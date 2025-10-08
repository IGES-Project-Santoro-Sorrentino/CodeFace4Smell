## This file is part of Codeface. Codeface is free software: you can

# Load required libraries
suppressPackageStartupMessages(library(lubridate))
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

## Helper functions for constructing release boundary information

prepare.release.boundaries <- function(conf) {
  res <- get.cycles.con(conf$con, conf$pid, boundaries=T)

  date.columns <- c("date.start", "date.end", "date.rc.start")
  for (col in date.columns) {
    # Check if the column is already POSIXct
    if (!inherits(res[, col], "POSIXct")) {
      # Try parsing as datetime string first
      if (is.character(res[, col])) {
        parsed <- ymd_hms(res[, col], quiet=TRUE)
        if (!any(is.na(parsed))) {
          res[, col] <- parsed
        } else {
          # Fall back to Unix timestamp conversion
          res[, col] <- as.POSIXct(res[, col], origin="1970-01-01")
        }
      } else {
        # Fall back to Unix timestamp conversion
        res[, col] <- as.POSIXct(res[, col], origin="1970-01-01")
      }
    }
  }

  return(res)
}
