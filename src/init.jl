function init(dict::Dict)
    envcp = get(ENV, "CLASSPATH", "")
    hadoopConfDir = get(ENV, "HADOOP_CONF_DIR", "")
    yarnConfDir = get(ENV, "YARN_CONF_DIR", "")
    emrfslib = "/usr/share/aws/emr/emrfs/lib/aopalliance-1.0.jar:/usr/share/aws/emr/emrfs/lib/bcpkix-jdk15on-1.51.jar:/usr/share/aws/emr/emrfs/lib/bcprov-jdk15on-1.51.jar:/usr/share/aws/emr/emrfs/lib/emrfs-hadoop-assembly-2.15.0.jar:/usr/share/aws/emr/emrfs/lib/javax.inject-1.jar:/usr/share/aws/emr/emrfs/lib/jcl-over-slf4j-1.7.21.jar:/usr/share/aws/emr/emrfs/lib/slf4j-api-1.7.21.jar:/usr/share/aws/emr/hadoop-state-pusher/lib/hadoop-common-2.7.2-amzn-1.jar"
    sparkjlassembly = joinpath(dirname(@__FILE__), "..", "jvm", "sparkjl", "target", "sparkjl-0.1-assembly.jar")
    classpath = @static is_windows() ? "$envcp;$sparkjlassembly;" : "$envcp:$sparkjlassembly"
    classpath = "$classpath:$hadoopConfDir:$yarnConfDir:$emrfslib"
    try
        println("JVM starting from init.jl")
        # prevent exceptions in REPL on code reloading

        # JVM start in debug mode
        #JavaCall.init(["-ea", "-Xmx1024M", "-Djava.class.path=$classpath", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4000"])

        #JVM default start
		driverMemory = get(dict, "spark.driver.memory", "1024M")
        JavaCall.init(["-ea", "-Xmx"*driverMemory, "-cp $classpath", "-Djava.class.path=$classpath"])
    end
end

#init()
