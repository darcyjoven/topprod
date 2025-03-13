# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: anmi010.4gl
# Descriptions...: 網絡銀行配置作業
# Date & Author..: 07/04/09 By Xufeng  
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-870067 08/07/14 By douzh 新增匯豐銀行接口欄位(nmv09-nmv20)及單身(nmx_file)
# Modify.........: No.FUN-870067 08/08/14 By douzh 新增匯豐銀行通知格式輸出欄位單身檔(nca_file)
# Modify.........: No.MOD-960079 09/06/09 By baofei i010_cs FETCH 值的時候少了nmv01的接受參數
# Modify.........: No.MOD-960082 09/06/09 By baofei 4fd中沒有idx欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nmv       RECORD LIKE nmv_file.*,
       g_nmv_t     RECORD LIKE nmv_file.*,  #備份舊值
       g_nmv_o     RECORD LIKE nmv_file.*,  #備份舊值
       g_nmv01_t   LIKE nmv_file.nmv01,     #Key值備份
       g_nmv06_t   LIKE nmv_file.nmv06,     #Key值備份
#No.FUN-870067--begin
       g_nmx         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           nmx06     LIKE nmx_file.nmx06,          #項次
           nmx03     LIKE nmx_file.nmx03,          #Payment Code
           nmx04     LIKE nmx_file.nmx04,          #Payment Code 說明 
           nmx05     LIKE nmx_file.nmx05           #Payment Code 是否已被使用
                     END RECORD,
       g_nmx_t       RECORD                        #程式變數(舊值)
           nmx06     LIKE nmx_file.nmx06,          #項次
           nmx03     LIKE nmx_file.nmx03,          #Payment Code
           nmx04     LIKE nmx_file.nmx04,          #Payment Code 說明 
           nmx05     LIKE nmx_file.nmx05           #Payment Code 是否已被使用
                     END RECORD,
       g_nmx_o       RECORD                        #程式變數(舊值)
           nmx06     LIKE nmx_file.nmx06,          #項次
           nmx03     LIKE nmx_file.nmx03,          #Payment Code
           nmx04     LIKE nmx_file.nmx04,          #Payment Code 說明 
           nmx05     LIKE nmx_file.nmx05           #Payment Code 是否已被使用
                     END RECORD,
       g_nca         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           nca03     LIKE nca_file.nca03,          #字段序號
           nca04     LIKE nca_file.nca04           #資料來源
                     END RECORD,
       g_nca_t       RECORD                        #程式變數(舊值)
           nca03     LIKE nca_file.nca03,          #字段序號
           nca04     LIKE nca_file.nca04           #資料來源
                     END RECORD,
       g_nca_o       RECORD                        #程式變數(舊值)
           nca03     LIKE nca_file.nca03,          #字段序號
           nca04     LIKE nca_file.nca04           #資料來源
                     END RECORD,
       g_zx02      LIKE zx_file.zx02,    
#No.FUN-870067--end
       g_wc        STRING,                  #儲存 user 的查詢條件 
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 SMALLINT
       g_rec_b2      LIKE type_file.num5,          #單身筆數  #No.FUN-870067
       g_sql       STRING                  #組 sql 用   
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令    
DEFINE g_cnt                 LIKE type_file.num10    
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose       
DEFINE g_msg                 LIKE type_file.chr1000 
DEFINE g_curs_index          LIKE type_file.num10  
DEFINE g_row_count           LIKE type_file.num10         #總筆數     
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數       
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗       
DEFINE l_col                 STRING         #存放字段組合 #No.FUN-870067
DEFINE g_nca04               LIKE nca_file.nca04
DEFINE l_nca04               LIKE nca_file.nca04
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5   
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_nmv.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM nmv_file WHERE nmv01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
   
   IF g_aza.aza73 ='N' THEN
      CALL cl_err('','anm-980',1)
      EXIT PROGRAM
   END IF
   LET g_nmv.nmv08 ="ALL"
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i010_w AT p_row,p_col WITH FORM "anm/42f/anmi010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
#No.FUN-870067--begin
   #-----指定combo nca04的值-------------#
   LET g_nca04=""
   LET g_sql = "SELECT gaq03 FROM gaq_file ",
               " WHERE gaq01 LIKE 'nps%' ",
               "   AND gaq02 = '",g_lang,"' " 
   PREPARE p_nca04_p  FROM g_sql
   DECLARE p_nca04_cur CURSOR FOR p_nca04_p
   FOREACH p_nca04_cur INTO l_nca04
      IF cl_null(g_nca04) THEN
         LET g_nca04=l_nca04
      ELSE
         LET g_nca04=g_nca04 CLIPPED,",",l_nca04 CLIPPED
      END IF
   END FOREACH
 
   CALL cl_set_combo_items("nca04",g_nca04,g_nca04)
   #-------------------------------------#
