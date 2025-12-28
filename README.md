Copyright (c) 2025 Ahmad Hussain Safder

# Overview
The intelligent control of heavy-duty electric vehicles consists of three steps. In the first step, the strategy utilizes information about upcoming driving conditions (e.g., speed limits, road grade, and lead vehicle behavior) to adjust the vehicle's speed optimally, resulting in reduced energy consumption while maintaining a balance between travel time. The second step operates at the powertrain level, which allocates torque optimally among multiple e-axles to minimize powertrain losses. Finally, the third step focuses on component-level coordination, ensuring that the uneven torque distribution does not induce harmful thermal or mechanical stresses on each traction electric machine (EM). It guarantees safe and reliable vehicle operation. 
<p align="center"><img width="718" height="330" alt="image" src="https://github.com/user-attachments/assets/f1ca4fe5-0a4e-4507-946d-e64db335a978" />Overview of Control Scheme</em>
  
# Step 1: Vehicle Level Optimization 
This step formulates a cost function that combines the vehicle’s energy consumption with the speed tracking error, where the speed limit serves as the reference. A penalty factor is introduced to adjust the trade-off, allowing emphasis to be placed either on minimizing energy use or on maintaining speed tracking. The strategy leverages look-ahead information, including upcoming road grade, speed limits, and the behavior of a lead vehicle, over a defined time horizon, which is further divided into smaller segments to capture variations in the input data. Within each segment, the cost function is evaluated, and optimization techniques are applied to determine the optimal acceleration that minimizes the overall cost across the horizon. In order to solve this problem, gradient-based optimization methods are employed, and the performance of sequential quadratic programming (SQP), interior-point (IP) methods, and dynamic programming (DP) are compared. The resulting optimal acceleration is then used to compute the required driving torque. The choice of penalty factor is particularly critical for heavy-duty electric vehicles. A higher penalty on speed tracking error reduces travel delays but can increase energy usage, while prioritizing energy minimization may extend delivery time and raise operational costs. This research therefore also addresses the optimal selection of the penalty factor, ensuring a balanced trade-off between energy efficiency and travel time.

# Step 2: Powertrain Level Optimization 
This step operates at the powertrain level, where it receives the optimal driving torque from Step 1 along with the current vehicle speed. A cost function is formulated to capture the power losses of key drivetrain components, including the traction electric machines (EMs), gearbox, and differential. Based on this cost function, the controller determines the optimal torque allocation for each e-axle to minimize overall powertrain losses. Similar to Step 1, this strategy employs gradient-based optimization techniques, such as sequential quadratic programming (SQP), to solve the optimal control problem. The published and ongoing research on this approach consistently demonstrates that an uneven torque split across e-axles is often optimal for minimizing system losses. The optimization is subject to critical constraints, including:

1) **Individual EM Torque Envelopes**: Ensuring commands remain within peak and continuous torque limits at the operating speed.

2) **Traction Limits**: Calculating the maximum permissible torque for each e-axle based on dynamic vertical load transfer to prevent wheel slip.

3) **Thermal Limits**: Monitoring and managing the derated torque in the EMs resulting from uneven thermal stress.

# Step 3: Component Level Optimization
At this stage, the framework addresses the operational impacts of the optimal torque allocation determined in Step 2. The uneven torque allocation commands induce correspondingly uneven thermal and mechanical stresses across the EMs and can lead to synchronization challenges between the e-axles. To proactively manage these effects, this research introduces a novel machine learning-based speed synchronization framework. This framework learns the EM dynamics and generates the speed references for the EM to ensure the synchronized operation under uneven torque allocation commands. Predicting and compensating for speed deviations before they manifest it provides smooth powertrain operation. Simultaneously, the framework incorporates online parameter estimation to monitor critical EM health indicators, such as winding resistance, which enables high-fidelity estimation of internal temperature and the calculation of a thermally-derated torque limit for each EM. This refined efficiency and thermal data are fed back to the powertrain-level optimizer in Step 2, enabling it to adjust the optimal torque allocation strategy. Consequently, the system proactively redistributes torque to mitigate excessive stress on any single motor and maintain synchronization, thereby enhancing both the vehicle's immediate operational robustness and the long-term durability of its powertrain components.



The proposed framework not only reduces the overall energy consumption of heavy-duty electric vehicles but also enhances the durability and reliability of the powertrain, thereby extending the vehicle's operational range and service life.


## EM Modeling 
This research work considers the permanent magnet synchronous machine as the traction electric machine. The dynamic equations of PMSM in the rotating d-q frame can be expressed as 

 $\frac{di_{d}}{dt}=-\frac{R_{s}}{L_{d}}i_{d}+\frac{\omega_e L_{q}}{L_{d}}i_{q}+\frac{v_{d}}{L_{d}}$


$\frac{di_{q}}{dt}=-\frac{\omega_e L_{d}}{L_{q}}i_{d}-\frac{R_{s}}{L_{q}}i_{q}+\frac{v_{q}}{L_{q}}-\frac{\omega_e\lambda_{m}}{L_{q}} $

$T_{e}=\frac{3}{2}p(\lambda_{m}i_{q}+(L_d-L_q)i_di_q)$

$J\frac{d\omega}{dt}=T_{e}-T_{L}-F\omega$

where $i_{q}$ is quadrature axis current, $i_{d}$ is direct axis current, $R_{s}$ is stator resistance, $\omega_e$ is angular electrical velocity, $T_{e}$ is machine torque, $p$ is number of poles, $\lambda_{m}$ is flux linkage, $T_{L}$ is load torque, $J$ is machine's rotor inertia, $F$ is viscous coefficient, $v_{d}$ direct axis voltage, $v_{q}$ is quadrature axis voltage and lastly $L_{q}$ and $L_{d}$ are equivalent quadrature and direct axis inductance respectively. 

