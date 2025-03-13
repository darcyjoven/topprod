# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqct403.4gl
# Descriptions...: FQC聯產品資料維護作業
# Input parameter:
# Date & Author..: 03/03/10 By Mandy
# Modify ........: No.MOD-490371 04/09/22 By Melody controlp ...display修改
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0038 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-580013 05/08/16 By yoyo 憑証類報表原則修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0106 05/11/12 By Dido 單據編號長度放大
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/31 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-710093 07/01/26 By pengu  筆數計算錯誤，無法下一筆
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7B0220 07/11/26 By Pengu FQC串aqct403時無法維護聯產品相關資料
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-AA0048 10/10/22 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao 
# Modify.........: No.MOD-B10057 11/01/07 By lixia s_umfchk參數傳錯
# Modify.........: No.FUN-BB0085 11/12/15 By xianghui 增加數量欄位小數取位
# Modify.........: NO.FUN-C20068 12/02/13 By xianghui 修改FUN-BB0085的一些問題
# Modify.........: No:FUN-D30034 13/04/16 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_qcf           RECORD LIKE qcf_file.*,
    g_qcf_t         RECORD LIKE qcf_file.*,
    g_qde           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        qde03       LIKE qde_file.qde03,   #
        qde05       LIKE qde_file.qde05,   #
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        bmm05       LIKE bmm_file.bmm05,   #
        qde12       LIKE qde_file.qde12,   #
        qde06       LIKE qde_file.qde06,   #
        qde13       LIKE qde_file.qde13,   #
        qde09       LIKE qde_file.qde09,   #
        qde10       LIKE qde_file.qde10,   #
        qde11       LIKE qde_file.qde11,   #
        qde08       LIKE qde_file.qde08    #
                    END RECORD,
    g_qde_t         RECORD    #程式變數(Program Variables)
        qde03       LIKE qde_file.qde03,   #
        qde05       LIKE qde_file.qde05,   #
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        bmm05       LIKE bmm_file.bmm05,   #
        qde12       LIKE qde_file.qde12,   #
        qde06       LIKE qde_file.qde06,   #
        qde13       LIKE qde_file.qde13,   #
        qde09       LIKE qde_file.qde09,   #
        qde10       LIKE qde_file.qde10,   #
        qde11       LIKE qde_file.qde11,   #
        qde08       LIKE qde_file.qde08    #
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,                  #NO.TQC-630166         #No.FUN-680104
    g_flag          LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,          #單身筆數              #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT   #No.FUN-680104 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5,       #No.FUN-680104 SMALLINT
    g_ima55      LIKE ima_file.ima55,
    t_img02      LIKE img_file.img02,         #倉庫
    t_img03      LIKE img_file.img03,         #儲位
    g_img19      LIKE ima_file.ima271,        #最高限量
    g_ima271     LIKE ima_file.ima271,        #最高儲存量
    g_imf05      LIKE imf_file.imf05,         #預設料件庫存量
    h_qty        LIKE ima_file.ima271,
    g_tot        LIKE qde_file.qde13,         #No.FUN-680104 DEC(15,3)
    g_sent       LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)     #1:由aqct410 mene 的'1.聯產品'串aqct403
                         #3:由aqct410 menu 的'3.特採'  串aqct403
                         #T:由aqct410 INPUT 的^T 串aqct403
 
 
#主程式開始
DEFINE g_forupd_sql          STRING                       #SELECT ... FOR UPDATE SQL     #No.FUN-680104
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose   #No.FUN-680104 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_qde12_t             LIKE qde_file.qde12          #FUN-BB0085
 
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
 
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
 
    LET g_qcf.qcf01  = ARG_VAL(1)           #主件編號
    LET g_qcf.qcf02  = ARG_VAL(2)           #主件編號
    LET g_sent       = ARG_VAL(3)
 
    LET g_forupd_sql = "SELECT * FROM qcf_file WHERE qcf01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 14
 
    OPEN WINDOW t403_w AT  p_row,p_col         #顯示畫面
         WITH FORM "aqc/42f/aqct403"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_qcf.qcf01) AND
       NOT cl_null(g_qcf.qcf02) THEN
       LET g_flag = 'Y'
       CALL t403_q()
       CALL t403_b()
    ELSE
       LET g_flag = 'N'
    END IF
 
    CALL t403_menu()
 
    CLOSE WINDOW t403_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
END MAIN
 
