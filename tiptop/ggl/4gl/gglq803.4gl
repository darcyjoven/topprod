# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gglq803.4gl
# Descriptions...: 科目幣別異動碼沖帳餘額查詢
# Date & Author..: 02/02/28 By Danny
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/26 By Nicola 報表架構修改
# Moidfy.........: No.FUN-5C0015 06/01/03 By kevin
#                  單頭增加欄位「異動碼類型代號aec052」,FORMONLY.ahe02，^p q_ahe
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-690009 06/09/14 By Flowld 欄位類型定義改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850011 08/05/07 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C40088 12/04/11 By yinhy 點擊列印按鈕，應只列印本畫面資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm      RECORD
                  wc      LIKE type_file.chr1000 #No.FUN-690009  VARCHAR(1000)             # Head Where condition
               END RECORD,
       g_ted1  RECORD
                  ted01   LIKE ted_file.ted01,
                  ted00   LIKE ted_file.ted00,   #No.FUN-740033
                  ted011  LIKE ted_file.ted011,
                  ted012  LIKE ted_file.ted012,  # No.FUN-5C0015 add
                  ted02   LIKE ted_file.ted02,
                  ted03   LIKE ted_file.ted03,
                  ted09   LIKE ted_file.ted09
               END RECORD,
       g_ted   DYNAMIC ARRAY OF RECORD
                  seq     LIKE ze_file.ze03, #No.FUN-690009 VARCHAR(04),
                  ted10   LIKE ted_file.ted10,
                  ted11   LIKE ted_file.ted11,
                  summ    LIKE ted_file.ted10
               END RECORD,
       m_cnt        LIKE type_file.num10,      #No.FUN-690009 INTEGER,
       g_argv1      LIKE ted_file.ted00,      # INPUT ARGUMENT - 1
       g_bookno     LIKE aaa_file.aaa01,       #帳別  #No.FUN-670039
        g_wc,g_sql   string,     #WHERE CONDITION  #No.FUN-580092 HCN
       l_total      LIKE ted_file.ted10,
       g_rec_b      LIKE type_file.num5       #No.FUN-690009 SMALLINT               #單身筆數
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-690009 INTEGER
DEFINE g_i          LIKE type_file.num5       #No.FUN-690009 SMALLINT   #count/index for any purpose
DEFINE g_msg        LIKE ze_file.ze03     #No.FUN-690009 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-690009 INTEGER
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-690009 INTEGER
#No.FUN-850011--begin--
DEFINE l_sql            STRING                                                                               
DEFINE g_str            STRING                                                                               
DEFINE l_table          STRING
#No.FUN-850011--end--
MAIN
#     DEFINE   l_time LIKE type_file.chr8               #No.FUN-6A0097
DEFINE         l_sl,p_row,p_col LIKE type_file.num5     #No.FUN-690009 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-850011--begin--
   LET g_sql="ted01.ted_file.ted01,",
             "aag02.aag_file.aag02,",
             "ted011.ted_file.ted011,",
             "ted02.ted_file.ted02,",
             "ted03.ted_file.ted03,",
             "ted09.ted_file.ted09,",
             "ted10.ted_file.ted10,",
             "ted11.ted_file.ted11,",
             "summ.ted_file.ted10,",
             "m_cnt.type_file.num5,",
             "ted012.ted_file.ted012,",
             "ted00.ted_file.ted00,",
             "aee04.aee_file.aee04,",
             "ahe02.ahe_file.ahe02"
    LET l_table = cl_prt_temptable('gglq803',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"                                                                           
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF    
#No.FUN-850011--end-- 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
 
   LET g_bookno = ARG_VAL(1)
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW q803_w AT p_row,p_col      #顯示畫面
     WITH FORM "ggl/42f/gglq803"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL q803_menu()
 
   CLOSE FORM q803_w                      #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
 
END MAIN
 
FUNCTION q803_cs()
   DEFINE   l_cnt  LIKE type_file.num5    #No.FUN-690009 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_ted.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                  # Default condition
 
   # FUN-5C0015 Add ted012
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ted1.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON ted01,ted00,ted03,ted011,ted012,ted02,ted09  #No.FUN-740033
 
      # FUN-5C0015 (s) -------------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
           WHEN INFIELD(ted012) #異動碼類型代號
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ahe"
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ted012
              NEXT FIELD ted012
           OTHERWISE EXIT CASE
         END CASE
      # FUN-5C0015 (e) -------------
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
  # No.FUN-5C0015 (s)
  #LET g_sql="SELECT UNIQUE ted01,ted011,ted02,ted03,ted09 ",
   LET g_sql="SELECT UNIQUE ted01,ted00,ted011,ted012,ted02,ted03,ted09 ",  #No.FUN-740033
  #No.FUN-5C0015 (e)
             "  FROM ted_file,aag_file ",
             " WHERE 1=1 AND ",tm.wc CLIPPED,
             "   AND aag01 = ted01 ",
             "   AND aag00 = ted00 ",  #No.FUN-740033
             " ORDER BY ted00,ted01,ted011,ted012,ted02,ted03,ted09 " #FUN-5C0015 Add ted012  #No.FUN-740033
   PREPARE q803_prepare FROM g_sql
   DECLARE q803_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q803_prepare
 
   DROP TABLE x
  #No.FUN-5C0015 (s)
  #LET g_sql="SELECT UNIQUE ted01,ted011,ted02,ted03,ted09 ",
   LET g_sql="SELECT UNIQUE ted00,ted01,ted011,ted012,ted02,ted03,ted09 ",  #No.FUN-740033
  #No.FUN-5C0015 (e)
             "  FROM ted_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND aag01 = ted01 ",
             "   AND aag00 = ted00 ",  #No.FUN-740033
             "  INTO TEMP x"
   PREPARE q803_prepare_pre FROM g_sql
   EXECUTE q803_prepare_pre
 
   DECLARE q803_count CURSOR FOR SELECT COUNT(*) FROM x
 
END FUNCTION
 
FUNCTION q803_menu()
   LET g_action_choice=" "
 
   WHILE TRUE
      CALL q803_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q803_q()
            END IF
         WHEN "first"
            CALL q803_fetch('F')
         WHEN "previous"
            CALL q803_fetch('P')
         WHEN "jump"
            CALL q803_fetch('/')
         WHEN "next"
            CALL q803_fetch('N')
         WHEN "last"
            CALL q803_fetch('L')
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q803_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ted),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q803_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_ted.clear()
 
   CALL q803_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN q803_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q803_count
      FETCH q803_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q803_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q803_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1,   #No.FUN-690009 VARCHAR(1),               #處理方式
       l_abso          LIKE type_file.num10   #No.FUN-690009 INTEGER                #絕對的筆數
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q803_cs INTO g_ted1.ted01,g_ted1.ted00,  #No.FUN-740033
                                           g_ted1.ted011,
                                           g_ted1.ted012,  #FUN-5C0015
                                           g_ted1.ted02,g_ted1.ted03,
                                           g_ted1.ted09
      WHEN 'P' FETCH PREVIOUS q803_cs INTO g_ted1.ted01,g_ted1.ted00,  #No.FUN-740033
                                           g_ted1.ted011,
                                           g_ted1.ted012,  #FUN-5C0015
                                           g_ted1.ted02,g_ted1.ted03,
                                           g_ted1.ted09
      WHEN 'F' FETCH FIRST    q803_cs INTO g_ted1.ted01,g_ted1.ted00,  #No.FUN-740033
                                           g_ted1.ted011,
                                           g_ted1.ted012,  #FUN-5C0015
                                           g_ted1.ted02,g_ted1.ted03,
                                           g_ted1.ted09
      WHEN 'L' FETCH LAST     q803_cs INTO g_ted1.ted01,g_ted1.ted00,  #No.FUN-740033
                                           g_ted1.ted011,
                                           g_ted1.ted012,  #FUN-5C0015
                                           g_ted1.ted02,g_ted1.ted03,
                                           g_ted1.ted09
      WHEN '/'
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
         LET INT_FLAG = 0  ######add for prompt bug
 
         PROMPT g_msg CLIPPED,': ' FOR l_abso
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
 
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
 
         FETCH ABSOLUTE l_abso q803_cs INTO g_ted1.ted01,g_ted1.ted00,  #No.FUN-740033
                                            g_ted1.ted011,
                                            g_ted1.ted012,  #FUN-5C0015
                                            g_ted1.ted02,g_ted1.ted03,
                                            g_ted1.ted09
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ted1.ted02,SQLCA.sqlcode,0)
      INITIALIZE g_ted1.* TO NULL  #TQC-6B0105
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
 
   CALL q803_show()
 
