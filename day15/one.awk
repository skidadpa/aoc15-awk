#!/usr/bin/env awk -f
BEGIN { FS = ": " }
(NF != 2 || $0 !~ \
/: capacity [-0-9]+, durability [-0-9]+, flavor [-0-9]+, texture [-0-9]+, calories [-0-9]+$/) {
    print "DATA ERROR"; exit _exit=1
}
{
    n = split($2, properties, ", "); if (n != 5) { print "DATA ERROR"; exit _exit=1 }
    for (p in properties) {
        n = split(properties[p], propval, " "); if (n != 2) { print "DATA ERROR"; exit _exit=1 }
        ingredients[$1][propval[1]] = propval[2]+0
    }
}
function join(array, start, end, sep,    result, i) {
    if (sep == "") sep = " "; else if (sep == SUBSEP) sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++) result = result sep array[i]
    return result
}
function find(allrecipes, recipe, items,    lines, n, l, line, tUsed, item, t, unused, count) {
    t = 0
    n = split(recipe, lines, ",")
    for (l = 1; l < n; ++l) {
        if (split(lines[l], line, ":") != 2) { print "CODE ERROR"; exit _exit=1 }
        tUsed += line[2]
    }
    if (length(items) == 1) for (item in items) {
        allrecipes[recipe item ":" (100 - tUsed)] = 0
        return 1
    }
    split("", unused)
    for (item in items) {
        if (length(unused) + 1 < length(items))
            unused[item] = 1
        else for (t = 0; t <= (100 - tUsed); ++t)
            count += find(allrecipes, recipe item ":" t ",", unused)
    }
    return count
}
END {
    if (_exit) exit
    for (i in ingredients) delete ingredients[i]["calories"]
    find(recipes, "", ingredients)

    for (recipe in recipes) {
        split("", score)
        split(recipe, lines, ",")
        for (l in lines) {
            if (split(lines[l], line, ":") != 2) { print "CODE ERROR"; exit _exit=1 }
            for (property in ingredients[line[1]])
                score[property] += line[2] * ingredients[line[1]][property]
        }
        total = 1
        for (p in score) total = score[p] > 0 ? total * score[p] : 0
        if (total > best) best = total
    }
    print best
}
