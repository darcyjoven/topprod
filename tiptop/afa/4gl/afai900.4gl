# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai900.4gl
# Descriptions...: 資產折舊費用開帳作業-財簽
# Date & Author..: 2003/09/18 By Winny
# Modify.........: No.8547 03/10/22 By Kitty 1.折舊金額在開帳時可以為0 2.分攤比率改為可以輸>0 < 100
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-470513 04/08/11 By Nicola 判斷欄位空白的部份應從per加上not null
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.MOD-4C0144 04/12/22 By Nicola cl_doc參數不足
# Modify.........: No.MOD-660007 06/06/06 By Smapmin 開放減值準備為可輸入
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/24 By zhuying 多套帳修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.TQC-690099 06/09/26 By Tracy 增加faj108一個欄位  
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i900_q()一開始應清空g_fan.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6A0023 06/10/30 By cl    處理無法修改的bug
# Modify.........: No.TQC-6C0009 06/12/06 By Rayven 錄入時分攤類型開窗選擇的是資產會計科目而不是分攤類型
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740026 07/04/11 By atsea  會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7C0175 07/12/25 By Smapmin 已提列減值準備可能為零
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-A30029 10/03/25 By Summer 增加fan19 欄位,不可維護.
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤
# Modify.........: No.TQC-B20043 11/02/15 By yinhy 增加欄位"累折科目"及"累折科目二"
# Modify.........: No.FUN-AB0088 11/04/08 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40004 11/04/14 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60363 11/06/29 By yinhy 錯誤代碼'aoo-801'應改為'aoo-081'
# Modify.........: No.MOD-BC0131 12/01/13 By Sakura 移除fan201

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fan       RECORD LIKE fan_file.*,
       g_fan_t     RECORD LIKE fan_file.*,  #備份舊值
       g_fan01_t   LIKE fan_file.fan01,     #Key值備份
       g_fan02_t   LIKE fan_file.fan02,
       g_fan03_t   LIKE fan_file.fan03,
       g_fan04_t   LIKE fan_file.fan04,
       g_fan041_t  LIKE fan_file.fan041,
       g_fan05_t   LIKE fan_file.fan05,
       g_fan06_t   LIKE fan_file.fan06,
       g_wc        STRING,                  #儲存 user 的查詢條件
       g_sql       STRING                   #組 sql 用
 
DEFINE g_faj       RECORD                   #No.TQC-690099                                                                          
                     faj108 LIKE faj_file.faj108                                                                                    
                   END RECORD                                                                                                       
DEFINE g_faj_t     RECORD                   #No.TQC-690099                                                                          
                     faj108 LIKE faj_file.faj108                                                                                    
                   END RECORD                                                                                                       
DEFINE g_faj108_t  LIKE faj_file.faj108     #No.TQC-690099                  
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
#        l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
 
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
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
   INITIALIZE g_fan.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM fan_file WHERE fan01 = ? AND fan02 = ? AND fan03 = ? AND fan04 = ? AND fan05 = ? AND fan06 = ? AND fan041 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i900_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i900_w AT p_row,p_col
     WITH FORM "afa/42f/afai900"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#FUN-680028----begin-----
 ##-----No:FUN-AB0088 Mark-----
 # IF g_aza.aza63 = 'Y' THEN
 #    CALL cl_set_comp_visible("fan111,fan121,fan201,aag02_3,aag02_4,aag02_6",TRUE)  #TQC-B20043 add fan201,aag02_6
 # ELSE
 #    CALL cl_set_comp_visible("fan111,fan121,fan201,aag02_3,aag02_4,aag02_6",FALSE) #TQC-B20043 add fan201,aag02_6
 # END IF
 ##-----No:FUN-AB0088 Mark END-----
#FUN-680028-----end------
   LET g_action_choice = ""
   CALL i900_menu()
 
   CLOSE WINDOW i900_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION i900_curs()
DEFINE ls STRING
 
    CLEAR FORM
   INITIALIZE g_fan.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON fan041,fan01,fan02,fan03,fan04,fan05,
                              fan06,fan09,fan10,fan13,fan07,fan08,
                              fan14,fan15,fan17,fan16,fan11,fan12,  #No:A099
                            # fan111,fan121,                        #No:FUN-AB0088 Mark  #FUN-680028
                              fan19,fan20 #,fan201                    #NO.CHI-A30029 #TQC-B20043 add fan20,fan201 #MOD-BC0131 mark fan201       
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fan01)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fan.fan01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan01
                 NEXT FIELD fan01
              WHEN INFIELD(fan06)  #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fan.fan06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan06
                 NEXT FIELD fan06
              WHEN INFIELD(fan09)  #被分攤部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fan.fan09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan09
                 NEXT FIELD fan09
              WHEN INFIELD(fan11) # 資產會計科目查詢
#                CALL q_aag(2,2,g_fan.fan11,'23','2','') RETURNING g_fan.fan11
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fan.fan11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan11
                 NEXT FIELD fan11
              WHEN INFIELD(fan12) # 折舊會計科目查詢
