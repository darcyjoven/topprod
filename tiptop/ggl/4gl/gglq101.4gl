# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gglq101.4gl
# Descriptions...: 科目幣別餘額查詢
# Date & Author..: 02/02/28 By Danny
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0087 04/12/16 By DAY  加入用"*"關閉窗口
# Modify.........: No.FUN-510007 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-560248 05/07/04 By day  b_fill()中選值有問題
# Modify.........: No.FUN-580010 05/08/12 By day  報表轉xml
# Modify.........: No.TQC-630196 06/03/20 By Smapmin 列印條件修改
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740018 07/04/05 By Judy 匯出Excel出錯
# Modify.........: No.FUN-730070 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-750022 07/05/09 By Lynn 打印內容:制表日期位置在報表名之上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850011 08/05/06 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	 STRING		# Head Where condition  #TQC-630166
        END RECORD,
    g_aag  RECORD
            tah00		LIKE tah_file.tah00,
            tah01		LIKE tah_file.tah01,
            tah02		LIKE tah_file.tah02,
            tah08		LIKE tah_file.tah08,
            aag02		LIKE aag_file.aag02,
            aag06		LIKE aag_file.aag06
        END RECORD,
    g_tah DYNAMIC ARRAY OF RECORD
            seq     LIKE type_file.chr1000,   #NO FUN-690009   VARCHAR(04)
            tah09   LIKE tah_file.tah09,
            tah10   LIKE tah_file.tah10,
            tah06   LIKE tah_file.tah06,
            tah07   LIKE tah_file.tah07,
            l_tot   LIKE tah_file.tah09
        END RECORD,
    g_bookno     LIKE tah_file.tah00,      # INPUT ARGUMENT - 1
   #g_wc,g_sql VARCHAR(1000),     #WHERE CONDITION
    g_wc,g_sql STRING,     #WHERE CONDITION                 #TQC-630166
    g_rec_b      LIKE type_file.num5          #NO FUN-690009    SMALLINT 	  #單身筆數
 
DEFINE   g_cnt           LIKE type_file.num5          #NO FUN-690009   INTEGER
DEFINE   g_i             LIKE type_file.num5          #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000       #NO FUN-690009   VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #NO FUN-690009   INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #NO FUN-690009   INTEGER
#No.FUN-850011--begin--
DEFINE l_table        STRING                                                                                                        
DEFINE g_str          STRING                                                                                                        
DEFINE l_sql          STRING 
#No.FUN-850011--end--
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0097
      DEFINE   l_sl,p_row,p_col	LIKE type_file.num5          #NO FUN-690009   SMALLINT
 
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
#No.FUN-850011--begin--
   LET g_sql="tah00.tah_file.tah00,",
             "tah01.tah_file.tah01,",
             "aag02.aag_file.aag02,",
             "tah08.tah_file.tah08,",
             "tah02.tah_file.tah02,",
             "tah03.tah_file.tah03,",
             "tah09.tah_file.tah09,",     
             "tah10.tah_file.tah10,",
             "l_tot.tah_file.tah09"       
   LET l_table = cl_prt_temptable('gglq101',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?)"                                                                           
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF    
#No.FUN-850011--end--
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
 
    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW q101_w AT p_row,p_col WITH FORM 'ggl/42f/gglq101'
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,g_bookno)
#    IF cl_chk_act_auth() THEN
#       CALL q101_q()
#    END IF
    CALL q101_menu()
    CLOSE WINDOW q101_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION q101_cs()
   DEFINE   l_cnt LIKE type_file.num5          #NO FUN-690009  SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_tah.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             tah01,tah08,tah00,tah02
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
 
 
   LET g_sql=" SELECT DISTINCT tah00,tah01,tah02,tah08 FROM tah_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND tah01 = aag01 ",
             "   AND tah00 = aag00 ",   #No.FUN-730070
             " ORDER BY tah00,tah01,tah08,tah02"  #No.FUN-730070
   PREPARE q101_prepare FROM g_sql
   DECLARE q101_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q101_prepare
 
   #====>取合乎條件筆數
   LET g_sql=" SELECT UNIQUE tah00,tah01,tah02,tah08 FROM tah_file,aag_file ",
             "     WHERE ",tm.wc CLIPPED,
             "       AND tah01 = aag01 ",
             "       AND tah00 = aag00 ",   #No.FUN-730070
             "     INTO TEMP x "
   DROP TABLE x
   PREPARE q101_prepare_x FROM g_sql
   EXECUTE q101_prepare_x
 
       LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE q101_prepare_cnt FROM g_sql
   DECLARE q101_count CURSOR FOR q101_prepare_cnt
