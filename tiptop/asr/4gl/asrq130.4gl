# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asrq130.4gl (copy from axmi171.4gl)
# Descriptions...: 銷售預測與生產計劃差異查詢作業
# Date & Author..: 06/03/21 By kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690023 06/09/08 By jamie 判斷occacti
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780003 07/08/01 By kim 畫圖的page的Action在_bp()段不應該加 EXIT DISPLAY,否則會照成操作不正常
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_opc           RECORD LIKE opc_file.*,
    g_opc_t         RECORD LIKE opc_file.*,
    g_opc_o         RECORD LIKE opc_file.*,
    g_opc01_t       LIKE opc_file.opc01,
    g_opc02_t       LIKE opc_file.opc02,
    g_opc03_t       LIKE opc_file.opc03,
    g_opc04_t       LIKE opc_file.opc04,
    g_opd           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        qty1        LIKE sre_file.sre07,
        qty2        LIKE sre_file.sre07,
        qty3        LIKE sre_file.sre07
                    END RECORD,
    g_opd_t         RECORD                      #程式變數 (舊值)
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        qty1        LIKE sre_file.sre07,
        qty2        LIKE sre_file.sre07,
        qty3        LIKE sre_file.sre07
                    END RECORD,
    g_opd_draw      DYNAMIC ARRAY OF RECORD     #繪製統計圖使用
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        qty1        LIKE sre_file.sre07,
        qty2        LIKE sre_file.sre07,
        qty3        LIKE sre_file.sre07
                    END RECORD,
    b_opd           RECORD
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        qty1        LIKE sre_file.sre07,
        qty2        LIKE sre_file.sre07,
        qty3        LIKE sre_file.sre07
                    END RECORD,
    g_ima02         LIKE ima_file.ima02,
    g_ima021        LIKE ima_file.ima021,
    g_wc,g_wc2      STRING,   #TQC-630166
    g_sql           STRING,   #TQC-630166
    g_rec_b         LIKE type_file.num5,        #單身筆數 #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT #No.FUN-680130 SMALLINT 
    l_cmd           LIKE type_file.chr1000      #No.FUN-680130 VARCHAR(200)
