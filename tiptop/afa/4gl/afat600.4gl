# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: afat600.4gl
# Descriptions...: 盤點資料維護作業
# Date & Author..: 96/05/09 By Sophia
# Modify.........: No.MOD-470423 04/07/26 By Nicola 刪除時出現-400
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-570369 05/08/03 By Smapmin afat600 實際保管部門及人員輸入順序建議對調,在輸入人員後自動帶出其歸屬部門.
# Modify.........: No.FUN-5C0067 05/12/19 By Smapmin 快速輸入action時,第一筆的盤點數量key完後按確定,畫面的資料先不清除
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t600_q() 一開始應清空g_fca.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740069 06/04/26 By kim 顯示中文名稱
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7C0129 07/12/20 By Smapmin 快速輸入時,若盤點編號/序號皆為空,會一直卡在序號
# Modify.........: No.CHI-7C0025 07/12/21 By Smapmin 快速輸入時,盤點序號自動累加1
# Modify.........: No.MOD-7C0195 07/12/25 By Smapmin 已過帳不可再由快速輸入更改
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A10195 10/01/29 By chenmoyan 當fca031為空時賦空格
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加"族群"之欄位
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60043 11/06/10 By Dido 由於 afap610 用到 fca04,因此此作業需增加此欄位預設值 
# Modify.........: No.TQC-B60296 11/06/23 By zhangweib 將 afa-093 檢核的 SQL 依據 faa31 判斷拆分為兩組檢核 faj43 或 faj432
# Modify.........: No:MOD-BB0283 11/11/26 By johung 調整SQL錯誤
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fca   RECORD LIKE fca_file.*,
    g_fca_t RECORD LIKE fca_file.*,
    g_fca_o RECORD LIKE fca_file.*,
    g_fca01_t LIKE fca_file.fca01,
    g_fca02_t LIKE fca_file.fca02,
    g_fca03_t LIKE fca_file.fca03,
    g_fca031_t LIKE fca_file.fca031,
     g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_qty               LIKE type_file.num5,                     #No.FUN-680070 SMALLINT
    g_faj06             LIKE faj_file.faj06,  
    g_out_qty           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    g_gen02             LIKE gen_file.gen02,
    g_t1                LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
MAIN
#    DEFINE l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
    INITIALIZE g_fca.* TO NULL
    INITIALIZE g_fca_t.* TO NULL
    INITIALIZE g_fca_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM fca_file WHERE fca01 = ? AND fca02 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t600_w AT p_row,p_col
         WITH FORM "afa/42f/afat600" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t600_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
END MAIN
 
FUNCTION t600_cs()
    CLEAR FORM
   INITIALIZE g_fca.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         #fca01,fca02,fca03,fca031,fca05,fca06,   #MOD-570369
         fca01,fca02,fca03,fca031,fca06,fca05,   #MOD-570369
         #fca07,fca08,fca15,fca09,fca13,fca14,fca10,fca11,fca12     #MOD-570369
         fca07,fca08,fca15,fca21,fca09,fca13,fca14,fca11,fca10,fca12     #MOD-570369   #FUN-9A0036 add fca21
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE 
### Modify:  
              WHEN INFIELD(fca03) #查詢財產編號
#                CALL q_faj(10,2,g_fca.fca03,g_fca.fca031)
#                     RETURNING g_fca.fca03,g_fca.fca031  
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fca.fca03
                 LET g_qryparam.default2 = g_fca.fca031
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO fca03
                 NEXT FIELD fca03
              WHEN INFIELD(fca14) #查詢盤點人員
#                CALL q_gen(10,3,g_fca.fca14)  RETURNING g_fca.fca14
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fca.fca14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO fca14
                 NEXT FIELD fca14
              WHEN INFIELD(fca10) #查詢實際保管部門
#                CALL q_gem(10,3,g_fca.fca10)                 
#                    RETURNING g_fca.fca10
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fca.fca10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO fca10
                 NEXT FIELD fca10
              WHEN INFIELD(fca11) #查詢實際保管人員
#                CALL q_gen(10,2,g_fca.fca11)             
#                     RETURNING g_fca.fca11
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fca.fca11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO fca11
                 NEXT FIELD fca11
              WHEN INFIELD(fca12) #查詢實際存放位置
#                CALL q_faf(10,3,g_fca.fca12) RETURNING g_fca.fca12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fca.fca12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO fca12
                 NEXT FIELD fca12
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
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT fca01,fca02 FROM fca_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED,
		" ORDER BY fca01"
    PREPARE t600_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t600_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t600_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM fca_file WHERE ",g_wc CLIPPED
    PREPARE t600_prep FROM g_sql
    DECLARE t600_count CURSOR FOR t600_prep
END FUNCTION
 
