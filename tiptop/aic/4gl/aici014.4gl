# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aici014.4gl
# Descriptions...: 收貨替代群組維護作業
# Date & Author..: 07/11/15 By jan
# Modify.........: No.FUN-7B0073 By jan 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-C30289 12/04/03 By bart 1.所有程式的Multi Die隱藏2.控卡ico03不可輸入8
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ico01         LIKE ico_file.ico01,   
       g_ico02         LIKE ico_file.ico02, 
       g_ico03         LIKE ico_file.ico03,  
       g_ico01_t       LIKE ico_file.ico01,   
       g_ico02_t       LIKE ico_file.ico02,   
       g_ico03_t       LIKE ico_file.ico03,
       g_ico           DYNAMIC ARRAY OF RECORD
                          ico04             LIKE ico_file.ico04, 
                          ico05             LIKE ico_file.ico05, 
                          ico06             LIKE ico_file.ico06
                       END RECORD,
       g_ico_t         RECORD                     #程式變數 (舊值)
                          ico04             LIKE ico_file.ico04, 
                          ico05             LIKE ico_file.ico05, 
                          ico06             LIKE ico_file.ico06
                       END RECORD,
 
       g_wc,g_sql,g_sql1      STRING,      
       g_rec_b         LIKE type_file.num5,        #單身筆數  
       l_sql           STRING,
       g_ico03_input    LIKE ico_file.ico03,
       l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_forupd_sql    STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10   
DEFINE g_msg           LIKE ze_file.ze03      
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10   
DEFINE g_jump          LIKE type_file.num10   
DEFINE mi_no_ask       LIKE type_file.num5 
DEFINE g_argv1         LIKE ico_file.ico01
DEFINE g_argv2         LIKE ico_file.ico02
DEFINE g_argv3         LIKE ico_file.ico03 
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_ss            LIKE type_file.chr1
DEFINE g_str           STRING
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                                 #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   
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

   CALL aici014()
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION aici014_type_sel()
 
   OPEN WINDOW i014a_w WITH FORM "aic/42f/aici014a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("ico03_8",FALSE)  #FUN-C30289
 
   INPUT g_ico03_input WITHOUT DEFAULTS FROM ico03
 
       AFTER FIELD ico03
          IF NOT cl_null(g_ico03_input) THEN
             IF g_ico03_input NOT MATCHES '[12345679]' THEN  #FUN-C30289
                NEXT FIELD ico03
             END IF
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG
             CALL cl_cmdask()
 
          ON ACTION CONTROLF
             CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
             CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION help
             CALL cl_show_help()
 
          ON ACTION about
             CALL cl_about()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i014a_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION aici014()
 
   IF NOT cl_null(g_argv3) THEN
      IF g_argv3 = 'axmt410_icd' OR
         g_argv3 = 'asfi301_icd' THEN
         CALL aici014_type_sel()
      END IF
   END IF
 
   LET g_ico01 = NULL               
   LET g_ico02 = NULL             
   LET g_ico01_t = NULL
   LET g_ico02_t = NULL
   LET g_ico03 = NULL
   LET g_ico03_t = NULL
 
   OPEN WINDOW i014_w WITH FORM "aic/42f/aici014"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_visible("ico03_8",FALSE)  #FUN-C30289
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN 
      CALL i014_q()
 
      IF cl_null(g_ico03_input) THEN  
         LET g_cnt = 0                                                        
         SELECT COUNT(*) INTO g_cnt                                           
           FROM ico_file                                     
          WHERE ico01 = g_argv1
            AND ico02 = g_argv2   
         IF g_cnt = 0 THEN                                                    
            CALL i014_a()                                                 
         END IF
      ELSE
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM ico_file
          WHERE ico01 = g_argv1
            AND ico02 = g_argv2
            AND ico03 = g_ico03_input
         IF g_cnt = 0 THEN
            CALL i014_a()
         END IF
      END IF
   END IF
 
   CALL i014_menu()
 
   CLOSE WINDOW i014_w                
END FUNCTION
 
