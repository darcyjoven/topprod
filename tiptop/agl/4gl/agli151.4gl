# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Pattern name...: agli151.4gl (coyp from aooi120)
# Descriptions...: 分類對應會計科目維護
# Note...........: 本程式由agli015呼叫,不提供獨立執行
# Date & Author..: 07/08/07 By kim (FUN-780013)
# Modify.........: No:MOD-840600 08/04/23 By Smapmin 進入單身時,資料抓取錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-920120 09/11/06   1.單頭欄位異動 
#                                                  2.單身科目ayb02開窗，以單頭營運中心DB+帳別ayb07開窗資料，AFTER FIELD檢查時亦同  
#                                                  3.aag02要跨db抓取顯示                                                                                 
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A30122 10/08/20 By vealxu 取合併帳別資料庫改由s_aaz641_plant，s_get_aaz641取合併帳別
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101参数档改为aaw_file
# Modify.........: No.CHI-B40058 11/05/17 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.MOD-B60184 11/06/22 By Polly 會計科目開窗抓q_aag
# Modify.........: No.TQC-C40276 12/04/28 By lujh  查詢一筆資料，點擊“單身”按鈕，系統報錯“-6319 OPEN i151_b_curl: Message number -6319 not found.”
# Modify.........: No.TQC-C40277 12/04/28 By lujh 點擊“查詢”顯示有四筆資料，刪除第一筆，清空界面中當前第一筆資料後，並未跟著顯示第二筆資料，下方總筆數資料顯示有誤。
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
   g_ayb01        LIKE ayb_file.ayb01,       #代號 (假單頭)
   g_ayb01_t      LIKE ayb_file.ayb01,       #代號 (舊值)
   g_ayb05        LIKE ayb_file.ayb05,       #FUN-920120 add
   g_ayb05_t      LIKE ayb_file.ayb05,       #FUN-920120 add
   g_ayb06        LIKE ayb_file.ayb06,       #FUN-920120 add
   g_ayb06_t      LIKE ayb_file.ayb06,       #FUN-920120 add
   g_ayb07        LIKE ayb_file.ayb07,       #FUN-920120 add
   g_ayb07_t      LIKE ayb_file.ayb07,       #FUN-920120 add
   g_axz05        LIKE axz_file.axz05,       #FUN-920120 add
   g_ayb          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      ayb02          LIKE ayb_file.ayb02,
      aag02          LIKE aag_file.aag02
                  END RECORD,
   g_ayb_t        RECORD                     #程式變數 (舊值)
      ayb02          LIKE ayb_file.ayb02,
      aag02          LIKE aag_file.aag02
                  END RECORD,
   g_name         LIKE type_file.chr20,
   g_wc,g_sql     STRING,
   g_ss           LIKE type_file.chr1,       #決定後續步驟
   l_ac           LIKE type_file.num5,       #目前處理的ARRAY CNT
   g_argv1        LIKE ayb_file.ayb01,
   g_rec_b        LIKE type_file.num5,       #單身筆數
   g_cn2          LIKE type_file.num5
DEFINE g_forupd_sql        STRING            #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE ayb_file.ayb01
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_sql_tmp           STRING                    #FUN-920120 add
DEFINE g_dbs_axz03         LIKE type_file.chr21      #FUN-920120 add
DEFINE g_plant_axz03       LIKE type_file.chr21      #FUN-A30122 add
DEFINE   g_jump         LIKE type_file.num10        #查詢指定的筆數     #TQC-C40277  add
DEFINE   g_no_ask       LIKE type_file.num5         #是否開啟指定筆視窗  #TQC-C40277  add

MAIN
   DEFINE p_row,p_col      LIKE type_file.num5
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1)            #計算使用時間 (進入時間)
      RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_ayb01   = NULL                        #清除鍵值
   LET g_ayb01_t = NULL
   LET g_ayb05   = NULL                      #FUN-920120 add
   LET g_ayb05_t = NULL                      #FUN-920120 add
   LET g_ayb06   = NULL                      #FUN-920120 add
   LET g_ayb06_t = NULL                      #FUN-920120 add
   LET g_ayb07   = NULL                      #FUN-920120 add
   LET g_ayb07_t = NULL                      #FUN-920120 add

   LET p_row = 4 LET p_col = 20

   OPEN WINDOW i151_w AT p_row,p_col WITH FORM "agl/42f/agli151"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN CALL i151_q() END IF

   CALL i151_menu()

   CLOSE WINDOW i151_w                       #結束畫面
   CALL cl_used(g_prog,g_time,2)             #計算使用時間 (退出時間)
      RETURNING g_time

END MAIN

