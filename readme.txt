Direct-sequence spread spectrum test with matlab
usge:
    [s,c]dsss_modulation(fliplr(gfprimdf(10)),ones(1,10),20000,7000,1023,1,1);
    showfft(s,20000)
