#!/bin/sh
dev=pdf
ncl -nQ dev=\"${dev}\" plot_slp_cdas.ncl
ncl -nQ dev=\"${dev}\" plot_zOmg_cdas.ncl
ncl -nQ dev=\"${dev}\" plot_qvector_cdas.ncl
ncl -nQ dev=\"${dev}\" plot_zT_qvector_cdas.ncl
