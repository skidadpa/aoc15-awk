#!/usr/bin/env awk -f
(NF < 4 || NF > 5) { print "ERROR: bad input"; exit 1 }
(NF == 4) {
    f = split($2, from, ","); t = split($4, to, ",")
    if ($1 != "toggle" || $3 != "through" || f != 2 || t != 2) {
        print "ERROR: bad input"; exit 1
    }
    for (x = from[1]; x <= to[1]; ++x)
        for (y = from[2]; y <= to[2]; ++y)
            if ((x,y) in grid) delete grid[x,y]; else grid[x,y] = 1
}
(NF == 5) {
    f = split($3, from, ","); t = split($5, to, ",")
    if ($1 != "turn" || $4 != "through" || f != 2 || t != 2) {
        print "ERROR: bad input"; exit 1 
    }
    if ($2 == "on") {
        for (x = from[1]; x <= to[1]; ++x)
            for (y = from[2]; y <= to[2]; ++y)
                grid[x,y] = 1
    } else if ($2 == "off") {
        for (x = from[1]; x <= to[1]; ++x)
            for (y = from[2]; y <= to[2]; ++y)
                delete grid[x,y]
    } else { print "ERROR: bad input"; exit 1 }
}
END {
    print length(grid)
}
