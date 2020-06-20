# RINEX_nav-obs_parser

## A tool for convertting RINEX version 3 navigation data and observation data to '.mat' data struct

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

### Navigation massage:
    eph.ionoParameters // Ionospheric correction parameters, see TABLE A5 in RINEX documentation
    eph.LeapSeconds // Current Number of leap seconds from GPS starting time.
    eph.GPS: t_oc // Time of clock in GPS seconds
    eph.GPS: a_f0, a_f1, a_f2 // SV clock bias (seconds), SV clock drift (sec/sec), SV clock drift rate (sec/sec2).
    
