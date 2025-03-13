# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: azzr901.4gl
# Descriptions...:帳號登陸狀況查詢表
# Date & Author..: 09/08/17 By jan
# Modify.........: No:FUN-980056 09/08/17 By jan
# Modify.........: No:MOD-B10088 11/01/12 By Carrier 正式区无此作业,重新过单
# Modify.........: No:FUN-B80037 11/08/03 By fanbj l_time改為g_time,EXIT PROTRAM前加cl_used(2)
# Modify.........: No:MOD-B70260 11/07/28 By Vampire QBE開窗無法使用
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:FUN-C30190 12/03/22 By yangxf  将老报表转换为CR报表

DATABASE ds

GLOBALS "../../config/top.global"   #No.MOD-B10088

   DEFINE tm  RECORD            
              wc      STRING, 
              s       LIKE type_file.chr3,   
              t       LIKE type_file.chr3,    
              u       LIKE type_file.chr3,     
              b_date  LIKE type_file.dat ,
              e_date  LIKE type_file.dat,
              more    LIKE type_file.chr1       
              END RECORD

DEFINE   g_i            LIKE type_file.num5   #count/index for any purpose
DEFINE   g_sql          STRING                #FUN-C30190 add
DEFINE   l_table        STRING                #FUN-C30190 add
DEFINE   g_str          STRING                #FUN-C30190 add

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF


   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
