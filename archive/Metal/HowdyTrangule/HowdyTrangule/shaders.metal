#include <metal_stdlib>
using namespace metal;

// [[ buffer(0) ]] says to pull data from the first vertex buffer 
//    sent to the shader
// the second argument is the index of the vertex within the vertex array
vertex float4 basic_vertex(
    const device packed_float3 *vertex_array [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]) {
    
    return float4(vertex_array[vid], 1.0);
}


fragment half4 basic_fragment() {
    return half(1.0);
}

