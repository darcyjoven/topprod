# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gglq311.4gl
# Descriptions...: 明細(幣別)分類帳
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-8B0042 08/11/13 By douzh 根據幣別查詢明細
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #No.FUN-8B0042
 
DEFINE tm               RECORD                        
                        wc1     STRING,                  
                        wc2     STRING,
                        t       LIKE type_file.chr1,
                        x       LIKE type_file.chr1,
                        n       LIKE type_file.chr1,
                        e       LIKE type_file.chr1,
                        o       LIKE azi_file.azi01,
                        k       LIKE type_file.chr1,
                        more    LIKE type_file.chr1
                        END RECORD,
       yy,mm            LIKE type_file.num10,
       mm1,nn1          LIKE type_file.num10,
       bdate,edate      LIKE type_file.dat,
       l_flag           LIKE type_file.chr1,
       bookno           LIKE aaa_file.aaa01,
       g_cnnt           LIKE type_file.num5
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_i              LIKE type_file.num5
DEFINE l_table          STRING
DEFINE g_str            STRING
DEFINE g_sql            STRING
DEFINE g_rec_b          LIKE type_file.num10
DEFINE g_aea05          LIKE aea_file.aea05
DEFINE g_aag02          LIKE aag_file.aag02
DEFINE g_aba04          LIKE aba_file.aba04
DEFINE g_curr           LIKE abb_file.abb24             #幣別
DEFINE g_abb            DYNAMIC ARRAY OF RECORD
                        aea02      LIKE aea_file.aea02,
                        aea03      LIKE aea_file.aea03,
                        abb04      LIKE abb_file.abb04,
                        abb24      LIKE abb_file.abb24,
                        df         LIKE abb_file.abb07,
                        abb25_d    LIKE abb_file.abb25,
                        d          LIKE abb_file.abb07,
                        cf         LIKE abb_file.abb07,
                        abb25_c    LIKE abb_file.abb25,
                        c          LIKE abb_file.abb07,
                        dc         LIKE type_file.chr10,
                        balf       LIKE abb_file.abb07,
                        abb25_bal  LIKE abb_file.abb25,
                        bal        LIKE abb_file.abb07
                        END RECORD
DEFINE g_pr             RECORD
                        aea05      LIKE aea_file.aea05,
                        aag02      LIKE type_file.chr1000,
                        abb24      LIKE abb_file.abb24,
                        aba04      LIKE aba_file.aba04,
                        type       LIKE type_file.chr1,
                        aea02      LIKE aea_file.aea02,
                        aea03      LIKE aea_file.aea03,
                        aea04      LIKE aea_file.aea04,
                        abb04      LIKE abb_file.abb04,
                        abb06      LIKE abb_file.abb06,
                        abb07      LIKE abb_file.abb07,
                        abb07f     LIKE abb_file.abb07f,
                        d          LIKE abb_file.abb07,
                        df         LIKE abb_file.abb07,
                        abb25_d    LIKE abb_file.abb25,
                        c          LIKE abb_file.abb07,
                        cf         LIKE abb_file.abb07,
                        abb25_c    LIKE abb_file.abb25,
                        dc         LIKE type_file.chr10,
                        bal        LIKE abb_file.abb07,
                        balf       LIKE abb_file.abb07,
                        abb25_bal  LIKE abb_file.abb25,
                        pagenum    LIKE type_file.num5,
                        azi04      LIKE azi_file.azi04,
                        azi05      LIKE azi_file.azi05,
                        azi07      LIKE azi_file.azi07
                        END RECORD
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE mi_no_ask        LIKE type_file.num5
DEFINE l_ac             LIKE type_file.num5
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET bookno     = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)            
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc1     = ARG_VAL(8)
   LET tm.wc2     = ARG_VAL(9)
   LET tm.t       = ARG_VAL(10)
   LET tm.x       = ARG_VAL(11)
   LET tm.n       = ARG_VAL(12)
   LET tm.e       = ARG_VAL(13)
   LET tm.k       = ARG_VAL(15)
   LET bdate      = ARG_VAL(16)
   LET edate      = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)
 
   CALL q311_out_1()
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
 
   OPEN WINDOW q311_w AT 5,10
        WITH FORM "ggl/42f/gglq311" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            
      THEN CALL gglq311_tm()                    
      ELSE CALL gglq311()                  
           CALL gglq311_t()
   END IF
 
   CALL q311_menu()
   DROP TABLE gglq311_tmp;
   CLOSE WINDOW q311_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q311_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q311_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq311_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q311_out_2()
            END IF
         WHEN "drill_down"
            IF cl_chk_act_auth() THEN
               CALL q311_drill_down()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_abb),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_aea05 IS NOT NULL THEN
                  LET g_doc.column1 = "aea05"
                  LET g_doc.value1 = g_aea05
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gglq311_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,
          l_i           LIKE type_file.num5,
          l_cmd            LIKE type_file.chr1000
 
   CALL s_dsmark(bookno)
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW gglq311_w1 AT p_row,p_col
        WITH FORM "ggl/42f/gglr313"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("gglr313")
 
   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  
   LET bdate   = g_today
   LET edate   = g_today
   LET tm.t    = 'N'
   LET tm.x    = 'N'
   LET tm.n    = 'N'
   LET tm.e    = 'N'
   LET tm.k    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc1 ON aag01,abb24
         ON ACTION locale
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
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW gglq311_w1 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      CONSTRUCT BY NAME tm.wc2 ON aba11
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
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW gglq311_w1 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.t,tm.x,tm.n,tm.e,tm.k,tm.more
      INPUT BY NAME bookno,bdate,edate,tm.t,tm.x,tm.n,tm.e,tm.k,tm.more
            WITHOUT DEFAULTS
 
         AFTER FIELD bdate
            IF cl_null(bdate) THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate
            IF cl_null(edate) THEN
               LET edate =g_lastdat
            ELSE
               IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF
            END IF
            IF edate < bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF
 
         AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
 
         AFTER FIELD n
            IF cl_null(tm.n) OR tm.n NOT MATCHES'[YN]' THEN NEXT FIELD n END IF
 
         AFTER FIELD k
            IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]'
            THEN NEXT FIELD k END IF
 
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
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 =bookno
                  CALL cl_create_qry() RETURNING bookno
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
            END CASE
 
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
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW gglq311_w1 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      LET mm1 = MONTH(bdate)
      LET nn1 = MONTH(edate)
 
      SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      
          WHERE zz01='gglq311'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gglq311','9031',1)
         ELSE
            LET tm.wc1=cl_wcsub(tm.wc1)
            LET l_cmd = l_cmd CLIPPED,
                       " '",bookno     CLIPPED,"'",
                       " '",g_pdate    CLIPPED,"'",
                       " '",g_towhom   CLIPPED,"'",
                       " '",g_rlang    CLIPPED,"'",
                       " '",g_bgjob    CLIPPED,"'",
                       " '",g_prtway   CLIPPED,"'",
                       " '",g_copies   CLIPPED,"'",
                       " '",tm.wc1     CLIPPED,"'",
                       " '",tm.wc2     CLIPPED,"'",
                       " '",tm.t       CLIPPED,"'",
                       " '",tm.x       CLIPPED,"'",
                       " '",tm.n       CLIPPED,"'",
                       " '",tm.e       CLIPPED,"'",
                       " '",tm.k       CLIPPED,"'",
                       " '",bdate      CLIPPED,"'",
                       " '",edate      CLIPPED,"'",
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('gglq311',g_time,l_cmd)      
         END IF
         CLOSE WINDOW gglq311_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL gglq311()
      ERROR ""
      EXIT WHILE
   END WHILE
   CLOSE WINDOW gglq311_w1
 
   CALL gglq311_t()
