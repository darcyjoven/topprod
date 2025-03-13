# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai500.4gl
# Descriptions...: 每月攤提保費維護作業
# Date & Author..: 97/08/25 By Sophia
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-570209 05/08/04 By Smapmin 己有修改本期保費金額,但回寫
#                    afat500之分攤金額(fdc10,fdc11)仍未一併更新,造成金額前後不一
# Modify.........: No.MOD-590091 05/09/08 By kim 保單編號不存在時,修改會造成無窮迴圈
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i500_q()一開始應清空g_fdd.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740026 07/04/11 By atsea 會計科目加帳套
# Modify.........: No.FUN-740055 07/04/13 By hongmei 自行輸入，科目二資料未如科目一資料default 
# Modify.........: No.TQC-750104 07/05/21 By rainy 過單
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-980003 09/08/06 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10053 11/01/25 By yinhy 科目查询自动过滤
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60363 11/06/29 By yinhy 錯誤代碼'aoo-801'應改為'aoo-081'
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BB0113 11/11/22 By xuxz      處理固資財簽二重測BUG
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fdd        RECORD LIKE fdd_file.*,
    g_fdd_t      RECORD LIKE fdd_file.*,
    g_fdd01_t    LIKE fdd_file.fdd01,
    g_fdd02_t    LIKE fdd_file.fdd02,
    g_fdd022_t   LIKE fdd_file.fdd022,
    g_fdd03_t    LIKE fdd_file.fdd03,
    g_fdd033_t   LIKE fdd_file.fdd033,
    g_aag02_1    LIKE aag_file.aag02,
    g_aag02_2    LIKE aag_file.aag02,
    g_aag02_3    LIKE aag_file.aag02,
    g_aag02_4    LIKE aag_file.aag02,
    g_faj06      LIKE faj_file.faj06,
     g_wc, g_sql  string  #No.FUN-580092 HCN
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
 
 
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_bookno1      LIKE aza_file.aza81         #No.FUN-740026
DEFINE   g_bookno2      LIKE aza_file.aza82         #No.FUN-740026
DEFINE   g_flag         LIKE type_file.chr1         #No.FUN-740026
 
 
 
MAIN
DEFINE p_row, p_col    LIKE type_file.num5         #No.FUN-680070 SMALLINT
#       l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
 
    LET g_forupd_sql = "SELECT * FROM fdd_file WHERE fdd01 = ? AND fdd02 = ? AND fdd022 = ? AND fdd03 = ? AND fdd033 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_cl CURSOR FROM g_forupd_sql                   # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 12
    OPEN WINDOW i500_w AT p_row,p_col
         WITH FORM "afa/42f/afai500"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #No.FUN-680028 --begin
 #  IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
       CALL cl_set_comp_visible("fdd081,fdd091",TRUE)
       CALL cl_set_comp_visible("aag02_3,aag02_4",TRUE)
       CALL cl_set_comp_visible("fdd062,fdd072",TRUE)  #No:FUN-B60140
    ELSE
       CALL cl_set_comp_visible("fdd081,fdd091",FALSE)
       CALL cl_set_comp_visible("aag02_3,aag02_4",FALSE)
       CALL cl_set_comp_visible("fdd062,fdd072",FALSE)  #No:FUN-B60140
    END IF
    #No.FUN-680028 --end
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i500_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION i500_curs()
    CLEAR FORM
   INITIALIZE g_fdd.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                         #螢幕上取條件
       fdd01,fdd02,fdd022,fdd03,fdd033,fdd04,fdd05,fdd08,fdd081,fdd09,fdd091,fdd06,fdd07,     #No.FUN-680028
       fdd062,fdd072,fdduser,fddgrup,fddmodu,fdddate  #No:FUN-B60140 加fdd062,fdd072
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#No.FUN-740026--begin
        CALL s_get_bookno(g_fdd.fdd03)
             RETURNING g_flag,g_bookno1,g_bookno2    
        IF g_flag= '1' THEN  #
           #CALL cl_err(g_fdd.fdd03,'aoo-801',1 )  #No.TQC-B60363
           CALL cl_err(g_fdd.fdd03,'aoo-081',1 )   #No.TQC-B60363
           NEXT FIELD fdd03
        END IF 
#No.FUN-740026--end
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fdd02)   #財產編號附號
#                CALL q_faj(10,3,g_fdd.fdd02,g_fdd.fdd022)
#                     RETURNING g_fdd.fdd02,g_fdd.fdd022
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fdd.fdd02
                 LET g_qryparam.default2 = g_fdd.fdd022
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdd02
                 NEXT FIELD fdd02
              WHEN INFIELD(fdd04)  #保管部門
#                CALL q_gem(10,3,g_fdd.fdd04)
#                     RETURNING g_fdd.fdd04
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fdd.fdd04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdd04
                 NEXT FIELD fdd04
              WHEN INFIELD(fdd08) # 總帳會計科目查詢
#                CALL q_aag(2,2,g_fdd.fdd08,'','','')
#                     RETURNING g_fdd.fdd08
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd08
                 LET g_qryparam.arg1 = g_aza.aza81       #No.FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdd08
                 NEXT FIELD fdd08
              WHEN INFIELD(fdd09) # 總帳會計科目查詢
