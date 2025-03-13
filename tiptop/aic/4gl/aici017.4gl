# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aici017.4gl
# Descriptions...: ICD 自動編碼規格維護作業 
# Date & Author..: No.FUN-7B0014 07/11/12 By bnlent 
# Modify.........: No.MOD-840164 08/04/20 By kim 先查詢後,執行新增,[編碼原則]及[編碼代號]未先清空.
# Modify.........: No.MOD-860317 08/06/27 By wujie 單身選流水碼時，不應該直接抓sma119來比較長度，應該取sma119的值所對應的長度
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70145 10/07/30 by alex 調整SQL語法
# Modify.........: No.FUN-A90024 10/11/16 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BC0106 12/01/16 By jason單身icr06新增開窗選項ima_file
# Modify.........: No.TQC-C30132 12/03/08 By bart icr06資料表型態為ima_file時,過濾非ima_file
# Modify.........: No.MOD-C30328 12/03/10 By bart 修改欄位長度取法
# Modify.........: No.FUN-C30207 12/03/15 By bart 編碼性質保留4，其他先拿掉
# Modify.........: No:TQC-C40222 12/04/23 By chenjing  單身預設上一筆
# Modify.........: No:MOD-C90026 12/09/05 By Elise 修正複製功能、日期性質
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_icr01           LIKE icr_file.icr01,
    g_icr01_t         LIKE icr_file.icr01,
    g_icr02           LIKE icr_file.icr02,
    g_icr02_t         LIKE icr_file.icr02,   
    g_icr             DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        icr03         LIKE icr_file.icr03,
        icr04         LIKE icr_file.icr04,
        icr05         LIKE icr_file.icr05,
        icr06         LIKE icr_file.icr06,
        icr06_desc    LIKE gat_file.gat03,
        icr061        LIKE icr_file.icr061,
        icr061_desc   LIKE gaq_file.gaq03,
        icr07         LIKE icr_file.icr07,
        icr08         LIKE icr_file.icr08
                      END RECORD,
    g_icr_t           RECORD                 #程式變數 (舊值)
        icr03         LIKE icr_file.icr03,
        icr04         LIKE icr_file.icr04,
        icr05         LIKE icr_file.icr05,
        icr06         LIKE icr_file.icr06,
        icr06_desc    LIKE gat_file.gat03,
        icr061        LIKE icr_file.icr061,
        icr061_desc   LIKE gaq_file.gaq03,
        icr07         LIKE icr_file.icr07,
        icr08         LIKE icr_file.icr08
                      END RECORD,
    a                 LIKE type_file.chr1,    
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,   
    g_rec_b           LIKE type_file.num5,  
    g_flag            LIKE type_file.chr1, 
    g_ss              LIKE type_file.chr1,
    l_ac              LIKE type_file.num5,
    g_argv1           LIKE icr_file.icr01,
    g_argv2           LIKE icr_file.icr02
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   
DEFINE   g_before_input_done   LIKE type_file.num5    
DEFINE   g_cnt                 LIKE type_file.num10    
DEFINE   g_msg         LIKE ze_file.ze03  
DEFINE   g_row_count   LIKE type_file.num10    
DEFINE   g_curs_index  LIKE type_file.num10    
DEFINE   l_cmd         LIKE type_file.chr1000  
DEFINE   li_inx        LIKE type_file.num5   
DEFINE   ls_str        STRING                 


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
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
 
   OPEN WINDOW i017_w WITH FORM "aic/42f/aici017"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_entry("icr02",FALSE)  #FUN-C30207
 
   IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN
      CALL i017_q()
   END IF   
   CALL i017_menu()
 
   CLOSE WINDOW i017_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i017_cs()
