#!/usr/bin/python
import math
import random

import actionlib
import rospy
import tf
from nav_msgs.msg import *
from nav_msgs.srv import *
from GridCell import GridCell
from actionlib_msgs.msg import GoalID, GoalStatusArray
from geometry_msgs.msg import *
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal
from nav_msgs.msg import GridCells, Odometry
from GridCell import GridCell
from nav_msgs.srv import GetMap
from tf.transformations import euler_from_quaternion, quaternion_from_euler
from kobuki_msgs.msg import Sound
from std_msgs.msg import Int32  
import threading
CELL_WIDTH = 0.3
CELL_HEIGHT = 0.3
expanded_cells = []
wall_cells = []
path_cells = []
frontier_cells = []
blacklist_cells = []
blackgroup_cells = []


# calculate target cell from frontier points
def calculate_target_cell(frontier):
    x_sum, y_sum = 0.0, 0.0
    total = len(frontier)

    for cell in frontier:
        x_sum = x_sum + cell.getXpos()
        y_sum = y_sum + cell.getYpos()

    cell_x = int(x_sum / total)
    cell_y = int(y_sum / total)

    cell = costMap[cell_x][cell_y]

    if not cell.isEmpty() or cell.isUnknown():
        cell = find_nearest_free_Gridcell(cell)

    return cell

# find nearest free grid cell
def find_nearest_free_Gridcell(cell):
    unexplored = []
    explored = [cell]

    unexplored.extend(find_neighbor_cells(cell))

    while True:
        tmp = unexplored.pop(0)
        if tmp in explored:
            continue
        explored.append(tmp)
        if tmp.isEmpty() and not tmp.isUnknown():
            return tmp
        else:
            unexplored.extend(find_neighbor_cells(tmp))

