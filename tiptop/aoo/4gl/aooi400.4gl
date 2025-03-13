# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi400.4gl
# Descriptions...: 編碼規則維護作業
# Date & Author..: 03/06/26 By Carrier
# Modi...........: No.A086 03/11/26 By ching append
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510027 05/01/14 By pengu 報表轉XML
# Modify.........: No.MOD-570359 05/07/26 By kim 型態為null時,型態說明未清空
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-5C0096 05/12/16 By Cliare 單身刪除時條件對應 geg013 應為  gef04
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6B0011 06/12/07 By Cliare 新增功能取消因有拮取功能
# Modify.........: No.TQC-710036 07/01/10 By Cliare 流水號後接獨立段會錯
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/11 By mike 報表格式修改為crystal reports
# Modify.........: No.MOD-840191 08/04/20 By kim AOOI401擷取失敗
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-890021 08/09/02 By claire MOD-840191 取消調整
# Modify.........: No.TQC-920046 09/02/17 By liuxa 單頭單身都輸入的話，計算筆數的語法有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B30637 11/07/17 By Pengu 當未設獨立段時，無法產生資料
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_gef           RECORD LIKE gef_file.*,
    g_gef_t         RECORD LIKE gef_file.*,
    g_gef_o         RECORD LIKE gef_file.*,
    p_gef           RECORD LIKE gef_file.*, #上一段次內容
    g_gef01_t       LIKE gef_file.gef01,    #編碼類別 (舊值)
    g_gef02_t       LIKE gef_file.gef02,    #段次     (舊值)
    g_gef04_t       LIKE gef_file.gef04,    #段次     (舊值)
    g_geg           DYNAMIC ARRAY OF RECORD
        geg02       LIKE geg_file.geg02,
        geg03       LIKE geg_file.geg03,
        geg04       LIKE geg_file.geg04
                    END RECORD,
    g_geg_t         RECORD
        geg02       LIKE geg_file.geg02,
        geg03       LIKE geg_file.geg03,
        geg04       LIKE geg_file.geg04
                    END RECORD,
    g_gei02         LIKE gei_file.gei02,    #編碼名稱
    g_gei03         LIKE gei_file.gei03,    #性質
    g_geh02         LIKE geh_file.geh02,    #性質說明
    g_gei04         LIKE gei_file.gei04,    #段數
    g_gei05         LIKE gei_file.gei05,    #總長度
    g_argv1         LIKE gef_file.gef01,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN 
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE   g_before_input_done   LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10,         #No.FUN-680102 INTEGER
         g_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   l_table        STRING                        #No.FUN-760083
