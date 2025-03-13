# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: aglq906.4gl
# Descriptions...: 明細分類帳查詢
# Date & Author..: 92/03/28 By MAY
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.CHI-710005 07/01/18 By Elva 參考gglq906，加傳票明細查詢功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/09 By bnlent 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-840699 08/04/30 By Smapmin 將獨立科目也納進來
# Modify.........: No.MOD-850012 08/05/05 By Carol 完整顯示abb04資料
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-860021 08/06/30 By xiaofeizhu 加上匯出EXCEL的功能
# Modify.........: No.MOD-860273 08/07/02 By Sarah 原先顯示gnm-001訊息的地方改顯示agl-193
# Modify.........: No.FUN-8A0077 08/10/17 By xiaofeizhu 新增「幣別」(abb24) / 原幣借方金額」(abb07f_1) /「原幣貸方金額」(abb07f_2)
# Modify.........: No.MOD-950041 09/05/06 By lilingyu 查詢有可能跨年度查,故檢核mfg6150訊息段mark掉   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0104 09/10/21 By wujie  ¶U¤è¥¿­t¸¹¤Ï¤F
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:MOD-A60158 10/06/23 By Dido 傳遞參數與 aglt110 相同
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: No.MOD-B50144 11/05/18 By Dido 傳遞參數二帳別 
# Modify.........: No.MOD-CA0103 12/10/16 By Polly 和aglr906一致，需排除aag03=2的條件
# Modify.........: No.MOD-D10010 13/01/22 By apo 產生的資料，單頭會科需依會科順序做為排列

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
           wc1  LIKE type_file.chr1000,	# Head Where condition  #No.FUN-680098  VARCHAR(600) 
           wc  	LIKE type_file.chr1000	# Head Where condition  #No.FUN-680098   VARCHAR(600) 
        END RECORD,
    bdate,edate  LIKE type_file.dat,  #CHI-710005
    g_ae  RECORD
           aea00                LIKE aea_file.aea00,   #No.FUN-740020
           aea05		LIKE aea_file.aea05,
           aea02		LIKE aea_file.aea02
       END RECORD,
    g_aea DYNAMIC ARRAY OF RECORD
            aea02   LIKE aea_file.aea02,
            aba05   LIKE aba_file.aba05,
            aea03   LIKE aea_file.aea03,
            aba06   LIKE aba_file.aba06,
            abb04   LIKE abb_file.abb04,
            abb07_1 LIKE abb_file.abb07,
            abb07_2 LIKE abb_file.abb07,
            b       LIKE aah_file.aah04, #CHI-710005
            abb24    LIKE abb_file.abb24, #FUN-8A0077
            abb07f_1 LIKE abb_file.abb07, #FUN-8A0077
            abb07f_2 LIKE abb_file.abb07  #FUN-8A0077            
        END RECORD,
    g_bookno     LIKE aea_file.aea00,      # INPUT ARGUMENT  
    l_ac    LIKE type_file.num5, #CHI-710005 
     g_wc,g_sql STRING,     #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num5   	      #單身筆數     #No.FUN-680098 smallint
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680098 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680098 smallint
MAIN
      DEFINE    l_sl	        LIKE type_file.num5          #No.FUN-680098  smallint 
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
 
 
    LET g_bookno      = ARG_VAL(1)         #參數值(1) Part#
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq906_w AT p_row,p_col
         WITH FORM "agl/42f/aglq906"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET bdate=g_today  #CHI-710005
    LET edate=g_today  #CHI-710005
 
 CALL s_shwact(0,0,g_bookno)   #No:8597
