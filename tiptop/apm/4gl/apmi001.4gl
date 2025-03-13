# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmi001.4gl
# Descriptions...: 三角貿易計價方式維護作業
# Date & Author..: 03/08/25 By Kammy
# Note...........: 1.請以後維護程式的人先暫時不要將array 放大，仍維持最多
#                    只能打六站的資料
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: No.MOD-4A0248 04/10/18 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0095 05/01/06 By Mandy 報表轉XML
# Modify.........: No.MOD-530598 05/03/28 By Carol 1.不選擇計價基礎可以過
#                                                  2.但是會造成Key值會為NULL ,無法維護這些資料
#                                                  3.單身新增時打到比率時壓ENTER無法往下一筆
# Modify.........: NO.MOD-590156 05/09/13 BY Yiting  1.輸入單頭資料若未輸入計價基準就會無法維護資料
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: NO.FUN-630006 06/03/06 BY Nicola 單身增加站別 0
# Modify.........: No.FUN-640025 06/04/08 By Nicola 取消站別0
# Modify.........: No.FUN-660051 06/06/12 By Nicola 計價基準增加3,4
# Modify.........: No.FUN-660129 06/06/23 By wujie  cl_err-->cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.TQC-6A0090 06/11/06 By baogui表頭多行空白
# Modify.........: No.FUN-6A0162 06/11/11 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.MOD-6B0135 06/12/11 By claire 單身選按比率時,計價比率不可空白
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: NO.TQC-740248 07/04/22 BY yiting 若計價方式為按比率則計價比率應要強制輸入
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: No.FUN-7C0043 07/12/28 By Cockroah 報表改為p_query實現
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.CHI-960008 09/06/10 By Dido 要設定有 99 站才可設定計價基準 3,4
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990066 09/09/16 By lilingyu "計價比率"欄位應該控管負數
# Modify.........: No:MOD-A10082 10/01/15 By Dido 增加變數清空
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_pox01         LIKE pox_file.pox01,   #流程代碼 (假單頭)
    g_pox02         LIKE pox_file.pox02,   #生效日期 (假單頭)
    g_pox03         LIKE pox_file.pox03,   #計價基準 (假單頭)
    g_pox01_t       LIKE pox_file.pox01,   #流程代碼   (舊值)
    g_pox02_t       LIKE pox_file.pox02,   #生效日期   (舊值)
    g_pox03_t       LIKE pox_file.pox03,   #計價基準   (舊值)
    l_cnt           LIKE type_file.num5,          #No.FUN-680136 SMALLINT
    l_cnt1          LIKE type_file.num5,          #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(100)
    g_pox           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        pox04       LIKE pox_file.pox04,          #站別
        poy03       LIKE poy_file.poy03,          #下游廠商
        pmc03       LIKE pmc_file.pmc03,          #簡稱
        pox05       LIKE pox_file.pox05,          #計價方式
        pox06       LIKE pox_file.pox06           #計價比率
                    END RECORD,
    g_pox_t         RECORD                        #程式變數 (舊值)
        pox04       LIKE pox_file.pox04,          #站別
        poy03       LIKE poy_file.poy03,          #下游廠商
        pmc03       LIKE pmc_file.pmc03,          #簡稱
        pox05       LIKE pox_file.pox05,          #計價方式
        pox06       LIKE pox_file.pox06           #計價比率
                    END RECORD,
    g_poz02         LIKE poz_file.poz02,
    g_wc,g_wc2,g_sql   STRING,    #No.FUN-580092 HCN
    g_delete           LIKE type_file.chr1,       #若刪除資料,則要重新顯示筆數 #No.FUN-680136 VARCHAR(01)
    g_rec_b            LIKE type_file.num5,       #單身筆數                    #No.FUN-680136 SMALLINT
    l_ac               LIKE type_file.num5        #目前處理的ARRAY CNT         #No.FUN-680136 SMALLINT
                       
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp       STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_pox01 = NULL                     #清除鍵值
   LET g_pox02 = NULL                     #清除鍵值
   LET g_pox03 = NULL                     #清除鍵值
   LET g_pox01_t = NULL
   LET g_pox02_t = NULL
   LET g_pox03_t = NULL
   LET p_row = 3 LET p_col = 25
   OPEN WINDOW i001_w AT p_row,p_col               #顯示畫面
     WITH FORM "apm/42f/apmi001"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
       
   LET g_delete='N'
   CALL i001_menu()
   CLOSE WINDOW i001_w                    #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i001_cs()
 
   CLEAR FORM                                             #清除畫面
   CALL g_pox.clear()
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pox01 TO NULL    #No.FUN-750051
   INITIALIZE g_pox02 TO NULL    #No.FUN-750051
   INITIALIZE g_pox03 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON pox01,pox02,pox03,pox04,pox05,pox06
                FROM pox01,pox02,pox03,s_pox[1].pox04,s_pox[1].pox05,s_pox[1].pox06
 
       #--No.MOD-4A0248--------
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
        CASE WHEN INFIELD(pox01) #流程代號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_poz"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pox01
               NEXT FIELD pox01
         OTHERWISE EXIT CASE
         END CASE
      #--END---------------
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT UNIQUE pox01,pox02,pox03 ",
              " FROM pox_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY pox01,pox02,pox03"
   PREPARE i001_prepare FROM g_sql      #預備一下
   DECLARE i001_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i001_prepare
 