END FUNCTION
 
FUNCTION q803_show()
 DEFINE  l_aag02         LIKE aag_file.aag02,
         l_aee04         LIKE aee_file.aee04,
         l_ahe02         LIKE ahe_file.ahe02    #FUN-5C0015
 
 
   #FUN-5C0015 Add ted012
   DISPLAY BY NAME g_ted1.ted01,g_ted1.ted011,g_ted1.ted012,g_ted1.ted02,
                   g_ted1.ted03,g_ted1.ted09,g_ted1.ted00  #No.FUN-740033
 
   SELECT aag02 INTO l_aag02 FROM aag_file
    WHERE aag01 = g_ted1.ted01
      AND aagacti = 'Y'
      AND aag00 = g_ted1.ted00  #No.FUN-740033
   IF SQLCA.sqlcode THEN
      LET l_aag02 = ''
   END IF
 
   SELECT aee04 INTO l_aee04 FROM aee_file
    WHERE aee01 = g_ted1.ted01
      AND aee02 = g_ted1.ted011
      AND aee03 = g_ted1.ted02
      AND aee00 = g_ted1.ted00  #No.FUN-740033
      AND aeeacti = 'Y'
   IF STATUS THEN
      LET l_aee04 = ''
   END IF
 
  # No.FUN-5C0015 (s)
   SELECT ahe02 INTO l_ahe02 FROM ahe_file
    WHERE ahe01 = g_ted1.ted012
   IF SQLCA.sqlcode THEN LET l_ahe02 = '' END IF
   DISPLAY l_ahe02 TO ahe02
  # No.FUN-5C0015 (e)
 
   DISPLAY l_aag02,l_aee04 TO aag02,aee04
 
   CALL q803_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q803_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,#No.FUN-690009 VARCHAR(1000),
          l_n       LIKE type_file.num5    #No.FUN-690009 SMALLINT
 
   LET l_sql = "SELECT 0,ted10, ted11,(ted10-ted11)",
               "  FROM ted_file",
               " WHERE ted01 = '",g_ted1.ted01,"'",
               "   AND ted011 = '",g_ted1.ted011,"'",
               "   AND ted012 = '",g_ted1.ted012,"'",   #FUN-5C0015
               "   AND ted02 = '",g_ted1.ted02,"'",
               "   AND ted03 = ",g_ted1.ted03,"" ,
               "   AND ted00 = '",g_ted1.ted00,"'" ,    #No.FUN-740033
               "   AND ted04 =? ",
               "   AND ted09 = '",g_ted1.ted09,"'"
   PREPARE q803_pb FROM l_sql
   DECLARE q803_bcs CURSOR FOR q803_pb
 
   CALL g_ted.clear()
   LET g_rec_b=0
   LET g_cnt = 0
   LET l_total = 0
 
   FOR g_cnt = 1 TO 14
      LET g_i = g_cnt - 1
 
      IF g_i = 0 THEN
         CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
         LET g_ted[g_cnt].seq = g_msg CLIPPED
      ELSE
         LET g_ted[g_cnt].seq = g_i
      END IF
 
      OPEN q803_bcs USING g_i    #由第０期開始抓
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
 
      FETCH q803_bcs INTO g_ted[g_cnt].*
     #FUN-5C0015(s)------------
     #IF SQLCA.SQLERRD[3] = 0 THEN
      IF SQLCA.sqlcode = 100 THEN
     #FUN-5C0015(e)------------
         LET g_ted[g_cnt].ted10 = 0
         LET g_ted[g_cnt].ted11 = 0
         LET g_ted[g_cnt].summ = 0
      END IF
 
      IF g_i = 0 THEN
         CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
         LET g_ted[g_cnt].seq = g_msg CLIPPED
      ELSE
         LET g_ted[g_cnt].seq = g_i
      END IF
 
      LET l_total = l_total + g_ted[g_cnt].summ
      LET g_ted[g_cnt].summ = l_total
      CLOSE q803_bcs
   END FOR
 
   LET g_rec_b = 14
 