IF NOT cl_null(g_bookno) THEN CALL q906_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)                #No:8597
 
    CALL q906_menu()
    CLOSE WINDOW aglq906_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q906_cs()
   DEFINE   l_cnt            LIKE type_file.num5          #No.FUN-680098  smallint
 
   CLEAR FORM #清除畫面
   CALL g_aea.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
 
   INITIALIZE g_ae.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc1 ON aag00,aag01    #No.FUN-740020
      ON ACTION CONTROLP
            CASE
                WHEN INFIELD(aag00)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aaa"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag00
                      NEXT FIELD aag01      #No.FUN-B50051
   #No.FUN-B50051--str--
            WHEN INFIELD(aag01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aag01
                   NEXT FIELD aag01
          OTHERWISE
             EXIT CASE
   #No.FUN-B50051--end--
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
 
 
   END CONSTRUCT
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
    INPUT BY NAME bdate,edate WITHOUT DEFAULTS
      AFTER FIELD bdate
         IF cl_null(bdate) THEN
              NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(edate) THEN
            LET edate =g_lastdat
         END IF
         IF edate < bdate THEN
            CALL cl_err(' ','agl-031',0)
            NEXT FIELD edate
         END IF
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
            
            ON ACTION about         
               CALL cl_about()      
            
            ON ACTION help          
               CALL cl_show_help()  
            
            ON ACTION controlg      
               CALL cl_cmdask()     
    END INPUT
   IF INT_FLAG THEN RETURN END IF
   CONSTRUCT BY NAME tm.wc ON aea02
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   LET g_sql=" SELECT aag00,aag01 FROM aag_file ",    #No.FUN-740020
             " WHERE ",tm.wc1 CLIPPED,
            #"   AND aag03 = '2' ",                   #MOD-CA0103 mark
             "   AND (aag07 = '2' OR aag07 = '3') "   #MOD-840699
            ," ORDER BY aag00,aag01"                  #MOD-D10010 add
   PREPARE q906_prepare FROM g_sql
   DECLARE q906_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q906_prepare
 
    LET g_sql="SELECT COUNT(*) FROM aag_file ",
              " WHERE ",tm.wc1 CLIPPED,
             #"   AND aag03 = '2' ",                   #MOD-CA0103 mark
              "   AND (aag07 = '2' OR aag07 = '3') "   #MOD-840699
    PREPARE q906_precount FROM g_sql
    DECLARE q906_count CURSOR FOR q906_precount
END FUNCTION
 
FUNCTION q906_menu()
DEFINE   p_vchno LIKE aea_file.aea03  #CHI-710005
DEFINE   g_cmd   LIKE type_file.chr1000 #CHI-710005
 
   WHILE TRUE
      CALL q906_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q906_q()
            END IF
         WHEN "drill"
            IF NOT cl_null(g_ae.aea05) THEN
              #-MOD-B50144-add-
               IF NOT cl_null(g_ae.aea00) THEN 
                  LET g_bookno = g_ae.aea00
               END IF
              #-MOD-B50144-end-
               LET p_vchno=g_aea[l_ac].aea03
               IF NOT cl_null(p_vchno) THEN
                  CASE g_aea[l_ac].aba06
                     WHEN 'RV'
                       #LET g_cmd = "aglq170 '",g_bookno,"' '",p_vchno,"' "   #MOD-A60158 mark
                        LET g_cmd = "aglq170 '",p_vchno,"' "                  #MOD-A60158
                     WHEN 'AC'
                       #LET g_cmd = "aglt130 '",g_bookno,"' '",p_vchno,"' "   #MOD-A60158 mark
                        LET g_cmd = "aglt130 '",p_vchno,"' '",g_bookno,"' "   #MOD-A60158 #MOD-B50144 add g_bookno
                     OTHERWISE
                        LET g_cmd = "aglt110 '",p_vchno,"' '",g_bookno,"' "   #FUN-810046 #MOD-B50144 add g_bookno
                  END CASE
                  CALL cl_cmdrun(g_cmd)
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aea),'','')                                 
            END IF                                                                                                                  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q906_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q906_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q906_count
    FETCH q906_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q906_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q906_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q906_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式        #No.FUN-680098  VARCHAR(1) 
    l_abso          LIKE type_file.num10   #絕對的筆數     #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q906_cs INTO g_ae.aea00,g_ae.aea05    #No.FUN-740020
        WHEN 'P' FETCH PREVIOUS q906_cs INTO g_ae.aea00,g_ae.aea05    #No.FUN-740020
        WHEN 'F' FETCH FIRST    q906_cs INTO g_ae.aea00,g_ae.aea05    #No.FUN-740020
        WHEN 'L' FETCH LAST     q906_cs INTO g_ae.aea00,g_ae.aea05    #No.FUN-740020
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
            FETCH ABSOLUTE g_jump q906_cs INTO g_ae.aea00,g_ae.aea05   #No.FUN-740020
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ae.aea05,SQLCA.sqlcode,0)
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
 
    CALL q906_show()
END FUNCTION
 
FUNCTION q906_show()
   DISPLAY g_ae.aea00 TO aag00   #No.FUN-740020
   DISPLAY g_ae.aea05 TO aag01
   CALL q906_aea05('d')
   CALL q906_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q906_aea05(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1) 
           l_aag02 LIKE aag_file.aag02,         
           l_aagacti LIKE aag_file.aagacti   
 
    LET g_errno = ' '
    IF g_ae.aea05 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aagacti
           INTO l_aag02,l_aagacti
           FROM aag_file WHERE aag01 = g_ae.aea05
                           AND aag00 = g_ae.aea00   #No.FUN-740020
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  FORMONLY.aag02     #No.FUN-740020
    END IF
END FUNCTION
 
