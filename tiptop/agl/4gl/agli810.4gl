# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agli810.4gl
# Descriptions...: 總帳立帳開帳資料維護作業
# Date & Author..: 98/12/28 By plum
# Modify.........: 03/08/20 By kitty 檢查異動碼三跟四的時候時傳錯異動碼順序
#                                    應該傳3跟4結果都傳成2,所以檢查不過
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-5C0015 060103 BY GILL增加異動碼5-10
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL 用s_ahe_qry取代q_aee
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By Lynn    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No:FUN-B40004 11/04/14 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B40026 11/06/14 By zhangweib 去除abg31~abg36的操作
# Modify.........: No.FUN-BC0092 12/04/11 By Lori 配合aglp802資料拋轉增加欄位與整批刪除
# Modify.........: No.FUN-C90083 12/09/21 By Belle 配合aglp802修改刪除條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_bookno  LIKE aaa_file.aaa01,
    g_aaa   RECORD LIKE aaa_file.*,
    g_abg   RECORD LIKE abg_file.*,
    g_abg_t RECORD LIKE abg_file.*,
    g_abg01_t LIKE abg_file.abg01,
    g_abg02_t LIKE abg_file.abg02,
    g_abg00_t LIKE abg_file.abg00,
    g_wc,g_sql          STRING,  #No:FUN-580092 HCN    
    g_aag02   LIKE aag_file.aag02,         
    g_aag05   LIKE aag_file.aag05,
    m_aag151  LIKE aag_file.aag151,
    m_aag161  LIKE aag_file.aag161,
    m_aag171  LIKE aag_file.aag171,
    m_aag181  LIKE aag_file.aag181,
    m_aag15   LIKE aag_file.aag15,
    m_aag16   LIKE aag_file.aag16,
    m_aag17   LIKE aag_file.aag17,
    m_aag18   LIKE aag_file.aag18
#FUN-B40026   ---start   Mark
#  #FUN-5C0015--start
#  ,m_aag311  LIKE aag_file.aag311,
#   m_aag321  LIKE aag_file.aag321,
#   m_aag331  LIKE aag_file.aag331,
#   m_aag341  LIKE aag_file.aag341,
#   m_aag351  LIKE aag_file.aag351,
#   m_aag361  LIKE aag_file.aag361,
#   m_aag31   LIKE aag_file.aag31,
#   m_aag32   LIKE aag_file.aag32,
#   m_aag33   LIKE aag_file.aag33,
#   m_aag34   LIKE aag_file.aag34,
#   m_aag35   LIKE aag_file.aag35,
#   m_aag36   LIKE aag_file.aag36
#  #FUN-5C0015--end
#FUN-B40026   ---end     Mark
 
DEFINE g_forupd_sql STRING    #SELECT ... FOR UPDATE SQL      
DEFINE g_before_input_done    LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE   g_cnt           LIKE type_file.num10              #No.FUN-680098 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03          #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #FUN-C90083 
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680098 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0073
 
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
 
 
     LET p_row = ARG_VAL(2)     #No.MOD-4C0171
     LET p_col = ARG_VAL(3)     #No.MOD-4C0171
    IF p_row = 0 OR p_row IS NULL THEN           # 螢墓位置
        LET p_row = 4
        LET p_col = 14
    END IF
    INITIALIZE g_abg.* TO NULL
    INITIALIZE g_abg_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM abg_file WHERE abg00 = ? AND abg01 = ? AND abg02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i810_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    #--010822wiky增
    IF g_bookno = ' ' OR g_bookno IS NULL THEN LET g_bookno = g_aaz.aaz64 END IF
    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
    #--
    LET p_row = 4 LET p_col = 14
    OPEN WINDOW i810_w AT p_row,p_col
         WITH FORM "agl/42f/agli810" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL i810_show_field()  #FUN-5C0015 BY GILL
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i810_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i810_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i810_cs()
    CLEAR FORM
   INITIALIZE g_abg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        abg00 ,abg01,abg02,abg06,abg03,abg05,abg11,abg12,abg13,abg14,
        
#FUN-B40026   ---start   Mark
#       #FUN-5C0015 BY GILL --START
#       abg31,abg32,abg33,abg34,abg35,abg36,
#       #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
        
        abg071,abg04 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp                                                          
       CASE                                                                     
          WHEN INFIELD(abg00)                                                   
#            CALL q_aaa(10,3,g_abg.abg00)                                       
#                 RETURNING g_abg.abg00                                         
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_aaa"                                       
             LET g_qryparam.default1 = g_abg.abg00                              
             #CALL cl_create_qry() RETURNING g_abg.abg00                        
             #DISPLAY BY NAME g_abg.abg00                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO abg00                               
             NEXT FIELD abg00                                                   
          WHEN INFIELD(abg03)                                                   
#            CALL q_aag(10,3,g_abg.abg03,' ',' ',' ')                           
#                 RETURNING g_abg.abg03                                         
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_aag"                                       
             LET g_qryparam.default1 = g_abg.abg03                              
             LET g_qryparam.where = " aag07 IN ('2','3') AND aag03='2' AND aag20='Y'" #FUN-B40004
             #CALL cl_create_qry() RETURNING g_abg.abg03                        
             #DISPLAY BY NAME g_abg.abg03        
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO abg03                               
             NEXT FIELD abg03                                                   
          WHEN INFIELD(abg05)                                                   
