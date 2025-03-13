# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgp300.4gl
# Descriptions...: 預算底稿產生作業(原部門科目預算產生作業)
# Date & Author..: No.FUN-810069 08/02/28 By douzh 預算編號管控調整/更改作業名稱為"預算底稿產生作業" 
# ...............:                                 因為涉及到對應的檔案發生重大變化,經討論重寫該作業
# Modify.........: No.TQC-830032 08/03/04 By douzh 預算bug調整
# Modify.........: No.TQC-840018 08/03/04 By douzh 更改拋轉提示
# Modify.........: No.CHI-860004 08/12/16 By Sarah abg-124訊息改為abg-130
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現

IMPORT os   #No.FUN-9C0009  
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
       g_sql            string,  
       g_bgq01          LIKE bgq_file.bgq01,      #版本
       g_bgq02          LIKE bgq_file.bgq02,      #年度
       g_bgq02_t        LIKE bgq_file.bgq02,      #舊值
       tm               RECORD 
          azp01         LIKE azp_file.azp01       #集團公司營運中心
                        END RECORD,
       g_change_lang    LIKE type_file.chr1,  
       ls_date          STRING,               
       l_flag           LIKE type_file.chr1,   
       p_row,p_col      LIKE type_file.num5     
DEFINE g_afd            RECORD LIKE afd_file.*
DEFINE g_afe            RECORD LIKE afe_file.*
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose
DEFINE g_cnt            LIKE type_file.num5  
DEFINE g_azp01          LIKE azp_file.azp01     #當前營運中心
DEFINE g_azp03          LIKE azp_file.azp03     #資料庫代碼
DEFINE g_aza17          LIKE aza_file.aza17     #集團中心幣別
DEFINE g_aza17_2        LIKE aza_file.aza17     #系統當前幣別
DEFINE g_rate           LIKE azj_file.azj03     #轉換匯率
DEFINE g_dbs_rep        LIKE type_file.chr50    #資料庫代碼前綴
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
     INITIALIZE g_bgjob_msgfile TO NULL
     LET g_bgq01 = ARG_VAL(1)
     LET g_bgq02 = ARG_VAL(2)
     LET g_bgjob = ARG_VAL(3)
     IF cl_null(g_bgjob) THEN
        LET g_bgjob = 'N'
     END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
 
   WHILE TRUE
      IF g_bgjob="N" THEN
         LET g_success="Y"
         CALL p300()
         IF g_success = 'Y' THEN
            IF cl_sure(0,0) THEN
               CALL cl_wait()
               LET g_success="Y"
               BEGIN WORK
               CALL p300_cur()
               IF g_success = 'Y' THEN
                  CALL cl_cmmsg(1)
                  COMMIT WORK
                  CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
               ELSE
                  CALL cl_rbmsg(1)
                  ROLLBACK WORK
                  CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
               END IF
               IF l_flag THEN
                  CONTINUE WHILE
               ELSE
                  CLOSE WINDOW p300_w
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p300_w
      ELSE
         LET g_success="Y"
         BEGIN WORK
         CALL p300_cur()
         IF g_success="Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p300()
    DEFINE lc_cmd           LIKE zz_file.zz08  
    DEFINE p_row,p_col      LIKE type_file.num5 
    DEFINE l_n              LIKE type_file.num5    #No.TQC-840018
    DEFINE l_cnt            LIKE type_file.num5    #No.TQC-840018
    DEFINE l_flag           LIKE type_file.num5    #No.TQC-840018
    DEFINE l_dbs            LIKE type_file.chr50 
    DEFINE l_sql            STRING
    DEFINE l_aza17          LIKE aza_file.aza17
    DEFINE l_aza17_2        LIKE aza_file.aza17
    DEFINE l_azp03          LIKE azp_file.azp03
    DEFINE l_rate           LIKE azj_file.azj03    #匯率
 
    LET p_row=5
    LET p_col=25
 
    OPEN WINDOW p300_w AT p_row,p_col WITH FORM "abg/42f/abgp300"
    ATTRIBUTE(STYLE=g_win_style)
 
    CALL cl_ui_init()
 
    CLEAR FORM
    CALL cl_opmsg('z')                 #不確定call的提示是否正確
 
    LET g_azp01 = g_plant
    LET g_bgq02 = YEAR(g_today)
    LET g_bgjob = "N"                        
    WHILE TRUE                             
      INPUT g_bgq01,g_bgq02,tm.azp01,g_bgjob WITHOUT DEFAULTS
        FROM bgq01,bgq02,azp01,g_bgjob                    
 
      AFTER FIELD bgq01
         IF cl_null(g_bgq01) THEN LET g_bgq01 = ' ' END IF
 
