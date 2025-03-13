# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxt850.4gl
# Descriptions...: 保稅庫存盤點資料維護作業
# Modify.........: No.FUN-30025 05/03/17 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550017 05/05/11 By day  根據模塊對FUN-530065分單 
# Modify.........: No.MOD-530075 05/06/09 By Smapmin CONSTRUCT BY NAME l_wc1 ON
#                                         pia01,pia02,pia03,pia04,pia05  與畫面不符
# Modify.........: No.MOD-530075 05/07/07 By Nicola SELECT pia_file(9個) INSERT 至 bwa_file(6個)欄位數量不符合
# Modify.........: No.MOD-580154 05/08/19 By CoCo PAGE LENGTH改為 g_page_line
# Modify.........: No.MOD-580323 05/08/30 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 1.FUNCTION t850()_q 一開始應清空g_bwa.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/06 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/18 By lala   報表轉為使用p_query
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0445 09/12/30 By Smapmin 擷取盤卡的action , bwa06盤點數量抓取,如果有做複盤要抓複盤數量，如果只做初盤就要抓初盤數量。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bwa               RECORD LIKE bwa_file.*,
    g_bwa_t             RECORD LIKE bwa_file.*,
    g_bwa01_t           LIKE bwa_file.bwa01,
    g_bwa011_t          LIKE bwa_file.bwa011,  #FUN-6A0007
    g_ima15             LIKE ima_file.ima15,
    g_ima06             LIKE ima_file.ima06,
    g_wc,g_sql,l_sql    STRING,  #No.FUN-580092 HCN  
    g_buf               LIKE ima_file.ima02,         #No.FUN-680062 VARCHAR(40)
    g_argv1             LIKE bwa_file.bwa01,
    #FUN-6A0007  變數宣告--START
    g_ima021            LIKE ima_file.ima021,
    g_ima25             LIKE ima_file.ima25,
    g_ima1916           LIKE ima_file.ima1916,
    g_bxe02             LIKE bxe_file.bxe02,
    g_bxe03             LIKE bxe_file.bxe03
    #FUN-6A0007  --END
 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE g_before_input_done  STRING 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680062 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680062 INTEGER
DEFINE   g_jump          LIKE type_file.num10,        #No.FUN-680062 INTEGER
         mi_no_ask       LIKE type_file.num5          #No.FUN-680062 SMALLINT
MAIN
    DEFINE
        p_row,p_col   LIKE type_file.num5             #No.FUN-680062 SMALLINT
#       l_time        LIKE type_file.chr8             #No.FUN-6A0062
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
    INITIALIZE g_bwa.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bwa_file WHERE bwa01 = ? AND bwa011 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t850_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW t850_w AT p_row,p_col WITH FORM "abx/42f/abxt850" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL t850_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL t850_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t850_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION t850_curs()
    CLEAR FORM
    IF cl_null(g_argv1) THEN
   INITIALIZE g_bwa.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              #FUN-6A0007  -add bwa011,bwa17,bwa18
              bwa011,bwa01,bwa02,bwa03,ima15,bwa04,bwa17,ima06,bwa05,bwa06,
              bwa18
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
     #FUN-530065                                                                 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(bwa02)                                                   
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()                                              
          #  LET g_qryparam.form = "q_ima"                                       
          #  LET g_qryparam.state = "c"                                          
          #  LET g_qryparam.default1 = g_bwa.bwa02                               
          #  CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            CALL q_sel_ima( TRUE, "q_ima","",g_bwa.bwa02,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
            DISPLAY g_qryparam.multiret TO bwa02                                
            NEXT FIELD bwa02                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
     #--
 
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
    ELSE
       LET g_wc = "bwa01 ='",g_argv1,"'"
    END IF
 #  INPUT g_ima15,g_ima06 from FORMONLY.ima15,FORMONLY.ima06
#   INPUT g_ima15,g_ima06 from ima15,ima06
#LET g_sql="SELECT bwa_file.bwa01 FROM bwa_file,ima_file ", # 組合出 SQL 指令
    #FUN-6A0007 
 LET g_sql="SELECT bwa_file.bwa01,bwa011 FROM bwa_file, ima_file ", # 組合出 SQL 指令
           " WHERE ",g_wc CLIPPED,
           "   AND bwa02=ima01 ",
          #"ORDER BY bwa01"
           "ORDER BY bwa011,bwa01"  #FUN-6A0007
