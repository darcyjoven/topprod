# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: atmr255.4gl
# Descriptions...: 集團雜發申請單憑証打印
# Date & Author..: 06/04/06 By wujie  
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By Rayven 報表左下角無程序代號
# Modify.........: No.FUN-860007 08/06/04 By Sunyanchun 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.TQC-940093 09/04/16 By mike 資料庫使用s_dbstring 
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50164 10/05/31 By Carrier MAIN结构调整
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)            # Where condition
            more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)             # Input more condition(Y/N)
            END RECORD
 DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
 DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
 DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
 DEFINE g_sql           STRING                       #No.FUN-860007
 DEFINE g_str           STRING                       #No.FUN-860007
 DEFINE l_table         STRING                       #No.FUN-860007
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #TQC-A50164  --Begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF

   #NO.FUN-860007----BEGIN----
   LET g_sql = "tsg01.tsg_file.tsg01,",
               "tsg17.tsg_file.tsg17,",
               "tsg02.tsg_file.tsg02,",
               "tsg18.tsg_file.tsg18,",
               "tsg03.tsg_file.tsg03,",
               "azp02a.azp_file.azp02,",
               "tsg04.tsg_file.tsg04,",
               "imd02a.imd_file.imd02,",
               "tsg06.tsg_file.tsg06,",
               "azp02b.azp_file.azp02,",
               "tsg07.tsg_file.tsg07,", 
               "imd02b.imd_file.imd02,",    
               "tsh02.tsh_file.tsh02,",
               "tsh03.tsh_file.tsh03,",     
               "ima135.ima_file.ima135,",     
               "tsh04.tsh_file.tsh04,",
               "tsh05.tsh_file.tsh05,",    
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021"
 
   LET l_table = cl_prt_temptable('atmr255',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-860007----END------

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   #TQC-A50164  --End  
   IF cl_null(tm.wc) THEN
        CALL atmr255_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tsg01= '",tm.wc CLIPPED,"'"
        CALL atmr255()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr255_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr255_w AT p_row,p_col WITH FORM "atm/42f/atmr255"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tsg01,tsg02,tsg17,tsg18,tsg03,tsg06,tsg05
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION CONTROLP    
          IF INFIELD(tsg01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tsg"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tsg01
             NEXT FIELD tsg01
          END IF
          IF INFIELD(tsg03) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azp"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tsg03
             NEXT FIELD tsg03
          END IF
          IF INFIELD(tsg06) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azp"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tsg06
             NEXT FIELD tsg06
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr255_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr255_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr255'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr255','9031',1)
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
         CALL cl_cmdat('atmr255',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmr255_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr255()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr255_w
END FUNCTION
 
FUNCTION atmr255()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000)
          l_dbs     STRING,    
          ps_dbs    LIKE azp_file.azp03,          #No.FUN-680120 VARCHAR(10)    
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40) 
          sr        RECORD
                    tsg01     LIKE tsg_file.tsg01,
                    tsg02     LIKE tsg_file.tsg02,
                    tsg03     LIKE tsg_file.tsg03,
                    azp02a    LIKE azp_file.azp02,
                    tsg04     LIKE tsg_file.tsg04,
                    imd02a    LIKE imd_file.imd02,
                    tsg05     LIKE tsg_file.tsg05,
                    tsg06     LIKE tsg_file.tsg06,
                    azp02b    LIKE azp_file.azp02,
                    tsg07     LIKE tsg_file.tsg07,
                    imd02b    LIKE imd_file.imd02,
                    tsg17     LIKE tsg_file.tsg17,
                    tsg18     LIKE tsg_file.tsg18,
                    tsh02     LIKE tsh_file.tsh02,   
                    tsh03     LIKE tsh_file.tsh03,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    ima135    LIKE ima_file.ima135,
                    tsh04     LIKE tsh_file.tsh04,
                    tsh05     LIKE tsh_file.tsh05
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tsguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tsggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tsggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tsguser', 'tsggrup')
 
      LET l_sql="SELECT UNIQUE tsg01,tsg02,tsg03,A.azp02,tsg04,'',tsg05,tsg06,B.azp02,tsg07,'',",   
               "        tsg17,tsg18,tsh02,tsh03,ima02,ima021,ima135,tsh04,tsh05",   
               "  FROM tsg_file,tsh_file,OUTER azp_file A,",
               "       OUTER azp_file B,OUTER ima_file ",
               " WHERE tsg01=tsh01 ",
               "   AND tsg_file.tsg03=A.azp01",
               "   AND tsg_file.tsg06=B.azp01",
               "   AND tsh_file.tsh03=ima_file.ima01",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY tsg01,tsh02 "
     PREPARE atmr255_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmr255_curs1 CURSOR FOR atmr255_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
     CALL cl_del_data(l_table)                     #NO.FUN-860007
     FOREACH atmr255_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #SELECT azp03 INTO ps_dbs FROM azp_file  #FUN-A50102
       # WHERE azp01 =sr.tsg03                  #FUN-A50102
       #LET l_dbs =ps_dbs                       #FUN-A50102
       #LET l_dbs=l_dbs.trimRight()             #FUN-A50102                                                                                                   
       #LET l_dbs=s_dbstring(l_dbs)             #FUN-A50102

       #LET l_sql ="SELECT imd02 FROM ",l_dbs,"imd_file",  #FUN-A50102
       LET l_sql ="SELECT imd02 FROM ",cl_get_target_table(sr.tsg03,'imd_file'), #FUN-A50102
                  " WHERE imd01 = '",sr.tsg04,"'"
       
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,sr.tsg03) RETURNING l_sql #FUN-A50102
       PREPARE tsg04_prepare FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
          EXIT PROGRAM 
       END IF

       EXECUTE tsg04_prepare INTO sr.imd02a
    
       #SELECT azp03 INTO ps_dbs FROM azp_file   #FUN-A50102
       # WHERE azp01 =sr.tsg06                   #FUN-A50102

       #LET l_dbs =ps_dbs                         #FUN-A50102
       #LET l_dbs=l_dbs.trimRight()               #FUN-A50102                                                                                                   
       #LET l_dbs=s_dbstring(l_dbs)               #FUN-A50102

       #LET l_sql ="SELECT imd02 FROM ",l_dbs,"imd_file",  #FUN-A50102
       LET l_sql ="SELECT imd02 FROM ",cl_get_target_table(sr.tsg06,'imd_file'), #FUN-A50102
                  " WHERE imd01 = '",sr.tsg07,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,sr.tsg06) RETURNING l_sql #FUN-A50102
       PREPARE tsg07_prepare FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
          EXIT PROGRAM 
       END IF
       EXECUTE tsg07_prepare INTO sr.imd02b

       EXECUTE insert_prep USING sr.tsg01,sr.tsg17,sr.tsg02,sr.tsg18,
                                   sr.tsg03,sr.azp02a,sr.tsg04,sr.imd02a,
                                   sr.tsg06,sr.azp02b,sr.tsg07,sr.imd02b,
                                   sr.tsh02,sr.tsh03,sr.ima135,sr.tsh04,
                                   sr.tsh05,sr.ima02,sr.ima021
       #OUTPUT TO REPORT atmr255_rep(sr.*)
       #NO.FUN-860007----END--------
     END FOREACH
     #NO.FUN-860007---BEGIN----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tsg01,tsg02,tsg17,tsg18,tsg03,tsg06,tsg05')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF 
     LET g_str = tm.wc
     CALL cl_prt_cs3('atmr255','atmr255',g_sql,g_str) 
     #FINISH REPORT atmr255_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-860007---END------
