# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_atmp227_carry.4gl
# Descriptions...: 價格表資料整批拋轉
# Date & Author..: 08/02/14 By Carrier FUN-7C0010
# Usage..........: CALL s_atmp227_carry_tqm(p_tqm,p_azp,p_gev04)
# Usage..........: CALL s_atmp227_carry_tqn(p_tqn,p_azp,p_gev04)
# Input PARAMETER: p_tqm    拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
# Modify.........: FUN-830090 08/03/24 By Carrier add upload logical
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0165 09/10/28 By lilingyu "資料拋轉"時,如條件不符,給出訊息提示
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A80036 10/09/29 By Carrier 资料抛转时,使用的中间表变成动态表名
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_tqm_1    DYNAMIC ARRAY OF RECORD 
                  sel      LIKE type_file.chr1,
                  tqm01    LIKE tqm_file.tqm01
                  END RECORD
DEFINE g_tqn_1    DYNAMIC ARRAY OF RECORD 
                  tqn01    LIKE tqn_file.tqn01,
                  tqn02    LIKE tqn_file.tqn02
                  END RECORD
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
DEFINE g_tqm      RECORD LIKE tqm_file.*
DEFINE g_tqn      RECORD LIKE tqn_file.*
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_msg      LIKE type_file.chr1000
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg3     LIKE type_file.chr1000
DEFINE g_msg4     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_sql      STRING
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_all_cnt  LIKE type_file.num10    #總共要拋轉的筆數
DEFINE g_cur_cnt  LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_flagx    LIKE type_file.chr1     #No.FUN-830090
 
