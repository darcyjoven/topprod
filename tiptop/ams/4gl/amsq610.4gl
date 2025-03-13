# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amsq610.4gl
# Desc/riptions..: 資源秏用明細查詢
# Date & Author..: 00/08/04 By Carol
# Modify.........: No.FUN-4B0014 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
#
 # Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770033 07/07/10 By wujie  匯出EXCEL,多出一行空白行
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rqb     DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rqb062    LIKE rqb_file.rqb062,
		    rqb05     LIKE rqb_file.rqb05,
		    t5_name   LIKE type_file.chr8,     #NO.FUN-680101 VARCHAR(08)  
		    rqb06     LIKE rqb_file.rqb06,
		    rqb061    LIKE rqb_file.rqb061,
		    rqb065    LIKE rqb_file.rqb065,
		    rqb063    LIKE rqb_file.rqb063,
		    rqb064    LIKE rqb_file.rqb064,
		    rqb08     LIKE rqb_file.rqb08,
		    rqb09     LIKE rqb_file.rqb09
                    END RECORD,
       g_argv1        LIKE rqa_file.rqa01,
       g_argv2        LIKE rqa_file.rqa02,
       g_argv3        LIKE rqa_file.rqa03,
       g_argv4        LIKE rqa_file.rqa04,
       g_rqa01        LIKE rqa_file.rqa01,
       g_rqa02        LIKE rqa_file.rqa02,
       g_rqa03        LIKE rqa_file.rqa03,
       g_rqa04        LIKE rqa_file.rqa04,
       g_rqa          RECORD LIKE rqa_file.*,
       g_rpf          RECORD LIKE rpf_file.*,
       g_over         LIKE type_file.chr1,      #NO.FUN-680101 VARCHAR(1)     #超耗否
        g_wc,g_wc2    string, #WHERE CONDITION  #No.FUN-580092 HCN
        g_sql         string, #WHERE CONDITION  #No.FUN-580092 HCN
       g_rec_b        LIKE type_file.num5,      #NO.FUN-680101 SMALLINT    #單身筆數
       l_ac           LIKE type_file.num5,      #NO.FUN-680101 SMALLINT    #目前處理的ARRAY CNT
       l_sl           LIKE type_file.num5       #NO.FUN-680101 SMALLINT    #目前處理的SCREEN LINE
 
