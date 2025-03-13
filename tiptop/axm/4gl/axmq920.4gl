# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq920.4gl
# Descriptions...: 貨運文件追?查詢作業
# Date & Author..: 04/06/16 By Mandy
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE
           g_oze   RECORD  #單頭
                     oze04 LIKE oze_file.oze04,
                     oze05 LIKE oze_file.oze05,
                     oze06 LIKE oze_file.oze06,
                     oze07 LIKE oze_file.oze07,
                     oze08 LIKE oze_file.oze08
                   END RECORD,
           g_oze_t RECORD
                     oze04 LIKE oze_file.oze04,
                     oze05 LIKE oze_file.oze05,
                     oze06 LIKE oze_file.oze06,
                     oze07 LIKE oze_file.oze07,
                     oze08 LIKE oze_file.oze08
                   END RECORD,
           g_yy,g_mm	   LIKE type_file.num5,                 #No.FUN-680137 	SMALLINT              
           g_ozf   DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables) 單身
                     ogb01     LIKE ogb_file.ogb01,
                     ogb04     LIKE ogb_file.ogb04,
                     ozf07     LIKE ozf_file.ozf07,
                     ozf04     LIKE ozf_file.ozf04,
                     ozf05     LIKE ozf_file.ozf05,
                     ozf09     LIKE ozf_file.ozf09
                   END RECORD,
           g_ozf_t RECORD
                     ogb01     LIKE ogb_file.ogb01,
                     ogb04     LIKE ogb_file.ogb04,
                     ozf07     LIKE ozf_file.ozf07,
                     ozf04     LIKE ozf_file.ozf04,
                     ozf05     LIKE ozf_file.ozf05,
                     ozf09     LIKE ozf_file.ozf09
                   END RECORD,
            g_wc           string,  #No.FUN-580092 HCN
            g_sql          string,  #No.FUN-580092 HCN
           g_t1            LIKE type_file.chr3,   #No.FUN-680137   VARCHAR(3)
           g_sw            LIKE type_file.chr1,   #No.FUN-680137   VARCHAR(1)
           g_buf           LIKE type_file.chr20,  #No.FUN-680137   VARCHAR(20)
           g_rec_b         LIKE type_file.num5,                #單身筆數               #No.FUN-680137 SMALLINT
           l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT    #No.FUN-680137 SMALLINT
           g_flag          LIKE type_file.chr1        #No.FUN-680137 VARCHAR(1)
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose          #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0094
      DEFINE  p_row,p_col     LIKE type_file.num5           #No.FUN-680137 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   LET g_oze.oze04  = ARG_VAL(1)
   LET g_oze.oze05  = ARG_VAL(2)
   LET g_oze.oze06  = ARG_VAL(3)
   LET g_oze.oze07  = ARG_VAL(4)
   LET g_oze.oze08  = ARG_VAL(5)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q920_w AT p_row,p_col WITH FORM "axm/42f/axmq920"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    LET g_flag = 'N'
    IF (NOT cl_null(g_oze.oze04) AND
        NOT cl_null(g_oze.oze05) AND
        NOT cl_null(g_oze.oze06) AND
        NOT cl_null(g_oze.oze07) AND
        NOT cl_null(g_oze.oze08)) THEN
         LET g_flag = 'Y'
         CALL q920_q()
    END IF
    CALL q920_menu()
    CLOSE WINDOW q920_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION q920_cs()
    DEFINE l_oze04    LIKE oze_file.oze04
    CLEAR FORM                             #清除畫面
    CALL g_ozf.clear()
    LET l_oze04 = NULL
    IF g_flag = 'N' THEN
        CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_oze.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           oze04,oze05,oze06,oze07,oze08
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        AFTER FIELD oze04
           LET l_oze04 = GET_FLDBUF(oze04)
        ON ACTION CONTROLP
            IF l_oze04 MATCHES '[OC]' THEN
                CASE
                    WHEN INFIELD(oze06) #運輸業者代碼
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form = "q_ozb" #海運
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oze06
                         NEXT FIELD oze06
                    OTHERWISE
                        EXIT CASE
                END CASE
            END IF
            IF l_oze04 = 'A' THEN
                CASE
                    WHEN INFIELD(oze06) #運輸業者代碼
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form = "q_oza" #航運
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oze06
                         NEXT FIELD oze06
                    OTHERWISE
                        EXIT CASE
                END CASE
            END IF
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
    END IF
{
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ozeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ozegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ozegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ozeuser', 'ozegrup')
    #End:FUN-980030
 
}
    IF INT_FLAG THEN RETURN END IF
    LET g_sql = "SELECT UNIQUE oze04,oze05,oze06,oze07,oze08 ",
                "  FROM oze_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY oze04,oze05,oze06,oze07,oze08 "
    PREPARE q920_prepare FROM g_sql
    DECLARE q920_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q920_prepare
 
    DROP TABLE x
    LET g_sql = "SELECT UNIQUE oze04,oze05,oze06,oze07,oze08 ",
                "  FROM oze_file ",
                " WHERE ", g_wc CLIPPED,
                "  INTO TEMP x "
    PREPARE q920_precount_x FROM g_sql
    EXECUTE q920_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE q920_precount FROM g_sql
    DECLARE q920_count CURSOR FOR q920_precount
