# test of text_file
sc = SparkContext(master="local")

txt = text_file(sc, "file://" * @__FILE__)
nums  = map(txt, it -> length(it))

@test reduce(nums, +) == 165

close(sc)
