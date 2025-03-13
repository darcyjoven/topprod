# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: aooi601.4gl
# Descriptions...: 資料控管原則維護作業
# Input parameter:
# Date & Author..: 07/12/06 By Carrier FUN-7C0010
# Modify.........: FUN-830090 08/03/21 By Carrier 資料中心修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B60098 13/04/03 By Alberti 新增 geu00 為 KEY 值
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global" #FUN-7C0010
 
#模組變數(Module Variables)
DEFINE
    g_gev01         LIKE gev_file.gev01,   #資料類型
    g_gev01_t       LIKE gev_file.gev01,   #資料類型 (舊值)
    g_gev           DYNAMIC ARRAY OF RECORD 
        gev02       LIKE gev_file.gev02,   #營運中心
        gev03       LIKE gev_file.gev03,   #資料中心否
        gev04       LIKE gev_file.gev04,   #資料中心代碼
        geu02       LIKE geu_file.geu02    #資料中心名稱
                    END RECORD,
    g_gev_t         RECORD                 #程式變數 (舊值)
        gev02       LIKE gev_file.gev02,   #營運中心
        gev03       LIKE gev_file.gev03,   #資料中心否
        gev04       LIKE gev_file.gev04,   #資料中心代碼
        geu02       LIKE geu_file.geu02    #資料中心名稱
                    END RECORD,
    g_gey           DYNAMIC ARRAY OF RECORD 
        gey03       LIKE gey_file.gey03,   #
        gaq03       LIKE gaq_file.gaq03,   #名稱
        gey04       LIKE gey_file.gey04,   #
        gey05       LIKE gey_file.gey05    #
                    END RECORD,
    g_gey_t         RECORD                 #程式變數 (舊值)
        gey03       LIKE gey_file.gey03,   #
        gaq03       LIKE gaq_file.gaq03,   #名稱
        gey04       LIKE gey_file.gey04,   #
        gey05       LIKE gey_file.gey05    #
                    END RECORD,
    g_argv1         LIKE aag_file.aag01,
    g_ss            LIKE type_file.chr1,
    g_wc,g_sql      STRING,
    g_wc2           STRING,
    g_rec_b         LIKE type_file.num5,   #單身筆數
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_rec_b2        LIKE type_file.num5,   #單身筆數
    l_ac2           LIKE type_file.num5    #目前處理的ARRAY CNT
DEFINE g_b_flag     STRING
 
#主程式開始
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_i                  LIKE type_file.num5
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_str                STRING            
 
MAIN
  DEFINE p_row,p_col     LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AOO")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    LET p_row = 4 LET p_col = 30
 
    OPEN WINDOW i601_w AT p_row,p_col
         WITH FORM "aoo/42f/aooi601"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    CALL s_set_combo_all(NULL,"gey03")
    IF NOT cl_null(g_argv1) THEN
       CALL i601_q()
    END IF
 
    CALL i601_menu()
 
    CLOSE WINDOW i601_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i601_curs()
    CLEAR FORM                             #清除畫面
    CALL g_gev.clear()
 
    IF g_argv1 IS NOT NULL THEN
       LET g_gev01 =  g_argv1
       DISPLAY g_gev01 TO gev01
       CALL cl_set_head_visible("","YES")     
       CALL s_set_combo_all(g_gev01,"gey03")
 
       LET g_wc = " gev01 ='",g_argv1,"'"
       LET g_wc2= " 1=1"
       IF INT_FLAG THEN RETURN END IF
    ELSE
       CALL cl_set_head_visible("","YES")      
       CONSTRUCT g_wc ON gev01,gev02,gev03,gev04
            FROM gev01,s_gev[1].gev02,s_gev[1].gev03,s_gev[1].gev04
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  WHEN INFIELD(gev02) #營運中心
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_azp"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gev02
                     NEXT FIELD gev02
                  WHEN INFIELD(gev04) #資料中心代碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_geu"
                     LET g_qryparam.arg1 ="1"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gev04
                     NEXT FIELD gev04
               END CASE
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about    
               CALL cl_about()
 
            ON ACTION help   
               CALL cl_show_help()
 
            ON ACTION controlg   
               CALL cl_cmdask()    
 
            ON ACTION qbe_select
              CALL cl_qbe_select()
 
            ON ACTION qbe_save
	      CALL cl_qbe_save()
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
       CALL s_set_combo_all(NULL,"gey03")       
       CONSTRUCT g_wc2 ON gey03,gey04,gey05
            FROM s_gey[1].gey03,s_gey[1].gey04,s_gey[1].gey05
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  WHEN INFIELD(gey03) #
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gaq"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gey03
                     NEXT FIELD gey03
               END CASE
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about    
               CALL cl_about()
 
            ON ACTION help   
               CALL cl_show_help()
 
            ON ACTION controlg   
               CALL cl_cmdask()    
 
            ON ACTION qbe_select
              CALL cl_qbe_select()
 
            ON ACTION qbe_save
	      CALL cl_qbe_save()
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
 
    IF g_wc2 = " 1=1" THEN
       LET g_sql= "SELECT DISTINCT gev01 FROM gev_file ",
                  " WHERE ", g_wc CLIPPED,