#main process
def process_map():
    global nav_goal, unreachable, centroids, done,recount,blanklist, pub_sound, dic,black_groups,dic_last,first_detect
    centroids = []
    frontier = []
        
    if True:
        # Iterate through all of the cells in the global map and collect all the possible frontier cells
        for row in costMap:
            for cell in row: 
                if is_frontier_cell(cell):
                    frontier.append(cell)
        #jingyu modification for test
        #while 1:
        #   for cell in frontier:
        #           deliver_cell(cell.getXpos(), cell.getYpos(), "frontier")
        #   for i in range(10):
        #       deliver_cells()
        #   print'jingyu'
            # Group the frontier cells into continuous frontiers and return them as a list
        groups = classify_frontiers(frontier)
        if slam_algo == "carto":
            groups = filter(lambda l: max_distance(l) >= 1, groups) #WZ: change the distance threshhold for cartographer test
        if slam_algo == "gmapping":
            groups = filter(lambda l: max_distance(l) >= 10, groups)
        if len(groups) == 0:
            groups = frontier
            if len(groups) == 0:
                vel_msg = Twist(Vector3(0,0,0),Vector3(0,0,1))
                rate = rospy.Rate(10)
                stop_navigation()
                print "Warning: no frontier detected. Waiting next round of map data"
                for i in range(30):
                    try:
                        pub_vel.publish(vel_msg)
                        rate.sleep()
                    except:
                        pass
                if first_detect:
                    return
        
        if len(groups) != 0:
            first_detect = False
        
    print "INFO: Found frontiers: ",len(groups)
    for frontier in groups:
        for cell in frontier:
            deliver_cell(cell.getXpos(), cell.getYpos(), "frontier")
    for i in range(10):
        deliver_cells()
    
    # Calculate the centroid of all of the frontiers
    #centroids = map(calculate_target_cell, groups)

    copy_black_groups = black_groups[:]
    copy_groups = groups[:]
    if len(black_groups) != 0 and len(copy_groups) != 0:
        for row in copy_groups:
            repeat_point = 0
            if len(copy_black_groups) != 0:
                for cloum in copy_black_groups:
                    repeat_point = 0
                    for m in row:
                        for n in cloum:
                            if m.getXpos() == n.getXpos() and m.getYpos() == n.getYpos():
                                repeat_point += 1
                                if repeat_point >= 3:
                                    copy_black_groups.remove(cloum)
                                    groups.remove(row)
                                    break
                        if repeat_point >= 3:
                            break
                    if repeat_point >=3:
                        break 

    for row in groups:              
        local_goal = calculate_target_cell(row)
        centroids.append(local_goal)
        dic[str(local_goal)] = row

    if len(centroids) == 0 and not first_detect:  # If there are no centroids, quit.
        beep(Sound.CLEANINGSTART)
        print '*****************DONE*****************'
        stop_navigation()
        done = True
        print "$$$ final total count: %d, black list: %s"%(recount, str(blanklist))
        rospy.signal_shutdown("We done.")
        exit()

    for cell in centroids:
        deliver_cell(cell.getXpos(), cell.getYpos(), "path")
    deliver_cells()

    # Calculate the number of frontier cells in each frontier
    lengths = map(len, groups)
    # Calculate the distance to each centroid
    distances = map(calculate_distance, centroids)

    # Weight each centroid by its distance * # of frontier cells
    weighted_centroid = []
    try:
        for i in range(len(distances)):
            weighted_centroid.append(lengths[i])
            #weighted_centroid.append(lengths[i]/(distances[i]*distances[i]))
    except ZeroDivisionError:
        print "An Distances to centroids is 0 for some reason!"


        abandon_centroids = [0 for i in range(len(centroids))]

        for i in range(len(centroids)):
                for j in range(i+1,len(centroids)):
                        if (math.sqrt((centroids[i].getXpos() - centroids[j].getXpos()) ** 2 + (centroids[i].getYpos() - centroids[j].getYpos()) ** 2)) < 20:
                                abandon_centroids[i] = 1
                                abandon_centroids[j] = 1
                                break

    maximum, index = 0, 0
    for i in range(len(weighted_centroid)):
        if not abandon_centroids[i] and weighted_centroid[i] > maximum:
            maximum = weighted_centroid[i]
            index = i

    flag = False
    print "p2",first_detect
    # The most heavily weighted centroid
    if not unreachable:
        old_nav_goal = nav_goal
        nav_goal = centroids[index] # best dest
        if len(blanklist) != 0:
            try:  
                for row in blanklist:
                    if nav_goal.getXpos() == row.getXpos() and nav_goal.getYpos() == row.getYpos():
                        flag = True # best dest in black list
                        break
                #Weizhi
                for i in range(len(centroids)):
                    if i != index and (math.sqrt((centroids[i].getXpos() - nav_goal.getXpos()) ** 2 + (centroids[i].getYpos() - nav_goal.getYpos()) ** 2)) < 10: #TODO:
                        flag = True
                        break
            except:
                pass

        #if old_nav_goal != nav_goal and nav_goal is not None:  # Change goal if better goal appears.
        if (old_nav_goal is None and nav_goal is not None) or \
        (old_nav_goal.getXpos() != nav_goal.getXpos() and old_nav_goal.getYpos() != nav_goal.getYpos() and not flag and nav_goal is not None):
            stop_navigation()
            print "#########################wilson Better goal available, canceling current..." + str(nav_goal)
           
           
    else:
        recount += 1
        print "####### recount = %d."%(recount)
        Repeat = False
        beep(Sound.ON)
        if len(blanklist) != 0:
            try:
                for row in blanklist:
                    if row.getXpos() == nav_goal.getXpos() and row.getYpos() == nav_goal.getYpos():
                        Repeat = True
                                                #Repeat = False
                        break
            except:
                #print "##### critical exception when detecting best goal in black list. best goal = %s, black list = %s"%(str(nav_goal), str(blanklist))
                pass
               
        if not Repeat:
            #print "###### centroid %s added into black list"%(str(nav_goal))
            #print "###### current black list: %s"%(str(blanklist))
            blanklist.append(nav_goal)
        #else:
            #print "###### current centroid = %s, black list not modified: %s"%(str(nav_goal), str(blanklist))
            #print "@@@@@@ centroid in black list ? %d"%(nav_goal in blanklist)

        centroids_orig = centroids[:]
        for row in centroids_orig:
            if row.getXpos() == nav_goal.getXpos() and row.getYpos() == nav_goal.getYpos():
                centroids.remove(nav_goal)
            
        if len(centroids) != 0 and len(blanklist) != 0:
            #print "@@@@@ centroids before deletion: %s"%(str(centroids))
            try:
                centroids_orig = centroids[:]
                for row in centroids_orig:
                    for cloum in blanklist:
                        if row.getXpos() == cloum.getXpos() and row.getYpos() == cloum.getYpos():
                            centroids.remove(row)
                            #print "@@@@@ centroid %s removed"%(str(row))
                            break

                '''#WEIZHI
                centroids_orig = centroids[:]
                for i in centroids_orig:
                    for j in centroids_orig:
                        if i != j and (math.sqrt((i.getXpos() - j.getXpos()) ** 2 + (i.getYpos() - j.getYpos()) ** 2)) < 10: #TODO: change the hardcode threshold.
                            centroids.remove(i)
                            centroids.remove(j)
                            continue'''


                        except:
                #print "##### critical exception when removing goals from centroids. centroids = %s, black list = %s"%(str(centroids), str(blanklist))
                pass

        if dic_last != {}:
            try:
                black_groups.append(dic_last[str(nav_goal)])
                print "wilson black_groups= " + str(len(black_groups)) + "    dic[str(nav_goal)]" + str(len(dic_last[str(nav_goal)]))
            except:
                print "key error occurred, dic = %s\n\n dic_last = %s\n\n nav_goal = %s"%(str(dic), str(dic_last), str(nav_goal))


        if len(centroids) == 0:
            beep(Sound.CLEANINGSTART)
            print '*****************BlankList DONE*****************'
            stop_navigation()
            done = True
            print "$$$ final total count: %d, black list: %s"%(recount, str(blanklist))
            rospy.signal_shutdown("We done.")
            exit()
        
        nav_goal = centroids[random.randint(0, len(centroids)-1)]
        #nav_goal = centroids[index]
        print "############wilson random nav_goal "+ str(nav_goal) +"  centroids=   " + str(len(centroids))+ "   black list= " +str(blanklist)
        #print "@@@@@@ nav goal in centroids? %d"%(nav_goal in centroids)
        unreachable = False

    #print "Nav Goal " + str(nav_goal)
    print "p3",first_detect
    for blackcell in blanklist:
        deliver_cell(blackcell.getXpos(), blackcell.getYpos(), 'blacklist')
    deliver_cells

    deliver_cell(nav_goal.getXpos(), nav_goal.getYpos(), "expanded")
    deliver_cell(nav_goal.getXpos() + 1, nav_goal.getYpos(), "expanded")
    deliver_cell(nav_goal.getXpos() - 1, nav_goal.getYpos(), "expanded")
    deliver_cell(nav_goal.getXpos(), nav_goal.getYpos() + 1, "expanded")
    deliver_cell(nav_goal.getXpos(), nav_goal.getYpos() - 1, "expanded")
    for i in range(10):
        deliver_cells()