#  LET g_sql="SELECT pox01,pox02,pox03",      #No.TQC-720019
   LET g_sql_tmp="SELECT pox01,pox02,pox03",  #No.TQC-720019
             "  FROM pox_file WHERE ", g_wc CLIPPED,
             " GROUP BY pox01,pox02,pox03 ",
             " INTO TEMP x"
   DROP TABLE x
#  PREPARE i001_precount_x FROM g_sql      #No.TQC-720019
   PREPARE i001_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i001_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i001_precount FROM g_sql
   DECLARE i001_count CURSOR FOR i001_precount
 
END FUNCTION
 
FUNCTION i001_menu()
   WHILE TRUE
     #NO.590002 START----------
    #LET g_pox03 = '1'   #No.FUN-660051 Mark
     #NO.590002 END------------
      CALL i001_bp("G")
      CASE g_action_choice
           WHEN "insert" 
            IF cl_chk_act_auth() THEN 
                CALL i001_a()
            END IF
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL i001_q()
            END IF
           WHEN "modify" 
            IF cl_chk_act_auth() THEN
                 CALL i001_u()
            END IF
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
                CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
           WHEN "next" 
            CALL i001_fetch('N')
           WHEN "previous" 
            CALL i001_fetch('P')
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL i001_r()
            END IF
          WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
           WHEN "related_document"   #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_pox01 IS NOT NULL THEN
                  LET g_doc.column1 = "pox01"
                  LET g_doc.column2 = "pox02"
                  LET g_doc.value1 = g_pox01
                  LET g_doc.value2 = g_pox02
                  CALL cl_doc()
               END IF
            END IF
 
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL i001_fetch('/')
           WHEN "controlg"     
            CALL cl_cmdask()
           WHEN "exporttoexcel"    #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pox),'','')           
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_a()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_pox.clear()
   INITIALIZE g_pox01 LIKE pox_file.pox01
   INITIALIZE g_pox02 LIKE pox_file.pox02
   INITIALIZE g_pox03 LIKE pox_file.pox03
   LET g_pox01_t = NULL
   LET g_pox02_t = NULL
   LET g_pox03_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      #NO.MOD-590156
      LET g_pox03 = '1'
      #NO.MOD-590156
 
      CALL i001_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      #自動產生單身
      LET g_rec_b =0                     #NO.FUN-680064
      CALL i001_g_b()
      CALL i001_b()                      #輸入單身
      LET g_pox01_t = g_pox01            #保留舊值
      LET g_pox02_t = g_pox02            #保留舊值
      LET g_pox03_t = g_pox03            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_g_b()
    
   LET g_success = 'Y'
 
   BEGIN WORK
 
   DECLARE i001_gb_cs CURSOR FOR
    SELECT poy02,poy03,pmc03,'',''
      FROM poy_file,OUTER pmc_file 
     WHERE poy01 = g_pox01 AND pmc_file.pmc01 = poy_file.poy03
 
   LET g_cnt = 1
 
  ##-----No.FUN-640025 Mark-----
  ##-----No.FUN-630006-----
  #LET g_pox[g_cnt].pox04 = "0"
  #LET g_pox[g_cnt].pox05 = ""
  #LET g_pox[g_cnt].pox06 = ""
 
  #SELECT poz04 INTO g_pox[g_cnt].poy03
  #  FROM poz_file
  # WHERE poz01 = g_pox01
 
  #SELECT pmc03 INTO g_pox[g_cnt].pmc03 FROM pmc_file
  # WHERE pmc01 = g_pox[g_cnt].poy03
 
  #INSERT INTO pox_file(pox01,pox02,pox03,pox04,pox05,pox06)
  #     VALUES (g_pox01,g_pox02,g_pox03,"0","","")
  #IF STATUS THEN
  #   CALL cl_err("",STATUS,1)
  #   LET g_success = "N"
  #END IF
  #
  #LET g_cnt = 2
  ##-----No.FUN-630006 END-----
  ##-----No.FUN-640025 Mark END-----
 
   FOREACH i001_gb_cs INTO g_pox[g_cnt].*
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         LET g_success = 'N' EXIT FOREACH
      END IF
 
      INSERT INTO pox_file(pox01,pox02,pox03,pox04,pox05,pox06)
           VALUES (g_pox01,g_pox02,g_pox03,g_pox[g_cnt].pox04,
                   g_pox[g_cnt].pox05,g_pox[g_cnt].pox06)
 
      LET g_cnt = g_cnt + 1
 
      IF STATUS THEN
        #IF STATUS = -239 THEN #CHI-790021 
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #CHI-790021 
            CONTINUE FOREACH 
         ELSE
