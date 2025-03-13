# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saimi107.4gl
# Descriptions...: 料件基本資料維護作業-成本項目結構
# Date & Author..: 91/11/07 By Wu
# Modify ........: 92/06/18 畫面上增加 [成本項目資料處理狀況](ima93[7,7])
#                           的input查詢...... By Lin
#                  Note: 因原本的l_sql只from iml_file,現加 ima93
#                        的查詢條件,所以必須改成 from ima_file,iml_file
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0171 04/11/30 By Mandy b_fill出來有值,但是按'b'之後,會報100的錯誤
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-580014 05/08/16 By jackie 轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 將列印單頭的料號、品名位置放大
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-640021 06/04/06 By Claire 將訊息 prompt出來
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/26 By jamie 1.FUNCTION i107_q() 一開始應清空g_iml.*值
#                                                  2.新增action"相關文件"   
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790061 07/09/10 By lumxa 查詢時候，狀態是灰色，不能查詢
# Modify.........: No.TQC-790172 07/09/29 By Pengu p_flow unicode 區無法執行程式
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840029 08/04/21 By sherry 報表改由CR輸出
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By xumm 修改FUN-D40030遗留问题

DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
DEFINE    #No.TQC-790172 
    g_iml01         LIKE iml_file.iml01    #類別代號 (假單頭)
END GLOBALS
 
DEFINE
    g_iml01_t       LIKE iml_file.iml01,    #類別代號 (舊值)
    g_iml           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        iml02       LIKE iml_file.iml02,    #成本項目
        smg02       LIKE smg_file.smg02,    #說明
        smg03       LIKE smg_file.smg03,    #類別
        iml031      LIKE iml_file.iml031,   #標準成本
        iml032      LIKE iml_file.iml032,   #現時成本
        iml033      LIKE iml_file.iml033    #預設成本
                    END RECORD,
    g_iml_t         RECORD                  #程式變數 (舊值)
        iml02       LIKE iml_file.iml02,    #成本項目
        smg02       LIKE smg_file.smg02,    #說明
        smg03       LIKE smg_file.smg03,    #類別
        iml031      LIKE iml_file.iml031,   #標準成本
        iml032      LIKE iml_file.iml032,   #現時成本
        iml033      LIKE iml_file.iml033    #預設成本
                    END RECORD,
    g_iml_o         RECORD                  #程式變數 (舊值)
        iml02       LIKE iml_file.iml02,    #成本項目
        smg02       LIKE smg_file.smg02,    #說明
        smg03       LIKE smg_file.smg03,    #類別
        iml031      LIKE iml_file.iml031,   #標準成本
        iml032      LIKE iml_file.iml032,   #現時成本
        iml033      LIKE iml_file.iml033    #預設成本
                    END RECORD,
    g_argv1         LIKE iml_file.iml01,
    g_imauser       LIKE ima_file.imauser,
    g_bookno        LIKE aaa_file.aaa01,    #帳別
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    g_imagrup       LIKE ima_file.imagrup,
    g_imamodu       LIKE ima_file.imamodu,
    g_imadate       LIKE ima_file.imadate,
    g_imaacti       LIKE ima_file.imaacti,
    g_wc,g_sql      string,                 #No.FUN-580092 HCN
    g_ss            LIKE type_file.chr1,    #決定後續步驟  #No.FUN-690026 VARCHAR(1)
    g_s             LIKE type_file.chr1,    #料件處理狀況  #No.FUN-690026 VARCHAR(1)
    g_rec           LIKE type_file.num5,    #單身筆數      #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5    #FUN-570110  #No.FUN-690026 SMALLINT
DEFINE g_str                 STRING                 #No.FUN-840029 
 
FUNCTION aimi107(p_argv1)
    DEFINE p_argv1       LIKE ima_file.ima01

    WHENEVER ERROR CALL cl_err_msg_log  
 
    IF g_sma.sma58 MATCHES '[Nn]' THEN
       CALL cl_err(g_sma.sma58,'mfg9046',1)    #TQC-640021  #0->1
       RETURN
    END IF

    LET g_argv1 = ARG_VAL(1)
    LET g_iml01 = NULL                     #清除鍵值
    LET g_iml01_t = NULL
    LET g_argv1 = p_argv1

    OPEN WINDOW aimi107_w WITH FORM "aim/42f/aimi107"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL s_shwact(3,2,g_bookno)
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL aimi107_q()
    END IF

    CALL aimi107_menu()
    CLOSE WINDOW aimi107_w                 #結束畫面