#No.FUN-870067--end
 
   LET g_action_choice = ""
   CALL i010_menu()
 
   CLOSE WINDOW i010_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION i010_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_nmv.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON  nmv01,nmv06,nmv03,
                               nmv04,nmv07,nmv05,  # 螢幕上取條件
                               nmv09,nmv10,nmv11,  #No.FUN-870067
                               nmv12,nmv13,nmv14,  #No.FUN-870067
                               nmv15,nmv16,nmv17,  #No.FUN-870067
                               nmv18,nmv19,nmv20,  #No.FUN-870067
                               nmv21,nmv22         #No.FUN-870067
        
        BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP
        CASE
          WHEN INFIELD(nmv06)
            CALL cl_init_qry_var()   
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_zx"   
            CALL cl_create_qry() RETURNING g_nmv.nmv06   
            DISPLAY BY NAME g_nmv.nmv06
            NEXT FIELD nmv06
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
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.FUN-870067--begin
    CONSTRUCT g_wc2 ON nmx06,nmx03,nmx04,nmx05    #螢幕上取單身條件
            FROM s_nmx[1].nmx06,s_nmx[1].nmx03,s_nmx[1].nmx04,s_nmx[1].nmx05
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
       ON ACTION about   
          CALL cl_about() 
    
       ON ACTION help     
          CALL cl_show_help()
    
       ON ACTION controlg   
          CALL cl_cmdask() 
    
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END CONSTRUCT
   
    IF INT_FLAG THEN
       RETURN
    END IF
 
 
    IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
       LET g_sql = "SELECT  nmv01 FROM nmv_file ",
                   " WHERE ", g_wc CLIPPED 
    ELSE                              # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE nmv_file. nmv01 ",
                   "  FROM nmv_file, nmx_file ",
                   " WHERE nmv01 = nmx01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED 
    END IF
    PREPARE i010_prepare FROM g_sql
    DECLARE i010_cs                                # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i010_prepare
 
 
       IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
          LET g_sql="SELECT COUNT(*) FROM nmv_file WHERE ",g_wc CLIPPED
       ELSE
          LET g_sql="SELECT COUNT(DISTINCT nmv01) FROM nmv_file,nmx_file WHERE ",
                    "nmx01=nmv01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF
    PREPARE i010_precount FROM g_sql
    DECLARE i010_count CURSOR FOR i010_precount
#No.FUN-870067--end
 
END FUNCTION
 
FUNCTION i010_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i010_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i010_q()
            END IF
        ON ACTION next
            CALL i010_fetch('N')
        ON ACTION previous
            CALL i010_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i010_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i010_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i010_copy()
            END IF
  #    ON ACTION output
  #         LET g_action_choice="output"
  #         IF cl_chk_act_auth()
  #            THEN CALL i010_out()
  #         END IF
#No.FUN-870067--begin
       ON ACTION detail
            LET g_action_choice="detail"
            CALL i010_b()
            CALL i010_b2()
       ON ACTION Adv_for_col
            LET g_action_choice="Adv_for_col"
            CALL i010_b2()
#No.FUN-870067--end
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i010_fetch('/')
        ON ACTION first
            CALL i010_fetch('F')
        ON ACTION last
            CALL i010_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()           
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about      
           CALL cl_about()    
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document   
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_nmv.nmv01 IS NOT NULL THEN
                 LET g_doc.column1 = "nmv01"
                 LET g_doc.value1 = g_nmv.nmv01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i010_cs
END FUNCTION
 
