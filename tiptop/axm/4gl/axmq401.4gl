# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq401.4gl
# Descriptions...: 訂單選擇配件查詢
# Date & Author..: 95/01/20 By Danny
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0045 04/11/16 By Smapmin 帳款客戶,送貨客戶,人員,部門,產品編號開窗
# Modify.........: No.MOD-510134 05/01/18 By ching count筆數錯誤修改
# Modify.........: No.MOD-570253 05/08/08 By Rosayu oeb08=>no use
# Modify.........: No.FUN-610020 06/01/06 By Carrier 出貨驗收功能 -- 單頭新增驗收欄位acc_q
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760107 07/06/23 By claire 修改變數定義方式
# Modify.........: No.TQC-790065 07/09/11 By lumxa 匯出Excel多出一空白行
# Modify.........: No.CHI-930019 09/03/10 By rainy select 了2次rowid造成-6372錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,         # Head Where condition  #No.FUN-680137 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000          # Body Where condition  #No.FUN-680137 VARCHAR(500)
        END RECORD,
    g_oea   RECORD
            oea01   LIKE oea_file.oea01,
            oea02   LIKE oea_file.oea02,
            oea03   LIKE oea_file.oea03,
            oea04   LIKE oea_file.oea04,
            oea032  LIKE oea_file.oea032,
            occ02   LIKE occ_file.occ02,
            oea14   LIKE oea_file.oea14,
            oea15   LIKE oea_file.oea15,
            oeaconf LIKE oea_file.oeaconf,
            oeahold LIKE oea_file.oeahold,
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb092  LIKE oeb_file.oeb092,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE oeb_file.oeb12,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            acc_q   LIKE ogb_file.ogb12,  #MOD-760107 modify type_file.num10,    #No.FUN-610020  #No.FUN-680137 INTEGER
            oeb24   LIKE oeb_file.oeb24,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb25   LIKE oeb_file.oeb25,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            unqty   LIKE oeb_file.oeb12,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb70   LIKE oeb_file.oeb70,
            oeb06   LIKE oeb_file.oeb06,
            ima021_h   LIKE ima_file.ima021,
            # oeb08   LIKE oeb_file.oeb08,MOD-570253
            oeb09   LIKE oeb_file.oeb09,
            oeb091  LIKE oeb_file.oeb091,
            oeb16   LIKE oeb_file.oeb16
        END RECORD,
    g_oeo DYNAMIC ARRAY OF RECORD
            oeo04   LIKE oeo_file.oeo04,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            oeo05   LIKE oeo_file.oeo05,
            oeo06   LIKE oeo_file.oeo06,
            oeo07   LIKE oeo_file.oeo07,
            oeo09   LIKE oeo_file.oeo09,
            desc    LIKE aab_file.aab02        #No.FUN-680137 VARCHAR(6)
        END RECORD,
    g_argv1         LIKE oea_file.oea01,
    g_argv2         LIKE oeb_file.oeb03,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
     g_sql         STRING,  #WHERE CONDITION  #No.FUN-580092 HCN 
    g_rec_b LIKE type_file.num10 	  #單身筆數 #No.FUN-680137 INTEGER
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
DEFINE          l_sl		LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
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
    LET g_argv2      = ARG_VAL(2)
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q401_w AT p_row,p_col
        WITH FORM "axm/42f/axmq401"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q401_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q401_q() END IF
    CALL q401_menu()
    CLOSE WINDOW q401_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q401_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
           IF NOT cl_null(g_argv2) THEN
              LET tm.wc=tm.wc CLIPPED," AND oeb03=",g_argv2
           END IF
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_oeo.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON
                     oea01,oea02,oea03,oea032,oea04,
                     oea14,oea15,oeahold,oeaconf,oeb70,
                     oeb03,oeb04,oeb06,oeb05,oeb12,oeb15,
                     #oeb08,oeb09,oeb091,oeb092, #MOD-570253
                            oeb09,oeb091,oeb092, #MOD-570253
                     oeb16,oeb24,oeb25
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              ON ACTION CONTROLP
           CASE
             WHEN INFIELD(oea03) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
             WHEN INFIELD(oea04) #送貨客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea04
                  NEXT FIELD oea04
             WHEN INFIELD(oea14) #人員   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea14
                  NEXT FIELD oea14
             WHEN INFIELD(oea15) #部門   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea15
                  NEXT FIELD oea15
              WHEN INFIELD(oeb04) #產品編號   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb04
                  NEXT FIELD oeb04
           END CASE
 
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
           CALL q401_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   #LET g_sql=" SELECT oea01,oeb03 FROM oea_file,oeb_file ",   #CHI-930019
   LET g_sql=" SELECT oea01,oeb03 FROM oea_file,oeb_file ",                   #CHI-930019
