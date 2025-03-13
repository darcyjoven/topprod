# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmi109.4gl
# Descriptions...: 測試料件－基本資料維護
# Date & Author..: 94/05/27 By Apple
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4C0002 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.MOD-530140 05/03/17 By Carrier KEY值欄位沒有鎖住,導致LOOP
# Modify.........: No.FUN-560027 05/06/16 By Mandy 加bmq910 主特性代碼
# Modify.........: No.FUN-590078 05/10/05 By Sarah 測試料號欄位應放大至40碼(現在為20碼)
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/14 By baogui 報表問題修改
# Modify.........: No.FUN-6B0026 06/11/21 By claire 料號要開窗
# Modify.........: No.CHI-6B0035 06/12/21 By jamie  增加分群碼帶出值的功能 
# Modify.........: No.CHI-720014 07/02/27 By claire 接收參數
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730075 07/03/29 By kim 行業別架構
# Modify.........: No.TQC-740079 07/04/13 By Ray 增加無效功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/06/27 BY xiaofeizhu 制作水晶報表
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840042 08/04/11 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-890089 08/09/10 By claire 調整邏輯
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-920091 09/02/26 By chenyu 資料無效時，不可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AB0025 10/11/05 By vealxu 拿掉FUN-AA0059 料號管控，測試料件無需判斷
# Modify.........: No.TQC-AB0052 10/11/14 By destiny 查询时不能在orig,oriu下条件 
# Modify.........: No.MOD-AC0075 10/12/09 by sabrina 庫存單位帶出來後要給bmq44_fac、bmq55_fac、bmq63_fac值 
# Modify.........: No.TQC-B30036 11/03/03 By destiny 新增一筆資料，沒有立即顯示bmquser欄位的相關值，重新查詢后能夠正常顯示
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20173 12/02/15 by Bart 過單
# Modify.........: No:TQC-C50009 12/05/03 By chenjing 修改正式料号为空问题
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmq   RECORD LIKE bmq_file.*,
    g_bmq_t RECORD LIKE bmq_file.*,
    g_bmq_o RECORD LIKE bmq_file.*,
    g_bmq01_t LIKE bmq_file.bmq01,
    g_flag             LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
    g_type             LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1) 
    g_sw               LIKE type_file.num5,       #No.FUN-680096 SMALLINT
    g_argv1            LIKE bmq_file.bmq01,       #CHI-720014 add
   #g_wc,g_sql         STRING #TQC-630166         #No.FUN-680096
    g_wc,g_sql         STRING    #TQC-630166
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_chr           LIKE type_file.chr1     #No.TQC-740079
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_ans           LIKE type_file.chr1     #CHI-720014 modify VARCHAR(1)  #CHI-6B0035 add
DEFINE   g_str           STRING                  #FUN-770052
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    INITIALIZE g_bmq.* TO NULL
    INITIALIZE g_bmq_t.* TO NULL
 
    LET g_argv1 = ARG_VAL(1)              #料件編號  #CHI-720014 add
 
    LET g_forupd_sql = "SELECT * FROM bmq_file WHERE bmq01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i109_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW i109_w AT p_row,p_col WITH FORM "abm/42f/abmi109"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    #FUN-560027................begin
    CALL cl_set_comp_visible("bmq910",g_sma.sma118='Y')
    #FUN-560027................end
 
   #CHI-720014-begin-add
    IF NOT cl_null(g_argv1) THEN 
      CALL i109_q()
    END IF   
   #CHI-720014-end-add
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i109_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i109_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION i109_cs()
    CLEAR FORM
   IF cl_null(g_argv1) THEN                  #CHI-720014 add
   INITIALIZE g_bmq.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        bmq01,  bmq02,  bmq021, bmq05,  bmq06,   #CHI-6B0035 bmq06與bmq08換順序
        bmq08,bmq910,  bmq25,  bmq63, bmq55, bmq44, bmq15, bmq105,bmq903,bmq107,bmq147, bmq37, #FUN-560027 add bmq910
        bmq103, bmq53,  bmq531, bmq91,
        bmquser, bmqgrup, bmqmodu, bmqdate,bmqacti, 
        #FUN-840042   ---start---
        bmqud01,bmqud02,bmqud03,bmqud04,bmqud05,
        bmqud06,bmqud07,bmqud08,bmqud09,bmqud10,
        bmqud11,bmqud12,bmqud13,bmqud14,bmqud15
        ,bmqorig,bmqoriu                              #No.TQC-AB0052  
        #FUN-840042    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp     #查詢條件
           CASE
             #FUN-6B0026-begin-add
              WHEN INFIELD(bmq01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bmq"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bmq.bmq01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bmq01
                 NEXT FIELD bmq01
             #FUN-6B0026-end-add
              WHEN INFIELD(bmq06)
#                CALL q_imz(10,10,g_bmq.bmq06) RETURNING g_bmq.bmq06
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imz"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bmq.bmq06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmq06
                 NEXT FIELD bmq06
              WHEN INFIELD(bmq25) #單位主檔
#                CALL q_gfe(10,44,g_bmq.bmq25) RETURNING g_bmq.bmq25
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bmq.bmq25
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmq25
                 NEXT FIELD bmq25
              WHEN INFIELD(bmq63) #單位主檔
#                CALL q_gfe(10,44,g_bmq.bmq63) RETURNING g_bmq.bmq63
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bmq.bmq63
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmq63
                 NEXT FIELD bmq63
              WHEN INFIELD(bmq55) #單位主檔
#                CALL q_gfe(10,44,g_bmq.bmq55) RETURNING g_bmq.bmq55
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bmq.bmq55
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmq55
                 NEXT FIELD bmq55
              WHEN INFIELD(bmq44) #單位主檔
#                CALL q_gfe(10,44,g_bmq.bmq44) RETURNING g_bmq.bmq44
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bmq.bmq44
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmq44
                 NEXT FIELD bmq44
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
##
  #CHI-720014-begin-add
   ELSE
    LET g_wc = " bmq01 ='",g_argv1,"'"
   END IF 
  #CHI-720014-end-add
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                 #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bmquser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                 #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bmqgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bmqgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmquser', 'bmqgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT bmq01 FROM bmq_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY bmq01"
    PREPARE i109_prepare FROM g_sql     # RUNTIME 編譯
    DECLARE i109_cs                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i109_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bmq_file WHERE ",g_wc CLIPPED
    PREPARE i109_precount FROM g_sql
    DECLARE i109_count CURSOR FOR i109_precount
END FUNCTION
 
FUNCTION i109_menu()
   DEFINE l_cmd	   LIKE type_file.chr50    #No.FUN-680096   VARCHAR(30)
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i109_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i109_q()
            END IF
        #No.TQC-740079 --begin
        ON ACTION invalid
            IF cl_chk_act_auth() THEN
               CALL i109_x()
            END IF
            DISPLAY "g_bmq.bmqacti=",g_bmq.bmqacti
            CALL cl_set_field_pic("","","","","",g_bmq.bmqacti)
        #No.TQC-740079 --end
        ON ACTION next
            CALL i109_fetch('N')
        ON ACTION previous
            CALL i109_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i109_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i109_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i109_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i109_out()
            END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_bmq.bmqacti)
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL i109_fetch('/')
        ON ACTION first
            CALL i109_fetch('F')
        ON ACTION last
            CALL i109_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
          ON ACTION related_document                   #MOD-470051
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_bmq.bmq01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmq01"
                  LET g_doc.value1  = g_bmq.bmq01
                  CALL cl_doc()
               END IF
            END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i109_cs
