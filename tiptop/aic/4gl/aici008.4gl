# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aici008.4gl
# Descriptions...: ICD料件DS維護作業
# Date & Author..: FUN-7B0077 07/11/15 By mike
# Modify.........: No.CHI-840023 08/04/20 By kim GP5.1顧問測試修改
# Modify.........: No.TQC-890007 08/09/02 By sherry 廠商開窗查詢異常
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   g_icg01           LIKE icg_file.icg01,
   g_icg01_t         LIKE icg_file.icg01,
   g_icg02           LIKE icg_file.icg02,
   g_icg02_t         LIKE icg_file.icg02,
   g_icg03           LIKE icg_file.icg03,
   g_icg03_t         LIKE icg_file.icg03,
   g_icg04           LIKE icg_file.icg04,
   g_icg04_t         LIKE icg_file.icg04,
   g_icg             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      icg03          LIKE icg_file.icg03,
      pmc03          LIKE pmc_file.pmc03,
      icg02          LIKE icg_file.icg02,
      icg16          LIKE icg_file.icg16,
      icg17          LIKE icg_file.icg17,
      icg18          LIKE icg_file.icg18,
      icg19          LIKE icg_file.icg19,
      icg20          LIKE icg_file.icg20,
      icg21          LIKE icg_file.icg21
                     END RECORD,
   g_icg_t           RECORD                     #程式變數 (舊值)
      icg03          LIKE icg_file.icg03,                                                                                          
      pmc03          LIKE pmc_file.pmc03,                                                                                          
      icg02          LIKE icg_file.icg02,                                                                                          
      icg16          LIKE icg_file.icg16,                                                                                          
      icg17          LIKE icg_file.icg17,                                                                                          
      icg18          LIKE icg_file.icg18,                                                                                          
      icg19          LIKE icg_file.icg19,                                                                                          
      icg20          LIKE icg_file.icg20,                                                                                          
      icg21          LIKE icg_file.icg21                     
                     END RECORD,
   g_wc,g_sql,g_wc2  STRING,
   g_show            LIKE type_file.chr1,   
   g_rec_b           LIKE type_file.num5,   #單身筆數
   g_flag            LIKE type_file.chr1, 
   g_ss              LIKE type_file.chr1,
   l_ac              LIKE type_file.num5   #目前處理的ARRAY CNT
DEFINE   p_row,p_col    LIKE type_file.num5    
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp      STRING   
DEFINE   g_before_input_done   LIKE type_file.num5   
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10    
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE   l_cmd          LIKE type_file.chr1000   
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_no_ask       LIKE type_file.chr1
DEFINE   l_abso         LIKE type_file.num10
 
#主程式開始
 
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i008_w AT p_row,p_col
      WITH FORM "aic/42f/aici008"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   LET g_icg04 = ' '
 
   CALL cl_ui_init()
   CALL i008_menu()
   CLOSE WINDOW i008_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
#QBE 查詢資料
FUNCTION i008_cs()
DEFINE l_sql STRING
 
       CLEAR FORM                      #清除畫面
       CALL g_icg.clear()
 
       CALL cl_set_head_visible("","YES")    
 
       CONSTRUCT g_wc ON icg01,
                         icg03,icg02,icg16,icg17,icg18,icg19,icg20,icg21
                 FROM    icg01,
                         s_icg[1].icg03,s_icg[1].icg02,s_icg[1].icg16,
                         s_icg[1].icg17,s_icg[1].icg18,s_icg[1].icg19,
                         s_icg[1].icg20,s_icg[1].icg21
 
          BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(icg01)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form  ="q_ima"
                #   LET g_qryparam.state ="c"
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO icg01
                   NEXT FIELD icg01
              
                WHEN INFIELD(icg03)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_pmc13"
                   LET g_qryparam.form = "q_pmc2" #TQC-890007
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO icg03
                   NEXT FIELD icg03
               
                WHEN INFIELD(icg02)                                                                                      
                  CALL cl_init_qry_var()                                                                                          
                  LET g_qryparam.form ="q_ecd02_icd"                                                                              
                  LET g_qryparam.state ="c"                                                                                       
                  LET g_qryparam.where =" ecdicd01='3'"  #CHI-840023
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                  DISPLAY g_qryparam.multiret TO icg02                                                                            
                  NEXT FIELD icg02  
                OTHERWISE EXIT CASE
             END CASE
          
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
       
          ON ACTION about         
             CALL cl_about()      
       
          ON ACTION help          
             CALL cl_show_help()  
       
          ON ACTION controlg     
             CALL cl_cmdask()    
 
          ON ACTION qbe_select
 
          ON ACTION qbe_save
             CALL cl_qbe_save()
       
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icguser', 'icggrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE icg01 FROM icg_file ",
              " WHERE icg04=' ' AND ",g_wc CLIPPED
    LET g_sql= l_sql," GROUP BY icg01  ORDER BY icg01"
 
    PREPARE i008_prepare FROM g_sql      #預備一下
    DECLARE i008_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i008_prepare
 
    
    LET g_sql="SELECT COUNT(DISTINCT icg01) FROM icg_file WHERE icg04=' ' AND ",g_wc CLIPPED      
    
    PREPARE i008_precount FROM g_sql    
    DECLARE i008_count CURSOR FOR i008_precount
 
