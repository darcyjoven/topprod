# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_ar_aging_d.4gl
# Descriptions...: 查詢一客户的應收帳齡
# Date & Author..: No.FUN-BA0095 2011/12/1 By chenwei
# Input Parameter: p_value1 combo值1 客戶
#                  p_value2 combo值2 NULL
#                  p_loc    圖表位置
# Usage..........: CALL s_chart_ar_aging_d(p_value1,p_value2,p_loc)
# Modify.........: No:TQC-C20485 2012/02/27 By baogc 修改Combo填充邏輯

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_ar_aging_d(p_value1,p_value2,p_loc)
DEFINE p_value1      LIKE img_file.img01
DEFINE p_value2      LIKE img_file.img09
DEFINE p_loc         LIKE type_file.chr10
DEFINE l_oma       RECORD
             oma03   LIKE oma_file.oma03,
             oma56t  LIKE oma_file.oma56t,
             oma57   LIKE oma_file.oma57,
             omaconf LIKE oma_file.omaconf
                   END RECORD
DEFINE l_sql         STRING                          
DEFINE amt1,amt2     LIKE type_file.num20_6         
DEFINE l_za05        LIKE type_file.chr1000         
DEFINE l_oma00       LIKE oma_file.oma00
DEFINE l_omavoid     LIKE oma_file.omavoid
DEFINE l_omaconf     LIKE oma_file.omaconf
DEFINE l_oma52       LIKE oma_file.oma52             
DEFINE l_oma53       LIKE oma_file.oma53
DEFINE l_oma54t      LIKE oma_file.oma54t
DEFINE l_oma55       LIKE oma_file.oma55
DEFINE l_oma56t      LIKE oma_file.oma56t
DEFINE l_oma57       LIKE oma_file.oma57
DEFINE l_oma_osum    LIKE oma_file.oma57
DEFINE l_oma_lsum    LIKE oma_file.oma57
DEFINE l_bucket      LIKE type_file.num5
DEFINE    sr         RECORD
            oma14    LIKE oma_file.oma14,     
            gen02    LIKE gen_file.gen02,      
            oma15    LIKE oma_file.oma15,     
            occ03    LIKE occ_file.occ03,     
            oca02    LIKE oca_file.oca02,     
            oma03    LIKE oma_file.oma03,     
            oma032   LIKE oma_file.oma032,   
            oma02    LIKE oma_file.oma02,      
            oma01    LIKE oma_file.oma01,
            num1     LIKE type_file.num20_6,    
            num2     LIKE type_file.num20_6,   
            num3     LIKE type_file.num20_6,  
            num4     LIKE type_file.num20_6,   
            num5     LIKE type_file.num20_6,   
            num6     LIKE type_file.num20_6,   
            num7     LIKE type_file.num20_6,  
            tot      LIKE type_file.num20_6,   
            azi03    LIKE azi_file.azi03,
            azi04    LIKE azi_file.azi04,
            azi05    LIKE azi_file.azi05
                     END RECORD
