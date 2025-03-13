# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi321.4gl
# Descriptions...: 工作站資料維護作業
# Date & Author..: FUN-850114 08/01/08 by Yiting
# Modify.........: FUN-840209 08/05/20 BY DUKE
# Modify.........: FUN-870027 08/07/03 BY DUKE
# Modify.........: FUN-880010 08/08/04 BY DUKE add column vmj10 CPT介面上的排序依據，越小排越前面,預設值為999
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0082 09/10/26 By wujie 5.2转SQL标准语法
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmj           RECORD LIKE vmj_file.*,   #FUN-850114
    g_vmj_t         RECORD LIKE vmj_file.*,
    g_vmj_o         RECORD LIKE vmj_file.*,
    g_vmj01_t       LIKE vmj_file.vmj01,
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    l_cmd           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100)
    g_argv1	    LIKE vmj_file.vmj01
 
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
    INITIALIZE g_vmj.* TO NULL
    INITIALIZE g_vmj_t.* TO NULL
    INITIALIZE g_vmj_o.* TO NULL
 
#   LET g_forupd_sql = "SELECT * FROM vmj_file WHERE rowid = ? FOR UPDATE"
    LET g_forupd_sql = "SELECT * FROM vmj_file WHERE vmj01 = ? FOR UPDATE"   #No.FUN-9A0082
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i321_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i321_w AT p_row,p_col
      WITH FORM "aps/42f/apsi321"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_argv1 =  ARG_VAL(1)               # 設備編號
    IF NOT cl_null(g_argv1)
       THEN CALL i321_q()
	    #CALL i321_u()  #FUN-870027
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL i321_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i321_w
      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i321_cs()
    CLEAR FORM
    IF NOT cl_null(g_argv1)  THEN
        LET g_wc = "vmj01 = '",g_argv1,"'"
    ELSE
        INITIALIZE g_vmj.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
      #   vmj01,vmj02,vmj03,vmj04,vmj07  #FUN-840209
        vmj01,vmj02,vmj03,vmj04          #FUN-840209
 
        #No.FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
                   CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
 
 
     #FUN-840209------add--------begin-----
      IF g_vmj.vmj07='' THEN
         LET g_wc = g_wc,' AND vmj07 = 0 '
      ELSE
         LET g_wc = g_wc,' AND vmj07 = ',g_vmj.vmj07
      END IF
     #FUN-940209--------add-------end-------
     #FUN-880010--------add-------begin-----
      IF g_vmj.vmj10='' THEN
         LET g_wc = g_wc,'AND vmj10 = 999 '
      ELSE
         LET g_wc = g_wc,'AND vmj10 = ',g_vmj.vmj10
      END IF
 
      #FUN-840209---------add------begin-------
      ON ACTION controlp
         CASE
                WHEN INFIELD(vmj03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_vmb"
                     LET g_qryparam.default1 = g_vmj.vmj03
                     CALL cl_create_qry() RETURNING g_vmj.vmj03
                     DISPLAY BY NAME g_vmj.vmj03
                     NEXT FIELD vmj03
 
                WHEN INFIELD(vmj02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_vmc"
                     LET g_qryparam.default1 = g_vmj.vmj02
                     CALL cl_create_qry() RETURNING g_vmj.vmj02
                     DISPLAY BY NAME g_vmj.vmj02
                     NEXT FIELD vmj02
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   END IF
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT vmj01 ",# 組合出 SQL 指令
             "  FROM vmj_file,eca_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND eca01 = vmj01 ",
             " ORDER BY vmj01 "
 
   PREPARE i321_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i321_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i321_prepare
   IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vmj_file ",
                 " WHERE vmj01 ='",g_argv1,"'"
   ELSE
       LET g_sql="SELECT COUNT(*) ",
                 "  FROM vmj_file,eca_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND eca01 = vmj01 "
   END IF
   PREPARE i321_precount FROM g_sql
   DECLARE i321_count CURSOR FOR i321_precount
END FUNCTION
 
FUNCTION i321_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i321_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i321_fetch('N')
        ON ACTION previous
            CALL i321_fetch('P')
        ON ACTION modify
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i321_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL i321_r()
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
 
#       ON ACTION jump
#           CALL i321_fetch('/')
#       ON ACTION first
#           CALL i321_fetch('F')
#       ON ACTION last
#           CALL i321_fetch('L')
 
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
               IF g_vmj.vmj01 IS NOT NULL THEN
                  LET g_doc.column1 = "vmj01"
                  LET g_doc.value1 = g_vmj.vmj01
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
    CLOSE i321_cs
END FUNCTION
 
FUNCTION i321_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_vmj.vmj01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmj01_t = g_vmj.vmj01
    LET g_vmj_o.*= g_vmj.*
    BEGIN WORK
 
    OPEN i321_cl USING g_vmj.vmj01
    IF STATUS THEN
       CALL cl_err("OPEN i321_cl:", STATUS, 1)
       CLOSE i321_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i321_cl INTO g_vmj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmj.vmj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i321_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i321_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmj.*=g_vmj_t.*
            CALL i321_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmj_file SET vmj_file.* = g_vmj.*    # 更新DB
            WHERE vmj01 = g_vmj01_t             # COLAUTH?
        IF cl_null(g_vmj.vmj07) THEN   #FUN-840209
           UPDATE vmj_file set vmj07=0
           WHERE vmj01 = g_vmj01_t
        END IF
        IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","vmj_file",g_vmj01_t,"",SQLCA.sqlcode,"","",1) # Fun-660095
            CONTINUE WHILE
        END IF
        #FUN-880010----add----begin--
        IF cl_null(g_vmj.vmj10) THEN
           UPDATE vmj_file set vmj10 = 999
           WHERE vmj01 = g_vmj01_t
        END IF
        IF SQLCA.sqlcode THEN
          CALL cl_err3('upd',"vmj_file",g_vmj01_t,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        #FUN-880010----add----end----
 
 
        EXIT WHILE
    END WHILE
    CLOSE i321_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i321_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    DISPLAY BY NAME
         g_vmj.vmj01,g_vmj.vmj02,g_vmj.vmj03,
         g_vmj.vmj04,
         g_vmj.vmj07,
         g_vmj.vmj10  #FUN-870010
 
    INPUT BY NAME
         g_vmj.vmj01,g_vmj.vmj02,g_vmj.vmj03,
         g_vmj.vmj04,g_vmj.vmj07,
         g_vmj.vmj10   #FUN-880010
        WITHOUT DEFAULTS
 
    AFTER FIELD vmj04
      IF NOT cl_null(g_vmj.vmj04) THEN
        IF g_vmj.vmj04 NOT MATCHES "[01]" THEN
            NEXT FIELD vmj04
        END IF
      END IF
 
    #FUN-880010
    AFTER FIELD vmj10
      IF NOT cl_null(g_vmj.vmj10) THEN
        IF g_vmj.vmj10<=0  OR  g_vmj.vmj10>999 THEN
           NEXT FIELD vmj10
        END IF
      END IF
 
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
            WHEN INFIELD(vmj03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_vmb"
                 LET g_qryparam.default1 = g_vmj.vmj03
                 CALL cl_create_qry() RETURNING g_vmj.vmj03
                 DISPLAY BY NAME g_vmj.vmj03
                 NEXT FIELD vmj03
 
            WHEN INFIELD(vmj02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_vmc"
                 LET g_qryparam.default1=g_vmj.vmj02
                 CALL cl_create_qry() RETURNING g_vmj.vmj02
                 DISPLAY BY NAME g_vmj.vmj02
                 NEXT FIELD vmj02
         END CASE
      #FUN-840209--------add-------end---------
 
    END INPUT
END FUNCTION
 
FUNCTION i321_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_vmj.* TO NULL          #No.FUN-6A0163 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i321_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i321_count
    FETCH i321_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i321_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmj.vmj01,SQLCA.sqlcode,0)
        INITIALIZE g_vmj.* TO NULL
    ELSE
        CALL i321_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i321_fetch(p_flvmj_file)
    DEFINE
        p_flvmj_file     LIKE type_file.chr1,   #No.FUN-690010     VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flvmj_file
        WHEN 'N' FETCH NEXT     i321_cs INTO g_vmj.vmj01
        WHEN 'P' FETCH PREVIOUS i321_cs INTO g_vmj.vmj01
        WHEN 'F' FETCH FIRST    i321_cs INTO g_vmj.vmj01
        WHEN 'L' FETCH LAST     i321_cs INTO g_vmj.vmj01
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
            FETCH ABSOLUTE l_abso i321_cs INTO g_vmj.vmj01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmj.vmj01,SQLCA.sqlcode,0)
        INITIALIZE g_vmj.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flvmj_file
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vmj.* FROM vmj_file            
WHERE vmj01 = g_vmj.vmj01
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_vmj.vmj01,SQLCA.sqlcode,0) #No.FUN-660095
         CALL cl_err3("sel","vmj_file",g_vmj.vmj01,"",SQLCA.sqlcode,"","",1) # FUN-660095
    ELSE
 
 
        CALL i321_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i321_show()
    LET g_vmj_t.* = g_vmj.*
    DISPLAY BY NAME
         g_vmj.vmj01,g_vmj.vmj02,g_vmj.vmj03,
         g_vmj.vmj04,
         g_vmj.vmj07,
         g_vmj.vmj10   #FUN-880010
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i321_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_vmj.vmj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i321_cl USING g_vmj.vmj01
    IF STATUS THEN
       CALL cl_err("OPEN i321_cl:", STATUS, 1)
       CLOSE i321_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i321_cl INTO g_vmj.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmj.vmj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i321_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmj01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmj.vmj01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM vmj_file WHERE vmj01 = g_vmj.vmj01
        CLEAR FORM
    END IF
    CLOSE i321_cl
    COMMIT WORK
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #
