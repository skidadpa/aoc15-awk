#!/usr/bin/env awk -f
BEGIN {
    matchrules = "children: 3\ncats: 7\nsamoyeds: 2\npomeranians: 3\n\
akitas: 0\nvizslas: 0\ngoldfish: 5\ntrees: 3\ncars: 2\nperfumes: 1"
    split(matchrules, rulelines, "\n")
    for (r in rulelines) {
        split(rulelines[r], ruleline, ": ")
        matches[ruleline[1]] = ruleline[2]
    }
    greatercheck["cats"] = greatercheck["trees"] = 1
    lessercheck["pomeranians"] = lessercheck["goldfish"] = 1
    FS = "((: )|(, ))"
}
(NF != 7) { print "DATA ERROR"; exit _exit=1 }
function check(field, value) {
    if (field in greatercheck)
        return value > matches[field]
    else if (field in lessercheck)
        return value < matches[field]
    else
        return value == matches[field]
}
{ if (check($2, $3) && check($4, $5) && check($6, $7)) print $1 }
