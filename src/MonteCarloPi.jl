module MonteCarloPi

export serial_pi
export jacc_pi

import JACC
JACC.@init_backend

"""
  Serial Monte Carlo Pi calculation.
  - `n_samples` is the number of random points to sample.
"""
function serial_pi(::Type{T}, n_samples::Int64) where {T<:AbstractFloat}

    count = Int64(0)
    for i in 1:n_samples
        x = rand(T)
        y = rand(T)
        if x^2 + y^2 <= 1.0
            count += 1
        end
    end
    return 4.0 * count / n_samples
end

serial_pi(n_samples::Int64) = serial_pi(Float64, n_samples)

"""
  -----------------------------------------------------------------------------
  Parallel Monte Carlo Pi calculation.
  - `n_samples` is the number of random points to sample.
"""

function jacc_pi(::Type{T}, n_samples::Int64) where {T<:AbstractFloat}

    counts = JACC.zeros(Int64, n_samples)
    println("num CPU threads: ", Threads.nthreads())

    function calc(i, a)
        x = rand(T)
        y = rand(T)
        @inbounds a[i] = x^2 + y^2 <= 1.0 ? 1 : 0
    end

    # JACC.parallel_for(JACC.launch_spec(; threads = 1), n_samples, calc, counts
    JACC.parallel_for(n_samples, calc, counts)
    res = JACC.parallel_reduce(counts)
    return 4.0 * res / n_samples
end

jacc_pi(n_samples::Int64) = jacc_pi(Float64, n_samples)

"""
  -----------------------------------------------------------------------------
  Parallel + Atomic Monte Carlo Pi calculation.
  - `n_samples` is the number of random points to sample.
"""

function jacc_pi_atomic(::Type{T}, n_samples::Int64) where {T<:AbstractFloat}

    count = Int64(0)
    println("num CPU threads: ", Threads.nthreads())

    function calc(i, count)
        x = rand(T)
        y = rand(T)
        res = x^2 + y^2 <= 1.0 ? 1 : 0
        if res > 0
            @inbounds JACC.@atomic count[1] += 1
        end
    end
    JACC.parallel_for(n_samples, calc, count)
    return 4.0 * count / n_samples
end

jacc_pi_atomic(n_samples::Int64) = jacc_pi(Float64, n_samples)

end # module MonteCarloPi