END FUNCTION
 

FUNCTION aimi107_curs()
    CLEAR FORM                             #清除畫面
    CALL g_iml.clear()
    IF g_argv1 IS NULL OR  g_argv1 = ' '
      THEN 
           INITIALIZE g_iml01 TO NULL   #FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
           CONSTRUCT g_wc ON iml01,iml02,iml031,iml032,iml033   #螢幕上取條件
                             ,imauser,imamodu,imaacti,imagrup,imadate #TQC-790061
                             ,imaoriu,imaorig  #TQC-B90177
                FROM iml01,s_iml[1].iml02,s_iml[1].iml031,
                     s_iml[1].iml032,s_iml[1].iml033
                     ,imauser,imamodu,imaacti,imagrup,imadate #TQC-790061
                     ,imaoriu,imaorig  #TQC-B90177

             #No.FUN-580031 --start--     HCN
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
             #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(iml01)
#FUN-AA0059 --Begin--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ima"
                   LET g_qryparam.state= "c"
                   LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"       #FUN-AB0025
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                 # CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret     #FUN-AB0025
#FUN-AA0059 --End--
                   CALL aimi107_iml01('d')
                   DISPLAY g_qryparam.multiret TO iml01
                WHEN INFIELD(iml02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_smg"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL aimi107_iml02('d')
                   DISPLAY g_qryparam.multiret TO iml02
                OTHERWISE
                   EXIT CASE
            END CASE
 
               #No.FUN-580031 --start--     HCN
               ON ACTION qbe_select
                  CALL cl_qbe_select()
               ON ACTION qbe_save
                  CALL cl_qbe_save()
               #No.FUN-580031 --end--       HCN
 
            #-----TQC-860018---------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT 
            
            ON ACTION about         
               CALL cl_about()      
            
            ON ACTION help          
               CALL cl_show_help()  
 
            ON ACTION CONTROLG
               CALL cl_cmdask()
            #-----END TQC-860018-----
 
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
            IF INT_FLAG THEN RETURN END IF
            LET g_s=NULL
           INPUT g_s   WITHOUT DEFAULTS FROM s
 
               AFTER FIELD s  #資料處理狀況
                   IF g_s NOT MATCHES '[YN]' THEN
                      NEXT FIELD s
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
           IF INT_FLAG THEN RETURN END IF
           IF g_s IS NOT NULL THEN
              LET g_wc=g_wc CLIPPED," AND ima93[7,7] matches '",g_s,"' "
           END IF
      ELSE  LET g_wc = " iml01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE iml01 FROM ima_file,iml_file ",
               " WHERE ima01=iml01 AND ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE aimi107_prepare FROM g_sql      #預備一下
    DECLARE aimi107_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR aimi107_prepare
    LET g_sql="SELECT COUNT(DISTINCT iml01 )",
              "  FROM ima_file,iml_file WHERE ima01=iml01 AND  ",g_wc CLIPPED
    PREPARE aimi107_precount FROM g_sql
    DECLARE aimi107_count CURSOR FOR aimi107_precount
END FUNCTION
 
FUNCTION aimi107_menu()
 
   WHILE TRUE
      CALL aimi107_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL aimi107_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL aimi107_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL aimi107_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL aimi107_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_imaacti matches'[Yy]' THEN      #檢查資料是否為無效
                  CALL aimi107_b()
               ELSE
                  CALL cl_err(g_iml01,'mfg1000',0)
               END IF
            ELSE                                    #TQC-D40025 Add
               LET g_action_choice = ""             #TQC-D40025 Add 
            END IF
           #LET g_action_choice = ""                #TQC-D40025 Mark
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL aimi107_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL aimi107_r()
            END IF
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_iml),'','')
            END IF
 
         #No.FUN-680046-------add--------str----     
         WHEN "related_document"                        
            IF cl_chk_act_auth() THEN                 
                IF g_iml01 IS NOT NULL THEN             
                   LET g_doc.column1 = "iml01"       
                   LET g_doc.value1 = g_iml01      
                   CALL cl_doc()                  
                END IF                           
            END IF                             
        #No.FUN-680046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION aimi107_a()
    MESSAGE ""
    CLEAR FORM
   CALL g_iml.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_iml01 LIKE iml_file.iml01
    LET g_iml01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL aimi107_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0                    #No.FUN-680064
        IF g_ss='N' THEN
           CALL g_iml.clear()
