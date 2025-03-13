# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimq131.4gl
# Descriptions...: OM  銷單未交明細查詢
# Date & Author..: 93/05/19 By Roger
#                  By Melody    1.l_sql 改抓 oea_file、oeb_file 檔案
#                               2.合計考慮單位換算 (oeb05_fac)
# Modify.........: No.MOD-480149 04/08/11 By Nicola 單身不會即時更新
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740135 07/04/19 By arman 當用指定比筆跳至第一筆時，“上一筆、第一筆”按紐仍存在；用指定筆跳至最后一筆，“下一筆、末一筆”仍存在;
# Modify.........: No.MOD-870308 08/07/29 By claire 單身應排除未確認的訂單
# Modify.........: No.MOD-880224 08/09/03 By Pengu 抓取受定量的SQL條件應該與aimq102一致
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C70273 12/07/27 By ck2yuan 將最後一行空白刪除
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1	LIKE ima_file.ima01    # 所要查詢的key
  DEFINE g_wc,g_wc2	string                 # WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql		string                 #No.FUN-580092 HCN
  DEFINE g_rec_b	LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE g_ima          RECORD
			ima01	LIKE ima_file.ima01,
  			ima02	LIKE ima_file.ima02,
  			ima021	LIKE ima_file.ima021,
  			ima08	LIKE ima_file.ima08
            		END RECORD
  DEFINE g_sr           DYNAMIC ARRAY OF RECORD
            		oeb01   LIKE oeb_file.oeb01,
            		oeb03   LIKE oeb_file.oeb03,
            		oea03   LIKE oea_file.oea03,
            		occ02   LIKE occ_file.occ02,
            		oeb15   LIKE oeb_file.oeb15,
            		oeb12   LIKE oeb_file.oeb12,
                        #FUN-570175  --begin
            		oeb913  LIKE oeb_file.oeb913,
            		oeb915  LIKE oeb_file.oeb915,
            		oeb910  LIKE oeb_file.oeb910,
            		oeb912  LIKE oeb_file.oeb912,
                        #FUN-570175  --end
            		on_order LIKE oeb_file.oeb12,
            		oeb05    LIKE oeb_file.oeb05
            		END RECORD
DEFINE g_factor         LIKE oeb_file.oeb05_fac
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0074
 
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
    LET p_row = 4 LET p_col = 4
 
    OPEN WINDOW q201_w AT p_row,p_col
         WITH FORM "aim/42f/aimq131"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----FUN-610006---------
    CALL q131_def_form()
#   #FUN-570175 --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
#   END IF
#   #FUN-570175 --end
    #-----END FUN-610006-----
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q201_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q201_q() END IF
    CALL q201_menu()
    CLOSE WINDOW q201_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION q201_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
           LET g_wc2=" 1=1 "
      ELSE CLEAR FORM                                   #清除畫面
   CALL g_sr.clear()
           CALL cl_opmsg('q')                           # 螢幕上取單頭條件
           INITIALIZE g_ima.* TO NULL  #FUN-640213 add
           
CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
           CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021
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
   PREPARE q201_prepare FROM g_sql
   DECLARE q201_cs SCROLL CURSOR FOR q201_prepare
 
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
 
   PREPARE q201_pp  FROM g_sql
   DECLARE q201_cnt   CURSOR FOR q201_pp
END FUNCTION
 
FUNCTION q201_b_askkey()
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
 
FUNCTION q201_menu()
 
   WHILE TRUE
      CALL q201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q201_q()
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
 
FUNCTION q201_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q201_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q201_cnt
       FETCH q201_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q201_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q201_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q201_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q201_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q201_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q201_cs INTO g_ima.ima01
        WHEN '/'
#NO.TQC-740135  ---Begin
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
            FETCH ABSOLUTE g_jump q201_cs INTO g_ima.ima01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
#NO.TQC-740135         ----End
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
 
    CALL q201_show()
END FUNCTION
 
FUNCTION q201_show()
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08
 
   CALL q201_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q201_b_fill()              #BODY FILL UP
   DEFINE l_sql             LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE oeb12_t,oeb12_o   LIKE oeb_file.oeb12
 
   LET l_sql =
      #"SELECT oeb01,oeb03,oea03,occ02,oeb15,oeb12,oeb12-oeb24,oeb05,oeb05_fac",
      #FUN-570175  --begin
       "SELECT oeb01,oeb03,oea03,occ02,oeb15,oeb12,oeb913,oeb915,oeb910,oeb912,",
       "       oeb12-oeb24+oeb25-oeb26,oeb05,oeb05_fac", #BugNo:5723 
      #FUN-570175  --end
       "  FROM oeb_file, oea_file, occ_file",
       " WHERE oeb04 = '",g_ima.ima01,"' AND ", g_wc2 CLIPPED,
#      "   AND oeb01 = oea01 AND oea03 = occ01 AND oea00='1' ",
       "   AND oeb01 = oea01 AND oea03 = occ01 AND oea00<>'0' ",
      #---------------No.MOD-880224 modify
      #"   AND oeb70 = 'N' AND oeb12 > oeb24",
       "   AND oeb70 = 'N' ",
       "   AND oeb12-oeb24+oeb25-oeb26>0 ", 
      #---------------No.MOD-880224 end
      #"   AND oeaconf != 'X' ", #01/08/07 mandy  #MOD-870308 mark
       "   AND oeaconf  = 'Y' ", #MOD-870308
       " ORDER BY oeb15 "     
    PREPARE q201_pb FROM l_sql
    DECLARE q201_bcs CURSOR FOR q201_pb
 
    FOR g_cnt = 1 TO g_sr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sr[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b = 0
    LET oeb12_t = 0
    LET oeb12_o = 0
    FOREACH q201_bcs INTO g_sr[g_cnt].*,g_factor
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET oeb12_t = oeb12_t + g_sr[g_cnt].oeb12   *g_factor    # 96-07-22
        LET oeb12_o = oeb12_o + g_sr[g_cnt].on_order*g_factor    # 96-07-22
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
    CALL g_sr.deleteElement(g_cnt)     #MOD-C70273 add
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY BY NAME oeb12_t,oeb12_o
END FUNCTION
 
FUNCTION q201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480149
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
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
         CALL q201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q201_fetch('L')
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
         CALL q131_def_form()   #FUN-610006
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530688  --end
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q131_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
    END IF
END FUNCTION
#-----END FUN-610006-----