def calculate_distance(centroid_cell):
    cell_x, cell_y = map2grid(x, y)
    return math.sqrt((centroid_cell.getXpos() - cell_x) ** 2 + (centroid_cell.getYpos() - cell_y) ** 2)


def find_neighbor_cells(cell):
    """
    :param cell: The cell, whose neighbors are needed
    :return: A list of cells neightobring cell
    """
    neighbors = []

    x_pos = cell.getXpos()
    y_pos = cell.getYpos()

    # Iterate through the 8 adjacent cells
    for row in range(y_pos - 1, y_pos + 2):
        for col in range(x_pos - 1, x_pos + 2):
            # Filter out bad cells
            if row < 0 or col < 0 or (row == y_pos and col == x_pos):
                continue
            else:
                try:
                    neighbors.append(costMap[col][row])
                except:  # Index out of bounds exception
                    pass

    return neighbors


def has_neighbor_free_Gridcell(neighbors):
    for cell in neighbors:
        if not cell.isUnknown():
            return True
    return False


def is_frontier_cell(cell):
    return cell.isUnknown() and has_neighbor_free_Gridcell(filter(lambda c: c.isEmpty(), find_neighbor_cells(cell)))


def classify_frontiers(ungrouped_frontier):
    frontiers = []
    #print"jingyu start"
    while len(ungrouped_frontier) != 0:
        popped = ungrouped_frontier.pop(0)
        frontier = [popped]
        done = False
        # Just ask Tucker what's going on here
        while not done:
            try:
                for a in ungrouped_frontier:
                    for b in frontier:
                        if IsNeigbor(a, b):
                            frontier.append(a)
                            ungrouped_frontier.remove(a)
                            raise StopIteration  # Using this to break out of outer for loop
                # Finished finding the frontier. Add it to the frontiers list.
                done = True
                frontiers.append(frontier)
            except:  # Using this as a break loop statement
                pass

    return frontiers


