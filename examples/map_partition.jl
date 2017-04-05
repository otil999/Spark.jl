using Spark

sc = SparkContext(master="local", appname="MapPartition Example")

rdd = parallelize(sc, [1,2,3,4], n_split=2)
mappedRdd = map_partitions(rdd, partition -> mean(partition))
result  = collect(mappedRdd)

print("\n This is the result : $result \n")

close(sc)
