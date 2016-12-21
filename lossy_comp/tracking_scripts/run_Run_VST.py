# this script runs two scripts to compare the video spot tracker difference on a uncompressed video and a compressd video. 

import sys
import os
import getopt

__doc__ = '''this script has the following parameter:
-t specify the video (frame) file directory for initialize the trackers
-u specify the uncompressed video file directory
-c specify the compressed video file directory
-o specify the output csv file name with out the extension
-h print the doc
-r print the readme'''

# sample command line: 
# python run_Run_VST.py -t .../search.pgm -u ../uncompressed/frame0001.pgm -c ../compressed/frame0001.pgm -o out 

def process(arg):
    yield

def print_video_readme():
    print '''This is a script for running Run_VST and Run_VST_CompressCompare successivelly. \n'''

def run_tracking_test(cmd1, cmd2):
    os.system(cmd1)
    os.system(cmd2)

def main():
    out = "out"
    # parse command line options
    try:
        opts, args = getopt.getopt(sys.argv[1:], "rho:t:u:c:", ["help"])
    except getopt.error, msg:
        print msg
        print "for help use --help"
        sys.exit(2)
    # process options
    for o, a in opts:
        if o in ("-h", "--help"):
            print __doc__
            sys.exit(0)
        if o in ("-r"):
            print_video_readme()
	    sys.exit(0)
        if o in ("-t"):
            init_tracking_frame = a
        if o in ("-u"):
            uncompressed = a
        if o in ("-c"):
            compressed = a
        if o in ("-o"):
            out = a
    # process arguments
    for arg in args:
        process(arg) # process() is defined somewhere else
    cmd1 = "Run_VST4 " + init_tracking_frame + " " + uncompressed + " " + out 
    cmd2 = "Run_VST_CompressCompare4 " + init_tracking_frame + " " + compressed + " " + out
    run_tracking_test(cmd1,cmd2)


if __name__ == "__main__":
    main()
    
