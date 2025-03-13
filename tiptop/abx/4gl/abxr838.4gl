# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abxr838.4gl
# Descriptions...: 報廢折合原料清冊作業(abxr838)
# Date & Author..: 
# Modify.........: No.FUN-530012 05/03/16 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗 
# Modify.........; NO.TQC-5A0003 05/10/07 BY yiting 沒有規格
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/25 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0083 06/11/09 By xumin 報表寬度不符問題更正 
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-850089 08/06/02 By TSD.liquor 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/25 By dxfwo  CR 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-BA0228 11/11/08 By johung 調整SQL
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,   # Where condition    #No.FUN-680062   VARCHAR(1000)   
              #FUN-6A0007...............begin
              s       LIKE type_file.chr2,     
              u       LIKE type_file.chr2,    
              yy      LIKE type_file.chr4,
              ima15   LIKE type_file.chr1,
              rname   LIKE type_file.chr1,        
              detail  LIKE type_file.chr1
              #FUN-6A0007...............end
              END RECORD,
          g_count LIKE type_file.num5,        #No.FUN-680062     smallint 
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   g_ima1916a    LIKE ima_file.ima1916     #FUN-6A0007
DEFINE   g_ima1916b    LIKE ima_file.ima1916     #FUN-6A0007
DEFINE   g_bxe01     LIKE bxe_file.bxe01  #FUN-6A0007
DEFINE   g_bxe02     LIKE bxe_file.bxe02  #FUN-6A0007
DEFINE   g_bxe03     LIKE bxe_file.bxe03  #FUN-6A0007
DEFINE   l_table              STRING,    #FUN-850089 add
         g_sql                STRING,    #FUN-850089 add
         g_str                STRING     #FUN-850089 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
  #---FUN-850089 add ---start
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql ="order1.bwd_file.bwd01,",
             "order2.bwd_file.bwd01,",
             "order3.bwd_file.bwd01,",
             "order4.bwd_file.bwd01,",
             "bwd01.bwd_file.bwd01,",
             "bwd05.bwd_file.bwd05,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ima25.ima_file.ima25,",
             "ima1916a.ima_file.ima1916,",
             "bwg04.bwg_file.bwg04,",
             "bwg041.bwg_file.bwg041,",
             "bwg05.bwg_file.bwg05,",
             "ima02b.ima_file.ima02,",
             "ima021b.ima_file.ima021,",
             "ima25b.ima_file.ima25,",
             "ima1916b.ima_file.ima1916,",
             "bxe02a.bxe_file.bxe02,",
             "bxe03a.bxe_file.bxe03,",
             "bxe02b.bxe_file.bxe02,",
             "bxe03b.bxe_file.bxe03"
 
 
  LET l_table = cl_prt_temptable('abxr838',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #------------------------------ CR (1) ------------------------------#
  #---FUN-850089 add ---end
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   IF cl_null(tm.wc)
   THEN 
       CALL abxr838_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr838_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062  smallint
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062  VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 9  LET p_col = 22
   ELSE LET p_row = 5  LET p_col = 19
   END IF
  
   OPEN WINDOW abxr838_w AT p_row,p_col
        WITH FORM "abx/42f/abxr838" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   #FUN-6A0007...............begin
   LET tm.wc = ""
   LET tm.yy    = YEAR(TODAY)-1
   LET tm.ima15 = "1"
   LET tm2.s1    = '2'
   LET tm2.s2    = '1'
   LET tm2.u1    = 'N'
   LET tm2.u2    = 'N'
   LET tm.rname  = '1'
   LET tm.detail = 'Y'
 
   #CONSTRUCT BY NAME tm.wc ON bwd01
   CONSTRUCT BY NAME tm.wc ON bwd01,ima1916a,bwg04,ima1916b
#No.FUN-570243 --start--                                                                                    
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(bwd01)  # 成品料號
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima20"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bwd01
             NEXT FIELD bwd01
           WHEN INFIELD(ima1916a)  # 成品保稅群組代碼
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bxe01"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima1916a
             NEXT FIELD ima1916a
           WHEN INFIELD(bwg04)  # 原料料號
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima20"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bwg04
             NEXT FIELD bwg04
           WHEN INFIELD(ima1916b)  # 半成品/成品保稅群組代碼
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bxe01"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima1916b
             NEXT FIELD ima1916b
         END CASE
 
      #ON ACTION CONTROLP                                                                                              
      #      IF INFIELD(bwd01) THEN                                                                                                  
      #         CALL cl_init_qry_var()                                                                                               
      #         LET g_qryparam.form = "q_ima"                                                                                       
      #         LET g_qryparam.state = "c"                                                                                           
      #         CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
      #         DISPLAY g_qryparam.multiret TO bwd01                                                                                 
      #         NEXT FIELD bwd01                                                                                                     
      #      END IF  
   #FUN-6A0007...............end
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr838_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" 
   THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr838_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   #FUN-6A0007...............begin
   INPUT BY NAME tm2.s1,tm2.s2,tm2.u1,tm2.u2,
                 tm.yy,tm.ima15,tm.rname,tm.detail WITHOUT DEFAULTS
      
      AFTER FIELD ima15
         IF tm.ima15 NOT MATCHES "[123]" THEN  
            NEXT FIELD ima15
         END IF
      AFTER FIELD yy    # 盤點年度
         IF NOT cl_null(tm.yy) THEN
            IF tm.yy < 0 THEN
               CALL cl_err('yyyy','aim-391',0)
               NEXT FIELD yy
            END IF
         END IF
      AFTER FIELD rname  # 報表格式
         IF tm.rname NOT MATCHES "[12]" THEN
            NEXT FIELD rname
         END IF
      AFTER FIELD s1     # 排序
         IF tm2.s1 NOT MATCHES "[12]" THEN
            NEXT FIELD s1
         END IF
      AFTER FIELD s2     # 排序
         IF tm2.s2 NOT MATCHES "[12]" THEN
            NEXT FIELD s2
         END IF
      AFTER FIELD u1     # 小計
         IF tm2.u1 NOT MATCHES "[YN]" THEN
            NEXT FIELD u1
         END IF
      AFTER FIELD u2     # 小計
         IF tm2.u2 NOT MATCHES "[YN]" THEN
            NEXT FIELD u2
         END IF
      AFTER FIELD detail # 明細列印否
         IF tm.detail NOT MATCHES "[YN]" THEN
            NEXT FIELD detail
         END IF
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.u = tm2.u1,tm2.u2
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE INPUT        #TQC-860021
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 EXIT WHILE
   END IF
   #FUN-6A0007...............end
   CALL cl_wait()
   #FUN-6A0007...............begin 做ima1916a,ima1916b字串替換
   CALL cl_replace_str(tm.wc,'ima1916a','a.ima1916') RETURNING tm.wc
   CALL cl_replace_str(tm.wc,'ima1916b','b.ima1916') RETURNING tm.wc
   #FUN-6A0007...............end 做ima1916a,ima1916b字串替換
   CALL abxr838()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr838_w
END FUNCTION
 
FUNCTION abxr838()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name              #No.FUN-680062    VARCHAR(1000)  
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       #No.FUN-680062   VARCHAR(1000)
          #l_za05    LIKE za_file.za05,            #No.FUN-680062   VARCHAR(40)    #FUN-6A0007
          bwd       RECORD LIKE bwd_file.*,   
          bwg       RECORD LIKE bwg_file.*   
   #FUN-6A0007...............begin
   DEFINE l_order   ARRAY[5] OF LIKE bwd_file.bwd01
   DEFINE sr        RECORD
                    order1     LIKE bwd_file.bwd01,
                    order2     LIKE bwd_file.bwd01,
                    order3     LIKE bwd_file.bwd01,
                    order4     LIKE bwd_file.bwd01,
                    bwd01      LIKE bwd_file.bwd01,
                    bwd05      LIKE bwd_file.bwd05,
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021,
                    ima25      LIKE ima_file.ima25,
                    ima1916a LIKE ima_file.ima1916,
                    bwg04      LIKE bwg_file.bwg04,
                    bwg041     LIKE bwg_file.bwg041,
                    bwg05      LIKE bwg_file.bwg05,
                    ima02b     LIKE ima_file.ima02,
                    ima021b    LIKE ima_file.ima021,
                    ima25b     LIKE ima_file.ima25,
                    ima1916b LIKE ima_file.ima1916
                    END RECORD
   #FUN-850089 add
   DEFINE l_bxe02a  LIKE bxe_file.bxe02,
          l_bxe03a  LIKE bxe_file.bxe03,
          l_bxe02b  LIKE bxe_file.bxe02,
          l_bxe03b  LIKE bxe_file.bxe03
   #FUN-850089 add end
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?)" #21 items
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ------------------------------#
   
   #FUN-6A0007...............end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #FUN-6A0007...............begin
   #LET l_sql="SELECT bwd_file.*,bwg_file.* ",
   #           "  FROM bwd_file,bwg_file  ",
   #           " WHERE bwd01=bwg01 AND bwd02=bwg02 AND bwg00 ='S' AND ",
   #           " bwg01 = bwg04 AND ",tm.wc clipped 
   {
   LET l_sql = "SELECT '','','','', ",
               "       bwd01,bwd05, ",
               "       a.ima02,a.ima021,a.ima25,a.ima1916, ",
               "       bwg04,bwg041,bwg05, ",
               "       b.ima02,b.ima021,b.ima25,b.ima1916 ",
               "  FROM bwd_file,bwg_file,ima_file a,ima_file b ",
               " WHERE bwd01 = a.ima01 AND bwg04 = b.ima01 ",
               "   AND bwd01 = bwg01 AND bwd02 = bwg02 ",
               "   AND (a.ima106 != '5' OR a.ima106 IS NULL) ",
               "   AND bwg01 != bwg04 ",
               "   AND bwg00 = 'S' ",
               "   AND ",tm.wc CLIPPED,
               "   AND bwd011 = bwg011 ",
               "   AND bwd011 = ",tm.yy
   }
   LET l_sql = "SELECT '','','','', ",
               "       bwd01,bwd05, ",
               "       a.ima02,a.ima021,a.ima25,a.ima1916, ",
               "       bwg04,bwg041,bwg05, ",
               "       b.ima02,b.ima021,b.ima25,b.ima1916 ",
               "  FROM bwd_file,bwg_file,ima_file a,ima_file b ",
               " WHERE bwd01 = a.ima01 AND bwg04 = b.ima01 ",
               "   AND bwd01 = bwg01 AND bwd02 = bwg02 ",   #MOD-BA0228 add ,
               #MOD-BA0228 -- begin --
               "   AND bwg00 = 'S' ",
               "   AND bwd011 = ",tm.yy,
               "   AND ",tm.wc CLIPPED
               #MOD-BA0228 -- end --
   # 保稅
   IF tm.ima15 = '1' THEN
      LET l_sql = l_sql," AND b.ima15 = 'Y' "
   END IF
   IF tm.ima15 = '2' THEN
      LET l_sql = l_sql," AND b.ima15 = 'N' "
   END IF
   #FUN-6A0007...............end
   
     PREPARE abxr838_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
     END IF
     LET g_count = 0
     DECLARE abxr838_curs1 CURSOR FOR abxr838_prepare1
    
