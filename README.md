Vehicle Dynamics & Cornering Performance Analysis Tool

Introduction: For this initial tool, I built a procedural data generator in MATLAB to create synthetic telemetry. I used trigonometric functions to simulate cornering phases and injected Gaussian noise to replicate real-world sensor vibration. This allowed me to test and validate my signal filtering algorithms before applying them to real track data.

1. The Objective: A custom MATLAB-based telemetry data processing pipeline designed to evaluate vehicle handling limits and driver performance. Trackside data acquisition systems often produce noisy sensor outputs due to heavy chassis vibration. The objective of this tool is to ingest raw speed and yaw rate telemetry, apply low-pass filtering (moving average), and derive clean, actionable longitudinal and lateral acceleration metrics ($A_x$ and $A_y$).By generating dynamic G-G diagrams (Traction Circles) and color-coded track maps, this tool allows race engineers to rapidly assess driver inputs, isolate heavy braking zones, and identify areas for setup optimization on demanding circuits.


2.Vehicle Traction Circle (G-G Diagram)
<img width="1000" height="875" alt="TCANALYSIS 1" src="https://github.com/user-attachments/assets/715f189b-76ff-4c6c-916e-846c11ee01da" />


Track Map: Braking and Acceleration Zones
<img width="1000" height="875" alt="MAPANALYSIS 1" src="https://github.com/user-attachments/assets/ccbbeaaa-1f79-4615-a9d8-8550cf20aba0" />
 



3. Conclusion: The generated G-G Diagram clearly visualizes the vehicle's friction ellipse, mapping the crucial transition between mechanical grip in low-speed sectors and aerodynamic downforce gains in high-speed zones. By plotting the data points against a theoretical friction limit, it becomes evident where the tire's lateral capacity is being maximized and where the driver is under-utilizing the available grip.
Furthermore, the track map successfully maps longitudinal G-forces to specific X-Y coordinates, isolating heavy braking events (negative $A_x$) from corner-exit acceleration. Cross-referencing the track map with the traction circle allows for rapid identification of trail-braking inefficiencies, providing a direct, data-driven pathway to advise the driver on combining brake and steering inputs deeper into the apex to extract maximum lap time from an open-wheel chassis.
