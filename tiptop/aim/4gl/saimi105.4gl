# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi105.4gl
# Descriptions...: 料件基本資料維護作業-成本資料
# Date & Author..: 91/11/02 By Wu
# Modify ........: 92/06/18 畫面上增加 [成本資料處理狀況](ima93[5,5])
#                           的input查詢...... By Lin
# Modify......Pin: 93/08/09 成本單位=庫存單位,NOENTRY
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-570015 06/06/14 By Sarah 成本中心開窗改成q_gem
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6B0038 06/12/07 By Claire 料號加上開窗查詢
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.MOD-780098 07/08/17 By kim 輸入和action的問題
# Modify.........: NO.MOD-7A0192 07/10/30 BY yiting 按action "建立料件單位轉換"  應該帶料號至開啟視窗中
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40037 10/04/22 By Summer 畫面增加顯示ima021
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No:TQC-B20007 11/02/12 By destiny show的时候未显示oriu,orig
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No:FUN-B90105 11/10/18 by linlin 子料件不可修改，母料件更新資料
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30190 12/03/21 By yangxf 将老报表转换为CR报表
# Modify.........: No.TQC-C40155 12/04/23 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_argv1             LIKE ima_file.ima01,
  g_ima               RECORD LIKE ima_file.*,
  g_ima_t             RECORD LIKE ima_file.*,
  g_ima_o             RECORD LIKE ima_file.*,
  g_ima01_t           LIKE ima_file.ima01,
  g_cmd               LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(60)
  g_s                 LIKE type_file.chr1,    #料件處理狀況  #No.FUN-690026 VARCHAR(1)
  g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  g_wc,g_sql          STRING                  #TQC-630166
 
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_table             STRING                 #FUN-C30190 add
DEFINE g_str               STRING                 #FUN-C30190 add


FUNCTION aimi105(p_argv1)
    DEFINE p_argv1         LIKE ima_file.ima01

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_ima.* TO NULL
    INITIALIZE g_ima_t.* TO NULL
#FUN-C30190 add begin ---
    LET g_sql = "imaacti.ima_file.imaacti,",
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "ima87.ima_file.ima87,",
                "ima12.ima_file.ima12"
    LET l_table = cl_prt_temptable('aimi105',g_sql) CLIPPED
    IF  l_table = -1 THEN
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
    END IF
#FUN-C30190 add end ---
 
    LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi105_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_argv1 = p_argv1
 
    OPEN WINDOW aimi105_w WITH FORM "aim/42f/aimi105"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN CALL aimi105_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi105_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi105_w

END FUNCTION
 
FUNCTION aimi105_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
       INITIALIZE g_ima.* TO NULL    #FUN-640213 add
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                 ima01,ima02,ima05,ima08,ima25,ima03,
                 ima34, ima39, ima12, #FUN-560183 del ima86, ima86_fac,
                 ima87, ima871, ima872, ima873, ima874,
                 imauser, imagrup, imamodu, imadate, imaacti,ima021, #CHI-A40037 add ima021
                 imaoriu,imaorig  #TQC-B90177
          #No.FUN-580031 --start--     HCN
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          #No.FUN-580031 --end--       HCN
 
          ON ACTION CONTROLP
             CASE
              #TQC-6B0038-begin-add
               WHEN INFIELD(ima01)                      
