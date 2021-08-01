# Trick to prevent manually activating an environment using: `activate <env_name>`
cd(@__DIR__)
using Pkg
Pkg.activate(".") # Activate the environment here.

using Printf
using Statistics


println(23)

# Float to Int
i1 = UInt8(trunc(3.256))
println(i1)

# Multiple dispatch
# The different variants of the same function, f, are called "methods".
function f(x::Int32, y::Int32)
    x * y
end

function f(x::Int32, y::Float64)
    x + y
end

function f(x::Int)
    return x^2
end

println(f(1))
println(f(2, 7))
println(f(2, 7.0))


# Function with types
function juliaFunction(arg1::Int32, arg2::Int32)
    return 3 * arg1
end
juliaFunction(15, 12)

# Concat strings
println("string1", "string2")
println("string1" * "string2")

s = """
Multi-line strings
are great to display
!"""
println(s)

println(occursin("key", "monkey"))
println(findfirst(isequal(3), [9, 4, 3, 5]))


# @printf
@printf("Today is a good day. Let's go to %s\n", "Space")
@printf("(true || false) and not(1 == 2 or true || false) = %s\n", (true || false) && !(1 == 2 || true || false))

# Ternary
a = (2 >= 10) ? true : false
println(a)

# Arrays
a = [1,2,3,4,5]
println(size(a))
println(length(a))
println(sum(a))
println(maximum(a))
println(minimum(a))

# Multi-dim array
b = [1 2 3; 4 5 6; 7 8 9]
for i in 1:3
    for j in 1:3
        @printf("value at %d and %d is: %f\n", i, j, b[i, j])
    end
end
println(b)

# Named tuples
t = (rock = ("Rock", 100), sea = ("Sea", 200))
println(t.rock)

# Delete key from Dict
d = Dict("pi" => 3.14, "e" => 2.73)
delete!(d, "pi")
println(d)

# Set
st = Set(["Flower", "car", "radio", "Flower"])
st2 = Set(["Ground", "Radio", "Car", "Flowers"])
println(st)
println(union(st, st2))
println(intersect(st, st2))

# Ways to define a function
# 1.
f(x) = x ^ 2
println(f(12))

# 2.
function f(x=3)
    return 3x
end
println(f(5))


# Can use global variables inside a function
function getSum(args)
    sum = 0
    for arg in args
        sum += arg
    end
    println(sum)
end

getSum([10, 20, 30])

# New function
function getSum(num1::Number, num2::Number)
    return num1 + num2
end

function getSum1(num1::String, num2::String)
    return parse(Int32, num1) + parse(Int32, num2)
end

println("5 + 4 = ", getSum1("5", "4"))

# Anonymous function
v2 = map(x -> x * x, [1, 2, 3])
println(v2)

v3 = map((x, y) -> x + y, [1, 2], [3, 4])
println(v3)

v4 = reduce(^, 1:50)
@printf("v4 = %f\n", v4)

# Split string
s = "This is a string!"
println(split(s))

# Multiply a value to array
l = [3,4,5,6]
## both are same
println(l * 4)
println(l .* 4)

# No need of *!
x = 3
println(2x)

# Enumerate
@enum Color begin
    red = 1
    blue = 2
    green = 3
end
favColor = green::Color
println(favColor)

# Structs are immutable, but add "mutable" before "struct" to make it mutable.

abstract type Animal end

struct Dog <: Animal
    name::String
    bark::String
end

# Symbols - immutable strings
:yash
println(:yash)

d = Dict(:one => 1, :two => 2, :three => 3)  # Avoids writing "one", "two", etc
println(d[:two])


# Mutable struct
# Immutable types may give faster speed since memory access cost is low.
mutable struct Cat <: Animal
    name::String
    meow::String
end

function animCat(animal::Cat)
    println("$(animal.name) does $(animal.meow)")
end

cat = Cat("mycat", "meow")
animCat(cat)

# try-catch
print("Enter a number ")
num1 = chomp(readline())
print("Enter another number ")
num2 = chomp(readline())

try
    val = parse(Int32, num1) / 0
catch e
    println("error!")
end


# Arrays
a1 = zeros(Int32, 3, 3)
a2 = Array{Int32}(undef, 4) # Array of undefined values of length 4.
a3 = Float64[]
a4 = [1,2,3,4]

println(a4[end])

println("The array a4 is ", a4)

# Make an array just like a4 but with undefined values.
a5 = similar(a4)
println(a5) # Will be random values

copyto!(a5, a4) # Mutating function using `!` - Allow for faster computation since less memory calls.
println(a5)

# Search for an element
println(findfirst(isequal(2), a4))

# Insert value (inplace)
splice!(a4, 2:2, [8, 9])
println(a4)

# collect
a5 = collect(2:2:10)
for n in a5
    println(n)
end

# Dict
d1 = Dict("pi" => 3.12, "e" => 2.34)
println(d1["pi"])
