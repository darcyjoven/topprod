# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimq610.4gl
# Descriptions...: 料件儲位各期異動統計量查詢
# Date & Author..: 05/06/01 By ice
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
#
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-790058 07/09/10 By Judy 匯出Excel多一空白行
# Modify.........: No.TQC-7A0112 07/10/31 By Judy msv需求，用到rowid的地方加入key值字段
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   tm        RECORD
              wc   LIKE type_file.chr1000  # Head Where condition-1  #No.FUN-690026 VARCHAR(500)
             END RECORD,
   tm2_1     RECORD
              yy   LIKE imkk_file.imkk05,  #No.FUN-690026 VARCHAR(4)
              mm   LIKE imkk_file.imkk06   #No.FUN-690026 VARCHAR(2)
             END RECORD,
   g_imgg    RECORD
              imgg01 LIKE imgg_file.imgg01,  # 料件編號
              imgg02 LIKE imgg_file.imgg02,  # 倉庫編號
              imgg03 LIKE imgg_file.imgg03,  # 存放位置
              imgg04 LIKE imgg_file.imgg04,  # 批號
              imgg09 LIKE imgg_file.imgg09   # 庫存單位
             END RECORD,
   g_ima02   LIKE ima_file.ima02,    # 品名
   g_ima021  LIKE ima_file.ima021,   # 規格
   g_ima25   LIKE ima_file.ima25,    # 單位
   g_imkk    DYNAMIC ARRAY OF RECORD
              imkk05      LIKE imkk_file.imkk05,  #年度
              imkk06      LIKE imkk_file.imkk06,  #期別
              imkk081     LIKE imkk_file.imkk081, #入庫
              imkk082     LIKE imkk_file.imkk082, #出
              imkk083     LIKE imkk_file.imkk083, #銷貨
              imkk084     LIKE imkk_file.imkk084, #轉
              imkk085     LIKE imkk_file.imkk085, #調整
              imkk09      LIKE imkk_file.imkk09   #期未結存
             END RECORD,
   g_argv1      LIKE imgg_file.imgg01,  #料件編號
   g_query_flag LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
   g_sql        string,                 #No.FUN-580092 HCN
   g_rec_b      LIKE type_file.num5     #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE l_ac             LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
 
   OPTIONS                                      #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
   LET g_argv1 = ARG_VAL(1)                     #料件編號
   LET g_query_flag=1
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW q610_w AT p_row,p_col
      WITH FORM "aim/42f/aimq610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   IF g_query_flag THEN
      CALL q610_q()
   END IF
   IF not cl_null(g_argv1) THEN
      CALL q610_q()
   END IF
   CALL q610_menu()
   CLOSE WINDOW q610_w
     CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q610_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   CLEAR FORM
   CALL g_imkk.clear()
   CALL cl_opmsg('q')
   INITIALIZE g_imgg.* TO NULL  #FUN-640213 add
   INITIALIZE tm.* TO NULL		
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   CONSTRUCT BY NAME tm.wc ON imgg01,ima02,ima021,imgg02,imgg03,imgg04,imgg09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(imgg01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imgg01
               NEXT FIELD imgg01
         END CASE
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   INPUT BY NAME tm2_1.yy,tm2_1.mm WITHOUT DEFAULTS
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm2_1.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm2_1.yy
            IF g_azm.azm02 = 1 THEN
               IF tm2_1.mm > 12 OR tm2_1.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm2_1.mm > 13 OR tm2_1.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
      IF cl_null(tm2_1.yy) AND NOT cl_null(tm2_1.mm) THEN
         NEXT FIELD yy
      END IF
 
      #-----TQC-860018---------
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
         ON ACTION controlg      
            CALL cl_cmdask()     
      #-----END TQC-860018-----
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "imgg01 = '",g_argv1,"'"
   END IF
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
 
   MESSAGE ' WAIT '
#  LET g_sql =  " SELECT imgg_file.imgg01,ima02,ima021,ima25 ", #TQC-7A0112
   LET g_sql =  " SELECT imgg_file.imgg01,imgg02,imgg03,imgg04,imgg09,ima02,ima021,ima25 ", #TQC-7A0112
                " FROM imgg_file,ima_file",
                " WHERE imgg01 = ima01 ",
                " AND ",tm.wc CLIPPED,
                " ORDER BY imgg01 "
   PREPARE q610_prepare FROM g_sql
   DECLARE q610_cs                               #SCROLL CURSOR
      SCROLL CURSOR FOR q610_prepare
 
   # 取合乎條件筆數
   LET g_sql = " SELECT COUNT(*) FROM imgg_file ",
               " WHERE ",tm.wc CLIPPED
   PREPARE q610_pp FROM g_sql
   DECLARE q610_count CURSOR FOR q610_pp
END FUNCTION
 
FUNCTION q610_menu()
   WHILE TRUE
      CALL q610_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q610_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imkk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q610_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q610_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q610_cs                                  # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q610_count
      FETCH q610_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q610_fetch('F')                       # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q610_fetch(p_flag)
DEFINE
   p_flag   LIKE type_file.chr1     #處理方式  #No.FUN-690026 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q610_cs INTO g_imgg.imgg01,
                                           g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                           g_imgg.imgg04,g_imgg.imgg09, #TQC-7A0112 add imgg04,imgg09
                                           g_ima02,g_ima021,g_ima25
      WHEN 'P' FETCH PREVIOUS q610_cs INTO g_imgg.imgg01,
                                           g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                           g_imgg.imgg04,g_imgg.imgg09, #TQC-7A0112 add imgg04,imgg09
                                           g_ima02,g_ima021,g_ima25
      WHEN 'F' FETCH FIRST    q610_cs INTO g_imgg.imgg01,
                                           g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                           g_imgg.imgg04,g_imgg.imgg09, #TQC-7A0112 add imgg04,imgg09
                                           g_ima02,g_ima021,g_ima25
      WHEN 'L' FETCH LAST     q610_cs INTO g_imgg.imgg01,
                                           g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                           g_imgg.imgg04,g_imgg.imgg09, #TQC-7A0112 add imgg04,imgg09
                                           g_ima02,g_ima021,g_ima25
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION about
                  CALL cl_about()
               ON ACTION help
                  CALL cl_show_help()
               ON ACTION controlg
                  CALL cl_cmdask()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
            FETCH ABSOLUTE g_jump q610_cs INTO g_imgg.imgg01,
                                               g_imgg.imgg02,g_imgg.imgg03, #TQC-7A0112 add imgg02,imgg03
                                               g_imgg.imgg04,g_imgg.imgg09, #TQC-7A0112 add imgg04,imgg09
                                               g_ima02,g_ima021,g_ima25
         END IF
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0)
      INITIALIZE g_imgg.* TO NULL  #TQC-6B0105
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
   SELECT imgg01,imgg02,imgg03,imgg04,imgg09 INTO g_imgg.*
     FROM imgg_file
    WHERE imgg01 = g_imgg.imgg01 AND imgg02 = g_imgg.imgg02 AND imgg03 = g_imgg.imgg03 AND imgg04 = g_imgg.imgg04 AND imgg09 = g_imgg.imgg09
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_imgg.imgg01,SQLCA.sqlcode,0) #No.FUN-660156
      CALL cl_err3("sel","imgg_file",g_imgg.imgg01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
      RETURN
   END IF
   CALL q610_show()
END FUNCTION
 
FUNCTION q610_show()
   DISPLAY BY NAME g_imgg.*                      # 顯示單頭值
   DISPLAY g_ima02, g_ima021,g_ima25 TO ima02,ima021,ima25
   CALL q610_b_fill()                            #單身
   CALL cl_show_fld_cont()                       #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q610_b_fill()                           #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(2000)
          l_nouse   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   IF cl_null(tm2_1.yy) THEN
      LET l_sql = " SELECT imkk05,imkk06,imkk081,imkk082, ",
                  "        imkk083,imkk084,imkk085,imkk09",
                  "   FROM imkk_file",
                  "  WHERE imkk01 = '",g_imgg.imgg01,"'",
                  "    AND imkk02 = '",g_imgg.imgg02,"'",
                  "    AND imkk03 = '",g_imgg.imgg03,"'",
                  "    AND imkk04 = '",g_imgg.imgg04,"'",
                  "    AND imkk10 = '",g_imgg.imgg09,"'",
                  "  ORDER BY imkk05,imkk06 "
   ELSE
      IF cl_null(tm2_1.mm) OR tm2_1.mm = '0' THEN LET tm2_1.mm = '0'  END IF
      LET l_sql = " SELECT imkk05,imkk06,imkk081,imkk082, ",
                  "        imkk083,imkk084,imkk085,imkk09",
                  "   FROM imkk_file",
                  "  WHERE imkk01 = '",g_imgg.imgg01,"'",
                  "    AND imkk02 = '",g_imgg.imgg02,"'",
                  "    AND imkk03 = '",g_imgg.imgg03,"'",
                  "    AND imkk04 = '",g_imgg.imgg04,"'",
                  "    AND imkk10 = '",g_imgg.imgg09,"'",
                  "    AND imkk05 >= ",tm2_1.yy,
                  "    AND imkk06 >= ",tm2_1.mm,
                  "  ORDER BY imkk05,imkk06 "
   END IF
 
   PREPARE q610_pb FROM l_sql
   DECLARE q610_bcs                              #BODY CURSOR
      CURSOR FOR q610_pb
 
   FOR g_cnt = 1 TO g_imkk.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_imkk[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q610_bcs INTO g_imkk[g_cnt].*
      IF g_cnt=1 THEN
         LET g_rec_b=SQLCA.SQLERRD[3]
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_imkk[g_cnt].imkk081) THEN LET g_imkk[g_cnt].imkk081 = 0 END IF
      IF cl_null(g_imkk[g_cnt].imkk082) THEN LET g_imkk[g_cnt].imkk082 = 0 END IF
      IF cl_null(g_imkk[g_cnt].imkk083) THEN LET g_imkk[g_cnt].imkk083 = 0 END IF
      IF cl_null(g_imkk[g_cnt].imkk084) THEN LET g_imkk[g_cnt].imkk084 = 0 END IF
      IF cl_null(g_imkk[g_cnt].imkk085) THEN LET g_imkk[g_cnt].imkk085 = 0 END IF
      IF cl_null(g_imkk[g_cnt].imkk09) THEN LET g_imkk[g_cnt].imkk09 = 0 END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_imkk.deleteElement(g_cnt)  #TQC-790058
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imkk TO s_imkk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()                    #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL q610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about
         CALL cl_about()
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