FUNCTION i014_curs()
 
  CLEAR FORM                           
   CALL g_ico.clear()
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_ico01 = g_argv1
      LET g_ico02 = g_argv2
      DISPLAY g_ico01 TO ico01
      DISPLAY g_ico02 TO ico02
      LET g_wc = "ico01 ='",g_argv1,"'",
            " AND ico02 ='",g_argv2,"'"
      IF NOT cl_null(g_ico03_input) THEN
         LET g_ico03 = g_ico03_input
         DISPLAY g_ico03 TO ico03
         LET g_wc = g_wc CLIPPED," AND ico03 = '",g_ico03 CLIPPED,"'"
      END IF  
  ELSE
 
      CONSTRUCT g_wc ON ico01,ico02,ico03,ico04,ico05,ico06 
                   FROM ico01,ico02,ico03,s_ico[1].ico04,
                        s_ico[1].ico05,s_ico[1].ico06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 CALL g_ico.clear()
         
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icouser', 'icogrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
  END IF
  
   LET g_sql= "SELECT UNIQUE ico01,ico02,ico03 FROM ico_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY ico01"
   PREPARE i014_prepare FROM g_sql      #預備一下
   DECLARE i014_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i014_prepare
 
   LET g_sql1="SELECT UNIQUE ico01,ico02,ico03 FROM ico_file WHERE ",g_wc CLIPPED,"INTO TEMP x "
   DROP TABLE x
   PREPARE i014_precount_x FROM g_sql1
   EXECUTE i014_precount_x
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i014_precount FROM g_sql
   DECLARE i014_count CURSOR FOR i014_precount
 
END FUNCTION
 
FUNCTION i014_menu()
 
   WHILE TRUE
      CALL i014_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i014_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i014_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i014_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i014_u()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i014_out()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i014_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i014_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ico),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                IF g_ico01 IS NOT NULL THEN
                 LET g_doc.column1 = "ico01"
                 LET g_doc.value1 = g_ico01
                 CALL cl_doc()
                END IF 
              END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i014_a()
  DEFINE  l_cnt  LIKE type_file.num5
  
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_ico.clear()
   INITIALIZE g_ico03 LIKE ico_file.ico03
   LET g_ico03_t = NULL
   
   IF NOT cl_null(g_ico03_input) THEN
      LET g_ico03 = g_ico03_input
   END IF
   
   LET g_wc = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL i014_i("a")                #輸入單頭
      IF INT_FLAG THEN                
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_ico01 = NULL
         LET g_ico02 = NULL
         LET g_ico03 = NULL
         DISPLAY g_ico01 TO ico01
         DISPLAY g_ico02 TO ico02
         DISPLAY g_ico03 TO ico03
         EXIT WHILE
      END IF
      IF g_ss='N' THEN
         LET g_rec_b = 0
         CALL g_ico.clear()
      ELSE
         CALL i014_b_fill('1=1')     
      END IF
 
      CALL i014_b()               
      LET g_ico01_t = g_ico01    
      LET g_ico02_t = g_ico02   
      LET g_ico03_t = g_ico03  
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i014_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ico01 IS NULL  OR cl_null(g_ico02)
       OR cl_null(g_ico03) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE " "
    CALL cl_opmsg('u')
    LET g_ico01_t = g_ico01
    LET g_ico02_t = g_ico02
    LET g_ico03_t = g_ico03
    
    BEGIN WORK
    
    WHILE TRUE
        CALL i014_i("u")       #欄位更改
        IF INT_FLAG THEN
           LET g_ico01 = g_ico01_t
           LET g_ico02 = g_ico02_t
           LET g_ico03 = g_ico03_t
           DISPLAY g_ico01 TO ico01
           DISPLAY g_ico02 TO ico02
           DISPLAY g_ico03 TO ico03
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF g_ico01 != g_ico01_t OR 
           g_ico02 != g_ico02_t OR 
           g_ico03 != g_ico03_t THEN
        UPDATE ico_file SET ico01 = g_ico01,
                            ico02 = g_ico02,
                            ico03 = g_ico03,
                            icomodu = g_user,
                            icodate = g_today
         WHERE ico01 = g_ico01_t
           AND ico02 = g_ico02_t
           AND ico03 = g_ico03_t
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_ico01,SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
         END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
  