#No.TQC-840018--begin
      AFTER FIELD bgq02
        IF cl_null(g_bgq02) THEN 
           LET g_bgq02 = g_bgq02_t
               NEXT FIELD bgq02
        END IF
 
      AFTER FIELD azp01
         IF cl_null(tm.azp01) THEN
            NEXT FIELD azp01
         ELSE
            SELECT COUNT(*) INTO l_cnt FROM azp_file WHERE azp01= tm.azp01
            IF l_cnt =0 THEN
               CALL cl_err(tm.azp01,'mfg9142',1)
               NEXT FIELD azp01
            END IF
            SELECT aza17 INTO g_aza17_2 FROM aza_file
            SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01 = tm.azp01
            CALL s_dbstring(g_azp03) RETURNING g_dbs_rep
           #LET l_sql="SELECT aza17 FROM ",g_dbs_rep CLIPPED,"aza_file"   #FUN-A50102
            LET l_sql="SELECT aza17 FROM ",cl_get_target_table(tm.azp01,'aza_file')  #FUN-A50102 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
            PREPARE aza_cs FROM l_sql 
            EXECUTE aza_cs INTO g_aza17
            CALL s_curr(g_aza17,g_today) RETURNING l_rate
            LET g_rate = 1/l_rate
            DISPLAY g_aza17 TO aza17
            DISPLAY g_aza17_2 TO aza17_2
            DISPLAY g_rate TO rate
           #LET l_sql= "SELECT COUNT(*) FROM ",g_dbs_rep CLIPPED,"afe_file",  #FUN-A50102
            LET l_sql= "SELECT COUNT(*) FROM ",cl_get_target_table(tm.azp01,'afe_file'),  #FUN-A50102
                       " WHERE afe00 = '",g_bgq01 CLIPPED,"' ",
                       " AND afe02 = '",g_bgq02 CLIPPED,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
            PREPARE count_cs FROM l_sql 
            EXECUTE count_cs INTO l_n
            IF l_n>0 THEN
               IF cl_confirm('abg-130') THEN   #CHI-860004 mod
                  CONTINUE INPUT
               ELSE
                  LET g_success = 'N'
                  EXIT INPUT                    
               END IF
            END IF
         END IF
