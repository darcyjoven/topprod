# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: apsi311.4gl
# Descriptions...: APS 鎖定製程時間維護   #FUN-850114
# Create.........: NO.FUN-840209 08/05/15 BY DUKE 依參數傳遞判斷製令編號,途程編號,加工序號,作業編號是否允許輸入
# Modify.........: NO.FUN-870027 08/07/03 BY DUKE 
# Modify.........: NO.TQC-890030 08/09/05 By Mandy sfb04 = '8',sfb87 = 'X',sfb87 = 'Y'時,不可做修改
# Modify.........: NO.FUN-960054 09/06/16 By Duke APS整合CP調整
# Modify.........: NO.FUN-960039 09/08/28 By Mandy 程式重過至正式區
# Modify.........: NO.FUN-9B0123 09/12/04 By Mandy vnd06,vnd07,vnd08 的控管
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.......... No.FUN-A70036 10/08/11 By Mandy aeci700/apsi315點選"APS鎖定製程時間"按鈕時,若鎖定碼(vnd06)沒有設定(vnd06=0),則不insert資料至vnd_file
# Modify.........: No.FUN-B50101 11/05/16 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BA0024 11/10/27 By Abby 不控卡已確認(sfb87 = 'Y')

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-850114
DEFINE
    g_sfb           RECORD LIKE sfb_file.*,   #TQC-890030
   #FUN-960054 MOD --STR------------------------------------
   #g_vnd           RECORD LIKE vnd_file.*,   
   #g_vnd_t         RECORD LIKE vnd_file.*, 
    g_vnd      RECORD
      vnd01         LIKE vnd_file.vnd01,
      vnd02         LIKE vnd_file.vnd02,
      vnd03         LIKE vnd_file.vnd03,
      vnd04         LIKE vnd_file.vnd04,          
      vnd05         LIKE vnd_file.vnd05,
      vnd06         LIKE vnd_file.vnd06,
      vnd07         DATETIME YEAR TO MINUTE,
      vnd08         DATETIME YEAR TO MINUTE,
      vnd09         LIKE vnd_file.vnd09,
      vnd10         LIKE vnd_file.vnd10,
      vnd11         LIKE vnd_file.vnd11,
      vndlegal      LIKE vnd_file.vndlegal, #FUN-B50101 add
      vndplant      LIKE vnd_file.vndplant, #FUN-B50101 add
      vnd012        LIKE vnd_file.vnd012    #FUN-B50101 add
      END           RECORD,
    g_vnd_t    RECORD
      vnd01         LIKE vnd_file.vnd01,
      vnd02         LIKE vnd_file.vnd02,
      vnd03         LIKE vnd_file.vnd03,
      vnd04         LIKE vnd_file.vnd04,
      vnd05         LIKE vnd_file.vnd05,
      vnd06         LIKE vnd_file.vnd06,
      vnd07         DATETIME YEAR TO MINUTE,
      vnd08         DATETIME YEAR TO MINUTE,
      vnd09         LIKE vnd_file.vnd09,
      vnd10         LIKE vnd_file.vnd10,
      vnd11         LIKE vnd_file.vnd11,
      vndlegal      LIKE vnd_file.vndlegal, #FUN-B50101 add
      vndplant      LIKE vnd_file.vndplant, #FUN-B50101 add
      vnd012        LIKE vnd_file.vnd012    #FUN-B50101 add
      END           RECORD,
   #FUN-960054 MOD --STR------------------------------------

    g_vnd01         LIKE vnd_file.vnd01,      #
    g_vnd02         LIKE vnd_file.vnd02,      #
    g_vnd03         LIKE vnd_file.vnd03,      #
    g_vnd04         LIKE vnd_file.vnd04,      #
    g_vnd05         LIKE vnd_file.vnd05,
    g_vnd012        LIKE vnd_file.vnd012,     #FUN-B50101 add
   #g_vnd_rowid     LIKE type_file.chr18, 	 #ROWID   # saki 20070821 rowid chr18 -> num10  #FUN-B50101 mark
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  

DEFINE  g_jump          LIKE type_file.num10         #查詢指定的筆數
DEFINE  mi_no_ask       LIKE type_file.num5          #是否開啟指定筆視窗
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE   g_before_input_done   STRING
DEFINE   l_vnd07,l_vnd08   LIKE type_file.chr20    #FUN-960054 ADD
DEFINE   l_vnd11   INTERVAL SECOND(5) TO SECOND    #FUN-960054 ADD
DEFINE   l_vnd11s       string                     #FUN-960054 ADD
DEFINE   l_ecm52        LIKE ecm_file.ecm52        #FUN-960054 ADD
DEFINE   l_program      LIKE zz_file.zz01          #FUN-960054 ADD

