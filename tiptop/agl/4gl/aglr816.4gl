# Prog. Version..: '5.30.06-13.03.27(00003)'     #
# Pattern name...: aglr816.4gl
# Descriptions...: 立沖帳拋轉前檢核報表
# Date & Author..: 11/12/23 By Lori(FUN-BC0001)
# Modify.........: No:TQC-BC0056 11/12/23 By Lori 異動碼9,10不需檢核 
# Modify.........: No:FUN-C40112 12/07/24 By Lori 拋轉傳票紀錄變稱為abm_file
# Modify.........: NO.CHI-CB0057 12/11/23 BY Yiting 與abm_file的串接條件錯誤

DATABASE ds
#FUN-BC0001
GLOBALS "../../config/top.global"

DEFINE tm         RECORD
                  o_abg00   LIKE abg_file.abg00,   #原始帳別
                  n_abg00   LIKE abg_file.abg00,   #拋轉帳別
                  o_abg01   LIKE abg_file.abg01,   #傳票單別
                  b_abg06   LIKE abg_file.abg06,   #起始傳票日期
                  e_abg06   LIKE abg_file.abg06,   #截止傳票日期
                  more      LIKE type_file.chr1    #Input more condition(Y/N)
                  END RECORD 
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_bookno   LIKE aah_file.aah00
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
               "order2.type_file.num5,",
               "abg00.abg_file.abg00,",    #帳別
               "abg01.abg_file.abg01,",    #傳票編號
               "abg06.abg_file.abg06,",    #傳票日期
               "aag01.aag_file.aag01,",    #科目代號
               "aag02.aag_file.aag02,",    #科目名稱
               "msg0.type_file.chr100,",   #訊息代號
               "msg1.type_file.chr100,",   #訊息代號
               "msg2.type_file.chr100"     #訊息代號
   LET l_table = cl_prt_temptable('aglr816',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,? ,?,?,?,?,?)"
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
   LET tm.o_abg00 = ARG_VAL(11)
   LET tm.n_abg00 = ARG_VAL(12)
   LET tm.o_abg01 = ARG_VAL(13)
   LET tm.b_abg06 = ARG_VAL(14)
   LET tm.e_abg06 = ARG_VAL(15)


   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r816_tm()
   ELSE
      CALL r816()
   END IF
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r816_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1,
          l_cmd          LIKE type_file.chr1000,
          g_cnt          LIKE type_file.num5
   DEFINE l_aaa13        LIKE aaa_file.aaa13
   DEFINE l_aac16        LIKE aac_file.aac16

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r816_w AT p_row,p_col WITH FORM "agl/42f/aglr816" 
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

      INPUT BY NAME tm.o_abg00,tm.n_abg00,tm.o_abg01,tm.b_abg06,tm.e_abg06,tm.more
            WITHOUT DEFAULTS  

         BEFORE INPUT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT

         AFTER FIELD o_abg00         #原始帳別
            IF cl_null(tm.o_abg00) THEN
               NEXT FIELD CURRENT
            ELSE
               CALL s_check_bookno(tm.o_abg00,g_user,g_plant)
                  RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD CURRENT
               END IF
               SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=tm.o_abg00
               IF g_cnt =0 THEN
                  CALL cl_err('','anm-062',0)
                  NEXT FIELD CURRENT
               END IF
            END IF

         AFTER FIELD n_abg00         #拋轉帳別
            IF cl_null(tm.n_abg00) OR tm.n_abg00=tm.o_abg00 THEN
               CALL cl_err('','agl-515',0)
               NEXT FIELD CURRENT
            END IF
    
            CALL s_check_bookno(tm.n_abg00,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD CURRENT
            END IF
    
            LET g_cnt = 0
            LET l_aaa13 = NULL
            SELECT aaa13,COUNT(*) INTO l_aaa13,g_cnt FROM aaa_file
             WHERE aaa01=tm.n_abg00
             GROUP BY aaa13
            IF g_cnt =0 THEN
               CALL cl_err('','anm-062',0)
               NEXT FIELD CURRENT
            ELSE
               IF cl_null(l_aaa13) OR l_aaa13 = 'N' THEN
                  CALL cl_err('','agl-516',0)
                  NEXT FIELD CURRENT
               END IF
            END IF

         AFTER FIELD o_abg01
            IF cl_null(tm.o_abg01) THEN
               NEXT FIELD CURRENT
            END IF
            IF tm.o_abg01 != '*' THEN
               LET l_aac16 = NULL
               SELECT aac16 INTO l_aac16 FROM aac_file
                WHERE aac01 = tm.o_abg01
                  AND aacacti='Y'
               IF cl_null(l_aac16) OR l_aac16 = 'N' THEN
                  CALL cl_err('','agl-530',0)
                  NEXT FIELD CURRENT
               END IF
            END IF

         AFTER FIELD e_abg06
            IF NOT cl_null(tm.e_abg06) THEN
               IF tm.b_abg06 > tm.e_abg06 THEN
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
            IF cl_null(tm.b_abg06) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.b_abg06
               CALL cl_err('',9033,0)
            END IF
            IF cl_null(tm.e_abg06) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.e_abg06
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
          WHERE zz01='aglr816'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr816','9031',1)   
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
                      " '",tm.o_abg00 CLIPPED, "'",
                      " '",tm.n_abg00 CLIPPED, "'",
                      " '",tm.o_abg01 CLIPPED, "'",
                      " '",tm.b_abg06 CLIPPED, "'",
                      " '",tm.e_abg06 CLIPPED, "'"
            CALL cl_cmdat('aglr816',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r816_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r816()
      ERROR ""
   END WHILE
   CLOSE WINDOW r816_w
END FUNCTION

FUNCTION r816()
   DEFINE g_abg     RECORD LIKE abg_file.*
   DEFINE g_abh     RECORD LIKE abh_file.*
   DEFINE l_sql     LIKE type_file.chr1000,
          i         LIKE type_file.num5,
          j         LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_row     LIKE type_file.num5,
          l_aag02   LIKE aag_file.aag02,
          l_gaq03   LIKE gaq_file.gaq03,
          l_ze02    LIKE ze_file.ze02,
          l_ze03    LIKE ze_file.ze03,
          l_ze03_0  LIKE ze_file.ze03,
          l_ze03_1  LIKE ze_file.ze03,
          l_ze03_2  LIKE ze_file.ze03
   DEFINE tmp1      DYNAMIC ARRAY OF RECORD
                    abg00  LIKE abg_file.abg00,
                    abg01  LIKE abg_file.abg01,
                    abg06  LIKE abg_file.abg06,
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    msg0   LIKE type_file.chr100,
                    msg1   LIKE type_file.chr100,
                    msg2   LIKE type_file.chr100
                    END RECORD

   DEFINE l_aag15_1,l_aag15_2    LIKE aag_file.aag15
   DEFINE l_aag151_1,l_aag151_2  LIKE aag_file.aag151
   DEFINE l_aag16_1,l_aag16_2    LIKE aag_file.aag16
   DEFINE l_aag161_1,l_aag161_2  LIKE aag_file.aag161
   DEFINE l_aag17_1,l_aag17_2    LIKE aag_file.aag17
   DEFINE l_aag171_1,l_aag171_2  LIKE aag_file.aag171
   DEFINE l_aag18_1,l_aag18_2    LIKE aag_file.aag18
   DEFINE l_aag181_1,l_aag181_2  LIKE aag_file.aag181
   DEFINE l_aag20_1,l_aag20_2    LIKE aag_file.aag20
   DEFINE l_aag222_1,l_aag222_2  LIKE aag_file.aag222
   DEFINE l_aag31_1,l_aag31_2    LIKE aag_file.aag31
   DEFINE l_aag311_1,l_aag311_2  LIKE aag_file.aag311
   DEFINE l_aag32_1,l_aag32_2    LIKE aag_file.aag32
   DEFINE l_aag321_1,l_aag321_2  LIKE aag_file.aag321
   DEFINE l_aag33_1,l_aag33_2    LIKE aag_file.aag33
   DEFINE l_aag331_1,l_aag331_2  LIKE aag_file.aag331
   DEFINE l_aag34_1,l_aag34_2    LIKE aag_file.aag34
   DEFINE l_aag341_1,l_aag341_2  LIKE aag_file.aag341
  #TQC-BC0056--Begin Mark--
  #DEFINE l_aag35_1,l_aag35_2    LIKE aag_file.aag35
  #DEFINE l_aag351_1,l_aag351_2  LIKE aag_file.aag351
  #DEFINE l_aag36_1,l_aag36_2    LIKE aag_file.aag36
  #DEFINE l_aag361_1,l_aag361_2  LIKE aag_file.aag361
   DEFINE l_aag05_1,l_aag05_2    LIKE aag_file.aag05
  #TQC-BC0056---End Mark---
   DEFINE l_aaa13                LIKE aaa_file.aaa13

   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

  #abg_file(傳票項次立帳異動檔)
   IF tm.o_abg01 = '*' THEN
      LET l_sql = "SELECT abg_file.* FROM abg_file,aac_file",
                  " WHERE abg00='",tm.o_abg00,"'",                  #帳別
                  "   AND abg01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'"
   ELSE
      LET l_sql = "SELECT abg_file.* FROM abg_file,aac_file",
                 " WHERE abg00='",tm.o_abg00,"'",                   #帳別
                 "   AND abg01[1,",g_doc_len,"]='",tm.o_abg01,"'",  #單別
                 "   AND abg01[1,",g_doc_len,"]= aac01",
                 "   AND aac16 = 'Y'"
   END IF
  #傳票日期
   IF tm.b_abg06 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND abg06  >= '",tm.b_abg06,"'"
   END IF
   IF tm.e_abg06 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND abg06  <= '",tm.e_abg06,"'"
   END IF
   LET l_sql = l_sql CLIPPED," ORDER BY abg01"

   PREPARE r816_p1 FROM l_sql
   DECLARE r816_c1 CURSOR WITH HOLD FOR r816_p1

   LET j = 0
   FOREACH r816_c1 INTO g_abg.*
      LET j = j+1
      LET l_row = 0
      CALL tmp1.clear()
     #檢核拋轉帳中，是否有存在傳票，傳票未拋轉者不可拋立沖資料
      LET l_n = 0
      #FUN-C40112-Mark Begin---
      #SELECT COUNT(*) INTO l_n FROM aba_file
      # WHERE aba16 = tm.n_abg00
      #   AND aba17 = g_abg.abg01
      #FUN-C40112-Mark End-----

      #FUN-C40112-Add Begin---
      SELECT COUNT(*) INTO l_n FROM aba_file LEFT OUTER JOIN abm_file
          #ON aba00 = abm02 AND aba01 = aba03 AND aba01 = abm06
          ON aba00 = abm02 AND aba01 = abm03  #CHI-CB0057 mod
       WHERE abm05 = tm.n_abg00
         AND abm06 = g_abg.abg01
      #FUN-C40112-Add End-----
      LET l_sql = " SELECT ze02,ze03 FROM ze_file"
                 ,"  WHERE ze01 = 'agl-518'"
                 ,"  ORDER BY ze02"
      PREPARE r816_p_518 FROM l_sql
      DECLARE r816_c_518 CURSOR FOR r816_p_518
      IF l_n = 0 THEN
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00 #g_abg.abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         FOREACH r816_c_518 INTO l_ze02,l_ze03
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

     #檢核是否有科目(abg03)
      LET l_n = 0
      LET l_aag02 = " "
      SELECT COUNT(*) INTO l_n FROM aag_file
       WHERE aag00   = tm.n_abg00
         AND aag01   = g_abg.abg03
         AND aagacti = 'Y'
     #如果新帳別找不到科目代號,以來源帳別科目名稱顯示
      SELECT aag02 INTO l_aag02 FROM aag_file
       WHERE aag00   = tm.o_abg00
         AND aag01   = g_abg.abg03
         AND aagacti = 'Y'
      LET l_sql = " SELECT ze02,ze03 FROM ze_file"
                 ,"  WHERE ze01 = 'agl-229'"
                 ,"  ORDER BY ze02"
      PREPARE r816_p_229 FROM l_sql
      DECLARE r816_c_229 CURSOR FOR r816_p_229
      IF l_n = 0 THEN
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_229 INTO l_ze02,l_ze03
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

     #檢核異動碼--來源帳別
      SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
             aag20,aag222,aag31,aag311,aag32,aag321,aag33,aag331,
             aag34,aag341,aag05                                 #TQC-BC0056
           #,aag35,aag351,aag36,aag361                          #TQC-BC0056
        INTO l_aag15_1,l_aag151_1,l_aag16_1,l_aag161_1,l_aag17_1,l_aag171_1,
             l_aag18_1,l_aag181_1,l_aag20_1,l_aag222_1,l_aag31_1,l_aag311_1,
             l_aag32_1,l_aag321_1,l_aag33_1,l_aag331_1,l_aag34_1,l_aag341_1,
             l_aag05_1                                          #TQC-BC0056
            #l_aag35_1,l_aag351_1,l_aag36_1,l_aag361_1          #TQC-BC0056
        FROM aag_file
       WHERE aag00 = tm.o_abg00 AND aag01 = g_abg.abg03 AND aagacti = 'Y'

     #檢核異動碼--拋轉帳別
      SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
             aag20,aag222,aag31,aag311,aag32,aag321,aag33,aag331,
             aag34,aag341,aag05                                 #TQC-BC0056
           #,aag35,aag351,aag36,aag361                          #TQC-BC0056
        INTO l_aag15_2,l_aag151_2,l_aag16_2,l_aag161_2,l_aag17_2,l_aag171_2,
             l_aag18_2,l_aag181_2,l_aag20_2,l_aag222_2,l_aag31_2,l_aag311_2,
             l_aag32_2,l_aag321_2,l_aag33_2,l_aag331_2,l_aag34_2,l_aag341_2,
             l_aag05_2                                          #TQC-BC0056
            #l_aag35_2,l_aag351_2,l_aag36_2,l_aag361_2          #TQC-BC0056
        FROM aag_file
       WHERE aag00 = tm.n_abg00 AND aag01 = g_abg.abg03 AND aagacti = 'Y'

     #異動碼差異
      LET l_sql = " SELECT ze02,ze03 FROM ze_file"
                 ,"  WHERE ze01 = 'agl-519'"
                 ,"  ORDER BY ze02"
      PREPARE r816_p_519 FROM l_sql
      DECLARE r816_c_519 CURSOR FOR r816_p_519
      FOREACH r816_c_519 INTO l_ze02,l_ze03
         CASE l_ze02
            WHEN "0"
               LET l_ze03_0 = l_ze03
            WHEN "1"
               LET l_ze03_1 = l_ze03
            WHEN "2"
               LET l_ze03_2 = l_ze03
         END CASE
      END FOREACH

      IF cl_null(l_aag15_1)  THEN LET l_aag15_1  =' '  END IF
      IF cl_null(l_aag151_1) THEN LET l_aag151_1 =' '  END IF
      IF cl_null(l_aag16_1)  THEN LET l_aag16_1  =' '  END IF
      IF cl_null(l_aag161_1) THEN LET l_aag161_1 =' '  END IF
      IF cl_null(l_aag17_1)  THEN LET l_aag17_1  =' '  END IF
      IF cl_null(l_aag171_1) THEN LET l_aag171_1 =' '  END IF
      IF cl_null(l_aag18_1)  THEN LET l_aag18_1  =' '  END IF
      IF cl_null(l_aag181_1) THEN LET l_aag181_1 =' '  END IF
      IF cl_null(l_aag20_1)  THEN LET l_aag20_1  =' '  END IF
      IF cl_null(l_aag222_1) THEN LET l_aag222_1 =' '  END IF
      IF cl_null(l_aag31_1)  THEN LET l_aag31_1  =' '  END IF
      IF cl_null(l_aag311_1) THEN LET l_aag311_1 =' '  END IF
      IF cl_null(l_aag32_1)  THEN LET l_aag32_1  =' '  END IF
      IF cl_null(l_aag321_1) THEN LET l_aag321_1 =' '  END IF
      IF cl_null(l_aag33_1)  THEN LET l_aag33_1  =' '  END IF
      IF cl_null(l_aag331_1) THEN LET l_aag331_1 =' '  END IF
      IF cl_null(l_aag34_1)  THEN LET l_aag34_1  =' '  END IF
      IF cl_null(l_aag341_1) THEN LET l_aag341_1 =' '  END IF
     #TQC-BC0056--Begin--
     #IF cl_null(l_aag35_1)  THEN LET l_aag35_1  =' '  END IF
     #IF cl_null(l_aag351_1) THEN LET l_aag351_1 =' '  END IF
     #IF cl_null(l_aag36_1)  THEN LET l_aag36_1  =' '  END IF
     #IF cl_null(l_aag361_1) THEN LET l_aag361_1 =' '  END IF
      IF cl_null(l_aag05_1)  THEN LET l_aag05_1  =' '  END IF
     #TQC-BC0056---End---
      IF cl_null(l_aag15_2)  THEN LET l_aag15_2 =' '   END IF
      IF cl_null(l_aag151_2) THEN LET l_aag151_2 =' '  END IF
      IF cl_null(l_aag16_2)  THEN LET l_aag16_2  =' '  END IF
      IF cl_null(l_aag161_2) THEN LET l_aag161_2 =' '  END IF
      IF cl_null(l_aag17_2)  THEN LET l_aag17_2  =' '  END IF
      IF cl_null(l_aag171_2) THEN LET l_aag171_2 =' '  END IF
      IF cl_null(l_aag18_2)  THEN LET l_aag18_2  =' '  END IF
      IF cl_null(l_aag181_2) THEN LET l_aag181_2 =' '  END IF
      IF cl_null(l_aag20_2)  THEN LET l_aag20_2  =' '  END IF
      IF cl_null(l_aag222_2) THEN LET l_aag222_2 =' '  END IF
      IF cl_null(l_aag31_2)  THEN LET l_aag31_2  =' '  END IF
      IF cl_null(l_aag311_2) THEN LET l_aag311_2 =' '  END IF
      IF cl_null(l_aag32_2)  THEN LET l_aag32_2  =' '  END IF
      IF cl_null(l_aag321_2) THEN LET l_aag321_2 =' '  END IF
      IF cl_null(l_aag33_2)  THEN LET l_aag33_2  =' '  END IF
      IF cl_null(l_aag331_2) THEN LET l_aag331_2 =' '  END IF
      IF cl_null(l_aag34_2)  THEN LET l_aag34_2  =' '  END IF
      IF cl_null(l_aag341_2) THEN LET l_aag341_2 =' '  END IF
     #TQC-BC0056--Begin--
     #IF cl_null(l_aag35_2)  THEN LET l_aag35_2  =' '  END IF
     #IF cl_null(l_aag351_2) THEN LET l_aag351_2 =' '  END IF
     #IF cl_null(l_aag36_2)  THEN LET l_aag36_2  =' '  END IF
     #IF cl_null(l_aag361_2) THEN LET l_aag361_2 =' '  END IF
      IF cl_null(l_aag05_2)  THEN LET l_aag05_2  =' '  END IF
     #TQC-BC0056---End---

      LET l_sql = " SELECT gaq03 FROM gaq_file"
                 ,"  WHERE gaq01 = ? AND gaq02 = ?"
      PREPARE r816_p_gaq03 FROM l_sql
      DECLARE r816_c_gaq03 CURSOR FOR r816_p_gaq03

      IF l_aag15_1 <> l_aag15_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag15",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag15",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag151_1 <> l_aag151_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag151",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag151",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag16_1 <> l_aag16_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag16",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag16",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag161_1 <> l_aag161_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag161",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag161",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag17_1 <> l_aag17_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag17",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag17",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag171_1 <> l_aag171_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag171",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag171",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag18_1 <> l_aag18_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag18",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag18",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag181_1 <> l_aag181_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag181",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag181",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag31_1 <> l_aag31_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag31",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag31",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag311_1 <> l_aag311_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag311",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag311",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag32_1 <> l_aag32_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag32",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag32",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag321_1 <> l_aag321_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag321",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag321",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag33_1 <> l_aag33_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag33",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag33",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag331_1 <> l_aag331_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag331",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag331",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag34_1 <> l_aag34_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag34",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag34",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag341_1 <> l_aag341_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag341",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag341",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
     #TQC-BC0056--Begin Mark--
     #IF l_aag35_1 <> l_aag35_2 THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag35",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag35",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abg.abg01
     #   LET tmp1[l_row].abg06 = g_abg.abg06
     #   LET tmp1[l_row].aag01 = g_abg.abg03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #IF l_aag351_1 <> l_aag351_2 THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag351",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag351",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abg.abg01
     #   LET tmp1[l_row].abg06 = g_abg.abg06
     #   LET tmp1[l_row].aag01 = g_abg.abg03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #IF l_aag36_1 <> l_aag36_2  THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag36",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag36",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abg.abg01
     #   LET tmp1[l_row].abg06 = g_abg.abg06
     #   LET tmp1[l_row].aag01 = g_abg.abg03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #IF l_aag361_1 <> l_aag361_2 THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag361",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag361",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abg.abg01
     #   LET tmp1[l_row].abg06 = g_abg.abg06
     #   LET tmp1[l_row].aag01 = g_abg.abg03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #TQC-BC0056---End Mark---
     #TQC-BC0056--Begin--
     #判斷部門管理
      LET l_sql = " SELECT ze02,ze03 FROM ze_file"
                 ,"  WHERE ze01 = 'agl1020'"
                 ,"  ORDER BY ze02"
      PREPARE r816_p_1020 FROM l_sql
      DECLARE r816_c_1020 CURSOR FOR r816_p_1020
      IF l_aag05_1 <> l_aag05_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag05",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag05",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_1020 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03
            END CASE
         END FOREACH
      END IF

     #TQC-BC0056---End---
     #判斷細項立沖否
      LET l_sql = " SELECT ze02,ze03 FROM ze_file"
                 ,"  WHERE ze01 = 'agl-520'"
                 ,"  ORDER BY ze02"
      PREPARE r816_p_520 FROM l_sql
      DECLARE r816_c_520 CURSOR FOR r816_p_520
      IF l_aag20_1 <> l_aag20_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag20",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag20",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_520 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03
            END CASE
         END FOREACH
      END IF
     #傳票項次異動別
      LET l_sql = " SELECT ze02,ze03 FROM ze_file"
                 ,"  WHERE ze01 = 'agl-521'"
                 ,"  ORDER BY ze02"
      PREPARE r816_p_521 FROM l_sql
      DECLARE r816_c_521 CURSOR FOR r816_p_521
      IF l_aag222_1 <> l_aag222_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag222",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag222",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abg.abg01
         LET tmp1[l_row].abg06 = g_abg.abg06
         LET tmp1[l_row].aag01 = g_abg.abg03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_521 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03
            END CASE
         END FOREACH
      END IF
      FOR i=1 TO l_row
         EXECUTE insert_prep USING
                 j,i,tmp1[i].abg00,tmp1[i].abg01,tmp1[i].abg06
                ,tmp1[i].aag01,tmp1[i].aag02,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2
      END FOR
   END FOREACH

  #abh_fie(傳票項次沖帳異動檔)
   IF tm.o_abg01 = '*' THEN
      LET l_sql = "SELECT abg_file.*,abh_file.* FROM abg_file,abh_file,aac_file",
                  " WHERE abg00 = abh00 ",
                  "   AND abg01 = abh07",
                  "   AND abg02 = abh08",
                  "   AND abg00='",tm.o_abg00,"'",                    #帳別
                  "   AND abg01[1,",g_doc_len,"]= aac01",
                  "   AND abh01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'",
                  "   AND abhconf = 'Y'"
   ELSE
      LET l_sql = "SELECT abg_file.*,abh_file.* FROM abg_file,abh_file,aac_file",
                  " WHERE abg00 = abh00 ",
                  "   AND abg01 = abh07",
                  "   AND abg02 = abh08",
                  "   AND abg00='",tm.o_abg00,"'",                    #帳別
                  "   AND abg01[1,",g_doc_len,"]='",tm.o_abg01,"'",   #單別
                  "   AND abg01[1,",g_doc_len,"]= aac01",
                  "   AND abh01[1,",g_doc_len,"]= aac01",
                  "   AND aac16 = 'Y'",
                  "   AND abhconf = 'Y'"
   END IF
  #傳票日期
   IF tm.b_abg06 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND abg06  >= '",tm.b_abg06,"'",
                                " AND abh021 >= '",tm.b_abg06,"'"
   END IF
   IF tm.e_abg06 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED," AND abg06  <= '",tm.e_abg06,"'",
                                " AND abh021 <= '",tm.e_abg06,"'"
   END IF
   LET l_sql = l_sql CLIPPED," ORDER BY abg01"

   PREPARE r816_p2 FROM l_sql
   DECLARE r816_c2 CURSOR WITH HOLD FOR r816_p2

   FOREACH r816_c2 INTO g_abg.*,g_abh.*
      LET j = j+1
      LET l_row = 0
      CALL tmp1.clear()
     #檢核拋轉帳中，是否有存在傳票，傳票未拋轉者不可拋立沖資料
      LET l_n = 0
      #FUN-C40112-Mark Begin---
      #SELECT COUNT(*) INTO l_n FROM aba_file
      # WHERE aba16 = tm.n_abg00
      #   AND aba17 = g_abh.abh01
      #FUN-C40112-Mark End----

      #FUN-C40112 Add Begin---
      SELECT COUNT(*) INTO l_n FROM aba_file LEFT OUTER JOIN abm_file
          ON aba00 = abm02 AND aba01 = abm03 AND aba01 = abm06
       WHERE abm05 = tm.n_abg00
         AND abm06 = g_abh.abh01
      #FUN-C40112 Add End-----
      IF l_n = 0 THEN
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00 #g_abg.abh00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         FOREACH r816_c_518 INTO l_ze02,l_ze03
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

     #檢核是否有科目(abg03)
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM aag_file
       WHERE aag00   = tm.n_abg00
         AND aag01   = g_abh.abh03
         AND aagacti = 'Y'
     #如果新帳別找不到科目代號,以來源帳別科目名稱顯示
      SELECT aag02 INTO l_aag02 FROM aag_file
       WHERE aag00   = tm.o_abg00
         AND aag01   = g_abh.abh03
         AND aagacti = 'Y'
      IF l_n = 0 THEN
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh06
         LET tmp1[l_row].aag01 = g_abh.abh021
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_229 INTO l_ze02,l_ze03
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

     #檢核異動碼--來源帳別
       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
              aag20,aag222,aag31,aag311,aag32,aag321,aag33,aag331,
              aag34,aag341,aag05                                 #TQC-BC0056
            #,aag35,aag351,aag36,aag361                          #TQC-BC0056 Mark
         INTO l_aag15_1,l_aag151_1,l_aag16_1,l_aag161_1,l_aag17_1,l_aag171_1,
              l_aag18_1,l_aag181_1,l_aag20_1,l_aag222_1,l_aag31_1,l_aag311_1,
              l_aag32_1,l_aag321_1,l_aag33_1,l_aag331_1,l_aag34_1,l_aag341_1,
              l_aag05_1                                          #TQC-BC0056
             #l_aag35_1,l_aag351_1,l_aag36_1,l_aag361_1          #TQC-BC0056 Mark
         FROM aag_file
        WHERE aag00 = tm.o_abg00 AND aag01 = g_abh.abh03 AND aagacti = 'Y'

       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
              aag20,aag222,aag31,aag331,aag32,aag321,aag33,aag331,
              aag34,aag341,aag05                                 #TQC-BC0056
            #,aag35,aag351,aag36,aag361                          #TQC-BC0056 Mark
         INTO l_aag15_2,l_aag151_2,l_aag16_2,l_aag161_2,l_aag17_2,l_aag171_2,
              l_aag18_2,l_aag181_2,l_aag20_2,l_aag222_2,l_aag31_2,l_aag311_2,
              l_aag32_2,l_aag321_2,l_aag33_2,l_aag331_2,l_aag34_2,l_aag341_2,
              l_aag05_2                                          #TQC-BC0056
             #l_aag35_2,l_aag351_2,l_aag36_2,l_aag361_2          #TQC-BC0056 Mark
         FROM aag_file
        WHERE aag00 = tm.n_abg00 AND aag01 = g_abh.abh03 AND aagacti = 'Y' 

     #異動碼差異
      FOREACH r816_c_519 INTO l_ze02,l_ze03
         CASE l_ze02
            WHEN "0"
               LET l_ze03_0 = l_ze03
            WHEN "1"
               LET l_ze03_1 = l_ze03
            WHEN "2"
               LET l_ze03_2 = l_ze03
         END CASE
      END FOREACH

      IF cl_null(l_aag15_1)  THEN LET l_aag15_1  =' '  END IF
      IF cl_null(l_aag151_1) THEN LET l_aag151_1 =' '  END IF
      IF cl_null(l_aag16_1)  THEN LET l_aag16_1  =' '  END IF
      IF cl_null(l_aag161_1) THEN LET l_aag161_1 =' '  END IF
      IF cl_null(l_aag17_1)  THEN LET l_aag17_1  =' '  END IF
      IF cl_null(l_aag171_1) THEN LET l_aag171_1 =' '  END IF
      IF cl_null(l_aag18_1)  THEN LET l_aag18_1  =' '  END IF
      IF cl_null(l_aag181_1) THEN LET l_aag181_1 =' '  END IF
      IF cl_null(l_aag20_1)  THEN LET l_aag20_1  =' '  END IF
      IF cl_null(l_aag222_1) THEN LET l_aag222_1 =' '  END IF
      IF cl_null(l_aag31_1)  THEN LET l_aag31_1  =' '  END IF
      IF cl_null(l_aag311_1) THEN LET l_aag311_1 =' '  END IF
      IF cl_null(l_aag32_1)  THEN LET l_aag32_1  =' '  END IF
      IF cl_null(l_aag321_1) THEN LET l_aag321_1 =' '  END IF
      IF cl_null(l_aag33_1)  THEN LET l_aag33_1  =' '  END IF
      IF cl_null(l_aag331_1) THEN LET l_aag331_1 =' '  END IF
      IF cl_null(l_aag34_1)  THEN LET l_aag34_1  =' '  END IF
      IF cl_null(l_aag341_1) THEN LET l_aag341_1 =' '  END IF
     #TQC-BC0056--Begin Mark--
     #IF cl_null(l_aag35_1)  THEN LET l_aag35_1  =' '  END IF
     #IF cl_null(l_aag351_1) THEN LET l_aag351_1 =' '  END IF
     #IF cl_null(l_aag36_1)  THEN LET l_aag36_1  =' '  END IF
     #IF cl_null(l_aag361_1) THEN LET l_aag361_1 =' '  END IF
      IF cl_null(l_aag05_1)  THEN LET l_aag05_1  =' '  END IF
     #TQC-BC0056---End Mark---
      IF cl_null(l_aag15_2)  THEN LET l_aag15_2  =' '  END IF
      IF cl_null(l_aag151_2) THEN LET l_aag151_2 =' '  END IF
      IF cl_null(l_aag16_2)  THEN LET l_aag16_2  =' '  END IF
      IF cl_null(l_aag161_2) THEN LET l_aag161_2 =' '  END IF
      IF cl_null(l_aag17_2)  THEN LET l_aag17_2  =' '  END IF
      IF cl_null(l_aag171_2) THEN LET l_aag171_2 =' '  END IF
      IF cl_null(l_aag18_2)  THEN LET l_aag18_2  =' '  END IF
      IF cl_null(l_aag181_2) THEN LET l_aag181_2 =' '  END IF
      IF cl_null(l_aag20_2)  THEN LET l_aag20_2  =' '  END IF
      IF cl_null(l_aag222_2) THEN LET l_aag222_2 =' '  END IF
      IF cl_null(l_aag31_2)  THEN LET l_aag31_2  =' '  END IF
      IF cl_null(l_aag311_2) THEN LET l_aag311_2 =' '  END IF
      IF cl_null(l_aag32_2)  THEN LET l_aag32_2  =' '  END IF
      IF cl_null(l_aag321_2) THEN LET l_aag321_2 =' '  END IF
      IF cl_null(l_aag33_2)  THEN LET l_aag33_2  =' '  END IF
      IF cl_null(l_aag331_2) THEN LET l_aag331_2 =' '  END IF
      IF cl_null(l_aag34_2)  THEN LET l_aag34_2  =' '  END IF
      IF cl_null(l_aag341_2) THEN LET l_aag341_2 =' '  END IF
     #TQC-BC0056--Begin Mark--
     #IF cl_null(l_aag35_2)  THEN LET l_aag35_2  =' '  END IF
     #IF cl_null(l_aag351_2) THEN LET l_aag351_2 =' '  END IF
     #IF cl_null(l_aag36_2)  THEN LET l_aag36_2  =' '  END IF
     #IF cl_null(l_aag361_2) THEN LET l_aag361_2 =' '  END IF
      IF cl_null(l_aag05_2)  THEN LET l_aag05_2  =' '  END IF
     #TQC-BC0056---End Mark---

     IF l_aag15_1 <> l_aag15_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag15",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag15",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag151_1 <> l_aag151_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag151",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag151",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag16_1 <> l_aag16_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag16",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag16",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag161_1 <> l_aag161_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag161",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag161",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag17_1 <> l_aag17_2  THEN 
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag17",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag17",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag171_1 <> l_aag171_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag171",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag171",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag18_1 <> l_aag18_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag18",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag18",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag181_1 <> l_aag181_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag181",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag181",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag31_1 <> l_aag31_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag31",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag31",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag311_1 <> l_aag311_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag311",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag311",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag32_1 <> l_aag32_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag32",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag32",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag321_1 <> l_aag321_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag321",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag321",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag33_1 <> l_aag33_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag33",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag33",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag331_1 <> l_aag331_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag331",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag331",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag34_1 <> l_aag34_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag34",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag34",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
      IF l_aag341_1 <> l_aag341_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag341",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag341",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
         LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
         LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
      END IF
     #TQC-BC0056--Begin Mark--
     #IF l_aag35_1 <> l_aag35_2 THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag35",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag35",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abh.abh01
     #   LET tmp1[l_row].abg06 = g_abh.abh021
     #   LET tmp1[l_row].aag01 = g_abh.abh03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #IF l_aag351_1 <> l_aag351_2 THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag351",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag351",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abh.abh01
     #   LET tmp1[l_row].abg06 = g_abh.abh021
     #   LET tmp1[l_row].aag01 = g_abh.abh03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #IF l_aag36_1 <> l_aag36_2  THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag36",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag36",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abh.abh01
     #   LET tmp1[l_row].abg06 = g_abh.abh021
     #   LET tmp1[l_row].aag01 = g_abh.abh03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #IF l_aag361_1 <> l_aag361_2 THEN
     #   LET l_gaq03 = " "
     #   OPEN r816_c_gaq03 USING "aag361",g_lang
     #   IF STATUS THEN
     #      CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
     #      CLOSE r816_c_gaq03
     #   END IF
     #   FETCH r816_c_gaq03 INTO l_gaq03
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err("aag361",SQLCA.sqlcode,0)
     #   END IF
     #   LET l_row=l_row+1
     #   LET tmp1[l_row].abg00 = tm.n_abg00
     #   LET tmp1[l_row].abg01 = g_abh.abh01
     #   LET tmp1[l_row].abg06 = g_abh.abh021
     #   LET tmp1[l_row].aag01 = g_abh.abh03
     #   LET tmp1[l_row].aag02 = l_aag02 
     #   LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03_0
     #   LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03_1
     #   LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03_2
     #END IF
     #TQC-BC0056---End Mark---
     #TQC-BC0056--Begin--
     #判斷部門管理
      IF l_aag05_1 <> l_aag05_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag05",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag05",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_1020 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03
            END CASE
         END FOREACH
      END IF
     #TQC-BC0056---End---
     #判斷細項立沖否
      IF l_aag20_1 <> l_aag20_2  THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag20",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag20",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_520 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03
            END CASE
         END FOREACH
      END IF
     #傳票項次異動別
      IF l_aag222_1 <> l_aag222_2 THEN
         LET l_gaq03 = " "
         OPEN r816_c_gaq03 USING "aag222",g_lang
         IF STATUS THEN
            CALL cl_err("OPEN r816_c_gaq03:", STATUS, 1)
            CLOSE r816_c_gaq03
         END IF
         FETCH r816_c_gaq03 INTO l_gaq03
         IF SQLCA.sqlcode THEN
            CALL cl_err("aag222",SQLCA.sqlcode,0)
         END IF
         LET l_row=l_row+1
         LET tmp1[l_row].abg00 = tm.n_abg00 #g_abg.abg00
         LET tmp1[l_row].abg01 = g_abh.abh01
         LET tmp1[l_row].abg06 = g_abh.abh021
         LET tmp1[l_row].aag01 = g_abh.abh03
         LET tmp1[l_row].aag02 = l_aag02 
         FOREACH r816_c_521 INTO l_ze02,l_ze03
            CASE l_ze02
               WHEN "0"
                  LET tmp1[l_row].msg0  = l_gaq03,"-",l_ze03
               WHEN "1"
                  LET tmp1[l_row].msg1  = l_gaq03,"-",l_ze03
               WHEN "2"
                  LET tmp1[l_row].msg2  = l_gaq03,"-",l_ze03
            END CASE
         END FOREACH
      END IF
      FOR i=1 TO l_row
         EXECUTE insert_prep USING
                 j,i,tmp1[i].abg00,tmp1[i].abg01,tmp1[i].abg06
                ,tmp1[i].aag01,tmp1[i].aag02,tmp1[i].msg0,tmp1[i].msg1,tmp1[i].msg2
      END FOR
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET g_str = ""
   CALL cl_prt_cs3('aglr816','aglr816',g_sql,g_str) 
END FUNCTION

