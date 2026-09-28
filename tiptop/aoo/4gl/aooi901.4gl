# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aooi901.4gl
# Descriptions...: 工廠資料建立
# Date & Author..: 92/08/31 By LYS
# Modify.........: No.MOD-480392 04/08/13 By ching 刪除時一併將 zxx_file相關資料
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4A0084 04/10/09 By Nicola 在變更名稱的時候要檢查zx.zx08
#                                若遇到已存在的要修改則須顯示錯誤訊息
# Modify.........: No.MOD-4B0098 04/11/12 By alex 解除不可修改azp01的錯誤
# Modify.........: No.MOD-520003 05/02/01 By alex 修正不可按放棄及錯誤訊息問題
# Modify.........: No.FUN-580135 05/08/25 By alex 若 azz05=Y則可編時區資料
# Modify.........: No.MOD-580311 05/08/29 By alex chk azp03
# Modify.........: No.MOD-590023 05/09/02 By alex 不可任意 update azp03
# Modify.........: No.MOD-590386 05/11/03 By alex 刪先判斷在p_zxy是否存在不能delete
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0066 06/10/20 By atsea 將g_no_ask修改為g_no_ask
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-680015 06/11/15 By Claire npx01->azp01
# Modify.........: No.TQC-710128 07/01/31 By alexstar 改成非TIPTOP使用者時才會show警告訊息
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730022 07/03/13 By alexstar 新增一欄位用來記錄Oracle的dblink name，Informix 版本此欄位則不可輸入(由程式擋掉)
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7A0086 07/11/02 By saki 營運中心上線人數控制
# Modify.........: No.FUN-7B0009 07/11/05 By saki 營運中心與部門上線人數相互check
# Modify.........: No.FUN-820040 08/02/21 By alex 修正判斷非ORACLE資料庫方法
# Modify.........: No.TQC-870015 08/08/15 By saki 取消使用zxx_file, 加入cl_used()控制process記錄
# Modify.........: No.FUN-880068 08/08/19 alexstar 1.Cancel The check of DB name 2.Change the way to check the DB link
# Modify.........: No.MOD-880167 08/08/21 alexstar DB-link name: UPCASE
# Modify.........: No.FUN-920134 09/02/18 By alex 移除FUN-910114
# Modify.........: No.FUN-930071 09/03/11 By kevin 用aooi901_fp 進行加密
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-930162 09/06/03 By Mandy 新增"資料庫開立"功能鍵
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0012 09/11/05 By Hiko 移除"資料庫開立"功能鍵,改在aooi931處理.
# Modify.........: No:TQC-9B0209 09/11/25 By Carrier copy重复性检查时,报错要用当前的azp01 值
# Modify.........: No:FUN-9C0048 09/12/10 By jan mark掉新增/刪除/複製/功能，並且修改時azp01/azp02/azp03三個欄位不可修改
# Modify.........: No.FUN-A10012 10/01/05 By destiny流通零售for業態管控
# Modify.........: No.FUN-A10018 10/01/07 By Hiko azp04的資料控制
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:FUN-960164 10/03/19 By alex 設定MS SQL database IP for CR connecttion
# Modify.........: No.MOD-A30173 10/03/31 by sabrina 用別的帳號進入aooi901後帳號會變成tiptop 
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A80148 10/09/01 By huangtao 原招商門店資料維護併入零售門店中
# Modify.........: NO:FUN-AA0054 10/10/21 By shiwuying 同步到32区
# Modify.........: NO:FUN-A80117 10/11/05 By huangtao 更新rtz_file
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_msg                LIKE ze_file.ze03            #No.FUN-680102CHAR(72),
DEFINE g_chr                LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE g_azp                RECORD LIKE azp_file.*
DEFINE g_azp_t              RECORD LIKE azp_file.*
DEFINE g_azp01_t            LIKE azp_file.azp01
DEFINE g_wc,g_sql           STRING                       #FUN-580092 HCN    
DEFINE g_ac                 LIKE type_file.num5          #No.FUN-680102SMALLINT
DEFINE g_rec_b              LIKE type_file.num5          #單身筆數  #No.FUN-680102 SMALLINT
DEFINE l_ac                 LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE l_n                  LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_row_count          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_jump               LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_no_ask             LIKE type_file.num5          #No.FUN-680102 SMALLINT  #No.FUN-6A0066
DEFINE g_chg_lim            LIKE type_file.num5          #No.FUN-7B0009
 