END FUNCTION
 
#中文的MENU
FUNCTION q101_menu()
 
   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q101_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
#             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','') #TQC-740018 mark
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tah),'','') #TQC-740018
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q101_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q101_count
       FETCH q101_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(1)       #處理方式
    l_abso          LIKE type_file.num10         #NO FUN-690009   INTEGER       #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_aag.tah00,g_aag.tah01,
                                             g_aag.tah02,g_aag.tah08
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_aag.tah00,g_aag.tah01,
                                             g_aag.tah02,g_aag.tah08
        WHEN 'F' FETCH FIRST    q101_cs INTO g_aag.tah00,g_aag.tah01,
                                             g_aag.tah02,g_aag.tah08
        WHEN 'L' FETCH LAST     q101_cs INTO g_aag.tah00,g_aag.tah01,
                                             g_aag.tah02,g_aag.tah08
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
        FETCH ABSOLUTE l_abso q101_cs INTO g_aag.tah00,g_aag.tah01,
                                           g_aag.tah02,g_aag.tah08
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.tah01,SQLCA.sqlcode,0)
        INITIALIZE g_aag.* TO NULL  #TQC-6B0105
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
 
    CALL q101_show()
END FUNCTION
 
FUNCTION q101_show()
   DISPLAY BY NAME g_aag.tah00,g_aag.tah01,g_aag.tah02,g_aag.tah08
   CALL q101_tah01('d')
   CALL q101_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q101_tah01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(1)
           l_aag02 LIKE aag_file.aag02,
           l_aag06 LIKE aag_file.aag06,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF g_aag.tah01 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aag06,aagacti
           INTO l_aag02,l_aag06,l_aagacti
           FROM aag_file WHERE aag01 = g_aag.tah01
                           AND aag00 = g_aag.tah00  #No.FUN-730070
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
   DEFINE l_sql     LIKE type_file.chr1000,      #NO FUN-690009   VARCHAR(1000)
          l_n       LIKE type_file.num5,         #NO FUN-690009   SMALLINT
          l_tot     LIKE tah_file.tah09
 
   LET l_sql =
#       "SELECT tah09, tah10, tah06, tah07,0",
         "SELECT 0,tah09, tah10, tah06, tah07,0",   #No.MOD-560248
        " FROM  tah_file",
        " WHERE tah00 = '",g_aag.tah00,"'",
        " AND tah01 = '",g_aag.tah01,"'",
        " AND tah02 = ",g_aag.tah02," AND tah03 = ?",
        " AND tah08 = '",g_aag.tah08,"'"
    PREPARE q101_pb FROM l_sql
    DECLARE q101_bcs                       #BODY CURSOR
        CURSOR FOR q101_pb
 
    CALL g_tah.clear()
    LET g_rec_b=0
    LET g_cnt = 0
    IF g_aag.aag06 = '1' THEN
       LET l_n = 1
    ELSE
       LET l_n = -1
    END IF
    LET l_tot = 0
    FOR g_cnt = 1 TO 14
        LET g_i = g_cnt - 1
           IF g_i = 0 THEN
                CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
                LET g_tah[g_cnt].seq = g_msg clipped
           ELSE LET g_tah[g_cnt].seq = g_i
           END IF
        OPEN q101_bcs USING g_i
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
        FETCH q101_bcs INTO g_tah[g_cnt].*
           IF SQLCA.sqlcode = 100 THEN
              LET g_tah[g_cnt].tah09 = 0
              LET g_tah[g_cnt].tah10 = 0
              LET g_tah[g_cnt].tah06 = 0
              LET g_tah[g_cnt].tah07 = 0
              LET g_tah[g_cnt].l_tot = l_tot
              CONTINUE FOR
           END IF
           LET g_tah[g_cnt].seq = g_i
           LET g_tah[g_cnt].l_tot = l_tot +
             (g_tah[g_cnt].tah09 - g_tah[g_cnt].tah10) * l_n
        LET l_tot = g_tah[g_cnt].l_tot
    END FOR
    LET g_rec_b = 14    #add by carrier
