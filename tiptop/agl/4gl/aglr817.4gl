# Prog. Version..: '5.30.06-13.03.19(00009)'     #
# Pattern name...: aglr817.4gl
# Descriptions...: 傳票拋轉檢核報表
# Date & Author..: No:FUN-BC0012 12/01/11 By Lori
# Modify.........: No:MOD-BC0111 12/01/13 By Lori 不論立沖帳,皆可產出差異報表
# Modify.........: No:FUN-BC0087 12/01/13 By Lori 取tag_file時須加入tagacti(有效否欄位)做為條件過濾資料
# Modify.........: No.CHI-C20023 12/03/12 By Lori 增加tag06(使用時點)的判斷
# Modify.........: No.CHI-C30028 12/05/21 By Lori 原始帳別,拋轉帳別,原始單別加入開窗功能
# Modify.........: No.FUN-BC0091 12/05/29 By Lori 增加"非共用帳本單別，是否檢核未拋轉傳票"勾選項，
#                                                 共用帳本單別，不需check勾選，一律要檢查是否有漏拋，非共用帳本單
# Modify.........: No.TQC-BC0169 12/07/24 By Lori 增加預算控制與專案管理比對
# Modify.........: No.FUN-C40112 12/07/25 By Lori 傳票拋轉紀錄變更為abm_file
# Modify.........: No.FUN-C90042 12/09/10 By Belle 增加傳票拋轉後科餘檢核(依aooi120設定新舊科目)

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE tm         RECORD
                  g_a         LIKE type_file.chr1,   #類型      #FUN-C90042
                  yy          LIKE type_file.num5,   #年度      #FUN-C90042
                  bmm         LIKE type_file.num5,   #月份      #FUN-C90042
                  emm         LIKE type_file.num5,   #月份      #FUN-C90042
                  o_aba00   LIKE aba_file.aba00,   #原始帳別
                  n_aba00   LIKE aba_file.aba00,   #拋轉帳別
                  o_aba01   LIKE aba_file.aba01,   #傳票單別
                  b_aba02   LIKE aba_file.aba02,   #起始傳票日期
                  e_aba02   LIKE aba_file.aba02,   #截止傳票日期
                  b_aba01   LIKE aba_file.aba01,   #起始傳票編號
                  e_aba01   LIKE aba_file.aba01,   #截止傳票編號
                  ck_notxnfer LIKE type_file.chr1,   #非共用單別是否檢查傳票有無漏拋      #FUN-BC0091 add
                  more      LIKE type_file.chr1    #Input more condition(Y/N)
                  END RECORD 
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE li_chk_bookno  LIKE type_file.num5

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql = "order1.type_file.num5,",
               "aba00o.aba_file.aba00,",   #來源帳別
               "aba00n.aba_file.aba00,",   #拋轉帳別
               "aba01.aba_file.aba01,",    #傳票編號
               "aba02.aba_file.aba02,",    #傳票日期
               "abb07.abb_file.abb07,",　  #金額
               "abb07f.abb_file.abb07f,",  #金額
               "azi04.azi_file.azi04,",    #幣別取位
               "aag01.aag_file.aag01,",    #科目代號
               "aag02.aag_file.aag02,",    #科目名稱
               "msg0.type_file.chr100"     #訊息代號
              #"msg1.type_file.chr100,",   #訊息代號        #FUN-C90042 mark
              #"msg2.type_file.chr100"     #訊息代號        #FUN-C90042 mark
              ,",aag011.aag_file.aag01"    #拋轉科目代號     #FUN-C90042
              ,",aag021.aag_file.aag02"    #拋轉科目名稱     #FUN-C90042
              ,",abb071.abb_file.abb07"    #拋轉本幣金額     #FUN-C90042
   LET l_table = cl_prt_temptable('aglr817',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?,?)"      #FUN-C90042
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           

  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)
   LET tm.o_aba00 = ARG_VAL(11)
   LET tm.n_aba00 = ARG_VAL(12)
   LET tm.o_aba01 = ARG_VAL(13)
   LET tm.b_aba02 = ARG_VAL(14)
   LET tm.e_aba02 = ARG_VAL(15)
   LET tm.b_aba01 = ARG_VAL(16)
   LET tm.e_aba01 = ARG_VAL(17)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r817_tm()
   ELSE
      CALL r817()
   END IF
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r817_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1,
          l_cmd          LIKE type_file.chr1000,
          g_cnt          LIKE type_file.num5
   DEFINE l_aaa13        LIKE aaa_file.aaa13

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r817_w AT p_row,p_col WITH FORM "agl/42f/aglr817" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL

   LET tm.ck_notxnfer = 'N'    #FUN-BC0091 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_sw = 1

      INPUT BY NAME tm.g_a,tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.yy,tm.bmm       #FUN-C90042
                   ,tm.emm,tm.b_aba02,tm.e_aba02                               #FUN-C90042 
                   ,tm.b_aba01,tm.e_aba01,tm.ck_notxnfer,tm.more               #FUN-BC0091 add tm.ck_notxnfer
            WITHOUT DEFAULTS  

         BEFORE INPUT
            CALL cl_qbe_init()
           #FUN-C90042--B--
            LET tm.g_a = 1
            CALL r817_set_entry()
            CALL r817_set_no_entry()
           #FUN-C90042--E--

        #FUN-C90042--B--
         ON CHANGE g_a
            CALL r817_set_entry()
            CALL r817_set_no_entry()
            IF tm.g_a = 1 THEN
               LET tm.o_aba01 = ""
               LET tm.b_aba02 = ""
               LET tm.e_aba02 = ""
               LET tm.b_aba01 = ""
               LET tm.e_aba01 = ""
               LET tm.ck_notxnfer = 'N'
               DISPLAY tm.o_aba01,tm.b_aba02,tm.e_aba02,tm.b_aba01,tm.e_aba01,tm.ck_notxnfer
                    TO o_aba01,b_aba02,e_aba02,b_aba01,e_aba01,ck_notxnfer
            ELSE
               LET tm.yy = ""
               LET tm.bmm =""
               LET tm.emm =""
               DISPLAY tm.yy,tm.bmm,tm.emm TO yy,bmm,emm
            END IF
	     #FUN-C90042--E--
         #CHI-C30028-add begin---
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(o_aba00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.o_aba00
                  CALL cl_create_qry() RETURNING tm.o_aba00
                  DISPLAY BY NAME tm.o_aba00
                  NEXT FIELD o_aba00
               WHEN INFIELD(n_aba00) #帳別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.n_aba00
                  CALL cl_create_qry() RETURNING tm.n_aba00
                  DISPLAY BY NAME tm.n_aba00
                  NEXT FIELD n_aba00
               WHEN INFIELD(o_aba01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aac1'
                  LET g_qryparam.default1 = tm.o_aba01
                  CALL cl_create_qry() RETURNING tm.o_aba01
                  DISPLAY BY NAME tm.o_aba01
                  NEXT FIELD o_aba01
            END CASE
         #CHI-C30028-add end-----
         #FUN-C90042--B--
         AFTER FIELD yy
            IF tm.yy < 1000 OR tm.yy > 2100 THEN
               CALL cl_err('','afa-370',0)   #年度資料錯誤
               NEXT FIELD yy
            END IF

         AFTER FIELD bmm
            IF NOT cl_null(tm.bmm) THEN
               IF tm.bmm < 0 OR tm.bmm >13 THEN
                  CALL cl_err('','afa-371',0)
                  NEXT FIELD bmm
               END IF
            END IF
            IF NOT cl_null(tm.bmm) AND cl_null(tm.emm) THEN
               LET tm.emm = tm.bmm
            END IF
            IF NOT cl_null(tm.bmm) AND NOT cl_null(tm.emm) THEN
               IF tm.emm < tm.bmm THEN
                  CALL cl_err('','afa-371',0)
                  NEXT FIELD bmm
               END IF
            END IF

         AFTER FIELD emm
            IF NOT cl_null(tm.emm) THEN
               IF tm.emm < 1 OR tm.emm >13 THEN
                  CALL cl_err('','afa-371',0)
                  NEXT FIELD emm
               END IF
            END IF
            IF NOT cl_null(tm.bmm) AND NOT cl_null(tm.emm) THEN
               IF tm.emm < tm.bmm THEN
                  CALL cl_err('','afa-371',0)
                  NEXT FIELD bmm
               END IF
            END IF
        #FUN-C90042--E--
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT

         AFTER FIELD o_aba00         #原始帳別
            IF cl_null(tm.o_aba00) THEN
               NEXT FIELD CURRENT
            ELSE
               CALL s_check_bookno(tm.o_aba00,g_user,g_plant)
                  RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD CURRENT
               END IF
               SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=tm.o_aba00
               IF g_cnt =0 THEN
                  CALL cl_err('','anm-062',0)
                  NEXT FIELD CURRENT
               END IF
            END IF

         AFTER FIELD n_aba00         #拋轉帳別
            IF cl_null(tm.n_aba00) OR tm.n_aba00=tm.o_aba00 THEN
               CALL cl_err('','agl-515',0)
               NEXT FIELD CURRENT
            END IF
    
            CALL s_check_bookno(tm.n_aba00,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD CURRENT
            END IF
    
            LET g_cnt = 0
            LET l_aaa13 = NULL
            SELECT aaa13,COUNT(*) INTO l_aaa13,g_cnt FROM aaa_file
             WHERE aaa01=tm.n_aba00
             GROUP BY aaa13
            IF g_cnt =0 THEN
               CALL cl_err('','anm-062',0)
               NEXT FIELD CURRENT
            END IF

         AFTER FIELD o_aba01
            IF cl_null(tm.o_aba01) THEN
               NEXT FIELD CURRENT
            END IF
            IF tm.o_aba01 <> '*' THEN
               SELECT COUNT(*) INTO g_cnt FROM aac_file WHERE aac01=tm.o_aba01
               IF g_cnt =0 THEN
                  CALL cl_err(tm.o_aba01,"agl-163",0)    #FUN-C90042
                  NEXT FIELD o_aba01
               END IF
            END IF

         AFTER FIELD e_aba02
            IF NOT cl_null(tm.e_aba02) THEN
               IF tm.b_aba02 > tm.e_aba02 THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

         AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(tm.b_aba02) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.b_aba02
              #CALL cl_err('',9033,0)          #FUN-BC0091 mark
            END IF
            IF cl_null(tm.e_aba02) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.e_aba02
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r008_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
            
      END IF

      IF tm.more = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr817'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr817','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'",
                       " '",tm.o_aba00 CLIPPED, "'",
                       " '",tm.n_aba00 CLIPPED, "'",
                       " '",tm.o_aba01 CLIPPED, "'",
                       " '",tm.b_aba02 CLIPPED, "'",
                       " '",tm.e_aba02 CLIPPED, "'",
                       " '",tm.b_aba01 CLIPPED, "'",
                       " '",tm.e_aba01 CLIPPED, "'"

            CALL cl_cmdat('aglr817',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r817_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
     #FUN-C90042--B--
      IF tm.g_a = 1 THEN
         CALL r817_1()
      ELSE
     #FUN-C90042--E--
         CALL r817()
      END IF           #FUN-C90042
      ERROR ""
   END WHILE
   CLOSE WINDOW r817_w
END FUNCTION

FUNCTION r817()
   DEFINE g_aba     RECORD LIKE aba_file.*
   DEFINE g_abb     RECORD LIKE abb_file.*
   DEFINE g_abm     RECORD LIKE abm_file.*            #FUN-C40112 add
   DEFINE l_sql     LIKE type_file.chr1000,
          i         LIKE type_file.num5,
          j         LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_n1      LIKE type_file.num5,
          l_row     LIKE type_file.num5

   DEFINE l_aag02   LIKE aag_file.aag02,
          l_aag21_o   LIKE aag_file.aag21,              #TQC-BC0169 add
          l_aag21_n   LIKE aag_file.aag21,              #TQC-BC0169 add
          l_aag23_o   LIKE aag_file.aag23,              #TQC-BC0169 add
          l_aag23_n   LIKE aag_file.aag23,              #TQC-BC0169 add
          l_ze02    LIKE ze_file.ze02,　　　　　　　　#語言別
          l_ze03    LIKE ze_file.ze03,　　　　　　　　#訊息內容
          l_abb031  LIKE abb_file.abb03,
          l_abb032  LIKE abb_file.abb03,
          l_abb07   LIKE abb_file.abb07,
          l_abb07f  LIKE abb_file.abb07f,
          o_aaa03   LIKE aaa_file.aaa03,
          l_aaa03   LIKE aaa_file.aaa03,
          l_azi04   LIKE azi_file.azi04,
          l_cur_aba01 LIKE aba_file.aba01               #FUN-BC0091 add
   DEFINE tmp1      DYNAMIC ARRAY OF RECORD
                    aba01  LIKE aba_file.aba01,
                    aba02  LIKE aba_file.aba02,
                    abb07  LIKE abb_file.abb07,
                    abb07f LIKE abb_file.abb07f,
                    azi04  LIKE azi_file.azi04,
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                   #msg0   LIKE type_file.chr100,       #TQC-BC0169 mark
                   #msg1   LIKE type_file.chr100,       #TQC-BC0169 mark
                   #msg2   LIKE type_file.chr100        #TQC-BC0169 mark
                    msg0   LIKE type_file.chr1000       #TQC-BC0169 aad
                   #msg1   LIKE type_file.chr1000,      #FUN-C90042 mark #TQC-BC0169 aad
                   #msg2   LIKE type_file.chr1000       #FUN-C90042 mark #TQC-BC0169 aad
                    END RECORD

   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

#FUN-BC0091-mark begin---
# #aba_file(會計傳票單頭檔)
#  IF tm.o_aba01 = '*' THEN
#     LET l_sql = "SELECT aba_file.* FROM aba_file,aac_file",
#                 " WHERE aba00='",tm.o_aba00,"'",                  #帳別
#                 "   AND aba01[1,",g_doc_len,"]= aac01", 
#                 "   AND aac16 = 'Y'"                    
#  ELSE
#     LET l_sql = "SELECT aba_file.* FROM aba_file,aac_file",
#                " WHERE aba00='",tm.o_aba00,"'",                   #帳別
#                "   AND aba01[1,",g_doc_len,"]='",tm.o_aba01,"'",  #單別
#                "   AND aba01[1,",g_doc_len,"]= aac01", 
#                "   AND aac16 = 'Y'"                    
#  END IF
# #傳票日期
#  IF tm.b_aba02 IS NOT NULL THEN
#     LET l_sql = l_sql CLIPPED," AND aba02  >= '",tm.b_aba02,"'"
#  END IF
#  IF tm.e_aba02 IS NOT NULL THEN
#     LET l_sql = l_sql CLIPPED," AND aba02  <= '",tm.e_aba02,"'"
#  END IF
#  LET l_sql = l_sql CLIPPED," ORDER BY aba01"

#  PREPARE r817_p1 FROM l_sql
#  DECLARE r817_c1 CURSOR WITH HOLD FOR r817_p1

#  LET j = 0
#  FOREACH r817_c1 INTO g_aba.*
#     LET j = j+1
#     LET l_row = 0
#     CALL tmp1.clear()
#    #檢核拋轉帳中，是否有存在傳票
#     LET l_n = 0
#     SELECT COUNT(*) INTO l_n FROM aba_file
#      WHERE aba00 = tm.n_aba00
#        AND aba01 = g_aba.aba01

#     LET l_sql = " SELECT ze02,ze03 FROM ze_file"
#                ,"  WHERE ze01 = 'agl1017'"
#                ,"  ORDER BY ze02"
#     PREPARE r817_p_1017 FROM l_sql
#     DECLARE r817_c_1017 CURSOR FOR r817_p_1017
#     IF l_n = 0 THEN
#        LET l_row=l_row+1
#        LET tmp1[l_row].aba01 = g_aba.aba01
#        LET tmp1[l_row].aba02 = g_aba.aba02
#        FOREACH r817_c_1017 INTO l_ze02,l_ze03
#           CASE l_ze02
#              WHEN "0"
#                 LET tmp1[l_row].msg0 = l_ze03
#              WHEN "1"
#                 LET tmp1[l_row].msg1 = l_ze03
#              WHEN "2"
#                 LET tmp1[l_row].msg2 = l_ze03
#           END CASE
#        END FOREACH
#     END IF
#     FOR i=1 TO l_row
#        EXECUTE insert_prep USING
#                j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
#               ,tmp1[i].abb07,tmp1[i].abb07f,tmp1[i].azi04,tmp1[i].aag01,tmp1[i].aag02
#               ,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2
#     END FOR
#  END FOREACH

# #abb_fie(會計傳票單身檔)
#  IF tm.o_aba01 = '*' THEN
#     LET l_sql = "SELECT aba_file.*,abb_file.* FROM aba_file,abb_file,aac_file",
#                 " WHERE aba00 = abb00 ",
#                 "   AND aba01 = abb01",
#                 "   AND aba00='",tm.o_aba00,"'",                    #帳別
#                 "   AND aba01[1,",g_doc_len,"]= aac01",
#                 "   AND abb01[1,",g_doc_len,"]= aac01",
#                 "   AND aac16 = 'Y'",                               
#                 "   AND aba19 = 'Y'",
#                 "   AND aba16 IS NOT NULL"
#                 
#  ELSE
#     LET l_sql = "SELECT aba_file.*,abb_file.* FROM aba_file,abb_file,aac_file",
#                 " WHERE aba00 = abb00 ",
#                 "   AND aba01 = abb01",
#                 "   AND aba00='",tm.o_aba00,"'",                    #帳別
#                 "   AND aba01[1,",g_doc_len,"]='",tm.o_aba01,"'",   #單別
#                 "   AND aba01[1,",g_doc_len,"]= aac01",
#                 "   AND abb01[1,",g_doc_len,"]= aac01",
#                 "   AND aac16 = 'Y'",                              
#                 "   AND aba19 = 'Y'",
#                 "   AND aba16 IS NOT NULL"
#                 
#  END IF
#FUN-BC0091-mark end-----

  #FUN-BC0091-add begin---
   #FUN-C40112 mark begin---
   #LET l_sql = "SELECT aba_file.*,abb_file.* FROM aba_file,abb_file,aac_file",
   #         " WHERE aba00 = abb00 ",
   #         "   AND aba01 = abb01",
   #         "   AND aba01[1,",g_doc_len,"]= aac01",
   #         "   AND aba00='",tm.o_aba00,"'",                           #帳別
   #         "   AND aba19 = 'Y'",
   #         "   AND aba16 IS NOT NULL"
   #FUN-C40112 mark end-----
   
   #FUN-C40112 add begin---
   LET l_sql = "SELECT aba_file.*,abb_file.*,abm_file.* FROM aba_file,abm_file,abb_file,aac_file",
               " WHERE aba00 = abm02 AND aba01 = abm03",
               "   AND aba00 = abb00 AND aba01 = abb01",
               "   AND aba01[1,",g_doc_len,"]= aac01",
               "   AND aba00 ='",tm.o_aba00,"'",
               "   AND abm05 ='",tm.n_aba00,"'",
               "   AND aba19 = 'Y'"   
   #FUN-C40112 add end-----

   IF tm.o_aba01 <> '*' THEN
      LET l_sql = l_sql  CLIPPED,"   AND aac01 ='",tm.o_aba01,"'"   #單別
   END IF

   IF tm.ck_notxnfer = 'N' THEN
      LET l_sql = l_sql  CLIPPED,"   AND aac16 = 'Y'"
   END IF

  #FUN-BC0091-add end-----
  #傳票日期
   IF tm.b_aba02 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND aba02  >= '",tm.b_aba02,"'"
   END IF
   IF tm.e_aba02 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND aba02  <= '",tm.e_aba02,"'"
   END IF
  #起始傳票編號
   IF tm.b_aba01 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND aba01>= '",tm.b_aba01,"'"
   END IF
  #截止傳票編號
   IF tm.e_aba01 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND aba01<= '",tm.e_aba01,"'"
   END IF

   LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb02"

   PREPARE r817_p2 FROM l_sql
   DECLARE r817_c2 CURSOR WITH HOLD FOR r817_p2

   LET j = 0                    #FUN-BC0091 add

   FOREACH r817_c2 INTO g_aba.*,g_abb.*,g_abm.*    #FUN-C40112 add g_abm.*
      LET l_n = 0               #FUN-BC0091 add
      LET j = j+1
      LET l_row = 0
      LET l_cur_aba01 = null    #FUN-BC0091 add

      CALL tmp1.clear()

     #FUN-BC0091-add begin---
      #檢核拋轉帳中，是否有存在傳票
       IF cl_null(l_cur_aba01) OR l_cur_aba01 <> g_aba.aba01 THEN
          LET l_cur_aba01 = g_aba.aba01

          SELECT COUNT(*) INTO l_n FROM aba_file
           WHERE aba00 = tm.n_aba00
             AND aba01 = g_aba.aba01
         #FUN-C90042--Begin Mark--
         #LET l_sql = " SELECT ze02,ze03 FROM ze_file"
         #           ,"  WHERE ze01 = 'agl1017'"
         #           ,"  ORDER BY ze02"
         #PREPARE r817_p_1017 FROM l_sql
         #DECLARE r817_c_1017 CURSOR FOR r817_p_1017
         #FUN-C90042---End Mark---
          IF l_n = 0 THEN
             LET l_row=l_row+1
             LET tmp1[l_row].aba01 = g_aba.aba01
             LET tmp1[l_row].aba02 = g_aba.aba02
             CALL cl_getmsg('agl1017',g_lang) RETURNING l_ze03   #FUN-C90042
             LET tmp1[l_row].msg0 = l_ze03                       #FUN-C90042
            #FUN-C90042--Begin Mark--
            #FOREACH r817_c_1017 INTO l_ze02,l_ze03
            #   CASE l_ze02
            #      WHEN "0"
            #         LET tmp1[l_row].msg0 = l_ze03
            #      WHEN "1"
            #         LET tmp1[l_row].msg1 = l_ze03
            #      WHEN "2"
            #         LET tmp1[l_row].msg2 = l_ze03
            #   END CASE
            #END FOREACH
            #FUN-C90042---End Mark---
          END IF
          FOR i=1 TO l_row
             EXECUTE insert_prep USING
                     j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
                    ,tmp1[i].abb07,tmp1[i].abb07f,tmp1[i].azi04,tmp1[i].aag01,tmp1[i].aag02
                   #,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2          #FUN-C90042 mark
                    ,tmp1[i].msg0,"","",""                           #FUN-C90042
          END FOR
      END IF
     #FUN-BC0091-add end-----

     #以來源帳別科目名稱顯示
      SELECT aag02,aag21,aag23 INTO l_aag02,l_aag21_o,l_aag23_o         #TQC-BC0169 add l_aag21,l_aag23
        FROM aag_file
       WHERE aag00   = tm.o_aba00              #帳別
         AND aag01   = g_abb.abb03             #單身科目
         AND aagacti = 'Y'

     IF cl_null(l_aag21_o) THEN LET l_aag21_o = 'N' END IF              #TQC-BC0169 add
     IF cl_null(l_aag23_o) THEN LET l_aag23_o = 'N' END IF              #TQC-BC0169 add

     #原始帳別轉換後的會計科目
      LET l_abb031 = " "
      SELECT tag05 INTO l_abb031 FROM tag_file
       WHERE tag01 = YEAR(g_aba.aba02) AND tag02 = g_aba.aba00
         AND tag03 = g_abb.abb03
         AND tagacti = 'Y'                     #FUN-BC0087
         AND tag06 = '1'                       #CHI-C20023
      IF cl_null(l_abb031) THEN
         LET l_abb031 = g_abb.abb03
      END IF
     #拋轉帳別科目與金額
      SELECT abb03,abb07,abb07f
        INTO l_abb032,l_abb07,l_abb07f
        FROM abb_file
      #WHERE abb00 = g_aba.aba16          #FUN-C40112 Mark
      #  AND abb01 = g_aba.aba17          #FUN-C40112 Mark
       WHERE abb00 = g_abm.abm05          #FUN-C40112 Add
         AND abb01 = g_abm.abm06          #FUN-C40112 Add
         AND abb02 = g_abb.abb02

     #TQC-BC0169 add begin---
     SELECT aag21,aag23 INTO l_aag21_n,l_aag23_n
       FROM aag_file
      WHERE aag00 = tm.n_aba00
        AND aag01 = l_abb032
        AND aagacti = 'Y'

     IF cl_null(l_aag21_n) THEN LET l_aag21_n = 'N' END IF
     IF cl_null(l_aag23_n) THEN LET l_aag23_n = 'N' END IF
     #TQC-BC0169 add end-----

     #科目
      IF(l_abb031 <> l_abb032) THEN
         LET l_row=l_row+1
         LET tmp1[l_row].aba01 = g_abb.abb01
         LET tmp1[l_row].aba02 = g_aba.aba02
         LET tmp1[l_row].aag01 = g_abb.abb03
         LET tmp1[l_row].aag02 = l_aag02
         CALL cl_getmsg('agl1018',g_lang) RETURNING l_ze03   #FUN-C90042
         LET tmp1[l_row].msg0 = l_ze03                       #FUN-C90042
        #FUN-C90042--Begin Mark--
        #LET l_sql = " SELECT ze02,ze03 FROM ze_file"
        #           ,"  WHERE ze01 = 'agl1018'"
        #           ,"  ORDER BY ze02"
        #PREPARE r817_p_1018 FROM l_sql
        #DECLARE r817_c_1018 CURSOR FOR r817_p_1018
        #FOREACH r817_c_1018 INTO l_ze02,l_ze03
        #   CASE l_ze02
        #      WHEN "0"
        #         LET tmp1[l_row].msg0 = l_ze03
        #      WHEN "1"
        #         LET tmp1[l_row].msg1 = l_ze03
        #      WHEN "2"
        #         LET tmp1[l_row].msg2 = l_ze03
        #   END CASE
        #END FOREACH
        #FUN-C90042--Begin Mark--
      END IF
      
      SELECT aaa03 INTO o_aaa03 FROM aaa_file WHERE aaa01 = tm.o_aba00
      SELECT aaa03 INTO l_aaa03 FROM aaa_file WHERE aaa01 = tm.n_aba00
     #來源帳別幣別與目地帳別幣別相同時,傳票本幣金額不需重算
      IF o_aaa03 <> l_aaa03 THEN
         CALL s_newrate(tm.o_aba00,tm.n_aba00,g_abb.abb24,g_abb.abb25,g_aba.aba02)
             RETURNING g_abb.abb25
         LET g_abb.abb07 = g_abb.abb25 * g_abb.abb07f
      END IF
     #小數取位
      SELECT azi04 INTO l_azi04 FROM azi_file
       WHERE azi01 = l_aaa03
      LET l_abb07 =cl_digcut(l_abb07,l_azi04)
      LET g_abb.abb07 =cl_digcut(g_abb.abb07,l_azi04)
     #金額比對
      IF l_abb07 <> g_abb.abb07 THEN
         LET l_row=l_row+1
         LET tmp1[l_row].aba01 = g_abb.abb01
         LET tmp1[l_row].aba02 = g_aba.aba02
         LET tmp1[l_row].aag01 = g_abb.abb03
         LET tmp1[l_row].aag02 = l_aag02
         LET tmp1[l_row].azi04 = l_azi04
         LET tmp1[l_row].abb07 = l_abb07                     #FUN-C90042
        #LET tmp1[l_row].abb07 = g_abb.abb07                 #FUN-C90042 mark
         LET tmp1[l_row].abb07f = g_abb.abb07f
         CALL cl_getmsg('agl1019',g_lang) RETURNING l_ze03   #FUN-C90042
         LET tmp1[l_row].msg0 = l_ze03                       #FUN-C90042
        #FUN-C90042--Begin Mark--
        #LET l_sql = " SELECT ze02,ze03 FROM ze_file"
        #           ,"  WHERE ze01 = 'agl1019'"
        #           ,"  ORDER BY ze02"
        #PREPARE r817_p_1019 FROM l_sql
        #DECLARE r817_c_1019 CURSOR FOR r817_p_1019
        #FOREACH r817_c_1019 INTO l_ze02,l_ze03
        #   CASE l_ze02
        #      WHEN "0"
        #         LET tmp1[l_row].msg0 = l_ze03
        #      WHEN "1"
        #         LET tmp1[l_row].msg1 = l_ze03
        #      WHEN "2"
        #         LET tmp1[l_row].msg2 = l_ze03
        #   END CASE
        #END FOREACH
        #FUN-C90042---End Mark---
      END IF

      FOR i=1 TO l_row
         EXECUTE insert_prep USING
                 j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
                ,tmp1[i].abb07,tmp1[i].abb07f,tmp1[i].azi04,tmp1[i].aag01,tmp1[i].aag02
               #,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2          #FUN-C90042 mark
                ,tmp1[i].msg0,"","",""                           #FUN-C90042
      END FOR

      #TQC-BC0169 add begin---
      #預算控制比對
      LET l_row = 0
      IF l_aag21_o <> l_aag21_n THEN
         LET l_row=l_row+1
         LET tmp1[l_row].aba01 = g_abb.abb01
         LET tmp1[l_row].aba02 = g_aba.aba02
         LET tmp1[l_row].aag01 = g_abb.abb03
         LET tmp1[l_row].aag02 = l_aag02
         LET tmp1[l_row].azi04 = l_azi04
         LET tmp1[l_row].abb07 = l_abb07
         LET tmp1[l_row].abb07f = g_abb.abb07f
         CALL cl_getmsg('agl1024',g_lang) RETURNING l_ze03   #FUN-C90042
         LET tmp1[l_row].msg0 = l_ze03                       #FUN-C90042
        #FUN-C90042--Begin Mark--
        #LET l_sql = " SELECT ze02,ze03 FROM ze_file",
        #            "  WHERE ze01 = 'agl1024'",
        #            "  ORDER BY ze02"
        #PREPARE r817_p_1024 FROM l_sql
        #DECLARE r817_c_1024 CURSOR FOR r817_p_1024
        #FOREACH r817_c_1024 INTO l_ze02,l_ze03
        #   CASE l_ze02
        #      WHEN "0"
        #         LET tmp1[l_row].msg0 = l_ze03
        #      WHEN "1"
        #         LET tmp1[l_row].msg1 = l_ze03
        #      WHEN "2"
        #         LET tmp1[l_row].msg2 = l_ze03
        #   END CASE
        #END FOREACH
        #FUN-C90042---End Mark---
         FOR i=1 TO l_row
            EXECUTE insert_prep USING
                    j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
                  #,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2          #FUN-C90042 mark
                   ,tmp1[i].msg0,"","",""                           #FUN-C90042
         END FOR
      END IF

      #專案管理比對
      LET l_row = 0
      IF l_aag23_o <> l_aag23_n THEN
         LET l_row=l_row+1
         LET tmp1[l_row].aba01 = g_abb.abb01
         LET tmp1[l_row].aba02 = g_aba.aba02
         LET tmp1[l_row].aag01 = g_abb.abb03
         LET tmp1[l_row].aag02 = l_aag02
         LET tmp1[l_row].azi04 = l_azi04
         LET tmp1[l_row].abb07 = l_abb07
         LET tmp1[l_row].abb07f = g_abb.abb07f
         CALL cl_getmsg('agl1025',g_lang) RETURNING l_ze03   #FUN-C90042
         LET tmp1[l_row].msg0 = l_ze03                       #FUN-C90042
        #FUN-C90042--Begin Mark--
        #LET l_sql = " SELECT ze02,ze03 FROM ze_file",
        #            "  WHERE ze01 = 'agl1025'",
        #            "  ORDER BY ze02"
        #PREPARE r817_p_1025 FROM l_sql
        #DECLARE r817_c_1025 CURSOR FOR r817_p_1025
        #FOREACH r817_c_1025 INTO l_ze02,l_ze03
        #   CASE l_ze02
        #      WHEN "0"
        #         LET tmp1[l_row].msg0 = l_ze03
        #      WHEN "1"
        #         LET tmp1[l_row].msg1 = l_ze03
        #      WHEN "2"
        #         LET tmp1[l_row].msg2 = l_ze03
        #   END CASE
        #END FOREACH
        #FUN-C90042---End Mark---
         FOR i=1 TO l_row
            EXECUTE insert_prep USING
                    j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
                   ,tmp1[i].abb07,tmp1[i].abb07f,tmp1[i].azi04,tmp1[i].aag01,tmp1[i].aag02
                  #,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2          #FUN-C90042 mark
                   ,tmp1[i].msg0,"","",""                           #FUN-C90042
         END FOR
      END IF
      #TQC-BC0169 add end-----
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET g_str = ""
   CALL cl_prt_cs3('aglr817','aglr817',g_sql,g_str) 
END FUNCTION
#FUN-C90042--B--
FUNCTION r817_1()
DEFINE l_tag03   LIKE tag_file.tag03
DEFINE l_tag05   LIKE tag_file.tag05
DEFINE l_aah04   LIKE aah_file.aah04
DEFINE l_aah041  LIKE aah_file.aah04
DEFINE l_aah042  LIKE aah_file.aah04
DEFINE l_aag02   LIKE aag_file.aag02
DEFINE l_aag021  LIKE aag_file.aag02
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_msg     LIKE ze_file.ze03

    CALL cl_del_data(l_table)
  #小數取位

   LET g_sql = "SELECT tag03,tag05 FROM tag_file"
              ," WHERE tag06 = '1' AND tagacti = 'Y'"
              ,"   AND tag01 = '",tm.yy,"' AND tag02 = '",tm.o_aba00,"'"
              ,"   AND tag04 = '",tm.n_aba00,"'"
              ," ORDER BY tag05"
   PREPARE r817_tag_p FROM g_sql
   DECLARE r817_tag_c SCROLL CURSOR FOR r817_tag_p
              
  #計算是否有多對一的科目
   LET g_sql = "SELECT COUNT(*) FROM tag_file"
              ," WHERE tag06 = '1' AND tagacti = 'Y'"
              ,"   AND tag01 = '",tm.yy,"' AND tag02 = '",tm.o_aba00,"'"
              ,"   AND tag04 = '",tm.n_aba00,"'"
              ,"   AND tag05 = ?"
   PREPARE r817_1_p1 FROM g_sql
   DECLARE r817_1_c1 SCROLL CURSOR FOR r817_1_p1

   LET g_sql = "SELECT SUM(aah04)-SUM(aah05) FROM aah_file"
              ," WHERE aah00 = ? AND aah01 = ? "
              ,"   AND aah02 = '",tm.yy,"'"
              ,"   AND aah03 BETWEEN '",tm.bmm,"' AND '",tm.emm,"'"
   PREPARE r817_1_p2 FROM g_sql
   DECLARE r817_1_c2 SCROLL CURSOR FOR r817_1_p2
   
   LET g_sql = "SELECT SUM(aah04)-SUM(aah05) FROM aah_file"
              ," WHERE aah00 = ? "
              ,"   AND aah02 = '",tm.yy,"'"
              ,"   AND aah03 BETWEEN '",tm.bmm,"' AND '",tm.emm,"'"
              ,"   AND EXISTS (SELECT tag03 FROM tag_file "
              ,"                WHERE tag03 = aah01"
              ,"                  AND tag01 = '",tm.yy,"' AND tag02 = '",tm.o_aba00,"'"
              ,"                  AND tag04 = '",tm.n_aba00,"' AND tag05 = ?"
              ,"                  AND tag06 = '1' AND tagacti = 'Y')"
   PREPARE r817_1_p3 FROM g_sql
   DECLARE r817_1_c3 SCROLL CURSOR FOR r817_1_p3
   
   FOREACH r817_tag_c INTO l_tag03,l_tag05
      LET l_cnt = 0
      LET l_aah04  = 0
      LET l_aah041 = 0
      LET l_aah042 = 0
   
      OPEN  r817_1_c1 USING l_tag05
      FETCH r817_1_c1 INTO l_cnt
      CLOSE r817_1_c1
      
      OPEN  r817_1_c2 USING tm.o_aba00,l_tag03
      FETCH r817_1_c2 INTO  l_aah04
      IF l_cnt > 1 THEN
         OPEN  r817_1_c3 USING tm.o_aba00,l_tag05
         FETCH r817_1_c3 INTO  l_aah042
      ELSE
         LET l_aah042 = l_aah04
      END IF
      
      OPEN  r817_1_c2 USING tm.n_aba00,l_tag05
      FETCH r817_1_c2 INTO l_aah041
      IF cl_null(l_aah04)  THEN  LET l_aah04  = 0 END IF
      IF cl_null(l_aah041) THEN  LET l_aah041 = 0 END IF
      IF cl_null(l_aah042) THEN  LET l_aah042 = 0 END IF
      
      IF l_aah041 <> l_aah042 THEN
         LET l_aag02  =" "
         LET l_aag021 =" "
         SELECT aag02 INTO l_aag02  FROM aag_file
          WHERE aag00 = tm.o_aba00 AND aag01 = l_tag03
         SELECT aag02 INTO l_aag021 FROM aag_file
          WHERE aag00 = tm.n_aba00 AND aag01 = l_tag05
         CALL cl_getmsg('agl1051',g_lang) RETURNING l_msg

         EXECUTE insert_prep USING
                 "",tm.o_aba00,tm.n_aba00,"",""
                ,l_aah04,"","",l_tag03,l_aag02
                ,l_msg,l_tag05,l_aag021,l_aah041
         
      END IF
   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ""
   CALL cl_prt_cs3('aglr817','aglr817_1',g_sql,g_str)
END FUNCTION
FUNCTION r817_set_entry()
   IF tm.g_a = 1 THEN
      CALL cl_set_comp_entry("yy,bmm,emm",TRUE)
   ELSE
      CALL cl_set_comp_entry("o_aba01,b_aba02,e_aba02,b_aba01,e_aba01,ck_notxnfer",TRUE)
   END IF
END FUNCTION
   
FUNCTION r817_set_no_entry()
   IF tm.g_a = 1 THEN
      CALL cl_set_comp_entry("o_aba01,b_aba02,e_aba02,b_aba01,e_aba01,ck_notxnfer",FALSE)
   ELSE
      CALL cl_set_comp_entry("yy,bmm,emm",FALSE)
   END IF
END FUNCTION
#FUN-C90042--E--
