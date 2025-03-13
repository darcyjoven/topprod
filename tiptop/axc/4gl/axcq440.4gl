# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcq440.4gl
# Descriptions...: 工單單位成本查詢作業
# Date & Author..: 96/02/06 By Roger
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-5A0127 05/10/20 By Rosayu DISPLAY AYYAR 加ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-670042 06/08/08 By Sarah 增加顯示"其他"欄位
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780013 07/08/02 By wujie  點擊右邊"營運中心切換"按鈕,彈出的界面沒有進行中文維護"plant code"
# Modify.........: No.FUN-7C0101 08/01/10 By lala  成本改善
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: NO.TQC-9B0016 09/11/04 By liuxqa rowid修改。
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.MOD-B60027 11/06/03 By Vampire 在 b_fill() 的 sql 加上 cch06=g_ccg.ccg06
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ccg             RECORD LIKE ccg_file.*,
       g_ccg_t           RECORD LIKE ccg_file.*,
       g_ccg_o           RECORD LIKE ccg_file.*,
       g_ccg01_t         LIKE ccg_file.ccg01,
       b_cch             RECORD LIKE cch_file.*,
       g_wc,g_wc2,g_sql  STRING,  #No.FUN-580092 HCN
       g_cch             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           cch04	  LIKE cch_file.cch04,
           cch22a	  LIKE cch_file.cch22a,
           cch22b	  LIKE cch_file.cch22b,
           cch22c	  LIKE cch_file.cch22c,
           cch22d	  LIKE cch_file.cch22d,
           cch22e	  LIKE cch_file.cch22e,   #FUN-670042 add
           cch22f	  LIKE cch_file.cch22f,   #FUN-7C0101
           cch22g	  LIKE cch_file.cch22g,   #FUN-7C0101
           cch22h	  LIKE cch_file.cch22h    #FUN-7C0101
                         END RECORD,
       g_cch_t           RECORD                 #程式變數 (舊值)
           cch04	  LIKE cch_file.cch04,
           cch22a	  LIKE cch_file.cch22a,
           cch22b	  LIKE cch_file.cch22b,
           cch22c	  LIKE cch_file.cch22c,
           cch22d	  LIKE cch_file.cch22d,
           cch22e	  LIKE cch_file.cch22e,   #FUN-670042 add
           cch22f	  LIKE cch_file.cch22f,   #FUN-7C0101
           cch22g	  LIKE cch_file.cch22g,   #FUN-7C0101
           cch22h	  LIKE cch_file.cch22h    #FUN-7C0101
                         END RECORD,
       g_buf             LIKE type_file.chr1000,             #        #No.FUN-680122CHAR(78),
       g_rec_b           LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
       l_ac              LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
       l_sl              LIKE type_file.num5          #No.FUN-680122 SMALLINT             #目前處理的SCREEN LINE
