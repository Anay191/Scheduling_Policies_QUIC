t = 10;
size = [1300, 180, 180, 140, 140];
C = 200:10:1000;
num_of_objs = [5,2,2,1,1];
total_num_of_objs = 1000*num_of_objs;
comp = 1;
final_result2 = {};
y2 = [];
for it=1:length(C)
    w = 0;
    objs_to_be_txs = zeros(1,5);
    result2 = [];
    sizes2 = [];
    seq2 = {};
    total = C(it)*t;
    final_size = inf;
    for index=1:1000
        w = 0;
        s = [];
        final_size = 0;
        rem_num_of_objs = num_of_objs + objs_to_be_txs;
        for k=1:t
            ind = find(rem_num_of_objs);
            if final_size+size(ind(1)) > total
                break;
            else
                s(k) = ind(1);
                rem_num_of_objs(s(k)) = rem_num_of_objs(s(k)) - 1;
                
                final_size = final_size +size(s(k));
            end
            
            
        end
        objs_to_be_txs = rem_num_of_objs;
        for k=1:length(s)-1
            if s(k) == s(k+1)
                w = w + 0;
            else
                w = w+(1-W(s(k),s(k+1)))*v(s(k))*v(s(k+1));
            end
            final_size = final_size + size(s(k));
        end
        result2(index) = w;
        sizes2(index) = final_size;
        seq2{index} = s;
        
    end
    final_result2{it} = result2;
    y2(it) = mean(result2);
    
end
