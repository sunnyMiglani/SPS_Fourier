
%#just change the file path to load the image.
v1 = imread('characters/Vs/V7.GIF'); s1 = imread('characters/Ss/S7.GIF'); t1 = imread('characters/Ts/T4.GIF'); %reading in the images 

ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) ); %applying fourier transform and fourier shift

%%plotting the phase%%

%%Magnitude%%
V1_Mag = abs(ftv1);
S1_Mag = abs(fts1);
T1_Mag = abs(ftt1);


%Extract a box region.
 box = Extract_Box_Original_Size((abs(fts1)), 50, 150, 270, 370);
 power_boxOne = Sum_Power(box);
 figure('Name', 'boxOne'); imagesc(log((box)+1)); 
 box = Extract_Box_Original_Size((abs(fts1)), 150, 250, 450, 580);
 power_boxOne = Sum_Power(box) + power_boxOne;
 figure('Name', 'boxTwo'); imagesc(log((box)+1)); 
 



%Extract a Sector region.
sector1 = Extract_sector((abs(ftt1)), 310, 150, 10, 30);  %theta 1 push anticlockwise
sector2 = Extract_sector((abs(ftt1)), 310, 150, 150, 170);  %theta 1 push anticlockwise
sector_power = Sum_Power((sector1)) + Sum_Power((sector2));
figure('Name', 'sectorOne'); imagesc(log((sector1)+1));
figure('Name', 'sectorTwo'); imagesc(log((sector2)+1));


%Extract a ring region
ring = Extract_Ring((abs(fts1)), 150 , 75);
ring_power = Sum_Power((ring));
inverse_ring = ifft2(ifftshift(ring));
figure('Name', 'ring'); imagesc(log((ring)+1));

%%%%%%%%%%%%%%% - Voronoi plots and testing the features - %%%%%%%%%%%%%%%%

% Extract the features for all the training data
[S, V, T] = extractSpectralFeature();

%Concat them in an array
Training_Data = [S; V; T];

% Grab the means (Centroid for each of the classes)
Cluster_S = mean(S,1); Cluster_V = mean(V,1); Cluster_T = mean(T,1);

%Concat the centroids into a single array that can be passed to the voronoi
%diagram so we can get an idea of the classification boundaries based on
%out spectral features.
meanArray = [Cluster_S; Cluster_V; Cluster_T];
figure('Name','3D Scatter of Features');
hold on;
scatter3( S(:,1), S(:, 2), S(:, 3),'filled', 'ro');
scatter3( V(:,1), V(:, 2), V(:, 3),'filled', 'go');
scatter3( T(:,1), T(:, 2), T(:, 3),'filled', 'bo');
xlabel('Sector Values');
ylabel('Box Values');
zlabel('Ring Values');

% Comparison of various pairs of features

% Ring vs Sector Values --> Clusters are not great. They're quite close
% together and it can easily cause problems during classification

% Sector vs Box Values --> Clusters are much better, very little
% interaction between the points. Good decision boundary with veronoi

% Ring vs Box Values --> Not as great clusters as Sector V Box. But Still
% better than Ring V Sector. Would prefer Sector vs Box Values



%  scatter( S(:,1), S(:, 2),'filled', 'ro');
%  scatter( V(:,1), V(:, 2), 'filled', 'go');
%  scatter( T(:,1), T(:, 2),'filled', 'bo');

% plot(Cluster_S(:,1),Cluster_S(:,2), 'rd', 'MarkerSize', 7);
% plot(Cluster_V(:,1),Cluster_V(:,2), 'gd', 'MarkerSize', 7);
% plot(Cluster_T(:,1),Cluster_T(:,2), 'bd', 'MarkerSize', 7);

%voronoi(meanArray(:,1), meanArray(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%% - KNN Classifier - %%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Create the labels for the observed data points
cell_labels = cellstr([repmat('S', 10,1); repmat('V', 10,1); repmat('T', 10,1)]);

%Fit the KNN classifier
MdL = fitcknn(Training_Data, cell_labels, 'NumNeighbors', 5, 'Standardize', 1);


[labels,Test_Data] = test_knn(MdL);



labels_cells = cell2mat(labels);
ClusterSIndices = find((labels_cells) == 'S'); ClusterTIndices = find(labels_cells == 'T'); ClusterVIndices = find(labels_cells == 'V');


ClusterS = [Test_Data(ClusterSIndices, 1), Test_Data(ClusterSIndices,2), Test_Data(ClusterSIndices,3)]; %The features that have been classified as S
ClusterT = [Test_Data(ClusterTIndices, 1), Test_Data(ClusterTIndices,2), Test_Data(ClusterTIndices,3)];
ClusterV = [Test_Data(ClusterVIndices, 1), Test_Data(ClusterVIndices,2), Test_Data(ClusterVIndices,3)];

scatter3( ClusterS(:,1), ClusterS(:, 2), ClusterS(:, 3), 'rd');
scatter3( ClusterV(:,1), ClusterV(:, 2), ClusterV(:, 3), 'gd');
scatter3( ClusterT(:,1), ClusterT(:, 2), ClusterT(:, 3), 'bd');


%%%Figures for each letter, uncomment to show%%%
%figure('Name','Fourier space of V not reduced');
%imagesc(log(V1_Mag+1));
%figure('Name','Fourier space of S not reduced');
%imagesc(log(S1_Mag+1));
%figure('Name','Fourier space of T not reduced');
%imagesc(log(T1_Mag+1))

