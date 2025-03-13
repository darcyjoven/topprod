# Prog. Version..: '5.30.06-13.04.12(00010)'     #
#
# Pattern name...: gglr940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 2003/12/08 By Lynn Fu
# Modify.........: No.FUN-510007 05/01/18 By Nicola 報表架構修改
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.TQC-730049 07/03/13 By Smapmin 修改SQL語法
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740053 07/04/12 By Xufeng  (接下頁)/(結束)位置調整
# Modify.........: No.TQC-720034 07/05/17 By Jackho 報表項目打印修正報表項目打印修正
# Modify.........: No.FUN-780031 07/08/29 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-8C0259 09/01/05 By wujie   金額應該根絕借貸做加減，而不是簡單的相加
# Modify.........: No.MOD-920238 09/02/19 By Smapmin 加上azi05
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50151 10/05/26 By Carrier CHI-9A0050追单
# Modify.........: No:TQC-AC0405 10/12/30 By lixh1   增加切換語音別功能
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No:MOD-C60205 12/06/28 By Polly 計算期初現金及約當現金餘額改抓取aah_file
# Modify.........: No:MOD-D40054 13/04/10 By apo 計算期初現金及約當現金餘額的SQL條件應判斷統制/明細別為2(明細),3(獨立)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE tm  RECORD
                 title   LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(20)   #輸入報表名稱
                 y1      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #輸入起始年度
                 m1      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #Begin 期別
                 y2      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #輸入截止年度
                 m2      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #End   期別
                 b       LIKE aaa_file.aaa01,    #帳別
                 c       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #異動額及餘額為0者是否列印
                 d       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #金額單位
                 o       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #轉換幣別否
                 r       LIKE azi_file.azi01,    #總帳幣別
                 p       LIKE azi_file.azi01,    #轉換幣別
                 q       LIKE azj_file.azj03,    #匯率
                 more    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)    #Input more condition(Y/N)
             END RECORD,
             bdate,edate          LIKE type_file.dat,     #NO FUN-690009   DATE
             l_za05               LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
             g_bookno             LIKE aah_file.aah00,    #帳別
             g_unit               LIKE type_file.num10    #NO FUN-690009   INTEGER
    DEFINE   g_i                  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
    DEFINE   g_aaa03              LIKE  aaa_file.aaa03
    DEFINE   g_before_input_done  LIKE type_file.num5     #NO FUN-690009   SMALLINT
    DEFINE   p_cmd                LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
    DEFINE   g_msg                LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(100)
    DEFINE   l_table              STRING  #No.FUN-780031
    DEFINE   g_str                STRING  #No.FUN-780031
    DEFINE   g_sql                STRING  #No.FUN-780031
   #DEFINE   g_init_cash          LIKE aao_file.aao05     #TQC-A50151 #MOD-C60205 mark
    DEFINE   g_init_cash          LIKE aah_file.aah04     #MOD-C60205
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   #No.FUN-780031  --Begin
   LET g_sql = " type.type_file.chr1,", 
               " nml01.nml_file.nml01,",
               " nml02.nml_file.nml02,",
               " nml03.nml_file.nml03,",
               " tia08.tia_file.tia08 "
   LET l_table = cl_prt_temptable('gglr940',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?               ) " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
   LET g_trace = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
  #-----TQC-610056---------
  LET tm.title = ARG_VAL(8)
  LET tm.y1 = ARG_VAL(9)
  LET tm.y2 = ARG_VAL(10)
  LET tm.m1 = ARG_VAL(11)
  LET tm.m2 = ARG_VAL(12)
  LET tm.b = ARG_VAL(13)
  LET tm.c = ARG_VAL(14)
  LET tm.d = ARG_VAL(15)
  LET tm.o = ARG_VAL(16)
  LET tm.r = ARG_VAL(17)
  LET tm.p = ARG_VAL(18)
  LET tm.q = ARG_VAL(19)
  LET g_rep_user = ARG_VAL(20)
  LET g_rep_clas = ARG_VAL(21)
  LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
  #-----END TQC-610056-----
 
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   LET g_rlang  = g_lang
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r940_tm()
   ELSE
      CALL r940()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r940_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_sw           LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)   #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(g_bookno)
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW r940_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr940"  ATTRIBUTE (STYLE = g_win_style CLIPPED)              #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660124
   END IF
 
   LET tm.title = g_x[1]
   LET tm.b = g_bookno
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = tm.r
   LET tm.q = 1
   LET tm.more = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,tm.b,tm.d,tm.c,tm.o,
                    tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()               #No.FUN-550037 hmf
            CALL cl_dynamic_locale()              #TQC-AC0405
 
         BEFORE INPUT
            CALL r940_set_entry(p_cmd)
            CALL r940_set_no_entry(p_cmd)
         #No.FUN-580031 --start--
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
 
         AFTER FIELD y1
            IF NOT cl_null(tm.y1) THEN
               IF tm.y1 = 0 THEN
                  NEXT FIELD y1
               END IF
               LET tm.y2=tm.y1
            END IF
 
         AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#            IF tm.m1 <1 OR tm.m1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD m1
