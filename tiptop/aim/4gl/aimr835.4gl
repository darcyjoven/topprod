# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: aimr835.4gl
# Descriptions...: 盤點資料清冊－在製工單
# Input parameter: 
# Return code....: 
# Date & Author..: 93/11/18 By Apple
# Modify.........: MOD-470050 04/07/19 By Mandy OUTER 那段SQL有問題
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.MOD-520029 05/03/14 By ching fix OUTER select sfa13
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 06/01/11 By kevin 結束位置調整
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.FUN-7B0138 07/12/12 By Lutingting 轉為用Crystal Report 輸出
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值
# Modify.........: No.MOD-910052 09/01/07 By claire 初盤二與複盤一的值取錯
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60092 10/07/21 By lilingyu 平行工藝
# Modify.........: No:MOD-AC0094 10/12/13 By sabrina 報表多show作業編號
# Modify.........: No.TQC-CB0093 12/11/26 By qirl 增加開窗
# Modify.........: No:CHI-B70047 13/01/22 By Alberti 判斷若是委外，則抓廠商簡稱(pmc03) 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                              # Print condition RECORD
           wc       STRING,                    # Where Condition  #TQC-630166
           data     LIKE type_file.chr20,      #No.FUN-690026 VARCHAR(12)
           choice   LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
           user     LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
           type     LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
           s        LIKE type_file.chr3,       #No.FUN-690026 VARCHAR(03)
           t        LIKE type_file.chr3,       #No.FUN-690026 VARCHAR(03)
           more     LIKE type_file.chr1        # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
       g_str,g_str2    LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(40)
