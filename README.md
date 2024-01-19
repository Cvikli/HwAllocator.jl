# Hardware agnostic array management

Very simple package literally with 2-3 relevant function to reduce data move. 


# Key points

- `move2hw(arr, dev)`: arr is the array you want to assure to be on a device but no operation is done if it is on the device already (compile time optimization). dev(device) is the array ConTeXt. 
- `gpu_vec_vec`:  convert vector of vector of arrays into 3 vector that is able to be used on GPU this way. (Also printit(...) is able to print out how the structure looks like.)
- `unsafe_free_all!`: if you want to free arrays manually.



# It is working but of course could be improved in a lot way...


