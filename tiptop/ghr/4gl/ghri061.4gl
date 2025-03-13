# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri061.4gl
# Descriptions...: 个税简表维护作业
# Date & Author..: 13/05/22 By yangjian

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_head          RECORD 
           hrcu01      LIKE hrcu_file.hrcu01,
           hrcu02      LIKE hrcu_file.hrcu02,
           hrcu03      LIKE hrcu_file.hrcu03,
           hrcu04      LIKE hrcu_file.hrcu04
              END RECORD,  
    g_head_t          RECORD 
           hrcu01      LIKE hrcu_file.hrcu01,
           hrcu02      LIKE hrcu_file.hrcu02,
           hrcu03      LIKE hrcu_file.hrcu03,
           hrcu04      LIKE hrcu_file.hrcu04
              END RECORD,                   
    g_hrcu           DYNAMIC ARRAY OF RECORD   
        hrcu05       LIKE hrcu_file.hrcu05,  
        hrcu06       LIKE hrcu_file.hrcu06,  
        hrcu07       LIKE hrcu_file.hrcu07, 
        hrcu10       LIKE hrcu_file.hrcu10,
        hrcu11       LIKE hrcu_file.hrcu11,        
        hrcu08       LIKE hrcu_file.hrcu08,
        hrcu09       LIKE hrcu_file.hrcu09,  
        hrcu12       LIKE hrcu_file.hrcu12,
        hrcuud01     LIKE hrcu_file.hrcuud01,
        hrcuud02     LIKE hrcu_file.hrcuud02,
        hrcuud03     LIKE hrcu_file.hrcuud03,
        hrcuud04     LIKE hrcu_file.hrcuud04,
        hrcuud05     LIKE hrcu_file.hrcuud05,
        hrcuud06     LIKE hrcu_file.hrcuud06,
        hrcuud07     LIKE hrcu_file.hrcuud07,
        hrcuud08     LIKE hrcu_file.hrcuud08,
        hrcuud09     LIKE hrcu_file.hrcuud09,
        hrcuud10     LIKE hrcu_file.hrcuud10,
        hrcuud11     LIKE hrcu_file.hrcuud11,
        hrcuud12     LIKE hrcu_file.hrcuud12,
        hrcuud13     LIKE hrcu_file.hrcuud13,
        hrcuud14     LIKE hrcu_file.hrcuud14,
        hrcuud15     LIKE hrcu_file.hrcuud15 
                    END RECORD,
    g_hrcu_t         RECORD                 #程式變數 (舊值)
        hrcu05       LIKE hrcu_file.hrcu05,  
        hrcu06       LIKE hrcu_file.hrcu06,  
        hrcu07       LIKE hrcu_file.hrcu07,
        hrcu10       LIKE hrcu_file.hrcu10,
        hrcu11       LIKE hrcu_file.hrcu11,         
        hrcu08       LIKE hrcu_file.hrcu08,
        hrcu09       LIKE hrcu_file.hrcu09,  
        hrcu12       LIKE hrcu_file.hrcu12,
        hrcuud01     LIKE hrcu_file.hrcuud01,
        hrcuud02     LIKE hrcu_file.hrcuud02,
        hrcuud03     LIKE hrcu_file.hrcuud03,
        hrcuud04     LIKE hrcu_file.hrcuud04,
        hrcuud05     LIKE hrcu_file.hrcuud05,
        hrcuud06     LIKE hrcu_file.hrcuud06,
        hrcuud07     LIKE hrcu_file.hrcuud07,
        hrcuud08     LIKE hrcu_file.hrcuud08,
        hrcuud09     LIKE hrcu_file.hrcuud09,
        hrcuud10     LIKE hrcu_file.hrcuud10,
        hrcuud11     LIKE hrcu_file.hrcuud11,
        hrcuud12     LIKE hrcu_file.hrcuud12,
        hrcuud13     LIKE hrcu_file.hrcuud13,
        hrcuud14     LIKE hrcu_file.hrcuud14,
        hrcuud15     LIKE hrcu_file.hrcuud15 
                    END RECORD,
    g_hrag   RECORD LIKE hrag_file.*,
    g_wc2,g_sql     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5,      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
    l_ac1           LIKE type_file.num5
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                   #No.FUN-850016                                                                    
DEFINE   g_str           STRING                   #No.FUN-850016   
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗    
DEFINE g_flag            LIKE type_file.chr10             #add by leo 130503                                                              


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_head.hrcu01 = ARG_VAL(1) 
   LET g_head.hrcu02 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_forupd_sql = "SELECT * FROM hrcu_file WHERE hrcu01 = ? ",
                      "   FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i061_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i061_w WITH FORM "ghr/42f/ghri061"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL i061_menu()
 
   CLOSE WINDOW i061_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i061_menu()
 
   WHILE TRUE
      CALL i061_bp("G")  
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
            	 CALL i061_a()
            END IF 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i061_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
            	 CALL i061_u()
            END IF 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i061_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            	 CALL i061_r()
            END IF 
         WHEN "next"
            IF cl_chk_act_auth() THEN
            	 CALL i061_fetch('N')
            END IF    
         WHEN "previous"
            IF cl_chk_act_auth() THEN
            	 CALL i061_fetch('P')
            END IF  
         WHEN "jump"
            IF cl_chk_act_auth() THEN
            	 CALL i061_fetch('/')
            END IF  
         WHEN "first"
            IF cl_chk_act_auth() THEN
            	 CALL i061_fetch('F')
            END IF  
         WHEN "last"
            IF cl_chk_act_auth() THEN
            	 CALL i061_fetch('L')
            END IF               
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              LET g_flag ='N'
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcu),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION


