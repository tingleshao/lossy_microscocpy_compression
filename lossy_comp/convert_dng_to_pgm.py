
import os
for i in xrange(1,126):
  files = [f for f in os.listdir("./frame_"+str(i))]
  print files
  for f in files:
    os.system("./dcraw -d " + "./frame_" + str(i) + "/" + f)
