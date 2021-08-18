using Printf

using Distributions
using GLM
using IterativeSolvers
using LinearAlgebra
using MultivariateStats
using Statistics
using Unitful


# MyRange Part 1:

# Part (i)
# Types cannot be redefined. So `MyRange` defined below cannot be redefined anywhere in this module.
struct MyRange
    start::Int
    step::Int
    stop::Int
end

function _MyRange(a::MyRange, i::Int)
    arr = a.start:a.step:a.stop
    return arr[i]
end

arr = MyRange(1, 2, 20)

# Checking
println(_MyRange(arr, 3)) # 5
println(_MyRange(arr, 10)) # 19

# Part (ii)

# Using the Julia array interface
# See https://docs.julialang.org/en/v1/manual/interfaces/#Indexing
function Base.getindex(a::MyRange, i::Int)
    for vals in enumerate(a.start:a.step:a.stop)
        if vals[1] == i
            return vals[2]
        end
    end
end

# Checking
println(arr[3]) # 5
println(arr[10]) # 19


# Part 2
# Lazy implementation of LinSpace.

# Ellipsis for varargs - variable number of arguments.
function Base.getindex(a::MyRange, i...)
    answer = Int[]
    for index in i
        push!(answer, a[index])
    end
    return answer
end

arr = MyRange(1, 2, 20)
println(arr[1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

# Checking with built-in `range`.
for value in range(1, stop=19, length=10)
    println(value)
end


# Part 3
struct UnitStepRange
    start::Int
    step::Int
    stop::Int
end



"""
x - The input value at which the interpolated value needs to be found.
start, step, stop - Parameters for the custom range type.
====
Handles the case where no interpolation is needed.
"""
function interpolate(x::Float64, start::Int, step::Int, stop::Int)
    arr = start:step:stop

    for ival in enumerate(arr)
        if ival[1] == x
            y = arr[ival[1]]
            return y
        elseif ival[1] > x
            y1 = arr[ival[1]-1] # first
            y2 = arr[ival[1]] # last
            x1 = floor(x)
            x2 = ceil(x)
            y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
            return y
        end
    end
end


# Linear Interpolation: y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)

# Call overload.
(c::UnitStepRange)(x::Float64) = interpolate(x, c.start, c.step, c.stop)
usr = UnitStepRange(1, 2, 10)

println("Interpolated value at 1.5 is $(usr(1.5))")
println("Interpolated value at 1.4 is $(usr(1.4))")
println("Interpolated value at 2.3 is $(usr(2.3))")
# No interpolation case.
println("Interpolated value at 2.0 is $(usr(2.0))")


# Part 4
arr = [100u"N", 200u"N", 300u"N"]
println(arr[3])

## Extra: Allow unitful arrays to handle multiple indices? ###
# Using above LinSpace on "unitful" arrays gives an error. So we can overload `Base.getindex` to allow unitful arrays.
# function Base.getindex(a::AbstractArray{T}, i...) where {T<:Unitful.N}
#     answer = []
#     for index in i
#         push!(answer, a[index])
#     end
#     return answer
# end

# println(arr[1, 3])


# Operator Problem
# A::Array{Int}, x::Vector
function strangMatrix(n::Int)
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
    return a
end

struct StrangMatrix
    n::Int
    StrangMatrix(n) = strangMatrix(n)  # Inner constructor 
end

smatrix = StrangMatrix(4)
println(smatrix)

function multiplication(a::Array, x::Array)
    y = similar(x)
    mul!(y, a, x)
end

vector = [1, 2, 3, 8]
println(multiplication(smatrix, vector))


# Advanced Bonus - IterativeSolvers
# Define `eltype` since all elements inside a strang matrix are integers (either 1 or -2).
Base.eltype(::Type{StrangMatrix}) = Int

n = 20
p = 20
A = StrangMatrix(n)
x = zeros(n, p)
b = randn(n, p)

sol = IterativeSolvers.cg!(x, A, b)
println("Solution:", sol)

# Must be close to zero.
println("\nDifference: \n", A * x - b)

println("========== Regression Problem ==========")
# Regression problem
#### Prepare Data For Regression Problem

"""
OLS estimator: For the equation: y = Ax, the coefficient vector 'A_prime' is given by:

(xT * x)^-1 * xT * y

which is a close estimate of 'A'. Hence, 'A_prime' is the OLS estimator of 'A'.

"""
# Data given in Q.
X = rand(1000, 3)               # feature matrix
a0 = rand(3)                    # ground truths
println(a0)
y = X * a0 + 0.1 * randn(1000);  # generate response

function olsEstimator(X::Array, y::Array, N::Int)
    Xnew = hcat(X, ones(N))
    Xnew\y  # Solution
end

beta1 = olsEstimator(X, y, 1000)

println("Actual 'a': ", a0)
println("Solution 1: ", beta1)

println("Using MultivariateStats")

beta2 = MultivariateStats.llsq(X, y; bias=true)
println("Solution 2: ", beta2)

println(isapprox(beta1, beta2))

# Using GLM
# See https://juliastats.org/GLM.jl/dev/api/#GLM.lm
beta3 = GLM.lm(X, y)
println(beta3)  # The coefficients are the same as beta1 and beta2!

# Regression Problem Part 2
# Data For Regression Problem Part 2
X = rand(100);
y = 2X  + 0.1 * randn(100);

beta = olsEstimator(X, y, 100)
println("Regression problem 2 solution: ", beta)

# Plotting (in notebook)

# Type heirarchy problem
# Takeaway: Cannot define subclasses of concrete types but only of abstract types.

abstract type AbstractPerson end
abstract type AbstractStudent end

struct Person <: AbstractPerson
    name::String
end
struct Student <: AbstractStudent
    name::String
    grade::Float64
end
struct GraduateStudent <: AbstractStudent
    name::String
    grade::Float64
    gradSchool::String
end

function person_info(x::Person)
    println("The person has the name: ", x.name)
end

function person_info(x::AbstractStudent)
    @printf("The student has the name: %s and has the grade: %f\n", x.name, x.grade)
end

person = Person("Brick")
person_info(person)

student = Student("Wall", 64.90)
person_info(student)

gradStudent = GraduateStudent("GradWall", 99.90, "Howard")
person_info(gradStudent)

# person_info(1.0)  # Using any other type will throw an error.


# Distribution Quantile Problem
distribution = Normal(0, 1)  # Can take gamma, beta, etc distributions.

"""
qth quantile in a given distribution using newtons iteration.
Start with the mean of the distribution.
"""
function calculate_qth_quantile(distribution::UnivariateDistribution, q::Number)
    tol = Inf
    theta = mean(distribution)
    while tol > 1e-5
        thetaold = theta
        theta = theta - (cdf(distribution, theta) - q) / pdf(distribution, theta)
        tol = abs(thetaold-theta)
    end
    theta
end

# Calculate median (50%) quantile.
println(calculate_qth_quantile(distribution, 0.75))
println(quantile.(distribution, 0.75))