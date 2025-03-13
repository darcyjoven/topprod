# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi610.4gl
# Descriptions...: 上階主件對元件群組維護作業
# Date & Author..: 2003/04/15 alexwang
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/02/16 By Mandy 報表轉XML
# Modify.........: No.FUN-5A0061 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/07/08 By xiaofeizhu 制作水晶報表
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-920061 09/02/20 By dxfwo .out抓出數據sql錯誤導致畫面主件的品名規格都是元件的
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40058 10/04/26 By lilingyu bmb16增加規格替代的邏輯內容
# Modify.........: No.TQC-A60132 10/06/29 By chenmoyan 把ds_report改為g_cr_db_str
# Modify.........: No,FUN-AA0059 10/10/25 By vealxu 規通料件整合(3)全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0041 10/12/14 By lixh1  將SQL中的OUTER改為LEFT OUTER JOIN 
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-D10033 13/01/23 By bart 1.設定完set替代後，需update bmb16=5
#                                                 2.刪除後判斷如果不存在其他的set取替代則update bmb16=0。
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE                                     #模組變數(Module Variables)
    g_cnt2,g_cnt3   LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    g_argv1         LIKE boa_file.boa01,   #上階主件 (假單頭)
    g_argv2         LIKE boa_file.boa02,   #元件群組
    g_boa01         LIKE boa_file.boa01,   #類別代號 (假單頭)
    g_boa02         LIKE boa_file.boa02,   #元件群組
    g_boa08         LIKE boa_file.boa08,   #說明
    g_ima02         LIKE ima_file.ima02,   #品名規格
    g_ima021        LIKE ima_file.ima021,   #品名規格
    g_ima05         LIKE ima_file.ima05,   #目前使用版本
    g_ima08         LIKE ima_file.ima08,   #來源碼
    g_ima25         LIKE ima_file.ima25,
    g_ima63         LIKE ima_file.ima63,
    g_boa          DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                boa03       LIKE boa_file.boa03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07
   END RECORD,
    g_boa_t        RECORD                  #變數舊值
                boa03       LIKE boa_file.boa03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07
   END RECORD,
     g_wc                  string,                 #No.FUN-580092 HCN
     g_sql                 string,                 #No.FUN-580092 HCN
    g_ss                   LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680096 VARCHAR(1)
    g_check_bma01          LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680096 VARCHAR(1)
    g_rec_b                LIKE type_file.num5,    #單身筆數        #No.FUN-680096 SMALLINT
    l_ac                   LIKE type_file.num5     #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql      STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)       
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5         #No.FUN-680096 SMALLINT
DEFINE   l_table         STRING,                     ### FUN-770052 ###                                                                  
         g_str           STRING                      ### FUN-770052 ###
 
