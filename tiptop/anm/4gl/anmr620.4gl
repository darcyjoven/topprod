# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr620.4gl
# Descriptions...: 投資市價重評價表
# Date & Author..: 06/06/23 By rainy
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-740410 07/04/27 By Nicola 改ora
# Modify.........: No.FUN-830156 08/03/31 By Sunyanchun  老報表改CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.CHI-8A0028 08/10/22 By Sarah 1.畫面增加"評價日期"edate
#                                                  2.程式針對畫面輸入日期作為sql依據
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.MOD-920033 09/02/03 By Sarah SQL裡用到to_date語法的部份需拿掉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B30678 11/03/28 By Dido 抓取最接近小於等於現價日期的投資單號  
# Modify.........: No:MOD-B60005 11/06/01 By Dido 計算投資損益(GSZZ)應先取位再相減 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
            wc     LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(600) #Where Condiction
            edate  LIKE type_file.dat,       #CHI-8A0028 add
            more   LIKE type_file.chr1       #No.FUN-680107 VARCHAR(1)   #
           END RECORD,
       g_buf       LIKE type_file.chr1000    #No.FUN-680107 VARCHAR(30)
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_head1     STRING
DEFINE i           LIKE type_file.num5       #No.FUN-680107 SMALLINT
DEFINE j           LIKE type_file.num5       #No.FUN-680107 SMALLINT
DEFINE g_str       STRING                    #No.FUN-830156
DEFINE l_table     STRING                    #MOD-B30678
DEFINE g_sql       STRING                    #MOD-B30678
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT  
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
  #MOD-B30678-add-
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   

   LET g_sql = "gsl01.gsl_file.gsl01,  gsb03.gsb_file.gsb03,",
               "gsb05.gsb_file.gsb05,  gsb06.gsb_file.gsb06,",
               "gsb09.gsb_file.gsb09,  gsb12.gsb_file.gsb12,",
               "gsl03.gsl_file.gsl03,  gsbtot.gsb_file.gsb09,",
               "gsltot.gsb_file.gsb09, gszz.gsb_file.gsb09 "
   LET l_table = cl_prt_temptable('anmr620',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF               
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #MOD-B30678-end-

   LET g_pdate    = ARG_VAL(2)   # Get arguments from command line
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc      = ARG_VAL(8)
   LET tm.edate   = ARG_VAL(9)   #CHI-8A0028 add
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmr620_tm()
   ELSE 
      CALL anmr620()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add-- 
END MAIN
 
FUNCTION anmr620_tm()
   DEFINE lc_qbe_sn   LIKE gsl_file.gsl01     #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd       LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
          l_jmp_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr620_w AT p_row,p_col WITH FORM "anm/42f/anmr620"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.edate= g_today   #CHI-8A0028 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON gsl01,gsb03,gsb05,gsb06
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            IF INFIELD(gsl01)  THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gsb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gsl01
               NEXT FIELD gsl01
            END IF
 
         ON ACTION locale
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
         LET INT_FLAG = 0
         CLOSE WINDOW anmr620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
   
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
   
      INPUT BY NAME tm.edate,tm.more WITHOUT DEFAULTS   #CHI-8A0028 add tm.edate
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
        #str CHI-8A0028 add
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               CALL cl_err(0, 'anm-003' ,0)
               NEXT FIELD edate
            END IF
        #end CHI-8A0028 add
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN 
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN 
               EXIT INPUT 
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()      # Command execution
 
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
         LET INT_FLAG = 0 
         CLOSE WINDOW anmr620_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='anmr620'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr620','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",   #CHI-8A0028 add
                        " '",tm.more CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('anmr620',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW anmr620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL anmr620()
 
      ERROR ""
 
   END WHILE
 
   CLOSE WINDOW anmr620_w
 
END FUNCTION
 
FUNCTION anmr620()
DEFINE l_name  LIKE type_file.chr20,             # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
      #l_sql   LIKE type_file.chr1000,           # RDSQL STATEMENT #No.FUN-680107 CHAR(1200) #MOD-B30678 mark
       l_sql   STRING,                           #MOD-B30678 
       l_gsl   RECORD 
                  gsl01   LIKE gsl_file.gsl01,
                  gsb03   LIKE gsb_file.gsb03,
                  gsb05   LIKE gsb_file.gsb05,
                  gsb06   LIKE gsb_file.gsb06,
                  gsb09   LIKE gsb_file.gsb09,
                  gsb12   LIKE gsb_file.gsb12,
                  gsl03   LIKE gsl_file.gsl03,
                  gsbtot  LIKE gsb_file.gsb09,
                  gsltot  LIKE gsb_file.gsb09,
                  gszz    LIKE gsb_file.gsb09
               END RECORD,
       g_msg   LIKE type_file.chr1000,          #No.FUN-680107 VARCHAR(40)
       sr      RECORD
                  gsl01   LIKE gsl_file.gsl01,
                  gsb03   LIKE gsb_file.gsb03,
                  gsb05   LIKE gsb_file.gsb05,
                  gsb06   LIKE gsb_file.gsb06,
                  gsb09   LIKE gsb_file.gsb09,
                  gsb12   LIKE gsb_file.gsb12,
                  gsl03   LIKE gsl_file.gsl03,
                  gsbtot  LIKE gsb_file.gsb09,
                  gsltot  LIKE gsb_file.gsb09,
                  gszz    LIKE gsb_file.gsb09
               END RECORD
DEFINE l_gsl01_o LIKE gsl_file.gsl01         #MOD-B30678
 
  #CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0082      #MOD-B30678 mark
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ## #MOD-B30678
   CALL cl_del_data(l_table)                                             #MOD-B30678

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND gsluser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND gslgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #群組權限
   #      LET tm.wc = tm.wc clipped," AND gslgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gsluser', 'gslgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT gsl01,gsb03,gsb05,gsb06,gsb09,",
               "       gsb12,gsl03,gsb09*gsb12 gsbtot,",
               "       gsb12*gsl03 gsltot,",
              #"       gsb12*gsl03-gsb09*gsb12 gszz ",      #MOD-B60005 mark
               "       0 gszz ",                            #MOD-B60005
               "  FROM gsl_file LEFT OUTER JOIN gsb_file ON gsl01 = gsb01 ",
               "  WHERE ",tm.wc CLIPPED,
              #"    AND gsl02 <=to_date('",g_today,"','yy/mm/dd')",  #CHI-8A0028 mark
              #"    AND gsl02 <=cast('",tm.edate,"' AS datetime)", #CHI-8A0028  #MOD-920033 mark
               "    AND gsl02 <='",tm.edate,"'",                                  #MOD-920033
               "    AND gslacti ='Y'",
               " ORDER BY gsl01,gsl02 DESC "   #MOD-B30678 add gls02 
   #No.FUN-830156---BEGIN  
  #-MOD-B30678-add-
   PREPARE r620_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r620_curs1 CURSOR FOR r620_prepare1
   LET l_gsl01_o = ''
   FOREACH r620_curs1 INTO sr.*
      IF (sr.gsl01 <> l_gsl01_o) OR cl_null(l_gsl01_o)  THEN 
        #-MOD-B60005-add-
         LET sr.gsltot = cl_digcut(sr.gsltot,g_azi04)
         LET sr.gsbtot = cl_digcut(sr.gsbtot,g_azi04)
         LET sr.gszz = sr.gsltot - sr.gsbtot 
        #-MOD-B60005-end- 
         EXECUTE insert_prep USING sr.*
      END IF
      LET l_gsl01_o = sr.gsl01
   END FOREACH
  #-MOD-B30678-end-

   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ## #MOD-B30678
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #MOD-B30678

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   
   IF g_zz05 = 'Y' THEN                                                                                                           
      CALL cl_wcchp(tm.wc,'gsl01,gsb03,gsb05,gsb06')                                                                              
         RETURNING tm.wc                                                                                                             
      LET g_str = tm.wc                                                                                                           
   END IF
   LET g_str =g_str,";",g_azi03,";",g_azi04,";",g_azi05                                                                                    
  #CALL cl_prt_cs1('anmr620','anmr620',l_sql,g_str)   #MOD-B30678 mark
   CALL cl_prt_cs3('anmr620','anmr620',l_sql,g_str)   #MOD-B30678
 
#  PREPARE anmr620_prepare1 FROM l_sql
#  IF STATUS THEN 
#     CALL cl_err('prepare:',STATUS,1) 
#     EXIT PROGRAM 
#  END IF
#
#  DECLARE anmr620_curs1 CURSOR FOR anmr620_prepare1
#
#  CALL cl_outnam('anmr620') RETURNING l_name
#  START REPORT anmr620_rep TO l_name
#
#  LET g_pageno = 0
#
#  FOREACH anmr620_curs1 INTO l_gsl.*
#     IF STATUS THEN 
#        CALL cl_err('foreach:',STATUS,1) 
#        EXIT FOREACH 
#     END IF
#
#     OUTPUT TO REPORT anmr620_rep(l_gsl.*)
#  END FOREACH
#
#  FINISH REPORT anmr620_rep
#
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #No.FUN-830156----END---
   #No.FUN-B80067--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0082
   #No.FUN-B80067--mark--End-----
END FUNCTION
 
#REPORT anmr620_rep(sr)
#  DEFINE l_last_sw   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#         sr   RECORD
#                 gsl01   LIKE gsl_file.gsl01,
#                 gsb03   LIKE gsb_file.gsb03,
#                 gsb05   LIKE gsb_file.gsb05,
#                 gsb06   LIKE gsb_file.gsb06,
#                 gsb09   LIKE gsb_file.gsb09,
#                 gsb12   LIKE gsb_file.gsb12,
#                 gsl03   LIKE gsl_file.gsl03,
#                 gsbtot  LIKE gsb_file.gsb09,
#                 gsltot  LIKE gsb_file.gsb09,
#                 gszz    LIKE gsb_file.gsb09
#              END RECORD,
#         l_point,l_begin,l_end      LIKE type_file.num10,    #No.FUN-680107 INTEGER
#         l_tot,l_cnt1,l_cnt2,l_cnt3 LIKE type_file.num10,    #No.FUN-680107 INTEGER
#         l_x                        LIKE type_file.chr20     #No.FUN-680107 VARCHAR(10)
#
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
#  
#  ORDER BY sr.gsl01,sr.gsb03
#  
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno=g_pageno+1
#        LET pageno_total=PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#    
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#              g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#    
#     ON EVERY ROW
#        PRINT COLUMN g_c[31],sr.gsl01,
#              COLUMN g_c[32],sr.gsb03,
#              COLUMN g_c[33],sr.gsb05,
#              COLUMN g_c[34],sr.gsb06,
#              COLUMN g_c[35],cl_numfor(sr.gsb09,35,g_azi03),
#              COLUMN g_c[36],cl_numfor(sr.gsb12,36,3),
#              COLUMN g_c[37],cl_numfor(sr.gsl03,37,g_azi03),
#              COLUMN g_c[38],cl_numfor(sr.gsbtot,38,g_azi04),
#              COLUMN g_c[39],cl_numfor(sr.gsltot,39,g_azi04),
#              COLUMN g_c[40],cl_numfor(sr.gszz,40,g_azi04)
#    
#     ON LAST ROW
#        PRINT g_dash2
#        PRINT COLUMN g_c[37],g_x[9],
#              COLUMN g_c[38],cl_numfor( SUM(sr.gsbtot),38,g_azi05),
#              COLUMN g_c[39],cl_numfor( SUM(sr.gsltot),39,g_azi05),
#              COLUMN g_c[40],cl_numfor( SUM(sr.gszz)  ,40,g_azi05)
#        PRINT
#        PRINT
#        PRINT g_dash[1,g_len] CLIPPED
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#    
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
#
#END REPORT
#No.MOD-740410
#FUN-870144