#                CALL q_aag(2,2,g_fdd.fdd09,'','','')
#                     RETURNING g_fdd.fdd09
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd09
                 LET g_qryparam.arg1 = g_aza.aza81       #No.FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdd09
                 NEXT FIELD fdd09
              #No.FUN-680028 --begin
              WHEN INFIELD(fdd081) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd081
                 LET g_qryparam.arg1 = g_aza.aza82       #No.FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdd081
                 NEXT FIELD fdd081
              WHEN INFIELD(fdd091) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd091
                 LET g_qryparam.arg1 = g_aza.aza82       #No.FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdd091
                 NEXT FIELD fdd091
              #No.FUN-680028 --end
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                               #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND fdduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                               #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND fddgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND fddgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fdduser', 'fddgrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT fdd01,fdd02,fdd022,fdd03,fdd033",
                "  FROM fdd_file ",  #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY fdd01"
    PREPARE i500_prepare FROM g_sql                   # RUNTIME 編譯
    DECLARE i500_cs                                 # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i500_prepare
 
    LET g_sql="SELECT COUNT(*) FROM fdd_file WHERE ",g_wc CLIPPED
    PREPARE i500_count_pre  FROM g_sql
    DECLARE i500_count CURSOR FOR i500_count_pre
 
END FUNCTION
 
FUNCTION i500_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       ON ACTION insert
          LET g_action_choice="insert"
          IF cl_chk_act_auth() THEN
             CALL i500_a()
          END IF
       ON ACTION query
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
             CALL i500_q()
          END IF
       ON ACTION next
          CALL i500_fetch('N')
       ON ACTION previous
          CALL i500_fetch('P')
       ON ACTION modify
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL i500_u()
          END IF
    {
       ON ACTION invalid
          LET g_action_choice="invalid"
          IF cl_chk_act_auth() THEN
             CALL i500_x()
          END IF
    }
       ON ACTION delete
          LET g_action_choice="delete"
          IF cl_chk_act_auth() THEN
             CALL i500_r()
          END IF
       ON ACTION help
          CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         EXIT MENU
       ON ACTION exit
            LET g_action_choice = "exit"
          EXIT MENU
        ON ACTION jump
           CALL i500_fetch('/')
        ON ACTION first
           CALL i500_fetch('F')
        ON ACTION last
           CALL i500_fetch('L')
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_fdd.fdd01 IS NOT NULL THEN
                LET g_doc.column1 = "fdd01"
                LET g_doc.value1 = g_fdd.fdd01
                 #-----No.MOD-4C0029-----
                LET g_doc.column2 = "fdd02"
                LET g_doc.value2 = g_fdd.fdd02
                LET g_doc.column3 = "fdd022"
                LET g_doc.value3 = g_fdd.fdd022
                LET g_doc.column4 = "fdd03"
                LET g_doc.value4 = g_fdd.fdd03
                LET g_doc.column5 = "fdd033"
                LET g_doc.value5 = g_fdd.fdd033
                 #-----No.MOD-4C0029 END-----
                CALL cl_doc()
             END IF
          END IF
 
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
      #FUN-810046
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i500_cs
END FUNCTION
 
 
FUNCTION i500_a()
    DEFINE l_fdc10   LIKE fdc_file.fdc10,
           l_fdc11   LIKE fdc_file.fdc11
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                  # 清螢幕欄位內容
    INITIALIZE g_fdd.* LIKE fdd_file.*
    LET g_fdd_t.* = g_fdd.*
    LET g_fdd01_t = NULL
    LET g_fdd02_t = NULL
    LET g_fdd022_t= NULL
    LET g_fdd03_t = NULL
    LET g_fdd033_t= NULL
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_fdd.fdduser = g_user
       LET g_fdd.fddoriu = g_user #FUN-980030
       LET g_fdd.fddorig = g_grup #FUN-980030
       LET g_fdd.fddmodu = g_user
       LET g_fdd.fddgrup = g_grup               # 使用者所屬群
       LET g_fdd.fdddate = g_today
       LET g_fdd.fddlegal= g_legal            #FUN-980003 add
 