#            CALL q_gem(0,0,g_abg.abg05) RETURNING g_abg.abg05                  
             CALL cl_init_qry_var()                                             
             LET g_qryparam.state = "c"                                         
             LET g_qryparam.form ="q_gem"                                       
             LET g_qryparam.default1 = g_abg.abg05                              
             #CALL cl_create_qry() RETURNING g_abg.abg05                        
             #DISPLAY BY NAME g_abg.abg05                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                 
             DISPLAY g_qryparam.multiret TO abg05                               
             NEXT FIELD abg05                                                   
          WHEN INFIELD(abg11)    #查詢異動碼-1
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 1
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg11
          WHEN INFIELD(abg12)    #查詢異動碼-2
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 2
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg12
          WHEN INFIELD(abg13)    #查詢異動碼-3
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 3
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg13
          WHEN INFIELD(abg14)    #查詢異動碼-4
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 4
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg14
             
          #FUN-5C0015 BY GILL --START
          WHEN INFIELD(abg31)    #查詢異動碼-5
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 5
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg31
          WHEN INFIELD(abg32)    #查詢異動碼-6
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 6
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg32
          WHEN INFIELD(abg33)    #查詢異動碼-7
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 7
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg33
          WHEN INFIELD(abg34)    #查詢異動碼-8
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 8
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg34
          WHEN INFIELD(abg35)    #查詢異動碼-9
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 9
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg35
          WHEN INFIELD(abg36)    #查詢異動碼-10
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aee"
             LET g_qryparam.arg1 = g_abg.abg03
             LET g_qryparam.arg2 = 10
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO abg36                                                                 
             #FUN-5C0015 BY GILL --END
             
          OTHERWISE EXIT CASE                                                   
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    LET g_sql="SELECT abg00,abg01,abg02",
              "  FROM abg_file",
             #" WHERE abg15='0' AND ",g_wc CLIPPED,             #FUN-BC0092
              " WHERE abg15 IN ('0','2')  AND ",g_wc CLIPPED,   #FUN-BC0092
              " ORDER BY abg00,abg01,abg02"
    PREPARE i810_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i810_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i810_prepare
    LET g_sql=
       #"SELECT COUNT(*) FROM abg_file WHERE abg15='0' AND ",g_wc CLIPPED               #FUN-BC0092
        "SELECT COUNT(*) FROM abg_file WHERE abg15 in('0','2')  AND ",g_wc CLIPPED      #FUN-BC0092
    PREPARE i810_precount FROM g_sql
    DECLARE i810_count CURSOR FOR i810_precount
END FUNCTION
 
FUNCTION i810_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i810_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i810_q()
            END IF
        ON ACTION next 
            CALL i810_fetch('N') 
        ON ACTION previous 
            CALL i810_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i810_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i810_r()
            END IF
        ON ACTION help 
                     CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i810_fetch('/')
        ON ACTION first
            CALL i810_fetch('F')
        ON ACTION last
            CALL i810_fetch('L')

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
              IF g_abg.abg01 IS NOT NULL THEN 
                 LET g_doc.column1 = "abg00"
                 LET g_doc.value1 = g_abg.abg00
                 LET g_doc.column2 = "abg01"
                 LET g_doc.value2 = g_abg.abg01
                 LET g_doc.column3 = "abg02"
                 LET g_doc.value3 = g_abg.abg02
                 CALL cl_doc()
              END IF
           END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
      #FUN-BC0092--Begin--
       ON ACTION delete_select
          LET g_action_choice="delete_select"
          IF cl_chk_act_auth() THEN
             CALL i810_r1()
          END IF
      #FUN-BC0092---End---
      #FUN-C90083--Begin--
       ON ACTION p802
          LET g_action_choice= "p802"
          IF cl_chk_act_auth() THEN
             LET l_cmd = "aglp802"
             CALL cl_cmdrun(l_cmd)
          END IF
      #FUN-C90083---End---
    END MENU
    CLOSE i810_cs
END FUNCTION
 
 
FUNCTION i810_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_abg.* LIKE abg_file.*
    LET g_abg.abg00 = NULL
    LET g_abg.abg01 = NULL
    LET g_abg.abg02 = NULL
    LET g_abg00_t = NULL
    LET g_abg01_t = NULL
    LET g_abg02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_abg.abg06   = g_today
        LET g_abg.abg15   ='0'  
        LET g_abg.abg072  = 0   
        LET g_abg.abg073  = 0   
        LET g_abg.abglegal = g_legal #FUN-980003 add legal
        CALL i810_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_abg.abg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_abg.abg11) THEN LET g_abg.abg11 = ' ' END IF
        IF cl_null(g_abg.abg12) THEN LET g_abg.abg12 = ' ' END IF
        IF cl_null(g_abg.abg13) THEN LET g_abg.abg13 = ' ' END IF
        IF cl_null(g_abg.abg14) THEN LET g_abg.abg14 = ' ' END IF
        
