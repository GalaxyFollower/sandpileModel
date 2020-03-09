function pile = moveSand(moveRow, moveCol, pile, tide)

wave = [0,0,0;0,-2,2;0,0,0];
pile_box = zeros(size(pile,1)+8);
pile_box(5:end-4,5:end-4) = pile;

for n = 1:tide
    pile_box(moveRow+3:moveRow+5,moveCol+3:moveCol+5) = ...
        pile_box(moveRow+3:moveRow+5,moveCol+3:moveCol+5) + wave;
    pile = pile_box(5:end-4,5:end-4);
    moveCol = moveCol+1;
end
