# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi109.4gl
# Descriptions...: 存貨預配記錄資料
# Date & Author..: 03/03/26 By saki
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-6A0163 06/11/06 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"`
# Modify.........: No:FUN-720043 07/03/02 By Mandy APS整合調整
# Modify.........: No.TQC-6B0105 07/03/09 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-6B0105 07/05/04 By Mandy stk_loc 儲位也是Key值,修改時應不能調整
# Modify.........: No.TQC-750013 07/05/04 By Mandy add AFTER FIELD stk_loc判斷
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-720043
DEFINE
    g_aps_saj    RECORD LIKE aps_saj.*,
    g_aps_saj_t  RECORD LIKE aps_saj.*,
    g_aps_saj_o  RECORD LIKE aps_saj.*,
    g_pid_t             LIKE aps_saj.pid,
    g_wh_id_t           LIKE aps_saj.wh_id,
    g_stk_loc_t         LIKE aps_saj.stk_loc,   #TQC-750013 add
    g_aps_saj_rowid     LIKE type_file.chr18,   #No.FUN-690010  INT
    g_wc,g_sql          string,  #No:FUN-580092 HCN
    l_cmd               LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100)
    g_argv1             LIKE aps_saj.pid,
    g_argv2             LIKE aps_saj.wh_id

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-690010 INTEGER
MAIN
    DEFINE l_time        LIKE type_file.chr8    #No.FUN-690010 VARCHAR(8)
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT

    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST,
        PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


      CALL cl_used(g_prog,l_time,1) RETURNING l_time #No:MOD-580088  HCN 20050818
    INITIALIZE g_aps_saj.* TO NULL
    INITIALIZE g_aps_saj_t.* TO NULL
    INITIALIZE g_aps_saj_o.* TO NULL

    LET g_forupd_sql = "SELECT * FROM aps_saj WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE i109_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i109_w AT p_row,p_col
      WITH FORM "aps/42f/apsi109"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()


    LET g_argv1 =  ARG_VAL(1)               # 庫存品號
    LET g_argv2 =  ARG_VAL(1)               # 倉庫編號
    IF NOT cl_null(g_argv1) AND cl_null(g_argv2)
       THEN CALL i109_q()
	    CALL i109_u()
    END IF

    WHILE TRUE
      LET g_action_choice=""
    CALL i109_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW i109_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818
END MAIN

FUNCTION i109_cs()
    CLEAR FORM
    IF NOT cl_null(g_argv1) AND cl_null(g_argv2)  THEN
        LET g_wc = "pid = '",g_argv1,
                   "' and wh_id = '",g_argv2, "'"
    ELSE
   INITIALIZE g_aps_saj.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         pid,
         oid,
         wh_id,
         stk_loc,
         location,
         fed_qty,
         dm_qty,
         is_mt,
         is_lock,
         is_do
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN

        ON ACTION controlp
           CASE
             WHEN INFIELD(pid)
#            CALL q_ima(10,3,g_aps_saj.pid) RETURNING g_aps_saj.pid
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_aps_saj.pid
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pid
             NEXT FIELD pid
 
             WHEN INFIELD(wh_id)
#            CALL q_imfd(10,3,g_aps_saj.wh_id,g_aps_saj.pid,'')
#            RETURNING g_aps_saj.wh_id
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_imfd"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_aps_saj.wh_id
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO wh_id
             NEXT FIELD wh_id
 
             OTHERWISE
               EXIT CASE
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
       END CONSTRUCT

    END IF
   IF INT_FLAG THEN RETURN END IF
#-->資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND sajuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND sajgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND sajgrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql="SELECT aps_saj.ROWID,pid,wh_id ",# 組合出 SQL 指令
             "  FROM aps_saj,ima_file,imd_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND ima01 = pid AND imd01 = wh_id ",
             " ORDER BY pid,wh_id "

   PREPARE i109_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i109_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i109_prepare
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2)  THEN
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM aps_saj ",
                 " WHERE pid ='",g_argv1,
                 "' AND wh_id ='",g_argv2, "'"
   ELSE
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM aps_saj,ima_file,imd_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND ima01 = pid AND imd01 = wh_id"
   END IF
   PREPARE i109_precount FROM g_sql
   DECLARE i109_count CURSOR FOR i109_precount
