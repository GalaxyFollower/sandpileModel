function [pile, edge_pos, num_pos] = handleEdge(pile, tide)

%------------- BEGIN CODE --------------
%pile_height = pile;
pile_width = size(pile, 1);
pile_box = zeros(size(pile,1)+2);
pile_box(2:end-1,2:end-1) = pile;
num_pos = zeros(pile_width*pile_width, 9);
edge_pos = [];

for j = 2:pile_width+1
    for i = 2:pile_width+1
        if pile_box(i,j)
            temp_0 = pile_box(i-1:i+1,j-1:j+1) ;%取出一个九宫格
            temp_3 = find(temp_0==0);%存放八领域是0的领域索引
            num_0 = numel(temp_3);
            if num_0 >0
                pos = (j-2)*pile_width + i-1;
                edge_pos(end+1) = pos;
                num_pos(pos, temp_3) = 1;
            end
            if tide<3
                num_pos(:,7:9)=0;
            end
        end
    end
end

pile = pile_box(2:end-1,2:end-1);


%------------- END CODE --------------

