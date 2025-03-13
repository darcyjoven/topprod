# Prog. Version..: '5.30.06-13.03.19(00009)'     #
#
# Pattern name...: apmq234.4gl
# Descriptions...: 廠商核價資料查詢
# Date & Author..: 97/08/29 By Kitty
# Modify.........: No.MOD-480482 04/09/15 By Smapmin調整為可以顯示上下筆之功能
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增廠商編號開窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-610018 06/01/10 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-610094 06/09/08 By kim 新增採購單位欄位顯示
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray “匯出EXCEL”輸出的值多出一空白行
# Modify.........: No.MOD-710193 07/02/07 By claire 以單身做查詢會查出多筆異常資料
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860328 07/06/30 By claire 調整單身可查詢
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-8A0083 08/10/08 By Smapmin 單頭廠商代號下QBE條件無法顯示資料
# Modify.........: No.CHI-8C0014 09/01/04 By xiaofeizhu 加入價格型態與作業編號兩個欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70048 10/08/12 By Summer 在pmi02的後面加上pmi05的顯示
# Modify.........: No:CHI-C10044 12/08/16 By jt_chen 單身增加幣別欄位
# Modify.........: No:FUN-CC0062 13/03/18 By Elise 將單頭廠商欄位拉到單身並開放查詢
# Modify.........: No:MOD-DC0002 13/12/02 By SunLM 将品名和规格显示出来
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
       	wc      LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(500) 
       	wc2  	LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(500) 
        END RECORD,
   #FUN-CC0062---mark---S
   #g_pmc   RECORD
   #    pmc01	LIKE pmc_file.pmc01,
   #    pmc03	LIKE pmc_file.pmc03,
   #    pmj12 LIKE pmj_file.pmj12         #No.CHI-8C0014 add
   #    END RECORD,
   #FUN-CC0062---mark---E
    g_pmj DYNAMIC ARRAY OF RECORD
            pmj12   LIKE pmj_file.pmj12,  #FUN-CC0062 add
            pmj03   LIKE pmj_file.pmj03,
            pmj031  LIKE pmj_file.pmj031, #MOD-DC0002
            pmj032  LIKE pmj_file.pmj032, #MOD-DC0002
            pmj04   LIKE pmj_file.pmj04,
            pmc01   LIKE pmc_file.pmc01,  #FUN-CC0062 add
            pmc03   LIKE pmc_file.pmc03,  #FUN-CC0062 add
            pmi02   LIKE pmi_file.pmi02,
            pmi05   LIKE pmi_file.pmi05,  #CHI-A70048 add
            ima44   LIKE ima_file.ima44,  #No.FUN-610094            
            pmj10   LIKE pmj_file.pmj10,  #No.CHI-8C0014 add
            pmj05   LIKE pmj_file.pmj05,  #CHI-C10044 add
            pmj06   LIKE pmj_file.pmj06,
            #No.FUN-610018
            pmj06t  LIKE pmj_file.pmj06t,
            pmj07   LIKE pmj_file.pmj07,
            pmj07t  LIKE pmj_file.pmj07t,
            pmj08   LIKE pmj_file.pmj08,
            pmj09   LIKE pmj_file.pmj09
    END RECORD,
    g_argv1         LIKE pmc_file.pmc01,
    g_query_flag    LIKE type_file.num5,         #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10,        #No.FUN-680136 INTEGER  #單身筆數
    p_row,p_col     LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_cnt      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_msg      LIKE ze_file.ze03,           #No.FUN-680136 VARCHAR(72) 
         l_ac       LIKE type_file.num5          #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_cnt_1        LIKE type_file.num10     #CHI-8C0014
 
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
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q234_w AT p_row,p_col
        WITH FORM "apm/42f/apmq234"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q234_q() END IF
    CALL q234_menu()
    CLOSE WINDOW q234_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q234_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680136 SMALLINT #FUN-CC0062 remove ,
   #FUN-CC0062---mark---S 
   #l_pmc   RECORD                              #No.CHI-8C0014 add
   #        pmc01	LIKE pmc_file.pmc01,          #No.CHI-8C0014 add
   #        pmj12 LIKE pmj_file.pmj12           #No.CHI-8C0014 add
   #        END RECORD                          #No.CHI-8C0014 add
   #FUN-CC0062---mark---E
   
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmc01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_pmj.clear()
         CALL cl_opmsg('q')
         INITIALIZE tm.* TO NULL			# Default condition
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
  #INITIALIZE g_pmc.* TO NULL    #No.FUN-750051 #FUN-CC0062 mark
        #FUN-CC0062---mark---S
        #CONSTRUCT BY NAME tm.wc ON pmc01,pmc03
        #       ,pmj03,pmi02,pmi05,pmj12,pmj10,pmj05,pmj06,pmj06t,pmj07,pmj07t,pmj08,pmj09,pmj04   #MOD-710193 add  #CHI-8C0014 Add pmj12,pmj10 #CHI-A70048 add pmi05 #CHI-C10044 add pmj05
        #     #No.FUN-580031 --start--     HCN
        #FUN-CC0062---mark---E
        #FUN-CC0062---S
         CONSTRUCT BY NAME tm.wc ON pmj12,pmj03,pmc01,pmc03,pmj04,
                                    pmi02,pmi05,pmj10,pmj05,pmj06,
                                    pmj06t,pmj07,pmj07t,pmj08,pmj09
        #FUN-CC0062---E

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
            #--No.FUN-4B0022-------
            ON ACTION CONTROLP
              CASE WHEN INFIELD(pmc01)      #廠商編號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state= "c"
                        LET g_qryparam.form = "q_pmc"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmc01
                        NEXT FIELD pmc01
              OTHERWISE EXIT CASE
              END CASE
            #--END---------------
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
 
         #CALL q234_b_askkey()  #MOD-710193 mark  
         IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   #MOD-710193-add
   #LET g_sql=" SELECT pmc01 FROM pmc_file ",
   #          " WHERE ",tm.wc CLIPPED,
   #          " ORDER BY pmc01"
