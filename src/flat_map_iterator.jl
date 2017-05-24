"Iterates over the iterators within an iterator"
immutable FlatMapIterator{I}
    it::I
end

eltype{I}(::Type{FlatMapIterator{I}}) = eltype(eltype(I))
iteratorsize{I}(::Type{FlatMapIterator{I}}) = Base.SizeUnknown()
iteratoreltype{I}(::Type{FlatMapIterator{I}}) = _flatteneltype(I, iteratoreltype(I))
_flatteneltype(I, ::Base.HasEltype) = iteratoreltype(eltype(I))
_flatteneltype(I, et) = Base.EltypeUnknown()

function Base.start(f::FlatMapIterator)
    local inner, s2
    s = start(f.it)
    d = done(f.it, s)
    # this is a simple way to make this function type stable
    d && throw(ArgumentError("argument to Flatten must contain at least one iterator"))
    done_inner = false
    while !d
        inner, s = next(f.it, s)
        s2 = start(inner)
        done_inner = done(inner, s2)
        !done_inner && break
        d = done(f.it, s)
    end
    return (d & done_inner), s, inner, s2
end

@inline function Base.next(f::FlatMapIterator, state)
    _done, s, inner, s2 = state
    val, s2 = next(inner, s2)
    done_inner = done_outer = false
    while (done_inner=done(inner, s2)) && !(done_outer=done(f.it, s))
        inner, s = next(f.it, s)
        s2 = start(inner)
    end
    return val, ((done_inner & done_outer), s, inner, s2)
end

@inline function Base.done(f::FlatMapIterator, state)
    return state[1]
end