#FUN-AA0059 --Begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"         
                 LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"     #FUN-AB0025
                 LET g_qryparam.default1 = g_ima.ima01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
              #   CALL q_sel_ima( TRUE, "q_ima","",g_ima.ima01,"","","","","",'')  RETURNING  g_qryparam.multiret      #FUN-AB0025
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
              #TQC-6B0038-end-add
              #Mark by FUN-560183
              {
               WHEN INFIELD(ima86)                       # 成本單位 (ima86)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima86
                    #CALL cl_create_qry() RETURNING g_ima.ima86
                    #DISPLAY BY NAME g_ima.ima86
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima86
                    NEXT FIELD ima86
              }
               WHEN INFIELD(ima34) #成本中心
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_smh"   #FUN-570015 mark
                    LET g_qryparam.form = "q_gem"   #FUN-570015
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima34
                    #CALL cl_create_qry() RETURNING g_ima.ima34
                    #DISPLAY BY NAME g_ima.ima34
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima34
                    NEXT FIELD ima34
               WHEN INFIELD(ima39) #會計科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima39
                    #CALL cl_create_qry() RETURNING g_ima.ima39
                    #DISPLAY BY NAME g_ima.ima39
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima39
                    NEXT FIELD ima39
               WHEN INFIELD(ima12) #其他分群碼四
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azf"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima12
                    LET g_qryparam.arg1 = "G"
                    #CALL cl_create_qry() RETURNING g_ima.ima12
                    #DISPLAY BY NAME g_ima.ima12
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima12
                    NEXT FIELD ima12
               WHEN INFIELD(ima87)                       # 成本項目 (ima86)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smg"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima87
                    #CALL cl_create_qry() RETURNING g_ima.ima87
                    #DISPLAY BY NAME g_ima.ima87
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima87
                    CALL aimi105_ima87('d')
                    NEXT FIELD ima87
               WHEN INFIELD(ima872)           #材料製造費用成本項目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smg"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima872
                    #CALL cl_create_qry() RETURNING g_ima.ima872
                    #DISPLAY BY NAME g_ima.ima872
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima872
                    CALL aimi105_ima872('d')
                    NEXT FIELD ima872
               WHEN INFIELD(ima874)           #人工製造費用成本項目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smg"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ima.ima874
                    #CALL cl_create_qry() RETURNING g_ima.ima874
                    #DISPLAY BY NAME g_ima.ima874
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima874
                    CALL aimi105_ima874('d')
                    NEXT FIELD ima874
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
 
	  #No.FUN-580031 --start--     HCN
          ON ACTION qbe_select
             CALL cl_qbe_select()
          ON ACTION qbe_save
	     CALL cl_qbe_save()
	  #No.FUN-580031 --end--       HCN
       END CONSTRUCT
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
          LET g_wc=g_wc CLIPPED," AND ima93[5,5] matches '",g_s,"' "
       END IF
    ELSE
       LET g_wc = " ima01 = '",g_argv1,"'"
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED, " ORDER BY ima01"                               #FUN-A90049 mark
              " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED, " ORDER BY ima01"              #FUN-A90049 add 
    PREPARE aimi105_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi105_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi105_prepare
#   LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED                     #FUN-A90049 mark
    LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED    #FUN-A90049 add 
    PREPARE aimi105_precount FROM g_sql
    DECLARE aimi105_count CURSOR FOR aimi105_precount
END FUNCTION
 
FUNCTION aimi105_menu()
   DEFINE l_cmd LIKE type_file.chr1000   #no.MOD-7A0192
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi105_q()
            END IF
        ON ACTION next
            CALL aimi105_fetch('N')
        ON ACTION previous
            CALL aimi105_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi105_u()
            END IF
        ON ACTION cost_element
            LET g_action_choice="cost_element"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL
               THEN LET g_cmd = "aimi106 ",g_ima.ima01
                    CALL  cl_cmdrun(g_cmd)
            END IF
        ON ACTION cost_artical
            LET g_action_choice="cost_artical"
            IF cl_chk_act_auth() AND g_ima.ima01 IS NOT NULL
               THEN LET g_cmd = "aimi107 ",g_ima.ima01
                    CALL  cl_cmdrun(g_cmd)
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aimi105_out()
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
            CALL aimi105_fetch('/')
        ON ACTION first
            CALL aimi105_fetch('F')
        ON ACTION last
            CALL aimi105_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-680046-------add--------str----
        ON ACTION related_document      #相關文件                   
           LET g_action_choice="related_document"        
              IF cl_chk_act_auth() THEN              
                 IF g_ima.ima01 IS NOT NULL THEN    
                  LET g_doc.column1 = "ima01"           
                  LET g_doc.value1 = g_ima.ima01       
                  CALL cl_doc()                     
              END IF                            
           END IF                          
        #No.FUN-680046-------add--------end----
 
        #----no.MOD-7A0192 start----
        ON ACTION create_item
           LET g_action_choice="create_item"
           IF cl_chk_act_auth() THEN
              LET l_cmd = "aooi103 '",g_ima.ima01,"'"
              CALL cl_cmdrun_wait(l_cmd)
           END IF
        #----no.MOD-7A0192 end------
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi105_curs
END FUNCTION
 
 
FUNCTION aimi105_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct1       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct2       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_direct3       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,
      g_ima.imadate, g_ima.imaacti
    DISPLAY g_s TO FORMONLY.s
    INPUT BY NAME
#No.FUN-570110 --start-
#       g_ima.ima34,g_ima.ima39, g_ima.ima12, #FUN-560183 del g_ima.ima86, g_ima.ima86_fac
      g_ima.ima01, g_ima.ima34,g_ima.ima39, g_ima.ima12, #FUN-560183 del g_ima.ima86, g_ima.ima86_fac
#No.FUN-570110 --end
      g_ima.ima87 , g_ima.ima871, g_ima.ima872, g_ima.ima873,g_ima.ima874
      WITHOUT DEFAULTS
        #genero
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i105_set_entry(p_cmd)                #No.FUN-570110
          CALL i105_set_no_entry(p_cmd)                #No.FUN-570110
          LET g_before_input_done = TRUE
