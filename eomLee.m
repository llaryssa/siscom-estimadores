function [frames, nchapeu] = eomLee (L, ss, sc)
    thres = 0.001;
    ended = 0;
    yant = 2;

    while (~ended)
        e = exp(1); % num de euler
        b = L / (yant * sc + ss);
        y = (1 - e^(-1/b)) / (b * (1 - (1 + 1/b)*e^(-1/b)));      
    
        frames = y*sc;
        nchapeu = frames/b;

        frames = round(frames);
        nchapeu = round(nchapeu);
    
        if abs(yant-y) < thres 
            ended = 1;
        else
            ended = 0;
        end
        yant = y;
    end    
end
