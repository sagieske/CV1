function tracking(image_path,sigma, thresh,n_harris, n_opticalflow)
    %Go to directory containing images
    if exist(image_path,'dir') == false
        fprintf('Chosen directory does not exist: %s\n', image_path);
    else
        cd(image_path)
        imagefiles = dir('*.jpeg'); 
        %If no jpeg found, get jpg
        if size(imagefiles,1) == 0
            imagefiles = dir('*.jpg');  
        end

        %Load all images
        for i=1:length(imagefiles)
            image_file = imagefiles(i).name;
            currentimage = im2double(rgb2gray(imread(image_file)));
            images{i} = currentimage;
        end

        %Locate feature points for first frame
        [Hmat,r,c] = harris(imagefiles(1).name, sigma, thresh,n_harris);
        interestpoints = [r c];
        
        writerObj = VideoWriter('peaks.avi');
        open(writerObj);
        %Loop through images to calculate flow
        for i=1:size(imagefiles)-1
            %Create 1d Gaussian filter
            G = gaussian(sigma);
            x_range = -n_harris*sigma:n_harris*sigma;
            %Take the derivative of 1d Gaussian filter
            Gd = G' * (-(x_range/(sigma^2)));
            %Convolve image with derivative of Gaussian in x-direction
            im_x = conv2(images{i}, Gd, 'same');
            %Convolve image with derivative of Gaussian in y-direction
            im_y = conv2(images{i}, transpose(Gd),'same');
            %Get gradient with respect to time
            im_t = imabsdiff(images{i}, images{i+1});
            %Initialize V matrix to store v and corresponding coordinates,
            %initialize counter for rows in V matrix
            V_total = zeros(size(interestpoints,1), 4);
            count = 1;
            
            %Loop through interest points
            for j=1:size(interestpoints,1)
                %Get coordinates for current point of interest
                x_points = interestpoints(j,1);
                y_points = interestpoints(j,2);
                % Calculate corner points of block region
                y_min = y_points-(floor(n_opticalflow/2));
                y_max = y_points+(floor(n_opticalflow/2));
                x_min = x_points-(floor(n_opticalflow/2));
                x_max = x_points+(floor(n_opticalflow/2));
                
                % Do not let block corner points be outside imagesize,
                % if so continue to next interespoint
                if x_min < 1 || y_min <1 || y_max > size(images{i},2) || x_max > size(images{i},1)
                    continue
                else
                    %Get regions from x_derivative, y_derivative, t_derivative
                    region_im_x = im_x(x_min:x_max, y_min:y_max);
                    region_im_y = im_y(x_min:x_max, y_min:y_max);
                    region_im_t = im_t(x_min:x_max, y_min:y_max); 
                    %Calculate v
                    v = calculate_opticalflowmatrix(region_im_x, region_im_y, region_im_t)
                    V_total(count, :) = [y_points x_points v(2) v(1)];
                    %Update interestpoints by adding the optical flow vectors.
                    interestpoints(j,1) = x_points + v(1);
                    interestpoints(j,2) = y_points + v(2);
                    count = count + 1;
                end
            end
            %Plot image as background
            figure, imshow(images{i});
            hold on;
            %Plot the optical flow
            quiver(V_total(:,1),V_total(:,2), V_total(:,3), V_total(:,4));
            plot(interestpoints(:,2),interestpoints(:,1), 'r.', 'MarkerSize', 10);
            F = getframe;
            writeVideo(writerObj, F);
            
        end
        close(writerObj);
        %Return to previous path (for debugging)
        cd('../')
        
    end