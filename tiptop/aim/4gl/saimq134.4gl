# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimq134.4gl
# Descriptions...: 料件在外明細查詢
# Date & Author..: 93/05/19 By Roger
#                  By Melody    新增'狀態'欄位、l_sql 條件修改
# Modify.........: No.MOD-480146 04/08/13 By Nicola "收貨明細查詢" 應不必詢問序號
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.MOD-4A0230 04/10/19 By Mandy 程式一執行出現9007錯誤
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-550005 05/05/02 By kim 修正 FUNCTION q134_bp(p_ud)的DISPLAY ARRAY
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-BB0287 11/11/26 By johung pmn16包含EF簽核狀況(R.S.W)
# Modify.........: No:TQC-C80095 12/08/15 By qiull 去掉單身的空值列，在b_fill中加CALL g_sr.deleteElement(g_cnt)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1	LIKE ima_file.ima01    # 所要查詢的key
  DEFINE g_wc,g_wc2	string                 # WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql		string                 #No.FUN-580092 HCN
  DEFINE g_rec_b	LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE g_ima RECORD
                        ima01	LIKE ima_file.ima01,
                        ima02	LIKE ima_file.ima02,
                        ima021	LIKE ima_file.ima021,
                        ima08	LIKE ima_file.ima08
             		END RECORD
  DEFINE g_sr DYNAMIC ARRAY OF RECORD
            		pmn01   LIKE pmn_file.pmn01,
            		pmn02   LIKE pmn_file.pmn02,
            		pmm09   LIKE pmm_file.pmm09,
            		pmc03   LIKE pmc_file.pmc03,
            		pmn33   LIKE pmn_file.pmn33,
            		pmn20   LIKE pmn_file.pmn20,
                        #FUN-570175  --begin
            		pmn83   LIKE pmn_file.pmn83,
            		pmn85   LIKE pmn_file.pmn85,
            		pmn80   LIKE pmn_file.pmn80,
            		pmn82   LIKE pmn_file.pmn82,
                        #FUN-570175  --end
            		on_order LIKE pmn_file.pmn20,
            		pmn07   LIKE pmn_file.pmn07,
            		pmn16   LIKE pmn_file.pmn16
            		END RECORD
  DEFINE g_factor	LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
  DEFINE g_pmn55        LIKE pmn_file.pmn55
  DEFINE g_pmn58        LIKE pmn_file.pmn58
  DEFINE g_order        LIKE type_file.num5      #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT

FUNCTION aimq134(p_ima01)
    DEFINE p_ima01         LIKE ima_file.ima01    #No.FUN-690026 VARCHAR(20)

    WHENEVER ERROR CONTINUE

    LET g_argv1 = p_ima01

    OPEN WINDOW q134_w WITH FORM "aim/42f/aimq134"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q134_def_form()

    LET g_action_choice = "query" #MOD-4A0230
    IF cl_chk_act_auth() THEN
       CALL q134_q()
    END IF
     LET g_action_choice = NULL    #MOD-4A0230
    CALL q134_menu()
    CLOSE WINDOW q134_w
END FUNCTION
 
FUNCTION q134_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
		   LET g_wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_sr.clear()
           CALL cl_opmsg('q')
           INITIALIZE g_ima.* TO NULL  #FUN-640213 add
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
   PREPARE q134_prepare FROM g_sql
   DECLARE q134_cs SCROLL CURSOR FOR q134_prepare
 
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
 
   PREPARE q134_pp  FROM g_sql
   DECLARE q134_cnt   CURSOR FOR q134_pp
END FUNCTION
 
FUNCTION q134_b_askkey()
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
 
#中文的MENU
 
FUNCTION q134_menu()
 
   WHILE TRUE
      CALL q134_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q134_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#@         WHEN "收貨明細查詢"
         WHEN "qry_receipts_details"
            CALL q134_detail()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q134_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q134_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q134_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q134_cnt
       FETCH q134_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q134_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q134_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q134_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q134_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q134_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q134_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q134_cs INTO g_ima.ima01
            LET g_no_ask = FALSE
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
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)  #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                    "",0)   #No.FUN-660156
        RETURN
    END IF
 
    CALL q134_show()
END FUNCTION
 
FUNCTION q134_show()
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08
   CALL q134_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q134_b_fill()              #BODY FILL UP
   DEFINE l_sql               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE pmn20_t,pmn20_o     LIKE pmn_file.pmn20
 
   # Subcontract 必需剔除 By David 93/06/03
   # 96/07/22
   LET l_sql =
