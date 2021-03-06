% Parser for RINEX file to data struct file (.mat).
% Supportting parsing GNSS obeservables and navigation data
% from standard RINEX version 3 file
% Supportting standard .rnx file, .obs file & .nav file parsed from RTKLIB.
% This function can be directly run in MATLAB
%
% By selecting the RINEX file, the function will save the data struct as
% .mat files.
%
% Author: Azurehappen
%----------------------------%

[fileName, filePath] = uigetfile({'*.rnx;*.obs;*nav','RINEX file (*.rnx,*.obs,*nav)'}, 'Select an RINEX File');
fullPath = strcat (filePath, fileName);
[~,fileName,ext] = fileparts(fullPath);
addpath('util');
if ext == ".rnx" || ext == ".obs" || ext == ".nav"
    flag = 1;
    fprintf ('Loading data...\n \n');
else
    fprintf ('File format not supported. Please input a RINEX file\n');
end
eph = []; obs = [];
if flag == 1
    file = fopen(fullPath);
    fisrtl = fgetl(file);
    lineSplit = strsplit(fisrtl);
    % Getting version and data type
    if contains(fisrtl,'RINEX VERSION')
        ver = lineSplit(2);
        type = fisrtl(21:31);
    end
    ver = str2double(ver);
    fclose(file);
    if ver>=3 && ver <=3.1
        if contains(type,'NAV')
            eph = parser_nav(fullPath);
        elseif contains(type,'OBSERVATION')
            obs = parser_obs(fullPath);
        else
            fprintf ('Unable to find Nav or Obs type');
        end
    else
        fprintf ('Not RINEX version 3');
    end
end
%% Save to MAT file
% if ~isempty(eph)
%     save ([fileName,'_nav.mat'], 'eph');
% end
% if ~isempty(obs)
%     save ([fileName,'_obs.mat'], 'obs');
% end