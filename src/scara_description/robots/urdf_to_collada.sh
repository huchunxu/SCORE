#!/bin/bash

set -x
set -e
rosrun collada_urdf urdf_to_collada mxx_scara.urdf  mxx_scara.dae
rosrun moveit_kinematics round_collada_numbers.py  mxx_scara.dae mxx_scara.round.dae 5

sed -i '/<\/articulated_system>/i \
                        <extra type="manipulator" name="manipulator"> \
                          <technique profile="OpenRAVE"> \
                            <frame_origin link="base_link"\/> \
                            <frame_tip link="link3"\/> \
                          <\/technique> \
                        <\/extra> ' mxx_scara.round.dae

openrave.py --database inversekinematics --robot=mxx_scara.round.dae  --manipname=manipulator --iktype=Translation3D --iktests=10 #TranslationZAxisAngle4D
