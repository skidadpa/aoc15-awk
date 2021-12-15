#!/usr/bin/env awk -f
(NF < 4 || NF > 5) { print "ERROR: bad input"; exit 1 }
(NF == 4) {
    f = split($2, from, ","); t = split($4, to, ",")
    if ($1 != "toggle" || $3 != "through" || f != 2 || t != 2) {
        print "ERROR: bad input"; exit 1
    }
    for (x = from[1]; x <= to[1]; ++x)
        for (y = from[2]; y <= to[2]; ++y)
            grid[x,y] += 2
}
(NF == 5) {
    f = split($3, from, ","); t = split($5, to, ",")
    if ($1 != "turn" || $4 != "through" || f != 2 || t != 2) {
        print "ERROR: bad input"; exit 1 
    }
    if ($2 == "on") {
        for (x = from[1]; x <= to[1]; ++x)
            for (y = from[2]; y <= to[2]; ++y)
                ++grid[x,y]
    } else if ($2 == "off") {
        for (x = from[1]; x <= to[1]; ++x)
            for (y = from[2]; y <= to[2]; ++y)
                if (--grid[x,y] < 1) delete grid[x,y]
    } else { print "ERROR: bad input"; exit 1 }
}
END {
    for (e in grid) brightness += grid[e]
    print brightness
}