END FUNCTION
 
FUNCTION gglq311()
   DEFINE l_name             LIKE type_file.chr20,
          l_sql,l_sql1       LIKE type_file.chr1000,
          l_aea03            LIKE type_file.chr5,
          l_bal,l_balf       LIKE type_file.num20_6,
          n_bal,n_balf       LIKE type_file.num20_6,
          s_abb07,s_abb07f   LIKE type_file.num20_6,
          l_za05             LIKE type_file.chr1000,
          l_date,l_date1     LIKE aba_file.aba02,
          p_aag02            LIKE type_file.chr1000,
          l_i                LIKE type_file.num5,
          l_credit           LIKE abb_file.abb07,
          l_creditf          LIKE abb_file.abb07f,
          l_debit            LIKE abb_file.abb07,
          l_debitf           LIKE abb_file.abb07f,
          l_aag01_str        LIKE type_file.chr50,
          sr1                RECORD
                             abb24  LIKE abb_file.abb24,
                             aag01  LIKE aag_file.aag01,
                             aag02  LIKE aag_file.aag02,
                             aag13  LIKE aag_file.aag13,
                             aag08  LIKE aag_file.aag08,
                             aag07  LIKE aag_file.aag07,
                             aag24  LIKE aag_file.aag24
                             END RECORD,
          sr                 RECORD
                             aea05  LIKE aea_file.aea05,
                             aea02  LIKE aea_file.aea02,
                             aea03  LIKE aea_file.aea03,
                             aea04  LIKE aea_file.aea04,
                             aba04  LIKE aba_file.aba04,
                             aba02  LIKE aba_file.aba02,
                             abb04  LIKE abb_file.abb04,
                             abb24  LIKE abb_file.abb24,
                             abb25  LIKE abb_file.abb25,
                             abb06  LIKE abb_file.abb06,
                             abb07  LIKE abb_file.abb07,
                             abb07f LIKE abb_file.abb07f,
                             aag02  LIKE type_file.chr1000,
                             aag08  LIKE aag_file.aag08,
                             qcye   LIKE abb_file.abb07,
                             qcyef  LIKE abb_file.abb07,
                             qcydd  LIKE abb_file.abb07,
                             qcyddf LIKE abb_file.abb07,
                             qcydc  LIKE abb_file.abb07,
                             qcydcf LIKE abb_file.abb07
                             END RECORD
  DEFINE l_abb071,l_abb072   LIKE type_file.num20_6
  DEFINE l_tah04,l_tah05     LIKE type_file.num20_6
  DEFINE l_tah09,l_tah10     LIKE type_file.num20_6
  DEFINE t_tah04,t_tah05     LIKE type_file.num20_6
  DEFINE t_tah09,t_tah10     LIKE type_file.num20_6
  DEFINE l_abb07f1,l_abb07f2 LIKE type_file.num20_6
  DEFINE l_year              LIKE type_file.num10
  DEFINE l_month             LIKE type_file.num10
 
 
     LET g_prog = 'gglr313'
     CALL gglq311_table()
 
     LET mm1 = MONTH(bdate)
     LET nn1 = MONTH(edate)
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno
        AND aaf02 = g_lang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     LET l_sql1= "SELECT DISTINCT(abb24),aag01,aag02,aag13,aag08,aag07,aag24 ",
                 "  FROM aag_file,abb_file ",
                 " WHERE aag03 ='2' ",
                 "   AND aag00 = '",bookno,"' ",
                 "   AND aag01 = abb03",
                 "   AND ",tm.wc1 CLIPPED
     PREPARE gglq311_prepare2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq311_curs2 CURSOR FOR gglq311_prepare2
 
     IF tm.k = '3' THEN
        LET l_sql = "SELECT aea05,aea02,aea03,aea04,aba04,",
                    "       aba02,abb04,abb24,abb25,abb06,",
                    "       abb07,abb07f,'','',0,0,0,0,0,0 ",
                    "  FROM aea_file,aba_file,abb_file ",
                    " WHERE aea05 LIKE ? ",
                    "   AND aea00 = '",bookno,"' ",
                    "   AND aea00 = aba00 ",
                    "   AND aba00 = abb00 ",
                    "   AND aba01 = abb01 ",
                    "   AND abb03 = aea05 ",
                    "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
                    "   AND abb01 = aea03 AND abb02 = aea04 ",
                    "   AND aba01 = aea03",
                    "   AND abapost = 'Y' ",
                    "   AND abb24 = ? ",
                    "   AND aba04 = ? ",
                    "   AND ",tm.wc2 CLIPPED
     ELSE
        LET l_sql = "SELECT abb03,aba02,abb01,abb02,aba04,",
                    "       ''   ,abb04,abb24,abb25,abb06,",
                    "       abb07,abb07f,'','',0,0,0,0,0,0 ",
                    "  FROM aba_file,abb_file ",
                    " WHERE abb03 LIKE ? ",
                    "   AND abb00 = '",bookno,"' ",
                    "   AND aba00 = abb00 ",
                    "   AND aba01 = abb01 ",
                    "   AND aba02 BETWEEN '",bdate,"' AND '",edate,"' ",
                    "   AND abaacti='Y' ",
                    "   AND aba19 <> 'X' ",  #CHI-C80041
                    "   AND abb24 = ? ",
                    "   AND aba04 = ? ",
                    "   AND ",tm.wc2 CLIPPED
     END IF
     IF tm.k = '2' THEN
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
     END IF
     IF tm.k = '3' THEN
        LET l_sql = l_sql CLIPPED," ORDER BY aea05,abb24,aba04,aea02,aea03,aea04 "
     ELSE
        LET l_sql = l_sql CLIPPED," ORDER BY abb03,abb24,aba04,aba02,abb01,abb02 "
     END IF
     PREPARE gglq311_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq311_curs1 CURSOR FOR gglq311_prepare1
 
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
                 "   FROM abb_file,aba_file ",
                 "  WHERE abb00 = aba00 ",
                 "    AND abb01 = aba01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ? ",
                 "    AND aba02 < '",bdate,"'",
                 "    AND aba03 = ",yy,
                 "    AND abb06 = ? ",
                 "    AND abapost ='N' ",
                 "    AND aba19 <> 'X' ",  #CHI-C80041
                 "    AND abb24 = ? ",
                 "    AND abaacti ='Y' "
     IF tm.k = '2' THEN
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
     END IF
     PREPARE gglq311_prepareb FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq311_cursb CURSOR FOR gglq311_prepareb
 
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
                 "   FROM abb_file,aba_file ",
                 "  WHERE abb00 = aba00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ? ",
                 "    AND abb24 = ? ",
                 "    AND aba02 >= '",bdate,"' AND aba02 <= '",edate,"'",
                 "    AND aba03 = ",yy,
                 "    AND aba19 <> 'X' ",  #CHI-C80041
                 "    AND abaacti='Y' "
     IF tm.k = '2' THEN
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
     END IF
     IF tm.k = '3' THEN
        LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
     END IF
     PREPARE gglq311_prepared FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglq311_cursd CURSOR FOR gglq311_prepared
 
     CALL cl_outnam('gglr313') RETURNING l_name
     START REPORT gglq311_rep TO l_name
     LET g_pageno = 0
 
     FOREACH gglq311_curs2 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglq311_curs2:',SQLCA.sqlcode,1) 
           EXIT FOREACH
        END IF
        IF tm.x = 'N' AND sr1.aag07 = '3' THEN CONTINUE FOREACH END IF
        IF sr1.aag24 = 1 THEN CONTINUE FOREACH END IF
        #No.FUN-A40020  --Begin                                                 
        #IF sr1.aag24 = 1 THEN CONTINUE FOREACH END IF                          
        IF sr1.aag24 = 1 AND sr1.aag07 = '1' THEN CONTINUE FOREACH END IF       
        #No.FUN-A40020  --End 
 
        LET l_aag01_str = sr1.aag01 CLIPPED,'%'
        CALL gglq311_qcye_qcyd(l_aag01_str,sr1.abb24)
             RETURNING l_bal,l_balf,l_debit,l_debitf,l_credit,l_creditf
        LET n_bal = l_bal
        LET n_balf= l_balf
 
        OPEN gglq311_cursd USING l_aag01_str,sr1.abb24
        FETCH gglq311_cursd INTO s_abb07,s_abb07f
        CLOSE gglq311_cursd
        IF cl_null(s_abb07) THEN LET s_abb07 = 0 END IF
        IF cl_null(s_abb07f) THEN LET s_abb07f = 0 END IF
 
        IF l_bal = 0 AND s_abb07 = 0 AND s_abb07f = 0 THEN CONTINUE FOREACH END IF
 
        FOR l_i = mm1 TO nn1
            LET g_cnt = 0
            LET l_flag='N'
            FOREACH gglq311_curs1 USING l_aag01_str,sr1.abb24,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach gglq311_curs1:',SQLCA.sqlcode,1)  
                  EXIT FOREACH
               END IF
               LET sr.aea05 = sr1.aag01
               LET sr.abb24 = sr1.abb24
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02 = l_date1
               LET l_flag='Y'
               IF tm.e = 'Y' THEN
                  LET sr.aag02=sr1.aag13
               ELSE
                  LET sr.aag02=sr1.aag02
               END IF
               LET sr.aag08=sr1.aag08
               LET sr.qcye  = l_bal
               LET sr.qcyef = l_balf
               LET sr.qcydd = l_debit
               LET sr.qcyddf= l_debitf
               LET sr.qcydc = l_credit
               LET sr.qcydcf= l_creditf
               IF sr1.aag07 = '3' THEN
                  LET sr.aag08 = ''
               ELSE
                  CALL gglq311_sjkm(sr1.aag01,sr1.aag24)
                       RETURNING p_aag02
                  LET sr.aag02 = p_aag02
               END IF
               OUTPUT TO REPORT gglq311_rep(sr.*)
               IF sr.abb06 = "1" THEN
                  LET n_bal = n_bal + sr.abb07
                  LET n_balf = n_balf + sr.abb07f
               ELSE
                  LET n_bal = n_bal - sr.abb07
                  LET n_balf = n_balf - sr.abb07f
               END IF
            END FOREACH
            IF l_flag = "N" AND (n_bal <> 0 OR tm.t = 'Y') THEN
               LET sr.aea05=sr1.aag01
               LET sr.abb24=sr1.abb24
               LET sr.aea02=NULL
               IF tm.e = 'Y' THEN
                  LET sr.aag02=sr1.aag13
               ELSE
                  LET sr.aag02=sr1.aag02
               END IF
               LET sr.aag08= sr1.aag08
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02 = l_date1
               LET sr.qcye  = l_bal
               LET sr.qcyef = l_balf
               LET sr.qcydd = l_debit
               LET sr.qcyddf= l_debitf
               LET sr.qcydc = l_credit
               LET sr.qcydcf= l_creditf
               LET sr.abb25 = 1
               LET sr.aba04 = l_i
               LET sr.abb07=0
               LET sr.abb07f = 0
               IF sr1.aag07 = '3' THEN
                  LET sr.aag08 = ''
               ELSE
                  CALL gglq311_sjkm(sr1.aag01,sr1.aag24)
                       RETURNING p_aag02
                  LET sr.aag02 = p_aag02
               END IF
               LET l_flag = 'Y'
               OUTPUT TO REPORT gglq311_rep(sr.*)
            END IF
        END FOR
     END FOREACH
 
     FINISH REPORT gglq311_rep
 
