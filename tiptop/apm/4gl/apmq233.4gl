# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmq233.4gl
# Descriptions...: 廠商/料件資料查詢
# Date & Author..: 97/08/29 By Kitty
# Modify.........: No.MOD-480481 04/09/15 By Smapmin調整為可以顯示上下筆之功能
# Modify.........: No.FUN-4A0074 04/10/11 By Carol 查詢時 =>廠商/料件資料應可查詢
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-610018 06/01/10 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610092 06/05/05 By Joe 新增採購單位欄位顯示
# Modify.........: No.FUN-660129 06/06/20 By cl  cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-910061 09/01/07 By Smapmin 單頭不下查詢條件在單身下查詢條件,會把所有的資料都查詢出來
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-9A0124 09/10/24 By lilingyu 改寫sql的標準寫法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500) 
       	wc2  	LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500) 
        END RECORD,
    g_pmc   RECORD
        pmc01	LIKE pmc_file.pmc01,
        pmc03	LIKE pmc_file.pmc03,
        pmh22 LIKE pmh_file.pmh22               #No.CHI-8C0017
        END RECORD,
    g_pmh DYNAMIC ARRAY OF RECORD
            pmh01   LIKE pmh_file.pmh01,
            pmh04   LIKE pmh_file.pmh04,
            pmh08   LIKE pmh_file.pmh08,
            pmh09   LIKE pmh_file.pmh09,
            pmh06   LIKE pmh_file.pmh06,
            pmh13   LIKE pmh_file.pmh13,
            pmh21   LIKE pmh_file.pmh21,        #No.CHI-8C0017
            #No.FUN-610018 --start--
            pmh17   LIKE pmh_file.pmh17,
            pmh18   LIKE pmh_file.pmh18,
            ima44   LIKE ima_file.ima44,  ##No.FUN-610092
            pmh12   LIKE pmh_file.pmh12,
            pmh19   LIKE pmh_file.pmh19,
            #No.FUN-610018 --start--
            pmh11   LIKE pmh_file.pmh11,
            pmh05   LIKE pmh_file.pmh05
    END RECORD,
    g_argv1         LIKE pmc_file.pmc01,
    g_query_flag    LIKE type_file.num5,         #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
     g_sql string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10         #No.FUN-680136 INTEGER  #單身筆數
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,           #No.FUN-680136 VARCHAR(72) 
       l_ac         LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680136 SMALLINT
 
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_cnt_1      LIKE type_file.num10         #CHI-8C0017
 
MAIN
   DEFINE l_time    LIKE type_file.chr8,         #計算被使用時間 #No.FUN-680136 VARCHAR(8)
          l_sl	    LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
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
    LET g_query_flag =1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q233_w AT p_row,p_col
        WITH FORM "apm/42f/apmq233"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q233_q() END IF
    CALL q233_menu()
    CLOSE WINDOW q233_w
      CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
        RETURNING l_time
END MAIN
 
#QBE 查詢資料
FUNCTION q233_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
   #No.CHI-8C0017--Begin--#
   DEFINE
    l_pmc   RECORD