MAIN
   DEFINE lc_azz05        LIKE azz_file.azz05   #FUN-580135
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log 
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #No.TQC-870015
 
   #LET g_user=fgl_getenv('LOGNAME')                           #MOD-A30173 mark     
   #SELECT zx06 INTO g_lang FROM zx_file WHERE zx01=g_user     #MOD-A30173 mark 
    INITIALIZE g_azp.* TO NULL
    INITIALIZE g_azp_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM azp_file WHERE azp01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i901_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i901_w WITH FORM "aoo/42f/aooi901" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    IF cl_db_get_database_type() <> "ORA" THEN  #FUN-820040 
       CALL cl_set_comp_visible("azp04",FALSE)
    END IF
    IF cl_db_get_database_type() <> "MSV" THEN  #FUN-960164
       CALL cl_set_comp_visible("azp20",FALSE)
    END IF

    IF g_azw.azw04 <> '2' THEN                    
      # CALL cl_set_act_visible('aooi901a',FALSE)      #No.FUN-A10012   
       CALL cl_set_act_visible('arti200',FALSE)      #FUN-A80148
    ELSE             
     #  CALL cl_set_act_visible('aooi901a',TRUE)      #No.FUN-A10012     
       CALL cl_set_act_visible('arti200',TRUE)        #FUN-A80148
    END IF            
    SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01='0'
    IF STATUS OR lc_azz05 IS NULL OR lc_azz05 <> "Y" THEN
       CALL cl_set_comp_visible("azp052",FALSE)
    ELSE
       CALL cl_set_comp_visible("azp052",TRUE)
    END IF
 
    CALL i901_menu()
 
    CLOSE WINDOW i901_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-870015
END MAIN
 
FUNCTION i901_curs()
    CLEAR FORM
 
   INITIALIZE g_azp.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        azp01,azp02,azp03,azp04,azp053,azp052,azp051,azp06,azp07,  #FUN-730022 add azp04
        azp20
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    
    LET g_sql="SELECT azp01 FROM azp_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY azp01"
    PREPARE i901_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i901_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i901_prepare
    LET g_sql="SELECT COUNT(*) FROM azp_file WHERE ",g_wc CLIPPED
    PREPARE i901_precount FROM g_sql
    DECLARE i901_count CURSOR FOR i901_precount
END FUNCTION
 
FUNCTION i901_menu()
DEFINE lc_azz06 LIKE azz_file.azz06 #FUN-930071
DEFINE l_msg        LIKE type_file.chr1000     #FUN-A80148
 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i901_q()
            END IF
 
        ON ACTION next 
            CALL i901_fetch('N')
 
        ON ACTION previous 
            CALL i901_fetch('P')
 
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i901_u()
            END IF
 
        ON ACTION help 
            CALL cl_show_help()
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i901_fetch('/')
 
        ON ACTION first
            CALL i901_fetch('F')
 
        ON ACTION last
            CALL i901_fetch('L')
 
        ON ACTION controlg
            CALL cl_cmdask()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION connect_string   #FUN-930071
            LET g_action_choice="connect_string"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_azp.azp01) THEN
                  CALL cl_err('',-400,1)
               ELSE
                  #必需要azz06先Enable才可以進入調整
                  SELECT azz06 INTO lc_azz06 FROM azz_file WHERE azz01="0"
                  IF lc_azz06 IS NULL OR lc_azz06 <> "Y" THEN
                     CALL cl_err("","azz-891",1)
                  ELSE
                     IF g_azp.azp04 IS NOT NULL THEN
                        CALL cl_err("","azz-890",1)
                     ELSE
                        CALL i901_connect_str(g_azp.azp03)
                     END IF
                  END IF
               END IF
            END IF
 
         ON ACTION mntn_reportdb   #FUN-930071
            LET g_action_choice="mntn_reportdb"
            IF cl_chk_act_auth() THEN
               #必需要azz06先Enable才可以進入調整
               SELECT azz06 INTO lc_azz06 FROM azz_file WHERE azz01="0"
               IF lc_azz06 IS NULL OR lc_azz06 <> "Y" THEN
                  CALL cl_err("","azz-891",1)
               ELSE
                  IF cl_confirm("azz-892") THEN
                     CALL i901_connect_str("ds_report")
                  END IF
               END IF
            END IF
#FUN-A80148 ---------start
            ON ACTION arti200
              LET g_action_choice="arti200"
              IF cl_chk_act_auth() THEN
                 IF g_azp.azp01 IS NOT NULL THEN
                    LET l_msg = "arti200  '",g_azp.azp01,"'"
                    CALL cl_cmdrun_wait(l_msg)
                 END IF
              END IF
#FUN-A80148 --------end
         ON ACTION related_document    #No.MOD-470515 
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_azp.azp01 IS NOT NULL THEN 
                  LET g_doc.column1 = "azp01"
                  LET g_doc.value1 = g_azp.azp01
                  CALL cl_doc()
               END IF
            END IF