END FUNCTION
 
FUNCTION q920_menu()
 
   WHILE TRUE
      CALL q920_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q920_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ozf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q920_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q920_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_oze.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q920_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oze.* TO NULL
    ELSE
        OPEN q920_count
        FETCH q920_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q920_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q920_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q920_cs INTO g_oze.oze04,g_oze.oze05,g_oze.oze06,g_oze.oze07,g_oze.oze08
        WHEN 'P' FETCH PREVIOUS q920_cs INTO g_oze.oze04,g_oze.oze05,g_oze.oze06,g_oze.oze07,g_oze.oze08
        WHEN 'F' FETCH FIRST    q920_cs INTO g_oze.oze04,g_oze.oze05,g_oze.oze06,g_oze.oze07,g_oze.oze08
        WHEN 'L' FETCH LAST     q920_cs INTO g_oze.oze04,g_oze.oze05,g_oze.oze06,g_oze.oze07,g_oze.oze08
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q920_cs INTO g_oze.oze04,g_oze.oze05,g_oze.oze06,g_oze.oze07,g_oze.oze08
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oze.* TO NULL  #TQC-6B0105
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
 
#   SELECT oze04,oze05,oze06,oze07,oze08 INTO g_oze.*
#     FROM oze_file
#    WHERE oze04 = g_oze.oze04
#      AND oze05 = g_oze.oze05
#      AND oze06 = g_oze.oze06
#      AND oze07 = g_oze.oze07
#      AND oze08 = g_oze.oze08
#   IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)
#       INITIALIZE g_oze.* TO NULL
#       RETURN
#   END IF
 
    CALL q920_show()
END FUNCTION
 
FUNCTION q920_show()
    LET g_oze_t.* = g_oze.*                #保存單頭舊值
    DISPLAY BY NAME g_oze.oze04,g_oze.oze05,g_oze.oze06,g_oze.oze07,g_oze.oze08
 
    CALL q920_b_fill()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q920_b_fill()              #BODY FILL UP
    LET g_sql =
        "SELECT ogb01,ogb04,ozf07,ozf04,ozf05,ozf09 ",
        " FROM ogb_file,oze_file,ozf_file ",
        " WHERE oze04 ='",g_oze.oze04,"'",  #單頭
        "   AND oze05 ='",g_oze.oze05,"'",  #單頭
        "   AND oze06 ='",g_oze.oze06,"'",  #單頭
        "   AND oze07 ='",g_oze.oze07,"'",  #單頭
        "   AND oze08 ='",g_oze.oze08,"'",  #單頭
        "   AND ",g_wc CLIPPED,                     #單身
        "   AND ogb01 = oze01 ",
        "   AND ogb03 = oze02 ",
        "   AND ozf_file.ozf01 = oze04 ",
        "   AND ozf_file.ozf02 = oze05 ",
        "   AND ozf_file.ozf03 = oze06 ",
        "   AND ozf_file.ozf04 = oze07 ",
        "   AND ozf_file.ozf05 = oze08 ",
        " ORDER BY ogb01,ogb04 "
{
    LET g_sql =
        "SELECT ogb01,ogb04,ozf07,ozf04,ozf05,ozf09 ",
        " FROM oze_file,OUTER ozf_file,OUTER ogb_file ",
        " WHERE oze04 ='",g_oze.oze04,"'",  #單頭
        "   AND oze05 ='",g_oze.oze05,"'",  #單頭
        "   AND oze06 ='",g_oze.oze06,"'",  #單頭
        "   AND oze07 ='",g_oze.oze07,"'",  #單頭
        "   AND oze08 ='",g_oze.oze08,"'",  #單頭
        "   AND oze01 = ogb_file.ogb01 ",
        "   AND oze02 = ogb_file.ogb03 ",
        "   AND ozf_file.ozf01 = oze04 ",
        "   AND ozf_file.ozf02 = oze05 ",
        "   AND ozf_file.ozf03 = oze06 ",
        "   AND ozf_file.ozf04 = oze07 ",
        "   AND ozf_file.ozf05 = oze08 ",
        "   AND ",g_wc CLIPPED,                     #單身
        " ORDER BY ogb01,ogb04 "
}
 
    PREPARE q920_pb FROM g_sql
    DECLARE ozf_curs CURSOR FOR q920_pb
 
    CALL g_ozf.clear()
    LET g_cnt = 1
    FOREACH ozf_curs INTO g_ozf[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ozf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q920_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ozf TO s_ozf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q920_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q920_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q920_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q920_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q920_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
      ON ACTION exporttoexcel       #FUN-4B0038
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
#Patch....NO.TQC-610037 <001,002> #
