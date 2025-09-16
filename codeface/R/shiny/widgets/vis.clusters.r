#! /usr/bin/env Rscript

## This file is part of Codeface. Codeface is free software: you can
## redistribute it and/or modify it under the terms of the GNU General Public
## License as published by the Free Software Foundation, version 2.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
##
## Copyright 2013 by Siemens AG, Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
## All Rights Reserved.

detailpage <- list(name="widget.clusters.clusters,widget.clusters.correlations,widget.clusters.summary",
                   title="Collaboration Clusters")

source("../../clusters.r")

## Create overviews about the types of collaboration graphs appearing in
## projects.

gen.clusters.list <- function(l, con) {
  # Check if we have valid cluster IDs
  if (is.null(l) || length(l) == 0) {
    return(list())
  }
  
  clusters.list <- lapply(1:length(l), function(i) {
    cluster.id <- l[[i]]
    
    # Check if cluster.id is valid
    if (is.null(cluster.id) || is.na(cluster.id) || cluster.id == "") {
      return(NULL)
    }
    
    tryCatch({
      g <- construct.cluster(con, cluster.id)
      
      # Check if we got a valid graph
      if (is.null(g)) {
        return(NULL)
      }

      ## Self-loops in the proximity analysis can become very strong;
      ## the resulting edges then typically destroy the visualisation
      ## completely. Get rid of them, thus.
      ## NOTE: simplify must be called before the cluster is annotated
      ## because the function
      g <- simplify(g, remove.loops=TRUE)
      
      # Check if graph still has vertices after simplification
      if (vcount(g) == 0) {
        return(NULL)
      }

      return(g)
    }, error = function(e) {
      logwarn(paste("Error processing cluster", cluster.id, ":", e$message))
      return(NULL)
    })
  })

  ## Remove empty clusters
  clusters.list[sapply(clusters.list, is.null)] <- NULL

  # Only annotate if we have clusters
  if (length(clusters.list) > 0) {
    clusters.list <- lapply(clusters.list, function(g) {
      tryCatch({
        return(annotate.cluster(g))
      }, error = function(e) {
        logwarn(paste("Error annotating cluster:", e$message))
        return(g)  # Return unannotated graph if annotation fails
      })
    })
  }

  return(clusters.list)
}

do.plot <- function(g) {
  V(g)$name <- NA
  plot(g)
}

prepare.clusters <- function(con, pid, range.id) {
  tryCatch({
    l <- query.cluster.ids.con(con, pid, range.id, "Spin Glass Community")
    
    # Check if we have any cluster IDs
    if (is.null(l) || length(l) == 0) {
      logwarn(paste("No cluster IDs found for project", pid, "range", range.id))
      return(list())
    }
    
    clusters.list <- gen.clusters.list(l, con)
    
    # Check if we have any valid clusters
    if (is.null(clusters.list) || length(clusters.list) == 0) {
      logwarn(paste("No valid clusters found for project", pid, "range", range.id))
      return(list())
    }

    ## Sort the clusters by number of vertices
    sizes <- sapply(clusters.list, vcount)
    clusters.list <- clusters.list[sort(sizes, index.return=TRUE, decreasing=TRUE)$ix]

    max.length <- 8
    if (length(clusters.list) < max.length) {
      max.length <- length(clusters.list)
    }

    return(clusters.list[1:max.length])
  }, error = function(e) {
    logwarn(paste("Error preparing clusters for project", pid, "range", range.id, ":", e$message))
    return(list())
  })
}

do.cluster.plots <- function(clusters.list) {
  if (is.null(clusters.list) || length(clusters.list) == 0) {
    # No clusters available - show empty plot with message
    plot(1, type="n", xlab="", ylab="", main="No collaboration clusters available", 
         xlim=c(0,1), ylim=c(0,1), axes=FALSE)
    text(0.5, 0.5, "No collaboration data found for this project", cex=1.2)
    return()
  }
  
  par(mfcol=c(2,4))
  for (i in 1:length(clusters.list)) {
    if (!is.null(clusters.list[[i]])) {
      do.plot(clusters.list[[i]])
    }
  }
}

gen.cluster.info <- function(g) {
  return(data.frame(Reciprocity=g$rec, Strength=g$strength,
                    Degree=g$deg.graph, Size=g$size,
                    Cent.degree=g$cent.deg, Cent.closeness=g$cent.clo,
                    Cent.betweenness=g$cent.bet, Cent.eigenvec=g$cent.evc))
}

gen.cluster.summary <- function(clusters.list) {
  res <- lapply(1:length(clusters.list), function(i) {
    df <- gen.cluster.info(clusters.list[[i]])
    cbind(ID=i, df)
  })

  return(do.call(rbind, res))
}

createWidgetClass(
  c("widget.clusters.clusters", "widget.clusters", "widget.rangeid"),
  "Clusters",
  "Developer collaboration Clusters",
  c("collaboration"),
  2, 1,
  detailpage=detailpage
)

initWidget.widget.clusters <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$cluster.list <- reactive({prepare.clusters(conf$con, w$pid(), w$view())})
  return(w)
}

renderWidget.widget.clusters.clusters <- function(w) {
  renderPlot({
    clusters <- w$cluster.list()
    do.cluster.plots(clusters)
  }, height=1024, width=2048)
}

createWidgetClass(
  c("widget.clusters.correlations", "widget.clusters", "widget.rangeid"),
  "Cluster Correlations",
  "Cluster Correlations",
  c("collaboration"),
  detailpage=detailpage
)

initWidget.widget.clusters.correlations <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$dat <- reactive({
    dat <- gen.cluster.summary(w$cluster.list())
    dat <- dat[,c("Reciprocity", "Strength", "Degree", "Size",
                  "Cent.degree", "Cent.closeness", "Cent.betweenness",
                  "Cent.eigenvec")]
    dat
  })
  return(w)
}

renderWidget.widget.clusters.correlations <- function(w) {
  renderPlot({
    dat <- w$dat()
    if (is.null(dat) || nrow(dat) == 0) {
      # No data available - show empty plot with message
      plot(1, type="n", xlab="", ylab="", main="No collaboration data available", 
           xlim=c(0,1), ylim=c(0,1), axes=FALSE)
      text(0.5, 0.5, "No collaboration clusters found for this project", cex=1.2)
      return()
    }
    corrgram(dat, order=FALSE, lower.panel=panel.shade, upper.panel=panel.pie,
              text.panel=panel.txt, main="")
  })
}

createWidgetClass(
  c("widget.clusters.summary", "widget.clusters", "widget.rangeid"),
  "Cluster Summary",
  "Tabular summary of clusters",
  c("collaboration"),
  3, 1,
  html=widget.tableOutput.html,
  detailpage=detailpage
)

renderWidget.widget.clusters.summary <- function(w, range.id=NULL) {
  renderTable({
    clusters <- w$cluster.list()
    if (is.null(clusters) || length(clusters) == 0) {
      return(data.frame(Message="No collaboration clusters found for this project"))
    }
    gen.cluster.summary(clusters)
  })
}

