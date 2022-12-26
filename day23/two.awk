#!/usr/bin/env awk -f
BEGIN {
    FPAT="([a-z]+)|([-+][[:digit:]]+)"
    REG["a"] = 1
    REG["b"] = 0
    IP = 1
    DEBUG = 0
    if (DEBUG) {
        print "PROGRAM:"
    }
}
/^hlf [ab]$/ || /^tpl [ab]$/ || /^inc [ab]$/ {
    OP[NR] = $1
    OP_REG[NR] = $2
    if (DEBUG) print NR, ":", $1, $2, "(arithmetic operation)"
    next
}
/^jmp [-+][[:digit:]]+/ {
    OP[NR] = $1
    OP_OFF[NR] = $2
    if (DEBUG) print NR, ":", $1, $2, "(unconditional jump)"
    next
}
/^jie [ab], [-+][[:digit:]]+/ || /^jio [ab], [-+][[:digit:]]+/ {
    OP[NR] = $1
    OP_REG[NR] = $2
    OP_OFF[NR] = $3
    if (DEBUG) print NR, ":", $1, $2, $3, "(conditional jump)"
    next
}
{
    print "DATA ERROR"
    exit _exit=1
}
END {
    if (_exit) {
        exit _exit
    }
    while (IP <= NR) {
        jumping = 0
        if (DEBUG) printf("Executing %d : %s %s %s ... ", IP, OP[IP], OP_REG[IP], OP_OFF[IP])
        switch (OP[IP]) {
        case "hlf":
            REG[OP_REG[IP]] /= 2
            break
        case "tpl":
            REG[OP_REG[IP]] *= 3
            break
        case "inc":
            ++REG[OP_REG[IP]]
            break
        case "jmp":
            jumping = 1
            break
        case "jie":
            jumping = (REG[OP_REG[IP]] % 2 == 0)
            break
        case "jio":
            jumping = (REG[OP_REG[IP]] == 1)
            break
        default:
            print "PROCESSING ERROR"
            exit _exit=1
        }
        if (jumping) {
            IP += OP_OFF[IP]
        } else {
            ++IP
        }
        if (DEBUG) print " IP =", IP, "A =", REG["a"], "B =", REG["b"]
    }
    if (DEBUG) print "stopped at IP =", IP, "A =", REG["a"], "B =", REG["b"]
    print REG["b"]
}
