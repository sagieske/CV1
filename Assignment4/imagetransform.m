function imagetransform(im1, im2, N)
    [pathstr,name,ext] = fileparts(im1);
    if ext == '.pgm'
        ext
        im1 = im2single(imread(im1));
        im2 = im2single(imread(im2));
    else
        im1 = im2single(rgb2gray(imread(im1)));
        im2 = im2single(rgb2gray(imread(im2)));
    end
    figure;
    subplot(1,2,1);
    imshow(im1);
    subplot(1,2,2);
    imshow(im2);
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
        for j=1:5
            j = round(rand * N);
            if j < 1
                j = 1;
            elseif j > size(matches,2)
                j = size(matches,2);
            end
                
                
            index1 = matches(1,j);
            index2 = matches(2,j);
            x = frames1(1,index1);
            y = frames1(2,index1);
            x_prime = frames2(1,index2);
            y_prime = frames2(2,index2);
            A = [A; x y 0 0 1 0; 0 0 x y 0 1];
            b = [b; x_prime; y_prime];
        end
        %Compute transformation vector
        transformationvector = pinv(A) * b;
        info_forplots = zeros(size(matches,2), 6);
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
            if (x_distance < 11 && y_distance < 11)
                inliers = inliers +1;
            end
        end
        if inliers > best_inliers;
            best_trans = transformationvector;
            best_inliers = inliers
        best_A = [best_trans(1), best_trans(2), 0;
            best_trans(3), best_trans(4), 0;
            best_trans(5), best_trans(6), 1;
            ]
        end
        
        
        %subplot(1,2,1);
        %imshow(im1);
        %hold on;
        %plot(rounded_coordinates(:,1),rounded_coordinates(:,2), 'r.', 'MarkerSize', 10);
        %hold off;
        %subplot(1,2,2);
        %imshow(im2);
        %ah=axes('position',[1,size(im1,1),1,size(im1,2)],'visible','off'); % <- select your pos...
        %size(rounded_coordinates,1);
        %for m=1:size(rounded_coordinates,1)
        %    line([rounded_coordinates(m,1),rounded_coordinates(m,2)],[rounded_coordinates(m,1),rounded_coordinates(m,2)],'parent',ah,'linewidth',5);
        %end
        

            
        %size(info_forplots)
        % plot correct x, y image 1
        %subplot(1,2,1);
        %caption = sprintf('FIRST IMAGE');
        %imshow(im1);
        %hold on;
        %plot(info_forplots(:,1),info_forplots(:,2), 'r.', 'MarkerSize', 10);
        %[xa1 ya1] = ds2nfu(info_forplots(:,1),info_forplots(:,2));


        
        
        %subplot(1,2,2);
        %caption = sprintf('CALCULATED PRIMES');
        %imshow(im2);
        %hold on;
        %plot(info_forplots(:,3),info_forplots(:,4), 'r.', 'MarkerSize', 10);
        %[xa2 ya2] = ds2nfu(info_forplots(:,3),info_forplots(:,4));
        
        
        % draw the lines
       % for k=1:numel(xa1)
        %    annotation('line',[xa1(k) xa2(k)],[ya1(k) ya2(k)],'color','r');
        %end

    end
    best_tform = maketform('affine', best_A)
    [J, cdata, rdata] = imtransform(im1, best_tform);
    [K, cdata2, rdata2] = imtransform(im2, best_tform);
    rounded_coordinates = round(info_forplots);
    figure;
    subplot(1,2,1);
    imshow(im1);
    subplot(1,2,2);
    imshow(K);
end