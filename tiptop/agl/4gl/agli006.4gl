# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli006.4gl (copy from agli016)
# Descriptions...: 股東權益期初導入/餘額查詢維護(合併)作業
# Date & Author..: 07/08/10 By kim (FUN-780013)
# Modify.........: No.MOD-840613 08/04/23 By Carol 單身異動後更新合計值
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-920123 10/08/16 By vealxu 將使用axzacti的地方mark
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60144 11/06/29 By lixiang  呼叫sagli006.4gl
# Modify.........: No.FUN-BB0065 12/03/06 by belle 因為合併區另外拆分ayd_file,所以改為獨立程式
# Modify.........: No.FUN-C10054 12/03/06 by belle 期別不允許輸入並預設為0
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"

#-----FUN-BB0065 start--------------------
DEFINE 
    g_ayd00         LIKE ayd_file.ayd00,
    g_ayd00_t       LIKE ayd_file.ayd00,
    g_ayd01         LIKE ayd_file.ayd01,
    g_ayd01_t       LIKE ayd_file.ayd01,
    g_ayd02         LIKE ayd_file.ayd02,
    g_ayd02_t       LIKE ayd_file.ayd02,
    g_ayd03         LIKE ayd_file.ayd03,
    g_ayd03_t       LIKE ayd_file.ayd03,
    g_ayd04         LIKE ayd_file.ayd04,
    g_ayd04_t       LIKE ayd_file.ayd04,
    g_ayd05         LIKE ayd_file.ayd05,
    g_ayd05_t       LIKE ayd_file.ayd05,
    g_ayd           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables) 
        ayd06       LIKE ayd_file.ayd06,
        aya02       LIKE aya_file.aya02,
        ayd07       LIKE ayd_file.ayd07,
        axl02       LIKE axl_file.axl02,
        ayd08       LIKE ayd_file.ayd08
                    END RECORD,
    g_ayd_t         RECORD                   #程式變數 (舊值) 
        ayd06       LIKE ayd_file.ayd06,
        aya02       LIKE aya_file.aya02,
        ayd07       LIKE ayd_file.ayd07,
        axl02       LIKE axl_file.axl02,
        ayd08       LIKE ayd_file.ayd08
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

   CALL  cl_used(g_prog,g_time,1)    #計算使用時間 (進入時間) 
         RETURNING g_time

   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i06_w AT p_row,p_col WITH FORM "agl/42f/agli006"  
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_set_comp_entry("aya02,axl02",FALSE)
   
   CALL i06_menu()
   CLOSE WINDOW i06_w              #結束畫面 

   CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION i06_menu()
   DEFINE l_cmd STRING
   WHILE TRUE
      CALL i06_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i06_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i06_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i06_r()
            END IF   
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i06_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#--FUN-BB0065 mark--
#         WHEN "output" 
#            IF cl_chk_act_auth() THEN
#               CALL i06_out()
#            END IF
#--FUN-BB0065 mark--
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF (g_ayd01 IS NOT NULL AND
                  g_ayd02 IS NOT NULL AND 
                  g_ayd00 IS NOT NULL) THEN
                  LET g_doc.column1 = "ayd00"
                  LET g_doc.value1 = g_ayd00
                  LET g_doc.column2 = "ayd01"
                  LET g_doc.value2 = g_ayd01
                  LET g_doc.column3 = "ayd02"
                  LET g_doc.value3 = g_ayd02
                  LET g_doc.column3 = "ayd03"
                  LET g_doc.value3 = g_ayd03
                  LET g_doc.column3 = "ayd04"
                  LET g_doc.value3 = g_ayd04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_ayd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i06_cs()
DEFINE  lc_qbe_sn   LIKE   gbm_file.gbm01    
    CLEAR FORM                       
    CALL g_ayd.clear()          

    LET g_ayd00=NULL
    LET g_ayd01=NULL
    LET g_ayd02=NULL
    LET g_ayd03=NULL
    LET g_ayd04=NULL
    LET g_ayd05=NULL

    CONSTRUCT g_wc ON ayd01,ayd02,ayd00,ayd03,ayd04,ayd05,ayd06,ayd07,ayd08
         FROM ayd01,ayd02,ayd00,ayd03,ayd04,ayd05,
              s_ayd[1].ayd06,s_ayd[1].ayd07,s_ayd[1].ayd08             #螢幕上取單頭條件 
        
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
               
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(ayd01) #族群編號                                                                                   
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.state = "c"                                                                                   
               LET g_qryparam.form = "q_axa5"                                                                               
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
               DISPLAY g_qryparam.multiret TO ayd01                                                                         
               NEXT FIELD ayd01                                                                                             
          WHEN INFIELD(ayd02)  
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz" 
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ayd02  
             NEXT FIELD ayd02
          WHEN INFIELD(ayd06)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form = "q_aya01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_ayd[1].ayd06
             NEXT FIELD ayd06
          WHEN INFIELD(ayd07)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form  = "q_axl01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_ayd[1].ayd07
             NEXT FIELD ayd07   
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
                     
    LET g_sql = " SELECT DISTINCT ayd00,ayd01,ayd02,ayd03,ayd04,ayd05",
                " FROM ayd_file",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY 1"
  
    PREPARE i06_prepare FROM g_sql
    DECLARE i06_cs                             #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i06_prepare
 
    LET g_sql="SELECT COUNT(*) FROM ", 
              " (SELECT DISTINCT ayd00,ayd01,ayd02,ayd03,ayd04,ayd05 ",
              "    FROM ayd_file WHERE ",g_wc CLIPPED,")"
    PREPARE i06_precount FROM g_sql
    DECLARE i06_count CURSOR FOR i06_precount
    
END FUNCTION

FUNCTION i06_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_ayd00=NULL                      
    LET g_ayd01=NULL                      
    LET g_ayd02=NULL                      
    LET g_ayd03=NULL                      
    LET g_ayd04=NULL                      
    LET g_ayd05=NULL                      
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i06_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_ayd00=NULL 
        LET g_ayd01=NULL                      
        LET g_ayd02=NULL                      
        LET g_ayd03=NULL                      
        LET g_ayd04=NULL                      
        LET g_ayd05=NULL                      
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i06_cs                           # 從DB產生合乎條件TEMP(0-30秒)
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_ayd00=NULL 
        LET g_ayd01=NULL                      
        LET g_ayd02=NULL                      
        LET g_ayd03=NULL                      
        LET g_ayd04=NULL                      
        LET g_ayd05=NULL                      
    ELSE
        OPEN i06_count
        FETCH i06_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i06_fetch('F')                
    END IF
    MESSAGE ""

END FUNCTION

FUNCTION i06_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1,            #處理方式
    l_abso     LIKE type_file.num10            #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     i06_cs INTO g_ayd00,g_ayd01,g_ayd02,g_ayd03,g_ayd04,g_ayd05
       WHEN 'P' FETCH PREVIOUS i06_cs INTO g_ayd00,g_ayd01,g_ayd02,g_ayd03,g_ayd04,g_ayd05
       WHEN 'F' FETCH FIRST    i06_cs INTO g_ayd00,g_ayd01,g_ayd02,g_ayd03,g_ayd04,g_ayd05
       WHEN 'L' FETCH LAST     i06_cs INTO g_ayd00,g_ayd01,g_ayd02,g_ayd03,g_ayd04,g_ayd05
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
         FETCH ABSOLUTE g_jump i06_cs INTO g_ayd00,g_ayd01,g_ayd02,g_ayd03,g_ayd04,g_ayd05

         LET mi_no_ask = FALSE          
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ayd02,SQLCA.sqlcode,0)
        LET g_ayd00=NULL 
        LET g_ayd01=NULL 
        LET g_ayd02=NULL 
        LET g_ayd03=NULL 
        LET g_ayd04=NULL 
        LET g_ayd05=NULL 
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

    DISPLAY g_ayd00 TO ayd00
    DISPLAY g_ayd01 TO ayd01
    DISPLAY g_ayd02 TO ayd02
    DISPLAY g_ayd03 TO ayd03
    DISPLAY g_ayd04 TO ayd04
    DISPLAY g_ayd05 TO ayd05
    CALL i06_b_fill(g_wc)               #單身 
    CALL cl_show_fld_cont()

END FUNCTION

