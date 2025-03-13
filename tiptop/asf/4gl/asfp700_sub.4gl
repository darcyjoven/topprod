# Prog. Version..: '5.30.06-13.04.22(00008)'     #
# Pattern name...: asfp700_sub.4gl
# Descriptions...: 存放asfp700相關函數
# Date & Author..: 10/09/12 by kim (#FUN-A80102)
# Modify.........: NO.TQC-AC0258 10/12/17 By jan 該從ecm_file 抓取單位資料
# Modify.........: NO.FUN-B70015 11/07/07 By yangxf  經營方式默認給值'1'經銷
# Modify.........: NO.MOD-BC0189 11/12/21 By ck2yuan 將工單紀錄的專案代號(sfb27)寫到採購單身的專案代號中(pmn122)
# Modify.........: NO.TQC-C10056 12/01/16 By suncx 資料來源欄位默認給值‘5’工單轉入
# Modify.........: NO.TQC-C50232 12/05/29 By lixh1 增加對委外採購單來源單號的賦值
# Modify.........: No:MOD-D30070 13/03/08 By bart 依SMA904傳給 s_curr3
# Modify.........: No:FUN-D40042 13/04/15 By fengrui 轉採購時，工單備註sfb96入採購單備註pmn100

DATABASE ds        
 
GLOBALS "../../config/top.global"

#FUN-A80102
FUNCTION  p700sub_pmm(p_pmm01,p_pmm04,p_pmm09,p_pmm12,p_pmm22)       #產生委外採購單頭資料
  DEFINE p_pmm01 LIKE pmm_file.pmm01
  DEFINE p_pmm04 LIKE pmm_file.pmm04
  DEFINE p_pmm09 LIKE pmm_file.pmm09
  DEFINE p_pmm12 LIKE pmm_file.pmm12
  DEFINE p_pmm22 LIKE pmm_file.pmm22
  DEFINE l_pmc14 LIKE pmc_file.pmc14,
         l_pmc15 LIKE pmc_file.pmc15,
         l_pmc16 LIKE pmc_file.pmc16,
         l_pmc17 LIKE pmc_file.pmc17,
         l_pmc47 LIKE pmc_file.pmc47,
         l_pmc49 LIKE pmc_file.pmc49,
         l_pmc22 LIKE pmc_file.pmc22
  DEFINE l_formid     LIKE oay_file.oayslip  #CHI-8A0013 
  DEFINE pr_pmm   RECORD LIKE pmm_file.*
 
   WHENEVER ERROR CALL cl_err_msg_log  #TQC-AC0258

   LET pr_pmm.pmm01 =p_pmm01
   LET pr_pmm.pmm02 ='SUB'
   #No.FUN-A60011  --Begin
   LET pr_pmm.pmm03 =0
   LET pr_pmm.pmm905 ='N'
   #No.FUN-A60011  --End  
   LET pr_pmm.pmm909 = '5'    #TQC-C10056
   LET pr_pmm.pmm04 =p_pmm04
   LET pr_pmm.pmm09 =p_pmm09
   SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
     INTO pr_pmm.pmm10,pr_pmm.pmm11,pr_pmm.pmm20,pr_pmm.pmm21,pr_pmm.pmm22,
          pr_pmm.pmm41
           FROM pmc_file
          WHERE pmc01=pr_pmm.pmm09
   LET pr_pmm.pmm12 =p_pmm12
   SELECT gen03 INTO pr_pmm.pmm13 FROM gen_file WHERE gen01= pr_pmm.pmm12
   LET pr_pmm.pmm18 ='N'
   LET pr_pmm.pmm25 ='0'
   SELECT azn02,azn04 INTO pr_pmm.pmm31,pr_pmm.pmm32 FROM azn_file
    WHERE azn01 = pr_pmm.pmm04
   IF NOT cl_null(p_pmm22) THEN LET pr_pmm.pmm22 = p_pmm22 END IF
   #CALL s_curr3(pr_pmm.pmm22,pr_pmm.pmm04,'S') RETURNING pr_pmm.pmm42  #MOD-D30070
   CALL s_curr3(pr_pmm.pmm22,pr_pmm.pmm04,g_sma.sma904) RETURNING pr_pmm.pmm42  #MOD-D30070
   SELECT gec04 INTO pr_pmm.pmm43 FROM gec_file
          WHERE gec01= pr_pmm.pmm21 AND gec011='1'
   IF SQLCA.SQLCODE THEN LET pr_pmm.pmm43=0 ELSE IF cl_null(pr_pmm.pmm43) THEN
   LET pr_pmm.pmm43=0 END IF END IF
   LET pr_pmm.pmm45 ='N'   #FUN-690047 modify  #'Y'
   LET pr_pmm.pmm30 = 'N'  #No.MOD-780243 add
   LET pr_pmm.pmmprsw='Y'
   LET pr_pmm.pmmmksg ='N'
   LET l_formid = s_get_doc_no(pr_pmm.pmm01)
      SELECT smyapr INTO pr_pmm.pmmmksg FROM smy_file
      WHERE smyslip=l_formid
   LET pr_pmm.pmmacti ='Y'
   LET pr_pmm.pmmuser =g_user
   LET pr_pmm.pmmgrup =g_grup
   LET pr_pmm.pmmdate =TODAY
   LET pr_pmm.pmmcrat =TODAY  #No.FUN-A60011