FUNCTION i010_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_nmv.* LIKE nmv_file.*
    LET g_nmv.nmv08="ALL"
    LET g_nmv01_t = NULL
    LET g_nmv.nmv17 = '1.0'
    LET g_nmv.nmv19 = 'N'
    LET g_nmv.nmv21 = 'N'
    LET g_wc = NULL
    #No.FUN-870067--begin
    LET l_col="nmv09,nmv10,nmv11,nmv12,nmv13,nmv14,nmv15,",
              "nmv16,nmv17,nmv18,nmv19,nmv20,nmv21,nmv22 "
    CALL cl_set_comp_visible(l_col,TRUE)
    CALL cl_set_comp_visible("Page02",TRUE)
    CALL cl_set_comp_visible("nmv03,nmv04,nmv05,nmv07",TRUE)
    #No.FUN-870067--end
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i010_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_nmv.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_nmv.nmv01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO nmv_file VALUES(g_nmv.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nmv_file",g_nmv.nmv01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        ELSE
            SELECT nmv01 INTO g_nmv.nmv01 FROM nmv_file
                     WHERE nmv01 = g_nmv.nmv01
        END IF
 
        #No.FUN-870067--begin
        IF g_aza.aza78 = g_nmv.nmv01 THEN
           LET g_nmv01_t = g_nmv.nmv01     #保留舊值
           LET g_nmv_t.* = g_nmv.*
           LET g_nmv_o.* = g_nmv.*
           CALL g_nmx.clear()
           LET g_rec_b = 0 
           CALL i010_b()                   #輸入單身
           IF g_nmv.nmv21 ='Y' AND g_nmv.nmv22 !='1' THEN
              LET g_rec_b2= 0 
              CALL i010_b2()               #輸入單身2
           END IF
        END IF
        #No.FUN-870067--end
 
        EXIT WHILE
    END WHILE
    LET g_wc=' '
 
END FUNCTION
 
FUNCTION i010_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,       
            l_input   LIKE type_file.chr1,     
            l_n       LIKE type_file.num5,    
            g_zx02    LIKE zx_file.zx02 
 
   DISPLAY BY NAME
      g_nmv.nmv01,g_nmv.nmv06,g_nmv.nmv03,g_nmv.nmv04,g_nmv.nmv07,g_nmv.nmv05,
      g_nmv.nmv09,g_nmv.nmv10,g_nmv.nmv11,g_nmv.nmv12,g_nmv.nmv13,g_nmv.nmv14,      #No.FUN-870067
      g_nmv.nmv15,g_nmv.nmv16,g_nmv.nmv17,g_nmv.nmv18,g_nmv.nmv19,g_nmv.nmv20,      #No.FUN-870067 
      g_nmv.nmv21,g_nmv.nmv22                                                       #No.FUN-870067 
 
   INPUT BY NAME
      g_nmv.nmv01,g_nmv.nmv06,g_nmv.nmv03,g_nmv.nmv04,g_nmv.nmv07,g_nmv.nmv05,
      g_nmv.nmv09,g_nmv.nmv10,g_nmv.nmv11,g_nmv.nmv12,g_nmv.nmv13,g_nmv.nmv14,      #No.FUN-870067
      g_nmv.nmv15,g_nmv.nmv16,g_nmv.nmv17,g_nmv.nmv18,g_nmv.nmv19,g_nmv.nmv20,      #No.FUN-870067 
      g_nmv.nmv21,g_nmv.nmv22                                                       #No.FUN-870067 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i010_set_entry(p_cmd)
          CALL i010_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD nmv01
         DISPLAY "AFTER FIELD nmv01"
         IF g_nmv.nmv01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_nmv.nmv01 != g_nmv01_t) THEN
               SELECT count(*) INTO l_n FROM nmv_file 
                 WHERE nmv01 = g_nmv.nmv01 AND nmv06 = g_nmv.nmv06 
                       AND nmv08 = "ALL"
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_nmv.nmv01,-239,1)
                  LET g_nmv.nmv01 = g_nmv01_t
                  DISPLAY BY NAME g_nmv.nmv01
                  NEXT FIELD nmv01
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('nmv01:',g_errno,1)
                  LET g_nmv.nmv01 = g_nmv01_t
                  DISPLAY BY NAME g_nmv.nmv01
                  NEXT FIELD nmv01
               END IF
               #No.FUN-870067--begin
               LET l_col="nmv09,nmv10,nmv11,nmv12,nmv13,nmv14,nmv15,",
                         "nmv16,nmv17,nmv18,nmv19,nmv20,nmv21,nmv22 "
               IF g_aza.aza78 = g_nmv.nmv01 THEN
                  CALL cl_set_comp_visible(l_col,TRUE)
                  CALL cl_set_comp_visible("Page02",TRUE)
                  CALL cl_set_comp_visible("Page03",TRUE)
                  CALL cl_set_comp_visible("nmv03,nmv04,nmv05,nmv07",FALSE)
               ELSE
                  CALL cl_set_comp_visible("nmv03,nmv04,nmv05,nmv07",TRUE)
                  CALL cl_set_comp_visible(l_col,FALSE)
                  CALL cl_set_comp_visible("Page02",FALSE)
                  CALL cl_set_comp_visible("Page03",FALSE)
               END IF
               #No.FUN-870067--end
            END IF
         END IF
 
      AFTER FIELD nmv06
         DISPLAY "AFTER FIELD nmv06"
         IF g_nmv.nmv06 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM zx_file
              WHERE zx01=g_nmv.nmv06 
            IF l_n <=0 THEN
               CALL cl_err(g_nmv.nmv06,'anmi-260',1)
               NEXT FIELD nmv06
            END IF
            SELECT zx02 INTO g_zx02 FROM zx_file 
              WHERE zx01=g_nmv.nmv06
            DISPLAY g_zx02 TO FORMONLY.zx02 
             
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_nmv.nmv06 != g_nmv06_t) THEN
               SELECT count(*) INTO l_n FROM nmv_file 
                 WHERE nmv01 = g_nmv.nmv01 AND nmv06 = g_nmv.nmv06 
                       AND nmv08 ="ALL"
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_nmv.nmv01,-239,1)
                  LET g_nmv.nmv06 = g_nmv06_t
                  DISPLAY BY NAME g_nmv.nmv06
                  NEXT FIELD nmv06
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('nmv01:',g_errno,1)
                  LET g_nmv.nmv06 = g_nmv06_t
                  DISPLAY BY NAME g_nmv.nmv06
                  NEXT FIELD nmv06
               END IF
            END IF
         END IF
         IF g_nmv.nmv06 IS NULL THEN DISPLAY "" TO zx02 END IF
  
      AFTER FIELD nmv09
         IF cl_null(g_nmv.nmv09) THEN
            CALL cl_err(g_nmv.nmv09,'anm-098',1)
            NEXT FIELD nmv09
         END IF
 
      AFTER FIELD nmv10
         IF cl_null(g_nmv.nmv10) THEN
            CALL cl_err(g_nmv.nmv10,'anm-098',1)
            NEXT FIELD nmv10
         END IF
 
      AFTER FIELD nmv19
         IF NOT cl_null(g_nmv.nmv19) THEN
            IF g_nmv.nmv19 = 'Y' THEN
               IF g_nmv.nmv21 IS NULL THEN
                  LET g_nmv.nmv21 = 'N'
               END IF
               CALL cl_set_comp_entry("nmv20,nmv21,nmv22",TRUE) 
               CALL cl_set_comp_required("nmv20,nmv21",TRUE)
            ELSE
               LET g_nmv.nmv20 = NULL
               LET g_nmv.nmv21 = NULL
               LET g_nmv.nmv22 = NULL
               CALL cl_set_comp_required("nmv20,nmv21",FALSE)
               CALL cl_set_comp_entry("nmv20,nmv21,nmv22",FALSE) 
            END IF
         END IF
         
      AFTER FIELD nmv20
         IF cl_null(g_nmv.nmv20) THEN
            IF g_nmv.nmv19 = 'Y' THEN
               CALL cl_err(g_nmv.nmv20,'anm-124',0)
               NEXT FIELD nmv20
            END IF
         END IF
 
      AFTER FIELD nmv21
         IF NOT cl_null(g_nmv.nmv21) THEN
            IF g_nmv.nmv21 = 'Y' THEN
               CALL cl_set_comp_entry("nmv22",TRUE) 
               CALL cl_set_comp_required("nmv22",TRUE)
               IF g_nmv.nmv22 !='1' AND g_nmv.nmv22 IS NOT NULL THEN
                  CALL cl_set_comp_visible("Page03",TRUE)
               END IF
            ELSE
               LET g_nmv.nmv22 = NULL
               CALL cl_set_comp_required("nmv22",FALSE)
               CALL cl_set_comp_entry("nmv22",FALSE) 
               CALL cl_set_comp_visible("Page03",FALSE)
            END IF
         ELSE
            CALL cl_err(g_nmv.nmv21,'anm-124',0)
            NEXT FIELD nmv21
         END IF
         
      AFTER FIELD nmv22
         IF cl_null(g_nmv.nmv22) THEN
            IF g_nmv.nmv21 = 'Y' THEN
               CALL cl_err(g_nmv.nmv22,'anm-124',0)
               NEXT FIELD nmv22
            END IF
         ELSE
            IF g_nmv.nmv22 !='1' THEN
               CALL cl_set_comp_visible("Page03",TRUE)
               CALL i010_b2_fill(g_wc2)    
               CALL i010_bp2_refresh()
            ELSE
               CALL cl_set_comp_visible("Page03",FALSE)
            END IF
         END IF
 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_nmv.nmv01 IS NULL THEN
               DISPLAY BY NAME g_nmv.nmv01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD nmv01
            END IF
   
   ON ACTION CONTROLP
      CASE
       WHEN INFIELD(nmv06)
         CALL cl_init_qry_var()   
         LET g_qryparam.state = "i"
         LET g_qryparam.form = "q_zx"   
         LET g_qryparam.default1 = g_nmv.nmv06 
         CALL cl_create_qry() RETURNING g_nmv.nmv06   
         DISPLAY BY NAME g_nmv.nmv06
         NEXT FIELD nmv06
         OTHERWISE EXIT CASE
      END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about  
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help() 
 
   END INPUT
