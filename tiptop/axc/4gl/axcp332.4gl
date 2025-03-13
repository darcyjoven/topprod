# Prog. Version..: '5.30.06-13.04.19(00002)'     #
#
# Pattern name...: axcp332.4gl
# Descriptions...: 發出商品轉回憑證生成作业
# Date & Author..: 12/08/29 By xuxz  No:FUN-C80094
# Modify.........: No:MOD-D40092 13/04/15 By  wujie 为单别做预设值aaz68

DATABASE ds   

GLOBALS "../../config/top.global"
#No:FUN-C80094 add
#模組變數(Module Variables)
DEFINE g_argv1             LIKE type_file.chr1
DEFINE g_aba01             LIKE aba_file.aba01
DEFINE g_aba               RECORD LIKE aba_file.*
DEFINE g_abb               RECORD LIKE abb_file.*
DEFINE g_cdj13             LIKE cdj_file.cdj13
DEFINE tm                  RECORD 
                           b    LIKE aaa_file.aaa01, 
                           yy          LIKE type_file.num5, 
                           mm          LIKE type_file.num5, 
                           type    LIKE aac_file.aac01
                           END RECORD 
#主程式開始
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_flag              LIKE type_file.chr1
DEFINE g_change_lang       LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT         
   
   LET tm.b = ARG_VAL(1)
   LET tm.yy = ARG_VAL(2)
   LET tm.mm = ARG_VAL(3)
   LET tm.type = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(4)
    
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   SELECT oaz92,oaz93,oaz107 INTO g_oaz.oaz92,g_oaz.oaz93,g_oaz.oaz107 FROM oaz_file
   IF NOT (g_oaz.oaz92='Y' AND g_oaz.oaz93='Y' AND g_oaz.oaz107='Y') THEN 
      CALL cl_err('','axc-911',1)
      EXIT PROGRAM
   END IF 
 
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF
   IF cl_null(tm.type) THEN LET tm.type = g_aaz.aaz68 END IF   ##no.MOD-D40092
   LET g_time = TIME   
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p332_tm()
         IF cl_sure(18,20) THEN 
            CALL p332_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p332_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p332_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p332_w
      ELSE
         CALL p332_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN

FUNCTION p332_tm()
   DEFINE p_row,p_col    LIKE type_file.num5  
   DEFINE li_result      LIKE type_file.chr1
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p332_w AT p_row,p_col WITH FORM "axc/42f/axcp332" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR '' 
 
   DISPLAY BY NAME tm.b,tm.yy,tm.mm,tm.type
   IF cl_null(tm.yy) AND cl_null(tm.mm) THEN  
      SELECT sma51,sma52 INTO tm.yy,tm.mm FROM sma_file
   END IF 
   LET g_bgjob = 'N'   
   INPUT BY NAME
      tm.b,tm.yy,tm.mm,tm.type  
      WITHOUT DEFAULTS 

 
      AFTER FIELD b
         IF NOT cl_null(tm.b) THEN
            CALL p332_bookno(tm.b)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b,g_errno,0)
               LET tm.b = g_aza.aza81
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
         END IF
 
      AFTER FIELD type
         IF NOT cl_null(tm.type) THEN
            CALL p332_check_slip_no(tm.type)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.type,g_errno,0)
               LET tm.type=''
               DISPLAY BY NAME tm.type
               NEXT FIELD type
            END IF
         END IF   
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p332_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
         END IF
         IF cl_null(tm.type)THEN 
            NEXT FIELD type
         END IF  
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy 
         END IF  
         IF cl_null(tm.mm) THEN
            NEXT FIELD mm 
         END IF 
         IF cl_null(tm.b) THEN
            NEXT FIELD b 
         END IF 
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION HELP          
         CALL cl_show_help()  
      
      ON ACTION controlg      
            CALL cl_cmdask()     
      
      ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
      ON ACTION qbe_save
           CALL cl_qbe_save()
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            WHEN INFIELD(type)
               CALL q_aac(FALSE,TRUE,g_aba.aba01,'4',' ',g_user,'AGL')
                   RETURNING tm.type
               DISPLAY BY NAME tm.type
               NEXT FIELD type
         END CASE
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p332_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
END FUNCTION