#No.FUN-740026--begin--
#       SELECT fbz13,fbz14 INTO g_fdd.fdd08,g_fdd.fdd09
#         FROM fbz_file
#        WHERE fbz00='0'
#      SELECT aag02 INTO g_aag02_1 FROM aag_file
#       WHERE aag01 = g_fdd.fdd08
#      DISPLAY g_aag02_1 TO FORMONLY.aag02_1
#
#      SELECT aag02 INTO g_aag02_2 FROM aag_file
#       WHERE aag01 = g_fdd.fdd09
#      DISPLAY g_aag02_2 TO FORMONLY.aag02_2
#       #No.FUN-680028 --begin
#       IF g_aza.aza63 = 'Y' THEN
#          SELECT fbz131,fbz141 INTO g_fdd.fdd081,g_fdd.fdd091
#            FROM fbz_file
#           WHERE fbz00='0'
#          SELECT aag02 INTO g_aag02_3 FROM aag_file
#           WHERE aag01 = g_fdd.fdd081
#          DISPLAY g_aag02_3 TO FORMONLY.aag02_3
#
#          SELECT aag02 INTO g_aag02_4 FROM aag_file
#           WHERE aag01 = g_fdd.fdd091
#          DISPLAY g_aag02_4 TO FORMONLY.aag02_4
#       END IF
#No.FUN-740026--end--
       #No.FUN-680028 --end
       CALL i500_i("a")                         # 各欄位輸入
       IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          INITIALIZE g_fdd.* TO NULL
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
#FUN-570209
#       IF cl_null(g_fdd.fdd01) OR cl_null(g_fdd.fdd02) OR
#          cl_null(g_fdd.fdd022) OR cl_null(g_fdd.fdd03) OR
#          cl_null(g_fdd.fdd033)       THEN              # KEY 不可空白
#          CONTINUE WHILE
#       END IF
#END FUN-570209
   #   SELECT fbz13,fbz14 INTO g_fdd.fdd08,g_fdd.fdd09
   #     FROM fbz_file
   #    WHERE fbz00='0'
       IF cl_null(g_fdd.fdd022) THEN LET g_fdd.fdd022 = ' ' END IF  #FUN-570209
       INSERT INTO fdd_file VALUES(g_fdd.*)     # DISK WRITE
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)   #No.FUN-660136
          CALL cl_err3("ins","fdd_file",g_fdd.fdd01,g_fdd.fdd02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          CONTINUE WHILE
       ELSE
#FUN-570209
    IF cl_null(g_fdd.fdd022) THEN LET g_fdd.fdd022 = ' ' END IF
       SELECT SUM(fdd05) INTO l_fdc11 FROM fdd_file
          WHERE fdd01=g_fdd.fdd01 AND fdd02=g_fdd.fdd02 AND
                fdd022=g_fdd.fdd022
       IF cl_null(l_fdc11) THEN LET l_fdc11 = 0 END IF
       UPDATE fdc_file SET fdc11 = l_fdc11
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
       SELECT (fdc09-fdc11) INTO l_fdc10 FROM fdc_file
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
       IF cl_null(l_fdc10) THEN LET l_fdc10 = 0 END IF
       UPDATE fdc_file SET fdc10 = l_fdc10
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
#END FUN-570209
          LET g_fdd_t.* = g_fdd.*              # 保存上筆資料
          LET g_fdd01_t = g_fdd.fdd01
          LET g_fdd02_t = g_fdd.fdd02
          LET g_fdd022_t= g_fdd.fdd022
          LET g_fdd03_t = g_fdd.fdd03
          LET g_fdd033_t= g_fdd.fdd033
          SELECT fdd01,fdd02,fdd022,fdd03,fdd033 INTO g_fdd.fdd01,g_fdd.fdd02,g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033 FROM fdd_file
           WHERE fdd01  = g_fdd.fdd01
             AND fdd02  = g_fdd.fdd02
             AND fdd022 = g_fdd.fdd022
             AND fdd03  = g_fdd.fdd03
             AND fdd033 = g_fdd.fdd033
       END IF
       EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i500_i(p_cmd)
DEFINE p_cmd         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_flag        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
       l_faj23       LIKE faj_file.faj23,
       l_faj53       LIKE faj_file.faj53,
       l_n           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_mm          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    DISPLAY BY NAME g_fdd.fdd01,g_fdd.fdd02,g_fdd.fdd022,g_fdd.fdd03,
                    g_fdd.fdd033,
                    g_fdd.fdd04,g_fdd.fdd05,g_fdd.fdd06,g_fdd.fdd07,
                    g_fdd.fdd062,g_fdd.fdd072,  #No:FUN-B60140
                    g_fdd.fdd08,g_fdd.fdd081,g_fdd.fdd09,g_fdd.fdd091,     #No.FUN-680028
                    g_fdd.fdduser,g_fdd.fddgrup,g_fdd.fdddate,g_fdd.fddmodu
    
#    DISPLAY g_aag02_1,g_aag02_2,g_aag02_3,g_aag02_4 TO FORMONLY.aag02_1,FORMONLY.aag02_2,FORMONLY.aag02_3,FORMONLY.aag02_4     #No.FUN-680028  #No.FUN-740026
    INPUT BY NAME g_fdd.fdd01,g_fdd.fdd02,g_fdd.fdd022,g_fdd.fdd03, g_fdd.fddoriu,g_fdd.fddorig,
                  g_fdd.fdd033,
                  g_fdd.fdd04,g_fdd.fdd05,g_fdd.fdd06,g_fdd.fdd07,g_fdd.fdd062,g_fdd.fdd072,  #No:FUN-B60140 加g_fdd.fdd062,g_fdd.fdd072
                  g_fdd.fdd08,g_fdd.fdd081,g_fdd.fdd09,g_fdd.fdd091     #No.FUN-680028
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i500_set_entry(p_cmd)
            CALL i500_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
       AFTER FIELD fdd01
          IF NOT cl_null(g_fdd.fdd01) THEN
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY #MOD-590091
               (p_cmd = "u" AND g_fdd.fdd01 != g_fdd_t.fdd01) THEN #MOD-590091
                SELECT COUNT(*) INTO g_cnt FROM fda_file
                 WHERE fda01 = g_fdd.fdd01
                IF g_cnt = 0 THEN
                   CALL cl_err(g_fdd.fdd01,'afa-901',0)
                   NEXT FIELD fdd01
                END IF
             END IF
          END IF
 
       AFTER FIELD fdd02
          IF NOT cl_null(g_fdd.fdd02) THEN
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY #MOD-590091
               (p_cmd = "u" AND g_fdd.fdd02 != g_fdd_t.fdd02) THEN #MOD-590091
                SELECT COUNT(*) INTO g_cnt FROM faj_file
                 WHERE faj02 = g_fdd.fdd02 AND faj43 IN ('1','2','4','7','8','9')
                IF g_cnt = 0 THEN
                   CALL cl_err(g_fdd.fdd02,'afa-902',0)
                   NEXT FIELD fdd02
                END IF
             END IF
          END IF
 
       AFTER FIELD fdd022
          IF cl_null(g_fdd.fdd022) THEN LET g_fdd.fdd022 =' ' END IF
          #SELECT COUNT(*),faj06 INTO g_cnt,g_faj06 FROM faj_file   #FUN-570209
           SELECT COUNT(*) INTO g_cnt FROM faj_file   #FUN-570209
           WHERE faj02 = g_fdd.fdd02 AND faj43 IN ('1','2','4','7','8','9')
             AND faj022 = g_fdd.fdd022
          IF g_cnt = 0 THEN
             CALL cl_err(g_fdd.fdd022,'afa-902',0)
             NEXT FIELD fdd022
          ELSE
             SELECT faj06 INTO g_faj06 FROM faj_file      #FUN-570209
                  WHERE faj02 = g_fdd.fdd02 AND faj43 IN ('1','2','4','7','8','9')   #FUN-570209
                  AND faj022 = g_fdd.fdd022   #FUN-570209
             DISPLAY g_faj06 TO FORMONLY.faj02
          END IF
 
#No.FUN-740026--begin--
       AFTER FIELD fdd03  #年
 
          IF NOT cl_null(g_fdd.fdd03) OR  g_fdd.fdd03 != g_fdd_t.fdd03 THEN
             CALL s_get_bookno(g_fdd.fdd03)
                  RETURNING g_flag,g_bookno1,g_bookno2    
             IF g_flag= '1' THEN  #
                #CALL cl_err(g_fdd.fdd03,'aoo-801',1 )  #No.TQC-B60363
                CALL cl_err(g_fdd.fdd03,'aoo-081',1 )   #No.TQC-B60363
                NEXT FIELD fdd03
             END IF 
             IF p_cmd ="a"    THEN    
                SELECT fbz13,fbz14 INTO g_fdd.fdd08,g_fdd.fdd09
                  FROM fbz_file
                 WHERE fbz00='0'
                SELECT aag02 INTO g_aag02_1 FROM aag_file
                 WHERE aag01 = g_fdd.fdd08
                  AND aag00 = g_bookno1
                DISPLAY  g_fdd.fdd08  TO fdd08
                DISPLAY g_aag02_1 TO FORMONLY.aag02_1
 
                SELECT aag02 INTO g_aag02_2 FROM aag_file
                 WHERE aag01 = g_fdd.fdd09
                   AND aag00 = g_bookno1
                DISPLAY  g_fdd.fdd09  TO fdd09
                DISPLAY g_aag02_2 TO FORMONLY.aag02_2
                #No.FUN-680028 --begin
             #  IF g_aza.aza63 = 'Y' THEN
                IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
                   SELECT fbz131,fbz141 INTO g_fdd.fdd081,g_fdd.fdd091
                     FROM fbz_file
                    WHERE fbz00='0'
                   SELECT aag02 INTO g_aag02_3 FROM aag_file
                    WHERE aag01 = g_fdd.fdd081
                     # AND aag00 = g_bookno2 #FUN-BB0113 mark
                      AND aag00 = g_faa.faa02c #FUn-BB0113 add
                   DISPLAY g_fdd.fdd081 TO fdd081
                   DISPLAY g_aag02_3 TO FORMONLY.aag02_3
 
                   SELECT aag02 INTO g_aag02_4 FROM aag_file
                    WHERE aag01 = g_fdd.fdd091
                      #AND aag00 = g_bookno2  #FUN-BB0113 mark
                      AND aag00 = g_faa.faa02c #FUn-BB0113 add
                   DISPLAY  g_fdd.fdd091  TO fdd091
                   DISPLAY g_aag02_4 TO FORMONLY.aag02_4
                END IF 
             END IF 
          END IF   
 
                   
#No.FUN-740026--end--
 
       AFTER FIELD fdd033  #月
          IF NOT cl_null(g_fdd.fdd033) THEN
             IF g_fdd.fdd033 > 12 OR g_fdd.fdd033 < 1 THEN
                NEXT FIELD fdd033
             END IF
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_fdd.fdd01 != g_fdd_t.fdd01) THEN
                SELECT count(*) INTO l_n FROM fdd_file
                 WHERE fdd01  = g_fdd.fdd01
                   AND fdd02  = g_fdd.fdd02
                   AND fdd022 = g_fdd.fdd022
                   AND fdd03  = g_fdd.fdd03
                   AND fdd033 = g_fdd.fdd033
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_fdd.fdd01,-239,0)
                   NEXT FIELD fdd03
                END IF
             END IF
          END IF
 
       AFTER FIELD fdd04
          IF NOT cl_null(g_fdd.fdd04) THEN
             SELECT faj23,faj53 INTO l_faj23,l_faj53 FROM faj_file
              WHERE faj02 = g_fdd.fdd02
                AND faj022= g_fdd.fdd022
             IF l_faj23 = '1' THEN
                CALL i500_fdd04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fdd.fdd04,g_errno,0)
                    NEXT FIELD fdd04
                 ELSE
                    CALL i500_fdd04('d')
                 END IF
             ELSE
               CALL i500_fdd042('a',l_faj53)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fdd.fdd04,g_errno,1)
                  NEXT FIELD fdd04
               END IF
             END IF
          END IF
 
       AFTER FIELD fdd08
         IF NOT g_fdd.fdd08 IS NULL THEN
            CALL i500_aag(g_fdd.fdd08,'1',g_bookno1)     #No.FUN-740026
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_fdd.fdd08
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aag09 = 'Y' AND aagacti = 'Y' AND aag01 LIKE '",g_fdd.fdd08 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_fdd.fdd08
               DISPLAY BY NAME g_fdd.fdd08
               #No.FUN-B10053  --End
               NEXT FIELD fdd08
            ELSE
               SELECT aag02 INTO g_aag02_1 FROM aag_file
                WHERE aag01 = g_fdd.fdd08
                  AND aag00 = g_bookno1           #No.FUN-740026
               DISPLAY g_aag02_1 TO FORMONLY.aag02_1
            END IF
         ELSE
            LET g_aag02_1 = NULL
            DISPLAY g_aag02_1 TO FORMONLY.aag02_1
         END IF
 
       AFTER FIELD fdd09
         IF g_fdd.fdd09 IS NOT NULL THEN
            CALL i500_aag(g_fdd.fdd09,'2',g_bookno1)     #No.FUN-740026
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) 
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_fdd.fdd09
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aag09 = 'Y' AND aagacti = 'Y' AND aag01 LIKE '",g_fdd.fdd09 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_fdd.fdd09
               DISPLAY BY NAME g_fdd.fdd09
               #No.FUN-B10053  --End
               NEXT FIELD fdd09
            ELSE
               SELECT aag02 INTO g_aag02_2 FROM aag_file
                WHERE aag01 = g_fdd.fdd09
                  AND aag00 = g_bookno1           #No.FUN-740026
               DISPLAY g_aag02_2 TO FORMONLY.aag02_2
            END IF
         ELSE
            LET g_aag02_2 = NULL
            DISPLAY g_aag02_2 TO FORMONLY.aag02_2
         END IF
 
       #No.FUN-680028 --begin
       AFTER FIELD fdd081
         IF g_fdd.fdd081 IS NOT NULL THEN
   #        CALL i500_aag(g_fdd.fdd081,'3',g_bookno1)         #No.FUN-740026  #No.FUN-740055
            #CALL i500_aag(g_fdd.fdd081,'3',g_bookno2)         #No.FUN-740055 #FUN-BB0113 mark
            CALL i500_aag(g_fdd.fdd081,'3',g_faa.faa02c) #FUN-BB0113 add
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) 
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_fdd.fdd081
               #LET g_qryparam.arg1 = g_bookno2#FUN-BB0113 mark
               LET g_qryparam.arg1 = g_faa.faa02c#FUN-BB0113 add
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aag09 = 'Y' AND aagacti = 'Y' AND aag01 LIKE '",g_fdd.fdd081 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_fdd.fdd081
               DISPLAY BY NAME g_fdd.fdd081
               #No.FUN-B10053  --End
               NEXT FIELD fdd081
            ELSE
               SELECT aag02 INTO g_aag02_3 FROM aag_file
                WHERE aag01 = g_fdd.fdd081
            #     AND aag00 = g_bookno1           #No.FUN-740026 #No.FUN-740055
                 # AND aag00 = g_bookno2           #No.FUN-740055 #FUN-BB0113 mark
                  AND aag00 =g_faa.faa02c#FUN-BB0113 add
               DISPLAY g_aag02_3 TO FORMONLY.aag02_3
            END IF
         ELSE
            LET g_aag02_3 = NULL
            DISPLAY g_aag02_3 TO FORMONLY.aag02_3
         END IF
 
       AFTER FIELD fdd091
         IF g_fdd.fdd091 IS NOT NULL THEN
      #     CALL i500_aag(g_fdd.fdd091,'4',g_bookno1)       #No.FUN-740026  #No.FUN-740055
            #CALL i500_aag(g_fdd.fdd091,'4',g_bookno2)       #No.FUN-740055 #FUN-BB0113 mark
            CALL i500_aag(g_fdd.fdd091,'4',g_faa.faa02c)  #FUN-BB0113 add
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) 
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_fdd.fdd091
               #LET g_qryparam.arg1 = g_bookno2 #FUN-BB0113 mark
               LET g_qryparam.arg1 = g_faa.faa02c#FUN-BB0113 add
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aag09 = 'Y' AND aagacti = 'Y' AND aag01 LIKE '",g_fdd.fdd091 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_fdd.fdd091
               DISPLAY BY NAME g_fdd.fdd091
               #No.FUN-B10053  --End
               NEXT FIELD fdd091
            ELSE
               SELECT aag02 INTO g_aag02_4 FROM aag_file
                WHERE aag01 = g_fdd.fdd091
           #      AND aag00 = g_bookno1           #No.FUN-740026  #No.FUN-740055
           #       AND aag00 = g_bookno2           #No.FUN-740055  #FUN-BB0113 mark
                  AND aag00 =g_faa.faa02c#FUN-BB0113 add
               DISPLAY g_aag02_4 TO FORMONLY.aag02_4
            END IF
         ELSE
            LET g_aag02_4 = NULL
            DISPLAY g_aag02_4 TO FORMONLY.aag02_4
         END IF
       #No.FUN-680028 --end
 
       AFTER FIELD fdd05
          IF cl_null(g_fdd.fdd05) THEN
             LET g_fdd.fdd05 = 0
          END IF
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_fdd.fdduser = s_get_data_owner("fdd_file") #FUN-C10039
          LET g_fdd.fddgrup = s_get_data_group("fdd_file") #FUN-C10039
          LET l_flag='N'
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          IF g_fdd.fdd01 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_fdd.fdd01
          END IF
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD fdd01
          END IF
          IF cl_null(g_fdd.fdd05) THEN
             LET g_fdd.fdd05 = 0
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fdd02)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fdd.fdd02
                 LET g_qryparam.default2 = g_fdd.fdd022
                 CALL cl_create_qry() RETURNING g_fdd.fdd02,g_fdd.fdd022
