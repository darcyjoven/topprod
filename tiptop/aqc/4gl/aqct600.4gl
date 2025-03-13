# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqct600.4gl
# Descriptions...: Xbar-R管制數據維護作業
# Date & Author..: 00/04/24 By Melody
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0038 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550063 05/05/20 By wujie 單據編號加大
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-5C0078 05/12/20 By day 抓取qcs_file的程序多加判斷qcs00
# Modify.........: No.MOD-620066 06/03/28 By pengu 1.單身資料的抓取邏輯抓取的資料似乎有問題
                                   #               2.close pi(),pf(),pp()的construct，因為會照成資料抓取錯誤
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: NO.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號部份改成char(16)
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-680104 06/08/31 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-950150 10/03/04 By vealxu 修改_u()函式中的update語句 
# Modify.........: No.TQC-B80258 11/08/31 By lilingyu 單頭狀態頁簽,有欄位不可下查詢條件
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20025 13/02/21 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30034 13/04/16 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_qdb           RECORD LIKE qdb_file.*,
    g_qdb_t         RECORD LIKE qdb_file.*,
    g_qdb_o         RECORD LIKE qdb_file.*,
    g_qdb01_t       LIKE qdb_file.qdb01,
    g_qdb011_t      LIKE qdb_file.qdb011,
    g_qdb012_t      LIKE qdb_file.qdb012,
    g_qdb013_t      LIKE qdb_file.qdb013,
    g_qdc           DYNAMIC ARRAY OF RECORD
        qdc02       LIKE qdc_file.qdc02,
        qdc03       LIKE qdc_file.qdc03,
        qdc04       LIKE qdc_file.qdc04,
        qdc05       LIKE qdc_file.qdc05,
        qdc06       LIKE qdc_file.qdc06,
        qdc07       LIKE qdc_file.qdc07,
        qdc08       LIKE qdc_file.qdc08
                    END RECORD,
    g_qdc_t         RECORD
        qdc02       LIKE qdc_file.qdc02,
        qdc03       LIKE qdc_file.qdc03,
        qdc04       LIKE qdc_file.qdc04,
        qdc05       LIKE qdc_file.qdc05,
        qdc06       LIKE qdc_file.qdc06,
        qdc07       LIKE qdc_file.qdc07,
        qdc08       LIKE qdc_file.qdc08
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,   #No.FUN-580092 HCN    #No.FUN-680104
    g_tabname       STRING,
    g_rec_b         LIKE type_file.num5,         #單身筆數                #No.FUN-680104 SMALLINT
    g_void          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(300)
    l_wc            LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(300)
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT     #No.FUN-680104 SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql    STRING     #SELECT ... FOR UPDATE SQL               #No.FUN-680104
DEFINE   g_before_input_done  LIKE type_file.num5                         #No.FUN-680104 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1                              #No.FUN-680104 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10                             #No.FUN-680104 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_jump          LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680104 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
    p_row,p_col   LIKE type_file.num5                #No.FUN-680104 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
    LET g_forupd_sql = "SELECT * FROM qdb_file WHERE qdb01 = ? AND qdb011 = ? AND qdb012 = ? AND qdb013 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 15
 
    OPEN WINDOW t600_w AT p_row,p_col   #顯示畫面
         WITH FORM "aqc/42f/aqct600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL t600_menu()
 
    CLOSE WINDOW t600_w                 #結束畫面
 
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
END MAIN
 
#QBE 查詢資料
FUNCTION t600_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_qdc.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qdb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        qdb00,qdb01,qdb011,qdb012,qdb013,qdb02,qdb03,qdb04,qdb05,qdb06,qdbconf,
        qdbuser,qdbgrup,
        qdboriu,qdborig,                #TQC-B80258
        qdbmodu,qdbdate,qdbacti
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND qdbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND qdbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND qdbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qdbuser', 'qdbgrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON qdc02,qdc03,qdc04,qdc05,qdc06,qdc07,qdc08
            FROM s_qdc[1].qdc02,s_qdc[1].qdc03,s_qdc[1].qdc04,s_qdc[1].qdc05,
                 s_qdc[1].qdc06,s_qdc[1].qdc07,s_qdc[1].qdc08
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
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  qdb01, qdb011, qdb012, qdb013 FROM qdb_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY qdb01,qdb011,qdb012"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  qdb01, qdb011,qdb012,qdb013 ",
                   "  FROM qdb_file, qdc_file ",
                   " WHERE qdb01 = qdc01",
                   "   AND qdb011= qdc011",
                   "   AND qdb012= qdc012",
                   "   AND qdb013= qdc013",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY qdb01,qdb011,qdb012"
    END IF
 
    PREPARE t600_prepare FROM g_sql
    DECLARE t600_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t600_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM qdb_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT qdb01) FROM qdb_file,qdc_file WHERE ",
                  "qdc01=qdb01 AND qdc011=qdb011 AND qdc012=qdb012 AND ",
                  "qdc013=qdb013 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t600_precount FROM g_sql
    DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_menu()
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_y()
               IF g_qdb.qdbconf= 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_z()
               IF g_qdb.qdbconf= 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t600_x()    #FUN-D20025
               CALL t600_x(1)   #FUN-D20025
               IF g_qdb.qdbconf= 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
            END IF
         #FUN-D20025--add--str--
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL t600_x()    #FUN-D20025
               CALL t600_x(2)   #FUN-D20025
               IF g_qdb.qdbconf= 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
            END IF
         #FUN-D20025--add--end--
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qdc),'','')
            END IF
         #No.FUN-6A0160-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_qdb.qdb01 IS NOT NULL THEN
                LET g_doc.column1 = "qdb01"
                LET g_doc.column2 = "qdb011"
                LET g_doc.column3 = "qdb012"
                LET g_doc.column4 = "qdb013" 
                LET g_doc.value1 = g_qdb.qdb01
                LET g_doc.value2 = g_qdb.qdb011
                LET g_doc.value3 = g_qdb.qdb012
                LET g_doc.value4 = g_qdb.qdb013
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0160-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t600_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_qdc.clear()
    INITIALIZE g_qdb.* LIKE qdb_file.*             #DEFAULT 設定
    LET g_qdb01_t = NULL
    LET g_qdb011_t = NULL
    LET g_qdb012_t = NULL
    LET g_qdb013_t = NULL
    #預設值及將數值類變數清成零
    LET g_qdb_t.* = g_qdb.*
    LET g_qdb_o.* = g_qdb.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_qdb.qdb00='1'
        LET g_qdb.qdbconf='N'
        LET g_qdb.qdbuser=g_user
        LET g_qdb.qdboriu = g_user #FUN-980030
        LET g_qdb.qdborig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_qdb.qdbgrup=g_grup
        LET g_qdb.qdbdate=g_today
        LET g_qdb.qdbacti='Y'              #資料有效
        LET g_qdb.qdb03=0
        LET g_qdb.qdb04=0
        LET g_qdb.qdb05=0
        LET g_qdb.qdb06=0
        LET g_qdb.qdb07=0
        LET g_qdb.qdb071=0
        LET g_qdb.qdb072=0
        LET g_qdb.qdb08=0
        LET g_qdb.qdb081=0
        LET g_qdb.qdb082=0
        CALL t600_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_qdb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_qdb.qdb01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_qdb.qdb011 IS NULL THEN LET g_qdb.qdb011=0 END IF
        IF g_qdb.qdb012 IS NULL THEN LET g_qdb.qdb012=0 END IF
        LET g_qdb.qdbplant = g_plant #FUN-980007
        LET g_qdb.qdblegal = g_legal #FUN-980007
        INSERT INTO qdb_file VALUES (g_qdb.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,1)   #No.FUN-660115
            CALL cl_err3("ins","qdb_file",g_qdb.qdb01,g_qdb.qdb011,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CONTINUE WHILE
        END IF
        SELECT qdb01,qdb011,qdb012,qdb013 INTO g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013 FROM qdb_file
            WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
              AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
        LET g_qdb01_t = g_qdb.qdb01        #保留舊值
        LET g_qdb011_t = g_qdb.qdb011        #保留舊值
        LET g_qdb012_t = g_qdb.qdb012        #保留舊值
        LET g_qdb013_t = g_qdb.qdb013        #保留舊值
        LET g_qdb_t.* = g_qdb.*
 
        CALL g_qdc.clear()
        LET g_rec_b = 0
 
        SELECT COUNT(*) INTO g_cnt FROM qdc_file WHERE qdc01=g_qdb.qdb01
           AND qdc011=g_qdb.qdb011 AND qdc012=g_qdb.qdb012
           AND qdc013=g_qdb.qdb013
 
        IF g_cnt =0 THEN
           CASE g_qdb.qdb00
#No.FUN-5C0078-begin
#             WHEN '1'
#                CALL t600_pi()
              WHEN '2'
                 CALL t600_pf()
              WHEN '3'
                 CALL t600_pp()
              OTHERWISE
                 CALL t600_pi()
#No.FUN-5C0078-end
           END CASE
        END IF
 
        CALL t600_b()                   #輸入單身
 
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION t600_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_qdb.qdb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    SELECT * INTO g_qdb.* FROM qdb_file
     WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011 AND qdb012=g_qdb.qdb012
       AND qdb013=g_qdb.qdb013
    IF g_qdb.qdbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qdb.qdb01,9027,0)
       RETURN
    END IF
 
    IF g_qdb.qdbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qdb.qdbconf='Y' THEN RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_qdb01_t = g_qdb.qdb01
    LET g_qdb011_t = g_qdb.qdb011
    LET g_qdb012_t = g_qdb.qdb012
    LET g_qdb013_t = g_qdb.qdb013
    LET g_qdb_o.* = g_qdb.*
 
    BEGIN WORK
 
    OPEN t600_cl USING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t600_cl INTO g_qdb.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t600_cl
        RETURN
    END IF
 
    CALL t600_show()
 
    WHILE TRUE
        LET g_qdb01_t = g_qdb.qdb01
        LET g_qdb011_t = g_qdb.qdb011
        LET g_qdb012_t = g_qdb.qdb012
        LET g_qdb013_t = g_qdb.qdb013
        LET g_qdb.qdbmodu=g_user
        LET g_qdb.qdbdate=g_today
 
        CALL t600_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_qdb.*=g_qdb_t.*
            CALL t600_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_qdb.qdb01 != g_qdb01_t OR g_qdb.qdb011!=g_qdb011_t OR
           g_qdb.qdb012 != g_qdb012_t OR g_qdb.qdb013 != g_qdb013_t THEN
           UPDATE qdc_file SET qdc01=g_qdb.qdb01,
                               qdc011=g_qdb.qdb011,
                               qdc012=g_qdb.qdb012,
