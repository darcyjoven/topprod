# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axmi640.4gl
# Descriptions...: 佣金資料維護作業
# Date & Author..: 02/11/19 By Maggie
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.TQC-970394 09/07/30 By sherry 無效的資料不可以刪除   
# Modify.........: No.TQC-980270 09/08/27 By lilingyu "比率"所有欄位對負數都沒有控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80249 11/08/31 By lilingyu 點擊action"客戶明細"和"料件基本資料明細"時,若條件不滿足,增加提示訊息
# Modify.........: No.TQC-B80246 11/09/05 By Carrier CONSTRUCT时加入oriu/orig
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-D50066 13/05/13 By qirl 1.查詢一筆資料後，點擊“更改”，再點擊【計算基準】欄位，資料自動保存，重新查詢此筆資料，【計算基準】欄位無資料顯示
#                                                 2.查詢時，傭金編號欄位建議增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofs        RECORD LIKE ofs_file.*,
    g_ofs_t      RECORD LIKE ofs_file.*,
    g_ofs_o      RECORD LIKE ofs_file.*,
    g_ofs01_t           LIKE ofs_file.ofs01,
     g_wc,g_sql         STRING,  #No.FUN-580092 HCN 
    l_cmd               LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE g_cmd            LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE g_buf            LIKE ima_file.ima01     #No.FUN-680137 VARCHAR(40)
 