FUNCTION q906_b_fill()              #BODY FILL UP
   DEFINE l_sql   LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(400)
          l_aea03 LIKE aea_file.aea03,
          l_aba05 LIKE aba_file.aba05,
          l_abb04 LIKE abb_file.abb04,
          l_abb06 LIKE abb_file.abb06,
          l_abb07 LIKE abb_file.abb07,
          l_bal     LIKE aah_file.aah04,
          l_bal1    LIKE aah_file.aah04,
          l_bdate   LIKE type_file.dat,
          l_edate   LIKE type_file.dat
   DEFINE l_abb07f  LIKE abb_file.abb07f  #FUN-8A0077          
 
   #期初
   LET l_bal1=0
   LET l_bdate=bdate USING "YYYY-MM-DD"
   CALL q906_qcye(g_ae.aea05) RETURNING l_bal
 
   LET l_sql =
        "SELECT aea02,aba05, aea03, aba06, abb04 ,0,0,0,abb24,0,0, abb06,abb07,abb07f ", #CHI-710005 #FUN-8A0077 Add abb24,0,0,abb07f         
        " FROM  aea_file,abb_file,aba_file ",
        " WHERE ",tm.wc CLIPPED,
        " AND aea05 = '",g_ae.aea05,"'",
        " AND aea03 = abb01 AND aea04 = abb02  AND abb01 = aba01 ",
        " AND aea00 = '",g_ae.aea00,"'",
        " AND aba00 = '",g_ae.aea00,"'",
        " AND abb00 = '",g_ae.aea00,"'",
        " AND aea02 BETWEEN '",bdate,"' AND '",edate,"'", #CHI-710005
        " ORDER BY aea02"  #CHI-710005
    PREPARE q906_pb FROM l_sql
    DECLARE q906_bcs                       #BODY CURSOR
        CURSOR FOR q906_pb
 
    FOR g_cnt = 1 TO g_aea.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_aea[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_aea[1].b=l_bal
    LET l_bal1=l_bal
    CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
    LET g_aea[1].abb04 = g_msg CLIPPED
    LET g_cnt = 2
    FOREACH q906_bcs INTO g_aea[g_cnt].*,l_abb06,l_abb07,l_abb07f                   #FUN-8A0077 Add l_abb07f
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt=2 THEN  #CHI-710005
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF l_abb06='1' THEN
           LET g_aea[g_cnt].abb07_1=l_abb07
           LET g_aea[g_cnt].abb07f_1=l_abb07f                                        #FUN-8A0077 Add
        ELSE
           LET g_aea[g_cnt].abb07_2=l_abb07  #CHI-710005
           LET g_aea[g_cnt].abb07f_2=l_abb07f                                       #FUN-8A0077 Add
        END IF
        LET l_bal1=l_bal1+g_aea[g_cnt].abb07_1-g_aea[g_cnt].abb07_2 #No.TQC-9A0104
        LET g_aea[g_cnt].b=l_bal1 #CHI-710005
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
   #期末
    CALL cl_getmsg('agl-193',g_lang) RETURNING g_msg   #MOD-860273
    LET g_aea[g_cnt].abb04 = g_msg CLIPPED
    LET g_aea[g_cnt].b=l_bal1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q906_bp(p_ud)
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
 
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q906_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q906_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q906_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q906_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q906_fetch('L')
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
      LET g_action_choice="drill"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION drill_down
      LET g_action_choice="drill"
      LET l_ac = ARR_CURR()
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
 
      ON ACTION exporttoexcel                                                                                                       
         LET g_action_choice = 'exporttoexcel'                                                                                      
         EXIT DISPLAY                                                                                                               
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q906_qcye(l_aea05)
   DEFINE l_aea05 LIKE aea_file.aea05,
          l_bal,l_d,l_c  LIKE aah_file.aah04,
          l_y1    LIKE type_file.num5,            #起始日所在年度
          l_m1    LIKE type_file.num5,            #起始日所在期別
          l_flag  LIKE type_file.chr1,            #
          b_date  LIKE type_file.dat,
          e_date  LIKE type_file.dat             #截至日
 
   SELECT azn02,azn04 INTO l_y1,l_m1
     FROM azn_file
    WHERE azn01 = bdate
   #取得起始日會計期間的起始日和截至日
   #CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(l_y1,l_m1,g_plant,g_ae.aea00) RETURNING l_flag,b_date,e_date
   ELSE
      CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date
   END IF
   #CHI-A70007 add --end--
   LET l_bal = 0
   LET l_d = 0
   LET l_c = 0
 
   #會計科目余額檔
   SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
    WHERE aah01 = l_aea05
      AND aah02 = l_y1
      AND aah03 >= 0
      AND aah03 < l_m1
      AND aah00 = g_ae.aea00    #No.FUN-740020
   #會計傳票檔
   SELECT SUM(abb07) INTO l_d FROM abb_file,aba_file
    WHERE abb03 = l_aea05 AND aba01 = abb01 AND abb06='1'
      AND aba02 >= b_date
      AND aba02 < bdate
      AND abb00 = aba00
      AND aba00 = g_ae.aea00 AND abapost='Y'    #No.FUN-740020
   SELECT SUM(abb07) INTO l_c FROM aba_file,abb_file
    WHERE abb03 = l_aea05 AND aba01 = abb01 AND abb06='2'
      AND aba02 >= b_date
      AND aba02 < bdate
      AND abb00 = aba00
      AND aba00 = g_ae.aea00 AND abapost='Y'   #No.FUN-740020
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   IF cl_null(l_d) THEN LET l_d = 0 END IF
   IF cl_null(l_c) THEN LET l_c = 0 END IF
   LET l_bal = l_bal + l_d - l_c    # 期初余額
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   RETURN l_bal
END FUNCTION
#No.FUN-9C0072 精簡程式碼
