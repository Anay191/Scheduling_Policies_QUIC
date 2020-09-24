t = 10;
size = [1300, 180, 180, 140, 140];
C = 200:10:1000;
num_of_objs = [5,2,2,1,1];
total_num_of_objs = 1000*num_of_objs;
comp = 1;
final_result4 = {};
y4 = [];
for it=1:length(C)
    v = [1, 0.7, 0.7, 0.4, 0.4];
    W = [1 0.7 0.7 0.7 0.7; 0.7 1 0 0.5 0.5; 0.7 0 1 0 0; 0.7 0.5 0 1 0.1; 0.7 0.5 0 0.1 1];
    p = 0;
    w = 0;
    objs_to_be_txs = zeros(1,5);
    result4 = [];
    sizes4 = [];
    seq4 = {};
    total = C(it)*t;
    final_size = inf;
    new_v = v;
    last_sent = zeros(1,5);
    for index=1:1000
        w = 0;
        s = [];
        final_size = 0;
        rem_num_of_objs = num_of_objs + objs_to_be_txs;
        for k=1:t
            temp = new_v;
            [maximum, ind] = max(temp);
            while (rem_num_of_objs(ind) == 0)
                check = rem_num_of_objs ~= 0;
                if sum(check) > 1
                    temp(ind) = -inf;
                    [m,ind] = max(temp);
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
                
                p = s(k);
                last_sent(p) = index;
                temp2 = timeliness(t,last_sent);
                new_v = new_v-comp*temp2;
                final_size = final_size +size(s(k));
            end
            
            
        end
        if any(index == last_sent+10)
            ch = index == last_sent+10;
            new_v(ch) = v(ch);
            rem_num_of_objs(ch) = 0;
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
        result4(index) = w;
        sizes4(index) = final_size;
        seq4{index} = s;
        
    end
    final_result4{it} = result4;
    y4(it) = mean(result4);
    
end