#Mark by #FUN-560183
{
        BEFORE FIELD ima86           #成本單位=NULL時, Default 庫存單位
            IF g_ima_o.ima86 IS NULL AND g_ima.ima86 IS NULL THEN
               LET g_ima.ima86=g_ima.ima25
               LET g_ima_o.ima86=g_ima.ima25
               DISPLAY BY NAME g_ima.ima86
            END IF
 
        AFTER FIELD ima86           #成本單位
            IF g_ima.ima86 IS NULL
               THEN LET g_ima.ima86=g_ima.ima25
                    DISPLAY BY NAME g_ima.ima86
            END IF
            IF  g_ima.ima86 IS NULL
               THEN LET g_ima.ima86 = g_ima_o.ima86
                    DISPLAY BY NAME g_ima.ima86
                    NEXT FIELD ima86
            END IF
            IF g_ima.ima86 IS NOT NULL THEN
                IF g_ima_o.ima86 IS NULL OR (g_ima.ima86 != g_ima_o.ima86 )
                   THEN SELECT gfe01
                          FROM gfe_file WHERE gfe01=g_ima.ima86 AND
                                              gfeacti IN ('Y','y')
                        IF SQLCA.sqlcode  THEN
#                          CALL cl_err(g_ima.ima86,'mfg1203',0) #No.FUN-660156
                           CALL cl_err3("sel","gfe_file",g_ima.ima86,"",
                                        "mfg1203","","",1)  #No.FUN-660156
                           LET g_ima.ima86 = g_ima_o.ima86
                           DISPLAY BY NAME g_ima.ima86
                           NEXT FIELD ima86
                        ELSE IF g_ima.ima86 = g_ima.ima25
                             THEN LET g_ima.ima86_fac = 1
                             ELSE CALL s_umfchk(g_ima.ima01,g_ima.ima86,
                                                g_ima.ima25)
                                  RETURNING g_sw,g_ima.ima86_fac
                                  IF g_sw = '1' THEN
                                     CALL cl_err(g_ima.ima25,'mfg1206',0)
                                     LET g_ima.ima86 = g_ima_o.ima86
                                     DISPLAY BY NAME g_ima.ima86
                                     LET g_ima.ima86_fac = g_ima_o.ima86_fac
                                     DISPLAY BY NAME g_ima.ima86_fac
                                     NEXT FIELD ima86
                                  END IF
                            END IF
                            DISPLAY BY NAME g_ima.ima86_fac
                       END IF
                END IF
            END IF
            LET g_ima_o.ima86 = g_ima.ima86
            LET g_ima_o.ima86_fac = g_ima.ima86_fac
 
#為防本來已有生產單位與單位相同,而轉換率尚無值 MAY
        BEFORE FIELD ima86_fac
            IF g_ima.ima86 = g_ima.ima25 THEN
               LET g_ima.ima86_fac = 1
            END IF
 
        AFTER FIELD ima86_fac
            IF g_ima.ima86_fac IS NULL OR g_ima.ima86_fac = ' '
               OR g_ima.ima86_fac <= 0
            THEN CALL cl_err(g_ima.ima86_fac,'mfg1322',0)
                 LET g_ima.ima86_fac = g_ima_o.ima86_fac
                 DISPLAY BY NAME g_ima.ima86_fac
                 NEXT FIELD ima86_fac
            END IF
            LET g_ima_o.ima86_fac = g_ima.ima86_fac
            LET l_direct = 'D'
}
 
#genero
{
#@@@@@記事:當系統參數(ASM #23 = '1' or '3' 不使用成本中心)
        BEFORE FIELD ima34
             IF g_sma.sma23 not matches'[13]'  THEN
               IF l_direct = 'D' THEN
                    NEXT FIELD ima39
               ELSE NEXT FIELD ima86_fac
               END IF
             END IF
}
 
       AFTER FIELD ima34     #成本中心
           IF g_ima.ima34 IS NOT NULL THEN
              IF (g_ima_o.ima34 IS NULL) OR (g_ima_o.ima34 != g_ima.ima34) THEN
                 CALL aimi105_ima34('a')
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err(g_ima.ima34,'mfg1318',0)
                    LET g_ima.ima34 = g_ima_o.ima34
                    DISPLAY BY NAME g_ima.ima34
                    NEXT FIELD ima34
                 END IF
              END IF
           ELSE
              DISPLAY NULL TO FORMONLY.gem02 #MOD-780098
           END IF
           LET g_ima_o.ima34 = g_ima.ima34
           LET l_direct = 'U'
 
        AFTER FIELD ima39  #會計科目, 可空白, 須存在
            IF g_ima.ima39 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_ima.ima39,g_aza.aza81) THEN  #No.FUN-730033
                    CALL cl_err(g_ima.ima39,'mfg0018',0)
                    #FUN-B10049--begin
                    CALL cl_init_qry_var()                                         
                    LET g_qryparam.form ="q_aag"                                   
                    LET g_qryparam.default1 = g_ima.ima39 
                    LET g_qryparam.construct = 'N'                
                    LET g_qryparam.arg1 = g_aza.aza81  
                    LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_ima.ima39 CLIPPED,"%' "                                                                        
                    CALL cl_create_qry() RETURNING g_ima.ima39
                    DISPLAY BY NAME g_ima.ima39  
                    #FUN-B10049--end                        
                    NEXT FIELD ima39
                END IF
               END IF
            END IF
            LET g_ima_o.ima39 = g_ima.ima39
            LET l_direct = 'U'
            LET l_direct1 = 'D'