#   IF g_ima15 MATCHES "[YN]" THEN
#      LET l_sql = l_sql CLIPPED," AND ima15='",g_ima15,"' "
#   END IF
#   IF g_ima06 !='    ' AND g_ima06 IS NOT NULL THEN
#      LET l_sql = l_sql CLIPPED," AND ima06='",g_ima06,"' "
#   END IF
#      LET g_sql = g_sql CLIPPED,l_sql CLIPPED, " ORDER BY bwa01 "
 
    PREPARE t850_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t850_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t850_prepare
   #LET g_sql= "SELECT COUNT(DISTINCT bwa01) FROM bwa_file,ima_file ",
    LET g_sql= "SELECT COUNT(*) FROM bwa_file,ima_file ",
               " WHERE ", g_wc CLIPPED,
               "   AND bwa02=ima01 "
    PREPARE t850x FROM g_sql
    DECLARE t850_count CURSOR FOR t850x
END FUNCTION
 
FUNCTION t850_menu()
DEFINE l_cmd  LIKE type_file.chr1000   #No.FUN-820002 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION access_inv_card
           CALL t850_3()
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t850_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t850_q()
            END IF
        ON ACTION next 
            CALL t850_fetch('N') 
        ON ACTION previous 
            CALL t850_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t850_u()
            END IF
        ON ACTION batch_remove 
            LET g_action_choice="batch_remove"
            IF cl_chk_act_auth() THEN
               CALL t850_d() 
            END IF
        ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL t850_out()
            END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL t850_fetch('/') 
        ON ACTION first
           CALL t850_fetch('F')  
        ON ACTION last
           CALL t850_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_bwa.bwa01 IS NOT NULL THEN
                  LET g_doc.column1 = "bwa01"
                  LET g_doc.value1 = g_bwa.bwa01
                  CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0046-------add--------end---- 
           LET g_action_choice = "exit"
           CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t850_cs
END FUNCTION
 
 
FUNCTION t850_a()
    MESSAGE ""
    CLEAR FORM               
    INITIALIZE g_bwa.* TO NULL
 
#   CALL bwa_default()    #No:8130
    LET g_bwa01_t = NULL
    LET g_bwa011_t= NULL #FUN-6A0007
    CALL cl_opmsg('a')
    WHILE TRUE
        #FUN-6A0007--start
        LET g_bwa.bwa17 = 'N'   #驗收區否
        LET g_bwa.bwa18 = NULL  #備註
        #FUN-6A0007--end
 
        LET g_bwa.bwaplant = g_plant  #FUN-980001 add
        LET g_bwa.bwalegal = g_legal  #FUN-980001 add
 
        CALL t850_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0) CLEAR FORM EXIT WHILE
        END IF
        IF g_bwa.bwa01 IS NULL THEN CONTINUE WHILE END IF
        IF cl_null(g_bwa.bwa011) THEN CONTINUE WHILE END IF   #FUN-6A0007
        INSERT INTO bwa_file VALUES(g_bwa.*)
        IF STATUS THEN 
#          CALL cl_err(g_bwa.bwa01,STATUS,0) #No.FUN-660052
           CALL cl_err3("ins","bwa_file",g_bwa.bwa01,"",STATUS,"","",1)
           CONTINUE WHILE
        ELSE LET g_bwa_t.* = g_bwa.*                # 保存上筆資料
             SELECT bwa01,bwa011 INTO g_bwa.bwa01,g_bwa.bwa011 FROM bwa_file
                WHERE bwa01 = g_bwa.bwa01 
                  AND bwa011 = g_bwa.bwa011    #FUN-6A0007
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t850_i(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
    DEFINE l_flag       LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
    DEFINE l_n          LIKE type_file.num5          #No.FUN-680062 smallint
    DEFINE l_str1       STRING     #No.MOD-580323   
    INPUT BY NAME         #FUN-6A0007 add bwa011,bwa17,bwa18
        g_bwa.bwa011,g_bwa.bwa01,g_bwa.bwa02,g_bwa.bwa03,g_bwa.bwa04,g_bwa.bwa17,
        g_bwa.bwa05,g_bwa.bwa06,g_bwa.bwa18
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t850_set_entry(p_cmd)
           CALL t850_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
       #FUN-6A0007---start
       AFTER FIELD bwa011
          IF NOT cl_null(g_bwa.bwa011) THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_bwa.bwa011 != g_bwa_t.bwa011)) 
            THEN
                SELECT count(*) INTO l_n FROM bwa_file
                    WHERE bwa01 = g_bwa.bwa01
                      AND bwa011 = g_bwa.bwa011
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_bwa.bwa011,-239,0)
                    LET g_bwa.bwa011 = g_bwa_t.bwa011
                    DISPLAY BY NAME g_bwa.bwa011
                    NEXT FIELD bwa011
                END IF
            END IF
          END IF
       #FUN-6A0007--end
 
        AFTER FIELD bwa01
          IF NOT cl_null(g_bwa.bwa01) THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_bwa.bwa01 != g_bwa_t.bwa01)) 
            THEN
                SELECT count(*) INTO l_n FROM bwa_file
                    WHERE bwa01 = g_bwa.bwa01
                      AND bwa011 = g_bwa.bwa011 #FUN-6A0007
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_bwa.bwa01,-239,0)
                    LET g_bwa.bwa01 = g_bwa_t.bwa01
                    DISPLAY BY NAME g_bwa.bwa01
                    NEXT FIELD bwa01
                END IF
            END IF
          END IF
 
        AFTER FIELD bwa02
          IF NOT cl_null(g_bwa.bwa02) THEN    #FUN-6A0007
             #FUN-AA0059 ----------------------------add start--------------------------
             IF NOT s_chk_item_no(g_bwa.bwa02,'') THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD bwa02   
             END IF 
             #FUN-AA0059 ----------------------------add end--------------------------
          SELECT count(*) INTO l_n FROM ima_file WHERE ima01 = g_bwa.bwa02 
          IF l_n = 0 
          THEN
 #No.MOD-580323 --start--                                                                                                           
               CALL cl_getmsg('ams-003',g_lang) RETURNING l_str1                                                                    
               ERROR l_str1                                                                                                         
