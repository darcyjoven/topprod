# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agli109.4gl
# Descriptions...: 科目異動碼值維護作業
# Date & Author..: 92/08/27 By Nora
# Modify.........: By Melody    新增列印功能 (_out)
# Modify.........: By Melody    aee00 改為 no-use
# Modify.........: No.MOD-480621 04/09/15 By Nicola AFTER FIELD aee01有問題
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-510007 05/02/16 By Nicola 報表架構修改
# Modify.........: No.FUN-590124 05/10/05 By Dido aag02科目名稱放寬
# Modify.........: No.FUN-5C0015 060102 BY GILL
#                  (1)異動碼順序aee02，選項增加5~10, 99
#                  新增「異動碼類型代號」aee021與「異動碼名稱」ahe02
# Modify.........: No.FUN-5C0015 060210 BY GILL
#                  新增資料時,判斷此異動碼其對應的類型之資料來源非2預設值者,
#                  ahe03 != '2' 就不可輸入
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.MOD-680104 06/09/05 By Smapmin 刪除資料時,先判斷是否有傳票已使用該異動碼
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/18 By Carrier 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/30 By sherry  報表改由Crystal Report輸出                                                     
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-920183 09/02/13 By Smapmin 刪除時程式會當掉
# Modify.........: No.TQC-950047 09/05/08 By xiaofeizhu 如一科目未做核算項管理，進入核算項順序欄位則報錯（agl-182,不做核算項管理），
# Modify.........:                                      無法點選其他欄位，只能退出重新錄入,修改為進入科目編號欄
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-960185 09/06/17 By sabrina (1)_u()的sql寫法有誤，欄位名稱應該aee01而非g_aee01 
#                                                    (2)i109_aee02()中的DISPLAY xxxx TO FORMONLY.aag15，但畫面檔沒有aag15
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_aee   RECORD LIKE aee_file.*,
    g_aee_t RECORD LIKE aee_file.*,
    g_aee_o RECORD LIKE aee_file.*,
    g_aee00_t LIKE aee_file.aee00,   #No.FUN-730020
    g_aee01_t LIKE aee_file.aee01,
    g_aee02_t LIKE aee_file.aee02,
    g_aee03_t LIKE aee_file.aee03,
    g_wc,g_sql      STRING,  #No.FUN-580092 HCN  
    g_aee00          LIKE aee_file.aee00,  #No.FUN-730020
    g_aee01          LIKE aee_file.aee01,
    g_aee02          LIKE aee_file.aee02,
    g_flag           LIKE type_file.chr1,          #No.FUN-680098CHAR(1)
    g_aag15          LIKE aag_file.aag15,
    g_aag16          LIKE aag_file.aag16,
    g_aag17          LIKE aag_file.aag17,
    g_aag18          LIKE aag_file.aag18,
    g_aag151         LIKE aag_file.aag151,
    g_aag161         LIKE aag_file.aag161,
    g_aag171         LIKE aag_file.aag171,
    g_aag181         LIKE aag_file.aag181
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose   #No.FUN-680098SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
#FUN-5C0015 BY GILL --START
DEFINE
    g_aag31            LIKE aag_file.aag31,
    g_aag32            LIKE aag_file.aag32,
    g_aag33            LIKE aag_file.aag33,
    g_aag34            LIKE aag_file.aag34,
    g_aag35            LIKE aag_file.aag35,
    g_aag36            LIKE aag_file.aag36,
    g_aag37            LIKE aag_file.aag37,
    g_aag311           LIKE aag_file.aag311,
    g_aag321           LIKE aag_file.aag321,
    g_aag331           LIKE aag_file.aag331,
    g_aag341           LIKE aag_file.aag341,
    g_aag351           LIKE aag_file.aag351,
    g_aag361           LIKE aag_file.aag361,
    g_aag371           LIKE aag_file.aag371,
    g_ahe02            LIKE ahe_file.ahe02,
    g_ahe03            LIKE ahe_file.ahe03
#FUN-5C0015 BY GILL --END
#No.FUN-760085---Begin                                                                                                              
DEFINE g_str           STRING                                                                                                     
DEFINE l_sql           STRING                                                                                                     
DEFINE l_table         STRING                                                                                                     
DEFINE g_bookno        LIKE aee_file.aee00  
#No.FUN-760085---End             
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0073
      DEFINE
           p_row,p_col LIKE type_file.num5      #No.FUN-680098 SMALLINT
 
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
   #No.FUN-760085---Begin
   LET g_sql = "aeeacti.aee_file.aeeacti,",
               "aee00.aee_file.aee00,",
               "aee01.aee_file.aee01,",
               "aag02.aag_file.aag02,",
               "aee02.aee_file.aee02,",
               "ahe02.ahe_file.ahe02,",
               "aee03.aee_file.aee03,",
               "aee04.aee_file.aee04 "
 
   LET l_table = cl_prt_temptable('agli109',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?) "                                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #NO.FUN-760085---End    
 
    INITIALIZE g_aee.* TO NULL
    INITIALIZE g_aee_t.* TO NULL
    INITIALIZE g_aee_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM aee_file       ",
                       " WHERE aee00 = ? AND aee01 = ? AND aee02 = ? AND aee03 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i109_cl CURSOR  FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 30
    OPEN WINDOW i109_w AT p_row,p_col
        WITH FORM "agl/42f/agli109"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
     LET g_aee00 = ARG_VAL(1)     #No.FUN-730020
     LET g_aee02 = ARG_VAL(2)     #No.MOD-4C0171
     LET g_aee01 = ARG_VAL(3)     #No.MOD-4C0171
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i109_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i109_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i109_cs()
    CLEAR FORM
 
   INITIALIZE g_aee.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        aee00,aee01,aee02,  #No.FUN-730020
        aee021,                        #異動碼類型代號 FUN-5C0015 BY GILL
        aee03,aee04,
        aeeuser,aeegrup,aeemodu,aeedate,aeeacti
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
        ON ACTION controlp
         CASE
            WHEN INFIELD(aee00) #FUN-5C0015 BY GILL
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aaa"
                 LET g_qryparam.state= "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aee00
                 NEXT FIELD aee00
 
            WHEN INFIELD(aee01) #FUN-5C0015 BY GILL
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state= "c"
                 LET g_qryparam.where=" aag07 MATCHES '[23]'"
                 LET g_qryparam.default1 = g_aee.aee01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aee01
                 CALL i109_aee01('a')
 
         #FUN-5C0015 BY GILL --START
            WHEN INFIELD(aee021)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ahe"
                   LET g_qryparam.state    = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aee021
                   NEXT FIELD aee021
         END CASE
         #FUN-5C0015 BY GILL --END
 
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND aeeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND aeegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND aeegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aeeuser', 'aeegrup')
    #End:FUN-980030
 
    LET g_sql="SELECT aee00,aee01,aee02,aee03 ",  #No.FUN-730020 #TQC-870018
              "  FROM aee_file ", # 組合出 SQL 指令
        " WHERE 1=1 AND ", g_wc CLIPPED, " ORDER BY aee00,aee01,aee02,aee03"  #No.FUN-730020
    PREPARE i109_prepare FROM g_sql           # RUNTIME 編譯
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) RETURN END IF
    DECLARE i109_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i109_prepare
    LET g_sql= "SELECT COUNT(*) FROM aee_file ",
                     " WHERE 1=1 AND ",g_wc CLIPPED
    PREPARE i109_precount FROM g_sql
    DECLARE i109_count CURSOR FOR i109_precount
