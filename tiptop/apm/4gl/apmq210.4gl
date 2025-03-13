# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmq210.4gl
# Descriptions...: 料件供應商查詢
# Date & Author..: 92/03/19 BY MAY
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmq210時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: No.MOD-4B0292 04/11/26 By Mandy 1.查詢後,有資料show出,可是第一筆上筆指定筆下筆末一筆的BUTTOM卻不可按
# Modify.........: No.MOD-4B0292                   2.單身筆數無show出
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-610092 06/05/05 By Joe 增加採購單位欄位
# Modify.........: No.FUN-660129 06/06/20 By czl  cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能 
# Modify.........: No.TQC-6B0159 06/11/29 By Ray “匯出EXCEL”輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-910065 09/01/07 By Smapmin 清空單身array
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-9A0124 09/10/26 By lilingyu 改寫sql的標準寫法
# Modify.........: No.TQC-B40071 11/04/13 By lilingyu "料號"欄位開窗第一頁資料全選,確定後報錯-404 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
            wc  	STRING,    #No.FUN-680136 VARCHAR(500)   #TQC-B40071 chr1000->STRING
      	    wc2  	STRING     #No.FUN-680136 VARCHAR(500)   #TQC-B40071 chr1000->STRING
        END RECORD,
    g_ima  RECORD
            ima01	LIKE ima_file.ima01,
            ima02	LIKE ima_file.ima02,
            ima021      LIKE ima_file.ima021,
            ima06	LIKE ima_file.ima06,
            pmh22       LIKE pmh_file.pmh22,        #No.CHI-8C0017
            ima44       LIKE ima_file.ima44         #No.FUN-610092
        END RECORD,
    g_pmh DYNAMIC ARRAY OF RECORD
            pmh02       LIKE pmh_file.pmh02,
            pmc03       LIKE pmc_file.pmc03,
            pmh04       LIKE pmh_file.pmh04,
            pmh08       LIKE pmh_file.pmh08,
            pmh09       LIKE pmh_file.pmh09,
            pmh13       LIKE pmh_file.pmh13,
            pmh21       LIKE pmh_file.pmh21,        #No.CHI-8C0017
            pmh12       LIKE pmh_file.pmh12,
            pmh11       LIKE pmh_file.pmh11,
            pmh05       LIKE pmh_file.pmh05
        END RECORD,
    g_argv1             LIKE ima_file.ima01,       # INPUT ARGUMENT - 1
    g_argv2             LIKE pmh_file.pmh02,       #MOD-4B0255
    g_wc,g_wc2          string,                    #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql               string,                    #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5   	   #單身筆數        #No.FUN-680136 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5        #No.FUN-680136 SMALLINT
DEFINE g_cnt            LIKE type_file.num10       #No.FUN-680136 INTEGER
DEFINE g_msg            LIKE ze_file.ze03,         #No.FUN-680136 VARCHAR(72) 
       l_ac             LIKE type_file.num5        #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
DEFINE g_row_count      LIKE type_file.num10       #No.FUN-680136 INTEGER
DEFINE g_curs_index     LIKE type_file.num10       #No.FUN-680136 INTEGER
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01        #No.FUN-580031 HCN
DEFINE g_cnt_1          LIKE type_file.num10       #CHI-8C0017
 
MAIN
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
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
     LET g_argv2      = ARG_VAL(2)          #參數值(2) 廠商編號 #MOD-4B0255
 
    OPEN WINDOW apmq210_w WITH FORM "apm/42f/apmq210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
     IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN #MOD-4B0255
        LET g_action_choice="query"                       #MOD-4B0255
       IF cl_chk_act_auth() THEN
          CALL q210_q()
       END IF
    END IF
## --
     LET g_action_choice="" #MOD-4B0255
    CALL q210_menu()
    CLOSE WINDOW q210_srn               #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q210_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
   #No.CHI-8C0017--Begin--#
   DEFINE
    l_ima  RECORD
