function obs = parser_obs(obspath)
% Parse observation data from rinex file to matlab data file. 
% Supportting RINEX version 3
%
%%%%%-----Reference
% ftp://igs.org/pub/data/format/rinex303.pdf
%
%%%%%-----Input
% obs file path
%
%%%%%-----Output
% Struct of constellation observation
%
% Specification
%           Reference: Section 5 in RINEX document
%           Output obs will include GPS, GAL, GLO and BDS
%           In this statement, attribute 'sys' denote GPS/GLO/GAL/BDS
%           obs.sys(i).type : The frequency type and measurement code
%           obs.sys(i).data : P:psedorange, C: carrier phase, D: doppler, S: signal strength 
%           Default:
%                   GPS(1)->type/data: (C1C) L1 frequency, C/A code; 
%                   GPS(2)->type/data: (C2L/C2S/C2X) L2 frequency;
%                   GPS(3)->type/data: (C1W) L1 frequency, P code; 
%                   GPS(4)->type/data: (C2W) l2 frequency, P code;
%
%                   GLO(1)->type/data: (C1C) L1 frequency, C/A code; 
%                   GLO(2)->type/data: (C2C) L2 frequency, C/A code;
%                   GLO(3)->type/data: (C1P) L1 frequency, P code; 
%                   GLO(4)->type/data: (C2P) l2 frequency, P code;
%
%                   GAL(1)->type/data: (C1X/C1C) E1 frequency;
%                   GAL(2)->type/data: (C7I/C7Q/C7X) E5b frequency;
%
%                   BDS(1)->type/data: (C2I/C2Q/C2X) B1(B1-2 in RINEX 3.04) frequency;
%                   BDS(2)->type/data: (C7I/C7Q/C7X) B2b frequency;
%           see RINEX 3.03 table A2
%
% Author: Azurehappen

fprintf ('Loading observations...\n \n');
obsfile = fopen(obspath);
%-----------------------------------%
% Initialization
obs = obsstctinit();
% read header
fprintf ('Reading header...\n');
while (true)  
    line = fgetl(obsfile);                                                   %get line    
    if contains(line,'SYS / # / OBS TYPES')
        constellation = line(1);
        switch(constellation)
            case 'G'
                fprintf('File contains GPS observations \n')
                num_gpstype  = str2double(line(5:6)); % number of obs type
                gpstype = strsplit(line(8:58));
                gpstype(cellfun(@isempty,gpstype))=[]; % Delete empty cite
                i = length(gpstype);
                while (i<num_gpstype)
                    line = fgetl(obsfile);
                    insert = strsplit(line(8:58));
                    insert(cellfun(@isempty,insert))=[]; % Delete empty cite
                    gpstype = [gpstype insert];
                    i = length(gpstype);
                end
            case 'R'
                fprintf('File contains GLO observations \n')
                num_glotype  = str2double(line(5:6)); % number of obs type
                glotype = strsplit(line(8:58));
                glotype(cellfun(@isempty,glotype))=[]; % Delete empty cite
                i = length(glotype);
                while (i<num_glotype)
                    line = fgetl(obsfile);
                    insert = strsplit(line(8:58));
                    insert(cellfun(@isempty,insert))=[]; % Delete empty cite
                    glotype = [glotype insert];
                    i = length(glotype);
                end
            case 'E'
                fprintf('File contains GAL observations \n')
                num_galtype  = str2double(line(5:6)); % number of obs type
                galtype = strsplit(line(8:58));
                galtype(cellfun(@isempty,galtype))=[]; % Delete empty cite
                i = length(galtype);
                while (i<num_galtype)
                    line = fgetl(obsfile);
                    insert = strsplit(line(8:58));
                    insert(cellfun(@isempty,insert))=[]; % Delete empty cite
                    galtype = [galtype insert];
                    i = length(galtype);
                end
        case 'C'
                fprintf('File contains BDS observations \n')
                num_bdstype  = str2double(line(5:6)); % number of obs type
                bdstype = strsplit(line(8:58));
                bdstype(cellfun(@isempty,bdstype))=[]; % Delete empty cite
                i = length(bdstype);
                while (i<num_bdstype)
                    line = fgetl(obsfile);
                    insert = strsplit(line(8:58));
                    insert(cellfun(@isempty,insert))=[]; % Delete empty cite
                    bdstype = [bdstype insert];
                    i = length(bdstype);
                end
        end        
    elseif contains(line,'END OF HEADER')
        break;                                                              % End of header loop
    end