#FUN-A80148 --------mark    
#         ON ACTION aooi901a
#            LET g_action_choice="aooi901a"
#            IF cl_chk_act_auth() THEN
#               IF g_azp.azp01 IS NOT NULL THEN
#                   CALL i901a(g_azp.azp01,g_azp.azp02)
#               END IF
#            END IF
#FUN-A80148 --------mark
    END MENU
    CLOSE i901_curs
END FUNCTION
 
FUNCTION i901_i(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
   DEFINE l_n1            LIKE type_file.num5           #No.FUN-680102 SMALLINT
   DEFINE l_n2            LIKE type_file.num5           #No.FUN-680102 SMALLINT
   DEFINE l_asked         LIKE type_file.num5           #No.FUN-680102 SMALLINT
   DEFINE l_azp01flag     LIKE type_file.num5           #No.FUN-680102 SMALLINT   #MOD-520003
   DEFINE li_azp03        LIKE type_file.num5           #No.FUN-680102 SMALLINT   #MOD-580311
   DEFINE l_sername       LIKE type_file.chr30          #FUN-730022
   DEFINE li_max_lim      LIKE type_file.num5           #No.FUN-7B0009
   DEFINE ls_msg          STRING                        #No.FUN-7B0009
   DEFINE l_cnt SMALLINT,
          l_dbname LIKE azp_file.azp04, 
          l_param STRING
 
    LET l_asked=FALSE
    
    INPUT BY NAME g_azp.azp01,g_azp.azp02,g_azp.azp03,g_azp.azp04,g_azp.azp053,  #FUN-730022 add azp04
                  g_azp.azp052,g_azp.azp051,g_azp.azp06,g_azp.azp07,  #no.7431
                  g_azp.azp09,g_azp.azp10,g_azp.azp20        #No:FUN-7A0086 FUN-960164
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i901_set_entry(p_cmd)
            CALL i901_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE 
            IF cl_db_get_database_type() <> "ORA" THEN   #lc_db_type="IFX" THEN #FUN-820040 
               CALL cl_set_comp_entry("azp04",FALSE)
            END IF
 
        ON CHANGE azp01               #MOD-520003
           LET l_azp01flag=TRUE
 
        AFTER FIELD azp01
            IF NOT cl_null(g_azp.azp01) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_azp.azp01 != g_azp01_t) THEN
                  SELECT count(*) INTO l_n FROM azp_file
                   WHERE azp01 = g_azp.azp01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_azp.azp01,-239,0)
                     LET g_azp.azp01 = g_azp01_t
                     DISPLAY BY NAME g_azp.azp01 
                     NEXT FIELD azp01
                  END IF
 
                  # FUN-4A0084 檢查是否在 zx_file or zxy_file 中有被使用
                  LET l_n1=0 LET l_n2=0
                  SELECT count(*) INTO l_n1 FROM zxy_file
                   WHERE zxy03 = g_azp01_t
                  SELECT count(*) INTO l_n2 FROM zx_file
                   WHERE zx08 = g_azp01_t
                   IF l_azp01flag THEN            #MOD-520003
                     IF l_n1 > 0 OR l_n2 > 0 THEN  
                        IF NOT cl_confirm("aoo-023") THEN
                           LET g_azp.azp01 = g_azp01_t
                           DISPLAY BY NAME g_azp.azp01 
                           NEXT FIELD azp01
                        END IF
                        LET l_asked=TRUE
                     END IF
                  END IF
               END IF
            END IF
 
         AFTER FIELD azp03   #MOD-580311
            IF NOT cl_null(g_azp.azp03) THEN
 
               CASE cl_db_get_database_type()
                  WHEN "ORA"
                     IF NOT i901_chk_ora_dbname() THEN      #FUN-730022 for Oracle
                        CALL cl_err("","aoo-989",1)
                        NEXT FIELD azp03
                     END IF
 
                  WHEN "IFX"
                     IF (NOT i901_get_dbname()) THEN     #FUN-730022
                        NEXT FIELD azp03
                     END IF
 
                  WHEN "MSV"
                     IF NOT i901_chk_msv_dbname() THEN 
                        CALL cl_err("","aoo-989",1)
                        NEXT FIELD azp03
                     END IF
               END CASE
 
            END IF
 
        AFTER FIELD azp04   #FUN-730022  for Oracle
           IF NOT cl_null(g_azp.azp04) THEN #FUN-A10018
              #判斷相同的azp03所對應的azp04是否已經存在.
              SELECT count(*) INTO l_cnt FROM azp_file WHERE azp03=g_azp.azp03 AND azp04 IS NOT NULL
              IF l_cnt>0 THEN
                 #正常的資料來說,同一個azp03如果有azp04的話,一定都是相同的值.
                 SELECT distinct azp04 INTO l_dbname FROM azp_file WHERE azp03=g_azp.azp03 AND azp04 IS NOT NULL
                 #如果原來存在的azp04和現在設定的azp04不同時,要詢問是否全部更新相同azp03的azp04.
                 IF g_azp.azp04 CLIPPED != l_dbname CLIPPED THEN
                    LET l_param = g_azp.azp03 CLIPPED,"|",l_dbname CLIPPED,"|",g_azp.azp04 CLIPPED,"|",l_dbname CLIPPED
                    IF NOT cl_confirm_parm("aoo-260", l_param) THEN
                       LET g_azp.azp04 = l_dbname
                       DISPLAY BY NAME g_azp.azp04
                       NEXT FIELD azp04
                    END IF
                 END IF
              END IF
              
              IF (NOT i901_chk_dblink()) THEN
                 LET INT_FLAG = 0  ######add for prompt mod
                 PROMPT 'Enter Service Name(Set in $ORACLE_HOME/network/admin/tnsnames.ora):' FOR l_sername   
                 IF INT_FLAG THEN #FUN-A10018:順便修改[取消]這個小Bug.
                    LET INT_FLAG = 0
                    NEXT FIELD azp04
                 ELSE
                    IF (NOT i901_add_dblink(l_sername)) THEN
                       NEXT FIELD azp04
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD azp053 
           IF NOT cl_null(g_azp.azp053) THEN 
              IF g_azp.azp053 NOT MATCHES '[YN]' THEN
                 NEXT FIELD azp053
              END IF
           END IF 
 
        ON CHANGE azp09
           CALL i901_set_entry(p_cmd)
           CALL i901_set_no_entry(p_cmd)
 
        BEFORE FIELD azp10
           #LET g_sql = "SELECT max(gbo03) FROM ",s_dbstring(g_azp.azp03 CLIPPED),"gbo_file WHERE gbo02='Y'"
           LET g_sql = "SELECT max(gbo03) FROM ",cl_get_target_table(g_azp.azp01,'gbo_file'), #FUN-A50102
                       " WHERE gbo02='Y'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		   CALL cl_parse_qry_sql(g_sql,g_azp.azp01) RETURNING g_sql #FUN-A50102            
           PREPARE gbo03_pre FROM g_sql
           EXECUTE gbo03_pre INTO li_max_lim
           LET ls_msg = cl_getmsg("azz-746",g_lang)
           LET ls_msg = ls_msg.subString(1,ls_msg.getIndexOf("%1",1)-1)
           IF cl_null(li_max_lim) THEN
              MESSAGE ls_msg," 0"
           ELSE
              MESSAGE ls_msg," ",li_max_lim
           END IF
 
        AFTER FIELD azp10
           IF NOT cl_null(g_azp.azp10) THEN
              IF g_azp.azp09 = "Y" AND g_azp.azp10 <= 0 THEN
                 CALL cl_err("","mfg9243",0)
                 NEXT FIELD azp10
              END IF
              IF NOT cl_null(li_max_lim) AND g_azp.azp10 < li_max_lim THEN
                 IF NOT cl_confirm2("azz-748",g_azp.azp10) THEN
                    NEXT FIELD azp10
                 ELSE
                    LET g_chg_lim = TRUE
                 END IF
              END IF
           END IF
 
        AFTER INPUT
            IF g_azp.azp09 ="Y" AND g_azp.azp10 <= 0 THEN
               CALL cl_err("","mfg9243",0)
               NEXT FIELD azp10
            END IF
            IF NOT l_asked AND l_azp01flag THEN   #MOD-520003
              LET l_n1=0 LET l_n2=0
              SELECT count(*) INTO l_n1 FROM zxy_file
               WHERE zxy03 = g_azp01_t
              SELECT count(*) INTO l_n2 FROM zx_file
               WHERE zx08 = g_azp01_t
              IF l_n1 > 0 OR l_n2 > 0 THEN  
                 IF NOT cl_confirm("aoo-023") THEN
                    LET g_azp.azp01 = g_azp01_t
                    DISPLAY BY NAME g_azp.azp01 
                 END IF
                 LET l_asked=TRUE
              END IF
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()    # Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION i901_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF INFIELD(azp09) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("azp10",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i901_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
       CALL cl_set_comp_entry("azp01,azp02,azp03",FALSE)  #TQC-680015 modify npx01->azp01 #FUN-9C0048
 
    IF INFIELD(azp09) OR (NOT g_before_input_done) THEN
       IF g_azp.azp09 = "N" OR cl_null(g_azp.azp09) THEN
          CALL cl_set_comp_entry("azp10",FALSE)
          LET g_azp.azp10 = 0
          DISPLAY BY NAME g_azp.azp10
       END IF
    END IF
 