END FUNCTION
 
 
FUNCTION i109_a()
  DEFINE l_opc      LIKE ze_file.ze03,  #No.FUN-680096 VARCHAR(10)
         l_des      LIKE ze_file.ze03   #No.FUN-680096 VARCHAR(4) #TQC-840066
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bmq.* LIKE bmq_file.*
    LET g_wc = NULL
    LET g_bmq01_t = NULL
    LET g_bmq_t.*=g_bmq.*
    LET g_bmq_o.*=g_bmq.*
    LET g_bmq.bmq103 = 0
    LET g_bmq.bmq15  = 'N'
    LET g_bmq.bmq105  = 'N'
    LET g_bmq.bmq903 = 'N' #NO:7120
    LET g_bmq.bmq107  = 'N' #BugNo:6165
    LET g_bmq.bmq147  = 'N' #BugNo:6542
    LET g_bmq.bmq37  = '2'
    LET g_bmq.bmq53  = 0
    LET g_bmq.bmq531 = 0
    LET g_bmq.bmq91  = 0
    LET g_bmq.bmq103 = '0'
    CALL s_opc(g_bmq.bmq37)       RETURNING l_opc
    DISPLAY l_opc TO FORMONLY.opc
    CALL s_purdesc(g_bmq.bmq103)  RETURNING l_des
    DISPLAY l_des TO FORMONLY.des
    CALL cl_opmsg('a')
    BEGIN WORK
    WHILE TRUE
        LET g_bmq.bmqacti ='Y'
        LET g_bmq.bmquser = g_user
        LET g_bmq.bmqoriu = g_user #FUN-980030
        LET g_bmq.bmqorig = g_grup #FUN-980030
        LET g_bmq.bmqgrup = g_grup
        LET g_bmq.bmqdate = g_today
        CALL i109_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_bmq.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF g_bmq.bmq01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        #FUN-560027 add
        IF g_bmq.bmq910 IS NULL THEN
            LET g_bmq.bmq910 = ' '
        END IF
        #FUN-560027(end)
        INSERT INTO bmq_file VALUES(g_bmq.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
   #        CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("ins","bmq_file",g_bmq.bmq01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
            CONTINUE WHILE
        END IF
        LET g_bmq_t.* = g_bmq.*                # 保存上筆資料
        SELECT bmq01 INTO g_bmq.bmq01 FROM bmq_file
                    WHERE bmq01 = g_bmq.bmq01
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i109_i(p_cmd)
    DEFINE l_sc          LIKE type_file.chr12,     #LIKE cqo_file.cqo12,      #No.FUN-680096 VARCHAR(12)   #TQC-B90211
           l_opc         LIKE ze_file.ze03,        #No.FUN-680096 VARCHAR(10)
           l_des         LIKE ze_file.ze03,        #No.FUN-680096 VARCHAR(4) #TQC-840066
           p_cmd         LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_n           LIKE type_file.num5       #No.FUN-680096 SMALLINT
    DEFINE lc_sma119     LIKE sma_file.sma119,     #FUN-590078
           li_len        LIKE type_file.num5       #FUN-590078   #No.FUN-680096 SMALLINT
 
   #start FUN-590078 抓取參數設定(asms215)的設定料件編號資料長度(sma119)
    SELECT sma119 INTO lc_sma119 FROM sma_file
    CASE lc_sma119
       WHEN "0"
          LET li_len = 20
       WHEN "1"
          LET li_len = 30
       WHEN "2"
          LET li_len = 40
    END CASE
   #end FUN-590078
    DISPLAY BY NAME g_bmq.bmquser #TQC-B30036 
    INPUT BY NAME g_bmq.bmqoriu,g_bmq.bmqorig,
        g_bmq.bmq01, g_bmq.bmq02, g_bmq.bmq021,g_bmq.bmq05, g_bmq.bmq06,  #CHI-6B0035 bmq06與bmq08換順序
        g_bmq.bmq08, g_bmq.bmq910,g_bmq.bmq25, g_bmq.bmq63, g_bmq.bmq55,  #FUN-560027 add bmq910
        g_bmq.bmq44, g_bmq.bmq15, g_bmq.bmq105,g_bmq.bmq903,g_bmq.bmq107,
        g_bmq.bmq147,g_bmq.bmq37,#BugNo:6165 ,6542 add bmq147
        g_bmq.bmq103,g_bmq.bmq53, g_bmq.bmq531,g_bmq.bmq91,
        g_bmq.bmqgrup, g_bmq.bmqmodu, g_bmq.bmqdate, g_bmq.bmqacti,
        #FUN-840042     ---start---
        g_bmq.bmqud01,g_bmq.bmqud02,g_bmq.bmqud03,g_bmq.bmqud04,
        g_bmq.bmqud05,g_bmq.bmqud06,g_bmq.bmqud07,g_bmq.bmqud08,
        g_bmq.bmqud09,g_bmq.bmqud10,g_bmq.bmqud11,g_bmq.bmqud12,
        g_bmq.bmqud13,g_bmq.bmqud14,g_bmq.bmqud15 
        #FUN-840042     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i109_set_entry(p_cmd)
            CALL i109_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
           #start FUN-590078
            CALL cl_chg_comp_att("bmq01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
           #end FUN-590078
 
        AFTER FIELD bmq01
#FUN-AB0025 ------------------mark start----------------
#          #FUN-AA0059 ----------------------add start----------------
#          IF NOT cl_null(g_bmq.bmq01) THEN
#             IF NOT s_chk_item_no(g_bmq.bmq01,'') THEN
#                CALL cl_err('',g_errno,1) 
#                LET g_bmq.bmq01 = g_bmq01_t
#                DISPLAY BY NAME g_bmq.bmq01
#                NEXT FIELD bmq01
#             END IF 
#          END IF 
#          #FUN-AA0059 ---------------------add end----------------------      
#FUN-AB0025 --------------mark end-----------------
             IF g_type = '0' THEN   #No.MOD-530140  --begin
            IF g_bmq.bmq01 IS NOT NULL THEN
               select count(*) INTO l_n FROM ima_file
                WHERE ima01 = g_bmq.bmq01
               IF l_n > 0 THEN
                  CALL cl_err(g_bmq.bmq01,'mfg2759',0)
                  LET g_bmq.bmq01 = g_bmq01_t
                  DISPLAY BY NAME g_bmq.bmq01
                  NEXT FIELD bmq01
               END IF
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_bmq.bmq01 != g_bmq01_t) THEN
                  SELECT count(*) INTO l_n FROM bmq_file
                   WHERE bmq01 = g_bmq.bmq01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_bmq.bmq01,-239,0)
                     LET g_bmq.bmq01 = g_bmq01_t
                     DISPLAY BY NAME g_bmq.bmq01
                     NEXT FIELD bmq01
                  END IF
       	       END IF
            END IF
             END IF  #No.MOD-530140  --end
 
        BEFORE FIELD bmq08
            CALL i109_set_entry(p_cmd)
 
        AFTER FIELD bmq08  #來源碼
            IF g_bmq.bmq08 NOT MATCHES "[CTDAMPXKUVWRZS]"
            THEN CALL cl_err(g_bmq.bmq08,'mfg1001',0)
                    LET g_bmq.bmq08 = g_bmq_o.bmq08
                    DISPLAY BY NAME g_bmq.bmq08
                    NEXT FIELD bmq08
            END IF
            CALL s_soucode(g_bmq.bmq08)   RETURNING l_sc
            DISPLAY l_sc TO FORMONLY.sc
            LET g_bmq_o.bmq08 = g_bmq.bmq08
            IF g_bmq.bmq08 NOT MATCHES "[MT]" THEN
                IF g_bmq.bmq903 = 'Y' THEN
                    LET g_bmq.bmq903 = 'N'
                    DISPLAY BY NAME g_bmq.bmq903
                END IF
            END IF
            CALL i109_set_no_entry(p_cmd)
        #CHI-6B0035---add---str---
        ##no.6542
        #AFTER FIELD bmq06
        #    IF NOT cl_null(g_bmq.bmq06) THEN
        #       CALL i109_bmq06('a')
        #       IF NOT cl_null(g_errno) THEN
        #          CALL cl_err('',g_errno,1)
        #          NEXT FIELD bmq06
        #       END IF
        #    END IF
        ##no.6542(end)
        AFTER FIELD bmq06                     #分群碼
          IF g_bmq.bmq06 IS NOT NULL AND  g_bmq.bmq06 != ' '
              THEN  #MOD-490474
                   #No:7062
                   IF (g_bmq_o.bmq06 IS NULL) OR (g_bmq.bmq06 != g_bmq_o.bmq06) THEN #MOD-490474
                      IF p_cmd='u' THEN #FUN-650045
                         CALL s_chkitmdel(g_bmq.bmq01) RETURNING g_errno
                      ELSE
                         LET g_errno=NULL
                      END IF
                      IF cl_null(g_errno) THEN #FUN-650045
                         LET g_ans=''
                         CALL abmi109_bmq06('Y') #default 預設值
                         IF g_ans="1" THEN #TQC-690074
                            #FUN-640260 ...............begin
                            IF NOT i109_chk_rel_bmq06(p_cmd) THEN
                               LET g_bmq_o.bmq06 = g_bmq.bmq06   
                       #TQC-6C0026 add  
                       #後面有要用到g_bmq_o.bmq06判斷,所以這邊要先給值
                               NEXT FIELD bmq06
                            END IF
                            #FUN-640260 ...............end
                         END IF
                      ELSE
                         #CHI-6B0073................begin
                         IF NOT cl_null(g_errno) THEN
                            CALL cl_err('',g_errno,1) #只提示
                         END IF
                         #CHI-6B0073................end
                         CALL abmi109_bmq06('N') #只check 對錯,不詢問
                        #CHI-6B0073.................begin #不帶相關預設值,不需檢查預設值正確與否
                        ##FUN-640260 ...............begin
                        #IF NOT i109_chk_rel_bmq06(p_cmd) THEN
                        #   LET g_bmq_o.bmq06 = g_bmq.bmq06 
                        #TQC-6C0026 add   
                        #後面有要用到g_bmq_o.bmq06判斷,所以這邊要先給值p
                        #   NEXT FIELD bmq06
                        #END IF
                        #CHI-6B0073.................end
                         #FUN-640260 ...............end
                      END IF
                   ELSE
                      CALL abmi109_bmq06('N') #只check 對錯,不詢問
                     #CHI-6B0073.................begin #不帶相關預設值,不需檢查預設值正確與否
                     ##FUN-640260 ...............begin
                     #IF NOT i109_chk_rel_bmq06(p_cmd) THEN
                     #   LET g_bmq_o.bmq06 = g_bmq.bmq06   #TQC-6C0026 add   #後面有要用到g_bmq_o.bmq06判斷,所以這邊要先給值
                     #   NEXT FIELD bmq06
                     #END IF
                     ##FUN-640260 ...............end
                     #CHI-6B0073.................end
                   END IF #No:7062
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_bmq.bmq06,g_errno,0)
                      LET g_bmq.bmq06 = g_bmq_o.bmq06
                      DISPLAY BY NAME g_bmq.bmq06
                      NEXT FIELD bmq06
                   END IF
                    #MOD-490474
            END IF
            LET g_bmq_o.bmq06 = g_bmq.bmq06
 
        #CHI-6B0035---add---end---
 
        #FUN-560027 add
        AFTER FIELD bmq910
           IF g_bmq.bmq910 IS NULL THEN
               LET g_bmq.bmq910 = ' '
           END IF
        #FUN-560027(end)
        AFTER FIELD bmq25  #庫存單位
            IF g_bmq.bmq25 IS NOT NULL THEN
               IF (g_bmq_o.bmq25 IS NULL) OR (g_bmq_o.bmq25 != g_bmq.bmq25)
               THEN SELECT gfe01 FROM gfe_file
                     WHERE gfe01=g_bmq.bmq25 AND gfeacti IN ('y','Y')
                        IF SQLCA.sqlcode THEN
                       #   CALL cl_err(g_bmq.bmq25,'mfg1200',0) #No.TQC-660046
                           CALL cl_err3("sel","gfe_file",g_bmq.bmq25,"","mfg1200","","",1)   #No.TQC-660046 
                           LET g_bmq.bmq25 = g_bmq_o.bmq25
                           DISPLAY BY NAME g_bmq.bmq25
                           NEXT FIELD bmq25
                        END IF
               END IF
               IF cl_null(g_bmq.bmq63) THEN
                  LET g_bmq.bmq63 = g_bmq.bmq25
                  LET g_bmq.bmq63_fac = 1      #MOD-AC0075 add
                  DISPLAY BY NAME g_bmq.bmq63
              #MOD-AC0075---add---start---
               ELSE
                  IF g_bmq.bmq63 != g_bmq.bmq25 THEN
                     CALL s_umfchk(g_bmq.bmq01,g_bmq.bmq63,g_bmq.bmq25)
                          RETURNING g_sw,g_bmq.bmq63_fac
                     IF g_sw THEN
                        CALL cl_err(g_bmq.bmq25,'mfg1206',0)
                        NEXT FIELD bmq25 
                     END IF
                  END IF
              #MOD-AC0075---add---end---
               END IF
               IF cl_null(g_bmq.bmq55) THEN
                  LET g_bmq.bmq55 = g_bmq.bmq25
                  LET g_bmq.bmq55_fac = 1      #MOD-AC0075 add
                  DISPLAY BY NAME g_bmq.bmq55
              #MOD-AC0075---add---start---
               ELSE
                  IF g_bmq.bmq55 != g_bmq.bmq25 THEN
                     CALL s_umfchk(g_bmq.bmq01,g_bmq.bmq55,g_bmq.bmq25)
                          RETURNING g_sw,g_bmq.bmq55_fac
                     IF g_sw THEN
                        CALL cl_err(g_bmq.bmq25,'mfg1206',0)
                        NEXT FIELD bmq25 
                     END IF
                  END IF
              #MOD-AC0075---add---end---
               END IF
               IF cl_null(g_bmq.bmq44) THEN
                  LET g_bmq.bmq44 = g_bmq.bmq25
                  LET g_bmq.bmq44_fac = 1      #MOD-AC0075 add
                  DISPLAY BY NAME g_bmq.bmq44
              #MOD-AC0075---add---start---
               ELSE
                  IF g_bmq.bmq44 != g_bmq.bmq25 THEN
                     CALL s_umfchk(g_bmq.bmq01,g_bmq.bmq44,g_bmq.bmq25)
                          RETURNING g_sw,g_bmq.bmq44_fac
                     IF g_sw THEN
                        CALL cl_err(g_bmq.bmq25,'mfg1206',0)
                        NEXT FIELD bmq25 
                     END IF
                  END IF
              #MOD-AC0075---add---end---
               END IF
               LET g_bmq.bmq31 = g_bmq.bmq25
               LET g_bmq.bmq31_fac = 1
               LET g_bmq_o.bmq25 = g_bmq.bmq25
            END IF
 
        AFTER FIELD bmq63  #發料單位
            IF g_bmq.bmq63 IS NOT NULL THEN
               IF (g_bmq_o.bmq63 IS NULL) OR (g_bmq_o.bmq63 != g_bmq.bmq63)
               THEN CALL i109_unit(g_bmq.bmq63)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_bmq.bmq63,'mfg1200',0)
                       LET g_bmq.bmq63 = g_bmq_o.bmq63
                       DISPLAY BY NAME g_bmq.bmq63
                       NEXT FIELD bmq63
                    ELSE IF g_bmq.bmq63 = g_bmq.bmq25
                         THEN LET g_bmq.bmq63_fac = 1
                         ELSE CALL s_umfchk(g_bmq.bmq01,g_bmq.bmq63,g_bmq.bmq25)
                                    RETURNING g_sw,g_bmq.bmq63_fac
                              IF g_sw THEN
                                 CALL cl_err(g_bmq.bmq63,'mfg1206',0)
                                 LET g_bmq.bmq63 = g_bmq_o.bmq63
                                 NEXT FIELD bmq63
                              END IF
                         END IF
                    END IF
               END IF
               LET g_bmq_o.bmq63 = g_bmq.bmq63
            END IF
 
        AFTER FIELD bmq55  #生產單位
            IF g_bmq.bmq55 IS NOT NULL THEN
               IF (g_bmq_o.bmq55 IS NULL) OR (g_bmq_o.bmq55 != g_bmq.bmq55)
               THEN CALL i109_unit(g_bmq.bmq55)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_bmq.bmq55,'mfg1200',0) 
                       LET g_bmq.bmq55 = g_bmq_o.bmq55
                       DISPLAY BY NAME g_bmq.bmq55
                       NEXT FIELD bmq55
                    ELSE IF g_bmq.bmq55 = g_bmq.bmq25
                         THEN LET g_bmq.bmq55_fac = 1
                         ELSE CALL s_umfchk(g_bmq.bmq01,g_bmq.bmq55,g_bmq.bmq25)
                                    RETURNING g_sw,g_bmq.bmq55_fac
                              IF g_sw THEN
                                 CALL cl_err(g_bmq.bmq55,'mfg1206',0)
                                 LET g_bmq.bmq55 = g_bmq_o.bmq55
                                 NEXT FIELD bmq55
                              END IF
                         END IF
                    END IF
               END IF
               LET g_bmq_o.bmq55 = g_bmq.bmq55
            END IF
 
        AFTER FIELD bmq44  #採購單位
            IF g_bmq.bmq44 IS NOT NULL THEN
               IF (g_bmq_o.bmq44 IS NULL) OR (g_bmq_o.bmq44 != g_bmq.bmq44)
               THEN CALL i109_unit(g_bmq.bmq44)
                    IF NOT cl_null(g_errno) THEN
             #         CALL cl_err(g_bmq.bmq44,'mfg1200',0) #No.TQC-660046
                       CALL cl_err3("sel","gfe_file",g_bmq.bmq44,"","mfg1200","","",1)   #No.TQC-660046
                       LET g_bmq.bmq44 = g_bmq_o.bmq44
                       DISPLAY BY NAME g_bmq.bmq44
                       NEXT FIELD bmq44
                    ELSE IF g_bmq.bmq44 = g_bmq.bmq25
                         THEN LET g_bmq.bmq44_fac = 1
                         ELSE CALL s_umfchk(g_bmq.bmq01,g_bmq.bmq44,g_bmq.bmq25)
                                    RETURNING g_sw,g_bmq.bmq44_fac
                              IF g_sw THEN
                                 CALL cl_err(g_bmq.bmq44,'mfg1206',0)
                                 LET g_bmq.bmq44 = g_bmq_o.bmq44
                                 NEXT FIELD bmq44
                              END IF
                         END IF
                    END IF
               END IF
               LET g_bmq_o.bmq44 = g_bmq.bmq44
            END IF
 
        AFTER FIELD bmq903 #BugNo:7120
            IF g_bmq.bmq903 IS NOT NULL THEN
               IF g_bmq.bmq903 = 'Y' AND g_bmq.bmq08 NOT MATCHES "[MT]" THEN
                  LET g_bmq.bmq903 = 'N'
                  DISPLAY BY NAME g_bmq.bmq903
                  CALL cl_err('','abm-608',0)
               END IF
            END IF
 
        AFTER FIELD bmq37  #補貨策略碼
            IF g_bmq.bmq37 IS NOT NULL THEN
               IF g_bmq.bmq37 NOT MATCHES "[012345]"
               THEN CALL cl_err(g_bmq.bmq37,'mfg1003',0)
                    LET g_bmq.bmq37 = g_bmq_o.bmq37
                    DISPLAY BY NAME g_bmq.bmq37
                    NEXT FIELD bmq37
               END IF
               #--->補貨策略碼為'0'(再訂購點),'5'(期間採購)
               IF ( g_bmq.bmq37='0' OR g_bmq.bmq37 ='5' )
                  AND ( g_bmq.bmq08 NOT MATCHES '[PVZ]' )
               THEN CALL cl_err(g_bmq.bmq37,'mfg3201',1)  #MOD-890089 0->1
                    LET g_bmq.bmq37 = g_bmq_o.bmq37
                    DISPLAY BY NAME g_bmq.bmq37
                    NEXT FIELD bmq37
               END IF
               CALL s_opc(g_bmq.bmq37)       RETURNING l_opc
               DISPLAY l_opc TO FORMONLY.opc
               LET g_bmq_o.bmq37 = g_bmq.bmq37
            END IF
 
       AFTER FIELD bmq103
            IF g_bmq.bmq103 NOT MATCHES'[012]'
            THEN  NEXT FIELD bmq103
            END IF
            CALL s_purdesc(g_bmq.bmq103)  RETURNING l_des
            DISPLAY l_des TO FORMONLY.des
 
       #FUN-840042     ---start---
       AFTER FIELD bmqud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD bmqud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #FUN-840042     ----end----
 
        AFTER INPUT
           LET g_bmq.bmquser = s_get_data_owner("bmq_file") #FUN-C10039
           LET g_bmq.bmqgrup = s_get_data_group("bmq_file") #FUN-C10039
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            #--->補貨策略碼為'0'(再訂購點),'5'(期間採購)
            IF ( g_bmq.bmq37='0' OR g_bmq.bmq37 ='5' )
               AND ( g_bmq.bmq08 NOT MATCHES '[PVZ]' )
            THEN CALL cl_err(g_bmq.bmq37,'mfg3201',1)  #MOD-890089 0->1
                 LET g_flag='Y'
                 DISPLAY BY NAME g_bmq.bmq08
                 DISPLAY BY NAME g_bmq.bmq37
                 NEXT FIELD bmq37   #MOD-890089 add
            END IF
            #FUN-560027 add
            IF g_bmq.bmq910 IS NULL THEN
                LET g_bmq.bmq910 = ' '
            END IF
            #FUN-560027(end)
 
            IF g_bmq.bmq08 IS NULL THEN  #來源碼
               LET g_flag='Y'
               DISPLAY BY NAME g_bmq.bmq08
            END IF
            IF g_bmq.bmq37 IS NULL THEN  #OPC
               LET g_flag='Y'
               DISPLAY BY NAME g_bmq.bmq37
            END IF
            IF g_bmq.bmq25 IS NULL THEN  #庫存單位
               LET g_flag='Y'
               DISPLAY BY NAME g_bmq.bmq25
            END IF
            IF g_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD bmq01
            END IF
 
    #   ON ACTION mntn_unit #單位換算
    #              CALL cl_cmdrun("aooi101 ")
 
        ON ACTION controlp     #查詢條件
            CASE
             #FUN-6B0026-begin-add
              WHEN INFIELD(bmq01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bmq"
                 LET g_qryparam.default1 = g_bmq.bmq01
                 CALL cl_create_qry() RETURNING g_bmq.bmq01 
                 DISPLAY BY NAME g_bmq.bmq01
                 NEXT FIELD bmq01
             #FUN-6B0026-end-add
               WHEN INFIELD(bmq06)
#                 CALL q_imz(10,10,g_bmq.bmq06) RETURNING g_bmq.bmq06
#                 CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq06 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imz"
                  LET g_qryparam.default1 = g_bmq.bmq06
                  CALL cl_create_qry() RETURNING g_bmq.bmq06
#                  CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq06 )
                  DISPLAY BY NAME g_bmq.bmq06
                  NEXT FIELD bmq06
               WHEN INFIELD(bmq25) #單位主檔
#                 CALL q_gfe(10,44,g_bmq.bmq25) RETURNING g_bmq.bmq25
#                 CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq25 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmq.bmq25
                  CALL cl_create_qry() RETURNING g_bmq.bmq25
#                  CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq25 )
                  DISPLAY BY NAME g_bmq.bmq25
                  NEXT FIELD bmq25
               WHEN INFIELD(bmq63) #單位主檔
#                 CALL q_gfe(10,44,g_bmq.bmq63) RETURNING g_bmq.bmq63
#                 CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq63 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmq.bmq63
                  CALL cl_create_qry() RETURNING g_bmq.bmq63
#                  CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq63 )
                  DISPLAY BY NAME g_bmq.bmq63
                  NEXT FIELD bmq63
               WHEN INFIELD(bmq55) #單位主檔
#                 CALL q_gfe(10,44,g_bmq.bmq55) RETURNING g_bmq.bmq55
#                 CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq55 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmq.bmq55
                  CALL cl_create_qry() RETURNING g_bmq.bmq55
#                  CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq55 )
                  DISPLAY BY NAME g_bmq.bmq55
                  NEXT FIELD bmq55
               WHEN INFIELD(bmq44) #單位主檔
#                 CALL q_gfe(10,44,g_bmq.bmq44) RETURNING g_bmq.bmq44
#                 CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq44 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_bmq.bmq44
                  CALL cl_create_qry() RETURNING g_bmq.bmq44
#                  CALL FGL_DIALOG_SETBUFFER( g_bmq.bmq44 )
                  DISPLAY BY NAME g_bmq.bmq44
                  NEXT FIELD bmq44
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
 
#CHI-6B0035---add---str--- 
FUNCTION abmi109_bmq06(p_def) 
   DEFINE
               p_def          LIKE type_file.chr1, #CHI-720014 modify VARCHAR(01), 
               l_msg          LIKE type_file.chr1000,  #CHI-720014 modify VARCHAR(57),
               l_imz02        LIKE imz_file.imz02,
               l_imzacti      LIKE imz_file.imzacti,
               l_bmqacti      LIKE bmq_file.bmqacti,
               l_bmquser      LIKE bmq_file.bmquser,
               l_bmqgrup      LIKE bmq_file.bmqgrup,
               l_bmqmodu      LIKE bmq_file.bmqmodu,
               l_bmqdate      LIKE bmq_file.bmqdate
 
   LET g_errno = ' '
   LET g_ans=' ' 
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_bmq.bmq06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN 
      #當輸入值與舊值不同時,才開出訊問視窗
      IF cl_null(g_bmq_o.bmq06) OR g_bmq_o.bmq06 != g_bmq.bmq06 THEN   
         CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
         CALL cl_confirm('mfg5033') RETURNING g_ans 
         IF g_ans THEN 
             SELECT imz01,imz08,imz09,imz10,imz11,imz12,imz15,imz25,
                    imz31,imz31_fac,imz37,imz44,imz44_fac,imz55,imz55_fac,
                    imz63,imz63_fac,imz103,imz105,imz107,imz147,imz903,
                    imzacti,imzuser,imzgrup,imzmodu,imzdate
             INTO   g_bmq.bmq06,g_bmq.bmq08,g_bmq.bmq09,g_bmq.bmq10,
                         g_bmq.bmq11,g_bmq.bmq12,g_bmq.bmq15,g_bmq.bmq25,
                         g_bmq.bmq31,g_bmq.bmq31_fac,g_bmq.bmq37,g_bmq.bmq44,
                         g_bmq.bmq44_fac,g_bmq.bmq55,g_bmq.bmq55_fac,
                         g_bmq.bmq63, g_bmq.bmq63_fac,g_bmq.bmq103,g_bmq.bmq105,  
                         g_bmq.bmq107,g_bmq.bmq147,g_bmq.bmq903,
                         l_bmqacti,l_bmquser,l_bmqgrup,l_bmqmodu,l_bmqdate
                    FROM  imz_file
                    WHERE imz01 = g_bmq.bmq06
 
         IF cl_null(g_errno)  AND g_ans ="1"  THEN   
            CALL i109_show()
         END IF
      END IF   
     END IF
  END IF
END FUNCTION
#CHI-6B0035---add---end---
 
#CHI-6B0035---add---str---
FUNCTION i109_chk_rel_bmq06(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #CHI-720014 modify VARCHAR(1)
   IF NOT i109_chk_bmq09() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq10() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq11() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq12() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq25() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq31() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq44() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq55() THEN
      RETURN FALSE
   END IF
   IF NOT i109_chk_bmq63() THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
 
FUNCTION i109_chk_bmq09()
   IF cl_null(g_bmq.bmq09) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
   WHERE azf01=g_bmq.bmq09 AND azf02='D' 
     AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
#     CALL cl_err(g_bmq.bmq09,'mfg1306',1) #No.FUN-660156 MARK
      CALL cl_err3("sel","azf_file",g_bmq.bmq09,"","mfg1306","","",1)  #No.FUN-660156
      LET g_bmq.bmq09 = g_bmq_o.bmq09
      DISPLAY BY NAME g_bmq.bmq09
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i109_chk_bmq10()
   IF cl_null(g_bmq.bmq10) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
   WHERE azf01=g_bmq.bmq10 AND azf02='E' #6818
     AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
#     CALL cl_err(g_bmq.bmq10,'mfg1306',1) #No.FUN-660156 MARK
      CALL cl_err3("sel","azf_file",g_bmq.bmq10,"","mfg1306","","",1)  #No.FUN-660156
      LET g_bmq.bmq10 = g_bmq_o.bmq10
      DISPLAY BY NAME g_bmq.bmq10
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
 
FUNCTION i109_chk_bmq11()
   IF cl_null(g_bmq.bmq11) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_bmq.bmq11 AND azf02='F' 
        AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
#     CALL cl_err(g_bmq.bmq11,'mfg1306',1) #No.FUN-660156 MARK
      CALL cl_err3("sel","azf_file",g_bmq.bmq11,"","mfg1306","","",1)  #No.FUN-660156
      LET g_bmq.bmq11 = g_bmq_o.bmq11
      DISPLAY BY NAME g_bmq.bmq11
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
 
FUNCTION i109_chk_bmq12()
   IF cl_null(g_bmq.bmq12) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_bmq.bmq12 AND azf02='G' 
        AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
#     CALL cl_err(g_bmq.bmq12,'mfg1306',1)   #No.FUN-660156 MARK
      CALL cl_err3("sel","azf_file",g_bmq.bmq12,"","mfg1306","","",1)  #No.FUN-660156
      LET g_bmq.bmq12 = g_bmq_o.bmq12
      DISPLAY BY NAME g_bmq.bmq12
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i109_chk_bmq25()
   IF cl_null(g_bmq.bmq25) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
     WHERE gfe01=g_bmq.bmq25
       AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bmq.bmq25,'mfg1200',1) #No.FUN-660156 MARK
      CALL cl_err3("sel","gfe_file",g_bmq.bmq25,"","mfg1200","","",1)  #No.FUN-660156
      DISPLAY BY NAME g_bmq.bmq25
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
 
FUNCTION i109_chk_bmq31()
   IF cl_null(g_bmq.bmq31) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_bmq.bmq31
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bmq.bmq31,'mfg1311',1) #No.FUN-660156 MARK
      CALL cl_err3("sel","gfe_file",g_bmq.bmq31,"","mfg1311","","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i109_chk_bmq44()
   IF cl_null(g_bmq.bmq44) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
      WHERE gfe01=g_bmq.bmq44
        AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bmq.bmq44,'apm-047',1)  #No.FUN-660156 MARK
      CALL cl_err3("sel","gfe_file",g_bmq.bmq44,"","apm-047","","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i109_chk_bmq55()
   IF cl_null(g_bmq.bmq55) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_bmq.bmq55
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bmq.bmq55,'mfg1325',1)  #No.FUN-660156 MARK
      CALL cl_err3("sel","gfe_file",g_bmq.bmq55,"","mfg1325","","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i109_chk_bmq63()
   IF cl_null(g_bmq.bmq63) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_bmq.bmq63
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bmq.bmq63,'mfg1326',1)   #No.FUN-660156 MARK
      CALL cl_err3("sel","gfe_file",g_bmq.bmq63,"","mfg1326","","",1)  #No.FUN-660156
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
#CHI-6B0035---add---end---
 