#  LET pr_pmm.pmm51 = ' '     #NO.FUN-960130     #NO.FUN-9B0016   #FUN-B70015 mark
   LET pr_pmm.pmm51 = '1'     #FUN-B70015     
   LET pr_pmm.pmmpos = 'N'     #NO.FUN-960130
 
   LET pr_pmm.pmmplant = g_plant #FUN-980008 add
   LET pr_pmm.pmmlegal = g_legal #FUN-980008 add
 
   LET pr_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
   LET pr_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
   RETURN pr_pmm.*
END FUNCTION

FUNCTION p700sub_pmn(p_pmn01,p_pmn02,p_pmn04,p_ecm01,p_ecm012,p_ecm03,
                     p_pmn20,p_pmn31,p_pmn91,p_pmn31t,p_pmn33,p_pmm13,
                     p_pmm22)     #update 請購單身之已轉採購數量及狀況碼
DEFINE p_pmn02  LIKE pmn_file.pmn02
DEFINE p_pmn01  LIKE pmn_file.pmn01 
DEFINE p_pmn04  LIKE pmn_file.pmn04 
DEFINE p_ecm01  LIKE ecm_file.ecm01 
DEFINE p_ecm012 LIKE ecm_file.ecm012
DEFINE p_ecm03  LIKE ecm_file.ecm03 
DEFINE p_pmn20  LIKE pmn_file.pmn20 
DEFINE p_pmn31  LIKE pmn_file.pmn31 
DEFINE p_pmn91  LIKE pmn_file.pmn91 
DEFINE p_pmn31t LIKE pmn_file.pmn31t
DEFINE p_pmn33  LIKE pmn_file.pmn33 
DEFINE p_pmm13  LIKE pmm_file.pmm13
DEFINE p_pmm22  LIKE pmm_file.pmm22
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE l_ima44  LIKE ima_file.ima44
DEFINE l_ima906 LIKE ima_file.ima906
DEFINE l_ima907 LIKE ima_file.ima907
DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE l_factor LIKE ima_file.ima44_fac
DEFINE l_ecm012 LIKE ecm_file.ecm012   #FUN-A60095
DEFINE l_ecm03  LIKE ecm_file.ecm03    #FUN-A60095
DEFINE l_flag   LIKE type_file.num5
DEFINE pr_pmn   RECORD LIKE pmn_file.*

   LET pr_pmn.pmn01 =p_pmn01
   LET pr_pmn.pmn011='SUB'
   LET pr_pmn.pmn02 =p_pmn02
   LET pr_pmn.pmn04 =p_pmn04
   LET pr_pmn.pmn012=p_ecm012     #No.FUN-A60011

   SELECT ima02,ima25
     INTO pr_pmn.pmn041,pr_pmn.pmn08
     FROM ima_file WHERE ima01=pr_pmn.pmn04
  #TQC-AC0258--begin--mod--------
  #SELECT sgm58 INTO pr_pmn.pmn07 FROM sgm_file
  # WHERE sgm01  = p_sgm01 AND sgm03 = p_ecm03
  #   AND sgm012 = p_ecm012
   SELECT ecm58 INTO pr_pmn.pmn07 FROM ecm_file
    WHERE ecm01  = p_ecm01 AND ecm03 = p_ecm03
      AND ecm012 = p_ecm012
  #TQC-AC0258--end--add--------
   CALL s_umfchk(pr_pmn.pmn04,pr_pmn.pmn07,pr_pmn.pmn08)
      RETURNING l_flag,pr_pmn.pmn09
   IF l_flag = 1 THEN
      CALL s_errmsg('','',pr_pmn.pmn07,'mfg1206',1)   #NO.FUN-710026
      LET g_success='N'
      RETURN pr_pmn.*
   END IF
   LET pr_pmn.pmn11 ='N'
   LET pr_pmn.pmn13 =0
   CALL s_overate(pr_pmn.pmn04) RETURNING pr_pmn.pmn13  #MOD-7B0090
   LET pr_pmn.pmn14 ='Y'
   LET pr_pmn.pmn15 ='Y'
   LET pr_pmn.pmn16 ='0'
   LET pr_pmn.pmn20 = p_pmn20
   LET pr_pmn.pmn31 = p_pmn31
   LET pr_pmn.pmn91 = p_pmn91     #No.FUN-810016
   LET pr_pmn.pmn31t=p_pmn31t     #No.FUN-550109
   LET pr_pmn.pmn33 =p_pmn33  #預計交貨日
   LET pr_pmn.pmn34 =p_pmn33
   LET pr_pmn.pmn35 =p_pmn33
   LET pr_pmn.pmn38 ='N'   #FUN-690047 modify  #'Y'
   LET pr_pmn.pmn41 =p_ecm01
   LET pr_pmn.pmn42 ='0'
   LET pr_pmn.pmn43 =p_ecm03  # 製程序號
   #FUN-A60095--begin--modify----------
   #SELECT MIN(ecm03) INTO pr_pmn.pmn431 FROM ecm_file                                                                                
   # WHERE ecm01 = g_tmp.ecm01                                                                                                       
   #   AND ecm012= g_tmp.ecm012   #No.FUN-A60011
   #   AND ecm03 > g_tmp.ecm03                                                                                                       
   #IF SQLCA.sqlcode THEN                                                                                                            
   #   LET pr_pmn.pmn431 = 0                                                                                                          
   #END IF 
   CALL s_schdat_next_ecm03(p_ecm01,p_ecm012,p_ecm03)
   RETURNING l_ecm012,l_ecm03
   IF cl_null(l_ecm03) THEN LET l_ecm03 = 0 END IF
   LET pr_pmn.pmn431 = l_ecm03
   #FUN-A60095--end--modify---------------                                                                                                                          
   LET pr_pmn.pmn46 =p_ecm03  # 製程序號
   LET pr_pmn.pmn50 =0
   LET pr_pmn.pmn51 =0
   LET pr_pmn.pmn53 =0
   LET pr_pmn.pmn55 =0
   LET pr_pmn.pmn57 =0
   LET pr_pmn.pmn61 =pr_pmn.pmn04
   LET pr_pmn.pmn62 =1
   LET pr_pmn.pmn65 ='1'
   LET pr_pmn.pmn75 = p_ecm01  #TQC-C50232
   #FUN-A80102 mark(S)
   #SELECT pmm43 INTO pr_pmm.pmm43 FROM pmm_file WHERE pmm01=pr_pmm.pmm01
   #IF SQLCA.SQLCODE THEN LET pr_pmm.pmm43=0 ELSE IF cl_null(pr_pmm.pmm43) THEN
   #LET pr_pmm.pmm43 =0 END IF
   #END IF
   #FUN-A80102 mark(E)

   #No.FUN-A60011  --Begin
   LET pr_pmn.pmn89 = 'N'
   #No.FUN-A60011  --Begin
   LET pr_pmn.pmn63 ='N'
   SELECT ima15 INTO pr_pmn.pmn64
     FROM ima_file
    WHERE ima01 = p_pmn04
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima25,ima44,ima906,ima907 INTO l_ima25,l_ima44,l_ima906,l_ima907
        FROM ima_file WHERE ima01=pr_pmn.pmn04
      IF SQLCA.sqlcode =100 THEN
         IF pr_pmn.pmn04 MATCHES 'MISC*' THEN
            SELECT ima25,ima44,ima906,ima907
              INTO l_ima25,l_ima44,l_ima906,l_ima907
              FROM ima_file WHERE ima01='MISC'
         END IF
      END IF
      IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
      LET pr_pmn.pmn80=pr_pmn.pmn07
      LET l_factor = 1
      CALL s_umfchk(pr_pmn.pmn04,pr_pmn.pmn80,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET pr_pmn.pmn81=l_factor
      LET pr_pmn.pmn82=pr_pmn.pmn20
      LET pr_pmn.pmn83=l_ima907
      LET l_factor = 1
      CALL s_umfchk(pr_pmn.pmn04,pr_pmn.pmn83,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET pr_pmn.pmn84=l_factor
      LET pr_pmn.pmn85=0
      IF l_ima906 = '3' THEN
         LET l_factor = 1
         CALL s_umfchk(pr_pmn.pmn04,pr_pmn.pmn80,pr_pmn.pmn83)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET pr_pmn.pmn85=pr_pmn.pmn82*l_factor
      END IF
   END IF
   LET pr_pmn.pmn86 =pr_pmn.pmn07
   LET pr_pmn.pmn87 =pr_pmn.pmn20
   LET pr_pmn.pmn90 =pr_pmn.pmn31   #CHI-690043 add
   IF NOT (cl_null(pr_pmn.pmn24) AND cl_null(pr_pmn.pmn25)) THEN
      SELECT pml930 INTO pr_pmn.pmn930 FROM pml_file
                                     WHERE pml01=pr_pmn.pmn24
                                       AND pml02=pr_pmn.pmn25
      IF SQLCA.sqlcode THEN
         LET pr_pmn.pmn930=NULL
      END IF
   ELSE
      LET pr_pmn.pmn930=s_costcenter(p_pmm13)
   END IF
 
    SELECT azi04 INTO t_azi04 FROM azi_file     #No.
     WHERE azi01 = p_pmm22  AND aziacti= 'Y'  #原幣
    LET pr_pmn.pmn88 = cl_digcut( pr_pmn.pmn31  * pr_pmn.pmn87, t_azi04)
    LET pr_pmn.pmn88t= cl_digcut( pr_pmn.pmn31t * pr_pmn.pmn87, t_azi04) 
    IF cl_null(pr_pmn.pmn02) THEN LET pr_pmn.pmn02 = 0 END IF   #TQC-790002 add
    LET pr_pmn.pmn73 = ' '   #NO.FUN-960130
    LET pr_pmn.pmnplant = g_plant #FUN-980008 add
    LET pr_pmn.pmnlegal = g_legal #FUN-980008 add
    IF cl_null(pr_pmn.pmn58) THEN LET pr_pmn.pmn58 = 0 END IF #TQC-9B0203
    IF cl_null(pr_pmn.pmn012) THEN LET pr_pmn.pmn012 = ' ' END IF   #FUN-A60076 

    SELECT sfb27,sfb96 INTO pr_pmn.pmn122,pr_pmn.pmn100 FROM sfb_file WHERE sfb01=p_ecm01  #MOD-BC0189 add  #FUN-D40042 pmn100

    RETURN pr_pmn.*
END FUNCTION
