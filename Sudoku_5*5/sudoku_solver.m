function D = sudoku_solver(D)
% D=[ 9 0 0 0 0 0 0 0 5
%     0 4 0 3 0 0 0 2 0
%     0 0 8 0 0 0 1 0 0
%     0 7 0 6 0 3 0 0 0
%     0 0 0 0 8 0 0 0 0
%     0 0 0 7 0 9 0 6 0
%     0 0 1 0 0 0 9 0 0
%     0 3 0 0 0 6 0 4 0
%     5 0 0 0 0 0 0 0 8];
onefound = 1;
N = 0;
poss = 1:5;

while onefound
    splits = {};
    onefound = 0;
    for m = 1:5
        rowdata = nonzeros(D(m,:)');
        for n = 1:5
            E = D(m,n);
            if E ~= 0, continue, end
            
            coldata = nonzeros(D(:,n));
%             blk = [ceil(m/3) ceil(n/3)]-1;
%             blkdata = nonzeros(D(blk(1)*3+[1:3],blk(2)*3+[1:3]));
            
            EE = zeros(1,5);
            RCB = [rowdata; coldata];
            EE(RCB) = 1;
            Enew = find(~EE);
            
            if isempty(Enew)
                D = []; return;
            elseif length(Enew) == 1;
                onefound = 1;
                D(m,n) = Enew;
                rowdata = nonzeros(D(m,:)');
            else
                splits{end+1} = [m n Enew];
            end
        end
    end
end

if isempty(splits)
    return
end

splitlength = cellfun(@length,splits);
splits = splits{find(splitlength == min(splitlength),1)};
m = splits(1); n = splits(2);

for test = 3:length(splits)
    D(m,n) = splits(test);
    D0 = sudoku_solver(D);
    if ~isempty(D0)
        D = D0;
        return
    end
end
D = [];