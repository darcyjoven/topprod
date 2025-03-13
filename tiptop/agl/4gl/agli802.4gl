# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agli802.4gl
# Descriptions...: 科目異動碼預算維護作業
# Date & Author..: 92/02/21 BY Nora
#       MODIFY...: 92/09/09 BY Roger
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-590124 05/10/05 By Dido aag02科目名稱放寬
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650029 06/05/10 By Dido 按"調整"後，選擇"放棄"會出現-201
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By hongmei 會計科目加帳套-財務
# Modify.........: No.TQC-740093 07/04/18 By bnlent 會計科目加帳套-財務BUG修改,解決q_aag開窗無資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760105 07/06/15 By dxfwo   agli802(科目異動碼預算) 
                   # 帳別 per應設 notnull,required打印出現 -284 error (子查詢....不只一列..)帳別未印出!
# Modify.........: No.TQC-7C0006 07/12/04 By dxfwo   agli802(科目異動碼預算)打印異常問題
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-830057 08/03/25 By judy 查詢時畫面期預算/已消耗預算保留上次查詢值
# Modify.........: No.FUN-830113 08/03/25 By Sunyanchun  老報表改CR
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9C0134 09/12/16 By Carrier afb041/afb042 賦初值
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_afb   RECORD LIKE afb_file.*,
    g_afb_t RECORD LIKE afb_file.*,
    g_afb_o RECORD LIKE afb_file.*,
    g_aaa   RECORD LIKE aaa_file.*,
    g_bookno   LIKE afb_file.afb00,
    g_afb00_t LIKE afb_file.afb00,        #No.FUN-740020
    g_afb01_t LIKE afb_file.afb01,
    g_afb02_t LIKE afb_file.afb02,
    g_afb03_t LIKE afb_file.afb03,
    g_afb04_t LIKE afb_file.afb04,
    g_afc  RECORD 					#各期預算
           afc06_1 LIKE afc_file.afc06,
           afc06_2 LIKE afc_file.afc06,
           afc06_3 LIKE afc_file.afc06,
           afc06_4 LIKE afc_file.afc06,
           afc06_5 LIKE afc_file.afc06,
           afc06_6 LIKE afc_file.afc06,
           afc06_7 LIKE afc_file.afc06,
           afc06_8 LIKE afc_file.afc06,
           afc06_9 LIKE afc_file.afc06,
           afc06_10 LIKE afc_file.afc06,
           afc06_11 LIKE afc_file.afc06,
           afc06_12 LIKE afc_file.afc06,
           afc06_13 LIKE afc_file.afc06
    END RECORD,
    g_afc1 RECORD 					#各期已消耗預算
           afc07_1 LIKE afc_file.afc07,
           afc07_2 LIKE afc_file.afc07,
           afc07_3 LIKE afc_file.afc07,
           afc07_4 LIKE afc_file.afc07,
           afc07_5 LIKE afc_file.afc07,
           afc07_6 LIKE afc_file.afc07,
           afc07_7 LIKE afc_file.afc07,
           afc07_8 LIKE afc_file.afc07,
           afc07_9 LIKE afc_file.afc07,
           afc07_10 LIKE afc_file.afc07,
           afc07_11 LIKE afc_file.afc07,
           afc07_12 LIKE afc_file.afc07,
           afc07_13 LIKE afc_file.afc07
    END RECORD,
    g_afc_o  RECORD
           afc06_1 LIKE afc_file.afc06,
           afc06_2 LIKE afc_file.afc06,
           afc06_3 LIKE afc_file.afc06,
           afc06_4 LIKE afc_file.afc06,
           afc06_5 LIKE afc_file.afc06,
           afc06_6 LIKE afc_file.afc06,
           afc06_7 LIKE afc_file.afc06,
           afc06_8 LIKE afc_file.afc06,
           afc06_9 LIKE afc_file.afc06,
           afc06_10 LIKE afc_file.afc06,
           afc06_11 LIKE afc_file.afc06,
           afc06_12 LIKE afc_file.afc06,
           afc06_13 LIKE afc_file.afc06
    END RECORD,
    g_afc_t  RECORD
           afc06_1 LIKE afc_file.afc06,
           afc06_2 LIKE afc_file.afc06,
           afc06_3 LIKE afc_file.afc06,
           afc06_4 LIKE afc_file.afc06,
           afc06_5 LIKE afc_file.afc06,
           afc06_6 LIKE afc_file.afc06,
           afc06_7 LIKE afc_file.afc06,
           afc06_8 LIKE afc_file.afc06,
           afc06_9 LIKE afc_file.afc06,
           afc06_10 LIKE afc_file.afc06,
           afc06_11 LIKE afc_file.afc06,
           afc06_12 LIKE afc_file.afc06,
           afc06_13 LIKE afc_file.afc06
    END RECORD,
    l_afc06   ARRAY[13] OF LIKE afc_file.afc06,
    l_afc07   ARRAY[13] OF LIKE afc_file.afc07,
#   g_wc,gsql          VARCHAR(300) 
    g_wc,g_sql          STRING        #TQC-630166  
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE g_exit                LIKE type_file.chr20    #No.FUN-680098 VARCHAR(10)
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680098 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE   g_cnt1          LIKE type_file.num10        #No.TQC-760105 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose  #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680098 SMALLINT
DEFINE   l_table         STRING                      #No.FUN-830113  add                                                            
DEFINE   g_str           STRING                      #No.FUN-830113  add
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
       DEFINE
           p_row,p_col     LIKE type_file.num5      #No.FUN-680098 SMALLINT
 
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
   #No.FUN-830113---------------start-------------------                        
   LET g_sql = "afb00.afb_file.afb00,",                                         
             "afb01.afb_file.afb01,",                                            
             "afa02.afa_file.afa02,",                                            
             "azi04.azi_file.azi04,",                                            
             "azi05.azi_file.azi05,",                                            
             "afbacti.afb_file.afbacti,",                                        
             "aag02.aag_file.aag02,",                                            
             "afb02.afb_file.afb02,",                                            
             "afb03.afb_file.afb03,",                                            
             "afb05.afb_file.afb05,",                                            
             "afc06_1.afc_file.afc06,",                                          
             "afc06_2.afc_file.afc06,",                                          
             "afc06_3.afc_file.afc06,",                                          
             "afc06_4.afc_file.afc06,",                                          
             "afc06_5.afc_file.afc06,",                                          
             "afc06_6.afc_file.afc06,",                                          
             "afc06_7.afc_file.afc06,",                                          
             "afc06_8.afc_file.afc06,",                                          
             "afc06_9.afc_file.afc06,",                                          
             "afc06_10.afc_file.afc06,",                                         
             "afc06_11.afc_file.afc06,",                                         
             "afc06_12.afc_file.afc06,",
             "afc06_13.afc_file.afc06,",                                         
             "afb11.afb_file.afb11,",                                            
             "afb12.afb_file.afb12,",                                            
             "afb13.afb_file.afb13,",                                            
             "afb14.afb_file.afb14,",                                            
             "afb10.afb_file.afb10"
   LET l_table = cl_prt_temptable('agli802',g_sql) CLIPPED                      
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                    
                                                                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,               
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"              
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
   #No.FUN-830113---------------end------------------- 
    INITIALIZE g_afb.* TO NULL
    INITIALIZE g_afc.* TO NULL
    INITIALIZE g_afb_t.* TO NULL
    INITIALIZE g_afb_o.* TO NULL
    INITIALIZE g_afc_t.* TO NULL
    INITIALIZE g_afc_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM afb_file WHERE afb00 = ? AND afb01 = ? AND afb02 = ? AND afb03 = ? AND afb04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i802_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i802_w AT p_row,p_col
         WITH FORM "agl/42f/agli802"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#No.FUN-740020   ---Begin
#   LET g_bookno = ARG_VAL(1)
#   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
#   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
#   SELECT azi04 INTO t_azi04        #幣別檔小數位數讀取       #CHI-6A0004
#     FROM azi_file WHERE azi01=g_aaa.aaa03
#No.FUN-740020   ---End
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i802_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i802_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i802_cs()
    CLEAR FORM
   INITIALIZE g_afb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
#       afb01   ,afb02  ,afb03  ,afb04,  afb07   , afb08  , afb09  ,
        afb00   ,afb01   ,afb02  ,afb03  ,afb04,  afb07   , afb09  ,       #No.FUN-740020
        afb05   ,afb06  , afb10 ,
        afc06_1 ,afc06_2,afc06_3,afc06_4 ,afc06_5 ,afc06_6 ,
        afc06_7 ,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,
        afc06_13,afb11  ,afb12  ,afb13  ,afb14   ,
        afbuser ,afbgrup,afbmodu,afbdate,afbacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp
       #No.FUN-740020 --Begin
       IF INFIELD(afb00) THEN                                                                                                       
          CALL cl_init_qry_var()                                                                                                    
          LET g_qryparam.state = "c"                                                                                                
          LET g_qryparam.form ="q_aaa"                                                                                              
          CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                        
          DISPLAY g_qryparam.multiret TO afb00                                                                                      
       END IF
       #No.FUN-740020 ---End
       IF INFIELD(afb01) THEN
#         CALL q_afa(0,0,g_afb.afb01,g_bookno) RETURNING g_afb.afb01
          CALL cl_init_qry_var()
          LET g_qryparam.state = "c"
          LET g_qryparam.form ="q_afa"
          LET g_qryparam.default1 = g_afb.afb01
          #CALL cl_create_qry() RETURNING g_afb.afb01
          #DISPLAY BY NAME g_afb.afb01
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO afb01
          CALL i802_afb01('d')
       END IF
       IF INFIELD(afb02) THEN
#         CALL q_aag(0,0,g_afb.afb02,' ','24',' ') RETURNING g_afb.afb02
          CALL cl_init_qry_var()
          LET g_qryparam.state = "c"
          LET g_qryparam.form ="q_aag"
          LET g_qryparam.default1 = g_afb.afb02
          LET g_qryparam.where ="  aag03 IN ('2','4')"
          #CALL cl_create_qry() RETURNING g_afb.afb02
          #DISPLAY BY NAME g_afb.afb02
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO afb02
          CALL i802_afb02('d')
       END IF
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
    #        LET g_wc = g_wc clipped," AND afbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND afbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND afbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
    #End:FUN-980030
#No.FUN-740020 ---Begin
#   LET g_sql="SELECT afb01 FROM afb_file ", # 組合出 SQL 指令
#       " WHERE afb00 = '",g_bookno,"'",
#       " AND ", g_wc CLIPPED, " AND afb15 = '3'",
       #" ORDER BY afb01"
#       " ORDER BY afb01,afb04,afb02,afb03" #no.7355
    LET g_sql="SELECT afb00,afb01,afb02,afb03,afb04 FROM afb_file ", # 組合出 SQL 指令                                        
              " WHERE ", g_wc CLIPPED, " AND afb15 = '3'",                                                                          
              "   AND afbacti = 'Y' ",                       #FUN-D70090 add 
              " ORDER BY afb00,afb01,afb04,afb02,afb03"
