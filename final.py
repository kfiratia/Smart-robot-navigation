#!/usr/bin/env python3
print("h")
import paho.mqtt.client as mqtt
from ev3dev.ev3 import *
import math
from time import sleep

mLF = LargeMotor('outB')  # left front
mRF = LargeMotor('outC')  # right front
mLB = LargeMotor('outA')  # left back
mRB = LargeMotor('outD')  # right back
gyro = GyroSensor()
gyro.mode='GYRO-RATE'
gyro.mode='GYRO-ANG'
#CYCLEcm = (360 / (17.5)) * 60  # 60 cm - 1 floor square
#REALDEGREE = ((420 * 4) / 465) * 2.34  # 1 degree
CYCLEcm = (345/(17.5))*60 # 60 cm - 1 floor square
REALDEGREE = ((300*2.215)/465)*1.35

def rotate(angle,sign):
    gyro.mode = 'GYRO-RATE'
    gyro.mode = 'GYRO-ANG'
    while (gyro.value() != angle):
        mLF.run_forever(speed_sp=90*sign)
        mRF.run_forever(speed_sp=-90*sign)
        mLB.run_forever(speed_sp=-90*sign)
        mRB.run_forever(speed_sp=90*sign)
    mLF.stop()
    mRF.stop()
    mLB.stop()
    mRB.stop()
def distance(x1, y1, x2, y2):
    return math.sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2))


def angle(a, b, c):
    return 180 - math.acos(((pow(a, 2) + pow(b, 2) - pow(c, 2)) / (2 * a * b))) * 180 / math.pi


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("topic/test")


def on_message(client, userdata, msg):
    X = []
    Y = []
    D = []
    temp = 0
    j = 1
    print(msg.payload.decode())
    print(msg.payload.decode().split(' '))
    for st in msg.payload.decode().split(' '):
        if st != '':
            if j % 2 != 0:
                X.append(int(st))
            else:
                Y.append(int(st))
        j = j + 1
    print("x = ", X)
    print("y = ", Y)
    if (X[1] == 0 & Y[1] > 0):
        temp = 0
    elif (X[1] == 0 & Y[1] < 0):
        temp = 180
    elif (Y[1] == 0 & X[1] > 0):
        temp = 90
    elif (Y[1] == 0 & X[1] < 0):
        temp = 270
    elif (X[1] >= 0 & Y[1] >= 0):
        try:
            temp = 90 - math.atan((Y[1] - Y[0]) / (X[1] - X[0])) * 180 / math.pi
        except:
            temp = 0
    elif (X[1] >= 0 & Y[1] <= 0):
        try:
            temp = 180 - math.atan((Y[1] - Y[0]) / (X[1] - X[0])) * 180 / math.pi
        except:
            temp = 0
    elif (X[1] <= 0 & Y[1] <= 0):
        try:
            temp = 270 - math.atan((Y[1] - Y[0]) / (X[1] - X[0])) * 180 / math.pi
        except:
            temp = 0
    elif (X[1] >= 0 & Y[1] >= 0):
        try:
            temp = math.atan((Y[1] - Y[0]) / (X[1] - X[0])) * 180 / math.pi
        except:
            temp = 0
    if (temp <= 180):
        print("right", temp)
        rotate(temp, 1)
    else:
        print("left", 360 - temp)
        rotate(360-temp, -1)

    D.append(distance(X[0], Y[0], X[1], Y[1]))
    mLF.run_to_rel_pos(position_sp=CYCLEcm * D[0], speed_sp=800, stop_action="brake")
    mRF.run_to_rel_pos(position_sp=CYCLEcm * D[0], speed_sp=800, stop_action="brake")
    mLB.run_to_rel_pos(position_sp=-CYCLEcm * D[0], speed_sp=800, stop_action="brake")
    mRB.run_to_rel_pos(position_sp=-CYCLEcm * D[0], speed_sp=800, stop_action="brake")
    mLF.wait_while('running')
    mRF.wait_while('running')
    mLB.wait_while('running')
    mRB.wait_while('running')

    for i in range(1, len(X) - 1):
        D.append(distance(X[i], Y[i], X[i + 1], Y[i + 1]))
        c = distance(X[i - 1], Y[i - 1], X[i + 1], Y[i + 1])
        ang = angle(D[i - 1], D[i], c)
        if (X[i] >= 0 & X[i + 1] >= 0):
            newX = X[i + 1] - X[i]
        elif (X[i] <= 0 & X[i + 1] >= 0):
            newX = X[i + 1] + X[i]
        elif (X[i] <= 0 & X[i + 1] <= 0):
            newX = -(abs(X[i + 1]) - abs(X[i]))
        elif (X[i] >= 0 & X[i + 1] <= 0):
            newX = X[i + 1] + X[i]
        if (Y[i] >= 0 & Y[i + 1] >= 0):
            newY = Y[i + 1] - Y[i]
        elif (Y[i] <= 0 & Y[i + 1] >= 0):
            newY = Y[i + 1] + Y[i]
        elif (Y[i] <= 0 & Y[i + 1] <= 0):
            newY = -(abs(Y[i + 1]) - abs(Y[i]))
        elif (Y[i] >= 0 & Y[i + 1] <= 0):
            newY = Y[i + 1] + Y[i]
        newZ = newX * math.cos(math.radians(temp)) - newY * math.sin(math.radians(temp))
        if newZ > 0:
            temp = (temp + ang) % 360
            print("right", ang)
            rotate(ang, 1)

        elif newZ < 0:
            temp = (temp - ang) % 360
            print("left", ang)
            rotate(ang, -1)

        elif newZ == 0:
            print("Continue straight")

        mLF.run_to_rel_pos(position_sp=CYCLEcm * D[i], speed_sp=800, stop_action="brake")
        mRF.run_to_rel_pos(position_sp=CYCLEcm * D[i], speed_sp=800, stop_action="brake")
        mLB.run_to_rel_pos(position_sp=-CYCLEcm * D[i], speed_sp=800, stop_action="brake")
        mRB.run_to_rel_pos(position_sp=-CYCLEcm * D[i], speed_sp=800, stop_action="brake")
        mLF.wait_while('running')
        mRF.wait_while('running')
        mLB.wait_while('running')
        mRB.wait_while('running')
#    client.disconnect()


client = mqtt.Client()
client.connect("47.254.229.61", 1883,20)

client.on_connect = on_connect
while True:
    client.on_message = on_message
    print(client.on_message)
    client.loop_forever()

