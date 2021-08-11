using IterativeSolvers
using LinearAlgebra
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


# Regression problem
N = 50
data = randn(N, 3)
outcomes = [i for i in 1:N]
println(data)
println(length(data))

println(hcat(data, outcomes))