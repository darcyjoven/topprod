# Prog. Version..: '5.30.06-13.04.22(00006)'     #
# Pattern name...: asfp710_sub.4gl
# Descriptions...: 存放asfp710相關函數
# Date & Author..: 10/09/12 by kim (#FUN-A90057)
# Modify.........: No.TQC-AB0390 10/12/03 By jan 產生委外採購單時給pmn63,pmn64賦值
# Modify.........: No.TQC-AC0258 10/12/17 By jan WHENEVER ERROR CALL cl_err_msg_log
# Modify.........: No:TQC-C20034 12/02/03 By zhangll 修正稅率錯誤問題
# Modify.........: No:MOD-D30070 13/03/08 By bart 依SMA904傳給 s_curr3
# Modify.........: No:FUN-D40042 13/04/17 By fengrui 轉採購時，工單備註sfb96入採購單備註pmn100
# Modify.........: No:TQC-D40094 13/08/14 By dongsz 工藝委外轉採購單時，資料來源pmm909欄位賦值

DATABASE ds        
 
GLOBALS "../../config/top.global"

#FUN-A90057
FUNCTION  p710sub_pmm(l_pmm01,l_pmm04,l_pmm09,l_pmm12,l_pmm42)       #產生採購單頭資料
   DEFINE l_pmc14 LIKE pmc_file.pmc14,
          l_pmc15 LIKE pmc_file.pmc15,
          l_pmc16 LIKE pmc_file.pmc16,
          l_pmc17 LIKE pmc_file.pmc17,
          l_pmc47 LIKE pmc_file.pmc47,
          l_pmc49 LIKE pmc_file.pmc49,
          l_pmc22 LIKE pmc_file.pmc22
   DEFINE l_pmm RECORD LIKE pmm_file.*
   DEFINE l_pmm01 LIKE pmm_file.pmm01
   DEFINE l_pmm04 LIKE pmm_file.pmm04
   DEFINE l_pmm09 LIKE pmm_file.pmm09
   DEFINE l_pmm12 LIKE pmm_file.pmm12
   DEFINE l_pmm42 LIKE pmm_file.pmm42

   WHENEVER ERROR CALL cl_err_msg_log  #TQC-AC0258

   LET l_pmm.pmm01  = l_pmm01
   LET l_pmm.pmm04  = l_pmm04
   LET l_pmm.pmm09  = l_pmm09
   LET l_pmm.pmm12  = l_pmm12
   LET l_pmm.pmm42  = l_pmm42
   LET l_pmm.pmm02  = 'SUB'
   LET l_pmm.pmm03  = 0     #FUN-A60095
   LET l_pmm.pmm905 = 'N'  #FUN-A60095
   LET l_pmm.pmm909 = '5'  #TQC-D40094 add
   SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
     INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,
          l_pmm.pmm41
           FROM pmc_file
          WHERE pmc01=l_pmm.pmm09
   SELECT gen03 INTO l_pmm.pmm13 FROM gen_file WHERE gen01= l_pmm.pmm12
   IF l_pmm42=0 OR l_pmm42 IS NULL THEN
      #CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,'S') RETURNING l_pmm.pmm42  #MOD-D30070
      CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,g_sma.sma904) RETURNING l_pmm.pmm42  #MOD-D30070
   END IF
   LET l_pmm.pmm18 ='N'
   LET l_pmm.pmm25 ='0'
   SELECT azn02,azn04 INTO l_pmm.pmm31,l_pmm.pmm32 FROM azn_file
    WHERE azn01 = l_pmm.pmm04
   SELECT gec04 INTO l_pmm.pmm43 FROM gec_file
          WHERE gec01= l_pmm.pmm21 AND gec011='1'
  #SELECT pmm43 INTO l_pmm.pmm43 FROM pmm_file WHERE pmm01=l_pmm.pmm01  #TQC-C20034 mark
   IF SQLCA.SQLCODE THEN 
      LET l_pmm.pmm43=0 
   ELSE 
      IF cl_null(l_pmm.pmm43) THEN
         LET l_pmm.pmm43 =0 
      END IF
   END IF
   LET l_pmm.pmm45 ='N'   #FUN-690047 modify  #'Y'
   LET l_pmm.pmmmksg ='N'
   LET l_pmm.pmmacti ='Y'
   LET l_pmm.pmmuser =g_user
   LET l_pmm.pmmgrup =g_grup
   LET l_pmm.pmmdate =TODAY
   LET l_pmm.pmmcrat =TODAY #FUN-A60095
   LET l_pmm.pmm51='1'      #No.TQC-A50119
   LET l_pmm.pmm53 = ' '    #NO.FUN-960130
   LET l_pmm.pmmpos = 'N'    #NO.FUN-960130
 
   LET l_pmm.pmmplant = g_plant    #FUN-980008 add
   LET l_pmm.pmmlegal = g_legal    #FUN-980008 add
 
   LET l_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
   RETURN l_pmm.*
