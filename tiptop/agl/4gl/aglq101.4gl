# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aglq101.4gl
# Descriptions...: 科目餘額查詢
# Date & Author..: 92/02/25 By Nora
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-520039 05/02/17 By Kitty _out()之l_aah.* define之位置順序與g_sql之select位置不同
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-590124 05/10/27 By Dido aag02科目名稱放寬
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680025 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0093 06/11/16 By wujie   匯出excel錯
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By sherry  會計科目加帳套
# Modify.........: No.TQC-740093 07/04/16 By sherry  會計科目加帳套--筆數修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830093 08/03/25 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B10176 11/01/21 By Dido 報表需與畫面顯示一致 
# Modify.........: No:TQC-B10251 11/01/28 By Dido 輸出報表語法取消 g_bookno 條件 
# Modify.........: No:MOD-C60002 12/06/07 By Polly 查詢時，控卡帳別需輸入
# Modify.........: No:CHI-D30002 13/03/05 By apo 依據aza02的選項若為12期即顯示12期,13期則顯示13期
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc  	STRING         #TQC-630166 		# Head Where condition
        END RECORD,
    g_aag  RECORD
            aah01		LIKE aah_file.aah01,
            aag02		LIKE aag_file.aag02,
            aah02		LIKE aah_file.aah02,
            aah00		LIKE aah_file.aah00,
            aag06		LIKE aag_file.aag06
        END RECORD,
    g_aah DYNAMIC ARRAY OF RECORD
            seq     LIKE ze_file.ze03,    #No.FUN-680098    VARCHAR(4)   
            aah04   LIKE aah_file.aah04,
            aah05   LIKE aah_file.aah05,
            aah06   LIKE aah_file.aah06,
            aah07   LIKE aah_file.aah07,
            l_tot   LIKE aah_file.aah04
        END RECORD,
    g_bookno     LIKE aah_file.aah00,      # INPUT ARGUMENT - 1
    g_wc,g_sql STRING,        #TQC-630166    #WHERE CONDITION
    p_row,p_col LIKE type_file.num5,                #No.FUN-680098     smallint
    g_rec_b     LIKE type_file.num5     #單身筆數    #No.FUN-680098     smallint
 
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680098    integer
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose   #No.FUN-680098    smallint
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680098      VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10      #No.FUN-680098     INTEGER
DEFINE   g_curs_index    LIKE type_file.num10      #No.FUN-680098     INTEGER
DEFINE   g_jump          LIKE type_file.num10      #No.FUN-680098     INTEGER
DEFINE   g_no_ask       LIKE type_file.num5       #No.FUN-680098     SMALLINT
DEFINE   l_table         STRING,                   ### FUN-830093 ###                                                                  
         g_str           STRING                    ### FUN-830093 ###
DEFINE   g_aah00         LIKE aah_file.aah00       #MOD-C60002 add

MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
### *** FUN-830093 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "aah01.aah_file.aah01,",
                "aah02.aah_file.aah02,",
                "aah03.aah_file.aah03,",
                "aah04.aah_file.aah04,",
                "aah05.aah_file.aah05,",
                "l_aag02.aag_file.aag02,",
                "l_tot.aah_file.aah04,",
                "l_aag06.aag_file.aag06"
    LET l_table = cl_prt_temptable('aglq101',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                        
                " VALUES(?, ?, ?, ?,                                                                                       
                         ?, ?, ?, ?)"                                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
 
    OPEN WINDOW q101_w WITH FORM "agl/42f/aglq101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,g_bookno)
    IF NOT cl_null(g_bookno) THEN CALL q101_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
 
    CALL q101_menu()
    CLOSE WINDOW q101_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION q101_cs()
   DEFINE   l_cnt  LIKE type_file.num5      #No.FUN-680098  smallint  
 
   CLEAR FORM #清除畫面
   CALL g_aah.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		     # Default condition
   CALL cl_set_head_visible("","YES")        #No.FUN-6B0029 
 
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             aah01,aah02,aah00
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
             #------MOD-C60002------(S)
              AFTER FIELD aah00
                  LET g_aah00 = get_fldbuf(aah00)
                  IF cl_null(g_aah00) THEN
                     CALL cl_err('','aap-099',0)
                     NEXT FIELD aah00
                  ELSE
                     SELECT COUNT(*) INTO l_cnt
                       FROM aaa_file
                      WHERE aaa01 = g_aah00
                     IF l_cnt = 0 THEN
                        CALL cl_err(g_aah00,'anm-009',0)
                        NEXT FIELD aah00
                     END IF
                  END IF

              AFTER CONSTRUCT
                  IF INT_FLAG THEN
                     EXIT CONSTRUCT
                  END IF
                  LET g_aah00 = get_fldbuf(aah00)
                  IF cl_null(g_aah00) THEN
                     CALL cl_err('','aap-099',0)
                     NEXT FIELD aah00
                  END IF
             #------MOD-C60002------(E)
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(aah01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_aag.aah00    #No.FUN-740020
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aah01
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
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET g_sql=" SELECT DISTINCT aah00,aah01,aah02 FROM aah_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND aah01 = aag01 ",
             "   AND aag00 = aah00 ",         #No.FUN-740020
             " ORDER BY aah01,aah02"
   PREPARE q101_prepare FROM g_sql
   DECLARE q101_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q101_prepare
 
   #====>取合乎條件筆數
   LET g_sql=" SELECT UNIQUE aah00,aah01,aah02 FROM aah_file,aag_file ",
             "     WHERE ",tm.wc CLIPPED,
             "       AND aah01 = aag01 ",
             "       AND aag00 = aah00 ",         #No.FUN-740020    No.TQC-740093
             "     INTO TEMP x "
   DROP TABLE x
   PREPARE q101_prepare_x FROM g_sql
   EXECUTE q101_prepare_x
 
       LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE q101_prepare_cnt FROM g_sql
   DECLARE q101_count CURSOR FOR q101_prepare_cnt
END FUNCTION
 
FUNCTION q101_menu()
 
   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q101_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aah),'','')     #TQC-6B0093
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q101_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q101_count
       FETCH q101_count INTO g_cnt
       DISPLAY g_cnt TO FORMONLY.cnt
       LET g_row_count = g_cnt      
       CALL q101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag         LIKE type_file.chr1,           #處理方式  #No.FUN-680098   VARCHAR(1)    
    l_abso         LIKE type_file.num10           #絕對的筆數   #No.FUN-680098 integer   
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_aag.aah00,g_aag.aah01,g_aag.aah02
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_aag.aah00,g_aag.aah01,g_aag.aah02
        WHEN 'F' FETCH FIRST    q101_cs INTO g_aag.aah00,g_aag.aah01,g_aag.aah02
        WHEN 'L' FETCH LAST     q101_cs INTO g_aag.aah00,g_aag.aah01,g_aag.aah02
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q101_cs INTO g_aag.aah00,g_aag.aah01,g_aag.aah02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.aah01,SQLCA.sqlcode,0)
        INITIALIZE g_aag.* TO NULL  #TQC-6B0105
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
 
    CALL q101_show()
END FUNCTION
 
FUNCTION q101_show()
   DISPLAY BY NAME g_aag.aah00,g_aag.aah01,g_aag.aah02
   CALL q101_aah01('d')
   CALL q101_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q101_aah01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(1)   
           l_aag02 LIKE aag_file.aag02,
           l_aag06 LIKE aag_file.aag06,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF g_aag.aah01 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aag06,aagacti
           INTO l_aag02,l_aag06,l_aagacti
           FROM aag_file WHERE aag01 = g_aag.aah01
                           AND aag00 = g_aag.aah00         #No.FUN-740020
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
            LET l_aag06 = NULL
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  aag02
       LET g_aag.aag06 = l_aag06
    END IF
END FUNCTION
 
FUNCTION q101_b_fill()              #BODY FILL UP
#  DEFINE l_sql     VARCHAR(400),
   DEFINE l_sql     STRING,        #TQC-630166
          l_n       LIKE type_file.num5,      #No.FUN-680098   smallint 
          l_tot     LIKE aah_file.aah04
   DEFINE l_cnt     LIKE type_file.num5   #CHI-D30002
 
   LET l_sql =
        "SELECT '',aah04, aah05, aah06, aah07,0",
        " FROM  aah_file",
        " WHERE aah00 = '",g_aag.aah00,"'",
        " AND aah01 = '",g_aag.aah01,"'",
        " AND aah02 = ",g_aag.aah02," AND aah03 = ?"
    PREPARE q101_pb FROM l_sql
    DECLARE q101_bcs                       #BODY CURSOR
        CURSOR FOR q101_pb
    CALL g_aah.clear() 
