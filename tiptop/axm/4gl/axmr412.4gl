# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axmr412.4gl
# Descriptions...: 訂單生產進度表
# Date & Author..: 2006/07/07 by kim
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-760191 07/06/26 By jamie 報表列印時，語言別是英文
# Modify.........: No.FUN-7A0036 07/10/30 By baofei 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-940009 09/04/08 By sabrina (1)在select訂單時，加入未交量(oeb12-oeb24+oeb25-oeb26)>0的條件
#                                                    (2)在select工單時，加入生產數量(sfb08)-完工入庫量(sfb09)>0的條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B20091 11/02/18 By Summer 一張訂單若有多張工單時，會無法列印
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                           # Print condition RECORD
              wc        STRING,                # Where condition
              more      LIKE type_file.chr1    # No.FUN-680137 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
         g_oea00       LIKE oea_file.oea00
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose       #No.FUN-680137 SMALLINT
DEFINE   g_outprog     LIKE faj_file.faj02     # No.FUN-680137 VARCHAR(10)  #外部呼叫的程式代號
#No.FUN-760036---Begin
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING,                                                                                                       
       l_sql          STRING                                                                                                        
#No.FUN-760036---End  
#TQC-760191 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   LET g_outprog = ARG_VAL(1)
   LET g_oea00 = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)            # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-7A0036---Begin                                                                                                              
   LET g_sql = "oea01.oea_file.oea01,",                                                                                             
               "oea02.oea_file.oea02,",                                                                                             
               "oea03.oea_file.oea03,",
               "oea032.oea_file.oea032,",                                                                                             
               "oeb03.oeb_file.oeb03,",                                                                                             
               "oeb04.oeb_file.oeb04,",                                                                                             
               "oeb06.oeb_file.oeb06,",                                                                                             
               "oeb15.oeb_file.oeb15,",                                                                                             
               "sfb01.sfb_file.sfb01,",                                                                                             
               "sfb08.sfb_file.sfb08,",                                                                                             
               "sfb081.sfb_file.sfb081,",                                                                                             
               "sfb09.sfb_file.sfb09,",                                                                                           
               "sfb12.sfb_file.sfb12,",                                                                                           
               "sfb13.sfb_file.sfb13,",                                                                                             
               "sfb15.sfb_file.sfb15,",
               "sfb25.sfb_file.sfb25,",
               "sfb87.sfb_file.sfb87,",
               "ima021.ima_file.ima021,",
               "ima55.ima_file.ima55"                                                                                                                                     
   LET l_table = cl_prt_temptable('axmr412',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-7A0036---Begin                       
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80089    ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r412_tm(0,0)        # Input print condition
   ELSE 
      CALL r412()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
END MAIN
 
FUNCTION r412_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r412_w AT p_row,p_col WITH FORM "axm/42f/axmr412"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   # 共用程式時呼叫
   CALL cl_set_locale_frm_name("axmr412")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_oea00 = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea14,oeb04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(oea01) #查詢單据
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oea11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea01
               NEXT FIELD oea01
          WHEN INFIELD(oea03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               IF g_aza.aza50 = 'Y' THEN
                  LET g_qryparam.form ="q_occ3"
               ELSE
                  LET g_qryparam.form ="q_occ"
               END IF
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea03
               NEXT FIELD oea03
          WHEN INFIELD(oea14)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
          WHEN INFIELD(oeb04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               IF g_aza.aza50 = 'Y' THEN
                  LET g_qryparam.form ="q_ima15"
               ELSE
                  LET g_qryparam.form ="q_ima"
               END IF
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oeb04
               NEXT FIELD oeb04
          OTHERWISE 
               EXIT CASE
       END CASE
 
     ON ACTION locale
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r412_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r412_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr412'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr412','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_prog  CLIPPED,"'",
                         " '",g_oea00  CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('axmr412',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r412_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r412()
   ERROR ""
END WHILE
   CLOSE WINDOW r412_w
END FUNCTION
 
FUNCTION r412()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     STRING,            # RDSQL STATEMENT
          sr        RECORD
                       oeb04  LIKE oeb_file.oeb04 ,
                       oeb06  LIKE oeb_file.oeb06 ,
                       sfb01  LIKE sfb_file.sfb01 ,
                       sfb08  LIKE sfb_file.sfb08 ,
                       sfb081 LIKE sfb_file.sfb081,
                       sfb12  LIKE sfb_file.sfb12 ,
                       sfb13  LIKE sfb_file.sfb13 ,
                       sfb25  LIKE sfb_file.sfb25 ,
                       oea03  LIKE oea_file.oea03 ,
                       oeb15  LIKE oeb_file.oeb15 ,
                       ima55  LIKE ima_file.ima55 ,
                       ima021 LIKE ima_file.ima021,
                       oea01  LIKE oea_file.oea01 ,
                       oeb03  LIKE oeb_file.oeb03 ,
                       sfb87  LIKE sfb_file.sfb87 ,
                       sfb09  LIKE sfb_file.sfb09 ,
                       sfb15  LIKE sfb_file.sfb15 ,
                       oea02  LIKE oea_file.oea02 ,
                       oea032 LIKE oea_file.oea032
                    END RECORD
     CALL  cl_del_data(l_table)                    #No.FUN-7A0036
    # CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0094
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-7A0036
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT oeb04,oeb06,'','','','','','',",
                 "oea03,oeb15,'','',oea01,oeb03,'','','',",
                 "oea02,oea032 FROM oea_file,oeb_file",
                 " WHERE oea01=oeb01",
                 " AND (oeb12 - oeb24 + oeb25 - oeb26) > 0 ",      #TQC-940009 add
                 " AND ",tm.wc CLIPPED,
                 " ORDER BY oeb04,oea01,oeb03"
     
     PREPARE r412_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
     DECLARE r412_curs1 CURSOR FOR r412_prepare1
#No.FUN-7A0036---Begin
#     CALL cl_outnam('axmr412') RETURNING l_name
#     CALL cl_prt_pos_len()
#     IF (NOT cl_null(g_outprog)) AND (g_outprog<>g_prog) THEN
#        LET g_x[4]='(',g_outprog,')'
#     END IF
#     START REPORT r412_rep TO l_name     
#     LET g_pageno = 0
#No.FUN-7A0036---End
     FOREACH r412_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF          
       #MOD-B20091 mark --start--
       #SELECT sfb01,sfb08,sfb081,sfb12,sfb13,sfb25,sfb87,sfb09,sfb15
       #  INTO sr.sfb01,sr.sfb08,sr.sfb081,sr.sfb12,sr.sfb13,sr.sfb25,
       #       sr.sfb87,sr.sfb09,sr.sfb15
       #  FROM sfb_file
       # WHERE sfb22 =sr.oea01
       #   AND sfb221=sr.oeb03
       #   AND sfbacti='Y'
       #   AND (sfb08 - sfb09) > 0     #TQC-940009 add
       #MOD-B20091 mark --end--
        #MOD-B20091 add --start--
        LET l_sql = "SELECT sfb01,sfb08,sfb081,sfb12,sfb13,sfb25,sfb87,sfb09,sfb15",
                    "  FROM sfb_file ",
                    " WHERE sfb22 = '",sr.oea01,"'",
                    "   AND sfb221 = ",sr.oeb03,
                    "   AND sfbacti='Y'",
                    "   AND (sfb08 - sfb09) > 0"
        PREPARE r412_prepare2 FROM l_sql
        DECLARE r412_curs2 CURSOR FOR r412_prepare2
        FOREACH r412_curs2 INTO sr.sfb01,sr.sfb08,sr.sfb081,sr.sfb12,sr.sfb13,
                                sr.sfb25,sr.sfb87,sr.sfb09,sr.sfb15

        #MOD-B20091 add --end--
           IF SQLCA.sqlcode THEN
              LET sr.sfb01 = NULL
              LET sr.sfb08 = NULL
              LET sr.sfb081= NULL
              LET sr.sfb12 = NULL
              LET sr.sfb13 = NULL
              LET sr.sfb25 = NULL
              LET sr.sfb87 = NULL
              LET sr.sfb09 = NULL
              LET sr.sfb15 = NULL
           END IF
           SELECT ima55,ima021 INTO sr.ima55,sr.ima021 
             FROM ima_file 
            WHERE ima01=sr.oeb04
           IF SQLCA.sqlcode THEN
              LET sr.ima55 =NULL
              LET sr.ima021=NULL
           END IF
#           OUTPUT TO REPORT r412_rep(sr.*)       #No.FUN-7A0036
            EXECUTE insert_prep USING  sr.oea01,sr.oea02,sr.oea03,sr.oea032,sr.oeb03,
                                       sr.oeb04,sr.oeb06,sr.oeb15,sr.sfb01,sr.sfb08,
                                       sr.sfb081,sr.sfb09,sr.sfb12,sr.sfb13,sr.sfb15,
                                       sr.sfb25,sr.sfb87,sr.ima021,sr.ima55     #No.FUN-7A0036
        END FOREACH #MOD-B20091 add
     END FOREACH
#No.FUN-7A0036---Begin
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea14,oeb04')                                                                                      
        RETURNING tm.wc                                                                                                             
   END IF                                                                                                                           
   LET g_str=tm.wc                                                                                                                                   
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
   CALL cl_prt_cs3('axmr412','axmr412',l_sql,g_str)  
#     FINISH REPORT r412_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0094
#No.FUN-7A0036---End
END FUNCTION
#No.FUN-7A0036---Begin
{
REPORT r412_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          sr        RECORD
                       oeb04  LIKE oeb_file.oeb04 ,
                       oeb06  LIKE oeb_file.oeb06 ,
                       sfb01  LIKE sfb_file.sfb01 ,
                       sfb08  LIKE sfb_file.sfb08 ,
                       sfb081 LIKE sfb_file.sfb081,
                       sfb12  LIKE sfb_file.sfb12 ,
                       sfb13  LIKE sfb_file.sfb13 ,
                       sfb25  LIKE sfb_file.sfb25 ,
                       oea03  LIKE oea_file.oea03 ,
                       oeb15  LIKE oeb_file.oeb15 ,
                       ima55  LIKE ima_file.ima55 ,
                       ima021 LIKE ima_file.ima021,
                       oea01  LIKE oea_file.oea01 ,
                       oeb03  LIKE oeb_file.oeb03 ,
                       sfb87  LIKE sfb_file.sfb87 ,
                       sfb09  LIKE sfb_file.sfb09 ,
                       sfb15  LIKE sfb_file.sfb15 ,
                       oea02  LIKE oea_file.oea02 ,
                       oea032 LIKE oea_file.oea032
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.oeb04,sr.oea01,sr.oeb03
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash
      CALL cl_prt_pos_dyn()
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[50],g_x[34],g_x[35],
                     g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
                     g_x[47],g_x[51],g_x[48],g_x[49],g_x[52]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
       PRINTX name=D1 COLUMN g_c[31],sr.oeb04,
                      COLUMN g_c[32],sr.oeb06,
                      COLUMN g_c[33],sr.sfb01,
                      COLUMN g_c[34],cl_numfor(sr.sfb08,34,3),
                      COLUMN g_c[35],cl_numfor(sr.sfb081,35,3),
                      COLUMN g_c[36],cl_numfor(sr.sfb12,36,3),
                      COLUMN g_c[37],sr.sfb13,
                      COLUMN g_c[38],sr.sfb25,
                      COLUMN g_c[39],sr.oea03,
                      COLUMN g_c[40],sr.oeb15
                      
       PRINTX name=D2 COLUMN g_c[41],sr.ima55,
                      COLUMN g_c[43],sr.ima021,
                      COLUMN g_c[44],sr.oea01,
                      COLUMN g_c[45],cl_numfor(sr.oeb03,45,0),
                      COLUMN g_c[46],sr.sfb87,
                      COLUMN g_c[47],cl_numfor(sr.sfb09,47,3),
                      COLUMN g_c[48],sr.sfb15,
                      COLUMN g_c[49],sr.oea02,
                      COLUMN g_c[52],sr.oea032
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
      
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.FUN-580005
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-7A0036---End
