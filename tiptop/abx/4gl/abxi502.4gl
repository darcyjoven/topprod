# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi502.4gl
# Descriptions...: 保稅機器設備盤點資料建立維護作業
# Date & Author..: 2006/10/13 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/07/09 By ve 報表改為使用crystal report
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.TQC-780054 07/08/17 By sherry out內有（+）的語法改為INFOR
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-8C0040 09/02/01 by jan 語法修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-B10034 10/01/21 By Smapmin 取消確認時不清空確認人/確認日期
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-D20015 13/04/02 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_bze           RECORD LIKE bze_file.*,
    g_bze_t         RECORD LIKE bze_file.*,
    g_bze_o         RECORD LIKE bze_file.*,
    g_bze01_t       LIKE bze_file.bze01,
    g_bzf           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        bzf02       LIKE bzf_file.bzf02,          #項次
        bzf03       LIKE bzf_file.bzf03,          #機器設備編號
        bzf04       LIKE bzf_file.bzf04,          #序號
        bzb03       LIKE bzb_file.bzb03,          #保管部門
        gem02          LIKE gem_file.gem02,                #部門名稱
        bzb04       LIKE bzb_file.bzb04,          #保管人
        gen02          LIKE gen_file.gen02,                #人員名稱
        bza02       LIKE bza_file.bza02,          #機器設備中文名稱
        bza03       LIKE bza_file.bza03,          #機器設備英文名稱
        bza04       LIKE bza_file.bza04,          #機器設備規格
        bza05       LIKE bza_file.bza05,          #型態
        bza08       LIKE bza_file.bza08,          #單位
        bzf05       LIKE bzf_file.bzf05,          #帳面結餘數量
        bzf06       LIKE bzf_file.bzf06,          #外送數量
        bzf07       LIKE bzf_file.bzf07,          #盤點數量
        bzf08       LIKE bzf_file.bzf08           #備註
                       END RECORD,                   
    g_bzf_t         RECORD                        #程式變數 (舊值)
        bzf02       LIKE bzf_file.bzf02,          #項次
        bzf03       LIKE bzf_file.bzf03,          #機器設備編號
        bzf04       LIKE bzf_file.bzf04,          #序號
        bzb03       LIKE bzb_file.bzb03,          #保管部門
        gem02          LIKE gem_file.gem02,                #部門名稱
        bzb04       LIKE bzb_file.bzb04,          #保管人
        gen02          LIKE gen_file.gen02,                #人員名稱
        bza02       LIKE bza_file.bza02,          #機器設備中文名稱
        bza03       LIKE bza_file.bza03,          #機器設備英文名稱
        bza04       LIKE bza_file.bza04,          #機器設備規格
        bza05       LIKE bza_file.bza05,          #型態
        bza08       LIKE bza_file.bza08,          #單位
        bzf05       LIKE bzf_file.bzf05,          #帳面結餘數量
        bzf06       LIKE bzf_file.bzf06,          #外送數量
        bzf07       LIKE bzf_file.bzf07,          #盤點數量
        bzf08       LIKE bzf_file.bzf08           #備註
                       END RECORD,                   
    g_bzf_o         RECORD                        #程式變數 (舊值)
        bzf02       LIKE bzf_file.bzf02,          #項次
        bzf03       LIKE bzf_file.bzf03,          #機器設備編號
        bzf04       LIKE bzf_file.bzf04,          #序號
        bzb03       LIKE bzb_file.bzb03,          #保管部門
        gem02          LIKE gem_file.gem02,                #部門名稱
        bzb04       LIKE bzb_file.bzb04,          #保管人
        gen02          LIKE gen_file.gen02,                #人員名稱
        bza02       LIKE bza_file.bza02,          #機器設備中文名稱
        bza03       LIKE bza_file.bza03,          #機器設備英文名稱
        bza04       LIKE bza_file.bza04,          #機器設備規格
        bza05       LIKE bza_file.bza05,          #型態
        bza08       LIKE bza_file.bza08,          #單位
        bzf05       LIKE bzf_file.bzf05,          #帳面結餘數量
        bzf06       LIKE bzf_file.bzf06,          #外送數量
        bzf07       LIKE bzf_file.bzf07,          #盤點數量
        bzf08       LIKE bzf_file.bzf08           #備註
                       END RECORD,
    g_wc,g_wc2,g_sql   STRING,
    g_rec_b            LIKE type_file.num5,                     #單身筆數
    l_ac               LIKE type_file.num5                      #目前處理的ARRAY CNT
 
DEFINE   p_row,p_col          LIKE type_file.num5
DEFINE   g_forupd_sql         STRING         #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt                LIKE type_file.num10   
DEFINE   g_msg                LIKE type_file.chr1000
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_row_count          LIKE type_file.num10        #總筆數 
DEFINE   g_jump               LIKE type_file.num10        #查詢指定的筆數
DEFINE   mi_no_ask            LIKE type_file.num5       #是否開啟指定筆視窗
DEFINE   g_void               LIKE type_file.chr1
DEFINE   l_table              STRING                    #No.FUN-770005
DEFINE   g_str                STRING                    #No.FUN-770005
 
#主程式開始
MAIN
# DEFINE
#       l_time   LIKE type_file.chr8       #No.FUN-6A0062
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('abxi502',g_time,1) RETURNING g_time  #計算使用時間 (進入時間)  #FUN-B30211 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
#No.FUN-770005 --start--   
   LET g_sql=" bze01.bze_file.bze01,",
             " bze02.bze_file.bze02,",
             " bze03.bze_file.bze03,",
             " bze04.bze_file.bze04,",
             " bze05.bze_file.bze05,",
             " gen02a.gen_file.gen02,",
             " bze06.bze_file.bze06,",
             " bze07.bze_file.bze07,",
             " bzf02.bzf_file.bzf02,",
             " bzf03.bzf_file.bzf03,",
             " bzf04.bzf_file.bzf04,",
             " bzb03.bzb_file.bzb03,",
             " gem02.gem_file.gem02,",
             " bzb04.bzb_file.bzb04,",
             " gen02b.gen_file.gen02,",
             " bza02.bza_file.bza02,",
             " bza03.bza_file.bza03,",
             " bza04.bza_file.bza04,",
             " bza05.bza_file.bza05,",
             " bza08.bza_file.bza08,",
             " bzf05.bzf_file.bzf05,",
             " bzf06.bzf_file.bzf06,",
             " bzf07.bzf_file.bzf07,",
             " bzf08.bzf_file.bzf08"
   LET l_table=cl_prt_temptable('abxi502',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
#  LET g_sql="INSERT INTO ds_report.",l_table CLIPPED,              # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054 
             " VALUES (?,?,?,?,?,?,?,?,?,?,",
             "         ?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
#NO.FUN-770005--END-- 
   LET g_forupd_sql ="SELECT * FROM bze_file WHERE bze01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i502_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW i502_w AT p_row,p_col              #顯示畫面
        WITH FORM "abx/42f/abxi502" ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   INITIALIZE g_bze_t.* TO NULL
 
   CALL i502_menu()
   CLOSE WINDOW i502_w                    #結束畫面
   #CALL cl_used('abxi502',g_time,2) RETURNING g_time  #計算使用時間 (退出時間)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
END MAIN
 
#QBE 查詢資料
FUNCTION i502_cs()
 DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM                             #清除畫面
   CALL g_bzf.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bze.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON bze01,bze02,bze04,bze03,     #取單頭資料
                             bze05,bze06,bze07,bzeuser,
                             bzegrup,bzemodu,bzedate,bzeacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(bze05)  #確認人
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_bze.bze05
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bze05
                CALL i502_bze05('d')
                NEXT FIELD bze05
             OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzeuser', 'bzegrup') #FUN-980030
   
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bzeuser = '",g_user,"'"
   #   END IF
   
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bzegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   CONSTRUCT g_wc2 ON bzf02,bzf03,bzf04,bzf05,   #螢幕上取單身條件
                      bzf06,bzf07,bzf08
                 FROM s_bzf[1].bzf02,s_bzf[1].bzf03,s_bzf[1].bzf04,
                      s_bzf[1].bzf05,s_bzf[1].bzf06,s_bzf[1].bzf07,
                      s_bzf[1].bzf08
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION qbe_save
          CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  bze01 FROM bze_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY bze01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE bze_file. bze01 ",
                  "  FROM bze_file, bzf_file ",
                  " WHERE bze01 = bzf01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY bze01"
   END IF
 
   PREPARE i502_prepare FROM g_sql
   DECLARE i502_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i502_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM bze_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT bze01) FROM bze_file,bzf_file WHERE ",
                "bzf01=bze01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i502_precount FROM g_sql
   DECLARE i502_count CURSOR FOR i502_precount