FUNCTION i014_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改  
       l_n             LIKE type_file.num5,                  #檢查重復用
       l_n1            LIKE type_file.num5                   #檢查重復用
       
   LET g_ss = 'Y'
   LET g_ico01 = g_argv1
   LET g_ico02 = g_argv2
   DISPLAY g_ico01 TO ico01 
   DISPLAY g_ico02 TO ico02 
   DISPLAY g_ico03 TO ico03 
   CALL i014_set_entry(p_cmd)
   CALL i014_set_no_entry(p_cmd)
          
   INPUT g_ico03 WITHOUT DEFAULTS FROM ico03
   
   AFTER FIELD ico03 
            #FUN-C30289---begin
            IF NOT cl_null(g_ico03) THEN
               IF g_ico03 NOT MATCHES '[12345679]' THEN 
                  NEXT FIELD ico03
               END IF
            END IF  
            #FUN-C30289---end 
            IF cl_null(g_ico03_t) OR             
               g_ico03 != g_ico03_t THEN                     
                  
               SELECT UNIQUE ico01,ico02,ico03
                 FROM ico_file                       
                WHERE ico01 = g_ico01 
                  AND ico02 = g_ico02                     
                  AND ico03 = g_ico03                     
               IF SQLCA.sqlcode THEN                       
                  IF p_cmd='a' THEN                                      
                     LET g_ss='N'                                          
                  END IF                                                 
               ELSE 
                  IF p_cmd='u' THEN                                      
                     CALL cl_err('',-239,0)                           
                     LET g_ico03 = g_ico03_t 
                     NEXT FIELD ico03                                    
                  END IF                                                 
               END IF                                                        
            END IF
    
 
      ON ACTION CONTROLF                
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
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
 
FUNCTION i014_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i014_curs()                   #取得查詢條件
 
   IF INT_FLAG THEN                   #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ico01 TO NULL
      RETURN
   END IF
 
   OPEN i014_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ico01 TO NULL
      INITIALIZE g_ico02 TO NULL
      INITIALIZE g_ico03 TO NULL
   ELSE
      OPEN i014_count
      FETCH i014_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i014_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i014_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i014_b_curs INTO g_ico01,g_ico02,g_ico03
       WHEN 'P' FETCH PREVIOUS i014_b_curs INTO g_ico01,g_ico02,g_ico03
       WHEN 'F' FETCH FIRST    i014_b_curs INTO g_ico01,g_ico02,g_ico03
       WHEN 'L' FETCH LAST     i014_b_curs INTO g_ico01,g_ico02,g_ico03
       WHEN '/'
           IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                    CONTINUE PROMPT
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
 
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
 
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i014_b_curs INTO g_ico01,g_ico02,g_ico03
           LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_ico01,SQLCA.sqlcode,0)
        LET g_ico01 = NULL
        LET g_ico02 = NULL
        LET g_ico03 = NULL
        DISPLAY g_ico01 TO ico01
        DISPLAY g_ico02 TO ico02
        DISPLAY g_ico03 TO ico03
        RETURN
   ELSE
      CALL i014_show()
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
 
FUNCTION i014_show()
 
   DISPLAY g_ico01 TO ico01               #單頭
   DISPLAY g_ico02 TO ico02
   DISPLAY g_ico03 TO ico03
 
   CALL i014_b_fill(g_wc)                 #單身
 
   CALL cl_show_fld_cont()                   
 
