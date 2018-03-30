"""
    SimpleANN <: AbstractNeuralNetwork{Int,Int,1}

A simple, 1-layer, feed-forward artificial neural network with perceptron nodes.

    SimpleANN(ws::AbstractArray{Float64,2}, ts::AbstractVector{Float64})

Create a SimpleANN with weights `ws` and thresholds `ts`.

    SimpleANN(n::Int,m::Int) = SimpleANN(zeros(m,n), zeros(m))

Create a SimpleANN with `n` inputs and `m` outputs. All weights and thresholds are
initialized to zero.
"""
struct SimpleANN <: AbstractNeuralNetwork{Int,Int,1}
    insize :: Int
    outsize :: Int
    weights :: Array{Float64,2}
    thresholds :: Vector{Float64}
    function SimpleANN(ws::AbstractArray{Float64,2}, ts::AbstractVector{Float64})
        if any(size(ws).==0)
            throw(ArgumentError("weights matrix; invalid size"))
        elseif length(ts) != size(ws,1)
            throw(DimensionMismatch("weights and thresholds"))
        end
        m, n = size(ws)
        new(n, m, ws, ts)
    end
end

SimpleANN(n::Int,m::Int) = SimpleANN(zeros(m,n), zeros(m))

insize(net::SimpleANN) = (net.insize,)
outsize(net::SimpleANN) = (net.outsize,)

function fire!(net::SimpleANN, input::Vector{Int}, output::Vector{Int})
    if net.insize != length(input)
        throw(DimensionMismatch("invalid input"))
    elseif net.outsize != length(output)
        throw(DimensionMismatch("invalid output"))
    end
    temp = zeros(Float64, net.outsize)
    for j in 1:net.insize
        for i in 1:net.outsize
            temp[i] += net.weights[i,j] * input[j]
        end
    end
    for i in 1:net.outsize
        output[i] = (temp[i] - net.thresholds[i] <= 0.) ? 0 : 1
    end
    output
end