#No.FUn-740020 ---End   
    PREPARE i802_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i802_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i802_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM afb_file WHERE ",
#       " afb00 = '",g_bookno,"' AND ",g_wc CLIPPED," AND afb15 = '3'"       #No.FUN-740020
        g_wc CLIPPED," AND afb15 = '3'"        #No.FUN-740020
       ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
    PREPARE i802_precount FROM g_sql
    DECLARE i802_count CURSOR FOR i802_precount
END FUNCTION
 
FUNCTION i802_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i802_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i802_q()
            END IF
        ON ACTION next
            CALL i802_fetch('N')
        ON ACTION previous
            CALL i802_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i802_u()
            END IF
        ON ACTION adjust
            LET g_action_choice="adjust"
            IF cl_chk_act_auth() AND g_afb.afb01 IS NOT NULL THEN
                 CALL i802_m()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i802_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i802_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i802_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i802_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #CKP
            CALL cl_set_field_pic("","","","","",g_afb.afbacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION jump
            CALL i802_fetch('/')
        ON ACTION first
            CALL i802_fetch('F')
        ON ACTION last
            CALL i802_fetch('L')

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
              IF g_afb.afb01 IS NOT NULL THEN
                 LET g_doc.column1 = "afb00"
                 LET g_doc.value1 = g_afb.afb00
                 LET g_doc.column2 = "afb01"
                 LET g_doc.value2 = g_afb.afb01
                 LET g_doc.column3 = "afb02"
                 LET g_doc.value3 = g_afb.afb02
                 LET g_doc.column4 = "afb03"
                 LET g_doc.value4 = g_afb.afb03
                 LET g_doc.column5 = "afb04"
                 LET g_doc.value5 = g_afb.afb04
                 CALL cl_doc()
              END IF
           END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i802_cs
END FUNCTION
 
 
FUNCTION i802_a()
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_afb.* LIKE afb_file.*
    LET g_afb.afb15 = '3'
    INITIALIZE g_afc.* TO NULL
    LET g_afb01_t = NULL LET g_afb02_t = NULL
    LET g_afb03_t = NULL LET g_afb04_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
#       LET g_afb.afb00 = g_bookno   #No.FUN-740020       
        LET g_afb.afb07 = '1'
        LET g_afb.afb08 = '1'
        LET g_afb.afb09 = 'Y'
        LET g_afb.afbacti ='Y'                   #有效的資料
        LET g_afb.afbuser = g_user
        LET g_afb.afboriu = g_user #FUN-980030
        LET g_afb.afborig = g_grup #FUN-980030
        LET g_afb.afbgrup = g_grup               #使用者所屬群
        LET g_afb.afbdate = g_today
        INITIALIZE g_afb_o.* TO NULL
        INITIALIZE g_afc_o.* TO NULL
        CALL i802_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_afb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_afb.afb01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        #No.FUN-740020 ---Begin
        IF g_afb.afb00 IS NULL THEN                # KEY 不可空白                                                           
           CONTINUE WHILE                                                                                                   
        END IF
        #No.FUN-740020 ---End
        #No.TQC-9C0134  --Begin                                                 
        IF cl_null(g_afb.afb041) THEN LET g_afb.afb041 = ' ' END IF             
        IF cl_null(g_afb.afb042) THEN LET g_afb.afb042 = ' ' END IF             
        #No.TQC-9C0134  --End
        INSERT INTO afb_file VALUES(g_afb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","afb_file",g_afb.afb01,g_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        ELSE
            LET g_afb_t.* = g_afb.*                # 保存上筆資料
            LET g_afc_t.* = g_afc.*                # 保存上筆資料
            LET g_afb_o.* = g_afb.*                # 保存上筆資料
            LET g_afc_o.* = g_afc.*                # 保存上筆資料
            SELECT afb00 INTO g_afb.afb00 FROM afb_file
#               WHERE afb00 = g_bookno AND afb01 = g_afb.afb01           #No.FUN-740020
                WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01        #No.FUN-740020
                  AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                  AND afb04 = g_afb.afb04 AND afbacti = 'Y'              #FUN-D70090 add
           BEGIN WORK
           CALL i802_addafc('a')   #產生期預算
           COMMIT WORK
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i802_addafc(p_cmd)
    DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#           l_sql     VARCHAR(200),
            l_sql     STRING,        #TQC-630166    
            l_n       LIKE type_file.num5          #No.FUN-680098 SMALLINT
    IF p_cmd = 'u' THEN
#      DELETE FROM afc_file WHERE afc00 = g_bookno AND afc01 = g_afb.afb01        #No.FUN-740020
       DELETE FROM afc_file WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01     #No.FUN-740020
                              AND afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                              AND afc04 = g_afb.afb04
       IF SQLCA.sqlcode THEN
#         CALL cl_err('delete:',SQLCA.sqlcode,0) #NO.FUN-660123
#         CALL cl_err3("del","afc_file",g_bookno,g_afb.afb01,SQLCA.sqlcode,"","delete:",1) #NO.FUN-660123
          CALL cl_err3("del","afc_file",g_afb.afb00,g_afb.afb01,SQLCA.sqlcode,"","delete:",1) #NO.TQC-760105
       END IF
    END IF
    LET l_afc06[1] = g_afc.afc06_1  LET l_afc06[2] = g_afc.afc06_2
    LET l_afc06[3] = g_afc.afc06_3  LET l_afc06[4] = g_afc.afc06_4
    LET l_afc06[5] = g_afc.afc06_5  LET l_afc06[6] = g_afc.afc06_6
    LET l_afc06[7] = g_afc.afc06_7  LET l_afc06[8] = g_afc.afc06_8
    LET l_afc06[9] = g_afc.afc06_9  LET l_afc06[10] = g_afc.afc06_10
    LET l_afc06[11] = g_afc.afc06_11  LET l_afc06[12] = g_afc.afc06_12
    LET l_afc06[13] = g_afc.afc06_13
     LET l_sql = "INSERT INTO afc_file (afc00,afc01,afc02,afc03,afc04,afc05,",  #No:BUG-470041 #No.MOD-470574
                "                      afc06,afc07) ",
  #             " VALUES ('",g_bookno,"','",g_afb.afb01,"','",            #No.FUN-740020
                " VALUES ('",g_afb.afb00,"','",g_afb.afb01,"','",         #No.FUN-740020
                g_afb.afb02,"',",g_afb.afb03,",'",g_afb.afb04,"',",
                "?,?,?)"
    PREPARE i802_p3 FROM l_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) END IF
    DECLARE i802_c3 CURSOR FOR i802_p3
    OPEN i802_c3
    IF g_aza.aza02 = '1' THEN
       LET g_cnt = 12
    ELSE
       LET g_cnt = 13
    END IF
    FOR l_n = 1 TO g_cnt
        IF (l_afc06[l_n] IS NULL OR l_afc06[l_n] = 0) AND
           (l_afc07[l_n] IS NULL OR l_afc07[l_n] = 0) THEN
           CONTINUE FOR
        END IF
        IF l_afc06[l_n] IS NULL THEN LET l_afc06[l_n] = 0 END IF
        IF l_afc07[l_n] IS NULL THEN LET l_afc07[l_n] = 0 END IF
        PUT i802_c3 FROM l_n,l_afc06[l_n],l_afc07[l_n]
        IF SQLCA.sqlcode THEN
           CALL cl_err('insert:',SQLCA.sqlcode,0) EXIT FOR
        END IF
    END FOR
    CLOSE i802_c3
END FUNCTION
 
FUNCTION i802_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680098CHAR(1)
        l_dir1          LIKE type_file.chr1,          #                              #No.FUN-680098CHAR(1)    
        l_dir2          LIKE type_file.chr1,          #                              #No.FUN-680098CHAR(1)    
        l_dir3          LIKE type_file.chr1,          #                              #No.FUN-680098CHAR(1)         
        l_n             LIKE type_file.num5           #No.FUN-680098  SMALLINT
 
    DISPLAY BY NAME g_afb.afbuser,g_afb.afbgrup,
        g_afb.afbdate, g_afb.afbacti
 
    INPUT BY NAME g_afb.afboriu,g_afb.afborig,
        g_afb.afb00   ,    #No.FUN-740020
        g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb04   ,
#       g_afb.afb07   ,g_afb.afb08,   g_afb.afb09   ,
        g_afb.afb07   ,g_afb.afb09   ,
        g_afb.afb05   ,g_afb.afb06   ,  g_afb.afb10   ,g_afc.afc06_1 ,
        g_afc.afc06_2 ,g_afc.afc06_3 ,g_afc.afc06_4 ,g_afc.afc06_5 ,
        g_afc.afc06_6 ,g_afc.afc06_7 ,g_afc.afc06_8 ,g_afc.afc06_9 ,
        g_afc.afc06_10,g_afc.afc06_11,g_afc.afc06_12,g_afc.afc06_13,
        g_afb.afb11   ,g_afb.afb12   ,g_afb.afb13   ,g_afb.afb14
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i802_set_entry(p_cmd)
            CALL i802_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        #No.FUN-740020 ---Begin
        AFTER FIELD afb00                                                                                                           
            IF g_afb.afb00 IS NOT NULL THEN                                                                                         
               IF (g_afb_o.afb00 IS NULL) OR (g_afb.afb00 != g_afb_o.afb00) THEN                                                    
                  CALL i802_afb00('a')                                                                                              
                  IF NOT cl_null(g_errno) THEN                                                                                      
                     CALL cl_err(g_afb.afb00,g_errno,0)                                                                             
                     LET g_afb.afb00 = g_afb_t.afb00                                                                                
                     DISPLAY BY NAME g_afb.afb00                                                                                    
                     NEXT FIELD afb00                                                                                               
                  END IF                                                                                                            
               END IF                                                                                                               
               SELECT * INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_afb.afb00                                                        
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03                                                          
               LET g_afb_o.afb00 = g_afb.afb00                                                                                      
            END IF
        #No.FUn-740020 ---End
 
        AFTER FIELD afb01
            IF cl_null(g_afb.afb00) THEN NEXT FIELD afb00 END IF   #No.FUN-740020
            IF g_afb.afb01 IS NOT NULL THEN
               IF (g_afb_o.afb01 IS NULL) OR (g_afb.afb01 != g_afb_o.afb01) THEN
                  CALL i802_afb01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_afb.afb01,g_errno,0)
                     LET g_afb.afb01 = g_afb_t.afb01
                     DISPLAY BY NAME g_afb.afb01
                     NEXT FIELD afb01
                  END IF
               END IF
               LET g_afb_o.afb01 = g_afb.afb01
            END IF
 
        AFTER FIELD afb02
            IF g_afb.afb02 IS NOT NULL THEN
               IF (g_afb_o.afb02 IS NULL) OR (g_afb.afb02 != g_afb_o.afb02) THEN
                  CALL i802_afb02('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_afb.afb02,g_errno,0)
                    #Mod No.FUN-B10048
                    #LET g_afb.afb02 = g_afb_o.afb02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.construct = 'N'
                     LET g_qryparam.arg1 = g_afb.afb00    #No.TQC-740093
                     LET g_qryparam.default1 = g_afb.afb02
                     LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 IN ('2','4') AND aag01 LIKE '",g_afb.afb02 CLIPPED,"%'"
                     CALL cl_create_qry() RETURNING g_afb.afb02
                    #End Mod No.FUN-B10048
                     DISPLAY BY NAME g_afb.afb02
                     NEXT FIELD afb02
                  END IF
               END IF
               LET g_afb_o.afb02 = g_afb.afb02
            END IF
 
        AFTER FIELD afb04
            IF g_afb.afb04 IS NOT NULL THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#                (p_cmd = "u" AND g_afb.afb00 = g_bookno          #No.FUN-740020
                 (p_cmd = "u" AND (g_afb.afb00 != g_afb00_t       #No.FUN-740020
          #       AND g_afb.afb01 != g_afb01_t AND g_afb.afb02 != g_afb02_t   #No.FUN-740020
          #       AND g_afb.afb03 != g_afb03_t AND g_afb.afb04 != g_afb04_t)  #No.FUN-740020
                  OR g_afb.afb01 != g_afb01_t OR g_afb.afb02 != g_afb02_t     #No.FUN-740020                                                         
                  OR g_afb.afb03 != g_afb03_t OR g_afb.afb04 != g_afb04_t))   #No.FUN-740020
                  THEN
                      SELECT count(*) INTO l_n FROM afb_file
#                      WHERE afb00 = g_bookno         #No.FUN-740020
                       WHERE afb00 = g_afb.afb00      #No.FUN-740020      
                         AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02
                         AND afb03 = g_afb.afb03 AND afb04 = g_afb.afb04
                         AND afbacti = 'Y'                         #FUN-D70090 add
                   IF l_n > 0 THEN                  # Duplicated
                       LET g_msg = g_afb.afb00 CLIPPED,    #No.FUN-740020
                               '+',g_afb.afb01 CLIPPED,
                               '+',g_afb.afb02 CLIPPED,
                               '+',g_afb.afb03 CLIPPED,
                               '+',g_afb.afb04 CLIPPED     #No.FUN-740020
                       CALL cl_err(g_msg,-239,0)
                       LET g_afb.afb01 = g_afb01_t LET g_afb.afb02 = g_afb02_t
                       LET g_afb.afb03 = g_afb03_t LET g_afb.afb04 = g_afb04_t
                       LET g_afb.afb00 = g_afb00_t       #No.FUN-740020
                       DISPLAY BY NAME g_afb.afb00,g_afb.afb01,g_afb.afb02,       #No.FUN-740020
                                       g_afb.afb03,g_afb.afb04 
                  #    NEXT FIELD afb01     #No.FUN-740020
                       NEXT FIELD afb00     #No.FUN-740020
                   END IF
               END IF
            END IF
 
        AFTER FIELD afb07
            IF NOT cl_null(g_afb.afb07) THEN
               IF g_afb.afb07 NOT MATCHES '[1-3]' THEN
                  LET g_afb.afb07 = g_afb_o.afb07
                  DISPLAY BY NAME g_afb.afb07
                  NEXT FIELD afb07
               END IF
           END IF
 
        AFTER FIELD afb09
            IF NOT cl_null(g_afb.afb09) THEN
               IF g_afb.afb09 NOT MATCHES '[yYnN]' THEN
                  LET g_afb.afb09 = g_afb_o.afb09
                  DISPLAY BY NAME g_afb.afb09
                  NEXT FIELD afb09
               END IF
           END IF
 
        BEFORE FIELD afb05
            CALL i802_set_entry(p_cmd)
 
 
        AFTER FIELD afb05
            IF g_afb.afb05 IS NOT NULL THEN
               CALL i802_set_no_entry(p_cmd)
               IF g_afb.afb05 NOT MATCHES'[1-3]' THEN
                  LET g_afb.afb05 = g_afb_o.afb05
                  DISPLAY BY NAME g_afb.afb05
                  NEXT FIELD afb05
               END IF
               IF g_afb_o.afb05 != g_afb.afb05 THEN
                  CASE g_afb.afb05
                       WHEN '1'  LET g_afb.afb06 = NULL   LET g_afb.afb10 = NULL
                                 LET g_afb.afb11 = NULL   LET g_afb.afb12 = NULL
                                 LET g_afb.afb13 = NULL   LET g_afb.afb14 = NULL
                                 DISPLAY BY NAME g_afb.afb06,g_afb.afb10,
                                                 g_afb.afb11,g_afb.afb12,
                                                 g_afb.afb13,g_afb.afb14
                       WHEN '2'  LET g_afb.afb06 = NULL   LET g_afb.afb10 = NULL
                                 INITIALIZE g_afc.* TO NULL
                                 DISPLAY BY NAME g_afb.afb06,g_afb.afb10,
                                                 g_afc.*
                       WHEN '3'  LET g_afb.afb11 = NULL   LET g_afb.afb12 = NULL
                                 LET g_afb.afb13 = NULL   LET g_afb.afb14 = NULL
                                 INITIALIZE g_afc.* TO NULL
                                 DISPLAY BY NAME g_afb.afb11,g_afb.afb12,
                                                 g_afb.afb13,g_afb.afb14,
                                                 g_afc.*
                  END CASE
               END IF
               LET g_afb_o.afb05 = g_afb.afb05
               LET l_dir1 = 'U'
               LET l_dir2 = 'U'
               LET l_dir3 = 'U'
            END IF
            CALL i802_set_no_entry(p_cmd)
{
        BEFORE FIELD afb06
            CASE g_afb.afb05
                 WHEN '1'
                     IF l_dir1 = 'U' THEN
                        NEXT FIELD afc06_1
                     END IF
                 OTHERWISE
                     IF g_aza.aza02 = '2' THEN
                        LET g_afb.afb06 = '2'
                        IF g_afb.afb05 = '2' THEN
                           IF l_dir2 = 'U' THEN
                              NEXT FIELD afb11
                           ELSE
                              NEXT FIELD afb05
                           END IF
                        ELSE
                           IF l_dir3 = 'U' THEN
                              NEXT FIELD afb11
                           ELSE
                              NEXT FIELD afb05
                           END IF
                        END IF
                        DISPLAY BY NAME g_afb.afb06
                     END IF
           END CASE
}
        AFTER FIELD afb06
            IF g_afb.afb06 IS NOT NULL THEN
               IF g_afb.afb06 NOT MATCHES'[12]' THEN
                  LET g_afb.afb06 = g_afb_o.afb06
                  DISPLAY BY NAME g_afb.afb06
                  NEXT FIELD afb06
               END IF
               IF g_afb.afb05 != '1' AND
                  g_afb.afb06 != g_afb_o.afb06 THEN
                  CALL i802_period('a')      #計算期預算
               END IF
               LET l_dir2 = 'U'
               LET g_afb_o.afb06 = g_afb.afb06
            END IF
{
        BEFORE FIELD afb10
            CASE g_afb.afb05
                 WHEN '2'
                     IF l_dir2 = 'U' THEN
                        NEXT FIELD afb11
                     ELSE
                        NEXT FIELD afb06
                     END IF
                 WHEN '1'
                     NEXT FIELD afb05
            END CASE
}
        AFTER FIELD afb10
            LET l_dir1 = 'D'
            LET g_afb.afb11 = g_afb.afb10 * 0.25
            LET g_afb.afb12 = g_afb.afb10 * 0.25
            LET g_afb.afb13 = g_afb.afb10 * 0.25
            LET g_afb.afb14 = g_afb.afb10 -
               (g_afb.afb11 + g_afb.afb12 + g_afb.afb13)
            CALL i802_period('a')      #計算期預算
            LET l_dir3 = 'D'
            LET g_afb.afb10 = cl_numfor(g_afb.afb10,15,t_azi04)      #CHI-6A0004
            DISPLAY BY NAME g_afb.afb10
 
        BEFORE FIELD afc06_1
            CASE g_afb.afb05
                 WHEN '3'  EXIT INPUT
           END CASE
 
        AFTER FIELD afc06_1
           CALL i802_afb11()          #重新計算季預算
           LET g_afc_o.afc06_1 = g_afc.afc06_1
           LET l_dir1 = 'D'
 
        AFTER FIELD afc06_2
           CALL i802_afb11()          #重新計算季預算
           LET g_afc_o.afc06_2 = g_afc.afc06_2
 
        AFTER FIELD afc06_3
           CALL i802_afb11()          #重新計算季預算
           LET g_afc_o.afc06_3 = g_afc.afc06_3
 
        AFTER FIELD afc06_4
           CALL i802_afb12()          #重新計算季預算
           LET g_afc_o.afc06_4 = g_afc.afc06_4
 
        AFTER FIELD afc06_5
           CALL i802_afb12()          #重新計算季預算
           LET g_afc_o.afc06_5 = g_afc.afc06_5
 
        AFTER FIELD afc06_6
           CALL i802_afb12()          #重新計算季預算
           LET g_afc_o.afc06_6 = g_afc.afc06_6
 
        AFTER FIELD afc06_7
           CALL i802_afb13()          #重新計算季預算
           LET g_afc_o.afc06_7 = g_afc.afc06_7
 
        AFTER FIELD afc06_8
           CALL i802_afb13()          #重新計算季預算
           LET g_afc_o.afc06_8 = g_afc.afc06_8
 
        AFTER FIELD afc06_9
           CALL i802_afb13()          #重新計算季預算
           LET g_afc_o.afc06_9 = g_afc.afc06_9
 
        AFTER FIELD afc06_10
           CALL i802_afb14()          #重新計算季預算
           LET g_afc_o.afc06_10 = g_afc.afc06_10
 
        AFTER FIELD afc06_11
           CALL i802_afb14()          #重新計算季預算
           LET g_afc_o.afc06_11 = g_afc.afc06_11
 
        AFTER FIELD afc06_12
           CALL i802_afb14()
 
        BEFORE FIELD afc06_13
           IF g_aza.aza02 = '1' THEN EXIT INPUT END IF
 
        AFTER FIELD afc06_13
           CALL i802_afb14()
 
        BEFORE FIELD afb11
           CASE g_afb.afb05
                WHEN '1' EXIT INPUT
           END CASE
 
 
        AFTER FIELD afb11
           CALL i802_afb10()          #重新計算季預算
           CALL i802_period('1')
           LET g_afb_o.afb11 = g_afb.afb11
 
        AFTER FIELD afb12
           CALL i802_afb10()          #重新計算季預算
           CALL i802_period('2')
           LET g_afb_o.afb12 = g_afb.afb12
 
        AFTER FIELD afb13
              CALL i802_afb10()          #重新計算季預算
              CALL i802_period('3')
           LET g_afb_o.afb13 = g_afb.afb13
 
        AFTER FIELD afb14
           CALL i802_afb10()          #重新計算季預算
           CALL i802_period('4')
           LET g_afb_o.afb14 = g_afb.afb14
 
## No:2446 modify 1998/09/28 -----
        AFTER INPUT #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_afb.afbuser = s_get_data_owner("afb_file") #FUN-C10039
           LET g_afb.afbgrup = s_get_data_group("afb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
         {   IF g_afb.afb01 IS NULL THEN
               DISPLAY BY NAME g_afb.afb01
               LET l_input='Y'
            END IF
            IF g_afb.afb02 IS NULL THEN
               DISPLAY BY NAME g_afb.afb02
               LET l_input='Y'
            END IF
            IF g_afb.afb03 IS NULL THEN
               DISPLAY BY NAME g_afb.afb03
               LET l_input='Y'
            END IF
            IF g_afb.afb04 IS NULL THEN
               DISPLAY BY NAME g_afb.afb04
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD afb01
            END IF
          }
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(afb01) THEN
        #        LET g_afb.* = g_afb_t.*
        #        LET g_afc.* = g_afc_t.*
        #        DISPLAY BY NAME
        #          g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb04   ,
        #          g_afb.afb05   ,g_afb.afb06   ,g_afb.afb10   ,g_afc.afc06_1 ,
        #          g_afc.afc06_2 ,g_afc.afc06_3 ,g_afc.afc06_4 ,g_afc.afc06_5 ,
        #          g_afc.afc06_6 ,g_afc.afc06_7 ,g_afc.afc06_8 ,g_afc.afc06_9 ,
        #          g_afc.afc06_10,g_afc.afc06_11,g_afc.afc06_12,g_afc.afc06_13,
        #          g_afb.afb11   ,g_afb.afb12   ,g_afb.afb13   ,g_afb.afb14
        #        NEXT FIELD afb01
        #    END IF
        #MOD-650015 --end
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            #No.FUN-740020 ---Begin
            IF INFIELD(afb00) THEN                                                                                          
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.form ="q_aaa"                                                                                 
               LET g_qryparam.default1 = g_afb.afb00                                                                        
               CALL cl_create_qry() RETURNING g_afb.afb00                                                                   
               DISPLAY BY NAME g_afb.afb00                                                                                  
               CALL i802_afb00('d')                                                                                         
               END IF
            #No.FUN-740020 ---End
            IF INFIELD(afb01) THEN
#              CALL q_afa(0,0,g_afb.afb01,g_bookno) RETURNING g_afb.afb01
#              CALL FGL_DIALOG_SETBUFFER( g_afb.afb01 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_afa"
               LET g_qryparam.default1 = g_afb.afb01
               LET g_qryparam.arg1 = g_afb.afb00         #No.FUN-740020
               CALL cl_create_qry() RETURNING g_afb.afb01
#               CALL FGL_DIALOG_SETBUFFER( g_afb.afb01 )
               DISPLAY BY NAME g_afb.afb01
               CALL i802_afb01('d')
            END IF
            IF INFIELD(afb02) THEN
#              CALL q_aag(0,0,g_afb.afb02,' ','24',' ') RETURNING g_afb.afb02
#              CALL FGL_DIALOG_SETBUFFER( g_afb.afb02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.arg1 = g_afb.afb00    #No.TQC-740093
               LET g_qryparam.default1 = g_afb.afb02
               LET g_qryparam.where ="  aag03 IN ('2','4')"
               CALL cl_create_qry() RETURNING g_afb.afb02
#               CALL FGL_DIALOG_SETBUFFER( g_afb.afb02 )
               DISPLAY BY NAME g_afb.afb02
               CALL i802_afb02('d')
            END IF
 
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
 
FUNCTION i802_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb04",TRUE)   #No.FUN-740020
     END IF
 
     CASE
        WHEN INFIELD(afb05) OR (NOT g_before_input_done)
             CALL cl_set_comp_entry("afb06,afb10,afc06_1",TRUE)
             CALL cl_set_comp_entry("afc06_2,afc06_3,afc06_4,afc06_5",TRUE)
             CALL cl_set_comp_entry("afc06_6,afc06_7,afc06_8,afc06_9",TRUE)
             CALL cl_set_comp_entry("afc06_10,afc06_11,afc06_12,afc06_13",TRUE)
             CALL cl_set_comp_entry("afb11,afb12,afb13,afb14",TRUE)
     END CASE
 
END FUNCTION
 
FUNCTION i802_set_no_entry(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
    DEFINE   l_dir1    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)   
    DEFINE   l_dir2    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)   
    DEFINE   l_dir3    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)  
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb04",FALSE)    #No.FUN-740020
    END IF
 
    CASE
        WHEN INFIELD(afb05) OR (NOT g_before_input_done)
             CASE g_afb.afb05
                  WHEN '1'
                       CALL cl_set_comp_entry("afb06,afb10",FALSE)
                       IF g_aza.aza02 = '1' THEN   #會計期間為12
                          CALL cl_set_comp_entry("afc06_13",FALSE)
                       END IF
                  OTHERWISE
                       IF g_aza.aza02 = '2' THEN
                          LET g_afb.afb06 = '2'
                          CALL cl_set_comp_entry("afb06,afb10,afc06_1,afc06_2,afc06_3,afc06_4,afc06_5,afc06_6,afc06_7,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,afc06_13",FALSE)
                          DISPLAY BY NAME g_afb.afb06
                       ELSE
                          CASE WHEN g_afb.afb05='2'
                                    CALL cl_set_comp_entry("afb10,afc06_1,afc06_2,afc06_3,afc06_4,afc06_5,afc06_6,afc06_7,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,afc06_13",FALSE)
                               WHEN g_afb.afb05='3'
                                    CALL cl_set_comp_entry("afc06_1,afc06_2,afc06_3,afc06_4,afc06_5,afc06_6,afc06_7,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,afc06_13,afb11,afb12,afb13,afb14",FALSE)
                          END CASE
                       END IF
             END CASE
    END CASE
 
