# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi320.4gl
# Descriptions...: 料件機種維護作業 
# Date & Author..: 97/12/29 By Kitty
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 hellen 新增單頭折疊功能
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740079 07/04/13 By Ray 報表格式調整
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/06/28 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-930108 09/03/30 By zhaijie若此作業可錄入資料,則增加判斷此料件是否需要AVL,需要才可輸入
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C50021 12/05/03 By chenjing 料件編號開窗時只顯示avl料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_bmk01         LIKE bmk_file.bmk01,   #料件編號     (假單頭)
    g_bmk01_t       LIKE bmk_file.bmk01,   #特性料件編號 (舊值)
    g_bmk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmk02       LIKE bmk_file.bmk02,   #行序
        bmk03       LIKE bmk_file.bmk03,   #條件編號
        bmi02       LIKE bmi_file.bmi02
                    END RECORD,
    g_bmk_t         RECORD                 #程式變數 (舊值)
        bmk02       LIKE bmk_file.bmk02,   #行序
        bmk03       LIKE bmk_file.bmk03,   #條件編號
        bmi02       LIKE bmi_file.bmi02
                    END RECORD,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,#TQC-630166        #No.FUN-680096
    g_wc,g_wc2,g_sql    STRING,    #TQC-630166
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680096 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE      #No.FUN-680096 SMALLINT
   DEFINE g_argv1         LIKE bmk_file.bmk01 
DEFINE p_row,p_col     LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE l_table        STRING,                   ### FUN-770052 ###                                                                    
       g_str          STRING                    ### FUN-770052 ###                                                                    
 
#主程式開始
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
MAIN
# DEFINE                                    #No.FUN-6A0060
#       l_time    LIKE type_file.chr8       #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "bmk01.bmk_file.bmk01,",                                                                                            
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "bmk02.bmk_file.bmk02,",                                                                                            
                "bmk03.bmk_file.bmk03,",                                                                                            
                "bmi02.bmi_file.bmi02"                                                                                              
                                                                                                                                    
    LET l_table = cl_prt_temptable('abmi320',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ? )"                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------# 
    LET g_argv1  = ARG_VAL(1)               #料件編號
    LET g_bmk01 = NULL                     #清除鍵值
    LET g_bmk01_t = NULL
    LET p_row = 3 LET p_col = 12
 
    OPEN WINDOW i320_w AT  p_row,p_col           #顯示畫面
         WITH FORM "abm/42f/abmi320"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    #No.FUN-6C0055 --start--
    IF g_aza.aza71 MATCHES '[Yy]' THEN 
       CALL aws_gpmcli_toolbar()
       CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
    ELSE
       CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
    END IF
    #No.FUN-6C0055 --end--
 
    IF NOT cl_null(g_argv1) THEN 
        CALL i320_q() 
    END IF
    LET g_delete='N'
    CALL i320_menu()
    CLOSE WINDOW i320_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i320_cs()
    CLEAR FORM                             #清除畫面
    CALL g_bmk.clear()
    IF cl_null(g_argv1) THEN
        CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_bmk01 TO NULL    #No.FUN-750051
    	CONSTRUCT g_wc ON bmk01,bmk02,bmk03   #螢幕上取條件
        	FROM bmk01,s_bmk[1].bmk02,s_bmk[1].bmk03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP                  
            CASE
                WHEN INFIELD(bmk01)
#                    CALL q_ima(0,0,'') RETURNING g_bmk01
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = 'c'
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmk01
                     NEXT FIELD bmk01
                WHEN INFIELD(bmk03) 
#                    CALL q_bmi(7,3,g_bmk[1].bmk03) RETURNING g_bmk[1].bmk03
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmi"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmk03
                     NEXT FIELD bmk03
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
    ELSE LET g_wc = " bmk01 = '",g_argv1,"'"
    END IF
 
    LET g_sql="SELECT UNIQUE bmk01 FROM bmk_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bmk01"
    PREPARE i320_prepare FROM g_sql      #預備一下
    DECLARE i320_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i320_prepare
    LET g_sql="SELECT COUNT(DISTINCT bmk01) ",
              "  FROM bmk_file WHERE ", g_wc CLIPPED
    PREPARE i320_precount FROM g_sql
    DECLARE i320_count CURSOR FOR i320_precount
