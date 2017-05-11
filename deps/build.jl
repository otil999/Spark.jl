mvn = is_windows() ? "mvn.cmd" : "mvn"
which = is_windows() ? "where" : "which"

try
    run(`$which $mvn`)
catch
    error("Cannot find maven. Is it installed?")
end

profile = get(ENV, "SPARKJL_PROFILE", "")

cd("../jvm/sparkjl")

if isempty(profile)
    run(`$mvn clean package`)
else
    run(`$mvn -P$profile clean package`)
end