#                CALL q_aag(2,2,g_fan.fan12,'23','2','') RETURNING g_fan.fan12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fan.fan12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan12
                 NEXT FIELD fan12
              #No.TQC-B20043  --Begin
              WHEN INFIELD(fan20) # 資產會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fan.fan20
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan20
                 NEXT FIELD fan20
              #No.TQC-B20043  --Begin
       #FUN-680028----begin-----
           ##-----No:FUN-AB0088 Mark-----
           #  WHEN INFIELD(fan111)
           #     CALL cl_init_qry_var()
           #     LET g_qryparam.state = "c"
           #     LET g_qryparam.form = "q_aag"
           #     LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
           #     LET g_qryparam.default1 = g_fan.fan111
           #     CALL cl_create_qry() RETURNING g_qryparam.multiret
           #     DISPLAY g_qryparam.multiret TO fan111
           #     NEXT FIELD fan111
           #  WHEN INFIELD(fan121)
           #     CALL cl_init_qry_var()
           #     LET g_qryparam.state = "c"
           #     LET g_qryparam.form = "q_aag"
           #     LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
           #     LET g_qryparam.default1 = g_fan.fan121
           #     CALL cl_create_qry() RETURNING g_qryparam.multiret
           #     DISPLAY g_qryparam.multiret TO fan121
           #     NEXT FIELD fan121
           ##-----No:FUN-AB0088 Mark END-----
        #FUN-680028-----end------
            #MOD-BC0131---begin mark
            #  #No.TQC-B20043  --Begin
            #  WHEN INFIELD(fan201)
            #     CALL cl_init_qry_var()
            #     LET g_qryparam.state = "c"
            #     LET g_qryparam.form = "q_aag"
            #     LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
            #     LET g_qryparam.default1 = g_fan.fan201
            #     CALL cl_create_qry() RETURNING g_qryparam.multiret
            #     DISPLAY g_qryparam.multiret TO fan201
            #     NEXT FIELD fan201
            #  #No.TQC-B20043  --End
            #MOD-BC0131---end mark
              WHEN INFIELD(fan13) # 分攤類別查詢
                 CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_fad"   #No.TQC-6C0009 mark
                 LET g_qryparam.form = "q_fad1"  #No.TQC-6C0009
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_fan.fan13
                 LET g_qryparam.multiret_index   = '2'   #No.FUN-680028
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan13
                 NEXT FIELD fan13
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
 
    LET g_sql = "SELECT fan_file.* FROM fan_file ",  #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY fan01"
    PREPARE i900_prepare FROM g_sql                   # RUNTIME 編譯
    DECLARE i900_cs                                 # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i900_prepare
 
DISPLAY "g_sql:",g_sql
 
 
    LET g_sql="SELECT COUNT(*) FROM fan_file WHERE ",g_wc CLIPPED
    PREPARE i900_cntpre FROM g_sql
    DECLARE i900_count CURSOR FOR i900_cntpre
 
END FUNCTION
 
FUNCTION i900_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i900_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i900_q()
            END IF
        ON ACTION next
            CALL i900_fetch('N')
        ON ACTION previous
            CALL i900_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i900_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i900_r()
            END IF
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_fan.fan01 IS NOT NULL THEN
                 #-----No.MOD-4C0144-----
                LET g_doc.column1 = "fan01|fan05"
                LET g_doc.value1 = g_fan.fan01 CLIPPED, "|", g_fan.fan05
                 #-----No.MOD-4C0029-----
                LET g_doc.column2 = "fan02|fan06"
                LET g_doc.value2 = g_fan.fan02 CLIPPED, "|", g_fan.fan06
                 #-----No.MOD-4C0144 END-----
                LET g_doc.column3 = "fan03"
                LET g_doc.value3 = g_fan.fan03
                LET g_doc.column4 = "fan04"
                LET g_doc.value4 = g_fan.fan04
                LET g_doc.column5 = "fan041"
                LET g_doc.value5 = g_fan.fan041
               #LET g_doc.column6 = "fan05"
               #LET g_doc.value6 = g_fan.fan05
               #LET g_doc.column7 = "fan06"
               #LET g_doc.value7 = g_fan.fan06
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
            CALL i900_fetch('/')
        ON ACTION first
            CALL i900_fetch('F')
        ON ACTION last
            CALL i900_fetch('L')
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
    CLOSE i900_cs
END FUNCTION
 
FUNCTION i900_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_fan.* LIKE fan_file.*
    LET g_fan01_t = NULL
    LET g_wc = NULL
    LET g_fan.fan041 = '0'
    LET g_fan.fan03  = YEAR(g_today)
    LET g_fan.fan04  = MONTH(g_today)
    LET g_fan.fan05 = '1'
    LET g_fan.fan10 = '2'
    LET g_fan.fan07 = 0
    LET g_fan.fan08 = 0
    LET g_fan.fan14 = 0
    LET g_fan.fan15 = 0
    LET g_fan.fan16 = 100     #No:8547
    LET g_fan.fan17 = 0       #No:A099
    LET g_fan.fanlegal = g_legal   #FUN-980003 add
 
    LET g_fan_t.* = g_fan.*
    LET g_fan01_t = NULL
    LET g_fan02_t = NULL
    LET g_fan03_t = NULL
    LET g_fan04_t = NULL
    LET g_fan041_t = NULL
    LET g_fan05_t = NULL
    LET g_fan06_t = NULL
    CALL cl_opmsg('a')
#No.FUN-740026--begin--
 
             CALL s_get_bookno(g_fan.fan03)
                  RETURNING g_flag,g_bookno1,g_bookno2    
             IF g_flag= '1' THEN  #
                #CALL cl_err(g_fan.fan03,'aoo-801',1)   #No.TQC-B60363
                CALL cl_err(g_fan.fan03,'aoo-081',1)    #No.TQC-B60363
             END IF 
 
