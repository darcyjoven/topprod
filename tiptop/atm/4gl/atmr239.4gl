# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr239.4gl
# Descriptions...: 提案清單打印
# Date & Author..: 06/03/31 By wujie
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By Rayven 報表左下角沒有程序名
# Modify.........: No.FUN-850152 08/06/06 By ChenMoyan 舊報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,          #No.FUN-680120             # Where condition
            a       LIKE type_file.chr1,             #No.FUN-680120              # 列印單價
            more    LIKE type_file.chr1              #No.FUN-680120              # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE bnb_file.bnb06,             #No.FUN-680120  # For TIPTOP 串 EasyFlow
        g_po_no,g_ctn_no1,g_ctn_no2        LIKE bnb_file.bnb06       #No.FUN-680120       #No:7674
 DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
 DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680120 SMALLINT
 DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680120
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   IF cl_null(tm.wc) THEN
        CALL atmr239_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqx01= '",tm.wc CLIPPED,"'"
        CALL atmr239()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr239_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr239_w AT p_row,p_col WITH FORM "atm/42f/atmr239"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tqx01,tqx02,tqx03,tqx04,tqx12,tqx13
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION CONTROLP    
          IF INFIELD(tqx01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqx"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx01
             NEXT FIELD tqx01
          END IF
          IF INFIELD(tqx03) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = "15"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx03
             NEXT FIELD tqx03
          END IF
          IF INFIELD(tqx04) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = "17"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx04
             NEXT FIELD tqx04
          END IF
          IF INFIELD(tqx12) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqb"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx12
             NEXT FIELD tqx12
          END IF
          IF INFIELD(tqx13) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = "20"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx13
             NEXT FIELD tqx13
          END IF
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr239_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help() 
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr239_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr239'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr239','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('atmr239',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmr239_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr239()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr239_w
END FUNCTION
 
FUNCTION atmr239()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680120        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,        #No.FUN-680120
          l_za05    LIKE ima_file.ima01,           #No.FUN-680120  
          sr        RECORD
                    tqx01     LIKE tqx_file.tqx01,
                    tqx05     LIKE tqx_file.tqx05,
                    tqx02     LIKE tqx_file.tqx02,
                    tqx12     LIKE tqx_file.tqx12,
                    tqb02     LIKE tqb_file.tqb02,
                    tqx13     LIKE tqx_file.tqx13,
                    tqa02a    LIKE tqa_file.tqa02,
                    tqx03     LIKE tqx_file.tqx03,
                    tqa02b    LIKE tqa_file.tqa02,
                    tqx04     LIKE tqx_file.tqx04,
                    tqa02c    LIKE tqa_file.tqa02,
                    tqx06     LIKE tqx_file.tqx06,
                    tqx10     LIKE tqx_file.tqx10,   
                    tqx11     LIKE tqx_file.tqx11
                    END RECORD
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='atmr239'      #No.FUN-850152
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tqxuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tqxgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tqxgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqxuser', 'tqxgrup')
     #End:FUN-980030
 
#     LET l_sql="SELECT UNIQUE tqx01,tqx05,tqx02,tqx12,tqb02,tqx13,A.tqa02,",   
#              "        tqx03,B.tqa02,tqx04,C.tqa02,tqx06,tqx10,tqx11",   
#              "  FROM tqx_file,OUTER tqb_file,OUTER tqa_file A,OUTER tqa_file B,OUTER tqa_file C",
#              " WHERE tqx12=tqb_file.tqb01",
#              "   AND tqx13=A.tqa01",
#              "   AND A.tqa03 = '20'",
#              "   AND tqx03=B.tqa01",
#              "   AND B.tqa03 = '15'",
#              "   AND tqx04=C.tqa01",
#              "   AND C.tqa03 = '17'",
#              "   AND ",tm.wc CLIPPED,
#              " ORDER BY tqx02,tqx01 "
#    LET l_sql="SELECT DISTINCT tqx01,tqx05,tqx02,tqx12,tqb02,tqx13,A.tqa02 tqa02a,",                                                       
#              "        tqx03,B.tqa02 tqa02b,tqx04,C.tqa02 tqa02c,tqx06,tqx10,tqx11",                                                             
#              "  FROM tqx_file,tqb_file,tqa_file A,tqa_file B,tqa_file C",                                 
#              " WHERE tqx12=tqb_file.tqb01(+)",                                                                                       
#              "   AND tqx13=A.tqa01(+)",                                                                                              
#              "   AND A.tqa03(+) = '20'",                                                                                             
#              "   AND tqx03=B.tqa01(+)",                                                                                              
#              "   AND B.tqa03(+) = '15'",                                                                                             
#              "   AND tqx04=C.tqa01(+)",                                                                                              
#              "   AND C.tqa03(+) = '17'",                                                                                             
#              "   AND ",tm.wc CLIPPED,                                                                                             
#              " ORDER BY tqx02,tqx01 "
    LET l_sql="SELECT DISTINCT tqx01,tqx05,tqx02,tqx12,tqb02,tqx13,A.tqa02 tqa02a,",                                                       
               "        tqx03,B.tqa02 tqa02b,tqx04,C.tqa02 tqa02c,tqx06,tqx10,tqx11",                                                             
               "  FROM tqx_file LEFT OUTER JOIN tqb_file ON tqx_file.tqx12=tqb_file.tqb01 ",                                 
               "   LEFT OUTER JOIN tqa_file A ON tqx_file.tqx13=A.tqa01 AND A.tqa03 = '20'",                                                                                       
               "   LEFT OUTER JOIN tqa_file B ON tqx_file.tqx03=B.tqa01 AND B.tqa03 = '15'",                        
               "   LEFT OUTER JOIN tqa_file C ON tqx_file.tqx04=C.tqa01 AND C.tqa03 = '17'",                                                                     
               "   WHERE ",tm.wc CLIPPED,                                                                                             
               " ORDER BY tqx02,tqx01 " 
#No.FUN-850152 --Begin
#    PREPARE atmr239_prepare1 FROM l_sql
#    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#       EXIT PROGRAM 
#    END IF
#    DECLARE atmr239_curs1 CURSOR FOR atmr239_prepare1
#    IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
#    CALL cl_outnam('atmr239') RETURNING l_name
 
#    START REPORT atmr239_rep TO l_name
 
#    LET g_pageno = 0
#    FOREACH atmr239_curs1 INTO sr.*
#      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#      OUTPUT TO REPORT atmr239_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT atmr239_rep
     IF g_zz05 ='Y' THEN
          CALL cl_wcchp(tm.wc,'tqx01,tqx02,tqx03,tqx04,tqx12,tqx13')
                   RETURNING tm.wc
     ELSE
          LET tm.wc=""
     END IF
     CALL cl_prt_cs1('atmr239','atmr239',l_sql,tm.wc)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-850152 --End
END FUNCTION
 
REPORT atmr239_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120
          l_flag       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          sr        RECORD
                    tqx01     LIKE tqx_file.tqx01,
                    tqx05     LIKE tqx_file.tqx05,
                    tqx02     LIKE tqx_file.tqx02,
                    tqx12     LIKE tqx_file.tqx12,
                    tqb02     LIKE tqb_file.tqb02,
                    tqx13     LIKE tqx_file.tqx13,
                    tqa02a    LIKE tqa_file.tqa02,
                    tqx03     LIKE tqx_file.tqx03,
                    tqa02b    LIKE tqa_file.tqa02,
                    tqx04     LIKE tqx_file.tqx04,
                    tqa02c    LIKE tqa_file.tqa02,
                    tqx06     LIKE tqx_file.tqx06,
                    tqx10     LIKE tqx_file.tqx10,   
                    tqx11     LIKE tqx_file.tqx11
                    END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.tqx02,sr.tqx01
 
   FORMAT
         PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                                                                     
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                                                                           
         LET g_pageno = g_pageno + 1                                                                                                   
         LET pageno_total = PAGENO USING '<<<','/pageno'                                                                               
         PRINT g_head CLIPPED, pageno_total                                                                                            
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'n'
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
         PRINT g_dash1
 
 
      ON EVERY ROW
         PRINT   COLUMN g_c[31],sr.tqx01 CLIPPED,
                 COLUMN g_c[32],sr.tqx05 CLIPPED,
                 COLUMN g_c[33],sr.tqx02 CLIPPED,
                 COLUMN g_c[34],sr.tqx12 CLIPPED,
                 COLUMN g_c[35],sr.tqb02 CLIPPED,
                 COLUMN g_c[36],sr.tqx13 CLIPPED,
                 COLUMN g_c[37],sr.tqa02a CLIPPED,
                 COLUMN g_c[38],sr.tqx03 CLIPPED,
                 COLUMN g_c[39],sr.tqa02b CLIPPED,
                 COLUMN g_c[40],sr.tqx04 CLIPPED,
                 COLUMN g_c[41],sr.tqa02c CLIPPED,
                 COLUMN g_c[42],sr.tqx06  CLIPPED,
                 COLUMN g_c[43],sr.tqx10 USING '#########&',
                 COLUMN g_c[44],sr.tqx11 USING '#########&'
 
      ON LAST ROW
         PRINT 
         PRINT g_dash[1,g_len]
         LET l_flag='Y'
#        PRINT  COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-710043 mark
         PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-710043
         
      PAGE TRAILER
         IF l_flag ='N' THEN
            PRINT g_dash[1,g_len]
#           PRINT COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-710043 mark
            PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-710043
         ELSE
            SKIP 2 LINE 
         END IF
         IF l_flag = 'N' THEN
            IF g_memo_pagetrailer THEN
               PRINT g_x[4]
               PRINT g_memo
            ELSE
               PRINT
               PRINT
            END IF
         ELSE
            PRINT g_x[4]
            PRINT g_memo
         END IF
 
 
END REPORT
#No.FUN-870144
