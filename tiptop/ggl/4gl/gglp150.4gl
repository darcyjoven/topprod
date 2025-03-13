# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglp150.4gl
# Descriptions...: 會計核算軟體數據接口-上海市
# Date & Author..: 2004/08/20 BY BENNY
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-550028 05/05/28 By wujie  單據編號加大
# Modify.........: No.FUN-5B0070 05/11/14 By wujie 增加可從客戶端匯出資料
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.TQC-680138 06/08/29 By Tracy g_x 的值都沒有抓出來
# Modify.........: No.TQC-680157 06/08/31 By Tracy SHCZ.txt導出數據有問題 
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-730070 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: NO.MOD-8B0282 08/11/27 BY yiting 修正MOD-860078問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0082 09/11/17 By liuxqa standard sql
# Modify.........: No.FUN-A70145 10/07/30 By alex 調整ASE SQL
# Modify.........: No.FUN-A90024 10/11/24 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   #gglp150.per獲得的參數
              a       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #格式定義文件
              b       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #單位組織機構代碼
              c       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #軟件版本
              d       LIKE type_file.dat,          #NO FUN-690009    DATE            #啟用日期
              e       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #會計科目文件
              f       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #年初余額文件
              g       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #現行會計年度
              h       LIKE type_file.chr20,        #NO FUN-690009    VARCHAR(20)        #會計憑証文件
              i       LIKE type_file.num5,         #NO FUN-690009    SMALLINT        #憑証日期(年)
              j       LIKE type_file.num5,         #NO FUN-690009    SMALLINT        #憑証日期(月)
              k       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)        #No.FUN-5B0070
              bookno  LIKE aaa_file.aaa01          #No.FUN-730070
              END RECORD,
          ddate,vdate LIKE type_file.dat,          #NO FUN-690009    DATE
          g_bookno    LIKE aaa_file.aaa01,         #缺省帳套編號     #No.FUN-670039 
          g_company2  LIKE zo_file.zo02,           #NO FUN-690009    VARCHAR(72)        #公司對外全名   #MOD-730146 modify
          col ARRAY[30] OF RECORD
                           colname   LIKE  type_file.chr1000 ,
                           coltype   LIKE  type_file.chr20   ,
                           coltype2  LIKE  zaa_file.zaa08,       #NO FUN-690009    VARCHAR(10)
                           collength LIKE  type_file.chr4,         #NO FUN-690009    VARCHAR(4)
                           gaq04      LIKE  gaq_file.gaq04      #字段說明
                           END RECORD
DEFINE   g_i             LIKE type_file.num5          #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_row_count     LIKE type_file.num10         #NO FUN-690009   INTEGER
DEFINE   g_db_type       LIKE type_file.chr3   
DEFINE   g_target        LIKE type_file.chr1000,      #NO FUN-690009          VARCHAR(100)    # No.FUN-670039
         g_fileloc       LIKE type_file.chr1000,      #NO FUN-690009          VARCHAR(100)    # No.FUN-670039
         l_url           STRING
 
