# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_abmi710_carry.4gl
# Descriptions...: ECN基本資料拋轉
# Date & Author..: 08/03/06 By xiaofeizhu FUN-820027
# Input PARAMETER: p_bmx 拋轉單身LIST
#                  p_azp    拋轉至DB 清單
#                  p_gev04  資料中心代碼
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting 拋轉成功才發郵件通知
# Modify.........: NO.MOD-840427 08/04/21 BY xiaofeizhu 下載的檔案文件名有誤
# Modify.........: NO.MOD-840418 08/04/21 BY xiaofeizhu 拋轉過去的單據確認碼應該為'N',增加單號+項次的檢查
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980001 09/08/11 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-9A0182 09/11/06 By Pengu ECN做替代變更時無法做資料拋轉
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No.FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A10110 10/11/24 By sabrina 調整check BOM資料的SQL條件
# Modify.........: No.TQC-AB0256 10/11/29 By vealxu -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.SQLCODE)
# Modify.........: No.TQC-AC0179 10/12/15 By vealxu abmp700執行拋轉會出現 "DS2:upd字元轉換至數值失敗
# Modify.........: No.TQC-AC0161 10/12/15 By jan 調整SQL寫法
# Modify.........: No:MOD-B10177 11/01/24 By sabrina EXECUTE db_cs2_bmw資料有錯，少了一個變數
# Modify.........: No:FUN-AC0060 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----str-----
# Modify.........: No:FUN-A80036 10/08/09 By Carrier 資料拋轉時,使用的中間表變成動態表名
# Modify.........: No:FUN-AC0060 10/12/20 By Mandy PLM-資料中心功能
# Modify.........: No:FUN-B20003 11/02/10 By Mandy PLM-調整
# Modify.........: No:FUN-AC0060 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----end-----
# Modify.........: No:FUN-B70076 11/07/21 By Mandy PLM-資料中心拋轉異常
# Modify.........: No:CHI-C20060 12/09/18 By bart 類別增加替代變更，變更替代量，替代只能打替代量，回寫abmi604

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bmx_1    DYNAMIC ARRAY OF RECORD                                                                                   
                   sel      LIKE type_file.chr1,                                                                             
                   bmx01    LIKE bmx_file.bmx01                                                                              
                  END RECORD              
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_msg_s      LIKE type_file.chr1000
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg3     LIKE type_file.chr1000
DEFINE g_msg4     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE #g_sql_s      LIKE type_file.chr1000
       g_sql_s       STRING      #NO.FUN-910082
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_dbs_sep  LIKE type_file.chr50
DEFINE g_bmx      RECORD LIKE bmx_file.*
DEFINE g_bmz      RECORD LIKE bmz_file.*
DEFINE g_bmy      RECORD LIKE bmy_file.*
DEFINE g_bmw      RECORD LIKE bmw_file.*
DEFINE g_bmf      RECORD LIKE bmf_file.*
DEFINE g_bmg      RECORD LIKE bmg_file.*
DEFINE g_sql      STRING
DEFINE g_all_cnt  LIKE type_file.num10    #總共要拋轉的筆數                                                                         
DEFINE g_cur_cnt  LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_flagx    LIKE type_file.chr1
DEFINE g_plant_sep LIKE azp_file.azp01    #FUN-A50102 
FUNCTION s_abmi710_carry_bmx(p_bmx_p,p_azp,p_gev04,p_flagx)
   DEFINE p_bmx_p             DYNAMIC ARRAY OF RECORD 
                               sel      LIKE type_file.chr1,
                               bmx01    LIKE bmx_file.bmx01
                              END RECORD             
   DEFINE p_azp               DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               azp01    LIKE azp_file.azp01,
                               azp02    LIKE azp_file.azp02,
                               azp03    LIKE azp_file.azp03
                              END RECORD                              
   DEFINE p_gev04              LIKE gev_file.gev04
   DEFINE p_flagx              LIKE type_file.chr1
   DEFINE p_wc2                STRING      #NO.FUN-910082
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_j                  LIKE type_file.num10
   
   DEFINE l_str1               STRING
   DEFINE l_str2               STRING
   DEFINE l_str3               STRING
   DEFINE l_str4               STRING
   DEFINE l_str1_bmz           STRING
   DEFINE l_str2_bmz           STRING
   DEFINE l_str3_bmz           STRING
   DEFINE l_str4_bmz           STRING
   DEFINE l_str1_bmy           STRING
   DEFINE l_str2_bmy           STRING
   DEFINE l_str3_bmy           STRING
   DEFINE l_str4_bmy           STRING
   DEFINE l_str1_bmw           STRING
   DEFINE l_str2_bmw           STRING
   DEFINE l_str3_bmw           STRING
   DEFINE l_str4_bmw           STRING
   DEFINE l_str1_bmf           STRING
   DEFINE l_str2_bmf           STRING
   DEFINE l_str3_bmf           STRING
   DEFINE l_str4_bmf           STRING
   DEFINE l_str1_bmg           STRING
   DEFINE l_str2_bmg           STRING
   DEFINE l_str3_bmg           STRING
   DEFINE l_str4_bmg           STRING
      
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_dbs_sep_tra        LIKE type_file.chr50  #FUN-980094 add
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_tabname            LIKE type_file.chr50
   DEFINE l_bmx01_old          LIKE bmx_file.bmx01
   DEFINE l_bmx01              LIKE bmx_file.bmx01
   DEFINE l_bmf01              LIKE bmf_file.bmf01
   DEFINE l_gez04              LIKE gez_file.gez04
   DEFINE l_gez05              LIKE gez_file.gez05
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail                                                                    
   DEFINE l_hist_tab           LIKE type_file.chr50    #for mail                                                                    
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail                                                                    
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_bmx_upd            LIKE type_file.chr1     #NO.FUN-840033 add
   DEFINE l_legal              LIKE bmx_file.bmxlegal  
   DEFINE l_plant_bak          LIKE azp_file.azp01     #FUN-AC0060 add
   DEFINE l_dbs                LIKE type_file.chr20    #FUN-AC0060 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_flagx = p_flagx
 
   IF g_flagx <> '1' THEN 
      IF p_bmx_p.getLength() = 0 THEN RETURN END IF
   END IF
 
   IF p_azp.getLength()   = 0 THEN RETURN END IF
   
   CALL g_bmx_1.clear()
 
   #前置准備
   FOR l_i = 1 TO p_bmx_p.getLength()
       LET g_bmx_1[l_i].* = p_bmx_p[l_i].*
   END FOR
   FOR l_i = 1 TO p_azp.getLength()
       LET g_azp[l_i].* = p_azp[l_i].*
   END FOR
   LET g_gev04 = p_gev04
   LET g_db_type=cl_db_get_database_type()
 
   #定義cursor
   CALL s_carry_p_cs()
    #default aooi602中設置的預設值
   LET g_sql = " SELECT gez04,gez05 FROM gez_file ",
               "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
               "    AND gez02 = '3'",
               "    AND gez03 = ?  "
   PREPARE gez_p FROM g_sql
   DECLARE gez_cur CURSOR WITH HOLD FOR gez_p
   #組column
   CALL s_carry_col('bmx_file') RETURNING l_str1,l_str2,l_str3
   CALL s_carry_col('bmz_file') RETURNING l_str1_bmz,l_str2_bmz,l_str3_bmz
   CALL s_carry_col('bmy_file') RETURNING l_str1_bmy,l_str2_bmy,l_str3_bmy
   CALL s_carry_col('bmf_file') RETURNING l_str1_bmf,l_str2_bmf,l_str3_bmf
   CALL s_carry_col('bmg_file') RETURNING l_str1_bmg,l_str2_bmg,l_str3_bmg
   CALL s_carry_col('bmw_file') RETURNING l_str1_bmw,l_str2_bmw,l_str3_bmw
   #組index
   CALL s_carry_idx('bmx_file') RETURNING l_str4
   CALL s_carry_idx('bmz_file') RETURNING l_str4_bmz
   CALL s_carry_idx('bmy_file') RETURNING l_str4_bmy
   CALL s_carry_idx('bmf_file') RETURNING l_str4_bmf
   CALL s_carry_idx('bmg_file') RETURNING l_str4_bmg
   CALL s_carry_idx('bmw_file') RETURNING l_str4_bmw
   
   #建立臨時表,用于存放拋轉的資料
   CALL s_abmi710_carry_p1() RETURNING l_tabname
   
   IF g_all_cnt = 0 THEN                                                                                                     
      CALL cl_err('','aap-129',1)                                                                                            
      RETURN                                                                                                                 
   END IF
 
   IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if判斷
       #建立歷史資料拋轉的臨時表                                                                                                        
       CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
   #FUN-AC0060---add----str---
   ELSE
       LET l_hist_tab = g_dc_hist_tab
   END IF
   #FUN-AC0060---add----end---
   
   #bmx對應bmz_file拋轉的cursor定義
   IF g_flagx <> '1' THEN                                         
      LET g_sql = " SELECT * FROM bmz_file ",                                      
                  "  WHERE bmz01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM bmz_file_bak1 ",                                                                                       
                  "  WHERE bmz01 = ? "
   END IF
   PREPARE bmz_p FROM g_sql                                                     
   DECLARE bmz_cur CURSOR WITH HOLD FOR bmz_p
   
    #bmx對應bmy_file拋轉的cursor定義    
   IF g_flagx <> '1' THEN                                     
      LET g_sql = " SELECT * FROM bmy_file ",                                      
                  "  WHERE bmy01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM bmy_file_bak1 ",                                                                                       
                  "  WHERE bmy01 = ? "
   END IF
   PREPARE bmy_p FROM g_sql                                                     
   DECLARE bmy_cur CURSOR WITH HOLD FOR bmy_p
   
    #bmx對應bmw_file拋轉的cursor定義           
   IF g_flagx <> '1' THEN                              
      LET g_sql = " SELECT * FROM bmw_file ",                                      
                  "  WHERE bmw01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM bmw_file_bak1 ",                                                                                       
                  "  WHERE bmw01 = ? "
   END IF
   PREPARE bmw_p FROM g_sql                                                     
   DECLARE bmw_cur CURSOR WITH HOLD FOR bmw_p
   
    #bmx對應bmf_file拋轉的cursor定義           
   IF g_flagx <> '1' THEN                              
      LET g_sql = " SELECT * FROM bmf_file ",                                      
                  "  WHERE bmf01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM bmf_file_bak1 ",                                                                                       
                  "  WHERE bmf01 = ? "
   END IF
   PREPARE bmf_p FROM g_sql                                                     
   DECLARE bmf_cur CURSOR WITH HOLD FOR bmf_p
   
    #bmx對應bmg_file拋轉的cursor定義  
   IF g_flagx <> '1' THEN                                       
      LET g_sql = " SELECT * FROM bmg_file ",                                      
                  "  WHERE bmg01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM bmg_file_bak1 ",                                                                                       
                  "  WHERE bmg01 = ? "
   END IF
   PREPARE bmg_p FROM g_sql                                                     
   DECLARE bmg_cur CURSOR WITH HOLD FOR bmg_p
   LET l_plant_bak = g_plant #FUN-AC0060 add
   FOR l_j = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
       
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '3'
          AND gew04 = g_azp[l_j].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
      #IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if判斷 #FUN-B70076 mark
           #mail_1                                                                                                                      
           CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'3',l_hist_tab)                                                     
                RETURNING l_hs_flag,l_hs_path
      #END IF #FUN-AC0060 add #FUN-B70076 mark
 
       CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
       LET g_dbs_sep = l_dbs_sep                                                        #MOD-840418
       LET g_plant_sep = g_azp[l_j].azp01   #FUN-A50102 
       LET g_plant_new = g_azp[l_j].azp01
       CALL s_gettrandbs()
       LET l_dbs_sep_tra = g_dbs_tra
       
      #LET g_sql = "INSERT INTO ",l_dbs_sep_tra CLIPPED,"bmx_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmx_file'),   #FUN-A50102 
                  " VALUES(",l_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE db_cs1 FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep_tra CLIPPED,"bmx_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmx_file'),  #FUN-A50102 
                   "   SET ",l_str3,
                   " WHERE ",l_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
       PREPARE db_cs2 FROM g_sql
 
      #LET g_sql = "INSERT INTO ",l_dbs_sep_tra CLIPPED,"bmz_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmz_file'),  #FUN-A50102
                   " VALUES(",l_str2_bmz,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE db_cs1_bmz FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep_tra CLIPPED,"bmz_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmz_file'),  #FUN-A50102
                   "   SET ",l_str3_bmz,
                   " WHERE ",l_str4_bmz
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
       PREPARE db_cs2_bmz FROM g_sql
      
      #LET g_sql = "INSERT INTO ",l_dbs_sep_tra CLIPPED,"bmy_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmy_file'),  #FUN-A50102
                   " VALUES(",l_str2_bmy,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE db_cs1_bmy FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep_tra CLIPPED,"bmy_file", #FUN-980094 add   #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmy_file'),   #FUN-A50102
                   "   SET ",l_str3_bmy,
                   " WHERE ",l_str4_bmy
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
       PREPARE db_cs2_bmy FROM g_sql
       
      #LET g_sql = "INSERT INTO ",l_dbs_sep_tra CLIPPED,"bmg_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmg_file'),  #FUN-A50102
                   " VALUES(",l_str2_bmg,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_bmg FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep_tra CLIPPED,"bmg_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmg_file'),  #FUN-A50102 
                   "   SET ",l_str3_bmg,
                   " WHERE ",l_str4_bmg
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
       PREPARE db_cs2_bmg FROM g_sql
       
      #LET g_sql = "INSERT INTO ",l_dbs_sep_tra CLIPPED,"bmw_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmw_file'),  #FUN-A50102
                   " VALUES(",l_str2_bmw,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE db_cs1_bmw FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep_tra CLIPPED,"bmw_file", #FUN-980094 add   #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmw_file'),   #FUN-A50102
                   "   SET ",l_str3_bmw,
                   " WHERE ",l_str4_bmw
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
       PREPARE db_cs2_bmw FROM g_sql
       
      #LET g_sql = "INSERT INTO ",l_dbs_sep_tra CLIPPED,"bmf_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmf_file'),  #FUN-A50102
                   " VALUES(",l_str2_bmf,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_bmf FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep_tra CLIPPED,"bmf_file", #FUN-980094 add  #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmf_file'),  #FUN-A50102
                   "   SET ",l_str3_bmf,
                   " WHERE ",l_str4_bmf
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
       PREPARE db_cs2_bmf FROM g_sql
       
       #default aooi602中設置的預設值
      LET l_bmf01 = NULL                                                                                                            
      FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05                                                                   
         IF SQLCA.sqlcode THEN                                                                                                      
            CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)                                                       
            CONTINUE FOREACH                                                                                                        
         END IF                                                                                                                     
         IF l_gez04 = 'bmf01'  THEN LET l_bmf01  = l_gez05 END IF                                                                   
      END FOREACH      
 
        #定義拋轉的SQL
       LET g_sql = " SELECT * FROM ",l_tabname CLIPPED,
                   "  WHERE ",l_gew05 CLIPPED
       PREPARE carry_p1 FROM g_sql
       DECLARE carry_cur1 CURSOR WITH HOLD FOR carry_p1
 
       #當前營運中心,滿足aooi602拋轉條件的筆數                                                                                      
       LET g_cur_cnt = 0                                                                                                            
       LET g_sql = " SELECT COUNT(*) FROM ",l_tabname CLIPPED,                                                                      
                   "  WHERE ",l_gew05 CLIPPED                                                                                       
       PREPARE cnt_p1 FROM g_sql                                                                                                    
       EXECUTE cnt_p1 INTO g_cur_cnt                                                                                                
       IF cl_null(g_cur_cnt) THEN LET g_cur_cnt = 0 END IF                                                                          
       IF g_all_cnt <> g_cur_cnt THEN   #aooi602中有設置,部分資料不滿足拋轉                                                         
          LET g_showmsg = g_azp[l_j].azp01,"/",g_all_cnt USING "<<<<&","/",g_cur_cnt USING "<<<<&"                                  
          CALL s_errmsg("azp01,all_cnt,cur_cnt",g_showmsg,"cnt_p1","aoo-049",1)                                                     
       END IF
 
       FOREACH carry_cur1 INTO g_bmx.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('bmx01',g_bmx.bmx01,'foreach',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
 
         IF g_bmx.bmx04 <> 'Y' AND l_j = 1 THEN  #僅報一次錯誤                                                                    
            LET g_showmsg = g_plant,":",g_bmx.bmx01                                                                                 
            CALL s_errmsg('azp01,bmx01',g_showmsg,'bmx04','aoo-092',3)                                                            
            CONTINUE FOREACH                                                                                                        
         END IF
 
         LET g_success = 'Y'
         LET l_bmx_upd = 'N'   #NO.FUN-840033 add
         IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if 判斷
             BEGIN WORK
         END IF                         #FUN-AC0060 add
         LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_bmx.bmx01,':'
         LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_bmx.bmx01,':'
 
         LET l_bmx01_old = g_bmx.bmx01
         LET g_bmx.bmx04 = 'N'                                                  #MOD-840418
         LET g_bmx.bmx09 = '0'                                                  #MOD-840418
         IF NOT cl_null(l_bmx01) THEN LET g_bmx.bmx01 = l_bmx01 END IF
   
         #bmx11,bmx12
         LET g_bmx.bmx11 = g_plant
         LET g_bmx.bmx12 = 1
    
         CALL s_getlegal(g_azp[l_j].azp01) RETURNING l_legal  
         LET g_bmx.bmxlegal = l_legal 
         LET g_bmx.bmxplant = g_azp[l_j].azp01 
          EXECUTE db_cs1 USING g_bmx.*
           IF SQLCA.sqlcode = 0 THEN
              MESSAGE g_msg1,':ok'
              LET l_bmx_upd = 'Y'   #NO.FUN-840033 add
              CALL ui.Interface.refresh()
           ELSE
           #IF SQLCA.sqlcode = -239 THEN      #TQC-AB0256
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-AB0256                                                                    
               IF l_gew07 = 'N' THEN                                                                               
                  MESSAGE g_msg1,':exist'                                                                          
                  LET l_bmx_upd = 'N'     #no.FUN-840033 add
                  CALL ui.Interface.refresh()                                                                     
               ELSE
                 LET g_sql = "SELECT bmx12 FROM ",
                            #l_dbs_sep_tra CLIPPED,"bmx_file ", #FUN-980094 add   #FUN-A50102
                             cl_get_target_table(g_azp[l_j].azp01,'bmx_file'),  #FUN-A50102
                             " WHERE bmx01='",l_bmx01_old CLIPPED,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
                 CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-980094
                 PREPARE bmx_p1 FROM g_sql
                 EXECUTE bmx_p1 INTO g_bmx.bmx12
                 IF cl_null(g_bmx.bmx12) THEN LET g_bmx.bmx12 = 0 END IF
                 LET g_bmx.bmx12 = g_bmx.bmx12 + 1
 
                 EXECUTE db_cs2 USING g_bmx.*,l_bmx01_old
                 IF SQLCA.sqlcode = 0 THEN
                    MESSAGE g_msg2,':ok'
                    LET l_bmx_upd = 'Y'   #no.FUN-840033 add
                    CALL ui.Interface.refresh()
                 ELSE
                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                    CALL s_errmsg('bmx01',g_bmx.bmx01,g_msg_x,SQLCA.sqlcode,1)
                    MESSAGE g_msg2,':fail'
                    LET l_bmx_upd = 'N'  #NO.FUN-840033 add
                    CALL ui.Interface.refresh()
                    LET g_success = 'N'
                 END IF
                END IF
              ELSE
                 LET g_msg_x = g_azp[l_j].azp01,':ins'
                 CALL s_errmsg('bmx01',g_bmx.bmx01,g_msg_x,SQLCA.sqlcode,1)
                 MESSAGE g_msg1,':fail'
                 CALL ui.Interface.refresh()
                 LET g_success = 'N'
                 LET l_bmx_upd = 'N'   #NO.FUN-840033 add
              END IF
           END IF
         IF SQLCA.sqlerrd[3] > 0 THEN
            CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_bmx.bmx01,'3')
            CALL s_abmi710_bmy(l_bmx01_old,l_bmx01,g_azp[l_j].azp01,l_gew07,g_bmx.bmx06)     #MOD-840418 add g_bmx.bmx06
            CALL s_abmi710_bmz(l_bmx01_old,l_bmx01,g_azp[l_j].azp01,l_gew07,g_bmx.bmx06)     #MOD-840418 add g_bmx.bmx06    
            CALL s_abmi710_bmw(l_bmx01_old,l_bmx01,g_azp[l_j].azp01,l_gew07)
            CALL s_abmi710_bmf(l_bmx01_old,l_bmx01,g_azp[l_j].azp01,l_gew07)
            CALL s_abmi710_bmg(l_bmx01_old,l_bmx01,g_azp[l_j].azp01,l_gew07)
         END IF
         IF g_success = 'N' THEN
            LET l_bmx_upd = 'N'   #NO.FUN-840033 add
            IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if 判斷
                ROLLBACK WORK
            END IF                         #FUN-AC0060 add
         ELSE
            LET l_bmx_upd = 'Y'   #NO.FUN-840033 add
            IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if 判斷
                COMMIT WORK
            END IF                         #FUN-AC0060 add
         END IF     
         
       END FOREACH
       #FUN-AC0060---add---str---
       IF g_prog = 'aws_ttsrv2' THEN
           IF g_success = 'Y' THEN
               LET g_plant = g_azp[l_j].azp01
               CALL i720sub_y_chk(g_bmx.bmx01)                                
           END IF
           IF g_success = "Y" THEN
               CALL i720sub_y_upd(g_bmx.bmx01,'N')                     
           END IF
       END IF
       #FUN-AC0060---add---end---
       LET g_plant = l_plant_bak #FUN-AC0060 add
 
       IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if判斷
           #mail 2                                                                                                                      
           IF l_bmx_upd = 'Y' THEN   #NO.FUN-840033 add
               CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
           END IF                    #NO.FUN-840033 add
       END IF #FUN-AC0060 add
   
   END FOR 
   
   IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0060 add if判斷
       CALL s_dc_drop_temp_table(l_tabname)
       CALL s_dc_drop_temp_table(l_hist_tab)
   #FUN-AC0060--add---str--
   ELSE
       CALL s_dc_del_tmp(l_tabname)
       CALL s_dc_del_tmp(l_hist_tab)
   END IF
   #FUN-AC0060--add---end--
    #MESSAGE 'Data Carry Finish!'    #TQC-AC0161
    IF g_success = 'Y' THEN CALL cl_err('','aim-162',0) END IF #TQC-AC0161
    CALL ui.Interface.refresh()
