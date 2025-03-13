# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai901.4gl
# Descriptions...: 資產折舊費用開帳作業-財簽
# Date & Author..: 2003/09/18 By Winny
# Modify.........: No.8547 03/10/22 By Kitty 1.折舊金額在開帳時可以為0 2.分攤比率改為可以輸>0 < 100
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-470513 04/08/11 By Nicola 判斷欄位空白的部份應從per加上not null
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i901_q()一開始應清空g_fao.*值
# Modify.........: No.TQC-6A0023 06/10/16 By cl  增加字段faj109
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/05 By Rayven 錄入時分攤類型開窗選擇的是資產會計科目而不是分攤類型
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740026 07/04/11 By atsea  會計科目加帳套
# Modify.........: No.TQC-740269 07/04/25 By bnlent 用年度取帳套位置有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.TQC-B20074 11/02/18 By yinhy 增加兩個欄位fao20，fao201
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60363 11/06/29 By yinhy 錯誤代碼'aoo-801'應改為'aoo-081'
# Modify.........: No.MOD-BC0131 12/01/13 By Sakura 移除fao111/fao121/fao201
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fao       RECORD LIKE fao_file.*,
       g_fao_t     RECORD LIKE fao_file.*,  #備份舊值
       g_fao01_t   LIKE fao_file.fao01,     #Key值備份
       g_fao02_t   LIKE fao_file.fao02,
       g_fao03_t   LIKE fao_file.fao03,
       g_fao04_t   LIKE fao_file.fao04,
       g_fao041_t  LIKE fao_file.fao041,
       g_fao05_t   LIKE fao_file.fao05,
       g_fao06_t   LIKE fao_file.fao06,
       g_wc        STRING,                  #儲存 user 的查詢條件
       g_sql       STRING                   #組 sql 用
 
DEFINE g_faj109_t  LIKE faj_file.faj109         #No.TQC-6A0023                                                                      
DEFINE g_faj       RECORD                       #No.TQC-6A0023                                                                      
                   faj109 LIKE faj_file.faj109                                                                                      
                   END RECORD                                                                                                       
DEFINE g_faj_t     RECORD                       #No.TQC-6A0023                                                                      
                   faj109 LIKE faj_file.faj109                                                                                      
                   END RECORD     
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令       #No.FUN-680070 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_curs_index         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_row_count          LIKE type_file.num10         #總筆數       #No.FUN-680070 INTEGER
DEFINE g_jump               LIKE type_file.num10         #查詢指定的筆數       #No.FUN-680070 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5         #是否開啟指定筆視窗       #No.FUN-680070 SMALLINT
DEFINE   g_bookno1      LIKE aza_file.aza81         #No.FUN-740026 
DEFINE   g_bookno2      LIKE aza_file.aza82         #No.FUN-740026 
DEFINE   g_flag         LIKE type_file.chr1         #No.FUN-740026 
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
#        l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8)  #NO.FUN-6A0069
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
   INITIALIZE g_fao.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM fao_file WHERE fao01 = ? AND fao02 = ? AND fao03 = ? AND fao04 = ? AND fao05 = ? AND fao06 = ? AND fao041 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i901_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i901_w AT p_row,p_col
     WITH FORM "afa/42f/afai901"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
#MOD-BC0131---begin mark
#   #No.FUN-680028 --begin
## IF g_aza.aza63 = 'Y' THEN
#   IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
#      CALL cl_set_comp_visible("fao111,fao121,fao201",TRUE)     #TQC-B20074 add fao201
#   ELSE
#     CALL cl_set_comp_visible("fao111,fao121,fao201",FALSE)    #TQC-B20074 add fao201
#   END IF
#   #No.FUN-680028 --end
#MOD-BC0131---begin mark
   LET g_action_choice = ""
   CALL i901_menu()
 
   CLOSE WINDOW i901_w
     CALL cl_used(g_prog,g_time,2) RETURNING  g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION i901_curs()
DEFINE ls STRING
 
    CLEAR FORM
   INITIALIZE g_fao.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON fao041,fao01,fao02,fao03,fao04,fao05,
                              fao06,fao09,fao10,fao13,fao07,fao08,
                              fao14,fao15,fao17,faj109,fao16,fao11,fao12,fao20   #No:A099 #No.TQC-6A0023 add afaj109 #TQC-B20074 add fan20
                              #fao111,fao121,fao201     #No.FUN-680028 #TQC-B20074 add fao201 #MOD-BC0131 mark
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fao01)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fao.fao01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao01
                 NEXT FIELD fao01
              WHEN INFIELD(fao06)  #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fao.fao06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao06
                 NEXT FIELD fao06
              WHEN INFIELD(fao09)  #被分攤部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fao.fao09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao09
                 NEXT FIELD fao09
              WHEN INFIELD(fao11) # 資產會計科目查詢
#                CALL q_aag(2,2,g_fao.fao11,'23','2','') RETURNING g_fao.fao11
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fao.fao11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao11
                 NEXT FIELD fao11
              WHEN INFIELD(fao12) # 折舊會計科目查詢
