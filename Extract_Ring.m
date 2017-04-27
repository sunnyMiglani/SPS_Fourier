function  Ring  = Extract_Ring(spectral_Region, radius_Outer, radius_Inner )
%Given an origin and two radi, a ring can be extracted from the fourier
%space by testing if a point lies in the circle definied by the outer
%radius, then testing if this point does NOT lie in the circle defined by
%the inner radius. If the point satisfys this condition it can be
%extracted.


[y, x] = size(spectral_Region); % Get the dimentions
midx = x/2; midy = y/2; %The origin
Ring = complex(double(zeros(y,x)));
%Ring = spectral_Region;
for i = 1 : x %loop width
    for j = 1 : y % loop height
        dist = sqrt( (midx - i)^2 + (midy - j)^2 ); %Distaance of point from origin (Circle centre)
        if (dist <= radius_Outer) && (dist >= radius_Inner) %Check if point lies in outer circle
            Ring(i,j) = spectral_Region(j,i);
        end
    end
end
end

