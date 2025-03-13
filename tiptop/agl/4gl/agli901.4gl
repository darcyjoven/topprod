# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: agli901.4gl
# Descriptions...: 財務指標公式設置資料維護作業
# Date & Author..: FUN-D50004 13/05/06 By zhangweib
# Modify.........: No:CHI-D70005 13/07/05 by Reanna 修正「查詢任何一筆資料，再查詢，不輸入任何資料，直接esc離開，再按下b進入單身，會出現無法離開程式的bug」
# Modify.........: No:TQC-D80014 13/08/08 By zhangweib 2.顯示標題或其他, 錄入後會出現以下錯誤:(-391) IFRS 無法將 null 插入欄的 '欄-名稱'

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_abq01            LIKE abq_file.abq01,   #FUN-D50004
    g_abq01_t          LIKE abq_file.abq01,   #
    g_abq02            LIKE abq_file.abq02,   #
    g_abq02_t          LIKE abq_file.abq02,   #
    g_abq00            LIKE abq_file.abq00,   #
    g_abq00_t          LIKE abq_file.abq00,   #
    g_abq              DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        abq03          LIKE abq_file.abq03,  
        abq04          LIKE abq_file.abq04,
        abq05          LIKE abq_file.abq05,
        abq06          LIKE abq_file.abq06,
        abq07          LIKE abq_file.abq07,
        abq08          LIKE abq_file.abq08,
        abq09          LIKE abq_file.abq09,
        abq10          LIKE abq_file.abq10,
        abq11          LIKE abq_file.abq11,
        abq12          LIKE abq_file.abq12,
        abq15          LIKE abq_file.abq15,
        abq16          LIKE abq_file.abq16,
        abq17          LIKE abq_file.abq17,
        abq18          LIKE abq_file.abq18,
        abq19          LIKE abq_file.abq19,
        abq13          LIKE abq_file.abq13,
        abq14          LIKE abq_file.abq14
                       END RECORD,
    g_abq_t            RECORD                 #程式變數 (舊值)
        abq03          LIKE abq_file.abq03, 
        abq04          LIKE abq_file.abq04,
        abq05          LIKE abq_file.abq05,
        abq06          LIKE abq_file.abq06,
        abq07          LIKE abq_file.abq07,
        abq08          LIKE abq_file.abq08,
        abq09          LIKE abq_file.abq09,
        abq10          LIKE abq_file.abq10,
        abq11          LIKE abq_file.abq11,
        abq12          LIKE abq_file.abq12,
        abq15          LIKE abq_file.abq15,
        abq16          LIKE abq_file.abq16,
        abq17          LIKE abq_file.abq17,
        abq18          LIKE abq_file.abq18,
        abq19          LIKE abq_file.abq19,
        abq13          LIKE abq_file.abq13,
        abq14          LIKE abq_file.abq14
                       END RECORD,
    g_wc,g_sql,g_wc2   STRING,
    g_show             LIKE type_file.chr1,        
    g_rec_b            LIKE type_file.num5,                #單身筆數
    g_flag             LIKE type_file.chr1,     
    g_ss               LIKE type_file.chr1,    
    l_ac               LIKE type_file.num5                 #目前處理的ARRAY CNT     
DEFINE p_row,p_col     LIKE type_file.num5       
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_sql_tmp       STRING 
DEFINE g_cnt           LIKE type_file.num10         
DEFINE g_msg           LIKE type_file.chr1000       
DEFINE g_row_count     LIKE type_file.num10         
DEFINE g_curs_index    LIKE type_file.num10         
DEFINE g_jump          LIKE type_file.num10         
DEFINE mi_no_ask       LIKE type_file.num5          
DEFINE l_table         STRING                       
DEFINE g_str           STRING                       
DEFINE l_sql           STRING                       
DEFINE g_before_input_done LIKE type_file.num5
DEFINE tm              RECORD
          abo01        LIKE abo_file.abo01,
          e            LIKE type_file.chr1
                       END RECORD
DEFINE dis_result      STRING
DEFINE dis_x           DYNAMIC ARRAY OF LIKE abo_file.abo01

MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET l_sql = "abq01.abq_file.abq01,", 
               "abq02.abq_file.abq02,", 
               "abq00.abq_file.abq00,", 
               "abq03.abq_file.abq03,",
               "abq04.abq_file.abq04,", 
               "abq05.abq_file.abq05,", 
               "abq06.abq_file.abq06,", 
               "abq07.abq_file.abq07,", 
               "abq08.abq_file.abq08,", 
               "abq09.abq_file.abq09,", 
               "abq10.abq_file.abq10,",
               "abq11.abq_file.abq11,",
               "abq12.abq_file.abq12,",
               "abq15.abq_file.abq15,", 
               "abq16.abq_file.abq16,", 
               "abq17.abq_file.abq17,", 
               "abq18.abq_file.abq18,", 
               "abq19.abq_file.abq19,",
               "abq13.abq_file.abq13,", 
               "abq14.abq_file.abq14"
   LET l_table = cl_prt_temptable('agli901',l_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
 
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i901_w AT p_row,p_col WITH FORM "agl/42f/agli901"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i901_menu()
 
   CLOSE WINDOW i901_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i901_cs()
DEFINE l_sql STRING   
 
   CLEAR FORM                            #清除畫面
   CALL g_abq.clear()
   CALL cl_set_head_visible("","YES")  
 
   INITIALIZE g_abq01 TO NULL   
   INITIALIZE g_abq02 TO NULL  
   INITIALIZE g_abq00 TO NULL 
   CONSTRUCT g_wc ON abq01,abq02,abq00,abq03,abq04,abq05,abq06,
                     abq07,abq08,abq09,abq10,abq11,abq12,abq15,
                     abq16,abq17,abq18,abq19,abq13,abq14
         FROM abq01,abq02,abq00, s_abq[1].abq03,
              s_abq[1].abq04,s_abq[1].abq05,s_abq[1].abq06,s_abq[1].abq07,
              s_abq[1].abq08,s_abq[1].abq09,s_abq[1].abq10,s_abq[1].abq11,
              s_abq[1].abq12,s_abq[1].abq15,s_abq[1].abq16,s_abq[1].abq17,
              s_abq[1].abq18,s_abq[1].abq19,s_abq[1].abq13,s_abq[1].abq14 
            
     
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
   
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(abq01)   #銷售成本中心
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_abq01"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO abq01
                NEXT FIELD abq01
             WHEN INFIELD(abq00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aaa" 
                LET g_qryparam.state = "c" 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO abq00 
                NEXT FIELD abq00
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
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
    
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED
    IF INT_FLAG THEN RETURN END IF
    
    LET l_sql="SELECT DISTINCT abq01,abq02,abq00 FROM abq_file",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY abq01,abq02,abq00"
    PREPARE i901_prepare FROM g_sql      #預備一下
    DECLARE i901_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i901_prepare
 
    DROP TABLE i901_cnttmp
    LET l_sql=l_sql," INTO TEMP i901_cnttmp"
    PREPARE i901_cnttmp_pre FROM l_sql
    EXECUTE i901_cnttmp_pre    
    
    LET g_sql_tmp="SELECT COUNT(*) FROM i901_cnttmp"  
    PREPARE i901_precount FROM g_sql_tmp 
    DECLARE i901_count CURSOR FOR i901_precount
 
END FUNCTION
 
FUNCTION i901_menu()
 
   WHILE TRUE
      CALL i901_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i901_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i901_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i901_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i901_copy()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i901_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i901_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i901_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_abq),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_abq01 IS NOT NULL THEN
                LET g_doc.column1 = "abq01"
                LET g_doc.column2 = "abq02"
                LET g_doc.column3 = "abq00"
                LET g_doc.value1 = g_abq01
                LET g_doc.value2 = g_abq02
                LET g_doc.value3 = g_abq00
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i901_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_abq.clear()
   LET g_abq01_t  = NULL
   LET g_abq02_t  = NULL
   LET g_abq00_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i901_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_abq01,g_abq02,g_abq00 TO NULL
         LET g_ss='N'
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0             
      IF g_ss='N' THEN
         CALL g_abq.clear()
      ELSE
         CALL i901_b_fill('1=1')         #單身
      END IF
 
      CALL i901_b()                      #輸入單身
 
      LET g_abq01_t = g_abq01
      LET g_abq02_t = g_abq02
      LET g_abq00_t = g_abq00
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i901_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改      
    l_cnt           LIKE type_file.num10,   
    l_aaaacti       LIKE aaa_file.aaaacti,   
    l_count         LIKE type_file.num10
 
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")   
 
    INPUT g_abq01,g_abq02,g_abq00 WITHOUT DEFAULTS FROM abq01,abq02,abq00
    BEFORE INPUT 
       LET g_before_input_done = FALSE
       CALL i901_set_entry(p_cmd)
       CALL i901_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
 
       AFTER FIELD abq01
         LET l_count = 0
         IF NOT cl_null(g_abq01) THEN
            IF g_abq01 != g_abq01_t OR g_abq01_t IS NULL THEN
               SELECT count(*) INTO l_count FROM abq_file
               WHERE abq01 = g_abq01
               IF l_count > 0 THEN   #資料重複
                  CALL cl_err(g_abq01,-239,0)
                  LET g_abq01 = g_abq01_t
                  DISPLAY BY NAME g_abq01
                  NEXT FIELD abq01
               END IF
            END IF
         END IF
 
 
       BEFORE FIELD abq00
          SELECT aza81 INTO g_aza.aza81 FROM aza_file
          LET g_abq00 = g_aza.aza81
       AFTER FIELD abq00
         IF NOT cl_null(g_abq00) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=g_abq00
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",g_abq00,"",100,"","",1)
               NEXT FIELD abq00
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(g_abq00,"9028",1)
               NEXT FIELD abq00
            END IF
         END IF
         IF g_abq00 != g_abq00_t THEN
            CALL cl_err(g_abq00,'agl-502',1)
         END IF

 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(abq00)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 =g_abq00
                CALL cl_create_qry() RETURNING g_abq00
                DISPLAY BY NAME g_abq00
                NEXT FIELD abq00
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
 
FUNCTION i901_q()
   LET g_abq01 = ''
   LET g_abq02 = ''
   LET g_abq00 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_abq01,g_abq02,g_abq00 TO NULL   
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_abq.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i901_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      LET g_rec_b = 0                  #CHI-D70005      
      INITIALIZE g_abq01,g_abq02,g_abq00 TO NULL
      RETURN
   END IF
 
   OPEN i901_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_abq01,g_abq02,g_abq00 TO NULL
   ELSE
      OPEN i901_count
      FETCH i901_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i901_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i901_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1       #處理方式 
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i901_bcs INTO g_abq01,g_abq02,g_abq00
       WHEN 'P' FETCH PREVIOUS i901_bcs INTO g_abq01,g_abq02,g_abq00
       WHEN 'F' FETCH FIRST    i901_bcs INTO g_abq01,g_abq02,g_abq00
       WHEN 'L' FETCH LAST     i901_bcs INTO g_abq01,g_abq02,g_abq00
       WHEN '/'
            IF (NOT mi_no_ask) THEN  
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about  
                     CALL cl_about() 
 
                  ON ACTION help    
                     CALL cl_show_help() 
 
                  ON ACTION controlg    
                     CALL cl_cmdask()  
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i901_bcs INTO g_abq01,g_abq02,g_abq00
            LET mi_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_abq01,SQLCA.sqlcode,0)
      INITIALIZE g_abq01 TO NULL  
      INITIALIZE g_abq02 TO NULL  
      INITIALIZE g_abq00 TO NULL 
   ELSE
      CALL i901_show()
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
FUNCTION i901_show()
   SELECT abq02 INTO g_abq02 
     FROM abq_file WHERE abq01 = g_abq01 AND abq00 = g_abq00 
   DISPLAY g_abq01 TO abq01
   DISPLAY g_abq02 TO abq02
   DISPLAY g_abq00 TO abq00
 
   CALL i901_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()    
