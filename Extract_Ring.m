function [ Ring ] = Extract_Ring(spectral_Region, radius_Outer, radius_Inner )
%Given an origin and two radi, a ring can be extracted from the fourier
%space by testing if a point lies in the circle definied by the outer
%radius, then testing if this point does NOT lie in the circle defined by
%the inner radius. If the point satisfys this condition it can be
%extracted.


[h w] = size(spectral_Region); % Get the dimentions
x = h/2; y = w/2 %The origin
%Ring = spectral_Region;
Ring = complex(double(zeros(h,w)));
for i = 1 : h %loop width
    for j = 1 : w % loop height
        dist = sqrt( (x - i)^2 + (y - j)^2 ); %Distaance of point from origin (Circle centre)
        if (dist <= radius_Outer) && (dist >= radius_Inner) %Check if point lies in outer circle
            Ring(i,j) = spectral_Region(i,j);
        end
    end
end
end

