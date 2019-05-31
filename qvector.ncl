pi = acos(-1.)
g_earth = 9.81; m/s^2
dayinsec = 86400.; s
Omega = 2 * pi / dayinsec
deg2rad = pi / 180.
Rd = 273.15; K
function qvector(z:numeric, T:numeric, lat:numeric, plev:numeric)
; input
;   z(:,:) (gpm), T(:,:) (K), lat (deg), plev (Pa)
; output
;   Q(0,:,:) Qx
;   Q(1,:,:) Qy
;   Q(2,:,:) \nabla Q
; NB. gradient and divergence is computed using SPHEREPACK functions
;     no missing values are allowed

begin
  gfr = g_earth/(2.0 * Omega * sin(lat*deg2rad))

  ug = z
  vg = z
  gradsf(z, vg, ug)
  ug = -ug*gfr
  vg =  vg*gfr

  ugx = ug
  ugy = ug
  vgx = vg
  vgy = vg
  gradsf(ug, ugx, ugy)
  gradsf(vg, vgx, vgy)
;  ugx = smth9(ugx,0.5,0.25,True)
;  vgx = smth9(vgx,0.5,0.25,True)

  Tx = T
  Ty = T
  gradsf(T, Tx, Ty)
;  Tx = smth9(Tx,0.5,0.25,True)
;  Ty = smth9(Ty,0.5,0.25,True)

  n = dimsizes(z)
  Q = new((/3, n(0), n(1)/), typeof(z))
  Q(0,:,:) = -Rd/plev*(ugx*Tx + vgx*Ty)
  Q(1,:,:) = -Rd/plev*(ugy*Tx + vgy*Ty)
  uv2dvf(Q(0,:,:), Q(1,:,:), Q(2,:,:))
 ; Q(2,:,:) = smth9(Q(2,:,:),0.5,0.25,True)
  return Q
 end
