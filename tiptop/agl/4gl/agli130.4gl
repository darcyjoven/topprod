# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agli130.4gl
# Descriptions...: 子系統各期統計開帳作業
# Date & Author..: NO.FUN-5C0015 05/12/16 By TSD.kevin
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690024 06/09/18 By jamie 判斷pmcacti
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-950035 09/06/12 By chenmoyan _u()中給g_npr10_t賦值
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980259 09/08/25 By Carrier 對象字段有效性判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.TQC-B40017 11/04/01 By yinhy 維護資料時“部門”欄位check部門內應根據部門拒絕/允許設置作業管控部門輸入
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C10122 12/01/17 By Polly 增加查詢人員action，並重帶npr02
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_npr   RECORD LIKE npr_file.*,
    g_npr_t RECORD LIKE npr_file.*,
    g_npr08_t LIKE npr_file.npr08,
    g_npr09_t LIKE npr_file.npr09,
    g_npr10_t LIKE npr_file.npr10,
    g_npr11_t LIKE npr_file.npr11,
    g_npr01_t LIKE npr_file.npr01,
    g_npr02_t LIKE npr_file.npr02,
    g_npr00_t LIKE npr_file.npr00,
    g_npr03_t LIKE npr_file.npr03,
    g_npr04_t LIKE npr_file.npr04,
    g_npr05_t LIKE npr_file.npr05,
    g_aag05   LIKE aag_file.aag05,
    g_wc,g_sql          STRING,   
    g_before_input_done LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
DEFINE   g_forupd_sql   STRING      # SELECT ... FOR UPDATE SQL        
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680098 INTEGER   
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER   
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER   
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER   
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   g_npr01_o      LIKE npr_file.npr01
DEFINE   g_flag         LIKE type_file.chr1          #MOD-C10122 add 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0073
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   INITIALIZE g_npr.* TO NULL
   INITIALIZE g_npr_t.* TO NULL
   LET g_flag = ' '                                  #MOD-C10122 add 
   LET g_forupd_sql = "SELECT * FROM npr_file WHERE npr00 = ? AND npr01 = ? AND npr02 = ? AND npr03 = ? AND npr04 = ? AND npr05 = ? AND npr08 = ? AND npr09 = ? AND npr10 = ? AND npr11 = ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i130_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW i130_w AT p_row,p_col WITH FORM "agl/42f/agli130" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
 
   LET g_action_choice=""
   CALL i130_menu()
   
   DROP TABLE x
   CLOSE WINDOW i130_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i130_cs()
    CLEAR FORM
 
    #CALL cl_set_act_visible("query_customer1",TRUE)    
 
   INITIALIZE g_npr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       npr10,npr08,npr09,npr00,npr01,npr02,npr03,npr11,npr04,npr05,
       npr06,npr06f,npr07,npr07f
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp                                                          
        CASE                                                                     
          WHEN INFIELD(npr00) #會計科目                                         
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_aag"                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO npr00                               
             NEXT FIELD npr00                                                   
          WHEN INFIELD(npr01) #客戶編號                                         
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_pmc"                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO npr01    
             LET g_flag = '1'                                    #MOD-C10122 add                           
             NEXT FIELD npr01                                                   
          WHEN INFIELD(npr03) #部門    
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_gem"                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO npr03                               
             NEXT FIELD npr03                                                   
          WHEN INFIELD(npr11) #幣別                                             
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_azi"                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO npr11                               
             NEXT FIELD npr11                                                   
          OTHERWISE EXIT CASE                                                   
        END CASE   
 
      ON ACTION query_customer1
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_occ"
         CALL cl_create_qry() RETURNING g_npr.npr01
         DISPLAY BY NAME g_npr.npr01
         LET g_flag = '2'                                    #MOD-C10122 add
         NEXT FIELD npr01

     #-----------------------MOD-C10122-----------------start
      ON ACTION query_user
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_gen2"
         CALL cl_create_qry() RETURNING g_npr.npr01
         DISPLAY BY NAME g_npr.npr01
         LET g_flag = '3'                                    
         NEXT FIELD npr01
     #-----------------------MOD-C10122-------------------end
                                                             
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about     
         CALL cl_about() 
 
      ON ACTION help     
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT   
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT npr08,npr09,npr01,npr02,npr00,npr03,",
              "       npr04,npr05,npr10,npr11 ",   # 組合出 SQL 指令
              " FROM npr_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY npr08,npr09,npr10,npr01"
 
    PREPARE i130_prepare FROM g_sql         # RUNTIME 編譯
    DECLARE i130_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i130_prepare
    CALL i130_pre()
 
