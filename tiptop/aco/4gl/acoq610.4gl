# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acoq610.4gl
# Descriptions...: 內銷申請數量查詢作業
# Date & Author..: 03/08/29 By Danny
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-493098 04/12/01 By DAY   add cnu07
# Modify.........: No.MOD-490398 05/02/25 By Carrier cnu04去掉'2.材料'的屬性
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790066 07/09/11 By Judy 匯出Excel多一空白行 
# Modify.........: No.TQC-930033 09/03/10 By mike 在_cs()段里呼叫b_askkey()做單身查詢后的tm.wc2未組入單頭sql條件，
#                                                 只在b_fill()里當where條件, 應判斷若非 " 1=1"時加入單頭條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)  # Head Where condition
       	wc2  	LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)  # Body Where condition
        END RECORD,
    g_cnu   RECORD
                cnu01  LIKE cnu_file.cnu01,
                cnu02  LIKE cnu_file.cnu02,
                cnu03  LIKE cnu_file.cnu03,
                cnu07  LIKE cnu_file.cnu07,    #MOD-490398
                cnu04  LIKE cnu_file.cnu04,
                cnu05  LIKE cnu_file.cnu05,
                cnu06  LIKE cnu_file.cnu06
        END RECORD,
    g_cnv DYNAMIC ARRAY OF RECORD
                cnv02  LIKE cnv_file.cnv02,
                cnv03  LIKE cnv_file.cnv03,
                cnv04  LIKE cnv_file.cnv04,
                cob02  LIKE cob_file.cob02,
                cnv041 LIKE cnv_file.cnv041,
                cnv05  LIKE cnv_file.cnv05,
                cnv051 LIKE cnv_file.cnv051,
                cnv06  LIKE cnv_file.cnv06,
                tot    LIKE cnv_file.cnv05
        END RECORD,
    g_argv1         LIKE cnu_file.cnu01,
    g_sql           STRING,        #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num10          #No.FUN-680069 INTEGER  #單身筆數
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680069 INTEGER
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_argv1 = ARG_VAL(1)         #申請編號
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
    OPEN WINDOW q610_w WITH FORM "aco/42f/acoq610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF not cl_null(g_argv1) THEN CALL q610_q() END IF
    CALL q610_menu()
    CLOSE WINDOW q610_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION q610_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "cnu01 = '",g_argv1,"'"
           LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_cnv.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
   INITIALIZE g_cnu.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON
                         cnu01,cnu02,cnu03,cnu07,cnu04,cnu05,cnu06  #MOD-490398
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
           CALL q610_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF tm.wc2 =" 1=1" THEN #TQC-930033
      LET g_sql=" SELECT cnu01 FROM cnu_file ",
                " WHERE cnuacti ='Y' ", #010807增
                "   AND cnuconf <> 'X' ",  #CHI-C80041
                " AND ",tm.wc CLIPPED
  #TQC-930033---START
   ELSE
      LET g_sql=" SELECT DISTINCT cnu01  ", 
                "  FROM cnu_file,cnv_file, cob_file",                                                                                           
                " WHERE cnv01 =cnu01",                                                                                     
                "   AND cnv04 = cob01 ",                                                                                               
                "   AND cnuacti ='Y' ", 
                "   AND cnuconf <> 'X' ",  #CHI-C80041
                " AND ",tm.wc CLIPPED,
                " AND ",tm.wc2 CLIPPED
   END IF
  #TQC-930033---END             
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cnuuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cnugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cnugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('cnuuser', 'cnugrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY cnu01"
   PREPARE q610_prepare FROM g_sql
   DECLARE q610_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q610_prepare
 
   IF tm.wc2 =" 1=1" THEN #TQC-930033
      LET g_sql=" SELECT COUNT(*) FROM cnu_file ",
                "  WHERE cnuacti ='Y' ",
                "   AND cnuconf <> 'X' ",  #CHI-C80041
                "    AND ",tm.wc CLIPPED
  #TQC-930033 ---START
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT(cnu01))  ",                                                                                  
                "   FROM cnu_file,cnv_file, cob_file",                                                                                           
                "  WHERE cnv01 =cnu01 ",
                "    AND cnuacti ='Y' ",
                "   AND cnuconf <> 'X' ",  #CHI-C80041
                "    AND ",tm.wc CLIPPED,                                                                                                
                "   AND cnv04 = cob01 ",                                                                                               
                "   AND ",tm.wc2 CLIPPED
   END IF
  #TQC-930033 --END
                                                                                              
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cnuuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cnugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cnugrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q610_pp  FROM g_sql
   DECLARE q610_cnt   CURSOR FOR q610_pp