MAIN
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

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    LET g_db_type=cl_db_get_database_type()    #FUN-9B0082 mod

    LET g_bookno = ' '
    IF g_bookno IS NULL OR g_bookno = ' ' THEN
       SELECT aaz64 INTO g_bookno FROM aaz_file     #aaz64缺省帳套編號
    END IF
    CALL acc_tm()
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION acc_tm()
   DEFINE l_sw        LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)  #重要欄位是否空白
          l_chr       LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(01)
          l_cnt       LIKE type_file.num5
 
   OPEN WINDOW acc_w WITH FORM "ggl/42f/gglp150"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   INITIALIZE tm.* TO NULL            # Default condition
   SELECT aaa04 INTO tm.g             #aaz04現行會計年度
     FROM aaa_file WHERE aaa01 = g_bookno
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #aaz03使用幣種
 
   #如果未取到使用幣種，則從整體管理系統參數檔中提取本國貨幣作為使用幣種
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF    #aza17本國幣種
 
   LET tm.a = "SHCZ.txt"
   LET tm.c = "V6.50"
   LET tm.d = g_today
   LET tm.e = "ACCOUNT.txt"
   LET tm.f = "BALANCE.txt"
   LET tm.h = "VOUCHER.txt"
   LET tm.i = YEAR(g_today)
   LET tm.j = MONTH(g_today)
   LET tm.k = 'N'   #No.FUN-5B0070
   LET tm.bookno = g_aza.aza81  #No.FUN-730070
 
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h,tm.i,tm.j,    #FUN-5B0070  #No.FUN-730070
                  tm.bookno,tm.k   #No.FUN-730070
                  WITHOUT DEFAULTS HELP 1
 
        #No.FUN-730070  --Begin
        AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL p150_bookno('a',tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               END IF
            END IF
        #No.FUN-730070  --End  
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      #No.FUN-7300070  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bookno) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = tm.bookno
               CALL cl_create_qry() RETURNING tm.bookno
               DISPLAY BY NAME tm.bookno
               CALL p150_bookno('d',tm.bookno)
         END CASE
 
         ON KEY(control-t)
            LET g_trace = 'Y'    # Trace on

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
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT   #MOD-8B0282
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW acc_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acc_shcz()
END WHILE
   CLOSE WINDOW acc_w
END FUNCTION
 
#No.FUN-730070  --Begin
FUNCTION p150_bookno(p_cmd,p_bookno)
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
     DEFINE l_name    LIKE type_file.chr20         #NO FUN-690009   VARCHAR(60)
     DEFINE l_tablename    LIKE type_file.chr20    #FUN-9B0082 mod     
     DEFINE l_tmp     LIKE type_file.chr1000       #NO FUN-690009   VARCHAR(60)         #No.TQC-680138
     DEFINE l_cnt     LIKE type_file.num5          #NO FUN-690009   SMALLINT
     DEFINE l_sql     STRING,
            l_msg     LIKE type_file.chr1000,      #NO FUN-690009   VARCHAR(100)
            l_aag01   LIKE aag_file.aag01,         #NO FUN-690009   VARCHAR(24)         #科目編號
            l_aag02   LIKE aag_file.aag02,         #NO FUN-690009   VARCHAR(30)         #科目名稱
            l_aag08   LIKE aag_file.aag08,         #NO FUN-690009   VARCHAR(24)         #所屬統制帳戶科目
            l_aag24   LIKE aag_file.aag24,         # Prog. Version..: '5.30.06-13.03.12(01)         #？
            l_pre01   LIKE aag_file.aag01,         #NO FUN-690009   VARCHAR(24)         #
            l_pre24   LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(01)
            l_len     LIKE type_file.num5
     DEFINE sr        RECORD           #格式定義文件
                      aag24 LIKE aag_file.aag24, #?
                      del    LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)
                      azm011 LIKE azm_file.azm011,
                      azm012 LIKE azm_file.azm012,
                      azm021 LIKE azm_file.azm021,
                      azm022 LIKE azm_file.azm022,
                      azm031 LIKE azm_file.azm031,
                      azm032 LIKE azm_file.azm032,
                      azm041 LIKE azm_file.azm041,
                      azm042 LIKE azm_file.azm042,
                      azm051 LIKE azm_file.azm051,
                      azm052 LIKE azm_file.azm052,
                      azm061 LIKE azm_file.azm061,
                      azm062 LIKE azm_file.azm062,
                      azm071 LIKE azm_file.azm071,
                      azm072 LIKE azm_file.azm072,
                      azm081 LIKE azm_file.azm081,
                      azm082 LIKE azm_file.azm082,
                      azm091 LIKE azm_file.azm091,
                      azm092 LIKE azm_file.azm092,
                      azm101 LIKE azm_file.azm101,
                      azm102 LIKE azm_file.azm102,
                      azm111 LIKE azm_file.azm111,
                      azm112 LIKE azm_file.azm112,
                      azm121 LIKE azm_file.azm121,
                      azm122 LIKE azm_file.azm122
                      END RECORD
     DEFINE sr1       RECORD           #科目庫
                      aag01 LIKE aag_file.aag01,
                      aag02 LIKE aag_file.aag02,
                      aag06 LIKE type_file.chr3,     # Prog. Version..: '5.30.06-13.03.12(02)  #LIKE aag_file.aag06,
                      aag08 LIKE aag_file.aag08,
                      aag24 LIKE aag_file.aag24
                      END RECORD
     DEFINE sr2       RECORD           #年初余額庫
                      aag01 LIKE aag_file.aag01,
                      aah01 LIKE aah_file.aah01,     #科目編號
                      balance LIKE aah_file.aah04   #NO FUN-690009   DEC(20,6)   #No.FUN-4C0009
                      END RECORD
     DEFINE sr3       RECORD           #憑証庫
                      aba01  LIKE aba_file.aba01,    #憑証編號
                      aba02  LIKE aba_file.aba02,    #憑証日期
                      aba08  LIKE aba_file.aba08,    #借方總金額
                      aba09  LIKE aba_file.aba09,    #貸方總金額
                      aba10  LIKE aba_file.aba10,    #收支科目
                      abb03  LIKE abb_file.abb03,    #科目編號
                      abb06  LIKE abb_file.abb06,    #借貸類(1.借/2.貸)
                      abb07  LIKE abb_file.abb07,    #異動金額
                      abb07b LIKE type_file.num20_6,   #NO FUN-690009    DEC(20,6)   #No.FUN-4C0009
                      aac01  LIKE aac_file.aac01,    #憑証單別編號
                      aac03  LIKE aac_file.aac03,    #轉帳性質
                      aac03b LIKE zaa_file.zaa08,    #NO FUN-690009    VARCHAR(10)
                      abb01  LIKE abb_file.abb01,    #憑証編號
                      abb02  LIKE abb_file.abb02,    #項次
                      vocher LIKE aba_file.aba01   #NO FUN-690009    VARCHAR(30)
                      END RECORD
 
     SELECT aaf03 INTO g_company FROM aaf_file       #aaf03,g_company帳套名稱
      WHERE aaf01 = tm.bookno AND aaf02 = g_lang  #No.FUN-730070
     SELECT zo02 INTO g_company2 FROM zo_file WHERE zo01 = g_lang #zo02公司對內全名   #MOD-730146 modify
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglp150'
     #zz17報表寬度,zz05打印選擇條件否
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 0 END IF

     CALL cl_outnam('gglp150') RETURNING l_tmp   #No.TQC-680138  
 
  #格式定義文件
     MESSAGE g_x[29] CLIPPED
     SLEEP 1
     LET l_name = tm.a
     FOR l_cnt = 1 TO 30
         INITIALIZE col[l_cnt].* TO NULL
     END FOR