END FUNCTION
 
FUNCTION i130_pre()
 
   LET g_sql="SELECT npr08,npr09,npr01,npr02,npr00,npr03,",
             "npr04,npr05,npr10,npr11 ",
             " FROM npr_file ",
             " WHERE ",g_wc CLIPPED," INTO TEMP x"
    DROP TABLE x
    PREPARE i130_precount_x  FROM g_sql
    EXECUTE i130_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i130_precount FROM g_sql
    DECLARE i130_count CURSOR FOR i130_precount
 
END FUNCTION
 
FUNCTION i130_menu()
    MENU ""
 
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert  
         LET g_action_choice="insert" 
         IF cl_chk_act_auth() THEN
            CALL i130_a() 
         END IF
 
      ON ACTION query  
         LET g_action_choice="query"   
         IF cl_chk_act_auth() THEN
            CALL i130_q() 
         END IF
 
      ON ACTION jump
         CALL i130_fetch('/')
 
      ON ACTION first
         CALL i130_fetch('F')
 
      ON ACTION last
         CALL i130_fetch('L')
 
      ON ACTION next
         CALL i130_fetch('N') 
 
      ON ACTION previous
         CALL i130_fetch('P')
 
      ON ACTION modify  
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i130_u() 
         END IF
 
      ON ACTION delete  
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i130_r() 
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about        
         CALL cl_about()    
         LET g_action_choice="exit"
         CONTINUE MENU
    
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE 	
         LET g_action_choice = "exit"
         EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i130_cs
