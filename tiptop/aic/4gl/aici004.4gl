# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aici004.4gl
# Descriptions...: ICD料件光罩群組維護作業 
# Date & Author..: No.FUN-7B0014 07/11/07 By bnlent  
# Modify.........: No.FUN-840031 08/04/08 By bnlent 1、移除單頭修改功能 2、Construct順序改變
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.CHI-920030 09/02/09 By jan 修改 工藝編號(ice03)的開窗
# Modify.........: No.FUN-920114 09/02/18 by ve007 參數字段傳錯
# Modify.........: No.CHI-950024 09/06/05 by jan 1.預設單身資料時，應先檢查若單身有資料則不做預設資料塞入動作
# ...............................................2.default時的檢查條件應該排除 ice03 (目前已不為key值)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No:TQC-9B0158 09/11/19 By sherry 修正新增時未帶出單身的問題
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/19 By velaxu ima26x 調整
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BC0106 12/02/04 by jason 新增s_aic_auto_no參數
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No:FUN-C30278 12/03/28 By bart 判斷imaicd05改為判斷imaicd04
# Modify.........: No.TQC-C40132 12/04/16 By xianghui 點退出時不需要再控管AFTER INPUT 裏面的
# Modify.........: No.TQC-C40266 12/05/07 By fengrui copy()函數中添加ice02、ice03控管與開窗
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ice01           LIKE ice_file.ice01,   # 類別代號 (假單頭)
         g_ice01_t         LIKE ice_file.ice01,   # 類別代號 (假單頭)
         g_ice02           LIKE ice_file.ice02,   # 類別代號 (假單頭)
         g_ice02_t         LIKE ice_file.ice02,   # 類別代號 (假單頭)
         g_ice02_desc      LIKE ima_file.ima02,   # 類別代號 (假單頭)
         g_ice03           LIKE ice_file.ice03,    
         g_ice03_t         LIKE ice_file.ice03,    
         g_ice13           LIKE ice_file.ice13,   # 類別代號 (假單頭)
         g_ice13_t         LIKE ice_file.ice13,   # 類別代號 (假單頭)
         g_ice14           LIKE ice_file.ice14,    
         g_ice14_t         LIKE ice_file.ice14,    
         g_ice_lock RECORD LIKE ice_file.*,       # FOR LOCK CURSOR TOUCH
         g_ice      DYNAMIC ARRAY of RECORD       # 程式變數
            ice04          LIKE ice_file.ice04,
            ice05          LIKE ice_file.ice05,
            ice06          LIKE ice_file.ice06,
            ice07          LIKE ice_file.ice07,
            ice08          LIKE ice_file.ice08,
            ice15          LIKE ice_file.ice15,
            ice16          LIKE ice_file.ice16
                      END RECORD,
         g_ice_t           RECORD                 # 變數舊值
            ice04          LIKE ice_file.ice04,
            ice05          LIKE ice_file.ice05,
            ice06          LIKE ice_file.ice06,
            ice07          LIKE ice_file.ice07,
            ice08          LIKE ice_file.ice08,
            ice15          LIKE ice_file.ice15,
            ice16          LIKE ice_file.ice16
                      END RECORD,
         g_cnt2                LIKE type_file.num5, 
         g_wc                  string,  
         g_sql                 string,  
         g_rec_b               LIKE type_file.num5,    # 單身筆數    
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT 
DEFINE   g_chr                 LIKE type_file.chr1     
DEFINE   g_cnt                 LIKE type_file.num10   
DEFINE   g_msg                 LIKE type_file.chr1000  
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     
DEFINE   g_argv1               LIKE ice_file.ice01
DEFINE   g_argv2               LIKE ice_file.ice02
DEFINE   g_curs_index          LIKE type_file.num10    
DEFINE   g_row_count           LIKE type_file.num10    
DEFINE   g_jump                LIKE type_file.num10    
DEFINE   mi_no_ask             LIKE type_file.num5     
DEFINE   g_std_id              LIKE smb_file.smb01    
DEFINE   g_db_type             LIKE type_file.chr3   
DEFINE   l_ima571              LIKE ima_file.ima571
 
 
MAIN
   DEFINE   p_row,p_col    LIKE type_file.num5     
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) 
         RETURNING g_time   
 
   LET g_ice01_t = NULL
   LET g_ice02_t = NULL
   LET g_ice03_t = NULL
   LET g_ice14_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW i004_w AT p_row,p_col WITH FORM "aic/42f/aici004"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
 
   LET g_forupd_sql = "SELECT * from ice_file ",
                      "  WHERE ice01 = ? AND ice02= ? ",
                      " AND  ice14 = ?",  
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i004_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL i004_q()
   END IF
 
   CALL i004_menu() 
 
   CLOSE WINDOW i004_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)          # 計算使用時間 (退出時間) 
         RETURNING g_time    
END MAIN
 
