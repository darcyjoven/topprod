# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: abmi617.4gl
# Descriptions...: 固定屬性變更維護作業
# Date & Author..: 08/01/23 By  jan
# Modify.........: No.FUN-810017 08/03/21 By jan
# Modify.........: No.FUN-840137 08/04/21 By jan 過單31->38
# Modify.........: No.FUN-870124 08/08/08 By jan 服飾作業功能完善
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料則提示是否刪除單頭
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 13/02/04 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bog           RECORD LIKE bog_file.*,       
    g_bog_t         RECORD LIKE bog_file.*,       
    g_bog_o         RECORD LIKE bog_file.*,       
    g_bog01_t       LIKE bog_file.bog01,          #變更單號 (舊值)
    g_bog01     LIKE bog_file.bog01,         #程式變數的個數      #No.TQC-940183
 
    g_boh           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        boh03       LIKE boh_file.boh03,          #主件款式
        boh04       LIKE boh_file.boh04,          #特性代碼
        boh05       LIKE boh_file.boh05,          #元件款式
        boh02       LIKE boh_file.boh02,          #固定屬性項次
        boh11       LIKE boh_file.boh11,          #變更方式
        boh06       LIKE boh_file.boh06,          #屬性代號
        boh10       LIKE boh_file.boh10,          #固定屬性類型(變更前)
        boh07       LIKE boh_file.boh07,          #固定屬性值(變更前)
        boh08       LIKE boh_file.boh08,          #生效日期(變更前)
        boh09       LIKE boh_file.boh09,          #失效日期(變更前）
        boh15       LIKE boh_file.boh15,          #固定屬性類型(變更后)
        boh12       LIKE boh_file.boh12,          #固定屬性值(變更后)
        boh13       LIKE boh_file.boh13,          #生效日期(變更后)
        boh14       LIKE boh_file.boh14           #失效日期(變更后)
                    END RECORD,
    g_boh_t         RECORD                 #程式變數 (舊值)
        boh03       LIKE boh_file.boh03,          #主件款式                                                                         
        boh04       LIKE boh_file.boh04,          #特性代碼                                                                         
        boh05       LIKE boh_file.boh05,          #元件款式                                                                         
        boh02       LIKE boh_file.boh02,          #固定屬性項次                                                                     
        boh11       LIKE boh_file.boh11,          #變更方式                                                                         
        boh06       LIKE boh_file.boh06,          #屬性代號                                                                         
        boh10       LIKE boh_file.boh10,          #固定屬性類型(變更前)                                                             
        boh07       LIKE boh_file.boh07,          #固定屬性值(變更前)                                                               
        boh08       LIKE boh_file.boh08,          #生效日期(變更前)                                                                 
        boh09       LIKE boh_file.boh09,          #失效日期(變更前）                                                                
        boh15       LIKE boh_file.boh15,          #固定屬性類型(變更后)                                                             
        boh12       LIKE boh_file.boh12,          #固定屬性值(變更后)                                                               
        boh13       LIKE boh_file.boh13,          #生效日期(變更后)                                                                 
        boh14       LIKE boh_file.boh14           #失效日期(變更后)
                    END RECORD,
    g_boh_o         RECORD                 #程式變數 (舊值)
        boh03       LIKE boh_file.boh03,          #主件款式                                                                         
        boh04       LIKE boh_file.boh04,          #特性代碼                                                                         
        boh05       LIKE boh_file.boh05,          #元件款式                                                                         
        boh02       LIKE boh_file.boh02,          #固定屬性項次                                                                     
        boh11       LIKE boh_file.boh11,          #變更方式                                                                         
        boh06       LIKE boh_file.boh06,          #屬性代號                                                                         
        boh10       LIKE boh_file.boh10,          #固定屬性類型(變更前)                                                             
        boh07       LIKE boh_file.boh07,          #固定屬性值(變更前)                                                               
        boh08       LIKE boh_file.boh08,          #生效日期(變更前)                                                                 
        boh09       LIKE boh_file.boh09,          #失效日期(變更前）                                                                
        boh15       LIKE boh_file.boh15,          #固定屬性類型(變更后)                                                             
        boh12       LIKE boh_file.boh12,          #固定屬性值(變更后)                                                               
        boh13       LIKE boh_file.boh13,          #生效日期(變更后)                                                                 
        boh14       LIKE boh_file.boh14           #失效日期(變更后)
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  
    g_rec_b             LIKE type_file.num5,    #單身筆數  
    g_t1                LIKE oay_file.oayslip,  
    l_ac_1              LIKE type_file.num5,    
    l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT  
DEFINE   p_row,p_col    LIKE type_file.num5     
DEFINE   g_forupd_sql   STRING     #SELECT ...  FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1     
DEFINE   g_chr2         LIKE type_file.chr1     
DEFINE   g_cnt          LIKE type_file.num10    
DEFINE   g_i            LIKE type_file.num5    
DEFINE   g_msg          LIKE ze_file.ze03     
DEFINE   g_before_input_done  LIKE type_file.num5     
DEFINE   g_row_count    LIKE type_file.num10    
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_jump         LIKE type_file.num10    
DEFINE   g_no_ask      LIKE type_file.num5     
 
MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  
       DEFER INTERRUPT
    END IF
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM bog_file WHERE bog01 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i617_cl CURSOR FROM g_forupd_sql

    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW i617_w WITH FORM "abm/42f/abmi617"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()

    IF g_sma.sma118 = "N" THEN                                                                                                       
       CALL cl_set_comp_visible("dummy11,boh04",FALSE)                                                                                       
    END IF 
    CALL i617_menu()
    CLOSE i617_cl
    CLOSE WINDOW i617_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i617_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
   CLEAR FORM                
   CALL g_boh.clear()
   INITIALIZE g_bog.* TO NULL    
       CONSTRUCT BY NAME g_wc ON bog01,bog02,bog03,bog04,bog05,bog06,   
                                 boguser,boggrup,bogmodu,bogdate,bogacti
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
          ON ACTION CONTROLP
             CASE      
                WHEN INFIELD(bog01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form = "q_bog01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bog01
                     NEXT FIELD bog01
                OTHERWISE EXIT CASE
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
 
 
          ON ACTION qbe_select
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
       IF INT_FLAG THEN  RETURN END IF
 
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                #只能使用自己的資料
       #        LET g_wc = g_wc clipped," AND boguser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                #只能使用相同群的資料
       #        LET g_wc=g_wc clipped," AND boggrup LIKE '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #        LET g_wc=g_wc clipped," AND boggrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('boguser', 'boggrup')
       #End:FUN-980030
 
       CONSTRUCT g_wc2 ON boh03,boh04,boh05,boh02,boh11,boh06,boh10,
                          boh07,boh08,boh09,boh15,boh12,boh13,boh14
                     FROM s_boh[1].boh03,s_boh[1].boh04,s_boh[1].boh05,s_boh[1].boh02,
                          s_boh[1].boh11,s_boh[1].boh06,s_boh[1].boh10,s_boh[1].boh07,
                          s_boh[1].boh08,s_boh[1].boh09,s_boh[1].boh15,s_boh[1].boh12,
                          s_boh[1].boh13,s_boh[1].boh14
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
       LET g_sql = "SELECT bog01 FROM bog_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bog01"
    ELSE
        LET g_sql= "SELECT bog01 ",
                   " FROM bog_file, boh_file ",
                   " WHERE bog01 = boh01 ",
                   "  AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
                   " ORDER BY bog01 "
    END IF
    PREPARE i617_prepare FROM g_sql      #預備一下
    DECLARE i617_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i617_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bog_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT bog01) FROM bog_file,boh_file WHERE ",
                  "bog01=boh01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i617_precount FROM g_sql
    DECLARE i617_count CURSOR FOR i617_precount
 
END FUNCTION
 
FUNCTION i617_menu()
 
   WHILE TRUE
      CALL i617_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i617_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i617_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i617_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i617_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i617_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#        WHEN "output"
#           CALL i617_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i617_confirm()          #CALL 原確認的 check 段
            END IF
       #@WHEN "取消確認"
         WHEN "notconfirm"
            IF cl_chk_act_auth() THEN
               CALL i617_notconfirm()
            END IF
       #@WHEN "發放"
          WHEN "release"       
            IF cl_chk_act_auth() THEN
               CALL i617_g()
            END IF
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_bog.bog01 IS NOT NULL THEN
                LET g_doc.column1 = "bog01"
                LET g_doc.value1 = g_bog.bog01
                CALL cl_doc()
              END IF
             END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i617_v()  #CHI-D20010
               CALL i617_v(1)  #CHI-D20010
            END IF
         #CHI-C80041---end
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i617_v(2)   #CHI-D20010
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i617_a()
DEFINE li_result  LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_boh.clear()
    INITIALIZE g_bog.* LIKE bog_file.*               #DEFAULT 設定
    INITIALIZE g_bog_t.* LIKE bog_file.*             #DEFAULT 設定
    INITIALIZE g_bog_o.* LIKE bog_file.*             #DEFAULT 設定
    LET g_bog.bog01  = ' '
    LET g_bog.bog02 = g_today
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bog.bog03   = 'N'                    
        LET g_bog.bog04   = 'N'                
        LET g_bog.bogacti = 'Y'
        LET g_bog.boggrup=g_grup
        LET g_bog.bogdate=g_today
        LET g_bog.boguser=g_user
        LET g_bog.bogoriu = g_user #FUN-980030
        LET g_bog.bogorig = g_grup #FUN-980030
        CALL i617_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_bog.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_bog.bog01) THEN
           CONTINUE WHILE
        END IF
        BEGIN WORK
        CALL s_auto_assign_no("abm",g_bog.bog01,g_bog.bog02,"3","bog_file","bog01","","","")                                        
        RETURNING li_result,g_bog.bog01                                                                                             
        IF (NOT li_result) THEN                                                                                                     
           CONTINUE WHILE                                                                                                           
        END IF
        DISPLAY BY NAME g_bog.bog01 
        INSERT INTO bog_file VALUES(g_bog.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)
            ROLLBACK WORK
            CONTINUE WHILE
        ELSE
            COMMIT WORK                                                                                                              
           CALL cl_flow_notify(g_bog.bog01,'I')
        END IF
        SELECT bog01 INTO g_bog01 FROM bog_file
            WHERE bog01 = g_bog.bog01
        
        LET g_bog01_t = g_bog.bog01
        LET g_bog_t.* = g_bog.*
        LET g_bog_o.* = g_bog.*
        CALL g_boh.clear()
        LET g_rec_b = 0
        CALL i617_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i617_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bog.bog01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_bog.bogacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_bog.bog01,9027,0)
       RETURN
    END IF
    IF g_bog.bog03 = 'Y' THEN
       CALL cl_err("",'aap-005',0)
       RETURN
    END IF
    IF g_bog.bog03 = 'X' THEN RETURN END IF  #CHI-C80041
 
    CALL cl_opmsg('u')
    LET g_bog01_t = g_bog.bog01
    LET g_bog_o.* = g_bog.*
    BEGIN WORK
    LET g_success ='Y'
 
    OPEN i617_cl USING g_bog01
    IF STATUS THEN
       CALL cl_err("OPEN i617_cl:", STATUS, 1)
       CLOSE i617_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i617_cl INTO g_bog.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i617_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL i617_show()
    WHILE TRUE
        LET g_bog01_t = g_bog.bog01
        LET g_bog.bogmodu=g_user
        LET g_bog.bogdate=g_today
        CALL i617_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_success ='N'
            LET INT_FLAG = 0
            LET g_bog.*=g_bog_o.*
            LET g_bog.bog01 = g_bog_o.bog01
            DISPLAY BY NAME g_bog.bog01
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_bog.bog01 != g_bog01_t THEN            # 更改單號
            UPDATE boh_file SET boh01 = g_bog.bog01
                WHERE boh01 = g_bog01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err('boh',SQLCA.sqlcode,0) CONTINUE WHILE
            END IF
        END IF
        UPDATE bog_file SET bog_file.* = g_bog.*
            WHERE bog01 = g_bog01
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i617_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i617_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 
    l_cmd           LIKE type_file.chr1000, 
    l_n             LIKE type_file.num5    