#genero
{
#@@@@@記事:當系統參數(ASM #58 = 'N' 不使用成本項目)
        BEFORE FIELD ima87
             IF g_sma.sma58 = 'N' THEN
               IF l_direct1 = 'D' THEN
                    NEXT FIELD ima871
               ELSE NEXT FIELD ima39
               END IF
             END IF
}
 
        #BugNo:3970
        AFTER FIELD ima12                     #其他分群碼四
             IF NOT cl_null(g_ima.ima12) THEN
                 IF (g_ima_o.ima12 IS NULL) OR
                    (g_ima_o.ima12 != g_ima.ima12) THEN
                      SELECT azf01 FROM azf_file
                       WHERE azf01=g_ima.ima12 AND azf02='G' #6818
                         AND azfacti='Y'
                      IF SQLCA.sqlcode  THEN
#                        CALL cl_err(g_ima.ima12,'mfg1306',0) #No.FUN-660156
                         CALL cl_err3("sel","azf_file",g_ima.ima12,"",
                                      "mfg1306","","",1)  #No.FUN-660156
                          LET g_ima.ima12 = g_ima_o.ima12
                          DISPLAY BY NAME g_ima.ima12
                          NEXT FIELD ima12
                      END IF
                 END IF
             END IF
             LET g_ima_o.ima12 = g_ima.ima12
 
        AFTER FIELD ima87          #成本項目
             IF g_ima.ima87 IS NOT NULL  AND g_ima.ima87 != ' '
                THEN IF (g_ima_o.ima87 IS NULL) OR
                             (g_ima.ima87 != g_ima_o.ima87)
                        THEN CALL aimi105_ima87('a')
                             IF g_chr = 'E'
                               THEN CALL cl_err(g_ima.ima87,'mfg1313',0)
                                    LET g_ima.ima87 = g_ima_o.ima87
                                    DISPLAY BY NAME g_ima.ima87
                                    NEXT FIELD ima87
                             END IF
                     END IF
             ELSE
                DISPLAY NULL TO FORMONLY.smg02_1 #MOD-780098
             END IF
            LET g_ima_o.ima87 = g_ima.ima87
            LET l_direct1 = 'U'
 
        AFTER FIELD ima871      #材料造費用分攤率
            #IF g_ima.ima871 IS NULL OR g_ima.ima871 = ' '  #genero
             IF g_ima.ima871 < 0
                THEN CALL cl_err(g_ima.ima871,'mfg0013',0)
                     LET g_ima.ima871 = g_ima_o.ima871
                     DISPLAY BY NAME g_ima.ima871
                     NEXT FIELD ima871
             END IF
            LET g_ima_o.ima871 = g_ima.ima871
            LET l_direct1 = 'U'
            LET l_direct2 = 'D'