END FUNCTION
 
    #計算第一季預算
FUNCTION i802_afb11()
    LET g_afb.afb11 = g_afc.afc06_1 + g_afc.afc06_2
                    + g_afc.afc06_3
    DISPLAY BY NAME g_afb.afb11
END FUNCTION
 
FUNCTION i802_afb12()
    LET g_afb.afb12 = g_afc.afc06_4 + g_afc.afc06_5
                    + g_afc.afc06_6
    DISPLAY BY NAME g_afb.afb12
END FUNCTION
 
FUNCTION i802_afb13()
    LET g_afb.afb13 = g_afc.afc06_7 + g_afc.afc06_8
                    + g_afc.afc06_9
    DISPLAY BY NAME g_afb.afb13
END FUNCTION
 
FUNCTION i802_afb14()
    IF g_aza.aza02 = '1' THEN
       LET g_afb.afb14 = g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12
    ELSE
       LET g_afb.afb14 = g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12
                       + g_afc.afc06_13
    END IF
    LET g_afb.afb10 = g_afb.afb11 + g_afb.afb12 + g_afb.afb13 + g_afb.afb14
    DISPLAY BY NAME g_afb.afb10,g_afb.afb14
END FUNCTION
 
FUNCTION i802_afb10()
    LET g_afb.afb10 = g_afb.afb11 + g_afb.afb12
                    + g_afb.afb13 + g_afb.afb14
    DISPLAY BY NAME g_afb.afb10