#           CALL cl_err('',STATUS,1)
            CALL cl_err3("ins","pox_file",g_pox01,g_pox02,STATUS,"","",1)   #No.FUN-660129
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
 
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   LET g_rec_b = g_cnt - 1
  
END FUNCTION
   
FUNCTION i001_u()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_pox01 IS NULL OR g_pox02 IS NULL OR g_pox03 IS NULL  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pox01_t = g_pox01
   LET g_pox02_t = g_pox02
   LET g_pox03_t = g_pox03
   WHILE TRUE
      CALL i001_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET g_pox01=g_pox01_t
         LET g_pox02=g_pox02_t
         LET g_pox03=g_pox03_t
         DISPLAY g_pox01,g_pox02,g_pox03 TO pox01,pox02,pox03 #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_pox01 != g_pox01_t OR g_pox02 != g_pox02_t OR 
         g_pox03 != g_pox03_t THEN #更改單頭值
         UPDATE pox_file SET pox01 = g_pox01,  #更新DB
                             pox02 = g_pox02,
                             pox03 = g_pox03
          WHERE pox01 = g_pox01_t          #COLAUTH?
            AND pox02 = g_pox02_t
            AND pox03 = g_pox03_t
         IF SQLCA.sqlcode THEN
            LET g_msg = g_pox01 CLIPPED,' + ', g_pox02 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)
            CALL cl_err3("upd","pox_file",g_pox01,g_pox02,SQLCA.sqlcode,"","",1)   #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1            #a:輸入 u:更改   #No.FUN-680136 VARCHAR(1)
