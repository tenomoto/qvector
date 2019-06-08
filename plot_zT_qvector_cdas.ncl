load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
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
  res@gsnRightString = "z T"
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
  res@mpGeophysicalLineThicknessF = 2
  res@cnFillOn = True
  res@cnLinesOn = False
  if (dT.ne.0) then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMinLevelValF = T0
    res@cnMaxLevelValF = T1
    res@cnLevelSpacingF =  dT
  end if

  resc = True
  resc@gsnLeftString = ""
  resc@gsnRightString = ""
  resc@gsnDraw = False
  resc@gsnFrame = False
  resc@cnLevelSpacingF = dz
  resc@cnLineThicknessF = 3
  resc@cnInfoLabelOn = False

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

  wks = gsn_open_wks(dev, "z-T-qvector_"+yyyymmddhh+"_"+dset)
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

  plot = gsn_csm_contour_map(wks, T, res)
  plotc = gsn_csm_contour(wks, z, resc)
  plotv = gsn_csm_vector(wks, Qx, Qy, resv)
  overlay(plot, plotc)
  overlay(plot, plotv)
  draw(plot)
  frame(wks)
end
