# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxi800.4gl
# Descriptions...: 保稅原因維護作業
#
# Modify.........: No:9573 04/05/20 By 0818欄位未做合理性管控,bxr11,bxr12,bxr13,
# Modify.........:                                            bxr91,bxr92,bxr93,
# Modify.........: No.FUN-530025 05/03/17 By kim 報表轉XML功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0046 06/10/18 By jamie 1.FUNCTION i800()_q 一開始應清空g_bxr.*的值
 
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/10/30 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/18 By lala   報表轉為使用p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bxr   		RECORD LIKE bxr_file.*,
    g_bxr_t 		RECORD LIKE bxr_file.*,
    g_bxr01_t 		LIKE bxr_file.bxr01,
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN   
    g_buf    		LIKE type_file.chr1000,          #No.FUN-680062  VARCHAR(40)
    g_argv1		LIKE bxr_file.bxr01
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
 DEFINE g_before_input_done   STRING 
DEFINE   g_cnt           LIKE type_file.num10                                 #No.FUN-680062  INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680062  SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680062     VARCHAR(72) 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680062     INTEGER
DEFINE   g_curs_index    LIKE type_file.num10,        #No.FUN-680062     INTEGER
         mi_no_ask       LIKE type_file.num5,         #No.FUN-680062     SMALLINT
         g_jump          LIKE type_file.num10         #No.FUN-680062     INTEGER
MAIN
    DEFINE
        p_row,p_col      LIKE type_file.num5          #No.FUN-680062     SMALLINT
#       l_time           LIKE type_file.chr8          #No.FUN-6A0062
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
    INITIALIZE g_bxr.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bxr_file WHERE bxr01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i800_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 8
    OPEN WINDOW i800_w AT p_row,p_col WITH FORM "abx/42f/abxi800" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL i800_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i800_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i800_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION i800_curs()
    CLEAR FORM
    IF cl_null(g_argv1) THEN
   INITIALIZE g_bxr.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              bxr01,bxr02,bxr04
              #FUN-6A0007...............begin
              ,bxr11,bxr12,bxr13,bxr21,bxr22,bxr23,bxr24,bxr25,bxr26,
              bxr31,bxr41,bxr42,bxr51,bxr60,bxr61,bxr62,bxr63,bxr64,
              bxr91,bxr92,bxr93,bxr94,bxr95
              #FUN-6A0007...............end
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    ELSE
       LET g_wc = "bxr01 ='",g_argv1,"'"
    END IF
    LET g_sql="SELECT bxr01 FROM bxr_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY bxr01"
    PREPARE i800_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i800_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i800_prepare
    LET g_sql= "SELECT COUNT(*) FROM bxr_file WHERE ",g_wc CLIPPED
    PREPARE i800_cntpre FROM g_sql
    DECLARE i800_count CURSOR FOR i800_cntpre
END FUNCTION
 
