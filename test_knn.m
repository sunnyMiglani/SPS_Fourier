function [ labels,Test_Data ] = test_knn(MdL)

S_testFiles = dir('test/Ss/');
S_Path = 'test/Ss/';
V_testFiles = dir('test/Vs/');
V_Path = 'test/Vs/';
T_testFiles = dir('test/Ts/');
T_Path = 'test/Ts/';

%Variables so we can more easily modify spectral regions.
ring_Outer = 200; ring_Inner = 75;
box1u0 = 1; box1u1 = 140; v0 = 300; v1 = 375; 
box2u0 = 240; box2u1 = 400;

for i = 3 : numel(S_testFiles)
    Image = imread(strcat(S_Path,S_testFiles(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);                               %Get Feature
    Box_Power = Sum_Power(abs(BoxOne)) + Sum_Power(abs(BoxTwo));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    S(i-2,1) = Box_Power;                                                  %Store the value in the return vector
    S(i-2,2) = Ring_Power;
end
for i = 3 : numel(V_testFiles)

    Image = imread(strcat(V_Path,V_testFiles(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);
    Box_Power = Sum_Power(abs(BoxOne))+ Sum_Power(abs(BoxTwo));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    V(i-2,1) = Box_Power;                                                  %Store the value in the return vector
    V(i-2,2) = Ring_Power;
end
for i = 3 : numel(T_testFiles)
    Image = imread(strcat(T_Path,T_testFiles(i).name));                        %Read the file name
    FFTM  = fftshift( fft2(double(Image)));                                %FFT
    %    figure
    % imagesc(log(abs(FFTM)+1))
    BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
    BoxTwo = Extract_Box(FFTM, box2u0, box2u1, v0, v1);
    Box_Power = Sum_Power(abs(BoxOne)) + Sum_Power(abs(BoxTwo));                                       %Sum the powers to get the value for this feature
    Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
    Ring_Power = Sum_Power(abs(Ring));
    T(i-2,1) = Box_Power;                                                  %Store the value in the return vector
    T(i-2,2) = Ring_Power;
end


Test_Data = [S; V; T];
labels = predict(MdL,Test_Data);





end