#No.FUN-740026--end--
 
 
    WHILE TRUE
       CALL i900_i("a")                         # 各欄位輸入
       IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_fan.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
       END IF
       IF cl_null(g_fan.fan01) OR cl_null(g_fan.fan03) OR
          cl_null(g_fan.fan04) OR cl_null(g_fan.fan05) OR
          cl_null(g_fan.fan06) THEN              # KEY 不可空白
          CONTINUE WHILE
       END IF
       INSERT INTO fan_file VALUES(g_fan.*)     # DISK WRITE
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_fan.fan01,SQLCA.sqlcode,0)   #No.FUN-660136
           CALL cl_err3("ins","fan_file",g_fan.fan01,g_fan.fan02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
       ELSE
          LET g_fan_t.* = g_fan.*              # 保存上筆資料
          LET g_fan01_t = g_fan.fan01
          LET g_fan02_t = g_fan.fan02
          LET g_fan03_t = g_fan.fan03
          LET g_fan04_t = g_fan.fan04
          LET g_fan041_t = g_fan.fan041
          LET g_fan05_t = g_fan.fan05
          LET g_fan06_t = g_fan.fan06
          SELECT fan01,fan02,fan03,fan04,fan05,fan06,fan041 INTO g_fan.fan01,g_fan.fan02,g_fan.fan03,g_fan.fan04,g_fan.fan05,g_fan.fan06,g_fan.fan041 FROM fan_file
           WHERE fan01  = g_fan.fan01
             AND fan02  = g_fan.fan02
             AND fan03  = g_fan.fan03
             AND fan04  = g_fan.fan04
             AND fan041 = g_fan.fan041
             AND fan05  = g_fan.fan05
             AND fan06  = g_fan.fan06
       END IF
       EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i900_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_fan12       LIKE fad_file.fad03,
            l_n       LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE  l_aag05     LIKE aag_file.aag05                  #No.FUN-B40004
 
 
   INPUT BY NAME  g_fan.fan041,g_fan.fan01,g_fan.fan02,g_fan.fan03,g_fan.fan04,g_fan.fan05,  #No.TQC-6A0023 move fao041 here
                  g_fan.fan06,g_fan.fan09,g_fan.fan10,g_fan.fan13,g_fan.fan07,
                  #No:A099
                  g_fan.fan08,g_fan.fan14,g_fan.fan15,
                  g_fan.fan17,g_faj.faj108,g_fan.fan16,g_fan.fan11,    #end No:A099 #No.TQC-690099 add faj108
               #  g_fan.fan12,g_fan.fan111,g_fan.fan121,g_fan.fan19,   #No:FUN-AB0088  #FUN-680028 #NO.CHI-A30029 add fan19
                  g_fan.fan12,g_fan.fan19, 
               #  g_fan.fan20,g_fan.fan201 WITHOUT DEFAULTS            #TQC-B20043 #MOD-BC0131 mark fan201
                  g_fan.fan20 WITHOUT DEFAULTS            #TQC-B20043 #MOD-BC0131 mark fan201
                  
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i900_set_entry(p_cmd)
          CALL i900_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
       AFTER FIELD fan01
          IF NOT cl_null(g_fan.fan01) THEN
             SELECT COUNT(*) INTO g_cnt FROM faj_file
              WHERE faj02 = g_fan.fan01
             IF g_cnt = 0 THEN
                CALL cl_err(g_fan.fan01,'afa-902',0)
                NEXT FIELD fan01
             END IF
          END IF
 
       AFTER FIELD fan02
          IF cl_null(g_fan.fan02) THEN
             LET g_fan.fan02 = ' '
          END IF
          CALL i900_chkfaj(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD fan02
          END IF
 
       AFTER FIELD fan04  #月
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_fan.fan04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_fan.fan03
            IF g_azm.azm02 = 1 THEN
               IF g_fan.fan04 > 12 OR g_fan.fan04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD fan04
               END IF
            ELSE
               IF g_fan.fan04 > 13 OR g_fan.fan04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD fan04
               END IF
            END IF
         END IF
#          IF NOT cl_null(g_fan.fan04) THEN
#             IF g_fan.fan04 > 13 OR g_fan.fan04 < 1 THEN
#                NEXT FIELD fan04
#             END IF
#          END IF
#No.TQC-720032 -- end --
 
       AFTER FIELD fan05
          IF NOT cl_null(g_fan.fan04) THEN
             IF g_fan.fan05 NOT MATCHES "[123]" THEN
                NEXT FIELD fan05
             END IF
          END IF
 
       AFTER FIELD fan06
          IF NOT cl_null(g_fan.fan06) THEN
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND (g_fan.fan01  != g_fan01_t  OR
                                 g_fan.fan02  != g_fan02_t  OR
                                 g_fan.fan03  != g_fan03_t  OR
                                 g_fan.fan04  != g_fan04_t  OR
                                 g_fan.fan041 != g_fan041_t OR
                                 g_fan.fan05  != g_fan05_t  OR
                                 g_fan.fan06  != g_fan06_t )) THEN
                SELECT COUNT(*) INTO l_n FROM fan_file
                 WHERE fan01  = g_fan.fan01
                   AND fan02  = g_fan.fan02
                   AND fan03  = g_fan.fan03
                   AND fan04  = g_fan.fan04
                   AND fan041 = g_fan.fan041
                   AND fan05  = g_fan.fan05
                   AND fan06  = g_fan.fan06
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_fan.fan01,-239,0)
                   NEXT FIELD fan01
                END IF
             END IF
             CALL i900_chkgem(p_cmd,g_fan.fan06,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fan.fan06,g_errno,0)
                NEXT FIELD fan06
             END IF
          END IF
 
       AFTER FIELD fan10
          IF NOT cl_null(g_fan.fan09) THEN
             IF g_fan.fan10 NOT MATCHES "[XC01234789]" THEN
                NEXT FIELD fan10
             END IF
          END IF
 
       AFTER FIELD fan09
          IF NOT cl_null(g_fan.fan09) THEN
             CALL i900_chkgem(p_cmd,g_fan.fan09,'2')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fan.fan09,g_errno,0)
                NEXT FIELD fan09
             END IF
          END IF
 
       AFTER FIELD fan13
          IF NOT cl_null(g_fan.fan13) THEN
             SELECT COUNT(*) INTO l_n FROM fad_file
              WHERE fad04 = g_fan.fan13
                AND fadacti = 'Y'
                AND fad07='1'     #No:FUN-AB0088
             IF l_n = 0 THEN
                CALL cl_err(g_fan.fan13,'afa-342',0)
                NEXT FIELD fan13
             END IF
          END IF
          IF g_fan.fan05 ='1' THEN
             LET g_fan.fan13 = ' '
             DISPLAY BY NAME g_fan.fan13
          ELSE
             IF cl_null(g_fan.fan13) THEN NEXT FIELD fan13 END IF
          END IF
 
       AFTER FIELD fan07
          IF NOT cl_null(g_fan.fan07) THEN
             IF g_fan.fan07 < 0 THEN   #No:8547
                CALL cl_err(g_fan.fan07,'afa-037',0)
                NEXT FIELD fan07
             END IF
          END IF
 
       AFTER FIELD fan08
          IF NOT cl_null(g_fan.fan08) THEN
             IF g_fan.fan08 <= 0 THEN
                CALL cl_err(g_fan.fan08,'afa-037',0)
                NEXT FIELD fan08
             END IF
          END IF
 
       AFTER FIELD fan14
          IF NOT cl_null(g_fan.fan14) THEN
             IF g_fan.fan14 <= 0 THEN
                CALL cl_err(g_fan.fan14,'afa-037',0)
                NEXT FIELD fan14
             END IF
          END IF
 
       AFTER FIELD fan15
          IF NOT cl_null(g_fan.fan15) THEN
             IF g_fan.fan15 <= 0 THEN              #No:A099
                CALL cl_err(g_fan.fan15,'afa-037',0)
                NEXT FIELD fan15
             END IF
          END IF
 
       #No:A099
       AFTER FIELD fan17
          IF NOT cl_null(g_fan.fan17) THEN
             #IF g_fan.fan17 <= 0 THEN   #MOD-7C0175
             IF g_fan.fan17 < 0 THEN   #MOD-7C0175
                #CALL cl_err(g_fan.fan17,'afa-037',0)   #MOD-7C0175
                CALL cl_err(g_fan.fan17,'mfg5034',0)   #MOD-7C0175
                NEXT FIELD fan17
             END IF
          END IF
          CALL i900_set_no_entry(p_cmd)
       #end No:A099
 