#            END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#            IF tm.m2 <1 OR tm.m2 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD m2
#            END IF
#No.TQC-720032 -- end --
 
 
            IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD m1
            END IF
 
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
               #No.FUN-670004--begin
	            CALL s_check_bookno(tm.b,g_user,g_plant) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF
               #No.FUN-670004--end
 SELECT aaa01 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('','agl-095',0)   #No.FUN-660124
                  CALL cl_err3("sel","aaa_file",tm.b,"","agl-095","","",0)   #No.FUN-660124
                  NEXT FIELD b
               END IF
	    END IF
 
         BEFORE FIELD o
            CALL r940_set_entry(p_cmd)
 
         AFTER FIELD o
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
               DISPLAY BY NAME tm.q,tm.r
            END IF
            CALL r940_set_no_entry(p_cmd)
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.p,'mfg3008',0)   #No.FUN-660124
               CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0)   #No.FUN-660124
               NEXT FIELD p
            END IF
 
         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
 
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
 
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
 
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY tm.p TO p
                  NEXT FIELD p
            END CASE
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
     #-----TQC-610056---------
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='gglr940'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglr940','9031',1)
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.title CLIPPED,"'" ,
                        " '",tm.y1 CLIPPED,"'" ,
                        " '",tm.y2 CLIPPED,"'" ,
                        " '",tm.m1 CLIPPED,"'" ,
                        " '",tm.m2 CLIPPED,"'" ,
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,
                        " '",tm.o CLIPPED,"'" ,
                        " '",tm.r CLIPPED,"'" ,
                        " '",tm.p CLIPPED,"'" ,
                        " '",tm.q CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('gglr940',g_time,l_cmd)    # Execute cmd at later tim
        END IF
        CLOSE WINDOW r940_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     #-----END TQC-610056-----
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r940_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r940()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r940_w
 
END FUNCTION
 
FUNCTION r940()
DEFINE l_name    LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)    # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0097
DEFINE l_chr     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)  # RDSQL STATEMENT
DEFINE sr        RECORD
                    type     LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
                    nml01    LIKE nml_file.nml01,
                    nml02    LIKE nml_file.nml02,
                    nml03    LIKE nml_file.nml03,
                    tia08    LIKE tia_file.tia08
                 END RECORD
DEFINE l_tmp     LIKE type_file.num5     #NO FUN-690009   SMALLINT
DEFINE l_tib08   LIKE tib_file.tib08   #TQC-730049
#No.MOD-8C0259 --begin
DEFINE l_nml03   LIKE nml_file.nml03
#No.MOD-8C0259 --end
 
   #No.FUN-780031  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-780031  --End
 
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr940'
   SELECT zo02 INTO g_company FROM zo_file
    WHERE  zo01 = g_rlang
 
   #No.FUN-780031  --Begin
   SELECT azi04,azi05 INTO t_azi04,t_azi05      #MOD-920238
     FROM azi_file WHERE azi01 = tm.r    #No.CHI-6A0004
 
   IF tm.d != '1' THEN
      LET t_azi04 = 0     #No.CHI-6A0004
      LET t_azi05 = 0
   END IF
   #No.FUN-780031  --End
   DROP TABLE x
#No.MOD-8C0259 --begin
   DROP TABLE y
   SELECT * FROM tia_file
    WHERE tia_file.tia05 = tm.b
      AND tia_file.tia01*13+tia_file.tia02 >= tm.y1*13+tm.m1
      AND tia_file.tia03*13+tia_file.tia04 <= tm.y2*13+tm.m2
      AND tia_file.tia08 > tia_file.tia081
     INTO TEMP y
   UPDATE y SET tia08 =tia08*(-1),tia081 =tia081*(-1) WHERE tia07='2'