DEFINE   g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done  STRING          
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_argv1     LIKE ofs_file.ofs01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    INITIALIZE g_ofs.* TO NULL
    INITIALIZE g_ofs_t.* TO NULL
    INITIALIZE g_ofs_o.* TO NULL
 
 
    LET g_forupd_sql = " SELECT * FROM ofs_file WHERE ofs01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i640_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 5 LET p_col = 10
 
    OPEN WINDOW i640_w AT p_row,p_col
        WITH FORM "axm/42f/axmi640"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i640_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i640_a()
            END IF
         OTHERWISE        
            CALL i640_q() 
      END CASE
   END IF
   #--
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i640_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i640_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i640_cs()
    CLEAR FORM
   INITIALIZE g_ofs.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" ofs01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ofs01,ofs02,ofs03,ofs16,ofs17,ofs04,ofs05,
        ofs06,ofs07,ofs08,ofs09,ofs10,
        ofs11,ofs12,ofs13,ofs14,ofs15,
        ofsuser,ofsgrup,ofsoriu,ofsorig,ofsmodu, ofsdate,ofsacti  #No.TQC-B80246
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                              # add---saki
           CASE
              WHEN INFIELD(ofs17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_ofs.ofs17
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofs17
                 NEXT FIELD ofs17
#---TQC-D50066---add---star---
              WHEN INFIELD(ofs01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ofs"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofs01
                 NEXT FIELD ofs01 
#---TQC-D50066---add---end----
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
   END IF  #FUN-7C0050
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ofsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                          #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ofsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ofsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofsuser', 'ofsgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ofs01 FROM ofs_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY ofs01"
    PREPARE i640_prepare FROM g_sql          # RUNTIME 編譯
    DECLARE i640_cs                        # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i640_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ofs_file WHERE ",g_wc CLIPPED
    PREPARE i640_precount FROM g_sql
    DECLARE i640_count CURSOR FOR i640_precount
END FUNCTION
 
FUNCTION i640_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i640_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i640_q()
            END IF
 
        ON ACTION next
           CALL i640_fetch('N')
 
        ON ACTION previous
           CALL i640_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i640_u()
            END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i640_x()
            END IF
           #圖形顯示
           CALL cl_set_field_pic("","","","","",g_ofs.ofsacti)
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i640_r()
            END IF
 
        ON ACTION customer
            IF NOT cl_null(g_ofs.ofs01) AND g_ofs.ofsacti = 'Y' AND
               g_ofs.ofs03 = '2' THEN
               LET l_cmd = 'axmi641 "',g_ofs.ofs01, '"'
               CALL cl_cmdrun(l_cmd CLIPPED)
#TQC-B80249 --begin--
            ELSE
               CALL cl_err('','axm-612',0)
#TQC-B80249 --end--
            END IF
 
        ON ACTION item_detail_maintain
           IF NOT cl_null(g_ofs.ofs01) AND g_ofs.ofsacti = 'Y' AND
              g_ofs.ofs03 = '3' THEN
              LET l_cmd = 'axmi642 "',g_ofs.ofs01, '"'
              CALL cl_cmdrun(l_cmd CLIPPED)
#TQC-B80249 --begin--
            ELSE
               CALL cl_err('','axm-613',0)
#TQC-B80249 --end--
           END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #圖形顯示
           CALL cl_set_field_pic("","","","","",g_ofs.ofsacti)
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i640_fetch('/')
 
        ON ACTION first
           CALL i640_fetch('F')
 
        ON ACTION last
           CALL i640_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_ofs.ofs01 IS NOT NULL THEN
                LET g_doc.column1 = "ofs01"
                LET g_doc.value1 = g_ofs.ofs01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i640_cs
END FUNCTION
 
 
 
FUNCTION i640_a()
    DEFINE l_cmd     LIKE gbc_file.gbc05        #No.FUN-680137 VARCHAR(100)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                    # 清螢幕欄位內容
    INITIALIZE g_ofs.* LIKE ofs_file.*
    LET g_ofs01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ofs.ofs16 = '2'
        LET g_ofs.ofs03 = '1'
        LET g_ofs.ofsacti = 'Y'
        LET g_ofs.ofsuser = g_user
        LET g_ofs.ofsoriu = g_user #FUN-980030
        LET g_ofs.ofsorig = g_grup #FUN-980030
        LET g_ofs.ofsgrup = g_grup
        LET g_ofs.ofsdate = g_today
        LET g_ofs_t.*=g_ofs.*
        CALL i640_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ofs.ofs01 IS NULL THEN               # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ofs_file VALUES(g_ofs.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("ins","ofs_file",g_ofs.ofs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
           CONTINUE WHILE
        ELSE
           SELECT ofs01 INTO g_ofs.ofs01 FROM ofs_file
           WHERE ofs01 = g_ofs.ofs01
        END IF
        CASE g_ofs.ofs03
             WHEN '2'
                IF NOT cl_null(g_ofs.ofs01) AND g_ofs.ofsacti = 'Y' THEN
                   LET l_cmd = 'axmi641 "',g_ofs.ofs01, '"'
                   CALL cl_cmdrun(l_cmd CLIPPED)
                END IF
             WHEN '3'
                IF NOT cl_null(g_ofs.ofs01) AND g_ofs.ofsacti = 'Y' THEN
                   LET l_cmd = 'axmi642 "',g_ofs.ofs01, '" "',
                                g_ofs.ofs02,'"'
                   CALL cl_cmdrun(l_cmd CLIPPED)
                END IF
              OTHERWISE EXIT CASE
        END CASE
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i640_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
	l_chr		LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   INPUT BY NAME g_ofs.ofsoriu,g_ofs.ofsorig,
        g_ofs.ofs01,g_ofs.ofs02,g_ofs.ofs03,g_ofs.ofs16,g_ofs.ofs17,
        g_ofs.ofs04,g_ofs.ofs05,
        g_ofs.ofs06,g_ofs.ofs07,g_ofs.ofs08,g_ofs.ofs09,g_ofs.ofs10,
        g_ofs.ofs11,g_ofs.ofs12,g_ofs.ofs13,g_ofs.ofs14,g_ofs.ofs15,
        g_ofs.ofsuser,g_ofs.ofsgrup,g_ofs.ofsmodu, g_ofs.ofsdate,g_ofs.ofsacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i640_set_entry(p_cmd)
           CALL i640_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ofs01
          IF g_ofs.ofs01 IS NOT NULL THEN
            IF p_cmd = "a"  OR                        # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_ofs.ofs01 != g_ofs_t.ofs01) THEN
               SELECT COUNT(*) INTO l_n FROM ofs_file WHERE ofs01 = g_ofs.ofs01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_ofs.ofs01,-239,0)
                  LET g_ofs.ofs01 = g_ofs_t.ofs01
                  DISPLAY BY NAME g_ofs.ofs01
                  NEXT FIELD ofs01
               END IF
            END IF
          END IF
 
        AFTER FIELD ofs03
	  IF g_ofs.ofs03 NOT MATCHES '[123]'
             THEN NEXT FIELD ofs03
          END IF
#----TQC-D50066---add--star---
         IF p_cmd = "u" THEN
            IF g_ofs.ofs03 MATCHES '[23]' THEN
               LET g_ofs.ofs04 = ''
               LET g_ofs.ofs05 = 0
               LET g_ofs.ofs06 = 0
               LET g_ofs.ofs07 = 0
               LET g_ofs.ofs08 = 0
               LET g_ofs.ofs09 = 0
               LET g_ofs.ofs10 = 0
               LET g_ofs.ofs11 = 0
               LET g_ofs.ofs12 = 0
               LET g_ofs.ofs13 = 0
               LET g_ofs.ofs14 = 0
               LET g_ofs.ofs15 = 0
               DISPLAY BY NAME g_ofs.ofs04,g_ofs.ofs05,g_ofs.ofs06,g_ofs.ofs07,
                               g_ofs.ofs08,g_ofs.ofs09,g_ofs.ofs10,g_ofs.ofs11,
                               g_ofs.ofs12,g_ofs.ofs13,g_ofs.ofs14,g_ofs.ofs15
               CASE g_ofs.ofs03
                    WHEN '2'
                       IF NOT cl_null(g_ofs.ofs01) AND g_ofs.ofsacti = 'Y' THEN
                          LET l_cmd = 'axmi641 "',g_ofs.ofs01, '"'
                          CALL cl_cmdrun(l_cmd CLIPPED)
                       END IF
                    WHEN '3'
                       IF NOT cl_null(g_ofs.ofs01) AND g_ofs.ofsacti = 'Y' THEN
                          LET l_cmd = 'axmi642 "',g_ofs.ofs01, '" "',
                                       g_ofs.ofs02,'"'
                          CALL cl_cmdrun(l_cmd CLIPPED)
                       END IF
                     OTHERWISE EXIT CASE
               END CASE
            END IF
         END IF
#----TQC-D50066---add--end---
 
        BEFORE FIELD ofs04
          IF g_ofs.ofs03 MATCHES '[23]' THEN
             LET g_ofs.ofs04 = ''
             LET g_ofs.ofs05 = 0
             LET g_ofs.ofs06 = 0
             LET g_ofs.ofs07 = 0
             LET g_ofs.ofs08 = 0
             LET g_ofs.ofs09 = 0
             LET g_ofs.ofs10 = 0
             LET g_ofs.ofs11 = 0
             LET g_ofs.ofs12 = 0
             LET g_ofs.ofs13 = 0
             LET g_ofs.ofs14 = 0
             LET g_ofs.ofs15 = 0
             DISPLAY BY NAME g_ofs.ofs04,g_ofs.ofs05,g_ofs.ofs06,g_ofs.ofs07,
                             g_ofs.ofs08,g_ofs.ofs09,g_ofs.ofs10,g_ofs.ofs11,
                             g_ofs.ofs12,g_ofs.ofs13,g_ofs.ofs14,g_ofs.ofs15
             EXIT INPUT	
          END IF
 
        AFTER FIELD ofs04
	  IF g_ofs.ofs04 NOT MATCHES '[1234]' THEN NEXT FIELD ofs04 END IF
#TQC-D50066---add---star--
        IF g_ofs.ofs03 MATCHES '[1]' AND g_ofs.ofs01 IS NOT NULL THEN
          IF g_ofs.ofs04 NOT MATCHES '[1234]' THEN NEXT FIELD ofs04 END IF
        END IF
#TQC-D50066---add---end---
 
#TQC-980270 --begin--
        AFTER FIELD ofs05
          IF NOT cl_null(g_ofs.ofs05) THEN 
             IF g_ofs.ofs05 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs05
             END IF 
          END IF 
 
        AFTER FIELD ofs06
          IF NOT cl_null(g_ofs.ofs06) THEN 
             IF g_ofs.ofs06 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs06
             END IF 
          END IF 
          
        AFTER FIELD ofs07
          IF NOT cl_null(g_ofs.ofs07) THEN 
             IF g_ofs.ofs07 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs07
             END IF 
          END IF 
 
        AFTER FIELD ofs08
          IF NOT cl_null(g_ofs.ofs08) THEN 
             IF g_ofs.ofs08 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs08
             END IF 
          END IF 
 
        AFTER FIELD ofs09
          IF NOT cl_null(g_ofs.ofs09) THEN 
             IF g_ofs.ofs09 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs09
             END IF 
          END IF 
          
        AFTER FIELD ofs10
          IF NOT cl_null(g_ofs.ofs10) THEN 
             IF g_ofs.ofs10 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs10
             END IF 
          END IF 
          
        AFTER FIELD ofs11
          IF NOT cl_null(g_ofs.ofs11) THEN 
             IF g_ofs.ofs11 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs11
             END IF 
          END IF 
          
        AFTER FIELD ofs12
          IF NOT cl_null(g_ofs.ofs12) THEN 
             IF g_ofs.ofs12 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs12
             END IF 
          END IF 
          
        AFTER FIELD ofs13
          IF NOT cl_null(g_ofs.ofs13) THEN 
             IF g_ofs.ofs13 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs13
             END IF 
          END IF 
          
        AFTER FIELD ofs14
          IF NOT cl_null(g_ofs.ofs14) THEN 
             IF g_ofs.ofs14 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs14
             END IF 
          END IF 
 
        AFTER FIELD ofs15
          IF NOT cl_null(g_ofs.ofs15) THEN 
             IF g_ofs.ofs15 < 0 THEN 
                CALL cl_err('','aim-223',0)
                NEXT FIELD ofs15
             END IF 
          END IF                                                                                                                        
#TQC-980270 --end--
 
        AFTER FIELD ofs16
          IF g_ofs.ofs16 NOT MATCHES '[123]' THEN
             NEXT FIELD ofs16
          END IF
          IF g_ofs.ofs16 != '3' THEN
             LET g_ofs.ofs17 = ''
             DISPLAY BY NAME g_ofs.ofs17
          END IF
 
        BEFORE FIELD ofs17
          IF g_ofs.ofs16 != '3' THEN
          END IF
 
        AFTER FIELD ofs17
          IF NOT cl_null(g_ofs.ofs17) THEN
             SELECT azi01 FROM azi_file
              WHERE azi01 = g_ofs.ofs17 AND aziacti = 'Y'
             IF STATUS THEN
#               CALL cl_err(g_ofs.ofs17,'mfg3008',0)    #No.FUN-660167
                CALL cl_err3("sel","azi_file",g_ofs.ofs17,"","mfg3008","","",1)  #No.FUN-660167
                NEXT FIELD ofs17
             END IF
          END IF
 
        AFTER INPUT
           LET g_ofs.ofsuser = s_get_data_owner("ofs_file") #FUN-C10039
           LET g_ofs.ofsgrup = s_get_data_group("ofs_file") #FUN-C10039
#TQC-D50066---add---star--
           IF g_ofs.ofs03 MATCHES '[1]'  AND g_ofs.ofs01 IS NOT NULL THEN
              IF g_ofs.ofs04 IS NULL THEN NEXT FIELD ofs04 END IF
           END IF
#TQC-D50066---add---end---
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp                              # add---saki
           CASE
              WHEN INFIELD(ofs17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_ofs.ofs17
                 CALL cl_create_qry() RETURNING g_ofs.ofs17
#                 CALL FGL_DIALOG_SETBUFFER( g_ofs.ofs17 )
                 DISPLAY BY NAME g_ofs.ofs17
                 NEXT FIELD ofs17
              OTHERWISE
                 EXIT CASE
           END CASE
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i640_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ofs.* TO NULL              #No.FUN-6A0020
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i640_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i640_count
    FETCH i640_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i640_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)
        INITIALIZE g_ofs.* TO NULL
    ELSE
        CALL i640_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i640_fetch(p_flofs)
    DEFINE
        p_flofs        LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1) 
 
    CASE p_flofs
        WHEN 'N' FETCH NEXT     i640_cs INTO g_ofs.ofs01
        WHEN 'P' FETCH PREVIOUS i640_cs INTO g_ofs.ofs01
        WHEN 'F' FETCH FIRST    i640_cs INTO g_ofs.ofs01
        WHEN 'L' FETCH LAST     i640_cs INTO g_ofs.ofs01
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
            FETCH ABSOLUTE g_jump i640_cs INTO g_ofs.ofs01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)
        INITIALIZE g_ofs.* TO NULL  #TQC-6B0105
        LET g_ofs.ofs01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flofs
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofs.* FROM ofs_file             # 重讀DB,因TEMP有不被更新特性
       WHERE ofs01 = g_ofs.ofs01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ofs_file",g_ofs.ofs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofs.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_ofs.ofsuser      #FUN-4C0057
       LET g_data_group = g_ofs.ofsgrup      #FUN-4C0057
       CALL i640_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i640_show()
    LET g_ofs_t.* = g_ofs.*
    DISPLAY BY NAME g_ofs.ofsoriu,g_ofs.ofsorig,
        g_ofs.ofs01,g_ofs.ofs02,g_ofs.ofs03,g_ofs.ofs04,g_ofs.ofs05,
        g_ofs.ofs06,g_ofs.ofs07,g_ofs.ofs08,g_ofs.ofs09,g_ofs.ofs10,
        g_ofs.ofs11,g_ofs.ofs12,g_ofs.ofs13,g_ofs.ofs14,g_ofs.ofs15,
        g_ofs.ofs16,g_ofs.ofs17,
        g_ofs.ofsuser,g_ofs.ofsgrup,g_ofs.ofsmodu,g_ofs.ofsdate,g_ofs.ofsacti
 
    #圖形顯示
    CALL cl_set_field_pic("","","","","",g_ofs.ofsacti)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i640_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ofs.ofs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ofs.* FROM ofs_file WHERE ofs01=g_ofs.ofs01
    IF g_ofs.ofsacti ='N' THEN     #檢查資料是否為無效
        CALL cl_err(g_ofs.ofs01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofs01_t = g_ofs.ofs01
    LET g_ofs_o.*=g_ofs.*
    BEGIN WORK
 
    OPEN i640_cl USING g_ofs.ofs01
    IF STATUS THEN
       CALL cl_err("OPEN i640_cl:", STATUS, 1)
       CLOSE i640_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i640_cl INTO g_ofs.*                # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofs.ofsmodu=g_user                     #修改者
    LET g_ofs.ofsdate = g_today                  #修改日期
    CALL i640_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ofs_t.*=g_ofs.*
        CALL i640_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofs.*=g_ofs_t.*
            CALL i640_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofs_file SET ofs_file.* = g_ofs.*    # 更新DB
            WHERE ofs01 = g_ofs.ofs01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofs_file",g_ofs01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i640_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i640_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofs.ofs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i640_cl USING g_ofs.ofs01
    IF STATUS THEN
       CALL cl_err("OPEN i640_cl:", STATUS, 1)
       CLOSE i640_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i640_cl INTO g_ofs.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i640_show()
    IF cl_exp(15,12,g_ofs.ofsacti) THEN
        LET g_chr=g_ofs.ofsacti
        IF g_ofs.ofsacti='Y' THEN
            LET g_ofs.ofsacti='N'
        ELSE
            LET g_ofs.ofsacti='Y'
        END IF
        UPDATE ofs_file
            SET ofsacti=g_ofs.ofsacti,
               ofsmodu=g_user, ofsdate=g_today
            WHERE ofs01=g_ofs.ofs01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofs_file",g_ofs.ofs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_ofs.ofsacti=g_chr
        END IF
        DISPLAY BY NAME g_ofs.ofsacti
    END IF
    CLOSE i640_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i640_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofs.ofs01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #TQC-970394---Begin                                                                                                             
    IF g_ofs.ofsacti = 'N' THEN                                                                                                     
       CALL cl_err('','abm-033',0)  
       RETURN                                                                                                                       
    END IF                                                                                                                          
    #TQC-970394---End  
    BEGIN WORK
    OPEN i640_cl USING g_ofs.ofs01
    IF STATUS THEN
       CALL cl_err("OPEN i640_cl:", STATUS, 1)
       CLOSE i640_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i640_cl INTO g_ofs.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i640_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofs01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofs.ofs01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ofs_file WHERE ofs01 = g_ofs.ofs01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_ofs.ofs01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","ofs_file",g_ofs.ofs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       INITIALIZE g_ofs.* TO NULL
       OPEN i640_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i640_cs
          CLOSE i640_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i640_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i640_cs
          CLOSE i640_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i640_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i640_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i640_fetch('/')
       END IF
    END IF
    CLOSE i640_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i640_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofs01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i640_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofs01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