#No.TQC-690099  --start--                                                                                                           
       AFTER FIELD faj108                                                                                                           
          IF NOT cl_null(g_faj.faj108) THEN                                                                                         
             IF g_faj.faj108 < 0 THEN                                                                                               
                CALL cl_err(g_faj.faj108,'afa-037',0)                                                                               
                NEXT FIELD faj108                                                                                                   
             END IF                                                                                                                 
             IF g_faj.faj108 > g_fan.fan15 THEN                                                                                     
                CALL cl_err(g_faj.faj108,'afa-925',0)                                                                               
                NEXT FIELD faj108                                                                                                   
             END IF                                                                                                                 
          END IF                                                                                                                    
#No.TQC-690099  --end--                
 
       AFTER FIELD fan16
           IF g_fan.fan16 <0  OR g_fan.fan16> 100 THEN      #No:8547
              NEXT FIELD fan16
           END IF
           IF g_fan.fan05 = '1' THEN
              LET g_fan.fan16 = 100          #No:8547
              DISPLAY BY NAME g_fan.fan16
           END IF
 
       AFTER FIELD fan11
           IF NOT cl_null(g_fan.fan11) THEN
#              CALL i900_chkaag(p_cmd,g_fan.fan11,'1')
              CALL i900_chkaag(p_cmd,g_fan.fan11,'1',g_bookno1)    #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #No.FUN-B10053  --Begin
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fan.fan11
                 LET g_qryparam.arg1 = g_bookno1 
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fan.fan11 CLIPPED,"%'"                
                 CALL cl_create_qry() RETURNING g_fan.fan11
                 DISPLAY BY NAME g_fan.fan11
                 #No.FUN-B10053  --End
                 NEXT FIELD fan11
              END IF
              #No.FUN-B40004  --Begin
              IF NOT cl_null(g_fan.fan06) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_fan.fan11
                    AND aag00 = g_bookno1
                 IF l_aag05 = 'Y' THEN
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_fan.fan11,g_fan.fan06,g_bookno1)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fan.fan11,g_errno,0)
                    DISPLAY BY NAME g_fan.fan11
                    NEXT FIELD fan11
                 END IF
              END IF
              #No.FUN-B40004  --End
           END IF
 
       AFTER FIELD fan12
           IF NOT cl_null(g_fan.fan12) THEN
#              CALL i900_chkaag(p_cmd,g_fan.fan12,'2')
              CALL i900_chkaag(p_cmd,g_fan.fan12,'2',g_bookno1)    #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 #No.FUN-B10053  --Begin 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fan.fan12
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fan.fan12 CLIPPED,"%'"                 
                 CALL cl_create_qry() RETURNING g_fan.fan12
                 DISPLAY BY NAME g_fan.fan12
                 #No.FUN-B10053  --End
                 NEXT FIELD fan12
              END IF
              #No.FUN-B40004  --Begin
              IF NOT cl_null(g_fan.fan06) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_fan.fan12
                    AND aag00 = g_bookno1
                 IF l_aag05 = 'Y' THEN
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_fan.fan12,g_fan.fan06,g_bookno1)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fan.fan12,g_errno,0)
                    DISPLAY BY NAME g_fan.fan12
                    NEXT FIELD fan12
                 END IF
              END IF
              #No.FUN-B40004  --End
           END IF