FUNCTION t600_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a() 
            END IF
            NEXT OPTION "next" 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t600_q()
            END IF
            NEXT OPTION "next" 
        ON ACTION next 
            CALL t600_fetch('N') 
        ON ACTION previous 
            CALL t600_fetch('P')
        ON ACTION register 
            LET g_action_choice="register"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
            NEXT OPTION "next"
        ON ACTION quick_input 
            LET g_action_choice="quick_input"
            IF cl_chk_act_auth() THEN
               CALL t600_z() 
            END IF
            NEXT OPTION "next" 
        ON ACTION delete     
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN 
              CALL t600_r()
            END IF 
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CALL cl_set_field_pic("","",g_fca.fca15,"","","")
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION jump
             CALL t600_fetch('/')
         ON ACTION first
             CALL t600_fetch('F')
         ON ACTION last
             CALL t600_fetch('L')
         ON ACTION related_document    #No.MOD-470515 
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_fca.fca01 IS NOT NULL THEN 
                 LET g_doc.column1 = "fca01"
                 LET g_doc.value1 = g_fca.fca01
                 CALL cl_doc()
              END IF
           END IF
 
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
      #FUN-810046
      &include "qry_string.4gl"
 
    END MENU
    CLOSE t600_cs
END FUNCTION
 
 
FUNCTION t600_a()		#輸入     
 DEFINE l_msg1,l_msg2  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(60)
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                         # 清螢幕欄位內容
    INITIALIZE g_fca.* TO NULL
    LET g_fca.fca15 = 'N'
    LET g_fca.fca13 = g_today
    LET g_fca.fca14 = g_user
    LET g_fca.fcalegal= g_legal    #FUN-980003 add
    LET g_fca_o.* = g_fca.*
    LET g_fca_t.* = g_fca.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fca.fca15 = 'N'
        LET g_fca.fca13 = g_today
        LET g_fca.fca14 = g_user
        CALL t600_i("a")                            # 各欄位輸入
        IF INT_FLAG THEN 
            LET INT_FLAG = 0
            INITIALIZE g_fca.* TO NULL
            EXIT WHILE
        END IF
        IF g_fca.fca01 IS NULL THEN
           CONTINUE WHILE
        END IF
#MOD-A10195 --Begin
        IF g_fca.fca031 IS NULL THEN
           LET g_fca.fca031 = ' '
        END IF
#MOD-A10195 --End
        INSERT INTO fca_file VALUES(g_fca.*)
        IF SQLCA.SQLCODE THEN 