FUNCTION i061_cs()
 
    CLEAR FORM
    INITIALIZE g_head.* TO NULL
    CALL g_hrcu.clear()
    LET g_wc2 = NULL
    
    CONSTRUCT g_wc2 ON hrcu01,hrcu02,hrcu03,hrcu04,
                       hrcu05,hrcu06,hrcu07,hrcu10,hrcu11,hrcu08,hrcu09,hrcu12,
                       hrcuud01,hrcuud02,hrcuud03,hrcuud04,hrcuud05,
                       hrcuud06,hrcuud07,hrcuud08,hrcuud09,hrcuud10,
                       hrcuud11,hrcuud12,hrcuud13,hrcuud14,hrcuud15
         FROM hrcu01,hrcu02,hrcu03,hrcu04,
              s_hrcu[1].hrcu05,s_hrcu[1].hrcu06,s_hrcu[1].hrcu07,s_hrcu[1].hrcu10,s_hrcu[1].hrcu11,
              s_hrcu[1].hrcu08,s_hrcu[1].hrcu09,s_hrcu[1].hrcu12, 
              s_hrcu[1].hrcuud01,s_hrcu[1].hrcuud02,s_hrcu[1].hrcuud03,s_hrcu[1].hrcuud04, 
              s_hrcu[1].hrcuud05,s_hrcu[1].hrcuud06,s_hrcu[1].hrcuud07,s_hrcu[1].hrcuud08,
              s_hrcu[1].hrcuud09,s_hrcu[1].hrcuud10,s_hrcu[1].hrcuud11,s_hrcu[1].hrcuud12,
              s_hrcu[1].hrcuud13,s_hrcu[1].hrcuud14,s_hrcu[1].hrcuud15
 
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
    
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
            CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcuuser', 'hrcugrup') #FUN-980030
 
    LET g_sql = "SELECT DISTINCT hrcu01,hrcu02,hrcu03,hrcu04 FROM hrcu_file ",
                " WHERE ",g_wc2 CLIPPED, 
                " ORDER BY 1,2,3,4"
    PREPARE i061_prepare FROM g_sql
    DECLARE i061_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i061_prepare

    LET g_sql = "SELECT COUNT (*) FROM (",
                " SELECT DISTINCT hrcu01,hrcu02,hrcu03,hrcu04 FROM hrcu_file ",
                " WHERE ",g_wc2 CLIPPED ,
                " ) "
    PREPARE i061_precount FROM g_sql
    DECLARE i061_count CURSOR FOR i061_precount
END FUNCTION
 
