function obs = obsstctinit()
% Initialize obs struct
    obs.GPS = struct;obs.GAL = struct;obs.GLO = struct;obs.BDS = struct;
    obs.GPS(1).type = 'L1 C/A';   obs.GPS(2).type = 'L2';
    obs.GPS(1).data.P = [];       obs.GPS(2).data.P = [];
    obs.GPS(1).data.C = [];       obs.GPS(2).data.C = [];
    obs.GPS(1).data.D = [];       obs.GPS(2).data.D = [];
    obs.GPS(1).data.S = [];       obs.GPS(2).data.S = [];
    obs.GPS(3).type = 'L1 P';     obs.GPS(4).type = 'L2 P';
    obs.GPS(3).data.P = [];       obs.GPS(4).data.P = [];
    obs.GPS(3).data.C = [];       obs.GPS(4).data.C = [];
    obs.GPS(3).data.D = [];       obs.GPS(4).data.D = [];
    obs.GPS(3).data.S = [];       obs.GPS(4).data.S = [];
    obs.GLO(1).type = 'L1 C/A';   obs.GLO(2).type = 'L2 C/A';
    obs.GLO(1).data.P = [];       obs.GLO(2).data.P = [];
    obs.GLO(1).data.C = [];       obs.GLO(2).data.C = [];
    obs.GLO(1).data.D = [];       obs.GLO(2).data.D = [];
    obs.GLO(1).data.S = [];       obs.GLO(2).data.S = [];
    obs.GLO(3).type = 'L1 P';     obs.GLO(4).type = 'L2 P';
    obs.GLO(3).data.P = [];       obs.GLO(4).data.P = [];
    obs.GLO(3).data.C = [];       obs.GLO(4).data.C = [];
    obs.GLO(3).data.D = [];       obs.GLO(4).data.D = [];
    obs.GLO(3).data.S = [];       obs.GLO(4).data.S = [];
    obs.GAL(1).type = 'E1';       obs.GAL(2).type = 'E5b';
    obs.GAL(1).data.P = [];       obs.GAL(2).data.P = [];
    obs.GAL(1).data.C = [];       obs.GAL(2).data.C = [];
    obs.GAL(1).data.D = [];       obs.GAL(2).data.D = [];
    obs.GAL(1).data.S = [];       obs.GAL(2).data.S = [];
    obs.BDS(1).type = 'B1';       obs.BDS(2).type = 'B2b';
	obs.BDS(1).data.P = [];       obs.BDS(2).data.P = [];
    obs.BDS(1).data.C = [];       obs.BDS(2).data.C = [];
    obs.BDS(1).data.D = [];       obs.BDS(2).data.D = [];
    obs.BDS(1).data.S = [];       obs.BDS(2).data.S = [];
end