END FUNCTION
 
 
FUNCTION i130_a()
 
    IF s_shut(0) THEN RETURN END IF
 
    MESSAGE ""
 
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_npr.* LIKE npr_file.*
 
    LET g_npr_t.* = g_npr.*
    LET g_npr10_t = NULL
    LET g_npr08_t = NULL
    LET g_npr09_t = NULL
    LET g_npr01_t = NULL
    LET g_npr02_t = NULL
    LET g_npr00_t = NULL
    LET g_npr03_t = NULL
    LET g_npr04_t = NULL
    LET g_npr05_t = NULL
    LET g_npr.npr10 = '0'
    LET g_npr11_t = NULL
    LET g_npr.npr11 = g_aza.aza17
    LET g_npr.npr06f = 0 
    LET g_npr.npr07f = 0 
    LET g_npr.npr08 = g_plant
    LET g_npr.npr09 = g_aaz.aaz64
    LET g_npr.npr06 = 0 
    LET g_npr.npr07 = 0 
    LET g_npr01_o = NULL
    LET g_npr.nprlegal = g_legal #FUN-980003 add
  
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i130_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                      # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_npr.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_npr.npr01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO npr_file VALUES(g_npr.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins npr:',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","npr_file",g_npr.npr08,g_npr.npr09,SQLCA.sqlcode,"","ins npr:",1)  #No.FUN-660123
            CONTINUE WHILE
        ELSE
            LET g_npr_t.* = g_npr.*                # 保存上筆資料
            SELECT npr01 INTO g_npr.npr01 FROM npr_file
             WHERE npr08 = g_npr.npr08 AND npr09 = g_npr.npr09
               AND npr01 = g_npr.npr01 AND npr02 = g_npr.npr02
               AND npr00 = g_npr.npr00 AND npr03 = g_npr.npr03
               AND npr04 = g_npr.npr04 AND npr05 = g_npr.npr05
               AND npr10 = g_npr.npr10   
               AND npr11 = g_npr.npr11  
        END IF
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i130_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1)
        l_flag          LIKE type_file.chr1,    # 判斷必要欄位之值是否有輸入  #No.FUN-680098 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-680098 SMALLINT
    DEFINE li_chk_bookno LIKE type_file.num5,   #No.FUN-670005 #No.FUN-680098  SMALLINT
           l_sql STRING          #No.FUN-670005       
    DEFINE l_aag05      LIKE aag_file.aag05      #No.TQC-B40017

    INPUT BY NAME
        g_npr.npr10,g_npr.npr08,g_npr.npr09,g_npr.npr00,g_npr.npr01,g_npr.npr02,
        g_npr.npr03,g_npr.npr11,g_npr.npr04,g_npr.npr05,
        g_npr.npr06,g_npr.npr06f,g_npr.npr07,g_npr.npr07f
        WITHOUT DEFAULTS 
 
      BEFORE INPUT                                                              
         LET g_before_input_done = FALSE                                        
         CALL i130_set_entry(p_cmd)                                             
         CALL i130_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE   
 
       
        AFTER FIELD npr08
          IF NOT cl_null(g_npr.npr08) THEN 
            #FUN-990031--mod--str--  營運中心要控制在當前法人下 
            #SELECT * FROM azp_file WHERE azp01 = g_npr.npr08
            #IF STATUS THEN 
            #  #CALL cl_err(g_npr.npr08,'agl-025',0)    #No.FUN-660123
            #   CALL cl_err3("sel","azp_file",g_npr.npr08,"","agl-025","","",1)  #No.FUN-660123
            #   NEXT FIELD npr08
            #END IF
             SELECT * FROM azw_file WHERE azw01 = g_npr.npr08 AND azw02 = g_legal 
             IF STATUS THEN
                CALL cl_err3("sel","azw_file",g_npr.npr08,"","agl-171","","",1)
                NEXT FIELD npr08
             END IF 
             #FUN-990031--mod--end 
          END IF
 
        AFTER FIELD npr09
          IF NOT cl_null(g_npr.npr09) THEN 
          #No.FUN-670005--begin
             CALL s_check_bookno(g_npr.npr09,g_user,g_npr.npr08) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                LET g_npr.npr09 = g_npr09_t
                NEXT FIELD npr09
             END IF 
             LET g_plant_new=g_npr.npr08   # 工廠編號                
             CALL s_getdbs()                 
             LET l_sql = "SELECT * ",    
                        #"  FROM ",g_dbs_new CLIPPED,"aaa_file ", #FUN-A50102
                         "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),   #FUN-A50102
                         "  WHERE aaa01 = '",g_npr.npr09,"' ",
                         "    AND aaaacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql    #FUN-A50102
             PREPARE p130_pre2 FROM l_sql
             DECLARE p130_cur2 CURSOR FOR p130_pre2
             OPEN p130_cur2  
             FETCH p130_cur2 # INTO g_cnt
          #No.FUN-670005--end
#           SELECT * FROM aaa_file WHERE aaa01 = g_npr.npr09 AND aaaacti='Y'  #No.FUN-670005 
            IF STATUS THEN 
