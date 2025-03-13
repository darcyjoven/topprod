# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdq202.4gl
# Descriptions...: 撥出單已派車狀況查詢
# Date & Author..: 04/01/14 By Hawk
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
#
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    tm     RECORD
                wc  	LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(500)
           END RECORD,
    g_adf  RECORD
               adf01    LIKE adf_file.adf01,
               adg02    LIKE adg_file.adg02,
               adf02	LIKE adf_file.adf02,
               adg05 	LIKE adg_file.adg05,
               ima02    LIKE ima_file.ima02,
               adg09    LIKE adg_file.adg09,
               adg10	LIKE adg_file.adg10,
               adg11    LIKE adg_file.adg11,
               adg12    LIKE adg_file.adg12
           END RECORD,
    g_adl  DYNAMIC ARRAY OF RECORD
               r        LIKE type_file.num5,   #No.FUN-680108 SMALLINT
               adl01    LIKE adl_file.adl01,
               adl02    LIKE adl_file.adl02,
               adk08    LIKE adk_file.adk08,
               adk04    LIKE adk_file.adk04,
               adk05    LIKE adk_file.adk05,
               adl07    LIKE adl_file.adl07,
               adl08    LIKE adl_file.adl08,
               adl05    LIKE adl_file.adl05
           END RECORD,
    g_adg_rowid     LIKE type_file.chr18,      #No.FUN-680108 INT
    g_sql           string,                    #No:FUN-580092 HCN
    g_wc2           string,                    #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #No.FUN-680108 SMALLINT
    g_adl05_t       LIKE adl_file.adl05        #MOD-4B0067 
DEFINE   g_cnt      LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_msg      LIKE type_file.chr1000,    #No.FUN-680108 VARCHAR(72)
         l_ac       LIKE type_file.num5        #No.FUN-680108 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680108 INTEGER
 
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680108 SMALLINT    #No.FUN-6A0078

MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0091
      DEFINE    p_row,p_col	LIKE type_file.num5    #No.FUN-680108 SMALLINT

    OPTIONS
        FORM LINE       FIRST + 2,
        MESSAGE LINE    LAST,
        PROMPT LINE     LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
     CALL  cl_used(g_prog,g_time,1)      #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
      LET p_row = 3 LET p_col = 2
    OPEN WINDOW axdq202_w AT p_row,p_col
        WITH FORM "axd/42f/axdq202"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()


 
#    IF cl_chk_act_auth() THEN
#       CALL q202_q()
#    END IF
   CALL q202_menu()    #中文
   CLOSE WINDOW axdq202_w
      CALL  cl_used(g_prog,g_time,2)        #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION q202_cs()
    DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01    #No:FUN-580031  HCN
    DEFINE  l_cnt           LIKE type_file.num5    #No.FUN-680108 SMALLINT

    CALL g_adl.clear()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_adf.* TO NULL    #No.FUN-750051
    CONSTRUCT  BY NAME tm.wc ON adf01,adg02,adf02,adg05,adg09,adg10

      BEFORE CONSTRUCT
         CALL cl_qbe_init()                     #No:FUN-580031

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      #No:FUN-580031 --start--
      ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    IF g_priv2='4' THEN
       LET tm.wc = tm.wc CLIPPED," AND adfuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN
       LET tm.wc = tm.wc CLIPPED," AND adfgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET tm.wc = tm.wc CLIPPED," AND adfgrup IN ",cl_chk_tgrup_list()
    END IF

    CONSTRUCT g_wc2 ON adl01,adk08,adk04,adk05,adl07,adl08
         FROM s_sr[1].adl01,s_sr[1].adk08,s_sr[1].adk04,
              s_sr[1].adk05,s_sr[1].adl07,s_sr[1].adl08

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No:FUN-580031 --start--
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No:FUN-580031 ---end---
 
    END CONSTRUCT

    MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
    IF g_wc2 = ' 1=1' THEN
        LET g_sql = " SELECT UNIQUE adg_file.ROWID,adf01,adg02 ",
                    " FROM adg_file,adf_file,OUTER ima_file",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND adf01 = adg01 ",
                    "   AND ima_file.ima01 = adg05 ",
                    "   AND adf10 = '1' AND adfacti = 'Y'",
                    " ORDER BY adf01,adg02 "
    ELSE
        LET g_sql = " SELECT UNIQUE adg_file.ROWID,adf01,adg02 ",
                    " FROM adg_file,adf_file ",
                    "     ,adl_file,adk_file,OUTER ima_file",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED,
                    "   AND adf01 = adg01 ",
                    "   AND adl01 = adk01 ",
                    "   AND adg01 = adl03 ",
                    "   AND adg02 = adl04 ",
                    "   AND ima_file.ima01 = adg05 ",
                    "   AND adf10 = '1' AND adfacti = 'Y'",
                    "   AND adkconf = 'Y'",
                    " ORDER BY adf01,adg02 "
    END IF
    PREPARE q202_prepare FROM g_sql
    DECLARE q202_cs
        SCROLL CURSOR FOR q202_prepare

    IF g_wc2 = ' 1=1' THEN
        LET g_sql = " SELECT adg01,adg02 ",
                    " FROM adg_file,adf_file,OUTER ima_file ",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND adf01 = adg01 ",
                    "   AND ima_file.ima01 = adg05 ",
                    "   AND adf10 = '1' AND adfacti = 'Y'",
                    "  INTO TEMP x"
    ELSE
        LET g_sql = " SELECT adg01,adg02 ",
                    " FROM adg_file,adf_file ",
                    "     ,adk_file,adl_file ,OUTER ima_file",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED,
                    "   AND adf01 = adg01 ",
                    "   AND adl01 = adk01 ",
                    "   AND adl03 = adg01 ",
                    "   AND adl04 = adg02 ",
                    "   AND ima_file.ima01 = adg05 ",
                    "   AND adf10 = '1' AND adfacti = 'Y'",
                    "   AND adkconf = 'Y'",
                    "  INTO TEMP x"
    END IF
    DROP  TABLE x
    PREPARE q202_precount_x FROM g_sql
    EXECUTE q202_precount_x
       LET g_sql = "SELECT COUNT(*) FROM x"	
    PREPARE q202_pp  FROM g_sql
    DECLARE q202_cnt  CURSOR FOR q202_pp