#   FOR g_cnt = 1 TO g_aah.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_aah[g_cnt].* TO NULL
#   END FOR
    LET g_rec_b=0
    LET g_cnt = 0
    IF g_aag.aag06 = '1' THEN
       LET l_n = 1
    ELSE
       LET l_n = -1
    END IF
    LET l_tot = 0
   #CHI-D30002--
    IF g_aza.aza02 = 1 THEN
       LET l_cnt = 13
    ELSE
       LET l_cnt = 14
    END IF
   #CHI-D30002--
   #FOR g_cnt = 1 TO 14      #CHI-D30002 mark
    FOR g_cnt = 1 TO l_cnt   #CHI-D30002 
        LET g_i = g_cnt - 1
        OPEN q101_bcs USING g_i
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
        FETCH q101_bcs INTO g_aah[g_cnt].*
           IF SQLCA.sqlcode = 100 THEN
              LET g_aah[g_cnt].aah04 = 0
              LET g_aah[g_cnt].aah05 = 0
#FUN-680025--begin
#             LET g_aah[g_cnt].aah06 = 0
#             LET g_aah[g_cnt].aah07 = 0
#             LET g_aah[g_cnt].l_tot = l_tot
#FUN-680025--end
              LET g_aah[g_cnt].l_tot = 0
           END IF
           IF g_i = 0 THEN
                CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
                LET g_aah[g_cnt].seq = g_msg clipped
           ELSE LET g_aah[g_cnt].seq = g_i
           END IF
           LET g_aah[g_cnt].l_tot = l_tot +
             (g_aah[g_cnt].aah04 - g_aah[g_cnt].aah05) * l_n
           LET l_tot = g_aah[g_cnt].l_tot
    END FOR
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q101_bp(p_ud)
   DEFINE   p_ud LIKE type_file.chr1       #No.FUN-680098    VARCHAR(1)  
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aah TO s_aah.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q101_fetch('L')
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
         CALL q101_b_fill()
         EXIT DISPLAY
 
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
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q101_out()
    DEFINE
        l_i            LIKE type_file.num5,       #No.FUN-680098   smallint 
        l_cnt          LIKE type_file.num5,       #MOD-B10176
        l_lastcnt      LIKE type_file.num5,       #MOD-B10176
        l_name         LIKE type_file.chr20,     # External(Disk) file name   #No.FUN-680098    VARCHAR(20)  
        l_aah  RECORD
                aah00	LIKE aah_file.aah00,
                aah01	LIKE aah_file.aah01,
                aah02	LIKE aah_file.aah02,
                aah03	LIKE aah_file.aah03,
                aah04   LIKE aah_file.aah04,
                aah05   LIKE aah_file.aah05,
                aah06   LIKE aah_file.aah06,
                aah07   LIKE aah_file.aah07
        END RECORD,
        l_chr       LIKE type_file.chr1   #No.FUN-680098   VARCHAR(1)
DEFINE  l_aag02         LIKE aag_file.aag02          #No.FUN-830093                                                                 
DEFINE  l_aag06         LIKE aag_file.aag06          #No.FUN-830093 
DEFINE  l_tot           LIKE aah_file.aah04          #No.FUN-830093
DEFINE  l_aah00_o       LIKE aah_file.aah00          #MOD-B10176
DEFINE  l_aah01_o       LIKE aah_file.aah01          #MOD-B10176
DEFINE  l_aah02_o       LIKE aah_file.aah02          #MOD-B10176
DEFINE  l_lastaah03     LIKE aah_file.aah03          #MOD-B10176
DEFINE  l_wc            STRING                       #TQC-B10251
 
    IF tm.wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('aglq101') RETURNING l_name        #FUN-830093 mark
   #SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno  #MOD-C60002 mark
    SELECT aaf03 INTO g_company                                       #MOD-C60002 add
      FROM aaf_file                                                   #MOD-C60002 add
     WHERE aaf01 = g_aah00                                            #MOD-C60002 add
			AND aaf02 = g_lang