#              CALL cl_err(g_npr.npr09,'agl-229',0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",g_npr.npr09,"","agl-229","","",1)  #No.FUN-660123
               NEXT FIELD npr09 
            END IF
          END IF
 
        BEFORE FIELD npr00
            CALL i130_set_entry(p_cmd)
 
        AFTER FIELD npr00
          IF cl_null(g_npr.npr09) THEN NEXT FIELD npr09 END IF  #No.FUN-730070
          IF NOT cl_null(g_npr.npr00) THEN 
            CALL i130_npr00('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_npr.npr00,g_errno,0)
              #Mod No.FUN-B10048
              #LET g_npr.npr00 = g_npr00_t
              #DISPLAY BY NAME g_npr.npr01 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_npr.npr00
               LET g_qryparam.arg1 = g_npr.npr09
               LET g_qryparam.where = " aag07 IN ('2','3')AND aag03='2' AND aagacti='Y' AND aag01 LIKE '",g_npr.npr00 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_npr.npr00
               DISPLAY BY NAME g_npr.npr00
              #End Mod No.FUN-B10048
               NEXT FIELD npr00
            END IF
            IF g_aag05 = 'N' THEN
               LET g_npr.npr03 = ' '                                         
               DISPLAY BY NAME g_npr.npr03             
            END IF                      
          END IF 
          CALL i130_set_no_entry(p_cmd)
 
 
        AFTER FIELD npr01
          IF NOT cl_null(g_npr.npr01) THEN 
            IF cl_null(g_npr01_o) OR (g_npr.npr01 != g_npr01_o) THEN 
               CALL i130_npr01()
               #No.TQC-980259  --Begin
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_npr.npr01,g_errno,0)
                  LET g_npr.npr01 = g_npr01_t
                  DISPLAY BY NAME g_npr.npr01 
                  NEXT FIELD npr01
               END IF
               #No.TQC-980259  --End   
               LET g_npr01_o = g_npr.npr01
            END IF
          END IF
 
        AFTER FIELD npr03
            #科目為需有部門資料者才需建立此欄位
            IF g_aag05 ='Y' THEN
               IF cl_null(g_npr.npr03) THEN NEXT FIELD npr03 END IF
               CALL i130_npr03('a')
               #No.TQC-B4001717171717171717171717171717171717  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_npr.npr00
                  AND aag00 = g_npr.npr09
               IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_npr.npr00,g_npr.npr03,g_npr.npr09)
                          RETURNING g_errno
                  END IF
               END IF
               #No.TQC-B40017  --End
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_npr.npr03,g_errno,0)
                  LET g_npr.npr03 = g_npr03_t
                  DISPLAY BY NAME g_npr.npr03 
                  NEXT FIELD npr03
               END IF
            END IF
            IF cl_null(g_npr.npr03) THEN LET g_npr.npr03 = ' ' END IF
 
 
        AFTER FIELD npr11
            SELECT azi01 FROM azi_file WHERE azi01 = g_npr.npr11
            IF STATUS THEN 
#              CALL cl_err(g_npr.npr11,'agl-002',0)    #No.FUN-660123
               CALL cl_err3("sel","azi_file",g_npr.npr11,"","agl-002","","",1)  #No.FUN-660123
               NEXT FIELD npr11
            END IF
 
 
        AFTER FIELD npr05
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_npr.npr05) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_npr.npr04
            IF g_azm.azm02 = 1 THEN
               IF g_npr.npr05 > 12 OR g_npr.npr05 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD npr05
               END IF
            ELSE
               IF g_npr.npr05 > 13 OR g_npr.npr05 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD npr05
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
          IF NOT cl_null(g_npr.npr05) THEN 
