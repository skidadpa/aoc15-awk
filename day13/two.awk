#!/usr/bin/env awk -f
BEGIN { FS = "[\\. ]" }
(NF != 12 || $0 !~ /would ((gain)|(lose)) [0-9]+ happiness units by sitting next to/) {
    print "DATA ERROR"; exit _exit=1
}
function permute(arrangements, arrangement, items,    remaining, count) {
    if (length(items) == 1) for (item in items) {
        arrangements[arrangement item] = 0
        return 1
    }
    for (nxt in items) {
        split("", remaining)
        for (item in items) if (item != nxt) remaining[item] = 1
        count += permute(arrangements, arrangement nxt SUBSEP, remaining)
    }
    return count
}
{
    happiness[$1] = happiness[$11] = 0
    delta[$1,$11] = ($3 == "lose") ? -($4+0) : $4+0
}
END {
    if (_exit) exit
    if ("Santa" in happiness) { print "CODE ERROR"; exit _exit=1 }
    for (person in happiness) delta["Santa",person] = delta[person,"Santa"] = 0
    happiness["Santa"] = 0
    permute(seating, "", happiness)
    for (s in seating) {
        n = split(s, g, SUBSEP)
        for (i = 1; i < n; ++i) seating[s] += delta[g[i],g[i+1]] + delta[g[i+1],g[i]]
        seating[s] += delta[g[1],g[n]] + delta[g[n],g[1]]
        # print gensub(SUBSEP, ",", "g", s), ":", seating[s]
        if (!max || seating[s] > seating[max]) max = s
    }
    print seating[max]
}
