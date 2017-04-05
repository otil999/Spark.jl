using Spark

sc = SparkContext(master="local", appname="Map Example")

rdd = parallelize(sc, [1,2,3,4])
mappedRdd = map(rdd, item -> item * item)
result  = collect(mappedRdd)

println("\n This is the result : $result \n")
close(sc)