END FUNCTION
 
FUNCTION s_abmi710_bmz(p_bmx01_old,p_bmx01_new,p_azp01,p_gew07,p_bmx06_old)
   DEFINE p_bmx01_old     LIKE bmx_file.bmx01
   DEFINE p_bmx01_new     LIKE bmx_file.bmx01
   DEFINE p_bmx06_old     LIKE bmx_file.bmx06
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_legal         LIKE bmx_file.bmxlegal
 
   FOREACH bmz_cur USING p_bmx01_old INTO g_bmz.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmz01',g_bmz.bmz01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bmx01_new) THEN LET g_bmz.bmz01 = p_bmx01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmz.bmz01,'+',g_bmz.bmz02,'+',g_bmz.bmz05,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmz.bmz01,'+',g_bmz.bmz02,'+',g_bmz.bmz05,':'
 
      #check item exist or not ?                                                                                                 
      IF NOT s_abmi710_carry_chk_bmz(g_bmz.bmz01,g_bmz.bmz02,p_bmx06_old,'bmz_file') THEN                                                    
         LET g_success = 'N'                                                                                                     
      END IF           
 
      CALL s_getlegal(p_azp01) RETURNING l_legal  
      LET g_bmz.bmzlegal = l_legal 
      LET g_bmz.bmzplant = p_azp01
 
      EXECUTE db_cs1_bmz USING g_bmz.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
       # IF SQLCA.sqlcode = -239 THEN      #TQC-AB0256
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-AB0256                                                                                            
            IF p_gew07 = 'N' THEN                                                                                                   
               MESSAGE g_msg3,':exist'                                                                                              
               CALL ui.Interface.refresh()
            ELSE 
          # EXECUTE db_cs2_bmz USING g_bmz.*,p_bmx01_old,g_bmz.bmz02,g_bmz.bmz05    #TQC-AC0179 mark
            EXECUTE db_cs2_bmz USING g_bmz.*,p_bmx01_old,g_bmz.bmz02,g_bmz.bmz05,g_bmz.bmz011,g_bmz.bmz012,g_bmz.bmz013    #TQC-AC0179
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_bmz.bmz01,'/',g_bmz.bmz02,'/',g_bmz.bmz05
               CALL s_errmsg('bmz01,bmz02,bmz05',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
           END IF 
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmz.bmz01,'/',g_bmz.bmz02,'/',g_bmz.bmz05
            CALL s_errmsg('bmz01,bmz02,bmz05',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF SQLCA.sqlerrd[3] > 0 THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmz.bmz01||'+'||g_bmz.bmz02||'+'||g_bmz.bmz05,'3')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi710_bmy(p_bmx01_old,p_bmx01_new,p_azp01,p_gew07,p_bmx06_old)
   DEFINE p_bmx01_old     LIKE bmx_file.bmx01
   DEFINE p_bmx01_new     LIKE bmx_file.bmx01
   DEFINE p_bmx06_old     LIKE bmx_file.bmx06
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_legal         LIKE bmx_file.bmxlegal 
 
   FOREACH bmy_cur USING p_bmx01_old INTO g_bmy.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmy01',g_bmy.bmy01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bmx01_new) THEN LET g_bmy.bmy01 = p_bmx01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmy.bmy01,'+',g_bmy.bmy02,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmy.bmy01,'+',g_bmy.bmy02,':'
 
      #check item exist or not ?                                                                                                    
      IF NOT s_abmi710_carry_chk_bmy(g_bmy.bmy01,g_bmy.bmy02,g_bmy.bmy04,g_bmy.bmy03,g_bmy.bmy05,g_bmy.bmy14,p_bmx06_old,'bmy_file') THEN           #MOD-A10110 add bmy02                                            
         LET g_success = 'N'                                                                                                        
      END IF    
 
      CALL s_getlegal(p_azp01) RETURNING l_legal  
      LET g_bmy.bmylegal = l_legal 
      LET g_bmy.bmyplant = p_azp01
      EXECUTE db_cs1_bmy USING g_bmy.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #IF SQLCA.sqlcode = -239 THEN  #TQC-AB0256
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-AB0256                                                                                             
            IF p_gew07 = 'N' THEN                                                                                                   
               MESSAGE g_msg3,':exist'                                                                                              
               CALL ui.Interface.refresh()                                                                                          
            ELSE
            EXECUTE db_cs2_bmy USING g_bmy.*,p_bmx01_old,g_bmy.bmy02  
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_bmy.bmy01,'/',g_bmy.bmy02
               CALL s_errmsg('bmy01,bmy02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
           END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmy.bmy01,'/',g_bmy.bmy02
            CALL s_errmsg('bmy01,bmy02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF SQLCA.sqlerrd[3] > 0 THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmy.bmy01||'+'||g_bmy.bmy02,'3')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi710_bmw(p_bmx01_old,p_bmx01_new,p_azp01,p_gew07)
   DEFINE p_bmx01_old     LIKE bmx_file.bmx01
   DEFINE p_bmx01_new     LIKE bmx_file.bmx01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_legal         LIKE bmx_file.bmxlegal
 
   FOREACH bmw_cur USING p_bmx01_old INTO g_bmw.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmw01',g_bmw.bmw01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bmx01_new) THEN LET g_bmw.bmw01 = p_bmx01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmw.bmw01,'+',g_bmw.bmw02,'+',g_bmw.bmw03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmw.bmw01,'+',g_bmw.bmw02,'+',g_bmw.bmw03,':'
 
      CALL s_getlegal(p_azp01) RETURNING l_legal  
      LET g_bmw.bmwlegal = l_legal 
      LET g_bmw.bmwplant = p_azp01
 
      EXECUTE db_cs1_bmw USING g_bmw.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
       # IF SQLCA.sqlcode = -239 THEN       #TQC-AB02546
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-AB02546 
            IF p_gew07 = 'N' THEN                                                                                                   
               MESSAGE g_msg3,':exist'                                                                                              
               CALL ui.Interface.refresh()                                                                                          
            ELSE
           #EXECUTE db_cs2_bmw USING g_bmw.*,p_bmx01_old,g_bmw.bmw02 #,g_bmw.bmw03     #MOD-B10177 mark
            EXECUTE db_cs2_bmw USING g_bmw.*,p_bmx01_old,g_bmw.bmw02,g_bmw.bmw03       #MOD-B10177 add
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_bmw.bmw01,'/',g_bmw.bmw02,'/',g_bmw.bmw03
               CALL s_errmsg('bmw01,bmw02,bmw03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
           END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmw.bmw01,'/',g_bmw.bmw02,'/',g_bmw.bmw03
            CALL s_errmsg('bmw01,bmw02,bmw03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF SQLCA.sqlerrd[3] > 0 THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmw.bmw01||'+'||g_bmw.bmw02,'3')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi710_bmf(p_bmx01_old,p_bmx01_new,p_azp01,p_gew07)
   DEFINE p_bmx01_old     LIKE bmx_file.bmx01
   DEFINE p_bmx01_new     LIKE bmx_file.bmx01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_legal         LIKE bmx_file.bmxlegal 
 
   FOREACH bmf_cur USING p_bmx01_old INTO g_bmf.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmf01',g_bmf.bmf01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bmx01_new) THEN LET g_bmf.bmf01 = p_bmx01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmf.bmf01,'+',g_bmf.bmf02,'+',g_bmf.bmf03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmf.bmf01,'+',g_bmf.bmf02,'+',g_bmf.bmf03,':'
 
      CALL s_getlegal(p_azp01) RETURNING l_legal  
      LET g_bmf.bmflegal = l_legal 
      LET g_bmf.bmfplant = p_azp01
 
      EXECUTE db_cs1_bmf USING g_bmf.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
       # IF p_gew07 = 'Y' AND SQLCA.sqlcode = -239 THEN    #TQC-AB0256
         IF p_gew07 = 'Y' AND cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-AB0256
            EXECUTE db_cs2_bmf USING g_bmf.*,p_bmx01_old,g_bmf.bmf02,g_bmf.bmf03
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_bmf.bmf01,'/',g_bmf.bmf02,'/',g_bmf.bmf03
               CALL s_errmsg('bmf01,bmf02,bmf06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmf.bmf01,'/',g_bmf.bmf02,'/',g_bmf.bmf03
            CALL s_errmsg('bmf01,bmf02,bmf06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF SQLCA.sqlerrd[3] > 0 THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmf.bmf01||'+'||g_bmf.bmf02||'+'||g_bmf.bmf03,'3')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi710_bmg(p_bmx01_old,p_bmx01_new,p_azp01,p_gew07)
   DEFINE p_bmx01_old     LIKE bmx_file.bmx01
   DEFINE p_bmx01_new     LIKE bmx_file.bmx01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_legal         LIKE bmx_file.bmxlegal 
 
   FOREACH bmg_cur USING p_bmx01_old INTO g_bmg.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmg01',g_bmg.bmg01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bmx01_new) THEN LET g_bmg.bmg01 = p_bmx01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmg.bmg01,'+',g_bmg.bmg02,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmg.bmg01,'+',g_bmg.bmg02,':'
 
      CALL s_getlegal(p_azp01) RETURNING l_legal  
      LET g_bmg.bmglegal = l_legal 
      LET g_bmg.bmgplant = p_azp01
 
      EXECUTE db_cs1_bmg USING g_bmg.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
       # IF p_gew07 = 'Y' AND SQLCA.sqlcode = -239 THEN      #TQC-AB0256
         IF p_gew07 = 'Y' AND cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-AB0256
            EXECUTE db_cs2_bmg USING g_bmg.*,p_bmx01_old,g_bmg.bmg02 
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_bmg.bmg01,'/',g_bmg.bmg02
               CALL s_errmsg('bmg01,bmg02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmg.bmg01,'/',g_bmg.bmg02
            CALL s_errmsg('bmg01,bmg02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF SQLCA.sqlerrd[3] > 0 THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmg.bmg01||'+'||g_bmg.bmg02,'3')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION abmi710_carry_send_mail() 
 
 DEFINE l_i         LIKE type_file.num5
 DEFINE l_j         LIKE type_file.num5
 DEFINE l_gew08     LIKE gew_file.gew08
 DEFINE l_tempdir   LIKE type_file.chr20
 DEFINE lc_channel base.Channel
 DEFINE l_str       LIKE type_file.chr1000
 DEFINE l_cmd       LIKE type_file.chr1000
 
   FOR l_i = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_i].azp01) THEN CONTINUE FOR END IF
       IF g_azp[l_i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew08 INTO l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '3'
          AND gew04 = g_azp[l_i].azp01
       IF SQLCA.sqlcode OR cl_null(l_gew08) THEN
          CONTINUE FOR
       END IF
       MESSAGE "Sending Mail:",l_gew08 CLIPPED
       CALL ui.Interface.refresh()
       INITIALIZE g_xml.* TO NULL
       LET l_tempdir = FGL_GETENV('TEMPDIR')
       LET g_msg_s = g_prog CLIPPED,' ',g_today
       #Subject
       CALL cl_getmsg('aoo-037',g_lang) RETURNING g_msg1
       LET g_xml.subject = g_msg_s CLIPPED,' ',g_msg1
 
       #抓相關應通知人員email
       LET g_xml.recipient =  l_gew08
 
       IF cl_null(g_xml.recipient) THEN
          CONTINUE FOR
       END IF
 
       # 產生文本檔
       LET g_msg_s = g_prog CLIPPED,'-',g_azp[l_i].azp01,'-',l_i USING "<<<<<",'.htm'    #FUN-9B0113
       LET g_msg_s = os.Path.join(l_tempdir CLIPPED, g_msg_s CLIPPED)
 
       LET lc_channel = base.Channel.create()
       CALL lc_channel.openFile(g_msg_s,"w")
       CALL lc_channel.setDelimiter("")
 
       LET l_str = "<html>"
       CALL lc_channel.write(l_str)
       LET l_str = "<head>"
       CALL lc_channel.write(l_str)
 
       LET l_str = "<title>",g_xml.subject CLIPPED,"</title>"
       CALL lc_channel.write(l_str)
       LET l_str = "</head>"
       CALL lc_channel.write(l_str)
       LET l_str = "<body>"
       CALL lc_channel.write(l_str)
 
       #本文
       LET l_str = 'Dear ALL:',"<br>"
       CALL lc_channel.write(l_str)
 
       LET l_str = ' ',"<br>"
       CALL lc_channel.write(l_str)
 
       LET l_str = g_plant CLIPPED,' ',cl_getmsg('aoo-038',g_lang)
       LET l_str = l_str CLIPPED,"<br>"
       CALL lc_channel.write(l_str)
 
       LET l_str = "</body>"
       CALL lc_channel.write(l_str)
       LET l_str = "</html>"
       CALL lc_channel.write(l_str)
       CALL lc_channel.close()
 
       LET g_xml.body = g_prog CLIPPED,'-',g_azp[l_i].azp01,'-',l_i USING "<<<<<",'.htm'   #FUN-9B0113
       LET g_xml.body = os.Path.join(l_tempdir CLIPPED, g_xml.body CLIPPED)
 
       #抓附件
       LET g_xml.attach=''

       LET l_cmd = g_prog CLIPPED,".txt"
       LET l_cmd = os.Path.join(l_tempdir CLIPPED, l_cmd CLIPPED)

       IF os.Path.delete(l_cmd CLIPPED) THEN
       END IF
       CALL cl_null_cat_to_file(l_cmd CLIPPED)                  #FUN-9B0113

       LET l_cmd = "echo 'Logestic\tProgram ID\tCarry Date\t",
                   "Carry Person' >>",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
       RUN l_cmd
       FOR l_j = 1 TO g_bmx_1.getlength()
           IF cl_null(g_bmx_1[l_j].bmx01) THEN
              CONTINUE FOR
           END IF
           IF g_bmx_1[l_j].sel = 'N' THEN
              CONTINUE FOR
           END IF
           LET l_cmd = "echo ",g_azp[l_i].azp01 CLIPPED," \t",
                       g_today," \t",
                       g_user," >>",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
           RUN l_cmd
       END FOR

       LET g_xml.attach = g_prog CLIPPED,'.txt'
       LET g_xml.attach = os.Path.join(l_tempdir CLIPPED,g_xml.attach CLIPPED)
 
       DISPLAY g_xml.subject
       DISPLAY "Mail 收件人清單：" , g_xml.recipient
       CALL cl_jmail()
 
       IF os.Path.delete(g_xml.attach CLIPPED) THEN            #FUN-9B0113
       END IF
 
   END FOR
 
END FUNCTION
 
FUNCTION s_abmi710_download(p_bmx)                                                                                  
   DEFINE p_bmx   DYNAMIC ARRAY OF RECORD                                                                               
                   sel      LIKE type_file.chr1,                                                                         
                   bmx01    LIKE bmx_file.bmx01                                                                          
                  END RECORD                                                                                            
    DEFINE l_path           LIKE ze_file.ze03                                                                                     
    DEFINE l_i              LIKE type_file.num10                                                                                  
                                                                                                                               
     FOR l_i = 1 TO p_bmx.getLength()                                                                                        
          LET g_bmx_1[l_i].* = p_bmx[l_i].*                                                                                   
     END FOR                                                                                                                 
 
    CALL s_dc_download_path() RETURNING l_path                                                                              
    CALL s_abmi710_download_files(p_bmx,l_path)                                                                              
 
END FUNCTION
 
FUNCTION s_abmi710_download_files(pp_bmx,p_path)
  DEFINE pp_bmx   DYNAMIC ARRAY OF RECORD                                                                               
                   sel      LIKE type_file.chr1,                                                                         
                   bmx01    LIKE bmx_file.bmx01                                                                          
                  END RECORD
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_tempdir         LIKE type_file.chr50
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5 
  DEFINE l_bmg01           LIKE bmg_file.bmg01
  DEFINE l_tabname         LIKE type_file.chr50
 
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
    END IF
   IF l_n <0 OR l_n = 0 THEN
      RETURN
   END IF
 
   LET l_tempdir    = fgl_getenv('TEMPDIR')
   
   #建立臨時表,用于存放拋轉的資料
   CALL s_abmi710_carry_p1() RETURNING l_tabname   
   
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_bmx_file_3.txt'             #MOD-840427
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_bmx_file_3.txt"              #MOD-840427
   
   LET g_sql = "SELECT * FROM ",l_tabname
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED                                                                                          
   RUN g_sql
   ######################bmz_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_bmz_file_3.txt'              #MOD-840427
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_bmz_file_3.txt"               #MOD-840427
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM bmz_file WHERE ",
               "   bmz01 IN (SELECT bmx01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
  ######################bmy_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_bmy_file_3.txt'                #MOD-840427
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_bmy_file_3.txt"                 #MOD-840427
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM bmy_file WHERE ",
               "   bmy01 IN (SELECT bmx01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
    ######################bmw_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_bmw_file_3.txt'                 #MOD-840427
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_bmw_file_3.txt"                  #MOD-840427
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM bmw_file WHERE ",
               "   bmw01 IN (SELECT bmx01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
    ######################bmf_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_bmf_file_3.txt'                   #MOD-840427
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_bmf_file_3.txt"                    #MOD-840427
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM bmf_file WHERE ",
               "   bmf01 IN (SELECT bmx01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
    ######################bmg_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_bmg_file_3.txt'                   #MOD-840427
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_bmg_file_3.txt"                    #MOD-840427
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM bmg_file WHERE ", 
               "  bmg01 IN (SELECT bmx01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
END FUNCTION   
 
FUNCTION s_abmi710_carry_p1() 
   DEFINE l_i                  LIKE type_file.num10
  #DEFINE l_tabname            LIKE type_file.chr50      #No.FUN-A80036 mark
   DEFINE l_tabname            STRING                    #No.FUN-A80036
   DEFINE l_str                STRING                    #No.FUN-A80036
   
  #FUN-AC0060---mark---str---
  #CALL s_dc_cre_temp_table("bmx_file") RETURNING l_tabname
  #FUN-AC0060---mark---end---
  #FUN-AC0060---add----str---
   IF g_prog <> 'aws_ttsrv2' THEN 
       CALL s_dc_cre_temp_table("bmx_file") RETURNING l_tabname
   ELSE
      #LET l_tabname = g_dc_tabname     #FUN-B20003 mark
       LET l_tabname = g_dc_tabname_bmx #FUN-B20003 add
   END IF
  #FUN-AC0060---add----end---
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX bmx_file_bak_01 ON ",l_tabname CLIPPED,"(bmx01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(bmx01)"
   #No.FUN-A80036  --End  
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM bmx_file",
                                                 "  WHERE bmx01 = ?"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0
 
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_bmx_1.getLength()
          IF cl_null(g_bmx_1[l_i].bmx01) THEN
             CONTINUE FOR
          END IF
          IF g_bmx_1[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          EXECUTE ins_pp USING g_bmx_1[l_i].bmx01
          IF SQLCA.sqlcode THEN
             LET l_str = 'ins ',l_tabname CLIPPED   #No.FUN-A80036
            #FUN-AC0060 mod---str---
            #CALL cl_err(l_str,SQLCA.sqlcode,1)     #No.FUN-A80036
             IF g_bgerr OR g_prog = 'aws_ttsrv2' THEN       
                CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  
             ELSE
                CALL cl_err(l_str,SQLCA.sqlcode,1)          
             END IF
            #FUN-AC0060 mod---end---
             CONTINUE FOR
          END IF
          LET g_all_cnt = g_all_cnt + 1
      END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM bmx_file_bak1"                                          
      PREPARE ins_ppx FROM g_sql                                                                                            
      EXECUTE ins_ppx                                                                                                       
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname                                                                        
      PREPARE cnt_ppx FROM g_sql                                                                                            
      EXECUTE cnt_ppx INTO g_all_cnt                                                                                        
      IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF                                                                   
    END IF
 
   RETURN l_tabname
END FUNCTION  
 
FUNCTION s_abmi710_carry_chk_bmy(p_bmy01,p_bmy02,p_bmy04,p_bmy03,p_bmy05,p_bmy14,p_bmx06,p_tabname)  #MOD-A10110 add bmy02                                                                               
   DEFINE p_bmy01        LIKE bmy_file.bmy01
   DEFINE p_bmy02        LIKE bmy_file.bmy02   #No:MOD-A10110 add
   DEFINE p_bmy04        LIKE bmy_file.bmy04
   DEFINE p_bmy03        LIKE bmy_file.bmy03                                                                                        
   DEFINE p_bmy05        LIKE bmy_file.bmy05
   DEFINE p_bmy14        LIKE bmy_file.bmy14
   DEFINE p_bmx06        LIKE bmx_file.bmx06
   DEFINE p_tabname      LIKE type_file.chr50                                                                                       
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_cnt1         LIKE type_file.num5 
   DEFINE l_bmz02        LIKE bmz_file.bmz02
   DEFINE l_bmy05        LIKE bmy_file.bmy05
   DEFINE l_bmy27        LIKE bmy_file.bmy27
 
   LET g_sql = " SELECT bmz02 from bmz_file,bmy_file ",  #TQC-AC0161
               "  WHERE bmz01 = '",p_bmy01,"'",
               "    AND bmz01 = bmy01 ", #TQC-AC0161
               "    AND bmy02 = '",p_bmy02,"'"     #No:MOD-A10110 add 
   PREPARE bmz_chk_p1 FROM g_sql
   DECLARE bmz_chk_cur1 CURSOR WITH HOLD FOR bmz_chk_p1
 
   LET g_sql = " SELECT bmy05,bmy27 from bmy_file ",                                                                               
               "  WHERE bmy01 = '",p_bmy01,"'",
               "    AND bmy02 = ",p_bmy02  #CHI-C20060                  
   PREPARE bmy_chk_p1 FROM g_sql                                                                                             
   DECLARE bmy_chk_cur1 CURSOR WITH HOLD FOR bmy_chk_p1
 
  IF cl_null(p_bmy03) THEN LET p_bmy03 = 0 END IF
 
   CASE 
   WHEN p_bmy03 = '1' OR p_bmy03 = '3' OR p_bmy03 = 0 
    IF p_bmx06 = '1' THEN                         #多主件(abmi710)                                                                        
       IF cl_null(p_bmy01) THEN                                                                                                         
          RETURN TRUE                                                                                                                   
       END IF                                                                                                                           
                                                                                                                                    
       LET l_cnt = 0                                                                                                                    
 
       FOREACH bmz_chk_cur1 INTO l_bmz02                                                                                                                                 
       IF cl_null(p_bmy04) THEN                       #檢查項次  
         #FUN-A50102--mod--str-- 
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                                
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),",",
                     cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end 
                    " WHERE bma01=bmb01 AND bma01='",l_bmz02,"' AND bmb03='",p_bmy05,"'"                       
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql   #FUN-A50102
          PREPARE chk_bmz_p1 FROM g_sql                                                                                                 
          EXECUTE chk_bmz_p1 INTO l_cnt
          LET l_cnt = l_cnt + l_cnt
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                                   
       ELSE                                                                                                                             
        #FUN-A50102--mod--str--
        # LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                                
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),",",
                     cl_get_target_table(g_plant_sep,'bmb_file'),
        #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",l_bmz02,"' AND bmb03='",p_bmy05,"'",                       
                    " AND bmb02='",p_bmy04,"'"                                                                        
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql   #FUN-A50102
          PREPARE chk_bmz_p2 FROM g_sql                                                                                                 
          EXECUTE chk_bmz_p2 INTO l_cnt    
          LET l_cnt = l_cnt + l_cnt                                                                                             
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                                   
       END IF
       END FOREACH
                                                                                                                                 
       IF l_cnt = 0 THEN                                                                                                                
          LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",l_bmz02,"/",p_bmy05                                                               
          CALL s_errmsg('azp01,gat01,bmy01,bmz02,bmy05',g_showmsg,'sel bmy01/bmz02/bmy05','abm-744',1)                                              
          RETURN FALSE                                                                                                                  
       ELSE                                                                                                                             
          RETURN TRUE                                                                                                                   
       END IF
     ELSE IF p_bmx06 = '2' THEN                       #單一主件(abmi720)                                                                                     
       IF cl_null(p_bmy01) THEN                                                                                                         
          RETURN TRUE                                                                                                                   
       END IF                                                                                                                           
                                                                                                                                    
       LET l_cnt = 0                                                                                                                    
                                                                                                                                    
       IF cl_null(p_bmy04) THEN                         #檢查項次                                                                                     
         #FUN-A50102--mod--str--
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                                
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),",",
                     cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",p_bmy14,"' AND bmb03='",p_bmy05,"'"                                   
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql   #FUN-A50102
          PREPARE chk_bmy_p1 FROM g_sql                                                                                                 
          EXECUTE chk_bmy_p1 INTO l_cnt                                                                                                 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                                   
       ELSE                                                                                                                             
         #FUN-A50102--mod--str--
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                                
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),",",
                     cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",p_bmy14,"' AND bmb03='",p_bmy05,"'",                                   
                    " AND bmb02='",p_bmy04,"'"                                                                              
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql   #FUN-A50102
          PREPARE chk_bmy_p2 FROM g_sql                                                                                                 
          EXECUTE chk_bmy_p2 INTO l_cnt                                                                                                 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                                   
       END IF
                                                                                                                                    
       IF l_cnt = 0 THEN                                                                                                                
          LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",p_bmy14,"/",p_bmy05                                                              
          CALL s_errmsg('azp01,gat01,bmy01,bmy14,bmy05',g_showmsg,'sel bmy01/bmy14/bmy05','abm-744',1)                                              
          RETURN FALSE                                                                                                                  
       ELSE                                                                                                                             
          RETURN TRUE                                                                                                                   
       END IF 
     END IF 
    END IF 
  WHEN p_bmy03 = '2' 
    IF p_bmx06 = '1' THEN                         #多主件(abmi710)                                                                  
       IF cl_null(p_bmy01) THEN                                                                                                     
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
                                                                                                                                    
       LET l_cnt = 0                                                                                                                
 
       #檢查主件                                                                                                                                    
       FOREACH bmz_chk_cur1 INTO l_bmz02                                                                                            
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file",  #FUN-A50102                          
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),   #FUN-A50102
                    " WHERE bma01='",l_bmz02,"' AND bma10 = '2'"                                            
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmz_p3 FROM g_sql                                                                                             
          EXECUTE chk_bmz_p3 INTO l_cnt                                                                                             
          LET l_cnt = l_cnt + l_cnt                                                                                                 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF    
       END FOREACH                                                                                                                  
 
       #檢查元件
       LET l_cnt1 = 0
       FOREACH bmy_chk_cur1 INTO l_bmy05,l_bmy27                                                                                            
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"ima_file",    #FUN-A50102                                                         
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'ima_file'),  #FUN-A50102
                    " WHERE ima01='",l_bmy05,"' AND ima1010 = '1' AND imaacti = 'Y'"                                                                                    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p3 FROM g_sql                                                                                             
          EXECUTE chk_bmy_p3 INTO l_cnt1                                                                                             
          LET l_cnt1 = l_cnt1 + l_cnt1                                                                                                 
          IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF                                                                               
       END FOREACH
                                                                                                                                    
       IF l_cnt = 0 OR l_cnt1 = 0 THEN                                                                                                            
          LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",l_bmz02,"/",p_bmy05                                                           
          CALL s_errmsg('azp01,gat01,bmy01,bmz02,bmy05',g_showmsg,'','abm-745',1)                                          
          RETURN FALSE                                                                                                              
       ELSE                                                                                                                         
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
     ELSE IF p_bmx06 = '2' THEN                       #單一主件(abmi720)                                                            
       IF cl_null(p_bmy01) THEN                                                                                                     
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
                                                                                                                                    
       LET l_cnt = 0                                                                                                                
                                                                                                                                    
       #檢查主件                                                              
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file",     #FUN-A50102
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),  #FUN-A50102                       
                    " WHERE bma01='",p_bmy14,"'"                                            
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p4 FROM g_sql
          EXECUTE chk_bmy_p4 INTO l_cnt                                                                                             
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                               
 
       #檢查元件                                                                                                                    
       LET l_cnt1 = 0                                                                                                               
       FOREACH bmy_chk_cur1 INTO l_bmy05,l_bmy27                                                                                            
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"ima_file",  #FUN-A50102
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'ima_file'),   #FUN-A50102                                                           
                    " WHERE ima01='",l_bmy05,"' AND ima1010 = '1' AND imaacti = 'Y'"                                               
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p5 FROM g_sql                                                                                             
          EXECUTE chk_bmy_p5 INTO l_cnt1                                                                                             
          LET l_cnt1 = l_cnt1 + l_cnt1                                                                                              
          IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF                                                                             
       END FOREACH
                                                                                                                                    
       IF l_cnt = 0 OR l_cnt1= 0 THEN                                                                                                            
          LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",p_bmy14,"/",p_bmy05                                                           
          CALL s_errmsg('azp01,gat01,bmy01,bmy14,bmy05',g_showmsg,'','abm-745',1)                                          
          RETURN FALSE                                                                                                              
       ELSE                                                                                                                         
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
     ELSE                                                                                                                           
        RETURN TRUE                                                                                                                 
     END IF
     END IF                                                                                                                         
  WHEN p_bmy03 = '4'  OR p_bmy03 = '5'     #No:MOD-9A0182 modify
    IF p_bmx06 = '1' THEN                         #多主件(abmi710)                                                                  
       IF cl_null(p_bmy01) THEN                                                                                                     
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
                                                                                                                                    
       LET l_cnt = 0                                                                                                                
                                                                                                                                    
       FOREACH bmz_chk_cur1 INTO l_bmz02                                                                                            
       IF cl_null(p_bmy04) THEN                       #檢查項次   
       #檢查主件+元件                                                                  
         #FUN-A50102--mod--str--
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                            
          LET g_sql="SELECT COUNT(*) ",
                    "  FROM ",cl_get_target_table(g_plant_sep,'bma_file'),
                    "      ,",cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",l_bmz02,"' AND bmb03='",p_bmy05,"'"                                            
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmz_p4 FROM g_sql                                                                                             
          EXECUTE chk_bmz_p4 INTO l_cnt                                                                                             
          LET l_cnt = l_cnt + l_cnt                                                                                                 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                               
       ELSE                                                                                                                         
         #FUN-A50102--mod--str--
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                            
          LET g_sql="SELECT COUNT(*) ",
                    "  FROM ",cl_get_target_table(g_plant_sep,'bma_file'),
                    "      ,",cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",l_bmz02,"' AND bmb03='",p_bmy05,"'",                                           
                    " AND bmb02='",p_bmy04,"'"                                                                                      
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102 
          PREPARE chk_bmz_p9 FROM g_sql                                                                                             
          EXECUTE chk_bmz_p9 INTO l_cnt                                                                                             
          LET l_cnt = l_cnt + l_cnt                                                                                                 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       END IF                                                                                                                       
       END FOREACH                                                                                                                  
                   
       #檢查取代的新料號                                                                                                                    
       LET l_cnt1 = 0                                                                                                               
       FOREACH bmy_chk_cur1 INTO l_bmy05,l_bmy27                                                                                            
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"ima_file",     #FUN-A50102
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'ima_file'),  #FUN-A50102                                                       
                    " WHERE ima01='",l_bmy27,"' AND ima1010 = '1' AND imaacti = 'Y'"                                               
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p6 FROM g_sql                                                                                             
          EXECUTE chk_bmy_p6 INTO l_cnt1                                                                                             
          LET l_cnt1 = l_cnt1 + l_cnt1                                                                                              
          IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF                                                                             
       END FOREACH
                                                                                                                 
       IF l_cnt = 0 OR l_cnt1 = 0 THEN                                                                                                            
          LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",l_bmz02,"/",l_bmy27                                                           
          CALL s_errmsg('azp01,gat01,bmy01,bmz02,bmy27',g_showmsg,'','abm-747',1)                                          
          RETURN FALSE                                                                                                              
       ELSE                                                                                                                         
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
     ELSE IF p_bmx06 = '2' THEN                       #單一主件(abmi720)                                                            
       IF cl_null(p_bmy01) THEN                                                                                                     
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
                                                                                                                                    
       LET l_cnt = 0                                                                                                                
                                                                                                                                    
       IF cl_null(p_bmy04) THEN                         #檢查項次
       #檢查主件+元件                                                                   
         #FUN-A50102--mod--str--
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                            
          LET g_sql="SELECT COUNT(*) ",
                    "  FROM ",cl_get_target_table(g_plant_sep,'bma_file'),
                    "      ,",cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",p_bmy14,"' AND bmb03='",p_bmy05,"'"                                            
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p7 FROM g_sql                                                                                             
          EXECUTE chk_bmy_p7 INTO l_cnt
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                               
       ELSE                                                                                                                         
         #FUN-A50102--mod--str--
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file,",g_dbs_sep CLIPPED,"bmb_file ",                            
          LET g_sql="SELECT COUNT(*) ",
                    "  FROM ",cl_get_target_table(g_plant_sep,'bma_file'),
                    "      ,",cl_get_target_table(g_plant_sep,'bmb_file'),
         #FUN-A50102--mod--end
                    " WHERE bma01=bmb01 AND bma01='",p_bmy14,"' AND bmb03='",p_bmy05,"'",                                           
                    " AND bmb02='",p_bmy04,"'"                                                                                      
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p10 FROM g_sql                                                                                             
          EXECUTE chk_bmy_p10 INTO l_cnt                                                                                             
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                               
       END IF                                                                                                                       
 
       #檢查取代的新料號                                                                                                                    
       LET l_cnt1 = 0                                                                                                               
       FOREACH bmy_chk_cur1 INTO l_bmy05,l_bmy27                                                                                            
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"ima_file",     #FUN-A50102
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'ima_file'),  #FUN-A50102                                                     
                    " WHERE ima01='",l_bmy27,"' AND ima1010 = '1' AND imaacti = 'Y'"                                               
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmy_p8 FROM g_sql                                                                                             
          EXECUTE chk_bmy_p8 INTO l_cnt1                                                                                             
          LET l_cnt1 = l_cnt1 + l_cnt1                                                                                              
          IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF                                                                             
       END FOREACH
                                                                                                                                    
       IF l_cnt = 0 OR l_cnt1 = 0 THEN                                                                                                            
          LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",p_bmy14,"/",l_bmy27                                                           
          CALL s_errmsg('azp01,gat01,bmy01,bmy14/bmy27',g_showmsg,'','abm-747',1)                                          
          RETURN FALSE                                                                                                              
       ELSE                                                                                                                         
          RETURN TRUE                                                                                                               
       END IF                                                                                                                       
     ELSE                                                                                                                           
        RETURN TRUE                                                                                                                 
     END IF
    END IF 
  #CHI-C20060---begin
  WHEN p_bmy03 = '6' 
     LET l_cnt = 0 
     FOREACH bmz_chk_cur1 INTO l_bmz02                                                                                                                                             
        LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),",",
                   cl_get_target_table(g_plant_sep,'bmb_file'),
                  " WHERE bma01=bmb01 AND bma01='",l_bmz02,"' AND bmb03='",p_bmy05,"'"                       
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
        CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  
        PREPARE chk_bmz_p10 FROM g_sql                                                                                                 
        EXECUTE chk_bmz_p10 INTO l_cnt
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF   
     END FOREACH   
     IF l_cnt = 0 THEN                                                                                                                
        LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",l_bmz02,"/",p_bmy05                                                               
        CALL s_errmsg('azp01,gat01,bmy01,bmz02,bmy05',g_showmsg,'','abm-744',1)                                              
        RETURN FALSE  
     END IF  
     
     LET l_cnt = 0
     FOREACH bmy_chk_cur1 INTO l_bmy05,l_bmy27    
        LET g_sql="SELECT COUNT(*) INTO l_cnt FROM ",cl_get_target_table(g_plant_sep,'bmd_file'),",",
                                                     cl_get_target_table(g_plant_sep,'bmz_file'),
                  " WHERE bmd08 = bmz02 ",
                  "   AND bmz01 = '",p_bmy01,"'",
                  "   AND bmd01 = '",p_bmy05,"'",
                  "   AND bmd04 = '",l_bmy27,"'", 
                  "   AND bmd02 = '2'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
        CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql 
        PREPARE chk_bmd_p1 FROM g_sql                                                                                             
        EXECUTE chk_bmd_p1 INTO l_cnt            
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF  
        IF l_cnt = 0 THEN                                                                                                                
           LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmy01,"/",l_bmz02,"/",p_bmy05                                                               
           CALL s_errmsg('azp01,gat01,bmy01,bmz02,bmy05',g_showmsg,'','abm-127',1)                                              
           RETURN FALSE  
        END IF    
     END FOREACH   
     RETURN TRUE 
  #CHI-C20060---end     
  END CASE