#           LET g_rec_b = 0                #No.FUN-680064
        ELSE
           CALL aimi107_b_fill('1=1')         #單身
        END IF
        CALL aimi107_b()                   #輸入單身
      # UPDATE ima_file SET ima93=SUBSTRING(ima93,1,6)+'Y'+SUBSTRING(ima93,8,8)  #No.TQC-9B0021
        UPDATE ima_file SET ima93=ima93[1,6] || 'Y' || ima93[8,8],  #No.TQC-9B0021
                            imadate = g_today     #FUN-C30315 add
                        WHERE ima01 = g_iml01
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_iml01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","ima_file",g_iml01,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
        END IF
        LET g_iml01_t = g_iml01            #保留舊值
        DISPLAY 'Y' TO FORMONLY.s
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION aimi107_u()

    IF s_shut(0) THEN RETURN END IF
    IF g_iml01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_chkey matches'[Nn]' THEN  RETURN END IF     #key 是否可修改
    IF g_imaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_iml01,'mfg1000',0)
        RETURN
    END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_iml01_t = g_iml01
    BEGIN WORK     #No.+205 mark 拿掉
    WHILE TRUE
        CALL aimi107_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_iml01=g_iml01_t
            DISPLAY g_iml01 TO iml01               #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_iml01 != g_iml01_t THEN             #更改單頭值
            UPDATE iml_file SET iml01 = g_iml01  #更新DB
                WHERE iml01 = g_iml01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_iml01,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("upd","iml_file",g_iml01_t,"",SQLCA.sqlcode,"",
                            "",1)   #No.FUN-660156
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
#處理INPUT
FUNCTION aimi107_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_iml01
        WITHOUT DEFAULTS
        FROM iml01
 
#No.FUN-570110 --start
        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL i107_set_entry(p_cmd)
             CALL i107_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
#No.FUN-570110 --end
        BEFORE FIELD iml01
            IF p_cmd = 'a' AND g_argv1 IS NOT NULL AND g_argv1 != ' '
               THEN  LET g_iml01 = g_argv1
                     CALL aimi107_iml01('a')
                     DISPLAY BY NAME g_iml01
            END IF
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,12,g_iml01) RETURNING g_iml01
	               DISPLAY BY NAME g_iml01
      	    END IF
 
        AFTER FIELD iml01                  #料件編號
            IF NOT cl_null(g_iml01) THEN
               IF g_iml01 != g_iml01_t OR     #輸入後更改不同時值
                  g_iml01_t IS NULL THEN
                   SELECT UNIQUE iml01 INTO g_chr
                       FROM iml_file
                       WHERE iml01=g_iml01
                   IF SQLCA.sqlcode THEN             #不存在, 新來的
                       IF p_cmd='a' THEN
                           LET g_ss='N'
                       END IF
                   ELSE
                       IF p_cmd='u' THEN
                           CALL cl_err(g_iml01,-239,0)
                           LET g_iml01=g_iml01_t
                           NEXT FIELD iml01
                       END IF
                   END IF
               END IF
               CALL aimi107_iml01('a')
               IF g_chr = 'E' THEN
                   CALL cl_err(g_iml01,'mfg1201',0)
                   LET g_iml01 = g_iml01_t
                   DISPLAY BY NAME g_iml01
                   NEXT FIELD iml01
               END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(iml01)
#FUN-AA0059 --Begin--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ima"
                   LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"     #FUN-AB0025
                   LET g_qryparam.default1 = g_iml01
                   CALL cl_create_qry() RETURNING g_iml01
                #  CALL q_sel_ima(FALSE, "q_ima", "", g_iml01, "", "", "", "" ,"",'' )  RETURNING g_iml01     #FUN-AB0025
#FUN-AA0059 --End--
                   CALL aimi107_iml01('d')
                   DISPLAY g_iml01 TO iml01
                OTHERWISE
                   EXIT CASE
            END CASE
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        #-----END TQC-860018-----
    END INPUT
END FUNCTION
 