#                CALL q_aag(2,2,g_fao.fao12,'23','2','') RETURNING g_fao.fao12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fao.fao12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao12
                 NEXT FIELD fao12
             #No.TQC-B20074  --Begin
             WHEN INFIELD(fao20) # 累折會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fao.fao20
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao20
                 NEXT FIELD fao20
             #No.TQC-B20074  --End
           #MOD-BC0131---end mark
           #   #No.FUN-680028 --begin
           #   WHEN INFIELD(fao111)
           #      CALL cl_init_qry_var()
           #      LET g_qryparam.state = "c"
           #      LET g_qryparam.form = "q_aag"
           #      LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
           #      LET g_qryparam.default1 = g_fao.fao111
           #      CALL cl_create_qry() RETURNING g_qryparam.multiret
           #      DISPLAY g_qryparam.multiret TO fao111
           #      NEXT FIELD fao111
           #   WHEN INFIELD(fao121)
           #      CALL cl_init_qry_var()
           #      LET g_qryparam.state = "c"
           #      LET g_qryparam.form = "q_aag"
           #      LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
           #      LET g_qryparam.default1 = g_fao.fao121
           #      CALL cl_create_qry() RETURNING g_qryparam.multiret
           #      DISPLAY g_qryparam.multiret TO fao121
           #      NEXT FIELD fao121
           #   #No.FUN-680028 --end
           #   #No.TQC-B20074  --Begin
           #   WHEN INFIELD(fao201)
           #      CALL cl_init_qry_var()
           #      LET g_qryparam.state = "c"
           #      LET g_qryparam.form = "q_aag"
           #      LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
           #      LET g_qryparam.default1 = g_fao.fao201
           #     CALL cl_create_qry() RETURNING g_qryparam.multiret
           #      DISPLAY g_qryparam.multiret TO fao201
           #      NEXT FIELD fao201
           #   #No.TQC-B20074  --End
           #MOD-BC0131---end mark
              WHEN INFIELD(fao13) # 分攤類別查詢
                 CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_fad"   #No.TQC-6C0009 mark
                 LET g_qryparam.form = "q_fad1"  #No.TQC-6C0009
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fao.fao13
                 LET g_qryparam.multiret_index   = '2'   #No.FUN-680028
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fao13
                 NEXT FIELD fao13
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
 
    LET g_sql = "SELECT fao_file.* FROM fao_file ",  #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY fao01"
    PREPARE i901_prepare FROM g_sql                   # RUNTIME 編譯
    DECLARE i901_cs                                 # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i901_prepare
 
DISPLAY "g_sql:",g_sql
 
 
    LET g_sql="SELECT COUNT(*) FROM fao_file WHERE ",g_wc CLIPPED
    PREPARE i901_cntpre FROM g_sql
    DECLARE i901_count CURSOR FOR i901_cntpre
 
END FUNCTION
 
FUNCTION i901_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i901_a()
            END IF
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
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i901_r()
            END IF
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_fao.fao01 IS NOT NULL THEN
                LET g_doc.column1 = "fao01"
                LET g_doc.value1 = g_fao.fao01
                 #-----No.MOD-4C0029-----
                LET g_doc.column2 = "fao02"
                LET g_doc.value2 = g_fao.fao02
                LET g_doc.column3 = "fao03"
                LET g_doc.value3 = g_fao.fao03
                LET g_doc.column4 = "fao04"
                LET g_doc.value4 = g_fao.fao04
                 #-----No.MOD-4C0029 END-----
                CALL cl_doc()
             END IF
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
      #FUN-810046
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i901_cs
END FUNCTION
 