END FUNCTION
 
FUNCTION q610_b_askkey()
   CONSTRUCT tm.wc2 ON cnv02,cnv03,cnv04,cnv041,cob02,cnv05,cnv051,cnv06
                  FROM s_cnv[1].cnv02,s_cnv[1].cnv03,
                       s_cnv[1].cnv04,s_cnv[1].cnv041,s_cnv[1].cob02,
                       s_cnv[1].cnv05,s_cnv[1].cnv051,
                       s_cnv[1].cnv06
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
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
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnv),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q610_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q610_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q610_cnt
        FETCH q610_cnt INTO g_row_count #CKP
        DISPLAY g_row_count TO cnt #CKP
        CALL q610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q610_cs INTO g_cnu.cnu01
        WHEN 'P' FETCH PREVIOUS q610_cs INTO g_cnu.cnu01
        WHEN 'F' FETCH FIRST    q610_cs INTO g_cnu.cnu01
        WHEN 'L' FETCH LAST     q610_cs INTO g_cnu.cnu01
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
             END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso q610_cs INTO g_cnu.cnu01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)
        INITIALIZE g_cnu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 #MOD-490398--begin
    SELECT cnu01,cnu02,cnu03,cnu07,cnu04,cnu05,cnu06
      INTO g_cnu.* FROM cnu_file WHERE cnu01 = g_cnu.cnu01
                                   AND  cnuacti ='Y' #010807 增
                                   AND  cnuconf <> 'X'  #CHI-C80041
 #MOD-490398--end
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("sel","cnu_file",g_cnu.cnu01,"",SQLCA.sqlcode,"","",0) #TQC-660045
       RETURN
    END IF
 
    CALL q610_show()
END FUNCTION
 
FUNCTION q610_show()
 DEFINE l_desc1 LIKE cnb_file.cnb04
 DEFINE l_desc2 LIKE pmc_file.pmc03
 
    DISPLAY BY NAME g_cnu.cnu01,g_cnu.cnu02,g_cnu.cnu03,g_cnu.cnu07,g_cnu.cnu04, #MOD-490398
                   g_cnu.cnu05,g_cnu.cnu06
             # 顯示單頭值
   CALL q610_cnu04()
   CALL q610_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q610_cnu04()       #轉廠類型
    DEFINE l_chr     LIKE type_file.chr10   #LIKE cqa_file.cqa03       #No.FUN-680069 VARCHAR(8)   #TQC-B90211
    CASE g_cnu.cnu04
         WHEN '1'    LET l_chr = cl_getmsg('aco-047',0)
 #         WHEN '2'    LET l_chr = cl_getmsg('aco-048',0) #No.MOD-490398
    END CASE
    DISPLAY l_chr TO FORMONLY.desc
END FUNCTION
 
FUNCTION q610_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,     #No.FUN-680069 VARCHAR(400)
	  I,J 	    LIKE type_file.num10        #No.FUN-680069 INTEGER
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql=" SELECT cnv02,cnv03,cnv04,cob02,cnv041,cnv05,cnv051,",
             "  cnv06,0",
             "  FROM cnv_file, cob_file",
             " WHERE cnv01 ='",g_cnu.cnu01,"'",
             "   AND cnv04 = cob01 ",
             "   AND ",tm.wc2 CLIPPED,
	     " ORDER BY cnv02"
 
    PREPARE q610_pb1 FROM l_sql
    DECLARE q610_bcs1 CURSOR FOR q610_pb1
 
    FOR g_cnt = 1 TO g_cnv.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_cnv[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q610_bcs1 INTO g_cnv[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach1:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #-->剩餘數量(tot)
        LET g_cnv[g_cnt].tot= g_cnv[g_cnt].cnv05 - g_cnv[g_cnt].cnv051
        LET g_cnt = g_cnt + 1
       #DISPLAY g_rec_b TO FORMONLY.cn2 #TQC-930033
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_cnv.deleteElement(g_cnt)  #TQC-790066
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b=g_cnt-1 #TQC-930033
    DISPLAY g_rec_b TO FORMONLY.cn2 #TQC-930033
END FUNCTION
 
FUNCTION q610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnv TO s_cnv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
