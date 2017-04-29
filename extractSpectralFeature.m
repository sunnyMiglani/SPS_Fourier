function [ S, V, T ] = extractSpectralFeature()
S_files = dir('characters/Ss/*.GIF');
S_Path = 'characters/Ss/';
V_files = dir('characters/Vs/*.GIF');
V_Path = 'characters/Vs/';
T_files = dir('characters/Ts/*.GIF');
T_Path = 'characters/Ts/';

%Ring Assumptions
ring_Outer = 150; ring_Inner = 120;
%%Top Box Assumptions
BT_u0 = 1; BT_u1 = 170; BT_v0 = 300; BT_v1 = 340; 
%%Right Box Assumptios
BR_u0 = 180; BR_u1 = 220; BR_v0 = 395; BR_v1 = 640; 
%%Sector Assumptions (L)
thetaL_1 = 10; thetaL_2 =30; radL_in = 150; radL_out = 310;
%(R)
thetaR_1 = 150; thetaR_2 = 170; radR_in = 150; radR_out = 310;

    function [ X ] = get_Feature( direct, path )
        for i = 1 : numel(direct)
            Image = imread(strcat(path, direct(i).name));                              %Read the file name
            FFTM  = log(abs(fftshift( fft2(double(Image))))+1); 
            Box_Top = Sum_Power( Extract_Box(FFTM, BT_u0, BT_u1, BT_v0, BT_v1));       %Extract a "Box" spectral feature
            Box_R = Sum_Power(Extract_Box(FFTM, BR_u0, BR_u1, BR_v0, BR_v1));                               
            Ring = Sum_Power(Extract_Ring(FFTM, ring_Outer, ring_Inner));
            SectorL = Sum_Power(Extract_sector(FFTM, radL_out, radL_in, thetaL_1, thetaL_2));
            SectorR = Sum_Power(Extract_sector(FFTM, radR_out, radR_in, thetaR_1, thetaR_2));
            X(i,1) = SectorL+ SectorR;                                               %Store the extracted features in a row vector
            X(i,2) = Box_Top + Box_R;
            X(i,3) = Ring;
        end
    end


    % Features being checked -> Box_Top, Box_Right, Ring, SectorL, SectorR (total = 5)
    % The feature values are stored in a (N x 3) array, with sectors stored
    % in (N,1). Boxes stored in (N,2) and Ring stored in (N,3).
    
    


%%Extract features for all training data
S = get_Feature(S_files, S_Path);
V = get_Feature(V_files, V_Path);
T = get_Feature(T_files, T_Path);

end


% 
% for i = 3 : numel(S_files)
%     Image = imread(strcat(S_Path,S_files(i).name));                        %Read the file name
%     FFTM  = log(abs(fftshift( fft2(double(Image))))+1); 
%     BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                    %Get Feature
%     Box_Power = Sum_Power(abs(BoxOne));           %Sum the powers to get the value for this feature
%     Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
%     Ring_Power = Sum_Power(abs(Ring));
%     sector = Extract_sector(FFTM, 200, 75, 10, 40);
%     sector_power = Sum_Power(abs(sector));
%     S(i-2,1) = sector_power;%Box_Power;                                                  %Store the value in the return vector
%     S(i-2,2) = Box_Power;%Ring_Power;
%     S(i-2,3) = Ring_Power;
% end
% for i = 3 : numel(V_files)
% 
%     Image = imread(strcat(V_Path,V_files(i).name));                        %Read the file name
%     FFTM  = log(abs(fftshift( fft2(double(Image))))+1);                                %FFT
%     BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
%     Box_Power = Sum_Power(abs(BoxOne));                                       %Sum the powers to get the value for this feature
%     Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
%     Ring_Power = Sum_Power(abs(Ring));
%     sector = Extract_sector(FFTM, 200, 75, 10, 40);
%     sector_power = Sum_Power(abs(sector));
%     V(i-2,1) = sector_power;%Box_Power;                                                  %Store the value in the return vector
%     V(i-2,2) = Box_Power;%Ring_Power;
%     V(i-2,3) = Ring_Power;
% end
% for i = 3 : numel(T_files)
% 
%     Image = imread(strcat(T_Path,T_files(i).name));                        %Read the file name
%     FFTM  = log(abs(fftshift( fft2(double(Image))))+1);                                %FFT
%     %    figure
%     % imagesc(log(abs(FFTM)+1))
%     BoxOne = Extract_Box(FFTM, box1u0, box1u1, v0, v1);                               %Get Feature
%     Box_Power = Sum_Power(abs(BoxOne));                                       %Sum the powers to get the value for this feature
%     Ring = Extract_Ring(FFTM, ring_Outer, ring_Inner);
%     Ring_Power = Sum_Power(abs(Ring));
%     sector = Extract_sector(FFTM, 200, 75, 10, 40);
%     sector_power = Sum_Power(abs(sector));
%     T(i-2,1) = sector_power; %Box_Power;                                                  %Store the value in the return vector
%     T(i-2,2) = Box_Power;%Ring_Power;
%     T(i-2,3) = Ring_Power;
% end
% end

