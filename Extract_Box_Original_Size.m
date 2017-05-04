function [ Spectral_Feature ] = Extract_Box_Original_Size( Spectral_Region,a,b,c,d )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Spectral_Feature = Spectral_Region;
for( i = 1 : a )
    for( j = 1 : 640 )
        Spectral_Feature( i,j ) = double(0); % TOP
    end
end

for( i = b : 400 )
    for( j = 1 : 640 )
        Spectral_Feature( i, j ) = double(0); %Bottom
    end
end

for( i = a : b )
    for( j = 1 : c )
        Spectral_Feature(i,j) = double(0); %Left
    end
end

for( i = a : b )
    for( j = d : 640 )
        Spectral_Feature( i,j ) = double(0); %Right
    end
end