FUNCTION i151_curs()                         # QBE 查詢資料
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             # 清除畫面
      CALL g_ayb.clear()
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_ayb01 TO NULL
      INITIALIZE g_ayb05 TO NULL       #FUN-920120 add
      INITIALIZE g_ayb06 TO NULL       #FUN-920120 add
      INITIALIZE g_ayb07 TO NULL       #FUN-920120 add

     #CONSTRUCT g_wc ON ayb01,ayb02                 #FUN-920120 mark  #螢幕上取條件
     #   FROM ayb01,s_ayb[1].ayb02                  #FUN-920120 mark  
      CONSTRUCT g_wc ON ayb05,ayb06,ayb01,ayb02     #FUN-920120 mod   #螢幕上取條件
         FROM ayb05,ayb06,ayb01,s_ayb[1].ayb02      #FUN-920120 mod  

       #FUN-920120---add---str---
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ayb01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aya"
                 LET g_qryparam.default1 = g_ayb01
                 CALL cl_create_qry() RETURNING g_ayb01
                 DISPLAY g_ayb01 TO ayb01
                 NEXT FIELD ayb01
              WHEN INFIELD(ayb05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ayb05
                 NEXT FIELD ayb05
#----------------No.MOD-B60184----------------------------add
              WHEN INFIELD(ayb02)  #會計科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ayb02
                 NEXT FIELD ayb02
#----------------No.MOD-B60184-----------------------------end
              WHEN INFIELD(ayb06)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz"      
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ayb06  
                 NEXT FIELD ayb06
                OTHERWISE EXIT CASE
           END CASE
       #FUN-920120---add---end---

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

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
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc=" ayb01='",g_argv1,"'"
      LET g_ayb01=g_argv1
   END IF

  #LET g_sql= "SELECT UNIQUE ayb01 FROM ayb_file ",                    #FUN-920120 mark
   LET g_sql= "SELECT UNIQUE ayb01,ayb05,ayb06,ayb07 FROM ayb_file ",  #FUN-920120 mod
              " WHERE ", g_wc CLIPPED
   PREPARE i151_prepare FROM g_sql      #預備一下
   DECLARE i151_b_curs                  #宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR i151_prepare

  #FUN-920120---mod---str---
  #LET g_sql = "SELECT COUNT(DISTINCT ayb01) FROM ayb_file ",  
  #            " WHERE ",g_wc CLIPPED
  #PREPARE i151_precount FROM g_sql
  #DECLARE i151_count CURSOR FOR i151_precount

   #TQC-C40277--mark--str--
   #LET g_sql_tmp = "SELECT UNIQUE ayb01,ayb05,ayb06,ayb07 ", 
   #                "  FROM ayb_file WHERE ", g_wc CLIPPED,
   #                "  INTO TEMP x "
   #DROP TABLE x
   #PREPARE i151_pre_x FROM g_sql_tmp 
   #EXECUTE i151_pre_x
   #LET g_sql = "SELECT COUNT(*) FROM x"
   #PREPARE i151_precount FROM g_sql
   #DECLARE i151_count CURSOR FOR i151_precount
   #TQC-C40277--mark--end--

   #TQC-C40277--add--str--
   LET g_sql=" SELECT DISTINCT ayb01,ayb05,ayb06,ayb07 ",
             " FROM ayb_file WHERE ",g_wc CLIPPED,
             " ORDER BY ayb01 "
   PREPARE i151_precount FROM g_sql
   DECLARE i151_count CURSOR FOR i151_precount
   #TQC-C40277--add--end--
END FUNCTION

FUNCTION i151_menu()
   DEFINE l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL i151_bp("G")
      CASE g_action_choice
        #FUN-920120---add---str---
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i151_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i151_q()
            END IF
        #FUN-920120---add---end---
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i151_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i151_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_ayb01 IS NOT NULL THEN
                  LET g_doc.column1 = "ayb01"
                  LET g_doc.value1 = g_ayb01
                 #FUN-920120---add---str---
                  LET g_doc.column2 = "ayb05"
                  LET g_doc.value2 = g_ayb05
                  LET g_doc.column3 = "ayb06"
                  LET g_doc.value3 = g_ayb06
                  LET g_doc.column4 = "ayb07"
                  LET g_doc.value4 = g_ayb07
                 #FUN-920120---add---end---
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ayb),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