#            rowi  LIKE type_file.chr1000,    #TQC-9A0124
            ima01	 LIKE ima_file.ima01,       
            pmh22  LIKE pmh_file.pmh22        
           END RECORD   
   #No.CHI-8C0017--End--#   
 
   #IF NOT cl_null(g_argv1) AND g_argv1 IS NOT NULL      #MOD-4B0255改寫如下段
  #   THEN LET tm.wc = "ima01 = '",g_argv1,"'"
  #        LET tm.wc2 = '1=1'
   #MOD-4B0255
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
       LET tm.wc  = ' 1=1'
       LET tm.wc2 = ' 1=1'
       IF NOT cl_null(g_argv1) THEN
           LET tm.wc = "ima01 = '",g_argv1,"'"
       END IF
       IF NOT cl_null(g_argv2) THEN
           LET tm.wc2 = "pmh02 = '",g_argv2,"'"
       END IF
   #MOD-4B0255(end)
   ELSE
         CLEAR FORM #清除畫面
         CALL g_pmh.clear()
         CALL cl_opmsg('q')
         INITIALIZE tm.* TO NULL			# Default condition
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
                   ima01,ima02,ima021,ima06,pmh22     #CHI-8C0017 Add pmh22
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_ima.ima01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
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
         #            LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
         #End:FUN-980030
 
         CALL q210_b_askkey()
         IF INT_FLAG THEN RETURN END IF
   END IF
 
#CHI-8C0017--Begin--#
 #MOD-4B0255
#IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
#   LET g_sql=" SELECT UNIQUE ima_file.ima01 FROM ima_file ,pmh_file",
#             " WHERE ",tm.wc CLIPPED,
#             "   AND ",tm.wc2,
#	     "   AND (imaacti ='Y' OR imaacti = 'y') ",
#             "   AND ima01 = pmh01 ",
#             "   AND pmh21 = ' ' ",                                            #CHI-860042 
#             "   AND pmh22 = '1' ",                                            #CHI-860042
#             " ORDER BY ima_file.ima01"
#ELSE
#   LET g_sql=" SELECT ima01 FROM ima_file ",
#             " WHERE ",tm.wc CLIPPED,
#	     " AND (imaacti ='Y' OR imaacti = 'y') ",
#             " ORDER BY ima01"
#END IF
 #MOD-4B0255(end)
 
   LET g_sql=" SELECT UNIQUE ima_file.ima01,pmh22 FROM ima_file ,pmh_file",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2,
	           "   AND (imaacti ='Y' OR imaacti = 'y') ",
             "   AND ima01 = pmh01 ",
             "   AND pmhacti = 'Y'",                                           #CHI-910021
             " ORDER BY ima_file.ima01"
#CHI-8C0017--End--# 
 
   PREPARE q210_prepare FROM g_sql
   DECLARE q210_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q210_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
 #MOD-4B0255
 
#CHI-8C0017--Begin--#   
 #MOD-4B0255
#IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
#   LET g_sql=" SELECT count(unique ima01) FROM ima_file ,pmh_file",
#             " WHERE ",tm.wc CLIPPED,
#             "   AND ",tm.wc2,
#	     "   AND (imaacti ='Y' OR imaacti = 'y') ",
#             "   AND ima01 = pmh01 ",
#             "   AND pmh21 = ' ' ",                                           #CHI-860042
#             "   AND pmh22 = '1' "                                            #CHI-860042 
#ELSE
#   LET g_sql=" SELECT COUNT(*) FROM ima_file ",
#             " WHERE ",tm.wc CLIPPED,
#	     " AND (imaacti ='Y' OR imaacti = 'y') "
#END IF
 #MOD-4B0255(end)
    LET g_cnt_1 = 0
    FOREACH q210_cs INTO l_ima.*
            LET g_cnt_1 = g_cnt_1 + 1
	  END FOREACH 
 
#CHI-8C0017--End--#
 
#  PREPARE q210_pp  FROM g_sql                                                  #CHI-8C0017 Mark
#  DECLARE q210_cnt   CURSOR FOR q210_pp                                        #CHI-8C0017 Mark 
END FUNCTION
 
