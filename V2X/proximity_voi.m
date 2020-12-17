function v = proximity_voi(d)
A = 1;
K = 0;
C = 1;
Q = 1;
B = 0.03;
V = 0.2;
d_s = 24.72;
v = A + ((K-A)./(C+Q.*exp(-B.*(d-d_s))).^(1./V));
return