END FUNCTION
 
FUNCTION q803_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1   #No.FUN-690009 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ted TO s_ted.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()                             #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
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
 
FUNCTION q803_out()
   DEFINE l_i             LIKE type_file.num5,     #No.FUN-690009 SMALLINT,
          l_sql1          LIKE type_file.chr1000,  #No.FUN-690009 VARCHAR(400),
          l_name          LIKE type_file.chr20,    #No.FUN-690009 VARCHAR(20),                # External(Disk) file name
          l_ted_arrno     LIKE type_file.num5,     #No.FUN-690009 SMALLINT,
          l_ted           RECORD
                             ted00      LIKE ted_file.ted00,  #No.FUN-740033
                             ted01      LIKE ted_file.ted01,
                             ted011     LIKE ted_file.ted011,
                             ted02      LIKE ted_file.ted02,
                             ted03      LIKE ted_file.ted03,
                             ted09      LIKE ted_file.ted09,
                             ted012     LIKE ted_file.ted012  #No.FUN-850011
                          END RECORD,
          l_chr           LIKE type_file.chr1    #No.FUN-690009 VARCHAR(1)
#No.FUN-850011--begin--
   DEFINE m_cnt           LIKE type_file.num5,   
          l_aag02         LIKE aag_file.aag02,   
          l_aee04         LIKE aee_file.aee04,
          l_ahe02         LIKE ahe_file.ahe02