#     CALL cl_outnam('abxr838') RETURNING l_name       #No.FUN-890101 
   #FUN-6A0007...............begin
     IF tm.rname = '2' THEN   # 依報表格式改變表身列印順序
        LET g_zaa[31].zaa07 = 7 
        LET g_zaa[32].zaa07 = 8
        LET g_zaa[33].zaa07 = 9
        LET g_zaa[34].zaa07 = 10
        LET g_zaa[35].zaa07 = 11
        LET g_zaa[36].zaa07 = 1 
        LET g_zaa[37].zaa07 = 2
        LET g_zaa[38].zaa07 = 3
        LET g_zaa[39].zaa07 = 4
        LET g_zaa[40].zaa07 = 5
        LET g_zaa[41].zaa07 = 6
        #重新定義各欄位起始位置
        LET g_c[36] = 1
        LET g_c[37] = g_c[36] + g_zaa[36].zaa05 + 1
        LET g_c[38] = g_c[37] + g_zaa[37].zaa05 + 1 
        LET g_c[39] = g_c[38] + g_zaa[38].zaa05 + 1
        LET g_c[40] = g_c[39] + g_zaa[39].zaa05 + 1
        LET g_c[41] = g_c[40] + g_zaa[40].zaa05 + 1
        LET g_c[31] = g_c[41] + g_zaa[41].zaa05 + 1
        LET g_c[32] = g_c[31] + g_zaa[31].zaa05 + 1
        LET g_c[33] = g_c[32] + g_zaa[32].zaa05 + 1
        LET g_c[34] = g_c[33] + g_zaa[33].zaa05 + 1
        LET g_c[35] = g_c[34] + g_zaa[34].zaa05 + 1
   END IF
 
     #START REPORT abxr838_rep TO l_name
 #    START REPORT abxr838_rep2 TO l_name           #No.FUN-890101 
 
     LET g_pageno = 0
     FOREACH abxr838_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
   END IF
        # 篩選排序條件
        IF tm.rname = '1' THEN
           FOR g_i = 1 TO 2
               CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bwd01
                                             LET l_order[g_i+2] = sr.bwg04
                    WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916a
                                             LET l_order[g_i+2] = sr.ima1916b
                    OTHERWISE LET l_order[g_i] = '-'
               END CASE
           END FOR
        ELSE
           FOR g_i = 1 TO 2
               CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bwg04
                                             LET l_order[g_i+2] = sr.bwd01
                    WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916b
                                             LET l_order[g_i+2] = sr.ima1916a
                    OTHERWISE LET l_order[g_i] = '-'
               END CASE
           END FOR
 
        END IF
        LET sr.order1 = l_order[1]
        LET sr.order2 = l_order[2]
        LET sr.order3 = l_order[3]
        LET sr.order4 = l_order[4]
        #FUN-850089  ---start---
        LET g_bxe01 = sr.ima1916a
        CALL abxr838_bxe01()
        LET l_bxe02a = g_bxe02
        LET l_bxe03a = g_bxe03
        LET g_bxe01 = sr.ima1916b
        CALL abxr838_bxe01()
        LET l_bxe02b = g_bxe02
        LET l_bxe03b = g_bxe03
        EXECUTE insert_prep USING sr.*,l_bxe02a,l_bxe03a,l_bxe02b,l_bxe03b
        IF STATUS THEN
           CALL cl_err('ins prep',STATUS,1)
        END IF
        #FUN-850089  ---e n d---
