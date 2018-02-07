__precompile__(true)

module Annette

export AbstractNetwork, AbstractAutomaton, fire, fire!, ECA

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
    fire(ca::AbstractAutomaton{T,N}, state::AbstractArray{T,N})

Update an automaton `state` according to the rule `net`. The `state` argument is left
unmodified, and the updated state is returned.
"""
function fire(net::AbstractAutomaton{T,N}, state::AbstractArray{T,N}) where {T,N}
    fire!(net, state, copy(state))
end

include("ca.jl")

end