def IsNeigbor(a, b):
    return (abs(a.getXpos() - b.getXpos()) <= 1) and (abs(a.getYpos() - b.getYpos()) <= 1)


def callback_odom(msg):
    """
    Odometry callback function.
    :param msg: The odom message.
    """
    global x, y, theta, x_cell, y_cell, pose
    pose = msg.pose

    try:
        (trans, rot) = odom_list.lookupTransform('map', 'base_footprint', rospy.Time(0))

        # Update the x, y, and theta globals every time something changes
        roll, pitch, yaw = euler_from_quaternion(rot)

        x = trans[0]
        y = trans[1]
        theta = yaw
        x_cell, y_cell = map2grid(x, y)
    except:
        pass
        
def max_distance(frontier):
    max_dist = 0
    for a in frontier:     
        for b in frontier:
            dist = math.sqrt((a.getXpos() - b.getXpos())**2 + (a.getYpos() - b.getYpos())**2)
            if dist > max_dist:
                max_dist = dist
               
    return max_dist


def process_map_now(event):
    """
    Request a map from the costmap service.
    """
    global carto_map
    
    if slam_algo == "carto":
        callback_map(carto_map)
    else:
        get_map_srv = rospy.ServiceProxy('/dynamic_map', GetMap)
        callback_map(get_map_srv().map)

    """
    else if slam_algo == "hector":
        map_handle(hector_map.map)
    else if slam_algo == "orbv2":
        map_handle(orbv2_map.map)   
    """


def callback_map(msg):
    """
    Handles when a new global map message arrives.
    :param msg: The map message to process.
    """
    print "******************************Got global map******************************"
    global CELL_WIDTH, CELL_HEIGHT
    global map_width, map_height, occupancyGrid, x_offset, y_offset
    global map_origin_x, map_origin_y, costMap
    global path_cells, wall_cells, frontier_cells, expanded_cells, blacklist_cells, blackgroup_cells,alive

    map_width = msg.info.width
    map_height = msg.info.height
    occupancyGrid = msg.data
    print "Map (width, height): " + str(map_width) + " " + str(map_height)

    CELL_WIDTH = msg.info.resolution
    CELL_HEIGHT = msg.info.resolution

    x_offset = msg.info.origin.position.x + (2 * CELL_WIDTH)
    y_offset = msg.info.origin.position.y - (2 * CELL_HEIGHT)
    map_origin_x = msg.info.origin.position.x
    map_origin_y = msg.info.origin.position.y
    # print "wilson Map origin: ", map_origin_x, map_origin_y,CELL_WIDTH,CELL_HEIGHT,x_offset,y_offset
   
    # Create the costMap
    costMap = [[0 for j in range(map_height)] for j in range(map_width)]

    count = 0
    # iterating through every position in the matrix
    # OccupancyGrid is in row-major order
    # Items in rows are displayed in contiguous memory
    path_cells, wall_cells, frontier_cells, expanded_cells, blacklist_cells, blackgroup_cells = [], [], [], [], [], []
    for y_tmp in range(0, map_height):  # Rows
        for x_tmp in range(0, map_width):  # Columns
            costMap[x_tmp][y_tmp] = GridCell(x_tmp, y_tmp, occupancyGrid[count])  # creates all the gridCells
            count += 1
        inflate_objects()
    deliver_walls()
        print "wilson alive will detect frontiers"
        if alive:
           print "wilson alive detect frontiers"
       process_map()


