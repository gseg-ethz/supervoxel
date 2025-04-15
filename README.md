# Supervoxel segmentation tool
This python library enables the segmentation of a point cloud into boundary preserving super voxels. Boundary 
preservation is achieved by incorporating cosine distance between the normal vectors in the objective function. This 
source code is based on the [ISPRS paper](https://www.sciencedirect.com/science/article/pii/S0924271618301370) 
by Lin et al. (2018) and the provided [source code](https://github.com/yblin/Supervoxel-for-3D-point-clouds). Currently,
we only provide a python wrapper for a single function, but other functions can be added by adapting the 
`supervoxel.i` file.

<pre><code>
<i>class</i> <b>supervoxel.computeSupervoxel(input_file, k_neighbors, resolution, save_file)</b>

<b>Parameters:</b> 

- <i>input_file (string):</i> path to the file that should be segmented into supervoxels

- <i>k_neighbors (int):</i> number of nearest neighbors used for the normal vector estimation

- <i>resolution (float):</i> desired diameter of the supervoxels indirectly
  controls the number of supervoxels (see paper for more information)

- <i>save_file (string):</i> path where the results should be saved if "None" data will not be saved (the folder must exist already) 

<b>Returns:</b>

- Function saves "ASCII" files to the defined path (save_file). First three
  columns are the coordinates of the points, columns 3-6 are randomly assigned
  colors (based on label), label denoting the supervoxel (all points with the 
  same label belong to one supervoxel) 

</code></pre>

> [1] Lin, Y., Wang, C., Zhai, D., Li, W., & Li, J. (2018). Toward better boundary preserved supervoxel segmentation 
> for 3D point clouds. ISPRS Journal of Photogrammetry and Remote Sensing, 143, 39–47. https://doi.org/10.1016/j.isprsjprs.2018.05.004
