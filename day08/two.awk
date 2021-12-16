#!/usr/bin/env awk -f
(NF != 1 || $1 !~ /^".*"$/ || $1 ~ /[^\\]"./ ) { print "ERROR: bad input"; exit 1 }
{
    literals += length()
    gsub(/\\/, "\\\\")
    gsub(/"/, "\\\"")
    $0 = "\"" $0 "\""
    encoded += length()
}
END { print encoded - literals }