MAIN
    DEFINE    l_za05     LIKE type_file.chr1000     #No.FUN-680096 VARCHAR(40)
 
    OPTIONS                                        #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)               #傳key值
    LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "boa01.boa_file.boa01,",  
                "boa02.boa_file.boa02,",
                "boa03.boa_file.boa03,",
                "boa04.boa_file.boa04,",
                "boa05.boa_file.boa05,",
                "boa06.boa_file.boa06,",
                "boa07.boa_file.boa07,",
                "boa08.boa_file.boa08,",                                                                                          
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "ima02a.ima_file.ima02,",                                                                                            
                "ima021a.ima_file.ima021"                                                                                                                    
    LET l_table = cl_prt_temptable('abmi610',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,             #TQC-A60132                                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A60132                                                                      
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#  
 
    LET g_chkey = "N"                      #封鎖更改假單頭 key 功能
    #就算 p_zz 設 "Y" 也不給做 替代表沒必要做 key 值修改
 
    OPEN WINDOW i610_w WITH FORM "abm/42f/abmi610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
        CALL i610_q()
    ELSE
        LET g_argv1 = ''                     #清除鍵值
        LET g_argv2 = 0                      #清除鍵值
    END IF
    CALL i610_menu()
 
    CLOSE WINDOW i610_w                      #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
FUNCTION i610_curs()                         #QBE 查詢資料
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "boa01 = '",g_argv1 CLIPPED,"' "
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = g_wc CLIPPED," AND boa02 = ",g_argv2 CLIPPED
       END IF
    ELSE
       CLEAR FORM                               #清除畫面
       CALL g_boa.clear()
       IF cl_null(ARG_VAL(1)) AND cl_null(ARG_VAL(2)) THEN
           CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_boa01 TO NULL    #No.FUN-750051
   INITIALIZE g_boa02 TO NULL    #No.FUN-750051
   INITIALIZE g_boa08 TO NULL    #No.FUN-750051
           CONSTRUCT g_wc ON boa01,boa02,boa08,boa03,boa04,boa05,boa06,boa07
                        FROM boa01,boa02,boa08,
                             s_boa[1].boa03,s_boa[1].boa04,s_boa[1].boa05,
                             s_boa[1].boa06,s_boa[1].boa07
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(boa01)
#                    CALL q_ima(0,0,g_boa01) RETURNING g_boa01
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO boa01
                     NEXT FIELD boa01
                 WHEN INFIELD(boa03)     #元件料號
                    IF g_check_bma01 = 'Y' THEN
##Genero:兩種做法,hot code 會解決qry原本組合sql及回傳超過四個值的狀況
#                      CALL q_bmb3(FALSE,TRUE,g_boa01,g_boa[1].boa03,
#                                  g_boa[1].boa04,g_boa[1].boa05)
#                           RETURNING g_msg, g_boa[1].boa03,g_boa[1].boa04,g_boa[1].boa05
##CALL q_bmb3分支出去的q_bmb302且要在主程式將最後沒回傳到的值再SELECT出來
##不過, boa04,boa05後面都還會再開出其他的qry查詢, 是否boa03這邊要回傳boa04,05?
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmb302"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO boa03
                    ELSE
#FUN-AA0059 --Begin--
                   #    CALL cl_init_qry_var()
                   #    LET g_qryparam.form = "q_ima"
                   #    LET g_qryparam.state = "c"
                   #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret  
#FUN-AA0059 --End--
                       DISPLAY g_qryparam.multiret TO boa03
                    END IF
                    NEXT FIELD boa03
 
                WHEN INFIELD(boa04) #作業主檔
                   CALL q_ecd(TRUE,TRUE,g_boa[1].boa04)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO boa04
                     NEXT FIELD boa04
 
                 WHEN INFIELD(boa05)     #單位
#                   CALL q_gfe(3,3,g_boa[1].boa05) RETURNING g_boa[1].boa05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO boa05
                    NEXT FIELD boa05
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
       END IF
    END IF
 
    LET g_sql= "SELECT UNIQUE boa01, boa02, boa08 FROM boa_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY boa01, boa02"
 
    PREPARE i610_prepare FROM g_sql          #預備一下
    DECLARE i610_b_curs                      #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i610_prepare
 
    LET g_sql = "SELECT UNIQUE boa01,boa02 FROM boa_file ",
                " WHERE ",g_wc CLIPPED," GROUP BY boa01,boa02 "
 
    PREPARE i610_precount FROM g_sql
    DECLARE i610_count CURSOR FOR i610_precount
 
END FUNCTION
 
 
FUNCTION i610_menu()                         #中文的MENU
   DEFINE   l_cmd  LIKE type_file.chr50      #No.FUN-680096 VARCHAR(50)
 
   WHILE TRUE
      CALL i610_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i610_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i610_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i610_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i610_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i610_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i610_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "替代群組"
         WHEN "sub_group"
            IF cl_chk_act_auth() AND NOT cl_null(g_boa01) THEN
               CALL i610_v()
            END IF
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_boa01 IS NOT NULL THEN
                  LET g_doc.column1 = "boa01"
                  LET g_doc.value1  = g_boa01
                  LET g_doc.column2 = "boa02"
                  LET g_doc.value2  = g_boa02
                  LET g_doc.column3 = "boa08"
                  LET g_doc.value3  = g_boa08
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_boa),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i610_a()                            #Add  輸入
 
    MESSAGE ""
 
    CLEAR FORM
    CALL g_boa.clear()
    LET g_wc = NULL
    INITIALIZE g_boa01 LIKE boa_file.boa01   #預設值及將數值類變數清成零
    INITIALIZE g_boa02 LIKE boa_file.boa02
    INITIALIZE g_boa08 LIKE boa_file.boa08
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET g_check_bma01 = 'Y'
        CALL i610_i("a")                     #輸入單頭
 
        IF INT_FLAG THEN                     #使用者不玩了
            LET g_boa01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        LET g_rec_b = 0                    #No.FUN-680064
        IF g_ss='N' THEN
            CALL g_boa.clear()
        ELSE
            CALL i610_b_fill('1=1')          #單身
        END IF
 
        CALL i610_b()                        #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i610_u()
 
