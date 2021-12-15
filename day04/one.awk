#!/usr/bin/env awk -f
@load "./md5"
{
    for (i = 1; i < 99999999; ++i) if (substr(md5($0 i), 1, 5) == "00000") {
        print i
        next
    }
    print $0, "NOT FOUND"
}
