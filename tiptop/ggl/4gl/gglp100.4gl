# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglp100.4gl
# Descriptions...: 金蝶財務軟件接口作業
# Date & Author..: 02/05/23 By Danny
# Modify.........: No.A115 04/03/16 By Danny
# Modify.........: No.TQC-5A0090 05/10/27 By Sampmin 單別單號寫死
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-730070 07/04/09 By Carrier 會計科目加帳套-財務
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_sql   	string,  #No.FUN-580092 HCN
        tm       RECORD
                wc    LIKE type_file.chr1000,   #NO.FUN-690009 VARCHAR(600)  
                a     LIKE type_file.chr1,      #NO.FUN-690009 VARCHAR(01)
                b     LIKE type_file.chr1,      #NO.FUN-690009 VARCHAR(01)
                c     LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)   #add 031225 NO.A103
                END RECORD
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0097
    DEFINE p_row,p_col     LIKE type_file.num5      #NO FUN-690009 SMALLINT
 
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
 
    OPEN WINDOW p100 AT p_row,p_col
         WITH FORM "ggl/42f/gglp100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
    CALL cl_opmsg('z')
    CALL p100()
    CLOSE WINDOW p100
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
END MAIN
 
FUNCTION p100()
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
     LET tm.c = '2'       #add 031225 NO.A103
 
     INPUT BY NAME tm.a,tm.b,tm.c WITHOUT DEFAULTS #modify 031225 NO.A103
 
        AFTER FIELD a
          IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
             NEXT FIELD a
          END IF
        AFTER FIELD b
          IF cl_null(tm.b) OR tm.b NOT MATCHES '[123]' THEN
             NEXT FIELD b
          END IF
        #add 031225 NO.A103
        AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[12]' THEN
             NEXT FIELD c
          END IF
      #end add
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
      CALL p100_t()
      ERROR ''
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p100_t()
   DEFINE l_sql         LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(600)
   DEFINE l_name        LIKE type_file.chr20     #NO.FUN-690009 VARCHAR(20)
   DEFINE l_print_cmd   LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(60)
   DEFINE i,l_i         LIKE type_file.num5      #NO.FUN-690009 SMALLINT
   DEFINE l_str         LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(80)
   DEFINE l_za05        LIKE type_file.chr1000   #NO.FUN-690009 VARCHAR(40)
   DEFINE l_aee04       LIKE aee_file.aee04
   DEFINE tmp           DYNAMIC ARRAY OF RECORD
                        fclsname    LIKE aag_file.aag15,    #NO.FUN-690009 VARCHAR(40)
                        fobjid      LIKE abb_file.abb11,    #NO.FUN-690009 VARCHAR(40)
                        fobjname    LIKE aee_file.aee04     #NO.FUN-690009 VARCHAR(40)
                        END RECORD
   DEFINE sr            RECORD
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*,
                        aag         RECORD LIKE aag_file.*,
                        gem02       LIKE gem_file.gem02
                        END RECORD
 
   LET l_sql = "SELECT aba_file.*,abb_file.*,aag_file.*,gem02 ",
               "  FROM aba_file,aag_file,abb_file LEFT OUTER JOIN gem_file ON abb_file.abb05=gem_file.gem01",
               " WHERE aba00 = abb00 AND aba01 = abb01 ",
               "   AND aag01 = abb03  ",
               "   AND aag00 = abb00 ",   #No.FUN-730070
               "   AND abaacti = 'Y' ",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND ",tm.wc CLIPPED
 
   PREPARE p100_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('p100_pre1',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p100_curs1 CURSOR FOR p100_pre1
 
   LET l_name = 'KINGDEE.TXT'
#modify 031225 NO.A103
   LET g_page_line = 1
   IF tm.c = '1' THEN
      START REPORT p100_rep1 TO l_name
   ELSE
      START REPORT p100_rep8 TO l_name
   END IF
   #end modify
 
   FOREACH p100_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p100_curs1',STATUS,1) EXIT FOREACH
      END IF
      IF tm.a = '1' AND sr.aba.aba19 = 'N' THEN CONTINUE FOREACH END IF
      IF tm.a = '2' AND sr.aba.aba19 = 'Y' THEN CONTINUE FOREACH END IF
      IF tm.b = '1' AND sr.aba.abapost = 'N' THEN CONTINUE FOREACH END IF
      IF tm.b = '2' AND sr.aba.abapost = 'Y' THEN CONTINUE FOREACH END IF
      FOR i = 1 TO 5
          INITIALIZE tmp[i].* TO NULL
      END FOR
      #核算項目按序填入, 若有空白者,要往前補入,否則金蝶系統會有問題
      #若部門資料不為空白,存入核算項目(一)
      LET l_i = 1
      IF NOT cl_null(sr.abb.abb05) THEN
         LET tmp[l_i].fclsname = '部門'
         LET tmp[l_i].fobjid   = sr.abb.abb05
         LET tmp[l_i].fobjname = sr.gem02
         LET l_i = l_i + 1
      END IF
      IF NOT cl_null(sr.abb.abb11) THEN    #異動碼一
         SELECT aee04 INTO l_aee04 FROM aee_file
          WHERE aee01 = sr.abb.abb03 AND aee02 = '1' AND aee03 = sr.abb.abb11
            AND aee00 = sr.abb.abb00  #No.FUN-730070
         IF STATUS THEN LET l_aee04 = '' END IF
         LET tmp[l_i].fclsname = sr.aag.aag15
         LET tmp[l_i].fobjid   = sr.abb.abb11
         LET tmp[l_i].fobjname = l_aee04
         LET l_i = l_i + 1
      END IF
      IF NOT cl_null(sr.abb.abb12) THEN    #異動碼二
         SELECT aee04 INTO l_aee04 FROM aee_file
          WHERE aee01 = sr.abb.abb03 AND aee02 = '2' AND aee03 = sr.abb.abb12
            AND aee00 = sr.abb.abb00  #No.FUN-730070
         IF STATUS THEN LET l_aee04 = '' END IF
         LET tmp[l_i].fclsname = sr.aag.aag16
         LET tmp[l_i].fobjid   = sr.abb.abb12
         LET tmp[l_i].fobjname = l_aee04
         LET l_i = l_i + 1
      END IF
      IF NOT cl_null(sr.abb.abb13) THEN    #異動碼三
         SELECT aee04 INTO l_aee04 FROM aee_file
          WHERE aee01 = sr.abb.abb03 AND aee02 = '3' AND aee03 = sr.abb.abb13
            AND aee00 = sr.abb.abb00  #No.FUN-730070
         IF STATUS THEN LET l_aee04 = '' END IF
         LET tmp[l_i].fclsname = sr.aag.aag17
         LET tmp[l_i].fobjid   = sr.abb.abb13
         LET tmp[l_i].fobjname = l_aee04
         LET l_i = l_i + 1
      END IF
      IF NOT cl_null(sr.abb.abb14) THEN    #異動碼四
         SELECT aee04 INTO l_aee04 FROM aee_file
          WHERE aee01 = sr.abb.abb03 AND aee02 = '4' AND aee03 = sr.abb.abb14
            AND aee00 = sr.abb.abb00  #No.FUN-730070
         IF STATUS THEN LET l_aee04 = '' END IF
         LET tmp[l_i].fclsname = sr.aag.aag18
         LET tmp[l_i].fobjid   = sr.abb.abb14
         LET tmp[l_i].fobjname = l_aee04
      END IF
      FOR i = 1 TO 5
          IF cl_null(tmp[i].fclsname) THEN LET tmp[i].fclsname = "''" END IF
          IF cl_null(tmp[i].fobjid)   THEN LET tmp[i].fobjid   = "''" END IF
          IF cl_null(tmp[i].fobjname) THEN LET tmp[i].fobjname = "''" END IF
      END FOR
      #modify 031225 NO.A103
      IF tm.c = '1' THEN
         OUTPUT TO REPORT p100_rep1(sr.aba.*,sr.abb.*,
                                tmp[1].fclsname,tmp[1].fobjid,tmp[1].fobjname,
                                tmp[2].fclsname,tmp[2].fobjid,tmp[2].fobjname,
                                tmp[3].fclsname,tmp[3].fobjid,tmp[3].fobjname,
                                tmp[4].fclsname,tmp[4].fobjid,tmp[4].fobjname,
                                tmp[5].fclsname,tmp[5].fobjid,tmp[5].fobjname)
      ELSE
         OUTPUT TO REPORT p100_rep8(sr.aba.*,sr.abb.*,
                                tmp[1].fclsname,tmp[1].fobjid,tmp[1].fobjname,
                                tmp[2].fclsname,tmp[2].fobjid,tmp[2].fobjname,
                                tmp[3].fclsname,tmp[3].fobjid,tmp[3].fobjname,
                                tmp[4].fclsname,tmp[4].fobjid,tmp[4].fobjname,
                                tmp[5].fclsname,tmp[5].fobjid,tmp[5].fobjname)
      END IF
      #end modify
   END FOREACH
 
  #modify 031225 NO.A103
   IF tm.c = '1' THEN
      FINISH REPORT p100_rep1
   ELSE
      FINISH REPORT p100_rep8
   END IF
   #end modify
 
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
##############
   LET l_print_cmd = 'txt2dbf.sh ',l_name CLIPPED
   RUN l_print_cmd
##############
 
END FUNCTION
 
#add 031225 NO.A103
#No.A115
REPORT p100_rep1(sr)
   DEFINE sr            RECORD
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*,
                        fclsname1   LIKE aag_file.aag15, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjid1     LIKE abb_file.abb11, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjname1   LIKE aee_file.aee04, #TQC-5A0134  #NO.FUN-690009 VARCHAR(40)
                        fclsname2   LIKE aag_file.aag15, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjid2     LIKE abb_file.abb11, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjname2   LIKE aee_file.aee04, #TQC-5A0134  #NO.FUN-690009 VARCHAR(40)
                        fclsname3   LIKE aag_file.aag15, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjid3     LIKE abb_file.abb11, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjname3   LIKE aee_file.aee04, #TQC-5A0134  #NO.FUN-690009 VARCHAR(40)
                        fclsname4   LIKE aag_file.aag15, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjid4     LIKE abb_file.abb11, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjname4   LIKE aee_file.aee04, #TQC-5A0134  #NO.FUN-690009 VARCHAR(40)
                        fclsname5   LIKE aag_file.aag15, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjid5     LIKE abb_file.abb11, #TQC-5A0134  #NO.FUN-690009 VARCHAR(20)
                        fobjname5   LIKE aee_file.aee04  #TQC-5A0134  #NO.FUN-690009 VARCHAR(40)
                        END RECORD
  DEFINE l_abb04        LIKE abb_file.abb04
  DEFINE l_seq          LIKE abb_file.abb02
  DEFINE l_dc           LIKE type_file.chr1      #TQC-5A0134  #NO.FUN-690009 VARCHAR(1)
  DEFINE l_d_amt,l_c_amt LIKE abb_file.abb07
  DEFINE l_aba01        LIKE type_file.num5      #NO.FUN-690009 SMALLINT
  DEFINE l_aag06        LIKE aag_file.aag06
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
  FORMAT
 
    FIRST PAGE  HEADER	
#              1     2       3      4    5        6    7       8
#              9       10        11        12      13        14
#              15      16        17        18      19        20
#              21    22        23  24      25   26     27     28
#              29         30        31       32   33    34      35
#              36         37      38      39       40
       PRINT "|FDATE|FPERIOD|FGROUP|FNUM|FENTRYID|FEXP|FACCTID|FCLSNAME1",
             "|FOBJID1|FOBJNAME1|FCLSNAME2|FOBJID2|FOBJNAME2|FCLSNAME3",
             "|FOBJID3|FOBJNAME3|FCLSNAME4|FOBJID4|FOBJNAME4|FTRANSID",
             "|FCYID|FEXCHRATE|FDC|FFCYAMT|FQTY|FPRICE|FDEBIT|FCREDIT",
             "|FSETTLCODE|FSETTLENO|FPREPARE|FPAY|FCASH|FPOSTER|FCHECKER",
             "|FATTCHMENT|FPOSTED|FMODULE|FDELETED|FSERIALNO|"
       PRINT "|D|N|C|N|N|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|N|C|N|N|N|N|N|C",
             "|C|C|C|C|C|C|N|L|C|L|N|"
       PRINT "|8|4|4|4|4|60|15|20|20|40|20|20|40|20|20|40|20|20|40|20|3|",
             "19,10|1|14,2|8,2|10,7|14,2|14,2|8|8|20|8|8|20|20|5|1|4|1|10|"
       PRINT " "
 
    BEFORE GROUP OF sr.aba.aba01
       LET l_seq = 0
 
    ON EVERY ROW
       LET l_abb04 = sr.abb.abb04
       IF l_seq = 0 AND cl_null(sr.abb.abb04) THEN
          LET l_abb04 = '<BLANK>'
       END IF
       CASE
          WHEN sr.abb.abb06='1' LET l_dc='D'
          WHEN sr.abb.abb06='2' LET l_dc='C'
          OTHERWISE        LET l_dc=' '
       END CASE
       IF sr.abb.abb06 = '1' THEN
          LET l_d_amt = sr.abb.abb07
          LET l_c_amt = 0
       ELSE
          LET l_d_amt = 0
          LET l_c_amt = sr.abb.abb07
       END IF
       LET l_aba01 = 0
       LET l_aba01 = sr.aba.aba01[9,12]
       IF cl_null(sr.aba.abauser) THEN LET sr.aba.abauser = ' ' END IF
       IF cl_null(sr.aba.aba21) THEN LET sr.aba.aba21 = ' ' END IF
       PRINT '|',
             sr.aba.aba02 USING 'YYYYMMDD','|',sr.aba.aba04 USING '#&','|',
#             sr.aba.aba01[1,3],'|',l_aba01 USING '###&','|',   #TQC-5A0090
             sr.aba.aba01[1,g_doc_len],'|',l_aba01 USING '###&','|',   #TQC-5A0090
             l_seq USING '##&','|',l_abb04,'|',sr.abb.abb03,'|',
             sr.fclsname1,'|',sr.fobjid1,'|',sr.fobjname1,'|',   #核算項目一
             sr.fclsname2,'|',sr.fobjid2,'|',sr.fobjname2,'|',   #核算項目二
             sr.fclsname3,'|',sr.fobjid3,'|',sr.fobjname3,'|',   #核算項目三
             sr.fclsname4,'|',sr.fobjid4,'|',sr.fobjname4,'|',   #核算項目四
             ' |',
             sr.abb.abb24,'|',sr.abb.abb25 USING '#######&.&&&&&&&&&&','|',
             l_dc,'|',sr.abb.abb07f USING '##########&.&&','|','    0.00|',
             ' 0.0000000|',l_d_amt USING '##########&.&&','|',
             l_c_amt USING '##########&.&&','|',
             #結算方式-附件張數不填值
             ' |',' |',sr.aba.abauser,'|',' |',' |',' |',' |',sr.aba.aba21,'|',
             'F|','  | ','F|','  |'
       LET l_seq = l_seq + 1
END REPORT
#end No.A115
 
REPORT p100_rep8(sr) #modify 031225 NO.A103
   DEFINE sr            RECORD
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*,
                        fclsname1   LIKE aag_file.aag15,    #NO.FUN-690009 VARCHAR(40)
                        fobjid1     LIKE abb_file.abb11,    #NO.FUN-690009 VARCHAR(40)
                        fobjname1   LIKE aee_file.aee04,    #NO.FUN-690009 VARCHAR(40) 
                        fclsname2   LIKE aag_file.aag15,    #NO.FUN-690009 VARCHAR(40)
                        fobjid2     LIKE abb_file.abb11,    #NO.FUN-690009 VARCHAR(40)
                        fobjname2   LIKE aee_file.aee04,    #NO.FUN-690009 VARCHAR(40)
                        fclsname3   LIKE aag_file.aag15,    #NO.FUN-690009 VARCHAR(40)
                        fobjid3     LIKE abb_file.abb11,    #NO.FUN-690009 VARCHAR(40)
                        fobjname3   LIKE aee_file.aee04,    #NO.FUN-690009 VARCHAR(40)
                        fclsname4   LIKE aag_file.aag15,    #NO.FUN-690009 VARCHAR(40)
                        fobjid4     LIKE abb_file.abb11,    #NO.FUN-690009 VARCHAR(40)
                        fobjname4   LIKE aee_file.aee04,    #NO.FUN-690009 VARCHAR(40)
                        fclsname5   LIKE aag_file.aag15,    #NO.FUN-690009 VARCHAR(40)
                        fobjid5     LIKE abb_file.abb11,    #NO.FUN-690009 VARCHAR(40)
                        fobjname5   LIKE aee_file.aee04     #NO.FUN-690009 VARCHAR(40)
                        END RECORD
  DEFINE l_abb04        LIKE abb_file.abb04
  DEFINE l_seq          LIKE abb_file.abb02
  DEFINE l_dc           LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
  DEFINE l_d_amt,l_c_amt LIKE abb_file.abb07
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
  FORMAT
{--#No:7794  少設BOTTOM MARGIN g_bottom_margin
    FIRST PAGE  HEADER	
       PRINT "|FDATE|FPERIOD|FGROUP|FNUM|FENTRYID|FEXP|FACCTID|FCLSNAME1|FOBJID1|FOBJNAME1|FCLSNAME2|FOBJID2|FOBJNAME2|FCLSNAME3|FOBJID3|FOBJNAME3|FCLSNAME4|FOBJID4|FOBJNAME4|FCLSNAME5|FOBJID5|FOBJNAME5|FCLSNAME6|FOBJID6|FOBJNAME6|FCLSNAME7|FOBJID7|FOBJNAME7|FCLSNAME8|FOBJID8|FOBJNAME8|FTRANSID|FCYID|FEXCHRATE|FDC|FFCYAMT|FQTY|FPRICE|FDEBIT|FCREDIT|FSETTLCODE|FSETTLENO|FPREPARE|FPAY|FCASH|FPOSTER|FCHECKER|FATTCHMENT|FPOSTED|FMODULE|FDELETED|FSERIALNO|"
       PRINT "|D|N|C|N|N|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|C|N|C|N|N|N|N|N|C|C|C|C|C|C|C|N|L|C|L|N|"
       PRINT "|8|20.5|10|20.5|20.5|80|40|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|80|10|20.5|1|20.5|20.5|20.5|20.5|20.5|80|80|80|80|80|80|80|20.5|1|10|1|20.5|"
       PRINT " "
----}
 
    BEFORE GROUP OF sr.aba.aba01
       LET l_seq = 0
 
    ON EVERY ROW
       LET l_abb04 = sr.abb.abb04
       IF l_seq = 0 AND cl_null(sr.abb.abb04) THEN LET l_abb04 = '<BLANK>' END IF
       LET l_dc = sr.abb.abb06
       IF sr.abb.abb06 = '2' THEN LET l_dc = '0' END IF
       IF l_dc = '1' THEN
          LET l_d_amt = sr.abb.abb07
          LET l_c_amt = 0
       ELSE
          LET l_d_amt = 0
          LET l_c_amt = sr.abb.abb07
       END IF
       PRINT "|",
             sr.aba.aba02 USING 'YYYYMMDD','|',sr.aba.aba04 USING '#&','|',
#             sr.aba.aba01[1,3],'|',sr.aba.aba01[5,12],'|',   #TQC-5A0090
             sr.aba.aba01[1,g_doc_len],'|',sr.aba.aba01[g_no_sp,g_no_ep],'|',   #TQC-5A0090
             l_seq USING '##&','|',l_abb04,'|',sr.abb.abb03,'|',
             sr.fclsname1,'|',sr.fobjid1,'|',sr.fobjname1,'|',   #核算項目一
             sr.fclsname2,'|',sr.fobjid2,'|',sr.fobjname2,'|',   #核算項目二
             sr.fclsname3,'|',sr.fobjid3,'|',sr.fobjname3,'|',   #核算項目三
             sr.fclsname4,'|',sr.fobjid4,'|',sr.fobjname4,'|',   #核算項目四
             sr.fclsname5,'|',sr.fobjid5,'|',sr.fobjname5,'|',   #核算項目五
             #核算項目六,七,八不填值
             "''|","''|","''|", "''|","''|","''|","''|","''|","''|","''|",
             sr.abb.abb24,'|',sr.abb.abb25 USING '####&.&&&&&','|',
             l_dc,'|',sr.abb.abb07f USING '###########&.&&&&&','|','0| 0|',
             l_d_amt USING '###########&.&&&&&','|',
             l_c_amt USING '###########&.&&&&&','|',
             #結算方式-附件張數不填值
             "''|","''|","''|","''|","''|","''|","''|","''|",'F|'," ''| ",'F|',
             " ''|"
       LET l_seq = l_seq + 1
END REPORT
#Patch....NO.TQC-610037 <001> #