MAIN
    DEFINE l_time       LIKE type_file.chr8   	#計算被使用時間  
    DEFINE p_row,p_col  LIKE type_file.num5    
    DEFINE l_cnt        LIKE type_file.num5     #FUN-A70036 add
    DEFINE l_vmp02      LIKE vmp_file.vmp02     #FUN-A70036 add
    DEFINE l_vme02      LIKE vme_file.vme02     #FUN-A70036 add
    DEFINE l_ecm        RECORD LIKE ecm_file.*  #FUN-A70036 add

    #FUN-B50101---mod---str---
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP				#輸入的方式: 不打轉
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
    #FUN-B50101---mod---end---

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80053--l_time改為g_time--
#    CALL cl_used(g_prog,l_time,1) RETURNING l_time  #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
    INITIALIZE g_vnd.* TO NULL
    INITIALIZE g_vnd_t.* TO NULL

   #FUN-B50101---mod---str---
   #LET g_forupd_sql = "SELECT * FROM vnd_file WHERE ROWID = ? FOR UPDATE NOWAIT"
    LET g_forupd_sql = "SELECT * FROM vnd_file WHERE vnd01 = ? AND vnd02 = ? AND vnd03 = ? AND vnd04 = ? AND vnd05 = ? AND vnd012 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   #FUN-B50101---mod---end---
    DECLARE i311_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR

    LET p_row = 2 LET p_col = 3
    OPEN WINDOW i311_w AT p_row,p_col
      WITH FORM "aps/42f/apsi311"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("vnd012",g_sma.sma541='Y')  #FUN-B50101 add

    LET g_vnd.vnd01  = ARG_VAL(1)
    LET g_vnd.vnd02  = ARG_VAL(2)
    LET g_vnd.vnd03  = ARG_VAL(3)
    LET g_vnd.vnd04  = ARG_VAL(4)
    LET g_vnd.vnd05  = ARG_VAL(5)
    LET l_program    = ARG_VAL(6)   #FUN-960054 ADD
    LET g_vnd.vnd012  = ARG_VAL(7)  #FUN-B50101 add
    LET g_vnd01  = ARG_VAL(1)
    LET g_vnd02  = ARG_VAL(2)
    LET g_vnd03  = ARG_VAL(3)
    LET g_vnd04  = ARG_VAL(4)
    LET g_vnd05  = ARG_VAL(5)
    LET g_vnd012 = ARG_VAL(7) #FUN-B50101 add

    #FUN-9B0123--add---str--
    IF NOT cl_null(l_program) THEN
        SELECT ecm52 
          INTO l_ecm52 
          FROM ecm_file
         WHERE ecm01 = g_vnd.vnd01
           AND ecm03 = g_vnd.vnd03 
           AND ecm012 = g_vnd.vnd012 #FUN-B50101 add
        CALL i311_set_comb()
    END IF
    #FUN-9B0123--add---end--
    #FUN-A70036--add---str--
     SELECT * INTO l_ecm.* FROM ecm_file
      WHERE ecm01 = g_vnd.vnd01
        AND ecm03 = g_vnd.vnd03 
        AND ecm012 = g_vnd.vnd012 #FUN-B50101 add
     IF l_ecm.ecm52 = 'N' THEN
        CALL cl_set_comp_visible("vnd11",FALSE)
     ELSE
        CALL cl_set_comp_visible("vnd11",TRUE)
     END IF
     IF l_program MATCHES '*aeci700*' THEN
         CALL cl_set_comp_visible("vnd05",FALSE)
     ELSE
         CALL cl_set_comp_visible("vnd05",TRUE)
     END IF
     IF l_program MATCHES '*aeci700*' THEN
         IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 0  THEN
            IF NOT cl_null(l_ecm.ecm06) THEN
               LET g_vnd.vnd05 = l_ecm.ecm06
           #FUN-B50101 mark--str---
           #ELSE
           #   SELECT vmp02 INTO l_vmp02
           #     FROM vmp_file
           #    WHERE vmp01 = l_ecm.vmn081
           #   LET g_vnd.vnd05 = l_vmp02
           #FUN-B50101 mark--end---
            END IF
         ELSE
            IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 1  THEN
               IF NOT cl_null(l_ecm.ecm05) THEN
                  LET g_vnd.vnd05 = l_ecm.ecm05
              #FUN-B50101 mark--str---
              #ELSE
              #   SELECT vme02 INTO l_vme02
              #     FROM vme_file
              #    WHERE vme01 = l_ecm.vmn08
              #   LET g_vnd.vnd05 = l_vme02
              #FUN-B50101 mark--end---
               END IF
            END IF
         END IF
         ##外包時 ecm52='Y'時, vnd05 塞一個空白
         IF l_ecm.ecm52 = 'Y' THEN 
            LET g_vnd.vnd05 =' ' 
         END IF
     END IF
    #FUN-A70036--add---end--

    IF NOT (cl_null(g_vnd.vnd01) AND cl_null(g_vnd.vnd02) AND cl_null(g_vnd.vnd03)
      #AND cl_null(g_vnd.vnd04) AND cl_null(g_vnd.vnd05) AND cl_null(l_program))   #FUN-960054 ADD l_program #FUN-A70036 mark
       AND cl_null(g_vnd.vnd04)                          AND cl_null(l_program))                             #FUN-A70036 add
       THEN LET g_flag = 'Y'
           #CALL i311_q() #FUN-A70036 mark
           #FUN-A70036--add----str---
            IF l_program MATCHES '*aeci700*' THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vnd_file
                 WHERE vnd01 = g_vnd.vnd01
                   AND vnd02 = g_vnd.vnd02
                   AND vnd03 = g_vnd.vnd03
                   AND vnd04 = g_vnd.vnd04
            ELSE
                SELECT COUNT(*) INTO l_cnt
                  FROM vnd_file
                 WHERE vnd01 = g_vnd.vnd01
                   AND vnd02 = g_vnd.vnd02
                   AND vnd03 = g_vnd.vnd03
                   AND vnd04 = g_vnd.vnd04
                   AND vnd05 = g_vnd.vnd05
                   AND vnd012 = g_vnd.vnd012 #FUN-B50101 add
            END IF
            IF l_cnt >= 1 THEN
                CALL i311_q()
            ELSE
                CALL i311_a()
            END IF
           #FUN-A70036--add----end---
       #     CALL i311_u()  #FUN-870027
       ELSE 
           LET g_flag = 'N'
    END IF

    WHILE TRUE
      LET g_action_choice=""
      CALL i311_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW i311_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--l_time改為g_time--
