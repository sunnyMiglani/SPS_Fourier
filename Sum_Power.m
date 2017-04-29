function [ Power ] = Sum_Power( Spectrum_Feature )

%Sums over the square of the magnitude of a spectral region from the
%fourier space.

Squared_Array = Spectrum_Feature.^2;                                       % Square each element in the matrix
Power = sum( sum ( Squared_Array ) );                                      % Sum over u and v for the result

end

