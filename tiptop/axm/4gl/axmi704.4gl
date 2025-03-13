# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axmi704.4gl
# Descriptions...: 競爭廠商資料維護作業
# Date & Author..: 02/11/13 by Leagh
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530546 05/03/29 By Mandy 執行無效時, 出現(-217)的錯誤訊息.
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830152 08/04/10 By baofei  報表打印改為CR輸出
# Modify.........: No.TQC-980065 09/08/11 By lilingyu 無效資料不可刪除  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BA0107 11/10/19 By destiny oriu,orig不能查询
# Modify.........: No.TQC-BA0137 11/10/25 By destiny 栏位不能输入负数
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30099 12/04/09 by Sakura 查詢時廠商編號要可以開窗篩選

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofr   RECORD LIKE ofr_file.*,
    g_ofr_t RECORD LIKE ofr_file.*,
    g_ofr_o RECORD LIKE ofr_file.*,
    g_ofr01_t           LIKE ofr_file.ofr01,
     g_wc,g_sql         STRING,  #No.FUN-580092 HCN  
    l_cmd               LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE g_cmd        LIKE gbc_file.gbc05         #No.FUN-680137 VARCHAR(100)
DEFINE g_buf        LIKE ima_file.ima01         #No.FUN-680137 VARCHAR(40)
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE   g_before_input_done   STRING
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_ofr.* TO NULL
    INITIALIZE g_ofr_t.* TO NULL
    INITIALIZE g_ofr_o.* TO NULL
 
 
    LET g_forupd_sql = "SELECT * FROM ofr_file WHERE ofr01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i704_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW i704_w AT p_row,p_col
         WITH FORM "axm/42f/axmi704"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i704_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i704_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i704_cs()
    CLEAR FORM
   INITIALIZE g_ofr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ofr01,ofr02,ofr03,ofr031,ofr04,ofr05,ofr06,ofr07, 
        ofr13,ofr14,ofr08,ofr09,ofr10,ofr11,ofr12,
        ofr15,ofr151,ofr152,ofr16,ofr161,ofr162,ofr163,ofr164,
        ofruser,ofrgrup,ofrmodu,ofrdate,ofracti
        ,ofroriu,ofrorig  #TQC-BA0107

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
     #FUN-C30099---add---START
      ON ACTION CONTROLP
        CASE
         WHEN INFIELD(ofr01)                                                                                        
            CALL cl_init_qry_var()                                                                                                
            LET g_qryparam.state = 'c'                                                                                            
            LET g_qryparam.form ="q_ofr"   
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                    
            DISPLAY g_qryparam.multiret TO ofr01                                                                                  
            NEXT FIELD ofr01                 
        END CASE
     #FUN-C30099---end---START          
              
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ofruser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                          #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ofrgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ofrgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofruser', 'ofrgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ofr01 FROM ofr_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY ofr01"
    PREPARE i704_prepare FROM g_sql          # RUNTIME 編譯
    DECLARE i704_cs                        # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i704_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ofr_file WHERE ",g_wc CLIPPED
    PREPARE i704_precount FROM g_sql
    DECLARE i704_count CURSOR FOR i704_precount
END FUNCTION
 
FUNCTION i704_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i704_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i704_q()
            END IF
 
        ON ACTION next
           CALL i704_fetch('N')
 
        ON ACTION previous
           CALL i704_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i704_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i704_x()
            END IF
           #圖形顯示
           CALL cl_set_field_pic("","","","","",g_ofr.ofracti)
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i704_r()
            END IF
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i704_out()
            END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #EXIT MENU
           #圖形顯示
           CALL cl_set_field_pic("","","","","",g_ofr.ofracti)
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i704_fetch('/')
 
        ON ACTION first
           CALL i704_fetch('F')
 
        ON ACTION last
           CALL i704_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
            LET g_action_choice = "exit"
            CALL cl_on_idle()
            CONTINUE MENU
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_ofr.ofr01 IS NOT NULL THEN
                LET g_doc.column1 = "ofr01"
                LET g_doc.value1 = g_ofr.ofr01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i704_cs
END FUNCTION
 
 
 
FUNCTION i704_a()
DEFINE l_cmd     LIKE gbc_file.gbc05        #No.FUN-680137 VARCHAR(100)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                    # 清螢幕欄位內容
    INITIALIZE g_ofr.* LIKE ofr_file.*
    LET g_ofr01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ofr.ofracti = 'Y'
        LET g_ofr.ofruser = g_user
        LET g_ofr.ofroriu = g_user #FUN-980030
        LET g_ofr.ofrorig = g_grup #FUN-980030
        LET g_ofr.ofrgrup = g_grup
        LET g_ofr.ofrdate = g_today
        LET g_ofr_t.*=g_ofr.*
        CALL i704_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ofr.ofr01 IS NULL THEN               # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO ofr_file VALUES(g_ofr.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","ofr_file",g_ofr.ofr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
           SELECT ofr01 INTO g_ofr.ofr01 FROM ofr_file
            WHERE ofr01 = g_ofr.ofr01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i704_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
	l_chr		LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE  l_pmc01         LIKE pmc_file.pmc01           #FUN-C30099 add