END FUNCTION
 
#No.FUN-870067-begin
FUNCTION i010_b()
DEFINE
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用 
    l_cnt           LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態 
    l_allow_insert  LIKE type_file.num5,                #可新增否
    l_allow_delete  LIKE type_file.num5                 #可刪除否 
DEFINE  i        LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_nmv.nmv01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_nmv.* FROM nmv_file
     WHERE nmv01=g_nmv.nmv01 AND nmv06 = g_nmv.nmv06
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nmx06,nmx03,nmx04,nmx05 ",
                       "  FROM nmx_file",
                       "  WHERE nmx01=? AND nmx02=? ",
                       "   AND nmx06=? ",
                       "  FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_nmx WITHOUT DEFAULTS FROM s_nmx.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET g_nmx[l_ac].nmx05 = 'N'    #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i010_cl USING g_nmv.nmv01
           IF STATUS THEN
              CALL cl_err("OPEN i010_cl:", STATUS, 1)
              CLOSE i010_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i010_cl INTO g_nmv.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_nmv.nmv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i010_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_nmx_t.* = g_nmx[l_ac].*  #BACKUP
              LET g_nmx_o.* = g_nmx[l_ac].*  #BACKUP
              OPEN i010_bcl USING g_nmv.nmv01,g_nmv.nmv06,g_nmx_t.nmx06
              IF STATUS THEN
                 CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i010_bcl INTO g_nmx[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_nmx_t.nmx06,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()    
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nmx[l_ac].* TO NULL  
           LET g_nmx[l_ac].nmx05 = 'N'
           LET g_nmx_t.* = g_nmx[l_ac].*         #新輸入資料
           LET g_nmx_o.* = g_nmx[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()         
           NEXT FIELD nmx06
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO nmx_file(nmx01,nmx02,nmx03,nmx04,nmx05,nmx06)
           VALUES(g_nmv.nmv01,g_nmv.nmv06,
                  g_nmx[l_ac].nmx03,g_nmx[l_ac].nmx04,
                  g_nmx[l_ac].nmx05,g_nmx[l_ac].nmx06)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nmx_file",g_nmv.nmv01,g_nmx[l_ac].nmx06,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD nmx06                        #default 序號
           IF g_nmx[l_ac].nmx06 IS NULL OR g_nmx[l_ac].nmx06 = 0 THEN
              SELECT max(nmx06)+1
                INTO g_nmx[l_ac].nmx06
                FROM nmx_file
               WHERE nmx01 = g_nmv.nmv01
                 AND nmx02 = g_nmv.nmv06
              IF g_nmx[l_ac].nmx06 IS NULL THEN
                 LET g_nmx[l_ac].nmx06 = 1
              END IF
           END IF
 
        AFTER FIELD nmx06                        #check 序號是否重複
           IF NOT cl_null(g_nmx[l_ac].nmx06) THEN
              IF g_nmx[l_ac].nmx06 != g_nmx_t.nmx06
                 OR g_nmx_t.nmx06 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM nmx_file
               WHERE nmx01 = g_nmv.nmv01
                 AND nmx02 = g_nmv.nmv06
                 AND nmx06 = g_nmx[l_ac].nmx06
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nmx[l_ac].nmx06 = g_nmx_t.nmx06
                    NEXT FIELD nmx06
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_nmx_t.nmx06 > 0 AND g_nmx_t.nmx06 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM nmx_file
               WHERE nmx01 = g_nmv.nmv01
                 AND nmx02 = g_nmv.nmv06
                 AND nmx06 = g_nmx_t.nmx06
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nmx_file",g_nmv.nmv01,g_nmx_t.nmx03,SQLCA.sqlcode,"","",1) 
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
              LET g_nmx[l_ac].* = g_nmx_t.*
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nmx[l_ac].nmx06,-263,1)
              LET g_nmx[l_ac].* = g_nmx_t.*
           ELSE
              UPDATE nmx_file SET nmx03=g_nmx[l_ac].nmx03,
                                  nmx04=g_nmx[l_ac].nmx04,
                                  nmx06=g_nmx[l_ac].nmx06 
               WHERE nmx01=g_nmv.nmv01
                 AND nmx02=g_nmv.nmv06
                 AND nmx06=g_nmx_t.nmx06
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","nmx_file",g_nmv.nmv01,g_nmx_t.nmx06,SQLCA.sqlcode,"","",1)  
                 LET g_nmx[l_ac].* = g_nmx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_nmx[l_ac].* = g_nmx_t.*
              END IF
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i010_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(nmx03) AND l_ac > 1 THEN
              LET g_nmx[l_ac].* = g_nmx[l_ac-1].*
              NEXT FIELD nmx03
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
 
    CLOSE i010_bcl
    COMMIT WORK
#   CALL i010_delall()         #CHI-C30002 mark
 
    CALL i010_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i010_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM nca_file WHERE nca01 = g_nmv.nmv01 AND nca02=g_nmv.nmv06   #CHI-C80041
         DELETE FROM nmv_file WHERE nmv01 = g_nmv.nmv01
         INITIALIZE g_nmv.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i010_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM nmx_file
#   WHERE nmx01 = g_nmv.nmv01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM nmv_file WHERE nmv01 = g_nmv.nmv01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i010_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT nmx06,nmx03,nmx04,nmx05", 
               " FROM nmx_file", 
               " WHERE nmx01 ='",g_nmv.nmv01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
 
   PREPARE i010_pb FROM g_sql
   DECLARE nmx_cs CURSOR FOR i010_pb
 
   CALL g_nmx.clear()
   LET g_cnt = 1
 
   FOREACH nmx_cs INTO g_nmx[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_nmx.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i010_bp_refresh()
 
  DISPLAY ARRAY g_nmx TO s_nmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
 
FUNCTION i010_b2()
DEFINE
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用 
    l_cnt           LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態 
    l_allow_insert  LIKE type_file.num5,                #可新增否
    l_allow_delete  LIKE type_file.num5                 #可刪除否 
DEFINE  i        LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_nmv.nmv01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_nmv.* FROM nmv_file
     WHERE nmv01=g_nmv.nmv01 AND nmv06 = g_nmv.nmv06
 
    IF g_nmv.nmv19 = 'N' OR g_nmv.nmv21 = 'N' OR g_nmv.nmv22 = '1'  THEN
       CALL cl_err(g_nmv.nmv01,'anm-122',1)
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nca03,nca04 ",
                       "  FROM nca_file",
                       "  WHERE nca01=? AND nca02=? ",
                       "   AND nca03=?",
                       "  FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_nca WITHOUT DEFAULTS FROM s_nca.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i010_cl USING g_nmv.nmv01
           IF STATUS THEN
              CALL cl_err("OPEN i010_cl:", STATUS, 1)
              CLOSE i010_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i010_cl INTO g_nmv.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_nmv.nmv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i010_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_nca_t.* = g_nca[l_ac].*  #BACKUP
              LET g_nca_o.* = g_nca[l_ac].*  #BACKUP
              OPEN i010_b2cl USING g_nmv.nmv01,g_nmv.nmv06,g_nca_t.nca03
              IF STATUS THEN
                 CALL cl_err("OPEN i010_b2cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i010_b2cl INTO g_nca[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_nca_t.nca03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()    
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nca[l_ac].* TO NULL  
           LET g_nca_t.* = g_nca[l_ac].*         #新輸入資料
           LET g_nca_o.* = g_nca[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()         
           NEXT FIELD nca03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO nca_file(nca01,nca02,nca03,nca04)
           VALUES(g_nmv.nmv01,g_nmv.nmv06,
                  g_nca[l_ac].nca03,g_nca[l_ac].nca04)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nca_file",g_nmv.nmv01,g_nca[l_ac].nca03,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD nca03                        #default 序號
           IF g_nca[l_ac].nca03 IS NULL OR g_nca[l_ac].nca03 = 0 THEN
              SELECT max(nca03)+1
                INTO g_nca[l_ac].nca03
                FROM nca_file
               WHERE nca01 = g_nmv.nmv01
                 AND nca02 = g_nmv.nmv06
              IF g_nca[l_ac].nca03 IS NULL THEN
                 LET g_nca[l_ac].nca03 = 1
              END IF
           END IF
 
        AFTER FIELD nca03                        #check 序號是否重複
           IF NOT cl_null(g_nca[l_ac].nca03) THEN
              IF g_nca[l_ac].nca03 != g_nca_t.nca03
                 OR g_nca_t.nca03 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM nca_file
               WHERE nca01 = g_nmv.nmv01
                 AND nca02 = g_nmv.nmv06
                 AND nca03 = g_nca[l_ac].nca03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nca[l_ac].nca03 = g_nca_t.nca03
                    NEXT FIELD nca03
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_nca_t.nca03 > 0 AND g_nca_t.nca03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM nca_file
               WHERE nca01 = g_nmv.nmv01
                 AND nca02 = g_nmv.nmv06
                 AND nca03 = g_nca_t.nca03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nca_file",g_nmv.nmv01,g_nca_t.nca03,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nca[l_ac].* = g_nca_t.*
              CLOSE i010_b2cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nca[l_ac].nca03,-263,1)
              LET g_nca[l_ac].* = g_nca_t.*
           ELSE
              UPDATE nca_file SET nca03=g_nca[l_ac].nca03,
                                  nca04=g_nca[l_ac].nca04
               WHERE nca01=g_nmv.nmv01
                 AND nca02=g_nmv.nmv06
                 AND nca03=g_nca_t.nca03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","nca_file",g_nmv.nmv01,g_nca_t.nca03,SQLCA.sqlcode,"","",1)  
                 LET g_nca[l_ac].* = g_nca_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_nca[l_ac].* = g_nca_t.*
              END IF
              CLOSE i010_b2cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i010_b2cl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(nca03) AND l_ac > 1 THEN
              LET g_nca[l_ac].* = g_nca[l_ac-1].*
              NEXT FIELD nca03
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
 
    CLOSE i010_b2cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_b2_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT nca03,nca04", 
               " FROM nca_file", 
               " WHERE nca01 ='",g_nmv.nmv01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
 
   PREPARE i010_pb2 FROM g_sql
   DECLARE nca_cs CURSOR FOR i010_pb2
 
   CALL g_nca.clear()
   LET g_cnt = 1
 
   FOREACH nca_cs INTO g_nca[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_nca.deleteElement(g_cnt)
 
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp2_refresh()
  DISPLAY ARRAY g_nca TO s_nca.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
        
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
#No.FUN-870067-end
 
FUNCTION i010_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_nmv.* TO NULL   
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i010_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i010_count
    FETCH i010_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i010_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmv.nmv01,SQLCA.sqlcode,0)
        INITIALIZE g_nmv.* TO NULL
    ELSE
        CALL i010_fetch('F')              # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION i010_fetch(p_flnmv)
    DEFINE
        p_flnmv         LIKE type_file.chr1          
 
    CASE p_flnmv
#        WHEN 'N' FETCH NEXT     i010_cs INTO g_nmv.nmv01  #MOD-960079                                                              
#        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_nmv.nmv01  #MOD-960079                                                              
#        WHEN 'F' FETCH FIRST    i010_cs INTO g_nmv.nmv01  #MOD-960079                                                              
#        WHEN 'L' FETCH LAST     i010_cs INTO g_nmv.nmv01  #MOD-960079                                                              
        WHEN 'N' FETCH NEXT     i010_cs INTO g_nmv.nmv01,g_nmv.nmv01  #MOD-960079                                                   
        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_nmv.nmv01,g_nmv.nmv01  #MOD-960079                                                   
        WHEN 'F' FETCH FIRST    i010_cs INTO g_nmv.nmv01,g_nmv.nmv01  #MOD-960079                                                   
        WHEN 'L' FETCH LAST     i010_cs INTO g_nmv.nmv01,g_nmv.nmv01  #MOD-960079  
        WHEN '/'
            IF (NOT mi_no_ask) THEN                  
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
#            FETCH ABSOLUTE g_jump i010_cs INTO g_nmv.nmv01    #MOD-960079                                                          
             FETCH ABSOLUTE g_jump i010_cs INTO g_nmv.nmv01,g_nmv.nmv01    #MOD-960079 
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmv.nmv01,SQLCA.sqlcode,0)
        INITIALIZE g_nmv.* TO NULL 
        RETURN
    ELSE
      CASE p_flnmv
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
#      DISPLAY g_curs_index TO FORMONLY.idx        #MOD-960082    
    END IF
 
    SELECT * INTO g_nmv.* FROM nmv_file    # 重讀DB,因TEMP有不被更新特性
       WHERE nmv01 = g_nmv.nmv01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","nmv_file",g_nmv.nmv01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        CALL i010_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i010_show()
    DEFINE l_n  LIKE type_file.num5
    LET g_nmv_t.* = g_nmv.*
    DISPLAY BY NAME g_nmv.nmv01,g_nmv.nmv06,g_nmv.nmv03,
                    g_nmv.nmv04,g_nmv.nmv05,g_nmv.nmv07,
                    g_nmv.nmv09,g_nmv.nmv10,g_nmv.nmv11,              #No.FUN-870067
                    g_nmv.nmv12,g_nmv.nmv13,g_nmv.nmv14,              #No.FUN-870067
                    g_nmv.nmv15,g_nmv.nmv16,g_nmv.nmv17,              #No.FUN-870067
                    g_nmv.nmv18,g_nmv.nmv19,g_nmv.nmv20,              #No.FUN-870067
                    g_nmv.nmv21,g_nmv.nmv22                           #No.FUN-870067
    SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=g_nmv.nmv06
    DISPLAY g_zx02 TO zx02
    CALL cl_show_fld_cont()              
    #No.FUN-870067--begin
    LET l_col="nmv09,nmv10,nmv11,nmv12,nmv13,nmv14,nmv15,",
              "nmv16,nmv17,nmv18,nmv19,nmv20,nmv21,nmv22 "
    SELECT count(*) INTO l_n FROM nmv_file  
     WHERE nmv01 = g_nmv.nmv01
       AND nmv09 IS NOT NULL
    IF l_n >0 THEN
       CALL cl_set_comp_visible(l_col,TRUE)
       CALL cl_set_comp_visible("Page02",TRUE)
       CALL cl_set_comp_visible("nmv03,nmv04,nmv05,nmv07",FALSE)
       CALL i010_b_fill(g_wc2)    
       CALL i010_bp_refresh()
       IF g_nmv.nmv21 = 'Y' AND g_nmv.nmv22 !='1' THEN
          CALL cl_set_comp_visible("Page03",TRUE)
          CALL i010_b2_fill(g_wc2)    
          CALL i010_bp2_refresh()
       ELSE
          CALL cl_set_comp_visible("Page03",FALSE)
       END IF
       CALL cl_show_fld_cont()           
    ELSE
       CALL cl_set_comp_visible("nmv03,nmv04,nmv05,nmv07",TRUE)
       CALL cl_set_comp_visible(l_col,FALSE)
       CALL cl_set_comp_visible("Page02",FALSE)
       CALL cl_set_comp_visible("Page03",FALSE)
    END IF
    #No.FUN-870067--end
END FUNCTION
 
FUNCTION i010_u()
    IF g_nmv.nmv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_nmv.* FROM nmv_file 
      WHERE nmv01=g_nmv.nmv01 AND nmv06=g_nmv.nmv06 AND nmv08="ALL"
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nmv01_t = g_nmv.nmv01
    LET g_nmv06_t = g_nmv.nmv06
    BEGIN WORK
 
    OPEN i010_cl USING g_nmv.nmv01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_nmv.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nmv.nmv01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i010_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i010_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_nmv.*=g_nmv_t.*
            CALL i010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nmv_file SET nmv_file.* = g_nmv.*    # 更新DB
            WHERE nmv01 = g_nmv01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","nmv_file",g_nmv.nmv01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
 
#No.FUN-870067--end   
    IF g_aza.aza78 = g_nmv.nmv01 THEN
       CALL cl_flow_notify(g_nmv.nmv01,'U')
       CALL i010_b_fill("1=1")
       CALL i010_bp_refresh()
       IF g_nmv.nmv21 = 'Y' AND g_nmv.nmv22 !='1' THEN
          CALL i010_b2_fill("1=1")
          CALL i010_bp2_refresh()
       END IF
    END IF
#No.FUN-870067--end   
 
END FUNCTION
 
FUNCTION i010_r()
    IF g_nmv.nmv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i010_cl USING g_nmv.nmv01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 0)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_nmv.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nmv.nmv01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i010_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nmv01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nmv.nmv01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM nmv_file WHERE nmv01 = g_nmv.nmv01 AND nmv06=g_nmv.nmv06 AND
                                  nmv08 = "ALL"
       DELETE FROM nmx_file WHERE nmx01 = g_nmv.nmv01 AND nmx02=g_nmv.nmv06             #No.FUN-870067
       DELETE FROM nca_file WHERE nca01 = g_nmv.nmv01 AND nca02=g_nmv.nmv06             #No.FUN-870067
       CLEAR FORM
       CALL g_nmx.clear()
       OPEN i010_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i010_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i010_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i010_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE              
          CALL i010_fetch('/')
       END IF
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_copy()
    DEFINE
        l_newno1        LIKE nmv_file.nmv01,
        l_newno2        LIKE nmv_file.nmv06,
        l_oldno1        LIKE nmv_file.nmv01,
        l_oldno2        LIKE nmv_file.nmv06,
        p_cmd           LIKE type_file.chr1,      
        l_input         LIKE type_file.chr1      
 
    IF g_nmv.nmv01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i010_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1,l_newno2 FROM nmv01,nmv06 
 
        BEFORE INPUT
         LET l_input='N'
         
        AFTER FIELD nmv01
           IF l_newno1 IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM nmv_file
                  WHERE nmv01 = l_newno1 AND nmv06=l_newno2 
                        AND nmv08 ="ALL"
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno1,-239,0)
                 NEXT FIELD nmv01
              END IF
           END IF
 
      
        AFTER FIELD nmv06
           IF l_newno2 IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM nmv_file
                  WHERE nmv01 = l_newno1 AND nmv06=l_newno2 
                        AND nmv08="ALL"
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno2,-239,0)
                 NEXT FIELD nmv06
              END IF
              SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=g_nmv.nmv06
              DISPLAY g_zx02 TO zx02
           END IF
       
        
   ON ACTION CONTROLP
      CASE
       WHEN INFIELD(nmv06)
         CALL cl_init_qry_var()   
         LET g_qryparam.state = "i"
         LET g_qryparam.form = "q_zx"   
         CALL cl_create_qry() RETURNING l_newno2
         DISPLAY l_newno2 TO nmv06
         NEXT FIELD nmv06
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
        DISPLAY BY NAME g_nmv.nmv01
        DISPLAY BY NAME g_nmv.nmv06
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM nmv_file
        WHERE nmv01 = g_nmv.nmv01
        INTO TEMP x
    UPDATE x
        SET nmv01=l_newno1,nmv06=l_newno2
    INSERT INTO nmv_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","nmv_file",g_nmv.nmv01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_nmv.nmv01
        LET l_oldno2 = g_nmv.nmv06
        LET g_nmv.nmv01 = l_newno1
        LET g_nmv.nmv06 = l_newno2
        SELECT nmv_file.* INTO g_nmv.* FROM nmv_file
          WHERE nmv01 = l_newno1 AND nmv06=l_newno2 
        CALL i010_u()
        #SELECT nmv_file.* INTO g_nmv.* FROM nmv_file  #FUN-C80046
        #  WHERE nmv01 = l_oldno1 AND nmv06=l_oldno2   #FUN-C80046
    END IF
    #LET g_nmv.nmv01 = l_oldno1  #FUN-C80046
    #LET g_nmv.nmv06 = l_oldno2  #FUN-C80046
    CALL i010_show()