END FUNCTION
 
 
FUNCTION i014_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ico01 IS NULL THEN
      CALL cl_err("",-400,0)                 
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ico01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ico01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM ico_file WHERE ico01 = g_ico01
                             AND ico02 = g_ico02
                             AND ico03 = g_ico03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ico_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_ico.clear()
         OPEN i014_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i014_b_curs
             CLOSE i014_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i014_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i014_b_curs
             CLOSE i014_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i014_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i014_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i014_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i014_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,                #檢查重複用  
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_cmd           LIKE type_file.chr1000,             #可新增否  
       l_ico04         LIKE ico_file.ico04,                #最大截止碼
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5                 #可刪除否  
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ico01 IS NULL OR cl_null(g_ico02) OR
      cl_null(g_ico03) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ico04,ico05,ico06",   
                      "  FROM ico_file",
                      "  WHERE ico01 = ? ",
                      "   AND ico02 = ? ",
                      "   AND ico03 = ? ",
                      "   AND ico04 = ? ",
                      " FOR UPDATE"  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i014_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ico WITHOUT DEFAULTS FROM s_ico.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_rec_b  = ARR_COUNT()
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ico_t.* = g_ico[l_ac].*  #BACKUP
            OPEN i014_bcl USING g_ico01,g_ico02,g_ico03,g_ico_t.ico04
            IF STATUS THEN
               CALL cl_err("OPEN i014_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i014_bcl INTO g_ico[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ico02_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               LET g_ico_t.* = g_ico[l_ac].*
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ico[l_ac].* TO NULL 
         LET g_ico[l_ac].ico05 = 'N'
         LET g_ico_t.* = g_ico[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ico04
 
      AFTER INSERT
         
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO ico_file(ico01,ico02,ico03,ico04,ico05,ico06,icouser,
                              icogrup,icomodu,icoacti,icodate,icooriu,icoorig)
                       VALUES(g_ico01,g_ico02,g_ico03,g_ico[l_ac].ico04,g_ico[l_ac].ico05,
                              g_ico[l_ac].ico06,g_user,g_grup,'','Y',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ico_file","","",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
            ROLLBACK WORK
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD ico04                                                                 
            IF cl_null(g_ico[l_ac].ico04) OR                                                                                 
               g_ico[l_ac].ico04 = 0 THEN                                                                                    
                                                                                                                                    
               SELECT max(ico04)+1 INTO g_ico[l_ac].ico04                                                                
                 FROM ico_file                                                                                                   
                WHERE ico01 = g_ico01
                  AND ico02 = g_ico02
                  AND ico03 = g_ico03
               IF cl_null(g_ico[l_ac].ico04) THEN                                                                            
                  LET g_ico[l_ac].ico04 = 1                                                                                  
               END IF                                                                                                               
           END IF
 
      AFTER FIELD ico04
         IF NOT cl_null(g_ico[l_ac].ico04) THEN
            IF g_ico[l_ac].ico04 < 1 THEN
               CALL cl_err('','apm-528',0)
               NEXT FIELD ico04
            END IF
            IF (g_ico_t.ico04 != g_ico[l_ac].ico04) OR
               cl_null(g_ico_t.ico04) THEN
              SELECT COUNT(*) INTO l_n
                FROM ico_file
               WHERE ico01=g_ico01
                 AND ico02=g_ico02
                 AND ico03=g_ico03
                 AND ico04=g_ico[l_ac].ico04
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_ico[l_ac].ico04 = g_ico_t.ico04
                NEXT FIELD ico04
             END IF
            END IF
         END IF
 
      AFTER FIELD ico05
        IF NOT cl_null(g_ico[l_ac].ico05) THEN
           IF g_ico[l_ac].ico05 NOT MATCHES '[YN]' THEN
              NEXT FIELD ico05
           END IF
        END IF
           
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ico_t.ico04) THEN
            IF NOT cl_delb(0,0) THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ico_file
             WHERE ico01=g_ico01
               AND ico02=g_ico02
               AND ico03=g_ico03
               AND ico04=g_ico_t.ico04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ico_file","","",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ico[l_ac].* = g_ico_t.*
            CLOSE i014_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ico[l_ac].ico04,-263,1)
            LET g_ico[l_ac].* = g_ico_t.*
         ELSE
            UPDATE ico_file SET ico04=g_ico[l_ac].ico04,
                                ico05=g_ico[l_ac].ico05,
                                ico06=g_ico[l_ac].ico06,
                                icomodu=g_user,
                                icodate=g_today
             WHERE ico01=g_ico01
               AND ico02=g_ico02
               AND ico03=g_ico03
               AND ico04=g_ico_t.ico04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ico","ico_file","","",SQLCA.sqlcode,"","",1)  
               LET g_ico[l_ac].* = g_ico_t.*
               ROLLBACK WORK
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
            IF p_cmd = 'u' THEN
               LET g_ico[l_ac].* = g_ico_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_ico.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i014_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030 #FUN-D40030 add
         CLOSE i014_bcl
         COMMIT WORK
 
 
      
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT
 
   CLOSE i014_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i014_b_askkey()
DEFINE
#   l_wc            LIKE type_file.chr1000 
   l_wc      STRING      #NO.FUN-910082
 
   CONSTRUCT l_wc ON ico04,ico05,ico06
                FROM s_ico[1].ico04,s_ico[1].ico05,s_ico[1].ico06
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   CALL i014_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i014_b_fill(p_wc)              #BODY FILL UP
DEFINE 
   #p_wc            LIKE type_file.chr1000 
   p_wc          STRING    #NO.FUN-910082
   
   IF cl_null(p_wc) THEN                                                                                                           
       LET p_wc = ' 1=1'                                                                                                            
   END IF 
   LET g_sql = " SELECT ico04,ico05,ico06 FROM ico_file ",  
               " WHERE ico01 = '",g_ico01,"'",
               "   AND ico02 = '",g_ico02,"'",
               "   AND ico03 = '",g_ico03,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY ico04"
   PREPARE i014_prepare2 FROM g_sql       #預備一下
   DECLARE ico_curs CURSOR FOR i014_prepare2
 
   CALL g_ico.clear()
   LET g_cnt = 1
 
   FOREACH ico_curs INTO g_ico[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_ico.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i014_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ico TO s_ico.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
            
#     ON ACTION modify
#        LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i014_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY          
 
 
      ON ACTION previous
         CALL i014_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY                  
 
 
      ON ACTION jump
         CALL i014_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY                  
 
 
      ON ACTION next
         CALL i014_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY          
 
 
      ON ACTION last
         CALL i014_fetch('L')
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
             LET INT_FLAG=FALSE                 #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i014_copy()
DEFINE l_newno,l_oldno1  LIKE ico_file.ico03,
       l_newico01,l_oldno2  LIKE ico_file.ico01,
       l_newico02,l_oldno3  LIKE ico_file.ico02,
       l_n               LIKE type_file.num5,    
       l_ima02           LIKE ima_file.ima02,
       l_ima021          LIKE ima_file.ima021
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ico01 IS NULL OR cl_null(g_ico02) 
      OR cl_null(g_ico03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           
   INPUT l_newno FROM ico03 
 
      AFTER FIELD ico03
         #FUN-C30289---begin
         IF NOT cl_null(l_newno) THEN
            IF l_newno NOT MATCHES '[12345679]' THEN 
               NEXT FIELD ico03
            END IF
         END IF  
         #FUN-C30289---end 
         IF NOT cl_null(l_newno) THEN
            LET l_n = 0
            SELECT count(*) INTO l_n
              FROM ico_file
             WHERE ico03=l_newno
               AND ico01=g_argv1
               AND ico02=g_argv2
            IF l_n > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD ico03
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
      DISPLAY  g_ico03 TO ico03
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ico_file WHERE ico01 = g_argv1
                            AND ico02 = g_argv2  
                            AND ico03 = g_ico03  
                           INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ico_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET ico03 = l_newno,
                ico01 = g_argv1,
                ico02 = g_argv2,
                icouser = g_user,
                icogrup = g_grup,
                icodate = g_today,
                icoacti = 'Y'
 
   INSERT INTO ico_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ico_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno1= g_ico03
   LET g_ico03=l_newno
 
   CALL i014_u()
   CALL i014_b()
   #LET g_ico03=l_oldno1  #FUN-C30027
   #CALL i014_show()      #FUN-C30027
END FUNCTION
 
 
FUNCTION i014_set_entry(p_cmd)
DEFINE  p_cmd  LIKE type_file.chr1
 
   CALL cl_set_comp_entry("ico03",TRUE)
 
END FUNCTION
 
FUNCTION i014_set_no_entry(p_cmd)
DEFINE  p_cmd  LIKE type_file.chr1
 
   IF NOT cl_null(g_ico03_input) THEN 
      CALL cl_set_comp_entry("ico03",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i014_out()
    DEFINE
       l_i      LIKE type_file.num5,
       l_name   LIKE type_file.chr20,
       l_za05   LIKE za_file.za05
       
    IF g_wc IS NULL THEN
       IF NOT cl_null(g_ico01) THEN
          LET g_wc=" ico01=",g_ico01," and ico02=",g_ico02," and ico03=",g_ico03
       ELSE
          CALL cl_err('','9057',0) RETURN
       END IF
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET g_sql="SELECT ico01,ico02,ico03,ico04,ico05,ico06 ",
              "  FROM ico_file ",
              " WHERE ",g_wc CLIPPED
    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'ico01,ico02,ico03,ico04,ico05,ico06')
       RETURNING g_wc
    END IF
    LET g_str = g_wc
    CALL cl_prt_cs1('aici014','aici014',g_sql,g_str)
END FUNCTION
#No.FUN-7B0073