#FUN-920120---add---str---
FUNCTION i151_a()

   IF s_aglshut(0) THEN
      RETURN
   END IF  

   MESSAGE ""
   CLEAR FORM
   CALL g_ayb.clear()
   INITIALIZE g_ayb05 LIKE ayb_file.ayb05      #DEFAULT 設定  
   INITIALIZE g_ayb06 LIKE ayb_file.ayb06      #DEFAULT 設定  
   INITIALIZE g_ayb07 LIKE ayb_file.ayb07      #DEFAULT 設定  
   INITIALIZE g_ayb01 LIKE ayb_file.ayb01      #DEFAULT 設定  

   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i151_i("a")                         #輸入單頭

      IF INT_FLAG THEN                         #使用者不玩了
         LET g_ayb05 = NULL                 
         LET g_ayb06 = NULL                 
         LET g_ayb07 = NULL                 
         LET g_ayb01 = NULL                 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_ayb.clear()
      ELSE
         CALL i151_b_fill('1=1')         #單身
      END IF

      CALL i151_b()                      #輸入單身

      LET g_ayb05_t = g_ayb05            #保留舊值                 
      LET g_ayb06_t = g_ayb06            #保留舊值
      LET g_ayb07_t = g_ayb07            #保留舊值                
      LET g_ayb01_t = g_ayb01            #保留舊值                
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i151_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680098 char(1)
   l_n1,l_n        LIKE type_file.num5,          #No.FUN-680098  smallint
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680098 char(1)

   LET g_ss = 'Y'

   DISPLAY g_ayb05 TO ayb05                  
   DISPLAY g_ayb06 TO ayb06                  
   DISPLAY g_ayb07 TO ayb07                  
   DISPLAY g_ayb01 TO ayb01                  
   CALL cl_set_head_visible("","YES")        
   INPUT g_ayb05,g_ayb06,g_ayb07,g_ayb01 WITHOUT DEFAULTS FROM ayb05,ayb06,ayb07,ayb01

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i151_set_entry(p_cmd) 
         CALL i151_set_no_entry(p_cmd) 
         LET g_before_input_done = TRUE

      AFTER FIELD ayb05   #族群代號
         IF cl_null(g_ayb05) THEN
            CALL cl_err(g_ayb05,'mfg0037',0)
            NEXT FIELD ayb05
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_ayb05
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_ayb05,'agl-223',0)
               NEXT FIELD ayb05
            END IF
         END IF

      AFTER FIELD ayb06 
         IF NOT cl_null(g_ayb06) THEN 
               CALL i151_ayb06('a',g_ayb06)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ayb06,g_errno,0)
                  NEXT FIELD ayb06
               END IF
            IF g_ayb05 IS NOT NULL AND g_ayb06 IS NOT NULL AND
               g_ayb07 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_ayb05 AND axa02=g_ayb06
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_ayb05 AND axb04=g_ayb06
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_ayb06,'agl-223',0)
                  LET g_ayb05 = g_ayb05_t
                  LET g_ayb06 = g_ayb06_t
                  LET g_ayb07 = g_ayb07_t
                  DISPLAY BY NAME g_ayb05,g_ayb06,g_ayb07
                  NEXT FIELD ayb06
               END IF
            END IF
         END IF

      AFTER FIELD ayb01 
         IF NOT cl_null(g_ayb01) THEN 
            CALL i151_ayb01('a',g_ayb01)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ayb01,g_errno,0)
               NEXT FIELD ayb01
            END IF
         END IF

    # AFTER FIELD ayb07
    #    IF cl_null(g_ayb06) THEN NEXT FIELD ayb06 END IF
    #    IF NOT cl_null(g_ayb07) THEN
    #       CALL i001_ayb07('a',g_ayb07)
    #       IF NOT cl_null(g_errno) THEN
    #          CALL cl_err(g_ayb07,g_errno,0)
    #          NEXT FIELD ayb07
    #       END IF
    #       #增加公司+帳別的合理性判斷,應存在agli009
    #       LET l_n = 0
    #       SELECT COUNT(*) INTO l_n FROM axz_file
    #        WHERE axz01=g_ayb06 AND axz05=g_ayb07
    #       IF l_n = 0 THEN
    #          CALL cl_err(g_ayb07,'agl-946',0)
    #          NEXT FIELD ayb07
    #       END IF
    #       IF g_ayb05 != g_ayb05_t OR cl_null(g_ayb05_t) OR 
    #          g_ayb06 != g_ayb06_t OR cl_null(g_ayb06_t) OR 
    #          g_ayb07 != g_ayb07_t OR cl_null(g_ayb07_t) THEN
    #          LET g_cnt = 0 
    #          SELECT COUNT(*) INTO g_cnt FROM axe_file
    #           WHERE ayb06=g_ayb06
    #             AND ayb07=g_ayb07
    #             AND ayb05=g_ayb05   
    #          IF g_cnt = 0  THEN            
    #             IF p_cmd = 'a' THEN 
    #                LET g_ss = 'N' 
    #             END IF
    #          ELSE
    #             IF p_cmd='u' THEN
    #                CALL cl_err(g_ayb06,-239,0)
    #                LET g_ayb05=g_ayb05_t   
    #                LET g_ayb06=g_ayb06_t
    #                LET g_ayb07=g_ayb07_t
    #                NEXT FIELD ayb06
    #             END IF
    #          END IF
    #          LET l_n = 0   LET l_n1 = 0
    #          SELECT COUNT(*) INTO l_n FROM axa_file
    #           WHERE axa01=g_ayb05 AND axa02=g_ayb06
    #             AND axa03=g_ayb07
    #          SELECT COUNT(*) INTO l_n1 FROM axb_file
    #           WHERE axb01=g_ayb05 AND axb04=g_ayb06
    #             AND axb05=g_ayb07
    #          IF l_n+l_n1 = 0 THEN
    #             CALL cl_err(g_ayb06,'agl-223',0)
    #             LET g_ayb05 = g_ayb05_t
    #             LET g_ayb06 = g_ayb06_t
    #             LET g_ayb07 = g_ayb07_t
    #             DISPLAY BY NAME g_ayb05,g_ayb06,g_ayb07
    #             NEXT FIELD ayb06
    #          END IF
    #       END IF
    #    END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
           #FUN-920120---add---str---
            WHEN INFIELD(ayb01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aya"
               LET g_qryparam.default1 = g_ayb01
               CALL cl_create_qry() RETURNING g_ayb01
               DISPLAY g_ayb01 TO ayb01
               NEXT FIELD ayb01
           #FUN-920120---add---end---
            WHEN INFIELD(ayb05) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_ayb05
               CALL cl_create_qry() RETURNING g_ayb05
               DISPLAY g_ayb05 TO ayb05
               NEXT FIELD ayb05
            WHEN INFIELD(ayb06)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"    
               LET g_qryparam.default1 = g_ayb06
               CALL cl_create_qry() RETURNING g_ayb06
               DISPLAY g_ayb06 TO ayb06 
               NEXT FIELD ayb06
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
#FUN-920120---add---end---


#Query 查詢
FUNCTION i151_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_ayb01 TO NULL
   INITIALIZE g_ayb05 TO NULL  #FUN-920120 add
   INITIALIZE g_ayb06 TO NULL  #FUN-920120 add
   INITIALIZE g_ayb07 TO NULL  #FUN-920120 add

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i151_curs()                       #取得查詢條件
  #IF INT_FLAG THEN                       #使用者不玩了
  #   LET INT_FLAG = 0
  #   RETURN
  #END IF
   OPEN i151_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      IF cl_null(g_argv1) THEN
         INITIALIZE g_ayb01 TO NULL
         INITIALIZE g_ayb05 TO NULL  #FUN-920120 add
         INITIALIZE g_ayb06 TO NULL  #FUN-920120 add
         INITIALIZE g_ayb07 TO NULL  #FUN-920120 add
      END IF
   ELSE
      CALL i151_fetch('F')                #讀出TEMP第一筆並顯示
      #TQC-C40277--mark--str--
      #OPEN i151_count
      #FETCH i151_count INTO g_row_count
      #TQC-C40277--mark--end--
      CALL i151_count()     #TQC-C40277 add
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i151_fetch(p_flag)
   DEFINE
      p_flag          LIKE type_file.chr1,   #處理方式
      l_abso          LIKE type_file.num10,  #絕對的筆數
      l_aya02         LIKE aya_file.aya02

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i151_b_curs INTO g_ayb01,g_ayb05,g_ayb06,g_ayb07 #FUN-920120 add ayb05,ayb06,ayb07 
      WHEN 'P' FETCH PREVIOUS i151_b_curs INTO g_ayb01,g_ayb05,g_ayb06,g_ayb07 #FUN-920120 add ayb05,ayb06,ayb07 
      WHEN 'F' FETCH FIRST    i151_b_curs INTO g_ayb01,g_ayb05,g_ayb06,g_ayb07 #FUN-920120 add ayb05,ayb06,ayb07 
      WHEN 'L' FETCH LAST     i151_b_curs INTO g_ayb01,g_ayb05,g_ayb06,g_ayb07 #FUN-920120 add ayb05,ayb06,ayb07 
      WHEN '/'
          IF (NOT g_no_ask) THEN   #TQC-C40277  add
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0                #add for prompt bug
             #PROMPT g_msg CLIPPED,': ' FOR l_abso   #TQC-C40277  mark
             PROMPT g_msg CLIPPED,': ' FOR g_jump    #TQC-C40277  add
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION about
                   CALL cl_about()

                ON ACTION HELP
                   CALL cl_show_help()

                ON ACTION controlg
                   CALL cl_cmdask()

             END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF  #TQC-C40277  add
             #FETCH ABSOLUTE l_abso i151_b_curs INTO g_ayb01                            #FUN-920120 mark
             #FETCH ABSOLUTE l_abso i151_b_curs INTO g_ayb01,g_ayb05,g_ayb06,g_ayb07    #FUN-920120 mod   #TQC-C40277  mark
             FETCH ABSOLUTE g_jump i151_b_curs INTO g_ayb01,g_ayb05,g_ayb06,g_ayb07    #FUN-920120 mod    #TQC-C40277  add
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      IF NOT cl_null(g_argv1) THEN
         LET g_ayb01=g_argv1

         DISPLAY g_ayb01 TO ayb01               #單頭   
         DISPLAY g_ayb05 TO ayb05               #FUN-920120 add #單頭   
         DISPLAY g_ayb06 TO ayb06               #FUN-920120 add #單頭   
         DISPLAY g_ayb07 TO ayb07               #FUN-920120 add #單頭   

         LET l_aya02=''
         SELECT aya02 INTO l_aya02 FROM aya_file
                                  WHERE aya01=g_ayb01
         DISPLAY l_aya02 TO FORMONLY.aya02
      ELSE
         CALL cl_err(g_ayb01,SQLCA.sqlcode,0)
      END IF
   ELSE
      CALL i151_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         #WHEN '/' LET g_curs_index = l_abso  #TQC-C40277  mark
         WHEN '/' LET g_curs_index = g_jump   #TQC-C40277  add
      END CASE

      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i151_show()
   DEFINE l_aya02 LIKE aya_file.aya02
   DISPLAY g_ayb01 TO ayb01               #單頭   
   DISPLAY g_ayb05 TO ayb05               #FUN-920120 add #單頭   
   DISPLAY g_ayb06 TO ayb06               #FUN-920120 add #單頭   
   DISPLAY g_ayb07 TO ayb07               #FUN-920120 add #單頭   

   LET l_aya02=''
   SELECT aya02 INTO l_aya02 FROM aya_file
                            WHERE aya01=g_ayb01
   DISPLAY l_aya02 TO FORMONLY.aya02
   CALL i151_ayb06('d',g_ayb06)   #FUN-920120 add
  #CALL i151_b_fill()             #FUN-920120 mark       #單身
   CALL i151_b_fill(g_wc)         #FUN-920120 mod        #單身
   CALL cl_show_fld_cont()
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i151_r()

  #IF g_ayb01 IS NULL THEN   #FUN-920120 mark
   IF cl_null(g_ayb01) OR cl_null(g_ayb05) OR cl_null(g_ayb06) OR cl_null(g_ayb07) THEN  #FUN-920120 mod
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ayb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ayb01       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "ayb05"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_ayb05       #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "ayb06"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_ayb06       #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "ayb07"      #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_ayb07       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM ayb_file WHERE ayb01 = g_ayb01
                             AND ayb05 = g_ayb05   #FUN-920120 add
                             AND ayb06 = g_ayb06   #FUN-920120 add
                             AND ayb07 = g_ayb07   #FUN-920120 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ayb_file",g_ayb01,"",SQLCA.sqlcode,"","BODY DELETE:",1)
      ELSE
         CLEAR FORM
         CALL g_ayb.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         #DISPLAY g_cnt TO FORMONLY.cnt   #TQC-C40277  mark
         #TQC-C40277--add--str--
         CALL i151_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i151_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i151_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE                
            CALL i151_fetch('/')
         END IF
         #TQC-C40277--add--end--
      END IF
   END IF
END FUNCTION

#單身
FUNCTION i151_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT
      l_n             LIKE type_file.num5,        #檢查重複用
      l_lock_sw       LIKE type_file.chr1,        #單身鎖住否
      p_cmd           LIKE type_file.chr1,        #處理狀態
      l_tot           LIKE type_file.num5,
      l_allow_insert  LIKE type_file.num5,        #可新增否
      l_allow_delete  LIKE type_file.num5,        #可刪除否
      l_cnt           LIKE type_file.num5         #判斷FIELD欄位值是否有效

   LET g_action_choice = ""
   IF g_ayb01 IS NULL THEN
      RETURN
   END IF

   CALL cl_opmsg('b')

   #LET g_forupd_sql = "SELECT ayb02,'' FROM ayb_file WHERE ayb01=? FOR UPDATE"   #MOD-840600
   #LET g_forupd_sql = "SELECT ayb02,'' FROM ayb_file WHERE ayb01=? AND ayb02=? FOR UPDATE"   #MOD-840600   #TQC-C40276  mark
   LET g_forupd_sql = "SELECT ayb02,'' FROM ayb_file WHERE ayb01=? AND ayb02=? AND ayb05=? AND ayb06=? AND ayb07=? FOR UPDATE"   #MOD-840600  #TQC-C40276  add
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i151_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_cnt = 0

   INPUT ARRAY g_ayb WITHOUT DEFAULTS FROM s_ayb.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         DISPLAY l_ac  TO FORMONLY.cn2
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ayb_t.* = g_ayb[l_ac].*  #BACKUP

            BEGIN WORK
           #OPEN i151_b_curl USING g_ayb01   #MOD-840600
           #OPEN i151_b_curl USING g_ayb01,g_ayb_t.ayb02                           #FUN-920120 mark   #MOD-840600
            OPEN i151_b_curl USING g_ayb01,g_ayb_t.ayb02,g_ayb05,g_ayb06,g_ayb07  #FUN-920120 mod    #MOD-840600
            IF STATUS THEN
               CALL cl_err("OPEN i151_b_curl:", STATUS, 1)
               LET l_lock_sw = "Y"
             ELSE
                FETCH i151_b_curl INTO g_ayb[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ayb_t.ayb02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                LET g_ayb[l_ac].aag02=i151_set_ayb02(g_ayb[l_ac].ayb02)
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ayb[l_ac].* TO NULL
         LET g_ayb_t.* = g_ayb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD ayb02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
        #FUN-920120---mod---str---
        #INSERT INTO ayb_file(ayb01,ayb02)
        #   VALUES(g_ayb01,g_ayb[l_ac].ayb02)
         INSERT INTO ayb_file(ayb01,ayb02,ayb05,ayb06,ayb07)
            VALUES(g_ayb01,g_ayb[l_ac].ayb02,g_ayb05,g_ayb06,g_ayb07)
        #FUN-920120---mod---end---
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ayb_file",g_ayb[l_ac].ayb02,"",
                         SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      AFTER FIELD ayb02
         IF NOT i151_chk_ayb02() THEN
            #FUN-B20004--begin
            #DISPLAY NULL TO g_ayb[l_ac].aag02
            CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_ayb[1].ayb02,'23',g_ayb07)  
                 RETURNING g_ayb[l_ac].ayb02
            #FUN-B20004--end            
            NEXT FIELD ayb02
         END IF
         LET g_ayb[l_ac].aag02=i151_set_ayb02(g_ayb[l_ac].ayb02)
         DISPLAY BY NAME g_ayb[l_ac].aag02

      BEFORE DELETE                            #是否取消單身
         IF g_ayb_t.ayb02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM ayb_file
               WHERE ayb01 = g_ayb01 AND
                     ayb02 = g_ayb_t.ayb02
                 AND ayb05 = g_ayb05   #FUN-920120 add
                 AND ayb06 = g_ayb06   #FUN-920120 add
                 AND ayb07 = g_ayb07   #FUN-920120 add

            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ayb_file",g_ayb01,g_ayb_t.ayb02,
                            SQLCA.sqlcode,"","",1)
               LET l_ac_t = l_ac
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE i151_b_curl
               COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ayb[l_ac].* = g_ayb_t.*
            CLOSE i151_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ayb[l_ac].ayb02,-263,1)
            LET g_ayb[l_ac].* = g_ayb_t.*
         ELSE
            UPDATE ayb_file SET ayb02 = g_ayb[l_ac].ayb02
               WHERE ayb01 = g_ayb01
                 AND ayb02 = g_ayb_t.ayb02
                 AND ayb05 = g_ayb05   #FUN-920120 add
                 AND ayb06 = g_ayb06   #FUN-920120 add
                 AND ayb07 = g_ayb07   #FUN-920120 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ayb_file",g_ayb01,g_ayb_t.ayb02,
                            SQLCA.sqlcode,"","",1)
               LET g_ayb[l_ac].* = g_ayb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ayb[l_ac].* = g_ayb_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_ayb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i151_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE i151_b_curl
         COMMIT WORK

      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ayb02)
             #FUN-920120---mod---str---
             #CALL cl_init_qry_var()
             #LET g_qryparam.form ="q_aag"
             #LET g_qryparam.default1 = g_ayb[l_ac].ayb02
             #LET g_qryparam.arg1 = g_aaz.aaz64
             #CALL cl_create_qry() RETURNING g_ayb[l_ac].ayb02
             #DISPLAY BY NAME g_ayb[l_ac].ayb02
             #NEXT FIELD ayb02
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_ayb[1].ayb02,'23',g_ayb07)    #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070 #TQC-9C0099
              #CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_ayb[1].ayb02,'23',g_ayb07)    #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070 #TQC-9C0099  #FUN-A30122 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_ayb[1].ayb02,'23',g_ayb07)  #FUN-A30122 add
                    RETURNING g_ayb[l_ac].ayb02
               #DISPLAY g_qryparam.multiret TO ayb02  #FUN-B20004
               DISPLAY g_ayb[l_ac].ayb02 TO ayb02   #FUN-B20004
               NEXT FIELD ayb02
             #FUN-920120---mod---end---
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END INPUT

   CLOSE i151_b_curl

   OPTIONS
      INSERT KEY F1,
      DELETE KEY F2