#FUN-9B0082 mod --begin
     #---FUN-A90024---start-----
     #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
     #目前統一用sch_file紀錄TIPTOP資料結構
     #CASE g_db_type
     #WHEN "ORA"
     ##LET l_sql=" SELECT unique lower(column_name),data_type,'',to_char(decode(data_precision,null, data_length, data_precision),'999.99'),gaq04",
     #LET l_sql=" SELECT unique lower(column_name),'','','',gaq04",
     #          " FROM user_tab_columns,OUTER gaq_file ",
     #          " WHERE (lower(column_name) = 'aag01' OR lower(column_name) = 'aag02' ",
     #          "   OR lower(column_name) = 'aag06' OR lower(column_name) = 'aac03' ",
     #          "   OR lower(column_name) = 'aba01' OR lower(column_name) = 'aba02' ",
     #          "   OR lower(column_name) = 'aba08' OR lower(column_name) = 'aba09')",      
     #          "   AND gaq02   = '0' ",
     #          "   AND lower(column_name) = gaq_file.gaq01 "
     #WHEN "IFX"
     ##LET l_sql=" SELECT b.colname,b.coltype,'',b.colength,gaq04 ",
     #LET l_sql=" SELECT b.colname,'','','',gaq04 ",
     #          "  FROM systables a,syscolumns b, OUTER gaq_file ",
     #          "WHERE a.tabid = b.tabid",
     #          "AND (b.colname = 'aag01' OR b.colname = 'aag02' ",
     #          "   OR b.colname = 'aag06' OR b.colname = 'aac03' ",
     #          "   OR b.colname = 'aba01' OR b.colname  = 'aba02' ",
     #          "   OR b.colname = 'aba08' OR b.colname = 'aba09')",
     #          "   AND b.colname= gaq_fiel.gaq01 AND gaq02 = '0' "
     #WHEN "MSV"
     ##LET l_sql="SELECT a.name, b.name,'',a.max_length,gaq04 ",
     #LET l_sql="SELECT a.name, '','','',gaq04 ",
     #          "  FROM sys.types b,sys.all_columns a LEFT OUTER JOIN gaq_file ON a.name=gaq01",
     #          "  WHERE a.system_type_id = b.user_type_id ",
     #          "    AND (a.name = 'aag01' OR a.name = 'aag02' ",
     #          "   OR a.name = 'aag06' OR a.name = 'aac03' ",
     #          "   OR a.name = 'aba01' OR a.name  = 'aba02' ",
     #          "   OR a.name = 'aba08' OR a.name = 'aba09')",
     #          "   AND gaq02 = '0' "
     #WHEN "ASE"                           #FUN-A70145
     #LET l_sql="SELECT a.name, '','','',gaq04 ",
     #          "  FROM sys.types b,sys.all_columns a LEFT OUTER JOIN gaq_file ON a.name=gaq01",
     #          "  WHERE a.system_type_id = b.user_type_id ",
     #          "    AND (a.name = 'aag01' OR a.name = 'aag02' ",
     #          "   OR a.name = 'aag06' OR a.name = 'aac03' ",
     #          "   OR a.name = 'aba01' OR a.name  = 'aba02' ",
     #          "   OR a.name = 'aba08' OR a.name = 'aba09')",
     #          "   AND gaq02 = '0' "
     #END CASE
     LET l_sql = "SELECT sch02, '', '', '', gaq04 ",
                 "  FROM sch_file LEFT OUTER JOIN gaq_file ",
                 "    ON sch02 = gaq_file.gaq01 ",
                 "  WHERE (sch02= 'aag01' OR sch02 = 'aag02' ",
                 "    OR sch02= 'aag06' OR sch02= 'aac03' ",
                 "    OR sch02= 'aba01' OR sch02= 'aba02' ",
                 "    OR sch02= 'aba08' OR sch02= 'aba09') ",
                 "    AND gaq02   = '0' "
     #---FUN-A90024---end-------

     PREPARE p_zt_pp FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
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
       CALL cl_get_column_info(g_dbs,l_tablename,col[l_cnt].colname) RETURNING col[l_cnt].coltype,col[l_cnt].collength  #FUN-9B0082 MOD
       CASE WHEN col[l_cnt].coltype = 'varchar2' LET col[l_cnt].coltype2 = g_x[34]       
            WHEN col[l_cnt].coltype = 'number'   LET col[l_cnt].coltype2 = g_x[35]       
            WHEN col[l_cnt].coltype = 'date'     LET col[l_cnt].coltype2 = g_x[36]       
            OTHERWISE LET col[l_cnt].coltype2 = col[l_cnt].coltype
       END CASE
       IF col[l_cnt].collength = '3843' THEN
          LET col[l_cnt].collength = '15,3'
       END IF
       LET l_cnt = l_cnt + 1
     END FOREACH
     START REPORT acc_rep TO l_name
       SELECT MAX(aag24) INTO sr.aag24 FROM aag_file
        WHERE aag00 = tm.bookno  #No.FUN-730070
       SELECT azm011,azm012,azm021,azm022,azm031,azm032,azm041,azm042,
              azm051,azm052,azm061,azm062,azm071,azm072,azm081,azm082,
              azm091,azm092,azm101,azm102,azm111,azm112,azm121,azm122     #No.TQC-680157 add azm101,azm102
       INTO sr.azm011,sr.azm012,sr.azm021,sr.azm022,sr.azm031,sr.azm032,
            sr.azm041,sr.azm042,sr.azm051,sr.azm052,sr.azm061,sr.azm062,
            sr.azm071,sr.azm072,sr.azm081,sr.azm082,sr.azm091,sr.azm092,
            sr.azm101,sr.azm102,sr.azm111,sr.azm112,sr.azm121,sr.azm122
       FROM azm_file
       WHERE azm01 = tm.g and azm02 = 1
       OUTPUT TO REPORT acc_rep(sr.*)
     FINISH REPORT acc_rep
