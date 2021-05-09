# Image Segmentation Algorithms - Region Growing, Watershed and K-Means
```
Author: Rishabh Srivastava
```
This work is focused on the implementation of 3 image segmentation algorithms - Region Growing, Watershed and K-Means algorithms. 

The original image on which image segmentation is performed is shown below :
<div align = "center">
<img src = "https://user-images.githubusercontent.com/39689610/117571164-e5d96e80-b0ea-11eb-8825-ec72f826e0d3.jpg" width="450" height="300">
</div>
<br>

_The image is to be segmented in **2 parts** to separate the aeroplane from the background._

The _Jaccard Similarity Coefficient_ is used as the metric to evaluate the performance of the algorithms.

## 1. Region Growing Algorithm :
This approach to segmentation examines neighboring pixels of initial seed points and determines whether the pixel neighbors should be added to the region. Choosing of an accurate seed point in Region Growing algorithm is crucial for the performance of the algorithm.


### Output :
<div align = "center">
<img src = "https://user-images.githubusercontent.com/39689610/117570965-2d132f80-b0ea-11eb-9b1b-39116acb7fd0.jpg" width="450" height="300"> <img src = "https://user-images.githubusercontent.com/39689610/117570980-41efc300-b0ea-11eb-855e-1d3e75bd7a99.jpg" width="450" height="300">
</div>

<div align = "center">
  <kbd>
    <img src = "https://user-images.githubusercontent.com/39689610/117571691-4b2e5f00-b0ed-11eb-9cb8-f3d33c2464a5.png">
  </kbd>
</div>

## 2. Watershed Algorithm :
A watershed is a transformation defined on a grayscale image. The name refers metaphorically to a geological watershed which separates adjacent drainage basins. The watershed transformation treats the image it operates upon like a topographic map, with the brightness of each point representing its height, and finds the lines that run along the tops of ridges.

Watershed algorithm outputs an image with many segments, which is further processed to obtain an image with only 2 segments to suit our requirement.


### Output :
<div align = "center">
<img src = "https://user-images.githubusercontent.com/39689610/117570571-4b782b80-b0e8-11eb-9eda-82ae0dcb0141.jpg" width="450" height="300"> <img src = "https://user-images.githubusercontent.com/39689610/117570593-5cc13800-b0e8-11eb-8bd7-1c302f4a8d25.jpg" width="450" height="300">
</div>

<div align = "center">
  <kbd>
    <img src = "https://user-images.githubusercontent.com/39689610/117571742-70bb6880-b0ed-11eb-938b-2611ef0c7bcf.png">
  </kbd>
</div>

## 3. K-Means Algorithm :
K-Means clustering algorithm is an unsupervised algorithm and it is used to segment the interest area from the background. It divides the pixels into clusters according to its characteristics.

### Output :
<div align = "center">
<img src = "https://user-images.githubusercontent.com/39689610/117570610-6ea2db00-b0e8-11eb-9217-f3f9dfbb8156.jpg" width="450" height="300">
</div>

<div align = "center">
  <kbd>
    <img src = "https://user-images.githubusercontent.com/39689610/117571752-787b0d00-b0ed-11eb-83e4-13db8089ce84.png">
  </kbd>
</div>

## Notes :
### Jaccard Similarity Coeffecient
Jaccard similarity coefficient is defined as the area of overlap between the predicted segmentation and the ground truth divided by the area of union between the predicted segmentation and the ground truth. 
<div align = "center">
<img src = "https://user-images.githubusercontent.com/39689610/117572878-90a15b00-b0f2-11eb-92ab-1c819a1a0fc8.png" width="450" height="300">
</div>

It is a numeric value in the range [0, 1]. A similarity of **1** means that the segmentations in the two images are a **perfect match**.
