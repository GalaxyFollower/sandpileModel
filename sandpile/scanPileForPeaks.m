function [peak_pos, nbr_pos] = scanPileForPeaks(pile, tide)
%scanPileForPeaks - Find all peaks in a sandpile
%
% Syntax:  peak_pos = scanPileForPeaks(pile)
%
% Inputs:
%    pile - Matrix of shape (pile width, pile width) with integer values 
%    from 0 to 4
%
% Outputs:
%    peak_pos - Vector containing positions of all peaks
%
% Example:
%    peak_pos = scanPileForPeaks([0 1 3; 4 1 2; 2 1 0]);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: simulateSandpile
%
% Author: Florian Roscheck
% Website: http://github.com/flrs/visual_sandpile
% January 2017; Last revision: 27-January-2017

%------------- BEGIN CODE --------------
%pile_height = pile;
pile_width = size(pile, 1);
pile_box = zeros(size(pile,1)+2);
pile_box(2:end-1,2:end-1) = pile;
a = fix(pile_width/4);
if tide == 1
    stop_col = a;
end
if tide == 2
    stop_col = a*2;
end
if tide == 3
    stop_col = a*3;
end
if tide == 4
    stop_col = pile_width+1;
end
nbr = [0,1,0;1,0,1;0,1,0];
no_nbr = 1-nbr;
nbr_pos=[];
peak_pos=[];
for j = 2:stop_col
    for i = 2:pile_width+1
       temp_0 = pile_box(i-1:i+1,j-1:j+1) ;
       nbr_pile = temp_0.* nbr;
       no_nbr_pile = no_nbr .* pile_box(i,j);
       temp_1 = nbr_pile + no_nbr_pile;
       temp_2 = find(pile_box(i,j)-temp_1>1);
       if temp_2
           pos = (j-2)*pile_width + i-1;
           peak_pos(end+1) = pos;
           nbr_pos(pos)=temp_2(end);
       end
    end
end


        

%------------- END CODE --------------