# Hardware Testing
The proposed algorithm is validated through extensive hardware testing. Its real-time implementation capability is evaluated using a hardware-in-the-loop (HIL) setup, while the E-axle electric machine (EM) control performance is assessed using a scale-down EM test bench.
## Hardware in Loop (HiL) Testing. 
Steps 1 and 2 of the proposed intelligent controller are validated using a hardware-in-the-loop (HIL) setup. The optimal torque control strategy is implemented on a Speedgoat real-time baseline target, while the vehicle model is executed on a dSPACE SCALEXIO system. A dedicated ControlDesk interface PC is used for real-time signal monitoring and data logging. Communication between the controller and the vehicle model is established via CAN, using a DS6342 CAN module on the SCALEXIO platform and an IO613 CAN module on the Speedgoat system.
[dSPACE_HiL_Setup.pdf](https://github.com/user-attachments/files/24358201/dSPACE_HiL_Setup.pdf)

## Scale-Down E-Axle Motor Test Bench and Control Implementation 
The setup includes two 3 kW three-phase PMSM/BLDC machines, 5 kW inverters, and a 5 kVA power source. Each electric machine is coupled with a 1 kW DC generator, which serves as an electric load to emulate the road load conditions.
For control implementation, the setup utilizes a Speedgoat Baseline Real-Time Target Machine, which interfaces seamlessly with MATLAB/Simulink. This enables rapid prototyping and deployment of control algorithms using Simulink blocks directly on the real-time hardware.
<p align="center"><img width="781" height="599" alt="image" src="https://github.com/user-attachments/assets/1c691ef4-87b3-4312-b687-6f033935eb34" />

## Scale-Down E-Axle Motor Test Bench Video




https://github.com/user-attachments/assets/b31696e0-6871-49aa-afd2-e4d69f09ba99




# Folders Description 
1) **Hardware Development** Includes videos and Simulink models of the control schemes implemented on hardware.
2) **Intelligent Control for Electric Trucks** Contains a presentation on intelligent control developed for the heavy-duty electric trucks. (Work in progress.)
3) **MTPA Control** Provides scripts to compute the Maximum Torque Per Ampere (MTPA) trajectory for the entire speed and torque range of PMSM. The generated lookup tables are used for integrating MTPA into PMSM control.
4) **Physics Constraint NN Based Torque Observer** Contains Python code and the dataset used to develop the torque observer based on physics-constrained neural networks.
5) **Physics Informed NN Based Parameter Estimation** Includes presentation related to the development of parameter estimation using Physics-Informed Neural Networks (PINNs). This work has not yet been reported in the PMSM control literature.

# Publications 
1) A. H. Safder, A. Hanif and Q. Ahmed, "Optimal Torque Allocation for Energy Efficient Operation of Dual E-Axle Based Powertrain for Heavy Duty Electric Vehicles," 2025 IEEE/AIAA Transportation Electrification Conference and Electric Aircraft Technologies Symposium ITEC+EATS), Anaheim, CA, USA, 2025, pp. 1-6, doi: 10.1109/ITEC63604.2025.11098060. ([link](https://ieeexplore.ieee.org/document/11098060))
2) A. H Safder, A. Hanif, Q. Ahmed, C. G. Cantimer and V. Horta, “Need of Dynamic Drive Control for Efficient Electrified Powertrain in Automotive Industry”, in 13th IEEE International Conference and Exposition on Electrical and Power Engineering (EPEi), Iaşi, Romania,2024. ([link](https://ieeexplore.ieee.org/document/10758063))
3) A. H. Safder, A. Hanif and Q. Ahmed, "Physics Constrained Neural Network Based Load Torque Observer for Traction Electric Machine," in IEEE Conference on Control Technology and Applications, NEWCASTLE UPON TYNE, UK, 2024. ([link](https://ieeexplore.ieee.org/document/10666631))
4) A. H. Safder, A. Hanif and Q. Ahmed, "Look Ahead Information-Based Optimal Control of Traction Electric Machine for Energy-Efficient Operations," in 25th IEEE Workshop on Control and Modeling for Power Electronics, Lahore, Pakistan, 2024.([link](https://ieeexplore.ieee.org/document/10614027))
5) A. Hanif, A. H. Safder, Hassam Moazzam and Q. Ahmed, "Linear Parameter Varying Control for Permanent Magnet Synchronous Motor-Based Electrified Powertrain," in IEEE Workshop on Control and Modeling for Power Electronics, Lahore, Pakistan, 2024. ([link](https://ieeexplore.ieee.org/document/10614058))
6) A. H. Safder, A. Hanif and Q. Ahmed, "Load Torque Estimation for Efficient Operation of PMSM-Based Electrified Powertrain," in IEEE Transportation Electrification Conference & Expo (ITEC), Rosemont, 2024.([link](https://ieeexplore.ieee.org/document/10599061))
7) A. H. Safder, A. Hanif, M. A. Saqib and F. Tanveer, "Compensating the Performance of PMSM Based Electrified Powertrain Through Sliding Mode Control," 2023 IEEE Applied Power Electronics Conference and Exposition (APEC), Orlando, FL, USA, 2023, pp. 2413-2418, doi: 10.1109/APEC43580.2023.10131502.([link](https://ieeexplore.ieee.org/document/10131502))


# Patent
1) A. H. Safder, A. Hanif, and Q. Ahmed. "Range extension with optimal traction control for multi e-axle based electrified vehicles." U.S. Patent Application No. 19/207,877. ([link](https://patents.google.com/patent/US20250353380A1/en))

