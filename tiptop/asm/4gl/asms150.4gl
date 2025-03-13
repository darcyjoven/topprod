# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asms150.4gl
# Descriptions...: 成本項目資料維護作業
# Date & Author..: 91/04/11 By Lee
# Modify.........: No.FUN-4C0033 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510031 05/01/18 By pengu 報表轉XML
# Modify.........: No.FUN-580024 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.TQC-5C0059 06/01/12 By kevin 結束線條調整
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/20 By Sunyanchun   把老報表改成p_query 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_smg   RECORD LIKE smg_file.*,
    g_smg_t RECORD LIKE smg_file.*,
    g_smg_o RECORD LIKE smg_file.*,
    g_smg01_t LIKE smg_file.smg01,
    g_wc,g_sql          STRING #TQC-630166 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
 
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0089
    DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
    INITIALIZE g_smg.* TO NULL
    INITIALIZE g_smg_t.* TO NULL
    INITIALIZE g_smg_o.* TO NULL
    LET g_forupd_sql = "SELECT * FROM smg_file WHERE smg01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s150_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 5 LET p_col = 28
 
    OPEN WINDOW s150_w AT p_row,p_col
        WITH FORM "asm/42f/asms150"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s150_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s150_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION s150_cs()
    CLEAR FORM
    WHILE TRUE
   INITIALIZE g_smg.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        smg01,smg03,smg02,
        smguser,smggrup,smgmodu,smgdate,smgacti
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
      IF INT_FLAG THEN RETURN END IF
      IF g_wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
    END WHILE
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND smguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND smggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND smggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('smguser', 'smggrup')
    #End:FUN-980030
 
    LET g_sql="SELECT smg01 FROM smg_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY smg01"
    PREPARE s150_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE s150_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s150_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM smg_file WHERE ",g_wc CLIPPED
    PREPARE s150_precount FROM g_sql
    DECLARE s150_count CURSOR FOR s150_precount
END FUNCTION
 
FUNCTION s150_menu()
DEFINE l_cmd  LIKE type_file.chr1000           #No.FUN-7C0043---add---
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL s150_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s150_q()
            END IF
        ON ACTION next
            CALL s150_fetch('N')
        ON ACTION previous
            CALL s150_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL s150_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL s150_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL s150_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL s150_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL s150_out()                                                                                    
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL s150_fetch('/')
        ON ACTION first
            CALL s150_fetch('F')
        ON ACTION last
            CALL s150_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE s150_cs