#No.FUN-5B0070--begin
   IF tm.k = 'Y' THEN
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",l_name CLIPPED
      IF NOT cl_open_url(l_url) THEN
         CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
      END IF
   END IF
#No.FUN-5B0070--end
     MESSAGE g_x[33] CLIPPED
     SLEEP 1
 
 #科目
     MESSAGE g_x[30] CLIPPED
     SLEEP 1
     LET l_sql = "SELECT aag01, aag02, aag06, aag08, aag24 FROM aag_file ",
                 " WHERE aag09 = 'Y' AND aag24 >= 1 AND aagacti = 'Y'",
#                " AND aag01 <> (SELECT aaz31 FROM aaz_file)",   #FUN-BC0027
                 " AND aag01 <> (SELECT aaa14 FROM aaa_file WHERE aaa01='",tm.bookno,"')",   #FUN-BC0027
                 " AND aag00 = '",tm.bookno,"'",   #No.FUN-730070
                 " ORDER BY aag01 "
     PREPARE acc_prepare1 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare1:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE acc_curs1 CURSOR FOR acc_prepare1
     LET l_name = tm.e
     START REPORT acc_rep_account TO l_name
     FOREACH acc_curs1 INTO sr1.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       IF sr1.aag06 = "2 " THEN
          LET sr1.aag06 = "-1"
       END IF
       LET sr1.aag01 = acc_aag01_2(sr1.aag01)
       OUTPUT TO REPORT acc_rep_account(sr1.*)
     END FOREACH
     FINISH REPORT acc_rep_account
#No.FUN-5B0070--begin
   IF tm.k = 'Y' THEN
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",l_name CLIPPED
      IF NOT cl_open_url(l_url) THEN
         CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
      END IF
   END IF
#No.FUN-5B0070--end
     MESSAGE g_x[33] CLIPPED
     SLEEP 1
 
 #年初余額
     MESSAGE g_x[31] CLIPPED
     SLEEP 1
     LET l_sql = "SELECT aag01, '', 0 FROM aag_file ",
                 " WHERE (aag07 = '2' OR aag07 ='3')",
                 "   AND aag09 = 'Y' AND aagacti = 'Y'",
#                "   AND aag01 <> (SELECT aaz31 FROM aaz_file ) ",  #FUN-BC0027
                 "   AND aag01 <> (SELECT aaa14 FROM aaa_file WHERE aaa01='",tm.bookno,"') ",  #FUN-BC0027                 
                 "   AND aag00 = '",tm.bookno,"'",  #No.FUN-730070
                 " ORDER BY aag01 "
     PREPARE acc_prepare2 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare2:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE acc_curs2 CURSOR FOR acc_prepare2
     LET l_name = tm.f
     START REPORT acc_rep_balance TO l_name
     FOREACH acc_curs2 INTO sr2.*
       IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) EXIT FOREACH END IF
       IF tm.j-1>0 THEN
          SELECT aah01,aah04-aah05 INTO sr2.aah01,sr2.balance FROM aah_file
          WHERE aah00 = tm.bookno AND aah01 = sr2.aag01  #No.FUN-730070
             AND aah02 = tm.i AND aah03 = tm.j-1
       ELSE
          SELECT aah01,aah04-aah05 INTO sr2.aah01,sr2.balance FROM aah_file
          WHERE aah00 = tm.bookno AND aah01 = sr2.aag01 AND aah02 = tm.i-1  #No.FUN-730070
             AND aah03 = (SELECT MAX(aah03) FROM aah_file
                          WHERE aah00 = tm.bookno AND aah01 = sr2.aag01  #No.FUN-730070
                          AND aah02 = tm.i-1   )
          ORDER BY aah01
       END IF
       IF sr2.balance IS NULL THEN LET sr2.balance = 0 END IF
       LET sr2.aag01 = acc_aag01_2(sr2.aag01)
       OUTPUT TO REPORT acc_rep_balance(sr2.*)
     END FOREACH
     FINISH REPORT acc_rep_balance
#No.FUN-5B0070--begin
   IF tm.k = 'Y' THEN
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",l_name CLIPPED
      IF NOT cl_open_url(l_url) THEN
         CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
      END IF
   END IF
#No.FUN-5B0070--end
     MESSAGE g_x[33] CLIPPED
     SLEEP 1
 
 #憑証
     MESSAGE g_x[32] CLIPPED
     SLEEP 1
     LET l_sql = "SELECT aba01, aba02, aba08, aba09, aba10, abb03, abb06,",
                 "       abb07, abb07, aac01, aac03, abb01, abb02, '' ",
                 "  FROM aac_file, aba_file ,abb_file ",
                 " WHERE aba00 = abb00 AND aba01 = abb01 ",