DEFINE l_i           LIKE type_file.num5                
DEFINE l_dbs         LIKE azp_file.azp03                 
DEFINE l_azp03       LIKE azp_file.azp03                 
DEFINE l_occ37       LIKE occ_file.occ37                 
DEFINE i             LIKE type_file.num5                                    
DEFINE l_oma16       LIKE oma_file.oma16   
DEFINE l_occ01       LIKE occ_file.occ01
DEFINE l_occ02       LIKE occ_file.occ02                   
DEFINE l_lb          STRING
DEFINE l_sub_str     STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
DEFINE l_month       LIKE type_file.num5
DEFINE l_day         LIKE type_file.num5
DEFINE l_apc04       LIKE apc_file.apc04
DEFINE l_flag        LIKE type_file.num5
DEFINE l_amt         LIKE apg_file.apg05

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc)

   IF NOT s_chart_auth("s_chart_ar_aging_d",g_user) THEN RETURN END IF
   
   DROP TABLE l_temp
   CREATE TEMP TABLE l_temp(
   flag  LIKE type_file.chr1,
   amt   LIKE apg_file.apg05)
   
   IF g_ooz.ooz07 = 'N' THEN
      LET l_sql="SELECT oma14, gen02, oma15, occ03, oca02,",
                "       oma03, oma032,oma02, oma01,",
                "       oma56t-oma57,0,0,0,0,0,0,0,0,0,0,oma00,", 
                "       occ37,oma16",                           
                " FROM  oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 , occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01 ",
                " WHERE  oma03=occ01 ",                                  
               #"   AND ",tm.wc CLIPPED,
                "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",g_today,"'",
                "   AND (oma56t>oma57 OR",
                "        oma01 IN (SELECT oob06 FROM ooa_file ,oob_file ",
                "                   WHERE ooa01=oob01  AND ooaconf !='X' ",
                "                     AND ooa37 = '1'",                     
                "                     AND ooa02 > '",g_today,"' ) OR ",    
                "        oma16 IN (SELECT oma19 FROM oma_file ",
                "                   WHERE omaconf='Y' AND omavoid='N'", 
                "                     AND (oma00='12' OR oma00='13')",   
                "                     AND oma02 >'",g_today,"' )",      
                "       ) "
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND oma03 = '",p_value1 CLIPPED,"' " END IF
     #IF tm.e = "Y" THEN
      LET l_sql = l_sql CLIPPED," UNION ",
                  "SELECT oma14, gen02, oma15, occ03, oca02,",
                  "       oma03, oma032,oma02, oma01,",
                  "       oma56t-oma57,0,0,0,0,0,0,0,0,0,0,oma00,",   
                  "       occ37,oma16",                             
                  " FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01,occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01 ",
                  " WHERE  oma03=occ01 ",                                 
                 #"   AND ",tm.wc CLIPPED,
                  "   AND oma00 MATCHES '2*' AND omaconf='Y' AND omavoid='N'",
                  "   AND oma02 <= '",g_today,"'",
                  "   AND (oma56t-oma57 >0     OR",
                  "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",
                  "                   WHERE ooa01=oob01  AND ooaconf !='X' ",
                  "                     AND ooa37 = '1'",                                
                  "                     AND ooa02 > '",g_today,"' ) OR ",      
                  "        oma16 IN (SELECT oma19 FROM oma_file ", 
                  "                   WHERE omaconf='Y' AND omavoid='N'",  
                  "                     AND (oma00='12' OR oma00='13')", 
                  "                     AND oma02 >'",g_today,"' )",      
                  "       ) "
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND oma03 = '",p_value1 CLIPPED,"' " END IF
     #END IF
   ELSE
      LET l_sql="SELECT oma14, gen02, oma15, occ03, oca02,",
                "       oma03, oma032,oma02, oma01,",
                "       oma61,0,0,0,0,0,0,0,0,0,0,oma00,",          
                "       occ37,oma16",                             
                " FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01, occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01",
                " WHERE  oma03=occ01 ",                                 
               #"   AND ",tm.wc CLIPPED,
                "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",g_today,"'",
                "   AND (oma61 >0     OR",
                "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",
                "                   WHERE ooa01=oob01  AND ooaconf !='X' ",
                "                     AND ooa37 = '1'",                         
                "                     AND ooa02 > '",g_today,"' ) OR ", 
                "        oma16 IN (SELECT oma19 FROM oma_file ", 
                "                   WHERE omaconf='Y' AND omavoid='N'",  
                "                     AND (oma00='12' OR oma00='13')",  
                "                     AND oma02 >'",g_today,"' )",     
                "     ) "
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND oma03 = '",p_value1 CLIPPED,"' " END IF
     #IF tm.e = "Y" THEN
      LET l_sql = l_sql CLIPPED," UNION ",
                  "SELECT oma14, gen02, oma15, occ03, oca02,",
                  "       oma03, oma032,oma02, oma01,",
                  "       oma61,0,0,0,0,0,0,0,0,0,0,oma00,", 
                  "       occ37,oma16",                     
                  " FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01,occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01",
                  " WHERE  oma03=occ01 ",                 
                 #"   AND ",tm.wc CLIPPED,
                  "   AND oma00 MATCHES '2*' AND omaconf='Y' AND omavoid='N'",
                  "   AND oma02 <= '",g_today,"'",
                  "   AND (oma61 >0     OR",
                  "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",
                  "                   WHERE ooa01=oob01  AND ooaconf !='X' ",
                  "                     AND ooa37 = '1'",            
                  "                     AND ooa02 > '",g_today,"' ) OR ", 
                  "        oma16 IN (SELECT oma19 FROM oma_file ",
                  "                   WHERE omaconf='Y' AND omavoid='N'",  
                  "                     AND (oma00='12' OR oma00='13')",   
                  "                     AND oma02 >'",g_today,"' )",      
                  "     ) "
      IF NOT cl_null(p_value1) THEN LET l_sql = l_sql CLIPPED," AND oma03 = '",p_value1 CLIPPED,"' " END IF
     #END IF
   END IF
   PREPARE sel_oma_pre FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     #EXIT PROGRAM 
      RETURN
   END IF
   DECLARE sel_oma_cs CURSOR FOR sel_oma_pre
   FOREACH sel_oma_cs INTO sr.*,l_oma00,l_occ37,l_oma16
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
      IF l_oma00 MATCHES '1*' THEN 
         LET amt1=0 LET amt2=0
         LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",                                                                              
                     "  FROM oob_file,ooa_file",
                     " WHERE oob06='",sr.oma01,"'",
                     "   AND oob03='2' AND oob04='1' AND ooaconf='Y'",
                     "   AND ooa37 = '1'",            
                     "   AND ooa01=oob01 AND ooa02 > '",g_today,"'"                                                                                                                                                                                   
         PREPARE oob_prepare3 FROM l_sql                                                                                          
         DECLARE oob_c3  CURSOR FOR oob_prepare3                                                                                 
         OPEN oob_c3                                                                                    
         FETCH oob_c3 INTO amt1,amt2
         IF amt1 IS NULL THEN LET amt1=0 END IF
         IF amt2 IS NULL THEN LET amt2=0 END IF
      ELSE
         LET amt1=0 LET amt2=0
         LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",                                                                              
                     "  FROM oob_file,ooa_file",
                     " WHERE oob06='",sr.oma01,"'",
                     "   AND oob03='1' AND oob04='3' AND ooaconf='Y'",
                     "   AND ooa37 = '1'",            
                     "   AND ooa01=oob01 AND ooa02 > '",g_today,"'"                                                                                                                                                                                   
         PREPARE oob_prepare1 FROM l_sql                                                                                          
         EXECUTE oob_prepare1 INTO amt1,amt2
         IF amt1 IS NULL THEN LET amt1=0 END IF
         IF amt2 IS NULL THEN LET amt2=0 END IF

         IF l_oma00 = '23' THEN
            LET sr.num1 = 0
            LET l_sql = "SELECT oma54t,oma55,oma56t,oma57 ",
                        "  FROM oma_file",
                        " WHERE oma01='",sr.oma01,"'"
            PREPARE oma_prepare1 FROM l_sql
            EXECUTE oma_prepare1 INTO l_oma54t,l_oma55,l_oma56t,l_oma57
            IF cl_null(l_oma54t) THEN LET l_oma54t=0 END IF
            IF cl_null(l_oma55)  THEN LET l_oma55 =0 END IF
            IF cl_null(l_oma56t) THEN LET l_oma56t=0 END IF
            IF cl_null(l_oma57)  THEN LET l_oma57 =0 END IF

            LET l_sql = "SELECT SUM(oma52)+SUM(oma54)+SUM(oma54x),SUM(oma53)+SUM(oma56)+SUM(oma56x) ",
                        "  FROM oma_file",
                        " WHERE oma19='",l_oma16,"'",
                        "   AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N'",
                        "   AND oma02<='",g_today,"'"
            PREPARE oma_prepare2 FROM l_sql
            EXECUTE oma_prepare2 INTO l_oma_osum,l_oma_lsum
            IF cl_null(l_oma_osum) THEN LET l_oma_osum=0 END IF
            IF cl_null(l_oma_lsum) THEN LET l_oma_lsum=0 END IF

            #當原幣合計金額等於原幣已沖合計金額,就讓本幣合計金額等於本幣已沖金額
            IF l_oma_osum=l_oma55 THEN LET l_oma_lsum=l_oma57 END IF

            #未沖金額 = 應收 - 已收
            LET l_oma52 = l_oma54t - l_oma_osum
            LET l_oma53 = l_oma56t - l_oma_lsum
            IF l_oma54t=l_oma55 THEN
               LET l_oma53=l_oma57-l_oma_lsum
            END IF
            IF cl_null(l_oma52) THEN LET l_oma52=0 END IF
            IF cl_null(l_oma53) THEN LET l_oma53=0 END IF

            LET amt2=amt2+l_oma53
         END IF

         LET amt2=sr.num1+amt2 
         LET sr.num1=0
         LET amt2=amt2*-1
      END IF
      LET amt2=sr.num1+amt2 LET sr.num1=0
 
      LET l_day = 0
      LET l_month = YEAR(g_today)*12 + MONTH(g_today) -(YEAR(sr.oma02)*12 +MONTH(sr.oma02))+1
      LET l_day = l_month*30
      IF 0 < l_day AND l_day <= 30 THEN
         INSERT INTO l_temp(flag,amt) VALUES('1',amt2)
      END IF
      IF 30 < l_day AND l_day <= 60 THEN
         INSERT INTO l_temp(flag,amt) VALUES('2',amt2)
      END IF
      IF 60 < l_day AND l_day <= 90 THEN
         INSERT INTO l_temp(flag,amt) VALUES('3',amt2)
      END IF
      IF 90 < l_day AND l_day <= 120 THEN
         INSERT INTO l_temp(flag,amt) VALUES('4',amt2)
      END IF
      IF 120 < l_day AND l_day <= 150 THEN
         INSERT INTO l_temp(flag,amt) VALUES('5',amt2)
      END IF
      IF 150 < l_day AND l_day <= 180 THEN
         INSERT INTO l_temp(flag,amt) VALUES('6',amt2)
      END IF
      IF 180 < l_day THEN
         INSERT INTO l_temp(flag,amt) VALUES('7',amt2)
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
   DECLARE sel_tmp_cs  CURSOR FOR sel_tmp_pre
   FOREACH sel_tmp_cs  INTO l_flag,l_amt
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF 
      CASE l_flag
         WHEN '1'
            LET l_lb = '0-30'
         WHEN '2'
            LET l_lb = '31-60'
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
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_ar_aging_d"
   IF NOT cl_null(p_value1) THEN    
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = p_value1
      LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk02,g_lang),":",p_value1,"(",l_occ02,")"
   END IF
   IF NOT cl_null(p_value2) THEN
      IF NOT cl_null(l_sub_str) THEN 
         LET l_sub_str = l_sub_str,"(",cl_getmsg(l_gdk03,g_lang),":",p_value2,")"
      ELSE
         LET l_sub_str = cl_getmsg('azz-181',g_lang),"--",cl_getmsg(l_gdk03,g_lang),":",p_value2
      END IF
   END IF
   IF NOT cl_null(p_value1)  THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_sub_str) 
   END IF
   CALL cl_chart_create(p_loc,"s_chart_ar_aging_d")
   CALL cl_chart_clear(p_loc)                         

