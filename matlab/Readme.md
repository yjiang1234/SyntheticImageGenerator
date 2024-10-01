##Overview

This MATLAB script generates synthetic fluorescent images and a corresponding labeled instance segmentation image. Each “cell” has an elliptical shape with random size, orientation, and intensity. The cells are generated without overlap, and the label assign a unique integer to each ellipse. The script also applies Gaussian blur to simulate the glow typically observed in real microscopy images.

The output includes:
A monochromic fluorescent image with a black-to-yellow colormap.
A labeled image with unique instance segmentation labels for each cell

Both images are displayed side by side in the figure in MATLAB environment and also saved as PNG file for further usage.

Features and Assumptions:

Random Elliptical cells: Each cell has elliptical shape, which is generated with random semi-major and semi-minor axes, and a random rotation angel. The “size”, which is the base radius can be adjusted to show larger or smaller cells. 
Homogeneous distribution of Fluorescent: I assume that the fluorescent is expressed homogeneously in the whole cell. A Gaussian blur is added to mimic the real image but the assumption is there is no difference of fluorescent expression level in the nucleus and cytoplasma.
No Overlap: The cells are placed in a way that they do not overlap
Gaussian Blur: The fluorescent image is blurred with Gaussian method to mimic the fluorescent glow effect
Labeling: Each ellipse has a unique label in the instance segmentation image.
Saving output: The generated image (fluorescent image in uint16 and labeled image as uint8) are saved as PNG files

Requirements:
MATLAB: This script requires MATLAB with the Image Processing Toolbox.

Usage:
1.	Clone or download this repo.
2.	Open the script file in MATLAB
3.	Run the script. The following will be generated:
a.	A 128*128 pixel synthetic fluorescent image with 9 yellow (fake color) cells
b.	A labeled instance segmentation image.
c.	The synthetic fluorescent image saved as uint16 and the labeled segmentation image saved as uint8 as PNG files.
Customization:
1.	Image size: Change the Image_size to define the pixels for the output images
2.	Cell numbers: Change num_spots to adjust the number of generated cells
3.	Size of cells: Change spot_radius to adjust the size of the cells
4.	Fluorescent Intensity: Since the fluorescent images can usually adjusted for visualization, here I defined the range for the fluorescent intensity, instead of absolute intensity. The intensity of each cell will be a random number in the intensity range, so a larger range will result in some cells are very bright and some are dim. A smaller range will generate cell in similar fluorescent intensity.
5.	Distance between cells: you can adjust min_distance_between_spots to change the minimum distance between cells. It is recommended for this value to be at least 3*spot_radius to avoid overlap.
6.	Export image name: You can change file_name_for_save_fluorescent and file_name_for_save_label for the export file name and path. 