END FUNCTION

#FUNCTION i151_b_fill()                    #FUN-920120 mark     #BODY FILL UP
FUNCTION i151_b_fill(p_wc)                 #FUN-920120 mod      #BODY FILL UP
DEFINE p_wc      LIKE type_file.chr1000    #FUN-920120 add

  #FUN-920120---add---str---
  #DECLARE ayb_curs CURSOR FOR
  #   SELECT ayb02,''
  #   FROM ayb_file WHERE ayb01=g_ayb01
   LET g_sql = "SELECT ayb02,'' ", 
               "  FROM ayb_file ",
               " WHERE ayb01 = '",g_ayb01,"' AND ", p_wc CLIPPED ,
               "   AND ayb05 = '",g_ayb05,"'", 
               "   AND ayb06 = '",g_ayb06,"'",   
               "   AND ayb07 = '",g_ayb07,"'"   
   PREPARE ayb_pre FROM g_sql      #預備一下
   DECLARE ayb_curs CURSOR FOR ayb_pre
  #FUN-920120---add---end---

   CALL g_ayb.clear()

   LET g_cnt = 1
   FOREACH ayb_curs INTO g_ayb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_ayb[g_cnt].aag02=i151_set_ayb02(g_ayb[g_cnt].ayb02)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ayb.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   LET g_rec_b= g_cnt

   DISPLAY g_cnt TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i151_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_ayb TO s_ayb.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
   
     #FUN-920120---add---str---
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
     #FUN-920120---add---end---
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i151_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i151_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i151_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      ON ACTION next
         CALL i151_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      ON ACTION last
         CALL i151_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i151_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    #CALL cl_set_comp_entry("ayb01",TRUE)                    #FUN-920120 mark
     CALL cl_set_comp_entry("ayb01,ayb05,ayb06,ayb07",TRUE)  #FUN-920120 mod
   END IF