#   LET g_sql=" SELECT oea01,oeb03 FROM oea_file,oeb_file ",
             " WHERE oea01=oeb01 AND ",tm.wc CLIPPED,
             "   AND oeaconf != 'X' " #01/08/08 mandy
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY oea01,oeb03"
 
   PREPARE q401_prepare FROM g_sql
   DECLARE q401_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q401_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) FROM oea_file,oeb_file ",  #MOD-510134
              " WHERE ",tm.wc CLIPPED,
               "   AND oea01=oeb01 ",           #MOD-510134
              "   AND oeaconf != 'X' " #01/08/08 mandy
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q401_pp  FROM g_sql
   DECLARE q401_cnt   CURSOR FOR q401_pp
END FUNCTION
 
FUNCTION q401_b_askkey()
   CONSTRUCT tm.wc2 ON oeo04,ima02,ima021,oeo05,oeo06,oeo07,oeo08
                  FROM s_oeo[1].oeo04,s_oeo[1].ima02,s_oeo[1].ima021,
                       s_oeo[1].oeo05,s_oeo[1].oeo06,s_oeo[1].oeo07 ,
                       s_oeo[1].oeo08
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
 
FUNCTION q401_menu()
 
   WHILE TRUE
      CALL q401_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q401_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeo),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q401_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q401_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q401_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q401_cnt
        FETCH q401_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q401_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q401_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q401_cs INTO g_oea.oea01,g_oea.oeb03  #CHI-930019 remark
       WHEN 'P' FETCH PREVIOUS q401_cs INTO g_oea.oea01,g_oea.oeb03  #CHI-930019 remark
       WHEN 'F' FETCH FIRST    q401_cs INTO g_oea.oea01,g_oea.oeb03  #CHI-930019 remark
       WHEN 'L' FETCH LAST     q401_cs INTO g_oea.oea01,g_oea.oeb03  #CHI-930019 remark
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
            FETCH ABSOLUTE g_jump q401_cs INTO g_oea.oea01,g_oea.oeb03  #CHI-930019 remark 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  #TQC-6B0105
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
 
	SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold,
          oeb03,oeb04,oeb092,oeb05,oeb12,0,oeb24,oeb25,(oeb12-oeb24+oeb25-oeb26), #No.FUN-610020
           #oeb15,oeb70,oeb06,ima021,oeb08,oeb09,oeb091,oeb16 #MOD-570253
            oeb15,oeb70,oeb06,ima021,      oeb09,oeb091,oeb16 #MOD-570253
	  INTO g_oea.*
	  FROM oea_file,oeb_file,OUTER ima_file
     WHERE oea01= g_oea.oea01
       AND oeb03= g_oea.oeb03
       AND oea01=oeb01
       AND oeb_file.oeb04=ima_file.ima01
 
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)  #No.FUN-660167
        CALL cl_err3("sel","oea_file,oeb_file",g_oea.oea01,g_oea.oeb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
    #No.FUN-610020  --Begin
    SELECT SUM(ogb12) INTO g_oea.acc_q
      FROM ogb_file,oga_file,oea_file,oeb_file
     WHERE ogb31 = g_oea.oea01 AND ogb32 = g_oea.oeb03
       AND ogb01 = oga01
       AND oeb01 = oea01
       AND oeb01 = ogb31 AND oeb03 = ogb32
       AND oea65 = 'Y'
       AND ogaconf = 'Y' AND ogapost = 'Y'
       AND oga09 = '8'  
    IF cl_null(g_oea.acc_q) THEN LET g_oea.acc_q = 0 END IF
    #No.FUN-610020  --End
 
    CALL q401_show()
END FUNCTION
 
FUNCTION q401_show()
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
   CALL q401_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q401_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT oeo04,ima02,ima021,oeo05,oeo06,oeo07,oeo09,oeo08 ",
        "  FROM oeo_file,ima_file ",
        " WHERE oeo01 ='",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND oeo03=",g_oea.oeb03,
        "   AND oeo04=ima01 ",
        " ORDER BY 1"
    PREPARE q401_pb FROM l_sql
    DECLARE q401_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q401_pb
#TQC-790065--start--
#   FOR g_cnt = 1 TO g_oeo.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_oeo[g_cnt].* TO NULL
#   END FOR
    CALL g_oeo.clear()
#TQC-790065--end--
    LET g_cnt = 1
    FOREACH q401_bcs INTO g_oeo[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oeo[g_cnt].oeo06 IS NULL THEN
  	       LET g_oeo[g_cnt].oeo06 = 0
        END IF
        IF g_oeo[g_cnt].desc = '1' THEN
           LET g_oeo[g_cnt].desc = cl_getmsg('axm-193',g_lang)
        END IF
        IF g_oeo[g_cnt].desc = '2' THEN
           LET g_oeo[g_cnt].desc = cl_getmsg('axm-195',g_lang)
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oeo.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q401_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeo TO s_oeo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q401_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q401_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q401_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q401_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q401_fetch('L')
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
 
#   ON ACTION accept
#      LET l_ac = ARR_CURR()
 
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
 
