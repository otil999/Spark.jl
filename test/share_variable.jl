# tests the attach macro
a = 2

# test of basic funtionality

@share(sc, a)

txt = parallelize(sc, ["hello", "world"])
rdd = map(txt, it -> length(it) + a)

@test reduce(rdd, +) == 14
