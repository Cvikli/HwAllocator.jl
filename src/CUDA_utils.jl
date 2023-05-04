
unsafe_free_all!(a::CuArray)  = CUDA.unsafe_free!(a)
unsafe_free_all!(args...)     = unsafe_free_all!(args)
unsafe_free_all!(tarr::Tuple) = for a in tarr  unsafe_free_all!(a) end

macro cudaS128(B, expr)
  return esc(quote
    @sync @cuda threads = 128 blocks = $B $expr
  end)
end

function configurator(B, kernel)
	config = launch_configuration(kernel.fun);
	threads = Base.min(B, config.threads);
	blocks = cld(B, threads);
	return (threads=threads, blocks=blocks)
end

macro krun(ex...)  # kernel config macro run @krun N kernelfn...
	len = ex[1]
	call = ex[2]

	args = call.args[2:end]

	@gensym kernel config threads blocks
	code = quote
			local $kernel = @cuda launch=false $call
			local $config = launch_configuration($kernel.fun)
			local $threads = min($len, $config.threads)
			local $blocks = cld($len, $threads)
			$kernel($(args...); threads=$threads, blocks=$blocks)
	end

	return esc(code)
end
