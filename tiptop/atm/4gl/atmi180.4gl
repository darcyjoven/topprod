# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
#
# Pattern name...: atmi180.4gl
# Descriptions...: 車輛保養維修記錄維護作業
# Date & Author..: 03/12/1 By HAWK
# Modify.........: No.MOD-4A0328 04/10/27 By Carrier 
# Modify.........: No.MOD-4B0067 04/11/16 By DAY    將變數用Like方式定義,報表拉成一行 
# Modify.........: No.FUN-520024 05/02/24 報表轉XML By wujie
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: NO.FUN-660104 06/06/16 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/18 By mike 報表格式修改為p_query
# Modify.........: No.TQC-8C0077 08/12/29 By clover cl_setup模組修改到 ATM
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_obx               RECORD LIKE obx_file.*,
    g_obx_t             RECORD LIKE obx_file.*,
    g_obx01_t           LIKE obx_file.obx01,
    g_obx02_t           LIKE obx_file.obx02,
    g_wc,g_sql          STRING  #No.FUN-580092 HCN
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120
DEFINE   g_row_count    LIKE type_file.num10                                         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10           #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10                                         #No.FUN-680120 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5            #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #IF (NOT cl_setup("AXD")) THEN
    IF (NOT cl_setup("ATM")) THEN     #TQC-8C0077 
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    INITIALIZE g_obx.* TO NULL
    INITIALIZE g_obx_t.* TO NULL
    LET g_forupd_sql = "SELECT * FROM obx_file WHERE obx01 = ? AND obx02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i180_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
    OPEN WINDOW atmi180_w WITH FORM "atm/42f/atmi180"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
--##                                                                            
    CALL g_x.clear()                                                            
--##   
 
    # 2004/02/23 hjwang: 單檔要做locale的範例
#    WHILE TRUE
       LET g_action_choice = ""
       CALL i180_menu()
#       IF g_action_choice="exit" THEN EXIT WHILE END IF
#    END WHILE
 
    CLOSE WINDOW atmi180_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
 
FUNCTION i180_curs()
    CLEAR FORM
#   CALL g_obx.clear()        
 
   INITIALIZE g_obx.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
 #MOD-4A0328  --begin
        obx01,obx02,obx03,obx04,obx05,obx08,obx11
 #MOD-4A0328  --end   
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(obx01)
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_obw01"                               
                   LET g_qryparam.state = "c"                                   
                   LET g_qryparam.default1 = g_obx.obx01                  
                   CALL cl_create_qry() RETURNING g_qryparam.multiret           
                   DISPLAY g_qryparam.multiret TO obx01 
                   NEXT FIELD obx01
              WHEN INFIELD(obx04)
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_obu"                               
                   LET g_qryparam.state = "c"                                   
                   LET g_qryparam.default1 = g_obx.obx04                  
                   CALL cl_create_qry() RETURNING g_qryparam.multiret           
                   DISPLAY g_qryparam.multiret TO obx04 
                   NEXT FIELD obx04
              WHEN INFIELD(obx11)
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_gen"                               
                   LET g_qryparam.state = "c"                                   
                   LET g_qryparam.default1 = g_obx.obx11                  
                   CALL cl_create_qry() RETURNING g_qryparam.multiret           
                   DISPLAY g_qryparam.multiret TO obx11 
                   NEXT FIELD obx11
 
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
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select() 
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    LET g_sql="SELECT obx01,obx02 FROM obx_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY obx01,obx02"
    PREPARE i180_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i180_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i180_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM obx_file WHERE ",g_wc CLIPPED
    PREPARE i180_precount FROM g_sql
    DECLARE i180_count CURSOR FOR i180_precount
END FUNCTION
 
 
FUNCTION i180_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680120
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION insert 
            LET g_action_choice="insert" 
            IF cl_chk_act_auth() THEN
                 CALL i180_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query" 
            IF cl_chk_act_auth() THEN
                 CALL i180_q()
            END IF
        ON ACTION next 
            CALL i180_fetch('N')
        ON ACTION previous 
            CALL i180_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i180_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i180_r()
            END IF
       ON ACTION reproduce 
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i180_copy()
            END IF
       ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth() 
                 #THEN CALL i180_out()                                     #No.FUN-780056
                 THEN                                                      #No.FUN-780056
                 IF cl_null(g_wc) THEN LET g_wc='1=1' END IF               #No.FUN-780056
                 LET l_cmd = 'p_query "atmi180" "',g_wc CLIPPED,'"'        #No.FUN-780056
                 CALL cl_cmdrun(l_cmd)                                     #No.FUN-780056
            END IF
       ON ACTION help 
           CALL cl_show_help()
       ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