#No.TQC-720032 -- begin --
#            IF g_npr.npr05 > 12 OR g_npr.npr04 < 1 THEN 
#               NEXT FIELD npr05 
#            END IF
#No.TQC-720032 -- end --
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_npr.npr01 != g_npr01_t OR
                                g_npr.npr02 != g_npr02_t OR 
                                g_npr.npr00 != g_npr00_t OR
                                g_npr.npr03 != g_npr03_t OR
                                g_npr.npr04 != g_npr04_t OR
                                g_npr.npr08 != g_npr08_t OR
                                g_npr.npr09 != g_npr09_t OR
                                g_npr.npr10 != g_npr10_t OR
                                g_npr.npr11 != g_npr11_t OR
                                g_npr.npr05 != g_npr05_t)) THEN
              SELECT count(*) INTO l_n FROM npr_file
               WHERE npr01 = g_npr.npr01 AND npr02 = g_npr.npr02
                 AND npr00 = g_npr.npr00 AND npr03 = g_npr.npr03
                 AND npr04 = g_npr.npr04 AND npr05 = g_npr.npr05
                 AND npr10 = g_npr.npr10 AND npr08 = g_npr.npr08
                 AND npr11 = g_npr.npr11 AND npr09 = g_npr.npr09
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err('',-239,0)
                 LET g_npr.npr08 = g_npr08_t LET g_npr.npr09 = g_npr09_t
                 LET g_npr.npr01 = g_npr01_t LET g_npr.npr02 = g_npr02_t
                 LET g_npr.npr00 = g_npr00_t LET g_npr.npr03 = g_npr03_t
                 LET g_npr.npr04 = g_npr04_t LET g_npr.npr05 = g_npr05_t
                 LET g_npr.npr10 = g_npr10_t 
                 LET g_npr.npr11 = g_npr11_t   
                 DISPLAY BY NAME g_npr.npr08 
                 DISPLAY BY NAME g_npr.npr09 
                 DISPLAY BY NAME g_npr.npr01 
                 DISPLAY BY NAME g_npr.npr02 
                 DISPLAY BY NAME g_npr.npr00 
                 DISPLAY BY NAME g_npr.npr03 
                 DISPLAY BY NAME g_npr.npr04 
                 DISPLAY BY NAME g_npr.npr05,g_npr.npr10 
                 DISPLAY BY NAME g_npr.npr11  
                 NEXT FIELD npr05
              END IF
            END IF
          END IF
 
        AFTER FIELD npr06f
            IF cl_null(g_npr.npr06f) THEN LET g_npr.npr06f=0 END IF
 
        AFTER FIELD npr06
            IF cl_null(g_npr.npr06) THEN LET g_npr.npr06=0 END IF
 
        AFTER FIELD npr07f
            IF cl_null(g_npr.npr07f) THEN LET g_npr.npr07f=0 END IF
 
        AFTER FIELD npr07
            IF cl_null(g_npr.npr07) THEN LET g_npr.npr07=0 END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_npr.npr01) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr01 
            END IF
            IF cl_null(g_npr.npr02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr02 
            END IF
            IF cl_null(g_npr.npr03) THEN LET g_npr.npr03 = ' ' END IF
            IF cl_null(g_npr.npr00) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr00 
            END IF
            IF cl_null(g_npr.npr04) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr04
            END IF
            IF cl_null(g_npr.npr05) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr05 
            END IF
            IF cl_null(g_npr.npr08) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr08 
            END IF
            IF cl_null(g_npr.npr09) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr09 
            END IF
            IF cl_null(g_npr.npr11) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npr.npr11 
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) NEXT FIELD npr08
            END IF
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(npr01) THEN
       #         LET g_npr.* = g_npr_t.*
       #         DISPLAY BY NAME g_npr.* 
       #         NEXT FIELD npr01
       #     END IF
        #MOD-650015 --end
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(npr00) #會計科目                                     
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_npr.npr00                          
                 LET g_qryparam.arg1 = g_npr.npr09  #No.FUN-730070
                 CALL cl_create_qry() RETURNING g_npr.npr00                     
                 DISPLAY BY NAME g_npr.npr00                                    
                 NEXT FIELD npr00                                               
              WHEN INFIELD(npr01) #對象(廠商)                                     
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_pmc"                                   
                 LET g_qryparam.default1 = g_npr.npr01                          
                 CALL cl_create_qry() RETURNING g_npr.npr01                     
                 DISPLAY BY NAME g_npr.npr01
                 LET g_flag = '1'                                    #MOD-C10122 add       
                 NEXT FIELD npr01                                               
              WHEN INFIELD(npr03) #部門                                         
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_gem"                                   
                 LET g_qryparam.default1 =g_npr.npr03  
                 CALL cl_create_qry() RETURNING g_npr.npr03                     
                 DISPLAY BY NAME g_npr.npr03                                    
                 NEXT FIELD npr03                                               
              WHEN INFIELD(npr11) #幣別                                         
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_azi"                                   
                 LET g_qryparam.default1 = g_npr.npr11                          
                 CALL cl_create_qry() RETURNING g_npr.npr11                     
                 DISPLAY BY NAME g_npr.npr11                                    
                 NEXT FIELD npr11                                               
              OTHERWISE EXIT CASE                                               
           END CASE       
 
        ON ACTION query_customer1
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_occ"
           LET g_qryparam.default1 = g_npr.npr01
           CALL cl_create_qry() RETURNING g_npr.npr01
           DISPLAY BY NAME g_npr.npr01
           LET g_flag = '2'                                    #MOD-C10122 add
           NEXT FIELD npr01

     #-----------------------MOD-C10122-----------------start
        ON ACTION query_user
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_gen2"
           LET g_qryparam.default1 = g_npr.npr01
           CALL cl_create_qry() RETURNING g_npr.npr01
           DISPLAY BY NAME g_npr.npr01
           LET g_flag = '3'                                    #MOD-C10122 add
           NEXT FIELD npr01
     #-----------------------MOD-C10122-------------------end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
 
