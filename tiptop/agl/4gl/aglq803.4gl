# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq803.4gl
# Descriptions...: 科目異動沖帳科目餘額查詢
# Date & Author..: 92/07/10 BY MAY
#                  By Melody    aee00 改為 no-use
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/26 By Nicola 報表架構修改
# Moidfy.........: No.FUN-5C0015 06/01/02 By kevin
#                  單頭增加欄位「異動碼類型代號aed012,FORMONLY.ahe02，^p q_ahei
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0093 06/11/22 By wujie  報表增加“接下頁/結束” 
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/03 By atsea 會計科目加帳套-財務
# Modify.........: No.TQC-740093 07/04/18 By dxfwo 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830144 08/04/07 By lilingyu 改CR報表 
# Modify.........: No.MOD-910142 09/01/13 By Sarah 抓ahe_file時不應過濾ahe00 = g_aed1.aed00
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-950040 10/03/03 By huangrh OPEN q803_c1 using 順序錯誤
# Modify.........: No:MOD-A20101 10/04/08 By wujie 13期不能打印
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: No.MOD-C40088 12/04/17 By yinhy 點擊列印按鈕，應只列印本畫面資料
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm     RECORD
                 wc     LIKE type_file.chr1000    # Head Where condition  #No.FUN-680098  VARCHAR(600) 
              END RECORD,
       g_aed1 RECORD
                 aed00   LIKE aed_file.aed00,  #No.FUN-740020
                 aed01   LIKE aed_file.aed01,
                 aed011  LIKE aed_file.aed011,
                 aed012  LIKE aed_file.aed012, # No.FUN-5C0015 add
                 aed02   LIKE aed_file.aed02,
                 aed03   LIKE aed_file.aed03
              END RECORD,
       g_aed  DYNAMIC ARRAY OF RECORD
                 seq     LIKE ze_file.ze03,    #No.FUN-680098 VARCHAR(4)
                 aed05   LIKE aed_file.aed05,
                 aed06   LIKE aed_file.aed06,
                 summ    LIKE aed_file.aed05
              END RECORD,
       m_cnt           LIKE type_file.num10,     #No.FUN-680098  integer
       g_argv1         LIKE aed_file.aed00,      # INPUT ARGUMENT - 1
       g_bookno        LIKE aaa_file.aaa01,      #帳別  #No.FUN-670039
        g_wc,g_sql      STRING,    #WHERE CONDITION  #No.FUN-580092 HCN    
       l_total         LIKE aed_file.aed05,
       g_rec_b         LIKE type_file.num5     #單身筆數        #No.FUN-680098 smallint
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-680098  integer
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_msg           LIKE ze_file.ze03       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680098 integer
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680098 integer
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE l_table         STRING                       #NO.FUN-830144                                                                  
DEFINE gg_sql          STRING                       #NO.FUN-830144                                                                  
DEFINE g_str           STRING                       #NO.FUN-830144 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0073
     DEFINE
          l_sl        LIKE type_file.num5,         #No.FUN-680098     smallint
          p_row,p_col LIKE type_file.num5          #No.FUN-680098     smallint
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
  #NO.FUN-830144  --Begin--                                                                                                           
   LET gg_sql ="aed01.aed_file.aed01,",                                                                                             
               "aag02.aag_file.aag02,",                                                                                             
               "aed011.aed_file.aed011,",                                                                                           
               "aed02.aed_file.aed02,",                                                                                             
               "aed03.aed_file.aed03,",                                                                                             
               "aed05.aed_file.aed05,",                                                                                             
               "aed06.aed_file.aed06,",                                                                                             
               "summ.aed_file.aed05,",                                                                                              
               "azi04.azi_file.azi04,",                                                                                             
               "m_cnt.type_file.num10"                                                                                              
   LET l_table = cl_prt_temptable('aglq803',gg_sql) CLIPPED                                                                         
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
   LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                 " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                                                     
   PREPARE insert_prep FROM gg_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',STATUS,1)                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
#NO.FUN-830144  --End---  
 
   LET g_bookno = ARG_VAL(1)
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW q803_w AT p_row,p_col
     WITH FORM "agl/42f/aglq803"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL q803_menu()
 
   CLOSE FORM q803_w                      #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION q803_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_aed.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                  # Default condition
 
   # FUN-5C0015 (s)
   # add aed012
   CALL cl_set_head_visible("","YES")       #No.FUN-6B0029
 
