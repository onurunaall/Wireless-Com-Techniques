clear all
clc
 
% Parameters
N = 5e3; % number of realizations/QPSK symbols
K=8e-4; % linear scale
d0=1; % reference distance [m]
d=150; % distance [m]
gamma = 2.4; % path loss exponent
sigma=4; % shadowing variance [in dB scale]
P_t=10^-3; % transmit power [mW]
Ts=10^-6; %1 microsecond,
dB_min = -2;
dB_max = 20;
Eb_N0 = dB_min:2:dB_max;
 
%% Generate random bits and modulate with QPSK
 
for M = 1:9
    for k = 1 : length(Eb_N0)
        data = randi([0 1],N*2,1);
        qpskModulator = comm.QPSKModulator('BitInput',true);
        qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);
        awgnchan = comm.AWGNChannel;
        errorRate = comm.ErrorRate;
        
        %% Modulate with QPSK
        modSig = qpskModulator(data);
        modSig = modSig';
 
        %% Simplified path loss
        path_loss = K*(d0/d)^gamma;
 
        %% Shadowing
        shadowing_dB = randn(1)*sqrt(sigma);
        shadowing = 10^(0.1*shadowing_dB);
 
        %% Rayeligh fading
        fast_fading = exprnd(1,1,N);
        if M == 1
            rayleig_coeff1 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
 
            % received power including pathloss + shadowing + Rayleigh fading
            P_r1  = P_t*path_loss*shadowing*(abs(rayleig_coeff1)).^2; % in linear
 
            % Received signal wihtout noise
            rxSig1=(sqrt(P_r1).*(rayleig_coeff1./abs(rayleig_coeff1))).*modSig;
 
            % Add noise
            EsNo = Eb_N0(k)+10*log10(2); %(in dB)
 
            % Noise variance/power
            No = 10.^((10*log10(P_t*path_loss*shadowing) - EsNo)/10);
 
            % Generate noise according to EsNo
            n = sqrt(No./2).*(randn(1,N)+ 1i.*randn(1,N));
 
            % Received signal fading  + noise
            rxSig1_noise = rxSig1 + n;
 
            % equalizer
            % calculated = rxSig2./rayleig_coeff;
            rxSig1_equ = rxSig1_noise.*conj(rayleig_coeff1);
 
            % Demodulation
            rxDataM1 = qpskDemodulator(rxSig1_equ');
 
            % Error statistics
            errorStats1 = errorRate(data, rxDataM1);
            ber1(k) = errorStats1(1);
 
        elseif M == 3
            rayleig_coeff1 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff2 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff3 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
 
            % received power including pathloss + shadowing + Rayleigh fading
            P_r1  = P_t*path_loss*shadowing*(abs(rayleig_coeff1)).^2; % in linear
            P_r2  = P_t*path_loss*shadowing*(abs(rayleig_coeff2)).^2; % in linear
            P_r3  = P_t*path_loss*shadowing*(abs(rayleig_coeff3)).^2; % in linear
            
            %determining the highest received power
            pmean = [mean(P_r1),mean(P_r2),mean(P_r3)];  
            pmax = max(pmean);
            
            if pmax == mean(P_r1)
                max_power_selected = P_r1;
                rayleigh_selected = rayleig_coeff1;
            elseif pmax == mean(P_r2)
                max_power_selected = P_r2;
                rayleigh_selected = rayleig_coeff2;
            elseif pmax == mean(P_r3)
                max_power_selected = P_r3;
                rayleigh_selected = rayleig_coeff3;
            end
                
            %%Received signal wihtout noise
            rxSig1=(sqrt(max_power_selected).*(rayleigh_selected./abs(rayleigh_selected))).*modSig;
           
            % Add noise
            EsNo = Eb_N0(k)+10*log10(2); %(in dB)
 
            % Noise variance/power
            No = 10.^((10*log10(P_t*path_loss*shadowing) - EsNo)/10);
 
            % Generate noise according to EsNo
            n = sqrt(No./2).*(randn(1,N)+ 1i.*randn(1,N));
 
            % Received signal fading  + noise
            rxSig1_noise = rxSig1 + n;
 
            % equalizer
            % calculated = rxSig2./rayleig_coeff;
            rxSig1_3_equ = rxSig1_noise.*conj(rayleigh_selected);
            
            
            % Demodulation
            rxDataM3 = qpskDemodulator(rxSig1_3_equ');
 
            % Error statistics
            errorStatsM3 = errorRate(data, rxDataM3);
            ber2(k) = errorStatsM3(1);
 
        elseif M == 6
            rayleig_coeff1 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff2 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff3 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff4 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff5 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff6 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
 
            % received power including pathloss + shadowing + Rayleigh fading
            P_r1  = P_t*path_loss*shadowing*(abs(rayleig_coeff1)).^2; % in linear
            P_r2  = P_t*path_loss*shadowing*(abs(rayleig_coeff2)).^2; % in linear
            P_r3  = P_t*path_loss*shadowing*(abs(rayleig_coeff3)).^2; % in linear
            P_r4  = P_t*path_loss*shadowing*(abs(rayleig_coeff4)).^2; % in linear
            P_r5  = P_t*path_loss*shadowing*(abs(rayleig_coeff5)).^2; % in linear
            P_r6  = P_t*path_loss*shadowing*(abs(rayleig_coeff6)).^2; % in linear
 
            %determining the highest received power
            pmean = [mean(P_r1),mean(P_r2),mean(P_r3)];  
            pmax = max(pmean);
            
            if pmax == mean(P_r1)
                max_power_selected = P_r1;
                rayleigh_selected = rayleig_coeff1;
            elseif pmax == mean(P_r2)
                max_power_selected = P_r2;
                rayleigh_selected = rayleig_coeff2;
            elseif pmax == mean(P_r3)
                max_power_selected = P_r3;
                rayleigh_selected = rayleig_coeff3;
            elseif pmax == mean(P_r4)
                max_power_selected = P_r4;
                rayleigh_selected = rayleig_coeff4;
            elseif pmax == mean(P_r5)
                max_power_selected = P_r5;
                rayleigh_selected = rayleig_coeff5;
            elseif pmax == mean(P_r6)
                max_power_selected = P_r6;
                rayleigh_selected = rayleig_coeff6;
            end
                
            %%Received signal wihtout noise
            rxSig1=(sqrt(max_power_selected).*(rayleigh_selected./abs(rayleigh_selected))).*modSig;
            
 
            % Add noise
            EsNo = Eb_N0(k)+10*log10(2); %(in dB)
 
            % Noise variance/power
            No = 10.^((10*log10(P_t*path_loss*shadowing) - EsNo)/10);
 
            % Generate noise according to EsNo
            n = sqrt(No./2).*(randn(1,N)+ 1i.*randn(1,N));
 
            % Received signal fading  + noise
            rxSig1_noise = rxSig1 + n;
            
            % equalizer
            % calculated = rxSig2./rayleig_coeff;
            rxSig1_6_equ = rxSig1_noise.*conj(rayleigh_selected);
 
            % Demodulation
            rxDataM6 = qpskDemodulator(rxSig1_6_equ');
 
            % Error statistics
            errorStatsM6 = errorRate(data, rxDataM6);
            ber3(k) = errorStatsM6(1);
 
 
       elseif M == 9
            rayleig_coeff1 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff2 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff3 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff4 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff5 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff6 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff7 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff8 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
            rayleig_coeff9 = (1/sqrt(2)).*(sqrt(randn(1,N).^2 + randn(1,N).^2));
 
            % received power including pathloss + shadowing + Rayleigh fading
            P_r1  = P_t*path_loss*shadowing*(abs(rayleig_coeff1)).^2; % in linear
            P_r2  = P_t*path_loss*shadowing*(abs(rayleig_coeff2)).^2; % in linear
            P_r3  = P_t*path_loss*shadowing*(abs(rayleig_coeff3)).^2; % in linear
            P_r4  = P_t*path_loss*shadowing*(abs(rayleig_coeff4)).^2; % in linear
            P_r5  = P_t*path_loss*shadowing*(abs(rayleig_coeff5)).^2; % in linear
            P_r6  = P_t*path_loss*shadowing*(abs(rayleig_coeff6)).^2; % in linear
            P_r7  = P_t*path_loss*shadowing*(abs(rayleig_coeff7)).^2; % in linear
            P_r8  = P_t*path_loss*shadowing*(abs(rayleig_coeff8)).^2; % in linear
            P_r9  = P_t*path_loss*shadowing*(abs(rayleig_coeff9)).^2; % in linear
            
            %determining the highest received power
            pmean = [mean(P_r1),mean(P_r2),mean(P_r3)];  
            pmax = max(pmean);
            
            if pmax == mean(P_r1)
                max_power_selected = P_r1;
                rayleigh_selected = rayleig_coeff1;
            elseif pmax == mean(P_r2)
                max_power_selected = P_r2;
                rayleigh_selected = rayleig_coeff2;
            elseif pmax == mean(P_r3)
                max_power_selected = P_r3;
                rayleigh_selected = rayleig_coeff3;
            elseif pmax == mean(P_r4)
                max_power_selected = P_r4;
                rayleigh_selected = rayleig_coeff4;
            elseif pmax == mean(P_r5)
                max_power_selected = P_r5;
                rayleigh_selected = rayleig_coeff5;
            elseif pmax == mean(P_r6)
                max_power_selected = P_r6;
                rayleigh_selected = rayleig_coeff6;
            elseif pmax == mean(P_r7)
                max_power_selected = P_r7;
                rayleigh_selected = rayleig_coeff7;
            elseif pmax == mean(P_r8)
                max_power_selected = P_r8;
                rayleigh_selected = rayleig_coeff8;
            elseif pmax == mean(P_r9)
                max_power_selected = P_r9;
                rayleigh_selected = rayleig_coeff9;
            end
                
            %%Received signal wihtout noise
            rxSig1=(sqrt(max_power_selected).*(rayleigh_selected./abs(rayleigh_selected))).*modSig;
 
            % Add noise
            EsNo = Eb_N0(k)+10*log10(2); %(in dB)
 
            % Noise variance/power
            No = 10.^((10*log10(P_t*path_loss*shadowing) - EsNo)/10);
 
            % Generate noise according to EsNo
            n = sqrt(No./2).*(randn(1,N)+ 1i.*randn(1,N));
 
            % Received signal fading  + noise
            rxSig1_noise = rxSig1 + n;
   
            % equalizer
            % calculated = rxSig2./rayleig_coeff;
            rxSig1_9_equ = rxSig1_noise.*conj(rayleigh_selected);
 
            % Demodulation
            rxDataM9 = qpskDemodulator(rxSig1_9_equ');
 
            % Error statistics
            errorStatsM9 = errorRate(data, rxDataM9);
            ber4(k) = errorStatsM9(1);
            
        else
            continue
        end
    end
end
 
%% Plotting
lg1 = semilogy(Eb_N0, ber1);
title('Selective Combining')
ylabel('Bit Error Rate (BER)')
xlabel('SNR [dB]')
lg1.LineWidth = 1.5;
xlim([-2.1,20.1])
grid on
hold on 
lg2 = semilogy(Eb_N0, ber2);
title('Selective Combining')
ylabel('Bit Error Rate (BER)')
xlabel('SNR [dB]')
lg2.LineWidth = 1.5;
xlim([-2.1,20.1])
grid on
hold on 
lg3 = semilogy(Eb_N0, ber3);
title('Selective Combining')
ylabel('Bit Error Rate (BER)')
xlabel('SNR [dB]')
lg3.LineWidth = 1.55;
xlim([-2.1,20.1])
grid on
hold on 
lg4 = semilogy(Eb_N0, ber4);
title('Selective Combining')
ylabel('Bit Error Rate (BER)')
xlabel('SNR [dB]')
lg4.LineWidth = 1.5;
xlim([-2.1,20.1])
grid on
hold on 
legend('M=1','M=3','M=6','M=9')
 
%% Printing the results
fprintf('Max BER1: %.5f, Min BER1: %.5f\n', max(ber1),min(ber1));
fprintf('Max BER2: %.5f, Min BER2: %.5f\n', max(ber2),min(ber2));
fprintf('Max BER3: %.5f, Min BER3: %.5f\n', max(ber3),min(ber3));
fprintf('Max BER4: %.5f, Min BER4: %.5f\n', max(ber4),min(ber4));