#No.FUN-850011--end--
   DEFINE l_wc            STRING   #MOD-C40088

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                             #No.FUN-850011
   CALL cl_del_data(l_table)                                                            #No.FUN-850011
   IF tm.wc IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_wait()
#  CALL cl_outnam('gglq803') RETURNING l_name                                           #No.FUN-850011
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_lang
 
#  LET g_sql="SELECT UNIQUE ted00,ted01,ted011,ted02,ted03,ted09", # 組合出 SQL 指令  #No.FUN-740033   #No.FUN-850011
#            " FROM ted_file ",                                                       #No.FUN-850011
   #No.MOD-C40088  --Begin
   LET l_wc = ' ted01="',g_ted1.ted01,'"',
              ' AND ted00="',g_ted1.ted00,'"',
              ' AND ted011="',g_ted1.ted011,'"',
              ' AND ted012="',g_ted1.ted012,'"',
              ' AND ted02="',g_ted1.ted02,'"',
              ' AND ted03="',g_ted1.ted03,'"',
              ' AND ted09="',g_ted1.ted09,'"'
   #No.MOD-C40088  --End
   LET g_sql="SELECT UNIQUE ted00,ted01,ted011,ted02,ted03,ted09,ted012",             #No.FUN-850011 
             " FROM ted_file,aag_file ",                                              #No.FUN-850011
             " WHERE 1=1 AND ",tm.wc CLIPPED,
             "   AND aag01 = ted01 ",                                                 #No.FUN-850011
             "   AND aag00 = ted00 ",                                                 #No.FUN-850011
             " ORDER BY ted00,ted01,ted011,ted02,ted03,ted09 "  #No.FUN-740033
   PREPARE q803_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE q803_co CURSOR FOR q803_p1
 
   LET l_sql1 = " SELECT 0,ted10,ted11,(ted10-ted11)",
                " FROM ted_file" ,
                " WHERE ted01 = ?  AND ted011 = ?  AND ted02 = ? ",
                " AND ted03 = ?  AND ted04 = ? AND ted09 = ? ",
                " AND ted00 = ? ",  #No.FUN-740033
                " AND ted012 = ? "  #No.FUN-850011
   PREPARE q803_p2 FROM l_sql1               # RUNTIME 編譯
   DECLARE q803_c1 SCROLL CURSOR FOR q803_p2
