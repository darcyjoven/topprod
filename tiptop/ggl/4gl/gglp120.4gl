# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: gglp120.4gl
# Descriptions...: 會計核算軟體數據接口-上海市
# Date & Author..: 2003/04/22 BY LEAGH
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-550028 05/05/28 By wujie  單據編號加大
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-730070 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0082 09/11/17 By liuxqa standard sql
# Modify.........: No.FUN-A50016 10/05/06 by rainy cl_get_column_info傳入參數修改
# Modify.........: No.FUN-A70145 10/07/30 By alex 調整ASE SQL
# Modify.........: No.TQC-AC0072 10/12/07 By Carrier zq_file改成gaq_file
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD
              a       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              b       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              c       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              d       LIKE type_file.dat,          #NO.FUN-690009 DATE
              e       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              f       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              g       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              h       LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
              i       LIKE type_file.dat,          #NO.FUN-690009 DATE
              bookno  LIKE aaa_file.aaa01          #No.FUN-730070
              END RECORD,
          ddate,vdate LIKE type_file.dat,          #NO.FUN-690009 DATE
          g_msg       LIKE type_file.chr1000,      #NO.FUN-690009 VARCHAR(100)
          g_bookno    LIKE aaa_file.aaa01,         #No.FUN-6.0039 
          g_company2  LIKE zo_file.zo02,           #NO.FUN-690009 VARCHAR(72)   #MOD-730146 modify
          col DYNAMIC ARRAY OF RECORD
                           colname   LIKE  type_file.chr1000 ,
                           coltype   LIKE  type_file.chr20   ,
                           coltype2  LIKE  zaa_file.zaa08,          #NO.FUN-690009 VARCHAR(10)
                           collength LIKE  type_file.chr4,      #NO.FUN-690009 VARCHAR(4)
                           gaq03     LIKE  gaq_file.gaq03
                           END RECORD
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5          #NO.FUN-690009 SMALLINT  #count/index for any purpose
DEFINE   g_zero          LIKE type_file.num5          #NO.FUN-690009 SMALLINT  #modify 031225 NO.A104
DEFINE   g_db_type       LIKE type_file.chr3       
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_user,1) RETURNING g_time

   LET g_db_type=cl_db_get_database_type()   #FUN-9B0082 mod
 
   LET g_zero=0         #add 031225 NO.A104
   CALL acc_tm()

   CALL cl_used(g_prog,g_user,2) RETURNING g_time
END MAIN
 