#FUN-CC0062---mark---S
#  LET g_sql=" SELECT UNIQUE pmc01,pmj12 FROM pmc_file,pmj_file,pmi_file ",       #CHI-8C0014 Add pmj12
#            "  WHERE ",tm.wc CLIPPED,
#            "    AND  pmi01=pmj01 AND pmiconf='Y' ",
#            "    AND  pmi03= pmc01 ",
#            "    AND  pmj10 = ' ' ",                           #CHI-860042       #CHI-8C0014 Mark                                                   
#            "    AND  pmj12 = '1' ",                           #CHI-860042       #CHI-8C0014 Mark
#           #"    AND ",tm.wc2 CLIPPED,   
#            "  ORDER BY pmc01"
#  #MOD-710193-add
#  PREPARE q234_prepare FROM g_sql
#  DECLARE q234_cs                         #SCROLL CURSOR
#          SCROLL CURSOR FOR q234_prepare
#FUN-CC0062---mark---E
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   #MOD-710193-add
   #LET g_sql=" SELECT COUNT(*) FROM pmc_file ",
   #           " WHERE ",tm.wc CLIPPED
   #CHI-8C0014 --Begin--#
#  LET g_sql=" SELECT COUNT(UNIQUE pmc01) FROM pmc_file,pmj_file,pmi_file ",
#            "  WHERE ",tm.wc CLIPPED,
#            "    AND  pmi01=pmj01 AND pmiconf='Y' ",
#            "    AND  pmi03= pmc01 ",
#            "    AND  pmj10 = ' ' ",                           #CHI-860042       #CHI-8C0014 Mark                                                      
#            "    AND  pmj12 = '1' ",                           #CHI-860042       #CHI-8C0014 Mark 
#           #"    AND ",tm.wc2 CLIPPED,   
#            "  ORDER BY pmc01"
   #MOD-710193-add
#  PREPARE q234_pp  FROM g_sql
#  DECLARE q234_cnt   CURSOR FOR q234_pp
 
   #FUN-CC0062---mark---S
   #LET g_cnt_1 = 0
   #FOREACH q234_cs INTO l_pmc.*
   #        LET g_cnt_1 = g_cnt_1 + 1
   #      END FOREACH
   #FUN-CC0062---mark---S
 
   #CHI-8C0014 --End--#