DEFINE  l_pmcacti       LIKE pmc_file.pmc01           #FUN-C30099 add
DEFINE  l_pmc03         LIKE pmc_file.pmc03           #FUN-C30099 add
 
   INPUT BY NAME g_ofr.ofroriu,g_ofr.ofrorig,
        g_ofr.ofr01,g_ofr.ofr02,g_ofr.ofr03,g_ofr.ofr031,
        g_ofr.ofr04,g_ofr.ofr05,g_ofr.ofr06,g_ofr.ofr07,
        g_ofr.ofr13,g_ofr.ofr14,g_ofr.ofr08,g_ofr.ofr09,
        g_ofr.ofr10,g_ofr.ofr11,g_ofr.ofr12,
        g_ofr.ofr15,g_ofr.ofr151,g_ofr.ofr152,g_ofr.ofr16,
        g_ofr.ofr161,g_ofr.ofr162,g_ofr.ofr163,g_ofr.ofr164,
        g_ofr.ofruser,g_ofr.ofrgrup,g_ofr.ofrmodu,g_ofr.ofrdate,g_ofr.ofracti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i704_set_entry(p_cmd)
           CALL i704_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ofr01
          IF g_ofr.ofr01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ofr.ofr01 != g_ofr_t.ofr01) THEN
        #FUN-C30099---add---START
               SELECT pmc01,pmcacti INTO l_pmc01,l_pmcacti FROM pmc_file
                WHERE pmc01 = g_ofr.ofr01
               IF cl_null(l_pmc01) OR l_pmcacti != 'Y'THEN 
                  CALL cl_err('','axm-233',0)
                  NEXT FIELD ofr01                  
               END IF               
        #FUN-C30099---end---START
               SELECT COUNT(*) INTO l_n FROM ofr_file WHERE ofr01 = g_ofr.ofr01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_ofr.ofr01,-239,0)
                  LET g_ofr.ofr01 = g_ofr_t.ofr01
                  DISPLAY BY NAME g_ofr.ofr01
                  NEXT FIELD ofr01
              #FUN-C30099---add---START
               ELSE
                  LET g_ofr.ofr02 = NULL
                  DISPLAY BY NAME g_ofr.ofr02
                  SELECT pmc03 INTO l_pmc03 FROM pmc_file
                    WHERE pmc01 = g_ofr.ofr01
                  LET g_ofr.ofr02 = l_pmc03
                  DISPLAY BY NAME g_ofr.ofr02
              #FUN-C30099---end---START
               END IF
            END IF
          END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                          # 沿用所有欄位
      #      IF INFIELD(ofr01) THEN
      #          LET g_ofr.* = g_ofr_t.*
      #          CALL i704_show()
      #          NEXT FIELD ofr01
      #      END IF
      #MOD-650015 -end-
      #TQC-BA0137--begin
        AFTER FIELD ofr09
          IF NOT cl_null(g_ofr.ofr09) THEN
             IF g_ofr.ofr09<0 THEN
                CALL cl_err('','aec-020',1)
                NEXT FIELD ofr09
             END IF
          END IF
        AFTER FIELD ofr11
          IF NOT cl_null(g_ofr.ofr11) THEN
             IF g_ofr.ofr11<0 THEN
                CALL cl_err('','aec-020',1)
                NEXT FIELD ofr11
             END IF
          END IF
        AFTER FIELD ofr12
          IF NOT cl_null(g_ofr.ofr12) THEN
             IF g_ofr.ofr12<0 THEN
                CALL cl_err('','aec-020',1)
                NEXT FIELD ofr12
             END IF
          END IF
      #TQC-BA0137--end
        AFTER INPUT
           LET g_ofr.ofruser = s_get_data_owner("ofr_file") #FUN-C10039
           LET g_ofr.ofrgrup = s_get_data_group("ofr_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
       #FUN-C30099---add---START
        ON ACTION CONTROLP   
          CASE                                                                                                     
            WHEN INFIELD(ofr01)                                                                                          
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_ofr1"                                                                                         
               LET g_qryparam.default1 = g_ofr.ofr01                                                                           
               CALL cl_create_qry() RETURNING g_ofr.ofr01                                                                           
               DISPLAY BY NAME g_ofr.ofr01                                                                                                                                                                                         
               NEXT FIELD ofr01                                                                                                             
           END CASE         
       #FUN-C30099---end---START
 
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
# END IF
END FUNCTION
 
FUNCTION i704_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ofr.* TO NULL              #No.FUN-6A0020
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i704_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i704_count
    FETCH i704_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i704_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)
        INITIALIZE g_ofr.* TO NULL
    ELSE
        CALL i704_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i704_fetch(p_flofr)
    DEFINE
        p_flofr        LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1) 
 
    CASE p_flofr
        WHEN 'N' FETCH NEXT     i704_cs INTO g_ofr.ofr01
        WHEN 'P' FETCH PREVIOUS i704_cs INTO g_ofr.ofr01
        WHEN 'F' FETCH FIRST    i704_cs INTO g_ofr.ofr01
        WHEN 'L' FETCH LAST     i704_cs INTO g_ofr.ofr01
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
            FETCH ABSOLUTE g_jump i704_cs INTO g_ofr.ofr01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)
        INITIALIZE g_ofr.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flofr
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofr.* FROM ofr_file             # 重讀DB,因TEMP有不被更新特性
       WHERE ofr01 = g_ofr.ofr01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ofr_file",g_ofr.ofr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofr.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_ofr.ofruser      #FUN-4C0057 add
       LET g_data_group = g_ofr.ofrgrup      #FUN-4C0057 add
       CALL i704_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i704_show()
    LET g_ofr_t.* = g_ofr.*
    DISPLAY BY NAME g_ofr.ofroriu,g_ofr.ofrorig,
        g_ofr.ofr01,g_ofr.ofr02,g_ofr.ofr03,g_ofr.ofr031,
        g_ofr.ofr04,g_ofr.ofr05,g_ofr.ofr06,g_ofr.ofr07,
        g_ofr.ofr08,g_ofr.ofr09,
        g_ofr.ofr10,g_ofr.ofr11,g_ofr.ofr12,g_ofr.ofr13,g_ofr.ofr14,
        g_ofr.ofr15,g_ofr.ofr151,g_ofr.ofr152,
        g_ofr.ofr16,g_ofr.ofr161,g_ofr.ofr162,g_ofr.ofr163,g_ofr.ofr164,
        g_ofr.ofruser,
        g_ofr.ofrgrup,g_ofr.ofrmodu,g_ofr.ofrdate,g_ofr.ofracti
 
    #圖形顯示
    CALL cl_set_field_pic("","","","","",g_ofr.ofracti)