FUNCTION q210_b_askkey()
   CONSTRUCT tm.wc2 ON pmh02 FROM s_pmh[1].pmh02
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
 
FUNCTION q210_menu()
 
   WHILE TRUE
      CALL q210_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q210_q()
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
 
FUNCTION q210_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q210_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q210_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
#          OPEN q210_cnt                          #CHI-8C0017 Mark           
          #FETCH q210_cnt INTO g_cnt
          #DISPLAY g_cnt TO cnt
           #MOD-4B0292
#          FETCH q210_cnt INTO g_row_count        #CHI-8C0017 Mark
           LET g_row_count = g_cnt_1              #CHI-8C0017           
           DISPLAY g_row_count TO FORMONLY.cnt
           #MOD-4B0292(end)
        CALL q210_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q210_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q210_cs INTO g_ima.ima01,g_ima.pmh22             #CHI-8C0017 Add g_ima.pmh22
        WHEN 'P' FETCH PREVIOUS q210_cs INTO g_ima.ima01,g_ima.pmh22             #CHI-8C0017 Add g_ima.pmh22
        WHEN 'F' FETCH FIRST    q210_cs INTO g_ima.ima01,g_ima.pmh22             #CHI-8C0017 Add g_ima.pmh22
        WHEN 'L' FETCH LAST     q210_cs INTO g_ima.ima01,g_ima.pmh22             #CHI-8C0017 Add g_ima.pmh22
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
            FETCH ABSOLUTE l_abso q210_cs INTO g_ima.ima01,g_ima.pmh22             #CHI-8C0017 Add g_ima.pmh22
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
	SELECT ima01, ima02,  ima021, ima06, ima44
#   INTO g_ima.*                                                                      #CHI-8C0017 Mark
    INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima06,g_ima.ima44                 #CHI-8C0017	  
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
 
    CALL q210_show()
END FUNCTION
 
FUNCTION q210_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q210_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q210_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   LET l_sql =
        "SELECT pmh02,pmc03,pmh04,pmh08,pmh09,pmh13,pmh21,pmh12,pmh11,pmh05",    #CHI-8C0017 Add pmh21 
#        " FROM  pmh_file,OUTER pmc_file",  #TQC-9A0124
        " FROM  pmh_file LEFT OUTER JOIN pmc_file ON pmh02=pmc01",   #TQC-9A0124
        " WHERE pmh01 = '",g_ima.ima01,"' AND ", tm.wc2 CLIPPED,
#		" AND pmh_file.pmh02 = pmc_file.pmc01 ",  #TQC-9A0124
		    "   AND pmh22 = '",g_ima.pmh22,"' ",                                     #CHI-8C0017
                " AND pmh23 = ' '",                                              #No.CHI-960033
		    "   AND pmhacti = 'Y'",                                                  #CHI-910021
#               " AND pmh21 = ' ' ",                                             #CHI-860042  #CHI-8C0017 Mark
#               " AND pmh22 = '1' ",                                             #CHI-860042  #CHI-8C0017 Mark                
        " ORDER BY 1 "
    PREPARE q210_pb FROM l_sql
    DECLARE q210_bcs                       #BODY CURSOR
        CURSOR FOR q210_pb
 
    #-----MOD-910065---------
    #FOR g_cnt = 1 TO g_pmh.getLength()           #單身 ARRAY 乾洗
    #   INITIALIZE g_pmh[g_cnt].* TO NULL
    #END FOR
    CALL g_pmh.clear()
    #-----END MOD-910065-----
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q210_bcs INTO g_pmh[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_pmh[g_cnt].pmh11 IS NULL THEN
  	       LET g_pmh[g_cnt].pmh11 = 0
        END IF
        IF g_pmh[g_cnt].pmh12 IS NULL THEN
  	       LET g_pmh[g_cnt].pmh12 = 0
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_pmh.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
     DISPLAY g_rec_b TO FORMONLY.cn2  #MOD-4B0292 將MARK移除
END FUNCTION
 
FUNCTION q210_bp(p_ud)
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
 
      BEFORE ROW
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
         CALL q210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q210_fetch('L')
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
 
