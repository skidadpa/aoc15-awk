#!/usr/bin/env awk -f
BEGIN { FS = "x" }
(NF != 3) { print "ERROR: bad input"; exit 1 }
{
    side[1] = $1 * $2; side[2] = $2 * $3; side[3] = $3 * $1
    area = 9999999999
    for (i in side) if (side[i] < area) area = side[i]
    for (i in side) area += 2 * side[i]
    total += area
}
END { print total }
