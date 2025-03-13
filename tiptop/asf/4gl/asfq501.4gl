# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfq501.4gl
# Descriptions...: 工單挪料明細查詢
# Date & Author..: 03/03/10 By Snow
# Modify.........: 03/03/27 By Mandy
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0130 09/10/26 By liuxqa 修改ROWID.
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1	LIKE sfn_file.sfn01     # 所要查詢的key
  DEFINE g_wc,g_wc2	string             	# WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql		string  #No.FUN-580092 HCN
  DEFINE g_sfn01        LIKE sfn_file.sfn01
  DEFINE g_sfm10        LIKE sfm_file.sfm10
  DEFINE g_type         LIKE ima_file.ima34          #No.FUN-680121 VARCHAR(08)
  DEFINE g_desc         LIKE gem_file.gem01          #No.FUN-680121 VARCHAR(06)
  DEFINE g_sfn DYNAMIC ARRAY OF RECORD
			sfn02	LIKE sfn_file.sfn02,
			sfn03	LIKE sfn_file.sfn03,
  			sfn04 	LIKE sfn_file.sfn04,
  			sfn06 	LIKE sfn_file.sfn06,
  			sfn07 	LIKE sfn_file.sfn07,
  			sfn08	LIKE sfn_file.sfn08,
  			sfn15 	LIKE sfn_file.sfn15,
  			sfn12 	LIKE sfn_file.sfn12,
  			sfn13 	LIKE sfn_file.sfn13,
                        sfn14   LIKE sfn_file.sfn14,
                        sfn10   LIKE sfn_file.sfn10,
                        sfn11   LIKE sfn_file.sfn11,
                        sfn05   LIKE sfn_file.sfn05
            		END RECORD
  DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680121 SMALLINT
  DEFINE g_rec_b        LIKE type_file.num5          #單身筆數        #No.FUN-680121 SMALLINT
  DEFINE g_za05           LIKE type_file.chr1000     #No.FUN-680121 VARCHAR(40)
  DEFINE   l_ac           LIKE type_file.num5        #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5         #No.FUN-680121 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
     LET g_argv1 = ARG_VAL(1)
 
    OPEN WINDOW q501_w AT p_row,p_col
         WITH FORM "/asf/42f/asfq501"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
 
   # IF cl_chk_act_auth() THEN
   #    CALL q501_q()
   # END IF
    IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
    CALL q501_menu()
    CLOSE WINDOW q501_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION q501_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   IF g_argv1 != ' ' THEN
      LET g_wc = "sfn01 = '",g_argv1,"'"
      LET g_wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
   CALL g_sfn.clear()
 
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfn01 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc  ON sfn01
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
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON sfn02,sfn03,sfn04,sfn06,sfn07,sfn08,sfn15,
                         sfn12,sfn13,sfn14,sfn10,sfn11,sfn05
                    FROM s_sfn[1].sfn02,s_sfn[1].sfn03,s_sfn[1].sfn04,
                         s_sfn[1].sfn06,s_sfn[1].sfn07,s_sfn[1].sfn08,
                         s_sfn[1].sfn15,s_sfn[1].sfn12,s_sfn[1].sfn13,
                         s_sfn[1].sfn14,s_sfn[1].sfn10,s_sfn[1].sfn11,
                         s_sfn[1].sfn05
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
      END CONSTRUCT
 # 螢幕上取單頭條件
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT DISTINCT sfn01 FROM sfn_file ",
             "  WHERE ",g_wc  CLIPPED,
             "    AND ",g_wc2 CLIPPED
 
{
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND sfnuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND sfngrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND sfngrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('sfnuser', 'sfngrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY sfn01"
}
   PREPARE q501_prepare FROM g_sql
   DECLARE q501_cs SCROLL CURSOR FOR q501_prepare
 
   LET g_sql=" SELECT  COUNT(DISTINCT sfn01) FROM sfn_file ",
             "  WHERE ",g_wc2 CLIPPED,
             "    AND ",g_wc CLIPPED
{
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND sfnuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND sfngrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND sfngrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
}
   PREPARE q501_pp  FROM g_sql
   DECLARE q501_count   CURSOR FOR q501_pp
END FUNCTION
 
FUNCTION q501_b_askkey()
    CONSTRUCT g_wc2 ON sfn02,sfn03,sfn04,sfn06,sfn07,sfn08,sfn15,
                       sfn12,sfn13,sfn14,sfn10,sfn11,sfn05
                  FROM s_sfn[1].sfn02,s_sfn[1].sfn03,s_sfn[1].sfn04,
                       s_sfn[1].sfn06,s_sfn[1].sfn07,s_sfn[1].sfn08,
                       s_sfn[1].sfn15,s_sfn[1].sfn12,s_sfn[1].sfn13,
                       s_sfn[1].sfn14,s_sfn[1].sfn10,s_sfn[1].sfn11,
                       s_sfn[1].sfn05
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
    END CONSTRUCT
 # 螢幕上取單頭條件
    IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
FUNCTION q501_menu()
 
   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q501_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfn),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q501_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q501_count
       FETCH q501_count INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q501_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q501_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q501_cs INTO g_sfn01
        WHEN 'P' FETCH PREVIOUS q501_cs INTO g_sfn01
        WHEN 'F' FETCH FIRST    q501_cs INTO g_sfn01
        WHEN 'L' FETCH LAST     q501_cs INTO g_sfn01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q501_cs INTO g_sfn01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfn01,SQLCA.sqlcode,0)
        INITIALIZE g_sfn01 TO NULL  #TQC-6B0105
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
 
    CALL q501_show()
END FUNCTION
 
FUNCTION q501_show()
   SELECT sfm10 INTO g_sfm10 FROM sfm_file WHERE sfm00=g_sfn01
   CASE g_sfm10
     WHEN '1' LET g_type=g_x[1] CLIPPED #'整批挪料'
     WHEN '2' LET g_type=g_x[2] CLIPPED #'單料挪料'
   END CASE
 
   DISPLAY g_sfn01,g_sfm10,g_type TO sfn01,sfm10,type
{
   DISPLAY g_sfn.sfn02,g_sfn.sfn03,g_sfn.sfn04,g_sfn.sfn06,g_sfn.sfn07,
           g_sfn.sfn08,g_sfn.sfn10,g_sfn.sfn11,g_sfn.sfn05,
           g_sfn.desc
        TO sfn02, sfn03, sfn04, sfn06, sfn07, sfn08, sfn10, sfn11, sfn05, desc
   DISPLAY g_desc TO desc
}
   CALL q501_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q501_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
    LET l_sql =
       "SELECT sfn02,sfn03,sfn04,sfn06,sfn07,sfn08,sfn15,",
       "       sfn12,sfn13,sfn14,sfn10,sfn11,sfn05 ",
       "  FROM sfn_file",
       " WHERE sfn01 = '",g_sfn01,"'",
       "   AND ", g_wc2 CLIPPED,
       " ORDER BY sfn02" CLIPPED
    PREPARE q501_pb FROM l_sql
    DECLARE q501_bcs CURSOR FOR q501_pb
    DISPLAY l_sql
 
    FOR g_cnt = 1 TO g_sfn.getLength()            #單身 ARRAY乾洗
         INITIALIZE g_sfn[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q501_bcs INTO g_sfn[g_cnt].*
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_sfn TO s_sfn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q501_fetch('L')
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
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
##
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
