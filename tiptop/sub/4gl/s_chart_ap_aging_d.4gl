# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_ap_aging_d.4gl
# Descriptions...: 查詢一廠商的應付帳齡
# Date & Author..: No.FUN-BA0095 2011/12/1 By chenwei  
# Input Parameter: p_value1 combo值1 廠商 
#                  p_value2 combo值2 NULL
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_ap_aging_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_ap_aging_d(p_value1,p_value2,p_loc)
DEFINE p_value1    LIKE img_file.img01
DEFINE p_value2    LIKE type_file.num5
DEFINE p_loc       LIKE type_file.chr10
DEFINE l_chk_auth  STRING
DEFINE l_sql       STRING
DEFINE tm  RECORD
       wc      LIKE type_file.chr1000,
       detail  LIKE type_file.chr1,       
       edate   LIKE type_file.dat
           END RECORD
DEFINE l_pmc       RECORD
             pmc01 LIKE pmc_file.pmc01,
             pmc02 LIKE pmc_file.pmc02
                   END RECORD
DEFINE l_apa       RECORD
             apa00 LIKE apa_file.apa00,
             apa01 LIKE apa_file.apa01,
             apa02 LIKE apa_file.apa02,
             apa06 LIKE apa_file.apa06,
             apa08 LIKE apa_file.apa08,
             apa21 LIKE apa_file.apa21,
             apa34 LIKE apa_file.apa34,
             apa35 LIKE apa_file.apa35,
             apa41 LIKE apa_file.apa41,
             apa42 LIKE apa_file.apa42,
             apa74 LIKE apa_file.apa74
                   END RECORD
DEFINE l_apc       RECORD
             apc02 LIKE apc_file.apc02,
             apc04 LIKE apc_file.apc04,
             apc09 LIKE apc_file.apc09,
             apc11 LIKE apc_file.apc11,
             apc15 LIKE apc_file.apc15,
             apg01 LIKE apg_file.apg01,
             apg04 LIKE apg_file.apg04,
             apf01 LIKE apf_file.apf01,
             apf02 LIKE apf_file.apf02,
             apf41 LIKE apf_file.apf41,
             aph04 LIKE aph_file.aph04,
             apc01 LIKE apc_file.apc01
                   END RECORD
DEFINE  sr         RECORD
             apa01     LIKE apa_file.apa01,
             apa02     LIKE apa_file.apa02,
             num1      LIKE type_file.num20_6
                   END RECORD
        
DEFINE l_lb        STRING
DEFINE l_sub_str   STRING
DEFINE l_gdk01     LIKE gdk_file.gdk01
DEFINE l_gdk02     LIKE gdk_file.gdk02
DEFINE l_gdk03     LIKE gdk_file.gdk03
DEFINE l_apc02     LIKE apc_file.apc02