#                              qdb013=g_qdb.qdb013   #No.TQC-950150 mark
                               qdc013=g_qdb.qdb013  #No.TQC-950150 add
            WHERE qdc01 = g_qdb01_t
              AND qdc011=g_qdb011_t
              AND qdc012= g_qdb012_t
#             AND qdb013=g_qdb013_t         #No.TQC-950150 mark
              AND qdc013=g_qdb013_t         #No.TQC-950150 add  
            IF SQLCA.sqlcode THEN
#              CALL cl_err('qdc',SQLCA.sqlcode,0)   #No.FUN-660115
               CALL cl_err3("upd","qdc_file",g_qdb01_t,g_qdb011_t,SQLCA.sqlcode,"","qdc",1)  #No.FUN-660115
               CONTINUE WHILE
            END IF
        END IF
 
        UPDATE qdb_file SET qdb_file.* = g_qdb.*
            WHERE qdb01 = g_qdb01_t AND qdb011 = g_qdb011_t AND qdb012 = g_qdb012_t AND qdb013 = g_qdb013_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("upd","qdb_file",g_qdb01_t,g_qdb011_t,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    CLOSE t600_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION t600_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)
    m_azf03         LIKE azf_file.azf03,
    m_ima02         LIKE ima_file.ima02,
    m_ima021        LIKE ima_file.ima021
 
    DISPLAY BY NAME
       g_qdb.qdb00,g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
       g_qdb.qdb02,g_qdb.qdb03,g_qdb.qdb04,g_qdb.qdb05,
       g_qdb.qdb06,g_qdb.qdb07,g_qdb.qdb071,g_qdb.qdb072,
       g_qdb.qdb08,g_qdb.qdb081,g_qdb.qdb082,g_qdb.qdbconf,
       g_qdb.qdbuser,g_qdb.qdbgrup,g_qdb.qdbmodu,g_qdb.qdbdate,g_qdb.qdbacti
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT BY NAME g_qdb.qdboriu,g_qdb.qdborig,
       g_qdb.qdb00,g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
       g_qdb.qdb02,g_qdb.qdb03,g_qdb.qdb04,g_qdb.qdb05,
       g_qdb.qdb06,g_qdb.qdb07,g_qdb.qdb071,g_qdb.qdb072,
       g_qdb.qdb08,g_qdb.qdb081,g_qdb.qdb082,g_qdb.qdbconf,
       g_qdb.qdbuser,g_qdb.qdbgrup,g_qdb.qdbmodu,g_qdb.qdbdate,g_qdb.qdbacti
       WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t600_set_entry(p_cmd)
            CALL t600_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550063--begin
            CALL cl_set_docno_format("qdb01")
#No.FUN-550063--end
 
 
        BEFORE FIELD qdb00
            CALL t600_set_entry(p_cmd)
 
        AFTER FIELD qdb00
            IF NOT cl_null(g_qdb.qdb00) THEN
               IF g_qdb.qdb00 NOT MATCHES '[12345]' THEN  #No.FUN-5C0078
                  NEXT FIELD qdb00
               END IF
               CALL t600_set_no_entry(p_cmd)
            END IF
 
        AFTER FIELD qdb01
            IF NOT cl_null(g_qdb.qdb01) THEN
               CASE g_qdb.qdb00
                    WHEN '1'
                         SELECT COUNT(*) INTO g_cnt FROM qcs_file
                            WHERE qcs01=g_qdb.qdb01 AND qcs14 <> 'X'
                              AND qcs00<'5'  #No.FUN-5C0078
                         IF g_cnt=0 THEN
                            CALL cl_err(g_qdb.qdb01,'mfg3070',0)
                            NEXT FIELD qdb01
                         END IF
                    WHEN '2'
                         SELECT qcf021 INTO g_qdb.qdb02 FROM qcf_file
                            WHERE qcf01=g_qdb.qdb01 AND qcf14 <> 'X'
                         IF STATUS THEN
#                           CALL cl_err(g_qdb.qdb01,'mfg3070',0)   #No.FUN-660115
                            CALL cl_err3("sel","qcf_file",g_qdb.qdb01,"","mfg3070","","",1)  #No.FUN-660115
                            NEXT FIELD qdb01
                         END IF
                    WHEN '3'
                         SELECT qcm021 INTO g_qdb.qdb02 FROM qcm_file
                            WHERE qcm01=g_qdb.qdb01 AND qcm14 <> 'X'
                         IF STATUS THEN
#                           CALL cl_err(g_qdb.qdb01,'mfg3070',0)   #No.FUN-660115
                            CALL cl_err3("sel","qcm_file",g_qdb.qdb01,"","mfg3070","","",1)  #No.FUN-660115
                            NEXT FIELD qdb01
                         END IF
#No.FUN-5C0078-begin
                    WHEN '4'
                         SELECT COUNT(*) INTO g_cnt FROM qcs_file
                            WHERE qcs01=g_qdb.qdb01 AND qcs14 <> 'X'
                              AND (qcs00='5' OR qcs00='6')
                         IF g_cnt=0 THEN
                            CALL cl_err(g_qdb.qdb01,'mfg3070',0)
                            NEXT FIELD qdb01
                         END IF
                    WHEN '5'
                         SELECT COUNT(*) INTO g_cnt FROM qcs_file
                            WHERE qcs01=g_qdb.qdb01 AND qcs14 <> 'X'
                              AND (qcs00='A' OR qcs00='B' OR qcs00='C' OR qcs00='D' OR
                                   qcs00='E' OR qcs00='F' OR qcs00='G' OR qcs00='Z')
                         IF g_cnt=0 THEN
                            CALL cl_err(g_qdb.qdb01,'mfg3070',0)
                            NEXT FIELD qdb01
                         END IF
#No.FUN-5C0078-end
               END CASE
               SELECT ima02,ima021 INTO m_ima02,m_ima021 FROM ima_file
                WHERE ima01=g_qdb.qdb02
               IF STATUS THEN LET m_ima02='' LET m_ima021='' END IF
 
               DISPLAY BY NAME g_qdb.qdb02
               DISPLAY m_ima02 TO FORMONLY.ima02
               DISPLAY m_ima021 TO FORMONLY.ima021
               LET g_qdb_o.qdb01=g_qdb.qdb01
 
            END IF
 
        AFTER FIELD qdb011
            IF NOT cl_null(g_qdb.qdb011) THEN
#No.FUN-5C0078-begin
#              SELECT COUNT(*) INTO g_cnt FROM qcs_file
#                 WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
#                   AND qcs14 <> 'X'
#              IF g_cnt=0 THEN
#                 CALL cl_err(g_qdb.qdb01,'mfg3070',0)
#                 NEXT FIELD qdb01
#              END IF
               CASE g_qdb.qdb00
                    WHEN '1'
                      SELECT COUNT(*) INTO g_cnt FROM qcs_file
                         WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
                           AND qcs14 <> 'X'
                           AND qcs05<'5'
                    WHEN '4'
                      SELECT COUNT(*) INTO g_cnt FROM qcs_file
                         WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
                           AND qcs14 <> 'X'
                           AND (qcs00='5' OR qcs00='6')
                    WHEN '5'
                      SELECT COUNT(*) INTO g_cnt FROM qcs_file
                         WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
                           AND qcs14 <> 'X'
                           AND (qcs00='A' OR qcs00='B' OR qcs00='C' OR qcs00='D' OR
                                qcs00='E' OR qcs00='F' OR qcs00='G' OR qcs00='Z')
               END CASE
#No.FUN-5C0078-end
               IF g_cnt=0 THEN
                  CALL cl_err(g_qdb.qdb01,'mfg3070',0)
                  NEXT FIELD qdb01
               END IF
            END IF
 
        AFTER FIELD qdb012
            IF NOT cl_null(g_qdb.qdb012) THEN
