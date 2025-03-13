# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_apmi600_carry.4gl
# Descriptions...: 基本資料拋轉
# Date & Author..: 08/02/28 By lilingyu FUN-820028
# Input PARAMETER: p_pmc 拋轉單身LIST
#                  p_azp    拋轉至DB 清單
#                  p_gev04  資料中心代碼
# Modify.........: FUN-820028 08/03/24 By lilingyu -239的錯誤不做收集
# Modify.........: FUN-820028 08/03/26 By lilingyu add upload logical
# Modify.........: FUN-820028 08/04/01 By lilingyu 拿掉pmc1921拋轉次數
# Modify.........: NO.FUN-840018 08/04/03 BY Yiting apmi610納入aooi602規則處理
# Modify.........: NO.FUN-840033 08/04/10 by yiting  1.走申請流程時，不用限制廠商基本資料拋轉動作
# Modify.........: No.MOD-840117 08/04/15 By claire 拋轉資料時,若沒選擇DB不應更新單據為已拋轉
# Modify.........: NO.FUN-840033 08/04/17 BY yiting 拋轉成功才發郵件通知
# Modify.........: no.FUN-840090 08/04/20 by yiting 依gew03設定拋.
# Modify.........: No.MOD-840200 08/04/21 By Carrier 修改拋轉DB INPUT功能
# Modify.........: No.MOD-840390 08/04/21 By lilingyu apmi610往其他DB insert/update時,
#                                                     把資料來源的值一起給上
# Modify.........: NO.MOD-840158 08/04/22 BY yiting 開窗拋轉時營運中心無法開窗
# Modify.........: No.CHI-870044 08/08/01 By Smapmin 資料拋轉不應只限20個DB
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-930086 09/03/09 By rainy INSERT INTO pmc_file時，誤將pmd1920key為pmcud1920,造成資料無法拋轉
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.MOD-960140 09/07/07 By Smapmin 供應商申請選擇修改時會判斷無前申請單而無法選擇拋轉營運中心
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0126 09/10/26 By liuxqa ROWID修改。
# Modify.........: NO.FUN-9A0092 09/10/30 By baofei GP5.2資料中心修改
# Modify.........: No.TQC-9B0011 09/11/03 By liuxqa s_dbstring 的修改。
# Modify.........: No.FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No.TQC-A10060 10/01/12 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A30110 10/04/12 By Carrier 客户/厂商简称修改
# Modify.........: No.TQC-A40128 10/06/07 By Cockroach 拋轉流通增加的字段的默認值pmc59,pmc60,pmccrat
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60011 10/07/26 By Summer 在拋轉資料前,將該Lock的Table都先做Lock,確定資料沒被其他人Lock住才能做拋轉
# Modify.........: NO.CHI-A60035 10/07/27 by Summer gew03 = '1'時,確認時自動拋轉
# Modify.........: No:MOD-A50071 10/07/30 By Smapmin MOD-840117
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
# Modify.........: No:MOD-AA0174 10/10/27 By lilingyu insert pmc_file時,前後數量不一致
# Modify.........: No:CHI-A80049 10/11/12 By Summer 開放apmi610其他欄位的修改,如同apmi600
# Modify.........: No.TQC-AB0107 10/11/28 By wangxin BUG修正
# Modify.........: No.TQC-AC0254 10/12/17 By vealxu 資料拋轉成功後無訊息提示
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-BB0002 11/01/01 By Carrier MISC/EMPL简称修改时,不进行各资料档案的UPDATE
# Modify.........: No:FUN-BB0049 11/11/21 By Carrier aza125='Y'&厂商及客户编号相同时,简称需保持相同,若为'N',则不需有此管控
#                                                    aza126='Y'&厂商客户简称修改后,需更新历史资料
# Modify.........: No:FUN-B90080 12/01/16 By Sakura  pmca914~pmca923欄位
# Modify.........: No:CHI-C20021 12/04/16 By suncx 新增手續費外加/內扣pmca281字段
# Modify.........: No:MOD-C50233 12/06/27 By Vampire apm-081的判斷,請增加判斷pmca914='Y'才檢查
# Modify.........: No:TQC-C50178 12/10/09 By dongsz 資料拋轉時，處於已拋轉狀態時應該可以繼續拋轉到還沒拋轉過的資料庫
# Modify.........: No:FUN-C90089 12/12/03 By pauline 拋轉時增加相關文件拋轉
# Modify.........: No:CHI-CB0017 12/12/05 By Lori 資料拋轉改使用s_data_transfer

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_apmi600_center.global"   #No.FUN-820028
 
DEFINE g_pmc_p    DYNAMIC ARRAY OF RECORD 
                    sel      LIKE type_file.chr1,                                                                             
                    pmc01    LIKE pmc_file.pmc01                                                                          
                  END RECORD 
DEFINE g_pmc_1    DYNAMIC ARRAY OF RECORD                                                                                   
                   sel      LIKE type_file.chr1,                                                                             
                   pmc01    LIKE pmc_file.pmc01                                                                              
                  END RECORD              
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
DEFINE tm         DYNAMIC ARRAY of RECORD            #CHI-870044                       
                  sel    LIKE type_file.chr1,    #No.FUN-680137 CHAR
                  azp01    LIKE azp_file.azp01,                       
                  azp02    LIKE azp_file.azp02,                       
                  azp03    LIKE azp_file.azp03,                       
                  plant    LIKE type_file.chr1000, #FUN-9A0092
                  exist    LIKE type_file.chr1     #TQC-740090 add    
                  END RECORD 
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_msg_s    LIKE type_file.chr1000
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg3     LIKE type_file.chr1000
DEFINE g_msg4     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE #g_sql_s    LIKE type_file.chr1000
       g_sql_s        STRING       #NO.FUN-910082  
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_dbs_sep  LIKE type_file.chr50
DEFINE g_pmc      RECORD LIKE pmc_file.*
DEFINE g_pnp      RECORD LIKE pnp_file.*
DEFINE g_pmf      RECORD LIKE pmf_file.*
DEFINE g_pmg      RECORD LIKE pmg_file.*
DEFINE g_pmd      RECORD LIKE pmd_file.*
DEFINE g_pov      RECORD LIKE pov_file.*
DEFINE g_all_cnt  LIKE type_file.num10   #總共要拋轉的筆數
DEFINE g_cur_cnt  LIKE type_file.num10   #當前營運中心滿足拋轉條件的筆數
DEFINE g_flagx    LIKE type_file.chr1    #NO.FUN-820028
DEFINE g_forupd_sql      STRING           #SELECT ... FOR UPDATE NOWAIT SQL #CHI-A60011 add
DEFINE l_hist_tab        LIKE type_file.chr50    #for mail   #CHI-A60011 add
 
