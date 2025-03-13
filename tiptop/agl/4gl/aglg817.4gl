# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aglg817.4gl
# Descriptions...: 傳票拋轉檢核報表
# Date & Author..: No:FUN-BC0012 12/01/11 By Lori
# Modify.........: No:MOD-BC0111 12/01/13 By Lori 不論立沖帳,皆可產出差異報表
# Modify.........: No:FUN-BC0087 12/01/13 By Lori 取tag_file時須加入tagacti(有效否欄位)做為條件過濾資料
# Modify.........: No.CHI-C20023 12/03/12 By Lori 增加tag06(使用時點)的判斷
# Modify.........: No.FUN-C40071 12/04/20 By yangxf 新增GR报表
#                                12/05/24 By yangtt GR程式優化
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE tm         RECORD
                  o_aba00   LIKE aba_file.aba00,   #原始帳別
                  n_aba00   LIKE aba_file.aba00,   #拋轉帳別
                  o_aba01   LIKE aba_file.aba01,   #傳票單別
                  b_aba02   LIKE aba_file.aba02,   #起始傳票日期
                  e_aba02   LIKE aba_file.aba02,   #截止傳票日期
                  b_aba01   LIKE aba_file.aba01,   #起始傳票編號
                  e_aba01   LIKE aba_file.aba01,   #截止傳票編號
                  more      LIKE type_file.chr1    #Input more condition(Y/N)
                  END RECORD 
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE li_chk_bookno  LIKE type_file.num5
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.num5,
    aba00o LIKE aba_file.aba00,
    aba00n LIKE aba_file.aba00,
    aba01 LIKE aba_file.aba01,
    aba02 LIKE aba_file.aba02,
    abb07 LIKE abb_file.abb07
   ,abb07f LIKE abb_file.abb07f,    #FUN-C40071 add
    azi04  LIKE azi_file.azi04,     #FUN-C40071 add
    aag01  LIKE aag_file.aag01,     #FUN-C40071 add
    aag02  LIKE aag_file.aag02,     #FUN-C40071 add
    msg0   LIKE type_file.chr100,   #FUN-C40071 add
    msg1   LIKE type_file.chr100,   #FUN-C40071 add
    msg2   LIKE type_file.chr100    #FUN-C40071 add
END RECORD
###GENGRE###END

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
               "abb07.abb_file.abb07,",　　#金額
               "abb07f.abb_file.abb07f,",  #金額
               "azi04.azi_file.azi04,",    #幣別取位
               "aag01.aag_file.aag01,",    #科目代號
               "aag02.aag_file.aag02,",    #科目名稱
               "msg0.type_file.chr100,",   #訊息代號
               "msg1.type_file.chr100,",   #訊息代號
               "msg2.type_file.chr100"     #訊息代號
   LET l_table = cl_prt_temptable('aglg817',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?)"
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
      CALL g817_tm()
   ELSE
      CALL g817()
   END IF
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)            #FUN-C40071 add
END MAIN

FUNCTION g817_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1,
          l_cmd          LIKE type_file.chr1000,
          g_cnt          LIKE type_file.num5
   DEFINE l_aaa13        LIKE aaa_file.aaa13
   DEFINE l_aac16        LIKE aac_file.aac16

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW g817_w AT p_row,p_col WITH FORM "agl/42f/aglg817" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL

   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_sw = 1

      INPUT BY NAME tm.o_aba00,tm.n_aba00,tm.o_aba01,tm.b_aba02,tm.e_aba02
                   ,tm.b_aba01,tm.e_aba01,tm.more
            WITHOUT DEFAULTS  

         BEFORE INPUT
            CALL cl_qbe_init()

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
           #MOD-BC0111--Begin Mark--
           #ELSE
           #   IF cl_null(l_aaa13) OR l_aaa13 = 'N' THEN
           #      CALL cl_err('','agl-516',0)
           #      NEXT FIELD CURRENT
           #   END IF
           #MOD-BC0111---End Mark---
            END IF

         AFTER FIELD o_aba01
            IF cl_null(tm.o_aba01) THEN
               NEXT FIELD CURRENT
            END IF
            IF tm.o_aba01 <> '*' THEN
               SELECT COUNT(*) INTO g_cnt FROM aac_file WHERE aac01=tm.o_aba01
               IF g_cnt =0 THEN NEXT FIELD o_aba01 END IF
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
               CALL cl_err('',9033,0)
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
         CALL cl_gre_drop_temptable(l_table)            #FUN-C40071 add
         EXIT PROGRAM
            
      END IF

      IF tm.more = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg817'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg817','9031',1)   
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

            CALL cl_cmdat('aglg817',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g817_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)            #FUN-C40071 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g817()
      ERROR ""
   END WHILE
   CLOSE WINDOW g817_w
END FUNCTION