END FUNCTION
 
FUNCTION i109_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i109_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i109_q()
            END IF
        ON ACTION next
            CALL i109_fetch('N')
        ON ACTION previous
            CALL i109_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i109_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i109_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i109_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i109_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i109_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #CKP
           CALL cl_set_field_pic("","","","","",g_aee.aeeacti)
            LET g_action_choice = "exit"
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i109_fetch('/')
        ON ACTION first
            CALL i109_fetch('F')
        ON ACTION last
            CALL i109_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_aee.aee01 IS NOT NULL THEN
                 #No.FUN-730020  --Begin
                 LET g_doc.column1 = "aee00"
                 LET g_doc.value1 = g_aee.aee00
                 LET g_doc.column2 = "aee01"
                 LET g_doc.value2 = g_aee.aee01
                 LET g_doc.column3 = "aee02"
                 LET g_doc.value3 = g_aee.aee02
                 LET g_doc.column4 = "aee03"
                 LET g_doc.value4 = g_aee.aee03
                 #No.FUN-730020  --End  
                 CALL cl_doc()
              END IF
           END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i109_cs
END FUNCTION
 
 
FUNCTION i109_a()
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_aee.* LIKE aee_file.*
    LET g_aee00_t = NULL   #No.FUN-730020
    LET g_aee01_t = NULL
    LET g_aee02_t = NULL
    LET g_aee03_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aee.aee00   = g_aee00   #No.FUN-730020
        LET g_aee.aee01   = g_aee01
        LET g_aee.aee02   = g_aee02
        LET g_aee.aeeacti ='Y'                   #有效的資料
        LET g_aee.aeeuser = g_user
        LET g_aee.aeeoriu = g_user #FUN-980030
        LET g_aee.aeeorig = g_grup #FUN-980030
        LET g_aee.aeegrup = g_grup               #使用者所屬群
        LET g_aee.aeedate = g_today
        CALL i109_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_aee.aee01 IS NULL OR g_aee.aee02 IS NULL 
        OR g_aee.aee00 IS NULL THEN  # KEY 不可空白  #No.FUN-730020
            CONTINUE WHILE
        END IF
        INSERT INTO aee_file VALUES(g_aee.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","aee_file",g_aee.aee01,g_aee.aee02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        ELSE
            LET g_aee_t.* = g_aee.*                # 保存上筆資料
            SELECT aee01 INTO g_aee.aee01 FROM aee_file
                WHERE aee01 = g_aee.aee01
                      AND aee02 = g_aee.aee02 AND aee03 = g_aee.aee03
                      AND aee00 = g_aee.aee00  #No.FUN-730020
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i109_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680098 SMALLINT
 
    INPUT BY NAME g_aee.aeeoriu,g_aee.aeeorig,g_aee.aee00,g_aee.aee01,g_aee.aee02,g_aee.aee03,g_aee.aee04,  #No.FUN-730020
                  g_aee.aee05,g_aee.aee06,
                  g_aee.aeeuser,g_aee.aeegrup,g_aee.aeemodu,g_aee.aeedate,
                  g_aee.aeeacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            IF p_cmd='u' THEN
                CALL cl_set_act_visible("controlo", FALSE)
            ELSE
                CALL cl_set_act_visible("controlo", TRUE)
            END IF
            LET g_before_input_done = FALSE
            CALL i109_set_entry(p_cmd)
            CALL i109_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        #No.FUN-730020  --Begin
        AFTER FIELD aee00
            IF NOT cl_null(g_aee.aee00) THEN
                IF g_aee.aee00 !=g_aee00_t OR cl_null(g_aee00_t) THEN   #No.MOD-480621
                  CALL i109_aee00('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD aee00
                  END IF
               END IF
            END IF
        #No.FUN-730020  --End  
 
        AFTER FIELD aee01
            IF cl_null(g_aee.aee00) THEN NEXT FIELD aee00 END IF  #No.FUN-730020
            IF NOT cl_null(g_aee.aee01) THEN
                IF g_aee.aee01 !=g_aee01_t OR cl_null(g_aee01_t) THEN   #No.MOD-480621
                  CALL i109_aee01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     #Add No.FUN-B10048
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag"
                     LET g_qryparam.construct = 'N'
                     LET g_qryparam.where=" aag07 MATCHES '[23]' AND aag01 LIKE '",g_aee.aee01 CLIPPED,"%'"
                     LET g_qryparam.default1 = g_aee.aee01
                     LET g_qryparam.arg1     = g_aee.aee00
                     CALL cl_create_qry() RETURNING g_aee.aee01
                     DISPLAY BY NAME g_aee.aee01
                     #End Add No.FUN-B10048
                     NEXT FIELD aee01
                  END IF
               END IF
            END IF
            CALL i109_aee021()   #FUN-5C0015 BY GILL
 
 
        AFTER FIELD aee02
            IF NOT cl_null(g_aee.aee02) THEN
               #FUN-5C0015 BY GILL --START
               #IF g_aee.aee02 NOT MATCHES "[1234]" THEN
               IF g_aee.aee02 NOT MATCHES "[123456789]" AND
                  g_aee.aee02 !='10' AND
                  g_aee.aee02 !='99'THEN
               #FUN-5C0015 BY GILL --END
                  NEXT FIELD aee02
               END IF
               CALL i109_aee02()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
#                 NEXT FIELD aee02                         #TQC-950047 Mark                                                         
                  NEXT FIELD aee01                         #TQC-950047
               END IF
            END IF
            #FUN-5C0015 BY GILL --START
            CALL i109_aee021()
            IF cl_null(g_ahe03) OR g_ahe03 != '2' THEN
               #此科目設定對應的異動碼類型非'2'預設值，無法新增，請重新輸入
               CALL cl_err(g_aee.aee01,'agl-062',0)
               NEXT FIELD aee02
            END IF
            #FUN-5C0015 BY GILL --END
 
        AFTER FIELD aee03
            IF NOT cl_null(g_aee.aee03) THEN
               IF p_cmd = 'a' OR p_cmd ='u' AND   #No.FUN-730020
                  (g_aee.aee01 != g_aee01_t OR g_aee.aee02 != g_aee02_t OR
                   g_aee.aee03 != g_aee03_t OR g_aee.aee00 != g_aee00_t) THEN  #No.FUN-730020
                   SELECT count(*) INTO l_n FROM aee_file
                    WHERE aee01 = g_aee.aee01 AND aee02 = g_aee.aee02
                      AND aee03 = g_aee.aee03 AND aee00 = g_aee.aee00  #No.FUN-730020
                   IF l_n > 0 THEN   #Duplicated
                      CALL cl_err(g_msg,-239,0)
                      LET g_msg = g_aee.aee01 CLIPPED,'+',g_aee.aee02
                      LET g_aee.aee00 = g_aee00_t  #No.FUN-730020
                      LET g_aee.aee01 = g_aee01_t
                      LET g_aee.aee02 = g_aee02_t
                      LET g_aee.aee03 = g_aee03_t
                      DISPLAY BY NAME g_aee.aee00  #No.FUN-730020
                      DISPLAY BY NAME g_aee.aee01
                      DISPLAY BY NAME g_aee.aee02
                      DISPLAY BY NAME g_aee.aee03
                      NEXT FIELD aee00  #No.FUN-730020
                   END IF
               END IF
            END IF
 
## No:2445 modify 1998/09/28 -------
        AFTER INPUT #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aee.aeeuser = s_get_data_owner("aee_file") #FUN-C10039
           LET g_aee.aeegrup = s_get_data_group("aee_file") #FUN-C10039
{
            LET l_flag = 'N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_aee.aee01) THEN
               LET l_flag ='Y'
               DISPLAY BY NAME g_aee.aee01
            END IF
            IF cl_null(g_aee.aee02) THEN
               LET l_flag ='Y'
               DISPLAY BY NAME g_aee.aee02
            END IF
            IF cl_null(g_aee.aee03) THEN
               LET l_flag ='Y'
               DISPLAY BY NAME g_aee.aee03
            END IF
            IF l_flag = 'Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD aee01
            END IF
}
 
        #MOD-650015 --start 
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(aee01) THEN
      #          LET g_aee.* = g_aee_t.*
      #          LET g_aee.aee05 = NULL
      #          LET g_aee.aee06 = NULL
      #          LET g_aee.aeemodu = NULL
      #          LET g_aee.aeeacti ='Y'                   #有效的資料
      #          LET g_aee.aeeuser = g_user
      #          LET g_aee.aeegrup = g_grup               #使用者所屬群
      #          LET g_aee.aeedate = g_today
      #          DISPLAY BY NAME
      #             g_aee.aee01,g_aee.aee02,g_aee.aee03,g_aee.aee04,g_aee.aee05,g_aee.aee06,
      #             g_aee.aeeuser,g_aee.aeegrup,g_aee.aeemodu,g_aee.aeedate, g_aee.aeeacti
      #          CALL i109_aee01('d')
      #          NEXT FIELD aee01
      #      END IF
        #MOD-650015 --end
 
        ON ACTION controlp
           #No.FUN-730020  --Begin
           CASE
              WHEN INFIELD(aee00) #帳別  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = g_aee.aee00
                 CALL cl_create_qry() RETURNING g_aee.aee00
                 DISPLAY BY NAME g_aee.aee00
                 CALL i109_aee00('d')
                 NEXT FIELD aee00
              WHEN INFIELD(aee01) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where=" aag07 MATCHES '[23]'"
                 LET g_qryparam.default1 = g_aee.aee01
                 LET g_qryparam.arg1     = g_aee.aee00
                 CALL cl_create_qry() RETURNING g_aee.aee01
                 DISPLAY BY NAME g_aee.aee01
                 CALL i109_aee01('a')
           END CASE
           #No.FUN-730020  --End  
 
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
 
FUNCTION i109_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aee00,aee01,aee02,aee03",TRUE)  #No.FUN-730020
    END IF
 
END FUNCTION
 
FUNCTION i109_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aee00,aee01,aee02,aee03",FALSE)  #No.FUN-730020
    END IF
 
END FUNCTION
 
FUNCTION i109_aee01(p_cmd)
      DEFINE p_cmd LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
               l_aag02      LIKE aag_file.aag02,
               l_aagacti    LIKE aag_file.aagacti
 
      LET g_errno = ''
 
      #FUN-5C0015 BY GILL --START
      #SELECT aag02,aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,aagacti
      #      INTO l_aag02,g_aag15,g_aag151,g_aag16,g_aag161,g_aag17,g_aag171,
      #           g_aag18,g_aag181,l_aagacti
 
      SELECT aag02,aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,aagacti,
             aag31,aag32,aag33,aag34,aag35,aag36,aag37,
             aag311,aag321,aag331,aag341,aag351,aag361,aag371
             INTO l_aag02,g_aag15,g_aag151,g_aag16,g_aag161,g_aag17,g_aag171,
                  g_aag18,g_aag181,l_aagacti,
                  g_aag31,g_aag32,g_aag33,g_aag34,g_aag35,g_aag36,g_aag37,
                  g_aag311,g_aag321,g_aag331,g_aag341,g_aag351,g_aag361,g_aag371
      #FUN-5C0015 BY GILL --END
 
            FROM aag_file WHERE aag01 = g_aee.aee01
                            AND aag00 = g_aee.aee00  #No.FUN-730020
      CASE
            WHEN l_aagacti = 'N' LET g_errno = '9027'
                     display "l_aagacti='N'"
            WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
            OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
           DISPLAY l_aag02 TO FORMONLY.aag02
      END IF
END FUNCTION
 
#No.FUN-730020  --Begin
FUNCTION i109_aee00(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aaaacti LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=g_aee.aee00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-730020  --End
 
FUNCTION i109_aee02()
      LET g_errno = ''
      CASE g_aee.aee02
           #WHEN '1' DISPLAY g_aag15 TO FORMONLY.aag15   #TQC-960185 mark
            WHEN '1'                                     #TQC-960185 add 
                         IF cl_null(g_aag151) THEN
                             LET g_errno = 'agl-182' #不做異動碼管理
                         END IF
           #WHEN '2' DISPLAY g_aag16 TO FORMONLY.aag15   #TQC-960185 mark
            WHEN '2'                                     #TQC-960185 add 
                         IF cl_null(g_aag161) THEN
                             LET g_errno = 'agl-182' #不做異動碼管理
                         END IF
           #WHEN '3' DISPLAY g_aag17 TO FORMONLY.aag15   #TQC-960185 mark
            WHEN '3'                                     #TQC-960185 add 
                         IF cl_null(g_aag171) THEN
                             LET g_errno = 'agl-182' #不做異動碼管理
                         END IF
           #WHEN '4' DISPLAY g_aag18 TO FORMONLY.aag15   #TQC-960185 mark
            WHEN '4'                                     #TQC-960185 add 
                         IF cl_null(g_aag181) THEN
                             LET g_errno = 'agl-182' #不做異動碼管理
                         END IF
 
            #FUN-5C0015 BY GILL --START
            WHEN '5'
               IF cl_null(g_aag311) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            WHEN '6'
               IF cl_null(g_aag321) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            WHEN '7'
               IF cl_null(g_aag331) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            WHEN '8'
               IF cl_null(g_aag341) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            WHEN '9'
               IF cl_null(g_aag351) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            WHEN '10'
               IF cl_null(g_aag361) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            WHEN '99'
               IF cl_null(g_aag371) THEN
                   LET g_errno = 'agl-182' #不做異動碼管理
               END IF
            #FUN-5C0015 BY GILL --END
 
            OTHERWISE EXIT CASE
      END CASE
END FUNCTION
 
FUNCTION i109_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aee.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i109_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i109_count
    FETCH i109_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i109_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)
        INITIALIZE g_aee.* TO NULL
    ELSE
        CALL i109_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i109_fetch(p_flaee)
    DEFINE
        p_flaee         LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)   
        l_abso          LIKE type_file.num10         #No.FUN-680098 INTEGER
 
    CASE p_flaee
        WHEN 'N' FETCH NEXT     i109_cs INTO g_aee.aee00,g_aee.aee01,  #No.FUN-730020
                                             g_aee.aee02,g_aee.aee03 #TQC-870018
                                             
        WHEN 'P' FETCH PREVIOUS i109_cs INTO g_aee.aee00,g_aee.aee01,  #No.FUN-730020
                                             g_aee.aee02,g_aee.aee03 #TQC-870018
                                             
        WHEN 'F' FETCH FIRST    i109_cs INTO g_aee.aee00,g_aee.aee01,  #No.FUN-730020
                                             g_aee.aee02,g_aee.aee03 #TQC-870018
                                             
        WHEN 'L' FETCH LAST     i109_cs INTO g_aee.aee00,g_aee.aee01,  #No.FUN-730020
                                             g_aee.aee02,g_aee.aee03 #TQC-870018
                                             
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
            FETCH ABSOLUTE g_jump i109_cs INTO g_aee.aee00,g_aee.aee01,  #No.FUN-730020
                                                g_aee.aee02,g_aee.aee03 #TQC-870018
                                                
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)
        INITIALIZE g_aee.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flaee
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_aee.* FROM aee_file        # 重讀DB,因TEMP有不被更新特性
       WHERE aee00 = g_aee.aee00 AND aee01 = g_aee.aee01 AND aee02 = g_aee.aee02 AND aee03 = g_aee.aee03
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","aee_file",g_aee.aee01,g_aee.aee02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
       LET g_data_owner = g_aee.aeeuser     #No.FUN-4C0048
       LET g_data_group = g_aee.aeegrup     #No.FUN-4C0048
       CALL i109_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i109_show()
    LET g_aee_t.* = g_aee.*
    LET g_aee_o.*=g_aee.*
    DISPLAY BY NAME g_aee.aee01,g_aee.aee02,g_aee.aee03,g_aee.aee04, g_aee.aeeoriu,g_aee.aeeorig,
                    g_aee.aee05,g_aee.aee06,
                    g_aee.aee00,   #No.FUN-730020
                    g_aee.aeeuser,g_aee.aeegrup,g_aee.aeemodu,
                    g_aee.aeedate,g_aee.aeeacti
    #CKP
    CALL cl_set_field_pic("","","","","",g_aee.aeeacti)
      CALL i109_aee01('d')
      CALL i109_aee02()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
    CALL i109_aee021() #FUN-5C0015 BY GILL
 
