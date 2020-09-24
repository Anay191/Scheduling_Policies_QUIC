t = 10;
size = [1300, 180, 180, 140, 140];
C = 200:10:1000;
num_of_objs = [5,2,2,1,1];
total_num_of_objs = 1000*num_of_objs;
comp = 1;
final_result3 = {};
y3 = [];
for it=1:length(C)
    v = [1, 0.7, 0.7, 0.4, 0.4];
    W = [1 0.7 0.7 0.7 0.7; 0.7 1 0 0.5 0.5; 0.7 0 1 0 0; 0.7 0.5 0 1 0.1; 0.7 0.5 0 0.1 1];
    p = 0;
    w = 0;
    objs_to_be_txs = zeros(1,5);
    last_sent = zeros(1,5);
    result3 = [];
    sizes3 = [];
    seq3 = {};
    total = C(it)*t;
    new_v = v;
    for index=1:1000
        w = 0;
        s = [];
        final_size = 0;
        rem_num_of_objs = num_of_objs + objs_to_be_txs;
        for k=1:t
            [maximum, ind] = max(new_v);
            while (rem_num_of_objs(ind) == 0)
                check = rem_num_of_objs ~= 0;
                if sum(check) > 1
                    new_v(ind) = -inf;
                    [m,ind] = max(new_v);
                else
                    ind = find(rem_num_of_objs);
                    break;
                end
                
            end
            if final_size+size(ind) > total
                break;
            else
                s(k) = ind;
                rem_num_of_objs(ind) = rem_num_of_objs(ind) - 1;
                new_v = v;
                
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
        result3(index) = w;
        sizes3(index) = final_size;
        seq3{index} = s;
        
    end
    final_result3{it} = result3;
    y3(it) = mean(result3);
    
end
