# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi203.4gl
# Descriptions...: 機器資料維護作業
# Date & Author..: 02/03/13 By Mandy
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-660193 06/06/30 By Joe del is_batch add eq_type
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-6A0163 06/11/07 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-720043 07/03/19 By Mandy APS 相關調整
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_eci   RECORD LIKE aps_eci.*,
    g_aps_eci_t RECORD LIKE aps_eci.*,
    g_aps_eci_o RECORD LIKE aps_eci.*,
    g_eq_id_t       LIKE aps_eci.eq_id,
    g_aps_eci_rowid     LIKE type_file.chr18,   #No.FUN-690010 INT
    g_wc,g_sql          string,  #No:FUN-580092 HCN
    l_cmd               LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100)
    g_argv1		LIKE aps_eci.eq_id

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
MAIN
    DEFINE l_time          LIKE type_file.chr8    #No.FUN-690010 VARCHAR(8)
    DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690010 SMALLINT

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
    INITIALIZE g_aps_eci.* TO NULL
    INITIALIZE g_aps_eci_t.* TO NULL
    INITIALIZE g_aps_eci_o.* TO NULL

    LET g_forupd_sql = "SELECT * FROM aps_eci WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE i203_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i203_w AT p_row,p_col
      WITH FORM "aps/42f/apsi203"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    LET g_argv1 =  ARG_VAL(1)               # 設備編號
    IF NOT cl_null(g_argv1)
       THEN CALL i203_q()
	    CALL i203_u()
    END IF

    WHILE TRUE
      LET g_action_choice=""
    CALL i203_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW i203_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818
END MAIN

FUNCTION i203_cs()
    CLEAR FORM
    IF NOT cl_null(g_argv1)  THEN
        LET g_wc = "eq_id = '",g_argv1,"'"
    ELSE
   INITIALIZE g_aps_eci.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
      ## eq_id,wcaln_id,dcaln_id,is_batch  ##NO:FUN-660193
         eq_id,wcaln_id,dcaln_id,eq_type   ##NO:FUN-660193
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
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
      LET g_wc = g_wc clipped," AND eciuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND ecigrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND ecigrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql="SELECT aps_eci.ROWID,eq_id ",# 組合出 SQL 指令
             "  FROM aps_eci,eci_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND eci01 = eq_id ",
             " ORDER BY eq_id "

   PREPARE i203_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i203_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i203_prepare
   IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM aps_eci ",
                 " WHERE eq_id ='",g_argv1,"'"
   ELSE
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM aps_eci,eci_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND eci01 = eq_id "
   END IF
   PREPARE i203_precount FROM g_sql
   DECLARE i203_count CURSOR FOR i203_precount
END FUNCTION

FUNCTION i203_menu()
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i203_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i203_fetch('N')
        ON ACTION previous
            CALL i203_fetch('P')
        ON ACTION modify
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i203_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i203_r()
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
            CALL i203_fetch('/')
        ON ACTION first
            CALL i203_fetch('F')
        ON ACTION last
            CALL i203_fetch('L')
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
               IF g_aps_eci.eq_id IS NOT NULL THEN
                  LET g_doc.column1 = "eq_id"
                  LET g_doc.value1 = g_aps_eci.eq_id
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
    CLOSE i203_cs
END FUNCTION

FUNCTION i203_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_aps_eci.eq_id) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_eq_id_t = g_aps_eci.eq_id
    LET g_aps_eci_o.*= g_aps_eci.*
    BEGIN WORK

    OPEN i203_cl USING g_aps_eci_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i203_cl:", STATUS, 1)
       CLOSE i203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i203_cl INTO g_aps_eci.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_eci.eq_id,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i203_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i203_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aps_eci.*=g_aps_eci_t.*
            CALL i203_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_eci SET aps_eci.* = g_aps_eci.*    # 更新DB
            WHERE ROWID = g_aps_eci_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_aps_eci.eq_id,SQLCA.sqlcode,0) #No.FUN-660095
          CALL cl_err3("upd","aps_eci",g_eq_id_t,"",SQLCA.sqlcode,"","",1) # Fun-660095
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i203_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i203_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT

    DISPLAY BY NAME
         g_aps_eci.eq_id,g_aps_eci.wcaln_id,g_aps_eci.dcaln_id,
      ## g_aps_eci.is_batch   ##NO:FUN-660193 
         g_aps_eci.eq_type

    INPUT BY NAME
         g_aps_eci.eq_id,g_aps_eci.wcaln_id,g_aps_eci.dcaln_id,
      ## g_aps_eci.is_batch   ##NO:FUN-660193
         g_aps_eci.eq_type
        WITHOUT DEFAULTS
 
 ##NO:FUN-660193----------------------------------------------------
 ##   AFTER FIELD is_batch
 ##     IF NOT cl_null(g_aps_eci.is_batch) THEN
 ##       IF g_aps_eci.is_batch NOT MATCHES "[012]" THEN
 ##           NEXT FIELD is_batch
 ##       END IF
 ##     END IF
    AFTER FIELD eq_type
      IF NOT cl_null(g_aps_eci.eq_type) THEN
        IF g_aps_eci.eq_type NOT MATCHES "[01]" THEN
            NEXT FIELD eq_type
        END IF
      END IF
 ##NO:FUN-660193----------------------------------------------------
