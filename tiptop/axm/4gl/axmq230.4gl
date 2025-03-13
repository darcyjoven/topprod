# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axmq230.4gl
# Descriptions...: 客戶最近訂單查詢
# Date & Author..: 95/01/21 By Nick
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-610020 06/01/06 By Carrier 出貨驗收功能 -- 單身新增驗收欄位acc_q
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790065 07/09/11 By lumxa 匯出Excel多出一空白行
# Modify.........: No.MOD-8B0192 08/12/02 By Smapmin 單頭不下查詢條件在單身下查詢條件,會把所有的資料都查詢出來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930009 09/09/21 By chenmoyan 給客戶/訂單單號/產品編號/單位加開窗
# Modify.........: No.FUN-CC0131 13/01/10 By SunLM 增加幣別,稅別,產品品名規格,銷售單位,單價,金額等欄位顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,         # Head Where condition  #No.FUN-680137 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000          # Body Where condition  #No.FUN-680137 VARCHAR(500)
        END RECORD,
    g_occ   RECORD
			occ01	LIKE occ_file.occ01,
			occ02	LIKE occ_file.occ02,
			link 	LIKE aab_file.aab01    #No.FUN-680137 VARCHAR(24)
        END RECORD,
    g_ogb DYNAMIC ARRAY OF RECORD
            oga02   LIKE oga_file.oga02,
            oga08   LIKE oga_file.oga08,
            oga01   LIKE oga_file.oga01,
            oga23   LIKE oga_file.oga23,   #FUN-CC0131
            oga21   LIKE oga_file.oga21,   #FUN-CC0131          
            ogb31   LIKE ogb_file.ogb31,
            ogb04   LIKE ogb_file.ogb04,   #FUN-CC0131
            ima02   LIKE ima_file.ima02,   #FUN-CC0131
            ima021   LIKE ima_file.ima021,            
            ogb092  LIKE ogb_file.ogb092,
            ogb05   LIKE ogb_file.ogb05,   #FUN-CC0131
            ogb12   LIKE ogb_file.ogb12,
            ogb63   LIKE ogb_file.ogb63,
            ogb37   LIKE ogb_file.ogb37,   #FUN-CC0131
            ogb13   LIKE ogb_file.ogb13,   #FUN-CC0131
            ogb14t  LIKE ogb_file.ogb14t   #FUN-CC0131          
        END RECORD,
	g_occ261		LIKE occ_file.occ261,
	g_occ29			LIKE occ_file.occ29,
    g_argv1         LIKE occ_file.occ01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next #No.FUN-680137 SMALLINT
     g_sql LIKE type_file.chr1000,#WHERE CONDITION  #No.FUN-580092 HCN  #No.FUN-680137
    g_rec_b LIKE type_file.num10   #單身筆數        #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