#               ERROR "無此料件編號"                                                                                                
 #No.MOD-580323 --end-- 
               NEXT FIELD bwa02
          END IF
           #SELECT ima02 INTO g_buf FROM ima_file WHERE ima01=g_bwa.bwa02
            SELECT ima02,ima021,ima1916,ima25,ima06,ima15 #FUN-6A0007
              INTO g_buf,g_ima021,g_ima1916,g_ima25,g_ima06,g_ima15 #FUN-6A0007
              FROM ima_file WHERE ima01=g_bwa.bwa02  #FUN-6A0007
              DISPLAY g_buf TO ima02 LET g_buf=NULL
              #FUN-6A0007--start
            IF NOT cl_null(g_ima1916) THEN
               SELECT bxe02,bxe03 INTO g_bxe02,g_bxe03 
                 FROM bxe_file WHERE bxe01=g_ima1916
            END IF
 
              DISPLAY g_ima021 TO ima021 LET g_ima021= NULL
              DISPLAY g_ima1916 TO ima1916 LET g_ima1916= NULL
              DISPLAY g_ima25 TO ima25 LET g_ima25= NULL
              DISPLAY g_ima06 TO ima06 LET g_ima06= NULL
              DISPLAY g_ima15 TO ima15 LET g_ima15= NULL #FUN-6A0007
              DISPLAY g_bxe02 TO bxe02 LET g_bxe02=NULL
              DISPLAY g_bxe03 TO bxe03 LET g_bxe03=NULL
              #FUN-6A0007--end
          END IF   #FUN-6A0007
 
        #FUN-6A0007--start
        AFTER FIELD bwa17
          IF g_bwa.bwa17 NOT MATCHES "[YN]" THEN
             NEXT FIELD bwa17
          END IF
        #FUN-6A0007--end
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_bwa.bwa02)  THEN
               LET l_flag='Y' DISPLAY BY NAME g_bwa.bwa02 
            END IF    
            IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD bwa01 END IF
      
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bwa01) AND p_cmd = 'a'THEN
        #       LET g_bwa.* = g_bwa_t.*
        #       CALL t850_show()
        #       NEXT FIELD bwa01
        #    END IF
        #MOD-650015 --end
 
        #FUN-530065                                                                 
        ON ACTION CONTROLP                                                         
           CASE                                                                    
              WHEN INFIELD(bwa02)                                                   
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                              
              #  LET g_qryparam.form = "q_ima"                                       
              #  LET g_qryparam.default1 = g_bwa.bwa02                               
              #  CALL cl_create_qry() RETURNING g_bwa.bwa02                  
                CALL q_sel_ima(FALSE, "q_ima", "",g_bwa.bwa02, "", "", "", "" ,"",'' )  RETURNING g_bwa.bwa02 
#FUN-AA0059 --End--
                DISPLAY BY NAME g_bwa.bwa02                                
                NEXT FIELD bwa02                                                    
             OTHERWISE                                                              
                EXIT CASE                                                           
          END CASE                                                                 
        #--
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
FUNCTION t850_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bwa.* TO NULL                 #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t850_curs()
    IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
    OPEN t850_count
    FETCH t850_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t850_cs
    IF STATUS
       THEN CALL cl_err(g_bwa.bwa01,STATUS,0)
            INITIALIZE g_bwa.* TO NULL
       ELSE CALL t850_fetch('F')
    END IF
END FUNCTION
 
FUNCTION t850_fetch(p_flbwa)
    DEFINE p_flbwa      LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)     
    DEFINE l_abso       LIKE type_file.num10         #No.FUN-680062  integer
 
    CASE p_flbwa