DEFINE l_apa00     LIKE apa_file.apa00
DEFINE l_apc04     LIKE apc_file.apc04
DEFINE l_amt       LIKE apg_file.apg05
DEFINE amt1,amt2   LIKE apg_file.apg05
DEFINE l_apg05     LIKE apg_file.apg05
DEFINE l_aph05     LIKE aph_file.aph05
DEFINE l_month     LIKE type_file.num5
DEFINE l_day       LIKE type_file.num5
DEFINE l_flag      LIKE type_file.num5
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_ima02     LIKE ima_file.ima02

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_ap_aging_d",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限

   DROP TABLE l_temp
   CREATE TEMP TABLE l_temp(
   flag  LIKE type_file.chr1,
   amt   LIKE apg_file.apg05)
   
   IF g_apz.apz27 = 'N' THEN
      LET l_sql="SELECT apa01,apa02, ",
                "       apc09-apc11-apc15,apa00,apc02,apc04", 
                "  FROM apc_file,apa_file ", 
                " WHERE apa01 = apc01 ",   
                "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)", 
                "   AND apa00 MATCHES '1*' AND apa41='Y' ",   
                "   AND apa02 <= '",g_today,"' ANd apa42='N' AND apa74='N'",
                "   AND (apc09>apc11+apc15 OR",   
                "        apa01 IN (SELECT apg04 FROM apf_file,apg_file",
                "              WHERE apf01=apg01 AND apf41 <> 'X' ",
                "                AND apf02 > '",g_today,"'))"
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND apa06 = '",p_value1 CLIPPED,"' " END IF
      LET l_sql = l_sql CLIPPED," UNION ",
                  "SELECT apa01,apa02, ",
                  "       apc09-apc11-apc15,apa00,apc02,apc04",
                  "  FROM apc_file,apa_file ",   
                  " WHERE apa01 = apc01 ",    
                  "   AND (apa00 = '21' OR apa00 = '22') AND apa41='Y' ",    
                  "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)",    
                  "   AND apa02 <= '",g_today,"' ANd apa42='N' AND apa74='N'",
                  "   AND ((apc09 > apc11+apc15)  OR",     
                  "        apa01 IN (SELECT aph04 FROM apf_file,aph_file",   
                  "              WHERE apf01=aph01 AND apf41 <> 'X' ",   
                  "                AND apf02 > '",g_today,"'))"
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND apa06 = '",p_value1 CLIPPED,"' " END IF

   ELSE
      LET l_sql="SELECT apa01,apa02, ",
                "       apc13,apa00,apc02,apc04",    
                "  FROM apc_file,apa_file ",
                " WHERE apa01 = apc01 ",  
                "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)",  
                "   AND apa00 MATCHES '1*' AND apa41='Y' ",   
                "   AND apa02 <= '",g_today,"' ANd apa42='N' AND apa74='N'",
                "   AND (apc13 > 0  OR",      
                "        apa01 IN (SELECT apg04 FROM apf_file,apg_file",
                "              WHERE apf01=apg01 AND apf41 <> 'X' ",
                "                AND apf02 > '",g_today,"'))"
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND apa06 = '",p_value1 CLIPPED,"' " END IF
      LET l_sql = l_sql CLIPPED," UNION ",
                  "SELECT apa01,apa02, ",
                  "       apc13,apa00,apc02,apc04",
                  "  FROM apc_file,apa_file ",
                  " WHERE apa01 = apc01 ", 
                  "   AND (apa00 = '21' OR apa00 = '22') AND apa41='Y' ",    
                  "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)",     
                  "   AND apa02 <= '",g_today,"' ANd apa42='N' AND apa74='N'",
                  "   AND (apc13 > 0 OR",    
                  "        apa01 IN (SELECT aph04 FROM apf_file,aph_file",   
                  "              WHERE apf01=aph01 AND apf41 <> 'X' ",   
                  "                AND apf02 > '",g_today,"'))"
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND apa06 = '",p_value1 CLIPPED,"' " END IF
   END IF
 
   PREPARE sel_apa_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      RETURN 
   END IF
   DECLARE sel_apa_cs CURSOR FOR sel_apa_pre
   FOREACH sel_apa_cs INTO sr.*,l_apa00,l_apc02,l_apc04
      IF STATUS THEN
         CALL cl_err('Foreach:',STATUS,1)
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
        #EXIT PROGRAM
         RETURN
      END IF

      LET amt1=0 LET amt2=0
      SELECT SUM(apg05) INTO amt1
        FROM apf_file, apg_file
       WHERE apg04=sr.apa01 AND apg01=apf01 AND apf41='Y'
         AND apg06 = l_apc02   
         AND apf02 > g_today

      IF amt1 IS NULL THEN LET amt1=0 END IF
      SELECT SUM(aph05) INTO amt2                                                                                                 
        FROM apf_file, aph_file                                                                                                  
       WHERE aph04=sr.apa01 AND aph01=apf01 AND apf41='Y'                                                                         
         AND aph17 = l_apc02                                                                                  
         AND apf02 > g_today                                                                                                     
      IF amt2 IS NULL THEN LET amt2=0 END IF   
      LET amt1=sr.num1+amt1+amt2 LET sr.num1=0                                                                                    
      IF l_apa00 MATCHES "2*" THEN              
         LET amt1 = amt1 * -1
      END IF

      LET l_month = YEAR(g_today)*12 + MONTH(g_today) - (YEAR(sr.apa02)*12 + MONTH(sr.apa02)) + 1   
      LET l_day = l_month*30
      IF 0 < l_day AND l_day <= 30 THEN
         INSERT INTO l_temp(flag,amt) VALUES('1',amt1)
      END IF            
      IF 30 < l_day AND l_day <= 60 THEN
         INSERT INTO l_temp(flag,amt) VALUES('2',amt1)
      END IF
      IF 60 < l_day AND l_day <= 90 THEN
         INSERT INTO l_temp(flag,amt) VALUES('3',amt1)
      END IF
      IF 90 < l_day AND l_day <= 120 THEN
         INSERT INTO l_temp(flag,amt) VALUES('4',amt1)
      END IF            
      IF 120 < l_day AND l_day <= 150 THEN
         INSERT INTO l_temp(flag,amt) VALUES('5',amt1)
      END IF            
      IF 150 < l_day AND l_day <= 180 THEN
         INSERT INTO l_temp(flag,amt) VALUES('6',amt1)
      END IF
      IF 180 < l_day THEN
         INSERT INTO l_temp(flag,amt) VALUES('7',amt1)
      END IF
      INSERT INTO l_temp(flag,amt) VALUES('1',0)
      INSERT INTO l_temp(flag,amt) VALUES('2',0)
      INSERT INTO l_temp(flag,amt) VALUES('3',0)
      INSERT INTO l_temp(flag,amt) VALUES('4',0)
      INSERT INTO l_temp(flag,amt) VALUES('5',0)
      INSERT INTO l_temp(flag,amt) VALUES('6',0)
      INSERT INTO l_temp(flag,amt) VALUES('7',0)
   END FOREACH

   LET l_sql = "SELECT flag,SUM(amt) FROM l_temp GROUP BY flag ORDER BY flag"
   PREPARE sel_tmp_pre FROM l_sql
   DECLARE sel_tmp_cs CURSOR FOR sel_tmp_pre
   FOREACH sel_tmp_cs INTO l_flag,l_amt
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF 
      CASE l_flag
          WHEN '1'
             LET l_lb = '0-30'
          WHEN '2'
             LET l_lb = '30-60'
          WHEN '3'
             LET l_lb = '61-90'
          WHEN '4'
             LET l_lb = '91-120'
          WHEN '5'
             LET l_lb = '121-150'
          WHEN '6'
             LET l_lb = '151-180'
          WHEN '7'
             LET l_lb = '181-'
      END CASE 
      CALL cl_chart_array_data(p_loc,"categories","",l_lb)
      CALL cl_chart_array_data(p_loc,"dataset"," ",l_amt)
   END FOREACH        

   INITIALIZE l_sub_str TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_ap_aging_d"
   IF NOT cl_null(p_value1) THEN    
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_pmc03,")"
   END IF
   IF NOT cl_null(p_value1) OR NOT cl_null(p_value2) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_ap_aging_d")
   CALL cl_chart_clear(p_loc)                          