#                "   AND aba01[1,3] = aac01 ",
                 "   AND aba01 like trim(aac01) ||'-%' ",           #No.FUN-550028
                 "   AND aba00 = '",tm.bookno,"'",   #No.FUN-730070
                 "   AND abapost = 'Y' AND aba19   = 'Y' " ,
                 "   AND abaacti = 'Y' AND aacacti = 'Y' "
     IF tm.i IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND aba03 = '",tm.i,"' AND aba04 = '",tm.j,"'"
     END IF
     LET l_sql = l_sql CLIPPED, " ORDER BY aba02, aac03, aba01 "
     PREPARE acc_prepare3 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare3:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
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
#         LET sr3.aac03b = g_x[23] CLIPPED       #No.TQC-680138 mark
          LET sr3.aac03b = g_x[26] CLIPPED       #No.TQC-680138
          LET sr3.vocher = sr3.aba01
       END IF
       IF sr3.aac03 = '1' THEN
          IF sr3.abb06 = '2' THEN LET sr3.abb07 = 0 END IF
#         LET sr3.aac03b = g_x[24] CLIPPED       #No.TQC-680138 mark
          LET sr3.aac03b = g_x[27] CLIPPED       #No.TQC-680138
          LET sr3.vocher = sr3.aba01
       END IF
       IF sr3.aac03 = '2' THEN
          IF sr3.abb06 = '1' THEN LET sr3.abb07b = 0 END IF
#         LET sr3.aac03b = g_x[25] CLIPPED       #No.TQC-680138 mark
          LET sr3.aac03b = g_x[28] CLIPPED       #No.TQC-680138
          LET sr3.vocher = sr3.aba01
       END IF
       LET sr3.aba10 = acc_aag01_2(sr3.aba10)
       LET sr3.abb03 = acc_aag01_2(sr3.abb03)
       OUTPUT TO REPORT acc_rep_vocher(sr3.*)
     END FOREACH
     FINISH REPORT acc_rep_vocher
#No.FUN-5B0070--begin
   IF tm.k = 'Y' THEN
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",l_name CLIPPED
      IF NOT cl_open_url(l_url) THEN
         CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
      END IF
   END IF
#No.FUN-5B0070--end
     MESSAGE g_x[33] CLIPPED
     SLEEP 1
 
END FUNCTION
 
#計算當前科目設置的情況
FUNCTION acc_subject()
   DEFINE l_sub   LIKE type_file.chr20,        #NO FUN-690009   VARCHAR(20)
          l_len   LIKE type_file.num5,         #NO FUN-690009   SMALLINT
          l_len_o LIKE type_file.num5,         #NO FUN-690009   SMALLINT
          l_len_t LIKE type_file.chr20,        #NO FUN-690009   VARCHAR(20)
          l_sql   STRING,
          l_aag24 LIKE aag_file.aag24
 
   LET l_sql = "SELECT DISTINCT aag24 FROM aag_file WHERE aag24 IS NOT NULL",
               "   AND aag00 = '",tm.bookno,"'",   #No.FUN-730070
               " ORDER BY aag24"
   PREPARE acc_prepare4 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare4:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE acc_curs4 CURSOR FOR acc_prepare4
   FOREACH acc_curs4 INTO l_aag24
      SELECT MAX(LENGTH(aag01)) INTO l_len FROM aag_file
      WHERE aag24 = l_aag24
        AND aag00 = tm.bookno  #No.FUN-730070
      IF cl_null(l_sub) THEN
         LET l_sub = l_len
      ELSE
         LET l_len_t = l_len-l_len_o
         LET l_sub = l_sub CLIPPED,",",l_len_t CLIPPED
      END IF
      LET l_len_o = l_len
   END FOREACH
 
   RETURN l_sub
 
END FUNCTION
 
#按級數分隔科目代碼
FUNCTION acc_aag01_2(l_aag01)
   DEFINE l_aag01     LIKE aag_file.aag01,
          l_aag08     LIKE aag_file.aag08,
          l_aag24     LIKE aag_file.aag24,
          t_aag24     LIKE aag_file.aag24,
          l_len       LIKE type_file.num5          #NO FUN-690009   SMALLINT
 
   SELECT aag08,aag24 INTO l_aag08,l_aag24
   FROM aag_file
   WHERE aag01 = l_aag01
     AND aag00 = tm.bookno   #No.FUN-730070
   IF l_aag01 != l_aag08 THEN
      WHILE l_aag24 > 1
        LET l_len = length(l_aag08)
        LET l_aag01 = l_aag01[1,l_len] CLIPPED,"\-",l_aag01[l_len+1,24]
        IF l_aag24 = t_aag24 THEN EXIT WHILE END IF
        LET t_aag24=l_aag24
        SELECT aag08,aag24 INTO l_aag08,l_aag24
        FROM aag_file
        WHERE aag01 = l_aag08
          AND aag00 = tm.bookno   #No.FUN-730070
      END WHILE
   END IF
 
   RETURN l_aag01
 
END FUNCTION
 