#FUN-B40026   ---start   Mark
#       #FUN-5C0015 BY GILL --START
#       IF cl_null(g_abg.abg31) THEN LET g_abg.abg31 = ' ' END IF
#       IF cl_null(g_abg.abg32) THEN LET g_abg.abg32 = ' ' END IF
#       IF cl_null(g_abg.abg33) THEN LET g_abg.abg33 = ' ' END IF
#       IF cl_null(g_abg.abg34) THEN LET g_abg.abg34 = ' ' END IF
#       IF cl_null(g_abg.abg35) THEN LET g_abg.abg35 = ' ' END IF
#       IF cl_null(g_abg.abg36) THEN LET g_abg.abg36 = ' ' END IF
#       #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
        
        INSERT INTO abg_file VALUES(g_abg.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins abg:',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","abg_file",g_abg.abg01,g_abg.abg02,SQLCA.sqlcode,"","ins abg:",1)  #No.FUN-660123
            CONTINUE WHILE
        ELSE
            LET g_abg_t.* = g_abg.*                # 保存上筆資料
            SELECT abg00 INTO g_abg.abg00 FROM abg_file
                WHERE abg01 = g_abg.abg01
                  AND abg02 = g_abg.abg02
                  AND abg00 = g_abg.abg00
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i810_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
        l_flag          LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
    DEFINE li_chk_bookno LIKE type_file.num5    #No.FUN-670005      #No.FUN-680098     SMALLINT
    DEFINE  l_aag05     LIKE aag_file.aag05           #No.FUN-B40004
    INPUT BY NAME
        g_abg.abg00 ,g_abg.abg01,g_abg.abg02,g_abg.abg06,g_abg.abg03,
        g_abg.abg05 ,g_abg.abg11,g_abg.abg12,g_abg.abg13,g_abg.abg14,
        
#FUN-B40026   ---start   Mark
#       #FUN-5C0015 BY GILL --START
#       g_abg.abg31,g_abg.abg32,g_abg.abg33,g_abg.abg34,
#       g_abg.abg35,g_abg.abg36,
#       #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
        
        g_abg.abg071,g_abg.abg04 WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i810_set_entry(p_cmd)
            CALL i810_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD abg00
            IF g_abg.abg00 IS NOT NULL THEN 
            #No.FUN-670005--begin
             CALL s_check_bookno(g_abg.abg00,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                 LET g_abg.abg00 = g_abg00_t
                 IF p_cmd = "a" THEN
                    NEXT FIELD abg00
                 END IF
                 IF p_cmd = "u" THEN
                    EXIT INPUT
                 END IF
             END IF 
             #No.FUN-670005--end
               SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=g_abg.abg00 
               IF g_cnt=0 THEN  
                  CALL cl_err(g_abg.abg00,'agl-095',0) NEXT FIELD abg00 
               END IF
            END IF
 
        AFTER FIELD abg01
            IF g_abg.abg01 IS NOT NULL THEN 
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                  (g_abg.abg00 != g_abg00_t   OR
                   g_abg.abg01 != g_abg01_t)) THEN
                  SELECT COUNT(*) INTO g_cnt FROM aba_file 
                   WHERE aba01=g_abg.abg01 
                     AND aba00=g_abg.abg00 #no.7277
                   IF g_cnt > 0 THEN                  # Duplicated
                      CALL cl_err('aba count:','agl-212',0)
                      NEXT FIELD abg01
                   END IF
               END IF
               LET g_abg00_t=g_abg.abg00
               LET g_abg01_t=g_abg.abg01
            END IF
 
        AFTER FIELD abg02
            IF g_abg.abg02 IS NOT NULL THEN 
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                  (g_abg.abg00 != g_abg00_t   OR
                   g_abg.abg01 != g_abg01_t   OR
                   g_abg.abg02 != g_abg02_t)) THEN
                  SELECT COUNT(*) INTO g_cnt FROM abg_file 
                   WHERE abg00=g_abg.abg00 AND abg01=g_abg.abg01 
                     AND abg02=g_abg.abg02
                  IF g_cnt > 0 THEN                  # Duplicated
                     CALL cl_err('abg count:','agl-212',0)
                     NEXT FIELD abg00
                  END IF
               END IF
               LET g_abg02_t=g_abg.abg02
            END IF
 
 
         BEFORE FIELD abg03
            CALL i810_set_entry('')
              
         AFTER FIELD abg03
            IF NOT cl_null(g_abg.abg03) THEN 
               CALL i810_abg03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  #Add No.FUN-B10048
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_abg.abg03
                  LET g_qryparam.arg1 = g_abg.abg00         # No.FUN-740020
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03='2' AND aag20='Y' AND aagacti='Y' AND aag01 LIKE '",g_abg.abg03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_abg.abg03
                  DISPLAY BY NAME g_abg.abg03
                  #End Add No.FUN-B10048
                  NEXT FIELD abg03
               END IF
{
               IF g_aag05 ='N' THEN
                  NEXT FIELD abg11
               END IF
}
               CALL i810_set_no_entry(p_cmd)
               
               #FUN-5C0015 --start
               CALL i810_set_no_required()
               CALL i810_set_required()
               #FUN-5C0015 --end
               
               
            END IF
 
        AFTER FIELD abg05
            IF NOT cl_null(g_abg.abg05) THEN 
               CALL i810_set_no_entry(p_cmd)
               CALL i810_abg05()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0) NEXT FIELD abg05
               END IF
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_abg.abg03
                  AND aag00 = g_abg.abg00
               iF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_abg.abg03,g_abg.abg05,g_abg.abg00)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_abg.abg05,g_errno,0)
                  DISPLAY BY NAME g_abg.abg05
                  NEXT FIELD abg05
               END IF
               #No.FUN-B40004  --End
            END IF
 
         BEFORE FIELD abg11
            CALL i810_error(m_aag15)  
 
         AFTER FIELD abg11
            #FUN-5C0015 BY GILL --START
            #CALL i810_abg11(m_aag151,'1',g_abg.abg11)
            CALL s_chk_aee(g_abg.abg03,'1',g_abg.abg11,g_abg.abg00)     # No.FUN-740020
            #FUN-5C0015 BY GILL --END
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD abg11
                 END IF
 
         BEFORE FIELD abg12
            CALL i810_error(m_aag16)  
 
         AFTER FIELD abg12
            #FUN-5C0015 BY GILL --START
            #CALL i810_abg11(m_aag161,'2',g_abg.abg12)
            CALL s_chk_aee(g_abg.abg03,'2',g_abg.abg12,g_abg.abg00)     # No.FUN-740020
            #FUN-5C0015 BY GILL --END
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD abg12
                 END IF
 
         BEFORE FIELD abg13
            CALL i810_error(m_aag17)  
 
         AFTER FIELD abg13
            #FUN-5C0015 BY GILL --START
            #CALL i810_abg11(m_aag171,'3',g_abg.abg13)   #No:7859
            CALL s_chk_aee(g_abg.abg03,'3',g_abg.abg13,g_abg.abg00)      # No.FUN-740020
            #FUN-5C0015 BY GILL --END
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD abg13
                 END IF
 
         BEFORE FIELD abg14
            CALL i810_error(m_aag18)  
 
         AFTER FIELD abg14
            #FUN-5C0015 BY GILL --START
            #CALL i810_abg11(m_aag181,'4',g_abg.abg14)   #No:7859
            CALL s_chk_aee(g_abg.abg03,'4',g_abg.abg14,g_abg.abg00)        # No.FUN-740020
            #FUN-5C0015 BY GILL --END
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    NEXT FIELD abg14
                 END IF
           