FUNCTION p332_p()
   DEFINE l_aba02 LIKE aba_file.aba02,
          l_next_year     LIKE type_file.num5,
          l_next_month    LIKE type_file.num5,
          l_bdate         LIKE type_file.dat,
          l_edate         LIKE type_file.dat,
          l_n             LIKE type_file.num5,
          l_cmd     STRING
   
   CALL s_showmsg_init()
   BEGIN WORK 
   SELECT aaz85 INTO g_aaz.aaz85 FROM aaz_file
   LET g_success = 'Y'
   CALL p332_chk()
   IF g_flag ='N' THEN 
      LET g_success = 'N' 
      ROLLBACK WORK
      CALL s_showmsg()
      RETURN 
   END IF   
   IF g_bgjob = 'N' THEN 
      CALL p332_del_aba_abb()
   END IF 
   CALL p332_ins_aba_abb()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
   IF g_success = 'Y' THEN
      IF g_aza.aza02 = 1 THEN
         IF tm.mm = 12 THEN
            LET l_next_year = tm.yy+1
            LET l_next_month = 1
         ELSE
            LET l_next_year = tm.yy
            LET l_next_month = tm.mm+1
         END IF
      END IF
      IF g_aza.aza02 = 2 THEN
         IF tm.mm = 13 THEN
            LET l_next_year = tm.yy+1
            LET l_next_month = 1
         ELSE
            LET l_next_year = tm.yy
            LET l_next_month = tm.mm+1
         END IF
      END IF
      CALL s_azm(l_next_year,l_next_month)
            RETURNING l_flag,l_bdate,l_edate
      LET l_aba02=l_bdate
 #
     #DECLARE p332_conf_cs CURSOR FOR
     #   SELECT * FROM aba_file
     #    WHERE aba00 = tm.b AND aba02 = l_aba02
     #      AND aba19 = 'Y' AND aba05 = g_today
     #      AND aba03 = l_next_year AND aba04 = l_next_month
     #      AND aba07 IN (SELECT cdj13 FROM cdj_file
     #                     WHERE cdj00 = '2' AND cdj01 = tm.b
     #                       AND cdj02 = tm.yy
     #                       AND cdj03 = tm.mm
     #                       AND cdjconf = 'Y')

     #FOREACH p332_conf_cs INTO g_aba.*
     #   LET l_cmd = "aglp102 '",g_aba.aba00,"' ' 1=1' '",g_aba.aba02,"' '",g_aba.aba02,"' '",g_aba.aba01,"' '",g_aba.aba01,"' 'Y'"
     #   CALL cl_cmdrun_wait(l_cmd)
     #END FOREACH
      #xuxz --add--20120906--str--用於在無資料的時候報錯
      SELECT COUNT(*) INTO l_n FROM aba_file
          WHERE aba00 = tm.b AND aba02 = l_aba02
            AND aba19 = 'Y' AND aba05 = g_today
            AND aba06 = 'RA'
            AND aba03 = l_next_year AND aba04 = l_next_month
            AND aba07 IN (SELECT cdj13 FROM cdj_file
                           WHERE cdj00 = '2' AND cdj01 = tm.b
                             AND cdj02 = tm.yy
                             AND cdj03 = tm.mm
                             AND cdjconf = 'Y')
      IF l_n = 0 THEN 
         CALL s_errmsg('','','','axc-015',1)
         LET g_success = 'N'
      END IF 
      #xuxz --add--20120906--end
   END IF
   CALL s_showmsg()
END FUNCTION 

