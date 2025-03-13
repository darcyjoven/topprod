# Prog. Version..: '5.10.00-08.01.04(00005)'     #
# Pattern name...: axdr223.4gl
# Descriptions...: 集團間銷售區域預估收入表
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,放寬ima02
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No:TQC-5B0045 05/11/08 By Smapmin 調整報表
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying　欄位形態定義為LIKE 
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/14 By xumin 報表表頭格式修改
# Modify.........: No:FUN-740082 07/05/23 By TSD.Achick報表改寫由Crystal Report產出

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition   #No.FUN-680108 VARCHAR(600)
              ada01   LIKE ada_file.ada01,
              a       LIKE type_file.chr1,    
              bdate   LIKE type_file.num10,  
              edate   LIKE type_file.num10,  
              more    LIKE type_file.chr1         # Input more condition(Y/N)  #No.FUN-680108 VARCHAR(1)
              END RECORD,
          g_sql   string,       # RDSQL STATEMENT  
          l_line  LIKE type_file.chr1000, #輸入打印報表頭的橫線 
          g_obd04 LIKE type_file.chr1000, #報表頭的l_line上的coc03          
          g_head2 LIKE type_file.chr1000, 
          g_cnt   LIKE type_file.num5,   
          g_value LIKE type_file.chr1000, #on every row中的金額數         
          g_no    LIKE type_file.num5,    #序號數 
          g_t     LIKE type_file.num5,    #(7-((g_cnt+1) mod 7 ))+g_cnt   
          g_obd   ARRAY[200] OF RECORD #coc03組合的矩陣
                  obd04 LIKE obd_file.obd04
                  END RECORD
DEFINE    g_azp01  LIKE azp_file.azp01
DEFINE    g_azp03  LIKE azp_file.azp03
DEFINE    g_azp03o LIKE azp_file.azp03

DEFINE    g_yy     LIKE type_file.num5,
          g_mm     LIKE type_file.num5,
          g_wk     LIKe type_file.num5, 
          g_xx     LIKE type_file.num5,  
          g_log    LIKE type_file.chr1    
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT

DEFINE l_table     STRING                       ### FUN-740082 add ###
DEFINE g_str       STRING                       ### FUN-740082 add ###

MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7) 
   LET tm.ada01= ARG_VAL(8)
   LET tm.a    = ARG_VAL(9)
   LET tm.bdate= ARG_VAL(10)
   LET tm.edate= ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF

   #str FUN-740082 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740082 *** ##
   LET g_sql = "obc021.obc_file.obc021,",
               "ima131.ima_file.ima131,",
               "obc01.obc_file.obc01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "l_amt1.obd_file.obd12,",
               "l_amt2.obd_file.obd07,",
               "l_no.type_file.num5,",
               "l_no1.type_file.num5,",
               "t_no.type_file.num5,",  
               "obd04_s.zaa_file.zaa08,",
               "head2_s.zaa_file.zaa08,",
               "value_s.zaa_file.zaa08,",
              # "line.zaa_file.zaa08,", 
               "line.type_file.chr1000,", 
               "obd07.obd_file.obd07"

   LET l_table = cl_prt_temptable('axdr223',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?)"

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#

   SELECT azp01,azp03 INTO g_azp01,g_azp03 FROM azp_file WHERE azp01 = g_plant
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      EXIT PROGRAM
   END IF
   LET g_azp03o = g_azp03

   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axdr223_tm(0,0)
      ELSE CALL axdr223()
   END IF

END MAIN

