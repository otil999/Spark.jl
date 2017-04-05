using Spark

sc = SparkContext(master="local", appname="MapPartitionWithIndex Example")

rdd = parallelize(sc, [1,1,2,2,3,3], n_split=3)
mappedRdd = map_partitions_with_index(rdd, (index, partition) -> index * mean(partition))
result  = collect(mappedRdd)

println("\n This is the result : $result \n")
close(sc)
