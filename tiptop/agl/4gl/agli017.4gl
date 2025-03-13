# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: agli017.4gl
# Descriptions...: 股東權益科目分類/群組歸屬作業(合併)
# Date & Author..: 11/06/28 By lixiang (FUN-B60144)
# Modify.........: 12/03/06 FUN-BB0065 by belle 將agli017 獨立一支程式，不再呼叫sagli017
# Modify.........: 12/03/06 FUN-C20023 by belle 增加加減項
# Modify.........: 12/09/21 MOD-C80169 By Elise 單身的科目開窗應傳入條件:單頭的帳別
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#---FUN-BB0065 start----
DEFINE 
    g_aaj00         LIKE aaj_file.aaj00,
    g_aaj00_t       LIKE aaj_file.aaj00,
    g_aaj01         LIKE aaj_file.aaj01,
    g_aaj01_t       LIKE aaj_file.aaj01,
    g_aaj02         LIKE aaj_file.aaj02,
    g_aaj02_t       LIKE aaj_file.aaj02,
    g_aaj           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables) 
        aaj03       LIKE aaj_file.aaj03,
        aag02       LIKE aag_file.aag02,
        aaj06       LIKE aaj_file.aaj06,     #FUN-C20023
        aaj04       LIKE aaj_file.aaj04,
        aya02       LIKE aya_file.aya02,
        aaj05       LIKE aaj_file.aaj05,
        axl02       LIKE axl_file.axl02
                    END RECORD,
    g_aaj_t         RECORD                   #程式變數 (舊值) 
        aaj03       LIKE aaj_file.aaj03,
        aag02       LIKE aag_file.aag02,
        aaj06       LIKE aaj_file.aaj06,     #FUN-C20023
        aaj04       LIKE aaj_file.aaj04,
        aya02       LIKE aya_file.aya02,
        aaj05       LIKE aaj_file.aaj05,
        axl02       LIKE axl_file.axl02
                    END RECORD,
    g_wc,g_wc2,g_sql         string,
    g_rec_b                  LIKE type_file.num5,            #單身筆數  
    l_ac                     LIKE type_file.num5             #目前處理的ARRAY CNT 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_cnt2                LIKE type_file.num10         
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_row_count           LIKE type_file.num10         
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_jump                LIKE type_file.num10         
DEFINE mi_no_ask             LIKE type_file.num5         
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE g_dbs_axz03     LIKE type_file.chr21        #FUN-920067
#---FUN-BB0065 end-------------

MAIN
DEFINE p_row,p_col   LIKE type_file.num5  
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

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

#---FUN-BB0065 start----
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i017_w AT p_row,p_col WITH FORM "agl/42f/agli017"  
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_set_comp_entry("aag02,aya02,axl02",FALSE)
   
   CALL i017_menu()
   CLOSE WINDOW i017_w              #結束畫面 
#---FUN-BB0065 end------

   #CALL i017('1')    #FUN-BB0065 mark
   CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN
#FUN-B60144--

#---FUN-BB0065 start--------------
FUNCTION i017_menu()
   DEFINE l_cmd STRING
   WHILE TRUE
      CALL i017_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i017_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i017_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i017_r()
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
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF (g_aaj01 IS NOT NULL AND
                  g_aaj02 IS NOT NULL AND 
                  g_aaj00 IS NOT NULL) THEN
                  LET g_doc.column1 = "aaj00"
                  LET g_doc.value1 = g_aaj00
                  LET g_doc.column2 = "aaj01"
                  LET g_doc.value2 = g_aaj01
                  LET g_doc.column3 = "aaj02"
                  LET g_doc.value3 = g_aaj02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_aaj),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i017_cs()
