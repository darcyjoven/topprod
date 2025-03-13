# Prog. Version..: '5.30.06-13.03.20(00008)'     #
#
# Pattern name...: apmq235.4gl
# Descriptions...: 廠商應付帳款查詢
# Date & Author..: 97/08/29 By Kitty
# Modify.........: No.8522 03/10/20 By Kitty 加show本幣
# Modify.........: No.MOD-480480 04/09/15 By Smapmin調整為可以顯示上下筆之功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray 匯出EXCEL輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-810236 08/01/29 By Claire 公式錯誤,折讓21時,應*(-1)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30028 10/03/12 By wujie  增加来源单据串查
#                                                   增加未付金额栏位 
# Modify.........: No:MOD-B80303 11/08/26 By suncx 單頭查詢SQL方法錯誤
# Modify.........: No.TQC-CC0023 12/12/06 By qirl  pmc01開窗
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(500) 
       	wc2  	LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(500) 
        END RECORD,
    g_pmc   RECORD
	pmc01	LIKE pmc_file.pmc01,
	pmc03	LIKE pmc_file.pmc03
        END RECORD,
    g_apa DYNAMIC ARRAY OF RECORD
        apa00   LIKE apa_file.apa00,
        apa01   LIKE apa_file.apa01,
        apa02   LIKE apa_file.apa02,
        apa12   LIKE apa_file.apa12,
        apa08   LIKE apa_file.apa08,
        apa13   LIKE apa_file.apa13,
        apa34f  LIKE apa_file.apa34f,
        apa35f  LIKE apa_file.apa35f,
        amt1    LIKE apa_file.apa35f,            #No.FUN-A30028
        apa34   LIKE apa_file.apa34,             #No:8522
        apa35   LIKE apa_file.apa35,             #No:8522
        amt2    LIKE apa_file.apa35              #No.FUN-A30028
        END RECORD,
    g_argv1         LIKE pmc_file.pmc01,
    g_query_flag    LIKE type_file.num5,      #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10,     #No.FUN-680136 INTEGER #單身筆數
    g_tot1          LIKE apa_file.apa34,      #應收金額合計 No:8522
    g_tot2          LIKE apa_file.apa35       #已沖金額合計 No:8522
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(72)
       l_ac         LIKE type_file.num5       #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
 
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-680136 INTEGER


MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
 
    OPEN WINDOW q235_w WITH FORM "apm/42f/apmq235"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q235_q() END IF
    CALL q235_menu()
    CLOSE WINDOW q235_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q235_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmc01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_apa.clear()
         CALL cl_opmsg('q')
         INITIALIZE tm.* TO NULL			# Default condition
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME tm.wc ON pmc01,pmc03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         #--TQC-CC0023--add--star--
          ON ACTION CONTROLP
           CASE
             WHEN INFIELD(pmc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_pmc14"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc01
                  NEXT FIELD pmc01
           END CASE
         #--TQC-CC0023--add--end---
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
         #Begin:FUN-980030
         #         IF g_priv2='4' THEN                           #只能使用自己的資料
         #            LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
         #End:FUN-980030
 
         CALL q235_b_askkey()
         IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   LET g_sql=" SELECT pmc01 FROM pmc_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY pmc01"
   #MOD-B80303 add begin---------------
   IF tm.wc2 <> " 1=1" THEN
      LET g_sql=" SELECT pmc01 FROM pmc_file,apa_file ",
                " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND apa06 = pmc01 ",
                " ORDER BY pmc01"
   END IF
   #MOD-B80303 add end-----------------
   PREPARE q235_prepare FROM g_sql
   DECLARE q235_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q235_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(*) FROM pmc_file ",
              " WHERE ",tm.wc CLIPPED
   #MOD-B80303 add begin---------------
   IF tm.wc2 <> " 1=1" THEN
      LET g_sql=" SELECT COUNT(*) FROM pmc_file,apa_file ",
                " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND apa06 = pmc01 "
   END IF
   #MOD-B80303 add end-----------------
   PREPARE q235_pp  FROM g_sql
   DECLARE q235_cnt   CURSOR FOR q235_pp
END FUNCTION
 
FUNCTION q235_b_askkey()
   CONSTRUCT tm.wc2 ON apa00,apa01,apa02,apa12,apa08,apa13,apa34f,apa35f,apa34,apa35         #No:8522
                  FROM s_apa[1].apa00,s_apa[1].apa01,s_apa[1].apa02,
                       s_apa[1].apa12,s_apa[1].apa08,s_apa[1].apa13,
    	               s_apa[1].apa34f,s_apa[1].apa35f,s_apa[1].apa34,s_apa[1].apa35         #No:8522
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
 
FUNCTION q235_menu()
 
   WHILE TRUE
      CALL q235_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q235_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
#No.FUN-A30028 --begin  
         WHEN "qry_apa" 
            IF cl_chk_act_auth() THEN    
               LET l_ac = ARR_CURR()    
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN       
                  CALL q235_apa_q() 
                  CALL cl_cmdrun(g_msg)     
               END IF                      
            END IF                        
#No.FUN-A30028 --end
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apa),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q235_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q235_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q235_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
           OPEN q235_cnt
            FETCH q235_cnt INTO g_row_count #MOD-480480
            DISPLAY g_row_count TO cnt  #MOD-480480
        CALL q235_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q235_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q235_cs INTO g_pmc.pmc01
        WHEN 'P' FETCH PREVIOUS q235_cs INTO g_pmc.pmc01
        WHEN 'F' FETCH FIRST    q235_cs INTO g_pmc.pmc01
        WHEN 'L' FETCH LAST     q235_cs INTO g_pmc.pmc01
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
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso q235_cs INTO g_pmc.pmc01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
        INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
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
	SELECT pmc01,pmc03
	  INTO g_pmc.pmc01,g_pmc.pmc03
	  FROM pmc_file
	 WHERE pmc01 = g_pmc.pmc01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)     #No.FUN-660129
        CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660129
        RETURN
    END IF
 
    CALL q235_show()