END FUNCTION
FUNCTION i901_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_azp.* TO NULL                #No.FUN-6A0015
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i901_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i901_count
    FETCH i901_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i901_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_azp.azp01,SQLCA.sqlcode,0)
       INITIALIZE g_azp.* TO NULL
    ELSE
        CALL i901_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i901_fetch(p_flazp)
    DEFINE
        p_flazp         LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),   
        l_abso          LIKE type_file.num10         #No.FUN-680102 INTEGER
 
    CASE p_flazp
        WHEN 'N' FETCH NEXT     i901_curs INTO g_azp.azp01
        WHEN 'P' FETCH PREVIOUS i901_curs INTO g_azp.azp01
        WHEN 'F' FETCH FIRST    i901_curs INTO g_azp.azp01
        WHEN 'L' FETCH LAST     i901_curs INTO g_azp.azp01
        WHEN '/'
            IF (NOT g_no_ask) THEN                  #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump i901_curs INTO g_azp.azp01
            LET g_no_ask = FALSE         #No.FUN-6A0066
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azp.azp01,SQLCA.sqlcode,0)
        INITIALIZE g_azp.* TO NULL  #TQC-6B0105
        LET g_azp.azp01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flazp
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_azp.* FROM azp_file            # 重讀DB,因TEMP有不被更新特性
       WHERE azp01 = g_azp.azp01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","azp_file",g_azp.azp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE
        CALL i901_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i901_show()
    LET g_azp_t.* = g_azp.*
    DISPLAY BY NAME
        g_azp.azp01,g_azp.azp02,g_azp.azp03,g_azp.azp04,  #FUN-730022 add azp04
        g_azp.azp052,g_azp.azp051,g_azp.azp053,
        g_azp.azp06,g_azp.azp07,
        g_azp.azp09,g_azp.azp10,g_azp.azp20   #No:FUN-7A0086 FUN-960164
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i901_u()
   DEFINE g_azp053_t   LIKE azp_file.azp053
   DEFINE ls_zx05      LIKE zx_file.zx05
   DEFINE li_count     LIKE type_file.num5           #No.FUN-680102SMALLINT
   DEFINE li_max_lim   LIKE type_file.num5           #No.FUN-7B0009
   DEFINE l_rtzpos     LIKE rtz_file.rtzpos          #NO.FUN-B40071
 
    IF g_azp.azp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_azp01_t = g_azp.azp01
    BEGIN WORK
 
    OPEN i901_curl USING g_azp.azp01
    IF STATUS THEN
       CALL cl_err("OPEN i901_curl:", STATUS, 1)
       CLOSE i901_curl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i901_curl INTO g_azp.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_azp.azp01,SQLCA.sqlcode,0)
       CLOSE i901_curl
       ROLLBACK WORK
       RETURN
    END IF
 
    LET g_azp053_t = g_azp.azp053             # MOD-4A0015
    LET g_chg_lim = FALSE                     #No.FUN-7B0009
 
    CALL i901_show()                          # 顯示最新資料
 
    WHILE TRUE
        CALL i901_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_azp.*=g_azp_t.*
            CALL i901_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