FUNCTION i901_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_fao.* LIKE fao_file.*
    LET g_fao01_t = NULL
    LET g_wc = NULL
    LET g_fao.fao041 = '0'
    LET g_fao.fao03  = YEAR(g_today)
    LET g_fao.fao04  = MONTH(g_today)
    LET g_fao.fao05 = '1'
    LET g_fao.fao10 = '2'
    LET g_fao.fao07 = 0
    LET g_fao.fao08 = 0
    LET g_fao.fao14 = 0
    LET g_fao.fao15 = 0
    LET g_fao.fao16 = 100     #No:8547
    LET g_fao.fao17 = 0       #No:A099
    LET g_fao.faolegal = g_legal     #FUN-980003 add
 
    LET g_fao_t.* = g_fao.*
    LET g_fao01_t = NULL
    LET g_fao02_t = NULL
    LET g_fao03_t = NULL
    LET g_fao04_t = NULL
    LET g_fao041_t = NULL
    LET g_fao05_t = NULL
    LET g_fao06_t = NULL
    CALL cl_opmsg('a')
 
 
    WHILE TRUE
       CALL i901_i("a")                         # 各欄位輸入
       IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_fao.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
       END IF
       IF cl_null(g_fao.fao01) OR cl_null(g_fao.fao03) OR
          cl_null(g_fao.fao04) OR cl_null(g_fao.fao05) OR
          cl_null(g_fao.fao06) THEN              # KEY 不可空白
          CONTINUE WHILE
       END IF
       INSERT INTO fao_file VALUES(g_fao.*)     # DISK WRITE
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_fao.fao01,SQLCA.sqlcode,0)   #No.FUN-660136
           CALL cl_err3("ins","fao_file",g_fao.fao01,g_fao.fao02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
       ELSE
       #No.TQC-6A0023--begin-- add                                                                                                         
          UPDATE faj_file SET faj109 = g_faj.faj109                                                                                    
           WHERE faj02  = g_fao.fao01                                                                                                  
             AND faj022 = g_fao.fao02                                                                                                  
          IF SQLCA.sqlerrd[3]=0 THEN                                                                                                   
             CALL cl_err3("upd","faj_file",g_fao.fao01,g_fao.fao02,SQLCA.sqlcode,"","",1)                                                                                 
             CONTINUE WHILE                                                                                                            
          END IF                                                                                                                       
       #No.TQC-6A0023--end-- add 
          LET g_fao_t.* = g_fao.*              # 保存上筆資料
          LET g_fao01_t = g_fao.fao01
          LET g_fao02_t = g_fao.fao02
          LET g_fao03_t = g_fao.fao03
          LET g_fao04_t = g_fao.fao04
          LET g_fao041_t = g_fao.fao041
          LET g_fao05_t = g_fao.fao05
          LET g_fao06_t = g_fao.fao06
          SELECT fao01,fao02,fao03,fao04,fao05,fao06,fao041 INTO g_fao.fao01,g_fao.fao02,g_fao.fao03,g_fao.fao04,g_fao.fao05,g_fao.fao06,g_fao.fao041 FROM fao_file
           WHERE fao01  = g_fao.fao01
             AND fao02  = g_fao.fao02
             AND fao03  = g_fao.fao03
             AND fao04  = g_fao.fao04
             AND fao041 = g_fao.fao041
             AND fao05  = g_fao.fao05
             AND fao06  = g_fao.fao06
       END IF
       EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i901_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_fao12       LIKE fad_file.fad03,
            l_n       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
 
   INPUT BY NAME  g_fao.fao041,g_fao.fao01,g_fao.fao02,g_fao.fao03,g_fao.fao04,g_fao.fao05,   #No.TQC-6A0023 move fao041 here
                  g_fao.fao06,g_fao.fao09,g_fao.fao10,g_fao.fao13,g_fao.fao07,
                  #No:A099
                  g_fao.fao08,g_fao.fao14,g_fao.fao15,
                  g_fao.fao17,g_faj.faj109,g_fao.fao16,g_fao.fao11,     #end No:A099   #No.TQC-6A0023 add faj109
               #  g_fao.fao12,g_fao.fao20,g_fao.fao111,g_fao.fao121,g_fao.fao201 WITHOUT DEFAULTS     #No.FUN-680028  #TQC-B20074 add fao20,fao201 #MOD-BC0131 mark
                  g_fao.fao12,g_fao.fao20 WITHOUT DEFAULTS     #No.FUN-680028  #TQC-B20074 add fao20,fao201 #MOD-BC0131 add
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i901_set_entry(p_cmd)
          CALL i901_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
       AFTER FIELD fao01
          IF NOT cl_null(g_fao.fao01) THEN
             SELECT COUNT(*) INTO g_cnt FROM faj_file
              WHERE faj02 = g_fao.fao01
             IF g_cnt = 0 THEN
                CALL cl_err(g_fao.fao01,'afa-902',0)
                NEXT FIELD fao01
             END IF
          END IF
 
       AFTER FIELD fao02
          IF cl_null(g_fao.fao02) THEN
             LET g_fao.fao02 = ' '
          END IF
          CALL i901_chkfaj(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD fao02
          END IF
   
      #No.TQC-740269  --Begin
      AFTER FIELD fao03
        IF NOT cl_null(g_fao.fao03) THEN
           CALL s_get_bookno(g_fao.fao03)
                RETURNING g_flag,g_bookno1,g_bookno2    
           IF g_flag= '1' THEN  
              #CALL cl_err(g_fao.fao03,'aoo-801',1)  #No.TQC-B60363
              CALL cl_err(g_fao.fao03,'aoo-081',1)   #No.TQC-B60363
              NEXT FIELD fao03
           END IF 
        END IF
      #No.TQC-740269  --End
 
       AFTER FIELD fao04  #月
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_fao.fao04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_fan.fan03
            IF g_azm.azm02 = 1 THEN
               IF g_fao.fao04 > 12 OR g_fao.fao04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD fao04
               END IF
            ELSE
               IF g_fao.fao04 > 13 OR g_fao.fao04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD fao04
               END IF
            END IF
         END IF
#          IF NOT cl_null(g_fao.fao04) THEN
#             IF g_fao.fao04 > 13 OR g_fao.fao04 < 1 THEN
#                NEXT FIELD fao04
#             END IF
#          END IF
#No.TQC-720032 -- end --
 
       AFTER FIELD fao05
          IF NOT cl_null(g_fao.fao04) THEN
             IF g_fao.fao05 NOT MATCHES "[123]" THEN
                NEXT FIELD fao05
             END IF
          END IF
 
       AFTER FIELD fao06
          IF NOT cl_null(g_fao.fao06) THEN
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND (g_fao.fao01  != g_fao01_t  OR
                                 g_fao.fao02  != g_fao02_t  OR
                                 g_fao.fao03  != g_fao03_t  OR
                                 g_fao.fao04  != g_fao04_t  OR
                                 g_fao.fao041 != g_fao041_t OR
                                 g_fao.fao05  != g_fao05_t  OR
                                 g_fao.fao06  != g_fao06_t )) THEN
                SELECT COUNT(*) INTO l_n FROM fao_file
                 WHERE fao01  = g_fao.fao01
                   AND fao02  = g_fao.fao02
                   AND fao03  = g_fao.fao03
                   AND fao04  = g_fao.fao04
                   AND fao041 = g_fao.fao041
                   AND fao05  = g_fao.fao05
                   AND fao06  = g_fao.fao06
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_fao.fao01,-239,0)
                   NEXT FIELD fao01
                END IF
             END IF
             CALL i901_chkgem(p_cmd,g_fao.fao06,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fao.fao06,g_errno,0)
                NEXT FIELD fao06
             END IF
          END IF
 
       AFTER FIELD fao10
          IF NOT cl_null(g_fao.fao09) THEN
             IF g_fao.fao10 NOT MATCHES "[XC01234789]" THEN
                NEXT FIELD fao10
             END IF
          END IF
 
       AFTER FIELD fao09
          IF NOT cl_null(g_fao.fao09) THEN
             CALL i901_chkgem(p_cmd,g_fao.fao09,'2')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fao.fao09,g_errno,0)
                NEXT FIELD fao09
             END IF
          END IF
 
       AFTER FIELD fao13
          IF NOT cl_null(g_fao.fao13) THEN
             SELECT COUNT(*) INTO l_n FROM fad_file
              WHERE fad04 = g_fao.fao13
                AND fadacti = 'Y'
             IF l_n = 0 THEN
                CALL cl_err(g_fao.fao13,'afa-342',0)
                NEXT FIELD fao13
             END IF
          END IF
          IF g_fao.fao05 ='1' THEN
             LET g_fao.fao13 = ' '
             DISPLAY BY NAME g_fao.fao13
          ELSE
             IF cl_null(g_fao.fao13) THEN NEXT FIELD fao13 END IF
          END IF
 
       AFTER FIELD fao07
          IF NOT cl_null(g_fao.fao07) THEN
             IF g_fao.fao07 < 0 THEN   #No:8547
                CALL cl_err(g_fao.fao07,'afa-037',0)
                NEXT FIELD fao07
             END IF
          END IF
 
       AFTER FIELD fao08
          IF NOT cl_null(g_fao.fao08) THEN
             IF g_fao.fao08 <= 0 THEN
                CALL cl_err(g_fao.fao08,'afa-037',0)
                NEXT FIELD fao08
             END IF
          END IF
 
       AFTER FIELD fao14
          IF NOT cl_null(g_fao.fao14) THEN
             IF g_fao.fao14 <= 0 THEN
                CALL cl_err(g_fao.fao14,'afa-037',0)
                NEXT FIELD fao14
             END IF
          END IF
 
       AFTER FIELD fao15
          IF NOT cl_null(g_fao.fao15) THEN
             IF g_fao.fao15 <= 0 THEN           #No:A099
                CALL cl_err(g_fao.fao15,'afa-037',0)
                NEXT FIELD fao15
             END IF
          END IF
 
       #No:A099
       AFTER FIELD fao17
          IF NOT cl_null(g_fao.fao17) THEN
             IF g_fao.fao17 <= 0 THEN
                CALL cl_err(g_fao.fao17,'afa-037',0)
                NEXT FIELD fao17
             END IF
          END IF
          CALL i901_set_no_entry(p_cmd)
       #end No:A099
 
      #No.TQC-6A0023-begin--add                                                                                                     
       AFTER FIELD faj109                                                                                                           
          IF NOT cl_null(g_faj.faj109) THEN                                                                                         
             IF g_faj.faj109 < 0 THEN                                                                                               
                CALL cl_err(g_faj.faj109,'afa-037',0)                                                                               
                NEXT FIELD faj109                                                                                                   
             END IF                                                                                                                 
             IF g_faj.faj109 > g_fao.fao15 THEN                                                                                     
                CALL cl_err(g_faj.faj109,'afa-925',0)                                                                               
                NEXT FIELD faj109                                                                                                   
             END IF                                                                                                                 
          END IF                                                                                                                    
      #No.TQC-6A0023-end-- add 
 
       AFTER FIELD fao16
           IF g_fao.fao16 <0  OR g_fao.fao16> 100 THEN      #No:8547
              NEXT FIELD fao16
           END IF
           IF g_fao.fao05 = '1' THEN
              LET g_fao.fao16 = 100          #No:8547
              DISPLAY BY NAME g_fao.fao16
           END IF
 
       AFTER FIELD fao11
           IF NOT cl_null(g_fao.fao11) THEN
              CALL i901_chkaag(p_cmd,g_fao.fao11,'1',g_bookno1)   #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fao.fao11  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fao.fao11 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fao.fao11
                 DISPLAY BY NAME g_fao.fao11  
                 #FUN-B10049--end                   
                 NEXT FIELD fao11
              END IF
           END IF
 
       AFTER FIELD fao12
           IF NOT cl_null(g_fao.fao12) THEN
              CALL i901_chkaag(p_cmd,g_fao.fao12,'2',g_bookno1)   #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fao.fao12  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fao.fao12 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fao.fao12
                 DISPLAY BY NAME g_fao.fao12 
                 #FUN-B10049--end                    
                 NEXT FIELD fao12
              END IF
           END IF
      #No.TQC-B20074  --Begin
      AFTER FIELD fao20
           IF NOT cl_null(g_fao.fao20) THEN
              CALL i901_chkaag(p_cmd,g_fao.fao20,'5',g_bookno1)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_fao.fao20
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fao.fao12 CLIPPED,"%' "
                 CALL cl_create_qry() RETURNING g_fao.fao20
                 DISPLAY BY NAME g_fao.fao20
                 NEXT FIELD fao20
              END IF
           END IF
      #No.TQC-B20074  --End

  #No.MOD-BC0131---begin mark
  #     #No.FUN-680028 --begin
  #     AFTER FIELD fao111
  #         IF NOT cl_null(g_fao.fao111) THEN
  #            CALL i901_chkaag(p_cmd,g_fao.fao111,'3',g_bookno2)   #No.FUN-740026
  #            IF NOT cl_null(g_errno) THEN
  #               CALL cl_err('',g_errno,0)
  #               #FUN-B10049--begin
  #               CALL cl_init_qry_var()                                         
  #               LET g_qryparam.form ="q_aag"                                   
  #               LET g_qryparam.default1 = g_fao.fao111  
  #               LET g_qryparam.construct = 'N'                
  #               LET g_qryparam.arg1 = g_bookno2  
  #               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fao.fao111 CLIPPED,"%' "                                                                        
  #               CALL cl_create_qry() RETURNING g_fao.fao111
  #               DISPLAY BY NAME g_fao.fao111  
  #               #FUN-B10049--end                     
  #               NEXT FIELD fao111
  #            END IF
  #         END IF
  # 
  #     AFTER FIELD fao121
  #         IF NOT cl_null(g_fao.fao121) THEN
  #            CALL i901_chkaag(p_cmd,g_fao.fao121,'4',g_bookno2)  #No.FUN-740026
  #            IF NOT cl_null(g_errno) THEN
  #               CALL cl_err('',g_errno,0) 
  #               #FUN-B10049--begin
  #               CALL cl_init_qry_var()                                         
  #               LET g_qryparam.form ="q_aag"                                   
  #               LET g_qryparam.default1 = g_fao.fao121  
  #               LET g_qryparam.construct = 'N'                
  #               LET g_qryparam.arg1 = g_bookno2  
  #               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fao.fao121 CLIPPED,"%' "                                                                        
  #               CALL cl_create_qry() RETURNING g_fao.fao121
  #               DISPLAY BY NAME g_fao.fao121  
  #               #FUN-B10049--end                   
  #               NEXT FIELD fao121
  #            END IF
  #         END IF
  #     #No.FUN-680028 --end
  #     #No.TQC-B20074  --Begin
  #     AFTER FIELD fao201
  #         IF NOT cl_null(g_fao.fao201) THEN
  #            CALL i901_chkaag(p_cmd,g_fao.fao201,'6',g_bookno2)  #No.FUN-740026
  #            IF NOT cl_null(g_errno) THEN
  #               CALL cl_err('',g_errno,0)
  #               CALL cl_init_qry_var()
  #               LET g_qryparam.form ="q_aag"
  #               LET g_qryparam.default1 = g_fao.fao201
  #               LET g_qryparam.construct = 'N'
  #               LET g_qryparam.arg1 = g_bookno2
  #               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aagacti='Y' AND aag01 LIKE '",g_fao.fao201 CLIPPED,"%' "
  #               CALL cl_create_qry() RETURNING g_fao.fao201
  #               DISPLAY BY NAME g_fao.fao201
  #               NEXT FIELD fao201
  #            END IF
  #         END IF
  #     #No.TQC-B20074  --End
  #No.MOD-BC0131---begin mark
      AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
          IF g_fao.fao02 IS NULL THEN
             LET g_fao.fao02 = ' '
          END IF
          IF g_fao.fao05 ='1' THEN
             LET g_fao.fao13 = ' '
             LET g_fao.fao16 = 100     #No:8547
             DISPLAY BY NAME g_fao.fao13,g_fao.fao16
          END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(fao01)   #財產編號附號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faj"
               LET g_qryparam.default1 = g_fao.fao01
               CALL cl_create_qry() RETURNING g_fao.fao01,g_fao.fao02
               DISPLAY BY NAME g_fao.fao01,g_fao.fao02
               NEXT FIELD fao01
            WHEN INFIELD(fao06)  #部門編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_fao.fao06
               CALL cl_create_qry() RETURNING g_fao.fao06