#  START REPORT q803_rep TO l_name                                #No.FUN-850011
 
   LET l_total = 0
 
   FOREACH q803_co INTO l_ted.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
 
#      IF g_aza.aza02 = '1' THEN                                  #No.FUN-850011    
#         LET l_ted_arrno = 13                                    #No.FUN-850011
#      ELSE                                                       #No.FUN-850011    
         LET l_ted_arrno = 14                                
#      END IF                                                     #No.FUN-850011
 
      LET l_total=0
      FOR g_cnt = 1 TO l_ted_arrno
         LET g_i = g_cnt - 1
         OPEN q803_c1 USING l_ted.ted01,l_ted.ted011,
#                           l_ted.ted02,l_ted.ted03,g_i,l_ted.ted09,l_ted.ted00  #No.FUN-740033  #No.FUN-850011
                            l_ted.ted02,l_ted.ted03,g_i,l_ted.ted09,l_ted.ted00,l_ted.ted012    #No.FUN-850011
         FETCH q803_c1 INTO g_ted[g_cnt].*
         IF SQLCA.sqlcode THEN
            LET g_ted[g_cnt].ted10 = 0
            LET g_ted[g_cnt].ted11 = 0
            LET g_ted[g_cnt].summ = 0
         END IF
 
         LET l_total = l_total + g_ted[g_cnt].summ
         LET g_ted[g_cnt].summ = l_total
#No.FUN-850011--begin--
      SELECT aag02 INTO l_aag02 FROM aag_file                                                    
          WHERE aag01 = l_ted.ted01                                                                         
            AND aag00 = l_ted.ted00                                                                          
            AND aagacti = 'Y'                                                                                   
         IF SQLCA.sqlcode THEN                                                                               
            LET l_aag02 = ' '                                                                              
         END IF                                                                                               
      SELECT aee04 INTO l_aee04 FROM aee_file
         WHERE aee01 = l_ted.ted01
          AND aee02 = l_ted.ted011
          AND aee03 = l_ted.ted02
          AND aee00 = l_ted.ted00 
          AND aeeacti = 'Y'
      IF STATUS THEN
         LET l_aee04 = ''
      END IF
      SELECT ahe02 INTO l_ahe02 FROM ahe_file
         WHERE ahe01 = l_ted.ted012
      IF SQLCA.sqlcode THEN LET l_ahe02 = '' END IF
#        OUTPUT TO REPORT q803_rep(l_ted.*,g_ted[g_cnt].*)
         EXECUTE insert_prep USING l_ted.ted01,l_aag02,l_ted.ted011,l_ted.ted02,l_ted.ted03,l_ted.ted09, 
                                   g_ted[g_cnt].ted10,g_ted[g_cnt].ted11,g_ted[g_cnt].summ,g_i,l_ted.ted012,
                                   l_ted.ted00,l_aee04,l_ahe02
         CLOSE q803_bcs
      END FOR
   END FOREACH
 
#  FINISH REPORT q803_rep
 
   CLOSE q803_co
   ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
   IF g_zz05 = 'Y' THEN                                                                                                           
      CALL cl_wcchp(tm.wc,'bhd04')                                                                                                
      RETURNING tm.wc                                                                                                        
      LET g_str = tm.wc                                                                                                           
   END IF                                                                                                                         
   LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   LET g_str=g_str,";",g_azi04
   CALL cl_prt_cs3('gglq803','gglq803',l_sql,g_str)
#No.FUN-850011--end--
END FUNCTION
#No.FUN-850011--begin--
#REPORT q803_rep(sr,sr1)
#  DEFINE l_trailer_sw  LIKE type_file.chr1,    #No.FUN-690009 VARCHAR(1),
#         m_cnt         LIKE type_file.num5,    #No.FUN-690009 INTEGER,
#         l_aag02      LIKE aag_file.aag02,
#         sr           RECORD
#                         ted00   LIKE ted_file.ted00,   #No.FUN-740033
#                         ted01   LIKE ted_file.ted01,
#                         ted011  LIKE ted_file.ted011,
#                         ted02   LIKE ted_file.ted02,
#                         ted03   LIKE ted_file.ted03,
#                         ted09   LIKE ted_file.ted09
#                      END RECORD,
#         sr1          RECORD
#                         ted10   LIKE ted_file.ted10,
#                         ted11   LIKE ted_file.ted11,
#                         summ    LIKE ted_file.ted10,
#                         seq     LIKE ze_file.ze03   #No.FUN-690009 VARCHAR(04)
#                      END RECORD,
#         l_chr        LIKE type_file.chr1    #No.FUN-690009 VARCHAR(1)
#  DEFINE g_head1      STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
## ORDER BY sr.ted01,sr.ted011,sr.ted02,sr.ted03
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED    #No.TQC-6A0094
#        PRINT ' '
#        PRINT g_dash[1,g_len]
 
