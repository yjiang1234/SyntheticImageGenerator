% Image size and parameters
image_width = 128; % In Pixals 
image_height = 128;
num_spots = 9; % Number of fluorescent spots
spot_radius = 8; % Average radius of the fluorescnt sports
spot_intensity_range = [1000, 3000];  % Intensity range of the spots
min_distance_between_spots = 40; %Minimum distance to avoid overlap
noise_level = 100; %set the camera noise level


file_name_for_save_fluorescent = 'fluorescent_image.png';
file_name_for_save_label = 'label_image.png';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ImageGenerator(image_width,image_height,num_spots,spot_radius,spot_intensity_range,min_distance_between_spots,noise_level);