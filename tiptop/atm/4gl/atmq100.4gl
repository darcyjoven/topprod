# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmq100.4gl
# Descriptions...: 車輛已派車狀況查詢
# Date & Author..: 04/01/14 By Carrier
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3 
#
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/24 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
        g_obw RECORD LIKE obw_file.*,
        g_adk DYNAMIC ARRAY OF RECORD
            r       LIKE type_file.num5,             #No.FUN-680120 SMALLINT
            adk01   LIKE adk_file.adk01,
            adk02   LIKE adk_file.adk02,
            adk03   LIKE adk_file.adk03,
            adk15   LIKE adk_file.adk15,
            adk04   LIKE adk_file.adk04,
            adk05   LIKE adk_file.adk05,
            adk06   LIKE adk_file.adk06,
            adk07   LIKE adk_file.adk07
        END RECORD,
        	g_wc,g_wc2      string,  #No.FUN-580092 HCN
        g_bdate,g_edate LIKE type_file.dat,           #No.FUN-6B0031 DATE
        l_ac            LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         g_sql           string, #WHERE CONDITION  #No.FUN-580092 HCN
        g_rec_b         LIKE type_file.num5   		  #單身筆數               #No.FUN-680120 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose #No.FUN-680120 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
 
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE   g_str          STRING                       #No.FUN-760083
DEFINE   l_table        STRING                       #No.FUN-760083
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6B0014
    DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-760083 --begin--
   LET g_sql="obw20.obw_file.obw20,",
             "obw16.obw_file.obw16,",
             "obw06.obw_file.obw06,",
             "obw05.obw_file.obw05,",
             "obw04.obw_file.obw04,",
             "obw03.obw_file.obw03,",
             "obw02.obw_file.obw02,",
             "obw01.obw_file.obw01,",
             "adk15.adk_file.adk15,",
             "adk07.adk_file.adk07,",
             "adk06.adk_file.adk06,",
             "adk05.adk_file.adk05,",
             "adk04.adk_file.adk04,",
             "adk03.adk_file.adk03,",
             "adk02.adk_file.adk02,",
             "adk01.adk_file.adk01,",
             "gen02.gen_file.gen02,",
             "l_desc.ze_file.ze03"
    LET l_table=cl_prt_temptable("atmq100",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err("insert_prep:",status,1)
    END IF
#No.FUN-760083   --end--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
       LET p_row = 3 LET p_col = 2
 OPEN WINDOW atmq100_w AT p_row,p_col
         WITH FORM "atm/42f/atmq100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
--##
    CALL g_x.clear()
--##
 
#    IF cl_chk_act_auth() THEN
#       CALL q100_q()
#    END IF
    CALL q100_menu()    #中文
    CLOSE WINDOW atmq100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION q100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680120 SMALLINT
   CALL g_adk.clear()
   CALL cl_opmsg('q')
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   INITIALIZE g_obw.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON
      obw01,obw05,obw02,obw03,obw04,obw06,obw16,obw20
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_bdate = g_today
   LET g_edate = g_today
 
   INPUT g_bdate,g_edate WITHOUT DEFAULTS
         FROM FORMONLY.bdate,FORMONLY.edate
 
      AFTER FIELD edate
        IF g_edate < g_bdate THEN NEXT FIELD bdate END IF
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON adk01,adk02,adk03,adk15,adk04,adk05,
                      adk06,adk07
      FROM s_sr[1].adk01 ,s_sr[1].adk02,s_sr[1].adk03,
           s_sr[1].adk15 ,s_sr[1].adk04,s_sr[1].adk05,
           s_sr[1].adk06 ,s_sr[1].adk07
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc CLIPPED," AND obwuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc CLIPPED," AND obwgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc CLIPPED," AND obwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('obwuser', 'obwgrup')
   #End:FUN-980030
 
 
   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
   LET g_sql="SELECT UNIQUE obw01 FROM obw_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND obw07='1' ",
             " ORDER BY obw01  "
 
   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs SCROLL CURSOR FOR q100_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(UNIQUE obw01) FROM obw_file",
             "  WHERE ",g_wc CLIPPED," AND obw07='1' "
   PREPARE q100_pp  FROM g_sql
   DECLARE q100_cnt CURSOR FOR q100_pp
--## 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN q100_cnt
   FETCH q100_cnt INTO g_row_count
   CLOSE q100_cnt
END FUNCTION
 
FUNCTION q100_b_askkey()
   CONSTRUCT g_wc2 ON adk01,adk02,adk03,adk15,adk04,adk05,
                      adk06,adk07
      FROM s_sr[1].adk01 ,s_sr[1].adk02,s_sr[1].adk03,
           s_sr[1].adk15 ,s_sr[1].adk04,s_sr[1].adk05,
           s_sr[1].adk06 ,s_sr[1].adk07
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
     END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION q100_menu()
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q100_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q100_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
--mi
    OPEN q100_cnt
    FETCH q100_cnt INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
--#
    OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs INTO g_obw.obw01
        WHEN 'P' FETCH PREVIOUS q100_cs INTO g_obw.obw01
        WHEN 'F' FETCH FIRST    q100_cs INTO g_obw.obw01
        WHEN 'L' FETCH LAST     q100_cs INTO g_obw.obw01
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
#             PROMPT g_msg CLIPPED,': ' FOR l_abso
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q100_cs INTO g_obw.obw01
            LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
        INITIALIZE g_obw.* TO NULL  #TQC-6B0105
        RETURN
    END IF
	SELECT * INTO g_obw.* FROM obw_file
	 WHERE obw01 = g_obw.obw01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
        CALL cl_err3("sel","obw_file",g_obw.obw01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660104
        RETURN
    END IF
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
 
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_desc    LIKE ze_file.ze03             #No.FUN-680120 VARCHAR(04)
   DISPLAY BY NAME  g_obw.obw01,g_obw.obw05,g_obw.obw02,g_obw.obw03,
                    g_obw.obw04,g_obw.obw06,g_obw.obw16,g_obw.obw20
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_obw.obw16
   DISPLAY l_gen02  TO FORMONLY.gen02
 
   CASE g_obw.obw06
        WHEN '1' CALL cl_getmsg('axd-035',g_lang) RETURNING l_desc
        WHEN '2' CALL cl_getmsg('axd-036',g_lang) RETURNING l_desc
   END CASE
   DISPLAY l_desc TO FORMONLY.desc
 
   CALL q100_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q100_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET l_sql ="SELECT 0,adk01,adk02,adk03,adk15,adk04,adk05,adk06,adk07",
              "  FROM adk_file",
              " WHERE adk08='",g_obw.obw01,"' AND adkconf ='Y' ",
              "   AND adk02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY adk02,adk01 "
    PREPARE q100_pb FROM l_sql
    DECLARE q100_bcs                       #BODY CURSOR
        CURSOR FOR q100_pb
 
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q100_bcs INTO g_adk[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_adk[g_cnt].r = g_cnt
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     END FOREACH
    CALL g_adk.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adk TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q100_fetch('L')
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
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q100_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
          obw       RECORD LIKE obw_file.*,
          adk       RECORD LIKE adk_file.*,
          gen02     LIKE gen_file.gen02
                    END RECORD,
    l_name          LIKE type_file.chr20,          #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
     l_za05          LIKE za_file.za05      #MOD-4B0067
DEFINE   l_desc      LIKE ze_file.ze03      #No.FUN-760083
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    #CALL cl_wait()                                               #No.FUN-760083
    #CALL cl_outnam('atmq100') RETURNING l_name                   #No.FUN-760083
    LET g_str=''                                                  #No.FUN-760083
    CALL cl_del_data(l_table)                                     #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog        #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT obw_file.*,adk_file.*,gen02",
              "  FROM obw_file,OUTER adk_file,OUTER gen_file",
 #MOD-4B0067(BEGIN)
              " WHERE obw_file.obw01 =adk_file.adk08  AND obw07 = '1' ",
              "   AND adk_file.adkconf = 'Y' AND obw_file.obw16 = gen_file.gen01 ",
              "   AND adk_file.adk02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
 #MOD-4B0067(END)
              "   AND ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY obw01,adk02,adk01 "
    PREPARE q100_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q100_co CURSOR FOR q100_p1
 
    #START REPORT q100_rep TO l_name
 
    FOREACH q100_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-760083  --begin--
        CASE sr.obw.obw06                                                                                                       
                 WHEN '1' CALL cl_getmsg('axd-035',g_lang) RETURNING l_desc                                                         
                 WHEN '2' CALL cl_getmsg('axd-036',g_lang) RETURNING l_desc                                                         
        END CASE      
        EXECUTE insert_prep  USING  sr.obw.obw20,sr.obw.obw16,sr.obw.obw06,sr.obw.obw05,
                                    sr.obw.obw04,sr.obw.obw03,sr.obw.obw02,sr.obw.obw01,
                                    sr.adk.adk15,sr.adk.adk07,sr.adk.adk06,sr.adk.adk05,
                                    sr.adk.adk04,sr.adk.adk03,sr.adk.adk02,sr.adk.adk01,
                                    sr.gen02,l_desc         
        #OUTPUT TO REPORT q100_rep(sr.*)
#No.FUN-760083 --end--
    END FOREACH
 
    #FINISH REPORT q100_rep   #No.FUN-760083
 
    CLOSE q100_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)    #No.FUN-760083
    IF g_zz05='Y' THEN 
         CALL cl_wcchp(g_wc,'obw01,obw05,obw02,obw03,obw04,obw06,obw16,obw20')
         RETURNING   g_wc
    END IF
    LET g_str=g_wc,';',g_bdate,';',g_edate
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3("atmq100","atmq100",g_sql,g_str)
END FUNCTION
 
#No.FUN-760083  --BEGIN--
{
REPORT q100_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    sr              RECORD
          obw       RECORD LIKE obw_file.*,
          adk       RECORD LIKE adk_file.*,
          gen02     LIKE gen_file.gen02
                    END RECORD,
    l_desc          LIKE ze_file.ze03              #No.FUN-680120 VARCHAR(04) 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.obw.obw01,sr.adk.adk02,sr.adk.adk01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
 
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                  g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
                  g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]
            PRINT g_dash1
#            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.obw.obw01
        ON EVERY ROW
            CASE sr.obw.obw06
                 WHEN '1' CALL cl_getmsg('axd-035',g_lang) RETURNING l_desc
                 WHEN '2' CALL cl_getmsg('axd-036',g_lang) RETURNING l_desc
            END CASE
            PRINT COLUMN g_c[31],sr.obw.obw01,
                  COLUMN g_c[32],sr.obw.obw02,
                  COLUMN g_c[33],sr.obw.obw05,
                  COLUMN g_c[34],sr.obw.obw03,
                  COLUMN g_c[35],sr.obw.obw04,
                  COLUMN g_c[36],sr.obw.obw06,
                  COLUMN g_c[37],l_desc,
                  COLUMN g_c[38],sr.obw.obw20,
                  COLUMN g_c[39],sr.obw.obw16,
                  COLUMN g_c[40],sr.gen02,
                  COLUMN g_c[41],g_bdate,
                  COLUMN g_c[42],g_edate;
 
            IF NOT cl_null(sr.adk.adk01) THEN
               PRINT COLUMN g_c[43],sr.adk.adk01,
                     COLUMN g_c[44],sr.adk.adk02,
                     COLUMN g_c[45],sr.adk.adk03,
                     COLUMN g_c[46],sr.adk.adk15,
                     COLUMN g_c[47],sr.adk.adk04,
                     COLUMN g_c[48],sr.adk.adk05,
                     COLUMN g_c[49],sr.adk.adk06,
                     COLUMN g_c[50],sr.adk.adk07
             ELSE
               PRINT ''
            END IF
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083  --END--
 
 
 
