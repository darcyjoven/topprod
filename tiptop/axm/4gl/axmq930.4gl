# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axmq930.4gl
# Descriptions...: 貨運文件追?查詢作業
# Date & Author..: 04/06/16 By Mandy
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-610020 06/01/06 By Carrier 出貨驗收功能 -- 單頭新增驗收欄位acd_q
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-970089 09/05/19 By dxfwo  select 欄位與INTO 欄位不對應
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE
           g_oea   RECORD  #單頭
                     oea01     LIKE oea_file.oea01,
                     oea02     LIKE oea_file.oea02,
                     oea03     LIKE oea_file.oea03,
                     oea04     LIKE oea_file.oea04,
                     oea05     LIKE oea_file.oea05,
                     oea14     LIKE oea_file.oea14,
                     oea15     LIKE oea_file.oea15,
                     oeaconf   LIKE oea_file.oeaconf,
                     oeb03     LIKE oeb_file.oeb03,
                     oeb04     LIKE oeb_file.oeb04,
                     oeb05     LIKE oeb_file.oeb05,
                     oeb12     LIKE oeb_file.oeb12,
                     oeb24     LIKE oeb_file.oeb24,
                     acd_q     LIKE oeb_file.oeb24,   #No.FUN-610020
                     oeb25     LIKE oeb_file.oeb25,
                     oeb15     LIKE oeb_file.oeb15
                   END RECORD,
           g_oea_t RECORD
                     oea01     LIKE oea_file.oea01,
                     oea02     LIKE oea_file.oea02,
                     oea03     LIKE oea_file.oea03,
                     oea04     LIKE oea_file.oea04,
                     oea05     LIKE oea_file.oea05,
                     oea14     LIKE oea_file.oea14,
                     oea15     LIKE oea_file.oea15,
                     oeaconf   LIKE oea_file.oeaconf,
                     oeb03     LIKE oeb_file.oeb03,
                     oeb04     LIKE oeb_file.oeb04,
                     oeb05     LIKE oeb_file.oeb05,
                     oeb12     LIKE oeb_file.oeb12,
                     oeb24     LIKE oeb_file.oeb24,
                     acd_q     LIKE oeb_file.oeb24,   #No.FUN-610020
                     oeb25     LIKE oeb_file.oeb25,
                     oeb15     LIKE oeb_file.oeb15
                   END RECORD,
           g_yy,g_mm       LIKE type_file.num5,                 #No.FUN-680137 SMALLINT              
           g_ozf   DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables) 單身
                     oga02     LIKE oga_file.oga02,
                     oga01     LIKE oga_file.oga01,
                     oga03     LIKE oga_file.oga03,
                     ozf09     LIKE ozf_file.ozf09,
                     ozf04     LIKE ozf_file.ozf04,
                     ozf05     LIKE ozf_file.ozf05,
                     ozf07     LIKE ozf_file.ozf07,
                     ozf08     LIKE ozf_file.ozf08
                   END RECORD,
           g_ozf_t RECORD
                     oga02     LIKE oga_file.oga02,
                     oga01     LIKE oga_file.oga01,
                     oga03     LIKE oga_file.oga03,
                     ozf09     LIKE ozf_file.ozf09,
                     ozf04     LIKE ozf_file.ozf04,
                     ozf05     LIKE ozf_file.ozf05,
                     ozf07     LIKE ozf_file.ozf07,
                     ozf08     LIKE ozf_file.ozf08
                   END RECORD,
            g_wc      string,  #No.FUN-580092 HCN
            g_sql     string,  #No.FUN-580092 HCN
           g_t1       LIKE type_file.chr3,         #No.FUN-680137   VARCHAR(3)
           g_sw       LIKE type_file.chr1,         #No.FUN-680137   VARCHAR(1)
           g_buf           LIKE type_file.chr20,   #No.FUN-680137   VARCHAR(20)
           g_rec_b         LIKE type_file.num5,                #單身筆數               #No.FUN-680137 SMALLINT
           l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT    #No.FUN-680137 SMALLINT
           g_flag          LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5        #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0094
      DEFINE  p_row,p_col     LIKE type_file.num5        #No.FUN-680137 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   LET g_oea.oea01  = ARG_VAL(1)
   LET g_oea.oeb03  = ARG_VAL(2)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q930_w AT p_row,p_col WITH FORM "axm/42f/axmq930"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    LET g_flag = 'N'
    IF (NOT cl_null(g_oea.oea01) AND
        NOT cl_null(g_oea.oeb03)) THEN
         LET g_flag = 'Y'
         CALL q930_q()
    END IF
    CALL q930_menu()
    CLOSE WINDOW q930_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION q930_cs()
    CLEAR FORM                             #清除畫面
    CALL g_ozf.clear()
    IF g_flag = 'N' THEN
        CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
            oea01,oea02,oea03,oea04,oea14,oea15,oeaconf,
            oeb03,oeb04,oeb05,oeb12,oeb24,oeb25,oeb15
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(oea03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea03
                   NEXT FIELD oea03
              WHEN INFIELD(oea04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea04
                   NEXT FIELD oea04
              WHEN INFIELD(oea14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea14
                   NEXT FIELD oea14
              WHEN INFIELD(oea15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gem"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea15
                   NEXT FIELD oea15
              WHEN INFIELD(oeb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb04
                   NEXT FIELD oeb04
              WHEN INFIELD(oeb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb05
                 NEXT FIELD oeb05
              OTHERWISE
                   EXIT CASE
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
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND oeauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
    #End:FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql = "SELECT UNIQUE oeb03,oea01 ",
                "  FROM oea_file,oeb_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND oea01 = oeb01 ",
                " ORDER BY oea01,oeb03"
    PREPARE q930_prepare FROM g_sql
    DECLARE q930_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q930_prepare
 
    DROP TABLE x
    LET g_sql = "SELECT UNIQUE oeb03,oea01 ",
                "  FROM oea_file,oeb_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND oea01 = oeb01 ",
                "  INTO TEMP x "
    PREPARE q930_precount_x FROM g_sql
    EXECUTE q930_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE q930_precount FROM g_sql
    DECLARE q930_count CURSOR FOR q930_precount
END FUNCTION
 
FUNCTION q930_menu()
 
   WHILE TRUE
      CALL q930_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q930_q()
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
 
FUNCTION q930_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q930_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_oea.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q930_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL
    ELSE
        OPEN q930_count
        FETCH q930_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q930_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q930_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q930_cs INTO g_oea.oeb03,g_oea.oea01
        WHEN 'P' FETCH PREVIOUS q930_cs INTO g_oea.oeb03,g_oea.oea01
        WHEN 'F' FETCH FIRST    q930_cs INTO g_oea.oeb03,g_oea.oea01
        WHEN 'L' FETCH LAST     q930_cs INTO g_oea.oeb03,g_oea.oea01
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
            FETCH ABSOLUTE g_jump q930_cs INTO g_oea.oeb03,g_oea.oea01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  #TQC-6B0105
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
 
    SELECT oea01,oea02,oea03,oea04,oea14,oea15,oeaconf,
#          oeb03,oeb04,oeb05,oeb12,oeb24,0,oeb25,oeb15    #No.FUN-610020 #No.TQC-970089
           oeb03,oeb04,oeb05,oeb12,oeb24,oeb25,oeb15      #No.TQC-970089  
      INTO g_oea.oea01,g_oea.oea02,g_oea.oea03,g_oea.oea04,g_oea.oea14,g_oea.oea15,g_oea.oeaconf,
           g_oea.oeb03,g_oea.oeb04,g_oea.oeb05,g_oea.oeb12,g_oea.oeb24,g_oea.oeb25,g_oea.oeb15
      FROM oea_file,oeb_file
     WHERE oea01 = g_oea.oea01
       AND oeb03 = g_oea.oeb03
       AND oea01 = oeb01
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","oea_file,oeb_file",g_oea.oea01,g_oea.oeb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
        INITIALIZE g_oea.* TO NULL
        RETURN
    END IF
    #No.FUN-610020  --Begin
    SELECT SUM(ogb12)
      INTO g_oea.acd_q
      FROM ogb_file,oga_file,oea_file,oeb_file
     WHERE ogb31 = g_oea.oea01 AND ogb32 = g_oea.oeb03
       AND ogb01 = oga01
       AND oeb01 = oea01
       AND oeb01 = ogb31 AND oeb03 = ogb32
       AND oea65 = 'Y'
       AND ogaconf = 'Y' AND ogapost = 'Y'
       AND oga09 = '8'   
    IF cl_null(g_oea.acd_q ) THEN LET g_oea.acd_q  = 0 END IF
    #No.FUN-610020  --End
 
    CALL q930_show()
END FUNCTION
 
FUNCTION q930_show()
    LET g_oea_t.* = g_oea.*                #保存單頭舊值
    DISPLAY BY NAME g_oea.oea01,g_oea.oea02,g_oea.oea03,g_oea.oea04,g_oea.oea14,g_oea.oea15,g_oea.oeaconf,
                    g_oea.oeb03,g_oea.oeb04,g_oea.oeb05,g_oea.oeb12,g_oea.oeb24,g_oea.acd_q,g_oea.oeb25,g_oea.oeb15  #No.FUN-610020
 
    CALL q930_b_fill()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q930_b_fill()              #BODY FILL UP
    DEFINE l_ozf11      LIKE ozf_file.ozf11
    LET g_sql =
        "SELECT oga02,oga01,ogb03,ozf09,ozf04,ozf05,ozf07,ozf08,ozf11",
        " FROM oga_file,ogb_file,oze_file,ozf_file ",
        " WHERE ogb31 ='",g_oea.oea01,"'", #訂單單號
        "   AND ogb32 = ",g_oea.oeb03,     #訂單項次
#       "   AND ",g_wc CLIPPED,                     #單身
        "   AND oga01 = ogb01 ",
        "   AND ogb01 = oze01 ",
        "   AND ogb03 = oze02 ",
        "   AND oze04 = ozf_file.ozf01 ",
        "   AND oze05 = ozf_file.ozf02 ",
        "   AND oze06 = ozf_file.ozf03 ",
        "   AND oze07 = ozf_file.ozf04 ",
        "   AND oze08 = ozf_file.ozf05 ",
        " ORDER BY oga02,oga01,ozf11 "
 
    PREPARE q930_pb FROM g_sql
    DECLARE ozf_curs CURSOR FOR q930_pb
 
    CALL g_ozf.clear()
    LET g_cnt = 1
    FOREACH ozf_curs INTO g_ozf[g_cnt].*,l_ozf11   #單身 ARRAY 填充
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
 
FUNCTION q930_bp(p_ud)
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
         CALL q930_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q930_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q930_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q930_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q930_fetch('L')
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#Patch....NO.TQC-610037 <001,002> #
