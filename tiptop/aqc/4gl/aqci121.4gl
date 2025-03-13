# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqci121.4gl
# Descriptions...: 站別料件檢驗項目AQL設定作業
# Date & Author..: 00/02/22 By Melody
# Modify.........: 01/04/10 By Kammy
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-580372 05/09/06 By Nicola 作業編號開窗修改
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.MOD-690009 06/12/08 By pengu i121_prepare & i121_precount條件不match
# Modify.........: No.MOD-6A0132 06/10/27 By Carol 查詢時應可依作業編號QBE
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.MOD-730035 07/03/09 By pengu 當查詢時,作業編號無法開窗
# Modify.........: No.TQC-740144 07/04/24 By hongmei 控管上線值要大于下線值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.TQC-950129 09/06/05 By chenmoyan 單頭開窗default1值給了''
# Modify.........: No.TQC-950130 09/05/21 By chenmoyan 復制時，單頭料號、作業編號 after field 會判斷是否存在，但不存在的資料仍可存檔成功。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990071 09/09/23 By chenmoyan 料件編號允許輸入*
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60086 10/06/21 By houlia insert 欄位跟values不一致，調整
# Modify.........: No.TQC-A60132 10/07/19 By chenmoyan 鎖表語句不標準
# Modify.........: No.FUN-A80063 10/08/16 By wujie     qcc04和qcc05位置互换
#                                                      qcc05增加item选项及控管
# Modify.........: No.TQC-AA0096 10/10/15 By Carrier 加入 FIELD ORDER FORM 属性来解决set_no_entry字段,mouse点击时当出的问题
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_qcc01         LIKE qcc_file.qcc01,   #類別代號 (假單頭)
    g_qcc011        LIKE qcc_file.qcc011,  #作業編號
    g_qccacti       LIKE qcc_file.qccacti, # 96-06-18
    g_qccuser       LIKE qcc_file.qccuser, #
    g_qccgrup       LIKE qcc_file.qccgrup, #
    g_qccmodu       LIKE qcc_file.qccmodu, #
    g_qccdate       LIKE qcc_file.qccdate, #
    g_qcc01_t       LIKE qcc_file.qcc01,   #類別代號 (舊值)
    g_qcc011_t      LIKE qcc_file.qcc011,  #作業編號 (舊值)
    g_qcc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                qcc02       LIKE qcc_file.qcc02,
                azf03       LIKE azf_file.azf03,
                qcc08       LIKE qcc_file.qcc08,           #No.FUN-910079
                qcc03       LIKE qcc_file.qcc03,
#No.FUN-A80063 --begin
                qcc05       LIKE qcc_file.qcc05,
                qcc04       LIKE qcc_file.qcc04,
#No.FUN-A80063 --end
               qcc061      LIKE qcc_file.qcc061,
               qcc062      LIKE qcc_file.qcc062,
               qcc07       LIKE qcc_file.qcc07
                    END RECORD,
    g_qcc_t         RECORD                 #程式變數 (舊值)
                qcc02       LIKE qcc_file.qcc02,
                azf03       LIKE azf_file.azf03,
                qcc08       LIKE qcc_file.qcc08,           #No.FUN-910079
                qcc03       LIKE qcc_file.qcc03,
#No.FUN-A80063 --begin
                qcc05       LIKE qcc_file.qcc05,
                qcc04       LIKE qcc_file.qcc04,
#No.FUN-A80063 --end
                qcc061      LIKE qcc_file.qcc061,
                qcc062      LIKE qcc_file.qcc062,
                qcc07       LIKE qcc_file.qcc07
                    END RECORD,
    g_argv1         LIKE qcc_file.qcc01,
    g_wc,g_sql      STRING,                      #No.FUN-580092 HCN
    g_ss            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01) #決定後續步驟
    g_rec_b         LIKE type_file.num5,         #單身筆數  #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
