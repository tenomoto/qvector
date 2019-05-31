# NCL scripts to draw Q-vector

The scripts in this repository draw the following plots:

* sea-level pressure
* geopotentail and p-velocity
* Q-vectors and their divergence.

NCEP/NCAR renanalysis (Kalnay et al. 1996) are obtained from
the OpenDAP server at NOAA/ESRL.

## How to use

* Edit config.txt for
- date and time: yyyymmddhh
- region: lon0, lon1, lat0, lat1
- pressure level: plev (hPa)
- temperature: dT, T0, T1 (K)
- geopotential: dz (m)
- p-velocity: domg, omg0, omg1 (hPa/h)
- Q-vector: qref
- div Q: dQ, Q0, Q1
* Run plot.sh
- Change dev=x11 to dev=pdf in plot.sh to save PDFs.
