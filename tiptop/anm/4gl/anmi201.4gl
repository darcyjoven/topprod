# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: anmi201.4gl
# Descriptions...: 轉帳媒體代碼轉換建立作業 
# Date & Author..: FUN-880073 08/08/21 By sabrina 
# Modify.........: FUN-870037 08/09/22 by Yiting  單身不要設定無值不能進入
# Modify.........: No.MOD-960082 09/06/09 By baofei 4fd中沒有idx欄位
# Modify.........: No.FUN-970080 09/07/27 By hongmei 原值nsc03非"D"日期型態則nsc03開放輸入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-970077 09/09/25 By chenmoyan nsc_file缺少KEY
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nsa         RECORD LIKE nsa_file.*,       
       g_nsa_t       RECORD LIKE nsa_file.*,       #單頭備份
       g_nsc         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           nsc02     LIKE nsc_file.nsc02,          #媒體序號
           nsc03     LIKE nsc_file.nsc03,          #原值 
           nsc04     LIKE nsc_file.nsc04           #轉換值 
                     END RECORD,
       g_nsc_t       RECORD                        #程式變數 (舊值)
           nsc02     LIKE nsc_file.nsc02,          #媒體序號
           nsc03     LIKE nsc_file.nsc03,          #原值 
           nsc04     LIKE nsc_file.nsc04           #轉換值 
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數 
       l_ac          LIKE type_file.num5           #單身目前指標
DEFINE p_row,p_col         LIKE type_file.num5   
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5     #判斷是否已執行 Before Input指令
DEFINE g_cnt               LIKE type_file.num10    
DEFINE g_msg               LIKE ze_file.ze03     
DEFINE g_curs_index        LIKE type_file.num10    #單頭目前指標
DEFINE g_row_count         LIKE type_file.num10    #單頭總筆數 
DEFINE g_jump              LIKE type_file.num10    #查詢指定的筆數
DEFINE g_no_ask           LIKE type_file.num5     #是否開啟指定筆視窗
DEFINE g_argv1             LIKE nsa_file.nsa01     #單號 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)          
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM nsa_file WHERE nsa01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i201_w WITH FORM "anm/42f/anmi201"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
 
   IF NOT cl_null(g_argv1) THEN
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN
      CALL i201_q()
      END IF
   END IF 
 
   CALL i201_menu()
 
   CLOSE WINDOW i201_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
