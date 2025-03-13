# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: anmq302.4gl
# Descriptions...: 銀行對帳單下載歷史記錄查詢
# Date & Author..: 07/03/19 By Rayven
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nmr                 RECORD LIKE nmr_file.*
DEFINE g_nmr_t               RECORD LIKE nmr_file.*  #備份舊值
DEFINE g_nmr01_t             LIKE nmr_file.nmr01     #Key值備份
DEFINE g_wc                  STRING                  #儲存 user 的查詢條件
DEFINE g_sql                 STRING                  #組 sql 用
DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10    #總筆數
DEFINE g_jump                LIKE type_file.num10    #查詢指定的筆數
DEFINE mi_no_ask             LIKE type_file.num5     #是否開啟指定筆視窗
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_aza.aza73 = 'N' THEN
      CALL cl_err('','anm-980',1)
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_nmr.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM nmr_file WHERE nmr01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q302_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW q302_w AT p_row,p_col WITH FORM "anm/42f/anmq302"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL q302_menu()
 
   CLOSE WINDOW q302_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q302_curs()
DEFINE ls      STRING
 
    CLEAR FORM
   INITIALIZE g_nmr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        nmr01,nmr02,nmr03
 
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(nmr01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nma"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_nmr.nmr01
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO nmr01
                NEXT FIELD nmr01
 
             OTHERWISE
                EXIT CASE
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
 
    LET g_sql="SELECT nmr01 FROM nmr_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY nmr01"
    PREPARE q302_prepare FROM g_sql
    DECLARE q302_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q302_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM nmr_file WHERE ",g_wc CLIPPED
    PREPARE q302_precount FROM g_sql
    DECLARE q302_count CURSOR FOR q302_precount
END FUNCTION
 
FUNCTION q302_menu()
  DEFINE l_cmd  LIKE type_file.chr1000
 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL q302_q()
            END IF
 
        ON ACTION next
            CALL q302_fetch('N')
 
        ON ACTION previous
            CALL q302_fetch('P')
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL q302_fetch('/')
 
        ON ACTION first
            CALL q302_fetch('F')
 
        ON ACTION last
            CALL q302_fetch('L')
 
        ON ACTION controlg
            CALL cl_cmdask()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
    CLOSE q302_cs
END FUNCTION
 
FUNCTION q302_nmr01()
 DEFINE  l_nma02   LIKE nma_file.nma02
 DEFINE  l_nma04   LIKE nma_file.nma04
 DEFINE  l_nma39   LIKE nma_file.nma39
 DEFINE  l_nmt02   LIKE nmt_file.nmt02
 
   SELECT nma02,nma04,nma39,nmt02
     INTO l_nma02,l_nma04,l_nma39,l_nmt02
     FROM nma_file,OUTER nmt_file
    WHERE nma01 = g_nmr.nmr01
      AND nma_file.nma39 = nmt_file.nmt01
 
    DISPLAY l_nma02 TO FORMONLY.nma02
    DISPLAY l_nma04 TO FORMONLY.nma04
    DISPLAY l_nma39 TO FORMONLY.nma39
    DISPLAY l_nmt02 TO FORMONLY.nmt02
END FUNCTION
 
FUNCTION q302_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_nmr.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q302_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN q302_count
    FETCH q302_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q302_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmr.nmr01,SQLCA.sqlcode,0)
        INITIALIZE g_nmr.* TO NULL
    ELSE
        CALL q302_fetch('F')              # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION q302_fetch(p_flnmr)
    DEFINE
        p_flnmr         LIKE type_file.chr1
 
    CASE p_flnmr
        WHEN 'N' FETCH NEXT     q302_cs INTO g_nmr.nmr01
        WHEN 'P' FETCH PREVIOUS q302_cs INTO g_nmr.nmr01
        WHEN 'F' FETCH FIRST    q302_cs INTO g_nmr.nmr01
        WHEN 'L' FETCH LAST     q302_cs INTO g_nmr.nmr01
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
 
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q302_cs INTO g_nmr.nmr01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nmr.nmr01,SQLCA.sqlcode,0)
       INITIALIZE g_nmr.* TO NULL
       RETURN
    ELSE
       CASE p_flnmr
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_nmr.* FROM nmr_file    # 重讀DB,因TEMP有不被更新特性
     WHERE nmr01 = g_nmr.nmr01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","nmr_file",g_nmr.nmr01,"",SQLCA.sqlcode,"","",0)
    ELSE
       CALL q302_show()                    # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q302_show()
    LET g_nmr_t.* = g_nmr.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_nmr.*
    DISPLAY BY NAME g_nmr.nmr01,g_nmr.nmr02,g_nmr.nmr03
    #No.FUN-9A0024--end 
    CALL q302_nmr01()
    CALL cl_show_fld_cont()
END FUNCTION