END FUNCTION

FUNCTION i151_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
     #CALL cl_set_comp_entry("ayb01",FALSE)                    #FUN-920120 mark
      CALL cl_set_comp_entry("ayb01,ayb05,ayb06,ayb07",FALSE)  #FUN-920120 mod
   END IF

   CALL cl_set_comp_entry("ayb07",FALSE) #FUN-920120 add
END FUNCTION

FUNCTION i151_set_ayb02(p_ayb02)
   DEFINE l_aag02 LIKE aag_file.aag02
   DEFINE p_ayb02 LIKE ayb_file.ayb02
   IF cl_null(p_ayb02) THEN RETURN NULL END IF
   LET l_aag02=''

  #FUN-920120---mod---str---
   LET g_sql = "SELECT aag02 ",
              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
              #"  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102   #FUN-A30122 mark
               "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), #FUN-A30122   add
               " WHERE aag01 = '",p_ayb02,"'",
               "   AND aag00 = '",g_ayb07,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
 # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102  #FUN-A30122 mark
   CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql             #FUN-A30122 
   PREPARE i151_pre_2 FROM g_sql
   DECLARE i151_cur_2 CURSOR FOR i151_pre_2
   OPEN i151_cur_2
   FETCH i151_cur_2 INTO l_aag02

  #SELECT aag02 INTO l_aag02 FROM aag_file 
  #                         WHERE aag01=p_ayb02
  #                           AND aag00=g_aaz.aaz64
  #FUN-920120---mod---end---
   RETURN l_aag02
