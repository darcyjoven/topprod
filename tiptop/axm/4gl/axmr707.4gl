# Prog. Version..: '5.30.07-13.05.16(00009)'     #
#
# Pattern name...: axmr707.4gl
# Descriptions...: 超期未聯係客戶明細表
# Date & Author..: 02/12/11 By Leagh
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-750097 07/06/20 By cheunl 報表改寫為CR報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改 
# Modify.........: No.FUN-CB0002 12/11/12 By lujh sql語句where條件有問題,導致查不出資料
# Modify.........: No.TQC-D10015 13/01/05 By qirl QBE條件欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
              b       LIKE type_file.num5,        # No.FUN-680137 SMALLINT     #
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)      # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_str           STRING                  #No.FUN-750097
DEFINE   l_table         STRING                  #No.FUN-750097                                                                         
DEFINE   g_sql           STRING                  #No.FUN-750097
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
   LET g_sql = " ofd10.ofd_file.ofd10,",  
               " ofd01.ofd_file.ofd01,",  
               " ofd23.ofd_file.ofd23,",  
               " ofd26.ofd_file.ofd26,",  
               " ofd27.ofd_file.ofd27,",  
               " ofd31.ofd_file.ofd31,",  
               " ofc04.ofc_file.ofc04,",  
               " ofc05.ofc_file.ofc05,",  
               " ofc06.ofc_file.ofc06,",  
               " ofd02.ofd_file.ofd02,",  
               " gen02.gen_file.gen02,",  
               " ofd33.ofd_file.ofd33 "   
   LET l_table = cl_prt_temptable('axmr707',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ",                                                                          
                "        ?, ?, ?, ?, ?, ? )"                                                                                  
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF
 
 
   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.b    = 0
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmr707_tm(0,0)             # Input print condition
      ELSE CALL axmr707()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr707_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 20
 
   OPEN WINDOW axmr707_w AT p_row,p_col WITH FORM "axm/42f/axmr707"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.b    = 0
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofd01,ofd23,ofd10
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#--TQC-D10015--add--star--
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ofd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ofd"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofd01
                 NEXT FIELD ofd01
              WHEN INFIELD(ofd10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ofd10"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofd10
                 NEXT FIELD ofd10
              WHEN INFIELD(ofd23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ofd23"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ofd23
                 NEXT FIELD ofd23
           END CASE

#--TQC-D10015--add--end---
 
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr707_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr707_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr707'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr707','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.b     CLIPPED,"'" ,
                        #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr707',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr707_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr707()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr707_w
END FUNCTION
 
FUNCTION axmr707()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    ofd10     LIKE ofd_file.ofd10,
                    ofd01     LIKE ofd_file.ofd01,
                    ofd23     LIKE ofd_file.ofd23,
                    ofd26     LIKE ofd_file.ofd26,
                    ofd27     LIKE ofd_file.ofd27,
                    ofd31     LIKE ofd_file.ofd31,
                    ofc04     LIKE ofc_file.ofc04,
                    ofc05     LIKE ofc_file.ofc05,
                    ofc06     LIKE ofc_file.ofc06,
                    ofd02     LIKE ofd_file.ofd02,
                    gen02     LIKE gen_file.gen02,
                    ofd33     LIKE ofd_file.ofd33
                    END RECORD
#No.FUN-750097-----------------start--------------                                                                                  
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#No.FUN-750097-----------------end----------------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT ofd10,ofd01,ofd23,ofd26,ofd27,",                         
               "       ofd31,ofc04,ofc05,ofc06,ofd02,gen02,ofd33 ",             
             #  "  FROM ofd_file,ofc_file,OUTER gen_file ",     #FUN-B80089     MARK            
             #  " WHERE ofd23 = gen01(+) AND ofd10 = ofc01",    #FUN-B80089     MARK
               "   FROM ofd_file LEFT OUTER JOIN gen_file ON ofd23 = gen01",         #FUN-B80089    ADD
               "   LEFT OUTER JOIN ofc_file ON ofd10 = ofc01",                       #FUN-B80089    ADD
               "   AND ofc03 = 'Y' ",                                           
               "   AND ofd22 IN ('0','1','2') AND ofd10 IS NOT NULL",           
               #"   AND (CAST('",g_today,"' as DATETIME) -ofd26) >= ",tm.b,    #FUN-CB0002  mark                     
               "   AND ",tm.wc CLIPPED                           
#No.FUN-750097-----------------------start-----------------------
     PREPARE axmr707_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr707_curs1 CURSOR FOR axmr707_prepare1
 
#    CALL cl_outnam('axmr707') RETURNING l_name
#    START REPORT axmr707_rep TO l_name
 
#    LET g_pageno = 0
     FOREACH axmr707_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#      OUTPUT TO REPORT axmr707_rep(sr.*)
       IF g_today - sr.ofd26 > = tm.b THEN   #FUN-CB0002 add
          EXECUTE insert_prep USING
                  sr.ofd10,sr.ofd01,sr.ofd23,sr.ofd26,sr.ofd27,sr.ofd31,
                  sr.ofc04,sr.ofc05,sr.ofc06,sr.ofd02,sr.gen02,sr.ofd33
       END IF   #FUN-CB0002 add 
     END FOREACH
 
#    FINISH REPORT axmr707_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'ofd01')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str = g_str
     CALL  cl_prt_cs3('axmr707','axmr707',l_sql,g_str) #NO.FUN-750097
#No.FUN-750097-----------------------------end-------------------------
END FUNCTION
 
#No.FUN-750097-----start-----------
{REPORT axmr707_rep(sr)
   DEFINE l_last_sw           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          base_tot,part_tot   LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          sr        RECORD
                    ofd10     LIKE ofd_file.ofd10,
                    ofd01     LIKE ofd_file.ofd01,
                    ofd23     LIKE ofd_file.ofd23,
                    ofd26     LIKE ofd_file.ofd26,
                    ofd27     LIKE ofd_file.ofd27,
                    ofd31     LIKE ofd_file.ofd31,
                    ofc04     LIKE ofc_file.ofc04,
                    ofc05     LIKE ofc_file.ofc05,
                    ofc06     LIKE ofc_file.ofc06,
                    ofd02     LIKE ofd_file.ofd02,
                    gen02     LIKE gen_file.gen02,
                    ofd33     LIKE ofd_file.ofd33
                    END RECORD,
            l_str1            LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)
            l_str2            LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)
            l_over            LIKE type_file.num10,     # No.FUN-680137 INTEGER
            i,j,l_tmp         LIKE type_file.num5       # No.FUN-680137 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ofd10
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41],
            g_x[42],
            g_x[43],
            g_x[44]
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET j = 0
 
   BEFORE GROUP OF sr.ofd10
      IF j > 0 THEN
         PRINT g_dash2
      END IF
      LET l_str1= sr.ofc04 USING '##' CLIPPED,g_x[10] CLIPPED,
                  sr.ofc05 USING '##' CLIPPED,g_x[11] CLIPPED
      LET l_str2= sr.ofc06 USING '####&' CLIPPED,g_x[09] CLIPPED
      PRINT COLUMN g_c[31],sr.ofd10 CLIPPED,
            COLUMN g_c[32],l_str1 CLIPPED,
            COLUMN g_c[33],l_str2 CLIPPED;
      LET base_tot = 0
      LET i = 0
      LET j = j+1
 
   ON EVERY ROW
      LET base_tot = base_tot + 1
      IF sr.ofc06 > 0 THEN
         LET l_tmp = (sr.ofc04*30+sr.ofc05)/sr.ofc06
      ELSE
         LET l_tmp = 0
      END IF
      PRINT COLUMN g_c[34],sr.ofd01 CLIPPED,
            COLUMN g_c[35],sr.ofd02 CLIPPED,
            COLUMN g_c[36],sr.ofd23 CLIPPED,
            COLUMN g_c[37],sr.gen02 CLIPPED,
            COLUMN g_c[38],sr.ofd26 CLIPPED;
      IF cl_null(sr.ofd26) OR cl_null(sr.ofc04) OR
         cl_null(sr.ofc05) OR cl_null(sr.ofc06) THEN
         PRINT COLUMN g_c[39],' ';
      ELSE
         PRINT COLUMN g_c[39],sr.ofd26 + l_tmp;
      END IF
      PRINT COLUMN g_c[40],sr.ofd27 CLIPPED;
      IF cl_null(sr.ofd26) THEN
         PRINT COLUMN g_c[41],' ';
      ELSE
         PRINT COLUMN g_c[41],g_today-sr.ofd26 USING '#########&';  #No.TQC-6A0087 add#長度
      END IF
      LET l_over = g_today - (sr.ofd26 + l_tmp)
      IF l_over < 0  THEN LET l_over = 0 END IF
      PRINT COLUMN g_c[42],l_over USING '#########&', #No.TQC-6A0087 add#長度
            COLUMN g_c[43],sr.ofd31 CLIPPED,
            COLUMN g_c[44],sr.ofd33 CLIPPED
 
   AFTER GROUP OF sr.ofd10
      LET l_str1 = base_tot USING '###&' CLIPPED,g_x[12] CLIPPED
 
      PRINT
      PRINT COLUMN g_c[31],g_x[13] CLIPPED,
            COLUMN g_c[32],l_str1 CLIPPED
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED, COLUMN g_c[44], g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED, COLUMN g_c[44], g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750097-----end----------
