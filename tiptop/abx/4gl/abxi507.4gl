# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi507.4gl
# Descriptions...: 保稅機器設備除帳建立作業
# Date & Author..: 2006/10/14 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能			
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-850089 08/05/20 By TSD.Ken 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/25 By Cockroach 21-->31 CR
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ABX
# Modify.........: No:CHI-B10034 10/01/21 By Smapmin 取消確認時不清空確認人/確認日期
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 13/02/05 By bart 無單身刪除單頭
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-C80072 12/03/27 By lujh 統一確認和取消確認時確認人員和確認日期的寫法 
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bzl           RECORD LIKE bzl_file.*,    
    g_bzl_t         RECORD LIKE bzl_file.*,     
    g_bzl_o         RECORD LIKE bzl_file.*,    
    g_bzl01_t       LIKE bzl_file.bzl01,
    g_bzm           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        bzm02       LIKE bzm_file.bzm02,    #項次
        bzm03       LIKE bzm_file.bzm03,    #機器設備編號
        bzm04       LIKE bzm_file.bzm04,    #序號
        bza02       LIKE bza_file.bza02,    #機器設備中文名稱
        bza03       LIKE bza_file.bza03,    #機器設備英文名稱
        bza04       LIKE bza_file.bza04,    #機器設備規格
        bzb03       LIKE bzb_file.bzb03,    #保管部門代號
        gem02          LIKE gem_file.gem02,          #部門名稱
        bzb04       LIKE bzb_file.bzb04,    #保管人     
        gen02          LIKE gen_file.gen02,          #人員名稱
        bzm05       LIKE bzm_file.bzm05,    #除帳數量    
        bzm06       LIKE bzm_file.bzm06     #備註     
        #FUN-840202 --start---
       ,bzmud01     LIKE bzm_file.bzmud01,
        bzmud02     LIKE bzm_file.bzmud02,
        bzmud03     LIKE bzm_file.bzmud03,
        bzmud04     LIKE bzm_file.bzmud04,
        bzmud05     LIKE bzm_file.bzmud05,
        bzmud06     LIKE bzm_file.bzmud06,
        bzmud07     LIKE bzm_file.bzmud07,
        bzmud08     LIKE bzm_file.bzmud08,
        bzmud09     LIKE bzm_file.bzmud09,
        bzmud10     LIKE bzm_file.bzmud10,
        bzmud11     LIKE bzm_file.bzmud11,
        bzmud12     LIKE bzm_file.bzmud12,
        bzmud13     LIKE bzm_file.bzmud13,
        bzmud14     LIKE bzm_file.bzmud14,
        bzmud15     LIKE bzm_file.bzmud15
        #FUN-840202 --end--
                       END RECORD,                   
    g_bzm_t         RECORD
        bzm02       LIKE bzm_file.bzm02,    #項次
        bzm03       LIKE bzm_file.bzm03,    #機器設備編號
        bzm04       LIKE bzm_file.bzm04,    #序號
        bza02       LIKE bza_file.bza02,    #機器設備中文名稱
        bza03       LIKE bza_file.bza03,    #機器設備英文名稱
        bza04       LIKE bza_file.bza04,    #機器設備規格
        bzb03       LIKE bzb_file.bzb03,    #保管部門代號
        gem02          LIKE gem_file.gem02,          #部門名稱
        bzb04       LIKE bzb_file.bzb04,    #保管人     
        gen02          LIKE gen_file.gen02,          #人員名稱
        bzm05       LIKE bzm_file.bzm05,    #除帳數量    
        bzm06       LIKE bzm_file.bzm06     #備註     
        #FUN-840202 --start---
       ,bzmud01     LIKE bzm_file.bzmud01,
        bzmud02     LIKE bzm_file.bzmud02,
        bzmud03     LIKE bzm_file.bzmud03,
        bzmud04     LIKE bzm_file.bzmud04,
        bzmud05     LIKE bzm_file.bzmud05,
        bzmud06     LIKE bzm_file.bzmud06,
        bzmud07     LIKE bzm_file.bzmud07,
        bzmud08     LIKE bzm_file.bzmud08,
        bzmud09     LIKE bzm_file.bzmud09,
        bzmud10     LIKE bzm_file.bzmud10,
        bzmud11     LIKE bzm_file.bzmud11,
        bzmud12     LIKE bzm_file.bzmud12,
        bzmud13     LIKE bzm_file.bzmud13,
        bzmud14     LIKE bzm_file.bzmud14,
        bzmud15     LIKE bzm_file.bzmud15
        #FUN-840202 --end--
                       END RECORD,                   
    g_bzm_o         RECORD                        
        bzm02       LIKE bzm_file.bzm02,    #項次
        bzm03       LIKE bzm_file.bzm03,    #機器設備編號
        bzm04       LIKE bzm_file.bzm04,    #序號
        bza02       LIKE bza_file.bza02,    #機器設備中文名稱
        bza03       LIKE bza_file.bza03,    #機器設備英文名稱
        bza04       LIKE bza_file.bza04,    #機器設備規格
        bzb03       LIKE bzb_file.bzb03,    #保管部門代號
        gem02          LIKE gem_file.gem02,          #部門名稱
        bzb04       LIKE bzb_file.bzb04,    #保管人     
        gen02          LIKE gen_file.gen02,          #人員名稱
        bzm05       LIKE bzm_file.bzm05,    #除帳數量    
        bzm06       LIKE bzm_file.bzm06     #備註     
        #FUN-840202 --start---
       ,bzmud01     LIKE bzm_file.bzmud01,
        bzmud02     LIKE bzm_file.bzmud02,
        bzmud03     LIKE bzm_file.bzmud03,
        bzmud04     LIKE bzm_file.bzmud04,
        bzmud05     LIKE bzm_file.bzmud05,
        bzmud06     LIKE bzm_file.bzmud06,
        bzmud07     LIKE bzm_file.bzmud07,
        bzmud08     LIKE bzm_file.bzmud08,
        bzmud09     LIKE bzm_file.bzmud09,
        bzmud10     LIKE bzm_file.bzmud10,
        bzmud11     LIKE bzm_file.bzmud11,
        bzmud12     LIKE bzm_file.bzmud12,
        bzmud13     LIKE bzm_file.bzmud13,
        bzmud14     LIKE bzm_file.bzmud14,
        bzmud15     LIKE bzm_file.bzmud15
        #FUN-840202 --end--
                       END RECORD,
    g_wc,g_wc2,g_sql   STRING,
    g_rec_b,g_i        LIKE type_file.num5,                     #單身筆數
    l_ac               LIKE type_file.num5                      #
DEFINE p_row,p_col     LIKE type_file.num5
 
DEFINE   g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt                LIKE type_file.num10   
DEFINE   g_msg                LIKE type_file.chr1000
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_row_count          LIKE type_file.num10               #總筆數 
DEFINE   g_jump               LIKE type_file.num10               #查詢指定的筆數
DEFINE   mi_no_ask            LIKE type_file.num5              #是否開啟指定筆視窗
DEFINE   g_t1                 LIKE type_file.chr5
DEFINE   l_table              STRING,    #FUN-850089 add
         g_str                STRING     #FUN-850089 add
 
