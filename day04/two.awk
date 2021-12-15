#!/usr/bin/env awk -f
@load "./md5"
{
    for (i = 1; i < 999999999; ++i) if (substr(md5($0 i), 1, 6) == "000000") {
        print i
        next
    }
    print $0, "NOT FOUND"
}
