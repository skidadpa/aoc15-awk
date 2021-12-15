#!/usr/bin/env awk -f
(NF != 1) { print "ERROR: bad input"; exit 1 }
{ down = gsub(/)/, ""); print length($0) - down }
