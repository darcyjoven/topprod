# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axmq910.4gl
# Descriptions...: 出貨單追蹤查詢作業
# Date & Author..: 04/06/03 By Mandy
 # Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
 # Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980010 09/08/27 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE
           g_ogb   RECORD
                     ogb01 LIKE ogb_file.ogb01,
                     ogb03 LIKE ogb_file.ogb03,
                     ogb04 LIKE ogb_file.ogb04,
                     ogb05 LIKE ogb_file.ogb05,
                     ogb12 LIKE ogb_file.ogb12,
                     oga02 LIKE oga_file.oga02,
                     oga03 LIKE oga_file.oga03,
                     oga04 LIKE oga_file.oga04,
                     oga14 LIKE oga_file.oga14,
                     oga43 LIKE oga_file.oga43
                   END RECORD,
           g_ogb_t RECORD
                     ogb01 LIKE ogb_file.ogb01,
                     ogb03 LIKE ogb_file.ogb03,
                     ogb04 LIKE ogb_file.ogb04,
                     ogb05 LIKE ogb_file.ogb05,
                     ogb12 LIKE ogb_file.ogb12,
                     oga02 LIKE oga_file.oga02,
                     oga03 LIKE oga_file.oga03,
                     oga04 LIKE oga_file.oga04,
                     oga14 LIKE oga_file.oga14,
                     oga43 LIKE oga_file.oga43
                   END RECORD,
           g_yy,g_mm	   LIKE type_file.num5,                 #No.FUN-680137 SMALLINT
           b_oze   RECORD LIKE oze_file.*,
           g_oze   DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                     oze03     LIKE oze_file.oze03,
                     ozf07     LIKE ozf_file.ozf07,
                     ozf08     LIKE ozf_file.ozf08,
                     ozf09     LIKE ozf_file.ozf09
                   END RECORD,
           g_oze_t RECORD
                     oze03     LIKE oze_file.oze03,
                     ozf07     LIKE ozf_file.ozf07,
                     ozf08     LIKE ozf_file.ozf08,
                     ozf09     LIKE ozf_file.ozf09
                   END RECORD,
            g_wc           STRING,  #No.FUN-580092 HCN 
            g_sql          STRING,  #No.FUN-580092 HCN 
           g_t1            LIKE type_file.chr3,          #No.FUN-680137  VARCHAR(3)  
           g_sw            LIKE type_file.chr1,          #No.FUN-680137  VARCHAR(1)  
           g_buf           LIKE type_file.chr20,         #No.FUN-680137  VARCHAR(20)
           g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680137 SMALLINT
           l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
           g_flag          LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1) 
DEFINE g_forupd_sql      STRING  #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
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
 
   LET g_ogb.ogb01  = ARG_VAL(1)
   LET g_ogb.ogb03  = ARG_VAL(2)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q910_w AT p_row,p_col WITH FORM "axm/42f/axmq910"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    LET g_flag = 'N'
    IF NOT cl_null(g_ogb.ogb01) AND NOT cl_null(g_ogb.ogb03) THEN
        LET g_flag = 'Y'
            CALL q910_q()
