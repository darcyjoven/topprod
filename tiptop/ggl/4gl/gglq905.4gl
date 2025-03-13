# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gglq905.4gl
# Descriptions...: 分類帳查詢
# Date & Author..: 02/02/27 By Danny
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0073 06/11/15 By xufeng  添加語言轉換功能 
# Modify.........: No.FUN-6A0092 06/11/27 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740053 07/04/12 By Xufeng  匯出excel時多出一空白行
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(1000)   # Head Where condition
        END RECORD,
    #modify 020815  NO.A030
    g_ae  RECORD
           aea00                LIKE aea_file.aea00,   #No.FUN-740033
           aea01		LIKE aea_file.aea01,
           aag24		LIKE aag_file.aag24
       END RECORD,
    g_aea DYNAMIC ARRAY OF RECORD
            aea02     LIKE aea_file.aea02,
            aba05     LIKE aba_file.aba05,
            aea03     LIKE aea_file.aea03,
            aba06     LIKE aba_file.aba06,
            abb24     LIKE abb_file.abb24,
            abb25     LIKE abb_file.abb25,
            abb07f_1  LIKE abb_file.abb07f,
            abb07_1   LIKE abb_file.abb07,
            abb07f_2  LIKE abb_file.abb07f,
            abb07_2   LIKE abb_file.abb07,
            abb04     LIKE abb_file.abb04
        END RECORD,
    g_bookno     LIKE aea_file.aea00,      # INPUT ARGUMENT - 1
     g_wc,g_sql string,     #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b      LIKE type_file.num5       #NO FUN-690009   SMALLINT    #單身筆數
 
 
DEFINE   g_cnt          LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_msg          LIKE ze_file.ze03      #NO FUN-690009   VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_curs_index   LIKE type_file.num10       #NO FUN-690009   INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0097
DEFINE        l_sl,p_row,p_col	LIKE type_file.num5        #NO FUN-690009   SMALLINT
 
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
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW q905_srn AT p_row,p_col WITH FORM 'ggl/42f/gglq905'
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
#   DISPLAY FORM q905_srn
 
    CALL s_shwact(0,0,g_bookno)
#    IF cl_chk_act_auth() THEN
#       CALL q905_q()
#    END IF
IF NOT cl_null(g_bookno) THEN CALL q905_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
    CALL q905_menu()
    CLOSE WINDOW q905_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION q905_cs()
   DEFINE   l_cnt LIKE type_file.num5        #NO FUN-690009   SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_aea.clear()
   CALL cl_opmsg('q')
  INITIALIZE tm.* TO NULL			# Default condition
   #modify 020815  NO.A030
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ae.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON                   # 螢幕上取單頭條件
             aea00,aea01,aag24,aea02            #No.A056  #No.FUN-740033
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
   #modify 020815  NO.A030
   LET g_sql=" SELECT UNIQUE aea00,aea01,aag24 FROM aea_file,aag_file ",  #No.FUN-740033
             " WHERE aea00 = aag00 AND ",tm.wc CLIPPED,  #No.FUN-740033
             " AND aea01 =  aag01 AND aag03 = '2' AND aag07 IN ('1','3') " #No.FUN-740033
   PREPARE q905_prepare FROM g_sql
   DECLARE q905_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q905_prepare
 
   #No.FUN-740033  --Begin
   DROP TABLE x
   LET g_sql=" SELECT UNIQUE aea00,aea01 FROM aea_file,aag_file ",
             " WHERE aea00 = aag00 AND ",tm.wc CLIPPED,
             " AND aea01 =  aag01 AND aag03 = '2' AND aag07 IN ('1','3') " ,  #No.FUN-740033
             "  INTO TEMP x"
   PREPARE q905_prepare_pre FROM g_sql
   EXECUTE q905_prepare_pre
 
   DECLARE q905_count CURSOR FOR SELECT COUNT(*) FROM x
   #No.FUN-740033  --End  
 