END FUNCTION

FUNCTION i109_menu()
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i109_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i109_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i109_fetch('N')
        ON ACTION previous
            CALL i109_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                CALL i109_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i109_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
{
        ON ACTION jump
            CALL i109_fetch('/')
        ON ACTION first
            CALL i109_fetch('F')
        ON ACTION last
            CALL i109_fetch('L')
}
        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
  
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No:FUN-6A0163-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_aps_saj.pid IS NOT NULL THEN
                  LET g_doc.column1 = "pid"
                  LET g_doc.value1 = g_aps_saj.pid
                  CALL cl_doc()
               END IF
           END IF
        #No:FUN-6A0163-------add--------end----
            LET g_action_choice = "exit"
          CONTINUE MENU

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i109_cs
END FUNCTION

FUNCTION i109_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_aps_saj.* LIKE aps_saj.*
    LET g_pid_t = NULL
    LET g_wh_id_t = NULL

    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aps_saj.fed_qty=0
        LET g_aps_saj.dm_qty=0
        LET g_aps_saj.is_mt=0
        LET g_aps_saj.is_lock=0
        LET g_aps_saj.is_do=0
        CALL i109_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_aps_saj.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF (g_aps_saj.pid AND g_aps_saj.wh_id) IS NULL THEN
           CONTINUE WHILE
        END IF

        INSERT INTO aps_saj VALUES(g_aps_saj.*)
        IF SQLCA.SQLCODE THEN
 #          CALL cl_err(g_aps_saj.pid,SQLCA.SQLCODE,0) #No.FUN-660095
          CALL cl_err3("ins","aps_saj",g_aps_saj.oid,g_aps_saj.pid,SQLCA.sqlcode,"","",1) # Fun-660095  
           CONTINUE WHILE
        ELSE
           SELECT ROWID INTO g_aps_saj_rowid FROM aps_saj
                  WHERE pid = g_aps_saj.pid
                  AND wh_id = g_aps_saj.wh_id
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i109_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_aps_saj.pid) AND cl_null(g_aps_saj.wh_id)
       THEN CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pid_t = g_aps_saj.pid
    LET g_wh_id_t = g_aps_saj.wh_id
    LET g_stk_loc_t = g_aps_saj.stk_loc #TQC-750013 add
    LET g_aps_saj_o.*= g_aps_saj.*
    BEGIN WORK

    OPEN i109_cl USING g_aps_saj_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_aps_saj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_saj.pid,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i109_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i109_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aps_saj.*=g_aps_saj_t.*
            CALL i109_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_saj SET aps_saj.* = g_aps_saj.*    # 更新DB
            WHERE ROWID = g_aps_saj_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_aps_saj.pid,SQLCA.sqlcode,0) #No.FUN-660095
            CALL cl_err3("upd","aps_saj",g_aps_saj.oid,g_aps_saj.pid,SQLCA.sqlcode,"","",1) # Fun-660095
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i109_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-690010 SMALLINT

    DISPLAY BY NAME
         g_aps_saj.pid,
         g_aps_saj.oid,
         g_aps_saj.wh_id,
         g_aps_saj.stk_loc,
         g_aps_saj.location,
         g_aps_saj.fed_qty,
         g_aps_saj.dm_qty,
         g_aps_saj.is_mt,
         g_aps_saj.is_lock,
         g_aps_saj.is_do

    INPUT BY NAME
         g_aps_saj.pid,
         g_aps_saj.oid,
         g_aps_saj.wh_id,
         g_aps_saj.stk_loc,
         g_aps_saj.location,
         g_aps_saj.fed_qty,
         g_aps_saj.dm_qty,
         g_aps_saj.is_mt,
         g_aps_saj.is_lock,
         g_aps_saj.is_do
         WITHOUT DEFAULTS

    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i109_set_entry(p_cmd)
        CALL i109_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
    BEFORE FIELD pid
        IF p_cmd = 'u' AND g_chkey = 'N' THEN
           NEXT FIELD location
        END IF

    AFTER FIELD pid
      IF g_aps_saj.pid IS NOT NULL THEN
        IF p_cmd = "a" OR
           (p_cmd = "u" AND g_aps_saj.pid != g_pid_t) THEN
           SELECT ima01 FROM ima_file
           WHERE ima01 = g_aps_saj.pid AND imaacti = 'Y'
           IF SQLCA.SQLCODE THEN
 #             CALL cl_err(g_aps_saj.pid,SQLCA.SQLCODE,0) #No.FUN-660095
           CALL cl_err3("sel","ima_file",g_aps_saj.pid,"",SQLCA.sqlcode,"","",1) # Fun-660095
              LET g_aps_saj.pid = g_pid_t
              DISPLAY BY NAME g_aps_saj.pid
              NEXT FIELD pid
           END IF
           SELECT COUNT(*) INTO l_n FROM aps_saj
           WHERE pid = g_aps_saj.pid
           IF l_n > 0 THEN
              CALL cl_err(g_aps_saj.pid,-239,0)
              LET g_aps_saj.pid = g_pid_t
              DISPLAY BY NAME g_aps_saj.pid
              NEXT FIELD pid
           END IF
        END IF
      END IF
   #TQC-750013---mod----str--
    AFTER FIELD wh_id
      IF g_aps_saj.wh_id IS NOT NULL THEN
        IF p_cmd = "a" OR
           (p_cmd = "u" AND g_aps_saj.wh_id != g_wh_id_t) THEN
           SELECT imd01 FROM imd_file
           WHERE imd01 = g_aps_saj.wh_id
              AND imdacti = 'Y' #MOD-4B0169
           IF SQLCA.SQLCODE THEN
  #            CALL cl_err(g_aps_saj.wh_id,SQLCA.SQLCODE,0) #No.FUN-660095
              CALL cl_err3("sel","imd_file",g_aps_saj.wh_id,"",SQLCA.sqlcode,"","",1) # Fun-660095
              LET g_aps_saj.wh_id = g_wh_id_t
              DISPLAY BY NAME g_aps_saj.wh_id
              NEXT FIELD wh_id
           END IF
          #TQC-750013---mark
          #SELECT COUNT(*) INTO l_n FROM aps_saj
          #WHERE pid = g_aps_saj.pid AND oid = g_aps_saj.oid
          #AND wh_id = g_aps_saj.wh_id
          #IF l_n > 0 THEN
          #   CALL cl_err(g_aps_saj.wh_id,-239,0)
          #   LET g_aps_saj.wh_id = g_wh_id_t
          #   DISPLAY BY NAME g_aps_saj.wh_id
          #   NEXT FIELD wh_id
          #END IF
        END IF
      END IF

   #TQC-750013------add----str---
    AFTER FIELD stk_loc
        IF p_cmd = "a" OR
           (p_cmd = "u" AND g_aps_saj.stk_loc != g_stk_loc_t) THEN
           SELECT COUNT(*) INTO l_n 
             FROM aps_saj
            WHERE pid     = g_aps_saj.pid 
              AND oid     = g_aps_saj.oid
              AND wh_id   = g_aps_saj.wh_id
              AND stk_loc = g_aps_saj.stk_loc
           IF l_n > 0 THEN
              CALL cl_err(g_aps_saj.wh_id,-239,0)
              LET g_aps_saj.stk_loc = g_stk_loc_t
              DISPLAY BY NAME g_aps_saj.stk_loc
              NEXT FIELD stk_loc
           END IF
        END IF
   #TQC-750013------add----end---

        ON ACTION controlp
           CASE
             WHEN INFIELD(pid)