#QBE 查詢資料
FUNCTION t403_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  DEFINE  l_i,l_j      LIKE type_file.num5,       #No.FUN-680104 SMALLINT
          l_buf        LIKE type_file.chr1000     #No.FUN-680104 VARCHAR(500)
   CLEAR FORM                             #清除畫面
   CALL g_qde.clear()
 
    IF g_flag = 'N' THEN
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcf.* TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON  qcf01,qcf02,qcf09,qcf021,qcf04,qcf22,qcf091,qcf14 # 螢幕上取單頭條件
                    FROM  qcf01,qcf02,qcf09,qcf021,qcf04,qcf22,qcf091,qcf14
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
    ELSE
         LET g_wc = "     qcf01 ='",g_qcf.qcf01,"'",
                    " AND qcf02 ='",g_qcf.qcf02,"'"
         LET g_wc2= "     qde01 ='",g_qcf.qcf01,"'",
                    " AND qde02 ='",g_qcf.qcf02,"'"
    END IF
    IF INT_FLAG THEN  RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND qcfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
    #End:FUN-980030
 
 
    IF g_flag = 'N' THEN
       CONSTRUCT g_wc2 ON qde03,qde05,qde12,qde06,qde13,qde09,
                          qde10,qde11,qde08 # 螢幕上取單身條件
                     FROM s_qde[1].qde03,s_qde[1].qde05,
                          s_qde[1].qde12,s_qde[1].qde06,s_qde[1].qde13,
                          s_qde[1].qde09,s_qde[1].qde10,s_qde[1].qde11,
                          s_qde[1].qde08
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(qde05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_bmm"
                      LET g_qryparam.state    = "c"
                      IF NOT cl_null(g_qcf.qcf021) THEN
                         LET g_qryparam.where = "bmm01 = '",g_qcf.qcf021 CLIPPED,"'"
                      END IF
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO qde05
                      NEXT FIELD qde05
                 WHEN INFIELD(qde09) #倉庫
                      #No.FUN-AA0048  --Begin
                      #CALL cl_init_qry_var()
                      #LET g_qryparam.form = "q_imfd"
                      #LET g_qryparam.state    = "c"
                      #IF g_sma.sma42 NOT MATCHES '[3]' THEN
                      #   LET g_qryparam.where = "imf01='",g_qde[1].qde05 CLIPPED,"'"
                      #END IF
                      #CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                      #No.FUN-AA0048  --End  
                      DISPLAY g_qryparam.multiret TO qde09
                      NEXT FIELD qde09
                 WHEN INFIELD(qde10) #儲位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_imfe"
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.arg1 = g_qde[1].qde09
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO qde10
                      NEXT FIELD qde10
                 WHEN INFIELD(qde11) #LOTS
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_img"
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.arg1 = g_qde[1].qde05
                      LET g_qryparam.arg2 = g_qde[1].qde09
                      LET g_qryparam.arg3 = g_qde[1].qde10
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO qde11
                      NEXT FIELD qde11
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
 
       IF INT_FLAG THEN  RETURN END IF
    ELSE
       LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT qcf01,qcf02 FROM qcf_file,ima_file ",
                   " WHERE ", g_wc CLIPPED,     # 單頭條件
                   "   AND qcf021 = ima01 ",
                   "   AND ima903 = 'Y'",
                   "   AND qcf00 = '1' "        # 資料來源'1'工單
#                  "   AND (qcf09 = '1'OR qcf09 = '3')",       # 判定結果'1'合格 OR '3'特採
#                  " ORDER BY 1,2"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE qcf01,qcf02 ",
                   "  FROM qcf_file, qde_file,ima_file ",
                   " WHERE qcf01 = qde01 ",
                   "   AND qcf02 = qde02 ",
                   "   AND qcf00 = '1' ",       # 資料來源'1'工單
                   "   AND qcf021 = ima01 ",
                   "   AND ima903 = 'Y'",
                   "   AND ", g_wc  CLIPPED,
                   "   AND ", g_wc2 CLIPPED
#                  "   AND (qcf09 = '1'OR qcf09 = '3')",       # 判定結果'1'合格 OR '3'特採
#                  " ORDER BY qcf01"
    END IF
IF g_sent <> '3' THEN
    LET g_sql = g_sql CLIPPED,
                   "   AND (qcf09 = '1'OR qcf09 = '3')",       # 判定結果'1'合格 OR '3'特採
                   " ORDER BY qcf01"
END IF
 
    PREPARE t403_prepare FROM g_sql
    DECLARE t403_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t403_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql = "SELECT qcf01,qcf02 FROM qcf_file,ima_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND qcf00 = '1' ",       # 資料來源'1'工單
                   "   AND qcf021 = ima01 ",
                   "   AND ima903 = 'Y'"
#                  "   AND (qcf09 = '1'OR qcf09 = '3')",       # 判定結果'1'合格 OR '3'特採
#                  " INTO TEMP x "
    ELSE
       LET g_sql = "SELECT qcf01,qcf02 ",
                   "  FROM qcf_file, qde_file,ima_file ",
                   " WHERE qcf01 = qde01 ",
                   "   AND qcf02 = qde02 ",
                   "   AND qcf00 = '1' ",       # 資料來源'1'工單
                   "   AND qcf021 = ima01 ",
                   "   AND ima903 = 'Y'",
                   "   AND ", g_wc  CLIPPED,
                   "   AND ", g_wc2 CLIPPED
#                  "   AND (qcf09 = '1'OR qcf09 = '3')",       # 判定結果'1'合格 OR '3'特採
#                  " INTO TEMP x "
    END IF
IF g_sent <> '3' THEN
    LET g_sql = g_sql CLIPPED,
                   "   AND (qcf09 = '1'OR qcf09 = '3')"       # 判定結果'1'合格 OR '3'特採
                   #" INTO TEMP x "     #No.TQC-710093 mark
END IF
   #-----No.TQC-710093 add
    LET g_sql = g_sql CLIPPED," INTO TEMP x "
   #-----No.TQC-710093 add
    DROP TABLE x
    PREPARE t403_precount_x FROM g_sql
    EXECUTE t403_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t403_precount FROM g_sql
    DECLARE t403_count CURSOR FOR t403_precount
END FUNCTION
 
FUNCTION t403_menu()
 
   WHILE TRUE
      CALL t403_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t403_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t403_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t403_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qde),'','')
            END IF
         #No.FUN-6A0160-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_qcf.qcf01 IS NOT NULL THEN
                LET g_doc.column1 = "qcf01"
                LET g_doc.column2 = "qcf02"
                LET g_doc.value1 = g_qcf.qcf01
                LET g_doc.value2 = g_qcf.qcf02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0160-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t403_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   #INITIALIZE g_qcf.* TO NULL              #No.FUN-6A0160   #No.MOD-7B0220 mark
    CALL cl_opmsg('q')
    MESSAGE ""
 
    CLEAR FORM
    CALL g_qde.clear()
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t403_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_qcf.* TO NULL
        RETURN
    END IF
 
    OPEN t403_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_qcf.* TO NULL
    ELSE
       OPEN t403_count
       FETCH t403_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t403_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t403_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t403_cs INTO g_qcf.qcf01,g_qcf.qcf02
        WHEN 'P' FETCH PREVIOUS t403_cs INTO g_qcf.qcf01,g_qcf.qcf02
        WHEN 'F' FETCH FIRST    t403_cs INTO g_qcf.qcf01,g_qcf.qcf02
        WHEN 'L' FETCH LAST     t403_cs INTO g_qcf.qcf01,g_qcf.qcf02
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
            FETCH ABSOLUTE g_jump t403_cs INTO g_qcf.qcf01,g_qcf.qcf02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_qcf.qcf01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_qcf.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_qcf.* FROM qcf_file WHERE qcf01 = g_qcf.qcf01