#No.TQC-840018--end
      ON ACTION controlp
         CASE
            WHEN INFIELD(azp01) #集團中心營運編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = tm.azp01
               CALL cl_create_qry() RETURNING tm.azp01
               DISPLAY tm.azp01 TO azp01
               NEXT FIELD azp01
            OTHERWISE EXIT CASE
          END CASE
 
        ON ACTION locale                  
           LET g_change_lang = TRUE        
           EXIT INPUT                    
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about     
           CALL cl_about()   
 
        ON ACTION help        
           CALL cl_show_help() 
 
        BEFORE INPUT
           CALL cl_qbe_init()
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
    END INPUT
 
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW p300_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
     END IF
 
     IF g_bgjob="Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01="abgp300"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('abgp300','9031',1) 
        ELSE   
           LET lc_cmd=lc_cmd CLIPPED,
                      " '",g_bgq01 CLIPPED,"'",
                      " '",g_bgq02 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('abgp300',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p300_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
     EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION p300_cur()
#TQC-830032--begin
    DEFINE sr   RECORD bgq01  LIKE bgq_file.bgq01,
                       bgq02  LIKE bgq_file.bgq02,
                       bgq03  LIKE bgq_file.bgq03,
                       bgq04  LIKE bgq_file.bgq04,
                       bgq05  LIKE bgq_file.bgq05,
                       bgq06  LIKE bgq_file.bgq06,
                       bgq061 LIKE bgq_file.bgq061,
                       bgq07  LIKE bgq_file.bgq07,
                       bgq08  LIKE bgq_file.bgq08,
                       bgq09  LIKE bgq_file.bgq09,
                       bgq051 LIKE bgq_file.bgq051,
                       bgq052 LIKE bgq_file.bgq052,
                       bgq053 LIKE bgq_file.bgq053 
               END RECORD,
#TQC-830032--end
           l_name      LIKE type_file.chr20,    #NO.FUN-680061 VARCHAR(20) 
           l_afd04     LIKE afd_file.afd04,
           l_cmd       LIKE type_file.chr50     #No.FUN-680061 VARCHAR(30)
    DEFINE l_sql       STRING     
 
   #LET l_sql = "DELETE FROM ",g_dbs_rep,"afd_file",
    LET l_sql = "DELETE FROM ",cl_get_target_table(tm.azp01,'afd_file'),   #FUN-A50102
                " WHERE afd00 = '",g_bgq01 CLIPPED,"'",
                "   AND afd01 = '",g_azp01 CLIPPED,"'",
                "   AND afd02 = '",g_bgq02 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
    PREPARE afd_r FROM l_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('afd_r',SQLCA.sqlcode,1)
    END IF
    EXECUTE afd_r  
    IF SQLCA.sqlcode THEN 
       LET g_success = 'N'   
       CALL cl_err('afd_r:ckp#',SQLCA.sqlcode,1) 
    END IF
   #LET l_sql = "DELETE FROM ",g_dbs_rep,"afe_file",   #FUN-A50102
    LET l_sql = "DELETE FROM ",cl_get_target_table(tm.azp01,'afe_file'),   #FUN-A50102
                " WHERE afe00 = '",g_bgq01 CLIPPED,"'",
                "   AND afe01 = '",g_azp01 CLIPPED,"'",
                "   AND afe02 = '",g_bgq02 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
    PREPARE afe_r FROM l_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('afd_e',SQLCA.sqlcode,1)
    END IF
    EXECUTE afe_r
    IF SQLCA.sqlcode THEN 
       LET g_success = 'N'   
       CALL cl_err('afe_r:ckp#',SQLCA.sqlcode,1) 
    END IF
 
    LET g_sql="SELECT * FROM bgq_file ",
              " WHERE bgq01 ='",g_bgq01 CLIPPED,"'",
              " AND bgq02 = '",g_bgq02 CLIPPED,"'",
              " ORDER BY bgq01,bgq02,bgq04,bgq05,bgq051,bgq052,bgq053,bgq03"
 
    PREPARE p300_prepare FROM g_sql
    DECLARE p300_cur CURSOR FOR p300_prepare
 
    CALL cl_outnam('abgp300')  RETURNING l_name
    START REPORT abgp300_rep TO l_name
      FOREACH p300_cur INTO sr.*
        IF STATUS THEN
           CALL cl_err('p300(foreach):',STATUS,1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT abgp300_rep(sr.*)
      END FOREACH
    FINISH REPORT abgp300_rep
#   CALL p300_account()
    CLOSE p300_cur
END FUNCTION
 
REPORT abgp300_rep(sr)
#TQC-830032--begin
  DEFINE  sr  RECORD bgq01  LIKE bgq_file.bgq01,
                     bgq02  LIKE bgq_file.bgq02,
                     bgq03  LIKE bgq_file.bgq03,
                     bgq04  LIKE bgq_file.bgq04,
                     bgq05  LIKE bgq_file.bgq05,
                     bgq06  LIKE bgq_file.bgq06,
                     bgq061 LIKE bgq_file.bgq061,
                     bgq07  LIKE bgq_file.bgq07,
                     bgq08  LIKE bgq_file.bgq08,
                     bgq09  LIKE bgq_file.bgq09,
                     bgq051 LIKE bgq_file.bgq051,
                     bgq052 LIKE bgq_file.bgq052,
                     bgq053 LIKE bgq_file.bgq053 
              END RECORD
#TQC-830032--end
  DEFINE i,t_mm LIKE type_file.num5  
  DEFINE  l_q1 LIKE bgq_file.bgq06,       #第一季預算加總
          l_q2 LIKE bgq_file.bgq06,       #第二季預算加總
          l_q3 LIKE bgq_file.bgq06,       #第三季預算加總
          l_q4 LIKE bgq_file.bgq06        #第四季預算加總
  DEFINE l_sum1 LIKE afe_file.afe09       
  DEFINE l_sum2 LIKE afe_file.afe10       
  DEFINE l_sum3 LIKE afe_file.afe11       
  DEFINE l_sum4 LIKE afe_file.afe12       
  DEFINE l_sql  STRING
 
  ORDER EXTERNAL BY sr.bgq01,sr.bgq02,sr.bgq04,sr.bgq05,
                    sr.bgq051,sr.bgq052,sr.bgq053,sr.bgq03
  FORMAT
  BEFORE GROUP OF sr.bgq053
     LET l_q1 = 0
     LET l_q2 = 0
     LET l_q3 = 0
     LET l_q4 = 0
     LET t_mm = 0
 
  ON EVERY ROW       #單身
     LET g_afe.afe00 = g_bgq01
     LET g_afe.afe01 = g_azp01
     LET g_afe.afe02 = g_bgq02
     LET g_afe.afe03 = sr.bgq05
     LET g_afe.afe04 = sr.bgq051
     LET g_afe.afe05 = sr.bgq052
     LET g_afe.afe06 = sr.bgq053
     LET g_afe.afe07 = sr.bgq04
     LET g_afe.afe08 = sr.bgq03
     LET g_afe.afe09 = (sr.bgq06 + sr.bgq061 + sr.bgq08) * g_rate
     LET g_afe.afe10 = 0
     LET g_afe.afe11 = sr.bgq06 + sr.bgq061 + sr.bgq08  
     LET g_afe.afe12 = 0
     FOR i = t_mm+1 TO sr.bgq03
         LET g_afe.afe08 = i
         IF i = sr.bgq03 THEN
            LET g_afe.afe09 = (sr.bgq06 + sr.bgq061 + sr.bgq08) * g_rate
            LET g_afe.afe11 = sr.bgq06 + sr.bgq061 + sr.bgq08
         ELSE
            LET g_afe.afe09 = 0
            LET g_afe.afe11 = 0
         END IF
        #LET l_sql="INSERT INTO ",g_dbs_rep CLIPPED,"afe_file ",  #FUN-A50102
         LET l_sql="INSERT INTO ",cl_get_target_table(tm.azp01,'afe_file'),  #FUN-A50102 
                   " VALUES(?,?,?,?, ?,?,?,?, ?,?,?,?, ?)"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
         PREPARE ins_afe FROM l_sql  
         EXECUTE ins_afe USING g_afe.*
         IF STATUS THEN
            CALL cl_err3("ins","afe_file",g_afe.afe01,g_afe.afe02,STATUS,"","ins afe",1) #FUN-660105
            LET g_success = 'N'
            RETURN
         END IF
         IF SQLCA.SQLERRD[3] = 0 THEN LET g_success = 'N' END IF
     END FOR
     LET t_mm = g_afe.afe08   #舊值
 
     IF sr.bgq03 >= 1 AND sr.bgq03 <=3 THEN
        LET l_q1 = l_q1 + sr.bgq06 + sr.bgq061 + sr.bgq08
     END IF
     IF sr.bgq03 >= 4 AND sr.bgq03 <=6 THEN
        LET l_q2 = l_q2 + (sr.bgq06 + sr.bgq061 + sr.bgq08)
     END IF
     IF sr.bgq03 >= 7 AND sr.bgq03 <=9 THEN
        LET l_q3 = l_q3 + (sr.bgq06 + sr.bgq061 + sr.bgq08)
     END IF
     IF sr.bgq03 >=10 AND sr.bgq03 <=12 THEN
        LET l_q4 = l_q4 + (sr.bgq06 + sr.bgq061 + sr.bgq08)
     END IF
 
  AFTER GROUP OF sr.bgq053      #單頭
     IF sr.bgq03 != 12 THEN
        FOR i = sr.bgq03+1 TO 12
         LET g_afe.afe08 = i
         LET g_afe.afe09 = 0
         LET g_afe.afe11 = 0
         #LET l_sql="INSERT INTO ",g_dbs_rep CLIPPED,"afe_file ",   #FUN-A50102
         LET l_sql="INSERT INTO ",cl_get_target_table(tm.azp01,'afe_file'),   #FUN-A50102 
                   " VALUES(?,?,?,?, ?,?,?,?, ?,?,?,?, ?)"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
         PREPARE ins_afe_2 FROM l_sql  
         EXECUTE ins_afe_2 USING g_afe.*
         IF STATUS THEN
            CALL cl_err3("ins","afe_file",g_afe.afe01,g_afe.afe02,STATUS,"","ins afe",1) #FUN-660105
            LET g_success = 'N'
            RETURN
         END IF
         IF SQLCA.SQLERRD[3] = 0 THEN LET g_success = 'N' END IF
        END FOR
     END IF
     LET l_sql= "SELECT afe00,afe01,afe02,afe03,afe04,afe05,afe06,afe07,",
                "SUM(afe09),SUM(afe10),SUM(afe11),SUM(afe12) ",
               #" FROM ",g_dbs_rep CLIPPED,"afe_file",   #FUN-A50102
                " FROM ",cl_get_target_table(tm.azp01,'afe_file'),   #FUN-A50102
                " WHERE afe00 = '",g_bgq01 CLIPPED,"' ", 
                " AND afe01 = '",g_azp01 CLIPPED,"' ",
                " AND afe02 = '",g_bgq02 CLIPPED,"' ",
                " AND afe03 = '",sr.bgq05 CLIPPED,"' ",
                " AND afe04 = '",sr.bgq051 CLIPPED,"' ",
                " AND afe05 = '",sr.bgq052 CLIPPED,"' ", 
                " AND afe06 = '",sr.bgq053 CLIPPED,"' ", 
                " AND afe07 = '",sr.bgq04 CLIPPED,"' ", 
                " GROUP BY afe00,afe01,afe02,afe03,afe04,afe05,afe06,afe07"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
      PREPARE sel_afe FROM l_sql  
      EXECUTE sel_afe INTO g_afd.afd00,g_afd.afd01,g_afd.afd02,g_afd.afd03,
                           g_afd.afd04,g_afd.afd05,g_afd.afd06,g_afd.afd07,
                           l_sum1,l_sum2,l_sum3,l_sum4
     LET g_afd.afd00 = g_bgq01
     LET g_afd.afd01 = g_azp01
     LET g_afd.afd02 = g_bgq02
     LET g_afd.afd03 = sr.bgq05
     LET g_afd.afd04 = sr.bgq051
     LET g_afd.afd05 = sr.bgq052
     LET g_afd.afd06 = sr.bgq053
     LET g_afd.afd07 = sr.bgq04
     LET g_afd.afd08 = g_user
     IF g_aza.aza01 = '0' THEN
        LET g_afd.afd09 = g_aza17
     END IF
     IF g_aza.aza01 = '0' THEN
        LET g_afd.afd11 = g_aza17_2
     END IF
     LET g_afd.afd10 = l_sum1+l_sum2
     LET g_afd.afd12 = l_sum3+l_sum4
     IF cl_null(g_afd.afd10) THEN LET g_afd.afd10=0 END IF 
     IF cl_null(g_afd.afd12) THEN LET g_afd.afd12=0 END IF 
     LET g_afd.afdacti = 'Y'
     LET g_afd.afduser = g_user
     LET g_afd.afdgrup = g_grup
     LET g_afd.afdmodu = ' '
     LET g_afd.afddate = g_today
     LET g_afd.afdoriu = g_user    #NO.TQC-A10060  add
     LET g_afd.afdorig = g_grup    #NO.TQC-A10060  add
    #LET l_sql="INSERT INTO ",g_dbs_rep CLIPPED,"afd_file ",  #FUN-A50102
     LET l_sql="INSERT INTO ",cl_get_target_table(tm.azp01,'afd_file'),   #FUN-A50102
               " VALUES(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)"   #NO.TQC-A10060  add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,tm.azp01) RETURNING l_sql  #FUN-A50102
         PREPARE ins_afd FROM l_sql  
         EXECUTE ins_afd USING g_afd.*
     IF STATUS THEN
        CALL cl_err3("ins","afd_file",g_afd.afd01,g_afd.afd02,STATUS,"","ins afd",1) #FUN-660105
        LET g_success = 'N'
        RETURN
     END IF
     IF SQLCA.SQLERRD[3] = 0 THEN LET g_success = 'N' END IF
 
END REPORT
 
FUNCTION p300_account()
    DEFINE l_name1,l_name2  LIKE type_file.chr20, 
           l_cmd   LIKE type_file.chr50          
    DEFINE l_exist LIKE type_file.chr1            
    DEFINE sr1 RECORD LIKE afd_file.*
    DEFINE tp RECORD LIKE afd_file.*
    DEFINE sr2 RECORD LIKE afe_file.*
    DEFINE a       LIKE type_file.chr1             #No.FUN-680061 VARCHAR(01)
    DEFINE l_afe   RECORD LIKE afe_file.* 
    DEFINE l_afd   RECORD LIKE afd_file.*,
           l_tmp   RECORD
                    p001    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
                    p002    LIKE afd_file.afd02    #NO.FUN-680061 VARCHAR(24)
                   END RECORD,
           l_cnt   LIKE type_file.num5             #No.FUN-680061 SMALLINT
     CREATE TEMP TABLE tmp_file(
           p01  LIKE type_file.chr1,  
           p02  LIKE aab_file.aab01)
        ;
     CREATE UNIQUE INDEX tmp_01 ON tmp_file (p02)
     DECLARE judge_cur CURSOR FOR
        SELECT * FROM afd_file
         WHERE afd00 = g_bgq01 AND afd01 = g_azp01
           AND afd02 = g_bgq02
     IF SQLCA.SQLCODE THEN CALL cl_err('judge',status,1) END IF
     FOREACH judge_cur INTO tp.*
       IF SQLCA.SQLCODE THEN CALL cl_err('temp_foreach',status,1) END IF
       SELECT COUNT(*) INTO l_cnt FROM afd_file
        WHERE afd00 = g_bgq01   AND afd01 = g_azp01
          AND afd02 = tp.afd02  
       IF l_cnt = 0 OR cl_null(l_cnt) THEN
          LET l_exist = 'N'
       ELSE
          LET l_exist = 'Y'
       END IF
       INSERT INTO tmp_file values(l_exist,tp.afd02)
     END FOREACH
 
     DECLARE tmp_cur CURSOR WITH HOLD FOR
       SELECT * FROM tmp_file
 
      LET l_name1 = 'abgp3001.out'
      START REPORT p300_rep1 TO l_name1
      IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',status,1) END IF
 
      LET l_name2 = 'abgp3002.out'
      START REPORT p300_rep2 TO l_name2
      IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',status,1) END IF
 
      FOREACH tmp_cur INTO l_tmp.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('tmp_cur',status,1)
         EXIT FOREACH
      END IF
 
       #----------afd_file部份----------
        DECLARE p300_cur1 CURSOR FOR
          SELECT *  FROM afd_file WHERE afd00 = g_bgq01 AND afd01 = g_azp01
          AND afd02 = l_tmp.p002 
          ORDER BY afd00, afd01, afd02,afd03,afd04,afd05,afd06,afd07
          IF SQLCA.SQLCODE THEN CALL cl_err('p300_cur1',STATUS,1) END IF
          FOREACH p300_cur1 INTO l_afd.*
              IF SQLCA.SQLCODE THEN CALL cl_err('p300_for1',STATUS,1)
                 EXIT FOREACH END IF
              OUTPUT TO REPORT p300_rep1(l_afd.*,l_tmp.p001)
          END FOREACH
       #----------afe_file部份----------#
        DECLARE p300_cur2 CURSOR FOR
          SELECT * FROM afe_file WHERE afe00 = g_bgq01 AND afe01 = g_azp01
          AND afe02 = l_tmp.p002 
          IF SQLCA.SQLCODE THEN CALL cl_err('p300_cur2',STATUS,1) END IF
          FOREACH p300_cur2 INTO l_afe.*
            IF SQLCA.SQLCODE THEN CALL cl_err('p300_for2',STATUS,1)
               EXIT FOREACH END IF
            OUTPUT TO REPORT p300_rep2(l_afe.*,l_tmp.p001)
          END FOREACH
      END FOREACH
      FINISH REPORT p300_rep1
      FINISH REPORT p300_rep2
#       LET l_cmd = "chmod 777 ", l_name1," ",l_name2       #No.FUN-9C0009
#       RUN l_cmd                                           #No.FUN-9C0009
        IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009 
        IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009
     CLOSE p300_cur1
     CLOSE p300_cur2
 
     DROP TABLE tmp_file
END FUNCTION
 
 
REPORT p300_rep1(sr1,p_p001)
  DEFINE sr1 RECORD LIKE afd_file.*
  DEFINE p_p001 LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
  DEFINE m_afd RECORD LIKE afd_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER EXTERNAL BY sr1.afd00, sr1.afd01, sr1.afd03, sr1.afd02,
                    sr1.afd04, sr1.afd05, sr1.afd06, sr1.afd07
 
  FORMAT
      AFTER GROUP OF sr1.afd07
         LET m_afd.afd10=GROUP SUM(sr1.afd10)
         LET m_afd.afd12=GROUP SUM(sr1.afd12)
         IF p_p001 ='Y' THEN
            UPDATE afd_file SET afd10 = m_afd.afd10, 
                                afd12 = m_afd.afd12 
                   WHERE afd00 = sr1.afd00 AND afd01 = sr1.afd01
                     AND afd03 = sr1.afd03 AND afd02 = sr1.afd02
                     AND afd04 = sr1.afd04 AND afd05 = sr1.afd05
                     AND afd06 = sr1.afd06 AND afd07 = sr1.afd07
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("upd","afd_file",sr1.afd00,sr1.afd01,SQLCA.sqlcode,"","upd afd:",0) #FUN-660105
               RETURN
            END IF
         END IF
         IF p_p001 ='N' THEN
            LET m_afd.afd00 = sr1.afd00
            LET m_afd.afd01 = sr1.afd01
            LET m_afd.afd02 = sr1.afd02
            LET m_afd.afd03 = sr1.afd03
            LET m_afd.afd04 = sr1.afd04
            LET m_afd.afd05 = sr1.afd05
            LET m_afd.afd06 = sr1.afd06
            LET m_afd.afd07 = sr1.afd07
            LET m_afd.afd08 = sr1.afd08
            LET m_afd.afd09 = sr1.afd09
            LET m_afd.afd10 = sr1.afd10
            LET m_afd.afd11 = sr1.afd11
            LET m_afd.afd12 = sr1.afd12
            LET m_afd.afdacti = 'Y'
            LET m_afd.afddate = g_today
            LET m_afd.afdgrup = g_grup
            LET m_afd.afdmodu = g_user
            LET m_afd.afduser = g_user
            LET m_afd.afdoriu = g_user      #No.FUN-980030 10/01/04
            LET m_afd.afdorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO afd_file VALUES(m_afd.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","afd_file",m_afd.afd01,m_afd.afd02,SQLCA.sqlcode,"","ins afd",0) #FUN-660105
               RETURN
            END IF
         END IF
END REPORT
 
REPORT p300_rep2(sr2,p_p001)
  DEFINE sr2 RECORD LIKE afe_file.*
  DEFINE p_p001 LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
  DEFINE m_afe    RECORD LIKE afe_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr2.afe00,sr2.afe01,sr2.afe03,sr2.afe02,sr2.afe05,
           sr2.afe04,sr2.afe06,sr2.afe07,sr2.afe08
 
  FORMAT
      AFTER GROUP OF sr2.afe08
         LET m_afe.afe09=GROUP SUM(sr2.afe09)
         LET m_afe.afe11=GROUP SUM(sr2.afe11)
      IF p_p001='Y'  THEN
         UPDATE afe_file SET afe09 = m_afe.afe09, 
                             afe11 = m_afe.afe11
                         WHERE afe00 = sr2.afe00 AND afe01 = sr2.afe01
                           AND afe02 = sr2.afe02 AND afe03 = sr2.afe03
                           AND afe04 = sr2.afe04 AND afe05 = sr2.afe05
                           AND afe06 = sr2.afe06 AND afe07 = sr2.afe07
                           AND afe08 = sr2.afe08
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("upd","afe_file",sr2.afe00,sr2.afe01,SQLCA.sqlcode,"","upd afe:",0) #FUN-660105
            RETURN
         END IF
      END IF
      IF p_p001='N' THEN
         LET m_afe.afe00 = sr2.afe00
         LET m_afe.afe01 = sr2.afe01
         LET m_afe.afe02 = sr2.afe02
         LET m_afe.afe03 = sr2.afe03
         LET m_afe.afe04 = sr2.afe04
         LET m_afe.afe05 = sr2.afe05
         LET m_afe.afe06 = sr2.afe06
         LET m_afe.afe07 = sr2.afe07
         LET m_afe.afe08 = sr2.afe08
         IF g_bgq02 != sr2.afe03 THEN #不同會計年度...已消耗預算不能代出
            LET m_afe.afe07 = 0
         END IF
         INSERT INTO afe_file VALUES(m_afe.*)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","afe_file",m_afe.afe00,m_afe.afe01,SQLCA.sqlcode,"","ins afe:",0) #FUN-660105
            RETURN
         END IF
      END IF
END REPORT
#No.FUN-810069