FUNCTION i800_menu()
DEFINE l_cmd  LIKE type_file.chr1000     #No.FUN-820002 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
          LET g_action_choice="insert" 
          IF cl_chk_act_auth() THEN
             CALL i800_a() 
          END IF
        ON ACTION query 
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
             CALL i800_q() 
          END IF NEXT OPTION "next" 
        ON ACTION next 
          CALL i800_fetch('N') 
        ON ACTION previous 
          CALL i800_fetch('P')
        ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL i800_u() 
          END IF NEXT OPTION "next"
        ON ACTION delete 
          LET g_action_choice="delete"
          IF cl_chk_act_auth() THEN
             CALL i800_r() 
          END IF NEXT OPTION "next"
        ON ACTION output 
          LET g_action_choice="output"
          IF cl_chk_act_auth() THEN 
             CALL i800_out()
          END IF
 
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i800_fetch('/') 
        ON ACTION first
           CALL i800_fetch('F')  
        ON ACTION last
           CALL i800_fetch('L') 
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_bxr.bxr01 IS NOT NULL THEN
                  LET g_doc.column1 = "bxr01"
                  LET g_doc.value1 = g_bxr.bxr01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0046-------add--------end----
 
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i800_cs
END FUNCTION
 
 
FUNCTION bxr_default()
    LET g_bxr.bxr04 = 0
    LET g_bxr.bxr11 = 0
    LET g_bxr.bxr12 = 0
    LET g_bxr.bxr13 = 0
    LET g_bxr.bxr21 = 0
    LET g_bxr.bxr22 = 0
    LET g_bxr.bxr23 = 0
    LET g_bxr.bxr24 = 0
    LET g_bxr.bxr25 = 0
    LET g_bxr.bxr26 = 0
    LET g_bxr.bxr31 = 0
    LET g_bxr.bxr41 = 0
    LET g_bxr.bxr42 = 0
    LET g_bxr.bxr51 = 0
    LET g_bxr.bxr60 = 0
    LET g_bxr.bxr61 = 0
    LET g_bxr.bxr62 = 0
    LET g_bxr.bxr63 = 0
    LET g_bxr.bxr64 = 0
    LET g_bxr.bxr91 = 'N'
    LET g_bxr.bxr92 = 'N'
    LET g_bxr.bxr93 = 'N'
    LET g_bxr.bxr94 = 'N'
    LET g_bxr.bxr95 = 'N'
END FUNCTION
 
FUNCTION i800_a()
    MESSAGE ""
    CLEAR FORM               
    INITIALIZE g_bxr.* TO NULL
    CALL bxr_default()
    LET g_bxr01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i800_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0) CLEAR FORM EXIT WHILE
        END IF
        IF g_bxr.bxr01 IS NULL THEN CONTINUE WHILE END IF
        INSERT INTO bxr_file VALUES(g_bxr.*)
        IF STATUS THEN 
