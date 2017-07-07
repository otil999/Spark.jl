
"Wrapper around JavaSparkContext"
type SparkContext
    jsc::JJavaSparkContext
    master::AbstractString
    appname::AbstractString
    tempdir::AbstractString
end

"""
Params:
 * master - address of application master. Currently only local and standalone modes
            are supported. Default is 'local'
 * appname - name of application
"""
function SparkContext(;master::AbstractString="local",
                      deploymode::AbstractString="client")
    props = read_spark_properties()
    dict = get_dictionary(props)
    Spark.init(dict)
    conf = SparkConf(props)
    setmaster(conf, master)
    setdeploy(conf, deploymode)
    jsc = JJavaSparkContext((JSparkConf,), conf.jconf)
    sc = SparkContext(jsc, master, dict["spark.app.name"], "")
    add_jar(sc, joinpath(dirname(@__FILE__), "..", "jvm", "sparkjl", "target", "sparkjl-0.1.jar"))
    return sc
end

function SparkContext(jsc::JJavaSparkContext)
    appname = jcall(jsc, "appName", JString, ())
    master = jcall(jsc, "master", JString, ())
    sc = SparkContext(jsc, master, appname, "")
    return sc
end

function get_dictionary(props::AbstractArray)
    dict = Dict()
    for entry in props
       dict[entry[1]] = entry[2]
    end
    return dict
end

function isnotcomment(x)
    return !startswith(x,"#")
end

function read_spark_properties()
      sconf = get(ENV, "SPARK_CONF_DIR", "")
      if sconf == ""
          shome =  get(ENV, "SPARK_HOME", "")
          if shome == "" ; return jconf; end
          sconf = joinpath(shome, "conf")
      end

      confText = ""

      try
        confText = readstring(joinpath(sconf, "spark-defaults.conf"))
      catch ex
        warn(ex)
        warn("Check your spark-defaults.conf is exist! Skip reading configs from spark-defaults.conf.")
      end

      return map(split, filter(isnotcomment, split(confText, '\n', keep=false) ) )
end

function get_temp_dir(sc::SparkContext)
    if sc.tempdir == ""
        sc.tempdir = mktempdir()
        x = deepcopy(sc.tempdir)
        atexit(()->rm(x, recursive=true))
    end
    return sc.tempdir
end

function Base.show(io::IO, sc::SparkContext)
    print(io, "SparkContext($(sc.master),$(sc.appname))")
end


"Close SparkContext"
function close(sc::SparkContext)
    jcall(sc.jsc, "close", Void, ())
end


"Add JAR file to SparkContext. Classes from this JAR will then be available to all tasks"
function add_jar(sc::SparkContext, path::AbstractString)
    jrdd = jcall(sc.jsc, "addJar", Void, (JString,), path)
end


"Add file to SparkContext. This file will be downloaded to each executor's work directory"
function add_file(sc::SparkContext, path::AbstractString)
    jrdd = jcall(sc.jsc, "addFile", Void, (JString,), path)
end


"Create RDD from a text file"
function text_file(sc::SparkContext, path::AbstractString)
    jrdd = jcall(sc.jsc, "textFile", JJavaRDD, (JString,), path)
    return JavaRDD(jrdd)
end


function default_parallelism(sc::SparkContext)
    scala_sc = jcall(sc.jsc, "sc", JSparkContext, ())
    return jcall(scala_sc, "defaultParallelism", jint, ())
end


function parallelize(sc::SparkContext, coll; n_split::Int=-1)
    n_split = n_split == -1 ? default_parallelism(sc) : n_split
    tmp_path, f = mktemp()
    Spark.dump_stream(f, coll)
    close(f)
    jrdd = jcall(JJuliaRDD, "readRDDFromFile", JJavaRDD,
                 (JJavaSparkContext, JString, jint),
                 sc.jsc, tmp_path, n_split)
    rm(tmp_path)
    JavaRDD(jrdd)
end