#                 CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd02 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd022 )
#                 CALL q_faj(10,3,g_fdd.fdd02,g_fdd.fdd022)
#                       RETURNING g_fdd.fdd02,g_fdd.fdd022
#                 CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd02 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd022 )
                 DISPLAY BY NAME g_fdd.fdd02,g_fdd.fdd022
                 NEXT FIELD fdd02
              WHEN INFIELD(fdd04)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fdd.fdd04
                 CALL cl_create_qry() RETURNING g_fdd.fdd04
#                  CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd04 )
#                  CALL q_gem(10,3,g_fdd.fdd04)
#                       RETURNING g_fdd.fdd04
#                  CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd04 )
                 DISPLAY BY NAME g_fdd.fdd04
                 NEXT FIELD fdd04
              WHEN INFIELD(fdd08) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd08
                 LET g_qryparam.arg1 = g_bookno1             #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fdd.fdd08
#                 CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd08 )
#                 CALL q_aag(2,2,g_fdd.fdd08,'','','')
#                      RETURNING g_fdd.fdd08
#                 CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd08 )
                 DISPLAY BY NAME g_fdd.fdd08
                 NEXT FIELD fdd08
              WHEN INFIELD(fdd09) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd09
                 LET g_qryparam.arg1 = g_bookno1             #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fdd.fdd09