#格式定義文件
REPORT acc_rep(sr)
   DEFINE sr       RECORD
                   aag24 LIKE aag_file.aag24,
                   del    LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)
                   azm011 LIKE azm_file.azm011,
                   azm012 LIKE azm_file.azm012,
                   azm021 LIKE azm_file.azm021,
                   azm022 LIKE azm_file.azm022,
                   azm031 LIKE azm_file.azm031,
                   azm032 LIKE azm_file.azm032,
                   azm041 LIKE azm_file.azm041,
                   azm042 LIKE azm_file.azm042,
                   azm051 LIKE azm_file.azm051,
                   azm052 LIKE azm_file.azm052,
                   azm061 LIKE azm_file.azm061,
                   azm062 LIKE azm_file.azm062,
                   azm071 LIKE azm_file.azm071,
                   azm072 LIKE azm_file.azm072,
                   azm081 LIKE azm_file.azm081,
                   azm082 LIKE azm_file.azm082,
                   azm091 LIKE azm_file.azm091,
                   azm092 LIKE azm_file.azm092,
                   azm101 LIKE azm_file.azm101,
                   azm102 LIKE azm_file.azm102,
                   azm111 LIKE azm_file.azm111,
                   azm112 LIKE azm_file.azm112,
                   azm121 LIKE azm_file.azm121,
                   azm122 LIKE azm_file.azm122
                   END RECORD,
          l_cnt     LIKE type_file.num5,         #NO FUN-690009   SMALLINT
          l_msg     LIKE type_file.chr1000,      #NO FUN-690009   VARCHAR(100)
          l_subject LIKE type_file.chr20         #NO FUN-690009   VARCHAR(20)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
#[帳套]
      PRINT "[",g_x[1] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[1] CLIPPED,"]"
#帳套=1,1
      PRINT g_x[1] CLIPPED,"=1\,1"# ,'\'
      #MESSAGE g_x[1] CLIPPED,"=1\,1"
#帳套名稱=
      PRINT g_x[2] CLIPPED,"=",g_company CLIPPED#,'\'
      #MESSAGE g_x[2] CLIPPED,"=",g_company CLIPPED
#單位名稱=
      PRINT g_x[3] CLIPPED,"=",g_company2 CLIPPED#,'\'
      #MESSAGE g_x[3] CLIPPED,"=",g_company2 CLIPPED
#會計年度=
      PRINT g_x[4] CLIPPED,"=",tm.g CLIPPED#,'\'
      #MESSAGE g_x[4] CLIPPED,"=",tm.g CLIPPED
#行業
      PRINT g_x[5] CLIPPED#,'\'
      #MESSAGE g_x[5] CLIPPED
#單位組織機構代碼=
      PRINT g_x[6] CLIPPED,"=",tm.b CLIPPED#,'\'
      #MESSAGE g_x[6] CLIPPED,"=",tm.b CLIPPED
#[帳務]
      PRINT "[",g_x[7] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[7] CLIPPED,"]"
#軟件公司=神州數碼管理有限公司
      PRINT g_x[8] CLIPPED#,'\'
      #MESSAGE g_x[8] CLIPPED
#軟件版本=V6.00
      PRINT g_x[9] CLIPPED,"=",tm.c CLIPPED#,'\'
      #MESSAGE g_x[9] CLIPPED,"=",tm.c CLIPPED
#啟用日期=
      PRINT g_x[10] CLIPPED,"=",tm.d USING "YYYYMMDD"#,'\'
      #MESSAGE g_x[10] CLIPPED,"=",tm.d USING "YYYYMMDD"
#啟用會計期=
      PRINT g_x[11] CLIPPED,"=",tm.d USING "YYYYMMDD"#,'\'
      #MESSAGE g_x[11] CLIPPED,"=",tm.d USING "YYYYMMDD"
#當前會計期
      PRINT g_x[12] CLIPPED,"=",MDY(tm.j,1,tm.i) USING "YYYYMMDD"#,'\'
      #MESSAGE g_x[12] CLIPPED,"=",MDY(tm.j,1,tm.i) USING "YYYYMMDD"
#期間=1
      PRINT g_x[13] CLIPPED,"=1",'\,',sr.azm011 USING 'mmdd','\,',sr.azm012 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=1",'\,',sr.azm011 USING 'mmdd','\,',sr.azm012 USING 'yyyymmdd','\,1'
#期間=2
      PRINT g_x[13] CLIPPED,"=2",'\,',sr.azm021 USING 'mmdd','\,',sr.azm022 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=2",'\,',sr.azm021 USING 'mmdd','\,',sr.azm022 USING 'yyyymmdd','\,1'
#期間=3
      PRINT g_x[13] CLIPPED,"=3",'\,',sr.azm031 USING 'mmdd','\,',sr.azm032 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=3",'\,',sr.azm031 USING 'mmdd','\,',sr.azm032 USING 'yyyymmdd','\,1'
#期間=4
      PRINT g_x[13] CLIPPED,"=4",'\,',sr.azm041 USING 'mmdd','\,',sr.azm042 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=4",'\,',sr.azm041 USING 'mmdd','\,',sr.azm042 USING 'yyyymmdd','\,1'
#期間=5
      PRINT g_x[13] CLIPPED,"=5",'\,',sr.azm051 USING 'mmdd','\,',sr.azm052 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=5",'\,',sr.azm051 USING 'mmdd','\,',sr.azm052 USING 'yyyymmdd','\,1'
