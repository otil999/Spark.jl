using Spark

sc = SparkContext(master="local", appname="Reduce Example")

path = "./resources/text.txt"
txt = text_file(sc, path)
rdd = map(txt, line -> length(split(line)))
result = reduce(rdd, +)

println("\n This is the result : $result \n")
close(sc)