END FUNCTION
 
FUNCTION i320_menu()
   #No.FUN-6C0055 --start--
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   #No.FUN-6C0055 --end--
 
   WHILE TRUE
      CALL i320_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i320_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i320_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i320_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i320_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i320_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmk01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmk01"
                  LET g_doc.value1 = g_bmk01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmk),'','')
            END IF
 
         #No.FUN-6C0055 --start--
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              LET l_partnum = g_bmk01
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              LET l_partnum = g_bmk01
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
        #No.FUN-6C0055 --end--
 
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i320_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bmk.clear()
    INITIALIZE g_bmk01 LIKE bmk_file.bmk01
    LET g_bmk01 = g_argv1
    LET g_bmk01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
       	CALL i320_i("a")                   #輸入單頭
       	IF INT_FLAG THEN                   #使用者不玩了
                LET g_bmk01 = NULL
           	LET INT_FLAG = 0
            	CALL cl_err('',9001,0)
            	EXIT WHILE
        END IF
        CALL g_bmk.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2  
        CALL i320_b()                   #輸入單身
        LET g_bmk01_t = g_bmk01            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i320_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmk01_t = g_bmk01
    WHILE TRUE
        CALL i320_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bmk01=g_bmk01_t
            DISPLAY g_bmk01 TO bmk01      #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bmk01 != g_bmk01_t THEN #更改單頭值
            UPDATE bmk_file SET bmk01 = g_bmk01   #更新DB
                WHERE bmk01 = g_bmk01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_bmk01,SQLCA.sqlcode,0)
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i320_i(p_cmd)
DEFINE
    p_cmd    LIKE type_file.chr1    #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0033
    INPUT g_bmk01 WITHOUT DEFAULTS FROM bmk01 
 
	    BEFORE FIELD bmk01  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(8,29,g_bmk01) RETURNING g_bmk01 
	            DISPLAY g_bmk01 TO bmk01 
	    END IF
 
        AFTER FIELD bmk01            #規格主件編號  
            IF NOT cl_null(g_bmk01) THEN
                #FUN-AA0059 -----------------------------add start--------------------------
                IF NOT s_chk_item_no(g_bmk01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bmk01 = g_bmk01_t
                   DISPLAY g_bmk01 TO bmk01
                   NEXT FIELD bmk01
                END IF 
                #FUN-AA0059 ----------------------------add end-----------------------------  
                IF g_bmk01 != g_bmk01_t OR g_bmk01_t IS NULL THEN
                    CALL i320_bmk01('a')
                    IF NOT cl_null(g_errno) THEN
                        	CALL cl_err(g_bmk01,g_errno,0)
                        	LET g_bmk01 = g_bmk01_t
                        	DISPLAY g_bmk01 TO bmk01 
                        	NEXT FIELD bmk01
                    END IF
                END IF
                SELECT count(*) INTO g_cnt FROM bmk_file
                 WHERE bmk01 = g_bmk01
                IF g_cnt > 0 THEN   #資料重複
                   CALL cl_err(g_bmk01,-239,0)
                   LET g_bmk01 = g_bmk01_t
                   DISPLAY  g_bmk01 TO bmk01 
                   NEXT FIELD bmk01
                END IF
            END IF
 
        ON ACTION CONTROLP                  
            CASE
                WHEN INFIELD(bmk01)
#                    CALL q_ima(0,0,'') RETURNING g_bmk01
#                    CALL FGL_DIALOG_SETBUFFER( g_bmk01 )
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.default1 = ''
                  #   CALL cl_create_qry() RETURNING g_bmk01 
                  #  CALL q_sel_ima(FALSE, "q_ima", "", '', "", "", "", "" ,"",'' )  RETURNING g_bmk01                #TQC-C50021
                     CALL q_sel_ima(FALSE, "q_ima", "ima926 = 'Y'", '', "", "", "", "" ,"",'' )  RETURNING g_bmk01    #TQC-C50021
#FUN-AA0059 --End--
#                     CALL FGL_DIALOG_SETBUFFER( g_bmk01 )
                     #DISPLAY BY NAME g_bmk01      #FUN-930108 這樣寫會報-1102錯誤
                     DISPLAY g_bmk01 TO bmk01      #FUN-930108 mod
                     NEXT FIELD bmk01
                OTHERWISE EXIT CASE
            END CASE
   
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
   
FUNCTION i320_bmk01(p_cmd)  #規格主件編號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima926  LIKE ima_file.ima926,         #FUN-930108 add ima926
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,imaacti,ima926       #FUN-930108 add ima926
           INTO l_ima02,l_ima021,l_ima25,l_imaacti,l_ima926  #FUN-930108 add ima926
           FROM ima_file WHERE ima01 = g_bmk01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021 = NULL LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN l_ima926 !='Y' LET g_errno = '9088'  #FUN-930108
    #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02 
           DISPLAY l_ima021 TO FORMONLY.ima021
           DISPLAY l_ima25 TO FORMONLY.ima25 
    END IF
END FUNCTION
 
FUNCTION i320_bmk03(p_cmd)  #機種
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_bmiacti   LIKE bmi_file.bmiacti
 
    LET g_errno = ' '
    SELECT bmi02,bmiacti INTO g_bmk[l_ac].bmi02,l_bmiacti FROM bmi_file 
                WHERE bmi01 = g_bmk[l_ac].bmk03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-008'
                            LET g_bmk[l_ac].bmi02 = NULL
         WHEN l_bmiacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY g_bmk[l_ac].bmi02 TO s_bmk[l_sl].bmi02
    END IF
END FUNCTION
#Query 查詢
FUNCTION i320_q()
  DEFINE l_bmk01  LIKE bmk_file.bmk01,
         l_cnt    LIKE type_file.num10   #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmk01 TO NULL             #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i320_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bmk01 TO NULL
        RETURN
    END IF
    OPEN i320_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmk01 TO NULL
    ELSE
        CALL i320_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i320_count
        FETCH i320_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i320_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1       #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i320_bcs INTO g_bmk01
        WHEN 'P' FETCH PREVIOUS i320_bcs INTO g_bmk01
        WHEN 'F' FETCH FIRST    i320_bcs INTO g_bmk01
        WHEN 'L' FETCH LAST     i320_bcs INTO g_bmk01
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i320_bcs INTO g_bmk01
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_bmk01,SQLCA.sqlcode,0)
        INITIALIZE g_bmk01 TO NULL  #TQC-6B0105
    ELSE
        OPEN i320_count
        FETCH i320_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i320_show()
        CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i320_show()
    DEFINE l_cnt    LIKE type_file.num10    #處理方式  #No.FUN-680096 INTEGER
 
    SELECT COUNT(*) INTO l_cnt FROM bmk_file WHERE bmk01=g_bmk01
    IF l_cnt=0 THEN LET g_bmk01= NULL END IF
    DISPLAY g_bmk01 TO bmk01 
    CALL i320_bmk01('d')
    CALL i320_bf(g_wc)                 #單身