#   CONSTRUCT BY NAME tm.wc ON aed01,aed03,aed011,aed012,aed02          #No.FUN-740020
   INITIALIZE g_aed1.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON aed00,aed01,aed03,aed011,aed012,aed02    #No.FUN-740020
   # FUN-5C0015 (e)
 
      # FUN-5C0015 (s)
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
#No.FUN-740020--begin--
           WHEN INFIELD(aed00) #異動碼類型代號
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_aaa"           #No.TQC-740093  
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aed00
              NEXT FIELD aed00
#No.FUN-740020--end--
#No.FUN-B50051--str--       #增加科目编号开窗查询功能
            WHEN INFIELD(aed01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aed01
                   NEXT FIELD aed01
 #No.FUN-B50051--end--
           WHEN INFIELD(aed012) #異動碼類型代號
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ahe"
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aed012
              NEXT FIELD aed012
           OTHERWISE EXIT CASE
         END CASE
      # FUN-5C0015 (e)
 
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
  #LET g_sql=" SELECT UNIQUE aed01,aed011,aed02,aed03 FROM aed_file,aag_file  ",
#   LET g_sql=" SELECT UNIQUE aed01,aed011,aed012,aed02,aed03 FROM aed_file,aag_file  ",       #No.FUN-740020
   LET g_sql=" SELECT UNIQUE aed00,aed01,aed011,aed012,aed02,aed03 FROM aed_file,aag_file  ",  #No.FUN-740020
  # No.FUN-5C0015 (e)
             "  WHERE 1=1 AND ",tm.wc CLIPPED,
             "    AND aag00 = aed00 ",                #No.FUN-740020
             "    AND aag01 = aed01 ",
             "  ORDER BY aed00,aed01,aed011,aed012,aed02,aed03 "
   PREPARE q803_prepare FROM g_sql
   DECLARE q803_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q803_prepare
 
   DROP TABLE x
 
  # No.FUN-5C0015 (s)
  #LET g_sql=" SELECT UNIQUE aed01,aed011,aed02,aed03 FROM aed_file,aag_file  ",
   LET g_sql=" SELECT UNIQUE aed00,aed01,aed011,aed012,aed02,aed03 FROM aed_file,aag_file  ", #No.FUN-740020
  # No.FUN-5C0015 (e)
             "  WHERE ",tm.wc CLIPPED,
             "    AND aag00 = aed00 ",              #No.FUN-740020
             "    AND aag01 = aed01 ",
             "   INTO TEMP x"
   PREPARE q803_prepare_pre FROM g_sql
   EXECUTE q803_prepare_pre
 
   DECLARE q803_count CURSOR FOR SELECT COUNT(*) FROM x
 
END FUNCTION
 
FUNCTION q803_menu()
 
   WHILE TRUE
      CALL q803_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q803_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q803_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aed),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q803_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aed.clear()
 
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
DEFINE p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1) 
       l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098  INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q803_cs INTO g_aed1.aed00,g_aed1.aed01,g_aed1.aed011,
                                           g_aed1.aed012,  #FUN-5C0015
                                           g_aed1.aed02,g_aed1.aed03
      WHEN 'P' FETCH PREVIOUS q803_cs INTO g_aed1.aed00,g_aed1.aed01,g_aed1.aed011,
                                           g_aed1.aed012,  #FUN-5C0015
                                           g_aed1.aed02,g_aed1.aed03
      WHEN 'F' FETCH FIRST    q803_cs INTO g_aed1.aed00,g_aed1.aed01,g_aed1.aed011,
                                           g_aed1.aed012,  #FUN-5C0015
                                           g_aed1.aed02,g_aed1.aed03
      WHEN 'L' FETCH LAST     q803_cs INTO g_aed1.aed00,g_aed1.aed01,g_aed1.aed011,
                                           g_aed1.aed012,  #FUN-5C0015
                                           g_aed1.aed02,g_aed1.aed03
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
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
         END IF
 
         FETCH ABSOLUTE g_jump q803_cs INTO g_aed1.aed00,g_aed1.aed01,g_aed1.aed011,
                                            g_aed1.aed012,  #FUN-5C0012
                                            g_aed1.aed02,g_aed1.aed03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aed1.aed02,SQLCA.sqlcode,0)
      INITIALIZE g_aed1.* TO NULL  #TQC-6B0105
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
 
   CALL q803_show()
 
END FUNCTION
 
