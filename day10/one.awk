#!/usr/bin/env awk -f
(NF != 1) { print "DATA ERROR"; exit 1 }
function look_and_say(input,    seq, n, nxt, i, j) {
    n = split(input, seq, "")
    nxt = ""
    i = 1
    while (i <= n) {
        for (j = i + 1; seq[i] == seq[j]; ++j) { }
        nxt = nxt (j - i) seq[i]
        # for (D = 1; D < i; ++D) printf(" "); while (D++ < j) printf("^")
        # print "<-" (j - i) seq[i]
        i = j
    }
    # print nxt
    return nxt
}
{
    # print
    for (step = 1; step <= 40; ++step) $0 = look_and_say($0)
    print length($0)
}