FUNCTION s_apmi600_carry_pmc(p_pmc_p,p_azp,p_gev04,p_flagx)  #NO.FUN-820028
   DEFINE p_pmc_p             DYNAMIC ARRAY OF RECORD 
                               sel      LIKE type_file.chr1,
                               pmc01    LIKE pmc_file.pmc01
                              END RECORD             
   DEFINE p_azp               DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               azp01    LIKE azp_file.azp01,
                               azp02    LIKE azp_file.azp02,
                               azp03    LIKE azp_file.azp03
                              END RECORD                              
   DEFINE p_gev04              LIKE gev_file.gev04
   DEFINE p_flagx               LIKE type_file.chr1     #NO.FUN-820028
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_j                  LIKE type_file.num10
   
   DEFINE l_str1               STRING
   DEFINE l_str2               STRING
   DEFINE l_str3               STRING
   DEFINE l_str4               STRING
   DEFINE l_str1_pnp           STRING
   DEFINE l_str2_pnp           STRING
   DEFINE l_str3_pnp           STRING
   DEFINE l_str4_pnp           STRING
   DEFINE l_str1_pmf           STRING
   DEFINE l_str2_pmf           STRING
   DEFINE l_str3_pmf           STRING
   DEFINE l_str4_pmf           STRING
   DEFINE l_str1_pmg           STRING
   DEFINE l_str2_pmg           STRING
   DEFINE l_str3_pmg           STRING
   DEFINE l_str4_pmg           STRING
   DEFINE l_str1_pmd           STRING
   DEFINE l_str2_pmd           STRING
   DEFINE l_str3_pmd           STRING
   DEFINE l_str4_pmd           STRING
   DEFINE l_str1_pov           STRING
   DEFINE l_str2_pov           STRING
   DEFINE l_str3_pov           STRING
   DEFINE l_str4_pov           STRING
      
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_tabname            LIKE type_file.chr50
   DEFINE l_pmc01_old          LIKE pmc_file.pmc01
   DEFINE l_pmc01              LIKE pmc_file.pmc01
   DEFINE l_pmc14              LIKE pmc_file.pmc14
   DEFINE l_gez04              LIKE gez_file.gez04
   DEFINE l_gez05              LIKE gez_file.gez05
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail                                                            
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark                                
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail                                                            
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail                                                            
   DEFINE l_pmc_upd            LIKE type_file.chr1     #NO.FUN-840068
   DEFINE l_pmc03_t            LIKE pmc_file.pmc03     #No.FUN-A30110
   DEFINE l_pmc_2       RECORD LIKE pmc_file.*  #CHI-A60011 add 
   DEFINE l_value1             LIKE type_file.chr30    #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30    #CHI-CB0017 add
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_flagx = p_flagx     #No.FUN-820028   0.carry  1.upload   
 
  
   IF g_flagx <> '1' THEN
      IF p_pmc_p.getLength() = 0 THEN RETURN END IF
   END IF
 
   IF p_azp.getLength()   = 0 THEN RETURN END IF
   CALL g_pmc_p.clear()
   
   #前置准備
   FOR l_i = 1 TO p_pmc_p.getLength()
       LET g_pmc_p[l_i].* = p_pmc_p[l_i].*
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
               "    AND gez02 = '5'",
               "    AND gez03 = ?  "
   PREPARE gez_p FROM g_sql
   DECLARE gez_cur CURSOR WITH HOLD FOR gez_p
   #組column
   CALL s_carry_col('pmc_file') RETURNING l_str1,l_str2,l_str3
   CALL s_carry_col('pnp_file') RETURNING l_str1_pnp,l_str2_pnp,l_str3_pnp
   CALL s_carry_col('pmf_file') RETURNING l_str1_pmf,l_str2_pmf,l_str3_pmf
   CALL s_carry_col('pmd_file') RETURNING l_str1_pmd,l_str2_pmd,l_str3_pmd
   CALL s_carry_col('pov_file') RETURNING l_str1_pov,l_str2_pov,l_str3_pov
   CALL s_carry_col('pmg_file') RETURNING l_str1_pmg,l_str2_pmg,l_str3_pmg
   #組index
   CALL s_carry_idx('pmc_file') RETURNING l_str4
   CALL s_carry_idx('pnp_file') RETURNING l_str4_pnp
   CALL s_carry_idx('pmf_file') RETURNING l_str4_pmf
   CALL s_carry_idx('pmd_file') RETURNING l_str4_pmd
   CALL s_carry_idx('pov_file') RETURNING l_str4_pov
   CALL s_carry_idx('pmg_file') RETURNING l_str4_pmg
   
   #建立臨時表,用于存放拋轉的資料
   CALL s_apmi600_carry_p2() RETURNING l_tabname
 
   IF g_all_cnt = 0 THEN                                                                                                     
      CALL cl_err('','aap-129',1)                                                                                            
      RETURN                                                                                                                 
   END IF                                                                                                                    
 
   #建立歷史資料拋轉的臨時表                                                                                                
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab  
   
   #pmc對應pnp_file拋轉的cursor定義                                         
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM pnp_file ",                                      
                  "  WHERE pnp01 = ? "
   ELSE
      LET g_sql  = " SELECT * FROM pnp_file_bak1 ",    #No.FUN-A80036
                   "  WHERE pnp01 = ? " 
   END IF
   PREPARE pnp_p FROM g_sql                                                     
   DECLARE pnp_cur CURSOR WITH HOLD FOR pnp_p
   
    #pmc對應pmf_file拋轉的cursor定義                                         
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM pmf_file ",                                      
                  "  WHERE pmf01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM pmf_file_bak1 ",    #No.FUN-A80036
                  " WHERE pmf01 = ? "
   END IF
   PREPARE pmf_p FROM g_sql                                                     
   DECLARE pmf_cur CURSOR WITH HOLD FOR pmf_p
   
    #pmc對應pmg_file拋轉的cursor定義                                         
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM pmg_file ",                                      
                  "  WHERE pmg01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM pmg_file_bak1 ",    #No.FUN-A80036
                  " WHERE pmg01 = ? "
   END IF
   PREPARE pmg_p FROM g_sql                                                     
   DECLARE pmg_cur CURSOR WITH HOLD FOR pmg_p
   
    #pmc對應pmd_file拋轉的cursor定義                                         
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM pmd_file ",                                      
                  "  WHERE pmd01 = ? "
   ELSE 
      LET g_sql = " SELECT * FROM pmd_file_bak1 ",    #No.FUN-A80036
                  " WHERE pmd01 = ? "
   END IF  
   PREPARE pmd_p FROM g_sql                                                     
   DECLARE pmd_cur CURSOR WITH HOLD FOR pmd_p
   
    #pmc對應pov_file拋轉的cursor定義                                         
    IF g_flagx <> '1' THEN
       LET g_sql = " SELECT * FROM pov_file ",                                      
                   "  WHERE pov01 ='0' and pov02 = ? "
    ELSE
      LET g_sql = " SELECT * FROM pov_file_bak1 ",    #No.FUN-A80036
                  " WHERE pov01 = '0' and pov02 = ? "
    END IF
    PREPARE pov_p FROM g_sql                                                     
   DECLARE pov_cur CURSOR WITH HOLD FOR pov_p
   
   FOR l_j = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
       
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '5'
          AND gew04 = g_azp[l_j].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                                                                                       
       CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'5',l_hist_tab)                                                      
            RETURNING l_hs_flag,l_hs_path
 
       CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
       LET g_dbs_sep = l_dbs_sep
       
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"pmc_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'pmc_file'), #FUN-A50102
                  " VALUES(",l_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1 FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"pmc_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'pmc_file'), #FUN-A50102
                   "   SET ",l_str3,
                   " WHERE ",l_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2 FROM g_sql
       #CHI-A60011 add --start--
       LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01,'pmc_file'),
                          " WHERE ",l_str4," FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
       CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql
       DECLARE db_cs2_pmc_lock CURSOR FROM g_forupd_sql
       #CHI-A60011 add --end--
           
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"pnp_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'pnp_file'), #FUN-A50102
                   " VALUES(",l_str2_pnp,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_pnp FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"pnp_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'pnp_file'), #FUN-A50102
                   "   SET ",l_str3_pnp,
                   " WHERE ",l_str4_pnp
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2_pnp FROM g_sql
       #CHI-A60011 add --start--
       LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01,'pnp_file'),
                          " WHERE ",l_str4_pnp," FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
       CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql
       DECLARE db_cs2_pnp_lock CURSOR FROM g_forupd_sql
       #CHI-A60011 add --end--
      
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"pmf_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'pmf_file'), #FUN-A50102
                   " VALUES(",l_str2_pmf,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_pmf FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"pmf_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'pmf_file'), #FUN-A50102
                   "   SET ",l_str3_pmf,
                   " WHERE ",l_str4_pmf
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2_pmf FROM g_sql
       #CHI-A60011 add --start--
       LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01,'pmf_file'),
                          " WHERE ",l_str4_pmf," FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
       CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql
       DECLARE db_cs2_pmf_lock CURSOR FROM g_forupd_sql
       #CHI-A60011 add --end--
       
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"pov_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'pov_file'), #FUN-A50102
                   " VALUES(",l_str2_pov,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_pov FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"pov_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'pov_file'), #FUN-A50102
                   "   SET ",l_str3_pov,
                   " WHERE ",l_str4_pov
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2_pov FROM g_sql
       #CHI-A60011 add --start--
       LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01,'pov_file'),
                          " WHERE ",l_str4_pov," FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
       CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql
       DECLARE db_cs2_pov_lock CURSOR FROM g_forupd_sql
       #CHI-A60011 add --end--
       
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"pmg_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'pmg_file'), #FUN-A50102
                   " VALUES(",l_str2_pmg,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_pmg FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"pmg_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'pmg_file'), #FUN-A50102
                   "   SET ",l_str3_pmg,
                   " WHERE ",l_str4_pmg
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2_pmg FROM g_sql
       #CHI-A60011 add --start--
       LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01,'pmg_file'),
                          " WHERE ",l_str4_pmg," FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
       CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql
       DECLARE db_cs2_pmg_lock CURSOR FROM g_forupd_sql
       #CHI-A60011 add --end--
       
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"pmd_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'pmd_file'), #FUN-A50102
                   " VALUES(",l_str2_pmd,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1_pmd FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"pmd_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'pmd_file'), #FUN-A50102
                   "   SET ",l_str3_pmd,
                   " WHERE ",l_str4_pmd
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2_pmd FROM g_sql
       #CHI-A60011 add --start--
       LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01,'pmd_file'),
                          " WHERE ",l_str4_pmd," FOR UPDATE"
       #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql     #No.FUN-B80088--mark--
       CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql         #No.FUN-B80088--add---
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql
       DECLARE db_cs2_pmd_lock CURSOR FROM g_forupd_sql
       #CHI-A60011 add --end--
       
       #default aooi602中設置的預設值
       LET l_pmc01 = NULL
       LET l_pmc14 = NULL
       FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)
             CONTINUE FOREACH
          END IF
          IF l_gez04 = 'pmc01'  THEN LET l_pmc01  = l_gez05 END IF
          IF l_gez04 = 'pmc14'  THEN LET l_pmc14  = l_gez05 END IF
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
 
       LET l_pmc_upd = 'N'    #No.FUN-A80036
       FOREACH carry_cur1 INTO g_pmc.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('pmc01',g_pmc.pmc01,'foreach',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
         IF g_pmc.pmcacti <> 'Y' THEN 
            IF l_j = 1 THEN  #僅報一次錯誤                                                                    
               LET g_showmsg = g_plant,":",g_pmc.pmc01                                                                                 
               CALL s_errmsg('azp01,pmc01',g_showmsg,'pmcacti','aoo-090',1)                                                            
            END IF
            CONTINUE FOREACH                                                                                                        
         END IF
 
         LET g_success = 'Y'
         #LET l_pmc_upd = 'N'   #NO.FUN-840068 add  #No.FUN-A80036
 
         BEGIN WORK
         LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_pmc.pmc01,':'
         LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_pmc.pmc01,':'
 
         LET l_pmc01_old = g_pmc.pmc01
         IF NOT cl_null(l_pmc01) THEN LET g_pmc.pmc01 = l_pmc01 END IF
         IF NOT cl_null(l_pmc14) THEN LET g_pmc.pmc14 = l_pmc14 END IF
 
         #pmc1920,pmc1921
         LET g_pmc.pmc1920 = g_plant
         LET g_pmc.pmc1921 = 1
            
         EXECUTE db_cs1 USING g_pmc.*
         IF SQLCA.sqlcode = 0 THEN
            MESSAGE g_msg1,':ok'
            CALL ui.Interface.refresh()
            CALL s_upd_abbr(g_pmc.pmc01,g_pmc.pmc03,g_azp[l_j].azp01,'1','Y','a')  #No.FUN-BB0049
         ELSE
            #IF SQLCA.sqlcode = -239 THEN  #若此筆數據在目標資料庫中已經存在 #CHI-A60011 mark 
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #CHI-A60011
               IF l_gew07 = 'N' THEN                                                                                        
                  MESSAGE g_msg1 CLIPPED,':exist'                                                                           
                  LET g_success = 'N'     #No.FUN-A80036
                  CALL ui.Interface.refresh()                                                                               
               ELSE     
                  #CHI-A60011 add --start--
                  OPEN db_cs2_pmc_lock USING l_pmc01_old
                  IF STATUS THEN
                     LET g_msg_x = g_azp[l_j].azp01,':pmc_file:lock'
                     CALL s_errmsg('pmc01',g_pmc.pmc01,g_msg_x,STATUS,1)
                     MESSAGE g_msg2,':fail'
                     CALL ui.Interface.refresh()
                     CLOSE db_cs2_pmc_lock
                     LET g_success = 'N'
                     #No.FUN-A80036  --Begin
                     #LET l_pmc_upd = 'N'
                     #EXIT FOREACH
                     CONTINUE FOREACH
                     #No.FUN-A80036  --End  
                  END IF
                  FETCH db_cs2_pmc_lock INTO l_pmc_2.* 
                  IF SQLCA.SQLCODE THEN
                     LET g_msg_x = g_azp[l_j].azp01,':pmc_file:lock'
                     CALL s_errmsg('pmc01',g_pmc.pmc01,g_msg_x,SQLCA.SQLCODE,1)
                     MESSAGE g_msg2,':fail'
                     CALL ui.Interface.refresh()
                     CLOSE db_cs2_pmc_lock
                     LET g_success = 'N'
                     #No.FUN-A80036  --Begin
                     #LET l_pmc_upd = 'N'
                     #EXIT FOREACH
                     CONTINUE FOREACH
                     #No.FUN-A80036  --End  
                  END IF
                  #CHI-A60011 add --end--
                  LET g_sql = "SELECT pmc1921,pmc03 FROM ",       #No.FUN-A30110
                              #l_dbs_sep CLIPPED,"pmc_file ",
                              cl_get_target_table(g_azp[l_j].azp01,'pmc_file'), #FUN-A50102
                              " WHERE pmc01='",l_pmc01_old CLIPPED,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-A50102
                  CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102            
                  PREPARE pmc_p1 FROM g_sql
                  EXECUTE pmc_p1 INTO g_pmc.pmc1921,l_pmc03_t    #No.FUN-A30110
                  IF cl_null(g_pmc.pmc1921) THEN LET g_pmc.pmc1921 = 0 END IF
                  LET g_pmc.pmc1921 = g_pmc.pmc1921 + 1
 
                  EXECUTE db_cs2 USING g_pmc.*,l_pmc01_old
                  IF SQLCA.sqlcode = 0 THEN
                     MESSAGE g_msg2,':ok'
                     #No.FUN-A80036  --Begin
                     #LET l_pmc_upd = 'Y'        #no.FUN-840068 add
                     #No.FUN-A80036  --End  
                     CALL ui.Interface.refresh()
                     #No.FUN-A30110  --Begin
                     IF NOT (g_pmc.pmc01 MATCHES 'MISC*' OR g_pmc.pmc01 MATCHES 'EMPL*') THEN    #No.TQC-BB0002
                        IF g_pmc.pmc03 <> l_pmc03_t THEN
                           #CALL s_upd_abbr(g_pmc.pmc01,g_pmc.pmc03,g_azp[l_j].azp03,'1','Y')
                           CALL s_upd_abbr(g_pmc.pmc01,g_pmc.pmc03,g_azp[l_j].azp01,'1','Y','u') #FUN-A50102   #No.FUN-BB0049
                        END IF
                     END IF    #No.TQC-BB0002
                     #No.FUN-A30110  --End  
                  ELSE
                     LET g_msg_x = g_azp[l_j].azp01,':upd'
                     CALL s_errmsg('pmc01',g_pmc.pmc01,g_msg_x,SQLCA.sqlcode,1)
                     MESSAGE g_msg2,':fail'
                     #LET l_pmc_upd = 'N'        #no.FUN-840068 add  #No.FUN-A80036
                     CALL ui.Interface.refresh()
                     LET g_success = 'N'
                  END IF
                  CLOSE db_cs2_pmc_lock  #CHI-A60011 add
               END IF
            ELSE
               LET g_msg_x = g_azp[l_j].azp01,':ins'
               CALL s_errmsg('pmc01',g_pmc.pmc01,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg1,':fail'
               #LET l_pmc_upd = 'N'       #no.FUN-840068 add  #No.FUN-A80036
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
         END IF
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlerrd[3] > 0 THEN
         IF g_success = 'Y' THEN
         #No.FUN-A80036  --End  
            CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_pmc.pmc01,'5')
            CALL s_apmp600_pnp(l_pmc01_old,l_pmc01,g_azp[l_j].azp01,l_gew07)
            CALL s_apmp600_pmf(l_pmc01_old,l_pmc01,g_azp[l_j].azp01,l_gew07)
            CALL s_apmp600_pmg(l_pmc01_old,l_pmc01,g_azp[l_j].azp01,l_gew07)
            CALL s_apmp600_pmd(l_pmc01_old,l_pmc01,g_azp[l_j].azp01,l_gew07)
            CALL s_apmp600_pov(l_pmc01_old,l_pmc01,g_azp[l_j].azp01,l_gew07)
         END IF
        #CALL i610_dbs_doc(g_azp[l_j].azp01)  #FUN-C90089 add    #CHI-CB0017 mark

         #CHI-CB0017 add begin---
         IF g_prog = 'apmi610' THEN
            LET l_value1 = g_pmca.pmcano
            LET l_value2 = g_pmca.pmca01
         END IF
         IF g_prog = 'apmi600' THEN
            LET l_value1 = g_pmc.pmc01
            LET l_value2 = g_pmc.pmc01
         END IF
         CALL s_data_transfer(g_azp[l_j].azp01,'3',g_prog,l_value1,l_value2,'','','')
         #CHI-CB0017 add end-----

         IF g_success = 'N' THEN
            #LET l_pmc_upd = 'N'    #no.FUN-840068 add  #No.FUN-A80036
            ROLLBACK WORK
         ELSE
            LET l_pmc_upd = 'Y'    #no.FUN-840068 add
            COMMIT WORK
         END IF     
 
       END FOREACH   
       IF l_pmc_upd ='Y' THEN   #NO.FUN-840068 add
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)                                                 
       END IF                   #no.FUN-840068 add
   END FOR 
   
    CALL s_dc_drop_temp_table(l_tabname)
    CALL s_dc_drop_temp_table(l_hist_tab)
 
    IF l_pmc_upd = 'Y' THEN   #no.FUN-840068 add
     #  MESSAGE 'Data Carry Finish!'     #TQC-AC0254 mark
        CALL cl_err('','aim-162',0)      #TQC-AC0254
        CALL ui.Interface.refresh()   
    END IF                    #no.FUN-840068 add