#           CALL q910_b()
    END IF
    CALL q910_menu()
    CLOSE WINDOW q910_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION q910_cs()
    CLEAR FORM                             #清除畫面
    CALL g_oze.clear()
    IF g_flag = 'N' THEN
        CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ogb.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
            oga02,ogb01,ogb03,ogb05,oga03,oga04,ogb04,ogb12,oga43,oga14
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(ogb01) #查詢出貨單oga09 IN('2','3','4','6')
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oga6"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb01
                   NEXT FIELD ogb01
              WHEN INFIELD(oga03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga03
                   NEXT FIELD oga03
              WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga04
                   NEXT FIELD oga04
              WHEN INFIELD(ogb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb04
                   NEXT FIELD ogb04
              WHEN INFIELD(ogb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb05
                   NEXT FIELD ogb05
              WHEN INFIELD(oga14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga14
                   NEXT FIELD oga14
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        IF INT_FLAG THEN RETURN END IF
    ELSE
        LET g_wc = "     ogb01 ='",g_ogb.ogb01,"'",
                   " AND ogb03 = ",g_ogb.ogb03
    END IF
    LET g_wc = g_wc CLIPPED," AND oga09 IN ('2','3','4','6') ", #No.FUN-610020
                            " AND ogaconf = 'Y'" CLIPPED
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ogbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ogbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ogbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogbuser', 'ogbgrup')
    #End:FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql = "SELECT oga02,oga03,ogb01,ogb03 ",
                "  FROM oga_file,ogb_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND oga01 = ogb01 ",
                " ORDER BY oga02,oga03,ogb01,ogb03 "
    PREPARE q910_prepare FROM g_sql
    DECLARE q910_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q910_prepare
 
    DROP TABLE x
    LET g_sql = "SELECT ogb01,ogb03 ",
                "  FROM oga_file,ogb_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND oga01 = ogb01 ",
                "  INTO TEMP x "
    PREPARE q910_precount_x FROM g_sql
    EXECUTE q910_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE q910_precount FROM g_sql
    DECLARE q910_count CURSOR FOR q910_precount
END FUNCTION
 
FUNCTION q910_menu()
 
   WHILE TRUE
      CALL q910_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q910_q()
            END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL q910_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oze),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q910_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q910_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_ogb.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q910_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ogb.* TO NULL
    ELSE
        OPEN q910_count
        FETCH q910_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q910_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q910_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q910_cs INTO g_ogb.oga02,g_ogb.oga03,g_ogb.ogb01,g_ogb.ogb03
        WHEN 'P' FETCH PREVIOUS q910_cs INTO g_ogb.oga02,g_ogb.oga03,g_ogb.ogb01,g_ogb.ogb03
        WHEN 'F' FETCH FIRST    q910_cs INTO g_ogb.oga02,g_ogb.oga03,g_ogb.ogb01,g_ogb.ogb03
        WHEN 'L' FETCH LAST     q910_cs INTO g_ogb.oga02,g_ogb.oga03,g_ogb.ogb01,g_ogb.ogb03
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
            FETCH ABSOLUTE g_jump q910_cs INTO g_ogb.oga02,g_ogb.oga03,g_ogb.ogb01,g_ogb.ogb03
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ogb.ogb01,SQLCA.sqlcode,0)
        INITIALIZE g_ogb.* TO NULL  #TQC-6B0105
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
 
    SELECT ogb01,ogb03,ogb04,ogb05,ogb12,oga02,oga03,oga04,oga14,oga43 INTO g_ogb.*
      FROM oga_file,ogb_file
     WHERE ogb01 = g_ogb.ogb01 AND ogb03 = g_ogb.ogb03
       AND oga01 = ogb01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ogb.ogb01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","oga_file,ogb_file",g_ogb.ogb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        INITIALIZE g_ogb.* TO NULL
        RETURN
    END IF
 
    CALL q910_show()
END FUNCTION
 
FUNCTION q910_show()
    LET g_ogb_t.* = g_ogb.*                #保存單頭舊值
    DISPLAY BY NAME g_ogb.ogb01,g_ogb.ogb03,g_ogb.ogb04,g_ogb.ogb05,g_ogb.ogb12,
                    g_ogb.oga02,g_ogb.oga03,g_ogb.oga04,g_ogb.oga14,g_ogb.oga43
 
    CALL q910_b_fill()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q910_b_fill()              #BODY FILL UP
  DEFINE l_ozf11  LIKE ozf_file.ozf11
 
    LET g_sql =
        "SELECT oze03,ozf07,ozf08,ozf09,ozf11 ",
        " FROM oze_file,oga_file,ogb_file,ozf_file ",
        " WHERE oze01 ='",g_ogb.ogb01,"'",  #單頭
        "   AND oze02 = ",g_ogb.ogb03,
        "   AND ",g_wc CLIPPED,                     #單身
        "   AND oga01 = ogb01 ",
        "   AND ogb01 = oze01 ",
        "   AND ogb03 = oze02 ",
        "   AND ozf01 = oze04 ",
        "   AND ozf02 = oze05 ",
        "   AND ozf03 = oze06 ",
        "   AND ozf04 = oze07 ",
        "   AND ozf05 = oze08 ",
        " ORDER BY ozf11 "
 
    PREPARE q910_pb FROM g_sql
    DECLARE oze_curs CURSOR FOR q910_pb
 
    CALL g_oze.clear()
    LET g_cnt = 1
    FOREACH oze_curs INTO g_oze[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oze.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q910_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oze TO s_oze.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q910_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q910_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q910_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q910_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q910_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
 
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
 
      ON ACTION accept
         LET g_action_choice="detail"
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
{
#單身
FUNCTION q910_b()
DEFINE
    l_za05          LIKE type_file.chr1000,             #                    #No.FUN-680137 VARCHAR(40)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用          #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否         #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態           #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01)  #可新增否
    l_allow_delete  LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)               #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ogb.ogb01) OR cl_null(g_ogb.ogb03) THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT ogb01,ogb03,ogb04,ogb05,ogb12,oga02,oga03,oga04,oga14,oga43 INTO g_ogb.*
      FROM oga_file,ogb_file
     WHERE ogb01 = g_ogb.ogb01 AND ogb03 = g_ogb.ogb03
       AND oga01 = ogb01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ogb.ogb01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","oga_file,ogb_file",g_ogb.ogb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        INITIALIZE g_ogb.* TO NULL
        RETURN
    END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT oze03,oze04,oze05,oze06,oze07,oze08 ",
                       "  FROM oze_file ",
                       "   WHERE oze01 = ?  ",
                       "   AND oze02 = ? ",
                       "   AND oze03 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q910_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_oze WITHOUT DEFAULTS FROM s_oze.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_oze_t.* = g_oze[l_ac].*  #BACKUP
                OPEN q910_bcl USING g_ogb.ogb01,g_ogb.ogb03,g_oze_t.oze03
                IF STATUS THEN
                   CALL cl_err("OPEN q910_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH q910_bcl INTO g_oze[l_ac].*
                   IF SQLCA.sqlcode THEN
                     #CALL cl_err(g_oze_t.oze03,SQLCA.sqlcode,1)
                      CALL cl_err("FETCH q910_bcl",SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_oze[l_ac].* TO NULL      #900423
            LET g_oze_t.* = g_oze[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oze03
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_oze[l_ac].oze07) THEN LET g_oze[l_ac].oze07 = '' END IF
           IF cl_null(g_oze[l_ac].oze08) THEN LET g_oze[l_ac].oze08 = '' END IF
           INSERT INTO oze_file(oze01,oze02,oze03,oze04,oze05,oze06,oze07,
                                 oze08,oze09,oze10,oze11,ozeplant,ozelegal)  #No.MOD-470041    #FUN-980010 add
                         VALUES(g_ogb.ogb01,g_ogb.ogb03,g_oze[l_ac].oze03,
                                g_oze[l_ac].oze04,g_oze[l_ac].oze05,g_oze[l_ac].oze06,
                                g_oze[l_ac].oze07,g_oze[l_ac].oze08,'',
                                '','',g_plant,g_legal)   #FUN-980010
           IF SQLCA.sqlcode THEN
#               #CALL cl_err(g_oze[l_ac].oze03,SQLCA.sqlcode,1)   #No.FUN-660167
#              CALL cl_err("INSERT oze_file",SQLCA.sqlcode,1)   #No.FUN-660167
               CALL cl_err3("ins","oze_file",g_ogb.ogb01,g_oze[l_ac].oze03,SQLCA.sqlcode,"","INSERT oze_file",1)   #No.FUN-660167
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD oze03                        #default 序號
            IF g_oze[l_ac].oze03 IS NULL OR
               g_oze[l_ac].oze03 = 0 THEN
                SELECT max(oze03)+1
                   INTO g_oze[l_ac].oze03
                   FROM oze_file
                   WHERE oze01 = g_ogb.ogb01
                     AND oze02 = g_ogb.ogb03
                IF g_oze[l_ac].oze03 IS NULL THEN
                    LET g_oze[l_ac].oze03 = 1
                END IF
            END IF
 
        AFTER FIELD oze03                        #check 序號是否重複
            IF NOT cl_null(g_oze[l_ac].oze03) THEN
               IF g_oze[l_ac].oze03 != g_oze_t.oze03 OR
                  g_oze_t.oze03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM oze_file
                    WHERE oze01 = g_ogb.ogb01
                      AND oze02 = g_ogb.ogb03
                      AND oze03 = g_oze[l_ac].oze03
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_oze[l_ac].oze03 = g_oze_t.oze03
                      NEXT FIELD oze03
                   END IF
               END IF
            END IF
        BEFORE FIELD oze05
            CASE g_oze[l_ac].oze04
                  WHEN 'O' MESSAGE g_x[11] #Master B/L
                  WHEN 'A' MESSAGE g_x[12] #Airway B/L
                  WHEN 'C' MESSAGE g_x[13] #Contain No
                  WHEN 'H' MESSAGE g_x[14] #Houser B/L
                  WHEN 'E' MESSAGE g_x[15] #快遞單號
            END CASE
        AFTER FIELD oze05
            MESSAGE ""
        BEFORE FIELD oze06
            CASE
                  WHEN g_oze[l_ac].oze04 MATCHES '[OC]' MESSAGE g_x[16] #海運公司代碼
                  WHEN g_oze[l_ac].oze04 = 'A'          MESSAGE g_x[17] #航空公司代碼
                  WHEN g_oze[l_ac].oze04 = 'H'          MESSAGE g_x[18] #統一編號
                  WHEN g_oze[l_ac].oze04 = 'E'          MESSAGE g_x[19] #快遞業者代碼
            END CASE
        AFTER FIELD oze06
            MESSAGE ""
            IF NOT cl_null(g_oze[l_ac].oze06) THEN
                IF g_oze[l_ac].oze04 MATCHES '[OC]' THEN
                    SELECT COUNT(*) INTO l_n FROM ozb_file
                     WHERE ozb01 = g_oze[l_ac].oze06
                       AND ozbacti = 'Y'
                    IF l_n <= 0 THEN
                        #無此海運公司代碼,或此代碼已無效,請重新輸入!
                        CALL cl_err(g_oze[l_ac].oze06,'axm-912',1)
                        NEXT FIELD oze06
                    END IF
                END IF
                IF g_oze[l_ac].oze04 = 'A' THEN
                    SELECT COUNT(*) INTO l_n FROM oza_file
                     WHERE oza01 = g_oze[l_ac].oze06
                       AND ozaacti = 'Y'
                    IF l_n <= 0 THEN
                        #無此航空公司代碼,或此代碼已無效,請重新輸入!
                        CALL cl_err(g_oze[l_ac].oze06,'axm-913',1)
                        NEXT FIELD oze06
                    END IF
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_oze_t.oze03 > 0 AND
               g_oze_t.oze03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM oze_file
                WHERE oze01 = g_ogb.ogb01
                  AND oze02 = g_ogb.ogb03
                  AND oze03 = g_oze_t.oze03
               IF SQLCA.sqlcode THEN
#                  #CALL cl_err(g_oze_t.oze03,SQLCA.sqlcode,0)   #No.FUN-660167
#                 CALL cl_err("DELETE oze_file",SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("del","oze_file",g_ogb.ogb01,g_oze_t.oze03,SQLCA.sqlcode,"","DELETE oze_file",0)   #No.FUN-660167
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete Ok"
               CLOSE q910_bcl
               COMMIT WORK
            END IF
 
     ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oze[l_ac].* = g_oze_t.*
               CLOSE q910_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oze[l_ac].oze03,-263,1)
               LET g_oze[l_ac].* = g_oze_t.*
            ELSE
               UPDATE oze_file SET oze03=g_oze[l_ac].oze03,
                                   oze04=g_oze[l_ac].oze04,
                                   oze05=g_oze[l_ac].oze05,
                                   oze06=g_oze[l_ac].oze06,
                                   oze07=g_oze[l_ac].oze07,
                                   oze08=g_oze[l_ac].oze08
                WHERE oze01=g_ogb.ogb01
                  AND oze02=g_ogb.ogb03
                  AND oze03=g_oze_t.oze03
               IF SQLCA.sqlcode THEN
#                  #CALL cl_err(g_oze[l_ac].oze03,SQLCA.sqlcode,1)   #No.FUN-660167
#                 CALL cl_err("UPDATE oze_file",SQLCA.sqlcode,1)   #No.FUN-660167
                  CALL cl_err3("upd","oze_file",g_ogb.ogb01,g_oze_t.oze03,SQLCA.sqlcode,"","UPDATE oze_file",1)   #No.FUN-660167
                  LET g_oze[l_ac].* = g_oze_t.*
                  CLOSE q910_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE q910_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oze[l_ac].* = g_oze_t.*
               END IF
               CLOSE q910_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           CLOSE q910_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
            IF g_oze[l_ac].oze04 MATCHES '[OC]' THEN
                CASE
                    WHEN INFIELD(oze06) #運輸業者代碼
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_ozb" #海運
                         LET g_qryparam.default1 = g_oze[l_ac].oze06
                         CALL cl_create_qry() RETURNING g_oze[l_ac].oze06
                          DISPLAY BY NAME g_oze[l_ac].oze06   #No.MOD-490371
                         NEXT FIELD oze06
                    OTHERWISE
                        EXIT CASE
                END CASE
            END IF
            IF g_oze[l_ac].oze04 = 'A' THEN
                CASE
                    WHEN INFIELD(oze06) #運輸業者代碼
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_oza" #航運
                         LET g_qryparam.default1 = g_oze[l_ac].oze06
                         CALL cl_create_qry() RETURNING g_oze[l_ac].oze06
                         NEXT FIELD oze06
                    OTHERWISE
                        EXIT CASE
                END CASE
            END IF
 
        ON ACTION controls                             #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oze03) AND l_ac > 1 THEN
                LET g_oze[l_ac].* = g_oze[l_ac-1].*
                LET g_oze[l_ac].oze03 = NULL
                NEXT FIELD oze03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
    CLOSE q910_bcl
    COMMIT WORK
 
END FUNCTION
}
#Patch....NO.TQC-610037 <001> #