#FUN-B40026   ---start   Mark
#        #FUN-5C0015 BY GILL --START
#        BEFORE FIELD abg31
#           CALL i810_error(m_aag31)  
#
#        AFTER FIELD abg31
#           CALL s_chk_aee(g_abg.abg03,'5',g_abg.abg31,g_abg.abg00)      # No.FUN-740020
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err('',g_errno,1)
#                   NEXT FIELD abg31
#                END IF
#        
#        BEFORE FIELD abg32
#           CALL i810_error(m_aag32)  
#
#        AFTER FIELD abg32
#           CALL s_chk_aee(g_abg.abg03,'6',g_abg.abg32,g_abg.abg00)       # No.FUN-740020
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err('',g_errno,1)
#                   NEXT FIELD abg32
#                END IF
#
#        BEFORE FIELD abg33
#           CALL i810_error(m_aag33)  
#
#        AFTER FIELD abg33
#           CALL s_chk_aee(g_abg.abg03,'7',g_abg.abg33,g_abg.abg00)     # No.FUN-740020
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err('',g_errno,1)
#                   NEXT FIELD abg33
#                END IF
#
#        BEFORE FIELD abg34
#           CALL i810_error(m_aag34)  
#
#        AFTER FIELD abg34
#           CALL s_chk_aee(g_abg.abg03,'8',g_abg.abg34,g_abg.abg00)       # No.FUN-740020
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err('',g_errno,1)
#                   NEXT FIELD abg34
#                END IF
#
#        BEFORE FIELD abg35
#           CALL i810_error(m_aag35)  
#
#        AFTER FIELD abg35
#           CALL s_chk_aee(g_abg.abg03,'9',g_abg.abg35,g_abg.abg00)      # No.FUN-740020
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err('',g_errno,1)
#                   NEXT FIELD abg35
#                END IF
#
#        BEFORE FIELD abg36
#           CALL i810_error(m_aag36)  
#
#        AFTER FIELD abg36
#           CALL s_chk_aee(g_abg.abg03,'10',g_abg.abg36,g_abg.abg00)       # No.FUN-740020
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err('',g_errno,1)
#                   NEXT FIELD abg36
#                END IF
#
#        #FUN-5C0015 BY GILL --END
#FUN-B4026   ---end     Mark
 
 
         AFTER FIELD abg071
            #---010822增wiky
            SELECT azi04
              INTO t_azi04        #幣別檔小數位數讀取       #CHI-6A0004
              FROM azi_file
             WHERE azi01=g_aaa.aaa03
            #---
            IF cl_null(g_abg.abg071) OR g_abg.abg071 <0 THEN
               CALL cl_err(g_abg.abg071,'aap-201',0) 
               NEXT FIELD abg071
            END IF
            LET g_abg.abg071 = cl_numfor(g_abg.abg071,15,t_azi04)     #CHI-6A0004
            DISPLAY BY NAME g_abg.abg071
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
{
            IF cl_null(g_abg.abg00) OR cl_null(g_abg.abg01) OR
               cl_null(g_abg.abg03) OR cl_null(g_abg.abg071) THEN
               LET l_flag='Y'
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD abg01
            END IF
}
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(abg01) THEN
        #        LET g_abg.* = g_abg_t.*
        #        DISPLAY BY NAME g_abg.* 
        #        NEXT FIELD abg00
        #    END IF
        #MOD-650015 --end
 
         ON ACTION controlp                                                     
            CASE                                                                
               WHEN INFIELD(abg00)                                              
#                 CALL q_aaa(10,3,g_abg.abg00)                                  
#                      RETURNING g_abg.abg00                                    
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg00 )
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form ="q_aaa"                                  
                  LET g_qryparam.default1 = g_abg.abg00                         
                  CALL cl_create_qry() RETURNING g_abg.abg00                    
#                  CALL FGL_DIALOG_SETBUFFER( g_abg.abg00 )
                  DISPLAY BY NAME g_abg.abg00                                   
                  NEXT FIELD abg00                                              
               WHEN INFIELD(abg03)                                              
#                 CALL q_aag(10,3,g_abg.abg03,' ',' ',' ')                      
#                      RETURNING g_abg.abg03                                    
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg03 )
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form ="q_aag"                                  
                  LET g_qryparam.default1 = g_abg.abg03                         
                  LET g_qryparam.arg1 = g_abg.abg00         # No.FUN-740020
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03='2' AND aag20='Y'" #No.FUN-B40004 
                  CALL cl_create_qry() RETURNING g_abg.abg03                    
#                  CALL FGL_DIALOG_SETBUFFER( g_abg.abg03 )
                  DISPLAY BY NAME g_abg.abg03                                   
                  NEXT FIELD abg03                                              
               WHEN INFIELD(abg05)                                              
#                 CALL q_gem(0,0,g_abg.abg05) RETURNING g_abg.abg05
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg05 )
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form ="q_gem"                                  
                  LET g_qryparam.default1 = g_abg.abg05                         
                  CALL cl_create_qry() RETURNING g_abg.abg05                    
#                  CALL FGL_DIALOG_SETBUFFER( g_abg.abg05 )
                  DISPLAY BY NAME g_abg.abg05                                   
                  NEXT FIELD abg05 
 
              #FUN-5C0015 查詢異動碼用s_ahe_qry取代q_aee
{                                             
              WHEN INFIELD(abg11)    #查詢異動碼-1
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aee"
                 LET g_qryparam.default1 = g_abg.abg11
                 LET g_qryparam.arg1 = g_abg.abg03
                 LET g_qryparam.arg2 = 1
                 CALL cl_create_qry() RETURNING g_abg.abg11
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg11 )
                   DISPLAY BY NAME g_abg.abg11     #No.MOD-490344                
                 NEXT FIELD abg11
              WHEN INFIELD(abg12)    #查詢異動碼-2
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aee"
                 LET g_qryparam.default1 = g_abg.abg12
                 LET g_qryparam.arg1 = g_abg.abg03
                 LET g_qryparam.arg2 = 2
                 CALL cl_create_qry() RETURNING g_abg.abg12
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg12 )
                   DISPLAY BY NAME g_abg.abg12     #No.MOD-490344                
                 NEXT FIELD abg12
              WHEN INFIELD(abg13)    #查詢異動碼-3
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aee"
                 LET g_qryparam.default1 = g_abg.abg13
                 LET g_qryparam.arg1 = g_abg.abg03
                 LET g_qryparam.arg2 = 3
                 CALL cl_create_qry() RETURNING g_abg.abg13
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg13 )
                   DISPLAY BY NAME g_abg.abg13     #No.MOD-490344                
                 NEXT FIELD abg13
              WHEN INFIELD(abg14)    #查詢異動碼-4
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aee"
                 LET g_qryparam.default1 = g_abg.abg14
                 LET g_qryparam.arg1 = g_abg.abg03
                 LET g_qryparam.arg2 = 4
                 CALL cl_create_qry() RETURNING g_abg.abg14
