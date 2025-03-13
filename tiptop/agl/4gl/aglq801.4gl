# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aglq801.4gl
# Descriptions...: 科目別異動明細查詢
# Date & Author..: 92/03/13 By DAVID WANG
# Modify.........: No.MOD-4A0034 04/10/04 By smapmin 資料有二筆,但是查詢只有一筆資料
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-560033 05/06/16 By ching fix筆數
# Modify.........: No.MOD-580107 05/09/08 By Smapmin 單身餘額不準確
# Moidfy.........: No.FUN-5C0015 06/01/02 By kevin 單頭增加欄位「異動碼類型代號aec052」,FORMONLY.ahe02
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By sherry  會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-8C0285 08/12/30 By Sarah aec00為NULL,導致科目名稱顯示不出來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A80179 10/08/25 By 依據借貸餘屬性呈現餘額 
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: No.MOD-BC0179 11/12/19 By Polly 增加帳別條件
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000,# Head Where condition   #No.FUN-680098 VARCHAR(600)
        	wc2     LIKE type_file.chr1000 # Body Where condition   #No.FUN-680098 VARCHAR(600) 
        END RECORD,
    l_aec  RECORD
            aec00   LIKE aec_file.aec00,        #No.FUN-740020 add    
            aec01   LIKE aec_file.aec01,
            aec051  LIKE aec_file.aec051,
            aec052  LIKE aec_file.aec052,       #No.FUN-5C0015 add
            aec05   LIKE aec_file.aec05,
            aee04   LIKE aee_file.aee04
        END RECORD,
    g_aec DYNAMIC ARRAY OF RECORD
            aec02   LIKE aec_file.aec02,
            aec03   LIKE aec_file.aec03,
            abb07_1 LIKE abb_file.abb07,#借
            abb07_2 LIKE abb_file.abb07,#貸
            abb99   LIKE type_file.num20_6     #餘額  #No.FUN-4C0009   #No.FUN-680098  decimal(20,6)
        END RECORD,
#   g_bookno     LIKE aec_file.aec00,      # INPUT ARGUMENT - 1    #No.FUN-740020
    g_argv2      LIKE aec_file.aec05,      # INPUT ARGUMENT - 2
    g_aag06      LIKE aag_file.aag06,      #MOD-A80179
     g_wc,g_wc2,g_sql,g_sql1 STRING, #WHERE CONDITION  #No.FUN-580092 HCN    
    g_rec_b LIKE type_file.num5,  		  #單身筆數        #No.FUN-680098 SMALLINT
    l_bal     LIKE type_file.num20_6  #No.FUN-4C0009     #No.FUN-680098  DECIMAL(20,6)
 
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03          #No.FUN-680098 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680098 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0073
      DEFINE    l_sl		LIKE type_file.num5             #No.FUN-680098  SMALLINT
   DEFINE p_row,p_col	LIKE type_file.num5             #No.FUN-680098  SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
    LET l_bal=0
#   LET g_bookno = ARG_VAL(1)          #參數值(1) Part# 
    LET l_aec.aec00 = ARG_VAL(1)          #參數值(1) Part#  #No.FUN-740020
 
#   CALL s_dsmark(g_bookno)   
    CALL s_dsmark(l_aec.aec00)         #No.FUN-740020
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq801_w AT p_row,p_col
         WITH FORM "agl/42f/aglq801"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    FOR l_sl = 9  TO 21 STEP 1 DISPLAY "" AT l_sl,1 END FOR
 
 
#   CALL s_shwact(0,0,g_bookno)         
    CALL s_shwact(0,0,l_aec.aec00)      #No.FUN-740020
 
#    IF cl_chk_act_auth() THEN
#       CALL q801_q()
#    END IF
#No.FUN-740020---begin
#IF NOT cl_null(g_bookno) THEN CALL q801_q() END IF
#   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 IF NOT cl_null(l_aec.aec00) THEN CALL q801_q() END IF
    IF cl_null(l_aec.aec00) THEN LET l_aec.aec00 = g_aza.aza81 END IF