DEFINE li_result LIKE type_file.num5  
    #NO:7203
    CALL cl_set_head_visible("","YES")           
    DISPLAY BY NAME
         g_bog.bog02,g_bog.bog03,g_bog.bog04,
         g_bog.boguser,g_bog.boggrup,g_bog.bogmodu,g_bog.bogdate,g_bog.bogacti
 
    INPUT BY NAME g_bog.bog01,g_bog.bog02,g_bog.bog06, g_bog.bogoriu,g_bog.bogorig,
                  g_bog.bog03,g_bog.bog04
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
        CALL cl_set_docno_format("bog01")
 
        LET  g_before_input_done = FALSE
        CALL i617_set_entry(p_cmd)
        CALL i617_set_no_entry(p_cmd)
        LET  g_before_input_done = TRUE
 
        AFTER FIELD bog01                   
           IF NOT cl_null(g_bog.bog01) THEN                                                                                        
            CALL s_check_no("abm",g_bog.bog01,g_bog_t.bog01,"3","bog_file","bog01","")                                              
            RETURNING li_result,g_bog.bog01                                                                                         
            DISPLAY BY NAME g_bog.bog01                                                                                             
            IF(NOT li_result) THEN                                                                                                  
               LET g_bog.bog01=g_bog_o.bog01                                                                                        
               DISPLAY BY NAME g_bog.bog01                                                                                          
            END IF                                                                                                                  
            END IF
 
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        ON ACTION CONTROLP
           CASE      
             WHEN INFIELD(bog01)
                 LET g_t1=s_get_doc_no(g_bog.bog01)                                                                               
                   CALL q_smy(FALSE,FALSE,g_t1,'ABM','3') RETURNING g_t1                                                           
                   LET g_bog.bog01 = g_t1                                                                                           
                   DISPLAY BY NAME g_bog.bog01                                                                                      
                   NEXT FIELD bog01
               OTHERWISE EXIT CASE
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
END FUNCTION
 
#Query 查詢
FUNCTION i617_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')                              
 
    CLEAR FORM
    CALL g_boh.clear()
    CALL i617_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i617_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bog.* TO NULL
    ELSE
        OPEN i617_count
        FETCH i617_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
 
        CALL i617_fetch('F')
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i617_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  
 
   #MESSAGE ""
    CALL cl_msg("")                              
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i617_cs INTO g_bog.bog01   LET g_bog01=g_bog.bog01
        WHEN 'P' FETCH PREVIOUS i617_cs INTO g_bog.bog01   LET g_bog01=g_bog.bog01
        WHEN 'F' FETCH FIRST    i617_cs INTO g_bog.bog01   LET g_bog01=g_bog.bog01
        WHEN 'L' FETCH LAST     i617_cs INTO g_bog.bog01   LET g_bog01=g_bog.bog01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i617_cs INTO g_bog.bog01   LET g_bog01=g_bog.bog01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        INITIALIZE g_bog.* TO NULL   
        CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_bog.* FROM bog_file WHERE bog01 = g_bog01
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)
        INITIALIZE g_bog.* TO NULL   
        RETURN
    END IF
    LET g_data_owner = g_bog.boguser      
    LET g_data_group = g_bog.boggrup      
    CALL i617_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i617_show()
 LET g_bog_t.* = g_bog.*
 
    DISPLAY BY NAME g_bog.bogoriu,g_bog.bogorig,
         g_bog.bog01,g_bog.bog02,g_bog.bog06,g_bog.bog05,   
         g_bog.bog03,g_bog.bog04,g_bog.boguser,g_bog.boggrup,
         g_bog.bogmodu,g_bog.bogdate,g_bog.bogacti
 
    CALL i617_b_fill(g_wc2)          
    CALL cl_show_fld_cont()          
