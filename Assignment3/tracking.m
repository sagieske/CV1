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
        %TODO: A LOT OF FEATURE POINTS THAT ARE NOT THE BALL?
        [Hmat,r,c] = harris(imagefiles(1).name, sigma, thresh,n_harris);
        interestpoints = [r c]
        size(interestpoints)
        %Loop through images to calculate flow?
        for i=1:length(imagefiles)-1
            %calculate v matrix with point r,c as center??
            %Create 1d Gaussian filter
            G = gaussian(sigma);
            x_range = -3*sigma:3*sigma;
            %Take the derivative of 1d Gaussian filter
            Gd = G' * (-(x_range/(sigma^2)));
            %Convolve image with derivative of Gaussian in x-direction
            im_x = conv2(images{i}, Gd, 'same');
            %Convolve image with derivative of Gaussian in y-direction
            im_y = conv2(images{i}, transpose(Gd),'same');
            %Get gradient with respect to time
            im_t = imabsdiff(images{i}, images{i+1});
            % Create block region for every interestpoint, with
            % interestpoint in middle
            V_total = zeros(size(interestpoints,1), 4);
            count = 1;
            for j=1:size(interestpoints,1)
                r = interestpoints(j,1);
                c = interestpoints(j,2);
                % Calculate corner points of block region
                x_min = c-(floor(n_opticalflow/2));
                x_max = c+(floor(n_opticalflow/2));
                y_min = r-(floor(n_opticalflow/2));
                y_max = r+(floor(n_opticalflow/2));
                
                % Do not let block corner points be outside imagesize,
                % continue to next interespoint
                if x_min < 1 || y_min <1 || y_max > size(images{i},2) || x_max > size(images{i},1)
                    continue
                else
                    %Get regions from x_derivative, y_derivative, t_derivative
                    region_im_x = im_x(x_min:x_max, y_min:y_max);
                    region_im_y = im_y(x_min:x_max, y_min:y_max);
                    region_im_t = im_t(x_min:x_max, y_min:y_max); 
                    %Calculate v
                    v =calculate_opticalflowmatrix(region_im_x, region_im_y, region_im_t)
                    V_total(count, :) = [c r v(1) v(2)]
                    %Update interestpoints with optical flow vectors. Round
                    %the optical flow vectors to get new point
                    interestpoints(j,1) = c+round(v(1));
                    interestpoints(j,2) = r+round(v(2));
                    count = count + 1;
                end
            end
            %Plot the optical flow
            figure, imshow(images{i});
            hold on;
            midofblock = n_opticalflow/2
            quiver(V_total(:,1),V_total(:,2), V_total(:,3), V_total(:,4));
            
            
            %opticalflow(imagefiles(i).name, imagefiles(i+2).name, sigma, n_opticalflow)
        end

        %Return to previous path (for debugging)
        cd('../')
    end