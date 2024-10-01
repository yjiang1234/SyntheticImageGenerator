% Generate the data for generated fluorescent image (img_blurred,
% uint16), and labeled image (label_img, uint8)
% Takes input of the image information (width, height) and the cell
% information (num of cells (num_spots), size (spot)radius), the
% intensity range (spot_intensity_range)).The output will be the data 
% for the generated fluorescent image (uint16) and a labeled image with
% unique instance segmentation labels for each cells (unit18). 
% This function will display these two images side by side in the figure 
% in MATLAB environment and also saved them as a PNG file.

function [img_blurred, label_img] = ImageGenerator(width,height,num_spots,spot_radius,spot_intensity_range,min_distance_between_spots)


    % Image size and parameters
    image_size = [width, height]; %Dimensions of the images
    %num_spots = 9; % Number of fluorescent spots
    %spot_radius = 8; % Average radius of the fluorescnt sports
    %spot_intensity_range = [1000, 3000];  % Intensity range of the spots
    min_distance_between_spots = 40; %Minimum distance to avoid overlap
    
    file_name_for_save_fluorescent = 'fluorescent_image.png';
    file_name_for_save_label = 'label_image.png';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    max_uint16 = double(intmax("uint16"));
    
    % Create a blank black image (in uint16 format
    img = zeros(image_size, 'uint16');
    label_img = zeros(image_size, 'uint8');  % Label image for instance segmentation
    
    % Generate random spots to simulate fluorescence without overlap
    spot_count = 0; %Keep track of how many spots have been generated
    spot_centers = CenterGenerator(num_spots,image_size,min_distance_between_spots);
    for i = 1:num_spots
        x = spot_centers(i,1);
        y = spot_centers(i,2);        
            
        ellipse_mask= EllipseShape(spot_radius,image_size,x,y);
    
        % Random intensity for the spot
        intensity = randi(spot_intensity_range);  
    
        img(ellipse_mask) = min(img(ellipse_mask)+ intensity,max_uint16);
    
        % Assign a unique label to the ellipse in the label image
        label_img(ellipse_mask) = spot_count + 1;  % Label starts from 1
        
        % Store the center of the new ellipse
        spot_count = spot_count + 1;
        spot_centers(spot_count, :) = [x, y];
    
    end
    
    % Apply Gaussian blur to simulate fluorescence glow
    img_blurred = imgaussfilt(double(img), 1);
    img_blurred = uint16(min(img_blurred, max_uint16));  % Convert back to uint16 and limit values
    
    
    % Display the synthetic fluorescent image (monochromatic)
    figure;
    
    % Left: Synthetic Fluorescnet Image
    ax_1 = subplot(1,2,1);
    imshow(img_blurred,[]);
    % use a custom colormap (false color in yellow)
    colormap(ax_1,[linspace(0, 1, max_uint16)' linspace(0, 1, max_uint16)' zeros(max_uint16, 1)]);  
    colorbar;
    axis on;
    title('Synthetic Fluorescent Image');
    % Save the img_blurred data as png image
    imwrite(img_blurred,file_name_for_save_fluorescent);
    
    % Right: show the instance segmentation labeled Image
    ax_2 = subplot(1,2,2);
    imshow(label_img, []);
    colormap(ax_2, parula);
    colorbar;
    axis on;
    title("Labeled Image")
    
    % Save the label_img data as png image
    imwrite(label_img,file_name_for_save_label);
end