DEFINE l_poz00         LIKE poz_file.poz00            #No.FUN-660051
 
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032  
   INPUT g_pox01, g_pox02,g_pox03  WITHOUT DEFAULTS 
          FROM pox01,pox02,pox03 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i001_set_entry(p_cmd)
         CALL i001_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pox01                # 流程代號
         IF NOT cl_null(g_pox01) THEN 
            IF g_pox01 != g_pox01_t OR g_pox01_t IS NULL THEN
               CALL i001_poz('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pox01,g_errno,0)
                  LET g_pox01 = g_pox01_t
                  DISPLAY g_pox01 TO pox01
                  NEXT FIELD pox01
               END IF
            END IF
         END IF
 
      AFTER FIELD pox02                #生效日期       
         IF NOT cl_null(g_pox02) THEN 
            IF p_cmd="a" OR (p_cmd="u" AND 
               (g_pox01!=g_pox01_t OR g_pox02!=g_pox02_t OR 
                g_pox03!=g_pox03_t))   THEN
               SELECT count(*) INTO g_cnt FROM pox_file
                WHERE pox01 = g_pox01 AND pox02 = g_pox02
               IF g_cnt > 0 THEN        #資料重複
                  LET g_msg = g_pox01 CLIPPED,' + ', g_pox02 CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  LET g_pox01 = g_pox01_t
                  LET g_pox02 = g_pox02_t
                  LET g_pox03 = g_pox03_t
                  DISPLAY g_pox01 TO pox01 
                  DISPLAY g_pox02 TO pox02 
                  DISPLAY g_pox03 TO pox03 
                  NEXT FIELD pox01
               END IF
            END IF
         END IF
               
 
      AFTER FIELD pox03                #計價基準
         IF NOT cl_null(g_pox03) THEN
            IF g_pox03 NOT MATCHES '[1234]' THEN  #No.FUN-660051
               NEXT FIELD pox03
            END IF
            #-----No.FUN-660051-----
            SELECT poz00 INTO l_poz00 FROM poz_file
             WHERE poz01 = g_pox01
            IF l_poz00 = "1" AND (g_pox03 = "3" OR g_pox03 = "4") THEN
               CALL cl_err(g_pox01,"apm-050",0) 
               NEXT FIELD pox03
            END IF 
            #-----No.FUN-660051 END-----
            #-CHI-960008-add-
            IF l_poz00 = "2" AND (g_pox03 = "3" OR g_pox03 = "4") THEN
               SELECT COUNT(*) INTO l_cnt FROM poy_file
                WHERE poy01 = g_pox01
                  AND poy02 = 99  
               IF l_cnt = 0 THEN
                  CALL cl_err(g_pox01,'apm-069',1)  
                  NEXT FIELD pox03
               END IF
            END IF
            #-CHI-960008-end-
         END IF
 
      ON ACTION CONTROLP                  
         CASE
            WHEN INFIELD(pox01)
#              CALL q_poz(10,3,g_pox01,'') RETURNING g_pox01
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz" 
               LET g_qryparam.default1 = g_pox01
               CALL cl_create_qry() RETURNING g_pox01
               DISPLAY g_pox01 TO pox01
               NEXT FIELD pox01
            OTHERWISE         
         END CASE
  
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
     
      #TQC-860019-begin-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
      #TQC-860019-end-add
          
   END INPUT
 
END FUNCTION
 
FUNCTION i001_q()
  DEFINE l_pox01  LIKE pox_file.pox01,
         l_pox02  LIKE pox_file.pox02,
         l_pox03  LIKE pox_file.pox03,
         l_curr   LIKE pox_file.pox02,
         l_cnt    LIKE type_file.num10        #No.FUN-680136 INTEGER               
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pox01 TO NULL                #No.FUN-6A0162
    INITIALIZE g_pox02 TO NULL                #No.FUN-6A0162
    INITIALIZE g_pox03 TO NULL                #NO.FUN-6A0162
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL i001_cs()                             #取得查詢條件
   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_pox01 TO NULL
      INITIALIZE g_pox02 TO NULL
      INITIALIZE g_pox03 TO NULL
      RETURN
   END IF
   OPEN i001_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pox01 TO NULL
      INITIALIZE g_pox02 TO NULL
      INITIALIZE g_pox03 TO NULL
   ELSE
      CALL i001_fetch('F')            #讀出TEMP第一筆並顯示
      OPEN i001_count
      FETCH i001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
 
END FUNCTION
 
FUNCTION i001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i001_bcs INTO g_pox01,g_pox02,g_pox03
        WHEN 'P' FETCH PREVIOUS i001_bcs INTO g_pox01,g_pox02,g_pox03
        WHEN 'F' FETCH FIRST    i001_bcs INTO g_pox01,g_pox02,g_pox03
        WHEN 'L' FETCH LAST     i001_bcs INTO g_pox01,g_pox02,g_pox03
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i001_bcs INTO g_pox01,g_pox02,g_pox03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_pox01,SQLCA.sqlcode,0)
       INITIALIZE g_pox01 TO NULL  #TQC-6B0105
       INITIALIZE g_pox02 TO NULL  #TQC-6B0105
       INITIALIZE g_pox03 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CALL i001_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
