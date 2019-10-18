# mavros

#### 坐标系定义的差异Reference Frames and ROS

The local/world and world frames used by ROS and PX4 are different.

| Frame | ROS                                                          | PX4                                             |
| ----- | ------------------------------------------------------------ | ----------------------------------------------- |
| Body  | FLU (X **F**orward, Y **L**eft, Z **U**p), usually named `base_link` | FRD (X **F**orward, Y **R**ight and Z **D**own) |
| World | ENU (X **E**ast, Y **N**orth and Z Up), with the naming being `odom` or `map` | NED (X **N**orth, Y **E**ast, Z **D**own)       |

> See [REP105: Coordinate Frames for Mobile Platforms](http://www.ros.org/reps/rep-0105.html) for more information about ROS frames.

Both frames are shown in the image below (NED on left/ENU on right).

![Reference frames](http://dev.px4.io/v1.9.0/assets/lpe/ref_frames.png)

When using external heading estimation, magnetic North is ignored and faked with a vector corresponding to world *x* axis (which can be placed freely during Vision/MoCap calibration). Yaw angle is therefore given with respect to local *x*.

> When creating the rigid body in the MoCap software, remember to first align the robot's local *x* axis with the world *x* axis otherwise yaw estimation will have an initial offset.

Using MAVROS, this operation is straightforward. ROS uses ENU frames as convention, therefore position feedback must be provided in ENU. If you have an Optitrack system you can use [mocap_optitrack](https://github.com/ros-drivers/mocap_optitrack) node which streams the object pose on a ROS topic already in ENU. With a remapping you can directly publish it on `mocap_pose_estimate` as it is without any transformation and MAVROS will take care of NED conversions.