def inflate_objects():
    global costMap
    for y_tmp in range(0, map_height):  # Rows
        for x_tmp in range(0, map_width):  # Columns
            if costMap[x_tmp][y_tmp].getOccupancyLevel() > 90:
                for y_tmp_2 in range (y_tmp - 5, y_tmp + 6):
                    for x_tmp_2 in range (x_tmp - 5, x_tmp + 6):
                        if math.sqrt((y_tmp_2 - y_tmp)**2 + (x_tmp_2 - x_tmp)**2) > 5:
                            continue
                        try:
                            costMap[x_tmp_2][y_tmp_2].setOccupancyLevel(60)
                        except IndexError:
                            pass
   # print "wilson max aqrt=  ",math.sqrt(map_height**2 + map_width**2)

def map2grid(global_x, global_y):
    """
    Map a global coordinate to a grid cell position.
    :param global_x: The global X coordinate.
    :param global_y: The global Y coordinate.
    :return: A tuple representing the X, Y coordinate on the grid.
    """
    grid_x = int(math.floor((global_x - map_origin_x) / CELL_WIDTH))
    grid_y = int(math.floor((global_y - map_origin_y) / CELL_HEIGHT))
    return grid_x, grid_y


def map2world(grid_x, grid_y):
    """
    Map a grid X and Y to a global X and Y.
    :param grid_x: The grid X position.
    :param grid_y: The grid Y position.
    :return: A tuple representing the X, Y coordinate in the world frame.
    """
    global_x = (grid_x * CELL_WIDTH + map_origin_x) + (CELL_WIDTH / 2)
    global_y = (grid_y * CELL_WIDTH + map_origin_y) + (CELL_HEIGHT / 2)
    return global_x, global_y


def deliver_cell(x_position, y_position, state):
    """
    Creates and adds a cell-location to its corresponding list to be published in the near future
    :param x_position: The X position (in terms of cell number) of the cell to color.
    :param y_position: The Y position (in terms of cell number) of the cell to color.
    :param state: The cell "state" to fill in, either expanded, wall, path, or frontier
    """
    global expanded_cells, frontier_cells, wall_cells, path_cells

    p = Point()
    p.x, p.y = map2world(x_position, y_position)
    # p.x -= CELL_WIDTH / 2
    # p.y -= CELL_HEIGHT / 2
    p.z = 0

    if state == 'expanded':
        expanded_cells.append(p)
    elif state == 'wall':
        wall_cells.append(p)
    elif state == 'path':
        path_cells.append(p)
    elif state == 'frontier':
        frontier_cells.append(p)
    elif state == 'blacklist':
        blacklist_cells.append(p)
    elif state == 'blackgroup':
        blackgroup_cells.append(p)
    else:
        print 'Bad state'


def deliver_cells():
    """
    Publishes messages to display all cells.
    """
    deliver_expanded()
    deliver_frontier()
    deliver_walls()
    deliver_path()
    deliver_blacklist()
    deliver_blackgroup()


def deliver_blacklist():
    """
    Publishes the information stored in unexplored_cells to the map
    """
    global pub_blacklist

    # Information all GridCells messages will use
    msg = GridCells()
    msg.header.frame_id = 'map'
    msg.cell_width = CELL_WIDTH
    msg.cell_height = CELL_HEIGHT

    msg.cells = blacklist_cells
    pub_blacklist.publish(msg)


def deliver_blackgroup():
    """
    Publishes the information stored in unexplored_cells to the map
    """
    global pub_blackgroup

    # Information all GridCells messages will use
    msg = GridCells()
    msg.header.frame_id = 'map'
    msg.cell_width = CELL_WIDTH
    msg.cell_height = CELL_HEIGHT

    msg.cells = blackgroup_cells
    pub_blackgroup.publish(msg)


def deliver_expanded():
    """
    Publishes the information stored in expanded_cells to the map
    """
    global pub_expanded

    # Information all GridCells messages will use
    msg = GridCells()
    msg.header.frame_id = 'map'
    msg.cell_width = CELL_WIDTH
    msg.cell_height = CELL_HEIGHT

    msg.cells = expanded_cells
    pub_expanded.publish(msg)