END FUNCTION
 
FUNCTION i802_period(p_cmd)
    DEFINE  p_cmd    LIKE type_file.chr1,                    #No.FUN-680098 VARCHAR(1)
            l_fac1,l_fac2,l_fac3 LIKE type_file.num5,        #No.FUN-680098 SMALLINT   
            l_tot    LIKE type_file.num5                     #No.FUN-680098 SMALLINT   
    IF g_afb.afb06 = '1' THEN
       LET l_tot  = g_aaz.aaz61+g_aaz.aaz62+g_aaz.aaz63
       LET l_fac1 = g_aaz.aaz61
       LET l_fac2 = g_aaz.aaz62
       LET l_fac3 = g_aaz.aaz63
    ELSE
       IF g_aza.aza02 = '1' THEN
          LET l_tot = 3
          LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
       ELSE
          LET l_tot = 4
          LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
       END IF
    END IF
    CASE p_cmd
         WHEN 'a'
               LET g_afc.afc06_1 = g_afb.afb11 * l_fac1 / l_tot
               LET g_afc.afc06_2 = g_afb.afb11 * l_fac2 / l_tot
               LET g_afc.afc06_3 = g_afb.afb11 -
                                  (g_afc.afc06_1 + g_afc.afc06_2)
               LET g_afc.afc06_4 = g_afb.afb12 * l_fac1 / l_tot
               LET g_afc.afc06_5 = g_afb.afb12 * l_fac2 / l_tot
               LET g_afc.afc06_6 = g_afb.afb12 -
                                  (g_afc.afc06_4 + g_afc.afc06_5)
               LET g_afc.afc06_7 = g_afb.afb13 * l_fac1 / l_tot
               LET g_afc.afc06_8 = g_afb.afb13 * l_fac2 / l_tot
               LET g_afc.afc06_9 = g_afb.afb13 -
                                  (g_afc.afc06_7 + g_afc.afc06_8)
               IF g_aza.aza02 = '1' THEN
                  LET g_afc.afc06_10 = g_afb.afb14 * l_fac1 / l_tot
                  LET g_afc.afc06_11 = g_afb.afb14 * l_fac2 / l_tot
                  LET g_afc.afc06_12 = g_afb.afb14 -
                                     (g_afc.afc06_10 + g_afc.afc06_11)
               ELSE
                  LET g_afc.afc06_10 = g_afb.afb14 * l_fac1 / l_tot
                  LET g_afc.afc06_11 = g_afb.afb14 * l_fac2 / l_tot
                  LET g_afc.afc06_12 = g_afb.afb14 * l_fac3 / l_tot
                  LET g_afc.afc06_12 = g_afb.afb14 -
                             (g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12)
              END IF
         WHEN '1'
               LET g_afc.afc06_1 = g_afb.afb11 * l_fac1 / l_tot
               LET g_afc.afc06_2 = g_afb.afb11 * l_fac2 / l_tot
               LET g_afc.afc06_3 = g_afb.afb11 -
                                  (g_afc.afc06_1 + g_afc.afc06_2)
         WHEN '2'
               LET g_afc.afc06_4 = g_afb.afb12 * l_fac1 / l_tot
               LET g_afc.afc06_5 = g_afb.afb12 * l_fac2 / l_tot
               LET g_afc.afc06_6 = g_afb.afb12 -
                                  (g_afc.afc06_4 + g_afc.afc06_5)
         WHEN '3'
               LET g_afc.afc06_7 = g_afb.afb13 * l_fac1 / l_tot
               LET g_afc.afc06_8 = g_afb.afb13 * l_fac2 / l_tot
               LET g_afc.afc06_9 = g_afb.afb13 -
                                  (g_afc.afc06_7 + g_afc.afc06_8)
         WHEN '4'
               IF g_aza.aza02 = '1' THEN
                  LET g_afc.afc06_10 = g_afb.afb14 * l_fac1 / l_tot
                  LET g_afc.afc06_11 = g_afb.afb14 * l_fac2 / l_tot
                  LET g_afc.afc06_12 = g_afb.afb14 -
                                     (g_afc.afc06_10 + g_afc.afc06_11)
               ELSE
                  LET g_afc.afc06_10 = g_afb.afb14 * l_fac1 / l_tot
                  LET g_afc.afc06_11 = g_afb.afb14 * l_fac2 / l_tot
                  LET g_afc.afc06_12 = g_afb.afb14 * l_fac3 / l_tot
                  LET g_afc.afc06_13 = g_afb.afb14 -
                             (g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12)
              END IF
    END CASE
    #--010823增
