function best_tform = imagetransform(im1, im2, N)
    %Load images
    [pathstr,name,ext] = fileparts(im1);
    if ext == '.pgm'
        ext
        im1 = im2single(imread(im1));
        im2 = im2single(imread(im2));
    else
        im1 = im2single(rgb2gray(imread(im1)));
        im2 = im2single(rgb2gray(imread(im2)));
    end
    %Detect interest points in each image. Characterize the local
    %appearance of the regions around interest points 
    [frames1, desc1] = vl_sift(im1);
    [frames2, desc2] = vl_sift(im2);
    %Set of supposed matches between region descriptors in each image
    [matches] = vl_ubcmatch(desc1, desc2);
    %Repeat N times
    best_trans = [];
    best_inliers = 0;
    for i=1:N
        inliers = 0;
        A = [];
        b = [];
        %Create A and b of match point and add to overall A and b
        %Need 3 matches to solve transformation
        for j=1:4
            %Get random match
            j = round(rand * N);
            if j < 1
                j = 1;
            elseif j > size(matches,2)
                j = size(matches,2);
            end
            %Retrieve indexes for matches
            index1 = matches(1,j);
            index2 = matches(2,j);
            x = frames1(1,index1);
            y = frames1(2,index1);
            x_prime = frames2(1,index2);
            y_prime = frames2(2,index2);
            %Get transformation
            A = [A; x y 0 0 1 0; 0 0 x y 0 1];
            b = [b; x_prime; y_prime];
        end
        %Compute transformation vector
        transformationvector = pinv(A) * b;
        %Use transformation to transform all matches
        for m=1:size(matches,2)
            index1 = matches(1,m);
            x = frames1(1,index1);
            y = frames1(2,index1);
            A = [x y 0 0 1 0; 0 0 x y 0 1];
            test = A * transformationvector;
            x_prime_trans = test(1);
            y_prime_trans = test(2);
            %Get true xprime yprime
            index2 = matches(2,m);
            x_prime_true = frames2(1,index2);
            y_prime_true = frames2(2,index2);
            x_distance = abs(x_prime_trans - x_prime_true);
            y_distance = abs(y_prime_trans - y_prime_true);
            %Count inliers
            if (x_distance < 11 && y_distance < 11)
                inliers = inliers +1;
            end
        end
        %Check if current transformation is better
        if inliers > best_inliers;
            best_trans = transformationvector;
            best_inliers = inliers;
        end
        %Create matrix for tform
        best_inliers
        best_A = [best_trans(1), best_trans(2), 0;
            best_trans(3), best_trans(4), 0;
            best_trans(5), best_trans(6), 1;
            ];
    end
    %Create tform from best matrix
    best_tform = maketform('affine', best_A);
end