FUNCTION q803_show()
 DEFINE  l_aag02         LIKE aag_file.aag02,
         l_aee04         LIKE aee_file.aee04,
         l_ahe02         LIKE ahe_file.ahe02  #FUN-5C0015
 
   DISPLAY BY NAME g_aed1.aed00,g_aed1.aed01,g_aed1.aed011,g_aed1.aed02,g_aed1.aed03,
                   g_aed1.aed012   # No.FUN-5C0015 add
 
   SELECT aag02 INTO l_aag02 FROM aag_file
    WHERE aag01 = g_aed1.aed01
      AND aag00 = g_aed1.aed00     #No.FUN-740020
      AND aagacti = 'Y'
   IF SQLCA.sqlcode THEN
      LET l_aag02 = ''
   END IF
 
   SELECT aee04 INTO l_aee04 FROM aee_file
    WHERE aee01 = g_aed1.aed01
      AND aee00 = g_aed1.aed00     #No.FUN-740020
      AND aee02 = g_aed1.aed011
      AND aee03 = g_aed1.aed02
      AND aeeacti = 'Y'
   IF STATUS THEN
      LET l_aee04 = ''
   END IF
 
  #FUN-5C0015(S)-------------
  #DISPLAY l_aag02,l_aee04 TO aag02,aee04
   SELECT ahe02 INTO l_ahe02 FROM ahe_file 
    WHERE ahe01 = g_aed1.aed012
  #   AND ahe00 = g_aed1.aed00   #No.FUN-740020   #MOD-910142 mark
   IF SQLCA.sqlcode THEN
      LET l_ahe02 = ''
   END IF
   DISPLAY l_aag02,l_aee04,l_ahe02 TO aag02,aee04,ahe02
  #FUN-5C0015(E)-------------
 
   CALL q803_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q803_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,      #No.FUN-680098 VARCHAR(400)
          l_n       LIKE type_file.num5          #No.FUN-680098  smallint
   LET l_sql = "SELECT '',aed05, aed06,(aed05-aed06)",
               "  FROM  aed_file",
               " WHERE aed01 = '",g_aed1.aed01,"'",
               "   AND aed00 = '",g_aed1.aed00,"'",  #No.FUN-740020 
               "   AND aed011 = '",g_aed1.aed011,"'",
               "   AND aed02 = '",g_aed1.aed02,"'",
               "   AND aed03 = ",g_aed1.aed03,"" ,
               "   AND aed04 =?"
   PREPARE q803_pb FROM l_sql
   DECLARE q803_bcs CURSOR FOR q803_pb
 
   CALL g_aed.clear()
 
   LET g_rec_b=0
   LET g_cnt = 0
   LET l_total = 0
 
   FOR g_cnt = 1 TO 14
      LET g_i = g_cnt - 1
      OPEN q803_bcs USING g_i    #由第０期開始抓
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
 
      FETCH q803_bcs INTO g_aed[g_cnt].*
     #FUN-5C0015(s)-----
     #IF STATUS THEN
      IF SQLCA.sqlcode = 100 THEN
     #FUN-5C0015(e)-----
         LET g_aed[g_cnt].aed05 = 0
         LET g_aed[g_cnt].aed06 = 0
         LET g_aed[g_cnt].summ = 0
      END IF
 
      IF g_i = 0 THEN
         CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
         LET g_aed[g_cnt].seq = g_msg clipped
      ELSE
         LET g_aed[g_cnt].seq = g_i
      END IF
 
      LET l_total = l_total + g_aed[g_cnt].summ
      LET g_aed[g_cnt].summ = l_total
      CLOSE q803_bcs
   END FOR
 
   CALL g_aed.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q803_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aed TO s_aed.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q803_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q803_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q803_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q803_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q803_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
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
     #LET l_ac = ARR_CURR()
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q803_out()
   DEFINE l_i     LIKE type_file.num5,          #No.FUN-680098  smallint
          l_sql1  LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(400)
          l_name  LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680098  VARCHAR(20) 
          l_aed   RECORD
                     aed00      LIKE aed_file.aed00,   #No.FUN-740020 
                     aed01      LIKE aed_file.aed01, 
                     aed011     LIKE aed_file.aed011,
                     aed02      LIKE aed_file.aed02,
                     aed03      LIKE aed_file.aed03
                  END RECORD,
          l_chr   LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1) 
   DEFINE l_aag02               LIKE aag_file.aag02    #NO.FUN-830144                                                               
   DEFINE m_cnt                 LIKE type_file.num10   #NO.FUN-830144 
   DEFINE l_wc            STRING   #MOD-C40088
  
   IF tm.wc IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
  #NO.FUN-830144  --Begin--                                                                                                           
 #   CALL cl_wait()                                                                                                                 
 #   CALL cl_outnam('aglq803') RETURNING l_name                                                                                     
    CALL cl_del_data(l_table)                                                                                                       
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglq803'                                                                     
#NO.FUN-830144  --End--   
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_lang
 
   #No.MOD-C40088  --Begin
   LET l_wc = ' aed01="',g_aed1.aed01,'"',
              ' AND aed00="',g_aed1.aed00,'"',
              ' AND aed011="',g_aed1.aed011,'"',
              ' AND aed012="',g_aed1.aed012,'"',
              ' AND aed02="',g_aed1.aed02,'"',
              ' AND aed03="',g_aed1.aed03,'"'
   #No.MOD-C40088  --End
   LET g_sql="SELECT UNIQUE aed00,aed01,aed011,aed02,aed03",   # 組合出 SQL 指令    #No.FUN-740020 
             " FROM aed_file ",
             " WHERE 1=1 AND ",tm.wc CLIPPED,
             "   AND ",l_wc CLIPPED,   #MOD-C40088
             " ORDER BY 1,2,3,4 "
   PREPARE q803_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE q803_co CURSOR FOR q803_p1
 
   LET l_sql1 = " SELECT '',aed05,aed06,(aed05-aed06)",    #No.TQC-6B0093
                " FROM aed_file" ,
                " WHERE aed01 = ?  AND aed011 = ?  AND aed02 = ? ",
                " AND aed03 = ?  AND aed04 = ? ",
                " AND aed00 = ? "                  #No.FUN-740020 
                      
   PREPARE q803_p2 FROM l_sql1               # RUNTIME 編譯
   DECLARE q803_c1 SCROLL CURSOR FOR q803_p2
 
