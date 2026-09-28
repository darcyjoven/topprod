# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcq101.4gl
# Descriptions...: 每月在制结存导入作业
# Date & Author..: 17/03/27 by donghy

IMPORT os
DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
DEFINE g_tc_cch_m  RECORD  
       tc_cch01           LIKE tc_cch_file.tc_cch01,
       tc_cch02           LIKE tc_cch_file.tc_cch02
       END RECORD 
DEFINE g_tc_cch03_t       LIKE tc_cch_file.tc_cch03

DEFINE  g_tc_cch             DYNAMIC ARRAY OF RECORD  
           tc_cch03    LIKE tc_cch_file.tc_cch03,           
           ima02       LIKE ima_file.ima02,
           ima021      LIKE ima_file.ima021,
           tc_cch04    LIKE tc_cch_file.tc_cch04,
           ecd02       LIKE ecd_file.ecd02,
           tc_cch05    LIKE tc_cch_file.tc_cch05,
           ima02a      LIKE ima_file.ima02,
           ima021a     LIKE ima_file.ima021,
           tc_cch06    LIKE tc_cch_file.tc_cch06,
           tc_cch07    LIKE tc_cch_file.tc_cch07,
           tc_cch08    LIKE tc_cch_file.tc_cch08,
           tc_cch09    LIKE tc_cch_file.tc_cch09
                    END RECORD
      
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE str                   STRING
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 
DEFINE g_t1                  LIKE oay_file.oayslip
DEFINE g_rec_b               LIKE type_file.num5         
DEFINE l_ac                  LIKE type_file.num5 
DEFINE g_correct,g_sdate,g_edate LIKE tc_omc_file.tc_omc08
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_days                LIKE type_file.num5
DEFINE g_show                LIKE type_file.chr1
DEFINE g_change          LIKE type_file.chr1
MAIN
    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("CXC")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   CLEAR FORM 
   CALL g_tc_cch.clear()
    INITIALIZE g_tc_cch_m.* TO NULL     
 
    OPEN WINDOW q101_w WITH FORM "cxc/42f/cxcq101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊
   

   LET g_action_choice = ""
   CALL q101_menu()                                         #進入選單 Menu
 
   CLOSE WINDOW q101_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION q101_curs()

    CLEAR FORM
    CALL g_tc_cch.clear()
    CALL cl_set_head_visible("","YES")  
    INITIALIZE g_tc_cch_m.* TO NULL 


    INPUT BY NAME g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02 WITHOUT DEFAULTS
   	
      BEFORE INPUT
   #     CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlg       
         CALL cl_cmdask()    

      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE INPUT      

      ON ACTION about        
         CALL cl_about()     

      ON ACTION help         
         CALL cl_show_help() 

   END INPUT
   
   IF INT_FLAG THEN
      RETURN
   END IF
    CONSTRUCT BY NAME g_wc ON  tc_cch03,tc_cch04,tc_cch05
        
        BEFORE CONSTRUCT                                   
           CALL cl_qbe_init()                               
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_cch03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_cch03
                 NEXT FIELD tc_cch03 
              WHEN INFIELD(tc_cch04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecd3"
                 LET g_qryparam.state = "c"                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_cch04
                 NEXT FIELD tc_cch04 
              WHEN INFIELD(tc_cch05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_cch05
                 NEXT FIELD tc_cch05 
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT
    
  
    IF INT_FLAG THEN RETURN END IF
  
    CALL q101_cursor()
    
END FUNCTION

FUNCTION q101_cursor()
   LET g_sql=" SELECT DISTINCT tc_cch01,tc_cch02 FROM tc_cch_file ",
              " WHERE ",g_wc CLIPPED
   IF NOT cl_null(g_tc_cch_m.tc_cch01) THEN
     LET g_sql = g_sql," AND tc_cch01 = ",g_tc_cch_m.tc_cch01
   END IF
   IF NOT cl_null(g_tc_cch_m.tc_cch02) THEN
     LET g_sql = g_sql," AND tc_cch02 = ",g_tc_cch_m.tc_cch02
   END IF
    PREPARE q101_prepare FROM g_sql
    DECLARE q101_cs SCROLL CURSOR WITH HOLD FOR q101_prepare
    LET g_sql=" SELECT COUNT(*) ",
              "   FROM (",g_sql,")"
    PREPARE q101_precount FROM g_sql
    DECLARE q101_count CURSOR FOR q101_precount
END FUNCTION 

FUNCTION q101_menu()
    DEFINE l_cmd    STRING 

    WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
            
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q101_q()
            END IF
       
         WHEN "help" 
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()   
            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_tc_cch),'','')
            END IF 
      END CASE
    END WHILE
