# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axrr200.4gl
# Descriptions...: 信用狀檢查表 CHECK LIST PRINTING
# Date & Author..: 97/08/01 By Sophia 
# Modify.........: No.FUN-4C0100 05/01/26 By Smapmin 調整單價.金額.匯率大小
# Modify.........: NO.FUN-550071 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-580010 05/08/05 By yoyo 憑証類報表原則修改 
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/12 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-B90041 11/09/05 By minpp 程序撰写规范修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      VARCHAR(1000),            # Where condition
              more    VARCHAR(01)               # Input more condition(Y/N)
              END RECORD,
#         g_dash1     VARCHAR(136),
          g_zo041     LIKE zo_file.zo041,
          g_zo042     LIKE zo_file.zo042
 
   DEFINE    prog_name    VARCHAR(30)
   DEFINE    tax          LIKE  oea_file.oea211
 
DEFINE   j               SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B90041
   
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL axrr200_tm(0,0)             # Input print condition
   ELSE
      CALL axrr200()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
END MAIN
 
FUNCTION axrr200_tm(p_row,p_col)
   DEFINE p_row,p_col    SMALLINT,
          l_cmd          VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW axrr200_w AT p_row,p_col
        WITH FORM "axr/42f/axrr200" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ola11,ola01,ola04 
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
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('olauser', 'olagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr200_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr200_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr200','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr200',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr200_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr200()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr200_w
END FUNCTION
 
FUNCTION axrr200()
   DEFINE l_name    VARCHAR(20),        # External(Disk) file name
          l_time    VARCHAR(8),         # Used time for running the job
          #l_sql     VARCHAR(1000),
          l_sql   STRING,      #NO.FUN-910082
          sra       RECORD  LIKE  ola_file.*,
          srb       RECORD  LIKE  olb_file.*,
          l_za05    VARCHAR(40) 
   # CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
     SELECT zo02,zo041,zo042 INTO g_company,g_zo041,g_zo042
       FROM zo_file WHERE zo01 = g_lang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrr200'
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND olauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND olagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     LET l_sql="SELECT * FROM  ola_file, olb_file ",
               "WHERE ola01 = olb01 AND olaconf != 'X' ", #010806增
               " AND ",tm.wc
 
     PREPARE axrr200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
        EXIT PROGRAM 
     END IF
     DECLARE axrr200_curs1 CURSOR FOR axrr200_prepare1
 
     CALL cl_outnam('axrr200') RETURNING l_name
     START REPORT axrr200_rep TO l_name
 
     LET   j            = 0
     LET   g_pageno     = 0
     FOREACH axrr200_curs1 INTO sra.*, srb.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       
      #FUN-A60056--mod--str--
      #SELECT oea211 INTO tax 
      #    FROM oea_file WHERE oea01 = srb.olb04
       LET l_sql = "SELECT oea211 FROM ",cl_get_target_table(sra.ola41,'oea_file'),
                   " WHERE oea01 = '",srb.olb04,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,sra.ola41) RETURNING l_sql
       PREPARE sel_oea211 FROM l_sql
       EXECUTE sel_oea211 INTO tax
      #FUN-A60056--mod--end
 
       OUTPUT TO REPORT axrr200_rep(sra.*,srb.*,tax) 
       LET j = j + 1
       message g_x[41] CLIPPED,j 
       CALL ui.Interface.refresh() #CKP 
 
     END FOREACH
 
     FINISH REPORT axrr200_rep
 
     IF  j  <>  0  THEN
         CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     ELSE
         CALL cl_err('','axr-334',1)
     END IF
      # CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
     #No.FUN-BB0047--mark--Begin---
     #   CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90041
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT axrr200_rep(sra,srb,tax)
   DEFINE l_last_sw    VARCHAR(1)
   DEFINE l_flag       VARCHAR(1)
   DEFINE l_buf        VARCHAR(30)             
   DEFINE s_azi03      LIKE azi_file.azi03
   DEFINE s_azi04      LIKE azi_file.azi04
   DEFINE s_azi05      LIKE azi_file.azi05
   DEFINE s_azi07      LIKE azi_file.azi07
   DEFINE sra   RECORD  LIKE  ola_file.*       
   DEFINE srb   RECORD  LIKE  olb_file.*       
   DEFINE tax   LIKE   oea_file.oea211
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin  #FUN-580098 
         PAGE LENGTH g_page_line
  ORDER BY sra.ola01, srb.olb02, srb.olb04, srb.olb05
  FORMAT
   PAGE HEADER 
      SKIP  1  LINE
    # PRINT '~it24w2z2'
      PRINT COLUMN 30, g_x[1]
    # PRINT '~it24w1z1'
      PRINT ''
 
      SELECT zx02 INTO g_user FROM zx_file WHERE zx01 = sra.olauser
 
   BEFORE GROUP OF sra.ola01
      SKIP  TO  TOP  OF  PAGE
      PRINT COLUMN 001,"FROM:",g_user,
            COLUMN 050,g_x[2] CLIPPED,g_today," ",TIME
      PRINT COLUMN 001,g_x[11] CLIPPED,
            COLUMN 044,g_x[12] CLIPPED
      PRINT COLUMN 001,g_x[46],g_x[47],g_x[50]
 
      IF sra.ola11 = '1' THEN LET l_buf = g_x[20]
                         ELSE LET l_buf = g_x[21] END IF
      PRINT COLUMN 001,g_x[13] CLIPPED, sra.ola01 CLIPPED
      PRINT 
      PRINT COLUMN 001,g_x[14] CLIPPED, sra.ola04 CLIPPED,
            COLUMN 041,g_x[15] CLIPPED, l_buf CLIPPED
      PRINT
 
      IF sra.ola28 = 'Y' THEN LET l_buf = g_x[16]
                         ELSE LET l_buf = g_x[17] END IF
 
      PRINT COLUMN 001,g_x[18] CLIPPED,
            COLUMN 041, l_buf CLIPPED
      PRINT
      PRINT COLUMN 001,g_x[19] CLIPPED, 
            COLUMN 041, sra.ola24 CLIPPED
      PRINT
      PRINT COLUMN 001,g_x[22] CLIPPED, 
            COLUMN 041, sra.ola21 CLIPPED 
      PRINT
      PRINT COLUMN 001,g_x[23] CLIPPED,
            COLUMN 041, sra.ola14 CLIPPED
      PRINT
      PRINT COLUMN 001,g_x[24] CLIPPED,
            COLUMN 041, sra.ola25 CLIPPED
      PRINT
      
      SELECT azi03,azi04,azi05 INTO s_azi03,s_azi04 ,s_azi05
          FROM azi_file WHERE azi01 = sra.ola06 
 
      PRINT COLUMN 001,g_x[25] CLIPPED, 
            COLUMN 041,sra.ola06," ",cl_numfor(sra.ola09,18,s_azi04) CLIPPED
      IF sra.ola07 <> 0 THEN
         PRINT COLUMN 001,g_x[26],
               COLUMN 041,sra.ola06," ",cl_numfor(sra.ola07,10,s_azi07) CLIPPED
      ELSE
         PRINT
      END IF
      PRINT g_x[27] CLIPPED 
 
      LET  l_buf  =''
      SELECT oag02 INTO l_buf FROM oag_file WHERE oag01 = sra.ola15
      PRINT COLUMN 5,"Confirm Payment:           ",COLUMN 41,l_buf CLIPPED
      PRINT
      IF sra.ola16 = 'Y' THEN LET l_buf = g_x[16] 
                         ELSE LET l_buf = g_x[17] END IF
      PRINT COLUMN 01,g_x[28] CLIPPED,
            COLUMN 41,l_buf CLIPPED
      
      IF sra.ola29 = 'Y' THEN LET l_buf = g_x[29]
                         ELSE LET l_buf = g_x[30] 
      END IF   
 
      PRINT
      PRINT COLUMN 1,g_x[31] CLIPPED,
            COLUMN 41, l_buf CLIPPED
      PRINT
      PRINT g_x[32] CLIPPED,g_x[33]
      PRINT