#      CALL cl_used(g_prog,l_time,2) RETURNING l_time #No:MOD-580088  HCN 20050818
END MAIN

FUNCTION i311_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       #FUN-840209----Modify------------- 
       LET g_wc = " vnd01='",g_vnd.vnd01,"'",
                  "  AND vnd02 ='",g_vnd.vnd02,"'",
                  "  AND vnd03 ='",g_vnd.vnd03,"'",
                  "  AND vnd04 ='",g_vnd.vnd04,"'",
                  "  AND vnd012 ='",g_vnd.vnd012,"'" #FUN-B50101 add
       #FUN-960054 MOD --STR--------------
       IF l_program = 'apsi315' THEN 
          LET g_wc = g_wc, "  AND vnd05 ='",g_vnd.vnd05,"'"   
       END IF
       #FUN-960054 MOD --END--------------
    ELSE
   INITIALIZE g_vnd.* TO NULL    
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
          vnd01,
          vnd02,
          vnd03, 
          vnd04,
          vnd05,
          vnd012, #FUN-B50101 add
          vnd06,
          vnd07,
          vnd08,
          vnd09,
          vnd10

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
    END IF
    IF INT_FLAG THEN RETURN END IF

   #LET g_sql = "SELECT ROWID,vnd01,vnd02,vnd03,vnd04,vnd05 FROM vnd_file ",        # 組合出 SQL 指令 #FUN-B50101 mark
    LET g_sql = "SELECT       vnd01,vnd02,vnd03,vnd04,vnd05,vnd012 FROM vnd_file ", # 組合出 SQL 指令 #FUN-B50101 add
        " WHERE ",g_wc CLIPPED, " ORDER BY vnd01,vnd02,vnd03,vnd04,vnd05,vnd012"                      #FUN-B50101 add vnd012
    PREPARE i311_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i311_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i311_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vnd_file WHERE ",g_wc CLIPPED
    PREPARE i311_precount FROM g_sql
    DECLARE i311_count CURSOR FOR i311_precount
END FUNCTION

FUNCTION i311_menu()
    MENU ""

        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
           #FUN-960054 ADD --STR---------------------------------
            SELECT ecm52 INTO l_ecm52 FROM ecm_file
             WHERE ecm01 = g_vnd.vnd01
               AND ecm03 = g_vnd.vnd03 
               AND ecm012 = g_vnd.vnd012 #FUN-B50101 add
            IF l_ecm52 = 'N' THEN
               CALL cl_set_comp_visible("vnd11",FALSE)
            ELSE
               CALL cl_set_comp_visible("vnd11",TRUE)
            END IF
           #FUN-960054 ADD --END--------------------------------- 

        #FUN-840209----MARK----begin---        
        #ON ACTION insert
        #    LET g_action_choice="insert"
        #    IF cl_chk_act_auth() THEN
        #       CALL i311_a()
        #       IF g_flag = 'Y' THEN
        #           CALL i311_q()
        #       END IF
        #    END IF
        #FUN-840209---------MARK---------END--------
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i311_q()
           END IF
        ON ACTION next
           CALL i311_fetch('N')
        ON ACTION previous
           CALL i311_fetch('P')

        ON ACTION modify
           CALL i311_u()
#FUN-840209----------MARK---------BEGIN----
#FUN-A70036--unmark--str--
         ON ACTION delete
             LET g_action_choice="delete"
             IF cl_chk_act_auth() THEN
                 CALL i311_r()
             END IF
#FUN-A70036--unmark--end--
#FUN-840209----------MARK---------END-----
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
           #FUN-9B0123---add---str---
           CALL i311_set_comb()
           #FUN-9B0123---add---end---
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     

        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_vnd.vnd01 IS NOT NULL 
                  AND g_vnd.vnd02 IS NOT NULL
                  AND g_vnd.vnd03 IS NOT NULL
                  AND g_vnd.vnd04 IS NOT NULL
                  AND g_vnd.vnd05 IS NOT NULL 
                  AND g_vnd.vnd012 IS NOT NULL THEN #FUN-B50101 add
                  LET g_doc.column1 = "vnd01"
                  LET g_doc.value1 = g_vnd.vnd01
                  LET g_doc.column2 = "vnd02"
                  LET g_doc.value2 = g_vnd.vnd02
                  LET g_doc.column3 = "vnd03"
                  LET g_doc.value3 = g_vnd.vnd03
                  LET g_doc.column4 = "vnd04"
                  LET g_doc.value4 = g_vnd.vnd04
                  LET g_doc.column5 = "vnd05"
                  LET g_doc.value5 = g_vnd.vnd05
                  CALL cl_doc()
               END IF
           END IF
           LET g_action_choice = "exit"
           CONTINUE MENU

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i311_cs
END FUNCTION

