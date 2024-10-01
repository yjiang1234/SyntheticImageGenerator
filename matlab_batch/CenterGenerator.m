% Generate n random spot on the canvas. Make sure they have enouth
% spaces between, so they won't overlap in the generated images.
% Take inputs of the image_size, number of cells (num_spots),
% distance between spots (min_distance_between_spots)
% Return the (x,y) coordinate of the center of all generated cells.
function spot_centers = CenterGenerator(num_spots,image_size,min_distance_between_spots)


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
    
        % Store the center of the new ellipse
        spot_count = spot_count + 1;
        spot_centers(spot_count, :) = [x, y];
    end
end
