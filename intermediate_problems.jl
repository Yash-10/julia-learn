# MyRange Part 1:

# Part (i)
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
