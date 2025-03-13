# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsq200.4gl
# Descriptions...: APS各類訊息明細表
# Date & Author..: 2008/04/23 By rainy #FUN-840156
# Modify.........: No.FUN-840209 By duke 每五分鐘refresh 一次
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: NO.TQC-940098 09/04/17 BY destiny 1.將嵌套sql改臨時表的形式                                                      
#                                                    2.vzv03定義成DATETIME YEAR TO SECOND于數據庫中長度不符,在msv環境下執行時會報錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-B50050 11/05/11 By Mandy APS GP5.25 追版---str---
# Modify.........: No.TQC-950078 09/05/13 By Duke 訊息接收時間應show到時分秒
# Modify.........: No:FUN-B50050 11/05/11 By Mandy ------------------end---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc          STRING,     #NO.FUN-910082 
        	wc2         STRING     #NO.FUN-910082  
        END RECORD,
    g_vzv01 LIKE vzv_file.vzv01,
    g_vzv02 LIKE vzv_file.vzv01,
    g_vdate LIKE type_file.dat,   
    g_rec_b LIKE type_file.num5,          
    g_vzv DYNAMIC ARRAY OF RECORD
           #vzv03   LIKE type_file.dat,        #No.TQC-940098 #TQC-950078 mark  
            vzv03   LIKE type_file.chr20,                     #TQC-950078 add
            vzv04   LIKE vzv_file.vzv04,
            vzv05   LIKE vzv_file.vzv05,
            vzv06   LIKE vzv_file.vzv06,
            vzv07   LIKE vzv_file.vzv07,
            vzv08   LIKE vzv_file.vzv08
        END RECORD,
    g_argv1         LIKE vzv_file.vzv01,      # INPUT ARGUMENT - 1
    g_argv2         LIKE vzv_file.vzv02,      # INPUT ARGUMENT - 2
    g_sql           string                   
DEFINE   p_row         LIKE type_file.num5    
DEFINE   p_col         LIKE type_file.num5    
DEFINE   g_cnt         LIKE type_file.num10   
DEFINE   g_msg         LIKE ze_file.ze03      
DEFINE   g_row_count   LIKE type_file.num10   
DEFINE   g_curs_index  LIKE type_file.num10   
DEFINE   g_jump        LIKE type_file.num10   
DEFINE   mi_no_ask     LIKE type_file.num5    
DEFINE   lc_qbe_sn     LIKE gbm_file.gbm01    
DEFINE   g_seq         LIKE type_file.num5    
DEFINE   g_aps_run     LIKE type_file.chr1
DEFINE   g_temp        STRING                  #No.TQC-940098
 
MAIN
      DEFINE  
          l_sl	       LIKE type_file.num5    
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q200_w AT p_row,p_col WITH FORM "aps/42f/apsq200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL q200("N",g_argv1,g_argv2) #FUN-840209
 
    CLOSE WINDOW q200_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q200(p0,p1,p2)
DEFINE  p0         LIKE type_file.chr1,
        p1         LIKE vzv_file.vzv01,
        p2         LIKE vzv_file.vzv02
 
   WHENEVER ERROR CONTINUE
   LET g_aps_run=p0
   LET g_argv1=p1
   LET g_argv2=p2
 
   IF cl_null(p1) THEN
      CALL q200_defqbe()
   END IF
   CALL q200_q()
 
   WHILE TRUE
     LET g_action_choice = NULL
     CALL q200_menu()
     IF g_action_choice = "exit" THEN
        EXIT WHILE
     END IF
  END WHILE
END FUNCTION
 
FUNCTION q200_defqbe()
  DEFINE l_vzv01  LIKE vzv_file.vzv01,
         l_vzv02  LIKE vzv_file.vzv02
  
  SELECT UNIQUE vzv01,vzv02 INTO l_vzv01,l_vzv02
    FROM vzv_file
   WHERE vzv00 = g_plant
     AND vzv07 = 'N'
     AND vzv08 = '2'
  IF SQLCA.sqlcode = 100 THEN
     SELECT UNIQUE vzv01,vzv02 INTO l_vzv01,l_vzv02
       FROM vzv_file
      WHERE vzv00 = g_plant
        AND vzv06 = (SELECT MAX(vzv06) FROM vzv_file
                      WHERE vzv00 = g_plant)
     IF SQLCA.sqlcode = 100 THEN
       LET g_argv1 = NULL
       LET g_argv2 = NULL
     ELSE
       LET g_argv1 = l_vzv01
       LET g_argv2 = l_vzv02
     END IF
  ELSE
    LET g_argv1 = l_vzv01
    LET g_argv2 = l_vzv02
  END IF
END FUNCTION
 
