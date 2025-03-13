# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: abxi501.4gl
# Descriptions...: 保稅機器設備記帳卡建立作業
# Date & Author..: 2006/10/12 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.odyliao 自定欄位功能修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bzc           RECORD LIKE bzc_file.*,    
    g_bzc_t         RECORD LIKE bzc_file.*,     
    g_bzc_o         RECORD LIKE bzc_file.*,    
    g_bzc01_t       LIKE bzc_file.bzc01,
    g_bzd           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        bzd02       LIKE bzd_file.bzd02,          #項次
        bzd03       LIKE bzd_file.bzd03,          #機器設備編號
        bza02       LIKE bza_file.bza02,          #機器設備中文名稱
        bza03       LIKE bza_file.bza03,          #機器設備英文名稱
        bza04       LIKE bza_file.bza04,          #機器設備規格
        bza05       LIKE bza_file.bza05,          #型態
        bza06       LIKE bza_file.bza06,          #主件編號
        bza08       LIKE bza_file.bza08,          #單位      
        bza09       LIKE bza_file.bza09,          #數量  
        bza11       LIKE bza_file.bza11,          #管理局核准文號
        bza10       LIKE bza_file.bza10,          #稅捐記帳金額
        bza07       LIKE bza_file.bza07,          #報單號碼
        bza12       LIKE bza_file.bza12,          #放行日期
        bza13       LIKE bza_file.bza13,          #記帳到期日
        bza14       LIKE bza_file.bza14,          #稽核日期
        bzd04       LIKE bzd_file.bzd04           #備註i
        #FUN-840202 --start---
       ,bzdud01     LIKE bzd_file.bzdud01,
        bzdud02     LIKE bzd_file.bzdud02,
        bzdud03     LIKE bzd_file.bzdud03,
        bzdud04     LIKE bzd_file.bzdud04,
        bzdud05     LIKE bzd_file.bzdud05,
        bzdud06     LIKE bzd_file.bzdud06,
        bzdud07     LIKE bzd_file.bzdud07,
        bzdud08     LIKE bzd_file.bzdud08,
        bzdud09     LIKE bzd_file.bzdud09,
        bzdud10     LIKE bzd_file.bzdud10,
        bzdud11     LIKE bzd_file.bzdud11,
        bzdud12     LIKE bzd_file.bzdud12,
        bzdud13     LIKE bzd_file.bzdud13,
        bzdud14     LIKE bzd_file.bzdud14,
        bzdud15     LIKE bzd_file.bzdud15
        #FUN-840202 --end--
                    END RECORD,                   
    g_bzd_t         RECORD                        
        bzd02       LIKE bzd_file.bzd02,          #項次
        bzd03       LIKE bzd_file.bzd03,          #機器設備編號
        bza02       LIKE bza_file.bza02,          #機器設備中文名稱
        bza03       LIKE bza_file.bza03,          #機器設備英文名稱
        bza04       LIKE bza_file.bza04,          #機器設備規格
        bza05       LIKE bza_file.bza05,          #型態
        bza06       LIKE bza_file.bza06,          #主件編號
        bza08       LIKE bza_file.bza08,          #單位      
        bza09       LIKE bza_file.bza09,          #數量  
        bza11       LIKE bza_file.bza11,          #管理局核准文號
        bza10       LIKE bza_file.bza10,          #稅捐記帳金額
        bza07       LIKE bza_file.bza07,          #報單號碼
        bza12       LIKE bza_file.bza12,          #放行日期
        bza13       LIKE bza_file.bza13,          #記帳到期日
        bza14       LIKE bza_file.bza14,          #稽核日期
        bzd04       LIKE bzd_file.bzd04           #備註
        #FUN-840202 --start---
       ,bzdud01     LIKE bzd_file.bzdud01,
        bzdud02     LIKE bzd_file.bzdud02,
        bzdud03     LIKE bzd_file.bzdud03,
        bzdud04     LIKE bzd_file.bzdud04,
        bzdud05     LIKE bzd_file.bzdud05,
        bzdud06     LIKE bzd_file.bzdud06,
        bzdud07     LIKE bzd_file.bzdud07,
        bzdud08     LIKE bzd_file.bzdud08,
        bzdud09     LIKE bzd_file.bzdud09,
        bzdud10     LIKE bzd_file.bzdud10,
        bzdud11     LIKE bzd_file.bzdud11,
        bzdud12     LIKE bzd_file.bzdud12,
        bzdud13     LIKE bzd_file.bzdud13,
        bzdud14     LIKE bzd_file.bzdud14,
        bzdud15     LIKE bzd_file.bzdud15
        #FUN-840202 --end--
                    END RECORD,                   
    g_wc,g_wc2,g_sql    STRING,
    g_rec_b         LIKE type_file.num5,                     #
    l_ac            LIKE type_file.num5                      #
