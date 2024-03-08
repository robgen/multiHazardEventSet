multiHazardEventSet
============
[![GitHub Stars](https://img.shields.io/github/stars/robgen/multiHazardScenario.svg)](https://github.com/robgen/multiHazardScenario/stargazers) [![GitHub Issues](https://img.shields.io/github/issues/robgen/multiHazardScenario.svg)](https://github.com/robgen/multiHazardScenario/issues) [![Current Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://github.com/robgen/multiHazardScenario)

The class **multiHazardEventSet** allows to simulate multi-hazard event sets (i.e., sequences of hazard events and associated features throughout a selected time horizon). The simulation method is based on the theory of competing Poisson processes. It incorporates the different types of hazard interactions using a sequential Monte Carlo sampling. The method outputs multi-hazard event sets that can be integrated into lifecycle consequence frameworks to quantify interacting hazard consequences. Given some inputs (a time horizon, a set of hazards, a set of rules defining hazard interactions), the class provides a set of simulated scenarios including different hazard events with an associated arrival time and an appropriate hazard intensity. The figure below shows one example multi-hazard scenario.

![exampleScenario](https://github.com/robgen/multiHazardScenario/blob/main/forReadme/exampleScenario.png)

The class **hazard** is an interface class defining hazards. Currently, the code supports earthquakes (mainshocks and aftershocks), heavy rain events, and landslides (both triggered by earthquakes or heavy rain). These events are respectively supported by the concrete classes  **mainshock**, **aftershock**, **rain**, **landslideFromEQ**, and **landslideFromRain** which inherit from **hazard**. New concrete hazard classes may be easily added, as long that they comply with the parent class. Pull requests are welcome!

Hazards are defined according the following taxonomy.

![hazardClassification](https://github.com/robgen/multiHazardScenario/blob/main/forReadme/Classification.png)

---

## (Some) Features of the hazard class
- name              String indicating the name of the hazard (e.g., 'Mainshocks from fault 3')
- isPrimary         Boolean indicating if this hazard is primary or not
- isHomogeneus      Boolean indicating if this hazard follows a homogenenous or non-homogeneous Poisson process
- isSlowonset       Boolean indicating if this hazard is of a slow-onset type. Sudden-onset hazard types are modeled as a single point in time (e.g., earthquakes). Slow-onset hazard types have a detectable start and end point (e.g., pandemics, droughts)
- drivesTriggered   List of strings indicating the names of the hazards triggered by this hazard (ignored if isPrimary is false)
- drivesTriggered   List of strings indicating the names of the hazards altered by this hazard (ignored if isPrimary is false)
- severityCurve     Type depends on the adopted concrete class. For example, Nx2 list for earthquakes (indicating the hazard curve); Dictionary for heavy rain events, containing the intensity-duration-frequency relationship.
---

## Setup
Clone this repo to any folder in your computer. Add this folder to the Matlab path and you are ready to go (or just cd to this folder). This class does not need external dependencies, apart from the built-in Matlab functions.

---

## Usage
A full demo of this class is given in the file examples_Level1.m

If you use this model for formal applications, please cite the following paper:

Iannacone, L., Otarola, K., Gentile, R., & Galasso, C. (2024). Simulating multi-hazard event sets for life cycle consequence analysis. EGUsphere [Preprint]. https://doi.org/10.5194/egusphere-2023-2540

---
## App with Graphical User interface (coming soon)

![appScreenshot](https://github.com/robgen/multiHazardScenario/blob/main/forReadme/appScreenshot.png)

---
## License
This project is licensed under the terms of the **CC0-1.0** license. This software is supplied "AS IS" without any warranties and support. The Author assumes no responsibility or liability for the use of the software. The Author reserves the right to make changes in the software without notification.