#          CALL cl_err('ins fca:',SQLCA.sqlcode,1)    #No.FUN-660136
           CALL cl_err3("ins","fca_file",g_fca.fca01,g_fca.fca02,SQLCA.sqlcode,"","ins fca:",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        SELECT fca01,fca02 INTO g_fca.fca01,g_fca.fca02 FROM fca_file
         WHERE fca01 = g_fca.fca01
           AND fca02 = g_fca.fca02
        LET g_fca_t.* = g_fca.*                # 保存上筆資料
        LET g_fca_o.* = g_fca.*                # 保存上筆資料
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t600_z()		#quick_input     
 DEFINE l_msg1,l_msg2  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(60)
 DEFINE l_cnt        LIKE type_file.num5          #CHI-7C0025
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL cl_opmsg('z')
    INITIALIZE g_fca.* LIKE fca_file.*
    LET g_fca.fca13 = g_today
    LET g_fca.fca14 = g_user
    LET g_fca.fcalegal = g_legal    #MOD-BB0283 add
  # LET l_msg1 = 'Del:register結束,<^F>:欄位說明'
  # LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
  # DISPLAY l_msg1 AT 1,1
  # DISPLAY l_msg2 AT 2,1
    WHILE TRUE
        LET g_fca.fca13 = g_today  #No:8274
        LET g_fca.fca14 = g_user
        LET g_fca.fcalegal = g_legal    #MOD-BB0283 add
        CALL t600_i("z")                            # 各欄位輸入
        IF INT_FLAG THEN                            # 若按了DEL鍵
            LET INT_FLAG = 0
            CLEAR FORM
            INITIALIZE g_fca.* TO NULL
            INITIALIZE g_fca_o.* TO NULL
            EXIT WHILE
        END IF
        IF g_fca.fca01 IS NULL THEN                 # KEY 不可空白
            CONTINUE WHILE
        END IF
        UPDATE fca_file SET fca_file.* = g_fca.*    # 更新DB
            WHERE fca01 = g_fca.fca01
              AND fca02 = g_fca.fca02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err(g_fca.fca01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fca_file",g_fca.fca01,g_fca.fca02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        LET g_fca_t.* = g_fca.*                # 保存上筆資料
        LET g_fca_o.* = g_fca.*                # 保存上筆資料
        SELECT fca01,fca02 INTO g_fca.fca01,g_fca.fca02 FROM fca_file
         WHERE fca01 = g_fca.fca01
           AND fca02 = g_fca.fca02
        LET g_fca01_t = g_fca.fca01
        LET g_fca02_t = g_fca.fca02
        #-----CHI-7C0025---------
        LET g_fca.fca02 = g_fca.fca02 + 1
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM fca_file
           WHERE fca01 = g_fca.fca01 
             AND fca02 = g_fca.fca02
        IF l_cnt = 0 THEN 
           LET g_fca.fca02 = g_fca_t.fca02
        END IF
        CALL t600_fca02('z')
        IF NOT cl_null(g_errno) THEN
           CALL cl_err(g_fca.fca02,g_errno,1)
        END IF
        #-----END CHI-7C0025-----
#        INITIALIZE g_fca.* TO NULL   #FUN-5C0067
#       EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t600_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
        l_gen02         LIKE gen_file.gen02,
        l_faj06         LIKE faj_file.faj06,
        l_qty           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_out_qty       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_mesg,l_str    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(80)
        l_n             LIKE type_file.num5          #No.FUN-680070 SMALLINT
 
 
          DISPLAY BY NAME g_fca.fca01,g_fca.fca02,g_fca.fca03,
                        g_fca.fca031,g_fca.fca05,g_fca.fca06,g_fca.fca07,
                        g_fca.fca08,g_fca.fca15,g_fca.fca21,g_fca.fca09,g_fca.fca13,g_fca.fca14,      #FUN-9A0036 add fca21
                        g_fca.fca10,g_fca.fca11,g_fca.fca12
 
          INPUT BY NAME g_fca.fca01,g_fca.fca02,g_fca.fca03,
                         #g_fca.fca031,g_fca.fca05,g_fca.fca06,g_fca.fca07,   #MOD-570369
                         g_fca.fca031,g_fca.fca06,g_fca.fca05,g_fca.fca07,   #MOD-570369
                        g_fca.fca08,g_fca.fca21,g_fca.fca09,g_fca.fca13,g_fca.fca14,       #FUN-9A0036 add fca21
                         #g_fca.fca10,g_fca.fca11,g_fca.fca12   #MOD-570369
                         g_fca.fca11,g_fca.fca10,g_fca.fca12   #MOD-570369
          WITHOUT DEFAULTS 
       
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t600_set_entry(p_cmd)
            CALL t600_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD fca01      #盤點編號
           LET g_fca_o.fca01 = g_fca.fca01
 
        BEFORE FIELD fca02
           IF p_cmd = 'a' THEN 
              SELECT MAX(fca02)+1 INTO g_fca.fca02
                FROM fca_file
               WHERE fca01 = g_fca.fca01
              IF SQLCA.sqlcode THEN
#                CALL cl_err('select max:',SQLCA.sqlcode,0)   #No.FUN-660136
                 CALL cl_err3("sel","fca_file",g_fca.fca01,"",SQLCA.sqlcode,"","select max:",1)  #No.FUN-660136
              END IF
              IF cl_null(g_fca.fca02) THEN
                 LET g_fca.fca02 = 1 
              END IF
              DISPLAY BY NAME g_fca.fca02 
           END IF  
 
 
        AFTER FIELD fca02      #盤點序號
          IF NOT cl_null(g_fca.fca02) THEN
             CASE p_cmd
               WHEN 'a'
                  IF (g_fca_o.fca01 IS NULL) OR
                     (g_fca_o.fca01 != g_fca.fca01) OR 
                     (g_fca_o.fca02 IS NULL) OR     # 盤點編號+序號
                     (g_fca_o.fca02 != g_fca.fca02) THEN
                     SELECT COUNT(*) INTO g_cnt FROM fca_file
                      WHERE fca01 = g_fca.fca01
                        AND fca02 = g_fca.fca02
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_fca.fca02,-239,0)
                        LET g_fca.fca02 = g_fca02_t
                        DISPLAY BY NAME g_fca.fca02 
                        NEXT FIELD fca02
                     END IF
                  END IF
               WHEN 'z'
                  SELECT COUNT(*) INTO g_cnt
                    FROM fca_file
                   WHERE fca01 = g_fca.fca01
                     AND fca02 = g_fca.fca02
                  IF g_cnt = 0 THEN
                     CALL cl_err(g_fca.fca02,'afa-032',0)
                     LET g_fca.fca02 = g_fca02_t
                     DISPLAY BY NAME g_fca.fca02
                     #NEXT FIELD fca02   #MOD-7C0129
                     NEXT FIELD fca01   #MOD-7C0129
                  ELSE  
                     CALL t600_fca02('z')
                     IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_fca.fca02,g_errno,1)
                       LET g_fca.fca02 = g_fca_o.fca02
                       DISPLAY BY NAME g_fca.fca02
                       #NEXT FIELD fca02   #MOD-7C0129
                       NEXT FIELD fca01   #MOD-7C0129
                     END IF
                  END IF
                  NEXT FIELD fca09
               OTHERWISE EXIT CASE
             END CASE
             LET g_fca_o.fca02 = g_fca.fca02
          END IF
 
        AFTER FIELD fca03
            IF cl_null(g_fca.fca03) AND cl_null(g_fca_t.fca031) THEN
               CALL cl_err(g_fca.fca03,'afa-036',0)
               NEXT FIELD fca03
            END IF
            LET g_fca_o.fca03 = g_fca.fca03
            #FUN-9A0036  -----start------------
            IF cl_null(g_fca.fca21) THEN
               LET g_fca.fca21 = g_fca.fca03 
            END IF 
            #FUN-9A0036  -----end--------------
 
        AFTER FIELD fca031
            IF cl_null(g_fca.fca03) AND cl_null(g_fca.fca031) THEN
               CALL cl_err(g_fca.fca031,'afa-036',0)
               NEXT FIELD fca031
            END IF
            IF cl_null(g_fca.fca031) THEN
               LET g_fca.fca031 = ' '
            END IF
               SELECT COUNT(*) INTO g_cnt
                 FROM fca_file
                WHERE fca01  = g_fca.fca01
                  AND fca03  =  g_fca.fca03
                  AND fca031 = g_fca.fca031
                   IF g_cnt > 0 THEN
                      CALL cl_err(g_fca.fca031,-239,0)
                      LET g_fca.fca031 = g_fca031_t
                      DISPLAY BY NAME g_fca.fca031 
                      NEXT FIELD fca031
                   END IF
              CALL t600_fca031('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fca.fca031,g_errno ,1)
                 LET g_fca.fca031 = g_fca_o.fca031
                 DISPLAY BY NAME g_fca.fca031 
                 NEXT FIELD fca031
              END IF
            LET g_fca_o.fca031 = g_fca.fca031
 
         AFTER FIELD fca05
            LET g_fca.fca10 = g_fca.fca05  
 
         AFTER FIELD fca06
            LET g_fca.fca11 = g_fca.fca06
 #MOD-570369
            SELECT gem01 INTO g_fca.fca05 FROM gem_file,gen_file
             WHERE gem01 = gen03 AND gen01 = g_fca.fca06
            DISPLAY BY NAME g_fca.fca05
 #END MOD-570369
 
         AFTER FIELD fca07
            LET g_fca.fca12 = g_fca.fca07
 
         AFTER FIELD fca09
            IF g_fca.fca09 < 0 THEN
               CALL cl_err(g_fca.fca09,'afa-040',0)
               NEXT FIELD fca09
            END IF
            LET g_fca_o.fca09 = g_fca.fca09
 
         AFTER FIELD fca14
            IF NOT cl_null(g_fca.fca14) THEN
               CALL t600_fca14('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fca.fca14,g_errno,1)  
                    LET g_fca.fca14 = g_fca_o.fca14
                    DISPLAY BY NAME g_fca.fca14
                    NEXT FIELD fca14
                 END IF
           END IF
           LET g_fca_o.fca14 = g_fca.fca14
        
         AFTER FIELD fca10
            IF NOT cl_null(g_fca.fca10) THEN
               CALL t600_fca10('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fca.fca10,g_errno,1)   
                    LET g_fca.fca14 = g_fca_o.fca10
                    DISPLAY BY NAME g_fca.fca10 
                    NEXT FIELD fca10
                 END IF
           END IF
           CALL t600_set_gem02() #MOD-740069
           LET g_fca_o.fca10 = g_fca.fca10
                          
         AFTER FIELD fca11
            IF NOT cl_null(g_fca.fca11) THEN
               CALL t600_fca11('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fca.fca11,g_errno,1)   
                    LET g_fca.fca11 = g_fca_o.fca11
                    DISPLAY BY NAME g_fca.fca11 
                    NEXT FIELD fca11
                 END IF
           END IF
           CALL t600_set_gen02() #MOD-740069
           LET g_fca_o.fca11 = g_fca.fca11
 #MOD-570369
           SELECT gem01 INTO g_fca.fca10 FROM gem_file,gen_file
            WHERE gem01 = gen03 AND gen01 = g_fca.fca11
           DISPLAY BY NAME g_fca.fca10
 #END MOD-570369
 
         AFTER FIELD fca12
            IF NOT cl_null(g_fca.fca12) THEN
               CALL t600_fca12('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fca.fca12,g_errno,1)   
                    LET g_fca.fca12 = g_fca_o.fca12
                    DISPLAY BY NAME g_fca.fca12 
                    NEXT FIELD fca12
                 END IF
           END IF
           CALL t600_set_faf02() #MOD-740069
           LET g_fca_o.fca12 = g_fca.fca12
 
        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF cl_null(g_fca.fca01) AND cl_null(g_fca.fca02) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_fca.fca01, g_fca.fca02 
             NEXT FIELD fca02
          END IF    
        # IF l_flag='Y' THEN
        #    CALL cl_err('','9033',0)
        #    NEXT FIELD fca02
        # END IF
 
        ON ACTION controlp
           CASE 
### Modify:  
              WHEN INFIELD(fca03) #查詢財產編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fca.fca03
                 LET g_qryparam.default2 = g_fca.fca031
                 CALL cl_create_qry() RETURNING g_fca.fca03,g_fca.fca031
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca031 )
#                 CALL q_faj(10,2,g_fca.fca03,g_fca.fca031)
#                      RETURNING g_fca.fca03,g_fca.fca031  
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca031 )
                 DISPLAY BY NAME g_fca.fca03,g_fca.fca031 
                 NEXT FIELD fca03
              WHEN INFIELD(fca14) #查詢盤點人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fca.fca14
                 CALL cl_create_qry() RETURNING g_fca.fca14
#                 CALL q_gen(10,3,g_fca.fca14)  RETURNING g_fca.fca14
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca14 )
                 DISPLAY BY NAME g_fca.fca14
                 CALL t600_fca14('a')
                 NEXT FIELD fca14
              WHEN INFIELD(fca10) #查詢實際保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fca.fca10
                 CALL cl_create_qry() RETURNING g_fca.fca10
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca10 )
#                 CALL q_gem(10,3,g_fca.fca10)                 
#                     RETURNING g_fca.fca10
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca10 )
                 DISPLAY BY NAME g_fca.fca10
                 NEXT FIELD fca10
              WHEN INFIELD(fca11) #查詢實際保管人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fca.fca11
                 CALL cl_create_qry() RETURNING g_fca.fca11
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca11 )
#                 CALL q_gen(10,2,g_fca.fca11)             
#                        RETURNING g_fca.fca11
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca11 )
                 DISPLAY BY NAME g_fca.fca11
                 NEXT FIELD fca11
              WHEN INFIELD(fca12) #查詢實際存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fca.fca12
                 CALL cl_create_qry() RETURNING g_fca.fca12
