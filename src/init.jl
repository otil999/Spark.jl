function init()
    envcp = get(ENV, "CLASSPATH", "")
    hadoopConfDir = get(ENV, "HADOOP_CONF_DIR", "")
    yarnConfDir = get(ENV, "YARN_CONF_DIR", "")
    emrfslib = @static is_windows() ? "" :
      "/usr/share/aws/emr/emrfs/lib/*:" *
      "/usr/share/aws/emr/hadoop-state-pusher/lib/hadoop-common-2.7.2-amzn-1.jar"

    sparkjlassembly = joinpath(dirname(@__FILE__), "..", "jvm", "sparkjl", "target", "sparkjl-0.1-assembly.jar")

    classpath_array = String[envcp, sparkjlassembly, hadoopConfDir, yarnConfDir, emrfslib]
    filter!(e -> e != "", classpath_array)
    separator = @static is_windows() ? ";" : ":"
    classpath = reduce((x, y) -> x * separator * y, classpath_array)

    try
        println("JVM starting from init.jl")
        # prevent exceptions in REPL on code reloading

        # JVM start in debug mode
        #JavaCall.init(["-ea", "-Xmx1024M", "-Djava.class.path=$classpath", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4000"])

        #JVM default start
        JavaCall.init(["-ea", "-Xmx6144M", "-cp $classpath", "-Djava.class.path=$classpath"])
    end
end

init()
