# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axcq312
# Descriptions...: 每月工單人工制費查詢作業(依工單）
# Date & Author..: No.FUN-920013 2009/02/05 By jan
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0118 09/12/02 By Carrier add cdc00/cdc11
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       #g_wc     LIKE type_file.chr1000,
       g_wc         STRING,  
       g_cdc01  LIKE cdc_file.cdc01,               #年度
       g_cdc02  LIKE cdc_file.cdc02,               #月份
       g_cdc00  LIKE cdc_file.cdc00,               #帐套         #No.FUN-9B0118
       g_cdc11  LIKE cdc_file.cdc11,               #成本计算类型 #No.FUN-9B0118
       g_cdc041  LIKE cdc_file.cdc041,             #工單編號 
       g_cdc    DYNAMIC ARRAY OF RECORD
                 cdc03  LIKE cdc_file.cdc03,       #成本中心
                 cdc04  LIKE cdc_file.cdc04,       #成本項目       
                 cdc08  LIKE cdc_file.cdc08,       #分攤方式             
                 cdc05  LIKE cdc_file.cdc05,       #成本       
                 cdc06  LIKE cdc_file.cdc06,       #成本       
                 cdc07  LIKE cdc_file.cdc07        #單位成本            
                END RECORD,
       g_tot_cdc05     LIKE cdc_file.cdc05,        #總成本 
       g_tot_cdc06     LIKE cdc_file.cdc06,        #總分攤數 
       g_query_flag    LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入N.下筆
       g_sql           STRING,                     #WHERE CONDITION 
       g_rec_b         LIKE type_file.num5         #單身筆數
DEFINE p_row,p_col     LIKE type_file.num5       
DEFINE g_cnt           LIKE type_file.num10     
DEFINE g_msg           LIKE type_file.chr1000  
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10     
DEFINE g_jump          LIKE type_file.num10    
DEFINE g_no_ask        LIKE type_file.num5      
DEFINE l_ac            LIKE type_file.num5      
DEFINE g_argv1         LIKE cdc_file.cdc01         #年度
DEFINE g_argv2         LIKE cdc_file.cdc02         #月份
DEFINE g_argv3         LIKE cdc_file.cdc00         #帐别             #No.FUN-9B0118
DEFINE g_argv4         LIKE cdc_file.cdc11         #成本计算类型     #No.FUN-9B0118
 
 
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (開始時間) 
 
    LET g_query_flag = 1
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    #No.FUN-9B0118  --Begin
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
    #No.FUN-9B0118  --End  
    LET p_row = 3 LET p_col = 15
 
    OPEN WINDOW q312_w AT p_row,p_col WITH FORM "axc/42f/axcq312"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL q312_q()
    END IF
 
    CALL q312_menu()
    CLOSE WINDOW q312_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) 
END MAIN
 
#QBE 查詢資料
FUNCTION q312_cs()
   DEFINE   l_cnt   LIKE type_file.num5     
 
   LET g_wc = ''
   IF g_argv1 != ' ' THEN
      LET g_wc = " cdc01 = '",g_argv1,"' AND ",  
                 " cdc02 = '",g_argv2,"'"       
      #No.FUN-9B0118  --Begin
      IF NOT cl_null(g_argv3) THEN
         LET g_wc = g_wc CLIPPED," AND cdc00 = '",g_argv3,"'"
      END IF
      IF NOT cl_null(g_argv4) THEN
         LET g_wc = g_wc CLIPPED," AND cdc11 = '",g_argv4,"'"
      END IF
      #No.FUN-9B0118  --End
   ELSE 
      CLEAR FORM #清除畫面
      CALL g_cdc.clear() 
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")  
 
      INITIALIZE g_cdc01 TO NULL    
      INITIALIZE g_cdc02 TO NULL   
      INITIALIZE g_cdc041 TO NULL  
 
      CONSTRUCT g_wc ON cdc11,cdc00,cdc01,cdc02,cdc041,cdc03,cdc04,cdc08,cdc05,cdc06,cdc07   # 螢幕上取單頭條件  #No.FUN-9B0118
           FROM cdc11,cdc00,cdc01,cdc02,cdc041,   #No.FUN-9B0118
                s_cdc[1].cdc03,s_cdc[1].cdc04,s_cdc[1].cdc08,
                s_cdc[1].cdc05,s_cdc[1].cdc06,s_cdc[1].cdc07
         
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
        ON ACTION CONTROLP                                                         
           CASE                                                                    
              WHEN INFIELD(cdc041)                                                 
                 CALL cl_init_qry_var()                                              
                 LET g_qryparam.form = "q_sfb"                                       
                 LET g_qryparam.state = "c"                                          
                 LET g_qryparam.default1 = g_cdc041                               
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                  
                 DISPLAY g_qryparam.multiret TO cdc041                                
                 NEXT FIELD cdc041 
              #No.FUN-9B0118  --Begin
              WHEN INFIELD(cdc00)       #帐套
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cdc00
                 NEXT FIELD cdc00
              #No.FUN-9B0118  --End  
              OTHERWISE                                                              
                 EXIT CASE                                                           
           END CASE                                                                 
 
         ON ACTION qbe_select
            CALL cl_qbe_select() 
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT        
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cdcuser', 'cdcgrup') #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF
   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
   LET g_sql="SELECT UNIQUE cdc11,cdc00,cdc01,cdc02,cdc041 FROM cdc_file ",     #No.FUN-9B0118
             " WHERE ",g_wc CLIPPED ,
             " ORDER BY cdc11,cdc00,cdc01,cdc02,cdc041"                         #No.FUN-9B0118
   PREPARE q312_prepare FROM g_sql
   DECLARE q312_cs SCROLL CURSOR FOR q312_prepare   #SCROLL CURSOR
 
   #取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT UNIQUE cdc11,cdc00,cdc01,cdc02,cdc041 FROM cdc_file ",     #No.FUN-9B0118
             " WHERE ",g_wc CLIPPED ,
             "  INTO TEMP x"
   DROP TABLE x
   PREPARE q312_precount_x FROM g_sql
   EXECUTE q312_precount_x
   
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE q312_pp FROM g_sql
   DECLARE q312_cnt CURSOR FOR q312_pp
