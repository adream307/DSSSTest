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
times=carry_fs/chip_bps;
remain=0;
n=1;
for k=s
    remain=remain+times;
    cur=round(remain);
    carry(n:n+cur-1)=k*ones(1,cur);
    remain=remain-cur;
    n=n+cur;
end
sig=zeros(1,chip_len/chip_bps*sample_fs);
carry_index=1;
sig_index=1;
remain_t=0;
period_t=1/sample_fs;
while carry_index<length(carry)
    num=0;
    val=carry(carry_index);
    while carry_index<length(carry)
        if carry(carry_index)~=val
            break;
        else
            carry_index=carry_index+1;
            num=num+1;
        end
    end
    cur_t=num*period_t+remain_t;
    cur_period=round(cur_t/period_t);
    t=0:1/sample_fs:cur_period/carry_fs;
    t=t(1:length(t)-1);
    if val==1
        sig(sig_index:sig_index+length(t)-1)=cos(2*pi*carry_fs*t);
    else
        sig(sig_index:sig_index+length(t)-1)=cos(2*pi*carry_fs*t+pi);
    end
    sig_index=sig_index+length(t);
    remain_t=cur_t-cur_period*period_t;
end
