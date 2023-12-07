%% General input

seedNumber = 1;
resol = 365;
Nsim = 5;
folderResults = pwd;

optionsGeneral.Analysis.seedNumber = seedNumber;
optionsGeneral.Analysis.timeUnit = 'days';
optionsGeneral.Analysis.timeHorizon = 50 * resol;

%% Only mainshocks

MSseverityCurve(:,1) = 4.45:0.3:7.45;
MSseverityCurve(:,2) = (1/resol) * [0.2326 0.1334 0.0567 0.0340 0.0255 0.0149 0.0128 0.0071 0.0028 0.0014 0];
MS = mainshock(MSseverityCurve);
MS.name = 'Mainshock';

optionsMS = optionsGeneral;
optionsMS.Analysis.hazards = {MS};

MSonly = multiHazardScenario(folderResults, optionsMS);
MSonly = MSonly.simulateScenarios(Nsim);
MSonly.plotScenario()

%% Mainshocks and aftershocks

omori = [-1.66, 0.96, 0.03, 0.93, MS.severityCurve(1,1)]; % a, b, c, p, MminMS

ASseverityCurve = MSseverityCurve;
AS = aftershock(ASseverityCurve, omori);
AS.name = 'Aftershock';

optionsMSAS = optionsGeneral;
optionsMSAS.Analysis.hazards = {MS; AS};

MSAS = multiHazardScenario(folderResults, optionsMSAS);
MSAS = MSAS.simulateScenarios(Nsim);
MSAS.plotScenario()

%% Mainshocks, Aftershocks, and landslides

probTriggerPars = [35, 0, 1]; %Parker et al. (2015); [SL, NDS, G]

MS2 = MS;
MS2.drivesAltered = {'Aftershock'};
MS2.drivesTriggered = {'Landslide (EQ)'};

AS2 = AS;
AS2.drivesTriggered = {'Landslide (EQ)'};

distEpicentre = 10; % [km]
LSeq = landslideFromEQ(probTriggerPars, distEpicentre);
LSeq.name = 'Landslide (EQ)';

optionsMSAS = optionsGeneral;
optionsMSAS.Analysis.hazards = {MS2; AS2; LSeq};

MSASLS = multiHazardScenario(folderResults, optionsMSAS);
MSASLS = MSASLS.simulateScenarios(Nsim);
MSASLS.plotScenario()

%% Rain and landslides

load('IDFexampleData.mat');

R = rain(IDF);
R.name = 'Rain';
R.drivesTriggered = {'Landslide (R)'};

LSr = landslideFromRain();
LSr.name = 'Landslide (R)';

optionsRL = optionsGeneral;
optionsRL.Analysis.hazards = {R, LSr};

RL = multiHazardScenario(folderResults, optionsRL);
RL = RL.simulateScenarios(Nsim);
RL.plotScenario() %TODO fix plot function to deal with severities of different dimension
