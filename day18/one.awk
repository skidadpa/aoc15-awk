#!/usr/bin/env awk -f
(NF != 1 || $0 !~ /^[.#]+$/) { print "DATA ERROR"; exit _exit=1 }
function join(array, start, end, sep,    result, i) {
    if (sep == "") sep = " "; else if (sep == SUBSEP) sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++) result = result sep array[i]
    return result
}
{
    n = split($1, row, "")
    if (!xmax) xmax = n; else if (xmax != n) { print "DATA ERROR"; exit _exit=1 }
    for (x in row) grid[0][x,NR] = row[x]
}
function dump(level,    y, x) {
    printf("\n")
    for (y = 1; y <= ymax; ++y) {
        for (x = 1; x <= xmax; ++x) printf("%s",grid[level][x,y]);
        printf("\n")
    }
}
function compute(level,    y, x, count) {
    for (y = 1; y <= ymax; ++y) for (x = 1; x <= xmax; ++x) {
        count = grid[level-1][x-1,y-1] == "#" ? 1 : 0
        if (grid[level-1][x,y-1] == "#") ++count
        if (grid[level-1][x+1,y-1] == "#") ++count
        if (grid[level-1][x-1,y] == "#") ++count
        if (grid[level-1][x+1,y] == "#") ++count
        if (grid[level-1][x-1,y+1] == "#") ++count
        if (grid[level-1][x,y+1] == "#") ++count
        if (grid[level-1][x+1,y+1] == "#") ++count
        if (count == 3) grid[level][x,y] = "#"
        else if (count == 2 && grid[level-1][x,y] == "#") grid[level][x,y] = "#"
        else grid[level][x,y] = "."
    }
}
END {
    if (_exit) exit
    ymax = NR
    step = 0
    nsteps = 100
    # dump(0)
    for (step = 1; step <= nsteps; ++step) {
        compute(step)
        # dump(step)
    }
    # dump(nsteps)
    on = 0
    for (y = 1; y <= ymax; ++y) for (x = 1; x <= xmax; ++x) if (grid[nsteps][x,y] == "#") ++on
    print on
}
