# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmq820.4gl
# Descriptions...: 定期存款單異動記錄查詢(anmq820)
# Date & Author..: 99/05/05 by frank871
# Modify.........: 99/06/01 By Kammy
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660119 06/06/28 By Smapmin 單身資料顯示有誤
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-960142 09/06/12 By sabrina 做查詢時單身下條件所查出的資料不正確，在組sql時少判斷了單身的條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_gxf RECORD
             gxf011 LIKE gxf_file.gxf011,
             gxf01  LIKE gxf_file.gxf01,
             gxf11  LIKE gxf_file.gxf11,
             gxf02  LIKE gxf_file.gxf02,
             gxf021 LIKE gxf_file.gxf021,
             gxf03  LIKE gxf_file.gxf03,
             gxf05  LIKE gxf_file.gxf05,
             gxf06  LIKE gxf_file.gxf06,
             gxf04  LIKE gxf_file.gxf04,
             gxf12  LIKE gxf_file.gxf12
             END RECORD,
       g_gxg DYNAMIC ARRAY OF RECORD
            gxg02   LIKE gxg_file.gxg02,
	    date1   LIKE gxg_file.gxg03,
            gxg04   LIKE gxg_file.gxg04,
            gxg05   LIKE gxg_file.gxg05,
            num     LIKE gxg_file.gxg07,
	    date2   LIKE gxg_file.gxg08,
            status  LIKE type_file.chr8            #No.FUN-680107 VARCHAR(8)
       END RECORD,
       g_wc           STRING,                      #No.FUN-580092 HCN 
       g_wc2          STRING,                      #No.FUN-580092 HCN 
       g_sql          STRING,                      #No.FUN-580092 HCN 
       l_ac           LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b        LIKE type_file.num5,         #單身筆數 #No.FUN-680107 SMALLINT
#      g_argv1        VARCHAR(10)
       g_argv1        LIKE gxf_file.gxf011         #No.FUN-550057
 
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
 
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031  HCN
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0082
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q820_w AT p_row,p_col
         WITH FORM "anm/42f/anmq820"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_argv1 = ARG_VAL(1)
    IF NOT cl_null(g_argv1)
       THEN CALL q820_q()
    END IF
 
    CALL q820_menu()
    CLOSE WINDOW q820_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION q820_cs()
    CLEAR FORM
   CALL g_gxg.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT gxf011 FROM gxf_file ", # 組合出 SQL 指令
                 " WHERE gxf011 ='",g_argv1, "' ORDER BY gxf011"
    ELSE
   INITIALIZE g_gxf.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON gxf011,gxf02,gxf021,gxf06,gxf01,gxf11,
                                 gxf03,gxf05,gxf12,gxf04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
              WHEN INFIELD(gxf02)   #原存銀行
#                  CALL q_nma2(0,0,g_gxf.gxf02,'23') RETURNING g_gxf.gxf02
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma2"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1 = 23
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxf02
                   NEXT FIELD gxf02
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       CALL q820_b_askkey()
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #           LET g_wc = g_wc clipped," AND gxfuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #           LET g_wc = g_wc clipped," AND gxfgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #           LET g_wc = g_wc clipped," AND gxfgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxfuser', 'gxfgrup')
       #End:FUN-980030
 
       IF g_wc2 = ' 1=1' THEN           #TQC-960142 add
          LET g_sql="SELECT gxf011 FROM gxf_file ", # 組合出 SQL 指令
                    " WHERE ",g_wc CLIPPED, " ORDER BY gxf011"
     #TQC-960142---add---
       ELSE
          LET g_sql="SELECT UNIQUE gxf_file.gxf011 FROM gxf_file,gxg_file ", # 組合出 SQL 指令
                    " WHERE gxf011 = gxg011 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ", g_wc2 CLIPPED,
                    " ORDER BY gxf011"
       END IF
     #TQC-960142---add---
    END IF
 
    PREPARE q820_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q820_cs                         # SCROLL CURSOR
        SCROLL CURSOR FOR q820_prepare
 
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = "SELECT COUNT(*) FROM gxf_file WHERE gxf011 ='",g_argv1,"'"
    ELSE
  #TQC-960142---modify---
       IF g_wc2 = " 1=1" THEN
          LET g_sql= "SELECT COUNT(*) FROM gxf_file WHERE ",g_wc CLIPPED
       ELSE
          LET g_sql= "SELECT COUNT(UNIQUE gxf011) FROM gxf_file,gxg_file ",
                     " WHERE gxf011 = gxg011 ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED
       END IF
    END IF
  #TQC-960142---modify---
    PREPARE q820_precount FROM g_sql
    DECLARE q820_count CURSOR FOR q820_precount
