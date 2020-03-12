function pile = rain(pile)
pile_width = size(pile,1);
num =  round(rand()*(pile_width*pile_width-1))+1;

peak_pattern = [0 1 0;1 -4 1;0 1 0;];

pile_box = zeros(size(pile,1)+2);
pile_box(2:end-1,2:end-1) = pile;
i = rem(num-1, pile_width)+1;
j = (num-i)/pile_width + 1;
if pile_box(i+1,j+1)>4
    pile_box(i:i+2,j:j+2) = ...
        pile_box(i:i+2,j:j+2) + peak_pattern;
    pile = pile_box(2:end-1,2:end-1);
end