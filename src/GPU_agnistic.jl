

const ssym = ["∑", "o", "∏", "σ", "⋌", "∠","∇", "-","e", "®"]  # TODO: HARDCODED_KNOWN_AMOEBA_FORDWARD_BACKWARD_SYMBOLS_ORDERED update...


gpu_vec_vec(v::Vector{Vector{Vector{Int64}}}) = begin
	v1, v2, vlen = 0, 0, 0
	for vi in v
		v1 += 1
		v2 += length(vi)
		for vj in vi
			vlen += length(vj)
		end
	end
	# @show v1, v2, vlen
	a1 = Vector{Int32}(undef, v1+1)
	a2 = Vector{Int32}(undef, v2+1)
	arr = Vector{Int32}(undef, vlen)
	a1[1] = 1
	a2[1] = 1
	arr[1] = 1
	for (i,vi) in enumerate(v)
		a1[i+1] = a1[i]+length(vi)
		for (j,vj) in enumerate(vi)
			a2[a1[i]+j] = a2[a1[i]+j-1]+length(vj)
			# for (k,vk) in enumerate(vj)
			rrange = a2[a1[i]+j-1]:(a2[a1[i]+j]-1)
			arr[rrange] .= v[i][j]
			# end
		end
	end
	# @display v
	a1, a2, arr
end

gpu_vec_vec(v::Vector{Vector{Vector{Vector{Int64}}}}) = begin
	v1, v2, v3, vlen = 0, 0, 0, 0
	for vi in v
		v1 += 1
		v2 += length(vi)
		for vj in vi
			v3 += length(vj)
			for vk in vj
				vlen += length(vk)
			end
		end
	end
	# @show v1, v2, v3, vlen
	a1 = Vector{Int32}(undef, v1+1)
	a2 = Vector{Int32}(undef, v2+1)
	a3 = Vector{Int32}(undef, v3+1)
	arr = Vector{Int32}(undef, vlen)
	a1[1], a2[1], a3[1], arr[1] = 1, 1, 1, 1
	for (i,vi) in enumerate(v)
		ii=a1[i]
		a1[i+1] = a1[i]+length(vi)
		for (j,vj) in enumerate(vi)
			jj = a2[ii+j-1]
			a2[ii+j] = jj+length(vj)
			for (k,vk) in enumerate(vj)
				kk=a3[jj+k-1]
				a3[jj+k] = kk +length(vk)
				arr[kk:(a3[jj+k]-1)] .= v[i][j][k]
			end
		end
	end
	# @display v
	a1, a2, a3, arr
end


printit(ops_l3, ops_l2, ops_l1, ops_lv) = begin 
	ops_lv = Array(ops_lv)
  for i in 1:length(ops_l1)-1
    for j in ops_l1[i]:ops_l1[i+1]-1
      # print((l1[i]:(l1[i+1]-1), l2[j]:(l2[j+1]-1),  (lv[l2[j]:l2[j+1]-1]...,)) )
      # print((ops_lv[ops_l2[j]:ops_l2[j+1]-1]...,)) 
      if ops_l2[j]<ops_l2[j+1]
        for k in ops_l2[j]:ops_l2[j+1]-1
          print((ops_lv[ops_l3[k]:ops_l3[k+1]-1]...,))
        end
      else 
        print("()")
      end
      # print((ops_l3[ops_l2[j]:ops_l2[j+1]-1]...,)) 
    end
    println()
    # @show ops_l2
    # @show ops_l3
    # @show ops_lv
  end
