load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "config.txt"

begin
  f = addfile(datadir+"/pressure/hgt."+year+".nc","r")
  g = addfile(datadir+"/pressure/omega."+year+".nc","r")
  time = f->time
  utime = cd_calendar(time, -3)
  t = closest_val(yyyymmddhh, utime)

  res = True
  res@tiMainString = dset
  res@gsnCenterString = yyyymmddhh
  res@gsnLeftString = "z m"
  res@gsnRightString = "omg hPa/h"
;  res@gsnMaximize = True
  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnSpreadColors = True
  res@gsnSpreadColorStart = 5
  res@gsnMaskLambertConformal = True
  res@mpProjection = "LambertConformal"
  res@mpMinLonF = lon0
  res@mpMaxLonF = lon1
  res@mpCenterLonF = 0.5*(lon0+lon1)
  res@mpMinLatF = lat0
  res@mpMaxLatF = lat1
  res@mpGridAndLimbOn = True
  res@mpDataBaseVersion = "Ncarg4_1"
  res@cnFillOn = True
  res@cnLinesOn = False
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF = omg0
  res@cnMaxLevelValF = omg1
  res@cnLevelSpacingF = domg

  resc = True
  resc@gsnDraw = False
  resc@gsnFrame = False
  resc@gsnLeftString = ""
  resc@gsnRightString = ""
  resc@cnLevelSpacingF = dz
  resc@cnLineThicknessF = 3

  wks = gsn_open_wks(dev, "zOmg"+yyyymmddhh+dset)
  gsn_define_colormap(wks, "posneg_1")

  z = f->hgt(t,{plev},:,:)
  omg = g->omega(t,{plev},:,:)
  omg = omg*36; Pa/s => hPa/h

  plot = gsn_csm_contour_map(wks, omg, res)
  plotc = gsn_csm_contour(wks, z, resc)
  overlay(plot, plotc)
  draw(plot)
  frame(wks)
end