DEFINE p_row,p_col  LIKE type_file.num5
 
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_row_count    LIKE type_file.num10            #總筆數 
DEFINE   g_jump         LIKE type_file.num10            #查詢指定的筆數
DEFINE   mi_no_ask      LIKE type_file.num5             #是否開啟指定筆視窗
 
 
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
 
    #CALL cl_used('abxi501',g_time,1)       #計算使用時間 (進入時間)   #FUN-B30211
     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #FUN-B30211
         RETURNING g_time    #No.FUN-6A0062
 
    LET g_forupd_sql = "SELECT * FROM bzc_file   WHERE bzc01 = ? ", 
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i501_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 9
 
    OPEN WINDOW i501_w AT p_row,p_col      #顯示畫面
        WITH FORM "abx/42f/abxi501" ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    CALL i501_menu()
    CLOSE WINDOW i501_w                    #結束畫面
    #CALL cl_used('abxi501',g_time,2)       #計算使用時間 (退出使間)  #FUN-B30211
     CALL cl_used(g_prog,g_time,2)       #計算使用時間 (進入時間)  #FUN-B30211 
          RETURNING g_time    #No.FUN-6A0062
END MAIN
 
FUNCTION i501_cs()
 DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM                              #清除畫面
   CALL g_bzd.clear()
   CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
   INITIALIZE g_bzc.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON bzc01,bzc02,bzc03,bzc04,bzc05,
                             bzcuser,bzcgrup,bzcmodu,bzcdate,bzcacti
                             #FUN-840202   ---start---
                             ,bzcud01,bzcud02,bzcud03,bzcud04,bzcud05,
                             bzcud06,bzcud07,bzcud08,bzcud09,bzcud10,
                             bzcud11,bzcud12,bzcud13,bzcud14,bzcud15
                             #FUN-840202    ----end----
   
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP   
         CASE
            WHEN INFIELD(bzc03) #負責人   
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_gen" 
                 LET g_qryparam.default1 = g_bzc.bzc03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bzc03 
                 NEXT FIELD bzc03
                
            WHEN INFIELD(bzc04)  #承辦人
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_gen"  
                 LET g_qryparam.default1 = g_bzc.bzc04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bzc04 
                 NEXT FIELD bzc04
            OTHERWISE EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzcuser', 'bzcgrup') #FUN-980030
   
   IF INT_FLAG THEN
      RETURN
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bzcuser = '",g_user,"'"
   #   END IF
   
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bzcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   CONSTRUCT g_wc2 ON bzd02,bzd03,bzd04  #螢幕上取單身條件
           #No.FUN-840202 --start--
           ,bzdud01,bzdud02,bzdud03,bzdud04,bzdud05
           ,bzdud06,bzdud07,bzdud08,bzdud09,bzdud10
           ,bzdud11,bzdud12,bzdud13,bzdud14,bzdud15
           #No.FUN-840202 ---end---
           FROM s_bzd[1].bzd02,s_bzd[1].bzd03,s_bzd[1].bzd04
           #No.FUN-840202 --start--
           ,s_bzd[1].bzdud01,s_bzd[1].bzdud02,s_bzd[1].bzdud03,s_bzd[1].bzdud04,s_bzd[1].bzdud05
           ,s_bzd[1].bzdud06,s_bzd[1].bzdud07,s_bzd[1].bzdud08,s_bzd[1].bzdud09,s_bzd[1].bzdud10
           ,s_bzd[1].bzdud11,s_bzd[1].bzdud12,s_bzd[1].bzdud13,s_bzd[1].bzdud14,s_bzd[1].bzdud15
           #No.FUN-840202 ---end---
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   ON ACTION CONTROLP
              IF INFIELD(bzd03)  THEN #機器設備編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_bza2"  
                 LET g_qryparam.default1 = g_bzd[l_ac].bzd03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bzd03 
                 NEXT FIELD bzd03
              END IF
      ON ACTION qbe_save
          CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  bzc01 FROM bzc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY bzc01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE bzc_file. bzc01 ",
                  "  FROM bzc_file, bzd_file ",
                  " WHERE bzc01 = bzd01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY bzc01"
   END IF
 
   PREPARE i501_prepare FROM g_sql
   DECLARE i501_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i501_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM bzc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT bzc01) FROM bzc_file,bzd_file WHERE ",
                " bzd01=bzc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i501_precount FROM g_sql
   DECLARE i501_count CURSOR FOR i501_precount
 
