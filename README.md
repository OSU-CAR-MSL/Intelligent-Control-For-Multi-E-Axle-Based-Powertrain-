Copyright (c) 2025 Ahmad Hussain Safder

# Overview
The intelligent control of heavy-duty electric vehicles consists of three steps. In the first step, the strategy leverages information about upcoming driving conditions (e.g., speed limits, road grade, and lead vehicle behavior) to adjust vehicle speed optimally, which leads to reduced energy consumption while balancing travel time. The second step operates at the powertrain level, optimally distributing torque among multiple e-axles to minimize powertrain losses. Finally, the third step focuses on component-level control, ensuring each electric machine operates in a synchronized manner, even under uneven torque allocation, to guarantee safe and reliable vehicle operation. 
<p align="center"><img width="718" height="330" alt="image" src="https://github.com/user-attachments/assets/f1ca4fe5-0a4e-4507-946d-e64db335a978" />Overview of Control Scheme</em>
  
# Step 1: Vehicle Level Optimization 
This step formulates a cost function that combines the vehicle’s energy consumption with the speed tracking error, where the speed limit serves as the reference. A penalty factor is introduced to adjust the trade-off, allowing emphasis to be placed either on minimizing energy use or on maintaining speed tracking. The strategy leverages look-ahead information, including upcoming road grade, speed limits, and the behavior of a lead vehicle, over a defined time horizon, which is further divided into smaller segments to capture variations in the input data. Within each segment, the cost function is evaluated, and optimization techniques are applied to determine the optimal acceleration that minimizes the overall cost across the horizon. In order to solve this problem, gradient-based optimization methods are employed, and the performance of sequential quadratic programming (SQP), interior-point (IP) methods, and dynamic programming (DP) are compared. The resulting optimal acceleration is then used to compute the required driving torque. The choice of penalty factor is particularly critical for heavy-duty electric vehicles. A higher penalty on speed tracking error reduces travel delays but can increase energy usage, while prioritizing energy minimization may extend delivery time and raise operational costs. This research therefore also addresses the optimal selection of the penalty factor, ensuring a balanced trade-off between energy efficiency and travel time.

# Step 2: Torque Allocation To Multi E-Axles 
This step operates at the powertrain level, where it receives the optimal driving torque from Step I along with the current vehicle speed. A cost function is then formulated to capture the power losses of key drivetrain components, including the traction electric machines (EMs), gearbox, and differential. Based on this cost function, the controller determines the optimal torque allocation for each e-axle to minimize overall powertrain losses. Similar to Step I, this strategy employs gradient-based optimization techniques to solve the optimal control problem. My published and ongoing  on this approach utilize sequential quadratic programming (SQP), interior-point (IP) methods, and dynamic programming (DP) to evaluate performance, consistently demonstrating the effectiveness of this control strategy. Unlike conventional supervisory powertrain controllers, however, these methods may sometimes recommend uneven torque splits across e-axles. While effective in reducing losses, this uneven distribution can introduce challenges in maintaining synchronized operation between the e-axles, highlighting the need for advanced coordination mechanisms.
# Step 3: Synchronizing Operation of Traction Electric Machines
At this stage, the impact of optimal torque allocation on traction electric machines (EMs) is addressed, as uneven torque distribution can result in different operating speeds and thermal stresses across the EMs. For safe and reliable vehicle operation, the EMs must remain synchronized in speed. To achieve this, the control strategy assigns adjusted speed references to each EM to ensure coordinated operation.
My research introduces two key novelties at this level. First, it employs machine learning techniques to model and predict EM dynamics, specifically the actual speed response at given torque and speed requests. The predicted responses of all EMs are then compared; if any EM is found to deviate from synchronized operation, its speed reference is adjusted to restore consistency. Second, I propose a physics-informed neural network (PINN)-based parameter estimation method for EMs, which is not currently present in the literature. In this approach, the PINN simultaneously learns EM parameters and network weights while enforcing physical constraints. The learned parameters are then used to reconstruct EM dynamics and verify convergence. If convergence is not achieved, the learning process is reiterated until accurate synchronization is ensured. By integrating this step with the previous levels of optimization, the proposed framework reduces the overall energy consumption of heavy-duty electric vehicles and extends their driving range.
## EM Modeling 
This research work considers the permanent magnet synchronous machine as the traction electric machine. The dynamic equations of PMSM in rotating d-q frame can be expressed as 

 $\frac{di_{d}}{dt}=-\frac{R_{s}}{L_{d}}i_{d}+\frac{\omega_e L_{q}}{L_{d}}i_{q}+\frac{v_{d}}{L_{d}}$