#    SELECT azi05 INTO g_azi05 FROM azi_file   #總計之小數位數     #CHI-6A0004
#           WHERE azi01 = g_aza.aza17          #CHI-6A0004
#    IF SQLCA.sqlcode THEN                       #CHI-6A0004  
#      CALL cl_err('',SQLCA.sqlcode,0)  # NO.FUN-660123    #CHI-6A0004  
#       CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0)   # NO.FUN-660123  #CHI-6A0004  
#   END IF                                                      #CHI-6A0004  
#FUN-680025--begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglq101'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
# FUN-680025--end
    LET g_sql="SELECT aah00,aah01,aah02,aah03,aah04,",      #No.MOD-520039
             " aah05,aah06,aah07 FROM aah_file,aag_file ",  # 組合出 SQL 指令  #FUN-830093 Add aag_file
            #" WHERE aah00 = '",g_bookno,"'",                                #TQC-B10251 mark
             " WHERE aah01 = aag01 ",                       # FUN-830093 Add #TQC-B10251 mod AND -> WHERE 
             " AND  aah01 = aag01 ",                        # FUN-830093 Add
             " AND  aah00 = aag00 ",                        # FUN-830093 Add
             " AND ",tm.wc CLIPPED,
             " ORDER BY aah00,aah01,aah02,aah03 "           #MOD-B10176
    PREPARE q101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q101_co CURSOR FOR q101_p1
 
#   START REPORT q101_rep TO l_name                            #FUN-830093 mark
 
   #-MOD-B10176-add-
    LET g_sql = " SELECT MAX(aah03) ",
                "   FROM aah_file ",
                "  WHERE aah00 = ? ",
                "    AND aah01 = ? ",
                "    AND aah02 = ? "
    PREPARE q101_p2 FROM g_sql
    DECLARE q101_c2 CURSOR FOR q101_p2
   #-MOD-B10176-end-

    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830093 *** ##                                                    
    CALL cl_del_data(l_table)                                                                                                      
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                     #FUN-830093                                       
    #------------------------------ CR (2) ------------------------------#
 
    LET l_aah00_o = ''  #MOD-B10176 
    LET l_aah01_o = ''  #MOD-B10176 
    LET l_aah02_o = ''  #MOD-B10176 
    FOREACH q101_co INTO l_aah.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
# FUN-830093 --Add-Begin--#
        SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file                                                                   
         WHERE aag01 = l_aah.aah01                                                                                           
           AND aag00 = l_aah.aah00
       #-MOD-B10176-add-
        OPEN q101_c2 USING l_aah.aah00,l_aah.aah01,l_aah.aah02
        FETCH q101_c2 INTO l_lastaah03
        LET l_lastcnt = l_lastaah03
        IF cl_null(l_aah00_o) OR l_aah00_o <> l_aah.aah00 OR l_aah01_o <> l_aah.aah01 OR 
                                 l_aah02_o <> l_aah.aah02 THEN
           LET l_cnt = 0   
        END IF   
        WHILE TRUE
           IF l_cnt < l_aah.aah03 THEN
              EXECUTE insert_prep USING                                                                                                  
                      l_aah.aah01,l_aah.aah02,l_cnt,'0','0',l_aag02,'',l_aag06
              LET l_cnt = l_cnt + 1 
           ELSE
              IF l_lastaah03 = l_aah.aah03 AND l_lastcnt < 13 THEN
                 LET l_lastcnt = l_lastcnt + 1 
                 EXECUTE insert_prep USING                                                                                                  
                         l_aah.aah01,l_aah.aah02,l_lastcnt,'0','0',l_aag02,'',l_aag06
              ELSE
                 EXIT WHILE
              END IF
           END IF 
        END WHILE
        LET l_aah00_o = l_aah.aah00 
        LET l_aah01_o = l_aah.aah01 
        LET l_aah02_o = l_aah.aah02 
        LET l_cnt = l_aah.aah03 + 1 
       #-MOD-B10176-end-
 
#       OUTPUT TO REPORT q101_rep(l_aah.*)                     #FUN-830093 mark
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830093 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 l_aah.aah01,l_aah.aah02,l_aah.aah03,l_aah.aah04,l_aah.aah05,
                 l_aag02,'',l_aag06
     #------------------------------ CR (3) ------------------------------#
 
    END FOREACH
 
#   FINISH REPORT q101_rep                                     #FUN-830093 mark
 
    CLOSE q101_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)                          #FUN-830093 mark
 
#No.FUN-830093--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'aah01,aah02,aah00')                                        
              RETURNING l_wc     #TQC-B10251 mod tm.wc -> l_wc                                                                                                  
      END IF                                                                                                                        
