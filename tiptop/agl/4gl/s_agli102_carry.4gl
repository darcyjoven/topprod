# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_agli102_carry.4gl
# Descriptions...: 會計科目資料整批拋轉
# Date & Author..: 08/02/27 By Sunyanchun FUN-820031   #FUN-830085
# Usage..........: CALL s_agli102_carry_aag(p_aag,p_azp,p_gev04)
# Input PARAMETER: p_aag    拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting 拋轉成功才發郵件通知 
# Modify.........: No.MOD-8B0195 08/11/19 By sherry 科目層級拋轉后變為0
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-830085
DEFINE g_aagx    DYNAMIC ARRAY OF RECORD 
                  sel      LIKE type_file.chr1,
                  aag00    LIKE aag_file.aag00,
                  aag01    LIKE aag_file.aag01
                  END RECORD
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
DEFINE g_aag      RECORD LIKE aag_file.*
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
DEFINE l_gew08              LIKE gew_file.gew08     #for mail                                                                     
DEFINE l_hist_tab           LIKE type_file.chr50    #for mail                                                                     
DEFINE l_hs_flag            LIKE type_file.chr1     #for mail                                                                     
DEFINE l_hs_path            LIKE ze_file.ze03       #for mail 
DEFINE g_flagx              LIKE type_file.chr1     #上傳還是拋轉的標識
##################################################
# Descriptions...: 會計科目資料整批拋轉
# Date & Author..: 08/02/27 By Sunyanchun FUN-820031
# Input PARAMETER: p_aag    拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
##################################################
FUNCTION s_agli102_carry_aag(p_aag,p_azp,p_gev04,p_flagx)
   DEFINE p_aag                DYNAMIC ARRAY OF RECORD 
                               sel      LIKE type_file.chr1,
                               aag00    LIKE aag_file.aag00,
                               aag01    LIKE aag_file.aag01
                               END RECORD
   DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               azp01    LIKE azp_file.azp01,
                               azp02    LIKE azp_file.azp02,
                               azp03    LIKE azp_file.azp03
                               END RECORD
   DEFINE p_gev04              LIKE gev_file.gev04
   DEFINE p_flagx              LIKE type_file.chr1
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
   DEFINE l_aag01              LIKE aag_file.aag01
   DEFINE l_aag01_old          LIKE aag_file.aag01
   DEFINE l_aag00_old          LIKE aag_file.aag00
   DEFINE l_aag24              LIKE aag_file.aag24
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_gez04              LIKE gez_file.gez04
   DEFINE l_gez05              LIKE gez_file.gez05
   DEFINE l_tabname            LIKE type_file.chr50
   DEFINE l_aag_upd            LIKE type_file.chr1   #no.FUN-840033 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_flagx = p_flagx
   IF g_flagx <> '1' THEN
      #檢查有沒有要拋轉的資料
      IF p_aag.getLength() = 0 THEN RETURN END IF
   END IF
   #檢查有沒有要拋轉到的資料庫
   IF p_azp.getLength() = 0 THEN RETURN END IF
 
   #前置准備
   FOR l_i = 1 TO p_aag.getLength()
       LET g_aagx[l_i].* = p_aag[l_i].*
   END FOR
   FOR l_i = 1 TO p_azp.getLength()
       LET g_azp[l_i].* = p_azp[l_i].*
   END FOR
   LET g_gev04 = p_gev04
   LET g_db_type=cl_db_get_database_type()
 
   #定義cursor,得到表中的列
   CALL s_carry_p_cs()
   #default aooi602中設置的預設值
   LET g_sql = " SELECT gez04,gez05 FROM gez_file ", #字段編號、拋轉字段值
               "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
               "    AND gez02 = '6'",
               "    AND gez03 = ?  "
   PREPARE gez_p FROM g_sql
   DECLARE gez_cur CURSOR WITH HOLD FOR gez_p 
   #組column
   CALL s_carry_col('aag_file') RETURNING l_str1,l_str2,l_str3
   #組index
   CALL s_carry_idx('aag_file') RETURNING l_str4
 
   #建立臨時表,用于存放拋轉的資料
   CALL s_agli102_carry_p1() RETURNING l_tabname
   IF g_all_cnt = 0 THEN                                                         
      CALL cl_err('','aap-129',1)                                                
      RETURN                                                                     
   END IF
   #建立歷史資料拋轉的臨時表                                                                                                         
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
 
   FOR l_j = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
       #查看拋轉條件和是否可以更新資料
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '6'
          AND gew04 = g_azp[l_j].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
       
       #mail_1                                                                                                                       
       CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'2',l_hist_tab)                                                      
           RETURNING l_hs_flag,l_hs_path   
       #根據 PLANT CODE 得出其 DataBase name
       CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
 
      #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"aag_file",   #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'aag_file'),  #FUN-A50102
                   " VALUES(",l_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE db_cs1 FROM g_sql
      #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"aag_file",  #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'aag_file'),   #FUN-A50102
                   "   SET ",l_str3,
                   " WHERE ",l_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE db_cs2 FROM g_sql
 
       #default aooi602中設置的預設值
       LET l_aag01 = NULL
       LET l_aag24 = NULL       #MOD-8B0195
       #LET l_tqm06 = NULL
       FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)
             CONTINUE FOREACH
          END IF
          IF l_gez04 = 'aag01'  THEN LET l_aag01  = l_gez05 END IF
          IF l_gez04 = 'aag24'  THEN LET l_aag24  = l_gez05 END IF
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
 
       LET l_aag_upd = 'N'    #No.FUN-A80036
       FOREACH carry_cur1 INTO g_aag.*
           IF SQLCA.sqlcode THEN
              LET g_showmsg = g_aag.aag00,"/",g_aag.aag01
              CALL s_errmsg('aag00,aag01',g_showmsg,'foreach',SQLCA.sqlcode,1)
              CONTINUE FOREACH
           END IF
           IF g_aag.aagacti <> 'Y' AND l_j = 1 THEN  #僅報一次錯誤                
              LET g_showmsg = g_plant,":",g_aag.aag00                             
              CALL s_errmsg('azp01,aag00',g_showmsg,'aagacti','aoo-090',1)        
              CONTINUE FOREACH                                                    
           END IF
           LET g_success = 'Y'
           #LET l_aag_upd = 'N'  #NO.FUN-840033 add  #No.FUN-A80036
           BEGIN WORK
           LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_aag.aag01,':'
           LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_aag.aag01,':'
 
           LET l_aag01_old = g_aag.aag01
           LET l_aag00_old = g_aag.aag00
           IF NOT cl_null(l_aag01) THEN LET g_aag.aag01 = l_aag01 END IF
           IF NOT cl_null(l_aag24) THEN LET g_aag.aag24 = l_aag24 END IF
 
           LET g_aag.aag39 = g_plant    #資料來源
           LET g_aag.aag40 = 1          #拋轉次數
           EXECUTE db_cs1 USING g_aag.*
           IF SQLCA.sqlcode = 0 THEN
              MESSAGE g_msg1,':ok'
              CALL ui.Interface.refresh()
              #LET l_aag_upd ='Y'  #NO.FUN-840033 add   #No.FUN-A80036
           ELSE
              #No.FUN-830090  --Begin                                             
              #No.FUN-A80036  --Begin
              #IF SQLCA.sqlcode = -239 THEN
              IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
              #No.FUN-A80036  --End
                 IF l_gew07 = 'N' THEN                                            
                    MESSAGE g_msg1 CLIPPED,':exist'                               
                    CALL ui.Interface.refresh()     
                    #LET l_aag_upd = 'N'  #NO.FUN-840033 add   #No.FUN-A80036
                    LET g_success = 'N'  #No.FUN-A80036
                 ELSE                                                             
              #No.FUN-830090  --End
                    LET g_sql = "SELECT aag40 FROM ",
                               #l_dbs_sep CLIPPED,"aag_file ",  #FUN-A50102
                                 cl_get_target_table(g_azp[l_j].azp01,'aag_file'),   #FUN-A50102
                                " WHERE aag01='",l_aag01_old CLIPPED,"'",
                                " AND aag00='",l_aag00_old CLIPPED,"'"
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql #FUN-A50102
                    CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
                    PREPARE aag_p1 FROM g_sql
                    EXECUTE aag_p1 INTO g_aag.aag40
                    IF cl_null(g_aag.aag40) THEN LET g_aag.aag40 = 0 END IF
                    LET g_aag.aag40 = g_aag.aag40 + 1
 
                    EXECUTE db_cs2 USING g_aag.*,l_aag00_old,l_aag01_old
                    IF SQLCA.sqlcode = 0 THEN
                       MESSAGE g_msg2,':ok'
                       CALL ui.Interface.refresh()
                       #LET l_aag_upd = 'Y'  #NO.FUN-840033 add  #No.FUN-A80036
                    ELSE
                       LET g_msg_x = g_azp[l_j].azp01,':upd'
                       LET g_showmsg = g_aag.aag00,"/",g_aag.aag01
                       CALL s_errmsg('aag00,aag01',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                       MESSAGE g_msg2,':fail'
                       CALL ui.Interface.refresh()
                       LET g_success = 'N'
                       #LET l_aag_upd = 'N'    #no.FUN-840033 add  #No.FUN-A80036
                    END IF
                 END IF
              ELSE
                 LET g_msg_x = g_azp[l_j].azp01,':ins'
                 LET g_showmsg = g_aag.aag00,"/",g_aag.aag01
                 CALL s_errmsg('aag01',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                 MESSAGE g_msg1,':fail'
                 CALL ui.Interface.refresh()
                 LET g_success = 'N'
                 #LET l_aag_upd = 'N'    #NO.FUN-840033 add  #No.FUN-A80036
              END IF
           END IF
           #No.FUN-A80036  --Begin
           #IF SQLCA.sqlerrd[3] > 0 THEN
           IF g_success = 'Y' THEN
           #No.FUN-A80036  --End  
              #CALL s_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_aag.aag00||'+'||g_aag.aag01,'6')
              CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_aag.aag00||'+'||g_aag.aag01,'6')
           END IF
           IF g_success = 'N' THEN
              #LET l_aag_upd = 'N'   #NO.FUN-840033 add  #No.FUN-A80036
              ROLLBACK WORK
           ELSE
              LET l_aag_upd = 'Y'   #NO.FUN-840033 add
              COMMIT WORK
           END IF
       END FOREACH
       #mail 2                                        
       IF l_aag_upd = 'Y' THEN  #NO.FUN-840033 add                                                                               
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
       END IF                   #NO.FUN-840033 add
   END FOR
 
   CALL s_dc_drop_temp_table(l_tabname)
   CALL s_dc_drop_temp_table(l_hist_tab)
   IF l_aag_upd = 'Y' THEN               #NO.FUN-840033 add
       MESSAGE 'Data Carry Finish!'
       CALL ui.Interface.refresh()
   END IF                                #NO.FUN-840033 add
   #CALL s_agli102_carry_send_mail('1')
END FUNCTION
 
FUNCTION s_agli102_carry_send_mail(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1
 DEFINE l_i        LIKE type_file.num5
 DEFINE l_j        LIKE type_file.num5
 DEFINE l_gew08    LIKE gew_file.gew08
 DEFINE l_tempdir  LIKE type_file.chr20
 DEFINE lc_channel base.Channel
 DEFINE l_str      LIKE type_file.chr1000
 DEFINE l_cmd      LIKE type_file.chr1000
 
   FOR l_i = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_i].azp01) THEN CONTINUE FOR END IF
       IF g_azp[l_i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew08 INTO l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '6'
          AND gew04 = g_azp[l_i].azp01
       IF SQLCA.sqlcode OR cl_null(l_gew08) THEN
          CONTINUE FOR
       END IF
       MESSAGE "Sending Mail:",l_gew08 CLIPPED
       CALL ui.Interface.refresh()
       INITIALIZE g_xml.* TO NULL
       LET l_tempdir = FGL_GETENV('TEMPDIR')
       LET g_msg = g_prog CLIPPED,' ',g_today
       #Subject
       CALL cl_getmsg('aoo-037',g_lang) RETURNING g_msg1
       LET g_xml.subject = g_msg CLIPPED,' ',g_msg1
 
       #抓相關應通知人員email
       LET g_xml.recipient =  l_gew08
 
       IF cl_null(g_xml.recipient) THEN
          CONTINUE FOR
       END IF
 
       # 產生文本檔
       LET g_msg = g_prog CLIPPED,'-',g_azp[l_i].azp01,'-',l_i USING "<<<<<",'.htm'    #FUN-9B0113
       LET g_msg = os.Path.join(l_tempdir CLIPPED, g_msg CLIPPED)
 
       LET lc_channel = base.Channel.create()
       CALL lc_channel.openFile(g_msg,"w")
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

#      LET l_cmd = "rm ",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
#      RUN l_cmd
#      LET l_cmd = "cat /dev/null >",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
#      RUN l_cmd

       LET l_cmd = g_prog CLIPPED,".txt"
       LET l_cmd = os.Path.join(l_tempdir CLIPPED, l_cmd CLIPPED)

       IF os.Path.delete(l_cmd CLIPPED) THEN
       END IF
       CALL cl_null_cat_to_file(l_cmd CLIPPED)                  #FUN-9B0113

       LET l_cmd = "echo 'Logestic\tData Type\tCarry Logestic\tProgram ID\t",
                   "Key Value\tCarry Counts\tCarry Date\tCarry Time\t",
                   "Carry Person' >>",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
       RUN l_cmd
       IF p_cmd = '1' THEN
          FOR l_j = 1 TO g_aagx.getLength()
              IF cl_null(g_aagx[l_j].aag01) THEN
                 CONTINUE FOR
              END IF
              LET l_cmd = "echo ",g_azp[l_i].azp01 CLIPPED,"\t1\t",g_plant CLIPPED,
                          "\t",g_prog CLIPPED,"\t",g_aagx[l_j].aag01,"\t1\t",
                          g_today,"\t",TIME,"\t",
                          g_user CLIPPED," >>",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
              RUN l_cmd
          END FOR
       END IF
 
       LET g_xml.attach = g_prog CLIPPED,'.txt'
       LET g_xml.attach = os.Path.join(l_tempdir CLIPPED,g_xml.attach CLIPPED)

       DISPLAY g_xml.subject
       DISPLAY "Mail 收件人清單：" , g_xml.recipient
       CALL cl_jmail()
 
#      LET l_cmd = "rm ",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
#      RUN l_cmd
       IF os.Path.delete(g_xml.attach CLIPPED) THEN    #FUN-9B0113
       END IF
 
   END FOR
 
END FUNCTION
 
FUNCTION s_agli102_carry_p1()
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                    #No.FUN-A80036         
   DEFINE l_str                STRING                    #No.FUN-A80036
 
   CALL s_dc_cre_temp_table("aag_file") RETURNING l_tabname
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX aag_file_bak_01 ON ",l_tabname CLIPPED,"(aag00,aag01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(aag00,aag01)"
   #No.FUN-A80036  --End  
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM aag_file",
                                                 "  WHERE aag00 = ? AND aag01 = ?"
   PREPARE ins_pp FROM g_sql
   LET g_all_cnt = 0
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_aagx.getLength()
         IF cl_null(g_aagx[l_i].aag01) OR cl_null(g_aagx[l_i].aag00) THEN
            CONTINUE FOR
         END IF
         IF g_aagx[l_i].sel = 'N' THEN
            CONTINUE FOR
         END IF
         EXECUTE ins_pp USING g_aagx[l_i].aag00,g_aagx[l_i].aag01
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
       LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM aag_file_bak1"                                                  
       PREPARE ins_ppx FROM g_sql                                                                                                    
       EXECUTE ins_ppx                                                                                                               
       LET g_sql = " SELECT COUNT(*) FROM ",l_tabname                                                                                
       PREPARE cnt_ppx FROM g_sql                                                                                                    
       EXECUTE cnt_ppx INTO g_all_cnt                                                                                                
       IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF 
   END IF
   RETURN l_tabname
END FUNCTION   
 
FUNCTION s_agli102_download(p_aag,p_wc)
  DEFINE p_aag        DYNAMIC ARRAY OF RECORD 
                      sel      LIKE type_file.chr1,
                      aag00    LIKE aag_file.aag00,
                      aag01    LIKE aag_file.aag01
                      END RECORD
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE
         #p_wc         LIKE type_file.chr1000
         p_wc         STRING      #NO.FUN-910082
 
    #前置准備
    FOR l_i = 1 TO p_aag.getLength()
        LET g_aagx[l_i].* = p_aag[l_i].*
    END FOR
 
    CALL s_dc_download_path() RETURNING l_path
    CALL s_agli102_download_files(l_path,p_wc)
 
END FUNCTION
 
FUNCTION s_agli102_download_files(p_path,p_wc)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE 
         #p_wc         LIKE type_file.chr1000
         p_wc          STRING           #NO.FUN-910082
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
   CALL s_agli102_carry_p1() RETURNING l_tabname
 
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_aag_file_6.txt'
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_aag_file_6.txt"
   
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
 
   #tqn
   LET l_upload_file = l_tempdir CLIPPED,g_prog,'/_file.txt'
   LET l_download_file = p_path CLIPPED,g_prog,"/_file.txt"
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
   
   LET g_sql = "SELECT * FROM tqn_file WHERE ",p_wc CLIPPED,
               "   AND tqn01 IN (SELECT aag01 FROM ",l_tabname CLIPPED,")"
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
