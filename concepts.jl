# Expressions
x = 1 + 2
println(x)  # Gets evaluated.

# If we don't want to evaluate it, use:
x = :(1+2)

println(x)

# OR
x = quote
    1+2
end
println(x)


println(x)
println(typeof(x))

# Dump
dump(x)  # Trying to print dump(..) will raise an error.

# Distinction of macros from functions
# - Macros execute code when the code is parsed unlike functions.
# - Macros take in either expressions, symbols, or literals as arguments.