END FUNCTION
 
#MOD-710193 mark-add
#FUNCTION q234_b_askkey()
#   CONSTRUCT tm.wc2 ON pmj03,pmi02,pmj06,pmj06t,pmj07,pmj07t,pmj08,pmj09,pmj04  #No.FUN-610018
#                  FROM s_pmj[1].pmj03,s_pmj[1].pmi02,s_pmj[1].pmj06,
#                       s_pmj[1].pmj06t,s_pmj[1].pmj07,
#                       s_pmj[1].pmj07t,s_pmj[1].pmj08,s_pmj[1].pmj09,
#                       s_pmj[1].pmj04
#              #No.FUN-580031 --start--     HCN
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#              #No.FUN-580031 --end--       HCN
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#		#No.FUN-580031 --start--     HCN
#                 ON ACTION qbe_select
#         	   CALL cl_qbe_select()
#                 ON ACTION qbe_save
#		   CALL cl_qbe_save()
#		#No.FUN-580031 --end--       HCN
#   END CONSTRUCT
# 
#END FUNCTION
#MOD-710193 mark-add
 
FUNCTION q234_menu()
 
   WHILE TRUE
      CALL q234_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q234_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmj),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q234_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q234_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   #OPEN q234_cs                            # 從DB產生合乎條件TEMP(0-30秒) #FUN-CC0062 mark
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
#           OPEN q234_cnt                                 #CHI-8C0014 Mark
#           FETCH q234_cnt INTO g_row_count #MOD-480482   #CHI-8C0014 Mark
       #FUN-CC0062---mark---S
       #    LET g_row_count = g_cnt_1                     #CHI-8C0014
       #    DISPLAY g_row_count TO cnt  #MOD-480482
       #CALL q234_fetch('F')                  # 讀出TEMP第一筆並顯示
       #FUN-CC0062---mark---E
    END IF
	MESSAGE ''
    CALL q234_show()  #FUN-CC0062 add
END FUNCTION
 
#FUN-CC0062---mark---S
#FUNCTION q234_fetch(p_flag)
#DEFINE
#    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
#    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
# 
#    CASE p_flag
#        WHEN 'N' FETCH NEXT     q234_cs INTO g_pmc.pmc01,g_pmc.pmj12 #MOD-710193 modify  #CHI-8C0014 Add pmj12
#        WHEN 'P' FETCH PREVIOUS q234_cs INTO g_pmc.pmc01,g_pmc.pmj12 #MOD-710193 modify  #CHI-8C0014 Add pmj12
#        WHEN 'F' FETCH FIRST    q234_cs INTO g_pmc.pmc01,g_pmc.pmj12 #MOD-710193 modify  #CHI-8C0014 Add pmj12
#        WHEN 'L' FETCH LAST     q234_cs INTO g_pmc.pmc01,g_pmc.pmj12 #MOD-710193 modify  #CHI-8C0014 Add pmj12 
#        WHEN '/'
#             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#            LET INT_FLAG = 0  ######add for prompt bug
#             PROMPT g_msg CLIPPED,': ' FOR l_abso
#                ON IDLE g_idle_seconds
#                   CALL cl_on_idle()
##                   CONTINUE PROMPT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#             END PROMPT
#            IF INT_FLAG THEN
#                LET INT_FLAG = 0
#                EXIT CASE
#            END IF
#            FETCH ABSOLUTE l_abso q234_cs INTO g_pmc.pmc01,g_pmc.pmj12 #MOD-710193 modify  #CHI-8C0014 Add pmj12
#    END CASE
# 
#    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
#        INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
#        RETURN
#    ELSE
#       CASE p_flag
#          WHEN 'F' LET g_curs_index = 1
#          WHEN 'P' LET g_curs_index = g_curs_index - 1
#          WHEN 'N' LET g_curs_index = g_curs_index + 1
#          WHEN 'L' LET g_curs_index = g_row_count
#          WHEN '/' LET g_curs_index = l_abso
#       END CASE
# 
#       CALL cl_navigator_setting( g_curs_index, g_row_count )
#    END IF
#	SELECT pmc01,pmc03
#	  INTO g_pmc.pmc01,g_pmc.pmc03
#	  FROM pmc_file
#	#WHERE pmc01 = g_pmc.pmc01  #MOD-710193 mark
#	 WHERE pmc01 =g_pmc.pmc01   #MOD-710193
#    IF SQLCA.sqlcode THEN
#    #   CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
#        CALL cl_err3("sel","pmc_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660129
#        RETURN
#    END IF
# 
#    CALL q234_show()
#END FUNCTION
#FUN-CC0062---mark---E
 
