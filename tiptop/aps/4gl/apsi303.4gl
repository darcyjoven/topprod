# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi303.4gl
# Descriptions...: 機器資料維護作業
# Date & Author..: FUN-850114 08/02/29 BY yiting
# Modify.........: FUN-840209 08/05/16 BY DUKE  add vmd08 & 週行事曆,日行事曆可開窗選擇
#                                               連批條件檢查碼預計0但SHOW5,選5 時儲存0 
# Modify.........: FUN-870027 08/07/03 BY DUKE
# Modify.........: TQC-8A0051 08/10/17 BY DUKE 修正機台效率未及時顯示
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmd           RECORD LIKE vmd_file.*,  #FUN-850114
    g_vmd_t         RECORD LIKE vmd_file.*,
    g_vmd_o         RECORD LIKE vmd_file.*,
    g_vmd01_t       LIKE vmd_file.vmd01,
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    l_cmd           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100)
    g_argv1	    LIKE vmd_file.vmd01
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
 
MAIN
    DEFINE l_time          LIKE type_file.chr8    #No.FUN-690010 VARCHAR(8)
    DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
    INITIALIZE g_vmd.* TO NULL
    INITIALIZE g_vmd_t.* TO NULL
    INITIALIZE g_vmd_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vmd_file WHERE vmd01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i303_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i303_w AT p_row,p_col
      WITH FORM "aps/42f/apsi303"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_argv1 =  ARG_VAL(1)               # 設備編號
    IF NOT cl_null(g_argv1)
       THEN CALL i303_q()
	    #CALL i303_u()    #FUN-870027
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL i303_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i303_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i303_cs()
    CLEAR FORM
    IF NOT cl_null(g_argv1)  THEN
        LET g_wc = "vmd01 = '",g_argv1,"'"
    ELSE
   INITIALIZE g_vmd.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
   #      vmd01,vmd02,vmd03,vmd04,vmd07,   ##NO.FUN-660193
          vmd01,vmd02,vmd03,vmd04,         #NO.FUN-840209 MODIFY
              vmd08                       #NO.FUN-840209
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
   #FUN-840209------add--------begin-----
    IF cl_null(g_vmd.vmd07) THEN
       LET g_wc =g_wc, ' AND vmd07 = 0 '
    ELSE 
       IF NOT cl_null(g_vmd.vmd07) THEN
          LET g_wc =g_wc, ' AND vmd07 = ',g_vmd.vmd07
       END IF
    END IF
   #FUN-840209------add---------end----
 
   #FUN-840209---------add------begin-------  
    ON ACTION controlp
    CASE
       WHEN INFIELD(vmd03)
            CALL cl_init_qry_var()
            LET g_qryparam.form     = "q_vmb"
            LET g_qryparam.default1 = g_vmd.vmd03
            CALL cl_create_qry() RETURNING g_vmd.vmd03
            DISPLAY BY NAME g_vmd.vmd03
            NEXT FIELD vmd03
 
       WHEN INFIELD(vmd02)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_vmc"
            LET g_qryparam.default1 = g_vmd.vmd02
            CALL cl_create_qry() RETURNING g_vmd.vmd02
            DISPLAY BY NAME g_vmd.vmd02
            NEXT FIELD vmd02
    END CASE
    #FUN-840209--------add-------end---------
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
   END IF
   IF INT_FLAG THEN RETURN END IF
#-->資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND eciuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND ecigrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND ecigrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('eciuser', 'ecigrup')
   #End:FUN-980030
 
   LET g_sql="SELECT vmd01 ",# 組合出 SQL 指令
             "  FROM vmd_file,eci_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND eci01 = vmd01 ",
             " ORDER BY vmd01 "
 
   PREPARE i303_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i303_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i303_prepare
   IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vmd_file ",
                 " WHERE vmd01 ='",g_argv1,"'"
   ELSE
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vmd_file,eci_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND eci01 = vmd01 "
   END IF
   PREPARE i303_precount FROM g_sql
   DECLARE i303_count CURSOR FOR i303_precount
END FUNCTION
 
FUNCTION i303_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i303_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i303_fetch('N')
        ON ACTION previous
            CALL i303_fetch('P')
        ON ACTION modify
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i303_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i303_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i303_fetch('/')
        ON ACTION first
            CALL i303_fetch('F')
        ON ACTION last
            CALL i303_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
  
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
   
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0163-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_vmd.vmd01 IS NOT NULL THEN
                  LET g_doc.column1 = "vmd01"
                  LET g_doc.value1 = g_vmd.vmd01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0163-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i303_cs
END FUNCTION
 
FUNCTION i303_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_vmd.vmd01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmd01_t = g_vmd.vmd01
    LET g_vmd_o.*= g_vmd.*
    BEGIN WORK
 
    OPEN i303_cl USING g_vmd.vmd01
    IF STATUS THEN
       CALL cl_err("OPEN i303_cl:", STATUS, 1)
       CLOSE i303_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i303_cl INTO g_vmd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmd.vmd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i303_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i303_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmd.*=g_vmd_t.*
            CALL i303_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmd_file SET vmd_file.* = g_vmd.*    # 更新DB
            WHERE vmd01 = g_vmd01_t             # COLAUTH?
        #FUN-840209 連批條件檢查碼為5時,資料庫存0
        IF cl_null(g_vmd.vmd07) THEN