END FUNCTION
 
FUNCTION gglq311_cs()
     LET g_sql = "SELECT UNIQUE aea05,aag02,abb24,aba04 FROM gglq311_tmp ",
                 " ORDER BY aea05,aag02,abb24,aba04 "
     PREPARE gglq311_ps FROM g_sql
     DECLARE gglq311_curs SCROLL CURSOR WITH HOLD FOR gglq311_ps
 
     LET g_sql = "SELECT UNIQUE aea05,aag02,abb24,aba04 FROM gglq311_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq311_ps1 FROM g_sql
     EXECUTE gglq311_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq311_ps2 FROM g_sql
     DECLARE gglq311_cnt CURSOR FOR gglq311_ps2
 
     OPEN gglq311_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq311_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq311_cnt
        FETCH gglq311_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq311_fetch('F')
     END IF
END FUNCTION
 
FUNCTION gglq311_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq311_curs INTO g_aea05,g_aag02,g_curr,g_aba04
      WHEN 'P' FETCH PREVIOUS gglq311_curs INTO g_aea05,g_aag02,g_curr,g_aba04
      WHEN 'F' FETCH FIRST    gglq311_curs INTO g_aea05,g_aag02,g_curr,g_aba04
      WHEN 'L' FETCH LAST     gglq311_curs INTO g_aea05,g_aag02,g_curr,g_aba04
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about
                   CALL cl_about()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION controlg
                   CALL cl_cmdask()
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump gglq311_curs INTO g_aea05,g_aag02,g_curr,g_aba04
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aea05,SQLCA.sqlcode,0)
      INITIALIZE g_aea05 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_aba04 TO NULL
      INITIALIZE g_curr TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   CALL gglq311_show()
