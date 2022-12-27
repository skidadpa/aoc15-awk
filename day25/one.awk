#!/usr/bin/env awk -f
BEGIN {
    FPAT = "[[:digit:]]+"
    DEBUG = 0
}
function code(n,   i, c) {
    c = 20151125
    for (i = 1; i < n; ++i) {
        c = (c * 252533) % 33554393
    }
    return c
}
function code_index(row, col,   n, i) {
    n = 0
    for (i = 1; i <= col; ++i) { n += i }
    for (i = 0; i < row - 1; ++i) { n += col + i }
    if (DEBUG) { print "code is at index", n }
    return n
}
$0 !~ /^To continue, please consult the code grid in the manual\.  Enter the code at row [[:digit:]]+, column [[:digit:]]+\.$/ {
    print "DATA ERROR"
    exit _exit=1
}
{
    if (DEBUG) { print "code is at row", $1, "col", $2 }
    print code(code_index($1, $2))
}
END {
    if (_exit) {
        exit _exit
    }
}
