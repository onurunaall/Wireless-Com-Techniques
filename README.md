# Wireless-Com-Selection-Combining
Two types of wireless communication techniques are examined in this repo. The Selection Combination implementation can be found in sc.m and similarly, Maximum Ratio Combining implementation can be found in mrc.m.

## Selection Combination (SC)
Selection Combination (SC) is known as one of the receiver diversity techniques. The strongest signal is chosen from among the signals in SC. In other words, using the same channel with different antennas in the same branch as SC, the highest signal-to-noise ratio is selected among the signals and thus the obtained signal is optimized.

### Implementation of Selection Combination
First of all, all the necessary parameters are defined. After that I set two for loops that iterate over SNR and M. In the for loops, there is an if-else structure that controls the value of M. If M is either 1, 3, 6 or 9, the if-else structure is activated. Except for M=1, since there is only one branch and one channel for M=1, Rayleigh coefficients are calculated separately. After that, related received powers which include path loss, the effect of shadowing and Rayleigh fading are calculated. After that within these received powers, the one which has the maximum average is selected and indicated as the one that will be used as Selective Combining received power. After that noise is calculated. Then noise is added to the signal and these added versions of the signal are sent to QPSK Demudolator. Lastly, the bit error rate (BER) is calculated. 

## Maximum Ratio Combining (MRC)
In MRC, unlike the SC, the output of the branches are summed and processed as one. Namely, the signals from each channel are added. It is expected that by using MRC, the average BER decreases.

### Implementation of Maximum Ratio Combining
First of all, all the necessary parameters are defined. After that I set two for loops that iterate over SNR and M. In the for loops, there is an if-else structure that controls the value of M. If M is either 1, 3, 6 or 9, the if-else structure is activated. Except for M=1, since there is only one branch and one channel for M=1, Rayleigh coefficients are calculated separately. After that, related received powers which include path loss, the effect of shadowing and Rayleigh fading are calculated. Then, as directed in the model code that was given signals without noise are calculated. After that noise is calculated. The next step is adding these noises to the signals which have no noise. Then by using the equalizer, signals are equalized. Lastly, all the signals which come from the equalizer are added together and then this summation is sent to QPSK Demodulator. And lastly, bit error rates are calculated. 
