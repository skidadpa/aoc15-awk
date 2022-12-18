#!/usr/bin/env awk -f
BEGIN {
    FPAT = "[A-Z][a-z]?"
    DEBUG = 0
}
/^[A-Z][a-z]? => [A-Z]/ {
    r = ""
    for (i = 2; i <= NF; ++i) r = r $i
    forward[$1] = r
    backward[(11 - NF)/2][r] = $1
    next
}
/e => [A-Z]/ {
    r = $1
    for (i = 2; i <= NF; ++i) r = r $i
    targets[r] = 1
    next
}
/=>/ { print "DATA ERROR"; exit _exit=1 }
(NF > 0) {
    # for (i in backward) {
    #     for (r in backward[i]) {
    #         print i, backward[i][r], "=>", r
    #     }
    # }
    for (level = 2; level <= 18; ++level) {
        if (DEBUG) print "Calculating level", level, "forward moves"
        prev_level = level - 1
        split("", next_targets)
        for (target in targets) if (targets[target] == prev_level) {
            for (source in forward) {
                prefix = ""
                suffix = target
                while (pos = index(suffix, source)) {
                    prefix = prefix substr(suffix, 1, pos - 1)
                    suffix = substr(suffix, pos + length(source))
                    next_targets[prefix forward[source] suffix] = level
                    prefix = prefix source
                }
            }
        }
        for (target in next_targets) {
            if (!(target in targets)) {
                targets[target] = next_targets[target]
            }
        }
    }
    element = $0
    matched = 1
    substitutions = 0
    while (matched) {
        for (l in backward) {
            for (target in backward[l]) {
                matched = sub(target, backward[l][target], element)
                substitutions += matched
                if (DEBUG && matched) print substitutions, ":", element
                if (matched) break
            }
            if (matched) break
        }
        if (element in targets) {
            substitutions += targets[element]
            element = "e"
            matched = 0
        }
    }
    print "After", substitutions, "substitutions, reached", element
}