FUNCTION i06_a()
    IF s_shut(0) THEN RETURN END IF         #判斷目前系統是否可用 
    MESSAGE ""
    CLEAR FORM
    CALL g_ayd.clear()
    LET g_ayd00_t = g_ayd00
    LET g_ayd01_t = g_ayd01
    LET g_ayd02_t = g_ayd02
    LET g_ayd03_t = g_ayd03
    LET g_ayd04_t = g_ayd04
    LET g_ayd05_t = g_ayd05
    LET g_ayd00=NULL
    LET g_ayd01=NULL
    LET g_ayd02=NULL
    LET g_ayd03=NULL
    LET g_ayd04=NULL
    LET g_ayd05=NULL

    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i06_i("a")                #輸入單頭  
        IF INT_FLAG THEN                #使用者不玩了 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        IF cl_null(g_ayd01) THEN
            CONTINUE WHILE
        END IF
        
        LET g_ayd00_t = g_ayd00
        LET g_ayd01_t = g_ayd01
        LET g_ayd02_t = g_ayd02
        LET g_ayd03_t = g_ayd03
        LET g_ayd04_t = g_ayd04
        LET g_ayd05_t = g_ayd05
        
        LET g_rec_b=0
        CALL i06_b()                           #輸入單身 
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i06_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,   
    l_n1            LIKE type_file.num5,   
    p_cmd           LIKE type_file.chr1,   
    l_n             LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5 

    DISPLAY BY NAME g_ayd00
    DISPLAY BY NAME g_ayd01
    DISPLAY BY NAME g_ayd02
    DISPLAY BY NAME g_ayd03
    DISPLAY BY NAME g_ayd04
    DISPLAY BY NAME g_ayd05

    INPUT g_ayd01,g_ayd02,g_ayd03,g_ayd04 WITHOUT DEFAULTS
     FROM ayd01,ayd02,ayd03,ayd04 


 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           LET g_ayd04 = 0                     #FUN-C10054
           DISPLAY g_ayd04 TO ayd04            #FUN-C10054
           CALL i06_set_entry(p_cmd)
           CALL i06_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
         AFTER FIELD ayd01
            IF NOT cl_null(g_ayd01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=g_ayd01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",g_ayd01,g_ayd02,"agl-11","","",0)  
                  NEXT FIELD ayd01 
               END IF
            END IF

         AFTER FIELD ayd02
            IF NOT cl_null(g_ayd02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=g_ayd01 AND axa02=g_ayd02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD ayd02
               END IF
               CALL s_aaz641_dbs(g_ayd01,g_ayd02) RETURNING g_dbs_axz03
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_ayd00
               SELECT axz06 INTO g_ayd05
                 FROM axz_file 
                WHERE axz01 = g_ayd02
              #SELECT aaa04,aaa05 INTO g_ayd03,g_ayd04   #FUN-C10054 mark
              #  FROM aaa_file WHERE aaa01 = g_ayd00     #FUN-C10054 mark
               SELECT aaa04 INTO g_ayd03                 #FUN-C10054
                FROM aaa_file WHERE aaa01 = g_ayd00      #FUN-C10054
               LET g_ayd04 = 0                           #FUN-C10054

               DISPLAY g_ayd03 TO ayd03
               DISPLAY g_ayd04 TO ayd04
               DISPLAY g_ayd05 TO ayd05
               DISPLAY g_ayd00 TO ayd00
            END IF

        ON ACTION controlp
           CASE
             WHEN INFIELD(ayd01) #族群編號                                                                                   
                  CALL cl_init_qry_var()                                                                                       
                  LET g_qryparam.form = "q_axa5"                                                                               
                  LET g_qryparam.default1 =g_ayd01
                  CALL cl_create_qry() RETURNING g_ayd01
                  DISPLAY BY NAME g_ayd01
                  NEXT FIELD ayd01                                                                                             
             WHEN INFIELD(ayd02)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz" 
                  LET g_qryparam.default1 =g_ayd02
                  CALL cl_create_qry() RETURNING g_ayd02
                  DISPLAY BY NAME g_ayd01
                  NEXT FIELD ayd02
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
 
FUNCTION i06_b()
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
 
    LET g_forupd_sql = "SELECT ayd06,'',ayd07,'',ayd08",
                       "  FROM ayd_file WHERE ayd00=? AND ayd01=? AND ayd02=? ",
                       "   AND ayd03=? AND ayd04=? AND ayd05=? ",
                       "   AND ayd06=? AND ayd07=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i06_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ayd WITHOUT DEFAULTS FROM s_ayd.*
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
          LET g_ayd_t.* = g_ayd[l_ac].*  #BACKUP
 
          LET g_before_input_done = FALSE                                      
          CALL i06_set_entry(p_cmd)                                           
          CALL i06_set_no_entry(p_cmd)                                        
          LET g_before_input_done = TRUE                                       
 
          OPEN i06_bcl USING g_ayd00,g_ayd01,g_ayd02,
                             g_ayd03,g_ayd04,g_ayd05,
                             g_ayd_t.ayd06,g_ayd_t.ayd07
          IF STATUS THEN
             CALL cl_err("OPEN i06_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i06_bcl INTO g_ayd[l_ac].* 
             IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ayd_t.ayd06,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
             END IF
             SELECT aya02 INTO g_ayd[l_ac].aya02 
               FROM aya_file WHERE aya01=g_ayd[l_ac].ayd06
                AND aya07 = 'Y'
             SELECT axl02 INTO g_ayd[l_ac].axl02 FROM axl_file WHERE axl01=g_ayd[l_ac].ayd07
          END IF
          CALL cl_show_fld_cont()     
       END IF
 
    BEFORE INSERT
       LET l_n = ARR_COUNT()
       LET p_cmd='a'
       LET g_before_input_done = FALSE                                        
       CALL i06_set_entry(p_cmd)                                             
       CALL i06_set_no_entry(p_cmd)                                          
       LET g_before_input_done = TRUE                                         
       INITIALIZE g_ayd[l_ac].* TO NULL
       LET g_ayd_t.* = g_ayd[l_ac].*   
       CALL cl_show_fld_cont()     
       NEXT FIELD ayd06
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i06_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                   

        IF (NOT cl_null(g_ayd[l_ac].ayd06)) AND (NOT cl_null(g_ayd[l_ac].ayd07)) THEN
           IF (g_ayd[l_ac].ayd06 != g_ayd_t.ayd06 OR g_ayd_t.ayd06 IS NULL) OR
              (g_ayd[l_ac].ayd07 != g_ayd_t.ayd07 OR g_ayd_t.ayd07 IS NULL) THEN
              SELECT count(*) INTO g_cnt FROM ayd_file
               WHERE ayd06 = g_ayd[l_ac].ayd06
                 AND ayd07 = g_ayd[l_ac].ayd07
                 AND ayd00 = g_ayd00
                 AND ayd01 = g_ayd01
                 AND ayd02 = g_ayd02
                 AND ayd03 = g_ayd03
                 AND ayd04 = g_ayd04
                 AND ayd05 = g_ayd05
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_ayd[l_ac].ayd06 = g_ayd_t.ayd06
                 NEXT FIELD ayd06
              END IF
           END IF
        END IF 
        INSERT INTO ayd_file(ayd00,ayd01,ayd02,ayd03,ayd04,ayd05,ayd06,ayd07,ayd08,aydlegal,aydoriu,aydorig)
                      VALUES(g_ayd00,g_ayd01,g_ayd02,g_ayd03,g_ayd04,g_ayd05,
                             g_ayd[l_ac].ayd06,g_ayd[l_ac].ayd07,g_ayd[l_ac].ayd08,g_legal,g_user,g_grup)
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","ayd_file",g_ayd[l_ac].ayd06,"",
                         SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b = g_rec_b + 1
           DISPLAY g_rec_b TO FORMONLY.cn2 
           COMMIT WORK
        END IF
        CALL i06_sum_ayd08()   

    AFTER FIELD ayd06 
        IF NOT cl_null(g_ayd[l_ac].ayd06) THEN
           SELECT COUNT(*) INTO l_cnt FROM aya_file 
            WHERE aya01=g_ayd[l_ac].ayd06
              AND aya07 = 'Y'
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_ayd[l_ac].ayd06=g_ayd_t.ayd06
              NEXT FIELD ayd06
              DISPLAY BY NAME g_ayd[l_ac].ayd06
           END IF
           SELECT aya02 INTO g_ayd[l_ac].aya02 
             FROM aya_file WHERE aya01=g_ayd[l_ac].ayd06
              AND aya07 = 'Y'
        END IF
        IF (NOT cl_null(g_ayd[l_ac].ayd06)) AND (NOT cl_null(g_ayd[l_ac].ayd07)) THEN
           IF (g_ayd[l_ac].ayd06 != g_ayd_t.ayd06 OR g_ayd_t.ayd06 IS NULL) OR
              (g_ayd[l_ac].ayd07 != g_ayd_t.ayd07 OR g_ayd_t.ayd07 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM ayd_file
               WHERE ayd06 = g_ayd[l_ac].ayd06 AND ayd07=g_ayd[l_ac].ayd07 
                 AND ayd00=g_ayd00 AND ayd01=g_ayd01 AND ayd02=g_ayd02
                 AND ayd03=g_ayd03 AND ayd04=g_ayd04 AND ayd05=g_ayd05
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_ayd[l_ac].ayd06 = g_ayd_t.ayd06
                 NEXT FIELD ayd06
              END IF
           END IF
        END IF

    AFTER FIELD ayd07  
        IF NOT cl_null(g_ayd[l_ac].ayd07) THEN
           SELECT COUNT(*) INTO l_cnt FROM axl_file WHERE axl01=g_ayd[l_ac].ayd07
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_ayd[l_ac].ayd07=g_ayd_t.ayd07
              NEXT FIELD ayd07
              DISPLAY BY NAME g_ayd[l_ac].ayd07
           END IF 
           SELECT axl02 INTO g_ayd[l_ac].axl02 FROM axl_file WHERE axl01=g_ayd[l_ac].ayd07
        END IF
        IF (NOT cl_null(g_ayd[l_ac].ayd06)) AND (NOT cl_null(g_ayd[l_ac].ayd07)) THEN
           IF (g_ayd[l_ac].ayd06 != g_ayd_t.ayd06 OR g_ayd_t.ayd06 IS NULL) OR
              (g_ayd[l_ac].ayd07 != g_ayd_t.ayd07 OR g_ayd_t.ayd07 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM ayd_file
               WHERE ayd06 = g_ayd[l_ac].ayd06 AND ayd07=g_ayd[l_ac].ayd07 
                 AND ayd00=g_ayd00 AND ayd01=g_ayd01 AND ayd02=g_ayd02
                 AND ayd03=g_ayd03 AND ayd04=g_ayd04 AND ayd05=g_ayd05
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_ayd[l_ac].ayd07= g_ayd_t.ayd07
                 NEXT FIELD ayd06
              END IF
           END IF
        END IF
 
    BEFORE DELETE
        IF g_rec_b>=l_ac THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL         
            LET g_doc.column1 = "ayd06"           
            LET g_doc.value1 = g_ayd[l_ac].ayd06 
            CALL cl_del_doc()                   
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM ayd_file WHERE ayd00=g_ayd00 
                                   AND ayd01=g_ayd01
                                   AND ayd02=g_ayd02
                                   AND ayd06=g_ayd_t.ayd06
                                   AND ayd07=g_ayd_t.ayd07 
                                   AND ayd08=g_ayd_t.ayd08
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ayd_file",g_ayd_t.ayd06,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
         CALL i06_sum_ayd08()  

     ON ROW CHANGE
        IF INT_FLAG THEN              
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_ayd[l_ac].* = g_ayd_t.*
           CLOSE i06_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_ayd[l_ac].ayd06,-263,0)
           LET g_ayd[l_ac].* = g_ayd_t.*
        ELSE
           UPDATE ayd_file 
               SET ayd06=g_ayd[l_ac].ayd06,ayd07=g_ayd[l_ac].ayd07,
                   ayd08=g_ayd[l_ac].ayd08
            WHERE ayd00 = g_ayd00
              AND ayd01 = g_ayd01
              AND ayd02 = g_ayd02
              AND ayd03 = g_ayd03
              AND ayd04 = g_ayd04
              AND ayd05 = g_ayd05
              AND ayd06 = g_ayd_t.ayd06
              AND ayd07 = g_ayd_t.ayd07
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","ayd_file",g_ayd[l_ac].ayd06,"",
                           SQLCA.sqlcode,"","",1)
              LET g_ayd[l_ac].* = g_ayd_t.*
           END IF
           CALL i06_sum_ayd08()   
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()      
        #LET l_ac_t = l_ac  #FUN-D30032 

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_ayd[l_ac].* = g_ayd_t.*
           #FUN-D30032--add--str--
           ELSE
              CALL g_ayd.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30032--add--end--
           END IF
           CLOSE i06_bcl        
           ROLLBACK WORK        
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  #FUN-D30032 
        CLOSE i06_bcl         
        COMMIT WORK
        CALL i06_sum_ayd08()   

     ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ayd06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aya01"
                LET g_qryparam.default1 = g_ayd[l_ac].ayd06
                CALL cl_create_qry() RETURNING g_ayd[l_ac].ayd06
                DISPLAY g_ayd[l_ac].ayd07 TO ayd06
             WHEN INFIELD(ayd07)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axl01"
                LET g_qryparam.default1 = g_ayd[l_ac].ayd07
                CALL cl_create_qry() RETURNING g_ayd[l_ac].ayd07,g_ayd[l_ac].axl02
                DISPLAY g_ayd[l_ac].ayd08 TO ayd07 
             OTHERWISE
                EXIT CASE
          END CASE
 
     ON ACTION CONTROLO              
         IF INFIELD(ayd06) AND l_ac > 1 THEN
             LET g_ayd[l_ac].* = g_ayd[l_ac-1].*
             NEXT FIELD ayd06
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
 
 
    CLOSE i06_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i06_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc             STRING       

    LET g_sql =
     "SELECT ayd06,'',ayd07,'',ayd08",
     " FROM ayd_file",
     " WHERE ", p_wc CLIPPED, 
     " AND ayd00 = '",g_ayd00,"'",
     " AND ayd01 = '",g_ayd01,"'",
     " AND ayd02 = '",g_ayd02,"'",
     " AND ayd03 = '",g_ayd03,"'",
     " AND ayd04 = '",g_ayd04,"'",
     " AND ayd05 = '",g_ayd05,"'",
     " ORDER BY ayd06"
   
    PREPARE i06_pb FROM g_sql
    DECLARE ayd_curs CURSOR FOR i06_pb
 
    CALL g_ayd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!" 
    FOREACH ayd_curs INTO g_ayd[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        SELECT aya02 INTO g_ayd[g_cnt].aya02 
          FROM aya_file WHERE aya01=g_ayd[g_cnt].ayd06
           AND aya07 = 'Y'
        SELECT axl02 INTO g_ayd[g_cnt].axl02 FROM axl_file WHERE axl01=g_ayd[g_cnt].ayd07
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ayd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    CALL i06_sum_ayd08()   
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i06_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ayd TO s_ayd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i06_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY        

      ON ACTION previous
         CALL i06_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY          

      ON ACTION jump
         CALL i06_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY          

      ON ACTION next
         CALL i06_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
        ACCEPT DISPLAY           

       ON ACTION last
         CALL i06_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY 
#--FUN-BB0065 mark--
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#--FUN-BB0065 mark--
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

FUNCTION i06_r()
    
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_ayd01) OR cl_null(g_ayd02) THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i06_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CLOSE i06_cs ROLLBACK WORK RETURN 
    END IF
    
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL           
        LET g_doc.column1 = "ayd01"          
        LET g_doc.value1 = g_ayd01      
        LET g_doc.column2 = "ayd02"          
        LET g_doc.value2 = g_ayd02      
        LET g_doc.column3 = "ayd00"          
        LET g_doc.value3 = g_ayd00      
        LET g_doc.column4 = "ayd03"          
        LET g_doc.value4 = g_ayd03      
        LET g_doc.column5 = "ayd04"          
        LET g_doc.value5 = g_ayd04      
        CALL cl_del_doc()                                            
       MESSAGE "Delete ayd!"
       DELETE FROM ayd_file
        WHERE ayd00 = g_ayd00  
          AND ayd01 = g_ayd01  
          AND ayd02 = g_ayd02  
          AND ayd03 = g_ayd03  
          AND ayd04 = g_ayd04  
          AND ayd05 = g_ayd05  
          
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ayd_file",g_ayd01,g_ayd02,STATUS,"","No ayd deleted",1)  
          CLOSE i06_cs ROLLBACK WORK RETURN
       END IF
       
       CLEAR FORM
       CALL g_ayd.clear()
       INITIALIZE g_ayd00 TO NULL
       INITIALIZE g_ayd01 TO NULL
       INITIALIZE g_ayd02 TO NULL
       INITIALIZE g_ayd03 TO NULL
       INITIALIZE g_ayd04 TO NULL
       INITIALIZE g_ayd05 TO NULL
       MESSAGE ""
         OPEN i06_count
         FETCH i06_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i06_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i06_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         #No.FUN-6A0067
            CALL i06_fetch('/')
         END IF
    END IF
    CLOSE i06_cs
    COMMIT WORK
END FUNCTION


FUNCTION i06_out()
DEFINE l_cmd  LIKE type_file.chr1000

   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

   LET l_cmd = 'p_query "agli06" "',g_wc CLIPPED,'"'
   CALL cl_cmdrun(l_cmd)
   RETURN

END FUNCTION

FUNCTION i06_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    #CALL cl_set_comp_entry("ayd01,ayd02,ayd03,ayd04",TRUE)     #FUN-C10054 mark
     CALL cl_set_comp_entry("ayd01,ayd02,ayd03",TRUE)           #FUN-C10054
   END IF

END FUNCTION

FUNCTION i06_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
    #CALL cl_set_comp_entry("ayd01,ayd02,ayd03,ayd04",FALSE)     #FUN-C10054 mark
     CALL cl_set_comp_entry("ayd01,ayd02,ayd03",FALSE)           #FUN-C10054
   END IF

END FUNCTION

FUNCTION i06_sum_ayd08()
DEFINE l_ayd08 LIKE ayd_file.ayd08
  
  SELECT SUM(ayd08) INTO l_ayd08 
    FROM ayd_file
   WHERE ayd00 = g_ayd00
     AND ayd01 = g_ayd01
     AND ayd02 = g_ayd02
     AND ayd03 = g_ayd03
     AND ayd04 = g_ayd04
     AND ayd05 = g_ayd05
  IF SQLCA.sqlcode OR cl_null(l_ayd08) THEN
     LET l_ayd08 =0
  END IF
  DISPLAY l_ayd08 TO FORMONLY.sum_ayd08
END FUNCTION
#-----FUN-BB0065 end----------------------

#FUN-B60144--mark
##模組變數(Module Variables)
#DEFINE
#   g_axn14           LIKE axn_file.axn14,
#   g_axn14_t         LIKE axn_file.axn14,
#   g_axn15           LIKE axn_file.axn15,
#   g_axn15_t         LIKE axn_file.axn15,   
#   g_axn16           LIKE axn_file.axn16,
#   g_axn16_t         LIKE axn_file.axn16,   
#   g_axn01           LIKE axn_file.axn01,
#   g_axn01_t         LIKE axn_file.axn01,
#   g_axn02           LIKE axn_file.axn02,
#   g_axn02_t         LIKE axn_file.axn02,
#   g_axn             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
#       axn17         LIKE axn_file.axn17,
#       aya02         LIKE aya_file.aya02,
#       axn18         LIKE axn_file.axn18
#                     END RECORD,
#   g_axn_t           RECORD                 #程式變數 (舊值)
#       axn17         LIKE axn_file.axn17,
#       aya02         LIKE aya_file.aya02,
#       axn18         LIKE axn_file.axn18
#                     END RECORD,
#   a                 LIKE type_file.chr1,
#   g_wc,g_sql        STRING,
#   g_show            LIKE type_file.chr1,   
#   g_rec_b           LIKE type_file.num5,   #單身筆數
#   g_flag            LIKE type_file.chr1,   
#   g_ss              LIKE type_file.chr1,   
#   l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT
#   g_argv1           LIKE axn_file.axn14,
#   g_argv2           LIKE axn_file.axn15,
#   g_argv3           LIKE axn_file.axn16,
#   g_argv4           LIKE axn_file.axn01,
#   g_argv5           LIKE axn_file.axn02 
#No.FUN-B60144--mark--end--

#DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT

#No.FUN-B60144--mark--begin--
##主程式開始
#DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
#DEFINE   g_sql_tmp    STRING   #No.TQC-720019
#DEFINE   g_before_input_done   LIKE type_file.num5
#DEFINE   g_cnt                 LIKE type_file.num10
#DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
#DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
#DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER
#No.FUN-B60144--mark--end--

#MAIN   #FUN-BB0065 mark
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
#--FUN-BB0065 mark---
#   OPTIONS                                #改變一些系統預設值
#      FORM LINE       FIRST + 2,         #畫面開始的位置
#      MESSAGE LINE    LAST,              #訊息顯示的位置
#      PROMPT LINE     LAST,              #提示訊息的位置
#      INPUT NO WRAP                      #輸入的方式: 不打轉
#   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
#
#   IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#   END IF
#
#   WHENEVER ERROR CALL cl_err_msg_log
# 
#   IF (NOT cl_setup("AGL")) THEN
#      EXIT PROGRAM
#   END IF
#   CALL cl_used(g_prog,g_time,1) RETURNING g_time
#--FUN-BB0065 mark

#No.FUN-B60144--mark
#  LET g_argv1 =ARG_VAL(1)
#  LET g_argv2 =ARG_VAL(2)
#  LET g_argv3 =ARG_VAL(3)
#  LET g_argv4 =ARG_VAL(4)
#  LET g_argv5 =ARG_VAL(5)
#
#  LET p_row = 3 LET p_col = 16
#
#  OPEN WINDOW i006_w AT p_row,p_col
#    WITH FORM "agl/42f/agli006"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#  CALL cl_ui_init()
#
#  IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
#     (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
#     (NOT cl_null(g_argv5)) THEN
#     CALL i006_q()
#  END IF   
#  CALL i006_menu()
#
#  CLOSE WINDOW i006_w                 #結束畫面
#No.FUN-B60144--mark--

#--FUN-BB0065 mark start--   
#   CALL i006('1')      #No.FUN-B60144
#   CALL cl_used(g_prog,g_time,2) RETURNING g_time
#END MAIN
#--FUN-BB0065 mark end--
#No.FUN-B60144--mark-- 
##QBE 查詢資料
#FUNCTION i006_cs()
#DEFINE l_sql STRING
#
#  IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
#     (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
#     (NOT cl_null(g_argv5)) THEN
#      LET g_wc = "     axn14 = '",g_argv1,"'",
#                 " AND axn15 = '",g_argv2,"'",
#                 " AND axn16 = '",g_argv3,"'",
#                 " AND axn01 = '",g_argv4,"'",
#                 " AND axn02 = '",g_argv5,"'"
#   ELSE
#      CLEAR FORM                            #清除畫面
#      CALL g_axn.clear()
#      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
#      INITIALIZE g_axn14 TO NULL
#      INITIALIZE g_axn15 TO NULL
#      INITIALIZE g_axn16 TO NULL
#      INITIALIZE g_axn01 TO NULL
#      INITIALIZE g_axn02 TO NULL
#      CONSTRUCT g_wc ON axn14,axn15,axn16,axn01,axn02,axn17,axn18
#         FROM axn14,axn15,axn16,axn01,axn02,s_axn[1].axn17,s_axn[1].axn18
#
#      #No.FUN-580031 --start--     HCN
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#      #No.FUN-580031 --end--       HCN
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(axn14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_axz"
#               LET g_qryparam.state ="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO axn14
#               NEXT FIELD axn14
#            WHEN INFIELD(axn17)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form  = "q_aya"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_axn[1].axn17
#               NEXT FIELD axn17
#         END CASE
#         
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
#      
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#      
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#      
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#
#      #No.FUN-580031 --start--     HCN
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#         
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#      #No.FUN-580031 --end--       HCN
#      
#      END CONSTRUCT
#      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axnuser', 'axngrup') #FUN-980030
#
#      IF INT_FLAG THEN
#         RETURN
#      END IF
#   END IF
#
#   IF cl_null(g_wc) THEN
#      LET g_wc="1=1"
#   END IF
#   
#   LET l_sql="SELECT UNIQUE axn14,axn15,axn16,axn01,axn02 FROM axn_file ",
#              " WHERE ", g_wc CLIPPED
#   LET g_sql= l_sql," ORDER BY axn14,axn15,axn16,axn01,axn02"
#   PREPARE i006_prepare FROM g_sql      #預備一下
#   DECLARE i006_bcs                     #宣告成可捲動的
#       SCROLL CURSOR WITH HOLD FOR i006_prepare
#
#   DROP TABLE i006_cnttmp
#   LET l_sql=l_sql," INTO TEMP i006_cnttmp"      #No.TQC-720019
#   LET g_sql_tmp=l_sql," INTO TEMP i006_cnttmp"  #No.TQC-720019
#   
#   PREPARE i006_cnttmp_pre FROM l_sql       #No.TQC-720019
#   PREPARE i006_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
#   EXECUTE i006_cnttmp_pre    
#   
#   LET g_sql="SELECT COUNT(*) FROM i006_cnttmp"
#
#   PREPARE i006_precount FROM g_sql
#   DECLARE i006_count CURSOR FOR i006_precount
#
#   IF NOT cl_null(g_argv1) THEN
#      LET g_axn14=g_argv1
#   END IF
#
#   IF NOT cl_null(g_argv2) THEN
#      LET g_axn15=g_argv2
#   END IF
#
#   IF NOT cl_null(g_argv3) THEN
#      LET g_axn16=g_argv3
#   END IF
#
#   IF NOT cl_null(g_argv4) THEN
#      LET g_axn01=g_argv4
#   END IF
#
#   IF NOT cl_null(g_argv5) THEN
#      LET g_axn02=g_argv5
#   END IF
#   CALL i006_show()
#END FUNCTION
#
#FUNCTION i006_menu()
#
#  WHILE TRUE
#     CALL i006_bp("G")
#     CASE g_action_choice
#        WHEN "insert"
#           IF cl_chk_act_auth() THEN
#              CALL i006_a()
#           END IF
#        WHEN "query"
#           IF cl_chk_act_auth() THEN
#              CALL i006_q()
#           END IF
#          WHEN "delete" 
#             IF cl_chk_act_auth() THEN
#                CALL i006_r()
#             END IF
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i006_copy()
#           END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL i006_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "help"
#           CALL cl_show_help()
#        WHEN "exit"
#           EXIT WHILE
#        WHEN "controlg"
#           CALL cl_cmdask()
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL i006_out()
#           END IF
#        WHEN "exporttoexcel"
#           IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel
#              (ui.Interface.getRootNode(),
#               base.TypeInfo.create(g_axn),'','')
#           END IF
#        WHEN "related_document"           #相關文件
#         IF cl_chk_act_auth() THEN
#            IF g_axn14 IS NOT NULL THEN
#               LET g_doc.column1 = "axn14"
#               LET g_doc.column2 = "axn15"
#               LET g_doc.column3 = "axn16"
#               LET g_doc.value1 = g_axn14
#               LET g_doc.value2 = g_axn15
#               LET g_doc.value3 = g_axn16
#               CALL cl_doc()
#            END IF 
#         END IF
#     END CASE
#  END WHILE
#END FUNCTION
#
#FUNCTION i006_a()
#  MESSAGE ""
#  CLEAR FORM
#  CALL g_axn.clear()
#  LET g_axn14_t  = NULL
#  LET g_axn15_t  = NULL
#  LET g_axn16_t  = NULL
#  LET g_axn01_t  = NULL
#  LET g_axn02_t  = NULL
#  CALL cl_opmsg('a')
#
#  WHILE TRUE
#     CALL i006_i("a")                   #輸入單頭
#
#     IF INT_FLAG THEN                   #使用者不玩了
#        LET g_axn14=NULL
#        LET g_axn15=NULL
#        LET g_axn16=NULL
#        LET g_axn01=NULL
#        LET g_axn02=NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
#
#     IF g_ss='N' THEN
#        CALL g_axn.clear()
#     ELSE
#        CALL i006_b_fill('1=1')            #單身
#     END IF
#
#     CALL i006_b()                      #輸入單身
#
#     LET g_axn14_t = g_axn14
#     LET g_axn15_t = g_axn15
#     LET g_axn16_t = g_axn16
#     LET g_axn01_t = g_axn01
#     LET g_axn02_t = g_axn02
#     EXIT WHILE
#  END WHILE
#
#END FUNCTION
# 
#FUNCTION i006_i(p_cmd)
#DEFINE
#   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
#   l_cnt           LIKE type_file.num10,
#   li_result       LIKE type_file.num5
#
#   LET g_ss='Y'
#
#   CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
#
#   INPUT g_axn14,g_axn15,g_axn16,g_axn01,g_axn02 WITHOUT DEFAULTS
#       FROM axn14,axn15,axn16,axn01,axn02
#
#      AFTER FIELD axn14
#         CALL i006_chk_axn14(g_axn14) 
#              RETURNING li_result,g_axn15,g_axn16
#         DISPLAY i006_set_axz02(g_axn14) TO FORMONLY.axz02
#         DISPLAY g_axn15 TO axn15
#         DISPLAY g_axn16 TO axn16
#         IF NOT li_result THEN
#            NEXT FIELD CURRENT
#         END IF
#      
#      AFTER FIELD axn02
#         IF (NOT cl_null(g_axn14)) OR (NOT cl_null(g_axn15)) OR
#            (NOT cl_null(g_axn16)) OR (NOT cl_null(g_axn01)) OR
#            (NOT cl_null(g_axn02)) THEN
#            LET l_cnt=0             
#            SELECT COUNT(*) INTO l_cnt FROM axn_file
#                                      WHERE axn14=g_axn14
#                                        AND axn15=g_axn15
#                                        AND axn16=g_axn16
#                                        AND axn01=g_axn01
#                                        AND axn02=g_axn02
#           IF l_cnt>0 THEN
#              CALL cl_err('','-239',1)
#              NEXT FIELD axn14
#           END IF
#         END IF
#
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(axn14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_axz"
#               CALL cl_create_qry() RETURNING g_axn14
#               DISPLAY g_axn14 TO axn14
#               NEXT FIELD axn14
#         END CASE
#      ON ACTION CONTROLG
#        CALL cl_cmdask()
#
#      ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#      ON ACTION CONTROLF                  #欄位說明
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#           RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#   END INPUT
#
#END FUNCTION
#
#FUNCTION i006_q()
#  LET g_row_count = 0
#  LET g_curs_index = 0
#  CALL cl_navigator_setting( g_curs_index, g_row_count )
#  INITIALIZE g_axn14,g_axn15,g_axn16,g_axn01,g_axn02 TO NULL
#  MESSAGE ""
#  CALL cl_opmsg('q')
#  CLEAR FORM
#  CALL g_axn.clear()
#  DISPLAY '' TO FORMONLY.cnt
#
#  CALL i006_cs()                      #取得查詢條件
#
#  IF INT_FLAG THEN                    #使用者不玩了
#     LET INT_FLAG = 0
#     INITIALIZE g_axn14,g_axn15,g_axn16,g_axn01,g_axn02 TO NULL
#     RETURN
#  END IF
#
#  OPEN i006_bcs                       #從DB產生合乎條件TEMP(0-30秒)
#  IF SQLCA.sqlcode THEN               #有問題
#     CALL cl_err('',SQLCA.sqlcode,0)
#     INITIALIZE g_axn14,g_axn15,g_axn16,g_axn01,g_axn02 TO NULL
#  ELSE
#     OPEN i006_count
#     FETCH i006_count INTO g_row_count
#     DISPLAY g_row_count TO FORMONLY.cnt
#     CALL i006_fetch('F')            #讀出TEMP第一筆並顯示
#  END IF
#END FUNCTION
#
##處理資料的讀取
#FUNCTION i006_fetch(p_flag)
#DEFINE
#  p_flag          LIKE type_file.chr1,   #處理方式
#  l_abso          LIKE type_file.num10   #絕對的筆數
#
#  MESSAGE ""
#  CASE p_flag
#      WHEN 'N' FETCH NEXT     i006_bcs INTO g_axn14,g_axn15,
#                                            g_axn16,g_axn01,g_axn02
#      WHEN 'P' FETCH PREVIOUS i006_bcs INTO g_axn14,g_axn15,
#                                            g_axn16,g_axn01,g_axn02
#      WHEN 'F' FETCH FIRST    i006_bcs INTO g_axn14,g_axn15,
#                                            g_axn16,g_axn01,g_axn02
#      WHEN 'L' FETCH LAST     i006_bcs INTO g_axn14,g_axn15,
#                                            g_axn16,g_axn01,g_axn02
#      WHEN '/'
#           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#           LET INT_FLAG = 0  ######add for prompt bug
#           PROMPT g_msg CLIPPED,': ' FOR l_abso
#              ON IDLE g_idle_seconds
#                 CALL cl_on_idle()
#                  CONTINUE PROMPT
#             
#              ON ACTION about         #MOD-4C0121
#                 CALL cl_about()      #MOD-4C0121
#             
#              ON ACTION help          #MOD-4C0121
#                 CALL cl_show_help()  #MOD-4C0121
#             
#              ON ACTION controlg      #MOD-4C0121
#                 CALL cl_cmdask()     #MOD-4C0121
#             
#           END PROMPT
#           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
#           FETCH ABSOLUTE l_abso i006_bcs INTO g_axn14,g_axn15,
#                                               g_axn16,g_axn01,g_axn02
#  END CASE
#
#  IF SQLCA.sqlcode THEN                  #有麻煩
#     CALL cl_err(g_axn14,SQLCA.sqlcode,0)
#     INITIALIZE g_axn14 TO NULL
#     INITIALIZE g_axn15 TO NULL
#     INITIALIZE g_axn16 TO NULL
#     INITIALIZE g_axn01 TO NULL
#     INITIALIZE g_axn02 TO NULL
#  ELSE
#     CALL i006_show()
#     CASE p_flag
#        WHEN 'F' LET g_curs_index = 1
#        WHEN 'P' LET g_curs_index = g_curs_index - 1
#        WHEN 'N' LET g_curs_index = g_curs_index + 1
#        WHEN 'L' LET g_curs_index = g_row_count
#        WHEN '/' LET g_curs_index = l_abso
#     END CASE
#
#     CALL cl_navigator_setting( g_curs_index, g_row_count )
#  END IF
#
#END FUNCTION
#
##將資料顯示在畫面上
#FUNCTION i006_show()
#
#  DISPLAY g_axn14 TO axn14
#  DISPLAY g_axn15 TO axn15
#  DISPLAY g_axn16 TO axn16
#  DISPLAY g_axn01 TO axn01
#  DISPLAY g_axn02 TO axn02
#  DISPLAY i006_set_axz02(g_axn14) TO FORMONLY.axz02
#
#  CALL i006_b_fill(g_wc)                      #單身
#
#  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#END FUNCTION
#
##單身
#FUNCTION i006_b()
#DEFINE
#  l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT
#  l_n             LIKE type_file.num5,          #檢查重複用       
#  l_lock_sw       LIKE type_file.chr1,          #單身鎖住否       
#  p_cmd           LIKE type_file.chr1,          #處理狀態         
#  l_allow_insert  LIKE type_file.num5,          #可新增否         
#  l_allow_delete  LIKE type_file.num5,          #可刪除否         
#  l_cnt           LIKE type_file.num10          #No.FUN-680098
#
#  LET g_action_choice = ""
#
#  IF cl_null(g_axn14) OR cl_null(g_axn15) OR
#     cl_null(g_axn16) OR cl_null(g_axn01) OR
#     cl_null(g_axn02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#
#  CALL cl_opmsg('b')
#
#  LET g_forupd_sql = "SELECT axn17,'',axn18 FROM axn_file",
#                     "  WHERE axn14 = ? AND axn15= ? AND axn16= ? ",
#                     "   AND axn01 = ? AND axn02= ? AND axn17= ? ",
#                     "   FOR UPDATE "
#                     
#  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#  DECLARE i006_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#  LET l_allow_insert = cl_detail_input_auth("insert")
#  LET l_allow_delete = cl_detail_input_auth("delete")
#
#  IF g_rec_b=0 THEN CALL g_axn.clear() END IF
#
#  INPUT ARRAY g_axn WITHOUT DEFAULTS FROM s_axn.*
#
#     ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#               INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#               APPEND ROW=l_allow_insert)
#
#     BEFORE INPUT
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(l_ac)
#        END IF
#
#     BEFORE ROW
#        LET p_cmd = ''
#        LET l_ac = ARR_CURR()
#        LET l_lock_sw = 'N'            #DEFAULT
#        LET l_n  = ARR_COUNT()
#        IF g_rec_b >= l_ac THEN
#           LET p_cmd='u'
#           LET g_axn_t.* = g_axn[l_ac].*  #BACKUP
#           BEGIN WORK
#           OPEN i006_bcl USING g_axn14,g_axn15,g_axn16,g_axn01,g_axn02,
#                               g_axn[l_ac].axn17
#           IF STATUS THEN
#              CALL cl_err("OPEN i006_bcl:", STATUS, 1)
#              LET l_lock_sw = "Y"
#           ELSE
#              FETCH i006_bcl INTO g_axn[l_ac].*
#              IF STATUS THEN
#                 CALL cl_err("OPEN i006_bcl:", STATUS, 1)
#                 LET l_lock_sw = "Y"
#              ELSE
#                 LET g_axn[l_ac].aya02=i006_set_aya02(g_axn[l_ac].axn17)
#                 LET g_axn_t.*=g_axn[l_ac].*
#              END IF
#           END IF
#           CALL cl_show_fld_cont()     #FUN-550037(smin)
#        END IF
#
#     BEFORE INSERT
#        LET l_n = ARR_COUNT()
#        LET p_cmd='a'
#        INITIALIZE g_axn[l_ac].* TO NULL            #900423
#        LET g_axn_t.* = g_axn[l_ac].*               #新輸入資料
#        LET g_axn[l_ac].axn18=0
#        CALL cl_show_fld_cont()
#        NEXT FIELD axn17
#
#     AFTER FIELD axn17                         # check data 是否重複
#        IF NOT cl_null(g_axn[l_ac].axn17) THEN
#           IF NOT i006_chk_axn17() THEN
#              LET g_axn[l_ac].axn17=g_axn_t.axn17
#              LET g_axn[l_ac].aya02=i006_set_aya02(g_axn[l_ac].axn17)
#              DISPLAY BY NAME g_axn[l_ac].axn17,g_axn[l_ac].aya02
#              NEXT FIELD CURRENT
#           END IF
#           LET g_axn[l_ac].aya02=i006_set_aya02(g_axn[l_ac].axn17)
#           DISPLAY BY NAME g_axn[l_ac].aya02
#           IF g_axn[l_ac].axn17 != g_axn_t.axn17 OR g_axn_t.axn17 IS NULL THEN
#              IF NOT i006_chk_dudata() THEN
#                 LET g_axn[l_ac].axn17=g_axn_t.axn17
#                 LET g_axn[l_ac].aya02=i006_set_aya02(g_axn[l_ac].axn17)
#                 DISPLAY BY NAME g_axn[l_ac].axn17,g_axn[l_ac].aya02
#                 NEXT FIELD CURRENT
#              END IF
#           END IF
#        END IF
#        LET g_axn[l_ac].aya02=i006_set_aya02(g_axn[l_ac].axn17)
#        DISPLAY BY NAME g_axn[l_ac].aya02
#
#     AFTER FIELD axn18
#        CALL i006_set_axn18()
#        
#     AFTER INSERT
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           INITIALIZE g_axn[l_ac].* TO NULL  #重要欄位空白,無效
#           DISPLAY g_axn[l_ac].* TO s_axn.*
#           CALL g_axn.deleteElement(g_rec_b+1)
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        INSERT INTO axn_file(axn14,axn15,axn16,axn01,axn02,axn17,axn18,axnlegal,axnoriu,axnorig) #FUN-980003 add legal
#             VALUES(g_axn14,g_axn15,g_axn16,g_axn01,g_axn02,
#                    g_axn[l_ac].axn17,g_axn[l_ac].axn18,g_legal, g_user, g_grup) #FUN-980003 add legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","axn_file",g_axn[l_ac].axn17,
#                        "",SQLCA.sqlcode,"","",1)
#           CANCEL INSERT
#        ELSE
#           MESSAGE 'INSERT O.K'
#           COMMIT WORK
#           LET g_rec_b=g_rec_b+1
#           DISPLAY g_rec_b TO FORMONLY.cn2
#           CALL i006_sum_axn18()      #MOD-840613-add
#        END IF
#
#     BEFORE DELETE                            #是否取消單身
#        IF l_ac>0 THEN
#           IF NOT cl_delb(0,0) THEN
#              CANCEL DELETE
#           END IF
#           IF l_lock_sw = "Y" THEN
#              CALL cl_err("", -263, 1)
#              CANCEL DELETE
#           END IF
#           DELETE FROM axn_file WHERE axn14 = g_axn14
#                                  AND axn15 = g_axn15
#                                  AND axn16 = g_axn16
#                                  AND axn01 = g_axn01
#                                  AND axn02 = g_axn02
#                                  AND axn17 = g_axn_t.axn17
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("del","axn_file",g_axn[l_ac].axn17,
#                           "",SQLCA.sqlcode,"","",1)
#              ROLLBACK WORK
#              CANCEL DELETE
#           END IF
#           LET g_rec_b = g_rec_b-1
#           DISPLAY g_rec_b TO FORMONLY.cn2
#        END IF
#        COMMIT WORK
#        CALL i006_sum_axn18()      #MOD-840613-add
#
#     ON ROW CHANGE
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           LET g_axn[l_ac].* = g_axn_t.*
#           CLOSE i006_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        IF l_lock_sw = 'Y' THEN
#           CALL cl_err(g_axn[l_ac].axn17,-263,1)
#           LET g_axn[l_ac].* = g_axn_t.*
#        ELSE
#           UPDATE axn_file SET axn17 = g_axn[l_ac].axn17,
#                               axn18 = g_axn[l_ac].axn18
#                                WHERE axn14 = g_axn14
#                                  AND axn15 = g_axn15
#                                  AND axn16 = g_axn16
#                                  AND axn01 = g_axn01
#                                  AND axn02 = g_axn02
#                                  AND axn17 = g_axn_t.axn17
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("upd","axn_file",g_axn[l_ac].axn17,
#                           "",SQLCA.sqlcode,"","",1)
#              LET g_axn[l_ac].* = g_axn_t.*
#           ELSE
#              MESSAGE 'UPDATE O.K'
#              COMMIT WORK
#              CALL i006_sum_axn18()      #MOD-840613-add
#           END IF
#        END IF
#
#     AFTER ROW
#        LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           IF p_cmd = 'u' THEN
#              LET g_axn[l_ac].* = g_axn_t.*
#           END IF
#           CLOSE i006_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        CLOSE i006_bcl
#        COMMIT WORK
#        #CKP2
#         CALL g_axn.deleteElement(g_rec_b+1)
#
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(axn17)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_aya"
#             LET g_qryparam.default1 = g_axn[l_ac].axn17
#             CALL cl_create_qry() RETURNING g_axn[l_ac].axn17
#             DISPLAY BY NAME g_axn[l_ac].axn17
#             NEXT FIELD axn17
#        END CASE
#
#     ON ACTION CONTROLR
#        CALL cl_show_req_fields()
#
#     ON ACTION CONTROLG
#        CALL cl_cmdask()
#
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#            RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
#     ON ACTION controls                                        
#        CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
#
#  END INPUT
#
#  CLOSE i006_bcl
#  COMMIT WORK
#  CALL i006_sum_axn18()
#END FUNCTION
#
#FUNCTION i006_b_fill(p_wc)                     #BODY FILL UP
#DEFINE p_wc STRING
#
#  LET g_sql = "SELECT axn17,'',axn18",
#              " FROM axn_file ",
#              " WHERE axn14 = '",g_axn14,"'",
#              "   AND axn15 = '",g_axn15,"'",
#              "   AND axn16 = '",g_axn16,"'",
#              "   AND axn01 = '",g_axn01,"'",
#              "   AND axn02 = '",g_axn02,"'",
#              "   AND ",p_wc CLIPPED ,
#              " ORDER BY axn17"
#  PREPARE i006_prepare2 FROM g_sql       #預備一下
#  DECLARE axn_cs CURSOR FOR i006_prepare2
#
#  CALL g_axn.clear()
#  LET g_cnt = 1
#  LET g_rec_b = 0
#
#  FOREACH axn_cs INTO g_axn[g_cnt].*     #單身 ARRAY 填充
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     LET g_axn[g_cnt].aya02=i006_set_aya02(g_axn[g_cnt].axn17)
#     LET g_cnt = g_cnt + 1
#     IF g_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#  END FOREACH
#
#  CALL g_axn.deleteElement(g_cnt)
#
#  LET g_rec_b=g_cnt-1
#
#  DISPLAY g_rec_b TO FORMONLY.cn2
#  CALL i006_sum_axn18()
#  LET g_cnt = 0
#
#END FUNCTION
#
#FUNCTION i006_bp(p_ud)
#  DEFINE   p_ud   LIKE type_file.chr1
#
#  IF p_ud <> "G" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_axn TO s_axn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#     BEFORE DISPLAY
#        CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ##########################################################################
#     # Standard 4ad ACTION
#     ##########################################################################
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY
#
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#
#     ON ACTION delete
#        LET g_action_choice="delete"
#        EXIT DISPLAY
#
#     ON ACTION first
#        CALL i006_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION previous
#        CALL i006_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION jump
#        CALL i006_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION next
#        CALL i006_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION last
#        CALL i006_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION reproduce
#        LET g_action_choice="reproduce"
#        EXIT DISPLAY
#
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ##########################################################################
#     # Special 4ad ACTION
#     ##########################################################################
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#     
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
#
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#
#     ON ACTION cancel
#        LET INT_FLAG=FALSE 		#MOD-570244	mars
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION exporttoexcel
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#
#     ON ACTION related_document                #No.FUN-6B0040  相關文件
#        LET g_action_choice="related_document"          
#        EXIT DISPLAY 
#
#     AFTER DISPLAY
#        CONTINUE DISPLAY
##No.FUN-6B0029--begin                                             
#     ON ACTION controls                                        
#        CALL cl_set_head_visible("","AUTO")                    
##No.FUN-6B0029--end
#
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
#FUNCTION i006_copy()
#DEFINE
#  l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
#  l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
#  l_newno1,l_oldno1  LIKE axn_file.axn14,
#  l_newno2,l_oldno2  LIKE axn_file.axn15,
#  l_newno3,l_oldno3  LIKE axn_file.axn16,
#  l_newno4,l_oldno4  LIKE axn_file.axn01,
#  l_newno5,l_oldno5  LIKE axn_file.axn02,
#  li_result       LIKE type_file.num5
#
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#
#  IF cl_null(g_axn14) OR cl_null(g_axn15) OR
#     cl_null(g_axn16) OR cl_null(g_axn01) OR
#     cl_null(g_axn02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#
#  DISPLAY NULL TO axn14
#  DISPLAY NULL TO axn15
#  DISPLAY NULL TO axn16
#  DISPLAY NULL TO axn01
#  DISPLAY NULL TO axn02
#  CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
#
#  INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5 
#   FROM axn14,axn15,axn16,axn01,axn02
#
#      AFTER FIELD axn14
#         CALL i006_chk_axn14(l_newno1) 
#             RETURNING li_result,l_newno2,l_newno3
#         DISPLAY i006_set_axz02(l_newno1) TO FORMONLY.axz02
#         DISPLAY l_newno2 TO axn15
#         DISPLAY l_newno3 TO axn16
#         IF NOT li_result THEN
#            NEXT FIELD CURRENT
#         END IF
#
#      AFTER FIELD axn02
#         IF (NOT cl_null(l_newno1)) OR (NOT cl_null(l_newno2)) OR
#            (NOT cl_null(l_newno3)) OR (NOT cl_null(l_newno4)) OR
#            (NOT cl_null(l_newno5)) THEN
#            LET l_cnt=0             
#            SELECT COUNT(*) INTO l_cnt FROM axn_file
#                                      WHERE axn14=l_newno1
#                                        AND axn15=l_newno2
#                                        AND axn16=l_newno3
#                                        AND axn01=l_newno4
#                                        AND axn02=l_newno5
#           IF l_cnt>0 THEN
#              CALL cl_err('','-239',1)
#              NEXT FIELD axn14
#           END IF
#         END IF
#
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(axn14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_axz"
#               CALL cl_create_qry() RETURNING l_newno1
#               DISPLAY l_newno1 TO axn14
#               NEXT FIELD axn14
#         END CASE
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END INPUT
#
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     DISPLAY g_axn14 TO axn14
#     DISPLAY g_axn15 TO axn15
#     DISPLAY g_axn16 TO axn16
#     DISPLAY g_axn01 TO axn01
#     DISPLAY g_axn02 TO axn02
#     RETURN
#  END IF
#
#  DROP TABLE i006_x
#
#  SELECT * FROM axn_file             #單身複製
#   WHERE axn14 = g_axn14
#     AND axn15 = g_axn15
#     AND axn16 = g_axn16
#     AND axn01 = g_axn01
#     AND axn02 = g_axn02
#    INTO TEMP i006_x
#  IF SQLCA.sqlcode THEN
#     LET g_msg=l_newno1 CLIPPED
#     CALL cl_err3("ins","i006_x",g_axn14,g_axn15,SQLCA.sqlcode,"","",1)
#     RETURN
#  END IF
#
#  UPDATE i006_x SET axn14=l_newno1,
#                    axn15=l_newno2,
#                    axn16=l_newno3,
#                    axn01=l_newno4,
#                    axn02=l_newno5
#
#  INSERT INTO axn_file SELECT * FROM i006_x
#  IF SQLCA.sqlcode THEN
#     LET g_msg=l_newno1 CLIPPED
#     CALL cl_err3("ins","axn_file",l_newno1,l_newno2,
#                   SQLCA.sqlcode,"",g_msg,1)
#     RETURN
#  ELSE
#     MESSAGE 'COPY O.K'
#     LET g_axn14=l_newno1
#     LET g_axn15=l_newno2
#     LET g_axn16=l_newno3
#     LET g_axn01=l_newno4
#     LET g_axn02=l_newno5
#     CALL i006_show()
#  END IF
#
#END FUNCTION
#
#FUNCTION i006_r()
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#  IF cl_null(g_axn14) OR cl_null(g_axn15) OR
#     cl_null(g_axn16) OR cl_null(g_axn01) OR
#     cl_null(g_axn02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#  IF NOT cl_delh(20,16) THEN RETURN END IF
#  INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
#  LET g_doc.column1 = "axn14"      #No.FUN-9B0098 10/02/24
#  LET g_doc.column2 = "axn15"      #No.FUN-9B0098 10/02/24
#  LET g_doc.column3 = "axn16"      #No.FUN-9B0098 10/02/24
#  LET g_doc.value1 = g_axn14       #No.FUN-9B0098 10/02/24
#  LET g_doc.value2 = g_axn15       #No.FUN-9B0098 10/02/24
#  LET g_doc.value3 = g_axn16       #No.FUN-9B0098 10/02/24
#  CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
#  DELETE FROM axn_file WHERE axn14=g_axn14
#                         AND axn15=g_axn15
#                         AND axn16=g_axn16
#                         AND axn01=g_axn01
#                         AND axn02=g_axn02
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err3("del","axn_file",g_axn14,g_axn15,
#                  SQLCA.sqlcode,"","del axn",1)
#     RETURN      
#  END IF   
#
#  INITIALIZE g_axn14,g_axn15,g_axn16,g_axn01,g_axn02 TO NULL
#  MESSAGE ""
#  DROP TABLE i006_cnttmp                   #No.TQC-720019
#  PREPARE i006_precount_x2 FROM g_sql_tmp  #No.TQC-720019
#  EXECUTE i006_precount_x2                 #No.TQC-720019
#  OPEN i006_count
#  #FUN-B50062-add-start--
#  IF STATUS THEN
#     CLOSE i006_bcs
#     CLOSE i006_count
#     COMMIT WORK
#     RETURN
#  END IF
#  #FUN-B50062-add-end--
#  FETCH i006_count INTO g_row_count
#  #FUN-B50062-add-start--
#  IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
#     CLOSE i006_bcs
#     CLOSE i006_count
#     COMMIT WORK
#     RETURN
#  END IF
#  #FUN-B50062-add-end--
#  DISPLAY g_row_count TO FORMONLY.cnt
#  IF g_row_count>0 THEN
#     OPEN i006_bcs
#     CALL i006_fetch('F') 
#  ELSE
#     DISPLAY g_axn14 TO axn14
#     DISPLAY g_axn15 TO axn15
#     DISPLAY g_axn16 TO axn16
#     DISPLAY g_axn01 TO axn01
#     DISPLAY g_axn02 TO axn02
#     DISPLAY 0 TO FORMONLY.cn2
#     CALL g_axn.clear()
#     CALL i006_menu()
#  END IF
#END FUNCTION
#
#FUNCTION i006_chk_axn14(p_axn14)
#  DEFINE p_axn14 LIKE axn_file.axn14
#  DEFINE l_axzacti  LIKE axz_file.axzacti
#  DEFINE l_axz05 LIKE axz_file.axz05
#  DEFINE l_axz06 LIKE axz_file.axz06
#
#  LET l_axz05=NULL
#  LET l_axz06=NULL
#  IF NOT cl_null(p_axn14) THEN
#    #SELECT axzacti,axz05,axz06                         #FUN-920123 mark 
#    #  INTO l_axzacti,l_axz05,l_axz06 FROM axz_file     #FUN-920123 mark
#     SELECT axz05,axz06                                 #FUN-920123 
#       INTO l_axz05,l_axz06 FROM axz_file               #FUN-920123 
#                                     WHERE axz01=p_axn14
#     CASE
#        WHEN SQLCA.sqlcode
#           CALL cl_err3("sel","axn_file",p_axn14,"",SQLCA.sqlcode,"","",1)
#           RETURN FALSE,NULL,NULL
#       #FUN-920123 --------------mark -------start-------------------
#       #WHEN l_axzacti='N'
#       #   CALL cl_err3("sel","axn_file",p_axn14,"",9028,"","",1)
#       #   RETURN FALSE,NULL,NULL
#       #FUN-920123 --------------mark -------end--------------------
#     END CASE      
#  END IF
#  RETURN TRUE,l_axz05,l_axz06
#END FUNCTION
#
#FUNCTION i006_set_axz02(p_axz01)
#  DEFINE p_axz01 LIKE axz_file.axz01
#  DEFINE l_axz02 LIKE axz_file.axz02
#  
#  IF cl_null(p_axz01) THEN RETURN NULL END IF
#  LET l_axz02=''
#  SELECT axz02 INTO l_axz02 FROM axz_file
#                           WHERE axz01=p_axz01
#  RETURN l_axz02
#END FUNCTION
#
#FUNCTION i006_set_aya02(p_aya01)
#  DEFINE p_aya01 LIKE aya_file.aya01
#  DEFINE l_aya02 LIKE aya_file.aya02
#  
#  IF cl_null(p_aya01) THEN RETURN NULL END IF
#  LET l_aya02=''
#  SELECT aya02 INTO l_aya02 FROM aya_file
#                           WHERE aya01=p_aya01
#  RETURN l_aya02
#END FUNCTION
#
#FUNCTION i006_chk_axn17()
#  IF NOT cl_null(g_axn[l_ac].axn17) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM aya_file 
#                               WHERE aya01 = g_axn[l_ac].axn17
#     IF g_cnt=0 THEN
#        CALL cl_err3("sel","aya_file",g_axn[l_ac].axn17,"",100,"","",1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i006_set_axn18()
#  IF NOT cl_null(g_axn[l_ac].axn18) THEN
#     SELECT azi04 INTO t_azi04 FROM azi_file
#                              WHERE azi01=g_axn16
#     LET g_axn[l_ac].axn18=cl_digcut(g_axn[l_ac].axn18,t_azi04)
#     DISPLAY BY NAME g_axn[l_ac].axn18
#  END IF
#END FUNCTION
#
#FUNCTION i006_chk_dudata()
#  IF NOT cl_null(g_axn[l_ac].axn17) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM axn_file
#                               WHERE axn14=g_axn14
#                                 AND axn15=g_axn15
#                                 AND axn16=g_axn16
#                                 AND axn01=g_axn01
#                                 AND axn02=g_axn02
#                                 AND axn17=g_axn[l_ac].axn17
#     IF g_cnt>0 THEN
#        CALL cl_err('',-239,1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i006_sum_axn18()
#  DEFINE l_axn18 LIKE axn_file.axn18
#  
#  SELECT SUM(axn18) INTO l_axn18 FROM axn_file
#                               WHERE axn14=g_axn14
#                                 AND axn15=g_axn15
#                                 AND axn16=g_axn16
#                                 AND axn01=g_axn01
#                                 AND axn02=g_axn02
#  IF SQLCA.sqlcode OR cl_null(l_axn18) THEN
#     LET l_axn18=0
#  END IF
#  DISPLAY l_axn18 TO FORMONLY.sum_axn18
#END FUNCTION
#
#FUNCTION i006_out()
#  DEFINE l_wc STRING
#  IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#
#  CALL cl_wait()
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
#  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli006'
#
#  #組合出 SQL 指令
#  LET g_sql="SELECT A.axn14,B.axz02 axn14_d,A.axn15,A.axn16,",
#            "       A.axn01,A.axn02,A.axn17,C.aya02 axn17_d,",
#            "       A.axn18,D.azi04,D.azi05",
#            "  FROM axn_file A,axz_file B,aya_file C,azi_file D",
#            " WHERE A.axn14=B.axz01",
#            "   AND A.axn17=C.aya01",
#            "   AND A.axn16=D.azi01",
#            "   AND ",g_wc CLIPPED,
#            " ORDER BY A.axn14,A.axn15,A.axn16,A.axn01,A.axn02,A.axn07"
#  PREPARE i006_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i006_co  CURSOR FOR i006_p1
#
#  #是否列印選擇條件
#  IF g_zz05 = 'Y' THEN
#     CALL cl_wcchp(g_wc,'axn14,axn15,axn16,axn01,axn02,axn17,axn18')
#          RETURNING l_wc
#  ELSE
#     LET l_wc = ' '
#  END IF
#
#  CALL cl_prt_cs1('agli006','agli006',g_sql,l_wc)
#
#END FUNCTION
##FUN-780013