END FUNCTION
 
FUNCTION gglq311_show()
 
   DISPLAY g_aea05 TO aea05
   DISPLAY g_aag02 TO aag02
   DISPLAY yy TO yy
   DISPLAY g_aba04 TO mm
   DISPLAY g_curr TO curr
 
   CALL gglq311_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq311_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
 
   LET g_sql = "SELECT aea02,aea03,abb04,abb24,df,abb25_d,d,",     
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               " FROM gglq311_tmp",
               " WHERE aea05 ='",g_aea05,"'",
               "   AND abb24 ='",g_curr,"'",
               "   AND aba04 = ",g_aba04,
               " ORDER BY type,aea02,aea03,aea04 "
 
   PREPARE gglq311_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq311_pb
 
   CALL g_abb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH abb_curs INTO g_abb[g_cnt].*,t_azi04,t_azi05,t_azi07,l_abb06,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach abb_curs:',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF
      LET g_abb[g_cnt].d        = cl_numfor(g_abb[g_cnt].d,20,g_azi04)
      LET g_abb[g_cnt].c        = cl_numfor(g_abb[g_cnt].c,20,g_azi04)
      LET g_abb[g_cnt].bal      = cl_numfor(g_abb[g_cnt].bal,20,g_azi04)
      LET g_abb[g_cnt].df       = cl_numfor(g_abb[g_cnt].df,20,t_azi04)
      LET g_abb[g_cnt].cf       = cl_numfor(g_abb[g_cnt].cf,20,t_azi04)
      LET g_abb[g_cnt].balf     = cl_numfor(g_abb[g_cnt].balf,20,t_azi04)
      LET g_abb[g_cnt].abb25_d  = cl_numfor(g_abb[g_cnt].abb25_d,20,t_azi07)
      LET g_abb[g_cnt].abb25_c  = cl_numfor(g_abb[g_cnt].abb25_c,20,t_azi07)
      LET g_abb[g_cnt].abb25_bal= cl_numfor(g_abb[g_cnt].abb25_bal,20,t_azi07)
 
      IF l_type = '1' THEN
         LET g_abb[g_cnt].d         = NULL
         LET g_abb[g_cnt].df        = NULL
         LET g_abb[g_cnt].abb25_d   = NULL
         LET g_abb[g_cnt].c         = NULL
         LET g_abb[g_cnt].cf        = NULL
         LET g_abb[g_cnt].abb25_c   = NULL
      END IF
      IF l_abb06 = '1' THEN
         LET g_abb[g_cnt].c       = NULL
         LET g_abb[g_cnt].cf      = NULL
         LET g_abb[g_cnt].abb25_c = NULL
      END IF
      IF l_abb06 = '2' THEN
         LET g_abb[g_cnt].d       = NULL
         LET g_abb[g_cnt].df      = NULL
         LET g_abb[g_cnt].abb25_d = NULL
      END IF
 
      IF tm.n = 'Y' THEN
         IF l_type <> '2' THEN
            LET g_abb[g_cnt].abb24 = NULL
         END IF
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_abb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION gglq311_sjkm(l_aag01,l_aag24)
   DEFINE l_aag24             LIKE aag_file.aag24
   DEFINE l_aag01             LIKE aag_file.aag01
   DEFINE s_aag08             LIKE aag_file.aag08
   DEFINE s_aag24             LIKE aag_file.aag24
   DEFINE s_aag02             LIKE aag_file.aag02
   DEFINE s_aag13             LIKE aag_file.aag13
   DEFINE p_aag02,p_aag021    LIKE type_file.chr1000
   DEFINE l_success,l_i       LIKE type_file.num5
   LET l_success = 1
   LET l_i = 1
   WHILE l_success
   SELECT aag02,aag13,aag08,aag24 INTO s_aag02,s_aag13,s_aag08,s_aag24
     FROM aag_file
    WHERE aag01 = l_aag01
      AND aag00 = bookno
   IF SQLCA.sqlcode THEN
      LET l_success = 0
      EXIT WHILE
   END IF
   IF tm.e = 'Y' THEN LET s_aag02 = s_aag13 END IF
   IF l_i = 1 THEN
      LET p_aag02 = s_aag02
   ELSE
      LET p_aag021 = p_aag02
      LET p_aag02 = s_aag02 CLIPPED,'-',p_aag021 CLIPPED
   END IF
   LET l_i = l_i + 1
   IF s_aag24 = 1 OR s_aag08 = l_aag01 THEN LET l_success = 1 EXIT WHILE END IF
   LET l_aag01 = s_aag08
   LET l_aag24 = l_aag24 - 1
   END WHILE
   RETURN p_aag02
