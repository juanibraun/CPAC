# CPAC
This project was implemented for the course "Creative Programming and Computing" in the Politecnico di Milano. 

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation and Setup](#installation-and-setup)
- [Usage](#usage)

## Project Overview

CPAC consist in creating an artistic representation of the information that is being sent from the python server implemented so the user can see how it changes based on his choices. This information being sent will be regarding the population data of different countries. It is downloaded in real-time from the webpage introduced in the script and will depend on the option made by the user.

Regarding our system architecture, the user interface will send OSC messages to the server. Once the notes are generates, they will be sent via UDP messages to processing so the graphic representation can start. Finally, the user from the interface on his mobile phone will modify the representation by sending OSC messages to processing.

## Features

This project is implemented on Python and Processing. These elements will allow us to implement the server as well as the interface and the visual representation. In addition, the application TouchOSC will allow the user to control the representation.

## Getting Started

This section will cover the set up of the necessary software to run the code successfully.

### Prerequisites

It is required to have installed Processing with the libraries corresponding to the implementation of the project.
For Python, Visual Studio Code is needed with the required libraries as well.
Finally, download TouchOSC from the application store in your mobile phone.


### Installation and Setup

Provide step-by-step instructions for setting up the project. This could involve cloning the repository, installing dependencies, and any other necessary setup procedures.
Once the prerequisites are fulfilled, the project can be cloned as follows:

```bash
# Clone the repository
git clone https://github.com/juanibraun/CPAC.git

# Navigate to the project directory
cd CPAC
```
Now, you should run the button_interface code and scribain_fluid on Processing and the python file on Visual Studio Code. Once everything is launched, you can press the button desired on the user interface, the OSC messages will be generated and the graphic representation will start.


### Usage

Open the application TouchOSC and generate a screen for the program with the parameters you want to use.
The different elements that you can see are the following:
- Radius: You can change the radius of the circle that is being painted.
- Camera ON: To turn on/off the camera on your computer.
- Angle offset: It will turn the circle clockwise as the user wishes.
- Reset grill: Reset the value of the different grill spaces.
- Viscosity: Changes the value of the viscosity.
- Diffusion: Changes the vallue of the diffusion.

