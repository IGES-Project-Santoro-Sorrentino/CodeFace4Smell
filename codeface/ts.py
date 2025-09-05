#! /usr/bin/env python

# This file is part of Codeface. Codeface is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Copyright 2013 by Siemens AG, Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
# All Rights Reserved.

# Create time series from a sequence of VCS objects

import yaml
import os.path
from . import kerninfo
import pickle
import argparse
from datetime import datetime

from .VCS import gitVCS
from .commit_analysis import createCumulativeSeries, createSeries, \
    writeToFile, getSeriesDuration
from .dbmanager import DBManager, tstamp_to_sql

def doAnalysis(dbfilename, destdir, revrange=None, rc_start=None):
    try:
        pkl_file = open(dbfilename, 'rb')
        vcs = pickle.load(pkl_file)
        pkl_file.close()
    except (IOError, OSError) as e:
        # Handle missing or corrupted database files
        print("Warning: Could not load VCS analysis database {0}: {1}".format(dbfilename, str(e)))
        # Create a minimal time series result
        from .commit_analysis import TimeSeries
        if revrange:
            res = TimeSeries(revrange[0], revrange[1])
            res.start_date = 0
            res.end_date = 0
            res.rc_start_date = None
            return res
        else:
            # This shouldn't happen, but provide a fallback
            res = TimeSeries("unknown", "unknown")
            res.start_date = 0
            res.end_date = 0
            res.rc_start_date = None
            return res

    if revrange:
        sfx = "{0}-{1}".format(revrange[0], revrange[1])
    else:
        sfx = "{0}-{1}".format(vcs.rev_start, vcs.rev_end)

    try:
        res = createSeries(vcs, "__main__", revrange, rc_start)
        return res
    except Exception as e:
        print("Warning: Error creating time series for {0}: {1}".format(sfx, str(e)))
        # Create a minimal time series result
        from .commit_analysis import TimeSeries
        if revrange:
            res = TimeSeries(revrange[0], revrange[1])
            res.start_date = 0
            res.end_date = 0
            res.rc_start_date = None
            return res
        else:
            res = TimeSeries(vcs.rev_start, vcs.rev_end)
            res.start_date = 0
            res.end_date = 0
            res.rc_start_date = None
            return res

def writeReleases(dbm, tstamps, conf):
    pid = dbm.getProjectID(conf["project"], conf["tagging"])

    for tstamp in tstamps:
        dbm.doExec("UPDATE release_timeline SET date=%s WHERE " +
                   "projectId=%s AND type=%s AND tag=%s",
                   (tstamp_to_sql(int(tstamp[2])), pid, tstamp[0], tstamp[1]))
    dbm.doCommit()

def dispatch_ts_analysis(resdir, conf):
    dbpath = resdir
    destdir = os.path.join(dbpath, "ts")
    dbm = DBManager(conf)

    if not(os.path.exists(destdir)):
        os.mkdir(destdir)

    # Stage 1: Create the individual time series (and record all time
    # stamps for the boundaries)
    # NOTE: The time stamp information in the database is still incomplete
    # in this stage, it is written out _after_ this stage. So we must
    # not rely on the content of tstamps before that is done.
    tstamps = []
    for i in range(1, len(conf["revisions"])):
        dbfilename = os.path.join(dbpath, "{0}-{1}".format(conf["revisions"][i-1],
                                                           conf["revisions"][i]),
                                  "vcs_analysis.db")

        try:
            ts = doAnalysis(dbfilename, destdir,
                            revrange=[conf["revisions"][i-1], conf["revisions"][i]],
                            rc_start=conf["rcs"][i])

            if (i==1):
                tstamps.append(("release", conf["revisions"][i-1], ts.get_start()))

            if (ts.get_rc_start()):
                tstamps.append(("rc", conf["rcs"][i], ts.get_rc_start()))

            tstamps.append(("release", conf["revisions"][i], ts.get_end()))
            
        except Exception as e:
            print("Warning: Failed to process revision range {0}-{1}: {2}".format(
                conf["revisions"][i-1], conf["revisions"][i], str(e)))
            # Add minimal timestamps to prevent the analysis from failing completely
            if (i==1):
                tstamps.append(("release", conf["revisions"][i-1], 0))
            tstamps.append(("release", conf["revisions"][i], 0))

    ## Stage 2: Insert time stamps for all releases considered into the database
    writeReleases(dbm, tstamps, conf)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('resdir')
    parser.add_argument('conf_file')
    args = parser.parse_args()

    dispatch_ts_analysis(args.resdir, args.conf_file)