#主程式開始
DEFINE   g_cnt        LIKE type_file.num10      #NO.FUN-680101 INTEGER   
DEFINE   g_msg        LIKE type_file.chr1000    #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10      #NO.FUN-680101 INTEGER 
DEFINE   g_curs_index LIKE type_file.num10      #NO.FUN-680101 INTEGER 
DEFINE   g_jump       LIKE type_file.num10      #NO.FUN-680101 INTEGER 
DEFINE   mi_no_ask    LIKE type_file.num5       #NO.FUN-680101 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8                #No.FUN-6A0081
    p_row,p_col       LIKE type_file.num5       #NO.FUN-680101 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET g_argv1 = ARG_VAL(1)               #參數-1
    LET g_argv2 = ARG_VAL(2)               #參數-2
    LET g_argv3 = ARG_VAL(3)               #參數-3
    LET g_argv4 = ARG_VAL(4)               #參數-4
    LET p_row = 2 LET p_col = 2 
    OPEN WINDOW q610_w  AT p_row,p_col
        WITH FORM "ams/42f/amsq610" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    CALL cl_ui_locale("")
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q610_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q610_q() END IF
    CALL q610_menu()
    CLOSE WINDOW q610_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION q610_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE   l_cnt          LIKE type_file.num5       #NO.FUN-680101   SMALLINT
 
 CLEAR FORM #清除畫面
   CALL g_rqb.clear()
 WHILE TRUE 
  IF NOT cl_null(g_argv1)  THEN 
     LET g_wc="rqa01='",g_argv1 CLIPPED,"' AND rqa02='",g_argv2 CLIPPED,"' "
     IF NOT cl_null(g_argv3) OR NOT cl_null(g_argv4) THEN 
        LET g_wc=g_wc CLIPPED," AND rqa03='",g_argv3 CLIPPED,
                 "' AND rqa04='",g_argv4 CLIPPED,"' " CLIPPED
     END IF 
  ELSE 
 # 螢幕上取單頭條件
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_rqa01 TO NULL    #No.FUN-750051
   INITIALIZE g_rqa02 TO NULL    #No.FUN-750051
   INITIALIZE g_rqa03 TO NULL    #No.FUN-750051
   INITIALIZE g_rqa04 TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc On rqa01,rqa02,rqa03,rqa04,rqa07,rqa05,rqa06
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN EXIT WHILE  END IF
 # 螢幕上取單身條件
   CONSTRUCT g_wc2 ON rqb062,rqb05,rqb06,rqb061,rqb063,rqb064,rqb08,rqb09 
                FROM s_rqb[1].rqb062,s_rqb[1].rqb05,s_rqb[1].rqb06,
                     s_rqb[1].rqb061,s_rqb[1].rqb063,s_rqb[1].rqb064,
                     s_rqb[1].rqb08,s_rqb[1].rqb09 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN EXIT WHILE  END IF
  END IF 
   IF cl_null(g_wc)  THEN LET g_wc=' 1=1' END IF 
   IF cl_null(g_wc2) THEN LET g_wc2=' 1=1' END IF 
   IF g_wc2=' 1=1' THEN 
      LET g_sql=" SELECT UNIQUE rqa01,rqa02,rqa03,rqa04 FROM rqa_file",
                " WHERE ",g_wc CLIPPED,
                " ORDER BY 1,2,3,4 "
   ELSE 
      LET g_sql=" SELECT UNIQUE rqa01,rqa02,rqa03,rqa04 ",
                " FROM rqa_file, rqb_file ",
                " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " AND rqa01=rqb01 AND rqa02=rqb02 AND rqa03=rqb03 ",
                " AND rqa04=rqb04 ",
                " ORDER BY 1,2,3,4 "
  END IF 
    PREPARE q610_prepare FROM g_sql
    DECLARE q610_cs                         #SCROLL CURSOR
        SCROLL CURSOR FOR q610_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    DROP TABLE x
    IF g_wc2 = ' 1=1' THEN
       LET g_sql=" SELECT UNIQUE rqa01,rqa02,rqa03,rqa04 ",
                 " FROM rqa_file ",
                 " WHERE ",g_wc CLIPPED,
                 " INTO TEMP x "
    ELSE
       LET g_sql=" SELECT UNIQUE rqa01,rqa02,rqa03,rqa04 ",
                 " FROM rqa_file, rqb_file ",
                 " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " AND rqa01=rqb01 ",
                 " AND rqa02=rqb02 AND rqa03=rqb03 AND rqa04=rqb04",
                 " INTO TEMP x "
     END IF
    PREPARE q610_precount_0 FROM g_sql
    EXECUTE q610_precount_0
    LET g_sql="SELECT COUNT(*) FROM x" CLIPPED
    PREPARE q610_pp FROM g_sql
    DECLARE q610_count CURSOR FOR q610_pp
    EXIT WHILE  
 END WHILE 
END FUNCTION
 
#中文的MENU
 
FUNCTION q610_menu()
 
   WHILE TRUE
      CALL q610_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q610_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0014
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rqb),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_rqb.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q610_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE ' WAIT ' 
    OPEN q610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
    OPEN q610_count
    FETCH q610_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL q610_fetch('F')                  # 讀出TEMP第一筆並顯示
    MESSAGE ''
END FUNCTION
 
