# SelfAssembly

> **Note:** All code in this repository was written by Kleber Cabral, except where credited otherwise (see [Notes on what's included / excluded](#notes-on-whats-included--excluded)). The README documentation and inline code comments were added with AI assistance (Claude).

Umbrella repository for Kleber Cabral's robotic self-assembly research cluster (PhD work,
2019-2023): a series of papers on decentralized strategies for multi-robot self-assembly
of 3D structures, sharing common simulation infrastructure and real-hardware validation.

One repo, one subfolder per paper, with the simulation infrastructure they all build on
factored out into `shared/` instead of duplicated per paper.

## Structure

- `shared/` — common simulation infrastructure used across multiple papers:
  - `AuxiliarLibs/` — core self-assembly/network-control MATLAB helper functions.
  - `core_sim/` — the underlying multi-agent network-control assembly simulation
    (`sim_assembly_*.m` variants: Manhattan-distance rules, diffusion, momentum,
    Nesterov, pinning/virtual-tree control).
  - `Attached_UAVs/` — Simulink models for physically-connected/docked quadrotor
    control.
  - `VREP_scenes/` — CoppeliaSim/V-REP scene files (`.ttt`) for the simulated UAVs.
- `real-uavs/` — real-hardware flight-test evidence shared across the cluster: drone-to-
  drone messaging code, Simulink mission supervisors, real assembly photos/frame
  sequences and a short demo video, system-ID logs. Not tied to one paper.
- `2019-syscon-design/` — paper #9, **2019 IEEE SysCon**, "Design of a Self-Assembly
  System" (pyramid/stairs structures).
- `2020-syscon-pinning-formation/` — paper #8, **2020 IEEE SysCon**, "Autonomous
  Assembly Using Pinning Control" (pyramid via formation control).
- `2020-ifac-obstacle-avoidance/` — paper #7, **2020 IFAC**, "Obstacle Avoidance of
  Swarms Using Pinning Control".
- `2023-jirs-layered-3d/` — paper #4, **2023 Journal of Intelligent & Robotic
  Systems**, "Design of a Decentralized Strategy for Layered Self-Assembly of 3D
  Structures Using Robotic Blocks" — the culmination/journal extension of the SysCon/
  IFAC conference work above.

Each paper folder has its own `src/` simulation code and, where available, `figures/`
and `results/`. The papers themselves are linked below rather than included; the conference talks' slides
are in each folder's `presentation/`.

## Papers

| Folder | Authors | Paper | Slides |
|---|---|---|---|
| `2019-syscon-design/` | Kleber M. Cabral, Sidney N. Givigi Jr., Sérgio R. Barros dos Santos, Peter T. Jardine | [doi:10.1109/SYSCON.2019.8836938](https://doi.org/10.1109/SYSCON.2019.8836938) | [PDF](2019-syscon-design/presentation/SysCon2019_slides.pdf) |
| `2020-syscon-pinning-formation/` | Kleber M. Cabral, Sidney N. Givigi Jr., Peter T. Jardine | [doi:10.1109/SysCon47679.2020.9275901](https://doi.org/10.1109/SysCon47679.2020.9275901) | [PDF](2020-syscon-pinning-formation/presentation/SysCon2020_slides.pdf) |
| `2020-ifac-obstacle-avoidance/` | Kleber M. Cabral, Sidney N. Givigi, Peter T. Jardine | [doi:10.1016/j.ifacol.2020.12.2608](https://doi.org/10.1016/j.ifacol.2020.12.2608) | — |
| `2023-jirs-layered-3d/` | Kleber Cabral, Tanvir Kaykobad, Jean-Alexis Delamer, Peter Jardine, Sidney Givigi | [doi:10.1007/s10846-023-01825-2](https://doi.org/10.1007/s10846-023-01825-2) (open access) | — (journal) |

## Videos

JIRS 2023 (`2023-jirs-layered-3d/`):

- [Real drones assembling stairs, 12 blocks](https://youtu.be/l1Q2W28R6DU)
- [Real drones assembling stairs, 6 blocks](https://youtu.be/WJ4kyx_M0xs)
- [Real-world docking](https://youtu.be/-uk45pwKqig)
- [Real quadrotor blocks assembling a structure, next to the block positions over time](https://youtu.be/zHvi8zz1TPk)
- [V-REP simulation](https://youtu.be/gZYQwoK7EZs)
- [Chair structure simulations](https://youtu.be/49m_lrOyueU): the proposed approach (slowest version) next to the baseline approach (fastest version), then the proposed approach with its graph being assembled; played at 3x speed

IFAC 2020 (`2020-ifac-obstacle-avoidance/`):

- [Swarm and formation obstacle-avoidance simulations](https://youtu.be/i_KIDDcos-0). These are preliminary studies; for the final results, see the paper.
- [Conference presentation (recorded talk)](https://youtu.be/jylsfQOC8QE)

SysCon 2020 (`2020-syscon-pinning-formation/`):

- [Quadrotor simulations assembling a column and a pyramid](https://youtu.be/yd4kUprGvcw)
- [Conference presentation (recorded talk)](https://youtu.be/i_F159RKKrc)

## Notes on what's included / excluded

- **Videos not in git.** Simulation recordings, real-drone experiment footage and the
  recorded conference talks (hundreds of MB; one file is over GitHub's 100MB limit) sit in
  each paper folder's `videos/`, which is gitignored. Uploaded ones are linked
  under [Videos](#videos). Small, already-compressed demo clips (e.g.
  `real-uavs/figures_stairs_3blocks_complete/video.mp4`, under 1MB) are kept in git.
- **No paper documents.** Paper PDFs and LaTeX sources are not included; see the DOI links
  above. Conference slides are included as PDFs.
- **Paper #8's real-hardware formation-control code** (`formation_with_real_uavs.slx` and
  its Python/MATLAB counterparts) lives in the separate `MultiRobotSystems` repo.
- Build artifacts (`slprj/`, Simulink `*_ert_rtw/` codegen folders, `.slxc` compiled
  caches, `__pycache__/`, `.DS_Store`) were stripped — regenerated automatically by
  MATLAB/Simulink/Python on demand.
- Hardcoded absolute paths in paper #4's import scripts were changed to relative ones.
- **V-REP remote API bindings are not included** (they ship with V-REP/CoppeliaSim under
  their own license). To run the models in `shared/Attached_UAVs/`, copy `remApi.m`,
  `remoteApiProto.m` and the `remoteApi` library for your platform from your simulator
  install into that folder.
- **Third-party code: the 2D RRT planner.** `2020-ifac-obstacle-avoidance/src/rrt/` is an
  implementation provided by a labmate (see the folder's README), based on LaValle's RRT
  algorithm (TR 98-11, Iowa State University, 1998). The paper #7 simulation calls it to
  plan the pinned UAV's path.
- **Third-party code: attached-UAV estimator and controller.** In `shared/Attached_UAVs/`,
  the LIEKF attitude estimator and the cooperative-transportation controller were
  provided by labmates (see the folder's README for files and references).
- **Quadrotor-with-load RRT planner not included.** Some preliminary obstacle-avoidance experiments for
  paper #7 used a separate external RRT planner for a quadrotor with a suspended load; that code
  is not redistributed here. The paper's own scripts do not depend on it.
- **Real-flight scripts need a drone server.** The scripts in `real-uavs/` connect to a lab
  drone server; its address is replaced by the placeholder `'DRONE_SERVER_IP'`. The
  full-workspace snapshots saved during flights are not included, only the recorded state
  history used for plotting (`flight_states_*.mat`).

## Status

Archival — PhD-era research code (2019-2023), not actively developed. Consolidated into
this structure on 2026-09-11.