END FUNCTION

FUNCTION i151_chk_ayb02()
 DEFINE l_aagacti LIKE aag_file.aagacti

   IF NOT cl_null(g_ayb[l_ac].ayb02) THEN
     #FUN-920120---mod---str---
      LET g_sql = "SELECT aagacti ",
                 #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
                 #"  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102  #FUN-A30122 mark
                  "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), #FUN-A30122 
                  " WHERE aag01 = '",g_ayb[l_ac].ayb02,"'",
                  "   AND aag00 = '",g_ayb07,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
    # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102   #FUN-A30122 mark
      CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql              #FUN-A30122 add   
      PREPARE i151_pre_3 FROM g_sql
      DECLARE i151_cur_3 CURSOR FOR i151_pre_3
      OPEN i151_cur_3
      FETCH i151_cur_3 INTO l_aagacti

     #SELECT aagacti INTO l_aagacti FROM aag_file 
     #                          WHERE aag01 = g_ayb[l_ac].ayb02
     #                            AND aag00 = g_aaz.aaz64
     #FUN-920120---mod---end---
      CASE
         WHEN SQLCA.SQLCODE
            #FUN-B20004--begin
            #CALL cl_err3("sel","aag_file",g_ayb[l_ac].ayb02,"",
            #             SQLCA.SQLCODE,"","",1)
            CALL cl_err3("sel","aag_file",g_ayb[l_ac].ayb02,"",
                         SQLCA.SQLCODE,"","",0)              
            RETURN FALSE
         WHEN l_aagacti='N'
            #CALL cl_err3("sel","aag_file",g_ayb[l_ac].ayb02,"",9028,"","",1)  #FUN-B20004
            CALL cl_err3("sel","aag_file",g_ayb[l_ac].ayb02,"",9028,"","",0)   #FUN-B20004
            RETURN FALSE         
      END CASE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-780013

