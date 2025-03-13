# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglp999.4gl
# Descriptions...: 國標認証檢查作業
# Date & Author..: 06/12/26 No.FUN-710056 By Carrier
# Modify.........: No.FUN-730070 07/04/10 By Carrier 會計科目加帳套-財務
#
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE #g_sql   	LIKE type_file.chr1000,
       g_sql    STRING,      #NO.FUN-910082
       g_bookno LIKE aaa_file.aaa01,
       tm       RECORD
                yy      LIKE type_file.num5,
                mm      LIKE type_file.num5,
                bookno  LIKE aaa_file.aaa01  #No.FUN-730070 
                END RECORD
 
#No.FUN-710056 ADD

DEFINE g_aaa    RECORD LIKE aaa_file.*    #FUN-BC0027

MAIN
    DEFINE p_row,p_col     LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GGL")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW p999 AT p_row,p_col
         WITH FORM "ggl/42f/gglp999"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL p999()
    CLOSE WINDOW p999
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p999()
 
   #No.FUN-730070  --Begin
   #LET g_bookno = ' '
   #IF cl_null(g_bookno) THEN
   #   SELECT aaz64 INTO g_bookno FROM aaz_file
   #END IF
   #No.FUN-730070  --End  
 
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   LET tm.bookno = g_aza.aza81  #No.FUN-730070
   WHILE TRUE
 
     CLEAR FORM
 
     INPUT BY NAME tm.yy,tm.mm,tm.bookno WITHOUT DEFAULTS  #No.FUN-730070
 
        #No.FUN-730070  --Begin
        AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL p999_bookno('a',tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               END IF
            END IF
        #No.FUN-730070  --End  
 
        #No.FUN-7300070  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bookno) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.bookno
                 CALL cl_create_qry() RETURNING tm.bookno
                 DISPLAY BY NAME tm.bookno
                 CALL p999_bookno('d',tm.bookno)
           END CASE
        #No.FUN-730070  --End
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         RETURN
      END IF
      CALL cl_wait()
      CALL p999_t()
      ERROR ''
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
#No.FUN-730070  --Begin
FUNCTION p999_bookno(p_cmd,p_bookno)
  DEFINE p_cmd      LIKE type_file.chr1,  
         p_bookno   LIKE aaa_file.aaa01, 
         l_aaaacti  LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-730070  --End  
 
FUNCTION p999_t()
   DEFINE l_sql         LIKE type_file.chr1000
   DEFINE l_name        LIKE type_file.chr20  
   DEFINE l_level       LIKE type_file.num5
   DEFINE l_aag         RECORD LIKE aag_file.*
   DEFINE l_aba         RECORD LIKE aba_file.*
   DEFINE l_abb         RECORD LIKE abb_file.*
   DEFINE l_giu         RECORD LIKE giu_file.*
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_aag08       LIKE aag_file.aag08
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE l_aah04       LIKE aah_file.aah04
   DEFINE l_aah05       LIKE aah_file.aah05
   DEFINE l_len         LIKE type_file.num5
   DEFINE l_giu01       LIKE giu_file.giu01
   DEFINE l_giu13       LIKE giu_file.giu13
   DEFINE l_beg_no      LIKE aba_file.aba11
   DEFINE l_end_no      LIKE aba_file.aba11
   DEFINE l_cnt         LIKE type_file.num10
   DEFINE l_i           LIKE type_file.num10
   DEFINE l_aba01       LIKE aba_file.aba01
   DEFINE sr            RECORD
                        aag01       LIKE aag_file.aag01,
                        aag02       LIKE aag_file.aag02,
                        aag13       LIKE aag_file.aag13,
                        aag06       LIKE aag_file.aag06,
                        aag07       LIKE aag_file.aag07,
                        aag08       LIKE aag_file.aag08,
                        aag24       LIKE aag_file.aag24
                        END RECORD
   DEFINE sr1           RECORD
                        type        LIKE type_file.num5,
                        aag01       LIKE aag_file.aag01,
                        src         LIKE aag_file.aag13,
                        des         LIKE aag_file.aag13,
                        err         LIKE ze_file.ze03
                        END RECORD
 
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.bookno   #FUN-BC0027
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   CALL cl_outnam('gglp999') RETURNING l_name
   START REPORT p999_rep TO l_name
 
   #Check-1  檢查國家標准會計科目檔
   LET l_sql = "SELECT giu01,giu13 FROM giu_file"
   PREPARE p999_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('p999_pre1',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p999_curs1 CURSOR FOR p999_pre1
 
   #Check-2  檢查會計科目檔
   LET l_sql = "SELECT aag01,aag02,aag13,aag06,aag07,aag08,aag24 ",
               "  FROM aag_file",
               " WHERE aag00 = '",tm.bookno,"'"   #No.FUN-730070
   PREPARE p999_pre2 FROM l_sql
   IF STATUS THEN CALL cl_err('p999_pre2',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p999_curs2 CURSOR FOR p999_pre2
 
   #Check-3  檢查會計憑証
   LET l_sql = "SELECT * FROM aba_file ",
               " WHERE aba00 = '",tm.bookno,"'",  #No.FUN-730070
               "   AND aba03 =  ",tm.yy,
               "   AND aba04 =  ",tm.mm,
               "   AND aba19 <> 'X' ",  #CHI-C80041
               " ORDER BY aba01 "
   PREPARE p999_pre3 FROM l_sql
   IF STATUS THEN CALL cl_err('p999_pre3',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p999_curs3 CURSOR FOR p999_pre3
   LET l_sql = "SELECT * FROM abb_file ",
               " WHERE abb00 = '",tm.bookno,"'",  #No.FUN-730070
               "   AND abb01 = ? ",
               "   AND abb04 IS NULL",
               " ORDER BY abb01 "
   PREPARE p999_pre4 FROM l_sql
   IF STATUS THEN CALL cl_err('p999_pre4',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211  
      EXIT PROGRAM 
   END IF
   DECLARE p999_curs4 CURSOR FOR p999_pre4
 
   #Check-1
   FOREACH p999_curs1 INTO l_giu01,l_giu13
      IF STATUS THEN
         CALL cl_err('p999_curs1',STATUS,1) EXIT FOREACH
      END IF
      INITIALIZE sr1.* TO NULL
      LET sr1.aag01=l_giu01
      SELECT * FROM aag_file WHERE aag01=l_giu01
                               AND aag00=tm.bookno  #No.FUN-730070
      IF SQLCA.sqlcode THEN
         LET sr1.type=1
         LET sr1.src = l_giu13
         #LET sr1.err ="國家標准會計科目沒有維護"
         CALL cl_getmsg("ggl-801",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
   END FOREACH
 
   #Check-2
   FOREACH p999_curs2 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p999_curs2',STATUS,1) EXIT FOREACH
      END IF
      #虛科目不要出來
      IF sr.aag01 = '3131-IS' OR sr.aag01 ='3135-IS' OR sr.aag01 = '3135' THEN
         CONTINUE FOREACH
      END IF
#     IF sr.aag01 = g_aaz.aaz31 OR sr.aag01 = g_aaz.aaz32 THEN   #FUN-BC0027
      IF sr.aag01 = g_aaa.aaa14 OR sr.aag01 = g_aaa.aaa15 THEN   #FUN-BC0027
         CONTINUE FOREACH
      END IF
      INITIALIZE sr1.* TO NULL
      LET sr1.aag01=sr.aag01
 
      INITIALIZE l_giu.* TO NULL
      SELECT * INTO l_giu.* FROM giu_file WHERE giu00='A' AND giu01=sr.aag01
 
      LET l_len = length(sr.aag01)
      IF l_len <> 4  AND l_len <> 6 AND l_len <>8 AND l_len <> 10 AND
         l_len <> 12 AND l_len <> 14 THEN
         LET sr1.type = 2
         LET sr1.src  = l_len
         LET sr1.des  = length(l_giu.giu01)
         #LET sr1.err  ="科目長度不符合4,2,2標准"
         CALL cl_getmsg("ggl-802",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF sr.aag13 <> l_giu.giu13 AND NOT cl_null(l_giu.giu13) THEN
         LET sr1.type=3
         LET sr1.src=sr.aag13
         LET sr1.des=l_giu.giu13
         #LET sr1.err  ="科目名稱不標准"
         CALL cl_getmsg("ggl-803",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      LET l_level = sr.aag24
      IF sr.aag24 = 99 THEN
         IF sr.aag07 = '3' THEN
            LET l_level = 1
         ELSE
            CALL gglp999_kmcj(sr.aag01)
                 RETURNING l_level
         END IF
      END IF
      IF l_level  <> l_giu.giu24 THEN
         LET sr1.type=4
         LET sr1.src=l_level
         LET sr1.des=l_giu.giu24
         #LET sr1.err  ="科目層級不正確"
         CALL cl_getmsg("ggl-804",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF sr.aag06 <> l_giu.giu06 THEN
         LET sr1.type=5
         LET sr1.src=sr.aag06
         LET sr1.des=l_giu.giu06
         #LET sr1.err  ="科目借貸別不正確"
         CALL cl_getmsg("ggl-805",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF NOT (sr.aag24 = 1 OR sr.aag07='3') THEN
         SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=sr.aag08
                                    AND aag00=tm.bookno  #No.FUN-730070
         IF l_aag06 <> sr.aag06 THEN
            LET sr1.type=6
            LET sr1.src=sr.aag06
            LET sr1.des=l_aag06
            #LET sr1.err  ="科目借貸別與上層科目不一致"
            CALL cl_getmsg("ggl-806",g_lang) RETURNING sr1.err
            OUTPUT TO REPORT p999_rep(sr1.*)
         END IF
      END IF
   END FOREACH
 
   #Check-3
   FOREACH p999_curs3 INTO l_aba.*
      IF STATUS THEN
         CALL cl_err('p999_curs3',STATUS,1) EXIT FOREACH
      END IF
      INITIALIZE sr1.* TO NULL
      LET sr1.aag01=l_aba.aba01
      IF cl_null(l_aba.abauser) THEN
         LET sr1.type=7
         #LET sr1.err ="制單人員為空"
         CALL cl_getmsg("ggl-807",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF cl_null(l_aba.aba37) THEN
         LET sr1.type=8
         #LET sr1.err ="審核人員為空"
         CALL cl_getmsg("ggl-808",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF l_aba.abapost='N' THEN
         LET sr1.type=9
         #LET sr1.err ="憑証沒有過帳"
         CALL cl_getmsg("ggl-809",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF cl_null(l_aba.aba38) THEN
         LET sr1.type=10
         #LET sr1.err ="過帳人員為空"
         CALL cl_getmsg("ggl-810",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      IF l_aba.abauser = l_aba.aba37 THEN
         LET sr1.type=11
         #LET sr1.err ="會計憑証的錄入與審核為同一人"
         CALL cl_getmsg("ggl-811",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
      FOREACH p999_curs4 USING l_aba.aba01 INTO l_abb.*
         IF STATUS THEN
            CALL cl_err('p999_curs4',STATUS,1) EXIT FOREACH
         END IF
         LET sr1.aag01=l_aba.aba01,'+',l_abb.abb02
         IF cl_null(l_abb.abb04) THEN
            LET sr1.type=12
            #LET sr1.err ="會計憑証的摘要內容為空"
            CALL cl_getmsg("ggl-812",g_lang) RETURNING sr1.err
            OUTPUT TO REPORT p999_rep(sr1.*)
         END IF
      END FOREACH
   END FOREACH
 
   #Check-4
   #當月最大/最小總號
   LET g_sql="SELECT MAX(aba11),MIN(aba11) FROM aba_file",
             " WHERE aba00 = '",tm.bookno,"'",  #No.FUN-730070
             "   AND aba03 = ",tm.yy,
             "   AND aba04 = ",tm.mm,
             "   AND aba19 <> 'X' ",  #CHI-C80041
             "   AND aba01 NOT LIKE '",g_aaz.aaz65,"%'"
   PREPARE aba_p1 FROM g_sql
   EXECUTE aba_p1 INTO l_end_no,l_beg_no
   #當月總憑証數
   LET g_sql="SELECT COUNT(*) FROM aba_file",
             " WHERE aba00 = '",tm.bookno,"'",  #No.FUN-730070
             "   AND aba03 = ",tm.yy,
             "   AND aba04 = ",tm.mm,
             "   AND abapost = 'Y'",
             "   AND aba01 NOT LIKE '",g_aaz.aaz65 CLIPPED,"%'"
   PREPARE aba_p2 FROM g_sql
   EXECUTE aba_p2 INTO l_cnt
 
   LET g_sql="SELECT UNIQUE aba01 FROM aba_file,abb_file",
             " WHERE aba00 = '",tm.bookno,"'",  #No.FUN-730070
             "   AND aba03 = ",tm.yy,
             "   AND aba04 = ",tm.mm,
             "   AND abapost = 'Y'",
             "   AND aba01 NOT LIKE '",g_aaz.aaz65 CLIPPED,"%'",
             "   AND aba00 = abb00 AND aba01 = abb01 ",
             "   AND aba11 = ?"
   PREPARE aba_p3 FROM g_sql
   #有憑証不連號現象(可能有些憑証沒有過帳,但沒有過帳的憑証是不能匯出)
   IF l_cnt <> l_end_no - l_beg_no + 1 THEN
      FOR l_i = l_beg_no TO l_end_no
          EXECUTE aba_p3 USING l_i INTO l_aba01
          IF SQLCA.sqlcode = 100 THEN
             INITIALIZE sr1.* TO NULL
             LET sr1.type=13
             LET sr1.src = l_i
             #LET sr1.err ="總號不存在或憑証沒有過帳或憑証沒有單身"
             CALL cl_getmsg("ggl-813",g_lang) RETURNING sr1.err
             OUTPUT TO REPORT p999_rep(sr1.*)
          END IF
      END FOR
   END IF
 
   #Check-5
   #檢查一級科目總借/總貸是否平衡
   SELECT SUM(aah04),SUM(aah05) INTO l_aah04,l_aah05
     FROM aah_file
    WHERE aah00 = tm.bookno  #No.FUN-730070
      AND aah02 = tm.yy
      AND aah03 = tm.mm
      AND aah01 IN (SELECT aag01 FROM aag_file
                     WHERE aag24 = 1 OR aag07='3'
                       AND aag00 = tm.bookno )  #一級科目或是獨立科目  #No.FUN-730070
   IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
   IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
   IF l_aah04 <> l_aah05 THEN
      INITIALIZE sr1.* TO NULL
      LET sr1.type=14
      LET sr1.src = l_aah04
      LET sr1.des  = l_aah05
      #LET sr1.err  ="一級科目總借/貸不平衡"
      CALL cl_getmsg("ggl-814",g_lang) RETURNING sr1.err
      OUTPUT TO REPORT p999_rep(sr1.*)
   END IF
 
   #Check-6
   #檢查父級和子級總借/總貸是否平衡
   DECLARE p999_par_cur CURSOR FOR
    SELECT UNIQUE aag08 FROM aag_file
     WHERE aag08 <> aag01
       AND aag08 IS NOT NULL
       AND aag00 = tm.bookno  #No.FUN-730070
   FOREACH p999_par_cur INTO l_aag08
      IF SQLCA.sqlcode THEN
         CALL cl_err("declare p999_par_cur",SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      SELECT SUM(aah04-aah05) INTO l_aah04  #父層余額
        FROM aah_file
       WHERE aah00 = tm.bookno  #No.FUN-730070
         AND aah01 = l_aag08
         AND aah02 = tm.yy
         AND aah03 = tm.mm
      IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
 
      SELECT SUM(aah04-aah05) INTO l_aah05  #子層余額
        FROM aah_file
       WHERE aah00 = tm.bookno  #No.FUN-730070
         AND aah01 IN (SELECT aag01 FROM aag_file
                        WHERE aag08 = l_aag08
                          AND aag00 = tm.bookno  #No.FUN-730070
                          AND aag01 <> aag08
                          AND aag08 IS NOT NULL)
         AND aah02 = tm.yy
         AND aah03 = tm.mm
      IF cl_null(l_aah05) THEN LET l_aah05 = 0 END IF
      IF l_aah04 <> l_aah05 THEN
         INITIALIZE sr1.* TO NULL
         LET sr1.type=15
         LET sr1.aag01= l_aag08
         LET sr1.src  = l_aah04
         LET sr1.des  = l_aah05
         #LET sr1.err  ="父級和子級總借/總貸不平衡"
         CALL cl_getmsg("ggl-815",g_lang) RETURNING sr1.err
         OUTPUT TO REPORT p999_rep(sr1.*)
      END IF
 
   END FOREACH
 
   FINISH REPORT p999_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
REPORT p999_rep(sr)
   DEFINE sr            RECORD
                        type        LIKE type_file.num5,
                        aag01       LIKE aag_file.aag01,
                        src         LIKE aag_file.aag13,
                        des         LIKE aag_file.aag13,
                        err         LIKE ze_file.ze03
                        END RECORD
   DEFINE l_last_sw     LIKE type_file.chr1  
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT   MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE   LENGTH g_page_line
  ORDER BY sr.type,sr.aag01
  FORMAT
    PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED  #MOD-630098 by HCN 20060522
        PRINT
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
        LET g_pageno=g_pageno+1
        LET pageno_total=PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED,pageno_total
        PRINT g_dash[1,g_len]
        PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
        PRINT g_dash1
        LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.type
       SKIP TO TOP OF PAGE
 
    ON EVERY ROW
       PRINT COLUMN g_c[31],sr.aag01 CLIPPED,
             COLUMN g_c[32],sr.src CLIPPED,
             COLUMN g_c[33],sr.des CLIPPED,
             COLUMN g_c[34],sr.err CLIPPED
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION gglp999_kmcj(p_aag01)
   DEFINE p_aag01 LIKE aag_file.aag01
   DEFINE l_aag08 LIKE aag_file.aag08
   DEFINE l_level LIKE aag_file.aag24
 
   SELECT aag08 INTO l_aag08 FROM aag_file WHERE aag01 = p_aag01
                                             AND aag00 = tm.bookno  #No.FUN-730070
   SELECT aag24+1 INTO l_level FROM aag_file WHERE aag01 = l_aag08
                                             AND aag00 = tm.bookno  #No.FUN-730070
   RETURN l_level
END FUNCTION
 