END FUNCTION

FUNCTION q101_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_cch_m.tc_cch01 TO NULL 
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM 
    CALL g_tc_cch.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q101_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN q101_count
    FETCH q101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q101_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_cch_m.tc_cch01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_cch_m.tc_cch01 TO NULL
    ELSE
        CALL q101_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


FUNCTION q101_fetch(p_flazb)
    DEFINE p_flazb         LIKE type_file.chr1
 
    CASE p_flazb
        WHEN 'N' FETCH NEXT     q101_cs INTO g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
        WHEN 'F' FETCH FIRST    q101_cs INTO g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
        WHEN 'L' FETCH LAST     q101_cs INTO g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    
 
                  ON ACTION generate_link
                     CALL cl_generate_shortcut()
 
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
            FETCH ABSOLUTE g_jump q101_cs INTO g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
            LET g_no_ask = FALSE   
        WHEN 'A'
             FETCH ABSOLUTE g_curs_index q101_cs INTO g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_cch_m.tc_cch01,SQLCA.sqlcode,0)
          INITIALIZE g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02 TO NULL 
          LET g_tc_cch_m.tc_cch01 = NULL      
        RETURN
    ELSE
      CASE p_flazb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE    
    END IF
    DISPLAY g_curs_index TO FORMONLY.cn1
    CALL q101_show()                   # 重新顯示
END FUNCTION

FUNCTION q101_show()
DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gen02_1  LIKE gen_file.gen02
   DEFINE l_azf03    LIKE azf_file.azf03
   
    SELECT DISTINCT tc_cch01,tc_cch02
    INTO  g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02
    FROM  tc_cch_file
    WHERE tc_cch01=g_tc_cch_m.tc_cch01 AND tc_cch02 = g_tc_cch_m.tc_cch02
     
    
    DISPLAY BY NAME g_tc_cch_m.tc_cch01,g_tc_cch_m.tc_cch02


    CALL q101_b_fill(g_wc)
    
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q101_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc  LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
DEFINE l_i   LIKE type_file.num5

    IF cl_null(g_wc) THEN
       LET g_wc = "1=1"
    END IF
    LET g_sql = " SELECT DISTINCT tc_cch03,ima02,ima021,tc_cch04,'',tc_cch05,'','', ",
                " tc_cch06,tc_cch07,tc_cch08,tc_cch09 ",
                " FROM tc_cch_file,ima_file ",
                " WHERE tc_cch03 = ima01 ",
                " AND ",g_wc CLIPPED
    IF NOT cl_null(g_tc_cch_m.tc_cch01) THEN
       LET g_sql = g_sql," AND tc_cch01 = ",g_tc_cch_m.tc_cch01
    END IF
    IF NOT cl_null(g_tc_cch_m.tc_cch02) THEN
       LET g_sql = g_sql," AND tc_cch02 = ",g_tc_cch_m.tc_cch02
    END IF 
    LET g_sql = g_sql," ORDER BY tc_cch03,tc_cch04,tc_cch05"
    PREPARE q101_prepare2 FROM g_sql      
    DECLARE tc_cch_cs CURSOR FOR q101_prepare2
    CALL g_tc_cch.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH tc_cch_cs INTO g_tc_cch[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        SELECT ecd02 INTO g_tc_cch[g_cnt].ecd02 FROM ecd_file WHERE ecd01=g_tc_cch[g_cnt].tc_cch04
        SELECT ima02,ima021 INTO g_tc_cch[g_cnt].ima02a,g_tc_cch[g_cnt].ima021a FROM ima_file
          WHERE ima01=g_tc_cch[g_cnt].tc_cch05
        LET g_cnt = g_cnt + 1
    END FOREACH

        CALL g_tc_cch.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1  
        DISPLAY g_rec_b TO FORMONLY.cn2   
END FUNCTION


FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
   DEFINE   l_date_str STRING 
   DEFINE   l_i    LIKE type_file.num5
   DEFINE   l_i_str STRING

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_tc_cch TO s_tc_cch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION first 
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	     ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	     ACCEPT DISPLAY              
 
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	     ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL q101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
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
          CALL cl_show_fld_cont()   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY 

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION ACCEPT 
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
         
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

