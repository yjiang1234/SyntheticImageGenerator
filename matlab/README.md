# Image Generator
## Overview

This MATLAB script generates synthetic fluorescent images and a corresponding labeled instance segmentation image. Each “cell” has an elliptical shape with random size, orientation, and intensity. The cells are generated without overlap, and the label assign a unique integer to each ellipse. The script also applies Gaussian blur to simulate the glow typically observed in real microscopy images.

The output includes:
1. A monochromic fluorescent image with a black-to-yellow colormap.
2. A labeled image with unique instance segmentation labels for each cell

Both images are displayed side by side in the figure in MATLAB environment and also saved as PNG file for further usage.

## Features and Assumptions:

**1. Random Elliptical cells**: Each cell has an elliptical shape, generated with random semi-major and semi-minor axes, and a random rotation angel. The “size”, which is the base radius can be adjusted to show larger or smaller cells. 

**2. Homogeneous distribution of Fluorescent**: The fluorescent signal is assumed to be expressed homogeneously throughout the cell. A Gaussian blur is added to mimic a real image, but it is assumed that there is no difference in the fluorescent expression level between the nucleus and cytoplasm.

**3. No Overlap**: Cells are placed in a way that they do not overlap.

**4. Gaussian Blur**: The fluorescent image is blurred with a Gaussian filter to mimic the fluorescent glow effect.

**5. Labeling:** Each ellipse has a unique label in the instance segmentation image.

**6. Gaussian Noises**: Gaussian noise that affects every pixel independently are added to the image to mimic microscope camera noise.

**7. Saving output:** The generated image (fluorescent image in uint16 and labeled image as uint8) are saved as PNG files


## Requirements:
MATLAB: This script requires MATLAB with the Image Processing Toolbox.

## Usage:
1.	Clone or download this repo.
2.	Open the script file in MATLAB
3.	Run the script. The following will be generated:

   	a.	A 128*128 pixel synthetic fluorescent image with 9 yellow (fake color) cells
  
  	b.	A labeled instance segmentation image.
  
  	c.	The synthetic fluorescent image saved as uint16 and the labeled segmentation image saved as uint8 as PNG files.
## Customization:
**1.	Image size:** Change the Image_size to define the pixels for the output images

**2.	Cell numbers:** Change num_spots to adjust the number of generated cells

**3.	Size of cells:** Change spot_radius to adjust the size of the cells

**4.	Fluorescent Intensity:** Since the fluorescent images can usually adjusted for visualization, here I defined the range for the fluorescent intensity, instead of absolute intensity. The intensity of each cell will be a random number in the intensity range, so a larger range will result in some cells are very bright and some are dim. A smaller range will generate cell in similar fluorescent intensity.

**5.	Distance between cells:** You can adjust min_distance_between_spots to change the minimum distance between cells. It is recommended for this value to be at least 3*spot_radius to avoid overlap.

**6. Noise level**: Change noise_level to adjust the noise level added to the image. The larger number means more noisy image. 

**7.	Export image name:** You can change file_name_for_save_fluorescent and file_name_for_save_label for the export file name and path. 