FUNCTION axdr223_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_log          LIKE type_file.chr1,
          l_cmd          LIKE type_file.chr1000 

   LET p_row = 5 LET p_col = 12
   OPEN WINDOW axdr223_w AT p_row,p_col
        WITH FORM "axd/42f/axdr223"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.ada01= g_plant
   LET tm.a    = '1'
   CALL r223_obc021()
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'

 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON obc01 HELP 1

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about     
         CALL cl_about()   
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION CONTROLP
            IF INFIELD(obc01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO obc01
               NEXT FIELD obc01
            END IF

      ON ACTION qbe_select
         CALL cl_qbe_select()

 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axdr223_w EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.ada01,tm.a,tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS HELP 1

      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD ada01
         IF cl_null(tm.ada01) THEN NEXT FIELD ada01 END IF
         SELECT * FROM ada_file WHERE ada01=tm.ada01
         IF SQLCA.sqlcode THEN
            CALL cl_err(tm.ada01,SQLCA.sqlcode,0)
            LET tm.ada01=g_plant
            DISPLAY BY NAME tm.ada01
         END IF

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
         CALL r223_obc021()
         DISPLAY tm.edate To edate

      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         CALL r223_date(tm.bdate)
         IF g_log = '0' THEN
             CALL cl_err('','axd-085',0)
             NEXT FIELD bdate
         END IF

      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         CALL r223_date(tm.edate)
         IF g_log = '0' THEN
             CALL cl_err('','axd-085',0)
             NEXT FIELD bdate
         END IF
         IF tm.bdate > tm.edate THEN NEXT FIELD bdate END IF

      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()

      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(ada01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_azp'
             LET g_qryparam.default1 = tm.ada01
             CALL cl_create_qry() RETURNING tm.ada01
             DISPLAY BY NAME tm.ada01
             NEXT FIELD ada01
         OTHERWISE
             EXIT CASE
      END CASE

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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axdr223_w EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axdr223'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr223','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.ada01 CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",    
                         " '",g_rep_clas CLIPPED,"'",    
                         " '",g_template CLIPPED,"'"     

         CALL cl_cmdat('axdr223',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axdr223_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axdr223()
   ERROR ""
END WHILE
   CLOSE WINDOW axdr223_w
END FUNCTION

FUNCTION r223_date(l_date)
DEFINE l_date   LIKE  obc_file.obc021
    LET g_log ='1'
    IF tm.a MATCHES '[12]' THEN
        IF l_date > 999999 OR l_date < 100001 THEN
           LET g_log = '0'
        END IF
        LET g_yy = l_date/100
        IF tm.a = '1' THEN
            LET g_mm = l_date-g_yy*100
            IF g_mm = 0  THEN
                LET g_log = '0'
            END IF
        ELSE
                LET g_wk = l_date-g_yy*100
                IF g_wk = 0 THEN
                    LET g_log = '0'
                END IF
            END IF
        END IF
    IF tm.a = '3' THEN
        IF l_date > 99999999 OR l_date < 10000001 THEN
            LET g_log = '0'
        END IF
        LET g_yy = l_date/10000
        LET g_xx = l_date - g_yy*10000
        LET g_mm = g_xx/100
        LET g_xx = g_xx - g_mm * 100
        IF (g_mm = 0 OR g_xx =0) THEN
            LET g_log = '0'
        END IF
    END IF
    IF g_mm > 12 OR g_wk > 53 OR g_xx > 3 THEN
        LET g_log = '0'
    END IF
END FUNCTION
 
FUNCTION r223_obc021()
DEFINE l_yy  LIKE type_file.num5,   
       l_mm  LIKE type_file.num5,   
       l_xx  LIKE type_file.num5,   
       l_wk  LIKE type_file.num5    
 
    LET l_yy = YEAR(g_today)
    LET l_mm = MONTH(g_today)
    LET l_xx = DAY(g_today)
    LET l_wk = 1
    IF l_xx < 11 THEN
        LET l_xx = 1
    ELSE
        IF l_xx < 21 THEN LET l_xx = 2
            ELSE LET l_xx = 3
        END IF
    END IF
    CASE tm.a
       WHEN  '1' LET tm.bdate = l_yy*100+l_mm
                 LET tm.edate = tm.bdate
       WHEN  '2' LET tm.bdate = l_yy*100+l_wk
                 LET tm.edate = tm.bdate
       WHEN  '3' LET tm.bdate = (l_yy*100+l_mm)*100+l_xx
                 LET tm.edate = tm.bdate
       OTHERWISE LET tm.bdate = ' '
                 LET tm.edate = tm.bdate
    END CASE
END FUNCTION

FUNCTION axdr223()
   DEFINE l_name    LIKE type_file.chr1000,  # External(Disk) file name
          l_name1   LIKE type_file.chr1000,  
          l_sql     LIKE type_file.chr1000,  # RDSQL STATEMENT 
          l_za05   LIKE za_file.za05,   
          l_i       LIKE type_file.num5,     
          l_len     LIKE type_file.num5,    
          l_len1    LIKE type_file.num5,   
          l_space1  LIKE type_file.num5,  
          l_space2  LIKE type_file.num5, 
          l_space3  LIKE type_file.num5,  
          l_space4  LIKE type_file.num5,  
          l_j       LIKE type_file.num5,  
          l_report  LIKE type_file.num5,  
          l_desc    LIKE type_file.chr20,
          l_obc021  LIKE obc_file.obc021,
          l_obd12   LIKE obd_file.obd12,
          l_obd07   LIKE obd_file.obd07,
          l_azp02   LIKE azp_file.azp02,
          sr        RECORD
                           obc021  LIKE obc_file.obc021,
                           ima131  LIKE ima_file.ima131,
                           obc01   LIKE obc_file.obc01,
                           ima02   LIKE ima_file.ima02,
                           ima021  LIKE ima_file.ima021,
                           ima25   LIKE ima_file.ima25,
                           l_amt1  LIKE obd_file.obd12,
                           l_amt2  LIKE obd_file.obd07,
                           l_no    LIKE type_file.num5,    #0-還有資料,1-本筆為最后一筆   #No.FUN-680108 SMALLINT
                           l_no1   LIKE type_file.num5,    #1--打印統計,0--不打印統計     #No.FUN-680108 SMALLINT
                           t_no    LIKE type_file.num5,    
                           obd04_s LIKE zaa_file.zaa08, #TQC-6A0095
                           head2_s LIKE zaa_file.zaa08, #TQC-6A0095
                           value_s LIKE zaa_file.zaa08, #TQC-6A0095
                           line    LIKE type_file.chr1000
                    END RECORD

   #str FUN-740082  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740082 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-740082  add

     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axdr223'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740082 add ###

     SELECT azp03 INTO g_azp03 FROM azp_file
      WHERE azp01 = tm.ada01
     IF SQLCA.sqlcode THEN
        CALL cl_err(tm.ada01,SQLCA.sqlcode,0)
        RETURN
     END IF

     DATABASE g_azp03

#####sr丟到report   on every row 的內容
     LET l_sql = "SELECT UNIQUE obc021,ima131,obc01,ima02,ima021,ima25,",
                 " SUM(obd12),SUM(obd07),0,0,COUNT(obd04),'','','','' ",
                 "  FROM obc_file,ima_file,obd_file ",
                 " WHERE obc01 = ima01 AND obc01 = obd01 ",
                 "   AND obc02 = obd02 AND obc021 = obd021 ",
                 "   AND obc02 = '",tm.a,"'",
                 "   AND obcacti = 'Y' AND obcconf = 'Y' ",
                 "   AND obc021 = ? ",
                 "   AND ",tm.wc CLIPPED,
                 " GROUP BY obc021,ima131,obc01,ima02,ima021,ima25 ",
                 " ORDER BY obc021,ima131,obc01 "

     PREPARE axdr223_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
     DECLARE axdr223_curs1 CURSOR FOR axdr223_prepare1
####select unique initial period of obc_file
     LET l_sql=" SELECT UNIQUE obc021 FROM obc_file,obd_file ",
               "  WHERE obc02 = '",tm.a,"' AND obc01=obd01 ",
               "    AND obc02 = obd02 AND obc021 = obd021 ",
               "    AND obcacti = 'Y' AND obcconf = 'Y' ",
               "    AND obc021 BETWEEN ",tm.bdate," AND ",tm.edate,
#               "    AND obd04 BETWEEN ",tm.bdate," AND ",tm.edate,
               "    AND ",tm.wc CLIPPED
     PREPARE axdr223_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
     DECLARE axdr223_curs2 CURSOR FOR axdr223_prepare2

#####select unique obd04 from obc021
     LET l_sql=" SELECT UNIQUE obd04 FROM obc_file,obd_file ",
               "  WHERE obc02 = '",tm.a,"' AND obc01=obd01 ",
               "    AND obc02 = obd02 AND obc021 = obd021 ",
               "    AND obcacti = 'Y' AND obcconf = 'Y' ",
               "    AND ",tm.wc CLIPPED," AND obc021=?"
     PREPARE axdr223_prepare4 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
     DECLARE obd04_curs CURSOR FOR axdr223_prepare4

     LET g_len = 241
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     LET g_pageno = 0

     CASE tm.a
          WHEN '1'  CALL cl_getmsg('axm-024',g_lang) RETURNING l_desc
          WHEN '2'  CALL cl_getmsg('axm-025',g_lang) RETURNING l_desc
          WHEN '3'  CALL cl_getmsg('axm-026',g_lang) RETURNING l_desc
     END CASE

     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=tm.ada01

     FOREACH axdr223_curs2 INTO l_obc021
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
         END IF
         FOR l_i = 1 TO 200
             INITIALIZE g_obd[l_i] TO NULL
         END FOR
         LET l_i = 1
         FOREACH obd04_curs USING l_obc021 INTO g_obd[l_i].obd04
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
            END IF
            LET l_i = l_i + 1
         END FOREACH
         LET g_cnt = l_i - 1   #obd04總數

         LET g_no = 1
####g_t=5-((g_cnt+1) mod 5) + (g_cnt+1) 多出的1指的是最后打印的小計
         LET l_i = (g_cnt + 1)/ 5
         IF (g_cnt+ 1) MOD 5 = 0 THEN
            LET g_t = g_cnt + 1
         ELSE
            LET g_t = (l_i + 1) * 5
         END IF
         FOR l_i = 1 TO g_t STEP 5   #每次5個obd04
             LET g_obd04=''
             LET g_head2=''
              LET l_line = '--------------------------- ------------------------------------------- ------------------------------------------- -------- ' #MOD-4B0067   #TQC-5B0045
             LET l_space1 = 0
             FOR l_j = 0 TO 4 #組g_obd04,g_line
                 LET g_obd04=g_obd04 CLIPPED,' ',l_space1 SPACES,
                             g_obd[l_i+l_j].obd04 USING "<<<<<<<<"
                 LET l_len = 0
                 LET l_space1 = 0
                 LET l_len  = LENGTH(g_obd[l_i+l_j].obd04)
                 LET l_space1 = 29 - l_len
                 IF l_space1 <> 29 THEN LET l_space3 = l_space1 END IF
                 IF l_len <>0 THEN
                    IF l_j=0 THEN
                       LET g_head2= g_head2 CLIPPED,'     數量           金額'
                    ELSE
                       LET g_head2= g_head2 CLIPPED,'           數量           金額'
                    END IF
                    LET l_line = l_line ,' -------------- --------------'
                 END IF
             END FOR
             FOREACH axdr223_curs1 USING l_obc021 INTO sr.*
                 IF SQLCA.sqlcode  THEN
                    CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                 END IF
                 LET g_value = ''
                 LET l_obd12 = 0
                 LET l_obd07 = 0
                 LET l_space4=0
                 FOR l_j = 0 TO 4
                     LET l_obd12=''
                     LET l_obd07=''
                     #當前obd01,obd02,obd021,obd04的obd12,obd07
                     SELECT obd12,obd07 INTO l_obd12,l_obd07 FROM obd_file
                      WHERE obd01=sr.obc01  AND obd02=tm.a
                        AND obd021=l_obc021 AND obd04=g_obd[l_i+l_j].obd04
                     IF cl_null(l_obd12) THEN LET l_obd12 = 0 END IF
                     IF cl_null(l_obd07) THEN LET l_obd07 = 0 END IF
                     #不打多余的0
                     IF l_i + l_j <= g_cnt THEN
                        IF sr.t_no>=l_i+l_j THEN
                           LET g_value = g_value CLIPPED,
                                         l_obd12 USING " --,---,--&.&&&",
                                         l_obd07 USING " --,---,--&.&&&"
                        ELSE
                           LET l_space4=l_space4+30
                        END IF
                     END IF
                 END FOR
                 LET sr.value_s = g_value
                 LET sr.obd04_s = g_obd04
                 LET sr.head2_s = g_head2
                 LET sr.line = l_line
                 #打完全部obd04之后的小計
                 LET sr.l_no=0
                 LET sr.l_no1=0
                 IF l_i > (g_cnt+1) - 5 THEN
                    IF l_i = g_cnt + 1 THEN   #該行只有小計
                       LET sr.l_no = 1
                       LET sr.l_no1= 1
                       LET sr.head2_s = sr.head2_s CLIPPED,'    ',
                                       #g_x[13] CLIPPED,'       ',
                                       #g_x[16] CLIPPED
                                        cl_getmsg("axd-116",g_lang),'       ',
                                        cl_getmsg("axd-117",g_lang)
                       LET sr.value_s = sr.value_s CLIPPED,
                                        sr.l_amt1 USING " --,---,--&.&&&",
                                        sr.l_amt2 USING " --,---,--&.&&&"
                    ELSE
                       LET sr.l_no = 0
                       LET sr.l_no1= 1
                       LET sr.head2_s = sr.head2_s CLIPPED,
                          #'          ',g_x[13] CLIPPED,
                          #'       ',g_x[16] CLIPPED
                           '          ',cl_getmsg("axd-116",g_lang),
                           '       ',cl_getmsg("axd-117",g_lang)
                       LET sr.value_s = sr.value_s CLIPPED,l_space4 SPACES,
                                        sr.l_amt1 USING " --,---,--&.&&&",
                                        sr.l_amt2 USING " --,---,--&.&&&"
                    END IF
                    LET sr.line = sr.line CLIPPED,' -------------- --------------'
                 END IF

         IF sr.l_no1=1 THEN
            LET g_sql="SELECT SUM(obd07) FROM obd_file,ima_file,obc_file",
                      " WHERE obc01=obd01 AND obc02=obd02 AND obc021=obd021 ",
                      "   AND ima01=obd01 ",
                      "   AND obcacti = 'Y' AND obcconf = 'Y' ",
                      "   AND obd02='",tm.a,"' AND obd021=",sr.obc021,
                      "   AND ",tm.wc
            IF cl_null(sr.ima131) THEN
               LET g_sql=g_sql CLIPPED," AND (ima131 IS NULL OR ima131='')"
            ELSE
               LET g_sql=g_sql CLIPPED," AND ima131='",sr.ima131,"'"
            END IF
            PREPARE axdr223_prepare3 FROM g_sql
            IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
            DECLARE axdr223_ima131 CURSOR FOR axdr223_prepare3
            OPEN axdr223_ima131
            FETCH axdr223_ima131 INTO l_obd07
            IF cl_null(l_obd07) THEN
               LET l_obd07 = 0
            END IF
         END IF

        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740082 *** ##
         EXECUTE insert_prep USING 
         sr.obc021, sr.ima131,  sr.obc01,   sr.ima02,   sr.ima021,
         sr.ima25,  sr.l_amt1,  sr.l_amt2,  sr.l_no,    sr.l_no1, 
         sr.t_no,   sr.obd04_s, sr.head2_s, sr.value_s, sr.line,
         l_obd07
       #------------------------------ CR (3) ------------------------------#

       #end FUN-740082 add 

             END FOREACH
         END FOR
     END FOREACH

   DATABASE g_azp03o

   #str FUN-740082 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740082 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'obc01')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",l_desc CLIPPED,";",tm.ada01,";",l_azp02
   CALL cl_prt_cs3('axdr223','axdr223',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740082 add 

     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END FUNCTION