DEFINE g_forupd_sql   STRING                     #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_sql_tmp      STRING                     #No.TQC-720019
DEFINE g_cnt          LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_msg          LIKE type_file.chr1000     #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_curs_index   LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_jump         LIKE type_file.num10       #No.FUN-680104 INTEGER
DEFINE g_no_ask      LIKE type_file.num5        #No.FUN-680104 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5   #No.TQC-AA0096
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
          FIELD ORDER FORM                #No.TQC-AA0096
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               #料件編號

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0085

    LET g_qcc01 = NULL                     #清除鍵值
    LET g_qcc01_t = NULL
    LET g_qcc01 = g_argv1
 
    OPEN WINDOW i121_w WITH FORM "aqc/42f/aqci121"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL  i121_q()
    END IF
    CALL i121_menu()

    CLOSE WINDOW i121_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION i121_curs()
    CLEAR FORM                             #清除畫面
    CALL g_qcc.clear()
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcc01 TO NULL                 #No.FUN-750051
   INITIALIZE g_qcc011 TO NULL                #No.FUN-750051
    CONSTRUCT g_wc ON qcc01,qcc011 FROM qcc01,qcc011  #MOD-6A0132 add qcc011  
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcc01)
#                    CALL q_ima(0,0,'') RETURNING g_qcc01
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                     DISPLAY g_qryparam.multiret TO qcc01
                     NEXT FIELD qcc01
                  #------------No.MOD-730035 add
                   WHEN INFIELD(qcc011)
                        CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO qcc011
                        NEXT FIELD qcc011
                  #------------No.MOD-730035 end
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qccuser', 'qccgrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc = " qcc01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE qcc01,qcc011 FROM qcc_file ",
#MOD-6A0132--modify
   #           " WHERE ", g_wc CLIPPED," AND qcc011 IS NOT NULL",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY qcc01,qcc011"
#MOD-6A0132--end
    PREPARE i121_prepare FROM g_sql      #預備一下
    DECLARE i121_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i121_prepare
   #-------No.MOD-690009--modify
   #LET g_sql="SELECT COUNT(DISTINCT qcc01) FROM qcc_file WHERE ",g_wc CLIPPED
   #LET g_sql="SELECT COUNT(DISTINCT qcc01) FROM qcc_file WHERE ",g_wc CLIPPED,
   #          " AND qcc011 IS NOT NULL "
    DROP TABLE x   #MOD-6A0132 add
#   LET g_sql="SELECT DISTINCT qcc01,qcc011 FROM qcc_file WHERE ",      #No.TQC-720019
    LET g_sql_tmp="SELECT DISTINCT qcc01,qcc011 FROM qcc_file WHERE ",  #No.TQC-720019
               g_wc CLIPPED," INTO TEMP x"  #MOD-6A0132 modify
 
    #MOD-6A0132 add
#   PREPARE i121_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i121_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i121_precount_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"    
    #MOD-6A0132 end
   #-------No.MOD-690009--end
    PREPARE i121_precount FROM g_sql
    DECLARE i121_count CURSOR FOR i121_precount
END FUNCTION
 
 
FUNCTION i121_menu()
 
   WHILE TRUE
      CALL i121_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i121_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i121_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i121_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i121_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i121_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcc),'','')
            END IF
         #No.FUN-6A0160-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_qcc01 IS NOT NULL THEN
                LET g_doc.column1 = "qcc01"
                LET g_doc.column2 = "qcc011"
                LET g_doc.value1 = g_qcc01
                LET g_doc.value2 = g_qcc011
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0160-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i121_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_qcc.clear()
    INITIALIZE g_qcc01 LIKE qcc_file.qcc01
    INITIALIZE g_qcc011 LIKE qcc_file.qcc011
    LET g_qcc01_t  = NULL
    LET g_qcc011_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i121_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF g_ss='N' THEN
           CALL g_qcc.clear()
        ELSE
            CALL i121_b_fill('1=1')         #單身
        END IF
        LET g_rec_b = 0
        CALL i121_b()                       #輸入單身
        LET g_qcc01_t = g_qcc01             #保留舊值
        LET g_qcc011_t = g_qcc011           #保留舊值    #MOD-6A0132
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i121_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)
 
     LET g_ss='Y'
     LET g_qccacti = 'Y'             # 有效的資料 96-06-18
     LET g_qccuser = g_user          # 使用者
     LET g_qccgrup = g_grup          # 使用者所屬群
     LET g_qccdate = g_today         # 更改日期

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_qcc01,g_qcc011           
        WITHOUT DEFAULTS
        FROM qcc01,qcc011
 
        AFTER FIELD qcc01                  #類別代號