#      WHEN 'N' FETCH NEXT     t850_cs INTO g_bwa.bwa01
#      WHEN 'P' FETCH PREVIOUS t850_cs INTO g_bwa.bwa01
#      WHEN 'F' FETCH FIRST    t850_cs INTO g_bwa.bwa01
#      WHEN 'L' FETCH LAST     t850_cs INTO g_bwa.bwa01
#FUN-6A0007-- start
       WHEN 'N' FETCH NEXT     t850_cs INTO g_bwa.bwa01,g_bwa.bwa011
       WHEN 'P' FETCH PREVIOUS t850_cs INTO g_bwa.bwa01,g_bwa.bwa011
       WHEN 'F' FETCH FIRST    t850_cs INTO g_bwa.bwa01,g_bwa.bwa011
       WHEN 'L' FETCH LAST     t850_cs INTO g_bwa.bwa01,g_bwa.bwa011
#FUN-6A0007-- end
       WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
       # FETCH ABSOLUTE g_jump t850_cs INTO g_bwa.bwa01
         FETCH ABSOLUTE g_jump t850_cs INTO g_bwa.bwa01,g_bwa.bwa011   #FUN-6A0007
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwa.bwa01,SQLCA.sqlcode,0)
        INITIALIZE g_bwa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flbwa
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_bwa.* FROM bwa_file WHERE bwa01 = g_bwa.bwa01 AND bwa011 = g_bwa.bwa011
    IF STATUS
#      THEN CALL cl_err(g_bwa.bwa01,STATUS,0)  #No.FUN-660052
       THEN CALL cl_err3("sel","bwa_file",g_bwa.bwa01,"",STATUS,"","",1)
       ELSE CALL t850_show()
    END IF
END FUNCTION
 
FUNCTION t850_show()
    LET g_bwa_t.* = g_bwa.*
    LET g_buf=NULL
    DISPLAY BY NAME     #FUN-6A0007 add bwa011,bwa17,bwa18 
        g_bwa.bwa011,g_bwa.bwa01,g_bwa.bwa02,g_bwa.bwa03,g_bwa.bwa04,g_bwa.bwa05,
        g_bwa.bwa06,g_bwa.bwa17,g_bwa.bwa18
#   SELECT ima02,ima06,ima15
#     INTO g_buf,g_ima06,g_ima15
 
    #FUN-6A0007
    SELECT ima02,ima06,ima15,ima021,ima25,ima1916
      INTO g_buf,g_ima06,g_ima15,g_ima021,g_ima25,g_ima1916
      FROM ima_file 
     WHERE ima01=g_bwa.bwa02
 
    #FUN-6A0007 show bxe02,bxe03--start
    IF NOT cl_null(g_ima1916) THEN
       SELECT bxe02,bxe03 INTO g_bxe02,g_bxe03
         FROM bxe_file WHERE bxe01=g_ima1916
    END IF
    #FUN-6A0007--end
 
      DISPLAY g_buf TO ima02 LET g_buf=NULL
      DISPLAY g_ima06 TO ima06 LET g_ima06=NULL
      DISPLAY g_ima15 TO ima15 LET g_ima15=NULL
 
      #FUN-6A0007 add DISPLAY --start
      DISPLAY g_ima021 TO ima021 LET g_ima021=NULL
      DISPLAY g_ima25 TO ima25 LET g_ima25=NULL
      DISPLAY g_ima1916 TO ima1916 LET g_ima1916=NULL
      DISPLAY g_bxe02 TO bxe02 LET g_bxe02=NULL
      DISPLAY g_bxe03 TO bxe03 LET g_bxe03=NULL
      #FUN-6A0007 add DISPLAY --end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t850_u()
    IF g_bwa.bwa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bwa01_t = g_bwa.bwa01
    LET g_bwa011_t = g_bwa.bwa011   #FUN-6A0007
    BEGIN WORK
 
    OPEN t850_cl USING g_bwa.bwa01,g_bwa.bwa011
    IF STATUS THEN
       CALL cl_err("OPEN t850_cl:", STATUS, 1)
       CLOSE t850_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t850_cl INTO g_bwa.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_bwa.bwa01,STATUS,0) RETURN END IF
    LET g_bwa_t.*=g_bwa.*
    CALL t850_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t850_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET g_bwa.*=g_bwa_t.* CALL t850_show()
            LET INT_FLAG = 0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        UPDATE bwa_file SET * = g_bwa.* WHERE bwa01 = g_bwa_t.bwa01 AND bwa011 = g_bwa_t.bwa011
        IF STATUS THEN 
