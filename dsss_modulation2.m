function [sig,carry]=dsss_modulation(primdf,init_states,sample_fs,carry_fs,chip_bps,src_bps,src)
% Direct-sequence spread spectrum test with matlab
% input:
%      primdf      -- primitive polynomials for a Galois field
%      ini_states  -- the initial states for commsrc.pn
%      sample_fs   -- sample frequence for the output signal
%      carry_fs    -- carry frequence
%      chip_bps    -- chip bps
%      src_bps     -- the information source pbs
%      src         -- the information which will be modulated
% output:
%      sig         -- the output signal which has been modulated
%       carry      -- the sequence the pn code xor with the source
x=zeros(size(init_states));
x(length(x))=1;
chip_len=chip_bps/src_bps*length(src);
h=commsrc.pn('GenPoly',primdf,...
    'InitialStates',init_states,...
    'CurrentStates',init_states,...
    'Mask',x,...
    'NumBitsOut',chip_len);
s=generate(h)';
x=repmat(src,chip_bps/src_bps,1);
x=reshape(x,1,length(s));
s=bitxor(s,x);
carry=-1*ones(1,chip_len/chip_bps*carry_fs);
k=1;
n=1;
while k<=length(s)
    carry(n)=s(k);
    n=n+1;
    if n*chip_bps > k*carry_fs
        k=k+1;
    end
end
k=1;
n=1;
sig=zeros(1,chip_len/chip_bps*sample_fs);
while k<=length(carry)
    if carry(k)>0
        sig(n)=cos(2*pi*carry_fs*(n-1)/sample_fs);
    else
        sig(n)=cos(2*pi*carry_fs*(n-1)/sample_fs+pi);
    end
    n=n+1;
    if n*carry_fs>k*sample_fs
        k=k+1;
    end
end
    