END FUNCTION
 
FUNCTION q312_menu()
   WHILE TRUE
      CALL q312_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q312_q()
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL q312_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()       
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q312_q()
   LET g_row_count = 0                                                        
   LET g_curs_index = 0                                                       
   CALL cl_navigator_setting( g_curs_index, g_row_count )                    
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
   CALL q312_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q312_cs                              # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q312_cnt
      FETCH q312_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
      CALL q312_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q312_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1      #處理方式
DEFINE l_abso   LIKE type_file.num5      #絕對的筆數
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q312_cs INTO g_cdc11,g_cdc00,g_cdc01,g_cdc02,g_cdc041   #No.FUN-9B0118
      WHEN 'P' FETCH PREVIOUS q312_cs INTO g_cdc11,g_cdc00,g_cdc01,g_cdc02,g_cdc041   #No.FUN-9B0118
      WHEN 'F' FETCH FIRST    q312_cs INTO g_cdc11,g_cdc00,g_cdc01,g_cdc02,g_cdc041   #No.FUN-9B0118
      WHEN 'L' FETCH LAST     q312_cs INTO g_cdc11,g_cdc00,g_cdc01,g_cdc02,g_cdc041   #No.FUN-9B0118
      WHEN '/'
         IF (NOT g_no_ask) THEN
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
         FETCH ABSOLUTE g_jump q312_cs INTO g_cdc11,g_cdc00,g_cdc01,g_cdc02,g_cdc041  #No.FUN-9B0118
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdc01,SQLCA.sqlcode,0)
      INITIALIZE g_cdc01 TO NULL  
      INITIALIZE g_cdc02 TO NULL  
      INITIALIZE g_cdc041 TO NULL  
      #No.FUN-9B0118  --Begin
      INITIALIZE g_cdc00 TO NULL  
      INITIALIZE g_cdc11 TO NULL  
      #No.FUN-9B0118  --End  
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
   CALL q312_show()
END FUNCTION
 
FUNCTION q312_show()
   DISPLAY g_cdc01 TO cdc01   #ATTRIBUTE(YELLOW)  # 顯示單頭值 
   DISPLAY g_cdc02 TO cdc02   #ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_cdc041 TO cdc041   #ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_cdc11 TO cdc11   #No.FUN-9B0118
   DISPLAY g_cdc00 TO cdc00   #No.FUN-9B0118
   CALL q312_b_fill() #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION q312_b_fill()                  #BODY FILL UP
   DEFINE #l_sql     LIKE type_file.chr1000 
          l_sql    STRING     #NO.FUN-910082
#DEFINE l_tot     LIKE  ima_file.ima26    #No.FUN-A20044  
 DEFINE l_tot     LIKE  type_file.num15_3 #No.FUN-A20044  
 
   LET l_sql="SELECT cdc03,cdc04,cdc08,cdc05,cdc06,cdc07 ",
             "  FROM cdc_file ",
             " WHERE cdc01 = ",g_cdc01,
             "   AND cdc02 = ",g_cdc02,
             "   AND cdc041 ='",g_cdc041,"'",
