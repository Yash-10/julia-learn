using Plots

# 1. AR1 TimeSeries
# x(t+1) = alpha * x(t) + e(t+1)
T = 200
alphas = [0 0.3 0.9]
function ar1TimeSeries(T, alphas)
    ts = []
    for alpha in alphas
        series = []
        xprev = 0
        for i in 1:T
            e = randn()
            x = alpha * xprev + e
            push!(series, x)
        end
        push!(ts, series)
    end
    return ts
end
ts = ar1TimeSeries(T, alphas)
display(plot!(1:T, ts, label=["0" "0.3" "0.9"]))  # Can make label generalized?


## Under construction ##
# 2. Logistic Map
# b(n+1) = r * bn * (1 - bn)
function logistic()
    r = 2.9
    r_end = 4
    dr = 0.001
    rs = []
    while r != r_end
        r = r + dr
        push!(rs, r)

    yrs = []
    for r in range_
        bn = 0.25
        l = []
        yr = []
        push!(l, bn)
        for i in 1:400+150
            bn = r * bn * (1 - bn)
            if i >= 400
                push!(yr, bn)
            else
                push!(l, bn)
            end
        end
        push!(yrs, yr)
    end
    return rs, yrs
end

yrs = logistic()
display(plot!(rs, yrs))