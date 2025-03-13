# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq138.4gl
# Descriptions...: 料件備料明細查詢
# Date & Author..: 93/05/19 By Roger
#                  By Melody    修改 l_sql 條件、合計考慮單位換算
# Modify.........: No.MOD-480143 04/08/11 By Nicola 單身不會即時更新
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-530273 05/05/05 By Mandy 2.工單備料明細查詢數量不合
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790048 07/09/10 By lumxa 匯出Excel時候多一空白行
# Modify.........: No.FUN-940008 09/05/15 By hongmei發料改善
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A90095 10/09/15 By Summer g_sfa065改為DYNAMIC ARRAY
# Modify.........: No:MOD-BA0158 12/06/15 By ck2yuan 單身無法顯示資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1	LIKE ima_file.ima01     # 所要查詢的key
  DEFINE g_wc,g_wc2	string             	# WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql		string                  #No.FUN-580092 HCN
  DEFINE g_rec_b	LIKE type_file.num5     #No.FUN-690026 SMALLINT
  DEFINE g_ima          RECORD
			ima01	LIKE ima_file.ima01,
  			ima02	LIKE ima_file.ima02,
  			ima021	LIKE ima_file.ima021,
  			ima08	LIKE ima_file.ima08
            		END RECORD
  DEFINE g_sr           DYNAMIC ARRAY OF RECORD
            		sfa01   LIKE sfa_file.sfa01,
            		sfb82   LIKE sfb_file.sfb82,
            		sfb05   LIKE sfb_file.sfb05,
            		sfa05   LIKE sfa_file.sfa05,
            		sfa06   LIKE sfa_file.sfa06,
            		sfa07   LIKE sfa_file.sfa07,
            		sfa12   LIKE sfa_file.sfa12,
                        sfa012  LIKE sfa_file.sfa012,   #FUN-A60027
                        sfa013  LIKE sfa_file.sfa013    #FUN-A60027 
            		END RECORD
 #DEFINE g_sfa065       ARRAY[200] OF LIKE sfa_file.sfa065 #MOD-A90095 mark
  DEFINE g_sfa065       DYNAMIC ARRAY OF LIKE sfa_file.sfa065 #MOD-A90095
  DEFINE g_factor       LIKE sfa_file.sfa13
  DEFINE p_row,p_col    LIKE type_file.num5                  #No.FUN-690026 SMALLINT
 #MOD-A90095 mod --start--
 #DEFINE g_sfa08        ARRAY[200] OF LIKE sfa_file.sfa08    #No.FUN-940008 add
 #DEFINE g_sfa03        ARRAY[200] OF LIKE sfa_file.sfa03    #No.FUN-940008 add
 #DEFINE g_sfa27        ARRAY[200] OF LIKE sfa_file.sfa27    #No.FUN-940008 add
  DEFINE g_sfa08        DYNAMIC ARRAY OF LIKE sfa_file.sfa08  
  DEFINE g_sfa03        DYNAMIC ARRAY OF LIKE sfa_file.sfa03   
  DEFINE g_sfa27        DYNAMIC ARRAY OF LIKE sfa_file.sfa27  
 #MOD-A90095 mod --end--
  DEFINE g_short_qty    LIKE sfa_file.sfa07                  #No.FUN-940008 add
 
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    LET p_row = 4 LET p_col = 3
 
    OPEN WINDOW q138_w AT p_row,p_col
         WITH FORM "aim/42f/aimq138"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("sfa012,sfa013",g_sma.sma541 = 'Y')  #FUN-A60027
 