#               CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd09 )
#               CALL q_aag(2,2,g_fdd.fdd09,'','','')
#                    RETURNING g_fdd.fdd09
#               CALL FGL_DIALOG_SETBUFFER( g_fdd.fdd09 )
                 DISPLAY BY NAME g_fdd.fdd09
                 NEXT FIELD fdd09
              #No.FUN-680028 --begin
              WHEN INFIELD(fdd081)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd081
                 #LET g_qryparam.arg1 = g_bookno2            #No.FUN-740026  #FUN-BB0113mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fdd.fdd081
                 DISPLAY BY NAME g_fdd.fdd081
                 NEXT FIELD fdd081
              WHEN INFIELD(fdd091)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fdd.fdd091
                 #LET g_qryparam.arg1 = g_bookno2             #No.FUN-740026#FUN-BB0113mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fdd.fdd091
                 DISPLAY BY NAME g_fdd.fdd091
                 NEXT FIELD fdd091
              #No.FUN-680028 --end
           END CASE
 
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
 
FUNCTION i500_fdd04(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gem02    LIKE gem_file.gem02,
      l_gemacti  LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem01,gem02,gemacti INTO l_gem01,l_gem02,l_gemacti
       FROM gem_file
      WHERE gem01 = g_fdd.fdd04
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gem02 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd='d' AND cl_null(g_errno) THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
     END IF
END FUNCTION
 
FUNCTION i500_fdd042(p_cmd,l_faj53)
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_cnt        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_faj53      LIKE faj_file.faj53
 
      LET g_errno = ' '
      IF cl_null(l_faj53) THEN
         #CALL cl_err(' ',STATUS,0)   #FUN-570209
         CALL cl_err('','afa-975',0)   #FUN-570209
      ELSE
         SELECT COUNT(*) INTO l_cnt
           FROM fad_file
          WHERE fad04 = g_fdd.fdd04
            AND fad03 = l_faj53
            AND fadacti = 'Y'
         IF l_cnt = 0 THEN LET g_errno = 'afa-342' END IF
      END IF
END FUNCTION
 
FUNCTION i500_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fdd.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i500_curs()                        # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i500_count
    FETCH i500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)
       INITIALIZE g_fdd.* TO NULL
    ELSE
       CALL i500_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i500_fetch(p_flfdd)
