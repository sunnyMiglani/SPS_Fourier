function [ Box ] = Extract_Box( Spectral_Region, a, b, c, d )
%Function that extracts a Box from the Fourier space
%   Extracts a box a<=u<=b, c<=v<=d.
Box = Spectral_Region(a:b,c:d); %Extracts rows a->b and columns c->d
end