#          CALL cl_err(g_bwa.bwa01,STATUS,0)  #No.FUN-660052
           CALL cl_err3("upd","bwa_file",g_bwa01_t,"",STATUS,"","",1)
           CONTINUE WHILE 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t850_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t850_r()
    IF g_bwa.bwa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN t850_cl USING g_bwa.bwa01,g_bwa.bwa011
    IF STATUS THEN
       CALL cl_err("OPEN t850_cl:", STATUS, 1)
       CLOSE t850_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t850_cl INTO g_bwa.*
    IF STATUS THEN CALL cl_err(g_bwa.bwa01,STATUS,0) RETURN END IF
    CALL t850_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bwa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bwa.bwa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bwa_file WHERE bwa01 = g_bwa.bwa01 
                              AND bwa011 = g_bwa.bwa011   #FUN-6A0007
 
       CLEAR FORM 
       OPEN t850_count
       FETCH t850_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t850_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t850_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t850_fetch('/')
       END IF
    END IF
    CLOSE t850_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t850_d()
    DEFINE l_wc LIKE type_file.chr1000   #No.FUN-680062 VARCHAR(300)
    DEFINE l_bwa RECORD LIKE bwa_file.*
    DEFINE l_str4,l_str5,l_str6  STRING   #No.MOD-580323  
 
    OPEN WINDOW t850_w2 AT 8,27 WITH FORM "abx/42f/abxt8501"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("abxt8501")
    WHILE TRUE #FUN-6A0007     
   #CONSTRUCT BY NAME l_wc ON bwa01
    CONSTRUCT BY NAME l_wc ON bwa011,bwa01    #FUN-6A0007
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
    #FUN-6A0007--start
       IF INT_FLAG THEN
          EXIT WHILE
       END IF
       IF l_wc =' 1=1' THEN
          CALL cl_err('','9046',0)
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    IF INT_FLAG THEN
       LET INT_FLAG =0 
    CLOSE WINDOW t850_w2
       RETURN
    END IF
    IF NOT cl_sure(0,0) THEN
       CLOSE WINDOW t850_w2
       RETURN
    END IF
    #FUN-6A0007--end
    CLOSE WINDOW t850_w2
   #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF  #FUN-6A0007
    LET g_sql="SELECT * FROM bwa_file WHERE ",l_wc CLIPPED
    PREPARE t850_p4 FROM g_sql
    DECLARE t850_c4 CURSOR FOR t850_p4
    LET g_cnt=0
    FOREACH t850_c4 INTO l_bwa.*
       IF STATUS THEN EXIT FOREACH END IF
 #No.MOD-580323 --start--                                                                                                           
       CALL cl_getmsg('mfg8501',g_lang) RETURNING l_str4                                                                            
       MESSAGE l_str4,l_bwa.bwa01                                                                                                   
#       MESSAGE '刪除中:',l_bwa.bwa01                                                                                               
       DELETE FROM bwa_file WHERE bwa01 = l_bwa.bwa01                                                                               
                              AND bwa011 = l_bwa.bwa011  #FUN-6A0007                                                                               
       IF STATUS THEN 
#         CALL cl_err('del bwa:',STATUS,1)  #No.FUN-660052
          CALL cl_err3("del","bwa_file",l_bwa.bwa01,"",STATUS,"","del bwa:",1)
       END IF                                                                       
       LET g_cnt=g_cnt+1                                                                                                            
    END FOREACH                                                                                                                     
    CALL cl_getmsg('mfg8502',g_lang) RETURNING l_str5                                                                               
    CALL cl_getmsg('mfg8503',g_lang) RETURNING l_str6                                                                               
    MESSAGE l_str5,g_cnt,l_str6                                                                                                     
#    MESSAGE "共 ", g_cnt," 筆刪除了!!!"                                                                                            
 #No.MOD-580323 --end--   
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION t850_out()
DEFINE l_cmd  LIKE type_file.chr1000
#    DEFINE l_bwa           RECORD LIKE bwa_file.*
#    DEFINE l_i             LIKE type_file.num5          #No.FUN-680062  SMALLINT
#    DEFINE l_name          LIKE type_file.chr20         #No.FUN-680062  VARCHAR(20)    
     IF cl_null(g_wc) AND NOT cl_null(g_bwa.bwa01) AND NOT cl_null(g_bwa.bwa011) THEN                                                
       LET g_wc = " bwa01 = '",g_bwa.bwa01,"' AND bwa011 = '",g_bwa.bwa011,"'"                                                      
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('',9057,0) RETURN                                                                                                
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "abxt850" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
#    IF g_wc IS NULL THEN 
#      CALL cl_err('',-400,0) RETURN 
#       CALL cl_err('',9057,0) RETURN 
#    END IF
#    CALL cl_wait()
#   LET l_name = 'abxt850.out'
#    CALL cl_outnam('abxt850') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    LET g_sql="SELECT * FROM bwa_file WHERE ",g_wc CLIPPED
 
#    PREPARE t850_p1 FROM g_sql
#    DECLARE t850_co  CURSOR FOR t850_p1
 
#    START REPORT t850_rep TO l_name
 
#    FOREACH t850_co INTO l_bwa.*
#       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#       MESSAGE g_x[9],l_bwa.bwa01,' ',g_x[10],l_bwa.bwa02
#       OUTPUT TO REPORT t850_rep(l_bwa.*)
#    END FOREACH
 
