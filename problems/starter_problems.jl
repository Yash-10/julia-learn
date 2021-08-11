# 1. Strang Matrix Problem
using LinearAlgebra
using Distributions

print("Enter value of n: ")
n = parse(Int32, chomp(readline()))

# ns = repeat([-2], n) # Repeat -2 "n" times

# Define a variable
variable = 10

a = Array{Int32}(undef, n, n)
for i in 1:n, j in 1:n
    if i == j
        a[i, j] = -2
    elseif i == j + 1 || j == i + 1
        a[i, j] = 1
    else
        a[i, j] = 0
    end
end
println(a)
#
# # 2. Factorial
function my_factorial(n::Int32)
    if n == 0
        return 1
    else
        return n * my_factorial(n-1)
    end
end

println(my_factorial(6)) # Works
println(my_factorial(15)) # Doesn't work

# New
function my_factorial(n::BigInt)
    x = one(n) # Define a variable that is of same type as n.
    if n == big(0)
        return 1 * x
    else
        return n * my_factorial(n-1) * x
    end
end

println(my_factorial(big(0)))
println(my_factorial(big(100)))

# 3. Binomial
function binomial_rv(n, p)
    arr = rand(n)
    count = zero(n) # Using `zero()` instead of 0 to match with the type of `n`.
    for i in 1:n
        if arr[i] > p
            count += 1
        end
    end
    return count
end
bs = [binomial_rv(10, 0.5) for j in 1:10]
println(bs)

# 4. Monte Carlo
function estimatePi(n)
    count = zero(n)
    for i in 1:n
        x = rand(Uniform(-1, 1))
        y = rand(Uniform(-1, 1))
        r = sqrt(x^2 + y^2)
        if r < 1
            count += 1
        end
    end
    # No need of return keyword here since the last value computed is returned by default.
    4 * count / n  # As n gets larger, answer comes closer to pi.
end

println(estimatePi(100))  # Slightly inaccurate estimate of pi
println(estimatePi(10000000))  # Good estimate of pi