#               CALL FGL_DIALOG_SETBUFFER( g_fao.fao06 )
               DISPLAY BY NAME g_fao.fao06
               NEXT FIELD fao06
            WHEN INFIELD(fao09)  #被分攤部門
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_fao.fao09
               CALL cl_create_qry() RETURNING g_fao.fao09
#               CALL FGL_DIALOG_SETBUFFER( g_fao.fao09 )
               DISPLAY BY NAME g_fao.fao09
               NEXT FIELD fao09
            WHEN INFIELD(fao11) # 資產會計科目查詢
#              CALL q_aag(2,2,g_fao.fao11,'23','2','') RETURNING g_fao.fao11
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fao.fao11
               LET g_qryparam.arg1 = g_bookno1               #No.FUN-740026
               CALL cl_create_qry() RETURNING g_fao.fao11
#               CALL FGL_DIALOG_SETBUFFER( g_fao.fao11 )
               DISPLAY BY NAME g_fao.fao11
               NEXT FIELD fao11
            WHEN INFIELD(fao12) # 折舊會計科目查詢
#              CALL q_aag(2,2,g_fao.fao12,'23','2','') RETURNING g_fao.fao12
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fao.fao12
               LET g_qryparam.arg1 = g_bookno1               #No.FUN-740026
               CALL cl_create_qry() RETURNING g_fao.fao12