#        SELECT aag02 INTO l_aag02 FROM aag_file
#         WHERE aag01 = sr.ted01
#           AND aag00 = sr.ted00  #No.FUN-740033
#           AND aagacti = 'Y'
#        IF SQLCA.sqlcode THEN
#           LET l_aag02 = ' '
#        END IF
#No.TQC-6A0094 -- begin --
#         LET g_head1 = g_x[9] CLIPPED,' ',sr.ted01,'    ',
#                       g_x[13] CLIPPED,l_aag02
#         PRINT g_head1
#        PRINT g_x[9] CLIPPED,' ',sr.ted01 CLIPPED
#        PRINT g_x[13] CLIPPED,l_aag02 CLIPPED
#No.TQC-6A0094 -- end --
#        PRINT ' '
#        LET g_head1 = g_x[10] CLIPPED,' (',sr.ted011 CLIPPED,') ',sr.ted02 CLIPPED,'     ',
#                      g_x[11] CLIPPED,sr.ted03 USING '####','     ',
#                      g_x[14] CLIPPED,sr.ted09 CLIPPED
#        PRINT g_head1 CLIPPED
#        PRINT ' '
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#        PRINT g_dash1 CLIPPED
#        LET m_cnt = 0
#        LET l_trailer_sw = 'y'
 
#     ON EVERY ROW
#        IF m_cnt = 0 THEN
#           PRINT COLUMN g_c[31],g_x[12] CLIPPED;
#No.TQC-6A0094 -- begin --                                                      
#           PRINT COLUMN g_c[32],cl_numfor(sr1.ted10,32,g_azi04),                 
#                 COLUMN g_c[33],cl_numfor(sr1.ted11,33,g_azi04),                 
#                 COLUMN g_c[34],cl_numfor(sr1.summ,34,g_azi04)                   
#           PRINT g_dash2[1,g_len]
#No.TQC-6A0094 -- end --
#        ELSE
#           PRINT COLUMN g_c[31],m_cnt USING '####';
#No.TQC-6A0094 -- begin --                                                      
#           PRINT COLUMN g_c[32],cl_numfor(sr1.ted10,32,g_azi04),                 
#                 COLUMN g_c[33],cl_numfor(sr1.ted11,33,g_azi04),                 
#                 COLUMN g_c[34],cl_numfor(sr1.summ,34,g_azi04)                   
#No.TQC-6A0094 -- end --
#        END IF
#No.TQC-6A0094 -- begin --
#         PRINT COLUMN g_c[32],cl_numfor(sr1.ted10,32,g_azi04),
#               COLUMN g_c[33],cl_numfor(sr1.ted11,33,g_azi04),
#               COLUMN g_c[34],cl_numfor(sr1.summ,34,g_azi04)
#No.TQC-6A0094 -- end --
#        LET m_cnt = m_cnt + 1
 
#        IF m_cnt = 13 THEN
#           LET m_cnt = 0
#            PRINT          #No.TQC-6A0094
#            PRINT          #No.TQC-6A0094
#            PRINT          #No.TQC-6A0094
#        END IF
#No.TQC-6A0094 -- begin --
#     ON LAST ROW
#        PRINT g_dash[1,g_len]                                               
#        LET l_trailer_sw = 'n'                                              
#        PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6A0094
#        ELSE
#           SKIP 2 LINE
#        END IF
#No.TQC-6A0094 -- end --
#END REPORT
#No.FUN-850011--end--
#No.FUN-870144