END FUNCTION

#FUNCTION s_chart_ap_aging_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_ap_aging_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk01       LIKE gdk_file.gdk01
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_sql         STRING
DEFINE l_apa06       LIKE apa_file.apa06
DEFINE l_pmc03       LIKE pmc_file.pmc03
DEFINE l_pmc01       LIKE pmc_file.pmc01
DEFINE l_apa41       LIKE apa_file.apa41
DEFINE l_apa42       LIKE apa_file.apa42
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_ap_aging_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT apa06,pmc03 ",
                  "  FROM apa_file,pmc_file ",
                  " WHERE apa06 = pmc01 ",
                  "   AND apa34 > apa35 ",
                  "   AND apa41 = 'Y' ",
                  "   AND apa42 = 'N' ",
                  " ORDER BY apa06 "
      PREPARE sel_combo_pre1 FROM l_sql
      DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
      FOREACH sel_combo_cs1 INTO l_apa06,l_pmc03
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_apa06
            LET l_combo_item  = l_combo_item,",",l_apa06 CLIPPED,"(",l_pmc03 CLIPPED,")"
         ELSE
            LET l_combo_value = l_apa06
            LET l_combo_item = l_apa06 CLIPPED,"(",l_pmc03 CLIPPED,")"
         END IF
      END FOREACH
      CALL cl_set_combo_items(l_combo,l_combo_value,l_combo_item)
      IF l_combo_value.getIndexof(",",1)=0 THEN
         LET l_def_filter1 = l_combo_value
      ELSE
         LET l_def_filter1 = l_combo_value.subString(1,l_combo_value.getIndexof(",",1)-1)
      END IF
   ELSE
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,FALSE)
   END IF

      LET l_combo = p_cboloc CLIPPED,"_2"
      CALL cl_set_comp_visible(l_combo,FALSE)

   RETURN l_def_filter1,l_def_filter2
END FUNCTION

#FUN-BA0095