#               CALL FGL_DIALOG_SETBUFFER( g_fao.fao12 )
               DISPLAY BY NAME g_fao.fao12
               NEXT FIELD fao12
            #No.TQC-B20074  --Begin
            WHEN INFIELD(fao20) # 累折會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fao.fao20
               LET g_qryparam.arg1 = g_bookno1
               CALL cl_create_qry() RETURNING g_fao.fao20
               DISPLAY BY NAME g_fao.fao20
               NEXT FIELD fao20
            #No.TQC-B20074  --End
       #MOD-BC0131---begin mark
       #     #No.FUN-680028 --begin
       #     WHEN INFIELD(fao111)
       #        CALL cl_init_qry_var()
       #        LET g_qryparam.form = "q_aag"
       #        LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
       #        LET g_qryparam.default1 = g_fao.fao111
       #        LET g_qryparam.arg1 = g_bookno2               #No.FUN-740026
       #        CALL cl_create_qry() RETURNING g_fao.fao111
       #        DISPLAY BY NAME g_fao.fao111
       #        NEXT FIELD fao111
       #     WHEN INFIELD(fao121)
       #        CALL cl_init_qry_var()
       #        LET g_qryparam.form = "q_aag"
       #        LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
       #        LET g_qryparam.default1 = g_fao.fao121
       #        LET g_qryparam.arg1 = g_bookno2               #No.FUN-740026
       #        CALL cl_create_qry() RETURNING g_fao.fao121
       #        DISPLAY BY NAME g_fao.fao121
       #        NEXT FIELD fao121
       #     #No.FUN-680028 --end
       #     #No.TQC-B20074  --Begin
       #     WHEN INFIELD(fao201)
       #        CALL cl_init_qry_var()
       #        LET g_qryparam.form = "q_aag"
       #        LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
       #        LET g_qryparam.default1 = g_fao.fao201
       #        LET g_qryparam.arg1 = g_bookno2
       #        CALL cl_create_qry() RETURNING g_fao.fao201
       #        DISPLAY BY NAME g_fao.fao201
       #        NEXT FIELD fao201
       #     #No.TQC-B20074  --End
       #MOD-BC0131---begin mark
            WHEN INFIELD(fao13) # 分攤類別查詢
               CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_fad"   #No.TQC-6C0009 mark
               LET g_qryparam.form = "q_fad1"  #No.TQC-6C0009
               LET g_qryparam.default1 = g_fao.fao13