FUNCTION i004_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_ice.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "ice01 = '",g_argv1 CLIPPED,"' "           #No.FUN-920114
   ELSE
      CALL cl_set_head_visible("","YES")   
      CONSTRUCT g_wc ON ice01,ice03,ice13,ice02,ice14,      #No.FUN-840031
                        ice04,ice05,ice06,ice07,ice08,ice15,ice16  
                   FROM ice01,ice03,ice13,ice02,ice14,      #No.FUN-840031
                        s_ice[1].ice04,s_ice[1].ice05,
                        s_ice[1].ice06,s_ice[1].ice07,
                        s_ice[1].ice08,s_ice[1].ice15,
                        s_ice[1].ice16
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ice02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imaicd1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ice02
                  NEXT FIELD ice02
               WHEN INFIELD(ice03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_icu"   #CHI-920030
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ice03
                  NEXT FIELD ice03
               WHEN INFIELD(ice05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecb07"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_ice03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ice05
                  NEXT FIELD ice05
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE ice01,ice02,ice14,ice03,ice13 FROM ice_file ",   
              " WHERE ", g_wc CLIPPED,
              " GROUP BY ice01,ice02,ice14,ice03,ice13 ORDER BY ice01"       
   PREPARE i004_prepare FROM g_sql          # 預備一下
   DECLARE i004_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR i004_prepare
   LET g_sql="SELECT UNIQUE ice01,ice02,ice14,ice03,ice13 FROM ice_file WHERE ",g_wc CLIPPED, "INTO TEMP x "
   DROP TABLE x 
   PREPARE i004_precount_x FROM g_sql
   EXECUTE i004_precount_x
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i004_precount FROM g_sql 
   DECLARE i004_count   CURSOR FOR i004_precount
 
END FUNCTION
 
FUNCTION i004_menu()
 
   WHILE TRUE
      CALL i004_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i004_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i004_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF
         WHEN "bodymask"                        # body mask料號 
            IF cl_chk_act_auth() THEN
               CALL i004_bodymask()
            END IF
         WHEN "layermask"                        # body mask料號 
            IF cl_chk_act_auth() THEN
               CALL i004_layermask()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "aici004" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ice),'','')
            END IF
         WHEN "related_document" #相關文件
            IF cl_chk_act_auth() THEN
               IF g_ice01 IS NOT NULL THEN
                  LET g_doc.column1 = "ice01 "
                  LET g_doc.column2 = "ice02 "
                  LET g_doc.column3 = "ice03 "
                  LET g_doc.column4 = "ice13 "
                  LET g_doc.column5 = "ice14 "
                  LET g_doc.value1 = g_ice01
                  LET g_doc.value2 = g_ice02
                  LET g_doc.value3 = g_ice03
                  LET g_doc.value4 = g_ice13
                  LET g_doc.value5 = g_ice14
                  CALL cl_doc()
               END IF
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i004_a()                            # Add  輸入
DEFINE l_n   LIKE type_file.num5    #CHI-950024
 
   MESSAGE ""
   CLEAR FORM
   CALL g_ice.clear()
 
   INITIALIZE g_ice01 LIKE ice_file.ice01         # 預設值及將數值類變數清成零
   INITIALIZE g_ice02 LIKE ice_file.ice02         # 預設值及將數值類變數清成零
   INITIALIZE g_ice02_desc LIKE ima_file.ima02  
   INITIALIZE g_ice03 LIKE ice_file.ice03      
   INITIALIZE g_ice14 LIKE ice_file.ice14
   INITIALIZE g_ice02_t LIKE ice_file.ice02       #TQC-C40266 add
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i004_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_ice01=NULL
         LET g_ice02=NULL
         LET g_ice02_desc=NULL
         LET g_ice03=NULL
         LET g_ice13=NULL
         LET g_ice14=NULL
         DISPLAY g_ice01 TO ice01
         DISPLAY g_ice02 TO ice02
         DISPLAY g_ice03 TO ice03
         DISPLAY g_ice13 TO ice13
         DISPLAY g_ice14 TO ice14
         DISPLAY g_ice02_desc TO FORMONLY.ice02_desc
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
     
      LET l_n = 0
      SELECT count(*) INTO l_n FROM ice_file
       WHERE ice01 = g_ice01
         AND ice02 = g_ice02
         AND ice14 = g_ice14
         AND ice04 > 0
      IF l_n <= 0 THEN
         IF NOT cl_null(g_ice03) THEN
            LET g_rec_b = 0   #CHI-950024
            CALL i004_g_b()
         END IF
      END IF #CHI-950024
      
      CALL i004_b_fill(g_wc)
      CALL i004_b()                          # 輸入單身
      LET g_ice01_t=g_ice01
      LET g_ice02_t=g_ice02
      LET g_ice03_t=g_ice03
      LET g_ice14_t=g_ice14
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i004_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改 
   DEFINE   l_count      LIKE type_file.num5   
   DEFINE   l_ice02      LIKE ice_file.ice02    
 
 
   LET g_ice13 = NULL
   DISPLAY g_ice01,g_ice02,g_ice02_desc,g_ice03,g_ice14,g_ice13 
        TO ice01,ice02,ice02_desc,ice03,ice14,ice13    
   CALL cl_set_head_visible("","YES")   
   INPUT g_ice01,g_ice02,g_ice03,g_ice14,g_ice13 WITHOUT DEFAULTS FROM ice01,ice02,ice03,ice14,ice13 
      AFTER FIELD ice02
         IF NOT cl_null(g_ice02) THEN
           #FUN-AA0059 -----------------add start-------------
            IF NOT s_chk_item_no(g_ice02,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ice02
            END IF 
           #FUN-AA0059 ------------------add end---------- 
            SELECT COUNT(*)
              INTO l_count
              FROM imaicd_file
             WHERE imaicd00 = g_ice02
              #AND imaicd05 = '1'  #FUN-C30278
              #AND imaicd04='0' OR imaicd04='1'  #FUN-C30278  #TQC-C40132
               AND (imaicd04='0' OR imaicd04='1')  #TQC-C40132
            IF l_count = 0 THEN
               CALL cl_err('','mfg3006',0)
               NEXT FIELD ice02
            END IF
            CALL i004_ice02_desc(p_cmd,g_ice02)  #TQC-C40266
            #TQC-C40132-add-str--
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ice02,g_errno,0)
               NEXT FIELD ice02
            END IF
            #TQC-C40132-add-end--
         ELSE                    #CHI-920030
            NEXT FIELD ice02     #CHI-920030
         END IF
         #TQC-C40266--add--str--
         IF cl_null(g_ice02_t) OR g_ice02_t != g_ice02 THEN
            LET g_ice03 = NULL
            DISPLAY g_ice03 TO ice03  
         END IF
         LET g_ice02_t = g_ice02
         #TQC-C40266--add--end--

      BEFORE FIELD ice03
        IF cl_null(g_ice02) THEN
           NEXT FIELD ice02
        END IF
 
      AFTER FIELD ice03
         IF NOT cl_null(g_ice03) THEN
           SELECT COUNT(*) INTO l_count
             FROM icu_file
            WHERE icu01=g_ice02
              AND icu02=g_ice03
           IF l_count = 0 THEN                                                                                                     
               CALL cl_err('','mfg4030',0)                                                                                          
               NEXT FIELD ice03                                                                                                     
           END IF 
         END IF     
      AFTER INPUT
         #TQC-C40132-add-str--
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #TQC-C40132-add-end--
         IF NOT cl_null(g_ice01) THEN
            IF g_ice01 != g_ice01_t OR cl_null(g_ice01_t) THEN
               LET g_cnt = 0    #TQC-C40132
               SELECT COUNT(UNIQUE ice01) INTO g_cnt FROM ice_file
                WHERE ice01 = g_ice01 AND ice02 = g_ice02 AND ice03 = g_ice03   
                  AND ice14 = g_ice14 AND ice13 = g_ice13
               #TQC-C40132--mod--str--
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err(g_ice01,g_errno,0)
               #   NEXT FIELD ice01
               #END IF
               IF g_cnt > 0 THEN 
                  CALL cl_err(g_ice01,-239,0)
                  NEXT FIELD ice01
               END IF
               #TQC-C40132--mod--end--
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ice02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imaicd1"
               LET g_qryparam.default1= g_ice02
               CALL cl_create_qry() RETURNING g_ice02  
               DISPLAY g_ice02 TO ice02  #TQC-C40266 add
               NEXT FIELD ice02
            WHEN INFIELD(ice03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_icu"  #CHI-920030
               LET g_qryparam.arg1 = g_ice02 
               LET g_qryparam.default1= g_ice03
               CALL cl_create_qry() RETURNING g_ice03
               #DISPLAY BY NAME g_ice03  #TQC-C40266 mark
               DISPLAY g_ice03 TO ice03  #TQC-C40266 add
               NEXT FIELD ice03
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
   END INPUT
END FUNCTION
 
FUNCTION i004_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
  
   CLEAR FORM  
   CALL g_ice.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i004_curs()                         #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i004_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                    #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_ice01 TO NULL
      INITIALIZE g_ice02_desc TO NULL
      INITIALIZE g_ice02 TO NULL
      INITIALIZE g_ice03 TO NULL                 
      INITIALIZE g_ice14 TO NULL                 
   ELSE
      OPEN i004_count                     #CHI-950024
      FETCH i004_count INTO g_row_count   #CHI-950024
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i004_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i004_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     
            l_abso   LIKE type_file.num10         #絕對的筆數   
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i004_b_curs INTO g_ice01,g_ice02,g_ice14,g_ice03,g_ice13   
      WHEN 'P' FETCH PREVIOUS i004_b_curs INTO g_ice01,g_ice02,g_ice14,g_ice03,g_ice13
      WHEN 'F' FETCH FIRST    i004_b_curs INTO g_ice01,g_ice02,g_ice14,g_ice03,g_ice13
      WHEN 'L' FETCH LAST     i004_b_curs INTO g_ice01,g_ice02,g_ice14,g_ice03,g_ice13
      WHEN '/' 
         IF (NOT mi_no_ask) THEN          
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i004_b_curs INTO g_ice01,g_ice02,g_ice14,g_ice03,g_ice13
         LET mi_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ice01,SQLCA.sqlcode,0)
      INITIALIZE g_ice01 TO NULL  
      INITIALIZE g_ice02 TO NULL  
      INITIALIZE g_ice03 TO NULL  
      INITIALIZE g_ice14 TO NULL  
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump         
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL i004_show()
   END IF
