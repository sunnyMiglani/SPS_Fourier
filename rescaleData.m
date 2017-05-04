function [ R_Data ] = rescaleData( Data )
%Rescales data with x-min/max-min
C1 = Data(:,1); C2 = Data(:,2);
C1_Max = max(C1); C2_Max = max(C2);
C1_Min = min(C1); C2_Min = min(C2);
R_Data = [(C1-C1_Min)./(C1_Max-C1_Min) (C2-C2_Min)./(C2_Max-C2_Min)];
end