#              CALL cl_create_qry() RETURNING g_fao.fao13,l_fao12   #No.FUN-680028
#              CALL cl_create_qry() RETURNING l_fao12,g_fao.fao13   #No.FUN-680028  #No.TQC-6C0009 mark
               CALL cl_create_qry() RETURNING g_fao.fao13  #No.TQC-6C0009
#               CALL FGL_DIALOG_SETBUFFER( g_fao.fao13 )
               DISPLAY BY NAME g_fao.fao13
               NEXT FIELD fao13
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
 
FUNCTION i901_chkfaj(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
       l_faj06    LIKE faj_file.faj06,
       l_faj061   LIKE faj_file.faj061,
       l_faj43    LIKE faj_file.faj43
 
     LET g_errno = ' '
     SELECT faj06,faj061,faj43 INTO l_faj06,l_faj061,l_faj43
       FROM faj_file
      WHERE faj02 = g_fao.fao01 AND faj022 = g_fao.fao02
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9329'
                                LET l_faj06 = NULL
                                LET l_faj061= NULL
       WHEN l_faj43 matches '[056]'  LET g_errno = 'afa-137'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_faj06  TO FORMONLY.faj06
        DISPLAY l_faj061 TO FORMONLY.faj061
     END IF
END FUNCTION
 
FUNCTION i901_chkgem(p_cmd,p_gem,p_type)
DEFINE
      p_gem      LIKE gem_file.gem01,
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
      p_type     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
      l_gem01    LIKE gem_file.gem01,
      l_gem02    LIKE gem_file.gem02,
      l_gemacti  LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem01,gem02,gemacti INTO l_gem01,l_gem02,l_gemacti
       FROM gem_file
      WHERE gem01 = p_gem
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gem02 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        IF p_type = '1' THEN
           DISPLAY l_gem02 TO FORMONLY.gem02_1
        ELSE
           DISPLAY l_gem02 TO FORMONLY.gem02_2
        END IF
     END IF
END FUNCTION
 
FUNCTION i901_chkaag(p_cmd,p_key,p_type,p_bookno)
DEFINE  l_aagacti  LIKE aag_file.aagacti,
        l_aag02    LIKE aag_file.aag02,
        l_aag03    LIKE aag_file.aag03,
        l_aag07    LIKE aag_file.aag07,
        p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
        p_type     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
        p_key      LIKE aag_file.aag01
DEFINE  p_bookno   LIKE aag_file.aag00          #No.FUN-640026
 
    LET g_errno = " "
    SELECT aag02,aag03,aag07,aagacti
      INTO l_aag02,l_aag03,l_aag07,l_aagacti
      FROM aag_file
     WHERE aag01 = p_key
        AND aag00 = p_bookno           #No.FUN-740026
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       #No.FUN-680028 --begin
       IF p_type = '1' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_1
       END IF
       IF p_type = '2' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_2
       END IF
       IF p_type = '3' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_3
       END IF
       IF p_type = '4' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_4
       END IF
       #No.TQC-B20074  --Begin
       IF p_type = '5' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_5
       END IF
       IF p_type = '6' THEN
          DISPLAY l_aag02 TO FORMONLY.aag02_6
       END IF
       #No.TQC-B20074  --End
       #No.FUN-680028 --end
    END IF
END FUNCTION
 
FUNCTION i901_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_fao.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i901_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i901_count
    FETCH i901_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i901_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fao.fao01,SQLCA.sqlcode,0)
        INITIALIZE g_fao.* TO NULL
    ELSE
        CALL i901_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i901_fetch(p_flfao)
    DEFINE
        p_flfao          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    CASE p_flfao
        WHEN 'N' FETCH NEXT     i901_cs INTO g_fao.*
        WHEN 'P' FETCH PREVIOUS i901_cs INTO g_fao.*
        WHEN 'F' FETCH FIRST    i901_cs INTO g_fao.*
        WHEN 'L' FETCH LAST     i901_cs INTO g_fao.*
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
            FETCH ABSOLUTE g_jump i901_cs INTO g_fao.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fao.fao01,SQLCA.sqlcode,0)
        INITIALIZE g_fao.* TO NULL  #TQC-6B0105
        INITIALIZE g_fao.* TO NULL #TQC-6B0105
        RETURN
    ELSE
      CASE p_flfao
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_fao.* FROM fao_file    # 重讀DB,因TEMP有不被更新特性
       WHERE fao01 = g_fao.fao01 AND fao02 = g_fao.fao02 AND fao03 = g_fao.fao03 AND fao04 = g_fao.fao04 AND fao05 = g_fao.fao05 AND fao06 = g_fao.fao06 AND fao041 = g_fao.fao041
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fao.fao01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fao_file",g_fao.fao01,g_fao.fao02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        CALL i901_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i901_show()
   #No.TQC-6A0023--begin-- add                                                                                                      
   SELECT faj109 INTO g_faj.faj109                                                                                                  
     FROM faj_file                                                                                                                  
    WHERE faj02  = g_fao.fao01                                                                                                      
      AND faj022 = g_fao.fao02                                                                                                      
   LET g_faj_t.faj109 = g_faj.faj109                                                                                                
   #No.TQC-6A0023--end-- add 
 
   LET g_fao_t.* = g_fao.*
   DISPLAY BY NAME g_fao.fao01,g_fao.fao02,g_fao.fao03,g_fao.fao04,g_fao.fao041,
                   g_fao.fao05,g_fao.fao06,g_fao.fao09,g_fao.fao10,g_fao.fao13,
                   g_fao.fao07,g_fao.fao08,g_fao.fao14,g_fao.fao15,g_fao.fao16,
                   g_fao.fao11,g_fao.fao12,g_fao.fao20, #g_fao.fao111,g_fao.fao121, #TQC-B20074 add fao20 #MOD-BC0131 mark fao111,fao121
             #     g_fao.fao201,g_fao.fao17,g_faj.faj109    #No:A099     #No.FUN-680028  #No.TQC-6A0023 add faj109  #TQC-B20074 add fao201 #MOD-BC0131 mark
                   g_fao.fao17,g_faj.faj109    #No:A099     #No.FUN-680028  #No.TQC-6A0023 add faj109  #TQC-B20074 add fao201 #MOD-BC0131 add
