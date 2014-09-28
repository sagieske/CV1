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
        %for i=1:length(imagefiles)
            %image_file = imagefiles(i).name
            %currentimage = im2double(rgb2gray(imread(image_file)));
            %images{i} = currentimage;
        %end

        %Locate feature points for first frame
        %TODO: A LOT OF FEATURE POINTS THAT ARE NOT THE BALL?
        [Hmat,r,c] = harris(imagefiles(1).name, sigma, thresh,n_harris)
        %Loop through images to calculate flow?
        for i=1:length(imagefiles)-1
            opticalflow(imagefiles(i).name, imagefiles(i+2).name, sigma, n_opticalflow)
        end

        %Return to previous path (for debugging)
        cd('../')
    end