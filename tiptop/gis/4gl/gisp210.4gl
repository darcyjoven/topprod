# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gisp210.4gl
# Descriptions...: 進項發票底稿匯出作業
# Date & Author..: 02/03/28 By Danny
 # Modify.........: No.MOD-560233 05/06/29 By day  報表檔名固定，g_page_line取法改變
# Modify.........: No.FUN-5B0070 05/11/14 By wujie 增加可從客戶端匯出資料
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_sql   	string,  #No.FUN-580092 HCN
        tm       RECORD
                wc    LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(600) 
                b     LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(1)
                e     LIKE type_file.chr1      #No.FUN-5B0070   #NO FUN-690009 VARCHAR(1)
                END RECORD
 
#No.FUN-5B0070--begin
DEFINE  g_targe   LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(100)
        g_fileloc LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(100)
        l_url     STRING
#No.FUN-5B0070--end
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0098
    DEFINE p_row,p_col     LIKE type_file.num5      #NO FUN-690009 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    OPEN WINDOW p210 AT p_row,p_col
         WITH FORM "gis/42f/gisp210"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
    CALL cl_opmsg('z')
    CALL p210()
    CLOSE WINDOW p210
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END MAIN
 
FUNCTION p210()
   WHILE TRUE
      CLEAR FORM
      CONSTRUCT BY NAME tm.wc ON ise01,ise03,ise04,ise062
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('iseuser', 'isegrup') #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      LET tm.b = 'N'
      LET tm.e = 'N'          #No.FUN-5B0070
      INPUT BY NAME tm.b,tm.e WITHOUT DEFAULTS    #No.FUN-5B0070
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
         #No.FUN-5B0070  --begin
         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
               NEXT FIELD e
            END IF
         #No.FUN-5B0070  --end
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
         LET INT_FLAG = 0 EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         RETURN
      END IF
      CALL cl_wait()
      CALL p210_t()
      ERROR ''
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p210_t()
   DEFINE l_sql         LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(600)
   DEFINE l_name        LIKE type_file.chr20    #NO FUN-690009 VARCHAR(20)
   DEFINE l_cnt         LIKE type_file.num5     #NO FUN-690009 SMALLINT
   DEFINE l_str         LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(80)
   DEFINE l_za05        LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(40)
   DEFINE sr            RECORD LIKE ise_file.*
 
   LET l_sql = "SELECT * FROM ise_file ",
               " WHERE ise07 = '0' ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY ise061,ise01 "
 
   PREPARE p210_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('p210_pre1',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p210_curs1 CURSOR FOR p210_pre1
 
 #No.MOD-560233-begin
   LET l_name = 'BUYING.txt'
   SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog
 #No.MOD-560233-end
   START REPORT p210_rep TO l_name
 
   FOREACH p210_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p210_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH 
      END IF
      LET sr.ise061 = sr.ise061 / 100
      OUTPUT TO REPORT p210_rep(sr.*)
   END FOREACH
 
   FINISH REPORT p210_rep
 
   IF tm.b = 'Y' THEN
      BEGIN WORK
      LET g_success='Y'
      LET l_sql = "UPDATE ise_file SET ise07 = '1' ",
                  " WHERE ise07 = '0' ",
                  "   AND ",tm.wc CLIPPED
      PREPARE p210_pre2 FROM l_sql
      IF STATUS THEN
         CALL cl_err('p210_pre2',STATUS,1) LET g_success='N'
      END IF
      EXECUTE p210_pre2
      IF STATUS THEN
#        CALL cl_err('execute',STATUS,1)   #No.FUN-660146
         CALL cl_err3("upd","ise_file","","",STATUS,"","execute",1)   #No.FUN-660146
         LET g_success='N'
      END IF
      IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   END IF
#No.FUN-5B0070--begin
   IF tm.e = 'Y' THEN
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",l_name CLIPPED
      IF NOT cl_open_url(l_url) THEN
         CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
      END IF
    ELSE
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   END IF
#No.FUN-5B0070--end
 
END FUNCTION
 
REPORT p210_rep(sr)
   DEFINE  sr     RECORD LIKE ise_file.*
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin
  PAGE LENGTH g_page_line      #No.FUN-560233
  FORMAT
    ON EVERY ROW
       IF sr.ise062 MATCHES '[NS]' THEN
          PRINT sr.ise062 CLIPPED,sr.ise02 CLIPPED,' ',sr.ise01 CLIPPED,' ',
                sr.ise03  USING 'YYYYMMDD',' "',sr.ise14 CLIPPED,'" ',
                sr.ise08  USING '-<<<<<<<<<<&.&&',' ',
                sr.ise061 USING '<&.&&',' ',
                sr.ise08t USING '-<<<<<<<<<<&.&&',' ',sr.ise052 CLIPPED,' ',
                sr.ise051 CLIPPED,' ',sr.ise09 USING 'YYYYMMDD',' ',
                sr.ise10  CLIPPED,' ',
                sr.ise12  USING 'YYYYMMDD',' ',
                sr.ise13  USING '-<<<<<<<<<<&.&&',' ',sr.ise11 CLIPPED
       END IF
       IF sr.ise062 MATCHES '[TAW]' THEN
          PRINT sr.ise062,' ',sr.ise01 CLIPPED,' ',
                sr.ise03  USING 'YYYYMMDD',' "',sr.ise14 CLIPPED,'" ',
                sr.ise08  USING '-<<<<<<<<<<&.&&',' ',
                sr.ise061 USING '<&.&&',' ',
                sr.ise08x USING '-<<<<<<<<<<&.&&',' ',sr.ise052 CLIPPED
       END IF
       IF sr.ise062 = 'G' THEN
          PRINT sr.ise062,' ',sr.ise01 CLIPPED,' ',
                sr.ise03  USING 'YYYYMMDD',' "',sr.ise14 CLIPPED,'" ',
                sr.ise08  USING '-<<<<<<<<<<&.&&',' ',
                sr.ise061 USING '<&.&&',' ',
                sr.ise08x USING '-<<<<<<<<<<&.&&',' ',sr.ise052 CLIPPED,' ',
                sr.ise10 CLIPPED,' ',
                sr.ise15 USING '-<<<<<<<<&.&&&',' ',sr.ise16 CLIPPED
       END IF
END REPORT
#Patch....NO.TQC-610037 <001> #