#期間=6
      PRINT g_x[13] CLIPPED,"=6",'\,',sr.azm061 USING 'mmdd','\,',sr.azm062 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=6",'\,',sr.azm061 USING 'mmdd','\,',sr.azm062 USING 'yyyymmdd','\,1'
#期間=7
      PRINT g_x[13] CLIPPED,"=7",'\,',sr.azm071 USING 'mmdd','\,',sr.azm072 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=7",'\,',sr.azm071 USING 'mmdd','\,',sr.azm072 USING 'yyyymmdd','\,1'
#期間=8
      PRINT g_x[13] CLIPPED,"=8",'\,',sr.azm081 USING 'mmdd','\,',sr.azm082 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=8",'\,',sr.azm081 USING 'mmdd','\,',sr.azm082 USING 'yyyymmdd','\,1'
#期間=9
      PRINT g_x[13] CLIPPED,"=9",'\,',sr.azm091 USING 'mmdd','\,',sr.azm092 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=9",'\,',sr.azm091 USING 'mmdd','\,',sr.azm092 USING 'yyyymmdd','\,1'
#期間=10
      PRINT g_x[13] CLIPPED,"=10",'\,',sr.azm101 USING 'mmdd','\,',sr.azm102 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=10",'\,',sr.azm101 USING 'mmdd','\,',sr.azm102 USING 'yyyymmdd','\,1'
#期間=11
      PRINT g_x[13] CLIPPED,"=11",'\,',sr.azm111 USING 'mmdd','\,',sr.azm112 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=11",'\,',sr.azm111 USING 'mmdd','\,',sr.azm112 USING 'yyyymmdd','\,1'
#期間=12
      PRINT g_x[13] CLIPPED,"=12",'\,',sr.azm121 USING 'mmdd','\,',sr.azm122 USING 'yyyymmdd','\,1'
      #MESSAGE g_x[13] CLIPPED,"=12",'\,',sr.azm121 USING 'mmdd','\,',sr.azm122 USING 'yyyymmdd','\,1'
#[科目]
      PRINT "[",g_x[14] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[14] CLIPPED,"]"
#文件名=
      PRINT g_x[15] CLIPPED,"=",tm.e CLIPPED#,'\'
      #MESSAGE g_x[15] CLIPPED,"=",tm.e CLIPPED
#科目結構
      LET l_subject = acc_subject()
      PRINT g_x[16] CLIPPED,"=",l_subject CLIPPED
      #MESSAGE g_x[16] CLIPPED,"=",l_subject CLIPPED
#分隔符
      PRINT g_x[17] CLIPPED,"=",'\-'#,'\'
      #MESSAGE g_x[17] CLIPPED,"=",'\-'
#字段:科目編碼
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aag01' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:科目名稱
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aag02' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:借貸方向
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aag06' THEN
             LET col[l_cnt].gaq04 = g_x[37] CLIPPED
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#年初余額
      PRINT "[",g_x[19] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[19] CLIPPED,"]"
#文件名
      PRINT g_x[15] CLIPPED,"=",tm.f CLIPPED#,'\'
      #MESSAGE g_x[15] CLIPPED,"=",tm.f CLIPPED
#字段:科目編碼
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aag01' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:年初金額
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aba08' THEN
             LET col[l_cnt].gaq04 = g_x[38] CLIPPED
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#[憑証]
      PRINT "[",g_x[20] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[20] CLIPPED,"]"
#文件名
      PRINT g_x[15] CLIPPED,"=",tm.h CLIPPED#,'\'
      #MESSAGE g_x[15] CLIPPED,"=",tm.h CLIPPED
#字段:科目編碼
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aag01' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:憑証日期
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aba02' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:借方金額
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aba08' THEN
             LET col[l_cnt].gaq04 = g_x[40] CLIPPED
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:貸方金額
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aba09' THEN
             LET col[l_cnt].gaq04 = g_x[41] CLIPPED
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:憑証類型
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aac03' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#字段:憑証編號
      FOR l_cnt = 1 TO 10
          IF col[l_cnt].colname = 'aba01' THEN
             LET l_msg = g_x[18] CLIPPED,"=",col[l_cnt].gaq04 CLIPPED,'\,',
                         col[l_cnt].coltype2 CLIPPED,'(',
                         col[l_cnt].collength CLIPPED,')'
             ELSE CONTINUE FOR
          END IF
      END FOR
      PRINT l_msg CLIPPED#,'\'
      #MESSAGE l_msg CLIPPED
#[核算]
      PRINT "[",g_x[21] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[21] CLIPPED,"]"
#文件名
      PRINT g_x[15] CLIPPED,"="#,'\'
      #MESSAGE g_x[15] CLIPPED,"="
#[報表]
      PRINT "[",g_x[22] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[22] CLIPPED,"]"
#報表數
      PRINT g_x[23] CLIPPED,"=",0 USING '&'#,'\'
      #MESSAGE g_x[23] CLIPPED,"=",0 USING '&'
#[統計碼]
      PRINT "[",g_x[24] CLIPPED,"]"#,'\'
      #MESSAGE "[",g_x[24] CLIPPED,"]"
