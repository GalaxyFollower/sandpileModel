function avalanche_output = simulateSandpile(pile_width, no_of_grains, ...
    draw_speed)
%simulateSandpile - Simulate a square, planar Abelian sandpile
%The Abelian sandpile is also known as the Bak-Tang-Wiesenfeld model.
%
%In this function, it is assumed that there is a square grid with the side
%length `pile_width`. When initiating the model, up to three sand grains
%are added randomly to every position in the grid. Then, a total of
%`no_of_grains` sand grains are added to the grid sequentially at random
%positions. If a sand grain causes the number of grains present at a grid
%position to exceed 3, an avalanche is started from the grid position. In 
%an avalanche, four grains are removed from the starting grid position. One
%grain of these four grains is added to the grid position toward the top,
%right, bottom and left, respectively. If this causes any of these grid
%positions to exceed three grains, an avalanche is started from the
%respective positions. The avalanche process continues until all positions
%in the grid carry not more than three grains. Then, the next sand grain is
%added at a random position, as described above.
%If a pile is resolved that is at the boundary of the grid, some grains
%will fall "off the grid" and no longer be considered in the model.
%
% Syntax:  avalanche_output = simulateSandpile(pile_width, no_of_grains, ...
%    draw_speed)
%
% Inputs:
%    pile_width - Side length of the square pile
%    no_of_grains - No. of grains that should be added to the sandpile
%    draw_speed - Speed of animation. A speed of 0 skips the animation
%       entirely, and will only plot a chart of avalanche sizes once the
%       simulation has finished running. A value of 0.5 yields a relatively
%       slow animation, smaller values yield a faster one.
%
% Outputs:
%    avalanche_output - Matrix containing count of observed avalanche
%       sizes. The second column shows the no. of avalanches
%       observed, the first column equals the no. of observations in such
%       configuration. For example. a vector like [1 8; 2 3; 3 1] would
%       mean that 8 avalanches with only 1 grid point exceeding 3 grains 
%       have be observed, 3 avalanches with 2 grid points exceeding 3
%       grains, and 1 avalanche with 3 grid points exceeding 3 grains.
%
% Example:
%    avalanche_output = simulateSandpile(15, 5000, 0.25)
%
% Other m-files required: setupPlots.m, scanPileForPeaks.m, resolvePeaks.m,
%   plotPile.m
% Subfunctions: none
% MAT-files required: none
%
% See also: none

%------------- BEGIN CODE --------------
%% check inputs
assert(nargin >= 3, 'The function %s needs at least 3 inputs.', mfilename);

check_vars = {pile_width, 'pile_width';
    no_of_grains, 'no_of_grains';
    draw_speed, 'draw_speed'};

for ct = 1:size(check_vars,1) %size是字典的长度这里为3,这里的1代表的是pile_with值，2代表"file_with"字符串
    assert(isfloat(check_vars{ct,1}), ['The input variable "%s" needs to'...
    ' be a floating point number.'], check_vars{ct,2});
    assert(numel(check_vars{ct,1})==1, ['The input variable "%s" needs to'...
        ' be a scalar.'], check_vars{ct,2});
end

for ct = 1:2
    assert(check_vars{ct,1}>0, ['The value of the input variable "%s" '...
        'needs to be greater than zero.'], check_vars{ct,2});
end

%% initialize
% initialize variables
pile = zeros(pile_width);%初始化一个空棋盘
pile_store = zeros([pile_width, pile_width, 1]);
pile_store_add = 0;
avalanche_plt = 0;  

% initialize pile
%genRand = @(inp) round(rand()*3);%产生一个0~3的整数，即为棋盘上沙粒的初始值
%pile = arrayfun(genRand, pile);%pile是整个棋盘，这行代码是往整个棋盘填入沙子
pile(6:end-5,6:end-5) = pile(6:end-5,6:end-5)+3;
pile_0 = pile;
tide = 1;
flag = 1;

% initialize plots
[pointer_patch, pile_img, avalanche_ct_plot, avalanche_desc_text] = ...
    setupPlots(pile_width, draw_speed);

%% run model
% generate pile
for ct = 1:no_of_grains
    % add grain to pile
    fprintf('Adding grain %.0f of %.0f...\n', ct, no_of_grains);
    add_pos = 13;
    %pile(add_pos) = pile(add_pos) + 1;%随机的数字是几，沙粒就落在了棋盘的第几格
    
    res = mod(no_of_grains,3);
    if res == 0
        [tide, flag] = changeTide(tide, flag);
    end
    
    for k = 1:pile_width
        temp = pile(k,: );
        temp_1 = find(temp>0);
        if ~isempty(temp_1)
            moveRow = k;
            moveCol = temp_1(1);
            pile = moveSand(moveRow, moveCol, pile, tide);
        end
    end
    
    
    pile_store = pile;
    pile_store_add = add_pos;
    avalanche_size = 0;
    
    % resolve peaks
    peaks = scanPileForPeaks(pile);%返回满足条件的值的索引
    intermediate_piles = [];
    while numel(peaks) ~= 0  %解决雪崩问题
        [pile, intermediate_piles] = resolvePeaks(pile, peaks);
        if ~isempty(intermediate_piles)
            if draw_speed
                pile_store = cat(3, pile_store, intermediate_piles);
            end
            avalanche_size = avalanche_size + size(intermediate_piles, 3);
        end
        peaks = scanPileForPeaks(pile);
    end
    
    % update avalanche counter
    if avalanche_size > 0
        if numel(avalanche_plt)>=avalanche_size
            avalanche_plt(avalanche_size) = ...
                avalanche_plt(avalanche_size)+1;
        else
            avalanche_plt(avalanche_size) = 1;
        end
        fprintf(['Captured avalanche with duration of %.0f time ',...
            'steps.\n'], avalanche_size);
    end

    % call plot function
    plotPile(pile_store, pile_store_add, pile_img, pointer_patch,...
        ct, avalanche_plt, avalanche_ct_plot,...
        avalanche_desc_text, draw_speed);  
    
    %comput the difference between the origin pile and the final pile.
    if ct == no_of_grains
        surf(pile,'EdgeColor','None');%绘制z的3D图
        shading interp;
        pile_dif = pile_0 - pile;
        add_pile_dif = sum(sum(pile_dif .* pile_dif));
        result_dif = sqrt(add_pile_dif);
        fprintf(['The difference between the two piles is %.0f .\n'], result_dif);
    end
end

avalanche_output = [1:numel(avalanche_plt);avalanche_plt]';
%------------- END CODE --------------
