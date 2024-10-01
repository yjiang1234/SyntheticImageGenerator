% generate n pairs of fluorescent and labeled images for further training.

%%%%%%%%%%%%% Image input%%%%%%%%%%%%%%
n = 3; % Number of pairs of images to generate
image_width = 128; % In Pixals 
image_height = 128;
num_spots = 9; % Number of fluorescent spots
spot_radius = 8; % Average radius of the fluorescnt sports
spot_intensity_range = [1000, 3000];  % Intensity range of the spots
min_distance_between_spots = 40; %Minimum distance to avoid overlap
file_name_fluo = 'fluorescent_image_'
file_name_label = 'label_image_'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:n
    [img_blurred, label_img] = ImageGeneratorNoFig(image_width,image_height,num_spots,spot_radius,spot_intensity_range,min_distance_between_spots);
    imwrite(img_blurred,strcat(file_name_fluo,int2str(i),'.png'));
    imwrite(label_img,strcat(file_name_label,int2str(i),'.png'));
    
end