#No.CHI-6A0004--begin--
    LET g_afc.afc06_1= cl_numfor(g_afc.afc06_1,15,t_azi04)
    LET g_afc.afc06_2= cl_numfor(g_afc.afc06_2,15,t_azi04)
    LET g_afc.afc06_3= cl_numfor(g_afc.afc06_3,15,t_azi04)
    LET g_afc.afc06_4= cl_numfor(g_afc.afc06_4,15,t_azi04)
    LET g_afc.afc06_5= cl_numfor(g_afc.afc06_5,15,t_azi04)
    LET g_afc.afc06_6= cl_numfor(g_afc.afc06_6,15,t_azi04)
    LET g_afc.afc06_7= cl_numfor(g_afc.afc06_7,15,t_azi04)
    LET g_afc.afc06_8= cl_numfor(g_afc.afc06_8,15,t_azi04)
    LET g_afc.afc06_9= cl_numfor(g_afc.afc06_9,15,t_azi04)
    LET g_afc.afc06_10=cl_numfor(g_afc.afc06_10,15,t_azi04)
    LET g_afc.afc06_11=cl_numfor(g_afc.afc06_11,15,t_azi04)
    LET g_afc.afc06_12=cl_numfor(g_afc.afc06_12,15,t_azi04)
    LET g_afc.afc06_13=cl_numfor(g_afc.afc06_13,15,t_azi04)
    LET g_afb.afb11=cl_numfor(g_afb.afb11,15,t_azi04)
    LET g_afb.afb12=cl_numfor(g_afb.afb12,15,t_azi04)
    LET g_afb.afb13=cl_numfor(g_afb.afb13,15,t_azi04)
    LET g_afb.afb14=cl_numfor(g_afb.afb14,15,t_azi04)
#No.CHI-6A0004--end--
    DISPLAY BY NAME g_afb.afb11,g_afb.afb12,g_afb.afb13,
                    g_afb.afb14,g_afc.*
END FUNCTION
 
FUNCTION i802_afb01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
           l_afa02 LIKE afa_file.afa02,
           l_afaacti LIKE afa_file.afaacti
 
    LET g_errno = ' '
    IF g_afb.afb01 IS NULL THEN
        LET l_afa02=NULL
    ELSE
## No:2577 modify 1998/10/21 ----------------
        SELECT afa02,afaacti
           INTO l_afa02,l_afaacti
#          FROM afa_file WHERE afa00 = g_bookno AND afa01 = g_afb.afb01
           FROM afa_file WHERE afa01 = g_afb.afb01 AND afa00 = g_afb.afb00   #No.FUN-740020
## -
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-005'
            LET l_afa02 = NULL
        END IF
        IF l_afaacti='N' THEN
           LET g_errno = '9028'
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_afa02 TO  afa02
    END IF
END FUNCTION
 
