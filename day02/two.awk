#!/usr/bin/env awk -f
BEGIN { FS = "x" }
(NF != 3) { print "ERROR: bad input"; exit 1 }
{
    side[1] = $1 + $2; side[2] = $2 + $3; side[3] = $3 + $1
    len = 9999999999
    for (i in side) if (2 * side[i] < len) len = 2 * side[i]
    len += $1 * $2 * $3
    total += len
}
END { print total }
