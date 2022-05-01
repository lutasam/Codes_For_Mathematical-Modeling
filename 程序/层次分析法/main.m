A = [ 1 1/2 4 3 3;
 2 1 7 5 5;
 1/4 1/7 1 1/2 1/3;
 1/3 1/5 2 1 1;
 1/3 1/5 3 1 1]; 
[W, Lmax, CI, CR] = AHP(A)
B1 = [ 1  2   5;
      1/2 1   2;
      1/5 1/2 1];
B2 = [1 1/3 1/8;
      3  1  1/3;
      8  3   1];
B3 = [ 1   1  3;
       1   1  3;
      1/3 1/3 1]; 
B4 = [ 1  3 4;
      1/3 1 1;
      1/4 1 1];
B5 = [1 1 1/4;
      1 1 1/4;
      4 4  1 ];
[W1, Lmax1, CI1, CR1] = AHP(B1);
[W2, Lmax2, CI2, CR2] = AHP(B2);
[W3, Lmax3, CI3, CR3] = AHP(B3);
[W4, Lmax4, CI4, CR4] = AHP(B4);
[W5, Lmax5, CI5, CR5] = AHP(B5);
rlts3 =[W1 W2 W3 W4 W5; Lmax1 Lmax2 Lmax3 Lmax4 Lmax5;           
        CI1 CI2 CI3 CI4 CI5; CR1 CR2 CR3 CR4 CR5]
a3 = rlts3(1:3,:)  *  W