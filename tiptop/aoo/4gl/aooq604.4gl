# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aooq604.4gl
# Descriptions...: 資料拋轉歷史查詢
# Date & Author..: 07/12/16 By Carrier FUN-7C0010
# Modify.........: FUN-830090 08/03/25 By Carrier gex03,gex04移至單頭
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/10/12 By 資料中心修改
 
DATABASE ds
 
GLOBALS "../../config/top.global" #FUN-7C0010
 
#模組變數(Module Variables)
DEFINE 
    tm           RECORD
       	        # wc   LIKE type_file.chr1000
       	         wc  STRING     #NO.FUN-910082
                 END RECORD,
    g_gex01      LIKE gex_file.gex01,
    g_geu02      LIKE geu_file.geu02,
    g_gex02      LIKE gex_file.gex02,
    g_gex03      LIKE gex_file.gex03,  #No.FUN-830090
    g_azp02      LIKE azp_file.azp02,  #No.FUN-830090
    g_gex04      LIKE gex_file.gex04,  #No.FUN-830090
    g_gex        DYNAMIC ARRAY OF RECORD
                 gex05   LIKE gex_file.gex05,
                 gex06   LIKE gex_file.gex06,
                 gex07   LIKE gex_file.gex07,
                 gex08   LIKE gex_file.gex08,
                 gex09   LIKE gex_file.gex09,
                 gen02   LIKE gen_file.gen02
                 END RECORD,
    g_argv1      LIKE gex_file.gex01,
    g_argv2      LIKE gex_file.gex02,
    g_argv3      LIKE gex_file.gex04,
    g_argv4      LIKE gex_file.gex05,
    g_sql        STRING,
    g_sql_tmp    STRING,
    g_rec_b      LIKE type_file.num10        #單身筆數  
 
DEFINE g_cnt          LIKE type_file.num10 
DEFINE l_n            LIKE type_file.num10   #No.FUN-980025 
DEFINE g_i            LIKE type_file.num5
DEFINE g_msg          LIKE ze_file.ze03  
DEFINE g_row_count    LIKE type_file.num10 
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5 
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   LET g_argv1      = ARG_VAL(1)
   LET g_argv2      = ARG_VAL(2)
   LET g_argv3      = ARG_VAL(3)
   LET g_argv4      = ARG_VAL(4)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW q604_w AT p_row,p_col
        WITH FORM "aoo/42f/aooq604"  
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q604_q() END IF
   CALL q604_menu()
   CLOSE WINDOW q604_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   
END MAIN
 
#QBE 查詢資料
FUNCTION q604_cs()
   DEFINE   l_cnt LIKE type_file.num5 
 
   IF g_argv1 != ' ' THEN
      LET tm.wc = "gex01 = '",g_argv1,"' AND ","gex02 = '",g_argv2,"'"
      IF NOT cl_null(g_argv3) THEN
         LET tm.wc = tm.wc CLIPPED," AND gex04 = '",g_argv3,"'"
      END IF
      IF NOT cl_null(g_argv4) THEN
         LET tm.wc = tm.wc CLIPPED," AND (gex05 = '",g_argv4,"' OR gex05 MATCHES '",g_argv4,"+*')"
      END IF
   ELSE
      CLEAR FORM #清除畫面
      CALL g_gex.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                   # Default condition
      CONSTRUCT tm.wc ON gex01,gex02,gex03,gex04,gex05,gex06,
                         gex07,gex08,gex09
           FROM gex01,gex02,gex03,gex04,s_gex[1].gex05,
                s_gex[1].gex06,s_gex[1].gex07,s_gex[1].gex08,s_gex[1].gex09
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
    
         ON ACTION CONTROLP                                                                                                              
            CASE                                                                                                                      
               WHEN INFIELD(gex01)                                                                                                    
                  CALL cl_init_qry_var()                                                                                              
                  LET g_qryparam.state = "c"                                                                                             
                  LET g_qryparam.form ="q_geu"                                                                                        
                  LET g_qryparam.arg1 ="1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gex01            
               WHEN INFIELD(gex03)                                                                                                    
                  CALL cl_init_qry_var()                                                                                              
                  LET g_qryparam.state = "c"                                                                                             
                  LET g_qryparam.form ="q_azp"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gex03           
               WHEN INFIELD(gex04)                                                                                                    
                  CALL cl_init_qry_var()                                                                                              
                  LET g_qryparam.state = "c"                                                                                             
                  LET g_qryparam.form ="q_zz"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gex04           
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT ' 
 
   LET g_sql=" SELECT UNIQUE gex01,gex02,gex03,gex04 ",
             "   FROM gex_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY gex01,gex02"
   PREPARE q604_prepare FROM g_sql
   DECLARE q604_cs SCROLL CURSOR FOR q604_prepare
 
   # 取合乎條件筆數
   LET g_sql_tmp=" SELECT UNIQUE gex01,gex02,gex03,gex04 FROM gex_file ",
                 "  WHERE ",tm.wc CLIPPED,
                 "   INTO TEMP x"
   DROP TABLE x
   PREPARE q604_pp1 FROM g_sql_tmp
   EXECUTE q604_pp1
   
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE q604_pp FROM g_sql
   DECLARE q604_cnt CURSOR FOR q604_pp
   