FUNCTION i001_show()
 
    DISPLAY g_pox01 TO pox01 
    DISPLAY g_pox02 TO pox02
    DISPLAY g_pox03 TO pox03
    CALL i001_poz('d')
    CALL i001_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i001_poz(p_cmd)
   DEFINE l_pozacti LIKE poz_file.pozacti
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   SELECT poz02,pozacti INTO g_poz02,l_pozacti
     FROM poz_file WHERE poz01=g_pox01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'tri-006'
                                  LET g_poz02 = NULL
        WHEN l_pozacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY g_poz02 TO FORMONLY.poz02
   END IF
 
END FUNCTION
 
FUNCTION i001_r()
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pox01 IS NULL OR g_pox02 IS NULL OR g_pox03 IS NULL  THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0162
       RETURN
    END IF
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pox01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "pox02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pox01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_pox02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM pox_file
        WHERE pox01 = g_pox01 
          AND pox02 = g_pox02
          AND pox03 = g_pox03
       IF SQLCA.sqlcode THEN
#         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
          CALL cl_err3("del","pox_file",g_pox01,g_pox02,SQLCA.sqlcode,"","BODY DELETE:",1)       #No.FUN-660129
       ELSE
          CLEAR FORM
          CALL g_pox.clear()
          LET g_delete='Y'
          LET g_pox01 = NULL
          LET g_pox02 = NULL
          LET g_pox03 = NULL
          LET g_cnt=SQLCA.SQLERRD[3]
          MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
          DROP TABLE x
#         EXECUTE i001_precount_x                  #No.TQC-720019
          PREPARE i001_precount_x2 FROM g_sql_tmp  #No.TQC-720019
          EXECUTE i001_precount_x2                 #No.TQC-720019
          OPEN i001_count
          FETCH i001_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i001_bcs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i001_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i001_fetch('/')
          END IF
       END IF
    END IF
END FUNCTION
 
