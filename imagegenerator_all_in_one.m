%%%%%%%%%%%%%%%%%% User Parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Image size and parameters
image_size = [128, 128]; %Dimensions of the images

num_spots = 9; % Number of fluorescent spots
spot_radius = 8; % Average radius of the fluorescnt sports
spot_intensity_range = [1000, 3000];  % Intensity range of the spots
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
while spot_count < num_spots

     % Randomly generate the center of each spot
    x = randi([1, image_size(2)]);
    y = randi([1, image_size(1)]);

    %check if the new ellipse is sufficiently far from all existing
    %ellipses
    if spot_count > 0
        distances = sqrt ((spot_centers(1:spot_count, 1)-x).^2 + (spot_centers(1:spot_count,2) - y).^2);
        if any(distances < min_distance_between_spots)
            continue;
        end
    end

                 
   % Randomly generate the radius and intensity for each spot
    a = spot_radius + randi([-3, 3]); 
    b = spot_radius + randi([-2,2]); 
    

    % Randomly generate the angle of rotation (in radians)
    theta = rand() * 2 * pi;  % Random angle between 0 and 2*pi
    
    % Random intensity for the spot
    intensity = randi(spot_intensity_range);  
    
    % Draw a circular spot
    [X, Y] = meshgrid(1:image_size(2), 1:image_size(1));
    ellipse_mask = (((X - x)*cos(theta) + (Y-y) * sin(theta)).^2 / a^2) + ...
        (((-X + x) * sin(theta)+ (Y - y)*cos(theta)).^2/ b^2) <= 1;
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
imwrite(img_blurred,file_name_for_save_fluorescent) 

% Right: show the instance segmentation labeled Image
ax_2 = subplot(1,2,2);
imshow(label_img, []);
colormap(ax_2, parula);
colorbar;
axis on;
title("Labeled Image")

% Save the label_img data as png image
imwrite(label_img,file_name_for_save_label)