# genero  script marked     LET g_bmk_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i320_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmk01 IS NULL THEN
       CALL cl_err("",-400,0)                      #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmk01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bmk01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bmk_file WHERE bmk01 = g_bmk01 
        IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
        ELSE
            CLEAR FORM
            CALL g_bmk.clear()
            OPEN i320_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i320_bcs
               CLOSE i320_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i320_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i320_bcs
               CLOSE i320_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i320_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i320_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i320_fetch('/')
            END IF
            LET g_delete='Y'
            LET g_bmk01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
 
#單身
FUNCTION i320_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否     #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否     #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmk01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
       "SELECT bmk02,bmk03,'' ",
       "FROM bmk_file ",
       "  WHERE bmk01 = ? ",
       "  AND bmk02 = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i320_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmk WITHOUT DEFAULTS FROM s_bmk.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET g_bmk_t.* = g_bmk[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
 
                OPEN i320_bcl USING g_bmk01,g_bmk_t.bmk02
                IF STATUS THEN
                    CALL cl_err("OPEN i320_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i320_bcl INTO g_bmk[l_ac].* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmk_t.bmk02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    SELECT bmi02 INTO g_bmk[l_ac].bmi02 FROM bmi_file 
                           WHERE bmi01 = g_bmk[l_ac].bmk03
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmk02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
             INSERT INTO bmk_file (bmk01,bmk02,bmk03)  #No.MOD-470041
                 VALUES(g_bmk01,g_bmk[l_ac].bmk02,g_bmk[l_ac].bmk03)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_bmk[l_ac].bmk02,SQLCA.sqlcode,0)
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmk[l_ac].* TO NULL      #900423
            LET g_bmk_t.* = g_bmk[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmk02
 
        BEFORE FIELD bmk02                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(bmk02)+1
                   INTO g_bmk[l_ac].bmk02
                   FROM bmk_file
                   WHERE bmk01 = g_bmk01
                IF g_bmk[l_ac].bmk02 IS NULL THEN
                    LET g_bmk[l_ac].bmk02 = 1
                END IF
                DISPLAY g_bmk[l_ac].bmk02 TO s_bmk[l_sl].bmk02
            END IF
 
        AFTER FIELD bmk02                        #check 序號是否重複
            IF NOT cl_null(g_bmk[l_ac].bmk02) THEN
                IF g_bmk[l_ac].bmk02 != g_bmk_t.bmk02 OR
                   g_bmk_t.bmk02 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bmk_file
                        WHERE bmk01 = g_bmk01
                          AND bmk02 = g_bmk[l_ac].bmk02
                    IF l_n > 0 THEN
                        CALL cl_err(g_bmk[l_ac].bmk02,-239,0)
                        LET g_bmk[l_ac].bmk02 = g_bmk_t.bmk02
                        DISPLAY g_bmk[l_ac].bmk02 TO s_bmk[l_sl].bmk02
                        NEXT FIELD bmk02
                    END IF
                END IF
            END IF
 
        AFTER FIELD bmk03
            IF NOT cl_null(g_bmk[l_ac].bmk03) THEN 
                CALL i320_bmk03('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bmk[l_ac].bmk03,g_errno,0)
                    NEXT FIELD bmk03
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmk_t.bmk02 > 0 AND
               g_bmk_t.bmk02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
                DELETE FROM bmk_file
                    WHERE bmk01 = g_bmk01 
                      AND bmk02 = g_bmk_t.bmk02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bmk_t.bmk03,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
	        COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmk[l_ac].* = g_bmk_t.*
               CLOSE i320_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmk[l_ac].bmk02,-263,1)
                LET g_bmk[l_ac].* = g_bmk_t.*
            ELSE
                UPDATE bmk_file SET
                       bmk02 = g_bmk[l_ac].bmk02,
                       bmk03 = g_bmk[l_ac].bmk03
                 WHERE bmk01=g_bmk01
                   AND bmk02=g_bmk_t.bmk02 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bmk[l_ac].bmk02,SQLCA.sqlcode,0)
                    LET g_bmk[l_ac].* = g_bmk_t.*
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
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmk[l_ac].* = g_bmk_t.*   
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i320_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_bmk_t.* = g_bmk[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i320_bcl
            COMMIT WORK
 
 
      # ON ACTION CONTROLN
      #     CALL i320_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmk02) AND l_ac > 1 THEN
                LET g_bmk[l_ac].* = g_bmk[l_ac-1].*
                NEXT FIELD bmk02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(bmk03) 
#                    CALL q_bmi(7,3,g_bmk[l_ac].bmk03) RETURNING g_bmk[l_ac].bmk03
#                    CALL FGL_DIALOG_SETBUFFER( g_bmk[l_ac].bmk03 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmi"
                     LET g_qryparam.default1 = g_bmk[l_ac].bmk03
                     CALL cl_create_qry() RETURNING g_bmk[l_ac].bmk03
#                     CALL FGL_DIALOG_SETBUFFER( g_bmk[l_ac].bmk03 )
                     DISPLAY g_bmk[l_ac].bmk03 TO bmk03
                     NEXT FIELD bmk03
           END CASE
 
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
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033    
 
        END INPUT
 
    CLOSE i320_bcl
	COMMIT WORK
END FUNCTION
   
FUNCTION i320_b_askkey()
DEFINE
   #l_wc            LIKE type_file.chr1000#TQC-630166        #No.FUN-680096
    l_wc            STRING   #TQC-630166
 
    CONSTRUCT l_wc ON bmk02,bmk03                               #螢幕上取條件
       FROM s_bmk[1].bmk03,s_bmk[1].bmk03
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
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i320_bf(l_wc)
END FUNCTION
 
FUNCTION i320_bf(p_wc)              #BODY FILL UP
DEFINE
   #p_wc      	    LIKE type_file.chr1000#TQC-630166        #No.FUN-680096
    p_wc      	    STRING    #TQC-630166
 
    LET g_sql = "SELECT bmk02,bmk03,'' FROM bmk_file ",
       " WHERE bmk01 = '",g_bmk01,"' AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i320_prepare2 FROM g_sql      #預備一下
    DECLARE bmk_cs CURSOR FOR i320_prepare2
    CALL g_bmk.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH bmk_cs INTO g_bmk[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT bmi02 INTO g_bmk[g_cnt].bmi02 FROM bmi_file 
             WHERE bmi01 = g_bmk[g_cnt].bmk03
        IF SQLCA.sqlcode THEN LET g_bmk[g_cnt].bmi02 = ' ' END IF
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_bmk.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmk TO s_bmk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i320_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i320_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i320_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i320_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i320_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
         #No.FUN-6C0055 --start--
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         #No.FUN-6C0055 --end--
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-6C0055 --start--   
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
      #No.FUN-6C0055 --end--
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i320_copy()
DEFINE
    l_oldno1         LIKE bmk_file.bmk01,
    l_newno1         LIKE bmk_file.bmk01
 
    IF s_shut(0) THEN RETURN END IF             #檢查權限
    IF g_bmk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0033
    INPUT l_newno1  FROM bmk01
 
        BEFORE FIELD bmk01
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(8,29,l_newno1) RETURNING l_newno1
	            DISPLAY l_newno1 TO bmk01 
	    END IF
 
        AFTER FIELD bmk01
            IF cl_null(l_newno1) THEN
                NEXT FIELD bmk01
            END IF
            #FUN-AA0059 ----------------------------add start-------------------
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmk01
            END IF 
            #FUN-A0059 ----------------------------add end----------------------
	       IF l_newno1 !='*' THEN
	          SELECT * FROM ima_file
                   WHERE ima01 = l_newno1 
	           IF SQLCA.sqlcode THEN 
	              CALL cl_err(l_newno1,'mfg2727',0)
		          NEXT FIELD bmk01
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
    IF INT_FLAG OR l_newno1 IS NULL THEN
        LET INT_FLAG = 0
    	CALL i320_show()
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM bmk_file
        WHERE bmk01=g_bmk01
        INTO TEMP x
    UPDATE x
        SET bmk01=l_newno1     #資料鍵值
    INSERT INTO bmk_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmk01,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K' 
        LET l_oldno1 = g_bmk01
        LET g_bmk01 = l_newno1
	IF g_chkey = 'Y' THEN CALL i320_u() END IF
        CALL i320_b()
        #LET g_bmk01 = l_oldno1  #FUN-C30027
        #CALL i320_show()        #FUN-C30027
    END IF
END FUNCTION
   
FUNCTION i320_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmk01       LIKE bmk_file.bmk01,   #規格主件編號
        bmk02       LIKE bmk_file.bmk02,   #特性料件編號
        bmk03       LIKE bmk_file.bmk03,   #行序
        bmi02       LIKE bmi_file.bmi02 
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
   DEFINE l_ima02   LIKE ima_file.ima02    #FUN-770052                                                                             
   DEFINE l_ima021  LIKE ima_file.ima021   #FUN-770052   
   DEFINE l_sql     STRING                 #FUN-770052
    IF cl_null(g_wc) THEN 
        LET g_wc=" bmk01='",g_bmk01,"'" 
    END IF
    CALL cl_wait()
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------#     
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bmk01,bmk02,bmk03,bmi02",
              " FROM bmk_file, OUTER bmi_file ",          # 組合出 SQL 指令
              " WHERE bmk_file.bmk03=bmi_file.bmi01 AND ",g_wc CLIPPED
    PREPARE i320_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i320_co                         # CURSOR
        CURSOR FOR i320_p1
 
#    CALL cl_outnam('abmi320') RETURNING l_name      #FUN-770052
#    START REPORT i320_rep TO l_name                 #FUN-770052 
 
    FOREACH i320_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
    #--No.FUN-770052--begin--
    SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                               
              FROM ima_file                                                                                                         
             WHERE ima01 = sr.bmk01                                                                                                 
            IF SQLCA.sqlcode THEN                                                                                                   
                LET l_ima02  = NULL                                                                                                 
                LET l_ima021 = NULL                                                                                                 
            END IF 
    #--No.FUN-770052--end--
#        OUTPUT TO REPORT i320_rep(sr.*)             #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING         
                   sr.bmk01,l_ima02,l_ima021,sr.bmk02,sr.bmk03,sr.bmi02                                                                                       
        #------------------------------ CR (3) ------------------------------# 
    END FOREACH
 
#   FINISH REPORT i320_rep                          #FUN-770052
 
    CLOSE i320_co
    ERROR ""                                        
#    CALL cl_prt(l_name,' ','1',g_len)              #FUN-770052          
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'bmk01,bmk02,bmk03')                                                                                                  
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#   
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_wc                                                                                                                
    CALL cl_prt_cs3('abmi320','abmi320',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#  
END FUNCTION
 
{ REPORT i320_rep(sr)                                 #FUN-770052
   DEFINE l_ima02      LIKE ima_file.ima02  #FUN-510017
   DEFINE l_ima021     LIKE ima_file.ima021 #FUN-510017
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1) 
    sr              RECORD
        bmk01       LIKE bmk_file.bmk01,   #規格主件編號
        bmk02       LIKE bmk_file.bmk02,   #特性料件編號
        bmk03       LIKE bmk_file.bmk03,   #行序
        bmi02       LIKE bmi_file.bmi02    #條件編號
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmk01,sr.bmk02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED  ))/2)+1 , g_company CLIPPED  
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
            PRINT 
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bmk01
            SELECT ima02,ima021 INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01 = sr.bmk01
            IF SQLCA.sqlcode THEN
                LET l_ima02  = NULL
                LET l_ima021 = NULL
            END IF
            PRINT COLUMN g_c[31],sr.bmk01,
                  COLUMN g_c[32],l_ima02,
                  COLUMN g_c[33],l_ima021;
 
        ON EVERY ROW
            PRINT COLUMN g_c[34],sr.bmk02 USING '###&',
                  COLUMN g_c[35],sr.bmk03,
                  COLUMN g_c[36],sr.bmi02
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED      #No.TQC-740079
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED      #No.TQC-740079
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED      #No.TQC-740079
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED      #No.TQC-740079
            ELSE
                SKIP 2 LINE
            END IF
END REPORT }                                                                 #FUN-770052