END FUNCTION
 
FUNCTION i502_menu()
 
   WHILE TRUE
      CALL i502_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i502_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i502_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i502_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i502_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i502_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"       #"確認"
            IF cl_chk_act_auth() THEN
               CALL i502_y()
               CALL i502_pic()
            END IF
         WHEN "undo_confirm"  #"取消確認"
            IF cl_chk_act_auth() THEN
               CALL i502_z()
               CALL i502_pic()
            END IF
         WHEN "void"          #"作廢"
           IF cl_chk_act_auth() THEN
              #CALL i502_x() #FUN-D20025 mark
              CALL i502_x(1) #FUN-D20025 add
              CALL i502_pic()
           END IF
         #FUN-D20025 add
         WHEN "undo_void"          #"取消作廢"
           IF cl_chk_act_auth() THEN
              CALL i502_x(2)
              CALL i502_pic()
           END IF
         #FUN-D20025 add
         
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i502_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            CALL cl_export_to_excel
            (ui.Interface.getRootNode(),base.TypeInfo.create(g_bzf),'','')
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF g_bze.bze01 IS NOT NULL THEN
                 LET g_doc.column1 = "bze01"
                 LET g_doc.value1 = g_bze.bze01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i502_a()
   DEFINE   l_add1    LIKE bze_file.bze02
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bzf.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_add1= g_bze_t.bze02
 
   INITIALIZE g_bze.* LIKE bze_file.*             #DEFAULT 設定
   LET g_bze01_t = NULL
   #預設值及將數值類變數清成零
   LET g_bze_t.* = g_bze.*
   LET g_bze_o.* = g_bze.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_bze.bzeuser = g_user
      LET g_bze.bzegrup = g_grup
      LET g_bze.bzedate = g_today
      LET g_bze.bzeacti = 'Y'              #資料有效
      LET g_bze.bze07   = 'N'
 
     #連續新增時DEFAULT前一筆的bze02和bze04
      IF cl_null(l_add1) OR l_add1 = '1899/12/31' THEN 
         LET g_bze.bze02  = g_today
      ELSE
         LET g_bze.bze02  = l_add1
      END IF
      LET g_bze.bze04  = YEAR(g_bze.bze02)
 
      CALL i502_i("a")                     #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_bze.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_bze.bze01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK 
      LET g_bze.bzeoriu = g_user      #No.FUN-980030 10/01/04
      LET g_bze.bzeorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bze_file VALUES (g_bze.*)
 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN   #置入資料庫不成功
         CALL cl_err(g_bze.bze01,SQLCA.sqlcode,1)     #No.FUN-B80082---調整至回滾事務前---
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK       
      END IF
 
      SELECT bze01 INTO g_bze.bze01 FROM bze_file
       WHERE bze01 = g_bze.bze01
      LET g_bze01_t = g_bze.bze01        #保留舊值
      LET g_bze_t.* = g_bze.*
      LET g_bze_o.* = g_bze.*
 
      CALL g_bzf.clear()
 
      LET g_rec_b = 0  
      CALL i502_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i502_u()
   DEFINE l_n            LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bze.bze01)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bze.* FROM bze_file
    WHERE bze01 = g_bze.bze01
 
   #檢查資料是否為無效
   IF g_bze.bzeacti ='N' THEN
      CALL cl_err(g_bze.bze01,'mfg1000',0)
      RETURN
   END IF
 
   #確認或作廢單據不可再修改 
   IF g_bze.bze07='Y' OR g_bze.bze07 = 'X' THEN
      CALL cl_err(g_bze.bze01,'9022',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bze01_t = g_bze.bze01
   BEGIN WORK
 
   OPEN i502_cl USING g_bze.bze01
   IF STATUS THEN
      CALL cl_err("OPEN i502_cl:", STATUS, 1)
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i502_cl INTO g_bze.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i502_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i502_show()
 
   WHILE TRUE
      LET g_bze01_t = g_bze.bze01
      LET g_bze_o.* = g_bze.*
      LET g_bze.bzemodu = g_user
      LET g_bze.bzedate = g_today
 
      CALL i502_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bze.* = g_bze_t.*
         CALL i502_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_bze.bze01 != g_bze01_t THEN        # 更改:盤點底稿編號
         UPDATE bzf_file
            SET bzf01 = g_bze.bze01
          WHERE bzf01 = g_bze01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
      UPDATE bze_file
         SET bze_file.* = g_bze.*
       WHERE bze01 = g_bze01_t
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i502_cl
   COMMIT WORK
   CALL i502_pic()
END FUNCTION
FUNCTION i502_i(p_cmd)
DEFINE
   l_n            LIKE type_file.num5,
   p_cmd          LIKE type_file.chr1                #a:輸入 u:更改
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
 
   DISPLAY BY NAME g_bze.bze01,g_bze.bze02,g_bze.bze03,
                   g_bze.bze04,g_bze.bze05,g_bze.bze06,
                   g_bze.bze07,
                   g_bze.bzeuser,g_bze.bzegrup,
                   g_bze.bzeacti,g_bze.bzemodu,g_bze.bzedate
 
   INPUT BY NAME g_bze.bze01,g_bze.bze02,g_bze.bze04,
                 g_bze.bze03,
                 g_bze.bzeuser,g_bze.bzegrup,
                 g_bze.bzeacti,g_bze.bzemodu,g_bze.bzedate
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i502_set_entry(p_cmd)
         CALL i502_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
 
      AFTER FIELD bze01   #盤點底稿編號:不可空白,不可重覆
         IF NOT cl_null(g_bze.bze01) THEN
            IF (p_cmd="a") OR
               (p_cmd="u" AND g_bze.bze01 != g_bze01_t) THEN
                LET l_n = 0
                SELECT count(*) INTO l_n FROM bze_file
                  WHERE bze01 = g_bze.bze01
                IF l_n IS NULL THEN LET l_n = 0 END IF
                IF l_n > 0 THEN 
                   CALL cl_err(g_bze.bze01,-239,0)
                   LET g_bze.bze01 = g_bze01_t
                   DISPLAY BY NAME g_bze.bze01 
                   NEXT FIELD bze01
                END IF
            END IF
         END IF
 
      AFTER FIELD bze02
         IF NOT cl_null(g_bze.bze02) THEN
            LET g_bze.bze04 = YEAR(g_bze.bze02) 
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form
         (ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
   END INPUT
END FUNCTION
   
FUNCTION i502_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   INITIALIZE g_bze.* TO NULL
   CLEAR FORM
   CALL g_bzf.clear()
   DISPLAY ' ' TO FORMONLY.cnt  
 
   CALL i502_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_bze.* TO NULL
      RETURN
   END IF
 
   OPEN i502_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bze.* TO NULL
   ELSE
      OPEN i502_count
      FETCH i502_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i502_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION i502_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i502_cs INTO g_bze.bze01
      WHEN 'P' FETCH PREVIOUS i502_cs INTO g_bze.bze01
      WHEN 'F' FETCH FIRST    i502_cs INTO g_bze.bze01
      WHEN 'L' FETCH LAST     i502_cs INTO g_bze.bze01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
                   ON ACTION about
                      CALL cl_about()
                   ON ACTION help
                      CALL cl_show_help()
                   ON ACTION controlg
                      CALL cl_cmdask()
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i502_cs INTO g_bze.bze01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)
      INITIALIZE g_bze.* TO NULL
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
 
   SELECT * INTO g_bze.* FROM bze_file WHERE bze01 = g_bze.bze01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)
      INITIALIZE g_bze.* TO NULL
      RETURN
   END IF
 
   CALL i502_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i502_show()
   LET g_bze_t.* = g_bze.*                #保存單頭舊值
   LET g_bze_o.* = g_bze.*                #保存單頭舊值
   DISPLAY BY NAME
           g_bze.bze01,g_bze.bze02,g_bze.bze04,
           g_bze.bze03,g_bze.bze05,g_bze.bze06,
           g_bze.bze07,
           g_bze.bzeuser,g_bze.bzegrup,
           g_bze.bzeacti,g_bze.bzemodu,g_bze.bzedate
 
   CALL i502_bze05('d')
   CALL i502_b_fill(g_wc2)                 #單身
   CALL i502_pic()