#FUN-680028-----begin----
        #No.TQC-B20043  --Begin
        AFTER FIELD fan20
            IF NOT cl_null(g_fan.fan20) THEN
              CALL i900_chkaag(p_cmd,g_fan.fan20,'3',g_bookno1)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fan.fan20
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fan.fan20 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fan.fan20
                 DISPLAY BY NAME g_fan.fan20
                 NEXT FIELD fan20
               END IF
               #No.FUN-B40004  --Begin
               IF NOT cl_null(g_fan.fan06) THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_fan.fan20
                    AND aag00 = g_bookno1
                 IF l_aag05 = 'Y' THEN
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       LET g_errno = ' '
                       CALL s_chkdept(g_aaz.aaz72,g_fan.fan20,g_fan.fan06,g_bookno1)
                            RETURNING g_errno
                    END IF
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fan.fan20,g_errno,0)
                    DISPLAY BY NAME g_fan.fan20
                    NEXT FIELD fan20
                 END IF
              END IF
              #No.FUN-B40004  --End
            END IF
        #No.TQC-B20043  --End
    ##-----No:FUN-AB0088 Mark-----
    #  AFTER FIELD fan111
    #      IF NOT cl_null(g_fan.fan111) THEN
    #         CALL i900_chkaag1(p_cmd,g_fan.fan111,'1',g_bookno2)  #No.FUN-740026
    #         IF NOT cl_null(g_errno) THEN
    #            CALL cl_err('',g_errno,0) 
    #            #No.FUN-B10053  --Begin 
    #            CALL cl_init_qry_var()
    #            LET g_qryparam.form = "q_aag"
    #            LET g_qryparam.construct = 'N'
    #            LET g_qryparam.default1 = g_fan.fan111
    #            LET g_qryparam.arg1 = g_bookno2
    #            LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fan.fan111 CLIPPED,"%'" 
    #            CALL cl_create_qry() RETURNING g_fan.fan111
    #            DISPLAY BY NAME g_fan.fan111
    #            #No.FUN-B10053  --End
    #            NEXT FIELD fan111
    #         END IF
    #      END IF
    # 
    #  AFTER FIELD fan121
    #      IF NOT cl_null(g_fan.fan121) THEN
    #         CALL i900_chkaag1(p_cmd,g_fan.fan121,'2',g_bookno2)  #No.FUN-740026
    #         IF NOT cl_null(g_errno) THEN
    #            CALL cl_err('',g_errno,0) 
    #            #No.FUN-B10053  --Begin
    #            CALL cl_init_qry_var()
    #            LET g_qryparam.form = "q_aag"
    #            LET g_qryparam.construct = 'N'
    #            LET g_qryparam.default1 = g_fan.fan121                                                                                
    #            LET g_qryparam.arg1 = g_bookno2
    #            LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fan.fan121 CLIPPED,"%'"                  
    #            CALL cl_create_qry() RETURNING g_fan.fan121                                                                           
    #            DISPLAY BY NAME g_fan.fan121 
    #            #No.FUN-B10053  --End
    #            NEXT FIELD fan121
    #         END IF
    #      END IF
    ##-----No:FUN-AB0088 Mark END-----
#FUN-680028-----end------
       #MOD-BC0131---begin mark
       ##No.TQC-B20043  --Begin
       # AFTER FIELD fan201
       #    IF NOT cl_null(g_fan.fan201) THEN
       #       CALL i900_chkaag1(p_cmd,g_fan.fan201,'3',g_bookno2)
       #       IF NOT cl_null(g_errno) THEN
       #          CALL cl_err('',g_errno,0)
       #          CALL cl_init_qry_var()
       #          LET g_qryparam.form = "q_aag"
       #          LET g_qryparam.construct = 'N'
       #          LET g_qryparam.default1 = g_fan.fan201
       #          LET g_qryparam.arg1 = g_bookno2
       #          LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fan.fan201 CLIPPED,"%'"
       #          CALL cl_create_qry() RETURNING g_fan.fan201
       #          DISPLAY BY NAME g_fan.fan201
       #          NEXT FIELD fan201
       #       END IF
       #       #No.FUN-B40004  --Begin
       #
       #        IF NOT cl_null(g_fan.fan06) THEN
       #          LET l_aag05=''
       #          SELECT aag05 INTO l_aag05 FROM aag_file
       #           WHERE aag01 = g_fan.fan201
       #             AND aag00 = g_bookno2
       #          IF l_aag05 = 'Y' THEN
       #             #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
       #             IF g_aaz.aaz90 !='Y' THEN
       #                LET g_errno = ' '
       #                CALL s_chkdept(g_aaz.aaz72,g_fan.fan201,g_fan.fan06,g_bookno2)
       #                     RETURNING g_errno
       #             END IF
       #          END IF
       #          IF NOT cl_null(g_errno) THEN
       #             CALL cl_err(g_fan.fan201,g_errno,0)
       #             DISPLAY BY NAME g_fan.fan201
       #             NEXT FIELD fan201
       #          END IF
       #       END IF
       #       #No.FUN-B40004  --End
       #    END IF
       # #No.TQC-B20043  --End
       #MOD-BC0131---end mark 
      AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
          IF g_fan.fan02 IS NULL THEN
             LET g_fan.fan02 = ' '
          END IF
          IF g_fan.fan05 ='1' THEN
             LET g_fan.fan13 = ' '
             LET g_fan.fan16 = 100     #No:8547
             DISPLAY BY NAME g_fan.fan13,g_fan.fan16
          END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(fan01)   #財產編號附號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faj"
               LET g_qryparam.default1 = g_fan.fan01
               CALL cl_create_qry() RETURNING g_fan.fan01,g_fan.fan02
               DISPLAY BY NAME g_fan.fan01,g_fan.fan02
               NEXT FIELD fan01
            WHEN INFIELD(fan06)  #部門編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_fan.fan06
               CALL cl_create_qry() RETURNING g_fan.fan06
