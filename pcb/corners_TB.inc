* =====================================================================
* corners_TB.inc  --  Corners de componentes externos (segun datasheet)
*   fuente de corriente Axx Onchip + LDO + ADR3412 + ADA4505
* Usa SOLO este archivo:   .include corners_TB.inc
*
* Cada componente usa la tolerancia y el TCR de la parte propuesta
* (tabla del documento). Capacitores ceramicos X5R/X7R incluyen la
* perdida por polarizacion DC (kDC, APROXIMADA: verificar con la curva
* C vs. V DC del fabricante y ajustar).
*
* Valores en el esquematico:
*   R1      -> {R1_val}
*   R2      -> {R2_val}
*   R3      -> {R3_val}
*   R4      -> {R4_val}
*   R5      -> {R5_val}
*   R6      -> {R6_val}
*   RVCOMP  -> {RVCOMP_val}
*   R7      -> {R7_val}
*   R8      -> {R8_val}
*   C1      -> {C1_val}
*   C2      -> {C2_val}
*   CIN1    -> {CIN1_val}
*   CIN2    -> {CIN2_val}
*   COUT1   -> {COUT1_val}
*   COUT2   -> {COUT2_val}
*   R12     -> {R12_val}
*   R13     -> {R13_val}
*   C5      -> {C5_val}
*   RLOAD1  -> {RLOAD1_val}
*   (en RVCOMP quita tambien 'tol=5')
* NO se varian: R9/I1, C3, C4, V3, V4, L1, L2, R10, R11.
* .tran 0 5m 0  y ningun otro .step.  Resultados: View > SPICE Error Log
*
* MODO A (activo): uno a la vez, 41 corridas
*   0           nominal (con kDC aplicado)
*   1..38       un componente al extremo bajo (impar) o alto (par):
*                 1,2 = R1
*                 3,4 = R2
*                 5,6 = R3
*                 7,8 = R4
*                 9,10 = R5
*                 11,12 = R6
*                 13,14 = RVCOMP
*                 15,16 = R7
*                 17,18 = R8
*                 19,20 = C1
*                 21,22 = C2
*                 23,24 = CIN1
*                 25,26 = CIN2
*                 27,28 = COUT1
*                 29,30 = COUT2
*                 31,32 = R12
*                 33,34 = R13
*                 35,36 = C5
*                 37,38 = RLOAD1
*   39          todos al extremo bajo
*   40          todos al extremo alto
* MODO B: Monte Carlo
* =====================================================================

* --- Temperatura: desviacion respecto a 25 C (afecta via TCR) ----------
* Ej.: dT = 0 (lab a 25 C), dT = 60 (85 C), dT = -65 (-40 C)
.param dT = 0
* Poner 0 para ignorar la perdida por DC en ceramicos
.param useDC = 1