#genero
{
#@@@@@記事:1.當系統參數(ASM #58 = 'N' 不使用成本項目)
#          2.分攤率 > 0
        BEFORE FIELD ima872
             IF g_sma.sma58 = 'N' OR g_ima.ima871 < 0 THEN
               IF l_direct2 = 'D' THEN
                    NEXT FIELD ima873
               ELSE NEXT FIELD ima871
               END IF
             END IF
}
 
        AFTER FIELD ima872          #材料製造費用成本項目
            #IF g_ima.ima872 IS NOT NULL AND g_ima.ima872 != ' ' #genero
            IF (g_ima_o.ima872 IS NULL) OR #genero
               (g_ima.ima872 != g_ima_o.ima872) THEN
                 CALL aimi105_ima872('a')
                 IF g_chr = 'E' THEN
                     CALL cl_err(g_ima.ima872,'mfg1313',0)
                     LET g_ima.ima872 = g_ima_o.ima872
                     DISPLAY BY NAME g_ima.ima872
                     NEXT FIELD ima872
                 END IF
            ELSE
                DISPLAY NULL TO FORMONLY.smg02_2 #MOD-780098
            END IF
            LET g_ima_o.ima872 = g_ima.ima872
            LET l_direct2 = 'U'
 
        AFTER FIELD ima873
            #IF g_ima.ima873 IS NULL OR g_ima.ima873 = ' '  #genero
             IF g_ima.ima873 < 0
                THEN CALL cl_err(g_ima.ima873,'mfg0013',0)
                     LET g_ima.ima873 = g_ima_o.ima873
                     DISPLAY BY NAME g_ima.ima873
                     NEXT FIELD ima873
             END IF
            LET g_ima_o.ima873 = g_ima.ima873
            LET l_direct2 = 'U'
            LET l_direct3 = 'D'
#genero
{
#@@@@@記事:1.當系統參數(ASM #58 = 'N' 不使用成本項目)
#          2.分攤率 > 0
        BEFORE FIELD ima874
             IF g_sma.sma58 = 'N' OR g_ima.ima873 < 0 THEN
               IF l_direct3 = 'D' THEN
                  EXIT INPUT
               ELSE
                  NEXT FIELD ima874
               END IF
             END IF
}
 
        AFTER FIELD ima874          #人工製造費用成本項目
            #IF g_ima.ima874 IS NOT NULL AND g_ima.ima874 != ' ' #genero
             IF (g_ima_o.ima874 IS NULL) OR
                (g_ima.ima874 != g_ima_o.ima874) THEN
                 CALL aimi105_ima874('a')
                 IF g_chr = 'E' THEN
                     CALL cl_err(g_ima.ima874,'mfg1313',0)
                     LET g_ima.ima874 = g_ima_o.ima874
                     DISPLAY BY NAME g_ima.ima874
                     NEXT FIELD ima874
                 END IF
             ELSE
                 DISPLAY NULL TO FORMONLY.smg02_3 #MOD-780098
             END IF
            LET g_ima_o.ima874 = g_ima.ima874
            LET l_direct = 'U'
 
        AFTER INPUT
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_ima.ima01 IS NULL THEN  #料件編號
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima01
            END IF
#           IF g_ima.ima86 IS NULL THEN  #成本單位
#              LET l_flag='Y'
#              DISPLAY BY NAME g_ima.ima86
#           END IF
            IF g_ima.ima871 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima871
            END IF
            IF g_ima.ima873 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima873
            END IF
           #MOD-780098 mark begin
           #IF g_sma.sma58 = 'Y' AND g_ima.ima87 IS NULL  THEN
           #   LET l_flag='Y'
           #   DISPLAY BY NAME g_ima.ima87
           #END IF
           #IF g_sma.sma58 = 'Y' AND g_ima.ima871>0 AND
           #   g_ima.ima872 IS NULL  THEN LET l_flag='Y'
           #   DISPLAY BY NAME g_ima.ima872
           #END IF
 
           #IF g_sma.sma58 = 'Y' AND g_ima.ima873 >0 AND
           #   g_ima.ima874  IS NULL THEN
           #   LET l_flag='Y'
           #   DISPLAY BY NAME g_ima.ima874
           #END IF
           #MOD-780098 mark end
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ima87
            END IF
 
       #MOD-780098 mark
       #ON ACTION mntn_cost_center
       #            CALL cl_cmdrun("acsi400 ")
 
        ON ACTION mntn_cost_item
                    CALL cl_cmdrun("asms150 ")
 
        ON ACTION mntn_group_code
                    LET l_cmd="aooi312 "
                    CALL cl_cmdrun(l_cmd CLIPPED)
 
        ON ACTION prt_item_group_code
          #TQC-610072-begin
          #CALL cl_cmdrun("aimr182 ")
           LET g_msg = 'ima01="',g_ima.ima01,'" '
           LET g_msg = "aimr182 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                       " 'Y' ' ' '1' ", 
                       " '",g_msg,"' "
           CALL cl_cmdrun(g_msg)
          #TQC-610072-end
 
        ON ACTION mntn_unit
                    CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
                    CALL cl_cmdrun("aooi102 ")
 
        #no.MOD-7A0192 mark---
        #ON ACTION mntn_item_unit_conv
        #            CALL cl_cmdrun("aooi103 ")
        #no.MOD-7A0192 mark---
        
        ON ACTION CONTROLP
            CASE
              #TQC-6B0038-begin-add
               WHEN INFIELD(ima01)                       