#FUN-4C0038
    IF SQLCA.sqlcode THEN
        LET g_msg=g_qcf.qcf01 CLIPPED
#       CALL cl_err(g_msg,SQLCA.sqlcode,1)   #No.FUN-660115
        CALL cl_err3("sel","qcf_file",g_qcf.qcf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
        INITIALIZE g_qcf.* TO NULL
    ELSE
       LET g_data_owner = g_qcf.qcfuser      #FUN-4C0038
       LET g_data_group = g_qcf.qcfgrup      #FUN-4C0038
       LET g_data_plant = g_qcf.qcfplant #FUN-980030
       CALL t403_show()                      # 重新顯示
    END IF
##
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t403_show()
    LET g_qcf_t.* = g_qcf.*                #保存單頭舊值
    DISPLAY BY NAME g_qcf.qcf01,g_qcf.qcf02,g_qcf.qcf04,g_qcf.qcf021,   # 顯示單頭值
                    g_qcf.qcf22,g_qcf.qcf091,g_qcf.qcf09,g_qcf.qcf14
    CALL t403_qcf09()
    CALL t403_qcf021()
 
    CALL t403_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t403_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否         #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態           #No.FUN-680104 VARCHAR(1)
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入   #No.FUN-680104 VARCHAR(1)
    sn1,sn2         LIKE type_file.num5,         #No.FUN-680104  SMALLINT
    l_direct        LIKE type_file.chr1,         #No.FUN-680104  VARCHAR(1)
    l_code          LIKE ima_file.ima23,         #No.FUN-680104  VARCHAR(7)
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680104 SMALLINT
DEFINE l_tf         LIKE type_file.chr1          #FUN-BB0085
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_qcf.qcf01) OR cl_null(g_qcf.qcf02) THEN
       RETURN
    END IF
    IF g_qcf.qcf14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qcf.qcf14 = 'Y' AND g_qcf.qcf09 = '1' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_qcf.qcf09 = '3' AND g_sent = '1' THEN
        #已做特採!
        CALL cl_err('','aqc-416',0)
        RETURN
    END IF
 
    IF g_sma.sma104 = 'N' THEN
        #不使用聯產品!
        CALL cl_err('','aqc-412',0)
        RETURN
    END IF
 
    IF g_sma.sma105 != '1' THEN
        #認定聯產品的時機點不為FQC!
        CALL cl_err('','aqc-413',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =#"SELECT qde03,qde05,qde12,qde06,qde09,qde10,qde11, qde13,qde08 ",
                       "SELECT qde03,qde05,'','','',qde12,qde06,qde13,qde09,qde10,qde11,qde08 ",
                       "  FROM qde_file ",
                       " WHERE qde01= ? AND qde02= ? AND qde03= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qde WITHOUT DEFAULTS FROM s_qde.*
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
IF g_sent = '1' THEN
            OPEN t403_cl USING g_qcf.qcf01
            IF STATUS THEN
               CALL cl_err("OPEN t403_cl:", STATUS, 1)
               CLOSE t403_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t403_cl INTO g_qcf.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_qcf.qcf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t403_cl
               ROLLBACK WORK
               RETURN
            END IF
END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_qde_t.* = g_qde[l_ac].*  #BACKUP
                LET g_qde12_t = g_qde[l_ac].qde12  #FUN-BB0085
                OPEN t403_bcl USING g_qcf.qcf01,  g_qcf.qcf02, g_qde_t.qde03
                IF STATUS THEN
                   CALL cl_err("OPEN t403_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t403_bcl INTO g_qde[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_qde_t.qde03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT ima02,ima021
                        INTO g_qde[l_ac].ima02,g_qde[l_ac].ima021
                        FROM ima_file
                       WHERE ima01 = g_qde[l_ac].qde05
                      SELECT bmm05 INTO g_qde[l_ac].bmm05
                        FROM bmm_file
                       WHERE bmm01 = g_qcf.qcf021
                         AND bmm03 = g_qde[l_ac].qde05
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qde[l_ac].* TO NULL      #900423
            LET g_qde_t.* = g_qde[l_ac].*         #新輸入資料
            LET g_qde12_t = NULL  #FUN-BB0085
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qde03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_qde.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            INSERT INTO qde_file(qde01,qde02,qde03,qde04,qde05,qde06,
                                 qde08,qde09,qde10,qde11,qde12,qde13,
                                 qdeplant,qdelegal)   #FUN-980007 
            VALUES(g_qcf.qcf01,g_qcf.qcf02,
                   g_qde[l_ac].qde03,g_qcf.qcf04,g_qde[l_ac].qde05,g_qde[l_ac].qde06,
                   g_qde[l_ac].qde08,g_qde[l_ac].qde09,g_qde[l_ac].qde10,g_qde[l_ac].qde11,
                   g_qde[l_ac].qde12,g_qde[l_ac].qde13,
                   g_plant,g_legal)                   #FUN-980007
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_qde[l_ac].qde03,SQLCA.sqlcode,0)   #No.FUN-660115
               CALL cl_err3("ins","qde_file",g_qcf.qcf01,g_qde[l_ac].qde03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL t403_tot()
            END IF
 
        BEFORE FIELD qde03                        #default 序號
            IF g_qde[l_ac].qde03 IS NULL OR
               g_qde[l_ac].qde03 = 0 THEN
                SELECT max(qde03)+1
                   INTO g_qde[l_ac].qde03
                   FROM qde_file
                   WHERE qde01 = g_qcf.qcf01
                     AND qde02 = g_qcf.qcf02
                IF g_qde[l_ac].qde03 IS NULL THEN
                    LET g_qde[l_ac].qde03 = 1
                END IF
            END IF
 
        AFTER FIELD qde03                        #check 序號是否重複
            IF cl_null(g_qde[l_ac].qde03) THEN
                NEXT FIELD qde03
            END IF
            IF g_qde[l_ac].qde03 != g_qde_t.qde03 OR
               g_qde_t.qde03 IS NULL THEN
                SELECT count(*) INTO l_n FROM qde_file
                 WHERE qde01 = g_qcf.qcf01
                   AND qde02 = g_qcf.qcf02
                   AND qde03 = g_qde[l_ac].qde03
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qde[l_ac].qde03 = g_qde_t.qde03
                   NEXT FIELD qde03
                END IF
            END IF
            LET g_cnt = g_cnt + 1
 
        AFTER FIELD qde05
            LET l_tf = "" #FUN-C20068
            IF NOT cl_null(g_qde[l_ac].qde05) THEN
#FUN-AB0025 ------------------------mark------------------------------------
#FUN-AA0059 ---------------------start----------------------------
#             IF NOT s_chk_item_no(g_qde[l_ac].qde05,"") THEN
#                CALL cl_err('',g_errno,1)
#                LET g_qde[l_ac].qde05= g_qde_t.qde05
#                NEXT FIELD qde05
#             END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 ------------------------mark -----------------------------------
               CALL t403_qde05('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_qde[l_ac].qde05,g_errno,0)
                   LET g_qde[l_ac].qde05 = g_qde_t.qde05
                   NEXT FIELD qde05
               END IF
               IF NOT cl_null(g_qde[l_ac].qde06) AND g_qde[l_ac].qde06 <>0 THEN       #FUN-C20068
                  CALL t403_qde06_check() RETURNING l_tf          #FUN-BB0085
               END IF                                          #FUN-C20068
 
               IF g_qde[l_ac].qde05 != g_qde_t.qde05 OR
                  cl_null(g_qde_t.qde05) THEN
                   SELECT COUNT(*) INTO g_cnt
                     FROM qde_file
                    WHERE qde01 = g_qcf.qcf01
                      AND qde02 = g_qcf.qcf02
                      AND qde05 = g_qde[l_ac].qde05
                   IF g_cnt >0 THEN
                       CALL cl_err(g_qde[l_ac].qde05,'abm-609',0)
                       #聯產品料件號編號重覆!
                       LET g_qde[l_ac].qde05 = g_qde_t.qde05
                       LET g_qde[l_ac].bmm05 = g_qde_t.bmm05
                       LET g_qde[l_ac].ima02 = g_qde_t.ima02
                       LET g_qde[l_ac].ima021= g_qde_t.ima021
                       NEXT FIELD qde05
                   END IF
               END IF
               SELECT ima35,ima36 INTO l_ima35,l_ima36 FROM ima_file
                WHERE ima01 = g_qde[l_ac].qde05
 
               LET g_qde[l_ac].qde09 = l_ima35
               LET g_qde[l_ac].qde10 = l_ima36
 
               #CALL s_umfchk(g_qde[l_ac].qde03,g_qde[l_ac].qde12,g_ima55) #MOD-B10057
               CALL s_umfchk(g_qde[l_ac].qde05,g_qde[l_ac].qde12,g_ima55)  
               RETURNING g_i,g_qde[l_ac].qde13
               IF g_i = 1 THEN
                   #無單位轉換率,請重新輸入
                   CALL cl_err(g_qde[l_ac].qde05,'mfg2719',0)
                   LET g_qde[l_ac].qde05 = g_qde_t.qde05
                   LET g_qde[l_ac].qde12 = g_qde_t.qde12
                   LET g_qde[l_ac].qde06 = g_qde_t.qde06
                   LET g_qde[l_ac].qde09 = g_qde_t.qde09
                   LET g_qde[l_ac].qde10 = g_qde_t.qde10
                   LET g_qde[l_ac].qde11 = g_qde_t.qde11
                   LET g_qde[l_ac].qde13 = g_qde_t.qde13
                   LET g_qde[l_ac].qde08 = g_qde_t.qde08
                   LET g_qde[l_ac].bmm05 = g_qde_t.bmm05
                   LET g_qde[l_ac].ima02 = g_qde_t.ima02
                   LET g_qde[l_ac].ima021= g_qde_t.ima021
                   NEXT FIELD qde05
              END IF
              #FUN-BB0085-add-str--
              LET g_qde12_t = g_qde[l_ac].qde12
              IF NOT l_tf THEN
                 NEXT FIELD qde12
              END IF
              #FUN-BB0085-add-str--
            END IF
 
        AFTER FIELD qde06 #數量
           IF NOT t403_qde06_check() THEN NEXT FIELD qde06 END IF   #FUN-BB0085
           #FUN-BB0085-mark-str-- 
           #IF NOT cl_null(g_qde[l_ac].qde06) THEN
           #   IF g_qde[l_ac].qde06 = 0 THEN
           #     #本欄位之值, 不可空白或小於等於零, 請重新輸入!
           #      CALL cl_err(g_qde[l_ac].qde06,'aap-022',0)
           #      NEXT FIELD qde06
           #   END IF
           #END IF
           #FUN-BB0085-mark-end--
 
        AFTER FIELD qde09  #倉庫
            IF NOT cl_null(g_qde[l_ac].qde09) THEN
               #No.FUN-AA0048  --Begin
               IF NOT s_chk_ware(g_qde[l_ac].qde09) THEN
                  NEXT FIELD qde09
               END IF
               #No.FUN-AA0048  --End  
 #------>check-1
               IF NOT s_imfchk1(g_qde[l_ac].qde05,g_qde[l_ac].qde09)
                  THEN CALL cl_err(g_qde[l_ac].qde09,'mfg9036',0)
                       NEXT FIELD qde09
               END IF
 #------>check-2
               CALL  s_stkchk(g_qde[l_ac].qde09,'A') RETURNING l_code
               IF l_code = 0 THEN
                  CALL cl_err(g_qde[l_ac].qde09,'mfg4020',0)
                  NEXT FIELD qde09
               END IF
#----->檢查倉庫是否為可用倉
               CALL  s_swyn(g_qde[l_ac].qde09) RETURNING sn1,sn2
               IF sn1=1 AND g_qde[l_ac].qde09!=t_img02 THEN
                  CALL cl_err(g_qde[l_ac].qde09,'mfg6080',0)
                  LET t_img02=g_qde[l_ac].qde09
                  NEXT FIELD qde09
               ELSE
                 IF sn2=2 AND g_qde[l_ac].qde09!=t_img02 THEN
                    CALL cl_err(g_qde[l_ac].qde09,'mfg6085',0)
                    LET t_img02=g_qde[l_ac].qde09
                    NEXT FIELD qde09
                 END IF
               END IF
               LET sn1=0 LET sn2=0
            ELSE
                NEXT FIELD ima021
            END IF
 
        AFTER FIELD qde10  #儲位
            IF g_qde[l_ac].qde10 IS NULL THEN LET g_qde[l_ac].qde10=' ' END IF
            IF NOT cl_null(g_qde[l_ac].qde09) THEN
               #BugNo:5626 控管是否為全型空白
               IF g_qde[l_ac].qde10 = '　' THEN #全型空白
                  LET g_qde[l_ac].qde10 =' '
               END IF
#---->需存在倉庫/儲位檔中
               IF g_qde[l_ac].qde10 IS NOT NULL THEN
                  CALL s_hqty(g_qde[l_ac].qde05,g_qde[l_ac].qde09,g_qde[l_ac].qde10)
                       RETURNING g_cnt,g_img19,g_imf05
                  IF g_img19 IS NULL THEN LET g_img19=0 END IF
                  LET h_qty=g_img19
                  CALL  s_lwyn(g_qde[l_ac].qde09,g_qde[l_ac].qde10) RETURNING sn1,sn2
                   IF sn1=1 AND g_qde[l_ac].qde10!=t_img03
                      THEN CALL cl_err(g_qde[l_ac].qde10,'mfg6080',0)
                           LET t_img03=g_qde[l_ac].qde10
                           NEXT FIELD qde10
                   ELSE IF sn2=2 AND g_qde[l_ac].qde10!=t_img03
                           THEN CALL cl_err(g_qde[l_ac].qde10,'mfg6085',0)
                           LET t_img03=g_qde[l_ac].qde10
                           NEXT FIELD qde10
                        END IF
                   END IF
                   LET sn1=0 LET sn2=0
               END IF
 
               LET l_direct='D'
               IF g_qde[l_ac].qde10 IS NULL THEN LET g_qde[l_ac].qde10 = ' ' END IF
            END IF
 
        AFTER FIELD qde11  # 批號
            IF g_qde[l_ac].qde11 IS NULL THEN LET g_qde[l_ac].qde11 = ' ' END IF
            IF NOT cl_null(g_qde[l_ac].qde09) THEN
               #BugNo:5626 控管是否為全型空白
               IF g_qde[l_ac].qde11 = '　' THEN #全型空白
                   LET g_qde[l_ac].qde11 =' '
               END IF
              #倉庫/儲位/批號不可以都不輸入!!!
 
               SELECT * FROM img_file
                WHERE img01=g_qde[l_ac].qde05 AND img02=g_qde[l_ac].qde09
                  AND img03=g_qde[l_ac].qde10 AND img04=g_qde[l_ac].qde11
               IF STATUS=100 THEN
                  #這是新的料件倉庫儲位, 是否確定新增庫存明細(Y/N)?
                  IF NOT cl_confirm('mfg1401') THEN NEXT FIELD qde09 END IF
                  CALL s_add_img(g_qde[l_ac].qde05,g_qde[l_ac].qde09,
                                 g_qde[l_ac].qde10,g_qde[l_ac].qde11,
                                 g_qcf.qcf01,      g_qde[l_ac].qde03,
                                 g_qcf.qcf04)
               END IF
 
               IF NOT s_actimg(g_qde[l_ac].qde05,g_qde[l_ac].qde09,
                               g_qde[l_ac].qde10,g_qde[l_ac].qde11) THEN
                  #該料件所存放之倉庫/存放位置/批號 已無效, 請輸入有效之資料
                  CALL cl_err('inactive','mfg6117',0)
                  NEXT FIELD qde09
               END IF
               LET l_direct='D'
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_qde_t.qde03 > 0 AND
               g_qde_t.qde03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM qde_file
                 WHERE qde01 = g_qcf.qcf01
                   AND qde02 = g_qcf.qcf02
                   AND qde03 = g_qde_t.qde03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qde_t.qde03,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qde_file",g_qcf.qcf01,g_qde_t.qde03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
                CALL t403_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qde[l_ac].* = g_qde_t.*
               CLOSE t403_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qde[l_ac].qde03,-263,1)
               LET g_qde[l_ac].* = g_qde_t.*
            ELSE
               UPDATE qde_file SET qde03=g_qde[l_ac].qde03,
                                   qde05=g_qde[l_ac].qde05,
                                   qde06=g_qde[l_ac].qde06,
                                   qde08=g_qde[l_ac].qde08,
                                   qde09=g_qde[l_ac].qde09,
                                   qde10=g_qde[l_ac].qde10,
                                   qde11=g_qde[l_ac].qde11,
                                   qde12=g_qde[l_ac].qde12,
                                   qde13=g_qde[l_ac].qde13
                WHERE qde01=g_qcf.qcf01
                  AND qde02=g_qcf.qcf02
                  AND qde03=g_qde_t.qde03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_qde[l_ac].qde03,SQLCA.sqlcode,0)   #No.FUN-660115
                  CALL cl_err3("upd","qde_file",g_qcf.qcf01,g_qde_t.qde03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  LET g_qde[l_ac].* = g_qde_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL t403_tot()
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30034
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CALL t403_tot()
               IF g_tot !=g_qcf.qcf091 AND g_qcf.qcf09 = '3' THEN
                 #特採聯產品總數一定要等於FQC合格量!
                  CALL cl_err('','aqc-405',1)
                 #(1)放棄輸入 (2)繼續輸入單身 , 若放棄輸入,將刪除所有單身資料
                  CALL cl_conf2(0,0,'aqc-406','12') RETURNING g_i
                  IF g_i = '1' THEN #放棄輸入
                     DELETE FROM qde_file
                      WHERE qde01 = g_qcf.qcf01
                        AND qde02 = g_qcf.qcf02
                     CALL t403_show()
                     EXIT INPUT
                  ELSE
                     NEXT FIELD qde03
                  END IF
               END IF
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qde[l_ac].* = g_qde_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qde.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE t403_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D30034
 
            CLOSE t403_bcl
            COMMIT WORK
 
        AFTER INPUT
            SELECT COUNT(*) INTO g_cnt
              FROM qde_file,bmm_file
             WHERE qde01 = g_qcf.qcf01
               AND qde02 = g_qcf.qcf02
               AND bmm01 = g_qcf.qcf021
               AND bmm03 = qde05
               AND bmm05 = 'N'
            IF g_cnt >= 1 THEN
                #存在無效的聯產品料號,請檢查(aqct403)單身資料正確否
                CALL cl_err('','aqc-422',1)
            END IF
 
            SELECT COUNT(*) INTO g_cnt FROM qde_file
             WHERE qde01 = g_qcf.qcf01
               AND qde02 = g_qcf.qcf02
            IF g_cnt >=1 THEN
               CALL t403_tot()
               IF g_tot !=g_qcf.qcf091 THEN
                  IF g_qcf.qcf09 ='3' THEN
                    #特採聯產品總數一定要等於FQC合格量!
                     CALL cl_err('','aqc-405',1)
                     NEXT FIELD qde03
                  ELSE
                     #聯產品總數不等於FQC合格量!
                     CALL cl_err('','aqc-403',1)
                  END IF
               END IF
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qde05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bmm"
                   LET g_qryparam.arg1 = g_qcf.qcf021
                   CALL cl_create_qry() RETURNING g_qde[l_ac].qde05,g_qde[l_ac].qde12
#                   CALL FGL_DIALOG_SETBUFFER( g_qde[l_ac].qde05 )
#                   CALL FGL_DIALOG_SETBUFFER( g_qde[l_ac].qde12 )
                    DISPLAY g_qde[l_ac].qde05 TO qde05   #No.MOD-490371
                    DISPLAY g_qde[l_ac].qde12 TO qde12   #No.MOD-490371
                   NEXT FIELD qde05
              WHEN INFIELD(qde09) #倉庫
                   #No.FUN-AA0048  --Begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_imfd"
                   #IF g_sma.sma42 NOT MATCHES '[3]' THEN
                   #   LET g_qryparam.where = "imf01='",g_qde[l_ac].qde05 CLIPPED,"'"
                   #END IF
                   #LET g_qryparam.default1 = g_qde[l_ac].qde09
                   #CALL cl_create_qry() RETURNING g_qde[l_ac].qde09
                   CALL q_imd_1(FALSE,TRUE,g_qde[l_ac].qde09,"","","","") RETURNING g_qde[l_ac].qde09
                   #No.FUN-AA0048  --End  
                   DISPLAY g_qde[l_ac].qde09 TO qde09   #No.MOD-490371
                   NEXT FIELD qde09
              WHEN INFIELD(qde10) #儲位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_imfe"
                   LET g_qryparam.default1 = g_qde[l_ac].qde10
                   LET g_qryparam.arg1 = g_qde[l_ac].qde09
                   CALL cl_create_qry() RETURNING g_qde[l_ac].qde10
#                   CALL FGL_DIALOG_SETBUFFER( g_qde[l_ac].qde10 )
                    DISPLAY g_qde[l_ac].qde10 TO qde10   #No.MOD-490371
                   NEXT FIELD qde10
              WHEN INFIELD(qde11) #LOTS
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_img"
                   LET g_qryparam.default1 = g_qde[l_ac].qde11
                   LET g_qryparam.arg1 = g_qde[l_ac].qde05
                   LET g_qryparam.arg2 = g_qde[l_ac].qde09
                   LET g_qryparam.arg3 = g_qde[l_ac].qde10
                   CALL cl_create_qry() RETURNING g_qde[l_ac].qde11
#                   CALL FGL_DIALOG_SETBUFFER( g_qde[l_ac].qde11 )
                    DISPLAY g_qde[l_ac].qde11 TO qde11   #No.MOD-490371
                   NEXT FIELD qde11
              OTHERWISE
                   EXIT CASE
            END CASE
 
#       ON ACTION CONTROLN
#           CALL t403_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qde03) AND l_ac > 1 THEN
               LET g_qde[l_ac].* = g_qde[l_ac-1].*
               NEXT FIELD qde03
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
    CLOSE t403_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t403_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
   CONSTRUCT g_wc2 ON qde03,qde05,qde12,qde06,qde13,qde09,qde10,qde11,qde08 # 螢幕上取單身條件
                 FROM s_qde[1].qde03,s_qde[1].qde05,s_qde[1].qde12,s_qde[1].qde06,s_qde[1].qde13,
                      s_qde[1].qde09,s_qde[1].qde10,s_qde[1].qde11,
                      s_qde[1].qde08
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
 
    CALL t403_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t403_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(200)
    l_flag          LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    LET g_sql =
      # "SELECT qde03,qde05,qde12,qde06,qde09,qde10,qde11,qde13,qde08,'', ",
      # "       ima02,ima021 ",
        "SELECT  qde03,qde05,ima02,ima021,'',qde12,qde06,qde13,qde09,qde10,qde11,qde08 ",
        "  FROM qde_file,OUTER ima_file",
        " WHERE qde01 ='",g_qcf.qcf01,"'", #單頭-1
        "   AND qde02 ='",g_qcf.qcf02,"'", #單頭-1
        "   AND qde_file.qde05 = ima_file.ima01 ",
        "   AND ",p_wc2 CLIPPED,           #單身
        " ORDER BY 1,2,3,4"
    PREPARE t403_pb FROM g_sql
    DECLARE qde_cs                       #SCROLL CURSOR
        CURSOR FOR t403_pb
 
    CALL g_qde.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH qde_cs INTO g_qde[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        SELECT bmm05 INTO g_qde[g_cnt].bmm05
          FROM bmm_file
         WHERE bmm01 = g_qcf.qcf021
           AND bmm03 = g_qde[g_cnt].qde05
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_qde.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
    CALL t403_tot()
 
END FUNCTION
 
FUNCTION t403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qde TO s_qde.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t403_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t403_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t403_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t403_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t403_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t403_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    sr              RECORD
        qde01       LIKE qde_file.qde01,   #
        qde02       LIKE qde_file.qde02,   #
        qde03       LIKE qde_file.qde03,   #
        qde04       LIKE qde_file.qde04,   #
        qde05       LIKE qde_file.qde05,   #
        qde06       LIKE qde_file.qde06,   #
        qde08       LIKE qde_file.qde08,   #
        qde09       LIKE qde_file.qde09,   #
        qde10       LIKE qde_file.qde10,   #
        qde11       LIKE qde_file.qde11,   #
        qde12       LIKE qde_file.qde12,   #
        qde13       LIKE qde_file.qde13,
        qcf01       LIKE qcf_file.qcf01,
        qcf02       LIKE qcf_file.qcf02,
        qcf04       LIKE qcf_file.qcf04,
        qcf021      LIKE qcf_file.qcf021,
        qcf22       LIKE qcf_file.qcf22,
        qcf091      LIKE qcf_file.qcf091,
        ima02       LIKE ima_file.ima02,
        ima55       LIKE ima_file.ima55
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE cob_file.cob01                 #No.FUN-680104 VARCHAR(40)
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('aqct403') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT qde01,qde02,qde03,qde04,qde05,qde06,",
              "       qde08,qde09,qde10,qde11,qde12,qde13,",
              "       qcf01,qcf02,qcf04,qcf021,qcf22,qcf091,ima02,ima55 ",
              "  FROM qde_file,qcf_file,ima_file ",
              " WHERE qde01 = qcf01 ",
              "   AND qde02 = qcf02 ",
              "   AND qcf021 = ima01",
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,2,3,4,5"
    PREPARE t403_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t403_co                         # CURSOR
        CURSOR FOR t403_p1
 
    START REPORT t403_rep TO l_name
 
    FOREACH t403_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t403_rep(sr.*)
    END FOREACH
 
    FINISH REPORT t403_rep
 
    CLOSE t403_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t403_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    sr              RECORD
        qde01       LIKE qde_file.qde01,   #
        qde02       LIKE qde_file.qde02,   #
        qde03       LIKE qde_file.qde03,   #
        qde04       LIKE qde_file.qde04,   #
        qde05       LIKE qde_file.qde05,   #
        qde06       LIKE qde_file.qde06,   #
        qde08       LIKE qde_file.qde08,   #
        qde09       LIKE qde_file.qde09,   #
        qde10       LIKE qde_file.qde10,   #
        qde11       LIKE qde_file.qde11,   #
        qde12       LIKE qde_file.qde12,   #
        qde13       LIKE qde_file.qde13,
        qcf01       LIKE qcf_file.qcf01,
        qcf02       LIKE qcf_file.qcf02,
        qcf04       LIKE qcf_file.qcf04,
        qcf021      LIKE qcf_file.qcf021,
        qcf22       LIKE qcf_file.qcf22,
        qcf091      LIKE qcf_file.qcf091,
        ima02       LIKE ima_file.ima02,
        ima55       LIKE ima_file.ima55
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.qde01,sr.qde02,sr.qde03
 
    FORMAT
        PAGE HEADER
#No.FUN-580013--start
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today ,' ',TIME,
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#No.FUN-580013--end
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.qde01
#TQC-5B0106
            PRINT COLUMN  2,g_x[11] CLIPPED,sr.qcf01,
                  COLUMN 28,g_x[12] CLIPPED,sr.qcf02,
                  COLUMN 54,g_x[13] CLIPPED,sr.qcf04
#           PRINT COLUMN  2,g_x[11] CLIPPED,sr.qcf01,
#                 COLUMN 25,g_x[12] CLIPPED,sr.qcf02,
#                 COLUMN 46,g_x[13] CLIPPED,sr.qcf04
            PRINT COLUMN  2,g_x[14] CLIPPED,sr.qcf021
            PRINT COLUMN  2,g_x[17] CLIPPED,sr.ima02
#           PRINT COLUMN  2,g_x[14] CLIPPED,sr.qcf021,' ',sr.ima02
#TQC-5B0106 End
            PRINT COLUMN  4,g_x[15] CLIPPED,sr.qcf22,
                  COLUMN 28,g_x[16] CLIPPED,sr.qcf091
            PRINT g_dash2[1,g_len]
#No.FUN-580013--start
#           PRINT COLUMN  3,g_x[17] CLIPPED,
#                 COLUMN 31,g_x[18] CLIPPED
#           PRINT '  ----  --------------------  ---- --------- -------------------------------'
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINTX name=H2 g_x[36],g_x[37]
            PRINTX name=H3 g_x[38],g_x[39]
            PRINT g_dash1
#No.FUN-580013--end
 
 
        ON EVERY ROW
            SELECT   ima02,ima021
              INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01 = sr.qde05
#No.FUN-580013--start
#           PRINT COLUMN  3,sr.qde03 USING '####',
#                 COLUMN  9,sr.qde05,
#                 COLUMN 31,sr.qde12,
#                 COLUMN 36,sr.qde06 USING '#######.#',
#                 COLUMN 46,sr.qde08
#           PRINT COLUMN 09,l_ima02,' ',l_ima021
            PRINTX name=D1
                  COLUMN g_c[31],sr.qde03 USING '####',
                  COLUMN g_c[32],sr.qde05 CLIPPED, #FUN-5B0014 [1,20],
                  COLUMN g_c[33],sr.qde12,
                  COLUMN g_c[34],sr.qde06 USING '##########&.#',
                  COLUMN g_c[35],sr.qde08[1,30]
            PRINTX name=D2
                  COLUMN g_c[37],l_ima02
            PRINTX name=D3
                  COLUMN g_c[39],l_ima021
#No.FUN-580013--end
 
        AFTER GROUP OF sr.qde01
              SKIP 2 LINE
              PRINT g_dash[1,g_len]
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN 
#NO.TQC-630166 start--
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
                    PRINT g_dash[1,g_len]
            END IF
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
 
FUNCTION t403_qde05(p_cmd)    #聯產品料件號編號
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
         l_ima02     LIKE ima_file.ima02,
         l_ima021    LIKE ima_file.ima021,
         l_bmm04     LIKE bmm_file.bmm04,
         l_bmm05     LIKE bmm_file.bmm05
 
  LET g_errno = ' '
       #單位,生效否
  SELECT bmm04,bmm05,ima02,ima021
    INTO l_bmm04,l_bmm05,l_ima02,l_ima021
    FROM bmm_file,OUTER ima_file
   WHERE bmm01 = g_qcf.qcf021      #主件料件編號
     AND bmm03 = g_qde[l_ac].qde05 #聯產品料件號編號
     AND bmm_file.bmm03 = ima_file.ima01
 
  CASE WHEN SQLCA.SQLCODE = 100
{
#           IF g_qcf.qcf021 = g_qde[l_ac].qde05 THEN #可建成品料號
#               SELECT ima55,ima02,ima021 INTO
#                     l_bmm04,l_ima02,l_ima021
#                 FROM ima_file
#                WHERE ima01=g_qde[l_ac].qde05
#               IF SQLCA.sqlcode = 100 THEN
#                   LET g_errno = 'abm-610' #無此聯產品料號!
#                   LET l_bmm04 = NULL
#                   LET l_bmm05 = NULL
#                   LET l_ima02 = NULL
#                   LET l_ima021= NULL
#               END IF
#           ELSE
}
                LET g_errno = 'abm-610' #無此聯產品料號!
                LET l_bmm04 = NULL
                LET l_bmm05 = NULL
                LET l_ima02 = NULL
                LET l_ima021= NULL
#           END IF
       WHEN l_bmm05='N' LET g_errno = '9028'
       OTHERWISE        LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  LET g_qde[l_ac].qde12 = l_bmm04
  LET g_qde[l_ac].bmm05 = l_bmm05
  LET g_qde[l_ac].ima02 = l_ima02
  LET g_qde[l_ac].ima021= l_ima021
END FUNCTION
 
FUNCTION t403_qcf09()
    DEFINE l_des1 LIKE ze_file.ze03    #No.TQC-610007
 
    CASE g_qcf.qcf09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_des1
         WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING l_des1
         WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_des1
    END CASE
    DISPLAY l_des1 TO FORMONLY.des1
END FUNCTION
FUNCTION t403_qcf021()
  DEFINE l_ima02  LIKE ima_file.ima02
     SELECT ima02,ima55
       INTO l_ima02,g_ima55
       FROM ima_file
      WHERE ima01 =g_qcf.qcf021
    DISPLAY l_ima02 TO FORMONLY.ima02d
    DISPLAY g_ima55 TO FORMONLY.ima55
END FUNCTION
 
FUNCTION t403_tot()
    DEFINE  l_tot1        LIKE qde_file.qde13,       #No.FUN-680104 DEC(15,3) #聯產品數量加總(不包含原主件)
            l_tot2        LIKE qde_file.qde13        #No.FUN-680104 DEC(15,3)#原主件產品數量加總
 
     SELECT SUM(qde06*qde13) INTO l_tot1
       FROM qde_file,bmm_file
      WHERE qde01 = g_qcf.qcf01
        AND qde02 = g_qcf.qcf02
        AND bmm01 = g_qcf.qcf021  #主件編號
        AND bmm03 = qde05
        AND bmm03 <> g_qcf.qcf021 #聯產品料號不等於主件本身
       #AND bmm05 = 'Y'           #不管製有效無效
     SELECT SUM(qde06*qde13) INTO l_tot2
       FROM qde_file
      WHERE qde01 = g_qcf.qcf01
        AND qde02 = g_qcf.qcf02
        AND qde05 = g_qcf.qcf021  #聯產品料號等於原主件本身
     IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
     IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
     LET g_tot = l_tot1 + l_tot2
     DISPLAY g_tot TO FORMONLY.tot
END FUNCTION

#FUN-BB0085------add------str------
FUNCTION t403_qde06_check() 
   IF NOT cl_null(g_qde[l_ac].qde06) AND NOT cl_null(g_qde[l_ac].qde12) THEN 
      IF cl_null(g_qde12_t) OR g_qde12_t != g_qde[l_ac].qde12 OR
         cl_null(g_qde_t.qde06) OR g_qde_t.qde06 != g_qde[l_ac].qde12 THEN 
         LET g_qde[l_ac].qde06 = s_digqty(g_qde[l_ac].qde06,g_qde[l_ac].qde12)
         DISPLAY BY NAME g_qde[l_ac].qde06
      END IF
   END IF
   IF NOT cl_null(g_qde[l_ac].qde06) THEN
      IF g_qde[l_ac].qde06 = 0 THEN
        #本欄位之值, 不可空白或小於等於零, 請重新輸入!
         CALL cl_err(g_qde[l_ac].qde06,'aap-022',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085------add------end------
#Patch....NO.TQC-610036 <> #