#No.FUN-740020---end
    CALL q801_menu()
    CLOSE WINDOW aglq801_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q801_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098 smallint
 
   CLEAR FORM #清除畫面
   CALL g_aec.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      DISPLAY ''
   ELSE
      DISPLAY "[        ]" AT 9,1
   END IF
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
   INITIALIZE l_aec.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON                   # 螢幕上取單頭條件
#     aec01,aec051,aec052,aec05,aec02    # FUN-5C0015 add aec052
      aec00,aec01,aec051,aec052,aec05,aec02    # FUN-740020 add aec00  #FUN-B50051 add aec02
                  
     #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
     #No.FUN-580031 --end--       HCN
 
      # FUN-5C0015 (s)
      ON ACTION controlp
         CASE
           #No.FUN-740020--begin
            WHEN INFIELD(aec00) #異動碼類型代號
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aaa"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aec00
               NEXT FIELD aec00
           #No.FUN-740020--end
           #No.FUN-B50051--str--   #增加科目查询功能
            WHEN INFIELD(aec01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aec01
                   NEXT FIELD aec01
         #No.FUN-B50051--end--
            WHEN INFIELD(aec052) #異動碼類型代號
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ahe"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aec052
               NEXT FIELD aec052
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
   DISPLAY "" AT  9,1
   IF INT_FLAG THEN RETURN END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
  # No.FUN-5C0015 (s)
  #LET g_sql="SELECT UNIQUE aec01,aec051,aec05 ",
  #LET g_sql="SELECT UNIQUE aec01,aec051,aec052,aec05 ",        #MOD-8C0285 mark
   LET g_sql="SELECT UNIQUE aec00,aec01,aec051,aec052,aec05 ",  #MOD-8C0285
  # No.FUN-5C0015 (e)
             "  FROM aec_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,
   #         "   AND aec00 = '",g_bookno,"'",    #No.FUN-740020
             "   AND aec00 = aag00",    #No.FUN-740020
             "   AND aec01 = aag01 ",
            #" ORDER BY aec01,aec051,aec052,aec05 "  #FUN-5C0015 Add aec052        #MOD-8C0285 mark
             " ORDER BY aec00,aec01,aec051,aec052,aec05 "  #FUN-5C0015 Add aec052  #MOD-8C0285
   PREPARE q801_prepare FROM g_sql
   DECLARE q801_cs SCROLL CURSOR FOR q801_prepare      #SCROLL CURSOR
   DISPLAY "g_sql=???",g_sql
 
  #LET g_sql="SELECT COUNT(DISTINCT aec01) FROM aec_file ",  #No.MOD-4A0034 筆誤更正為aec01
  #          " WHERE ",tm.wc CLIPPED,
  #          "   AND aec00 = '",g_bookno,"'"
  #PREPARE q801_precount FROM g_sql
  #DECLARE q801_count CURSOR FOR q801_precount
 
   #MOD-560033
   DROP TABLE count_tmp
  #LET g_sql="SELECT aec01,aec051,aec052,aec05 ",   #FUN-5C0015 Add aec052        #MOD-8C0285 mark
   LET g_sql="SELECT aec00,aec01,aec051,aec052,aec05 ",   #FUN-5C0015 Add aec052  #MOD-8C0285
             "  FROM aec_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,
#            "   AND aec00 = '",g_bookno,"'",    #No.FUN-740020
             "   AND aec00 = aag00",    #No.FUN-740020
             "   AND aec01 = aag01 ",
            #" GROUP BY aec01,aec051,aec052,aec05 ", #FUN-5C0015 Add aec052       #MOD-8C0285 mark
             " GROUP BY aec00,aec01,aec051,aec052,aec05 ", #FUN-5C0015 Add aec052 #MOD-8C0285
             "  INTO TEMP count_tmp"
   PREPARE q801_cnt_tmp  FROM g_sql
   EXECUTE q801_cnt_tmp
   DECLARE q801_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
   #--
 
END FUNCTION
 
FUNCTION q801_b_askkey()
   LET l_bal =0
   DISPLAY "[        ]" AT 9,1
END FUNCTION
 
FUNCTION q801_menu()
 
   WHILE TRUE
      CALL q801_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q801_q()
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
 
FUNCTION q801_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q801_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q801_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q801_count
       FETCH q801_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
        CALL q801_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q801_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    LET l_bal=0
    CASE p_flag
       WHEN 'N' FETCH NEXT     q801_cs INTO l_aec.aec00,l_aec.aec01,l_aec.aec051,   #MOD-8C0285 add aec00
                                            l_aec.aec052,   #FUN-5C0015
                                            l_aec.aec05
       WHEN 'P' FETCH PREVIOUS q801_cs INTO l_aec.aec00,l_aec.aec01,l_aec.aec051,   #MOD-8C0285 add aec00
                                            l_aec.aec052,   #FUN-5C0015
                                            l_aec.aec05
       WHEN 'F' FETCH FIRST    q801_cs INTO l_aec.aec00,l_aec.aec01,l_aec.aec051,   #MOD-8C0285 add aec00
                                            l_aec.aec052,   #FUN-5C0015
                                            l_aec.aec05
       WHEN 'L' FETCH LAST     q801_cs INTO l_aec.aec00,l_aec.aec01,l_aec.aec051,   #MOD-8C0285 add aec00
                                            l_aec.aec052,   #FUN-5C0015
                                            l_aec.aec05
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
            FETCH ABSOLUTE g_jump q801_cs INTO l_aec.aec00,l_aec.aec01,l_aec.aec051,   #MOD-8C0285 add aec00
                                               l_aec.aec052,  #FUN-5C0015
                                               l_aec.aec05
            LET mi_no_ask = FALSE
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
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q801_show()
END FUNCTION
 
FUNCTION q801_show()
  DEFINE   l_aag02         LIKE aag_file.aag02,
           l_aee04         LIKE aee_file.aee04,
           l_ahe02         LIKE ahe_file.ahe02  #FUN-5C0015
 
   DISPLAY l_aec.aec00 TO aec00   #MOD-8C0285 add
   DISPLAY l_aec.aec01 TO aec01
  #SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = l_aec.aec01                   #MOD-A80179 mark
   SELECT aag02,aag06 INTO l_aag02,g_aag06 FROM aag_file WHERE aag01 = l_aec.aec01     #MOD-A80179
                                             AND aag00 = l_aec.aec00          #No.FUN-740020   
   IF SQLCA.sqlcode THEN LET l_aag02 = '' END IF
  #FUN-5C0015(S)--
   SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = l_aec.aec052
   IF SQLCA.sqlcode THEN LET l_ahe02 = '' END IF
  #FUN-5C0015(E)--
   DISPLAY l_aag02     TO aag02
   DISPLAY l_aec.aec051 TO aec051
   DISPLAY l_aec.aec052 TO aec052    #FUN-5C0015 add
   DISPLAY l_ahe02 TO ahe02          #FUN-5C0015 add
   DISPLAY l_aec.aec05 TO aec05
   # 96-07-09
   SELECT aee04 INTO l_aee04 FROM aee_file
          # WHERE aee01 = l_aec.aec01  AND aee00 = g_bookno #No.MOD-490104
           WHERE aee01 = l_aec.aec01
            AND aee02 = l_aec.aec051 AND aee03 = l_aec.aec05
            AND aee00 =l_aec.aec00             #No.FUN-740020
   IF SQLCA.sqlcode THEN LET l_aee04 = '' END IF
   DISPLAY l_aee04     TO aee04
   CALL q801_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q801_b_fill()              #BODY FILL UP
   DEFINE
   l_sql     LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(400) 
   l_abb06   LIKE abb_file.abb06,
   l_abb07   LIKE abb_file.abb07,
   l_sql2    LIKE type_file.chr1000,  #MOD-580107        #No.FUN-680098  VARCHAR(400) 
   l_abb07_1 LIKE abb_file.abb07,   #MOD-580107
   l_abb07_2 LIKE abb_file.abb07    #MOD-580107
 
 
 
   LET l_sql =
        "SELECT aec02, aec03,0,0,0,abb06,abb07 ",
        " FROM  aec_file , abb_file ",
        " WHERE aec01 = '",l_aec.aec01,"' AND ",
        " aec05 = '",l_aec.aec05,"' AND ",
        " aec051= '",l_aec.aec051,"' AND ",
#       " aec00 = '",g_bookno,"' AND ",            #No.FUN-740020
        " abb00 = aec00 AND abb01 = aec03 AND abb02 = aec04 ",
        " AND ",tm.wc CLIPPED,
        " AND aec00 ='",l_aec.aec00,"'",            #MOD-BC0179 add
        " ORDER BY 1 "
    PREPARE q801_pb FROM l_sql
    DECLARE q801_bcs                       #BODY CURSOR
        CURSOR FOR q801_pb
 
    CALL g_aec.clear()
    LET l_bal = 0
    LET g_rec_b=0
    LET g_cnt = 1
    LET l_abb06 = NULL
    LET l_abb07 = NULL
    FOREACH q801_bcs INTO g_aec[g_cnt].*,l_abb06,l_abb07
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#MOD-580107
        IF g_cnt = 1 THEN
           LET l_sql2=
           "SELECT SUM(abb07) FROM abb_file,aec_file ",
             "WHERE abb00 = aec00 AND abb01 = aec03 AND ",
                   "abb02 = aec04 AND abb06 = '1' AND ",
                   "aec01 = '",l_aec.aec01,"' AND ",
                   "aec05 = '",l_aec.aec05,"' AND ",
                   "aec051 = '",l_aec.aec051,"' AND ",
                   "aec02 < '",g_aec[g_cnt].aec02,"' AND ",
                   "aec00 = '",l_aec.aec00,"'"                    #MOD-BC0179 add
           PREPARE q801_aab07pb1 FROM l_sql2
           DECLARE q801_aab07bcs1 CURSOR FOR q801_aab07pb1
           FOREACH q801_aab07bcs1 INTO l_abb07_1
              IF l_abb07_1 IS NULL THEN LET l_abb07_1 = 0 END IF
           END FOREACH
           LET l_sql2=
           "SELECT SUM(abb07) FROM abb_file,aec_file ",
             "WHERE abb00 = aec00 AND abb01 = aec03 AND ",
                   "abb02 = aec04 AND abb06 = '2' AND ",
                   "aec01 = '",l_aec.aec01,"' AND ",
                   "aec05 = '",l_aec.aec05,"' AND ",
                   "aec051 = '",l_aec.aec051,"' AND ",
                   "aec02 < '",g_aec[g_cnt].aec02,"' AND ",
                   "aec00 = '",l_aec.aec00,"'"                     #MOD-BC0179 add
           PREPARE q801_aab07pb2 FROM l_sql2
           DECLARE q801_aab07bcs2 CURSOR FOR q801_aab07pb2
           FOREACH q801_aab07bcs2 INTO l_abb07_2
              IF l_abb07_2 IS NULL THEN LET l_abb07_2 = 0 END IF
           END FOREACH
          #LET l_bal = l_abb07_1-l_abb07_2     #MOD-A80179 mark
          #-MOD-A80179-add-
           IF g_aag06 = '1' THEN
              LET l_bal = l_abb07_1-l_abb07_2
           ELSE
              LET l_bal = l_abb07_2-l_abb07_1
           END IF
          #-MOD-A80179-end-
        END IF
#END MOD-580107
        IF l_abb06 = '1' THEN
            LET g_aec[g_cnt].abb07_1 = l_abb07  #借
            LET g_aec[g_cnt].abb07_2 = NULL
           #LET l_bal = l_bal + l_abb07        #MOD-A80179 mark
           #-MOD-A80179-add-
            IF g_aag06 = '1' THEN
               LET l_bal = l_bal + l_abb07
            ELSE
               LET l_bal = l_bal - l_abb07
            END IF
           #-MOD-A80179-end-
        ELSE
            LET g_aec[g_cnt].abb07_1 = NULL
            LET g_aec[g_cnt].abb07_2 = l_abb07  #貸
           #LET l_bal = l_bal - l_abb07        #MOD-A80179 mark
           #-MOD-A80179-add-
            IF g_aag06 = '1' THEN
               LET l_bal = l_bal - l_abb07
            ELSE
               LET l_bal = l_bal + l_abb07
            END IF
           #-MOD-A80179-end-
        END IF
        LET g_aec[g_cnt].abb99 = l_bal
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aec.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q801_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aec TO s_aec.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q801_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q801_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q801_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q801_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q801_fetch('L')
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
 
