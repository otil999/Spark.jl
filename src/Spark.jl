module Spark

    module Worker
        import ..Spark
        export dump_stream,
               readobj
        include("worker.jl")
        include("serialization.jl")
    end

import .Worker

export SparkConfig,
       SparkConf,
       SparkContext,
       RDD,
       JuliaRDD,
       JavaRDD,
       text_file,
       parallelize,
       map,
       map_pair,
       map_partitions,
       map_partitions_pair,
       map_partitions_with_index,
       reduce,
       collect,
       count,
       id,
       num_partitions,
       close,
       @attach,
       share_variable,
       @share,
       flat_map,
       flat_map_pair,
       cartesian,
       group_by_key,
       reduce_by_key,
       cache,
       repartition,
       coalesce,
       pipe

include("core.jl")

end