END FUNCTION
 
FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #NO FUN-690009   VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tah TO s_tah.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 #MOD-4C0087--begin
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 #MOD-4C0087--end
 
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
 
 
FUNCTION q101_out()
    DEFINE
        l_i             LIKE type_file.num5,         #NO FUN-690009   SMALLINT
        l_name          LIKE type_file.chr20,        #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
        l_tah  RECORD
                tah00	LIKE tah_file.tah00,
                tah01	LIKE tah_file.tah01,
                tah02	LIKE tah_file.tah02,
                tah03	LIKE tah_file.tah03,
                tah09   LIKE tah_file.tah09,
                tah10   LIKE tah_file.tah10,
                tah06   LIKE tah_file.tah06,
                tah07   LIKE tah_file.tah07,
                tah08   LIKE tah_file.tah08
        END RECORD,
        l_chr           LIKE type_file.chr1          #NO FUN-690009   VARCHAR(1)
DEFINE  l_aag02         LIKE aag_file.aag02          #No.FUN-850011
DEFINE  l_aag06         LIKE aag_file.aag06          #No.FUN-850011
DEFINE  l_tot           LIKE tah_file.tah09          #No.FUN-850011
 
    CALL cl_del_data(l_table)                                         #No.FUN-830154                                               
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog          #No.FUN-830154 
    IF tm.wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('gglq101') RETURNING l_name                        #No.FUN-830154
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
			AND aaf02 = g_lang
#No.CHI-6A0004   ----begin----   
#       SELECT azi05 INTO g_azi05 FROM azi_file   #總計之小數位數
#           WHERE azi01 = g_aza.aza17         
#    IF SQLCA.sqlcode THEN 
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660124
#           CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124           
#    END IF
#No.CHI-6A0004   ----end----
    LET g_sql="SELECT tah00,tah01,tah02,tah03,tah09,",
#              " tah10,tah06,tah07,tah08 FROM tah_file ",      # 組合出 SQL 指令  #No.FUN-850011
#             " WHERE tah00 = '",g_bookno,"'",                                    #No.FUN-730070
#             " WHERE ",tm.wc CLIPPED                                             #No.FUN-850011
              " tah10,tah06,tah07,tah08 FROM tah_file,aag_file ",                 #No.FUN-850011 
              " WHERE ",tm.wc CLIPPED,                                            #No.FUN-850011
              "   AND tah01 = aag01 ",                                            #No.FUN-850011                                                                                               
              "   AND tah00 = aag00 "                                             #No.FUN-850011 
    PREPARE q101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q101_co CURSOR FOR q101_p1
#No.FUN-850011--begin--
#   START REPORT q101_rep TO l_name
 
    FOREACH q101_co INTO l_tah.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
            SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
                   WHERE aag01 = l_tah.tah01
                     AND aag00 = l_tah.tah00
            LET l_tot = 0
            IF l_aag06 = '1' THEN
               LET l_tot = l_tot +(l_tah.tah09 - l_tah.tah10)
            ELSE
               LET l_tot = l_tot +(l_tah.tah10 - l_tah.tah09)
            END IF   
         EXECUTE insert_prep USING l_tah.tah00,l_tah.tah01,l_aag02,l_tah.tah08,l_tah.tah02,l_tah.tah03,l_tah.tah09,
                                   l_tah.tah10,l_tot   