END FUNCTION
 
 
FUNCTION i617_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_bog.bog01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0079
       RETURN
    END IF
    IF g_bog.bog03 = 'Y' THEN
       CALL cl_err("",'aap-005',0)
       RETURN
    END IF
    IF g_bog.bog03 = 'X' THEN RETURN END IF  #CHI-C80041
 
    SELECT * INTO g_bog.* FROM bog_file
     WHERE bog01 = g_bog.bog01
    IF g_bog.bogacti = 'N' THEN
       CALL cl_err(g_bog.bog01,'mfg1000',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i617_cl USING g_bog01
    IF STATUS THEN
       CALL cl_err("OPEN i617_cl:", STATUS, 1)
       CLOSE i617_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i617_cl INTO g_bog.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i617_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bog01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bog.bog01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM bog_file WHERE bog01 = g_bog.bog01
         DELETE FROM boh_file WHERE boh01 = g_bog.bog01
         INITIALIZE g_bog.* TO NULL
         CLEAR FORM
         CALL g_boh.clear()
         OPEN i617_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i617_cs
            CLOSE i617_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i617_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i617_cs
            CLOSE i617_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i617_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i617_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i617_fetch('/')
         END IF
    END IF
    CLOSE i617_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i617_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,                
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_cmd           LIKE type_file.chr1,                #採購單身是否為新增 
    l_flag          LIKE type_file.chr1,
    l_flag1         LIKE type_file.chr2, 
    l_flag2         LIKE type_file.chr2, 
    l_flag3         LIKE type_file.chr2, 
    l_flag4         LIKE type_file.chr2, 
    l_bmv04         LIKE bmv_file.bmv04,
    l_bmv08         LIKE bmv_file.bmv08,
    l_bmv07         LIKE bmv_file.bmv07,
    l_bmv05         LIKE bmv_file.bmv05,
    l_bmv06         LIKE bmv_file.bmv06,
    l_i             LIKE type_file.num5,    
    l_allow_insert  LIKE type_file.num5,    #可新增否  
    l_allow_delete  LIKE type_file.num5     #可刪除否  
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bog.bog01) THEN
       RETURN
    END IF
    IF g_bog.bogacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_bog.bog01,'mfg1000',0)
       RETURN
    END IF
    #--->如為'已確認',不可異動
    IF g_bog.bog03='Y' THEN
       CALL cl_err('','aap-005',0)
       RETURN
    END IF
    IF g_bog.bog03 = 'X' THEN RETURN END IF  #CHI-C80041
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT boh03,boh04,boh05,boh02,boh11,boh06,boh10,boh07,",             
      "        boh08,boh09,boh15,boh12,boh13,boh14 FROM boh_file",	
      "   WHERE boh01 = ? ",
      "    AND boh02 = ? ",
      "    AND boh03 = ? ",
      "    AND boh04 = ? ",
      "    AND boh05 = ? ",
      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i617_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        
        INPUT ARRAY g_boh WITHOUT DEFAULTS FROM s_boh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL FGL_DIALOG_SETFIELDORDER(TRUE)
            
        BEFORE ROW
            LET p_cmd = ''
               LET l_ac = ARR_CURR()
               LET l_lock_sw = 'N'            #DEFAULT
               LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i617_cl USING g_bog01
            IF STATUS THEN
               CALL cl_err("OPEN i617_cl:", STATUS, 1)
               CLOSE i617_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i617_cl INTO g_bog.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i617_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_boh_t.* = g_boh[l_ac].*  #BACKUP
 
                OPEN i617_bcl USING g_bog.bog01,g_boh_t.boh02,g_boh_t.boh03,g_boh_t.boh04,g_boh_t.boh05
                IF STATUS THEN
                    CALL cl_err("OPEN i617_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i617_bcl INTO g_boh[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_boh_t.boh02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
 
                CALL cl_show_fld_cont()     #FUN-550037(smin)
                NEXT FIELD boh02
            END IF
 
        BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd = 'a'
          INITIALIZE g_boh[l_ac].* TO NULL
          LET g_boh_t.* = g_boh[l_ac].*
          LET g_boh[l_ac].boh13 = g_today
#         LET g_boh_t.* = g_boh[l_ac].*
          CALL cl_show_fld_cont()
          NEXT FIELD boh03 
       
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            IF cl_null(g_boh[l_ac].boh07) THEN
               LET g_boh[l_ac].boh07 = " "
            END IF
            IF cl_null(g_boh[l_ac].boh08) THEN
               LET g_boh[l_ac].boh08 = g_today
            END IF
            IF cl_null(g_boh[l_ac].boh04) THEN LET g_boh[l_ac].boh04 = ' ' END IF
            INSERT INTO boh_file(boh01,boh03,boh04,
                                 boh05,boh02,boh11,
                                 boh06,boh10,boh07,boh08,     
                                 boh09,boh15,boh12,boh13,boh14)      
            VALUES(g_bog.bog01,g_boh[l_ac].boh03, 
                   g_boh[l_ac].boh04, g_boh[l_ac].boh05,
                   g_boh[l_ac].boh02, g_boh[l_ac].boh11,
                   g_boh[l_ac].boh06, g_boh[l_ac].boh10,
                   g_boh[l_ac].boh07, g_boh[l_ac].boh08,
                   g_boh[l_ac].boh09, g_boh[l_ac].boh15,
                   g_boh[l_ac].boh12, g_boh[l_ac].boh13,
                   g_boh[l_ac].boh14)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_boh[l_ac].boh03,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            
       AFTER FIELD boh03
             IF NOT cl_null(g_boh[l_ac].boh03) THEN
               #FUN-AA0059 ---------------------------add start--------------------------
               IF NOT s_chk_item_no(g_boh[l_ac].boh03,'') THEN 
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD boh03
               END IF 
              #3FUN-AA0059 ---------------------------add  end- ----------------------------    
               IF g_boh[l_ac].boh03 != g_boh_t.boh03                                                                                   
                  OR cl_null(g_boh_t.boh03) THEN
                LET l_cnt = 0
                SELECT COUNT(*)  INTO l_cnt FROM ima_file,bmb_file,bma_file 
                   WHERE ima01 = g_boh[l_ac].boh03
                     AND ima151 = 'Y'
                     AND ima01 = bma01
                     AND bma01 = bmb01
                     AND bma10 IN ('1','2')
                     AND imaacti = 'Y'
                     AND bmaacti = 'Y'
                     AND bma10 !='0'
                IF l_cnt = 0 THEN
                   CALL cl_err('','abm-090',0)
                   NEXT FIELD boh03
                END IF
               END IF
             ELSE 
                NEXT FIELD boh03
             END IF  
            IF g_boh[l_ac].boh03 != g_boh_t.boh03 THEN
            #FUN-870124-- begin--
                LET g_boh[l_ac].boh04 = " "
                LET g_boh[l_ac].boh05 = " "
                LET g_boh[l_ac].boh02 = " "
                LET g_boh[l_ac].boh11 = " "
                LET g_boh[l_ac].boh06 = " "
                LET g_boh[l_ac].boh10 = " "
                LET g_boh[l_ac].boh07 = " "
                LET g_boh[l_ac].boh08 = " "
                LET g_boh[l_ac].boh09 = " "
                LET g_boh[l_ac].boh15 = " "
                LET g_boh[l_ac].boh12 = " "
                LET g_boh[l_ac].boh13 = g_today
                LET g_boh[l_ac].boh14 = " "
#                CALL i617_checkerr1() 
#                RETURNING l_flag
#                IF l_flag = 'N' THEN
#                   CALL cl_err('','abm-080',1)
#                   NEXT FIELD boh03
#                END IF
#                CALL i617_checkerr2()
#               RETURNING l_flag1,l_flag2,l_flag3,l_flag4
#                IF l_flag1 = '1' THEN
#                    CALL cl_err('','abm-416',1)
#                    NEXT FIELD boh03
#                END IF
#                IF l_flag2 = '2' THEN
#                    CALL cl_err('','abm-417',1)
#                    NEXT FIELD boh03
#                END IF
#                IF l_flag3 = '3' THEN
#                    CALL cl_err('','abm-418',1)
#                    NEXT FIELD boh03
#                END IF
#                IF l_flag4 = '4' THEN
#                    CALL cl_err('','abm-417',1)
#                    NEXT FIELD boh03
#                END IF
          #No.FUN-870124--END--
            END IF
#            IF g_boh_t.boh03 IS NULL THEN   #N0.FUN-870124
                IF g_sma.sma118 = 'Y' THEN
                   NEXT FIELD boh04
                ELSE
                   NEXT FIELD boh05
                END IF
#             END IF                         #No.FUN-870124
 
 
       AFTER FIELD boh04
         LET l_cnt = 0
         IF NOT cl_null(g_boh[l_ac].boh04) THEN 
            IF g_boh[l_ac].boh04 != g_boh_t.boh04
             OR cl_null(g_boh_t.boh04) THEN
              SELECT COUNT(*) INTO l_cnt FROM bma_file
               WHERE bma06 = g_boh[l_ac].boh04
                 AND bma01 = g_boh[l_ac].boh03
              IF l_cnt = 0 THEN
                 CALL cl_err('','asfi115',0)
                 NEXT FIELD boh04
              END IF
            END IF
         ELSE
#           NEXT FIELD boh04              #No.FUN-870124
            LET g_boh[l_ac].boh04 = " "   #No.fun-870124
         END IF 
         IF g_boh[l_ac].boh04 != g_boh_t.boh04 THEN
#NO.fun-870124-- begin--
                LET g_boh[l_ac].boh05 = " "
                LET g_boh[l_ac].boh02 = " "
                LET g_boh[l_ac].boh11 = " "
                LET g_boh[l_ac].boh06 = " "
                LET g_boh[l_ac].boh10 = " "
                LET g_boh[l_ac].boh07 = " "
                LET g_boh[l_ac].boh08 = " "
                LET g_boh[l_ac].boh09 = " "
                LET g_boh[l_ac].boh15 = " "
                LET g_boh[l_ac].boh12 = " "
                LET g_boh[l_ac].boh13 = g_today
                LET g_boh[l_ac].boh14 = " "
{            CALL i617_checkerr1() 
            RETURNING l_flag
            IF l_flag = 'N' THEN
               CALL cl_err('','abm-080',1)
               NEXT FIELD boh04
            END IF
            CALL i617_checkerr2()
            RETURNING l_flag1,l_flag2,l_flag3,l_flag4
            IF l_flag1 = '1' THEN
               CALL cl_err('','abm-416',1)
               NEXT FIELD boh04
            END IF
            IF l_flag2 = '2' THEN
               CALL cl_err('','abm-417',1)
               NEXT FIELD boh04
            END IF
            IF l_flag3 = '3' THEN
               CALL cl_err('','abm-418',1)
               NEXT FIELD boh04
            END IF
            IF l_flag4 = '4' THEN
               CALL cl_err('','abm-417',1)
               NEXT FIELD boh04
            END IF}
#No.FUN-870124--END            
         END IF
#         IF g_boh_t.boh04 IS NULL THEN  #No.FUN-870124
            NEXT FIELD boh05
#         END IF                         #No.FUN-870124
 
       AFTER FIELD boh05
         LET l_cnt = 0                                                                                                              
         IF NOT cl_null(g_boh[l_ac].boh05) THEN                                                                                     
            #FUN-AA0059 -------------------------------add start-------------------------
            IF NOT s_chk_item_no(g_boh[l_ac].boh05,'') THEN
               CALL cl_err('',g_errno,1) 
               NEXT FIELD boh05
            END IF 
            #FUN-AA0059 ------------------------------add end -------------------------- 
            IF g_boh[l_ac].boh05 != g_boh_t.boh05                                                                                   
             OR cl_null(g_boh_t.boh05) THEN                                                                                         
             IF g_sma.sma118 = 'N' THEN
              SELECT COUNT(*) INTO l_cnt FROM bmb_file,ima_file                                                                              
               WHERE bmb01 = g_boh[l_ac].boh03 
                 AND bmb03 = ima01
                 AND ima151 = 'Y'
                 AND ima01 = g_boh[l_ac].boh05
             ELSE 
              SELECT COUNT(*) INTO l_cnt FROM bmb_file,ima_file                                                                              
               WHERE bmb29 = g_boh[l_ac].boh04                                                                                      
                 AND bmb01 = g_boh[l_ac].boh03 
                 AND bmb03 = ima01
                 AND ima151 = 'Y'
                 AND ima01 = g_boh[l_ac].boh05
             END IF
              IF l_cnt = 0 THEN                                                                                                     
                 CALL cl_err('','asfi115',0)                                                                                        
                 NEXT FIELD boh05                                                                                                   
              END IF                                                                                                                
            END IF                                                                                                                  
         ELSE                                                                                                                       
           NEXT FIELD boh05                                                                                                         
         END IF   
         IF g_boh[l_ac].boh05 != g_boh_t.boh05 THEN
#FUN-870124-- begin--
                LET g_boh[l_ac].boh02 = " "
                LET g_boh[l_ac].boh11 = " "
                LET g_boh[l_ac].boh06 = " "
                LET g_boh[l_ac].boh10 = " "
                LET g_boh[l_ac].boh07 = " "
                LET g_boh[l_ac].boh08 = " "
                LET g_boh[l_ac].boh09 = " "
                LET g_boh[l_ac].boh15 = " "
                LET g_boh[l_ac].boh12 = " "
                LET g_boh[l_ac].boh13 = g_today
                LET g_boh[l_ac].boh14 = " "
{            CALL i617_checkerr1() 
            RETURNING l_flag
            IF l_flag = 'N' THEN
               CALL cl_err('','abm-080',1)
               NEXT FIELD boh05
            END IF
            CALL i617_checkerr2()
            RETURNING l_flag1,l_flag2,l_flag3,l_flag4
            IF l_flag1 = '1' THEN
                CALL cl_err('','abm-416',1)
                NEXT FIELD boh05
            END IF
            IF l_flag2 = '2' THEN
                CALL cl_err('','abm-417',1)
                NEXT FIELD boh05
            END IF
            IF l_flag3 = '3' THEN
               CALL cl_err('','abm-418',1)
               NEXT FIELD boh05
            END IF
            IF l_flag4 = '4' THEN
                CALL cl_err('','abm-417',1)
                NEXT FIELD boh05
            END IF}
#NO.FUN-870124--END--            
         END IF
#         IF g_boh_t.boh05 IS NULL THEN  #No.FUN-870124
            NEXT FIELD boh02
#         END IF                         #No.FUN-870124
 
        BEFORE FIELD boh02 
        CALL cl_set_comp_entry("boh15,boh12,boh13,boh14",TRUE)
 
        AFTER FIELD boh02
         IF NOT cl_null(g_boh[l_ac].boh02) THEN
            CALL cl_set_comp_entry("boh11,boh06",TRUE)
            LET g_cnt=0
          IF g_sma.sma118 = 'Y' THEN
            SELECT COUNT(*) INTO g_cnt
                FROM bmv_file
                WHERE bmv09 = g_boh[l_ac].boh02
                  AND bmv01 = g_boh[l_ac].boh03
                  AND bmv02 = g_boh[l_ac].boh05
                  AND bmv03 = g_boh[l_ac].boh04
          ELSE
            SELECT COUNT(*) INTO g_cnt
                FROM bmv_file
                WHERE bmv09 = g_boh[l_ac].boh02
                  AND bmv01 = g_boh[l_ac].boh03
                  AND bmv02 = g_boh[l_ac].boh05
          END IF
            IF g_cnt = 0 THEN
               LET g_boh[l_ac].boh11 = '2'
               CALL cl_set_comp_entry("boh11",FALSE)
#              CALL cl_set_comp_entry("boh06",TRUE)
            ELSE
#              IF cl_null(g_boh[l_ac].boh11) OR g_boh[l_ac].boh11 = '2' THEN
#                 LET g_boh[l_ac].boh11 = '1'
#              END IF 
              IF g_sma.sma118 = 'Y' THEN
               SELECT bmv04,bmv08,bmv07,bmv05,bmv06  
                 INTO l_bmv04,l_bmv08,l_bmv07,l_bmv05,l_bmv06
                 FROM bmv_file
                WHERE bmv09 = g_boh[l_ac].boh02
                  AND bmv01 = g_boh[l_ac].boh03
                  AND bmv02 = g_boh[l_ac].boh05
                  AND bmv03 = g_boh[l_ac].boh04
              ELSE
               SELECT bmv04,bmv08,bmv07,bmv05,bmv06  
                 INTO l_bmv04,l_bmv08,l_bmv07,l_bmv05,l_bmv06
                 FROM bmv_file
                WHERE bmv09 = g_boh[l_ac].boh02
                  AND bmv01 = g_boh[l_ac].boh03
                  AND bmv02 = g_boh[l_ac].boh05
                  AND bmv03 = " "
              END IF
                LET g_boh[l_ac].boh06 = l_bmv04
                LET g_boh[l_ac].boh10 = l_bmv08
                LET g_boh[l_ac].boh07 = l_bmv07
                LET g_boh[l_ac].boh08 = l_bmv05
                LET g_boh[l_ac].boh09 = l_bmv06
                DISPLAY BY NAME g_boh[l_ac].boh06
                DISPLAY BY NAME g_boh[l_ac].boh10
                DISPLAY BY NAME g_boh[l_ac].boh07
                DISPLAY BY NAME g_boh[l_ac].boh08
                DISPLAY BY NAME g_boh[l_ac].boh09
                CALL cl_set_comp_entry("boh06",FALSE)
#               CALL cl_set_comp_entry("boh11",TRUE)
                IF cl_null(g_boh[l_ac].boh11) OR g_boh[l_ac].boh11 = '2' THEN
                   LET g_boh[l_ac].boh11 = '1'
                END IF 
            END IF
          ELSE 
            NEXT FIELD boh02
          END IF
         
         IF g_boh_t.boh02 IS NULL OR 
            g_boh[l_ac].boh02 != g_boh_t.boh02 OR
            g_boh[l_ac].boh03 != g_boh_t.boh03 OR        #No.FUN-870124                                                               
            g_boh[l_ac].boh04 != g_boh_t.boh04 OR        #No.FUN-870124                                                               
            g_boh[l_ac].boh05 != g_boh_t.boh05  THEN     #No.FUN-870124 
            CALL i617_checkerr1() 
            RETURNING l_flag
            IF l_flag = 'N' THEN
               CALL cl_err('','abm-080',1)
              NEXT FIELD boh02
           END IF
         END IF	
         IF g_boh[l_ac].boh02 != g_boh_t.boh02 AND
            g_boh[l_ac].boh03 = g_boh_t.boh03 AND   #No.FUN-870124
            g_boh[l_ac].boh04 = g_boh_t.boh04 AND   #No.FUN-870124
            g_boh[l_ac].boh05 = g_boh_t.boh05 THEN  #No.FUN-870124
            CALL i617_checkerr2()
            RETURNING l_flag1,l_flag2,l_flag3,l_flag4
#            IF l_flag1 = '1' THEN
#                CALL cl_err('','abm-416',1)
#                NEXT FIELD boh02
#            END IF
#            IF l_flag2 = '2' THEN
#                CALL cl_err('','abm-417',1)
#                NEXT FIELD boh02
#            END IF
#            IF l_flag3 = '3' THEN
#               CALL cl_err('','abm-418',1)
#               NEXT FIELD boh02
#            END IF
            IF l_flag4 = '4' THEN
                CALL cl_err('','abm-417',1)
                NEXT FIELD boh02
            END IF
          END IF
         IF g_boh_t.boh02 IS NULL OR
            g_boh[l_ac].boh03 != g_boh_t.boh03 OR        #No.FUN-870124 
            g_boh[l_ac].boh04 != g_boh_t.boh04 OR        #No.FUN-870124
            g_boh[l_ac].boh05 != g_boh_t.boh05   THEN    #No.FUN-870124
            NEXT FIELD boh11
         END IF
         #No.FUN-870124--BEGIN--
         IF g_boh_t.boh02 IS NOT NULL THEN
            IF g_boh[l_ac].boh11 = '3' THEN
               CALL cl_set_comp_entry("boh15,boh12,boh13,boh14",FALSE)
            END IF
         END IF
         #No.FUN-870124--END--
 
 
        BEFORE FIELD boh11
            CALL i617_set_boh11()
 
        AFTER FIELD boh11
            CALL i617_set_boh11a()
            IF g_boh[l_ac].boh11 = '1' OR g_boh[l_ac].boh11 = '2' THEN
               CALL cl_set_comp_entry("boh15,boh12,boh13,boh14",TRUE)
            ELSE
               CALL cl_set_comp_entry("boh15,boh12,boh13,boh14",FALSE)
            END IF
 
        AFTER FIELD boh06
            LET l_cnt = 0
            IF NOT cl_null(g_boh[l_ac].boh06) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM agb_file,ima_file
                WHERE agb01 = imaag
                  AND ima01 =  g_boh[l_ac].boh05
               IF l_cnt = 0 THEN
                  CALL cl_err('','asfi115',0)
                  NEXT FIELD boh06
               END IF
            ELSE
               NEXT FIELD boh06
            END IF
            IF g_boh_t.boh06 IS NULL OR g_boh_t.boh06 != g_boh[l_ac].boh06 THEN
               CALL i617_checkerr2()
               RETURNING l_flag1,l_flag2,l_flag3,l_flag4
               IF l_flag1 = '1' THEN
                  CALL cl_err('','abm-416',1)
                  NEXT FIELD boh06
               END IF
               IF l_flag2 = '2' THEN
                  CALL cl_err('','abm-417',1)
                  NEXT FIELD boh06
               END IF
               IF l_flag3 = '3' THEN
                  CALL cl_err('','abm-418',1)
                  NEXT FIELD boh06
               END IF
               IF l_flag4 = '4' THEN
                  CALL cl_err('','abm-417',1)
                  NEXT FIELD boh06
               END IF
            END IF
 
        AFTER FIELD boh15
             IF g_boh[l_ac].boh11 = '2'OR g_boh[l_ac].boh11 = '1' THEN
                IF cl_null(g_boh[l_ac].boh15) THEN
                   CALL cl_err('','mfg2726',0)
                   NEXT FIELD boh15
                END IF
             END IF
             IF g_boh[l_ac].boh15 != g_boh_t.boh15 THEN
                LET g_boh[l_ac].boh12=" "
             END IF
         BEFORE FIELD boh12
             IF g_boh[l_ac].boh11 = '2'OR g_boh[l_ac].boh11 = '1' THEN
                IF cl_null(g_boh[l_ac].boh15) THEN
                   CALL cl_err('','mfg2726',0)
                   NEXT FIELD boh15
                END IF
             END IF
         AFTER FIELD boh12
          IF NOT cl_null(g_boh[l_ac].boh12) THEN
           IF (g_boh[l_ac].boh12 != g_boh_t.boh12) OR
              cl_null(g_boh_t.boh12) THEN
             LET l_cnt = 0
             IF g_boh[l_ac].boh15 = '1' THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM agb_file,ima_file
                 WHERE agb01=imaag
                   AND ima01=g_boh[l_ac].boh03
                IF l_cnt = 0 THEN
                   CALL cl_err('','asfi115',0)
                   NEXT FIELD boh12
                END IF
             END IF
             LET g_cnt = 0
             IF g_boh[l_ac].boh15 = '2' THEN
                SELECT COUNT(*) INTO g_cnt
                  FROM agd_file,agc_file
                 WHERE (agd02 = g_boh[l_ac].boh12
                   AND  agd01 = agc01
                   AND  agc04 = '2'
                   AND  agc01 = g_boh[l_ac].boh06)
                    OR  (g_boh[l_ac].boh12 BETWEEN agc05 AND agc06
                   AND   agc04 = '3'
                   AND   agc01 = g_boh[l_ac].boh06)
                    OR  (agc04 = '1'
                   AND   agc01 = g_boh[l_ac].boh06)
                IF g_cnt = 0 THEN
                   CALL cl_err('','asfi115',0)
                   NEXT FIELD boh12
                END IF
             END IF
          END IF
         END IF
 
        AFTER FIELD boh13  
           IF g_boh[l_ac].boh11 = '2' THEN
              IF cl_null(g_boh[l_ac].boh13) THEN
                 CALL cl_err('','mfg2726',0)
                 NEXT FIELD boh13
              END IF
              IF NOT cl_null(g_boh[l_ac].boh14) THEN
                 IF g_boh[l_ac].boh13 > g_boh[l_ac].boh14 THEN
                    CALL cl_err('','abm-828',0)
                    NEXT FIELD boh13
                 END IF
              END IF
           END IF
          IF NOT cl_null(g_boh[l_ac].boh13) THEN
             IF g_boh_t.boh13 IS NULL OR 
                (g_boh[l_ac].boh13 != g_boh_t.boh13) THEN
                CALL i617_checkerr2()
                RETURNING l_flag1,l_flag2,l_flag3,l_flag4
                IF l_flag1 = '1' THEN
                   CALL cl_err('','abm-416',1)
                   NEXT FIELD boh13
                END IF
                IF l_flag2 = '2' THEN
                   CALL cl_err('','abm-417',1)
                   NEXT FIELD boh13
                END IF
                IF l_flag3 = '3' THEN
                   CALL cl_err('','abm-418',1)
                   NEXT FIELD boh13
                END IF
                IF l_flag4 = '4' THEN
                   CALL cl_err('','abm-417',1)
                   NEXT FIELD boh13
                END IF
             END IF
           END IF
 
        AFTER FIELD boh14  
           IF NOT cl_null(g_boh[l_ac].boh14) AND NOT cl_null(g_boh[l_ac].boh13) THEN
              IF g_boh[l_ac].boh13 > g_boh[l_ac].boh14 THEN                                                                      
                    CALL cl_err('','abm-828',0)                                                                                     
                    NEXT FIELD boh14                                                                                                
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_boh_t.boh02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM boh_file
                    WHERE boh01 = g_bog.bog01
                      AND boh02 = g_boh_t.boh02
                      AND boh03 = g_boh_t.boh03
                      AND boh04 = g_boh_t.boh04
                      AND boh05 = g_boh_t.boh05
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_boh_t.boh02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
 
        ON ROW CHANGE
          CALL i617_check()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_boh[l_ac].* = g_boh_t.*
               CLOSE i617_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_boh[l_ac].boh02,-263,1)
               LET g_boh[l_ac].* = g_boh_t.*
            ELSE
                UPDATE boh_file SET
                       boh03 = g_boh[l_ac].boh03,
                       boh04 = g_boh[l_ac].boh04,
                       boh05 = g_boh[l_ac].boh05,
                       boh02 = g_boh[l_ac].boh02,
                       boh11 = g_boh[l_ac].boh11,       #No.FUN-550089
                       boh06 = g_boh[l_ac].boh06,
                       boh10 = g_boh[l_ac].boh10,
                       boh07 = g_boh[l_ac].boh07,
                       boh08 = g_boh[l_ac].boh08,
                       boh09 = g_boh[l_ac].boh09,
                       boh15 = g_boh[l_ac].boh15,
                       boh12 = g_boh[l_ac].boh12,
                       boh13 = g_boh[l_ac].boh13,
                       boh14 = g_boh[l_ac].boh14
                 WHERE boh01  = g_bog.bog01
                   AND boh02  = g_boh_t.boh02
                   AND boh03  = g_boh_t.boh03
                   AND boh04  = g_boh_t.boh04
                   AND boh05  = g_boh_t.boh05
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_boh[l_ac].boh02,SQLCA.sqlcode,0)
                    LET g_boh[l_ac].* = g_boh_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_boh[l_ac].* = g_boh_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_boh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i617_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i617_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(boh03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_boh03"
                 LET g_qryparam.default1 = g_boh[l_ac].boh03
                 CALL cl_create_qry() RETURNING g_boh[l_ac].boh03
                 CALL FGL_DIALOG_SETBUFFER(g_boh[l_ac].boh03)
                 DISPLAY BY NAME g_boh[l_ac].boh03
                 NEXT FIELD boh03
 
               WHEN INFIELD(boh04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_boh04"
                    LET g_qryparam.arg1 = g_boh[l_ac].boh03
                    CALL cl_create_qry() RETURNING g_boh[l_ac].boh04
                    CALL FGL_DIALOG_SETBUFFER(g_boh[l_ac].boh04)
                    DISPLAY BY NAME g_boh[l_ac].boh04
                    NEXT FIELD boh04
               WHEN INFIELD(boh05) 
                    CALL cl_init_qry_var()
                    IF g_sma.sma118 = 'Y' THEN
                       LET g_qryparam.form = "q_boh05"
                       LET g_qryparam.arg1 = g_boh[l_ac].boh03
                       LET g_qryparam.arg2 = g_boh[l_ac].boh04
                    END IF
                    IF g_sma.sma118 = 'N' THEN
                       LET g_qryparam.form = "q_boh05_1" 
                       LET g_qryparam.arg1 = g_boh[l_ac].boh03
                    END IF
                    CALL cl_create_qry() RETURNING g_boh[l_ac].boh05
                    CALL FGL_DIALOG_SETBUFFER(g_boh[l_ac].boh05)
                    DISPLAY BY NAME g_boh[l_ac].boh05
                    NEXT FIELD boh05   
               WHEN INFIELD(boh06) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_boh06"
                    LET g_qryparam.arg1 = g_boh[l_ac].boh05
                    CALL cl_create_qry() RETURNING g_boh[l_ac].boh06
                    CALL FGL_DIALOG_SETBUFFER(g_boh[l_ac].boh06)
                    DISPLAY BY NAME g_boh[l_ac].boh06
                    NEXT FIELD boh06
               WHEN INFIELD(boh12) 
                    CALL cl_init_qry_var()
                    IF g_boh[l_ac].boh15 = '1' THEN
                       LET g_qryparam.form ="q_boh12_1"
                       LET g_qryparam.arg1 = g_boh[l_ac].boh03
                    END IF
                    IF g_boh[l_ac].boh15 = '2' THEN
                       LET g_qryparam.form ="q_boh12_2"                                                                             
                       LET g_qryparam.arg1 = g_boh[l_ac].boh06
                    END IF
                    CALL cl_create_qry() RETURNING g_boh[l_ac].boh12
                    DISPLAY BY NAME g_boh[l_ac].boh12
                    CALL FGL_DIALOG_SETBUFFER(g_boh[l_ac].boh12)
                    NEXT FIELD boh12
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
    CLOSE i617_bcl
    COMMIT WORK
 
#  CALL i617_delall()   #CHI-C30002 mark
   CALL i617_delHeader() #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 ------ add ------ begin
FUNCTION i617_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bog.bog01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bog_file ",
                  "  WHERE bog01 LIKE '",l_slip,"%' ",
                  "    AND bog01 > '",g_bog.bog01,"'"
      PREPARE i617_pb1 FROM l_sql 
      EXECUTE i617_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL i617_v()    #CHI-D20010
         CALL i617_v(1)   #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM bog_file WHERE bog01 = g_bog.bog01
         INITIALIZE g_bog.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------ add ------ end
 
FUNCTION i617_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                                                                       
                                                                                                                                    
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                             
      CALL cl_set_comp_entry("bog01",TRUE)                                                                                          
    END IF
 
END FUNCTION
 
FUNCTION i617_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                                                                       
                                                                                                                                    
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN                                                           
       CALL cl_set_comp_entry("bog01",FALSE)                                                                                        
    END IF
END FUNCTION
 
#CHI-C30002 ----- mark ------ begin
#FUNCTION i617_delall() 			# 未輸入單身資料, 是否取消單頭資料
#   SELECT COUNT(*) INTO g_cnt FROM boh_file
#       WHERE boh01 = g_bog.bog01
#   IF g_cnt = 0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM bog_file WHERE bog01 = g_bog.bog01 
#   END IF
#END FUNCTION
#CHI-C30002 ----- mark ------ end 
FUNCTION i617_b_askkey()
DEFINE
#    l_wc            LIKE type_file.chr1000 
    l_wc            STRING     #NO.FUN-910082 
 
    CONSTRUCT l_wc ON boh03,boh04,boh05,boh02,boh11,boh06,boh10,  #螢幕上取條件
                      boh07,boh08,boh09,boh15,boh12,boh13,boh14
       FROM s_boh[1].boh03,s_boh[1].boh04,s_boh[1].boh05,s_boh[1].boh02,
            s_boh[1].boh11,s_boh[1].boh06,s_boh[1].boh10,s_boh[1].boh07,
            s_boh[1].boh08,s_boh[1].boh09,s_boh[1].boh15,s_boh[1].boh12,
            s_boh[1].boh13,s_boh[1].boh14
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i617_b_fill(l_wc)
END FUNCTION
 
FUNCTION i617_b_fill(p_wc)              
DEFINE
   # p_wc            LIKE type_file.chr1000  
    p_wc             STRING        #NO.FUN-910082             
 
    LET g_sql =               
       " SELECT boh03,boh04,boh05,boh02,boh11,boh06,boh10,",
       "        boh07,boh08,boh09,boh15,boh12,boh13,boh14 ",  
       " FROM boh_file ",     
       " WHERE boh01 = '",g_bog.bog01, "'",
       "   AND ", p_wc CLIPPED
    PREPARE i617_prepare2 FROM g_sql      #預備一下
    DECLARE boh_cs CURSOR FOR i617_prepare2
    CALL g_boh.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH boh_cs INTO g_boh[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_boh.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
 
FUNCTION i617_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boh TO s_boh.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")        
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i617_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL i617_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
       	ACCEPT DISPLAY                   
 
 
      ON ACTION jump
         CALL i617_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION next
         CALL i617_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION last
         CALL i617_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
  	ACCEPT DISPLAY                   
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION notconfirm
         LET g_action_choice="notconfirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
    #@ON ACTION 發放
       ON ACTION release  
          LET g_action_choice="release"  
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
{
FUNCTION i617_out()
  DEFINE l_sw       LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(01)
         l_prog     LIKE zz_file.zz01,           #No.FUN-680136 VARCHAR(10)
         l_wc       LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(200)
         l_cmd,g_buf     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_i,l_j    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
	 l_prtway   LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
         l_lang     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
     IF NOT cl_null(g_pna.pna01) THEN
        SELECT pmc911 INTO l_lang
          FROM pmc_file, pmm_file
         WHERE g_pna.pna01 = pmm01 AND pmm09 = pmc01
     ## CALL s_chen_lang(6,10,g_lang) RETURNING l_lang #BugNo:6715, 7252
#       CALL cl_prtmsg(16,11,'apm-223',g_lang) RETURNING l_sw
        CALL cl_confirm('apm-223') RETURNING l_sw
        IF l_sw THEN
#       IF l_sw matches'[yY]' THEN
           LET l_wc = " pna01 = "," '",g_pna.pna01,"' ",
                      " AND pna02 = "," '",g_pna.pna02,"' "
           LET g_buf=l_wc
           LET l_j=length(g_buf)
           FOR l_i=1 TO l_j
             IF g_buf[l_i,l_i+1]='"' THEN
                LET g_buf[l_i,l_i+1]="'"
             END IF
           END FOR
           LET l_wc = g_buf
           LET l_prog='apmr910'
           SELECT zz22 INTO l_prtway FROM zz_file
            WHERE zz01 = l_prog
	   LET l_cmd = l_prog CLIPPED,
		   " '",g_today CLIPPED,"' ''",
		   " '",l_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
		  ' "',l_wc CLIPPED,'" '  # TQC-610085 mark ,"3" CLIPPED
            CALL cl_cmdrun(l_cmd)
         END IF
     END IF
END FUNCTION}
 
FUNCTION i617_confirm()       
DEFINE l_n1  LIKE type_file.num5
DEFINE l_n2  LIKE type_file.num5
DEFINE l_n3  LIKE type_file.num5
DEFINE l_n4  LIKE type_file.num5
DEFINE l_cnt LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF                                                                                                      
    IF cl_null(g_bog.bog01) THEN                                                                             
       CALL cl_err('',-400,0)                                                                                                       
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF g_bog.bog03="Y"  THEN                                                                                                         
       CALL cl_err("",9023,1)       
       RETURN                                                                                                
    END IF   
    IF g_bog.bog03 = 'X' THEN RETURN END IF  #CHI-C80041    
    IF g_bog.bog04="Y" THEN
       CALL cl_err("",'abm-003',0)
       RETURN 
    END IF                                                                                                           
    IF g_bog.bogacti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1)     
       RETURN                                                                                             
    END IF                                                                                                                            
    IF NOT cl_confirm('aap-222') THEN RETURN END IF                                                                                           
    #CHI-C30107 -------- add -------- begin
    IF cl_null(g_bog.bog01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_bog.bog03="Y"  THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_bog.bog03 = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_bog.bog04="Y" THEN
       CALL cl_err("",'abm-003',0)
       RETURN
    END IF
    IF g_bog.bogacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN
    END IF
    #CHI-C30107 -------- add -------- end
    BEGIN WORK   
    LET g_success = 'Y'
    DECLARE boh_cury CURSOR FOR
            SELECT boh03,boh04,boh05,boh02,boh11,boh06,boh10,
                   boh07,boh08,boh09,boh15,boh12,boh13,boh14
              FROM boh_file WHERE boh01 = g_bog.bog01 
    CALL s_showmsg_init()
    FOREACH boh_cury INTO g_boh[l_ac].*
         IF g_sma.sma118 = 'Y' THEN
            IF g_boh[l_ac].boh11 = '2' THEN
               SELECT count(*) INTO l_n4 FROM bmv_file
                WHERE bmv01 = g_boh[l_ac].boh03
                  AND bmv03 = g_boh[l_ac].boh04
                  AND bmv02 = g_boh[l_ac].boh05
                  AND bmv04 = g_boh[l_ac].boh06
                  AND bmv05 = g_boh[l_ac].boh13
               IF l_n4 > 0 THEN
                  CALL s_errmsg('boh03,boh04,boh05,boh02',g_showmsg,'','abm-417',1)
                  LET g_success='N'
               END IF
            ELSE IF g_boh[l_ac].boh11 = '1' THEN
                       SELECT count(*) INTO l_n2 FROM bmv_file
                        WHERE bmv01 = g_boh[l_ac].boh03
                          AND bmv03 = g_boh[l_ac].boh04
                          AND bmv02 = g_boh[l_ac].boh05
                          AND bmv04 = g_boh[l_ac].boh06
                          AND bmv05 = g_boh[l_ac].boh13
                          AND bmv09 != g_boh[l_ac].boh02
                       IF l_n2 > 0 THEN
                          CALL s_errmsg('boh03,boh04,boh05,boh02',g_showmsg,'','abm-417',1)
                          LET g_success='N'
                       END IF
                    END IF
            END IF 
         ELSE
            IF g_boh[l_ac].boh11 = '2' THEN
               SELECT count(*) INTO l_n4 FROM bmv_file
                WHERE bmv01 = g_boh[l_ac].boh03
                  AND bmv02 = g_boh[l_ac].boh05
                  AND bmv04 = g_boh[l_ac].boh06
                  AND bmv05 = g_boh[l_ac].boh13
               IF l_n4 > 0 THEN
                   CALL s_errmsg('boh03,boh04,boh05,boh02',g_showmsg,'set count',STATUS,1)
                   LET g_success='N'
               END IF
            ELSE IF g_boh[l_ac].boh11 = '1' THEN
                       SELECT count(*) INTO l_n2 FROM bmv_file
                        WHERE bmv01 = g_boh[l_ac].boh03
                          AND bmv02 = g_boh[l_ac].boh05
                          AND bmv04 = g_boh[l_ac].boh06
                          AND bmv05 = g_boh[l_ac].boh13
                          AND bmv09 != g_boh[l_ac].boh02
                       IF l_n2 > 0 THEN
                          CALL s_errmsg('boh03,boh04,boh05,boh02',g_showmsg,'set count',STATUS,1)
                          LET g_success='N'
                       END IF
                    END IF
            END IF 
         END IF
     LET l_ac=l_ac+1
     END FOREACH
     CALL s_showmsg()
     IF g_success='Y' THEN
            UPDATE bog_file                                                                                                         
            SET bog03="Y"                                                                                                           
            WHERE bog01=g_bog.bog01                                                                                                 
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err3("upd","bog_file",g_bog.bog01,"",SQLCA.sqlcode,"","bog03",1)
            ROLLBACK WORK                                                                                                           
        ELSE                                                                                                                        
            COMMIT WORK                                                                                                             
            LET g_bog.bog03="Y"                                                                                                     
            DISPLAY BY NAME g_bog.bog03                                                                                    
        END IF                                                                                                                      
     END IF                                                                                                                      
END FUNCTION
 
FUNCTION i617_notconfirm()      
    IF s_shut(0) THEN RETURN END IF                                                                                                    
    IF cl_null(g_bog.bog01) THEN                                                                             
                                                                                                                                    
       CALL cl_err('',-400,0)                                                                                                       
                                                                                                                                    
       RETURN                                                                                                                       
                                                                                                                                    
    END IF              
    IF g_bog.bog03 = 'X' THEN RETURN END IF  #CHI-C80041    
    IF g_bog.bog03="N" OR g_bog.bog04="Y" OR g_bog.bogacti="N" THEN                                                                                    
        CALL cl_err("",'atm-365',1)                                                                                                 
    ELSE                                                                                                                            
        IF cl_confirm('aap-224') THEN                                                                                               
                                                                                                                                    
         BEGIN WORK                                                                                                                 
         UPDATE bog_file                                                                                                            
           SET bog03="N"                                                                                                            
         WHERE bog01=g_bog.bog01                                                                                                    
        IF SQLCA.sqlcode THEN                                                                                                       
          CALL cl_err3("upd","bog_file",g_bog.bog01,"",SQLCA.sqlcode,"","bog03",1)
          ROLLBACK WORK                                                                                                             
        ELSE                                                                                                                        
          COMMIT WORK                                                                                                               
          LET g_bog.bog03="N"                                                                                                       
          DISPLAY BY NAME g_bog.bog03                                                                                      
        END IF                                                                                                                      
        END IF                                                                                                                      
    END IF                                                                                                                          
END FUNCTION
 
FUNCTION i617_g()
  DEFINE l_cmd    LIKE type_file.chr1000 
  DEFINE l_boh01  LIKE boh_file.boh01
  DEFINE l_boh02  LIKE boh_file.boh02
  DEFINE l_boh03  LIKE boh_file.boh03
  DEFINE l_boh04  LIKE boh_file.boh04
  DEFINE l_boh05  LIKE boh_file.boh05
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_bog.bog01) THEN CALL cl_err('','-400',0) RETURN END IF  
  IF g_bog.bog03 = 'N' THEN CALL cl_err('','aap-717',0) RETURN END IF
  IF g_bog.bog03 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
  IF g_bog.bogacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF 
  IF g_bog.bog04 = 'Y' THEN CALL cl_err(g_bog.bog04,'abm-003',0) RETURN END IF
  SELECT COUNT(*) INTO g_cnt FROM boh_file WHERE boh01=g_bog.bog01
  IF g_cnt=0 THEN
     CALL cl_err('','arm-034',0) RETURN
  END IF
  BEGIN WORK                                                                                                                      
                                                                                                                                    
    OPEN i617_cl USING g_bog01                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("OPEN i617_cl:", STATUS, 1)                                                                                      
       CLOSE i617_cl                                                                                                                
       ROLLBACK WORK                                                                                                                
       RETURN                                                                                                                       
    END IF                                                                                                                          
    FETCH i617_cl INTO g_bog.*                                                                                                      
    IF SQLCA.sqlcode THEN                                                                                                           
       CALL cl_err(g_bog.bog01,SQLCA.sqlcode,0) RETURN                                                                              
    END IF                                                                                                                          
    CALL i617_show()                                                                                                                
    IF NOT cl_confirm('abm-004') THEN RETURN END IF                                                                                 
    LET g_bog.bog05=g_today                                                                                                         
    CALL cl_set_head_visible("","YES")
    INPUT BY NAME g_bog.bog05 WITHOUT DEFAULTS                                                                                      
                                                                                                                                    
      AFTER FIELD bog05                                                                                                           
        IF cl_null(g_bog.bog05) THEN NEXT FIELD bog05 END IF                                                                        
        IF g_bog.bog05 < g_bog.bog02 THEN
           CALL cl_err('','apm-055',0)
           NEXT FIELD bog05
        END IF
                                                                                                                                    
      AFTER INPUT                                                                                                                   
        IF INT_FLAG THEN EXIT INPUT END IF                                                                                          
        IF cl_null(g_bog.bog05) THEN NEXT FIELD bog05 END IF
 
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
         LET g_bog.bog05=NULL                                                                                                         
         DISPLAY BY NAME g_bog.bog05                                                                                                  
         LET INT_FLAG=0                                                                                                               
         ROLLBACK WORK                                                                                                                
         RETURN                                                                                                                       
      END IF                                                                                                                          
      
     LET g_success = 'Y'
     DECLARE boh_cury1 CURSOR FOR
             SELECT boh03,boh04,boh05,boh02,boh11,boh06,boh10,
                    boh07,boh08,boh09,boh15,boh12,boh13,boh14
              FROM boh_file WHERE boh01 = g_bog.bog01 
     FOREACH boh_cury1 INTO g_boh[l_ac].*
      IF g_sma.sma118 =  'Y' THEN
       CASE g_boh[l_ac].boh11 
         WHEN '3' 
          DELETE FROM bmv_file
           WHERE bmv01 = g_boh[l_ac].boh03
             AND bmv03 = g_boh[l_ac].boh04
             AND bmv02 = g_boh[l_ac].boh05
             AND bmv09 = g_boh[l_ac].boh02
             IF SQLCA.sqlcode THEN                                                                                                  
                CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                LET g_success = 'N'                                                                                                      
                EXIT FOREACH                                                                                                             
             END IF
         WHEN '2' 
               INSERT INTO bmv_file 
               VALUES(g_boh[l_ac].boh03,g_boh[l_ac].boh05,g_boh[l_ac].boh04,
                      g_boh[l_ac].boh06,g_boh[l_ac].boh13,g_boh[l_ac].boh14,
                      g_boh[l_ac].boh12,g_boh[l_ac].boh15,g_boh[l_ac].boh02)
               IF SQLCA.sqlcode THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF       
         WHEN '1' 
               IF g_boh[l_ac].boh12 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv07 = g_boh[l_ac].boh12
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv03 = g_boh[l_ac].boh04
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh13 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv05 = g_boh[l_ac].boh13
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv03 = g_boh[l_ac].boh04
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh14 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv06 = g_boh[l_ac].boh14
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv03 = g_boh[l_ac].boh04
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh15 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv08 = g_boh[l_ac].boh15
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv03 = g_boh[l_ac].boh04
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh02 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv09 = g_boh[l_ac].boh02
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv03 = g_boh[l_ac].boh04
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
                  
       END CASE
       IF SQLCA.sqlcode  THEN                                                                                                  
           CALL cl_err3("sql","boh_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","boh13",1)                                             
           LET g_success = 'N'                                                                                                      
           EXIT FOREACH                                                                                                             
       END IF
      ELSE
       CASE g_boh[l_ac].boh11 
         WHEN '3' 
          DELETE FROM bmv_file
           WHERE bmv01 = g_boh[l_ac].boh03
             AND bmv02 = g_boh[l_ac].boh05
             AND bmv09 = g_boh[l_ac].boh02
           IF SQLCA.sqlcode THEN                                                                                                  
              CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
              LET g_success = 'N'                                                                                                      
              EXIT FOREACH                                                                                                             
           END IF
         WHEN '2' 
               IF cl_null(g_boh[l_ac].boh04) THEN LET g_boh[l_ac].boh04 = ' ' END IF
               INSERT INTO bmv_file(bmv01,bmv02,bmv03,bmv04,bmv05,bmv06,bmv07,bmv08,bmv09) 
               VALUES(g_boh[l_ac].boh03,g_boh[l_ac].boh05,g_boh[l_ac].boh04,
                      g_boh[l_ac].boh06,g_boh[l_ac].boh13,g_boh[l_ac].boh14,
                      g_boh[l_ac].boh12,g_boh[l_ac].boh15,g_boh[l_ac].boh02)
              IF SQLCA.sqlcode THEN                                                                                                  
                 CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                 LET g_success = 'N'                                                                                                      
                 EXIT FOREACH                                                                                                             
              END IF       
         WHEN '1' 
               IF g_boh[l_ac].boh12 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv07 = g_boh[l_ac].boh12
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh13 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv05 = g_boh[l_ac].boh13
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh14 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv06 = g_boh[l_ac].boh14
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh15 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv08 = g_boh[l_ac].boh15
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
               IF g_boh[l_ac].boh02 IS NOT NULL THEN
                  UPDATE bmv_file SET bmv09 = g_boh[l_ac].boh02
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv09 = g_boh[l_ac].boh02
               END IF 
               IF SQLCA.sqlcode  THEN                                                                                                  
                  CALL cl_err3("sql","bmv_file",g_bog.bog01,g_boh[l_ac].boh02,SQLCA.sqlcode,"","",1)                                             
                  LET g_success = 'N'                                                                                                      
                  EXIT FOREACH                                                                                                             
               END IF
       END CASE
      END IF
     LET l_ac=l_ac+1
     END FOREACH
     UPDATE bog_file SET bog05=g_bog.bog05,                                                                                          
                         bog04='Y'                                                                                                   
                     WHERE bog01=g_bog.bog01                                                                                          
     IF SQLCA.SQLERRD[3]=0 THEN                                                                                                      
        LET g_bog.bog05=NULL                                                                                                         
        DISPLAY BY NAME g_bog.bog05                                                                                                  
        CALL cl_err3("upd","bog_file",g_bog.bog01,"",SQLCA.sqlcode,"","up bog05",1)                                                  
        LET g_success = 'N'
        RETURN                                                                                                                       
     END IF
    IF g_success = 'N' THEN                                                                                                         
       ROLLBACK WORK                                                                                                                
    ELSE                                                                                                                            
       COMMIT WORK                                                                                                                  
    END IF
    SELECT bog04 INTO g_bog.bog04 FROM bog_file WHERE bog01=g_bog.bog01                                                             
    DISPLAY BY NAME g_bog.bog05                                                                                                     
    DISPLAY BY NAME g_bog.bog04
 
END FUNCTION
 
FUNCTION i617_set_boh11()                                                                                                           
   DEFINE lcbo_target ui.ComboBox                                                                                                   
 
   LET lcbo_target = ui.ComboBox.forName("boh11")   
   IF g_boh[l_ac].boh11='1' OR g_boh[l_ac].boh11 = '3' THEN
      CALL lcbo_target.RemoveItem("2")         
   END IF  
END FUNCTION
 
FUNCTION i617_set_boh11a()
   DEFINE lcbo_target ui.ComboBox
   DEFINE l_str       STRING
   DEFINE l_ze03 LIKE ze_file.ze03
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='abm-105'
     AND ze02=g_lang
   
   LET lcbo_target = ui.ComboBox.forName("boh11")
   LET l_str = l_ze03
   IF g_boh[l_ac].boh11 != '2' THEN
      CALL lcbo_target.AddItem("2",l_str)
   END IF
END FUNCTION
 
FUNCTION i617_check()
DEFINE
    l_cnt           LIKE type_file.num5,
    l_bmv04         LIKE bmv_file.bmv04,
    l_bmv08         LIKE bmv_file.bmv08,
    l_bmv07         LIKE bmv_file.bmv07,
    l_bmv05         LIKE bmv_file.bmv05,
    l_bmv06         LIKE bmv_file.bmv06
   
   CALL cl_set_comp_entry("boh06,boh11",TRUE)
    IF g_boh[l_ac].boh11 = '3' THEN
       LET g_boh[l_ac].boh15 = " "
       LET g_boh[l_ac].boh12 = " "
       LET g_boh[l_ac].boh13 = " "
       LET g_boh[l_ac].boh14 = " "
    END IF
    LET g_cnt=0
    IF g_sma.sma118 = 'Y' THEN
    SELECT COUNT(*) INTO g_cnt
      FROM bmv_file
     WHERE bmv09 = g_boh[l_ac].boh02
       AND bmv01 = g_boh[l_ac].boh03
       AND bmv02 = g_boh[l_ac].boh05
       AND bmv03 = g_boh[l_ac].boh04
    ELSE
    SELECT COUNT(*) INTO g_cnt
      FROM bmv_file
     WHERE bmv09 = g_boh[l_ac].boh02
       AND bmv01 = g_boh[l_ac].boh03
       AND bmv02 = g_boh[l_ac].boh05
    END IF
    IF g_cnt = 0 THEN
       LET g_boh[l_ac].boh11 = '2'
       CALL cl_set_comp_entry("boh11",FALSE)
       LET g_boh[l_ac].boh10 = " "
       LET g_boh[l_ac].boh07 = " "
       LET g_boh[l_ac].boh08 = " "
       LET g_boh[l_ac].boh09 = " "
       DISPLAY BY NAME g_boh[l_ac].boh10
       DISPLAY BY NAME g_boh[l_ac].boh07
       DISPLAY BY NAME g_boh[l_ac].boh08
       DISPLAY BY NAME g_boh[l_ac].boh09
    ELSE
       IF g_boh[l_ac].boh11 = '2' THEN
          LET g_boh[l_ac].boh11 = '1'
       END IF
       IF g_sma.sma118 = 'Y' THEN
       SELECT bmv04,bmv08,bmv07,bmv05,bmv06  
         INTO l_bmv04,l_bmv08,l_bmv07,l_bmv05,l_bmv06
         FROM bmv_file
        WHERE bmv09 = g_boh[l_ac].boh02
          AND bmv01 = g_boh[l_ac].boh03
          AND bmv02 = g_boh[l_ac].boh05
          AND bmv03 = g_boh[l_ac].boh04
       ELSE
       SELECT bmv04,bmv08,bmv07,bmv05,bmv06  
         INTO l_bmv04,l_bmv08,l_bmv07,l_bmv05,l_bmv06
         FROM bmv_file
        WHERE bmv09 = g_boh[l_ac].boh02
          AND bmv01 = g_boh[l_ac].boh03
          AND bmv02 = g_boh[l_ac].boh05
       END IF
       LET g_boh[l_ac].boh06 = l_bmv04
       LET g_boh[l_ac].boh10 = l_bmv08
       LET g_boh[l_ac].boh07 = l_bmv07
       LET g_boh[l_ac].boh08 = l_bmv05
       LET g_boh[l_ac].boh09 = l_bmv06
       DISPLAY BY NAME g_boh[l_ac].boh06
       DISPLAY BY NAME g_boh[l_ac].boh10
       DISPLAY BY NAME g_boh[l_ac].boh07
       DISPLAY BY NAME g_boh[l_ac].boh08
       DISPLAY BY NAME g_boh[l_ac].boh09
       CALL cl_set_comp_entry("boh06",FALSE)
    END IF
END FUNCTION
 
FUNCTION i617_checkerr1()
DEFINE   l_flag     LIKE type_file.chr1
DEFINE   l_n        LIKE type_file.num5
 
    LET l_flag = 'Y'
        IF g_sma.sma118 = 'Y' THEN
           SELECT count(*) INTO l_n FROM boh_file,bog_file
            WHERE boh01 = bog01
              AND bog04 != 'Y'
              AND boh03 = g_boh[l_ac].boh03
              AND boh04 = g_boh[l_ac].boh04
              AND boh05 = g_boh[l_ac].boh05
              AND boh02 = g_boh[l_ac].boh02
              AND bog03 <> 'X'  #CHI-C80041
              IF l_n> 0 THEN                  
                 LET l_flag = 'N'
              END IF
        ELSE
          SELECT count(*) INTO l_n FROM boh_file,bog_file
           WHERE boh01 = bog01
             AND bog04 != 'Y'
             AND boh03 = g_boh[l_ac].boh03
             AND boh05 = g_boh[l_ac].boh05
             AND boh02 = g_boh[l_ac].boh02
             AND bog03 <> 'X'  #CHI-C80041
           IF l_n > 0 THEN                  
              LET l_flag = 'N'
           END IF
        END IF
        RETURN l_flag
        
END FUNCTION
 
FUNCTION i617_checkerr2()
DEFINE   l_flag1     LIKE type_file.chr1
DEFINE   l_flag2     LIKE type_file.chr1
DEFINE   l_flag3     LIKE type_file.chr1
DEFINE   l_flag4     LIKE type_file.chr1
DEFINE   l_n1        LIKE type_file.num5
DEFINE   l_n2        LIKE type_file.num5
 
   LET l_flag1 = '0'
   LET l_flag2 = '0'
   LET l_flag3 = '0'
   LET l_flag4 = '0'
       IF g_sma.sma118 = 'Y' THEN
          IF g_boh[l_ac].boh11 = '2' THEN
             SELECT count(*) INTO l_n1 FROM boh_file
              WHERE boh03 = g_boh[l_ac].boh03
                AND boh04 = g_boh[l_ac].boh04
                AND boh05 = g_boh[l_ac].boh05
                AND boh06 = g_boh[l_ac].boh06
                AND ((boh13 = g_boh[l_ac].boh13 AND boh11 = '2') OR
                     (boh11 = '1' AND boh13 = g_boh[l_ac].boh13 AND
                      boh13 IS NOT NULL AND boh13 != '') OR
                     (boh11 = '1' AND boh08 = g_boh[l_ac].boh13 AND
                     (boh13 IS NULL AND boh13 = '')))
                AND boh01 = g_bog.bog01
           IF l_n1 > 0 THEN
              LET l_flag1 = '1'
           END IF
           SELECT count(*) INTO l_n2 FROM bmv_file
            WHERE bmv01 = g_boh[l_ac].boh03
              AND bmv03 = g_boh[l_ac].boh04
              AND bmv02 = g_boh[l_ac].boh05
              AND bmv04 = g_boh[l_ac].boh06
              AND bmv05 = g_boh[l_ac].boh13
           IF l_n2 > 0 THEN
              LET l_flag2 = '2'
           END IF
          ELSE IF g_boh[l_ac].boh11 = '1' THEN
               IF g_boh[l_ac].boh13 IS NOT NULL OR g_boh[l_ac].boh13 !='' THEN
                  SELECT count(*) INTO l_n1 FROM boh_file
                   WHERE boh03 = g_boh[l_ac].boh03
                     AND boh04 = g_boh[l_ac].boh04
                     AND boh05 = g_boh[l_ac].boh05
                     AND boh06 = g_boh[l_ac].boh06
                     AND ((boh13 = g_boh[l_ac].boh13 AND
                           boh11 = '2') OR (boh11 = '1' AND
                           boh13 = g_boh[l_ac].boh13 AND
                           boh13 IS NOT NULL AND boh13 != '') OR
                           (boh11 = '1' AND boh08 = g_boh[l_ac].boh13 AND
                           (boh13 IS NULL AND boh13 = '')))
                     AND boh01 = g_bog.bog01
                     IF l_n1 > 0 THEN
                        LET l_flag3='3'
                     END IF
                  SELECT count(*) INTO l_n2 FROM bmv_file
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv03 = g_boh[l_ac].boh04
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv04 = g_boh[l_ac].boh06
                     AND bmv05 = g_boh[l_ac].boh13
                     AND bmv09 != g_boh[l_ac].boh02
                  IF l_n2 > 0 THEN
                     LET l_flag4 = '4'
                  END IF
               END IF
          END IF
          END IF 
       ELSE
         IF g_boh[l_ac].boh11 = '2' THEN
            SELECT count(*) INTO l_n1 FROM boh_file
             WHERE boh03 = g_boh[l_ac].boh03
               AND boh05 = g_boh[l_ac].boh05
               AND boh06 = g_boh[l_ac].boh06
               AND ((boh13 = g_boh[l_ac].boh13 AND boh11 = '2') OR
                   (boh11 = '1' AND boh13 = g_boh[l_ac].boh13 AND
                   boh13 IS NOT NULL AND boh13 != '') OR
                   (boh11 = '1' AND boh08 = g_boh[l_ac].boh13 AND
                   (boh13 IS NULL AND boh13 = '')))
               AND boh01 = g_bog.bog01
            IF l_n1 > 0 THEN
               LET l_flag1 = '1'
            END IF
            SELECT count(*) INTO l_n2 FROM bmv_file
             WHERE bmv01 = g_boh[l_ac].boh03
               AND bmv02 = g_boh[l_ac].boh05
               AND bmv04 = g_boh[l_ac].boh06
               AND bmv05 = g_boh[l_ac].boh13
            IF l_n2 > 0 THEN
               LET l_flag2 = '2'
            END IF
         ELSE IF g_boh[l_ac].boh11 = '1' THEN
              IF g_boh[l_ac].boh13 IS NOT NULL OR g_boh[l_ac].boh13 !='' THEN
                 SELECT count(*) INTO l_n1 FROM boh_file
                  WHERE boh03 = g_boh[l_ac].boh03
                    AND boh05 = g_boh[l_ac].boh05
                    AND boh06 = g_boh[l_ac].boh06
                    AND ((boh13 = g_boh[l_ac].boh13 AND
                         boh11 = '2') OR (boh11 = '1' AND
                         boh13 = g_boh[l_ac].boh13 AND
                         boh13 IS NOT NULL AND boh13 != '') OR
                         (boh11 = '1' AND boh08 = g_boh[l_ac].boh13 AND
                         (boh13 IS NULL AND boh13 = '')))
                     AND boh01 = g_bog.bog01
                  IF l_n1 > 0 THEN
                     LET l_flag3 = '3'
                  END IF
                 SELECT count(*) INTO l_n2 FROM bmv_file
                   WHERE bmv01 = g_boh[l_ac].boh03
                     AND bmv02 = g_boh[l_ac].boh05
                     AND bmv04 = g_boh[l_ac].boh06
                     AND bmv05 = g_boh[l_ac].boh13
                     AND bmv09 != g_boh[l_ac].boh02
                 IF l_n2 > 0 THEN
                    LET l_flag4 = '4'
                 END IF
               END IF
              END IF
         END IF 
         END IF
         RETURN l_flag1,l_flag2,l_flag3,l_flag4
END FUNCTION
#No.FUN-810017
#No.FUN-840137
#CHI-C80041---begin
#FUNCTION i617_v()        #CHI-D20010
FUNCTION i617_v(p_type)   #CHI-D20010
DEFINE l_chr  LIKE type_file.chr1
DEFINE l_flag LIKE type_file.chr1
DEFINE p_type LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_bog01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_bog.bog03 = 'X' THEN RETURN END IF
   ELSE
      IF g_bog.bog03 <> 'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i617_cl USING g_bog01
   IF STATUS THEN
      CALL cl_err("OPEN i617_cl:", STATUS, 1)
      CLOSE i617_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i617_cl INTO g_bog.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bog01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i617_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_bog.bog03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_bog.bog03) THEN 
        LET l_chr=g_bog.bog03
       #IF g_bog.bog03='N' THEN   #CHI-D20010
        IF p_type = 1 THEN   #CHI-D20010
            LET g_bog.bog03='X' 
        ELSE
            LET g_bog.bog03='N'
        END IF
        UPDATE bog_file
            SET bog03=g_bog.bog03,  
                bogmodu=g_user,
                bogdate=g_today
            WHERE bog01=g_bog01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bog_file",g_bog01,"",SQLCA.sqlcode,"","",1)  
            LET g_bog.bog03=l_chr 
        END IF
        DISPLAY BY NAME g_bog.bog03
   END IF
 
   CLOSE i617_cl
   COMMIT WORK
   CALL cl_flow_notify(g_bog01,'V')
 
END FUNCTION
#CHI-C80041---end