FUNCTION i802_afb02(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aag02 LIKE aag_file.aag02,
           l_aag07 LIKE aag_file.aag07,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF g_afb.afb02 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aag07,aagacti
           INTO l_aag02,l_aag07,l_aagacti
           FROM aag_file WHERE aag01 = g_afb.afb02
                           AND aag00 = g_afb.afb00  #No.FUN-740020
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
        END IF
        IF l_aag07 = '1' THEN #為統制科目者不可做預算
           LET g_errno = 'agl-131 '
        END IF
        IF l_aagacti='N' THEN
           LET g_errno = '9028'
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  aag02
    END IF
END FUNCTION
 
#No.FUN-740020 ---Begin
FUNCTION i802_afb00(p_cmd)                                                                                                          
  DEFINE p_cmd     LIKE type_file.chr1,                                                                                             
         p_afb00   LIKE afb_file.afb00,                                                                                             
         l_aaaacti LIKE aaa_file.aaaacti                                                                                            
                                                                                                                                    
    LET g_errno = ' '                                                                                                               
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=g_afb.afb00                                                             
    CASE                                                                                                                            
        WHEN l_aaaacti = 'N' LET g_errno = '9028'                                                                                   
        WHEN STATUS=100      LET g_errno = 'anm-062'                                                                        
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'                                                                        
        END CASE                                                                                                                    
END FUNCTION
#No.FUN-740020 ---End
 
FUNCTION i802_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_afb.* TO NULL              #No.FUN-6B0040
    INITIALIZE g_afc.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i802_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i802_count
    FETCH i802_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i802_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL
        INITIALIZE g_afc.* TO NULL
    ELSE
        CALL i802_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i802_fetch(p_flafb)
    DEFINE
        p_flafb          LIKE type_file.chr1,             #No.FUN-680098    VARCHAR(1) 
#       l_sql            VARCHAR(200),
        l_sql            STRING,        #TQC-630166     
        l_abso           LIKE type_file.num10         #No.FUN-680098 INTEGER
 
    CASE p_flafb
        WHEN 'N' FETCH NEXT     i802_cs INTO g_afb.afb00,g_afb.afb01,    #No.FUN-740020
                                          g_afb.afb02,g_afb.afb03,g_afb.afb04
        WHEN 'P' FETCH PREVIOUS i802_cs INTO g_afb.afb00,g_afb.afb01,    #No.FUN-740020
                                          g_afb.afb02,g_afb.afb03,g_afb.afb04
        WHEN 'F' FETCH FIRST    i802_cs INTO g_afb.afb00,g_afb.afb01,    #No.FUN-740020
                                          g_afb.afb02,g_afb.afb03,g_afb.afb04
        WHEN 'L' FETCH LAST     i802_cs INTO g_afb.afb00,g_afb.afb01,    #No.FUN-740020
                                          g_afb.afb02,g_afb.afb03,g_afb.afb04
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
            FETCH ABSOLUTE g_jump i802_cs INTO g_afb.afb00,g_afb.afb01,   #No.FUN-740020
                                               g_afb.afb02,g_afb.afb03,g_afb.afb04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flafb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_afb.* FROM afb_file            # 重讀DB,因TEMP有不被更新特性
       WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 AND afb04 = g_afb.afb04
         AND afbacti = 'Y'                         #FUN-D70090 add
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","afb_file",g_afb.afb01,g_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
       #No.FUN-740020 ---Begin
       SELECT * INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_afb.afb00                                                                
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03
       #No.FUN-740020 ---End
       #讀取期預算
       LET l_sql = "SELECT afc06,afc07 FROM afc_file",
             #     " WHERE afc00 = '",g_bookno,"'",     #No.FUN-740020
                   " WHERE afc00 = '",g_afb.afb00,"'",  #No.FUN-740020
                   " AND afc01 ='",g_afb.afb01,"'",
                   " AND afc02 ='",g_afb.afb02,"'",
                   " AND afc03 =",g_afb.afb03,
                   " AND afc04 ='",g_afb.afb04,"'",
                   " AND afc05 = ?"
       PREPARE i802_p2 FROM l_sql
       DECLARE i802_c2 CURSOR FOR i802_p2
       CALL l_afc06.clear()  #TQC-830057
       CALL l_afc07.clear()  #TQC-830057
       FOR g_cnt = 1 TO 13
           OPEN i802_c2 USING g_cnt
           FETCH i802_c2 INTO l_afc06[g_cnt],l_afc07[g_cnt]
              IF SQLCA.sqlcode != 100 AND SQLCA.sqlcode != 0 THEN
                 CALL cl_err('fetch:',SQLCA.sqlcode,0)   
              END IF
       END FOR
       LET g_afc.afc06_1 = l_afc06[1]    LET g_afc.afc06_2 = l_afc06[2]
       LET g_afc.afc06_3 = l_afc06[3]    LET g_afc.afc06_4 = l_afc06[4]
       LET g_afc.afc06_5 = l_afc06[5]    LET g_afc.afc06_6 = l_afc06[6]
       LET g_afc.afc06_7 = l_afc06[7]    LET g_afc.afc06_8 = l_afc06[8]
       LET g_afc.afc06_9 = l_afc06[9]    LET g_afc.afc06_10 = l_afc06[10]
       LET g_afc.afc06_11 = l_afc06[11]  LET g_afc.afc06_12 = l_afc06[12]
       LET g_afc.afc06_13 = l_afc06[13]
       LET g_afc1.afc07_1 = l_afc07[1]    LET g_afc1.afc07_2 = l_afc07[2]
       LET g_afc1.afc07_3 = l_afc07[3]    LET g_afc1.afc07_4 = l_afc07[4]
       LET g_afc1.afc07_5 = l_afc07[5]    LET g_afc1.afc07_6 = l_afc07[6]
       LET g_afc1.afc07_7 = l_afc07[7]    LET g_afc1.afc07_8 = l_afc07[8]
       LET g_afc1.afc07_9 = l_afc07[9]    LET g_afc1.afc07_10 = l_afc07[10]
       LET g_afc1.afc07_11 = l_afc07[11]  LET g_afc1.afc07_12 = l_afc07[12]
       LET g_afc1.afc07_13 = l_afc07[13]
       LET g_data_owner = g_afb.afbuser     #No.FUN-4C0048
       LET g_data_group = g_afb.afbgrup     #No.FUN-4C0048
       CALL i802_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i802_show()
    LET g_afb_t.* = g_afb.*
    LET g_afb_o.* = g_afb.*
    LET g_afc_t.* = g_afc.*
    LET g_afc_o.* = g_afc.*
    DISPLAY BY NAME g_afb.afboriu,g_afb.afborig,
        g_afb.afb00   ,   #No.FUN-740020 
        g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb04   ,
#       g_afb.afb07   ,g_afb.afb08   ,g_afb.afb09   ,
        g_afb.afb07   ,g_afb.afb09   ,
        g_afb.afb05   ,g_afb.afb06   ,g_afb.afb10   ,g_afc.afc06_1 ,
        g_afc.afc06_2 ,g_afc.afc06_3 ,g_afc.afc06_4 ,g_afc.afc06_5 ,
        g_afc.afc06_6 ,g_afc.afc06_7 ,g_afc.afc06_8 ,g_afc.afc06_9 ,
        g_afc.afc06_10,g_afc.afc06_11,g_afc.afc06_12,g_afc.afc06_13,
        g_afc1.afc07_2 ,g_afc1.afc07_3 ,g_afc1.afc07_4 ,g_afc1.afc07_5 ,
        g_afc1.afc07_1,g_afc1.afc07_6 ,g_afc1.afc07_7 ,g_afc1.afc07_8 ,
        g_afc1.afc07_9 ,g_afc1.afc07_10,g_afc1.afc07_11,g_afc1.afc07_12,
        g_afc1.afc07_13,
        g_afb.afb11   ,g_afb.afb12   ,g_afb.afb13   ,g_afb.afb14,
        g_afb.afbuser ,g_afb.afbgrup ,g_afb.afbmodu ,g_afb.afbdate,
        g_afb.afbacti
    CALL i802_afb00('d')   #No.FUN-740020
    CALL i802_afb01('d')
    CALL i802_afb02('d')
    #CKP
    CALL cl_set_field_pic("","","","","",g_afb.afbacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i802_u()
    IF s_aglshut(0) THEN RETURN END IF
#   IF g_afb.afb01 IS NULL THEN        #No.FUN-740020
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN   #No.FUN-740020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_afb.* FROM afb_file WHERE afb00=g_afb.afb00
       AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
       AND afb03=g_afb.afb03 AND afb04=g_afb.afb04
       AND afbacti = 'Y'                         #FUN-D70090 add
    IF g_afb.afbacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_afb.afb01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_afb01_t = g_afb.afb01
    #No.FUN-740020 ---Begin
    LET g_afb00_t = g_afb.afb00                                                                                                     
    LET g_afb02_t = g_afb.afb02                                                                                                     
    LET g_afb03_t = g_afb.afb03                                                                                                     
    LET g_afb04_t = g_afb.afb04
    #No.FUN-740020 ---End
    LET g_afb_o.*=g_afb.*
    LET g_afc_o.*=g_afc.*
	BEGIN WORK
 
    OPEN i802_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04
    IF STATUS THEN
       CALL cl_err("OPEN i802_cl:", STATUS, 1)
       CLOSE i802_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i802_cl INTO g_afb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_afb.afbmodu=g_user                     #修改者
    LET g_afb.afbdate = g_today                  #修改日期
    CALL i802_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i802_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_afb.*=g_afb_t.*
            LET g_afc.*=g_afc_t.*
            CALL i802_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE afb_file SET afb_file.* = g_afb.*    # 更新DB
            WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 AND afb04 = g_afb.afb04             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","afb_file",g_afb_t.afb01,g_afb_t.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        CALL i802_addafc('u')    #更新期預算
        EXIT WHILE
    END WHILE
    CLOSE i802_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i802_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF s_aglshut(0) THEN RETURN END IF
#   IF g_afb.afb01 IS NULL THEN
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN   #No.FUN-740020
        CALL cl_err('',-400,0)
        RETURN
    END IF
	BEGIN WORK
 
    OPEN i802_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04
    IF STATUS THEN
       CALL cl_err("OPEN i802_cl:", STATUS, 1)
       CLOSE i802_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i802_cl INTO g_afb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i802_show()
    IF cl_exp(16,21,g_afb.afbacti) THEN
        LET g_chr=g_afb.afbacti
        IF g_afb.afbacti='Y' THEN
            LET g_afb.afbacti='N'
        ELSE
            LET g_afb.afbacti='Y'
        END IF
        UPDATE afb_file
            SET afbacti=g_afb.afbacti,
               afbmodu=g_user, afbdate=g_today
            WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 AND afb04 = g_afb.afb04
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","afb_file",g_afb_t.afb01,g_afb_t.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            LET g_afb.afbacti=g_chr
        END IF
        DISPLAY BY NAME g_afb.afbacti
    END IF
    CLOSE i802_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic("","","","","",g_afb.afbacti)
 
END FUNCTION
 
FUNCTION i802_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF s_aglshut(0) THEN RETURN END IF
#   IF g_afb.afb01 IS NULL THEN       #No.FUN-740020
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN     #No.FUN-740020 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i802_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04
    IF STATUS THEN
       CALL cl_err("OPEN i802_cl:", STATUS, 1)
       CLOSE i802_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i802_cl INTO g_afb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i802_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "afb00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_afb.afb00      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "afb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_afb.afb01      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "afb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_afb.afb02      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "afb03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_afb.afb03      #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "afb04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_afb.afb04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM afb_file
        WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
          AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
          AND afb04 = g_afb.afb04
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
          CALL cl_err3("del","afb_file",g_afb.afb00,g_afb.afb01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       END IF
       DELETE FROM afc_file
  #     WHERE afc00 = g_bookno AND afc01 = g_afb.afb01        #No.FUN-740020
        WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01     #No.FUn-740020 
          AND afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
          AND afc04 = g_afb.afb04
       CLEAR FORM
       OPEN i802_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i802_cs
          CLOSE i802_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i802_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i802_cs
          CLOSE i802_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i802_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i802_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i802_fetch('/')
       END IF
    END IF
    CLOSE i802_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i802_copy()
#No.FUN-740020 ---Begin
   DEFINE l_afb           RECORD LIKE afb_file.*,
    #     l_newno LIKE afb_file.afb01,
    #     l_oldno1 LIKE afb_file.afb01,
    #     l_oldno2 LIKE afb_file.afb02,
    #     l_oldno3 LIKE afb_file.afb03,
    #     l_oldno4 LIKE afb_file.afb04,
          t_afb           RECORD LIKE afb_file.*,
          o_afb           RECORD LIKE afb_file.*
#No.FUN-740020 ---End  
 
    IF s_aglshut(0) THEN RETURN END IF
#   IF g_afb.afb01 IS NULL THEN      #No.FUN-740020
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN   #No.FUN-740020
        CALL cl_err('',-400,0)
        RETURN
    END IF
            LET g_before_input_done=FALSE
            CALL i802_set_entry('a')
            LET g_before_input_done = TRUE
 
    INPUT t_afb.afb00,t_afb.afb01,t_afb.afb02,t_afb.afb03,t_afb.afb04   #No.FUN-740020
     FROM afb00,afb01,afb02,afb03,afb04    #No.FUN-740020
 
        #No.FUN-740020 ---Begin
        AFTER FIELD afb00                                                                                                           
            IF t_afb.afb00 IS NOT NULL THEN                                                                                         
               LET g_afb.afb00 = t_afb.afb00                                                                                        
               CALL i802_afb00('a')                                                                                                 
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(t_afb.afb00,g_errno,0)                                                                                
                  NEXT FIELD afb00                                                                                                  
               END IF                                                                                                               
            END IF  
        #No.FUN-740020 ---End
        AFTER FIELD afb01
            IF cl_null(t_afb.afb00) THEN NEXT FIELD afb00 END IF     #No.FUN-740020
            IF t_afb.afb01 IS NOT NULL THEN
               LET g_afb.afb01 = t_afb.afb01
               CALL i802_afb01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(t_afb.afb01,g_errno,0)
                  NEXT FIELD afb01
               END IF
            END IF
        AFTER FIELD afb02
            IF t_afb.afb02 IS NOT NULL THEN
               LET g_afb.afb02 = t_afb.afb02
               CALL i802_afb02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(t_afb.afb02,g_errno,0)
                  #Add No.FUN-B10048
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = t_afb.afb02
                  LET g_qryparam.arg1 = t_afb.afb00    #No.TQC-740093
                  LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 IN ('2','4')AND aag01 LIKE '",g_afb.afb02 CLIPPED,"%'"
                  LET g_qryparam.default1 = t_afb.afb00    #No.FUN-740020
                  CALL cl_create_qry() RETURNING t_afb.afb02
                  DISPLAY BY NAME t_afb.afb02
                  #End Add No.FUN-B10048
                  NEXT FIELD afb02
               END IF
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            #No.FUN-740020 ---Begin
            IF INFIELD(afb00) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_aaa"                                                                                         
               LET g_qryparam.default1 = t_afb.afb00                                                                                
               CALL cl_create_qry() RETURNING t_afb.afb00                                                                           
               DISPLAY BY NAME t_afb.afb00                                                                                          
            END IF
            #No.FUN-740020 ---End
            IF INFIELD(afb01) THEN
#              CALL q_afa(0,0,t_afb.afb01,g_bookno) RETURNING t_afb.afb01
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_afa"
               LET g_qryparam.default1 = t_afb.afb01
               LET g_qryparam.default1 = t_afb.afb00    #No.FUN-740020
               CALL cl_create_qry() RETURNING t_afb.afb01
               DISPLAY BY NAME t_afb.afb01
            END IF
            IF INFIELD(afb02) THEN
#              CALL q_aag(0,0,t_afb.afb02,' ','24',' ') RETURNING t_afb.afb02
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = t_afb.afb02
               LET g_qryparam.arg1 = t_afb.afb00    #No.TQC-740093
               LET g_qryparam.where ="  aag03 IN ('2','4')"
               LET g_qryparam.default1 = t_afb.afb00    #No.FUN-740020
               CALL cl_create_qry() RETURNING t_afb.afb02
               DISPLAY BY NAME t_afb.afb02
            END IF
 
         ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        AFTER INPUT
            SELECT count(*) INTO g_cnt FROM afb_file
                WHERE afb02 = t_afb.afb02
                  AND afb03 = t_afb.afb03
                  AND afb04 = t_afb.afb04
                  AND afb01 = t_afb.afb01
     #            AND afb00 = g_bookno       #No.FUN-740020
                  AND afb00 = t_afb.afb00    #No.FUN-740020
                  AND afbacti = 'Y'                         #FUN-D70090 add
            IF g_cnt > 0 THEN
                DISPLAY "g_cnt>0"
         #      CALL cl_err(l_newno,-239,0)      #No.FUN-740020
                CALL cl_err(t_afb.afb01,-239,0)  #No.FUN-740020
                NEXT FIELD afb01
            END IF
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_afb.* = o_afb.*   #No.FUN-740020
        DISPLAY BY NAME g_afb.afb01,g_afb.afb02,g_afb.afb00,g_afb.afb03,g_afb.afb04  #No.FUN-740020
        RETURN
    END IF
    LET g_afb.* = o_afb.*           #No.FUN-740020
    LET l_afb.* = g_afb.*
#   LET l_afb.afb00  =g_bookno      #No.FUN-740020
    LET l_afb.afb00  =t_afb.afb00   #No.FUN-740020 
    LET l_afb.afb01  =t_afb.afb01   #資料鍵值
    LET l_afb.afb02  =t_afb.afb02   #資料鍵值
    LET l_afb.afb03  =t_afb.afb03   #資料鍵值
    LET l_afb.afb04  =t_afb.afb04   #資料鍵值
    LET l_afb.afb15  ='3'
    LET l_afb.afbuser=g_user    #資料所有者
    LET l_afb.afbgrup=g_grup    #資料所有者所屬群
    LET l_afb.afbmodu=NULL      #資料修改日期
    LET l_afb.afbdate=g_today   #資料建立日期
    LET l_afb.afbacti='Y'       #有效資料
    #No.TQC-9C0134  --Begin                                                     
    IF cl_null(l_afb.afb041) THEN LET l_afb.afb041 = ' ' END IF                 
    IF cl_null(l_afb.afb042) THEN LET l_afb.afb042 = ' ' END IF                 
    #No.TQC-9C0134  --End  
    LET g_success = 'Y'
    BEGIN WORK
    LET l_afb.afboriu = g_user      #No.FUN-980030 10/01/04
    LET l_afb.afborig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO afb_file VALUES (l_afb.*)
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","afb_file",l_afb.afb01,l_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       ROLLBACK WORK
    ELSE
        COMMIT WORK
        #No.FUN-740020 ---Begin
#       MESSAGE 'ROW(',l_newno,') O.K'
        MESSAGE 'ROW(',t_afb.afb01,') O.K'
#       LET l_oldno1= g_afb.afb01
#       LET l_oldno2= g_afb.afb02
#       LET l_oldno3= g_afb.afb03
#       LET l_oldno4= g_afb.afb04
        SELECT afb_file.* INTO g_afb.* FROM afb_file
                WHERE afb02 = l_afb.afb02
                  AND afb03 = l_afb.afb03
                  AND afb04 = l_afb.afb04
                  AND afb01 = l_afb.afb01
#                 AND afb00 = g_bookno
                  AND afb00 = t_afb.afb00   #No.FUN-740020
                  AND afbacti = 'Y'                         #FUN-D70090 add
        #No.FUN-740020 ---End
        IF sqlca.sqlcode THEN
            DISPLAY "ERROR"
        END IF
        CALL i802_u()
    END IF
#No.FUN-740020 ---Begin
#       LET g_afb.afb01=l_oldno1
#       LET g_afb.afb02=l_oldno2
#       LET g_afb.afb03=l_oldno3
#       LET g_afb.afb04=l_oldno4
        #FUN-C30027---begin
        #LET g_afb.* = o_afb.*     #No.FUN-740020
        #SELECT afb_file.* INTO g_afb.* FROM afb_file
        #        WHERE afb02 = g_afb.afb02
        #          AND afb03 = g_afb.afb03
        #          AND afb04 = g_afb.afb04
        #          AND afb01 = g_afb.afb01
        # #        AND afb00 = g_bookno
        #          AND afb00 = g_afb.afb00    #No.FUN-740020
        #FUN-C30027---end
#No.FUN-740020 ---End
    CALL i802_show()
END FUNCTION
#No.FUN-830113----begin------ 
FUNCTION i802_out()
    DEFINE
        l_i             LIKE type_file.num5,                  #No.FUN-680098 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
        l_afb   RECORD LIKE afb_file.*,
        l_za05          LIKE za_file.za05,                    #No.FUN-680098 VARCHAR(40)
        l_chr           LIKE type_file.chr1,                   #No.FUN-680098  VARCHAR(1)
        l_err           LIKE type_file.chr1,                                                                                        
        l_afc06         ARRAY[13] OF LIKE afc_file.afc06,                                                                           
        l_afa02         LIKE afa_file.afa02,                                                                                        
        l_aag02         LIKE aag_file.aag02,                                                                                        
        l_wc            STRING
 
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
#    CALL cl_wait()
#    CALL cl_outnam('agli802') RETURNING l_name
	#金額小數位數
    #No.FUN-740020 ---Begin
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
#   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03      #CHI-6A0004
#   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
#		AND aaf02 = g_lang
    #No.FUN-740020 ---End
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli802'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 88 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM afb_file ",          # 組合出 SQL 指令
              " WHERE afb15 = '3' AND ",  # g_wc CLIPPED   TQC-760105
              "  afb00 = '",g_afb.afb00,"'",
              " AND afb01 = '",g_afb.afb01,"'",
              " AND afb02 = '",g_afb.afb02,"'",
              " AND afb03 = '",g_afb.afb03,"'",
              " AND afb04 = '",g_afb.afb04,"'"
             ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
    PREPARE i802_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i802_co CURSOR FOR i802_p1
 
#    START REPORT i802_rep TO l_name
    CALL cl_del_data(l_table)
    FOREACH i802_co INTO l_afb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        SELECT afa02 INTO l_afa02 FROM afa_file                                 
           WHERE afa01 = l_afb.afb01 AND afa00 = l_afb.afb00                    
        IF SQLCA.sqlcode THEN                                                   
           CALL cl_err3("sel","afa_file",l_afb.afb00,l_afb.afb01,SQLCA.sqlcode,"","1:",1)
           LET l_err = 'Y'                                                      
        END IF
     
        SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = l_afb.afb01 AND aag00=l_afb.afb00
        IF SQLCA.sqlcode THEN                                                   
           IF SQLCA.sqlcode != 100 THEN                                         
              CALL cl_err3("sel","aag_file",l_afb.afb02,"",SQLCA.sqlcode,"","2:",1)
           ELSE                                                                 
              LET l_aag02 = ' '                                                 
           END IF                                                               
        END IF
        SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file                   
           WHERE azi01 = g_aaa03                                                
                                                                                
        LET g_sql = "SELECT afc06 FROM afc_file",                               
                    " WHERE afc00 = '",l_afb.afb00,"'",                         
                    " AND afc01 ='",l_afb.afb01,"'",                            
                    " AND afc02 ='",l_afb.afb02,"'",                            
                    " AND afc03 ='",l_afb.afb03,"'",                            
                    " AND afc04 ='",l_afb.afb04,"'",                            
                    " AND afc05 = ?"                                            
        PREPARE i802_p4 FROM g_sql                                              
        IF SQLCA.sqlcode THEN                                                   
           CALL cl_err('p4:',SQLCA.sqlcode,1)                                   
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114        
           EXIT PROGRAM                                                         
        END IF                                                                  
        DECLARE i802_c4 CURSOR FOR i802_p4                                      
                                                                                
        IF g_aza.aza02 = '1' THEN                                               
           LET g_i = 12                                                         
        ELSE                                                                    
           LET g_i = 13                                                         
        END IF
        LET g_cnt1 = ''                                                         
        FOR g_cnt = 1 TO g_i                                                    
            OPEN i802_c4 USING g_cnt                                            
            FETCH i802_c4 INTO l_afc06[g_cnt]                                   
            IF SQLCA.sqlcode THEN                                               
               CALL cl_err('3:',SQLCA.sqlcode,0)                                
               EXIT FOR                                                         
            END IF                                                              
        END FOR                                                                 
                                                                                
        IF g_cnt1 = '0' THEN                                                    
          RETURN                                                                
        END IF
        EXECUTE insert_prep USING l_afb.afb00,l_afb.afb01,l_afa02,t_azi04,t_azi05,
                                  l_afb.afbacti,l_aag02,l_afb.afb02,l_afb.afb03,
                                  l_afb.afb05,l_afc06[1],l_afc06[2],l_afc06[3], 
                                  l_afc06[4],l_afc06[5],l_afc06[6],l_afc06[7],  
                                  l_afc06[8],l_afc06[9],l_afc06[10],l_afc06[11],
                                  l_afc06[12],l_afc06[13],l_afb.afb11,l_afb.afb12,
                                  l_afb.afb13,l_afb.afb14,l_afb.afb10
#        OUTPUT TO REPORT i802_rep(l_afb.*)
#No.TQC-760105----------------BEGIN 由于在rep函數里當有一筆資料取不到值的時候，直接返回到這里，在FINISH REPORT 之前跳出，從而不會出現無資料還會打印的錯誤
        IF g_cnt1 = '0' THEN
          EXIT FOREACH
        END IF
    END FOREACH
        IF g_cnt1 ='0' THEN
          ERROR  ""
          RETURN
        END IF           
#No.TQC-760105--------------END
#    FINISH REPORT i802_rep
 
    CLOSE i802_co
                                                                                                                            
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   IF g_zz05='Y' THEN                                                                                                               
      CALL cl_wcchp(l_wc,'afb00,afb01,afb02,afb03,afb04,afb07,afb09')                                                               
         RETURNING l_wc                                                                                                             
   ELSE                                                                                                                             
      LET l_wc=""                                                                                                                   
   END IF                                                                                                                           
   LET g_str=l_wc,";",l_err                                                                                                         
   CALL cl_prt_cs3('agli802','agli802',g_sql,g_str)
   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i802_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1) 
#       l_sw            LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1)
#       sr RECORD LIKE afb_file.*,
#       l_afa02   LIKE afa_file.afa02,
#       l_aag02   LIKE aag_file.aag02,
#       l_afc06   ARRAY[13] OF LIKE afc_file.afc06,
#       l_sql           VARCHAR(200), 
#       l_sql           STRING,        #TQC-630166  
#       l_chr           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#    ORDER BY sr.afb00,sr.afb01,sr.afb02     #No.FUN-740020
 
#   FORMAT
#       PAGE HEADER
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#               COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
## No:2577 modify 1998/10/21 ----------------
#           SELECT afa02 INTO l_afa02 FROM afa_file
#                  WHERE afa00 = g_bookno AND afa01 = sr.afb01
#                  WHERE afa01 = sr.afb01 AND afa00 = sr.afb00  #No.FUN-740020
## -
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('1:',SQLCA.sqlcode,1)#NO.FUN-660123
#              CALL cl_err3("sel","afa_file",g_bookno,sr.afb01,SQLCA.sqlcode,"","1:",1)#NO.FUN-660123  
#              CALL cl_err3("sel","afa_file",sr.afb00,sr.afb01,SQLCA.sqlcode,"","1:",1)#NO.TQC-760105  
#           PRINT g_x[21] CLIPPED,' ',sr.afb00,'    ';    #No.FUN-740020
#           END IF
#           PRINT g_x[18] CLIPPED,' ',sr.afb01,'    ',
#                 g_x[19] CLIPPED,' ',l_afa02 CLIPPED
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
#           LET l_sw = 'y'
#       
#       #No.FUN-740020 ---Begin
#       BEFORE GROUP OF sr.afb00                                                                                                    
#           SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = sr.afb00                                                          
#           SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file                                                                   
#            WHERE azi01 = g_aaa03        #CHI-6A0004                                                                               
#           IF PAGENO > 1 OR LINENO > 9 THEN                                                                                        
#              SKIP TO TOP OF PAGE                                                                                                  
#           END IF                                                                                                                  
#           LET l_sw = 'y' 
#       #No.FUN-740020 ---End
 
#       BEFORE GROUP OF sr.afb01
#           IF PAGENO > 1 OR LINENO > 9 THEN
#              SKIP TO TOP OF PAGE
#           END IF
#           LET l_sw = 'y'
 
#       ON EVERY ROW
#           IF l_sw != 'y'
#              THEN PRINT '--------------------------------------------',
#                         '--------------------------------------------'
#           END IF
#           LET l_sw = 'n'
#FUN-590124
#           IF sr.afbacti = 'N' THEN
#              PRINT '*',g_x[11],g_x[12] CLIPPED
#           ELSE
#              PRINT ' ',g_x[11],g_x[12] CLIPPED
#           END IF
#           PRINT g_x[11],g_x[12] CLIPPED
#           PRINT '  ------------------------  ------------',
#                 '-------------------------------------- ----  --  '
#                 '------------------ ----  --  '
#           SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.afb01 
#           SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.afb01 AND aag00=sr.afb00   #TQC-760105
#           IF SQLCA.sqlcode THEN
#              IF SQLCA.sqlcode != 100 THEN
#                 CALL cl_err('2:',SQLCA.sqlcode,1)   #No.FUN-660123
#                 CALL cl_err3("sel","aag_file",sr.afb02,"",SQLCA.sqlcode,"","2:",1)  #No.FUN-660123
#              ELSE
#	          LET l_aag02 = ' '
#              END IF
#           END IF
#           PRINT COLUMN 3,sr.afb02,COLUMN 29,l_aag02,
#                 COLUMN 80,sr.afb03 USING'####';
#                 COLUMN 60,sr.afb03 USING'####';
#           CASE sr.afb05
#                WHEN '1' PRINT COLUMN 86,g_x[13] CLIPPED
#                WHEN '2' PRINT COLUMN 86,g_x[14] CLIPPED
#                WHEN '3' PRINT COLUMN 86,g_x[15] CLIPPED
#                WHEN '1' PRINT COLUMN 66,g_x[13] CLIPPED
#                WHEN '2' PRINT COLUMN 66,g_x[14] CLIPPED
#                WHEN '3' PRINT COLUMN 66,g_x[15] CLIPPED
#                OTHERWISE PRINT '    '
#           END CASE
#FUN-590124 End
#       SKIP 1  LINE
#
#       #讀取期預算
#       LET l_sql = "SELECT afc06 FROM afc_file",
#              #    " WHERE afc00 = '",g_bookno,"'",     #No.FUN-740020
#                   " WHERE afc00 = '",sr.afb00,"'",     #No.FUN-740020
#                   " AND afc01 ='",sr.afb01,"'",
#                   " AND afc02 ='",sr.afb02,"'",
#                   " AND afc03 ='",sr.afb03,"'",
#                   " AND afc04 ='",sr.afb04,"'",
#                   " AND afc05 = ?"
#       PREPARE i802_p4 FROM l_sql
#       	IF SQLCA.sqlcode
#       THEN CALL cl_err('p4:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#            EXIT PROGRAM
#       END IF
#       DECLARE i802_c4 CURSOR FOR i802_p4
#       IF g_aza.aza02 = '1' THEN
#          LET g_i = 12
#       ELSE
#          LET g_i = 13
#       END IF
#       LET g_cnt1 = ''
#       FOR g_cnt = 1 TO g_i
#           OPEN i802_c4 USING g_cnt
#           FETCH i802_c4 INTO l_afc06[g_cnt]
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err('3:',SQLCA.sqlcode,1)           #TQC-7C0006  
#                 CALL cl_err('3:',SQLCA.sqlcode,0)           #TQC-7C0006
#No.TQC-760105----------------BEGIN 出現無資料還會打印的錯誤,直接讓出現錯誤的時候跳出rep函數，返回到FOREACH那。
#                 LET g_cnt1 = '0'
#                 EXIT FOR  
#                  
#              END IF
#       END FOR
#       IF g_cnt1 = '0' THEN
#         RETURN
#       END IF 
#No.TQC-760105---------------END 
#       PRINT g_x[16],'     ',g_x[16]CLIPPED
#       PRINT ' -- ------------------ -- ------------------',
#             ' -- ------------------ -- ------------------'
#No.CHI-6A0004--begin--
#       PRINT '  1',COLUMN 4,cl_numfor(l_afc06[1],18,t_azi04) CLIPPED,
#             '  4',COLUMN 26,cl_numfor(l_afc06[4],18,t_azi04) CLIPPED,
#             '  7',COLUMN 48,cl_numfor(l_afc06[7],18,t_azi04) CLIPPED,
#             ' 10',COLUMN 70,cl_numfor(l_afc06[10],18,t_azi04) CLIPPED
#       PRINT '  2',COLUMN 4,cl_numfor(l_afc06[2],18,t_azi04) CLIPPED,
#             '  5',COLUMN 26,cl_numfor(l_afc06[5],18,t_azi04) CLIPPED,
#             '  8',COLUMN 48,cl_numfor(l_afc06[8],18,t_azi04) CLIPPED,
#             ' 11',COLUMN 70,cl_numfor(l_afc06[11],18,t_azi04) CLIPPED
#       PRINT '  3',COLUMN 4,cl_numfor(l_afc06[3],18,t_azi04) CLIPPED,
#             '  6',COLUMN 26,cl_numfor(l_afc06[6],18,t_azi04) CLIPPED,
#             '  9',COLUMN 48,cl_numfor(l_afc06[9],18,t_azi04) CLIPPED,
#             ' 12',COLUMN 70,cl_numfor(l_afc06[12],18,t_azi04) CLIPPED
#       IF  l_afc06[13] IS NOT NULL
#           THEN PRINT COLUMN 68,'13',cl_numfor(l_afc06[13],18,t_azi04) CLIPPED
#       END IF
#       SKIP 1  LINE
#       PRINT ' ',g_x[14] CLIPPED,
#             COLUMN 4,cl_numfor(sr.afb11,18,t_azi05) CLIPPED,
#             ' ',g_x[14] CLIPPED,
#             COLUMN 26,cl_numfor(sr.afb12,18,t_azi05) CLIPPED,
#             ' ',g_x[14] CLIPPED,
#             COLUMN 48,cl_numfor(sr.afb13,18,t_azi05) CLIPPED,
#             ' ',g_x[14] CLIPPED,
#             COLUMN 70,cl_numfor(sr.afb14,18,t_azi05) CLIPPED
#       SKIP 1  LINE
#       PRINT  COLUMN 49,g_x[17] CLIPPED,
#              COLUMN 70,cl_numfor(sr.afb10,18,t_azi05) CLIPPED
#       SKIP 1  LINE
#No.CHI-6A0004--end--
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   #TQC-630166
#                   #IF g_wc[001,080] > ' ' THEN
#       	    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(g_wc)
#           END IF
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-830113----end----
FUNCTION i802_m()
DEFINE  l_percent  LIKE type_file.num15_3,          #LIKE cpf_file.cpf112,            #No.FUN-680098    dec(6,2)   #TQC-B90211
        l_percent1 LIKE type_file.num5,             #No.FUN-680098    smallint
#       l_sql     VARCHAR(200)
        l_sql      STRING        #TQC-630166    
 
    IF s_aglshut(0) THEN RETURN END IF
#   IF g_afb.afb01 IS NULL THEN   #No.FUN-740020
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN   #No.FUN-740020      
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_afb.afbacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_afb.afb01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
 
 
    OPEN WINDOW i802_w2 AT 10,09
         WITH FORM "agl/42f/agli6021"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("agli6021")
 
 
    INPUT l_percent1 FROM percent1
 
    AFTER FIELD percent1
          IF l_percent1 IS NULL OR l_percent1 = ' ' THEN
             LET l_percent1 = 0
             DISPLAY l_percent1 TO FORMONLY.percent1
             NEXT FIELD percent1
          ELSE
              IF l_percent1 > 100 OR l_percent1 < -100
                 OR l_percent1 = 0  THEN   #不要超過百分之百
                 NEXT FIELD percent1
              END IF
          END IF
 
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
    CLOSE WINDOW i802_w2
 
    #--TQC-650029 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    #--TQC-650029--END 
 
    LET l_percent = l_percent1/100+1
    LET l_sql = " UPDATE afc_file SET afc06 = afc06 * ",l_percent," ",
           #    " WHERE afc00 = '",g_bookno,"'  AND afc01 = '",g_afb.afb01,"'",    #No.FUN-740020
                " WHERE afc00 = '",g_afb.afb00,"'  AND afc01 = '",g_afb.afb01,"'", #No.FUN-740020
                " AND afc02 = '",g_afb.afb02,"' AND afc03 = ",g_afb.afb03," ",
                " AND afc04 = '",g_afb.afb04,"' AND afc05 = ? "
    PREPARE i802_pre FROM l_sql
    IF SQLCA.sqlcode
    THEN CALL cl_err('p4:',SQLCA.sqlcode,1)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
    END IF
    IF g_aza.aza02 = '1' THEN
       LET g_i = 12
    ELSE
       LET g_i = 13
    END IF
    LET g_success = 'Y'
    BEGIN WORK
    FOR g_cnt = 1 TO g_i
        EXECUTE i802_pre USING g_cnt
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL cl_err('3:',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
    END FOR
    LET g_i=g_i
{ckp#1}UPDATE afb_file SET afb10 = afb10 * l_percent,
                        afb11 = afb11 * l_percent,
                        afb12 = afb12 * l_percent,
                        afb13 = afb13 * l_percent,
                        afb14 = afb14 * l_percent
     #     WHERE afb00 = g_bookno    AND afb01 = g_afb.afb01 AND     #No.FUN-740020
           WHERE afb00 = g_afb.afb00    AND afb01 = g_afb.afb01 AND  #No.FUN-740020
                 afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 AND
                 afb04 = g_afb.afb04
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
#      CALL cl_err('ckp#1',SQLCA.sqlcode,1)  #NO.FUN-660123  
       CALL cl_err3("upd","afb_file",g_bookno,g_afb.afb01,SQLCA.sqlcode,"","ckp#1",1) #NO.FUN-660123  
    END IF
    SELECT afb_file.* INTO g_afb.* FROM afb_file
             #     WHERE afb00 = g_bookno AND afb01 = g_afb.afb01      #No.FUN-740020
                   WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01   #No.FUN-740020
                         AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                         AND afb04 = g_afb.afb04 AND afbacti = 'Y'                         #FUN-D70090 add
   FOR g_cnt = 1 TO 13
      OPEN i802_c2 USING g_cnt
      FETCH i802_c2 INTO l_afc06[g_cnt]
      IF SQLCA.sqlcode != 100 AND SQLCA.sqlcode != 0 THEN
         CALL cl_err('fetch:',SQLCA.sqlcode,0)  
      END IF
   END FOR
   LET g_afc.afc06_1 = l_afc06[1]    LET g_afc.afc06_2 = l_afc06[2]
   LET g_afc.afc06_3 = l_afc06[3]    LET g_afc.afc06_4 = l_afc06[4]
   LET g_afc.afc06_5 = l_afc06[5]    LET g_afc.afc06_6 = l_afc06[6]
   LET g_afc.afc06_7 = l_afc06[7]    LET g_afc.afc06_8 = l_afc06[8]
   LET g_afc.afc06_9 = l_afc06[9]    LET g_afc.afc06_10 = l_afc06[10]
   LET g_afc.afc06_11 = l_afc06[11]  LET g_afc.afc06_12 = l_afc06[12]
   LET g_afc.afc06_13 = l_afc06[13]
   CALL i802_show()
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1) COMMIT WORK
   ELSE
      CALL cl_rbmsg(1) ROLLBACK WORK
   END IF
 
   #     END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001,002> #