FUNCTION i061_q()
 
   CALL i061_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i061_count
    FETCH i061_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i061_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrcu01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL
    ELSE
        CALL i061_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION


FUNCTION i061_fetch(p_flhrcu)
    DEFINE p_flhrcu         LIKE type_file.chr1
 
    CASE p_flhrcu
        WHEN 'N' FETCH NEXT     i061_cs INTO g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
        WHEN 'P' FETCH PREVIOUS i061_cs INTO g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
        WHEN 'F' FETCH FIRST    i061_cs INTO g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
        WHEN 'L' FETCH LAST     i061_cs INTO g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i061_cs INTO g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head.hrcu01,SQLCA.sqlcode,0)
        INITIALIZE g_head.* TO NULL  
        RETURN
    ELSE
      CASE p_flhrcu
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT DISTINCT hrcu01,hrcu02,hrcu03,hrcu04
      INTO g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
      FROM hrcu_file    # 重讀DB,因TEMP有不被更新特性
     WHERE hrcu01 = g_head.hrcu01
       AND hrcu02 = g_head.hrcu02
       AND hrcu03 = g_head.hrcu03
       AND hrcu04 = g_head.hrcu04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcu_file",g_head.hrcu01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        CALL i061_show()                   # 重新顯示
    END IF
END FUNCTION
 

FUNCTION i061_show()

    LET g_head_t.* = g_head.*
    DISPLAY BY NAME g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
    CALL cl_show_fld_cont()
    
    CALL i061_b_fill()
END FUNCTION


FUNCTION i061_a()
 DEFINE l_hrcu   RECORD LIKE hrcu_file.*

    CLEAR FORM 
    INITIALIZE g_head.* TO NULL
    LET g_rec_b = 0 
    CALL g_hrcu.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_head.hrcu03 = 'N'
        LET g_head.hrcu04 = 'N'
        CALL i061_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
        	  CALL g_hrcu.clear()
        	  INITIALIZE g_head.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_head.hrcu01 IS NULL OR g_head.hrcu02 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL i061_b()
        EXIT WHILE
    END WHILE
    CALL i061_show()
END FUNCTION


FUNCTION i061_u()
    IF g_head.hrcu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i061_cl USING g_head.hrcu01
    IF STATUS THEN
       CALL cl_err("OPEN i061_cl:", STATUS, 1)
       CLOSE i061_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    LET g_head_t.* = g_head.*
    CALL i061_show()
    WHILE TRUE
       CALL i061_i("u")
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_head.*=g_head_t.*
          CALL i061_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       UPDATE hrcu_file SET hrcu02 = g_head.hrcu02,
                            hrcu03 = g_head.hrcu03,
                            hrcu04 = g_head.hrcu04,
                            hrcumodu = g_user,
                            hrcudate = g_today
        WHERE hrcu01 = g_head.hrcu01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrcu_file",g_head.hrcu01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i061_cl
    COMMIT WORK
    
END FUNCTION
    
FUNCTION i061_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
 
   DISPLAY BY NAME g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
 
   INPUT BY NAME
      g_head.hrcu01,g_head.hrcu02,g_head.hrcu03,g_head.hrcu04
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         CALL i061_set_entry(p_cmd)
         CALL i061_set_no_entry(p_cmd)
 
      AFTER FIELD hrcu01
         IF g_head.hrcu01 IS NOT NULL THEN
         	  IF g_head.hrcu01 != g_head_t.hrcu01 OR
         	     g_head.hrcu01 IS NULL THEN 
               SELECT COUNT(*) INTO l_n FROM hrcu_file 
                WHERE hrcu01 = g_head.hrcu01
               IF l_n > 0 THEN 
                  CALL cl_err('hrcu01:',-239,1)
                  LET g_head.hrcu01 = NULL
                  DISPLAY BY NAME g_head.hrcu01
                  NEXT FIELD hrcu01
               ELSE 
               
               END IF
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
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
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


