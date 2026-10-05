# rrt

2D Rapidly-exploring Random Tree (RRT) path planner used by `../sim_flocking_IFAC.m` to
plan the path of the pinned UAV around obstacles:

```matlab
path = rrt(obstacles, area_dimensions, range_obstacles, start, finish)
```

**Credit.** This implementation was provided by a labmate and adapted for the paper's
simulations; it was not written by the repository author. The algorithm itself is public
knowledge, introduced in:

> S. M. LaValle, "Rapidly-exploring random trees: A new tool for path planning,"
> Technical Report TR 98-11, Computer Science Department, Iowa State University, Oct. 1998.