#            CALL q_ima(10,3,g_aps_saj.pid) RETURNING g_aps_saj.pid
#            CALL FGL_DIALOG_SETBUFFER( g_aps_saj.pid )
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.default1 = g_aps_saj.pid
             CALL cl_create_qry() RETURNING g_aps_saj.pid
#             CALL FGL_DIALOG_SETBUFFER( g_aps_saj.pid )
             DISPLAY BY NAME g_aps_saj.pid
             NEXT FIELD pid
 
             WHEN INFIELD(wh_id)
#            CALL q_imfd(10,3,g_aps_saj.wh_id,g_aps_saj.pid,'')
#            RETURNING g_aps_saj.wh_id
#            CALL FGL_DIALOG_SETBUFFER( g_aps_saj.wh_id )
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_imfd"
             LET g_qryparam.default1 = g_aps_saj.wh_id
             CALL cl_create_qry() RETURNING g_aps_saj.wh_id
#             CALL FGL_DIALOG_SETBUFFER( g_aps_saj.wh_id )
             DISPLAY BY NAME g_aps_saj.wh_id
             NEXT FIELD wh_id
 
             OTHERWISE
               EXIT CASE
           END CASE

       #MOD-650015 --start
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(pid) THEN
        #        LET g_aps_saj.* = g_aps_saj_t.*
        #        DISPLAY BY NAME g_aps_saj.*
        #        NEXT FIELD pid
        #    END IF
       #MOD-650015 --end

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION

