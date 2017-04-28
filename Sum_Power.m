function [ Power ] = Sum_Power( Spectrum_Feature )
%Sums over the square of magnitude array of an extracted feature.
Squared_Array = Spectrum_Feature.^2; % Square each element in the matrix
Power = sum( sum ( Squared_Array ) ); % sum over each row, then sum the result
end

