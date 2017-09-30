#!/usr/bin/python
import rospy
import random
import tf
from tf.transformations import euler_from_quaternion, quaternion_from_euler

from nav_msgs.msg import *
from geometry_msgs.msg import *
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal

import numpy as np
import actionlib
from actionlib_msgs.msg import GoalStatusArray, GoalID

from timeit import default_timer as timer

config_freeGrid_max = 31;
config_freeGrid_min = 0;
config_min_boundies_count = 1;
config_debug = True;

class Grid_map():
    odom = None;
    move_base = None;
    move_base_status = None;
    target = "cartographer";
    navatigating = False;
    boundaries = {};
    max_boundary_index = 1; # 0 is reserved, start form 1;
    black_list = [];
    goal_list = [];
    pub_boundaries = None;
    pub_goal_points = None
    map_origin_x = 0;
    map_origin_y = 0;
    resolution = 0;
    robot_position_x = 0;
    robot_position_y = 0;
    map_msg = None;
    lastest_goal = None;
    margin_verify = lambda self,height, row, max_height, max_row, userMap, default_value: default_value if (height < 0 or row < 0 or height >= max_height or row >= max_row) and True else userMap[height, row]
    def __init__(self):
        self.odom = tf.TransformListener();
        self.move_base = actionlib.SimpleActionClient('move_base', MoveBaseAction);
        self.move_base.wait_for_server(rospy.Duration(5));

        if config_debug: 
            self.pub_boundaries = rospy.Publisher('/intel_boundaries', GridCells, queue_size=1)
            self.pub_candidate_goal_points = rospy.Publisher('/intel_goal_candidate', GridCells, queue_size=1)

        self.pub_movebase_cancle = rospy.Publisher('move_base/cancel', GoalID,queue_size=1)
        rospy.Subscriber('/move_base/status', GoalStatusArray, self.movebase_status_callback, queue_size=1)

        if (self.target == "cartographer"):
            rospy.Subscriber("/map", OccupancyGrid, self.save_map_data, queue_size=1);
            print "Boot intel cartographer auto slam...."

        rospy.Timer(rospy.Duration(1), self.process_map)
        return;

    def map_to_grid(self, global_x, global_y):
        grid_x = int(np.floor((global_x - self.map_origin_x) / self.resolution))
        grid_y = int(np.floor((global_y - self.map_origin_y) / self.resolution))
        return grid_x, grid_y

    def grid_to_map(self, grid_x, grid_y):
        p = Point();
        p.x = (grid_x * self.resolution + self.map_origin_x) + (self.resolution/ 2)
        p.y = (grid_y * self.resolution + self.map_origin_y) + (self.resolution/ 2)
        p.z = 0;
        return p; 

    def check_blacklist(self, height, row):
        return False;
        for grid_point in self.black_list:
            distance = np.sqrt((grid_point.y - height)**2 + (grid_point.x - row)**2);
            if distance < 4:
                return False
        return True;

    def navigate_to_index(self, index=0, angle=0):
        height = -1;
        row = -1;
        while True:
            if len(self.goal_list) <= 0:
                return False;
            goal = self.goal_list.pop(0);
            height = self.boundaries[goal[0]]['centrolid'][0]
            row = self.boundaries[goal[0]]['centrolid'][1]
            
            if False == self.check_blacklist(height, row):
                break
            else:
                height = -1;
                row = -1;

        if -1 == height or -1 == row:
            height = self.robot_position_y
            row = self.robot_position_x
            angle = 6.28;

        target = self.grid_to_map(row, height)
        goal_pose = MoveBaseGoal()
        goal_pose.target_pose.header.frame_id = 'map'
        goal_pose.target_pose.header.stamp = rospy.Time.now()
        goal_pose.target_pose.pose.position.x = target.x 
        goal_pose.target_pose.pose.position.y = target.y 
        if angle == 0: 
            w = random.random() * 2 * np.pi
        else:
            w = angle
        goal_pose.target_pose.pose.orientation.w, goal_pose.target_pose.pose.orientation.x, goal_pose.target_pose.pose.orientation.y, goal_pose.target_pose.pose.orientation.z = quaternion_from_euler(w, 0.0, 0.0)
        self.lastest_goal = Point(row, height, 0);
        self.move_base.send_goal(goal_pose)
        return True;

    def cancle_all_goal(self):
        cancel = GoalID()
        self.pub_movebase_cancle.publish(cancel)
        return;

    def movebase_status_callback(self, msg):
        for goal in msg.status_list:
            if goal.status <= 2:
                continue;

            if goal.status == 3:
                self.navatigating = False;

            if goal.status > 3:
                self.cancle_all_goal();
                if len(self.goal_list) <= 0:
                    self.navatigating = False;
                    return;
                self.navigate_to_index(0, 0);
        return;

    def merge_boundary(self, height, row, boundaryMap, index1, index2):
        for point in self.boundaries[index2]['points'] :
            boundaryMap[point[0], point[1]] = index1;    

        self.boundaries[index1]['points'] = self.boundaries[index1]['points'] + self.boundaries[index2]['points'];
        self.boundaries[index1]['cnt'] = self.boundaries[index1]['cnt'] + self.boundaries[index2]['cnt'] + 1;
        self.boundaries[index1]['points'].append((height, row));
        boundaryMap[height, row] = index1;
        self.boundaries.pop(index2);
        return;
    
    def add_to_boundary(self, height, row, boundaryMap, index):
        boundaryMap[height, row] = index;    
        self.boundaries[index]['points'].append((height, row));  
        self.boundaries[index]['cnt'] += 1;
        return;

    def new_boundary(self, height, row, boundaryMap):
        self.boundaries[self.max_boundary_index] = {'cnt':1, 'points':[(height, row)], 'centrolid':(-1, -1), 'distance':0.0};
        boundaryMap[height, row] = self.max_boundary_index;
        self.max_boundary_index += 1;
        return;
    
    def calculate_distance(self, height, row):
        return np.sqrt((height-self.robot_position_y)**2 + (row-self.robot_position_x)**2);
    
    def get_valid_point(self, height, row, costMap, max_height, max_row):
        valid_point = [];
        
        for y in range(height-1, height+2, 1):
            for x in range(row-1, row+2, 1):
                if y >=0 and y < max_height and x >= 0 and x < max_row:
                    valid_point.append((y, x));
        
        return valid_point;

    def get_closest_valid_cell(self, height, row, costMap, max_height, max_row):
        unexplored = []
        explored = [(height, row)]
        unexplored.extend(self.get_valid_point(height, row, costMap, max_height, max_row))
        while True:
            tmp = unexplored.pop(0)

            if (tmp[0], tmp[1]) in explored:
                continue

            explored.append(tmp)
            if (self.margin_verify(tmp[0], tmp[1], max_height, max_row, costMap, -1) < config_freeGrid_max and  self.margin_verify(tmp[0], tmp[1], max_height, max_row, costMap, -1) > config_freeGrid_min):
                return tmp
            else:
                unexplored.extend(self.get_valid_point(tmp[0], tmp[1], costMap, max_height, max_row))
    
    def calculate_goal_point(self, costMap, max_height, max_row):
        self.goal_list = [];
        for key in self.boundaries.keys(): 
            mean_point = np.mean( np.array(self.boundaries[key]['points'], dtype='int32'), axis=0, keepdims=True, dtype='int32');
            mean_height, mean_row = self.get_closest_valid_cell(mean_point[0][0],mean_point[0][1], costMap, max_height, max_row)
            self.boundaries[key]["centrolid"] = (mean_height, mean_row);
            self.boundaries[key]['distance'] =  self.calculate_distance(mean_height, mean_row);
            self.goal_list.append([key, self.boundaries[key]['distance'], self.boundaries[key]['cnt']])
        
        #based on the distance, sort all the point
        self.goal_list = sorted(self.goal_list, key=lambda x:x[1])
        return;
    
    def connected_filter(self, costMap, binMap, boundaryMap, row, height, max_height, max_row):
        print costMap[height, row]
        if costMap[height, row] ==  -1:
            connector1 = lambda:self.margin_verify(height - 1, row -1, max_height, max_row, costMap, -1); 
            connector2 = lambda:self.margin_verify(height - 1, row, max_height, max_row, costMap, -1); 
            connector3 = lambda:self.margin_verify(height - 1, row + 1, max_height, max_row, costMap, -1); 
            connector4 = lambda:self.margin_verify(height, row - 1, max_height, max_row, costMap, -1); 
            connector5 = lambda:self.margin_verify(height, row + 1, max_height, max_row, costMap, -1); 
            connector6 = lambda:self.margin_verify(height + 1, row -1, max_height, max_row, costMap, -1); 
            connector7 = lambda:self.margin_verify(height + 1, row, max_height, max_row, costMap, -1); 
            connector8 = lambda:self.margin_verify(height + 1, row + 1, max_height, max_row, costMap, -1); 

            if  (connector1() > config_freeGrid_min and connector1() < config_freeGrid_max) or (connector2() > config_freeGrid_min and connector2() < config_freeGrid_max) or \
                (connector3() > config_freeGrid_min and connector3() < config_freeGrid_max) or (connector4() > config_freeGrid_min and connector4() < config_freeGrid_max) or \
                (connector5() > config_freeGrid_min and connector5() < config_freeGrid_max) or (connector6() > config_freeGrid_min and connector6() < config_freeGrid_max) or \
                (connector7() > config_freeGrid_min and connector7() < config_freeGrid_max) or (connector8() > config_freeGrid_min and connector8() < config_freeGrid_max) :

                binMap[height, row] = 1;

                connector1 = lambda:self.margin_verify(height - 1, row -1, max_height, max_row, binMap, 0); 
                connector2 = lambda:self.margin_verify(height - 1, row, max_height, max_row, binMap, 0); 
                connector3 = lambda:self.margin_verify(height - 1, row + 1, max_height, max_row, binMap, 0); 
                connector4 = lambda:self.margin_verify(height, row - 1, max_height, max_row, binMap, 0); 

                if  connector1() == 1 and connector3() == 1 and boundaryMap[height-1, row -1] != boundaryMap[height -1, row +1] : 
                    self.merge_boundary(height, row, boundaryMap,  boundaryMap[height-1, row-1], boundaryMap[height-1, row+1])
                    return;
                if  connector4() == 1 and connector2() == 1 and boundaryMap[height, row -1] != boundaryMap[height -1, row]: 
                    self.merge_boundary(height, row, boundaryMap, boundaryMap[height, row-1], boundaryMap[height-1, row])
                    return;
                if  connector4() == 1 and connector3() == 1 and boundaryMap[height, row -1] != boundaryMap[height -1, row + 1]: 
                    self.merge_boundary(height, row, boundaryMap, boundaryMap[height, row-1], boundaryMap[height-1, row+1])
                    return;
                if  connector1() == 1 :
                    self.add_to_boundary(height, row, boundaryMap, boundaryMap[height-1, row-1]);
                    return;
                if  connector2() == 1 :
                    self.add_to_boundary(height, row, boundaryMap, boundaryMap[height-1, row]);
                    return;
                if  connector3() == 1 :
                    self.add_to_boundary(height, row, boundaryMap, boundaryMap[height-1, row+1]);
                    return;
                if  connector4() == 1 :
                    self.add_to_boundary(height, row, boundaryMap, boundaryMap[height, row-1]);
                    return;

                self.new_boundary(height, row, boundaryMap);
        return;

    def process_grid(self, costMap, binMap, boundaryMap):
        max_height = costMap.shape[0];
        max_row = costMap.shape[1];
        
        for height in range(0, max_height):
            for row in range(0, max_row):
                 if costMap[height, row] ==  -1:
                     connector1 = lambda:self.margin_verify(height - 1, row -1, max_height, max_row, costMap, -1); 
                     connector2 = lambda:self.margin_verify(height - 1, row, max_height, max_row, costMap, -1); 
                     connector3 = lambda:self.margin_verify(height - 1, row + 1, max_height, max_row, costMap, -1); 
                     connector4 = lambda:self.margin_verify(height, row - 1, max_height, max_row, costMap, -1); 
                     connector5 = lambda:self.margin_verify(height, row + 1, max_height, max_row, costMap, -1); 
                     connector6 = lambda:self.margin_verify(height + 1, row -1, max_height, max_row, costMap, -1); 
                     connector7 = lambda:self.margin_verify(height + 1, row, max_height, max_row, costMap, -1); 
                     connector8 = lambda:self.margin_verify(height + 1, row + 1, max_height, max_row, costMap, -1); 

                     if  (connector1() > config_freeGrid_min and connector1() < config_freeGrid_max) or (connector2() > config_freeGrid_min and connector2() < config_freeGrid_max) or \
                         (connector3() > config_freeGrid_min and connector3() < config_freeGrid_max) or (connector4() > config_freeGrid_min and connector4() < config_freeGrid_max) or \
                         (connector5() > config_freeGrid_min and connector5() < config_freeGrid_max) or (connector6() > config_freeGrid_min and connector6() < config_freeGrid_max) or \
                         (connector7() > config_freeGrid_min and connector7() < config_freeGrid_max) or (connector8() > config_freeGrid_min and connector8() < config_freeGrid_max) :

                         binMap[height, row] = 1;

                         connector1 = lambda:self.margin_verify(height - 1, row -1, max_height, max_row, binMap, 0); 
                         connector2 = lambda:self.margin_verify(height - 1, row, max_height, max_row, binMap, 0); 
                         connector3 = lambda:self.margin_verify(height - 1, row + 1, max_height, max_row, binMap, 0); 
                         connector4 = lambda:self.margin_verify(height, row - 1, max_height, max_row, binMap, 0); 

                         if  connector1() == 1 and connector3() == 1 and boundaryMap[height-1, row -1] != boundaryMap[height -1, row +1] : 
                             self.merge_boundary(height, row, boundaryMap,  boundaryMap[height-1, row-1], boundaryMap[height-1, row+1])
                             continue;
                         if  connector4() == 1 and connector2() == 1 and boundaryMap[height, row -1] != boundaryMap[height -1, row]: 
                             self.merge_boundary(height, row, boundaryMap, boundaryMap[height, row-1], boundaryMap[height-1, row])
                             continue;
                         if  connector4() == 1 and connector3() == 1 and boundaryMap[height, row -1] != boundaryMap[height -1, row + 1]: 
                             self.merge_boundary(height, row, boundaryMap, boundaryMap[height, row-1], boundaryMap[height-1, row+1])
                             continue;
                         if  connector1() == 1 :
                             self.add_to_boundary(height, row, boundaryMap, boundaryMap[height-1, row-1]);
                             continue;
                         if  connector2() == 1 :
                             self.add_to_boundary(height, row, boundaryMap, boundaryMap[height-1, row]);
                             continue;
                         if  connector3() == 1 :
                             self.add_to_boundary(height, row, boundaryMap, boundaryMap[height-1, row+1]);
                             continue;
                         if  connector4() == 1 :
                             self.add_to_boundary(height, row, boundaryMap, boundaryMap[height, row-1]);
                             continue;

                         self.new_boundary(height, row, boundaryMap);

        self.calculate_goal_point(costMap, max_height, max_row);
        
        if config_debug:
            msg_goal_points = GridCells()
            msg_goal_points.header.frame_id = 'map'
            msg_goal_points.cell_width = self.resolution
            msg_goal_points.cell_height = self.resolution 
            
            msg_boundies = GridCells() 
            msg_boundies.header.frame_id = 'map'
            msg_boundies.cell_width = self.resolution
            msg_boundies.cell_height = self.resolution 

            for key in self.boundaries.keys(): 
                for point in self.boundaries[key]['points']:
                    msg_boundies.cells.append(self.grid_to_map(point[1], point[0]));

            for goal  in self.goal_list:
                msg_goal_points.cells.append(self.grid_to_map(self.boundaries[goal[0]]['centrolid'][1], self.boundaries[goal[0]]['centrolid'][0]));
                    
            self.pub_boundaries.publish(msg_boundies)
            self.pub_candidate_goal_points.publish(msg_goal_points)

        return;

    def save_map_data(self, OccupancyGrid):
        self.map_msg = OccupancyGrid;

    def process_map(self, event):
        if self.target == "cartographer":
            OccupancyGrid = self.map_msg;
        elif self.target == "gmapping":
            get_map_srv = rospy.ServiceProxy('/dynamic_map', GetMap)
            OccupancyGrid = get_map_srv().map

        if None == OccupancyGrid:
            return;

        start = timer()
        self.resolution = OccupancyGrid.info.resolution
        self.map_origin_x = OccupancyGrid.info.origin.position.x; 
        self.map_origin_y = OccupancyGrid.info.origin.position.y;

        (trans, rot) = self.odom.lookupTransform('map', 'base_link', rospy.Time(0))
        self.robot_position_x, self.robot_position_y = self.map_to_grid(trans[0], trans[1]);

        self.boundaries = {};
        self.max_boundary_index = 1;

        costMap = np.array(OccupancyGrid.data, dtype='int8');
        costMap.resize(OccupancyGrid.info.height, OccupancyGrid.info.width);
        binMap = np.zeros((OccupancyGrid.info.height, OccupancyGrid.info.width), dtype='bool');
        boundaryMap = np.zeros((OccupancyGrid.info.height, OccupancyGrid.info.width), dtype='int32');

        #main process
        self.process_grid(costMap, binMap, boundaryMap);
        
        if (len(self.goal_list) > 0):
            goal = self.goal_list.pop(0);
            height = self.boundaries[goal[0]]['centrolid'][0]
            row = self.boundaries[goal[0]]['centrolid'][1]
            if False == self.navigate_to_index(0, 0):
                print "Navigation Failure...."
        else:
            self.navigate_to_index(-1, 6.24);
            print "Auto slam has Ended...............";

        self.navatigating = False;
        end = timer();
        print "This Process cost : [%f] s" %(end - start)      
        return;
    
    def __del__(self):
        return;
    
def main():
    rospy.init_node('intel_automatic_slam');
    grid_map = Grid_map();
    rate = rospy.Rate(0.5);
    rospy.spin();   

if __name__ == '__main__':
    main();