END FUNCTION
 
 
FUNCTION i004_show()                         # 將資料顯示在畫面上
   CALL i004_ice02_desc('d',g_ice02)     #TQC-C40266
   DISPLAY g_ice01,g_ice02,g_ice02_desc,g_ice03,g_ice14,g_ice13 
        TO ice01,ice02,ice02_desc,ice03,ice14,ice13  
   CALL i004_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION i004_ice02_desc(p_cmd,p_ice02)  #TQC-C40266
DEFINE p_cmd     LIKE type_file.chr1    
DEFINE p_ice02   LIKE ice_file.ice02     #TQC-C40266 add
DEFINE l_imaacti LIKE ima_file.imaacti

   LET g_errno = " "
   SELECT ima02,imaacti INTO g_ice02_desc,l_imaacti  
     FROM ima_file,imaicd_file
   # WHERE ima01 = g_ice02               #TQC-C40266   
    WHERE ima01 = p_ice02                #TQC-C40266
      AND imaicd00 = ima01
      #AND imaicd05 = '1'   #FUN-C30278
      #AND imaicd04='0' OR imaicd04='1'  #FUN-C30278  #TQC-C40132 mark
      AND (imaicd04='0' OR imaicd04='1')  #TQC-C40132  
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET g_ice02_desc = NULL
        WHEN l_imaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_ice02_desc TO FORMONLY.ice02_desc
   END IF
 
END FUNCTION
 
 
 