#FUN-720043------mark-----------str--------
#   AFTER FIELD wcaln_id
#       IF NOT cl_null(g_aps_eci.wcaln_id) THEN
#          SELECT * FROM aps_sag WHERE wcaln_id = g_aps_eci.wcaln_id
#          IF STATUS = 100 THEN
##             CALL cl_err('','aps-003',0) #No.FUN-660095
#              CALL cl_err3("sel","aps_sag",g_aps_eci.wcaln_id,"","aps-003","","",1) # Fun-660095
#             NEXT FIELD wcaln_id
#          END IF
#       END IF

#   AFTER FIELD dcaln_id
#       IF NOT cl_null(g_aps_eci.dcaln_id) THEN
#          SELECT * FROM aps_sad WHERE dcaln_id = g_aps_eci.dcaln_id
#          IF STATUS = 100 THEN
# #            CALL cl_err('','aps-004',0) #No.FUN-660095
#             CALL cl_err3("sel","aps_sad",g_aps_eci.dcaln_id,"","aps-004","","",1) # Fun-660095
#             NEXT FIELD dcaln_id
#          END IF
#       END IF
#FUN-720043------mark-----------end--------

       #MOD-650015 --start
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(eq_id) THEN
        #        LET g_aps_eci.* = g_aps_eci_t.*
        #        DISPLAY BY NAME g_aps_eci.*
        #        NEXT FIELD eq_id
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

FUNCTION i203_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aps_eci.* TO NULL          #No.FUN-6A0163 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i203_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i203_count
    FETCH i203_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i203_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_eci.eq_id,SQLCA.sqlcode,0)
        INITIALIZE g_aps_eci.* TO NULL
    ELSE
        CALL i203_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i203_fetch(p_flaps_eci)
    DEFINE
        p_flaps_eci     LIKE type_file.chr1,   #No.FUN-690010     VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER

    CASE p_flaps_eci
        WHEN 'N' FETCH NEXT     i203_cs INTO g_aps_eci_rowid,g_aps_eci.eq_id
        WHEN 'P' FETCH PREVIOUS i203_cs INTO g_aps_eci_rowid,g_aps_eci.eq_id
        WHEN 'F' FETCH FIRST    i203_cs INTO g_aps_eci_rowid,g_aps_eci.eq_id
        WHEN 'L' FETCH LAST     i203_cs INTO g_aps_eci_rowid,g_aps_eci.eq_id
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
            FETCH ABSOLUTE l_abso i203_cs INTO g_aps_eci_rowid,g_aps_eci.eq_id
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_eci.eq_id,SQLCA.sqlcode,0)
        INITIALIZE g_aps_eci.* TO NULL  #TQC-6B0105
        LET g_aps_eci_rowid = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flaps_eci
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_aps_eci.* FROM aps_eci            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_aps_eci_rowid
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_aps_eci.eq_id,SQLCA.sqlcode,0) #No.FUN-660095
         CALL cl_err3("sel","aps_eci",g_aps_eci.eq_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
    ELSE


        CALL i203_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i203_show()
    LET g_aps_eci_t.* = g_aps_eci.*
    DISPLAY BY NAME g_aps_eci.*
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i203_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_aps_eci.eq_id IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i203_cl USING g_aps_eci_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i203_cl:", STATUS, 1)
       CLOSE i203_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i203_cl INTO g_aps_eci.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps_eci.eq_id,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i203_show()
    IF cl_delete() THEN
        DELETE FROM aps_eci WHERE ROWID = g_aps_eci_rowid
        CLEAR FORM
    END IF
    CLOSE i203_cl
    COMMIT WORK
END FUNCTION

#Patch....NO:TQC-610036 <001> #