END FUNCTION
 
#單身
FUNCTION i901_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,                #檢查重複用      
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否     
   p_cmd           LIKE type_file.chr1,                #處理狀態
   l_allow_insert  LIKE type_file.num5,                #可新增否
   l_allow_delete  LIKE type_file.num5,                #可刪除否
   l_cnt           LIKE type_file.num10,                       
   l_ogb           RECORD LIKE ogb_file.*,
   l_oga24         LIKE oga_file.oga24,
   l_num,i         LIKE type_file.num5
 
   LET g_action_choice = ""
 
   IF cl_null(g_abq01) OR cl_null(g_abq00) THEN
      CALL cl_err('',-400,1)
   END IF
 
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT abq03,abq04,abq05,abq06,abq07,abq08,abq09,abq10,abq11,abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14", 
                      "  FROM abq_file",
                      "  WHERE abq00 = ? AND abq01 = ?",
                      "   AND abq03 = ? FOR UPDATE"
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i901_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_abq.clear() END IF
 
   INPUT ARRAY g_abq WITHOUT DEFAULTS FROM s_abq.*
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
            LET g_abq_t.* = g_abq[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i901_bcl USING g_abq00,g_abq01,g_abq[l_ac].abq03
            IF STATUS THEN
               CALL cl_err("OPEN i901_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i901_bcl INTO g_abq[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i901_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_abq_t.*=g_abq[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()   
         END IF
         IF cl_null(g_abq[l_ac].abq03) OR
            g_abq[l_ac].abq03 = 0 THEN
               SELECT max(abq03)+1 INTO g_abq[l_ac].abq03 FROM abq_file
                WHERE abq01 = g_abq01 AND abq00 = g_abq00
               IF g_abq[l_ac].abq03 IS NULL THEN
                  LET g_abq[l_ac].abq03 = 1
               END IF
         END IF 
         IF g_abq[l_ac].abq05 = '1' THEN
            CALL cl_set_comp_required('abq09',TRUE)
            CALL cl_set_comp_required('abq10',TRUE)
            CALL cl_set_comp_required('abq12',TRUE) 
            CALL cl_set_comp_entry('abq09',TRUE)
            CALL cl_set_comp_entry('abq10',TRUE)
            CALL cl_set_comp_entry('abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14',TRUE) 
            IF cl_null(g_abq[l_ac].abq09) THEN 
            	 LET g_abq[l_ac].abq09 = '1' 
            END IF  	 
         ELSE 
         	  LET g_abq[l_ac].abq11 = 'N' 
            LET g_abq[l_ac].abq12 = '9'
         	  CALL cl_set_comp_required('abq12',FALSE)
            CALL cl_set_comp_entry('abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14',FALSE)  
            CALL cl_set_comp_entry('abq09,abq10',FALSE)  #No.TQC-D80014   Add 
           #IF NOT cl_null(g_abq[l_ac].abq09) THEN       #No.TQC-D80014   Mark
            LET g_abq[l_ac].abq09 = ' ' 
           #END IF                                       #No.TQC-D80014   Mark
         END IF	

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_abq[l_ac].* TO NULL      
         LET g_abq_t.* = g_abq[l_ac].*               #新輸入資料
         IF cl_null(g_abq[l_ac].abq03) OR
            g_abq[l_ac].abq03 = 0 THEN
               SELECT max(abq03)+1 INTO g_abq[l_ac].abq03 FROM abq_file
                WHERE abq01 = g_abq01 AND abq00 = g_abq00
               IF g_abq[l_ac].abq03 IS NULL THEN
                 LET g_abq[l_ac].abq03 = 1
               END IF
         END IF
         LET g_abq[l_ac].abq05='1'
         SELECT azi04 INTO g_azi04 FROM azi_file 
         LET g_abq[l_ac].abq10=g_azi04
         LET g_abq[l_ac].abq11 = 'Y'
         LET g_abq[l_ac].abq12 = '9'
         LET g_abq[l_ac].abq13 = 'N'
         LET g_abq[l_ac].abq14 = 'N'
         CALL cl_show_fld_cont()
     
 
        BEFORE FIELD abq03                        #default 序號
           IF cl_null(g_abq[l_ac].abq03) OR
              g_abq[l_ac].abq03 = 0 THEN
                 SELECT max(abq03)+1 INTO g_abq[l_ac].abq03 FROM abq_file
                  WHERE abq01 = g_abq01 AND abq00 = g_abq00
                 IF g_abq[l_ac].abq03 IS NULL THEN
                    LET g_abq[l_ac].abq03 = 1
                 END IF
           END IF

        AFTER FIELD abq03                        #check 序號是否重複
           IF NOT cl_null(g_abq[l_ac].abq03) THEN
              IF g_abq[l_ac].abq03 != g_abq_t.abq03 OR g_abq_t.abq03 IS NULL THEN
                 SELECT count(*) INTO l_n FROM abq_file
                  WHERE abq01 = g_abq01 AND abq00 = g_abq00 AND abq03 = g_abq[l_ac].abq03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_abq[l_ac].abq03 = g_abq_t.abq03
                    NEXT FIELD abq03
                 END IF
              END IF
           END IF
       
      AFTER FIELD abq05                     
         IF cl_null(g_abq[l_ac].abq05) THEN
            CALL cl_err('数据来源不为空','!',0)
         END IF
         IF g_abq[l_ac].abq05 = '1' THEN
            CALL cl_set_comp_required('abq09',TRUE)
            CALL cl_set_comp_required('abq10',TRUE)
            CALL cl_set_comp_required('abq12',TRUE) 
            CALL cl_set_comp_entry('abq09',TRUE)
            CALL cl_set_comp_entry('abq10',TRUE)
            CALL cl_set_comp_entry('abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14',TRUE) 
            IF cl_null(g_abq[l_ac].abq09) THEN 
            	 LET g_abq[l_ac].abq09 = '1' 
            END IF  	 
         ELSE 
            LET g_abq[l_ac].abq11 = 'N' 
            LET g_abq[l_ac].abq12 = '9'
         	  CALL cl_set_comp_required('abq12',FALSE)
            CALL cl_set_comp_entry('abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14',FALSE)  
            CALL cl_set_comp_entry('abq09,abq10',FALSE) #No.TQC-D80014   Add 
           #IF NOT cl_null(g_abq[l_ac].abq09) THEN      #No.TQC-D80014   Mark 
            LET g_abq[l_ac].abq09 = ' ' 
           #END IF                                      #No.TQC-D80014   Mark
         END IF

      AFTER FIELD abq07
         IF NOT cl_null(g_abq[l_ac].abq07) THEN
            IF g_abq_t.abq07 IS Null OR g_abq_t.abq07 != g_abq[l_ac].abq07 THEN
               CALL i901_abq07(g_abq[l_ac].abq07) RETURNING l_num
               IF l_num > 0 THEN
                  LET l_n = 0
                  FOR i = 1 TO l_num
                     IF dis_x[i][1,1] MATCHES '[a-z]' OR dis_x[i][1,1] MATCHES '[A-Z]' THEN
                        SELECT COUNT(*) INTO l_n FROM abo_file WHERE abo01 = dis_x[i] AND abo00 = g_abq00
                        IF l_n < 1 THEN
                           EXIT FOR
                        END IF
                     END IF
                  END FOR
                  IF l_n < 1 THEN
                     CALL cl_err(dis_x[i],'agl-281',1)
                     NEXT FIELD abq07
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD abq09
         IF g_abq[l_ac].abq05 = '1' THEN
            IF cl_null(g_abq[l_ac].abq09)  THEN
               CALL cl_err('财务指标时数据格式不为空','!',0)
               NEXT FIELD abq09
            END IF
         END IF

      AFTER FIELD abq10
         IF g_abq[l_ac].abq05 = '1' THEN
            IF cl_null(g_abq[l_ac].abq10)  THEN
               CALL cl_err('财务指标时保留位数不为空','!',0)
               NEXT FIELD abq10
            END IF
         END IF
      ON CHANGE abq14
         IF g_abq[l_ac].abq14 <> g_abq_t.abq14 AND g_abq_t.abq14 <> 'Y' THEN 
         	  LET l_n = 0
         	  SELECT COUNT(*) INTO l_n FROM abq_file
         	   WHERE abq00 = g_abq00
         	     AND abq01 = g_abq01
         	     AND abq14 = 'Y'
         	  IF l_n >= 12 THEN   
               CALL cl_err('显示圆盘数已有12个，不可再增加','!',0)
               LET g_abq[l_ac].abq14 = g_abq_t.abq14 
               NEXT FIELD abq14
            END IF
         END IF    	
      AFTER FIELD abq14
         IF g_abq[l_ac].abq14 = 'Y' THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM abq_file
             WHERE abq00 = g_abq00
               AND abq01 = g_abq01
               AND abq14 = 'Y'
            IF l_n >= 12 THEN   
               CALL cl_err('显示圆盘数超过12个，请检查','!',0)
               LET g_abq[l_ac].abq14 = g_abq_t.abq14 
               NEXT FIELD abq14
            END IF   
         END IF    	
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_abq[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_abq[l_ac].* TO s_abq.*
            CALL g_abq.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_abq[l_ac].abq05 = '1' THEN   #No.TQC-D80014   Add
            INSERT INTO abq_file(abq01,abq02,abq00,abq03,abq04,abq05,abq06,
                                 abq07,abq08,abq09,abq10,abq11,abq12,abq15,
                                abq16,abq17,abq18,abq19,abq13,abq14)
                 VALUES(g_abq01,g_abq02,g_abq00,
                        g_abq[l_ac].abq03,g_abq[l_ac].abq04,g_abq[l_ac].abq05,
                        g_abq[l_ac].abq06,g_abq[l_ac].abq07,g_abq[l_ac].abq08,
                        g_abq[l_ac].abq09 ,g_abq[l_ac].abq10,g_abq[l_ac].abq11,
                        g_abq[l_ac].abq12 ,g_abq[l_ac].abq15,g_abq[l_ac].abq16,
                        g_abq[l_ac].abq17 ,g_abq[l_ac].abq18,g_abq[l_ac].abq19,
                        g_abq[l_ac].abq13,g_abq[l_ac].abq14)
        #No.TQC-D80014 ---Add--- Start
         ELSE
            INSERT INTO abq_file(abq01,abq02,abq00,abq03,abq04,abq05,abq06,
                                 abq07,abq08,abq09,abq10,abq11,abq12,abq15,
                                abq16,abq17,abq18,abq19,abq13,abq14)
                 VALUES(g_abq01,g_abq02,g_abq00,
                        g_abq[l_ac].abq03,g_abq[l_ac].abq04,g_abq[l_ac].abq05,
                        g_abq[l_ac].abq06,g_abq[l_ac].abq07,g_abq[l_ac].abq08,
                        ' '              ,g_abq[l_ac].abq10,g_abq[l_ac].abq11,
                        g_abq[l_ac].abq12,0                ,0                ,
                        0                ,0                ,0                ,
                        g_abq[l_ac].abq13,g_abq[l_ac].abq14)
         END IF
        #No.TQC-D80014 ---Add--- End
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","abq_file",g_abq01,g_abq02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_abq_t.abq03 IS NOT NULL OR g_abq_t.abq05 IS NOT NULL THEN
            IF NOT cl_confirm('是否删除单身') THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM abq_file WHERE abq01 = g_abq01
                                   AND abq02 = g_abq02
                                   AND abq00 = g_abq00
                                   AND abq03 = g_abq_t.abq03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","abq_file",g_abq_t.abq04,g_abq_t.abq05,SQLCA.sqlcode,"","",1)
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
            LET g_abq[l_ac].* = g_abq_t.*
            CLOSE i901_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_abq[l_ac].abq03,-263,1)
            LET g_abq[l_ac].* = g_abq_t.*
         ELSE
            UPDATE abq_file SET abq03 = g_abq[l_ac].abq03, 
                                abq04 = g_abq[l_ac].abq04,
                                abq05 = g_abq[l_ac].abq05,
                                abq06 = g_abq[l_ac].abq06,
                                abq07 = g_abq[l_ac].abq07,
                                abq08 = g_abq[l_ac].abq08,
                                abq09 = g_abq[l_ac].abq09,
                                abq10 = g_abq[l_ac].abq10,
                                abq11 = g_abq[l_ac].abq11,
                                abq12 = g_abq[l_ac].abq12,
                                abq15 = g_abq[l_ac].abq15,
                                abq16 = g_abq[l_ac].abq16,
                                abq17 = g_abq[l_ac].abq17,
                                abq18 = g_abq[l_ac].abq18,
                                abq19 = g_abq[l_ac].abq19,
                                abq13 = g_abq[l_ac].abq13,
                                abq14 = g_abq[l_ac].abq14   
                          WHERE abq01 = g_abq01
                            AND abq02 = g_abq02
                            AND abq00 = g_abq00
                            AND abq03 = g_abq_t.abq03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","abq_file",g_abq_t.abq03,g_abq_t.abq05,SQLCA.sqlcode,"","",1)
               LET g_abq[l_ac].* = g_abq_t.*
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
               LET g_abq[l_ac].* = g_abq_t.*
            END IF
            CLOSE i901_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i901_bcl
         COMMIT WORK
         CALL g_abq.deleteElement(g_rec_b+1)
 
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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

      ON ACTION controlp
         CASE
            WHEN INFIELD(abq07)
               CALL i901_formula(g_abq[l_ac].abq07)
               DISPLAY  BY NAME g_abq[l_ac].abq07
         END CASE      
 
   END INPUT
 
   CLOSE i901_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i901_b_fill(p_wc)                     #BODY FILL UP
   DEFINE p_wc STRING  
 
   LET g_sql = "SELECT abq03,abq04,abq05,abq06,abq07,abq08,abq09,abq10,abq11,abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14",
               "  FROM abq_file ",
               " WHERE abq01='",g_abq01,"'",
               "   AND abq02='",g_abq02,"'",
               "   AND abq00='",g_abq00,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY abq03"
   PREPARE i901_p FROM g_sql       #預備一下
   DECLARE abq_cs CURSOR FOR i901_p
 
   CALL g_abq.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH abq_cs INTO g_abq[g_cnt].*     #單身 ARRAY 填充
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
 
   CALL g_abq.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i901_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abq TO s_abq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()      
 
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
         CALL i901_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i901_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY             
 
      ON ACTION jump
         CALL i901_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY             
 
      ON ACTION next
         CALL i901_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY            
 
      ON ACTION last
         CALL i901_fetch('L')
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
         CALL cl_show_fld_cont()       
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i901_u()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_abq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT abq02 INTO g_abq02 FROM abq_file WHERE abq00 = g_abq00 AND abq01 = g_abq01
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_abq01_t = g_abq01
   LET g_abq00_t = g_abq00
   LET g_abq02_t = g_abq02
   BEGIN WORK
   CALL i901_show()
   WHILE TRUE
      LET g_abq01_t = g_abq01
      CALL i901_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_abq00 = g_abq00_t
         LET g_abq01 = g_abq01_t
         LET g_abq02 = g_abq02_t
         CALL i901_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      UPDATE abq_file SET abq02 = g_abq02
       WHERE abq00 = g_abq00_t
         AND abq01 = g_abq01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","abq_file",g_abq01_t,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION i901_copy()
DEFINE
   l_n                LIKE type_file.num5, 
   l_cnt              LIKE type_file.num10,
   l_count            LIKE type_file.num10,     
   l_newno1,l_oldno1  LIKE abq_file.abq01,
   l_newno2,l_oldno2  LIKE abq_file.abq02,
   l_newno3,l_oldno3  LIKE abq_file.abq00
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_abq01) OR cl_null(g_abq02) THEN
      CALL cl_err('',-400,1)
   END IF
   LET g_before_input_done = FALSE
   CALL i901_set_entry('a') 

   CALL cl_set_head_visible("","YES") 
 
   INPUT l_newno1,l_newno2 FROM abq01,abq00
 
      AFTER FIELD abq01
         LET l_count = 0
         IF NOT cl_null(l_newno1) THEN
            SELECT COUNT(*) INTO l_count
              FROM abq_file WHERE abq01 = l_newno1
            IF l_count >0 THEN  
               CALL cl_err('财务分析编号不能重复','!',0)
               LET l_newno1=''
               DISPLAY '' TO abq01
               NEXT FIELD abq01
            END IF
         END IF
 
      
      BEFORE FIELD abq00
         SELECT aza81 INTO g_aza.aza81 FROM aza_file
         LET l_newno2 = g_aza.aza81

      AFTER FIELD abq00
         IF cl_null(l_newno2) THEN
            CALL cl_err('帐套不能为空','!',0)
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(abq00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 =l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO abq00
               NEXT FIELD abq00
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
      DISPLAY g_abq01 TO abq01
      DISPLAY g_abq00 TO abq00
      RETURN
   END IF
 
   DROP TABLE i901_x
 
   SELECT * FROM abq_file             #單身複製
    WHERE abq01 = g_abq01
      AND abq00 = g_abq00
     INTO TEMP i901_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","i901_x",g_abq01,g_abq00,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE i901_x SET abq01=l_newno1,
                     abq00=l_newno2
 
   INSERT INTO abq_file SELECT * FROM i901_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","abq_file",l_newno1,l_newno2,SQLCA.sqlcode,"",g_msg,1)
      RETURN
   END IF
   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldno1 = g_abq01
   LET l_oldno2 = g_abq00
   SELECT abq00,abq01 INTO g_abq00,g_abq01
     FROM abq_file WHERE abq01 = l_newno1 AND abq00 = l_newno2
   CALL i901_u()
   CALL i901_b()
 
   LET g_abq01 = l_oldno1
   LET g_abq00 = l_oldno2
   CALL i901_show()
   DISPLAY BY NAME g_abq01,g_abq00
 
END FUNCTION
 
 
FUNCTION i901_r()
   DEFINE l_sql   STRING
   DEFINE l_cnt   LIKE type_file.num5         
 
   IF cl_null(g_abq01) OR cl_null(g_abq02) OR cl_null(g_abq00) THEN
      CALL cl_err('',-400,1)
      RETURN                             
   END IF
 
   LET l_sql = "SELECT COUNT(npp01)",
               "  FROM abq_file,npp_file",
               " WHERE nppsys ='CC'",
               "   AND npp00  =2",
               "   AND npp01  =abq18",
               "   AND npp011 =1",
               "   AND npptype='0'",
               "   AND abq01=",g_abq01,
               "   AND abq02=",g_abq02,
               "   AND abq00=",g_abq00 
   PREPARE i901_r_p1 FROM l_sql
   IF STATUS THEN CALL cl_err('i901_r_p1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE i901_r_c1 CURSOR FOR i901_r_p1
   OPEN i901_r_c1
   FETCH i901_r_c1 INTO l_cnt
 
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL  
   LET g_doc.column1 = "abq01" 
   LET g_doc.column2 = "abq02" 
   LET g_doc.column3 = "abq00" 
   LET g_doc.value1 = g_abq01  
   LET g_doc.value2 = g_abq02 
   LET g_doc.value3 = g_abq00
   DELETE FROM abq_file WHERE abq01=g_abq01
                          AND abq02=g_abq02
                          AND abq00=g_abq00
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","abq_file",g_abq01,g_abq02,SQLCA.sqlcode,"","del abq",1)
      RETURN      
   END IF   
 
   INITIALIZE g_abq01,g_abq02,g_abq00 TO NULL
   MESSAGE ""
 
   DROP TABLE i901_cnttmp
   LET l_sql="SELECT DISTINCT abq01,abq02,abq00 FROM abq_file",
             " WHERE ", g_wc CLIPPED,
             " INTO TEMP i901_cnttmp"
   PREPARE i901_cnttmp_p1 FROM l_sql
   PREPARE i901_cnttmp_p12 FROM g_sql_tmp
   EXECUTE i901_cnttmp_p12              
    
   OPEN i901_count
   IF STATUS THEN
      CLOSE i901_bcs
      CLOSE i901_count
      COMMIT WORK
      RETURN
   END IF
   FETCH i901_count INTO g_row_count
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i901_bcs
      CLOSE i901_count
      COMMIT WORK
      RETURN
   END IF
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i901_bcs
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL i901_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE 
      CALL i901_fetch('/')
   END IF
END FUNCTION
 
FUNCTION i901_out()
   DEFINE sr           RECORD LIKE abq_file.*,
          l_i          LIKE type_file.num5,              
          l_name       LIKE type_file.chr20,            
          l_za05       LIKE za_file.za05               
   DEFINE l_str         STRING
   
   IF g_wc IS NULL THEN 
      IF NOT cl_null(g_abq01) AND NOT cl_null(g_abq00) THEN
         LET g_wc=" AND abq01=",g_abq01,
                  " AND abq00=",g_abq00
      ELSE
         CALL cl_err('',-400,0)
         RETURN 
      END IF
   END IF
   CALL cl_wait()
   
   CALL cl_del_data(l_table)    
   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='agli901'  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT * FROM abq_file ",          # 組合出 SQL 指令
             " WHERE 1=1 AND ",g_wc CLIPPED,
             " ORDER BY abq01,abq00,abq03"
   PREPARE i901_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i901_c1 CURSOR FOR i901_p1        # SCROLL CURSOR
 
 
   FOREACH i901_c1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)    
         EXIT FOREACH
      END IF
      EXECUTE insert_prep USING 
           sr.abq01,sr.abq02,sr.abq00,sr.abq03,sr.abq04,sr.abq05,sr.abq06,
           sr.abq07,sr.abq08,sr.abq09,sr.abq10,sr.abq11
   END FOREACH
   
   
   IF g_zz05='Y'  THEN 
      CALL cl_wcchp(g_wc,'abq01,abq02,abq00,abq03,abq04,abq05,abq06,abq061,abq07,abq08,abq09,abq10,abq11,abq12,abq15,abq16,abq17,abq18,abq19,abq13,abq14')                                                         RETURNING l_str
   ELSE
      LET l_str = "" 	  
   END IF
  
    LET l_str = l_str CLIPPED ,";",g_prog CLIPPED       
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_prog="agli901"   
   	  
   CALL cl_prt_cs3('agli901','agli901',g_sql,l_str)
 
   CLOSE i901_c1
   ERROR ""
END FUNCTION
 

FUNCTION i901_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("abq01,abq00",TRUE)
    END IF

END FUNCTION

FUNCTION i901_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("abq01,abq00",FALSE)
    END IF

END FUNCTION

FUNCTION i901_formula(p_abq07)
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE p_abq07     LIKE abq_file.abq07
   DEFINE l_num       LIKE type_file.num5
   DEFINE l_num1      LIKE type_file.num5
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_str       STRING
   DEFINE l_str1      STRING
   DEFINE i           LIKE type_file.num5

   LET l_flag = 'N'
   CALL i901_abq07(p_abq07) RETURNING l_num
   LET dis_result = p_abq07
   LET tm.abo01 = Null
   LET tm.e     = Null
   
   OPEN WINDOW i9011_w AT p_row,p_col WITH FORM "agl/42f/agli901_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("agli901_1")
      CALL cl_set_head_visible("","YES")

      WHILE TRUE
         INPUT BY NAME tm.abo01,tm.e WITHOUT DEFAULTS

            BEFORE INPUT
               DISPLAY dis_result TO msg
            
            AFTER FIELD abo01
               IF NOT cl_null(tm.abo01) THEN
                  SELECT COUNT(*) INTO l_cnt FROM abo_file WHERE abo01 = tm.abo01 AND abo00 = g_abq00
                  IF l_cnt > 0 THEN
                     LET dis_result = dis_result,tm.abo01
                     DISPLAY dis_result TO msg
                     IF l_num = 0 THEN
                        LET dis_x[1] = tm.abo01
                     ELSE
                        LET l_num = l_num + 1
                        LET dis_x[l_num] = tm.abo01
                     END IF
                  ELSE
                     CALL cl_err(tm.abo01,"agl-281",1)
                     NEXT FIELD abo01
                  END IF
               END IF

            AFTER FIELD e
               IF NOT cl_null(tm.e) THEN
                  LET dis_result = dis_result,tm.e
                  DISPLAY dis_result TO msg
                  IF l_num = 0 THEN
                     LET dis_x[1] = tm.abo01
                  ELSE
                     LET l_num = l_num + 1
                     LET dis_x[l_num] = tm.abo01
                  END IF
               END IF

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT

            ON ACTION Calloff
               IF l_num = 0 THEN
               ELSE
                  LET l_str1 = dis_x[l_num]
                  LET l_num1 = dis_result.getlength() - l_str1.getlength()
                  LET dis_result = dis_result.subString(1,l_num1)
                  LET l_num = l_num - 1
                  DISPLAY dis_result TO msg
               END IF

            ON ACTION controlp
               CASE
                  WHEN INFIELD(abo01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_abo"
                     LET g_qryparam.default1= tm.abo01
                     CALL cl_create_qry() RETURNING tm.abo01
                     NEXT FIELD abo01
               END CASE
       
            ON ACTION exit
               LET l_flag = 'Y'
               EXIT INPUT

            ON ACTION accept
               LET l_flag = 'Y'
               EXIT INPUT
         END INPUT
         IF INT_FLAG THEN
            LET l_flag = 'Y'
            LET INT_FLAG = 0
         END IF
         
         IF l_flag = 'Y' THEN
            LET g_abq[l_ac].abq07 = dis_result
            EXIT WHILE
         END IF
      END WHILE

   CLOSE WINDOW i9011_w
   
END FUNCTION

FUNCTION i901_abq07(p_abq07)
   DEFINE p_abq07      LIKE abq_file.abq07
   DEFINE l_str        STRING
   DEFINE l_str1       STRING
   DEFINE l_str2       STRING
   DEFINE l_num,l_num1 LIKE type_file.num5
   DEFINE i            LIKE type_file.num5

   IF cl_null(p_abq07) THEN
      RETURN 1
   ELSE
      LET dis_x = NULL
      LET l_num1 = 1
      LET l_str = p_abq07
      LET l_str1= Null
      LET l_num = l_str.getlength()
      FOR i = 1 TO l_num
         LET l_str1 = l_str.subString(i,i)
         IF l_str1 NOT MATCHES '[a-z]' AND l_str1 NOT MATCHES '[A-Z]' THEN
            IF NOT cl_null(l_str2) THEN
               LET dis_x[l_num1]=l_str2
               LET l_str2 = NULL
               LET l_num1 = l_num1 + 1
            END IF
            LET dis_x[l_num1]=l_str1
            LET l_str1 = NULL
            LET l_num1 = l_num1 + 1
         ELSE
            LET l_str2 = l_str2,l_str1
         END IF
      END FOR
      IF NOT cl_null(l_str2) THEN
         LET dis_x[l_num1]=l_str2
      END IF
   END IF
   RETURN l_num1
   
END FUNCTION