#                 CALL FGL_DIALOG_SETBUFFER( g_abg.abg14 )
                   DISPLAY BY NAME g_abg.abg14     #No.MOD-490344                
                 NEXT FIELD abg14
}
             WHEN INFIELD(abg11)    #查詢異動碼-1
                  CALL s_ahe_qry(g_abg.abg03,'1','i',g_abg.abg11,g_abg.abg00)     # No.FUN-740020
                     RETURNING g_abg.abg11
                  DISPLAY g_abg.abg11 TO abg11
                  NEXT FIELD abg11
 
             WHEN INFIELD(abg12)    #查詢異動碼-2
                  CALL s_ahe_qry(g_abg.abg03,'2','i',g_abg.abg12,g_abg.abg00)      # No.FUN-740020
                     RETURNING g_abg.abg12
                  DISPLAY g_abg.abg12 TO abg12
                  NEXT FIELD abg12
 
             WHEN INFIELD(abg13)    #查詢異動碼-3
                  CALL s_ahe_qry(g_abg.abg03,'3','i',g_abg.abg13,g_abg.abg00)       # No.FUN-740020
                     RETURNING g_abg.abg13
                  DISPLAY g_abg.abg13 TO abg13
                  NEXT FIELD abg13
 
             WHEN INFIELD(abg14)    #查詢異動碼-4
                  CALL s_ahe_qry(g_abg.abg03,'4','i',g_abg.abg14,g_abg.abg00)       # No.FUN-740020
                     RETURNING g_abg.abg14
                  DISPLAY g_abg.abg14 TO abg14
                  NEXT FIELD abg14
 
             WHEN INFIELD(abg31)    #查詢異動碼-5
                  CALL s_ahe_qry(g_abg.abg03,'5','i',g_abg.abg31,g_abg.abg00)       # No.FUN-740020
                     RETURNING g_abg.abg31
                  DISPLAY g_abg.abg31 TO abg31
                  NEXT FIELD abg31
 
             WHEN INFIELD(abg32)    #查詢異動碼-6
                  CALL s_ahe_qry(g_abg.abg03,'6','i',g_abg.abg32,g_abg.abg00)     # No.FUN-740020
                     RETURNING g_abg.abg32
                  DISPLAY g_abg.abg32 TO abg32
                  NEXT FIELD abg32
 
             WHEN INFIELD(abg33)    #查詢異動碼-7
                  CALL s_ahe_qry(g_abg.abg03,'7','i',g_abg.abg33,g_abg.abg00)       # No.FUN-740020
                     RETURNING g_abg.abg33
                  DISPLAY g_abg.abg33 TO abg33
                  NEXT FIELD abg33
 
             WHEN INFIELD(abg34)    #查詢異動碼-8
                  CALL s_ahe_qry(g_abg.abg03,'8','i',g_abg.abg34,g_abg.abg00)     # No.FUN-740020
                     RETURNING g_abg.abg34
                  DISPLAY g_abg.abg34 TO abg34
                  NEXT FIELD abg34
 
             WHEN INFIELD(abg35)    #查詢異動碼-9
                  CALL s_ahe_qry(g_abg.abg03,'9','i',g_abg.abg35,g_abg.abg00)      # No.FUN-740020
                     RETURNING g_abg.abg35
                  DISPLAY g_abg.abg35 TO abg35
                  NEXT FIELD abg35
 
             WHEN INFIELD(abg36)    #查詢異動碼-10
                  CALL s_ahe_qry(g_abg.abg03,'10','i',g_abg.abg36,g_abg.abg00)       # No.FUN-740020
                     RETURNING g_abg.abg36
                  DISPLAY g_abg.abg36 TO abg36
                  NEXT FIELD abg36
 
               #FUN-5C0015 BY GILL --END
 
               OTHERWISE EXIT CASE                                              
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
 
FUNCTION i810_set_entry(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("abg00,abg01,abg02",TRUE)
    END IF
 
    CASE
        WHEN INFIELD(abg03) OR (NOT g_before_input_done)
             CALL cl_set_comp_entry("abg05",TRUE)
             CALL cl_set_comp_entry("abg11,abg12,abg13,abg14",TRUE)
 
#FUN-B40026   ---start   Mark
#            #FUN-5C0015 BY GILL --START
#            CALL cl_set_comp_entry("abg31,abg32,abg33,abg34,abg35,abg36",TRUE)
#            #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
 
    END CASE
 
END FUNCTION
 
FUNCTION i810_set_no_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("abg00,abg01,abg02",FALSE)
    END IF
 
    # 科目編號(agb03) 會影響:部門:[abg05 ]
    #                        異動碼-1:[abg11          ]
    #                        異動碼-2:[abg12          ]
    #                        異動碼-3:[abg13          ]
    #                        異動碼-4:[abg14          ]
 
    CASE WHEN INFIELD(abg03) OR (NOT g_before_input_done)
              IF g_aag05 ='N' THEN
                 CALL cl_set_comp_entry("abg05",FALSE)
              END IF
              IF cl_null(m_aag151) THEN
                 CALL cl_set_comp_entry("abg11",FALSE)
              END IF
              IF cl_null(m_aag161) THEN
                 CALL cl_set_comp_entry("abg12",FALSE)
              END IF
              IF cl_null(m_aag171) THEN
                 CALL cl_set_comp_entry("abg13",FALSE)
              END IF
              IF cl_null(m_aag181) THEN
                 CALL cl_set_comp_entry("abg14",FALSE)
              END IF
 
#FUN-B40026   ---start   Mark
#             #FUN-5C0015 BY GILL --START
#             IF cl_null(m_aag311) THEN
#                CALL cl_set_comp_entry("abg31",FALSE)
#             END IF
#             IF cl_null(m_aag321) THEN
#                CALL cl_set_comp_entry("abg32",FALSE)
#             END IF
#             IF cl_null(m_aag331) THEN
#                CALL cl_set_comp_entry("abg33",FALSE)
#             END IF
#             IF cl_null(m_aag341) THEN
#                CALL cl_set_comp_entry("abg34",FALSE)
#             END IF
#             IF cl_null(m_aag351) THEN
#                CALL cl_set_comp_entry("abg35",FALSE)
#             END IF
#             IF cl_null(m_aag361) THEN
#                CALL cl_set_comp_entry("abg36",FALSE)
#             END IF
#             #FUN-5C0015 BY GILL --END
#FUN-B40026   ---start   Mark
 
    END CASE
 
END FUNCTION
 
FUNCTION i810_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_abg.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i810_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i810_count
    FETCH i810_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i810_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open i810_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_abg.* TO NULL
    ELSE
        CALL i810_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i810_fetch(p_flabg)
    DEFINE
        p_flabg         LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
        l_abso          LIKE type_file.num10          #No.FUN-680098 INTEGER
 
    CASE p_flabg
        WHEN 'N' FETCH NEXT     i810_cs INTO g_abg.abg00,
                              g_abg.abg01, g_abg.abg02
        WHEN 'P' FETCH PREVIOUS i810_cs INTO g_abg.abg00,
                              g_abg.abg01, g_abg.abg02
        WHEN 'F' FETCH FIRST    i810_cs INTO g_abg.abg00,
                              g_abg.abg01, g_abg.abg02
        WHEN 'L' FETCH LAST     i810_cs INTO g_abg.abg00,
                              g_abg.abg01, g_abg.abg02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i810_cs INTO g_abg.abg00,g_abg.abg01, g_abg.abg02
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_abg.abg01,SQLCA.sqlcode,0)
        INITIALIZE g_abg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flabg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_abg.* FROM abg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE abg00 = g_abg.abg00 AND abg01 = g_abg.abg01 AND abg02 = g_abg.abg02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_abg.abg01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel"," abg_file",g_abg.abg01,g_abg.abg02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
 
        CALL i810_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i810_show()
    LET g_abg_t.* = g_abg.*
    
    DISPLAY BY NAME
        g_abg.abg00 ,g_abg.abg01,g_abg.abg02,g_abg.abg06,g_abg.abg03,
        g_abg.abg05 ,g_abg.abg11,g_abg.abg12,g_abg.abg13,g_abg.abg14,
 