#   START REPORT q803_rep TO l_name   #NO.FUN-830144
   LET l_total = 0
   LET g_success = 'Y'                #NO.FUN-830144
    
   FOREACH q803_co INTO l_aed.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
 
      LET l_total=0
      IF g_success = 'Y' THEN
          LET m_cnt = 0        #NO.FUN-830144
      END IF                        
      FOR g_cnt = 1 TO g_aed.getLength()
         LET g_i = g_cnt - 1
#No.TQC-950040--------begin
         OPEN q803_c1 USING l_aed.aed01,l_aed.aed011,l_aed.aed02,              #No.FUN-740020
                            l_aed.aed03,g_i,
                            l_aed.aed00
#No.TQC-950040--------end 
         FETCH q803_c1 INTO g_aed[g_cnt].*
 
         IF SQLCA.sqlcode THEN
            LET g_aed[g_cnt].aed05 = 0
            LET g_aed[g_cnt].aed06 = 0
            LET g_aed[g_cnt].summ = 0
         END IF
 
         LET l_total = l_total + g_aed[g_cnt].summ
         LET g_aed[g_cnt].summ = l_total
         #NO.FUN-830144  --Begin--     
      #    OUTPUT TO REPORT q803_rep(l_aed.*,g_aed[g_cnt].*)
 
      #   CLOSE q803_bcs
        SELECT aag02 INTO l_aag02 FROM aag_file                                                                                    
          WHERE aag01 = l_aed.aed01                                                                                                 
            AND aag00 = l_aed.aed00                                                                                                 
            AND aagacti = 'Y'                                                                                                       
         IF SQLCA.sqlcode THEN                                                                                                      
            LET l_aag02 = ' '                                                                                                       
         END IF                                                                                                                     
                                                                                                                                    
         EXECUTE insert_prep USING                                                                                                  
            l_aed.aed01,l_aag02,l_aed.aed011,l_aed.aed02,l_aed.aed03,                                                               
            g_aed[g_cnt].aed05, g_aed[g_cnt].aed06, g_aed[g_cnt].summ,                                                              
            g_azi04,m_cnt                                                                                                           
                                                                                                                                    
         LET m_cnt = m_cnt + 1                                                                                                      
         IF m_cnt = 14 THEN           #No.MOD-A20101  
            LET m_cnt = 0                                                                                                           
         END IF                                                                                                                     
         #NO.FUN-830144  --End--      
      END FOR
      LET g_success = 'N'    #NO.FUN-830144        
   END FOREACH
   #NO.FUN-830144  --Begin--
#   FINISH REPORT q803_rep
 
 #  CLOSE q803_co
 #  ERROR ""
 #  CALL cl_prt(l_name,' ','1',g_len)
    LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
                                                                                                                                    
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'aed00,aed01,aed03,aed011,aed012,aed02')                                                                  
      RETURNING tm.wc                                                                                                               
   ELSE                                                                                                                             
          LET tm.wc=""                                                                                                              
   END IF                                                                                                                           
                                                                                                                                    
   LET g_str = tm.wc                                                                                                                
                                                                                                                                    
   CALL cl_prt_cs3('aglq803','aglq803',gg_sql,g_str)                                                                                
 #NO.FUN-830144  --End-- 
   CALL q803_b_fill()           #No.TQC-6B0093
 
 