#No.FUN-740026--begin--
             CALL s_get_bookno(g_fao.fao03)
                  RETURNING g_flag,g_bookno1,g_bookno2    
             IF g_flag= '1' THEN  
                #CALL cl_err(g_fao.fao03,'aoo-801',1)  #No.TQC-B60363
                CALL cl_err(g_fao.fao03,'aoo-081',1)   #No.TQC-B60363
             END IF 
#No.FUN-740026--end-
 
   CALL i901_chkaag('d',g_fao.fao11,'1',g_bookno1)         #No.FUN-740026
   CALL i901_chkaag('d',g_fao.fao12,'2',g_bookno1)         #No.FUN-740026
   CALL i901_chkaag('d',g_fao.fao20,'5',g_bookno1)         #No.TQC-B20074
#  IF g_aza.aza63 = 'Y' THEN     #No.FUN-680028
#MOD-BC0131---begin mark
#   IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
#      CALL i901_chkaag('d',g_fao.fao111,'3',g_bookno2)     #No.FUN-680028  #No.FUN-740026
#      CALL i901_chkaag('d',g_fao.fao121,'4',g_bookno2)     #No.FUN-680028  #No.FUN-740026
#      CALL i901_chkaag('d',g_fao.fao201,'6',g_bookno2)     #No.TQC-B20074
#   END IF     #No.FUN-680028
#MOD-BC0131---begin mark   
   CALL i901_chkgem('d',g_fao.fao06,'1')
   CALL i901_chkgem('d',g_fao.fao09,'2')
   CALL i901_chkfaj('d')
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i901_u()
    IF g_fao.fao01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fao.fao041 <> '0' THEN
       CALL cl_err(g_fao.fao01,'afa-136',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fao01_t = g_fao.fao01
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i901_cl USING g_fao.fao01,g_fao.fao02,g_fao.fao03,g_fao.fao04,g_fao.fao05,g_fao.fao06,g_fao.fao041
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 1)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_fao.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fao.fao01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i901_show()                          # 顯示最新資料
    LET g_fao_t.* = g_fao.*
    LET g_faj_t.faj109 = g_faj.faj109         #No.TQC-6A0023 add 
    LET g_fao01_t = g_fao.fao01
    LET g_fao02_t = g_fao.fao02
    LET g_fao03_t = g_fao.fao03
    LET g_fao04_t = g_fao.fao04
    LET g_fao041_t= g_fao.fao041
    LET g_fao05_t = g_fao.fao05
    LET g_fao06_t = g_fao.fao06
    LET g_faj109_t= g_faj.faj109              #No.TQC-6A0023 add
    WHILE TRUE
       CALL i901_i("u")                      # 欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_fao.*=g_fao_t.*
           LET g_faj.faj109=g_faj_t.faj109    #No.TQC-6A0023 add 
           CALL i901_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       IF cl_null(g_fao.fao01) THEN
          CONTINUE WHILE
       END IF
       UPDATE fao_file SET fao_file.* = g_fao.*    # 更新DB
  WHERE fao01 = g_fao01_t AND fao02 = g_fao02_t AND fao03 = g_fao03_t AND fao04 = g_fao04_t AND fao05 = g_fao05_t AND fao06 = g_fao06_t AND fao041 = g_fao041_t
       IF SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err(g_fao.fao01,SQLCA.sqlcode,0)   #No.FUN-660136
          CALL cl_err3("upd","fao_file",g_fao.fao01,g_fao.fao02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          CONTINUE WHILE
       END IF
#No.TQC-6A0023--begin-- add                                                                                                         
       UPDATE faj_file SET faj109 = g_faj.faj109                                                                                    
        WHERE faj02  = g_fao.fao01                                                                                                  
          AND faj022 = g_fao.fao02                                                                                                  
       EXIT WHILE                                                                                                                   
       IF SQLCA.sqlerrd[3]=0 THEN                                                                                                   
          CALL cl_err3("upd","faj_file",g_fao.fao01,g_fao.fao02,SQLCA.sqlcode,"","",1)                                                                                 
          CONTINUE WHILE                                                                                                            
       END IF                                                                                                                       
#No.TQC-6A0023--end-- add 
     #  EXIT WHILE    #No.TQC-6A0023 mark 
    END WHILE
    CLOSE i901_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION i901_r()
    IF g_fao.fao01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fao.fao041 <> '0' THEN
       CALL cl_err(g_fao.fao01,'afa-136',0)
       RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i901_cl USING g_fao.fao01,g_fao.fao02,g_fao.fao03,g_fao.fao04,g_fao.fao05,g_fao.fao06,g_fao.fao041
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 0)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_fao.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fao.fao01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i901_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fao01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fao.fao01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "fao02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_fao.fao02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "fao03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_fao.fao03      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "fao04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_fao.fao04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM fao_file WHERE fao01  = g_fao.fao01
                              AND fao02  = g_fao.fao02
                              AND fao03  = g_fao.fao03
                              AND fao04  = g_fao.fao04
                              AND fao041 = g_fao.fao041
                              AND fao05  = g_fao.fao05
                              AND fao06  = g_fao.fao06
       IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660136
           CALL cl_err3("del","fao_file",g_fao.fao01,g_fao.fao02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       ELSE
          CLEAR FORM
          OPEN i901_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i901_cs
             CLOSE i901_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i901_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i901_cs
             CLOSE i901_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i901_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i901_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i901_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i901_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION i901_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("fao01",TRUE)
     END IF
     #No:A099
     IF INFIELD(fao17) OR (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("fao17",TRUE)
     END IF
     #end No:A099
 
END FUNCTION
 
FUNCTION i901_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("fao01",FALSE)
    END IF
    #No:A099
    IF INFIELD(fao17) OR (NOT g_before_input_done) THEN
       IF g_aza.aza26 != '2' THEN
          CALL cl_set_comp_entry("fao17",FALSE)
       END IF
    END IF
    #end No:A099
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