#FUN-B40026   ---start   Mark
#       #FUN-5C0015 BY GILL --START
#       g_abg.abg31,g_abg.abg32,g_abg.abg33,g_abg.abg34,
#       g_abg.abg35,g_abg.abg36,
#       #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
 
        g_abg.abg071,g_abg.abg04 
    CALL i810_abg03()
    CALL i810_abg05()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i810_u()
   DEFINE l_abg072    LIKE abg_file.abg072       #FUN-BC0092

    IF g_abg.abg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-C90083--Begin Mark--
   ##FUN-BC0092--Begin--
   #SELECT SUM(abg072+abg073) INTO l_abg072
   #  FROM abg_file
   # WHERE abg00 = g_abg.abg00
   #   AND abg01 = g_abg.abg01
   #   AND abg02 = g_abg.abg02
   #IF l_abg072 <> 0 THEN
   #   CALL cl_err('','anm-800',0)
   #   RETURN
   #END IF
   ##FUN-BC0092---End---
   #FUN-C90083---End Mark---
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_abg00_t = g_abg.abg00
    LET g_abg01_t = g_abg.abg01
    LET g_abg02_t = g_abg.abg02
    BEGIN WORK
 
    OPEN i810_cl USING g_abg.abg00,g_abg.abg01,g_abg.abg02
    IF STATUS THEN
       CALL cl_err("OPEN i810_cl:", STATUS, 1)
       CLOSE i810_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i810_cl INTO g_abg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i810_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i810_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_abg.*=g_abg_t.*
            CALL i810_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE abg_file SET abg_file.* = g_abg.*    # 更新DB
            WHERE abg00=g_abg_t.abg00 AND abg01=g_abg_t.abg01 AND abg02 = g_abg_t.abg02             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_abg.abg01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","abg_file",g_abg_t.abg01,g_abg_t.abg02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i810_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i810_r()
    IF g_abg.abg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i810_cl USING g_abg.abg00,g_abg.abg01,g_abg.abg02
    IF STATUS THEN
       CALL cl_err("OPEN i810_cl:", STATUS, 1)
       CLOSE i810_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i810_cl INTO g_abg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_abg.abg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i810_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "abg00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_abg.abg00      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "abg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_abg.abg01      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "abg02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_abg.abg02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM abg_file WHERE abg00 = g_abg.abg00
                              AND abg01 = g_abg.abg01
                              AND abg02 = g_abg.abg02
       CLEAR FORM
       OPEN i810_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i810_cs
          CLOSE i810_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end-- 
       FETCH i810_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i810_cs
          CLOSE i810_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i810_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i810_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i810_fetch('/')
       END IF
    END IF
    CLOSE i810_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i810_abg03()
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag03    LIKE aag_file.aag03  
  DEFINE l_aag20    LIKE aag_file.aag20  
  DEFINE l_aag07    LIKE aag_file.aag07  
 
   SELECT aag02,aag03,aag05,aag07,aagacti,
          aag151,aag161,aag171,aag181,aag20,
          aag15,aag16,aag17,aag18
 
#FUN-B40026   ---start   Mark
#         #FUN-5C0015 BY GILL --START
#        ,aag311,aag321,aag331,aag341,aag351,aag361,
#         aag31,aag32,aag33,aag34,aag35,aag36
#         #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
 
     INTO g_aag02,l_aag03,g_aag05,l_aag07,l_aagacti,
          m_aag151,m_aag161,m_aag171,m_aag181,l_aag20,
          m_aag15,m_aag16,m_aag17,m_aag18
 
#FUN-B40026   ---start   Mark
#         #FUN-5C0015 BY GILL --START
#        ,m_aag311,m_aag321,m_aag331,m_aag341,m_aag351,m_aag361,
#         m_aag31,m_aag32,m_aag33,m_aag34,m_aag35,m_aag36
#         #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
 
     FROM aag_file
    WHERE aag01=g_abg.abg03
      AND aag00=g_abg.abg00       # No.FUN-740020
   CASE WHEN STATUS = 100 LET g_errno='agl-001'
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201' 
         WHEN l_aag20 != 'Y'      LET g_errno = 'agl-211' 
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   DISPLAY g_aag02 TO aag02 
   IF cl_null(m_aag151)  THEN
       LET g_abg.abg11=NULL
       DISPLAY BY NAME g_abg.abg11
    END IF
    IF cl_null(m_aag161)  THEN
       LET g_abg.abg12=NULL
       DISPLAY BY NAME g_abg.abg12
    END IF
    IF cl_null(m_aag171) THEN
       LET g_abg.abg13=NULL
       DISPLAY BY NAME g_abg.abg13
    END IF
    IF cl_null(m_aag181) THEN
       LET g_abg.abg14=NULL
       DISPLAY BY NAME g_abg.abg14
    END IF
 