END FUNCTION
 
FUNCTION q905_menu()
   LET g_action_choice=" "
 
   WHILE TRUE
      CALL q905_bp("G")
      CASE g_action_choice
#TQC-6B0073  --begin
         WHEN "locale"
            CALL cl_dynamic_locale()
#TQC-6B0073  --end
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q905_q()
            END IF
         WHEN "first"
            CALL q905_fetch('F')
         WHEN "previous"
            CALL q905_fetch('P')
         WHEN "jump"
            CALL q905_fetch('/')
         WHEN "next"
            CALL q905_fetch('N')
         WHEN "last"
            CALL q905_fetch('L')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aea),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q905_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q905_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q905_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q905_count
       FETCH q905_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q905_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q905_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)    #處理方式
    l_abso          LIKE type_file.num10       #NO FUN-690009   INTEGER    #絕對的筆數
 
    #modify 020815  NO.A030
    CASE p_flag
        WHEN 'N' FETCH NEXT     q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.FUN-740033
        WHEN 'P' FETCH PREVIOUS q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.FUN-740033
        WHEN 'F' FETCH FIRST    q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.FUN-740033
        WHEN 'L' FETCH LAST     q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.FUN-740033
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
            FETCH ABSOLUTE l_abso q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.FUN-740033
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ae.aea01,SQLCA.sqlcode,0)
        INITIALIZE g_ae.* TO NULL  #TQC-6B0105
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
 
    CALL q905_show()
END FUNCTION
 
FUNCTION q905_show()
   #modify 020815  NO.A030
   DISPLAY BY NAME g_ae.aea01,g_ae.aag24,g_ae.aea00  #No.FUN-740033
   CALL q905_aea01('d')
   CALL q905_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q905_aea01(p_cmd)
    DEFINE
           p_cmd     LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)
           l_aag02   LIKE aag_file.aag02,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF g_ae.aea01 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aagacti
           INTO l_aag02,l_aagacti
           FROM aag_file WHERE aag01 = g_ae.aea01 AND aagacti ='Y'
                           AND aag00 = g_ae.aea00  #No.FUN-740033
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  aag02
    END IF
END FUNCTION
 
FUNCTION q905_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
          l_abb06   LIKE abb_file.abb06
 
   #modify 020815  NO.A030
   LET l_sql =
        "SELECT aea02,aba05,aea03,aba06,abb24,abb25,abb07f,abb07,",
        "       0,0,abb04,abb06 ",
        " FROM  aea_file,aba_file,abb_file,aag_file ",
        " WHERE aea00 = aag00",  #No.FUN-740033
        " AND aba01 = aea03 AND abb01 = aea03  AND abb02 = aea04 ",
        " AND aba00 = aea00 ",
        " AND abb00 = aea00 ",
        " AND aea01 ='",g_ae.aea01,"'",
        " AND aea00 ='",g_ae.aea00,"'",  #No.FUN-740033
        " AND aag01 = aea01 ",
	" AND ",tm.wc CLIPPED,
        " ORDER BY aea02"                #No.FUN-740033
    PREPARE q905_pb FROM l_sql
    DECLARE q905_bcs                       #BODY CURSOR
        CURSOR FOR q905_pb
 
    CALL g_aea.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q905_bcs INTO g_aea[g_cnt].*,l_abb06
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        IF l_abb06 = '2' THEN
           LET g_aea[g_cnt].abb07_2 = g_aea[g_cnt].abb07_1
           LET g_aea[g_cnt].abb07_1 = 0
           LET g_aea[g_cnt].abb07f_2 = g_aea[g_cnt].abb07f_1
           LET g_aea[g_cnt].abb07f_1 = 0
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_aea.deleteElement(g_cnt)  #No.TQC-740053
    LET g_rec_b = g_cnt - 1
END FUNCTION
 
FUNCTION q905_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aea TO s_aea.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
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
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
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
 
#Patch....NO.TQC-610037 <001> #