END FUNCTION
 
FUNCTION s_abmi710_carry_chk_bmz(p_bmz01,p_bmz02,p_bmx06,p_tabname)                                                                                 
   DEFINE p_bmz01        LIKE bmz_file.bmz01 
   DEFINE p_bmz02        LIKE bmz_file.bmz02           
   DEFINE p_bmx06        LIKE bmx_file.bmx06                                                                            
   DEFINE p_tabname      LIKE type_file.chr50                                                                                       
   DEFINE l_cnt          LIKE type_file.num5                                                                                        
   DEFINE l_bmz02        LIKE bmz_file.bmz02
 
   LET g_sql = " SELECT bmz02 from bmz_file ",                                                                                      
               "  WHERE bmz01 = '",p_bmz01,"'"                                                                                      
   PREPARE bmz02_chk_p1 FROM g_sql                                                                                                    
   DECLARE bmz02_chk_cur1 CURSOR WITH HOLD FOR bmz02_chk_p1
 
 
   IF p_bmx06 = '1' THEN                                                                                                                                  
       IF cl_null(p_bmz01) THEN                                                                                                         
          RETURN TRUE                                                                                                                   
       END IF                                                                                                                           
       LET l_cnt = 0      
 
       FOREACH bmz02_chk_cur1 INTO l_bmz02                                                                                            
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file",     #FUN-A50102
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'), #FUN-A50102                                                    
                    " WHERE bma01='",l_bmz02,"'"                                                                                    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmz02_p3 FROM g_sql                                                                                             
          EXECUTE chk_bmz02_p3 INTO l_cnt                                                                                             
          LET l_cnt = l_cnt + l_cnt                                                                                                 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       END FOREACH
   ELSE IF p_bmx06 = '2' THEN
       IF cl_null(p_bmz01) THEN                                                                                                         
          RETURN TRUE                                                                                                                   
       END IF                                                                                                                           
       LET l_cnt = 0
 
         #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bma_file",     #FUN-A50102
          LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'bma_file'),  #FUN-A50102                                                        
                    " WHERE bma01='",p_bmz02,"'"                                                                                    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
          PREPARE chk_bmz02_p4 FROM g_sql                                                                                             
          EXECUTE chk_bmz02_p4 INTO l_cnt                                                                                             
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   END IF
  END IF
   
   IF l_cnt = 0 THEN                                                                                                                
      LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bmz01,"/",p_bmz02                                                                           
      CALL s_errmsg('azp01,gat01,bmz01,bmz02',g_showmsg,'sel bmz01/bmz02','abm-748',1)                                                          
      RETURN FALSE                                                                                                                  
   ELSE                                                                                                                             
      RETURN TRUE                                                                                                                   
   END IF
END FUNCTION 
#NO.FUN-9C0072 精簡程式碼

#FUN-AC0060---add-----str---
FUNCTION s_abmi710_get_db(p_plant)
   DEFINE p_plant		LIKE azq_file.azq01           
   DEFINE l_dbs  		LIKE type_file.chr20

   SELECT azp03 INTO l_dbs FROM azp_file
          WHERE azp01 = p_plant
   RETURN l_dbs
END FUNCTION
#FUN-AC0060---add-----end---