#No.FUN-580010--start 
      PRINTX name=H1 g_x[51],g_x[52],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58]
      PRINTX name=H2 g_x[53]
      PRINT g_dash1
#No.FUN-580010--end
      LET   l_flag  =  "N"
 
   ON EVERY ROW
      LET  l_flag  =  "N"
      LET  l_buf   =  ""
#No.FUN-580010--start
      PRINTX name=D1
            COLUMN g_c[51],srb.olb04,
            COLUMN g_c[52],srb.olb05 USING "###&", #FUN-590118
#           COLUMN 21,srb.olb11[1,18],
            COLUMN g_c[54],cl_numfor(srb.olb07,54,2),
            COLUMN g_c[55],srb.olb03 CLIPPED,
            COLUMN g_c[56],cl_numfor(srb.olb06,56,s_azi03),
            COLUMN g_c[57],cl_numfor(srb.olb08,57,s_azi04),
            COLUMN g_c[58],cl_numfor(srb.olb08 * ((tax / 100) / (1 + tax / 100)) ,
                      58,s_azi04)
      PRINTX name=D2 COLUMN g_c[53],srb.olb11
   AFTER GROUP OF sra.ola01
      PRINT g_dash2[1,g_len]
     PRINT COLUMN g_c[56],cl_numfor(GROUP SUM(srb.olb07),56,2),
           COLUMN g_c[57],cl_numfor(GROUP SUM(srb.olb08),57,s_azi05),
           COLUMN g_c[58],
#No.FUN-550071 --end--
            cl_numfor(GROUP SUM(srb.olb08) * ((tax / 100) / (1 + tax / 100)) ,
                      58,s_azi05) 
#No.FUN-580010--end
      PRINT
 
      IF sra.ola17 = "Y" THEN LET l_buf = g_x[16]
                         ELSE LET l_buf = g_x[17]  END IF
   
      PRINT COLUMN 1,g_x[34],
            COLUMN 41, l_buf CLIPPED
      PRINT
           
      IF sra.ola18 = "Y" THEN LET l_buf = g_x[16] 
                         ELSE LET l_buf = g_x[17]  END IF
   
      PRINT COLUMN 1,g_x[40] CLIPPED,
            COLUMN 41, l_buf CLIPPED
      CASE  sra.ola19  
          WHEN  "1"  LET l_buf = g_x[35]
          WHEN  "2"  LET l_buf = g_x[36]
          WHEN  "3"  LET l_buf = g_x[37]
      END CASE
      PRINT
      PRINT COLUMN 1,g_x[38] CLIPPED,l_buf CLIPPED
      PRINT
      LET l_buf = ''
      CASE  sra.ola20  
          WHEN  "1"  LET l_buf = g_x[35]
          WHEN  "2"  LET l_buf = g_x[36]
          WHEN  "3"  LET l_buf = g_x[37]
      END CASE
      PRINT COLUMN 1,g_x[41] CLIPPED, l_buf CLIPPED
 
      PRINT
      LET  l_flag  =  "N"
END REPORT