END FUNCTION
 
FUNCTION i109_u()
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aee.aee01 IS NULL OR g_aee.aee00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
  #TQC-960185---modify---start---
   #SELECT * INTO g_aee.* FROM aee_file WHERE g_aee01=g_aee.aee01
   #   AND g_aee02=g_aee.aee02 AND g_aee03=g_aee.aee03
   #   AND g_aee00=g_aee.aee00   #No.FUN-730020
    SELECT * INTO g_aee.* FROM aee_file WHERE aee01=g_aee.aee01
       AND aee02=g_aee.aee02 AND aee03=g_aee.aee03
       AND aee00=g_aee.aee00  
  #TQC-960185---modify---end---
    IF g_aee.aeeacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_aee.aee01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aee00_t = g_aee.aee00  #No.FUN-730020
    LET g_aee01_t = g_aee.aee01
    LET g_aee02_t = g_aee.aee02
    LET g_aee03_t = g_aee.aee03
    BEGIN WORK
 
    OPEN i109_cl USING g_aee.aee00,g_aee.aee01,g_aee.aee02,g_aee.aee03
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_aee.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_aee.aeemodu=g_user                     #修改者
    LET g_aee.aeedate = g_today                  #修改日期
    CALL i109_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i109_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aee.*=g_aee_t.*
            CALL i109_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aee_file SET aee_file.* = g_aee.*    # 更新DB
            WHERE aee00 = g_aee00_t AND aee01 = g_aee01_t  AND aee02 = g_aee02_t AND aee03 = g_aee03_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","aee_file",g_aee.aee01,g_aee.aee02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i109_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aee.aee01 IS NULL OR g_aee.aee00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i109_cl USING g_aee.aee00,g_aee.aee01,g_aee.aee02,g_aee.aee03
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_aee.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i109_show()
    IF cl_exp(15,21,g_aee.aeeacti) THEN
        LET g_chr=g_aee.aeeacti
        IF g_aee.aeeacti='Y' THEN
            LET g_aee.aeeacti='N'
        ELSE
            LET g_aee.aeeacti='Y'
        END IF
        UPDATE aee_file
            SET aeeacti=g_aee.aeeacti,
               aeemodu=g_user, aeedate=g_today
            WHERE aee00 = g_aee.aee00 AND aee01 = g_aee.aee01 AND aee02 = g_aee.aee02 AND aee03 = g_aee.aee03
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","aee_file",g_aee.aee01,g_aee.aee02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            LET g_aee.aeeacti=g_chr
        END IF
        DISPLAY BY NAME g_aee.aeeacti
    END IF
    CLOSE i109_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic("","","","","",g_aee.aeeacti)
 