DEFINE  lc_qbe_sn   LIKE   gbm_file.gbm01    
    CLEAR FORM                       
    CALL g_aaj.clear()          

    LET g_aaj00=NULL
    LET g_aaj01=NULL
    LET g_aaj02=NULL

    CONSTRUCT g_wc ON aaj01,aaj02,aaj00,aaj03,aaj04,aaj05
         FROM aaj01,aaj02,aaj00,s_aaj[1].aaj03,s_aaj[1].aaj04,s_aaj[1].aaj05             #螢幕上取單頭條件 
        
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
               
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aaj01) #族群編號                                                                                   
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.state = "c"                                                                                   
               LET g_qryparam.form = "q_axa5"                                                                               
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
               DISPLAY g_qryparam.multiret TO aaj01                                                                         
               NEXT FIELD aaj01                                                                                             
          WHEN INFIELD(aaj02)  
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz" 
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aaj02  
             NEXT FIELD aaj02
          WHEN INFIELD(aaj03)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
            #LET g_qryparam.form  = "q_aag11"  #MOD-C80169 mark
             LET g_qryparam.form  = "q_aag02"  #MOD-C80169
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aaj[1].aaj03
             NEXT FIELD aaj03
          WHEN INFIELD(aaj04)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form = "q_aya01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aaj[1].aaj04
             NEXT FIELD aaj04
          WHEN INFIELD(aaj05)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form  = "q_axl01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aaj[1].aaj05
             NEXT FIELD aaj05   
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
       CALL cl_qbe_list() RETURNING lc_qbe_sn
       CALL cl_qbe_display_condition(lc_qbe_sn)

    END CONSTRUCT
    LET g_wc = g_wc CLIPPED
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc = NULL
       RETURN
    END IF
                     
    LET g_sql = " SELECT DISTINCT aaj00,aaj01,aaj02",
                " FROM aaj_file",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY 1"
  
    PREPARE i017_prepare FROM g_sql
    DECLARE i017_cs                             #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i017_prepare
 
    LET g_sql="SELECT COUNT(*) FROM ", 
              " (SELECT DISTINCT aaj00,aaj01,aaj02 ",
              "    FROM aaj_file WHERE ",g_wc CLIPPED,")"
    PREPARE i017_precount FROM g_sql
    DECLARE i017_count CURSOR FOR i017_precount
    
END FUNCTION

FUNCTION i017_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_aaj00=NULL                      
    LET g_aaj01=NULL                      
    LET g_aaj02=NULL                      
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i017_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_aaj00=NULL 
        LET g_aaj01=NULL                      
        LET g_aaj02=NULL                      
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i017_cs                           # 從DB產生合乎條件TEMP(0-30秒)
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_aaj00=NULL 
        LET g_aaj01=NULL                      
        LET g_aaj02=NULL                      
    ELSE
        OPEN i017_count
        FETCH i017_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i017_fetch('F')                
    END IF
    MESSAGE ""

END FUNCTION

FUNCTION i017_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1,            #處理方式
    l_abso     LIKE type_file.num10            #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     i017_cs INTO g_aaj00,g_aaj01,g_aaj02
       WHEN 'P' FETCH PREVIOUS i017_cs INTO g_aaj00,g_aaj01,g_aaj02
       WHEN 'F' FETCH FIRST    i017_cs INTO g_aaj00,g_aaj01,g_aaj02
       WHEN 'L' FETCH LAST     i017_cs INTO g_aaj00,g_aaj01,g_aaj02
       WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN         
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i017_cs INTO g_aaj00,g_aaj01,g_aaj02
         LET mi_no_ask = FALSE          
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aaj02,SQLCA.sqlcode,0)
        LET g_aaj00=NULL 
        LET g_aaj01=NULL 
        LET g_aaj02=NULL 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    DISPLAY g_aaj00 TO aaj00
    DISPLAY g_aaj01 TO aaj01
    DISPLAY g_aaj02 TO aaj02
    CALL i017_b_fill(g_wc)               #單身 
    CALL cl_show_fld_cont()

END FUNCTION