#FUN-920120---add---str---
FUNCTION  i151_ayb06(p_cmd,p_ayb06)  
DEFINE p_cmd           LIKE type_file.chr1,         
       p_ayb06         LIKE ayb_file.ayb06,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       #l_aaz641        LIKE aaz_file.aaz641   #FUN-B50001 
       l_aaw01        LIKE aaw_file.aaw01    

    LET g_errno = ' '

    SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
      FROM axz_file
     WHERE axz01 = p_ayb06

#FUN-A30122 -------------------mark start-------------------------
#   LET g_plant_new = l_axz03      #營運中心
#   CALL s_getdbs()
#   LET g_dbs_axz03 = g_dbs_new    #所屬DB

#  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
#   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#               " WHERE aaz00 = '0'"
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#   PREPARE i151_pre_1 FROM g_sql
#   DECLARE i151_cur_1 CURSOR FOR i151_pre_1
#   OPEN i151_cur_1
#   FETCH i151_cur_1 INTO l_aaz641    #合併後帳別
#   IF cl_null(l_aaz641) THEN
#       CALL cl_err(l_axz03,'agl-601',1)
#   END IF
#FUN-A30122 ------------------mark end--------------------------------------
    CALL s_aaz641_dbs(g_ayb05,p_ayb06) RETURNING g_plant_axz03           #FUN-A30122 add         
    #CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaz641                  #FUN-A30122 add #FUN-B50001
    CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaw01                    #FUN-B50001
    LET g_plant_new = g_plant_axz03                                      #FUN-A30122 add 
  
   # LET g_ayb07 = l_aaz641   #FUN-B50001 
    LET g_ayb07 = l_aaw01
    LET g_axz05 = l_axz05

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'mfg9142'
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03                                          
       DISPLAY g_ayb07 TO FORMONLY.ayb07 
    END IF

