# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abxr010.4gl
# Descriptions...: 放行單管制卡
# Date & Author..: 96/07/23 By STAR 
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6C0152 07/01/08 By xufeng 接下頁和結束上方應是雙橫線
# Modify.........: No.FUN-750112 07/06/15 By Jackho CR報表修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql

 
DATABASE ds
 
GLOBALS "../../config/top.global"
#########################No.FUN-680062 BEGIN######################
   DEFINE tm  RECORD                # Print condition RECORD
#              wc      VARCHAR(1000),    # Where condition
#              bdate   DATE,
#              edate   DATE,
#              more    VARCHAR(1),        # Input more condition(Y/N)
#              a       VARCHAR(1),   
#              s       VARCHAR(2),        # Order by sequence
#              t       VARCHAR(2)         # Eject sw
#             wc    LIKE type_file.chr1000,
              wc    STRING　,　　　#NO.FUN-910082
              edate LIKE type_file.dat,   
              bdate LIKE type_file.dat,   
              more  LIKE type_file.chr1,  
              a     LIKE bna_file.bna06,   
              s     LIKE type_file.chr2,  
              t     LIKE type_file.chr2  
             END RECORD,   
##########################No.FUN-680062-END##########################
           g_mount   LIKE type_file.num10,   #No.FUN-680062  integer
           g_chars   LIKE zaa_file.zaa08     #No.FUN-680062  VARCHAR(10) 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE  l_table     STRING                   ### FUN-750112 ###