FUNCTION i109_unit(p_unit)
  DEFINE  p_unit     LIKE bmq_file.bmq25,
          l_gfe01    LIKE gfe_file.gfe01,
          l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = ' '
  SELECT gfe01,gfeacti
    INTO l_gfe01,l_gfeacti
    FROM gfe_file
   WHERE gfe01=p_unit
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1200'
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i109_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    #INITIALIZE g_bmq.* TO NULL             #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i109_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i109_count
    FETCH i109_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i109_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0)
        INITIALIZE g_bmq.* TO NULL
    ELSE
        CALL i109_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i109_fetch(p_flbmq)
    DEFINE
        p_flbmq    LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    CASE p_flbmq
        WHEN 'N' FETCH NEXT     i109_cs INTO g_bmq.bmq01
        WHEN 'P' FETCH PREVIOUS i109_cs INTO g_bmq.bmq01
        WHEN 'F' FETCH FIRST    i109_cs INTO g_bmq.bmq01
        WHEN 'L' FETCH LAST     i109_cs INTO g_bmq.bmq01
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i109_cs INTO g_bmq.bmq01
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0)
        INITIALIZE g_bmq.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbmq
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_bmq.* FROM bmq_file
       WHERE bmq01 = g_bmq.bmq01
    IF SQLCA.sqlcode THEN
  #     CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bmq_file",g_bmq.bmq01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
    ELSE
         LET g_data_owner = g_bmq.bmquser #MOD-4C0054
         LET g_data_group = g_bmq.bmqgrup #MOD-4C0054
        CALL i109_show()
    END IF