#        ON ACTION cancel
#            LET g_action_choice = "exit"
#            EXIT MENU
       ON ACTION jump
           CALL i180_fetch('/')
       ON ACTION first
           CALL i180_fetch('F')
       ON ACTION last
           CALL i180_fetch('L')
       ON ACTION controlg
           CALL cl_cmdask()
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT MENU
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       #No.FUN-6B0043-------add--------str----
       ON ACTION related_document             #相關文件"                        
        LET g_action_choice="related_document"           
           IF cl_chk_act_auth() THEN                     
              IF g_obx.obx01 IS NOT NULL THEN
                 LET g_doc.column1 = "obx01"
                 LET g_doc.column2 = "obx02"
                 LET g_doc.value1 = g_obx.obx01
                 LET g_doc.value2 = g_obx.obx02
             CALL cl_doc()                            
              END IF                                        
           END IF                                           
        #No.FUN-6B0043-------add--------end----
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
    CLOSE i180_cs
END FUNCTION
 
FUNCTION i180_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
#   CALL g_obx.clear()   
 
    INITIALIZE g_obx.* LIKE obx_file.*
    LET g_obx01_t = NULL
    LET g_obx02_t = NULL
    LET g_obx.obx03=g_today
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i180_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_obx.obx01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO obx_file VALUES(g_obx.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("ins","obx_file",g_obx.obx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        ELSE
            LET g_obx_t.* = g_obx.*                # 保存上筆資料
            SELECT obx01 INTO g_obx.obx01 FROM obx_file
             WHERE obx01 = g_obx.obx01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i180_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
        l_input         LIKE type_file.chr1,             #No.FUN-680120
         l_obw26         LIKE obw_file.obw26,  #MOD-4A0328
        l_n             LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
 #MOD-4A0328  --begin
    INPUT BY NAME   g_obx.obx01,g_obx.obx02,g_obx.obx03,g_obx.obx04,
                    g_obx.obx05,g_obx.obx08,g_obx.obx11
                    WITHOUT DEFAULTS
 #MOD-4A0328  --end    
 
        BEFORE INPUT
            LET l_input='N'
            LET g_before_input_done = FALSE
            CALL i180_set_entry(p_cmd)
            CALL i180_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD obx01
            IF NOT cl_null(g_obx.obx01) THEN
               IF p_cmd = 'a' OR 
                 (p_cmd = 'u' AND g_obx.obx01 != g_obx_t.obx01) THEN
                  CALL i180_obx01()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_obx.obx01,g_errno,0)
                     LET g_obx.obx01 = g_obx01_t
                     DISPLAY BY NAME g_obx.obx01 
                     NEXT FIELD obx01
                  END IF
               END IF
            END IF
 
        BEFORE FIELD obx02
            IF cl_null(g_obx.obx02) THEN
               SELECT MAX(obx02)+1 INTO g_obx.obx02 FROM obx_file
                WHERE obx01 = g_obx.obx01
               IF g_obx.obx02 IS NULL THEN
                  LET g_obx.obx02 = 1 
               END IF
               DISPLAY BY NAME g_obx.obx02
            END IF
 
        AFTER FIELD obx02
            IF NOT cl_null(g_obx.obx02) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND (g_obx.obx01 != g_obx_t.obx01 OR 
                                    g_obx.obx02 != g_obx_t.obx02)) THEN
                  SELECT COUNT(*) INTO l_n FROM obx_file
                  WHERE obx01 = g_obx.obx01 AND obx02 = g_obx.obx02
                  IF l_n>0 THEN
                     CALL cl_err(g_obx.obx02,-239,0)
                     LET g_obx.obx01 = g_obx_t.obx01
                     LET g_obx.obx02 = g_obx_t.obx02
                     DISPLAY BY NAME g_obx.obx01 #ATTRIBUTE(YELLOW)
                     DISPLAY BY NAME g_obx.obx02 #ATTRIBUTE(YELLOW)
                     NEXT FIELD obx02
                  END IF
               END IF
           END IF
 
       AFTER FIELD obx04
           IF NOT cl_null(g_obx.obx04) THEN
              IF p_cmd = 'a' OR 
                (p_cmd = 'u' AND g_obx.obx04 != g_obx_t.obx04) THEN
                 CALL i180_obx04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_obx.obx04,g_errno,0)
                    NEXT FIELD obx04
                 END IF
               END IF
            END IF
 
       AFTER FIELD obx11
           IF NOT cl_null(g_obx.obx11) THEN
              IF p_cmd = 'a' OR 
                (p_cmd = 'u' AND g_obx.obx11 != g_obx_t.obx11) THEN
                 CALL i180_obx11('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_obx.obx11,g_errno,0)
                    NEXT FIELD obx11
                 END IF
              END IF
           END IF
 
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(obx01)
               # CALL q_obw01(10,10,g_obx.obx01) RETURNING g_obx.obx01
                 CALL cl_init_qry_var()                                       
                 LET g_qryparam.form ="q_obw01"                               
                 LET g_qryparam.default1 = g_obx.obx01                  
                 CALL cl_create_qry() RETURNING g_obx.obx01             
 
                 DISPLAY BY NAME g_obx.obx01
                 NEXT FIELD obx01
               WHEN INFIELD(obx04)
               # CALL q_obu(10,3,g_obx.obx04) RETURNING g_obx.obx04
                 CALL cl_init_qry_var()                                       
                 LET g_qryparam.form ="q_obu"                               
                 LET g_qryparam.default1 = g_obx.obx04                  
                 CALL cl_create_qry() RETURNING g_obx.obx04             
                 DISPLAY BY NAME g_obx.obx04
                 NEXT FIELD obx04
               WHEN INFIELD(obx11)
               # CALL q_gen(10,3,g_obx.obx11) RETURNING g_obx.obx11
                 CALL cl_init_qry_var()                                       
                 LET g_qryparam.form ="q_gen"                               
                 LET g_qryparam.default1 = g_obx.obx11                  
                 CALL cl_create_qry() RETURNING g_obx.obx11             
                 DISPLAY BY NAME g_obx.obx11
                 NEXT FIELD obx11
               OTHERWISE
                 EXIT CASE
            END CASE
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
 #MOD-4A0328  --begin
    SELECT obw26 INTO l_obw26 FROM obw_file
     WHERE obw01=g_obx.obx01
    IF cl_null(l_obw26) OR l_obw26 < g_obx.obx03 THEN 
       UPDATE obw_file SET obw26 = g_obx.obx03 WHERE obw01=g_obx.obx01
       IF SQLCA.sqlcode THEN
#         CALL cl_err('update obw26',SQLCA.sqlcode,0)  #No.FUN-660104
          CALL cl_err3("upd","obw_file",g_obx.obx01,"",SQLCA.sqlcode,
                       "","update obw26",1)  #No.FUN-660104
       END IF
    END IF
 #MOD-4A0328  --end   
 
END FUNCTION
 
FUNCTION i180_obx01()
  DEFINE l_obw01   LIKE obw_file.obw01,
         l_obwacti LIKE obw_file.obwacti
 
     LET g_errno = ' '
     SELECT obw01,obwacti INTO l_obw01,l_obwacti
       FROM obw_file 
      WHERE obw01=g_obx.obx01
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='axd-010'
         WHEN l_obwacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
END FUNCTION
 
FUNCTION i180_obx04(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
         l_obu02   LIKE obu_file.obu02,
         l_obuacti LIKE obu_file.obuacti
 
     LET g_errno = ' '
     SELECT obu02,obuacti INTO l_obu02,l_obuacti
       FROM obu_file 
      WHERE obu01=g_obx.obx04
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='axd-011'
                                 LET l_obu02=NULL
         WHEN l_obuacti = 'N'    LET g_errno = '9028'
         OTHERWISE               LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
     IF p_cmd='d' OR g_errno=' ' THEN
        DISPLAY l_obu02 TO FORMONLY.obu02 
     END IF
END FUNCTION
 
FUNCTION i180_obx11(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
         l_gen02   LIKE gen_file.gen02,
         l_genacti LIKE gen_file.genacti
 
     LET g_errno = ' '
     SELECT gen02,genacti INTO l_gen02,l_genacti
       FROM gen_file 
      WHERE gen01=g_obx.obx11
 
     CASE
         WHEN SQLCA.sqlcode =100 LET g_errno='mfg3096'
         WHEN l_genacti='N'      LET g_errno = '9028'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd='d' OR g_errno=' ' THEN
        DISPLAY l_gen02 TO FORMONLY.gen02 
     END IF
 
END FUNCTION
 
FUNCTION i180_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obx.* TO NULL                #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i180_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i180_cs                              # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)
        INITIALIZE g_obx.* TO NULL
    ELSE
        OPEN i180_count
        FETCH i180_COUNT INTO g_row_count                                      
        DISPLAY g_row_count TO FORMONLY.cnt 
        CALL i180_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i180_fetch(p_flzx)
    DEFINE
        p_flzx          LIKE type_file.chr1,         #No.FUN-680120
        l_abso          LIKE type_file.num10         #No.FUN-680120 INTEGER
 
    CASE p_flzx
        WHEN 'N' FETCH NEXT     i180_cs INTO g_obx.obx01,g_obx.obx02
        WHEN 'P' FETCH PREVIOUS i180_cs INTO g_obx.obx01,g_obx.obx02
        WHEN 'F' FETCH FIRST    i180_cs INTO g_obx.obx01,g_obx.obx02
        WHEN 'L' FETCH LAST     i180_cs INTO g_obx.obx01,g_obx.obx02
        WHEN '/'
            IF (NOT g_no_ask) THEN   #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
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
            FETCH ABSOLUTE g_jump i180_cs INTO g_obx.obx01,g_obx.obx02
            LET g_no_ask = FALSE    #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)
        INITIALIZE g_obx.* TO NULL  #TQC-6B0105
        RETURN
    ELSE                                                                        
       CASE p_flzx                                                              
          WHEN 'F' LET g_curs_index = 1                                        
          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
          WHEN 'L' LET g_curs_index = g_row_count                             
          WHEN '/' LET g_curs_index = g_jump                                   
       END CASE                                                                 
       CALL cl_navigator_setting( g_curs_index, g_row_count ) 
    END IF
 
    SELECT * INTO g_obx.* FROM obx_file            # 重讀DB,因TEMP有不被更新特性
       WHERE obx01 = g_obx.obx01 AND obx02 = g_obx.obx02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("sel","obx_file",g_obx.obx01,"",SQLCA.sqlcode,
                     "","",1)  #No.FUN-660104
    ELSE
        CALL i180_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i180_show()
#   DEFINE desc_temp LIKE apm_file.apm08    #No.FUN-680120 VARCHAR(10) # TQC-6A0079
    LET g_obx_t.* = g_obx.*
 #MOD-4A0328  --begin
    DISPLAY BY NAME g_obx.obx01,g_obx.obx02,g_obx.obx03,g_obx.obx04,
                    g_obx.obx05,g_obx.obx08,g_obx.obx11
 #MOD-4A0328  --end    
    CALL i180_obx04('d')
    CALL i180_obx11('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i180_u()
DEFINE l_n      LIKE type_file.num5          #No.FUN-680120 SMALLINT
    IF g_obx.obx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obx01_t = g_obx.obx01
    LET g_obx02_t = g_obx.obx02
    LET g_obx_t.*=g_obx.*
    BEGIN WORK
    OPEN i180_cl USING g_obx.obx01,g_obx.obx02
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_obx.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i180_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i180_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
UPDATE obx_file SET obx_file.* = g_obx.*    # 更新DB
        WHERE obx01 = g_obx01_t AND obx02 = g_obx02_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)  #No.FUN-660104
           CALL cl_err3("upd","obx_file",g_obx.obx01,"",SQLCA.sqlcode,
                        "","",1)  #No.FUN-660104
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i180_cl
    COMMIT WORK 
END FUNCTION
 
FUNCTION i180_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF g_obx.obx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i180_cl USING g_obx.obx01,g_obx.obx02
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_obx.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i180_show()
    IF cl_delh(0,0) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "obx02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obx.obx01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_obx.obx02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM obx_file WHERE obx01 = g_obx.obx01 AND obx02 = g_obx.obx02
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_obx.obx01,SQLCA.sqlcode,0)  #No.FUN-660104
          CALL cl_err3("del","obx_file",g_obx.obx01,"",SQLCA.sqlcode,
                       "","",1)  #No.FUN-660104
       ELSE
          CLEAR FORM
--mi                                                                            
         OPEN i180_count                                                        
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i180_cs
            CLOSE i180_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i180_count INTO g_row_count                                      
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i180_cs
            CLOSE i180_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt                                    
         OPEN i180_cs                                                           
         IF g_curs_index = g_row_count + 1 THEN                                 
            LET g_jump = g_row_count                                            
            CALL i180_fetch('L')                                                
         ELSE                                                                   
            LET g_jump = g_curs_index                                           
            LET g_no_ask = TRUE     #No.FUN-6A0072                                           
            CALL i180_fetch('/')                                                
         END IF                                                                 
--#    
       END IF
    END IF
    CLOSE i180_cl
    COMMIT WORK 
END FUNCTION
 
FUNCTION i180_copy()
    DEFINE l_n                LIKE type_file.num5,    #No.FUN-680120 SMALLINT
           l_newno1,l_oldno1  LIKE obx_file.obx01,
           l_newno2,l_oldno2  LIKE obx_file.obx02,
           p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           l_input   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF g_obx.obx01 IS NULL THEN CALL cl_err('',-400,0) RETURN  END IF
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1 #ATTRIBUTE(RED)    #No.FUN-940135
    LET l_oldno1 = g_obx.obx01
    LET l_oldno2 = g_obx.obx02
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i180_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1,l_newno2 FROM obx01,obx02
          AFTER FIELD obx01
              IF l_newno1 IS NULL THEN
                 NEXT FIELD obx01
              END IF
              IF l_newno1 IS NOT NULL THEN
                 CALL i180_obx01()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(l_newno1,g_errno,0)
                    NEXT FIELD obx01
                 END IF
              END IF
 
          AFTER FIELD obx02
              IF l_newno2 IS NULL THEN
                 NEXT FIELD obx02
              END IF
              IF l_newno2 IS NOT NULL THEN
                 SELECT COUNT(*) INTO l_n FROM obx_file
                  WHERE obx01 = l_newno1 AND obx02 = l_newno2
                 IF l_n>0 THEN
                    CALL cl_err(l_newno2,-239,0)
                    NEXT FIELD obx02
                 END IF
              END IF
 
          ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(obx01)
                 #  CALL q_obw01(10,10,l_newno1) RETURNING l_newno1
                    CALL cl_init_qry_var()                        
                    LET g_qryparam.form ="q_obw01"                 
                    LET g_qryparam.default1 = l_newno1
                    CALL cl_create_qry() RETURNING l_newno1
 
                    DISPLAY l_newno1 TO obx01
                    NEXT FIELD obx01
                 OTHERWISE
                    EXIT CASE
              END CASE
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
    IF INT_FLAG THEN LET INT_FLAG = 0  RETURN END IF    
 
    DROP TABLE x
    SELECT * FROM obx_file
     WHERE obx01=g_obx.obx01 AND obx02=g_obx.obx02
      INTO TEMP x
    UPDATE x SET obx01=l_newno1,obx02=l_newno2    #資料鍵值
    INSERT INTO obx_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno1,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","obx_file",l_newno1,"",SQLCA.sqlcode,
                     "","",1)  #No.FUN-660104
    ELSE
        MESSAGE 'ROW(',l_newno1,l_newno2,') O.K' ATTRIBUTE(REVERSE)
    END IF
    SELECT obx_file.* INTO g_obx.* FROM obx_file
     WHERE obx01 = l_newno1
       AND obx02 = l_newno2
    CALL i180_u()
    CALL i180_show()
    #FUN-C80046---begin
    #SELECT obx_file.* INTO g_obx.* FROM obx_file
    # WHERE obx01 = l_oldno1     
    #   AND obx02 = l_oldno2     
    #CALL i180_show()
    #FUN-C80046---end
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i180_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_obx           RECORD LIKE obx_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_obu           RECORD LIKE obu_file.*,
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
         l_za05          LIKE za_file.za05,        # MOD-4B0067
 #MOD-4A0328  --begin
        sr              RECORD
                        obx01 LIKE obx_file.obx01,
                        obx02 LIKE obx_file.obx02,
                        obx03 LIKE obx_file.obx03,
                        obx04 LIKE obx_file.obx04,
                        obx05 LIKE obx_file.obx05,
                        obx08 LIKE obx_file.obx08,
                        obx11 LIKE obx_file.obx11,
                        obu02 LIKE obu_file.obu02,
                        gen02 LIKE gen_file.gen02
                        END RECORD , 
 #MOD-4A0328  --end    
        l_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    IF cl_null(g_wc) AND NOT cl_null(g_obx.obx01) AND NOT cl_null(g_obx.obx02)THEN                          
       LET g_wc = " obx01 = '",g_obx.obx01,"' AND obx02 = '",g_obx.obx02,"'"                                  
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi180') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT obx01,obx02,obx03,obx04,obx05,",
              "       obx08,obx11,obu02,gen02 ",
              " FROM obx_file,OUTER obu_file,OUTER gen_file",
              " WHERE obx04=obu_file.obu01 AND obx11=gen_file.gen01 AND ",g_wc CLIPPED
 #MOD-4A0328  --end   
 
    PREPARE i180_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i180_curo CURSOR FOR i180_p1      # SCROLL CURSOR
 
    START REPORT i180_rep TO l_name
 
    FOREACH i180_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i180_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i180_rep
 
    CLOSE i180_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i180_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
 #MOD-4A0328  --begin
        sr RECORD
           obx01 LIKE obx_file.obx01,
           obx02 LIKE obx_file.obx02,
           obx03 LIKE obx_file.obx03,
           obx04 LIKE obx_file.obx04,
           obx05 LIKE obx_file.obx05,
           obx08 LIKE obx_file.obx08,
           obx11 LIKE obx_file.obx11,
           obu02 LIKE obu_file.obu02,
           gen02 LIKE gen_file.gen02
        END RECORD,
 #MOD-4A0328  --end    
        l_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    OUTPUT
        TOP MARGIN g_top_margin
        LEFT MARGIN g_left_margin
        BOTTOM MARGIN g_bottom_margin
        PAGE LENGTH g_page_line
 
    ORDER BY sr.obx01,sr.obx02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total 
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 #MOD-4B0067(BEGIN)
            PRINT g_x[31],g_x[32],g_x[33],  
                  g_x[34],g_x[35],g_x[36],  
                  g_x[37],g_x[38],g_x[39]   
 
            PRINT g_dash1
 
      ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obx01 CLIPPED,
                  COLUMN g_c[32],sr.obx02 USING "###&", #FUN-590118
                  COLUMN g_c[33],sr.obx03 CLIPPED,
                  COLUMN g_c[34],sr.obx04 CLIPPED,
                  COLUMN g_c[35],sr.obu02,
                  COLUMN g_c[36],sr.obx11,
                  COLUMN g_c[37],sr.gen02,
                  COLUMN g_c[38],sr.obx05 CLIPPED,
 #MOD-4A0328  --begin
#            IF NOT cl_null(sr.obx06) THEN PRINT COLUMN 27,sr.obx06 END IF
#            IF NOT cl_null(sr.obx07) THEN PRINT COLUMN 27,sr.obx07 END IF
 
        #     PRINT COLUMN 18,g_x[14] CLIPPED,   #MOD-4B0067
                   COLUMN g_c[39],sr.obx08           #MOD-4B0067 
#            IF NOT cl_null(sr.obx09) THEN PRINT COLUMN 27,sr.obx09 END IF
#            IF NOT cl_null(sr.obx10) THEN PRINT COLUMN 27,sr.obx10 END IF
 #MOD-4A0328  --end  
 
       
        AFTER GROUP OF sr.obx01
            PRINT
 #MOD-4B0067(END)
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 -end
 
FUNCTION i180_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("obx01,obx02",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i180_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("obx01,obx02",FALSE)
    END IF
 
END FUNCTION
