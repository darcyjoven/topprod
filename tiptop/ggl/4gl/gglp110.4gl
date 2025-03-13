# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglp110.4gl
# Descriptions...: 用友財務軟件接口作業
# Date & Author..: 02/05/24 By Danny
# Modify.........: No.FUN-510007 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_sql   	string,  #No.FUN-580092 HCN
        tm       RECORD
                wc    LIKE type_file.chr1000,      #NO.FUN-690009 VARCHAR(600)
                a     LIKE type_file.chr1,         #NO.FUN-690009 VARCHAR(01)
                b     LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(01)
                END RECORD
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0097
    DEFINE p_row,p_col     LIKE type_file.num5          #NO.FUN-690009 SMALLINT
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
    OPEN WINDOW p110 AT p_row,p_col
         WITH FORM "ggl/42f/gglp110"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
    CALL cl_opmsg('z')
    CALL p110()
    CLOSE WINDOW p110
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
END MAIN
 
FUNCTION p110()
   WHILE TRUE
 
      CLEAR FORM
 
      CONSTRUCT BY NAME tm.wc ON aba00,aba01,aba02,aba06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
        CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET tm.a = '1'
      LET tm.b = '1'
 
      INPUT BY NAME tm.a,tm.b WITHOUT DEFAULTS
 
         AFTER FIELD a
           IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
              NEXT FIELD a
           END IF
 
         AFTER FIELD b
           IF cl_null(tm.b) OR tm.b NOT MATCHES '[123]' THEN
              NEXT FIELD b
           END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         RETURN
      END IF
      CALL cl_wait()
      CALL p110_t()
      ERROR ''
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p110_t()
   DEFINE l_sql         LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(600)
   DEFINE l_name        LIKE type_file.chr20     #NO.FUN-690009 VARCHAR(20)
   DEFINE i,l_i         LIKE type_file.num5      #NO.FUN-690009 SMALLINT
   DEFINE l_str         LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(80)
   DEFINE l_za05        LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(40)
   DEFINE l_aee04       LIKE aee_file.aee04
   DEFINE sr            RECORD
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*
                        END RECORD
 
   LET l_sql = "SELECT aba_file.*,abb_file.* ",
               "  FROM aba_file,abb_file ",
               " WHERE aba00 = abb00 AND aba01 = abb01 ",
               "   AND abaacti = 'Y' ",
               "   AND aba19 <> 'X' ",   #CHI-C80041
               "   AND ",tm.wc CLIPPED
 
   PREPARE p110_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('p110_pre1',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p110_curs1 CURSOR FOR p110_pre1
 
   LET l_name = 'UFERPM8.TXT'
   LET g_page_line = 1
   START REPORT p110_rep TO l_name
   #add 030428 NO.A063
   LET g_pageno = 1
   FOREACH p110_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p110_curs1',STATUS,1) EXIT FOREACH
      END IF
      IF tm.a = '1' AND sr.aba.aba19 = 'N' THEN CONTINUE FOREACH END IF
      IF tm.a = '2' AND sr.aba.aba19 = 'Y' THEN CONTINUE FOREACH END IF
      IF tm.b = '1' AND sr.aba.abapost = 'N' THEN CONTINUE FOREACH END IF
      IF tm.b = '2' AND sr.aba.abapost = 'Y' THEN CONTINUE FOREACH END IF
      OUTPUT TO REPORT p110_rep(sr.aba.*,sr.abb.*)
   END FOREACH
 
   FINISH REPORT p110_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT p110_rep(sr)
  DEFINE sr             RECORD
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*
                        END RECORD
  DEFINE l_abb04        LIKE abb_file.abb04
  DEFINE l_d_amt,l_c_amt LIKE abb_file.abb07
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
  FORMAT
{modify 030428 NO.A063
    PAGE HEADER
       PRINT "填制憑證,V800"
}
 
    ON EVERY ROW
       LET l_abb04 = sr.abb.abb04
       IF cl_null(sr.abb.abb04) THEN LET l_abb04 = '<BLANK>' END IF
       #modify 030428 NO.A063
       IF sr.abb.abb06 = '1' THEN
          LET l_d_amt = cl_numfor(sr.abb.abb07,18,g_azi04)
          LET l_c_amt = cl_numfor(0,15,2)
       ELSE
          LET l_d_amt = cl_numfor(0,15,2)
          LET l_c_amt = cl_numfor(sr.abb.abb07,18,g_azi04)
       END IF
       #add 030428 NO.A063
       IF g_pageno = 1 THEN
          PRINT "填制憑証,V800"
          LET g_pageno = 0
       END IF
       #modify 030428 NO.A063
       PRINT sr.aba.aba02 USING 'YYYY-MM-DD',",",
             sr.abb.abb01[1,2],",",
             sr.aba.aba01[9,12],",",
             "0",",",
             l_abb04 CLIPPED,",",
             sr.abb.abb03[1,15] CLIPPED,",",
             l_d_amt USING '-<<<<<<<<<<<<<&.&&',",",
             l_c_amt USING '-<<<<<<<<<<<<<&.&&',",",
             "0",",",
             sr.abb.abb07f USING '-<<<<<<<<<<<<<&.&&',",",
             sr.abb.abb25 USING '-<<<<<<&.&&&&',",",
             g_user CLIPPED,
             ",,,,",
             ",",
             ",,,,",
             sr.abb.abb08 CLIPPED,
             ",,,,,,,,,,,,,,,,,,1,1,1,0,0,,1,1,1,0"
 
END REPORT
#Patch....NO.TQC-610037 <001> #
#FUN-B80096