END FUNCTION
 
FUNCTION i010_out()
    DEFINE
        l_i             LIKE type_file.num5,  
        l_nmv           RECORD LIKE nmv_file.*,
        l_name          LIKE type_file.chr20,            # External(Disk) file name    
        sr RECORD
           nmv01 LIKE nmv_file.nmv01,
           nmv03 LIKE nmv_file.nmv03,
           nmv04 LIKE nmv_file.nmv04,
           nmv05 LIKE nmv_file.nmv05
           END RECORD,
        l_za05          LIKE za_file.za05      
 
    IF g_wc IS NULL THEN LET g_wc=" nmv01='",g_nmv.nmv01,"'" END IF
    #改成印當下的那一筆資料內容
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT nmv01,nmv03,nmv04,nmv05 ",
              " FROM nmv_file ",
              " WHERE ",g_wc CLIPPED
 
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_curo                         # SCROLL CURSOR
         CURSOR FOR i010_p1
 
    CALL cl_outnam('anmi010') RETURNING l_name
    START REPORT i010_rep TO l_name
 
    FOREACH i010_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i010_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i010_rep
 
    CLOSE i010_curo
    ERROR ""
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT i010_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    
        sr RECORD
           nmv01 LIKE nmv_file.nmv01,
           nmv03 LIKE nmv_file.nmv03,
           nmv04 LIKE nmv_file.nmv04,
           nmv05 LIKE nmv_file.nmv05
           END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line  
 
    ORDER BY sr.nmv01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.nmv01,
                  COLUMN g_c[32],sr.nmv03,
                  COLUMN g_c[33],sr.nmv04,
                  COLUMN g_c[34],sr.nmv05
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                  g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                      g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION i010_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1        
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("nmv01",TRUE)
         CALL cl_set_comp_entry("nmv06",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("nmv01",FALSE)
       CALL cl_set_comp_entry("nmv06",FALSE)
    END IF
 
END FUNCTION
