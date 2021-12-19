#!/usr/bin/env awk -f
(NF != 1 || $0 !~ /^[0-9]+$/) { print "DATA ERROR"; exit _exit=1 }
{ jar[NR] = $1 }
function permute(combos, selected, total, jars,    count, i, nxt, left) {
    count = 0
    if (length(jars) < 0) return 0
    if (length(jars) == 1) for (i in jars) {
        if (total + jars[i] == 150) {
            combos[selected i] = 1
            ++count
        }
        return count
    }
    for (nxt in jars) {
        if (total + jars[nxt] == 150) {
            combos[selected nxt] = 1
            ++count
        } else if (total + jars[nxt] < 150) {
            split("", left)
            for (i in jars) if (i > nxt) left[i] = jars[i]
            count += permute(combos, selected nxt SUBSEP, total + jars[nxt], left)
        }
    }
    return count
}
END {
    if (_exit) exit
    permute(combinations, "", 0, jar)
    for (c in combinations) {
        n = split(c, selected, SUBSEP)
        # print gensub(SUBSEP, ",", "g", c), ":", n
        if (n == min) ++count;
        else if (!count || n < min) {
            min = n
            count = 1
        }
    }
    print count
}