* --- Parametros por componente (datasheet de la parte propuesta) -------
*        nominal       tolerancia        TCR [ppm/C]      kDC (C/C0 a V DC)
.param R1_nom=1.15Meg  tol_R1=0.01   tcr_R1=100  kdc_R1=1     ; Vishay CRCW08051M15FKEBC C4114864 | IOUTN_2UA -> VDD3V3
.param R2_nom=499k     tol_R2=0.01   tcr_R2=100  kdc_R2=1     ; UNI-ROYAL HV05W8F4993T5E C414820 | IOUTP_2UA -> VSS (esq. 500k)
.param R3_nom=115k     tol_R3=0.01   tcr_R3=100  kdc_R3=1     ; FH RS-05K1153FT C322252 | IOUTN_20UA -> VDD3V3
.param R4_nom=49.9k    tol_R4=0.01   tcr_R4=100  kdc_R4=1     ; UNI-ROYAL 0805W8F4992T5E C17719 | IOUTP_20UA -> VSS (esq. 50k)
.param R5_nom=46.4k    tol_R5=0.01   tcr_R5=100  kdc_R5=1     ; Vishay CRCW080546K4FKEC C4360265 | IOUTN_50UA -> VDD3V3 (esq. 46k)
.param R6_nom=20k      tol_R6=0.01   tcr_R6=100  kdc_R6=1     ; UNI-ROYAL 0805W8F2002T5E C4328 | IOUTP_50UA -> VSS
.param RVCOMP_nom=600k     tol_RVCOMP=0.01   tcr_RVCOMP=100  kdc_RVCOMP=1     ; 2x UNI-ROYAL 0805W8F3003T5E C17616 | VCOMP -> VSS
.param R7_nom=100k     tol_R7=0.01   tcr_R7=100  kdc_R7=1     ; UNI-ROYAL 0805W8F1003T5E C149504 | LDO vin -> EN
.param R8_nom=100k     tol_R8=0.01   tcr_R8=100  kdc_R8=1     ; UNI-ROYAL 0805W8F1003T5E C149504 | LDO EN -> GND
.param C1_nom=10u      tol_C1=0.1    tcr_C1=0    kdc_C1=0.6   ; Samsung CL21A106KAYNNNE C15850 (X5R 25V) | LDO entrada, ~5 V DC
.param C2_nom=10u      tol_C2=0.1    tcr_C2=0    kdc_C2=0.7   ; Samsung CL21A106KAYNNNE C15850 (X5R 25V) | LDO salida, 3.3 V DC
.param CIN1_nom=1u       tol_CIN1=0.1    tcr_CIN1=0    kdc_CIN1=0.9   ; Samsung CL21B105KBFNNNE C28323 (X7R 50V) | ADR3412 entrada, ~5 V DC
.param CIN2_nom=100n     tol_CIN2=0.1    tcr_CIN2=0    kdc_CIN2=0.97  ; YAGEO CC0805KRX7R9BB104 C49678 (X7R 50V) | ADR3412 entrada, ~5 V DC
.param COUT1_nom=100n     tol_COUT1=0.1    tcr_COUT1=0    kdc_COUT1=1.0   ; YAGEO CC0805KRX7R9BB104 C49678 (X7R 50V) | ADR3412 salida, 1.2 V DC
.param COUT2_nom=1u       tol_COUT2=0.1    tcr_COUT2=0    kdc_COUT2=0.98  ; Samsung CL21B105KBFNNNE C28323 (X7R 50V) | ADR3412 salida, 1.2 V DC
.param R12_nom=12k      tol_R12=0.001  tcr_R12=25   kdc_R12=1     ; TC0525B1202T5G C2989153 (thin film 0.1%) | ADA4505 realimentacion
.param R13_nom=120      tol_R13=0.01   tcr_R13=100  kdc_R13=1     ; UNI-ROYAL 0805W8F1200T5E C17437 | ADA4505 entrada +
.param C5_nom=100p     tol_C5=0.05   tcr_C5=30   kdc_C5=1.0   ; Samsung CL21C101JBANNNC C1790 (C0G 50V) | ADA4505 salida
.param RLOAD1_nom=1Meg   tol_RLOAD1=0.01   tcr_RLOAD1=100  kdc_RLOAD1=1     ; UNI-ROYAL 0805W8F1004T5E C17514 | carga de VREF12

