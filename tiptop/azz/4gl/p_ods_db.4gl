# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: p_ods_db.4gl
# Descriptions...: 讓使用者能夠知道目前ods所涵蓋的資料庫範圍有哪幾個
# Date & Author..: 10/03/29 Jay FUN-A30103
# Modify.........: No.FUN-A40066 10/05/05 By Jay 加入六個基本欄位
# Modify.........: No.FUN-A50015 10/05/14 By Jay DS需納入ODS資料庫
# Modify.........: No.FUN-A60017 10/06/03 By Kevin  加入GP5.2 SQL SERVER 語法
# Modify.........: No.FUN-A60045 10/06/11 By Jay  重新建立ods的view
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
#FUN-A30103
GLOBALS "../../config/top.global"

DEFINE g_azwd                DYNAMIC ARRAY OF RECORD 
         azwd01         LIKE azwd_file.azwd01  
                            END RECORD 
DEFINE g_azwd_t              RECORD 
         azwd01         LIKE azwd_file.azwd01  
                            END RECORD 
DEFINE g_wc2                STRING 
DEFINE g_sql                STRING 
DEFINE g_rec_b              LIKE type_file.num5       # 單身筆數   
DEFINE l_ac                 LIKE type_file.num5       # 目前處理的ARRAY CNT  SMALLINT
DEFINE g_cnt                LIKE type_file.num10      # INTEGER
DEFINE g_forupd_sql         STRING
DEFINE g_ms_db              STRING
DEFINE g_before_input_done  LIKE type_file.num5       # SMALLINT

DEFINE g_azwd_bk            DYNAMIC ARRAY OF RECORD   #FUN-A60045記錄g_azwd_bk一開始的值,以利後面判斷是否需rebuild_ods_view
         azwd01         LIKE azwd_file.azwd01  
                            END RECORD 

MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP                               # 輸入的方式: 不打轉
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)                  # 計算使用時間 (進入時間) 
         RETURNING g_time    

   OPEN WINDOW p_ods_db_w WITH FORM "azz/42f/p_ods_db"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   LET g_ms_db = FGL_GETENV("MSSQLAREA") CLIPPED,"_"
   
   LET g_forupd_sql = "SELECT azwd01 FROM azwd_file ",
                       "  WHERE azwd01 = ? FOR UPDATE "
   DECLARE p_ods_db_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_wc2 = '1=1'         
   CALL p_ods_db_b_fill(g_wc2)
   CALL p_ods_db_azwd_bk_fill()                    #FUN-A60045
   CALL p_ods_db_menu()

   CLOSE WINDOW p_ods_db_w                           # 結束畫面
   CALL  cl_used(g_prog,g_time,2)                  # 計算使用時間 (退出使間) 
         RETURNING g_time    

END MAIN


FUNCTION p_ods_db_menu()

  DEFINE   l_log_file      STRING              #FUN-A60045:rebuild_ods_view結束後,彈出訊息使用的變數.

   WHILE TRUE
      CALL p_ods_db_bp("G")
      CASE g_action_choice

      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_ods_db_q()
         END IF

       WHEN "detail"                            # "B.單身"
          IF cl_chk_act_auth() THEN
             CALL p_ods_db_b()
          ELSE
             LET g_action_choice = " "
          END IF
          CALL p_ods_db_b_fill(g_wc2)           # FUN-A60045

      WHEN "exit"
         #----------FUN-A60045 modify start----------------------
         IF p_ods_db_chk_azwd_change() THEN   
            IF p_create_schema_conf("azz1048") THEN
               CALL p_create_schema_rebuild_ods_view() RETURNING l_log_file
               CALL p_create_schema_info("azz1011", l_log_file)
            END IF
         END IF
         #----------FUN-A60045 modify end------------------------
         EXIT WHILE

      WHEN "exporttoexcel"   
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azwd),'','')
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION p_ods_db_q()
   CALL p_ods_db_b_askkey()
END FUNCTION

FUNCTION p_ods_db_b()

DEFINE r_azwd01                DYNAMIC ARRAY OF RECORD 
         azwd01         LIKE azwd_file.azwd01
                              END RECORD
 
DEFINE l_ac_n           LIKE type_file.num5                     # 目前處理的ARRAY CNT  SMALLINT
DEFINE l_cnt            LIKE type_file.num5                     # 記錄目前被刪除的Count  SMALLINT
DEFINE f_azwd01         STRING                                  # 記錄DB已被刪除的名稱