#FUN-A80148    --------start
       IF g_azp.azp051 <> g_azp_t.azp051 OR g_azp.azp06 <> g_azp_t.azp06 OR g_azp.azp07 <> g_azp_t.azp07 OR
          (cl_null(g_azp.azp051) AND NOT cl_null(g_azp_t.azp051)) OR
          (cl_null(g_azp.azp06)  AND NOT cl_null(g_azp_t.azp06) ) OR
          (cl_null(g_azp.azp07)  AND NOT cl_null(g_azp_t.azp07) ) OR
          (NOT cl_null(g_azp.azp051) AND cl_null(g_azp_t.azp051)) OR
          (NOT cl_null(g_azp.azp06)  AND cl_null(g_azp_t.azp06) ) OR
          (NOT cl_null(g_azp.azp07)  AND cl_null(g_azp_t.azp07) ) THEN
          #FUN-B40071 --START--
          SELECT rtzpos INTO l_rtzpos FROM rtz_file
           WHERE rtz01 =  g_azp.azp01
          IF l_rtzpos <> '1' THEN
             LET l_rtzpos = '2'
          ELSE
             LET l_rtzpos = '1'
          END IF                   
          #FUN-B40071 --END--
          IF g_azw.azw04='2' THEN
             IF cl_confirm("aoo-423") THEN
                IF g_azp.azp051 <> g_azp_t.azp051 OR
                  (cl_null(g_azp.azp051) AND NOT cl_null(g_azp_t.azp051)) OR
                  (NOT cl_null(g_azp.azp051) AND cl_null(g_azp_t.azp051)) THEN
                     UPDATE rtz_file SET rtz17 = g_azp.azp051,
                                         rtzpos = l_rtzpos,                      #FUN-A80117 #No:FUN-B40071
                                         rtzmodu = g_user,                       #FUN-A80117
                                         rtzdate = g_today                       #FUN-A80117
                     WHERE rtz01 =  g_azp.azp01 
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","rtz_file",g_azp.azp01,"",SQLCA.sqlcode,"","Update rtz_file",1)  
                        CONTINUE WHILE
                     END IF
                END IF     
          
                IF g_azp.azp06 <> g_azp_t.azp06 OR
                  (cl_null(g_azp.azp06) AND NOT cl_null(g_azp_t.azp06)) OR
                  (NOT cl_null(g_azp.azp06) AND cl_null(g_azp_t.azp06)) THEN
                    UPDATE rtz_file SET rtz18 = g_azp.azp06,
                                         rtzpos = l_rtzpos,                      #FUN-A80117 #No:FUN-B40071
                                         rtzmodu = g_user,                       #FUN-A80117
                                         rtzdate = g_today                       #FUN-A80117
                    WHERE rtz01 =  g_azp.azp01 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","rtz_file",g_azp.azp01,"",SQLCA.sqlcode,"","Update rtz_file",1)  
                       CONTINUE WHILE
                    END IF
                END IF         
          
                IF g_azp.azp07 <> g_azp_t.azp07 OR
                  (cl_null(g_azp.azp07) AND NOT cl_null(g_azp_t.azp07)) OR
                  (NOT cl_null(g_azp.azp07) AND cl_null(g_azp_t.azp07)) THEN
                    UPDATE rtz_file SET rtz19 = g_azp.azp07,
                                        rtzpos = l_rtzpos,                      #FUN-A80117 #No:FUN-B40071
                                        rtzmodu = g_user,                       #FUN-A80117
                                        rtzdate = g_today                       #FUN-A80117
                    WHERE rtz01 =  g_azp.azp01 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","rtz_file",g_azp.azp01,"",SQLCA.sqlcode,"","Update rtz_file",1)  
                       CONTINUE WHILE
                    END IF
                END IF
             END IF
          ELSE
             UPDATE rtz_file SET rtz17 = g_azp.azp051,
                                 rtz18 = g_azp.azp06,
                                 rtz19 = g_azp.azp07,
                                 rtzpos = l_rtzpos,                      #FUN-A80117 #No:FUN-B40071
                                 rtzmodu = g_user,                       #FUN-A80117
                                 rtzdate = g_today                       #FUN-A80117
              WHERE rtz01 =  g_azp.azp01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rtz_file",g_azp.azp01,"",SQLCA.sqlcode,"","Update rtz_file",1)
                CONTINUE WHILE
             END IF
          END IF
       END IF