#No.MOD-8C0259 --end
 
 LET l_sql = "SELECT nml01 x01,nml02 x02,nml03 x03,SUM(tia08-tia081) x04",
#No.MOD-8C0259 --begin
#                "  FROM nml_file LEFT OUTER JOIN tia_file ON tia09 = nml01 AND tia05 = '",tm.b,"' AND tia01*13+tia02 >= '",tm.y1*13+tm.m1,"' AND tia03*13+tia04 <= '",tm.y2*13+tm.m2,"' AND tia08 > tia081  ",
#No.TQC-A50151  --Begin
#                "  FROM nml_file,y ", 
#                " WHERE y.tia09(+) = nml01",
                 "  FROM nml_file LEFT OUTER JOIN y ON y.tia09 = nml01",
#No.TQC-A50151  --End  
#No.MOD-8C0259 --end
                 " GROUP BY nml01,nml02,nml03",
                 " INTO TEMP x"
               #" UNION ",
               #"SELECT nml01 x01,nml02 x02,nml03 x03,SUM(tib08) x04",
               #"  FROM nml_file,OUTER tib_file",
               #" WHERE tib09 = nml01",
               #"   AND tib03 = '",tm.b,"'",
               #"   AND tib01*13+tib02 >= ",tm.y1*13+tm.m1,
               #"   AND tib01*13+tib02 <= ",tm.y2*13+tm.m2,
               #" GROUP BY 1,2,3",
               #" ORDER BY 1,2,3 INTO TEMP x"
               #-----END TQC-730049-----
 
   PREPARE gglr940_gentemp FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare',STATUS,1)
      RETURN
   END IF
 
   EXECUTE gglr940_gentemp
   IF STATUS THEN
      CALL cl_err('execute',STATUS,1)
      RETURN
   END IF
 
   DECLARE gglr940_curs CURSOR FOR SELECT '',x01,x02,x03,SUM(x04)
                                     FROM x
                                    GROUP BY x01,x02,x03
   IF STATUS THEN
      CALL cl_err('declare',STATUS,0)
      RETURN
   END IF
 
   #No.FUN-780031  --Begin
   #CALL cl_outnam('gglr940') RETURNING l_name
   #START REPORT r940_rep TO l_name
   #LET g_pageno = 0
   #No.FUN-780031  --End
 
   FOREACH gglr940_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #-----TQC-730049---------
      IF sr.tia08 IS NULL THEN LET sr.tia08 = 0 END IF
      LET l_tib08 = 0
#No.MOD-8C0259 --begin
      DROP TABLE z
      SELECT * FROM tib_file
       WHERE tib09 = sr.nml01
         AND tib03 = tm.b
         AND tib01*13+tib02 >= tm.y1*13+tm.m1
         AND tib01*13+tib02 <= tm.y2*13+tm.m2
        INTO TEMP z 
      UPDATE z SET tib08 =tib08*(-1) WHERE tib05 ='2'
#     SELECT SUM(tib08) INTO l_tib08 FROM tib_file
#        WHERE tib09 = sr.nml01
#          AND tib03 = tm.b
#          AND tib01*13+tib02 >= tm.y1*13+tm.m1
#          AND tib01*13+tib02 <= tm.y2*13+tm.m2
      SELECT SUM(tib08) INTO l_tib08 FROM z
         WHERE tib09 = sr.nml01
           AND tib03 = tm.b
           AND tib01*13+tib02 >= tm.y1*13+tm.m1
           AND tib01*13+tib02 <= tm.y2*13+tm.m2
      SELECT nml03 INTO l_nml03 FROM nml_file WHERE nml01 =sr.nml01
      IF l_nml03 MATCHES '*0' THEN 
         LET l_tib08 =l_tib08*(-1) 
         LET sr.tia08 =sr.tia08*(-1)
      END IF
