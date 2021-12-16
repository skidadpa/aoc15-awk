#!/usr/bin/env awk -f
(NF != 1 || $1 !~ /^".*"$/ || $1 ~ /[^\\]"./ ) { print "ERROR: bad input"; exit 1 }
{
    literals += length()
    $0 = substr($0, 2, length() - 2)
    gsub(/\\\\/, "@")
    gsub(/\\x../, "@")
    gsub(/\\"/, "@")
    memory += length()
}
END { print literals - memory }
