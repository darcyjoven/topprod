# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apsi312.4gl
# Descriptions...: APS 途程製程維護
# Date & Author..: NO.FUN-850114 08/01/17 BY yiting
# Modify         : NO.FUN-840209 08/05/13 BY Duke
# Modify.........: NO.FUN-870027 08/07/03 BY DUKE
# Modify.........: NO.FUN-890012 08/09/03 BY DUKE 增加委外欄位決定是否顯示維護外包商
# Modify.........: NO.TQC-890030 08/09/05 By Mandy sfb04 = '8',sfb87 = 'X',sfb87 = 'Y'時,不可做修改
# Modify.........: No.FUN-890130 08/09/30 BY DUKE 資源群組機器,工作站開窗
# Modify.........: No.FUN-8C0008 08/12/03 BY DUKE ADD 批量後置時間
# Modify.........: No.TQC-8C0016 08/12/15 By Mandy 資源群組編號(機器)及資源群組編號(工作站)欄位隱藏
# Modify.........: No.TQC-920083 09/03/06 By Duke 隱藏vmn15欄位 (反應單為CHI-920051)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0082 09/10/26 By wujie 5.2转SQL标准语法
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50101 11/05/16 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No.FUN-B60152 11/06/29 By Mandy 異動後,也需更新ecudate,如此apsp500在拋APS-途程製程資料時,才會抓出有異動的資料
# Modify.........: No.FUN-BA0024 11/10/27 By Abby 不控卡已確認(sfb87 = 'Y')
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sfb           RECORD LIKE sfb_file.*,   #TQC-890030
    g_vmn           RECORD LIKE vmn_file.*, #FUN-720043
    g_vmn_t         RECORD LIKE vmn_file.*, 
    g_vmn01         LIKE vmn_file.vmn01,
    g_vmn02         LIKE vmn_file.vmn02,   #途程編號
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE   g_outsource    LIKE type_file.chr1   #FUN-890012 是否委外

