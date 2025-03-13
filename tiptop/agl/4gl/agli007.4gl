# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli007.4gl (copy from agli006)
# Descriptions...: 股東權益變動事項維護作業(合併)
# Date & Author..: 07/08/10 By kim (FUN-780013)
# Modify.........: No.FUN-780068 07/09/17 By Sarah 增加"異動明細產生"ACTION
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-920123 10/08/16 By vealxu 將使用axzacti的地方mark
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60144 11/06/29 By lixiang 呼叫sagli007.4gl
# Modify.........: No.FUN-BB0065 12/03/06 by belle 因為合併區另外拆aye_file,所以改為獨立程式
# Modify.........: NO.FUN-BC0089 12/03/06 By belle 合併股東權益變動表，把取進來的餘額減掉期初開帳期數
# Modify.........: NO.MOD-C10053 12/03/06 By belle 取得當年度月數最小的那一筆
# Modify.........: NO.CHI-C20007 12/03/06 By belle 修改金額錯誤
# Modify.........: NO.FUN-C20023 12/03/06 By belle 取得axh科餘時依據agli017設定的加減項
# Modify.........: NO.CHI-C80057 12/10/22 By belle  因股東權益相關科目為貸方科目屬性，取得科餘改為貸減借,並先將期初金額扣除後再乘上加減項
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#-----FUN-BB0065 start--------------------
DEFINE 
    g_aye00         LIKE aye_file.aye00,
    g_aye00_t       LIKE aye_file.aye00,
    g_aye01         LIKE aye_file.aye01,
    g_aye01_t       LIKE aye_file.aye01,
    g_aye02         LIKE aye_file.aye02,
    g_aye02_t       LIKE aye_file.aye02,
    g_aye03         LIKE aye_file.aye03,
    g_aye03_t       LIKE aye_file.aye03,
    g_aye04         LIKE aye_file.aye04,
    g_aye04_t       LIKE aye_file.aye04,
    g_aye05         LIKE aye_file.aye05,
    g_aye05_t       LIKE aye_file.aye05,
    g_aye           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables) 
        aye06       LIKE aye_file.aye06,
        aya02       LIKE aya_file.aya02,
        aye07       LIKE aye_file.aye07,
        axl02       LIKE axl_file.axl02,
        aye08       LIKE aye_file.aye08
                    END RECORD,
    g_aye_t         RECORD                   #程式變數 (舊值) 
        aye06       LIKE aye_file.aye06,
        aya02       LIKE aya_file.aya02,
        aye07       LIKE aye_file.aye07,
        axl02       LIKE axl_file.axl02,
        aye08       LIKE aye_file.aye08
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
DEFINE g_aaa04         LIKE aaa_file.aaa04     #FUN-BB0065
DEFINE g_aaa05         LIKE aaa_file.aaa05     #FUN-BB0065

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
   OPEN WINDOW i07_w AT p_row,p_col WITH FORM "agl/42f/agli007"  
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_set_comp_entry("aya02,axl02",FALSE)
   
   CALL i07_menu()
   CLOSE WINDOW i07_w              #結束畫面 

   CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION i07_menu()
   DEFINE l_cmd STRING
   WHILE TRUE
      CALL i07_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i07_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i07_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i07_r()
            END IF   
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i07_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "generate" 
            IF cl_chk_act_auth() THEN
               CALL i07_g()
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF (g_aye01 IS NOT NULL AND
                  g_aye02 IS NOT NULL AND 
                  g_aye00 IS NOT NULL) THEN
                  LET g_doc.column1 = "aye00"
                  LET g_doc.value1 = g_aye00
                  LET g_doc.column2 = "aye01"
                  LET g_doc.value2 = g_aye01
                  LET g_doc.column3 = "aye02"
                  LET g_doc.value3 = g_aye02
                  LET g_doc.column3 = "aye03"
                  LET g_doc.value3 = g_aye03
                  LET g_doc.column3 = "aye04"
                  LET g_doc.value3 = g_aye04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_aye),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i07_cs()
DEFINE  lc_qbe_sn   LIKE   gbm_file.gbm01    
    CLEAR FORM                       
    CALL g_aye.clear()          

    LET g_aye00=NULL
    LET g_aye01=NULL
    LET g_aye02=NULL
    LET g_aye03=NULL
    LET g_aye04=NULL
    LET g_aye05=NULL

    CONSTRUCT g_wc ON aye01,aye02,aye00,aye03,aye04,aye05,aye06,aye07,aye08
         FROM aye01,aye02,aye00,aye03,aye04,aye05,
              s_aye[1].aye06,s_aye[1].aye07,s_aye[1].aye08             #螢幕上取單頭條件 
        
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
               
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aye01) #族群編號                                                                                   
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.state = "c"                                                                                   
               LET g_qryparam.form = "q_axa5"                                                                               
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
               DISPLAY g_qryparam.multiret TO aye01                                                                         
               NEXT FIELD aye01                                                                                             
          WHEN INFIELD(aye02)  
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz" 
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aye02  
             NEXT FIELD aye02
          WHEN INFIELD(aye06)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form = "q_aya01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aye[1].aye06
             NEXT FIELD aye06
          WHEN INFIELD(aye07)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form  = "q_axl01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aye[1].aye07
             NEXT FIELD aye07   
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
                     
    LET g_sql = " SELECT DISTINCT aye00,aye01,aye02,aye03,aye04,aye05",
                " FROM aye_file",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY 1"
  
    PREPARE i07_prepare FROM g_sql
    DECLARE i07_cs                             #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i07_prepare
 
    LET g_sql="SELECT COUNT(*) FROM ", 
              " (SELECT DISTINCT aye00,aye01,aye02,aye03,aye04,aye05 ",
              "    FROM aye_file WHERE ",g_wc CLIPPED,")"
    PREPARE i07_precount FROM g_sql
    DECLARE i07_count CURSOR FOR i07_precount
    
END FUNCTION

FUNCTION i07_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_aye00=NULL                      
    LET g_aye01=NULL                      
    LET g_aye02=NULL                      
    LET g_aye03=NULL                      
    LET g_aye04=NULL                      
    LET g_aye05=NULL                      
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i07_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_aye00=NULL 
        LET g_aye01=NULL                      
        LET g_aye02=NULL                      
        LET g_aye03=NULL                      
        LET g_aye04=NULL                      
        LET g_aye05=NULL                      
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i07_cs                           # 從DB產生合乎條件TEMP(0-30秒)
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_aye00=NULL 
        LET g_aye01=NULL                      
        LET g_aye02=NULL                      
        LET g_aye03=NULL                      
        LET g_aye04=NULL                      
        LET g_aye05=NULL                      
    ELSE
        OPEN i07_count
        FETCH i07_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i07_fetch('F')                
    END IF
    MESSAGE ""

END FUNCTION

FUNCTION i07_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1,            #處理方式
    l_abso     LIKE type_file.num10            #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     i07_cs INTO g_aye00,g_aye01,g_aye02,g_aye03,g_aye04,g_aye05
       WHEN 'P' FETCH PREVIOUS i07_cs INTO g_aye00,g_aye01,g_aye02,g_aye03,g_aye04,g_aye05
       WHEN 'F' FETCH FIRST    i07_cs INTO g_aye00,g_aye01,g_aye02,g_aye03,g_aye04,g_aye05
       WHEN 'L' FETCH LAST     i07_cs INTO g_aye00,g_aye01,g_aye02,g_aye03,g_aye04,g_aye05
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
         FETCH ABSOLUTE g_jump i07_cs INTO g_aye00,g_aye01,g_aye02,g_aye03,g_aye04,g_aye05

         LET mi_no_ask = FALSE          
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aye02,SQLCA.sqlcode,0)
        LET g_aye00=NULL 
        LET g_aye01=NULL 
        LET g_aye02=NULL 
        LET g_aye03=NULL 
        LET g_aye04=NULL 
        LET g_aye05=NULL 
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

    DISPLAY g_aye00 TO aye00
    DISPLAY g_aye01 TO aye01
    DISPLAY g_aye02 TO aye02
    DISPLAY g_aye03 TO aye03
    DISPLAY g_aye04 TO aye04
    DISPLAY g_aye05 TO aye05
    CALL i07_b_fill(g_wc)               #單身 
    CALL cl_show_fld_cont()

END FUNCTION

