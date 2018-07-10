#!/bin/bash

set -x
set -e
rosrun collada_urdf urdf_to_collada mxx_scara.urdf  mxx_scara.dae
rosrun moveit_kinematics round_collada_numbers.py  mxx_scara.dae mxx_scara.round.dae 5

sed -i '/<\/articulated_system>/i \
                        <extra type="manipulator" name="manipulator"> \
                          <technique profile="OpenRAVE"> \
                            <frame_origin link="base_link"\/> \
                            <frame_tip link="tip_link"\/> \
                          <\/technique> \
                        <\/extra> ' mxx_scara.round.dae

# https://github.com/rdiankov/openrave/issues/596#issuecomment-403673192
# python -c 'import openravepy
# env = openravepy.Environment()
# env.Load("mxx_scara.round.dae")
# robot = env.GetRobots()[0]
# manip = robot.GetManipulators()[0]
# manip.SetLocalToolDirection([1,0,0])
# env.Save("mxx_scara.fix.round.dae")'

script -c 'bash -x -c "openrave.py --database inversekinematics --robot=mxx_scara.round.dae  --manipname=manipulator --iktype=TranslationXAxisAngleZNorm4D --iktests=10" #'

## rosrun moveit_kinematics create_ikfast_moveit_plugin.py scara manipulator scara_ikfast_plugin /home/k-okada/.openrave/kinematics.0521325f83e4c7fe374f34511d3dc035/ikfast0x1000004a.TranslationXAxisAngleZNorm4D.0_1_2_3.cpp