END FUNCTION
 
FUNCTION i502_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bze.bze01)  THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bze.* FROM bze_file
    WHERE bze01=g_bze.bze01
 
   #檢查資料是否為無效
   IF g_bze.bzeacti = 'N' THEN
      CALL cl_err(g_bze.bze01,'mfg1000',0)
      RETURN
   END IF
 
   #確認或作廢單據不可再刪除
   IF g_bze.bze07='Y' OR g_bze.bze07 = 'X' THEN
      CALL cl_err(g_bze.bze01,'9021',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i502_cl USING g_bze.bze01
   IF STATUS THEN
      CALL cl_err("OPEN i502_cl:", STATUS, 1)
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i502_cl INTO g_bze.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i502_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bze01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bze.bze01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM bze_file WHERE bze01 = g_bze.bze01
      DELETE FROM bzf_file WHERE bzf01 = g_bze.bze01
      CLEAR FORM
      CALL g_bzf.clear()
 
      OPEN i502_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i502_cs
         CLOSE i502_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--

      FETCH i502_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i502_cs
         CLOSE i502_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i502_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i502_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i502_fetch('/')
      END IF
   END IF
   CLOSE i502_cl
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i502_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重複用
    l_cnt           LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
    p_cmd           LIKE type_file.chr1,               #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5               #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_bze.bze01)  THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF cl_null(g_bze.bze01)  THEN
       RETURN
    END IF
 
    #確認或作廢單據不可更改或刪除
    IF g_bze.bze07 = 'Y' OR g_bze.bze07 = 'X' THEN
      CALL cl_err('','9022',0)
      RETURN
    END IF
 
    SELECT * INTO g_bze.* FROM bze_file
     WHERE bze01=g_bze.bze01
 
    IF g_bze.bzeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_bze.bze01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bzf02,bzf03,bzf04,'','','','','','', ",
                       "       '','','', bzf05,bzf06,bzf07,bzf08 ",
                       "  FROM bzf_file ",
                       " WHERE bzf01=? AND bzf02=? FOR UPDATE "
    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i502_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bzf WITHOUT DEFAULTS FROM s_bzf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i502_cl USING g_bze.bze01
           IF STATUS THEN
              CALL cl_err("OPEN i502_cl:", STATUS, 1)
              CLOSE i502_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i502_cl INTO g_bze.*            # 鎖住將被更改或取消的資料
 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0) # 資料被他人LOCK
              CLOSE i502_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_bzf_t.* = g_bzf[l_ac].*  #BACKUP
              LET g_bzf_o.* = g_bzf[l_ac].*  #BACKUP
              OPEN i502_bcl USING g_bze.bze01,g_bzf_t.bzf02
              IF STATUS THEN
                 CALL cl_err("OPEN i502_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i502_bcl INTO g_bzf[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bzf_t.bzf03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i502_bzb03('d')
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_bzf[l_ac].* TO NULL      
           LET g_bzf_t.* = g_bzf[l_ac].*         #新輸入資料
           LET g_bzf_o.* = g_bzf[l_ac].*         #新輸入資料
           NEXT FIELD bzf02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           #(bzf03+bzf04)不可重複於不同的bze01
           IF NOT cl_null(g_bzf[l_ac].bzf03) THEN
              CALL i502_bzf03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 CALL g_bzf.deleteElement(l_ac)
                 CANCEL INSERT
              END IF
           END IF
           IF NOT cl_null(g_bzf[l_ac].bzf04) THEN
              CALL i502_bzf04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 CALL g_bzf.deleteElement(l_ac)
                 CANCEL INSERT
              END IF
           END IF
           INSERT INTO bzf_file(bzf01,bzf02,bzf03,bzf04,
                                   bzf05,bzf06,bzf07,bzf08)
           VALUES(g_bze.bze01,g_bzf[l_ac].bzf02,
                  g_bzf[l_ac].bzf03,g_bzf[l_ac].bzf04,
                  g_bzf[l_ac].bzf05,g_bzf[l_ac].bzf06,
                  g_bzf[l_ac].bzf07,g_bzf[l_ac].bzf08)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
              CALL cl_err(g_bzf[l_ac].bzf02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD bzf02                        #default 項次 
           IF cl_null(g_bzf[l_ac].bzf02) OR
              g_bzf[l_ac].bzf02 = 0 THEN
              SELECT max(bzf02)+1
                INTO g_bzf[l_ac].bzf02
                FROM bzf_file
               WHERE bzf01 = g_bze.bze01 
              IF cl_null(g_bzf[l_ac].bzf02) THEN
                 LET g_bzf[l_ac].bzf02 = 1
              END IF
           END IF
 
        AFTER FIELD bzf02                         #check 項次是否重複
           IF NOT cl_null(g_bzf[l_ac].bzf02) THEN
              IF (g_bzf[l_ac].bzf02 != g_bzf_t.bzf02)  
                 OR cl_null(g_bzf_t.bzf02) THEN
                 LET l_n = 0
                 SELECT count(*)
                   INTO l_n
                   FROM bzf_file
                  WHERE bzf01 = g_bze.bze01 
                    AND bzf02 = g_bzf[l_ac].bzf02
                 IF l_n IS NULL THEN LET l_n = 0 END IF
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,1)
                    LET g_bzf[l_ac].bzf02 = g_bzf_t.bzf02
                    NEXT FIELD bzf02
                 END IF
              END IF
           END IF
           LET g_bzf_o.bzf02 = g_bzf[l_ac].bzf02
 
        AFTER FIELD bzf03  #判斷bzf03值是否正確 
           IF NOT cl_null(g_bzf[l_ac].bzf03) THEN
              CALL i502_bzf03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 DISPLAY BY NAME g_bzf[l_ac].bzf03
                 LET g_bzf[l_ac].bzf03 = g_bzf_t.bzf03
                 NEXT FIELD bzf03
              END IF
              IF NOT cl_null(g_bzf[l_ac].bzf04) THEN
                 CALL i502_bzb03('d')
                 CALL i502_bzf06(p_cmd)
              END IF
           END IF
           DISPLAY BY NAME g_bzf[l_ac].bzf03
           DISPLAY BY NAME g_bzf[l_ac].bzf04
           LET g_bzf_o.bzf03 = g_bzf[l_ac].bzf03
           LET g_bzf_o.bzf04 = g_bzf[l_ac].bzf04
 
        AFTER FIELD bzf04
           #(bzf03+bzf04)不可重複於不同的bze01
           IF NOT cl_null(g_bzf[l_ac].bzf03) THEN
              CALL i502_bzf03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 DISPLAY BY NAME g_bzf[l_ac].bzf03
                 LET g_bzf[l_ac].bzf03 = g_bzf_t.bzf03
                 NEXT FIELD bzf03
              END IF
           END IF
           IF NOT cl_null(g_bzf[l_ac].bzf04) THEN
              CALL i502_bzf04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 DISPLAY BY NAME g_bzf[l_ac].bzf03,g_bzf[l_ac].bzf04
                 LET g_bzf[l_ac].bzf04 = g_bzf_t.bzf04
                 IF g_errno = '-239' THEN
                    NEXT FIELD bzf03
                 END IF
                 NEXT FIELD bzf04
              ELSE
                 CALL i502_bzf06(p_cmd)
              END IF
           END IF
           DISPLAY BY NAME g_bzf[l_ac].bzf03
           DISPLAY BY NAME g_bzf[l_ac].bzf04
           LET g_bzf_o.bzf03 = g_bzf[l_ac].bzf03
           LET g_bzf_o.bzf04 = g_bzf[l_ac].bzf04
 
        AFTER FIELD bzf07
           IF NOT cl_null(g_bzf[l_ac].bzf07) THEN
              IF g_bzf[l_ac].bzf07 < 0  THEN  
                 CALL cl_err(g_bzf[l_ac].bzf07,'aap-022',0)
                 NEXT FIELD bzf07
              END IF
           END IF
           LET g_bzf_o.bzf07 = g_bzf[l_ac].bzf07
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_bzf_t.bzf02 > 0 AND NOT cl_null(g_bzf_t.bzf02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN      #資料已經被鎖住,無法修改
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM bzf_file
               WHERE bzf01 = g_bze.bze01
                 AND bzf02 = g_bzf_t.bzf02
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err(g_bzf_t.bzf02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
           COMMIT WORK
 
        ON ROW CHANGE     
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)         #此筆資料放棄輸入或更改
              LET INT_FLAG = 0
              LET g_bzf[l_ac].* = g_bzf_t.*
              CLOSE i502_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #(bzf03+bzf04)不可重複於不同的bze01
           IF NOT cl_null(g_bzf[l_ac].bzf03) THEN
              CALL i502_bzf03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 DISPLAY BY NAME g_bzf[l_ac].bzf03
                 LET g_bzf[l_ac].bzf03 = g_bzf_t.bzf03
                 NEXT FIELD bzf03
              END IF
           END IF
           IF NOT cl_null(g_bzf[l_ac].bzf04) THEN
              CALL i502_bzf04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 DISPLAY BY NAME g_bzf[l_ac].bzf03,g_bzf[l_ac].bzf04
                 LET g_bzf[l_ac].bzf04 = g_bzf_t.bzf04
                 IF g_errno = '-239' THEN
                    NEXT FIELD bzf03
                 END IF
                 NEXT FIELD bzf04
              END IF
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bzf[l_ac].bzf02,-263,1)
              LET g_bzf[l_ac].* = g_bzf_t.*
           ELSE
              UPDATE bzf_file
                 SET bzf02 = g_bzf[l_ac].bzf02,
                     bzf03 = g_bzf[l_ac].bzf03,
                     bzf04 = g_bzf[l_ac].bzf04,
                     bzf05 = g_bzf[l_ac].bzf05,
                     bzf06 = g_bzf[l_ac].bzf06,
                     bzf07 = g_bzf[l_ac].bzf07,
                     bzf08 = g_bzf[l_ac].bzf08
               WHERE bzf01 = g_bze.bze01
                 AND bzf02 = g_bzf_t.bzf02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_bzf[l_ac].bzf02,SQLCA.sqlcode,0)
                 LET g_bzf[l_ac].* = g_bzf_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30034 mark
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_bzf[l_ac].* = g_bzf_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_bzf.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE i502_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30034 add
           CLOSE i502_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bzf02) AND l_ac > 1 THEN
              LET g_bzf[l_ac].* = g_bzf[l_ac-1].*
              LET g_bzf[l_ac].bzf02 = g_rec_b + 1 
              NEXT FIELD bzf02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP                     # 沿用所有欄位
           CASE 
              WHEN INFIELD(bzf03)              # 查詢機器設備明細資料           
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bzb"
                 LET g_qryparam.default1 = g_bzf[l_ac].bzf03
                 LET g_qryparam.default2 = g_bzf[l_ac].bzf04  
                 CALL cl_create_qry() 
                      RETURNING g_bzf[l_ac].bzf03,g_bzf[l_ac].bzf04
                 DISPLAY BY NAME g_bzf[l_ac].bzf03
                 IF NOT cl_null(g_bzf[l_ac].bzf03) THEN
                    CALL i502_bzf03(p_cmd)
                 END IF
                 IF NOT cl_null(g_bzf[l_ac].bzf04) THEN 
                    CALL i502_bzf04(p_cmd)
                    CALL i502_bzf06(p_cmd)
                 END IF
                 NEXT FIELD bzf03
              WHEN INFIELD(bzf04)                
                 CALL cl_init_qry_var()       
                 LET g_qryparam.form = "q_bzb"
                 LET g_qryparam.default1 = g_bzf[l_ac].bzf03  
                 LET g_qryparam.default2 = g_bzf[l_ac].bzf04 
                 CALL cl_create_qry()
                      RETURNING g_bzf[l_ac].bzf03,g_bzf[l_ac].bzf04
                 DISPLAY BY NAME g_bzf[l_ac].bzf04
                 IF NOT cl_null(g_bzf[l_ac].bzf04) THEN 
                    CALL i502_bzf04(p_cmd)
                    CALL i502_bzf06(p_cmd)
                 END IF
                 NEXT FIELD bzf04
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION controls                       #No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
    END INPUT
   
    CLOSE i502_bcl
    COMMIT WORK
    CALL i502_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i502_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bze_file WHERE bze01 = g_bze.bze01
         INITIALIZE  g_bze.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查機器設備
