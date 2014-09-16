function G = gaussian(sigma)
    x = -5*sigma:5*sigma;
    G = (1/(sigma*sqrt(2*pi))) * exp(-((x.^2)/(2*sigma^2)));
end
