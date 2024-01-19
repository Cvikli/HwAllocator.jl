module HwAllocator
using Distributed
using CUDA
using Random

const CPU_CTX  = Val(:CPU)
const CUDA_CTX = Val(:CUDA)
const AMD_CTX  = Val(:AMD)



move2hw(arr::Array,           dev::Val{:CPU})  = arr
move2hw(arr::CuArray,         dev::Val{:CUDA}) = arr
move2hw(arr::Vector{Array},   dev::Val{:CPU})  = arr
move2hw(arr::Vector{CuArray}, dev::Val{:CUDA}) = arr
# move2hw(arr::ROCArray,        dev::Val{:AMD}) = arr
# move2hw(arr,                  dev::Val{:AMD})               = ROCArray(arr)
move2hw(arr::CuArray,         dev::Val{:CPU})               = Array(arr)
move2hw(arr::Array,           dev::Val{:CUDA})              = CuArray(arr)
move2hw(arr::Vector{Array},   dev::Val{:CUDA})              = move2hw.(arr, dev)
move2hw(arr::Vector{CuArray}, dev::Val{:CPU})               = move2hw.(arr, dev)
move2hw(arr::Vector{T},       dev) where T <: AbstractArray = move2hw.(arr, dev)
move2hw(arr::Tuple,           dev)                          = Tuple(move2hw(a, dev) for a in arr)


hw_one(arr::CuArray, size...) = CUDA.one(eltype(arr),size...)
hw_one(arr::Array,   size...) = one(eltype(arr),size...)

include("GPU_agnistic.jl")
include("GPU_release.jl")


end # module HWAllocator