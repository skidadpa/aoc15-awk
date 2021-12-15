#!/usr/bin/env awk -f
BEGIN { xadd[">"] = 1; xadd["<"] = -1; yadd["^"] = 1; yadd["v"] = -1 }
(NF != 1) { print "ERROR: bad input"; exit 1 }
{
    x = y = 0
    n = split($1, moves, "")
    split("", houses)
    ++houses[x,y]
    for (i in moves) {
        x += xadd[moves[i]]
        y += yadd[moves[i]]
        ++houses[x,y]
    }
    print length(houses)
}