#No.FUN-830093--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830093 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = l_wc,";",g_azi05 #TQC-B10251 mod tm.wc -> l_wc 
    CALL cl_prt_cs3('aglq101','aglq101',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#NO.FUN-830093 -Mark--Begin--#
#REPORT q101_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)  
#       sr     RECORD
#               aah00	LIKE aah_file.aah00,
#               aah01	LIKE aah_file.aah01,
#               aah02	LIKE aah_file.aah02,
#               aah03   LIKE aah_file.aah03,
#               aah04   LIKE aah_file.aah04,
#               aah05   LIKE aah_file.aah05,
#               aah06   LIKE aah_file.aah06,
#               aah07   LIKE aah_file.aah07
#       END RECORD,
#       l_aag02         LIKE aag_file.aag02,
#       l_aag06         LIKE aag_file.aag06,
#       l_tot           LIKE aah_file.aah04,
#       l_chr           LIKE type_file.chr1         #No.FUN-680098     VARCHAR(1) 
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.aah01,sr.aah02,sr.aah03
 
#   FORMAT
#       PAGE HEADER
#FUN-680025--begin
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#               COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           LET g_pageno = g_pageno + 1 
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
#           PRINT '' 
#FUN-680025--end
#           PRINT g_dash[1,g_len]
#FUN-680025--begin
#FUN-590124
#           PRINT g_x[11],'                           ',g_x[12] CLIPPED
#           PRINT "    ------------------------ -------",
#                 "------------------------------------------- --------"
#                 "-----------------------   ----"
#FUN-590124 End
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                 g_x[35],g_x[36],g_x[37]
#           PRINT g_dash1         
#FUN-680025--end     
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.aah02
#           IF PAGENO > 1 OR LINENO > 5 THEN
#              SKIP TO TOP OF PAGE
#           END IF
#           SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
#                  WHERE aag01 = sr.aah01
#                    AND aag00 = sr.aah00                  #No.FUN-740020
#FUN-680025--begin
#            PRINT COLUMN 5,sr.aah01,COLUMN 30,l_aag02,
#            PRINT COLUMN g_c[31],sr.aah01,                                                                                       
#                  COLUMN g_c[32],l_aag02,                                                                                        
#                  COLUMN g_c[33],sr.aah02 USING'####';
#FUN-590124
#                 COLUMN 81,sr.aah02 USING'####'
#                 COLUMN 63,sr.aah02 USING'####'
#FUN-590124 End
#           PRINT COLUMN 8,g_x[13],g_x[14]
#           PRINT "       ---- ------------------ ------------------ ",
#				  "------------------"
#FUN-680025-end
#           LET l_tot = 0
#
#       ON EVERY ROW
#           IF l_aag06 = '1' THEN
#              LET l_tot = l_tot +(sr.aah04 - sr.aah05)
#           ELSE
#              LET l_tot = l_tot +(sr.aah05 - sr.aah04)
#           END IF
#FUN-680025--begin
#           IF sr.aah03 = 0 THEN
#              PRINT COLUMN 8,g_x[15] CLIPPED;
#           ELSE
#              PRINT COLUMN 8,sr.aah03 USING '####';
#           END IF
#           PRINT COLUMN 13,cl_numfor(sr.aah04,18,g_azi05) CLIPPED,
#                 COLUMN 29,cl_numfor(sr.aah05,18,g_azi05) CLIPPED,
#                 COLUMN 46,cl_numfor(l_tot,18,g_azi05) CLIPPED
#           IF sr.aah03 = 0 THEN
#              PRINT COLUMN g_c[34],g_x[15] CLIPPED; 
#           ELSE
#              PRINT COLUMN g_c[34],sr.aah03 USING '####'; 
#           END IF
#           PRINT COLUMN g_c[35],cl_numfor(sr.aah04,35,g_azi05),
#                 COLUMN g_c[36],cl_numfor(sr.aah05,36,g_azi05),
#                 COLUMN g_c[37],cl_numfor(l_tot,37,g_azi05) 
#FUN-680025--end
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   #TQC-630166
#                   #IF g_wc[001,080] > ' ' THEN
#       	    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(tm.wc)
#           END IF
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-830093 -Mark--End--#
#Patch....NO.TQC-610035 <001,002> #