END FUNCTION
 
FUNCTION i109_show()
  DEFINE l_sc       LIKE zaa_file.zaa08,  #No.FUN-680096 VARCHAR(12)
         l_opc      LIKE ze_file.ze03,    #No.FUN-680096 VARCHAR(10)
         l_des      LIKE ze_file.ze03     #No.FUN-680096 VARCHAR(4)
 
    LET g_bmq_t.* = g_bmq.*
    DISPLAY BY NAME g_bmq.bmqoriu,g_bmq.bmqorig,
        g_bmq.bmq01, g_bmq.bmq011,g_bmq.bmq02, g_bmq.bmq021,
        g_bmq.bmq05, g_bmq.bmq06,  #CHI-6B0035 bmp06與bmq08換順序
        g_bmq.bmq08, g_bmq.bmq910,g_bmq.bmq25, g_bmq.bmq63, g_bmq.bmq55,  #FUN-560027 add bmq910
        g_bmq.bmq44, g_bmq.bmq15, g_bmq.bmq105,g_bmq.bmq903,g_bmq.bmq107,g_bmq.bmq147,g_bmq.bmq37,#BugNo:6165,6542 add bmq147
        g_bmq.bmq103,g_bmq.bmq53, g_bmq.bmq531,g_bmq.bmq91,g_bmq.bmquser,
        g_bmq.bmqgrup, g_bmq.bmqmodu, g_bmq.bmqdate, g_bmq.bmqacti,
        #FUN-840042     ---start---
        g_bmq.bmqud01,g_bmq.bmqud02,g_bmq.bmqud03,g_bmq.bmqud04,
        g_bmq.bmqud05,g_bmq.bmqud06,g_bmq.bmqud07,g_bmq.bmqud08,
        g_bmq.bmqud09,g_bmq.bmqud10,g_bmq.bmqud11,g_bmq.bmqud12,
        g_bmq.bmqud13,g_bmq.bmqud14,g_bmq.bmqud15 
        #FUN-840042     ----end----
  
    #-->OPC code
    CALL s_soucode(g_bmq.bmq08)   RETURNING l_sc
     #DISPLAY l_sc TO FORMONLY.sc   #No.MOD-530140
    #-->OPC code
    CALL s_opc(g_bmq.bmq37)       RETURNING l_opc
     #DISPLAY l_opc TO FORMONLY.opc   #No.MOD-530140
    #-->購料特性
    CALL s_purdesc(g_bmq.bmq103)  RETURNING l_des
     #DISPLAY l_des TO FORMONLY.des   #No.MOD-530140
    CALL cl_set_field_pic("","","","","",g_bmq.bmqacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i109_bmq06(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 DEFINE l_imzacti  LIKE imz_file.imzacti
 LET g_errno = ""
 SELECT imzacti INTO l_imzacti FROM imz_file WHERE imz01 = g_bmq.bmq06
 CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
      WHEN l_imzacti='N' LET g_errno = '9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
 END CASE
END FUNCTION
 
FUNCTION i109_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bmq.bmq01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #-->檢查資料是否為無效
    IF g_bmq.bmqacti ='N' THEN
        CALL cl_err(g_bmq.bmq01,'mfg1000',0)
        RETURN
    END IF
    #-->已轉成正式BOM
    IF g_bmq.bmq011 IS NOT NULL AND g_bmq.bmq011 != ' '
    THEN CALL cl_err(g_bmq.bmq011,'mfg2762',0)
         RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmq01_t = g_bmq.bmq01
    BEGIN WORK
 
    OPEN i109_cl USING g_bmq.bmq01
 
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_bmq.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_bmq.bmqmodu=g_user                     #修改者
    LET g_bmq.bmqdate = g_today                  #修改日期
    CALL i109_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_bmq_o.* = g_bmq.*
        CALL i109_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmq.*=g_bmq_t.*
            CALL i109_show()
            CALL cl_err(g_bmq.bmq01,9001,0)
            EXIT WHILE
        END IF
        UPDATE bmq_file SET bmq_file.* = g_bmq.*
         WHERE bmq01 = g_bmq01_t
        IF SQLCA.sqlcode THEN
     #      CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("upd","bmq_file",g_bmq01_t,"",SQLCA.sqlcode,"","",1)      #No.TQC-660046
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION
 
#No.TQC-740079 --begin
FUNCTION i109_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_bmq.bmq01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i109_cl USING g_bmq.bmq01
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_bmq.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i109_show()
    IF cl_exp(0,0,g_bmq.bmqacti) THEN
        LET g_chr=g_bmq.bmqacti
        IF g_bmq.bmqacti='Y' THEN
            LET g_bmq.bmqacti='N'
        ELSE
            LET g_bmq.bmqacti='Y'
        END IF
        UPDATE bmq_file                    #更改有效碼
            SET bmqacti=g_bmq.bmqacti
            WHERE bmq01=g_bmq.bmq01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmq_file",g_bmq.bmq01,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
            LET g_bmq.bmqacti=g_chr
        END IF
        DISPLAY BY NAME g_bmq.bmqacti
    END IF
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION
#No.TQC-740079 --end
 
FUNCTION i109_r()
    DEFINE l_chr LIKE type_file.chr1,         #No.FUN-680096 VARCHAR(1)
           l_cnt LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmq.bmq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_bmq.bmq011 is not null and g_bmq.bmq011 != ' '
    THEN CALL cl_err(g_bmq.bmq01,'mfg1338',0)
         RETURN
    END IF
    #No.TQC-920091 add --begin
    IF g_bmq.bmqacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
    #No.TQC-920091 add --end
    #-->單頭是否存在
    SELECT count(*) INTO l_cnt FROM bmo_file WHERE bmo01 = g_bmq.bmq01
    IF l_cnt > 0 THEN CALL cl_err(g_bmq.bmq01,'mfg1339',0) RETURN END IF
    #-->單身是否存在
    SELECT count(*) INTO l_cnt FROM bmp_file WHERE bmp03 = g_bmq.bmq01
    IF l_cnt > 0 THEN CALL cl_err(g_bmq.bmq01,'mfg1340',0) RETURN END IF
    BEGIN WORK
 
    OPEN i109_cl USING g_bmq.bmq01
 
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_bmq.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0) RETURN END IF
    CALL i109_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmq01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bmq.bmq01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
        DELETE FROM bmq_file WHERE bmq01=g_bmq.bmq01
        IF SQLCA.SQLERRD[3]=0 THEN
      #    CALL cl_err(g_bmq.bmq01,SQLCA.sqlcode,0) #No.TQC-660046
           CALL cl_err3("del","bmq_file",g_bmq.bmq01,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
        ELSE
           CLEAR FORM
           INITIALIZE g_bmq.* TO NULL
            OPEN i109_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i109_cs
               CLOSE i109_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i109_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i109_cs
               CLOSE i109_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i109_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i109_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i109_fetch('/')
            END IF
        END IF
    END IF
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i109_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680096 SMALLINT
        l_bmq		RECORD LIKE bmq_file.*,
        l_oldno         LIKE bmq_file.bmq01,
        l_newno         LIKE bmq_file.bmq01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmq.bmq01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i109_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM bmq01
	    BEFORE FIELD bmq01  # 是否可以修改 key
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(9,19,l_newno) RETURNING l_newno
	                 DISPLAY l_newno TO bmq01
            END IF
        AFTER FIELD bmq01
            IF NOT cl_null(l_newno) THEN
#FUN-AB0025 ------------------mark start--------------
#              #FUN-AA0059 -----------------------add start--------------------
#              IF NOT s_chk_item_no(l_newno,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 NEXT FIELD bmq01
#              END IF 
#              #FUN-AA0059 -----------------------add end---------------------    
#FUN-AB0025 -----------------mark end---------------------
               SELECT count(*) INTO g_cnt FROM bmq_file
                WHERE bmq01 = l_newno
               IF g_cnt > 0 THEN
                  CALL cl_err(l_newno,-239,0)
                  NEXT FIELD bmq01
               END IF
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
        DISPLAY BY NAME g_bmq.bmq01
        RETURN
    END IF
    LET l_bmq.* = g_bmq.*
    LET l_bmq.bmq901 = g_today  #料件建檔日期
 #  LET l_bmq.bmq011 = ' '   #TQC-C50009
    LET l_bmq.bmq011 = ''    #TQC-C50009 
    LET l_bmq.bmq01 = l_newno
    LET l_bmq.bmquser=g_user    #資料所有者
    LET l_bmq.bmqgrup=g_grup    #資料所有者所屬群
    LET l_bmq.bmqmodu=NULL      #資料修改日期
    LET l_bmq.bmqdate=g_today   #資料建立日期
    LET l_bmq.bmqacti='Y'       #有效資料
    LET l_bmq.bmqoriu = g_user      #No.FUN-980030 10/01/04
    LET l_bmq.bmqorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO bmq_file VALUES(l_bmq.*)
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(l_newno,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","bmq_file",l_bmq.bmq01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_bmq.bmq01
        SELECT bmq_file.* INTO g_bmq.* FROM bmq_file
                       WHERE bmq01 = l_newno
        CALL i109_u()
        #FUN-C30027---begin
        #SELECT bmq_file.* INTO g_bmq.* FROM bmq_file
        #               WHERE bmq01 = l_oldno
        #CALL i109_show()
        #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_bmq.bmq01
END FUNCTION
 
FUNCTION i109_out()
    DEFINE
        sr    RECORD
                  bmq  RECORD LIKE bmq_file.*
             END RECORD,
        l_i             LIKE type_file.num5,     #No.FUN-680096 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)
        l_chr           LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
        LET g_wc=" bmq01='",g_bmq.bmq01,"'"
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abmi109') RETURNING l_name                   #FUN-770052
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bmq_file.* ",
              " FROM bmq_file ",
              " WHERE ",g_wc CLIPPED
{   PREPARE i109_p1 FROM g_sql                # RUNTIME 編譯     #FUN-770052
    DECLARE i109_curo                         # CURSOR
        CURSOR FOR i109_p1
 
    START REPORT i109_rep TO l_name
 
    FOREACH i109_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i109_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i109_rep
 
    CLOSE i109_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)  }                        #FUN-770052
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'bmq01')                                                                         
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
    LET g_str=''                                                #FUN-770052
    LET g_str=g_wc                                              #FUN-770052
    CALL cl_prt_cs1('abmi109','abmi109',g_sql,g_str)            #FUN-770052
END FUNCTION
 
{ REPORT i109_rep(sr)                                           #FUN-770052
    DEFINE
        sr    RECORD
                  bmq   RECORD  LIKE bmq_file.*
             END RECORD,
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
        l_chr           LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmq.bmq01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash[1,g_len]                 #TQC-6A0081
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.bmq.bmqacti = 'N' THEN
                PRINT COLUMN g_c[31],'*';
            ELSE
                PRINT COLUMN g_c[31],' ';
            END IF
            PRINT COLUMN g_c[32],sr.bmq.bmq01,
                  COLUMN g_c[33],sr.bmq.bmq02,
                  COLUMN g_c[34],sr.bmq.bmq021,
                  COLUMN g_c[35],sr.bmq.bmq08,
                  COLUMN g_c[36],sr.bmq.bmq05,
                  COLUMN g_c[37],sr.bmq.bmq25
        ON LAST ROW
            IF g_zz05 = 'Y'
               THEN PRINT g_dash[1,g_len]       #TQC-6A0081
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash[1,g_len]       #TQC-6A0081
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.TQC-5B0030 modify
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]       #TQC-6A0081
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED  #No.TQC-5B0030 modify
            ELSE
                SKIP 2 LINE
            END IF
END REPORT  }                               #FUN-770052
 
FUNCTION i109_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
       LET g_type = '0'   #No.MOD-530140
      CALL cl_set_comp_entry("bmq01",TRUE)
   END IF
    #No.MOD-530140  --begin
   #IF INFIELD(bmq08) OR (NOT g_before_input_done) THEN
   #   IF (g_sma.sma104 = 'Y') THEN
   #      CALL cl_set_comp_entry("bmp903",TRUE)
   #   END IF
   #END IF
    #No.MOD-530140  --end
END FUNCTION
 
FUNCTION i109_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
       LET g_type = '1'   #No.MOD-530140
      CALL cl_set_comp_entry("bmq01",FALSE)
   END IF
    #No.MOD-530140  --begin
   #IF NOT (g_sma.sma104 = 'Y') OR g_bmq.bmq08 NOT MATCHES "[MT]" THEN
   #   CALL cl_set_comp_entry("bmp903",FALSE)
   #END IF
    #No.MOD-530140  --end
END FUNCTION
#CHI-7B0023/CHI-7B0039/TQC-C20173

