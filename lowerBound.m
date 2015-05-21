function [frames, nchapeu] = lowerBound (ss, sc)
    nchapeu = ss + (2 * sc);
    frames = 2 * sc;
end