END FUNCTION
 
#NO.FUN-830144  --Begin--
#REPORT q803_rep(sr,sr1)
#   DEFINE l_trailer_sw   LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1) 
#          m_cnt          LIKE type_file.num10,    #No.FUN-680098  integer
#          l_aag02         LIKE aag_file.aag02,  
#          sr              RECORD
#                             aed00    LIKE aed_file.aed00,    #No.FUN-740020
#                             aed01    LIKE aed_file.aed01,
#                             aed011   LIKE aed_file.aed011,
#                             aed02    LIKE aed_file.aed02,
#                             aed03    LIKE aed_file.aed03
#                          END RECORD,
#          sr1             RECORD
#                             seq      LIKE ze_file.ze03,  #No.TQC-6B0093
#                             aed05    LIKE aed_file.aed05,
#                             aed06    LIKE aed_file.aed06,
#                             summ     LIKE aed_file.aed05
#                          END RECORD,
#          l_chr           LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1) 
#   DEFINE g_head1         STRING
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
# # ORDER BY sr.aed01,sr.aed011,sr.aed02,sr.aed03
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT g_dash[1,g_len]
#
#         SELECT aag02 INTO l_aag02 FROM aag_file
#          WHERE aag01 = sr.aed01
#            AND aag00 = sr.aed00    #No.FUN-740020
#            AND aagacti = 'Y'
#         IF SQLCA.sqlcode THEN
#            LET l_aag02 = ' '
#         END IF
#
#         LET g_head1 = g_x[9] CLIPPED,' ',sr.aed01,'     ',
#                       g_x[13] CLIPPED,l_aag02
#         PRINT g_head1
#         PRINT ' '
#         LET g_head1 = g_x[10] CLIPPED,' (',sr.aed011,') ',sr.aed02,'     ',
#                       g_x[11] CLIPPED, sr.aed03 USING '####'
#         PRINT g_head1
#         PRINT ' '
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#         PRINT g_dash1
#         LET m_cnt = 0
#         LET l_trailer_sw = 'n'              #TQC-6B0093
#
#      ON EVERY ROW
#         IF m_cnt = 0 THEN
#            PRINT COLUMN g_c[31],g_x[12] CLIPPED;
#         ELSE
#            PRINT COLUMN g_c[31],m_cnt USING '####';
#         END IF
#
#         PRINT COLUMN g_c[32],cl_numfor(sr1.aed05,32,g_azi04),
#               COLUMN g_c[33],cl_numfor(sr1.aed06,33,g_azi04),
#               COLUMN g_c[34],cl_numfor(sr1.summ,34,g_azi04)
#
#         LET m_cnt = m_cnt + 1
#
#         IF m_cnt = 13 THEN
#            LET m_cnt=0
#         #  PRINT
#         #  PRINT
#            SKIP TO TOP OF PAGE
#         END IF
#
##No.TQC-6B0093--begin                                                                                                               
#      ON LAST ROW                                                                                                                   
#        PRINT                                                                                                                       
#        #是否列印選擇條件                                                                                                           
#        IF g_zz05 = 'Y' THEN                                                                                                        
#           CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')                                                                     
#                RETURNING tm.wc                                                                                                     
#           PRINT g_dash[1,g_len]                                                                                                    
#                IF tm.wc[001,070] > ' ' THEN            # for 80                                                                    
#           PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF                                                                       
#                IF tm.wc[071,140] > ' ' THEN                                                                                        
#            PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF                                                                      
#                IF tm.wc[141,210] > ' ' THEN                                                                                        
#            PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF                                                                      
#                IF tm.wc[211,280] > ' ' THEN                                                                                        
#            PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF                                                                      
#        END IF                                                                                                                      
#        PRINT g_dash[1,g_len]                                                                                                       
#        LET l_trailer_sw = 'y'                                                                                                      
#        PRINT  g_x[4],COLUMN g_len-9,g_x[7] CLIPPED                                                                                 
#                                                    
#      PAGE TRAILER                                                                                                                  
#         IF l_trailer_sw = 'n' THEN                                                                                                 
#            PRINT g_dash[1,g_len]                                                                                                   
#            PRINT g_x[4],COLUMN g_len-9,g_x[6] CLIPPED                                                                              
#         ELSE                                                                                                                       
#            SKIP 2 LINE                                                                                                             
#         END IF                                                                                                                     
#         PRINT                                                                                                                      
##No.TQC-6B0093--end                                                                                                                 
#                     
#END REPORT
#NO.FUN-830144   --End--
