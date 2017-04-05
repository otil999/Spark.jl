using Spark

sc = SparkContext(master="local", appname="Map Example")

rdd = parallelize(sc, [[1,"a"],[2,"b"],[3,"c"],[4,"d"]])
mappedRdd = flat_map(rdd, item -> item[2])
result  = collect(mappedRdd)

println("\n This is the result: $result \n")

close(sc)