FUNCTION i311_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    #FUN-840209---------Modify-------start------
    IF g_flag='N' then
      CLEAR FORM                                   # 清螢墓欄位內容
      INITIALIZE g_vnd.* LIKE vnd_file.*
      LET g_vnd.vnd01 = NULL
      LET g_vnd.vnd02 = NULL
      LET g_vnd.vnd03 = NULL
      LET g_vnd.vnd04 = NULL
      LET g_vnd.vnd05 = NULL
      LET g_vnd.vnd012 = NULL #FUN-B50101 add
      LET g_vnd.vnd06 = NULL
      LET g_vnd.vnd07 = NULL
      LET g_vnd.vnd08 = NULL
      LET g_vnd.vnd09 = NULL
      LET g_vnd.vnd10 = NULL
    ELSE
      LET g_vnd.vnd01 = g_vnd01
      LET g_vnd.vnd02 = g_vnd02
      LET g_vnd.vnd03 = g_vnd03
      LET g_vnd.vnd04 = g_vnd04
      LET g_vnd.vnd05 = g_vnd05
      LET g_vnd.vnd012 = g_vnd012 #FUN-B50101 add
     #FUN-A70036--mark--str---
     #LET g_vnd.vnd06 = NULL
     #LET g_vnd.vnd07 = NULL
     #LET g_vnd.vnd08 = NULL
     #LET g_vnd.vnd09 = NULL
     #LET g_vnd.vnd10 = NULL
     #FUN-A70036--mark--end---
     #FUN-A70036--add---str---
      LET g_vnd.vnd06 = 0
      LET g_vnd.vnd07 = NULL
      LET g_vnd.vnd08 = NULL
      LET g_vnd.vnd09 = 0
      IF l_program MATCHES '*aeci700*' THEN
          LET g_vnd.vnd10 = 0
      ELSE
          LET g_vnd.vnd10 = 1
      END IF
      LET g_vnd.vnd11 = 0 
     #FUN-A70036--add---end---

    END IF
    #FUN-840209--------Modify---------end--------

    LET g_vnd_t.*=g_vnd.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i311_i("a")                         #各欄位輸入
        #FUN-840209------Modify-----begin-----
        IF INT_FLAG THEN                         #若按了DEL鍵
            IF g_flag='N' THEN
               INITIALIZE g_vnd.* TO NULL
               LET INT_FLAG = 0
               CALL cl_err('',9001,0)
               CLEAR FORM
            ELSE
               LET INT_FLAG = 0
               CALL cl_err('',9001,0)
               LET g_vnd.vnd06 = NULL
               LET g_vnd.vnd07 = NULL
               LET g_vnd.vnd08 = NULL
               LET g_vnd.vnd09 = NULL
               LET g_vnd.vnd10 = NULL

            END IF 
            EXIT WHILE
        END IF
        #FUN-840209--------Modify--------end-----
        IF g_vnd.vnd01 IS NULL OR
           g_vnd.vnd02 IS NULL OR
           g_vnd.vnd03 IS NULL OR
           g_vnd.vnd04 IS NULL OR
           g_vnd.vnd05 IS NULL OR 
           g_vnd.vnd012 IS NULL THEN                # KEY 不可空白 #FUN-B50101 add
            CONTINUE WHILE
        END IF
        #FUN-960054 MOD --STR------------------------------------
        #INSERT INTO vnd_file VALUES(g_vnd.*)       # DISK WRITE
       #FUN-A70036--mark---str---
       #CASE
       #   WHEN g_vnd.vnd06 = 0 
       #        INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd09,vnd10,vnd11)
       #          VALUES(g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd06,g_vnd.vnd09,g_vnd.vnd10,g_vnd.vnd11)
       #   WHEN g_vnd.vnd06 = 1
       #        INSERT INTO vld_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd09,vnd10,vnd11)
       #          VALUES(g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd06,g_vnd.vnd07,g_vnd.vnd09,g_vnd.vnd10,g_vnd.vnd11)
       #   WHEN g_vnd.vnd06 = 2
       #        INSERT INTO vld_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd08,vvnd09,vnd10,vnd11)
       #          VALUES(g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd06,g_vnd.vnd08,g_vnd.vnd09,g_vnd.vnd10,g_vnd.vnd11)
       #   WHEN g_vnd.vnd06 = 3
       #        INSERT INTO vld_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11)
       #          VALUES(g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd06,g_vnd.vnd07,g_vnd.vnd08,g_vnd.vnd09,g_vnd.vnd10,g_vnd.vnd11)
       #END CASE
       #FUN-A70036--mark---end---
       #FUN-A70036--add----str---
                INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd012,vnd06,vnd09,vnd10,vnd11)                                                 #FUN-B50101 add vnd012
                  VALUES(g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012,g_vnd.vnd06,g_vnd.vnd09,g_vnd.vnd10,g_vnd.vnd11) #FUN-B50101 add vnd012
       #FUN-A70036--add----end---
        #FUN-960054 MOD --END------------------------------------ 

        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vnd_file",g_vnd.vnd01,"",SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
        ELSE
            LET g_vnd_t.* = g_vnd.*                # 保存上筆資料
        #FUN-A70036--unmark---str--
            #FUN-B50101 mark---str---
            #SELECT ROWID INTO g_vnd_rowid FROM vnd_file 
            #    WHERE vnd01 = g_vnd.vnd01
            #      AND vnd02 = g_vnd.vnd02
            #      AND vnd03 = g_vnd.vnd03
            #      AND vnd04 = g_vnd.vnd04
            #      AND vnd05 = g_vnd.vnd05
            #FUN-B50101 mark---end---
        #FUN-A70036--unmark---end--
        END IF
        #FUN-A70036--add----str---
         IF l_vnd07[1,4] != '0000' THEN 
            UPDATE vnd_file SET vnd_file.vnd07 = g_vnd.vnd07
            #FUN-B50101--mod---str---
            #WHERE ROWID = g_vnd_rowid
             WHERE vnd01 = g_vnd.vnd01
               AND vnd02 = g_vnd.vnd02
               AND vnd03 = g_vnd.vnd03
               AND vnd04 = g_vnd.vnd04
               AND vnd05 = g_vnd.vnd05
               AND vnd012 = g_vnd.vnd012             
            #FUN-B50101--mod---end---
         END IF
         IF l_vnd08[1,4] != '0000' THEN
            UPDATE vnd_file SET vnd_file.vnd08 = g_vnd.vnd08
            #FUN-B50101--mod---str---
            #WHERE ROWID = g_vnd_rowid
             WHERE vnd01 = g_vnd.vnd01
               AND vnd02 = g_vnd.vnd02
               AND vnd03 = g_vnd.vnd03
               AND vnd04 = g_vnd.vnd04
               AND vnd05 = g_vnd.vnd05
               AND vnd012 = g_vnd.vnd012             
            #FUN-B50101--mod---end---
         END IF
        #FUN-A70036--add----end---
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i311_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    # VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    # SMALLINT

    DISPLAY BY NAME 
        g_vnd.vnd01,
        g_vnd.vnd02,
        g_vnd.vnd03,
        g_vnd.vnd04,
        g_vnd.vnd05,
        g_vnd.vnd012, #FUN-B50101 add vnd012
        g_vnd.vnd06,
        g_vnd.vnd07,
        g_vnd.vnd08,
        g_vnd.vnd09,
        g_vnd.vnd10,
        g_vnd.vnd11  #FUN-960054 ADD
    INPUT BY NAME   
        g_vnd.vnd01,
        g_vnd.vnd02,
        g_vnd.vnd03,
        g_vnd.vnd04,
        g_vnd.vnd05,
        g_vnd.vnd012, #FUN-B50101 add vnd012
        g_vnd.vnd06,
        g_vnd.vnd07,
        g_vnd.vnd08,
        g_vnd.vnd09,
        g_vnd.vnd10,
        g_vnd.vnd11  #FUN-960054 ADD
        WITHOUT DEFAULTS

    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i311_set_entry(p_cmd)
        CALL i311_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE

      #FUN-960054 ADD --STR--------------------------
      ON CHANGE vnd06
         LET g_vnd.vnd09 = 0
         DISPLAY BY NAME g_vnd.vnd09 
         IF g_vnd.vnd06 = 1 THEN
            CALL cl_set_comp_required("vnd07",TRUE)
            CALL cl_set_comp_required("vnd08",FALSE)
         ELSE
            IF g_vnd.vnd06 = 2 THEN
               CALL cl_set_comp_required("vnd07",FALSE)
               CALL cl_set_comp_required("vnd08",TRUE)
            ELSE
               IF g_vnd.vnd06 = 3  THEN
                  CALL cl_set_comp_required("vnd07,vnd08",TRUE)
               ELSE
                  CALL cl_set_comp_required("vnd07,vnd08",FALSE)
               END IF
            END IF
         END IF 
         CALL i311_set_entry(p_cmd)    #FUN-9B0123 add
         CALL i311_set_no_entry(p_cmd) #FUN-9B0123 add
      ON CHANGE vnd05
         LET g_vnd.vnd09 = 0
         DISPLAY BY NAME g_vnd.vnd09

      ON CHANGE vnd07
         LET g_vnd.vnd09 = 0
         DISPLAY BY NAME g_vnd.vnd09
     
      ON CHANGE vnd08
         LET g_vnd.vnd09 = 0
         DISPLAY BY NAME g_vnd.vnd09
 
      ON CHANGE vnd11
         LET g_vnd.vnd09 = 0
         DISPLAY BY NAME g_vnd.vnd09
      #FUN-9B0123--add---str---
      BEFORE FIELD vnd06
      CALL i311_set_entry(p_cmd)
      #FUN-9B0123--add---end---

      BEFORE FIELD vnd07
      ##由於日期格式不接收NULL值,故以 0000-01-01 00:00 為預設來取代NULL值,
      ##存檔時若欄位值為 0000-01-01 00:00 則視為空值不存檔
          IF cl_null(g_vnd.vnd07) THEN
             LET g_vnd.vnd07 = '0000-01-01 00:00'
             DISPLAY BY NAME g_vnd.vnd07
             LET l_vnd07 = '0000-01-01 00:00'
          END IF           
      BEFORE FIELD vnd08
      ##由於日期格式不接收NULL值,故以0000-01-01 00:00為預設來取代NULL值,
      ##存檔時若欄位值為 0000-01-01 00:00 則視為空值不存檔
          IF cl_null(g_vnd.vnd08) THEN
             LET g_vnd.vnd08 = '0000-01-01 00:00'
             DISPLAY BY NAME g_vnd.vnd08
             LET l_vnd08 = '0000-01-01 00:00'
          END IF

      AFTER FIELD vnd06
          IF g_vnd.vnd05=' ' AND g_vnd.vnd06 NOT MATCHES '[03]' THEN
             CALL cl_err('','aps-763',1)
             NEXT FIELD vnd06
          END IF 
          #FUN-9B0123---add----str----
          IF g_vnd.vnd06 = 1 THEN
             CALL cl_set_comp_required("vnd07",TRUE)
             CALL cl_set_comp_required("vnd08",FALSE)
          ELSE
             IF g_vnd.vnd06 = 2 THEN
                CALL cl_set_comp_required("vnd07",FALSE)
                CALL cl_set_comp_required("vnd08",TRUE)
             ELSE
                IF g_vnd.vnd06 = 3  THEN
                   CALL cl_set_comp_required("vnd07,vnd08",TRUE)
                ELSE
                   CALL cl_set_comp_required("vnd07,vnd08",FALSE)
                END IF
             END IF
          END IF 
          CALL i311_set_no_entry(p_cmd) 
          #FUN-9B0123---add----end----
               
      #FUN-960054 ADD --END--------------------------

      AFTER FIELD vnd07
          #FUN-960054 ADD --STR------------------------
           LET l_vnd07 = g_vnd.vnd07
           IF (cl_null(g_vnd.vnd07) OR (l_vnd07[1,4]='0000')) AND 
              (g_vnd.vnd06 = 1 OR g_vnd.vnd06 = 3)  THEN
              CALL cl_err('','aap-099',1) 
              NEXT FIELD vnd07
           END IF
           IF l_vnd07[1,4]='0000' AND g_vnd.vnd06 NOT MATCHES '[13]' THEN
              LET g_vnd.vnd07 = NULL
              DISPLAY BY NAME g_vnd.vnd07
           END IF
          #FUN-960054 ADD --END------------------------            
           IF (NOT cl_null(g_vnd.vnd07)) and (NOT cl_null(g_vnd.vnd08)) AND
              (g_vnd.vnd06 = 0 OR g_vnd.vnd06 = 3)  THEN   #FUN-960054 ADD
               IF g_vnd.vnd07 > g_vnd.vnd08  THEN
                   CALL cl_err('','aap-100',0)
                   NEXT FIELD vnd07
                END IF
           END IF
          #FUN-960054 ADD --STR------------------------
           IF l_vnd07[1,4]='0000' OR l_vnd08[1,4]='0000' THEN
              LET g_vnd.vnd11 = 0
           ELSE
              LET l_vnd11 = (g_vnd.vnd08-g_vnd.vnd07) 
              LET l_vnd11s = l_vnd11
              LET g_vnd.vnd11 = l_vnd11s
              IF g_vnd.vnd11 < 0 THEN
                 CALL cl_err('','aap-100',0)
                 LET g_vnd.vnd11 = 0
                 NEXT FIELD vnd07
              END IF  
              DISPLAY BY NAME g_vnd.vnd11
           END IF
          #FUN-960054 ADD --END------------------------


      AFTER FIELD vnd08
          #FUN-960054 ADD --STR------------------------
           LET l_vnd08 = g_vnd.vnd08
           IF (cl_null(g_vnd.vnd08) OR (l_vnd08[1,4]='0000')) AND 
              (g_vnd.vnd06 = 2 OR g_vnd.vnd06 = 3)  THEN
              CALL cl_err('','aap-099',1)
              NEXT FIELD vnd08
           END IF
           IF l_vnd08[1,4]='0000' AND g_vnd.vnd06 NOT MATCHES '[23]' THEN
              LET g_vnd.vnd08 = NULL
              DISPLAY BY NAME g_vnd.vnd08
           END IF
          #FUN-960054 ADD --END------------------------
          IF (NOT cl_null(g_vnd.vnd07)) and (NOT cl_null(g_vnd.vnd08)) AND
             (g_vnd.vnd06 = 3 OR g_vnd.vnd06 = 0) THEN   #FUN-960054 ADD
              IF g_vnd.vnd07 > g_vnd.vnd08  THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD vnd08
              END IF
          END IF
         #FUN-960054 ADD --STR------------------------
          IF l_vnd07[1,4]='0000' OR l_vnd08[1,4]='0000' THEN
             LET g_vnd.vnd11 = 0
          ELSE
             LET l_vnd11 = (g_vnd.vnd08-g_vnd.vnd07) 
             LET l_vnd11s = l_vnd11
             LET g_vnd.vnd11 = l_vnd11s
             IF g_vnd.vnd11<0THEN
                CALL cl_err('','aap-100',0)
                LET g_vnd.vnd11 = 0
                NEXT FIELD vnd07
             END IF
             DISPLAY BY NAME g_vnd.vnd11
          END IF
         #FUN-960054 ADD --END------------------------

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
    END INPUT
