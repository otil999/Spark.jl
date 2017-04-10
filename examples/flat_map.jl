using Spark

sc = SparkContext(master="local", appname="flat_map Example")

rdd = parallelize(sc, [1,2,0,3])
mappedRdd = flat_map(rdd, item -> fill(it, it))
result  = collect(mappedRdd)

println("\n This is the result: $result \n")

close(sc)
