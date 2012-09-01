function sig = bpsk_modulatlion(sample_fs,carry_fs,symble_rate,source)
len=ceil(length(source)/symble_rate*sample_fs);
sig=zeros(1,len);
k=1;
n=1;
while k<=length(source);
    if source(k)>0
        sig(n)=cos(2*pi*carry_fs*(n-1)/sample_fs);
    else
        sig(n)=cos(2*pi*carry_fs*(n-1)/sample_fs+pi);
    end
    n=n+1;
    if n*symble_rate>k*sample_fs
        k=k+1;
    end
end