#               CALL FGL_DIALOG_SETBUFFER( g_fan.fan06 )
               DISPLAY BY NAME g_fan.fan06
               NEXT FIELD fan06
            WHEN INFIELD(fan09)  #被分攤部門
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_fan.fan09
               CALL cl_create_qry() RETURNING g_fan.fan09
#               CALL FGL_DIALOG_SETBUFFER( g_fan.fan09 )
               DISPLAY BY NAME g_fan.fan09
               NEXT FIELD fan09
            WHEN INFIELD(fan11) # 資產會計科目查詢
#              CALL q_aag(2,2,g_fan.fan11,'23','2','') RETURNING g_fan.fan11
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fan.fan11
               LET g_qryparam.arg1 = g_bookno1               #No.FUN-740026
               CALL cl_create_qry() RETURNING g_fan.fan11
#               CALL FGL_DIALOG_SETBUFFER( g_fan.fan11 )
               DISPLAY BY NAME g_fan.fan11
               NEXT FIELD fan11
            WHEN INFIELD(fan12) # 折舊會計科目查詢
#              CALL q_aag(2,2,g_fan.fan12,'23','2','') RETURNING g_fan.fan12
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fan.fan12
               LET g_qryparam.arg1 = g_bookno1               #No.FUN-740026
               CALL cl_create_qry() RETURNING g_fan.fan12
#               CALL FGL_DIALOG_SETBUFFER( g_fan.fan12 )
               DISPLAY BY NAME g_fan.fan12
               NEXT FIELD fan12
            #No.TQC-B20043  --Begin
            WHEN INFIELD(fan20) # 累折會計科目查詢
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
               LET g_qryparam.default1 = g_fan.fan20
               LET g_qryparam.arg1 = g_bookno1
               CALL cl_create_qry() RETURNING g_fan.fan20
               DISPLAY BY NAME g_fan.fan20
               NEXT FIELD fan20
            #No.TQC-B20043  --End
    #FUN-680028-----begin----
     ##-----No:FUN-AB0088 Mark-----
     #      WHEN INFIELD(fan111)
     #         CALL cl_init_qry_var()
     #         LET g_qryparam.form = "q_aag"
     #         LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
     #         LET g_qryparam.default1 = g_fan.fan111
     #         LET g_qryparam.arg1 = g_bookno2               #No.FUN-740026
     #         CALL cl_create_qry() RETURNING g_fan.fan111
     #         DISPLAY BY NAME g_fan.fan111
     #         NEXT FIELD fan111
     #      WHEN INFIELD(fan121)
     #         CALL cl_init_qry_var()
     #         LET g_qryparam.form = "q_aag"
     #         LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
     #         LET g_qryparam.default1 = g_fan.fan121                                                                                
     #         LET g_qryparam.arg1 = g_bookno2               #No.FUN-740026
     #         CALL cl_create_qry() RETURNING g_fan.fan121                                                                           
     #         DISPLAY BY NAME g_fan.fan121                                                                                          
     #         NEXT FIELD fan121
     ##-----No:FUN-AB0088 Mark END-----
    #FUN-680028-----end-----
           #MOD-BC0131---begin mark      
           ##No.TQC-B20043  --Begin
           # WHEN INFIELD(fan201)
           #    CALL cl_init_qry_var()
           #   LET g_qryparam.form = "q_aag"
           #    LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
           #    LET g_qryparam.default1 = g_fan.fan201
           #    LET g_qryparam.arg1 = g_bookno2
           #    CALL cl_create_qry() RETURNING g_fan.fan201
           #    DISPLAY BY NAME g_fan.fan201
           #    NEXT FIELD fan201
           ##No.TQC-B20043  --End
           #MOD-BC0131---begin mark
            WHEN INFIELD(fan13) # 分攤類別查詢
               CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_fad"   #No.TQC-6C0009 mark
               LET g_qryparam.form = "q_fad1"  #No.TQC-6C0009
               LET g_qryparam.default1 = g_fan.fan13
#              CALL cl_create_qry() RETURNING g_fan.fan13,l_fan12   #No.FUN-680028
#              CALL cl_create_qry() RETURNING l_fan12,g_fan.fan13   #No.FUN-680028 #No.TQC-6C0009 mark
               CALL cl_create_qry() RETURNING g_fan.fan13  #No.TQC-6C0009
#               CALL FGL_DIALOG_SETBUFFER( g_fan.fan13 )
               DISPLAY BY NAME g_fan.fan13
               NEXT FIELD fan13
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
 