FUNCTION i07_a()
    IF s_shut(0) THEN RETURN END IF         #判斷目前系統是否可用 
    MESSAGE ""
    CLEAR FORM
    CALL g_aye.clear()
    LET g_aye00_t = g_aye00
    LET g_aye01_t = g_aye01
    LET g_aye02_t = g_aye02
    LET g_aye03_t = g_aye03
    LET g_aye04_t = g_aye04
    LET g_aye05_t = g_aye05
    LET g_aye00=NULL
    LET g_aye01=NULL
    LET g_aye02=NULL
    LET g_aye03=NULL
    LET g_aye04=NULL
    LET g_aye05=NULL

    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i07_i("a")                #輸入單頭  
        IF INT_FLAG THEN                #使用者不玩了 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        IF cl_null(g_aye01) THEN
            CONTINUE WHILE
        END IF
        
        LET g_aye00_t = g_aye00
        LET g_aye01_t = g_aye01
        LET g_aye02_t = g_aye02
        LET g_aye03_t = g_aye03
        LET g_aye04_t = g_aye04
        LET g_aye05_t = g_aye05
        
        LET g_rec_b=0
        CALL i07_b()                           #輸入單身 
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i07_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,   
    l_n1            LIKE type_file.num5,   
    p_cmd           LIKE type_file.chr1,   
    l_n             LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5 

    DISPLAY BY NAME g_aye00
    DISPLAY BY NAME g_aye01
    DISPLAY BY NAME g_aye02
    DISPLAY BY NAME g_aye03
    DISPLAY BY NAME g_aye04
    DISPLAY BY NAME g_aye05

    INPUT g_aye01,g_aye02,g_aye03,g_aye04 
         WITHOUT DEFAULTS 
     FROM aye01,aye02,aye03,aye04
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i07_set_entry(p_cmd)
           CALL i07_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
         AFTER FIELD aye01
            IF NOT cl_null(g_aye01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=g_aye01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",g_aye01,g_aye02,"agl-11","","",0)  
                  NEXT FIELD aye01 
               END IF
            END IF

         AFTER FIELD aye02
            IF NOT cl_null(g_aye02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=g_aye01 AND axa02=g_aye02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD aye02
               END IF
               CALL s_aaz641_dbs(g_aye01,g_aye02) RETURNING g_dbs_axz03
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aye00
               SELECT axz06 INTO g_aye05
                 FROM axz_file 
                WHERE axz01 = g_aye02
               SELECT aaa04,aaa05 INTO g_aye03,g_aye04
                 FROM aaa_file WHERE aaa01 = g_aye00

               DISPLAY g_aye03 TO aye03
               DISPLAY g_aye04 TO aye04
               DISPLAY g_aye05 TO aye05
               DISPLAY g_aye00 TO aye00
            END IF

        ON ACTION controlp
           CASE
             WHEN INFIELD(aye01) #族群編號                                                                                   
                  CALL cl_init_qry_var()                                                                                       
                  LET g_qryparam.form = "q_axa5"                                                                               
                  LET g_qryparam.default1 =g_aye01
                  CALL cl_create_qry() RETURNING g_aye01
                  DISPLAY BY NAME g_aye01
                  NEXT FIELD aye01                                                                                             
             WHEN INFIELD(aye02)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz" 
                  LET g_qryparam.default1 =g_aye02
                  CALL cl_create_qry() RETURNING g_aye02
                  DISPLAY BY NAME g_aye02
                  NEXT FIELD aye02
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
 
FUNCTION i07_b()
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
 
    LET g_forupd_sql = "SELECT aye06,'',aye07,'',aye08",
                       "  FROM aye_file WHERE aye00=? AND aye01=? AND aye02=? ",
                       "   AND aye03=? AND aye04=? AND aye05=? ",
                       "   AND aye06=? AND aye07=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i07_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_aye WITHOUT DEFAULTS FROM s_aye.*
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
          LET g_aye_t.* = g_aye[l_ac].*  #BACKUP
 
          LET g_before_input_done = FALSE                                      
          CALL i07_set_entry(p_cmd)                                           
          CALL i07_set_no_entry(p_cmd)                                        
          LET g_before_input_done = TRUE                                       
 
          OPEN i07_bcl USING g_aye00,g_aye01,g_aye02,
                             g_aye03,g_aye04,g_aye05,
                             g_aye_t.aye06,g_aye_t.aye07
          IF STATUS THEN
             CALL cl_err("OPEN i07_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i07_bcl INTO g_aye[l_ac].* 
             IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aye_t.aye06,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
             END IF
             SELECT aya02 INTO g_aye[l_ac].aya02 FROM aya_file 
              WHERE aya01=g_aye[l_ac].aye06
                AND aya07 = 'Y'
             SELECT axl02 INTO g_aye[l_ac].axl02 FROM axl_file 
              WHERE axl01=g_aye[l_ac].aye07
          END IF
          CALL cl_show_fld_cont()     
       END IF
 
    BEFORE INSERT
       LET l_n = ARR_COUNT()
       LET p_cmd='a'
       LET g_before_input_done = FALSE                                        
       CALL i07_set_entry(p_cmd)                                             
       CALL i07_set_no_entry(p_cmd)                                          
       LET g_before_input_done = TRUE                                         
       INITIALIZE g_aye[l_ac].* TO NULL
       LET g_aye_t.* = g_aye[l_ac].*   
       CALL cl_show_fld_cont()     
       NEXT FIELD aye06
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i07_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                   

        IF (NOT cl_null(g_aye[l_ac].aye06)) AND (NOT cl_null(g_aye[l_ac].aye07)) THEN
           IF (g_aye[l_ac].aye06 != g_aye_t.aye06 OR g_aye_t.aye06 IS NULL) OR
              (g_aye[l_ac].aye07 != g_aye_t.aye07 OR g_aye_t.aye07 IS NULL) THEN
              SELECT count(*) INTO g_cnt FROM aye_file
               WHERE aye06 = g_aye[l_ac].aye06
                 AND aye07 = g_aye[l_ac].aye07
                 AND aye00 = g_aye00
                 AND aye01 = g_aye01
                 AND aye02 = g_aye02
                 AND aye03 = g_aye03
                 AND aye04 = g_aye04
                 AND aye05 = g_aye05
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aye[l_ac].aye06 = g_aye_t.aye06
                 NEXT FIELD aye06
              END IF
           END IF
        END IF 
        INSERT INTO aye_file(aye00,aye01,aye02,aye03,aye04,aye05,aye06,aye07,aye08,ayelegal,ayeoriu,ayeorig)
                      VALUES(g_aye00,g_aye01,g_aye02,g_aye03,g_aye04,g_aye05,
                             g_aye[l_ac].aye06,g_aye[l_ac].aye07,g_aye[l_ac].aye08,g_legal,g_user,g_grup)
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","aye_file",g_aye[l_ac].aye06,"",
                         SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b = g_rec_b + 1
           DISPLAY g_rec_b TO FORMONLY.cn2 
           COMMIT WORK
        END IF

    AFTER FIELD aye06 
        IF NOT cl_null(g_aye[l_ac].aye06) THEN
           SELECT COUNT(*) INTO l_cnt FROM aya_file 
            WHERE aya01=g_aye[l_ac].aye06
              AND aya07 = 'Y'
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aye[l_ac].aye06=g_aye_t.aye06
              NEXT FIELD aye06
              DISPLAY BY NAME g_aye[l_ac].aye06
           END IF
           SELECT aya02 INTO g_aye[l_ac].aya02 FROM aya_file 
            WHERE aya01=g_aye[l_ac].aye06
              AND aya07 = 'Y'
        END IF
        IF (NOT cl_null(g_aye[l_ac].aye06)) AND (NOT cl_null(g_aye[l_ac].aye07)) THEN
           IF (g_aye[l_ac].aye06 != g_aye_t.aye06 OR g_aye_t.aye06 IS NULL) OR
              (g_aye[l_ac].aye07 != g_aye_t.aye07 OR g_aye_t.aye07 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aye_file
               WHERE aye06 = g_aye[l_ac].aye06 AND aye07=g_aye[l_ac].aye07 
                 AND aye00=g_aye00 AND aye01=g_aye01 AND aye02=g_aye02
                 AND aye03=g_aye03 AND aye04=g_aye04 AND aye05=g_aye05
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aye[l_ac].aye06 = g_aye_t.aye06
                 NEXT FIELD aye06
              END IF
           END IF
        END IF

    AFTER FIELD aye07  
        IF NOT cl_null(g_aye[l_ac].aye07) THEN
           SELECT COUNT(*) INTO l_cnt FROM axl_file WHERE axl01=g_aye[l_ac].aye07
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aye[l_ac].aye07=g_aye_t.aye07
              NEXT FIELD aye07
              DISPLAY BY NAME g_aye[l_ac].aye07
           END IF 
           SELECT axl02 INTO g_aye[l_ac].axl02 FROM axl_file WHERE axl01=g_aye[l_ac].aye07
        END IF
        IF (NOT cl_null(g_aye[l_ac].aye06)) AND (NOT cl_null(g_aye[l_ac].aye07)) THEN
           IF (g_aye[l_ac].aye06 != g_aye_t.aye06 OR g_aye_t.aye06 IS NULL) OR
              (g_aye[l_ac].aye07 != g_aye_t.aye07 OR g_aye_t.aye07 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aye_file
               WHERE aye06 = g_aye[l_ac].aye06 AND aye07=g_aye[l_ac].aye07 
                 AND aye00=g_aye00 AND aye01=g_aye01 AND aye02=g_aye02
                 AND aye03=g_aye03 AND aye04=g_aye04 AND aye05=g_aye05
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aye[l_ac].aye07= g_aye_t.aye07
                 NEXT FIELD aye06
              END IF
           END IF
        END IF
 
    BEFORE DELETE
        IF g_rec_b>=l_ac THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL         
            LET g_doc.column1 = "aye06"           
            LET g_doc.value1 = g_aye[l_ac].aye06 
            CALL cl_del_doc()                   
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM aye_file WHERE aye00=g_aye00 
                                   AND aye01=g_aye01
                                   AND aye02=g_aye02
                                   AND aye06=g_aye_t.aye06
                                   AND aye07=g_aye_t.aye07 
                                   AND aye08=g_aye_t.aye08
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aye_file",g_aye_t.aye06,"",SQLCA.sqlcode,"","",1)
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
           LET g_aye[l_ac].* = g_aye_t.*
           CLOSE i07_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_aye[l_ac].aye06,-263,0)
           LET g_aye[l_ac].* = g_aye_t.*
        ELSE
           UPDATE aye_file 
               SET aye06=g_aye[l_ac].aye06,aye07=g_aye[l_ac].aye07,
                   aye08=g_aye[l_ac].aye08
            WHERE aye00 = g_aye00
              AND aye01 = g_aye01
              AND aye02 = g_aye02
              AND aye03 = g_aye03
              AND aye04 = g_aye04
              AND aye05 = g_aye05
              AND aye06 = g_aye_t.aye06
              AND aye07 = g_aye_t.aye07
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","aye_file",g_aye[l_ac].aye06,"",
                           SQLCA.sqlcode,"","",1)
              LET g_aye[l_ac].* = g_aye_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()      
        #LET l_ac_t = l_ac  #FUN-D30032 

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_aye[l_ac].* = g_aye_t.*
           #FUN-D30032--add--str--
           ELSE
              CALL g_aye.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30032--add--end--
           END IF
           CLOSE i07_bcl        
           ROLLBACK WORK        
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  #FUN-D30032 
        CLOSE i07_bcl         
        COMMIT WORK

     ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aye06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aya01"
                LET g_qryparam.default1 = g_aye[l_ac].aye06
                CALL cl_create_qry() RETURNING g_aye[l_ac].aye06
                DISPLAY g_aye[l_ac].aye07 TO aye06
             WHEN INFIELD(aye07)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axl01"
                LET g_qryparam.default1 = g_aye[l_ac].aye07
                CALL cl_create_qry() RETURNING g_aye[l_ac].aye07,g_aye[l_ac].axl02
                DISPLAY g_aye[l_ac].aye08 TO aye07 
             OTHERWISE
                EXIT CASE
          END CASE
 
     ON ACTION CONTROLO              
         IF INFIELD(aye06) AND l_ac > 1 THEN
             LET g_aye[l_ac].* = g_aye[l_ac-1].*
             NEXT FIELD aye06
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
 
 
    CLOSE i07_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i07_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc             STRING       

    LET g_sql =
     "SELECT aye06,'',aye07,'',aye08",
     " FROM aye_file",
     " WHERE ", p_wc CLIPPED, 
     " AND aye00 = '",g_aye00,"'",
     " AND aye01 = '",g_aye01,"'",
     " AND aye02 = '",g_aye02,"'",
     " AND aye03 = '",g_aye03,"'",
     " AND aye04 = '",g_aye04,"'",
     " AND aye05 = '",g_aye05,"'",
     " ORDER BY aye06"
   
    PREPARE i07_pb FROM g_sql
    DECLARE aye_curs CURSOR FOR i07_pb
 
    CALL g_aye.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!" 
    FOREACH aye_curs INTO g_aye[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        SELECT aya02 INTO g_aye[g_cnt].aya02 FROM aya_file 
         WHERE aya01=g_aye[g_cnt].aye06
           AND aya07 = 'Y'
        SELECT axl02 INTO g_aye[g_cnt].axl02 FROM axl_file 
         WHERE axl01=g_aye[g_cnt].aye07
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aye.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i07_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aye TO s_aye.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i07_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY        

      ON ACTION previous
         CALL i07_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY          

      ON ACTION jump
         CALL i07_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY          

      ON ACTION next
         CALL i07_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
        ACCEPT DISPLAY           

       ON ACTION last
         CALL i07_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY 
      ON ACTION generate   
         LET g_action_choice="generate"
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

FUNCTION i07_r()
    
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_aye01) OR cl_null(g_aye02) THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i07_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CLOSE i07_cs ROLLBACK WORK RETURN 
    END IF
    
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL           
        LET g_doc.column1 = "aye01"          
        LET g_doc.value1 = g_aye01      
        LET g_doc.column2 = "aye02"          
        LET g_doc.value2 = g_aye02      
        LET g_doc.column3 = "aye00"          
        LET g_doc.value3 = g_aye00      
        LET g_doc.column4 = "aye03"          
        LET g_doc.value4 = g_aye03      
        LET g_doc.column5 = "aye04"          
        LET g_doc.value5 = g_aye04      
        CALL cl_del_doc()                                            
       MESSAGE "Delete aye!"
       DELETE FROM aye_file
        WHERE aye00 = g_aye00  
          AND aye01 = g_aye01  
          AND aye02 = g_aye02  
          AND aye03 = g_aye03  
          AND aye04 = g_aye04  
          AND aye05 = g_aye05  
          
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","aye_file",g_aye01,g_aye02,STATUS,"","No aye deleted",1)  
          CLOSE i07_cs ROLLBACK WORK RETURN
       END IF
       
       CLEAR FORM
       CALL g_aye.clear()
       INITIALIZE g_aye00 TO NULL
       INITIALIZE g_aye01 TO NULL
       INITIALIZE g_aye02 TO NULL
       INITIALIZE g_aye03 TO NULL
       INITIALIZE g_aye04 TO NULL
       INITIALIZE g_aye05 TO NULL
       MESSAGE ""
         OPEN i07_count
         FETCH i07_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i07_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i07_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         #No.FUN-6A0067
            CALL i07_fetch('/')
         END IF
    END IF
    CLOSE i07_cs
    COMMIT WORK
END FUNCTION

#--FUN-BB0065 start--
FUNCTION i07_g()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
DEFINE l_flag      LIKE type_file.chr1
DEFINE li_result   LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE  tm    RECORD
              axa01   LIKE axa_file.axa01,
              axa02   LIKE axa_file.axa02,
              aye00   LIKE aye_file.aye00,    #帳別
              a       LIKE axa_file.axa06,
              yy      LIKE aye_file.aye03,    #年度
              mm      LIKE aye_file.aye04,    #期別
              q1      LIKE type_file.num5, 
              h1      LIKE type_file.num5
              END RECORD 
DEFINE p_row,p_col   LIKE type_file.num5  
DEFINE l_dbs         LIKE type_file.chr21    
DEFINE  l_axz03      LIKE axz_file.axz03  

   OPEN WINDOW i07_g_w AT p_row,p_col WITH FORM "agl/42f/agli007_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("agli007_g")
 
   
   INITIALIZE tm.* TO NULL
   DISPLAY BY NAME tm.axa01
   DISPLAY BY NAME tm.axa02
   DISPLAY BY NAME tm.a
   DISPLAY BY NAME tm.yy
   DISPLAY BY NAME tm.mm
   
   WHILE TRUE
      #INPUT BY NAME tm.axa01,tm.axa02,tm.a,tm.yy,tm.mm WITHOUT DEFAULTS
      INPUT BY NAME tm.axa01,tm.axa02,tm.a,tm.yy,tm.mm,tm.q1,tm.h1 WITHOUT DEFAULTS   #FUN-BB0065
      
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn) 
            INITIALIZE tm.* TO NULL
 
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)  
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02
            IF NOT cl_null(tm.axa02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02
               END IF
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
               CALL s_get_aaz641(g_dbs_axz03) RETURNING tm.aye00
               #--FUN-C80057 mark--
               #SELECT aaa04,aaa05 INTO tm.yy,tm.mm
               #  FROM aaa_file WHERE aaa01 = tm.aye00
               #DISPLAY BY NAME tm.yy
               #DISPLAY BY NAME tm.mm
               #FUN-C80057 mark--

               SELECT axz06 INTO g_aye05
                 FROM axz_file 
                WHERE axz01 = tm.axa02

               SELECT axa06 
                 INTO tm.a  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
                FROM axa_file
               WHERE axa01 = tm.axa01     #族群編號
                 AND axa04 = 'Y'   #最上層公司否
               IF cl_null(tm.a) THEN LET tm.a = '2' END IF
               DISPLAY BY NAME tm.a
 
               CALL i07_g_set_entry()    
               CALL i07_g_set_no_entry(tm.a)

               IF tm.a = '1' THEN
                   LET tm.q1 = '' 
                   LET tm.h1 = '' 
                  #LET tm.mm = g_aaa05    #FUN-C80057 mark
                   LET tm.mm = ''         #FUN-C80057 mod
               END IF
               IF tm.a = '2' THEN
                   LET tm.h1 = '' 
                   LET tm.mm = '' 
               END IF
               IF tm.a = '3' THEN
                   LET tm.mm = '' 
                   LET tm.q1 = ''
               END IF
               IF tm.a = '4' THEN
                   LET tm.mm = '' 
                   LET tm.q1 = ''
                   let tm.h1 = ''
               END IF
               DISPLAY BY NAME tm.mm
               DISPLAY BY NAME tm.q1
               DISPLAY BY NAME tm.h1
               DISPLAY BY NAME tm.aye00
               DISPLAY BY NAME tm.yy
               DISPLAY BY NAME tm.mm
            END IF

         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD yy
            END IF
            IF tm.yy < 0 THEN NEXT FIELD yy END IF
 
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD mm
            END IF
 

         ON ACTION CONTROLP
            CASE
             WHEN INFIELD(axa01) #族群編號                                                                                   
                  CALL cl_init_qry_var()                                                                                       
                  LET g_qryparam.form = "q_axa5"                                                                               
                  LET g_qryparam.default1 =tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01 
                  DISPLAY BY NAME tm.axa01
                  NEXT FIELD axa01                                                                                             
             WHEN INFIELD(axa02)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz" 
                  LET g_qryparam.default1 =tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
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
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF NOT cl_null(tm.a) THEN
               IF tm.a <> '1' THEN #月 
                   CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03
                   CALL s_get_aznn01(l_axz03,tm.a,tm.aye00,tm.yy,tm.q1,tm.h1) RETURNING tm.mm
               END IF
            END IF
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i07_g_w
         RETURN
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i07_g_w
         RETURN
      END IF
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i07_g_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'
         CALL i07_g1(tm.*)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE

   CLOSE WINDOW i07_g_w
END FUNCTION

FUNCTION i07_g1(tm)
DEFINE  tm    RECORD
              axa01   LIKE axa_file.axa01,
              axa02   LIKE axa_file.axa02,
              aye00   LIKE aye_file.aye00,    #帳別
              a       LIKE axa_file.axa06,
              yy      LIKE aye_file.aye03,    #年度
              mm      LIKE aye_file.aye04,    #期別
              q1      LIKE type_file.num5, 
              h1      LIKE type_file.num5
              END RECORD,
       l_cnt       LIKE type_file.num5,
       sr          RECORD
                   aaj03  LIKE aaj_file.aaj03,   #CHI-C20007
                   aye06  LIKE aye_file.aye06,   #分類代碼
                   aye07  LIKE aye_file.aye07,   #群組代碼
                   aye08  LIKE aye_file.aye08    #異動金額
                  ,aaj06  LIKE aaj_file.aaj06    #FUN-C20023
                   END RECORD
DEFINE l_aaj03     LIKE aaj_file.aaj03,   #科目
       l_aag06     LIKE aag_file.aag06 
DEFINE l_axh08     LIKE axh_file.axh08
DEFINE l_axh09     LIKE axh_file.axh09
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_ayd04     LIKE ayd_file.ayd04    #FUN-BC0089
DEFINE l_ayd08     LIKE ayd_file.ayd08    #FUN-BC0089
DEFINE l_aye06     LIKE aye_file.aye06    #FUN-BC0089
DEFINE l_aye07     LIKE aye_file.aye07    #FUN-BC0089
DEFINE l_axz03     LIKE axz_file.axz03    #FUN-BB0065

   #--FUN-BB0065 start--
   IF tm.a <> '1' THEN
       CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03
       CALL s_get_aznn01(l_axz03,tm.a,tm.aye00,tm.yy,tm.q1,tm.h1) RETURNING tm.mm
   END IF
   #--FUN-BB0065 end--

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM aye_file
    WHERE aye01 = tm.axa01
      AND aye02 = tm.axa02
      AND aye03 = tm.yy 
      AND aye04 = tm.mm 
      AND aye00 = tm.aye00
   IF l_cnt > 0 THEN
      #先將舊資料刪除，再重新產生
      DELETE FROM aye_file
       WHERE aye01 = tm.axa01
         AND aye02 = tm.axa02
         AND aye03 = tm.yy 
         AND aye04 = tm.mm 
         AND aye00 = tm.aye00
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("del","aye_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del aye",1)
         LET g_success='N'
         RETURN
      END IF
   END IF

#--CHI-C20007 mark start--
#  LET g_sql ="SELECT aaj03 FROM aaj_file ",
#             " WHERE aaj00='",tm.aye00,"'",
#             "   AND aaj01='",tm.axa01,"'",
#             "   AND aaj02='",tm.axa02,"'"
#       
#  PREPARE i007_aajbc_p FROM g_sql
#  DECLARE i007_aajbc_cs CURSOR FOR i007_aajbc_p
#  LET l_flag = 'N'                                                      
#  FOREACH i007_aajbc_cs INTO l_aaj03 
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        LET g_success='N'
#        EXIT FOREACH
#     END IF  
#---CHI-C20007 mark end---      

     #LET g_sql ="SELECT aaj04,aaj05,'' ",                #CHI-C20007 mark
     #LET g_sql ="SELECT aaj03,aaj04,aaj05,'' ",          #FUN-C20023 mark  #CHI-C20007
      LET g_sql ="SELECT aaj03,aaj04,aaj05,'',aaj06 ",    #FUN-C20023
                 "  FROM aaj_file ",
                 " WHERE aaj00='",tm.aye00,"' ",
                 "   AND aaj01='",tm.axa01,"'",
                 "   AND aaj02='",tm.axa02,"'",
                #"   AND aaj03='",l_aaj03,"' "                       #CHI-C20007
                #"  GROUP BY aaj04,aaj05,aaj01,aaj02,aaj03"          #FUN-C20023 mark #CHI-C20007
                 "  GROUP BY aaj04,aaj05,aaj01,aaj02,aaj03,aaj06"    #FUN-C20023
      PREPARE i007_ayebc_p FROM g_sql
      DECLARE i007_ayebc_cs CURSOR FOR i007_ayebc_p
   
      FOREACH i007_ayebc_cs INTO sr.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
        
         LET l_axh08 = 0
         LET l_axh09 = 0
         SELECT axh08,axh09 INTO l_axh08,l_axh09 
           FROM axh_file
          WHERE axh00=tm.aye00
            AND axh01=tm.axa01
            AND axh02=tm.axa02
           #AND axh05=l_aaj03      #CHI-C20007
            AND axh05= sr.aaj03    #CHI-C20007 mod
            AND axh06=tm.yy
            AND axh07=tm.mm
            AND axh12=g_aye05
         IF cl_null(l_axh08) THEN
            LET l_axh08=0
         END IF
         IF cl_null(l_axh09) THEN
            LET l_axh09=0
         END IF
        #LET sr.aye08 = l_axh08 - l_axh09    #CHI-C80057 mark
         LET sr.aye08 = l_axh09 - l_axh08    #CHI-C80057
        #FUN-C20023--Begin Mark--
        #SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=l_aaj03 AND aag00=tm.aye00
        #IF l_aag06 = '2' THEN
        #   LET sr.aye08 = sr.aye08 * (-1)
        #END IF
        #FUN-C20023---End Mark---
         IF sr.aaj06 = '-' THEN                    #FUN-C20023
            LET sr.aye08 = sr.aye08 * (-1)         #FUN-C20023
         END IF                                    #FUN-C20023
         IF cl_null(sr.aye08) THEN
            LET sr.aye08=0
         END IF
         IF sr.aye08 <> 0 THEN    #CHI-C20007
            INSERT INTO aye_file(aye00,aye01,aye02,aye03,aye04,aye05,
                                 aye06,aye07,aye08,ayelegal,ayeoriu,ayeorig)
                          VALUES(tm.aye00,tm.axa01,tm.axa02,tm.yy,tm.mm,
                                 g_aye05,sr.aye06,sr.aye07,sr.aye08,g_legal,g_user,g_grup)      
            LET l_flag = 'Y'              
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #SQLCA.SQLCODE=-239
               UPDATE aye_file SET aye08 = aye08 + sr.aye08
                          WHERE aye00 = tm.aye00
                            AND aye01 = tm.axa01
                            AND aye02 = tm.axa02
                            AND aye03 = tm.yy
                            AND aye04 = tm.mm
                            AND aye05 = g_aye05
                            AND aye06 = sr.aye06
                            AND aye07 = sr.aye07
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","aye_file",sr.aye06,sr.aye07,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","aye_file",sr.aye06,sr.aye07,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
            END IF
         END IF  #CHI-C20007
      END FOREACH
  #END FOREACH   #CHI-C20007 mark
  #FUN-BC0089--Begin--
  #算出該分類,群組代碼餘額的期別與餘額
  #LET g_sql = " SELECT MAX(ayd04) "            #MOD-C10053 mark
   LET g_sql = " SELECT MIN(ayd04) "            #MOD-C10053
              ," FROM ayd_file"
              ," WHERE ayd00 = '",tm.aye00,"'"
              ," AND ayd01 = '",tm.axa01,"'"
              ," AND ayd02 = '",tm.axa02,"'"
              ," AND ayd03 = '",tm.yy,"'"
              ," AND ayd05 = '",g_aye05,"'"
   PREPARE i007_ayd_p1 FROM g_sql
   DECLARE i007_ayd_cs1 SCROLL CURSOR WITH HOLD FOR i007_ayd_p1
   OPEN i007_ayd_cs1
   FETCH LAST i007_ayd_cs1 INTO l_ayd04
   IF NOT cl_null(l_ayd04) THEN
     #算出該分類,群組代碼餘額的期別與餘額
      LET g_sql = " SELECT aye06,aye07 "
                 ," FROM aye_file " 
                 ," WHERE aye00 = '",tm.aye00,"'"
                 ,"   AND aye01 = '",tm.axa01,"'"
                 ,"   AND aye02 = '",tm.axa02,"'"
                 ,"   AND aye03 = '",tm.yy,"'"
                 ,"   AND aye04 = '",tm.mm,"'"
                 ,"   AND aye05 = '",g_aye05,"'"
      PREPARE i007_aye_p2 FROM g_sql
      DECLARE i007_aye_cs2 CURSOR FOR i007_aye_p2
      LET l_aye06 = ''  #CHI-C20007
      LET l_aye07 = 0   #CHI-C20007
      FOREACH i007_aye_cs2 INTO l_aye06,l_aye07
         LET l_ayd08 = 0 
         LET g_sql = " SELECT ayd08 "
                    ," FROM ayd_file"
                    ," WHERE ayd00 = '",tm.aye00,"'"
                    ," AND ayd01 = '",tm.axa01,"'"
                    ," AND ayd02 = '",tm.axa02,"'"
                    ," AND ayd03 = '",tm.yy,"'"
                    ," AND ayd04 = '",l_ayd04,"'"
                    ," AND ayd05 = '",g_aye05,"'"
                    ," AND ayd06 = '",l_aye06,"'"
                    ," AND ayd07 = '",l_aye07,"'"
         PREPARE i007_ayd_p2 FROM g_sql
         DECLARE i007_ayd_cs2 SCROLL CURSOR WITH HOLD FOR i007_ayd_p2
         OPEN i007_ayd_cs2
         FETCH LAST i007_ayd_cs2 INTO l_ayd08
        #IF NOT cl_null(l_ayd08) THEN        #CHI-C20007
        #CHI-C20007--start--
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt 
           FROM aye_file 
           WHERE aye00 = tm.aye00
             AND aye01 = tm.axa01
             AND aye02 = tm.axa02
             AND aye03 = tm.yy
             AND aye04 = tm.mm
             AND aye05 = g_aye05
             AND aye06 = l_aye06
             AND aye07 = l_aye07
          IF l_cnt > 0 THEN
        #CHI-C20007---end---
            UPDATE aye_file SET aye08 = aye08 - l_ayd08
                       WHERE aye00 = tm.aye00
                         AND aye01 = tm.axa01
                         AND aye02 = tm.axa02
                         AND aye03 = tm.yy
                         AND aye04 = tm.mm
                         AND aye05 = g_aye05
                         AND aye06 = l_aye06
                         AND aye07 = l_aye07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","aye_file",l_aye06,l_aye07,SQLCA.sqlcode,"","",1)
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
      END FOREACH
   END IF
  #FUN-BC0089---End---
END FUNCTION    
#--FUN-BB0065 end-------

FUNCTION i07_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("aye01,aye02,aye03,aye04",TRUE)
   END IF

END FUNCTION

FUNCTION i07_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("aye01,aye02,aye03,aye04",FALSE)
   END IF
END FUNCTION

#---FUN-BB0065 start---
FUNCTION i07_g_set_entry()
  DEFINE p_cmd   LIKE type_file.chr1         
   CALL cl_set_comp_entry("q1,mm,h1",TRUE)  
END FUNCTION

FUNCTION i07_g_set_no_entry(p_a)
  DEFINE p_cmd   LIKE type_file.chr1      
  DEFINE p_a     LIKE type_file.chr1

   CALL cl_set_comp_entry("a",FALSE) 

   IF p_a ="1" THEN  #月
      CALL cl_set_comp_entry("q1,h1",FALSE) 
   END IF
   IF p_a ="2" THEN  #季
      CALL cl_set_comp_entry("mm,h1",FALSE) 
   END IF
   IF p_a ="3" THEN  #半年
      CALL cl_set_comp_entry("mm,q1",FALSE) 
   END IF
   IF p_a ="4" THEN  #年
      CALL cl_set_comp_entry("q1,mm,h1",FALSE) 
   END IF
END FUNCTION
#-----FUN-BB0065 end----------------------

#No.FUN-B60144--mark
##模組變數(Module Variables)
#DEFINE
#   g_axo11           LIKE axo_file.axo11,
#   g_axo11_t         LIKE axo_file.axo11,
#   g_axo12           LIKE axo_file.axo12,
#   g_axo12_t         LIKE axo_file.axo12,   
#   g_axo13           LIKE axo_file.axo13,
#   g_axo13_t         LIKE axo_file.axo13,   
#   g_axo01           LIKE axo_file.axo01,
#   g_axo01_t         LIKE axo_file.axo01,
#   g_axo02           LIKE axo_file.axo02,
#   g_axo02_t         LIKE axo_file.axo02,
#   g_axo             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
#       axo14         LIKE axo_file.axo14,
#       aya02         LIKE aya_file.aya02,
#       axo04         LIKE axo_file.axo04,
#       axo15         LIKE axo_file.axo15,
#       axl02         LIKE axl_file.axl02
#                     END RECORD,
#   g_axo_t           RECORD                 #程式變數 (舊值)
#       axo14         LIKE axo_file.axo14,
#       aya02         LIKE aya_file.aya02,
#       axo04         LIKE axo_file.axo04,
#       axo15         LIKE axo_file.axo15,
#       axl02         LIKE axl_file.axl02
#                     END RECORD,
#   a                 LIKE type_file.chr1,
#   g_wc,g_sql        STRING,
#   g_show            LIKE type_file.chr1,   
#   g_rec_b           LIKE type_file.num5,   #單身筆數
#   g_flag            LIKE type_file.chr1,   
#   g_ss              LIKE type_file.chr1,   
#   l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT
#   g_argv1           LIKE axo_file.axo11,
#   g_argv2           LIKE axo_file.axo12,
#   g_argv3           LIKE axo_file.axo13,
#   g_argv4           LIKE axo_file.axo01,
#   g_argv5           LIKE axo_file.axo02 
#No.FUN-B60144--mark--end--

#DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT

#No.FUN-B60144--mark--
##主程式開始
#DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
#DEFINE   g_sql_tmp    STRING   #No.TQC-720019
#DEFINE   g_before_input_done   LIKE type_file.num5
#DEFINE   g_cnt                 LIKE type_file.num10
#DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
#DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
#DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER
#No.FUN-B60144--mark--

#MAIN   #FUN-BB0065 mark
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
 
#--FUN-BB0065 mark start---
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
#--FUN-BB0065 mark end-------

#No.FUN-B60144--mark
 # LET g_argv1 =ARG_VAL(1)
 # LET g_argv2 =ARG_VAL(2)
 # LET g_argv3 =ARG_VAL(3)
 # LET g_argv4 =ARG_VAL(4)
 # LET g_argv5 =ARG_VAL(5)
 
 # LET p_row = 3 LET p_col = 16
 
 # OPEN WINDOW i007_w AT p_row,p_col
 #   WITH FORM "agl/42f/agli007"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
 # CALL cl_ui_init()
 
 # IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
 #    (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
 #    (NOT cl_null(g_argv5)) THEN
 #    CALL i007_q()
 # END IF   
 # CALL i007_menu()
 
 # CLOSE WINDOW i007_w                 #結束畫面
#No.FUN-B60144--mark

#--FUN-BB0065 mark start--
#   CALL i007('1')       #No.FUN-B60144    
#   CALL cl_used(g_prog,g_time,2) RETURNING g_time
#END MAIN
#--FUN-BB0065 mark end---

#No.FUN-B60144--mark
##QBE 查詢資料
#FUNCTION i007_cs()
#DEFINE l_sql STRING
#
#  IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
#     (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
#     (NOT cl_null(g_argv5)) THEN
#      LET g_wc = "     axo11 = '",g_argv1,"'",
#                 " AND axo12 = '",g_argv2,"'",
#                 " AND axo13 = '",g_argv3,"'",
#                 " AND axo01 = '",g_argv4,"'",
#                 " AND axo02 = '",g_argv5,"'"
#   ELSE
#      CLEAR FORM                            #清除畫面
#      CALL g_axo.clear()
#      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
#      INITIALIZE g_axo11 TO NULL
#      INITIALIZE g_axo12 TO NULL
#      INITIALIZE g_axo13 TO NULL
#      INITIALIZE g_axo01 TO NULL
#      INITIALIZE g_axo02 TO NULL
#      CONSTRUCT g_wc ON axo11,axo12,axo13,axo01,axo02,
#                        axo14,axo04,axo15
#         FROM axo11,axo12,axo13,axo01,axo02,s_axo[1].axo14,
#              s_axo[1].axo04,s_axo[1].axo15
#          
#
#      #No.FUN-580031 --start--     HCN
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#      #No.FUN-580031 --end--       HCN
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(axo11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_axz"
#               LET g_qryparam.state ="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO axo11
#               NEXT FIELD axo11
#            WHEN INFIELD(axo14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form  = "q_aya"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_axo[1].axo14
#               NEXT FIELD axo14
#            WHEN INFIELD(axo15)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form  = "q_axl"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_axo[1].axo15
#               NEXT FIELD axo15
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
#      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axouser', 'axogrup') #FUN-980030
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
#   LET l_sql="SELECT DISTINCT axo11,axo12,axo13,axo01,axo02 FROM axo_file ",
#              " WHERE ", g_wc CLIPPED
#   LET g_sql= l_sql," ORDER BY axo11,axo12,axo13,axo01,axo02"
#   PREPARE i007_prepare FROM g_sql      #預備一下
#   DECLARE i007_bcs                     #宣告成可捲動的
#       SCROLL CURSOR WITH HOLD FOR i007_prepare
#
#   DROP TABLE i007_cnttmp
#   LET l_sql=l_sql," INTO TEMP i007_cnttmp"      #No.TQC-720019
#   LET g_sql_tmp=l_sql," INTO TEMP i007_cnttmp"  #No.TQC-720019
#   
#   PREPARE i007_cnttmp_pre FROM l_sql       #No.TQC-720019
#   PREPARE i007_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
#   EXECUTE i007_cnttmp_pre    
#   
#   LET g_sql="SELECT COUNT(*) FROM i007_cnttmp"
#
#   PREPARE i007_precount FROM g_sql
#   DECLARE i007_count CURSOR FOR i007_precount
#
#   IF NOT cl_null(g_argv1) THEN
#      LET g_axo11=g_argv1
#   END IF
#
#   IF NOT cl_null(g_argv2) THEN
#      LET g_axo12=g_argv2
#   END IF
#
#   IF NOT cl_null(g_argv3) THEN
#      LET g_axo13=g_argv3
#   END IF
#
#   IF NOT cl_null(g_argv4) THEN
#      LET g_axo01=g_argv4
#   END IF
#
#   IF NOT cl_null(g_argv5) THEN
#      LET g_axo02=g_argv5
#   END IF
#   CALL i007_show()
#
#END FUNCTION
#
#FUNCTION i007_menu()
#
#  WHILE TRUE
#     CALL i007_bp("G")
#     CASE g_action_choice
#        WHEN "insert"
#           IF cl_chk_act_auth() THEN
#              CALL i007_a()
#           END IF
#        WHEN "query"
#           IF cl_chk_act_auth() THEN
#              CALL i007_q()
#           END IF
#          WHEN "delete" 
#             IF cl_chk_act_auth() THEN
#                CALL i007_r()
#             END IF
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i007_copy()
#           END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL i007_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#       #str FUN-780068 add 10/19
#        WHEN "generate"   #異動明細產生
#           IF cl_chk_act_auth() THEN
#              CALL i007_g()
#           END IF
#       #end FUN-780068 add 10/19
#        WHEN "help"
#           CALL cl_show_help()
#        WHEN "exit"
#           EXIT WHILE
#        WHEN "controlg"
#           CALL cl_cmdask()
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL i007_out()
#           END IF
#        WHEN "exporttoexcel"
#           IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel
#              (ui.Interface.getRootNode(),
#               base.TypeInfo.create(g_axo),'','')
#           END IF
#        WHEN "related_document"           #相關文件
#         IF cl_chk_act_auth() THEN
#            IF g_axo11 IS NOT NULL THEN
#               LET g_doc.column1 = "axo11"
#               LET g_doc.column2 = "axo12"
#               LET g_doc.column3 = "axo13"
#               LET g_doc.value1 = g_axo11
#               LET g_doc.value2 = g_axo12
#               LET g_doc.value3 = g_axo13
#               CALL cl_doc()
#            END IF 
#         END IF
#     END CASE
#  END WHILE
#END FUNCTION
#
#FUNCTION i007_a()
#  MESSAGE ""
#  CLEAR FORM
#  CALL g_axo.clear()
#  LET g_axo11_t  = NULL
#  LET g_axo12_t  = NULL
#  LET g_axo13_t  = NULL
#  LET g_axo01_t  = NULL
#  LET g_axo02_t  = NULL
#  CALL cl_opmsg('a')
#
#  WHILE TRUE
#     CALL i007_i("a")                   #輸入單頭
#
#     IF INT_FLAG THEN                   #使用者不玩了
#        LET g_axo11=NULL
#        LET g_axo12=NULL
#        LET g_axo13=NULL
#        LET g_axo01=NULL
#        LET g_axo02=NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
#
#     IF g_ss='N' THEN
#        CALL g_axo.clear()
#     ELSE
#        CALL i007_b_fill('1=1')            #單身
#     END IF
#
#     CALL i007_b()                      #輸入單身
#
#     LET g_axo11_t = g_axo11
#     LET g_axo12_t = g_axo12
#     LET g_axo13_t = g_axo13
#     LET g_axo01_t = g_axo01
#     LET g_axo02_t = g_axo02
#     EXIT WHILE
#  END WHILE
#
#END FUNCTION
# 
#FUNCTION i007_i(p_cmd)
#DEFINE
#   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
#   l_cnt           LIKE type_file.num10,
#   li_result       LIKE type_file.num5
#
#   LET g_ss='Y'
#
#   CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
#
#   INPUT g_axo11,g_axo12,g_axo13,g_axo01,g_axo02 WITHOUT DEFAULTS
#       FROM axo11,axo12,axo13,axo01,axo02
#
#      AFTER FIELD axo11
#         CALL i007_chk_axo11(g_axo11) 
#              RETURNING li_result,g_axo12,g_axo13
#         DISPLAY i007_set_axz02(g_axo11) TO FORMONLY.axz02
#         DISPLAY g_axo12 TO axo12
#         DISPLAY g_axo13 TO axo13
#         IF NOT li_result THEN
#            NEXT FIELD CURRENT
#         END IF
#      
#      AFTER FIELD axo02
#         IF (NOT cl_null(g_axo11)) OR (NOT cl_null(g_axo12)) OR
#            (NOT cl_null(g_axo13)) OR (NOT cl_null(g_axo01)) OR
#            (NOT cl_null(g_axo02)) THEN
#            LET l_cnt=0             
#            SELECT COUNT(*) INTO l_cnt FROM axo_file
#                                      WHERE axo11=g_axo11
#                                        AND axo12=g_axo12
#                                        AND axo13=g_axo13
#                                        AND axo01=g_axo01
#                                        AND axo02=g_axo02
#           IF l_cnt>0 THEN
#              CALL cl_err('','-239',1)
#              NEXT FIELD axo11
#           END IF
#         END IF
#
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(axo11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_axz"
#               CALL cl_create_qry() RETURNING g_axo11
#               DISPLAY g_axo11 TO axo11
#               NEXT FIELD axo11
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
#FUNCTION i007_q()
#  LET g_row_count = 0
#  LET g_curs_index = 0
#  CALL cl_navigator_setting( g_curs_index, g_row_count )
#  INITIALIZE g_axo11,g_axo12,g_axo13,g_axo01,g_axo02 TO NULL
#  MESSAGE ""
#  CALL cl_opmsg('q')
#  CLEAR FORM
#  CALL g_axo.clear()
#  DISPLAY '' TO FORMONLY.cnt
#
#  CALL i007_cs()                      #取得查詢條件
#
#  IF INT_FLAG THEN                    #使用者不玩了
#     LET INT_FLAG = 0
#     INITIALIZE g_axo11,g_axo12,g_axo13,g_axo01,g_axo02 TO NULL
#     RETURN
#  END IF
#
#  OPEN i007_bcs                       #從DB產生合乎條件TEMP(0-30秒)
#  IF SQLCA.sqlcode THEN               #有問題
#     CALL cl_err('',SQLCA.sqlcode,0)
#     INITIALIZE g_axo11,g_axo12,g_axo13,g_axo01,g_axo02 TO NULL
#  ELSE
#     OPEN i007_count
#     FETCH i007_count INTO g_row_count
#     DISPLAY g_row_count TO FORMONLY.cnt
#     CALL i007_fetch('F')            #讀出TEMP第一筆並顯示
#  END IF
#END FUNCTION
#
##處理資料的讀取
#FUNCTION i007_fetch(p_flag)
#DEFINE
#  p_flag          LIKE type_file.chr1,   #處理方式
#  l_abso          LIKE type_file.num10   #絕對的筆數
#
#  MESSAGE ""
#  CASE p_flag
#      WHEN 'N' FETCH NEXT     i007_bcs INTO g_axo11,g_axo12,
#                                            g_axo13,g_axo01,g_axo02
#      WHEN 'P' FETCH PREVIOUS i007_bcs INTO g_axo11,g_axo12,
#                                            g_axo13,g_axo01,g_axo02
#      WHEN 'F' FETCH FIRST    i007_bcs INTO g_axo11,g_axo12,
#                                            g_axo13,g_axo01,g_axo02
#      WHEN 'L' FETCH LAST     i007_bcs INTO g_axo11,g_axo12,
#                                            g_axo13,g_axo01,g_axo02
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
#           FETCH ABSOLUTE l_abso i007_bcs INTO g_axo11,g_axo12,
#                                               g_axo13,g_axo01,g_axo02
#  END CASE
#
#  IF SQLCA.sqlcode THEN                  #有麻煩
#     CALL cl_err(g_axo11,SQLCA.sqlcode,0)
#     INITIALIZE g_axo11 TO NULL
#     INITIALIZE g_axo12 TO NULL
#     INITIALIZE g_axo13 TO NULL
#     INITIALIZE g_axo01 TO NULL
#     INITIALIZE g_axo02 TO NULL
#  ELSE
#     CALL i007_show()
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
#FUNCTION i007_show()
#
#  DISPLAY g_axo11 TO axo11
#  DISPLAY g_axo12 TO axo12
#  DISPLAY g_axo13 TO axo13
#  DISPLAY g_axo01 TO axo01
#  DISPLAY g_axo02 TO axo02
#  DISPLAY i007_set_axz02(g_axo11) TO FORMONLY.axz02
#
#  CALL i007_b_fill(g_wc)                      #單身
#
#  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#END FUNCTION
#
##單身
#FUNCTION i007_b()
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
#  IF cl_null(g_axo11) OR cl_null(g_axo12) OR
#     cl_null(g_axo13) OR cl_null(g_axo01) OR
#     cl_null(g_axo02) THEN
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
#  LET g_forupd_sql = "SELECT axo14,'',axo04,axo15,'' FROM axo_file",
#                     "  WHERE axo11 = ? AND axo12= ? AND axo13= ? ",
#                     "   AND axo01 = ? AND axo02= ? AND axo14= ? ",
#                     "   AND axo15 = ? FOR UPDATE "
#                     
#  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#  DECLARE i007_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#  LET l_allow_insert = cl_detail_input_auth("insert")
#  LET l_allow_delete = cl_detail_input_auth("delete")
#
#  IF g_rec_b=0 THEN CALL g_axo.clear() END IF
#
#  INPUT ARRAY g_axo WITHOUT DEFAULTS FROM s_axo.*
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
#           LET g_axo_t.* = g_axo[l_ac].*  #BACKUP
#           BEGIN WORK
#           OPEN i007_bcl USING g_axo11,g_axo12,g_axo13,g_axo01,g_axo02,
#                               g_axo[l_ac].axo14,g_axo[l_ac].axo15
#           IF STATUS THEN
#              CALL cl_err("OPEN i007_bcl:", STATUS, 1)
#              LET l_lock_sw = "Y"
#           ELSE
#              FETCH i007_bcl INTO g_axo[l_ac].*
#              IF STATUS THEN
#                 CALL cl_err("OPEN i007_bcl:", STATUS, 1)
#                 LET l_lock_sw = "Y"
#              ELSE
#                 LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
#                 LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
#                 LET g_axo_t.*=g_axo[l_ac].*
#              END IF
#           END IF
#           CALL cl_show_fld_cont()     #FUN-550037(smin)
#        END IF
#
#     BEFORE INSERT
#        LET l_n = ARR_COUNT()
#        LET p_cmd='a'
#        INITIALIZE g_axo[l_ac].* TO NULL            #900423
#        LET g_axo_t.* = g_axo[l_ac].*               #新輸入資料
#        LET g_axo[l_ac].axo04=0
#        CALL cl_show_fld_cont()
#        NEXT FIELD axo14
#
#     AFTER FIELD axo14                         # check data 是否重複
#        IF NOT cl_null(g_axo[l_ac].axo14) THEN
#           IF NOT i007_chk_axo14() THEN
#              LET g_axo[l_ac].axo14=g_axo_t.axo14
#              LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
#              DISPLAY BY NAME g_axo[l_ac].axo14,g_axo[l_ac].aya02
#              NEXT FIELD CURRENT
#           END IF
#           LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
#           DISPLAY BY NAME g_axo[l_ac].aya02
#           IF g_axo[l_ac].axo14 != g_axo_t.axo14 OR 
#              g_axo_t.axo14 IS NULL THEN
#              IF NOT i007_chk_dudata() THEN
#                 LET g_axo[l_ac].axo14=g_axo_t.axo14
#                 LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
#                 DISPLAY BY NAME g_axo[l_ac].axo14,g_axo[l_ac].aya02
#                 NEXT FIELD CURRENT
#              END IF
#           END IF
#        END IF
#        LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
#        DISPLAY BY NAME g_axo[l_ac].aya02
#
#     AFTER FIELD axo04
#        CALL i007_set_axo04()
#        
#     AFTER FIELD axo15                         # check data 是否重複
#        IF NOT cl_null(g_axo[l_ac].axo15) THEN
#           IF NOT i007_chk_axo15() THEN
#              LET g_axo[l_ac].axo15=g_axo_t.axo15
#              LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
#              DISPLAY BY NAME g_axo[l_ac].axo15,g_axo[l_ac].axl02
#              NEXT FIELD CURRENT
#           END IF
#           LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
#           DISPLAY BY NAME g_axo[l_ac].axl02
#           IF g_axo[l_ac].axo15 != g_axo_t.axo15 OR 
#              g_axo_t.axo15 IS NULL THEN
#              IF NOT i007_chk_dudata() THEN
#                 LET g_axo[l_ac].axo15=g_axo_t.axo15
#                 LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
#                 DISPLAY BY NAME g_axo[l_ac].axo15,g_axo[l_ac].axl02
#                 NEXT FIELD CURRENT
#              END IF
#           END IF
#        END IF
#        LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
#        DISPLAY BY NAME g_axo[l_ac].axl02
#
#     AFTER INSERT
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           INITIALIZE g_axo[l_ac].* TO NULL  #重要欄位空白,無效
#           DISPLAY g_axo[l_ac].* TO s_axo.*
#           CALL g_axo.deleteElement(g_rec_b+1)
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        INSERT INTO axo_file(axo11,axo12,axo13,axo01,axo02,axo14,axo04,
#                             axo15,axooriu,axoorig)
#             VALUES(g_axo11,g_axo12,g_axo13,g_axo01,g_axo02,
#                    g_axo[l_ac].axo14,g_axo[l_ac].axo04,
#                    g_axo[l_ac].axo15, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","axo_file",g_axo[l_ac].axo14,
#                        "",SQLCA.sqlcode,"","",1)
#           CANCEL INSERT
#        ELSE
#           MESSAGE 'INSERT O.K'
#           COMMIT WORK
#           LET g_rec_b=g_rec_b+1
#           DISPLAY g_rec_b TO FORMONLY.cn2
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
#           DELETE FROM axo_file WHERE axo11 = g_axo11
#                                  AND axo12 = g_axo12
#                                  AND axo13 = g_axo13
#                                  AND axo01 = g_axo01
#                                  AND axo02 = g_axo02
#                                  AND axo14 = g_axo_t.axo14
#                                  AND axo15 = g_axo_t.axo15
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("del","axo_file",g_axo[l_ac].axo14,
#                           g_axo[l_ac].axo15,SQLCA.sqlcode,"","",1)
#              ROLLBACK WORK
#              CANCEL DELETE
#           END IF
#           LET g_rec_b = g_rec_b-1
#           DISPLAY g_rec_b TO FORMONLY.cn2
#        END IF
#        COMMIT WORK
#
#     ON ROW CHANGE
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           LET g_axo[l_ac].* = g_axo_t.*
#           CLOSE i007_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        IF l_lock_sw = 'Y' THEN
#           CALL cl_err(g_axo[l_ac].axo14,-263,1)
#           LET g_axo[l_ac].* = g_axo_t.*
#        ELSE
#           UPDATE axo_file SET axo14 = g_axo[l_ac].axo14,
#                               axo04 = g_axo[l_ac].axo04,
#                               axo15 = g_axo[l_ac].axo15
#                                WHERE axo11 = g_axo11
#                                  AND axo12 = g_axo12
#                                  AND axo13 = g_axo13
#                                  AND axo01 = g_axo01
#                                  AND axo02 = g_axo02
#                                  AND axo14 = g_axo_t.axo14
#                                  AND axo15 = g_axo_t.axo15
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("upd","axo_file",g_axo[l_ac].axo14,
#                           g_axo[l_ac].axo15,SQLCA.sqlcode,"","",1)
#              LET g_axo[l_ac].* = g_axo_t.*
#           ELSE
#              MESSAGE 'UPDATE O.K'
#              COMMIT WORK
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
#              LET g_axo[l_ac].* = g_axo_t.*
#           END IF
#           CLOSE i007_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        CLOSE i007_bcl
#        COMMIT WORK
#        #CKP2
#         CALL g_axo.deleteElement(g_rec_b+1)
#
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(axo14)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_aya"
#             LET g_qryparam.default1 = g_axo[l_ac].axo14
#             CALL cl_create_qry() RETURNING g_axo[l_ac].axo14
#             DISPLAY BY NAME g_axo[l_ac].axo14
#             NEXT FIELD axo14
#          WHEN INFIELD(axo15)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_axl"
#             LET g_qryparam.default1 = g_axo[l_ac].axo15
#             LET g_qryparam.default2 = g_axo[l_ac].axl02
#             CALL cl_create_qry() RETURNING g_axo[l_ac].axo15,
#                                            g_axo[l_ac].axl02
#             DISPLAY BY NAME g_axo[l_ac].axo15
#             DISPLAY BY NAME g_axo[l_ac].axl02
#             NEXT FIELD axo15
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
##No.FUN-6B0029--begin                                             
#     ON ACTION controls                                        
#        CALL cl_set_head_visible("","AUTO")                    
##No.FUN-6B0029--end 
#
#  END INPUT
#
#  CLOSE i007_bcl
#  COMMIT WORK
#END FUNCTION
#
#FUNCTION i007_b_fill(p_wc)                     #BODY FILL UP
#DEFINE p_wc STRING
#
#  LET g_sql = "SELECT axo14,'',axo04,axo15,''",
#              " FROM axo_file ",
#              " WHERE axo11 = '",g_axo11,"'",
#              "   AND axo12 = '",g_axo12,"'",
#              "   AND axo13 = '",g_axo13,"'",
#              "   AND axo01 = '",g_axo01,"'",
#              "   AND axo02 = '",g_axo02,"'",
#              "   AND ",p_wc CLIPPED ,
#              " ORDER BY axo14"
#  PREPARE i007_prepare2 FROM g_sql       #預備一下
#  DECLARE axo_cs CURSOR FOR i007_prepare2
#
#  CALL g_axo.clear()
#  LET g_cnt = 1
#  LET g_rec_b = 0
#
#  FOREACH axo_cs INTO g_axo[g_cnt].*     #單身 ARRAY 填充
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     LET g_axo[g_cnt].aya02=i007_set_aya02(g_axo[g_cnt].axo14)
#     LET g_axo[g_cnt].axl02=i007_set_axl02(g_axo[g_cnt].axo15)
#     LET g_cnt = g_cnt + 1
#     IF g_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#  END FOREACH
#
#  CALL g_axo.deleteElement(g_cnt)
#
#  LET g_rec_b=g_cnt-1
#
#  DISPLAY g_rec_b TO FORMONLY.cn2
#  LET g_cnt = 0
#
#END FUNCTION
#
#FUNCTION i007_bp(p_ud)
#  DEFINE   p_ud   LIKE type_file.chr1
#
#  IF p_ud <> "G" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_axo TO s_axo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
#        CALL i007_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION previous
#        CALL i007_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION jump
#        CALL i007_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION next
#        CALL i007_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION last
#        CALL i007_fetch('L')
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
#    #str FUN-780068 add 10/19
#     ON ACTION generate   #異動明細產生
#        LET g_action_choice="generate"
#        EXIT DISPLAY
#    #end FUN-780068 add 10/19
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
#FUNCTION i007_copy()
#DEFINE
#  l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
#  l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
#  l_newno1,l_oldno1  LIKE axo_file.axo11,
#  l_newno2,l_oldno2  LIKE axo_file.axo12,
#  l_newno3,l_oldno3  LIKE axo_file.axo13,
#  l_newno4,l_oldno4  LIKE axo_file.axo01,
#  l_newno5,l_oldno5  LIKE axo_file.axo02,
#  li_result       LIKE type_file.num5
#
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#
#  IF cl_null(g_axo11) OR cl_null(g_axo12) OR
#     cl_null(g_axo13) OR cl_null(g_axo01) OR
#     cl_null(g_axo02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#
#  DISPLAY NULL TO axo11
#  DISPLAY NULL TO axo12
#  DISPLAY NULL TO axo13
#  DISPLAY NULL TO axo01
#  DISPLAY NULL TO axo02
#  CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
#
#  INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5 
#   FROM axo11,axo12,axo13,axo01,axo02
#
#      AFTER FIELD axo11
#         CALL i007_chk_axo11(l_newno1) 
#             RETURNING li_result,l_newno2,l_newno3
#         DISPLAY i007_set_axz02(l_newno1) TO FORMONLY.axz02
#         DISPLAY l_newno2 TO axo12
#         DISPLAY l_newno3 TO axo13
#         IF NOT li_result THEN
#            NEXT FIELD CURRENT
#         END IF
#
#      AFTER FIELD axo02
#         IF (NOT cl_null(l_newno1)) OR (NOT cl_null(l_newno2)) OR
#            (NOT cl_null(l_newno3)) OR (NOT cl_null(l_newno4)) OR
#            (NOT cl_null(l_newno5)) THEN
#            LET l_cnt=0             
#            SELECT COUNT(*) INTO l_cnt FROM axo_file
#                                      WHERE axo11=l_newno1
#                                        AND axo12=l_newno2
#                                        AND axo13=l_newno3
#                                        AND axo01=l_newno4
#                                        AND axo02=l_newno5
#           IF l_cnt>0 THEN
#              CALL cl_err('','-239',1)
#              NEXT FIELD axo11
#           END IF
#         END IF
#
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(axo11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_axz"
#               CALL cl_create_qry() RETURNING l_newno1
#               DISPLAY l_newno1 TO axo11
#               NEXT FIELD axo11
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
#     DISPLAY g_axo11 TO axo11
#     DISPLAY g_axo12 TO axo12
#     DISPLAY g_axo13 TO axo13
#     DISPLAY g_axo01 TO axo01
#     DISPLAY g_axo02 TO axo02
#     RETURN
#  END IF
#
#  DROP TABLE i007_x
#
#  SELECT * FROM axo_file             #單身複製
#   WHERE axo11 = g_axo11
#     AND axo12 = g_axo12
#     AND axo13 = g_axo13
#     AND axo01 = g_axo01
#     AND axo02 = g_axo02
#    INTO TEMP i007_x
#  IF SQLCA.sqlcode THEN
#     LET g_msg=l_newno1 CLIPPED
#     CALL cl_err3("ins","i007_x",g_axo11,g_axo12,SQLCA.sqlcode,"","",1)
#     RETURN
#  END IF
#
#  UPDATE i007_x SET axo11=l_newno1,
#                    axo12=l_newno2,
#                    axo13=l_newno3,
#                    axo01=l_newno4,
#                    axo02=l_newno5
#
#  INSERT INTO axo_file SELECT * FROM i007_x
#  IF SQLCA.sqlcode THEN
#     LET g_msg=l_newno1 CLIPPED
#     CALL cl_err3("ins","axo_file",l_newno1,l_newno2,
#                   SQLCA.sqlcode,"",g_msg,1)
#     RETURN
#  ELSE
#     MESSAGE 'COPY O.K'
#     LET g_axo11=l_newno1
#     LET g_axo12=l_newno2
#     LET g_axo13=l_newno3
#     LET g_axo01=l_newno4
#     LET g_axo02=l_newno5
#     CALL i007_show()
#  END IF
#
#END FUNCTION
# 
#FUNCTION i007_r()
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#  IF cl_null(g_axo11) OR cl_null(g_axo12) OR
#     cl_null(g_axo13) OR cl_null(g_axo01) OR
#     cl_null(g_axo02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#  IF NOT cl_delh(20,16) THEN RETURN END IF
#  INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
#  LET g_doc.column1 = "axo11"      #No.FUN-9B0098 10/02/24
#  LET g_doc.column2 = "axo12"      #No.FUN-9B0098 10/02/24
#  LET g_doc.column3 = "axo13"      #No.FUN-9B0098 10/02/24
#  LET g_doc.value1 = g_axo11       #No.FUN-9B0098 10/02/24
#  LET g_doc.value2 = g_axo12       #No.FUN-9B0098 10/02/24
#  LET g_doc.value3 = g_axo13       #No.FUN-9B0098 10/02/24
#  CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
#  DELETE FROM axo_file WHERE axo11=g_axo11
#                         AND axo12=g_axo12
#                         AND axo13=g_axo13
#                         AND axo01=g_axo01
#                         AND axo02=g_axo02
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err3("del","axo_file",g_axo11,g_axo12,
#                  SQLCA.sqlcode,"","del axo",1)
#     RETURN      
#  END IF   
#
#  INITIALIZE g_axo11,g_axo12,g_axo13,g_axo01,g_axo02 TO NULL
#  MESSAGE ""
#  DROP TABLE i007_cnttmp                   #No.TQC-720019
#  PREPARE i007_precount_x2 FROM g_sql_tmp  #No.TQC-720019
#  EXECUTE i007_precount_x2                 #No.TQC-720019
#  OPEN i007_count
#  #FUN-B50062-add-start--
#  IF STATUS THEN
#     CLOSE i007_bcs
#     CLOSE i007_count
#     COMMIT WORK
#     RETURN
#  END IF
#  #FUN-B50062-add-end--
#  FETCH i007_count INTO g_row_count
#  #FUN-B50062-add-start--
#  IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
#     CLOSE i007_bcs
#     CLOSE i007_count
#     COMMIT WORK
#     RETURN
#  END IF
#  #FUN-B50062-add-end--
#  DISPLAY g_row_count TO FORMONLY.cnt
#  IF g_row_count>0 THEN
#     OPEN i007_bcs
#     CALL i007_fetch('F') 
#  ELSE
#     DISPLAY g_axo11 TO axo11
#     DISPLAY g_axo12 TO axo12
#     DISPLAY g_axo13 TO axo13
#     DISPLAY g_axo01 TO axo01
#     DISPLAY g_axo02 TO axo02
#     DISPLAY 0 TO FORMONLY.cn2
#     CALL g_axo.clear()
#     CALL i007_menu()
#  END IF
#END FUNCTION
#
##str FUN-780068 add 10/19
#FUNCTION i007_g()   #0期資料產生
#DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
#DEFINE l_flag      LIKE type_file.chr1
#DEFINE li_result   LIKE type_file.num5
#DEFINE tm          RECORD
#                   axo11  LIKE axo_file.axo11,   #公司編號 
#                   axo12  LIKE axo_file.axo12,   #帳別
#                   axo13  LIKE axo_file.axo13,   #幣別
#                   yy     LIKE axr_file.axr10,   #年度
#                   mm     LIKE axr_file.axr11    #期別
#                  END RECORD
#
#  OPEN WINDOW i007_g_w AT p_row,p_col WITH FORM "agl/42f/agli007_g"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  CALL cl_ui_locale("agli007_g")
#
#  WHILE TRUE
#     INPUT BY NAME tm.axo11,tm.axo12,tm.axo13,tm.yy,tm.mm WITHOUT DEFAULTS
#        BEFORE INPUT
#           CALL cl_qbe_display_condition(lc_qbe_sn)   #FUN-580031 add
#           INITIALIZE tm.* TO NULL
#           LET tm.yy = YEAR(g_today)    #現行年度
#           LET tm.mm = MONTH(g_today)   #現行期別
#           DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
#
#        AFTER FIELD axo11
#           CALL i007_chk_axo11(tm.axo11) 
#                RETURNING li_result,tm.axo12,tm.axo13
#           DISPLAY tm.axo12 TO axo12
#           DISPLAY tm.axo13 TO axo13
#           IF NOT li_result THEN
#              NEXT FIELD CURRENT
#           END IF
#      
#        AFTER FIELD yy
#           IF cl_null(tm.yy) THEN
#              CALL cl_err('','mfg5103',0)
#              NEXT FIELD yy
#           END IF
#           IF tm.yy < 0 THEN NEXT FIELD yy END IF
#
#        AFTER FIELD mm
#           IF cl_null(tm.mm) THEN
#              CALL cl_err('','mfg5103',0)
#              NEXT FIELD mm
#           END IF
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(axo11)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_axz"
#                 CALL cl_create_qry() RETURNING tm.axo11
#                 DISPLAY tm.axo11 TO axo11
#                 NEXT FIELD axo11
#           END CASE
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#        AFTER INPUT
#           IF INT_FLAG THEN EXIT INPUT END IF
#
#        #No.FUN-580031 --start--     HCN
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.FUN-580031 --end--       HCN
#     END INPUT
#     IF INT_FLAG THEN
#        LET INT_FLAG=0
#        CLOSE WINDOW i007_g_w
#        RETURN
#     END IF
#     IF NOT cl_sure(0,0) THEN
#        CLOSE WINDOW i007_g_w
#        RETURN
#     ELSE
#        BEGIN WORK
#        LET g_success='Y'
#        CALL i007_g1(tm.*)
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag
#        END IF
#        IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#     END IF
#  END WHILE
#
#  CLOSE WINDOW i007_g_w
#END FUNCTION
#
#FUNCTION i007_g1(tm)
#DEFINE tm          RECORD
#                   axo11  LIKE axo_file.axo11,   #公司編號 
#                   axo12  LIKE axo_file.axo12,   #帳別
#                   axo13  LIKE axo_file.axo13,   #幣別
#                   yy     LIKE axr_file.axr10,   #年度
#                   mm     LIKE axr_file.axr11    #期別
#                  END RECORD,
#      l_cnt       LIKE type_file.num5,
#      sr          RECORD
#                   axo11  LIKE axo_file.axo11,   #公司編號
#                   axo12  LIKE axo_file.axo12,   #帳別
#                   axo13  LIKE axo_file.axo13,   #幣別
#                   axo01  LIKE axo_file.axo01,   #年度
#                   axo02  LIKE axo_file.axo02,   #期別
#                   axo14  LIKE axo_file.axo14,   #分類代碼
#                   axo15  LIKE axo_file.axo15,   #群組代碼
#                   axo04  LIKE axo_file.axo04    #異動金額
#                  END RECORD
#
#  LET l_cnt = 0
#  SELECT COUNT(*) INTO l_cnt FROM axo_file
#   WHERE axo01=tm.yy    AND axo02=tm.mm
#     AND axo11=tm.axo11 AND axo12=tm.axo12 AND axo13=tm.axo13
#  IF l_cnt > 0 THEN
#     #先將舊資料刪除，再重新產生
#     DELETE FROM axo_file 
#      WHERE axo01=tm.yy    AND axo02=tm.mm
#        AND axo11=tm.axo11 AND axo12=tm.axo12 AND axo13=tm.axo13
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err3("del","axo_file",tm.axo11,tm.axo12,SQLCA.sqlcode,"","del axo",1)
#        LET g_success='N'
#        RETURN      
#     END IF
#  END IF
#
#  #異動金額：借方為 - 減少(ayc11='1')
#  #          貸方為 + 增加(ayc11='2')
#  DECLARE i007_ayabc_cs CURSOR FOR
#     SELECT ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13,SUM(ayc12)*-1
#       FROM aya_file,ayb_file,ayc_file
#      WHERE aya01=ayb01
#        AND ayb02=ayc10
#        AND ayc01=tm.axo11
#        AND ayc02=tm.axo12
#        AND ayc03=tm.axo13
#        AND ayc04=tm.yy
#        AND ayc05=tm.mm
#        AND ayc11='1'   #借方
#      GROUP BY ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13
#     UNION 
#     SELECT ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13,SUM(ayc12)
#       FROM aya_file,ayb_file,ayc_file
#      WHERE aya01=ayb01
#        AND ayb02=ayc10
#        AND ayc01=tm.axo11
#        AND ayc02=tm.axo12
#        AND ayc03=tm.axo13
#        AND ayc04=tm.yy
#        AND ayc05=tm.mm
#        AND ayc11='2'   #貸方
#      GROUP BY ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13
#
#  FOREACH i007_ayabc_cs INTO sr.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        LET g_success='N'
#        EXIT FOREACH
#     END IF
#
#     INSERT INTO axo_file(axo11,axo12,axo13,axo01,axo02,axo14,axo04,axo15,axooriu,axoorig)
#                   VALUES(sr.axo11,sr.axo12,sr.axo13,sr.axo01,sr.axo02,
#                          sr.axo14,sr.axo04,sr.axo15, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #SQLCA.SQLCODE=-239
#        UPDATE axo_file SET axo04 = axo04 + sr.axo04
#                      WHERE axo11 = sr.axo11
#                        AND axo12 = sr.axo12
#                        AND axo13 = sr.axo13
#                        AND axo01 = sr.axo01
#                        AND axo02 = sr.axo02
#                        AND axo14 = sr.axo14
#                        AND axo15 = sr.axo15
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("upd","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#     ELSE
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#     END IF
#  END FOREACH
#
#END FUNCTION
##end FUN-780068 add 10/19
#
#FUNCTION i007_chk_axo11(p_axo11)
#  DEFINE p_axo11 LIKE axo_file.axo11
#  DEFINE l_axzacti  LIKE axz_file.axzacti
#  DEFINE l_axz05 LIKE axz_file.axz05
#  DEFINE l_axz06 LIKE axz_file.axz06
#
#  LET l_axz05=NULL
#  LET l_axz06=NULL
#  IF NOT cl_null(p_axo11) THEN
#   # SELECT axzacti,axz05,axz06                              #FUN-920123 mark
#   #   INTO l_axzacti,l_axz05,l_axz06 FROM axz_file          #FUN-920123 mark
#     SELECT axz05,axz06                                      #FUN-920123
#       INTO l_axz05,l_axz06 FROM axz_file                    #FUN-920123   
#                                     WHERE axz01=p_axo11
#     CASE
#        WHEN SQLCA.sqlcode
#           CALL cl_err3("sel","axo_file",p_axo11,"",SQLCA.sqlcode,"","",1)
#           RETURN FALSE,NULL,NULL
#       #FUN-920123 -----------------mark start---------------
#       #WHEN l_axzacti='N'
#       #   CALL cl_err3("sel","axo_file",p_axo11,"",9028,"","",1)
#       #   RETURN FALSE,NULL,NULL
#       #FUN-920123 ---------------  mark end--------------- 
#     END CASE      
#  END IF
#  RETURN TRUE,l_axz05,l_axz06
#END FUNCTION
#
#FUNCTION i007_set_axz02(p_axz01)
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
#FUNCTION i007_set_aya02(p_aya01)
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
#FUNCTION i007_chk_axo14()
#  IF NOT cl_null(g_axo[l_ac].axo14) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM aya_file 
#                               WHERE aya01 = g_axo[l_ac].axo14
#     IF g_cnt=0 THEN
#        CALL cl_err3("sel","aya_file",g_axo[l_ac].axo14,"",100,"","",1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i007_chk_axo15()
#  IF NOT cl_null(g_axo[l_ac].axo15) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM axl_file 
#                               WHERE axl01 = g_axo[l_ac].axo15
#     IF g_cnt=0 THEN
#        CALL cl_err3("sel","axl_file",g_axo[l_ac].axo15,"",100,"","",1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i007_set_axo04()
#  IF NOT cl_null(g_axo[l_ac].axo04) THEN
#     SELECT azi04 INTO t_azi04 FROM azi_file
#                              WHERE azi01=g_axo13
#     LET g_axo[l_ac].axo04=cl_digcut(g_axo[l_ac].axo04,t_azi04)
#     DISPLAY BY NAME g_axo[l_ac].axo04
#  END IF
#END FUNCTION
#
#FUNCTION i007_chk_dudata()
#  IF (NOT cl_null(g_axo[l_ac].axo14)) AND 
#     (NOT cl_null(g_axo[l_ac].axo15)) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM axo_file
#                               WHERE axo11=g_axo11
#                                 AND axo12=g_axo12
#                                 AND axo13=g_axo13
#                                 AND axo01=g_axo01
#                                 AND axo02=g_axo02
#                                 AND axo14=g_axo[l_ac].axo14
#                                 AND axo15=g_axo[l_ac].axo15
#     IF g_cnt>0 THEN
#        CALL cl_err('',-239,1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i007_out()
#  DEFINE l_wc STRING
#  IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#
#  CALL cl_wait()
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
#  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli007'
#
#  #組合出 SQL 指令
#  LET g_sql="SELECT A.axo11,B.axz02 axo11_d,A.axo12,A.axo13,",
#            "       A.axo01,A.axo02,A.axo14,C.aya02 axo14_d,",
#            "       A.axo04,A.axo15,D.axl02 axo15_d,E.azi04,E.azi05",
#            "  FROM axo_file A,axz_file B,aya_file C,",
#            "       axl_file D,azi_file E",
#            " WHERE A.axo11=B.axz01",
#            "   AND A.axo14=C.aya01",
#            "   AND A.axo15=D.axl01",
#            "   AND A.axo13=E.azi01",
#            "   AND ",g_wc CLIPPED,
#            " ORDER BY A.axo11,A.axo12,A.axo13,A.axo01,A.axo02,",
#            "          A.axo14,A.axo15"
#  PREPARE i007_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i007_co  CURSOR FOR i007_p1
#
#  #是否列印選擇條件
#  IF g_zz05 = 'Y' THEN
#     CALL cl_wcchp(g_wc,'axo11,axo12,axo13,axo01,axo02,axo14,axo04,axo15')
#          RETURNING l_wc
#  ELSE
#     LET l_wc = ' '
#  END IF
#
#  CALL cl_prt_cs1('agli007','agli007',g_sql,l_wc)
#
#END FUNCTION
#
#FUNCTION i007_set_axl02(p_axl01)
#  DEFINE p_axl01 LIKE axl_file.axl01
#  DEFINE l_axl02 LIKE axl_file.axl02
#  
#  IF cl_null(p_axl01) THEN RETURN NULL END IF
#  LET l_axl02=''
#  SELECT axl02 INTO l_axl02 FROM axl_file
#                           WHERE axl01=p_axl01
#  RETURN l_axl02
#END FUNCTION
##FUN-780013
#No.FUN-B60144--mark