FUNCTION acc_tm()
   DEFINE   l_sw          LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
            l_chr         LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
            l_cnt         LIKE type_file.num5
 
   OPEN WINDOW acc_w WITH FORM "ggl/42f/gglp120"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL            # Default condition

    SELECT aaa04 INTO tm.g FROM aaa_file WHERE aaa01 = g_aza.aza81
   #SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   #IF SQLCA.sqlcode THEN
   #   LET g_aaa03 = g_aza.aza17
   #END IF
   #No.FUN-730070  --End  
   LET tm.a = "SHCZ.TXT"
   LET tm.c = "V6.00"
   LET tm.d = g_today
   LET tm.e = "ACCOUNT.TXT"
   LET tm.f = "BALANCE.TXT"
   LET tm.h = "VOUCHER.TXT"
   LET tm.i = g_today
   LET tm.bookno = g_aza.aza81  #No.FUN-730070
 
   WHILE TRUE
      LET l_sw = 1
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h,tm.i,tm.bookno  #No.FUN-730070
                    WITHOUT DEFAULTS
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         AFTER FIELD a
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD d
            IF cl_null(tm.d) THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD e
            IF cl_null(tm.e) THEN
               NEXT FIELD e
            END IF
 
         AFTER FIELD f
            IF cl_null(tm.f) THEN
               NEXT FIELD f
            END IF
 
         AFTER FIELD g
            IF cl_null(tm.g) THEN
               NEXT FIELD g
            END IF
 
         AFTER FIELD h
            IF cl_null(tm.h) THEN
               NEXT FIELD h
            END IF
 
        #No.FUN-730070  --Begin
        AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL p120_bookno('a',tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               END IF
            END IF
        #No.FUN-730070  --End  
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
       #No.FUN-7300070  --Begin
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(bookno) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = tm.bookno
                CALL cl_create_qry() RETURNING tm.bookno
                DISPLAY BY NAME tm.bookno
                CALL p120_bookno('d',tm.bookno)
          END CASE

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW acc_w
         CALL cl_used(g_prog,g_user,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL acc_shcz()
      ERROR ""
   END WHILE
   CLOSE WINDOW acc_w
END FUNCTION
 
#No.FUN-730070  --Begin
FUNCTION p120_bookno(p_cmd,p_bookno)
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
 
FUNCTION acc_shcz()
     DEFINE l_name    LIKE type_file.chr20         #NO FUN-690009 VARCHAR(60)
#     DEFINE     l_time LIKE type_file.chr8        #No.FUN-6A0097
     DEFINE l_za05    LIKE type_file.chr1000       #NO FUN-690009 VARCHAR(40) 
     DEFINE l_cnt     LIKE type_file.num5          #NO FUN-690009 SMALLINT
     DEFINE l_tablename    LIKE type_file.chr20    #NO-FUN-9B0082 mod 
     DEFINE l_sql     LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(1000)
            l_msg     LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(100)
            l_aag01   LIKE aag_file.aag01,         #NO FUN-690009 VARCHAR(24)    
            l_aag02   LIKE aag_file.aag02,         #NO FUN-690009 VARCHAR(30) 
            l_aag08   LIKE aag_file.aag08,         #NO FUN-690009 VARCHAR(24) 
            l_aag24   LIKE aag_file.aag24,         #NO FUN-690009 VARCHAR(01)
            l_pre01   LIKE aag_file.aag01,       #NO FUN-690009 VARCHAR(24)
            l_pre02   LIKE aag_file.aag02,       #NO FUN-690009 VARCHAR(30)
            l_pre08   LIKE aag_file.aag08,       #NO FUN-690009 VARCHAR(24)
            l_pre24   LIKE aag_file.aag24        #NO FUN-690009 VARCHAR(01)
     DEFINE sr        RECORD
                      aag24 LIKE aag_file.aag24,
                      del   LIKE cre_file.cre08    #NO FUN-690009 VARCHAR(10)
                      END RECORD
     DEFINE sr1       RECORD
                      aag01 LIKE aag_file.aag01,
                      aag02 LIKE aag_file.aag02,
                      aag06 LIKE aag_file.aag06,
                      aag08 LIKE aag_file.aag08,
                      aag24 LIKE aag_file.aag24
                      END RECORD
     DEFINE sr2       RECORD
                      aag01 LIKE aag_file.aag01,
                      aah01 LIKE aah_file.aah01,
                      balance LIKE aah_file.aah04  #No.FUN-4C0009    #NO FUN-690009 DEC(20,6)
                      END RECORD
     DEFINE sr3       RECORD
                      aba01  LIKE aba_file.aba01,
                      aba02  LIKE aba_file.aba02,
                      aba08  LIKE aba_file.aba08,
                      aba09  LIKE aba_file.aba09,
                      aba10  LIKE aba_file.aba10,
                      abb03  LIKE abb_file.abb03,
                      abb06  LIKE abb_file.abb06,
                      abb07  LIKE abb_file.abb07,
                      abb07b LIKE abb_file.abb07f,   #No.FUN-4C0009    #NO FUN-690009 DEC(20,6)
                      aac01  LIKE aac_file.aac01,
                      aac03  LIKE aac_file.aac03,
                      aac03b LIKE zaa_file.zaa08,   #NO FUN-690009 VARCHAR(10)
                      abb01  LIKE abb_file.abb01,
                      abb02  LIKE abb_file.abb02,
                      abb04  LIKE abb_file.abb04,   #add 031225 NO.A104
                      vocher LIKE aba_file.aba01  #NO FUN-690009 VARCHAR(30)
                      END RECORD
     DEFINE   l_azw05    LIKE  azw_file.azw05   #FUN-A50016

 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     SELECT aaf03 INTO g_company FROM aaf_file
#     WHERE aaf01 = g_bookno AND aaf02 = g_lang  #No.FUN-730070
      WHERE aaf01 = g_aza.aza81 AND aaf02 = g_lang  #No.FUN-730070
     SELECT zo02 INTO g_company2 FROM zo_file WHERE zo01 = g_lang     #MOD-730146 modify
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglp120'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 0 END IF
 
     MESSAGE g_x[26] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
     LET l_name = tm.a
     FOR l_cnt = 1 TO 30
         INITIALIZE col[l_cnt].* TO NULL
     END FOR
#FUN-9B0082 mod --begin
     #No.TQC-AC0072  --Begin
     CASE g_db_type
     WHEN "ORA"
     #LET l_sql=" SELECT lower(column_name),data_type,'',to_char(decode(data_precision,null, data_length, data_precision),'999.99'),zq04",
   # LET l_sql=" SELECT lower(column_name),'','','',zq04",
     LET l_sql=" SELECT lower(column_name),'','','',gaq03",
             # " FROM user_tab_columns, zq_file ",
               " FROM user_tab_columns, gaq_file ",
               " WHERE (lower(column_name) = 'aag01' OR lower(column_name) = 'aag02' ",
               "   OR lower(column_name) = 'aag06' OR lower(column_name) = 'aac03' ",
               "   OR lower(column_name) = 'aba01' OR lower(column_name) = 'aba02' ",
               "   OR lower(column_name) = 'aba08' OR lower(column_name) = 'aba09')",      
             # "   AND lower(column_name) = zq_file.zq01 AND zq_file.zq03 = '0' "
               "   AND lower(column_name) = gaq_file.gaq01 AND gaq_file.gaq02 = '0' "
     WHEN "IFX"
     #LET l_sql=" SELECT b.colname,b.coltype,'',b.colength,zq04 ",
   # LET l_sql=" SELECT b.colname,'','','',zq04 ",
     LET l_sql=" SELECT b.colname,'','','',gaq03 ",
             # "  FROM systables a,syscolumns b,zq_file ",
               "  FROM systables a,syscolumns b,gaq_file ",
               "WHERE a.tabid = b.tabid",
               "AND (b.colname = 'aag01' OR b.colname = 'aag02' ",
               "   OR b.colname = 'aag06' OR b.colname = 'aac03' ",
               "   OR b.colname = 'aba01' OR b.colname  = 'aba02' ",
               "   OR b.colname = 'aba08' OR b.colname = 'aba09')",
             # "   AND b.colname= zq_file.zq01 AND zq_file.zq03 = '0' "
               "   AND b.colname= gaq_file.gaq01 AND gaq_file.gaq02 = '0' "
     WHEN "MSV"
   # LET l_sql="SELECT a.name, '','','',zq04 ",
     LET l_sql="SELECT a.name, '','','',gaq03 ",
             # "  FROM sys.all_columns a,sys.types b,zq_file ",
               "  FROM sys.all_columns a,sys.types b,gaq_file ",
               "  WHERE a.system_type_id = b.user_type_id ",
               "    AND (a.name = 'aag01' OR a.name = 'aag02' ",
               "   OR a.name = 'aag06' OR a.name = 'aac03' ",
               "   OR a.name = 'aba01' OR a.name  = 'aba02' ",
               "   OR a.name = 'aba08' OR a.name = 'aba09')",
             # "   AND a.name= zq_file.zq01 AND zq_file.zq03 = '0' "
               "   AND a.name= gaq_file.gaq01 AND gaq_file.gaq02 = '0' "
     WHEN "ASE"                                #FUN-A70145
   # LET l_sql="SELECT a.name, '','','',zq04 ",
     LET l_sql="SELECT a.name, '','','',gaq03 ",
             # "  FROM sys.all_columns a,sys.types b,zq_file ",
               "  FROM sys.all_columns a,sys.types b,gaq_file ",
               "  WHERE a.system_type_id = b.user_type_id ",
               "    AND (a.name = 'aag01' OR a.name = 'aag02' ",
               "   OR a.name = 'aag06' OR a.name = 'aac03' ",
               "   OR a.name = 'aba01' OR a.name  = 'aba02' ",
               "   OR a.name = 'aba08' OR a.name = 'aba09')",
             # "   AND a.name= zq_file.zq01 AND zq_file.zq03 = '0' "
               "   AND a.name= gaq_file.gaq01 AND gaq_file.gaq02 = '0' "
     END CASE
     #No.TQC-AC0072  --End  
#FUN-9B0082 mod --end

     PREPARE p_zt_pp FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_user,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE p_zt_cs CURSOR FOR p_zt_pp
     LET l_cnt = 1
     FOREACH p_zt_cs INTO col[l_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_tablename = ''                                   #FUN-9B0082 mod
       CALL cl_get_table_name(col[l_cnt].colname) RETURNING l_tablename    #FUN-9B0082 mod
#FUN-A50016 begin
       CALL s_get_azw05(g_plant) RETURNING l_azw05
       #CALL cl_get_column_info(g_dbs,l_tablename,col[l_cnt].colname) RETURNING col[l_cnt].coltype,col[l_cnt].collength  #FUN-9B0082 Mod
       CALL cl_get_column_info(l_azw05,l_tablename,col[l_cnt].colname) RETURNING col[l_cnt].coltype,col[l_cnt].collength  #FUN-9B0082 Mod
#FUN-A50016 end
       CASE WHEN col[l_cnt].coltype = 0 LET col[l_cnt].coltype2 = g_x[31]
            WHEN col[l_cnt].coltype = 1 LET col[l_cnt].coltype2 = g_x[32]
            WHEN col[l_cnt].coltype = 2 LET col[l_cnt].coltype2 = g_x[32]
            WHEN col[l_cnt].coltype = 5 LET col[l_cnt].coltype2 = g_x[32]
            WHEN col[l_cnt].coltype = 7 LET col[l_cnt].coltype2 = g_x[33]
            WHEN col[l_cnt].coltype = 256 LET col[l_cnt].coltype2 = g_x[31]
            WHEN col[l_cnt].coltype = 257 LET col[l_cnt].coltype2 = g_x[32]
            WHEN col[l_cnt].coltype = 258 LET col[l_cnt].coltype2 = g_x[32]
            WHEN col[l_cnt].coltype = 261 LET col[l_cnt].coltype2 = g_x[32]
            WHEN col[l_cnt].coltype = 262 LET col[l_cnt].coltype2 = g_x[32]
            OTHERWISE LET col[l_cnt].coltype2 = col[l_cnt].coltype
       END CASE
       IF col[l_cnt].collength = '3843' THEN
          LET col[l_cnt].collength = '15,3'
       END IF
       LET l_cnt = l_cnt + 1
     END FOREACH
     START REPORT acc_rep TO l_name
       SELECT MAX(aag24) INTO sr.aag24 FROM aag_file
        WHERE aag00 = tm.bookno    #No.FUN-730070
       OUTPUT TO REPORT acc_rep(sr.*)
     FINISH REPORT acc_rep
     MESSAGE g_x[30] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
 
     MESSAGE g_x[27] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
     #modify 031225 NO.A104
     LET l_sql = "SELECT aag01, aag02, aag06, aag08, aag24 FROM aag_file ",
                 " WHERE aag09 = 'Y' AND aagacti = 'Y'",
                 "   AND aag00 = '",tm.bookno,"'",   #No.FUN-730070
                 " ORDER BY aag01 "
     #end modify
     PREPARE acc_prepare1 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare1:',STATUS,1)
        CALL cl_used(g_prog,g_user,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE acc_curs1 CURSOR FOR acc_prepare1
     LET l_name = tm.e
     START REPORT acc_rep_account TO l_name
     FOREACH acc_curs1 INTO sr1.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       LET l_aag01 = sr1.aag01
       LET l_aag24 = sr1.aag24
       LET l_pre08 = sr1.aag08
       LET l_pre01 = " "
       LET l_pre02 = " "
       LET l_pre24 = " "
       WHILE l_aag01 != l_pre08
             SELECT aag01,aag02,aag08,aag24
               INTO l_aag01,l_aag02,l_aag08,l_aag24  FROM aag_file
              WHERE aag01 = l_pre08 AND aagacti = 'Y'
                AND aag00 = tm.bookno     #No.FUN-730070
             LET sr1.aag02 = l_aag02 CLIPPED,'-',sr1.aag02 CLIPPED
             LET l_pre01 = l_aag01
             LET l_pre02 = l_aag02
             LET l_pre08 = l_aag08
             LET l_pre24 = l_aag24
       END WHILE
       OUTPUT TO REPORT acc_rep_account(sr1.*)
     END FOREACH
     FINISH REPORT acc_rep_account
     MESSAGE g_x[30] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
 
     MESSAGE g_x[28] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
     #modify 031225 NO.A104
     LET l_sql = "SELECT aag01, '', 0 FROM aag_file ",
                 " WHERE aag09 = 'Y' AND aagacti = 'Y'",
                 "   AND aag00 = '",tm.bookno,"'",   #No.FUN-730070
                 " ORDER BY aag01 "
     #end modify
     PREPARE acc_prepare2 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare2:',STATUS,1)
        CALL cl_used(g_prog,g_user,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE acc_curs2 CURSOR FOR acc_prepare2
     LET l_name = tm.f
     START REPORT acc_rep_balance TO l_name
     FOREACH acc_curs2 INTO sr2.*
       IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) EXIT FOREACH END IF
       #modify 031225 NO.A104
       SELECT aah01,aah04-aah05 INTO sr2.aah01,sr2.balance
         FROM aah_file
#       WHERE aah00 = g_bookno AND aah01 = sr2.aag01     #No.FUN-730070
        WHERE aah00 = tm.bookno AND aah01 = sr2.aag01  #No.FUN-730070
          AND aah02 = tm.g     AND aah03 = 0
        ORDER BY aah01
       #end modify
       IF sr2.balance IS NULL THEN LET sr2.balance = 0 END IF
       OUTPUT TO REPORT acc_rep_balance(sr2.*)
     END FOREACH
     FINISH REPORT acc_rep_balance
     MESSAGE g_x[30] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
 
     MESSAGE g_x[29] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
     LET l_sql = "SELECT aba01, aba02, aba08, aba09, aba10, abb03, abb06,",
                 #add 031225 NO.A104
                 "       abb07, abb07, aac01, aac03,'',abb01,abb02,abb04,''",
                 #end modify
                 "  FROM aac_file, aba_file ,abb_file ",
                 " WHERE aba00 = abb00 AND aba01 = abb01 ",
#                "   AND aba01[1,3] = aac01 ",
                 "   AND aba01 like trim(aac01) ||'-%' ",              #No.FUN-550028
                 "   AND aba00 = '",tm.bookno,"'",           #No.FUN-730070
                 "   AND abapost = 'Y' AND aba19   = 'Y' " ,
                 "   AND abaacti = 'Y' AND aacacti = 'Y' "
     IF tm.i IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND aba02 = '",tm.i,"'"
     END IF
     LET l_sql = l_sql CLIPPED, " ORDER BY aba02, aac03, aba01 "
     PREPARE acc_prepare3 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare3:',STATUS,1)
        CALL cl_used(g_prog,g_user,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE acc_curs3 CURSOR FOR acc_prepare3
     LET l_name = tm.h
     START REPORT acc_rep_vocher TO l_name
     FOREACH acc_curs3 INTO sr3.*
       IF STATUS THEN CALL cl_err('foreach3:',STATUS,1) EXIT FOREACH END IF
       IF sr3.aac03 = '0' THEN
          IF sr3.abb06 = '1' THEN
             LET sr3.abb07b = 0
          ELSE
             LET sr3.abb07 = 0
          END IF
          LET sr3.aac03b = g_x[23] CLIPPED
          LET sr3.vocher = sr3.aba01
       END IF
       IF sr3.aac03 = '1' THEN
          IF sr3.abb06 = '2' THEN LET sr3.abb07 = 0 END IF
          LET sr3.aac03b = g_x[24] CLIPPED
          LET sr3.vocher = sr3.aba01
       END IF
       IF sr3.aac03 = '2' THEN
          IF sr3.abb06 = '1' THEN LET sr3.abb07b = 0 END IF
          LET sr3.aac03b = g_x[25] CLIPPED
          LET sr3.vocher = sr3.aba01
       END IF
       OUTPUT TO REPORT acc_rep_vocher(sr3.*)
     END FOREACH
     FINISH REPORT acc_rep_vocher
     MESSAGE g_x[30] CLIPPED
     CALL ui.Interface.refresh()
     SLEEP 1
 
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
END FUNCTION
 
REPORT acc_rep(sr)
   DEFINE sr       RECORD
                   aag24 LIKE aag_file.aag24,
                   del   LIKE cre_file.cre08    #NO FUN-690009 VARCHAR(10)
                   END RECORD,
          l_cnt    LIKE type_file.num5,         #NO FUN-690009 SMALLINT
          l_msg    LIKE type_file.chr1000       #NO FUN-690009 VARCHAR(100)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  FORMAT
   #modify 031225 NO.A104
   PAGE HEADER
      PRINT "[",g_x[1] CLIPPED,"]"                #// 帳套
      MESSAGE "[",g_x[1] CLIPPED,"]"
      CALL ui.Interface.refresh()
 
      PRINT g_x[1] CLIPPED,"=1\,1"
      MESSAGE g_x[1] CLIPPED,"=1\,1"
      CALL ui.Interface.refresh()
      PRINT g_x[2] CLIPPED,"=",g_company CLIPPED
      MESSAGE g_x[2] CLIPPED,"=",g_company CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[3] CLIPPED,"=",g_company2 CLIPPED
      MESSAGE g_x[3] CLIPPED,"=",g_company2 CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[4] CLIPPED,"=",tm.g CLIPPED
      MESSAGE g_x[4] CLIPPED,"=",tm.g CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[5] CLIPPED
      MESSAGE g_x[5] CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[6] CLIPPED,"=",tm.b CLIPPED
      MESSAGE g_x[6] CLIPPED,"=",tm.b CLIPPED
      CALL ui.Interface.refresh()
      PRINT "[",g_x[7] CLIPPED,"]"              #//帳務
      MESSAGE "[",g_x[7] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[8] CLIPPED
      MESSAGE g_x[8] CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[9] CLIPPED,"=",tm.c CLIPPED
      MESSAGE g_x[9] CLIPPED,"=",tm.c CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[10] CLIPPED,"=",tm.d USING "YYYYMMDD"
      MESSAGE g_x[10] CLIPPED,"=",tm.d USING "YYYYMMDD"
      CALL ui.Interface.refresh()
      PRINT "[",g_x[11] CLIPPED,"]"             #// 科目
      MESSAGE "[",g_x[11] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[12] CLIPPED,"=",tm.e CLIPPED
      MESSAGE g_x[12] CLIPPED,"=",tm.e CLIPPED
      CALL ui.Interface.refresh()
      PRINT g_x[13] CLIPPED,"=",'4\,5'
      MESSAGE g_x[13] CLIPPED,"=",'4\,5'
      CALL ui.Interface.refresh()
      PRINT g_x[14] CLIPPED,"="
      MESSAGE g_x[14] CLIPPED,"="
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aag01' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aag02' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aag06' THEN
             LET col[l_cnt].gaq03=g_x[34] CLIPPED
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      PRINT "[",g_x[16] CLIPPED,"]"
      CALL ui.Interface.refresh()
      MESSAGE "[",g_x[16] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[12] CLIPPED,"=",tm.f CLIPPED
      MESSAGE g_x[12] CLIPPED,"=",tm.f CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aag01' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aba08' THEN
             LET col[l_cnt].gaq03=g_x[35] CLIPPED
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      PRINT "[",g_x[17] CLIPPED,"]"
      MESSAGE "[",g_x[17] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[12] CLIPPED,"=",tm.h CLIPPED
      MESSAGE g_x[12] CLIPPED,"=",tm.h CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aag01' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aba02' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aba08' THEN
             LET col[l_cnt].gaq03=g_x[37] CLIPPED
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aba09' THEN
             LET col[l_cnt].gaq03=g_x[38] CLIPPED
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aac03' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         #col[l_cnt].coltype2 CLIPPED,'(',
                         # col[l_cnt].collength CLIPPED,')'
                         col[l_cnt].coltype2 CLIPPED,'(4)'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='aba01' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      #// 摘要
      FOR l_cnt=1 TO 10
          IF col[l_cnt].colname='abc04' THEN
             LET l_msg=g_x[15] CLIPPED,"=",col[l_cnt].gaq03 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED
      MESSAGE l_msg CLIPPED
      CALL ui.Interface.refresh()
      PRINT "[",g_x[18] CLIPPED,"]"
      MESSAGE "[",g_x[18] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[12] CLIPPED,"="
      MESSAGE g_x[12] CLIPPED,"="
      CALL ui.Interface.refresh()
      PRINT "[",g_x[19] CLIPPED,"]"
      MESSAGE "[",g_x[19] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[20] CLIPPED,"=",  g_zero USING '&'
      MESSAGE g_x[20] CLIPPED,"=",g_zero USING '&'
      CALL ui.Interface.refresh()
      PRINT "[",g_x[21] CLIPPED,"]"
      MESSAGE "[",g_x[21] CLIPPED,"]"
      CALL ui.Interface.refresh()
      PRINT g_x[22] CLIPPED,"=",g_zero USING '&'
      MESSAGE g_x[22] CLIPPED,"=",g_zero USING '&'
      CALL ui.Interface.refresh()
 
#  ON LAST ROW
#     PRINT '\^L'
 
  #end modify
END REPORT
 
REPORT acc_rep_account(sr)
  DEFINE sr        RECORD
                   aag01 LIKE aag_file.aag01,
                   aag02 LIKE aag_file.aag02,
                   aag06 LIKE aag_file.aag06,
                   aag08 LIKE aag_file.aag08,
                   aag24 LIKE aag_file.aag24
                   END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aag01
  FORMAT
  #modify 031225 NO.A104
  ON EVERY ROW
        IF sr.aag06 = '1' THEN
            PRINT '\"',sr.aag01 CLIPPED,'\"','\t','\"',sr.aag02 CLIPPED,
               '\"','\t',sr.aag06 CLIPPED
        ELSE
            PRINT '\"',sr.aag01 CLIPPED,'\"','\t','\"',sr.aag02 CLIPPED,
               '\"','\t-1'
        END IF
 
        MESSAGE '\"',sr.aag01 CLIPPED,'\"','\,','\"',sr.aag02 CLIPPED,
           '\"','\,',sr.aag06 CLIPPED
        CALL ui.Interface.refresh()
 
 
# ON LAST ROW
#    PRINT '\'
 
  #end modify
END REPORT
 
REPORT acc_rep_balance(sr)
     DEFINE sr        RECORD
                      aag01 LIKE aag_file.aag01,
                      aah01 LIKE aah_file.aah01,
                      balance LIKE aah_file.aah04  #No.FUN-4C0009  #NO FUN-690009 DEC(20,6)
                      END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aag01
  FORMAT
  #modify 031225 NO.A104
  ON EVERY ROW
     PRINT '\"',sr.aag01 CLIPPED,'\"','\t',sr.balance
     MESSAGE '\"',sr.aag01 CLIPPED,'\"','\,',sr.balance
     CALL ui.Interface.refresh()
 
# ON LAST ROW
#    PRINT '\'
 
  #end modify
END REPORT
 
REPORT acc_rep_vocher(sr)
  DEFINE sr        RECORD
                      aba01  LIKE aba_file.aba01,
                      aba02  LIKE aba_file.aba02,
                      aba08  LIKE aba_file.aba08,
                      aba09  LIKE aba_file.aba09,
                      aba10  LIKE aba_file.aba10,
                      abb03  LIKE abb_file.abb03,
                      abb06  LIKE abb_file.abb06,
                      abb07  LIKE abb_file.abb07,
                      abb07b LIKE abb_file.abb07f,   #No.FUN-4C0009   #NO FUN-690009 DEC(20,6)
                      aac01  LIKE aac_file.aac01,
                      aac03  LIKE aac_file.aac03,
                      aac03b LIKE zaa_file.zaa08,   #NO FUN-690009 VARCHAR(10) 
                      abb01  LIKE abb_file.abb01,
                      abb02  LIKE abb_file.abb02,
                      abb04  LIKE abb_file.abb04,   #add 031225 NO.A104
                      vocher LIKE aba_file.aba01  #NO FUN-690009 VARCHAR(30)
                   END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba02, sr.aac03, sr.aba01
  FORMAT
 
        #modify 031225 NO.A104
        BEFORE GROUP OF sr.aba01
            IF sr.aac03='1' THEN
                PRINT '\"',sr.aba10 CLIPPED,'\"','\t',
                      sr.aba02 USING "yyyy-mm-dd",'\t',
                      sr.aba08,'\t',0,'\t','\"',
                      sr.aac03b CLIPPED,'\"','\t','\"',
                      sr.vocher CLIPPED,'\"',''
                MESSAGE '\"',sr.aba10 CLIPPED,'\"','\t',
                      sr.aba02 USING "yyyy-mm-dd",'\t',
                      sr.aba08,'\t',g_zero USING "&",'\t','\"',
                      sr.aac03b CLIPPED,'\"','\t','\"',
                      sr.vocher CLIPPED,'\"',''
                CALL ui.Interface.refresh()
            ELSE
                IF sr.aac03='2' AND sr.aba10 IS NOT NULL THEN
                    PRINT '\"',sr.aba10 CLIPPED,'\"','\t',
                          sr.aba02 USING "yyyy-mm-dd",'\t',
                          0,'\t',sr.aba09,'\t','\"',
                          sr.aac03b CLIPPED,'\"','\t','\"',
                          sr.vocher CLIPPED,'\"','\t','\"',
                          sr.abb04 CLIPPED,'\"',''
                    MESSAGE '\"',sr.aba10 CLIPPED,'\"','\t',
                        sr.aba02 USING "yyyy-mm-dd",'\t',
                        g_zero USING "&",'\t',sr.aba09,'\t','\"',
                        sr.aac03b CLIPPED,'\"','\t','\"',
                        sr.vocher CLIPPED,'\"',''
                    CALL ui.Interface.refresh()
                END IF
            END IF
 
        ON EVERY ROW
            IF (sr.aac03='1' AND sr.abb06='2') OR
                (sr.aac03='2' AND sr.abb06='1') OR
                (sr.aac03='0' ) THEN
                PRINT '\"',sr.abb03 CLIPPED,'\"','\t',
                      sr.aba02 USING "yyyy-mm-dd",
                      '\t',sr.abb07,'\t',sr.abb07b,'\t','\"',
                      sr.aac03b CLIPPED,'\"','\t','\"',
                      #sr.abb04 CLIPPED,'\"','\t','\"',
                      #sr.vocher CLIPPED,'\"',''
                      sr.vocher CLIPPED,'\"','\t','\"',
                      sr.abb04 CLIPPED,'\"',''
                MESSAGE '\"',sr.abb03 CLIPPED,'\"','\,',
                      sr.aba02 USING "yyyy-mm-dd",
                      '\,',sr.abb07,'\,',sr.abb07b,'\,','\"',
                      sr.aac03b CLIPPED,'\"',
                      '\,','\"',sr.vocher CLIPPED,'\"',''
                CALL ui.Interface.refresh()
            END IF
 
        ON LAST ROW
            PRINT '\"'
 
END REPORT
#end modify
 
FUNCTION isfile(p_filename)
  DEFINE  p_filename  LIKE type_file.chr20,    #NO.FUN-690009 VARCHAR(20)
          l_str       LIKE type_file.chr1000,  #NO.FUN-690009 VARCHAR(200)
          l_success   LIKE type_file.chr1,     #NO.FUN-690009 VARCHAR(01)
          l_n         LIKE type_file.num5      #NO.FUN-690009 SMALLINT
 
  LET l_str = 'test -f ',p_filename CLIPPED
  RUN l_str RETURNING l_n
  MESSAGE l_n
  CALL ui.Interface.refresh()
  IF l_n THEN
     LET l_success = 'N'
  ELSE
     LET l_success = 'Y'
  END IF
  IF INT_FLAG THEN LET INT_FLAG = 0 LET l_success = 'N' END IF
  RETURN l_success
END FUNCTION
#Patch....NO.TQC-610037 <001> #
