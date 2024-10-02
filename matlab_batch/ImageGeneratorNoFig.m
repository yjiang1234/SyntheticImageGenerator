
% Generate the data for generated fluorescent image (img_blurred,
% uint16), and labeled image (label_img, uint8)
% Takes input of the image information (width, height) and the cell
% information (num of cells (num_spots), size (spot)radius), the
% intensity range (spot_intensity_range))
% Don't generate figures. only generate data for further save and
% imshow()
function [img_blurred, label_img] = ImageGeneratorNoFig(width,height,num_spots,spot_radius,spot_intensity_range,min_distance_between_spots,noise_level)


    % Image size and parameters
    image_size = [width, height]; %Dimensions of the images
    %num_spots = 9; % Number of fluorescent spots
    %spot_radius = 8; % Average radius of the fluorescnt sports
    %spot_intensity_range = [1000, 3000];  % Intensity range of the spots
    %min_distance_between_spots = 40; %Minimum distance to avoid overlap
    %noise_level = 100; %set the camera noise level
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
    img_double = double(img);
    
    img_blurred = imgaussfilt(double(img), 1);
    
    % Add Gaussian noise
    % Generate Gaussian noise in the original scale (65535)
    noise = noise_level*randn(size(img_blurred));
    % Add noise to the blurred image
    img_blurred_with_noise = img_blurred + noise;
    % make sure the value is within the range for uint16
    img_blurred_with_noise = max(min(img_blurred_with_noise, 65535), 0);
    
    img_blurred = uint16(img_blurred_with_noise);  % Convert back to uint16 and limit values
    
   
end