FUNCTION i004_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_ice   RECORD LIKE ice_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ice01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ice01 "      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "ice02 "      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "ice03 "      #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "ice13 "      #No.FUN-9B0098 10/02/24
       LET g_doc.column5 = "ice14 "      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ice01        #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_ice02        #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_ice03        #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_ice13        #No.FUN-9B0098 10/02/24
       LET g_doc.value5 = g_ice14        #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM ice_file
       WHERE ice01 = g_ice01 
         AND ice02 = g_ice02 
         AND ice14 = g_ice14  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ice_file",g_ice01,g_ice14,SQLCA.sqlcode,"","BODY DELETE",0)   
      ELSE
         CLEAR FORM
         CALL g_ice.clear()
         OPEN i004_count      #CHI-950024
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i004_b_curs
             CLOSE i004_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i004_count INTO g_row_count #CHI-950024
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i004_b_curs
             CLOSE i004_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         IF g_row_count > 1 THEN
            LET g_row_count = g_row_count -1 
         ELSE
            LET g_row_count = 0 
         END IF 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i004_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i004_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE           
            CALL i004_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION i004_b()           # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,               # 檢查重複用        
            l_gau01         LIKE type_file.num5,               # 檢查重複用        
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        
            p_cmd           LIKE type_file.chr1,               # 處理狀態          
            l_allow_insert  LIKE type_file.num5,               
            l_allow_delete  LIKE type_file.num5                
   DEFINE   l_count         LIKE type_file.num5                
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ice01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
 
   LET g_forupd_sql= "SELECT ice04,ice05,ice06,ice07,ice08,ice15,ice16",
                     "  FROM ice_file",
                     "  WHERE ice01 = ? AND ice02 = ? ",
                       " AND ice14 = ? AND ice04= ?",    
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ice WITHOUT DEFAULTS FROM s_ice.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
         
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ice_t.* = g_ice[l_ac].*    #BACKUP
            OPEN i004_bcl USING g_ice01,g_ice02,g_ice14,g_ice_t.ice04  
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i004_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i004_bcl INTO g_ice[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i004_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ice[l_ac].* TO NULL       
         LET g_ice_t.* = g_ice[l_ac].*          #新輸入資料
         LET g_ice[l_ac].ice07 = 'N' 
         LET g_ice[l_ac].ice08 = 'N' 
         CALL cl_show_fld_cont()     
         NEXT FIELD ice04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO ice_file(ice01,ice02,ice03,ice04,ice05,ice06,ice07,ice08,ice14,ice15,ice16) 
                      VALUES (g_ice01,g_ice02,g_ice03,
                              g_ice[l_ac].ice04,g_ice[l_ac].ice05,
                              g_ice[l_ac].ice06,g_ice[l_ac].ice07,
                              g_ice[l_ac].ice08,g_ice14,
                              g_ice[l_ac].ice15,g_ice[l_ac].ice16)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ice_file",g_ice01,g_ice[l_ac].ice04,SQLCA.sqlcode,"","",0)   
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD ice04
         CALL cl_set_comp_entry("ice04",TRUE)
         IF g_ice[l_ac].ice04 IS NULL OR g_ice[l_ac].ice04 = 0 THEN
            SELECT MAX(ice04)+1 INTO g_ice[l_ac].ice04
              FROM ice_file
             WHERE ice01 = g_ice01
               AND ice02 = g_ice02
               AND ice14 = g_ice14
             IF g_ice[l_ac].ice04 IS NULL THEN
                LET g_ice[l_ac].ice04 = 1
             END IF
         END IF
      AFTER FIELD ice04
         IF NOT cl_null(g_ice[l_ac].ice04) THEN
            IF g_ice[l_ac].ice04 != g_ice_t.ice04
               OR g_ice_t.ice04 IS NULL THEN
               SELECT COUNT(*)
                 INTO l_n
                 FROM ice_file
                WHERE ice01 = g_ice01
                  AND ice02 = g_ice02
                  AND ice14 = g_ice14 
                  AND ice04 = g_ice[l_ac].ice04
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_ice[l_ac].ice04 = g_ice_t.ice04
                   NEXT FIELD ice04
                END IF
             END IF
          END IF
          IF p_cmd <> 'a' THEN   # 新增時, 准, 修改, 不准
             CALL cl_set_comp_entry("ice04",FALSE)
          END IF
 
      AFTER FIELD ice05
         IF NOT cl_null(g_ice[l_ac].ice05) THEN
               SELECT COUNT(*) INTO l_n FROM ecb_file
                WHERE ecb02 = g_ice03
                  AND ecb06 = g_ice[l_ac].ice05
               IF l_n = 0 THEN
                  CALL cl_err(g_ice[l_ac].ice05,'mfg4009',0)
                  LET g_ice[l_ac].ice05 = g_ice_t.ice05
                  NEXT FIELD ice05
               END IF
         END IF
 
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ice_t.ice04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err(g_ice[l_ac].ice04,"aic-082",1)
            END IF
            DELETE FROM ice_file WHERE ice01 = g_ice01
                                   AND ice02 = g_ice02
                                  #AND ice03 = g_ice03 #CHI-950024
                                   AND ice14 = g_ice14
                                   AND ice04 = g_ice_t.ice04             
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ice_file",g_ice01,g_ice_t.ice04,SQLCA.sqlcode,"","",0)   
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ice[l_ac].* = g_ice_t.*
            CLOSE i004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("g_ice[l_ac].ice04","aic-083",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ice[l_ac].ice04,-263,1)
            LET g_ice[l_ac].* = g_ice_t.*
         ELSE
            UPDATE ice_file
               SET ice04 = g_ice[l_ac].ice04,
                   ice05 = g_ice[l_ac].ice05,
                   ice06 = g_ice[l_ac].ice06,
                   ice07 = g_ice[l_ac].ice07,
                   ice08 = g_ice[l_ac].ice08,
                   ice15 = g_ice[l_ac].ice15,
                   ice16 = g_ice[l_ac].ice16
             WHERE ice01 = g_ice01
               AND ice04 = g_ice_t.ice04
               AND ice02 = g_ice02
               AND ice14 = g_ice14
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ice_file",g_ice01,g_ice_t.ice04,SQLCA.sqlcode,"","",0)   
               LET g_ice[l_ac].* = g_ice_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac#FUN-D40030 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ice[l_ac].* = g_ice_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_ice.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i004_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030 add
         CLOSE i004_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(ice04) AND l_ac > 1 THEN
            LET g_ice[l_ac].* = g_ice[l_ac-1].*
            NEXT FIELD ice04
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ice05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ecb07"
               LET g_qryparam.arg1 = g_ice03 
               LET g_qryparam.default1= g_ice[l_ac].ice05
               CALL cl_create_qry() RETURNING g_ice[l_ac].ice05
               DISPLAY BY NAME g_ice[l_ac].ice05 
               NEXT FIELD ice05 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END INPUT
 
   CLOSE i004_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i004_b_fill(p_wc)               
   DEFINE  p_wc        STRING     #NO.FUN-910082
   DEFINE p_ac         LIKE type_file.num5    
 
    IF cl_null(p_wc) THEN
       LET p_wc = "1=1"
    END IF
    LET g_sql = "SELECT ice04,ice05,ice06,ice07,ice08,ice15,ice16 ",
                 " FROM ice_file ",
                " WHERE ice01 = '",g_ice01 CLIPPED,"' ",
                  " AND ice02 = '",g_ice02 CLIPPED,"' ",
                  " AND ice14 = '",g_ice14 CLIPPED,"' ",   
                  " AND ",p_wc CLIPPED,
                " ORDER BY ice04"
 
    PREPARE i004_prepare2 FROM g_sql           #預備一下
    DECLARE ice_curs CURSOR FOR i004_prepare2
 
    CALL g_ice.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ice_curs INTO g_ice[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ice.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ice TO s_ice.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION bodymask                    
         LET g_action_choice='bodymask'
         EXIT DISPLAY
 
      ON ACTION layermask                    
         LET g_action_choice='layermask'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice='delete'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL i004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   #
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous                         # P.上筆
         CALL i004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION jump                             # 指定筆
         CALL i004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION next                             # N.下筆
         CALL i004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION last                             # 最終筆
         CALL i004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   
      ON ACTION related_document
         LET g_action_choice = "related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i004_copy()
   DEFINE   l_n       LIKE type_file.num5,          
            l_new01   LIKE ice_file.ice01,
            l_new02   LIKE ice_file.ice02,
            l_new03   LIKE ice_file.ice03,          
            l_new14   LIKE ice_file.ice14,          
            l_old01   LIKE ice_file.ice01,
            l_old02   LIKE ice_file.ice02,
            l_old03   LIKE ice_file.ice03,
            l_old14   LIKE ice_file.ice14,
            l_count   LIKE type_file.num5,       #TQC-C40266 
            l_new02_t LIKE ice_file.ice02        #TQC-C40266
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_ice01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   
   INPUT l_new01,l_new02,l_new03,l_new14 WITHOUT DEFAULTS FROM ice01,ice02,ice03,ice14   
   
      #TQC-C40266--add--str--
      AFTER FIELD ice02
         IF NOT cl_null(l_new02) THEN
            IF NOT s_chk_item_no(l_new02,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ice02
            END IF 
            SELECT COUNT(*)
              INTO l_count
              FROM imaicd_file
             WHERE imaicd00 = l_new02
               AND (imaicd04='0' OR imaicd04='1') 
            IF l_count = 0 THEN
               CALL cl_err('','mfg3006',0)
               NEXT FIELD ice02
            END IF
            CALL i004_ice02_desc('',l_new02)  
 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_new02,g_errno,0)
               NEXT FIELD ice02
            END IF
         ELSE                    
            NEXT FIELD ice02     
         END IF
         IF cl_null(l_new02_t) OR l_new02_t != l_new02 THEN
            LET l_new03 = NULL
            DISPLAY l_new03 TO ice03  
         END IF
         LET l_new02_t = l_new02
         
      BEFORE FIELD ice03
        IF cl_null(l_new02) THEN
           NEXT FIELD ice02
        END IF
 
      AFTER FIELD ice03
         IF NOT cl_null(l_new03) THEN
           SELECT COUNT(*) INTO l_count
             FROM icu_file
            WHERE icu01=l_new02
              AND icu02=l_new03
           IF l_count = 0 THEN                                                                                                     
               CALL cl_err('','mfg4030',0)                                                                                          
               NEXT FIELD ice03                                                                                                     
           END IF 
         END IF     
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ice02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imaicd1"
               LET g_qryparam.default1= l_new02
               CALL cl_create_qry() RETURNING l_new02  
               DISPLAY l_new02 TO ice02
               NEXT FIELD ice02
            WHEN INFIELD(ice03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_icu"  
               LET g_qryparam.arg1 = l_new02 
               LET g_qryparam.default1= l_new03
               CALL cl_create_qry() RETURNING l_new03
               DISPLAY l_new03 TO ice03
               NEXT FIELD ice03
            OTHERWISE 
               EXIT CASE
         END CASE
      #TQC-C40266--add--end--

 
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(l_new01) THEN
            NEXT FIELD ice01
         END IF
         LET g_cnt = 0         #TQC-C40266 add
         SELECT COUNT(*) INTO g_cnt FROM ice_file
           WHERE ice01 = l_new01 AND ice02 = l_new02 
            AND ice14 = l_new14                       #CHI-950024   
         IF g_cnt > 0 THEN
            CALL cl_err(l_new01,-239,0)
            NEXT FIELD ice01   #TQC-C40266 add
         END IF
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ice01,g_ice02,g_ice02_desc,g_ice03,g_ice14 TO ice01,ice02,ice02_desc,ice03,ice14   
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ice_file 
     WHERE ice01=g_ice01 and ice02=g_ice02 AND ice14=g_ice14 and ice04 NOT IN   #CHI-950024   
     (SELECT ice04 FROM ice_file WHERE ice01=l_new01 and ice02=l_new02 and ice14=l_new14)   #CHI-950024   
   INTO TEMP x
 
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_ice01,g_ice02,SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
 
   UPDATE x
      SET ice01 = l_new01,                        # 資料鍵值
          ice02 = l_new02,                        # 資料鍵值
          ice03 = l_new03,                        
          ice14 = l_new14  
 
   INSERT INTO ice_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","ice_file",l_new01,l_new02,SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_ice01
   LET l_old02 = g_ice02
   LET l_old03 = g_ice03   
   LET l_old14 = g_ice14   
   LET g_ice01 = l_new01
   LET g_ice02 = l_new02
   LET g_ice03 = l_new03
   LET g_ice14 = l_new14   
   CALL i004_b()
   #FUN-C30027---begin
   #LET g_ice01 = l_old01
   #LET g_ice02 = l_old02
   #LET g_ice03 = l_old03
   #LET g_ice14 = l_old14   
   #CALL i004_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION i004_g_b()
DEFINE l_ecb06 LIKE ecb_file.ecb06
DEFINE l_ice04 LIKE ice_file.ice04
    BEGIN WORK
 
    LET g_sql = "SELECT ecb06 ",
                " FROM ecb_file ",
                " WHERE ecb01 = '",g_ice02 CLIPPED,"' ",
                " AND ecb02 = '",g_ice03 CLIPPED,"' ",
                " ORDER BY ecb03"
    PREPARE i004_g_b FROM g_sql           #預備一下
    DECLARE i004_g_b_curs CURSOR FOR i004_g_b
    FOREACH i004_g_b_curs INTO l_ecb06
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ice_file",g_ice01,g_ice[l_ac].ice04,SQLCA.sqlcode,"","",0)   
       EXIT FOREACH
       RETURN
    END IF
       SELECT MAX(ice04)+1 INTO l_ice04
              FROM ice_file
             WHERE ice01 = g_ice01
               AND ice02 = g_ice02
              #AND ice03 = g_ice03 #CHI-950024
               AND ice14 = g_ice14
             IF l_ice04 IS NULL THEN
                LET l_ice04 = 1
             END IF
       INSERT INTO ice_file(ice01,ice02,ice03,ice14,ice04,ice05,ice07,ice08)
            VALUES (g_ice01,g_ice02,g_ice03,g_ice14,l_ice04,l_ecb06,'N','N')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ice_file",g_ice01,g_ice[l_ac].ice04,SQLCA.sqlcode,"","",0)   
            ROLLBACK WORK
            RETURN
         END IF
    END FOREACH
    COMMIT WORK
END FUNCTION
 
FUNCTION i004_bodymask() #body mask 料號產生
DEFINE l_ima    RECORD LIKE ima_file.*
DEFINE l_imaicd RECORD LIKE imaicd_file.*
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_a     LIKE icr_file.icr01
DEFINE l_b     LIKE imz_file.imz01
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_aza60 LIKE aza_file.aza60
DEFINE p_keyvalue STRING
 
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_ice01) THEN 
     CALL cl_err('',-400,0)
     RETURN
  END IF 
  INITIALIZE l_ima.* TO NULL       
  OPEN WINDOW i0041_w AT 10,25 WITH FORM "aic/42f/aici0041"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
  CALL cl_ui_locale("aici0041")
 
  INPUT l_a,l_b FROM FORMONLY.a,FORMONLY.b
 
      AFTER FIELD a
        IF cl_null(l_a) THEN
           NEXT FIELD a 
        ELSE
           SELECT COUNT(*) INTO l_cnt FROM icr_file
            WHERE icr01 = l_a
           IF l_cnt = 0 THEN
             CALL cl_err('','aic-019',1)
             NEXT FIELD a 
           END IF
        END IF
      AFTER FIELD b
        IF cl_null(l_b) THEN
           NEXT FIELD b
        ELSE
         SELECT COUNT(*) INTO l_cnt FROM ima_file
           WHERE ima06 = l_b
          IF l_cnt = 0 THEN
            CALL cl_err('','mfg3179',1)
            NEXT FIELD b
          END IF
        END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help       
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION controlp
        CASE
          WHEN INFIELD(a) 
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_icr01"
             LET g_qryparam.arg1 = '1' 
             CALL cl_create_qry() RETURNING l_a 
             DISPLAY l_a TO FORMONLY.a
             NEXT FIELD a
 
          WHEN INFIELD(b)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_imz"
             CALL cl_create_qry() RETURNING l_b 
             DISPLAY l_b TO FORMONLY.b
             NEXT FIELD b
        END CASE
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW i0041_w
        RETURN
    END IF
    
   CLOSE WINDOW i0041_w
   BEGIN WORK
   LET p_keyvalue = g_ice01,'||',g_ice02,'||',g_ice14
   CALL s_aic_auto_no(l_a,1,p_keyvalue,'') RETURNING l_ima01   #FUN-BC0106 add ''
    IF cl_null(l_ima01) THEN
       CALL cl_err('','sub-145',0)
       RETURN
    END IF
          SELECT imz01,imz02,imz03 ,imz04,
                 imz07,imz08,imz09,imz10,
                 imz11,imz12,imz14,imz15,
                 imz17,imz19,imz21,
                 imz23,imz24,imz25,imz27,
                 imz28,imz31,imz31_fac,imz34,
                 imz35,imz36,imz37,imz38,
                 imz39,imz42,imz43,imz44,
                 imz44_fac,imz45,imz46 ,imz47,
                 imz48,imz49,imz491,imz50,
                 imz51,imz52,imz54,imz55,
                 imz55_fac,imz56,imz561,imz562,
                 imz571,
                 imz59 ,imz60,imz61,imz62,
                 imz63,imz63_fac ,imz64,imz641,
                 imz65,imz66,imz67,imz68,
                 imz69,imz70,imz71,imz86,
                 imz86_fac ,imz87,imz871,imz872,
                 imz873,imz874,imz88,imz89,
                 imz90,imz94,imz99,imz100 ,
                 imz101,imz102 ,imz103,imz105,
                 imz106,imz107,imz108,imz109,
                 imz110,imz130,imz131,imz132,
                 imz133,imz134,
                 imz147,imz148,imz903,
                 imzacti,imzuser,imzgrup,imzmodu,imzdate,
                 imz906,imz907,imz908,imz909,
                 imz911,
                 imz926,                       #FUN-9B0099
                 imz136,imz137,imz391,imz1321,
                 imz72
            INTO l_ima.ima06,l_ima.ima02,l_ima.ima03,l_ima.ima04,
                 l_ima.ima07,l_ima.ima08,l_ima.ima09,l_ima.ima10,
                 l_ima.ima11,l_ima.ima12,l_ima.ima14,l_ima.ima15,
                 l_ima.ima17,l_ima.ima19,l_ima.ima21,
                 l_ima.ima23,l_ima.ima24,l_ima.ima25,l_ima.ima27, 
                 l_ima.ima28,l_ima.ima31,l_ima.ima31_fac,l_ima.ima34,
                 l_ima.ima35,l_ima.ima36,l_ima.ima37,l_ima.ima38,
                 l_ima.ima39,l_ima.ima42,l_ima.ima43,l_ima.ima44, 
                 l_ima.ima44_fac,l_ima.ima45,l_ima.ima46,l_ima.ima47,
                 l_ima.ima48,l_ima.ima49,l_ima.ima491,l_ima.ima50,
                 l_ima.ima51,l_ima.ima52,l_ima.ima54,l_ima.ima55,
                 l_ima.ima55_fac,l_ima.ima56,l_ima.ima561,l_ima.ima562,
                 l_ima.ima571,
                 l_ima.ima59, l_ima.ima60,l_ima.ima61,l_ima.ima62,
                 l_ima.ima63, l_ima.ima63_fac,l_ima.ima64,l_ima.ima641,
                 l_ima.ima65, l_ima.ima66,l_ima.ima67,l_ima.ima68,
                 l_ima.ima69, l_ima.ima70,l_ima.ima71,l_ima.ima86,
                 l_ima.ima86_fac, l_ima.ima87,l_ima.ima871,l_ima.ima872,
                 l_ima.ima873, l_ima.ima874,l_ima.ima88,l_ima.ima89,
                 l_ima.ima90,l_ima.ima94,l_ima.ima99,l_ima.ima100,     
                 l_ima.ima101,l_ima.ima102,l_ima.ima103,l_ima.ima105,  
                 l_ima.ima106,l_ima.ima107,l_ima.ima108,l_ima.ima109,  
                 l_ima.ima110,l_ima.ima130,l_ima.ima131,l_ima.ima132,  
                 l_ima.ima133,l_ima.ima134,                            
                 l_ima.ima147,l_ima.ima148,l_ima.ima903,
                 l_ima.imaacti,l_ima.imauser,l_ima.imagrup,l_ima.imamodu,l_ima.imadate,
                 l_ima.ima906,l_ima.ima907,l_ima.ima908,l_ima.ima909,  
                 l_ima.ima911,                                         
                 l_ima.ima926,             #FUN-9B0099                               
                 l_ima.ima136,l_ima.ima137,l_ima.ima391,l_ima.ima1321, 
                 l_ima.ima915                                          
                 FROM  imz_file
                 WHERE imz01 = l_b
          IF SQLCA.sqlcode THEN
             CALL cl_err('sel imz',SQLCA.sqlcode,0)
             RETURN
          END IF
          LET l_ima.ima01 = l_ima01
          IF l_ima.ima99 IS NULL THEN LET l_ima.ima99 = 0 END IF
          IF l_ima.ima133 IS NULL THEN LET l_ima.ima133 = l_ima.ima01 END IF
          IF l_ima.ima01[1,4]='MISC' THEN 
             LET l_ima.ima08='Z'
          END IF
          SELECT aza60 INTO l_aza60 FROM aza_file
          IF l_aza60 = 'Y' THEN
             LET l_ima.imaacti = 'P'
          ELSE 
             LET l_ima.imaacti = 'Y'
          END IF          
#          LET l_ima.ima26 = 0               #FUN-A20044
#          LET l_ima.ima261 = 0              #FUN-A20044
#          LET l_ima.ima262 = 0              #FUN-A20044
          LET l_ima.ima916 = ' '
          LET l_ima.ima601 = 1     #No.FUN-840194
          IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 = 'N' END IF     #FUN-9B0099
    LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
   #FUN-A80150---add---start---
    IF cl_null(l_ima.ima156) THEN 
       LET l_ima.ima156 = 'N'
    END IF
    IF cl_null(l_ima.ima158) THEN 
       LET l_ima.ima158 = 'N'
    END IF
   #FUN-A80150---add---end---
    LET l_ima.ima927='N'   #No:FUN-AA0014
    #FUN-C20065 ----------Begin-----------
     IF cl_null(l_ima.ima159) THEN
        LET l_ima.ima159 = '3'
     END IF
    #FUN-C20065 ----------End-------------
    IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
    IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
    INSERT INTO ima_file VALUES(l_ima.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ima_file",l_ima01,g_ice02,SQLCA.sqlcode,"","",0)   
       ROLLBACK WORK
       RETURN
    END IF
    LET l_imaicd.imaicd00 = l_ima01
    LET l_imaicd.imaicd08 = 'N'
    LET l_imaicd.imaicd09 = 'N'
    LET l_imaicd.imaicd05 = '3'
    INSERT INTO imaicd_file VALUES(l_imaicd.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","imaicd_file",l_ima01,g_ice02,SQLCA.sqlcode,"","",0)   
       ROLLBACK WORK
       RETURN
    END IF
    INSERT INTO ics_file(ics00,ics01,ics02,ics03,ics04,ics05,ics13,ics14,ics15,icspost)
        VALUES(l_ima01,g_ice01,g_ice02,g_ice03,g_ice14,'',0,l_ima.ima31,0,'N')
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ics_file",l_ima01,l_ima01,SQLCA.sqlcode,"","",0)   
       ROLLBACK WORK
       RETURN
    END IF
    UPDATE ice_file SET ice13 = l_ima01
     WHERE ice01 = g_ice01
       AND ice02 = g_ice02
       AND ice14 = g_ice14
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","ice_file",l_ima01,"",SQLCA.sqlcode,"","",0)   
       ROLLBACK WORK
       RETURN
    END IF
    LET g_ice13 = l_ima01
    DISPLAY BY NAME g_ice13
      
    COMMIT WORK
END FUNCTION
 
FUNCTION i004_layermask() #layer mask 料號產生
DEFINE l_ima    RECORD LIKE ima_file.*
DEFINE l_imaicd RECORD LIKE imaicd_file.*
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_a     LIKE icr_file.icr01
DEFINE l_b     LIKE imz_file.imz01
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5
DEFINE l_aza60 LIKE aza_file.aza60
DEFINE l_ice04 LIKE ice_file.ice04
DEFINE l_ice05 LIKE ice_file.ice05
DEFINE p_keyvalue   STRING
 
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_ice01) THEN 
     CALL cl_err('',-400,0)
     RETURN
  END IF 
  INITIALIZE l_ima.* TO NULL       
  OPEN WINDOW i0041_w AT 10,25 WITH FORM "aic/42f/aici0041"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
  CALL cl_ui_locale("aici0041")
 
  INPUT l_a,l_b FROM FORMONLY.a,FORMONLY.b
 
      AFTER FIELD a
        IF cl_null(l_a) THEN
           NEXT FIELD a 
        ELSE
           SELECT COUNT(*) INTO l_cnt FROM icr_file
            WHERE icr01 = l_a
           IF l_cnt = 0 THEN
             CALL cl_err('','aic-019',1)
             NEXT FIELD a 
           END IF
        END IF
      AFTER FIELD b
        IF cl_null(l_b) THEN
           NEXT FIELD b
        ELSE
         SELECT COUNT(*) INTO l_cnt FROM ima_file
           WHERE ima06 = l_b
          IF l_cnt = 0 THEN
            CALL cl_err('','mfg3179',1)
            NEXT FIELD b
          END IF
        END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help       
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION controlp
        CASE
          WHEN INFIELD(a) 
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_icr01"
             LET g_qryparam.arg1 = '2' 
             CALL cl_create_qry() RETURNING l_a 
             DISPLAY l_a TO FORMONLY.a
             NEXT FIELD a
 
          WHEN INFIELD(b)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_imz"
             CALL cl_create_qry() RETURNING l_b 
             DISPLAY l_b TO FORMONLY.b
             NEXT FIELD b
        END CASE
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW i0041_w
        RETURN
    END IF
    
    CLOSE WINDOW i0041_w
 
    BEGIN WORK
 
    LET g_sql = "SELECT ice04,ice05 ",
                " FROM ice_file ",
                " WHERE ice01 = '",g_ice01 CLIPPED,"' ",
                " AND ice02 = '",g_ice02 CLIPPED,"' ",
                " AND ice14 = '",g_ice14 CLIPPED,"' ",
                " AND ice07 = 'Y' ",
                " ORDER BY ice04"
    PREPARE i004_layer_pre FROM g_sql           #預備一下
    DECLARE i004_layer_curs CURSOR FOR i004_layer_pre
    FOREACH i004_layer_curs INTO l_ice04,l_ice05
    IF SQLCA.sqlcode THEN
       CALL cl_err3("foreach","ice_file",g_ice01,"",SQLCA.sqlcode,"","",0)   
       EXIT FOREACH
       RETURN
    END IF
    LET p_keyvalue = g_ice01,'||',g_ice02,'||',l_ice04,'||',g_ice14
    CALL s_aic_auto_no(l_a,2,p_keyvalue,'') RETURNING l_ima01   #FUN-BC0106 add ''
    IF cl_null(l_ima01) THEN
       CALL cl_err('','sub-145',0)
       RETURN
    END IF
          SELECT imz01,imz02,imz03 ,imz04,
                 imz07,imz08,imz09,imz10,
                 imz11,imz12,imz14,imz15,
                 imz17,imz19,imz21,
                 imz23,imz24,imz25,imz27,
                 imz28,imz31,imz31_fac,imz34,
                 imz35,imz36,imz37,imz38,
                 imz39,imz42,imz43,imz44,
                 imz44_fac,imz45,imz46 ,imz47,
                 imz48,imz49,imz491,imz50,
                 imz51,imz52,imz54,imz55,
                 imz55_fac,imz56,imz561,imz562,
                 imz571,
                 imz59 ,imz60,imz61,imz62,
                 imz63,imz63_fac ,imz64,imz641,
                 imz65,imz66,imz67,imz68,
                 imz69,imz70,imz71,imz86,
                 imz86_fac ,imz87,imz871,imz872,
                 imz873,imz874,imz88,imz89,
                 imz90,imz94,imz99,imz100 ,
                 imz101,imz102 ,imz103,imz105,
                 imz106,imz107,imz108,imz109,
                 imz110,imz130,imz131,imz132,
                 imz133,imz134,
                 imz147,imz148,imz903,
                 imzacti,imzuser,imzgrup,imzmodu,imzdate,
                 imz906,imz907,imz908,imz909,
                 imz911,
                 imz926,                       #FUN-9B0099
                 imz136,imz137,imz391,imz1321,
                 imz72
            INTO l_ima.ima06,l_ima.ima02,l_ima.ima03,l_ima.ima04,
                 l_ima.ima07,l_ima.ima08,l_ima.ima09,l_ima.ima10,
                 l_ima.ima11,l_ima.ima12,l_ima.ima14,l_ima.ima15,
                 l_ima.ima17,l_ima.ima19,l_ima.ima21,
                 l_ima.ima23,l_ima.ima24,l_ima.ima25,l_ima.ima27, 
                 l_ima.ima28,l_ima.ima31,l_ima.ima31_fac,l_ima.ima34,
                 l_ima.ima35,l_ima.ima36,l_ima.ima37,l_ima.ima38,
                 l_ima.ima39,l_ima.ima42,l_ima.ima43,l_ima.ima44, 
                 l_ima.ima44_fac,l_ima.ima45,l_ima.ima46,l_ima.ima47,
                 l_ima.ima48,l_ima.ima49,l_ima.ima491,l_ima.ima50,
                 l_ima.ima51,l_ima.ima52,l_ima.ima54,l_ima.ima55,
                 l_ima.ima55_fac,l_ima.ima56,l_ima.ima561,l_ima.ima562,
                 l_ima.ima571,
                 l_ima.ima59, l_ima.ima60,l_ima.ima61,l_ima.ima62,
                 l_ima.ima63, l_ima.ima63_fac,l_ima.ima64,l_ima.ima641,
                 l_ima.ima65, l_ima.ima66,l_ima.ima67,l_ima.ima68,
                 l_ima.ima69, l_ima.ima70,l_ima.ima71,l_ima.ima86,
                 l_ima.ima86_fac, l_ima.ima87,l_ima.ima871,l_ima.ima872,
                 l_ima.ima873, l_ima.ima874,l_ima.ima88,l_ima.ima89,
                 l_ima.ima90,l_ima.ima94,l_ima.ima99,l_ima.ima100,     
                 l_ima.ima101,l_ima.ima102,l_ima.ima103,l_ima.ima105,  
                 l_ima.ima106,l_ima.ima107,l_ima.ima108,l_ima.ima109,  
                 l_ima.ima110,l_ima.ima130,l_ima.ima131,l_ima.ima132,  
                 l_ima.ima133,l_ima.ima134,                            
                 l_ima.ima147,l_ima.ima148,l_ima.ima903,
                 l_ima.imaacti,l_ima.imauser,l_ima.imagrup,l_ima.imamodu,l_ima.imadate,
                 l_ima.ima906,l_ima.ima907,l_ima.ima908,l_ima.ima909,  
                 l_ima.ima911,                                         
                 l_ima.ima926,             #FUN-9B0099                               
                 l_ima.ima136,l_ima.ima137,l_ima.ima391,l_ima.ima1321, 
                 l_ima.ima915                                          
                 FROM  imz_file
                 WHERE imz01 = l_b
          IF SQLCA.sqlcode THEN
             CALL cl_err('sel imz',SQLCA.sqlcode,0)
             RETURN
          END IF
          LET l_ima.ima01 = l_ima01
          IF l_ima.ima99 IS NULL THEN LET l_ima.ima99 = 0 END IF
          IF l_ima.ima133 IS NULL THEN LET l_ima.ima133 = l_ima.ima01 END IF
          IF l_ima.ima01[1,4]='MISC' THEN 
             LET l_ima.ima08='Z'
          END IF
          SELECT aza60 INTO l_aza60 FROM aza_file
          IF l_aza60 = 'Y' THEN
             LET l_ima.imaacti = 'P'
          ELSE 
             LET l_ima.imaacti = 'Y'
          END IF          
#          LET l_ima.ima26 = 0              #FUN-A20044
#          LET l_ima.ima261 = 0             #FUN-A20044
#          LET l_ima.ima262 = 0             #FUN-A20044
          LET l_ima.ima916 = ' '
          LET l_ima.ima601 = 1      #No.FUN-840194   
          LET l_imaicd.imaicd00 = l_ima01
          LET l_imaicd.imaicd08 = 'N'
          LET l_imaicd.imaicd09 = 'N'
          LET l_imaicd.imaicd05 = '3'
          LET l_i = 0
          IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 = 'N' END IF     #FUN-9B0099
          SELECT COUNT(*) INTO l_i FROM ima_file WHERE ima01 = l_ima01
          IF l_i = 0 THEN
             LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
             LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
            #FUN-A80150---add---start---
             IF cl_null(l_ima.ima156) THEN 
                LET l_ima.ima156 = 'N'
             END IF
             IF cl_null(l_ima.ima158) THEN 
                LET l_ima.ima158 = 'N'
             END IF
            #FUN-A80150---add---end---
             LET l_ima.ima927='N'   #No:FUN-AA0014
             #FUN-C20065 ----------Begin-----------
             IF cl_null(l_ima.ima159) THEN
                LET l_ima.ima159 = '3'
             END IF
             #FUN-C20065 ----------End-------------
             IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
             IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
             INSERT INTO ima_file VALUES(l_ima.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ima_file",l_ima01,g_ice02,SQLCA.sqlcode,"","",0)   
                ROLLBACK WORK
                RETURN
             END IF
          END IF
          LET l_i = 0
          SELECT COUNT(*) INTO l_i FROM imaicd_file WHERE imaicd00 = l_ima01
          IF l_i = 0 THEN
             INSERT INTO imaicd_file VALUES(l_imaicd.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","imaicd_file",l_ima01,g_ice02,SQLCA.sqlcode,"","",0)   
                ROLLBACK WORK
                RETURN
             END IF
          END IF
          LET l_i = 0
          SELECT COUNT(*) INTO l_i FROM ics_file WHERE ics00 = l_ima01
          IF l_i = 0 THEN
             INSERT INTO ics_file(ics00,ics01,ics02,ics03,ics04,ics05,ics13,ics14,ics15,icspost)
                  VALUES(l_ima01,g_ice01,g_ice02,g_ice03,g_ice14,l_ice05,0,l_ima.ima31,0,'N')
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ics_file",l_ima01,l_ima01,SQLCA.sqlcode,"","",0)   
                ROLLBACK WORK
                RETURN
             END IF
          END IF
          UPDATE ice_file SET ice15 = l_ima01
           WHERE ice01 = g_ice01
             AND ice02 = g_ice02
             AND ice14 = g_ice14
             AND ice04 = l_ice04
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","ice_file",l_ima01,"",SQLCA.sqlcode,"","",0)   
              ROLLBACK WORK
              RETURN
           END IF
           LET g_ice13 = l_ima01
           DISPLAY BY NAME g_ice13
    END FOREACH
 
    COMMIT WORK
END FUNCTION
#No.FUN-9C0072 精簡程式碼
 
