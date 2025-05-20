module MonteCarloPi

export serial_pi

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

end # module MonteCarloPi