END FUNCTION
 
FUNCTION i501_menu()
 
   WHILE TRUE
      CALL i501_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i501_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i501_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i501_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i501_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i501_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i501_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bzd),'','')
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF g_bzc.bzc01 IS NOT NULL THEN
                 LET g_doc.column1 = "bzc01"
                 LET g_doc.value1 = g_bzc.bzc01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i501_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bzd.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_bzc.* LIKE bzc_file.*             #DEFAULT 設定
   LET g_bzc01_t = ' ' 
 
   #預設值及將數值類變數清成零
   LET g_bzc_t.* = g_bzc.*
   LET g_bzc_o.* = g_bzc.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_bzc.bzcuser=g_user
      LET g_bzc.bzcgrup=g_grup
      LET g_bzc.bzcdate=g_today
      LET g_bzc.bzcacti='Y'              #資料有效
 
      CALL i501_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         CLEAR FORM
         INITIALIZE g_bzc.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_bzc.bzc01) THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      LET g_bzc.bzcoriu = g_user      #No.FUN-980030 10/01/04
      LET g_bzc.bzcorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bzc_file VALUES (g_bzc.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,1)  #No.FUN-B80082---調整至回滾事務前---
         ROLLBACK WORK      
         CONTINUE WHILE
      END IF
 
      SELECT bzc01 INTO g_bzc.bzc01 
         FROM bzc_file
         WHERE bzc01 = g_bzc.bzc01
      LET g_bzc01_t = g_bzc.bzc01        #保留舊值
      LET g_bzc_t.* = g_bzc.*
      LET g_bzc_o.* = g_bzc.*
      CALL g_bzd.clear()
 
      LET g_rec_b = 0  
      CALL i501_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i501_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bzc.bzc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bzc.* FROM bzc_file
    WHERE bzc01 = g_bzc.bzc01
 
   IF g_bzc.bzcacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_bzc.bzc01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bzc01_t = g_bzc.bzc01
   BEGIN WORK
 
   OPEN i501_cl USING g_bzc.bzc01
   IF STATUS THEN
      CALL cl_err("OPEN i501_cl:", STATUS, 1)
      CLOSE i501_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i501_cl INTO g_bzc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i501_show()
 
   WHILE TRUE
      LET g_bzc01_t = g_bzc.bzc01
      LET g_bzc_o.* = g_bzc.*
      LET g_bzc.bzcmodu=g_user
      LET g_bzc.bzcdate=g_today
 
      CALL i501_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bzc.*=g_bzc_t.*
         CALL i501_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_bzc.bzc01 != g_bzc01_t THEN            # 更改單號
         UPDATE bzd_file SET bzd01 = g_bzc.bzc01
          WHERE bzd01 = g_bzc01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('bzd',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE bzc_file SET bzc_file.* = g_bzc.*
      WHERE bzc01 = g_bzc01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i501_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i501_i(p_cmd)
DEFINE
   l_gen021  LIKE gen_file.gen02,
   l_gen022  LIKE gen_file.gen02,
   l_n            LIKE type_file.num5,
   p_cmd          LIKE type_file.chr1                #a:輸入 u:更改
   CALL cl_set_head_visible("","YES")                #No.FUN-6B0033
   INPUT BY NAME g_bzc.bzc01,g_bzc.bzc02,g_bzc.bzc03,g_bzc.bzc04,
                 g_bzc.bzc05,
                 g_bzc.bzcuser,g_bzc.bzcmodu,g_bzc.bzcgrup,
                 g_bzc.bzcdate,g_bzc.bzcacti
                 #FUN-840202     ---start---
                ,g_bzc.bzcud01,g_bzc.bzcud02,g_bzc.bzcud03,g_bzc.bzcud04,
                 g_bzc.bzcud05,g_bzc.bzcud06,g_bzc.bzcud07,g_bzc.bzcud08,
                 g_bzc.bzcud09,g_bzc.bzcud10,g_bzc.bzcud11,g_bzc.bzcud12,
                 g_bzc.bzcud13,g_bzc.bzcud14,g_bzc.bzcud15 
                 #FUN-840202     ----end----
            WITHOUT DEFAULTS
 
      BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i501_set_entry(p_cmd)
        CALL i501_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
      AFTER FIELD bzc01
         IF NOT cl_null(g_bzc.bzc01) THEN
            IF p_cmd = "a" OR                 
               (p_cmd = "u" AND g_bzc.bzc01 != g_bzc01_t) THEN 
               SELECT count(*) INTO l_n 
                  FROM bzc_file
                  WHERE bzc01 = g_bzc.bzc01
               IF l_n > 0 THEN
                  CALL cl_err(g_bzc.bzc01,-239,1)
                  LET g_bzc.bzc01 = g_bzc_t.bzc01
                  DISPLAY BY NAME g_bzc.bzc01
                  NEXT FIELD bzc01
               END IF
            END IF
         END IF
 
      AFTER FIELD bzc03
         IF NOT cl_null(g_bzc.bzc03) THEN
            CALL i501_bzc03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('bzc03:',g_errno,0)
               LET g_bzc.bzc03 = '' 
               DISPLAY BY NAME g_bzc.bzc03
               NEXT FIELD bzc03
            END IF   
         END IF
      AFTER FIELD bzc04
         IF NOT cl_null(g_bzc.bzc04) THEN
            CALL i501_bzc04(p_cmd)         
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('bzc04:',g_errno,0)
               LET g_bzc.bzc04 = ''
               DISPLAY BY NAME g_bzc.bzc04
               NEXT FIELD bzc04
            END IF   
         END IF
 
        #FUN-840202     ---start---
        AFTER FIELD bzcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bzc03) #負責人   
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_bzc.bzc03
                 CALL cl_create_qry() RETURNING g_bzc.bzc03
                 DISPLAY BY NAME g_bzc.bzc03
                 CALL i501_bzc03('d')          
                 NEXT FIELD bzc03
                
            WHEN INFIELD(bzc04) #承辦人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_bzc.bzc04
                 CALL cl_create_qry() RETURNING g_bzc.bzc04
                 DISPLAY BY NAME g_bzc.bzc04 
                 CALL i501_bzc04('d')   
                 NEXT FIELD bzc04
            OTHERWISE EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
