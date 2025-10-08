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
## Copyright 2013, Siemens AG, Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
## All Rights Reserved.

## Example server component to dynamically compare inter-release similarities
## for projects

get.release.distance.data <- function(con, name.list) {
  pid.list <- lapply(name.list, function(name) {
    return(projects.list[projects.list$name==name,]$id)
  })

  plot.ids <- lapply(pid.list, function(pid) {
    return(get.plot.id.con(con, pid, "Release TS distance"))
  })

  ts.list <- lapply(plot.ids, function(plot.id) {
    return(query.timeseries(con, plot.id))
  })

  name.list <- lapply(pid.list, function(pid) {
    return(query.project.name(con, pid))
  })

  # Filter out empty time series and ensure all vectors have the same length
  valid.indices <- which(sapply(ts.list, function(ts) {
    isTRUE(!is.null(ts)) && isTRUE(nrow(ts) > 0) && isTRUE(!is.null(ts$value)) && isTRUE(!is.null(ts$time))
  }))
  
  if (length(valid.indices) == 0) {
    # Return empty data frame with correct structure
    return(data.frame(project=character(0), distance=numeric(0), date=as.POSIXct(character(0))))
  }

  dat <- do.call(rbind, lapply(valid.indices, function(i) {
    ts <- ts.list[[i]]
    project.name <- name.list[[i]]
    
    # Ensure all vectors have the same length
    min.length <- min(length(ts$value), length(ts$time))
    if (min.length == 0) {
      return(data.frame(project=character(0), distance=numeric(0), date=as.POSIXct(character(0))))
    }
    
    data.frame(
      project=rep(project.name, min.length), 
      distance=ts$value[1:min.length],
      date=ts$time[1:min.length]
    )
  }))

  return(dat)
}

do.release.distance.plot <- function(con, names.list) {
  dat <- get.release.distance.data(con, names.list)

  # Handle empty data case
  if (nrow(dat) == 0) {
    g <- ggplot() + 
      geom_text(aes(x=0.5, y=0.5, label="No release distance data available"), size=5) +
      xlim(0, 1) + ylim(0, 1) +
      theme_void()
    return(g)
  }

  g <- ggplot(dat, aes(x=project, y=distance)) +
    geom_boxplot(outlier.colour="red") +
    geom_jitter(alpha=0.4, size=1.1) + xlab("Project") +
      ylab("Distribution of distance values")

  return(g)
}

createWidgetClass(
  "widget.release.distance",
  "Release distance",
  "Time distance of releases",
  c("construction"),
  size.x = 1,
  size.y = 1,
  compareable=TRUE,
  detailpage=list(app="dashboard", topic="construction")
)

renderWidget.widget.release.distance <- function(w) {
  renderPlot({
    project.idx <- which(projects.list$id == as.integer(w$pid()))
    projectname <- if (length(project.idx) > 0) {
      projects.list$name[[project.idx]]
    } else {
      paste("Project", w$pid())
    }
    if(is.null(w$pids.compare())) {
      compare.projectnames <- list()
      if (isTRUE(!is.null(w$name2)) && isTRUE(!is.null(w$name2()))) {
        compare.projectnames <- c(compare.projectnames, w$name2())
      }
      if (isTRUE(!is.null(w$name3)) && isTRUE(!is.null(w$name3()))) {
        compare.projectnames <- c(compare.projectnames, w$name3())
      }
    } else {
      compare.projectnames <- lapply(w$pids.compare(), function(pid) {
        return(projects.list[projects.list$id==pid,]$name)
      })
    }
    print(do.release.distance.plot(conf$con, c(projectname, compare.projectnames)))
  })
}