#No.FUN-5C0078-begin
#              SELECT qcs021 INTO g_qdb.qdb02 FROM qcs_file
#               WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
#                 AND qcs05=g_qdb.qdb012 AND qcs14 <> 'X'
               CASE g_qdb.qdb00
                    WHEN '1'
                      SELECT qcs021 INTO g_qdb.qdb02 FROM qcs_file
                       WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
                         AND qcs05=g_qdb.qdb012 AND qcs14 <> 'X'
                         AND qcs05<'5'
                    WHEN '4'
                      SELECT qcs021 INTO g_qdb.qdb02 FROM qcs_file
                       WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
                         AND qcs05=g_qdb.qdb012 AND qcs14 <> 'X'
                         AND (qcs00='5' OR qcs00='6')
                    WHEN '5'
                      SELECT qcs021 INTO g_qdb.qdb02 FROM qcs_file
                       WHERE qcs01=g_qdb.qdb01 AND qcs02=g_qdb.qdb011
                         AND qcs05=g_qdb.qdb012 AND qcs14 <> 'X'
                         AND (qcs00='A' OR qcs00='B' OR qcs00='C' OR qcs00='D' OR
                              qcs00='E' OR qcs00='F' OR qcs00='G' OR qcs00='Z')
               END CASE
#No.FUN-5C0078-end
               IF STATUS THEN
#                 CALL cl_err(g_qdb.qdb01,'mfg3070',0)   #No.FUN-660115
                  CALL cl_err3("sel","qcs_file",g_qdb.qdb01,g_qdb.qdb011,"mfg3070","","",1)  #No.FUN-660115
                  NEXT FIELD qdb01
               ELSE
                  SELECT ima02,ima021 INTO m_ima02,m_ima021 FROM ima_file
                   WHERE ima01=g_qdb.qdb02
                  IF STATUS THEN LET m_ima02='' LET m_ima021='' END IF
                  DISPLAY BY NAME g_qdb.qdb02
                  DISPLAY m_ima02 TO FORMONLY.ima02
                  DISPLAY m_ima021 TO FORMONLY.ima021
               END IF
            END IF
 
        AFTER FIELD qdb013
            IF NOT cl_null(g_qdb.qdb013) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_qdb.qdb01 != g_qdb01_t OR
                                   g_qdb.qdb011!= g_qdb011_t OR
                                   g_qdb.qdb012!= g_qdb012_t OR
                                   g_qdb.qdb013!= g_qdb013_t)) THEN
                   CASE g_qdb.qdb00
#No.FUN-5C0078-begin
#                       WHEN '1'
#                            SELECT qct04,azf03 INTO g_qdb.qdb09, m_azf03
#                               FROM qct_file, OUTER azf_file
#                              WHERE qct01=g_qdb.qdb01 AND qct02=g_qdb.qdb011
#                                AND qct021=g_qdb.qdb012 AND qct03=g_qdb.qdb013
#                                AND qct_file.qct04=azf_file.azf01 AND azf_file.azf02='6'
#No.FUN-5C0078-end
                        WHEN '2'
                             SELECT qcg04,azf03 INTO g_qdb.qdb09, m_azf03
                                FROM qcg_file, OUTER azf_file
                               WHERE qcg01=g_qdb.qdb01
                                 AND qcg03=g_qdb.qdb013
                                 AND qcg_file.qcg04=azf_file.azf01 AND azf_file.azf02='6'
                             LET g_tabname = "qcg_file"  #No.FUN-660115
                        WHEN '3'
                             SELECT qcn04,azf03 INTO g_qdb.qdb09, m_azf03
                                FROM qcn_file, OUTER azf_file
                               WHERE qcn01=g_qdb.qdb01
                                 AND qcn03=g_qdb.qdb013
                                 AND qcn_file.qcn04=azf_file.azf01 AND azf_file.azf02='6'
                             LET g_tabname = "qcn_file"  #No.FUN-660115
#No.FUN-5C0078-begin
                       OTHERWISE
                            SELECT qct04,azf03 INTO g_qdb.qdb09, m_azf03
                               FROM qct_file, OUTER azf_file
                              WHERE qct01=g_qdb.qdb01 AND qct02=g_qdb.qdb011
                                AND qct021=g_qdb.qdb012 AND qct03=g_qdb.qdb013
                                AND qct_file.qct04=azf_file.azf01 AND azf_file.azf02='6'
                             LET g_tabname = "qct_file"  #No.FUN-660115
#No.FUN-5C0078-end
                   END CASE
                   IF STATUS THEN
                      LET g_msg=g_qdb.qdb01 CLIPPED,'+',g_qdb.qdb011 CLIPPED,'+',
                                g_qdb.qdb012 CLIPPED,'+',g_qdb.qdb013 CLIPPED
#                     CALL cl_err(g_msg,STATUS,0)   #No.FUN-660115
                      CALL cl_err3("sel",g_tabname,g_qdb.qdb01,g_qdb.qdb013,STATUS,"","",1)  #No.FUN-660115
                      NEXT FIELD qdb01
                   END IF
                   DISPLAY BY NAME g_qdb.qdb09
                   DISPLAY m_azf03 TO FORMONLY.azf03
               END IF
 
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                    (p_cmd = "u" AND (g_qdb.qdb01 != g_qdb01_t)) THEN
                     SELECT COUNT(*) INTO g_cnt FROM qdb_file
                         WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
                           AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
                     IF g_cnt > 0 THEN
                        LET g_msg=g_qdb.qdb01 CLIPPED,'+',g_qdb.qdb011 CLIPPED,'+',
                                  g_qdb.qdb012 CLIPPED,'+',g_qdb.qdb013 CLIPPED
                        CALL cl_err(g_msg,-239,0)
                        NEXT FIELD qdb01
                     END IF
 
               END IF
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qdb01) #單號
                 CASE g_qdb.qdb00
                      WHEN '1'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_qcs1"
                           LET g_qryparam.default1 = g_qdb.qdb01
                           LET g_qryparam.default2 = g_qdb.qdb011
                           LET g_qryparam.default3 = g_qdb.qdb012
                           LET g_qryparam.where = " qcs00<'5' "  #No.FUN-5C0078
                           CALL cl_create_qry() RETURNING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012
#                           CALL FGL_DIALOG_SETBUFFER( g_qdb.qdb01 )
#                           CALL FGL_DIALOG_SETBUFFER( g_qdb.qdb011 )
#                           CALL FGL_DIALOG_SETBUFFER( g_qdb.qdb012 )
                           DISPLAY BY NAME g_qdb.qdb01, g_qdb.qdb011, g_qdb.qdb012
                           NEXT FIELD qdb01
                      WHEN '2'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_qcf1"
                           LET g_qryparam.default1 = g_qdb.qdb01
                           CALL cl_create_qry() RETURNING g_qdb.qdb01
#                           CALL FGL_DIALOG_SETBUFFER( g_qdb.qdb01 )
                           DISPLAY BY NAME g_qdb.qdb01
                           NEXT FIELD qdb01
                      WHEN '3'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_qcm1"
                           LET g_qryparam.default1 = g_qdb.qdb01
                           CALL cl_create_qry() RETURNING g_qdb.qdb01
#                           CALL FGL_DIALOG_SETBUFFER( g_qdb.qdb01 )
                           DISPLAY BY NAME g_qdb.qdb01
                           NEXT FIELD qdb01
#No.FUN-5C0078-begin
                      WHEN '4'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_qcs1"
                           LET g_qryparam.default1 = g_qdb.qdb01
                           LET g_qryparam.default2 = g_qdb.qdb011
                           LET g_qryparam.default3 = g_qdb.qdb012
                           LET g_qryparam.where = " qcs00='5' OR qcs00='6' "
                           CALL cl_create_qry() RETURNING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012
                           DISPLAY BY NAME g_qdb.qdb01, g_qdb.qdb011, g_qdb.qdb012
                           NEXT FIELD qdb01
                      WHEN '5'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_qcs1"
                           LET g_qryparam.default1 = g_qdb.qdb01
                           LET g_qryparam.default2 = g_qdb.qdb011
                           LET g_qryparam.default3 = g_qdb.qdb012
                           LET g_qryparam.where = " qcs00='A' OR qcs00='B' OR qcs00='C' OR qcs00='D' OR qcs00='E' OR qcs00='F' OR qcs00='G' OR qcs00='Z' "
                           CALL cl_create_qry() RETURNING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012
                           DISPLAY BY NAME g_qdb.qdb01, g_qdb.qdb011, g_qdb.qdb012
                           NEXT FIELD qdb01
#No.FUN-5C0078-end
                 END CASE
              OTHERWISE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
 
#Query 查詢
FUNCTION t600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qdb.* TO NULL               #NO.FUN-6A0160
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_qdc.clear()
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t600_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_qdb.qdb01 = NULL               #MOD-660086 add
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
    OPEN t600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_qdb.* TO NULL
    ELSE
       OPEN t600_count
       FETCH t600_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t600_cs INTO g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
        WHEN 'P' FETCH PREVIOUS t600_cs INTO g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
        WHEN 'F' FETCH FIRST    t600_cs INTO g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
        WHEN 'L' FETCH LAST     t600_cs INTO g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
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
            FETCH ABSOLUTE g_jump t600_cs INTO g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)
       INITIALIZE g_qdb.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_qdb.* FROM qdb_file WHERE qdb01 = g_qdb.qdb01 AND qdb011 = g_qdb.qdb011 AND qdb012 = g_qdb.qdb012 AND qdb013 = g_qdb.qdb013
#FUN-4C0038
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,1)   #No.FUN-660115
       CALL cl_err3("sel","qdb_file",g_qdb.qdb01,g_qdb.qdb011,SQLCA.sqlcode,"","",1)  #No.FUN-660115
       INITIALIZE g_qdb.* TO NULL
    ELSE
       LET g_data_owner = g_qdb.qdbuser      #FUN-4C0038
       LET g_data_group = g_qdb.qdbgrup      #FUN-4C0038
       LET g_data_plant = g_qdb.qdbplant #FUN-980030
       CALL t600_show()                      # 重新顯示
    END IF
