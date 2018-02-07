"""
    ECA <: AbstractAutomaton{Int,1}

An elementary cellular automaton.

ECA's consist of an 8-bit Wolfram code, and a boundary condition. If the boundary condition
`isnull` then a circular boundary is used, otherwise the tuple represents the (left,right)
boundary condition.

# Examples
```julia
julia> ECA(30)
Annette.ECA(0x1e, Nullable{Tuple{Int64,Int64}}())

julia> ECA(30, 1, 0)
Annette.ECA(0x1e, Nullable{Tuple{Int64,Int64}}((1, 0)))

julia> ECA(30, (1,0))
Annette.ECA(0x1e, Nullable{Tuple{Int64,Int64}}((1, 0)))
```
"""
type ECA <: AbstractAutomaton{Int,1}
    "The 8-bit Wolfram ECA code"
    code :: UInt8
    "The boundary conditions for the ECA"
    boundary :: Nullable{Tuple{Int,Int}}

    ECA(code) = new(code, Nullable{Tuple{Int,Int}}())
    ECA(code, left, right) = new(code, Nullable((1 & left, 1 & right)))
end

ECA(code, boundary::Tuple{Int,Int}) = ECA(code, boundary...)

"""
    iscircular(ca::ECA)

Does the ECA have circular or open boundary conditions?

# Examples
```julia
julia> iscircular(ECA(30))
true

julia> iscircular(ECA(30, (0,0)))
false
```
"""
iscircular(ca::ECA) = isnull(ca.boundary)

function fire!(ca::ECA, state::AbstractVector{Int}, dest::AbstractVector{Int})
    if length(dest) != length(state)
        throw(BoundsError())
    end

    left, right = iscircular(ca) ? (state[end], state[1]) : get(ca.boundary)

    shift = 2 * left + state[1]
    for i in 1:length(state)-1
        shift = 7 & (2 * shift + state[i+1])
        dest[i] = 1 & (ca.code >> shift)
    end
    shift = 7 & (2 * shift + right)
    dest[end] = 1 & (ca.code >> shift)

    dest
end