#           IF NOT cl_null(g_qcc01) THEN                    #No.FUN-990071
            IF NOT cl_null(g_qcc01) AND g_qcc01<>'*' THEN   #No.FUN-990071
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_qcc01,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_qcc01= g_qcc01_t
                  NEXT FIELD qcc01
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                CALL i121_qcc01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_qcc01,g_errno,0)
                   NEXT FIELD qcc01
                END IF
            END IF
 
        AFTER FIELD qcc011
            IF NOT cl_null(g_qcc011) THEN
                CALL i121_qcc011('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_qcc011,g_errno,0)
                   NEXT FIELD qcc011
                END IF
            END IF
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcc01)
#                    CALL q_ima(0,0,'') RETURNING g_qcc01
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = ''      #No.TQC-950129
#                    LET g_qryparam.default1 = g_qcc01 #No.TQC-950129 
#                    CALL cl_create_qry() RETURNING g_qcc01
                     CALL q_sel_ima(FALSE, "q_ima","",g_qcc01,"","","","","",'' ) 
                      RETURNING  g_qcc01  
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY BY NAME g_qcc01
                     NEXT FIELD qcc01
                WHEN INFIELD(qcc011)
#                    CALL q_ecd(0,0,'') RETURNING g_qcc011
                     CALL q_ecd(FALSE,TRUE,g_qcc011) RETURNING g_qcc011
                     DISPLAY BY NAME g_qcc011
                     NEXT FIELD qcc011
                OTHERWISE EXIT CASE
            END CASE
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
    END INPUT
END FUNCTION
 
