* =====================================================================
* corners_TB.inc  --  Corners de componentes externos del banco completo
*   (fuente de corriente Axx Onchip + LDO en el mismo esquematico)
* Reemplaza a corners_R.inc y corners_LDO.inc: usa SOLO este archivo.
*
* USO EN TB_Tran_TOP.asc:
*   1. Borra los dos .include anteriores y deja solo:
*      .include "C:\Users\Usuario\Documents\Chipa_pcb\Onchip_CurRefGen\Onchip_CurRefGen\pcb\corners_TB.inc"
*   2. Valores en el esquematico:
*        R1      -> {R1_val}   IOUTN_2UA -> VDD3V3, 2 uA sumidero
*        R2      -> {R2_val}   IOUTP_2UA -> VSS, 2 uA fuente (esq. 500k)
*        R3      -> {R3_val}   IOUTN_20UA -> VDD3V3, 20 uA sumidero
*        R4      -> {R4_val}   IOUTP_20UA -> VSS, 20 uA fuente (esq. 50k)
*        R5      -> {R5_val}   IOUTN_50UA -> VDD3V3, 50 uA sumidero (esq. 46k)
*        R6      -> {R6_val}   IOUTP_50UA -> VSS, 50 uA fuente
*        RVCOMP  -> {RVCOMP_val}   VCOMP -> VSS (2 x 300k en la PCB)
*        R7      -> {R7_val}   vin -> EN del LDO
*        R8      -> {R8_val}   EN -> GND del LDO
*        C1      -> {C1_val}   entrada LDO (vin)
*        C2      -> {C2_val}   salida LDO (VDD3V3)
*      (en RVCOMP quita tambien 'tol=5')
*   3. .tran 0 5m 0   y ningun otro .step
*   4. Resultados: View > SPICE Error Log (Ctrl+L)
*
* MODO A (activo): uno a la vez, 25 corridas
*   0          nominal
*   1..22      un componente al extremo bajo (impar) o alto (par):
*                1,2 = R1
*                3,4 = R2
*                5,6 = R3
*                7,8 = R4
*                9,10 = R5
*                11,12 = R6
*                13,14 = RVCOMP
*                15,16 = R7
*                17,18 = R8
*                19,20 = C1
*                21,22 = C2
*   23         todos al extremo bajo
*   24         todos al extremo alto
* MODO B: Monte Carlo (R +/-1 %, C +/-10 %)
* =====================================================================

.param tol  = 0.01   ; resistencias 1 %
.param tolC = 0.10   ; capacitores 10 % (CL21A106KAYNNNE)

* --- Nominales -----------------------------------------------------------
.param R1_nom = 1.15Meg
.param R2_nom = 499k
.param R3_nom = 115k
.param R4_nom = 49.9k
.param R5_nom = 46.4k
.param R6_nom = 20k
.param RVCOMP_nom = 600k
.param R7_nom = 100k
.param R8_nom = 100k
.param C1_nom = 10u
.param C2_nom = 10u

* Perdida de C por polarizacion DC (X5R/X7R). 1 = sin perdida.
.param kDC1 = 1
.param kDC2 = 1

* =====================================================================
* MODO A: UNO A LA VEZ
* =====================================================================
.step param corner 0 24 1
.param idx = {floor((corner+1)/2)}
.param sgn = {if(corner-2*floor(corner/2) == 1, -1, 1)}
.param kR1 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==1,1+tol*sgn,1))))}
.param kR2 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==2,1+tol*sgn,1))))}
.param kR3 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==3,1+tol*sgn,1))))}
.param kR4 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==4,1+tol*sgn,1))))}
.param kR5 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==5,1+tol*sgn,1))))}
.param kR6 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==6,1+tol*sgn,1))))}
.param kRVCOMP = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==7,1+tol*sgn,1))))}
.param kR7 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==8,1+tol*sgn,1))))}
.param kR8 = {if(corner==0,1, if(corner==23,1-tol, if(corner==24,1+tol, if(idx==9,1+tol*sgn,1))))}
.param kC1 = {if(corner==0,1, if(corner==23,1-tolC, if(corner==24,1+tolC, if(idx==10,1+tolC*sgn,1))))}
.param kC2 = {if(corner==0,1, if(corner==23,1-tolC, if(corner==24,1+tolC, if(idx==11,1+tolC*sgn,1))))}