END FUNCTION
 
 
FUNCTION s150_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_smg.* LIKE smg_file.*
    LET g_smg01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        #NO.FUN-590002-start----
        LET g_smg.smg03 = '1'
        #NO.FUN-590002-end----
        LET g_smg.smgacti ='Y'                   #有效的資料
        LET g_smg.smguser = g_user
        LET g_smg.smgoriu = g_user #FUN-980030
        LET g_smg.smgorig = g_grup #FUN-980030
        LET g_smg.smggrup = g_grup               #使用者所屬群
        LET g_smg.smgdate = g_today
        CALL s150_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_smg.smg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO smg_file VALUES(g_smg.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("ins","smg_file",g_smg.smg01,g_smg.smg02,SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        ELSE
            LET g_smg_t.* = g_smg.*                # 保存上筆資料
            SELECT smg01 INTO g_smg.smg01 FROM smg_file
                WHERE smg01 = g_smg.smg01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION s150_i(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
            l_n      LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   INPUT BY NAME
      g_smg.smg01,g_smg.smg03,g_smg.smg02,
      g_smg.smguser,g_smg.smggrup,g_smg.smgmodu,g_smg.smgdate,g_smg.smgacti
      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL s150_set_entry(p_cmd)
            CALL s150_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
      AFTER FIELD smg01
         IF NOT cl_null(g_smg.smg01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_smg.smg01 != g_smg01_t) THEN
               SELECT count(*) INTO l_n FROM smg_file WHERE smg01 = g_smg.smg01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_smg.smg01,-239,0)
                  LET g_smg.smg01 = g_smg01_t
                  DISPLAY BY NAME g_smg.smg01
                  NEXT FIELD smg01
               END IF
            END IF
         END IF
 
      AFTER FIELD smg03
         IF NOT cl_null(g_smg.smg03) THEN
            IF g_smg.smg03 not matches'[12345]' THEN
               LET g_smg.smg03 = g_smg_o.smg03
               DISPLAY BY NAME g_smg.smg03
               NEXT FIELD smg03
            END IF
            LET g_smg_o.smg03 = g_smg.smg03
         END IF
 
      AFTER INPUT
         LET g_smg.smguser = s_get_data_owner("smg_file") #FUN-C10039
         LET g_smg.smggrup = s_get_data_group("smg_file") #FUN-C10039
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
       #MOD-650015 --start
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(smg01) THEN
      #      LET g_smg.* = g_smg_t.*
      #      DISPLAY BY NAME g_smg.*
      #      NEXT FIELD smg01
      #   END IF
        #MOD-650015 --end
 
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
 
 
   END INPUT
END FUNCTION
 
FUNCTION s150_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s150_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN s150_count
    FETCH s150_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN s150_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)
        INITIALIZE g_smg.* TO NULL
    ELSE
        CALL s150_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION s150_fetch(p_flsmg)
    DEFINE
        p_flsmg     LIKE type_file.chr1    #No.FUN-690010        VARCHAR(1)
 
    CASE p_flsmg
        WHEN 'N' FETCH NEXT     s150_cs INTO g_smg.smg01
        WHEN 'P' FETCH PREVIOUS s150_cs INTO g_smg.smg01
        WHEN 'F' FETCH FIRST    s150_cs INTO g_smg.smg01
        WHEN 'L' FETCH LAST     s150_cs INTO g_smg.smg01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            END IF
            FETCH ABSOLUTE g_jump s150_cs INTO g_smg.smg01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)
        INITIALIZE g_smg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsmg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_smg.* FROM smg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE smg01 = g_smg.smg01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("sel","smg_file",g_smg.smg01,g_smg.smg02,SQLCA.sqlcode,"","",0) #No.FUN-660138
    ELSE                                     #FUN-4C0033權限控管
       LET g_data_owner = g_smg.smguser
       LET g_data_group = g_smg.smggrup
        CALL s150_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s150_show()
    LET g_smg_t.* = g_smg.*
    #No.FUN-9A0024--begin     
    #DISPLAY BY NAME g_smg.*                             
    DISPLAY BY NAME g_smg.smg01,g_smg.smg03,g_smg.smg02,g_smg.smguser,g_smg.smggrup,
                    g_smg.smgmodu,g_smg.smgdate,g_smg.smgacti,g_smg.smgoriu,g_smg.smgorig    
    #No.FUN-9A0024--end  
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s150_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_smg.smg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_smg.smgacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_smg.smg01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
    OPEN s150_cl USING g_smg.smg01
    FETCH s150_cl INTO g_smg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_smg01_t = g_smg.smg01
    LET g_smg_o.*=g_smg.*
    LET g_smg.smgmodu=g_user                     #修改者
    LET g_smg.smgdate = g_today                  #修改日期
    CALL s150_show()                          # 顯示最新資料
    WHILE TRUE
        CALL s150_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_smg.*=g_smg_t.*
            CALL s150_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE smg_file SET smg_file.* = g_smg.*    # 更新DB
            WHERE smg01 = g_smg.smg01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","smg_file",g_smg.smg01,g_smg.smg02,SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE s150_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s150_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
	IF g_smg.smg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
	BEGIN WORK
	OPEN s150_cl USING g_smg.smg01
	FETCH s150_cl INTO g_smg.*
	IF SQLCA.sqlcode THEN
        CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)
        RETURN
     END IF
	CALL s150_show()
	IF cl_exp(0,0,g_smg.smgacti) THEN
        LET g_chr=g_smg.smgacti
        IF g_smg.smgacti='Y'
           THEN LET g_smg.smgacti='N'
           ELSE LET g_smg.smgacti='Y'
        END IF
        UPDATE smg_file
            SET smgacti=g_smg.smgacti,
               smgmodu=g_user, smgdate=g_today
            WHERE smg01=g_smg.smg01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","smg_file",g_smg.smg01,g_smg.smg02,SQLCA.sqlcode,"","",0) #No.FUN-660138
            LET g_smg.smgacti=g_chr
        END IF
        DISPLAY BY NAME g_smg.smgacti
    END IF
    CLOSE s150_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s150_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smg.smg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN s150_cl USING g_smg.smg01
    FETCH s150_cl INTO g_smg.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0) RETURN END IF
    CALL s150_show()
    IF cl_delete() THEN
        DELETE FROM smg_file WHERE smg01=g_smg.smg01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_smg.smg01,SQLCA.sqlcode,0)   #No.FUN-660138
           CALL cl_err3("del","smg_file",g_smg.smg01,"",SQLCA.sqlcode,"","",0) #No.FUN-660138
        ELSE
           CLEAR FORM
           INITIALIZE g_smg.* TO NULL
           OPEN s150_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE s150_cs
              CLOSE s150_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           FETCH s150_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE s150_cs
              CLOSE s150_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN s150_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL s150_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL s150_fetch('/')
           END IF
        END IF
    END IF
    CLOSE s150_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s150_copy()
   DEFINE l_smg           RECORD LIKE smg_file.*,
          l_oldno,l_newno LIKE smg_file.smg01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smg.smg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-580024
    CALL s150_set_entry('a')          #FUN-580024
    LET g_before_input_done = TRUE    #FUN-580024
    INPUT l_newno FROM smg01
        AFTER FIELD smg01
            IF l_newno IS NULL THEN
                NEXT FIELD smg01
            END IF
            SELECT count(*) INTO g_cnt FROM smg_file
                WHERE smg01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD smg01
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_smg.smg01
        RETURN
    END IF
    LET l_smg.* = g_smg.*
    LET l_smg.smg01  =l_newno   #資料鍵值
    LET l_smg.smguser=g_user    #資料所有者
    LET l_smg.smggrup=g_grup    #資料所有者所屬群
    LET l_smg.smgmodu=NULL      #資料修改日期
    LET l_smg.smgdate=g_today   #資料建立日期
    LET l_smg.smgacti='Y'       #有效資料
    LET l_smg.smgoriu = g_user      #No.FUN-980030 10/01/04
    LET l_smg.smgorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO smg_file VALUES (l_smg.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("ins","smg_file",l_smg.smg01,l_smg.smg02,SQLCA.sqlcode,"","",0) #No.FUN-660138
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_smg.smg01
        SELECT smg_file.* INTO g_smg.* FROM smg_file
                       WHERE smg01 = l_newno
        CALL s150_u()
        #SELECT smg_file.* INTO g_smg.* FROM smg_file  #FUN-C80046
        #               WHERE smg01 = l_oldno          #FUN-C80046
    END IF
    CALL s150_show()
END FUNCTION
 
FUNCTION s150_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("smg01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION s150_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
         l_n     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("smg01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION s150_out()
DEFINE l_cmd  LIKE type_file.chr1000           #No.FUN-7C0043---add--- 
#   DEFINE
#       l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#       l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_smg   RECORD LIKE smg_file.*,
#       l_za05          LIKE type_file.chr1000,               #  #No.FUN-690010 VARCHAR(40)
#       l_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
    #FUN-7C0043---BEGIN
    IF cl_null(g_wc) AND NOT cl_null(g_smg.smg01) THEN                          
       LET g_wc = " smg01 = '",g_smg.smg01,"'"                                  
    END IF                                                                      
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                
    LET l_cmd = 'p_query "asms150" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
    #FUN-7C0043---END
#   IF cl_null(g_wc) THEN
#      LET g_wc=" smg01='",g_smg.smg01,"'"
#   END IF
 
#   IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
#       CALL cl_err('','9057',0)
#       RETURN
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('asms150') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM smg_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE s150_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE s150_co                         # SCROLL CURSOR
#       CURSOR FOR s150_p1
 
#   START REPORT s150_rep TO l_name
 
#   FOREACH s150_co INTO l_smg.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT s150_rep(l_smg.*)
#   END FOREACH
 
#   FINISH REPORT s150_rep
 
#   CLOSE s150_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT s150_rep(sr)
#   DEFINE
#       l_trailer_sw   LIKE type_file.chr1,   #No.FUN-690010   VARCHAR(1),
#       sr RECORD LIKE smg_file.*,
#       l_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.smg01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.smgacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
#           PRINT COLUMN g_c[32],sr.smg01,
#                 COLUMN g_c[33],sr.smg03,
#                 COLUMN g_c[34],sr.smg02
 
#       ON LAST ROW
#           IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#              CALL cl_wcchp(g_wc,'smg01,smg02,smg03')
#                   RETURNING g_sql
#             PRINT g_dash[1,g_len]
 
#           #TQC-630166
#           {
#             IF g_sql[001,080] > ' ' THEN
#                     PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#             IF g_sql[071,140] > ' ' THEN
#                     PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#             IF g_sql[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#           }
#             CALL cl_prt_pos_wc(g_sql)
#           #END TQC-630166
 
#           END IF
#           PRINT g_dash[1,g_len] #No.TQC-5C0059
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
 
 