FUNCTION p332_ins_aba_abb()
   DEFINE l_sql STRING 
   DEFINE li_result      LIKE type_file.chr1
   DEFINE l_flag          LIKE type_file.chr1,      
          l_next_year     LIKE type_file.num5,      
          l_next_month    LIKE type_file.num5,    
          l_bdate         LIKE type_file.dat,      
          l_edate         LIKE type_file.dat
   #搜索出符合條件的cdj13 的值
   LET l_sql = " SELECT DISTINCT cdj13 FROM cdj_file ",
               "  WHERE cdj00 = '2' AND cdj01 = '",tm.b,"'",
               "    AND cdj02 = '",tm.yy,"'",
               "    AND cdj03 = '",tm.mm,"'",
               "    AND cdjconf = 'Y' "
   PREPARE p332_cdj13_pre FROM l_sql
   DECLARE p332_cdj13_cs CURSOR FOR p332_cdj13_pre
   
   #抓取aba_file的資料
   LET l_sql = " SELECT * FROM aba_file ",
               "  WHERE aba07 = ? ",
               "    AND aba00 = '",tm.b,"'",
               "    AND aba19 = 'Y' AND abapost = 'Y' "
   PREPARE p332_aba_pre FROM l_sql
   DECLARE p332_aba_cs CURSOR FOR p332_aba_pre

   #抓取abb_file的資料
   LET l_sql = " SELECT * FROM abb_file ",
               "  WHERE abb00 = '",tm.b,"'",
               "    AND abb01 = ? "
   PREPARE p332_abb_pre FROM l_sql
   DECLARE p332_abb_cs CURSOR FOR p332_abb_pre
   
   FOREACH p332_cdj13_cs INTO g_cdj13
      FOREACH p332_aba_cs USING g_cdj13 INTO g_aba.*
         #更新aba01,aba02的值后插入aba_file
         IF g_aza.aza02 = 1 THEN 
            IF tm.mm = 12 THEN
               LET l_next_year = tm.yy+1
               LET l_next_month = 1
            ELSE
               LET l_next_year = tm.yy
               LET l_next_month = tm.mm+1 
            END IF 
         END IF 
         IF g_aza.aza02 = 2 THEN 
            IF tm.mm = 13 THEN
               LET l_next_year = tm.yy+1
               LET l_next_month = 1
            ELSE
               LET l_next_year = tm.yy
               LET l_next_month = tm.mm+1 
            END IF 
         END IF 
         LET g_aba.aba03 = l_next_year
         LET g_aba.aba04 = l_next_month
         LET g_aba.aba05 = g_today
         LET g_aba.abapost = 'N'
         LET g_aba.aba19 = 'N'
         LET g_aba.aba20 = 0
         LET g_aba.aba37 = ''
         LET g_aba.aba38 = ''
         CALL s_azm(l_next_year,l_next_month) 
            RETURNING l_flag,l_bdate,l_edate
         LET g_aba.aba02=l_bdate
         LET g_aba01 = g_aba.aba01
         CALL s_auto_assign_no("agl",tm.type,g_aba.aba02,"","aba_file","aba01",g_plant,"",tm.b)
         RETURNING li_result,g_aba.aba01
         IF (NOT li_result) THEN
            LET g_success = 'N' 
            CALL s_errmsg('','','','asf-377',1)
            RETURN 
         END IF
         INSERT INTO aba_file VALUES(g_aba.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=g_aba.aba00,"/",g_aba.aba01,"/",g_aba.aba02
            CALL s_errmsg('aba00,aba01,aba02',g_showmsg,'ins_aba',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF 
         FOREACH p332_abb_cs USING g_aba01 INTO g_abb.*
            LET g_abb.abb00 = g_aba.aba00
            LET g_abb.abb01 = g_aba.aba01 
            INSERT INTO abb_file VALUES(g_abb.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=g_abb.abb00,"/",g_abb.abb01,"/",g_abb.abb02
               CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ins_abb',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF 
         END FOREACH 
         UPDATE abb_file SET abb07=-abb07,abb07f=-abb07f WHERE abb01=g_aba.aba01 AND abb00=g_aba.aba00
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=g_aba.aba00,"/",g_aba.aba01
            CALL s_errmsg('aba00,aba01',g_showmsg,'upd_abb',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         UPDATE aba_file SET aba08 = -aba08 ,aba09 = -aba09,aba06 = 'RA' WHERE aba00 = g_aba.aba00 AND aba01 = g_aba.aba01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=g_aba.aba00,"/",g_aba.aba01
            CALL s_errmsg('aba00,aba01',g_showmsg,'upd_aba',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         
        #IF g_aaz.aaz85 = 'Y' THEN
            CALL p332_updata() 
        #END IF 
      END FOREACH 
   END FOREACH 
END FUNCTION 

FUNCTION p332_chk()
   DEFINE l_aba02 LIKE aba_file.aba02
   DEFINE l_flag          LIKE type_file.chr1,      
          l_next_year     LIKE type_file.num5,      
          l_next_month    LIKE type_file.num5,      
          l_bdate         LIKE type_file.dat,      
          l_edate         LIKE type_file.dat
   DEFINE l_aba01         LIKE aba_file.aba01,
          l_aba19         LIKE aba_file.aba19,
          l_abapost       LIKE aba_file.abapost,
          l_n             LIKE type_file.num5
   LET g_flag = 'Y'
   IF g_aza.aza02 = 1 THEN 
      IF tm.mm = 12 THEN
         LET l_next_year = tm.yy+1
         LET l_next_month = 1
      ELSE
         LET l_next_year = tm.yy
         LET l_next_month = tm.mm+1 
      END IF 
   END IF 
   IF g_aza.aza02 = 2 THEN 
      IF tm.mm = 13 THEN
         LET l_next_year = tm.yy+1
         LET l_next_month = 1
      ELSE
         LET l_next_year = tm.yy
         LET l_next_month = tm.mm+1 
      END IF 
   END IF 
   CALL s_azm(l_next_year,l_next_month) 
         RETURNING l_flag,l_bdate,l_edate
   LET l_aba02=l_bdate

   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM aba_file 
    WHERE aba00 = tm.b AND aba02 = l_aba02 
      AND aba03 = l_next_year AND aba04 = l_next_month
      AND aba07 IN (SELECT cdj13 FROM cdj_file 
                     WHERE cdj00 = '2' AND cdj01 = tm.b
                       AND cdj02 = tm.yy
                       AND cdj03 = tm.mm
                       AND cdjconf = 'Y')
   IF l_n > 0 THEN 
      IF (cl_confirm("axc-217")) THEN 
      ELSE
         LET g_flag = 'N' 
         RETURN 
      END IF 
   END IF
   #判断是否可以删除
   DECLARE p332_chk_cs CURSOR FOR  
      SELECT aba01,aba19,abapost  FROM aba_file 
       WHERE aba00 = tm.b AND aba02 = l_aba02 
         AND aba03 = l_next_year AND aba04 = l_next_month
         AND aba07 IN (SELECT cdj13 FROM cdj_file 
                        WHERE cdj00 = '2' AND cdj01 = tm.b
                          AND cdj02 = tm.yy
                          AND cdj03 = tm.mm
                          AND cdjconf = 'Y')
   FOREACH p332_chk_cs INTO l_aba01,l_aba19,l_abapost
      IF l_aba19 = 'Y' AND l_abapost = 'N' AND g_aaz.aaz85 = 'N' THEN 
         LET g_flag = 'N'
         CALL s_errmsg('aba01',g_showmsg,l_aba01,'9023',1)
      END IF
      IF l_aba19 = 'Y' AND l_abapost = 'Y' THEN 
         LET g_flag = 'N'
         CALL s_errmsg('aba01',g_showmsg,l_aba01,'aar-347',1)
      END IF 
   END FOREACH 
END FUNCTION 

FUNCTION p332_del_aba_abb()
   DEFINE l_aba00 LIKE aba_file.aba00
   DEFINE l_aba01 LIKE aba_file.aba01
   DEFINE l_aba02 LIKE aba_file.aba02
   DEFINE l_next_year     LIKE type_file.num5,      
          l_next_month    LIKE type_file.num5,
          l_bdate         LIKE type_file.dat,      
          l_edate         LIKE type_file.dat
   IF g_aza.aza02 = 1 THEN 
      IF tm.mm = 12 THEN
         LET l_next_year = tm.yy+1
         LET l_next_month = 1
      ELSE
         LET l_next_year = tm.yy
         LET l_next_month = tm.mm+1 
      END IF 
   END IF 
   IF g_aza.aza02 = 2 THEN 
      IF tm.mm = 13 THEN
         LET l_next_year = tm.yy+1
         LET l_next_month = 1
      ELSE
         LET l_next_year = tm.yy
         LET l_next_month = tm.mm+1 
      END IF 
   END IF 
   CALL s_azm(l_next_year,l_next_month) 
            RETURNING l_flag,l_bdate,l_edate
   LET l_aba02=l_bdate
   DECLARE p332_del_cs CURSOR FOR  
      SELECT aba00,aba01  FROM aba_file 
       WHERE aba00 = tm.b AND aba02 = l_aba02 
         AND aba03 = l_next_year AND aba04 = l_next_month
         AND aba07 IN (SELECT cdj13 FROM cdj_file 
                        WHERE cdj00 = '2' AND cdj01 = tm.b
                          AND cdj02 = tm.yy
                          AND cdj03 = tm.mm
                          AND cdjconf = 'Y')
   FOREACH p332_del_cs INTO l_aba00,l_aba01
      DELETE FROM aba_file WHERE aba00 = l_aba00 AND aba01 = l_aba01
      DELETE FROM abb_file WHERE abb00 = l_aba00 AND abb01 = l_aba01
   END FOREACH 
END FUNCTION 

FUNCTION p332_check_slip_no(p_aac01)
  DEFINE p_aac01         LIKE aac_file.aac01
  DEFINE l_aacacti       LIKE aac_file.aacacti

    LET g_errno = ' '
    SELECT aacacti INTO l_aacacti FROM aac_file
     WHERE aac01 = p_aac01
       AND aac11 = '4' 

    CASE WHEN SQLCA.SQLCODE=100 LET g_errno = 'agl-035'
         WHEN l_aacacti = 'N'   LET g_errno = '9028'
         OTHERWISE              LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION p332_updata()
   DEFINE l_n       LIKE type_file.num5,
          l_success LIKE type_file.chr1
   SELECT COUNT(*) INTO l_n FROM abb_file,aag_file
    WHERE abb01 = g_aba.aba01
      AND abb00 = g_aba.aba00
      AND abb03 = aag01
      AND abb00 = aag00
      AND aag20 = 'Y'
   IF l_n = 0 THEN 
      IF cl_null(g_aba.aba18) THEN LET g_aba.aba19 = 0 END IF 
      IF g_aba.abamksg = 'N' THEN 
         LET g_aba.aba20='1'
         LET g_aba.aba19 = 'Y'
         CALL s_chktic (g_ccz.ccz12,g_aba.aba01) RETURNING l_success
         IF NOT l_success THEN
            LET g_aba.aba20 ='0'
            LET g_aba.aba19 ='N'
         END IF
         UPDATE aba_file SET abamksg = g_aba.abamksg,
                             abasign = g_aba.abasign,
                             aba18 = g_aba.aba18,
                             aba19 = g_aba.aba19,
                             aba20 = g_aba.aba20,
                             aba37 = g_user
          WHERE aba00 = g_aba.aba00 AND aba01 = g_aba.aba01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=g_aba.aba00,"/",g_aba.aba01
            CALL s_errmsg('aba00,aba01',g_showmsg,'upd_aba',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
      END IF 
   END IF 
END FUNCTION 

FUNCTION p332_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti

    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' 
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
        END CASE
END FUNCTION