DEFINE l_boa01_t     LIKE boa_file.boa01,
       l_boa02_t     LIKE boa_file.boa02,
       l_boa08_t     LIKE boa_file.boa08
 
    IF s_shut(0) THEN RETURN END IF
    IF g_boa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    CALL i610_show()
    WHILE TRUE
        LET l_boa01_t = g_boa01 LET l_boa02_t = g_boa02
        LET l_boa08_t = g_boa08
        CALL i610_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_boa01 = l_boa01_t
           LET g_boa02 = l_boa02_t
           LET g_boa08 = l_boa08_t
           CALL i610_show()
           CALL cl_err('','9001',0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
 
        IF g_boa01 != l_boa01_t OR g_boa02 != l_boa02_t
        OR ( g_boa08 != l_boa08_t OR
           ( NOT cl_null(g_boa08) AND cl_null(l_boa08_t))) THEN
            IF g_chkey = "Y" THEN
                UPDATE boa_file
                   SET boa01=g_boa01,
                       boa02=g_boa02,
                       boa08=g_boa08
                 WHERE boa01=l_boa01_t AND boa02=l_boa02_t
            ELSE
                UPDATE boa_file SET boa08 = g_boa08
                 WHERE boa01=l_boa01_t AND boa02=l_boa02_t
            END IF
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err(g_boa01,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("upd","boa_file",l_boa01_t,l_boa02_t,SQLCA.sqlcode,"","",1) #TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_i(p_cmd)                       #處理INPUT
 
DEFINE
    p_cmd  LIKE type_file.chr1       #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_boa01,g_boa02,g_boa08 WITHOUT DEFAULTS
        FROM boa01,boa02,boa08
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i610_set_entry(p_cmd)
            CALL i610_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE FIELD boa01
            IF p_cmd="u" AND g_chkey="N" THEN NEXT FIELD boa08 END IF
 
        AFTER FIELD boa01                    #料件編號
            IF NOT cl_null(g_boa01) THEN
               #FUN-AA0059 -----------------------add start----------------------------
                IF NOT s_chk_item_no(g_boa01,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD boa01
                END IF 
               #FUN-AA0059 ----------------------add end------------------------------ 
                CALL i610_boa01(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err("ItemNo.:",g_errno,0)
                    NEXT FIELD boa01
                END IF
            END IF
 
        BEFORE FIELD boa02
            SELECT MAX(boa02) INTO g_boa02 FROM boa_file
             WHERE boa01 = g_boa01
            IF cl_null(g_boa02) THEN
                LET g_boa02 = 1
            ELSE
                LET g_boa02 = g_boa02 + 1
            END IF
            DISPLAY g_boa02 TO boa02
 
        AFTER FIELD boa02
            IF NOT cl_null(g_boa02) THEN
                CALL i610_boa02(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err("Serial:",g_errno,0)
                    NEXT FIELD boa02
                END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(boa01)
#                   CALL q_ima(0,0,g_boa01) RETURNING g_boa01
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = g_boa01
                  #  CALL cl_create_qry() RETURNING g_boa01
                    CALL q_sel_ima(FALSE, "q_ima", "", g_boa01, "", "", "", "" ,"",'' )  RETURNING g_boa01
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_boa01
                    NEXT FIELD boa01
               OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021
    END INPUT
END FUNCTION
 
FUNCTION  i610_boa01(p_cmd)
 
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_desc          LIKE fan_file.fan02,      #No.FUN-680096 VARCHAR(4) 
    l_cnt           LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima05         LIKE ima_file.ima05,
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti,
    l_boa02         LIKE boa_file.boa02
 
    LET g_errno = ""
 
    SELECT ima02,ima021,ima05,ima08,imaacti
      INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti FROM ima_file
     WHERE ima01=g_boa01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
                                   LET l_ima05 = NULL
                                   LET l_ima08 = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) THEN
       #CHECK此上階料號是否存在BOM單頭中
       # YES :單身所輸入的料件皆須存在此料件之BOM明細中(bmb_file)
       # NO  :單身所輸入的料件不須存在此料件之BOM明細中(bmb_file)
        SELECT COUNT(*) INTO l_cnt FROM bma_file
         WHERE bma01 = g_boa01
        IF l_cnt > 0 THEN
           LET g_check_bma01 = 'Y'
        ELSE
           LET g_check_bma01 = 'N'
        END IF
    END IF
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
        DISPLAY l_ima02 TO FORMONLY.ima02
        DISPLAY l_ima021 TO FORMONLY.ima021
        DISPLAY l_ima05 TO FORMONLY.ima05
        DISPLAY l_ima08 TO FORMONLY.ima08
    END IF
 
END FUNCTION
 
FUNCTION  i610_boa02(p_cmd)
 
DEFINE
    p_cmd    LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    LET g_errno = " "
 
    SELECT DISTINCT boa02 FROM boa_file
     WHERE boa01 = g_boa01 AND boa02 = g_boa02
    IF SQLCA.SQLCODE THEN
        IF SQLCA.SQLCODE != 100 THEN
            LET g_errno = SQLCA.sqlcode USING "-------"
        END IF
    ELSE
        LET g_ss="N"                         #進入單身的 sw
    END IF
END FUNCTION
 
FUNCTION i610_q()                            #Query 查詢
DEFINE l_boa        RECORD
       boa01        LIKE boa_file.boa01,
       boa02        LIKE boa_file.boa02
                    END RECORD,
       l_cnt        LIKE type_file.num5     #定義單頭總數   #No.FUN-680096 SMALLINT
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_boa01 TO NULL               #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i610_curs()                         #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_boa01 TO NULL
        RETURN
    END IF
    OPEN i610_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN                    #有問題
        CALL cl_err("",SQLCA.SQLCODE,0)
        INITIALIZE g_boa01 TO NULL
    ELSE
        FOREACH i610_count INTO l_boa.*
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i610_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i610_fetch(p_flag)                  #處理資料的讀取
 
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式    #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i610_b_curs INTO g_boa01, g_boa02, g_boa08
        WHEN 'P' FETCH PREVIOUS i610_b_curs INTO g_boa01, g_boa02, g_boa08
        WHEN 'F' FETCH FIRST    i610_b_curs INTO g_boa01, g_boa02, g_boa08
        WHEN 'L' FETCH LAST     i610_b_curs INTO g_boa01, g_boa02, g_boa08
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i610_b_curs INTO g_boa01,g_boa02,g_boa08
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_boa01,SQLCA.sqlcode,0)
       INITIALIZE g_boa01 TO NULL
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
 
    CALL i610_show()
 
END FUNCTION
 
FUNCTION i610_show()                         #將資料顯示在畫面上
 
 DEFINE  l_tot    LIKE type_file.num5        #No.FUN-680096 SMALLINT 
 
    DISPLAY g_boa01, g_boa02, g_boa08        #假單頭
         TO boa01, boa02, boa08
    CALL i610_boa01('d')                     #單身
 
    CALL i610_b_fill(g_wc)                   #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i610_r()                            #取消整筆 (所有合乎單頭的資料)
DEFINE l_boa        RECORD
       boa01        LIKE boa_file.boa01,
       boa02        LIKE boa_file.boa02
       END RECORD,
       l_cnt        LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_i          LIKE type_file.num5      #CHI-D10033
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_boa01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_success = 'Y'
 
    BEGIN WORK
    IF l_cnt > 0 THEN
       IF NOT cl_confirm('abm-800') THEN
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       IF NOT cl_delh(0,0) THEN                   #確認一下
          ROLLBACK WORK
          RETURN
       END IF
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "boa01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1  = g_boa01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "boa02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2  = g_boa02      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "boa08"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3  = g_boa08      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
    END IF
    IF l_cnt > 0 THEN
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
    END IF
 
    DELETE FROM boa_file WHERE boa01 = g_boa01 AND boa02 = g_boa02
    IF SQLCA.sqlcode THEN
 #       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("del","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","BODY DELETE",1) #TQC-660046
        ROLLBACK WORK
        CALL cl_rbmsg(1)
        RETURN
    ELSE
        #CHI-D10033---begin
        FOR l_i = 1 TO g_boa.getLength()
           LET l_cnt = 0
           SELECT COUNT(*)
             INTO l_cnt
             FROM boa_file
            WHERE boa01 = g_boa01
              AND boa03 = g_boa[l_i].boa03
           IF l_cnt = 0 THEN
              UPDATE bmb_file 
                 SET bmb16='0'
               WHERE bmb01 = g_boa01
                 AND bmb03 = g_boa[l_i].boa03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","bmb_file","",g_boa[l_i].boa03,SQLCA.sqlcode,"","",0)
              END IF
           END IF 
        END FOR 
        #CHI-D10033---end
        CLEAR FORM
        CALL g_boa.clear()
        LET g_row_count = 0
        FOREACH i610_count INTO l_boa.*
            LET g_row_count = g_row_count + 1
        END FOREACH
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i610_b_curs
           CLOSE i610_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--

        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i610_b_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i610_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL i610_fetch('/')
        END IF
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        COMMIT WORK
    END IF
 
    LET g_msg=TIME
    #重要資料異動記錄 aoo/azo_file
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)#FUN-980001 add plant & legal
       VALUES ('abmi610',g_user,g_today,g_msg,g_boa01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal
 
END FUNCTION
 
FUNCTION i610_b()                          #單身
 
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(80)
    l_tot           LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_cnt           LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否    #No.FUN-680096 SMALLINT
DEFINE   l_bmb10    LIKE bmb_file.bmb10
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_boa01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT boa03,'','',boa04,boa05,boa06,boa07 ",
       "  FROM boa_file ",
       "  WHERE boa01= ? ",
       "   AND boa02= ? ",
       "   AND boa03= ? ",
       "   AND boa04= ? ",
       "   AND boa05= ? ",
       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i610_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_boa WITHOUT DEFAULTS FROM s_boa.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL i610_set_entry_b(p_cmd)
            CALL i610_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac   = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_boa_t.* = g_boa[l_ac].*  #BACKUP
                BEGIN WORK
 
                OPEN i610_bcl USING g_boa01,g_boa02,g_boa_t.boa03,g_boa_t.boa04,g_boa_t.boa05
                IF STATUS THEN
                    CALL cl_err("OPEN i610_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i610_bcl INTO g_boa[l_ac].*
                    IF SQLCA.SQLCODE THEN
                        CALL cl_err("P/NSpec:",SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_boa_t.*=g_boa[l_ac].*
                    SELECT ima02,ima021 INTO g_boa[l_ac].ima02b,g_boa[l_ac].ima021b FROM ima_file
                     WHERE ima01 = g_boa[l_ac].boa03
                    IF SQLCA.sqlcode THEN
                        LET g_boa[l_ac].ima02b=" "
                        LET g_boa[l_ac].ima021b=" "
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD boa03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
             INSERT INTO boa_file (boa01,boa02,boa03,boa04,boa05,boa06,boa07,boa08) #No.MOD-470041
                 VALUES (g_boa01,g_boa02,g_boa[l_ac].boa03,g_boa[l_ac].boa04,
                         g_boa[l_ac].boa05,g_boa[l_ac].boa06,g_boa[l_ac].boa07,
                         g_boa08)
            IF SQLCA.sqlcode THEN
 #               CALL cl_err(g_boa02,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","",1)  #TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            #CHI-D10033---begin
            UPDATE bmb_file SET bmb16='5' WHERE
               bmb01=g_boa01 AND bmb03=g_boa[l_ac].boa03
            #CHI-D10033---end
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_boa[l_ac].* TO NULL       #900423
            LET g_boa_t.* = g_boa[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD boa03
 
        AFTER FIELD boa03
            IF NOT cl_null(g_boa[l_ac].boa03) THEN
              #FUN-AA0059 ------------------------------add start-----------------------
               IF NOT s_chk_item_no(g_boa[l_ac].boa03,'') THEN
                  CALL cl_err('',g_errno,1) 
                  NEXT FIELD boa03
               END IF 
              #FUN-AA0059 ------------------------------add end--------------------------
              #元件料號不可等於[上階主件]
               IF g_boa[l_ac].boa03 = g_boa01 THEN
                  CALL cl_err(g_boa[l_ac].boa03,'abm-016',0)
                  NEXT FIELD boa03
               END IF
               CALL i610_boa03("a")
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_boa[l_ac].boa03,g_errno,0) 
                  NEXT FIELD boa03
               END IF
            ELSE
                LET g_boa[l_ac].ima02b = " "
                LET g_boa[l_ac].ima021b = " "
            END IF
 
        AFTER FIELD boa04
            IF g_boa[l_ac].boa04 IS NULL THEN
               LET g_boa[l_ac].boa04=" "
            END IF
            IF NOT cl_null(g_boa[l_ac].boa04) THEN
               CALL i610_boa04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_boa[l_ac].boa04,g_errno,0)
                  NEXT FIELD boa04
               END IF
            END IF
 
        AFTER FIELD boa05
            IF NOT cl_null(g_boa[l_ac].boa05) THEN
                CALL i610_boa05('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_boa[l_ac].boa05,g_errno,0) 
                    NEXT FIELD boa05
                END IF
                #CHECK KEY值是否有重覆
                IF p_cmd='a' OR ( p_cmd = 'u' AND
                   ( g_boa_t.boa03 !=g_boa[l_ac].boa03
                   OR g_boa_t.boa04 !=g_boa[l_ac].boa04
                   OR g_boa_t.boa05 !=g_boa[l_ac].boa05 )) THEN
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM boa_file
                    WHERE boa01 = g_boa01
                      AND boa02 = g_boa02
                      AND boa03 = g_boa[l_ac].boa03
                      AND boa04 = g_boa[l_ac].boa04
                      AND boa05 = g_boa[l_ac].boa05
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_boa[l_ac].boa03,'-239',0)
                      NEXT FIELD boa05
                   END IF
 
                   #CHECK所輸入的料件資料是否已存在上階料其他替代料資料中
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM boa_file
                    WHERE boa01 = g_boa01
                      AND boa02 != g_boa02
                      AND boa03 = g_boa[l_ac].boa03
                      AND boa04 = g_boa[l_ac].boa04
                      AND boa05 = g_boa[l_ac].boa05
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_boa[l_ac].boa03,'abm-017',0)
                      NEXT FIELD boa05
                   END IF
                END IF
            END IF
 
        BEFORE FIELD boa06
            IF cl_null(g_boa[l_ac].boa06) THEN
                LET g_boa[l_ac].boa06 = g_today
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_boa[l_ac].boa06
                #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD boa06
            IF NOT cl_null(g_boa[l_ac].boa06) THEN
                IF NOT cl_null(g_boa[l_ac].boa07) THEN
                   #失效日期不可小於生效日期
                   IF g_boa[l_ac].boa06 > g_boa[l_ac].boa07 THEN
                      CALL cl_err(g_boa[l_ac].boa07,'mfg2604',1)
                      NEXT FIELD boa06
                   END IF
                END IF
            END IF
 
        AFTER FIELD boa07
            IF NOT cl_null(g_boa[l_ac].boa07) THEN
              #失效日期不可小於生效日期
               IF g_boa[l_ac].boa06 > g_boa[l_ac].boa07 THEN
                  CALL cl_err(g_boa[l_ac].boa07,'mfg2604',1)
                  NEXT FIELD boa06
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_boa_t.boa03) THEN
               IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
               END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
               DELETE FROM boa_file
                WHERE boa01 = g_boa01       AND boa02 = g_boa02
                  AND boa03 = g_boa_t.boa03 AND boa04 = g_boa_t.boa04
                  AND boa05 = g_boa_t.boa05
               IF SQLCA.SQLCODE THEN
 #                  CALL cl_err("Del-ItemNo.:",SQLCA.SQLCODE,0) #No.TQC-660046
                   CALL cl_err3("del","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","Del-ItemNo",1)  #TQC-660046
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               #CHI-D10033---begin
               LET l_cnt = 0
               SELECT COUNT(*)
                 INTO l_cnt
                 FROM boa_file
                WHERE boa01 = g_boa01
                  AND boa03 = g_boa_t.boa03
               IF l_cnt = 0 THEN
                  UPDATE bmb_file 
                     SET bmb16='0'
                   WHERE bmb01 = g_boa01
                     AND bmb03 = g_boa_t.boa03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","bmb_file","",g_boa_t.boa03,SQLCA.sqlcode,"","",0)
                  END IF
               END IF 
               #CHI-D10033---end
               COMMIT WORK
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_boa[l_ac].* = g_boa_t.*
               CLOSE i610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_boa[l_ac].boa03,-263,1)
                LET g_boa[l_ac].* = g_boa_t.*
            ELSE
                UPDATE boa_file
                  SET boa03=g_boa[l_ac].boa03,
                      boa04=g_boa[l_ac].boa04,
                      boa05=g_boa[l_ac].boa05,
                      boa06=g_boa[l_ac].boa06,
                      boa07=g_boa[l_ac].boa07
                WHERE boa01=g_boa01
                  AND boa02=g_boa02
                  AND boa03=g_boa_t.boa03
                  AND boa04=g_boa_t.boa04
                  AND boa05=g_boa_t.boa05
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
 #                   CALL cl_err(g_boa[l_ac].boa03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","",1) #TQC-660046
                    LET g_boa[l_ac].* = g_boa_t.*
                    ROLLBACK WORK
                ELSE
                    #CHI-D10033---begin
                    IF g_boa[l_ac].boa03 <> g_boa_t.boa03 THEN 
                       LET l_cnt = 0
                       SELECT COUNT(*)
                         INTO l_cnt
                         FROM boa_file
                        WHERE boa01 = g_boa01
                          AND boa03 = g_boa_t.boa03
                       IF l_cnt = 0 THEN
                          UPDATE bmb_file 
                             SET bmb16='0'
                           WHERE bmb01 = g_boa01
                            AND bmb03 = g_boa_t.boa03
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","bmb_file","",g_boa_t.boa03,SQLCA.sqlcode,"","",0)
                          END IF 
                       END IF  
                       UPDATE bmb_file 
                          SET bmb16='5'
                        WHERE bmb01 = g_boa01
                         AND bmb03 = g_boa[l_ac].boa03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmb_file","",g_boa[l_ac].boa03,SQLCA.sqlcode,"","",0)
                       END IF
                    END IF 
                    #CHI-D10033---end
                    MESSAGE "UPDATE O.K"
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
                  LET g_boa[l_ac].* = g_boa_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_boa.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_boa_t.* = g_boa[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i610_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(boa03)     #元件料號
                  IF g_check_bma01 = 'Y' THEN
##Genero:兩種做法,hot code 會解決qry原本組合sql及回傳超過四個值的狀況
#                    CALL q_bmb3(FALSE,TRUE,g_boa01,g_boa[l_ac].boa03,
#                                g_boa[l_ac].boa04,g_boa[l_ac].boa05)
#                         RETURNING g_msg, g_boa[l_ac].boa03,g_boa[l_ac].boa04,g_boa[l_ac].boa05
##CALL FGL_DIALOG_SETBUFFER( g_msg )
##CALL FGL_DIALOG_SETBUFFER(  g_boa[l_ac].boa03 )
##CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa04 )
##CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa05 )
##CALL q_bmb3分支出去的q_bmb302且要在主程式將最後沒回傳到的值再SELECT出來
##不過, boa04,boa05後面都還會再開出其他的qry查詢, 是否boa03這邊要回傳boa04,05?
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmb302"
                     LET g_qryparam.default1 = g_boa01
                     LET g_qryparam.default2 = g_boa[l_ac].boa03
                     LET g_qryparam.default3 = g_boa[l_ac].boa04
                     LET g_qryparam.arg1     = g_boa01
                     CALL cl_create_qry() RETURNING g_msg, g_boa[l_ac].boa03,g_boa[l_ac].boa04
#                     CALL FGL_DIALOG_SETBUFFER( g_msg )
#                     CALL FGL_DIALOG_SETBUFFER(  g_boa[l_ac].boa03 )
#                     CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa04 )
                      DISPLAY BY NAME g_boa[l_ac].boa03           #No.MOD-490371
                      DISPLAY BY NAME g_boa[l_ac].boa04           #No.MOD-490371
                     SELECT bmb10 INTO l_bmb10 FROM bmb_file
                      WHERE bmb01 = g_boa01
                     DISPLAY l_bmb10 TO boa05
                  ELSE
#                    CALL q_ima(4,0,g_boa[l_ac].boa03) RETURNING g_boa[l_ac].boa03
#                    CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa03 )
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.default1 = g_boa[l_ac].boa03
                   #  CALL cl_create_qry() RETURNING g_boa[l_ac].boa03
                      CALL q_sel_ima(FALSE, "q_ima", "", g_boa[l_ac].boa03, "", "", "", "" ,"",'' )  RETURNING g_boa[l_ac].boa03
#FUN-AA0059 --End--
#                     CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa03 )
                      DISPLAY BY NAME g_boa[l_ac].boa03           #No.MOD-490371
                     CALL i610_boa03('a')
                  END IF
                  NEXT FIELD boa03
 
                WHEN INFIELD(boa04)     #作業編號
                   CALL q_ecd(FALSE,TRUE,g_boa[l_ac].boa04) RETURNING g_boa[l_ac].boa04
#                   CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa04 )
                   DISPLAY g_boa[l_ac].boa04 TO boa04
                   NEXT FIELD boa04
 
                WHEN INFIELD(boa05)     #單位
#                    CALL q_gfe(3,3,g_boa[l_ac].boa05) RETURNING g_boa[l_ac].boa05
#                    CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa05 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.default1 = g_boa[l_ac].boa05
                     CALL cl_create_qry() RETURNING g_boa[l_ac].boa05
#                     CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa05 )
                     NEXT FIELD boa05
            END CASE
 
      # ON ACTION CONTROLN
      #     CALL i610_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
#           IF INFIELD(boa02) AND l_ac > 1 THEN
            IF l_ac > 1 THEN
                LET g_boa[l_ac].* = g_boa[l_ac-1].*
                NEXT FIELD boa03
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
 
 
    CLOSE i610_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_boa03(p_cmd)         #元件料號, 預帶入 boa05
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_imaacti LIKE ima_file.imaacti,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_n       LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    LET g_errno = ''
    LET g_ima25 = ''
    LET g_ima63 = ''
 
    SELECT ima02,ima021,ima25,ima63,imaacti
      INTO l_ima02,l_ima021,g_ima25,g_ima63,l_imaacti FROM ima_file
     WHERE ima01 = g_boa[l_ac].boa03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "ams-003"
                                   LET l_ima02 = ""
                                   LET l_ima021= ""
                                   LET l_imaacti = ""
         WHEN l_imaacti='N'        LET g_errno = "9028"
     #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690022------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
    IF cl_null(g_errno) AND g_check_bma01 = 'Y' THEN
      #因上階料件存在BOM中(g_check_bma01='Y')...SO.....
      #CHECK元件料號必須為上階主件的下階料
       SELECT UNIQUE bmb03 FROM bmb_file
        WHERE bmb01 = g_boa01
          AND bmb03 = g_boa[l_ac].boa03
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "abm-015"
            OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
       END CASE
    END IF
 
    IF p_cmd = 'a' THEN
      #順便將預設單位值丟出來
       LET g_boa[l_ac].ima02b = l_ima02
       LET g_boa[l_ac].ima021b = l_ima021
       IF g_check_bma01 = 'N' OR cl_null(g_boa[l_ac].boa05) THEN
          LET g_boa[l_ac].boa05  = g_ima63
       END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_boa[l_ac].ima02b = l_ima02
       LET g_boa[l_ac].ima021b = l_ima021
    END IF
END FUNCTION
 
FUNCTION i610_boa04(p_cmd)         #作業編號
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ecdacti LIKE ecd_file.ecdacti
 
    LET g_errno = ""
    SELECT ecdacti INTO l_ecdacti FROM ecd_file
     WHERE ecd01 = g_boa[l_ac].boa04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "aec-015"
         WHEN l_ecdacti='N'        LET g_errno = "9028"
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
END FUNCTION
 
 
FUNCTION i610_boa05(p_cmd)         #單位
 
    DEFINE p_cmd     LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
           l_gfeacti LIKE gfe_file.gfeacti,
           l_gfe01   LIKE gfe_file.gfe01,
           l_sfa13   LIKE sfa_file.sfa13,
           l_n       LIKE type_file.num5        #No.FUN-680096 SMALLINT
 
    LET g_errno = ""
    SELECT gfe01,gfeacti INTO l_gfe01,l_gfeacti FROM gfe_file
     WHERE gfe01 = g_boa[l_ac].boa05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "mfg1326"
         WHEN l_gfeacti='N'        LET g_errno = "9028"
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
    IF NOT cl_null(g_errno) THEN
      #單身的『單位』要檢查對庫存單位是否有建立轉換率
       CALL s_umfchk(g_boa[l_ac].boa03,g_boa[l_ac].boa05,g_ima25)
           RETURNING l_n,l_sfa13
       IF l_n = 1 THEN
          LET g_errno = 'mfg3075'
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i610_b_askkey()
 
DEFINE
    l_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
 
    CONSTRUCT l_wc ON boa03,boa04,boa05,boa06,boa07
                 FROM s_boa[1].boa03,s_boa[1].boa04,
                      s_boa[1].boa05,s_boa[1].boa06,s_boa[1].boa07
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
    CALL i610_b_fill(l_wc)
END FUNCTION
 
FUNCTION i610_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
 
    LET g_sql =
       "SELECT boa03,ima02,ima021,boa04,boa05,boa06,boa07 ",
      #"  FROM boa_file,OUTER ima_file ",                 #TQC-AB0041
       "  FROM boa_file LEFT OUTER JOIN ima_file ",       #TQC-AB0041       
       "    ON boa_file.boa03 =ima_file.ima01 ",          #TQC-AB0041 
       " WHERE boa01 = '",g_boa01,"' ",
       "   AND boa02 = '",g_boa02,"' ",
      #"   AND boa_file.boa03 =ima_file.ima01 ",          #TQC-AB0041 
       "   AND ",p_wc CLIPPED
 
    PREPARE i610_prepare2 FROM g_sql           #預備一下
    DECLARE boa_curs CURSOR FOR i610_prepare2
    CALL g_boa.clear()
    LET g_cnt = 1
    FOREACH boa_curs INTO g_boa[g_cnt].*       #單身 ARRAY 填充
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
    #CKP
    CALL g_boa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boa TO s_boa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(g_argv1) THEN
             CALL cl_set_act_visible("sub_group",FALSE)
         END IF
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #@ON ACTION 替代群組
      ON ACTION sub_group
         LET g_action_choice="sub_group"
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i610_v()
 
DEFINE l_msg    LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(100)
       l_bmb16  LIKE bmb_file.bmb16
 
    LET g_msg = "abmi611 '",g_boa01 CLIPPED,"' '",g_boa02 CLIPPED,"'"
    CALL cl_cmdrun(g_msg)
 
RETURN
 
    #詢問是否回寫 bmb16替代碼="5"
    SELECT bmb16 INTO l_bmb16 FROM bmb_file
     WHERE bmb01 = g_boa01
    IF SQLCA.SQLCODE THEN
        sleep 5
    END IF
    LET l_msg = "是否將",g_boa01 CLIPPED,"元件取替代特性由"
    CASE
        WHEN l_bmb16="0" LET l_msg=l_msg CLIPPED,"不可取替代"
        WHEN l_bmb16="1" LET l_msg=l_msg CLIPPED,"新料,有舊料可取代(UTE)"
        WHEN l_bmb16="2" LET l_msg=l_msg CLIPPED,"主料,有副料可替代(SUB)"
        WHEN l_bmb16="7" LET l_msg=l_msg CLIPPED,"規格替代"                     #FUN-A40058
        WHEN l_bmb16="5" RETURN
        OTHERWISE        LET l_msg=l_msg CLIPPED,"未記錄取替代特性"
    END CASE
    LET l_msg=l_msg CLIPPED,"變更為:主料,可做SET替代?"
    IF cl_prompt(0,0,l_msg) THEN
        sleep 5
    END IF
 
END FUNCTION
 
FUNCTION i610_out()
DEFINE
    l_i         LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    sr          RECORD
                boa01       LIKE boa_file.boa01,
                boa02       LIKE boa_file.boa02,
                boa03       LIKE boa_file.boa03,
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                boa08       LIKE boa_file.boa08,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021
    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
    DEFINE l_sql     STRING                  #FUN-770052 
    DEFINE l_ima02  LIKE ima_file.ima02    #FUN-770052                                                                             
    DEFINE l_ima021 LIKE ima_file.ima021   #FUN-770052                                                                             
    IF cl_null(g_wc) THEN
        LET g_wc="     boa01='",g_boa01,"'",
                 " AND boa02= ",g_boa02
    END IF
    IF cl_null(g_boa01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abmi610') RETURNING l_name                      #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------# 
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
 
    LET g_sql="SELECT boa01,boa02,boa03,boa04,boa05,boa06,boa07,boa08,''",
              " FROM boa_file ",              # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
 
    PREPARE i610_p1 FROM g_sql                # uUNTIME 編譯
    DECLARE i610_curo                         # CURSOR
        CURSOR FOR i610_p1
 
#   START REPORT i610_rep TO l_name           #FUN-770052
 
    FOREACH i610_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
         WHERE ima01 = sr.boa03
        IF cl_null(sr.ima02) THEN LET sr.ima02 = " " END IF
        IF cl_null(sr.ima021) THEN LET sr.ima021 = " " END IF
 ###--FUN-770052--begin--
          SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                                 
            FROM ima_file                                                                                                           
#          WHERE ima01= sr.boa03   #TQC-920061
           WHERE ima01= sr.boa01   #TQC-920061
 ###--FUN-770052--end--
#       OUTPUT TO REPORT i610_rep(sr.*)       #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.boa01,sr.boa02,sr.boa03,sr.boa04,sr.boa05,sr.boa06,
                   sr.boa07,sr.boa08,sr.ima02,sr.ima021,l_ima02,l_ima021                                                             
        #------------------------------ CR (3) ------------------------------#     
    END FOREACH
 
#   FINISH REPORT i610_rep                    #FUN-770052
 
    CLOSE i610_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)         #FUN-770052
 
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'boa01,boa02,boa08,boa03,boa04,boa05,boa06,boa07')                                                                                                  
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''
    LET g_str = g_wc                                                                                                                  
    CALL cl_prt_cs3('abmi610','abmi610',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
{REPORT i610_rep(sr)                          #FUN-770052
DEFINE
    l_ima02         LIKE ima_file.ima02,      #FUN-510033
    l_ima021        LIKE ima_file.ima021,     #FUN-510033
    l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_chr           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_tot           LIKE type_file.num20_6,   #No.FUN-680096 DECIMAL(20,6)
    l_page          LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_dash          LIKE type_file.chr20,     #No.FUN-680096 VARCHAR(20)
    sr              RECORD
                boa01       LIKE boa_file.boa01,
                boa02       LIKE boa_file.boa02,
                boa03       LIKE boa_file.boa03,
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                boa08       LIKE boa_file.boa08,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021
    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.boa01,sr.boa02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
            PRINTX name=H2 g_x[38],g_x[43],g_x[39],g_x[40]   #No.FUN-5A0061 modify
            PRINTX name=H3 g_x[41],g_x[44],g_x[42]           #No.FUN-5A0061 modify
            PRINT g_dash1
            LET l_trailer_sw = 'n'
 
        BEFORE GROUP OF sr.boa01  #料件編號
            SKIP TO TOP OF PAGE
 
        ON EVERY ROW
          SELECT ima02,ima021 INTO l_ima02,l_ima021
            FROM ima_file
           WHERE ima01= sr.boa03
          PRINTX name=D1 COLUMN g_c[31],sr.boa01,
                         COLUMN g_c[32],sr.boa02 USING "########",
                         COLUMN g_c[33],sr.boa03,
                         COLUMN g_c[34],sr.boa04,
                         COLUMN g_c[35],sr.boa05,
                         COLUMN g_c[36],sr.boa06,
                         COLUMN g_c[37],sr.boa07
          PRINTX name=D2 COLUMN g_c[38],sr.ima02,
                         COLUMN g_c[39],l_ima02,
                         COLUMN g_c[40],sr.boa08
          PRINTX name=D3 COLUMN g_c[41],sr.ima021,
                         COLUMN g_c[42],l_ima021
 
        AFTER GROUP OF sr.boa01  #料件編號
            LET l_trailer_sw = 'n'
 
        ON LAST ROW
            LET l_trailer_sw = 'y'
 
        PAGE TRAILER
            PRINT COLUMN  1,g_dash
            IF l_trailer_sw = 'y' THEN
                PRINT COLUMN  1,g_x[4] CLIPPED,
                      COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                PRINT COLUMN  1,g_x[4] CLIPPED,
                      COLUMN (g_len-9), g_x[5] CLIPPED
            END IF
END REPORT}                                                  #FUN-770052
 
#單頭
FUNCTION i610_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("boa01,boa02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i610_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("boa01,boa02",FALSE)
       END IF
   END IF
 
END FUNCTION
#單身
FUNCTION i610_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("boa03,boa05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i610_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' THEN
           CALL cl_set_comp_entry("boa03,boa05",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