#                 CALL q_faf(10,3,g_fca.fca12) RETURNING g_fca.fca12
#                 CALL FGL_DIALOG_SETBUFFER( g_fca.fca12 )
                 DISPLAY BY NAME g_fca.fca12
                 NEXT FIELD fca12
              OTHERWISE 
                 EXIT CASE
           END CASE
 
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
   
FUNCTION t600_fca02(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           l_faj06   LIKE faj_file.faj06,
           l_qty     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_out_qty LIKE type_file.num5                      #No.FUN-680070 SMALLINT
 
    LET g_errno = ' '
    IF p_cmd = 'a' THEN RETURN END IF
       SELECT fca03,fca031,fca15,fca21,faj06,fca08,fca05,fca06,fca07,(faj17-faj58),         #FUN-9A0036 add fca21 
              faj171,fca09,fca10,fca11,fca12
         INTO g_fca.fca03,g_fca.fca031,g_fca.fca15,g_fca.fca21,l_faj06,g_fca.fca08,         #FUN-9A0036 add fca21
              g_fca.fca05,
              g_fca.fca06,g_fca.fca07,l_qty,l_out_qty,g_fca.fca09,g_fca.fca10,
              g_fca.fca11,g_fca.fca12
        #FROM fca_file LEFT JOIN ON faj_file ON fac03=faj02 AND fca031=faj022   #MOD-BB0283 mark
         FROM fca_file LEFT JOIN faj_file ON fca03=faj02 AND fca031=faj022      #MOD-BB0283
        WHERE fca01  = g_fca.fca01
          AND fca02  = g_fca.fca02
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-041'   
              LET g_fca.fca03  = NULL LET g_fca.fca06  = NULL 
              LET g_fca.fca031 = NULL LET g_fca.fca07  = NULL
              LET l_faj06      = NULL LET l_qty        = NULL 
              LET g_fca.fca08  = NULL LET l_out_qty    = NULL  
              LET g_fca.fca05  = NULL LET g_fca.fca09  = NULL
              LET g_fca.fca10  = NULL LET g_fca.fca11  = NULL
              LET g_fca.fca12  = NULL
         WHEN g_fca.fca15 = 'Y'    #MOD-7C0195
              LET g_errno='asf-812'   #MOD-7C0195
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
       LET g_fca_t.* = g_fca.* 
       LET g_faj06   = l_faj06
       LET g_qty     = l_qty
       LET g_out_qty = l_out_qty
       IF cl_null(g_errno) OR p_cmd = 'z' THEN
          DISPLAY BY NAME g_fca.fca03,g_fca.fca031,g_fca.fca15,g_fca.fca05,
                          g_fca.fca06,
                       g_fca.fca07,g_fca.fca08,g_fca.fca09,g_fca.fca10,
                       g_fca.fca11,g_fca.fca12
          DISPLAY l_faj06 TO FORMONLY.faj06
          DISPLAY l_qty   TO FORMONLY.qty
          DISPLAY l_out_qty TO FORMONLY.out_qty
       END IF
END FUNCTION
   
FUNCTION t600_fca031(p_cmd)   #財產附號
  DEFINE p_cmd	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_faj01   LIKE faj_file.faj01,      #TQC-B60043
         l_faj06   LIKE faj_file.faj06,
         l_faj18   LIKE faj_file.faj18,
         l_faj20   LIKE faj_file.faj20,
         l_faj19   LIKE faj_file.faj19,
         l_faj21   LIKE faj_file.faj21,
         l_fca09   LIKE fca_file.fca09,
         l_qty     LIKE type_file.num5,      #No.FUN-680070 SMALLINT
         l_out_qty LIKE type_file.num5       #No.FUN-680070 SMALLINT
 
    LET g_errno = ' '
#TQC-B60296   ---start   Add
  IF g_faa.faa31 = 'Y' THEN
#TQC-B60296   ---end     Add
    SELECT faj01,faj06,faj17-faj58,faj171,faj18,faj20,faj19,faj21,faj17-faj58      #TQC-B60043 add faj01 
      INTO l_faj01,l_faj06,l_qty,l_out_qty,l_faj18,l_faj20,l_faj19,l_faj21,l_fca09 #TQC-B60043 add faj01
      FROM faj_file
     WHERE faj02 = g_fca.fca03
       AND faj022 = g_fca.fca031
      #AND faj43 not IN ('0','5','6','X')    #TQC-B60296   Mark
       AND faj432 not IN ('0','5','6','X')    #FUN-AB0088
#TQC-B60296   ---start   Add
  ELSE
    SELECT faj01,faj06,faj17-faj58,faj171,faj18,faj20,faj19,faj21,faj17-faj58
      INTO l_faj01,l_faj06,l_qty,l_out_qty,l_faj18,l_faj20,l_faj19,l_faj21,l_fca09
      FROM faj_file
     WHERE faj02 = g_fca.fca03
       AND faj022 = g_fca.fca031
       AND faj43 not IN ('0','5','6','X')
  END IF
#TQC-B60296   ---end     Add
 
   #CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-093'    #MOD-C70265 mark
    CASE                                                     #MOD-C70265 add
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-134'    #MOD-C70265 add
           LET l_faj06     = NULL  LET l_qty       = NULL
           LET l_out_qty   = NULL  LET g_fca.fca08 = NULL
           LET g_fca.fca05 = NULL  LET g_fca.fca06 = NULL
           LET g_fca.fca07 = NULL  LET g_fca.fca09 = NULL
           LET g_fca.fca10 = NULL  LET g_fca.fca11 = NULL
           LET g_fca.fca12 = NULL
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
        LET g_fca.fca04 = l_faj01   #TQC-B60043
        LET g_faj06 = l_faj06
        LET g_qty   = l_qty
        LET g_out_qty = l_out_qty
        LET g_fca.fca08 = l_faj18
        LET g_fca.fca05 = l_faj20
        LET g_fca.fca06 = l_faj19
        LET g_fca.fca07 = l_faj21
        LET g_fca.fca09 = l_fca09    
        LET g_fca.fca10 = g_fca.fca05
        LET g_fca.fca11 = g_fca.fca06
        LET g_fca.fca12 = g_fca.fca07
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
           DISPLAY BY NAME g_fca.fca08,g_fca.fca05,g_fca.fca06,g_fca.fca07,
                           g_fca.fca09,g_fca.fca10,g_fca.fca11,g_fca.fca12
           DISPLAY l_faj06 TO FORMONLY.faj06
           DISPLAY l_qty   TO FORMONLY.qty
           DISPLAY l_out_qty TO FORMONLY.out_qty
        END IF
END FUNCTION
 
#檢查盤點人員是否存在員工姓名檔
FUNCTION t600_fca14(p_cmd) 
    DEFINE p_cmd	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
      INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_fca.fca14
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-034'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_gen02 = l_gen02
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
#檢查實際保管部門是否存在部門檔  
FUNCTION t600_fca10(p_cmd) 
    DEFINE p_cmd	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
      INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fca.fca10
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#檢查實際保管人是否存在員工姓名檔
FUNCTION t600_fca11(p_cmd) 
    DEFINE p_cmd	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           l_gen02 LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
      INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_fca.fca11
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-034'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#檢查實際存放位置是否存在存放位置檔
FUNCTION t600_fca12(p_cmd) 
    DEFINE p_cmd	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           l_faf02 LIKE faf_file.faf02,
           l_fafacti LIKE faf_file.fafacti
 
    LET g_errno = ' '
    SELECT faf02,fafacti
      INTO l_faf02,l_fafacti
      FROM faf_file
     WHERE faf01 = g_fca.fca12
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-039'
                            LET l_faf02 = NULL
         WHEN l_fafacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
FUNCTION t600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fca.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t600_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t600_count
    FETCH t600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('Query:',SQLCA.sqlcode,0)
        INITIALIZE g_fca.* TO NULL
        INITIALIZE g_fca_o.* TO NULL
    ELSE
        CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t600_fetch(p_flfca)
    DEFINE
        p_flfca          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfca
        WHEN 'N' FETCH NEXT     t600_cs INTO g_fca.fca01,g_fca.fca02
        WHEN 'P' FETCH PREVIOUS t600_cs INTO g_fca.fca01,g_fca.fca02
        WHEN 'F' FETCH FIRST    t600_cs INTO g_fca.fca01,g_fca.fca02
        WHEN 'L' FETCH LAST     t600_cs INTO g_fca.fca01,g_fca.fca02
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
            FETCH ABSOLUTE g_jump t600_cs INTO g_fca.fca01,g_fca.fca02
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fca.fca01,SQLCA.sqlcode,0)
        INITIALIZE g_fca.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flfca
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fca.* FROM fca_file   # 重讀DB,因TEMP有不被更新特性
       WHERE fca01 = g_fca.fca01 AND fca02 = g_fca.fca02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fca.fca01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fca_file",g_fca.fca01,g_fca.fca02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        CALL t600_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t600_show()
    LET g_fca_t.* = g_fca.*
    LET g_fca_o.* = g_fca.*   
    DISPLAY BY NAME 
 
        g_fca.fca01,g_fca.fca02,g_fca.fca15,g_fca.fca21,g_fca.fca03,g_fca.fca031,            #FUN-9A0036 add fca21
        g_fca.fca08,g_fca.fca05,g_fca.fca06,g_fca.fca07,g_fca.fca09,
        g_fca.fca13,g_fca.fca14,g_fca.fca10,g_fca.fca11,g_fca.fca12
    CALL cl_set_field_pic("","",g_fca.fca15,"","","")
    SELECT faj06,faj17-faj58,faj171
     INTO g_faj06,g_qty,g_out_qty
     FROM faj_file
    WHERE faj02  = g_fca.fca03 
      AND faj022 = g_fca.fca031
       DISPLAY g_faj06     TO FORMONLY.faj06
       DISPLAY g_qty       TO FORMONLY.qty
       DISPLAY g_out_qty   TO FORMONLY.out_qty
    CALL t600_fca14('d')
    CALL t600_set_gen02() #MOD-740069
    CALL t600_set_gem02() #MOD-740069
    CALL t600_set_faf02() #MOD-740069
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t600_u()              # register
 
    IF s_shut(0) THEN RETURN END IF
  # CALL t600_q()
    IF g_fca.fca01 IS NULL THEN 
       CALL cl_err('',-400,0) RETURN 
    END IF
    IF g_fca.fca15 = 'Y' THEN RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fca01_t = g_fca.fca01
    LET g_fca02_t = g_fca.fca02
    BEGIN WORK
 
    OPEN t600_cl USING g_fca.fca01,g_fca.fca02
 
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t600_cl INTO g_fca.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fca.fca01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t600_show()                          # 顯示最新資料
    WHILE TRUE