END FUNCTION
 
FUNCTION s_apmp600_pnp(p_pmc01_old,p_pmc01_new,p_azp01,p_gew07)
   DEFINE p_pmc01_old     LIKE pmc_file.pmc01
   DEFINE p_pmc01_new     LIKE pmc_file.pmc01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_pnp_2         RECORD LIKE pnp_file.*  #CHI-A60011 add
 
   FOREACH pnp_cur USING p_pmc01_old INTO g_pnp.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pnp01',g_pnp.pnp01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_pmc01_new) THEN LET g_pnp.pnp01 = p_pmc01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_pnp.pnp01,'+',g_pnp.pnp02,'+',g_pnp.pnp03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_pnp.pnp01,'+',g_pnp.pnp02,'+',g_pnp.pnp03,':'
      EXECUTE db_cs1_pnp USING g_pnp.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #No.FUN-A80036  --Begin
        #IF SQLCA.sqlcode = -239 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        #No.FUN-A80036  --End  
          IF p_gew07 = 'N' THEN                                                                                           
             MESSAGE g_msg3 CLIPPED,':exist'                                                                              
             LET g_success = 'N'     #No.FUN-A80036
             CALL ui.Interface.refresh()                                                                                  
          ELSE  
             #CHI-A60011 add --start--
             OPEN db_cs2_pnp_lock USING p_pmc01_old,g_pnp.pnp02,g_pnp.pnp03
             IF STATUS THEN
                LET g_msg_x = p_azp01,':pnp_file:lock'
                LET g_showmsg = g_pnp.pnp01,'/',g_pnp.pnp02,'/',g_pnp.pnp03
                CALL s_errmsg('pnp01,pnp02,pnp03',g_showmsg,g_msg_x,STATUS,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pnp_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH db_cs2_pnp_lock INTO l_pnp_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg_x = p_azp01,':pnp_file:lock'
                LET g_showmsg = g_pnp.pnp01,'/',g_pnp.pnp02,'/',g_pnp.pnp03
                CALL s_errmsg('pnp01,pnp02,pnp03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pnp_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
            EXECUTE db_cs2_pnp USING g_pnp.*,p_pmc01_old,g_pnp.pnp02,g_pnp.pnp03
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_pnp.pnp01,'/',g_pnp.pnp02,'/',g_pnp.pnp03
               CALL s_errmsg('pnp01,pnp02,pnp03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
            CLOSE db_cs2_pnp_lock  #CHI-A60011 add
          END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_pnp.pnp01,'/',g_pnp.pnp02,'/',g_pnp.pnp03
            CALL s_errmsg('pnp01,pnp02,pnp03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_pnp.pnp01||'+'||g_pnp.pnp02||'+'||g_pnp.pnp03,'5')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_apmp600_pmf(p_pmc01_old,p_pmc01_new,p_azp01,p_gew07)
   DEFINE p_pmc01_old     LIKE pmc_file.pmc01
   DEFINE p_pmc01_new     LIKE pmc_file.pmc01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_pmf_2         RECORD LIKE pmf_file.*  #CHI-A60011 add
 
   FOREACH pmf_cur USING p_pmc01_old INTO g_pmf.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmf01',g_pmf.pmf01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_pmc01_new) THEN LET g_pmf.pmf01 = p_pmc01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_pmf.pmf01,'+',g_pmf.pmf02,'+',g_pmf.pmf03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_pmf.pmf01,'+',g_pmf.pmf02,'+',g_pmf.pmf03,':'
      EXECUTE db_cs1_pmf USING g_pmf.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #No.FUN-A80036  --Begin
        #IF SQLCA.sqlcode = -239 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        #No.FUN-A80036  --End  
           IF p_gew07 = 'N' THEN                                                                                           
              MESSAGE g_msg3 CLIPPED,':exist'                                                                              
              CALL ui.Interface.refresh()                                                                                  
              LET g_success = 'N'    #No.FUN-A80036
           ELSE 
             #CHI-A60011 add --start--
             OPEN db_cs2_pmf_lock USING p_pmc01_old,g_pmf.pmf02,g_pmf.pmf03
             IF STATUS THEN
                LET g_msg_x = p_azp01,':pmf_file:lock'
                LET g_showmsg = g_pmf.pmf01,'/',g_pmf.pmf02,'/',g_pmf.pmf03
                CALL s_errmsg('pmf01,pmf02,pmf03',g_showmsg,g_msg_x,STATUS,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pmf_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH db_cs2_pmf_lock INTO l_pmf_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg_x = p_azp01,':pmf_file:lock'
                LET g_showmsg = g_pmf.pmf01,'/',g_pmf.pmf02,'/',g_pmf.pmf03
                CALL s_errmsg('pmf01,pmf02,pmf03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pmf_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
            EXECUTE db_cs2_pmf USING g_pmf.*,p_pmc01_old,g_pmf.pmf02,g_pmf.pmf03
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_pmf.pmf01,'/',g_pmf.pmf02,'/',g_pmf.pmf03
               CALL s_errmsg('pmf01,pmf02,pmf03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
            CLOSE db_cs2_pmf_lock  #CHI-A60011 add
          END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_pmf.pmf01,'/',g_pmf.pmf02,'/',g_pmf.pmf03
            CALL s_errmsg('pmf01,pmf02,pmf03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_pmf.pmf01||'+'||g_pmf.pmf02||'+'||g_pmf.pmf03,'5')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_apmp600_pmg(p_pmc01_old,p_pmc01_new,p_azp01,p_gew07)
   DEFINE p_pmc01_old     LIKE pmc_file.pmc01
   DEFINE p_pmc01_new     LIKE pmc_file.pmc01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_pmg_2         RECORD LIKE pmg_file.*  #CHI-A60011 add
 
   FOREACH pmg_cur USING p_pmc01_old INTO g_pmg.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmg01',g_pmg.pmg01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_pmc01_new) THEN LET g_pmg.pmg01 = p_pmc01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_pmg.pmg01,'+',g_pmg.pmg02,'+',g_pmg.pmg03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_pmg.pmg01,'+',g_pmg.pmg02,'+',g_pmg.pmg03,':'
      EXECUTE db_cs1_pmg USING g_pmg.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #No.FUN-A80036  --Begin
        #IF SQLCA.sqlcode = -239 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN                                                                                          
                MESSAGE g_msg3 CLIPPED,':exist'                                                                              
                LET g_success = 'N'    #No.FUN-A80036
                CALL ui.Interface.refresh()                                                                                  
            ELSE 
             #CHI-A60011 add --start--
             OPEN db_cs2_pmg_lock USING p_pmc01_old,g_pmg.pmg02
             IF STATUS THEN
                LET g_msg_x = p_azp01,':pmg_file:lock'
                LET g_showmsg = g_pmg.pmg01,'/',g_pmg.pmg02,'/',g_pmg.pmg03
                CALL s_errmsg('pmg01,pmg02,pmg03',g_showmsg,g_msg_x,STATUS,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pmg_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH db_cs2_pmg_lock INTO l_pmg_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg_x = p_azp01,':pmg_file:lock'
                LET g_showmsg = g_pmg.pmg01,'/',g_pmg.pmg02,'/',g_pmg.pmg03
                CALL s_errmsg('pmg01,pmg02,pmg03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pmg_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
            EXECUTE db_cs2_pmg USING g_pmg.*,p_pmc01_old,g_pmg.pmg02 #,g_pmg.pmg03
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_pmg.pmg01,'/',g_pmg.pmg02,'/',g_pmg.pmg03
               CALL s_errmsg('pmg01,pmg02,pmg03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
            CLOSE db_cs2_pmg_lock  #CHI-A60011 add
          END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_pmg.pmg01,'/',g_pmg.pmg02,'/',g_pmg.pmg03
            CALL s_errmsg('pmg01,pmg02,pmg03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_pmg.pmg01||'+'||g_pmg.pmg02,'5')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_apmp600_pmd(p_pmc01_old,p_pmc01_new,p_azp01,p_gew07)
   DEFINE p_pmc01_old     LIKE pmc_file.pmc01
   DEFINE p_pmc01_new     LIKE pmc_file.pmc01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_pmd_2         RECORD LIKE pmd_file.*  #CHI-A60011 add
 
   FOREACH pmd_cur USING p_pmc01_old INTO g_pmd.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmd01',g_pmd.pmd01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_pmc01_new) THEN LET g_pmd.pmd01 = p_pmc01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_pmd.pmd01,'+',g_pmd.pmd02,'+',g_pmd.pmd06,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_pmd.pmd01,'+',g_pmd.pmd02,'+',g_pmd.pmd06,':'
      EXECUTE db_cs1_pmd USING g_pmd.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #No.FUN-A80036  --Begin
        #IF SQLCA.sqlcode = -239 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        #No.FUN-A80036  --End  
             IF p_gew07 = 'N' THEN                                                                                           
               MESSAGE g_msg3 CLIPPED,':exist'                                                                              
               LET g_success = 'N'    #No.FUN-A80036
               CALL ui.Interface.refresh()                                                                                  
          ELSE 
             #CHI-A60011 add --start--
             OPEN db_cs2_pmd_lock USING p_pmc01_old,g_pmd.pmd02,g_pmd.pmd06
             IF STATUS THEN
                LET g_msg_x = p_azp01,':pmd_file:lock'
                LET g_showmsg = g_pmd.pmd01,'/',g_pmd.pmd02,'/',g_pmd.pmd06
                CALL s_errmsg('pmd01,pmd02,pmd06',g_showmsg,g_msg_x,STATUS,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pmd_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH db_cs2_pmd_lock INTO l_pmd_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg_x = p_azp01,':pmd_file:lock'
                LET g_showmsg = g_pmd.pmd01,'/',g_pmd.pmd02,'/',g_pmd.pmd06
                CALL s_errmsg('pmd01,pmd02,pmd06',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pmd_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
            EXECUTE db_cs2_pmd USING g_pmd.*,p_pmc01_old,g_pmd.pmd02,g_pmd.pmd06
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_pmd.pmd01,'/',g_pmd.pmd02,'/',g_pmd.pmd06
               CALL s_errmsg('pmd01,pmd02,pmd06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
            CLOSE db_cs2_pmd_lock  #CHI-A60011 add
         END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_pmd.pmd01,'/',g_pmd.pmd02,'/',g_pmd.pmd06
            CALL s_errmsg('pmd01,pmd02,pmd06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_pmd.pmd01||'+'||g_pmd.pmd02||'+'||g_pmd.pmd06,'5')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_apmp600_pov(p_pmc01_old,p_pmc01_new,p_azp01,p_gew07)
   DEFINE p_pmc01_old     LIKE pmc_file.pmc01
   DEFINE p_pmc01_new     LIKE pmc_file.pmc01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_pov_2         RECORD LIKE pov_file.*  #CHI-A60011 add
 
   FOREACH pov_cur USING p_pmc01_old INTO g_pov.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pov01',g_pov.pov01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_pmc01_new) THEN LET g_pov.pov01 = p_pmc01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_pov.pov01,'+',g_pov.pov02,'+',g_pov.pov03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_pov.pov01,'+',g_pov.pov02,'+',g_pov.pov03,':'
      EXECUTE db_cs1_pov USING g_pov.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #No.FUN-A80036  --Begin
        #IF SQLCA.sqlcode = -239 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN                                                                                           
               MESSAGE g_msg3 CLIPPED,':exist'                                                                              
               LET g_success = 'N'    #No.FUN-A80036
               CALL ui.Interface.refresh()                                                                                  
            ELSE   
             #CHI-A60011 add --start--
             OPEN db_cs2_pov_lock USING p_pmc01_old,g_pov.pov02
             IF STATUS THEN
                LET g_msg_x = p_azp01,':pov_file:lock'
                LET g_showmsg = g_pov.pov01,'/',g_pov.pov02,'/',g_pov.pov03
                CALL s_errmsg('pov01,pov02,pov03',g_showmsg,g_msg_x,STATUS,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pov_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH db_cs2_pov_lock INTO l_pov_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg_x = p_azp01,':pov_file:lock'
                LET g_showmsg = g_pov.pov01,'/',g_pov.pov02,'/',g_pov.pov03
                CALL s_errmsg('pov01,pov02,pov03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                MESSAGE g_msg4,':fail'
                CALL ui.Interface.refresh()
                CLOSE db_cs2_pov_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
            EXECUTE db_cs2_pov USING g_pov.*,p_pmc01_old,g_pov.pov02  #,g_pov.pov03
            IF SQLCA.sqlcode = 0 THEN
               IF g_success = 'Y' THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               END IF
            ELSE
               LET g_msg_x = p_azp01,':upd'
               LET g_showmsg = g_pov.pov01,'/',g_pov.pov02,'/',g_pov.pov03
               CALL s_errmsg('pov01,pov02,pov03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg4,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
            CLOSE db_cs2_pov_lock  #CHI-A60011 add
         END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_pov.pov01,'/',g_pov.pov02,'/',g_pov.pov03
            CALL s_errmsg('pov01,pov02,pov03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_pov.pov01||'+'||g_pov.pov02,'5')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i610_dbs() 
   DEFINE l_ans         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
          l_exit_sw     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_cnt         LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_check       LIKE type_file.chr1    #CHI-A60035 add
   DEFINE l_gew03       LIKE gew_file.gew03    #CHI-A60035 add 
   DEFINE l_gev04       LIKE gev_file.gev04    #CHI-A60035 add
   DEFINE l_flag        LIKE type_file.chr1    #CHI-A60035 add
   DEFINE l_n           LIKE type_file.num5    #FUN-B90080 add

  #TQC-C50178 mark str---
  #IF g_pmca.pmca05='2' THEN
  #    #已拋轉，不可再異動!
  #    CALL cl_err(g_pmca.pmcano,'axm-225',1)
  #    LET g_success = 'N'
  #    RETURN
  #END IF
  #TQC-C50178 mark end---
 
  #IF g_pmca.pmca05!='1' THEN         #TQC-C50178 mark
   IF g_pmca.pmca05 NOT MATCHES '[12]' THEN   #TQC-C50178 add
       #不在確認狀態，不可異動！
       CALL cl_err('','atm-053',0)
       RETURN 
   END IF
 
   IF s_shut(0) THEN RETURN END IF
   
   IF g_pmca.pmca914 = 'Y' THEN #MOD-C50233 add
   #FUN-B90080 add --start--
         SELECT COUNT(*) INTO l_n FROM pmc_file
          WHERE pmc915 = g_pmca.pmca915
            AND pmc916 = g_pmca.pmca916
            AND pmc01 != g_pmca.pmca01
         IF l_n>0 THEN
            CALL cl_err('','apm-081',0)
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM pmc_file
          WHERE pmc917 = g_pmca.pmca917
            AND pmc918 = g_pmca.pmca918
            AND pmc01 != g_pmca.pmca01
         IF l_n>0 THEN
            CALL cl_err('','apm-081',0)
            RETURN
         END IF
   #FUN-B90080 add --end--   
   END IF #MOD-C50233 add
   
   CALL tm.clear()   #NO.FUN-840018
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file 
    WHERE gev01 = '5' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
   CALL s_showmsg_init()
 
   CALL s_carry_data_i600() 
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF

   #CHI-A60035 add --start--
   LET l_check = 'N' 
   FOR i = 1 TO tm.getLength()
       IF tm[i].sel = 'Y' THEN
          LET l_check = 'Y'
          EXIT FOR
       END IF
   END FOR

   SELECT gev04 INTO l_gev04 FROM gev_file
    WHERE gev01 = '5' and gev02 = g_plant
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = l_gev04
      AND gew02 = '5'
   #chech是否所有營運中心皆己存在此料號拋轉
   LET l_flag = 'N'
   FOR i = 1 TO tm.getLength()  
       IF tm[i].exist = 'N' THEN 
          LET l_flag = 'Y'
          EXIT FOR
       ELSE
          LET l_flag = 'N'
       END IF
   END FOR
   IF l_gew03 = '2' THEN  
       IF NOT cl_confirm('anm-929') THEN RETURN END IF    #是否確定拋轉以上資料?
   END IF              
   IF l_gew03 = '3' AND l_check ='N' AND l_flag = 'Y' THEN
      CALL cl_err('','aim-505',1)
      RETURN
   END IF
   IF l_check = 'N' AND l_flag = 'N' THEN
       CALL cl_err('','aim1009',1)
       RETURN #TQC-AB0107 add
   END IF 
   LET l_flag = ' '
   #CHI-A60035 add --end--
   #IF NOT cl_confirm('anm-929') THEN RETURN END IF    #是否確定拋轉以上資料? #CHI-A60035 mark

   #建立歷史資料拋轉的臨時表
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab   #CHI-A60011 add

    BEGIN WORK
 
   LET g_success='Y'
   FOR i = 1 TO tm.getLength()   #CHI-870044
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN LET g_success='N' CONTINUE FOR END IF 
       LET g_success='Y' 
       EXIT FOR      
   END FOR
   IF g_success = 'Y' THEN   #MOD-A50071
      IF g_pmca.pmca00 = 'I' THEN   #MOD-A50071 AND g_success='Y' THEN   #MOD-840117 modify g_success='Y'
         CALL i610_dbs_ins() #新增
      ELSE
         CALL i610_dbs_upd() #修改
      END IF
   END IF   #MOD-A50071
   IF g_success = 'Y' THEN
       #更新狀況碼
       UPDATE pmca_file
          SET pmca05 = '2' #已拋轉
        WHERE pmcano = g_pmca.pmcano
       IF SQLCA.sqlcode OR sqlca.sqlerrd[3] <= 0 THEN
           #狀況碼更新不成功
           CALL cl_get_feldname('pmca05',g_lang) RETURNING g_msg_i600
           CALL cl_err(g_msg_i600,'lib-030',1)
           LET g_success = 'N'
       END IF
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   CALL s_dc_drop_temp_table(l_hist_tab)   #CHI-A60011 add
   CALL s_showmsg()       #CHI-A60011 add
   SELECT * INTO g_pmca.* FROM pmca_file WHERE pmcano = g_pmca.pmcano   #No.TQC-9A0126 mod 
END FUNCTION              #                    apmi610
 
#資料拋轉時會用到的副程式
FUNCTION s_carry_data_i600()
   DEFINE l_pmcano       LIKE pmca_file.pmcano
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_arrno        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_ac           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_exit_sw      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_wc           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
          l_sql          LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
          l_time         LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          l_do_ok        LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
   DEFINE l_rec_b        LIKE type_file.num5     #No.FUN-610048  #No.FUN-680136 SMALLINT
   DEFINE l_cnt          LIKE type_file.num5     #TQC-740090 add
   DEFINE l_dbs          LIKE type_file.chr21    #TQC-740090 add
   DEFINE l_i            LIKE type_file.num5     #NO.FUN-840018
   DEFINE l_gew03        LIKE gew_file.gew03     #NO.FUN-840018
   DEFINE l_gev04        LIKE gev_file.gev04     #NO.FUN-840018
   DEFINE l_geu02        LIKE geu_file.geu02     #NO.FUN-840018
   DEFINE l_allow_insert  LIKE type_file.num5                 #可新增否 #NO.FUN-840018 
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否 #NO.FUN-840018
   DEFINE l_n            LIKE type_file.num5  #FUN-9A0092                                                                           
   DEFINE l_azw01        LIKE azw_file.azw01  #FUN-9A0092                                                                           
   DEFINE l_azw06        LIKE azw_file.azw06  #FUN-9A0092                                                                           
   DEFINE l_str          STRING               #FUN-9A0092   

   LET l_ac = 1
 
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = g_gev04
      AND gew02 = '5'
   IF SQLCA.sqlcode THEN
      IF SQLCA.sqlcode = -284 THEN
         LET l_gew03 = '3'
      END IF
   END IF
   #NO.FUN-840090 end----------
 
   #NO.FUN-840018 start-----------------------------
  #IF l_gew03 = '2' OR l_gew03 = '3' THEN              #NO.FUN-840090 #CHI-A60035 mark
   IF l_gew03 = '3' THEN      #CHI-A60035
       OPEN WINDOW s_dc_1_w AT 6,26 WITH FORM "sub/42f/s_dc_sel_db1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("s_dc_sel_db1")
 
       SELECT gev04 INTO l_gev04 FROM gev_file
        WHERE gev01 = '5' and gev02 = g_plant
       SELECT geu02 INTO l_geu02 FROM geu_file
        WHERE geu01 = l_gev04
       DISPLAY l_gev04 TO FORMONLY.gev04
       DISPLAY l_geu02 TO FORMONLY.geu02
    LET l_n = 0                                                                                                                     
    SELECT COUNT(*) INTO l_n FROM azw_file                                                                                          
     WHERE azw05 <> azw06                                                                                                           
    IF l_n  = 0  THEN                                                                                                               
       CALL cl_set_comp_visible("plant",FALSE)                                                                                      
    END IF                                                                                                                          
 
   END IF             #no.FUN-840090
 
     IF g_pmca.pmca00 = 'I' THEN #新增
        #IF l_gew03 = '1' OR l_gew03 = '2'  THEN  #NO.FUN-840090 #CHI-A60035 mark
         IF l_gew03 MATCHES '[123]' THEN  #CHI-A60035
            LET l_sql = " SELECT 'Y',gew04,azp02,azp03,' ','N' FROM gew_file,azp_file ", #FUN-9A0092    
                        "  WHERE gew01 = '",g_gev04,"'",
                        "    AND gew02 = '5'",
                        "    AND gew04 = azp01 "
            PREPARE s_carry_data_prepare1 FROM l_sql
            DECLARE azp_curs1 CURSOR FOR s_carry_data_prepare1
            
            FOREACH azp_curs1 INTO tm[l_ac].* 
               IF SQLCA.sqlcode != 0 THEN 
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               #看l_dbs資料庫是否存在此筆資料,若存在就給exist='Y'做備註
               LET l_cnt = NULL
               #CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs   #FUN-A50102 
               #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"pmc_file",
               LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'pmc_file'), #FUN-A50102
                           " WHERE pmc01 ='",g_pmca.pmca01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql #FUN-A50102
               PREPARE pmc_count_pre1 FROM l_sql
               EXECUTE pmc_count_pre1 INTO l_cnt
   
               IF NOT cl_null(l_cnt) THEN
                   #新增時,已存在的不能選取
                   #修改時,已存在的選取
                   IF g_pmca.pmca00 = 'I' THEN #新增
                       IF l_cnt >= 1 THEN
                           LET tm[l_ac].exist = 'Y'     #存在       #NO.FUN-840018 mod
                           LET tm[l_ac].sel     = 'N'     #選取      #NO.FUN-840018 mod
                       END IF
                   ELSE
                       IF l_cnt >= 1 THEN
                           LET tm[l_ac].exist = 'Y'     #存在     #NO.FUN-840018 mod
                           LET tm[l_ac].sel     = 'Y'     #選取     #NO.FUN-840018 mod
                       END IF
                   END IF
               END IF
          LET l_azw06 = NULL                                                                                                        
          LET l_azw01 = NULL                                                                                                        
          LET l_str = ''                                                                                                            
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[l_ac].azp01                                                     
          DECLARE s_dc_db1  CURSOR  FOR                                                                                             
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                                  
          FOREACH s_dc_db1  INTO l_azw01                                                                                            
            IF STATUS THEN                                                                                                          
               CALL cl_err('foreach:',STATUS,1)                                                                                     
               EXIT FOREACH                                                                                                         
            END IF                                                                                                                  
            IF l_azw01 = tm[l_ac].azp01 THEN                                                                                       
               LET l_azw01 = NULL                                                                                                   
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
            IF cl_null(l_str)  THEN                                                                                                 
               LET l_str = l_azw01                                                                                                  
            ELSE                                                                                                                    
               LET l_str = l_str,",",l_azw01                                                                                        
            END IF                                                                                                                  
          END FOREACH                                                                                                               
          LET tm[l_ac].plant = l_str                                                                                               
               LET l_ac = l_ac + 1
            END FOREACH
            CALL tm.deleteElement(g_cnt)
         END IF
     ELSE
          LET l_sql = " SELECT 'N',gew04,azp02,azp03,' ','N' ",   #FUN-9A0092 
            "   FROM gew_file,azp_file ",
            "  WHERE gew01 = '",g_gev04,"'",
            "    AND azp053 = 'Y' ",
            "    AND gew02 = '5'",
            "    AND gew04 = azp01 ",
            "  ORDER BY gew04 "
         PREPARE s_carry_data_prepare2 FROM l_sql
         DECLARE azp_curs2 CURSOR FOR s_carry_data_prepare2
         
         FOREACH azp_curs2 INTO tm[l_ac].* 
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            #看l_dbs資料庫是否存在此筆資料,若存在就給exist='Y'做備註
            LET l_cnt = NULL
            #CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs   #FUN-A50102
            #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"pmc_file",
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'pmc_file'), #FUN-A50102
                        " WHERE pmc01 ='",g_pmca.pmca01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql #FUN-A50102
            PREPARE pmc_count_pre2 FROM l_sql
            EXECUTE pmc_count_pre2 INTO l_cnt
   
            IF NOT cl_null(l_cnt) THEN
                #新增時,已存在的不能選取
                #修改時,已存在的選取
                IF g_pmca.pmca00 = 'I' THEN #新增
                    IF l_cnt >= 1 THEN
                        LET tm[l_ac].exist = 'Y'     #存在       #NO.FUN-840018 mod
                        LET tm[l_ac].sel     = 'N'     #選取      #NO.FUN-840018 mod
                    END IF
                ELSE
                    IF l_cnt >= 1 THEN
                        LET tm[l_ac].exist = 'Y'     #存在     #NO.FUN-840018 mod
                        LET tm[l_ac].sel     = 'Y'     #選取     #NO.FUN-840018 mod
                    END IF
                END IF
            END IF
          LET l_azw06 = NULL                                                                                                        
          LET l_azw01 = NULL                                                                                                        
          LET l_str = ''                                                                                                            
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[l_ac].azp01                                                     
          DECLARE s_dc_db2  CURSOR  FOR                                                                                             
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                                  
          FOREACH s_dc_db2  INTO l_azw01                                                                                            
            IF STATUS THEN                                                                                                          
               CALL cl_err('foreach:',STATUS,1)                                                                                     
               EXIT FOREACH                                                                                                         
            END IF                                                                                                                  
            IF l_azw01 = tm[l_ac].azp01 THEN                                                                                       
               LET l_azw01 = NULL                                                                                                   
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
            IF cl_null(l_str)  THEN                                                                                                 
               LET l_str = l_azw01                                                                                                  
            ELSE                                                                                                                    
               LET l_str = l_str,",",l_azw01                                                                                        
            END IF                                                                                                                  
          END FOREACH                                                                                                               
          LET tm[l_ac].plant = l_str                                                                                               
            LET l_ac = l_ac + 1
         END FOREACH
         CALL tm.deleteElement(g_cnt)
    END IF
 
     LET l_rec_b = l_ac -1   
      WHILE TRUE
         LET l_exit_sw = "n"
 
  #IF l_gew03 = '2' OR l_gew03 = '3' THEN              #NO.FUN-840090  #CHI-A60035 mark
   IF l_gew03 = '3' THEN         #CHI-A60035  
      IF g_pmca.pmca00 = 'U' THEN 
          LET l_allow_insert = FALSE
      ELSE
          LET l_allow_insert = TRUE
      END IF
 
      INPUT ARRAY tm WITHOUT DEFAULTS FROM s_azp.*     #NO.FUN-840018 mod
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=TRUE,APPEND ROW=l_allow_insert)   #FUN-840018 add
                   #INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
         BEFORE ROW   
            LET l_ac = ARR_CURR()
            #新增時,已存在的不能選取
            #修改時,不存在的不能選取
            IF g_pmca.pmca00 = 'I' THEN #新增
                IF tm[l_ac].exist = 'Y' THEN #存在   #NO.FUN-840018  mod
                    NEXT FIELD exist
                END IF
            ELSE
                IF tm[l_ac].exist = 'N' THEN #存在   #NO.FUN-840018  mod
                    IF l_ac <> l_rec_b THEN
                        NEXT FIELD exist
                    ELSE
                        EXIT INPUT
                    END IF
                END IF
            END IF
            CALL i600_610_set_entry( )
            CALL i600_610_set_no_entry(l_ac)
 
	 AFTER FIELD azp01
	    IF NOT cl_null(tm[l_ac].azp01) THEN
	       CALL i600_sel_db_azp01(l_ac)
	       IF NOT cl_null(g_errno) THEN
		  CALL cl_err(tm[l_ac].azp01,g_errno,0)
		  NEXT FIELD azp01
	       END IF
               #CALL s_getdbs_curr(tm1[l_ac].azp01) RETURNING l_dbs   #FUN-A50102
               #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"pmc_file",
               LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm1[l_ac].azp01,'pmc_file'), #FUN-A50102
                           " WHERE pmc01 ='",g_pmca.pmca01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,tm1[l_ac].azp01) RETURNING l_sql #FUN-A50102
               PREPARE pmc_count_pre3 FROM l_sql
               EXECUTE pmc_count_pre3 INTO l_cnt
   
               IF NOT cl_null(l_cnt) THEN
                   IF l_cnt >= 1 THEN
                       LET tm[l_ac].exist = 'Y'     #存在
                   ELSE
                       LET tm[l_ac].exist = 'N'
                   END IF
               END IF
               DISPLAY BY NAME tm[l_ac].exist
	    ELSE
	       LET tm[l_ac].azp02 = NULL
	       LET tm[l_ac].azp03 = NULL
	    END IF
      
           ON ACTION controlp
              CASE
                 WHEN INFIELD(azp01)        #azp_file
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gew04"
                      LET g_qryparam.arg1     = g_gev04
                      LET g_qryparam.arg2     = '5'
                      LET g_qryparam.default1 = tm[l_ac].azp01
                      CALL cl_create_qry() RETURNING tm[l_ac].azp01
                      CALL i600_sel_db_azp01(l_ac)
                      NEXT FIELD azp01
              END CASE
 
         ON ACTION accept
            LET l_exit_sw = 'y'
            EXIT INPUT     
      
      END INPUT   
   ELSE              #no.FUN-840090
      EXIT WHILE     #NO.FUN-840090
   END IF            #NO.FUN-840090
      
   IF INT_FLAG THEN 
      LET l_exit_sw = 'y'
   END IF
    IF l_exit_sw = "y" THEN 
      EXIT WHILE  
   END IF
END WHILE
 
IF l_gew03 = '3' THEN   #CHI-A60035 add
   CLOSE WINDOW s_dc_1_w      #NO.FUN-840018  add
END IF                  #CHI-A60035 add
END FUNCTION
 


FUNCTION i610_ins_imab(l_dbs) #新增主檔拋轉記錄檔
  DEFINE l_dbs        LIKE azp_file.azp03
 
    INSERT INTO imab_file(imab00,imabno,imab01,imabtype,imabdate,imabdb)
       VALUES (g_pmca.pmca00,g_pmca.pmcano,g_pmca.pmca01,'3',g_today,l_dbs)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","imab_file","apmi610","",SQLCA.sqlcode,"","",1)  
        LET g_success='N'
    END IF
    IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("ins","imab_file","apmi610","",'lib-028',"","",1)  
        LET g_success='N'
    END IF
END FUNCTION
 
FUNCTION i610_dbs_ins()
   DEFINE l_pmca        RECORD LIKE pmca_file.*  #061113
   DEFINE i             LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_all_cnt            LIKE type_file.num5    
   DEFINE l_cur_cnt            LIKE type_file.num5
   DEFINE l_pmca_ins           LIKE type_file.chr1    #NO.FUN-840068 add
   DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add 

   MESSAGE ' COPY FOR INSERT .... '
 
  #讀取相關資料..........................................
   SELECT * INTO l_pmca.* FROM pmca_file 
    WHERE pmcano = g_pmca.pmcano 
   IF STATUS THEN 
       CALL cl_err(g_msg_i600,SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
   LET l_pmca_ins = 'N'    #NO.FUN-840068 add
 
   FOR i = 1 TO tm.getLength()   #CHI-870044
       #建立歷史資料拋轉的臨時表
      #CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab #CHI-A60011 mark
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '5'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'5',l_hist_tab)                                                      
            RETURNING l_hs_flag,l_hs_path
 
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF    #NO.FUN-840018  mod
       #LET g_sql='INSERT INTO ',s_dbstring(tm[i].azp03 CLIPPED),'pmc_file(',            ##NO.FUN-840018  mod  #TQC-9B0011 mod
       LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'pmc_file'),'(', #FUN-A50102       
 ' pmc01  ,', 
 ' pmc02  ,', 
 ' pmc03  ,', 
 ' pmc04  ,', 
 ' pmc05  ,', 
 ' pmc06  ,', 
 ' pmc07  ,', 
 ' pmc081 ,', 
 ' pmc082 ,', 
 ' pmc091 ,', 
 ' pmc092 ,', 
 ' pmc093 ,', 
 ' pmc094 ,', 
 ' pmc095 ,', 
 ' pmc10  ,', 
 ' pmc11  ,', 
 ' pmc12  ,', 
 ' pmc13  ,', 
 ' pmc14  ,', 
 ' pmc15  ,', 
 ' pmc16  ,', 
 ' pmc17  ,', 
 ' pmc18  ,', 
 ' pmc19  ,', 
 ' pmc20  ,', 
 ' pmc21  ,', 
 ' pmc22  ,', 
 ' pmc23  ,', 
 ' pmc24  ,', 
 ' pmc25  ,', 
 ' pmc26  ,', 
 ' pmc27  ,', 
 ' pmc28  ,', 
 ' pmc281 ,',   #CHI-C20021 add 
 ' pmc30  ,', 
 ' pmc40  ,', 
 ' pmc41  ,', 
 ' pmc42  ,', 
 ' pmc43  ,', 
 ' pmc44  ,', 
 ' pmc45  ,', 
 ' pmc46  ,', 
 ' pmc47  ,', 
 ' pmc48  ,', 
 ' pmc49  ,', 
 ' pmc50  ,', 
 ' pmc51  ,', 
 ' pmc52  ,', 
 ' pmc53  ,', 
 ' pmc54  ,', 
 ' pmc55  ,', 
 ' pmc56  ,', 
 ' pmc901 ,', 
 ' pmc902 ,', 
 ' pmc903 ,', 
 ' pmc904 ,', 
 ' pmc905 ,', 
 ' pmc906 ,', 
 ' pmc907 ,', 
 ' pmc908 ,', 
 ' pmc909 ,', 
 ' pmc910 ,', 
 ' pmc911 ,', 
 ' pmc912 ,',    #TQC-AB0107  add
 ' pmc914 ,',    #FUN-B90080 add
 ' pmc915 ,',    #FUN-B90080 add
 ' pmc916 ,',    #FUN-B90080 add
 ' pmc917 ,',    #FUN-B90080 add
 ' pmc918 ,',    #FUN-B90080 add
 ' pmc919 ,',    #FUN-B90080 add
 ' pmc920 ,',    #FUN-B90080 add
 ' pmc921 ,',    #FUN-B90080 add
 ' pmc922 ,',    #FUN-B90080 add
 ' pmc923 ,',    #FUN-B90080 add
 ' pmcacti,', 
 ' pmcuser,', 
 ' pmcgrup,',
 ' pmcoriu,',    #TQC-A10060  add
 ' pmcorig,',    #TQC-A10060  add 
 ' pmcmodu,', 
 ' pmcdate,', 
 ' pmcud01,', 
 ' pmcud02,', 
 ' pmcud03,', 
 ' pmcud04,', 
 ' pmcud05,', 
 ' pmcud06,', 
 ' pmcud07,', 
 ' pmcud08,', 
 ' pmcud09,', 
 ' pmcud10,', 
 ' pmcud11,', 
 ' pmcud12,', 
 ' pmcud13,',
 ' pmcud14,',
 ' pmcud15,',
 ' pmc59  ,',    #TQC-A40128
 ' pmc60  ,',    #TQC-A40128
 ' pmccrat,',    #TQC-A40128
 ' pmc1920   )',  #MOD-840390    資料來源     #MOD-930086
 ' VALUES(',
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #10
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #20
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #30
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #40
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #50
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #60
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #70
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #80
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #90 #FUN-B90080 add
 ' ?,?,?,?,?,  ?,?,?,?,? )'    #TQC-A40128   #TQC-A10060  add ?,?    #83   #MOD-840390  #MOD-AA0174 add ? #TQC-AB0107 add ?
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql #FUN-A50102
       PREPARE ins_pmc FROM g_sql
       EXECUTE ins_pmc USING
     l_pmca.pmca01  , 
     l_pmca.pmca02  , 
     l_pmca.pmca03  , 
     l_pmca.pmca04  , 
     l_pmca.pmca05  , 
     l_pmca.pmca06  , 
     l_pmca.pmca07  , 
     l_pmca.pmca081 , 
     l_pmca.pmca082 , 
     l_pmca.pmca091 , 
     l_pmca.pmca092 , 
     l_pmca.pmca093 , 
     l_pmca.pmca094 , 
     l_pmca.pmca095 , 
     l_pmca.pmca10  , 
     l_pmca.pmca11  , 
     l_pmca.pmca12  , 
     l_pmca.pmca13  , 
     l_pmca.pmca14  , 
     l_pmca.pmca15  , 
     l_pmca.pmca16  , 
     l_pmca.pmca17  , 
     l_pmca.pmca18  , 
     l_pmca.pmca19  , 
     l_pmca.pmca20  , 
     l_pmca.pmca21  , 
     l_pmca.pmca22  , 
     l_pmca.pmca23  , 
     l_pmca.pmca24  , 
     l_pmca.pmca25  , 
     l_pmca.pmca26  , 
     l_pmca.pmca27  , 
     l_pmca.pmca28  , 
     l_pmca.pmca281 ,    #CHI-C20021 add
     l_pmca.pmca30  , 
     l_pmca.pmca40  , 
     l_pmca.pmca41  , 
     l_pmca.pmca42  , 
     l_pmca.pmca43  , 
     l_pmca.pmca44  , 
     l_pmca.pmca45  , 
     l_pmca.pmca46  , 
     l_pmca.pmca47  , 
     l_pmca.pmca48  , 
     l_pmca.pmca49  , 
     l_pmca.pmca50  , 
     l_pmca.pmca51  , 
     l_pmca.pmca52  , 
     l_pmca.pmca53  , 
     l_pmca.pmca54  , 
     l_pmca.pmca55  , 
     l_pmca.pmca56  , 
     l_pmca.pmca901 , 
     l_pmca.pmca902 , 
     l_pmca.pmca903 , 
     l_pmca.pmca904 , 
     l_pmca.pmca905 , 
     l_pmca.pmca906 , 
     l_pmca.pmca907 , 
     l_pmca.pmca908 , 
     l_pmca.pmca909 , 
     l_pmca.pmca910 , 
     l_pmca.pmca911 , 
     'Y',      #TQC-AB0107  add
     l_pmca.pmca914 , #FUN-B90080 add 
     l_pmca.pmca915 , #FUN-B90080 add
     l_pmca.pmca916 , #FUN-B90080 add
     l_pmca.pmca917 , #FUN-B90080 add
     l_pmca.pmca918 , #FUN-B90080 add
     l_pmca.pmca919 , #FUN-B90080 add
     l_pmca.pmca920 , #FUN-B90080 add
     l_pmca.pmca921 , #FUN-B90080 add
     l_pmca.pmca922 , #FUN-B90080 add
     l_pmca.pmca923 , #FUN-B90080 add
     l_pmca.pmcaacti, 
     g_user,   #資料所有者  
     g_grup,   #資料所有部門
     g_user,   #TQC-A10060  add
     g_grup,   #TQC-A10060  add
     '',       #資料修改者  
     g_today,  #最近修改日  
     l_pmca.pmcaud01, 
     l_pmca.pmcaud02, 
     l_pmca.pmcaud03, 
     l_pmca.pmcaud04, 
     l_pmca.pmcaud05, 
     l_pmca.pmcaud06, 
     l_pmca.pmcaud07, 
     l_pmca.pmcaud08, 
     l_pmca.pmcaud09, 
     l_pmca.pmcaud10, 
     l_pmca.pmcaud11, 
     l_pmca.pmcaud12, 
     l_pmca.pmcaud13,
     l_pmca.pmcaud14,
     l_pmca.pmcaud15,  #MOD-840390  
     '1',              #TQC-A40128
     '0000000',        #TQC-A40128
     g_today,          #TQC-A40128
     g_plant           #MOD-840390  
 
#-------------------- COPY FILE ------------------------------
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #LET g_msg_i600 = 'INSERT ',s_dbstring(tm[i].azp03 CLIPPED),'pmc_file'   #NO.FUN-840018  mod  #TQC-9B0011 mod
           LET g_msg_i600 = 'INSERT ',cl_get_target_table(tm[i].azp01,'pmc_file') #FUN-A50102
           CALL cl_err(g_msg_i600,'lib-028',1)
           LET g_success = 'N'
           LET l_pmca_ins = 'N'  #NO.FUN-840068 add
           EXIT FOR
       ELSE
           CALL s_upd_abbr(l_pmca.pmca01,l_pmca.pmca03,tm[i].azp01,'1','Y','a')  #No.FUN-BB0049
           CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_pmca.pmca01,'5') #NO.FUN-840018  add
           CALL i610_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔    ##NO.FUN-840018  mod
           IF g_success = 'N' THEN EXIT FOR END IF
           LET l_pmca_ins = 'Y'  #NO.FUN-840068 add
       END IF
      #CALL i610_dbs_doc(tm[i].azp01)  #FUN-C90089 add    #CHI-CB0017 mark

       #CHI-CB0017 add begin---
       IF g_prog = 'apmi610' THEN
          LET l_value1 = g_pmca.pmcano
          LET l_value2 = g_pmca.pmca01
       END IF
       IF g_prog = 'apmi600' THEN
          LET l_value1 = g_pmc.pmc01
          LET l_value2 = g_pmc.pmc01
       END IF
       CALL s_data_transfer(tm[i].azp01,'3',g_prog,l_value1,l_value2,'','','')
       #CHI-CB0017 add end-----

       IF l_pmca_ins ='Y' THEN   #NO.FUN-840068 add
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)                                                  
       END IF                    #NO.FUN-840068 add
    END FOR
 
   #CALL s_dc_drop_temp_table(l_hist_tab) #CHI-A60011 mark
    IF l_pmca_ins ='Y' THEN  #NO.FUN-840068 add
     #  MESSAGE 'Data Carry Finish!'      #TQC-AC0254 mark
        CALL cl_err('','aim-162',0)      #TQC-AC0254      
        CALL ui.Interface.refresh()       
    END IF                   #NO.FUN-840068 add
 
END FUNCTION
 
FUNCTION i610_dbs_upd()    
   DEFINE l_pmca        RECORD LIKE pmca_file.*,
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         #l_sql         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(9000) #CHI-A80049 mark
          l_sql         STRING,                                           #CHI-A80049
          l_cnt         LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_all_cnt            LIKE type_file.num5    
   DEFINE l_cur_cnt            LIKE type_file.num5
   DEFINE l_pmca_upd           LIKE type_file.chr1     #NO.FUN-840068 add
   DEFINE l_pmc03_t            LIKE pmc_file.pmc03     #No.FUN-A30110
   DEFINE l_pmc_2       RECORD LIKE pmc_file.* #CHI-A60011 add
   DEFINE l_value1             LIKE type_file.chr30    #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30    #CHI-CB0017 add 

   MESSAGE ' COPY FOR THE UPDATE .... '  #No.FUN-B80088---增加THE避免系統檢測到FOR UPDATE---
  #讀取相關資料..........................................
 
   LET g_sql='SELECT * FROM pmca_file WHERE pmcano="',g_pmca.pmcano CLIPPED,'" '
   PREPARE s_pmca_p FROM g_sql
   DECLARE s_pmca CURSOR FOR s_pmca_p
   LET l_pmca_upd = 'N'  #NO.FUN-840068 add
 
   FOR i = 1 TO tm.getLength()   #CHI-870044
       #建立歷史資料拋轉的臨時表
      #CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab #CHI-A60011 mark
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '5'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'5',l_hist_tab)                                                      
            RETURNING l_hs_flag,l_hs_path
 
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF      #NO.FUN-840018  mod
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(tm[i].azp03 CLIPPED),'pmca_file ',    #NO.FUN-840018  mod  #TQC-9B0011 mod
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm[i].azp01,'pmca_file'), #FUN-A50102
                 ' WHERE pmcano = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							

       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql #FUN-A50102	          
       PREPARE c_pmca_p FROM g_sql
       DECLARE c_pmca CURSOR FOR c_pmca_p

       #No.FUN-A30110  --Begin
       #LET g_sql='SELECT pmc03 FROM ',s_dbstring(tm[i].azp03 CLIPPED),'pmc_file ', 
       LET g_sql='SELECT pmc03 FROM ',cl_get_target_table(tm[i].azp01,'pmc_file'), #FUN-A50102
                 ' WHERE pmc01 = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							

       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql #FUN-A50102	          
       PREPARE pmc03_p1  FROM g_sql
       DECLARE pmc03_cs1 CURSOR FOR pmc03_p1
       #No.FUN-A30110  --End   
 
       #-------------------- UPDATE FILE: pmca_file ------------------------------
       MESSAGE ' COPY FOR THE UPDATE pmca_file .... '  #No.FUN-B80088---增加THE避免系統檢測到FOR UPDATE---
       FOREACH s_pmca INTO l_pmca.*
          IF STATUS THEN
             CALL cl_err('foreach pmca',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_pmca USING l_pmca.pmcano
          FETCH c_pmca INTO l_cnt
             #CHI-A60011 add --start--
             LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(tm[i].azp01,'pmc_file'),
                                " WHERE pmc01=? FOR UPDATE"
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
             CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
             CALL cl_parse_qry_sql(g_forupd_sql,tm[i].azp01) RETURNING g_forupd_sql
             DECLARE i610_cs2_pmc_lock CURSOR FROM g_forupd_sql
             OPEN i610_cs2_pmc_lock USING l_pmca.pmca01
             IF STATUS THEN
                LET g_msg_i600 = tm[i].azp03 CLIPPED,':pmc_file:lock'
                LET g_showmsg=tm1[i].dbs,'/',l_pmca.pmca01
                CALL s_errmsg('azp03,pmc01',g_showmsg,g_msg_i600,STATUS,1)
                CLOSE i610_cs2_pmc_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH i610_cs2_pmc_lock INTO l_pmc_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg_i600 = tm[i].azp03 CLIPPED,':pmc_file:lock'
                LET g_showmsg=tm1[i].dbs,'/',l_pmca.pmca01
                CALL s_errmsg('azp03,pmc01',g_showmsg,g_msg_i600,SQLCA.SQLCODE,1)
                CLOSE i610_cs2_pmc_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
          #No.FUN-A30110  --Begin
          OPEN pmc03_cs1 USING l_pmca.pmca01
          FETCH pmc03_cs1 INTO l_pmc03_t
          #No.FUN-A30110  --End  
             #LET l_sql='UPDATE ',s_dbstring(tm[i].azp03 CLIPPED),'pmc_file ',   #NO.FUN-840018  mod  #TQC-9B0011 mod
             LET l_sql='UPDATE ',cl_get_target_table(tm[i].azp01,'pmc_file'), #FUN-A50102
                      #CHI-A80049 mark --start--
                      #'   SET pmc03  =? ,pmc081 =?,',
                      #'       pmc082 =? ,pmc24  =?,',
                      #'       pmcmodu=? ,pmcdate=?, ', #MOD-840390
                      #'       pmc1920=? ',              #MOD-840390
                      #CHI-A80049 mark --end--
                      #CHI-A80049 mom --start--
                       '   SET pmc02=?  ,', 
                       '       pmc03=?  ,', 
                       '       pmc04=?  ,', 
                       '       pmc05=?  ,', 
                       '       pmc06=?  ,', 
                       '       pmc07=?  ,', 
                       '       pmc081=? ,', 
                       '       pmc082=? ,', 
                       '       pmc091=? ,', 
                       '       pmc092=? ,', 
                       '       pmc093=? ,', 
                       '       pmc094=? ,', 
                       '       pmc095=? ,', 
                       '       pmc10=?  ,', 
                       '       pmc11=?  ,', 
                       '       pmc12=?  ,', 
                       '       pmc13=?  ,', 
                       '       pmc14=?  ,', 
                       '       pmc15=?  ,', 
                       '       pmc16=?  ,', 
                       '       pmc17=?  ,', 
                       '       pmc18=?  ,', 
                       '       pmc19=?  ,', 
                       '       pmc20=?  ,', 
                       '       pmc21=?  ,', 
                       '       pmc22=?  ,', 
                       '       pmc23=?  ,', 
                       '       pmc24=?  ,', 
                       '       pmc25=?  ,', 
                       '       pmc26=?  ,', 
                       '       pmc27=?  ,', 
                       '       pmc28=?  ,', 
                       '       pmc281=?  ,',    #CHI-C20021 add
                       '       pmc30=?  ,', 
                       '       pmc40=?  ,', 
                       '       pmc41=?  ,', 
                       '       pmc42=?  ,', 
                       '       pmc43=?  ,', 
                       '       pmc44=?  ,', 
                       '       pmc45=?  ,', 
                       '       pmc46=?  ,', 
                       '       pmc47=?  ,', 
                       '       pmc48=?  ,', 
                       '       pmc49=?  ,', 
                       '       pmc50=?  ,', 
                       '       pmc51=?  ,', 
                       '       pmc52=?  ,', 
                       '       pmc53=?  ,', 
                       '       pmc54=?  ,', 
                       '       pmc55=?  ,', 
                       '       pmc56=?  ,', 
                       '       pmc901=? ,', 
                       '       pmc902=? ,', 
                       '       pmc903=? ,', 
                       '       pmc904=? ,', 
                       '       pmc905=? ,', 
                       '       pmc906=? ,', 
                       '       pmc907=? ,', 
                       '       pmc908=? ,', 
                       '       pmc909=? ,', 
                       '       pmc910=? ,', 
                       '       pmc911=? ,', 
                      #FUN-B90080 add --start--
                       '       pmc914=? ,', 
                       '       pmc915=? ,', 
                       '       pmc916=? ,', 
                       '       pmc917=? ,', 
                       '       pmc918=? ,', 
                       '       pmc919=? ,', 
                       '       pmc920=? ,', 
                       '       pmc921=? ,', 
                       '       pmc922=? ,', 
                       '       pmc923=? ,', 
                      #FUN-B90080 add --end-- 
                       '       pmcacti=?,', 
                       '       pmcuser=?,', 
                       '       pmcgrup=?,', 
                       '       pmcmodu=?,', 
                       '       pmcdate=?,', 
                       '       pmcud01=?,', 
                       '       pmcud02=?,', 
                       '       pmcud03=?,', 
                       '       pmcud04=?,', 
                       '       pmcud05=?,', 
                       '       pmcud06=?,', 
                       '       pmcud07=?,', 
                       '       pmcud08=?,', 
                       '       pmcud09=?,', 
                       '       pmcud10=?,', 
                       '       pmcud11=?,', 
                       '       pmcud12=?,', 
                       '       pmcud13=?,',
                       '       pmcud14=?,',
                       '       pmcud15=?,',
                       '       pmc1920=?',
                      #CHI-A80049 mom --end--
                       ' WHERE pmc01 =? '
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							

             CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql #FUN-A50102	              
             PREPARE u_pmca FROM l_sql
            #CHI-A80049 mark --start--
            #EXECUTE u_pmca USING l_pmca.pmca03 ,l_pmca.pmca081, 
            #                     l_pmca.pmca082,l_pmca.pmca24 ,
            #                     g_user,g_today,g_plant, #MOD-840390
            #                     l_pmca.pmca01
            #CHI-A80049 mark --end--
            #CHI-A80049 mod --start--
             EXECUTE u_pmca USING l_pmca.pmca02, 
                                  l_pmca.pmca03, 
                                  l_pmca.pmca04, 
                                  l_pmca.pmca05, 
                                  l_pmca.pmca06, 
                                  l_pmca.pmca07, 
                                  l_pmca.pmca081, 
                                  l_pmca.pmca082, 
                                  l_pmca.pmca091, 
                                  l_pmca.pmca092, 
                                  l_pmca.pmca093, 
                                  l_pmca.pmca094, 
                                  l_pmca.pmca095, 
                                  l_pmca.pmca10, 
                                  l_pmca.pmca11, 
                                  l_pmca.pmca12, 
                                  l_pmca.pmca13, 
                                  l_pmca.pmca14, 
                                  l_pmca.pmca15, 
                                  l_pmca.pmca16, 
                                  l_pmca.pmca17, 
                                  l_pmca.pmca18, 
                                  l_pmca.pmca19, 
                                  l_pmca.pmca20, 
                                  l_pmca.pmca21, 
                                  l_pmca.pmca22, 
                                  l_pmca.pmca23, 
                                  l_pmca.pmca24, 
                                  l_pmca.pmca25, 
                                  l_pmca.pmca26, 
                                  l_pmca.pmca27, 
                                  l_pmca.pmca28, 
                                  l_pmca.pmca281,    #CHI-C20021 add
                                  l_pmca.pmca30, 
                                  l_pmca.pmca40, 
                                  l_pmca.pmca41, 
                                  l_pmca.pmca42, 
                                  l_pmca.pmca43, 
                                  l_pmca.pmca44, 
                                  l_pmca.pmca45, 
                                  l_pmca.pmca46, 
                                  l_pmca.pmca47, 
                                  l_pmca.pmca48, 
                                  l_pmca.pmca49, 
                                  l_pmca.pmca50, 
                                  l_pmca.pmca51, 
                                  l_pmca.pmca52, 
                                  l_pmca.pmca53, 
                                  l_pmca.pmca54, 
                                  l_pmca.pmca55, 
                                  l_pmca.pmca56, 
                                  l_pmca.pmca901, 
                                  l_pmca.pmca902, 
                                  l_pmca.pmca903, 
                                  l_pmca.pmca904, 
                                  l_pmca.pmca905, 
                                  l_pmca.pmca906, 
                                  l_pmca.pmca907, 
                                  l_pmca.pmca908, 
                                  l_pmca.pmca909, 
                                  l_pmca.pmca910, 
                                  l_pmca.pmca911, 
                                 #FUN-B90080 add --start--
                                  l_pmca.pmca914, 
                                  l_pmca.pmca915, 
                                  l_pmca.pmca916, 
                                  l_pmca.pmca917, 
                                  l_pmca.pmca918, 
                                  l_pmca.pmca919, 
                                  l_pmca.pmca920, 
                                  l_pmca.pmca921, 
                                  l_pmca.pmca922, 
                                  l_pmca.pmca923,
                                 #FUN-B90080 add --end-- 
                                  l_pmca.pmcaacti, 
                                  g_user, 
                                  l_pmca.pmcagrup, 
                                  l_pmca.pmcamodu, 
                                  g_today, 
                                  l_pmca.pmcaud01, 
                                  l_pmca.pmcaud02, 
                                  l_pmca.pmcaud03, 
                                  l_pmca.pmcaud04, 
                                  l_pmca.pmcaud05, 
                                  l_pmca.pmcaud06, 
                                  l_pmca.pmcaud07, 
                                  l_pmca.pmcaud08, 
                                  l_pmca.pmcaud09, 
                                  l_pmca.pmcaud10, 
                                  l_pmca.pmcaud11, 
                                  l_pmca.pmcaud12, 
                                  l_pmca.pmcaud13,
                                  l_pmca.pmcaud14,
                                  l_pmca.pmcaud15,
                                  g_plant,
                                  l_pmca.pmca01  #where
            #CHI-A80049 mod --end--
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 #LET g_msg_i600 = 'UPDATE ',s_dbstring(tm[i].azp03 CLIPPED),'pmc_file'    #NO.FUN-840018 mod  #TQC-9B0011 mod
                 LET g_msg_i600 = 'UPDATE ',cl_get_target_table(tm[i].azp01,'pmc_file') #FUN-A50102 
                 #CALL cl_err(g_msg_i600,'lib-028',1) #CHI-A60011 mark
                 #CHI-A60011 add --start--
                 LET g_showmsg=tm1[i].dbs,'/',l_pmca.pmca01
                 CALL s_errmsg('azp03,pmc01',g_showmsg,g_msg_i600,'lib-028',1)
                 #CHI-A60011 add --end--
                 LET g_success = 'N'
                 LET l_pmca_upd = 'N'   #NO.FUN-840068 add
                 EXIT FOREACH
             ELSE
                 #No.FUN-A30110  --Begin
                 IF NOT (l_pmca.pmca01 MATCHES 'MISC*' OR l_pmca.pmca01 MATCHES 'EMPL*') THEN    #No.TQC-BB0002
                    IF l_pmca.pmca03 <> l_pmc03_t THEN
                       #CALL s_upd_abbr(l_pmca.pmca01,l_pmca.pmca03,tm[i].azp03,'1','Y')
                       CALL s_upd_abbr(l_pmca.pmca01,l_pmca.pmca03,tm[i].azp01,'1','Y','u')  #FUN-A50102   #No.FUN-BB0049
                    END IF
                 END IF     #No.TQC-BB0002
                 #No.FUN-A30110  --End
                 CALL i610_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔           #NO.FUN-840018 mod
                 CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_pmca.pmca01,'5')   #NO.FUN-840018  ADD
                 IF g_success = 'N' THEN EXIT FOREACH END IF
                 LET l_pmca_upd ='Y'   #NO.FUN-840068 add
             END IF
             CLOSE i610_cs2_pmc_lock  #CHI-A60011 add
       END FOREACH
      #CALL i610_dbs_doc(tm[i].azp01)  #FUN-C90089 add    #CHI-CB0017 mark

       #CHI-CB0017 add begin---
       IF g_prog = 'apmi610' THEN
          LET l_value1 = g_pmca.pmcano
          LET l_value2 = g_pmca.pmca01
       END IF
       IF g_prog = 'apmi600' THEN
          LET l_value1 = g_pmc.pmc01
          LET l_value2 = g_pmc.pmc01
       END IF
       CALL s_data_transfer(tm[i].azp01,'3',g_prog,l_value1,l_value2,'','','')
       #CHI-CB0017 add end-----

       IF l_pmca_upd = 'Y' THEN   #NO.FUN-840068 add
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)                                                  
       END IF                     #NO.FUN-840068 add
   END FOR
 
  #CALL s_dc_drop_temp_table(l_hist_tab)  #CHI-A60011 mark
   IF l_pmca_upd = 'Y' THEN  #NO.FUN-840068 add
    #  MESSAGE 'Data Carry Finish!'         #TQC-AC0254 mark
       CALL cl_err('','aim-162',0)      #TQC-AC0254
       CALL ui.Interface.refresh()        
   END IF                    #NO.FUN-840068 add
END FUNCTION
 
FUNCTION s_apmi600_download(p_pmc)                                                                                  
   DEFINE p_pmc   DYNAMIC ARRAY OF RECORD                                                                               
                   sel      LIKE type_file.chr1,                                                                         
                   pmc01    LIKE pmc_file.pmc01                                                                          
                  END RECORD                                                                                            
    DEFINE l_path           LIKE ze_file.ze03                                                                                     
    DEFINE l_i              LIKE type_file.num10                                                                                  
                                                                                                                               
     FOR l_i = 1 TO p_pmc.getLength()                                                                                        
          LET g_pmc_1[l_i].* = p_pmc[l_i].*                                                                                   
     END FOR                                                                                                                 
 
    CALL s_dc_download_path() RETURNING l_path                                                                              
    CALL s_apmi600_download_files(p_pmc,l_path)                                                                              
                                                                                                                             
END FUNCTION
 
FUNCTION s_apmi600_download_files(pp_pmc,p_path)
  DEFINE pp_pmc   DYNAMIC ARRAY OF RECORD                                                                               
                   sel      LIKE type_file.chr1,                                                                         
                   pmc01    LIKE pmc_file.pmc01                                                                          
                  END RECORD
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_tempdir         LIKE type_file.chr50
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5 
  DEFINE l_pov01           LIKE pov_file.pov01
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
   CALL s_apmi600_carry_p1() RETURNING l_tabname   
   
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_pmc_file_5.txt'    #NO.FUN-820028
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_pmc_file_5.txt"     #NO.FUN-820028
   
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
   ######################pnp_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_pnp_file_5.txt'   #NO.FUN-820028
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_pnp_file_5.txt"    #NO.FUN-820028
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM pnp_file WHERE ",
               "   pnp01 IN (SELECT pmc01 FROM ",l_tabname CLIPPED,")"
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
  ######################pmf_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_pmf_file_5.txt'  #NO.FUN-820028
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_pmf_file_5.txt"   #NO.FUN-820028
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM pmf_file WHERE ",
               "   pmf01 IN (SELECT pmc01 FROM ",l_tabname CLIPPED,")"
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
    ######################pmg_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_pmg_file_5.txt'   #NO.FUN-820028
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_pmg_file_5.txt"    #NO.FUN-820028
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM pmg_file WHERE ",
               "   pmg01 IN (SELECT pmc01 FROM ",l_tabname CLIPPED,")"
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
    ######################pmd_file
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_pmd_file_5.txt'  #NO.FUN-820028
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_pmd_file_5.txt"   #NO.FUN-820028
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM pmd_file WHERE ",
               "   pmd01 IN (SELECT pmc01 FROM ",l_tabname CLIPPED,")"
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
    ######################pov_file
   #LET l_pov01= '0' 
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog,'_pov_file_5.txt'  #NO.FUN-820028
   LET l_download_file = p_path CLIPPED,"/",g_prog,"_pov_file_5.txt"   #NO.FUN-820028
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM pov_file WHERE pov01 = '0'", 
               "  and pov02 IN (SELECT pmc01 FROM ",l_tabname CLIPPED,")"
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
 
FUNCTION s_apmi600_carry_p1() 
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                    #No.FUN-A80036         
   DEFINE l_str                STRING                    #No.FUN-A80036
   
   CALL s_dc_cre_temp_table("pmc_file") RETURNING l_tabname
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX pmc_file_bak_01 ON ",l_tabname CLIPPED,"(pmc01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(pmc01)"
   #No.FUN-A80036  --End  
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM pmc_file",
                                                 "  WHERE pmc01 = ?"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF                                                                        
      IF g_flagx <> '1' THEN 
        FOR l_i = 1 TO g_pmc_1.getLength()
           IF cl_null(g_pmc_1[l_i].pmc01) THEN
              CONTINUE FOR
           END IF
           IF g_pmc_1[l_i].sel = 'N' THEN
              CONTINUE FOR
           END IF
           EXECUTE ins_pp USING g_pmc_1[l_i].pmc01
           IF SQLCA.sqlcode THEN
              LET l_str = "ins ",l_tabname                   #No.FUN-A80036      
              IF g_bgerr THEN                                                    
                 CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  #No.FUN-A80036      
              ELSE                                                               
                 CALL cl_err(l_str,SQLCA.sqlcode,1)          #No.FUN-A80036      
              END IF
              CONTINUE FOR
           END IF
           LET g_all_cnt = g_all_cnt + 1
         END FOR
     ELSE
       LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM pmc_file_bak1"                                          
       PREPARE ins_ppx1 FROM g_sql                                                                                            
       EXECUTE ins_ppx1                                                                                                       
       LET g_sql = " SELECT COUNT(*) FROM ",l_tabname                                                                        
       PREPARE cnt_ppx1 FROM g_sql                                                                                            
       EXECUTE cnt_ppx1 INTO g_all_cnt                                                                                        
       IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF                                                                   
     END IF                                                                                                                   
   RETURN l_tabname
END FUNCTION  
 
FUNCTION s_apmi600_carry_p2() 
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                    #No.FUN-A80036         
   DEFINE l_str                STRING                    #No.FUN-A80036
   
   CALL s_dc_cre_temp_table("pmc_file") RETURNING l_tabname
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX pmc_file_bak_01 ON ",l_tabname CLIPPED,"(pmc01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(pmc01)"
   #No.FUN-A80036  --End  
   PREPARE unique_p2 FROM g_sql
   EXECUTE unique_p2
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM pmc_file",
                                                 "  WHERE pmc01 = ?"
   PREPARE ins_pp2 FROM g_sql
 
   LET g_all_cnt = 0
 
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_pmc_p.getLength()
          IF cl_null(g_pmc_p[l_i].pmc01) THEN
             CONTINUE FOR
          END IF
          IF g_pmc_p[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          EXECUTE ins_pp2 USING g_pmc_p[l_i].pmc01
          IF SQLCA.sqlcode THEN
             LET l_str = "ins ",l_tabname                   #No.FUN-A80036      
             IF g_bgerr THEN                                                    
                CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  #No.FUN-A80036      
             ELSE                                                               
                CALL cl_err(l_str,SQLCA.sqlcode,1)          #No.FUN-A80036      
             END IF
             CONTINUE FOR
          END IF
          LET g_all_cnt = g_all_cnt + 1
       END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM pmc_file_bak1"                                          
      PREPARE ins_ppx FROM g_sql                                                                                            
      EXECUTE ins_ppx                                                                                                       
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname                                                                        
      PREPARE cnt_ppx FROM g_sql                                                                                            
      EXECUTE cnt_ppx INTO g_all_cnt                                                                                        
      IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF                                                                   
  END IF                                                                                                                   
 
   RETURN l_tabname
END FUNCTION    
 
FUNCTION i600_610_set_entry()
         CALL cl_set_comp_entry("azp01",TRUE)
END FUNCTION
 
FUNCTION i600_610_set_no_entry(p_i)
DEFINE p_i  LIKE type_file.num5
 
    IF (tm[p_i].exist = 'Y') OR g_pmca.pmca00 = 'U' AND cl_null(tm[p_i].exist) THEN
         CALL cl_set_comp_entry("azp01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i600_sel_db_azp01(i)
    DEFINE i       LIKE type_file.num10
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_azp02   LIKE azp_file.azp02
    DEFINE l_azp03   LIKE azp_file.azp03
    DEFINE l_gew04   LIKE gew_file.gew04
 
    LET g_errno = ' '
    SELECT azp02,azp03 INTO l_azp02,l_azp03
      FROM azp_file WHERE azp01=tm[i].azp01
    CASE
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF cl_null(g_errno) THEN
       SELECT gew04 INTO l_gew04 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 ='5' 
          AND gew04 = tm[i].azp01
       CASE
           WHEN STATUS=100        LET g_errno = 'aoo-034'
           OTHERWISE              LET g_errno = SQLCA.sqlcode USING'-------'
       END CASE
    END IF
    #相同的DB不要能KEY多次
    IF cl_null(g_errno) THEN
       FOR l_i = 1 TO tm.getLength()
           IF l_i = i THEN
              CONTINUE FOR
           END IF
           IF tm[i].azp01 = tm[l_i].azp01 THEN
              LET g_errno = '-239'
           END IF
       END FOR
    END IF
    IF NOT cl_null(g_errno) THEN
       LET l_azp03 = NULL
       LET l_azp02 = NULL
    END IF
    IF cl_null(g_errno) THEN
       LET tm[i].azp02 = l_azp02
       LET tm[i].azp03 = l_azp03
    END IF
END FUNCTION
#NO.FUN-9C0072 

#CHI-CB0017 mark begin---
##FUN-C90089 add START
#FUNCTION i610_dbs_doc(p_plant)
#DEFINE l_sql        STRING
#DEFINE l_gca        RECORD LIKE gca_file.*
#DEFINE l_gcb        RECORD LIKE gcb_file.*
#DEFINE i            LIKE   type_file.num5
#DEFINE l_n          LIKE   type_file.num5
#DEFINE l_column     LIKE   type_file.chr10
#DEFINE l_value      LIKE   type_file.chr50
#DEFINE l_column1    LIKE   type_file.chr10
#DEFINE l_value1     LIKE   type_file.chr50
#DEFINE l_gca07      LIKE   gca_file.gca07
#DEFINE l_filename   LIKE   gca_file.gca07
#DEFINE l_time       STRING
#DEFINE p_plant      LIKE   azp_file.azp01
#
#   IF g_success = 'N' THEN RETURN END IF
#   LET l_time = TIME
#   IF g_prog = 'apmi610' THEN
#      LET l_column  = "pmcano"
#      LET l_value  = g_pmca.pmcano
#
#      LET l_column1 = "pmc01"
#      LET l_value1 = g_pmca.pmca01
#   END IF
#   IF g_prog = 'apmi600' THEN
#      LET l_column  = "pmc01"
#      LET l_value  = g_pmc.pmc01
#
#      LET l_column1 = "pmc01"
#      LET l_value1 =  g_pmc.pmc01
#   END IF
#   IF cl_null(l_column) OR cl_null(l_value) OR
#      cl_null(l_column1) OR cl_null(l_value1)  THEN
#      RETURN
#   END IF
#
#   LET l_sql = " SELECT * FROM  ",cl_get_target_table(g_plant ,'gca_file'),
#               "   WHERE gca01 = '",l_column CLIPPED || "=" || l_value CLIPPED,"' "
#   PREPARE doc_pre1 FROM l_sql
#   DECLARE doc_cur1 CURSOR WITH HOLD FOR doc_pre1
#   FOREACH doc_cur1 INTO l_gca.*
#      IF cl_null(p_plant) THEN CONTINUE FOREACH END IF
#      LET l_gca.gca01 = l_column1 CLIPPED || "=" || l_value1 CLIPPED
#      LET l_n = 0
#
#      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_plant ,'gca_file'),
#                  "    WHERE gca01 = '",l_gca.gca01,"' ",
#                  "      AND gca06 = '",l_gca.gca06,"' "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
#      PREPARE doc_pre2 FROM l_sql
#      DECLARE doc_cur2 CURSOR WITH HOLD FOR doc_pre2
#      EXECUTE doc_cur2 INTO l_n
#      IF l_n = 0 OR cl_null(l_n) THEN
#        #新增gca_file
#         LET l_filename = l_gca.gca08 CLIPPED, "-",
#             FGL_GETPID() USING "<<<<<<<<<<", "-",
#             TODAY USING "YYYYMMDD", "-",
#             l_time.subString(1,2), l_time.subString(4,5), l_time.subString(7,8)
#         LET l_sql = " INSERT INTO ",cl_get_target_table(p_plant ,'gca_file'),
#                     "  (gca01 ,",
#                     "   gca02 ,",
#                     "   gca03 ,",
#                     "   gca04 ,",
#                     "   gca05 ,",
#                     "   gca06 ,",
#                     "   gca07 ,",
#                     "   gca08 ,",
#                     "   gca09 ,",
#                     "   gca10 ,",
#                     "   gca11 ,",
#                     "   gca12 ,",
#                     "   gca13 ,",
#                     "   gca14 ,",
#                     "   gca15 ,",
#                     "   gca16 ,",
#                     "   gca17 )",
#                     " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
#                     "          ?,?,?,?,?,   ?,?       )"
#
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
#         PREPARE ins_doc FROM l_sql
#         EXECUTE ins_doc USING l_gca.gca01,
#                               l_gca.gca02,
#                               l_gca.gca03,
#                               l_gca.gca04,
#                               l_gca.gca05,
#                               l_gca.gca06,
#                               l_filename,
#                               l_gca.gca08,
#                               l_gca.gca09,
#                               l_gca.gca10,
#                               l_gca.gca11,
#                               l_gca.gca12,
#                               l_gca.gca13,
#                               l_gca.gca14,
#                               l_gca.gca15,
#                               l_gca.gca16,
#                               l_gca.gca17
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             LET g_msg_i600 = 'INSERT ',cl_get_target_table(p_plant,'gca_file')
#             CALL cl_err(g_msg_i600,'lib-028',1)
#             LET g_success = 'N'
#             EXIT FOREACH
#         ELSE
#             IF g_success = 'N' THEN EXIT FOREACH END IF
#         END IF
#
#        #新增gcb_file
#         LET l_sql = " SELECT * FROM ",cl_get_target_table(g_plant ,'gcb_file'),
#                     "   WHERE gcb01= '",l_gca.gca07,"' "
#         PREPARE doc_pre3 FROM l_sql
#         DECLARE doc_cur3 CURSOR WITH HOLD FOR doc_pre3
#         LOCATE l_gcb.gcb09 IN MEMORY
#         FOREACH doc_cur3 INTO l_gcb.*
#             LET l_sql = " INSERT INTO ",cl_get_target_table(p_plant ,'gcb_file'),
#                         "   ( gcb01 ,",
#                         "     gcb02 ,",
#                         "     gcb03 ,",
#                         "     gcb04 ,",
#                         "     gcb05 ,",
#                         "     gcb06 ,",
#                         "     gcb07 ,",
#                         "     gcb08 ,",
#                         "     gcb09 ,",
#                         "     gcb10 ,",
#                         "     gcb11 ,",
#                         "     gcb12 ,",
#                         "     gcb13 ,",
#                         "     gcb14 ,",
#                         "     gcb15 ,",
#                         "     gcb16 ,",
#                         "     gcb17 ,",
#                         "     gcb18 )",
#                         " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
#                         "          ?,?,?,?,?,   ?,?,?     )"
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
#            PREPARE ins_doc2 FROM l_sql
#            EXECUTE ins_doc2 USING l_filename ,
#                                   l_gcb.gcb02,
#                                   l_gcb.gcb03,
#                                   l_gcb.gcb04,
#                                   l_gcb.gcb05,
#                                   l_gcb.gcb06,
#                                   l_gcb.gcb07,
#                                   l_gcb.gcb08,
#                                   l_gcb.gcb09,
#                                   l_gcb.gcb10,
#                                   l_gcb.gcb11,
#                                   l_gcb.gcb12,
#                                   l_gcb.gcb13,
#                                   l_gcb.gcb14,
#                                   l_gcb.gcb15,
#                                   l_gcb.gcb16,
#                                   l_gcb.gcb17,
#                                   l_gcb.gcb18
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                LET g_msg_i600 = 'INSERT ',cl_get_target_table(p_plant,'gcb_file')
#                CALL cl_err(g_msg_i600,'lib-028',1)
#                LET g_success = 'N'
#                EXIT FOREACH
#            ELSE
#                IF g_success = 'N' THEN EXIT FOREACH END IF
#            END IF
#            FREE l_gcb.gcb09
#         END FOREACH
#      ELSE
#        #修改gca_file
#         LET l_sql = " SELECT DISTINCT gca07 FROM ",cl_get_target_table(p_plant ,'gca_file'),
#                     "    WHERE gca01 = '",l_gca.gca01,"' ",
#                     "      AND gca06 = '",l_gca.gca06,"' "
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
#         PREPARE upd_doc3 FROM l_sql
#         EXECUTE upd_doc3 INTO l_gca07
#
#         LET l_sql = " UPDATE ",cl_get_target_table(p_plant ,'gca_file'),
#                     " SET ",
#                     "    gca07 =   ?,",
#                     "    gca08 =   ?,",
#                     "    gca09 =   ?,",
#                     "    gca10 =   ?,",
#                     "    gca11 =   ?,",
#                     "    gca12 =   ?,",
#                     "    gca13 =   ?,",
#                     "    gca14 =   ?,",
#                     "    gca15 =   ?,",
#                     "    gca16 =   ?,",
#                     "    gca17 =   ? ",
#                     "    WHERE gca01 = '",l_gca.gca01,"' ",
#                     "      AND gca06 = '",l_gca.gca06,"' "
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
#         PREPARE upd_doc FROM l_sql
#         EXECUTE upd_doc USING
#                               l_gca.gca07,
#                               l_gca.gca08,
#                               l_gca.gca09,
#                               l_gca.gca10,
#                               l_gca.gca11,
#                               l_gca.gca12,
#                               l_gca.gca13,
#                               l_gca.gca14,
#                               l_gca.gca15,
#                               l_gca.gca16,
#                               l_gca.gca17
#
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             LET g_msg_i600 = 'INSERT ',cl_get_target_table(p_plant,'gcb_file')
#             CALL cl_err(g_msg_i600,'lib-028',1)
#             LET g_success = 'N'
#             EXIT FOREACH
#         ELSE
#             IF g_success = 'N' THEN EXIT FOREACH END IF
#         END IF
#        #修改gcb_file
#         LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'gcb_file') ,
#                     "   WHERE gcb01= '",l_gca07,"' "
#         PREPARE doc_pre4 FROM l_sql
#         DECLARE doc_cur4 CURSOR WITH HOLD FOR doc_pre4
#         LOCATE l_gcb.gcb09 IN MEMORY
#         FOREACH doc_cur4 INTO l_gcb.*
#            LET l_sql = " UPDATE ",cl_get_target_table(p_plant ,'gcb_file'),
#                        " SET ",
#                        "    gcb05 =   ?,",
#                        "    gcb06 =   ?,",
#                        "    gcb07 =   ?,",
#                        "    gcb08 =   ?,",
#                        "    gcb09 =   ?,",
#                        "    gcb10 =   ?,",
#                        "    gcb11 =   ?,",
#                        "    gcb12 =   ?,",
#                        "    gcb13 =   ?,",
#                        "    gcb14 =   ?,",
#                        "    gcb15 =   ?,",
#                        "    gcb16 =   ?,",
#                        "    gcb17 =   ?,",
#                        "    gcb18 =   ? ",
#                        "    WHERE gcb01 = '",l_gca07,"' "
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
#            PREPARE upd_doc2 FROM l_sql
#            EXECUTE upd_doc2 USING
#                                   l_gcb.gcb05,
#                                   l_gcb.gcb06,
#                                   l_gcb.gcb07,
#                                   l_gcb.gcb08,
#                                   l_gcb.gcb09,
#                                   l_gcb.gcb10,
#                                   l_gcb.gcb11,
#                                   l_gcb.gcb12,
#                                   l_gcb.gcb13,
#                                   l_gcb.gcb14,
#                                   l_gcb.gcb15,
#                                   l_gcb.gcb16,
#                                   l_gcb.gcb17,
#                                   l_gcb.gcb18
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                LET g_msg_i600 = 'UPDATE ',cl_get_target_table(p_plant,'gcb_file')
#                CALL cl_err(g_msg_i600,'lib-028',1)
#                LET g_success = 'N'
#                EXIT FOREACH
#            ELSE
#                IF g_success = 'N' THEN EXIT FOREACH END IF
#            END IF
#            FREE l_gcb.gcb09
#         END FOREACH
#
#      END IF
#
#   END FOREACH
#
#END FUNCTION
##FUN-C90089 add END
#CHI-CB0017 mark end-----

