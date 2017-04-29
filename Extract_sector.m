function spectral_feature = Extract_sector( spectral_region, outer_radius, inner_radius, theta1, theta2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    theta1Rad = deg2rad(theta1); %converted to radians
    theta2Rad = deg2rad(theta2);

    [y,x] = size(spectral_region);
    spectral_feature = complex(double(zeros(y,x)));
    midy = y/2;
    midx = x/2;
    
    
    % Formula's 
    % 1 -> p^2 = u^2 + v^2
    % 2 theta1 <= tanInv (v/u) <= theta2
    
    %Idea : Starting from x,y
    % this theta1, theta2 is given in by the user
    % theta1 is taken as the angle away from the point x,y where x,y is the
    % origin
    
    for u = 1:x
        for v = 1:y
          pSq = sqrt( (midx - u)^2 + (midy - v)^2 );
          if(pSq <= outer_radius && pSq >= inner_radius ) % to see if the values are in the sector length
            tanVal = atan2(midy - v,midx - u); % This gives radians.
            if(tanVal >= theta1Rad && tanVal <= theta2Rad) 
                   spectral_feature(v,u) = spectral_region(v,u);
                   % If the feature is part of the tan arc then it's part of
                   % the feature being extracted.
            end
          end
        end
    end
   
    
end

