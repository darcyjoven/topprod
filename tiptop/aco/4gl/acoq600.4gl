# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: acoq600.4gl
# Descriptions...: 轉廠申請數量查詢作業
# Date & Author..: 00/09/20 By Apple
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/12/01 By DAY   add cnm09
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790066 07/09/11 By Judy 匯出Excel多一空白行 
# Modify.........: No.TQC-930033 09/03/06 By mike 在_cs()段里呼叫b_askkey()做單身查詢后的tm.wc2未組入單頭sql條件，
#                                                  在b_fill()里當where條件, 應判斷若非 " 1=1"時加入單頭條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0332 09/12/21 By sabrina 不可查詢到未確認的資料
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)   # Head Where condition
       	wc2  	LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)   # Body Where condition
        END RECORD,
     g_cnm   RECORD        #No.MOD-490398
                cnm01  LIKE cnm_file.cnm01,
                cnm02  LIKE cnm_file.cnm02,
                cnm03  LIKE cnm_file.cnm03,
                cnm04  LIKE cnm_file.cnm04,
                cnm05  LIKE cnm_file.cnm05,
                cnm06  LIKE cnm_file.cnm06,
                cnm09  LIKE cnm_file.cnm09,
                cnm07  LIKE cnm_file.cnm07,
                cnm072 LIKE cnm_file.cnm072,
                cnm08  LIKE cnm_file.cnm08,
                cnm082 LIKE cnm_file.cnm082
         END RECORD,       #No.MOD-490398   end
    g_cnn DYNAMIC ARRAY OF RECORD
                cnn02  LIKE cnn_file.cnn02,
                cnn03  LIKE cnn_file.cnn03,
                cnn04  LIKE cnn_file.cnn04,
                cnn041 LIKE cnn_file.cnn041,
                cob02  LIKE cob_file.cob02,
                cnn06  LIKE cnn_file.cnn06,
                cnn05  LIKE cnn_file.cnn05,
                cnn051 LIKE cnn_file.cnn051,
                tot    LIKE cnn_file.cnn05
        END RECORD,
    g_argv1         LIKE cnm_file.cnm01,
    g_sql           STRING,        #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num10              #No.FUN-680069 INTEGER  #單身筆數
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(72)
         l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
 
MAIN
   OPTIONS                                #改變一些系統預設值
     INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)         #申請編號
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   OPEN WINDOW q600_w WITH FORM "aco/42f/acoq600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF not cl_null(g_argv1) THEN CALL q600_q() END IF
 
   CALL q600_menu()
   CLOSE WINDOW q600_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION q600_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "cnm01 = '",g_argv1,"'"
           LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_cnn.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
   INITIALIZE g_cnm.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON
                         cnm01,cnm02,cnm03,cnm04,cnm05,cnm09,    #No.MOD-490398
                         cnm06,cnm07,cnm072,cnm08,cnm082         #No.MOD-490398
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
           CALL q600_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
  
   IF tm.wc2=" 1=1" THEN #TQC-930033
      LET g_sql=" SELECT cnm01 FROM cnm_file ",
                " WHERE cnmacti ='Y' ", #010807增  
                " AND cnmconf = 'Y' ",     #MOD-9C0332
                " AND ",tm.wc CLIPPED
  #TQC-930033  -----start
   ELSE 
      LET g_sql=" SELECT DISTINCT cnm01 ",
                "   FROM cnm_file,cnn_file, cob_file ",                                                                                           
                "  WHERE cnn01 =cnm01 ",                                                                                     
                "    AND cnn04 = cob01 ",                                                                                               
                "    AND cnmconf = 'Y' ",     #MOD-9C0332
                "    AND cnmacti ='Y' ", 
                "    AND ",tm.wc CLIPPED, 
                "    AND ",tm.wc2 CLIPPED 
   END IF 
  #TQC-930033  -----end
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cnmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cnmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cnmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('cnmuser', 'cnmgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY cnm01"
   PREPARE q600_prepare FROM g_sql
   DECLARE q600_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q600_prepare
 
   IF tm.wc2 =" 1=1" THEN #TQC-930033 
      LET g_sql=" SELECT COUNT(*) FROM cnm_file ",
                " WHERE cnmacti ='Y' ", #010807增
                " AND cnmconf = 'Y' ",     #MOD-9C0332
                " AND ",tm.wc CLIPPED
  #TQC-930033 ---START
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT(cnm01)) ",                                                                                             
                "   FROM cnm_file,cnn_file, cob_file ",                                                                             
                "  WHERE cnn01 =cnm01 ",                                                                                            
                "    AND cnn04 = cob01 ",                                                                                           
                "    AND cnmconf = 'Y' ",     #MOD-9C0332
                "    AND cnmacti ='Y' ",                                                                                            
                "    AND ",tm.wc CLIPPED,                                                                                           
                "    AND ",tm.wc2 CLIPPED 
   END IF 
  #TQC-930033 ---END 
  
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND cnmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND cnmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND cnmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q600_pp  FROM g_sql
   DECLARE q600_cnt   CURSOR FOR q600_pp
