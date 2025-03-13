# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
#Pattern name...: abxr112.4gl
# Descriptions...: ECN 明細表維護作業
# Date & Author..: 97/03/28 By Elaine
 # Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima021
# Modify.........: 05/02/23 By cate 報表標題標準化
# Modify.........: No.FUN-550033 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560239 05/06/27 By Melody QPA改為 dec(16,8)
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/08 By xumin 報表寬度調整
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              bmb24   LIKE bmb_file.bmb24,    #No.FUN-550033
              bdate   LIKE type_file.dat,     #No.FUN-680062     #No.FUN-680062  DATE
              edate   LIKE type_file.dat,     #No.FUN-680062     #No.FUN-680062  DATE
              doc_no  LIKE type_file.chr4,      #No.FUN-680062     VARCHAR(04)
              se_no   LIKE type_file.chr4,      #No.FUN-680062     VARCHAR(04)
              more    LIKE type_file.chr1     #No.FUN-680062     VARCHAR(1)
              END RECORD,
          g_mount       LIKE type_file.num10,         #No.FUN-680062 INTEGER
          l_cnt         LIKE type_file.num5,          #No.FUN-680062 SMALLINT
          l_bmb03       LIKE bmb_file.bmb03, #FUN-5B0013 20->40   #No.FUN-680062CHAR(40) 
          g_bmb01       LIKE bmb_file.bmb03, #FUN-5B0013 20->40   #No.FUN-680062 VARCHAR(40)
          g_ima02       LIKE ima_file.ima02, #FUN-5B0013 30->60   #No.FUN-680062 VARCHAR(60)
          l_code        LIKE type_file.chr1,                   #No.FUN-680062 VARCHAR(01)
          g_dash1_1 	LIKE type_file.chr1000,		# Dash line #No.FUN-680062 VARCHAR(300)
          l_cmd         LIKE type_file.chr1000       #No.FUN-680062CHAR(1000)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.bmb24 = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.doc_no = ARG_VAL(10)
   LET tm.se_no = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r112_tm(4,15)        # Input print condition
      ELSE CALL r112()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION r112_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680062SMALLINT
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW abxr112_w AT p_row,p_col
        WITH FORM "abx/42f/abxr112"
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
   INPUT BY NAME tm.bmb24,tm.bdate,tm.edate,tm.doc_no,tm.se_no,tm.more
   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
 
 
 
      AFTER FIELD bmb24
           IF cl_null(tm.bmb24) THEN NEXT FIELD bmb24 END IF
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr112_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr112'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr112','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.bmb24   CLIPPED,"'",
                         " '",tm.bdate   CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",tm.doc_no   CLIPPED,"'",
                         " '",tm.se_no   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('abxr112',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r112()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr112_w
END FUNCTION
 
FUNCTION r112()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680062   VARCHAR(1000)          
          l_chr     LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,           #No.FUN-680062  VARCHAR(40)
          l_bmb01   LIKE bmb_file.bmb01, #FUN-5B0013 20->60    #No.FUN-680062  VARCHAR(40)
          q_bmb01   LIKE bmb_file.bmb01, #FUN-5B0013 20->40   #No.FUN-680062  VARCHAR(40)
          l_ima02   LIKE ima_file.ima02, #FUN-5B0013 30->60    #No.FUN-680062   VARCHAR(60)
          br              RECORD  code       LIKE type_file.chr1,    #No.FUN-680062char(1)  
                                  bmb061     LIKE bmb_file.bmb06,    #No.FUN-560230   #No.FUN-680062  decimal(16,8)
                                  bmb062     LIKE bmb_file.bmb06,    #No.FUN-560230   #No.FUN-680062  decimal(16,8)
                                  bmb031     LIKE type_file.chr20,   #No.FUN-680062   VARCHAR(20)
                                  bmb032     LIKE type_file.chr20,   #No.FUN-680062   VARCHAR(20)
                                  ima021     LIKE ima_file.ima02, #FUN-5B0013 30->60    #No.FUN-680062  VARCHAR(60)
                                  ima022     LIKE ima_file.ima02, #FUN-5B0013 30->60    #No.FUN-680062  VARCHAR(60)
                                  bmb01      LIKE bmb_file.bmb01, #FUN-5B0013 20->40    #No.FUN-680062  VARCHAR(40) 
                                  bmb03      LIKE bmb_file.bmb03, #FUN-5B0013 20->40    #No.FUN-680062  VARCHAR(40)
                                  bmb10      LIKE bmb_file.bmb10,                       #No.FUN-680062  VARCHAR(04) 
                                  bmb04      LIKE bmb_file.bmb04, #No.FUN-680062    date    
                                  bmb05      LIKE bmb_file.bmb05, #No.FUN-680062    date
                                  bmb24      LIKE bmb_file.bmb24    #No.FUN-550033
                        END RECORD,
          sr               RECORD bmb01  LIKE bmb_file.bmb01, #主件料件編號
                                  bmb03  LIKE bmb_file.bmb03,
                                  ima02  LIKE ima_file.ima02,
                                  bmb06  LIKE bmb_file.bmb06,
                                  bmb10  LIKE bmb_file.bmb10,
                                  bmb04  LIKE bmb_file.bmb04,
                                  bmb05  LIKE bmb_file.bmb05,
                                  bmb24  LIKE bmb_file.bmb24
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_x[1]='產品原料異動表'
     LET g_x[2]='製表日期:'
     LET g_x[4]='(abxr112)'
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abxr112'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '=' END FOR
 
     LET l_bmb03 =' '
     LET l_code =' '
     LET l_bmb01 =' '
     LET l_sql = "SELECT bmb01,bmb03,ima02,bmb06,bmb10, ",
                 "       bmb04,bmb05,bmb24 ",
                 "  FROM bmb_file, ima_file  ",
                 " WHERE bmb03 = ima01 ",
                 "   AND ima15 <> 'N' ",
                 "   AND bmb24='",tm.bmb24,"'",
                 "   AND ((bmb04 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"') OR",
                 "   (bmb05 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'))",
                 "   AND bmb04 <> '9999/01/01' ", #若生效日為01/01/99,即表示
                 "  ORDER BY bmb03,bmb05 "      #此料號為option,且未生效
 
     PREPARE r112_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('preparegg:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM
           
     END IF
     DECLARE r112_curs1 CURSOR FOR r112_prepare1
 
     CALL cl_outnam('abxr112') RETURNING l_name
     START REPORT r112_rep1 TO l_name
     START REPORT r112_rep2 TO 'abxr112.ou2'
     START REPORT r112_rep3 TO 'abxr112.ou3'
     LET g_pageno = 0
     LET l_cnt=0
     OUTPUT TO REPORT r112_rep3()
     FOREACH r112_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.bmb06) THEN LET sr.bmb06 = 0 END IF
       LET br.bmb01=sr.bmb01
       LET br.bmb04=sr.bmb04
       LET br.bmb05=sr.bmb05
       LET br.bmb24=sr.bmb24
       LET br.bmb10=sr.bmb10
       IF sr.bmb04 <= sr.bmb05  THEN
          LET br.code='D'
          LET br.bmb061=sr.bmb06
          LET br.bmb062=0
          LET br.bmb031=sr.bmb03
          LET br.bmb032=' '
          LET br.ima021=sr.ima02
          LET br.ima022='NONE'
       ELSE
          LET br.code='A'
          LET br.bmb061=0
          LET br.bmb062=sr.bmb06
          LET br.bmb031=' '
          LET br.bmb032=sr.bmb03
          LET br.ima021='NONE'
          LET br.ima022=sr.ima02
       END IF
       IF (sr.bmb01[1,2]='90' OR sr.bmb01[1,2]='92' OR sr.bmb01[1,2]='94') THEN
           IF l_bmb03<>sr.bmb03 OR l_code<>br.code  THEN
              OUTPUT TO REPORT r112_rep1(br.*)
              LET l_bmb03=sr.bmb03
              LET l_code=br.code
           END IF
#若主件編號為90/92/94階, 則須往上展至97/98階,並將之列印至r112_rep2
           CALL r112_bom(sr.bmb01)
       ELSE
           IF l_bmb03<>sr.bmb03 OR l_code<>br.code THEN
              OUTPUT TO REPORT r112_rep1(br.*)
              LET l_bmb03=sr.bmb03
              LET l_code=br.code
           END IF
           IF l_bmb01<>sr.bmb01 THEN
              OUTPUT TO REPORT r112_rep2(sr.bmb01)
              LET l_bmb01=sr.bmb01
              CALL r112_bom(sr.bmb01)
           ELSE
              LET l_bmb01=sr.bmb01
           END IF
       END IF
     END FOREACH
     FINISH REPORT r112_rep1
     FINISH REPORT r112_rep2
     FINISH REPORT r112_rep3
 
     LET l_cmd='cat ','abxr112.ou2','>>',l_name
     RUN l_cmd WITHOUT WAITING
 
     IF tm.doc_no IS NOT NULL AND tm.doc_no <>' ' THEN
        LET l_cmd='cat ','abxr112.ou3','>>',l_name
        RUN l_cmd WITHOUT WAITING
     END IF
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION r112_bom(p_bmb01)
   DEFINE    p_bmb01       LIKE bmb_file.bmb01,#FUN-5B0013 20->40   #No.FUN-680062 VARCHAR(40) 
             arrno         LIKE type_file.num5,          #No.FUN-680062     smallint
             l_ac,i        LIKE type_file.num5,          #No.FUN-680062     smallint
             l_tot         LIKE type_file.num5,          #No.FUN-680062     smallint
          sr  DYNAMIC ARRAY OF RECORD
              bmb01    LIKE bmb_file.bmb01 #FUN-5B0013 20->40   #No.FUN-680062  VARCHAR(40)
              END RECORD
 
   LET arrno = 301
   DECLARE a112_cur CURSOR FOR
    SELECT bmb01 FROM bmb_file
     WHERE bmb03=p_bmb01
     ORDER BY bmb01
 
   LET l_ac =1
   FOREACH a112_cur INTO sr[l_ac].*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     LET l_ac = l_ac + 1
     IF l_ac > arrno THEN EXIT FOREACH END IF
   END FOREACH
 
   LET l_tot = l_ac - 1
   FOR i = 1 TO l_tot
     IF  sr[i].bmb01[1,2] = '98' THEN
        OUTPUT TO REPORT r112_rep2(sr[i].bmb01)
     ELSE
        IF sr[i].bmb01[1,2] = '97' THEN
           OUTPUT TO REPORT r112_rep2(sr[i].bmb01)
           CALL r112_bom(sr[i].bmb01)
        ELSE
           IF sr[i].bmb01 MATCHES 'Z*' THEN  #在ima_file及bmb_file中發現
              CONTINUE FOR
           ELSE
              CALL r112_bom(sr[i].bmb01)         #料號'z28'
           END IF
        END IF
     END IF
   END FOR
END FUNCTION
 
REPORT r112_rep1(br)
   DEFINE
          l_last_sw    LIKE type_file.chr1,      #No.FUN-680062  VARCHAR(1)
          l_sql1       LIKE type_file.chr1000,   #No.FUN-680062 VARCHAR(1000)
 
          sr              RECORD  cnt        LIKE type_file.num5,     #No.FUN-680062  smallint
                                  code       LIKE type_file.chr1,     #No.FUN-680062  VARCHAR(1)
                                  bmb031     LIKE type_file.chr20,    #No.FUN-680062  VARCHAR(20)
                                  bmb032     LIKE type_file.chr20,    #No.FUN-680062  VARCHAR(20)
                                  bmb061     LIKE bmb_file.bmb06,     #No.FUN-560230  #No.FUN-680062  decimal(16,8)
                                  bmb062     LIKE bmb_file.bmb06,     #No.FUN-560230  #No.FUN-680062  decimal(16,8)
                                  bmb10      LIKE bmb_file.bmb10,     #No.FUN-680062  VARCHAR(4)
                                  ima021     LIKE ima_file.ima02, #FUN-5B0013 30->60  #No.FUN-680062  VARCHAR(60)
                                  ima022     LIKE ima_file.ima02 #FUN-5B0013 30->60   #No.FUN-680062  VARCHAR(60)
                          END RECORD,
          br              RECORD  code       LIKE type_file.chr1,                       #No.FUN-680062  VARCHAR(1)
                                  bmb061     LIKE bmb_file.bmb06, #No.FUN-560230        #No.FUN-680062  decimal(16,8)
                                  bmb062     LIKE bmb_file.bmb06, #No.FUN-560230        #No.FUN-680062  decimal(16,8)
                                  bmb031     LIKE type_file.chr20,    #No.FUN-680062   VARCHAR(20)
                                  bmb032     LIKE type_file.chr20,    #No.FUN-680062   VARCHAR(20) 
                                  ima021     LIKE ima_file.ima02,#FUN-5B0013 30->60    #No.FUN-680062  VARCHAR(60)
                                  ima022     LIKE ima_file.ima02,#FUN-5B0013 30->60    #No.FUN-680062   VARCHAR(60)
                                  bmb01      LIKE bmb_file.bmb01, #FUN-5B0013 20->40   #No.FUN-680062   VARCHAR(40)
                                  bmb03      LIKE bmb_file.bmb03, #FUN-5B0013 20->40   #No.FUN-680062   VARCHAR(40)
                                  bmb10      LIKE bmb_file.bmb10,    #No.FUN-680062    VARCHAR(04)
                                  bmb04      LIKE bmb_file.bmb04,    #No.FUN-680062    date
                                  bmb05      LIKE bmb_file.bmb05,    #No.FUN-680062    date
                                  bmb24      LIKE bmb_file.bmb24     #No.FUN-550033
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT g_x[17] clipped,g_towhom;
      END IF
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED  #No.TQC-6A0083
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME
      PRINT g_x[11] clipped
      PRINT
      PRINT COLUMN 01,g_x[12] clipped;
      PRINT COLUMN 68,g_x[13] clipped
      PRINT
      PRINT COLUMN 01,g_x[14],g_x[15],g_x[16] clipped
      PRINT g_dash1_1[1,g_len]
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      LET l_cnt=l_cnt+1
#TQC-6A0083 add CLIPPED--END
      PRINT COLUMN 01,l_cnt CLIPPED USING '###';
      PRINT COLUMN 07,br.code CLIPPED;
      PRINT COLUMN 11,br.bmb031[1,12] CLIPPED,
             COLUMN 24,sr.ima021 CLIPPED; #MOD-4A0238
      PRINT COLUMN 55,br.bmb061 USING '#,##&.&&',
            COLUMN 64,br.bmb10 CLIPPED;
      PRINT COLUMN 68,br.bmb032[1,12],
            #COLUMN 80,br.ima022[1,30];#FUN-5B0013 mark
            COLUMN 80,br.ima022 CLIPPED; #FUN-5B0013 add
      PRINT COLUMN 114,br.bmb062 USING '#,##&.&&',
            COLUMN 123,br.bmb10 CLIPPED
 
   ON LAST ROW
      PRINT g_dash1_1[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED
      LET l_sql1 = "SELECT DISTINCT bmb01 FROM bmb_file,ima_file ",
                   " WHERE bmb24='",tm.bmb24,"'",
                   "   AND bmb03=ima01 AND ima15 <>'N' ",
                   "   AND (bmb04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "    OR bmb05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                   "   AND bmb04 <> '9999/01/01' ",
                   "  ORDER BY bmb01 "
 
      PREPARE r112_p FROM l_sql1
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
            
      END IF
      DECLARE r112_cs CURSOR FOR r112_p
      PRINT g_x[18] clipped
      FOREACH r112_cs INTO br.bmb01
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF (br.bmb01[1,2]='90' OR br.bmb01[1,2]='92' OR br.bmb01[1,2]='94') THEN
             PRINT '           ',br.bmb01
         END IF
      END FOREACH
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash1_1[1,g_len]
           PRINT g_x[4] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
END REPORT
 
REPORT r112_rep2(l_bmb01)
   DEFINE
          l_last_sw    LIKE type_file.chr1,    #No.FUN-680062      VARCHAR(1) 
          l_bmb01      LIKE bmb_file.bmb01, #FUN-5B0013 20->40     #No.FUN-680062  VARCHAR(40)
          l_ima02      LIKE ima_file.ima02  #FUN-5B0013 30->60     #No.FUN-680062  VARCHAR(60)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY l_bmb01
  FORMAT
   PAGE HEADER
      PRINT (66-FGL_WIDTH(g_company))/2 SPACES,g_company
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT g_x[17] clipped,g_towhom;
      END IF
      PRINT (66-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME
      PRINT g_x[19],g_x[20] CLIPPED
      PRINT
      PRINT g_x[21],g_x[22] CLIPPED
      PRINT g_x[23],g_x[24] CLIPPED
      LET l_last_sw = 'n'
   BEFORE GROUP OF l_bmb01
      SELECT ima02 INTO l_ima02 FROM ima_file
       WHERE ima01=l_bmb01
      PRINT COLUMN 01,l_bmb01 CLIPPED; #FUN-5B0013 add CLIPPED
      PRINT COLUMN 22,l_ima02 CLIPPED;
      PRINT COLUMN 58,'1.0000',' ','ST'
 
   ON LAST ROW
      PRINT g_x[19],g_x[20] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_x[19],g_x[20] CLIPPED
           PRINT g_x[4] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
END REPORT
 
REPORT r112_rep3()
  DEFINE s_page    LIKE type_file.chr1     #No.FUN-680062 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
     ON EVERY ROW
       LET s_page = ASCII(12)
       PRINT
       PRINT
       PRINT
       PRINT "~w3z3l6g2;     ","       ",g_company
       PRINT "~w2z2;"
       PRINT g_x[25],g_x[26] clipped
       PRINT g_x[27],g_x[28] clipped
       PRINT g_x[25],g_x[26] clipped
       PRINT
       PRINT
#FUN-860063-modify
#      PRINT g_x[29] clipped,"(",year(g_pdate)-1911 USING "&&",")",
       PRINT g_x[29] clipped,"(",year(g_pdate)-1911 USING "&&&",")",
#FUN-860063-modify-end
             g_x[30] clipped,tm.doc_no,g_x[31] clipped
       PRINT
#FUN-860063-modify
#      PRINT g_x[32] clipped,tm.se_no,"(",year(g_pdate)-1911 USING "&&",")號"
       PRINT g_x[32] clipped,tm.se_no,"(",year(g_pdate)-1911 USING "&&&",")號"
#FUN-860063-modify-end
       PRINT
#FUN-860063-modify
#      PRINT g_x[33] clipped,year(g_pdate)-1911 USING "&&"," 年 ",
       PRINT g_x[33] clipped,year(g_pdate)-1911 USING "&&&"," 年 ",
#FUN-860063-modify
             month(g_pdate) USING "&&"," 月 ",
             day(g_pdate) USING "&&",' 日'
       PRINT
       PRINT g_x[34] clipped
       PRINT "~w1z1;"
       PRINT g_x[35],g_x[36] clipped
       PRINT g_x[37],g_x[38] clipped
       PRINT g_x[39],g_x[40] clipped
       PRINT g_x[41],g_x[42] clipped
       PRINT g_x[43],g_x[44] clipped
       PRINT g_x[45],g_x[46] clipped
       PRINT g_x[47],g_x[48] clipped
       PRINT g_x[45],g_x[46] clipped
       PRINT g_x[49],g_x[50] clipped
       PRINT g_x[45],g_x[46] clipped
       PRINT g_x[47],g_x[48] clipped
       PRINT g_x[45],g_x[46] clipped
       PRINT g_x[51],g_x[52] clipped
       PRINT g_x[45],g_x[46] clipped
       PRINT g_x[53],g_x[54] clipped
 
#      SKIP TO TOP OF PAGe
    PAGE TRAILER
       PRINT s_page
 
END REPORT
#Patch....NO.TQC-610035 <001,002,003,004,005,006> #
