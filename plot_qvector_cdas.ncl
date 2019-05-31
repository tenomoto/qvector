load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$HOME/local/lib/ncarg/nclscripts/grads/grads.ncl"
load "qvector.ncl"
load "config.txt"

begin
  f = addfile(datadir+"/pressure/hgt."+year+".nc","r")
  g = addfile(datadir+"/pressure/air."+year+".nc","r")
  time = f->time
  utime = cd_calendar(time, -3)
  t = closest_val(yyyymmddhh, utime)

  res = True
  res@tiMainString = dset
  res@gsnCenterString = yyyymmddhh
  res@gsnLeftString = "Q"
  res@gsnRightString = "divQ"
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
  res@cnMinLevelValF = Q0
  res@cnMaxLevelValF =  Q1
  res@cnLevelSpacingF = dQ

  resv = True
  resv@gsnDraw = False
  resv@gsnFrame = False
  resv@gsnLeftString = ""
  resv@gsnRightString = ""
  resv@vcRefAnnoSide = "Right"
  resv@vcRefAnnoString2On = False
  resv@vcRefMagnitudeF = qref
  resv@vcRefLengthF = 0.045
  resv@vcRefAnnoOrthogonalPosF = -1.0
  resv@vcRefAnnoArrowLineColor = "black"
  resv@vcRefAnnoArrowUseVecColor = False
  resv@vcGlyphStyle = "CurlyVector"
  resv@vcLineArrowColor = "black"
  resv@vcLineArrowThicknessF = 3

  wks = gsn_open_wks(dev, "qvector"+yyyymmddhh+dset)
  gsn_define_colormap(wks,"posneg_1")

  z = f->hgt(t,{plev},:,:)
  T = g->air(t,{plev},:,:)
  Q = qvector(z(::-1,:), T(::-1,:), 0.5*(lat0+lat1), plev*100)

  Qx = z
  Qx = (/Q(0,::-1,:)/)
  Qy = z
  Qy = (/Q(1,::-1,:)/)
  divQ = z
  divQ = (/Q(2,::-1,:)/)

  plot = gsn_csm_contour_map(wks, divQ, res)
  plotv = gsn_csm_vector(wks, Qx, Qy, resv)
  overlay(plot, plotv)
  draw(plot)
  frame(wks)
end
