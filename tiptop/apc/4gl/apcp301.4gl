# Prog. Version..: '5.30.06-13.03.12(00001)'     #

#
# Pattern name...: apcp301.4gl
# Descriptions...: webservice日志删除作业
# Date & Author..: No.FUN-C70124 12/07/27 By yangxf

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE p_row,p_col             LIKE type_file.num5

DEFINE tm           RECORD
                    azw01 STRING, 
                    a     LIKE type_file.chr1,
                    b     LIKE type_file.num10
                    END RECORD         
DEFINE g_bgjob      LIKE type_file.chr1
DEFINE g_posdb      LIKE ryg_file.ryg00
DEFINE g_posdb_link LIKE ryg_file.ryg02

MAIN                     
   DEFINE l_flag    LIKE type_file.chr1         
   OPTIONS
      INPUT NO WRAP

   LET tm.azw01  = ARG_VAL(1)
   LET tm.a = ARG_VAL(2)
   LET tm.b = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p301()
         IF g_bgjob='Y' THEN
            CLOSE WINDOW p301_w
            CALL p301_p()
            EXIT WHILE
         END IF

         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL p301_p()
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF NOT l_flag THEN
               CLOSE WINDOW p301_w
               EXIT WHILE
            ELSE
               MESSAGE 'UPLOAD SUCCESS'
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p301_p()
         EXIT WHILE
      END IF
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p301()         
DEFINE lc_cmd         LIKE type_file.chr1000
DEFINE l_num          LIKE type_file.num10
   LET p_row = 2 LET p_col = 8
   OPEN WINDOW p301_w AT p_row,p_col WITH FORM "apc/42f/apcp301"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   WHILE TRUE
      MESSAGE ""
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME tm.azw01 ON azw01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
                   
            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
               EXIT DIALOG       

            ON ACTION controlp
               CASE
                  WHEN INFIELD(azw01) #指定傳輸營運中心
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_rtz01"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz01 AND zxy01 = '",g_user,"')"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO azw01
                      NEXT FIELD azw01
                  OTHERWISE EXIT CASE
               END CASE

         END CONSTRUCT 
         INPUT tm.a,tm.b,g_bgjob FROM a,b,bgjob
            BEFORE INPUT
               CALL p301_set_entry()
               CALL p301_set_no_entry()
            
            ON CHANGE a
               IF tm.a= '2' THEN
                  CALL cl_set_comp_entry("b",TRUE)
                  CALL cl_set_comp_required("b",TRUE)
               ELSE
                  CALL cl_set_comp_entry("b",FALSE)
                  CALL cl_set_comp_required("b",FALSE)
                  LET tm.b = ''
                  DISPLAY BY NAME tm.b
               END IF

            AFTER FIELD b
               IF tm.b <= 0 THEN
                  CALL cl_err('','apc-201',0)
                  LET tm.b = ''
                  NEXT FIELD b
               END IF 

            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
               EXIT DIALOG  

            AFTER INPUT
               IF INT_FLAG THEN EXIT DIALOG END IF    
     
         END INPUT
         ON ACTION CONTROLR
              CALL cl_show_req_fields()

         ON ACTION CONTROLG
            call cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 

         ON ACTION about         
            CALL cl_about()      

         ON ACTION help          
            CALL cl_show_help() 

         ON ACTION exit
            LET INT_FLAG = 1
            CLOSE WINDOW apcp301_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION close
            LET INT_FLAG=1
            CLOSE WINDOW apcp301_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION accept
            IF tm.azw01 = " 1=1" THEN
               CALL cl_err('','apc-198',0)
               NEXT FIELD azw01
            END IF 
            IF cl_null(tm.a) THEN
               CALL cl_err('','apc-200',0)
               NEXT FIELD a
            END IF 
            IF tm.a = '2' AND cl_null(tm.b) THEN 
               CALL cl_err('','apc-199',0)
               NEXT FIELD b
            END IF 
            IF tm.b <= 0 THEN
               CALL cl_err('','apc-201',0)
               NEXT FIELD b
            END IF 
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            CLOSE WINDOW apcp301_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
      END DIALOG

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p301_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
       
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "apcp301"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('apcp301','9031',1) 
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
            " '",tm.azw01 CLIPPED,"'",
            " '",tm.a CLIPPED,"'",
            " '",tm.b CLIPPED,"'",
            " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('apcp301',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p301_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p301_p()
DEFINE l_date         LIKE type_file.dat
DEFINE l_posdb        LIKE ryg_file.ryg00
DEFINE l_posdb_link   LIKE ryg_file.ryg02
DEFINE l_plant        LIKE azp_file.azp01
DEFINE l_sql          STRING 
   #计算年月
   IF tm.a = '1' THEN 
      LET l_date = g_today
   ELSE 
       CALL s_incmonth(g_today,(tm.b*(-1)+1)) RETURNING l_date
       LET l_date = MDY((MONTH(l_date)),1,YEAR(l_date))
   END IF 
   SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file
   LET g_posdb=s_dbstring(l_posdb)
   LET g_posdb_link=p301_dblinks(l_posdb_link)
   CALL s_showmsg_init()        #錯誤訊息統整初始化函式
   LET tm.azw01 = cl_replace_str(tm.azw01,"azw01","rxu03")
   BEGIN WORK
   #删除ERP的Webservice日志
   LET l_sql = "DELETE FROM rxu_file ", 
               " WHERE rxu11 < '",l_date,"'",
               "   AND rxu03 IN ",g_auth,
               "   AND ",tm.azw01 CLIPPED
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE p301_del_rxu FROM l_sql
   EXECUTE p301_del_rxu
   IF SQLCA.sqlcode THEN
      LET g_showmsg = tm.azw01
      CALL s_errmsg('azw01',g_showmsg,'del rxu_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
   #删除中间库的Webservice日志
   CALL cl_replace_str(tm.azw01,"rxu03","SHOP") RETURNING tm.azw01
   LET l_sql = "DELETE FROM ",g_posdb,"tk_WSLog",g_posdb_link,
               " WHERE SHOP IN ",g_auth,
               "   AND RDate < '",l_date,"'",
               "   AND ",tm.azw01 CLIPPED
   PREPARE p301_del_tk FROM l_sql
   EXECUTE p301_del_tk
   IF SQLCA.sqlcode THEN
      LET g_showmsg = tm.azw01
      CALL s_errmsg('azw01',g_showmsg,'del tk_WSLog',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN 
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
   END IF 
   CALL s_showmsg()
END FUNCTION

FUNCTION p301_set_entry()
    IF tm.a= '2' THEN
       CALL cl_set_comp_entry("b",TRUE)
       CALL cl_set_comp_required("b",TRUE)
    END IF
END FUNCTION

FUNCTION p301_set_no_entry()
    IF tm.a= '1' THEN
       CALL cl_set_comp_entry("b",FALSE)
       CALL cl_set_comp_required("b",FALSE)
    END IF
END FUNCTION

FUNCTION p301_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02
  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
END FUNCTION

#FUN-C70124
