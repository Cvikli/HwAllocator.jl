module HwAllocator
using Distributed
using CUDA
using Random
# using Zygote

const CPU_CTX = Val(:CPU)
const CUDA_CTX = Val(:CUDA)
const AMD_CTX = Val(:AMD)

include("GPU_agnistic_FNs.jl")
include("CUDA_utils.jl")
# include("HwAllocator_old.jl")



move2hw(arr::Array, dev::Val{:CPU}) = arr
move2hw(arr::CuArray, dev::Val{:CUDA}) = arr
move2hw(arr::Vector{Array}, dev::Val{:CPU}) = arr
move2hw(arr::Vector{CuArray}, dev::Val{:CUDA}) = arr
# move2hw(arr::ROCArray, dev::Val{:AMD}) = arr
move2hw(arr::CuArray, dev::Val{:CPU}) = Array(arr)
move2hw(arr::Array, dev::Val{:CUDA}) = CuArray(arr)
move2hw(arr::Vector{Array}, dev::Val{:CUDA}) = move2hw.(arr, dev)
move2hw(arr::Vector{CuArray}, dev::Val{:CPU}) = move2hw.(arr, dev)

move2hw(arr::Vector{T}, dev) where T <: AbstractArray = move2hw.(arr, dev)
move2hw(arr::Tuple, dev) = Tuple(move2hw(a, dev) for a in arr)
# move2hw(arr, dev::Val{:AMD}) = ROCArray(arr)


hw_one(arr::CuArray, size...) = CUDA.one(eltype(arr),size...)
hw_one(arr::Array, size...) = one(eltype(arr),size...)


end # module HwAllocator