#FUN-AA0059 --Begin--
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"   #FUN-AB0025 
                  LET g_qryparam.default1 = g_ima.ima01
                  CALL cl_create_qry() RETURNING g_ima.ima01
                # CALL q_sel_ima(FALSE, "q_ima", "", g_ima.ima01, "", "", "", "" ,"",'' )  RETURNING g_ima.ima01   #FUN-AB0025
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_ima.ima01 
                  NEXT FIELD ima01
              #TQC-6B0038-end-add
#Mark by #FUN-560183
{
               WHEN INFIELD(ima86)                       # 成本單位 (ima86)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_ima.ima86
                  CALL cl_create_qry() RETURNING g_ima.ima86
#                  CALL FGL_DIALOG_SETBUFFER( g_ima.ima86 )
                  DISPLAY BY NAME g_ima.ima86
                  NEXT FIELD ima86
}
               WHEN INFIELD(ima34) #成本中心
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_smh"   #FUN-570015 mark
                  LET g_qryparam.form = "q_gem"   #FUN-570015
                  LET g_qryparam.default1 = g_ima.ima34
                  CALL cl_create_qry() RETURNING g_ima.ima34
#                  CALL FGL_DIALOG_SETBUFFER( g_ima.ima34 )
                  DISPLAY BY NAME g_ima.ima34
                  NEXT FIELD ima34
               WHEN INFIELD(ima39) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_ima.ima39
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_ima.ima39
#                  CALL FGL_DIALOG_SETBUFFER( g_ima.ima39 )
                  DISPLAY BY NAME g_ima.ima39
                  NEXT FIELD ima39
               WHEN INFIELD(ima12) #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf"
                  LET g_qryparam.default1 = g_ima.ima12
                  LET g_qryparam.arg1 = "G"
                  CALL cl_create_qry() RETURNING g_ima.ima12
#                  CALL FGL_DIALOG_SETBUFFER( g_ima.ima12 )
                  DISPLAY BY NAME g_ima.ima12
                  NEXT FIELD ima12
               WHEN INFIELD(ima87)                       # 成本項目 (ima86)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smg"
                  LET g_qryparam.default1 = g_ima.ima87
                  CALL cl_create_qry() RETURNING g_ima.ima87
#                  CALL FGL_DIALOG_SETBUFFER( g_ima.ima87 )
                  DISPLAY BY NAME g_ima.ima87
                 CALL aimi105_ima87('d')
                 NEXT FIELD ima87
               WHEN INFIELD(ima872)           #材料製造費用成本項目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_smg"
                 LET g_qryparam.default1 = g_ima.ima872
                 CALL cl_create_qry() RETURNING g_ima.ima872
#                 CALL FGL_DIALOG_SETBUFFER( g_ima.ima872 )
                 DISPLAY BY NAME g_ima.ima872
                 CALL aimi105_ima872('d')
                 NEXT FIELD ima872
               WHEN INFIELD(ima874)           #人工製造費用成本項目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_smg"
                 LET g_qryparam.default1 = g_ima.ima874
                 CALL cl_create_qry() RETURNING g_ima.ima874
#                 CALL FGL_DIALOG_SETBUFFER( g_ima.ima874 )
                 DISPLAY BY NAME g_ima.ima874
                 CALL aimi105_ima874('d')
                 NEXT FIELD ima874
               OTHERWISE EXIT CASE
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
 
FUNCTION aimi105_ima34(p_cmd)    #成本中心
    DEFINE  p_cmd     LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   #start FUN-570015 modify
   #DEFINE  l_smh02   LIKE smh_file.smh02 
   #DEFINE  l_smhacti LIKE smh_file.smhacti
    DEFINE  l_gem02   LIKE gem_file.gem02 
    DEFINE  l_gemacti LIKE gem_file.gemacti
   #end FUN-570015 modify
 
    LET g_chr = ' '
    IF g_ima.ima34 IS NULL THEN
      #LET g_chr = 'E' #MOD-780098
       LET g_chr = ' ' #MOD-780098
      #LET l_smh02 = NULL   #FUN-570015 mark
       LET l_gem02 = NULL   #FUN-570015
    ELSE 
      #start FUN-570015 modify
      #SELECT smh02,smhacti INTO l_smh02,l_smhacti FROM smh_file
      # WHERE smh01 = g_ima.ima34
       SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
        WHERE gem01 = g_ima.ima34
      #end FUN-570015 modify
       IF SQLCA.sqlcode THEN
         #LET l_smh02 = NULL   #FUN-570015 mark
          LET l_gem02 = NULL   #FUN-570015
          LET g_chr = 'E'
       ELSE 
         #IF l_smhacti matches'[Nn]' THEN LET g_chr = 'E' END IF   #FUN-570015 mark
          IF l_gemacti matches'[Nn]' THEN LET g_chr = 'E' END IF   #FUN-570015
       END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd' THEN
      #DISPLAY l_smh02 TO smh02   #FUN-570015 mark
       DISPLAY l_gem02 TO gem02   #FUN-570015 
    END IF
 