#No.MOD-8C0259 --end
      IF l_tib08 IS NULL THEN LET l_tib08 = 0 END IF
      LET sr.tia08 = sr.tia08 + l_tib08
      #-----END TQC-730049-----
      IF cl_null(sr.tia08) THEN
         LET sr.tia08 = 0
      END IF
 
      LET sr.type = sr.nml03[1,1]
 
      IF tm.c = 'N' AND sr.tia08 = 0 THEN
         CONTINUE FOREACH
      END IF
 
      #No.FUN-780031  --Begin
      #OUTPUT TO REPORT r940_rep(sr.*)
      EXECUTE insert_prep USING sr.*
      #No.FUN-780031  --End
 
   END FOREACH
 
   #No.FUN-780031  --Begin
   #FINISH REPORT r940_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   #IF g_zz05 = 'Y' THEN
   #   CALL cl_wcchp(tm.wc,'apa01,apa21,apa02,apa22,apa05,apa36,apa06')
   #        RETURNING tm.wc
   #   LET g_str = tm.wc
   #END IF
   #TQC-A50151   ---start                                                       
   #计算期初现金及约当现金余额                                                  
   #--------------------------MOD-C60205-------------------(S)
   #----MOD-C60205------mark
   #SELECT SUM(aao05-aao06)
   #  INTO g_init_cash
   #  FROM aao_file,aag_file
   # WHERE aao00=tm.b  AND aag00=tm.b
   #   AND aao03=tm.y1
   #   AND aao04 BETWEEN 0 AND tm.m1-1
   #   AND aao00=aag00 AND aao01=aag01
   #   AND aag19=1
   #----MOD-C60205------mark
    SELECT SUM(aah04 - aah05)
      INTO g_init_cash
      FROM aah_file,aag_file
     WHERE aah00 = tm.b
       AND aag00 = tm.b
       AND aah02 = tm.y1
       AND aah03 BETWEEN 0 AND tm.m1-1
       AND aah00 = aag00
       AND aah01 = aag01
       AND aag19 = 1
       AND aag07 IN('2','3')   #MOD-D40054 add
   #--------------------------MOD-C60205-------------------(E)
    IF cl_null(g_init_cash) THEN                                                
       LET g_init_cash=0                                                        
    END IF                                                                      
   #TQC-A50151   ---end
   LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",tm.q,";",g_unit,";",
               t_azi04,";",t_azi05,";",g_init_cash #TQC-A50151 
   CALL cl_prt_cs3('gglr940','gglr940',g_sql,g_str)
   #No.FUN-780031  --End
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
REPORT r940_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   DEFINE l_amt        LIKE nme_file.nme08
   DEFINE l_amt2       LIKE nme_file.nme08
   DEFINE l_cash       LIKE nme_file.nme08
   DEFINE cash_in      LIKE nme_file.nme08
   DEFINE cash_out     LIKE nme_file.nme08
   DEFINE l_count      LIKE nme_file.nme08
   DEFINE l_count_in   LIKE nme_file.nme08
   DEFINE l_count_out  LIKE nme_file.nme08
   DEFINE p_flag       LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_flag       LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_unit       LIKE zaa_file.zaa08   #NO FUN-690009   VARCHAR(40)
   DEFINE sr RECORD
                type   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(01)
                nml01  LIKE nml_file.nml01,
                nml02  LIKE nml_file.nml02,
                nml03  LIKE nml_file.nml03,
                tia08  LIKE tia_file.tia08
             END RECORD
   DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.type,sr.nml03,sr.nml01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(tm.title))/2)-1,tm.title CLIPPED #No.TQC-6A0094
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT COLUMN ((g_len-FGL_WIDTH(tm.title))/2)-1,tm.title CLIPPED #No.TQC-6A0094
         CASE tm.d
            WHEN '1'
               LET l_unit = g_x[19]
            WHEN '2'
               LET l_unit = g_x[20]
            WHEN '3'
               LET l_unit = g_x[21]
            OTHERWISE
               LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[22] CLIPPED,'     ',g_x[23] CLIPPED,tm.p,
                       g_x[8] CLIPPED,l_unit
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32]
         PRINT g_dash1 CLIPPED
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.type
         CASE sr.type
            WHEN '1'
               PRINT COLUMN g_c[31],g_x[9]
            WHEN '2'
               PRINT COLUMN g_c[31],g_x[11]
            WHEN '3'
               PRINT COLUMN g_c[31],g_x[13]
            WHEN '4'
               PRINT COLUMN g_c[31],g_x[15]
            OTHERWISE
               EXIT CASE
         END CASE
         PRINT g_dash2 CLIPPED
 
      ON EVERY ROW
         LET sr.tia08 = sr.tia08 * tm.q / g_unit
         PRINT COLUMN g_c[31]+5,sr.nml02,
               COLUMN g_c[32],cl_numfor(sr.tia08,32,t_azi04)    #No.CHI-6A0004
         PRINT g_dash2 CLIPPED
 
      AFTER GROUP OF sr.nml03
         LET cash_in = GROUP SUM(sr.tia08) WHERE sr.nml03[2,2] = '0'
         LET cash_out= GROUP SUM(sr.tia08) WHERE sr.nml03[2,2] = '1'
 
         IF cl_null(cash_in) THEN
            LET cash_in = 0
         END IF
 
         IF cl_null(cash_out) THEN
            LET cash_out = 0
         END IF
 
         IF sr.nml03 <> '40' THEN