#統計碼數
      PRINT g_x[25] CLIPPED,"=",0 USING '&'#,'\'
      #MESSAGE g_x[25] CLIPPED,"=",0 USING '&'
 
# ON LAST ROW
#    PRINT '\'
 
END REPORT
 
#科目庫
REPORT acc_rep_account(sr)
  DEFINE sr        RECORD
                   aag01 LIKE aag_file.aag01,
                   aag02 LIKE aag_file.aag02,
                   aag06 LIKE type_file.chr3,       # Prog. Version..: '5.30.06-13.03.12(02)  #LIKE aag_file.aag06,
                   aag08 LIKE aag_file.aag08,
                   aag24 LIKE aag_file.aag24
                   END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aag01
  FORMAT
  ON EVERY ROW
     PRINT sr.aag01 CLIPPED,'\t',sr.aag02 CLIPPED,
           '\t',sr.aag06 CLIPPED#,'\'
     #MESSAGE sr.aag01 CLIPPED,'\,',sr.aag02 CLIPPED,
     #      '\,',sr.aag06 CLIPPED#,'\'
 
# ON LAST ROW
#    PRINT '\'
 
END REPORT
 
#年初余額
REPORT acc_rep_balance(sr)
     DEFINE sr        RECORD
                      aag01 LIKE aag_file.aag01,
                      aah01 LIKE aah_file.aah01,
                      balance LIKE aah_file.aah04        #NO FUN-690009   DEC(20,6)   #No.FUN-4C0009
                      END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aag01
  FORMAT
  ON EVERY ROW
     PRINT sr.aag01 CLIPPED,'\t',sr.balance#,'\'
     #MESSAGE sr.aag01 CLIPPED,'\,',sr.balance#,'\'
 
# ON LAST ROW
#    PRINT '\'
 
END REPORT
 
#憑証庫
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
                      abb07b LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)   #No.FUN-4C0009
                      aac01  LIKE aac_file.aac01,
                      aac03  LIKE aac_file.aac03,
                      aac03b LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(10)
                      abb01  LIKE abb_file.abb01,
                      abb02  LIKE abb_file.abb02,
                      vocher LIKE aba_file.aba01     #NO FUN-690009   VARCHAR(30)
                   END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba02, sr.aac03, sr.aba01
  FORMAT
 
  BEFORE GROUP OF sr.aba01
     IF sr.aac03 = '1' THEN
        PRINT sr.aba10 CLIPPED,'\t',sr.aba02 USING "yyyy-mm-dd",'\t',
                   sr.aba08,'\t',0,'\t',
                   sr.aac03b CLIPPED,'\t',sr.vocher CLIPPED#,''
        #MESSAGE sr.aba10 CLIPPED,'\t',sr.aba02 USING "yyyy-mm-dd",'\t',
        #           sr.aba08,'\t',0,'\t',
        #           sr.aac03b CLIPPED,'\t',sr.vocher CLIPPED#,''
     ELSE IF sr.aac03 = '2' AND sr.aba10 IS NOT NULL THEN
             PRINT sr.aba10 CLIPPED,'\t',sr.aba02 USING "yyyy-mm-dd",'\t',
                        0,'\t',sr.aba09,'\t',
                        sr.aac03b CLIPPED,'\t',sr.vocher CLIPPED#,''
             #MESSAGE sr.aba10 CLIPPED,'\t',sr.aba02 USING "yyyy-mm-dd",'\t',
             #           0,'\t',sr.aba09,'\t',
             #           sr.aac03b CLIPPED,'\t',sr.vocher CLIPPED#,''
          END IF
     END IF
 
  ON EVERY ROW
     IF (sr.aac03 = '1' AND sr.abb06 = '2') OR
        (sr.aac03 = '2' AND sr.abb06 = '1') OR
        (sr.aac03 = '0' ) THEN
        PRINT sr.abb03 CLIPPED,'\t',sr.aba02 USING "yyyy-mm-dd",'\t',
                   sr.abb07,'\t',sr.abb07b,'\t',
                   sr.aac03b CLIPPED,'\t',sr.vocher CLIPPED#,''
        #MESSAGE sr.abb03 CLIPPED,'\,',sr.aba02 USING "yyyy-mm-dd",'\,',
        #           sr.abb07,'\,',sr.abb07b,'\,',
        #           sr.aac03b CLIPPED,'\,',sr.vocher CLIPPED#,''
     END IF
 
# ON LAST ROW
#    PRINT '\'
 
END REPORT
 
FUNCTION isfile(p_filename)
  DEFINE  p_filename  LIKE type_file.chr20,        #NO FUN-690009   VARCHAR(20)
          l_str       LIKE type_file.chr1000,      #NO FUN-690009   VARCHAR(200)
          l_success   LIKE type_file.chr1,         #NO FUN-690009   VARCHAR(01)
          l_n         LIKE type_file.num5          #NO FUN-690009   SMALLINT
 
  LET l_str = 'test -f ',p_filename CLIPPED
  RUN l_str RETURNING l_n
  #MESSAGE l_n
  IF l_n THEN
     LET l_success = 'N'
  ELSE
     LET l_success = 'Y'
  END IF
  IF INT_FLAG THEN LET INT_FLAG = 0 LET l_success = 'N' END IF
  RETURN l_success
END FUNCTION
#Patch....NO.TQC-610037 <001> #
