function G = gaussian(sigma)
    x = -3*sigma:3*sigma;
    G = (1/(sigma*sqrt(2*pi))) * exp(-((x.^2)/(2*sigma^2)));
    G = G / sum(G);
end