#FUN-A80148  ---------end        
        UPDATE azp_file SET azp_file.* = g_azp.*
        WHERE azp01=g_azp_t.azp01 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","azp_file",g_azp.azp01,"",SQLCA.sqlcode,"","Update azp_file",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
 
        UPDATE azp_file SET azp04=g_azp.azp04 WHERE azp03=g_azp.azp03
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
           CALL cl_err3("upd","azp_file",g_azp.azp04,"",SQLCA.sqlcode,"","",10)
           CONTINUE WHILE
        END IF

        # 2004/11/12 若確定要變更的話, 則連 zx_file.zx08,zxy_file.zxy03一起變
        LET li_count=0
        IF g_azp.azp01 != g_azp01_t THEN
           IF cl_confirm("aoo-024") THEN
              SELECT COUNT(*) INTO li_count FROM zx_file WHERE zx08=g_azp01_t
              IF li_count>0 THEN
                 UPDATE zx_file SET zx08=g_azp.azp01 WHERE zx08=g_azp01_t 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","zx_file",g_azp01_t,"",SQLCA.sqlcode,"","Update zx_file",1)  #No.FUN-660131
                    CONTINUE WHILE
                 END IF
              END IF
              SELECT COUNT(*) INTO li_count FROM zxy_file WHERE zxy03=g_azp01_t
              IF li_count>0 THEN
                 UPDATE zxy_file SET zxy03=g_azp.azp01 WHERE zxy03=g_azp01_t
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","zxy_file",g_azp01_t,"",SQLCA.sqlcode,"","Update zxy_file",1)  #No.FUN-660131
                    CONTINUE WHILE
                 END IF
              END IF
              CALL i901_chk_process_dbs(g_azp01_t,g_azp.azp01,"u")  #No.TQC-870015
           END IF
        END IF
 
        IF g_chg_lim THEN
           #LET g_sql = "SELECT max(gbo03) FROM ",s_dbstring(g_azp.azp03 CLIPPED),"gbo_file WHERE gbo02='Y'"
           LET g_sql = "SELECT max(gbo03) FROM ",cl_get_target_table(g_azp.azp01,'gbo_file'), #FUN-A50102
                       " WHERE gbo02='Y'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		   CALL cl_parse_qry_sql(g_sql,g_azp.azp01) RETURNING g_sql #FUN-A50102 
           PREPARE gbo03_pre_2 FROM g_sql
           EXECUTE gbo03_pre_2 INTO li_max_lim
           IF NOT cl_null(li_max_lim) THEN
              #LET g_sql = "UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"gbo_file SET gbo03=",g_azp.azp10,
              LET g_sql = "UPDATE ",cl_get_target_table(g_azp.azp01,'gbo_file'), #FUN-A50102
                          "   SET gbo03=",g_azp.azp10,
                          " WHERE gbo02='Y' AND gbo03 > ",g_azp.azp10  
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		      CALL cl_parse_qry_sql(g_sql,g_azp.azp01) RETURNING g_sql #FUN-A50102             
              PREPARE gbo03_upd_2 FROM g_sql
              EXECUTE gbo03_upd_2
              MESSAGE ""
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i901_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i901_t()
   #DEFINE l_dbs       LIKE type_file.chr20          #No.FUN-680102CHAR(20)
   DEFINE l_plant      LIKE type_file.chr21          #FUN-A50102 
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
   #DECLARE i901_c3 CURSOR FOR SELECT azp03 FROM azp_file
   DECLARE i901_c3 CURSOR FOR SELECT azp01 FROM azp_file #FUN-A50102 
   #FOREACH i901_c3 INTO l_dbs
   FOREACH i901_c3 INTO l_plant                          #FUN-A50102 
      #LET g_sql="DELETE FROM ",s_dbstring(l_dbs CLIPPED),"azp_file" #TQC-940177   
      LET g_sql="DELETE FROM ",cl_get_target_table(l_plant,'azp_file') #FUN-A50102
      MESSAGE g_sql
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102  
      PREPARE i901_p3 FROM g_sql
      EXECUTE i901_p3
      #LET g_sql="INSERT INTO ",s_dbstring(l_dbs CLIPPED),"azp_file SELECT * FROM azp_file" #TQC-940177
      LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'azp_file'), #FUN-A50102
                " SELECT * FROM azp_file" 
      MESSAGE g_sql
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102 
      PREPARE i901_p4 FROM g_sql
      EXECUTE i901_p4
   END FOREACH
   MESSAGE "Transfer O.K."
