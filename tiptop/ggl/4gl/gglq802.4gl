# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gglq802.4gl
# Descriptions...: 異動碼別異動查詢
# Date & Author..: 02/02/28 By Danny
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Moidfy.........: No.FUN-5C0015 06/01/02 By kevin
#                  單頭增加欄位「異動碼類型代號aec052」,FORMONLY.ahe02，^p q_ahe
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0073 06/11/15 By xufeng  修改語言不能轉換
# Modify.........: No.FUN-6A0092 06/11/27 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740053 07/04/12 By Xufeng  匯出excel時多一空白行
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(1000)   # Head Where condition
        END RECORD,
    l_aec  RECORD
            aec051  LIKE aec_file.aec051,
            aec052  LIKE aec_file.aec052,  # No.FUN-5C0015 add
            aec05   LIKE aec_file.aec05,
            aec00   LIKE aec_file.aec00    #No.FUN-740033
        END RECORD,
    g_aec DYNAMIC ARRAY OF RECORD
            aec02    LIKE aec_file.aec02,
            aec01    LIKE aec_file.aec01,
            aec03    LIKE aec_file.aec03,
            abb24    LIKE abb_file.abb24,
            abb25    LIKE abb_file.abb25,
            abb07_1  LIKE abb_file.abb07,
            abb07f_1 LIKE abb_file.abb07f,
            abb07_2  LIKE abb_file.abb07,
            abb07f_2 LIKE abb_file.abb07f,
            abb99    LIKE abb_file.abb07
        END RECORD,
    g_bookno        LIKE aec_file.aec00,       #INPUT ARGUMENT - 1
    g_aec01         LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)
    g_wc,g_wc2,g_sql,g_sql1 string,            #WHERE CONDITION #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #NO FUN-690009   SMALLINT     #單身筆數
    l_bal           LIKE abb_file.abb07       #NO FUN-690009   DECIMAL(20,6)#No.FUN-4C0009
 
DEFINE   g_cnt           LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_msg           LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_curs_index    LIKE type_file.num10       #NO FUN-690009   INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0097
DEFINE         l_sl,p_row,p_col	LIKE type_file.num5       #NO FUN-690009       SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW q802_srn AT p_row,p_col WITH FORM 'ggl/42f/gglq802'
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    DISPLAY FORM q802_srn
    FOR l_sl = 8  TO 20 STEP 1 DISPLAY "" AT l_sl,1 END FOR
 
    CALL s_shwact(0,0,g_bookno)
#    IF cl_chk_act_auth() THEN
#       CALL q802_q()
#    END IF
IF NOT cl_null(g_bookno) THEN CALL q802_q() END IF
    IF cl_null(g_bookno)  THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL q802_menu()
    CLOSE FORM q802_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION q802_cs()
   DEFINE   l_cnt LIKE type_file.num5        #NO FUN-690009   SMALLINT
 
    CLEAR FORM #清除畫面
    CALL g_aec.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL			# Default condition
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE l_aec.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
              aec051,aec052,aec05,aec00,aec02         # FUN-5C0015 add aec052  #No.FUN-740033
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
     # FUN-5C0015 (s) add
     ON ACTION controlp
         CASE
           WHEN INFIELD(aec052) #異動碼類型代號
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ahe"
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aec052
              NEXT FIELD aec052
           OTHERWISE EXIT CASE
         END CASE
     # FUN-5C0015 (e) add
 
     ON ACTION locale
        CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
    DISPLAY "" AT  8,1
    IF INT_FLAG THEN RETURN END IF
 
    #====>資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
    #End:FUN-980030
 
 
   # No.FUN-5C0015 (s)
   #LET g_sql=" SELECT UNIQUE aec051,aec05  FROM aec_file,aag_file  ",
    LET g_sql=" SELECT UNIQUE aec051,aec052,aec05,aec00 FROM aec_file,aag_file  ",  #No.FUN-740033
   # No.FUN-5C0015 (e)
              " WHERE ",tm.wc CLIPPED,
#             " AND aec00 = '",g_bookno,"'",  #No.FUN-740033
              " AND aec00 = aag00 ",          #No.FUN-740033
              " AND aec01 = aag01 ",
              " ORDER BY aec00,aec051,aec052,aec05 "   #FUN-5C0015 Add aec052  #No.FUN-740033
    PREPARE q802_prepare FROM g_sql
    DECLARE q802_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q802_prepare
    DISPLAY g_sql
 
#No.FUN-5C0015 (s)---------------
{
    LET g_sql=
        "SELECT COUNT(DISTINCT aec051) FROM aec_file,aag_file ",
         "   WHERE aec00 = '",g_bookno,"'",
         "   AND aec01 = aag01    AND ",tm.wc CLIPPED
    PREPARE q802_precount FROM g_sql
    DECLARE q802_count CURSOR FOR q802_precount
    display g_sql
    OPEN q802_count
    FETCH q802_count INTO g_row_count
    CLOSE q802_count
}
    DROP TABLE count_tmp
    LET g_sql="SELECT aec00,aec051,aec052,aec05 ",     #No.FUN-740033
              "  FROM aec_file,aag_file ",
              " WHERE ",tm.wc CLIPPED,
#             "   AND aec00 = '",g_bookno,"'",  #No.FUN-740033
              "   AND aec00 = aag00 ",          #No.FUN-740033
              "   AND aec01 = aag01 ",
              " GROUP BY aec00,aec051,aec052,aec05 ",  #No.FUN-740033
              " INTO TEMP count_tmp"
    PREPARE q802_cnt_tmp  FROM g_sql
    EXECUTE q802_cnt_tmp
    DECLARE q802_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