MAIN
# DEFINE
#       l_time    LIKE type_file.chr8      #No.FUN-6A0062
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ABX")) THEN
       EXIT PROGRAM
    END IF
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bzl01.bzl_file.bzl01,",
              "bzl02.bzl_file.bzl02,",
              "bzl03.bzl_file.bzl03,",
              "bzl04.bzl_file.bzl04,",
              "gen02a.gen_file.gen02,",      #人員名稱
              "bzl05.bzl_file.bzl05,",
              "bzl06.bzl_file.bzl06,",
              "bzm02.bzm_file.bzm02,",       #項次
              "bzm03.bzm_file.bzm03,",       #機器設備編號
              "bzm04.bzm_file.bzm04,",       #序號
              "bza02.bza_file.bza02,",       #機器設備中文名稱
              "bza03.bza_file.bza03,",       #機器設備英文名稱
              "bza04.bza_file.bza04,",       #機器設備規格
              "bzb03.bzb_file.bzb03,",       #保管部門代號
              "gem02.gem_file.gem02,",       #部門名稱
              "bzb04.bzb_file.bzb04,",       #保管人
              "gen02b.gen_file.gen02,",      #人員名稱
              "bzm05.bzm_file.bzm05,",       #報廢數量
              "bzm06.bzm_file.bzm06"         #備註
                                          #21 items
  LET l_table = cl_prt_temptable('abxi507',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
    #CALL cl_used('abxi507',g_time,1) RETURNING g_time      #計算使用時間 (進入時間)  #FUN-B30211
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
    LET g_forupd_sql = "SELECT * FROM bzl_file   WHERE bzl01 = ? ", 
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i507_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 9
 
    OPEN WINDOW i507_w AT p_row,p_col      #顯示畫面
         WITH FORM "abx/42f/abxi507" ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    CALL i507_menu()
    CLOSE WINDOW i507_w                    #結束畫面
    #CALL cl_used('abxi507',g_time,2) RETURNING g_time      #計算使用時間 (退出時間)  #FUN-B30211
    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
END MAIN
 
FUNCTION i507_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM                              #清除畫面
   CALL g_bzm.clear()
   CALL cl_set_head_visible("","YES")      #No.FUN-6B0033			
 
   INITIALIZE g_bzl.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON bzl01,bzl02,bzl03,bzl04,bzl05,bzl06,
                             bzluser,bzlgrup,bzlmodu,bzldate,bzlacti
                             #FUN-840202   ---start---
                             ,bzlud01,bzlud02,bzlud03,bzlud04,bzlud05,
                             bzlud06,bzlud07,bzlud08,bzlud09,bzlud10,
                             bzlud11,bzlud12,bzlud13,bzlud14,bzlud15
                             #FUN-840202    ----end----
   
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP   
         CASE
           WHEN INFIELD(bzl01)  #除帳單號  
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1  = '2'
                LET g_qryparam.form  = "q_bzl01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bzl01
                NEXT FIELD bzl01
           WHEN INFIELD(bzl04)  #確認人
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_gen"  
                LET g_qryparam.default1 = g_bzl.bzl04
                CALL cl_create_qry() RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO bzl04
                CALL i507_bzl04('d') 
                NEXT FIELD bzl04
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzluser', 'bzlgrup') #FUN-980030
   
   IF INT_FLAG THEN
      RETURN
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bzluser = '",g_user,"'"
   #   END IF
   
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bzlgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #螢幕上取單身條件
   CONSTRUCT g_wc2 ON bzm02,bzm03,bzm04,bzm05,bzm06
           #No.FUN-840202 --start--
           ,bzmud01,bzmud02,bzmud03,bzmud04,bzmud05
           ,bzmud06,bzmud07,bzmud08,bzmud09,bzmud10
           ,bzmud11,bzmud12,bzmud13,bzmud14,bzmud15
           #No.FUN-840202 ---end---
 
           FROM s_bzm[1].bzm02,s_bzm[1].bzm03,s_bzm[1].bzm04,
                s_bzm[1].bzm05,s_bzm[1].bzm06
               #No.FUN-840202 --start--
               ,s_bzm[1].bzmud01,s_bzm[1].bzmud02,s_bzm[1].bzmud03,
                s_bzm[1].bzmud04,s_bzm[1].bzmud05,s_bzm[1].bzmud06,
                s_bzm[1].bzmud07,s_bzm[1].bzmud08,s_bzm[1].bzmud09,
                s_bzm[1].bzmud10,s_bzm[1].bzmud11,s_bzm[1].bzmud12,
                s_bzm[1].bzmud13,s_bzm[1].bzmud14,s_bzm[1].bzmud15
               #No.FUN-840202 ---end---
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
      LET g_sql = "SELECT bzl01 FROM bzl_file ",
                  " WHERE ", g_wc CLIPPED,
                  "   AND bzl00 = '2' ",
                  " ORDER BY bzl01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE bzl_file.bzl01 ",
                  "  FROM bzl_file, bzm_file ",
                  " WHERE bzl01 = bzm01",
                  "   AND bzl00 = '2' ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY bzl01"
   END IF
 
   PREPARE i507_prepare FROM g_sql
   DECLARE i507_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i507_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM bzl_file ",
                " WHERE bzl00 = '2'",
                "   AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT bzl01) FROM bzl_file,bzm_file ",
                " WHERE bzm01=bzl01 ",
                "   AND bzl00 = '2' ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i507_precount FROM g_sql
   DECLARE i507_count CURSOR FOR i507_precount
 
END FUNCTION
 
FUNCTION i507_menu()
 
   WHILE TRUE
      CALL i507_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i507_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i507_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i507_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i507_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i507_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i507_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i507_y()
               CALL i507_pic()
            END IF   
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i507_z()
               CALL i507_pic()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL i507_x() #FUN-D20025 mark
               CALL i507_x(1) #FUN-D20025 add
               CALL i507_pic()
            END IF
         #FUN-D20025 add
         WHEN "undo_void"          #"取消作廢"
            IF cl_chk_act_auth() THEN
               CALL i507_x(2)
               CALL i507_pic()
            END IF
         #FUN-D20025 add    
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bzm),'','')
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF g_bzl.bzl01 IS NOT NULL THEN
                 LET g_doc.column1 = "bzl01"
                 LET g_doc.value1 = g_bzl.bzl01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i507_a()
   DEFINE li_result   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bzm.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_bzl.* LIKE bzl_file.*             #DEFAULT 設定
   LET g_bzl01_t = ' ' 
 
   #預設值及將數值類變數清成零
   LET g_bzl_t.* = g_bzl.*
   LET g_bzl_o.* = g_bzl.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_bzl.bzluser = g_user
      LET g_bzl.bzlgrup = g_grup
      LET g_bzl.bzldate = g_today
      LET g_bzl.bzlacti = 'Y'      #資料有效
      LET g_bzl.bzl00 = '2'
      LET g_bzl.bzl02 = g_today
      LET g_bzl.bzl06 = 'N'
 
      LET g_bzl.bzlplant = g_plant  #FUN-980001 add
      LET g_bzl.bzllegal = g_legal  #FUN-980001 add
 
      CALL i507_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_bzl.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_bzl.bzl01) THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
 
      LET g_t1 = s_get_doc_no(g_bzl.bzl01)
      CALL s_auto_assign_no("abx",g_t1,g_bzl.bzl02,"D","","","","","")
           RETURNING li_result,g_bzl.bzl01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      #進行輸入之單號檢查
      CALL s_mfgchno(g_bzl.bzl01) RETURNING g_i,g_bzl.bzl01
      DISPLAY BY NAME g_bzl.bzl01
      IF NOT g_i THEN CONTINUE WHILE END IF
 
      LET g_bzl.bzloriu = g_user      #No.FUN-980030 10/01/04
      LET g_bzl.bzlorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bzl_file VALUES (g_bzl.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     #置入資料庫不成功
         CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,1)       #No.FUN-B80082---調整至回滾事務前---
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK       
      END IF
 
      SELECT bzl01 INTO g_bzl.bzl01
        FROM bzl_file
       WHERE bzl01 = g_bzl.bzl01
      LET g_bzl01_t = g_bzl.bzl01        #保留舊值
      LET g_bzl_t.* = g_bzl.*
      LET g_bzl_o.* = g_bzl.*
      CALL g_bzm.clear()
 
      LET g_rec_b = 0  
      CALL i507_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i507_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bzl.bzl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bzl.* FROM bzl_file
    WHERE bzl01 = g_bzl.bzl01
 
   IF g_bzl.bzlacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_bzl.bzl01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_bzl.bzl06 = 'Y' OR g_bzl.bzl06 = 'X' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bzl01_t = g_bzl.bzl01
   BEGIN WORK
 
   OPEN i507_cl USING g_bzl.bzl01
   IF STATUS THEN
      CALL cl_err("OPEN i507_cl:", STATUS, 1)
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i507_cl INTO g_bzl.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i507_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i507_show()
 
   WHILE TRUE
      LET g_bzl01_t = g_bzl.bzl01
      LET g_bzl_o.* = g_bzl.*
      LET g_bzl.bzlmodu=g_user
      LET g_bzl.bzldate=g_today
 
      CALL i507_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bzl.*=g_bzl_t.*
         CALL i507_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_bzl.bzl01 != g_bzl01_t THEN            # 更改單號
         UPDATE bzm_file SET bzm01 = g_bzl.bzl01
          WHERE bzm01 = g_bzl01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('bzm',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
       UPDATE bzl_file SET bzl_file.* = g_bzl.*
        WHERE bzl01 = g_bzl01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i507_cl
   COMMIT WORK
   CALL i507_pic()
END FUNCTION
 
FUNCTION i507_i(p_cmd)
DEFINE
   li_result      LIKE type_file.num5,
   p_cmd          LIKE type_file.chr1                #a:輸入 u:更改
 
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0033			
 
   DISPLAY BY NAME g_bzl.bzl00,g_bzl.bzl01,g_bzl.bzl02,
                   g_bzl.bzl03,
                   g_bzl.bzl04,g_bzl.bzl05,g_bzl.bzl06,
                   g_bzl.bzluser,g_bzl.bzlmodu,g_bzl.bzlgrup,
                   g_bzl.bzldate,g_bzl.bzlacti
                   #FUN-840202     ---start---
                   ,g_bzl.bzlud01,g_bzl.bzlud02,g_bzl.bzlud03,g_bzl.bzlud04,
                   g_bzl.bzlud05,g_bzl.bzlud06,g_bzl.bzlud07,g_bzl.bzlud08,
                   g_bzl.bzlud09,g_bzl.bzlud10,g_bzl.bzlud11,g_bzl.bzlud12,
                   g_bzl.bzlud13,g_bzl.bzlud14,g_bzl.bzlud15
                   #FUN-840202     ----end----
 
   INPUT BY NAME g_bzl.bzl00,g_bzl.bzl01,g_bzl.bzl02,
                 g_bzl.bzl03,
                 g_bzl.bzluser,g_bzl.bzlmodu,g_bzl.bzlgrup,
                 g_bzl.bzldate,g_bzl.bzlacti
                 #FUN-840202     ---start---
                 ,g_bzl.bzlud01,g_bzl.bzlud02,g_bzl.bzlud03,g_bzl.bzlud04,
                 g_bzl.bzlud05,g_bzl.bzlud06,g_bzl.bzlud07,g_bzl.bzlud08,
                 g_bzl.bzlud09,g_bzl.bzlud10,g_bzl.bzlud11,g_bzl.bzlud12,
                 g_bzl.bzlud13,g_bzl.bzlud14,g_bzl.bzlud15 
                 #FUN-840202     ----end----
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i507_set_entry(p_cmd)
        CALL i507_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
        LET g_bzl.bzl00 = '2'
 
      AFTER FIELD bzl01
        IF NOT cl_null(g_bzl.bzl01) THEN
           IF g_bzl.bzl01 != g_bzl01_t OR cl_null(g_bzl01_t) THEN
              #進行輸入之單號檢查
#             CALL s_check_no(g_sys,g_bzl.bzl01,g_bzl01_t,"D","bzl_file","bzl01","")
              CALL s_check_no("abx",g_bzl.bzl01,g_bzl01_t,"D","bzl_file","bzl01","")   #No.FUN-A40041
                   RETURNING li_result,g_bzl.bzl01
              DISPLAY BY NAME g_bzl.bzl01
              IF (NOT li_result) THEN
                 NEXT FIELD bzl01
              END IF
           END IF
        END IF
 
        #FUN-840202     ---start---
        AFTER FIELD bzlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bzl01) #除帳單號  
                 LET g_t1 = s_get_doc_no(g_bzl.bzl01)