#          CALL cl_err(g_bxr.bxr01,STATUS,0)  #No.FUN-660052
           CALL cl_err3("ins","bxr_file",g_bxr.bxr01,"",STATUS,"","",1)
           CONTINUE WHILE
        ELSE LET g_bxr_t.* = g_bxr.*          # 保存上筆資料
           SELECT bxr01 INTO g_bxr.bxr01 FROM bxr_file
            WHERE bxr01 = g_bxr.bxr01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i800_i(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
    DEFINE l_flag	LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
    DEFINE l_n		LIKE type_file.num5          #No.FUN-680062  SMALLINT
 
    INPUT BY NAME 
        g_bxr.bxr01,g_bxr.bxr02,g_bxr.bxr04,
        g_bxr.bxr11, g_bxr.bxr12, g_bxr.bxr13,
        g_bxr.bxr21, g_bxr.bxr22, g_bxr.bxr23, g_bxr.bxr24, g_bxr.bxr25,
        g_bxr.bxr26, g_bxr.bxr31, g_bxr.bxr41, g_bxr.bxr42,
        g_bxr.bxr51,
        g_bxr.bxr60, g_bxr.bxr61, g_bxr.bxr62, g_bxr.bxr63, g_bxr.bxr64,
        g_bxr.bxr91, g_bxr.bxr92, g_bxr.bxr93, g_bxr.bxr94, g_bxr.bxr95
        WITHOUT DEFAULTS 
 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i800_set_entry(p_cmd)
           CALL i800_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD bxr01
          IF NOT cl_null(g_bxr.bxr01) THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_bxr.bxr01 != g_bxr_t.bxr01) THEN
                SELECT count(*) INTO l_n FROM bxr_file
                    WHERE bxr01 = g_bxr.bxr01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_bxr.bxr01,-239,0)
                    LET g_bxr.bxr01 = g_bxr_t.bxr01
                    DISPLAY BY NAME g_bxr.bxr01
                    NEXT FIELD bxr01
                END IF
            END IF
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_bxr.bxr11)  THEN
               LET l_flag='Y' DISPLAY BY NAME g_bxr.bxr11 
            END IF    
            IF cl_null(g_bxr.bxr12)  THEN
               LET l_flag='Y' DISPLAY BY NAME g_bxr.bxr12 
            END IF    
            IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD bxr01 END IF
        #No.9573
        AFTER FIELD bxr04
            IF cl_null(g_bxr.bxr04) THEN NEXT FIELD bxr04 END IF
            IF g_bxr.bxr04 >1 OR g_bxr.bxr04 < -1 THEN NEXT FIELD bxr04 END IF
 
        AFTER FIELD bxr11
            IF cl_null(g_bxr.bxr11) THEN NEXT FIELD bxr11 END IF
            IF g_bxr.bxr11 >1 OR g_bxr.bxr11 < -1 THEN NEXT FIELD bxr11 END IF
 
        AFTER FIELD bxr12
            IF cl_null(g_bxr.bxr12) THEN NEXT FIELD bxr12 END IF
            IF g_bxr.bxr12 >1 OR g_bxr.bxr12 < -1 THEN NEXT FIELD bxr12 END IF
 
        AFTER FIELD bxr13
            IF cl_null(g_bxr.bxr13) THEN NEXT FIELD bxr13 END IF
            IF g_bxr.bxr13 >1 OR g_bxr.bxr13 < -1 THEN NEXT FIELD bxr13 END IF
 
        AFTER FIELD bxr21
            IF cl_null(g_bxr.bxr21) THEN NEXT FIELD bxr21 END IF
            IF g_bxr.bxr21 >1 OR g_bxr.bxr21 < -1 THEN NEXT FIELD bxr21 END IF
 
        AFTER FIELD bxr22
 
            IF cl_null(g_bxr.bxr22) THEN NEXT FIELD bxr22 END IF
            IF g_bxr.bxr22 >1 OR g_bxr.bxr22 < -1 THEN NEXT FIELD bxr22 END IF
 
        AFTER FIELD bxr23
            IF cl_null(g_bxr.bxr23) THEN NEXT FIELD bxr23 END IF
            IF g_bxr.bxr23 >1 OR g_bxr.bxr23 < -1 THEN NEXT FIELD bxr23 END IF
 
        AFTER FIELD bxr24
            IF cl_null(g_bxr.bxr24) THEN NEXT FIELD bxr24 END IF
            IF g_bxr.bxr24 >1 OR g_bxr.bxr24 < -1 THEN NEXT FIELD bxr24 END IF
 
        AFTER FIELD bxr25
            IF cl_null(g_bxr.bxr25) THEN NEXT FIELD bxr25 END IF
            IF g_bxr.bxr25 >1 OR g_bxr.bxr25 < -1 THEN NEXT FIELD bxr25 END IF
 
        AFTER FIELD bxr26
            IF cl_null(g_bxr.bxr26) THEN NEXT FIELD bxr26 END IF
            IF g_bxr.bxr26 >1 OR g_bxr.bxr26 < -1 THEN NEXT FIELD bxr26 END IF
 
        AFTER FIELD bxr31
            IF cl_null(g_bxr.bxr31) THEN NEXT FIELD bxr31 END IF
            IF g_bxr.bxr31 >1 OR g_bxr.bxr31 < -1 THEN NEXT FIELD bxr31 END IF
 
        AFTER FIELD bxr41
            IF cl_null(g_bxr.bxr41) THEN NEXT FIELD bxr41 END IF
            IF g_bxr.bxr41 >1 OR g_bxr.bxr41 < -1 THEN NEXT FIELD bxr41 END IF
 
        AFTER FIELD bxr42
            IF cl_null(g_bxr.bxr42) THEN NEXT FIELD bxr42 END IF
            IF g_bxr.bxr42 >1 OR g_bxr.bxr42 < -1 THEN NEXT FIELD bxr42 END IF
 
        AFTER FIELD bxr51
            IF cl_null(g_bxr.bxr51) THEN NEXT FIELD bxr51 END IF
            IF g_bxr.bxr51 >1 OR g_bxr.bxr51 < -1 THEN NEXT FIELD bxr51 END IF
 
        AFTER FIELD bxr60
            IF cl_null(g_bxr.bxr60) THEN NEXT FIELD bxr60 END IF
            IF g_bxr.bxr60 >1 OR g_bxr.bxr60 < -1 THEN NEXT FIELD bxr60 END IF
 
        AFTER FIELD bxr61
            IF cl_null(g_bxr.bxr61) THEN NEXT FIELD bxr61 END IF
            IF g_bxr.bxr61 >1 OR g_bxr.bxr61 < -1 THEN NEXT FIELD bxr61 END IF
 
        AFTER FIELD bxr62
            IF cl_null(g_bxr.bxr62) THEN NEXT FIELD bxr62 END IF
            IF g_bxr.bxr62 >1 OR g_bxr.bxr62 < -1 THEN NEXT FIELD bxr62 END IF
 
        AFTER FIELD bxr63
            IF cl_null(g_bxr.bxr63) THEN NEXT FIELD bxr63 END IF
            IF g_bxr.bxr63 >1 OR g_bxr.bxr63 < -1 THEN NEXT FIELD bxr63 END IF
 
        AFTER FIELD bxr64
            IF cl_null(g_bxr.bxr64) THEN NEXT FIELD bxr64 END IF
            IF g_bxr.bxr64 >1 OR g_bxr.bxr64 < -1 THEN NEXT FIELD bxr64 END IF
 
        AFTER FIELD bxr91
            IF NOT cl_null(g_bxr.bxr91) AND
               g_bxr.bxr91 NOT MATCHES '[YN]' THEN  NEXT FIELD bxr91 END IF
 
        AFTER FIELD bxr92
            IF cl_null(g_bxr.bxr92) AND
               g_bxr.bxr92 NOT MATCHES '[YN]'  THEN NEXT FIELD bxr92 END IF
 
        AFTER FIELD bxr93
            IF cl_null(g_bxr.bxr93) AND
               g_bxr.bxr93 NOT MATCHES '[YN]'  THEN NEXT FIELD bxr93 END IF
 
        AFTER FIELD bxr94
            IF cl_null(g_bxr.bxr94) AND
               g_bxr.bxr94 NOT MATCHES '[YN]' THEN  NEXT FIELD bxr94 END IF
 
        AFTER FIELD bxr95
            IF cl_null(g_bxr.bxr95) AND
               g_bxr.bxr95 NOT MATCHES '[YN]' THEN  NEXT FIELD bxr95 END IF
        #--
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位FTER FIELD bxr92
        #    IF INFIELD(bxr01) AND p_cmd = 'a'THEN
        #       LET g_bxr.* = g_bxr_t.*
        #       CALL i800_show()
        #       NEXT FIELD bxr01
        #    END IF
        #MOD-650015 --end
 
        ON KEY(F1) NEXT FIELD bxr11
        ON KEY(F2) NEXT FIELD bxr21
 