END FUNCTION
 
FUNCTION i311_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i311_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vnd.* TO NULL
        RETURN
    END IF
    OPEN i311_count
    FETCH i311_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i311_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnd.vnd01,SQLCA.sqlcode,0)
        INITIALIZE g_vnd.* TO NULL
    ELSE
        CALL i311_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i311_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   # VARCHAR(1),
        l_abso          LIKE type_file.num10   # INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     i311_cs INTO g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 拿掉rowid,add vnd012
        WHEN 'P' FETCH PREVIOUS i311_cs INTO g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 拿掉rowid,add vnd012
        WHEN 'F' FETCH FIRST    i311_cs INTO g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 拿掉rowid,add vnd012
        WHEN 'L' FETCH LAST     i311_cs INTO g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 拿掉rowid,add vnd012
        WHEN '/'
        #FUN-840209----MARK----BEGIN----
        #    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
        #    LET INT_FLAG = 0  ######add for prompt bug
        #    PROMPT g_msg CLIPPED,': ' FOR l_abso
        #       ON IDLE g_idle_seconds
        #          CALL cl_on_idle()
        #
        #       ON ACTION about         
        #          CALL cl_about()      
        #       
        #       ON ACTION help          
        #          CALL cl_show_help()  
        #       
        #       ON ACTION controlg      
        #          CALL cl_cmdask()     
        #    END PROMPT
        #    IF INT_FLAG THEN
        #        LET INT_FLAG = 0
        #        EXIT CASE
        #    END IF
        #FUN-840209--------MARK----------END--------

        #FUN-840209--------ADD-----------BEGIN-----
           IF (NOT mi_no_ask) THEN                   
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
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
        #FUN-840209--------ADD-----------END-------

            FETCH ABSOLUTE g_jump i311_cs INTO g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 拿掉rowid,add vnd012
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        LET g_msg = g_vnd.vnd01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vnd.* TO NULL          
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

    #FUN-B50101--mod---str---
    SELECT * 
      INTO g_vnd.* FROM vnd_file            # 重讀DB,因TEMP有不被更新特性
       #WHERE ROWID = g_vnd_rowid
        WHERE vnd01 = g_vnd.vnd01
          AND vnd02 = g_vnd.vnd02
          AND vnd03 = g_vnd.vnd03
          AND vnd04 = g_vnd.vnd04
          AND vnd05 = g_vnd.vnd05
          AND vnd012 = g_vnd.vnd012             
    #FUN-B50101--mod---end---

    IF SQLCA.sqlcode THEN
        LET g_msg = g_vnd.vnd01 CLIPPED
         CALL cl_err3("sel","vnd_file",g_vnd.vnd01,"",SQLCA.sqlcode,"","",1) 
         INITIALIZE g_vnd.* TO NULL       
    ELSE
        CALL i311_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i311_show()
    LET g_vnd_t.* = g_vnd.*
    LET l_vnd07 = g_vnd.vnd07  #FUN-960054 ADD
    LET l_vnd08 = g_vnd.vnd08  #FUN-960054 ADD
    DISPLAY BY NAME 
        g_vnd.vnd01,
        g_vnd.vnd02,
        g_vnd.vnd03,
        g_vnd.vnd04,
        g_vnd.vnd05,
        g_vnd.vnd012, #FUN-B50101 add
        g_vnd.vnd06,
        g_vnd.vnd07,
        g_vnd.vnd08,
        g_vnd.vnd09,
        g_vnd.vnd10,
        g_vnd.vnd11  #FUN-960054 ADD
   CALL cl_show_fld_cont() 
                 
   #FUN-960054 ADD --STR-----------------
    IF g_vnd.vnd05 =' ' THEN
       CALL cl_set_comp_entry("vnd11",TRUE)
       CALL cl_set_comp_required("vnd11",TRUE)
    ELSE
       CALL cl_set_comp_entry("vnd11",FALSE)
       CALL cl_set_comp_required("vnd11",FALSE)
    END IF
    IF g_vnd.vnd10 = '0' THEN
       CALL cl_set_comp_visible("vnd05",FALSE)
    ELSE
       CALL cl_set_comp_visible("vnd05",TRUE)
    END IF
   #FUN-960054 ADD --END-----------------
 
