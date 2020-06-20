# RINEX_nav-obs_parser

## A tool for convertting RINEX version 3 navigation data and observation data to '.mat' data struct
% Please email bug reports or suggestions for improvements to:
% wahu@ece.ucr.edu
## Supporting standard RINEX version 3 file: .rnx, .nav, .obs
## Supporting GPS, GLONASS, GALILEO, BeiDou.

If you download the Multi-GNSS observation data file from IGS which is .crx file, you need using
crx2rnx tool to uncompress .crx file. This tool is available at https://terras.gsi.go.jp/ja/crx2rnx.html

## Instruction:
  Go to subfolder MATLAB_code, run parser_rinex, select the rinex file that you want to parse.


## Reference: 
ftp://igs.org/pub/data/format/rinex303.pdf

http://acc.igs.org/misc/rinex304.pdf

## Data struct description:
Note: time in eph and obs are represented in GPS time.
### Navigation massage:
    eph.ionoParameters // Ionospheric correction parameters, see TABLE A5 in RINEX documentation
    eph.LeapSeconds // Current Number of leap seconds from GPS starting time.
#### GPS (see TABLE A6 in RINEX documentation)
    eph.GPS: t_oc // Time of clock in GPS seconds of week
             a_f0, a_f1, a_f2 // SV clock bias (seconds), SV clock drift (sec/sec), SV clock drift rate (sec/sec2)
             IODE, C_rs, Delta_n, M_0 // Broadcast orbit - 1
             C_uc, e, C_us, sqrtA // Broadcast orbit - 2
             t_oe, C_ic, Omega_0, C_is // Broadcast orbit - 3
             i_0, C_rc, Omega, OmegaDot // Broadcast orbit - 4
             IDOT, CodesOnL2, week_num, L2Pflag // Broadcast orbit - 5
             SV_acc, SV_health, TGD, IODC // Broadcast orbit - 6
             trans_time, fit_interval // Broadcast orbit - 7
#### GALILEO (see TABLE A8 in RINEX documentation)
    eph.GAL: t_oc // Time of clock GAL (Have been convert to GPS time, represented by seconds of week)
             a_f0, a_f1, a_f2 // SV clock bias (seconds), SV clock drift (sec/sec), SV clock drift rate (sec/sec2)
             IODE, C_rs, Delta_n, M_0 // Broadcast orbit - 1
             C_uc, e, C_us, sqrtA // Broadcast orbit - 2
             t_oe, C_ic, Omega_0, C_is // Broadcast orbit - 3
             i_0, C_rc, Omega, OmegaDot // Broadcast orbit - 4
             IDOT, Data_source, week_num // Broadcast orbit - 5
             SV_acc, SV_health, BGD_E5a, BGD_E5b // Broadcast orbit - 6
             trans_time // Broadcast orbit - 7
#### GLONASS (see TABLE A10 in RINEX documentation)
    eph.GLO: t_oc // Time of clock UTC (Have been convert to GPS time, represented by seconds of week)
             nTauN, pGammaN, t_of // SV clock bias(sec)(-TauN), SV relative frequency bias(+GammaN), Message frame time
             X, Xdot, Xacc, SV_health // Broadcast orbit - 1 (unit of length have been covert from km to m)
             Y, Ydot, Yacc, freq // Broadcast orbit - 2 (unit of length have been covert from km to m)
             Z, Zdot, Zacc, age // Broadcast orbit - 3 (unit of length have been covert from km to m)
#### BeiDou (see TABLE A14 in RINEX documentation)
    eph.GAL: t_oc // Time of clock BDT (Have been convert to GPS time, represented by seconds of week)
             a_f0, a_f1, a_f2 // SV clock bias (seconds), SV clock drift (sec/sec), SV clock drift rate (sec/sec2)
             AODE, C_rs, Delta_n, M_0 // Broadcast orbit - 1
             C_uc, e, C_us, sqrtA // Broadcast orbit - 2
             t_oe, C_ic, Omega_0, C_is // Broadcast orbit - 3
             i_0, C_rc, Omega, OmegaDot // Broadcast orbit - 4
             IDOT, week_num // Broadcast orbit - 5
             SV_acc, SV_health, TGD1, TGD2 // Broadcast orbit - 6
             trans_time, ADOC // Broadcast orbit - 7             

### Observation data:
  see specification section in unil/parser_obs.m header comments
