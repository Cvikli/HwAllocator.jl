# Hardware agnostic array management
Very simple package literally with 2-3 relevant function. 
It spare data move based on types (so compile time). 

```
const CPU_CTX = Val(:CPU)
const CUDA_CTX = Val(:CUDA)
const AMD_CTX = Val(:AMD)
```

- move2hw(arr, dev): arr is the array you want to assure to be on a device. dev is the array ConTeXt 
- unsafe_free_all!: if you want to free arrays manually
- gpu_vec_vec:  convert vector of vector of arrays into 3 vector that is able to be used on GPU this way. (Also printit(...) is able to print out how the structure looks like.)

# It is working but of course needs a lot of improvment (even specifying what more should it do)