* =====================================================================
* MODO A: UNO A LA VEZ
* =====================================================================
.step param corner 0 40 1
.param idx = {floor((corner+1)/2)}
.param sgn = {if(corner-2*floor(corner/2) == 1, -1, 1)}
.param kR1 = {if(corner==0,1, if(corner==39,1-tol_R1, if(corner==40,1+tol_R1, if(idx==1,1+tol_R1*sgn,1))))}
.param kR2 = {if(corner==0,1, if(corner==39,1-tol_R2, if(corner==40,1+tol_R2, if(idx==2,1+tol_R2*sgn,1))))}
.param kR3 = {if(corner==0,1, if(corner==39,1-tol_R3, if(corner==40,1+tol_R3, if(idx==3,1+tol_R3*sgn,1))))}
.param kR4 = {if(corner==0,1, if(corner==39,1-tol_R4, if(corner==40,1+tol_R4, if(idx==4,1+tol_R4*sgn,1))))}
.param kR5 = {if(corner==0,1, if(corner==39,1-tol_R5, if(corner==40,1+tol_R5, if(idx==5,1+tol_R5*sgn,1))))}
.param kR6 = {if(corner==0,1, if(corner==39,1-tol_R6, if(corner==40,1+tol_R6, if(idx==6,1+tol_R6*sgn,1))))}
.param kRVCOMP = {if(corner==0,1, if(corner==39,1-tol_RVCOMP, if(corner==40,1+tol_RVCOMP, if(idx==7,1+tol_RVCOMP*sgn,1))))}
.param kR7 = {if(corner==0,1, if(corner==39,1-tol_R7, if(corner==40,1+tol_R7, if(idx==8,1+tol_R7*sgn,1))))}
.param kR8 = {if(corner==0,1, if(corner==39,1-tol_R8, if(corner==40,1+tol_R8, if(idx==9,1+tol_R8*sgn,1))))}
.param kC1 = {if(corner==0,1, if(corner==39,1-tol_C1, if(corner==40,1+tol_C1, if(idx==10,1+tol_C1*sgn,1))))}
.param kC2 = {if(corner==0,1, if(corner==39,1-tol_C2, if(corner==40,1+tol_C2, if(idx==11,1+tol_C2*sgn,1))))}
.param kCIN1 = {if(corner==0,1, if(corner==39,1-tol_CIN1, if(corner==40,1+tol_CIN1, if(idx==12,1+tol_CIN1*sgn,1))))}
.param kCIN2 = {if(corner==0,1, if(corner==39,1-tol_CIN2, if(corner==40,1+tol_CIN2, if(idx==13,1+tol_CIN2*sgn,1))))}
.param kCOUT1 = {if(corner==0,1, if(corner==39,1-tol_COUT1, if(corner==40,1+tol_COUT1, if(idx==14,1+tol_COUT1*sgn,1))))}
.param kCOUT2 = {if(corner==0,1, if(corner==39,1-tol_COUT2, if(corner==40,1+tol_COUT2, if(idx==15,1+tol_COUT2*sgn,1))))}
.param kR12 = {if(corner==0,1, if(corner==39,1-tol_R12, if(corner==40,1+tol_R12, if(idx==16,1+tol_R12*sgn,1))))}
.param kR13 = {if(corner==0,1, if(corner==39,1-tol_R13, if(corner==40,1+tol_R13, if(idx==17,1+tol_R13*sgn,1))))}
.param kC5 = {if(corner==0,1, if(corner==39,1-tol_C5, if(corner==40,1+tol_C5, if(idx==18,1+tol_C5*sgn,1))))}
.param kRLOAD1 = {if(corner==0,1, if(corner==39,1-tol_RLOAD1, if(corner==40,1+tol_RLOAD1, if(idx==19,1+tol_RLOAD1*sgn,1))))}

* =====================================================================
* MODO B: MONTE CARLO (comenta todo el MODO A y descomenta esto)
* =====================================================================
*.step param run 1 100 1
*.param kR1 = {mc(1, tol_R1)}
*.param kR2 = {mc(1, tol_R2)}
*.param kR3 = {mc(1, tol_R3)}
*.param kR4 = {mc(1, tol_R4)}
*.param kR5 = {mc(1, tol_R5)}
*.param kR6 = {mc(1, tol_R6)}
*.param kRVCOMP = {mc(1, tol_RVCOMP)}
*.param kR7 = {mc(1, tol_R7)}
*.param kR8 = {mc(1, tol_R8)}
*.param kC1 = {mc(1, tol_C1)}
*.param kC2 = {mc(1, tol_C2)}
*.param kCIN1 = {mc(1, tol_CIN1)}
*.param kCIN2 = {mc(1, tol_CIN2)}
*.param kCOUT1 = {mc(1, tol_COUT1)}
*.param kCOUT2 = {mc(1, tol_COUT2)}
*.param kR12 = {mc(1, tol_R12)}
*.param kR13 = {mc(1, tol_R13)}
*.param kC5 = {mc(1, tol_C5)}
*.param kRLOAD1 = {mc(1, tol_RLOAD1)}