FUNCTION  aimi107_iml01(p_cmd)
DEFINE
    p_cmd       LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
    l_ima05     LIKE ima_file.ima05,
    l_ima08     LIKE ima_file.ima08,
    l_ima25     LIKE ima_file.ima25,
    l_ima02     LIKE ima_file.ima02,
    l_ima021    LIKE ima_file.ima021,
   #l_ima86     LIKE ima_file.ima86,     #FUN-560183
   #l_ima86_fac LIKE ima_file.ima86_fac, #FUN-560183
    l_ima03     LIKE ima_file.ima03,
    l_ima93     LIKE ima_file.ima93
 
  LET g_chr = ' '
  IF g_iml01 IS NULL
    THEN LET l_ima02 = NULL LET l_ima03 = NULL
         LET l_ima021 = NULL
         LET l_ima05 = NULL LET l_ima08 = NULL
        #LET l_ima86 = NULL #LET l_ima86_fac = NULL #FUN-560183
         LET l_ima25 = NULL LET g_chr = 'E'
    ELSE SELECT ima02,ima021,ima03,ima05,ima08,ima25,ima93, #FUN-560183 del ima86,ima86_fac
                imauser,imagrup,imamodu,imadate,imaacti
           INTO l_ima02,l_ima021,l_ima03,l_ima05,l_ima08,l_ima25,
                l_ima93, #FUN-560183 del l_ima86,l_ima86_fac
                g_imauser,g_imagrup,g_imamodu,g_imadate,g_imaacti
           FROM ima_file
           WHERE ima01 = g_iml01
         IF SQLCA.sqlcode THEN
             LET g_chr = 'E'
             LET l_ima02   = NULL   LET l_ima03   = NULL
             LET l_ima021  = NULL
             LET l_ima05   = NULL   LET l_ima08   = NULL
             LET l_ima25   = NULL   LET g_imauser = NULL
            #LET l_ima86   = NULL  #LET l_ima86_fac = NULL #FUN-560183
             LET l_ima93   = NULL
             LET g_imagrup = NULL  LET g_imamodu  = NULL
             LET g_imadate = NULL  LET g_imaacti  = NULL
          ELSE IF g_imaacti matches'[Nn]'
                  THEN LET g_chr = 'E'
               END IF
          END IF
  END IF
  LET g_s=l_ima93[7,7]
  IF g_chr = ' ' OR p_cmd = 'd'
    THEN DISPLAY l_ima02 TO ima02
         DISPLAY l_ima021 TO ima021
         DISPLAY l_ima03 TO ima03
         DISPLAY l_ima05 TO ima05
         DISPLAY l_ima08 TO ima08
         DISPLAY l_ima25 TO ima25
        #DISPLAY l_ima86 TO ima86 #FUN-560183
        #DISPLAY l_ima86_fac TO ima86_fac  #FUN-560183
         DISPLAY g_s TO FORMONLY.s
         DISPLAY g_imauser TO imauser
         DISPLAY g_imagrup TO imagrup
         DISPLAY g_imamodu TO imamodu
         DISPLAY g_imadate TO imadate
         DISPLAY g_imaacti TO imaacti
  END IF
END FUNCTION
#Query 查詢
FUNCTION aimi107_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL g_iml.clear()                     #No.FUN-680046  
    CALL aimi107_curs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN aimi107_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode AND (g_argv1 IS NULL OR g_argv1=' ')
        THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_iml01 TO NULL
    ELSE
        OPEN aimi107_count
        FETCH aimi107_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL aimi107_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION aimi107_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     aimi107_b_curs INTO g_iml01
        WHEN 'P' FETCH PREVIOUS aimi107_b_curs INTO g_iml01
        WHEN 'F' FETCH FIRST    aimi107_b_curs INTO g_iml01
        WHEN 'L' FETCH LAST     aimi107_b_curs INTO g_iml01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump aimi107_b_curs INTO g_iml01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_iml01,SQLCA.sqlcode,0)
        INITIALIZE g_iml01 TO NULL  #TQC-6B0105
    ELSE
       CALL aimi107_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    #FUN-4C0053
    SELECT imauser,imagrup
      INTO g_data_owner ,g_data_group
      FROM ima_file
     WHERE ima01 = g_iml01
    #FUN-4C0053(end)
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION aimi107_show()
    DISPLAY g_iml01 TO iml01               #單頭
    #圖形顯示
    CALL cl_set_field_pic("","","","","",g_imaacti)
    CALL aimi107_iml01('d')                 #單身
    CALL aimi107_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi107_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_iml01 IS NULL THEN
        RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "iml01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_iml01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        BEGIN WORK
        DELETE FROM iml_file WHERE iml01 = g_iml01
        IF SQLCA.sqlcode THEN