#        OUTPUT TO REPORT abxr838_rep2(sr.*)       #No.FUN-890101 
     END FOREACH
 
 
 
#     FOREACH abxr838_curs1 INTO bwd.*,bwg.*
#       IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#          EXIT FOREACH 
#       END IF
#       OUTPUT TO REPORT abxr838_rep(bwd.*,bwg.*)
#     END FOREACH
#
     #FINISH REPORT abxr838_rep
#     FINISH REPORT abxr838_rep2                  #No.FUN-890101 
   #FUN-6A0007...............end
   #FUN-850089  ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'bwd01,ima1916a,bwg04,ima1916b')
           RETURNING g_str
   ELSE
      LET g_str = ''
   END IF
 
   LET g_str = g_str,";",tm.s,";",tm.u,";",tm.yy,";",
               tm.rname,";",tm.detail,";",
               g_bxz.bxz100,";",g_bxz.bxz101,";",g_bxz.bxz102
 
   CALL cl_prt_cs3('abxr838','abxr838',l_sql,g_str)
   #---FUN-850089 add---END
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #No.FUN-890101 
END FUNCTION
 
#FUN-6A0007...............begin
#REPORT abxr838_rep2(sr)
#   DEFINE l_last_sw LIKE type_file.chr1
#   DEFINE l_str     STRING
#   DEFINE sr        RECORD
#                    order1     LIKE bwd_file.bwd01,
#                    order2     LIKE bwd_file.bwd01,
#                    order3     LIKE bwd_file.bwd01,
#                    order4     LIKE bwd_file.bwd01,
#                    bwd01      LIKE bwd_file.bwd01,
#                    bwd05      LIKE bwd_file.bwd05,
#                    ima02      LIKE ima_file.ima02,
#                    ima021     LIKE ima_file.ima021,
#                    ima25      LIKE ima_file.ima25,
#                    ima1916a LIKE ima_file.ima1916,
#                    bwg04      LIKE bwg_file.bwg04,
#                    bwg041     LIKE bwg_file.bwg041,
#                    bwg05      LIKE bwg_file.bwg05,
#                    ima02b     LIKE ima_file.ima02,
#                    ima021b    LIKE ima_file.ima021,
#                    ima25b     LIKE ima_file.ima25,
#                    ima1916b LIKE ima_file.ima1916
#                    END RECORD
#   OUTPUT TOP MARGIN g_top_margin
#          LEFT MARGIN 0
#          BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH g_page_line
#   ORDER BY sr.order1,sr.order2,sr.order3,sr.order4
#   FORMAT
#     PAGE HEADER
#        LET l_str = g_bxz.bxz100 CLIPPED,
#                    ' ',g_company CLIPPED,
#                    ' ',g_bxz.bxz102 CLIPPED,
#                    '                   ',g_x[12],g_bxz.bxz101 CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED)
#                            -FGL_WIDTH(g_bxz.bxz100 CLIPPED)
#                            -FGL_WIDTH(g_bxz.bxz102 CLIPPED))/2)+3,l_str CLIPPED
#        PRINT ' '
#        LET g_pageno = g_pageno + 1
#        IF tm.rname = '1' THEN
#           LET g_x[1] = g_x[1]
#        ELSE
#           LET g_x[1] = g_x[11]
#        END IF
#        # 報表格式名稱
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#
#        PRINT ' '
#        # 製表日期....
#        PRINT COLUMN 01,g_x[2] CLIPPED,g_pdate USING 'yy/mm/dd',' ',TIME,
#              COLUMN 104,g_x[13] CLIPPED,tm.yy USING '####',
#              COLUMN g_len - 10,g_x[3] CLIPPED,g_pageno USING '###'
#        PRINT g_dash
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#              g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
# 
#     ON EVERY ROW
#        IF tm.detail = 'Y' THEN
#           PRINT COLUMN g_c[31],sr.bwd01[1,20],
#                 COLUMN g_c[32],sr.ima02[1,30],
#                 COLUMN g_c[33],sr.ima021[1,30],
#                 COLUMN g_c[34],sr.ima25 CLIPPED,  #TQC-6A0083
#                 COLUMN g_c[35],cl_numfor(sr.bwd05,35,3),
#                 COLUMN g_c[36],sr.bwg04[1,20],
#                 COLUMN g_c[37],sr.ima02b[1,30],
#                 COLUMN g_c[38],sr.ima021b[1,30],
#                 COLUMN g_c[39],sr.ima25b CLIPPED,  #TQC-6A0083
#                 COLUMN g_c[40],cl_numfor(sr.bwg041,40,4),
#                 COLUMN g_c[41],cl_numfor(sr.bwg05,41,4)
#        END IF
#
#     AFTER GROUP OF sr.order1
#        IF tm.u[1,1] = 'Y' THEN  # 是否小計
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[1,1] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[33],g_x[18] CLIPPED,sr.bwd01 CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[33],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT COLUMN g_c[33],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[33],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE 
#             END CASE 
#           ELSE
#             CASE 
#              WHEN tm.s[1,1] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[38],g_x[18] CLIPPED,sr.bwg04 CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[38],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT COLUMN g_c[38],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[38],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE 
#             END CASE 
#           END IF
#        END IF
#
#     AFTER GROUP OF sr.order2
#        IF tm.u[2,2] = 'Y' THEN  # 是否小計
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[2,2] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[33],g_x[18] CLIPPED,sr.bwd01 CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[33],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT COLUMN g_c[33],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[33],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE 
#           ELSE
#             CASE 
#              WHEN tm.s[2,2] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[38],g_x[18] CLIPPED,sr.bwg04 CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[38],g_x[15] CLIPPED,sr.ima1916b,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT COLUMN g_c[38],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[38],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE 
#           END IF
#        END IF
#
#     AFTER GROUP OF sr.order3
#        IF tm.u[1,1] = 'Y' THEN
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[1,1] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[38],g_x[18] CLIPPED,sr.bwg04 CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[38],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT COLUMN g_c[38],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[38],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE 
#           ELSE
#             CASE 
#              WHEN tm.s[1,1] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[33],g_x[18] CLIPPED,sr.bwd01 CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[33],g_x[15] CLIPPED,sr.ima1916a[1,30],
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT COLUMN g_c[33],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[33],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE 
#           END IF
#        END IF
#     
#     AFTER GROUP OF sr.order4
#        IF tm.u[2,2] = 'Y' THEN
#           IF tm.rname = '1' THEN
#             CASE
#              WHEN tm.s[2,2] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[38],g_x[18] CLIPPED,sr.bwg04 CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[38],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[39],g_x[14] CLIPPED,
#                       COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bwg041),40,4),
#                       COLUMN g_c[41],cl_numfor(GROUP SUM(sr.bwg05),41,4)
#                 PRINT COLUMN g_c[38],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[38],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE 
#           ELSE
#             CASE
#              WHEN tm.s[2,2] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[33],g_x[18] CLIPPED,sr.bwd01 CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr838_bxe01()
#                 PRINT COLUMN g_c[33],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[34],g_x[14] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bwd05),35,3)
#                 PRINT COLUMN g_c[33],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[33],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE 
#           END IF
#        END IF
#
#     ON LAST ROW
#        PRINT g_dash
#        LET l_last_sw = 'y'
#        PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
#              COLUMN (g_len-9),g_x[7] CLIPPED
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
#                 COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
#
#END REPORT
#No.FUN-890101 
 
