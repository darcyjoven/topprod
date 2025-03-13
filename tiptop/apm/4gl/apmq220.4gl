# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmq220.4gl
# Descriptions...: 供應商/料件查詢
# Date & Author..: 92/03/19 BY MAY
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmq220時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: No.FUN-610092 06/05/05 By Joe 增加採購單位欄位
# Modify.........: No.FUN-660129 06/06/20 By cl  cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray 匯出EXCEL輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0205 07/10/31 By claire QBE條件輸入廠商簡稱會有錯誤
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
            wc      LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(500) 
            wc2     LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(500) 
        END RECORD,
    g_pmc  RECORD
            pmh02   LIKE pmh_file.pmh02,
            pmc03   LIKE pmc_file.pmc03,
            pmh22   LIKE pmh_file.pmh22       #No.CHI-8C0017
        END RECORD,
    g_pmh DYNAMIC ARRAY OF RECORD
            pmh01   LIKE pmh_file.pmh01,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            ima44   LIKE ima_file.ima44,     #No.FUN-610092
            pmh12   LIKE pmh_file.pmh12,
            pmh05   LIKE pmh_file.pmh05,
            pmh13   LIKE pmh_file.pmh13,
            pmh21   LIKE pmh_file.pmh21      #No.CHI-8C0017
        END RECORD,
    g_argv1         LIKE pmh_file.pmh02,     # INPUT ARGUMENT - 1
     g_sql string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num5   	     #單身筆數        #No.FUN-680136 SMALLINT
 
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680136 SMALLINT 
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,       #No.FUN-680136 VARCHAR(72) 
       l_ac         LIKE type_file.num5      #目前處理的ARRAY CNT   #No.FUN-680136 SMALLINT
 
DEFINE g_row_count  LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01      #No.FUN-580031  HCN
DEFINE g_cnt_1      LIKE type_file.num10     #CHI-8C0017
 
MAIN
   DEFINE l_time    LIKE type_file.chr8,     #計算被使用時間    #No.FUN-680136 VARCHAR(8)
          l_sl	    LIKE type_file.num5      #No.FUN-680136 SMALLINT
 
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
 
 
      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
        RETURNING l_time
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW apmq220_w AT p_row,p_col
        WITH FORM "apm/42f/apmq220"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
     #MOD-4B0255
    IF NOT cl_null(g_argv1) THEN
       LET g_action_choice="query"
       IF cl_chk_act_auth() THEN
          CALL q220_q()
       END IF
    END IF
    LET g_action_choice=""
     #MOD-4B0255(end)
 
    CALL q220_menu()
 
    CLOSE WINDOW q220_srn               #結束畫面
    CALL cl_used(g_prog,l_time,2) RETURNING l_time
END MAIN
 
FUNCTION q220_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-680136 SMALLINT
   #No.CHI-8C0017--Begin--#
   DEFINE
    l_pmh  RECORD
            pmh02   LIKE pmh_file.pmh02,
            pmh22   LIKE pmh_file.pmh22     
           END RECORD
   #No.CHI-8C0017--End--#   
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "pmh02 = '",g_argv1,"'"
      LET tm.wc2 = '1=1'
   ELSE
      CLEAR FORM #清除畫面
      CALL g_pmh.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON pmh02,pmc03,pmh22  # 螢幕上取單頭條件      #CHI-8C0017 Add pmh22
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
         IF INT_FLAG THEN RETURN END IF
 
         #資料權限的檢查
         #Begin:FUN-980030
         #         IF g_priv2='4' THEN                           #只能使用自己的資料
         #            LET tm.wc = tm.wc clipped," AND pmhuser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET tm.wc = tm.wc clipped," AND pmhgrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET tm.wc = tm.wc clipped," AND pmhgrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmhuser', 'pmhgrup')
         #End:FUN-980030
 
         CALL q220_b_askkey()
         IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql=" SELECT UNIQUE pmh02,pmh22 FROM pmh_file,pmc_file ", #MOD-7A0205 modify pmc_file   #CHI-8C0017 Add pmh22
             " WHERE ",tm.wc CLIPPED,
	     " AND (pmhacti ='Y' OR pmhacti = 'y') ",
             " AND pmh02=pmc01 ",  #MOD-7A0205 add
#            " AND pmh21 = ' ' ",                                             #CHI-860042   #CHI-8C0017 Mark
#            " AND pmh22 = '1' ",                                             #CHI-860042   #CHI-8C0017 Mark             
             " ORDER BY pmh02"
   PREPARE q220_prepare FROM g_sql
   DECLARE q220_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q220_prepare
   