DEFINE g_cnt             LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_msg             LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72) 
DEFINE g_row_count       LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_curs_index      LIKE type_file.num10         #No.FUN-680122 INTEGER
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0146
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW q440_w AT p_row,p_col
        WITH FORM "axc/42f/axcq440"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   INITIALIZE g_ccg.* TO NULL
   INITIALIZE g_ccg_t.* TO NULL
   INITIALIZE g_ccg_o.* TO NULL
 
   CALL q440_menu()
   CLOSE WINDOW q440_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION q440_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_cch.clear()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ccg.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON ccg01,ccg04,ccg06,ccg07
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      #MOD-530850
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ccg04)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bma2"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_ccg.ccg04
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ccg04
             NEXT FIELD ccg04
          OTHERWISE
             EXIT CASE
        END CASE
      #MOD-530850
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON cch04,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h   #FUN-670042 add cch22e   #FUN-7C0101
                 FROM s_cch[1].cch04 ,s_cch[1].cch22a,
                      s_cch[1].cch22b,s_cch[1].cch22c,
                      s_cch[1].cch22d,s_cch[1].cch22e,                          #FUN-670042 add s_cch[1].cch22e
                      s_cch[1].cch22f,s_cch[1].cch22g,s_cch[1].cch22h           #FUN-7C0101
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      #MOD-530850
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(cch04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bmb203"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_cch[1].cch04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cch04
               NEXT FIELD cch04
            OTHERWISE
               EXIT CASE
         END CASE
 
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
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND ccguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND ccggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT UNIQUE ccg01,ccg04,ccg06,ccg07 ",             #FUN-7C0101
                " FROM ccg_file ,sfb_file ",
                " WHERE ",g_wc CLIPPED,
                " AND  sfb38 IS NOT NULL " ,
                " AND  ccg01 = sfb01 " ,
                " AND  ccg04 = sfb05 " ,                              #FUN-7C0101
#               " AND  ccg06 = sfb06 " ,                              #FUN-7C0101
#               " AND  ccg07 = sfb07 " ,                              #FUN-7C0101
                " ORDER BY ccg01,ccg04,ccg06,ccg07"                   #FUN-7C0101
   ELSE 
      LET g_sql="SELECT UNIQUE ccg01,ccg04,ccg06,ccg07 ",             #FUN-7C0101
                "  FROM ccg_file,cch_file,sfb_file ",
                " WHERE ccg01 = cch01 ",
                " WHERE ccg04 = cch04 ",                              #FUN-7C0101
                " WHERE ccg06 = cch06 ",                              #FUN-7C0101
                " WHERE ccg07 = cch07 ",                              #FUN-7C0101
                " AND   ccg01 = sfb01 ",
                " AND   ccg04 = sfb05 " ,                             #FUN-7C0101
#               " AND   ccg06 = sfb06 " ,                             #FUN-7C0101
#               " AND   ccg07 = sfb07 " ,                             #FUN-7C0101
                " AND   sfb38 IS NOT NULL ",
                " AND ",g_wc CLIPPED,
                " ORDER BY ccg01,ccg04,ccg06,ccg07 "                  #FUN-7C0101
   END IF
   PREPARE q440_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE q440_cs SCROLL CURSOR WITH HOLD FOR q440_prepare
 
   DROP TABLE y
   CREATE TEMP TABLE y(
       ccg01  LIKE ccg_file.ccg01,
       ccg04  LIKE ccg_file.ccg04,
       ccg06  LIKE ccg_file.ccg06,           #FUN-7C0101
       ccg07  LIKE ccg_file.ccg07)           #FUN-7C0101
   IF g_wc2=' 1=1 ' THEN
      LET g_sql="INSERT INTO y ",
                " SELECT ccg01,ccg04,ccg06,ccg07 ",                   #FUN-7C0101
                " from ccg_file ,sfb_file ",
                " WHERE ", g_wc CLIPPED,
                " AND  sfb38 IS NOT NULL ",
                " AND  ccg01 = sfb01 ",
                " AND  ccg04 = sfb05 ",                               #FUN-7C0101
#               " AND  ccg06 = sfb06 ",                               #FUN-7C0101
#               " AND  ccg07 = sfb07 ",                               #FUN-7C0101
                " group by ccg01,ccg04,ccg06,ccg07 "                  #FUN-7C0101
   ELSE
      LET g_sql="INSERT INTO y ",
                " SELECT ccg01,ccg04,ccg06,ccg07 ",                   #FUN-7C0101
                " from ccg_file ,sfb_file ,cch_file ",
                " WHERE ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " AND  sfb38 IS NOT NULL ",
                " AND  ccg01 = sfb01 ",
                " AND  ccg04 = sfb05 ",                               #FUN-7C0101
#               " AND  ccg06 = sfb06 ",                               #FUN-7C0101
#               " AND  ccg07 = sfb07 ",                               #FUN-7C0101
                " AND  ccg01 = cch01 ",
                " AND  ccg04 = cch04 ",                               #FUN-7C0101
                " AND  ccg06 = cch06 ",                               #FUN-7C0101
                " AND  ccg07 = cch07 ",                               #FUN-7C0101
                " group by ccg01,ccg04,ccg06,ccg07 "                  #FUN-7C0101
   END IF
   PREPARE q440_prec1 FROM g_sql
   EXECUTE q440_prec1
   LET g_sql="SELECT COUNT(*) FROM y  "
   PREPARE q440_precount FROM g_sql
   DECLARE q440_count CURSOR FOR q440_precount
END FUNCTION
 
FUNCTION q440_menu()
 
   WHILE TRUE
      CALL q440_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q440_q()
            END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL q440_b('0')
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL q440_out('o')
#           END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#@        WHEN "工廠切換"
#@           CALL q440_d()
      #  WHEN "switch_plant"         #FUN-B10030
      #     CALL q440_d()            #FUN-B10030
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cch),'','')
      END CASE
   END WHILE
   CLOSE q440_cs
END FUNCTION
 
