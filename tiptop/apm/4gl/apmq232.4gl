# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmq232.4gl
# Descriptions...: 廠商最近入庫/退貨查詢
# Date & Author..: 97/08/28 By Kitty
# Modify.........: No.MOD-480483 04/09/15 By Smapmin調整為可以顯示上下筆之功能
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增廠商開窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B60231 11/07/04 By Summer cs段需增加tm.wc2有沒有輸入值的條件處理
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500) 	
       	wc2  	LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500) 
        END RECORD,
    g_pmc   RECORD
        pmc01	LIKE pmc_file.pmc01,
        pmc03	LIKE pmc_file.pmc03
        END RECORD,
    g_rvv DYNAMIC ARRAY OF RECORD
        rvu03   LIKE rvu_file.rvu03,
        rvu00   LIKE rvu_file.rvu00,
        desc    LIKE ze_file.ze03,    #No.FUN-680136 VARCHAR(4) 
        rvu01   LIKE rvu_file.rvu01,
        rvu02   LIKE rvu_file.rvu02,
        rvv36   LIKE rvv_file.rvv36,
        rvv31   LIKE rvv_file.rvv31,
        rvv031  LIKE rvv_file.rvv031,
        rvv17   LIKE rvv_file.rvv17
    END RECORD,
    g_argv1         LIKE pmc_file.pmc01,
    g_query_flag    LIKE type_file.num5,         #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10         #No.FUN-680136 INTEGER  #單身筆數
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,           #No.FUN-680136 VARCHAR(72) 
       l_ac         LIKE type_file.num5          #目前處理的ARRAY CNT   #No.FUN-680136 SMALLINT
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680136 INTEGER

MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_query_flag =1
 
    OPEN WINDOW q232_w WITH FORM "apm/42f/apmq232"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q232_q() END IF
    CALL q232_menu()
    CLOSE WINDOW q232_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q232_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmc01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_rvv.clear()
         CALL cl_opmsg('q')
         INITIALIZE tm.* TO NULL			# Default condition
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME tm.wc ON pmc01,pmc03
              #No.FUN-580031 --start--     HCN
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
         #            LET tm.wc =tm.wc clipped," AND pmcuser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #            LET tm.wc =tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #            LET tm.wc =tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
         #End:FUN-980030
 
         CALL q232_b_askkey()
         IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   IF tm.wc2=' 1=1 ' THEN #MOD-B60231 add
      LET g_sql=" SELECT pmc01 FROM pmc_file ",
                " WHERE ",tm.wc CLIPPED,
                " ORDER BY pmc01"
   #MOD-B60231 add --start--
   ELSE
      LET g_sql=" SELECT UNIQUE pmc01 FROM pmc_file,rvv_file,rvu_file ",
                " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND pmc01 = rvu04",
                "   AND rvu01 = rvv01",
                " ORDER BY pmc01"
   END IF
   #MOD-B60231 add --end--
   PREPARE q232_prepare FROM g_sql
   DECLARE q232_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q232_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2=' 1=1 ' THEN #MOD-B60231 add
      LET g_sql=" SELECT COUNT(*) FROM pmc_file ",
                 " WHERE ",tm.wc CLIPPED
   #MOD-B60231 add --start--
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT pmc01) FROM pmc_file,rvv_file,rvu_file ",
                " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND pmc01 = rvu04",
                "   AND rvu01 = rvv01",
                " ORDER BY pmc01"
   END IF
   #MOD-B60231 add --end--
   PREPARE q232_pp  FROM g_sql
   DECLARE q232_cnt   CURSOR FOR q232_pp
END FUNCTION
 
FUNCTION q232_b_askkey()
   CONSTRUCT tm.wc2 ON rvu03,rvu00,rvu01,rvu02,rvv36,rvv31,rvv031,rvv17
                  FROM s_rvv[1].rvu03,s_rvv[1].rvu00,
                       s_rvv[1].rvu01,s_rvv[1].rvu02,s_rvv[1].rvv36,
                       s_rvv[1].rvv31,s_rvv.rvv031,s_rvv[1].rvv17
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
 
FUNCTION q232_menu()
 
   WHILE TRUE
      CALL q232_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q232_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q232_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q232_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q232_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
           OPEN q232_cnt
            FETCH q232_cnt INTO g_row_count #MOD-480483
            DISPLAY g_row_count TO cnt  #MOD-480483
        CALL q232_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q232_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q232_cs INTO g_pmc.pmc01
        WHEN 'P' FETCH PREVIOUS q232_cs INTO g_pmc.pmc01
        WHEN 'F' FETCH FIRST    q232_cs INTO g_pmc.pmc01
        WHEN 'L' FETCH LAST     q232_cs INTO g_pmc.pmc01
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
            FETCH ABSOLUTE l_abso q232_cs INTO g_pmc.pmc01
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
 
    CALL q232_show()
END FUNCTION
 
FUNCTION q232_show()
   DISPLAY BY NAME g_pmc.*   # 顯示單頭值
   CALL q232_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q232_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT rvu03,rvu00,' ',rvu01,rvu02,rvv36,rvv31,rvv031,rvv17 ",
        "  FROM rvu_file,rvv_file ",
        " WHERE rvu01=rvv01 AND rvuconf='Y' AND ",
        "       rvu04= '",g_pmc.pmc01,"' AND  ",tm.wc2 CLIPPED,
        " ORDER BY rvu03 DESC"
    PREPARE q232_pb FROM l_sql
    DECLARE q232_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q232_pb
 
    FOR g_cnt = 1 TO g_rvv.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_rvv[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q232_bcs INTO g_rvv[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_rvv[g_cnt].rvv17   IS NULL THEN
  	       LET g_rvv[g_cnt].rvv17   = 0
        END IF
       CASE
          WHEN g_rvv[g_cnt].rvu00='1'
               CALL cl_getmsg('apm-243',g_lang) RETURNING g_rvv[g_cnt].desc
          WHEN g_rvv[g_cnt].rvu00='2'
               CALL cl_getmsg('apm-244',g_lang) RETURNING g_rvv[g_cnt].desc
          WHEN g_rvv[g_cnt].rvu00='3'
               CALL cl_getmsg('apm-245',g_lang) RETURNING g_rvv[g_cnt].desc
        END CASE
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
  #     DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q232_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q232_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q232_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q232_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q232_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q232_fetch('L')
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
 
