__precompile__(true)

module Annette

export AbstractNetwork, fire, fire!
export AbstractNeuralNetwork, SimpleANN, insize, outsize
export AbstractAutomaton, ECA

"""
    AbstractNetwork

Abstract supertype from which all networks inherit
"""
abstract type AbstractNetwork end

"""
    AbstractAutomaton{T,N} <: AbstractNetwork

Abstract supertype from which automata inherit
"""
abstract type AbstractAutomaton{T,N} <: AbstractNetwork end

"""
    fire!(net::AbstractAutomaton{T,N}, state::AbstractArray{T,N})
    fire!(net::AbstractAutomaton{T,N}, state::AbstractArray{T,N}, dest::AbstractArray{T,N})

Update an automaton `state` in-place according to the automaton rule `net`. If `dest` is
provided, then the updated state is placed in `dest` and `state` is left unmodifed.  The
updated state is returned.
"""
function fire!(net::AbstractAutomaton{T,N}, state::AbstractArray{T,N}) where {T,N}
    fire!(net, state, state)
end

"""
    fire(net::AbstractNetwork, input::AbstractArray)

Fire a network on an `input` state, and return the result. All arguments are left
unmodified.
"""
function fire(net::AbstractAutomaton{T,N}, state::AbstractArray{T,N}) where {T,N}
    fire!(net, state, copy(state))
end

"""
    AbstractNeuralNetwork{T,U,N} <: AbstractNetwork

Abstract supertype from which all artificial neural network types inherit
"""
abstract type AbstractNeuralNetwork{T,U,N} <: AbstractNetwork end

"""
    insize(net::AbstractNeuralNetwork)

Get the size of the input array for an artificial neural network
"""
insize(net::AbstractNeuralNetwork) = net.insize

"""
    outsize(net::AbstractNeuralNetwork)

Get the size of the output array for an artificial neural network
"""
outsize(net::AbstractNeuralNetwork) = net.outsize

function fire(net::AbstractNeuralNetwork{T,U,N}, input::AbstractArray{T,N}) where {T,U,N}
    if size(input) != insize(net)
        throw(BoundsError())
    end
    fire!(net, input, Array{U}(outsize(net)...))
end

include("ca.jl")
include("neural.jl")

end