FUNCTION i109_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aps_saj.* TO NULL          #No.FUN-6A0163
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i109_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i109_count
    FETCH i109_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i109_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_saj.pid,SQLCA.sqlcode,0)
        INITIALIZE g_aps_saj.* TO NULL
    ELSE
        CALL i109_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i109_fetch(p_flaps_saj)
    DEFINE
        p_flaps_saj    LIKE type_file.chr1,     #No.FUN-690010  VARCHAR(1),
        l_abso         LIKE type_file.num10     #No.FUN-690010 INTEGER

    CASE p_flaps_saj
        WHEN 'N' FETCH NEXT     i109_cs INTO g_aps_saj_rowid,g_aps_saj.pid
        WHEN 'P' FETCH PREVIOUS i109_cs INTO g_aps_saj_rowid,g_aps_saj.pid
        WHEN 'F' FETCH FIRST    i109_cs INTO g_aps_saj_rowid,g_aps_saj.pid
        WHEN 'L' FETCH LAST     i109_cs INTO g_aps_saj_rowid,g_aps_saj.pid
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso i109_cs INTO g_aps_saj_rowid,g_aps_saj.pid
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_saj.pid,SQLCA.sqlcode,0)
        INITIALIZE g_aps_saj.* TO NULL   #No.TQC-6B0105
        LET g_aps_saj_rowid = NULL       #No.TQC-6B0105
        RETURN
    ELSE
       CASE p_flaps_saj
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_aps_saj.* FROM aps_saj            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_aps_saj_rowid
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_aps_saj.pid,SQLCA.sqlcode,0) #No.FUN-660095
     CALL cl_err3("sel","aps_saj",g_aps_saj.oid,g_aps_saj.pid,SQLCA.sqlcode,"","",1) # Fun-660095
    ELSE

        CALL i109_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i109_show()
    LET g_aps_saj_t.* = g_aps_saj.*
    DISPLAY BY NAME g_aps_saj.*
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i109_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_aps_saj.pid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i109_cl USING g_aps_saj_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_aps_saj.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_saj.pid,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i109_show()
    IF cl_delete() THEN
        DELETE FROM aps_saj WHERE ROWID = g_aps_saj_rowid
        CLEAR FORM
    END IF
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION

FUNCTION i109_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oid,pid,wh_id",TRUE)
   END IF
END FUNCTION

FUNCTION i109_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oid,pid,wh_id,stk_loc",FALSE) #TQC-750013 add stk_loc
   END IF
END FUNCTION


#Patch....NO:TQC-610036 <001> #