DEFINE l_sql STRING
 
    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN
       LET g_wc = " icr01 = '",g_argv1,"'",
                  " AND icr02 = '",g_argv2,"'"
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_icr.clear()
       CALL cl_set_head_visible("","YES")    
 
   INITIALIZE g_icr01 TO NULL    
   INITIALIZE g_icr02 TO NULL    
       #CONSTRUCT g_wc ON icr01,icr02,icr03,icr04,icr05,icr06,icr061,icr07,icr08   #FUN-C30207
       CONSTRUCT g_wc ON icr01,icr03,icr04,icr05,icr06,icr061,icr07,icr08#FUN-C30207
          #FROM icr01,icr02,s_icr[1].icr03,s_icr[1].icr04,s_icr[1].icr05,#FUN-C30207
          FROM icr01,s_icr[1].icr03,s_icr[1].icr04,s_icr[1].icr05,
               s_icr[1].icr06,s_icr[1].icr061,s_icr[1].icr07,s_icr[1].icr08
               
       
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(icr06)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_icr06"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO icr06
                NEXT FIELD icr06
             WHEN INFIELD(icr061)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_icr061"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO icr061
                NEXT FIELD icr061
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE icr01,icr02 FROM icr_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY icr01"
    PREPARE i017_prepare FROM g_sql      #預備一下
    DECLARE i017_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i017_prepare
 
    DROP TABLE i017_cnttmp
 
    LET g_sql_tmp=l_sql," INTO TEMP i017_cnttmp"  
    
 
    PREPARE i017_cnttmp_pre FROM g_sql_tmp   
    EXECUTE i017_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i017_cnttmp"      
    
    PREPARE i017_precount FROM g_sql    
    DECLARE i017_count CURSOR FOR i017_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_icr01=g_argv1
    END IF
 
    IF NOT cl_null(g_argv2) THEN
       LET g_icr02=g_argv2
    END IF
 
    CALL i017_show()
END FUNCTION
 
FUNCTION i017_menu()
 
   WHILE TRUE
      CALL i017_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL i017_a()
               END IF
            END IF
         #WHEN "modify"                          # U.修改
         #   IF cl_chk_act_auth() THEN
         #      CALL i017_u()
         #   END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i017_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i017_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i017_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i017_b()
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
               LET l_cmd = 'p_query "aici017" "',g_wc CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd) 
            END IF
        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_icr),'','')
            END IF
         
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_icr01 IS NOT NULL THEN
                LET g_doc.column1 = "icr01"
                LET g_doc.column2 = "icr02"
                LET g_doc.value1 = g_icr01
                LET g_doc.value2 = g_icr02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i017_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_icr.clear()
   LET g_icr01    = NULL #MOD-840164
   #LET g_icr02    = NULL #MOD-840164
   LET g_icr02    = '4'   #FUN-C30207
   LET g_icr01_t  = NULL
   LET g_icr02_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i017_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_icr01=NULL
         LET g_icr02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_icr.clear()
      ELSE
         CALL i017_b_fill('1=1')         #單身
      END IF
 
      CALL i017_b()                      #輸入單身
 
      LET g_icr01_t = g_icr01
      LET g_icr02_t = g_icr02
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i017_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   
    l_cnt           LIKE type_file.num10       
 
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")         
 
    INPUT g_icr01,g_icr02 WITHOUT DEFAULTS
        FROM icr01,icr02
 
       AFTER INPUT
       
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
 
FUNCTION i017_q()
   LET g_icr01 = ''
   LET g_icr02 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_icr01,g_icr02 TO NULL       
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL g_icr.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i017_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_icr01,g_icr02 TO NULL
      RETURN
   END IF
 
   OPEN i017_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_icr01,g_icr02 TO NULL
   ELSE
      OPEN i017_count
      FETCH i017_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i017_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i017_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   
   l_abso          LIKE type_file.num10   #絕對的筆數  
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i017_bcs INTO g_icr01,g_icr02
       WHEN 'P' FETCH PREVIOUS i017_bcs INTO g_icr01,g_icr02
       WHEN 'F' FETCH FIRST    i017_bcs INTO g_icr01,g_icr02
       WHEN 'L' FETCH LAST     i017_bcs INTO g_icr01,g_icr02
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  #add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         
                  CALL cl_about()      
              
               ON ACTION help          
                  CALL cl_show_help()  
              
               ON ACTION controlg      
                  CALL cl_cmdask()     
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i017_bcs INTO g_icr01,g_icr02
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_icr01,SQLCA.sqlcode,0)
      INITIALIZE g_icr01 TO NULL  
      INITIALIZE g_icr02 TO NULL  
   ELSE
      CALL i017_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i017_show()
 
   DISPLAY g_icr01 TO icr01
   DISPLAY g_icr02 TO icr02
 
   CALL i017_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   