MAIN
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_vmn.* TO NULL
    INITIALIZE g_vmn_t.* TO NULL
 
   #LET g_forupd_sql = "SELECT * FROM vmn_file WHERE vmn01 = ? AND vmn02 = ? AND vmn03 = ? AND vmn04 = ? FOR UPDATE"  #No.FUN-9A0082
    LET g_forupd_sql = "SELECT * FROM vmn_file WHERE vmn01 = ? AND vmn02 = ? AND vmn03 = ? AND vmn04 = ? AND vmn012 = ? FOR UPDATE"  #No.FUN-9A0082 #FUN-B50101 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i312_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i312_w WITH FORM "aps/42f/apsi312"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    CALL cl_set_comp_visible("vmn08,vmn081",FALSE) #TQC-8C0016 add
    CALL cl_set_comp_visible("vmn012",g_sma.sma541='Y')  #FUN-B50101 add
 
    LET g_vmn.vmn01  = ARG_VAL(1)
    LET g_vmn.vmn02  = ARG_VAL(2)
    LET g_vmn.vmn03  = ARG_VAL(3)
    LET g_vmn.vmn04  = ARG_VAL(4)
    LET g_outsource  = ARG_VAL(5)  #FUN-890012  add 是否委外
    LET g_vmn.vmn012  = ARG_VAL(6) #FUN-B50101  add
      
    display 'outsource=',g_outsource
    IF NOT cl_null(g_vmn.vmn01) AND
       NOT cl_null(g_vmn.vmn02) AND
       NOT cl_null(g_vmn.vmn03) AND
       NOT cl_null(g_vmn.vmn04) 
       THEN LET g_flag = 'Y'
            CALL i312_q()
       ELSE LET g_flag = 'N'
    END IF
 
      LET g_action_choice=""
      CALL i312_menu()
 
    CLOSE WINDOW i312_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i312_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "     vmn01='",g_vmn.vmn01,"'",
                  " AND vmn02='",g_vmn.vmn02,"'",
                  " AND vmn03='",g_vmn.vmn03,"'",
                  " AND vmn04='",g_vmn.vmn04,"'",  
                  " AND vmn012='",g_vmn.vmn012,"'" #FUN-B50101 add
    ELSE
   INITIALIZE g_vmn.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
                 vmn01,
                 vmn02,
                 vmn03,
                 vmn04,
                 vmn012, #FUN-B50101 add
                 vmn08,
                 vmn081,
                 vmn09,
                 vmn12,
                 vmn13,
                 vmn15,    
                 vmn16,
                 vmn17,
                 vmn18,  #FUN-890012 add 
                 vmn19   #FUN-8C0008 ADD
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          
          ON ACTION controlp
             CASE
                WHEN INFIELD(vmn18)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc2"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO vmn18
                WHEN INFIELD(vmn08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_vme01"
                     CALL cl_create_qry() RETURNING g_vmn.vmn08
                     DISPLAY BY NAME g_vmn.vmn08
                     NEXT FIELD vmn08
               WHEN  INFIELD(vmn081)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_vmp01"
                     CALL cl_create_qry() RETURNING g_vmn.vmn081
                     DISPLAY BY NAME g_vmn.vmn081
                     NEXT FIELD vmn081
 
 
                OTHERWISE
                     EXIT CASE
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
             CALL cl_qbe_select()
          ON ACTION qbe_save
             CALL cl_qbe_save()
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    END IF
    IF INT_FLAG THEN RETURN END IF
 
   #FUN-B50101---mod---str---
   #LET g_sql = "SELECT vmn01,vmn02,vmn03,vmn04 FROM vmn_file ",   # 組合出 SQL 指令        
   #            " WHERE ",g_wc CLIPPED, " ORDER BY vmn01,vmn02,vmn03,vmn04"
    LET g_sql = "SELECT vmn01,vmn02,vmn03,vmn04,vmn012 FROM vmn_file ",   # 組合出 SQL 指令  
                " WHERE ",g_wc CLIPPED, " ORDER BY vmn01,vmn02,vmn03,vmn04,vmn012"
   #FUN-B50101---mod---end---
    PREPARE i312_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i312_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i312_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vmn_file WHERE ",g_wc CLIPPED
    PREPARE i312_precount FROM g_sql
    DECLARE i312_count CURSOR FOR i312_precount
END FUNCTION
 
FUNCTION i312_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_set_comp_visible("vmn15",FALSE)  #TQC-920083 ADD
           #FUN-890012 接收參數設定是否委外
           display g_outsource to FORMONLY.isoutsource
           IF g_outsource='N' THEN 
              CALL cl_set_comp_visible("vmn18",FALSE)
           END IF
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i312_q()
           END IF
        ON ACTION first
           CALL i312_fetch('F')
        ON ACTION next
           CALL i312_fetch('N')
        ON ACTION previous
           CALL i312_fetch('P')
        ON ACTION last
           CALL i312_fetch('L')
        ON ACTION jump
           CALL i312_fetch('/')
        ON ACTION modify
           CALL i312_u()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_vmn.vmn01) AND
                  NOT cl_null(g_vmn.vmn02) AND
                  NOT cl_null(g_vmn.vmn03) AND
                  NOT cl_null(g_vmn.vmn04) AND
                  g_vmn.vmn012 IS NOT NULL THEN    #FUN-B50101 add
                   LET g_doc.column1 = "vmn01"
                   LET g_doc.column2 = "vmn02"
                   LET g_doc.column3 = "vmn03"
                   LET g_doc.column4 = "vmn04"
                   LET g_doc.column5 = "vmn012"    #FUN-B50101 add
                   LET g_doc.value1 = g_vmn.vmn01
                   LET g_doc.value2 = g_vmn.vmn02
                   LET g_doc.value3 = g_vmn.vmn03
                   LET g_doc.value4 = g_vmn.vmn04
                   LET g_doc.value5 = g_vmn.vmn012 #FUN-B50101 add
                   CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i312_cs