#                CALL q_bna(FALSE,TRUE,g_t1,'D',g_sys) RETURNING g_t1
                 CALL q_bna(FALSE,TRUE,g_t1,'D','abx') RETURNING g_t1   #No.FUN-A40041
                 IF INT_FLAG THEN
                    LET INT_FLAG = 0
                 END IF
                 LET g_bzl.bzl01 = g_t1
                 DISPLAY BY NAME g_bzl.bzl01
                 NEXT FIELD bzl01
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
   END INPUT
END FUNCTION
   
FUNCTION i507_bzl04(p_cmd)        #確認人
   DEFINE p_cmd      LIKE type_file.chr1,
          l_gen021   LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti 
 
   LET g_errno = " "
   SELECT gen02,genacti INTO l_gen021,l_genacti
     FROM gen_file 
    WHERE gen01 = g_bzl.bzl04 
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'aap-038'
           LET l_gen021 = NULL
        WHEN l_genacti='N' 
           LET g_errno = '9028'
        OTHERWISE          
           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen021 TO FORMONLY.gen02_1
   END IF
 
END FUNCTION
   
FUNCTION i507_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   INITIALIZE g_bzl.* TO NULL
   CLEAR FORM
   CALL g_bzm.clear()
   DISPLAY ' ' TO FORMONLY.cnt  
 
   CALL i507_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_bzl.* TO NULL
      RETURN
   END IF
 
   OPEN i507_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bzl.* TO NULL
   ELSE
      OPEN i507_count
      FETCH i507_count INTO g_row_count      
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i507_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i507_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i507_cs INTO g_bzl.bzl01,g_bzl.bzl01
      WHEN 'P' FETCH PREVIOUS i507_cs INTO g_bzl.bzl01,g_bzl.bzl01
      WHEN 'F' FETCH FIRST    i507_cs INTO g_bzl.bzl01,g_bzl.bzl01
      WHEN 'L' FETCH LAST     i507_cs INTO g_bzl.bzl01,g_bzl.bzl01
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
            FETCH ABSOLUTE g_jump i507_cs INTO g_bzl.bzl01,g_bzl.bzl01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)
      INITIALIZE g_bzl.* TO NULL
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
 
   SELECT * INTO g_bzl.* FROM bzl_file WHERE bzl01 = g_bzl.bzl01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)
      INITIALIZE g_bzl.* TO NULL
      RETURN
   END IF
 
   CALL i507_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i507_show()
   LET g_bzl_t.* = g_bzl.*                #保存單頭舊值
   LET g_bzl_o.* = g_bzl.*                #保存單頭舊值
   DISPLAY BY NAME g_bzl.bzl00,g_bzl.bzl01,g_bzl.bzl02,
                   g_bzl.bzl03,
                   g_bzl.bzl04,g_bzl.bzl05,g_bzl.bzl06,
                   g_bzl.bzluser,g_bzl.bzlgrup,g_bzl.bzlmodu,
                   g_bzl.bzldate,g_bzl.bzlacti
                   #FUN-840202     ---start---
                   ,g_bzl.bzlud01,g_bzl.bzlud02,g_bzl.bzlud03,g_bzl.bzlud04,
                   g_bzl.bzlud05,g_bzl.bzlud06,g_bzl.bzlud07,g_bzl.bzlud08,
                   g_bzl.bzlud09,g_bzl.bzlud10,g_bzl.bzlud11,g_bzl.bzlud12,
                   g_bzl.bzlud13,g_bzl.bzlud14,g_bzl.bzlud15 
                   #FUN-840202     ----end----
   CALL i507_bzl04('d')
   CALL i507_b_fill(g_wc2)     
   CALL i507_pic()           