##################################################
# Descriptions...: 價格表資料整批拋轉
# Date & Author..: 08/02/14 By Carrier FUN-7C0010
# Input PARAMETER: p_tqm    拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
#                  p_wc2    單身拋轉條件
##################################################
FUNCTION s_atmp227_carry_tqm(p_tqm,p_azp,p_gev04,p_wc2,p_flagx)  #No.FUN-830090
   DEFINE p_tqm                DYNAMIC ARRAY OF RECORD 
                               sel      LIKE type_file.chr1,
                               tqm01    LIKE tqm_file.tqm01
                               END RECORD
   DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               azp01    LIKE azp_file.azp01,
                               azp02    LIKE azp_file.azp02,
                               azp03    LIKE azp_file.azp03
                               END RECORD
   DEFINE p_gev04              LIKE gev_file.gev04
   DEFINE 
          #p_wc2                LIKE type_file.chr1000
          p_wc2        STRING       #NO.FUN-910082
   DEFINE p_flagx              LIKE type_file.chr1    #No.FUN-830090
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_str1               STRING
   DEFINE l_str2               STRING
   DEFINE l_str3               STRING
   DEFINE l_str4               STRING
   DEFINE l_str5               STRING
   DEFINE l_str6               STRING
   DEFINE l_str7               STRING
   DEFINE l_str8               STRING
   DEFINE l_tqm01              LIKE tqm_file.tqm01
   DEFINE l_tqm01_old          LIKE tqm_file.tqm01
   DEFINE l_tqm06              LIKE tqm_file.tqm06
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_gez04              LIKE gez_file.gez04
   DEFINE l_gez05              LIKE gez_file.gez05
   DEFINE l_tabname            LIKE type_file.chr50
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
   DEFINE l_hist_tab           LIKE type_file.chr50    #for mail
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_flagx = p_flagx     #No.FUN-830090  0.carry  1.upload
   #No.FUN-830090  --Begin
   IF g_flagx <> '1' THEN
      IF p_tqm.getLength() = 0 THEN RETURN END IF
   END IF
   #No.FUN-830090  --End
 
   IF p_azp.getLength() = 0 THEN 
      CALL cl_err('','aim-505',0) #TQC-9A0165
      RETURN
   END IF
   CALL g_tqm_1.clear()
 
   #前置准備
   FOR l_i = 1 TO p_tqm.getLength()
       LET g_tqm_1[l_i].* = p_tqm[l_i].*
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
               "    AND gez02 = '7'",
               "    AND gez03 = ?  "
   PREPARE gez_p FROM g_sql
   DECLARE gez_cur CURSOR WITH HOLD FOR gez_p 
   #組column
   CALL s_carry_col('tqm_file') RETURNING l_str1,l_str2,l_str3
   CALL s_carry_col('tqn_file') RETURNING l_str5,l_str6,l_str7
   #組index
   CALL s_carry_idx('tqm_file') RETURNING l_str4
   CALL s_carry_idx('tqn_file') RETURNING l_str8
 
   #建立臨時表,用于存放拋轉的資料
   CALL s_atmp227_carry_p1() RETURNING l_tabname
   #No.FUN-830090  --Begin
   IF g_all_cnt = 0 THEN
      CALL cl_err('','aap-129',1)
      RETURN
   END IF
   #No.FUN-830090  --End  
 
   #建立歷史資料拋轉的臨時表
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
 
   #tqm對應單身tqn_file拋轉的cursor定義
   #No.FUN-830090  --Begin    
   IF g_flagx <> '1' THEN                                  
      LET g_sql = " SELECT * FROM tqn_file ",
                  "  WHERE tqn01 = ? ",
                  "    AND ",p_wc2
   ELSE
      LET g_sql = " SELECT * FROM tqn_file_bak1 ",
                  "  WHERE tqn01 = ? "
   END IF
   #No.FUN-830090  --End
   PREPARE tqn_p FROM g_sql
   DECLARE tqn_cur CURSOR WITH HOLD FOR tqn_p 
 
   FOR l_j = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '7'
          AND gew04 = g_azp[l_j].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'7',l_hist_tab)
            RETURNING l_hs_flag,l_hs_path
 
       CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"tqm_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'tqm_file'), #FUN-A50102
                   " VALUES(",l_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs1 FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"tqm_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'tqm_file'), #FUN-A50102
                   "   SET ",l_str3,
                   " WHERE ",l_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs2 FROM g_sql
 
       #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"tqn_file",
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'tqn_file'), #FUN-A50102
                   " VALUES(",l_str6,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs3 FROM g_sql
       #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"tqn_file",
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'tqn_file'), #FUN-A50102
                   "   SET ",l_str7,
                   " WHERE ",l_str8
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
       PREPARE db_cs4 FROM g_sql
 
       #default aooi602中設置的預設值
       LET l_tqm01 = NULL
       LET l_tqm06 = NULL
       FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)
             CONTINUE FOREACH
          END IF
          IF l_gez04 = 'tqm01'  THEN LET l_tqm01  = l_gez05 END IF
          IF l_gez04 = 'tqm06'  THEN LET l_tqm06  = l_gez05 END IF
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
      
       FOREACH carry_cur1 INTO g_tqm.*
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('tqm01',g_tqm.tqm01,'foreach',SQLCA.sqlcode,1)
              CONTINUE FOREACH
           END IF
           IF g_tqm.tqmacti <> 'Y' THEN
              IF l_j = 1 THEN
                 LET g_showmsg = g_plant,":",g_tqm.tqm01
                 CALL s_errmsg('azp01,tqm01',g_showmsg,'tqmacti','aoo-090',1)
              END IF
              CONTINUE FOREACH
           END IF
           LET g_success = 'Y'
           BEGIN WORK
           LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_tqm.tqm01,':'
           LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_tqm.tqm01,':'
 
           LET l_tqm01_old = g_tqm.tqm01
           IF NOT cl_null(l_tqm01) THEN LET g_tqm.tqm01 = l_tqm01 END IF
           IF NOT cl_null(l_tqm06) THEN LET g_tqm.tqm06 = l_tqm06 END IF
 
           #tqm07,tqm08
           LET g_tqm.tqm07 = g_plant
           LET g_tqm.tqm08 = 1
           EXECUTE db_cs1 USING g_tqm.*
           IF SQLCA.sqlcode = 0 THEN
              MESSAGE g_msg1,':ok'
              CALL ui.Interface.refresh()
           ELSE
              #No.FUN-A80036  --Begin
              #IF SQLCA.sqlcode = -239 THEN  
              IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
              #No.FUN-A80036  --End  
                 IF l_gew07 = 'N' THEN     
                    MESSAGE g_msg1,':exist'
                    CALL ui.Interface.refresh()
                    LET g_success = 'N'      #No.FUN-A80036
                 ELSE
                    LET g_sql = "SELECT tqm08 FROM ",
                                #l_dbs_sep CLIPPED,"tqm_file ",
                                cl_get_target_table(g_azp[l_j].azp01,'tqm_file'), #FUN-A50102
                                " WHERE tqm01='",l_tqm01_old CLIPPED,"'"
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-A50102
                    CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102
                    PREPARE tqm_p1 FROM g_sql
                    EXECUTE tqm_p1 INTO g_tqm.tqm08
                    IF cl_null(g_tqm.tqm08) THEN LET g_tqm.tqm08 = 0 END IF
                    LET g_tqm.tqm08 = g_tqm.tqm08 + 1
 
                    EXECUTE db_cs2 USING g_tqm.*,l_tqm01_old
                    IF SQLCA.sqlcode = 0 THEN
                       MESSAGE g_msg2,':ok'
                       CALL ui.Interface.refresh()
                    ELSE
                       LET g_msg_x = g_azp[l_j].azp01,':upd'
                       CALL s_errmsg('tqm01',g_tqm.tqm01,g_msg_x,SQLCA.sqlcode,1)
                       MESSAGE g_msg2,':fail'
                       CALL ui.Interface.refresh()
                       LET g_success = 'N'
                    END IF
                 END IF
              ELSE
                 LET g_msg_x = g_azp[l_j].azp01,':ins'
                 CALL s_errmsg('tqm01',g_tqm.tqm01,g_msg_x,SQLCA.sqlcode,1)
                 MESSAGE g_msg1,':fail'
                 CALL ui.Interface.refresh()
                 LET g_success = 'N'
              END IF
           END IF
           #No.FUN-A80036  --Begin
           #IF SQLCA.sqlerrd[3] > 0 THEN
           IF g_success = 'Y' THEN
           #No.FUN-A80036  --End  
              CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_tqm.tqm01,'7')
              #處理單身tqn的insert或是update
              FOREACH tqn_cur USING l_tqm01_old INTO g_tqn.* 
                 IF SQLCA.sqlcode THEN
                    CALL s_errmsg('tqn01',g_tqn.tqn01,'foreach',SQLCA.sqlcode,1)
                    CONTINUE FOREACH
                 END IF
                 LET g_msg3 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_tqm.tqm01,'+',g_tqn.tqn02,':'
                 LET g_msg4 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_tqm.tqm01,'+',g_tqn.tqn02,':'
                 IF NOT cl_null(l_tqm01) THEN LET g_tqn.tqn01 = l_tqm01 END IF
                 EXECUTE db_cs3 USING g_tqn.*
                 IF SQLCA.sqlcode = 0 THEN
                    MESSAGE g_msg3,':ok'
                    CALL ui.Interface.refresh()
                 ELSE
                    #No.FUN-A80036  --Begin
                    #IF SQLCA.sqlcode = -239 THEN  
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                    #No.FUN-A80036  --End  
                       IF l_gew07 = 'N' THEN
                          MESSAGE g_msg1,':exist'
                          CALL ui.Interface.refresh()
                          LET g_success = 'N'    #No.FUN-A80036
                       ELSE
                          EXECUTE db_cs4 USING g_tqn.*,l_tqm01_old,g_tqn.tqn02
                          IF SQLCA.sqlcode = 0 THEN
                             MESSAGE g_msg4,':ok'
                             CALL ui.Interface.refresh()
                          ELSE
                             LET g_msg_x = g_azp[l_j].azp01,':upd'
                             LET g_showmsg = g_tqn.tqn01,"/",g_tqn.tqn02
                             CALL s_errmsg('tqn01,tqn02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                             MESSAGE g_msg4,':fail'
                             CALL ui.Interface.refresh()
                             LET g_success = 'N'
                          END IF
                       END IF
                    ELSE
                       LET g_msg_x = g_azp[l_j].azp01,':ins'
                       LET g_showmsg = g_tqn.tqn01,"/",g_tqn.tqn02
                       CALL s_errmsg('tqn01,tqn02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                       MESSAGE g_msg3,':fail'
                       CALL ui.Interface.refresh()
                       LET g_success = 'N'
                    END IF
                 END IF
                 #No.FUN-A80036  --Begin
                 #IF SQLCA.sqlerrd[3] > 0 THEN
                 IF g_success = 'Y' THEN
                 #No.FUN-A80036  --End  
                    CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_tqn.tqn01||'+'||g_tqn.tqn02,'7')
                 END IF
              END FOREACH
           END IF
           IF g_success = 'N' THEN
              ROLLBACK WORK
           ELSE
              COMMIT WORK
           END IF
       END FOREACH
       #mail 2                                                                  
       CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
   END FOR
 
   CALL s_dc_drop_temp_table(l_tabname)
   CALL s_dc_drop_temp_table(l_hist_tab)
 
   MESSAGE 'Data Carry Finish!'
   CALL ui.Interface.refresh()
  #CALL s_atmp227_carry_send_mail('1')
END FUNCTION
 
FUNCTION s_atmp227_carry_p1()
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                    #No.FUN-A80036
   DEFINE l_str                STRING                    #No.FUN-A80036
 
   CALL s_dc_cre_temp_table("tqm_file") RETURNING l_tabname
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX tqm_file_bak_01 ON ",l_tabname CLIPPED,"(tqm01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(tqm01)"
   #No.FUN-A80036  --End
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM tqm_file",
                                                 "  WHERE tqm01 = ?"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0
   #No.FUN-830090  --Begin
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_tqm_1.getLength()
          IF cl_null(g_tqm_1[l_i].tqm01) THEN
             CONTINUE FOR
          END IF
          IF g_tqm_1[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          EXECUTE ins_pp USING g_tqm_1[l_i].tqm01
          IF SQLCA.sqlcode THEN
             LET l_str = 'ins ',l_tabname CLIPPED   #No.FUN-A80036
             CALL cl_err(l_str,SQLCA.sqlcode,1)     #No.FUN-A80036
             CONTINUE FOR
          END IF
          LET g_all_cnt = g_all_cnt + 1
      END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM tqm_file_bak1"
      PREPARE ins_ppx FROM g_sql
      EXECUTE ins_ppx
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname
      PREPARE cnt_ppx FROM g_sql
      EXECUTE cnt_ppx INTO g_all_cnt
      IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF
   END IF
   #No.FUN-830090  --End
 
   RETURN l_tabname
END FUNCTION   
 
FUNCTION s_atmp227_download(p_tqm,p_wc)
  DEFINE p_tqm        DYNAMIC ARRAY OF RECORD 
                      sel      LIKE type_file.chr1,
                      tqm01    LIKE tqm_file.tqm01
                      END RECORD
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE 
         #p_wc         LIKE type_file.chr1000
         p_wc        STRING       #NO.FUN-910082
 
    #前置准備
    FOR l_i = 1 TO p_tqm.getLength()
        LET g_tqm_1[l_i].* = p_tqm[l_i].*
    END FOR
 
    CALL s_dc_download_path() RETURNING l_path
    IF cl_null(l_path) THEN RETURN END IF
    CALL s_atmp227_download_files(l_path,p_wc)
 
END FUNCTION
 
FUNCTION s_atmp227_download_files(p_path,p_wc)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE 
         #p_wc         LIKE type_file.chr1000]
         p_wc         STRING       #NO.FUN-910082
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
  DEFINE l_tempdir         LIKE ze_file.ze03
  DEFINE l_temp_file       LIKE ze_file.ze03                                    
  DEFINE l_temp_file1      LIKE ze_file.ze03                                    
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
 
   LET l_tempdir    = fgl_getenv('TEMPDIR')                                     
 
   #建立臨時表,用于存放拋轉的資料
   CALL s_atmp227_carry_p1() RETURNING l_tabname
 
   LET l_upload_file = l_tempdir CLIPPED,'/atmp227_tqm_file_7.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/atmp227_tqm_file_7.txt"   #No.FUN-830090
   
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
 
   #tqn
   LET l_upload_file = l_tempdir CLIPPED,'/atmp227_tqn_file_7.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/atmp227_tqn_file_7.txt"   #No.FUN-830090
   
   LET g_sql = "SELECT * FROM tqn_file WHERE ",p_wc CLIPPED,
               "   AND tqn01 IN (SELECT tqm01 FROM ",l_tabname CLIPPED,")"
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