FUNCTION  i121_qcc01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima103        LIKE ima_file.ima103,
    l_imaacti       LIKE ima_file.imaacti          #資料有效碼
 
    LET g_errno = ' '
    SELECT ima02, ima021, ima103, imaacti
        INTO l_ima02, l_ima021, l_ima103, l_imaacti
        FROM ima_file
        WHERE ima01 = g_qcc01
    CASE WHEN STATUS=100          LET g_errno = 'mfg0002' #No.7926
              LET l_ima02 = NULL LET l_ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------         
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION  i121_qcc011(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
    l_ecd02         LIKE ecd_file.ecd02,
    l_ecdacti       LIKE ecd_file.ecdacti          #資料有效碼
 
    LET g_errno = ' '
    SELECT ecd02,ecdacti
        INTO l_ecd02, l_ecdacti
        FROM ecd_file
        WHERE ecd01 = g_qcc011
    CASE WHEN STATUS=100          LET g_errno = 'mfg0009' #No.7926
                                  LET l_ecd02 = NULL
         WHEN l_ecdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ecd02  TO FORMONLY.ecd02
    END IF
END FUNCTION

#Query 查詢
FUNCTION i121_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qcc01  TO NULL            #No.FUN-6A0160
    INITIALIZE g_qcc011 TO NULL            #No.FUN-6A0160
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i121_curs()                       #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_qcc01  TO NULL
        INITIALIZE g_qcc011 TO NULL
        RETURN
    END IF
    OPEN i121_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_qcc01 TO NULL
    ELSE
        CALL i121_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i121_count
        FETCH i121_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i121_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i121_b_curs INTO g_qcc01,g_qcc011
        WHEN 'P' FETCH PREVIOUS i121_b_curs INTO g_qcc01,g_qcc011
        WHEN 'F' FETCH FIRST    i121_b_curs INTO g_qcc01,g_qcc011
        WHEN 'L' FETCH LAST     i121_b_curs INTO g_qcc01,g_qcc011
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
            FETCH ABSOLUTE g_jump i121_b_curs INTO g_qcc01,g_qcc011
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_qcc01,SQLCA.sqlcode,0)
        INITIALIZE g_qcc01 TO NULL
    ELSE
       CALL i121_show()
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
FUNCTION i121_show()
    DISPLAY g_qcc01,g_qcc011 TO qcc01,qcc011               #單頭   
    CALL i121_qcc01('d')
    CALL i121_qcc011('d')
    CALL i121_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i121_r()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_qcc01) THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0160
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qcc01"       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "qcc011"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qcc01        #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_qcc011       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM qcc_file WHERE qcc01 = g_qcc01 AND qcc011 = g_qcc011
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("del","qcc_file",g_qcc01,g_qcc011,SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660115
        ELSE
            CLEAR FORM
            CALL g_qcc.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            DROP TABLE x
            PREPARE i121_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i121_precount_x2                 #No.TQC-720019
            OPEN i121_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i121_b_curs
               CLOSE i121_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i121_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i121_b_curs
               CLOSE i121_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i121_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i121_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL i121_fetch('/')
            END IF
        END IF
        LET g_msg=TIME
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i121_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用  #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態    #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,    #可新增否    #No.FUN-680104 VARCHAR(80)
    l_allow_insert  LIKE type_file.num5,       #可新增否    #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5        #可刪除否    #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qcc01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_qccmodu=g_user          #修改者96-06-18
    LET g_qccdate=g_today         #修改日期
 
    LET g_forupd_sql = " SELECT qcc02,'',qcc08,qcc03,qcc05,qcc04,qcc061,qcc062,qcc07,'' FROM qcc_file ",   #No.FUN-A80063   
                       "  WHERE qcc01  = ? AND qcc011 = ? AND qcc02  = ? ", #TQC-A60132
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i121_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qcc WITHOUT DEFAULTS FROM s_qcc.*
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
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_qcc_t.* = g_qcc[l_ac].*  #BACKUP
                BEGIN WORK
 
                OPEN i121_bcl USING g_qcc01,g_qcc011,g_qcc_t.qcc02
                IF STATUS THEN
                    CALL cl_err("OPEN i121_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i121_bcl INTO g_qcc[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_qcc_t.qcc02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        LET g_qcc_t.*=g_qcc[l_ac].*
                    END IF
                END IF
                CALL i121_qcc02('d')
                #No.TQC-AA0096  --Begin
                LET g_before_input_done = FALSE
                CALL i121_set_entry_b()
                CALL i121_set_no_entry_b()
                LET g_before_input_done = TRUE 
                #No.TQC-AA0096  --End  
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_qcc.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            INSERT INTO qcc_file(qcc01,qcc011,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062,
#                   qcc07,qccacti,qccuser,qccgrup,qccmodu,qccdate,qccoriu,qccorig)
#                  qcc07,qcc08,qccacti,qccuser,qccgrup,qccmodu,qccdate)                           #No.FUN-910079    #TQC-A60086 --mark
                    qcc07,qcc08,qccacti,qccuser,qccgrup,qccmodu,qccdate,qccoriu,qccorig)    #TQC-A60086  --modify  
            VALUES(g_qcc01,g_qcc011,g_qcc[l_ac].qcc02,
                   g_qcc[l_ac].qcc03,g_qcc[l_ac].qcc04,g_qcc[l_ac].qcc05,
                   g_qcc[l_ac].qcc061,g_qcc[l_ac].qcc062,g_qcc[l_ac].qcc07,
                   g_qcc[l_ac].qcc08,g_qccacti,g_qccuser,g_qccgrup,
#                   g_qccacti,g_qccuser,g_qccgrup,
                   g_qccmodu,g_qccdate, g_user, g_grup)                         #No.FUN-980030 10/01/04  insert columns oriu, orig 
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_qcc[l_ac].qcc02,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("ins","qcc_file",g_qcc01,g_qcc[l_ac].qcc02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcc[l_ac].* TO NULL      #900423
            LET g_qcc[l_ac].qcc07='N'
            LET g_qcc[l_ac].qcc08='9'             #No.FUN-910079
            LET g_qcc_t.* = g_qcc[l_ac].*         #新輸入資料
            #No.TQC-AA0096  --Begin
            LET g_before_input_done = FALSE
            CALL i121_set_entry_b()
            CALL i121_set_no_entry_b()
            LET g_before_input_done = TRUE
            #No.TQC-AA0096  --End  
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qcc02
 
        AFTER FIELD qcc02                        #check 序號是否重複
            IF NOT cl_null(g_qcc[l_ac].qcc02) THEN
               IF (g_qcc[l_ac].qcc02 != g_qcc_t.qcc02 OR
                   g_qcc_t.qcc02 IS NULL) THEN
                   SELECT count(*)
                       INTO l_n
                       FROM qcc_file
                       WHERE qcc01 = g_qcc01 AND
                             qcc011= g_qcc011 AND
                             qcc02 = g_qcc[l_ac].qcc02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_qcc[l_ac].qcc02 = g_qcc_t.qcc02
                       NEXT FIELD qcc02
                   ELSE
                       CALL i121_qcc02('a')
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_qcc[l_ac].qcc02,g_errno,0)
                           LET g_qcc[l_ac].qcc02 = g_qcc_t.qcc02      #no.5185
                           NEXT FIELD qcc02
                       END IF
                   END IF
               END IF
            END IF
 
          AFTER FIELD qcc03
            IF NOT cl_null(g_qcc[l_ac].qcc03) THEN
               IF g_qcc[l_ac].qcc03 NOT MATCHES'[123]' THEN
                   NEXT FIELD qcc03
               END IF
            END IF

         #No.FUN-A80063 --begin
         BEFORE FIELD qcc05
            #CALL cl_set_comp_entry('qcc04,qcc07',TRUE)  #No.TQC-AA0096
            CALL i121_set_entry_b()                      #No.TQC-AA0096
         #No.FUN-A80063 --end
 
        AFTER FIELD qcc05
            IF NOT cl_null(g_qcc[l_ac].qcc05) THEN
                IF g_qcc[l_ac].qcc05 NOT MATCHES "[1234]" THEN   #No.FUN-A80063
                   NEXT FIELD qcc05
                END IF
            END IF
            #No.TQC-AA0096  --Begin
            CALL i121_set_no_entry_b()
            ##No.FUN-A80063 --begin
            #IF g_qcc[l_ac].qcc05 <> g_qcc_t.qcc05 OR g_qcc_t.qcc05 IS NULL THEN 
            #   IF g_qcc[l_ac].qcc05 MATCHES '[34]' THEN 
            #      LET g_qcc[l_ac].qcc04 =NULL 
            #      CALL cl_set_comp_entry('qcc04',FALSE)
            #   END IF 
            #   IF g_qcc[l_ac].qcc05 ='4' THEN 
            #      LET g_qcc[l_ac].qcc07 ='Y'
            #      CALL cl_set_comp_entry('qcc07',FALSE)
            #   END IF 
            #END IF 
            LET g_qcc_t.qcc05 = g_qcc[l_ac].qcc05
            ##No.FUN-A80063 --end
            #No.TQC-AA0096  --End  

        AFTER FIELD qcc07
            IF NOT cl_null(g_qcc[l_ac].qcc07) THEN
                IF g_qcc[l_ac].qcc07 NOT MATCHES "[YN]" THEN
                   NEXT FIELD qcc07
                END IF
            END IF

#No.TQC-740144 ---Begin                                                                                                             
        AFTER FIELD qcc062                                                                                                          
            IF g_qcc[l_ac].qcc062<g_qcc[l_ac].qcc061 THEN                                                                           
               CALL cl_err('','aqc1000',0)                                                                                          
               NEXT FIELD qcc062                                                                                                    
            END IF                                                                                                                  
#No.TQC-740144 ---End
#No.FUN-A80063 --begin
            IF g_qcc[l_ac].qcc05 ='4' AND cl_null(g_qcc[l_ac].qcc061) AND cl_null(g_qcc[l_ac].qcc062) THEN 
               NEXT FIELD qcc062
            END IF 
#No.FUN-A80063 --end
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcc_t.qcc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM qcc_file
                    WHERE qcc01 = g_qcc01 AND
                          qcc011 = g_qcc011 AND
                          qcc02 = g_qcc_t.qcc02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_qcc_t.qcc02,SQLCA.sqlcode,0)   #No.FUN-660115
                    CALL cl_err3("del","qcc_file",g_qcc01,g_qcc_t.qcc02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b = g_rec_b - 1
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcc[l_ac].* = g_qcc_t.*
               CLOSE i121_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_qcc[l_ac].qcc02,-263,1)
                LET g_qcc[l_ac].* = g_qcc_t.*
            ELSE
                UPDATE qcc_file SET
                       qcc02=g_qcc[l_ac].qcc02,
                       qcc03=g_qcc[l_ac].qcc03,
                       qcc04=g_qcc[l_ac].qcc04,
                       qcc05=g_qcc[l_ac].qcc05,
                       qcc061=g_qcc[l_ac].qcc061,
                       qcc062=g_qcc[l_ac].qcc062,
                       qcc07=g_qcc[l_ac].qcc07,
                       qcc08=g_qcc[l_ac].qcc08,                #No.FUN-910079
                       qccmodu=g_qccmodu,
                       qccdate=g_qccdate
                 WHERE qcc01  = g_qcc01
                   AND qcc011 = g_qcc011
                   AND qcc02  = g_qcc_t.qcc02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_qcc[l_ac].qcc02,SQLCA.sqlcode,0)   #No.FUN-660115
                    CALL cl_err3("upd","qcc_file",g_qcc01,g_qcc_t.qcc02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                    LET g_qcc[l_ac].* = g_qcc_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcc[l_ac].* = g_qcc_t.*
               END IF
               CLOSE i121_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i121_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcc02)     #廠商編號
