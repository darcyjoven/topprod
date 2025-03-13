# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...:anmi550
# Descriptions...:借款狀況資料維護作業
# Date & Author..: 98/06/18 By David Hsu
# Modify.........:No.MOD-470426 04/07/20 By Nicola 輸入單身前,prompt的畫面-自動產生,打'y',會有error
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770085 07/07/17 By wujie   單身日期欄位未控管 
# Modify.........: No.TQC-770109 07/07/24 By Rayven 單身更改融資金，點確定后不更新融資余額
#                                                   單身日期欄位錄入一日期后，天數欄位自動計算出，如修改日期欄位值后，天數欄位的值未重新計算
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-950115 09/05/26 By baofei  i550_count CURSOR 少一個AND
#                                                    改正修改時更新nmm_file表而不是nmn_file
# Modify.........: No.MOD-960078 09/06/04 By Sarah nmm02為key值,entry與no_entry的控制需與nmm01相同
# Modify.........: No.TQC-960292 09/07/14 By baofei  修改單身金額修改后，合計沒有重新show  
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_nmm           RECORD LIKE nmm_file.*,    #(假單頭)
    g_nmm_t         RECORD LIKE nmm_file.*,    #(舊值)
    g_nmm_o         RECORD LIKE nmm_file.*,    #(舊值)
    g_nmm01_t       LIKE nmm_file.nmm01,       #key(舊值)
    g_nmm02_t       LIKE nmm_file.nmm02,       #key(舊值)
    g_nmn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nmn03       LIKE nmn_file.nmn03,       #
        nmn04       LIKE nmn_file.nmn04,       #
        nmn05       LIKE nmn_file.nmn05,       #
        nmn06       LIKE nmn_file.nmn06,       #
        nmn07       LIKE nmn_file.nmn07,       #
        nmn08       LIKE nmn_file.nmn08        #
                    END RECORD,
    g_nmn_t         RECORD                     #程式變數 (舊值)
        nmn03       LIKE nmn_file.nmn03,       #
        nmn04       LIKE nmn_file.nmn04,       #
        nmn05       LIKE nmn_file.nmn05,       #
        nmn06       LIKE nmn_file.nmn06,       #
        nmn07       LIKE nmn_file.nmn07,       #
        nmn08       LIKE nmn_file.nmn08        #
                    END RECORD,
    g_nmn_trn       RECORD                     #程式變數 (舊值)
        nmn01       LIKE nmn_file.nmn01,       #
        nmn02       LIKE nmn_file.nmn02,       #
        nmn03       LIKE nmn_file.nmn03,       #
        nmn04       LIKE nmn_file.nmn04,       #
        nmn05       LIKE nmn_file.nmn05,       #
        nmn06       LIKE nmn_file.nmn06,       #
        nmn07       LIKE nmn_file.nmn07,       #
        nmn08       LIKE nmn_file.nmn08,       #
        nmnlegal    LIKE nmn_file.nmnlegal     #FUN-980005 add legal 
                    END RECORD,
    g_faa26         LIKE faa_file.faa26,
    g_tot5_t        LIKE nmn_file.nmn05,       #No.FUN-4C0010
    g_tot6_t        LIKE nmn_file.nmn06,       #No.FUN-4C0010
    g_tot8_t        LIKE nmn_file.nmn08,       #No.FUN-4C0010
  g_wc,g_wc2,g_sql  STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
    g_i550_day      LIKE type_file.num5        #No.FUN-680107 SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_chr        LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
MAIN
#DEFINE l_time       LIKE type_file.chr8       #No.FUN-6A0082
 DEFINE p_row,p_col  LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   LET g_forupd_sql = "SELECT * FROM nmm_file WHERE nmm01 = ? AND nmm02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i550_cl CURSOR FROM g_forupd_sql
 
   SELECT faa26 INTO g_faa26 FROM faa_file
    WHERE faa00='0'
 
   LET p_row = 3 LET p_col = 24
   OPEN WINDOW i550_w AT p_row,p_col WITH FORM "anm/42f/anmi550"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF g_faa26='1' THEN
      CALL cl_err('','anm-650',1)
      CLOSE WINDOW i550_w
      EXIT PROGRAM
   END IF
 
   CALL i550_menu()
   CLOSE WINDOW i550_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION i550_cs()
DEFINE  lc_qbe_sn  LIKE    gbm_file.gbm01 #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_nmn.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nmm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON nmm01,nmm02,nmm03,nmm04,nmmuser,
                              nmmgrup,nmmmodu,nmmdate,nmmacti
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
 
    IF INT_FLAG THEN
       RETURN
    END IF
 
    IF g_wc IS NULL THEN
       LET g_wc='1=1'
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND nmmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND nmmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND nmmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmmuser', 'nmmgrup')
    #End:FUN-980030
 
    CONSTRUCT g_wc2 ON nmn03,nmn04,nmn05,nmn06,nmn07,nmn08
            FROM s_nmn[1].nmn03,s_nmn[1].nmn04,s_nmn[1].nmn05,
                 s_nmn[1].nmn06,s_nmn[1].nmn07,s_nmn[1].nmn08
 
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT nmm01,nmm02 FROM nmm_file ",   #MOD-960078 add nmm02
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY nmm01"
    ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE nmm01,nmm02",
                   "  FROM nmm_file, nmn_file ",
                   " WHERE nmm01 = nmn01",
                   "   AND nmm02 = nmn02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY nmm01"
    END IF
 
    PREPARE i550_prepare FROM g_sql
    DECLARE i550_cs SCROLL CURSOR WITH HOLD FOR i550_prepare  #SCROLL CURSOR
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM nmm_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT nmm01) FROM nmm_file,nmn_file WHERE ",
#                "nmn01=nmm01 AND nmn02=nmm02",g_wc CLIPPED," AND ",       #TQC-950115  
                 "nmn01=nmm01 AND nmn02=nmm02 AND ",g_wc CLIPPED," AND ",   #TQC-950115  
                  g_wc2 CLIPPED
    END IF
    PREPARE i550_precount FROM g_sql
    DECLARE i550_count CURSOR FOR i550_precount
 