END FUNCTION
 
FUNCTION i507_r()
   DEFINE   l_d    LIKE type_file.num5              #檢查是否可刪除用
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bzl.bzl01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_bzl.bzl06 = 'Y' OR g_bzl.bzl06 = 'X' THEN
      CALL cl_err('',9021,0)
      RETURN
   END IF
 
   SELECT * INTO g_bzl.* FROM bzl_file
    WHERE bzl01=g_bzl.bzl01
   IF g_bzl.bzlacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_bzl.bzl01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i507_cl USING g_bzl.bzl01
   IF STATUS THEN
      CALL cl_err("OPEN i507_cl:", STATUS, 1)
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i507_cl INTO g_bzl.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i507_show()
 
   WHILE TRUE 
      IF cl_delh(0,0) THEN                   #確認一下
          INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "bzl01"         #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_bzl.bzl01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM bzl_file WHERE bzl01 = g_bzl.bzl01
         DELETE FROM bzm_file WHERE bzm01 = g_bzl.bzl01
         CLEAR FORM
         CALL g_bzm.clear()
         OPEN i507_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i507_cs
            CLOSE i507_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--

         FETCH i507_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i507_cs
            CLOSE i507_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i507_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i507_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i507_fetch('/')
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i507_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i507_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重複用
    l_cnt           LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5               #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN 
       RETURN
    END IF
 
    IF cl_null(g_bzl.bzl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_bzl.bzl06 = 'Y' OR g_bzl.bzl06 = 'X' THEN
       CALL cl_err('',9022,0)
       RETURN
    END IF
 
    SELECT * INTO g_bzl.* 
      FROM bzl_file
     WHERE bzl01=g_bzl.bzl01
 
    IF g_bzl.bzlacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_bzl.bzl01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bzm02,bzm03,bzm04,' ',' ',' ',' ',' ',",
                       "       ' ',' ',bzm05,bzm06 ",
                       #FUN-840202 --start-- 
                       ",bzmud01,bzmud02,bzmud03,bzmud04,bzmud05,",
                       "bzmud06,bzmud07,bzmud08,bzmud09,bzmud10,",
                       "bzmud11,bzmud12,bzmud13,bzmud14,bzmud15",
                       #FUN-840202 --end--
                       "  FROM bzm_file ",
                       "  WHERE bzm01=? AND bzm02=?  ",
                       " FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i507_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bzm WITHOUT DEFAULTS FROM s_bzm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i507_cl USING g_bzl.bzl01
           IF STATUS THEN
              CALL cl_err("OPEN i507_cl:", STATUS, 1)
              CLOSE i507_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i507_cl INTO g_bzl.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i507_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_bzm_t.* = g_bzm[l_ac].*  #BACKUP
              LET g_bzm_o.* = g_bzm[l_ac].*  #BACKUP
              OPEN i507_bcl USING g_bzl.bzl01, g_bzm_t.bzm02
              IF STATUS THEN
                 CALL cl_err("OPEN i507_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i507_bcl INTO g_bzm[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bzm_t.bzm02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i507_bzm03(p_cmd)
                 CALL i507_bzm04(p_cmd) 
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_bzm[l_ac].* TO NULL              
           LET g_bzm_t.* = g_bzm[l_ac].*         #新輸入資料
           LET g_bzm_o.* = g_bzm[l_ac].*         #新輸入資料
           LET g_bzm[l_ac].bzm05 = 0
           NEXT FIELD bzm02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF 
           CALL i507_bzm04(p_cmd)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_bzm[l_ac].bzm04,g_errno,1)
              CALL g_bzm.deleteElement(l_ac)
              CANCEL INSERT
           END IF   
           CALL i507_bzm05(p_cmd)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_bzm[l_ac].bzm05,g_errno,1)
              CALL g_bzm.deleteElement(l_ac)
              CANCEL INSERT
           END IF
           INSERT INTO bzm_file(bzm01,bzm02,bzm03,bzm04,bzm05,bzm06
                                  #FUN-840202 --start--
                                  ,bzmud01,bzmud02,bzmud03,
                                  bzmud04,bzmud05,bzmud06,
                                  bzmud07,bzmud08,bzmud09,
                                  bzmud10,bzmud11,bzmud12,
                                  bzmud13,bzmud14,bzmud15,
                                  #FUN-840202 --end--
                                  bzmplant,bzmlegal)  #FUN-980001 add
           VALUES(g_bzl.bzl01,g_bzm[l_ac].bzm02,
                  g_bzm[l_ac].bzm03,g_bzm[l_ac].bzm04,
                  g_bzm[l_ac].bzm05,g_bzm[l_ac].bzm06,
                  #FUN-840202 --start--
                  g_bzm[l_ac].bzmud01, g_bzm[l_ac].bzmud02,
                  g_bzm[l_ac].bzmud03, g_bzm[l_ac].bzmud04,
                  g_bzm[l_ac].bzmud05, g_bzm[l_ac].bzmud06,
                  g_bzm[l_ac].bzmud07, g_bzm[l_ac].bzmud08,
                  g_bzm[l_ac].bzmud09, g_bzm[l_ac].bzmud10,
                  g_bzm[l_ac].bzmud11, g_bzm[l_ac].bzmud12,
                  g_bzm[l_ac].bzmud13, g_bzm[l_ac].bzmud14,
                  g_bzm[l_ac].bzmud15,
                  #FUN-840202 --end--
                  g_plant,g_legal)  #FUN-980001 add
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err(g_bzm[l_ac].bzm02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD bzm02                     
           IF cl_null(g_bzm[l_ac].bzm02) OR g_bzm[l_ac].bzm02 = 0 THEN
              SELECT max(bzm02)+1
                INTO g_bzm[l_ac].bzm02
                FROM bzm_file
               WHERE bzm01 = g_bzl.bzl01
              IF cl_null(g_bzm[l_ac].bzm02) THEN
                 LET g_bzm[l_ac].bzm02 = 1
              END IF
           END IF
 
        AFTER FIELD bzm02
           IF NOT cl_null(g_bzm[l_ac].bzm02) THEN
              IF g_bzm[l_ac].bzm02 != g_bzm_t.bzm02 OR 
                 cl_null(g_bzm_t.bzm02) THEN 
                 SELECT count(*) INTO l_n
                   FROM bzm_file
                  WHERE bzm01 = g_bzl.bzl01 
                    AND bzm02 = g_bzm[l_ac].bzm02 
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bzm[l_ac].bzm02 = g_bzm_t.bzm02
                    DISPLAY BY NAME g_bzm[l_ac].bzm02   
                 END IF    
              END IF
           END IF
 
        AFTER FIELD bzm03
           IF NOT cl_null(g_bzm[l_ac].bzm03) THEN
              CALL i507_bzm03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bzm[l_ac].bzm03,g_errno,0)
                 LET g_bzm[l_ac].bzm03 = g_bzm_t.bzm03
                 DISPLAY BY NAME g_bzm[l_ac].bzm03
                 NEXT FIELD bzm03
              END IF   
           END IF
  
        AFTER FIELD bzm04
           IF NOT cl_null(g_bzm[l_ac].bzm03) AND 
              NOT cl_null(g_bzm[l_ac].bzm04) THEN
              CALL i507_bzm04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bzm[l_ac].bzm04,g_errno,0)
                 LET g_bzm[l_ac].bzm04 = g_bzm_t.bzm04
                 DISPLAY BY NAME g_bzm[l_ac].bzm04
                 NEXT FIELD bzm04
              END IF   
           END IF
 
        AFTER FIELD bzm05
           IF NOT cl_null(g_bzm[l_ac].bzm05) THEN
              CALL i507_bzm05(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bzm[l_ac].bzm05,g_errno,0)
                 LET g_bzm[l_ac].bzm05 = g_bzm_t.bzm05
                 DISPLAY BY NAME g_bzm[l_ac].bzm05
                 NEXT FIELD bzm05
              END IF   
           END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD bzmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_bzm_t.bzm02 > 0 AND NOT cl_null(g_bzm_t.bzm02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF
              DELETE FROM bzm_file
               WHERE bzm01 = g_bzl.bzl01
                 AND bzm02 = g_bzm_t.bzm02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_bzm_t.bzm02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bzm[l_ac].* = g_bzm_t.*
              CLOSE i507_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CALL i507_bzm04(p_cmd)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_bzm[l_ac].bzm04,g_errno,0)
              LET g_bzm[l_ac].bzm04 = g_bzm_t.bzm04
              DISPLAY BY NAME g_bzm[l_ac].bzm04
              NEXT FIELD bzm04
           END IF   
           CALL i507_bzm05(p_cmd)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_bzm[l_ac].bzm05,g_errno,0)
              LET g_bzm[l_ac].bzm05 = g_bzm_t.bzm05
              DISPLAY BY NAME g_bzm[l_ac].bzm05
              NEXT FIELD bzm05
           END IF   
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bzm[l_ac].bzm02,-263,1)
              LET g_bzm[l_ac].* = g_bzm_t.*
           ELSE
              UPDATE bzm_file SET bzm02=g_bzm[l_ac].bzm02,
                                     bzm03=g_bzm[l_ac].bzm03,
                                     bzm04=g_bzm[l_ac].bzm04,
                                     bzm05=g_bzm[l_ac].bzm05,
                                     bzm06=g_bzm[l_ac].bzm06,
                                     #FUN-840202 --start--
                                     bzmud01 = g_bzm[l_ac].bzmud01,
                                     bzmud02 = g_bzm[l_ac].bzmud02,
                                     bzmud03 = g_bzm[l_ac].bzmud03,
                                     bzmud04 = g_bzm[l_ac].bzmud04,
                                     bzmud05 = g_bzm[l_ac].bzmud05,
                                     bzmud06 = g_bzm[l_ac].bzmud06,
                                     bzmud07 = g_bzm[l_ac].bzmud07,
                                     bzmud08 = g_bzm[l_ac].bzmud08,
                                     bzmud09 = g_bzm[l_ac].bzmud09,
                                     bzmud10 = g_bzm[l_ac].bzmud10,
                                     bzmud11 = g_bzm[l_ac].bzmud11,
                                     bzmud12 = g_bzm[l_ac].bzmud12,
                                     bzmud13 = g_bzm[l_ac].bzmud13,
                                     bzmud14 = g_bzm[l_ac].bzmud14,
                                     bzmud15 = g_bzm[l_ac].bzmud15
                                     #FUN-840202 --end-- 
               WHERE bzm01=g_bzl.bzl01 
                 AND bzm02=g_bzm_t.bzm02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_bzm[l_ac].bzm02,SQLCA.sqlcode,0)
                 LET g_bzm[l_ac].* = g_bzm_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_bzm[l_ac].* = g_bzm_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_bzm.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF 
              CLOSE i507_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add 
           CLOSE i507_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bzm02) AND l_ac > 1 THEN
              LET g_bzm[l_ac].* = g_bzm[l_ac-1].*
              LET g_bzm[l_ac].bzm02 = g_rec_b + 1 
              NEXT FIELD bzm02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
              IF INFIELD(bzm03) THEN #保稅機器設備編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bzb"
                 LET g_qryparam.default1 = g_bzm[l_ac].bzm03
                 LET g_qryparam.default2 = g_bzm[l_ac].bzm04
                 CALL cl_create_qry() RETURNING g_bzm[l_ac].bzm03,g_bzm[l_ac].bzm04
                 DISPLAY BY NAME g_bzm[l_ac].bzm03,g_bzm[l_ac].bzm04
                 CALL i507_bzm03(p_cmd)
                 CALL i507_bzm04(p_cmd)
                 NEXT FIELD bzm03
              END IF
              IF INFIELD(bzm04) THEN #序號     
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bzb"
                 LET g_qryparam.default1 = g_bzm[l_ac].bzm03
                 LET g_qryparam.default2 = g_bzm[l_ac].bzm04
                 CALL cl_create_qry() RETURNING g_bzm[l_ac].bzm03,g_bzm[l_ac].bzm04 
                 DISPLAY BY NAME g_bzm[l_ac].bzm03,g_bzm[l_ac].bzm04
                 CALL i507_bzm04(p_cmd)
                 NEXT FIELD bzm04
              END IF
              
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
 
    CLOSE i507_bcl
    COMMIT WORK