#    FINISH REPORT t850_rep
 
#    CLOSE t850_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t850_rep(sr)
# DEFINE l_trailer_sw  LIKE type_file.chr1     #No.FUN-680062 VARCHAR(1)
# DEFINE l_ima02    LIKE ima_file.ima02          
# DEFINE l_ima021   LIKE ima_file.ima021
# DEFINE x          LIKE type_file.chr8        #No.FUN-680062   VARCHAR(6)   
# DEFINE sr         RECORD LIKE bwa_file.*
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line 
 
#ORDER BY sr.bwa01
# ORDER BY sr.bwa011,sr.bwa01	 #FUN-6A0007
 
# FORMAT
#  PAGE HEADER
#    PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#    PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#    LET g_pageno=g_pageno+1
#    LET pageno_total=PAGENO USING '<<<','/pageno'
#    PRINT g_head CLIPPED,pageno_total
#    PRINT 
#    PRINT g_dash
#    PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#          g_x[36],g_x[37],g_x[38]
#    PRINT g_dash1
#    LET l_trailer_sw = 'y'
 
#  BEFORE GROUP OF sr.bwa01
#    PRINT COLUMN g_c[31],sr.bwa01;
 
#  ON EVERY ROW
#    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
#        WHERE ima01=sr.bwa02
#    IF SQLCA.sqlcode THEN 
#        LET l_ima02 = NULL 
#        LET l_ima021 = NULL 
#    END IF
 
#    PRINT COLUMN g_c[32],sr.bwa02,
#          COLUMN g_c[33],l_ima02,
#          COLUMN g_c[34],l_ima021,
#          COLUMN g_c[35],sr.bwa03 clipped,
#          COLUMN g_c[36],sr.bwa04 clipped,
#          COLUMN g_c[37],sr.bwa05 clipped,
#          COLUMN g_c[38],cl_numfor(sr.bwa06,38,2)
 
#  ON LAST ROW
#    LET l_trailer_sw = 'n'
 
#  PAGE TRAILER
#    PRINT g_dash
#    IF l_trailer_sw = 'y'
#       THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#    END IF
#END REPORT
#No.FUN-820002--end--
 
FUNCTION t850_2()
    DEFINE sr              RECORD LIKE bwa_file.*
    DEFINE l_i             LIKE type_file.num5          #No.FUN-680062 smallint
    DEFINE l_name          LIKE type_file.chr20         #No.FUN-680062 VARCHAR(20)     
    DEFINE l_wc1,l_wc2     STRING       #No.FUN-680062 VARCHAR(300)
    DEFINE l_str2,l_str7,l_str8 STRING  #No.MOD-580323   
 
    LET l_name = 'abxt850.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'abxt850'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    LET g_len = 110
 
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    OPEN WINDOW t850_w2 AT 8,27 WITH FORM "abx/42f/abxt8502"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abxt8502")
    INPUT BY NAME g_plant_new
     AFTER FIELD g_plant_new
         IF g_plant_new IS NOT NULL AND NOT s_chknplt(g_plant_new,'','') THEN
 #No.MOD-580323 --start--                                                                                                           
            CALL cl_getmsg('abx-850',g_lang) RETURNING l_str2                                                                       
            ERROR l_str2                                                                                                            
#            ERROR "錯誤工廠編號" NEXT FIELD g_plant_new                                                                            
 #No.MOD-580323 --end-- 
         END IF
         DISPLAY BY NAME g_dbs_new
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
    CONSTRUCT BY NAME l_wc1 ON pia01
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END CONSTRUCT
#FUN-6A0007--start
#   CONSTRUCT BY NAME l_wc2 ON pie01
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
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
#   END CONSTRUCT
#FUN-6A0007--end
    CLOSE WINDOW t850_w2
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    CALL cl_wait()
    LET g_sql="SELECT pia01,pia02,pia03,pia04,pia05,0,pia09,pia30,pia900",
             #"  FROM ",g_dbs_new,"pia_file WHERE ",l_wc1 CLIPPED,  #FUN-A50102
              "  FROM ",cl_get_target_table(g_plant_new,'pia_file'),  #FUN-A50102
              " WHERE ",l_wc1 CLIPPED,   #FUN-A50102
              "   AND pia01 NOT IN (SELECT bwa01 FROM bwa_file)"
          #FUN-6A0007--start
          #   " UNION ",
          #   "SELECT pie01,pie02,'','','',pie07,pie04,pie30,pid900",
          #   "  FROM pie_file,pid_file WHERE pie01=pid01 AND ",l_wc2 CLIPPED,
          #   "   AND pie01 NOT IN (SELECT bwa01 FROM bwa_file)"
          #FUN-6A0007--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
    PREPARE t850_p2 FROM g_sql
    DECLARE t850_co2  CURSOR FOR t850_p2
 
    START REPORT t850_rep2 TO l_name
 
    FOREACH t850_co2 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 #No.MOD-580323 --start--                                                                                                           
       CALL cl_getmsg('abx-010',g_lang) RETURNING l_str7                                                                            
       CALL cl_getmsg('abx-832',g_lang) RETURNING l_str8                                                                            
       MESSAGE l_str7,sr.bwa01,l_str8,sr.bwa02                                                                                      