#No.FUN-5C0015 (e)-----------
 
END FUNCTION
 
FUNCTION q802_b_askkey()
   LET l_bal =0
   DISPLAY "[        ]" AT 8,1
END FUNCTION
 
#中文的MENU
FUNCTION q802_menu()
 
   WHILE TRUE
      CALL q802_bp("G")
      CASE g_action_choice
#TQC-6B0073   --begin
         WHEN "locale"
            CALL cl_dynamic_locale()
#TQC-6B0073   --end
         WHEN "first"
            CALL q802_fetch('F')
         WHEN "previous"
            CALL q802_fetch('P')
         WHEN "jump"
            CALL q802_fetch('/')
         WHEN "next"
            CALL q802_fetch('N')
         WHEN "last"
            CALL q802_fetch('L')
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q802_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aec),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q802_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q802_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q802_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q802_count
        FETCH q802_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q802_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q802_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)   #處理方式
    l_abso          LIKE type_file.num10       #NO FUN-690009   INTEGER   #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q802_cs INTO l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05,l_aec.aec00  #No.FUN-740033
        WHEN 'P' FETCH PREVIOUS q802_cs INTO l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05,l_aec.aec00  #No.FUN-740033
        WHEN 'F' FETCH FIRST    q802_cs INTO l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05,l_aec.aec00  #No.FUN-740033
        WHEN 'L' FETCH LAST     q802_cs INTO l_aec.aec051,
                                             l_aec.aec052,   #FUN-5C0015
                                             l_aec.aec05,l_aec.aec00  #No.FUN-740033
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
            FETCH ABSOLUTE l_abso q802_cs INTO l_aec.aec051,
                                               l_aec.aec052, #FUN-5C0015
                                               l_aec.aec05,l_aec.aec00  #No.FUN-740033
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_aec.aec05,SQLCA.sqlcode,0)
        INITIALIZE l_aec.* TO NULL  #TQC-6B0105
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
 
    CALL q802_show()
END FUNCTION
 
FUNCTION q802_show()
 DEFINE l_ahe02 LIKE ahe_file.ahe02  #FUN-5C0015
 
   DISPLAY l_aec.aec051 TO aec051
   DISPLAY l_aec.aec05 TO aec05
   DISPLAY BY NAME l_aec.aec00  #No.FUN-740033
  #FUN-5C0015(S)-----
   SELECT ahe02 FROM ahe_file WHERE ahe01 = l_aec.aec052
   IF SQLCA.sqlcode THEN LET l_ahe02 = '' END IF
   DISPLAY l_aec.aec052 TO aec052
   DISPLAY l_ahe02 TO ahe02
  #FUN-5C0015(E)-----
   CALL q802_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q802_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(1000)
   DEFINE l_abb06   LIKE abb_file.abb06
 
   LET l_sql =
      "SELECT aec02,aec01,aec03,abb24,abb25,abb07,abb07f,0,0,0,abb06", #No:7658
      " FROM  aec_file , abb_file ",
      " WHERE aec00 = '",l_aec.aec00,"'",  #No.FUN-740033
      " AND aec00 = abb00 ",
      " AND aec051= '",l_aec.aec051,"'",
      " AND aec05 = '",l_aec.aec05,"'",
      " AND abb00 = aec00 AND abb01 = aec03 AND abb02 = aec04 ",
      " AND ",tm.wc CLIPPED,
      " ORDER BY 1 "
    PREPARE q802_pb FROM l_sql
    DECLARE q802_bcs                       #BODY CURSOR
        CURSOR FOR q802_pb
 
    CALL g_aec.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET l_bal = 0
    FOREACH q802_bcs INTO g_aec[g_cnt].*,l_abb06
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_abb06 = '2' THEN
           LET g_aec[g_cnt].abb07_2 = g_aec[g_cnt].abb07_1
           LET g_aec[g_cnt].abb07_1 = 0
           LET g_aec[g_cnt].abb07f_2 = g_aec[g_cnt].abb07f_1
           LET g_aec[g_cnt].abb07f_1 = 0
        END IF
        LET l_bal = l_bal + g_aec[g_cnt].abb07_1 - g_aec[g_cnt].abb07_2
        LET g_aec[g_cnt].abb99 = l_bal
        IF cl_null(g_aec[g_cnt].abb07_2) THEN
           LET g_aec[g_cnt].abb07_2=0
        END IF
        IF cl_null(g_aec[g_cnt].abb07_1) THEN
           LET g_aec[g_cnt].abb07_1=0
        END IF
        IF cl_null(g_aec[g_cnt].abb07f_2) THEN
           LET g_aec[g_cnt].abb07f_2=0
        END IF
        IF cl_null(g_aec[g_cnt].abb07f_1) THEN
           LET g_aec[g_cnt].abb07f_1=0
        END IF
        IF cl_null(l_bal) THEN
           LET l_bal=0
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aec.deleteElement(g_cnt)   #No.TQC-740053
 
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cnt2
 
END FUNCTION
 
FUNCTION q802_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aec TO s_aec.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    # BEFORE ROW
    #    LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #    LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#TQC-6B0073   --begin
      ON ACTION locale
         LET g_action_choice="locale"
         EXIT DISPLAY
#TQC-6B0073   --end
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
         LET g_action_choice="previous"
         EXIT DISPLAY
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DISPLAY
      ON ACTION next
         LET g_action_choice="next"
         EXIT DISPLAY
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
      #  LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