#   CALL i507_delall() #CHI-C30002 mark
    CALL i507_delHeader()     #CHI-C30002 add

 
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION i507_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bzl.bzl01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bzl_file ",
                  "  WHERE bzl01 LIKE '",l_slip,"%' ",
                  "    AND bzl01 > '",g_bzl.bzl01,"'"
      PREPARE i507_pb1 FROM l_sql 
      EXECUTE i507_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
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
        # CALL i507_x() #FUN-D20025 mark
         CALL i507_x(1) #FUN-D20025 add
         CALL i507_pic()
      END IF 
      
      IF l_cho = 3 THEN    
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM bzl_file WHERE bzl01 = g_bzl.bzl01
         INITIALIZE g_bzl.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查機器設備
FUNCTION i507_bzm03(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1,
          l_bzaacti   LIKE bza_file.bzaacti
 
   LET g_errno = '' 
   SELECT bzaacti INTO l_bzaacti
     FROM bza_file
    WHERE bza01 = g_bzm[l_ac].bzm03 
   CASE WHEN SQLCA.SQLCODE = 100  
             LET g_errno = 'abx-019' 
             LET l_bzaacti = NULL
        WHEN l_bzaacti <> 'Y'
             LET g_errno = '9028' 
        OTHERWISE          
             LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
#檢查機器設備、序號
FUNCTION i507_bzm04(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_bza02   LIKE bza_file.bza02,
          l_bza03   LIKE bza_file.bza03,
          l_bza04   LIKE bza_file.bza04,
          l_bzb03   LIKE bzb_file.bzb03,
          l_gem02      LIKE gem_file.gem02,
          l_bzb04   LIKE bzb_file.bzb04,
          l_gen02      LIKE gen_file.gen02
 
   LET g_errno = ' '
   SELECT bza02,bza03,bza04,bzb03,bzb04
     INTO l_bza02,l_bza03,l_bza04,l_bzb03,l_bzb04
     FROM bza_file,bzb_file
    WHERE bza01 = bzb01
      AND bzb01 = g_bzm[l_ac].bzm03
      AND bzb02 = g_bzm[l_ac].bzm04 
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'abx-023'
           LET l_bza02 = NULL
           LET l_bza03 = NULL
           LET l_bza04 = NULL
           LET l_bzb03 = NULL
           LET l_bzb04 = NULL
        OTHERWISE          
           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_bzm[l_ac].bza02 = l_bza02
      LET g_bzm[l_ac].bza03 = l_bza03
      LET g_bzm[l_ac].bza04 = l_bza04
      LET g_bzm[l_ac].bzb03 = l_bzb03
      LET g_bzm[l_ac].bzb04 = l_bzb04
      SELECT gem02 INTO l_gem02
        FROM gem_file
       WHERE gem01 = g_bzm[l_ac].bzb03 
      LET g_bzm[l_ac].gem02 = l_gem02
      SELECT gen02 INTO l_gen02
        FROM gen_file
       WHERE gen01 = g_bzm[l_ac].bzb04 
      LET g_bzm[l_ac].gen02 = l_gen02
      DISPLAY BY NAME g_bzm[l_ac].bza02,g_bzm[l_ac].bza03,
                      g_bzm[l_ac].bza04,
                      g_bzm[l_ac].bzb03,g_bzm[l_ac].gem02,
                      g_bzm[l_ac].bzb04,
                      g_bzm[l_ac].gen02
   END IF
END FUNCTION
 
#檢查除帳數量
FUNCTION i507_bzm05(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_bzb07      LIKE bzb_file.bzb07
 
   LET g_errno = ''
   IF g_bzm[l_ac].bzm05 <= 0 THEN
      LET g_errno = '-32406'
   END IF
   LET l_bzb07 = 0
   SELECT bzb07 INTO l_bzb07
     FROM bzb_file
    WHERE bzb01 = g_bzm[l_ac].bzm03 
      AND bzb02 = g_bzm[l_ac].bzm04
   IF l_bzb07 IS NULL THEN LET l_bzb07 = 0 END IF
   IF g_bzm[l_ac].bzm05 > l_bzb07 THEN
      LET g_errno = 'abx-031'
   END IF
END FUNCTION
 
#FUNCTION i507_delall()
#
#   LET g_cnt = 0
#   SELECT COUNT(*) INTO g_cnt FROM bzm_file
#    WHERE bzm01 = g_bzl.bzl01  
#   IF g_cnt IS NULL THEN LET g_cnt = 0 END IF
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM bzl_file WHERE bzl01 = g_bzl.bzl01
#   END IF
#END FUNCTION
 
FUNCTION i507_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING
 
    
    LET g_sql = "SELECT bzm02,bzm03,bzm04,bza02,bza03,bza04,",
                "       bzb03,gem02,bzb04,gen02,bzm05,bzm06 ", 
                #No.FUN-840202 --start--
                ",bzmud01,bzmud02,bzmud03,bzmud04,bzmud05,",
                "bzmud06,bzmud07,bzmud08,bzmud09,bzmud10,",
                "bzmud11,bzmud12,bzmud13,bzmud14,bzmud15", 
                #No.FUN-840202 ---end---
                "  FROM bzm_file,bza_file,bzb_file, ",
                "       OUTER gem_file, OUTER gen_file ",
                " WHERE bzm01 ='",g_bzl.bzl01,"' ",   #單頭
                "   AND bza01 = bzm03 AND bzb01 = bzm03 ",
                "   AND gem_file.gem01 = bzb_file.bzb03 AND gen_file.gen01 = bzb_file.bzb04 ",
                "   AND bzb02 = bzm04 "
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY bzm02 "
    DISPLAY g_sql
 
    PREPARE i507_pb FROM g_sql
    DECLARE bzm_cs CURSOR FOR i507_pb       #CURSOR
 
    CALL g_bzm.clear()
    LET g_cnt = 1
 
    FOREACH bzm_cs INTO g_bzm[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_bzm.deleteElement(g_cnt)
  
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i507_y()
   DEFINE  p_cmd   LIKE type_file.chr1   
 
   IF s_shut(0) THEN
      RETURN
   END IF
#CHI-C30107 --------- add ---------- begin
   IF cl_null(g_bzl.bzl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_bzl.bzl06 = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF g_bzl.bzl06 = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
#CHI-C30107 --------- add ---------- end
   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 add
   SELECT * INTO g_bzl.* FROM bzl_file WHERE bzl01 = g_bzl.bzl01
   IF cl_null(g_bzl.bzl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_bzl.bzl06 = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF 
   IF g_bzl.bzl06 = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF  
#  IF cl_confirm('axm-108') THEN #CHI-C30107
      CALL i507_update('y')
#  END IF  #CHI-C30107
END FUNCTION 
 
FUNCTION i507_update(p_cmd)
   DEFINE l_bzb07   LIKE bzb_file.bzb07,  #帳面結餘數量
          l_bzm     RECORD LIKE bzm_file.*,
          p_cmd        LIKE type_file.chr1,
          l_gen02   LIKE gen_file.gen02    #CHI-C80072 add 
 
   BEGIN WORK
 
   OPEN i507_cl USING g_bzl.bzl01
   IF STATUS THEN
      CALL cl_err("OPEN i507_cl:", STATUS, 1)
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i507_cl INTO g_bzl.*           # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,1)    # 資料被他人LOCK
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_bzl_t.* = g_bzl.*   #備份值
   
   LET g_bzl.bzldate = g_today
   LET g_bzl.bzlmodu = g_user
   IF p_cmd = 'y' THEN
      LET g_bzl.bzl04 = g_user
      LET g_bzl.bzl05 = g_today
      LET g_bzl.bzl06 = 'N' 
      #CALL i507_yi()     #CHI-C80072  mark
      LET g_bzl.bzl06 = 'Y' 
   ELSE
      #LET g_bzl.bzl04 = ''   #CHI-B10034
      #LET g_bzl.bzl05 = ''   #CHI-B10034
      LET g_bzl.bzl06 = 'N'
      LET g_bzl.bzl04 = g_user     #CHI-C80072 add
      LET g_bzl.bzl05 = g_today    #CHI-C80072 add
   END IF
 
   IF INT_FLAG THEN
      LET g_bzl.* = g_bzl_t.*
      DISPLAY BY NAME g_bzl.bzl04,g_bzl.bzl05,g_bzl.bzl06,
                      g_bzl.bzlmodu,g_bzl.bzldate
      DISPLAY '' TO FORMONLY.gen02_1
      LET INT_FLAG = 0
      CALL cl_err('',9001,1)
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #開始異動資料
   LET g_success = 'Y'
 
   UPDATE bzl_file SET bzl04 = g_bzl.bzl04,
                          bzl05 = g_bzl.bzl05,
                          bzl06 = g_bzl.bzl06,
                          bzlmodu = g_bzl.bzlmodu,
                          bzldate = g_bzl.bzldate
    WHERE bzl01 = g_bzl.bzl01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_bzl.bzl01,SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_bzl.bzl04    #CHI-C80072 add
   DISPLAY l_gen02 TO gen02_1                                           #CHI-C80072 add
   IF g_success = 'Y' THEN
      LET g_sql = "SELECT * ", 
                  "  FROM bzm_file ",
                  " WHERE bzm01 ='",g_bzl.bzl01,"'  "  
      PREPARE i507_upd FROM g_sql
      DECLARE bzb_update CURSOR FOR i507_upd                      
      FOREACH bzb_update INTO l_bzm.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
         IF p_cmd = 'y' THEN 
            LET l_bzb07 = 0
            SELECT bzb07 INTO l_bzb07
              FROM bzb_file
             WHERE bzb01 = l_bzm.bzm03
               AND bzb02 = l_bzm.bzm04
            IF l_bzb07 IS NULL THEN
               LET l_bzb07 = 0
            END IF
            IF l_bzm.bzm05 > l_bzb07 THEN    #不可大於帳面結餘數量
               CALL cl_err(g_bzm[l_ac].bzm05,'abx-031',1)
               LET g_success = 'N'
               EXIT FOREACH 
            END IF
            UPDATE bzb_file SET bzb13 = bzb13 + l_bzm.bzm05,
                                   bzb08 = '3',
                                   bzb09 = g_bzl.bzl05
             WHERE bzb_file.bzb01 = l_bzm.bzm03
               AND bzb_file.bzb02 = l_bzm.bzm04 
         ELSE 
            UPDATE bzb_file SET bzb13 = bzb13 - l_bzm.bzm05,
                                   bzb08 = '1',
                                   bzb09 = ''
             WHERE bzb_file.bzb01 = l_bzm.bzm03 
               AND bzb_file.bzb02 = l_bzm.bzm04
         END IF   
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_bzl.bzl01,SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
         #update 帳面結餘數量
         UPDATE bzb_file 
            SET bzb07 = bzb05 - bzb10 + bzb11 - bzb12 - bzb13
            WHERE bzb_file.bzb01 = l_bzm.bzm03 
              AND bzb_file.bzb02 = l_bzm.bzm04 
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_bzl.bzl01,SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
         #加總單身帳面結餘數量至單頭
         LET l_bzb07 = 0  
         SELECT sum(bzb07) INTO l_bzb07
           FROM bzb_file
          WHERE bzb_file.bzb01 = l_bzm.bzm03 
         UPDATE bza_file SET bza16 = l_bzb07     
          WHERE bza_file.bza01 = l_bzm.bzm03
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_bzl.bzl01,SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF 
         #寫入或刪除異動檔bzp_file
         IF p_cmd = 'y' THEN 
            INSERT INTO bzp_file(bzp01,bzp02,bzp03,bzp04,
                                    bzp05,bzp06,bzp07,bzp08,
                                    bzp09,
                                    bzpplant,bzplegal)  #FUN-980001 add
                        VALUES(g_bzl.bzl01,l_bzm.bzm02,
                               g_today,'D','-1',
                               l_bzm.bzm03,l_bzm.bzm04,
                               l_bzm.bzm05,g_bzl.bzl05,
                               g_plant,g_legal)  #FUN-980001 add
         ELSE 
            DELETE FROM bzp_file
             WHERE bzp01 = g_bzl.bzl01
               AND bzp02 = l_bzm.bzm02 
         END IF
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
      END FOREACH
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)  #顯示 COMMIT WORK 訊息
   ELSE
      ROLLBACK WORK
      LET g_bzl.* = g_bzl_t.*
      CALL cl_rbmsg(4)  #顯示 ROLLBACK WORK 訊息
   END IF
   CLOSE i507_cl
   DISPLAY BY NAME g_bzl.bzl04,g_bzl.bzl05,g_bzl.bzl06,
                   g_bzl.bzlmodu,g_bzl.bzldate
   IF cl_null(g_bzl.bzl04) THEN
      DISPLAY '' TO FORMONLY.gen02_1
   END IF
END FUNCTION 
 
FUNCTION i507_yi()    #確認後輸入確認人及確認日期
   DEFINE  p_cmd  LIKE type_file.chr1
   
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INPUT BY NAME g_bzl.bzl04,g_bzl.bzl05,g_bzl.bzl06
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         NEXT FIELD bzl04
 
      AFTER FIELD bzl04
         IF NOT cl_null(g_bzl.bzl04) THEN
            CALL i507_bzl04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('bzl04',g_errno,0)
               NEXT FIELD bzl04
            END IF
         END IF
 
      AFTER FIELD bzl05     
         IF NOT cl_null(g_bzl.bzl05) THEN
            IF g_bzl.bzl05 < g_bzl.bzl02 THEN
               CALL cl_err(g_bzl.bzl05,'abx-026',0)
               NEXT FIELD bzl05
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_bzl.bzl05 < g_bzl.bzl02 THEN
            CALL cl_err(g_bzl.bzl05,'abx-026',0)
            NEXT FIELD bzl05
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bzl04)  #確認人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"  
                 LET g_qryparam.default1 = g_bzl.bzl04
                 CALL cl_create_qry() RETURNING g_bzl.bzl04 
                 DISPLAY BY NAME g_bzl.bzl04
                 CALL i507_bzl04('d') 
                 NEXT FIELD bzl04
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
END FUNCTION
 
FUNCTION i507_z()   #取消確認
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF cl_null(g_bzl.bzl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   IF g_bzl.bzl06 = 'X' OR g_bzl.bzl06 = 'N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF cl_confirm('axm-109') THEN
      CALL i507_update('z')
   END IF
 
END FUNCTION
 
#FUNCTION i507_x()     #作廢 #FUN-D20025 mark
FUNCTION i507_x(p_type)  #作廢  #FUN-D20025 add

   DEFINE l_void  LIKE type_file.chr1    
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bzl.bzl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #FUN-D20025 add 從begin work里移出
   IF g_bzl.bzl06 = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   #FUN-D20025 add
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_bzl.bzl06='X' THEN RETURN END IF
   ELSE
      IF g_bzl.bzl06<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end    
   BEGIN WORK
 
   OPEN i507_cl USING g_bzl.bzl01
   IF STATUS THEN
      CALL cl_err("OPEN i507_cl:", STATUS, 1)
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i507_cl INTO g_bzl.*           # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzl.bzl01,SQLCA.sqlcode,0)    # 資料被他人LOCK
      CLOSE i507_cl
      ROLLBACK WORK
      RETURN
   END IF
   #FUN-D20025 mark 移到begin work 外面 
   #IF g_bzl.bzl06 = 'Y' THEN
   #   CALL cl_err('','9023',0)
   #   RETURN
   #END IF
   #FUN-D20025 mark 
   LET g_bzl_t.* = g_bzl.*   #備份值
 
   IF g_bzl.bzl06 = 'X' THEN
      LET l_void = 'Y'    #取消作廢?
   ELSE 
      LET l_void = 'N'    #要作廢?
   END IF
   LET g_bzl.bzldate = g_today
   LET g_bzl.bzlmodu = g_user
 
   IF cl_void(0,0,l_void) THEN
      CASE 
         WHEN g_bzl.bzl06 = 'N'
              LET g_bzl.bzl06 = 'X'
         WHEN g_bzl.bzl06 = 'X'
              LET g_bzl.bzl06 = 'N'
      END CASE
      UPDATE bzl_file SET bzl06 = g_bzl.bzl06,
                             bzlmodu = g_bzl.bzlmodu,
                             bzldate = g_bzl.bzldate
       WHERE bzl01 = g_bzl.bzl01
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('',SQLCA.SQLCODE,0)
         LET g_bzl.* = g_bzl_t.*
         ROLLBACK WORK
      ELSE
         COMMIT WORK
      END IF
      DISPLAY BY NAME g_bzl.bzl06,
                      g_bzl.bzlmodu,g_bzl.bzldate
      CLOSE i507_cl
   END IF
END FUNCTION
 
FUNCTION i507_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bzm TO s_bzm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION first
         CALL i507_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION previous
         CALL i507_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
      ON ACTION jump
         CALL i507_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1)  
      ON ACTION next
         CALL i507_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION last
         CALL i507_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL i507_pic()
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
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION void          
         LET g_action_choice="void"         
         EXIT DISPLAY
      #FUN-D20025 add
      ON ACTION undo_void         #取消作廢
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20025 add    
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
 
FUNCTION i507_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bzl01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i507_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bzl01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i507_pic()
   DEFINE l_void LIKE type_file.chr1
   IF g_bzl.bzl06 = 'X' THEN
      LET l_void = 'Y'
   ELSE
      LET l_void = 'N'
   END IF
   CALL cl_set_field_pic(g_bzl.bzl06,"","","",l_void,"")
END FUNCTION
 
FUNCTION i507_out()
DEFINE sr RECORD 
             bzl01       LIKE bzl_file.bzl01, 
             bzl02       LIKE bzl_file.bzl02,
             bzl03       LIKE bzl_file.bzl03,
             bzl04       LIKE bzl_file.bzl04,
             gen02a      LIKE gen_file.gen02,
             bzl05       LIKE bzl_file.bzl05,
             bzl06       LIKE bzl_file.bzl06,
             bzm02       LIKE bzm_file.bzm02,    #項次
             bzm03       LIKE bzm_file.bzm03,    #機器設備編號
             bzm04       LIKE bzm_file.bzm04,    #序號
             bza02       LIKE bza_file.bza02,    #機器設備中文名稱
             bza03       LIKE bza_file.bza03,    #機器設備英文名稱
             bza04       LIKE bza_file.bza04,    #機器設備規格
             bzb03       LIKE bzb_file.bzb03,    #保管部門
             gem02       LIKE gem_file.gem02,    #保管部門名稱
             bzb04       LIKE bzb_file.bzb04,    #保管人
             gen02b      LIKE gen_file.gen02,    #人員名稱
             bzm05       LIKE bzm_file.bzm05,    #報廢數量
             bzm06       LIKE bzm_file.bzm06     #備註
          END RECORD,
       l_name LIKE type_file.chr20    # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#FUN-850089 add---START
   DEFINE l_sql    STRING
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
 
   IF g_bzl.bzl01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc=" bzl01='",g_bzl.bzl01,"'"
   END IF
 
   CALL cl_wait()
#   CALL cl_outnam('abxi507') RETURNING l_name        #FUN-850089
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
LET g_sql="SELECT bzl01,bzl02,bzl03,bzl04,b.gen02,bzl05,bzl06,",
          "       bzm02,bzm03,bzm04,d.bza02,d.bza03,d.bza04,e.bzb03,a.gem02,",
          "       e.bzb04,c.gen02,bzm05,bzm06 ",
          "  FROM bzl_file LEFT OUTER JOIN gen_file b ON bzl_file.bzl04=b.gen01,",
          "       bzm_file LEFT OUTER JOIN bza_file d ON bzm_file.bzm03=d.bza01 ",
          "                LEFT OUTER JOIN (bzb_file e LEFT OUTER JOIN gen_file c ",
          "                ON e.bzb04=c.gen01 LEFT OUTER JOIN gem_file a ON e.bzb03=a.gem01) ",
          "                ON bzm_file.bzm03=e.bzb01 AND bzm_file.bzm04=e.bzb02 ",
          " WHERE bzm01=bzl01 AND bzl00='2'",
          "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 
   PREPARE i507_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i507_co CURSOR FOR i507_p1        # SCROLL CURSOR
 
#   START REPORT i507_rep TO l_name              #FUN-850089
 
   FOREACH i507_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
         EXIT FOREACH
      END IF
#      OUTPUT TO REPORT i507_rep(sr.*)          #FUN-850089
      #---FUN-850089 add---START
      EXECUTE insert_prep USING  
           sr.bzl01,sr.bzl02,sr.bzl03
           ,sr.bzl04,sr.gen02a,sr.bzl05,sr.bzl06,sr.bzm02
           ,sr.bzm03,sr.bzm04,sr.bza02,sr.bza03,sr.bza04
           ,sr.bzb03,sr.gem02,sr.bzb04,sr.gen02b,sr.bzm05,sr.bzm06
      #---FUN-850089 add---END
   END FOREACH
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bzl01,bzm02"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'bzl01,bzl02,bzl03,bzl04,bzl05,bzluser,bzlgrup,bzlmodu,bzldate,bzlacti')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str
    CALL cl_prt_cs3('abxi507','abxi507',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
#   FINISH REPORT i507_rep
 
   CLOSE i507_co
   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)           #FUN-850089
END FUNCTION
 
#FUN-850089  ----BEGIN---
#REPORT i507_rep(sr)
#DEFINE l_last_sw  LIKE type_file.chr1          #No.FUN-690010 VARCHAR(1),
#DEFINE sr RECORD 
#            bzl01       LIKE bzl_file.bzl01, 
#            bzl02       LIKE bzl_file.bzl02,
#            bzl03       LIKE bzl_file.bzl03,
#            bzl04       LIKE bzl_file.bzl04,
#            gen02a      LIKE gen_file.gen02,
#            bzl05       LIKE bzl_file.bzl05,
#            bzl06       LIKE bzl_file.bzl06,
#            bzm02       LIKE bzm_file.bzm02,    #項次
#            bzm03       LIKE bzm_file.bzm03,    #機器設備編號
#            bzm04       LIKE bzm_file.bzm04,    #序號
#            bza02       LIKE bza_file.bza02,    #機器設備中文名稱
#            bza03       LIKE bza_file.bza03,    #機器設備英文名稱
#            bza04       LIKE bza_file.bza04,    #機器設備規格
#            bzb03       LIKE bzb_file.bzb03,    #保管部門
#            gem02       LIKE gem_file.gem02,    #保管部門名稱
#            bzb04       LIKE bzb_file.bzb04,    #保管人
#            gen02b      LIKE gen_file.gen02,    #人員名稱
#            bzm05       LIKE bzm_file.bzm05,    #報廢數量
#            bzm06       LIKE bzm_file.bzm06     #備註
#         END RECORD
 
#       OUTPUT
#               TOP MARGIN g_top_margin
#               LEFT MARGIN g_left_margin
#               BOTTOM MARGIN g_bottom_margin
#               PAGE LENGTH g_page_line
 
#       ORDER BY sr.bzl01,sr.bzm02
 
#       FORMAT
#           PAGE HEADER
#              PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#              PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#              LET g_pageno=g_pageno+1
#              LET pageno_total=PAGENO USING '<<<',"/pageno"
#              PRINT g_head CLIPPED,pageno_total
#              PRINT g_dash2
#              PRINT g_x[11],sr.bzl01 CLIPPED,COLUMN (g_len/2),g_x[12],sr.bzl02 CLIPPED
#              PRINT g_x[14],sr.bzl04 CLIPPED,'  ',sr.gen02a CLIPPED,COLUMN (g_len/2),g_x[15],sr.bzl05 CLIPPED 
#              PRINT g_x[16],sr.bzl06 CLIPPED,COLUMN (g_len/2),g_x[13],sr.bzl03 CLIPPED
#              PRINT g_dash
#              PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                             g_x[36],g_x[37],g_x[38],g_x[39]
#              PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#                             g_x[45],g_x[46]
#              PRINT g_dash1
#              LET l_last_sw = 'y'
 
#           BEFORE GROUP OF sr.bzl01
#              SKIP TO TOP OF PAGE
 
#           ON EVERY ROW
#              PRINTX name=D1 COLUMN g_c[31],cl_numfor(sr.bzm02,31,0),
#                             COLUMN g_c[32],sr.bzm03,
#                             COLUMN g_c[33],cl_numfor(sr.bzm04,33,0),
#                             COLUMN g_c[34],sr.bza02,                
#                             COLUMN g_c[35],sr.bza04,                
#                             COLUMN g_c[36],sr.bzb03,                
#                             COLUMN g_c[37],sr.bzb04,                
#                             COLUMN g_c[38],cl_numfor(sr.bzm05,38,0),
#                             COLUMN g_c[39],sr.bzm06                 
 
#              PRINTX name=D2 COLUMN g_c[43],sr.bza03,
#                             COLUMN g_c[45],sr.gem02,
#                             COLUMN g_c[46],sr.gen02b
 
#           ON LAST ROW
#             IF g_zz05 = 'Y' THEN PRINT g_dash
#                CALL cl_prt_pos_wc(g_wc)
#             END IF
#             PRINT g_dash
#             LET l_last_sw = 'n'
#             PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
 
#       PAGE TRAILER
#           IF l_last_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#FUN-850089  ----END---
#No.FUN-890101  
