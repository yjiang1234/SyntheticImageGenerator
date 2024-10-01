# Synthetic Image Generator- Batch Run
## Overview:

This MATLAB script generates synthetic fluorescent images and a corresponding labeled instance segmentation image. Each “cell” has an elliptical shape with random size, orientation, and intensity. The cells are generated without overlap, and the label assign a unique integer to each ellipse. The script also applies Gaussian blur to simulate the glow typically observed in real microscopy images.

## Features and Assumptions:
The features and assumptions are basically the same as the matlab/imagegenerator_all_in_one. This script just seperate the center generator and cell_mask (here is ellipse) as sepearte function, so it will be easier to add other cell mask if needed. It also change the whole scipt (matlab/imagegenerator_all_in_one) into a function so we can do a batch run on it to generate multiple image datasets.

**1. Random Elliptical cells**: Each cell has elliptical shape, which is generated with random semi-major and semi-minor axes, and a random rotation angel. The “size”, which is the base radius can be adjusted to show larger or smaller cells. 

**2. Homogeneous distribution of Fluorescent**: I assume that the fluorescent is expressed homogeneously in the whole cell. A Gaussian blur is added to mimic the real image but the assumption is there is no difference of fluorescent expression level in the nucleus and cytoplasma.

**3. No Overlap**: The cells are placed in a way that they do not overlap.

**4. Gaussian Blur**: The fluorescent image is blurred with Gaussian method to mimic the fluorescent glow effect.

**5. Labeling:** Each ellipse has a unique label in the instance segmentation image.

**6. Saving output:** The generated image (fluorescent image in uint16 and labeled image as uint8) are saved as PNG files
## Retuirements

**MATLAB**: This script requires MATLAB with the Image Processing Toolbox.

## Usage and Examplar:

1.	Clone or download this repo.
2.	Open MATLAB, make sure all files are in the same folder
3.	Run the example.m file. The following will be generated:

   	a.	A 128*128 pixel synthetic fluorescent image with 9 yellow (fake color) cells
  
  	b.	A labeled instance segmentation image.
  
  	c.	The synthetic fluorescent image saved as uint16 and the labeled segmentation image saved as uint8 as PNG files.

4. Once you are happy with how the image look like in step 3, you can use the same parameter to generate a batch of images for further traing. To do so, run the batch_run.m file. This will generate n (here n = 3) pairs of 128*128 pixel synthetic fluorescent image with 9 yellow (fake color) cells and labeled instance segmentation image. The fluorescent images will be saved as png file with name "fluorescent_image_1.png","fluorescent_image_2.png"... and the labeled images saved as "label_image_1.png","label_image_2.png"... You can change the path and save file name by changing the file_name_fluo and file_name_label.

## Code Explanation
CenterGenerator.m is a function file that generate n random spot on the canvas. It take inputs of the image_size, number of cells (num_spots), distance between spots (min_distance_between_spots) and return the (x,y) coordinate of the center of all generated cells. The purpose is to make sure they have enouth spaces between, so they won't overlap in the generated images.

EllipseShape.m is a function file that generate ellipse_mask for each cells. It takes inputs as the base spot_radius (spot_radius), image_size for meshgrid, (x,y) coordinator for each center of the mask. The output is the ellipse_mask for a given coordinator(x,y) as the center for each cell.

ImageGenerator.m is a function file that generate the data for generated fluorescent image (img_blurred, uint16), and labeled image (label_img, uint8). It takes input of the image information (width, height) and the cell information (num of cells (num_spots), size (spot_radius), the intensity range (spot_intensity_range)). The output will be the data for the generated fluorescent image (uint16) and a labeled image with unique instance segmentation labels for each cells (unit18). This function will display these two images side by side in the figure in MATLAB environment and also saved them as a PNG file.

ImageGeneratorNoFig.m is a function identical to ImageGenerator.m but will not show any figures in MATLAB environment or save file. The output are the data(matrix) for the generated image and labeled image. This will be used in batch processing.

## Customization:
**1.	Image size:** Change the Image_size to define the pixels for the output images

**2.	Cell numbers:** Change num_spots to adjust the number of generated cells

**3.	Size of cells:** Change spot_radius to adjust the size of the cells

**4.	Fluorescent Intensity:** Since the fluorescent images can usually adjusted for visualization, here I defined the range for the fluorescent intensity, instead of absolute intensity. The intensity of each cell will be a random number in the intensity range, so a larger range will result in some cells are very bright and some are dim. A smaller range will generate cell in similar fluorescent intensity.

**5.	Distance between cells:** you can adjust min_distance_between_spots to change the minimum distance between cells. It is recommended for this value to be at least 3*spot_radius to avoid overlap.

**6.	Export image name:** You can change file_name_for_save_fluorescent and file_name_for_save_label for the export file name and path. 

**7. Batch Run: ** In batch_run.m, you can define how many images you want to generate by change n. You can also change the saved file name and path by changing "file_name_fluo" and "file_name_label".

