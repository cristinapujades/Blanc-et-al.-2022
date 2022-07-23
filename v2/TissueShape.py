#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
description: A python code to analyse the difference in shape between two models
through signed distance measurments.

@authors: Matthias Blanc and Giovanni Dalmasso.

"""


# Process prep

import PySimpleGUI as sg
import pandas as pd
import os
import numpy as np
from shutil import rmtree
from vedo import (show, buildLUT, load, Video, vector, colorMap, ask,
                  sys_platform, pyplot, ProgressBar, screenshot, printc)


def pathExists(path):
    """
    Check the existence of a folder.

    Parameters
    ----------
    path : TYPE
        DESCRIPTION.

    Returns
    -------
    None.

    """
    if not os.path.exists(path):
        os.mkdir(path)
        printc("Directory ", path, " Created ", c='green')
    else:
        res = ask("Directory ", path, " already exists, "
                  "should I delete the folder and create a new one?",
                  options=['Y', 'n'], default='Y', c='g')
        if res == 'Y':
            rmtree(path)
            os.mkdir(path)
            printc("Directory ", path, " Created ", c='green')
        else:
            exit()


# User prompt prep
sg.theme("DarkTeal2")

# LUT Creator
colors = []
for i in np.linspace(-80, 80):
    c = colorMap(i, name="RdBu", vmin=-40, vmax=40)
    if abs(i) < 1:
        c = "white"
    colors.append([i, c])
lut = buildLUT(colors, vmin=-80, vmax=80, interpolate=True)

# Building Window 0
layout = [
    [sg.T("")],
    [sg.Text("Choose a Workspace folder: "),
     sg.Input(), sg.FolderBrowse(key="-IN-")],
    [sg.Button("Submit")],
]
window = sg.Window("Workspace Browser", layout, size=(600, 150))

while True:
    event, values = window.read()
    if event == sg.WIN_CLOSED or event == "Exit":
        break
    elif event == "Submit":
        e = values["-IN-"]
        print(e)
        window.close()
        break

# Building Window 1
layout = [
    [sg.T("")],
    [sg.Text("Choose a Ref: "), sg.Input(), sg.FileBrowse(key="-IN-")],
    [sg.Button("Submit")],
]
window = sg.Window("Ref Model Browser", layout, size=(600, 150))

while True:
    event, values = window.read()
    if event == sg.WIN_CLOSED or event == "Exit":
        break
    elif event == "Submit":
        a = values["-IN-"]
        print(a)
        window.close()
        break

# Building Window 2
layout2 = [
    [sg.T("")],
    [sg.Text("Choose a Exp: "), sg.Input(), sg.FileBrowse(key="-IN-")],
    [sg.Button("Submit")],
]
window = sg.Window("Exp Model Browser", layout2, size=(600, 150))

while True:
    event, values = window.read()
    if event == sg.WIN_CLOSED or event == "Exit":
        break
    elif event == "Submit":
        b = values["-IN-"]
        print(b)
        window.close()
        break

# making results folders
pathRes = e + '/results/'
pathExists(pathRes)
# if OS == Windows also make a folder for the images
if sys_platform != 'Darwin' and sys_platform != 'Linux':
    pathImgs = pathRes + 'imgs/'
    os.mkdir(pathImgs)
    printc("Directory ", pathImgs, " Created ", c='green')


# Process
s1 = load(a).extractLargestRegion().smooth(niter=60)
s2 = load(b).extractLargestRegion().smooth(niter=60)


s1.distanceTo(s2, signed=True)
s1.cmap(input_array="Distance", cname=lut)
s1.addScalarBar(title="Signed \nDistance (\mum)")

# show results
print(s1.pointdata["Distance"])
show(s1, bg='k').close()


pyplot.histogram(s1.pointdata["Distance"]).show(
    zoom='tight', mode='image').screenshot(pathRes + 'hist.pdf').close()


# save results
DF = pd.DataFrame(s1.pointdata["Distance"])


DF.to_csv(pathRes+"data1.csv")
s1.write(pathRes+"test.vtk")


cam = dict(
    pos=(199.0, 59.74, 1316),
    focalPoint=(174.9, 177.5, 123.9),
    viewup=(-0.7978, -0.6014, -0.04324),
    distance=1199,
    clippingRange=(918.7, 1549),
)

p = s1.centerOfMass()
v = vector(1, 0, 0)

if sys_platform == ('Darwin' or 'Linux'):
    video = Video(
        pathRes+'test.mp4',
        duration=12,
        backend="ffmpeg"
    )

pb = ProgressBar(0, 30)
for j in pb.range():
    show(
        s1.rotate(j, axis=v, point=p),
        interactive=False,
        resetcam=False,
        camera=cam,
        bg='k'
    )  # render the scene

    if sys_platform == ('Darwin' or 'Linux'):
        video.addFrame()  # add individual frame
    else:
        screenshot(pathImgs + str(j) + '.png')

    pb.print()

if sys_platform == ('Darwin' or 'Linux'):
    video.close()