#                 "   AND gev01 <> '0'",
                  " ORDER BY gev01"
    ELSE
       LET g_sql= "SELECT DISTINCT gev01 FROM gev_file,gey_file ",
                  " WHERE gev01 = gey01 AND gev02 = gey02 ",
#                 "   AND gev01 <> '0'",
                  "   AND ", g_wc CLIPPED,
                  "   AND ", g_wc2 CLIPPED,
                  " ORDER BY gev01"
    END IF
    PREPARE i601_prepare FROM g_sql      #預備一下
    DECLARE i601_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i601_prepare
 
    IF g_wc2 = " 1=1" THEN
       LET g_sql= "SELECT COUNT(DISTINCT gev01) FROM gev_file ",
                  " WHERE ", g_wc CLIPPED
#                 "   AND gev01 <> '0'",
    ELSE
       LET g_sql= "SELECT COUNT(DISTINCT gev01) FROM gev_file,gey_file ",
                  " WHERE gev01 = gey01 AND gev02 = gey02 ",
#                 "   AND gev01 <> '0'",
                  "   AND ", g_wc CLIPPED,
                  "   AND ", g_wc2 CLIPPED
    END IF
    PREPARE i601_precount FROM g_sql
    DECLARE i601_count CURSOR FOR i601_precount
END FUNCTION
 
