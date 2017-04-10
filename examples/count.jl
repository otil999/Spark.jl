using Spark

sc = SparkContext(master="local", appname="Count Example")

rdd = parallelize(sc, [0,1,2,3])
result  = count(rdd)

println("\n This is the result: $result \n")

close(sc)