#       ON ACTION CONTROLP
#          CASE WHEN INFIELD(bxr01) CALL q_bxr(10,3,g_bxr.bxr01)
#                                   RETURNING g_bxr.bxr01
#          CASE WHEN INFIELD(bxr01) CALL FGL_DIALOG_SETBUFFER( g_bxr.bxr01 )
#                                   DISPLAY BY NAME g_bxr.bxr01
#                                   NEXT FIELD bxr01
#          END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
FUNCTION i800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bxr.* TO NULL             #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i800_curs()
    IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
    OPEN i800_count
    FETCH i800_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i800_cs
    IF STATUS
       THEN CALL cl_err(g_bxr.bxr01,STATUS,0)
            INITIALIZE g_bxr.* TO NULL
       ELSE CALL i800_fetch('F')
    END IF
END FUNCTION
 
FUNCTION i800_fetch(p_flbxr)
     DEFINE p_flbxr     LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
     DEFINE l_abso	LIKE type_file.num10         #No.FUN-680062  INTEGER
 
    CASE p_flbxr
        WHEN 'N' FETCH NEXT     i800_cs INTO g_bxr.bxr01
        WHEN 'P' FETCH PREVIOUS i800_cs INTO g_bxr.bxr01
        WHEN 'F' FETCH FIRST    i800_cs INTO g_bxr.bxr01
        WHEN 'L' FETCH LAST     i800_cs INTO g_bxr.bxr01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i800_cs INTO g_bxr.bxr01
            LET mi_no_ask =FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bxr.bxr01,SQLCA.sqlcode,0)
        INITIALIZE g_bxr.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flbxr
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
 
    SELECT * INTO g_bxr.* FROM bxr_file WHERE bxr01 = g_bxr.bxr01
    IF STATUS THEN
