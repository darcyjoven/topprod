# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimt900.4gl
# Descriptions...: 盤點資料維護作業
# Date & Author..: 96/08/13 By Melody
# Modify.........: NO.MOD-420449 05/07/12 BY Yiting key可更改
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A30016 10/03/05 By destiny 增加cl_delete訊息
# Modify.........: No:FUN-BB0086 11/12/12 By tanxc 增加數量欄位小數取位 
# Modify.........: No.TQC-CB0083 12/11/26 By qirl 增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_pia             RECORD LIKE pia_file.*,
     g_pia_t           RECORD LIKE pia_file.*,
     g_pia_o           RECORD LIKE pia_file.*,
     g_pia01_t         LIKE pia_file.pia01,
     g_wc,g_sql        string                  #No.FUN-580092 HCN
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5    #MOD-420449         #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8               #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    INITIALIZE g_pia.* TO NULL
    INITIALIZE g_pia_t.* TO NULL
    INITIALIZE g_pia_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM pia_file WHERE pia01 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
       LET p_row = 3 LET p_col = 26
 
    OPEN WINDOW t900_w AT p_row,p_col
        WITH FORM "aim/42f/aimt900" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
#    CALL t900_q('q')
 
    WHILE TRUE
      LET g_action_choice=""
    CALL t900_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t900_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION t900_cs(p_code)
 DEFINE  p_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    CLEAR FORM
    INITIALIZE g_pia.* TO NULL    #FUN-640213 add
    CONSTRUCT BY NAME g_wc ON pia01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#----TQC-CB0083---ADD---STAR--
        ON ACTION controlp
           CASE
              WHEN INFIELD(pia01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_pia01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia01
                 NEXT FIELD pia01
              WHEN INFIELD(pia02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_pia02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia02
                 NEXT FIELD pia02
              WHEN INFIELD(pia03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_pia03"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia03
                 NEXT FIELD pia03
              WHEN INFIELD(pia04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_pia04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia04
                 NEXT FIELD pia04
              WHEN INFIELD(pia05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_pia05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia05
                 NEXT FIELD pia05
              OTHERWISE EXIT CASE
            END CASE
#----TQC-CB0083---ADD---end--
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    LET g_sql="SELECT pia01 FROM pia_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, 
              " ORDER BY pia01"
    PREPARE t900_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t900_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t900_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pia_file WHERE ",g_wc CLIPPED
    PREPARE t900_precount FROM g_sql
    DECLARE t900_count CURSOR FOR t900_precount
END FUNCTION
 
FUNCTION t900_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t900_q('Q')
            END IF
        ON ACTION next 
            CALL t900_fetch('N') 
        ON ACTION previous 
            CALL t900_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t900_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t900_d()
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
            CALL t900_fetch('/')
        ON ACTION first
            CALL t900_fetch('F')
        ON ACTION last
            CALL t900_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-680046-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_pia.pia01 IS NOT NULL THEN
                 LET g_doc.column1 = "pia01"
                 LET g_doc.value1 = g_pia.pia01
                 CALL cl_doc()
              END IF
          END IF
       #No.FUN-680046-------add--------end----    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t900_cs
END FUNCTION
 
 
FUNCTION t900_q(p_code)
 DEFINE  p_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t900_cs(p_code)                         # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN t900_count
    FETCH t900_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t900_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        INITIALIZE g_pia.* TO NULL
    ELSE
        CALL t900_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t900_fetch(p_flpia)
    DEFINE
        p_flpia          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flpia
        WHEN 'N' FETCH NEXT     t900_cs INTO g_pia.pia01
        WHEN 'P' FETCH PREVIOUS t900_cs INTO g_pia.pia01
        WHEN 'F' FETCH FIRST    t900_cs INTO g_pia.pia01
        WHEN 'L' FETCH LAST     t900_cs INTO g_pia.pia01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t900_cs INTO g_pia.pia01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        INITIALIZE g_pia.* TO NULL  #TQC-6B0105
              #TQC-6B0105
        RETURN
    ELSE
       CASE p_flpia
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_pia.* FROM pia_file    # 重讀DB,因TEMP有不被更新特性
       WHERE pia01 = g_pia.pia01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
 
        CALL t900_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t900_show()
    DEFINE l_ima02 LIKE ima_file.ima02,
           l_gen02 LIKE gen_file.gen02 
 
    LET g_pia_t.* = g_pia.*
    DISPLAY BY NAME g_pia.pia01,g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05,
                    g_pia.pia06,g_pia.pia09,g_pia.pia07,g_pia.pia30,
                    g_pia.pia32,g_pia.pia31 
    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=g_pia.pia02
    IF STATUS=100 THEN LET l_ima02='' END IF
    DISPLAY l_ima02 TO FORMONLY.ima02 
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_pia.pia31
    IF STATUS=100 THEN LET l_gen02='' END IF
    DISPLAY l_gen02 TO FORMONLY.gen02 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t900_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
        l_cnt           LIKE type_file.num10,   #No.FUN-690026 INTEGER
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_pia09         LIKE pia_file.pia09     #No.FUN-BB0086 
 
    INPUT BY NAME
         g_pia.pia01,  #MOD-420449
        g_pia.pia30,g_pia.pia32,g_pia.pia31
        WITHOUT DEFAULTS  
 
        AFTER FIELD pia30
           #No.FUN-BB0086--add--start--
           IF NOT cl_null(g_pia.pia30) THEN
              IF cl_null(g_pia_t.pia30) OR g_pia_t.pia30 != g_pia.pia30 THEN
                 SELECT pia09 INTO l_pia09 FROM pia_file WHERE pia01 = g_pia.pia01
                 LET g_pia.pia30 = s_digqty(g_pia.pia30,l_pia09)
                 DISPLAY BY NAME g_pia.pia30
              END IF
           END IF
           #No.FUN-BB0086--add--end--
            IF g_pia.pia30<=0 THEN
                NEXT FIELD pia30
            END IF
 
 
        AFTER FIELD pia31
            IF g_pia.pia31 IS NOT NULL AND g_pia.pia31 != ' ' THEN
               SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE g_pia.pia31=gen01
               IF l_cnt<=0 THEN
                NEXT FIELD pia31
               END IF
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_pia.pia30 IS NULL THEN NEXT FIELD pia30 END IF
 
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
 
FUNCTION t900_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pia.pia01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN t900_cl USING g_pia.pia01
    IF STATUS THEN
       CALL cl_err("OPEN t900_cl:", STATUS, 1)
       CLOSE t900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t900_cl INTO g_pia.*               #對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_pia01_t = g_pia.pia01
    LET g_pia_o.*=g_pia.*   
    LET g_pia.pia32=g_today
    CALL t900_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t900_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pia.*=g_pia_t.*
            CALL t900_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pia_file SET pia_file.* = g_pia.*    # 更新DB
            WHERE pia01=g_pia01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","pia_file",g_pia_t.pia01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t900_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t900_d()
     DEFINE g_wc1   string,  #No.FUN-580092 HCN
            g_sql1  string   #No.FUN-580092 HCN
    CLOSE WINDOW t900_w1
    IF s_shut(0) THEN RETURN END IF
    LET p_row = 5 LET p_col = 10
    OPEN WINDOW t900_w1 AT p_row,p_col
        WITH FORM "aim/42f/aimt9001" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt9001")
 
    CONSTRUCT BY NAME g_wc1 ON pia01
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    #No.TQC-A30016
    IF NOT cl_delete() THEN
       LET g_wc1=NULL
       CLOSE WINDOW t900_w1
       RETURN 
    END IF       
    #No.TQC-A30016
    LET g_sql1="DELETE FROM pia_file WHERE ",g_wc1 CLIPPED  
    PREPARE t900_prepare1 FROM g_sql1               # RUNTIME 編譯
    IF SQLCA.sqlcode THEN RETURN END IF
    EXECUTE t900_prepare1
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL cl_err('','aim-389',0)
    END IF 
    CLOSE WINDOW t900_w1
END FUNCTION
 
 #MOD-420449
FUNCTION t900_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("pia01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t900_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("pia01",FALSE)
   END IF
END FUNCTION
#--end
 