FUNCTION q234_show()
  #DISPLAY BY NAME g_pmc.*   # 顯示單頭值 #FUN-CC0062 mark
   CALL q234_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q234_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
       #"SELECT pmj03,pmj04,pmi02,pmi05,'',pmj10,pmj05,pmj06,pmj06t,pmj07,pmj07t,pmj08,pmj09",  #No.FUN-610018  #CHI-8C0014 Add pmj10 #CHI-A70048 add pmi05  #CHI-C10044 add pmj05 #FUN-CC0062 mark
        "SELECT pmj12,pmj03,pmj031,pmj032,pmc01,pmc03,pmj04,pmi02,pmi05,'',pmj10,pmj05,pmj06,pmj06t,pmj07,pmj07t,pmj08,pmj09",   #FUN-CC0062 add pmj12,pmc01,pmc03 #add pmj031,032 #MOD-DC0002
        "  FROM pmc_file,pmi_file,pmj_file ",   #MOD-8A0083加入pmc_file
        " WHERE pmi01=pmj01 AND pmiconf='Y' AND ",
#       "       pmi03= '",g_pmc.pmc01,"' AND  ",tm.wc CLIPPED, #MOD-860328 modify tm.wc2->tm.wc #FUN-CC0062 mark
        "       pmi03= pmc01 AND ",tm.wc CLIPPED,             #FUN-CC0062
        "       AND ",tm.wc CLIPPED,                          #FUN-CC0062
	"   AND pmi03 = pmc01 ",   #MOD-8A0083
#       "   AND pmj10 = ' ' ",                           #CHI-860042     #CHI-8C0014 Mark                                                            
#       "   AND pmj12 = '1' ",                           #CHI-860042     #CHI-8C0014 Mark
        " ORDER BY pmj03 DESC"
    PREPARE q234_pb FROM l_sql
    DECLARE q234_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q234_pb
 
    FOR g_cnt = 1 TO g_pmj.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_pmj[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q234_bcs INTO g_pmj[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #FUN-610094...............begin
        LET g_pmj[g_cnt].ima44=NULL 
        SELECT ima44 INTO g_pmj[g_cnt].ima44 FROM ima_file
                                            WHERE ima01=g_pmj[g_cnt].pmj03
        #FUN-610094...............end
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_pmj.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
   #FUN-CC0062---add---S
    LET g_row_count = g_rec_b
    DISPLAY g_row_count TO cnt
   #FUN-CC0062---add---E
  #     DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q234_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmj TO s_pmj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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

     #FUN-CC0062---mark---S
     #ON ACTION first
     #   CALL q234_fetch('F')
     #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     #     IF g_rec_b != 0 THEN
     #   CALL fgl_set_arr_curr(1)  ######add in 040505
     #     END IF
     #     ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
     #ON ACTION previous
     #   CALL q234_fetch('P')
     #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     #     IF g_rec_b != 0 THEN
     #   CALL fgl_set_arr_curr(1)  ######add in 040505
     #     END IF
     #  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
     #ON ACTION jump
     #   CALL q234_fetch('/')
     #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     #     IF g_rec_b != 0 THEN
     #   CALL fgl_set_arr_curr(1)  ######add in 040505
     #     END IF
     #  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
     #ON ACTION next
     #   CALL q234_fetch('N')
     #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     #     IF g_rec_b != 0 THEN
     #   CALL fgl_set_arr_curr(1)  ######add in 040505
     #     END IF
     #  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
     #ON ACTION last
     #   CALL q234_fetch('L')
     #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     #     IF g_rec_b != 0 THEN
     #   CALL fgl_set_arr_curr(1)  ######add in 040505
     #     END IF
     #  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
     #FUN-CC0062---mark---E
 
 
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
 