#        "SELECT pmn01,pmn02,pmm09,pmc03,pmn33,pmn20,pmn50,pmn07,pmn16,0,pmn09,",
        #FUN-570175  --begin
        "SELECT pmn01,pmn02,pmm09,pmc03,pmn33,pmn20,pmn83,pmn85,pmn80,pmn82,",
        "       pmn50,pmn07,pmn16,pmn09,",
        #FUN-570175  --end
        " pmn55,pmn58 ",
        "  FROM pmn_file, pmm_file, OUTER pmc_file",
        " WHERE pmn04 = '",g_ima.ima01,"' AND ", g_wc2 CLIPPED,
        "   AND pmn01 = pmm01 AND pmm_file.pmm09 = pmc_file.pmc01",
      # "   AND pmn20 > pmn50-pmn55-pmn58 AND pmn16 <= '2'",
       #"   AND pmn20 > pmn50-pmn55 AND pmn16 <= '2'",   #No.+032在外量不含倉退      #MOD-BB0287 mark
        "   AND pmn20 > pmn50-pmn55 AND (pmn16 <= '2' OR pmn16 IN ('S','R','W'))",   #MOD-BB0287
        "   AND pmn011 !='SUB' ",
        " ORDER BY pmn33 "
    PREPARE q134_pb FROM l_sql
    DECLARE q134_bcs CURSOR FOR q134_pb
 
    CALL g_sr.clear()
    LET g_cnt = 1
    LET pmn20_t = 0
    LET pmn20_o = 0
    LET g_pmn55 = 0
    LET g_pmn58 = 0
    FOREACH q134_bcs INTO g_sr[g_cnt].*,g_factor,g_pmn55,g_pmn58
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_sr[g_cnt].on_order = g_sr[g_cnt].pmn20 - g_sr[g_cnt].on_order +
                                 # g_pmn55+g_pmn58
                                   g_pmn55   #No.+032在外量不含倉退010424 linda
        LET pmn20_t = pmn20_t + g_sr[g_cnt].pmn20   *g_factor
        LET pmn20_o = pmn20_o + g_sr[g_cnt].on_order*g_factor
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sr.deleteElement(g_cnt)        #TQC-C80095  
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY BY NAME pmn20_t,pmn20_o
END FUNCTION
 
 
FUNCTION q134_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-550005
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
#         LET l_ac = ARR_CURR()
#         LET l_sl = SCR_LINE()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q134_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
 
      ON ACTION previous
         CALL q134_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
 
      ON ACTION jump
         CALL q134_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
 
      ON ACTION next
         CALL q134_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
 
      ON ACTION last
         CALL q134_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-550037(smin)
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL q134_def_form()   #FUN-610006
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@      ON ACTION 收貨明細查詢
      ON ACTION qry_receipts_details
         LET g_action_choice="qry_receipts_details"
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
 
     #FUN-550037(smin)
     AFTER DISPLAY
       CONTINUE DISPLAY
     #END FUN-550037(smin)
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q134_detail()
DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(100)
 
    IF cl_null (g_sr[1].pmn01)  THEN
       CALL cl_err ('','apm-207',0)
       RETURN
    END IF
    IF INT_FLAG THEN RETURN END IF
     #-----No.MOD-480146-----
#   WHILE TRUE
#      CALL cl_getmsg('apm-208',g_lang) RETURNING g_msg
#      LET INT_FLAG = 0  ######add for prompt bug
#      PROMPT g_msg CLIPPED,':' FOR g_order
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
#
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
#
 #     ON ACTION controlg      #MOD-4C0121
 #        CALL cl_cmdask()     #MOD-4C0121
#
#
#      END PROMPT
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW q134_ww
#         RETURN
#      END IF
#      IF g_order >= 1 AND g_order <= 100  THEN
#         IF NOT cl_null(g_sr[g_order].pmn01)  THEN
#            EXIT WHILE
#         END IF
#      END IF
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW q134_ww
#         RETURN
#      END IF
#   END WHILE
    LET g_order = ARR_CURR()
    #-----END---------------
    LET l_sql = "apmq520 '",g_sr[g_order].pmn01,"' '",g_sr[g_order].pmn02,"'"
    CALL cl_cmdrun(l_sql)
    CLOSE WINDOW q134_ww
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q134_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
END FUNCTION
#-----END FUN-610006-----