END FUNCTION

FUNCTION  i151_ayb01(p_cmd,p_ayb01)  
DEFINE p_cmd           LIKE type_file.chr1,         
       p_ayb01         LIKE ayb_file.ayb01,
       l_aya01         LIKE aya_file.aya01

    LET g_errno = ' '

    LET g_sql = "SELECT aya01 FROM aya_file",
                " WHERE aya01 = '",g_ayb01,"'"

    PREPARE i151_pre_4 FROM g_sql
    DECLARE i151_cur_4 CURSOR FOR i151_pre_4
    OPEN i151_cur_4
    FETCH i151_cur_4 INTO l_aya01
    IF cl_null(l_aya01) THEN
#       LET g_errno = 'apy-169'    #CHI-B40058
       LET g_errno = 'agl-264'     #CHI-B40058
    END IF

END FUNCTION

#FUN-920120---add---end---

#TQC-C40277--add--str--
FUNCTION i151_count()
   DEFINE li_cnt      LIKE type_file.num5
   DEFINE l_ayb       DYNAMIC ARRAY OF RECORD
             ayb01    LIKE ayb_file.ayb01,
             ayb05    LIKE ayb_file.ayb05,
             ayb06    LIKE ayb_file.ayb06,
             ayb07    LIKE ayb_file.ayb07
                      END RECORD

      OPEN i151_count
      LET li_cnt = 1
      FOREACH i151_count INTO l_ayb[li_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET li_cnt = li_cnt + 1
      END FOREACH
      LET g_row_count = li_cnt - 1
      CLOSE i151_count
END FUNCTION
#TQC-C40277--add--end--