display "g_ofr.ofracti=",g_ofr.ofracti
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i704_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ofr.ofr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ofr.* FROM ofr_file WHERE ofr01=g_ofr.ofr01
    IF g_ofr.ofracti ='N' THEN     #檢查資料是否為無效
        CALL cl_err(g_ofr.ofr01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofr01_t = g_ofr.ofr01
    LET g_ofr_o.*=g_ofr.*
    BEGIN WORK
 
    OPEN i704_cl USING g_ofr.ofr01
    IF STATUS THEN
       CALL cl_err("OPEN i704_cl:", STATUS, 1)
       CLOSE i704_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i704_cl INTO g_ofr.*                # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofr.ofrmodu=g_user                     #修改者
    LET g_ofr.ofrdate = g_today                  #修改日期
    CALL i704_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ofr_t.*=g_ofr.*
        CALL i704_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofr.*=g_ofr_t.*
            CALL i704_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofr_file SET ofr_file.* = g_ofr.*    # 更新DB
            WHERE ofr01 = g_ofr_t.ofr01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofr_file",g_ofr01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i704_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i704_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofr.ofr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i704_cl USING g_ofr.ofr01
    IF STATUS THEN
       CALL cl_err("OPEN i704_cl:", STATUS, 1)
       CLOSE i704_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i704_cl INTO g_ofr.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i704_show()
    IF cl_exp(15,12,g_ofr.ofracti) THEN
        LET g_chr=g_ofr.ofracti
        IF g_ofr.ofracti='Y' THEN
            LET g_ofr.ofracti='N'
        ELSE
            LET g_ofr.ofracti='Y'
        END IF
        UPDATE ofr_file
            SET ofracti=g_ofr.ofracti,
                 ofrmodu=g_user,  #MOD-530546
                ofrdate=g_today
            WHERE ofr01=g_ofr.ofr01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("upd","ofr_file",g_ofr.ofr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
           LET g_ofr.ofracti=g_chr
        END IF
        DISPLAY BY NAME g_ofr.ofracti
    END IF
    CLOSE i704_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i704_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofr.ofr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-980065 --BEGIN--
    IF g_ofr.ofracti = 'N' THEN
      CALL cl_err('','abm-033',0)
      RETURN
    END IF 
#TQC-980065 --END--
    
    BEGIN WORK
 
    OPEN i704_cl USING g_ofr.ofr01
    IF STATUS THEN
       CALL cl_err("OPEN i704_cl:", STATUS, 1)
       CLOSE i704_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i704_cl INTO g_ofr.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i704_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofr01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofr.ofr01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ofr_file WHERE ofr01 = g_ofr.ofr01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_ofr.ofr01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","ofr_file",g_ofr.ofr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       INITIALIZE g_ofr.* TO NULL
       OPEN i704_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i704_cs
          CLOSE i704_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i704_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i704_cs
          CLOSE i704_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i704_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i704_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i704_fetch('/')
       END IF
    END IF
    CLOSE i704_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i704_out()
    DEFINE
        l_ofr           RECORD LIKE ofr_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmi704'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM ofr_file ",
              " WHERE ",g_wc CLIPPED
#No.FUN-830152---Begin
#    PREPARE i704_p1 FROM g_sql                # RUNTIME
#    DECLARE i704_co                           # CURSOR
#        CURSOR FOR i704_p1
 
#    CALL cl_outnam('axmi704') RETURNING l_name
#    START REPORT i704_rep TO l_name
#    FOREACH i704_co INTO l_ofr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i704_rep(l_ofr.*)
#    END FOREACH
 
#    FINISH REPORT i704_rep
     CALL cl_prt_cs1('axmi704','axmi704',g_sql,'')
#    CLOSE i704_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin
#REPORT i704_rep(sr)
#   DEFINE
#       l_trailer_sw   LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1) 
#       sr              RECORD LIKE ofr_file.*,
#       i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin  PAGE LENGTH g_page_line
 
#   ORDER BY sr.ofr01
 
#   FORMAT
#       PAGE HEADER
#          PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#          PRINT ' '
#          PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#          PRINT ' '
#          PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#          PRINT g_dash[1,g_len]
#          LET l_trailer_sw = 'n'
#          LET i = 0
 
#       ON EVERY ROW
#          IF i > 0 AND i < 3 THEN
#             PRINT '---------------------------------------------------------',
#                   '-----------------------'
#          END IF
#          LET i = i+1
 
#          PRINT g_x[11] CLIPPED,COLUMN 11,sr.ofr01 CLIPPED,
#                COLUMN 23,g_x[12] CLIPPED,COLUMN 33,sr.ofr02 CLIPPED,
#                COLUMN 49,g_x[13] CLIPPED,COLUMN 59,sr.ofr08 CLIPPED
#          PRINT g_x[14] CLIPPED,COLUMN 11,sr.ofr03 CLIPPED,
#                COLUMN 49,g_x[15] CLIPPED,COLUMN 59,sr.ofr09 CLIPPED
#          PRINT COLUMN 11,sr.ofr031 CLIPPED,
#                COLUMN 49,g_x[16] CLIPPED,COLUMN 59,sr.ofr10 CLIPPED
#          PRINT g_x[17] CLIPPED,COLUMN 11,sr.ofr04 CLIPPED,
#                COLUMN 49,g_x[18] CLIPPED,COLUMN 59,sr.ofr11 CLIPPED
#          PRINT COLUMN 11,sr.ofr05 CLIPPED,
#                COLUMN 49,g_x[19] CLIPPED,COLUMN 59,sr.ofr12 CLIPPED
#          PRINT COLUMN 11,sr.ofr06 CLIPPED,
#                COLUMN 53,g_x[20] CLIPPED,COLUMN 59,sr.ofr13 CLIPPED
#          PRINT COLUMN 11,sr.ofr07 CLIPPED,
#                COLUMN 53,g_x[21] CLIPPED,COLUMN 59,sr.ofr14 CLIPPED
#          PRINT g_x[22] CLIPPED,COLUMN 11,sr.ofr15 CLIPPED
#          PRINT COLUMN 11,sr.ofr151 CLIPPED
#          PRINT COLUMN 11,sr.ofr152 CLIPPED
#          PRINT g_x[23] CLIPPED,COLUMN 11,sr.ofr16 CLIPPED
#          PRINT COLUMN 11,sr.ofr161 CLIPPED
#          PRINT COLUMN 11,sr.ofr162 CLIPPED
#          PRINT COLUMN 11,sr.ofr163 CLIPPED
#          PRINT COLUMN 11,sr.ofr164 CLIPPED
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],COLUMN 41,g_x[5] CLIPPED,
#                 COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'y'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'n' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],COLUMN 41,g_x[5] CLIPPED,
#                     COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-830152---End
FUNCTION i704_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofr01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i704_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofr01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

