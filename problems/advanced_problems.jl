using LinearAlgebra
using Polynomials

# Metaprogramming problem.
"""
The polynomial is: [summation k=1 to length(c)] z ^ (k-1) * c[k]
"""
macro myevalpoly(z, c...)
    # indices = range(1, length=length(c))
    # ex = Expr(:call, :+, c[0], c[1] * x, c[2] * x^2)
    return quote
        coeff = $z
        arr = $c
        sum(arr[i] * coeff ^ (i-1) for i in 1:length(arr))
    end
end

println(@myevalpoly(3, 1, 0, 1))  # expected: 10
println(@myevalpoly(2, 1, 0, 1))  # expected: 5
println(@myevalpoly(2, 1, 1, 1))  # expected: 7


# Wilkinson's polynomial - (in notebook)