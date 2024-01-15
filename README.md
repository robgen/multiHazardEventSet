multiHazardScenario
============
[![GitHub Stars](https://img.shields.io/github/stars/robgen/multiHazardScenario.svg)](https://github.com/robgen/multiHazardScenario/stargazers) [![GitHub Issues](https://img.shields.io/github/issues/robgen/multiHazardScenario.svg)](https://github.com/robgen/multiHazardScenario/issues) [![Current Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://github.com/robgen/multiHazardScenario)

This Matlab class allows to train a surrogated probabilistic seismic demand model (PSDM) based for inelastic single degree of freedom (SDoF) structures based on Gaussian process regression. The PSDM provides the distribution of the maximum displacement of the SDoF conditioned on different spectral acceleration levels. Given four input parameters (hysteresis model “hyst”, fundamental period T, normalised yield shear strength fy, hardening ratio h), two Gaussian process regressions provide the parameters of the PSDM (slope and standard deviation).

A trained model is already provided for ready predictions, including the training data involving non-linear time history analyses of 10000 SDoF systems. The user is free to add or remove training data and re-train the model, and running a k-fold cross validation.

---

## Features
- Extract non-linear time history analysis data from an input table
- Train Gaussian process regressions for the slope and the dispersion of the PSDM
- Perform k-fold cross validation of the trained regressions
- Predict PSDM parameters using the Gaussian process regressions
- Predict Lognormal seismic fragility parameters using the Gaussian process regressions
- Calculate and plot surrogated-vs-modelled error

---

## Setup
Clone this repo to any folder in your computer. Add this folder to the Matlab path and you are ready to go (or just cd to this folder). This class does not need external dependencies, apart from the built-in Matlab functions.

---

## Usage
A full demo of this class is given in the file trainModel.m

If you use this model for formal applications, please cite the following paper:

Gentile R, Galasso C. Surrogate probabilistic seismic demand modelling of inelastic single‐degree‐of‐freedom systems for efficient earthquake risk applications. Earthquake Engineering & Structural Dynamics 2022; 51(2): 492–511. DOI: 10.1002/eqe.3576.

---
## App with Graphical User interface

![slopePrediction](https://github.com/robgen/multiHazardScenario/blob/main/appScreenshot.png)

---
## License
This project is licensed under the terms of the **GNU GPLv3** license. This software is supplied "AS IS" without any warranties and support. The Author assumes no responsibility or liability for the use of the software. The Author reserves the right to make changes in the software without notification.
