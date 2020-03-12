function pile = averEdge(edge_pos, num_pos, pile)  

pile_width = size(pile, 1);
pile_box = zeros(size(pile,1)+2);
pile_box(2:end-1,2:end-1) = pile;
temp_0 = zeros(3);

for ct = 1:numel(edge_pos)
    i = rem(edge_pos(ct)-1, pile_width)+1;
    j = (edge_pos(ct)-i)/pile_width + 1;%Ñ°ÕÒÑ©±ÀµãµÄ×ø±ê
    temp_3 = num_pos(edge_pos(ct),:);
    temp_1 = find(temp_3==1);
    num_0 = numel(find(temp_3==1));
    if num_0
        a = fix(pile_box(i+1,j+1)/(num_0+1));
        index = temp_1;
        temp_0(index) = a;
        temp_0(5) = -a*num_0;
    end
    pile_box(i:i+2,j:j+2) = temp_0+pile_box(i:i+2,j:j+2);
end

pile = pile_box(2:end-1,2:end-1);