#96-06-11 Modify by Lynn 如果盤點日期,人員空白則default
       IF g_fca.fca13 IS NULL THEN LET g_fca.fca13 = g_today END IF
       IF g_fca.fca14 IS NULL THEN LET g_fca.fca14 = g_user  END IF
        CALL t600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fca.*=g_fca_t.*
            CALL t600_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fca_file SET fca_file.* = g_fca.*    # 更新DB
            WHERE fca01 = g_fca01_t AND fca02 = g_fca02_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fca.fca01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fca_file",g_fca01_t,g_fca02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
           EXIT WHILE
    END WHILE
    COMMIT WORK
 
    CLOSE t600_cl
END FUNCTION
 
#Modify:2705 
FUNCTION t600_r()   #batch_delete 
  DEFINE l_sql     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(500)
         l_fca     RECORD LIKE fca_file.* 
 
 #No:4703
 #CLEAR FORM
 #WHILE TRUE
 #  CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
 #        fca01,fca02,fca03,fca031,fca05,fca06,fca07,fca15,fca08,
 #        fca09,fca13,fca14,fca10,fca11,fca12    
 #      ON ACTION controlp
 #         CASE 
### Modify:  
 #            WHEN INFIELD(fca03) #查詢財產編號
##               CALL q_faj(10,2,g_fca.fca03,g_fca.fca031)
##                    RETURNING g_fca.fca03,g_fca.fca031  
 #               CALL cl_init_qry_var()
 #               LET g_qryparam.state = "c"
 #               LET g_qryparam.form = "q_faj"
 #               LET g_qryparam.default1 = g_fca.fca03
 #               LET g_qryparam.default2 = g_fca.fca031
 #               CALL cl_create_qry() RETURNING g_qryparam.multiret 
 #               DISPLAY g_qryparam.multiret TO fca03
 #               NEXT FIELD fca03
 #            WHEN INFIELD(fca14) #查詢盤點人員