END FUNCTION
 
FUNCTION i901_chk_dblink()    #FUN-730022   for Oracle
   DEFINE ls_each   STRING
   DEFINE l_dbname  LIKE azp_file.azp04

   LET ls_each = g_azp.azp04
   LET ls_each = ls_each.toUpperCase()  #MOD-880167
 
   IF NOT ls_each.getIndexOf("@",1) THEN
      LET g_azp.azp04 = "@" || g_azp.azp04
   END IF
 
   LET l_dbname = ls_each.subString(ls_each.getIndexOf("@",1)+1,ls_each.getLength())
 
   SELECT * FROM all_db_links where DB_LINK = l_dbname
   
   IF SQLCA.sqlcode=100 THEN
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i901_add_dblink(serv_name)    #FUN-730022  for Oracle
  DEFINE serv_name   LIKE type_file.chr30,
         l_channel   base.Channel,
         l_fname     STRING,
         l_tmp_file  STRING,
         l_cmd       STRING,
         l_buf       STRING,
         l_flag      LIKE type_file.num5,
         ls_each     STRING,
         l_dbname    LIKE azp_file.azp04,
         l_sql       STRING
  
  LET l_channel = base.Channel.create()
  LET l_fname = FGL_GETENV("ORACLE_HOME")
  LET l_tmp_file = FGL_GETENV("TEMPDIR") 
  LET l_fname = l_fname, "/network/admin/tnsnames.ora"
  LET l_tmp_file = l_tmp_file, "/flag.txt"
  LET l_cmd = "grep ", serv_name , " " , l_fname , " > /dev/null;echo $?>", l_tmp_file
  RUN l_cmd
  
  LET l_flag = FALSE
  CALL l_channel.openFile(l_tmp_file,"r")
  IF STATUS THEN
     CALL l_channel.close()
  ELSE
     WHILE l_channel.read(l_buf)
       IF l_buf MATCHES "0*" THEN
          LET l_flag = TRUE
       END IF
     END WHILE
     CALL l_channel.close()
  END IF
 
  LET ls_each = g_azp.azp04
  LET l_dbname = ls_each.subString(ls_each.getIndexOf("@",1)+1,ls_each.getLength())
 
  IF l_flag THEN       
     LET l_sql = "echo ""CREATE PUBLIC DATABASE LINK ", l_dbname , " USING '" , serv_name, "';""|sqlplus '/as sysdba' > /dev/null 2>&1"
     DISPLAY l_sql
     RUN l_sql
  ELSE
     CALL cl_err("","aoo-990",1)
     RETURN FALSE
  END IF
 
  SELECT * FROM all_db_links where DB_LINK = l_dbname
 
  IF SQLCA.sqlcode=100 THEN
     CALL cl_err('DBlink create failed!', '!', 1)
  ELSE
     CALL cl_err('DBlink create successfully!', '!', 1)
  END IF
  
  RETURN TRUE