UPDATE vmd_file SET vmd_file.vmd07 = 0
WHERE vmd01 = g_vmd01_t
        END IF
 
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_vmd.vmd01,SQLCA.sqlcode,0) #No.FUN-660095
          CALL cl_err3("upd","vmd_file",g_vmd01_t,"",SQLCA.sqlcode,"","",1) # Fun-660095
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i303_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i303_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_cnt        LIKE type_file.num5
 
    DISPLAY BY NAME
         g_vmd.vmd01,g_vmd.vmd02,g_vmd.vmd03,
         g_vmd.vmd04,
         g_vmd.vmd07,
         g_vmd.vmd08    #NO.FUN-840209 add
 
    INPUT BY NAME
         g_vmd.vmd01,g_vmd.vmd02,g_vmd.vmd03,
         g_vmd.vmd04,g_vmd.vmd07,
         g_vmd.vmd08    #NO.FUN-840209 add
        WITHOUT DEFAULTS
 
    AFTER FIELD vmd02 
        LET l_cnt= 0
        IF NOT cl_null(g_vmd.vmd02) THEN
            SELECT COUNT(*) INTO l_cnt
              FROM vmc_file
             WHERE vmc01 = g_vmd.vmd02
            IF l_cnt = 0 THEN
                CALL cl_err('','aps-403',0)
                NEXT FIELD vmd02
            END IF
        END IF
 
    AFTER FIELD vmd03 
        LET l_cnt= 0
        IF NOT cl_null(g_vmd.vmd03) THEN
            SELECT COUNT(*) INTO l_cnt
              FROM vmb_file
             WHERE vmb01 = g_vmd.vmd03
            IF l_cnt = 0 THEN
                CALL cl_err('','aps-402',0)
                NEXT FIELD vmd03
            END IF
        END IF
 
    AFTER FIELD vmd04
      IF NOT cl_null(g_vmd.vmd04) THEN
        IF g_vmd.vmd04 NOT MATCHES "[01]" THEN
            NEXT FIELD vmd04
        END IF
      END IF
 
    #FUN-840209-----------add-----begin----
    AFTER FIELD vmd08
      IF cl_null(g_vmd.vmd08) OR
         (NOT cl_null(g_vmd.vmd08) and (g_vmd.vmd08<0))THEN
         CALL cl_err('','mfg3291',0)
         NEXT FIELD vmd08
      END IF
    #FUN-840209-----------add------end------
 
        ON ACTION CONTROLR
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
 
      #FUN-840209---------add------begin-------
      ON ACTION controlp
      CASE
          WHEN INFIELD(vmd03)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_vmb"
               LET g_qryparam.default1 = g_vmd.vmd03
               CALL cl_create_qry() RETURNING g_vmd.vmd03
               DISPLAY BY NAME g_vmd.vmd03
               NEXT FIELD vmd03
 
          WHEN INFIELD(vmd02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_vmc"
               LET g_qryparam.default1=g_vmd.vmd02
               CALL cl_create_qry() RETURNING g_vmd.vmd02
               DISPLAY BY NAME g_vmd.vmd02
               NEXT FIELD vmd02
      END CASE
   #FUN-840209--------add-------end---------
 
 
 
 
    END INPUT
END FUNCTION
 
FUNCTION i303_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vmd.* TO NULL          #No.FUN-6A0163 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i303_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i303_count
    FETCH i303_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i303_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmd.vmd01,SQLCA.sqlcode,0)
        INITIALIZE g_vmd.* TO NULL
    ELSE
        CALL i303_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i303_fetch(p_flvmd_file)
    DEFINE
        p_flvmd_file     LIKE type_file.chr1,   #No.FUN-690010     VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flvmd_file
        WHEN 'N' FETCH NEXT     i303_cs INTO g_vmd.vmd01
        WHEN 'P' FETCH PREVIOUS i303_cs INTO g_vmd.vmd01
        WHEN 'F' FETCH FIRST    i303_cs INTO g_vmd.vmd01
        WHEN 'L' FETCH LAST     i303_cs INTO g_vmd.vmd01
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
            FETCH ABSOLUTE l_abso i303_cs INTO g_vmd.vmd01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmd.vmd01,SQLCA.sqlcode,0)
        INITIALIZE g_vmd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flvmd_file
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vmd.* FROM vmd_file
 WHERE vmd01 = g_vmd.vmd01
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_vmd.vmd01,SQLCA.sqlcode,0) #No.FUN-660095
         CALL cl_err3("sel","vmd_file",g_vmd.vmd01,"",SQLCA.sqlcode,"","",1) # FUN-660095
    ELSE
 
 
        CALL i303_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i303_show()
    LET g_vmd_t.* = g_vmd.*
    DISPLAY BY NAME
         g_vmd.vmd01,g_vmd.vmd02,g_vmd.vmd03,
         g_vmd.vmd04,
         g_vmd.vmd07,
         g_vmd.vmd08  #TQC-8A0051
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i303_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_vmd.vmd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i303_cl USING g_vmd.vmd01
    IF STATUS THEN
       CALL cl_err("OPEN i303_cl:", STATUS, 1)
       CLOSE i303_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i303_cl INTO g_vmd.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmd.vmd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i303_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmd.vmd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM vmd_file WHERE vmd01 = g_vmd.vmd01
        CLEAR FORM
    END IF
    CLOSE i303_cl
    COMMIT WORK
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #
