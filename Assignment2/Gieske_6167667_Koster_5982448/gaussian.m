function G = gaussian(sigma)
    %Create range for vector x
    x = -3*sigma:3*sigma;
    %Calculate Gaussian vector for filter
    G = (1/(sigma*sqrt(2*pi))) * exp(-((x.^2)/(2*sigma^2)));
    %Normalize filter
    G = G / sum(G);
end
