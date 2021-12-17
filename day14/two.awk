#!/usr/bin/env awk -f
(NF != 15) { print "DATA ERROR"; exit _exit=1 }
($0 !~ / can fly [0-9]+ km\/s for [0-9]+ seconds, but then must rest for [0-9]+ seconds\./) {
    print "DATA ERROR"; exit _exit=1
}
{
    speed[$1] = $4
    duration[$1] = $7
    rest[$1] = $14
    distance[$1] = flytime[$1] = resttime[$1] = points[$1] = 0
}
END {
    if (_exit) exit
    for (i = 1; i <= 2503; ++i) {
        for (r in distance) {
            if (++flytime[r] <= duration[r]) distance[r] += speed[r];
            else if (++resttime[r] >= rest[r]) flytime[r] = resttime[r] = 0
            if (distance[r] > leader) leader = distance[r]
        }
        for (r in distance) if (distance[r] == leader) ++points[r]
    }
    for (r in points) if (!winner || points[r] > points[winner]) winner = r
    # for (r in distance) print r, points[r]
    # print winner
    print points[winner]
}