end
%-----------------------------------%
% read observables
count = 0;
% Step size for each data and its gap
gap = 4; len = 12;
fprintf ('Parsing observables \n');
while ~feof(obsfile)
    line = fgetl(obsfile);
    if strcmp(line(1),'>') % new observables
        count = count+1;
        lineSplit = strsplit(line);
        obs.tr_prime(:,count) = str2double(lineSplit(2:7))'; % [year;month;date;hour;minute;second]
        [~,~,obs.tr_sow(1,count)] = date2gnsst(str2double(lineSplit(2:7))); %  GPS seconds
    else
        switch line(1)
            case{'G'}
                prn = str2double(line(2:3));
                idx = 1+gap;
                for i = 1:length(gpstype)
                    if idx + len <=length(line)
                    % Avioding short line that don't have other types of data
                        [obs,idx]=readgps(gpstype{i},prn,count,obs,idx,line);         
                        idx = idx + min(gap,length(line)-idx);
                    end
                end
            case{'R'}
                prn = str2double(line(2:3));
                idx = 1+gap;
                for i = 1:length(glotype)
                    if idx + len <=length(line)
                        [obs,idx]=readglo(glotype{i},prn,count,obs,idx,line);
                        idx = idx + min(gap,length(line)-idx);
                    end
                end
            case{'E'}
                prn = str2double(line(2:3));
                idx = 1+gap;
                for i = 1:length(galtype)
                    if idx + len <=length(line)
                        [obs,idx]=readgal(galtype{i},prn,count,obs,idx,line);
                        idx = idx + min(gap,length(line)-idx);
                    end
                end
            case{'C'}
                prn = str2double(line(2:3));
                idx = 1+gap;
                for i = 1:length(bdstype)
                    if idx + len <=length(line)
                        [obs,idx]=readbds(bdstype{i},prn,count,obs,idx,line);
                        idx = idx + min(gap,length(line)-idx);
                    end
                end
        end
    end 