#組sql查詢條件
FUNCTION i201_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01 
 
   CLEAR FORM 
   CALL g_nsc.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " nsa01 ='",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")     #預設單頭區塊開啟 
     
      INITIALIZE g_nsa.* TO NULL   
      CONSTRUCT BY NAME g_wc ON nsa01,nsa02,nsa03,nsa04,nsa05   #單頭條件
                              
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
 
         ON ACTION qbe_select                        #查詢提供條件選擇，選擇後直接帶入畫面
            CALL cl_qbe_list() RETURNING lc_qbe_sn   #提供列表選擇
            CALL cl_qbe_display_condition(lc_qbe_sn) #顯示條件
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
      IF NOT cl_null(g_argv1) THEN
         LET g_wc2 = ' 1=1'     
      ELSE
         CONSTRUCT g_wc2 ON nsc02,nsc03,nsc04   #螢幕上取單身條件 
              FROM s_nsc[1].nsc02,s_nsc[1].nsc03,s_nsc[1].nsc04                  
 
            BEFORE CONSTRUCT                   #再次顯示查詢條件，因為進入單身後會將原顯示值清空
               CALL cl_qbe_display_condition(lc_qbe_sn)
 
            ON ACTION controlp
               CASE
                  WHEN INFIELD(nsc02)             #媒體序號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form = "q_nsb"
                       LET g_qryparam.arg1 = g_nsa.nsa01
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO nsc02
                       NEXT FIELD nsc02
            
                  WHEN INFIELD(nsc04)
                       CALL q_nsc(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO nsc04
                       NEXT FIELD nsc04
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
 
                 ON ACTION qbe_save
                    CALL cl_qbe_save()
         END CONSTRUCT
   
         IF INT_FLAG THEN
            RETURN
         END IF
      END IF
 
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT nsa01 FROM nsa_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY nsa01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE nsa_file.nsa01 ",
                  "  FROM nsa_file, nsc_file ",
                  " WHERE nsa01 = nsc01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE i201_prepare FROM g_sql
   DECLARE i201_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i201_prepare
 
   IF g_wc2 = " 1=1" THEN                  #單身沒下條件時，計算符合單頭條件的筆數
      LET g_sql="SELECT COUNT(*) FROM nsa_file WHERE ",g_wc CLIPPED
   ELSE                                    #單身有下條件時，計算符合單頭和單身條件的筆數
      LET g_sql="SELECT COUNT(DISTINCT nsa01) FROM nsa_file,nsc_file WHERE ",
                "nsc01=nsa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i201_precount FROM g_sql
   DECLARE i201_count CURSOR FOR i201_precount
 
END FUNCTION
 
FUNCTION i201_menu()
 
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i201_b()
            ELSE
               LET g_action_choice = NULL          #如果沒做else判斷，則會變無窮迴圈
           END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nsa.nsa01 IS NOT NULL THEN
                 LET g_doc.column1 = "nsa01"
                 LET g_doc.value1 = g_nsa.nsa01
                 CALL cl_doc()
                 END IF
              END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)   #在單身顯示資料時，accept跟cancel將被隱藏
   DISPLAY ARRAY g_nsc TO s_nsc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #將資料顯示於畫面上
                                                                     
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                #設定欄位格式(不管有無特殊欄位，此行程式皆要保留著)             
 
      ON ACTION query
          LET g_action_choice="query"
          EXIT DISPLAY
 
      ON ACTION first
         CALL i201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL i201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL i201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL i201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL i201_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              #畫面上欄位的工具提示轉換語言別                 
 
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
         
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i201_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_nsc.clear()
   DISPLAY ' ' TO FORMONLY.cnt      #將筆數清空
 
   CALL i201_cs()              #進入i201_cs組查詢條件   
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_nsa.* TO NULL
      RETURN
   END IF
 
   OPEN i201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nsa.* TO NULL
   ELSE
      OPEN i201_count                       #在i201_cs裡計算出筆數
      FETCH i201_count INTO g_row_count     #將計算出的筆數變成指令
      DISPLAY g_row_count TO FORMONLY.cnt   #將筆數顯示在畫面上
 
      CALL i201_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#抓取單頭資料
FUNCTION i201_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i201_cs INTO g_nsa.nsa01
      WHEN 'P' FETCH PREVIOUS i201_cs INTO g_nsa.nsa01
      WHEN 'F' FETCH FIRST    i201_cs INTO g_nsa.nsa01
      WHEN 'L' FETCH LAST     i201_cs INTO g_nsa.nsa01
      WHEN '/'
         IF (NOT g_no_ask) THEN     #指定筆開窗選擇   
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
         FETCH ABSOLUTE g_jump i201_cs INTO g_nsa.nsa01  #抓取指定筆資料
         LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)
      INITIALIZE g_nsa.* TO NULL              
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
#      DISPLAY g_curs_index TO FORMONLY.idx         #MOD-960082           
   END IF
 
   SELECT * INTO g_nsa.* FROM nsa_file WHERE nsa01 = g_nsa.nsa01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nsa_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_nsa.* TO NULL
      RETURN
   END IF
 
   CALL i201_show()               #將資料顯示於畫面
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i201_show()
 
   LET g_nsa_t.* = g_nsa.*                #保存單頭舊值
 
 
   DISPLAY BY NAME g_nsa.nsa01, g_nsa.nsa02, g_nsa.nsa03,
                   g_nsa.nsa04, g_nsa.nsa05               
  
   CALL i201_b_fill(g_wc2)                 #抓取單身資料
   CALL cl_show_fld_cont()                 
END FUNCTION
 