END FUNCTION
 
FUNCTION i901_chk_msv_dbname()   
  DEFINE ls_each  STRING
 
  LET ls_each = g_azp.azp03
 
  IF ls_each.getIndexOf("@",1) THEN
     RETURN FALSE
  ELSE 
     RETURN TRUE
  END IF
  IF ls_each.getIndexOf(".dbo.",1) THEN
     RETURN FALSE
  ELSE 
     RETURN TRUE
  END IF
 
END FUNCTION
 
 
FUNCTION i901_chk_ora_dbname()    #FUN-730022  for Oracle
  DEFINE ls_each  STRING
 
  LET ls_each = g_azp.azp03
 
  IF ls_each.getIndexOf("@",1) THEN
     RETURN FALSE
  ELSE 
     RETURN TRUE
  END IF
 
END FUNCTION
 
FUNCTION i901_get_dbname()    #FUN-730022 
  DEFINE ls_each   STRING
  DEFINE l_dbname  LIKE azp_file.azp03
 
  LET ls_each = g_azp.azp03
 
  IF NOT ls_each.getIndexOf("@",1) THEN
     SELECT * FROM sysmaster:sysdatabases
      WHERE name=g_azp.azp03
     IF SQLCA.SQLCODE THEN
        CALL cl_err_msg(NULL,"aoo-086",g_azp.azp03 CLIPPED,10)
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  ELSE
     LET l_dbname = ls_each.subString(1,ls_each.getIndexOf("@",1)-1)
     SELECT * FROM sysmaster:sysdatabases
      WHERE name=l_dbname
     IF SQLCA.SQLCODE THEN
        CALL cl_err_msg(NULL,"aoo-086",g_azp.azp03 CLIPPED,10)
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  END IF
 
END FUNCTION
 
FUNCTION i901_chk_process_dbs(pc_dbs_old,pc_dbs_new,pc_cmd)
   DEFINE pc_dbs_old LIKE azp_file.azp01
   DEFINE pc_dbs_new LIKE azp_file.azp01
   DEFINE pc_cmd     LIKE type_file.chr1
   DEFINE g_gbq01    LIKE gbq_file.gbq01
   DEFINE g_gbq02    LIKE gbq_file.gbq02
   DEFINE g_gbq03    LIKE gbq_file.gbq03
   DEFINE g_gbq10    LIKE gbq_file.gbq10
 
   LET g_sql = "SELECT gbq01,gbq02,gbq03,gbq10 FROM gbq_file "
   IF cl_db_get_database_type() = "ORA" THEN
      LET g_sql = g_sql," WHERE gbq10 LIKE '%",pc_dbs_old CLIPPED,"%' AND gbq10 IS NOT NULL"
   ELSE
      LET g_sql = g_sql," WHERE gbq10 MATCHES '*",pc_dbs_old CLIPPED,"*' AND gbq10 IS NOT NULL"
   END IF
   PREPARE gbq_pre FROM g_sql
   DECLARE gbq_curs CURSOR FOR gbq_pre
 
   FOREACH gbq_curs INTO g_gbq01,g_gbq02,g_gbq03,g_gbq10
      CASE
         WHEN pc_cmd = "u"
            LET g_gbq10 = cl_replace_str(g_gbq10 CLIPPED,pc_dbs_old,pc_dbs_new)
            UPDATE gbq_file SET gbq10 = g_gbq10
             WHERE gbq01 = g_gbq01 AND gbq02 = g_gbq02 AND gbq03 = g_gbq03
         WHEN pc_cmd = "d"
            DELETE FROM gbq_file WHERE gbq01 = g_gbq01 AND gbq02 = g_gbq02 AND gbq03 = g_gbq03
      END CASE
   END FOREACH
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#FUN-AA0054