#FUN-B40026   ---start   Mark
#   #FUN-5C0015 BY GILL --START
#   IF cl_null(m_aag311) THEN
#      LET g_abg.abg31=NULL
#      DISPLAY BY NAME g_abg.abg31
#   END IF
#   IF cl_null(m_aag321) THEN
#      LET g_abg.abg32=NULL
#      DISPLAY BY NAME g_abg.abg32
#   END IF
#   IF cl_null(m_aag331) THEN
#      LET g_abg.abg33=NULL
#      DISPLAY BY NAME g_abg.abg33
#   END IF
#   IF cl_null(m_aag341) THEN
#      LET g_abg.abg34=NULL
#      DISPLAY BY NAME g_abg.abg34
#   END IF
#   IF cl_null(m_aag351) THEN
#      LET g_abg.abg35=NULL
#      DISPLAY BY NAME g_abg.abg35
#   END IF
#   IF cl_null(m_aag361) THEN
#      LET g_abg.abg36=NULL
#      DISPLAY BY NAME g_abg.abg36
#   END IF
#
#   #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
END FUNCTION
 
FUNCTION i810_abg05()
  DEFINE l_gem02   LIKE gem_file.gem02
  DEFINE l_gem05   LIKE gem_file.gem05
  DEFINE l_gemacti LIKE gem_file.gemacti
   LET g_errno = ' '
   SELECT gem02,gem05,gemacti
     INTO l_gem02,l_gem05,l_gemacti FROM gem_file
      WHERE gem01 = g_abg.abg05
    CASE WHEN STATUS = 100  LET g_errno = 'agl-003'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN l_gem05  = 'N'      LET g_errno = 'agl-202'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    DISPLAY l_gem02 TO gem02 
END FUNCTION
 
FUNCTION i810_error(p_code)
 DEFINE p_code   LIKE aag_file.aag15,
        l_str    LIKE ze_file.ze03,          #No.FUN-680098    VARCHAR(20)
        l_ahe02  LIKE ahe_file.ahe02
    
    SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = p_code
 
    #-->顯示狀況
    IF p_code IS NOT NULL AND p_code != ' ' THEN 
       CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
       #LET l_str = l_str CLIPPED,p_code,'!' 
       LET l_str = l_str CLIPPED,l_ahe02,'!' 
       ERROR l_str
    END IF
END FUNCTION
 
FUNCTION i810_abg11(p_cmd,p_seq,p_key)
 DEFINE p_cmd    LIKE aag_file.aag151,    # 檢查否
        p_seq    LIKE type_file.chr1,              # 項       #No.FUN-680098    VARCHAR(1) 
        p_key    LIKE type_file.chr20,             # 異動碼   #No.FUN-680098    VARCHAR(20)
        l_aeeacti  LIKE aee_file.aeeacti,
        l_aee04    LIKE aee_file.aee04
 
  LET g_errno = ' '
   SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file 
              WHERE aee01 = g_abg.abg03
               AND aee02 = p_seq    
                AND aee03 = p_key
                AND aee00 = g_abg.abg00        # No.FUN-740020
     CASE p_cmd
        WHEN '2'   #異動碼必須輸入不檢查
           IF p_key IS NULL OR p_key = ' ' THEN
              LET g_errno = 'agl-154'
           END IF
        WHEN '3'   #異動碼必須輸入要檢查
           CASE
              WHEN p_key IS NULL OR p_key = ' ' 
                   LET g_errno = 'agl-154'
               WHEN l_aeeacti = 'N' LET g_errno = '9027'
               WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-153'
               OTHERWISE  LET g_errno = SQLCA.sqlcode USING'-------'
           END CASE
        OTHERWISE EXIT CASE
    END CASE
END FUNCTION
 
 
#FUN-5C0015 BY GILL --START
FUNCTION  i810_show_field()
#依參數決定異動碼的多寡  
 
  DEFINE l_field  STRING 
 
#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN     
#    RETURN  
# END IF
#
# IF g_aaz.aaz88 = 0 THEN     
#    LET l_field  = "abg11,abg12,abg13,abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 1 THEN     
#    LET l_field  = "abg12,abg13,abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 2 THEN     
#    LET l_field  = "abg13,abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 3 THEN     
#    LET l_field  = "abg14,abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 4 THEN     
#    LET l_field  = "abg31,abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 5 THEN     
#    LET l_field  = "abg32,abg33,abg34,",
#                   "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 6 THEN     
#    LET l_field  = "abg33,abg34,abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 7 THEN     
#    LET l_field  = "abg34,abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 8 THEN     
#    LET l_field  = "abg35,abg36"
# END IF  
#
# IF g_aaz.aaz88 = 9 THEN     
#    LET l_field  = "abg36"
# END IF  
#FUN-B50105   ---start   Mark
 
#FUN-B50105   ---start   Add
   IF g_aaz.aaz88 = 0 THEN
      LET l_field = "abg11,abg12,abg13,abg14"
   END IF
   IF g_aaz.aaz88 = 1 THEN
      LET l_field = "abg12,abg13,abg14"
   END IF
   IF g_aaz.aaz88 = 2 THEN
      LET l_field = "abg13,abg14"
   END IF
   IF g_aaz.aaz88 = 3 THEN
      LET l_field = "abg14"
   END IF
   IF g_aaz.aaz88 = 4 THEN
      LET l_field = ""
   END IF
   IF NOT cl_null(l_field) THEN lET l_field = l_field,"," END IF
   IF g_aaz.aaz125 = 5 THEN
      LET l_field = l_field,"abg32,abg33,abg34,abg35,abg36"
   END IF
   IF g_aaz.aaz125 = 6 THEN
      LET l_field = l_field,"abg33,abg34,abg35,abg36"
   END IF
   IF g_aaz.aaz125 = 7 THEN
      LET l_field = l_field,"abg34,abg35,abg36"
   END IF
   IF g_aaz.aaz125 = 8 THEN
      LET l_field = l_field,"abg35,abg36"
   END IF