END FUNCTION
 
REPORT gglq311_rep(sr)
   DEFINE
          sr     RECORD
                 aea05  LIKE aea_file.aea05,
                 aea02  LIKE aea_file.aea02,
                 aea03  LIKE aea_file.aea03,
                 aea04  LIKE aea_file.aea04,
                 aba04  LIKE aba_file.aba04,
                 aba02  LIKE aba_file.aba02,
                 abb04  LIKE abb_file.abb04,
                 abb24  LIKE abb_file.abb24,
                 abb25  LIKE abb_file.abb25,
                 abb06  LIKE abb_file.abb06,
                 abb07  LIKE abb_file.abb07,
                 abb07f LIKE abb_file.abb07f,
                 aag02  LIKE type_file.chr1000,
                 aag08  LIKE aag_file.aag08,
                 qcye   LIKE abb_file.abb07,
                 qcyef  LIKE abb_file.abb07,
                 qcydd  LIKE abb_file.abb07,
                 qcyddf LIKE abb_file.abb07,
                 qcydc  LIKE abb_file.abb07,
                 qcydcf LIKE abb_file.abb07
                 END RECORD,
          t_bal,t_balf                 LIKE abb_file.abb07,
          t_debit,t_debitf             LIKE abb_file.abb07,
          t_credit,t_creditf           LIKE abb_file.abb07,
          l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
          n_bal,n_balf                 LIKE type_file.num20_6,
          l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
          l_date2                      LIKE type_file.dat,
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER BY sr.aea05,sr.abb24,sr.aba04,sr.aea02,sr.aea03,sr.aea04
 
  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1
      PRINT
      PRINT
      PRINT
      PRINT
      PRINT
 
   BEFORE GROUP OF sr.aea05
      LET t_bal     = sr.qcye
      LET t_balf    = sr.qcyef
      LET t_debit   = sr.qcydd
      LET t_debitf  = sr.qcyddf
      LET t_credit  = sr.qcydc
      LET t_creditf = sr.qcydcf
      PRINT
 
   BEFORE GROUP OF sr.abb24
      LET t_bal     = sr.qcye
      LET t_balf    = sr.qcyef
      LET t_debit   = sr.qcydd
      LET t_debitf  = sr.qcyddf
      LET t_credit  = sr.qcydc
      LET t_creditf = sr.qcydcf
      PRINT
 
   BEFORE GROUP OF sr.aba04
      IF sr.aba04 = 1 THEN
         LET g_pageno = 0
      ELSE
         SELECT tpg04 INTO g_pageno FROM tpg_file
          WHERE tpg01 = YEAR(bdate)
            AND tpg02 = sr.aba04 - 1
            AND tpg03 = sr.aea05
            AND tpg05 = g_prog
      END IF
      LET g_pageno = g_pageno + 1
      IF sr.aba04 = MONTH(bdate) THEN
         LET l_date2 = bdate
      ELSE
         LET l_date2 = MDY(sr.aba04,1,yy)
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         LET l_dc  = g_x[28]
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            LET l_dc  = g_x[53]
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            LET l_dc = g_x[29]
         END IF
      END IF
 
      LET g_msg = g_x[27]
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      INSERT INTO gglq311_tmp
      VALUES(sr.aea05,sr.aag02,sr.abb24,sr.aba04,'1',l_date2,'','',g_msg,
             '',0,0,0,0,0,0,0,0,l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
   ON EVERY ROW
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         IF LINENO = 34 THEN
            PRINT
            SKIP TO TOP OF PAGE
            PRINT
         END IF
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07) THEN LET sr.abb07 = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            LET l_dc  = g_x[28]
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               LET l_dc  = g_x[53]
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               LET l_dc = g_x[29]
            END IF
         END IF
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df 
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq311_tmp
         VALUES(sr.aea05,sr.aag02,sr.abb24,sr.aba04,'2',sr.aea02,sr.aea03,sr.aea04,sr.abb04,
                sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
         PRINT
      END IF
 
   AFTER GROUP OF sr.aba04
      IF LINENO >=34 THEN
         PRINT
         SKIP TO TOP OF PAGE
         PRINT
      END IF
      CALL s_yp(edate) RETURNING l_year,l_month
      IF sr.aba04 = l_month THEN
         LET sr.aba02 = edate
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         LET l_dc  = g_x[28]
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            LET l_dc  = g_x[53]
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            LET l_dc = g_x[29]
         END IF
      END IF
 
      LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
      LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
      LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
      LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      LET g_msg = g_x[19]
      LET l_abb25_d = l_d / l_df
      LET l_abb25_c = l_c / l_cf
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
      IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
      INSERT INTO gglq311_tmp
      VALUES(sr.aea05,sr.aag02,sr.abb24,sr.aba04,'3',sr.aba02,'','',g_msg,
             '',0,0,l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
 
      LET g_msg = g_x[20]
      LET l_abb25_d = t_debit / t_debitf
      LET l_abb25_c = t_credit / t_creditf
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
      IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
      INSERT INTO gglq311_tmp
      VALUES(sr.aea05,sr.aag02,sr.abb24,sr.aba04,'4',sr.aba02,'','',g_msg,
             '',0,0,
             t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      INSERT INTO tpg_file VALUES(yy,sr.aba04,sr.aea05,g_pageno,g_prog,'','')
#     IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
      IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
         UPDATE tpg_file SET tpg04 = g_pageno
          WHERE tpg01 = yy
            AND tpg02 = sr.aba04
            AND tpg03 = sr.aea05
            AND tpg05 = g_prog
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 1 THEN
            CALL cl_err('update',SQLCA.sqlcode,1)
         END IF
      END IF
      PRINT
      PRINT
 
END REPORT
 
FUNCTION gglq311_qcye_qcyd(p_aea05,p_abb24)
   DEFINE p_aea05                 LIKE type_file.chr50
   DEFINE p_abb24                 LIKE abb_file.abb24
   DEFINE l_d0,l_d1,l_d2,l_d3     LIKE aah_file.aah04
   DEFINE l_c0,l_c1,l_c2,l_c3     LIKE aah_file.aah04
   DEFINE l_df0,l_df1,l_df2,l_df3 LIKE aah_file.aah04
   DEFINE l_cf0,l_cf1,l_cf2,l_cf3 LIKE aah_file.aah04
   DEFINE l_debit,l_debitf        LIKE aah_file.aah04
   DEFINE l_credit,l_creditf      LIKE aah_file.aah04
   DEFINE l_bal,l_balf            LIKE aah_file.aah04
 
   LET l_d0  = 0
   LET l_d1  = 0
   LET l_d2  = 0
   LET l_d3  = 0
   LET l_c0  = 0
   LET l_c1  = 0
   LET l_c2  = 0
   LET l_c3  = 0
   LET l_df0 = 0
   LET l_df1 = 0
   LET l_df2 = 0
   LET l_df3 = 0
   LET l_cf0 = 0
   LET l_cf1 = 0
   LET l_cf2 = 0
   LET l_cf3 = 0
 
   IF tm.n = "N" THEN
      IF g_aaz.aaz51 = 'Y' THEN
         SELECT SUM(tah04),SUM(tah05) INTO l_d0,l_c0 FROM tah_file
          WHERE tah01 LIKE p_aea05 AND tah02 = yy AND tah03 = 0
            AND tah00 = bookno AND tah08 = p_abb24
         SELECT SUM(tas04),SUM(tas05) INTO l_d2,l_c2 FROM tas_file
          WHERE tas00 = bookno AND tas01 LIKE p_aea05
            AND YEAR(tas02) = yy AND tas02 < bdate
            AND tas08 = p_abb24  
      ELSE
         SELECT SUM(tah04),SUM(tah05) INTO l_d0,l_c0 FROM tah_file
          WHERE tah01 LIKE p_aea05 AND tah02 = yy AND tah03 = 0
            AND tah00 = bookno AND tah08 = p_abb24  
 
         SELECT SUM(tah04),SUM(tah05) INTO l_d1,l_c1 FROM tah_file
          WHERE tah01 LIKE p_aea05 AND tah02 = yy AND tah03 < mm
            AND tah03 > 0
            AND tah00 = bookno AND tah08 = p_abb24
 
         SELECT SUM(abb07) INTO l_d2 FROM abb_file,aba_file
          WHERE abb03 LIKE p_aea05 AND aba01 = abb01 AND abb06='1'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = bookno AND abapost='Y'
            AND aba03=yy AND aba04=mm
            AND abb24 = p_abb24
 
         SELECT SUM(abb07) INTO l_c2 FROM aba_file,abb_file
          WHERE abb03 LIKE p_aea05 AND aba01 = abb01 AND abb06='2'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = bookno AND abapost='Y'
            AND aba03=yy AND aba04=mm
            AND abb24 = p_abb24
      END IF
   ELSE
      IF g_aaz.aaz51 = 'Y' THEN
         SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
           INTO l_d0,l_c0,l_df0,l_cf0 FROM tah_file
          WHERE tah01 LIKE p_aea05 AND tah02 = yy AND tah03 = 0
            AND tah00 = bookno AND tah08 = p_abb24
 
         SELECT SUM(tas04),SUM(tas05),SUM(tas09),SUM(tas10)
           INTO l_d2,l_c2,l_df2,l_cf2 FROM tas_file
          WHERE tas00 = bookno AND tas01 LIKE p_aea05
            AND YEAR(tas02) = yy AND tas02 < bdate
            AND tas08 = p_abb24  
 
      ELSE
         SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
           INTO l_d0,l_c0,l_df0,l_cf0 FROM tah_file
          WHERE tah01 LIKE p_aea05 AND tah02 = yy AND tah03 = 0
            AND tah00 = bookno AND tah08 = p_abb24
 
         SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
           INTO l_d1,l_c1,l_df1,l_cf1 FROM tah_file
          WHERE tah01 LIKE p_aea05 AND tah02 = yy AND tah03 < mm
            AND tah03 > 0
            AND tah00 = bookno AND tah08 = p_abb24
 
         SELECT SUM(abb07),SUM(abb07f)
           INTO l_d2,l_df2 FROM abb_file,aba_file
          WHERE abb03 LIKE p_aea05 AND aba01 = abb01 AND abb06='1'
            AND aba02 < bdate   AND abb00 = aba00
            AND aba00 = bookno  AND abapost='Y'
            AND aba03 =yy       AND aba04 = mm
            AND abb24 = p_abb24
 
         SELECT SUM(abb07),SUM(abb07f)
           INTO l_c2,l_cf2 FROM aba_file,abb_file
          WHERE abb03 LIKE p_aea05 AND aba01 = abb01 AND abb06='2'
            AND aba02 < bdate   AND abb00 = aba00
            AND aba00 = bookno  AND abapost='Y'
            AND aba03 = yy      AND aba04 = mm
            AND abb24 = p_abb24
 
      END IF
   END IF
 
   IF tm.k = '1' OR  tm.k = '2' THEN
      OPEN gglq311_cursb USING p_aea05,'1',p_abb24
      FETCH gglq311_cursb INTO l_d3,l_df3
      CLOSE gglq311_cursb
      OPEN gglq311_cursb USING p_aea05,'2',p_abb24
      FETCH gglq311_cursb INTO l_c3,l_cf3
      CLOSE gglq311_cursb
   END IF
 
   IF cl_null(l_d0) THEN LET l_d0 = 0 END IF
   IF cl_null(l_d1) THEN LET l_d1 = 0 END IF
   IF cl_null(l_d2) THEN LET l_d2 = 0 END IF
   IF cl_null(l_d3) THEN LET l_d3 = 0 END IF
   IF cl_null(l_c0) THEN LET l_c0 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   IF cl_null(l_c2) THEN LET l_c2 = 0 END IF
   IF cl_null(l_c3) THEN LET l_c3 = 0 END IF
 
   IF cl_null(l_df0) THEN LET l_df0 = 0 END IF
   IF cl_null(l_df1) THEN LET l_df1 = 0 END IF
   IF cl_null(l_df2) THEN LET l_df2 = 0 END IF
   IF cl_null(l_df3) THEN LET l_df3 = 0 END IF
   IF cl_null(l_cf0) THEN LET l_cf0 = 0 END IF
   IF cl_null(l_cf1) THEN LET l_cf1 = 0 END IF
   IF cl_null(l_cf2) THEN LET l_cf2 = 0 END IF
   IF cl_null(l_cf3) THEN LET l_cf3 = 0 END IF
 
   LET l_debit  = l_d1 + l_d2 + l_d3
   LET l_credit = l_c1 + l_c2 + l_c3
   LET l_debitf = l_df1 + l_df2 + l_df3
   LET l_creditf= l_cf1 + l_cf2 + l_cf3
 
   LET l_bal = l_d0 - l_c0 + l_debit - l_credit
   LET l_balf= l_df0 - l_cf0 + l_debitf - l_creditf
 
   IF cl_null(l_bal)     THEN LET l_bal = 0     END IF
   IF cl_null(l_balf)    THEN LET l_balf = 0    END IF
   IF cl_null(l_debit)   THEN LET l_debit = 0   END IF
   IF cl_null(l_debitf)  THEN LET l_debitf = 0  END IF
   IF cl_null(l_credit)  THEN LET l_credit = 0  END IF
   IF cl_null(l_creditf) THEN LET l_creditf = 0 END IF
   RETURN l_bal,l_balf,l_debit,l_debitf,l_credit,l_creditf
END FUNCTION
 
FUNCTION q311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION drill_down
         LET g_action_choice="drill_down"
         EXIT DISPLAY
 
      ON ACTION first
         CALL gglq311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL gglq311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL gglq311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL gglq311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL gglq311_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q311_out_1()
 
   LET g_prog = 'gglq311'
   LET g_sql = " aea05.aea_file.aea05,",
               " aag02.type_file.chr1000,",
               " abb24.abb_file.abb24,",
               " aba04.aba_file.aba04,",
               " type.type_file.chr1,",
               " aea02.aea_file.aea02,",
               " aea03.aea_file.aea03,",
               " aea04.aea_file.aea04,",
               " abb04.abb_file.abb04,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " d.abb_file.abb07,",
               " df.abb_file.abb07,",
               " abb25_d.abb_file.abb25,",
               " c.abb_file.abb07,",
               " cf.abb_file.abb07,",
               " abb25_c.abb_file.abb25,",
               " dc.type_file.chr10,",
               " bal.abb_file.abb07,",
               " balf.abb_file.abb07,",
               " abb25_bal.abb_file.abb25,",
               " pagenum.type_file.num5,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07 "
 
   LET l_table = cl_prt_temptable('gglq311',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?)             "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION q311_out_2()
   DEFINE l_name              LIKE type_file.chr20
 
   LET g_prog = 'gglq311'
 
   CALL cl_del_data(l_table)
 
   DECLARE gglq311_tmp_curs CURSOR FOR
    SELECT * FROM gglq311_tmp
     ORDER BY aea05,aba04,abb24,aea02,aea03,aea04
   FOREACH gglq311_tmp_curs INTO g_pr.*
      EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",tm.e,";",bdate USING "yyyy/mm/dd" ,";",g_azi04
   IF tm.n = 'N' THEN
       LET l_name = 'gglq311'
   ELSE
       LET l_name = 'gglq311_1'
   END IF
   CALL cl_prt_cs3('gglq311',l_name,g_sql,g_str)
 
END FUNCTION
 
FUNCTION gglq311_table()
     DROP TABLE gglq311_tmp;
     CREATE TEMP TABLE gglq311_tmp(
                    aea05       LIKE aea_file.aea05,
                    aag02       LIKE aag_file.aag02,
                    abb24       LIKE abb_file.abb24,
                    aba04       LIKE aba_file.aba04,
                    type        LIKE type_file.chr1,
                    aea02       LIKE aea_file.aea02,
                    aea03       LIKE aea_file.aea03,
                    aea04       LIKE aea_file.aea04,
                    abb04       LIKE abb_file.abb04,
                    abb06       LIKE abb_file.abb06,
                    abb07       LIKE abb_file.abb07,
                    abb07f      LIKE abb_file.abb07f,
                    d           LIKE abb_file.abb07,
                    df          LIKE abb_file.abb07,
                    abb25_d     LIKE abb_file.abb25,
                    c           LIKE abb_file.abb07,
                    cf          LIKE abb_file.abb07,
                    abb25_c     LIKE abb_file.abb25,
                    dc          LIKE type_file.chr10,
                    bal         LIKE abb_file.abb07,
                    balf        LIKE abb_file.abb07,
                    abb25_bal   LIKE abb_file.abb25,
                    pagenum     LIKE type_file.num5,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi05,
                    azi07       LIKE azi_file.azi07);
 
END FUNCTION
 
FUNCTION gglq311_t()
   IF tm.n = 'Y' THEN
      CALL cl_set_comp_visible("abb24,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",TRUE)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-205",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-206",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("abb24,abb25,df,cf,balf",FALSE)
      CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",FALSE)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
   LET g_aea05 = NULL
   LET g_aag02 = NULL
   CLEAR FORM
   CALL g_abb.clear()
   CALL gglq311_cs()
END FUNCTION
 
FUNCTION q311_drill_down()  
   DEFINE l_wc    LIKE type_file.chr50
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
 
   IF cl_null(g_aea05) THEN RETURN END IF
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_abb[l_ac].aea03) THEN RETURN END IF
   LET g_msg = "aglt110 '",g_abb[l_ac].aea03,"'"
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
#FUN-B80096
