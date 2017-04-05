include("Person.jl")

using Spark

sc = SparkContext(master="local", appname="LoadCsv Example")

path = "./resources/persons.csv"
txt = text_file(sc, path)
rdd = map(txt, line -> Person(split(line, ',')[1], parse(Int64, split(line, ',')[2]), split(line, ',')[3]))
result = collect(rdd)

println("\n This is the result : $result \n")

close(sc)