def deliver_walls():
    """
    Publishes the information stored in frontier_cells to the map
    """
    global pub_walls, costMap, wall_cells

    wall_cells = []
    for y_tmp in range(0, map_height):
        for x_tmp in range(0, map_width):
            if not costMap[x_tmp][y_tmp].isEmpty():
                deliver_cell(x_tmp, y_tmp, 'wall')

    # Information all GridCells messages will use
    msg = GridCells()
    msg.header.frame_id = 'map'
    msg.cell_width = CELL_WIDTH
    msg.cell_height = CELL_HEIGHT

    msg.cells = wall_cells
    pub_walls.publish(msg)


def deliver_path():
    """
    Publishes the information stored in unexplored_cells to the map
    """
    global pub_path

    # Information all GridCells messages will use
    msg = GridCells()
    msg.header.frame_id = 'map'
    msg.cell_width = CELL_WIDTH
    msg.cell_height = CELL_HEIGHT

    msg.cells = path_cells
    pub_path.publish(msg)


def deliver_frontier():
    """
    Publishes the information stored in unexplored_cells to the map
    """
    global pub_frontier

    # Information all GridCells messages will use
    msg = GridCells()
    msg.header.frame_id = 'map'
    msg.cell_width = CELL_WIDTH
    msg.cell_height = CELL_HEIGHT

    msg.cells = frontier_cells
    pub_frontier.publish(msg)


def nav_to_pose(goal):
    global move_base
    goal_pose = MoveBaseGoal()
    goal_pose.target_pose.header.frame_id = 'map'
    goal_pose.target_pose.header.stamp = rospy.Time.now()
    goal_pose.target_pose.pose = goal.pose
    move_base.send_goal(goal_pose)


def stop_navigation():
    cancel = GoalID()
    move_base_cancel.publish(cancel)


def callback_movebase_status(msg):
    global last_active_goal, goal_done, unreachable,tmp_msg,retry,alive
    
    #tmp_msg = msg
    #flag = False
    for goal in msg.status_list:
        if goal.status < 2:
            last_active_goal = goal
            goal_done = False
            retry = 0
        #print "wilson len(msg.status_list)="+str(len(msg.status_list)) + "   goal_done=" + str(goal_done) + "   goal.status= " + str(goal.status)
        
    
    #print "wilson1 len(msg.status_list)="+str(len(msg.status_list)) + "   goal_done=" + str(goal_done)      
    if len(msg.status_list) > 0 and not goal_done:
        #print "wilson2 msg.status_list="+str(goal.status) 
        for goal in msg.status_list:
            if goal.goal_id.id == last_active_goal.goal_id.id:
                if 2 <= goal.status <= 3:
                    goal_done = True
                    print "Goal completed, moving to next centroid."
                    go2nextGoal()
                elif 4 <= goal.status <= 5:  # Goal unreachable or rejected
                    goal_done = True
                    print "Goal unreachable or other error."
                    unreachable = True
                    stop_navigation()
                    go2nextGoal()

    if len(msg.status_list) == 1 and goal_done:
        for goal in msg.status_list:
            if goal.status == 2:
                retry += 1
                if retry > 20:
                    print "...............wilson2 dead ,wait recovery............"
                    unreachable = True
                    #blanklist = []
                    stop_navigation()
                    go2nextGoal()
         


def go2nextGoal():
    global first_detect,alive
    if first_detect:
        return
    nav_goal_pose = PoseStamped()
    nav_goal_pose.header.frame_id = 'map'
    nav_goal_pose.header.stamp = rospy.Time().now()
    world_x, world_y = map2world(nav_goal.getXpos(), nav_goal.getYpos())
    nav_goal_pose.pose.position.x = world_x
    nav_goal_pose.pose.position.y = world_y
    # TODO: Turn towards frontier
    #assign random orientation
    w = random.random() * 2 * math.pi
    nav_goal_pose.pose.orientation.w, nav_goal_pose.pose.orientation.x, nav_goal_pose.pose.orientation.y, nav_goal_pose.pose.orientation.z = quaternion_from_euler(w, 0.0, 0.0)
    #nav_goal_pose.pose.orientation.w, nav_goal_pose.pose.orientation.x, nav_goal_pose.pose.orientation.y, nav_goal_pose.pose.orientation.z = quaternion_from_euler(0.0, 0.0, 0.0)
    print "**********************wilson Navigating to centroid..." +str(nav_goal)
    if alive:
        nav_to_pose(nav_goal_pose)
    