end
fclose(obsfile);
%%Save to MAT file
% save ([fileName,'_obs.mat'], 'obs');
%----------------------------------------------------%
fprintf ('\nObservables loaded correctly\n \n');

    function [obs,idx]=readgps(data_type,prn,count,obs,idx,line)
        switch(data_type(1))
            case 'C' % Psedorange
                if strcmp(data_type,'C1C')
                    obs.GPS(1).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C2L')||strcmp(data_type,'C2S')||strcmp(data_type,'C2X')
                    obs.GPS(2).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C1W')
                    obs.GPS(3).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C2W')
                    obs.GPS(4).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end
            case 'L' % Carrier phase
                if strcmp(data_type,'L1C')
                    obs.GPS(1).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L2L')||strcmp(data_type,'L2S')||strcmp(data_type,'L2X')
                    obs.GPS(2).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L1W')
                    obs.GPS(3).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L2W')
                    obs.GPS(4).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end            
            case 'D' % Doppler
                if strcmp(data_type,'D1C')
                    obs.GPS(1).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D2L')||strcmp(data_type,'D2S')||strcmp(data_type,'D2X')
                    obs.GPS(2).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D1W')
                    obs.GPS(3).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D2W')
                    obs.GPS(4).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end            
            case 'S' % Signal strength
                if strcmp(data_type,'S1C')
                    obs.GPS(1).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S2L')||strcmp(data_type,'S2S')||strcmp(data_type,'S2X')
                    obs.GPS(2).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S1W')
                    obs.GPS(3).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S2W')
                    obs.GPS(4).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end             
        end
    end


    function [obs,idx]=readglo(data_type,prn,count,obs,idx,line)
        switch(data_type(1))
            case 'C' % Psedorange
                if strcmp(data_type,'C1C')
                    obs.GLO(1).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C2C')
                    obs.GLO(2).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C1P')
                    obs.GLO(3).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C2P')
                    obs.GLO(4).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end
            case 'L' % Carrier phase
                if strcmp(data_type,'L1C')
                    obs.GLO(1).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L2C')
                    obs.GLO(2).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L1P')
                    obs.GLO(3).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L2P')
                    obs.GLO(4).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end            
            case 'D' % Doppler
                if strcmp(data_type,'D1C')
                    obs.GLO(1).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D2C')
                    obs.GLO(2).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D1P')
                    obs.GLO(3).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D2P')
                    obs.GLO(4).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end            
            case 'S' % Signal strength
                if strcmp(data_type,'S1C')
                    obs.GLO(1).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S2C')
                    obs.GLO(2).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S1P')
                    obs.GLO(3).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S2P')
                    obs.GLO(4).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end             
        end
    end

    function [obs,idx]=readgal(data_type,prn,count,obs,idx,line)
        switch(data_type(1))
            case 'C' % Psedorange
                if strcmp(data_type,'C1C')||strcmp(data_type,'C1X')
                    obs.GAL(1).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C7I')||strcmp(data_type,'C7Q')||strcmp(data_type,'C7X')
                    obs.GAL(2).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end
            case 'L' % Carrier phase
                if strcmp(data_type,'L1C')||strcmp(data_type,'L1X')
                    obs.GAL(1).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L7I')||strcmp(data_type,'L7Q')||strcmp(data_type,'L7X')
                    obs.GAL(2).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end           
            case 'D' % Doppler
                if strcmp(data_type,'D1C')||strcmp(data_type,'D1X')
                    obs.GAL(1).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D7I')||strcmp(data_type,'D7Q')||strcmp(data_type,'D7X')
                    obs.GAL(2).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end            
            case 'S' % Signal strength
                if strcmp(data_type,'S1C')||strcmp(data_type,'S1X')
                    obs.GAL(1).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S7I')||strcmp(data_type,'S7Q')||strcmp(data_type,'S7X')
                    obs.GAL(2).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end             
        end
    end

    function [obs,idx]=readbds(data_type,prn,count,obs,idx,line)
        switch(data_type(1))
            case 'C' % Psedorange
                if strcmp(data_type,'C2I')||strcmp(data_type,'C2Q')||strcmp(data_type,'C2X')
                    obs.BDS(1).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'C7I')||strcmp(data_type,'C7Q')||strcmp(data_type,'C7X')
                    obs.BDS(2).data.P(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end
            case 'L' % Carrier phase
                if strcmp(data_type,'L2I')||strcmp(data_type,'L2Q')||strcmp(data_type,'L2X')
                    obs.BDS(1).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'L7I')||strcmp(data_type,'L7Q')||strcmp(data_type,'L7X')
                    obs.BDS(2).data.C(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end           
            case 'D' % Doppler
                if strcmp(data_type,'D2I')||strcmp(data_type,'D2Q')||strcmp(data_type,'D2X')
                    obs.BDS(1).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'D7I')||strcmp(data_type,'D7Q')||strcmp(data_type,'D7X')
                    obs.BDS(2).data.D(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end            
            case 'S' % Signal strength
                if strcmp(data_type,'S2I')||strcmp(data_type,'S2Q')||strcmp(data_type,'S2X')
                    obs.BDS(1).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                elseif strcmp(data_type,'S7I')||strcmp(data_type,'S7Q')||strcmp(data_type,'S7X')
                    obs.BDS(2).data.S(prn,count)=str2double(line(idx:idx+len));
                    idx = idx + len;
                else
                    idx = idx + len;
                end             
        end
    end

end