#處理資料的讀取
FUNCTION q610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)    #處理方式
    l_abso          LIKE type_file.num10   #NO.FUN-680101 INTEGER    #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q610_cs INTO g_rqa01,g_rqa02,g_rqa03,g_rqa04 
        WHEN 'P' FETCH PREVIOUS q610_cs INTO g_rqa01,g_rqa02,g_rqa03,g_rqa04
        WHEN 'F' FETCH FIRST    q610_cs INTO g_rqa01,g_rqa02,g_rqa03,g_rqa04
        WHEN 'L' FETCH LAST     q610_cs INTO g_rqa01,g_rqa02,g_rqa03,g_rqa04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q610_cs INTO g_rqa01,g_rqa02,g_rqa03,g_rqa04
            LET mi_no_ask = FALSE
    END CASE
 
    SELECT * INTO g_rqa.* FROM rqa_file 
     WHERE rqa01=g_rqa01 AND rqa02=g_rqa02 AND rqa03=g_rqa03 AND rqa04=g_rqa04
    IF SQLCA.sqlcode THEN
  #    CALL cl_err(g_rqa01,SQLCA.sqlcode,0) #No.FUN-660108
       CALL cl_err3("sel","rqa_file",g_rqa.rqa01,"",SQLCA.sqlcode,"","",0)         #No.FUN-660108    
       INITIALIZE g_rqa.* TO NULL  #TQC-6B0105
       LET g_rqa01=''
       LET g_rqa02=''
       LET g_rqa03=''
       LET g_rqa04=''
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
 
    CALL q610_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q610_show()
 
    SELECT * INTO g_rpf.* FROM rpf_file WHERE rpf01=g_rqa.rqa01 
 
    IF g_rpf.rpf03 = '1' 
       THEN
       LET g_rpf.rpf03 = '人時'
    ELSE
       LET g_rpf.rpf03 = '機時'
    END IF
 
    DISPLAY BY NAME g_rqa.rqa01,g_rqa.rqa02,g_rqa.rqa03,g_rqa.rqa04,
                    g_rqa.rqa05,g_rqa.rqa06,g_rqa.rqa07 
    DISPLAY BY NAME g_rpf.rpf02,g_rpf.rpf03,g_rpf.rpf04,g_rpf.rpf07
 
    IF g_rqa.rqa06>g_rqa.rqa05
       THEN
       DISPLAY BY NAME g_rqa.rqa06 
       DISPLAY 'Y' TO FORMONLY.over 
    ELSE
       DISPLAY 'N' TO FORMONLY.over 
    END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' 
      THEN
      DISPLAY '!' TO rpf07  
      DISPLAY '!' TO FORMONLY.over
   END IF
   CALL q610_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q610_b_fill()                        #BODY FILL UP
DEFINE l_sql     LIKE type_file.chr1000       #NO.FUN-680101 VARCHAR(1000)
 
   LET l_sql="SELECT rqb062,rqb05,'',rqb06,rqb061,rqb065,rqb063,",
             " rqb064,rqb08,rqb09 FROM rqb_file ",
             " WHERE  rqb01='",g_rqa.rqa01 CLIPPED,
             "' AND   rqb02='",g_rqa.rqa02 CLIPPED,
             "' AND   rqb03='",g_rqa.rqa03 CLIPPED,
             "' AND   rqb04='",g_rqa.rqa04 CLIPPED,
             "' AND ",g_wc2 CLIPPED,
             "  ORDER BY 1 " 
    PREPARE q610_pb FROM l_sql
    DECLARE q610_bcs                       #SCROLL CURSOR
        CURSOR FOR q610_pb
 
    CALL g_rqb.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q610_bcs INTO g_rqb[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CASE g_rqb[g_cnt].rqb05
           WHEN '64' 
              CALL cl_getmsg('ams-015',g_lang) RETURNING g_rqb[g_cnt].t5_name
           WHEN '65'
              CALL cl_getmsg('ams-016',g_lang) RETURNING g_rqb[g_cnt].t5_name
           WHEN '66'
              CALL cl_getmsg('ams-017',g_lang) RETURNING g_rqb[g_cnt].t5_name
           OTHERWISE      
      END CASE 
    
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_rqb.deleteElement(g_cnt)     #No.TQC-770033  
    LET g_cnt = g_cnt - 1
    LET g_rec_b=g_cnt     
    IF g_rec_b = 0 AND g_cnt > 1 THEN
       LET g_rec_b=9999
       DISPLAY g_rec_b TO FORMONLY.cn2 
    END IF
END FUNCTION
 
FUNCTION q610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rqb TO s_rqb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0014
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
       #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end         
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