#單身
FUNCTION i201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT     
    l_n             LIKE type_file.num5,                #檢查重複用 
    l_cnt           LIKE type_file.num5,                #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.num5,                #可新增否              
    l_allow_delete  LIKE type_file.num5                 #可刪除否  
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_nsa.nsa01 IS NULL THEN         #如果單頭沒資料，則return回menu
       RETURN
    END IF
 
    #--NO.FUN-870037 mark---
    #IF g_nsc[l_ac].nsc02 IS NULL THEN         #如果單身沒資料，則return回menu
    #   RETURN
    #END IF
    #--NO.FUN-870037 mark---
 
    SELECT * INTO g_nsa.* FROM nsa_file
     WHERE nsa01=g_nsa.nsa01
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nsc02,nsc03,nsc04",  
                       "  FROM nsc_file",
                       "  WHERE nsc01=? AND nsc02=? ",
                       "   AND nsc03=?",
                       " FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_bcl CURSOR FROM g_forupd_sql     #將單身的資料lock
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_nsc WITHOUT DEFAULTS FROM s_nsc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW =l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW =l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i201_cl USING g_nsa.nsa01
           IF STATUS THEN
              CALL cl_err("OPEN i201_cl:", STATUS, 1)
              CLOSE i201_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i201_cl INTO g_nsa.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i201_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN                 #當總筆數大於目前指標時，代表對原有的資料做修改
              LET p_cmd='u'                        #修改
              LET g_nsc_t.* = g_nsc[l_ac].*        #BACKUP
              OPEN i201_bcl USING g_nsa.nsa01,g_nsc_t.nsc02,g_nsc_t.nsc03
              IF STATUS THEN
                 CALL cl_err("OPEN i201_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i201_bcl INTO g_nsc[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_nsc_t.nsc02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              #FUN-970080---Begin
              CALL cl_set_comp_entry("nsc03",TRUE)
              IF g_nsc[l_ac].nsc03 ='D' THEN 
                 CALL cl_set_comp_entry("nsc03",FALSE)
              END IF 
              #FUN-970080---End
              CALL cl_show_fld_cont()     
           END IF
 
#--NO.FUN-870037 start---
         BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             INITIALIZE g_nsc[l_ac].* TO NULL
             LET g_nsc_t.* = g_nsc[l_ac].*         #新輸入資料
             CALL cl_show_fld_cont()    
             NEXT FIELD nsc02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO nsc_file(nsc01,nsc02,nsc03,nsc04)
                          VALUES(g_nsa.nsa01,
                                 g_nsc[l_ac].nsc02,
                                 g_nsc[l_ac].nsc03,
                                 g_nsc[l_ac].nsc04)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","nsc_file",g_nsa.nsa01,g_nsc[l_ac].nsc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               COMMIT WORK
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
            END IF
#--NO.FUN-870037 end-----
         #FUN-970080---Begin
         BEFORE FIELD nsc02
           CALL cl_set_comp_entry("nsc03",TRUE)
         #FUN-970080---End
         
         AFTER FIELD nsc02                              
            IF NOT cl_null(g_nsc[l_ac].nsc02) THEN
               IF g_nsc[l_ac].nsc02 != g_nsc_t.nsc02 OR g_nsc_t.nsc02 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM nsc_file
                  WHERE nsc01=g_nsa.nsa01
                    AND nsc02=g_nsc[l_ac].nsc02
                    AND nsc03=g_nsc[l_ac].nsc03    #FUN-970077 add
                  IF l_n > 0 THEN                          #CHECK序號是否重覆
                     CALL cl_err(g_nsc[l_ac].nsc02, '-239',1)
                     LET g_nsc[l_ac].nsc02 = g_nsc_t.nsc02
                     DISPLAY BY NAME g_nsc[l_ac].nsc02
                     NEXT FIELD nsc02
                  ELSE  
                     SELECT COUNT(*) INTO l_n FROM nsb_file 
                     WHERE nsb01=g_nsa.nsa01 
                       AND nsb02=g_nsc[l_ac].nsc02
                     IF l_n=0 THEN                         #CHECK資料是否存在nsb_file
                        CALL cl_err(g_nsc[l_ac].nsc02,'abx-020',1)
                        LET g_nsc[l_ac].nsc02 = g_nsc_t.nsc02
                        DISPLAY BY NAME g_nsc[l_ac].nsc02
                        NEXT FIELD nsc02
                     ELSE
                        SELECT nsb08 INTO g_nsc[l_ac].nsc03 FROM nsb_file 
                        WHERE nsb01=g_nsa.nsa01 
                          AND nsb02=g_nsc[l_ac].nsc02
                        DISPLAY BY NAME g_nsc[l_ac].nsc03
                     END IF
                  END IF
               END IF
               #FUN-970080---Begin
               IF NOT cl_null(g_nsc[l_ac].nsc03) THEN 
                  IF g_nsc[l_ac].nsc03 ='D' THEN 
                     CALL cl_set_comp_entry("nsc03",FALSE)
                  END IF 
               END IF    
               #FUN-970080---End
            END IF
 
        BEFORE FIELD nsc04
            CALL i201_set_no_required_b()
            CALL i201_set_required_b()
 
        AFTER FIELD nsc04                            #判斷格式是否正確
         IF g_nsc[l_ac].nsc03 = 'D' THEN   #FUN-970106
           IF (g_nsc[l_ac].nsc04 <> 'YYYYMMDD')
           AND (g_nsc[l_ac].nsc04 <> 'YYYY/MM/DD')
           AND (g_nsc[l_ac].nsc04 <> 'YYMMDD') 
           AND (g_nsc[l_ac].nsc04 <> 'YYYMMDD') THEN
                CALL cl_err('nsc04','anm-201',1)
                LET g_nsc[l_ac].nsc04 = g_nsc_t.nsc04
                DISPLAY BY NAME g_nsc[l_ac].nsc04
                NEXT FIELD nsc04
           END IF
         #FUN-970080---Begin
         ELSE 
           DISPLAY BY NAME g_nsc[l_ac].nsc04
         END IF
         #FUN-970080---End
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_nsc_t.nsc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN    #詢問使用者是否刪除
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM nsc_file
               WHERE nsc01 = g_nsa.nsa01
                 AND nsc02 = g_nsc_t.nsc02
                 AND nsc03 = g_nsc_t.nsc03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nsc_file",g_nsa.nsa01,g_nsc_t.nsc02,SQLCA.sqlcode,"","",1)  
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
              LET g_nsc[l_ac].* = g_nsc_t.*
              CLOSE i201_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nsc[l_ac].nsc02,-263,1)
              LET g_nsc[l_ac].* = g_nsc_t.*
           ELSE
              UPDATE nsc_file SET nsc02=g_nsc[l_ac].nsc02,
                                  nsc03=g_nsc[l_ac].nsc03,
                                  nsc04=g_nsc[l_ac].nsc04
               WHERE nsc01=g_nsa.nsa01
                 AND nsc02=g_nsc_t.nsc02
                 AND nsc03=g_nsc_t.nsc03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","nsc_file",g_nsa.nsa01,g_nsc_t.nsc02,SQLCA.sqlcode,"","",1)  
                 LET g_nsc[l_ac].* = g_nsc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac       #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_nsc[l_ac].* = g_nsc_t.*
           #FUN-D30032--add--str--
               ELSE
                  CALL g_nsc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
           #FUN-D30032--add--end--
              END IF
              CLOSE i201_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30032 add 
           CLOSE i201_bcl
           COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(nsc02)             #媒體序號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nsb"
               LET g_qryparam.arg1 = g_nsa.nsa01
               LET g_qryparam.default1 = g_nsc[l_ac].nsc02
               LET g_qryparam.default2 = g_nsc[l_ac].nsc03  #FUN-970080
               CALL cl_create_qry() RETURNING g_nsc[l_ac].nsc02, g_nsc[l_ac].nsc03
               DISPLAY BY NAME g_nsc[l_ac].nsc02, g_nsc[l_ac].nsc03
               NEXT FIELD nsc02
             
             WHEN INFIELD(nsc04)            #轉換值
               IF g_nsc[l_ac].nsc03 = 'D' THEN
                  CALL q_nsc(FALSE,FALSE,g_nsc[l_ac].nsc04) RETURNING g_nsc[l_ac].nsc04
                  DISPLAY BY NAME g_nsc[l_ac].nsc04
                  NEXT FIELD nsc04
               END IF
           END CASE
 
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
 
    CLOSE i201_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i201_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT nsc02,nsc03,nsc04 ", 
               "FROM nsc_file",  
               " WHERE nsc01 ='",g_nsa.nsa01,"' "  
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY nsc02,nsc03,nsc04 "
 
   DISPLAY g_sql
 
   PREPARE i201_pb FROM g_sql
   DECLARE nsc_cs CURSOR FOR i201_pb
 
   CALL g_nsc.clear()
   LET g_cnt = 1
 
   FOREACH nsc_cs INTO g_nsc[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_nsc.deleteElement(g_cnt)   
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i201_set_no_required_b()
      CALL cl_set_comp_required("nsc04",FALSE)
END FUNCTION
 
FUNCTION i201_set_required_b()
    IF g_nsc[l_ac].nsc03 = 'D' THEN
       CALL cl_set_comp_required("nsc04",TRUE)
    ELSE 
       CALL cl_set_comp_required("nsc04",FALSE)
    END IF
END FUNCTION
#FUN-880073 ---end---