DEFINE g_i             LIKE type_file.num5,    #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
DEFINE l_table   STRING          #No.FUN-7B0138
DEFINE l_str     STRING          #No.FUN-7B0138
DEFINE g_sql     STRING          #No.FUN-7B0138
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#No.FUN-7B0138--START--
   LET g_sql = "pid01.pid_file.pid01,",
               "pid02.pid_file.pid02,",
               "pid022.pid_file.pid022,",     #MOD-AC0094 add
               "pid03.pid_file.pid03,",
               "pie02.pie_file.pie02,",
               "pie03.pie_file.pie03,",
               "pie04.pie_file.pie04,",
               "pie07.pie_file.pie07,",
               "pie30.pie_file.pie30,",
               "pie40.pie_file.pie40,",
               "pie50.pie_file.pie50,",
               "pie60.pie_file.pie60,",
               "count.pie_file.pie30,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,",
               "ima25.ima_file.ima25,",
               "sfa13.sfa_file.sfa13,",
               "sfb82.sfb_file.sfb82,",
               "gem02.gem_file.gem02,",      #FUN-A60092 add ,
               "pid012.pid_file.pid012,",    #FUN-A60092 add
               "pid021.pid_file.pid021"      #FUN-A60092 add
    LET l_table = cl_prt_temptable('aimr835',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?)"      #FUN-A60092 add ?,?   #MOD-AC0094 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-7B0138--END
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.data  = ARG_VAL(8)
   LET tm.choice= ARG_VAL(9)
   LET tm.user  = ARG_VAL(10)
   LET tm.type  = ARG_VAL(11)
   LET tm.s     = ARG_VAL(12)
   LET tm.t     = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r835_tm(0,0)        # Input print condition
      ELSE CALL r835()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r835_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 15
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r835_w AT p_row,p_col
        WITH FORM "aim/42f/aimr835" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice= '1'
   LET tm.user  = '1'
   LET tm.type  = 'N'
   LET tm.s     = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pid02,pid01,pid03,pie02,sfb82 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#TQC-CB0093 -------------Begin-------------
       ON ACTION controlp
          CASE
             WHEN INFIELD(pid01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_pid01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pid01
                  NEXT FIELD pid01
             WHEN INFIELD(pid02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_pid02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pid02
                  NEXT FIELD pid02
             WHEN INFIELD(pid03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_pid03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pid03
                  NEXT FIELD pid03
             WHEN INFIELD(pie02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_pie02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pie02
                  NEXT FIELD pie02
             WHEN INFIELD(sfb82)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfb82"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb82
                  NEXT FIELD sfb82
                 OTHERWISE EXIT CASE
             END CASE
#TQC-CB0093 -------------End---------------
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
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r835_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.data,tm.choice,tm.user,tm.type,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                  tm.more 
                    WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD choice
         IF tm.choice IS NULL OR tm.choice NOT MATCHES'[12]'
         THEN NEXT FIELD choice
         END IF
 
      AFTER FIELD user  
         IF tm.user   IS NULL OR tm.user   NOT MATCHES'[12]'
         THEN NEXT FIELD user  
         END IF
 
      AFTER FIELD type  
         IF tm.type   IS NULL OR tm.type   NOT MATCHES'[YN]'
         THEN NEXT FIELD type  
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r835_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr835'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr835','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.data   CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.user   CLIPPED,"'",
                         " '",tm.type   CLIPPED,"'",
                         " '",tm.s      CLIPPED,"'",
                         " '",tm.t      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr835',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r835_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r835()
   ERROR ""
END WHILE
   CLOSE WINDOW r835_w
END FUNCTION
 
FUNCTION r835()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD 
                    order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    pid01  LIKE pid_file.pid01, #標籤號碼
                    pid02  LIKE pid_file.pid02, #工單編號
                    pid022 LIKE pid_file.pid022,#作業編號    #MOD-AC0094 add
                    pid03  LIKE pid_file.pid03, #生產料件
                    pie02  LIKE pie_file.pie02, #盤點料號
                    pie03  LIKE pie_file.pie03, 
                    pie04  LIKE pie_file.pie04, #發料單位
                    pie07  LIKE pie_file.pie07, #項次
                    pie30  LIKE pie_file.pie30, 
                    pie40  LIKE pie_file.pie40, 
                    pie50  LIKE pie_file.pie50, 
                    pie60  LIKE pie_file.pie60, 
                    pie900 LIKE pie_file.pie900,#No.FUN-870051 
                    count  LIKE pie_file.pie30, #盤點數量
                    pie012 LIKE pie_file.pie012,#No.FUN-A60027 
                    pie013 LIKE pie_file.pie013,#No.FUN-A60027 
                    ima02  LIKE ima_file.ima02, #品名規格
                    ima021 LIKE ima_file.ima021,#FUN-510017
                    ima08  LIKE ima_file.ima08, #來源    
                    ima25  LIKE ima_file.ima25, #庫存單位
                    sfa13  LIKE sfa_file.sfa13, #發料/庫存轉換率
                    sfb82  LIKE sfb_file.sfb82, #製造部門
                    gem02  LIKE gem_file.gem02  #製造部門
                   ,pid012 LIKE pid_file.pid012  #FUN-A60092 add
                   ,pid021 LIKE pid_file.pid021  #FUN-A60092 add 
                   ,sfb02  LIKE sfb_file.sfb02   #CHI-B70047 add
                    END RECORD
     
     CALL cl_del_data(l_table)                                      #No.FUN-7B0138
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aimr833'      #No.FUN-7B0138            
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','', ",
                 " pid01, pid02, pid022,pid03, pie02, pie03, pie04,",     #MOD-AC0094 add pid022
                 " pie07, pie30, pie40, pie50, pie60,pie900, '',pie012,pie013,", #No.FUN-870051 add pie900 #FUN-A60027 add pie012,pie013
                 " ima02,ima021, ima08, ima25, 0, sfb82, gem02,pid012,pid021,sfb02", #MOD-520029
                                                            #FUN-A60092 add pid012,pid021 
                                                            #CHI-B70047 add sfb02
                 "  FROM pid_file,pie_file,sfb_file,",
                 "       OUTER ima_file,OUTER gem_file",                          
                 " WHERE pid01=pie01 AND pie_file.pie02=ima_file.ima01 ",                
                 "   AND pid02=sfb01 AND sfb_file.sfb82=gem_file.gem01 ",                  
                 "   AND pid02 IS NOT NULL AND sfb87!='X' ",
                 "   AND ",tm.wc
     DISPLAY "l_sql:",l_sql
 
     IF tm.type ='N'
     THEN  CASE tm.choice    
           WHEN  '1'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped,"AND pie30 >=0 "
                      ELSE LET l_sql =l_sql clipped,"AND pie40 >=0 "   #MOD-910052 modify pie50->pie40
                      END IF
           WHEN  '2'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped,"AND pie50 >=0 "   #MOD-910052 modify pie40->pie50
                      ELSE LET l_sql =l_sql clipped,"AND pie60 >=0 "
                      END IF
           END CASE
     END IF
     PREPARE r835_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r835_curs1 CURSOR FOR r835_prepare1
 
#    LET l_name = 'aimr835.out'
#No.FUN-7B0138--START
#     CALL cl_outnam('aimr835') RETURNING l_name
#     START REPORT r835_rep TO l_name
#     IF tm.choice = '1' 
#     THEN LET g_str = g_x[14] clipped
#     ELSE LET g_str = g_x[15] clipped
#     END IF
#     IF tm.user   = '1' 
#     THEN LET g_str2 = g_x[16] clipped
#     ELSE LET g_str2 = g_x[17] clipped
#     END IF
#No.FUN-7B0138--END
     FOREACH r835_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
 
       IF cl_null(sr.pie900) THEN LET sr.pie900=sr.pie02 END IF #FUN-870051 
        #MOD-520029
       SELECT sfa13 INTO sr.sfa13 FROM sfa_file
        WHERE sfa01=sr.pid02
          AND sfa03=sr.pie02
          AND sfa08=sr.pie03
          AND sfa12=sr.pie04
          AND sfa27=sr.pie900 #No.FUN-870051
          AND sfa012 = sr.pie012 AND sfa013 = sr.pie013                #FUN-A60027  
       #--
 
#No.FUN-7B0138--START--
#       IF tm.user = '1' 
#       THEN IF tm.choice = '1' 
#            THEN LET sr.count = sr.pie30
#            ELSE LET sr.count = sr.pie50
#            END IF
#       ELSE IF tm.choice = '1'
#            THEN LET sr.count = sr.pie40
#            ELSE LET sr.count = sr.pie60
#            END IF
#       END IF
#No.FUN-7B0138--END
       IF sr.sfa13 IS NULL OR sr.sfa13 = ' ' OR sr.sfa13 = 0
       THEN LET sr.sfa13 = 1 
       END IF
#No.FUN-7B0138--START--
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid02
#                                        LET l_orderA[g_i] =g_x[41]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid01
#                                        LET l_orderA[g_i] =g_x[42]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pid03
#                                        LET l_orderA[g_i] =g_x[43]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pie02
#                                        LET l_orderA[g_i] =g_x[44]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.sfb82
#                                        LET l_orderA[g_i] =g_x[45]    #TQC-6A0088
#               OTHERWISE LET l_order[g_i] = '-'
#                                        LET l_orderA[g_i] =''    #TQC-6A0088
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT r835_rep(sr.*)
        #CHI-B70047 --- modify --- start ---
	     IF sr.sfb02 MATCHES '[78]' THEN
             SELECT pmc03 INTO sr.gem02 FROM pmc_file WHERE pmc01 = sr.sfb82
         END IF
        #CHI-B70047 --- modify ---  end  ---
        EXECUTE insert_prep USING
             sr.pid01,sr.pid02,sr.pid022,sr.pid03,sr.pie02,sr.pie03,sr.pie04,sr.pie07,   #MOD-AC0094 add pid022
             sr.pie30,sr.pie40,sr.pie50,sr.pie60,sr.count,sr.ima02,sr.ima02,
             sr.ima08,sr.ima25,sr.sfa13,sr.sfb82,sr.gem02
            ,sr.pid012,sr.pid021     #FUN-A60092 add 
#No.FUN-7B0138--END
     END FOREACH
#No.FUN-7B0138--START
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = "Y" THEN 
         CALL cl_wcchp(tm.wc,'pid02,pid01,pid03,pie02,sfb82')
         RETURNING tm.wc
         LET l_str= tm.wc
     END IF
     LET l_str = l_str,";",tm.choice,";",tm.user,";",tm.s[1,1],";",tm.s[2,2],";",
                  tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.data
     IF g_sma.sma541 = 'N' THEN                           #FUN-A60092
        CALL cl_prt_cs3('aimr835','aimr835',g_sql,l_str)
     ELSE                                                   #FUN-A60092
        CALL cl_prt_cs3('aimr835','aimr835_1',g_sql,l_str)  #FUN-A60092      
     END IF                                                 #FUN-A60092
#    FINISH REPORT r835_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0138--END
END FUNCTION
 
#No.FUN-7B0138--START--
#REPORT r835_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr           RECORD 
#                       order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                       order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                       order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                       pid01  LIKE pid_file.pid01, #標籤號碼
#                       pid02  LIKE pid_file.pid02, #工單編號
#                       pid03  LIKE pid_file.pid03, #生產料件
#                       pie02  LIKE pie_file.pie02, #盤點料號
#                       pie03  LIKE pie_file.pie03, 
#                       pie04  LIKE pie_file.pie04, #發料單位
#                       pie07  LIKE pie_file.pie07, #項次
#                       pie30  LIKE pie_file.pie30, 
#                       pie40  LIKE pie_file.pie40, 
#                       pie50  LIKE pie_file.pie50, 
#                       pie60  LIKE pie_file.pie60, 
#                       count  LIKE pie_file.pie30, #盤點數量
#                       ima02  LIKE ima_file.ima02, #品名規格
#                       ima021 LIKE ima_file.ima021,#FUN-510017
#                       ima08  LIKE ima_file.ima08, #來源    
#                       ima25  LIKE ima_file.ima25, #庫存單位
#                       sfa13  LIKE sfa_file.sfa13, #發料/庫存轉換率
#                       sfb82  LIKE sfb_file.sfb82, #製造部門
#                       gem02  LIKE gem_file.gem02  #製造部門
#                       END RECORD,
#         l_amt  LIKE pie_file.pie30
#
#  OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.pid02 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno" 
#     PRINT g_head CLIPPED,pageno_total     
#     PRINT tm.data
#     PRINt g_str2
#     PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                      '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#     PRINT g_dash1 
#     LET l_last_sw = 'n'
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 11)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 11)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 11)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.pid02 
#     PRINT COLUMN g_c[31],sr.pid01,
#           COLUMN g_c[32],sr.pid02,
#           COLUMN g_c[33],sr.sfb82,
#           COLUMN g_c[34],sr.gem02;
 
#  ON EVERY ROW
#     NEED 2 LINES
#     PRINT COLUMN g_c[35],sr.pie02,
#           COLUMN g_c[36],sr.ima02,
#           COLUMN g_c[37],sr.ima021,
#           COLUMN g_c[38],sr.ima08,
#           COLUMN g_c[39],sr.pie04,
#           COLUMN g_c[40],cl_numfor(sr.count,40,3)
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'pid03,pid04,pid05,pid02,pid01')
#             RETURNING tm.wc
#        PRINT g_dash
##TQC-630166
##       IF tm.wc[001,080] > ' ' THEN
##       	       PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##       IF tm.wc[071,140] > ' ' THEN
##       	       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##       IF tm.wc[141,210] > ' ' THEN
##       	       PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash #No.TQC-5C0005
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash #No.TQC-5C0005
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-7B0138-END