END FUNCTION
   
FUNCTION i501_bzc03(p_cmd)    #負責人
   DEFINE p_cmd     LIKE type_file.chr1,
          l_gen021  LIKE gen_file.gen02,
          l_genacti LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen021,l_genacti 
      FROM gen_file 
      WHERE gen01 = g_bzc.bzc03 
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'aoo-070'
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
   
FUNCTION i501_bzc04(p_cmd)      #承辦人
    DEFINE p_cmd      LIKE type_file.chr1,
           l_gen022   LIKE gen_file.gen02,
           l_genacti  LIKE gen_file.genacti 
 
   LET g_errno = " "
   SELECT gen02,genacti INTO l_gen022,l_genacti
     FROM gen_file 
     WHERE gen01 = g_bzc.bzc04 
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'aoo-070'
           LET l_gen022 = NULL
        WHEN l_genacti='N' 
           LET g_errno = '9028'
        OTHERWISE          
           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen022 TO FORMONLY.gen02_2
   END IF
 
END FUNCTION
   
FUNCTION i501_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   INITIALIZE g_bzc.* TO NULL
   CLEAR FORM
   CALL g_bzd.clear()
   DISPLAY ' ' TO FORMONLY.cnt  
 
   CALL i501_cs()
 
   IF INT_FLAG THEN
      CLEAR FORM
      CALL g_bzd.clear()
      LET INT_FLAG = 0
      INITIALIZE g_bzc.* TO NULL
      RETURN
   END IF
 
   OPEN i501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bzc.* TO NULL
   ELSE
      OPEN i501_count
      FETCH i501_count INTO g_row_count      
      DISPLAY g_row_count TO FORMONLY.cnt  
 
      CALL i501_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i501_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i501_cs INTO g_bzc.bzc01
      WHEN 'P' FETCH PREVIOUS i501_cs INTO g_bzc.bzc01
      WHEN 'F' FETCH FIRST    i501_cs INTO g_bzc.bzc01
      WHEN 'L' FETCH LAST     i501_cs INTO g_bzc.bzc01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i501_cs INTO g_bzc.bzc01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,0)
      INITIALIZE g_bzc.* TO NULL
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
 
   SELECT * INTO g_bzc.* FROM bzc_file WHERE bzc01 = g_bzc.bzc01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,0)
      INITIALIZE g_bzc.* TO NULL
      RETURN
   END IF
 
   CALL i501_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i501_show()
   LET g_bzc_t.* = g_bzc.*                #保存單頭舊值
   LET g_bzc_o.* = g_bzc.*                #保存單頭舊值
   DISPLAY BY NAME g_bzc.bzc01,g_bzc.bzc02,g_bzc.bzc03,g_bzc.bzc04,
                   g_bzc.bzc05,
                   g_bzc.bzcuser,g_bzc.bzcgrup,g_bzc.bzcmodu,
                   g_bzc.bzcdate,g_bzc.bzcacti
                   #FUN-840202     ---start---
                  ,g_bzc.bzcud01,g_bzc.bzcud02,g_bzc.bzcud03,g_bzc.bzcud04,
                   g_bzc.bzcud05,g_bzc.bzcud06,g_bzc.bzcud07,g_bzc.bzcud08,
                   g_bzc.bzcud09,g_bzc.bzcud10,g_bzc.bzcud11,g_bzc.bzcud12,
                   g_bzc.bzcud13,g_bzc.bzcud14,g_bzc.bzcud15 
                   #FUN-840202     ----end----
       
   CALL i501_bzc03('d')
   CALL i501_bzc04('d')
 
   CALL i501_b_fill(g_wc2)                
  
 