END FUNCTION
 
FUNCTION aimi105_ima87(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_ima.ima87 IS NULL
      THEN #LET g_chr = 'E' #MOD-780098
           LET g_chr = ' ' #MOD-780098
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_ima.ima87
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_1
    END IF
END FUNCTION
 
FUNCTION aimi105_ima872(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_ima.ima872 IS NULL
      THEN #LET g_chr = 'E' #MOD-780098
           LET g_chr = ' ' #MOD-780098
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_ima.ima872
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_2
    END IF
END FUNCTION
 
FUNCTION aimi105_ima874(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_ima.ima874 IS NULL
      THEN #LET g_chr = 'E' #MOD-780098
           LET g_chr = ' ' #MOD-780098
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_ima.ima874
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_3
    END IF
END FUNCTION
 
FUNCTION aimi105_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi105_curs()                          # 宣告 SCROLL CURSOR
 #  IF INT_FLAG THEN
 #      LET INT_FLAG = 0
 #      CLEAR FORM
 #      RETURN
 #  END IF
    OPEN aimi105_count
    FETCH aimi105_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi105_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
    ELSE
        CALL aimi105_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi105_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     aimi105_curs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS aimi105_curs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    aimi105_curs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     aimi105_curs INTO g_ima.ima01
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump aimi105_curs INTO g_ima.ima01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flima
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_ima.imauser #FUN-4C0053
        LET g_data_group = g_ima.imagrup #FUN-4C0053
        CALL aimi105_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi105_show()
 
    LET g_ima_t.* = g_ima.*
    LET g_s=g_ima.ima93[5,5]
    DISPLAY g_s TO FORMONLY.s
    DISPLAY BY NAME
      g_ima.ima01,  g_ima.ima05,  g_ima.ima08,  g_ima.ima25,
      g_ima.ima02,  g_ima.ima03,  
      g_ima.ima34,  g_ima.ima39,  g_ima.ima12, #FUN-560183 del g_ima.ima86, g_ima.ima86_fac
      g_ima.ima87 , g_ima.ima871, g_ima.ima872, g_ima.ima873, g_ima.ima874,
      g_ima.imauser,g_ima.imagrup,g_ima.imamodu,g_ima.imadate,g_ima.imaacti,g_ima.ima021, #CHI-A40037 add g_ima.ima021
      g_ima.imaoriu,g_ima.imaorig   #TQC-B20007

    CALL aimi105_ima34('d')
    CALL aimi105_ima87('d')
    CALL aimi105_ima872('d')
    CALL aimi105_ima874('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi105_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ima.ima01,'mfg1000',0)
        RETURN
    END IF
#FUN-B90105----add--begin---- 
    IF s_industry('slk') THEN
       IF g_ima.ima151='N' AND g_ima.imaag='@CHILD' THEN
          CALL cl_err(g_ima.ima01,'axm_665',1)
          RETURN
       END IF
    END IF
#FUN-B90105----add--end---
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    LET g_ima_o.* = g_ima.*
    BEGIN WORK     #No.+205 mark 拿掉
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN aimi105_curl USING g_ima01_t
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN aimi105_curl:", STATUS, 1)
       CLOSE aimi105_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi105_curl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ima.imamodu = g_user                   #修改者
    LET g_ima.imadate = g_today                  #修改日期
    CALL aimi105_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi105_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima_t.imadate=g_ima_o.imadate        #TQC-C40219
            LET g_ima_t.imamodu=g_ima_o.imamodu        #TQC-C40219
            LET g_ima.*=g_ima_t.*   #TQC-C40155 #TQC-C40219
           #LET g_ima.*=g_ima_o.*   #TQC-C40155 #TQC-C40219
            CALL aimi105_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_ima.ima93[5,5] = 'Y'
        UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
            WHERE ima01 = g_ima01_t                  # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","ima_file",g_ima01_t,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        DISPLAY 'Y' TO FORMONLY.s
        EXIT WHILE
    END WHILE
    CLOSE aimi105_curl
#FUN-B90105----add--begin---- 
        IF s_industry('slk') THEN
           IF g_ima.ima151='Y' THEN
              CALL i105_ins_ima()
           END IF
        END IF
#FUN-B90105----add--end---
    COMMIT WORK   #No.+205 mark 拿掉
END FUNCTION
#FUN-B90105----add--begin---- 
FUNCTION i105_ins_ima()
  DEFINE l_ima   RECORD LIKE ima_file.*
    UPDATE ima_file SET ima34 = g_ima.ima34,ima39 = g_ima.ima39,
                        ima12 = g_ima.ima12,ima87 = g_ima.ima87,
                        ima871 = g_ima.ima871,ima872 = g_ima.ima872,
                        ima873 = g_ima.ima873,ima874 = g_ima.ima874,
                        imamodu=g_ima.imamodu,imadate=g_ima.imadate
      WHERE ima01 IN (SELECT imx000 FROM imx_file WHERE imx00=g_ima.ima01)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1)
         END IF
END FUNCTION
#FUN-B90105----add--end---
 
FUNCTION aimi105_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        sr              RECORD LIKE ima_file.*,
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
    DEFINE l_sql        STRING                  #FUN-C30190 add    
 
    IF cl_null(g_wc) THEN
        LET g_wc=" ima01='",g_ima.ima01,"'"
    END IF
    CALL cl_wait()
#FUN-C30190 add begin ---
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?,  ?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
#FUN-C30190 add end ----
#   CALL cl_outnam('aimi105') RETURNING l_name   #FUN-C30190 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ima_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aimi105_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi105_curo                         # CURSOR
        CURSOR FOR aimi105_p1
 
#   START REPORT aimi105_rep TO l_name           #FUN-C30190 mark
 
    FOREACH aimi105_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#       OUTPUT TO REPORT aimi105_rep(sr.*)       #FUN-C30190 mark
#FUN-C30190 add begin ---
        EXECUTE  insert_prep  USING sr.imaacti,sr.ima01,
                                    sr.ima02,sr.ima021,
                                    sr.ima87,sr.ima12
#FUN-C30190 add end -----
    END FOREACH

#   FINISH REPORT aimi105_rep                    #FUN-C30190 mark

    CLOSE aimi105_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)            #FUN-C30190 mark
#FUN-C30190 add begin ---
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = g_wc
    CALL cl_prt_cs3('aimi105','aimi105',l_sql,g_str)
#FUN-C30190 add end ----
END FUNCTION
 
#FUN-C30190 mark begin ---
#REPORT aimi105_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#        sr              RECORD LIKE ima_file.*,
#        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.ima01
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED   #No.TQC-6A0078
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT
#            PRINT g_dash[1,g_len]  #No.TQC-6A0078
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[37] #FUN-560183 del ,g_x[36]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            IF sr.imaacti = 'N' THEN
#                PRINT COLUMN g_c[31],'*';
#            ELSE
#                PRINT COLUMN g_c[31],' ';
#            END IF
#            PRINT COLUMN g_c[32],sr.ima01[1,30] CLIPPED,    #No.TQC-6A0078
#                  COLUMN g_c[33],sr.ima02[1,30] CLIPPED,    #No.TQC-6A0078
#                  COLUMN g_c[34],sr.ima021[1,30] CLIPPED,    #No.TQC-6A0078
#                  COLUMN g_c[35],sr.ima87,
#                 #COLUMN g_c[36],sr.ima86,
#                  COLUMN g_c[37],sr.ima12
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]  #No.TQC-6A0078
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            PRINT g_dash2
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #No.TQC-6A0078
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash2
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0078
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190 mark end ---
 
#genero
FUNCTION i105_set_no_entry(p_cmd)
DEFINE    p_cmd    LIKE type_file.chr1          #No.FUN-570110  #No.FUN-690026 VARCHAR(1)
   CASE
       WHEN NOT g_before_input_done
              IF g_sma.sma23 not matches'[13]'  THEN
                  CALL cl_set_comp_entry("ima34",FALSE)
              END IF
              IF g_sma.sma58 = 'N'  THEN
                  CALL cl_set_comp_entry("ima87,ima872,ima874",FALSE)
              END IF
#No.FUN-570110--begin
              IF p_cmd = 'u' AND g_chkey = 'N' THEN
                  CALL cl_set_comp_entry("ima01",FALSE)
              END IF
#No.FUN-570110--end
   END CASE
END FUNCTION
 
FUNCTION i105_set_entry(p_cmd)
DEFINE    p_cmd    LIKE type_file.chr1          #No.FUN-570110  #No.FUN-690026 VARCHAR(1)
   CASE
       WHEN NOT g_before_input_done
            CALL cl_set_comp_entry("ima34,ima87,ima872,ima874",TRUE)
#No.FUN-570110--begin
              IF p_cmd = 'a' THEN
                  CALL cl_set_comp_entry("ima01",TRUE)
              END IF
#No.FUN-570110--end
   END CASE
END FUNCTION
 