END FUNCTION

FUNCTION p710sub_pmn(l_pmn01,l_n,l_pmn04,l_pmn012,l_pmn18,l_pmn32,l_pmn41,
                     l_pmn20,l_pmn31,l_pmn31t,l_pmn33,l_pmm13,l_pmm22)     #update 請購單身之已轉採購數量及狀況碼
   DEFINE l_n      LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_ima44  LIKE ima_file.ima44
   DEFINE l_ima906 LIKE ima_file.ima906
   DEFINE l_ima907 LIKE ima_file.ima907
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_factor LIKE ima_file.ima44_fac
   DEFINE l_pmn431 LIKE pmn_file.pmn431 #TQC-750166
   DEFINE l_sgm012 LIKE sgm_file.sgm012 #FUN-A60095
   DEFINE l_pmm13  LIKE pmm_file.pmm13
   DEFINE l_pmm22  LIKE pmm_file.pmm22
   DEFINE l_pmn    RECORD LIKE pmn_file.*
   DEFINE l_flag   LIKE type_file.num5
   DEFINE l_pmn01  LIKE pmn_file.pmn01 
   DEFINE l_pmn04  LIKE pmn_file.pmn04 
   DEFINE l_pmn012 LIKE pmn_file.pmn012
   DEFINE l_pmn18  LIKE pmn_file.pmn18 
   DEFINE l_pmn32  LIKE pmn_file.pmn32 
   DEFINE l_pmn41  LIKE pmn_file.pmn41 
   DEFINE l_pmn20  LIKE pmn_file.pmn20 
   DEFINE l_pmn31  LIKE pmn_file.pmn31 
   DEFINE l_pmn31t LIKE pmn_file.pmn31t
   DEFINE l_pmn33  LIKE pmn_file.pmn33 

   LET l_pmn.pmn01  = l_pmn01 
   LET l_pmn.pmn04  = l_pmn04 
   LET l_pmn.pmn012 = l_pmn012 #FUN-A60095
   LET l_pmn.pmn18  = l_pmn18  #runcard單號
   LET l_pmn.pmn32  = l_pmn32  #runcard製程序
   LET l_pmn.pmn41  = l_pmn41 
   LET l_pmn.pmn20  = l_pmn20 
   LET l_pmn.pmn31  = l_pmn31 
   LET l_pmn.pmn31t = l_pmn31t #No.FUN-550109
   LET l_pmn.pmn33  = l_pmn33  #預計交貨日
   LET l_pmn.pmn011 = 'SUB'
   LET l_pmn.pmn02  = l_n
 
   SELECT ima02,ima25
     INTO l_pmn.pmn041,l_pmn.pmn08
     FROM ima_file WHERE ima01=l_pmn.pmn04
   SELECT sgm58 INTO l_pmn.pmn07 FROM sgm_file  #FUN-A60095
    WHERE sgm01=l_pmn.pmn18 AND sgm03=l_pmn.pmn32
      AND sgm012=l_pmn.pmn012   #FUN-A60095   
   CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08) RETURNING l_flag,l_pmn.pmn09
   IF l_flag = '1' THEN
      #CALL s_errmsg('','',l_pmn.pmn07,'mfg1206',1)          #NO.FUN-710026  #mark by guanyao160912
      CALL s_errmsg('pmn04',l_pmn.pmn04,l_pmn.pmn07,'mfg1206',1)   #add by guanyao160912
      LET g_success='N'
      RETURN l_pmn.*
   END IF
  #FUN-A60095--begin--modify------------- 
  #LET l_pmn431=NULL
  #DECLARE pmn431_c CURSOR FOR 
  #                      SELECT MIN(sgm03) FROM sgm_file 
  #                       WHERE sgm01=g_tmp.sgm01 AND sgm03>g_tmp.sgm03
  #                         AND sgm012=g_tmp_sgm012  #FUN-A60095
  #OPEN pmn431_c
  #FETCH pmn431_c INTO l_pmn431
  #CLOSE pmn431_c
   CALL s_schdat_next_sgm03(l_pmn.pmn18,l_pmn.pmn012,l_pmn.pmn32)
   RETURNING l_sgm012,l_pmn431
  #FUN-A60095--end--modify-----------------
   IF cl_null(l_pmn431) THEN #本製程為最終製程
      LET l_pmn431=l_pmn.pmn32
   END IF
   LET l_pmn.pmn11 ='N'
   LET l_pmn.pmn13 =0
   CALL s_overate(l_pmn.pmn04) RETURNING l_pmn.pmn13  #MOD-7B0090
   LET l_pmn.pmn14 ='Y'
   LET l_pmn.pmn15 ='Y'
   LET l_pmn.pmn16 ='0'
 
   LET l_pmn.pmn34 =l_pmn.pmn33
   LET l_pmn.pmn35 =l_pmn.pmn33
   LET l_pmn.pmn38 ='N'   #FUN-690047 modify  #'Y'
   LET l_pmn.pmn42 ='0'
   LET l_pmn.pmn43 =l_pmn.pmn32 #TQC-750166 #本製程序
   LET l_pmn.pmn431=l_pmn431 #TQC-750166 #下一製程序
   LET l_pmn.pmn46 =0
   LET l_pmn.pmn50 =0
   LET l_pmn.pmn51 =0
   LET l_pmn.pmn53 =0
   LET l_pmn.pmn55 =0
   LET l_pmn.pmn57 =0
   LET l_pmn.pmn61 =l_pmn.pmn04
   LET l_pmn.pmn62 =1
   LET l_pmn.pmn65 ='1'
   LET l_pmn.pmn89 = 'N'  #FUN-A60095
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima25,ima44,ima906,ima907 INTO l_ima25,l_ima44,l_ima906,l_ima907
        FROM ima_file WHERE ima01=l_pmn.pmn04
      IF SQLCA.sqlcode =100 THEN
         IF l_pmn.pmn04 MATCHES 'MISC*' THEN
            SELECT ima25,ima44,ima906,ima907
              INTO l_ima25,l_ima44,l_ima906,l_ima907
              FROM ima_file WHERE ima01='MISC'
         END IF
      END IF
      IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
      LET l_pmn.pmn80=l_pmn.pmn07
      LET l_factor = 1
      CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET l_pmn.pmn81=l_factor
      LET l_pmn.pmn82=l_pmn.pmn20
      LET l_pmn.pmn83=l_ima907
      LET l_factor = 1
      CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn83,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET l_pmn.pmn84=l_factor
      LET l_pmn.pmn85=0
      IF l_ima906 = '3' THEN
         LET l_factor = 1
         CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_pmn.pmn83)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET l_pmn.pmn85=l_pmn.pmn82*l_factor
      END IF
   END IF
   LET l_pmn.pmn86 =l_pmn.pmn07
   LET l_pmn.pmn87 =l_pmn.pmn20
   IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
      SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                     WHERE pml01=l_pmn.pmn24
                                       AND pml02=l_pmn.pmn25
      IF SQLCA.sqlcode THEN
         LET l_pmn.pmn930=NULL
      END IF
   ELSE
      LET l_pmn.pmn930=s_costcenter(l_pmm13)
   END IF
   SELECT azi04 INTO t_azi04 FROM azi_file     #No.
    WHERE azi01 = l_pmm22  AND aziacti= 'Y'  #原幣
   LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn31  * l_pmn.pmn87, t_azi04)
   LET l_pmn.pmn88t= cl_digcut( l_pmn.pmn31t * l_pmn.pmn87, t_azi04) 
   IF cl_null(l_pmn.pmn02) THEN
      LET l_pmn.pmn02 = 0
   END IF
   LET l_pmn.pmn73 = ' '           #NO.FUN-960130
   LET l_pmn.pmnplant = g_plant    #FUN-980008 add
   LET l_pmn.pmnlegal = g_legal    #FUN-980008 add
   IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF #TQC-9B0203
   IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012 = ' ' END IF    #FUN-A60076 
   IF cl_null(l_pmn.pmn63) THEN LET l_pmn.pmn63 = 'N' END IF #TQC-AB0390
   IF cl_null(l_pmn.pmn64) THEN LET l_pmn.pmn64 = 'N' END IF #TQC-AB0390
   SELECT sfb96 INTO l_pmn.pmn100 FROM sfb_file WHERE sfb01 = l_pmn.pmn41  #FUN-D40042 add 
   RETURN l_pmn.*
END FUNCTION
 