#      CALL cl_err(g_bxr.bxr01,STATUS,0)  #No.FUN-660052
       CALL cl_err3("sel","bxr_file",g_bxr.bxr01,"",STATUS,"","",1)
    ELSE 
       CALL i800_show()
    END IF
END FUNCTION
 
FUNCTION i800_show()
    LET g_bxr_t.* = g_bxr.*
    DISPLAY BY NAME 
        g_bxr.bxr01,g_bxr.bxr02,g_bxr.bxr04,
        g_bxr.bxr11, g_bxr.bxr12, g_bxr.bxr13,
        g_bxr.bxr21, g_bxr.bxr22, g_bxr.bxr23, g_bxr.bxr24, g_bxr.bxr25,
        g_bxr.bxr26, g_bxr.bxr31, g_bxr.bxr41, g_bxr.bxr42,
        g_bxr.bxr51,
        g_bxr.bxr60, g_bxr.bxr61, g_bxr.bxr62, g_bxr.bxr63, g_bxr.bxr64,
        g_bxr.bxr91, g_bxr.bxr92, g_bxr.bxr93, g_bxr.bxr94, g_bxr.bxr95
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i800_u()
    IF g_bxr.bxr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bxr01_t = g_bxr.bxr01
    BEGIN WORK
 
    OPEN i800_cl USING g_bxr.bxr01
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_bxr.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_bxr.bxr01,STATUS,0) RETURN END IF
    LET g_bxr_t.*=g_bxr.*
    CALL i800_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i800_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET g_bxr.*=g_bxr_t.* CALL i800_show()
            LET INT_FLAG = 0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        UPDATE bxr_file SET * = g_bxr.* WHERE bxr01 = g_bxr01_t
        IF STATUS THEN 
#          CALL cl_err(g_bxr.bxr01,STATUS,0)  #No.FUN-660052
           CALL cl_err3("upd","bxr_file",g_bxr01_t,"",STATUS,"","",1)
           CONTINUE WHILE 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i800_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i800_r()
    IF g_bxr.bxr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i800_cl USING g_bxr.bxr01
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_bxr.*
    IF STATUS THEN CALL cl_err(g_bxr.bxr01,STATUS,0) RETURN END IF
    CALL i800_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bxr01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bxr.bxr01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bxr_file WHERE bxr01 = g_bxr.bxr01
       CLEAR FORM 
       OPEN i800_count
       FETCH i800_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i800_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i800_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i800_fetch('/')
       END IF
 
    END IF
    CLOSE i800_cl
    COMMIT WORK
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION i800_out()
DEFINE l_cmd  LIKE type_file.chr1000 
#    DEFINE l_bxr          RECORD LIKE bxr_file.*
#    DEFINE l_i            LIKE type_file.num5          #No.FUN-680062
#    DEFINE l_name         LIKE type_file.chr20,        #No.FUN-680062 VARCHAR(20)
#           l_za05         LIKE za_file.za05            #No.FUN-680062 VARCHAR(40)
     IF cl_null(g_wc) AND NOT cl_null(g_bxr.bxr01) THEN                                                                             
        LET g_wc = " bxr01 = '",g_bxr.bxr01,"'"                                                                                     
     END IF                                                                                                                         
     IF g_wc IS NULL THEN                                                                                                           
        CALL cl_err('','9057',0)                                                                                                    
        RETURN                                                                                                                      
     END IF                                                                                                                         
     LET l_cmd = 'p_query "abxi800" "',g_wc CLIPPED,'"'                                                                             
     CALL cl_cmdrun(l_cmd)