DEFINE  g_str       STRING                   ### FUN-750112 ###
DEFINE  g_sql       STRING                   ### FUN-750112 ###
 
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
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
#----------------No.TQC-610081 modify
   LET tm.a      = ARG_VAL(10)
   LET tm.bdate  = ARG_VAL(11)
   LET tm.edate  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "bnb01.bnb_file.bnb01,",
                "bnb02.bnb_file.bnb02,",
                "bnb03.bnb_file.bnb03,",
                "bnb04.bnb_file.bnb04,",
                "bnb09.bnb_file.bnb09,",
                "bnb12.bnb_file.bnb12,",
                "bnb13.bnb_file.bnb13,",
                "bxj11.bxj_file.bxj11,",
                "bnb06.bnb_file.bnb06,",
                "bnb07.bnb_file.bnb07,",
                "bnb16.bnb_file.bnb16 "
 
    LET l_table = cl_prt_temptable('abxr010',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #TQC-A40116 mod
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#--------------------No.FUN-750112--end------CR (1) ------------#
#----------------No.TQC-610081 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr010_tm(4,10)        # Input print condition
      ELSE CALL abxr010()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr010_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062CHAR(1000)
 
   LET p_row = 5 LET p_col = 20
       
   OPEN WINDOW abxr010_w AT p_row,p_col WITH FORM "abx/42f/abxr010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.a = '1'
   LET tm.s  = '21'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1' 
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   INPUT BY NAME tm.bdate,tm.edate,tm.a,tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,tm.more
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
 
 
 
      AFTER FIELD bdate
           IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF 
 
      AFTER FIELD edate
           IF cl_null(tm.edate) OR tm.edate<tm.bdate 
           THEN NEXT FIELD edate END IF 
 
      AFTER FIELD a
           IF cl_null(tm.a) OR 
              tm.a NOT MATCHES '[1-3]' THEN 
              NEXT FIELD a
           END IF
 
#FUN-530012  移到abxr010() Function  
#          CASE WHEN tm.a = '1'
#               LET g_chars='保稅物品'
#               WHEN tm.a = '2'
#               LET g_chars='免稅物品'
#               WHEN tm.a = '3'
#               LET g_chars='非保稅物品'
#          END CASE
 
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
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr010_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr010'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr010','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s  CLIPPED,"'",
                         " '",tm.t  CLIPPED,"'",
                         " '",tm.a  CLIPPED,"'",
                         " '",tm.bdate  CLIPPED,"'",
                         " '",tm.edate  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                         
         CALL cl_cmdat('abxr010',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr010()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr010_w
END FUNCTION
 
FUNCTION i010_create_temp()
   DROP TABLE b1_temp
#FUN-680062-BEGIN
   CREATE TEMP TABLE b1_temp(
     bnb09   LIKE bnb_file.bnb09,
     num     LIKE type_file.num10);
#FUN-680062-END
END FUNCTION
 
FUNCTION abxr010()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680062    VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT     #No.FUN-680062 VARCHAR(1000)
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1,            #No.FUN-680062  VARCHAR(1)  
          l_za      LIKE type_file.chr1000,               #No.FUN-680062  VARCHAR(40)  
          l_order   ARRAY[2] OF LIKE bxi_file.bxi01,           #No.FUN-550033  #No.FUN-680062 VARCHAR(16)  
          l_bnc02   LIKE bnc_file.bnc02,
          sr               RECORD order1 LIKE bxi_file.bxi01,   #No.FUN-550033   #No.FUN-680062    VARCHAR(16)
                                  order2 LIKE bxi_file.bxi01,   #No.FUN-550033   #No.FUN-680062     VARCHAR(16)  
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb09  LIKE bnb_file.bnb09,
                                  bnb12  LIKE bnb_file.bnb12,
                                  bnb13  LIKE bnb_file.bnb13,
                                  code1  LIKE type_file.chr20,   #No.FUN-680062 VARCHAR(20)
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnb07  LIKE bnb_file.bnb07,
                                  bnb16  LIKE bnb_file.bnb16
                        END RECORD
   DEFINE xr            RECORD bnb09  LIKE bnb_file.bnb09,              #No.FUN-750112
                               num   LIKE type_file.num10               #No.FUN-750112
                        END RECORD
#--------------------No.FUN-750112--begin----CR(2)----------------#
     CALL cl_del_data(l_table)
#--------------------No.FUN-750112--end------CR(2)----------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','',bnb01,      bnb02,bnb03,bnb04,bnb09, ",
                 "       bnb12,bnb13,' ',bnb06,bnb07,bnb16 ",
                 "  FROM bnb_file,bna_file  ",
                 " WHERE bnb02 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
#No.FUN-550033--begin
#                "   AND bna01=bnb01[1,3] ",
                 "   AND bnb01 like rtrim(bna01) || '-%' ",
#No.FUN-550033--end   
                 "   AND bna06 = '",tm.a,"'",
                 "   AND ",tm.wc CLIPPED
 
     SELECT azi03,azi04,azi05 
       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
       FROM azi_file
      WHERE azi01=g_aza.aza17
 
     PREPARE abxr010_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr010_curs1 CURSOR FOR abxr010_prepare1
 
#No.FUN-750112 mark--begin
#     CALL cl_outnam('abxr010') RETURNING l_name                     
 
#     CASE WHEN tm.a = '1'
#          LET g_chars=g_x[12]
#          WHEN tm.a = '2'
#          LET g_chars=g_x[13]
#          WHEN tm.a = '3'
#          LET g_chars=g_x[14]
#     END CASE
 
#     START REPORT abxr010_rep TO l_name      
#     LET g_pageno = 0                       
#No.FUN-750112 mark--end
     CALL i010_create_temp()
     LET g_mount = 0 
     FOREACH abxr010_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
#         DECLARE r010_curb SCROLL CURSOR FOR 
#         SELECT bnc02 FROM bnc_file WHERE bnc01 = sr.bnb01
#         FETCH FIRST r010_curb INTO l_bnc02 
#       IF sr.bnb03 = '2' THEN 
#         IF cl_null(l_bnc02) OR STATUS THEN LET l_bnc02 = 1 END IF 
          SELECT bxj11 INTO sr.code1 FROM bxj_file WHERE bxj01 = sr.bnb04  
#         SELECT bxj11 INTO sr.code1 FROM bxj_file 
#          WHERE bxj01 = sr.bnb04 AND bxj03 = l_bnc02 
#         IF STATUS THEN 
#            SELECT oga38,oga39 INTO l_oga38,l_oga39 FROM oga_file 
#             WHERE oga01 = sr.bnb04
#            IF NOT STATUS THEN LET sr.code1 = l_oga38,l_oga39 END IF 
#         END IF 
#         IF cl_null(sr.code1) THEN LET sr.code1 = ' ' END IF 
#       END IF 
#      IF sr.bnb03 !='1' THEN 
#         LET sr.code2 = sr.bnb04 
#      ELSE
#         SELECT sfs03 INTO sr.code2 FROM sfs_file
#          WHERE sfs01 = sr.bnb04 AND sfs02 = l_bnc02
#      END IF 
#      IF cl_null(sr.code2) THEN LET sr.code2 = ' ' END IF 
 
#No.FUN-750112 mark
#       FOR g_i = 1 TO 2
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bnb01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bnb02 USING 'YYYYMMDD'
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#No.FUN-750112 mark
       IF cl_null(sr.bnb09) THEN LET sr.bnb09 = NULL END IF 
       UPDATE b1_temp SET num = num + 1 WHERE bnb09 = sr.bnb09
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          INSERT INTO b1_temp VALUES(sr.bnb09,1)
       END IF
#--------------------No.FUN-750112---begin---CR(3)----------------#
       EXECUTE insert_prep USING 
             sr.bnb01,sr.bnb02,sr.bnb03,sr.bnb04,
             sr.bnb09,sr.bnb12,sr.bnb13,sr.code1,
             sr.bnb06,sr.bnb07,sr.bnb16
       LET g_mount = g_mount + 1
#       OUTPUT TO REPORT abxr010_rep(sr.*)
     END FOREACH
#--------------------No.FUN-750112---end-----CR(3)----------------#
 
#--------------------No.FUN-750112--begin----CR(4)----------------#
#     FINISH REPORT abxr010_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_str=tm.a,";",g_mount,";",tm.s[1,1],";",tm.s[2,2],";",
               tm.s[1,1],";",tm.s[2,2],";",g_azi03,";",g_azi04,";",g_azi05,";",'0'
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('abxr010','abxr010',l_sql,g_str)
#--------------------No.FUN-750112--end------CR(4)----------------#
END FUNCTION
 
#REPORT abxr010_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680062 VARCHAR(1)   
#          l_len        LIKE type_file.num5,                 #No.FUN-680062 smallint  
#          l_str        STRING,        
#          xr               RECORD bnb09  LIKE bnb_file.bnb09,
#                                  num   LIKE type_file.num10     #No.FUN-680062  integer 
#                        END RECORD,
#          sr               RECORD order1 LIKE bnb_file.bnb01,  #No.FUN-680062 VARCHAR(16)  
#                                  order2 LIKE bnb_file.bnb01,  #No.FUN-680062 VARCHAR(16)  
#                                  bnb01  LIKE bnb_file.bnb01,
#                                  bnb02  LIKE bnb_file.bnb02,
#                                  bnb03  LIKE bnb_file.bnb03,
#                                  bnb04  LIKE bnb_file.bnb04,
#                                  bnb09  LIKE bnb_file.bnb09,
#                                  bnb12  LIKE bnb_file.bnb12,
#                                  bnb13  LIKE bnb_file.bnb13,
#                                  code1  LIKE type_file.chr20,     #No.FUN-680062   
#                                  bnb06  LIKE bnb_file.bnb06,
#                                  bnb07  LIKE bnb_file.bnb07,
#                                  bnb16  LIKE bnb_file.bnb16
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2
#  FORMAT
#   PAGE HEADER
#      LET l_str=g_chars CLIPPED,g_x[1] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT 
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN 
#         SKIP TO TOP OF PAGE
#     END IF
#
#   BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN 
#        SKIP TO TOP OF PAGE
#     END IF
#
#   ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.bnb01,
#               COLUMN g_c[32],sr.bnb02,
#               COLUMN g_c[33],sr.bnb09,
#               COLUMN g_c[34],sr.bnb12,
#               COLUMN g_c[35],sr.bnb13,
#               COLUMN g_c[36],sr.code1,
#               COLUMN g_c[37],sr.bnb06,
#               COLUMN g_c[38],sr.bnb16
#
#   ON LAST ROW
#      PRINT g_dash
#      PRINT g_x[9] CLIPPED,g_mount USING '##,##&' ,g_x[10] CLIPPED
#      DECLARE abxr010_curs2 CURSOR FOR
#       SELECT bnb09,num FROM b1_temp
#         FOREACH abxr010_curs2 INTO xr.*
#           IF SQLCA.sqlcode != 0 THEN 
#              CALL cl_err('foreach:',SQLCA.sqlcode,1)
#              EXIT FOREACH 
#           END IF
#           PRINT xr.bnb09 ,':',xr.num USING '##,##&',g_x[11] CLIPPED
#         END FOREACH
#     #PRINT g_dash2    #No.TQC-6C0152
#      PRINT g_dash     #No.TQC-6C0152
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#          #PRINT g_dash2    #No.TQC-6C0152
#           PRINT g_dash     #No.TQC-6C0152
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#           SKIP 2 LINE
#       END IF
#
#END REPORT