FUNCTION i061_r()
    IF g_head.hrcu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i061_cl USING g_head.hrcu01
    IF STATUS THEN
       CALL cl_err("OPEN i061_cl:", STATUS, 0)
       CLOSE i061_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i061_cl INTO g_head.hrcu01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_head.hrcu01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i061_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrcu01"   
       LET g_doc.value1 = g_head.hrcu01       

       CALL cl_del_doc()
       DELETE FROM hrcu_file WHERE hrcu01 = g_head.hrcu01
       CLEAR FORM
       OPEN i061_count
       IF STATUS THEN
          CLOSE i061_cl
          CLOSE i061_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i061_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i061_cl
          CLOSE i061_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i061_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i061_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i061_fetch('/')
       END IF
    END IF
    CLOSE i061_cl
    COMMIT WORK
END FUNCTION


FUNCTION i061_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_head.hrcu01 IS NULL THEN RETURN END IF 
   
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                      #FUN-510041 add hrcu05
   LET g_forupd_sql = " SELECT hrcu05 ",
                      "   FROM hrcu_file ",  #TQC-B30004 
                      "  WHERE hrcu01= ? AND hrcu05= ?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i061_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrcu WITHOUT DEFAULTS FROM s_hrcu.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrcu_t.* = g_hrcu[l_ac].*  #BACKUP
            OPEN i061_bcl USING g_head.hrcu01,g_hrcu_t.hrcu05
            IF STATUS THEN
               CALL cl_err("OPEN i061_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i061_bcl INTO g_hrcu[l_ac].hrcu05 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcu_t.hrcu05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
               END IF
            END IF
            CALL i061_set_entry_b('u')
            CALL i061_set_no_entry_b('u')            
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrcu[l_ac].* TO NULL      #900423
         LET g_hrcu_t.* = g_hrcu[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         CALL i061_set_entry_b('a')
         CALL i061_set_no_entry_b('a')
         NEXT FIELD hrcu05
         
      BEFORE FIELD hrcu05 
         IF g_hrcu[l_ac].hrcu05 IS NULL OR g_hrcu[l_ac].hrcu05 = 0 THEN 
         	  SELECT MAX(hrcu05)+1 INTO g_hrcu[l_ac].hrcu05 FROM hrcu_file
         	   WHERE hrcu01 = g_head.hrcu01
         	  IF g_hrcu[l_ac].hrcu05 IS NULL THEN 
         	  	 LET g_hrcu[l_ac].hrcu05 = 1 
         	  END IF 
         END IF 
         
      AFTER FIELD hrcu05
         IF NOT cl_null(g_hrcu[l_ac].hrcu05) THEN
         	  IF g_hrcu[l_ac].hrcu05 != g_hrcu_t.hrcu05 OR 
         	     g_hrcu_t.hrcu05 IS NULL THEN 
            	  SELECT COUNT(*) INTO l_n FROM hrcu_file
         	      WHERE hrcu01 = g_head.hrcu01
         	        AND hrcu05 = g_hrcu[l_ac].hrcu05
         	     IF l_n > 0 THEN 
         	  	    CALL cl_err('',-239,0)
         	  	    LET g_hrcu[l_ac].hrcu05 = g_hrcu_t.hrcu05
         	     END IF 
         	  END IF 
         END IF 
         
      AFTER FIELD hrcu06
         IF NOT cl_null(g_hrcu[l_ac].hrcu06) THEN
            CALL i061_calc()
         END IF       
         
      AFTER FIELD hrcu07
         IF NOT cl_null(g_hrcu[l_ac].hrcu07) THEN
            CALL i061_calc()
         END IF 
          
      AFTER FIELD hrcu10
         IF NOT cl_null(g_hrcu[l_ac].hrcu10) THEN
            CALL i061_calc()
         END IF       
         
      AFTER FIELD hrcu11
         IF NOT cl_null(g_hrcu[l_ac].hrcu11) THEN
            CALL i061_calc()
         END IF 
                   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO hrcu_file(hrcu01,hrcu02,hrcu03,hrcu04,hrcu05,hrcu06,
                               hrcu07,hrcu08,hrcu09,hrcu10,hrcu11,hrcu12,
                               hrcuud01,hrcuud02,hrcuud03,hrcuud04,hrcuud05,
                               hrcuud06,hrcuud07,hrcuud08,hrcuud09,hrcuud10,
                               hrcuud11,hrcuud12,hrcuud13,hrcuud14,hrcuud15,
                               hrcuuser,hrcugrup,hrcumodu,hrcudate,hrcuacti,
                               hrcuoriu,hrcuorig)
                       VALUES(g_head.hrcu01,g_head.hrcu02,
                              g_head.hrcu03,g_head.hrcu04,
                              g_hrcu[l_ac].hrcu05,  
                              g_hrcu[l_ac].hrcu06,   
                              g_hrcu[l_ac].hrcu07,   
                              g_hrcu[l_ac].hrcu08,   
                              g_hrcu[l_ac].hrcu09,   
                              g_hrcu[l_ac].hrcu10,
                              g_hrcu[l_ac].hrcu11,
                              g_hrcu[l_ac].hrcu12,
                              g_hrcu[l_ac].hrcuud01,
                              g_hrcu[l_ac].hrcuud02,
                              g_hrcu[l_ac].hrcuud03,
                              g_hrcu[l_ac].hrcuud04,
                              g_hrcu[l_ac].hrcuud05,
                              g_hrcu[l_ac].hrcuud06,
                              g_hrcu[l_ac].hrcuud07,
                              g_hrcu[l_ac].hrcuud08,
                              g_hrcu[l_ac].hrcuud09,
                              g_hrcu[l_ac].hrcuud10,
                              g_hrcu[l_ac].hrcuud11,
                              g_hrcu[l_ac].hrcuud12,
                              g_hrcu[l_ac].hrcuud13,
                              g_hrcu[l_ac].hrcuud14,
                              g_hrcu[l_ac].hrcuud15,
                              g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcu_file",g_hrcu[l_ac].hrcu05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrcu_t.hrcu05 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrcu_file WHERE hrcu01 = g_head.hrcu01
                                    AND hrcu05 = g_hrcu_t.hrcu05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcu_file",g_hrcu_t.hrcu05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
            LET g_hrcu[l_ac].* = g_hrcu_t.*
            CLOSE i061_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcu[l_ac].hrcu05,-263,1)
            LET g_hrcu[l_ac].* = g_hrcu_t.*
         ELSE
            UPDATE hrcu_file SET 
                                hrcu01=g_head.hrcu01,
                                hrcu02=g_head.hrcu02,
                                hrcu03=g_head.hrcu03,
                                hrcu04=g_head.hrcu04,
                                hrcu05=g_hrcu[l_ac].hrcu05,  
                                hrcu06=g_hrcu[l_ac].hrcu06,  
                                hrcu07=g_hrcu[l_ac].hrcu07,  
                                hrcu08=g_hrcu[l_ac].hrcu08,  
                                hrcu09=g_hrcu[l_ac].hrcu09,
                                hrcu10=g_hrcu[l_ac].hrcu10,
                                hrcu11=g_hrcu[l_ac].hrcu11,
                                hrcu12=g_hrcu[l_ac].hrcu12,  
                                hrcuud01=g_hrcu[l_ac].hrcuud01, 
                                hrcuud02=g_hrcu[l_ac].hrcuud02, 
                                hrcuud03=g_hrcu[l_ac].hrcuud03, 
                                hrcuud04=g_hrcu[l_ac].hrcuud04, 
                                hrcuud05=g_hrcu[l_ac].hrcuud05, 
                                hrcuud06=g_hrcu[l_ac].hrcuud06, 
                                hrcuud07=g_hrcu[l_ac].hrcuud07, 
                                hrcuud08=g_hrcu[l_ac].hrcuud08, 
                                hrcuud09=g_hrcu[l_ac].hrcuud09, 
                                hrcuud10=g_hrcu[l_ac].hrcuud10, 
                                hrcuud11=g_hrcu[l_ac].hrcuud11, 
                                hrcuud12=g_hrcu[l_ac].hrcuud12, 
                                hrcuud13=g_hrcu[l_ac].hrcuud13, 
                                hrcuud14=g_hrcu[l_ac].hrcuud14, 
                                hrcuud15=g_hrcu[l_ac].hrcuud15,
                                hrcumodu = g_user,
                                hrcudate = g_today
             WHERE hrcu01 = g_head.hrcu01
               AND hrcu05 = g_hrcu_t.hrcu05 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcu_file",g_head.hrcu01,g_hrcu_t.hrcu05,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrcu[l_ac].* = g_hrcu_t.*
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
            IF p_cmd='u' THEN
               LET g_hrcu[l_ac].* = g_hrcu_t.*
            END IF
            CLOSE i061_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i061_bcl
         COMMIT WORK

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hrcu01) AND l_ac > 1 THEN
            LET g_hrcu[l_ac].* = g_hrcu[l_ac-1].*
            NEXT FIELD hrcu05
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i061_bcl
 
   COMMIT WORK
 
END FUNCTION

FUNCTION i061_calc()

   LET g_hrcu[l_ac].hrcu08 = g_hrcu[l_ac].hrcu06 +g_hrcu[l_ac].hrcu11 - g_hrcu[l_ac].hrcu06*g_hrcu[l_ac].hrcu10/100
   LET g_hrcu[l_ac].hrcu09 = g_hrcu[l_ac].hrcu07 +g_hrcu[l_ac].hrcu11 - g_hrcu[l_ac].hrcu07*g_hrcu[l_ac].hrcu10/100
   
END FUNCTION
 
FUNCTION i061_b_fill()  
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrcu05,hrcu06,hrcu07,hrcu10,hrcu11,hrcu08,hrcu09,hrcu12, ",
               "       hrcuud01,hrcuud02,hrcuud03,hrcuud04,hrcuud05,",
               "       hrcuud06,hrcuud07,hrcuud08,hrcuud09,hrcuud10,",
               "       hrcuud11,hrcuud12,hrcuud13,hrcuud14,hrcuud15 ",
               "  FROM hrcu_file ",                                         #FUN-B80058 add hrcu071,hrcu141
               " WHERE hrcu01 = '",g_head.hrcu01 CLIPPED,"' ",
               " ORDER BY hrcu05"
   PREPARE i061_pb FROM g_sql
   DECLARE hrcu_curs CURSOR FOR i061_pb
 
   CALL g_hrcu.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrcu_curs INTO g_hrcu[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrcu.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION

 
 
FUNCTION i061_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY g_hrcu TO s_hrcu.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
             CALL cl_navigator_setting(g_curs_index, g_row_count)
               
            
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
      END DISPLAY 


         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
         ON ACTION next
            LET g_action_choice="next"
            EXIT DIALOG
         ON ACTION previous
            LET g_action_choice="previous" 
            EXIT DIALOG     
         ON ACTION jump
            LET g_action_choice="jump" 
            EXIT DIALOG
         ON ACTION first
            LET g_action_choice="first" 
            EXIT DIALOG
         ON ACTION last
            LET g_action_choice="last"    
            EXIT DIALOG                                    
               
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
      
         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ##########################################################################
         # Special 4ad ACTION
         ##########################################################################
         ON ACTION controlg 
            LET g_action_choice="controlg"
            EXIT DIALOG
      
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
      
         ON ACTION cancel
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice="exit"
            EXIT DIALOG
            
         ON ACTION close
            LET g_action_choice="exit"
            EXIT DIALOG   

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION exporttoexcel   #No.FUN-4B0020
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
      
      END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i061_set_entry(p_cmd)
 DEFINE p_cmd  LIKE  type_file.chr1
 
   IF p_cmd = 'a' THEN 
   	  CALL cl_set_comp_entry("hrcu01",TRUE)
   END IF 
END FUNCTION

FUNCTION i061_set_no_entry(p_cmd)
 DEFINE p_cmd  LIKE  type_file.chr1
 
   IF p_cmd = 'u' THEN
   	  CALL cl_set_comp_entry("hrcu01",FALSE)
   END IF 
END FUNCTION

FUNCTION i061_set_entry_b(p_cmd)
 DEFINE p_cmd  LIKE  type_file.chr1


END FUNCTION

FUNCTION i061_set_no_entry_b(p_cmd)
 DEFINE p_cmd  LIKE  type_file.chr1
 
   CALL cl_set_comp_entry("hrcu05,hrcu08,hrcu09",FALSE)
END FUNCTION

