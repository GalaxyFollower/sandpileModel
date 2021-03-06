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
nbr = [0,1,0;1,0,1;0,1,0];
no_nbr = 1-nbr;
nbr_pos=[];
peak_pos=[];
for j = 2:pile_width+1
    for i = 2:pile_width+1
        if pile_box(i,j)
            temp_0 = pile_box(i-1:i+1,j-1:j+1) ;%取出一个九宫格
            temp_3 = find(temp_0<1);%存放八领域是0的领域索引
            num_0 = numel(temp_3);
            if num_0 == 0
                nbr_pile = temp_0.* nbr;%去除四领域
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
    end
end


        

%------------- END CODE --------------

