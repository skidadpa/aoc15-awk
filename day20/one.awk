#!/usr/bin/env awk -f
BEGIN {
    DEBUG = 0
}
(NF != 1) || ($0 !~ /^[[:digit:]]+$/) { print "DATA ERROR"; exit _exit=1 }
{
    N_HOUSES = $1/10
    for (e = 1; e <= N_HOUSES; ++e) for (h = e; h <= N_HOUSES; h += e) HOUSES[h] += e * 10
    if (DEBUG) for (h = 1; h <= N_HOUSES; ++h) printf("%d: %d\n",h, HOUSES[h])
    for (h = 1; h <= N_HOUSES; ++h) if (HOUSES[h] >= $1) break
    print h
}