END FUNCTION

#FUNCTION s_chart_ar_aging_set_combo(p_cboloc)                            #TQC-C20485 Mark
FUNCTION s_chart_ar_aging_set_combo(p_cboloc,p_def_filter1,p_def_filter2) #TQC-C20485 Add
DEFINE p_cboloc      LIKE type_file.chr10
DEFINE l_def_filter1 STRING
DEFINE l_def_filter2 STRING
DEFINE l_combo       LIKE type_file.chr12
DEFINE l_combo_value STRING
DEFINE l_combo_item  STRING
DEFINE l_gdk02       LIKE gdk_file.gdk02
DEFINE l_gdk03       LIKE gdk_file.gdk03
#DEFINE l_sql         STRING
DEFINE l_oma03       LIKE oma_file.oma03
DEFINE l_occ02       LIKE occ_file.occ02
DEFINE l_occ01       LIKE occ_file.occ01
DEFINE l_oma56t      LIKE oma_file.oma56
DEFINE l_oma57       LIKE oma_file.oma57
DEFINE l_omaconf     LIKE oma_file.omaconf
DEFINE l_img01       LIKE img_file.img01
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_sql         STRING
DEFINE p_def_filter1 STRING #TQC-C20485 Add
DEFINE p_def_filter2 STRING #TQC-C20485 Add

  #TQC-C20485 Add Begin ---
   #若傳入值中第一個Combo項不為空，則不需要重新填充Combo
   IF NOT cl_null(p_def_filter1) THEN RETURN p_def_filter1,p_def_filter2 END IF
  #TQC-C20485 Add End -----

   INITIALIZE l_def_filter1,l_def_filter2 TO NULL
   SELECT gdk02,gdk03 INTO l_gdk02,l_gdk03 FROM gdk_file WHERE gdk01 = "s_chart_ar_aging_d"
   IF NOT cl_null(l_gdk02) THEN
      INITIALIZE l_combo_value,l_combo_item TO NULL
      LET l_combo = p_cboloc CLIPPED,"_1"
      CALL cl_set_comp_visible(l_combo,TRUE)
      LET l_sql = "SELECT DISTINCT oma03,occ02 ",
                  "  FROM oma_file,occ_file ",
                  " WHERE oma03 = occ01 ",
                  "   AND oma56t > oma57 ",
                  "   AND omaconf = 'Y' ",
                  " ORDER BY oma03 "
      PREPARE sel_combo_pre1 FROM l_sql
      DECLARE sel_combo_cs1 CURSOR FOR sel_combo_pre1
      FOREACH sel_combo_cs1 INTO l_img01,l_ima02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_combo_value) THEN
            LET l_combo_value = l_combo_value,",",l_img01
            LET l_combo_item  = l_combo_item,",",l_img01 CLIPPED,"(",l_ima02 CLIPPED,")"
         ELSE
            LET l_combo_value = l_img01
            LET l_combo_item = l_img01 CLIPPED,"(",l_ima02 CLIPPED,")"
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
