% FIFO

% The script devises the simple FIFO schedule for v2x communication

% Size of the packets in bits
size = 8*[1300, 180, 180, 140, 140];
% Capacity of the channel in kbps
C = 20000:5000:120000;
% Number of objects created by the sensors per second
num_of_objs = [10,10,10,10,10];
% Total number of objects to be sent out over the 10000 timesteps
total_num_of_objs = 1000*num_of_objs;
final_result2 = {};
pkts_sent2 = zeros(length(C),5);
y2 = [];
% Running the script for each capacity values
for it=1:length(C)
    objs_to_be_txs = zeros(1,5);
    result2 = [];
    sizes2 = [];
    seq2 = {};
    total = C(it);
%   Run the scheduling algorithm over 10000 timesteps
    for index=1:1000
        w = 0;
        s = [];
        final_size = 0;
        size_final = 0;
        rem_num_of_objs = num_of_objs;
        while final_size < total
            ind = randperm(length(rem_num_of_objs),1);
            if final_size+size(ind) > total
                break;
            else
                s = [s ind];
                rem_num_of_objs(ind) = rem_num_of_objs(ind) - 1;
                pkts_sent2(it,ind) = pkts_sent2(it,ind) + 1;
                final_size = final_size +size(ind);
            end
            
            
        end
%       Calculate the value of information for the schedule defined
        for k=1:length(s)-1
            if s(k) == s(k+1)
                w = w + 0;
            else
                w = w+(1-W(s(k),s(k+1)))*v(s(k))*v(s(k+1));
            end
            size_final = size_final + size(s(k));
        end
        result2(index) = w;
        sizes2(index) = size_final;
        seq2{index} = s;
        
    end
    final_result2{it} = result2;
    y2(it) = mean(result2);
    
end
