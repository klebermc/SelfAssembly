# Attached_UAVs

Simulink models for physically connected (docked) quadrotors flying as one compound
vehicle, linked to V-REP through `vrep_comm.m`.

**Credit.** Parts of this folder were provided by labmates and were not written by the
repository author:

- the left-invariant extended Kalman filter (LIEKF) attitude estimator: `RiccatiCov.m`,
  `propagation.m`, `skew_sym_3.m` and the estimator blocks in the `*_LIEKF.slx` models;
- the cooperative-transportation controller: `kumar_controller.m` and the controller
  blocks in `control_3quads_attached_Kumar.slx`.

Both are implementations of published methods:

> A. Barrau and S. Bonnabel, "The invariant extended Kalman filter as a stable observer,"
> IEEE Transactions on Automatic Control, vol. 62, no. 4, 2017.

> D. Mellinger, M. Shomin, N. Michael and V. Kumar, "Cooperative grasping and transport
> using multiple quadrotors," Distributed Autonomous Robotic Systems (DARS), 2010.
