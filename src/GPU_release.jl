unsafe_free_all!(a::CuArray)  = CUDA.unsafe_free!(a)
unsafe_free_all!(args...)     = unsafe_free_all!(args)
unsafe_free_all!(tarr::Tuple) = for a in tarr  unsafe_free_all!(a) end