END FUNCTION
 
FUNCTION q600_b_askkey()
   CONSTRUCT tm.wc2 ON cnn02,cnn03,cnn04,cnn041,cob02,cnn06,cnn05,cnn051
                  FROM s_cnn[1].cnn02,s_cnn[1].cnn03,
                       s_cnn[1].cnn04,s_cnn[1].cnn041,s_cnn[1].cob02,
                       s_cnn[1].cnn06,
                       s_cnn[1].cnn05,s_cnn[1].cnn051
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
 
FUNCTION q600_menu()
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query"
          IF cl_chk_act_auth() THEN
              CALL q600_q()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnn),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q600_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q600_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q600_cnt
        FETCH q600_cnt INTO g_row_count #CKP
        DISPLAY g_row_count TO cnt #CKP
        CALL q600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q600_cs INTO g_cnm.cnm01
        WHEN 'P' FETCH PREVIOUS q600_cs INTO g_cnm.cnm01
        WHEN 'F' FETCH FIRST    q600_cs INTO g_cnm.cnm01
        WHEN 'L' FETCH LAST     q600_cs INTO g_cnm.cnm01
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
            FETCH ABSOLUTE l_abso q600_cs INTO g_cnm.cnm01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)
        INITIALIZE g_cnm.* TO NULL  #TQC-6B0105
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
    SELECT cnm01,cnm02,cnm03,cnm04,cnm05,cnm06,cnm09,
           cnm07,cnm072,cnm08,cnm082
      INTO g_cnm.* FROM cnm_file WHERE cnm01 = g_cnm.cnm01
                                   AND  cnmacti ='Y' #010807 增
                                   AND  cnmconf <> 'X' #CHI-C80041
 #MOD-490398--end
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("sel","cnm_file",g_cnm.cnm01,"",SQLCA.sqlcode,"","",0) #TQC-660045
       RETURN
    END IF
 
    CALL q600_show()
END FUNCTION
 
FUNCTION q600_show()
 DEFINE l_desc1 LIKE cnb_file.cnb04
 DEFINE l_desc2 LIKE pmc_file.pmc03
 
   DISPLAY BY NAME g_cnm.cnm01,g_cnm.cnm02,g_cnm.cnm03,g_cnm.cnm04,
                    g_cnm.cnm05,g_cnm.cnm06,g_cnm.cnm09,g_cnm.cnm07, #No.MOD-490398
                    g_cnm.cnm072,g_cnm.cnm08,g_cnm.cnm082            #No.MOD-490398
             # 顯示單頭值
   SELECT cnb04 INTO l_desc1 FROM cnb_file
    WHERE cnb01 = g_cnm.cnm07
   SELECT pmc03 INTO l_desc2 FROM pmc_file
    WHERE pmc01 = g_cnm.cnm08
   DISPLAY l_desc1 TO FORMONLY.desc1
   DISPLAY l_desc2 TO FORMONLY.desc2
 
   CALL q600_cnm04()
   CALL q600_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_cnm04()       #轉廠類型
    DEFINE l_chr     LIKE type_file.chr10   #LIKE cqa_file.cqa03       #No.FUN-680069 VARCHAR(8)   #TQC-B90211
    CASE g_cnm.cnm04
         WHEN '1'    LET l_chr = cl_getmsg('aco-051',0)
         WHEN '2'    LET l_chr = cl_getmsg('aco-052',0)
         WHEN '3'    LET l_chr = cl_getmsg('aco-053',0)
         WHEN '4'    LET l_chr = cl_getmsg('aco-054',0)
    END CASE
    DISPLAY l_chr TO FORMONLY.desc
END FUNCTION
 
FUNCTION q600_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(400)
	  I,J 	    LIKE type_file.num10          #No.FUN-680069 INTEGER 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql=" SELECT cnn02,cnn03,cnn04,cnn041,cob02,cnn06,cnn05,cnn051,",
             "  0",
             "  FROM cnn_file, cob_file",
             " WHERE cnn01 ='",g_cnm.cnm01,"'",
             "   AND cnn04 = cob01 ",
             "   AND ",tm.wc2 CLIPPED,
	     " ORDER BY cnn02"
 
    PREPARE q600_pb1 FROM l_sql
    DECLARE q600_bcs1 CURSOR FOR q600_pb1
 
    FOR g_cnt = 1 TO g_cnn.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_cnn[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q600_bcs1 INTO g_cnn[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach1:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #-->剩餘數量(tot)
        LET g_cnn[g_cnt].tot= g_cnn[g_cnt].cnn05 - g_cnn[g_cnt].cnn051
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_cnn.deleteElement(g_cnt)  #TQC-790066
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnn TO s_cnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q600_fetch('L')
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
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