##
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t600_show()
   DEFINE m_ima02         LIKE ima_file.ima02,
          m_ima021        LIKE ima_file.ima021,
          m_azf03         LIKE azf_file.azf03
 
    LET g_qdb_t.* = g_qdb.*                #保存單頭舊值
    DISPLAY BY NAME g_qdb.qdboriu,g_qdb.qdborig,                              # 顯示單頭值
        g_qdb.qdb00,g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
        g_qdb.qdb02,g_qdb.qdb03,g_qdb.qdb04,g_qdb.qdb05,
        g_qdb.qdb06,g_qdb.qdb09,g_qdb.qdb07,g_qdb.qdb071,g_qdb.qdb072,
        g_qdb.qdb08,g_qdb.qdb081,g_qdb.qdb082,g_qdb.qdbconf,
        g_qdb.qdbuser,g_qdb.qdbgrup,g_qdb.qdbmodu,g_qdb.qdbdate,g_qdb.qdbacti
 
    #-------------------------------------------------------------
    SELECT ima02,ima021 INTO m_ima02,m_ima021 FROM ima_file
     WHERE ima01=g_qdb.qdb02
    IF STATUS=100 THEN LET m_ima02 = ' ' LET m_ima021=' ' END IF
 
    DISPLAY m_ima02 TO FORMONLY.ima02
    DISPLAY m_ima021 TO FORMONLY.ima021
    SELECT azf03 INTO m_azf03 FROM azf_file WHERE azf01=g_qdb.qdb09 AND azf02='6' #6818
    IF STATUS=100 THEN LET m_azf03 = ' ' END IF
    DISPLAY m_azf03 TO FORMONLY.azf03
    #-------------------------------------------------------------
    IF g_qdb.qdbconf= 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
 
    CALL t600_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t600_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_qdb.qdb01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
 
    SELECT * INTO g_qdb.* FROM qdb_file
     WHERE qdb01=g_qdb.qdb01
       AND qdb011=g_qdb.qdb011
       AND qdb012=g_qdb.qdb012
       AND qdb013=g_qdb.qdb013
    IF g_qdb.qdbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qdb.qdb01,9027,0)
       RETURN
    END IF
 
    IF g_qdb.qdbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qdb.qdbconf='Y' THEN RETURN END IF
 
    BEGIN WORK
 
    OPEN t600_cl USING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t600_cl INTO g_qdb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
 
    CALL t600_show()
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qdb01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "qdb011"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "qdb012"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "qdb013"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qdb.qdb01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_qdb.qdb011      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_qdb.qdb012      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_qdb.qdb013      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM qdb_file
        WHERE qdb01 = g_qdb.qdb01
          AND qdb011=g_qdb.qdb011
          AND qdb012=g_qdb.qdb012
          AND qdb013=g_qdb.qdb013
 
       DELETE FROM qdc_file
        WHERE qdc01 = g_qdb.qdb01
          AND qdc011=g_qdb.qdb011
          AND qdc012=g_qdb.qdb012
          AND qdc013=g_qdb.qdb013
 
       DELETE FROM qdd_file
        WHERE qdd01 = g_qdb.qdb01
          AND qdd011=g_qdb.qdb011
          AND qdd012=g_qdb.qdb012
          AND qdd013=g_qdb.qdb013
 
       INITIALIZE g_qdb.* TO NULL
       CLEAR FORM
       CALL g_qdc.clear()
 
    END IF
 
    CLOSE t600_cl
    COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION t600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT      #No.FUN-680104 SMALLINT
    l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi LIKE type_file.num5,          #No.FUN-680104 SMALLINT         #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否         #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否         #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qdb.qdb01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_qdb.* FROM qdb_file
     WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
       AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
    IF g_qdb.qdbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qdb.qdb01,'aom-000',0)
       RETURN
    END IF
 
    IF g_qdb.qdbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qdb.qdbconf='Y' THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT qdc02,qdc03,qdc04,qdc05,qdc06,qdc07,qdc08 ",
                       " FROM qdc_file ",
                       "  WHERE qdc01= ?  AND qdc011= ? AND qdc012= ? ",
                       " AND qdc013= ? AND qdc02= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qdc WITHOUT DEFAULTS FROM s_qdc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t600_cl USING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
            IF STATUS THEN
               CALL cl_err("OPEN t600_cl:", STATUS, 1)
               CLOSE t600_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t600_cl INTO g_qdb.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t600_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_qdc_t.* = g_qdc[l_ac].*  #BACKUP
               OPEN t600_bcl USING g_qdb.qdb01, g_qdb.qdb011, g_qdb.qdb012,
                                   g_qdb.qdb013, g_qdc_t.qdc02
               IF STATUS THEN
                  CALL cl_err("OPEN t600_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t600_bcl INTO g_qdc[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_qdc_t.qdc02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qdc[l_ac].* TO NULL      #900423
            LET g_qdc[l_ac].qdc03=g_today
            LET g_qdc[l_ac].qdc04=TIME
            LET g_qdc_t.* = g_qdc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qdc02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_qdc.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
             INSERT INTO qdc_file (qdc01,qdc011,qdc012,qdc013,qdc02,qdc03,  #No:BUG-470041 #No.MOD-470607
                                  qdc04,qdc05,qdc06,qdc07,qdc08,qdc09,qdc10,
                                  qdcplant,qdclegal)  #FUN-980007
                 VALUES(g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
                        g_qdc[l_ac].qdc02,g_qdc[l_ac].qdc03,g_qdc[l_ac].qdc04,
                        g_qdc[l_ac].qdc05,g_qdc[l_ac].qdc06,g_qdc[l_ac].qdc07,
                        g_qdc[l_ac].qdc08,'','',
                        g_plant,g_legal)              #FUN-980007
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_qdc[l_ac].qdc02,SQLCA.sqlcode,0)   #No.FUN-660115
               CALL cl_err3("ins","qdc_file",g_qdb.qdb01,g_qdc[l_ac].qdc02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #
            END IF
 
        BEFORE FIELD qdc02                        #default 序號
            IF g_qdc[l_ac].qdc02 IS NULL OR
               g_qdc[l_ac].qdc02 = 0 THEN
                SELECT max(qdc02)+1 INTO g_qdc[l_ac].qdc02 FROM qdc_file
                 WHERE qdc01 = g_qdb.qdb01
                   AND qdc011= g_qdb.qdb011
                   AND qdc012= g_qdb.qdb012
                   AND qdc013= g_qdb.qdb013
                IF g_qdc[l_ac].qdc02 IS NULL THEN
                   LET g_qdc[l_ac].qdc02 = 1
                END IF
            END IF
 
        AFTER FIELD qdc04
            IF NOT cl_null(g_qdc[l_ac].qdc04) THEN
               CALL t600_more_b()
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_qdc_t.qdc02 > 0 AND
               g_qdc_t.qdc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM qdc_file
                 WHERE qdc01 = g_qdb.qdb01
                   AND qdc011= g_qdb.qdb011
                   AND qdc012= g_qdb.qdb012
                   AND qdc013= g_qdb.qdb013
                   AND qdc02 = g_qdc_t.qdc02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qdc_t.qdc03,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qdc_file",g_qdb.qdb01,g_qdc_t.qdc02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   DELETE FROM qdd_file
                    WHERE qdd01 = g_qdb.qdb01
                      AND qdd011= g_qdb.qdb011
                      AND qdd012= g_qdb.qdb012
                      AND qdd013= g_qdb.qdb013
                      AND qdd02 = g_qdc_t.qdc02
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qdc[l_ac].* = g_qdc_t.*
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qdc[l_ac].qdc03,-263,1)
               LET g_qdc[l_ac].* = g_qdc_t.*
            ELSE
 
               UPDATE qdc_file SET qdc02=g_qdc[l_ac].qdc02,
                                   qdc03=g_qdc[l_ac].qdc03,
                                   qdc04=g_qdc[l_ac].qdc04,
                                   qdc05=g_qdc[l_ac].qdc05,
                                   qdc06=g_qdc[l_ac].qdc06,
                                   qdc07=g_qdc[l_ac].qdc07,
                                   qdc08=g_qdc[l_ac].qdc08
                WHERE qdc01=g_qdb.qdb01 AND
                      qdc011=g_qdb.qdb011 AND
                      qdc012=g_qdb.qdb012 AND
                      qdc013=g_qdb.qdb013 AND
                      qdc02=g_qdc_t.qdc02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qdc[l_ac].qdc02,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("upd","qdc_file",g_qdb.qdb01,g_qdc_t.qdc02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   LET g_qdc[l_ac].* = g_qdc_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qdc[l_ac].* = g_qdc_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qdc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D30034
            CLOSE t600_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL t600_b_askkey()
#           EXIT INPUT
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
   #start FUN-5B0136
    LET g_qdb.qdbmodu = g_user
    LET g_qdb.qdbdate = g_today
    UPDATE qdb_file SET qdbmodu = g_qdb.qdbmodu,qdbdate = g_qdb.qdbdate
     WHERE qdb01 = g_qdb.qdb01 AND qdb011 = g_qdb.qdb011 AND qdb012 = g_qdb.qdb012 AND qdb013 = g_qdb.qdb013
    DISPLAY BY NAME g_qdb.qdbmodu,g_qdb.qdbdate
   #end FUN-5B0136
 
    CLOSE t600_bcl
    COMMIT WORK
 
    CALL t600_count()
    CALL t600_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t600_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t600_x()   #FUN-D20025
         CALL t600_x(1)  #FUN-D20025
         IF g_qdb.qdbconf= 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM qdb_file 
                WHERE qdb01 = g_qdb.qdb01 AND qdb011 = g_qdb.qdb011 
                  AND qdb012 = g_qdb.qdb012 AND qdb013 = g_qdb.qdb013
         INITIALIZE g_qdb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t600_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON qdc02,qdc03,qdc04,qdc05,qdc06,qdc07,qdc08
            FROM s_qdc[1].qdc02,s_qdc[1].qdc03,s_qdc[1].qdc04,s_qdc[1].qdc05,
                 s_qdc[1].qdc06,s_qdc[1].qdc07,s_qdc[1].qdc08
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
 
    CALL t600_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t600_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    IF p_wc2 IS NULL THEN LET p_wc2=" 1=1 " END IF
 
    LET g_sql =
        "SELECT qdc02,qdc03,qdc04,qdc05,qdc06,qdc07,qdc08 ",
        " FROM qdc_file ",
        " WHERE qdc01 ='",g_qdb.qdb01,"'",
        "   AND qdc011='",g_qdb.qdb011,"'",
        "   AND qdc012='",g_qdb.qdb012,"'",
        "   AND qdc013='",g_qdb.qdb013,"'",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE t600_pb FROM g_sql
    DECLARE qdc_curs                       #SCROLL CURSOR
        CURSOR FOR t600_pb
 
    CALL g_qdc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH qdc_curs INTO g_qdc[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_qdc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qdc TO s_qdc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
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
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t600_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_qdb.qdbconf= 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qdb.qdbconf,"","","",g_void,g_qdb.qdbacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025--add--str--
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025--add--end--
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
     
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t600_y()
 
#CHI-C30107 ----------- add --------------- begin
   IF g_qdb.qdbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_qdb.qdbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ----------- add --------------- end
   SELECT * INTO g_qdb.* FROM qdb_file
    WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
      AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
   IF g_qdb.qdbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_qdb.qdbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   BEGIN WORK
 
   OPEN t600_cl USING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_qdb.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET g_success = 'Y'
 
   UPDATE qdb_file SET qdbconf='Y'
    WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
      AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_qdb.qdbconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_qdb.qdbconf
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_z()
   SELECT * INTO g_qdb.* FROM qdb_file
    WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
      AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
   IF g_qdb.qdbconf = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
   IF g_qdb.qdbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t600_cl USING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_qdb.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   UPDATE qdb_file SET qdbconf='N'
    WHERE qdb01=g_qdb.qdb01 AND qdb011=g_qdb.qdb011
      AND qdb012=g_qdb.qdb012 AND qdb013=g_qdb.qdb013
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_qdb.qdbconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_qdb.qdbconf
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#FUNCTION t600_x()       #FUN-D20025
FUNCTION t600_x(p_type)  #FUN-D20025
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_qdb.* FROM qdb_file WHERE qdb01 = g_qdb.qdb01
 
   IF cl_null(g_qdb.qdb01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_qdb.qdbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_qdb.qdbconf='X' THEN RETURN END IF
   ELSE
      IF g_qdb.qdbconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t600_cl USING g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_qdb.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t600_cl ROLLBACK WORK RETURN
   END IF
 
  #IF cl_void(0,0,g_qdb.qdbconf)   THEN   #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
      LET g_chr=g_qdb.qdbconf
     #IF g_qdb.qdbconf ='N' THEN   #FUN-D20025
      IF p_type = 1 THEN           #FUN-D20025
         LET g_qdb.qdbconf='X'
      ELSE
         LET g_qdb.qdbconf='N'
      END IF
      UPDATE qdb_file
          SET qdbconf  =g_qdb.qdbconf,
              qdbmodu=g_user,
              qdbdate=g_today
          WHERE qdb01  =g_qdb.qdb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_qdb.qdb01,SQLCA.sqlcode,0)   #No.FUN-660115
          CALL cl_err3("upd","qdb_file",g_qdb.qdb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
          LET g_qdb.qdbconf=g_chr
      END IF
      SELECT qdbconf INTO g_qdb.qdbconf FROM qdb_file
       WHERE qdb01 = g_qdb.qdb01
      DISPLAY BY NAME g_qdb.qdbconf
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t600_more_b()
  DEFINE ls_tmp           STRING
  DEFINE l_qdd            DYNAMIC ARRAY OF RECORD
                         qdd03     LIKE qdd_file.qdd03
                          END RECORD
  DEFINE l_n,l_cnt        LIKE type_file.num5          #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5          #No.FUN-680104 SMALLINT
  DEFINE l_min,l_max      LIKE type_file.num10         #No.FUN-680104 INTEGER
  DEFINE l_rec_b          LIKE type_file.num5,         #No.FUN-680104 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680104 SMALLINT
 
   OPEN WINDOW t600_mo AT 04,04 WITH FORM "aqc/42f/aqct6001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct6001")
 
 
   DECLARE t600_mo CURSOR FOR
    SELECT qdd03 FROM qdd_file
     WHERE qdd01=g_qdb.qdb01
       AND qdd011=g_qdb.qdb011
       AND qdd012=g_qdb.qdb012
       AND qdd013=g_qdb.qdb013
       AND qdd02=g_qdc[l_ac].qdc02
 
   CALL l_qdd.clear()
 
   LET i = 1
   LET l_rec_b = 0
   FOREACH t600_mo INTO l_qdd[i].*
      IF STATUS THEN CALL cl_err('foreach qdd',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_rec_b = i - 1
   DISPLAY l_rec_b TO cn2
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qdd WITHOUT DEFAULTS FROM s_qdd.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
 
     BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER ROW
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
        END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   CLOSE WINDOW t600_mo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET g_qdc[l_ac].qdc05=0 LET g_qdc[l_ac].qdc06=0 LET l_min=0 LET l_max=0
   FOR k = 1 TO l_qdd.getLength()
       IF l_qdd[k].qdd03 IS NOT NULL AND l_qdd[k].qdd03 <> 0 THEN
          LET g_qdc[l_ac].qdc06=g_qdc[l_ac].qdc06+l_qdd[k].qdd03
          LET g_qdc[l_ac].qdc05=g_qdc[l_ac].qdc05+1
          IF k=1 THEN
             LET l_min=l_qdd[k].qdd03
             LET l_max=l_qdd[k].qdd03
          END IF
          IF l_qdd[k].qdd03<=l_min THEN
             LET l_min=l_qdd[k].qdd03
          END IF
          IF l_qdd[k].qdd03>=l_max THEN
             LET l_max=l_qdd[k].qdd03
          END IF
       END IF
   END FOR
 
   IF g_qdc[l_ac].qdc05 IS NOT NULL AND g_qdc[l_ac].qdc05 !=0 THEN
      LET g_qdc[l_ac].qdc07=g_qdc[l_ac].qdc06/g_qdc[l_ac].qdc05
   ELSE
      LET g_qdc[l_ac].qdc07=0
   END IF
   LET g_qdc[l_ac].qdc08=l_max-l_min
   #------------------------------------------
   DELETE FROM qdd_file
    WHERE qdd01=g_qdb.qdb01
      AND qdd011=g_qdb.qdb011
      AND qdd012=g_qdb.qdb012
      AND qdd013=g_qdb.qdb013
      AND qdd02=g_qdc[l_ac].qdc02
   FOR i = 1 TO l_qdd.getLength()
       IF l_qdd[i].qdd03 IS NULL OR l_qdd[i].qdd03=0 THEN
          CONTINUE FOR
       END IF
        INSERT INTO qdd_file(qdd01,qdd011,qdd012,qdd013,qdd02,qdd03,  #No.MOD-470041
                             qddplant,qddlegal) #FUN-980007
            VALUES(g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
                   g_qdc[l_ac].qdc02,l_qdd[i].qdd03,
                   g_plant,g_legal)             #FUN-980007
       IF SQLCA.sqlcode THEN
#         CALL cl_err('INS-qdd',SQLCA.sqlcode,0)   #No.FUN-660115
          CALL cl_err3("ins","qdd_file",g_qdb.qdb01,g_qdc[l_ac].qdc02,SQLCA.sqlcode,"","INS-qdd",1)  #No.FUN-660115
          LET g_success = 'N' EXIT FOR
       END IF
 
    END FOR
 
END FUNCTION
 
FUNCTION t600_count()
    DEFINE l_qda    RECORD LIKE qda_file.*
 
    SELECT COUNT(*),SUM(qdc07),SUM(qdc08)
      INTO g_qdb.qdb04,g_qdb.qdb05,g_qdb.qdb06
      FROM qdc_file
     WHERE qdc01=g_qdb.qdb01 AND qdc011=g_qdb.qdb011
       AND qdc012=g_qdb.qdb012 AND qdc013=g_qdb.qdb013
 
    SELECT COUNT(*) INTO g_qdb.qdb03
      FROM qdd_file
     WHERE qdd01=g_qdb.qdb01 AND qdd011=g_qdb.qdb011
       AND qdd012=g_qdb.qdb012 AND qdd013=g_qdb.qdb013
       AND qdd02=(SELECT MIN(qdd02) FROM qdd_file
     WHERE qdd01=g_qdb.qdb01 AND qdd011=g_qdb.qdb011
       AND qdd012=g_qdb.qdb012 AND qdd013=g_qdb.qdb013)
 
    #-------- 管制線計算
    SELECT * INTO l_qda.* FROM qda_file WHERE qda01=g_qdb.qdb03
    IF STATUS THEN
       LET l_qda.qda023=0 LET l_qda.qda045=0 LET l_qda.qda046=0
    END IF
 
    IF g_qdb.qdb04 IS NOT NULL AND g_qdb.qdb04!=0 THEN
       LET g_qdb.qdb07=g_qdb.qdb05/g_qdb.qdb04
       LET g_qdb.qdb08=g_qdb.qdb06/g_qdb.qdb04
 
       LET g_qdb.qdb071=g_qdb.qdb07+l_qda.qda023*g_qdb.qdb08
       LET g_qdb.qdb072=g_qdb.qdb07-l_qda.qda023*g_qdb.qdb08
 
       LET g_qdb.qdb081=l_qda.qda046*g_qdb.qdb08
       LET g_qdb.qdb082=l_qda.qda045*g_qdb.qdb08
    END IF
    #-------------------
 
    DISPLAY BY NAME g_qdb.qdb03,g_qdb.qdb04,g_qdb.qdb05,g_qdb.qdb06,
                    g_qdb.qdb07,g_qdb.qdb071,g_qdb.qdb072,
                    g_qdb.qdb08,g_qdb.qdb081,g_qdb.qdb082
 
    UPDATE qdb_file SET qdb03=g_qdb.qdb03,
                        qdb04=g_qdb.qdb04,
                        qdb05=g_qdb.qdb05,
                        qdb06=g_qdb.qdb06,
                        qdb07=g_qdb.qdb07,
                        qdb071=g_qdb.qdb071,
                        qdb072=g_qdb.qdb072,
                        qdb08=g_qdb.qdb08,
                        qdb081=g_qdb.qdb081,
                        qdb082=g_qdb.qdb082
     WHERE qdb01=g_qdb.qdb01
       AND qdb011=g_qdb.qdb011
       AND qdb012=g_qdb.qdb012
       AND qdb013=g_qdb.qdb013
 
END FUNCTION
 
FUNCTION t600_pi()
DEFINE  ls_tmp              STRING
DEFINE  l_qdc02             LIKE qdc_file.qdc02,
        p_row,p_col         LIKE type_file.num5,         #No.FUN-680104 SMALLINT
        l_qdd               RECORD LIKE qdd_file.*,
        l_qdc               RECORD LIKE qdc_file.*,
        l_tmp               RECORD
                   tmp01    LIKE qdc_file.qdc01,         #No.FUN-680104 VARCHAR(10)
                   tmp011   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp012   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp013   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp02    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp03    LIKE type_file.dat,          #No.FUN-680104 DATE
                   tmp04    LIKE qcs_file.qcs03,         #No.FUN-680104 VARCHAR(08)
                   tmp05    LIKE eco_file.eco05          #No.FUN-680104 DEC(7,2)
               END RECORD,
        l_allow_insert      LIKE type_file.num5,                #可新增否        #No.FUN-680104 SMALLINT
        l_allow_delete      LIKE type_file.num5                 #可刪除否        #No.FUN-680104 SMALLINT
 
   IF cl_null(g_qdb.qdb01) OR cl_null(g_qdb.qdb011) OR cl_null(g_qdb.qdb012)
      OR cl_null(g_qdb.qdb013) THEN
      CALL cl_err('','aqc-052',1)
      RETURN
   END IF
 
   DROP TABLE aqc_tmpi
#No.FUN-680104-begin
   CREATE TEMP TABLE aqc_tmpi(
     tmp01    LIKE type_file.chr1000,
     tmp011   LIKE type_file.num5,  
     tmp012   LIKE type_file.num5,  
     tmp013   LIKE type_file.num5,  
     tmp02    LIKE type_file.num5,  
     tmp03    LIKE type_file.dat,   
     tmp04    LIKE qcs_file.qcs03,
     tmp05    LIKE eco_file.eco05)
#No.FUN-680104-end
   IF STATUS THEN
      CALL cl_err('Create aqc_tmpi',STATUS,1)
      RETURN
   END IF
 
 
#---------------------No.MOD-620066 mark
#  LET p_row = 5 LET p_col = 30
#No.FUN-5C0078-begin
#  CASE g_qdb.qdb00
#    WHEN '1'
#      OPEN WINDOW t600_wi AT p_row,p_col WITH FORM "aqc/42f/aqct600_i"
#            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    WHEN '4'
#      OPEN WINDOW t600_wi AT p_row,p_col WITH FORM "aqc/42f/aqct600_x"
#            ATTRIBUTE (STYLE = g_win_style CLIPPED)
#    WHEN '5'
#      OPEN WINDOW t600_wi AT p_row,p_col WITH FORM "aqc/42f/aqct600_y"
#            ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  END CASE
#No.FUN-5C0078-end
 
#   CALL cl_ui_locale("aqct600_i")
 
#
#  CLEAR FORM
#  CALL g_qdc.clear()
#  WHILE TRUE
#     CONSTRUCT BY NAME g_wc ON qcs01,qcs04
#             #No.FUN-580031 --start--     HCN
#             BEFORE CONSTRUCT
#                CALL cl_qbe_init()
#             #No.FUN-580031 --end--       HCN
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
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
#
#       	#No.FUN-580031 --start--     HCN
#               ON ACTION qbe_select
#        	   CALL cl_qbe_select()
#               ON ACTION qbe_save
#       	   CALL cl_qbe_save()
#       	#No.FUN-580031 --end--       HCN
#     END CONSTRUCT
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW t600_wi
#        EXIT PROGRAM
#     END IF
#     IF g_wc=" 1=1" THEN
#        CALL cl_err('','9046',0) CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
#  END WHILE
#-------------------------No.MOD-620066 end
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
 
   CALL cl_wait()
 
   LET g_success ='Y'
 
   BEGIN WORK
 
   #----------------------先宣告所須資料的 Cursor----------------------
#No.FUN-5C0078-begin
   CASE g_qdb.qdb00
     WHEN '1'
         LET g_sql= "SELECT qct01,qct02,qct021,qct03,'',qcs04,qcs041,qctt04 ",
                    "  FROM qcs_file,qct_file,qctt_file ",
                    " WHERE qcs01=qct01 AND qcs02=qct02 AND qcs05=qct021 ",
                    "   AND qct01=qctt01 AND qct02=qctt02 AND qct021=qctt021 ",
                    "   AND qcs00<'5' ",  #No.FUN-5C0078
                  #-------------No.MOD-620066 modify----------------
                    "   AND qcs01='",g_qdb.qdb01  CLIPPED,"'",
                    "   AND qcs02=",g_qdb.qdb011 CLIPPED,
                    "   AND qcs05=",g_qdb.qdb012 CLIPPED,
                    "   AND qct03=",g_qdb.qdb013 CLIPPED,
                   #"   AND qct03=qctt03 AND ",g_wc CLIPPED
                    "   AND qct03=qctt03 "
                  #-------------No.MOD-620066 modify----------------
     WHEN '4'
         LET g_sql= "SELECT qct01,qct02,qct021,qct03,'',qcs04,qcs041,qctt04 ",
                    "  FROM qcs_file,qct_file,qctt_file ",
                    " WHERE qcs01=qct01 AND qcs02=qct02 AND qcs05=qct021 ",
                    "   AND qct01=qctt01 AND qct02=qctt02 AND qct021=qctt021 ",
                    "   AND (qcs00='5' OR qcs00='6') ",
                  #-------------No.MOD-620066 modify----------------
                    "   AND qcs01='",g_qdb.qdb01  CLIPPED,"'",
                    "   AND qcs02=",g_qdb.qdb011 CLIPPED,
                    "   AND qcs05=",g_qdb.qdb012 CLIPPED,
                    "   AND qct03=",g_qdb.qdb013 CLIPPED,
                   #"   AND qct03=qctt03 AND ",g_wc CLIPPED
                    "   AND qct03=qctt03 "
                  #-------------No.MOD-620066 modify----------------
     WHEN '5'
         LET g_sql= "SELECT qct01,qct02,qct021,qct03,'',qcs04,qcs041,qctt04 ",
                    "  FROM qcs_file,qct_file,qctt_file ",
                    " WHERE qcs01=qct01 AND qcs02=qct02 AND qcs05=qct021 ",
                    "   AND qct01=qctt01 AND qct02=qctt02 AND qct021=qctt021 ",
                    "   AND (qcs00='A' OR qcs00='B' OR qcs00='C' OR qcs00='D'  ",
                    "     OR qcs00='E' OR qcs00='F' OR qcs00='G' OR qcs00='Z')  ",
                  #-------------No.MOD-620066 modify----------------
                    "   AND qcs01='",g_qdb.qdb01  CLIPPED,"'",
                    "   AND qcs02=",g_qdb.qdb011 CLIPPED,
                    "   AND qcs05=",g_qdb.qdb012 CLIPPED,
                    "   AND qct03=",g_qdb.qdb013 CLIPPED,
                   #"   AND qct03=qctt03 AND ",g_wc CLIPPED
                    "   AND qct03=qctt03 "
                  #-------------No.MOD-620066 modify----------------
    END CASE
#No.FUN-5C0078-end
   PREPARE t600_pretmpi FROM g_sql
   DECLARE t600_tmpi CURSOR FOR t600_pretmpi
 
   LET g_sql= "SELECT tmp01,tmp011,tmp012,tmp013,tmp02,tmp03,tmp04, ",
              " COUNT(tmp05),SUM(tmp05),AVG(tmp05),MAX(tmp05)-MIN(tmp05) ",
              "  FROM aqc_tmpi ",
              " GROUP BY tmp01,tmp011,tmp012,tmp013,tmp02,tmp03,tmp04 "
   PREPARE t600_preqcti FROM g_sql
   DECLARE t600_qcti CURSOR FOR t600_preqcti
 
   LET g_sql= "SELECT tmp01,tmp011,tmp012,tmp013,tmp02,tmp05 ",
              "  FROM aqc_tmpi "
   PREPARE t600_preqdci FROM g_sql
   DECLARE t600_qdci CURSOR FOR t600_preqdci
 
   #--------------------------------------------------------------------
   DELETE FROM aqc_tmpi
   FOREACH t600_tmpi INTO l_tmp.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      INSERT INTO aqc_tmpi VALUES(l_tmp.*)
      IF STATUS THEN
#        CALL cl_err('ins tmp:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","aqc_tmpi","","",SQLCA.sqlcode,"","ins tmp",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
    END FOREACH
 
   LET l_qdc02=1
   FOREACH t600_qcti INTO l_qdc.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      LET l_qdc.qdc02=l_qdc02
      INSERT INTO qdc_file(qdc01,qdc011,qdc012,qdc013,qdc02,qdc03,qdc04,
                           qdc05,qdc06,qdc07,qdc08,
                           qdcplant,qdclegal) #FUN-980007
          VALUES(g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
                 l_qdc02,l_qdc.qdc03,l_qdc.qdc04,l_qdc.qdc05,l_qdc.qdc06,
                 l_qdc.qdc07,l_qdc.qdc08,
                 g_plant,g_legal)             #FUN-980007
      IF STATUS THEN
#        CALL cl_err('ins qdc:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","qdc_file",g_qdb.qdb01,l_qdc02,STATUS,"","ins qdc",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      UPDATE aqc_tmpi SET tmp02=l_qdc02
       WHERE tmp01=l_qdc.qdc01 AND tmp011=l_qdc.qdc011
         AND tmp012=l_qdc.qdc012 AND tmp013=l_qdc.qdc013
      IF STATUS THEN
#        CALL cl_err('upd tmp:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("upd","aqc_tmpi",l_qdc.qdc01,l_qdc.qdc011,STATUS,"","upd tmp",1)  #No.FUN-660115
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      LET l_qdc02=l_qdc02+1
 
   END FOREACH
 
   FOREACH t600_qdci INTO l_qdd.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      INSERT INTO qdd_file(qdd01,qdd011,qdd012,qdd013,qdd02,qdd03,
                           qddplant,qddlegal) #FUN-980007
           VALUES(g_qdb.qdb01,g_qdb.qdb011,g_qdb.qdb012,g_qdb.qdb013,
                  l_qdd.qdd02,l_qdd.qdd03,
                  g_plant,g_legal)            #FUN-980007
      IF STATUS THEN
#        CALL cl_err('ins qdd:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","qdd_file",g_qdb.qdb01,l_qdd.qdd02,STATUS,"","ins qdd",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
 
   ERROR ""
   CALL cl_end(18,20)
 
   CLOSE WINDOW t600_wi
 
   CALL t600_show()
 
END FUNCTION
 
FUNCTION t600_pf()
DEFINE  ls_tmp          STRING
DEFINE  l_qdc02         LIKE qdc_file.qdc02,
        p_row,p_col     LIKE type_file.num5,             #No.FUN-680104 SMALLINT
        l_qdd           RECORD LIKE qdd_file.*,
        l_qdc           RECORD LIKE qdc_file.*,
        l_tmp   RECORD
                   tmp01    LIKE qdc_file.qdc01,         #No.FUN-680104 VARCHAR(10)
                   tmp011   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp012   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp013   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp02    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp03    LIKE type_file.dat,          #No.FUN-680104 DATE
                   tmp04    LIKE qcs_file.qcs03,         #No.FUN-680104 VARCHAR(8)
                   tmp05    LIKE eco_file.eco05          #No.FUN-680104 DEC(7,2)
               END RECORD
 
   IF cl_null(g_qdb.qdb01) OR cl_null(g_qdb.qdb013) THEN
      CALL cl_err('','aqc-052',1)
      RETURN
   END IF
 
   DROP TABLE aqc_tmpf
#No.FUN-680104-begin
   CREATE TEMP TABLE aqc_tmpf(
     tmp01    LIKE qcs_file.qcs03,
     tmp011   LIKE type_file.num5,  
     tmp012   LIKE type_file.num5,  
     tmp013   LIKE type_file.num5,  
     tmp02    LIKE type_file.num5,  
     tmp03    LIKE type_file.dat,   
     tmp04    LIKE qcs_file.qcs03,
     tmp05    LIKE eco_file.eco05)
#No.FUN-680104-end
   IF STATUS THEN
      CALL cl_err('Create aqc_tmpf',STATUS,1)
      RETURN
   END IF
 
#---------------------No.MOD-620066 mark
#  LET p_row = 5 LET p_col = 30
#  OPEN WINDOW t600_wf AT p_row,p_col WITH FORM "aqc/42f/aqct600_f"
#        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#   CALL cl_ui_locale("aqct600_f")
 
#
#  CLEAR FORM
#  CALL g_qdc.clear()
 
#  WHILE TRUE
#     CONSTRUCT BY NAME g_wc ON qcf01,qcf04
#             #No.FUN-580031 --start--     HCN
#             BEFORE CONSTRUCT
#                CALL cl_qbe_init()
#             #No.FUN-580031 --end--       HCN
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
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
#
#       	#No.FUN-580031 --start--     HCN
#               ON ACTION qbe_select
#        	   CALL cl_qbe_select()
#               ON ACTION qbe_save
#       	   CALL cl_qbe_save()
#       	#No.FUN-580031 --end--       HCN
#     END CONSTRUCT
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW t600_wf
#        RETURN
#     END IF
#     IF g_wc=" 1=1" THEN
#        CALL cl_err('','9046',0) CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
#  END WHILE
#---------------------No.MOD-620066 end
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
 
   CALL cl_wait()
 
   LET g_success ='Y'
 
   BEGIN WORK
 
  #----------------------先宣告所須資料的 Cursor----------------------
   LET g_sql= "SELECT qcg01,0,0,qcg03,'',qcf04,qcf041,qcgg04 ",
              "  FROM qcf_file,qcg_file,qcgg_file ",
              " WHERE qcf01=qcg01 AND qcg01=qcgg01 ",
            #---------------------No.MOD-620066 modify------------
             #"   AND qcg03=qcgg03 AND ",g_wc CLIPPED
              "   AND qcg03=qcgg03 ",
              "   AND qcg01='",g_qdb.qdb01 CLIPPED,"'",
              "   AND qcg03=",g_qdb.qdb013 CLIPPED
            #---------------------No.MOD-620066 end------------
   PREPARE t600_pretmpf FROM g_sql
   DECLARE t600_tmpf CURSOR FOR t600_pretmpf
 
   LET g_sql= "SELECT tmp01,tmp011,tmp012,tmp013,tmp02,tmp03,tmp04, ",
              " COUNT(tmp05),SUM(tmp05),AVG(tmp05),MAX(tmp05)-MIN(tmp05) ",
              "  FROM aqc_tmpf ",
              " GROUP BY tmp01,tmp011,tmp012,tmp013,tmp02,tmp03,tmp04 "
   PREPARE t600_preqcgf FROM g_sql
   DECLARE t600_qcgf CURSOR FOR t600_preqcgf
 
   LET g_sql= "SELECT tmp01,tmp011,tmp012,tmp013,tmp02,tmp05 ",
              "  FROM aqc_tmpf "
   PREPARE t600_preqdcf FROM g_sql
   DECLARE t600_qdcf CURSOR FOR t600_preqdcf
 
   #--------------------------------------------------------------------
   DELETE FROM aqc_tmpf
   FOREACH t600_tmpf INTO l_tmp.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      INSERT INTO aqc_tmpf VALUES(l_tmp.*)
      IF STATUS THEN
#        CALL cl_err('ins tmp:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","aqc_tmpf","","",STATUS,"","ins tmp",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
    END FOREACH
 
   LET l_qdc02=1
   FOREACH t600_qcgf INTO l_qdc.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_qdc.qdc02=l_qdc02
      INSERT INTO qdc_file(qdc01,qdc011,qdc012,qdc013,qdc02,qdc03,qdc04,
                           qdc05,qdc06,qdc07,qdc08,
                           qdcplant,qdclegal)  #FUN-980007
           VALUES(g_qdb.qdb01,0,0,g_qdb.qdb013,l_qdc02,l_qdc.qdc03,
                  l_qdc.qdc04,l_qdc.qdc05,l_qdc.qdc06,l_qdc.qdc07,l_qdc.qdc08,
                  g_plant,g_legal)             #FUN-980007
      IF STATUS THEN
#        CALL cl_err('ins qdc:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","qdc_file",g_qdb.qdb01,l_qdc02,STATUS,"","ins qdc",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      UPDATE aqc_tmpf SET tmp02=l_qdc02
       WHERE tmp01=l_qdc.qdc01 AND tmp011=l_qdc.qdc011
         AND tmp012=l_qdc.qdc012 AND tmp013=l_qdc.qdc013
      IF STATUS THEN
#        CALL cl_err('upd tmp:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("upd","aqc_tmpf",l_qdc.qdc01,l_qdc.qdc011,STATUS,"","upd tmp",1)  #No.FUN-660115
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      LET l_qdc02=l_qdc02+1
   END FOREACH
 
   FOREACH t600_qdcf INTO l_qdd.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      INSERT INTO qdd_file(qdd01,qdd011,qdd012,qdd013,qdd02,qdd03,
                           qddplant,qddlegal) #FUN-980007
           VALUES(g_qdb.qdb01,0,0,g_qdb.qdb013,l_qdd.qdd02,l_qdd.qdd03,
                  g_plant,g_legal)            #FUN-980007
      IF STATUS THEN
#        CALL cl_err('ins qdd:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","qdd_file",g_qdb.qdb01,l_qdd.qdd02,STATUS,"","ins qdd",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
 
   ERROR ""
   CALL cl_end(18,20)
 
   CLOSE WINDOW t600_wf
 
   CALL t600_show()
 
END FUNCTION
 
FUNCTION t600_pp()
DEFINE  ls_tmp          STRING
DEFINE  l_qdc02         LIKE qdc_file.qdc02,
        p_row,p_col     LIKE type_file.num5,             #No.FUN-680104 SMALLINT
        l_qdd           RECORD LIKE qdd_file.*,
        l_qdc           RECORD LIKE qdc_file.*,
        l_tmp   RECORD
                   tmp01    LIKE qcn_file.qcn01, #FUN-660152
                   tmp011   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
                   tmp012   LIKE type_file.num5,         #No.FUN-680104 SMALLINT 
                   tmp013   LIKE type_file.num5,         #No.FUN-680104 SMALLINT 
                   tmp02    LIKE type_file.num5,         #No.FUN-680104 SMALLINT 
                   tmp03    LIKE type_file.dat,          #No.FUN-680104 DATE
                   tmp04    LIKE qcs_file.qcs03,         #No.FUN-680104 VARCHAR(8)
                   tmp05    LIKE eco_file.eco05          #No.FUN-680104 DEC(7,2)
               END RECORD
 
   IF cl_null(g_qdb.qdb01) OR cl_null(g_qdb.qdb013) THEN
      CALL cl_err('','aqc-052',1)
      RETURN
   END IF
 
   DROP TABLE aqc_tmpp
#No.FUN-680104-begin
   CREATE TEMP TABLE aqc_tmpp(
     tmp01    LIKE type_file.chr1000,
     tmp011   LIKE type_file.num5,  
     tmp012   LIKE type_file.num5,  
     tmp013   LIKE type_file.num5,  
     tmp02    LIKE type_file.num5,  
     tmp03    LIKE type_file.dat,   
     tmp04    LIKE qcs_file.qcs03,
     tmp05    LIKE eco_file.eco05)
#No.FUN-680104-end
   IF STATUS THEN
      CALL cl_err('Create aqc_tmpp',STATUS,1)
      RETURN
   END IF
 
#---------------------------No.MOD-620066 mark
#  LET p_row = 5 LET p_col = 30
#  OPEN WINDOW t600_wp AT p_row,p_col WITH FORM "aqc/42f/aqct600_p"
#        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#   CALL cl_ui_locale("aqct600_p")
 
#
#  CLEAR FORM
#  CALL g_qdc.clear()
 
#  WHILE TRUE
#     CONSTRUCT BY NAME g_wc ON qcm01,qcm04
#             #No.FUN-580031 --start--     HCN
#             BEFORE CONSTRUCT
#                CALL cl_qbe_init()
#             #No.FUN-580031 --end--       HCN
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
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
#
#       	#No.FUN-580031 --start--     HCN
#               ON ACTION qbe_select
#        	   CALL cl_qbe_select()
#               ON ACTION qbe_save
#       	   CALL cl_qbe_save()
#       	#No.FUN-580031 --end--       HCN
#     END CONSTRUCT
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW t600_wp
#        RETURN
#     END IF
 
#     IF g_wc=" 1=1" THEN
#        CALL cl_err('','9046',0) CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
 
#  END WHILE
#---------------------------No.MOD-620066 end
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
   CALL cl_wait()
 
   LET g_success ='Y'
 
   BEGIN WORK
 
   #----------------------先宣告所須資料的 Cursor----------------------
   LET g_sql= "SELECT qcn01,0,0,qcn03,'',qcm04,qcm041,qcnn04 ",
              "  FROM qcm_file,qcn_file,qcnn_file ",
              " WHERE qcm01=qcn01 AND qcn01=qcnn01 ",
            #--------------------No.MOD-620066 modify
             #"   AND qcn03=qcnn03 AND ",g_wc CLIPPED
              "   AND qcn03=qcnn03 ",
              "   AND qcn01='",g_qdb.qdb01 CLIPPED,"'",
              "   AND qcn03=",g_qdb.qdb013 CLIPPED
            #--------------------No.MOD-620066 end
   PREPARE t600_pretmpp FROM g_sql
   DECLARE t600_tmpp CURSOR FOR t600_pretmpp
 
   LET g_sql= "SELECT tmp01,tmp011,tmp012,tmp013,tmp02,tmp03,tmp04, ",
              " COUNT(tmp05),SUM(tmp05),AVG(tmp05),MAX(tmp05)-MIN(tmp05) ",
              "  FROM aqc_tmpp ",
              " GROUP BY tmp01,tmp011,tmp012,tmp013,tmp02,tmp03,tmp04 "
   PREPARE t600_preqcnp FROM g_sql
   DECLARE t600_qcnp CURSOR FOR t600_preqcnp
 
   LET g_sql= "SELECT tmp01,tmp011,tmp012,tmp013,tmp02,tmp05 ",
              "  FROM aqc_tmpp "
   PREPARE t600_preqdcp FROM g_sql
   DECLARE t600_qdcp CURSOR FOR t600_preqdcp
 
   #--------------------------------------------------------------------
   DELETE FROM aqc_tmpp
   FOREACH t600_tmpp INTO l_tmp.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      INSERT INTO aqc_tmpp VALUES(l_tmp.*)
      IF STATUS THEN
#        CALL cl_err('ins tmp:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","aqc_tmpp","","",STATUS,"","ins tmp",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
    END FOREACH
 
   LET l_qdc02=1
   FOREACH t600_qcnp INTO l_qdc.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_qdc.qdc02=l_qdc02
      INSERT INTO qdc_file(qdc01,qdc011,qdc012,qdc013,qdc02,qdc03,qdc04,
                           qdc05,qdc06,qdc07,qdc08,
                           qdcplant,qdclegal) #FUN-980007
           VALUES(g_qdb.qdb01,0,0,g_qdb.qdb013,l_qdc02,l_qdc.qdc03,
                  l_qdc.qdc04,l_qdc.qdc05,l_qdc.qdc06,l_qdc.qdc07,l_qdc.qdc08,
                  g_plant,g_legal)            #FUN-980007
      IF STATUS THEN
#        CALL cl_err('ins qdc:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","qdc_file",g_qdb.qdb01,l_qdc02,STATUS,"","ins qdc",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      UPDATE aqc_tmpp SET tmp02=l_qdc02
       WHERE tmp01=l_qdc.qdc01 AND tmp011=l_qdc.qdc011
         AND tmp012=l_qdc.qdc012 AND tmp013=l_qdc.qdc013
      IF STATUS THEN
#        CALL cl_err('upd tmp:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("upd","aqc_tmpp",l_qdc.qdc01,l_qdc.qdc011,STATUS,"","upd tmp",1)  #No.FUN-660115
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      LET l_qdc02=l_qdc02+1
 
   END FOREACH
 
   FOREACH t600_qdcp INTO l_qdd.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      INSERT INTO qdd_file(qdd01,qdd011,qdd012,qdd013,qdd02,qdd03,
                           qddplant,qddlegal) #FUN-980007
           VALUES(g_qdb.qdb01,0,0,g_qdb.qdb013,l_qdd.qdd02,l_qdd.qdd03,
                  g_plant,g_legal)            #FUN-980007
      IF STATUS THEN
#        CALL cl_err('ins qdd:',STATUS,1)   #No.FUN-660115
         CALL cl_err3("ins","qdd_file",g_qdb.qdb01,l_qdd.qdd02,STATUS,"","ins qdd",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
 
   ERROR ""
   CALL cl_end(18,20)
 
   CLOSE WINDOW t600_wp
 
   CALL t600_show()
 
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qdb00,qdb01,qdb011,qdb012,qdb013,qdb02",TRUE)
    END IF
 
    IF INFIELD(qdb00) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qdb011,qdb012",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done )  AND g_chkey='N' THEN           #No.FUN-570109
       CALL cl_set_comp_entry("qdb00,qdb01,qdb011,qdb012,qdb013,qdb02",FALSE)
    END IF
 
    IF INFIELD(qdb00) OR ( NOT g_before_input_done ) THEN
       IF g_qdb.qdb00 MATCHES '[23]' THEN
          LET g_qdb.qdb011=0
          LET g_qdb.qdb012=0
          DISPLAY BY NAME g_qdb.qdb011,g_qdb.qdb012
          CALL cl_set_comp_entry("qdb011,qdb012",FALSE)
       END IF
    END IF
 
END FUNCTION
#Patch....NO.TQC-610036 <001> #
