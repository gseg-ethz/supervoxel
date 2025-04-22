 /* supervoxel.i */
 %module(cxx) supervoxel

 %{
    #define SWIG_FILE_WITH_INIT
    // only define the 2.0 C‑API macro if it isn’t already set
    #ifndef NPY_NO_DEPRECATED_API
    #define NPY_NO_DEPRECATED_API NPY_2_0_API_VERSION
    #endif
 	#include "supervoxel.h"
 %}


 %include std_string.i
 %include std_vector.i

 %template(IntVector) std::vector<int>;

 %include "numpy.i"
 %init %{
 import_array();
 %}

 %include "supervoxel.h"