FUNCTION q440_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q440_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_cch.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN q440_count
   FETCH q440_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q440_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
      INITIALIZE g_ccg.* TO NULL
   ELSE
      CALL q440_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION q440_fetch(p_flccg)
   DEFINE p_flccg          LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(01),
          l_abso           LIKE type_file.num10         #No.FUN-680122 INTEGER
 
    CASE p_flccg
        WHEN 'N' FETCH NEXT     q440_cs INTO g_ccg.ccg01,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07       #FUN-7C0101
        WHEN 'P' FETCH PREVIOUS q440_cs INTO g_ccg.ccg01,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07       #FUN-7C0101
        WHEN 'F' FETCH FIRST    q440_cs INTO g_ccg.ccg01,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07       #FUN-7C0101
        WHEN 'L' FETCH LAST     q440_cs INTO g_ccg.ccg01,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07       #FUN-7C0101
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
             FETCH ABSOLUTE l_abso q440_cs INTO g_ccg.ccg01,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07      #FUN-7C0101
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
       INITIALIZE g_ccg.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flccg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    {
#    SELECT * INTO g_ccg.* FROM ccg_file       # 重讀DB,因TEMP有不被更新特性
#     WHERE rowid = g_ccg_rowid                                        #TQC-9B0016 mark
#    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)   #No.FUN-660127
#       CALL cl_err3("sel","g_ccg.*",,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
#    ELSE
    }
 
       CALL q440_show()                      # 重新顯示
    #END IF
END FUNCTION
 
FUNCTION q440_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    LET g_ccg_t.* = g_ccg.*
    DISPLAY BY NAME g_ccg.ccg01,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07      #FUN-7C0101
    CALL q440_ccg01()
    CALL q440_b_fill(g_wc2)
    CALL q440_b_tot()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q440_ccg01()
DEFINE l_sfb RECORD LIKE sfb_file.*,
       l_ccg RECORD LIKE ccg_file.*,
       l_unit LIKE ccg_file.ccg22a
    SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=g_ccg.ccg01
    DISPLAY BY NAME l_sfb.sfb25,l_sfb.sfb38,
                    l_sfb.sfb08,l_sfb.sfb09,
                    l_sfb.sfb15,l_sfb.sfb22,
                    l_sfb.sfb221
  SELECT SUM(ccg22a+ccg23a),SUM(ccg22b+ccg23b),SUM(ccg22c+ccg23c),SUM(ccg22d+ccg23d),
         SUM(ccg22e+ccg23e),SUM(ccg22f+ccg23f),SUM(ccg22g+ccg23g),SUM(ccg22h+ccg23h)   #FUN-670042 add SUM(ccg22e+ccg23e)  #FUN-7C0101
    INTO l_ccg.ccg22a,l_ccg.ccg22b,l_ccg.ccg22c,l_ccg.ccg22d,
         l_ccg.ccg22e,l_ccg.ccg22f,l_ccg.ccg22g,l_ccg.ccg22h   #FUN-670042 add l_ccg.ccg22e   #FUN-7C0101
  FROM  ccg_file
  WHERE ccg01 = g_ccg.ccg01
  AND   ccg04 = g_ccg.ccg04
  AND   ccg06 = g_ccg.ccg06                  #FUN-7C0101
  AND   ccg07 = g_ccg.ccg07                  #FUN-7C0101
  LET  l_unit= (l_ccg.ccg22a+l_ccg.ccg22b+l_ccg.ccg22c+l_ccg.ccg22d+l_ccg.ccg22e+l_ccg.ccg22f+l_ccg.ccg22g+l_ccg.ccg22h)/l_sfb.sfb09   #FUN-670042 add l_ccg.ccg22e   #FUN-7C0101
  DISPLAY l_ccg.ccg22a ,l_ccg.ccg22b,l_ccg.ccg22c,l_ccg.ccg22d,l_ccg.ccg22e,l_ccg.ccg22f,l_ccg.ccg22g,l_ccg.ccg22h,l_unit   #FUN-670042 add l_ccg.ccg22e   #FUN-7C0101
       to FORMONLY.ccg22a,FORMONLY.ccg22b,FORMONLY.ccg22c,FORMONLY.ccg22d,
          FORMONLY.ccg22e,FORMONLY.ccg22f,FORMONLY.ccg22g,FORMONLY.ccg22h,FORMONLY.unit_amt   #FUN-670042 add FORMONLY.ccg22e   #FUN-7C0101
END FUNCTION
 
FUNCTION q440_out(p_cmd)
   DEFINE p_cmd		    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_cmd		    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(400),
          l_wc              LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'ccg01="',g_ccg.ccg01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則L多張
   END IF
   IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#     CALL cl_err('',-400,0) END IF
   LET l_cmd = "axcr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUN-B10030 ---------mark start------------------