END FUNCTION
 
FUNCTION i109_r()
    DEFINE
        l_chr LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)
        l_sql STRING,     #MOD-680104
        l_cnt LIKE type_file.num5          #MOD-680104  #No.FUN-680098 SMALINT
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aee.aee01 IS NULL OR g_aee.aee00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i109_cl USING g_aee.aee00,g_aee.aee01,g_aee.aee02,g_aee.aee03
    IF STATUS THEN
       CALL cl_err("OPEN i109_cl:", STATUS, 1)
       CLOSE i109_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i109_cl INTO g_aee.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i109_show()
    #-----MOD-680104---------
    LET l_sql = ""
    CASE g_aee.aee02
       WHEN "1"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb11='",g_aee.aee03,"'"
       WHEN "2"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb12='",g_aee.aee03,"'"
       WHEN "3"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb13='",g_aee.aee03,"'"
       WHEN "4"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb14='",g_aee.aee03,"'"
       WHEN "5"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb31='",g_aee.aee03,"'"
       WHEN "6"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb32='",g_aee.aee03,"'"
       WHEN "7"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb33='",g_aee.aee03,"'"
       WHEN "8"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb34='",g_aee.aee03,"'"
       WHEN "9"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                      "   AND abb35='",g_aee.aee03,"'"
       WHEN "10"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                     "   AND abb36='",g_aee.aee03,"'"
       #-----MOD-920183---------
       WHEN "99"
          LET l_sql = "SELECT COUNT(*) FROM abb_file",
                      "   WHERE abb03 ='",g_aee.aee01,"'",
                      "   AND abb00 ='",g_aee.aee00,"'",  #No.FUN-730020
                     "   AND abb37='",g_aee.aee03,"'"
       #-----END MOD-920183-----
    END CASE
    LET l_cnt = 0
    PREPARE aee_p FROM l_sql
    EXECUTE aee_p INTO l_cnt
    IF l_cnt > 0 THEN
       CALL cl_err(g_aee.aee01,'agl-220',0)
       ROLLBACK WORK
       RETURN
    END IF
    #-----END MOD-680104-----
 
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aee00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aee.aee00      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "aee01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_aee.aee01      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "aee02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_aee.aee02      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "aee03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_aee.aee03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM aee_file WHERE aee01 = g_aee.aee01
                   AND aee02 = g_aee.aee02 AND aee03 = g_aee.aee03
                   AND aee00 = g_aee.aee00   #No.FUN-730020
            IF SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err(g_aee.aee01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aee_file",g_aee.aee01,g_aee.aee02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            ELSE
               CLEAR FORM
               OPEN i109_count
               #FUN-B50062-add-start--
               IF STATUS THEN
                  CLOSE i109_cs
                  CLOSE i109_count
                  COMMIT WORK
                  RETURN
               END IF
               #FUN-B50062-add-end--
               FETCH i109_count INTO g_row_count
               #FUN-B50062-add-start--
               IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                  CLOSE i109_cs
                  CLOSE i109_count
                  COMMIT WORK
                  RETURN
               END IF
               #FUN-B50062-add-end--
               DISPLAY g_row_count TO FORMONLY.cnt
               OPEN i109_cs
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL i109_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET mi_no_ask = TRUE
                  CALL i109_fetch('/')
               END IF
            END IF
    END IF
    CLOSE i109_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i109_copy()
   DEFINE l_aee           RECORD LIKE aee_file.*,
          l_aag02           LIKE aag_file.aag02,
          l_aaaacti         LIKE aaa_file.aaaacti, #No.FUN-730020
          l_oldno0,l_newno0 LIKE aee_file.aee00,   #No.FUN-730020
          l_oldno1,l_newno1 LIKE aee_file.aee01,
          l_oldno2,l_newno2 LIKE aee_file.aee02,
          l_oldno3,l_newno3 LIKE aee_file.aee03
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aee.aee01 IS NULL OR g_aee.aee00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_aee.* = g_aee.*
    LET l_aee.aee00  =NULL  #資料鍵值  #No.FUN-730020
    LET l_aee.aee01  =NULL  #資料鍵值
    LET l_aee.aee02  =NULL  #資料鍵值
    LET l_aee.aee03  =NULL  #資料鍵值
    LET l_aee.aee05  =NULL
    LET l_aee.aee06  =NULL
    LET l_aee.aeeuser=g_user    #資料所有者
    LET l_aee.aeegrup=g_grup    #資料所有者所屬群
    LET l_aee.aeemodu=NULL      #資料修改日期
    LET l_aee.aeedate=g_today   #資料建立日期
    LET l_aee.aeeacti='Y'       #有效資料
    DISPLAY BY NAME l_aee.aee01,l_aee.aee02,l_aee.aee03,l_aee.aee04,
                  l_aee.aee05,l_aee.aee06,
                  l_aee.aee00,   #No.FUN-730020
                  l_aee.aeeuser,l_aee.aeegrup,l_aee.aeemodu,l_aee.aeedate,
                  l_aee.aeeacti
    DISPLAY NULL TO FORMONLY.aag02
 
    LET g_before_input_done = FALSE
    CALL i109_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno0,l_newno1,l_newno2,l_newno3 FROM aee00,aee01,aee02,aee03  #No.FUN-730020
 
        #No.FUN-730020  --Begin
        AFTER FIELD aee00
            IF cl_null(l_newno0) THEN NEXT FIELD aee00 END IF
            IF NOT cl_null(l_newno0) THEN                                      
               SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
                WHERE aaa01=l_newno0
               IF SQLCA.SQLCODE=100 THEN                                            
                  CALL cl_err3("sel","aaa_file",l_newno0,"",100,"","",1)            
                  NEXT FIELD aee00                                                 
               END IF                                                               
               IF l_aaaacti='N' THEN                                                
                  CALL cl_err(l_newno0,"9028",1)                                    
                  NEXT FIELD aee00                                                 
               END IF                                                               
            END IF
        #No.FUN-730020  --End  
 
        AFTER FIELD aee01
          IF NOT cl_null(l_newno1) THEN
             SELECT aag02 INTO l_aag02 FROM aag_file
              WHERE aag01 = l_newno1
                AND aag00 = l_newno0  #No.FUN-730020
                AND aagacti = 'Y'
             IF SQLCA.sqlcode THEN
#               CALL cl_err(l_newno1,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("sel","aag_file",l_newno1,"",SQLCA.sqlcode,"","",0)  #No.FUN-660123  #No.FUN-B10048 1->0
                #Add No.FUN-B10048
                CALL cl_init_qry_var()
                LET g_qryparam.form =  "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where=" aag07 MATCHES '[23]' AND aag01 LIKE '",l_newno1 CLIPPED,"%'"
                LET g_qryparam.arg1 = l_newno0
                LET g_qryparam.default1 = l_newno1
                CALL cl_create_qry() RETURNING l_newno1
                DISPLAY l_newno1 TO aee01
                #End Add No.FUN-B10048
                NEXT FIELD aee01
             END IF
          END IF
          CALL i109_aee021()   #FUN-5C0015 BY GILL
 
 
 
        AFTER FIELD aee02
            IF NOT cl_null(l_newno2) THEN
               IF l_newno2 not matches '[1-4]' THEN
                  NEXT FIELD aee02
               END IF
            END IF
            CALL i109_aee021()   #FUN-5C0015 BY GILL
 
        BEFORE FIELD aee03
            IF cl_null(l_newno3) THEN
               LET l_newno3=g_aee.aee03
            END IF
 
        AFTER FIELD aee03
            IF NOT cl_null(l_newno3) THEN
               SELECT count(*) INTO g_cnt FROM aee_file
                WHERE aee01 = l_newno1 AND aee02 = l_newno2
                  AND aee03 = l_newno3 AND aee00 = l_newno0 #No.FUN-730020
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno0 CLIPPED,'+',l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',l_newno3
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD aee01
               END IF
            END IF
 
       #No.FUN-730020  --Begin
       ON ACTION controlp
         CASE
            WHEN INFIELD(aee00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = l_newno0
               CALL cl_create_qry() RETURNING l_newno0
               DISPLAY l_newno0 TO aee00
               NEXT FIELD aee00  
            WHEN INFIELD(aee01)
               CALL cl_init_qry_var()
               LET g_qryparam.form =  "q_aag"
               LET g_qryparam.where=" aag07 MATCHES '[23]'"
               LET g_qryparam.arg1 = l_newno0
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO aee01
            OTHERWISE
               EXIT CASE
       END CASE
       #No.FUN-730020  --End
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
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        #No.FUN-730020  --Begin 
        DISPLAY BY NAME g_aee.aee00
        DISPLAY BY NAME g_aee.aee01
        DISPLAY BY NAME g_aee.aee02
        DISPLAY BY NAME g_aee.aee03
        #DISPLAY l_newno1 TO aee01
        #DISPLAY l_newno2 TO aee02
        #DISPLAY l_newno3 TO aee03
        #No.FUN-730020  --End   
        RETURN
    END IF
    LET l_aee.aee00  =l_newno0  #資料鍵值  #No.FUN-730020
    LET l_aee.aee01  =l_newno1  #資料鍵值
    LET l_aee.aee02  =l_newno2  #資料鍵值
    LET l_aee.aee03  =l_newno3  #資料鍵值
    LET l_aee.aeeoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aee.aeeorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aee_file VALUES (l_aee.*)
      LET g_msg = l_newno0 CLIPPED,'+',l_newno1 CLIPPED,'+',l_newno2  #No.FUN-730020
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","aee_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno0 = g_aee.aee00  #No.FUN-730020
        LET l_oldno1 = g_aee.aee01
        LET l_oldno2 = g_aee.aee02
        LET l_oldno3 = g_aee.aee03
        SELECT aee_file.* INTO g_aee.* FROM aee_file
                       WHERE aee01 = l_newno1 AND aee02 = l_newno2
                         AND aee03 = l_newno3 AND aee00 = l_newno0  #No.FUN-730020
        CALL i109_u()
        #FUN-C30027---begin
        #SELECT aee_file.* INTO g_aee.* FROM aee_file
        #               WHERE aee01 = l_oldno1 AND aee02 = l_oldno2
        #                 AND aee03 = l_oldno3 AND aee00 = l_oldno0  #No.FUN-730020
        #FUN-C30027---end
    END IF
    CALL i109_show()
END FUNCTION
 
FUNCTION i109_out()
   DEFINE l_i             LIKE type_file.num5,         #No.FUN-680098 SMALLINT
          l_name          LIKE type_file.chr20,        # External(Disk) file name   #No.FUN-680098CHAR(20)
          l_aee           RECORD LIKE aee_file.*,
          l_chr           LIKE type_file.chr1          #No.FUN-680098CHAR(1)
   #No.FUN-760085---Begin
   DEFINE m_aag02         LIKE aag_file.aag02
   DEFINE m_aag           LIKE type_file.chr8                                               
   DEFINE l_ahe02         LIKE ahe_file.ahe02
   #No.FUN-760085---End
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
   #CALL cl_outnam('agli109') RETURNING l_name         #No.FUN-760085
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang  #No.FUN-760085                 
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_lang
 
   LET g_sql = "SELECT * FROM aee_file ",          # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED
   PREPARE i109_p1 FROM g_sql                # RUNTIME 編譯
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,0)   
      RETURN
   END IF
   DECLARE i109_co CURSOR FOR i109_p1
 
   #START REPORT i109_rep TO l_name                   #No.FUN-760085                                                                        
   CALL cl_del_data(l_table)                          #No.FUN-760085     
 
   FOREACH i109_co INTO l_aee.*
      IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      #No.FUN-760085---Begin 
      #OUTPUT TO REPORT i109_rep(l_aee.*)
      SELECT aag02 INTO m_aag02                                              
           FROM aag_file                                                        
          WHERE aag01 = l_aee.aee01                                                
            AND aag00 = l_aee.aee00  #No.FUN-730020                                
         IF STATUS = 100 THEN                                                   
            LET m_aag02 = ''                                                    
         END IF              
 
      CASE l_aee.aee02     #----- 依異動碼值不同, 抓取會計主檔之該異動碼名稱                                                        
           WHEN '1'                                                                                                                
                SELECT aag15 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                         AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
           WHEN '2'                                                                                                                
                SELECT aag16 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                         AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
           WHEN '3'                                                                                                                
                SELECT aag17 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                         AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
           WHEN '4'                                                                                                                
                SELECT aag18 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                         AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
                                                                                                                                   
           #FUN-5C0015 BY GILL --START                                                                                             
           WHEN '5'                                                                                                                
                SELECT aag31 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                         AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
           WHEN '6'                                                                                                                
                 SELECT aag32 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                          AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
            WHEN '7'                                                                                                                
                 SELECT aag33 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                          AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
            WHEN '8'                                                                                                                
                 SELECT aag34 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                          AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
            WHEN '9'                                                                                                                
                 SELECT aag35 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                          AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
            WHEN '10'                                                                                                               
                 SELECT aag36 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                          AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
            WHEN '99'                                                                                                               
                 SELECT aag37 INTO m_aag FROM aag_file WHERE aag01=l_aee.aee01                                                         
                                          AND aag00 = l_aee.aee00   #No.FUN-730020                                                     
                                                                                                                                    
            #FUN-5C0015 BY GILL --END                                                                                               
                                                                                                                                    
      END CASE                 
      IF STATUS = 100 THEN                                                                                                       
            LET m_aag = ''                                                                                                          
      END IF                                                                                                                     
                                                                                                                                    
      #FUN-5C0015 BY GILL --START                                                                                                
      LET l_ahe02 =''                                                                                                            
      SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = m_aag                                                                
      #FUN-5C0015 BY GILL --END                
      EXECUTE insert_prep USING l_aee.aeeacti,l_aee.aee00,l_aee.aee01,m_aag02,
                                l_aee.aee02,l_ahe02,l_aee.aee03,l_aee.aee04
      #No.FUN-760085---End 
   END FOREACH
 
   #FINISH REPORT i109_rep                             #No.FUN-760085        
 
   CLOSE i109_co
   #No.FUN-760085---Begin
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(g_wc,'aee00,aee01,aee02,aee021,aee03,aee04')                                                              
           RETURNING g_str                                                                                                          
   END IF                                                                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                              
   CALL cl_prt_cs3('agli109','agli109',l_sql,g_str)                                                                                
   #No.FUN-760085---End                             
   #CALL cl_prt(l_name,' ','1',g_len)
   MESSAGE ""
 
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i109_rep(sr)
   DEFINE l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          sr RECORD       LIKE aee_file.*,
          l_chr           LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
#FUN-590124
          m_aag02         LIKE aag_file.aag02,
#         m_aag02         LIKE aab_file.aab01,     
#FUN-590124 End
          m_aag           LIKE type_file.chr8           #No.FUN-680098   VARCHAR(8)
 
DEFINE    l_ahe02         LIKE ahe_file.ahe02
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aee00,sr.aee01,sr.aee02,sr.aee03  #No.FUN-730020
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         #No.FUN-730020  --Begin
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
               COLUMN g_c[32],g_x[9]  CLIPPED,
               COLUMN g_c[33],g_x[10] CLIPPED
         #No.FUN-730020  --End  
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.aee01
         SELECT aag02 INTO m_aag02
           FROM aag_file
          WHERE aag01 = sr.aee01
            AND aag00 = sr.aee00  #No.FUN-730020
         IF STATUS = 100 THEN
            LET m_aag02 = ''
         END IF
         #No.FUN-730020  --Begin
         PRINT COLUMN g_c[31],sr.aee00,
               COLUMN g_c[32],sr.aee01,
               COLUMN g_c[33],m_aag02
         #No.FUN-730020  --End  
 
      ON EVERY ROW
         CASE sr.aee02     #----- 依異動碼值不同, 抓取會計主檔之該異動碼名稱
            WHEN '1'
                 SELECT aag15 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '2'
                 SELECT aag16 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '3'
                 SELECT aag17 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '4'
                 SELECT aag18 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
 
            #FUN-5C0015 BY GILL --START
            WHEN '5'
                 SELECT aag31 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '6'
                 SELECT aag32 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '7'
                 SELECT aag33 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '8'
                 SELECT aag34 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '9'
                 SELECT aag35 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '10'
                 SELECT aag36 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
            WHEN '99'
                 SELECT aag37 INTO m_aag FROM aag_file WHERE aag01=sr.aee01
                                          AND aag00 = sr.aee00   #No.FUN-730020
 
            #FUN-5C0015 BY GILL --END
 
         END CASE
         IF STATUS = 100 THEN
            LET m_aag = ''
         END IF
 
         #FUN-5C0015 BY GILL --START
         LET l_ahe02 =''
         SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = m_aag
         #FUN-5C0015 BY GILL --END
 
         IF sr.aeeacti = 'N' THEN
            PRINT COLUMN g_c[31],'*';
         END IF
         PRINT COLUMN g_c[32],sr.aee02,
               #COLUMN g_c[33],m_aag,  #FUN-5C0051 BY GILL
               COLUMN g_c[33],l_ahe02, #FUN-5C0051 BY GILL
               COLUMN g_c[34],sr.aee03,
               COLUMN g_c[35],sr.aee04
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-760085---End
 
#FUN-5C0015 BY GILL --START
FUNCTION i109_aee021()
#由科目編號+異動碼順序得到「異動碼類型代號」
#順序1，得aee021 = aag15，順序2，得aee021 = aag16。以此類推
 
  DEFINE l_field    STRING,
         l_sql      STRING 
 
  IF cl_null(g_aee.aee01) OR cl_null(g_aee.aee02) OR cl_null(g_aee.aee00) THEN  #No.FUN-730020
     LET g_aee.aee021 = ''
     LET g_ahe02 = ''
     DISPLAY BY NAME g_aee.aee021
     DISPLAY g_ahe02 TO ahe02
     RETURN
  END IF
 
  LET l_field = 'aag'
  IF g_aee.aee02 = '1' THEN
     LET l_field = l_field,'15'
  END IF
  IF g_aee.aee02 = '2' THEN
     LET l_field = l_field,'16'
  END IF
  IF g_aee.aee02 = '3' THEN
     LET l_field = l_field,'17'
  END IF
  IF g_aee.aee02 = '4' THEN
     LET l_field = l_field,'18'
  END IF
  IF g_aee.aee02 = '5' THEN
     LET l_field = l_field,'31'
  END IF
  IF g_aee.aee02 = '6' THEN
     LET l_field = l_field,'32'
  END IF
  IF g_aee.aee02 = '7' THEN
     LET l_field = l_field,'33'
  END IF
  IF g_aee.aee02 = '8' THEN
     LET l_field = l_field,'34'
  END IF
  IF g_aee.aee02 = '9' THEN
     LET l_field = l_field,'35'
  END IF
  IF g_aee.aee02 = '10' THEN
     LET l_field = l_field,'36'
  END IF
  IF g_aee.aee02 = '99' THEN
     LET l_field = l_field,'37'
  END IF
 
  LET l_sql = "SELECT ",l_field, " FROM aag_file ",
              " WHERE aag01 = '",g_aee.aee01,"'",
              "   AND aag00 = '",g_aee.aee00,"'",   #No.FUN-730020
              "   AND aagacti = 'Y' "
  DECLARE i109_ahe_cs CURSOR FROM l_sql
 
  OPEN i109_ahe_cs
  FETCH i109_ahe_cs INTO g_aee.aee021
  CLOSE i109_ahe_cs
  DISPLAY BY NAME g_aee.aee021
 
  LET g_ahe02 = ''
  LET g_ahe03 = ''
  SELECT ahe02,ahe03 INTO g_ahe02,g_ahe03 FROM ahe_file
   WHERE ahe01 = g_aee.aee021
  DISPLAY g_ahe02 TO ahe02
 
END FUNCTION
#FUN-5C0015 BY GILL --END
 