#FUN-C30190 add begin ---
   LET g_sql = "zx01.zx_file.zx01,",
               "zx02.zx_file.zx02,",
               "zx03.zx_file.zx03,",
               "gem02.gem_file.gem02,",
               "gen04.gen_file.gen04,",
               "tlf905.tlf_file.tlf905,",
               "tlf06.tlf_file.tlf06,",
               "l_cnt.type_file.num5,",
               "l_gat03.gat_file.gat03"
   LET l_table = cl_prt_temptable('azzr901',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
#FUN-C30190 add end ---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  # No.FUN-B80037--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r901_tm(0,0)        
   ELSE CALL r901()             
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  # No.FUN-B80037--add--
END MAIN

FUNCTION r901_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000

   LET p_row = 5 LET p_col = 16
   
   OPEN WINDOW r901_w AT p_row,p_col WITH FORM "azz/42f/azzr901" 
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.e_date = g_today
   LET tm.b_date = g_today - 7

WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON zx01, zx03  

        ON ACTION CONTROLP   
           #MOD-B70260 --- modify --- start ---
            CASE WHEN INFIELD(zx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO zx01
                 NEXT FIELD zx01
            WHEN INFIELD(zx03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO zx03
                 NEXT FIELD zx03
            END CASE
           #MOD-B70260 --- modify ---  end  ---
        
        ON ACTION locale
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
      
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

  
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r901_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time # No.FUN-B80037--add---
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0) 
   END WHILE
   
   INPUT BY NAME tm.b_date,tm.e_date,tm.more WITHOUT DEFAULTS 

      AFTER FIELD b_date
         IF cl_null(tm.b_date) THEN
            NEXT FIELD b_date
         END IF

      AFTER FIELD e_date
         IF cl_null(tm.e_date) THEN
            NEXT FIELD e_date
         END IF
         IF tm.e_date < tm.b_date THEN
            NEXT FIELD e_date
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time # No.FUN-B80037--add---
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='azzr901'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('azzr901','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'", 
                         " '",g_template CLIPPED,"'" 
         CALL cl_cmdat('azzr901',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r901_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time # No.FUN-B80037--add---
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r901()
   ERROR ""
END WHILE
   CLOSE WINDOW r901_w
END FUNCTION

FUNCTION r901()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
          l_time    LIKE type_file.chr10,        # Used time for running the job
          l_sql     STRING,                      # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE za_file.za05,
          sr               RECORD 
                                  zx01   LIKE zx_file.zx01,
                                  zx02   LIKE zx_file.zx02,
                                  zx03   LIKE zx_file.zx03,
                                  gem02  LIKE gem_file.gem02,
                                  gen04  LIKE gen_file.gen04,
                                  tlf905 LIKE tlf_file.tlf905,
                                  tlf06  LIKE tlf_file.tlf06
                        END RECORD
     #----No.FUN-B80037----------------------------------
     #  CALL cl_used(g_prog,l_time,1) RETURNING l_time 
     # CALL cl_used(g_prog,g_time,1) RETURNING g_time
     #----No.FUN-B80037----------------------------------

#FUN-C30190 add begin ---
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?) "
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
#FUN-C30190 add end ----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_len = 80      
     IF g_priv2='4' THEN
         LET tm.wc = tm.wc clipped," AND pmhuser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN
         LET tm.wc = tm.wc clipped," AND pmhgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF
     IF g_dbs = 'ds' THEN
        #LET l_sql = "SELECT zx01,zx02,gen03,gem02,gen04 ",
        #            " FROM zx_file,gen_file,gem_file ",  
        #            " WHERE zx03 = gem01(+) ",    
        #            " AND zx01 = gen01(+) ",
        #            " AND ", tm.wc CLIPPED
        LET l_sql = "SELECT zx01,zx02,gen03,gem02,gen04 ",
                    " FROM zx_file ",
                    " LEFT OUTER JOIN gem_file ON gem01=zx03 ",
                    " LEFT OUTER JOIN gen_file ON gen01=zx01 ",
                    "WHERE ", tm.wc CLIPPED
     ELSE
        #LET l_sql = "SELECT zx01,zx02,gen03,gem02,gen04 ",
        #            "  FROM zx_file,gen_file,gem_file ",  
        #            " WHERE zx03 = gem01(+) ",    
        #            "   AND zx01 = gen01 ",
        #            "   AND ", tm.wc CLIPPED,
        #            " UNION ",
        #            "SELECT zx01,zx02,'','','' ",
        #            "  FROM zx_file ",  
        #            " WHERE zx01 in ('topgui','tiptop','toptest') "
        LET l_sql = "SELECT zx01,zx02,gen03,gem02,gen04 ",
                    "  FROM gen_file,zx_file ",
                    "  LEFT OUTER JOIN gem_file ON gem01=zx03 ",     
                    " WHERE zx01 = gen01 ",
                    "   AND ", tm.wc CLIPPED,
                    " UNION ",
                    "SELECT zx01,zx02,'','','' ",
                    "  FROM zx_file ",  
                    " WHERE zx01 in ('topgui','tiptop','toptest') "

     END IF
     PREPARE r901_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time # No.FUN-B80037--add---
        EXIT PROGRAM 
     END IF
     DECLARE r901_curs1 CURSOR FOR r901_prepare1
#    CALL cl_outnam('azzr901') RETURNING l_name            #FUN-C30190 mark

#    START REPORT r901_rep TO l_name                       #FUN-C30190 mark
     FOREACH r901_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('foreach:',SQLCA.sqlcode,1) 
             EXIT FOREACH 
          END IF
#         OUTPUT TO REPORT r901_rep(sr.*)                  #FUN-C30190 mark
#FUN-C30190 add begin ---
          CALL ins_table(sr.*)                             #FUN-C30190 add
#FUN-C30190 add end -----
     END FOREACH
#    FINISH REPORT r901_rep                                #FUN-C30190 mark

#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #FUN-C30190 mark
#FUN-C30190 add begin ---
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " ORDER BY zx01,zx02,zx03"
     LET g_str = tm.wc,";",tm.b_date,";",tm.e_date,";"
     CALL cl_prt_cs3('azzr901','azzr901',l_sql,g_str)
#FUN-C30190 add end ----

   #No.FUN-BB0047--mark--Begin---
   #  #No.FUN-B80037-----------------------------------
   #  #  CALL cl_used(g_prog,l_time,2) RETURNING l_time
   #  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   #  #No.FUN-B80037-----------------------------------
   #No.FUN-BB0047--mark--End-----
END FUNCTION

#FUN-C30190 add begin ---
FUNCTION ins_table(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,
          l_azi03      LIKE azi_file.azi03,
          l_sql        STRING,       # RDSQL STATEMENT
          l_sql2       STRING,       # RDSQL STATEMENT
          sr               RECORD
                                  zx01   LIKE zx_file.zx01,
                                  zx02   LIKE zx_file.zx02,
                                  zx03   LIKE zx_file.zx03,
                                  gem02  LIKE gem_file.gem02,
                                  gen04  LIKE gen_file.gen04,
                                  tlf905 LIKE tlf_file.tlf905,
                                  tlf06  LIKE tlf_file.tlf06
                        END RECORD,
          l_gat03      LIKE gat_file.gat03,
          l_gaq01      LIKE gaq_file.gaq01,
          l_cnt99      LIKE type_file.num5,
          l_user       LIKE zx_file.zx01,
          l_date       LIKE zx_file.zx01,
          l_modu       LIKE zx_file.zx01,
          l_head03     LIKE type_file.chr3,
          l_head04     LIKE type_file.chr3,
          l_table01    LIKE type_file.chr10
      LET l_sql = "SELECT gaq01 FROM gaq_file ",
                  "WHERE SUBSTR(gaq01,4,4) = 'modu' ",
                  "   AND gaq02='0' ",
                  "ORDER BY 1"
      PREPARE r901_pmp FROM l_sql
      DECLARE pmp_cs CURSOR FOR r901_pmp
      FOREACH pmp_cs INTO l_gaq01
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_cnt99 = 0
         LET l_head03 = l_gaq01
         LET l_user = l_head03 CLIPPED,"user"
         LET l_date = l_head03 CLIPPED,"date"
         LET l_table01 = l_head03 CLIPPED,"_file"
         LET l_sql2 = "SELECT count(*) FROM ",l_table01,
                      " WHERE (",l_gaq01," = '",sr.zx01,"' OR ",l_user,
                      " = '",sr.zx01,"') ",
                      " AND ",l_date," BETWEEN '",tm.b_date,"' AND '",
                      tm.e_date,"' "

         DECLARE r901_b_c1 CURSOR FROM l_sql2
         OPEN r901_b_c1
         FETCH r901_b_c1 INTO l_cnt99
         LET l_sql2 = "SELECT gat03 FROM gat_file ",
                      " WHERE gat01 = '",l_table01,"' AND gat02 = '0' "
         DECLARE r901_b_c2 CURSOR FROM l_sql2
         OPEN r901_b_c2
         FETCH r901_b_c2 INTO l_gat03
         IF l_cnt99 > 0 THEN
            EXECUTE  insert_prep  USING sr.*,l_cnt99,l_gat03
         END IF
      END FOREACH
      LET l_sql = "SELECT gaq01 FROM gaq_file ",
                  " WHERE SUBSTR(gaq01,5,4) = 'modu' ",
                  "   AND gaq02='0' ",
                  " ORDER BY 1"
      PREPARE r901_pmp2 FROM l_sql
      DECLARE pmp_cs2 CURSOR FOR r901_pmp2    #CURSOR
      FOREACH pmp_cs2 INTO l_gaq01
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_cnt99 = 0
         LET l_head04 = l_gaq01
         LET l_user = l_head04 CLIPPED,"user"
         LET l_date = l_head04 CLIPPED,"date"
         LET l_table01 = l_head04 CLIPPED,"_file"
         LET l_sql2 = "SELECT count(*) FROM ",l_table01,
                      " WHERE (",l_gaq01," = '",sr.zx01,"' OR ",l_user,
                      " = '",sr.zx01,"') ",
                      " AND ",l_date," BETWEEN '",tm.b_date,"' AND '",
                      tm.e_date,"' "
         DECLARE r901_b_c3 CURSOR FROM l_sql2
         OPEN r901_b_c3
         FETCH r901_b_c3 INTO l_cnt99
         LET l_sql2 = "SELECT gat03 FROM gat_file ",
                      " WHERE gat01 = '",l_table01,"' AND gat02 = '0' "
         DECLARE r901_b_c4 CURSOR FROM l_sql2
         OPEN r901_b_c4
         FETCH r901_b_c4 INTO l_gat03
         IF l_cnt99 > 0 THEN
            EXECUTE  insert_prep  USING sr.*,l_cnt99,l_gat03
         END IF
      END FOREACH
END FUNCTION
#FUN-C30190 add end -----

#FUN-C30190 mark begin ---
#REPORT r901_rep(sr)
#   DEFINE l_ima021     LIKE ima_file.ima021  
#   DEFINE l_last_sw    LIKE type_file.chr1,
#          l_azi03      LIKE azi_file.azi03,
#          l_sql        STRING,       # RDSQL STATEMENT
#          l_sql2       STRING,       # RDSQL STATEMENT
#          sr               RECORD 
#                                  zx01   LIKE zx_file.zx01,
#                                  zx02   LIKE zx_file.zx02,
#                                  zx03   LIKE zx_file.zx03,
#                                  gem02  LIKE gem_file.gem02,
#                                  gen04  LIKE gen_file.gen04,
#                                  tlf905 LIKE tlf_file.tlf905,
#                                  tlf06  LIKE tlf_file.tlf06
#                        END RECORD,
#          l_gat03      LIKE gat_file.gat03,
#          l_gaq01      LIKE gaq_file.gaq01,
#          l_cnt99      LIKE type_file.num5,
#          l_i          LIKE type_file.num5,
#          l_j          LIKE type_file.num5,
#          l_user       LIKE zx_file.zx01,
#          l_date       LIKE zx_file.zx01,
#          l_modu       LIKE zx_file.zx01,
#          l_head03     LIKE type_file.chr3,
#          l_head04     LIKE type_file.chr3,
#          l_table01    LIKE type_file.chr10
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN 0
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#  ORDER BY sr.zx03,sr.zx01
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.zx01
#      PRINT COLUMN g_c[31],sr.zx01,
#            COLUMN g_c[32],sr.zx02,
#            COLUMN g_c[33],sr.zx03,sr.gem02;
#
#   ON EVERY ROW
#
#      LET l_sql = "SELECT gaq01 FROM gaq_file ",
#                  " WHERE SUBSTR(gaq01,4,4) = 'modu' ",
#                  "   AND gaq02='0' ",
#                  " ORDER BY 1"
#      PREPARE r901_pmp FROM l_sql
#      DECLARE pmp_cs CURSOR FOR r901_pmp    #CURSOR
#      FOREACH pmp_cs INTO l_gaq01
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            LET g_success = 'N'
#            EXIT FOREACH
#         END IF
#         
#         LET l_cnt99 = 0 
#         LET l_head03 = l_gaq01
#         LET l_user = l_head03 CLIPPED,"user"
#         LET l_date = l_head03 CLIPPED,"date"
#         LET l_table01 = l_head03 CLIPPED,"_file"
#
#         LET l_sql2 = "SELECT count(*) FROM ",l_table01,
#                      " WHERE (",l_gaq01," = '",sr.zx01,"' OR ",l_user,
#                      " = '",sr.zx01,"') ",
#                      " AND ",l_date," BETWEEN '",tm.b_date,"' AND '",
#                      tm.e_date,"' "
#
#         DECLARE r901_b_c1 CURSOR FROM l_sql2
#         OPEN r901_b_c1
#         FETCH r901_b_c1 INTO l_cnt99
#
#         LET l_sql2 = "SELECT gat03 FROM gat_file ",
#                      " WHERE gat01 = '",l_table01,"' AND gat02 = '0' "
#         DECLARE r901_b_c2 CURSOR FROM l_sql2
#         OPEN r901_b_c2
#         FETCH r901_b_c2 INTO l_gat03
#
#         IF l_cnt99 > 0 THEN
#            PRINT COLUMN g_c[34],l_gat03,
#                  COLUMN g_c[35],l_cnt99 USING "--,---",g_x[10] CLIPPED
#         END IF
#
#      END FOREACH
#
#      LET l_sql = "SELECT gaq01 FROM gaq_file ",
#                  " WHERE SUBSTR(gaq01,5,4) = 'modu' ",
#                  "   AND gaq02='0' ",
#                  " ORDER BY 1"
#      PREPARE r901_pmp2 FROM l_sql
#      DECLARE pmp_cs2 CURSOR FOR r901_pmp2    #CURSOR
#      FOREACH pmp_cs2 INTO l_gaq01
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            LET g_success = 'N'
#            EXIT FOREACH
#         END IF
#         
#         LET l_cnt99 = 0 
#         LET l_head04 = l_gaq01
#         LET l_user = l_head04 CLIPPED,"user"
#         LET l_date = l_head04 CLIPPED,"date"
#         LET l_table01 = l_head04 CLIPPED,"_file"
#
#         LET l_sql2 = "SELECT count(*) FROM ",l_table01,
#                      " WHERE (",l_gaq01," = '",sr.zx01,"' OR ",l_user,
#                      " = '",sr.zx01,"') ",
#                      " AND ",l_date," BETWEEN '",tm.b_date,"' AND '",
#                      tm.e_date,"' "
#
#         DECLARE r901_b_c3 CURSOR FROM l_sql2
#         OPEN r901_b_c3
#         FETCH r901_b_c3 INTO l_cnt99
#
#         LET l_sql2 = "SELECT gat03 FROM gat_file ",
#                      " WHERE gat01 = '",l_table01,"' AND gat02 = '0' "
#         DECLARE r901_b_c4 CURSOR FROM l_sql2
#         OPEN r901_b_c4
#         FETCH r901_b_c4 INTO l_gat03
#
#         IF l_cnt99 > 0 THEN
#            PRINT COLUMN g_c[34],l_gat03,
#                  COLUMN g_c[35],l_cnt99 USING "--,---",g_x[10] CLIPPED
#         END IF
#
#      END FOREACH
#
#      IF cl_null(sr.tlf905) or sr.tlf905 = '' THEN
#         PRINT
#      END IF
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'zx01,zx02,zx03')
#              RETURNING tm.wc
#         PRINT g_dash
# Prog. Version..: '5.30.06-13.03.12(001,070) > ' ' THEN            # for 80
#         PRINT g_x[8] CLIPPED,tm.wc.substring(001,070) CLIPPED
#         PRINT g_x[9] CLIPPED,' : ',tm.b_date,'-',tm.e_date  END IF
#              IF tm.wc.substring(071,140) > ' ' THEN
#          PRINT COLUMN 10,     tm.wc.substring(071,140) CLIPPED END IF
#              IF tm.wc.substring(141,210) > ' ' THEN
#          PRINT COLUMN 10,     tm.wc.substring(141,210) CLIPPED END IF
#              IF tm.wc.substring(211,280) > ' ' THEN
#          PRINT COLUMN 10,     tm.wc.substring(211,280) CLIPPED END IF
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED 
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED 
#         ELSE SKIP 3 LINE
#      END IF
#END REPORT
#FUN-C30190 mark end---
#FUN-980056