FUNCTION i900_chkfaj(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
       l_faj06    LIKE faj_file.faj06,
       l_faj061   LIKE faj_file.faj061,
       l_faj43    LIKE faj_file.faj43
 
     LET g_errno = ' '
     SELECT faj06,faj061,faj43 INTO l_faj06,l_faj061,l_faj43
       FROM faj_file
      WHERE faj02 = g_fan.fan01 AND faj022 = g_fan.fan02
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
 
FUNCTION i900_chkgem(p_cmd,p_gem,p_type)
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
 
FUNCTION i900_chkaag(p_cmd,p_key,p_type,p_bookno)
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
       #No.TQC-B20043  --Begin
       #IF p_type = '1' THEN
       #   DISPLAY l_aag02 TO FORMONLY.aag02_1
       #ELSE
       #   DISPLAY l_aag02 TO FORMONLY.aag02_2
       #END IF
       CASE p_type
            WHEN '1' DISPLAY l_aag02 TO FORMONLY.aag02_1
            WHEN '2' DISPLAY l_aag02 TO FORMONLY.aag02_2
            WHEN '3' DISPLAY l_aag02 TO FORMONLY.aag02_5
       END CASE
       #No.TQC-B20043  --End
    END IF
END FUNCTION
#FUN-680028---begin----
FUNCTION i900_chkaag1(p_cmd,p_key,p_type,p_bookno)                                                                                            
DEFINE  l_aagacti  LIKE aag_file.aagacti,                                                                                           
        l_aag02    LIKE aag_file.aag02,                                                                                             
        l_aag03    LIKE aag_file.aag03,                                                                                             
        l_aag07    LIKE aag_file.aag07,                                                                                             
        p_cmd      LIKE type_file.chr1,                                                                                                                 #No.FUN-680070 VARCHAR(01)
        p_type     LIKE type_file.chr1,                                                                                                                 #No.FUN-680070 VARCHAR(01)
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
      #No.TQC-B20043  --Begin
      # IF p_type = '1' THEN                                                                                                         
      #    DISPLAY l_aag02 TO FORMONLY.aag02_3                                                                                      
      # ELSE                                                                                                                         
      #    DISPLAY l_aag02 TO FORMONLY.aag02_4                                                                                       
      # END IF                                                                                                                       
      CASE p_type
           WHEN '1' DISPLAY l_aag02 TO FORMONLY.aag02_3
           WHEN '2' DISPLAY l_aag02 TO FORMONLY.aag02_4
           WHEN '3' DISPLAY l_aag02 TO FORMONLY.aag02_6
      END CASE
      #No.TQC-B20043  --Begin
    END IF                                                                                                                          
END FUNCTION 
#FUN-680028-----end-----
 
FUNCTION i900_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_fan.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i900_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i900_count
    FETCH i900_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i900_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fan.fan01,SQLCA.sqlcode,0)
        INITIALIZE g_fan.* TO NULL
    ELSE
        CALL i900_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i900_fetch(p_flfan)
    DEFINE
        p_flfan          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    CASE p_flfan
        WHEN 'N' FETCH NEXT     i900_cs INTO g_fan.*
        WHEN 'P' FETCH PREVIOUS i900_cs INTO g_fan.*
        WHEN 'F' FETCH FIRST    i900_cs INTO g_fan.*
        WHEN 'L' FETCH LAST     i900_cs INTO g_fan.*
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
            FETCH ABSOLUTE g_jump i900_cs INTO g_fan.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fan.fan01,SQLCA.sqlcode,0)
        INITIALIZE g_fan.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flfan
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_fan.* FROM fan_file    # 重讀DB,因TEMP有不被更新特性
       WHERE fan01 = g_fan.fan01 AND fan02 = g_fan.fan02 AND fan03 = g_fan.fan03 AND fan04 = g_fan.fan04 AND fan05 = g_fan.fan05 AND fan06 = g_fan.fan06 AND fan041 = g_fan.fan041 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fan.fan01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fan_file",g_fan.fan01,g_fan.fan02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        CALL i900_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i900_show()
 
#No.TQC-690099  --start--                                                                                                           
   SELECT faj108 INTO g_faj.faj108                                                                                                  
     FROM faj_file                                                                                                                  
    WHERE faj02  = g_fan.fan01                                                                                                      
      AND faj022 = g_fan.fan02                                                                                                      
   LET g_faj_t.faj108 = g_faj.faj108                                                                                                
#No.TQC-690099  --end--                                                                                                             
                                
   LET g_fan_t.* = g_fan.*
   DISPLAY BY NAME g_fan.fan01,g_fan.fan02,g_fan.fan03,g_fan.fan04,g_fan.fan041,
                   g_fan.fan05,g_fan.fan06,g_fan.fan09,g_fan.fan10,g_fan.fan13,
                   g_fan.fan07,g_fan.fan08,g_fan.fan14,g_fan.fan15,g_fan.fan16,
                #  g_fan.fan11,g_fan.fan12,g_fan.fan111,g_fan.fan121,g_fan.fan17,g_faj.faj108, #No:FUN-AB0088 Mark   #No:A099      #FUN-680028 #No.TQC-690099 add faj108 
                   g_fan.fan11,g_fan.fan12,g_fan.fan17,g_faj.faj108,
                   g_fan.fan19,g_fan.fan20 #,g_fan.fan201 #NO.CHI-A30029 #TQC-B20043 add fan20,fan201 #MOD-BC0131 mark fan201
#No.FUN-740026--begin--
 
             CALL s_get_bookno(g_fan.fan03)
                  RETURNING g_flag,g_bookno1,g_bookno2    
             IF g_flag= '1' THEN  #
                #CALL cl_err(g_fan.fan03,'aoo-801',1)  #No.TQC-B60363
                CALL cl_err(g_fan.fan03,'aoo-081',1)   #No.TQC-B60363
             END IF 
 
#No.FUN-740026--end--
   CALL i900_chkaag('d',g_fan.fan11,'1',g_bookno1)          #No.FUN-740026
   CALL i900_chkaag('d',g_fan.fan12,'2',g_bookno1)          #No.FUN-740026
   CALL i900_chkaag('d',g_fan.fan20,'3',g_bookno1)          #No.TQC-B20043
