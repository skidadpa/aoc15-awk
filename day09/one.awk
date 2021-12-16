#!/usr/bin/env awk -f
BEGIN { FS = " = " }
(NF != 2) { print "ERROR: bad input"; exit 1 }
{
    if (split($1, route, " to ") != 2) { print "DATA ERROR"; exit 1 }
    towns[route[1]] = towns[route[2]] = 1
    distance[route[1],route[2]] = distance[route[2],route[1]] = $2
}
function permute(path, visiting,    remaining) {
    if (length(visiting) == 1) for (town in visiting) {
        paths[path town] = 0
        return
    }
    for (town in visiting) {
        split("", remaining)
        for (visit in visiting) if (visit != town) remaining[visit] = 1
        permute(path town SUBSEP, remaining)
    }
}
END {
    npaths = length(towns) * (length(towns) - 1)
    if (length(distance) != npaths) { print "DATA ERROR"; exit 1 }
    permute("", towns)
    for (path in paths) {
        n = split(path, route, SUBSEP)
        for (i = 1; i < n; ++i) paths[path] += distance[route[i],route[i+1]]
        if (!shortest || paths[shortest] > paths[path]) shortest = path
        # print gensub(SUBSEP, " -> ", "g", path), ":", paths[path]
    }
    print paths[shortest]
}