END FUNCTION
#NO.FUN-860007---BEGIN---- 
#REPORT atmr255_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,            #No.FUN-680120 VARCHAR(1)
#         l_flag       LIKE type_file.chr1,            #No.FUN-680120 VARCHAR(1)
#         sr        RECORD
#                   tsg01     LIKE tsg_file.tsg01,
#                   tsg02     LIKE tsg_file.tsg02,
#                   tsg03     LIKE tsg_file.tsg03,
#                   azp02a    LIKE azp_file.azp02,
#                   tsg04     LIKE tsg_file.tsg04,
#                   imd02a    LIKE imd_file.imd02,
#                   tsg05     LIKE tsg_file.tsg05,
#                   tsg06     LIKE tsg_file.tsg06,
#                   azp02b    LIKE azp_file.azp02,
#                   tsg07     LIKE tsg_file.tsg07,
#                   imd02b    LIKE imd_file.imd02,
#                   tsg17     LIKE tsg_file.tsg17,
#                   tsg18     LIKE tsg_file.tsg18,
#                   tsh02     LIKE tsh_file.tsh02,   
#                   tsh03     LIKE tsh_file.tsh03,
#                   ima02     LIKE ima_file.ima02,
#                   ima021    LIKE ima_file.ima021,
#                   ima135    LIKE ima_file.ima135,
#                   tsh04     LIKE tsh_file.tsh04,
#                   tsh05     LIKE tsh_file.tsh05
#                   END RECORD
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.tsg01,sr.tsh02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_msg))/2+1),g_msg
#        PRINT g_head CLIPPED,pageno_total  
#        PRINT g_dash[1,g_len]
#        PRINT g_x[11],sr.tsg01,COLUMN 29,g_x[12],sr.tsg17 
#        PRINT g_x[17],sr.tsg02,COLUMN 29,g_x[18],sr.tsg18
#        PRINT g_x[13],sr.tsg03,COLUMN 29,g_x[14],sr.azp02a 
#        PRINT g_x[19],sr.tsg04,COLUMN 29,g_x[20],sr.imd02a
#        PRINT g_x[15],sr.tsg06,COLUMN 29,g_x[16],sr.azp02b 
#        PRINT g_x[21],sr.tsg07,COLUMN 29,g_x[22],sr.imd02b 
#        PRINT g_dash2[1,g_len]
#        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#        PRINTX name=H2 g_x[36],g_x[37]
#        PRINTX name=H3 g_x[38],g_x[39]
#        PRINT g_dash1
#        LET l_flag='N'  #No.TQC-710043
#
#     BEFORE GROUP OF sr.tsg01
#        SKIP TO TOP OF PAGE
#        
#     ON EVERY ROW
#        PRINTX name=D1  
#                       COLUMN g_c[31],sr.tsh02 USING '#####' CLIPPED,
#                       COLUMN g_c[32],sr.tsh03 CLIPPED,
#                       COLUMN g_c[33],sr.ima135 CLIPPED,
#                       COLUMN g_c[34],sr.tsh04 CLIPPED,
#                       COLUMN g_c[35],sr.tsh05 USING '###########&.##' CLIPPED
#        PRINTX name=D2 
#                       COLUMN g_c[37],sr.ima02 CLIPPED
#        PRINTX name=D3 
#                       COLUMN g_c[39],sr.ima021 CLIPPED
#     ON LAST ROW
#        PRINT 
#        PRINT g_dash[1,g_len]
#        LET l_flag='Y'
#        #No.TQC-710043 --start--
#        PRINT  COLUMN (g_len-9),g_x[7] CLIPPED
#        PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
#        PRINT
#        PRINT g_x[4]
#        PRINT g_memo
#        #No.TQC-710043 --end--
#        
#     PAGE TRAILER
#        IF l_flag ='N' THEN
#           PRINT g_dash[1,g_len]
#           PRINT COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-710043 mark
#           PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-710043
#        ELSE
#           SKIP 2 LINE 
#        END IF
#        IF l_flag = 'N' THEN  #No.TQC-710043 mark
#        IF l_flag = 'Y' THEN  #No.TQC-710043
#           IF g_memo_pagetrailer THEN
#              PRINT g_x[4]
#              PRINT g_memo
#           ELSE
#              PRINT
#              PRINT
#           END IF
#        ELSE
#           PRINT g_x[4]
#           PRINT g_memo
#        END IF
 
 
#END REPORT
#NO.FUN-860007---END------ 
##No.FUN-870144