DEFINE          l_sl	        LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
    LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q230_w AT p_row,p_col
        WITH FORM "axm/42f/axmq230"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q230_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q230_q() END IF
    CALL q230_menu()
    CLOSE WINDOW q230_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q230_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "occ01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_ogb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B003           CALL cl_set_head_visible("","YES")  #NO.FUN-6B00311
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON occ01,occ02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#No.FUN-930009 --Begin
              ON ACTION CONTROLP
                 CASE
                    WHEN INFIELD(occ01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form ="q_occ"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO occ01
                       NEXT FIELD occ01
                 END CASE
#No.FUN-930009 --End
 
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
           CALL q230_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   #-----MOD-8B0192---------
   #LET g_sql=" SELECT occ01 FROM occ_file ",
   #          " WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN
      LET g_sql=" SELECT occ01 FROM occ_file ",
                " WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql=" SELECT occ01 FROM occ_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND occ01 IN ",
                "   (SELECT oga03 FROM oga_file,ogb_file ",
                "     WHERE oga01 =ogb01  ",
                "       AND (oga09='2' OR oga09='3' OR oga09='4' OR oga09='6' ) ",
                "       AND ogapost='Y'  ",
                "       AND ",tm.wc2 CLIPPED,")"
   END IF
   #-----END MOD-8B0192-----
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY occ01"
 
   PREPARE q230_prepare FROM g_sql
   DECLARE q230_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q230_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   #-----MOD-8B0192---------
   #LET g_sql=" SELECT COUNT(*) FROM occ_file ",
   #           " WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN
      LET g_sql=" SELECT COUNT(*) FROM occ_file ",
                 " WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql=" SELECT COUNT(*) FROM occ_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND occ01 IN ",
                "   (SELECT oga03 FROM oga_file,ogb_file ",
                "     WHERE oga01 =ogb01  ",
                "       AND (oga09='2' OR oga09='3' OR oga09='4' OR oga09='6' ) ",
                "       AND ogapost='Y'  ",
                "       AND ",tm.wc2 CLIPPED,")"
   END IF
   #-----END MOD-8B0192-----
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q230_pp  FROM g_sql
   DECLARE q230_cnt   CURSOR FOR q230_pp
END FUNCTION
 
FUNCTION q230_b_askkey()
   CONSTRUCT tm.wc2 ON oga02,oga08,oga01,oga23,oga21,ogb31,ogb04,ogb092,ogb05,ogb12,ogb63,
                       ogb37,ogb13,ogb14t  #FUN-CC0131 add ##add oga23,oga21,ogb05,ogb37,ogb13,ogb14t 
                  FROM s_ogb[1].oga02,s_ogb[1].oga08,s_ogb[1].oga01,s_ogb[1].oga23,s_ogb[1].oga21,
                       s_ogb[1].ogb31,s_ogb[1].ogb04,s_ogb[1].ogb092,s_ogb[1].ogb05,
					        s_ogb[1].ogb12,s_ogb[1].ogb63,s_ogb[1].ogb37,s_ogb[1].ogb13,s_ogb[1].ogb14t #FUN-CC0131 add
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#No.FUN-930009 --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oga01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_oga"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga01
               NEXT FIELD oga01
            WHEN INFIELD(ogb31)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_oea03a"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ogb31
               NEXT FIELD ogb31
            WHEN INFIELD(ogb04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ogb04
               NEXT FIELD ogb04
         END CASE
#No.FUN-930009 --End
 
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
 
FUNCTION q230_menu()
 
   WHILE TRUE
      CALL q230_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q230_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q230_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q230_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q230_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q230_cnt
        FETCH q230_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q230_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q230_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q230_cs INTO g_occ.occ01
        WHEN 'P' FETCH PREVIOUS q230_cs INTO g_occ.occ01
        WHEN 'F' FETCH FIRST    q230_cs INTO g_occ.occ01
        WHEN 'L' FETCH LAST     q230_cs INTO g_occ.occ01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q230_cs INTO g_occ.occ01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL  #TQC-6B0105
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
	SELECT occ01,occ02,occ261,occ29
	  INTO g_occ.occ01,g_occ.occ02,g_occ261,g_occ29
	  FROM occ_file
	 WHERE occ01 = g_occ.occ01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)  #No.FUN-660167
        CALL cl_err3("sel","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
 
    CALL q230_show()
END FUNCTION
 
FUNCTION q230_show()
   LET g_occ.link = g_occ261 CLIPPED,'-',g_occ29 CLIPPED
   IF SQLCA.SQLCODE THEN LET g_occ.occ02=' ' END IF
   DISPLAY BY NAME g_occ.*
   CALL q230_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q230_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT oga02,oga08,oga01,oga23,oga21,ogb31,ogb04,'','',ogb092,ogb05,ogb12,ogb63,ogb37,ogb13,ogb14t  ",
        "  FROM oga_file,ogb_file ", ##add oga23,oga21,ogb05,ogb37,ogb13,ogb14t FUN-CC0131
        " WHERE oga01 =ogb01  ",
        "   AND (oga09='2' OR oga09='3' OR oga09='4' OR oga09='6' ) ", #No.8347 #No.FUN-610020
        "   AND ogapost='Y'  ",
        "   AND oga03 = '",g_occ.occ01,"'",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY oga02 DESC"
    PREPARE q230_pb FROM l_sql
    DECLARE q230_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q230_pb
#TQC-790065---start---
#   FOR g_cnt = 1 TO g_ogb.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_ogb[g_cnt].* TO NULL
#   END FOR
    CALL g_ogb.clear()
#TQC-790065---end---
    LET g_cnt = 1
    FOREACH q230_bcs INTO g_ogb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_ogb[g_cnt].ogb12 IS NULL THEN
  	       LET g_ogb[g_cnt].ogb12 = 0
        END IF
        IF g_ogb[g_cnt].ogb63 IS NULL THEN
  	       LET g_ogb[g_cnt].ogb63 = 0
        END IF
        SELECT ima02,ima021 INTO g_ogb[g_cnt].ima02,g_ogb[g_cnt].ima021
          FROM ima_file 
         WHERE ima01=g_ogb[g_cnt].ogb04 #FUN-CC0131 add        
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    #   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q230_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q230_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q230_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q230_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q230_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q230_fetch('L')
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
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