END FUNCTION
 
FUNCTION i501_r()
   DEFINE   l_d    LIKE type_file.num5              #檢查是否可刪除用
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bzc.bzc01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bzc.* FROM bzc_file
    WHERE bzc01=g_bzc.bzc01
   IF g_bzc.bzcacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_bzc.bzc01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i501_cl USING g_bzc.bzc01
   IF STATUS THEN
      CALL cl_err("OPEN i501_cl:", STATUS, 1)
      CLOSE i501_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i501_cl INTO g_bzc.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i501_show()
 
   WHILE TRUE 
      IF cl_delh(0,0) THEN                   #確認一下
          INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "bzc01"         #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_bzc.bzc01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM bzc_file WHERE bzc01 = g_bzc.bzc01
         DELETE FROM bzd_file WHERE bzd01 = g_bzc.bzc01
         CLEAR FORM
         CALL g_bzd.clear()
         OPEN i501_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i501_cs
            CLOSE i501_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i501_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i501_cs
            CLOSE i501_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i501_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i501_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i501_fetch('/')
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i501_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i501_b()
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
 
    IF cl_null(g_bzc.bzc01) THEN
       RETURN
    END IF
 
    SELECT * INTO g_bzc.* 
       FROM bzc_file
       WHERE bzc01=g_bzc.bzc01
 
    IF g_bzc.bzcacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_bzc.bzc01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bzd02,bzd03,' ',' ',' ',' ',' ',",
                       " ' ',' ',' ',' ',' ',' ',' ',' ',bzd04 ", 
                       ",bzdud01,bzdud02,bzdud03,bzdud04,bzdud05,",
                       "bzdud06,bzdud07,bzdud08,bzdud09,bzdud10,",
                       "bzdud11,bzdud12,bzdud13,bzdud14,bzdud15",
                       " FROM bzd_file ",
                       "  WHERE bzd01=? AND bzd02=?  ",
                       " FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i501_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bzd WITHOUT DEFAULTS FROM s_bzd.*
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
 
           OPEN i501_cl USING g_bzc.bzc01
           IF STATUS THEN
              CALL cl_err("OPEN i501_cl:", STATUS, 1)
              CLOSE i501_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i501_cl INTO g_bzc.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_bzc.bzc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i501_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_bzd_t.* = g_bzd[l_ac].*  #BACKUP
              OPEN i501_bcl USING g_bzc.bzc01, g_bzd_t.bzd02
              IF STATUS THEN
                 CALL cl_err("OPEN i501_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i501_bcl INTO g_bzd[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bzd_t.bzd02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i501_bzd03(p_cmd) 
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_bzd[l_ac].* TO NULL              
           LET g_bzd_t.* = g_bzd[l_ac].*         #新輸入資料
           NEXT FIELD bzd02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF 
           INSERT INTO bzd_file(bzd01,bzd02,bzd03,bzd04,
                                  #FUN-840202 --start--
                                  bzdud01,bzdud02,bzdud03,
                                  bzdud04,bzdud05,bzdud06,
                                  bzdud07,bzdud08,bzdud09,
                                  bzdud10,bzdud11,bzdud12,
                                  bzdud13,bzdud14,bzdud15)
                                  #FUN-840202 --end--
           VALUES(g_bzc.bzc01,g_bzd[l_ac].bzd02,
                  g_bzd[l_ac].bzd03,g_bzd[l_ac].bzd04,
                                  #FUN-840202 --start--
                  g_bzd[l_ac].bzdud01, g_bzd[l_ac].bzdud02,
                  g_bzd[l_ac].bzdud03, g_bzd[l_ac].bzdud04,
                  g_bzd[l_ac].bzdud05, g_bzd[l_ac].bzdud06,
                  g_bzd[l_ac].bzdud07, g_bzd[l_ac].bzdud08,
                  g_bzd[l_ac].bzdud09, g_bzd[l_ac].bzdud10,
                  g_bzd[l_ac].bzdud11, g_bzd[l_ac].bzdud12,
                  g_bzd[l_ac].bzdud13, g_bzd[l_ac].bzdud14,
                  g_bzd[l_ac].bzdud15)
                  #FUN-840202 --end--
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_bzd[l_ac].bzd02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD bzd02                     
           IF cl_null(g_bzd[l_ac].bzd02) OR g_bzd[l_ac].bzd02 = 0 THEN
              SELECT max(bzd02)+1
                INTO g_bzd[l_ac].bzd02
                FROM bzd_file
                WHERE bzd01 = g_bzc.bzc01
              IF cl_null(g_bzd[l_ac].bzd02) THEN
                 LET g_bzd[l_ac].bzd02 = 1
              END IF
           END IF
        AFTER FIELD bzd02
           IF NOT cl_null(g_bzd[l_ac].bzd02) THEN
              IF g_bzd[l_ac].bzd02 != g_bzd_t.bzd02     
                 OR cl_null(g_bzd_t.bzd02) THEN 
                    SELECT count(*) INTO l_n
                       FROM bzd_file
                       WHERE bzd01 = g_bzc.bzc01 AND 
                             bzd02 = g_bzd[l_ac].bzd02 
                    IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bzd[l_ac].bzd02 = g_bzd_t.bzd02
                    DISPLAY BY NAME g_bzd[l_ac].bzd02   
                    END IF    
              END IF
           END IF
 
        AFTER FIELD bzd03
           IF NOT cl_null(g_bzd[l_ac].bzd03) THEN
              IF (g_bzd[l_ac].bzd03 != g_bzd_t.bzd03) OR 
                 cl_null(g_bzd_t.bzd03) THEN
                 SELECT count(*) INTO l_n
                    FROM bzd_file
                    WHERE bzd03 = g_bzd[l_ac].bzd03 
                 IF l_n > 0 THEN 
                    CALL cl_err('','abx-018',0)
                    LET g_bzd[l_ac].bzd03 = g_bzd_t.bzd03
                    DISPLAY BY NAME g_bzd[l_ac].bzd03
                    NEXT FIELD bzd03  
                 ELSE
                    CALL i501_bzd03(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_bzd[l_ac].bzd03,g_errno,0)
                       LET g_bzd[l_ac].bzd03 = g_bzd_t.bzd03
                       DISPLAY BY NAME g_bzd[l_ac].bzd03
                       NEXT FIELD bzd03
                    END IF   
                 END IF
              END IF
           END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD bzdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE" 
           IF g_bzd_t.bzd02 > 0 AND NOT cl_null(g_bzd_t.bzd02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF
              DELETE FROM bzd_file
               WHERE bzd01 = g_bzc.bzc01
                 AND bzd02 = g_bzd_t.bzd02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_bzd_t.bzd02,SQLCA.sqlcode,0)
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
              LET g_bzd[l_ac].* = g_bzd_t.*
              CLOSE i501_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bzd[l_ac].bzd02,-263,1)
              LET g_bzd[l_ac].* = g_bzd_t.*
           ELSE
              UPDATE bzd_file SET bzd02=g_bzd[l_ac].bzd02,
                                  bzd03=g_bzd[l_ac].bzd03,
                                  bzd04=g_bzd[l_ac].bzd04
                                  #FUN-840202 --start--
                                 ,bzdud01 = g_bzd[l_ac].bzdud01,
                                  bzdud02 = g_bzd[l_ac].bzdud02,
                                  bzdud03 = g_bzd[l_ac].bzdud03,
                                  bzdud04 = g_bzd[l_ac].bzdud04,
                                  bzdud05 = g_bzd[l_ac].bzdud05,
                                  bzdud06 = g_bzd[l_ac].bzdud06,
                                  bzdud07 = g_bzd[l_ac].bzdud07,
                                  bzdud08 = g_bzd[l_ac].bzdud08,
                                  bzdud09 = g_bzd[l_ac].bzdud09,
                                  bzdud10 = g_bzd[l_ac].bzdud10,
                                  bzdud11 = g_bzd[l_ac].bzdud11,
                                  bzdud12 = g_bzd[l_ac].bzdud12,
                                  bzdud13 = g_bzd[l_ac].bzdud13,
                                  bzdud14 = g_bzd[l_ac].bzdud14,
                                  bzdud15 = g_bzd[l_ac].bzdud15
                                  #FUN-840202 --end-- 
               WHERE bzd01=g_bzc.bzc01
                 AND bzd02=g_bzd_t.bzd02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_bzd[l_ac].bzd02,SQLCA.sqlcode,0)
                 LET g_bzd[l_ac].* = g_bzd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_bzd[l_ac].* = g_bzd_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_bzd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF 
              CLOSE i501_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE i501_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bzd02) AND l_ac > 1 THEN
              LET g_bzd[l_ac].* = g_bzd[l_ac-1].*
              LET g_bzd[l_ac].bzd02 = g_rec_b + 1 
              DISPLAY BY NAME g_bzd[l_ac].bzd02
              NEXT FIELD bzd03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           IF INFIELD(bzd03) THEN #保管部門代號
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_bza2"
              LET g_qryparam.default1 = g_bzd[l_ac].bzd03
              CALL cl_create_qry() RETURNING g_bzd[l_ac].bzd03
              DISPLAY BY NAME g_bzd[l_ac].bzd03
              CALL i501_bzd03(p_cmd)          
              NEXT FIELD bzd03
           END IF
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
       ON ACTION controls                       #No.FUN-6B0033
          CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
 
    CLOSE i501_bcl
    COMMIT WORK