$\frac{di_{q}}{dt}=-\frac{\omega_e L_{d}}{L_{q}}i_{d}-\frac{R_{s}}{L_{q}}i_{q}+\frac{v_{q}}{L_{q}}-\frac{\omega_e\lambda_{m}}{L_{q}} $

$T_{e}=\frac{3}{2}p(\lambda_{m}i_{q}+(L_d-L_q)i_di_q)$

$J\frac{d\omega}{dt}=T_{e}-T_{L}-F\omega$

where $i_{q}$ is quadrature axis current, $i_{d}$ is direct axis current, $R_{s}$ is stator resistance, $\omega_e$ is angular electrical velocity, $T_{e}$ is machine torque, $p$ is number of poles, $\lambda_{m}$ is flux linkage, $T_{L}$ is load torque, $J$ is machine's rotor inertia, $F$ is viscous coefficient, $v_{d}$ direct axis voltage, $v_{q}$ is quadrature axis voltage and lastly $L_{q}$ and $L_{d}$ are equivalent quadrature and direct axis inductance respectively. 

## Hardware Implementation 
The setup includes two 3 kW three-phase PMSM/BLDC machines, 5 kW inverters, and a 5 kVA power source. Each electric machine is coupled with a 1 kW DC generator, which serves as an electric load to emulate the road load conditions.
For control implementation, the setup utilizes a Speedgoat Baseline Real-Time Target Machine, which interfaces seamlessly with MATLAB/Simulink. This enables rapid prototyping and deployment of control algorithms using Simulink blocks directly on the real-time hardware.
<p align="center"><img width="781" height="599" alt="image" src="https://github.com/user-attachments/assets/1c691ef4-87b3-4312-b687-6f033935eb34" />

# Folders Description 
1) **E-axle Synchornization Under Uneven Torque Split** Contains a presentation on control strategies to ensure synchronized operation of e-axles under uneven or optimal torque split. (Work in progress.)
2) **Hardware Development** Includes videos and Simulink models of the control schemes implemented on hardware.
3) **MTPA Control** Provides scripts to compute the Maximum Torque Per Ampere (MTPA) trajectory for the entire speed and torque range of PMSM. The generated lookup tables are used for integrating MTPA into PMSM control.
4) **Physics Constraint NN Based Torque Observer** Contains Python code and the dataset used to develop the torque observer based on physics-constrained neural networks.
5) **Physics Informed NN Based Parameter Estimation** Includes Python code, dataset, and presentation related to the development of parameter estimation using Physics-Informed Neural Networks (PINNs). This work has not yet been reported in the PMSM control literature.

# Publications 
1) A. H. Safder, A. Hanif and Q. Ahmed, "Optimal Torque Allocation for Energy Efficient Operation of Dual E-Axle Based Powertrain for Heavy Duty Electric Vehicles," 2025 IEEE/AIAA Transportation Electrification Conference and Electric Aircraft Technologies Symposium ITEC+EATS), Anaheim, CA, USA, 2025, pp. 1-6, doi: 10.1109/ITEC63604.2025.11098060.
2) A. H Safder, A. Hanif, Q. Ahmed, C. G. Cantimer and V. Horta, “Need of Dynamic Drive Control for Efficient Electrified Powertrain in Automotive Industry”, in 13th IEEE International Conference and Exposition on Electrical and Power Engineering (EPEi), Iaşi, Romania,2024.
3) A. H. Safder, A. Hanif and Q. Ahmed, "Physics Constrained Neural Network Based Load Torque Observer for Traction Electric Machine," in IEEE Conference on Control Technology and Applications, NEWCASTLE UPON TYNE, UK, 2024.
4) A. H. Safder, A. Hanif and Q. Ahmed, "Look Ahead Information-Based Optimal Control of Traction Electric Machine for Energy-Efficient Operations," in 25th IEEE Workshop on Control and Modeling for Power Electronics, Lahore, Pakistan, 2024.
5) A. Hanif, A. H. Safder, Hassam Moazzam and Q. Ahmed, "Linear Parameter Varying Control for Permanent Magnet Synchronous Motor-Based Electrified Powertrain," in IEEE Workshop on Control and Modeling for Power Electronics, Lahore, Pakistan, 2024.
6) A. H. Safder, A. Hanif and Q. Ahmed, "Load Torque Estimation for Efficient Operation of PMSM-Based Electrified Powertrain," in IEEE Transportation Electrification Conference & Expo (ITEC), Rosemont, 2024.
7) A. H. Safder, A. Hanif, M. A. Saqib and F. Tanveer, "Compensating the Performance of PMSM Based Electrified Powertrain Through Sliding Mode Control," 2023 IEEE Applied Power Electronics Conference and Exposition (APEC), Orlando, FL, USA, 2023, pp. 2413-2418, doi: 10.1109/APEC43580.2023.10131502.