END FUNCTION
 
 
FUNCTION q820_b_askkey()
    CONSTRUCT g_wc2 ON gxg02,gxg03,gxg04,gxg05,gxg07,gxg08
	 FROM s_gxg[1].gxg02,s_gxg[1].date1,s_gxg[1].gxg04,
	      s_gxg[1].gxg05,s_gxg[1].num,s_gxg[1].date2
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
 
FUNCTION q820_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL q820_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q820_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gxg),'','')
            END IF
      END CASE
   END WHILE
    CLOSE q820_cs
END FUNCTION
 
FUNCTION q820_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q820_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_gxg.clear()
        RETURN
    END IF
    OPEN q820_count
    FETCH q820_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q820_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)
        INITIALIZE g_gxf.* TO NULL
    ELSE
        CALL q820_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q820_fetch(p_flgxf)
    DEFINE
        p_flgxf         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    CASE p_flgxf
        WHEN 'N' FETCH NEXT     q820_cs INTO g_gxf.gxf011
        WHEN 'P' FETCH PREVIOUS q820_cs INTO g_gxf.gxf011
        WHEN 'F' FETCH FIRST    q820_cs INTO g_gxf.gxf011
        WHEN 'L' FETCH LAST     q820_cs INTO g_gxf.gxf011
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
            FETCH ABSOLUTE g_jump q820_cs INTO g_gxf.gxf011
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)
        INITIALIZE g_gxf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgxf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT gxf011,gxf01,gxf11,gxf02,gxf021,gxf03,gxf05,gxf06,gxf04,gxf12
      INTO g_gxf.*
      FROM gxf_file
       WHERE gxf011 = g_gxf.gxf011
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gxf.gxf011,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","gxf_file",g_gxf.gxf011,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
    ELSE
 
        CALL q820_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q820_show()
  DEFINE l_nma02 LIKE nma_file.nma02,
	 l_stat  LIKE type_file.chr20,       #No.FUN-680107 VARCHAR(10)
	 l_code  LIKE type_file.chr8         #No.FUN-680107 VARCHAR(7)
 
  DISPLAY BY NAME g_gxf.gxf011,g_gxf.gxf01,g_gxf.gxf11,g_gxf.gxf02,g_gxf.gxf021,
                  g_gxf.gxf03,g_gxf.gxf05,g_gxf.gxf06,g_gxf.gxf04,
                  g_gxf.gxf12
 
   SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=g_gxf.gxf02
   DISPLAY l_nma02 TO FORMONLY.nma02
   CALL q820_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q820_b_fill()              #BODY FILL UP
 DEFINE l_gxg  RECORD LIKE gxg_file.*
 
    IF NOT cl_null(g_argv1) THEN
        LET g_sql =
           "SELECT * FROM  gxg_file",
           " WHERE gxgconf = 'Y'",
           "   AND gxg011 = '",g_gxf.gxf011,"'" ,
           " ORDER BY gxg02"
    ELSE
       LET g_sql =
           "SELECT * FROM  gxg_file",
           " WHERE gxg011 = '",g_gxf.gxf011,"'" ,
           " AND gxgconf = 'Y'"," AND ",g_wc2 CLIPPED,
           " ORDER BY 2,1"
    END IF
 
    PREPARE q820_pb FROM g_sql
    DECLARE gxg_curs                      #SCROLL CURSOR
        CURSOR FOR q820_pb
 
    FOR g_cnt = 1 TO g_gxg.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_gxg[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH gxg_curs INTO l_gxg.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_gxg[g_cnt].gxg02=l_gxg.gxg02
        LET g_gxg[g_cnt].gxg04=l_gxg.gxg04
        LET g_gxg[g_cnt].gxg05=l_gxg.gxg05
        IF NOT cl_null(l_gxg.gxg09) THEN
           LET g_gxg[g_cnt].date1=l_gxg.gxg09
           LET g_gxg[g_cnt].num  =l_gxg.gxg10
           LET g_gxg[g_cnt].date2=l_gxg.gxg11
           CALL cl_getmsg('anm-638',g_lang) RETURNING g_msg
           LET g_gxg[g_cnt].status=g_msg
        ELSE
           LET g_gxg[g_cnt].date1=l_gxg.gxg03
           LET g_gxg[g_cnt].num  =l_gxg.gxg07
           LET g_gxg[g_cnt].date2=l_gxg.gxg08
           CALL cl_getmsg('anm-634',g_lang) RETURNING g_msg
           LET g_gxg[g_cnt].status=g_msg
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q820_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_gxg TO s_gxg.*   #MOD-660119
   DISPLAY ARRAY g_gxg TO s_gxg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-660119
 
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q820_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q820_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q820_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q820_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q820_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
