# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglq905.4gl
# Descriptions...: 分類帳查詢
# Date & Author..: 92/02/25 By DAVID
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
#
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By arman   會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760105 07/06/13 By hongmei 處理帳套顯示問題
# Modify.........: No.TQC-790005 07/09/03 By Carrier 單身fill時加入單頭的帳套條件
# Modify.........: No.MOD-860064 08/06/09 By Sarah q905_b_fill()中q905_pb的l_sql將abb03 = aea01改為abb03 = aea05(對應明細科目)
# Modify.........: No.FUN-940013 09/04/30 By jan aea01 欄位增加開窗功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
       	wc  	LIKE type_file.chr1000	# Head Where condition    #No.FUN-680098  VARCHAR(600)
        END RECORD,
    #modify 020815  NO.A030
    g_ae  RECORD
           aea00                LIKE aea_file.aea00,     #NO.FUN-740020
           aea01		LIKE aea_file.aea01,
           aag24		LIKE aag_file.aag24
       END RECORD,
    g_aea DYNAMIC ARRAY OF RECORD
            aea02   LIKE aea_file.aea02,
            aba05   LIKE aba_file.aba05,
            aea03   LIKE aea_file.aea03,
            aba06   LIKE aba_file.aba06,
            abb04   LIKE abb_file.abb04,
            abb07_1 LIKE abb_file.abb07,
            abb07_2 LIKE abb_file.abb07
        END RECORD,
    g_bookno     LIKE aea_file.aea00,      # INPUT ARGUMENT - 1
    g_wc,g_sql STRING,     #WHERE CONDITION  #No.FUN-580092 HCN        
    g_rec_b LIKE type_file.num5   		  #單身筆數        #No.FUN-680098 smallint
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680098 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098  smallint
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0073
      DEFINE    l_sl		LIKE type_file.num5          #No.FUN-680098  smallint
   DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680098  smallint
 
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
 
 
#    LET g_bookno      = ARG_VAL(1)          #參數值(1) Part#  #NO.FUN-740020
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq905_w AT p_row,p_col
         WITH FORM "agl/42f/aglq905"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)    #NO.FUN-740020
#    IF cl_chk_act_auth() THEN
#       CALL q905_q()
#    END IF
#NO.FUN-740020    ---Begin
IF NOT cl_null(g_bookno) THEN CALL q905_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)
#NO.FUN-740020    ---END
    CALL q905_menu()
    CLOSE WINDOW aglq905_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q905_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098  smallint
 
   CLEAR FORM #清除畫面
   CALL g_aea.clear()
   CALL cl_opmsg('q')
  INITIALIZE tm.* TO NULL			# Default condition
   #modify 020815  NO.A030
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
   INITIALIZE g_ae.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON                   # 螢幕上取單頭條件
             aea00,aea01,aag24,aea02            #NO.FUN-740020   ＃No.TQC-760105
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
#  NO.FUN-740020   ---Begin 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aea00)                        
               CALL cl_init_qry_var()                  
               LET g_qryparam.form = "q_aaa" 
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aea00
               NEXT FIELD aea00
            #FUN-940013--begin--add 
            WHEN INFIELD(aea01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO aea01 
                   NEXT FIELD aea01
            #FUN-940013--end--
         END CASE
#  NO.FUN-740020   ---End
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
   LET g_sql=" SELECT UNIQUE aag00,aea01,aag24 FROM aea_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,    #NO.FUN-740020
             "   AND aea00 = aag00 ",    #No.TQC-790005
             " AND aea01 =  aag01 AND aag03 = '2' AND aag07 IN ('1','3')"
   PREPARE q905_prepare FROM g_sql
   DECLARE q905_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q905_prepare
 
   LET g_sql=" SELECT COUNT(UNIQUE aea01) FROM aea_file,aag_file ",
             " WHERE  ",tm.wc CLIPPED,   #NO.FUN-740020
             "   AND aea00 = aag00 ",    #No.TQC-790005
             " AND aea01 =  aag01 AND aag03 = '2' AND aag07 IN ('1','3')"
   PREPARE q905_prepare_pre FROM g_sql
   DECLARE q905_count CURSOR FOR q905_prepare_pre
 
END FUNCTION
 
FUNCTION q905_menu()
 
   WHILE TRUE
      CALL q905_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q905_q()
            END IF
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
    MESSAGE ""
    CALL cl_opmsg('q')
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
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer
 
    #modify 020815  NO.A030
    CASE p_flag
        WHEN 'N' FETCH NEXT     q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.TQC-760105
        WHEN 'P' FETCH PREVIOUS q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.TQC-760105  
        WHEN 'F' FETCH FIRST    q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.TQC-760105  
        WHEN 'L' FETCH LAST     q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24  #No.TQC-760105
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
            FETCH ABSOLUTE g_jump q905_cs INTO g_ae.aea00,g_ae.aea01,g_ae.aag24    #No.TQC-760105
            LET mi_no_ask = FALSE
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
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q905_show()
END FUNCTION
 
FUNCTION q905_show()
   #modify 020815  NO.A030
   DISPLAY BY NAME g_ae.aea00,g_ae.aea01,g_ae.aag24    #No.TQC-760105
   CALL q905_aea01('d')
   CALL q905_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q905_aea01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1) 
           l_aag02 LIKE aag_file.aag02,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF g_ae.aea01 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aagacti
           INTO l_aag02,l_aagacti
           FROM aag_file WHERE aag00 = g_ae.aea00 AND  aag01 = g_ae.aea01 AND aagacti ='Y'     #NO.FUN-740020
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
   DEFINE l_sql   LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(1000) 
          l_aea03 LIKE aea_file.aea03,
          l_aba05 LIKE aba_file.aba05,
          l_abb04 LIKE abb_file.abb04,
          l_abb06 LIKE abb_file.abb06,
          l_abb07 LIKE abb_file.abb07
 
   LET l_sql =
        "SELECT aea02,aba05, aea03, aba06, abb04,0,0, abb06,abb07 ",
        " FROM  aea_file,aba_file,abb_file,aag_file ",               #No.A056
        #No.TQC-790005  --Begin
        " WHERE abb00 = aba00 AND abb00 = aea00 ",
        "   AND aea00 = '",g_ae.aea00,"'",
        "   AND aba01 = abb01 AND aba01 = aea03 ",
       #"   AND abb02 = aea04 AND abb03 = aea01 ",   #MOD-860064 mark
        "   AND abb02 = aea04 AND abb03 = aea05 ",   #MOD-860064
        "   AND aea00 = aag00 AND aea01 = aag01 ", 
        "   AND aea01 = '",g_ae.aea01,"'",
	"   AND ",tm.wc CLIPPED,
        " ORDER BY aea02"
        #No.TQC-790005  --End  
    PREPARE q905_pb FROM l_sql
    DECLARE q905_bcs                       #BODY CURSOR
        CURSOR FOR q905_pb
 
    FOR g_cnt = 1 TO g_aea.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_aea[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q905_bcs INTO g_aea[g_cnt].*,l_abb06,l_abb07
        IF g_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLCODE
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #----
        IF l_abb06='1' THEN
           LET g_aea[g_cnt].abb07_1=l_abb07
        ELSE
           LET g_aea[g_cnt].abb07_2=l_abb07
        END IF
        #----
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_aea_arrno THEN
#            CALL cl_err('','agl-114',0)
#            EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q905_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aea TO s_aea.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q905_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q905_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q905_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q905_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q905_fetch('L')
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
 
#Patch....NO.TQC-610035 <001> #