#CHI-8C0017--Mark--Begin--#
#  LET g_sql=" SELECT COUNT(*) FROM pmh_file,pmc_file ",   #MOD-7A0205 modify
#            " WHERE ",tm.wc CLIPPED,
#            " AND pmh02=pmc01 ",  #MOD-7A0205 add
#            " AND pmh21 = ' ' ",                                             #CHI-860042   
#            " AND pmh22 = '1' ",                                             #CHI-860042   
#            " AND (pmhacti ='Y' OR pmhacti = 'y') "
#  PREPARE q220_pp  FROM g_sql
#  DECLARE q220_cnt   CURSOR FOR q220_pp
#CHI-8C0017--Mark--End--#
   
   LET g_cnt_1 = 0                                                            #CHI-8C0017 
   FOREACH q220_cs INTO l_pmh.*                                               #CHI-8C0017
           LET g_cnt_1 = g_cnt_1 + 1                                          #CHI-8C0017 
	 END FOREACH                                                                #CHI-8C0017   
   
END FUNCTION
 
FUNCTION q220_b_askkey()
   CONSTRUCT tm.wc2 ON pmh01,ima44,pmh12,pmh05,pmh13,pmh21                     #CHI-8C0017 Add pmh21
      ##FROM s_pmh[1].pmh01,s_pmh[1].pmh12,                ##No.FUN-610092
        FROM s_pmh[1].pmh01,s_pmh[1].ima44,s_pmh[1].pmh12, ##No.FUN-610092
             s_pmh[1].pmh05,s_pmh[1].pmh13,s_pmh[1].pmh21                      #CHI-8C0017 Add s_pmh[1].pmh21
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
 
END FUNCTION
 
FUNCTION q220_menu()
 
   WHILE TRUE
      CALL q220_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q220_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q220_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
    CALL q220_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q220_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
#       OPEN q220_cnt                         #CHI-8C0017 Mark
#       FETCH q220_cnt INTO g_row_count       #CHI-8C0017 Mark
        LET g_row_count = g_cnt_1             #CHI-8C0017        
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q220_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q220_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式      #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數    #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q220_cs INTO g_pmc.pmh02,g_pmc.pmh22    #CHI-8C0017 Add g_pmc.pmh22
        WHEN 'P' FETCH PREVIOUS q220_cs INTO g_pmc.pmh02,g_pmc.pmh22    #CHI-8C0017 Add g_pmc.pmh22
        WHEN 'F' FETCH FIRST    q220_cs INTO g_pmc.pmh02,g_pmc.pmh22    #CHI-8C0017 Add g_pmc.pmh22
        WHEN 'L' FETCH LAST     q220_cs INTO g_pmc.pmh02,g_pmc.pmh22    #CHI-8C0017 Add g_pmc.pmh22
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
            FETCH ABSOLUTE l_abso q220_cs INTO g_pmc.pmh02,g_pmc.pmh22    #CHI-8C0017 Add g_pmc.pmh22
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmc.pmh02,SQLCA.sqlcode,0)
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
    SELECT pmc03 INTO g_pmc.pmc03 FROM pmc_file WHERE pmc01 = g_pmc.pmh02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_pmc.pmh02,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pmc_file",g_pmc.pmh02,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
 
    CALL q220_show()
END FUNCTION
 
FUNCTION q220_show()
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q220_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q220_b_fill()              #BODY FILL UP
   DEFINE l_sql1    LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(1000) 
          l_sql2    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
    LET l_sql1 =                                   #供應商對料件資料
       ## "SELECT pmh01,ima02,ima021,pmh12,pmh05,pmh13",     ##No.FUN-610092
        "SELECT pmh01,ima02,ima021,ima44,pmh12,pmh05,pmh13,pmh21", ##No.FUN-610092   #CHI-8C0017 Add pmh21
        " FROM pmh_file,ima_file",
        " WHERE ",
        " pmh02 ='",g_pmc.pmh02 ,"'",
        "  AND ima01 = pmh01 ",
        "  AND pmh22 ='",g_pmc.pmh22 ,"'",                                           #CHI-8C0017
        "  AND pmh23 = ' '",                                             #No.CHI-960033
#       "  AND pmh21 = ' ' ",                                            #CHI-860042 #CHI-8C0017 Mark  
#       "  AND pmh22 = '1' ",                                            #CHI-860042 #CHI-8C0017 Mark        
        " AND (pmhacti ='Y' OR pmhacti = 'y') ",
        "  AND ",tm.wc2 CLIPPED,
        " ORDER BY 2 "
    PREPARE q220_pb FROM l_sql1
    DECLARE q220_bcs                       #BODY CURSOR
        CURSOR FOR q220_pb
 
    CALL g_pmh.clear()
 
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q220_bcs INTO g_pmh[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_pmh[g_cnt].pmh12 IS NULL THEN
           LET g_pmh[g_cnt].pmh12 = 0
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_pmh.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2                     #CHI-8C0017
 
END FUNCTION
 
FUNCTION q220_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmh TO s_pmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION first
         CALL q220_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q220_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q220_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q220_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q220_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
 