FUNCTION i001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pox01 IS NULL OR g_pox02 IS NULL OR g_pox03 IS NULL  THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pox04,'','',pox05,pox06 FROM pox_file",
                       "  WHERE pox01=? AND pox02=? AND pox03=?",
                       "   AND pox04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 #MOD-530598
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
#
 
    INPUT ARRAY g_pox WITHOUT DEFAULTS FROM s_pox.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_pox_t.* = g_pox[l_ac].*      #BACKUP
             BEGIN WORK
             OPEN i001_bcl USING g_pox01,g_pox02,g_pox03,g_pox_t.pox04
             IF STATUS THEN
                CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i001_bcl INTO g_pox[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pox_t.pox05,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
               ##-----No.FUN-640025 Mark-----
               ##-----No.FUN-630006-----
               #IF g_pox[l_ac].pox04 = "0" THEN
               #   IF g_pox03 = "1" THEN
               #      SELECT poz05 INTO g_pox[l_ac].poy03
               #        FROM poz_file
               #       WHERE poz01 = g_pox01
               #   ELSE
               #      SELECT poz04 INTO g_pox[l_ac].poy03
               #        FROM poz_file
               #       WHERE poz01 = g_pox01
               #   END IF
               #ELSE
                   SELECT poy03 INTO g_pox[l_ac].poy03 FROM poy_file
                    WHERE poy01 = g_pox01
                      AND poy02 = g_pox[l_ac].pox04
               #END IF
               ##-----No.FUN-630006 END-----
               ##-----No.FUN-640025 Mark END-----
                SELECT pmc03 INTO g_pox[l_ac].pmc03 FROM pmc_file
                 WHERE pmc01 = g_pox[l_ac].poy03
                CALL i001_set_no_entry_b(p_cmd)
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_pox[l_ac].* TO NULL      #900423
          LET g_pox_t.* = g_pox[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD pox05
 
       BEFORE FIELD pox05                        #計價方式
          CALL i001_set_entry_b(p_cmd)
 
       AFTER FIELD pox05                        #計價方式
          IF NOT cl_null(g_pox[l_ac].pox05) THEN
             IF g_pox[l_ac].pox05 NOT MATCHES '[123]' THEN
                NEXT FIELD pox05
             END IF
             #MOD-530598
             IF g_pox[l_ac].pox05 <> '1' THEN
                LET g_pox[l_ac].pox06 = ''
                DISPLAY BY NAME g_pox[l_ac].pox06
             END IF
          END IF
          CALL i001_set_no_entry_b(p_cmd)
       #MOD-6B0135-begin-add
 
#NO.TQC-740248 start--
          IF g_pox[l_ac].pox05 = '1' THEN
              CALL cl_set_comp_required("pox06",TRUE)
          END IF
#NO.TQC-740248 end---
 
        AFTER FIELD pox06                        #計價比率
#TQC-990066 --begin--
          IF NOT cl_null(g_pox[l_ac].pox06) THEN
             IF g_pox[l_ac].pox06 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD pox06
             END IF 
          END IF 
#TQC-990066 --end--
          IF g_pox[l_ac].pox05='1' THEN
             IF g_pox[l_ac].pox06= 0 OR cl_null(g_pox[l_ac].pox06) THEN
                CALL cl_err('','mfg5103',1)
                NEXT FIELD pox06
             END IF           
          END IF 
       #MOD-6B0135-end-add
          ##
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN 
                LET g_pox[l_ac].* = g_pox_t.*
             END IF 
             CLOSE i001_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
#TQC-990066 --begin--
          IF NOT cl_null(g_pox[l_ac].pox06) THEN
             IF g_pox[l_ac].pox06 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD pox06
             END IF
          END IF
#TQC-990066 --end--
          IF g_pox[l_ac].pox04 IS NOT NULL THEN
             IF g_pox_t.pox04 IS NOT NULL THEN
                UPDATE pox_file SET pox05 = g_pox[l_ac].pox05,
                                    pox06 = g_pox[l_ac].pox06
                 WHERE pox01 = g_pox01
                   AND pox02 = g_pox02  
                   AND pox03 = g_pox03
                   AND pox04 = g_pox_t.pox04
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pox[l_ac].pox05,SQLCA.sqlcode,0)
                   CALL cl_err3("upd","pox_file",g_pox01,g_pox[l_ac].pox05,SQLCA.sqlcode,"","",1)    #No.FUN-660129
                   LET g_pox[l_ac].* = g_pox_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
            #      COMMIT WORK
                END IF
             END IF
          END IF
          CLOSE i001_bcl
          COMMIT WORK
 
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
 
    CLOSE i001_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b_askkey()
DEFINE l_wc   LIKE type_file.chr1000                 #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc ON pox05,pox06             #螢幕上取條件
       FROM s_pox[1].pox05,s_pox[1].pox06
 
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
       LET INT_FLAG = FALSE
       RETURN
    END IF
 
    CALL i001_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc   LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    CALL g_pox.clear()     #MOD-A10082
    LET g_sql = "SELECT pox04,poy03,'',pox05,pox06 ",
                "  FROM pox_file ,OUTER poy_file ",
                " WHERE pox01 = '",g_pox01,"' ",
                "   AND pox02 = '",g_pox02,"' ",
                "   AND pox03 = '",g_pox03,"' ",
                "   AND pox_file.pox01 = poy_file.poy01 ",
                "   AND pox_file.pox04 = poy_file.poy02 ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE i001_prepare2 FROM g_sql      #預備一下
    DECLARE pox_cs CURSOR FOR i001_prepare2
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH pox_cs INTO g_pox[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
      ##-----No.FUN-640025 Mark-----
      ##-----No.FUN-630006-----
      #IF g_pox[g_cnt].pox04 = "0" THEN
      #   IF g_pox03 = "1" THEN
      #      SELECT poz05 INTO g_pox[g_cnt].poy03
      #        FROM poz_file
      #       WHERE poz01 = g_pox01
      #   ELSE
      #      SELECT poz04 INTO g_pox[g_cnt].poy03
      #        FROM poz_file
      #       WHERE poz01 = g_pox01
      #   END IF
      #END IF
      ##-----No.FUN-630006 END-----
      ##-----No.FUN-640025 Mark END-----
 
       SELECT pmc03 INTO g_pox[g_cnt].pmc03 FROM pmc_file
        WHERE pmc01 = g_pox[g_cnt].poy03
 
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_pox.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1            
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i001_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pox TO s_pox.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting( g_curs_index, g_row_count )
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       
        ON ACTION insert      
           LET g_action_choice="insert"     
           EXIT DISPLAY 
       
        ON ACTION query       
           LET g_action_choice="query"      
           EXIT DISPLAY 
       
         ON ACTION first 
            CALL i001_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                 
         ON ACTION previous
            CALL i001_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                 
         ON ACTION jump 
            CALL i001_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                 
         ON ACTION next
            CALL i001_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                 
         ON ACTION last 
            CALL i001_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
        ON ACTION delete      
           LET g_action_choice="delete"     
           EXIT DISPLAY 
 
        ON ACTION modify
           LET g_action_choice="modify"
           EXIT DISPLAY
 
        ON ACTION detail      
           LET g_action_choice="detail"    
           EXIT DISPLAY 
           LET l_ac = 1
 
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
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
     
        ON ACTION cancel
             LET INT_FLAG=FALSE          #MOD-570244 mars
           LET g_action_choice="exit"
           EXIT DISPLAY
     
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION related_document            #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
       
        ON ACTION exporttoexcel   #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i001_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("pox01,pox02",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i001_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("pox01,pox02",FALSE) 
    END IF 
 
END FUNCTION
 
 #MOD-530598 add
FUNCTION i001_set_entry_b(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    CALL cl_set_comp_entry("pox06",TRUE)
 
END FUNCTION
 
FUNCTION i001_set_no_entry_b(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)
 
    IF g_pox[l_ac].pox05 != '1' THEN 
       CALL cl_set_comp_entry("pox06",FALSE) 
       LET g_pox[l_ac].pox06 = ''
       DISPLAY BY NAME g_pox[l_ac].pox06
    END IF
 
END FUNCTION
##
 
 
#NO.FUN-7C0043 --BEGIN MARK--
FUNCTION i001_out()
#   DEFINE
#       l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
#       l_pox           RECORD LIKE pox_file.*,
#       l_gen           RECORD LIKE gen_file.*,
#       l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
#       sr              RECORD LIKE pox_file.*,
#       sr1 RECORD     
#            poz02    LIKE poz_file.poz02,
#            poy03    LIKE poy_file.poy03,
#            pmc03    LIKE pmc_file.pmc03
#           END RECORD,
#       l_za05          LIKE type_file.chr1000                #No.FUN-680136 VARCHAR(40)
   DEFINE   l_cmd      LIKE type_file.chr1000   #NO.FUN-7C0043     
    IF cl_null(g_wc) AND NOT cl_null(g_pox01) AND NOT cl_null(g_pox02) THEN                                                         
       LET g_wc=" pox01='",g_pox01,"'"," AND pox02='",g_pox02,"'"                                                                   
    END IF                                                                                                                          
    IF cl_null(g_wc) THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                 
    LET l_cmd = 'p_query "apmi001" "',g_wc CLIPPED,'"'     ##### "',g_wc2 CLIPPED,'"'                                               
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN              
#   #FUN-4C0095----
#   IF cl_null(g_wc) THEN 
#       LET g_wc="     pox01='",g_pox01,"'",
#                " AND pox02='",g_pox02,"'" 
#   END IF
#   #FUN-4C0095(end)
#   CALL cl_wait()
#   CALL cl_outnam('apmi001') RETURNING l_name #FUN-4C0095
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT *  FROM pox_file ",
#             " WHERE ",g_wc CLIPPED
#   PREPARE i001_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i001_curo CURSOR FOR i001_p1
 
#   START REPORT i001_rep TO l_name
 
#   FOREACH i001_curo INTO sr.*   
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       SELECT poz02 INTO sr1.poz02 FROM poz_file
#        WHERE poz01 = sr.pox01
#       SELECT poy03 INTO sr1.poy03 FROM poy_file
#        WHERE poy01 = sr.pox01 AND poy02 = sr.pox04
#       SELECT pmc03 INTO sr1.pmc03 FROM pmc_file
#        WHERE pmc01 = sr1.poy03
#       OUTPUT TO REPORT i001_rep(sr.*,sr1.*)
#   END FOREACH
 
#   FINISH REPORT i001_rep
 
#   CLOSE i001_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i001_rep(sr,sr1)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,                 #No.FUN-680136
#       sr RECORD LIKE pox_file.*,
#       sr1 RECORD     
#            poz02    LIKE poz_file.poz02,
#            poy03    LIKE poy_file.poy03,
#            pmc03    LIKE pmc_file.pmc03
#           END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pox01,sr1.poz02,sr.pox02,sr.pox04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
##          PRINT              #TQC-6A0090
#           PRINT g_dash
#           LET l_trailer_sw = 'n'   #TQC-6A0090 add
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#           PRINT g_dash1 
 
#       BEFORE GROUP OF sr.pox02
#           PRINT COLUMN g_c[31],sr.pox01,
#                 COLUMN g_c[32],sr1.poz02,
#                 COLUMN g_c[33],sr.pox02;
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[34],sr1.poy03,
#                 COLUMN g_c[35],sr1.pmc03,
#                 COLUMN g_c[36],sr.pox05,
#                 COLUMN g_c[37],sr.pox06 USING '###.##&'
 
#       ON LAST ROW
#           PRINT g_dash
#  #        PRINT g_x[4] CLIPPED,COLUMN g_c[37],g_x[7] CLIPPED  #TQC-6A0090 
#           PRINT g_x[4] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED  #TQC-6A0090 
#       #   LET l_trailer_sw = 'n'  #TQC-6A0090 
#           LET l_trailer_sw = 'y'  #TQC-6A0090 
 
#       PAGE TRAILER
#       #   IF l_trailer_sw = 'y' THEN   #TQC-6A0090 
#           IF l_trailer_sw = 'n' THEN   #TQC-6A0090 
#               PRINT g_dash
#          #    PRINT g_x[4] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED   #TQC-6A0090 
#               PRINT g_x[4] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED  #TQC-6A0090
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043 --END MARK--
 