FUNCTION g817()
   DEFINE g_aba     RECORD LIKE aba_file.*
   DEFINE g_abb     RECORD LIKE abb_file.*
   DEFINE l_sql     LIKE type_file.chr1000,
          i         LIKE type_file.num5,
          j         LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_n1      LIKE type_file.num5,
          l_row     LIKE type_file.num5

   DEFINE l_aag02   LIKE aag_file.aag02,
          l_ze02    LIKE ze_file.ze02,　　　　　　　　#語言別
          l_ze03    LIKE ze_file.ze03,　　　　　　　　#訊息內容
          l_abb031  LIKE abb_file.abb03,
          l_abb032  LIKE abb_file.abb03,
          l_abb07   LIKE abb_file.abb07,
          l_abb07f  LIKE abb_file.abb07f,
          o_aaa03   LIKE aaa_file.aaa03,
          l_aaa03   LIKE aaa_file.aaa03,
          l_azi04   LIKE azi_file.azi04
   DEFINE tmp1      DYNAMIC ARRAY OF RECORD
                    aba01  LIKE aba_file.aba01,
                    aba02  LIKE aba_file.aba02,
                    abb07  LIKE abb_file.abb07,
                    abb07f LIKE abb_file.abb07f,
                    azi04  LIKE azi_file.azi04,
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    msg0   LIKE type_file.chr100,
                    msg1   LIKE type_file.chr100,
                    msg2   LIKE type_file.chr100
                    END RECORD

   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

  #aba_file(會計傳票單頭檔)
   IF tm.o_aba01 = '*' THEN
      LET l_sql = "SELECT aba_file.* FROM aba_file,aac_file",
                  " WHERE aba00='",tm.o_aba00,"'",                  #帳別
                  "   AND aba01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'",
                  "   AND aba19 <> 'X'"  #CHI-C80041
   ELSE
      LET l_sql = "SELECT aba_file.* FROM aba_file,aac_file",
                 " WHERE aba00='",tm.o_aba00,"'",                   #帳別
                 "   AND aba01[1,",g_doc_len,"]='",tm.o_aba01,"'",  #單別
                 "   AND aba01[1,",g_doc_len,"]= aac01",
                 "   AND aac16 = 'Y'",
                 "   AND aba19 <> 'X'"  #CHI-C80041
   END IF
  #傳票日期
   IF tm.b_aba02 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND aba02  >= '",tm.b_aba02,"'"
   END IF
   IF tm.e_aba02 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND aba02  <= '",tm.e_aba02,"'"
   END IF
   LET l_sql = l_sql CLIPPED," ORDER BY aba01"

   PREPARE g817_p1 FROM l_sql
   DECLARE g817_c1 CURSOR WITH HOLD FOR g817_p1
  
   #FUN-C40071----add---str--
   LET l_sql = " SELECT ze02,ze03 FROM ze_file"
              ,"  WHERE ze01 = 'agl1017'"
              ,"  ORDER BY ze02"
   PREPARE g817_p_1017 FROM l_sql
   DECLARE g817_c_1017 CURSOR FOR g817_p_1017

   LET l_sql = " SELECT ze02,ze03 FROM ze_file"
              ,"  WHERE ze01 = 'agl1018'"
              ,"  ORDER BY ze02"
   PREPARE g817_p_1018 FROM l_sql
   DECLARE g817_c_1018 CURSOR FOR g817_p_1018

   LET l_sql = " SELECT ze02,ze03 FROM ze_file"
              ,"  WHERE ze01 = 'agl1019'"
              ,"  ORDER BY ze02"
   PREPARE g817_p_1019 FROM l_sql
   DECLARE g817_c_1019 CURSOR FOR g817_p_1019
   #FUN-C40071----add---end--

   LET j = 0
   FOREACH g817_c1 INTO g_aba.*
      LET j = j+1
      LET l_row = 0
      CALL tmp1.clear()
     #檢核拋轉帳中，是否有存在傳票
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM aba_file
       WHERE aba00 = tm.n_aba00
         AND aba01 = g_aba.aba01
     #FUN-C40071----mark--str--
     #LET l_sql = " SELECT ze02,ze03 FROM ze_file"
     #           ,"  WHERE ze01 = 'agl1017'"
     #           ,"  ORDER BY ze02"
     #PREPARE g817_p_1017 FROM l_sql
     #DECLARE g817_c_1017 CURSOR FOR g817_p_1017
     #FUN-C40071----mark--end--
      IF l_n = 0 THEN
         LET l_row=l_row+1
         LET tmp1[l_row].aba01 = g_aba.aba01
         LET tmp1[l_row].aba02 = g_aba.aba02
         FOREACH g817_c_1017 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0 = l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1 = l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2 = l_ze03
            END CASE
         END FOREACH
      END IF
      FOR i=1 TO l_row
         EXECUTE insert_prep USING
                 j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
                ,tmp1[i].abb07,tmp1[i].abb07f,tmp1[i].azi04,tmp1[i].aag01,tmp1[i].aag02
                ,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2
      END FOR
   END FOREACH

  #abb_fie(會計傳票單身檔)
   IF tm.o_aba01 = '*' THEN
      LET l_sql = "SELECT aba_file.*,abb_file.* FROM aba_file,abb_file,aac_file",
                  " WHERE aba00 = abb00 ",
                  "   AND aba01 = abb01",
                  "   AND aba00='",tm.o_aba00,"'",                    #帳別
                  "   AND aba01[1,",g_doc_len,"]= aac01",
                  "   AND abb01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'",
                  "   AND aba19 = 'Y'",
                  "   AND aba16 IS NOT NULL"
                  
   ELSE
      LET l_sql = "SELECT aba_file.*,abb_file.* FROM aba_file,abb_file,aac_file",
                  " WHERE aba00 = abb00 ",
                  "   AND aba01 = abb01",
                  "   AND aba00='",tm.o_aba00,"'",                    #帳別
                  "   AND aba01[1,",g_doc_len,"]='",tm.o_aba01,"'",   #單別
                  "   AND aba01[1,",g_doc_len,"]= aac01",
                  "   AND abb01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'",
                  "   AND aba19 = 'Y'",
                  "   AND aba16 IS NOT NULL"
                  
   END IF
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

   PREPARE g817_p2 FROM l_sql
   DECLARE g817_c2 CURSOR WITH HOLD FOR g817_p2

   FOREACH g817_c2 INTO g_aba.*,g_abb.*
      LET j = j+1
      LET l_row = 0
      CALL tmp1.clear()
     #以來源帳別科目名稱顯示
      SELECT aag02 INTO l_aag02 FROM aag_file
       WHERE aag00   = tm.o_aba00              #帳別
         AND aag01   = g_abb.abb03             #單身科目
         AND aagacti = 'Y'
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
       WHERE abb00 = g_aba.aba16
         AND abb01 = g_aba.aba17
         AND abb02 = g_abb.abb02

     #科目
      IF(l_abb031 <> l_abb032) THEN
         LET l_row=l_row+1
         LET tmp1[l_row].aba01 = g_abb.abb01
         LET tmp1[l_row].aba02 = g_aba.aba02
         LET tmp1[l_row].aag01 = g_abb.abb03
         LET tmp1[l_row].aag02 = l_aag02
        #FUN-C40071----mark--str--
        #LET l_sql = " SELECT ze02,ze03 FROM ze_file"
        #           ,"  WHERE ze01 = 'agl1018'"
        #           ,"  ORDER BY ze02"
        #PREPARE g817_p_1018 FROM l_sql
        #DECLARE g817_c_1018 CURSOR FOR g817_p_1018
        #FUN-C40071----mark--end--
         FOREACH g817_c_1018 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0 = l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1 = l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2 = l_ze03
            END CASE
         END FOREACH
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
         LET tmp1[l_row].abb07 = g_abb.abb07
         LET tmp1[l_row].abb07f = g_abb.abb07f
        #FUN-C40071----mark--str--
        #LET l_sql = " SELECT ze02,ze03 FROM ze_file"
        #           ,"  WHERE ze01 = 'agl1019'"
        #           ,"  ORDER BY ze02"
        #PREPARE g817_p_1019 FROM l_sql
        #DECLARE g817_c_1019 CURSOR FOR g817_p_1019
        #FUN-C40071----mark--end--
         FOREACH g817_c_1019 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0 = l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1 = l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2 = l_ze03
            END CASE
         END FOREACH
      END IF

      FOR i=1 TO l_row
         EXECUTE insert_prep USING
                 j,tm.o_aba00,tm.n_aba00,tmp1[i].aba01,tmp1[i].aba02
                ,tmp1[i].abb07,tmp1[i].abb07f,tmp1[i].azi04,tmp1[i].aag01,tmp1[i].aag02
                ,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2
      END FOR
   END FOREACH
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
###GENGRE###   LET g_str = ""
###GENGRE###   CALL cl_prt_cs3('aglg817','aglg817',g_sql,g_str) 
    CALL aglg817_grdata()    ###GENGRE###
END FUNCTION
#FUN-BC0012



###GENGRE###START
FUNCTION aglg817_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg817")
        IF handler IS NOT NULL THEN
            START REPORT aglg817_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg817_datacur1 CURSOR FROM l_sql
            FOREACH aglg817_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg817_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg817_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg817_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5

    
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
#           PRINTX g_user,g_pdate,g_prog,g_company                     #FUN-C40071 mark
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime  #FUN-C40071 add
            PRINTX tm.*
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        
        ON LAST ROW

END REPORT
###GENGRE###END