##               CALL q_gen(10,3,g_fca.fca14)  RETURNING g_fca.fca14
 #               CALL cl_init_qry_var()
 #               LET g_qryparam.state = "c"
 #               LET g_qryparam.form = "q_gen"
 #               LET g_qryparam.default1 = g_fca.fca14
 #               CALL cl_create_qry() RETURNING g_qryparam.multiret 
 #               DISPLAY g_qryparam.multiret TO fca14
 #               NEXT FIELD fca14
 #            WHEN INFIELD(fca10) #查詢實際保管部門
##               CALL q_gem(10,3,g_fca.fca10)                 
##                   RETURNING g_fca.fca10
 #               CALL cl_init_qry_var()
 #               LET g_qryparam.state = "c"
 #               LET g_qryparam.form = "q_gem"
 #               LET g_qryparam.default1 = g_fca.fca10
 #               CALL cl_create_qry() RETURNING g_qryparam.multiret 
 #               DISPLAY g_qryparam.multiret TO fca10
 #               NEXT FIELD fca10
 #            WHEN INFIELD(fca11) #查詢實際保管人員
##               CALL q_gen(10,2,g_fca.fca11)             
##                    RETURNING g_fca.fca11
 #               CALL cl_init_qry_var()
 #               LET g_qryparam.state = "c"
 #               LET g_qryparam.form = "q_gen"
 #               LET g_qryparam.default1 = g_fca.fca11
 #               CALL cl_create_qry() RETURNING g_qryparam.multiret 
 #               DISPLAY g_qryparam.multiret TO fca11
 #               NEXT FIELD fca11
 #            WHEN INFIELD(fca12) #查詢實際存放位置