#   CALL i501_delall()   #CHI-C30002 mark
    CALL i501_delHeader()     #CHI-C30002 add
 
END FUNCTION
  
#CHI-C30002 -------- add -------- begin
FUNCTION i501_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bzc_file WHERE bzc01 = g_bzc.bzc01
         INITIALIZE g_bzc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i501_bzd03(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,
          l_bza     RECORD LIKE bza_file.*
 
   LET g_errno = ' '
   SELECT * INTO l_bza.*
      FROM bza_file
      WHERE bza01 = g_bzd[l_ac].bzd03 
        AND bza05 = '1'
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'abx-019'
           INITIALIZE  l_bza.* TO NULL
        WHEN l_bza.bzaacti='N'
           LET g_errno = '9028'
        OTHERWISE          
           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_bzd[l_ac].bza02 = l_bza.bza02
      LET g_bzd[l_ac].bza03 = l_bza.bza03
      LET g_bzd[l_ac].bza04 = l_bza.bza04
      LET g_bzd[l_ac].bza05 = l_bza.bza05
      LET g_bzd[l_ac].bza06 = l_bza.bza06
      LET g_bzd[l_ac].bza08 = l_bza.bza08
      LET g_bzd[l_ac].bza09 = l_bza.bza09
      LET g_bzd[l_ac].bza11 = l_bza.bza11
      LET g_bzd[l_ac].bza10 = l_bza.bza10
      LET g_bzd[l_ac].bza07 = l_bza.bza07
      LET g_bzd[l_ac].bza12 = l_bza.bza12
      LET g_bzd[l_ac].bza13 = l_bza.bza13
      LET g_bzd[l_ac].bza14 = l_bza.bza14
      DISPLAY BY NAME g_bzd[l_ac].bza02,g_bzd[l_ac].bza03,
                      g_bzd[l_ac].bza04,g_bzd[l_ac].bza05,
                      g_bzd[l_ac].bza06,g_bzd[l_ac].bza08,
                      g_bzd[l_ac].bza09,g_bzd[l_ac].bza11,
                      g_bzd[l_ac].bza10,g_bzd[l_ac].bza07,
                      g_bzd[l_ac].bza12,g_bzd[l_ac].bza13,
                      g_bzd[l_ac].bza14
   END IF
 
END FUNCTION
#CHI-C30002 -------- mark -------- begin 
#FUNCTION i501_delall()
#   DEFINE  l_d     LIKE type_file.num5
#
#   SELECT COUNT(*) INTO g_cnt FROM bzd_file
#      WHERE bzd01 = g_bzc.bzc01 
#
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      IF cl_confirm('9042') THEN
#         DELETE FROM bzc_file WHERE bzc01 = g_bzc.bzc01
#      END IF
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i501_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          STRING
 
    
    LET g_sql = "SELECT bzd02,bzd03,bza02,bza03,bza04,bza05,",
                "  bza06,bza08,bza09,bza11,bza10,bza07,bza12,",
                "  bza13,bza14,bzd04 ", 
                #No.FUN-840202 --start--
                ",bzdud01,bzdud02,bzdud03,bzdud04,bzdud05,",
                "bzdud06,bzdud07,bzdud08,bzdud09,bzdud10,",
                "bzdud11,bzdud12,bzdud13,bzdud14,bzdud15", 
                #No.FUN-840202 ---end---
                "  FROM bzd_file,OUTER bza_file ",
                " WHERE bzd01 ='",g_bzc.bzc01,"' AND ",   #單頭
                "  bza_file.bza01 = bzd_file.bzd03 ",
                "   AND bza_file.bza05 = '1' "
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY bzd02 "
    DISPLAY g_sql
 
    PREPARE i501_pb FROM g_sql
    DECLARE bzd_cs                       #CURSOR
        CURSOR FOR i501_pb
 
    CALL g_bzd.clear()
    LET g_cnt = 1
 
    FOREACH bzd_cs INTO g_bzd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_bzd.deleteElement(g_cnt)
  
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bzd TO s_bzd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION previous
         CALL i501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
      ON ACTION jump
         CALL i501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1)  
      ON ACTION next
         CALL i501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
      ON ACTION last
         CALL i501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1) 
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
 
FUNCTION i501_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bzc01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i501_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bzc01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i501_out()
   DEFINE p_cmd  LIKE type_file.chr8,
          l_cmd  STRING,
          l_prt_con LIKE zz_file.zz21,
          l_prt_way LIKE zz_file.zz22,
          l_wc   STRING,
          l_lang LIKE type_file.chr1
 
   IF cl_null(g_bzc.bzc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
      LET l_wc= "'",g_bzc.bzc01,"'"
      LET p_cmd = 'abxr500'
      SELECT zz21,zz22 INTO l_prt_con,l_prt_way 
         FROM zz_file       
         WHERE zz01 = p_cmd      
      IF SQLCA.sqlcode OR cl_null(l_prt_con) OR l_wc = ' ' THEN 
         LET l_prt_con = " 'Y' " 
      LET l_cmd = p_cmd CLIPPED, 
                 " '",g_today CLIPPED,"' ''", 
                 " '",g_lang CLIPPED,"' 'Y' '",l_prt_way,"' ' '",
                  " '",l_wc CLIPPED,"' ",l_prt_con     
      CALL cl_cmdrun_wait(l_cmd)
      END IF
END FUNCTION
 
 
 
