function [frames, nchapeu] = schoute (ss, sc)
    nchapeu = ss + (2.39 * sc);
    frames = 2.39 * sc;
end