END FUNCTION

FUNCTION i311_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnd.vnd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #TQC-890030---add---str---
    LET g_sfb.sfb87 = NULL   #FUN-960054 ADD
    SELECT * INTO g_sfb.*
      FROM sfb_file
     WHERE sfb01 = g_vnd.vnd01
    IF g_sfb.sfb04 = '8' THEN CALL cl_err('','aap-730',1) RETURN END IF
   #IF g_sfb.sfb87 = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF #FUN-BA0024 mark
    IF g_sfb.sfb87 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
    #TQC-890030---add---end---
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vnd01 = g_vnd.vnd01 
    BEGIN WORK

   #OPEN i311_cl USING g_vnd_rowid                                                              #FUN-B50101 mark
    OPEN i311_cl USING g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 add
    IF STATUS THEN
       CALL cl_err("OPEN i311_cl:", STATUS, 1)
       CLOSE i311_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i311_cl INTO g_vnd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnd.vnd01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i311_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i311_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vnd.* = g_vnd_t.*
            CALL i311_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        #FUN-960054 MOD --STR------------------------------------
        #UPDATE vnd_file SET vnd_file.* = g_vnd.*    # 更新DB
        #    WHERE ROWID = g_vnd_rowid               # COLAUTH?
         UPDATE vnd_file SET vnd_file.vnd01=g_vnd.vnd01,vnd_file.vnd02=g_vnd.vnd02,
                             vnd_file.vnd03=g_vnd.vnd03,vnd_file.vnd04=g_vnd.vnd04,
                             vnd_file.vnd05=g_vnd.vnd05,vnd_file.vnd012=g_vnd.vnd012,vnd_file.vnd06=g_vnd.vnd06, #FUN-B50101 add vnd012
                             vnd_file.vnd09=g_vnd.vnd09,vnd_file.vnd10=g_vnd.vnd10,
                             vnd_file.vnd11=g_vnd.vnd11
           #FUN-B50101--mod---str---
           #WHERE ROWID = g_vnd_rowid
            WHERE vnd01 = g_vnd.vnd01
              AND vnd02 = g_vnd.vnd02
              AND vnd03 = g_vnd.vnd03
              AND vnd04 = g_vnd.vnd04
              AND vnd05 = g_vnd.vnd05
              AND vnd012 = g_vnd.vnd012             
           #FUN-B50101--mod---end---
         IF l_vnd07[1,4] != '0000' THEN 
            UPDATE vnd_file SET vnd_file.vnd07 = g_vnd.vnd07
            #FUN-B50101--mod---str---
            #WHERE ROWID = g_vnd_rowid
             WHERE vnd01 = g_vnd.vnd01
               AND vnd02 = g_vnd.vnd02
               AND vnd03 = g_vnd.vnd03
               AND vnd04 = g_vnd.vnd04
               AND vnd05 = g_vnd.vnd05
               AND vnd012 = g_vnd.vnd012             
            #FUN-B50101--mod---end---
         END IF
         IF l_vnd08[1,4] != '0000' THEN
            UPDATE vnd_file SET vnd_file.vnd08 = g_vnd.vnd08
            #FUN-B50101--mod---str---
            #WHERE ROWID = g_vnd_rowid
             WHERE vnd01 = g_vnd.vnd01
               AND vnd02 = g_vnd.vnd02
               AND vnd03 = g_vnd.vnd03
               AND vnd04 = g_vnd.vnd04
               AND vnd05 = g_vnd.vnd05
               AND vnd012 = g_vnd.vnd012             
            #FUN-B50101--mod---end---
         END IF
        #FUN-960054 MOD --END------------------------------------ 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vnd.vnd01 CLIPPED
            CALL cl_err3("upd","vnd_file",g_vnd01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        ELSE
            LET g_vnd_t.* = g_vnd.*# 保存上筆資料
           #FUN-B50101---mark---str---
           #SELECT ROWID INTO g_vnd_rowid FROM vnd_file 
           # WHERE vnd01 = g_vnd.vnd01
           #   AND vnd02 = g_vnd.vnd02
           #   AND vnd03 = g_vnd.vnd03
           #   AND vnd04 = g_vnd.vnd04
           #   AND vnd05 = g_vnd.vnd05
           #FUN-B50101---mark---end---
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i311_cl
    COMMIT WORK
END FUNCTION

FUNCTION i311_r()
    DEFINE
        l_chr LIKE type_file.chr1   #  VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnd.vnd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

   #OPEN i311_cl USING g_vnd_rowid                                                              #FUN-B50101 mark
    OPEN i311_cl USING g_vnd.vnd01,g_vnd.vnd02,g_vnd.vnd03,g_vnd.vnd04,g_vnd.vnd05,g_vnd.vnd012 #FUN-B50101 add
    IF STATUS THEN
       CALL cl_err("OPEN i311_cl:", STATUS, 1)
       CLOSE i311_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i311_cl INTO g_vnd.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnd.vnd01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i311_show()
    #FUN-840209--------begin-----
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vnd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vnd.vnd01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vnd02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vnd.vnd02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "vnd03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_vnd.vnd03      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "vnd04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_vnd.vnd04      #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "vnd05"         #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_vnd.vnd05      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       #     DELETE FROM vnd_file WHERE ROWID = g_vnd_rowid
       #     CLEAR FORM

      DELETE FROM vnd_file WHERE vnd01= g_vnd.vnd01  
                             AND vnd02=g_vnd.vnd02
                             AND vnd03=g_vnd.vnd03 
                             AND vnd04=g_vnd.vnd04
                             AND vnd05=g_vnd.vnd05
                             AND vnd012=g_vnd.vnd012 #FUN-B50101 add
      CLEAR FORM
      OPEN i311_count
      FETCH i311_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i311_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i311_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE                 
         CALL i311_fetch('/')
      END IF
    END IF
    #FUN-840209----------------end--------------
    CLOSE i311_cl
   #FUN-840209 MODIFY
   #INITIALIZE g_vnd.* TO NULL
    COMMIT WORK
END FUNCTION

FUNCTION i311_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    # VARCHAR(1)

#     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
#        CALL cl_set_comp_entry("vnd01,vnd02,vnd03,vnd04,vnd05",TRUE)
#     END IF

   #FUN-840209----------Modify--------begin--------
   IF g_flag='N' THEN
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("vnd01,vnd02,vnd03,vnd04,vnd05,vnd012",TRUE) #FUN-B50101 add vnd012
      END IF
   ELSE
      CALL cl_set_comp_entry("vnd01,vnd02,vnd03,vnd04,vnd05,vnd012",FALSE)   #FUN-B50101 add vnd012
   END IF
   #FUN-840209---------Modify----------end---------
   #FUN-9B0123--add---str---
   CALL cl_set_comp_entry("vnd07,vnd08",TRUE)
   #FUN-9B0123--add---end---

END FUNCTION

FUNCTION i311_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    # VARCHAR(1)
  IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("vnd01,vnd02,vnd03,vnd04,vnd05,vnd012",FALSE) #FUN-B50101 add vnd012
  END IF
  #FUN-9B0123--add---str---
  CASE g_vnd.vnd06
       WHEN 0
            CALL cl_set_comp_entry("vnd07,vnd08",FALSE)
       WHEN 1
            CALL cl_set_comp_entry("vnd08",FALSE)
       WHEN 2
            CALL cl_set_comp_entry("vnd07",FALSE)
  END CASE
  #FUN-9B0123--add---end---
END FUNCTION
#NO.FUN-960039

#FUN-9B0123---add---str---
FUNCTION i311_set_comb()
  DEFINE comb_value STRING
  DEFINE comb_item  STRING
 
    IF l_ecm52 = 'N' THEN
        LET comb_value = '1,2,3'
        #1:鎖定開始時間,2:鎖定結束時間,3:鎖定開始時間和結束時間
        CALL cl_getmsg('aps-038',g_lang) RETURNING comb_item
    ELSE
        LET comb_value = '0,3'
        #0:不鎖定時間,3:鎖定開始時間和結束時間
        CALL cl_getmsg('aps-039',g_lang) RETURNING comb_item
    END IF
    CALL cl_set_combo_items('vnd06',comb_value,comb_item)
END FUNCTION
#FUN-9B0123---add---end---
