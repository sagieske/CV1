function v = calculate_opticalflowmatrix(im_x_region, im_y_region, im_t_region)
            %Reshape to vectors
            im_x_region = reshape(im_x_region, numel(im_x_region), 1);
            im_y_region = reshape(im_y_region, numel(im_y_region), 1);
            im_t_region = reshape(im_t_region, numel(im_t_region), 1);
            
            %A is a matrix of x-derivative, y-derivative
            A= [im_x_region im_y_region];
            %b is a vector of the negative of the t-derivative
            b = -1.* im_t_region;
            %Calculate v
            ata = A' * A;
            pseudo_inverse = inv(ata) * A';
            v = pseudo_inverse * b;