END FUNCTION
 
FUNCTION i550_menu()
 
   WHILE TRUE
      CALL i550_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i550_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i550_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i550_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i550_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i550_x()
               CALL cl_set_field_pic("","","","","",g_nmm.nmmacti)
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i550_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmn),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nmm.nmm01 IS NOT NULL AND
                    g_nmm.nmm02 IS NOT NULL THEN   #MOD-960078 add
                 LET g_doc.column1 = "nmm01"
                 LET g_doc.column2 = "nmm02"       #MOD-960078 add
                 LET g_doc.value1 = g_nmm.nmm01
                 LET g_doc.value2 = g_nmm.nmm02    #MOD-960078 add
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i550_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nmn.clear()
   INITIALIZE g_nmm.* LIKE nmm_file.*             #DEFAULT 設定
   LET g_nmm01_t = NULL
   LET g_nmm02_t = NULL
   #預設值及將數值類變數清成零
   LET g_nmm_o.* = g_nmm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_nmm.nmmuser=g_user
      LET g_nmm.nmmoriu = g_user #FUN-980030
      LET g_nmm.nmmorig = g_grup #FUN-980030
      LET g_nmm.nmmgrup=g_grup
      LET g_nmm.nmmdate=g_today
      LET g_nmm.nmmacti='Y'              #資料有效
 
      #FUN-980005 add legal 
      LET g_nmm.nmmlegal = g_legal
      #FUN-980005 end legal 
 
      CALL i550_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_nmm.* TO NULL
         EXIT WHILE
      END IF
 
      IF g_nmm.nmm01 IS NULL OR g_nmm.nmm02 IS NULL THEN  # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO nmm_file VALUES (g_nmm.*)
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#        CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,1)   #No.FUN-660148
         CALL cl_err3("ins","nmm_file",g_nmm.nmm01,g_nmm.nmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
 
      LET g_nmm_t.* = g_nmm.*
      LET g_rec_b =0                     #NO.FUN-680064
      SELECT nmm01,nmm02 INTO g_nmm.nmm01,g_nmm.nmm02 FROM nmm_file
       WHERE nmm01 = g_nmm.nmm01
         AND nmm02 = g_nmm.nmm02
      LET g_nmm01_t = g_nmm.nmm01        #保留舊值
      LET g_nmm02_t = g_nmm.nmm02        #保留舊值
 
      CALL i550_b_trn()
 
      CALL i550_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#----自動產生單身-----
FUNCTION i550_b_trn()
 DEFINE   l_chr        LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_cntno      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_bdate      LIKE type_file.dat,          #No.FUN-680107 DATE
          l_edate      LIKE type_file.dat,          #No.FUN-680107 DATE
          l_year       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_month      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_temp01     LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_temp02     LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_temp03     LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_temp04     LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_temp08     LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_day        LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_msg        LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(72)
          l_first      LIKE nmn_file.nmn07,         #No.FUN-4C0010
          l_temp_num   LIKE nmn_file.nmn05,         #No.FUN-4C0010
          l_flag       LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
#  OPEN WINDOW cl_conf_w AT 20,5 WITH 1 ROWS, 62 COLUMNS
   WHILE TRUE
      CALL cl_getmsg('anm-244',g_lang) RETURNING l_msg
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT l_msg CLIPPED FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END PROMPT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET l_chr = "N"
      END IF
 
      IF l_chr MATCHES "[Yy]" THEN
#        CLOSE WINDOW cl_conf_w
          LET l_ac=1   #MOD-470426
         EXIT WHILE
      END IF
 
      IF l_chr MATCHES "[Nn]" THEN
#        CLOSE WINDOW cl_conf_w
         EXIT WHILE
      END IF
   END WHILE
 
   IF l_chr MATCHES '[Nn]' THEN
      LET g_rec_b = 0
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cntno FROM nmn_file
    WHERE nmn01=g_nmm.nmm01
      AND nmn02=g_nmm.nmm02
 
   IF STATUS THEN
#     CALL cl_err('',SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("sel","nmn_file",g_nmm.nmm01,g_nmm.nmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
   END IF
 
   IF l_cntno != 0 THEN   #有單身不可產生
      CALL cl_err('','anm-245',1)
      RETURN
   END IF
 
   LET g_success = 'Y'
   #---找前期餘額--------------------------------
   IF g_nmm.nmm02 = 1 THEN
      LET l_month = 12
      LET l_year = g_nmm.nmm01 - 1
   ELSE
      LET l_month = g_nmm.nmm02 - 1
      LET l_year = g_nmm.nmm01
   END IF
 
   SELECT nmn07 INTO l_first
     FROM nmn_file
    WHERE nmn03=(SELECT MAX(nmn03)
                   FROM nmn_file
                  WHERE nmn01=l_year
                    AND nmn02=l_month)
      AND nmn01=l_year
      AND nmn02=l_month
 
   IF STATUS THEN
#     CALL cl_err('nmn08:',SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("sel","nmn_file",l_year,l_month,SQLCA.sqlcode,"","nmn08:",1)  #No.FUN-660148
      LET l_first=0
   END IF
 
   #------------------------------------------------------------
   IF l_chr = 'Y' OR l_chr = 'y'THEN
      #----宣告抓資料 cursor----------
      DECLARE i550_g_b_c1 CURSOR FOR
       SELECT DAY(nne111),nne19,'1'
         FROM nne_file
        WHERE YEAR(nne111) =g_nmm.nmm01
          AND MONTH(nne111)=g_nmm.nmm02
          AND nneconf='Y'
      UNION
      SELECT DAY(nng081),nng22,'2'
        FROM nng_file
       WHERE YEAR(nng081) =g_nmm.nmm01
         AND MONTH(nng081)=g_nmm.nmm02
         AND nngconf='Y'
      UNION
      SELECT DAY(nnk02),nnl14,'3'
        FROM nnk_file,nnl_file
        WHERE nnk01=nnl01
          AND YEAR(nnk02) =g_nmm.nmm01
          AND MONTH(nnk02)=g_nmm.nmm02
          AND nnkconf='Y'
      #----insert to 單身 ------------------------------
      #1.先產生期初一筆(抓上月),再insert其它
      #-------------------------------------------------
      LET g_nmn_trn.nmn01 = g_nmm.nmm01
      LET g_nmn_trn.nmn02 = g_nmm.nmm02
      LET g_nmn_trn.nmn03 = 1
      LET g_nmn_trn.nmn04 = 1
      LET g_nmn_trn.nmn05 = 0
      LET g_nmn_trn.nmn06 = 0
      LET g_nmn_trn.nmn07 = l_first
      LET g_nmn_trn.nmn08 = 0
      MESSAGE g_nmn_trn.nmn03
 
      #FUN-980005 add legal 
      LET g_nmn_trn.nmnlegal = g_legal
      #FUN-980005 end legal 
 
      INSERT INTO nmn_file VALUES(g_nmn_trn.*)
      IF STATUS THEN
#        CALL cl_err('ins fir',STATUS,1)   #No.FUN-660148
         CALL cl_err3("ins","nmn_file",g_nmn_trn.nmn01,g_nmn_trn.nmn02,STATUS,"","ins fir",1)  #No.FUN-660148
         LET g_success = 'N'
      END IF
 
      LET l_temp01=g_nmn_trn.nmn01 # key
      LET l_temp02=g_nmn_trn.nmn02 # key
      LET l_temp03=g_nmn_trn.nmn03 # key
      LET l_temp04=g_nmn_trn.nmn04 #初值日期
      #-------------------------------------------------
      LET l_cntno=1
      FOREACH i550_g_b_c1 INTO g_nmn_trn.nmn04,l_temp_num,l_flag
         IF STATUS THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         LET l_cntno=l_cntno+1
         LET g_nmn_trn.nmn01 = g_nmm.nmm01
         LET g_nmn_trn.nmn02 = g_nmm.nmm02
         LET g_nmn_trn.nmn03 = l_cntno
 
         IF l_flag != '3'THEN
            LET g_nmn_trn.nmn05 = l_temp_num
            LET g_nmn_trn.nmn06 = 0
         ELSE
            LET g_nmn_trn.nmn05 = 0
            LET g_nmn_trn.nmn06 = l_temp_num
         END IF
 
         LET g_nmn_trn.nmn07 = l_first+g_nmn_trn.nmn05-g_nmn_trn.nmn06
         #------------------------------------------
         UPDATE nmn_file
            SET nmn08 = g_nmn_trn.nmn04-l_temp04
          WHERE nmn01=l_temp01
            AND nmn02=l_temp02
            AND nmn03=l_temp03
         IF STATUS THEN
#           CALL cl_err('nmn08:',SQLCA.sqlcode,1)   #No.FUN-660148
            CALL cl_err3("upd","nmn_file",l_temp01,l_temp02,SQLCA.sqlcode,"","nmn08:",1)  #No.FUN-660148
            LET g_success = 'N'
         END IF
         #------------------------------------------
         LET g_nmn_trn.nmn08 = 0
         MESSAGE g_nmn_trn.nmn03
 
         #FUN-980005 add legal 
         LET g_nmn_trn.nmnlegal = g_legal
         #FUN-980005 end legal 
 
         INSERT INTO nmn_file VALUES(g_nmn_trn.*)
         IF STATUS THEN
#           CALL cl_err('ins nmn',STATUS,1)   #No.FUN-660148
            CALL cl_err3("ins","nmn_file",g_nmn_trn.nmn01,g_nmn_trn.nmn02,STATUS,"","ins nmn",1)  #No.FUN-660148
            LET g_success = 'N'
         END IF
 
         LET l_temp01=g_nmn_trn.nmn01 #
         LET l_temp02=g_nmn_trn.nmn02 #
         LET l_temp03=g_nmn_trn.nmn03 #
         LET l_temp04=g_nmn_trn.nmn04 #
         LET l_first=g_nmn_trn.nmn07
      END FOREACH
   ELSE
      LET g_nmn_trn.nmn01 = g_nmm.nmm01
      LET g_nmn_trn.nmn02 = g_nmm.nmm02
      LET g_nmn_trn.nmn03 = 1
      LET g_nmn_trn.nmn04 = 1
      LET g_nmn_trn.nmn05 = 0
      LET g_nmn_trn.nmn06 = 0
      LET g_nmn_trn.nmn07 = 0
      LET g_nmn_trn.nmn08 = 0
      MESSAGE g_nmn_trn.nmn03
 
      #FUN-980005 add legal 
      LET g_nmn_trn.nmnlegal = g_legal
      #FUN-980005 end legal 
 
      INSERT INTO nmn_file VALUES(g_nmn_trn.*)
      IF STATUS THEN
#        CALL cl_err('ins NEW',STATUS,1)   #No.FUN-660148
         CALL cl_err3("ins","nmn_file",g_nmn_trn.nmn01,g_nmn_trn.nmn02,STATUS,"","ins NEW",1)  #No.FUN-660148
         LET g_success = 'N'
      END IF
   END IF
   #----最後一筆天數-------------
   CALL s_mothck(MDY(g_nmm.nmm02,1,g_nmm.nmm01))
        RETURNING l_bdate,l_edate
   LET l_day=DAY(l_edate)
 
   UPDATE nmn_file
      SET nmn08 =l_day-l_temp04
      WHERE nmn01=l_temp01
        AND nmn02=l_temp02
        AND nmn03=l_temp03
   IF STATUS THEN
#     CALL cl_err('last day:',SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("upd","nmn_file",l_temp01,l_temp02,SQLCA.sqlcode,"","last day:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL i550_b_fill(' 1=1')
   CLOSE i550_g_b_c1
 
END FUNCTION
 
FUNCTION i550_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nmm.nmm01 IS NULL OR g_nmm.nmm02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_nmm.* FROM nmm_file
    WHERE nmm01=g_nmm.nmm01
      AND nmm02=g_nmm.nmm02
 
   IF g_nmm.nmmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_nmm.nmmacti,9027,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nmm01_t = g_nmm.nmm01
   LET g_nmm02_t = g_nmm.nmm02
   LET g_nmm_o.* = g_nmm.*
   BEGIN WORK
 
   OPEN i550_cl USING g_nmm.nmm01,g_nmm.nmm02
   IF STATUS THEN
      CALL cl_err("OPEN i550_cl:", STATUS, 1)
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i550_cl INTO g_nmm.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i550_show()
 
   WHILE TRUE
      LET g_nmm01_t = g_nmm.nmm01
      LET g_nmm02_t = g_nmm.nmm02
      LET g_nmm.nmmmodu=g_user
      LET g_nmm.nmmdate=g_today
 
      CALL i550_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_nmm.*=g_nmm_t.*
         CALL i550_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_nmm.nmm01 != g_nmm01_t OR g_nmm.nmm02 != g_nmm02_t THEN      #更改單號
#        UPDATE nmn_file SET nmm01 = g_nmm.nmm01,    #TQC-950115 
         UPDATE nmm_file SET nmm01 = g_nmm.nmm01,    #TQC-950115 
                             nmm02 = g_nmm.nmm02
          WHERE nmm01 = g_nmm01_t
            AND nmm02 = g_nmm02_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('nmn',SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nmn_file",g_nmm01_t,g_nmm02_t,SQLCA.sqlcode,"","nmn",1)  #No.FUN-660148
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE nmm_file SET nmm_file.* = g_nmm.*
     # WHERE nmm01 = g_nmm.nmm01 AND nmm02 = g_nmm.nmm02   #MOD-960078 mark
       WHERE nmm01 = g_nmm01_t     #MOD-960078
         AND nmm02 = g_nmm02_t     #MOD-960078
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("upd","nmm_file",g_nmm_t.nmm01,g_nmm_t.nmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i550_cl
   COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i550_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入 #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1     #a:輸入 u:更改 #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' THEN
      LET g_nmm.nmm03 = 0
      LET g_nmm.nmm04 = 0
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_nmm.nmm01,g_nmm.nmm02,g_nmm.nmm03,g_nmm.nmm04,g_nmm.nmmuser, g_nmm.nmmoriu,g_nmm.nmmorig,
                 g_nmm.nmmgrup,g_nmm.nmmmodu,g_nmm.nmmdate,g_nmm.nmmacti
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i550_set_entry(p_cmd)
         CALL i550_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD nmm01 #資料月份
         IF NOT cl_null(g_nmm.nmm01) THEN
            IF g_nmm.nmm01 < 0 THEN
               CALL cl_err(g_nmm.nmm01,'afa-376',0)
               DISPLAY g_nmm.nmm01 TO nmm01
               NEXT FIELD nmm01
            END IF
         END IF
 
      AFTER FIELD nmm02
         IF NOT cl_null(g_nmm.nmm02) THEN
            IF g_nmm.nmm02 < 0 OR g_nmm.nmm02 >12 THEN
               CALL cl_err(g_nmm.nmm02,'aom-580',0)
               LET g_nmm.nmm02 = NULL
               DISPLAY g_nmm.nmm02 TO nmm02
               NEXT FIELD nmm02
            END IF
            IF (g_nmm.nmm01 != g_nmm01_t OR g_nmm01_t IS NULL) OR
               (g_nmm.nmm02 != g_nmm02_t OR g_nmm02_t IS NULL) THEN
               SELECT count(*) INTO g_cnt FROM nmm_file
                WHERE nmm01 = g_nmm.nmm01
                  AND nmm02 = g_nmm.nmm02
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_nmm.nmm01,-239,0)
                  LET g_nmm.nmm01 = g_nmm01_t
                  LET g_nmm.nmm02 = g_nmm02_t
                  DISPLAY BY NAME g_nmm.nmm01
                  DISPLAY BY NAME g_nmm.nmm02
                  NEXT FIELD nmm01
               END IF
            END IF
         END IF
 
 
      AFTER FIELD nmm03 #月利率
         IF g_nmm.nmm03 < 0 THEN
            CALL cl_err(g_nmm.nmm03,'anm-246',0)
            LET g_nmm.nmm03 = 0
            DISPLAY g_nmm.nmm03 TO nmm03
            NEXT FIELD nmm03
         END IF
 
      AFTER FIELD nmm04 #利息支出
         IF g_nmm.nmm04 < 0 THEN
            CALL cl_err(g_nmm.nmm04,'anm-247',0)
            LET g_nmm.nmm04 = 0
            DISPLAY g_nmm.nmm04 TO nmm04
            NEXT FIELD nmm04
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(nmm01) THEN
      #      LET g_nmm.* = g_nmm_t.*
      #      DISPLAY BY NAME g_nmm.*
      #      NEXT FIELD nmm01
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
 
FUNCTION i550_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_nmn.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i550_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
 
   OPEN i550_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nmm.* TO NULL
   ELSE
      OPEN i550_count
      FETCH i550_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i550_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
 
END FUNCTION
 
FUNCTION i550_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式   #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10     #絕對的筆數 #No.FUN-680107 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i550_cs INTO g_nmm.nmm01,g_nmm.nmm02
      WHEN 'P' FETCH PREVIOUS i550_cs INTO g_nmm.nmm01,g_nmm.nmm02
      WHEN 'F' FETCH FIRST    i550_cs INTO g_nmm.nmm01,g_nmm.nmm02
      WHEN 'L' FETCH LAST     i550_cs INTO g_nmm.nmm01,g_nmm.nmm02
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
            FETCH ABSOLUTE g_jump i550_cs INTO g_nmm.nmm01,g_nmm.nmm02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)
      INITIALIZE g_nmm.* TO NULL                #No.FUN-6B0079  add
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
 
   SELECT * INTO g_nmm.* FROM nmm_file
  # WHERE nmm01 = g_nmm.nmm01 AND nmm02 = g_nmm.nmm02   #MOD-960078 mark
    WHERE nmm01 = g_nmm.nmm01   #MOD-960078
      AND nmm02 = g_nmm.nmm02   #MOD-960078
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("sel","nmm_file",g_nmm.nmm01,g_nmm.nmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
      INITIALIZE g_nmm.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_nmm.nmmuser     #No.FUN-4C0063
      LET g_data_group = g_nmm.nmmgrup     #No.FUN-4C0063
      CALL i550_show()
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i550_show()
 
   LET g_nmm_t.* = g_nmm.*                #保存單頭舊值
 
   DISPLAY BY NAME g_nmm.nmm01,g_nmm.nmm02,g_nmm.nmm03,g_nmm.nmm04, g_nmm.nmmoriu,g_nmm.nmmorig,
                   g_nmm.nmmuser,g_nmm.nmmgrup,g_nmm.nmmmodu,
                   g_nmm.nmmdate,g_nmm.nmmacti
 
   CALL i550_b_fill(g_wc2)                 #單身
   CALL cl_set_field_pic("","","","","",g_nmm.nmmacti)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i550_r()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nmm.nmm01 IS NULL OR g_nmm.nmm02 IS NULL THEN   #MOD-960078 mod
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i550_cl USING g_nmm.nmm01,g_nmm.nmm02
   IF STATUS THEN
      CALL cl_err("OPEN i550_cl:", STATUS, 1)
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i550_cl INTO g_nmm.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i550_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL              #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nmm01"             #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "nmm02"             #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nmm.nmm01          #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_nmm.nmm02          #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM nmm_file WHERE nmm01 = g_nmm.nmm01 AND nmm02 = g_nmm.nmm02
      DELETE FROM nmn_file WHERE nmn01 = g_nmm.nmm01 AND nmn02 = g_nmm.nmm02
      INITIALIZE g_nmm.* TO NULL
      CLEAR FORM
      CALL g_nmn.clear()
      OPEN i550_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i550_cs
         CLOSE i550_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i550_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i550_cs
         CLOSE i550_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i550_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i550_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i550_fetch('/')
      END IF
   END IF
 
   CLOSE i550_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i550_x()
 
    IF s_anmshut(0) THEN
       RETURN
    END IF
 
    IF g_nmm.nmm01 IS NULL OR g_nmm.nmm02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i550_cl USING g_nmm.nmm01,g_nmm.nmm02
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 1)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i550_cl INTO g_nmm.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL i550_show()
 
    IF cl_exp(0,0,g_nmm.nmmacti) THEN                   #確認一下
       LET g_chr=g_nmm.nmmacti
 
       IF g_nmm.nmmacti='Y' THEN
          LET g_nmm.nmmacti='N'
       ELSE
          LET g_nmm.nmmacti='Y'
       END IF
 
       UPDATE nmm_file SET nmmacti=g_nmm.nmmacti
        WHERE nmm01=g_nmm.nmm01
          AND nmm02=g_nmm.nmm02
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)   #No.FUN-660148
          CALL cl_err3("upd","nmm_file",g_nmm.nmm01,g_nmm.nmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
          LET g_nmm.nmmacti=g_chr
       END IF
       DISPLAY BY NAME g_nmm.nmmacti
    END IF
 
    CLOSE i550_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i550_b()
DEFINE
   l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,         #檢查重複用        #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680107 VARCHAR(1)
   l_b_bdate       LIKE type_file.dat,          #No.FUN-680107     DATE
   l_b_edate       LIKE type_file.dat,          #No.FUN-680107     DATE
   l_allow_insert  LIKE type_file.num5,         #可新增否          #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5          #可刪除否          #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nmm.nmm01 IS NULL OR g_nmm.nmm02 IS NULL THEN
      RETURN
   END IF
 
   SELECT * INTO g_nmm.* FROM nmm_file
    WHERE nmm01=g_nmm.nmm01
      AND nmm02=g_nmm.nmm02
 
   IF g_nmm.nmmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_nmm.nmm01,'aom-000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nmn03,nmn04,nmn05,nmn06,nmn07,nmn08 FROM nmn_file",
                      " WHERE nmn01=? AND nmn02=? AND nmn03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i550_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nmn WITHOUT DEFAULTS FROM s_nmn.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        IF g_rec_b!=0 THEN
           CALL fgl_set_arr_curr(l_ac)
        END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN i550_cl USING g_nmm.nmm01,g_nmm.nmm02
         IF STATUS THEN
            CALL cl_err("OPEN i550_cl:", STATUS, 1)
            CLOSE i550_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i550_cl INTO g_nmm.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_nmm.nmm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i550_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nmn_t.* = g_nmn[l_ac].*  #BACKUP
 
            OPEN i550_bcl USING g_nmm.nmm01,g_nmm.nmm02,g_nmn_t.nmn03
            IF STATUS THEN
               CALL cl_err("OPEN i550_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i550_bcl INTO g_nmn[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nmn_t.nmn03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nmn[l_ac].* TO NULL      #900423
         LET g_nmn[l_ac].nmn05 =0
         LET g_nmn[l_ac].nmn06 =0
         LET g_nmn_t.* = g_nmn[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD nmn03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
           #CALL g_nmn.deleteElement(l_ac)   #取消 Array Element
           #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
           #   LET g_action_choice = "detail"
           #   LET l_ac = l_ac_t
           #END IF
           #EXIT INPUT
         END IF
         INSERT INTO nmn_file(nmn01,nmn02,nmn03,nmn04,nmn05,nmn06,nmn07,nmn08,nmnlegal)  #FUN-980005 add legal 
         VALUES(g_nmm.nmm01,g_nmm.nmm02,g_nmn[l_ac].nmn03,
                g_nmn[l_ac].nmn04,g_nmn[l_ac].nmn05,g_nmn[l_ac].nmn06,
                g_nmn[l_ac].nmn07,g_nmn[l_ac].nmn08,g_legal)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nmn[l_ac].nmn03,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nmn_file",g_nmm.nmm01,g_nmm.nmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           #LET g_nmn[l_ac].* = g_nmn_t.*
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            CALL i550_nmn08('i') #算date
            CALL i550_upamt('i') #算sum
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD nmn03                        #default 序號
         IF cl_null(g_nmn[l_ac].nmn03) OR g_nmn[l_ac].nmn03 = 0 THEN
            SELECT max(nmn03)+1 INTO g_nmn[l_ac].nmn03
              FROM nmn_file
             WHERE nmn01 = g_nmm.nmm01
               AND nmn02 = g_nmm.nmm02
            IF g_nmn[l_ac].nmn03 IS NULL THEN
               LET g_nmn[l_ac].nmn03 = 1
            END IF
         END IF
 
      AFTER FIELD nmn03                        #check 序號是否重複
         IF NOT cl_null(g_nmn[l_ac].nmn03) THEN
            IF g_nmn[l_ac].nmn03 != g_nmn_t.nmn03 OR g_nmn_t.nmn03 IS NULL THEN
               SELECT COUNT(*) INTO l_n
                 FROM nmn_file
                WHERE nmn01 = g_nmm.nmm01
                  AND nmn02 = g_nmm.nmm02
                  AND nmn03 = g_nmn[l_ac].nmn03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_nmn[l_ac].nmn03 = g_nmn_t.nmn03
                  NEXT FIELD nmn03
               END IF
            END IF
         END IF
 
      AFTER FIELD nmn04 #日期,確認 30 or 31
         IF NOT cl_null(g_nmn[l_ac].nmn04) THEN
            CALL s_mothck(MDY(g_nmm.nmm02,1,g_nmm.nmm01))
                 RETURNING l_b_bdate,l_b_edate
            LET g_i550_day=DAY(l_b_edate)
            IF g_nmn[l_ac].nmn04 >g_i550_day THEN
               CALL cl_err('31','anm-248',0)
               LET g_nmn[l_ac].nmn04 = NULL
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_nmn[l_ac].nmn04
               #------MOD-5A0095 END------------
               NEXT FIELD nmn04
            END IF
#No.TQC-770085--begin                                                                                                               
            IF g_nmn[l_ac].nmn04 <=0  THEN                                                                                          
               LET g_nmn[l_ac].nmn04 =NULL                                                                                          
               CALL cl_err('','mfg9243',1)                                                                                          
               NEXT FIELD nmn04                                                                                                     
            END IF                                                                                                                  
#No.TQC-770085--end 
         END IF
 
      AFTER FIELD nmn05 #融資金額
         IF g_nmn[l_ac].nmn05 < 0 THEN
            CALL cl_err('<0','anm-249',0)
            LET g_nmn[l_ac].nmn05 = 0
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_nmn[l_ac].nmn05
            #------MOD-5A0095 END------------
            NEXT FIELD nmn05
         END IF
         #No.TQC-770109 --start--
         IF l_ac=1 THEN
            LET g_nmn[l_ac].nmn07=g_nmn[l_ac].nmn05-g_nmn[l_ac].nmn06
         END IF
         IF l_ac>1 THEN
            LET g_nmn[l_ac].nmn07 =g_nmn[l_ac-1].nmn07+g_nmn[l_ac].nmn05
                                   -g_nmn[l_ac].nmn06
            DISPLAY BY NAME g_nmn[l_ac].nmn07
         END IF
         #No.TQC-770109 --end--
 
      AFTER FIELD nmn06 # 還款金額,融資餘額,天數
         IF g_nmn[l_ac].nmn06 < 0 THEN
            CALL cl_err('<0','anm-249',0)
            LET g_nmn[l_ac].nmn06 = 0
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_nmn[l_ac].nmn06
            #------MOD-5A0095 END------------
            NEXT FIELD nmn06
         END IF
         IF l_ac=1 THEN
            LET g_nmn[l_ac].nmn07=g_nmn[l_ac].nmn05-g_nmn[l_ac].nmn06
         END IF
         IF l_ac>1 THEN
            LET g_nmn[l_ac].nmn07 =g_nmn[l_ac-1].nmn07+g_nmn[l_ac].nmn05
                                   -g_nmn[l_ac].nmn06
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_nmn[l_ac].nmn07
            #------MOD-5A0095 END------------
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_nmn_t.nmn03 > 0 AND g_nmn_t.nmn03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nmn_file
             WHERE nmn01 = g_nmm.nmm01
               AND nmn02 = g_nmm.nmm02
               AND nmn03 = g_nmn_t.nmn03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nmn_t.nmn03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nmn_file",g_nmm.nmm01,g_nmn_t.nmn03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL i550_nmn08('d') #算date
            CALL i550_upamt('d') #算sum
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nmn[l_ac].* = g_nmn_t.*
            CLOSE i550_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nmn[l_ac].nmn03,-263,1)
            LET g_nmn[l_ac].* = g_nmn_t.*
         ELSE
            UPDATE nmn_file SET nmn03= g_nmn[l_ac].nmn03,
                                nmn04= g_nmn[l_ac].nmn04,
                                nmn05= g_nmn[l_ac].nmn05,
                                nmn06= g_nmn[l_ac].nmn06,
                                nmn07= g_nmn[l_ac].nmn07,
                                nmn08= g_nmn[l_ac].nmn08
             WHERE nmn01=g_nmm.nmm01
               AND nmn02=g_nmm.nmm02
               AND nmn03=g_nmn_t.nmn03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nmn[l_ac].nmn03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nmn_file",g_nmm.nmm01,g_nmn_t.nmn03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nmn[l_ac].* = g_nmn_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CALL i550_nmn08('i')  #No.TQC-770109
               CALL i550_upamt('u')
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nmn[l_ac].* = g_nmn_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_nmn.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i550_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 Add
         CLOSE i550_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i550_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nmn03) AND l_ac > 1 THEN
            LET g_nmn[l_ac].* = g_nmn[l_ac-1].*
            LET g_nmn[l_ac].nmn03 = NULL   #TQC-620018
            NEXT FIELD nmn03
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
 
  #start FUN-5A0029
   LET g_nmm.nmmmodu = g_user
   LET g_nmm.nmmdate = g_today
   UPDATE nmm_file SET nmmmodu = g_nmm.nmmmodu,nmmdate = g_nmm.nmmdate
    WHERE nmm01 =  g_nmm.nmm01 AND nmm02 = g_nmm.nmm02
   DISPLAY BY NAME g_nmm.nmmmodu,g_nmm.nmmdate
  #end FUN-5A0029
 
   CLOSE i550_bcl
   COMMIT WORK
 
#  CALL i550_delall()  #CHI-C30002 mark
   CALL i550_delHeader()     #CHI-C30002 add
   CALL i550_show()   #TQC-960292  
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i550_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM nmm_file
          WHERE nmm01 = g_nmm.nmm01
            AND nmm02 = g_nmm.nmm02
         INITIALIZE g_nmm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
 
#FUNCTION i550_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM nmn_file
#   WHERE nmn01 = g_nmm.nmm01
#     AND nmn02 = g_nmm.nmm02
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#
#     DELETE FROM nmm_file
#      WHERE nmm01 = g_nmm.nmm01
#        AND nmm02 = g_nmm.nmm02
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i550_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON nmn03,nmn04,nmn05,nmn06,nmn07,nmn08
            FROM s_nmn[1].nmn03,s_nmn[1].nmn04,s_nmn[1].nmn05,
                 s_nmn[1].nmn06,s_nmn[1].nmn07,s_nmn[1].nmn08
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
 
    CALL i550_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i550_b_fill(p_wc2)               #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(200)
   l_tot5          LIKE nmn_file.nmn05,   #No.FUN-4C0010
   l_tot6          LIKE nmn_file.nmn06,   #No.FUN-4C0010
   l_tot8          LIKE nmn_file.nmn08    #No.FUN-4C0010
 
   LET g_sql = "SELECT nmn03,nmn04,nmn05,nmn06,nmn07,nmn08 ",
               "  FROM nmn_file",
               " WHERE nmn01 ='",g_nmm.nmm01,"' AND ",  #單頭
   #No.FUN-8B0123---Begin
               " nmn02 ='",g_nmm.nmm02,"'"      # AND ",
   #           p_wc2 CLIPPED,                     #單身
   #           " ORDER BY 1"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
   DISPLAY g_sql
   #No.FUN-8B0123---End
   
   PREPARE i550_pb FROM g_sql
   DECLARE nmn_curs                       #SCROLL CURSOR
       CURSOR FOR i550_pb
 
   LET g_rec_b = 0
   LET g_cnt=1
   LET l_tot5 = 0
   LET l_tot6 = 0
   LET l_tot8 = 0
 
   FOREACH nmn_curs INTO g_nmn[g_cnt].*   #單身 ARRAY 填充
      LET l_tot5 = l_tot5 + g_nmn[g_cnt].nmn05
      LET l_tot6 = l_tot6 + g_nmn[g_cnt].nmn06
      LET l_tot8 = l_tot8 + g_nmn[g_cnt].nmn08
 
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
 
   CALL g_nmn.deleteElement(g_cnt)   #取消 Array Element
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
   LET g_cnt = 0
   LET g_tot5_t = l_tot5
   LET g_tot6_t = l_tot6
   LET g_tot8_t = l_tot8
   DISPLAY l_tot5  TO tot_nmn05
   DISPLAY l_tot6  TO tot_nmn06
   DISPLAY l_tot8  TO tot_nmn08
 
END FUNCTION
 
FUNCTION i550_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmn TO s_nmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i550_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i550_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i550_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i550_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i550_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
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
         CALL cl_set_field_pic("","","","","",g_nmm.nmmacti)
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
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
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i550_nmn08(u_pa08)
DEFINE u_pa08              LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
       l_pa08              LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   CASE u_pa08
      WHEN 'i'
         IF l_ac>1 THEN
            LET l_pa08 = g_nmn[l_ac].nmn04 - g_nmn[l_ac-1].nmn04
 
            UPDATE nmn_file SET nmn08 = l_pa08
             WHERE nmn01 = g_nmm.nmm01
               AND nmn02 = g_nmm.nmm02
               AND nmn03 = g_nmn[l_ac-1].nmn03
            IF STATUS THEN
#              CALL cl_err('date u_pa1',SQLCA.sqlcode,1)   #No.FUN-660148
               CALL cl_err3("upd","nmn_file",g_nmm.nmm01,g_nmn[l_ac-1].nmn03,SQLCA.sqlcode,"","date u_pal",1)  #No.FUN-660148
            END IF
 
            LET g_nmn[l_ac-1].nmn08=l_pa08
         END IF
 
         LET l_pa08 = g_i550_day-g_nmn[l_ac].nmn04
 
         UPDATE nmn_file SET nmn08 = l_pa08
          WHERE nmn01 = g_nmm.nmm01
            AND nmn02 = g_nmm.nmm02
            AND nmn03 = g_nmn[l_ac].nmn03
         IF STATUS THEN
#           CALL cl_err('date u_pa2',SQLCA.sqlcode,1)   #No.FUN-660148
            CALL cl_err3("upd","nmn_file",g_nmm.nmm01,g_nmn[l_ac].nmn03,SQLCA.sqlcode,"","date u_pa2",1)  #No.FUN-660148
         END IF
         LET g_nmn[l_ac].nmn08=l_pa08
      WHEN 'd'
         IF l_ac>1 THEN
            LET l_pa08 = 0
            UPDATE nmn_file SET nmn08 = l_pa08
             WHERE nmn01 = g_nmm.nmm01
               AND nmn02 = g_nmm.nmm02
               AND nmn03 = g_nmn[l_ac-1].nmn03
            IF STATUS THEN
#             CALL cl_err('date u_pa08',SQLCA.sqlcode,1)   #No.FUN-660148
              CALL cl_err3("upd","nmn_file",g_nmm.nmm01,g_nmn[l_ac-1].nmn03,SQLCA.sqlcode,"","date u_pa08",1)  #No.FUN-660148
            END IF
         END IF
   END CASE
 
END FUNCTION
 
FUNCTION i550_upamt(u_pa)
DEFINE u_pa  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   CASE u_pa
     WHEN 'i'
        LET g_tot5_t=g_tot5_t + g_nmn[l_ac].nmn05
        LET g_tot6_t=g_tot6_t + g_nmn[l_ac].nmn06
        IF g_i550_day = 30 THEN
           LET g_tot8_t = 29
        END IF
 
        IF g_i550_day = 31 THEN
           LET g_tot8_t = 30
        END IF
 
        IF g_i550_day = 28 THEN
           LET g_tot8_t = 27
        END IF
 
        IF g_i550_day = 29 THEN
           LET g_tot8_t = 29
        END IF
   END CASE
 
   DISPLAY g_tot5_t TO tot_nmn05
   DISPLAY g_tot6_t TO tot_nmn06
   DISPLAY g_tot8_t TO tot_nmn08
 
END FUNCTION
 
FUNCTION i550_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nmm01,nmm02",TRUE)   #MOD-960078 add nmm02
   END IF
 
END FUNCTION
 
FUNCTION i550_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nmm01,nmm02",FALSE)   #MOD-960078 add nmm02
   END IF
 
END FUNCTION
 
#Patch....NO.MOD-5A0095 <003,001,002,004> #
#Patch....NO.TQC-610036 <001> #