#    IF cl_chk_act_auth() THEN
#       CALL q138_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q138_q() END IF
    CALL q138_menu()
    CLOSE WINDOW q138_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION q138_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
		   LET g_wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_sr.clear()
           CALL cl_opmsg('q')
           INITIALIZE g_ima.* TO NULL   #FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
           CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021 # 螢幕上取單頭條件
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
 
                #### No.FUN-4A0041
              ON ACTION controlp
                  CASE
                    WHEN INFIELD(ima01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima01
                     NEXT FIELD ima01
                  END CASE
               ### END  No.FUN-4A0041
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
		   LET g_wc2=" 1=1 "
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT ima01 FROM ima_file ",
             " WHERE ",g_wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q138_prepare FROM g_sql
   DECLARE q138_cs SCROLL CURSOR FOR q138_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q138_pp  FROM g_sql
   DECLARE q138_count   CURSOR FOR q138_pp
END FUNCTION
 
FUNCTION q138_b_askkey()
   CONSTRUCT g_wc2 ON pmn01 FROM s_sr[1].pmn01
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
END FUNCTION
 
FUNCTION q138_menu()
 
   WHILE TRUE
      CALL q138_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q138_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q138_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q138_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q138_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q138_count
       FETCH q138_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q138_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q138_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q138_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q138_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q138_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q138_cs INTO g_ima.ima01
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
            FETCH ABSOLUTE g_jump q138_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
	SELECT ima01,ima02,ima021,ima08 INTO g_ima.* FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q138_show()
END FUNCTION
 
FUNCTION q138_show()
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08
   CALL q138_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q138_b_fill()              #BODY FILL UP
   DEFINE l_sql                     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE sfa05_t,sfa06_t,sfa07_t   LIKE sfa_file.sfa05
 
   LET l_sql =
#No.+034 by tommy
#       "SELECT sfa01,sfb82,sfb05,sfa05,sfa06,sfa07,sfa13",  # 96-07-23
#       "SELECT sfa01,sfb82,sfb05,sfa05,sfa06,sfa07,sfa12,sfa13,",  # 96-07-23  #FUN-940008 mark
        "SELECT sfa01,sfb82,sfb05,sfa05,sfa06,'',sfa12,sfa012,sfa013,sfa13,sfa065,sfa03,sfa08,sfa27",  #FUN-940008 add   #FUN-A60027 add sfa012,sfa013
#       "       sfa065 ",  #FUN-940008 mark
        "  FROM sfb_file,sfa_file",
        " WHERE sfa03 = '",g_ima.ima01,"' AND ", g_wc2 CLIPPED,
        "   AND sfb01 = sfa01 AND sfb87!='X' ",
        #"   AND sfb04 !='8' AND (sfa05 > sfa06 OR sfa07 > 0) ",                    #MOD-530273
         "   AND sfb04 !='8' ",
#       "   AND ((sfa05 > (sfa06+sfa07+sfa065)) OR (sfa07 > 0)) ", #MOD-530273 #FUN-940008 mark
        " ORDER BY sfa01 "
    PREPARE q138_pb FROM l_sql
    DECLARE q138_bcs CURSOR FOR q138_pb
 
    FOR g_cnt = 1 TO g_sr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sr[g_cnt].* TO NULL
     # INITIALIZE g_sfa065[g_cnt].* TO NULL
       INITIALIZE g_sfa065[g_cnt]   TO NULL
    END FOR
    LET g_cnt = 1
    LET sfa05_t = 0
    LET sfa06_t = 0
    LET sfa07_t = 0
    FOREACH q138_bcs INTO g_sr[g_cnt].*,g_factor,g_sfa065[g_cnt],
                          g_sfa03[g_cnt],g_sfa08[g_cnt],g_sfa27[g_cnt]     #FUN-940008 add
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
        #FUN-940008---Begin add  #欠料量計算
        CALL s_shortqty(g_sr[g_cnt].sfa01,g_sfa03[g_cnt],g_sfa08[g_cnt],
                        g_sr[g_cnt].sfa12,g_sfa27[g_cnt],g_sr[g_cnt].sfa012,g_sr[g_cnt].sfa013)    #FUN-A60027 add sfa012,sfa013      
             RETURNING g_short_qty
       #MOD-BA0158---mark---start---    #資料被CONTINUE FOREACH就無法顯示資料了
       #IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
       #IF g_sr[g_cnt].sfa05 <= g_sr[g_cnt].sfa06+g_short_qty+g_sfa065[g_cnt] THEN
       #   CONTINUE FOREACH
       #END IF
       #IF g_short_qty <= 0 THEN
       #   CONTINUE FOREACH
       #END IF        
       #MOD-BA0158---mark---end---
        LET g_sr[g_cnt].sfa07 = g_short_qty
        #FUN-940008---End   
        #IF g_factor IS NULL THEN LET g_factor=1 END IF
        LET g_sr[g_cnt].sfa05=g_sr[g_cnt].sfa05
        LET g_sr[g_cnt].sfa06=g_sr[g_cnt].sfa06
        LET g_sr[g_cnt].sfa07=g_sr[g_cnt].sfa07
      # LET g_sr[g_cnt].sfa06=g_sr[g_cnt].sfa05-g_sr[g_cnt].sfa06
      # BugNo:4824
        LET g_sr[g_cnt].sfa06=g_sr[g_cnt].sfa05-g_sr[g_cnt].sfa06
                                               -g_sfa065[g_cnt]
                                                -g_sr[g_cnt].sfa07 #MOD-530273
        LET sfa05_t=sfa05_t+g_sr[g_cnt].sfa05*g_factor
        LET sfa06_t=sfa06_t+g_sr[g_cnt].sfa06*g_factor
        LET sfa07_t=sfa07_t+g_sr[g_cnt].sfa07*g_factor
        LET g_cnt = g_cnt + 1
#       IF g_cnt > g_sr_arrno THEN
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sr.deleteElement(g_cnt)   #TQC-790048
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY BY NAME sfa05_t,sfa06_t,sfa07_t
END FUNCTION
 
FUNCTION q138_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
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
         CALL q138_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q138_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q138_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q138_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q138_fetch('L')
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
#         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
