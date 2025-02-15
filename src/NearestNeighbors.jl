module NearestNeighbors

using Distances
import Distances: Metric, result_type, eval_reduce, eval_end, eval_op, eval_start, evaluate, parameters

using StaticArrays
import Base.show

export NNTree, BruteTree, KDTree, BallTree, DataFreeTree
export knn, nn, inrange, inrangecount # TODOs? , allpairs, distmat, npairs
export injectdata

export Euclidean,
       Cityblock,
       Minkowski,
       Chebyshev,
       Hamming,
       WeightedEuclidean,
       WeightedCityblock,
       WeightedMinkowski

abstract type NNTree{V <: AbstractVector,P <: Metric} end

const MinkowskiMetric = Union{Euclidean,Chebyshev,Cityblock,Minkowski,WeightedEuclidean,WeightedCityblock,WeightedMinkowski}

NUMBER_OF_DISTANCES::UInt64 = 0

@inline function clear_distances!() 
  global NUMBER_OF_DISTANCES = UInt64(0)
end

@inline function add_distance!(k::UInt64 = UInt64(1))
  global NUMBER_OF_DISTANCES += k
end

function check_input(::NNTree{V1}, ::AbstractVector{V2}) where {V1, V2 <: AbstractVector}
    if length(V1) != length(V2)
        throw(ArgumentError(
            "dimension of input points:$(length(V2)) and tree data:$(length(V1)) must agree"))
    end
end

function check_input(::NNTree{V1}, point::AbstractVector{T}) where {V1, T <: Number}
    if length(V1) != length(point)
        throw(ArgumentError(
            "dimension of input points:$(length(point)) and tree data:$(length(V1)) must agree"))
    end
end

get_T(::Type{T}) where {T <: AbstractFloat} = T
get_T(::T) where {T} = Float64

include("evaluation.jl")
include("tree_data.jl")
include("datafreetree.jl")
include("knn.jl")
include("inrange.jl")
include("hyperspheres.jl")
include("hyperrectangles.jl")
include("utilities.jl")
include("brute_tree.jl")
include("kd_tree.jl")
include("ball_tree.jl")
include("tree_ops.jl")

for dim in (2, 3)
    tree = KDTree(rand(dim, 10))
    knn(tree, rand(dim), 5)
    inrange(tree, rand(dim), 0.5)
end

end # module