#       MESSAGE "盤點標簽:",sr.bwa01," 料號:",sr.bwa02                                                                              
 #No.MOD-580323 --end--  
       OUTPUT TO REPORT t850_rep2(sr.*)
    END FOREACH
 
    FINISH REPORT t850_rep2
 
    CLOSE t850_co2
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t850_rep2(sr)
 DEFINE l_trailer_sw  LIKE type_file.chr1                  #No.FUN-680062   VARCHAR(1)    
 DEFINE x             LIKE type_file.chr8                  #No.FUN-680062   VARCHAR(6)   
 DEFINE xima02        LIKE ima_file.ima02
 DEFINE sr              RECORD LIKE bwa_file.*
 
 OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line 
 
 ORDER BY sr.bwa01
 
 FORMAT
  PAGE HEADER
    PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
    PRINT
    LET g_msg='未擷取盤點清冊資料簡表'
    PRINT (g_len-FGL_WIDTH(g_msg))/2 SPACES,g_msg
    PRINT
    PRINT '製表日期:',g_today,' ',TIME,
          COLUMN g_len-10,'頁次:',PAGENO USING '<<<'
    PRINT g_dash[1,g_len]
    PRINT "盤點標籤編號 料               號 品名規格                 倉      庫 儲      位 批      號     盤點數量   "
    PRINT "------------ ------------------- ------------------------ ---------- ---------- ---------- ---------------"
    LET l_trailer_sw = 'y'
 
    BEFORE GROUP OF sr.bwa01
    PRINT sr.bwa01;
 
    ON EVERY ROW
    SELECT ima02 INTO xima02 FROM ima_file WHERE ima01 = sr.bwa02
    PRINT COLUMN  14,sr.bwa02 ,
          COLUMN  34,xima02   ,
          COLUMN  63,sr.bwa03 clipped,
          COLUMN  74,sr.bwa04 clipped,
          COLUMN  85,sr.bwa05 clipped,
          COLUMN  96,sr.bwa06 using "###########&.&&"
 
 
  ON LAST ROW
    LET l_trailer_sw = 'n'
 
  PAGE TRAILER
    PRINT g_dash[1,g_len]
    IF l_trailer_sw = 'y'
       THEN PRINT '(abxt850)',COLUMN (g_len-9),'(接下頁)'
       ELSE PRINT '(abxt850)',COLUMN (g_len-9),'(結  束)'
    END IF
END REPORT
 
FUNCTION t850_3()
    DEFINE l_bwa           RECORD LIKE bwa_file.*
    DEFINE l_wc1,l_wc2     LIKE  type_file.chr1000       #No.FUN-680062  VARCHAR(300)
    DEFINE l_str3,l_str9,l_str10  STRING                 #No.MOD-580323  
    DEFINE l_pia30         LIKE pia_file.pia30   #MOD-9C0445
   
   OPEN WINDOW t850_w3 AT 8,27 WITH FORM "abx/42f/abxt8502"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("abxt8502")
   
   ##-----No.MOD-530075 MARK-----
  #CONSTRUCT BY NAME l_wc1 ON pia01,pia02,pia03,pia04,pia05 
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE CONSTRUCT
 
   #  ON ACTION about         #MOD-4C0121
   #     CALL cl_about()      #MOD-4C0121
 
   #  ON ACTION help          #MOD-4C0121
   #     CALL cl_show_help()  #MOD-4C0121
 
   #  ON ACTION controlg      #MOD-4C0121
   #     CALL cl_cmdask()     #MOD-4C0121
 
  #
  #END CONSTRUCT
  #IF INT_FLAG THEN 
  #   CLOSE WINDOW t850_w3
  #   RETURN 
  #END IF
   ##-----No.MOD-530075 MARK END-----
    
{
    OPEN WINDOW t850_w3 AT 8,27 WITH FORM "abx/42f/abxt8502"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abxt8502")
 
 
    CALL cl_ui_locale("abxt8502")
 
         
 }
    INPUT BY NAME g_plant_new
     AFTER FIELD g_plant_new
         IF g_plant_new IS NOT NULL AND NOT s_chknplt(g_plant_new,'','') THEN
 #No.MOD-580323 --start--                                                                                                           
            CALL cl_getmsg('abx-850',g_lang) RETURNING l_str3                                                                       
            ERROR l_str3                                                                                                            