END FUNCTION
 
#單身
FUNCTION i017_b()
DEFINE l_ac_t          LIKE type_file.num5          #未取消的ARRAY CNT 
DEFINE l_n             LIKE type_file.num5          #檢查重複用        
DEFINE l_lock_sw       LIKE type_file.chr1          #單身鎖住否        
DEFINE p_cmd           LIKE type_file.chr1          #處理狀態          
DEFINE l_allow_insert  LIKE type_file.num5          #可新增否          
DEFINE l_allow_delete  LIKE type_file.num5          #可刪除否          
DEFINE l_cnt           LIKE type_file.num10          
DEFINE l_sma119        LIKE sma_file.sma119
DEFINE l_ztb04         LIKE ztb_file.ztb04
DEFINE l_db_type       STRING
DEFINE l_sql           STRING
DEFINE l_flag          LIKE type_file.chr1
DEFINE l_type          LIKE ahe_file.ahe04
DEFINE l_data_length   LIKE type_file.num5
   LET g_action_choice = ""
 
   IF cl_null(g_icr01) OR cl_null(g_icr02) OR (g_icr01=0) OR (g_icr01=0) THEN
      CALL cl_err('',-400,1)
      RETURN     
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_db_type=cl_db_get_database_type()
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT icr03,icr04,icr05,icr06,'',icr061,'',icr07,icr08 FROM icr_file",
                      " WHERE icr01 = ? AND icr02= ? AND icr03= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i017_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_icr.clear() END IF
 
   INPUT ARRAY g_icr WITHOUT DEFAULTS FROM s_icr.*
 
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
            LET g_icr_t.* = g_icr[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i017_bcl USING g_icr01,g_icr02,g_icr[l_ac].icr03
            IF STATUS THEN
               CALL cl_err("OPEN i017_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i017_bcl INTO g_icr[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i017_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i017_icr06_desc(g_icr[l_ac].icr06) RETURNING g_icr[l_ac].icr06_desc
                  CALL i017_icr061_desc(g_icr[l_ac].icr061) RETURNING g_icr[l_ac].icr061_desc
                  LET g_icr_t.*=g_icr[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_icr[l_ac].* TO NULL            
         LET g_icr_t.* = g_icr[l_ac].*               #新輸入資料
         LET g_icr[l_ac].icr04=1
         CALL cl_show_fld_cont()
         NEXT FIELD icr03
 
      BEFORE FIELD icr03
         CALL cl_set_comp_entry("icr03",TRUE)
         IF g_icr[l_ac].icr03 IS NULL OR g_icr[l_ac].icr03 = 0 THEN
            SELECT MAX(icr03)+1 INTO g_icr[l_ac].icr03
              FROM icr_file
             WHERE icr01 = g_icr01
               AND icr02 = g_icr02
             IF g_icr[l_ac].icr03 IS NULL THEN
                LET g_icr[l_ac].icr03 = 1
             END IF
         END IF
      AFTER FIELD icr03
         IF NOT cl_null(g_icr[l_ac].icr03) THEN
            IF g_icr[l_ac].icr03 != g_icr_t.icr03
               OR g_icr_t.icr03 IS NULL THEN
               SELECT COUNT(*)
                 INTO l_n
                 FROM icr_file
                WHERE icr01 = g_icr01
                  AND icr02 = g_icr02
                  AND icr03 = g_icr[l_ac].icr03
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_icr[l_ac].icr03 = g_icr_t.icr03
                   NEXT FIELD icr03
                END IF
             END IF
          END IF
          IF p_cmd <> 'a' THEN   # 新增時, 准, 修改, 不准
             CALL cl_set_comp_entry("icr03",FALSE)
          END IF
      AFTER FIELD icr04
         IF NOT cl_null(g_icr[l_ac].icr04) THEN
            CASE g_icr[l_ac].icr04
              WHEN '1' LET g_icr[l_ac].icr06 = ''
                       LET g_icr[l_ac].icr061 = ''
                       LET g_icr[l_ac].icr08 = ''
                       CALL cl_set_comp_entry("icr05",TRUE)
                       CALL cl_set_comp_entry("icr06,icr061",FALSE)
                       
              WHEN '2' LET g_icr[l_ac].icr05 = ''
                       CALL cl_set_comp_entry("icr05",FALSE)
                       CALL cl_set_comp_entry("icr06,icr061",TRUE)
 
              WHEN '3' LET g_icr[l_ac].icr05 = ''
                       LET g_icr[l_ac].icr06 = ''
                       LET g_icr[l_ac].icr061 = ''
                       LET g_icr[l_ac].icr08 = ''
                       CALL cl_set_comp_entry("icr05,icr06,icr061",FALSE)
                       SELECT MAX(icr03) INTO l_n FROM icr_file
                        WHERE icr01 = g_icr01
                          AND icr02 = g_icr02
                       IF l_n > g_icr[l_ac].icr03 THEN
                          CALL cl_err('','aic-001',1)
                          NEXT FIELD icr04
                       END IF
            END CASE
         END IF
 
      AFTER FIELD icr05
         IF g_icr[l_ac].icr04 = '1' THEN
            IF cl_null(g_icr[l_ac].icr05) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD icr05
            END IF
            LET g_icr[l_ac].icr07 = LENGTH(g_icr[l_ac].icr05)
         END IF
 
      AFTER FIELD icr06
         IF g_icr[l_ac].icr04 = '2' THEN
            IF cl_null(g_icr[l_ac].icr06) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD icr06
            END IF
            SELECT COUNT(*) INTO l_n FROM gat_file 
             WHERE gat01 = g_icr[l_ac].icr06
               IF l_n = 0 THEN
                  CALL cl_err('','-6001',0)
                  NEXT FIELD icr06
               END IF
         END IF
         IF NOT cl_null(g_icr[l_ac].icr06) THEN
            CALL i017_icr06_desc(g_icr[l_ac].icr06) RETURNING g_icr[l_ac].icr06_desc
            DISPLAY BY NAME g_icr[l_ac].icr06_desc
            IF g_icr[l_ac].icr06 <> g_icr_t.icr06
            OR g_icr_t.icr06 IS NULL THEN
            LET g_icr[l_ac].icr061 = NULL
            LET g_icr[l_ac].icr061_desc = NULL
            END IF
         END IF
      AFTER FIELD icr061
         IF g_icr[l_ac].icr04 = '2' THEN
            IF cl_null(g_icr[l_ac].icr061) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD icr061
            END IF
            SELECT COUNT(*) INTO l_n FROM gaq_file 
             WHERE gaq01 = g_icr[l_ac].icr061
               IF l_n = 0 THEN
                  CALL cl_err('','-6001',0)
                  NEXT FIELD icr061
               END IF
         END IF
         IF NOT cl_null(g_icr[l_ac].icr061) THEN
            CALL i017_icr061_desc(g_icr[l_ac].icr061) RETURNING g_icr[l_ac].icr061_desc
            DISPLAY BY NAME g_icr[l_ac].icr061_desc
            IF g_icr[l_ac].icr061 <> g_icr_t.icr061
            OR g_icr_t.icr061 IS NULL THEN
               LET g_icr[l_ac].icr08 = NULL
            END IF
           #MOD-C90026--MOD--S----
            LET l_flag = cl_get_column_datetype('',g_icr[l_ac].icr061 CLIPPED)            
            IF l_flag = 'Y' THEN  
           #SELECT ztb04 INTO l_ztb04 FROM ztb_file
           # WHERE ztb01 = g_icr[l_ac].icr06
           #   AND ztb03 = g_icr[l_ac].icr061
           #   IF l_ztb04 = 'DATE' OR l_ztb04 = 'date' THEN
               CALL cl_set_comp_entry("icr08",TRUE)
            ELSE
               CALL cl_set_comp_entry("icr08",FALSE)
            END IF
           #MOD-C90026--MOD--E---- 
                  
         END IF
      AFTER FIELD icr07
         IF NOT cl_null(g_icr[l_ac].icr07) THEN
            CALL cl_numchk(g_icr[l_ac].icr07,0) RETURNING l_flag
            IF l_flag = 0 THEN
               CALL cl_err(g_icr[l_ac].icr07,'aic-310',1)
               NEXT FIELD icr07
            END IF
         END IF
         IF NOT cl_null(g_icr[l_ac].icr04) THEN
            CASE g_icr[l_ac].icr04
              WHEN '1' IF g_icr[l_ac].icr07 <= 0 OR  
                          g_icr[l_ac].icr07 > LENGTH(g_icr[l_ac].icr05) THEN
                          CALL cl_err('','abm-811',0)
                          NEXT FIELD icr07
                       END IF 
                       
              #WHEN '2' IF g_icr[l_ac].icr07 <= 0 OR                            #MOD-C30328
              #            g_icr[l_ac].icr07 > LENGTH(g_icr[l_ac].icr06) THEN   #MOD-C30328
              WHEN '2' CALL cl_get_column_info('ds',g_icr[l_ac].icr06,g_icr[l_ac].icr061) RETURNING l_type,l_data_length   #MOD-C30328
                       IF g_icr[l_ac].icr07 <= 0 OR                             #MOD-C30328
                                     g_icr[l_ac].icr07 > l_data_length THEN     #MOD-C30328
                          CALL cl_err('','abm-811',0)
                          NEXT FIELD icr07
                       END IF 
 
              WHEN '3' SELECT SUM(icr07) INTO l_n FROM icr_file
                        WHERE icr01 = g_icr01
                          AND icr02 = g_icr02
                          AND icr03 <> g_icr[l_ac].icr03
                       IF SQLCA.sqlcode THEN
                          LET l_n = 0
                       END IF
                       IF cl_null(l_n) THEN LET l_n = 0 END IF
                       SELECT sma119 INTO l_sma119 FROM sma_file
#MOD-860317 --begin     
                       IF l_sma119 =0 THEN           
                          LET l_cnt=20              
                       END IF                      
                       IF l_sma119 =1 THEN        
                          LET l_cnt=30           
                       END IF                   
                       IF l_sma119 =2 THEN     
                          LET l_cnt=40        
                       END IF                
#                      IF l_n + g_icr[l_ac].icr07 > l_sma119 THEN            
                       IF l_n + g_icr[l_ac].icr07 > l_cnt THEN              
#MOD-860317 --end     
                          CALL cl_err('','aic-002',0)
                          NEXT FIELD icr07
                       END IF
            END CASE
         END IF
      AFTER FIELD icr08
         #判斷日否為日期型態字段
         IF NOT cl_null(g_icr[l_ac].icr08) AND 
           (NOT cl_null(g_icr[l_ac].icr061)) THEN
           #---FUN-A90024---start-----
           #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
           #目前統一用sch_file紀錄TIPTOP資料結構
           #CASE l_db_type
           #   WHEN "IFX"
           #      LET l_sql="SELECT COUNT(*) FROM syscolumns ",
           #                              " WHERE colname = '",g_icr[l_ac].icr061,"'",
           #                              "   AND coltype = 7 "  #7:日期型態
           #   WHEN "ORA"
           #      LET l_sql="SELECT COUNT(*) FROM all_tab_columns ",
           #                              " WHERE owner='",g_dbs CLIPPED,"'",
           #                              "   AND upper(cloumn_name)='",UPSHIFT(g_icr[l_ac].icr061),"'",
           #                              "   AND rtrim(upper(data_type))='DATE'"
           #   WHEN "MSV"
           #      LET l_sql="SELECT COUNT(*) FROM sys.columns ",
           #                              " WHERE name='",g_icr[l_ac].icr061,"'",
           #                              "   AND system_type_id = 61 "  #61:日期型態
           #   WHEN "ASE"
           #      LET l_sql="SELECT COUNT(*) FROM sys.columns ",         #FUN-A70145
           #                              " WHERE name='",g_icr[l_ac].icr061,"'",
           #                              "   AND system_type_id = 61 "  #61:日期型態
           #END CASE

           #IF l_sql IS NOT NULL THEN
           #   #No.CHI-950007  --Begin
           #   PREPARE i017_date_cs_p FROM l_sql 
           # # DECLARE i017_date_cs CURSOR FROM l_sql
           #   EXECUTE i017_date_cs_p INTO l_cnt
           #   #No.CHI-950007  --End  
           #      IF l_cnt>0 THEN  #為日期型態字段
           #         IF cl_null(g_icr[l_ac].icr08) THEN
           #            CALL cl_err('','mfg5103',0)
           #            NEXT FIELD icr08
           #         END IF
           #      END IF
           #END IF
           LET l_flag = cl_get_column_datetype('', g_icr[l_ac].icr061 CLIPPED)
           IF l_flag = 'Y' THEN  #為日期型態字段
              IF cl_null(g_icr[l_ac].icr08) THEN
                 CALL cl_err('','mfg5103',0)
                 NEXT FIELD icr08
              END IF
           END IF
           #---FUN-A90024---end-------
         END IF
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_icr[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_icr[l_ac].* TO s_icr.*
            CALL g_icr.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
         INSERT INTO icr_file(icr01,icr02,icr03,icr04,icr05,icr06,icr061,icr07,icr08)
              VALUES(g_icr01,g_icr02,g_icr[l_ac].icr03,g_icr[l_ac].icr04,g_icr[l_ac].icr05,
                     g_icr[l_ac].icr06,g_icr[l_ac].icr061,g_icr[l_ac].icr07,g_icr[l_ac].icr08)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","icr_file",g_icr[l_ac].icr03,'',SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_icr_t.icr03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM icr_file WHERE icr01 = g_icr01
                                   AND icr02 = g_icr02
                                   AND icr03 = g_icr_t.icr03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","icr_file",g_icr[l_ac].icr03,"",SQLCA.sqlcode,"","",1)  
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
            LET g_icr[l_ac].* = g_icr_t.*
            CLOSE i017_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_icr[l_ac].icr03,-263,1)
            LET g_icr[l_ac].* = g_icr_t.*
         ELSE
            UPDATE icr_file SET icr03 = g_icr[l_ac].icr03,
                                icr04 = g_icr[l_ac].icr04,
                                icr05 = g_icr[l_ac].icr05,
                                icr06 = g_icr[l_ac].icr06,
                                icr061 = g_icr[l_ac].icr061,
                                icr07 = g_icr[l_ac].icr07,
                                icr08 = g_icr[l_ac].icr08
                                 WHERE icr01 = g_icr01
                                   AND icr02 = g_icr02
                                   AND icr03 = g_icr_t.icr03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","icr_file",g_icr[l_ac].icr03,"",SQLCA.sqlcode,"","",1)  
               LET g_icr[l_ac].* = g_icr_t.*
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
               LET g_icr[l_ac].* = g_icr_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icr.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i017_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030 add
         CLOSE i017_bcl
         COMMIT WORK
          CALL g_icr.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icr06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_aictab"
               LET g_qryparam.arg1 = g_lang
               CASE g_icr02
                 WHEN '1' LET g_qryparam.where = " gat01 = 'ice_file'"
                 WHEN '2' LET g_qryparam.where = " gat01 = 'ice_file'"
                 WHEN '3' LET g_qryparam.where = " gat01 = 'ice_file' OR gat01 = 'icw_file'"
                #WHEN '4' LET g_qryparam.where = " gat01 = 'icw_file' OR gat01 = 'ics_file'"   #FUN-BC0106 mark
                 WHEN '4' LET g_qryparam.where = " gat01 = 'icw_file' OR gat01 = 'ics_file' OR gat01 = 'ima_file'"   #FUN-BC0106
                 WHEN '5' LET g_qryparam.where = " gat01 = 'ick_file' OR gat01 = 'icq_file'",
                                                 "  OR gat01 = 'sfb_file' OR gat01 ='sfbi_file'"
               END CASE
               CALL cl_create_qry() RETURNING g_icr[l_ac].icr06,g_icr[l_ac].icr06_desc
               DISPLAY BY NAME g_icr[l_ac].icr06,g_icr[l_ac].icr06_desc
               NEXT FIELD icr06
            WHEN INFIELD(icr061)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_aicfeld"
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET ls_str = g_icr[l_ac].icr06
               LET li_inx = ls_str.getIndexOf("_file",1)
               IF li_inx >= 1 THEN
                  LET ls_str = ls_str.subString(1,li_inx - 1)
               ELSE
                  LET ls_str = ""
               END IF
               LET g_qryparam.arg2 =ls_str 
               IF g_icr[l_ac].icr06 = 'ice_file' THEN
                  LET g_qryparam.where = " gaq01 = 'ice01' OR gaq01 = 'ice02' ",
                                         " OR gaq01 = 'ice03' OR gaq01 = 'ice14'"
               END IF
               IF g_icr[l_ac].icr06 = 'sfb_file' THEN
                  LET g_qryparam.where = " gaq01 = 'sfb05' OR gaq01 = 'sfb81' ",
                                         " OR gaq01 = 'sfb13' OR gaq01 = 'sfb06' ",
                                         " OR gaq01 = 'sfb82' OR gaq01 = 'sfb86'"
               END IF
               IF g_icr[l_ac].icr06 = 'sfbi_file' THEN
                  LET g_qryparam.where = " gaq01 = 'sfbiicd01' OR gaq01 = 'sfbiicd02' ",
                                         " OR gaq01 = 'sfbiicd09'"
               END IF
               #TQC-C30132
               IF g_icr[l_ac].icr06 = 'ima_file' THEN
                  LET g_qryparam.where = " gaq01 LIKE 'ima%' AND gaq01 NOT LIKE 'imaa%' AND gaq01 NOT LIKE 'imaicd%'"
               END IF 
               #TQC-C30132
               CALL cl_create_qry() RETURNING g_icr[l_ac].icr061,g_icr[l_ac].icr061_desc
               DISPLAY BY NAME g_icr[l_ac].icr061,g_icr[l_ac].icr061_desc
               NEXT FIELD icr061
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
       # IF INFIELD(icr02) AND l_ac > 1 THEN    #TQC-C40222
         IF INFIELD(icr03) AND l_ac > 1 THEN    #TQC-C40222
            LET g_icr[l_ac].* = g_icr[l_ac-1].*
            LET g_icr[l_ac].icr03=null
            NEXT FIELD icr03
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
 
   CLOSE i017_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i017_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT icr03,icr04,icr05,icr06,'',icr061,'',icr07,icr08",
               " FROM icr_file ",
               " WHERE icr01 = '",g_icr01,"'",
               "   AND icr02 = '",g_icr02,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY icr03"
   PREPARE i017_prepare2 FROM g_sql       #預備一下
   DECLARE icr_cs CURSOR FOR i017_prepare2
 
   CALL g_icr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH icr_cs INTO g_icr[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i017_icr06_desc(g_icr[g_cnt].icr06) RETURNING g_icr[g_cnt].icr06_desc
      CALL i017_icr061_desc(g_icr[g_cnt].icr061) RETURNING g_icr[g_cnt].icr061_desc
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_icr.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i017_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_icr TO s_icr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      #ON ACTION modify                           # Q.修改
      #   LET g_action_choice='modify'
      #   EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i017_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i017_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL i017_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i017_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL i017_fetch('L')
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
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
FUNCTION i017_copy()
DEFINE
   l_n             LIKE type_file.num5,   
   l_cnt           LIKE type_file.num10,  
   l_newno1,l_oldno1  LIKE icr_file.icr01,
   l_newno2,l_oldno2  LIKE icr_file.icr02 
   DEFINE l_icr RECORD LIKE icr_file.* 
  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icr01) OR cl_null(g_icr02) THEN
      CALL cl_err('',-400,1)
      RETURN     
   END IF
 
   DISPLAY " " TO icr01
   CALL cl_set_head_visible("","YES")    
 
   LET l_newno2 = '4'         #MOD-C90026 add
   DISPLAY l_newno2 TO icr02  #MOD-C90026 add
  #INPUT l_newno1,l_newno2 FROM icr01,icr02  #MOD-C90026 mark
   INPUT l_newno1 FROM icr01                 #MOD-C90026 
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
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
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_icr01 TO icr01
      DISPLAY g_icr02 TO icr02
      RETURN
   END IF
 
   DROP TABLE i017_x
 
   SELECT * FROM icr_file             #單身複製
    WHERE icr01 = g_icr01
      AND icr02 = g_icr02
     INTO TEMP i017_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","i017_x",g_icr01,g_icr02,SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE i017_x SET icr01=l_newno1,
                     icr02=l_newno2
  #SELECT * INTO l_icr.* FROM i017_x  #MOD-C90026 
  #DISPLAY l_icr.*                    #MOD-C90026 
   INSERT INTO icr_file SELECT * FROM i017_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","icr_file",l_newno1,l_newno2,SQLCA.sqlcode,"",g_msg,1)  
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_icr01=l_newno1
      LET g_icr02=l_newno2
      CALL i017_show()
   END IF
 
END FUNCTION
 
FUNCTION i017_icr06_desc(p_icr06)
DEFINE p_icr06 LIKE icr_file.icr06
DEFINE l_gat03 LIKE gat_file.gat03
 
   SELECT gat03 INTO l_gat03 FROM gat_file
    WHERE gat01=p_icr06
      AND gat02 = g_lang
   IF SQLCA.sqlcode THEN
      LET l_gat03 = NULL
   END IF
   RETURN l_gat03
END FUNCTION
 
FUNCTION i017_icr061_desc(p_icr061)
DEFINE p_icr061 LIKE icr_file.icr061
DEFINE l_gaq03  LIKE gaq_file.gaq03
 
   SELECT gaq03 INTO l_gaq03 FROM gaq_file
    WHERE gaq01=p_icr061
      AND gaq02 = g_lang
   IF SQLCA.sqlcode THEN
      LET l_gaq03 = NULL
   END IF
   RETURN l_gaq03
END FUNCTION
 
FUNCTION i017_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_icr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_comp_entry("icr01",FALSE)
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_icr01_t = g_icr01
   LET g_icr02_t = g_icr02
 
   BEGIN WORK
   OPEN i017_bcs
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i017_bcs
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i017_bcs INTO g_icr01,g_icr02
   IF SQLCA.sqlcode THEN
      CALL cl_err("icr01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i017_bcs
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i017_i("u")
      IF INT_FLAG THEN
         LET g_icr01 = g_icr01_t
         LET g_icr02 = g_icr02_t
         DISPLAY g_icr01,g_icr02 TO icr01,icr02 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE icr_file SET icr01 = g_icr01, 
                          icr02 = g_icr02 
       WHERE icr01 = g_icr01_t
         AND icr02 = g_icr02_t                
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_icr01,SQLCA.sqlcode,0)  
         CALL cl_err3("upd","icr_file",g_icr01_t,g_icr02_t,SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
 
FUNCTION i017_r()
   IF cl_null(g_icr01) OR cl_null(g_icr02) THEN
      CALL cl_err('',-400,1)
      RETURN     
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "icr01"      #No.FUN-9B0098 10/02/24
   LET g_doc.column2 = "icr02"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_icr01       #No.FUN-9B0098 10/02/24
   LET g_doc.value2 = g_icr02       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM icr_file WHERE icr01=g_icr01
                          AND icr02=g_icr02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","icr_file",g_icr01,g_icr02,SQLCA.sqlcode,"","del icr",1)  
      RETURN      
   END IF   
 
   INITIALIZE g_icr01,g_icr02 TO NULL
   MESSAGE ""
   DROP TABLE i017_cnttmp                   
   PREPARE i017_precount_x2 FROM g_sql_tmp  
   EXECUTE i017_precount_x2                 
   OPEN i017_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i017_bcs
      CLOSE i017_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH i017_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i017_bcs
      CLOSE i017_count
      COMMIT WORK
      RETURN
   END IF
  #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i017_bcs
      CALL i017_fetch('F') 
   ELSE
      DISPLAY g_icr01 TO icr01
      DISPLAY g_icr02 TO icr02
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_icr.clear()
      CALL i017_menu()
   END IF                      
END FUNCTION
#No.FUN-7B0014
# FUN-B80083