END FUNCTION
 
FUNCTION q604_menu()
 
   WHILE TRUE
      CALL q604_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q604_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gex),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q604_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q604_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q604_cs  
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q604_cnt
       FETCH q604_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL q604_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q604_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  
    l_abso          LIKE type_file.num10                 #絕對的筆數 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q604_cs INTO g_gex01,g_gex02,g_gex03,g_gex04
        WHEN 'P' FETCH PREVIOUS q604_cs INTO g_gex01,g_gex02,g_gex03,g_gex04
        WHEN 'F' FETCH FIRST    q604_cs INTO g_gex01,g_gex02,g_gex03,g_gex04
        WHEN 'L' FETCH LAST     q604_cs INTO g_gex01,g_gex02,g_gex03,g_gex04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q604_cs INTO g_gex01,g_gex02,g_gex03,g_gex04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gex01,SQLCA.sqlcode,0)
        INITIALIZE g_gex01 TO NULL
        INITIALIZE g_gex02 TO NULL
        INITIALIZE g_gex03 TO NULL
        INITIALIZE g_gex04 TO NULL
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
 
    CALL q604_show()
END FUNCTION
 
FUNCTION q604_show()
   DEFINE l_geu02 LIKE geu_file.geu02
   DEFINE l_azp02 LIKE azp_file.azp02
  ##NO.FUN-980025 GP5.2 add--begin
   DEFINE l_azw06 LIKE azw_file.azw06
   DEFINE l_azw01 LIKE azw_file.azw01
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_str   string
  ##NO.FUN-980025 GP5.2 add--end
 
   DISPLAY g_gex01 TO gex01
   DISPLAY g_gex02 TO gex02
   DISPLAY g_gex03 TO gex03
   DISPLAY g_gex04 TO gex04
   SELECT geu02 INTO g_geu02 FROM geu_file WHERE geu01 = g_gex01
   SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01 = g_gex03
  ##NO.FUN-980025 GP5.2 add--begin
   SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = g_gex01
   SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw06 = l_azw06 
   SELECT count(azw01) INTO l_n FROM azw_file WHERE azw06 = l_azw06
   IF l_n >= 1 THEN 
     LET g_sql = "SELECT azw01 FROM azw_file WHERE azw06 = '",l_azw06,"' " 
     PREPARE q604_pb1 FROM g_sql 
     DECLARE azw_curs CURSOR FOR q604_pb1
     LET l_str = ' '
     FOREACH azw_curs INTO l_azw01
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF           
       IF l_azw01 is NULL THEN
          CONTINUE FOREACH
       END IF
       IF l_str = ' ' THEN 
          LET l_str = l_str,l_azw01
          LET l_str = l_str.trim()
       ELSE 
          LET l_str = l_str,",",l_azw01 
          LET l_str = l_str.trim()
       END IF   
     END FOREACH
   END IF  
   DISPLAY l_str TO formonly.plant
  ##NO.FUN-980025 GP5.2 add--end
  ##NO.FUN-980025 GP5.2 add--begin	
   SELECT COUNT(*) INTO l_n FROM azw_file 
    WHERE azw05 <> azw06 
   IF l_n < 1  THEN
     CALL cl_set_comp_visible("plant",FALSE)
   ELSE 
     CALL cl_set_comp_visible("plant",TRUE)
   END IF   
  ##NO.FUN-980025 GP5.2 add--end
   DISPLAY g_geu02 TO geu02
   DISPLAY g_azp02 TO azp02
   CALL q604_b_fill() #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION q604_b_fill()              #BODY FILL UP
   DEFINE #l_sql           LIKE type_file.chr1000, 
          l_sql          STRING,      #NO.FUN-910082
          g_gen02         LIKE gen_file.gen02,
          g_abaconf       LIKE aba_file.aba19,
          g_abauser       LIKE aba_file.abauser 
 
   IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF
   LET l_sql ="SELECT gex05,gex06,gex07,gex08,gex09,'' ", 
              "  FROM gex_file ",
              " WHERE gex01 ='",g_gex01,"' AND gex02= '",g_gex02,"'",
              "   AND gex03 ='",g_gex03,"' AND gex04= '",g_gex04,"'",
              "   AND ",tm.wc CLIPPED,
              " ORDER BY gex07,gex05"
 
    PREPARE q604_pb FROM l_sql
    DECLARE q604_bcs CURSOR WITH HOLD FOR q604_pb
 
    CALL g_gex.clear()
    LET g_cnt = 1
    FOREACH q604_bcs INTO g_gex[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT gen02 INTO g_gex[g_cnt].gen02 FROM gen_file
         WHERE gen01 = g_gex[g_cnt].gex09
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q604_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gex TO s_gex.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(g_argv1) THEN
            CALL cl_set_act_visible("query",FALSE)
         END IF
         CALL cl_show_fld_cont() 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION first 
         CALL q604_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
                              
 
      ON ACTION previous
         CALL q604_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY
                             
      ON ACTION jump
         CALL q604_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY
                              
      ON ACTION next
         CALL q604_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY
                              
      ON ACTION last
         CALL q604_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