#          CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
           CALL cl_err3("del","iml_file",g_iml01,"",SQLCA.sqlcode,"",
                        "BODY DELETE:",1)   #NO.FUN-640266 #No.FUN-660156
        ELSE
            COMMIT WORK
            CLEAR FORM
            CALL g_iml.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN aimi107_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE aimi107_b_curs
               CLOSE aimi107_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH aimi107_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE aimi107_b_curs
               CLOSE aimi107_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN aimi107_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL aimi107_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL aimi107_fetch('/')
            END IF
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION aimi107_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,      #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否  #No.FUN-690026 SMALLINT

 
    LET g_action_choice = ""
 
    IF g_iml01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT iml02,'','',iml031,iml032,iml033 FROM iml_file WHERE iml01 = ? AND iml02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi107_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
  # UPDATE ima_file SET ima93=SUBSTRING(ima93,1,6)+'Y'+SUBSTRING(ima93,8,8) WHERE ima01 = g_iml01  #No.TQC-9B0021
   #UPDATE ima_file SET ima93=ima93[1,6] || 'Y' || ima93[8,8] WHERE ima01 = g_iml01  #No.TQC-9B0021    #FUN-C30315 mark
    UPDATE ima_file SET ima93=ima93[1,6] || 'Y' || ima93[8,8],imadate = g_today WHERE ima01 = g_iml01  #No.TQC-9B0021  #FUN-C30315 add
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_iml WITHOUT DEFAULTS FROM s_iml.* #MOD-4B0171 加上WITHOUT DEFAULTS
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_iml_t.* = g_iml[l_ac].*  #BACKUP
                OPEN aimi107_b_curl USING g_iml01,g_iml_t.iml02
                IF STATUS THEN
                   CALL cl_err("OPEN aimi107_b_curl:", STATUS, 1)
                   CLOSE aimi107_b_curl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH aimi107_b_curl INTO g_iml[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_iml_t.iml02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_iml_t.*=g_iml[l_ac].*
                       LET g_iml_o.*=g_iml[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF l_ac <= l_n then                   #DISPLAY NEWEST
                CALL aimi107_iml02('d')
            END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO iml_file(iml01,iml02,iml031,iml032,iml033)
                VALUES(g_iml01,g_iml[l_ac].iml02,g_iml[l_ac].iml031,
                       g_iml[l_ac].iml032,g_iml[l_ac].iml033)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_iml[l_ac].iml02,SQLCA.sqlcode,0) #No.FUN-660156
              CALL cl_err3("ins","iml_file",g_iml01,g_iml[l_ac].iml02,
                            SQLCA.sqlcode,"","",1)   #No.FUN-660156
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
              DISPLAY g_rec TO FORMONLY.cn2
           END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_iml[l_ac].* TO NULL      #900423
            LET g_iml[l_ac].iml031 = 0
            LET g_iml[l_ac].iml032 = 0
            LET g_iml[l_ac].iml033 = 0
            LET g_iml_t.* = g_iml[l_ac].*         #新輸入資料
            LET g_iml_o.* = g_iml[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD iml02
 
        AFTER FIELD iml02                        #check 序號是否重複
            IF g_iml[l_ac].iml02 IS NOT NULL THEN
              IF (g_iml[l_ac].iml02 != g_iml_t.iml02 OR
                          g_iml_t.iml02 IS NULL) THEN
                      SELECT count(*)
                          INTO l_n
                          FROM iml_file
                          WHERE iml01 = g_iml01 AND
                                iml02 = g_iml[l_ac].iml02
                      IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_iml[l_ac].iml02 = g_iml_t.iml02
                        NEXT FIELD iml02
                      ELSE  CALL aimi107_iml02('a')
                            IF g_chr = 'E' THEN
                               CALL cl_err(g_iml[l_ac].iml02,'mfg1313',0)
                               LET g_iml[l_ac].iml02 = g_iml_t.iml02
                               NEXT FIELD iml02
                            END IF
                      END IF
              END IF
            END IF
 
        AFTER FIELD iml031
            IF NOT cl_null(g_iml[l_ac].iml031)  THEN
               IF g_iml[l_ac].iml031 < 0 THEN
                  CALL cl_err(g_iml[l_ac].iml031,'mfg0013',0)
                  LET g_iml[l_ac].iml031 = g_iml_o.iml031
                  NEXT FIELD iml031
               END IF
            END IF
            LET g_iml_o.iml031 = g_iml[l_ac].iml031
        AFTER FIELD iml032
            IF NOT cl_null(g_iml[l_ac].iml032)  THEN
               IF g_iml[l_ac].iml032 < 0 THEN
                  CALL cl_err(g_iml[l_ac].iml032,'mfg0013',0)
                  LET g_iml[l_ac].iml032 = g_iml_o.iml032
                  NEXT FIELD iml032
               END IF
            END IF
            LET g_iml_o.iml032 = g_iml[l_ac].iml032
        AFTER FIELD iml033
            IF NOT cl_null(g_iml[l_ac].iml033)  THEN
               IF g_iml[l_ac].iml033 < 0 THEN
                  CALL cl_err(g_iml[l_ac].iml033,'mfg0013',0)
                  LET g_iml[l_ac].iml033 = g_iml_o.iml033
                  NEXT FIELD iml033
               END IF
            END IF
            LET g_iml_o.iml033 = g_iml[l_ac].iml033
 
        BEFORE DELETE                            #是否取消單身
            IF g_iml_t.iml02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM iml_file
                    WHERE iml01 = g_iml01 AND
                          iml02 = g_iml_t.iml02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_iml_t.iml02,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("del","iml_file",g_iml01,g_iml_t.iml02,
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec=g_rec-1
                DISPLAY g_rec TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_iml[l_ac].* = g_iml_t.*
               CLOSE aimi107_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_iml[l_ac].iml02,-263,1)
               LET g_iml[l_ac].* = g_iml_t.*
            ELSE
                UPDATE iml_file SET
                       iml02=g_iml[l_ac].iml02,iml031=g_iml[l_ac].iml031,
                       iml032=g_iml[l_ac].iml032,iml033=g_iml[l_ac].iml033
                WHERE iml01 = g_iml01 AND iml02=g_iml_t.iml02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_iml[l_ac].iml02,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("upd","iml_file",g_iml01,g_iml_t.iml02,
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    LET g_iml[l_ac].* = g_iml_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_iml[l_ac].* = g_iml_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_iml.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE aimi107_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE aimi107_b_curl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(iml02)
#                  CALL q_smg(10,26,g_iml[l_ac].iml02) RETURNING g_iml[l_ac].iml02
#                  CALL FGL_DIALOG_SETBUFFER( g_iml[l_ac].iml02 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_smg"
                   LET g_qryparam.default1 = g_iml[l_ac].iml02
                   CALL cl_create_qry() RETURNING g_iml[l_ac].iml02
                   DISPLAY g_iml[l_ac].iml02 TO iml02
#                  CALL FGL_DIALOG_SETBUFFER( g_iml[l_ac].iml02 )
                   CALL aimi107_iml02('d')
                OTHERWISE
                   EXIT CASE
            END CASE
 
       # ON ACTION CONTROLN
       #     CALL aimi107_b_askkey()
       #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(iml02) AND l_ac > 1 THEN
                LET g_iml[l_ac].* = g_iml[l_ac-1].*
                DISPLAY g_iml[l_ac].* TO s_iml[l_ac].*
                NEXT FIELD iml02
            END IF
 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
    END INPUT
 
   #start FUN-5A0029
    LET g_imamodu = g_user
    LET g_imadate = g_today
    UPDATE ima_file SET imamodu = g_imamodu,imadate = g_imadate
     WHERE ima01 = g_iml01
    DISPLAY g_imamodu TO imamodu
    DISPLAY g_imadate TO imadate
   #end FUN-5A0029
 
    CLOSE aimi107_b_curl
    COMMIT WORK
END FUNCTION

 
#檢查程式代號
FUNCTION  aimi107_iml02(p_cmd)
DEFINE    p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_smgacti       LIKE smg_file.smgacti
 
 LET g_chr = ' '
 IF g_iml[l_ac].iml02 IS NULL THEN
       LET g_chr = 'E'
       LET g_iml[l_ac].smg02 = NULL
       LET g_iml[l_ac].smg03 = NULL
 ELSE SELECT smg02,smg03,smgacti
      INTO g_iml[l_ac].smg02 ,g_iml[l_ac].smg03,l_smgacti
      FROM  smg_file
      WHERE smg01 = g_iml[l_ac].iml02
      IF SQLCA.sqlcode THEN
          LET g_chr = 'E'
          LET g_iml[l_ac].iml02 = NULL
      ELSE IF l_smgacti matches'[Nn]' THEN
              LET g_chr = 'E'
           END IF
      END IF
 END IF
 
END FUNCTION
 
FUNCTION aimi107_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT l_wc ON iml02,iml031,iml032,iml033 #螢幕上取條件
       FROM s_iml[1].iml02,s_iml[1].iml031,
            s_iml[1].iml032,s_iml[1].iml033
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
    CALL aimi107_b_fill(l_wc)
END FUNCTION
 
FUNCTION aimi107_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql =
       "SELECT iml02,smg02,smg03,iml031,iml032,iml033 ",
       " FROM ima_file, ",
            " iml_file LEFT OUTER JOIN smg_file ON iml_file.iml02 = smg_file.smg01 ",
       " WHERE ima01=iml01 AND iml01 = '",g_iml01,"' ",
         " AND ",p_wc CLIPPED ,
       " ORDER BY iml02 "
    PREPARE aimi107_prepare2 FROM g_sql      #預備一下
    DECLARE iml_curs CURSOR FOR aimi107_prepare2
    CALL g_iml.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH iml_curs INTO g_iml[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
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
 
    CALL g_iml.deleteElement(g_cnt)
    LET g_rec = g_cnt - 1
    DISPLAY g_rec TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION aimi107_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_iml TO s_iml.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL aimi107_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL aimi107_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL aimi107_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL aimi107_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL aimi107_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #圖形顯示
         CALL cl_set_field_pic("","","","","",g_imaacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                         #No.FUN-680046
         LET g_action_choice="related_document"          #No.FUN-680046
         EXIT DISPLAY                                    #No.FUN-680046
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION aimi107_copy()
DEFINE
    l_newno,l_oldno LIKE iml_file.iml01
 
    IF g_iml01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-580026
    CALL i107_set_entry('a')          #FUN-580026
    LET g_before_input_done = TRUE    #FUN-580026
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM iml01
        BEFORE FIELD iml01
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,12,l_newno) RETURNING l_newno
	               DISPLAY l_newno TO iml01
      	    END IF
        AFTER FIELD iml01
            IF l_newno IS NULL THEN
                NEXT FIELD iml01
            ELSE SELECT ima01 FROM ima_file WHERE ima01 = l_newno
                                             AND imaacti IN ('y','Y')
                 IF SQLCA.sqlcode != 0 THEN
#                   CALL cl_err(l_newno,'mfg0002',0) #No.FUN-660156
                    CALL cl_err3("sel","ima_file",l_newno,"",
                                 "mfg0002","","",1)  #No.FUN-660156
                      NEXT FIELD iml01
                 END IF
            END IF
            SELECT count(*) INTO g_cnt FROM iml_file
                WHERE iml01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD iml01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM iml_file
        WHERE iml01=g_iml01
        INTO TEMP x
    UPDATE x
        SET iml01=l_newno     #資料鍵值
    INSERT INTO iml_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_iml01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","iml_file",g_iml01,"",
                    SQLCA.sqlcode,"","",1)  #No.FUN-660156 
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_iml01
        LET g_iml01 = l_newno
     #  SELECT ROWID,* INTO g_iml.* FROM iml_file
     #                 WHERE iml01 = l_newno
        CALL aimi107_u()
        CALL aimi107_b()
     #   LET g_iml01 = l_oldno  #FUN-C30027
     #  SELECT ROWID,* INTO g_iml.* FROM iml_file
     #                 WHERE ech01 = l_oldno
        CALL aimi107_show()
    END IF
END FUNCTION
 
FUNCTION aimi107_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sr              RECORD
        iml01       LIKE iml_file.iml01,    #料件編號
        iml02       LIKE iml_file.iml02,    #成本項目
        iml031      LIKE iml_file.iml031,   #標準成本
        iml032      LIKE iml_file.iml032,   #現時成本
        iml033      LIKE iml_file.iml033,   #預設成本
        smg02       LIKE smg_file.smg02,    #說明
        smg03       LIKE smg_file.smg03,    #類別
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        ima03       LIKE ima_file.ima03,
        ima05       LIKE ima_file.ima05,
        ima08       LIKE ima_file.ima08,
        ima25       LIKE ima_file.ima25
                    END RECORD,
    l_name          LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    l_za05          LIKE za_file.za05       #No.FUN-690026 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    #CALL cl_outnam('aimi107') RETURNING l_name     #No.FUN-840029            
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimi107' #No.FUN-840029
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR     #No.FUN-840029
    LET g_sql="SELECT iml01,iml02,iml031,iml032,iml033,",
              " smg02,smg03,ima02,ima021,ima03,ima05,ima08,ima25 ",
" FROM ima_file,iml_file LEFT OUTER JOIN smg_file ON iml_file.iml02=smg_file.smg01 ",
" WHERE ima01 = iml01 ",
" AND ",g_wc CLIPPED, " ORDER BY 1 "
    #No.FUN-840029---Begin   
    #PREPARE aimi107_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE aimi107_curo                         # CURSOR
    #    CURSOR FOR aimi107_p1
 
    #START REPORT aimi107_rep TO l_name
 
    #FOREACH aimi107_curo INTO sr.*
    #    IF SQLCA.sqlcode THEN
    #        CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #        EXIT FOREACH
    #        END IF
    #    OUTPUT TO REPORT aimi107_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT aimi107_rep
 
    #CLOSE aimi107_curo
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'iml01,iml02,iml031,iml032,iml033,                    
                          imauser,imamodu,imaacti,imagrup,imadate')             
       RETURNING g_str                                                          
    END IF                                                                      
    LET g_str = g_str,";",g_azi03,";",g_azi05                                   
    CALL cl_prt_cs1('aimi107','aimi107',g_sql,g_str)                            
    #No.FUN-840029---End       
END FUNCTION
 
#No.FUN-840029---Begin 
#REPORT aimi107_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   sr              RECORD
#       iml01       LIKE iml_file.iml01,    #料件編號
#       iml02       LIKE iml_file.iml02,    #成本項目
#       iml031      LIKE iml_file.iml031,   #標準成本
#       iml032      LIKE iml_file.iml032,   #現時成本
#       iml033      LIKE iml_file.iml033,   #預設成本
#       smg02       LIKE smg_file.smg02,    #說明
#       smg03       LIKE smg_file.smg03,    #類別
#       ima02       LIKE ima_file.ima02,
#       ima021      LIKE ima_file.ima021,
#       ima03       LIKE ima_file.ima03,
#       ima05       LIKE ima_file.ima05,
#       ima08       LIKE ima_file.ima08,
#       ima25       LIKE ima_file.ima25
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.iml01,sr.iml02
 
#   FORMAT
#       PAGE HEADER
##No.FUN-580014 --start--
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.iml01  #料件編號
#        IF (PAGENO > 1 OR LINENO > 8)
#           THEN SKIP TO TOP OF PAGE
#        END IF
#          #start TQC-5B0059
#          #PRINT COLUMN  1,g_x[11] clipped, sr.iml01 CLIPPED,  #FUN-5B0014 [1,20],'   ',
#          #      COLUMN 33,g_x[12] clipped, sr.ima05,'  ',        #版本
#          #      COLUMN 42,g_x[13] clipped, sr.ima08,'       ',   #來源碼
#          #      COLUMN 57,g_x[14] clipped, sr.ima25              #庫存單位
#          #PRINT COLUMN  1,g_x[15] clipped, sr.ima02 CLIPPED,
#          #      COLUMN 42,g_x[16] clipped, sr.ima03
#           PRINT COLUMN  1,g_x[11] clipped, sr.iml01 CLIPPED,  #FUN-5B0014 [1,20],'   ',
#                 COLUMN 51,g_x[12] clipped, sr.ima05,'  ',        #版本
#                 COLUMN 60,g_x[13] clipped, sr.ima08,'       ',   #來源碼
#                 COLUMN 75,g_x[14] clipped, sr.ima25              #庫存單位
#           PRINT COLUMN  1,g_x[15] clipped, sr.ima02 CLIPPED,
#                 COLUMN 75,g_x[16] clipped, sr.ima03
#          #end TQC-5B0059
#           PRINT COLUMN 10,sr.ima021
#           PRINT ' '
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#           PRINT g_dash1
 
#       ON EVERY ROW
#           PRINTX name=D1
#                 COLUMN g_c[31],sr.iml02 CLIPPED,
#                 COLUMN g_c[32],sr.smg02 CLIPPED,
#                 COLUMN g_c[33],sr.smg03 CLIPPED,
#                 COLUMN g_c[34],cl_numfor(sr.iml031,34,g_azi03),
#                 COLUMN g_c[35],cl_numfor(sr.iml032,35,g_azi03),
#                 COLUMN g_c[36],cl_numfor(sr.iml033,36,g_azi03)
 
#       AFTER GROUP OF sr.iml01
#           PRINT
#           PRINTX name=S1
#                 column g_c[32],g_x[19] clipped,
#                 COLUMN g_c[34],cl_numfor(GROUP SUM (sr.iml031),34,g_azi05),
#                 COLUMN g_c[35],cl_numfor(GROUP SUM (sr.iml032),35,g_azi05),
#                 COLUMN g_c[36],cl_numfor(GROUP SUM (sr.iml033),36,g_azi05)
##No.FUN-580014 --end--
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-840029---End
 
#No.FUN-570110 --start
FUNCTION i107_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("iml01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i107_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("iml01",FALSE)
   END IF
 
END FUNCTION
 
#No.FUN-570110 --end
#Patch....NO.TQC-610036 <> #