#        OUTPUT TO REPORT q101_rep(l_tah.*)
    END FOREACH
 
#    FINISH REPORT q101_rep
 
    CLOSE q101_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'tah01,tah08,tah00,tah02')                                                                       
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",g_azi05                                              
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                            
      CALL cl_prt_cs3('gglq101','gglq101',l_sql,g_str)
#No.FUN-850011--end--
END FUNCTION
#No.FUN-850011--begin--
#REPORT q101_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(1),
#       sr     RECORD
#               tah00	LIKE tah_file.tah00,
#               tah01	LIKE tah_file.tah01,
#               tah02	LIKE tah_file.tah02,
#               tah03   LIKE tah_file.tah03,
#               tah09   LIKE tah_file.tah09,
#               tah10   LIKE tah_file.tah10,
#               tah06   LIKE tah_file.tah06,
#               tah07   LIKE tah_file.tah07,
#               tah08   LIKE tah_file.tah08
#       END RECORD,
#       l_aag02         LIKE aag_file.aag02,
#       l_aag06         LIKE aag_file.aag06,
#       l_tot           LIKE tah_file.tah09,
#       l_chr           LIKE type_file.chr1          #NO FUN-690009   VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.tah00,sr.tah01,sr.tah02,sr.tah08,sr.tah03  #No.FUN-730070
 
#No.FUN-580010-begin
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total         # No.TQC-750022
 
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           PRINT g_head CLIPPED,pageno_total         # No.TQC-750022
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                 g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]  #No.FUN-730070
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.tah08
#           IF PAGENO > 1 OR LINENO > 9 THEN
#              SKIP TO TOP OF PAGE
#           END IF
#           SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
#                  WHERE aag01 = sr.tah01
#                    AND aag00 = sr.tah00   #No.FUN-730070
#           #No.FUN-730070  --Begin
#           PRINT COLUMN g_c[31],sr.tah00 CLIPPED;
#           PRINT COLUMN g_c[32],sr.tah01 CLIPPED,
#                 COLUMN g_c[33],l_aag02 CLIPPED,
#                 COLUMN g_c[34],sr.tah08 CLIPPED,
#                 COLUMN g_c[35],sr.tah02 USING'####';
#           #No.FUN-730070  --End  
#           LET l_tot = 0
#
#       ON EVERY ROW
#           IF l_aag06 = '1' THEN
#              LET l_tot = l_tot +(sr.tah09 - sr.tah10)
#           ELSE
#              LET l_tot = l_tot +(sr.tah10 - sr.tah09)
#           END IF
#           #No.FUN-730070  --Begin
#           IF sr.tah03 = 0 THEN
#              PRINT COLUMN g_c[36],g_x[15] CLIPPED;
#           ELSE
#              PRINT COLUMN g_c[36],sr.tah03 USING '####';
#           END IF
#           PRINT COLUMN g_c[37],cl_numfor(sr.tah09,36,g_azi05),
#                 COLUMN g_c[38],cl_numfor(sr.tah10,37,g_azi05),
#                 COLUMN g_c[39],cl_numfor(l_tot,38,g_azi05)
#           #No.FUN-730070  --End  
#No.FUN-580010-end
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'  THEN        # 80:70,140,210      132:120,240
#                 CALL cl_wcchp(tm.wc,'tah01,tah08,tah00,tah02') RETURNING tm.wc
#                 PRINT g_dash[1,g_len]
#                 #TQC-630166
#                 # IF g_wc[001,080] > ' ' THEN
#       	  #    PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                 # IF g_wc[071,140] > ' ' THEN
#       	  #    PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                 # IF g_wc[141,210] > ' ' THEN
#       	  #    PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(tm.wc)   #TQC-630196
#                 #END TQC-630166
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
#No.FUN-850011--end--
#Patch....NO.TQC-610037 <> #
#No.FUN-870144