DEFINE   g_str          STRING                        #No.FUN-760083
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081 #FUN-BB0047 mark
 
   LET g_sql="gef01.gef_file.gef01,",
             "gei02.gei_file.gei02,",
             "geg05.geg_file.geg05"
   LET l_table=cl_prt_temptable("aooi400",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?)"
   PREPARE insert_prep  FROM g_sql
   IF STATUS THEN 
     CALL cl_err("insert_prep:",status,1) 
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   OPEN WINDOW i400_w WITH FORM "aoo/42f/aooi400"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * FROM gef_file  WHERE gef01=? AND gef02=? AND gef04=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_cl CURSOR FROM g_forupd_sql
 
   CALL i400_menu()
 
   CLOSE WINDOW i400_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i400_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   IF cl_null(g_argv1) THEN
      CALL g_geg.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_gef.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON gef01,gef02,gef03,gef04,gef05,gefuser,gefgrup,
                                gefmodu,gefdate,gefacti
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(gef01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gei"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_gef.gef01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gef01
               WHEN INFIELD(gef04)     #前段編碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_geg"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_gef.gef04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gef04
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
 
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_wc = g_wc clipped," AND gefuser = '",g_user,"'"
      #      END IF
 
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_wc = g_wc clipped," AND gefgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_wc = g_wc clipped," AND gefgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gefuser', 'gefgrup')
      #End:FUN-980030
 
 
      CONSTRUCT g_wc2 ON geg02,geg03,geg04                # 螢幕上取單身條件
           FROM s_geg[1].geg02,s_geg[1].geg03,s_geg[1].geg04
 
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
   ELSE
      LET g_wc = " gef01 = '",g_argv1,"'"
      LET g_wc2= " 1=1 "
   END IF
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  gef01,gef02,gef04 FROM gef_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY gef01,gef02,gef04"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  gef01,gef02,gef04 ",
                  "  FROM gef_file, geg_file ",
                  " WHERE gef01 = geg01 AND geg012 = gef02 ",
                  "   AND gef04 = geg013 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY gef01,gef02,gef04"
   END IF
 
   PREPARE i400_prepare FROM g_sql
   DECLARE i400_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i400_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM gef_file WHERE ",g_wc CLIPPED
   ELSE
#       LET g_sql="SELECT COUNT(DISTINCT gef01,gef02,gef04) ",#No.TQC-920046 mark by liuxqa
        LET g_sql="SELECT DISTINCT gef01,gef02,gef04 ",       #No.TQC-920046 mod  by liuxqa
                 "  FROM gef_file,geg_file ",
                 " WHERE geg01=gef01 AND geg012 = gef02 ",
                 "   AND gef04 = geg013 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP i400_tmpcnt "                    #No.TQC-920046 add by liuxqa 
#因主鍵值有三個故所抓出的資料筆數有誤
        DROP TABLE i400_tmpcnt                                #No.TQC-920046 add by liuxqa
 
        PREPARE i400_precount_x  FROM g_sql                   #No.TQC-920046 add by liuxqa 
        EXECUTE i400_precount_x                               #No.TQC-920046 add by liuxqa
    
        LET g_sql="SELECT COUNT(*) FROM i400_tmpcnt "         #No.TQC-920046 add by liuxqa 
   END IF
   PREPARE i400_precount FROM g_sql
   DECLARE i400_count CURSOR FOR i400_precount
 
   OPEN i400_count
   FETCH i400_count INTO g_row_count
   CLOSE i400_count
 
END FUNCTION
 
FUNCTION i400_menu()
 
   WHILE TRUE
      CALL i400_bp("G")
      CASE g_action_choice
        #MOD-6B0011-begin-mark
         #WHEN "insert"
         #   IF cl_chk_act_auth() THEN
         #      CALL i400_a()
         #   END IF
        #MOD-6B0011-end-mark
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i400_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i400_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i400_u()
            END IF
         WHEN "access"
            IF cl_chk_act_auth() THEN
               CALL i400_gen()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i400_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#           LET g_action_choice = ""
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i400_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gef.gef01 IS NOT NULL THEN
                  LET g_doc.column1 = "gef01"
                  LET g_doc.value1 = g_gef.gef01
                  LET g_doc.column2 = "gef02"
                  LET g_doc.value2 = g_gef.gef02
                  LET g_doc.column3 = "gef04"
                  LET g_doc.value3 = g_gef.gef04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_geg),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i400_a()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_geg.clear()
   INITIALIZE g_gef.* LIKE gef_file.*             #DEFAULT 設定
   LET g_gef01_t = NULL
   LET g_gef02_t = NULL
   LET g_gef04_t = ' '
   #預設值及將數值類變數清成零
   LET g_gef_o.* = g_gef.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_gef.gef04  =' '
      LET g_gef.gefuser=g_user
      LET g_gef.geforiu = g_user #FUN-980030
      LET g_gef.geforig = g_grup #FUN-980030
      LET g_gef.gefgrup=g_grup
      LET g_gef.gefdate=g_today
      LET g_gef.gefacti='Y'              #資料有效
 
      CALL i400_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_gef.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_gef.gef01) OR cl_null(g_gef.gef02) THEN # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO gef_file VALUES (g_gef.*)
      IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#        CALL cl_err(g_gef.gef01,SQLCA.sqlcode,1)   #No.FUN-660131
         CALL cl_err3("ins","gef_file",g_gef.gef01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
         CONTINUE WHILE
      END IF
 
      SELECT gef01,gef02,gef04 INTO g_gef.gef01,g_gef.gef02,g_gef.gef04 FROM gef_file
       WHERE gef01 = g_gef.gef01
         AND gef02 = g_gef.gef02
         AND gef04 = g_gef.gef04
 
      LET g_gef01_t = g_gef.gef01        #保留舊值
      LET g_gef02_t = g_gef.gef02        #保留舊值
      LET g_gef04_t = g_gef.gef04        #保留舊值
      LET g_gef_t.* = g_gef.*
      CALL g_geg.clear()
      LET g_rec_b = 0
 
      CALL i400_b()                   #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i400_gen()
   DEFINE l_sql        LIKE type_file.chr1000      #No.FUN-680102CHAR(300)
   DEFINE l_i,l_j      LIKE type_file.num5          #No.FUN-680102 SMALLINT
   DEFINE l_flag       LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE l_flag2      LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE l_gel        RECORD LIKE gel_file.*
   DEFINE l_gef        RECORD LIKE gef_file.*
   DEFINE l_geg        RECORD LIKE geg_file.*
   DEFINE l_gek        RECORD LIKE gek_file.*
   DEFINE l_gei        RECORD LIKE gei_file.*
   DEFINE l_gel01      LIKE gel_file.gel01
   DEFINE l_gel04      LIKE gel_file.gel04
   DEFINE l_gef04_old  LIKE gef_file.gef04
 
   IF s_shut(0) THEN RETURN END IF
 
   CLEAR FORM
 
   INPUT l_gel01 FROM gef01 HELP 1
 
      AFTER FIELD gef01
         SELECT * INTO l_gei.* FROM gei_file WHERE gei01 = l_gel01
         IF STATUS THEN
#           CALL cl_err(l_gel01,'aoo-112',0)   #No.FUN-660131
            CALL cl_err3("sel","gei_file",l_gel01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            NEXT FIELD gef01
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gef01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei"
               LET g_qryparam.default1 = l_gel01
               CALL cl_create_qry() RETURNING l_gel01
               DISPLAY l_gel01 TO gef01
            OTHERWISE
               EXIT CASE
         END CASE
     #TQC-860019-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     #TQC-860019-add
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET l_sql = "SELECT * FROM gel_file ",
               " WHERE gel01 = '",l_gel01,"'",
               " ORDER BY gel02 "
 
   PREPARE gen_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('gen_pre',STATUS,1)
      RETURN
   END IF
 
   DECLARE gen_curs CURSOR FOR gen_pre
 
   BEGIN WORK
   LET g_success = 'Y'
   INITIALIZE l_gef.* TO NULL
   LET l_gef04_old = ' '
   LET l_gef.gef04 = ' '
   LET l_gef.gef05 = ' '
   LET l_gef.gefacti = 'Y'
   LET l_gef.gefuser = g_user
   LET l_gef.gefgrup = g_grup
   LET l_gef.gefdate = g_today
   LET l_flag = 'N'
 
   #TQC-710036-begin-add
    SELECT gei05 INTO g_gei05 
     FROM gei_file  WHERE gei01=l_gel01
   #TQC-710036-end-add
 
   FOREACH gen_curs INTO l_gel.*
      IF STATUS THEN
         CALL cl_err('gen_curs',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      #若前段為獨立段且本段為固定及流水, 則不需處理.
      LET l_flag2= 'N'
 
      IF l_gel.gel02 > 1 THEN
         SELECT gel04 INTO l_gel04 FROM gel_file
          WHERE gel01 = l_gel.gel01
            AND gel02 = l_gel.gel02 - 1
         IF l_gel04 = '2' THEN
            LET l_flag2 = 'Y'
         END IF
      END IF
 
      #處理前段連續為固定值,獨立段,流水號之前段編碼
         IF length(l_gef.gef04) <> g_gei05 THEN #TQC-710036 add
            IF l_flag2 = 'N' THEN
               CASE
                 WHEN l_gel.gel04 = '1'         #固定值
                    LET l_gef04_old = l_gef04_old CLIPPED,l_gel.gel05
                 WHEN l_gel.gel04 = '3'         #流水號
                    FOR l_i=1 TO l_gel.gel03
                       LET l_gef04_old = l_gef04_old CLIPPED,"*"
                    END FOR
               END CASE
            END IF
         END IF   #TQC-710036 add
 
         IF l_flag = 'N' THEN
            LET l_gef.gef04 = l_gef04_old
         END IF
 
        #MOD-890021-cancel-mark
        #MOD-840191.............begin
       #--------------No:MOD-B30637 mark
       #IF l_gel.gel04 MATCHES '[1356789]' THEN
       #   CONTINUE FOREACH
       #END IF
       #--------------No:MOD-B30637 end
        #MOD-840191.............end
        #MOD-890021-cancel-mark
 
      IF cl_null(l_gel.gel04) THEN
         FOR l_i=1 TO l_gel.gel03
            LET l_gef04_old = l_gef04_old CLIPPED,"&"
         END FOR
         LET l_flag = 'Y'
      END IF
 
      LET l_gef.gef01 = l_gel.gel01
      LET l_gef.gef02 = l_gel.gel02
      LET l_gef.gef03 = l_gel.gel03
      LET l_gef.gef05 = l_gel.gel04
 
      IF l_gel.gel04 = '2' THEN    #獨立段
         DECLARE gek_curs CURSOR FOR
          SELECT * FROM gek_file
           WHERE gek01 = l_gel.gel05
         IF l_flag = 'N' THEN   #表示無單身之前段
            CALL s_geg05(l_gef.gef04,l_gef.gef01,l_gef.gef02,l_gei.gei04,'1')
                 RETURNING l_gef.gef04
            LET l_geg.geg05 = l_gef.gef04
            LET l_gef04_old = l_gef.gef04
         ELSE
            LET l_gef.gef04 = l_gef04_old
            CALL s_geg05(l_gef.gef04,l_gef.gef01,l_gef.gef02,l_gei.gei04,'1')
                 RETURNING l_gef.gef04
            LET l_geg.geg05 = l_gef.gef04
            LET l_gef04_old = l_gef.gef04
         END IF
 
         LET l_geg.geg01 = l_gef.gef01
         LET l_geg.geg012= l_gef.gef02
         LET l_geg.geg013= l_gef.gef04
         LET l_geg.geg02 = 0
 
         FOREACH gek_curs INTO l_gek.*
             IF STATUS THEN
                CALL cl_err('gek_curs',STATUS,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_geg.geg02 = l_geg.geg02 + 1
             LET l_geg.geg03 = l_gek.gek03
             LET l_geg.geg04 = l_gek.gek04
             INSERT INTO geg_file VALUES(l_geg.*)
             IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('ins geg',STATUS,0)   #No.FUN-660131
                CALL cl_err3("ins","geg_file","","",SQLCA.sqlcode,"","ins geg",1)  #No.FUN-660131
                LET g_success = 'N'
                EXIT FOREACH
             END IF
         END FOREACH
      END IF
 
      LET l_gef.geforiu = g_user      #No.FUN-980030 10/01/04
      LET l_gef.geforig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO gef_file VALUES(l_gef.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('ins gef',STATUS,0)   #No.FUN-660131
         CALL cl_err3("ins","gef_file","","",SQLCA.sqlcode,"","ins gef",1)  #No.FUN-660131
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      IF l_flag = 'Y' THEN
         LET l_gef.gef04 = ' '
      END IF
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
 
   LET g_argv1 = l_gel01
 
   CALL i400_q()
 
   LET g_argv1 = ''
 
END FUNCTION
 
FUNCTION i400_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_gef.gef01) OR cl_null(g_gef.gef02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_gef.* FROM gef_file
    WHERE gef01 = g_gef.gef01
      AND gef02 = g_gef.gef02
      AND gef04 = g_gef.gef04
 
   IF g_gef.gefacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_gef.gef01,9027,0)
      RETURN
   END IF
 
   IF NOT cl_null(g_gef.gef05) THEN
      CALL cl_err(g_gef.gef01,'aoo-123',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gef01_t = g_gef.gef01
   LET g_gef02_t = g_gef.gef02
   LET g_gef04_t = g_gef.gef04
   LET g_gef_o.* = g_gef.*
   BEGIN WORK
 
   OPEN i400_cl USING g_gef.gef01,g_gef.gef02,g_gef.gef04
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_gef.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gef.gef01,SQLCA.sqlcode,1)      # 資料被他人LOCK
       CLOSE i400_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i400_show()
 
   WHILE TRUE
      LET g_gef01_t = g_gef.gef01
      LET g_gef02_t = g_gef.gef02
      LET g_gef04_t = g_gef.gef04
      LET g_gef.gefmodu=g_user
      LET g_gef.gefdate=g_today
 
      CALL i400_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gef.*=g_gef_t.*
         CALL i400_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_gef.gef01 != g_gef01_t OR g_gef.gef02 != g_gef02_t
         OR g_gef.gef04 != g_gef04_t THEN       #更改單號
         UPDATE gef_file SET gef01 = g_gef.gef01,
                             gef02 = g_gef.gef02,
                             gef04 = g_gef.gef04
          WHERE gef01 = g_gef01_t
            AND gef02 = g_gef02_t
            AND gef04 = g_gef04_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('gef',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","gef_file",g_gef01_t,g_gef02_t,SQLCA.sqlcode,"","gef",1)  #No.FUN-660131
            CONTINUE WHILE
         END IF
 
         UPDATE geg_file SET geg01 = g_gef.gef01,
                             geg012= g_gef.gef02,
                             geg013= g_gef.gef04
          WHERE geg01 = g_gef01_t
            AND geg012 = g_gef02_t
            AND geg013 = g_gef04_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('geg',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","geg_file",g_gef01_t,g_gef02_t,SQLCA.sqlcode,"","geg",1)  #No.FUN-660131
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE gef_file SET gef_file.* = g_gef.*
       WHERE gef01=g_gef.gef01 AND gef02=g_gef.gef02 AND gef04=g_gef.gef04
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_gef.gef01,SQLCA.sqlcode,0)   #No.FUN-660131
         CALL cl_err3("upd","gef_file",g_gef.gef01,g_gef.gef02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i400_cl
   COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i400_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_gef.geforiu,g_gef.geforig,
      g_gef.gef01,g_gef.gef02,g_gef.gef03,g_gef.gef04,g_gef.gef05,g_gef.gefuser,
      g_gef.gefgrup,g_gef.gefmodu,g_gef.gefdate,g_gef.gefacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i400_set_entry(p_cmd)
         CALL i400_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gef01                  #簽核等級
         IF NOT cl_null(g_gef.gef01) THEN
            CALL i400_gef01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gef.gef01,g_errno,0)
               LET g_gef.gef01=g_gef01_t
               DISPLAY BY NAME g_gef.gef01
               NEXT FIELD gef01
            END IF
         END IF
 
      AFTER FIELD gef02                 #段次
         IF NOT cl_null(g_gef.gef02) THEN
            IF g_gef.gef02 > g_gei04 THEN  #段次大于段數
               CALL cl_err('','aoo-113',0)
               LET g_gef.gef02=g_gef02_t
               NEXT FIELD gef02
            END IF
            CALL i400_gef02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gef.gef02,g_errno,0)
               LET g_gef.gef02=g_gef02_t
               DISPLAY BY NAME g_gef.gef02
               NEXT FIELD gef02
            END IF
         END IF
 
      BEFORE FIELD gef04         #前段編碼
         IF NOT cl_null(g_gef.gef05) THEN
            CALL cl_err(g_gef.gef01,'aoo-123',0)
            NEXT FIELD gef02
         END IF
 
      AFTER FIELD gef04          #前段編碼
         IF g_gef.gef04 IS NULL THEN
            LET g_gef.gef04 = ' '
         END IF
         IF g_gef.gef02 <> 1 THEN  #段次不為1，應輸入前段編碼
            IF cl_null(g_gef.gef04) THEN
               CALL cl_err('','aoo-116',0)
               NEXT FIELD gef04
            END IF
            SELECT COUNT(*) INTO l_cnt FROM gef_file
             WHERE gef01 = g_gef.gef01
               AND gef02 > 1
               AND gef02 < g_gef.gef02
               AND gef04 = ' '
               AND gef05 <> '2'
            IF l_cnt > 0 THEN
               CALL cl_err('','aoo-115',0)
               NEXT FIELD gef04
            END IF
         ELSE                    #段次為1，應使前段編碼保持為空
            IF NOT cl_null(g_gef.gef04) THEN
               CALL cl_err('','aoo-117',0)
               NEXT FIELD gef04
            END IF
         END IF
         IF p_cmd = 'a' OR (p_cmd = 'u' AND
           (g_gef.gef01 != g_gef01_t OR g_gef.gef02 != g_gef02_t OR
            g_gef.gef04 != g_gef04_t)) THEN
            SELECT COUNT(*) INTO g_cnt FROM gef_file
             WHERE gef01 = g_gef.gef01
               AND gef02 = g_gef.gef02
               AND gef04 = g_gef.gef04
            IF g_cnt > 0 THEN   #資料重複
               CALL cl_err(g_gef.gef01,-239,0)
               LET g_gef.gef01 = g_gef01_t
               LET g_gef.gef02 = g_gef02_t
               LET g_gef.gef04 = g_gef04_t
               DISPLAY BY NAME g_gef.gef01
               DISPLAY BY NAME g_gef.gef02
               DISPLAY BY NAME g_gef.gef04
               NEXT FIELD gef04
            END IF
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_gef.gefuser = s_get_data_owner("gef_file") #FUN-C10039
         LET g_gef.gefgrup = s_get_data_group("gef_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
#        CALL cl_show_req_fields()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gef01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei"
               LET g_qryparam.default1 = g_gef.gef01
               CALL cl_create_qry() RETURNING g_gef.gef01
               DISPLAY g_gef.gef01 TO gef01
            WHEN INFIELD(gef04)     #前段編碼
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geg"
               LET g_qryparam.default1 = g_gef.gef04
               LET g_qryparam.arg1 = g_gef.gef01
               LET g_qryparam.arg2 = g_gef.gef02
               CALL cl_create_qry() RETURNING g_gef.gef04
#               CALL FGL_DIALOG_SETBUFFER( g_gef.gef04 )
               DISPLAY g_gef.gef04 TO gef04
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(gef01) THEN
      #      LET g_gef.* = g_gef_t.*
      #      DISPLAY BY NAME g_gef.*
      #      NEXT FIELD gef01
      #   END IF
        #MOD-650015 --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION i400_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gef01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i400_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gef01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i400_q()
    # 2004/02/06 by Hiko : 初始化單頭資料筆數.
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_gef.* TO NULL              #No.FUN-6A0015
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_geg.clear()
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL i400_cs()
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
 
    OPEN i400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gef.* TO NULL
    ELSE
       OPEN i400_count
       FETCH i400_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i400_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
   ls_jump         LIKE ze_file.ze03
 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i400_cs INTO g_gef.gef01,
                                           g_gef.gef02,g_gef.gef04
      WHEN 'P' FETCH PREVIOUS i400_cs INTO g_gef.gef01,
                                           g_gef.gef02,g_gef.gef04
      WHEN 'F' FETCH FIRST    i400_cs INTO g_gef.gef01,
                                           g_gef.gef02,g_gef.gef04
      WHEN 'L' FETCH LAST     i400_cs INTO g_gef.gef01,
                                           g_gef.gef02,g_gef.gef04
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED || ': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                 CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump i400_cs INTO g_gef.gef01,
                                             g_gef.gef02,g_gef.gef04
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gef.gef01,SQLCA.sqlcode,0)
      INITIALIZE g_gef.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_gef.* FROM gef_file WHERE gef01=g_gef.gef01 AND gef02=g_gef.gef02 AND gef04=g_gef.gef04
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_gef.gef01,SQLCA.sqlcode,0)   #No.FUN-660131
      CALL cl_err3("sel","gef_file",g_gef.gef01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
      INITIALIZE g_gef.* TO NULL
      RETURN
   ELSE                                    #FUN-4C0044權限控管
      LET g_data_owner=g_gef.gefuser
      LET g_data_group=g_gef.gefgrup
   END IF
 
   CALL i400_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i400_show()
   DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   LET g_gef_t.* = g_gef.*                      #保存單頭舊值
   DISPLAY BY NAME g_gef.gef01,g_gef.gef02,g_gef.gef03,g_gef.gef04,g_gef.gef05, g_gef.geforiu,g_gef.geforig,
                   g_gef.gefuser,g_gef.gefgrup,g_gef.gefmodu,g_gef.gefdate,g_gef.gefacti
   CALL i400_gef01('d')
   CALL i400_gef02('d')
   CALL i400_b_fill(g_wc2)                      #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i400_r()
   DEFINE  l_cnt   LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_gef.gef01) OR cl_null(g_gef.gef02) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i400_cl USING g_gef.gef01,g_gef.gef02,g_gef.gef04
   IF STATUS THEN
      CALL cl_err("OPEN i400_cl:", STATUS, 1)
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i400_cl INTO g_gef.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gef.gef01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i400_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gef01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gef.gef01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "gef02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_gef.gef02      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "gef04"         #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_gef.gef04      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      SELECT COUNT(*) INTO l_cnt FROM gef_file
       WHERE gef01 = g_gef.gef01
         AND gef02 > g_gef.gef02
         AND gef04 = g_gef.gef04
      IF l_cnt > 0 THEN
         IF cl_conf(0,0,'aoo-127') THEN
            DELETE FROM gef_file
             WHERE gef01 = g_gef.gef01
               AND gef02 >= g_gef.gef02
               AND gef04 = g_gef.gef04
            DELETE FROM geg_file
             WHERE geg01 = g_gef.gef01
               AND geg012 >= g_gef.gef02
               AND geg013 = g_gef.gef04
         END IF
      END IF
 
      DELETE FROM gef_file
       WHERE gef01 = g_gef.gef01
         AND gef02 = g_gef.gef02
         AND gef04 = g_gef.gef04
 
      DELETE FROM geg_file
       WHERE geg01 = g_gef.gef01
         AND geg012 = g_gef.gef02
         AND geg013 = g_gef.gef04
 
      INITIALIZE g_gef.* TO NULL
      CLEAR FORM
      CALL g_geg.clear()
 
      OPEN i400_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i400_cs
         CLOSE i400_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--  
      FETCH i400_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i400_cs
         CLOSE i400_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i400_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i400_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i400_fetch('/')
      END IF
   END IF
 
   CLOSE i400_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i400_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102CHAR(1)              #可新增否
   l_allow_delete  LIKE type_file.chr1,           #No.FUN-680102CHAR(1)              #可刪除否
   l_geg05         LIKE geg_file.geg05
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_gef.gef01) OR cl_null(g_gef.gef02) THEN
      RETURN
   END IF
 
   SELECT * INTO g_gef.* FROM gef_file
    WHERE gef01 = g_gef.gef01 AND gef02 = g_gef.gef02 AND gef04 = g_gef.gef04
 
   IF g_gef.gefacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_gef.gef01,'aom-000',0)
      RETURN
   END IF
 
   IF NOT cl_null(g_gef.gef05) THEN
      CALL cl_err(g_gef.gef01,'aoo-123',0)
      RETURN
   END IF
 
   IF g_gef.gef02 > 1 AND g_gef.gef04 = ' ' THEN
      CALL cl_err(g_gef.gef01,'aoo-139',0)
      RETURN
   END IF
 
  #LET l_allow_insert = cl_detail_input_auth('insert')  #MOD-6B0011 mark
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT geg02,geg03,geg04 FROM geg_file ",
                      "  WHERE geg01 = ? AND geg012 = ? ",
                      "   AND geg013 = ? AND geg02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_geg WITHOUT DEFAULTS FROM s_geg.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
      #             INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) #MOD-6B0011 mark
                    DELETE ROW=l_allow_delete)  #MOD-6B0011 
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
 
         BEGIN WORK
         OPEN i400_cl USING g_gef.gef01,g_gef.gef02,g_gef.gef04
         IF STATUS THEN
            CALL cl_err("OPEN i400_cl:", STATUS, 1)
            CLOSE i400_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i400_cl INTO g_gef.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_gef.gef01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i400_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_geg_t.* = g_geg[l_ac].*  #BACKUP
 
            OPEN i400_bcl USING g_gef.gef01,g_gef.gef02,g_gef.gef04,
                                g_geg_t.geg02
            IF STATUS THEN
               CALL cl_err("OPEN i400_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i400_bcl INTO g_geg[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_geg_t.geg02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_geg[l_ac].* TO NULL      #900423
         LET g_geg_t.* = g_geg[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD geg02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         LET l_geg05 = g_gef.gef04 CLIPPED,g_geg[l_ac].geg03
         CALL s_geg05(l_geg05,g_gef.gef01,g_gef.gef02+1,g_gei04,'2')
              RETURNING l_geg05
         INSERT INTO geg_file(geg01,geg012,geg013,geg02,geg03,geg04,geg05)
               VALUES(g_gef.gef01,g_gef.gef02,g_gef.gef04,g_geg[l_ac].geg02,
                      g_geg[l_ac].geg03,g_geg[l_ac].geg04,l_geg05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_geg[l_ac].geg02,SQLCA.sqlcode,1)   #No.FUN-660131
            CALL cl_err3("ins","geg_file",g_geg[l_ac].geg02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD geg02                        #default 序號
         IF cl_null(g_geg[l_ac].geg02) OR g_geg[l_ac].geg02 = 0 THEN
            SELECT max(geg02)+1 INTO g_geg[l_ac].geg02 FROM geg_file
             WHERE geg01  = g_gef.gef01 AND geg012 = g_gef.gef02
               AND geg013 = g_gef.gef04
            IF g_geg[l_ac].geg02 IS NULL THEN
                LET g_geg[l_ac].geg02 = 1
            END IF
         END IF
 
      AFTER FIELD geg02                        #check 序號是否重複
         IF NOT cl_null(g_geg[l_ac].geg02) THEN
            IF g_geg[l_ac].geg02 != g_geg_t.geg02 OR cl_null(g_geg_t.geg02) THEN
               SELECT count(*) INTO l_n FROM geg_file
                WHERE geg01 = g_gef.gef01
                  AND geg012= g_gef.gef02
                  AND geg013= g_gef.gef04
                  AND geg02 = g_geg[l_ac].geg02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_geg[l_ac].geg02 = g_geg_t.geg02
                  NEXT FIELD geg02
               END IF
            END IF
         END IF
 
      AFTER FIELD geg03
         IF NOT cl_null(g_geg[l_ac].geg03) THEN
            IF length(g_geg[l_ac].geg03) <> g_gef.gef03 THEN
               CALL cl_err(g_geg[l_ac].geg03,'aoo-121',0)
               NEXT FIELD geg03
            END IF
            IF g_geg[l_ac].geg03 MATCHES '*[*_%? ]*' THEN
               CALL cl_err(g_geg[l_ac].geg03,'aoo-124',0)
               NEXT FIELD geg03
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_geg_t.geg02 > 0 AND g_geg_t.geg02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM geg_file
             WHERE geg01 = g_gef.gef01
               AND geg012= g_gef.gef02
              #AND geg013= g_gef.gef03
               AND geg013= g_gef.gef04    #MOD-5C0096
               AND geg02 = g_geg_t.geg02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_geg_t.geg02,SQLCA.sqlcode,0)   #No.FUN-660131
               CALL cl_err3("del","geg_file",g_geg_t.geg02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE "Delete Ok"
            CLOSE i400_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_geg[l_ac].* = g_geg_t.*
            CLOSE i400_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_geg[l_ac].geg02,-263,1)
            LET g_geg[l_ac].* = g_geg_t.*
         ELSE
            UPDATE geg_file SET geg02 = g_geg[l_ac].geg02,
                                geg03 = g_geg[l_ac].geg03,
                                geg04 = g_geg[l_ac].geg04,
                                geg05 = l_geg05
             WHERE geg01 =g_gef.gef01 AND geg012=g_gef.gef02
               AND geg013=g_gef.gef04 AND geg02 =g_geg_t.geg02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_geg[l_ac].geg02,SQLCA.sqlcode,1)   #No.FUN-660131
               CALL cl_err3("upd","geg_file",g_gef.gef01,g_gef.gef02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_geg[l_ac].* = g_geg_t.*
               CLOSE i400_bcl
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i400_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac                #FUN-D40030 Mark
 
         IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_geg[l_ac].* = g_geg_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_geg.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i400_bcl
             ROLLBACK WORK
             EXIT INPUT
         END IF
         LET l_ac_t = l_ac                #FUN-D40030 Add
         CLOSE i400_bcl
         COMMIT WORK
 
## UnMark By Raymon
      ON ACTION CONTROLN
         CALL i400_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(geg02) AND l_ac > 1 THEN
            LET g_geg[l_ac].* = g_geg[l_ac-1].*
            NEXT FIELD geg02
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
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END INPUT
 
  #start FUN-5B0136
   LET g_gef.gefmodu = g_user
   LET g_gef.gefdate = g_today
   UPDATE gef_file SET gefmodu = g_gef.gefmodu,gefdate = g_gef.gefdate
    WHERE gef01 = g_gef.gef01 AND gef02 = g_gef.gef02 AND gef04 = g_gef.gef04
   DISPLAY BY NAME g_gef.gefmodu,g_gef.gefdate
  #end FUN-5B0136
 
   CLOSE i400_bcl
   CLOSE i400_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i400_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       #No.FUN-680102CHAR(200) 
 
 
   CONSTRUCT l_wc2 ON geg02,geg03,geg04
           FROM s_geg[1].geg02,s_geg[1].geg03,s_geg[1].geg04
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
 
   CALL i400_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i400_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2          LIKE type_file.chr1000      #No.FUN-680102CHAR(200) 
 
   LET g_sql = "SELECT geg02,geg03,geg04 FROM geg_file",
               " WHERE geg01 ='",g_gef.gef01,"'",  #單頭
               "   AND geg012='",g_gef.gef02,"'",
               "   AND geg013='",g_gef.gef04,"'",
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY geg02,geg03,geg04"
   PREPARE i400_pb FROM g_sql
   DECLARE geg_curs CURSOR FOR i400_pb
 
   CALL g_geg.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH geg_curs INTO g_geg[g_cnt].*   #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_geg.deleteElement(g_cnt)# by kay
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_geg TO s_geg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
     #MOD-6B0011-mark
      #ON ACTION insert
      #   LET g_action_choice="insert"
      #   EXIT DISPLAY
     #MOD-6B0011-mark
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION last
         CALL i400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION access
         LET g_action_choice="access"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i400_gef01(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
       l_geiacti LIKE gei_file.geiacti,
       l_gehacti LIKE geh_file.gehacti
 
   LET g_errno = ' '
   SELECT gei02,gei03,geh02,gei04,gei05,geiacti,gehacti
     INTO g_gei02,g_gei03,g_geh02,g_gei04,g_gei05,l_geiacti,l_gehacti
     FROM gei_file,geh_file
    WHERE gei01 = g_gef.gef01 AND geh01 = gei03
 
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aoo-112'
                                 LET g_gei02 = NULL
                                 LET g_gei03 = NULL
                                 LET g_geh02 = NULL
                                 LET g_gei04 = NULL
                                 LET g_gei05 = NULL
        WHEN l_geiacti='N'       LET g_errno = '9028'
        WHEN l_gehacti='N'       LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_gei02 TO FORMONLY.gei02
      DISPLAY g_gei03 TO FORMONLY.gei03
      DISPLAY g_geh02 TO FORMONLY.geh02
      DISPLAY g_gei04 TO FORMONLY.gei04
      DISPLAY g_gei05 TO FORMONLY.gei05
   END IF
 
END FUNCTION
 
FUNCTION i400_gef02(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
       l_gel05   LIKE gel_file.gel05,
       l_gel06   LIKE gel_file.gel06,
       l_desc    LIKE type_file.chr8           #No.FUN-680102CHAR(10)
 
   LET g_errno = ' '
   LET l_desc = ''
 
   SELECT gel03,gel04,gel05,gel06
     INTO g_gef.gef03,g_gef.gef05,l_gel05,l_gel06
     FROM gel_file
    WHERE gel01 = g_gef.gef01 AND gel02 = g_gef.gef02
 
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aoo-137'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF g_gef.gef05 = '2' THEN    #獨立段
         LET l_desc = cl_getmsg('aoo-136',g_lang)
      END IF
      DISPLAY g_gef.gef05 TO gef05 #MOD-570359
      DISPLAY l_gel05,l_desc TO gel05,desc
      DISPLAY l_gel06 TO FORMONLY.gel06
      DISPLAY BY NAME g_gef.gef03
   END IF
 
END FUNCTION
 
FUNCTION i400_out()
    DEFINE
        l_gef01 LIKE gef_file.gef01,
        l_geg05 LIKE geg_file.geg05,
        l_gei02 LIKE gei_file.gei02,
        l_gel04 LIKE gel_file.gel04,
        l_max   LIKE type_file.num5,           #No.FUN-680102SMALLINT,
        l_cnt   LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_wc    LIKE type_file.chr1000,       #No.FUN-680102CHAR(500),
        l_name  LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05  LIKE type_file.chr1000                #        #No.FUN-680102 VARCHAR(40)
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                           #No.FUN-760083
    LET g_str=''                                        #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql=" SELECT UNIQUE gef01,gei02,MAX(gef02)",
              "   FROM gef_file,gei_file ",
              "  WHERE gei01 = gef01 ",
              "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              "  GROUP BY gef01,gei02 "
    PREPARE i400_p1 FROM g_sql
    IF STATUS THEN CALL cl_err('i400_p1',STATUS,0) RETURN END IF
    DECLARE i400_co CURSOR FOR i400_p1
 
    #CALL cl_outnam('aooi400') RETURNING l_name           #No.FUN-760083 
    #START REPORT i400_rep TO l_name                      #No.FUN-760083 
 
    FOREACH i400_co INTO l_gef01,l_gei02,l_max,l_cnt
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        LET l_gel04 = ''
        SELECT gel04 INTO l_gel04 FROM gel_file
         WHERE gel01 = l_gef01 AND gel02 = l_max
 
        SELECT COUNT(*) INTO l_cnt FROM gef_file
         WHERE gef01 = l_gef01 AND (gef05 IS NULL OR gef05 = ' ')
 
        LET g_sql="SELECT UNIQUE geg05 FROM gef_file,geg_file ",
                  " WHERE gef01 = geg01 AND gef02 = geg012 ",
                  "   AND gef04 = geg013 AND gef01 = '",l_gef01,"'",
                  "   AND geg012 = ",
                  "       (SELECT MAX(geg012) FROM geg_file,gef_file ",
                  "         WHERE geg01 = gef01 AND geg012 = gef02 ",
                  "           AND geg013= gef04 AND geg01 = '",l_gef01,"'"
 
        #若最後段為獨立段, 則應取前段之geg05
        #若為連續獨立段, 則不判斷
        IF l_gel04 = '2' AND l_cnt > 1 THEN
           LET g_sql = g_sql CLIPPED,
                       " AND (gef05 != '2' OR gef05 IS NULL OR gef05 = ' '))"
        ELSE
           LET g_sql = g_sql CLIPPED," )"
        END IF
        PREPARE i400_p2 FROM g_sql
        IF STATUS THEN CALL cl_err('i400_p2',STATUS,0) RETURN END IF
        DECLARE i400_co2 CURSOR FOR i400_p2
 
        FOREACH i400_co2 INTO l_geg05
            #OUTPUT TO REPORT i400_rep(l_gef01,l_gei02,l_geg05)      #No.FUN-760083 
            EXECUTE insert_prep USING l_gef01,l_gei02,l_geg05        #No.FUN-760083 
        END FOREACH
    END FOREACH
 
    #FINISH REPORT i400_rep                                           #No.FUN-760083 
 
    CLOSE i400_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                                #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    #No.FUN-760083 
    IF g_zz05='Y' THEN                                                #No.FUN-760083
       CALL cl_wcchp(g_wc,'gef01,gef02,gef03,gef04,gef05,gefuser,gefgrup,   #No.FUN-760083                                                      
                           gefmodu,gefdate,gefacti')                        #No.FUN-760083
       RETURNING  g_wc
    END IF                                                                  #No.FUN-760083
    LET g_str=g_wc                                                          #No.FUN-760083
    CALL cl_prt_cs3("aooi400","aooi400",g_sql,g_str)                        #No.FUN-760083 
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i400_rep(l_gef01,l_gei02,l_geg05)
    DEFINE
        l_trailer_sw LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
        l_gef01 LIKE gef_file.gef01,
        l_gei02 LIKE gei_file.gei02,
        l_geg05 LIKE geg_file.geg05
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
    ORDER BY l_gef01,l_geg05
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF l_gef01
           PRINT COLUMN g_c[31],l_gef01,COLUMN g_c[32],l_gei02;
 
        ON EVERY ROW
           PRINT COLUMN g_c[33],l_geg05
 
        AFTER GROUP OF l_gef01
           SKIP 1 LINE
 
        ON LAST ROW
           PRINT COLUMN g_c[31],g_x[9] CLIPPED,COLUMN g_c[32],g_x[10] CLIPPED
           PRINT g_dash[1,g_len]
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
           LET l_trailer_sw = 'n'
 
        PAGE TRAILER
           IF l_trailer_sw = 'y' THEN
              PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
           ELSE
              SKIP 2 LINE
           END IF
END REPORT
}
#No.FUN-760083 -end-

