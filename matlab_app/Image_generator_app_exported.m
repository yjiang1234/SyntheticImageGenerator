classdef Image_generator_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        NoiseEditField                 matlab.ui.control.NumericEditField
        NoiseEditFieldLabel            matlab.ui.control.Label
        DistanceEditField              matlab.ui.control.NumericEditField
        DistanceEditFieldLabel         matlab.ui.control.Label
        RepeatEditField                matlab.ui.control.NumericEditField
        RepeatEditFieldLabel           matlab.ui.control.Label
        FluoIntensityRangeSlider       matlab.ui.control.Slider
        FluoIntensityRangeSliderLabel  matlab.ui.control.Label
        CellNoEditField                matlab.ui.control.NumericEditField
        CellNoEditFieldLabel           matlab.ui.control.Label
        SizeSlider                     matlab.ui.control.Slider
        SizeSliderLabel                matlab.ui.control.Label
        SaveasEditField                matlab.ui.control.EditField
        SaveasEditFieldLabel           matlab.ui.control.Label
        WidthEditField                 matlab.ui.control.NumericEditField
        WidthEditFieldLabel            matlab.ui.control.Label
        LengthEditField                matlab.ui.control.NumericEditField
        LengthEditFieldLabel           matlab.ui.control.Label
        BatchButton                    matlab.ui.control.Button
        PreviewButton                  matlab.ui.control.Button
        RightPanel                     matlab.ui.container.Panel
        LabelAxes2                     matlab.ui.control.UIAxes
        FluorescentAxes                matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    methods (Access = private)
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
            
                %check if the new cell is sufficiently far from all existing cells
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
           
        end

        % Generate the data for generated fluorescent image (img_blurred,
        % uint16), and labeled image (label_img, uint8)
        % Takes input of the image information (width, height) and the cell
        % information (num of cells (num_spots), size (spot)radius), the
        % intensity range (spot_intensity_range))
        % Don't generate figures. only generate data for further save and
        % imshow()

        function [img_blurred, label_img] = ImageGeneratorNoFig(width,height,num_spots,spot_radius,spot_intensity_range, min_distance_between_spots,noise_value)


            % Image size and parameters
            image_size = [width, height]; %Dimensions of the images
            %num_spots = 9; % Number of fluorescent spots
            %spot_radius = 8; % Average radius of the fluorescnt sports
            %spot_intensity_range = [1000, 3000];  % Intensity range of the spots
            %min_distance_between_spots = 40; %Minimum distance to avoid overlap
            
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
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: LengthEditField
        function LengthEditFieldValueChanged(app, event)

            
        end

        % Value changed function: WidthEditField
        function WidthEditFieldValueChanged(app, event)
    
            
        end

        % Button pushed function: PreviewButton
        function PreviewButtonPushed(app, event)
            % Image size and parameters
            width = app.WidthEditField.Value;
            height = app.LengthEditField.Value;
            num_spots = app.CellNoEditField.Value;
            spot_radius = app.SizeSlider.Value;
            min_distance_between_spots = app.DistanceEditField.Value; %Minimum distance to avoid overlap
            noise_level = app.NoiseEditField.Value; %set the camera noise level
            spot_intensity_range = [1000,1000 + round(app.FluoIntensityRangeSlider.Value *200)];
         
            image_size = [width, height]; %Dimensions of the images
            %num_spots = 9; % Number of fluorescent spots
            %spot_radius = 8; % Average radius of the fluorescnt sports
            %spot_intensity_range = [1000, 3000];  % Intensity range of the spots
            
            %min_distance_between_spots = 40; %Minimum distance to avoid overlap
            
            %file_name_for_save_fluorescent = 'fluorescent_image.png';
            %file_name_for_save_label = 'label_image.png';
            max_uint16 = double(intmax("uint16"));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [img_blurred, label_img] = ImageGeneratorNoFig(width,height,num_spots,spot_radius,spot_intensity_range,min_distance_between_spots,noise_level);

            % Display the synthetic fluorescent image (monochromatic)
            %figure;
            
            % Left: Synthetic Fluorescnet Image
            ax_1 = app.FluorescentAxes;
           
            imshow(img_blurred,[],'Parent',ax_1);
          
            % use a custom colormap 
            
            %colormap(ax_1, [linspace(0, 1, max_uint16)' linspace(0, 1, max_uint16)' zeros(max_uint16, 1)]);
            colormap(ax_1); 
            colorbar(ax_1);
            ax_1.XLim = [0 width];
            
            % Right: show the instance segmentation labeled Image
            ax_2 = app.LabelAxes2;

            imshow(label_img, [],'Parent',ax_2);
            colormap(ax_2, parula);
            colorbar(ax_2);
            axis on;

        end

        % Button pushed function: BatchButton
        function BatchButtonPushed(app, event)
            iter = app.RepeatEditField.Value;
            file_name = app.SaveasEditField.Value;

            width = app.WidthEditField.Value;
            height = app.LengthEditField.Value;
            num_spots = app.CellNoEditField.Value;
            spot_radius = app.SizeSlider.Value;
            spot_intensity_range = [1000,3000];
            min_distance_between_spots = app.DistanceEditField.Value; %Minimum distance to avoid overlap
            noise_value = app.NoiseEditField.Value; %set the camera noise level

            for i = 1:iter
                [img_blurred, label_img] = ImageGeneratorNoFig(width,height,num_spots,spot_radius,spot_intensity_range,min_distance_between_spots,noise_value);
                imwrite(img_blurred,strcat(file_name,'_', int2str(i),'.png'));
                imwrite(label_img,strcat('label_',file_name,'_',int2str(i),'.png'));
                
            end

        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {285, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {285, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create PreviewButton
            app.PreviewButton = uibutton(app.LeftPanel, 'push');
            app.PreviewButton.ButtonPushedFcn = createCallbackFcn(app, @PreviewButtonPushed, true);
            app.PreviewButton.Position = [15 28 100 23];
            app.PreviewButton.Text = 'Preview';

            % Create BatchButton
            app.BatchButton = uibutton(app.LeftPanel, 'push');
            app.BatchButton.ButtonPushedFcn = createCallbackFcn(app, @BatchButtonPushed, true);
            app.BatchButton.Position = [119 27 100 23];
            app.BatchButton.Text = 'Batch';

            % Create LengthEditFieldLabel
            app.LengthEditFieldLabel = uilabel(app.LeftPanel);
            app.LengthEditFieldLabel.HorizontalAlignment = 'right';
            app.LengthEditFieldLabel.Position = [15 371 42 22];
            app.LengthEditFieldLabel.Text = 'Length';

            % Create LengthEditField
            app.LengthEditField = uieditfield(app.LeftPanel, 'numeric');
            app.LengthEditField.ValueChangedFcn = createCallbackFcn(app, @LengthEditFieldValueChanged, true);
            app.LengthEditField.Position = [72 371 30 22];
            app.LengthEditField.Value = 128;

            % Create WidthEditFieldLabel
            app.WidthEditFieldLabel = uilabel(app.LeftPanel);
            app.WidthEditFieldLabel.HorizontalAlignment = 'right';
            app.WidthEditFieldLabel.Position = [119 371 36 22];
            app.WidthEditFieldLabel.Text = 'Width';

            % Create WidthEditField
            app.WidthEditField = uieditfield(app.LeftPanel, 'numeric');
            app.WidthEditField.ValueChangedFcn = createCallbackFcn(app, @WidthEditFieldValueChanged, true);
            app.WidthEditField.Position = [170 371 32 22];
            app.WidthEditField.Value = 128;

            % Create SaveasEditFieldLabel
            app.SaveasEditFieldLabel = uilabel(app.LeftPanel);
            app.SaveasEditFieldLabel.HorizontalAlignment = 'right';
            app.SaveasEditFieldLabel.Position = [15 88 57 22];
            app.SaveasEditFieldLabel.Text = 'Save as...';

            % Create SaveasEditField
            app.SaveasEditField = uieditfield(app.LeftPanel, 'text');
            app.SaveasEditField.Position = [87 88 100 22];

            % Create SizeSliderLabel
            app.SizeSliderLabel = uilabel(app.LeftPanel);
            app.SizeSliderLabel.HorizontalAlignment = 'right';
            app.SizeSliderLabel.Position = [31 232 28 22];
            app.SizeSliderLabel.Text = 'Size';

            % Create SizeSlider
            app.SizeSlider = uislider(app.LeftPanel);
            app.SizeSlider.Limits = [0 10];
            app.SizeSlider.Position = [117 242 156 3];
            app.SizeSlider.Value = 8;

            % Create CellNoEditFieldLabel
            app.CellNoEditFieldLabel = uilabel(app.LeftPanel);
            app.CellNoEditFieldLabel.HorizontalAlignment = 'right';
            app.CellNoEditFieldLabel.Position = [15 321 48 22];
            app.CellNoEditFieldLabel.Text = 'Cell No.';

            % Create CellNoEditField
            app.CellNoEditField = uieditfield(app.LeftPanel, 'numeric');
            app.CellNoEditField.Position = [71 321 32 22];
            app.CellNoEditField.Value = 9;

            % Create FluoIntensityRangeSliderLabel
            app.FluoIntensityRangeSliderLabel = uilabel(app.LeftPanel);
            app.FluoIntensityRangeSliderLabel.HorizontalAlignment = 'right';
            app.FluoIntensityRangeSliderLabel.Position = [1 179 118 22];
            app.FluoIntensityRangeSliderLabel.Text = 'Fluo. Intensity Range';

            % Create FluoIntensityRangeSlider
            app.FluoIntensityRangeSlider = uislider(app.LeftPanel);
            app.FluoIntensityRangeSlider.Limits = [0 10];
            app.FluoIntensityRangeSlider.Position = [122 189 152 3];
            app.FluoIntensityRangeSlider.Value = 10;

            % Create RepeatEditFieldLabel
            app.RepeatEditFieldLabel = uilabel(app.LeftPanel);
            app.RepeatEditFieldLabel.HorizontalAlignment = 'right';
            app.RepeatEditFieldLabel.Position = [14 119 58 22];
            app.RepeatEditFieldLabel.Text = 'Repeat';

            % Create RepeatEditField
            app.RepeatEditField = uieditfield(app.LeftPanel, 'numeric');
            app.RepeatEditField.Position = [88 119 46 22];

            % Create DistanceEditFieldLabel
            app.DistanceEditFieldLabel = uilabel(app.LeftPanel);
            app.DistanceEditFieldLabel.HorizontalAlignment = 'right';
            app.DistanceEditFieldLabel.Position = [119 321 52 22];
            app.DistanceEditFieldLabel.Text = 'Distance';

            % Create DistanceEditField
            app.DistanceEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DistanceEditField.Position = [185 321 35 22];
            app.DistanceEditField.Value = 40;

            % Create NoiseEditFieldLabel
            app.NoiseEditFieldLabel = uilabel(app.LeftPanel);
            app.NoiseEditFieldLabel.HorizontalAlignment = 'right';
            app.NoiseEditFieldLabel.Position = [15 278 36 22];
            app.NoiseEditFieldLabel.Text = 'Noise';

            % Create NoiseEditField
            app.NoiseEditField = uieditfield(app.LeftPanel, 'numeric');
            app.NoiseEditField.Position = [72 278 32 22];
            app.NoiseEditField.Value = 100;

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create FluorescentAxes
            app.FluorescentAxes = uiaxes(app.RightPanel);
            title(app.FluorescentAxes, 'Synthetic Fluorescent Image')
            app.FluorescentAxes.XTick = [];
            app.FluorescentAxes.YTick = [];
            app.FluorescentAxes.Position = [12 251 300 185];

            % Create LabelAxes2
            app.LabelAxes2 = uiaxes(app.RightPanel);
            title(app.LabelAxes2, 'Labeled Image')
            app.LabelAxes2.XTick = [];
            app.LabelAxes2.YTick = [];
            app.LabelAxes2.Position = [12 27 300 185];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Image_generator_app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end