#        rowi	LIKE type_file.chr1000,  #TQC-9A0124
        pmc01	LIKE pmc_file.pmc01,
        pmh22 LIKE pmh_file.pmh22               
        END RECORD   
   #No.CHI-8C0017--End--#   
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "pmc01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
      CALL g_pmh.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON pmc01,pmc03,pmh22                   #CHI-8C0017 Add pmh22
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
 
 
#FUN-4A0074
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(pmc01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_pmc2"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pmc01
               END CASE
##
 
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
 
         CALL q233_b_askkey()
         IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   #-----MOD-910061---------
   #LET g_sql=" SELECT UNIQUE pmc_file.pmc01,pmh22 FROM pmc_file,pmh_file ",    #CHI-8C0017 Add UNIQUE pmh22,pmh_file
   #          " WHERE ",tm.wc CLIPPED,
   #          "    AND pmh02=pmc01 ",                                          #CHI-8C0017 Add
   #          " ORDER BY pmc01"
   IF tm.wc2 = " 1=1" THEN   
      LET g_sql=" SELECT UNIQUE pmc_file.pmc01,pmh22 FROM pmc_file,pmh_file ",    
                " WHERE ",tm.wc CLIPPED,
                "    AND pmh02=pmc01 ",
                "    AND pmhacti = 'Y'",                                           #CHI-910021                                         
                " ORDER BY pmc01"
   ELSE
      LET g_sql=" SELECT UNIQUE pmc_file.pmc01,pmh22 FROM pmc_file,pmh_file ",  
                " WHERE ",tm.wc CLIPPED,
                "    AND pmh02=pmc01 ",                                          
                "    AND pmc01||pmh22 IN ",
                "    (SELECT pmh02||pmh22 FROM pmh_file,ima_file ", 
                "       WHERE pmh01= ima01 ",   
                "         AND  ",tm.wc2 CLIPPED,") ",
                "    AND pmhacti = 'Y'",                                           #CHI-910021
                " ORDER BY pmc01"
   END IF
   #-----END MOD-910061-----
   PREPARE q233_prepare FROM g_sql
   DECLARE q233_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q233_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
 
#CHI-8C0017--Mark--Begin--#   
#  LET g_sql=" SELECT COUNT(*) FROM pmc_file ",        
#             " WHERE ",tm.wc CLIPPED,
#  PREPARE q233_pp  FROM g_sql
#  DECLARE q233_cnt   CURSOR FOR q233_pp
#CHI-8C0017--Mark--End--#
   
   LET g_cnt_1 = 0                                                            #CHI-8C0017 
   FOREACH q233_cs INTO l_pmc.*                                               #CHI-8C0017
           LET g_cnt_1 = g_cnt_1 + 1                                          #CHI-8C0017 
	 END FOREACH                                                                #CHI-8C0017   
   
END FUNCTION
 
FUNCTION q233_b_askkey()
 ##CONSTRUCT tm.wc2 ON pmh01,pmh04,pmh08,pmh09,pmh06,pmh13,pmh17,pmh18,pmh12,pmh19,pmh11,pmh05  #No.FUN-610018 ##No.FUN-610092
   CONSTRUCT tm.wc2 ON pmh01,pmh04,pmh08,pmh09,pmh06,pmh13,pmh21,pmh17,pmh18,ima44,pmh12,pmh19,pmh11,pmh05  #No.FUN-610092 #CHI-8C0017 Add pmh21
                  FROM s_pmh[1].pmh01,s_pmh[1].pmh04,s_pmh[1].pmh08,
                       s_pmh[1].pmh09,s_pmh[1].pmh06,s_pmh[1].pmh13,s_pmh[1].pmh21,                         #CHI-8C0017 Add s_pmh[1].pmh21
                  ##   s_pmh[1].pmh17,s_pmh[1].pmh18,s_pmh[1].pmh12, ##No.FUN-610092
                       s_pmh[1].pmh17,s_pmh[1].pmh18,s_pmh[1].ima44,s_pmh[1].pmh12, ##No.FUN-610092
                       s_pmh[1].pmh19,s_pmh[1].pmh11,s_pmh[1].pmh05
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
 
 
#FUN-4A0074
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(pmh01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_ima"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmh01
        END CASE
##
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
END FUNCTION
 
FUNCTION q233_menu()
 
   WHILE TRUE
      CALL q233_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q233_q()
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
 
FUNCTION q233_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q233_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q233_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
#       OPEN q233_cnt                                     #CHI-8C0017 Mark
#       FETCH q233_cnt INTO g_row_count #MOD-480481       #CHI-8C0017 Mark
        LET g_row_count = g_cnt_1                         #CHI-8C0017         
         DISPLAY g_row_count TO cnt  #MOD-480481
        CALL q233_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q233_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q233_cs INTO g_pmc.pmc01,g_pmc.pmh22                    #CHI-8C0017 Add g_pmc.pmh22
        WHEN 'P' FETCH PREVIOUS q233_cs INTO g_pmc.pmc01,g_pmc.pmh22                    #CHI-8C0017 Add g_pmc.pmh22
        WHEN 'F' FETCH FIRST    q233_cs INTO g_pmc.pmc01,g_pmc.pmh22                    #CHI-8C0017 Add g_pmc.pmh22
        WHEN 'L' FETCH LAST     q233_cs INTO g_pmc.pmc01,g_pmc.pmh22                    #CHI-8C0017 Add g_pmc.pmh22
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
            FETCH ABSOLUTE l_abso q233_cs INTO g_pmc.pmc01,g_pmc.pmh22                    #CHI-8C0017 Add g_pmc.pmh22
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
    #   CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660129
        RETURN
    END IF
 
    CALL q233_show()
END FUNCTION
 
FUNCTION q233_show()
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q233_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q233_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
      ##"SELECT pmh01,pmh04,pmh08,pmh09,pmh06,pmh13,pmh17,pmh18,pmh12,pmh19,pmh11,pmh05",  ##No.FUN-610092
        "SELECT pmh01,pmh04,pmh08,pmh09,pmh06,pmh13,pmh21,pmh17,pmh18,ima44,pmh12,pmh19,pmh11,pmh05",    #CHI-8C0017 Add pmh21
        "  FROM pmh_file,ima_file ",
        " WHERE pmh01= ima01 ",   ##No.FUN-610092
        "   AND pmh02= '",g_pmc.pmc01,"' AND  ",tm.wc2 CLIPPED,
        "   AND pmh22= '",g_pmc.pmh22,"' ",                                                #CHI-8C0017
        "   AND pmh23 = ' '",                                             #No.CHI-960033
        "   AND pmhacti = 'Y'",                                           #CHI-910021
#       "   AND pmh21 = ' ' ",                                            #CHI-860042      #CHI-8C0017 Mark  
#       "   AND pmh22 = '1' ",                                            #CHI-860042      #CHI-8C0017 Mark        
        " ORDER BY pmh01 DESC"
    PREPARE q233_pb FROM l_sql
    DECLARE q233_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q233_pb
 
    #-----MOD-910061---------
    #FOR g_cnt = 1 TO g_pmh.getLength()           #單身 ARRAY 乾洗
    #   INITIALIZE g_pmh[g_cnt].* TO NULL
    #END FOR
    CALL g_pmh.clear()  
    #-----END MOD-910061-----
    LET g_cnt = 1
    FOREACH q233_bcs INTO g_pmh[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_pmh.deleteElement(g_cnt)   #MOD-910061
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
  #     DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_rec_b TO FORMONLY.cn2             #CHI-8C0017  
END FUNCTION
 
FUNCTION q233_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmh TO s_pmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q233_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q233_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q233_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q233_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q233_fetch('L')
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
 