DEFINE   l_ac_t          LIKE type_file.num5,                   # 未取消的ARRAY CNT # SMALLINT 
         l_n             LIKE type_file.num5,                   # 檢查重複用        # SMALLINT
         l_modify_flag   LIKE type_file.chr1,                   # 單身更改否        # CHAR(1)
         l_lock_sw       LIKE type_file.chr1,                   # 單身鎖住否        # CHAR(1)
         l_exit_sw       LIKE type_file.chr1,                   # CHAR(1) # Esc結束INPUT ARRAY 否
         p_cmd           LIKE type_file.chr1,                   # 處理狀態          # CHAR(1)
         l_allow_insert  LIKE type_file.num5,                   # 可否新增          # SMALLINT
         l_allow_delete  LIKE type_file.num5,                   # 可否刪除          # SMALLINT
         l_jump          LIKE type_file.num5                    # SMALLINT # 判斷是否跳過AFTER ROW的處理
DEFINE   l_azw05         LIKE azw_file.azw05                    #檢查資料是否存在

   CALL cl_opmsg('b')

   IF s_shut(0) THEN 
      RETURN 
   END IF
   LET g_action_choice = ""

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_azwd WITHOUT DEFAULTS FROM s_azwd.*
      ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET l_cnt = 0
         LET f_azwd01 = ""
    
         FOR l_ac_n = 1 TO g_azwd.getlength()
             IF NOT cl_chk_schema_has_built(g_azwd[l_ac_n].azwd01) THEN
                 LET f_azwd01 = f_azwd01, g_azwd[l_ac_n].azwd01, ", "
                 LET l_cnt = l_cnt + 1
                 LET r_azwd01[l_cnt].azwd01 = g_azwd[l_ac_n].azwd01
             END IF
         END FOR
    
         IF NOT cl_null(f_azwd01) THEN
             LET f_azwd01 = f_azwd01.substring(1, f_azwd01.getlength() - 2)
             IF (cl_confirm2("azz1038", f_azwd01)) THEN
                 BEGIN WORK
                   FOR l_ac_n = 1 TO l_cnt
                       DELETE FROM azwd_file WHERE azwd01 = r_azwd01[l_ac_n].azwd01
                       IF SQLCA.sqlcode THEN
                           CALL cl_err3("del","azwd_file",g_azwd_t.azwd01,"",SQLCA.sqlcode,"","",0)  
                           ROLLBACK WORK 
                       END IF
                   END FOR
                 COMMIT WORK
                 CLEAR FORM
                 CALL g_azwd.clear()
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     RETURN
                 END IF
                 LET g_wc2 = '1=1'
                 CALL p_ods_db_b_fill(g_wc2)
             END IF
         END IF
  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_azwd_t.* = g_azwd[l_ac].*  #BACKUP

            OPEN p_ods_db_bcl USING g_azwd_t.azwd01
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN p_ods_db_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_ods_db_bcl INTO g_azwd[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_ods_db_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_azwd[l_ac].* TO NULL      
          LET g_azwd_t.* = g_azwd[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()

       AFTER INSERT    
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE p_ods_db_bcl
             CANCEL INSERT
          ELSE
             BEGIN WORK
             INSERT INTO azwd_file(azwd01, azwduser, azwdgrup, azwddate, azwdoriu, azwdorig)
                    VALUES(g_azwd[l_ac].azwd01, g_user, g_grup, g_today, g_user, g_grup)      #No.FUN-A40066
                                      
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","azwd_file",g_azwd[l_ac].azwd01,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL INSERT
             ELSE
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
             END IF
          END IF

        AFTER FIELD azwd01                        #check azwd01資料是否重複
            IF NOT cl_null(g_azwd[l_ac].azwd01) THEN
               IF g_azwd[l_ac].azwd01 != g_azwd_t.azwd01 OR
                  (g_azwd[l_ac].azwd01 IS NOT NULL AND g_azwd_t.azwd01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM azwd_file
                    WHERE azwd01 = g_azwd[l_ac].azwd01
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_azwd[l_ac].azwd01 = g_azwd_t.azwd01
                      NEXT FIELD azwd01
                   END IF
                   
                   #check azwd05 data 是否存在
                   SELECT azw05 INTO l_azw05 FROM azw_file
                     WHERE azw05 = g_azwd[l_ac].azwd01
                   IF cl_null(l_azw05) THEN
                       CALL cl_err('','mfg9180',0)
                       LET g_azwd[l_ac].azwd01 = g_azwd_t.azwd01
                       NEXT FIELD azwd01
                   END IF
                   
                   #check DB是否已經建立
                   IF NOT cl_chk_schema_has_built(g_azwd[l_ac].azwd01) THEN
                       CALL cl_err_msg('','azz1025',g_azwd[l_ac].azwd01, 10)
                       LET g_azwd[l_ac].azwd01 = g_azwd_t.azwd01
                       NEXT FIELD azwd01
                   END IF
                   
                   #check ds是否被選擇(ds不需納入ods)               #FUN-A50015
                   #IF g_azwd[l_ac].azwd01 = 'ds' THEN              #FUN-A50015
                   #    CALL cl_err_msg('','azz1037','',10)         #FUN-A50015
                   #    LET g_azwd) _ac].azwd01 = g_azwd_t.azwd01   #FUN-A50015
                   #    NEXT FIELD azwd01                           #FUN-A50015 
                   #END IF                                          #FUN-A50015
               END IF
               IF NOT cl_null(g_errno)  THEN
                   CALL cl_err('',g_errno,0) 
                   NEXT FIELD azwd01
               END IF
            END IF

       BEFORE DELETE                            #是否取消單身
          IF g_azwd_t.azwd01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM azwd_file WHERE azwd01 = g_azwd_t.azwd01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","azwd_file",g_azwd_t.azwd01,"",SQLCA.sqlcode,"","",0)  
                ROLLBACK WORK 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             CLOSE p_ods_db_bcl
             COMMIT WORK 
             
          END IF

      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_azwd[l_ac].* = g_azwd_t.*
             #FUN-D30034---add---str---
             ELSE
                CALL g_azwd.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034---add---end---
             END IF
             CLOSE p_ods_db_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE p_ods_db_bcl
          COMMIT WORK
         
      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   

      ON ACTION help         
         CALL cl_show_help()
         
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azwd01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw10"
               LET g_qryparam.default1 = g_azwd[l_ac].azwd01
               CALL cl_create_qry() RETURNING g_azwd[l_ac].azwd01
               DISPLAY g_azwd[l_ac].azwd01 TO azwd01

            OTHERWISE 
               EXIT CASE
         END CASE
 
   END INPUT

   CLOSE p_ods_db_bcl
   COMMIT WORK 
END FUNCTION

FUNCTION p_ods_db_b_askkey()  

    DEFINE r_azwd01                DYNAMIC ARRAY OF RECORD 
         azwd01         LIKE azwd_file.azwd01
                                  END RECORD 
    DEFINE l_ac_n       LIKE type_file.num5    # 目前處理的ARRAY CNT  SMALLINT
    DEFINE l_cnt        LIKE type_file.num5    # 記錄目前被刪除的Count  SMALLINT
    DEFINE f_azwd01     STRING                 # 記錄DB已被刪除的名稱
    
    LET l_cnt = 0
    LET f_azwd01 = ""
 
    FOR l_ac_n = 1 TO g_azwd.getlength()
        IF NOT cl_chk_schema_has_built(g_azwd[l_ac_n].azwd01) THEN
            LET f_azwd01 = f_azwd01, g_azwd[l_ac_n].azwd01, ", "
            LET l_cnt = l_cnt + 1
            LET r_azwd01[l_cnt].azwd01 = g_azwd[l_ac_n].azwd01
        END IF
    END FOR
    
    IF NOT cl_null(f_azwd01) THEN
        LET f_azwd01 = f_azwd01.substring(1, f_azwd01.getlength() - 2)
        IF (cl_confirm2("azz1038", f_azwd01)) THEN
            BEGIN WORK
                FOR l_ac_n = 1 TO l_cnt
                    DELETE FROM azwd_file WHERE azwd01 = r_azwd01[l_ac_n].azwd01
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","azwd_file",g_azwd_t.azwd01,"",SQLCA.sqlcode,"","",0)  
                        ROLLBACK WORK 
                    END IF
                END FOR
            COMMIT WORK
        END IF
    END IF
      
    CLEAR FORM
    CALL g_azwd.clear()
    CONSTRUCT g_wc2 ON azwd01
         FROM s_azwd[1].azwd01
    
    ON ACTION CONTROLP
         CASE WHEN INFIELD(azwd01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_azw10"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_azwd[l_ac].azwd01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_azwd[1].azwd01
              OTHERWISE
                   EXIT CASE
          END CASE
    END CONSTRUCT      

    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('geauser', 'geagrup')

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL p_ods_db_b_fill(g_wc2)
END FUNCTION



FUNCTION p_ods_db_b_fill(p_wc2)              #BODY FILL UP

    DEFINE p_wc2       STRING
    
    LET g_sql = " SELECT azwd01 FROM azwd_file ",
                 " WHERE ", p_wc2 CLIPPED,                     #單身
                 " ORDER BY azwd01"

    PREPARE p_ods_db_pb FROM g_sql
    DECLARE azwd_curs CURSOR FOR p_ods_db_pb

    CALL g_azwd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 

    FOREACH azwd_curs INTO g_azwd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.SQLCODE THEN
           CALL cl_err('foreach:',SQLCA.SQLCODE,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1

        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    
    #----------FUN-A40066 modify start----------------------
    IF g_cnt = 1 THEN
    	 CASE cl_db_get_database_type()
          WHEN 'ORA'
             LET g_sql = "SELECT distinct azw05 FROM azw_file",               #取得所有實體Schema
                   " INNER JOIN all_users ON username=UPPER(azw05)",    #判斷實體Schema是否建立
                   " WHERE azwacti='Y' AND azw05<>'ds' AND EXISTS ",
                   " (SELECT zta02 FROM zta_file WHERE zta02=azw05)",   #判斷是否為ERP資料庫
                   " ORDER BY 1"
	     #FUN-A60017 start		   
             WHEN 'MSV'         
             LET g_sql = "SELECT distinct azw05 FROM azw_file",               #取得所有實體Schema
                   " INNER JOIN sys.databases ON substring(name,3,13)=azw05",    #判斷實體Schema是否建立
                   " WHERE azwacti='Y' AND azw05<>'ds' AND EXISTS ",
                   " (SELECT zta02 FROM zta_file WHERE zta02=azw05)",   #判斷是否為ERP資料庫
                   " ORDER BY 1"
	      #FUN-A60017 end
       END CASE
             
       PREPARE p_db FROM g_sql
       DECLARE azw_curs CURSOR FOR p_db

       CALL g_azwd.clear()
       LET g_cnt = 1
       MESSAGE "Searching!" 

       BEGIN WORK
         FOREACH azw_curs INTO g_azwd[g_cnt].*   #單身 ARRAY 填充
             IF SQLCA.SQLCODE THEN
                CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                EXIT FOREACH
             END IF
             INSERT INTO azwd_file(azwd01, azwduser, azwdgrup, azwddate, azwdoriu, azwdorig)
                      VALUES(g_azwd[g_cnt].azwd01, g_user, g_grup, g_today, g_user, g_grup)
             IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","azwd_file",g_azwd[l_ac].azwd01,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  EXIT FOREACH
             END IF
             LET g_cnt = g_cnt + 1

             IF g_cnt > g_max_rec THEN
                CALL cl_err('',9035,0)
                EXIT FOREACH
             END IF
         END FOREACH   
       COMMIT WORK
    END IF
    #----------FUN-A40066 modify end------------------------
    
    CALL g_azwd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt=0
END FUNCTION


FUNCTION p_ods_db_bp(p_ud)

   DEFINE p_ud            LIKE type_file.chr1          # CHAR(1)

   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_azwd TO s_azwd.* ATTRIBUTE(COUNT=g_rec_b)

        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()                 

        ON ACTION query                  # Q.查詢
           LET g_action_choice="query"
           EXIT DISPLAY

         ON ACTION detail                 # B.單身
            LET g_action_choice="detail"
            EXIT DISPLAY

        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY

        ON ACTION cancel
           LET INT_FLAG=FALSE 
           LET g_action_choice="exit"
           EXIT DISPLAY

        ON ACTION exit                   # Esc.結束
           LET g_action_choice="exit"
           EXIT DISPLAY

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about      
           CALL cl_about()  

        ON ACTION controlg 
           CALL cl_cmdask() 
 
        ON ACTION help                   # H.說明
           CALL cl_show_help()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()  

        ON ACTION exporttoexcel 
           LET g_action_choice = "exporttoexcel"
           EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#----------FUN-A60045 modify start------------------------
FUNCTION p_ods_db_chk_azwd_change()
   DEFINE l_cnt          LIKE type_file.num5,
          l_cnt_bk       LIKE type_file.num5,
          l_i            LIKE type_file.num5,
          l_j            LIKE type_file.num5,
          l_exist        BOOLEAN   

   LET l_cnt = g_azwd.getlength()
   LET l_cnt_bk = g_azwd_bk.getlength()
   IF l_cnt != l_cnt_bk THEN
      RETURN TRUE
   END IF
   #檢查資料內容是否一致
   FOR l_i=1 TO l_cnt
      LET l_exist = FALSE
      FOR l_j=1 TO l_cnt_bk
         IF g_azwd[l_i].azwd01 = g_azwd_bk[l_j].azwd01 THEN
            LET l_exist = TRUE
            EXIT FOR
         END IF
      END FOR
      IF l_exist = FALSE THEN
         RETURN TRUE
      END IF
   END FOR
   
   RETURN FALSE
END FUNCTION

FUNCTION p_ods_db_azwd_bk_fill()      
   DEFINE l_cnt          LIKE type_file.num5,
          l_i            LIKE type_file.num5

   LET l_cnt = g_azwd.getlength()

   FOR l_i=1 TO l_cnt
      LET g_azwd_bk[l_i].* = g_azwd[l_i].* 
   END FOR 
END FUNCTION
#----------FUN-A60045 modify end------------------------