#    IF g_wc IS NULL THEN 
    #  CALL cl_err('',-400,0) 
#       CALL cl_err('','9057',0)
#    RETURN END IF
#    CALL cl_wait()
#    CALL cl_outnam('abxi800') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    LET g_sql="SELECT * FROM bxr_file WHERE ",g_wc CLIPPED
#    PREPARE i800_p1 FROM g_sql
#    DECLARE i800_co CURSOR FOR i800_p1
 
#    START REPORT i800_rep TO l_name
 
#    FOREACH i800_co INTO l_bxr.*
#       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#       OUTPUT TO REPORT i800_rep(l_bxr.*)
#    END FOREACH
 
#    FINISH REPORT i800_rep
 
#    CLOSE i800_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i800_rep(sr)
#  DEFINE l_trailer_sw   LIKE type_file.chr1                 #No.FUN-680062 VARCHAR(1)
#  DEFINE x    LIKE type_file.chr6                           #No.FUN-680062 VARCHAR(6)
#  DEFINE sr              RECORD LIKE bxr_file.*
 
# OUTPUT TOP MARGIN g_top_margin 
#LEFT MARGIN g_left_margin 
#BOTTOM MARGIN g_bottom_margin 
#PAGE LENGTH g_page_line
 
# ORDER BY sr.bxr01
 
# FORMAT
#  PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT 
#      PRINT g_dash
#      PRINT g_x[31],g_x[32]
#      PRINT g_dash1
#      LET l_trailer_sw = 'y'
 
#  ON EVERY ROW
#    PRINT COLUMN g_c[31],sr.bxr01,
#          COLUMN g_c[32],sr.bxr02  #'    庫存加減方式:',sr.bxr04
#    PRINT
#{
#    PRINT
#    PRINT x,'    保稅進口數:',sr.bxr11,'         核准報廢數:',sr.bxr41
#    PRINT x,'    視同進口數:',sr.bxr12,'         調  整  數:',sr.bxr42
#    PRINT x,'    非保進口數:',sr.bxr13
#    PRINT x,'                              成品存倉數:',sr.bxr51
#    PRINT x,'廠內生產領用數:',sr.bxr21
#    PRINT x,'廠外生產領用數:',sr.bxr22,'         成品出倉數:',sr.bxr60
#    PRINT x,'    外運數    :',sr.bxr23,'         直接出口數:',sr.bxr61
#    PRINT x,'    其他領用數:',sr.bxr24,'         視同出口數:',sr.bxr62
#    PRINT x,'    原料內銷數:',sr.bxr25,'         內  銷  數:',sr.bxr63
#    PRINT x,'    原料外銷數:',sr.bxr26,'         其它出倉數:',sr.bxr64
#    PRINT x,'    生產退料數:',sr.bxr31
#    PRINT
#    PRINT g_dash[1,g_len]
#}
#  ON LAST ROW
#    LET l_trailer_sw = 'n'
 
#  PAGE TRAILER
#    PRINT g_dash
#    IF l_trailer_sw = 'y'
#       THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#    END IF
#END REPORT
#No.FUN-820002--end--
 
FUNCTION i800_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bxr01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i800_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bxr01",FALSE)
   END IF
END FUNCTION
 