#                    CALL q_azf(4,3,g_qcc[l_ac].qcc02,'6') RETURNING g_qcc[l_ac].qcc02
#                    CALL FGL_DIALOG_SETBUFFER( g_qcc[l_ac].qcc02 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf"
                     LET g_qryparam.default1 = g_qcc[l_ac].qcc02
                     LET g_qryparam.arg1     = '6'
                     CALL cl_create_qry() RETURNING g_qcc[l_ac].qcc02
#                     CALL FGL_DIALOG_SETBUFFER( g_qcc[l_ac].qcc02 )
                     DISPLAY g_qcc[l_ac].qcc02 TO qcc02
                     NEXT FIELD qcc02
                OTHERWISE EXIT CASE
            END CASE
 
      # ON ACTION CONTROLN
      #     CALL i121_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qcc02) AND l_ac > 1 THEN
                LET g_qcc[l_ac].* = g_qcc[l_ac-1].*
                NEXT FIELD qcc02
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
 
    CLOSE i121_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i121_qcc02(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
           l_azf03      LIKE azf_file.azf03
 
    LET g_errno = ' '
    SELECT azf03
        INTO g_qcc[l_ac].azf03
        FROM azf_file
        WHERE azf01 = g_qcc[l_ac].qcc02
          AND azf02='6'
 
    CASE WHEN STATUS=100    LET g_errno = 'aqc-041' #No.7926
                            LET g_qcc[l_ac].azf03 = NULL
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i121_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc ON qcc02,qcc03,qcc04,qcc05,qcc061,qcc062,qcc07
                 FROM s_qcc[1].qcc02,s_qcc[1].qcc03,s_qcc[1].qcc05,                                  #No.FUN-A80063
                      s_qcc[1].qcc04,s_qcc[1].qcc061,s_qcc[1].qcc062,s_qcc[1].qcc07
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
    CALL i121_b_fill(l_wc)
END FUNCTION
 
FUNCTION i121_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
#       "SELECT qcc02,azf03,qcc03,qcc04,qcc05,qcc061,qcc062,qcc07 ",
       "SELECT qcc02,azf03,qcc08,qcc03,qcc05,qcc04,qcc061,qcc062,qcc07 ",    #No.FUN-910079   #No.FUN-A80063  
       " FROM qcc_file LEFT OUTER JOIN azf_file ON qcc_file.qcc02 = azf_file.azf01 AND azf_file.azf02='6'",
       " WHERE qcc01 = '",g_qcc01,"'",
       "   AND qcc011= '",g_qcc011,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i121_prepare2 FROM g_sql      #預備一下
    DECLARE qcc_curs CURSOR FOR i121_prepare2
    CALL g_qcc.clear()
    LET g_cnt = 1
    FOREACH qcc_curs INTO g_qcc[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_qcc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i121_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcc TO s_qcc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i121_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i121_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i121_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i121_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i121_fetch('L')
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
             LET INT_FLAG=FALSE                 #MOD-570244mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i121_copy()
DEFINE l_newno,l_oldno1  LIKE qcc_file.qcc01,
       l_newno2,l_oldno2 LIKE qcc_file.qcc011,
       l_n           LIKE type_file.num5,          #No.FUN-680104 SMALLINT
       l_ecd02       LIKE ecd_file.ecd02,
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qcc01 IS NULL
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
#bugno:5994 add....................................................
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       MESSAGE g_msg
    ELSE
       DISPLAY '' AT 1,1
       CALL cl_getmsg('mfg3161',g_lang) RETURNING g_msg
       DISPLAY g_msg AT 2,1
    END IF
#bugno:5994 end....................................................
    DISPLAY ' ' TO qcc01
    DISPLAY ' ' TO qcc011
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno,l_newno2 FROM qcc01,qcc011
        AFTER FIELD qcc01
#           IF NOT cl_null(l_newno) THEN                    #No.FUN-990071
            IF NOT cl_null(l_newno) AND l_newno<>'*' THEN   #No.FUN-990071
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(l_newno,"") THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD qcc01
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
                 WHERE ima01 = l_newno
                   AND imaacti = 'Y'
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('','mfg0002',0)   #No.FUN-660115
                    CALL cl_err3("sel","ima_file",l_newno,"","mfg0002","","",1)  #No.FUN-660115
                    NEXT FIELD qcc01              #No.TQC-950130
                ELSE
                    DISPLAY l_ima02 TO FORMONLY.ima02
                    DISPLAY l_ima021 TO FORMONLY.ima021
                END IF
            END IF
 
         AFTER FIELD qcc011
            IF NOT cl_null(l_newno2) THEN
                SELECT count(*) INTO l_n
                  FROM qcc_file
                 WHERE qcc01 = l_newno
                   AND qcc011= l_newno2
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   NEXT FIELD qcc01
                END IF
                SELECT ecd02 INTO l_ecd02 FROM ecd_file
                 WHERE ecd01 = l_newno2
                IF STATUS THEN
#                   CALL cl_err('','mfg4009',0)   #No.FUN-660115
                    CALL cl_err3("sel","ecd_file",l_newno2,"","mfg4009","","",1)  #No.FUN-660115
                    NEXT FIELD qcc011             #No.TQC-950130
                ELSE
                    DISPLAY l_ecd02 TO FORMONLY.ecd02
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(qcc01)
#                    CALL q_ima(0,0,'') RETURNING l_newno
#                    CALL FGL_DIALOG_SETBUFFER( l_newno )
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = ''        #No.TQC-950129
#                    LET g_qryparam.default1 = l_newno   #No.TQC-950129
#                    CALL cl_create_qry() RETURNING l_newno
                     CALL q_sel_ima(FALSE, "q_ima","",l_newno,"","","","","",'' ) 
                      RETURNING l_newno  
#FUN-AA0059---------mod------------end-----------------
#                     CALL FGL_DIALOG_SETBUFFER( l_newno )
                     DISPLAY l_newno TO qcc01
                     NEXT FIELD qcc01
 
                WHEN INFIELD(qcc011)
                      #-----No.MOD-580372-----
#                  # CALL q_ecd(0,0,'') RETURNING l_newno2
#                  # CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                   # CALL cl_init_qry_var()
                   # LET g_qryparam.form = "q_ecd"
                   # LET g_qryparam.default1 = ''
                   # CALL cl_create_qry() RETURNING l_newno2
#                  #  CALL FGL_DIALOG_SETBUFFER( l_newno2 )
 
                     CALL q_ecd(FALSE,TRUE,g_qcc011) RETURNING l_newno2
                     DISPLAY l_newno2 TO qcc011
                     NEXT FIELD qcc011
                      #-----No.MOD-580372 END-----
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY  g_qcc01 TO qcc01
            DISPLAY  g_qcc011 TO qcc011
            RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM qcc_file         #單身複製
        WHERE qcc01 = g_qcc01
          AND qcc011= g_qcc011
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_qcc01,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","x",g_qcc01,g_qcc011,SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    UPDATE x
        SET qcc01 = l_newno,
            qcc011= l_newno2
    INSERT INTO qcc_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","qcc_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno1= g_qcc01
     LET l_oldno2= g_qcc011
     LET g_qcc01 = l_newno
     LET g_qcc011= l_newno2
     CALL i121_b()
     #LET g_qcc01 =l_oldno1  #FUN-C80046
     #LET g_qcc011=l_oldno2  #FUN-C80046
     #CALL i121_show()       #FUN-C80046
END FUNCTION
#Patch....NO.TQC-610036 <001> #

#No.TQC-AA0096  --Begin
FUNCTION i121_set_entry_b()

   IF NOT g_before_input_done OR INFIELD(qcc05) THEN
      CALL cl_set_comp_entry("qcc04,qcc07",TRUE)
   END IF

END FUNCTION

FUNCTION i121_set_no_entry_b()

   IF NOT g_before_input_done OR INFIELD(qcc05) THEN
      IF g_qcc[l_ac].qcc05 MATCHES '[34]' THEN 
         LET g_qcc[l_ac].qcc04 =NULL 
         CALL cl_set_comp_entry('qcc04',FALSE)
      END IF 
      IF g_qcc[l_ac].qcc05 ='4' THEN 
         LET g_qcc[l_ac].qcc07 ='Y'
         CALL cl_set_comp_entry('qcc07',FALSE)
      END IF 
   END IF

END FUNCTION
#No.TQC-AA0096  --End  