FUNCTION i601_menu()
 
   WHILE TRUE
      CALL i601_bp("G")
      IF g_gev01 IS NULL THEN
         CALL s_set_combo_all(NULL,"gey03")
      ELSE
         CALL s_set_combo_all(g_gev01,"gey03")
      END IF    
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i601_q()
            END IF
       # WHEN "delete"
       #    IF cl_chk_act_auth() THEN
       #       CALL i601_r()
       #    END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i601_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "condition_detail"
            IF cl_chk_act_auth() THEN
               CALL i601_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "qry_condition_detail"
            IF cl_chk_act_auth() THEN
               CALL i601_bp2('G')
            ELSE 
               LET g_action_choice = NULL 
            END IF
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL i601_out()
        #   END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_gev01 IS NOT NULL THEN
                  LET g_doc.column1 = "gev01"
                  LET g_doc.value1 = g_gev01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gev),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i601_gev02(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1
 
    LET g_errno = ' '
    SELECT * FROM azp_file
     WHERE azp01 = g_gev[l_ac].gev02
    CASE
       WHEN STATUS=100      LET g_errno = 'aap-025'
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION
 
FUNCTION i601_gev04(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_geu00   LIKE geu_file.geu00   
    DEFINE l_geu02   LIKE geu_file.geu02   
    DEFINE l_geuacti LIKE geu_file.geuacti
 
    LET g_errno = ' '
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti
     #FROM geu_file WHERE geu01=g_gev[l_ac].gev04                   #CHI-B60098 mark 
      FROM geu_file WHERE geu01=g_gev[l_ac].gev04 AND geu00 = '1'   #CHI-B60098 add
    CASE
        WHEN l_geuacti = 'N' LET g_errno = '9028'
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN 
       LET l_geu02 = NULL
       LET g_gev[l_ac].geu02 = NULL
    END IF
    IF p_cmd = 'd' OR g_errno IS NULL THEN
       LET g_gev[l_ac].geu02 = l_geu02
    END IF
    DISPLAY BY NAME g_gev[l_ac].geu02
END FUNCTION
 
FUNCTION i601_gey03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_gaq03   LIKE gaq_file.gaq03   
 
    LET g_errno = ' '
    SELECT gaq03 INTO l_gaq03
      FROM gaq_file WHERE gaq01=g_gey[l_ac2].gey03
                      AND gaq02=g_lang
    CASE
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN 
       LET l_gaq03 = NULL
       LET g_gey[l_ac2].gaq03 = NULL
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_gey[l_ac2].gaq03 = l_gaq03
    END IF
    DISPLAY BY NAME g_gey[l_ac2].gaq03
END FUNCTION
 
#Query 查詢
FUNCTION i601_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gev01 TO NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_gev.clear()
    CALL i601_curs()                          #取得查詢條件
    IF INT_FLAG THEN                          #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i601_b_curs                          #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                     #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gev01 TO NULL
    ELSE
       CALL i601_fetch('F')
       OPEN i601_count
       FETCH i601_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i601_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i601_b_curs INTO g_gev01
        WHEN 'P' FETCH PREVIOUS i601_b_curs INTO g_gev01
        WHEN 'F' FETCH FIRST    i601_b_curs INTO g_gev01
        WHEN 'L' FETCH LAST     i601_b_curs INTO g_gev01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about        
                      CALL cl_about()     
 
                   ON ACTION help         
                      CALL cl_show_help() 
 
                   ON ACTION controlg     
                      CALL cl_cmdask()    
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i601_b_curs INTO g_gev01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN        
        CALL cl_err(g_gev01,SQLCA.sqlcode,0)
        INITIALIZE g_gev01 TO NULL
    ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i601_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i601_show()
    DISPLAY g_gev01 TO gev01   
    CALL i601_b_fill(g_wc)  
    CALL i601_b_fill2(g_wc2)   
    CALL cl_show_fld_cont()    
END FUNCTION
 
##取消整筆 (所有合乎單頭的資料)
#FUNCTION i601_r()
#    IF s_shut(0) THEN RETURN END IF
#    IF g_gev01 IS NULL THEN
#       CALL cl_err("",-400,0)
#       RETURN
#    END IF
#    BEGIN WORK
#    IF cl_delh(0,0) THEN                   #確認一下
#        DELETE FROM gev_file WHERE gev01 = g_gev01
#        IF SQLCA.sqlcode THEN
#            CALL cl_err3("del","gev_file",g_gev01,"",SQLCA.sqlcode,"","del gev",1)
#            ROLLBACK WORK
#            RETURN
#        ELSE
#            LET g_cnt=SQLCA.SQLERRD[3]
#            DELETE FROM gey_file WHERE gey01 = g_gev01
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("del","gey_file",g_gev01,"",SQLCA.sqlcode,"","del gey",1)
#               ROLLBACK WORK
#               RETURN
#            END IF
#            CLEAR FORM
#            CALL g_gev.clear()
#            CALL g_gey.clear()
#            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
#            OPEN i601_count
#            FETCH i601_count INTO g_row_count
#            DISPLAY g_row_count TO FORMONLY.cnt
#            OPEN i601_b_curs
#            IF g_curs_index = g_row_count + 1 THEN
#               LET g_jump = g_row_count
#               CALL i601_fetch('L')
#            ELSE
#               LET g_jump = g_curs_index
#               LET mi_no_ask = TRUE
#               CALL i601_fetch('/')
#            END IF
#        END IF
#    END IF
#    COMMIT WORK
#END FUNCTION
 
#單身
FUNCTION i601_b()
DEFINE
    l_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,           #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,           #單身鎖住否       
    p_cmd           LIKE type_file.chr1,           #處理狀態         
    l_allow_insert  LIKE type_file.num5,           #可新增否         
    l_allow_delete  LIKE type_file.num5            #可刪除否         
 
    LET g_action_choice = ""
    IF g_gev01 IS NULL THEN
       RETURN
    END IF
    IF g_gev01 = '0' THEN
       CALL cl_err('','aoo-048',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gev02,gev03,gev04,'' FROM gev_file ",
                       " WHERE gev01= ? AND gev02 = ? FOR UPDATE  "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    CALL ui.Interface.refresh()
    INPUT ARRAY g_gev WITHOUT DEFAULTS FROM s_gev.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'   
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_gev_t.* = g_gev[l_ac].*  #BACKUP
               OPEN i601_bcl USING g_gev01,g_gev_t.gev02
               IF STATUS THEN
                  CALL cl_err("OPEN i601_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i601_bcl INTO g_gev[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gev_t.gev04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i601_gev04('d')
                  CALL i601_b_fill2(" 1=1")
                  CALL i601_bp2_refresh()  #No.FUN-830090
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gev[l_ac].* TO NULL      #900423
            LET g_gev[l_ac].gev03 = 'N'
            LET g_gev[l_ac].gev04 = ''
            LET g_gev_t.* = g_gev[l_ac].*         #新輸入資料
            CALL i601_b_fill2(" 1=1")
            CALL i601_bp2_refresh()  #No.FUN-830090
            CALL cl_show_fld_cont()
            NEXT FIELD gev02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO gev_file(gev01,gev02,gev03,gev04)
                   VALUES(g_gev01,g_gev[l_ac].gev02,g_gev[l_ac].gev03,
                          g_gev[l_ac].gev04)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gev_file",g_gev01,g_gev[l_ac].gev02,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD gev02
             IF g_gev[l_ac].gev03 = 'Y' THEN  #資料中心DB,不可更改
                IF g_gev[l_ac].gev02 <> g_gev_t.gev02 THEN
                   LET g_gev[l_ac].gev02 = g_gev_t.gev02
                   DISPLAY BY NAME g_gev[l_ac].gev02
                END IF
             END IF
             IF NOT cl_null(g_gev[l_ac].gev02) THEN
                IF g_gev[l_ac].gev02 != g_gev_t.gev02 OR
                   g_gev_t.gev02 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM gev_file
                    WHERE gev01 = g_gev01
                      AND gev02 = g_gev[l_ac].gev02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_gev[l_ac].gev02 = g_gev_t.gev02
                       NEXT FIELD gev02
                   END IF
                   CALL i601_gev02(p_cmd)
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_gev[l_ac].gev02,g_errno,0)
                     LET g_gev[l_ac].gev02 = g_gev_t.gev02
                     DISPLAY BY NAME g_gev[l_ac].gev02
                     NEXT FIELD gev02
                   END IF
                END IF
             END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gev_t.gev02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM gev_file
                WHERE gev01 = g_gev01 
                  AND gev02 = g_gev_t.gev02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gev_file",g_gev01,g_gev_t.gev02,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  #No.FUN-830090  --Begin
                  DELETE FROM gey_file
                   WHERE gey01 = g_gev01
                     AND gey02 = g_gev_t.gev02 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gev_file",g_gev01,g_gev_t.gev02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
                  #No.FUN-830090  --End  
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gev[l_ac].* = g_gev_t.*
               CLOSE i601_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gev[l_ac].gev02,-263,1)
               LET g_gev[l_ac].* = g_gev_t.*
            ELSE
               UPDATE gev_file SET gev02 = g_gev[l_ac].gev02,
                                   gev03 = g_gev[l_ac].gev03,
                                   gev04 = g_gev[l_ac].gev04
                WHERE gev01= g_gev01 
                  AND gev02= g_gev_t.gev02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","gev_file",g_gev01,g_gev_t.gev02,SQLCA.sqlcode,"","",1)
                  LET g_gev[l_ac].* = g_gev_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_gev[l_ac].* = g_gev_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_gev.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i601_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i601_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(gev02) #營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azp"
                  LET g_qryparam.default1 = g_gev[l_ac].gev02
                  CALL cl_create_qry() RETURNING g_gev[l_ac].gev02
                  DISPLAY BY NAME g_gev[l_ac].gev02
                  NEXT FIELD gev02
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about     
           CALL cl_about() 
 
        ON ACTION help       
           CALL cl_show_help()
                       
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
    CLOSE i601_bcl
    COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION i601_b2()
DEFINE
    l_ac2_t         LIKE type_file.num5,           #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,           #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,           #單身鎖住否       
    p_cmd           LIKE type_file.chr1,           #處理狀態         
    l_allow_insert  LIKE type_file.num5,           #可新增否         
    l_allow_delete  LIKE type_file.num5            #可刪除否         
 
    LET g_action_choice = ""
    IF g_gev01 IS NULL THEN
       RETURN
    END IF
    IF g_gev01 = '0' THEN 
       CALL cl_err('','aoo-048',0)
       RETURN 
    END IF
    IF l_ac < 1 OR l_ac > g_rec_b THEN
       RETURN
    END IF
    #No.FUN-830090  --Begin
    IF g_gev[l_ac].gev03 = 'Y' THEN
       CALL cl_err(g_gev[l_ac].gev02,'aoo-093',0)
       RETURN
    END IF
    #No.FUN-830090  --End  
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gey03,'',gey04,gey05 FROM gey_file ",
                       " WHERE gey01= ? AND gey02 = ? AND gey03 = ? FOR UPDATE  "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac2_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gey WITHOUT DEFAULTS FROM s_gey.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b2!=0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'   
            LET l_n  = ARR_COUNT()
            IF g_rec_b2 >= l_ac2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_gey_t.* = g_gey[l_ac2].*  #BACKUP
               OPEN i601_bcl2 USING g_gev01,g_gev[l_ac].gev02,g_gey_t.gey03
               IF STATUS THEN
                  CALL cl_err("OPEN i601_bcl2:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i601_bcl2 INTO g_gey[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gey_t.gey05,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i601_gey03('d')
               END IF
               CALL i601_set_no_required(p_cmd)
               CALL i601_set_required(p_cmd)
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gey[l_ac2].* TO NULL      #900423
            LET g_gey[l_ac2].gey04 = '1'
            LET g_gey_t.* = g_gey[l_ac2].*         #新輸入資料
            CALL i601_set_no_required(p_cmd)
            CALL i601_set_required(p_cmd)
            CALL cl_show_fld_cont()
            NEXT FIELD gey03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO gey_file(gey01,gey02,gey03,gey04,gey05)
                   VALUES(g_gev01,g_gev[l_ac].gev02,g_gey[l_ac2].gey03,g_gey[l_ac2].gey04,
                          g_gey[l_ac2].gey05)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gey_file",g_gev01,g_gey[l_ac2].gey03,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn3
            END IF
 
        BEFORE FIELD gey03
            CALL i601_set_no_required(p_cmd)
 
        AFTER FIELD gey03
             IF cl_null(g_gey[l_ac2].gey03) THEN
                LET g_gey[l_ac2].gey04 = NULL
                LET g_gey[l_ac2].gey05 = NULL
             ELSE
                CALL i601_gey03('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_gey[l_ac2].gey03,g_errno,1)
                   LET g_gey[l_ac2].gey03 = g_gey_t.gey03
                   NEXT FIELD gey03
                END IF
                IF g_gey[l_ac2].gey03 != g_gey_t.gey03 OR
                   g_gey_t.gey03 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM gey_file
                    WHERE gey01 = g_gev01
                      AND gey02 = g_gev[l_ac].gev02
                      AND gey03 = g_gey[l_ac2].gey03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_gey[l_ac2].gey03 = g_gey_t.gey03
                       NEXT FIELD gey03
                   END IF
                END IF
             END IF
             CALL i601_set_required(p_cmd)
 
        AFTER FIELD gey05
             IF NOT cl_null(g_gey[l_ac2].gey05) THEN
                CALL s_value_chk(g_gey[l_ac2].gey05)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_gey[l_ac2].gey05,g_errno,1)
                   LET g_gey[l_ac2].gey05 = g_gey_t.gey05
                   NEXT FIELD gey05
                END IF
             END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gey_t.gey03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM gey_file
                WHERE gey01 = g_gev01
                  AND gey02 = g_gev[l_ac].gev02 
                  AND gey03 = g_gey_t.gey03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gey_file",g_gev01,g_gey_t.gey03,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b2 = g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn3
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gey[l_ac2].* = g_gey_t.*
               CLOSE i601_bcl2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gey[l_ac2].gey03,-263,1)
               LET g_gey[l_ac2].* = g_gey_t.*
            ELSE
               UPDATE gey_file SET gey03 = g_gey[l_ac2].gey03,
                                   gey04 = g_gey[l_ac2].gey04,
                                   gey05 = g_gey[l_ac2].gey05
                WHERE gey01 = g_gev01
                  AND gey02 = g_gev[l_ac].gev02 
                  AND gey03 = g_gey_t.gey03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","gey_file",g_gev01,g_gey_t.gey03,SQLCA.sqlcode,"","",1)
                  LET g_gey[l_ac2].* = g_gey_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac2 = ARR_CURR()
            #LET l_ac2_t = l_ac2  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_gey[l_ac2].* = g_gey_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_gey.deleteElement(l_ac2)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "condition_detail"
                     LET l_ac2 = l_ac2_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i601_bcl2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac2_t = l_ac2  #FUN-D40030
            CLOSE i601_bcl2
            COMMIT WORK
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(gey03) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gaq"
                  LET g_qryparam.arg1 = g_gey[l_ac2].gey03
                  CALL cl_create_qry() RETURNING g_gey[l_ac2].gey03
                  DISPLAY BY NAME g_gey[l_ac2].gey03
                  NEXT FIELD gey03
           END CASE
           
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about     
           CALL cl_about() 
 
        ON ACTION help       
           CALL cl_show_help()
                       
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
    
    CLOSE i601_bcl2
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i601_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc     STRING
DEFINE l_i      LIKE type_file.num10
 
    LET g_sql ="SELECT gev02,gev03,gev04,'' FROM gev_file ",
               " WHERE gev01 = '",g_gev01,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY gev02"
    PREPARE i601_p2 FROM g_sql      #預備一下
    DECLARE gev_curs CURSOR FOR i601_p2
 
    CALL g_gev.clear()
 
    LET l_i = 1
    FOREACH gev_curs INTO g_gev[l_i].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT geu02 INTO g_gev[l_i].geu02
          FROM geu_file
        #WHERE geu01=g_gev[l_i].gev04                   #CHI-B60098 mark
         WHERE geu01=g_gev[l_i].gev04 AND GEU00='1'     #CHI-B60098 add
        LET l_i = l_i + 1 
        IF l_i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gev.deleteElement(l_i)
    LET g_rec_b = l_i - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i601_b_fill2(p_wc2)              #BODY FILL UP
DEFINE p_wc2     STRING
DEFINE l_gev02   LIKE gev_file.gev02
 
#   IF g_rec_b > 0 THEN
       IF l_ac > 0 THEN
          LET l_gev02 = g_gev[l_ac].gev02
       ELSE
#         LET l_gev02 = g_gev[1].gev02
#      END IF
#   ELSE
       LET l_gev02 = NULL
    END IF
    LET g_sql ="SELECT gey03,'',gey04,gey05 FROM gey_file ",
               " WHERE gey01 = '",g_gev01,"'",
               "   AND gey02 = '",l_gev02,"'",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY gey03"
    PREPARE i601_pb2 FROM g_sql      #預備一下
    DECLARE gey_curs CURSOR FOR i601_pb2
 
    CALL g_gey.clear()
 
    LET g_cnt = 1
    FOREACH gey_curs INTO g_gey[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT gaq03 INTO g_gey[g_cnt].gaq03
          FROM gaq_file
         WHERE gaq01=g_gey[g_cnt].gey03
           AND gaq02=g_lang
        LET g_cnt = g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gey.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i601_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN  #FUN-D40030
   IF p_ud <> "G" OR g_action_choice = "detail" OR g_action_choice = "condition_detail" THEN  #FUN-D40030
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gev TO s_gev.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL i601_b_fill2(" 1=1")
         CALL i601_bp2_refresh()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
    # ON ACTION delete
    #    LET g_action_choice="delete"
    #    EXIT DISPLAY
         
      ON ACTION first
         CALL i601_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#        EXIT DISPLAY
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i601_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#        EXIT DISPLAY
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i601_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#        EXIT DISPLAY
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i601_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#        EXIT DISPLAY
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i601_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#        EXIT DISPLAY
         ACCEPT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION condition_detail         
         LET g_action_choice="condition_detail"
         LET l_ac2 = 1
         EXIT DISPLAY
 
      ON ACTION qry_condition_detail
         LET g_action_choice="qry_condition_detail"
         EXIT DISPLAY
 
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i601_bp2_refresh()
   DISPLAY ARRAY g_gey TO s_gey.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
END FUNCTION
 
FUNCTION i601_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_gey TO s_gey.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
END FUNCTION
 
 
FUNCTION i601_set_required(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1
  
     IF NOT cl_null(g_gey[l_ac2].gey03) THEN
        CALL cl_set_comp_required("gey04,gey05",TRUE) 
     END IF
     
END FUNCTION
 
FUNCTION i601_set_no_required(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
  
     CALL cl_set_comp_required("gey04,gey05",FALSE) 
     
END FUNCTION
