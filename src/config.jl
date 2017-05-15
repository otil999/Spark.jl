
type SparkConf
    jconf::JSparkConf
end

function SparkConf(;opts...)
    jconf = JSparkConf(())
    opts = Dict(opts)
    for (k, v) in opts
        jcall(jconf, "set", JSparkConf, (JString, JString), string(k), v)
    end
    spark_defaults(jconf)
    return SparkConf(jconf)
end
    

function Base.show(io::IO, conf::SparkConf)    
    print(io, "SparkConf()")
end


function Base.setindex!(conf::SparkConf, key::AbstractString, val::AbstractString)
    jcall(conf.jconf, "set", JSparkConf, (JString, JString), key, val)
end


function Base.getindex(conf::SparkConf, key::AbstractString)
    jcall(conf.jconf, "get", JString, (JString,), key)
end


function Base.get(conf::SparkConf, key::AbstractString, default::AbstractString)
    jcall(conf.jconf, "get", JString, (JString, JString), key, default)
end


function setmaster(conf::SparkConf, master::AbstractString)
    jcall(conf.jconf, "setMaster", JSparkConf, (JString,), master)
end


function setappname(conf::SparkConf, appname::AbstractString)
    jcall(conf.jconf, "setAppName", JSparkConf, (JString,), appname)
end


function isnotcomment(x)
    return !startswith("#", x)
end


function spark_defaults(jconf::JSparkConf)
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
      warn("spark-defaults.conf does not exist - skipping spark defaults!")
    end

    p = map(split, filter(isnotcomment, split(confText, '\n', keep=false) ) )
    for x in p
         jcall(jconf, "set", Spark.JSparkConf, (JString, JString), x[1], x[2])
    end
    return jconf
end

function setdeploy(conf::SparkConf, deploymode::AbstractString)
    jcall(conf.jconf, "set", JSparkConf, (JString, JString), "deploy-mode", deploymode)
end