FUNCTION i502_bzf03(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1,
          l_bza01    LIKE bza_file.bza01
 
   LET g_errno = ' '
 
   SELECT  bza01 INTO l_bza01 FROM bza_file
      WHERE bza01   = g_bzf[l_ac].bzf03 
   CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_errno = 'mfg4010' #無此機器設備編號
       OTHERWISE
          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_bzf[l_ac].bzf03 = l_bza01
      DISPLAY BY NAME g_bzf[l_ac].bzf03
   END IF
END FUNCTION
 
#檢查機器設備、序號
FUNCTION i502_bzf04(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_n1       LIKE type_file.num5,
          l_bze01    LIKE bze_file.bze01,
          l_bzb02    LIKE bzb_file.bzb02,
          l_bzf01    LIKE bzf_file.bzf01
 
   LET g_errno = ' '
   LET l_n1 = 0
 
   IF (p_cmd='a') OR 
      (p_cmd='u'  AND 
       (g_bzf[l_ac].bzf03 != g_bzf_t.bzf03 OR 
       g_bzf[l_ac].bzf04 != g_bzf_t.bzf04)) THEN
 
      #---1.判斷資料是否重覆
      LET l_n1 = 0
      SELECT count(*) INTO l_n1 FROM bzf_file
       WHERE  bzf01 = g_bze.bze01
         AND  bzf03 = g_bzf[l_ac].bzf03
         AND  bzf04 = g_bzf[l_ac].bzf04
      IF l_n1 IS NULL THEN LET l_n1 = 0 END IF
      IF l_n1 >0 THEN #單身重複
         LET g_errno = '-239'
         RETURN
      END IF
 
      #---沒有重覆,判斷輸入資料是否存在(bzb02)
      SELECT bzb02 INTO l_bzb02 FROM bzb_file
       WHERE bzb01  = g_bzf[l_ac].bzf03 AND
             bzb02  = g_bzf[l_ac].bzf04
      CASE 
          WHEN SQLCA.sqlcode = 100
               LET g_errno = 'abx-020' #無此序號
          OTHERWISE
               LET g_errno = SQLCA.SQLCODE USING '-------'         
      END CASE
      IF p_cmd = 'd' OR cl_null(g_errno) THEN
         LET g_bzf[l_ac].bzf04 = l_bzb02
         DISPLAY BY NAME g_bzf[l_ac].bzf04
         CALL i502_bzb03('d')
      END IF         
   END IF
END FUNCTION
 
#計算bzf06和bzf07
FUNCTION i502_bzf06(p_cmd)
   DEFINE p_cmd            LIKE type_file.chr1,
          l_bzb07      LIKE  bzb_file.bzb07,
          l_bzb10      LIKE  bzb_file.bzb10,
          l_bzb11      LIKE  bzb_file.bzb11
 
   IF (g_bzf[l_ac].bzf03 != g_bzf_o.bzf03) OR 
       cl_null(g_bzf_o.bzf03) OR cl_null(g_bzf_o.bzf04) OR
      (g_bzf[l_ac].bzf04 != g_bzf_o.bzf04) THEN
      LET l_bzb10 = 0
      LET l_bzb11 = 0 
      SELECT bzb10,bzb11,bzb07
        INTO l_bzb10,l_bzb11,l_bzb07
        FROM bzb_file
       WHERE bzb01=g_bzf[l_ac].bzf03 
         AND bzb02=g_bzf[l_ac].bzf04
      IF cl_null(l_bzb07)  THEN  LET l_bzb07 = 0 END IF
      IF cl_null(l_bzb10)  THEN  LET l_bzb10 = 0 END IF
      IF cl_null(l_bzb11)  THEN  LET l_bzb11 = 0 END IF
      LET g_bzf[l_ac].bzf05 = l_bzb07
      LET g_bzf[l_ac].bzf06 = l_bzb10 - l_bzb11
      LET g_bzf[l_ac].bzf07 = g_bzf[l_ac].bzf05+g_bzf[l_ac].bzf06
      DISPLAY BY NAME g_bzf[l_ac].bzf05
      DISPLAY BY NAME g_bzf[l_ac].bzf06
      DISPLAY BY NAME g_bzf[l_ac].bzf07
   END IF
END FUNCTION
 
#秀值
FUNCTION i502_bzb03(p_cmd) 
   DEFINE   p_cmd      LIKE type_file.chr1,
            l_bzb01    LIKE bzb_file.bzb01,
            l_bzb03    LIKE bzb_file.bzb03,
            l_bzb04    LIKE bzb_file.bzb04,
            l_bza02    LIKE bza_file.bza02,
            l_bza03    LIKE bza_file.bza03,
            l_bza04    LIKE bza_file.bza04,
            l_bza05    LIKE bza_file.bza05,
            l_bza08    LIKE bza_file.bza08,
            l_gem02    LIKE gem_file.gem02,
            l_gen02    LIKE gen_file.gen02
 
   SELECT bzb03,bzb04,bzb01
     INTO l_bzb03,l_bzb04,l_bzb01
     FROM bzb_file
    WHERE bzb01 = g_bzf[l_ac].bzf03
      AND bzb02 = g_bzf[l_ac].bzf04 
 
   SELECT bza02,bza03,bza04,bza05,bza08
     INTO l_bza02,l_bza03,l_bza04,l_bza05,l_bza08
     FROM bza_file
    WHERE bza01 = g_bzf[l_ac].bzf03
 
   SELECT gem02 INTO l_gem02
     FROM gem_file
    WHERE gem01 = l_bzb03 AND gemacti='Y'
 
   SELECT gen02 INTO l_gen02
     FROM gen_file
    WHERE gen01 = l_bzb04 AND genacti='Y'
 
   LET g_bzf[l_ac].bzb03 = l_bzb03
   LET g_bzf[l_ac].bzb04 = l_bzb04
   LET g_bzf[l_ac].bza02 = l_bza02
   LET g_bzf[l_ac].bza03 = l_bza03
   LET g_bzf[l_ac].bza04 = l_bza04
   LET g_bzf[l_ac].bza05 = l_bza05
   LET g_bzf[l_ac].bza08 = l_bza08
   LET g_bzf[l_ac].gem02 = l_gem02
   LET g_bzf[l_ac].gen02 = l_gen02
 
   DISPLAY BY NAME
           g_bzf[l_ac].bzb03,g_bzf[l_ac].gem02,
           g_bzf[l_ac].bzb04,g_bzf[l_ac].gen02,
           g_bzf[l_ac].bza02,g_bzf[l_ac].bza03,
           g_bzf[l_ac].bza04,g_bzf[l_ac].bza05,
           g_bzf[l_ac].bza08,g_bzf[l_ac].bzf07
END FUNCTION
 
#BODY FILL UP
FUNCTION i502_b_fill(p_wc2)
   DEFINE   p_wc2  STRING
 
   LET g_sql = "SELECT bzf02,bzf03,bzf04,'','','','', ",
               " '','','','','',bzf05,bzf06,bzf07,bzf08 ",
               "  FROM bzf_file ",
               " WHERE bzf01 ='",g_bze.bze01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
 
   LET g_sql=g_sql CLIPPED," ORDER BY bzf02,bzf03 "
   DISPLAY g_sql
 
   PREPARE i502_pb FROM g_sql
   DECLARE bzf_cs                       #CURSOR
           CURSOR FOR i502_pb
 
   CALL g_bzf.clear()
   LET g_cnt = 1
 
   FOREACH bzf_cs INTO g_bzf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_ac = g_cnt  #查詢時要設定l_ac值,副程式中的條件式才可用使用
      CALL i502_bzb03("d")
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      CALL i502_bzb03("d") 
   END FOREACH
   CALL g_bzf.deleteElement(g_cnt)
  
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i502_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bzf TO s_bzf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ##################################################################
      # Standard 4ad ACTION
      ##################################################################
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
         CALL i502_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION previous
         CALL i502_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
      ON ACTION jump
         CALL i502_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1)  
      ON ACTION next
         CALL i502_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION last
         CALL i502_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION detail       #單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION confirm      #確認
        LET g_action_choice="confirm"
        EXIT DISPLAY
      ON ACTION undo_confirm #取消確認
        LET g_action_choice="undo_confirm"
        EXIT DISPLAY
      ON ACTION void         #作廢
        LET g_action_choice="void"
        EXIT DISPLAY
      #FUN-D20025 add
      ON ACTION undo_void         #取消作廢
        LET g_action_choice="undo_void"
        EXIT DISPLAY
      #FUN-D20025 add  
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL i502_pic()
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
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION about
         CALL cl_about()
#@    ON ACTION 相關文件
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i502_y()
   DEFINE l_cnt   LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 ------ add ------ begin
   IF cl_null(g_bze.bze01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
   IF g_bze.bze07='Y' THEN CALL cl_err('','9023',1) RETURN END IF
   IF g_bze.bze07='X' THEN CALL cl_err('','9024',1) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107
   SELECT * INTO g_bze.* FROM bze_file
   WHERE bze01=g_bze.bze01
#CHI-C30107 ------ add ------ end
   IF cl_null(g_bze.bze01) THEN
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
#CHI-C30107 ------ mark ------ begin
#  SELECT * INTO g_bze.* FROM bze_file
#   WHERE bze01=g_bze.bze01
#CHI-C30107 ------ mark ------ end
 
   IF g_bze.bze07='Y' THEN CALL cl_err('','9023',1) RETURN END IF
   IF g_bze.bze07='X' THEN CALL cl_err('','9024',1) RETURN END IF
 
   #---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM bzf_file
    WHERE bzf01=g_bze.bze01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      RETURN
   END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
 

   BEGIN WORK
 
   OPEN i502_cl USING g_bze.bze01
   IF STATUS THEN
      CALL cl_err("OPEN i502_cl:", STATUS, 1)
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i502_cl INTO g_bze.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_bze.bze07 = 'N' THEN
      LET g_bze.bze05 = g_user
      LET g_bze.bze06 = g_today
      LET g_bze.bze07 = 'Y'
      LET g_bze.bzemodu = g_user
      LET g_bze.bzedate = g_today
      CALL i502_bze05('d')
#     CALL i502_yi()        #CHI-D20015
   END IF
 
   CALL i502_show()
 
   IF INT_FLAG THEN                   #使用者不玩了
      LET g_bze.bze05 = NULL
      LET g_bze.bze06 = NULL
      LET g_bze.bze07 ='N' 
      LET INT_FLAG = 0
      DISPLAY By Name g_bze.bze05,g_bze.bze06,g_bze.bze07
      CALL cl_err('',9001,0)
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE bze_file
      SET bze05 = g_bze.bze05,
          bze06 = g_bze.bze06,
          bze07 = g_bze.bze07,
          bzemodu = g_bze.bzemodu,
          bzedate = g_bze.bzedate
    WHERE bze01 = g_bze.bze01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)
      CALL i502_show()
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE i502_cl
   COMMIT WORK
END FUNCTION
 
#CHI-D20015---mark--str--
#FUNCTION i502_yi()
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   INPUT BY NAME g_bze.bze05,g_bze.bze06 
#                 WITHOUT DEFAULTS
#      BEFORE INPUT
#         CALL cl_set_comp_required("bze06",TRUE)
#         NEXT FIELD bze05 
# 
#      AFTER FIELD bze05
#         IF NOT cl_null(g_bze.bze05) THEN
#            CALL i502_bze05('a')
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(g_bze.bze05,g_errno,0)
#               LET g_bze.bze05 = g_bze_o.bze05
#               DISPLAY BY NAME g_bze.bze05
#               NEXT FIELD bze05
#            END IF
#         END IF
# 
#      AFTER INPUT
#         CALL cl_set_comp_required("bze06",FALSE)
# 
#      ON ACTION CONTROLP
#         CASE
#           WHEN INFIELD(bze05)  #確認人
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_gen"
#                LET g_qryparam.default1 = g_bze.bze05
#                CALL cl_create_qry() RETURNING g_bze.bze05
#                DISPLAY BY NAME g_bze.bze05
#                CALL i502_bze05('d')
#                NEXT FIELD bze05
#           OTHERWISE EXIT CASE
#         END CASE
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
# 
#      ON ACTION about
#         CALL cl_about()
# 
#      ON ACTION help
#         CALL cl_show_help()
# 
#      ON ACTION controlg
#         CALL cl_cmdask()
#   END INPUT
#END FUNCTION
#CHI-D20015--mark--end--
 
FUNCTION i502_bze05(p_cmd)        #確認人
   DEFINE p_cmd      LIKE type_file.chr1,
          l_gen021   LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti
 
   LET g_errno = " "
   SELECT gen02,genacti INTO l_gen021,l_genacti
     FROM gen_file
     WHERE gen01 = g_bze.bze05
   CASE WHEN SQLCA.SQLCODE = 100
             LET g_errno = 'aoo-070'
             LET l_gen021 = NULL
        WHEN l_genacti='N'
             LET g_errno = '9028'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen021 TO FORMONLY.gen021
   END IF
END FUNCTION
 
FUNCTION i502_z()
 
   IF cl_null(g_bze.bze01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
 
   SELECT * INTO g_bze.* FROM bze_file
    WHERE bze01=g_bze.bze01
 
   IF g_bze.bze07='N' THEN CALL cl_err('','9002',1)    RETURN END IF
   IF g_bze.bze07='X' THEN CALL cl_err('','axr-103',1) RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK   
   OPEN i502_cl USING g_bze.bze01
   IF STATUS THEN
      CALL cl_err("OPEN i502_cl:", STATUS, 1)
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i502_cl INTO g_bze.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF g_bze.bze07 = 'Y' THEN
      #LET g_bze.bze05 = ''    #CHI-B10034
      #LET g_bze.bze06 = ''    #CHI-B10034
      LET g_bze.bze07 = 'N'
      LET g_bze.bzemodu = g_user
      LET g_bze.bzedate = g_today
   END IF
 
   CALL i502_show()
 
   UPDATE bze_file
      SET bze05 = g_bze.bze05,
          bze06 = g_bze.bze06,
          bze07 = g_bze.bze07,
          bzemodu = g_bze.bzemodu,
          bzedate = g_bze.bzedate
    WHERE bze01 = g_bze.bze01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)
      CALL i502_show()
      ROLLBACK WORK
      RETURN
   END IF
   CLOSE i502_cl
   COMMIT WORK
END FUNCTION
 
#FUNCTION i502_x() #FUN-D20025 mark
FUNCTION i502_x(p_type) #FUN-D20025 add
   
   DEFINE l_bzeconf LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add   
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_bze.bze01) THEN 
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   IF g_bze.bze07 = 'Y' THEN CALL cl_err('','abx-021',1) RETURN  END IF
   #FUN-D20025---begin 
    IF p_type = 1 THEN 
       IF g_bze.bze07='X' THEN RETURN END IF
    ELSE
       IF g_bze.bze07<>'X' THEN RETURN END IF
    END IF 
    #FUN-D20025---end 
   BEGIN WORK
 
   OPEN i502_cl USING g_bze.bze01
   IF STATUS THEN
      CALL cl_err("OPEN i502_cl:", STATUS, 1)
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i502_cl INTO g_bze.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i502_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_bze.bze07='X' THEN
      LET l_bzeconf = 'Y'  #取消作廢
   ELSE
      LET l_bzeconf = 'N'  #作廢
   END IF
 
   IF cl_void(0,0,l_bzeconf) THEN
      CASE 
          WHEN g_bze.bze07 = 'X'
               LET g_bze.bze05 = ''
               LET g_bze.bze06 = ''
               LET g_bze.bze07 = 'N'
          WHEN g_bze.bze07 = 'N'
               LET g_bze.bze05 = ''
               LET g_bze.bze06 = ''
               LET g_bze.bze07 = 'X'
      END CASE
      LET g_bze.bzemodu = g_user
      LET g_bze.bzedate = g_today
      CALL i502_show()
 
      UPDATE bze_file
         SET bze05 = g_bze.bze05,
             bze06 = g_bze.bze06,
             bze07 = g_bze.bze07,
             bzemodu = g_bze.bzemodu,
             bzedate = g_bze.bzedate
       WHERE bze01 = g_bze.bze01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_bze.bze01,SQLCA.sqlcode,0)
         CALL i502_show()
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   CLOSE i502_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i502_set_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("bze01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i502_set_no_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1 
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("bze01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i502_pic()
   IF g_bze.bze07 = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_bze.bze07,"","","",g_void,"")
END FUNCTION
 
FUNCTION i502_out()
DEFINE sr RECORD 
             bze01       LIKE bze_file.bze01,
             bze02       LIKE bze_file.bze02,
             bze03       LIKE bze_file.bze03,
             bze04       LIKE bze_file.bze04,
             bze05       LIKE bze_file.bze05,
             gen02a      LIKE gen_file.gen02,          #人員名稱
             bze06       LIKE bze_file.bze06,
             bze07       LIKE bze_file.bze07,
             bzf02       LIKE bzf_file.bzf02,          #項次
             bzf03       LIKE bzf_file.bzf03,          #機器設備編號
             bzf04       LIKE bzf_file.bzf04,          #序號
             bzb03       LIKE bzb_file.bzb03,          #保管部門
             gem02       LIKE gem_file.gem02,          #部門名稱
             bzb04       LIKE bzb_file.bzb04,          #保管人
             gen02b      LIKE gen_file.gen02,          #人員名稱
             bza02       LIKE bza_file.bza02,          #機器設備中文名稱
             bza03       LIKE bza_file.bza03,          #機器設備英文名稱
             bza04       LIKE bza_file.bza04,          #機器設備規格
             bza05       LIKE bza_file.bza05,          #型態
             bza08       LIKE bza_file.bza08,          #單位
             bzf05       LIKE bzf_file.bzf05,          #帳面結餘數量
             bzf06       LIKE bzf_file.bzf06,          #外送數量
             bzf07       LIKE bzf_file.bzf07,          #盤點數量
             bzf08       LIKE bzf_file.bzf08           #備註
          END RECORD,
       l_name LIKE type_file.chr20    # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
   CALL cl_del_data(l_table)
   IF g_bze.bze01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc=" bze01='",g_bze.bze01,"'"
   END IF
 
   CALL cl_wait()
#  CALL cl_outnam('abxi502') RETURNING l_name          #No.FUN-770005
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT bze01,bze02,bze03,bze04,bze05,b.gen02,bze06,bze07,bzf02,",
             "       bzf03,bzf04,bzb03,gem02,bzb04,c.gen02,bza02,bza03,",
             "       bza04,bza05,bza08,bzf05,bzf06,bzf07,bzf08 ",
             " FROM  bza_file,bzb_file,bze_file,bzf_file,",
             # " outer gem_file a,outer gen_file b,outer gen_file c",                 #No.TQC-780054
             " outer gem_file a,outer gen_file b,outer gen_file c",  #No.TQC-780054   
             " WHERE bza01=bzf03 AND bzb01=bzf03 AND bzb02=bzf04",
             #No.TQC-780054---Begin
            #"   AND bze01=bzf01 AND bze_file.bze05=b.gen01", #CHI-8C0040
             "   AND bze01=bzf01 AND bze_file.bze05=b.gen01",    #CHI-8C0040
            #"   AND bzb_file.bzb03=a.gem01 AND bzb_file.bzb04=c.gen01", #CHI-8C0040
             "   AND bzb_file.bzb03=a.gem01 AND bzb_file.bzb04=c.gen01",       #CHI-8C0040 
             "   AND bze01=bzf01 AND bze_file.bze05=b.gen01",
             "   AND bzb_file.bzb03=a.gem01 AND bzb_file.bzb04=c.gen01",
             #No.TQC-780054---End
             "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 
   PREPARE i502_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i502_co CURSOR FOR i502_p1        # SCROLL CURSOR
 
#  START REPORT i502_rep TO l_name           #No.FUN-770005
 
   FOREACH i502_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
         EXIT FOREACH
      END IF
      EXECUTE insert_prep USING 
            sr.bze01,sr.bze02,sr.bze03,sr.bze04,sr.bze05,sr.gen02a,sr.bze06,sr.bze07,sr.bzf02,
            sr.bzf03,sr.bzf04,sr.bzb03,sr.gem02,sr.bzb04,sr.gen02b,sr.bza02,sr.bza03,sr.bza04
            ,sr.bza05,sr.bza08,sr.bzf05,sr.bzf06,sr.bzf07,sr.bzf08 
#     OUTPUT TO REPORT i502_rep(sr.*)        #No.FUN-770005     
   END FOREACH
#No.FUN-770005 --mark--
{  FINISH REPORT i502_rep
 
   CLOSE i502_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
}
#No.FUN-770005 --end--
#No.FUN-770005 --start--
   SELECT zz05 INTO g_zz05  FROM zz_file WHERE zz01=g_prog
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(g_wc,'bze01,bze02,bze04,bze03,        
                          bze05,bze06,bze07,bzeuser,      
                          bzegrup,bzemodu,bzedate,bzeacti')
           RETURNING g_wc
      LET g_str = g_wc
   END IF
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str= g_str
   CALL cl_prt_cs3("abxi502","abxi502",g_sql,g_str)
#No.FUN-770005--end--
END FUNCTION
#No.FUN-770005--begin--
{
REPORT i502_rep(sr)
DEFINE l_last_sw  LIKE type_file.chr1          #No.FUN-690010 VARCHAR(1),
DEFINE sr RECORD 
             bze01       LIKE bze_file.bze01,
             bze02       LIKE bze_file.bze02,
             bze03       LIKE bze_file.bze03,
             bze04       LIKE bze_file.bze04,
             bze05       LIKE bze_file.bze05,
             gen02a      LIKE gen_file.gen02,          #人員名稱
             bze06       LIKE bze_file.bze06,
             bze07       LIKE bze_file.bze07,
             bzf02       LIKE bzf_file.bzf02,          #項次
             bzf03       LIKE bzf_file.bzf03,          #機器設備編號
             bzf04       LIKE bzf_file.bzf04,          #序號
             bzb03       LIKE bzb_file.bzb03,          #保管部門
             gem02       LIKE gem_file.gem02,          #部門名稱
             bzb04       LIKE bzb_file.bzb04,          #保管人
             gen02b      LIKE gen_file.gen02,          #人員名稱
             bza02       LIKE bza_file.bza02,          #機器設備中文名稱
             bza03       LIKE bza_file.bza03,          #機器設備英文名稱
             bza04       LIKE bza_file.bza04,          #機器設備規格
             bza05       LIKE bza_file.bza05,          #型態
             bza08       LIKE bza_file.bza08,          #單位
             bzf05       LIKE bzf_file.bzf05,          #帳面結餘數量
             bzf06       LIKE bzf_file.bzf06,          #外送數量
             bzf07       LIKE bzf_file.bzf07,          #盤點數量
             bzf08       LIKE bzf_file.bzf08           #備註
          END RECORD
 
        OUTPUT
                TOP MARGIN g_top_margin
                LEFT MARGIN g_left_margin
                BOTTOM MARGIN g_bottom_margin
                PAGE LENGTH g_page_line
 
        ORDER BY sr.bze01,sr.bzf02
 
        FORMAT
            PAGE HEADER
               PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
               PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
               LET g_pageno=g_pageno+1
               LET pageno_total=PAGENO USING '<<<',"/pageno"
               PRINT g_head CLIPPED,pageno_total
               PRINT g_dash2
               PRINT g_x[11],sr.bze01 CLIPPED, COLUMN (g_len/2),g_x[12],sr.bze02 CLIPPED
               PRINT g_x[14],sr.bze04 CLIPPED, COLUMN (g_len/2),g_x[15],sr.bze05 CLIPPED,'  ',sr.gen02a CLIPPED
               PRINT g_x[16],sr.bze06 CLIPPED, COLUMN (g_len/2),g_x[17],sr.bze07 CLIPPED
               PRINT g_x[13],sr.bze03 CLIPPED
               PRINT g_dash
               PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                              g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                              g_x[41],g_x[42],g_x[43]
               PRINTX name=H2 g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
                              g_x[49]
               PRINT g_dash1
               LET l_last_sw = 'y'
 
            BEFORE GROUP OF sr.bze01
               SKIP TO TOP OF PAGE
 
            ON EVERY ROW
               PRINTX name=D1 COLUMN g_c[31],cl_numfor(sr.bzf02,31,0),
                              COLUMN g_c[32],sr.bzf03,
                              COLUMN g_c[33],cl_numfor(sr.bzf04,33,0),
                              COLUMN g_c[34],sr.bzb03,
                              COLUMN g_c[35],sr.bzb04,
                              COLUMN g_c[36],sr.bza02,
                              COLUMN g_c[37],sr.bza04,
                              COLUMN g_c[38],sr.bza05,
                              COLUMN g_c[39],sr.bza08,
                              COLUMN g_c[40],cl_numfor(sr.bzf05,40,0),
                              COLUMN g_c[41],cl_numfor(sr.bzf06,41,0),
                              COLUMN g_c[42],cl_numfor(sr.bzf07,42,0),
                              COLUMN g_c[43],sr.bzf08
 
               PRINTX name=D2 COLUMN g_c[47],sr.gem02,
                              COLUMN g_c[48],sr.gen02b,
                              COLUMN g_c[49],sr.bza03
 
            ON LAST ROW
              IF g_zz05 = 'Y' THEN PRINT g_dash
                 CALL cl_prt_pos_wc(g_wc)
              END IF
              PRINT g_dash
              LET l_last_sw = 'n'
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
 
        PAGE TRAILER
            IF l_last_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-770005--end--
