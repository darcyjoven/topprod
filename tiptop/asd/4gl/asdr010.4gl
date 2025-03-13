# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr010.4gl
# Descriptions...: 材料標準成本訂定表
# Date & Author..: 98/07/10 By plum
 # Modify.........: No.MOD-4A0158 04/10/13 By Smapmin 
# Modify.........: No.FUN-5100337 05/01/19 By pengu 報表轉XML
 # Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
 # Modify.........: No.MOD-540063 05/04/27 By kim 報表料號加長到 20
 # Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換  
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: NO.FUN-750031 07/07/13 BY TSD.c123k 改為crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD            
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300), 
              yy      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mm      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(01)       
              END RECORD,
          l_za05        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(40)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql       STRING                  # FUN-750031 TSD.c123k
DEFINE   g_str       STRING                  # FUN-750031 TSD.c123k
DEFINE   l_table     STRING                  # FUN-750031 TSD.c123k
 
MAIN
#  DEFINE       l_time          LIKE type_file.chr8        #No.FUN-6A0089
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy  = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
   # add FUN-750031
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima06.ima_file.ima06,",
               "stdprice.apb_file.apb08,",
               "apb08.apb_file.apb08,",
               "apa01.apa_file.apa01,",
               "apa02.apa_file.apa02"
 
   LET l_table = cl_prt_temptable('asdr010',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750031
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN 
      CALL r010_tm()        
   ELSE 
      CALL r010()             
   END IF
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
END MAIN
 
FUNCTION r010_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
          
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r010_w AT p_row,p_col WITH FORM "asd/42f/asdr010" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ima01,ima131,ima06,ima12,ima08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT CONSTRUCT
   
#No.FUN-570244 --start
        ON ACTION CONTROLP                                             
            IF INFIELD(ima01) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                   
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO ima01                             
               NEXT FIELD ima01                                                 
            END IF                 
#No.FUN-570244 --end
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        CLOSE WINDOW r010_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
 
     IF tm.wc = " 1=1" THEN
        CALL cl_err('','9046',0)
        CONTINUE WHILE
     END IF
 
     INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD yy 
          IF NOT cl_null(tm.yy) THEN 
             IF tm.yy=0 THEN
                NEXT FIELD yy  
             END IF
          END IF
      
       AFTER FIELD mm
          IF NOT cl_null(tm.mm) THEN 
             IF tm.mm=0 THEN
                NEXT FIELD mm
             END IF
          END IF
      
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
  
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file   
         WHERE zz01='asdr010'
        IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
          CALL cl_err('asdr010','9031',1)   
           
           CONTINUE WHILE 
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,     
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'",
                       " '",tm.yy CLIPPED,"'",
                       " '",tm.mm CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('asdr010',g_time,l_cmd) 
           EXIT WHILE 
        END IF
     END IF
  
     CALL cl_wait()
     CALL r010()
 
    END WHILE #MOD-540063
     CLOSE WINDOW r010_w
  
     ERROR ""
 
 #  END WHILE #MOD-540063
 
END FUNCTION
 
FUNCTION r010()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(600)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_apa01   LIKE apa_file.apa01,
          l_apa02   LIKE apa_file.apa02,
          l_apb08   LIKE apb_file.apb08, 
          l_pmm01   LIKE pmm_file.pmm01,
          l_pmm04   LIKE pmm_file.pmm04,
          l_pmn44   LIKE pmn_file.pmn44,
          sr        RECORD 
                          ima01     LIKE ima_file.ima01,
                          ima02     LIKE ima_file.ima02,
                          ima021    LIKE ima_file.ima021,
                          ima06     LIKE ima_file.ima06,
                          stdprice  LIKE apb_file.apb08,
                          apb08     LIKE apb_file.apb08,
                          apa01     LIKE apa_file.apa01,
                          apa02     LIKE apa_file.apa02
                    END RECORD 
 
     # add FUN-750031
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     # end FUN-750031
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #CALL cl_outnam('asdr010') RETURNING l_name  #FUN-750031 TSD.c123k mark
     #START REPORT r010_rep TO l_name  #FUN-750031 TSD.c123k mark
     LET g_pageno = 0
     #-->取最近應付帳款本幣單價
      LET l_sql = " SELECT  apa01,apa02,apb08 FROM apa_file,apb_file ",
                  "  WHERE apb12= ? and apa01 = apb01 ",
                  "    AND apa42 = 'N' ",
                  " AND apa00 LIKE '1%' ",
                  "  ORDER BY apa02 desc"
     PREPARE r010_preapb   FROM l_sql
     IF STATUS THEN CALL cl_err('preapb:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE apb_curs  CURSOR FOR r010_preapb   
     #-->取最近應付帳款本幣單價
      LET l_sql = " SELECT  pmm01,pmm04,pmn44 FROM pmm_file,pmn_file",
                  "  WHERE pmn04= ? and pmn01 = pmm01 AND pmm18 <> 'X'",
                  "  ORDER BY pmm04 desc"
     PREPARE r010_prepmn   FROM l_sql
     IF STATUS THEN CALL cl_err('prepmn:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM 
     END IF
     DECLARE pmn_curs  CURSOR FOR r010_prepmn   
 
 
     LET l_sql = " SELECT ima01, ima02, ima021,ima06,",
                 " (stb07+stb08+stb09+stb09a),0,0,0",
                 " FROM ima_file, stb_file ",
                 " WHERE ima01 = stb_file.stb01 ",
                 " AND stb_file.stb02=",tm.yy,
                 " AND stb_file.stb03=",tm.mm,
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY 1 "
 
     PREPARE r010_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE r010_curs1 CURSOR FOR r010_prepare1
     FOREACH r010_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #-->取最近應付帳款本幣單價
         OPEN apb_curs USING sr.ima01
         FETCH apb_curs INTO l_apa01,l_apa02,l_apb08
           IF SQLCA.sqlcode THEN
               LET l_apa01 = ' ' LET l_apa02 = ' ' LET l_apb08 = 0 
           END IF
         CLOSE apb_curs
         LET sr.apb08=l_apb08 
         LET sr.apa01=l_apa01
         LET sr.apa02=l_apa02
       #-->如取不到則取最近採購單價
         IF sr.apb08 = 0 THEN 
             OPEN pmn_curs USING sr.ima01 #MOD-4A0158
            FETCH pmn_curs INTO l_pmm01,l_pmm04,l_pmn44
              IF SQLCA.sqlcode THEN
                  LET l_pmm01 = ' ' LET l_pmm04 = ' ' LET l_pmn44 = 0 #MOD-4A0158
              END IF
              LET sr.apb08=l_pmn44 
              LET sr.apa01=l_pmm01
              LET sr.apa02=l_pmm04 
            CLOSE pmn_curs
         END IF
         IF sr.stdprice IS NULL THEN LET sr.stdprice=0 END IF
         IF sr.apb08 IS NULL THEN LET sr.apb08=0 END IF
 
         #FUN-750031 add
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         #OUTPUT TO REPORT r010_rep(sr.*) #FUN-750031
        
         EXECUTE insert_prep USING
            sr.ima01,  sr.ima02,  sr.ima021,  sr.ima06,  sr.stdprice,
            sr.apb08,  sr.apa01,  sr.apa02
         #------------------------------ CR (3) ------------------------------#
         #FUN-750031 end
     END FOREACH
 
     #FINISH REPORT r010_rep  #FUN-750031 TSD.c123k mark
     CLOSE r010_curs1
     ERROR ""
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-750031 TSD.c123k mark
 
    # FUN-750031 add
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,ima131,ima06,ima12,ima08')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.yy,";",tm.mm
 
    CALL cl_prt_cs3('asdr010','asdr010',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    # FUN-750031 end
 
END FUNCTION
{
REPORT r010_rep(sr)
   DEFINE l_str         LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
          l_last_sw     LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
          sr            RECORD 
                          ima01     LIKE ima_file.ima01,
                          ima02     LIKE ima_file.ima02,
                          ima021    LIKE ima_file.ima021,
                          ima06     LIKE ima_file.ima06,
                          stdprice  LIKE apb_file.apb08,
                          apb08     LIKE apb_file.apb08,
                          apa01     LIKE apa_file.apa01,
                          apa02     LIKE apa_file.apa02
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.ima01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[9] CLIPPED,tm.yy USING '&&&&','/',tm.mm USING '&&'
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   ON EVERY ROW 
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02 CLIPPED,
            COLUMN g_c[33],sr.ima021 CLIPPED,
            COLUMN g_c[34],cl_numfor(sr.stdprice,34,g_azi03),
            COLUMN g_c[35],cl_numfor(sr.apb08,35,g_azi03),
            COLUMN g_c[36],sr.apa02,
            COLUMN g_c[37],sr.apa01 clipped
 
   ON LAST ROW  
      PRINT g_dash[1,g_len] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
}
