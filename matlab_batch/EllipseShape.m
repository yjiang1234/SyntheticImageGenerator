%Generate ellipse_mask for each cells.
% Take inputs as the base spot_radius (spot_radius), image_size for
% meshgrid, (x,y) coordinator for each center of the mask
% Output the ellipse_mask for a given coordinator(x,y) as the
% center for each cell.

function ellipse_mask= EllipseShape(spot_radius,image_size,x,y)
   % Randomly generate the radius and intensity for each spot
    a = spot_radius + randi([-3, 3]); 
    b = spot_radius + randi([-2,2]); % Add variability to the radius
    

    % Randomly generate the angle of rotation (in radians)
    theta = rand() * 2 * pi;  % Random angle between 0 and 2*pi
    

    
    % Draw a circular spot
    
    [X, Y] = meshgrid(1:image_size(2), 1:image_size(1));
    ellipse_mask = (((X - x)*cos(theta) + (Y-y) * sin(theta)).^2 / a^2) + ...
        (((-X + x) * sin(theta)+ (Y - y)*cos(theta)).^2/ b^2) <= 1;
    %img(ellipse_mask) = min(img(ellipse_mask)+ intensity,max_uint16);
end