#No.TQC-720034--begin
          CASE 
            WHEN sr.nml03='1' OR sr.nml03='3'
               PRINT COLUMN g_c[31]+8,g_x[18];
            WHEN sr.nml03='2'
               PRINT COLUMN g_c[31]+8,g_x[17];
            OTHERWISE
               PRINT COLUMN g_c[31]+8,g_x[sr.nml03 MOD 10 + 17];
          END CASE
#            PRINT COLUMN g_c[31]+8,g_x[sr.nml03 MOD 10 + 17];
#No.TQC-720034--end
            IF sr.nml03[2,2] = '0' THEN
               LET cash_in = cash_in * tm.q / g_unit
               PRINT COLUMN g_c[32],cl_numfor(cash_in,32,t_azi04)   #No.CHI-6A0004
               PRINT g_dash2 CLIPPED
            ELSE
               LET cash_out = cash_out * tm.q / g_unit
               PRINT COLUMN g_c[32],cl_numfor(cash_out,32,t_azi04)  #No.CHI-6A0004
               PRINT g_dash2 CLIPPED
            END IF
         END IF
 
      AFTER GROUP OF sr.type
         LET cash_in = GROUP SUM(sr.tia08) WHERE sr.nml03[2,2] = '0'
         LET cash_out= GROUP SUM(sr.tia08) WHERE sr.nml03[2,2] = '1'
 
         IF cl_null(cash_in) THEN
            LET cash_in = 0
         END IF
 
         IF cl_null(cash_out) THEN
            LET cash_out = 0
         END IF
 
         CASE sr.type
            WHEN '1'
               LET l_cash = (cash_in - cash_out) * tm.q / g_unit
               PRINT COLUMN g_c[31]+5,g_x[10],
                     COLUMN g_c[32],cl_numfor(l_cash,32,t_azi04)    #No.CHI-6A0004
               PRINT g_dash2 CLIPPED
               LET cash_in = 0
               LET cash_out = 0
            WHEN '2'
               LET l_cash = (cash_in - cash_out) * tm.q / g_unit
               PRINT COLUMN g_c[31]+5,g_x[12],
                     COLUMN g_c[32],cl_numfor(l_cash,32,t_azi04)    #No.CHI-6A0004
               PRINT g_dash2 CLIPPED
               LET cash_in = 0
               LET cash_out = 0
            WHEN '3'
               LET l_cash = (cash_in - cash_out) * tm.q / g_unit
               PRINT COLUMN g_c[31]+5,g_x[14],
                     COLUMN g_c[32],cl_numfor(l_cash,32,t_azi04)   #No.CHI-6A0004
               PRINT g_dash2 CLIPPED
               LET cash_in = 0
               LET cash_out = 0
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON LAST ROW
         LET l_count_in = SUM(sr.tia08) WHERE sr.nml03[2,2] = '0'
         LET l_count_out= SUM(sr.tia08) WHERE sr.nml03[2,2] = '1'
 
         IF cl_null(l_count_in) THEN
            LET l_count_in = 0
         END IF
 
         IF cl_null(l_count_out) THEN
            LET l_count_out = 0
         END IF
 
         LET l_count = l_count_in - l_count_out
         LET l_last_sw = 'y'
         LET l_count = l_count * tm.q / g_unit
 
         PRINT COLUMN g_c[31],g_x[16],
               COLUMN g_c[32],cl_numfor(l_count,32,t_azi04)     #No.CHI-6A0004
         PRINT g_dash[1,g_len]
        #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[32],g_x[7] CLIPPED  #No.TQC-740053
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED  #No.TQC-740053
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
           #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[32],g_x[6] CLIPPED   #No.TQC-740053
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #No.TQC-740053
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
 
FUNCTION r940_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   CALL cl_set_comp_entry("p,q",TRUE)
 
END FUNCTION
 
FUNCTION r940_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   IF tm.o = 'N' THEN
      CALL cl_set_comp_entry("p,q",FALSE)
   END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <001> #