#            ERROR "錯誤工廠編號" NEXT FIELD g_plant_new                                                                            
 #No.MOD-580323 --end-- 
         END IF
         DISPLAY BY NAME g_dbs_new
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
    CONSTRUCT BY NAME l_wc1 ON pia01
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END CONSTRUCT
#06/08/01 By jin --start
#
#   CONSTRUCT BY NAME l_wc2 ON pie01
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
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
#   END CONSTRUCT
#
 
    INPUT BY NAME g_bwa.bwa011 WITHOUT DEFAULTS 
     AFTER FIELD bwa011
        IF g_bwa.bwa011 < 1 OR cl_null(g_bwa.bwa011) THEN
           CALL cl_err('','afa-370',0)
           NEXT FIELD bwa011
        END IF 
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help() 
 
    END INPUT
#FUN-6A0007 --end
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t850_w3 
       RETURN
    END IF
 
    IF NOT cl_sure(0,0) THEN
       CLOSE WINDOW t850_w3
       RETURN
    END IF
 
# pia30 -> pia50   pie30  -> pia50    modi by  98/06/29
#   LET g_sql="SELECT pia01,pia02,pia03,pia04,pia05,pia30,0,pia09,pia900",
#   LET g_sql="SELECT pia01,pia02,pia03,pia04,pia05,pia50,0,pia09,pia900",
     #LET g_sql="SELECT pia01,pia02,pia03,pia04,pia05,pia50",   #No:MOD-530075   #MOD-9C0445
     LET g_sql="SELECT pia01,pia02,pia03,pia04,pia05,pia50,'','','','','',pia30",   #No:MOD-530075   #MOD-9C0445
              "  FROM pia_file WHERE ",l_wc1 clipped,
              "   AND pia01 NOT IN (SELECT bwa01 FROM bwa_file",
                                  "  WHERE bwa011 = ",g_bwa.bwa011,")"  #FUN-6A0007
             # " UNION ", #FUN-6A0007
#             "SELECT pie01,pie02,'','','',pie30,pie07,pie04,pid900",
#             "SELECT pie01,pie02,'','','',pie50,pie07,pie04,pid900",
 
            #FUN-6A0007--start
            #   "SELECT pie01,pie02,'','','',pie50",          #No.MOD-530075
            #  "  FROM pie_file,pid_file WHERE pie01=pid01 ",
            #  "   AND pie01 NOT IN (SELECT bwa01 FROM bwa_file",
            #                         "  WHERE bwa011 = ",g_bwa.bwa011,")" #FUN-6A0007
            #FUN-6A0007--end
    PREPARE t850_p3 FROM g_sql
    DECLARE t850_co3 CURSOR FOR t850_p3
    #FOREACH t850_co3 INTO l_bwa.*   #MOD-9C0445
    FOREACH t850_co3 INTO l_bwa.*,l_pia30   #MOD-9C0445
      IF STATUS THEN EXIT FOREACH END IF
      MESSAGE l_bwa.bwa01
      IF cl_null(l_bwa.bwa06) OR l_bwa.bwa06 = 0 THEN   #MOD-9C0445
         LET l_bwa.bwa06 = l_pia30   #MOD-9C0445
      END IF   #MOD-9C0445
      #FUN-6A0007--start
      LET l_bwa.bwa17 = 'N'
      LET l_bwa.bwa18 = NULL
      LET l_bwa.bwa011 = g_bwa.bwa011
      #FUN-6A0007--end
 
      LET l_bwa.bwaplant = g_plant  #FUN-980001 add
      LET l_bwa.bwalegal = g_legal  #FUN-980001 add
 
      INSERT INTO bwa_file VALUES(l_bwa.*)
      IF STATUS THEN 
#        CALL cl_err('',STATUS,1)    #No.FUN-660052
         CALL cl_err3("ins","bwa_file",l_bwa.bwa01,"",STATUS,"","",1)
      END IF
 #No.MOD-580323 --start--                                                                                                           
       CALL cl_getmsg('abx-010',g_lang) RETURNING l_str9                                                                            
       CALL cl_getmsg('abx-832',g_lang) RETURNING l_str10                                                                           
       MESSAGE l_str9,l_bwa.bwa01,l_str10,l_bwa.bwa02                                                                               
#      MESSAGE "盤點標簽:",l_bwa.bwa01," 料號:",l_bwa.bwa02                                                                         
 #No.MOD-580323 --end-- 
    END FOREACH
    CLOSE WINDOW t850_w3
END FUNCTION
 
FUNCTION t850_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bwa01",TRUE)
      CALL cl_set_comp_entry("bwa011",TRUE)
   END IF
END FUNCTION
 
FUNCTION t850_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bwa01",FALSE)
      CALL cl_set_comp_entry("bwa011",FALSE)
END IF
END FUNCTION
 