DEFINE p_flfdd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_abso       LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfdd
       WHEN 'N' FETCH NEXT     i500_cs INTO g_fdd.fdd01,g_fdd.fdd02,
                                           g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
       WHEN 'P' FETCH PREVIOUS i500_cs INTO g_fdd.fdd01,g_fdd.fdd02,
                                           g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
       WHEN 'F' FETCH FIRST    i500_cs INTO g_fdd.fdd01,g_fdd.fdd02,
                                           g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
       WHEN 'L' FETCH LAST     i500_cs INTO g_fdd.fdd01,g_fdd.fdd02,
                                           g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
       WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
          CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump  i500_cs INTO g_fdd.fdd01,g_fdd.fdd02,
                                           g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)
       INITIALIZE g_fdd.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flfdd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_fdd.* FROM fdd_file       # 重讀DB,因TEMP有不被更新特性
       WHERE fdd01 = g_fdd.fdd01 AND fdd02 = g_fdd.fdd02 AND fdd022 = g_fdd.fdd022 AND fdd03 = g_fdd.fdd03 AND fdd033 = g_fdd.fdd033 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)   #No.FUN-660136
       CALL cl_err3("sel","fdd_file",g_fdd.fdd01,g_fdd.fdd02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
       LET g_data_owner = g_fdd.fdduser   #FUN-4C0059
       LET g_data_group = g_fdd.fddgrup   #FUN-4C0059
       CALL i500_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i500_show()
    LET g_fdd_t.* = g_fdd.*
    DISPLAY BY NAME g_fdd.fdd01,g_fdd.fdd02,g_fdd.fdd022,g_fdd.fdd03, g_fdd.fddoriu,g_fdd.fddorig,
                    g_fdd.fdd033,g_fdd.fdd04,g_fdd.fdd05,g_fdd.fdd06,
                    g_fdd.fdd07,g_fdd.fdd08,g_fdd.fdd09,g_fdd.fdd081,g_fdd.fdd091,     #No.FUN-680028
                    g_fdd.fdd062,g_fdd.fdd072,  #No:FUN-B60140
                    g_fdd.fdduser,g_fdd.fddgrup,g_fdd.fddmodu,g_fdd.fdddate
 
    #No.FUN-680028 --begin
    LET g_aag02_1 = NULL
    LET g_aag02_2 = NULL
    LET g_aag02_3 = NULL
    LET g_aag02_4 = NULL
    #No.FUN-680028 --end
 
    SELECT aag02 INTO g_aag02_1 FROM aag_file
     WHERE aag01 = g_fdd.fdd08
       AND aag00 = g_bookno1           #No.FUN-740026
    DISPLAY g_aag02_1 TO FORMONLY.aag02_1
 
    SELECT aag02 INTO g_aag02_2 FROM aag_file
     WHERE aag01 = g_fdd.fdd09
       AND aag00 = g_bookno1           #No.FUN-740026
    DISPLAY g_aag02_2 TO FORMONLY.aag02_2
    #No.FUN-680028 --begin
  # IF g_aza.aza63 ='Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
       SELECT aag02 INTO g_aag02_3 FROM aag_file
        WHERE aag01 = g_fdd.fdd081
  #       AND aag00 = g_bookno1           #No.FUN-740026 #No.FUN-740055
       #   AND aag00 = g_bookno2           #No.FUN-740055#FUN-BB0113 mark
          AND aag00 = g_faa.faa02c #FUn-BB0113 add
       DISPLAY g_aag02_3 TO FORMONLY.aag02_3
   
       SELECT aag02 INTO g_aag02_4 FROM aag_file
        WHERE aag01 = g_fdd.fdd091
 #        AND aag00 = g_bookno1           #No.FUN-740026  #No.FUN-740055
       #   AND aag00 = g_bookno2           #No.FUN-740055#FUN-BB0113 mark
          AND aag00 = g_faa.faa02c #FUn-BB0113 add
       DISPLAY g_aag02_4 TO FORMONLY.aag02_4
    #No.FUN-680028 --end
    END IF
    SELECT faj06 INTO g_faj06 FROM faj_file
     WHERE faj02  = g_fdd.fdd02
     AND faj022 = g_fdd.fdd022
     DISPLAY g_faj06 TO FORMONLY.faj02
    CALL i500_fdd04('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i500_u()
    DEFINE l_fdc10   LIKE fdc_file.fdc10,
           l_fdc11   LIKE fdc_file.fdc11
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fdd.fdd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF NOT cl_null(g_fdd.fdd06) OR NOT cl_null(g_fdd.fdd07) 
       OR NOT cl_null(g_fdd.fdd062) OR NOT cl_null(g_fdd.fdd072) THEN #No:FUN-B60140
       CALL cl_err(g_fdd.fdd01,'afa-311',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i500_cl USING g_fdd.fdd01,g_fdd.fdd02,g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
 IF SQLCA.sqlcode THEN
       CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)
       CLOSE i500_cl
 END IF
 
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_fdd.*                # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)
       CLOSE i500_cl
       COMMIT WORK
       RETURN
    END IF
    CALL i500_show()                          # 顯示最新資料
    LET g_fdd_t.* = g_fdd.*
    LET g_fdd01_t = g_fdd.fdd01
    LET g_fdd02_t = g_fdd.fdd02
    LET g_fdd022_t= g_fdd.fdd022
    LET g_fdd03_t = g_fdd.fdd03
    LET g_fdd033_t= g_fdd.fdd033
    LET g_fdd.fddmodu = g_user                # 修改者
    LET g_fdd.fdddate = g_today               # 修改日期
    WHILE TRUE
       CALL i500_i("u")                       # 欄位更改
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_fdd.* = g_fdd_t.*
          CALL i500_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       IF cl_null(g_fdd.fdd01) THEN
          CONTINUE WHILE
       END IF
       UPDATE fdd_file SET fdd_file.* = g_fdd.* # 更新DB
          WHERE fdd01 = g_fdd01_t AND fdd02 = g_fdd02_t AND fdd022 = g_fdd022_t AND fdd03 = g_fdd03_t AND fdd033 = g_fdd033_t        # COLAUTH?
       IF SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)   #No.FUN-660136
          CALL cl_err3("upd","fdd_file",g_fdd01_t,g_fdd02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          CONTINUE WHILE
       ELSE
#FUN-570209
    IF cl_null(g_fdd.fdd022) THEN LET g_fdd.fdd022 = ' ' END IF
       SELECT SUM(fdd05) INTO l_fdc11 FROM fdd_file
          WHERE fdd01=g_fdd.fdd01 AND fdd02=g_fdd.fdd02 AND
                fdd022=g_fdd.fdd022
       IF cl_null(l_fdc11) THEN LET l_fdc11 = 0 END IF
       UPDATE fdc_file SET fdc11 = l_fdc11
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
       SELECT (fdc09-fdc11) INTO l_fdc10 FROM fdc_file
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
       IF cl_null(l_fdc10) THEN LET l_fdc10 = 0 END IF
       UPDATE fdc_file SET fdc10 = l_fdc10
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
    IF g_fdd.fdd022 <> g_fdd_t.fdd022 THEN
       IF cl_null(g_fdd_t.fdd022) THEN LET g_fdd_t.fdd022 = ' ' END IF
          SELECT SUM(fdd05) INTO l_fdc11 FROM fdd_file
             WHERE fdd01=g_fdd_t.fdd01 AND fdd02=g_fdd_t.fdd02 AND
                   fdd022=g_fdd_t.fdd022
          IF cl_null(l_fdc11) THEN LET l_fdc11 = 0 END IF
          UPDATE fdc_file SET fdc11 = l_fdc11
             WHERE fdc01=g_fdd_t.fdd01 AND fdc03=g_fdd_t.fdd02 AND
                   fdc032=g_fdd_t.fdd022
          SELECT (fdc09-fdc11) INTO l_fdc10 FROM fdc_file
             WHERE fdc01=g_fdd_t.fdd01 AND fdc03=g_fdd_t.fdd02 AND
                   fdc032=g_fdd_t.fdd022
          IF cl_null(l_fdc10) THEN LET l_fdc10 = 0 END IF
          UPDATE fdc_file SET fdc10 = l_fdc10
             WHERE fdc01=g_fdd_t.fdd01 AND fdc03=g_fdd_t.fdd02 AND
                   fdc032=g_fdd_t.fdd022
    END IF
#END FUN-570209
       END IF
       EXIT WHILE
    END WHILE
 
    CLOSE i500_cl
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION i500_r()
    DEFINE l_fdc10   LIKE fdc_file.fdc10,
           l_fdc11   LIKE fdc_file.fdc11
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fdd.fdd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF NOT cl_null(g_fdd.fdd06) OR NOT cl_null(g_fdd.fdd07) 
       OR NOT cl_null(g_fdd.fdd062) OR NOT cl_null(g_fdd.fdd072) THEN #No:FUN-B60140
       CALL cl_err(g_fdd.fdd01,'afa-311',0)
       RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i500_cl USING g_fdd.fdd01,g_fdd.fdd02,g_fdd.fdd022,g_fdd.fdd03,g_fdd.fdd033
 
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_fdd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fdd.fdd01,SQLCA.sqlcode,0)
       CLOSE i500_cl
       COMMIT WORK
       RETURN
    END IF
    CALL i500_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fdd01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fdd.fdd01       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "fdd02"          #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_fdd.fdd02       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "fdd022"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_fdd.fdd022      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "fdd03"          #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_fdd.fdd03       #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "fdd033"         #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_fdd.fdd033      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM fdd_file WHERE fdd01  = g_fdd.fdd01
                              AND fdd02  = g_fdd.fdd02
                              AND fdd022 = g_fdd.fdd022
                              AND fdd03  = g_fdd.fdd03
                              AND fdd033 = g_fdd.fdd033
       IF sqlca.sqlerrd[3]=0 THEN
          LET g_success = 'N'
       ELSE
#FUN-570209
    IF cl_null(g_fdd.fdd022) THEN LET g_fdd.fdd022 = ' ' END IF
       SELECT SUM(fdd05) INTO l_fdc11 FROM fdd_file
          WHERE fdd01=g_fdd.fdd01 AND fdd02=g_fdd.fdd02 AND
                fdd022=g_fdd.fdd022
       IF cl_null(l_fdc11) THEN LET l_fdc11 = 0 END IF
       UPDATE fdc_file SET fdc11 = l_fdc11
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
       SELECT (fdc09-fdc11) INTO l_fdc10 FROM fdc_file
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
       IF cl_null(l_fdc10) THEN LET l_fdc10 = 0 END IF
       UPDATE fdc_file SET fdc10 = l_fdc10
          WHERE fdc01=g_fdd.fdd01 AND fdc03=g_fdd.fdd02 AND
                fdc032=g_fdd.fdd022
#END FUN-570209
          INITIALIZE g_fdd.* TO NULL
          CLEAR FORM
         #CKP3
         OPEN i500_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i500_cs
             CLOSE i500_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i500_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i500_cs
             CLOSE i500_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i500_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i500_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i500_fetch('/')
         END IF
       END IF
    END IF
    CLOSE i500_cl
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION i500_aag(p_key,p_key1,p_bookno)       #No.FUN-740026
DEFINE
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_key      LIKE fcx_file.fcx09,
      p_key1     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
DEFINE p_bookno LIKE aag_file.aag00
 
    LET g_errno = " "
    SELECT aag02,aagacti,aag07,aag03,aag09
      INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
      FROM aag_file
     WHERE aag01=p_key
       AND aag00 = p_bookno           #No.FUN-740026
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
         WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
         WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CASE
           WHEN p_key1='1'
                DISPLAY l_aag02 TO FORMONLY.aag02_1
           WHEN p_key1='2'
                DISPLAY l_aag02 TO FORMONLY.aag02_2
           #No.FUN-680028 --begin
           WHEN p_key1='3'
                DISPLAY l_aag02 TO FORMONLY.aag02_3
           WHEN p_key1='4'
                DISPLAY l_aag02 TO FORMONLY.aag02_4
           #No.FUN-680028 --end
       END CASE
    END IF
END FUNCTION
 
FUNCTION i500_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fdd01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i500_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n     LIKE type_file.num10        #No.FUN-680070 INTEGER
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fdd01",FALSE)
  END IF
END FUNCTION
 
#TQC-750104

