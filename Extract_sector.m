function spectral_feature = Extract_sector( spectral_region, radius, theta1, theta2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    [len,width] = size(spectral_region);
    spectral_feature = complex(double(zeros(h,w)));
    
    
    % Formula's 
    % 1 -> p^2 = u^2 + v^2
    % 2 theta1 <= tanInv (v/u) <= theta2
    
    %Idea : Starting from x,y
    % this theta1, theta2 is given in by the user
    % theta1 is taken as the angle away from the point x,y where x,y is the
    % origin
    
    for u = 1:len
        for v = 1:width
          pSq = sqrt(u*u + v*v);
          if(pSq > radius) % to see if the values are in the sector length
              continue;
          end
          tanVal = atan(v/u);
          if(tanVal >= theta1)
              if(tanVal <= theta2) 
                  spectral_feature(u,v) = spectral_region(u,v);
                  % If the feature is part of the tan arc then it's part of
                  % the feature being extracted.
              end
          end
        end
    end
   
    
end

