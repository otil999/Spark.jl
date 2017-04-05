using Spark

sc = SparkContext(master="local", appname="Parallelize Example")

rdd = parallelize(sc, [1,2,3,4])
result = reduce(rdd, *)

println("\n This is the result : $result \n")

close(sc)
