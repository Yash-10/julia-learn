# Suppose we want to calculate the integral: \theta = \(\int_{0}^{1} sqrt(1 - y^2) \,dy\).
# For demonstration and proof of concept, we could convert this integral = E[sqrt(1 - U^2)], where U is a uniformly distributed random variable.
# Uniform random variables can be easily simulated by a computer.

using Distributions;

sample_means = []

"""
n: No. of times the experiment must be repeated.
"""
function approx_integral(n)
    sampleMeans = []
    for i in 1:n
        for i in 1:100
            x = []
            append!(x, sqrt(1 - rand(Uniform(0, 1)) ^ 2))
        append!(sampleMeans, mean(x))
        end
    return mean(sampleMeans)
    end
end

# Do the experiment n >= 30 times.
for n in [30, 100, 10000, 1000000]
    approxValue = approx_integral(200)
    println("n = ", n)
    println("================")
    println("Expected: ", pi/4)
    println("Approximation: ", approxValue)
    print("\n")
end
    
"""
Output:

n = 30
================
Expected: 0.7853981633974483
Approximation: 0.7731090119129932

n = 100
================
Expected: 0.7853981633974483
Approximation: 0.7752292267973813

n = 10000
================
Expected: 0.7853981633974483
Approximation: 0.7770962471064391

n = 1000000
================
Expected: 0.7853981633974483
Approximation: 0.8121993763859061

"""
