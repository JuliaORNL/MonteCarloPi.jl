
import MonteCarloPi

function julia_main()::Cint
    if length(ARGS) != 1
        println("Usage: julia serialPi-run.jl <n_samples>")
        return
    end

    n_samples = parse(Int64, ARGS[1])
    pi_value = MonteCarloPi.serial_pi(n_samples)
    println("Estimated value of Pi: ", pi_value)
    return 0
end

if !isdefined(Base, :active_repl)
    @time julia_main()
end