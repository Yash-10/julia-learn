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