* --- Valores aplicados: nominal * tolerancia * TCR * DC ------------------
.param R1_val = {R1_nom*kR1*(1+tcr_R1*1u*dT)*(1+useDC*(kdc_R1-1))}
.param R2_val = {R2_nom*kR2*(1+tcr_R2*1u*dT)*(1+useDC*(kdc_R2-1))}
.param R3_val = {R3_nom*kR3*(1+tcr_R3*1u*dT)*(1+useDC*(kdc_R3-1))}
.param R4_val = {R4_nom*kR4*(1+tcr_R4*1u*dT)*(1+useDC*(kdc_R4-1))}
.param R5_val = {R5_nom*kR5*(1+tcr_R5*1u*dT)*(1+useDC*(kdc_R5-1))}
.param R6_val = {R6_nom*kR6*(1+tcr_R6*1u*dT)*(1+useDC*(kdc_R6-1))}
.param RVCOMP_val = {RVCOMP_nom*kRVCOMP*(1+tcr_RVCOMP*1u*dT)*(1+useDC*(kdc_RVCOMP-1))}
.param R7_val = {R7_nom*kR7*(1+tcr_R7*1u*dT)*(1+useDC*(kdc_R7-1))}
.param R8_val = {R8_nom*kR8*(1+tcr_R8*1u*dT)*(1+useDC*(kdc_R8-1))}
.param C1_val = {C1_nom*kC1*(1+tcr_C1*1u*dT)*(1+useDC*(kdc_C1-1))}
.param C2_val = {C2_nom*kC2*(1+tcr_C2*1u*dT)*(1+useDC*(kdc_C2-1))}
.param CIN1_val = {CIN1_nom*kCIN1*(1+tcr_CIN1*1u*dT)*(1+useDC*(kdc_CIN1-1))}
.param CIN2_val = {CIN2_nom*kCIN2*(1+tcr_CIN2*1u*dT)*(1+useDC*(kdc_CIN2-1))}
.param COUT1_val = {COUT1_nom*kCOUT1*(1+tcr_COUT1*1u*dT)*(1+useDC*(kdc_COUT1-1))}
.param COUT2_val = {COUT2_nom*kCOUT2*(1+tcr_COUT2*1u*dT)*(1+useDC*(kdc_COUT2-1))}
.param R12_val = {R12_nom*kR12*(1+tcr_R12*1u*dT)*(1+useDC*(kdc_R12-1))}
.param R13_val = {R13_nom*kR13*(1+tcr_R13*1u*dT)*(1+useDC*(kdc_R13-1))}
.param C5_val = {C5_nom*kC5*(1+tcr_C5*1u*dT)*(1+useDC*(kdc_C5-1))}
.param RLOAD1_val = {RLOAD1_nom*kRLOAD1*(1+tcr_RLOAD1*1u*dT)*(1+useDC*(kdc_RLOAD1-1))}

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

* --- Mediciones: referencia ADR3412 (VREF12) -------------------------------
.meas tran Vref_ss  AVG V(VREF12) FROM 4m TO 5m
.meas tran Vref_pp  PP  V(VREF12) FROM 4m TO 5m
.meas tran err_Vref_pct PARAM (Vref_ss-1.2)/1.2*100
.meas tran t_ref99  WHEN V(VREF12)=0.99*Vref_ss RISE=1
* ADR3412 requiere C de salida efectiva >= 0.1 uF
.meas tran Cout_eff PARAM COUT1_val+COUT2_val
.meas tran I_RLOAD1 PARAM Vref_ss/RLOAD1_val

* --- Mediciones: amplificador ADA4505 (vout, i_probe) ----------------------
.meas tran Vamp_ss   AVG V(vout)    FROM 4m TO 5m
.meas tran Vamp_pp   PP  V(vout)    FROM 4m TO 5m
.meas tran Vprobe_ss AVG V(i_probe) FROM 4m TO 5m
.meas tran I_probe   PARAM (Vprobe_ss-Vamp_ss)/R12_val

.options plotwinsize=0