FUNCTION q200_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          
 
    IF g_action_choice = 'idle' THEN
 
         LET tm.wc = " vzv01 = '",g_vzv01,"'",
                 " AND vzv02 = '",g_vzv02,"'"
 
     LET tm.wc2=" 1=1 "
 
         LET g_sql = " SELECT UNIQUE vzv01,vzv02 FROM vzv_file",
                 "  WHERE ",tm.wc  CLIPPED,
                 "    AND ",tm.wc2 CLIPPED,
                 "    AND vzv00 = '",g_plant,"'"
 
   ELSE
      CLEAR FORM                       # 清除畫面
      CALL g_vzv.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     
 
      LET g_vzv01 = NULL
      LET g_vzv02 = NULL
      CONSTRUCT BY NAME tm.wc ON vzv01,vzv02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION CONTROLP
        IF INFIELD(vzv01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_vzv01"
             CALL cl_create_qry() RETURNING g_vzv01,g_vzv02     #FUN-840209
             DISPLAY g_vzv01 TO vzv01                           #FUN-840209
             DISPLAY g_vzv02 TO vzv02                           #FUN-840209 
 
           NEXT FIELD vzv01
        END IF
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")     
 
      CALL q200_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING '
   LET g_sql = " SELECT UNIQUE vzv01,vzv02 FROM vzv_file", 
               "  WHERE ",tm.wc  CLIPPED,
               "    AND ",tm.wc2 CLIPPED,
               "    AND vzv00 = '",g_plant,"'"
 
   LET g_sql = g_sql clipped," ORDER BY vzv01 "
   PREPARE q200_prepare FROM g_sql
   DECLARE q200_cs SCROLL CURSOR FOR q200_prepare
 
   LET g_temp = " SELECT distinct vzv01,vzv02 ",                                                                                    
                " FROM vzv_file ",                                                                                                  
                " WHERE ",tm.wc  CLIPPED,                                                                                           
                "   AND ",tm.wc2 CLIPPED,                                                                                           
                "   AND vzv00 = '",g_plant,"' ",                                                                                    
                " INTO TEMP x"                                                                                                      
   DROP TABLE x                                                                                                                     
   PREPARE q200_pre_x FROM g_temp                                                                                                   
   EXECUTE q200_pre_x                                                                                                               
   LET g_sql  = " SELECT COUNT(*) FROM x "                                                                                          
 
   PREPARE q200_pp FROM g_sql
   DECLARE q200_cnt CURSOR FOR q200_pp
END FUNCTION
 
 
FUNCTION q200_b_askkey()
  #TQC-950078 MOD --STR-----------------------------------
  #CONSTRUCT tm.wc2 ON vzv03,vzv04,vzv05,vzv06,vzv07,vzv08
  #               FROM s_vzv[1].vzv03,s_vzv[1].vzv04,
  #                    s_vzv[1].vzv05,s_vzv[1].vzv06,
  #                    s_vzv[1].vzv07,s_vzv[1].vzv08
   CONSTRUCT tm.wc2 ON vzv04,vzv05,vzv06,vzv07,vzv08
                  FROM s_vzv[1].vzv04,
                       s_vzv[1].vzv05,s_vzv[1].vzv06,
                       s_vzv[1].vzv07,s_vzv[1].vzv08
  #TQC-950078 MOD --END-----------------------------------
                       
      BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
END FUNCTION
 
FUNCTION q200_menu()
 
   WHILE TRUE
      CALL q200_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q200_q()
         WHEN "jump"
            CALL q200_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q200_fetch('N')
         WHEN "previous"
            CALL q200_fetch('P')
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vzv),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q200_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q200_cnt
       FETCH q200_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q200_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q200_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q200_cs INTO g_vzv01,g_vzv02
        WHEN 'P' FETCH PREVIOUS q200_cs INTO g_vzv01,g_vzv02
        WHEN 'F' FETCH FIRST    q200_cs INTO g_vzv01,g_vzv02
        WHEN 'L' FETCH LAST     q200_cs INTO g_vzv01,g_vzv02
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q200_cs INTO g_vzv01,g_vzv02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vzv01,SQLCA.sqlcode,0)
        LET g_vzv01 = NULL
        LET g_vzv02 = NULL
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
    END IF
    SELECT UNIQUE vzv01,vzv02
      INTO g_vzv01,g_vzv02
      FROM vzv_file 
     WHERE vzv01 = g_vzv01
       AND vzv02 = g_vzv02
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vzv_file",g_vzv01,g_vzv02,SQLCA.sqlcode,"","",1)    
        RETURN
    END IF
    CALL q200_show()
END FUNCTION
 
FUNCTION q200_show()
   DISPLAY g_vzv01 TO vzv01
   DISPLAY g_vzv02 TO vzv02
 
   CALL q200_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION q200_b_fill()              #BODY FILL UP
   DEFINE i	   LIKE type_file.num5          
   DEFINE l_sql1   STRING  #FUN-B50050 add
 
   #FUN-B50050------mod----str----
   #LET g_sql=" SELECT vzv03,vzv04,vzv05,vzv06,vzv07,vzv08 ", #TQC-950078
   #LET g_sql=" SELECT TO_CHAR(vzv03,'yyyy/mm/dd HH24:MI:SS') vzv03,vzv04,vzv05,vzv06,vzv07,vzv08 ", #TQC-950078 ADD
    LET l_sql1 = cl_tp_tochar('vzv03','yyyy/mm/dd HH24:MI:SS')
    LET g_sql = "SELECT ",l_sql1 CLIPPED," vzv03,vzv04,vzv05,vzv06,vzv07,vzv08 ",
   #FUN-B50050------mod----end----
              "   FROM vzv_file ",
              "  WHERE vzv01 = '",g_vzv01,"'",
              "    AND vzv02 = '",g_vzv02,"'",
              "    AND vzv00 = '",g_plant,"'",
              "  ORDER BY vzv03 "
    
    PREPARE q200_pre_bcs FROM g_sql
    DECLARE q200_bcs CURSOR FOR q200_pre_bcs
    CALL g_vzv.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q200_bcs INTO g_vzv[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
       END IF
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_vzv.deleteElement(g_cnt)       
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vzv TO s_vzv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL q200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL q200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")  
 
      ON IDLE 5
         LET g_action_choice = 'idle'
         CALL q200_q()
         EXIT DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-9C0072 精簡程式碼
