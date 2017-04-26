function [ Box ] = Extract_Box( Spectral_Region, u0, u1, v0, v1 )
%Function that extracts a Box from the Fourier space
%   Extracts a box a<=u<=b, c<=v<=d.
Box = Spectral_Region(u0:u1,v0:v1);                                        %Extracts rows u0->u1 and columns v0->v1
end