# 保稅規格代碼、品名、規格
FUNCTION abxr838_bxe01()
 
 LET g_bxe02 = NULL
 LET g_bxe03 = NULL
 
 SELECT bxe02,bxe03 INTO g_bxe02,g_bxe03
  FROM bxe_file
  WHERE bxe01 = g_bxe01
 
END FUNCTION
#FUN-6A0007...............end
 
#FUN-6A0007............... mark begin
#REPORT abxr838_rep(bwd,bwg)
#    DEFINE l_last_sw   LIKE type_file.chr1,     #No.FUN-680062     VARCHAR(1) 
#          x_ima25 LIKE ima_file.ima25,
#          x_ima15 LIKE ima_file.ima15, 
#          x_ima02 LIKE ima_file.ima02, 
#          x_ima021 LIKE ima_file.ima021,   #NO.TQC-5A0003
#          x_bne08 LIKE bne_file.bne08,
#          x_bnd04 LIKE bnd_file.bnd04,
#          bwd RECORD LIKE bwd_file.*,          
#          bwg RECORD LIKE bwg_file.*,          
#         nbwg RECORD LIKE bwg_file.*,          
#          bne RECORD LIKE bne_file.*,          
#          ima RECORD LIKE ima_file.*           
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY bwd.bwd01
#
#  FORMAT
#   PAGE HEADER 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT 
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#      PRINTX name=H2 g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw = "n"
#
#   BEFORE GROUP OF bwd.bwd01
#    #select ima02,ima25,ima15 into x_ima02,x_ima25,x_ima15  #NO.TQC-5A0003 MARK
#    select ima02,ima021,ima25,ima15 into x_ima02,x_ima021,x_ima25,x_ima15
#    from ima_file where ima01 = bwd.bwd01 
#    select bnd04 into x_bnd04 FROM bnd_file where bnd01 = bwd.bwd01 
#    PRINTX name=D1 COLUMN g_c[31],g_x[9],
#                   COLUMN g_c[32],bwg.bwg01,
#                   COLUMN g_c[33],bwg.bwg02,
#                   COLUMN g_c[34],x_bnd04,
#                   COLUMN g_c[36],cl_numfor(bwg.bwg05,36,2) 
#    PRINTX name=D2 COLUMN g_c[38],x_ima02,
#                   COLUMN g_c[39],x_ima021  #NO.TQC-5A0003
#
#
#   ON EVERY ROW
#     declare selmmxx cursor for 
#       select * from bwg_file 
#     where bwg00 = bwg.bwg00 
#     AND   bwg01 = bwg.bwg01
#     AND   bwg02 = bwg.bwg02 
#      AND bwg01 <> bwg04       #No.9572
#     ORDER BY bwg00,bwg01,bwg02,bwg03
#     FOREACH selmmxx INTO nbwg.*
#       select * into ima.* from ima_file where ima01 = nbwg.bwg04
#       select * into bne.* from bne_file where bne01 = nbwg.bwg01
#                                         and   bne02 = nbwg.bwg02
#                                         and   bne03 = nbwg.bwg03
#
#       PRINT COLUMN g_c[31],nbwg.bwg03 using "###&",
#             COLUMN g_c[32],nbwg.bwg04,
#             COLUMN g_c[34],ima.ima02,
#             COLUMN g_c[35],cl_numfor(bne.bne08,35,2), 
#             COLUMN g_c[36],cl_numfor(nbwg.bwg05,36,2)
#     END FOREACH 
#
#   AFTER GROUP OF bwd.bwd01
#   PRINT 
#
#   ON LAST ROW
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#
#END REPORT
#FUN-6A0007............... mark end