#FUNCTION q440_d()
#  DEFINE l_plant,l_dbs	LIKE type_file.chr21          #No.FUN-680122CHAR(21)
#  DEFINE l_msg         LIKE type_file.chr1000        #No.TQC-780013
#
#  CALL cl_getmsg('axc-535',g_lang) RETURNING l_msg     #No.TQC-780013
#  LET INT_FLAG = 0  ######add for prompt bug
##  PROMPT 'PLANT CODE:' FOR l_plant
#  PROMPT l_msg FOR l_plant                           #No.TQC-780013
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
##         CONTINUE PROMPT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END PROMPT
#  IF l_plant IS NULL THEN RETURN END IF
#  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#  IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#  DATABASE l_dbs
#  CALL cl_ins_del_sid(1,l_plant)   #FUN-990069  
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#END FUNCTION
#FUN-B10030 --------------mark end---------------
 
FUNCTION q440_b_tot()
   DEFINE l_cch22at,l_cch22bt,l_cch22ct,l_cch22dt,l_cch22et,l_cch22ft,l_cch22gt,l_cch22ht   LIKE type_file.num20_6       #No.FUN-680122DEC(20,6)  #FUN-4C0005   #FUN-670042 add l_cch22et    #FUN-7C0101
 
   SELECT SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),SUM(cch22f),SUM(cch22g),SUM(cch22h)   #FUN-670042 add SUM(cch22e)    #FUN-7C0101
     INTO l_cch22at,l_cch22bt,l_cch22ct,l_cch22dt,l_cch22et,l_cch22ft,l_cch22gt,l_cch22ht             #FUN-670042 add l_cch22et    #FUN-7C0101
     FROM cch_file
    WHERE cch01 = g_ccg.ccg01
   DISPLAY  l_cch22at,l_cch22bt,l_cch22ct,l_cch22dt,l_cch22et,l_cch22ft,l_cch22gt,l_cch22ht   #FUN-670042 add l_cch22et    #FUN-7C0101
        TO  FORMONLY.cch22at,FORMONLY.cch22bt,FORMONLY.cch22ct,FORMONLY.cch22dt, 
            FORMONLY.cch22et,FORMONLY.cch22ft,FORMONLY.cch22gt,FORMONLY.cch22ht   #FUN-670042 add FORMONLY.cch22et     #FUN-7C0101
END FUNCTION
 
FUNCTION q440_b_askkey()
   CONSTRUCT g_wc2 ON cch04,cch22a,cch22b,cch22c,cch22d,cch22e,cch22f,cch22g,cch22h   #FUN-670042 add cch22e   #FUN-7C0101
                 FROM s_cch[1].cch04, s_cch[1].cch22a,
                      s_cch[1].cch22b,s_cch[1].cch22c,
                      s_cch[1].cch22d,s_cch[1].cch22e,   #FUN-670042 add s_cch[1].cch22e
                      s_cch[1].cch22f,s_cch[1].cch22g,s_cch[1].cch22h     #FUN-7C0101
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
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL q440_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q440_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200) 
 
    LET g_sql =
       "SELECT cch04,SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),SUM(cch22f),SUM(cch22g),SUM(cch22h) ",   #FUN-670042 add SUM(cch22e)    #FUN-7C0101
       "FROM cch_file ",
       "WHERE cch01 ='",g_ccg.ccg01,"'",
       " AND ",p_wc2 CLIPPED,                     #單身
       " AND cch06='",g_ccg.ccg06,"'",            #MOD-B60027 add
       " GROUP BY cch04",
       " ORDER BY cch04"
    PREPARE q440_pb FROM g_sql
    DECLARE cch_curs CURSOR FOR q440_pb
 
    FOR g_cnt = 1 TO g_cch.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_cch[g_cnt].* TO NULL
    END FOR
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH cch_curs INTO g_cch[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       # genero shell add g_max_rec check START
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
       # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q440_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_cch TO s_cch.* #FUN-5A0127 mark
   DISPLAY ARRAY g_cch TO s_cch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-5A0127 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     # BEFORE ROW
     #    LET l_ac = ARR_CURR()
     # CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #    LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q440_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q440_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q440_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q440_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q440_fetch('L')
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
 
 #MOD-530170
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#@    ON ACTION 工廠切換
    # ON ACTION switch_plant                   #FUN-B10030
    #    LET g_action_choice="switch_plant"    #FUN-B10030
    #    EXIT DISPLAY                          #FUN-B10030
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