END FUNCTION
 
FUNCTION i008_menu()
 
   WHILE TRUE
      CALL i008_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
                  CALL i008_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i008_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i008_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i008_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i008_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
               LET l_cmd = 'p_query "aici008" "',g_wc CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd) 
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_icg),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_icg01 IS NOT NULL THEN
                  LET g_doc.column1 = "icg01"
                  LET g_doc.value1 = g_icg01
                  CALL cl_doc()
               END IF 
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i008_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_icg.clear()
   INITIALIZE g_icg01    LIKE icg_file.icg01
   INITIALIZE g_icg01_t  LIKE icg_file.icg01
   INITIALIZE g_icg02    LIKE icg_file.icg02                                                                                        
   INITIALIZE g_icg02_t  LIKE icg_file.icg02  
   INITIALIZE g_icg03    LIKE icg_file.icg03                                                                                        
   INITIALIZE g_icg03_t  LIKE icg_file.icg03 
   LET g_icg01_t  = NULL
   LET g_icg02_t  = NULL
   LET g_icg03_t  = NULL
   LET g_wc = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
    
      CALL i008_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_icg01 = NULL
         LET g_icg02 = NULL
         LET g_icg03 = NULL
         LET g_icg04 = ' '
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
     
      LET g_rec_b = 0
 
      IF cl_null(g_icg01) THEN
         CONTINUE WHILE
      END IF
 
      CALL i008_b()                      #輸入單身
 
      LET g_icg01_t = g_icg01
      LET g_icg02_t = g_icg02
      LET g_icg03_t = g_icg03
      LET g_icg04_t = g_icg04
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i008_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   
   l_cnt           LIKE type_file.num10      
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET g_ss='Y'
 
   CALL cl_set_head_visible("","YES")  
 
   INPUT g_icg01 WITHOUT DEFAULTS
      FROM icg01
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i008_set_entry(p_cmd)
         CALL i008_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
         AFTER FIELD icg01
            IF NOT cl_null(g_icg01) THEN
              #FUN-AA0059 ------------------add start-------------
               IF NOT s_chk_item_no(g_icg01,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_icg01 = g_icg01_t
                  NEXT FIELD icg01
               END IF 
              #FUN-AA0059 -----------------add end----------------- 
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM ima_file                                                                             
                  WHERE ima01 = g_icg01 AND imaacti = 'Y'                                                                           
               IF g_cnt = 0 THEN                                                                                                    
                  CALL cl_err(g_icg01,'mfg3403',0)                                                                                  
                  LET g_icg01 = g_icg01_t                                                                                           
                  NEXT FIELD icg01                                                                                                  
               END IF                
               LET g_cnt = 0
               SELECT COUNT(UNIQUE icg01) INTO g_cnt FROM icg_file
                  WHERE icg01 = g_icg01
               IF g_cnt > 0 THEN
                 CALL cl_err(g_icg01,'atm-310',0)
                 LET g_icg01 = g_icg01_t
                 NEXT FIELD icg01
               END IF
               CALL i008_icg01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('icg01:',g_errno,1)
                  LET g_icg01 = g_icg01_t
                  DISPLAY g_icg01 TO icg01
                  NEXT FIELD icg01
               END IF
            END IF
 
            ON ACTION CONTROLP 
               CASE
                  WHEN INFIELD(icg01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.default1 = g_icg01
                  #   CALL cl_create_qry() RETURNING g_icg01
                     CALL q_sel_ima(FALSE, "q_ima", "", g_icg01, "", "", "", "" ,"",'' )  RETURNING g_icg01
#FUN-AA0059 --End--
                     NEXT FIELD icg01
               
                  OTHERWISE EXIT CASE
               END CASE
    
            ON ACTION CONTROLG
               CALL cl_cmdask()
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
 
            ON ACTION about     
               CALL cl_about()    
 
            ON ACTION help       
               CALL cl_show_help()
 
            ON ACTION CONTROLF                  #欄位說明
               CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      END INPUT
 
END FUNCTION
 
FUNCTION i008_q()
 
   LET g_icg01 = ''
   LET g_icg02 = ''
   LET g_icg03 = ''
   LET g_icg04 = ' '
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_icg01 TO NULL  
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_icg.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i008_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_icg01 TO NULL
      CALL g_icg.clear()
      RETURN
   END IF
 
   OPEN i008_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_icg01 TO NULL
   ELSE
      OPEN i008_count
      FETCH i008_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i008_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i008_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   
   l_abso          LIKE type_file.num10   #絕對的筆數 
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i008_bcs INTO g_icg01
       WHEN 'P' FETCH PREVIOUS i008_bcs INTO g_icg01
       WHEN 'F' FETCH FIRST    i008_bcs INTO g_icg01
       WHEN 'L' FETCH LAST     i008_bcs INTO g_icg01
       WHEN '/'
          IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
              
                ON ACTION about      
                   CALL cl_about()  
              
                ON ACTION help     
                   CALL cl_show_help()
              
                ON ACTION controlg  
                   CALL cl_cmdask()  
              
             END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
 
            FETCH ABSOLUTE l_abso i008_bcs INTO g_icg01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_icg01,SQLCA.sqlcode,0)
      INITIALIZE g_icg01 TO NULL 
      INITIALIZE g_icg02 TO NULL
      INITIALIZE g_icg03 TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL i008_show()
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i008_show()
   
   LET g_icg01_t = g_icg01
   DISPLAY g_icg01 TO icg01
   CALL i008_icg01()
   CALL i008_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont() 
 
END FUNCTION
 
#單身
FUNCTION i008_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,          #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
   p_cmd           LIKE type_file.chr1,          #處理狀態          
   l_allow_insert  LIKE type_file.num5,          #可新增否          
   l_allow_delete  LIKE type_file.num5,          #可刪除否          
   l_cnt           LIKE type_file.num10,          
   l_key           STRING  
 
   LET g_action_choice = ""
   LET g_icg04=' '
 
   IF cl_null(g_icg01) THEN
      CALL cl_err('',-400,1)
      RETURN  
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT icg03,' ',icg02,icg16,icg17,icg18,icg19,icg20,icg21",
                      "    FROM icg_file ",
                      " WHERE icg01 = ? AND icg02 = ?  AND icg03 = ? AND icg04 = ? ",
                      " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i008_bcl CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_icg WITHOUT DEFAULTS FROM s_icg.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
        
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_icg_t.* = g_icg[l_ac].*  #BACKUP
        
            BEGIN WORK
        
            OPEN i008_bcl 
            USING g_icg01,g_icg_t.icg02,g_icg_t.icg03,g_icg04
        
            IF STATUS THEN
               CALL cl_err("OPEN i008_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
               CLOSE i008_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i008_bcl INTO g_icg[l_ac].*
 
               IF STATUS THEN
                  CALL cl_err("FETCH i008_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CLOSE i008_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  CALL i008_set_entry_b()
                  CALL i008_set_no_entry_b()
                  CALL i008_icg03()
               END IF
            END IF
            CALL cl_show_fld_cont()   
         END IF
 
      BEFORE INSERT
         DISPLAY 'BEFORE INSERT!'
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_icg[l_ac].* TO NULL 
         LET g_icg[l_ac].icg16 = 'N'
         LET g_icg[l_ac].icg21 = 0
         LET g_icg_t.* = g_icg[l_ac].*
         CALL cl_show_fld_cont()
         CALL i008_set_entry_b()
         CALL i008_set_no_entry_b()
         NEXT FIELD icg03
 
      AFTER FIELD icg03                        
         IF NOT cl_null(g_icg[l_ac].icg03) THEN
            IF g_icg[l_ac].icg03 != g_icg_t.icg03 OR g_icg_t.icg03 IS NULL THEN
               CALL i008_icg03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('icg03:',g_errno,1)
                  LET g_icg[l_ac].icg03 = g_icg_t.icg03
                  DISPLAY BY NAME g_icg[l_ac].icg03
                  NEXT FIELD icg03
               END IF  
            END IF
         END IF
      
      AFTER FIELD icg02
         IF NOT cl_null(g_icg[l_ac].icg02) THEN
            IF p_cmd ='a' OR 
               (p_cmd = 'u' AND 
               (g_icg[l_ac].icg03 != g_icg_t.icg03 OR g_icg[l_ac].icg02 != g_icg_t.icg02)) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                FROM icg_file
                WHERE  icg01 = g_icg01
                   AND icg02 = g_icg[l_ac].icg02
                   AND icg03 = g_icg[l_ac].icg03
                   AND icg04 = g_icg04
                    
               IF l_n > 0 THEN
                  LET g_icg[l_ac].icg02 = g_icg_t.icg02
                  DISPLAY BY NAME g_icg[l_ac].icg02
                  CALL cl_err(g_icg[l_ac].icg02,-239,1)
                  NEXT FIELD icg02
               END IF
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM ecd_file     
                WHERE ecd01=g_icg[l_ac].icg02                                                                               
                  AND ecdicd01='3' #CHI-840023
               IF l_n=0 THEN                                                                                              
                  CALL cl_err('sel ecd_file',100,0)                                                                         
                  NEXT FIELD icg02                                                                                          
               END IF           
            END IF
         END IF
      
      BEFORE FIELD icg16
         CALL i008_set_entry_b()
 
      AFTER FIELD icg16
         IF cl_null(g_icg[l_ac].icg16) OR 
            g_icg[l_ac].icg16 NOT MATCHES '[YN]' THEN
            NEXT FIELD icg16
         END IF
         
         IF g_icg[l_ac].icg16 = 'Y' THEN
            LET g_cnt = 0
            SELECT COUNT(icg16) INTO g_cnt FROM icg_file
             WHERE icg01=g_icg01 AND icg04=' ' AND icg16='Y'
            IF g_cnt>0 THEN
               CALL cl_err('icg16:','aic-023',1)
               LET g_icg[l_ac].icg16 = g_icg_t.icg16
               DISPLAY BY NAME g_icg[l_ac].icg16
               NEXT FIELD icg16
            END IF
         END IF
         IF g_icg[l_ac].icg16 = 'Y' THEN
            LET g_icg[l_ac].icg17 = ' '
            DISPLAY BY NAME g_icg[l_ac].icg17
         END IF
         CALL i008_set_no_entry_b()
 
      AFTER FIELD icg21
         IF cl_null(g_icg[l_ac].icg21) OR g_icg[l_ac].icg21 < 0 THEN
               CALL cl_err(g_icg[l_ac].icg21,'aim-391',1)
               LET g_icg[l_ac].icg21 = g_icg_t.icg21
               DISPLAY BY NAME g_icg[l_ac].icg21
               NEXT FIELD icg21
         END IF
 
      AFTER INSERT
         DISPLAY 'AFTER INSERT!'
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO icg_file(icg01,icg02,icg03,icg04,icg16,
                              icg17,icg18,icg19,icg20,icg21,
                              icguser,icggrup,icgmodu,icgdate,icgacti,icgoriu,icgorig)
         VALUES(g_icg01,g_icg[l_ac].icg02,g_icg[l_ac].icg03,g_icg04,g_icg[l_ac].icg16,
                g_icg[l_ac].icg17,g_icg[l_ac].icg18,g_icg[l_ac].icg19,g_icg[l_ac].icg20,
                g_icg[l_ac].icg21,g_user,g_grup,NULL,g_today,'Y', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                 
         IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("ins","icg_file",g_icg[l_ac].icg03,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         DISPLAY 'BEFORE DELETE!'
         IF g_icg_t.icg03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
               
            DELETE FROM icg_file WHERE icg01 = g_icg01
                                   AND icg02 = g_icg_t.icg02
                                   AND icg03 = g_icg_t.icg03
                                   AND icg04 = g_icg04
 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("del","icg_file",g_icg[l_ac].icg03,"",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
 
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_icg[l_ac].* = g_icg_t.*
            CLOSE i008_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_icg[l_ac].icg03,-263,1)
            LET g_icg[l_ac].* = g_icg_t.*
         ELSE
            UPDATE icg_file 
               SET icg02 = g_icg[l_ac].icg02,
                   icg03 = g_icg[l_ac].icg03,
                   icg16 = g_icg[l_ac].icg16,
                   icg17 = g_icg[l_ac].icg17,
                   icg18 = g_icg[l_ac].icg18,
                   icg19 = g_icg[l_ac].icg19,
                   icg20 = g_icg[l_ac].icg20,
                   icg21 = g_icg[l_ac].icg21,
                   icgmodu = g_user,
                   icgdate = g_today
 
               WHERE icg01 = g_icg01
                AND  icg02 = g_icg_t.icg02
                AND  icg03 = g_icg_t.icg03
                AND  icg04 = ' '
 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","icg_file",g_icg[l_ac].icg03,"",SQLCA.sqlcode,"","",1)  
               LET g_icg[l_ac].* = g_icg_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac#FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err(' ',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_icg[l_ac].* = g_icg_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i008_bcl
            ROLLBACK WORK 
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030  add
         CLOSE i008_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icg03)
               CALL cl_init_qry_var()
              #LET g_qryparam.form  ="q_pmc13"
               LET g_qryparam.form  ="q_pmc2" #TQC-890007
               CALL cl_create_qry() RETURNING g_icg[l_ac].icg03
               DISPLAY BY NAME g_icg[l_ac].icg03
               NEXT FIELD icg03
            
             WHEN INFIELD(icg02)                                                                                                   
               CALL cl_init_qry_var()                                                                                             
               LET g_qryparam.form = "q_ecd02_icd"                                                                                
               LET g_qryparam.default1 = g_icg[l_ac].icg02                                                                        
               LET g_qryparam.where =" ecdicd01='3'" 
               CALL cl_create_qry() RETURNING g_icg[l_ac].icg02                                                                   
               DISPLAY BY NAME g_icg[l_ac].icg02
               NEXT FIELD icg02      
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLO
         IF INFIELD(icg03) AND l_ac>1 THEN
            LET g_icg[l_ac].* = g_icg[l_ac-1].*
            DISPLAY BY NAME g_icg[l_ac].*
            NEXT FIELD icg03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()   
 
      ON ACTION help     
         CALL cl_show_help()
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
 
   CLOSE i008_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i008_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT icg03,' ',icg02,icg16,icg17,icg18,icg19,icg20,icg21",
               " FROM icg_file ",
               " WHERE icg01 = '",g_icg01,"' ",
               "   AND icg04 = ' ' ",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY icg03"
   PREPARE i008_prepare2 FROM g_sql       #預備一下
   DECLARE icg_cs CURSOR FOR i008_prepare2
 
   CALL g_icg.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH icg_cs INTO g_icg[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT pmc03 INTO g_icg[g_cnt].pmc03 
       FROM pmc_file
      WHERE pmc01 = g_icg[g_cnt].icg03
       AND  pmcacti = 'Y'
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_icg.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i008_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_icg TO s_icg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i008_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL i008_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL i008_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY         
 
      ON ACTION next
         CALL i008_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION last
         CALL i008_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY             
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document         
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i008_copy()
DEFINE
   l_n                LIKE type_file.num5,  
   l_newno1,l_oldno1  LIKE icg_file.icg01,
   l_ima02            LIKE ima_file.ima02,
   l_imaacti          LIKE ima_file.imaacti
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icg01) THEN
      CALL cl_err('',-400,1)
      RETURN     
   END IF
   
   LET g_before_input_done = FALSE
   CALL i008_set_entry('a')
   LET g_before_input_done = TRUE
 
   DISPLAY " " TO icg01
   CALL cl_set_head_visible("","YES") 
 
   INPUT l_newno1 WITHOUT DEFAULTS FROM icg01
 
   AFTER INPUT
      IF INT_FLAG THEN
         EXIT INPUT
      END IF
 
      IF cl_null(l_newno1) THEN
         NEXT FIELD icg01
      END IF
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM ima_file
       WHERE ima01 = l_newno1 AND imaacti = 'Y'
 
      IF l_n = 0 THEN
         CALL cl_err(l_newno1,'mfg3403',1)
         NEXT FIELD icg01
      END IF
 
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM icg_file
       WHERE icg01 = l_newno1
      
      IF l_n > 0 THEN
         CALL cl_err(l_newno1,'-239',1)
         NEXT FIELD icg01 
      END IF
      
      LET g_errno=" "
      SELECT ima02,imaacti  INTO l_ima02,l_imaacti FROM ima_file
       WHERE ima01=l_newno1
      CASE WHEN SQLCA.SQLCODE=100 LET g_errno='mfg3001'
                                  LET l_ima02=NULL
           WHEN l_imaacti='N'     LET g_errno='9028'
           OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '------' 
      END CASE
      IF cl_null(g_errno) THEN 
         DISPLAY l_ima02 TO FORMONLY.ima02
      END IF
 
      ON ACTION CONTROLP 
         CASE
            WHEN INFIELD(icg01)
#FUN-AB0025---------mod---------------str---------------- 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_ima'
#              LET g_qryparam.default1 = l_newno1
#              CALL cl_create_qry() RETURNING l_newno1
               CALL q_sel_ima(FALSE, "q_ima","",l_newno1,"","","","","",'' ) 
                 RETURNING l_newno1
#FUN-AB0025--------mod---------------end----------------
               NEXT FIELD icg01
            OTHERWISE EXIT CASE
         END CASE
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_icg01 TO icg01
      RETURN
   END IF
 
   DROP TABLE i008_x
 
   SELECT * FROM icg_file    
    WHERE icg01 = g_icg01 AND icg04 = ' '
     INTO TEMP i008_x
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","i008_x",g_icg01,"",SQLCA.sqlcode,"",g_msg,1) 
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE i008_x SET icg01   = l_newno1,
                     icguser = g_user,
                     icggrup = g_grup,
                     icgmodu = NULL,
                     icgdate = g_today,
                     icgacti = 'Y'
 
   INSERT INTO icg_file SELECT * FROM i008_x
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","icg_file",l_newno1,"",SQLCA.sqlcode,"",g_msg,1) 
      ROLLBACK WORK
      RETURN
   ELSE 
      COMMIT WORK
   END IF
  
   LET l_oldno1 = g_icg01 
   LET g_icg01 = l_newno1
   CALL i008_b()
   #LET g_icg01 = l_oldno1  #FUN-C30027
   #CALL i008_show()        #FUN-C30027
 
END FUNCTION
 
FUNCTION i008_icg03()   #廠商
   DEFINE   l_pmc03     LIKE pmc_file.pmc03
   DEFINE   l_pmcacti   LIKE pmc_file.pmcacti
 
   LET g_errno = ''
 
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti   
    FROM pmc_file
   WHERE pmc01=g_icg[l_ac].icg03
 
   CASE   WHEN   SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                      LET l_pmc03=null
          WHEN   l_pmcacti = 'N'      LET g_errno = '9028'
          OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE  
 
   IF cl_null(g_errno) THEN
      LET g_icg[l_ac].pmc03 = l_pmc03
      DISPLAY BY NAME g_icg[l_ac].pmc03
   END IF
 
END FUNCTION
 
FUNCTION i008_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_icg01) THEN
      CALL cl_err('',-400,1)
      RETURN   
   END IF
 
   BEGIN WORK
  
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "icg01"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_icg01       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM icg_file WHERE icg01=g_icg01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","icg_file",g_icg01,"",SQLCA.sqlcode,"","del icg",1)
      RETURN      
   END IF   
   
   CLEAR FORM 
   CALL g_icg.clear()
   MESSAGE ""
   OPEN i008_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i008_bcs
      CLOSE i008_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH i008_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i008_bcs
      CLOSE i008_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i008_bcs
   IF g_curs_index = g_row_count+1 THEN
      LET l_abso = g_row_count
      CALL i008_fetch('L') 
   ELSE
      LET l_abso = g_curs_index
      LET g_no_ask = TRUE
      CALL i008_fetch('/')
   END IF                 
 
   COMMIT WORK
   CALL cl_flow_notify(g_icg01,'D')
 
END FUNCTION
 
FUNCTION i008_set_entry_b()
 
   CALL cl_set_comp_entry("icg17",TRUE)
 
END FUNCTION
 
FUNCTION i008_set_no_entry_b()
 
   IF g_icg[l_ac].icg16 = 'Y' THEN
      CALL cl_set_comp_entry("icg17",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i008_icg01()         #料件編號
   DEFINE   l_ima02     LIKE ima_file.ima02
   DEFINE   l_imaacti   LIKE ima_file.imaacti
 
   LET g_errno = ''
   SELECT ima02,imaacti INTO l_ima02,l_imaacti
      FROM ima_file WHERE ima01 = g_icg01
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3006'
                                 LET l_ima02=NULL
        WHEN l_imaacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
 
   IF cl_null(g_errno) THEN
      DISPLAY  l_ima02 TO FORMONLY.ima02
   END IF
 
END FUNCTION
 
FUNCTION i008_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("icg01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i008_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("icg01",FALSE)
   END IF
 
END FUNCTION
 
#No.FUN-7B0077
                                                                                                                                   
              
                                                                                                                  
                                                                                                                                    
                                                                                                                                 
                                                                                                                                    
                                                                                                                           
                                                                                                                                    
      
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