FUNCTION i017_a()
    IF s_shut(0) THEN RETURN END IF         #判斷目前系統是否可用 
    MESSAGE ""
    CLEAR FORM
    CALL g_aaj.clear()
    LET g_aaj00_t = g_aaj00
    LET g_aaj01_t = g_aaj01
    LET g_aaj02_t = g_aaj02
    LET g_aaj00=NULL
    LET g_aaj01=NULL
    LET g_aaj02=NULL

    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i017_i("a")                #輸入單頭  
        IF INT_FLAG THEN                #使用者不玩了 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        IF cl_null(g_aaj01) THEN
            CONTINUE WHILE
        END IF
        
        LET g_aaj00_t = g_aaj00
        LET g_aaj01_t = g_aaj01
        LET g_aaj02_t = g_aaj02
        
        LET g_rec_b=0
        CALL i017_b()                           #輸入單身 
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i017_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,   
    l_n1            LIKE type_file.num5,   
    p_cmd           LIKE type_file.chr1,   
    l_n             LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5 

    DISPLAY BY NAME g_aaj00
    DISPLAY BY NAME g_aaj01
    DISPLAY BY NAME g_aaj02
    INPUT g_aaj01,g_aaj02,g_aaj00 WITHOUT DEFAULTS FROM aaj01,aaj02,aaj00
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i017_set_entry(p_cmd)
           CALL i017_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
         AFTER FIELD aaj01
            IF NOT cl_null(g_aaj01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=g_aaj01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",g_aaj01,g_aaj02,"agl-11","","",0)  
                  NEXT FIELD aaj01 
               END IF
            END IF

         AFTER FIELD aaj02
            IF NOT cl_null(g_aaj02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=g_aaj01 AND axa02=g_aaj02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD aaj02
               END IF
               CALL s_aaz641_dbs(g_aaj01,g_aaj02) RETURNING g_dbs_axz03
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaj00
               DISPLAY g_aaj00 TO aaj00
            END IF

        ON ACTION controlp
           CASE
             WHEN INFIELD(aaj01) #族群編號                                                                                   
                  CALL cl_init_qry_var()                                                                                       
                  LET g_qryparam.form = "q_axa5"                                                                               
                  LET g_qryparam.default1 =g_aaj01
                  CALL cl_create_qry() RETURNING g_aaj01
                  DISPLAY BY NAME g_aaj01
                  NEXT FIELD aaj01                                                                                             
             WHEN INFIELD(aaj02)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz" 
                  LET g_qryparam.default1 =g_aaj02
                  CALL cl_create_qry() RETURNING g_aaj02
                  DISPLAY BY NAME g_aaj01
                  NEXT FIELD aaj02
             OTHERWISE EXIT CASE
           END CASE
  
        ON ACTION CONTROLF                #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()     
 
        ON ACTION help         
           CALL cl_show_help() 

    END INPUT
END FUNCTION
 
FUNCTION i017_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.chr1,                #可新增否
    l_allow_delete  LIKE type_file.chr1,                #可刪除否
    l_cnt           LIKE type_file.num10

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
   #LET g_forupd_sql = "SELECT aaj03,'',aaj04,'',aaj05,''",          #FUN-C20023 mark
    LET g_forupd_sql = "SELECT aaj03,'',aaj06,aaj04,'',aaj05,''",    #FUN-C20023
                       "  FROM aaj_file WHERE aaj00=? AND aaj01=? AND aaj02=? AND aaj03=? AND aaj04=? AND aaj05=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i017_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_aaj WITHOUT DEFAULTS FROM s_aaj.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,
                     DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
       LET p_cmd=''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'            #DEFAULT
       LET l_n  = ARR_COUNT()
       IF g_rec_b>=l_ac THEN
          BEGIN WORK
          LET p_cmd='u'
          LET g_aaj_t.* = g_aaj[l_ac].*  #BACKUP
 
          LET g_before_input_done = FALSE                                      
          CALL i017_set_entry(p_cmd)                                           
          CALL i017_set_no_entry(p_cmd)                                        
          LET g_before_input_done = TRUE                                       
 
          OPEN i017_bcl USING g_aaj00,g_aaj01,g_aaj02,g_aaj_t.aaj03,g_aaj_t.aaj04,g_aaj_t.aaj05
          IF STATUS THEN
             CALL cl_err("OPEN i017_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i017_bcl INTO g_aaj[l_ac].* 
             IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aaj_t.aaj03,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_aaj[l_ac].aag02 FROM aag_file WHERE aag01=g_aaj[l_ac].aaj03 AND aag00 = g_aaj00
             SELECT aya02 INTO g_aaj[l_ac].aya02 FROM aya_file WHERE aya01=g_aaj[l_ac].aaj04 AND aya07 = 'Y'
             SELECT axl02 INTO g_aaj[l_ac].axl02 FROM axl_file WHERE axl01=g_aaj[l_ac].aaj05
          END IF
          CALL cl_show_fld_cont()     
       END IF
 
    BEFORE INSERT
       LET l_n = ARR_COUNT()
       LET p_cmd='a'
       LET g_before_input_done = FALSE                                        
       CALL i017_set_entry(p_cmd)                                             
       CALL i017_set_no_entry(p_cmd)                                          
       LET g_before_input_done = TRUE                                         
       INITIALIZE g_aaj[l_ac].* TO NULL
       LET g_aaj_t.* = g_aaj[l_ac].*   
       CALL cl_show_fld_cont()     
       NEXT FIELD aaj03
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i017_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                   

        IF (NOT cl_null(g_aaj[l_ac].aaj03)) AND (NOT cl_null(g_aaj[l_ac].aaj04))
           AND (NOT cl_null(g_aaj[l_ac].aaj05)) THEN
           IF (g_aaj[l_ac].aaj03 != g_aaj_t.aaj03 OR g_aaj_t.aaj03 IS NULL) OR
              (g_aaj[l_ac].aaj04 != g_aaj_t.aaj04 OR g_aaj_t.aaj04 IS NULL) OR
              (g_aaj[l_ac].aaj05 != g_aaj_t.aaj05 OR g_aaj_t.aaj05 IS NULL) THEN
              SELECT count(*) INTO g_cnt FROM aaj_file
               WHERE aaj03 = g_aaj[l_ac].aaj03
                 AND aaj04 = g_aaj[l_ac].aaj04
                 AND aaj05 = g_aaj[l_ac].aaj05
                 AND aaj00 = g_aaj00
                 AND aaj01 = g_aaj01
                 AND aaj02 = g_aaj02
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aaj[l_ac].aaj03 = g_aaj_t.aaj03
                 NEXT FIELD aaj03
              END IF
           END IF
        END IF 
       #INSERT INTO aaj_file(aaj00,aaj01,aaj02,aaj03,aaj04,aaj05)                              #FUN-C20023 mark
       #VALUES(g_aaj00,g_aaj01,g_aaj02,g_aaj[l_ac].aaj03,g_aaj[l_ac].aaj04,g_aaj[l_ac].aaj05)  #FUN-C20023 mark
        INSERT INTO aaj_file(aaj00,aaj01,aaj02,aaj03,aaj04,aaj05,aaj06)                        #FUN-C20023
        VALUES(g_aaj00,g_aaj01,g_aaj02,g_aaj[l_ac].aaj03,g_aaj[l_ac].aaj04,g_aaj[l_ac].aaj05,g_aaj[l_ac].aaj06)  #FUN-C20023
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","aaj_file",g_aaj[l_ac].aaj03,"",
                         SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b = g_rec_b + 1
           DISPLAY g_rec_b TO FORMONLY.cn2 
           COMMIT WORK
        END IF
 
    AFTER FIELD aaj03  
        IF NOT cl_null(g_aaj[l_ac].aaj03) THEN
           SELECT COUNT(*) INTO l_cnt FROM aag_file WHERE aag01=g_aaj[l_ac].aaj03
                                                      AND aag00 = g_aaj00   #MOD-C80169 add 
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aaj[l_ac].aaj03=g_aaj_t.aaj03
              NEXT FIELD aaj03
              DISPLAY BY NAME g_aaj[l_ac].aaj03
           END IF
           SELECT aag02 INTO g_aaj[l_ac].aag02 FROM aag_file WHERE aag01=g_aaj[l_ac].aaj03 AND aag00 = g_aaj00
        END IF
        IF (NOT cl_null(g_aaj[l_ac].aaj03)) AND (NOT cl_null(g_aaj[l_ac].aaj04)) AND (NOT cl_null(g_aaj[l_ac].aaj05)) THEN
           IF (g_aaj[l_ac].aaj03 != g_aaj_t.aaj03 OR g_aaj_t.aaj03 IS NULL) OR
              (g_aaj[l_ac].aaj04 != g_aaj_t.aaj04 OR g_aaj_t.aaj04 IS NULL) OR
              (g_aaj[l_ac].aaj05 != g_aaj_t.aaj05 OR g_aaj_t.aaj05 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aaj_file
               WHERE aaj03 = g_aaj[l_ac].aaj03 AND aaj04=g_aaj[l_ac].aaj04 
                 AND aaj05=g_aaj[l_ac].aaj05 AND aaj00=g_aaj00 AND aaj01=g_aaj01 AND aaj02=g_aaj02
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aaj[l_ac].aaj03 = g_aaj_t.aaj03
                 NEXT FIELD aaj03
              END IF
           END IF
        END IF

    AFTER FIELD aaj04  
        IF NOT cl_null(g_aaj[l_ac].aaj04) THEN
           SELECT COUNT(*) INTO l_cnt FROM aya_file WHERE aya01=g_aaj[l_ac].aaj04 AND aya07 = 'Y'
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aaj[l_ac].aaj04=g_aaj_t.aaj04
              NEXT FIELD aaj04
              DISPLAY BY NAME g_aaj[l_ac].aaj04
           END IF
           SELECT aya02 INTO g_aaj[l_ac].aya02 FROM aya_file WHERE aya01=g_aaj[l_ac].aaj04 AND aya07 = 'Y'
        END IF
        IF (NOT cl_null(g_aaj[l_ac].aaj03)) AND (NOT cl_null(g_aaj[l_ac].aaj04)) AND (NOT cl_null(g_aaj[l_ac].aaj05)) THEN
           IF (g_aaj[l_ac].aaj03 != g_aaj_t.aaj03 OR g_aaj_t.aaj03 IS NULL) OR
              (g_aaj[l_ac].aaj04 != g_aaj_t.aaj04 OR g_aaj_t.aaj04 IS NULL) OR
              (g_aaj[l_ac].aaj05 != g_aaj_t.aaj05 OR g_aaj_t.aaj05 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aaj_file
               WHERE aaj03 = g_aaj[l_ac].aaj03 AND aaj04=g_aaj[l_ac].aaj04 
                 AND aaj05=g_aaj[l_ac].aaj05  AND aaj00=g_aaj00 AND aaj01=g_aaj01 AND aaj02=g_aaj02
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aaj[l_ac].aaj04 = g_aaj_t.aaj04
                 NEXT FIELD aaj03
              END IF
           END IF
        END IF

    AFTER FIELD aaj05  
        IF NOT cl_null(g_aaj[l_ac].aaj05) THEN
           SELECT COUNT(*) INTO l_cnt FROM axl_file WHERE axl01=g_aaj[l_ac].aaj05
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aaj[l_ac].aaj05=g_aaj_t.aaj05
              NEXT FIELD aaj05
              DISPLAY BY NAME g_aaj[l_ac].aaj05
           END IF 
           SELECT axl02 INTO g_aaj[l_ac].axl02 FROM axl_file WHERE axl01=g_aaj[l_ac].aaj05
        END IF
        IF (NOT cl_null(g_aaj[l_ac].aaj03)) AND (NOT cl_null(g_aaj[l_ac].aaj04)) AND (NOT cl_null(g_aaj[l_ac].aaj05)) THEN
           IF (g_aaj[l_ac].aaj03 != g_aaj_t.aaj03 OR g_aaj_t.aaj03 IS NULL) OR
              (g_aaj[l_ac].aaj04 != g_aaj_t.aaj04 OR g_aaj_t.aaj04 IS NULL) OR
              (g_aaj[l_ac].aaj05 != g_aaj_t.aaj05 OR g_aaj_t.aaj05 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aaj_file
               WHERE aaj03 = g_aaj[l_ac].aaj03 AND aaj04=g_aaj[l_ac].aaj04 
                 AND aaj05=g_aaj[l_ac].aaj05 AND aaj00=g_aaj00 AND aaj01=g_aaj01 AND aaj02=g_aaj02
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aaj[l_ac].aaj05= g_aaj_t.aaj05
                 NEXT FIELD aaj03
              END IF
           END IF
        END IF
 
    BEFORE DELETE
        IF g_rec_b>=l_ac THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL         
            LET g_doc.column1 = "aaj03"           
            LET g_doc.value1 = g_aaj[l_ac].aaj03 
            CALL cl_del_doc()                   
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM aaj_file WHERE aaj00=g_aaj00 
                                   AND aaj01=g_aaj01
                                   AND aaj02=g_aaj02
                                   AND aaj03=g_aaj_t.aaj03
                                   AND aaj04=g_aaj_t.aaj04 
                                   AND aaj05=g_aaj_t.aaj05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aaj_file",g_aaj_t.aaj03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN              
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_aaj[l_ac].* = g_aaj_t.*
           CLOSE i017_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_aaj[l_ac].aaj03,-263,0)
           LET g_aaj[l_ac].* = g_aaj_t.*
        ELSE
           UPDATE aaj_file 
               SET aaj03=g_aaj[l_ac].aaj03,aaj04=g_aaj[l_ac].aaj04,
                   aaj05=g_aaj[l_ac].aaj05
                  ,aaj06=g_aaj[l_ac].aaj06                              #FUN-C20023
            WHERE aaj00 = g_aaj00
              AND aaj01 = g_aaj01
              AND aaj02 = g_aaj02
              AND aaj03 = g_aaj_t.aaj03
              AND aaj04 = g_aaj_t.aaj04
              AND aaj05 = g_aaj_t.aaj05
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","aaj_file",g_aaj[l_ac].aaj03,"",
                           SQLCA.sqlcode,"","",1)
              LET g_aaj[l_ac].* = g_aaj_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()      
       #LET l_ac_t = l_ac #FUN-D30032 mark 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_aaj[l_ac].* = g_aaj_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_aaj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
           END IF
           CLOSE i017_bcl        
           ROLLBACK WORK        
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  #FUN-D30032 add
        CLOSE i017_bcl         
        COMMIT WORK

     ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aaj03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.arg1 = g_aaj00
                LET g_qryparam.default1 = g_aaj[l_ac].aaj03
                CALL cl_create_qry() RETURNING g_aaj[l_ac].aaj03
                DISPLAY g_aaj[l_ac].aaj03 TO aaj03
             WHEN INFIELD(aaj04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aya01"
                LET g_qryparam.default1 = g_aaj[l_ac].aaj04
                CALL cl_create_qry() RETURNING g_aaj[l_ac].aaj04
                DISPLAY g_aaj[l_ac].aaj04 TO aaj04
             WHEN INFIELD(aaj05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axl01"
                LET g_qryparam.default1 = g_aaj[l_ac].aaj05
                CALL cl_create_qry() RETURNING g_aaj[l_ac].aaj05,g_aaj[l_ac].axl02
                DISPLAY g_aaj[l_ac].aaj05 TO aaj05
             OTHERWISE
                EXIT CASE
          END CASE
 
     ON ACTION CONTROLO              
         IF INFIELD(aaj03) AND l_ac > 1 THEN
             LET g_aaj[l_ac].* = g_aaj[l_ac-1].*
             NEXT FIELD aaj03
         END IF
 
     ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
         CALL cl_cmdask()
 
     ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
          RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
     
     END INPUT
 
 
    CLOSE i017_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i017_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc             STRING       

    LET g_sql =
    #"SELECT aaj03,'',aaj04,'',aaj05,''",           #FUN-C20023
     "SELECT aaj03,'',aaj06,aaj04,'',aaj05,''",     #FUN-C20023
     " FROM aaj_file",
     " WHERE ", p_wc CLIPPED, 
     " AND aaj00 = '",g_aaj00,"'",
     " AND aaj01 = '",g_aaj01,"'",
     " AND aaj02 = '",g_aaj02,"'",
     " ORDER BY aaj03"
   
    PREPARE i017_pb FROM g_sql
    DECLARE aaj_curs CURSOR FOR i017_pb
 
    CALL g_aaj.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!" 
    FOREACH aaj_curs INTO g_aaj[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        SELECT aag02 INTO g_aaj[g_cnt].aag02 FROM aag_file WHERE aag01=g_aaj[g_cnt].aaj03 AND aag00 = g_aaj00
        SELECT aya02 INTO g_aaj[g_cnt].aya02 FROM aya_file WHERE aya01=g_aaj[g_cnt].aaj04 AND aya07 = 'Y'
        SELECT axl02 INTO g_aaj[g_cnt].axl02 FROM axl_file WHERE axl01=g_aaj[g_cnt].aaj05
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aaj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
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
   DISPLAY ARRAY g_aaj TO s_aaj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()           

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON ACTION output
         LET g_action_choice="output"
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

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE                 #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i017_r()
    
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_aaj01) OR cl_null(g_aaj02) THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i017_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CLOSE i017_cs ROLLBACK WORK RETURN 
    END IF
    
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL           
        LET g_doc.column1 = "aaj01"          
        LET g_doc.value1 = g_aaj01      
        LET g_doc.column2 = "aaj02"          
        LET g_doc.value2 = g_aaj02      
        LET g_doc.column3 = "aaj00"          
        LET g_doc.value3 = g_aaj00      
        CALL cl_del_doc()                                            
       MESSAGE "Delete aaj!"
       DELETE FROM aaj_file
        WHERE aaj00 = g_aaj00  
          AND aaj01 = g_aaj01  
          AND aaj02 = g_aaj02  
          
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","aaj_file",g_aaj01,g_aaj02,STATUS,"","No aaj deleted",1)  
          CLOSE i017_cs ROLLBACK WORK RETURN
       END IF
       
       CLEAR FORM
       CALL g_aaj.clear()
       INITIALIZE g_aaj00 TO NULL
       INITIALIZE g_aaj01 TO NULL
       INITIALIZE g_aaj02 TO NULL
       MESSAGE ""
         OPEN i017_count
         FETCH i017_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i017_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i017_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         #No.FUN-6A0067
            CALL i017_fetch('/')
         END IF
    END IF
    CLOSE i017_cs
    COMMIT WORK
END FUNCTION


FUNCTION i017_out()
DEFINE l_cmd  LIKE type_file.chr1000

   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

   LET l_cmd = 'p_query "agli017" "',g_wc CLIPPED,'"'
   CALL cl_cmdrun(l_cmd)
   RETURN

END FUNCTION

FUNCTION i017_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("aaj01,aaj02",TRUE)
   END IF

END FUNCTION

FUNCTION i017_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("aaj01,aaj02",FALSE)
   END IF

END FUNCTION
#-----FUN-BB0065 end------------------------