#  CALL i900_chkaag1('d',g_fan.fan111,'1',g_bookno2)        #FUN-680028  #No.FUN-740026   #No:FUN-AB0088 Mark
#  CALL i900_chkaag1('d',g_fan.fan121,'2',g_bookno2)        #FUN-680028  #No.FUN-740026   #No:FUN-AB0088 Mark
#  CALL i900_chkaag1('d',g_fan.fan201,'3',g_bookno2)        #TQC-B20043 #MOD-BC0131 mark
   CALL i900_chkgem('d',g_fan.fan06,'1')
   CALL i900_chkgem('d',g_fan.fan09,'2')
   CALL i900_chkfaj('d')
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i900_u()
    IF g_fan.fan01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fan.fan041 <> '0' THEN
       CALL cl_err(g_fan.fan01,'afa-136',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fan01_t = g_fan.fan01
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i900_cl USING g_fan.fan01,g_fan.fan02,g_fan.fan03,g_fan.fan04,g_fan.fan05,g_fan.fan06,g_fan.fan041
    IF STATUS THEN
       CALL cl_err("OPEN i900_cl:", STATUS, 1)
       CLOSE i900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i900_cl INTO g_fan.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fan.fan01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i900_show()                          # 顯示最新資料
    LET g_fan_t.* = g_fan.*
    LET g_faj_t.faj108 = g_faj.faj108        #No.TQC-690099       
    LET g_fan01_t = g_fan.fan01
    LET g_fan02_t = g_fan.fan02
    LET g_fan03_t = g_fan.fan03
    LET g_fan04_t = g_fan.fan04
    LET g_fan041_t= g_fan.fan041
    LET g_fan05_t = g_fan.fan05
    LET g_fan06_t = g_fan.fan06
    LET g_faj108_t= g_faj.faj108             #No.TQC-690099       
    WHILE TRUE
       CALL i900_i("u")                      # 欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_fan.*=g_fan_t.*
           LET g_faj.faj108=g_faj_t.faj108   #No.TQC-690099        
           CALL i900_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       IF cl_null(g_fan.fan01) THEN
          CONTINUE WHILE
       END IF
       UPDATE fan_file SET fan_file.* = g_fan.*    # 更新DB
 WHERE fan01 = g_fan01_t AND fan02 = g_fan02_t AND fan03 = g_fan03_t AND fan04 = g_fan04_t AND fan05 = g_fan05_t AND fan06 = g_fan06_t AND fan041 = g_fan041_t
       IF SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err(g_fan.fan01,SQLCA.sqlcode,0)   #No.FUN-660136
          CALL cl_err3("upd","fan_file",g_fan01_t,g_fan02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          CONTINUE WHILE
       END IF
#No.TQC-690099  --start--                                                                                                           
       UPDATE faj_file SET faj108 = g_faj.faj108                                                                                    
        WHERE faj02  = g_fan.fan01                                                                                                  
          AND faj022 = g_fan.fan02                                                                                                  
       EXIT WHILE                                                                                                                   
       IF SQLCA.sqlerrd[3]=0 THEN                                                                                                   
          CALL cl_err3("upd","faj_file",g_fan01_t,g_fan02_t,SQLCA.sqlcode,"","",1)                                                    
          CONTINUE WHILE                                                                                                            
       END IF                                                                                                                       
#No.TQC-690099  --end--                  
       EXIT WHILE
    END WHILE
    CLOSE i900_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION i900_r()
    IF g_fan.fan01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fan.fan041 <> '0' THEN
       CALL cl_err(g_fan.fan01,'afa-136',0)
       RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN i900_cl USING g_fan.fan01,g_fan.fan02,g_fan.fan03,g_fan.fan04,g_fan.fan05,g_fan.fan06,g_fan.fan041
    IF STATUS THEN
       CALL cl_err("OPEN i900_cl:", STATUS, 0)
       CLOSE i900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i900_cl INTO g_fan.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fan.fan01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i900_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL                                    #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fan01|fan05"                             #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fan.fan01 CLIPPED, "|", g_fan.fan05      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "fan02|fan06"                             #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_fan.fan02 CLIPPED, "|", g_fan.fan06      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "fan03"                                   #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_fan.fan03                                #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "fan04"                                   #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_fan.fan04                                #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "fan041"                                  #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_fan.fan041                               #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                                                   #No.FUN-9B0098 10/02/24
       DELETE FROM fan_file WHERE fan01  = g_fan.fan01
                              AND fan02  = g_fan.fan02
                              AND fan03  = g_fan.fan03
                              AND fan04  = g_fan.fan04
                              AND fan041 = g_fan.fan041
                              AND fan05  = g_fan.fan05
                              AND fan06  = g_fan.fan06
       IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660136
           CALL cl_err3("del","fan_file",g_fan.fan01,g_fan.fan02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       ELSE
          CLEAR FORM
          OPEN i900_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i900_cs
             CLOSE i900_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i900_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i900_cs
             CLOSE i900_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i900_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i900_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i900_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i900_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION i900_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("fan01",TRUE)
     END IF
     #No:A099
     IF INFIELD(fan17) OR (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("fan17",TRUE)
     END IF
     #end No:A099
 
END FUNCTION
 
FUNCTION i900_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("fan01",FALSE)
    END IF
    #No:A099
    IF INFIELD(fan17) OR (NOT g_before_input_done) THEN
       #-----MOD-660007---------
       #IF g_aza.aza26 != '2' THEN
       #   CALL cl_set_comp_entry("fan17",FALSE)
       #END IF
       #-----END MOD-660007-----
    END IF
    #end No:A099
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