END FUNCTION
 
 
FUNCTION i312_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vmn.* LIKE vmn_file.*
    LET g_vmn.vmn01  = NULL
    LET g_vmn.vmn02  = NULL
    LET g_vmn.vmn03  = 0
    LET g_vmn.vmn04  = NULL
    LET g_vmn.vmn012 = ' ' #FUN-B50101 add
    LET g_vmn.vmn08  = NULl
    LET g_vmn.vmn081 = NULL
    LET g_vmn.vmn09  = 0
    LET g_vmn.vmn12  = 0
    LET g_vmn.vmn13  = 1
    LET g_vmn.vmn15  = 0
    LET g_vmn.vmn16  = 9999
    LET g_vmn.vmn17  = 1
    LET g_vmn.vmn19  = 0  #FUN-8C0008 ADD
 
    LET g_vmn_t.*=g_vmn.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i312_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vmn.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_vmn.vmn01) AND  # KEY 不可空白
           cl_null(g_vmn.vmn02) AND  # KEY 不可空白
           cl_null(g_vmn.vmn03) AND
           cl_null(g_vmn.vmn04) AND 
           g_vmn.vmn012 IS NULL THEN #FUN-B50101 add
            CONTINUE WHILE
        END IF
        INSERT INTO vmn_file VALUES(g_vmn.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vmn_file",g_vmn.vmn01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            #FUN-B60152---add----str---
            UPDATE ecu_file
               SET ecudate = g_today
             WHERE ecu01 = g_vmn.vmn01
               AND ecu02 = g_vmn.vmn02
            #FUN-B60152---add----end---
            LET g_vmn_t.* = g_vmn.*                # 保存上筆資料
            SELECT vmn01,vmn02,vmn03,vmn04,vmn012 INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 FROM vmn_file #FUN-B50101 add vmn012
                WHERE vmn01 = g_vmn.vmn01
                  AND vmn02 = g_vmn.vmn02
                  AND vmn03 = g_vmn.vmn03
                  AND vmn04 = g_vmn.vmn04
                  AND vmn012 = g_vmn.vmn012 #FUN-B50101 add
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i312_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_cnt        LIKE type_file.num5  #No.FUN-840209 by Duke add
 
    DISPLAY BY NAME
        g_vmn.vmn01, 
        g_vmn.vmn02,
        g_vmn.vmn03,
        g_vmn.vmn04,
        g_vmn.vmn012, #FUN-B50101 add
        g_vmn.vmn08,
        g_vmn.vmn081,
        g_vmn.vmn09,
        g_vmn.vmn12,
        g_vmn.vmn13,
        g_vmn.vmn15,  
        g_vmn.vmn16,
        g_vmn.vmn17,
        g_vmn.vmn18,  #FUN-890012  add
        g_vmn.vmn19   #FUN-8C0008  ADD
    INPUT BY NAME
        g_vmn.vmn01,    
        g_vmn.vmn02,
        g_vmn.vmn03,
        g_vmn.vmn04,
        g_vmn.vmn012, #FUN-B50101 add
        g_vmn.vmn08,
        g_vmn.vmn081,
        g_vmn.vmn09,
        g_vmn.vmn12,
        g_vmn.vmn13,
        g_vmn.vmn15,   
        g_vmn.vmn16,
        g_vmn.vmn17,
        g_vmn.vmn18,  #FUN-890012 add
        g_vmn.vmn19   #FUN-8C0008 ADD
        WITHOUT DEFAULTS
 
   BEFORE INPUT
 
       AFTER FIELD vmn08
          IF NOT cl_null(g_vmn.vmn08) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vme_file
               WHERE vme01 = g_vmn.vmn08
              IF l_cnt = 0 THEN
                  CALL cl_err('','aps-404',0)
                  NEXT FIELD vmn08
              END IF
          END IF
        
       AFTER FIELD vmn081
          IF NOT cl_null(g_vmn.vmn081) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vmp_file
               WHERE vmp01 = g_vmn.vmn081
              IF l_cnt = 0 THEN
                  CALL cl_err('','aps-405',0)
                  NEXT FIELD vmn081
              END IF
          END IF
 
       AFTER FIELD vmn18
          IF NOT cl_null(g_vmn.vmn18) THEN
             SELECT COUNT(*) INTO l_cnt
               FROM pmc_file
             WHERE pmc01 = g_vmn.vmn18
               and pmcacti='Y'
             IF l_cnt = 0 THEN
                CALL cl_err('','aom-061',0)
                NEXT FIELD vmn18
             END IF
           END IF
 
 
 
       AFTER FIELD vmn12
          IF (NOT cl_null(g_vmn.vmn12) and g_vmn.vmn12<0) THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmn12
          END IF
 
       AFTER FIELD vmn13
          IF (NOT cl_null(g_vmn.vmn13) and g_vmn.vmn13<0) THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmn13
          END IF
       AFTER FIELD vmn19
          IF (NOT cl_null(g_vmn.vmn19) and g_vmn.vmn19<0) THEN
             CALL cl_err('','aps-406',0)
             NEXT FIELD vmn19
          END IF
 
 
       AFTER FIELD vmn15
          IF (NOT cl_null(g_vmn.vmn15) and g_vmn.vmn15<0) THEN
             CALL cl_err('','aps-406',0)
             NEXT  FIELD  vmn15
          END IF
 
       AFTER FIELD vmn16
          IF (NOT cl_null(g_vmn.vmn16) and g_vmn.vmn16<0) THEN
             CALL cl_err('','aps-406',0)
             NEXT  FIELD  vmn16
          END IF
 
       AFTER FIELD vmn17
          IF (NOT cl_null(g_vmn.vmn17) and g_vmn.vmn17<0) THEN
             CALL cl_err('','aps-406',0)
             NEXT  FIELD  vmn17
          END IF
 
 
    AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD vmn01
       END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(vmn18)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmc2"
                LET g_qryparam.default1 = g_vmn.vmn18
                CALL cl_create_qry() RETURNING g_vmn.vmn18
                DISPLAY g_vmn.vmn18 TO vmn18
                NEXT FIELD vmn18
              WHEN INFIELD(vmn08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_vme01"
                   CALL cl_create_qry() RETURNING g_vmn.vmn08
                   DISPLAY BY NAME g_vmn.vmn08
                   NEXT FIELD vmn08
              WHEN INFIELD(vmn081)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_vmp01"
                   CALL cl_create_qry() RETURNING g_vmn.vmn081
                   DISPLAY BY NAME g_vmn.vmn081
                   NEXT FIELD vmn081
 
 
              OTHERWISE
                   EXIT CASE
           END CASE
 
 
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
 
FUNCTION i312_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i312_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vmn.* TO NULL
        RETURN
    END IF
    OPEN i312_count
    FETCH i312_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i312_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmn.vmn01,SQLCA.sqlcode,0)
        INITIALIZE g_vmn.* TO NULL
    ELSE
        CALL i312_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i312_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,  
        l_abso          LIKE type_file.num10   
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i312_cs INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add
        WHEN 'P' FETCH PREVIOUS i312_cs INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add
        WHEN 'F' FETCH FIRST    i312_cs INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add
        WHEN 'L' FETCH LAST     i312_cs INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso i312_cs INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmn.vmn01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_vmn.* TO NULL          
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vmn.* FROM vmn_file            
WHERE vmn01 = g_vmn.vmn01 AND vmn02 = g_vmn.vmn02 AND vmn03 = g_vmn.vmn03 AND vmn04 = g_vmn.vmn04
  AND vmn012 = g_vmn.vmn012 #FUN-B50101 add
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmn.vmn01 CLIPPED
         CALL cl_err3("sel","vmn_file",g_vmn.vmn01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vmn.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i312_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i312_show()
    LET g_vmn_t.* = g_vmn.*
    DISPLAY BY NAME 
        g_vmn.vmn01,
        g_vmn.vmn02,
        g_vmn.vmn03,
        g_vmn.vmn04,
        g_vmn.vmn012, #FUN-B50101 add
        g_vmn.vmn08,
        g_vmn.vmn081,
        g_vmn.vmn09,
        g_vmn.vmn12,
        g_vmn.vmn13,
        g_vmn.vmn15,  
        g_vmn.vmn16,
        g_vmn.vmn17,
        g_vmn.vmn18,  #FUN-890012
        g_vmn.vmn19   #FUN-8C0008
    IF (g_vmn.vmn18 IS NULL and g_outsource='N') or
       (g_vmn.vmn18 IS NULL and g_outsource IS NULL) then 
       CALL cl_set_comp_visible("vmn18",FALSE)
       DISPLAY 'N'  to FORMONLY.isoutsource 
    ELSE
       DISPLAY 'Y' to FORMONLY.isoutsource
       CALL cl_set_comp_visible("vmn18",TRUE)
    END IF
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i312_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmn.vmn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_sfb.*
      FROM sfb_file
     WHERE sfb01 = g_vmn.vmn02
    IF g_sfb.sfb04 = '8' THEN CALL cl_err('','aap-730',1) RETURN END IF
   #IF g_sfb.sfb87 = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF #FUN-BA0024 mark
    IF g_sfb.sfb87 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmn01 = g_vmn.vmn01
    BEGIN WORK
 
    OPEN i312_cl USING g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add vmn012
    IF STATUS THEN
       CALL cl_err("OPEN i312_cl:", STATUS, 1)
       CLOSE i312_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i312_cl INTO g_vmn.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmn.vmn01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i312_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i312_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmn.* = g_vmn_t.*
            CALL i312_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmn_file SET vmn_file.* = g_vmn.*    # 更新DB
            WHERE vmn01 = g_vmn_t.vmn01 AND vmn02 = g_vmn_t.vmn02
           AND vmn03 = g_vmn_t.vmn03 AND vmn04 = g_vmn_t.vmn04               # COLAUTH?
           AND vmn012 = g_vmn.vmn012  #FUN-B50101 add
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vmn.vmn01 CLIPPED
            CALL cl_err3("upd","vmn_file",g_vmn01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            #FUN-B60152---add----str---
            UPDATE ecu_file
               SET ecudate = g_today
             WHERE ecu01 = g_vmn.vmn01
               AND ecu02 = g_vmn.vmn02
            #FUN-B60152---add----end---
            LET g_vmn_t.* = g_vmn.*# 保存上筆資料
            SELECT vmn01,vmn02,vmn03,vmn04,vmn012 INTO g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 FROM vmn_file #FUN-B50101 add vmn012
             WHERE vmn01 = g_vmn.vmn01
               AND vmn02 = g_vmn.vmn02
               AND vmn03 = g_vmn.vmn03
               AND vmn04 = g_vmn.vmn04
               AND vmn012 = g_vmn.vmn012  #FUN-B50101 add
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i312_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i312_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmn.vmn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i312_cl USING g_vmn.vmn01,g_vmn.vmn02,g_vmn.vmn03,g_vmn.vmn04,g_vmn.vmn012 #FUN-B50101 add vmn012
    IF STATUS THEN
       CALL cl_err("OPEN i312_cl:", STATUS, 1)
       CLOSE i312_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i312_cl INTO g_vmn.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmn.vmn01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i312_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmn01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vmn02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "vmn03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "vmn04"         #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "vmn012"        #No.FUN-B50101 add
        LET g_doc.value1 = g_vmn.vmn01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vmn.vmn02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_vmn.vmn03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_vmn.vmn04      #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_vmn.vmn012     #No.FUN-B50101 add
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM vmn_file WHERE vmn01 = g_vmn.vmn01 AND vmn02 = g_vmn.vmn02
            AND vmn03 = g_vmn.vmn03 AND vmn04 = g_vmn.vmn04
            AND vmn012 = g_vmn.vmn012 #FUN-B50101 add
            CLEAR FORM
    END IF
    CLOSE i312_cl
    INITIALIZE g_vmn.* TO NULL
    COMMIT WORK
END FUNCTION
#No.FUN-9C0072 精簡程式碼
 
 