--## 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN q202_cnt
   FETCH q202_cnt INTO g_row_count
   CLOSE q202_cnt
END FUNCTION

#中文的MENU
FUNCTION q202_menu()
   WHILE TRUE
      CALL q202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q202_q()
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


FUNCTION q202_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q202_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
--mi
    OPEN q202_cnt
    FETCH q202_cnt INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
--#
    OPEN q202_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q202_fetch('F')
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION q202_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
    l_abso          LIKE type_file.num10         #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     q202_cs INTO g_adg_rowid,g_adf.adf01,g_adf.adg02
        WHEN 'P' FETCH PREVIOUS q202_cs INTO g_adg_rowid,g_adf.adf01,g_adf.adg02
        WHEN 'F' FETCH FIRST    q202_cs INTO g_adg_rowid,g_adf.adf01,g_adf.adg02
        WHEN 'L' FETCH LAST     q202_cs INTO g_adg_rowid,g_adf.adf01,g_adf.adg02
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
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
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
             END IF

             FETCH ABSOLUTE g_jump q202_cs INTO g_adg_rowid,
                                                g_adf.adf01,g_adf.adg02
            LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        INITIALIZE g_adf.* TO NULL  #TQC-6B0105
        LET g_adg_rowid = NULL      #TQC-6B0105
        RETURN
    END IF
    SELECT adf01,adf02,adg02,adg05,adg09,adg10,adg11,adg12,ima02
	INTO g_adf.adf01,g_adf.adf02,g_adf.adg02,
             g_adf.adg05,g_adf.adg09,g_adf.adg10,
             g_adf.adg11,g_adf.adg12,g_adf.ima02
	FROM adg_file,adf_file,OUTER ima_file
        WHERE adf01 = adg01
          AND ima_file.ima01 = adg05
	  AND adg_file.ROWID = g_adg_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
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
    CALL q202_show()
END FUNCTION

FUNCTION q202_show()
    DISPLAY BY NAME g_adf.*
    CALL q202_b_fill()
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION q202_b_fill()
    DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

    LET l_sql = " SELECT '',adl01,adl02,adk08,adk04,adk05,adl07,adl08,adl05 ",
                "   FROM adl_file,adk_file",
                "  WHERE adl03 = '",g_adf.adf01,"'",
                "    AND adl04 = '",g_adf.adg02,"'",
                "    AND adl01 = adk01 ",
                "    AND adkconf = 'Y'",
                "    AND ",g_wc2 CLIPPED,
                " ORDER BY adl01,adl02 "
    PREPARE q202_pb FROM l_sql
    DECLARE q202_bcs
        CURSOR FOR q202_pb

  LET g_cnt = 1
    LET g_adl05_t = 0
    FOREACH q202_bcs INTO g_adl[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_adl05_t = g_adl05_t+g_adl[g_cnt].adl05
        LET g_adl[g_cnt].r = g_cnt
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_adl.deleteElement(g_cnt)
    CALL SET_COUNT(g_cnt-1)
END FUNCTION

FUNCTION q202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adl TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION previous
         CALL q202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION jump
         CALL q202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION next
         CALL q202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION last
         CALL q202_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