END FUNCTION
 
FUNCTION q235_show()
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q235_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q235_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,        #No.FUN-680136 VARCHAR(1000) 
          l_apa34f  LIKE apa_file.apa34f
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
#       "SELECT apa00,apa01,apa02,apa12,apa08,apa13,apa34f,apa35f,apa34,apa35",   #No:8522
        "SELECT apa00,apa01,apa02,apa12,apa08,apa13,apa34f,apa35f,'',apa34,apa35,''",   #No:8522   #No.FUN-A30028
        "  FROM apa_file ",
        " WHERE apa06 = '",g_pmc.pmc01,"'"," AND apa34f > apa35f",
        "    AND apa41='Y' AND apa42='N' AND ",tm.wc2 CLIPPED,
        " ORDER BY apa00,apa01 "
    PREPARE q235_pb FROM l_sql
    DECLARE q235_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q235_pb
 
    FOR g_cnt = 1 TO g_apa.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_apa[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
	LET g_tot1= 0
	LET g_tot2= 0
    FOREACH q235_bcs INTO g_apa[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_apa[g_cnt].apa34f IS NULL THEN
  	       LET g_apa[g_cnt].apa34f = 0
        END IF
        IF g_apa[g_cnt].apa35f IS NULL THEN
  	       LET g_apa[g_cnt].apa35f = 0
        END IF
         #No:8522
        IF g_apa[g_cnt].apa34 IS NULL THEN
               LET g_apa[g_cnt].apa34 = 0
        END IF
        IF g_apa[g_cnt].apa35 IS NULL THEN
               LET g_apa[g_cnt].apa35 = 0
        END IF
                #------modify:3008------------------------
                IF g_apa[g_cnt].apa00 >='21' THEN
                  #LET l_apa34f=g_apa[g_cnt].apa34f * (-1)             #MOD-812336 mark  
                   LET g_apa[g_cnt].apa34f=g_apa[g_cnt].apa34f * (-1)  #MOD-810236 
                   LET g_apa[g_cnt].apa34=g_apa[g_cnt].apa34 * (-1)    #No:8522
                   LET g_apa[g_cnt].apa35f=g_apa[g_cnt].apa35f * (-1)  #No:8522
                   LET g_apa[g_cnt].apa35=g_apa[g_cnt].apa35 * (-1)    #No:8522
                END IF
                #-----------------------------------------
#No.FUN-A30028 --begin
        LET g_apa[g_cnt].amt1 = g_apa[g_cnt].apa34f - g_apa[g_cnt].apa35f        
        LET g_apa[g_cnt].amt2 = g_apa[g_cnt].apa34 - g_apa[g_cnt].apa35        
#No.FUN-A30028 --end
                LET g_tot1 = g_tot1 + g_apa[g_cnt].apa34     #No:8522
                LET g_tot2 = g_tot2 + g_apa[g_cnt].apa35    #No:8522
 
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_apa.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
	DISPLAY g_tot1 TO tot01
	DISPLAY g_tot2 TO tot02
#       DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q235_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q235_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q235_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q235_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q235_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q235_fetch('L')
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
          CALL cl_show_fld_cont()                   #No.FUN-55:037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
#No.FUN-A30028 --begin
      ON ACTION qry_apa
         LET g_action_choice = 'qry_apa'
         EXIT DISPLAY
#No.FUN-A30028 --end 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-A30028 --begin
FUNCTION q235_apa_q()
DEFINE l_apa00    LIKE apa_file.apa00

    LET g_msg =''
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01 = g_apa[l_ac].apa01
    IF NOT sqlCA.sqlcode THEN
       IF l_apa00 ='23' THEN
          LET g_msg ='aapq230'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='25' THEN
          LET g_msg ='aapq231'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='24' THEN
          LET g_msg ='aapq240'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='11' THEN
          LET g_msg ='aapt110'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='12' THEN
          LET g_msg ='aapt120'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='13' THEN
          LET g_msg ='aapt121'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='15' THEN
          LET g_msg ='aapt150'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='17' THEN
          LET g_msg ='aapt151'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='16' THEN
          LET g_msg ='aapt160'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='21' THEN
          LET g_msg ='aapt210'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='22' THEN
          LET g_msg ='aapt220'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
       IF l_apa00 ='26' THEN
          LET g_msg ='aapt260'," '",g_apa[l_ac].apa01 CLIPPED,"'"
          RETURN
       END IF
    END IF

END FUNCTION
#No.FUN-A30028 --end 
