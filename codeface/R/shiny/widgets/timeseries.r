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

suppressPackageStartupMessages(library(scales))
source("../../ts_utils.r")

createWidgetClass(
  c("widget.timeseries.messages.per.day", "widget.timeseries"),
  "Messages per Day",
  "Number of messages on the mailing list per day",
  c("communication"),
  size.x = 2,
  size.y = 1,
  detailpage=list(app="timeseries", topic="communication")
)

initWidget.widget.timeseries.messages.per.day <- function(w) {
  # Note that this class 'derives' from "widget.timeseries.plots", which
  # means we can reuse the listViews command and use the initialization
  w$plots <- reactive({
    dbGetQuery(conf$con, str_c("SELECT id, name FROM plots WHERE projectId=", w$pid(), " AND releaseRangeId IS NULL AND name LIKE '%activity'"))
  })
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.timeseries.messages.per.day <- function(w) {
  renderPlot({
    plots_data <- w$plots()
    if (is.null(plots_data) || (nrow(plots_data) == 0)) {
      # No data available - show empty plot with message
      plot(1, type="n", xlab="Time", ylab="Messages per Day", 
           main="No mailing list data available", 
           xlim=c(0,1), ylim=c(0,1))
      text(0.5, 0.5, "No mailing list activity data found for this project", cex=1.2)
      return()
    }
    
    # Check if the selected view exists
    view_id <- w$view()
    if (is.null(view_id) || (!view_id %in% plots_data$id)) {
      # Use the first available plot if view is invalid
      view_id <- plots_data$id[1]
    }
    
    name <- plots_data$name[[which(plots_data$id == view_id)]]
    ts <- get.ts.data(conf$con, w$pid(), name)
    
    if (is.null(ts) || (nrow(ts) == 0)) {
      # No time series data available
      plot(1, type="n", xlab="Time", ylab="Messages per Day", 
           main="No time series data available", 
           xlim=c(0,1), ylim=c(0,1))
      text(0.5, 0.5, "No time series data found for this project", cex=1.2)
      return()
    }
    
    print(do.ts.plot(ts, w$boundaries(), name, "Messages per Day", w$smooth.or.def(), w$transform.or.def()))
  })
}