DEFINE g_before_input_done LIKE type_file.num5             #No.FUN-680130 SMALLINT
DEFINE g_draw_day          LIKE type_file.dat              #No.FUN-680130 DATE #畫統計圖用的日期
DEFINE g_yy,g_mm           LIKE type_file.num5             #No.FUN-680130 SMALLINT
DEFINE g_i                 LIKE type_file.num5             #No.FUN-680130 SMALLINT #縱刻度數目 =>10
DEFINE g_draw_x,g_draw_y,g_draw_dx,g_draw_dy,
       g_draw_width,g_draw_multiple LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_draw_base,g_draw_maxy      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_draw_start_y               LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_forupd_sql STRING                      #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6B0014
 
    LET g_forupd_sql = "SELECT * FROM opc_file WHERE opc01=? AND opc02=? AND opc03=? AND opc04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q130_cl CURSOR FROM g_forupd_sql
 
    SELECT * INTO g_mpz.* FROM mpz_file WHERE mpz00='0'
 
    OPEN WINDOW q130_w WITH FORM "asr/42f/asrq130"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    WHILE TRUE
      LET g_action_choice = ''
      CALL q130_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW q130_w                #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q130_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_opd.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_opc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
        opc01,opc02,opc03,opc04,opc05,opc06,opc10,opc07,opc08,opc09,
        opc11,opc12
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE WHEN INFIELD(opc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opc01
                  NEXT FIELD opc01
                WHEN INFIELD(opc02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opc02
                  NEXT FIELD opc02
                WHEN INFIELD(opc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opc04
                  NEXT FIELD opc04
                WHEN INFIELD(opc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opc05
                  NEXT FIELD opc05
                WHEN INFIELD(opc10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rpg"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opc10
                  NEXT FIELD opc10
                WHEN INFIELD(opc08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opc08
                  NEXT FIELD opc08
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('opcuser', 'opcgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON opd05,opd06,opd07,opd08
            FROM s_opd[1].opd05,s_opd[1].opd06,s_opd[1].opd07,
                 s_opd[1].opd08
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT opc01,opc02,opc03,opc04 FROM opc_file", #TQC-870018
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY opc01,opc02,opc03,opc04 "
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  opc01,opc02,opc03,opc04", #TQC-870018
                   "  FROM opc_file, opd_file",
                   " WHERE opc01 = opd01",
                   "   AND opc02 = opd02",
                   "   AND opc03 = opd03",
                   "   AND opc04 = opd04",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY opc01,opc02,opc03,opc04 "
    END IF
 
    PREPARE q130_prepare FROM g_sql
    DECLARE q130_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q130_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM opc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql = "SELECT DISTINCT opc01,opc02,opc03,opc04 ",
                    "  FROM opc_file, opd_file",
                    " WHERE opc01 = opd01",
                    "   AND opc02 = opd02",
                    "   AND opc03 = opd03",
                    "   AND opc04 = opd04",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " INTO TEMP q130_tmpcnt "
        #因主鍵值有兩個故所抓出資料筆數有誤
        DROP TABLE q130_tmpcnt
 
        PREPARE q130_precount_x  FROM g_sql
        EXECUTE q130_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM q130_tmpcnt "
 
    END IF
    PREPARE q130_precount FROM g_sql
    DECLARE q130_count CURSOR FOR q130_precount
    DISPLAY g_sql
 
END FUNCTION
 
FUNCTION q130_menu()
 
   WHILE TRUE
      CALL q130_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q130_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #CHI-780003..............begin
        #WHEN "page03" 
        #   LET g_yy=NULL
        #   LET g_mm=NULL
        #   CALL q130_draw()
        #WHEN "prev_month" 
        #   CALL q130_prev_month()
        #WHEN "next_month" 
        #   CALL q130_next_month()
        #WHEN "reset_month" 
        #   CALL q130_reset_month()
        #CHI-780003..............end
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_opd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q130_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q130_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_opc.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q130_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_opc.* TO NULL
    ELSE
        OPEN q130_count
        FETCH q130_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q130_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION q130_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)                #處理方式
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q130_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04 #TQC-870018
        WHEN 'P' FETCH PREVIOUS q130_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04 #TQC-870018
        WHEN 'F' FETCH FIRST    q130_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04 #TQC-870018
        WHEN 'L' FETCH LAST     q130_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04 #TQC-870018
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q130_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04 #TQC-870018
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)
        INITIALIZE g_opc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_opc.* FROM opc_file WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03 AND opc04=g_opc.opc04
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("sel","opc_file",g_opc.opc01,g_opc.opc02,SQLCA.sqlcode,"","",0) #No.FUN-660138
        INITIALIZE g_opc.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_opc.opcuser      #FUN-4C0057 add
    LET g_data_group = g_opc.opcgrup      #FUN-4C0057 add
    CALL q130_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q130_show()
    LET g_opc_t.* = g_opc.*                #保存單頭舊值
    DISPLAY BY NAME
        g_opc.opc01,g_opc.opc02,g_opc.opc03,
        g_opc.opc06,g_opc.opc10,g_opc.opc07,
        g_opc.opc04,g_opc.opc05,
        g_opc.opc08,g_opc.opc09,
        g_opc.opc11,g_opc.opc12
    CALL q130_opc01('d')
    CALL q130_opc02('d')
    CALL q130_opc04('d')
    CALL q130_opc05('d')
    CALL q130_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    LET g_yy=NULL
    LET g_mm=NULL
    CALL q130_draw()
END FUNCTION
 
FUNCTION q130_b_askkey()
DEFINE
    l_wc2           STRING
 
    CONSTRUCT l_wc2 ON opd05,opd06,opd07,opd08,opd10,opd11,opd09
            FROM s_opd[1].opd05,s_opd[1].opd06,s_opd[1].opd07,s_opd[1].opd08,
                 s_opd[1].opd10,s_opd[1].opd11,s_opd[1].opd09
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL q130_b_fill(l_wc2)
END FUNCTION
 
FUNCTION q130_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           STRING
    LET g_sql =
        "SELECT opd05,opd06,opd07,opd08,0,0,0",
        " FROM opd_file",
        " WHERE opd01 ='",g_opc.opc01,"'",  #單頭
        "   AND opd02 ='",g_opc.opc02,"'",
        "   AND opd03 ='",g_opc.opc03,"'",
        "   AND opd04 ='",g_opc.opc04,"'",
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY opd05"
 
    PREPARE q130_pb FROM g_sql
    DECLARE opd_curs                       #CURSOR
        CURSOR WITH HOLD FOR q130_pb
 
    CALL g_opd.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH opd_curs INTO g_opd[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT SUM(sre07) INTO g_opd[g_cnt].qty1 
          FROM sre_file WHERE sre04=g_opc.opc01
                          AND sre06 BETWEEN g_opd[g_cnt].opd06
                          AND g_opd[g_cnt].opd07
                          AND sre07 IS NOT NULL
       IF SQLCA.sqlcode OR cl_null(g_opd[g_cnt].qty1) THEN
          LET g_opd[g_cnt].qty1=0
       END IF
       LET g_opd[g_cnt].qty2=g_opd[g_cnt].opd08-g_opd[g_cnt].qty1
       LET g_opd[g_cnt].qty3=(g_opd[g_cnt].qty2/g_opd[g_cnt].qty1)*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_opd.deleteElement(g_cnt)
    CALL g_opd.deleteElement(g_cnt+1)
    LET g_rec_b = g_cnt - 1
    CALL SET_COUNT(g_rec_b)
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_opd TO s_opd.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q130_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q130_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q130_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q130_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q130_fetch('L')
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
         EXIT DISPLAY
         
      ON ACTION page03
        #CHI-780003......................begin
        #LET g_action_choice="page03"
        #EXIT DISPLAY #CHI-780003
         LET g_yy=NULL
         LET g_mm=NULL
         CALL q130_draw()         
        #CHI-780003......................end
#@    ON ACTION 上個月
      ON ACTION prev_month
        #CHI-780003......................begin
        #LET g_action_choice="prev_month"
        #EXIT DISPLAY
         CALL q130_prev_month()
        #CHI-780003......................end
   
#@    ON ACTION 下個月
      ON ACTION next_month
        #CHI-780003......................begin
        #LET g_action_choice="next_month"
        #EXIT DISPLAY
         CALL q130_next_month()
        #CHI-780003......................end
 
      ON ACTION reset_month
        #CHI-780003......................begin
        #LET g_action_choice="reset_month"
        #EXIT DISPLAY
         CALL q130_reset_month()
        #CHI-780003......................end
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q130_opc01(p_cmd)  #料件編號
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti,
           p_cmd     LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file
   WHERE ima01 = g_opc.opc01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------       
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02,FORMONLY.ima021
  END IF
END FUNCTION
 
FUNCTION q130_opc02(p_cmd)  #客戶編號
    DEFINE l_occ02 LIKE occ_file.occ02,
           l_occacti LIKE occ_file.occacti,
           p_cmd     LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
  LET g_errno = " "
  IF cl_null(g_opc.opc02)
     THEN
     LET g_opc.opc02=' '
     DISPLAY ' ' TO FORMONLY.occ02
     RETURN
  END IF
  SELECT occ02,occacti INTO l_occ02,l_occacti
    FROM occ_file
   WHERE occ01 = g_opc.opc02
 
  CASE WHEN SQLCA.SQLCODE = 100  
            LET g_errno = 'anm-045'
            LET l_occ02 = NULL  LET l_occacti = NULL
       WHEN l_occacti='N'
            LET g_errno = '9028'
    #FUN-690023------mod-------
       WHEN l_occacti MATCHES '[PH]'
             LET g_errno = '9038'
    #FUN-690023------mod-------
       OTHERWISE         
            LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd'  THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
  END IF
END FUNCTION
 
FUNCTION q130_opc04(p_cmd)  #業務員
    DEFINE l_gen02 LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti,
           p_cmd     LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file
   WHERE gen01 = g_opc.opc04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-053'
                                 LET l_gen02 = NULL  LET l_genacti = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
 
FUNCTION q130_opc05(p_cmd)  #部門
  DEFINE l_gem02 LIKE gem_file.gem02,
         l_gemacti LIKE gem_file.gemacti,
         p_cmd     LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gem02,gemacti INTO l_gem02,l_gemacti
    FROM gem_file
   WHERE gem01 = g_opc.opc05
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                                 LET l_gem02 = NULL  LET l_gemacti = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION q130_draw()
DEFINE id      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_sql   STRING
DEFINE l_flag  LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
  CALL drawClear()
  CALL drawselect("c01")
 
  LET g_i=10 #縱刻度數目
  CALL q130_set_ym()
  LET g_draw_day=MDY(g_mm,1,g_yy)
 
  LET g_draw_base=q130_getbase() #縱軸刻度基數;刻度比例
  IF g_draw_base=0 THEN #無單身資料
     RETURN
  END IF
 
  
  LET g_draw_x=0   #起始x軸位置
  LET g_draw_y=75  #起始y軸位置
  LET g_draw_dx=0  #起始dx軸位置
  LET g_draw_dy=10 #起始dy軸位置
  LET g_draw_width=15 #每條長條圖寬度
  LET g_draw_multiple=1 #時間的放大倍數(在長條圖上的刻度比例)
  LET g_draw_start_y=120      #起始y軸位置
  CALL q130_draw_axis()
  CALL q130_gather()
  WHILE NOT (g_draw_day IS NULL)
    IF MONTH(g_draw_day)<>g_mm THEN
       EXIT WHILE
    END IF
    CALL DrawFillColor("black")
    LET id=DrawText(60,g_draw_y+5,DAY(g_draw_day)) #日期
 
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
 
    LET l_flag=(g_opd_draw.getlength()>0) AND q130_find()
 
    IF l_flag THEN
       CALL q130_draw_plan()
    END IF
 
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    LET g_draw_y=g_draw_y+g_draw_width
 
    IF l_flag THEN
       CALL q130_draw_product()
    END IF
 
    #LET g_draw_x=g_draw_start_y #起始x軸位置
    #LET g_draw_dx=0
 
    LET g_draw_y=g_draw_y+g_draw_width
    LET g_draw_day=g_draw_day+1
 
  END WHILE
END FUNCTION
 
FUNCTION q130_draw_axis() #座標
DEFINE id,l_h          LIKE type_file.num10   #No.FUN-680130INTEGER
DEFINE l_i             LIKE type_file.num5    #No.FUN-680130SMALLINT
DEFINE l_msg           STRING
DEFINE l_draw_multiple LIKE type_file.num10     #縱刻度一個刻度的寬度  #No.FUN-680130 INTEGER
DEFINE l_dist          LIKE type_file.num10,    #每個圖例說明的間距    #No.FUN-680130 INTEGER
       l_draw_x        LIKE type_file.num10,    #每個圖例說明的x軸位置 #No.FUN-680130 INTEGER
       l_draw_y        LIKE type_file.num10,    #每個圖例說明的y軸位置 #No.FUN-680130 INTEGER
       l_base          LIKE type_file.num10                            #No.FUN-680130 INTEGER
       
  CALL DrawFillColor("black")
  LET id=DrawRectangle(g_draw_start_y-5,60,5,940) #(橫軸)
  LET id=DrawRectangle(g_draw_start_y-5,60,850,2)  #(縱軸)
  LET l_draw_multiple=35*2.3
  LET l_h=(g_draw_start_y-5)+l_draw_multiple
  FOR l_i=1 TO g_i #(縱軸刻度)
    CALL DrawFillColor("black")
    LET id=DrawRectangle(l_h,60,8,6)
    CALL DrawFillColor("black")
    LET id=DrawText(l_h-30,30,l_i*g_draw_base)
    LET l_h=l_h+l_draw_multiple
  END FOR
 
  LET g_draw_maxy=l_h-(g_draw_start_y-5)-g_draw_y #當比例為1:1的時候,長條圖在最高刻度(g_i)的長度
  
  CALL DrawFillColor("black")
  LET id=DrawText((g_draw_start_y-5)/4-10,970,"(DAY)") #日期
  CALL DrawFillColor("black")
  LET id=DrawText(940,35,"(QTY)") #數量
  
  #圖例
  #計畫數量
  LET l_dist=60
  LET l_draw_x=(g_draw_start_y-5)/4
  LET l_draw_y=g_draw_y
  CALL DrawFillColor("blue")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_get_feldname("opd08",g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-20,l_draw_y,l_msg)
 
  #生產計畫量
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("red")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-036',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-20,l_draw_y,l_msg)
END FUNCTION
 
FUNCTION q130_gather() #收集單身資料
DEFINE l_i,l_j         LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_bi,l_bj       LIKE type_file.num10   #No.FUN-680130 INTEGER
 
  CALL g_opd_draw.clear()
  LET l_j=1
  FOR l_i=1 TO g_opd.getlength()
     IF (YEAR(g_opd[l_i].opd06)=g_yy) AND
        (MONTH(g_opd[l_i].opd06)=g_mm) THEN
        #將單身的數量分攤到起始日至截止日間的每一天
        LET l_bj=(g_opd[l_i].opd07-g_opd[l_i].opd06)+1
        FOR l_bi=1 TO l_bj
           LET g_opd_draw[l_j].*=g_opd[l_i].*
           LET g_opd_draw[l_j].opd06=g_opd[l_i].opd06+(l_bi-1)
           LET g_opd_draw[l_j].opd08=g_opd[l_i].opd08/l_bj
           LET g_opd_draw[l_j].qty1=g_opd[l_i].qty1/l_bj
           LET l_j=l_j+1
        END FOR
     END IF
  END FOR
END FUNCTION
 
#找那一天的數量
FUNCTION q130_find() #RETURN TRUE => Finded ; FALSE => not found 
DEFINE l_i    LIKE type_file.num10   #No.FUN-680130 INTEGER
 
  INITIALIZE b_opd.* TO NULL
  FOR l_i=1 TO g_opd_draw.getlength()
     IF g_opd_draw[l_i].opd06=g_draw_day THEN
        LET b_opd.*=g_opd_draw[l_i].*
        CALL g_opd_draw.deleteElement(l_i)
        RETURN TRUE
     END IF
  END FOR
  RETURN FALSE
END FUNCTION
 
FUNCTION q130_draw_plan() #計劃數量
DEFINE id LIKE type_file.num10  #No.FUn-680130 int
DEFINE l_str STRING
 
  CALL DrawFillColor("blue")
  LET g_draw_dx=b_opd.opd08*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))  #數量*縮小倍率=目前長條圖長度
  LET id=DrawRectangle(g_draw_x,g_draw_y,g_draw_dx,g_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
  LET l_str=b_opd.opd08
  LET l_str=l_str.trim()
  LET l_str=b_opd.opd06," ~ ",b_opd.opd07," : ",l_str
  CALL drawSetComment(id,l_str)
END FUNCTION
 
FUNCTION q130_draw_product() #生產計劃量
DEFINE id LIKE type_file.num10  #No.FUN-680130 int
DEFINE l_str STRING
 
  CALL DrawFillColor("red")
  LET g_draw_dx=b_opd.qty1*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base)) #數量*縮小倍率=目前長條圖長度
  LET id=DrawRectangle(g_draw_x,g_draw_y,g_draw_dx,g_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
  LET l_str=b_opd.qty1
  LET l_str=l_str.trim()
  LET l_str=b_opd.opd06," ~ ",b_opd.opd07," : ",l_str
  CALL drawSetComment(id,l_str)
END FUNCTION
 
#取數量最大值的碼數-1
#若最大值為10萬,則回傳1萬;
#若最大值為 8888 則回傳 880
FUNCTION q130_getbase()
DEFINE l_sql,l_str        STRING
DEFINE l_i,l_j,l_base     LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_opd08,l_rest     LIKE opd_file.opd08
DEFINE l_bdate,l_edate    LIKE type_file.dat     #No.FUN-680130 DATE
 
   IF g_opd.getlength()=0 THEN
      RETURN 0
   END IF
   LET l_bdate=MDY(g_mm,1,g_yy)
   LET l_edate=q130_GETLASTDAY(l_bdate)
   LET l_sql =
       "SELECT MAX(opd08/(opd07-opd06+1))",
       " FROM opd_file",
       " WHERE opd01 ='",g_opc.opc01,"'",  #單頭
       "   AND opd02 ='",g_opc.opc02,"'",
       "   AND opd03 ='",g_opc.opc03,"'",
       "   AND opd04 ='",g_opc.opc04,"'",
       "   AND ",g_wc2 CLIPPED,            #單身
       "   AND opd06 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
   PREPARE q130_getbase_p FROM l_sql
   DECLARE q130_getbase_c CURSOR FOR q130_getbase_p
   OPEN q130_getbase_c
   FETCH q130_getbase_c INTO l_opd08
   IF SQLCA.sqlcode OR cl_null(l_opd08) THEN
      LET l_opd08=0
   END IF
   LET l_rest=l_opd08
   IF l_rest<=0 THEN
      RETURN 0
   END IF
   
   LET l_i=l_rest
   LET l_str=l_i
   LET l_str=l_str.trim()
   LET l_j=l_str.getlength()-2
   IF l_j<0 THEN
      LET l_j=1
   END IF
   LET l_base=1
   FOR l_i=1 TO l_j
      LET l_base=l_base*10
   END FOR
   LET l_i=l_rest/l_base
   LET l_i=l_i*l_base/g_i
   IF l_i<1 THEN
      LET l_i=1
   END IF
   RETURN l_i
END FUNCTION
 
#設定年月
FUNCTION q130_set_ym()
DEFINE l_cnt    LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_sql    STRING
 
   IF g_opd.getlength()=0 THEN
      LET g_yy=NULL
      LET g_mm=NULL
   ELSE
      LET g_draw_day=g_opd[1].opd06
      IF cl_null(g_yy) OR cl_null(g_mm) OR (g_yy=0) OR (g_mm=0) THEN
         LET g_yy=YEAR(g_draw_day)
         LET g_mm=MONTH(g_draw_day)
      ELSE
         LET g_draw_day=MDY(g_mm,1,g_yy)
         #單身若有該月份的資料,則show該月份的資料
         LET l_sql =
             "SELECT COUNT(opd06)",
             " FROM opd_file",
             " WHERE opd01 ='",g_opc.opc01,"'",  #單頭
             "   AND opd02 ='",g_opc.opc02,"'",
             "   AND opd03 ='",g_opc.opc03,"'",
             "   AND opd04 ='",g_opc.opc04,"'",
             "   AND ",g_wc2 CLIPPED,             #單身
             "   AND opd06 BETWEEN '",g_draw_day,"' AND '",
             q130_GETLASTDAY(g_draw_day),"'"
         PREPARE q130_set_ym_p FROM l_sql
         DECLARE q130_set_ym_c CURSOR FOR q130_set_ym_p
         OPEN q130_set_ym_c
         FETCH q130_set_ym_c INTO l_cnt
         IF SQLCA.sqlcode OR cl_null(l_cnt) THEN
            LET l_cnt=0
         END IF
         #IF l_cnt=0 THEN
         #   LET g_draw_day=g_opd[1].opd06
         #   LET g_yy=YEAR(g_draw_day)
         #   LET g_mm=MONTH(g_draw_day)
         #END IF
      END IF 
   END IF
   
   DISPLAY g_yy TO FORMONLY.yy
   DISPLAY g_mm TO FORMONLY.mm
END FUNCTION
 
#上個月
FUNCTION q130_prev_month()
   IF g_opd.getlength()=0 THEN
      RETURN
   END IF
   IF cl_null(g_yy) OR cl_null(g_mm) THEN
      RETURN
   ELSE
      IF g_mm=1 THEN
         LET g_mm=12
         LET g_yy=g_yy-1
      ELSE
         LET g_mm=g_mm-1
      END IF
   END IF
   DISPLAY g_yy TO FORMONLY.yy
   DISPLAY g_mm TO FORMONLY.mm
   CALL q130_draw()
END FUNCTION
 
#下個月
FUNCTION q130_next_month()
   IF g_opd.getlength()=0 THEN
      RETURN
   END IF
   IF cl_null(g_yy) OR cl_null(g_mm) THEN
      RETURN
   ELSE
      IF g_mm=12 THEN
         LET g_mm=1
         LET g_yy=g_yy+1
      ELSE
         LET g_mm=g_mm+1
      END IF
   END IF
   DISPLAY g_yy TO FORMONLY.yy
   DISPLAY g_mm TO FORMONLY.mm
   CALL q130_draw()
END FUNCTION
 
#重設年月
FUNCTION q130_reset_month()
   IF g_opd.getlength()=0 THEN
      RETURN
   ELSE
      LET g_yy=YEAR(g_opd[1].opd06)
      LET g_mm=MONTH(g_opd[1].opd06)
   END IF
   DISPLAY g_yy TO FORMONLY.yy
   DISPLAY g_mm TO FORMONLY.mm
   CALL q130_draw()
END FUNCTION
 
FUNCTION q130_GETLASTDAY(p_date)
DEFINE     p_date     LIKE type_file.dat     #No.FUN-680130 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
#Patch....NO.TQC-610037 <001> #