#FUN-B50105   ---end     Add

  CALL cl_set_comp_visible(l_field,FALSE)
END FUNCTION
#FUN-BC0092--Begin--
FUNCTION i810_r1()
   DEFINE l_wc,l_sql  LIKE type_file.chr1000
   DEFINE l_abg00     LIKE abg_file.abg00
   DEFINE l_abg01     LIKE abg_file.abg01
   DEFINE l_abg02     LIKE abg_file.abg02
   DEFINE l_abg072    LIKE abg_file.abg072
   DEFINE l_aaa07     LIKE aaa_file.aaa07
   DEFINE l_abg06     LIKE abg_file.abg06
   DEFINE l_abg15     LIKE abg_file.abg15   #FUN-C90083

   OPEN WINDOW i810_w1 AT 8,20
     WITH FORM "agl/42f/agli810_r"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli810_r")

   CONSTRUCT BY NAME l_wc ON abg00,abg01,abg02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(abg00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO abg00
               NEXT FIELD abg00
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

   IF INT_FLAG THEN
      CLOSE WINDOW i810_w1
      LET INT_FLAG=0
      RETURN
   END IF

   IF l_wc = ' 1=1' THEN
      CALL cl_err('','9046',1)
      CLOSE WINDOW i810_w1
   ELSE
      IF NOT cl_sure(16,16) THEN
         CLOSE WINDOW i810_w1
         RETURN
      END IF

      LET l_sql = " SELECT abg00,abg01,abg02,abg06,SUM(abg072+abg073) "
                 ,"       ,abg15"                                         #FUN-C90083
                 ,"   FROM abg_file"
                 ,"  WHERE abg15 in ('0','2') AND ",l_wc CLIPPED
                 ,"  GROUP BY abg00,abg01,abg02,abg06"
                 ,"          ,abg15"                                      #FUN-C90083
      PREPARE i810_r1_p FROM l_sql
      DECLARE i810_r1_c CURSOR FOR i810_r1_p
      CALL s_showmsg_init()
      FOREACH i810_r1_c INTO l_abg00,l_abg01,l_abg02,l_abg06,l_abg072,l_abg15  #FUN-C90083 add
        #FUN-C90083--Begin Mark--
        #IF l_abg072 <> 0 THEN
        #   LET g_showmsg = l_abg00,"/",l_abg01,"/",l_abg02
        #   CALL s_errmsg('abg00,abg01,abg02',g_showmsg,'','anm-800',1)
        #   CONTINUE FOREACH
        #END IF
        #FUN-C90083---End Mark---
         SELECT aaa07 INTO l_aaa07
           FROM aaa_file WHERE aaa01 = l_abg00
              IF l_abg06 <= l_aaa07 THEN               #判斷傳票日期是否小於關帳日
                 LET g_showmsg = l_abg00,"/",l_abg01,"/",l_abg02
                 CALL s_errmsg('abg00,abg01,abg02',g_showmsg,'','agl-200',1)
                 CONTINUE FOREACH
              END IF
        #FUN-C90083--Begin Mark--
        #LET l_sql= " DELETE FROM abg_file "
        #          ," WHERE abg15 in ('0','2') "
        #          ,"   AND abg00 = '",l_abg00,"'"
        #          ,"   AND abg01 = '",l_abg01,"'"
        #          ,"   AND abg02 = '",l_abg02,"'"
        #PREPARE i810_r_p FROM l_sql
        #EXECUTE i810_r_p
        #FUN-C90083---End Mark---
        #FUN-C90083---B---
        DELETE FROM abg_file WHERE abg15 in ('0','2')
          AND abg00 = l_abg00 AND abg01 = l_abg01 AND abg02 = l_abg02
        #FUN-C90083---E---
      END FOREACH
      CALL s_showmsg()

      CLOSE WINDOW i810_w1
   END IF
END FUNCTION
#FUN-BC0092---End--- 
 
FUNCTION i810_set_no_required()
#FUN-B40026   ---start   Mark
#  CALL cl_set_comp_required("abg11,abg12,abg13,abg14,abg31,abg32,abg33,abg34,abg35,
#                        abg36",FALSE)
#FUN-B40026   ---end     Mark

#FUN-B40026   ---start   Add
   CALL cl_set_comp_required("abg11,abg12,abg13,abg14",FALSE)
#FUN-B40026   ---end     Add
END FUNCTION
 
FUNCTION i810_set_required()
 
   IF m_aag151 MATCHES '[23]' THEN
      CALL cl_set_comp_required("abg11",TRUE)
   END IF
   IF m_aag161 MATCHES '[23]' THEN
      CALL cl_set_comp_required("abg12",TRUE)
   END IF
   IF m_aag171 MATCHES '[23]' THEN
      CALL cl_set_comp_required("abg13",TRUE)
   END IF
   IF m_aag181 MATCHES '[23]' THEN
      CALL cl_set_comp_required("abg14",TRUE)
   END IF
#FUN-B40026   ---start   Mark
#  IF m_aag311 MATCHES '[23]' THEN
#     CALL cl_set_comp_required("abg31",TRUE)
#  END IF
#  IF m_aag321 MATCHES '[23]' THEN
#     CALL cl_set_comp_required("abg32",TRUE)
#  END IF
#  IF m_aag331 MATCHES '[23]' THEN
#     CALL cl_set_comp_required("abg33",TRUE)
#  END IF
#  IF m_aag341 MATCHES '[23]' THEN
#     CALL cl_set_comp_required("abg34",TRUE)
#  END IF
#  IF m_aag351 MATCHES '[23]' THEN
#     CALL cl_set_comp_required("abg35",TRUE)
#  END IF
#  IF m_aag361 MATCHES '[23]' THEN
#     CALL cl_set_comp_required("abg36",TRUE)
#  END IF
#FUN-B40026   ---end     Mark
 
END FUNCTION
 
#FUN-5C0015 BY GILL --END
 
 