def beep(se):
    global pub_sound
    sound = Sound()
    sound.value = se
    pub_sound.publish(sound)

def same_pooint(a, b):
    return (a.getXpos() < b.getXpos()+1 and a.getXpos() > b.getXpos()-1 and a.getYpos() < b.getYpos()+1 and a.getYpos > b.getYpos()-1)

def command(enable):
       global alive,_done_cond,flag
       
       if enable.data == 3:
          alive = True
          if flag:
             go2nextGoal()
          with _done_cond:
             _done_cond.notify()
             flag = True             
       if enable.data == 4:
          alive = False
          stop_navigation()

       print alive

def callback_map(msg):
    global carto_map
    carto_map = msg

if __name__ == '__main__':
    try:
        global odom_list, pub_walls, pub_expanded, pub_path, pub_frontier, last_map, move_base_cancel, pub_sound
        global goal_done, unreachable, nav_goal, done,goal_list,timecount,blanklist,retry,alive, _done_cond, flag
        global slam_algo
        global carto_map
        rospy.init_node('rbe_3002_frontier_node')
        goal_done = True
        unreachable = False
        nav_goal = None
        first_detect = True
        flag = False
        done = False
        recount = 0
        blanklist =[]
        timecount=0
        goal_list = []
        retry = 0
        alive = False
        black_groups = []
        dic = {}
        dic_last = {}
        move_base_cancel = rospy.Publisher('/move_base/cancel', GoalID, queue_size=1)
        pub_walls = rospy.Publisher('/wall_cells', GridCells, queue_size=1)
        pub_expanded = rospy.Publisher('/expanded_cells', GridCells, queue_size=1)
        pub_path = rospy.Publisher('/path_cells', GridCells, queue_size=1)
        pub_frontier = rospy.Publisher('/frontier_cells', GridCells, queue_size=1)
        pub_blacklist = rospy.Publisher('/black_list', GridCells, queue_size=1)
        pub_blackgroup = rospy.Publisher('/black_group', GridCells, queue_size=1)
        pub_sound = rospy.Publisher('/mobile_base/commands/sound', Sound, queue_size=1)
        rospy.Subscriber("/voice/cmd_topic",Int32,command, queue_size=1)
        pub_result = rospy.Publisher('/voice/result_topic',Int32, queue_size=1)
        pub_vel = rospy.Publisher('/mobile_base/commands/velocity',Twist,queue_size=10)

        rate = rospy.Rate(0.5)
        while not pub_sound.get_num_connections():
            rate.sleep()

        beep(Sound.CLEANINGEND)
        if not rospy.has_param("~slam_algo"):
           print "You should specify the SLAM Algorithms to run this node"

        #slam_algo = "gmapping"
        slam_algo = "carto"
        if slam_algo == "carto":
            map_status = rospy.Subscriber("/map", OccupancyGrid, callback_map)

        # Subscribe to Odometry changes
        rospy.Subscriber('/odom', Odometry, callback_odom)
        rospy.Subscriber('/navgoal', PoseStamped, nav_to_pose)
        rospy.Subscriber('/move_base/status', GoalStatusArray, callback_movebase_status)

        odom_list = tf.TransformListener()
        move_base = actionlib.SimpleActionClient('move_base', MoveBaseAction)
        move_base.wait_for_server(rospy.Duration(5))
        print "wait"
        try:
            _done_cond = threading.Condition(threading.Lock())
            _done_cond.acquire()
            _done_cond.wait()
        finally:
            _done_cond.release()

        last_map = []
        for i in range(10):
            try:
                process_map_now(None)
                rospy.sleep(rospy.Duration(5))
                if not first_detect:
                    break
                print("no frontier detected, try more times...")
            except:
                break

        go2nextGoal()
        rospy.Timer(rospy.Duration(5), process_map_now)

        rospy.spin()
    except KeyboardInterrupt:
        rospy.loginfo("except")
        sys.exit()
