function v = calculate_opticalflowmatrix(im_x_region, im_y_region, im_t_region)
            A= [im_x_region im_y_region];
            %Create b
            b = -1.* reshape(im_t_region, numel(im_t_region), 1);
            %Calculate v
            a = A' * A;
            ab = A' * b;
            v = inv(a) * ab;