#            "   AND cdc00 = '",g_cdc00,"'",   #No.FUN-9B0118
             "   AND cdc11 = '",g_cdc11,"'",   #No.FUN-9B0118
             "   AND ",g_wc CLIPPED,
             " ORDER BY cdc03"
   PREPARE q312_pb FROM l_sql
   DECLARE q312_bcs CURSOR FOR q312_pb     #BODY CURSOR
 
   CALL g_cdc.clear() 
   LET g_rec_b= 0
   LET g_cnt  = 1
   FOREACH q312_bcs INTO g_cdc[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_cdc.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
 
#   LET l_sql="SELECT SUM(cdc05) ",
#             "  FROM cdc_file ",
#             " WHERE cdc01 = ",g_cdc01,
#             "   AND cdc02 = ",g_cdc02,
#             "   AND cdc041 ='",g_cdc041,"'",
#             "   AND cdc06 ='",g_cdc06,"'"
#   PREPARE q312_tot_p FROM l_sql
#   DECLARE q312_tot_c CURSOR FOR q312_tot_p
#   OPEN q312_tot_c
#   FETCH q312_tot_c INTO g_tot_cdc05
#   DISPLAY g_tot_cdc05 TO FORMONLY.tot_cdc05
   LET l_sql="SELECT SUM(cdc06),SUM(cdc05) ",
             "  FROM cdc_file ",
             " WHERE cdc01 = ",g_cdc01,
             "   AND cdc02 = ",g_cdc02,
             "   AND cdc041 ='",g_cdc041,"'",
#            "   AND cdc00 = '",g_cdc00,"'",   #No.FUN-9B0118
             "   AND cdc11 = '",g_cdc11,"'"    #No.FUN-9B0118
   PREPARE q312_tot_p1 FROM l_sql
   DECLARE q312_tot_c1 CURSOR FOR q312_tot_p1
   OPEN q312_tot_c1
   FETCH q312_tot_c1 INTO g_tot_cdc06,g_tot_cdc05
   DISPLAY g_tot_cdc06 TO FORMONLY.tot_cdc06
   DISPLAY g_tot_cdc05 TO FORMONLY.tot_cdc05
 
END FUNCTION
 
FUNCTION q312_bp(p_ud)
DEFINE p_ud     LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cdc TO s_cdc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()          
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY
      ON ACTION first 
         CALL q312_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           
      ON ACTION previous
         CALL q312_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY             
      ON ACTION jump 
         CALL q312_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
      ON ACTION next
         CALL q312_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 
      ON ACTION last
         CALL q312_fetch('L')
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
      ON ACTION accept
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
      ON ACTION controls   
         CALL cl_set_head_visible("","AUTO")     
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#str FUN-7C0028 add
FUNCTION q312_out()
DEFINE l_wc         STRING                        #No.FUN-9B0118
DEFINE l_cmd        STRING                        #No.FUN-9B0118

    #No.FUN-9B0118  --Begin
    LET l_wc  = g_wc 
    IF cl_null(g_wc) AND NOT cl_null(g_cdc01)
                     AND NOT cl_null(g_cdc02)
                     AND NOT cl_null(g_cdc041)
                     AND NOT cl_null(g_cdc11) THEN
       LET g_wc="     cdc01 = '",g_cdc01 ,"'",
                " AND cdc02 = '",g_cdc02 ,"'",
                " AND cdc041= '",g_cdc041,"'",
                " AND cdc11 = '",g_cdc11 ,"'"
    END IF
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "axcq312" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    LET g_wc  = l_wc   
    #No.FUN-9B0118  --End  

#No.FUN-9B0118  --Begin
#  DEFINE #l_sql  LIKE type_file.chr1000
#        l_sql    STRING     #NO.FUN-910082
#  DEFINE 
#       #l_wc   LIKE type_file.chr1000
#        l_wc         STRING       #NO.FUN-910082
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#
#  LET l_wc = " cdc01 = ",g_cdc01," AND ",
#             " cdc02 = ",g_cdc02," AND ",
#             " cdc041 ='",g_cdc041,"' AND ",g_wc CLIPPED  
#
#  LET l_sql="SELECT cdc01,cdc02,cdc03,cdc04,cdc041,cdc05,cdc06,cdc07,cdc08",
#            "  FROM cdc_file ",
#            " WHERE ",l_wc CLIPPED
#
# #列印選擇條件
# IF g_zz05 = 'Y' THEN
#    CALL cl_wcchp(l_wc,'cdc01,cdc02,cdc03,cdc04,cdc041,cdc08,cdc05,cdc06,cdc07')
#         RETURNING l_wc
# ELSE
#    LET l_wc = ''
# END IF
# LET l_wc = l_wc,";",g_tot_cdc06
# CALL cl_prt_cs1('axcq312','axcq312',l_sql,l_wc)                                                                                   
#                                                                                                                                   
# ERROR ""                                                                                                                          
# RETURN                                                                                                                            
#No.FUN-9B0118  --End  
END FUNCTION                                                                                                                        
#FUN-920013
