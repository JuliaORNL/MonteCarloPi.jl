import MonteCarloPi

ENV["JULIA_EXCLUSIVE"]="1"

function julia_main()::Cint
    if length(ARGS) != 1
        println("Usage: julia serialPi-run.jl <n_samples>")
        return
    end

    n_samples = parse(Int64, ARGS[1])

    # Warmup call
    MonteCarloPi.serial_pi(10)

    @time pi_value_ref = MonteCarloPi.serial_pi(n_samples)
    println("Ref estimated value of Pi: ", pi_value_ref)

    # Warmup call
    MonteCarloPi.jacc_pi_atomic(10)

    @time pi_value_atomic = MonteCarloPi.jacc_pi_atomic(n_samples)
    println("JACC atomic estimated value of Pi: ", pi_value_atomic)

    @time pi_value_jacc = MonteCarloPi.jacc_pi(n_samples)
    println("JACC estimated value of Pi: ", pi_value_jacc)
    return 0
end

if !isdefined(Base, :active_repl)
    julia_main()
end
