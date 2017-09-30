#!/usr/bin/python

import math

MagX_min = 120;
MagX_max = 0;
MagY_min = 120;
MagY_max = 0;
MagZ_min = 120;
MagZ_max = 0;

GyroX_last = 0;
GyroY_last = 0;
GyroZ_last = 0;



import serial
com1 = serial.Serial('/dev/ttyACM0', 19200, timeout=1)

while True:
    line = com1.readline().strip();
    values = line.split(",");
    #print values;
    if len(values) != 10:
        continue;
    time = values[0].strip();
    AccX = int(values[1].strip());
    AccY = int(values[2].strip());
    AccZ = int(values[3].strip());
    GyroX = values[4].strip();
    GyroY = values[5].strip();
    GyroZ = values[6].strip();
    MagX = values[7].strip();
    MagY = values[8].strip();
    MagZ = values[9].strip();
    
    print "Raw Time stamp: " + time
    print "\tAccX: %d"  %AccX
    print "\tAccY: %d" %AccY
    print "\taccZ: %d" %AccZ
    print "\tGyroX: " + GyroX
    print "\tGyroY: " + GyroY
    print "\tGyroZ: " + GyroZ
    print "\tMagX: " + MagX
    print "\tMagY: " + MagY
    print "\tMagZ: " + MagZ

    if (float(MagX) > float(MagX_max)):
        MagX_max = MagX;
    if (float(MagX) < float(MagX_min)):
        MagX_min = MagX;

    if (float(MagY) > float(MagY_max)):
        MagY_max = MagY;
    if (float(MagY) < float(MagY_min)):
        MagY_min = MagY;
    
    if (float(MagZ) > float(MagZ_max)):
        MagZ_max = MagZ;
    if (float(MagZ) < float(MagZ_min)):
        MagZ_min = MagZ;
    
    full_range_X = (float(MagX_max) - float(MagX_min))/2
    full_range_Y = (float(MagY_max) - float(MagY_min))/2
    full_range_Z = (float(MagZ_max) - float(MagZ_min))/2

    Offset_X = (float(MagX_max) + float(MagX_min))/2;
    Offset_Y = (float(MagY_max) + float(MagY_min))/2;
    Offset_Z = (float(MagZ_max) + float(MagZ_min))/2;

    #print "\tMagX: %f" %((float(MagX) - float(Offset_X))/full_range_X)
    #print "\tMagY: %f" %((float(MagY) - float(Offset_Y))/full_range_Y)
    #print "\tMagZ: %f" %((float(MagZ) - float(Offset_Z))/full_range_Z)
    GyroX_cal = float((float(GyroX) - float(GyroX_last)))/2000
    GyroY_cal = float((float(GyroY) - float(GyroY_last)))/2000
    GyroZ_cal = float((float(GyroZ) - float(GyroZ_last)))/2000

    GyroX_last = GyroX
    GyroY_last = GyroY
    GyroZ_last = GyroZ

    print "\tGyroscope value X: [%f], y : [%f], z:[%f]" %(GyroX_cal, GyroY_cal, GyroZ_cal)

    normal = float(math.sqrt(AccX*AccX + AccY * AccY + AccZ * AccZ));
    print normal;
    print "\t==================="
    print "\tAccX: %f" %(AccX/normal)
    print "\tAccY: %f" %(AccY/normal)
    print "\tAccZ: %f" %(AccZ/normal)



    

    