end
toidx(offset) = Int(offset /1000 + 1)
printitdirected_dict(nops_l1g, nops_l2g, nops_lvg, ops_l1g, ops_l2g, ops_l3g, ops_lvg; forward=true) = begin # TODO new package... for Vector of... decode! Also in_bfs could go there
	mv2hw = arr -> move2hw(arr, Val(:CPU))
	nops_l2, nops_l1, nops_lv, ops_l3, ops_l2, ops_l1, ops_lv = mv2hw(nops_l2g), mv2hw(nops_l1g), mv2hw(nops_lvg), mv2hw(ops_l3g), mv2hw(ops_l2g), mv2hw(ops_l1g), mv2hw(ops_lvg)
	tmp_dict = Dict()
	if forward
		println("Forward: [bemenetekből]↦[kimenetekbe]")
	else
		println("Backward: [kimenetekből]↤[bemenetekbe]")
	end
  for i in 1:length(ops_l1)-1
    for j in ops_l1[i]:ops_l1[i+1]-1
      # print((l1[i]:(l1[i+1]-1), l2[j]:(l2[j+1]-1),  (lv[l2[j]:l2[j+1]-1]...,)) )
      # print((ops_lv[ops_l2[j]:ops_l2[j+1]-1]...,)) 
			print(ssym[j-(i-1)*10] * "(")
			for k in ops_l2[j]:ops_l2[j+1]-1
				if nops_lv[k] in keys(tmp_dict)
					append!(tmp_dict[nops_lv[k]], Int[toidx.(ops_lv[ops_l3[k]:ops_l3[k+1]-1])...])
				else
					# @show ops_lv[ops_l3[k]:ops_l3[k+1]-1]
					tmp_dict[nops_lv[k]] = Int[toidx.(ops_lv[ops_l3[k]:ops_l3[k+1]-1])...]
				end
				if forward
					print(Int[toidx.(ops_lv[ops_l3[k]:ops_l3[k+1]-1])...],"↦",toidx(nops_lv[k])," ")
				else
					print(Int[toidx.(ops_lv[ops_l3[k]:ops_l3[k+1]-1])...],"↤",toidx(nops_lv[k])," ")
				end
			end
			print(")")
      # print((ops_l3[ops_l2[j]:ops_l2[j+1]-1]...,)) 
    end
    println()
    # @show ops_l2
    # @show ops_l3
    # @show ops_lv
  end
	tmp_dict	
end
printitdirected(nops_l2, nops_l1, nops_lv, ops_l3, ops_l2, ops_l1, ops_lv; forward=true) = begin 
	mv2hw = arr -> move2hw(arr, Val(:CPU))
	nops_l2, nops_l1, nops_lv, ops_l3, ops_l2, ops_l1, ops_lv = mv2hw(nops_l2g), mv2hw(nops_l1g), mv2hw(nops_lvg), mv2hw(ops_l3g), mv2hw(ops_l2g), mv2hw(ops_l1g), mv2hw(ops_lvg)
	
	if forward
		println("Forward: [bemenetekből]->[kimenetekbe]")
	else
		println("Backward: [kimenetekből]<-[bemenetekbe]")
	end
  for i in 1:length(ops_l1)-1
    for j in ops_l1[i]:ops_l1[i+1]-1
      # print((l1[i]:(l1[i+1]-1), l2[j]:(l2[j+1]-1),  (lv[l2[j]:l2[j+1]-1]...,)) )
      # print((ops_lv[ops_l2[j]:ops_l2[j+1]-1]...,)) 
			print("(")
      if ops_l2[j]<ops_l2[j+1]
        for k in ops_l2[j]:ops_l2[j+1]-1
					if forward
          	print(Int[ops_lv[ops_l3[k]:ops_l3[k+1]-1]...],"->",nops_lv[k]," ")
					else
          	print(Int[ops_lv[ops_l3[k]:ops_l3[k+1]-1]...],"<-",nops_lv[k]," ")
					end
        end
      end
			print(")")
      # print((ops_l3[ops_l2[j]:ops_l2[j+1]-1]...,)) 
    end
    println()
    # @show ops_l2
    # @show ops_l3
    # @show ops_lv
  end
end
printit(ops_l2, ops_l1, ops_lv) = begin 
	ops_lv = Array(ops_lv)
  for i in 1:length(ops_l1)-1
    for j in ops_l1[i]:ops_l1[i+1]-1
      # print((l1[i]:(l1[i+1]-1), l2[j]:(l2[j+1]-1),  (lv[l2[j]:l2[j+1]-1]...,)) )
      print((ops_lv[ops_l2[j]:ops_l2[j+1]-1]...,)) 
    end
    println()
  end
end
printit(ops) = begin 
  for i in 1:length(ops)
    for j in 1:len(ops[i])
      print((ops[i][j]...,))
    end
    println()
  end
end