FUNCTION i130_set_entry(p_cmd)  
                                                
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                            
      CALL cl_set_comp_entry("npr08",TRUE)                                      
   END IF                                                                       
                                                                                
   IF INFIELD(npr00) OR (NOT g_before_input_done) THEN                          
      CALL cl_set_comp_entry("npr03",TRUE)                                
   END IF    
                                                                   
END FUNCTION     
 
FUNCTION i130_set_no_entry(p_cmd)  
                                             
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680098 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN  
      CALL cl_set_comp_entry("npr08",FALSE)                                     
   END IF                                                                       
                                                                                
   IF INFIELD(npr00) OR (NOT g_before_input_done) THEN                          
      IF g_aag05<>'Y' THEN                                                
         CALL cl_set_comp_entry("npr03",FALSE)                            
      END IF                                                                    
   END IF    
                                                                   
END FUNCTION  
 
FUNCTION i130_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_npr.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i130_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! " 
    OPEN i130_count
    FETCH i130_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i130_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_npr.* TO NULL
    ELSE
        CALL i130_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
 
END FUNCTION
 
FUNCTION i130_fetch(p_flnpr)
 
    DEFINE  p_flnpr  LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
 
    CASE p_flnpr
        WHEN 'N' FETCH NEXT     i130_cs INTO g_npr.npr08,
                                             g_npr.npr09,g_npr.npr01,
                                             g_npr.npr02,g_npr.npr00,
                                             g_npr.npr03,g_npr.npr04,
                                             g_npr.npr05,g_npr.npr10,
                                             g_npr.npr11
        WHEN 'P' FETCH PREVIOUS i130_cs INTO g_npr.npr08,
                                             g_npr.npr09,g_npr.npr01,
                                             g_npr.npr02,g_npr.npr00,
                                             g_npr.npr03,g_npr.npr04,
                                             g_npr.npr05,g_npr.npr10,
                                             g_npr.npr11
        WHEN 'F' FETCH FIRST    i130_cs INTO g_npr.npr08,
                                             g_npr.npr09,g_npr.npr01,
                                             g_npr.npr02,g_npr.npr00,
                                             g_npr.npr03,g_npr.npr04,
                                             g_npr.npr05,g_npr.npr10,
                                             g_npr.npr11
        WHEN 'L' FETCH LAST     i130_cs INTO g_npr.npr08,
                                             g_npr.npr09,g_npr.npr01,
                                             g_npr.npr02,g_npr.npr00,
                                             g_npr.npr03,g_npr.npr04,
                                             g_npr.npr05,g_npr.npr10,
                                             g_npr.npr11
        WHEN '/'
            IF NOT mi_no_ask THEN
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
            FETCH ABSOLUTE g_jump i130_cs INTO g_npr.npr08,
                                                g_npr.npr09,g_npr.npr01,
                                                g_npr.npr02,g_npr.npr00,
                                                g_npr.npr03,g_npr.npr04,
                                                g_npr.npr05,g_npr.npr10, 
                                                g_npr.npr11
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_npr.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnpr
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_npr.* FROM npr_file            # 重讀DB,因TEMP有不被更新特性
       WHERE npr00 = g_npr.npr00 AND npr01 = g_npr.npr01 AND npr02 = g_npr.npr02 AND npr03 = g_npr.npr03 AND npr04 = g_npr.npr04 AND npr05 = g_npr.npr05 AND npr08 = g_npr.npr08 AND npr09 = g_npr.npr09 AND npr10 = g_npr.npr10 AND npr11 = g_npr.npr11
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel","npr_file",g_npr.npr08,g_npr.npr09,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
 
        CALL i130_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i130_show()
 
    LET g_npr_t.* = g_npr.*
    DISPLAY BY NAME
        g_npr.npr08,g_npr.npr09,g_npr.npr00,g_npr.npr01,g_npr.npr02,
        g_npr.npr03,g_npr.npr04,g_npr.npr05,g_npr.npr06,g_npr.npr07,
        g_npr.npr10,g_npr.npr11,g_npr.npr06f,g_npr.npr07f 
 
    CALL i130_npr00('d')
    CALL i130_npr03('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i130_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_npr.npr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_npr08_t = g_npr.npr08
    LET g_npr09_t = g_npr.npr09
    LET g_npr01_t = g_npr.npr01
    LET g_npr01_o = g_npr.npr01
    LET g_npr02_t = g_npr.npr02
    LET g_npr00_t = g_npr.npr00
    LET g_npr03_t = g_npr.npr03
    LET g_npr04_t = g_npr.npr04
    LET g_npr05_t = g_npr.npr05
    LET g_npr11_t = g_npr.npr11
    LET g_npr10_t = g_npr.npr10            #No.TQC-950035 
    BEGIN WORK
 
    OPEN i130_cl USING g_npr.npr00,g_npr.npr01,g_npr.npr02,g_npr.npr03,g_npr.npr04,g_npr.npr05,g_npr.npr08,g_npr.npr09,g_npr.npr10,g_npr.npr11
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_npr.*                # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i130_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i130_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_npr.*=g_npr_t.*
            CALL i130_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE npr_file SET npr_file.* = g_npr.*  # 更新DB
            WHERE npr00 = g_npr00_t AND npr01 = g_npr01_t AND npr02 = g_npr02_t AND npr03 = g_npr03_t AND npr04 = g_npr04_t AND npr05 = g_npr05_t AND npr08 = g_npr08_t AND npr09 = g_npr09_t AND npr10 = g_npr10_t AND npr11 = g_npr11_t             # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","npr_file",g_npr08_t,g_npr09_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i130_r()
    DEFINE l_chr   LIKE   type_file.chr1          #No.FUN-680098 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
    IF g_npr.npr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i130_cl USING g_npr.npr00,g_npr.npr01,g_npr.npr02,g_npr.npr03,g_npr.npr04,g_npr.npr05,g_npr.npr08,g_npr.npr09,g_npr.npr10,g_npr.npr11
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_npr.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i130_show()
    IF cl_delete() THEN
        DELETE FROM npr_file 
            WHERE npr00 = g_npr.npr00 AND npr01 = g_npr.npr01 AND npr02 = g_npr.npr02 AND npr03 = g_npr.npr03 AND npr04 = g_npr.npr04 AND npr05 = g_npr.npr05 AND npr08 = g_npr.npr08 AND npr09 = g_npr.npr09 AND npr10 = g_npr.npr10 AND npr11 = g_npr.npr11
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("del","npr_file",g_npr08_t,g_npr09_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL i130_pre()
           OPEN i130_count
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i130_cs
              CLOSE i130_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           FETCH i130_count INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i130_cs
              CLOSE i130_count
              COMMIT WORK
              RETURN
           END IF
          #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i130_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i130_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i130_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i130_npr00(p_cmd) 
    DEFINE p_cmd        LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag01	LIKE aag_file.aag01          #No.FUN-680098 VARCHAR(24)  
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti	LIKE aag_file.aagacti       #No.FUN-680098  VARCHAR(1)  
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag05,aag07,aagacti
      INTO l_aag02,l_aag03,g_aag05,l_aag07,l_acti 
      FROM aag_file WHERE aag01 = g_npr.npr00
                      AND aag00 = g_npr.npr09  #No.FUN-730070
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015' 
         WHEN l_aag03 != '2'       LET g_errno = 'agl-201' 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   
    IF cl_null(g_errno) OR p_cmd = 'd' THEN 
       DISPLAY l_aag02 TO FORMONLY.aag02
    END IF
 
END FUNCTION
 
 
FUNCTION i130_npr01()    # 先撈廠商編號，再撈客戶編號
    DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
           l_pmc03      LIKE pmc_file.pmc03,
           l_pmcacti    LIKE pmc_file.pmcacti
 
    LET g_errno = ' '
   #----------------------MOD-C10122---------------------start
    CASE g_flag
         WHEN '1'
              SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
                FROM pmc_file WHERE pmc01 = g_npr.npr01
         WHEN '2'
              SELECT occ02,occacti INTO l_pmc03,l_pmcacti
                FROM occ_file WHERE occ01 = g_npr.npr01
         WHEN '3'
              SELECT gen02,genacti INTO l_pmc03,l_pmcacti
                FROM gen_file WHERE gen01 = g_npr.npr01
    END CASE
    CASE WHEN SQLCA.SQLCODE = 100
              IF g_flag = '1' THEN
                 LET g_errno = 'aap-000'
              ELSE
                 IF g_flag = '2' THEN
                    LET g_errno = 'aom-061'
                 ELSE
                    LET g_errno = 'aoo-017'
                 END IF
              END IF
              LET l_pmc03 = ' '
         WHEN l_pmcacti = 'N'
              LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'
              LET g_errno = '9038'
         OTHERWISE
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

   #SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
   #  FROM pmc_file WHERE pmc01=g_npr.npr01
 
   #CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-000'   #No.TQC-980259
   #                                 LET l_pmc03 = ' '
   #     WHEN l_pmcacti      ='N'    LET g_errno = '9028'
   #     WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'   #No.FUN-690024 add
   #      OTHERWISE   
   #          LET g_errno = SQLCA.SQLCODE USING '-------'
   #END CASE
 
   #IF NOT cl_null(g_errno) THEN
   #   LET g_errno = ' '
   #   SELECT occ02,occacti INTO l_pmc03,l_pmcacti
   #     FROM occ_file WHERE occ01=g_npr.npr01
 
   #   CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aom-061'  #No.TQC-980259
   #                                    LET l_pmc03 = ' '
   #        WHEN l_pmcacti     ='N'     LET g_errno = '9028'
   #        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038' #No.FUN-690024 add 
   #        OTHERWISE       
   #             LET g_errno = SQLCA.SQLCODE USING '-------'
   #   END CASE
   #END IF
   #----------------------MOD-C10122-----------------------end
   
    IF cl_null(g_errno) THEN
       LET g_npr.npr02 = l_pmc03
    ELSE 
       LET g_npr.npr02 = ' '
    END IF
    DISPLAY BY NAME g_npr.npr02
 
END FUNCTION
 
FUNCTION i130_npr03(p_cmd) 
    DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
           l_gem02      LIKE gem_file.gem02,
           l_gemacti    LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01=g_npr.npr03
 
    CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-039'  #No.TQC-980259
                                     LET l_gem02 = ' '
         WHEN l_gemacti      ='N'    LET g_errno = '9028'
         OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   
    IF p_cmd='d' OR cl_null(g_errno) THEN 
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
 
END FUNCTION