##               CALL q_faf(10,3,g_fca.fca12) RETURNING g_fca.fca12
 #               CALL cl_init_qry_var()
 #               LET g_qryparam.state = "c"
 #               LET g_qryparam.form = "q_faf"
 #               LET g_qryparam.default1 = g_fca.fca12
 #               CALL cl_create_qry() RETURNING g_qryparam.multiret 
 #               DISPLAY g_qryparam.multiret TO fca12
 #               NEXT FIELD fca12
 #            OTHERWISE 
 #               EXIT CASE
 #         END CASE
 #     ON IDLE g_idle_seconds
 #        CALL cl_on_idle()
 #        CONTINUE CONSTRUCT
 
  #    ON ACTION about         #MOD-4C0121
  #       CALL cl_about()      #MOD-4C0121
 #
  #    ON ACTION help          #MOD-4C0121
  #       CALL cl_show_help()  #MOD-4C0121
 #
  #    ON ACTION controlg      #MOD-4C0121
  #       CALL cl_cmdask()     #MOD-4C0121
 
 #  
 #       ON ACTION exit                            #加離開功能
 #          LET INT_FLAG = 1
 #          EXIT CONSTRUCT
#
#   END CONSTRUCT
#         IF g_wc=' 1=1' THEN 
#            CALL cl_err('','9046',0) CONTINUE WHILE 
#         ELSE EXIT WHILE
#         END IF
#  END WHILE
#  IF INT_FLAG THEN RETURN END IF
   IF s_shut(0) THEN  RETURN END IF
   SELECT * INTO g_fca.* FROM fca_file
    WHERE fca01 = g_fca.fca01
      AND fca03 = g_fca.fca03
      AND fca031 = g_fca.fca031
   IF g_fca.fca15 = 'Y' THEN
      Call cl_err(' ','afa-101',0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   #----------未過帳才可刪除---------
  #LET l_sql = " DELETE FROM fca_file ",
  #            " WHERE fca15 = 'N' ",
  #            "   AND ",g_wc CLIPPED
  #PREPARE t600_c_pre FROM l_sql
 ##DECLARE t600_c_cur CURSOR FOR t600_c_pre
  #IF NOT cl_sure(20,20) THEN RETURN END IF
  #CALL cl_wait()
   
  #LET l_sql =" SELECT * FROM fca_file WHERE ",g_wc clipped 
  #PREPARE t600_r_pre FROM l_sql 
  #DECLARE t600_r_cur CURSOR FOR t600_r_pre
  #FOREACH t600_r_cur INTO l_fca.*
  #  IF  SQLCA.sqlcode THEN CALL cl_err('foreach',status,0) END IF  
  #  IF l_fca.fca15 ='Y' THEN   #此筆資料已過帳 
  #    CALL cl_err('此筆資料已過帳,不可刪除!',STATUS,0) 
  #    RETURN 
  #  END IF  
  #END FOREACH 
  # EXECUTE t600_c_pre
  # IF SQLCA.sqlcode THEN
  #    CALL cl_err('del fca',STATUS,0)
  #    LET g_success = 'N'
  # END IF
    OPEN t600_cl USING g_fca.fca01,g_fca.fca02  #No.MOD-470423
   FETCH t600_cl INTO g_fca.*
   IF SQLCA.sqlcode THEN
        CALL cl_err(g_fca.fca01,SQLCA.sqlcode,0)
        LET g_success = 'N'
     END IF
     #No:4703
     Call t600_show()
    IF cl_delete() THEN  #No.MOD-470423
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fca01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fca.fca01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM fca_file WHERE fca01 = g_fca.fca01 AND fca03 = g_fca.fca03
                             AND fca031 = g_fca.fca031
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_fca.fca01,SQLCA.sqlcode,1)   #No.FUN-660136
          CALL cl_err3("del","fca_file",g_fca.fca01,g_fca.fca03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          LET g_success = 'N'
     ELSE
        CLEAR FORM
        OPEN t600_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t600_cs
           CLOSE t600_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t600_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t600_cs
           CLOSE t600_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t600_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t600_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t600_fetch('/')
        END IF
 
     END IF
   END IF
   #No:4703 end
   CLOSE t600_cl
  
   IF g_success = 'Y' THEN 
      COMMIT WORK 
  #    CALL cl_end(0,0)  
   ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   #IF p_cmd = 'a' AND (NOT g_before_input_done) THEN   #MOD-7C0129
      CALL cl_set_comp_entry("fca01,fca02,fca03,fca031,fca08,fca05,fca06,fca07",TRUE)
   #END IF   #MOD-7C0129
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fca01,fca02,fca03,fca031,fca08,fca05,fca06,fca07",FALSE)
   END IF
   IF NOT g_before_input_done THEN   
      IF p_cmd != 'a' THEN 
         CALL cl_set_comp_entry("fca03,fca031,fca08,fca05,fca06,fca07",FALSE)
      END IF 
   END IF
END FUNCTION
 
#MOD-740069
FUNCTION t600_set_gen02()
   DEFINE l_gen02 LIKE gen_file.gen02
   SELECT gen02 INTO l_gen02 FROM gen_file
                            WHERE gen01=g_fca.fca11
   DISPLAY l_gen02 TO FORMONLY.gen02_2
END FUNCTION
 
#MOD-740069
FUNCTION t600_set_gem02()
   DEFINE l_gem02 LIKE gem_file.gem02
   SELECT gem02 INTO l_gem02 FROM gem_file
                            WHERE gem01=g_fca.fca10
   DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION
 
#MOD-740069
FUNCTION t600_set_faf02()
   DEFINE l_faf02 LIKE faf_file.faf02
   SELECT faf02 INTO l_faf02 FROM faf_file
                            WHERE faf01=g_fca.fca12
   DISPLAY l_faf02 TO FORMONLY.faf02
END FUNCTION