* =====================================================================
* MODO B: MONTE CARLO (comenta todo el MODO A y descomenta esto)
* =====================================================================
*.step param run 1 100 1
*.param kR1 = {mc(1, tol)}
*.param kR2 = {mc(1, tol)}
*.param kR3 = {mc(1, tol)}
*.param kR4 = {mc(1, tol)}
*.param kR5 = {mc(1, tol)}
*.param kR6 = {mc(1, tol)}
*.param kRVCOMP = {mc(1, tol)}
*.param kR7 = {mc(1, tol)}
*.param kR8 = {mc(1, tol)}
*.param kC1 = {mc(1, tolC)}
*.param kC2 = {mc(1, tolC)}

* --- Valores aplicados ---------------------------------------------------
.param R1_val = {R1_nom*kR1}
.param R2_val = {R2_nom*kR2}
.param R3_val = {R3_nom*kR3}
.param R4_val = {R4_nom*kR4}
.param R5_val = {R5_nom*kR5}
.param R6_val = {R6_nom*kR6}
.param RVCOMP_val = {RVCOMP_nom*kRVCOMP}
.param R7_val = {R7_nom*kR7}
.param R8_val = {R8_nom*kR8}
.param C1_val = {C1_nom*kC1*kDC1}
.param C2_val = {C2_nom*kC2*kDC2}

* --- Mediciones: fuente de corriente (estado estable, 4.5 ms) ------------
.meas tran I_R1 FIND abs(I(R1)) AT 4.5m
.meas tran I_R2 FIND abs(I(R2)) AT 4.5m
.meas tran I_R3 FIND abs(I(R3)) AT 4.5m
.meas tran I_R4 FIND abs(I(R4)) AT 4.5m
.meas tran I_R5 FIND abs(I(R5)) AT 4.5m
.meas tran I_R6 FIND abs(I(R6)) AT 4.5m
.meas tran I_RVCOMP FIND abs(I(RVCOMP)) AT 4.5m
.meas tran V_R1 PARAM I_R1*R1_val
.meas tran V_R2 PARAM I_R2*R2_val
.meas tran V_R3 PARAM I_R3*R3_val
.meas tran V_R4 PARAM I_R4*R4_val
.meas tran V_R5 PARAM I_R5*R5_val
.meas tran V_R6 PARAM I_R6*R6_val
.meas tran V_RVCOMP PARAM I_RVCOMP*RVCOMP_val
.meas tran err_R1_pct PARAM (I_R1-2u)/2u*100
.meas tran err_R2_pct PARAM (I_R2-2u)/2u*100
.meas tran err_R3_pct PARAM (I_R3-20u)/20u*100
.meas tran err_R4_pct PARAM (I_R4-20u)/20u*100
.meas tran err_R5_pct PARAM (I_R5-50u)/50u*100
.meas tran err_R6_pct PARAM (I_R6-50u)/50u*100
* Tiempo a referencia: 99 % del valor final (nominal R1: ~843.8 us)
.meas tran t_ref_R1 WHEN abs(I(R1))=0.99*I_R1 RISE=1
.meas tran t_ref_R3 WHEN abs(I(R3))=0.99*I_R3 RISE=1
.meas tran t_ref_R5 WHEN abs(I(R5))=0.99*I_R5 RISE=1

* --- Mediciones: LDO --------------------------------------------------------
.meas tran Vin_ss   AVG V(vin)    FROM 4m TO 5m
.meas tran Vout_ss  AVG V(VDD3V3) FROM 4m TO 5m
.meas tran Vout_pp  PP  V(VDD3V3) FROM 4m TO 5m
.meas tran Vout_min MIN V(VDD3V3) FROM 4m TO 5m
.meas tran I_R8     AVG abs(I(R8)) FROM 4m TO 5m
.meas tran V_EN     PARAM I_R8*R8_val
.meas tran err_Vout_pct PARAM (Vout_ss-3.3)/3.3*100
.meas tran t_on99   WHEN V(VDD3V3)=0.99*Vout_ss RISE=1

.options plotwinsize=0
