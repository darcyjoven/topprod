# Prog. Version..: '5.30.06-13.03.25(00006)'     #
#
# Pattern name...: aglp802.4gl
# Descriptions...: 立沖帳餘額拋轉作業
# Date & Author..: NO.FUN-BC0092 12/04/10 By Lori
# Modify.........: No:CHI-C20025 12/04/12 By Lori 匯率增加小數位數取位
# Modify.........: No:CHI-C90002 12/09/14 By Belle 修正錯誤訊息
# Modify.........: No:FUN-C90083 12/09/20 By Belle 立沖帳資料由abi_file匯入
# Modify.........: No:MOD-CA0105 12/10/16 by Polly 檢核資料是否重覆增加項次條件判斷
# Modify.........: No:MOD-CA0206 12/10/29 By Polly 金額以餘額方成寫入
# Modify.........: No:CHI-CB0068 12/12/03 By Belle 提供重覆拋轉功能 
# Modify.........: No:FUN-CB0111 13/01/03 By Belle 增加action

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   tm  RECORD
             o_abg00     LIKE abg_file.abg00,
             n_abg00     LIKE abg_file.abg00,
             yy          LIKE type_file.num5,  #FUN-C90083
             mm          LIKE type_file.num5,  #FUN-C90083
            #o_abg01     LIKE abg_file.abg01,  #FUN-C90083 mark
            #b_abg06     LIKE abg_file.abg06,  #FUN-C90083 mark
            #e_abg06     LIKE abg_file.abg06,  #FUN-C90083 mark
             abg06       LIKE abg_file.abg06
         END RECORD
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   l_flag          LIKE type_file.chr1
DEFINE   g_change_lang   LIKE type_file.chr1
DEFINE   ls_date         STRING
DEFINE   g_more          LIKE type_file.chr1
DEFINE   g_open          LIKE type_file.chr1
DEFINE   g_aaa07         LIKE aaa_file.aaa07
DEFINE   g_argv1         LIKE abg_file.abg00

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF s_aglshut(0) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF cl_null(g_more) THEN
      LET g_more = 'N'
   END IF

   WHILE TRUE
      IF g_more = 'N' THEN
         CALL p802()
         IF cl_sure(16,21) THEN
            CALL  cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
           #CHI-CB0068--(B)--
            LET g_cnt = 0
            SELECT count(*) INTO g_cnt
              FROM abg_file
             WHERE abg00 = tm.n_abg00 AND YEAR(abg06) = tm.yy AND MONTH(abg06) = tm.mm 
            IF g_cnt > 0 THEN
               IF cl_confirm("axc-096") THEN
                  DELETE FROM abg_file
                   WHERE abg00 = tm.n_abg00 
                     AND abg15 = '2'
               ELSE
                  LET g_success = 'N'
                  EXIT WHILE
               END IF
            END IF
           #CHI-CB0068--(E)--
            CALL  p802_abg()
            CALL s_showmsg()
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF NOT cl_null(g_argv1) THEN
              CLOSE WINDOW p802_w
              EXIT WHILE
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p802_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL  p802_abg()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p802()
DEFINE     p_row,p_col    LIKE type_file.num5,
           l_sw           LIKE type_file.chr1,          #重要欄位是否空白
           l_cmd          LIKE type_file.chr1000,
           lc_cmd         LIKE type_file.chr1000
DEFINE     li_chk_bookno  LIKE type_file.num5
DEFINE     l_sql          STRING
DEFINE     l_aaa01        LIKE aaa_file.aaa01
DEFINE     l_chr          LIKE type_file.chr1
DEFINE     l_aac16        LIKE aac_file.aac16

   LET p_row = 2 LET p_col = 26
   IF cl_null(l_flag) THEN
      OPEN WINDOW p802_w AT p_row,p_col WITH FORM "agl/42f/aglp802"
        ATTRIBUTE (STYLE = g_win_style)
   END IF

   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
     #DISPLAY tm.o_abg00 TO o_abg00   #FUN-C90083 mark
     #DISPLAY tm.n_abg00 TO n_abg00   #FUN-C90083 mark
     #DISPLAY tm.o_abg01 TO o_abg01   #FUN-C90083 mark
     #DISPLAY tm.b_abg06 TO b_abg06   #FUN-C90083 mark
     #DISPLAY tm.e_abg06 TO e_abg06   #FUN-C90083 mark
      DISPLAY g_open     TO opening
      DISPLAY tm.abg06   TO abg06
      DISPLAY g_more     TO more
   ELSE
      INITIALIZE tm.* TO NULL
     #LET tm.o_abg00 = g_aaz.aaz64    #FUN-C90083 mark
     #LET tm.n_abg00 = g_aaz.aaz64    #FUN-C90083 mark
     #LET tm.b_abg06 = g_today        #FUN-C90083 mark
     #LET tm.e_abg06 = g_today        #FUN-C90083 mark
   END IF

   WHILE TRUE
      LET g_more = "N"
     #INPUT tm.o_abg00,tm.n_abg00,tm.o_abg01,tm.b_abg06,tm.e_abg06,g_open,g_more               #FUN-C90083 mark
      #FROM o_abg00,n_abg00,o_abg01,b_abg06,e_abg06,opening,more                               #FUN-C90083 mark
      INPUT tm.o_abg00,tm.n_abg00,tm.yy,tm.mm,g_open,tm.abg06,g_more                           #FUN-C90083
            WITHOUT DEFAULTS
       FROM o_abg00,n_abg00,yy,mm,opening,abg06,more                                           #FUN-C90083

         BEFORE INPUT
           #FUN-C90083--B--
            LET g_open = 'Y'
            DISPLAY g_open TO opening
            CALL cl_set_comp_entry("abg06",FALSE)
           #FUN-C90083--E--
            IF NOT cl_null(g_argv1) THEN
              #CALL cl_set_comp_entry("o_abg00,n_abg00,o_abg01,b_abg06,e_abg06,opening",FALSE) #FUN-C90083 mark
               CALL cl_set_comp_entry("o_abg00,n_abg00,yy,mm,opening",FALSE)                   #FUN-C90083
            ELSE
              #CALL cl_set_comp_entry("o_abg00,n_abg00,o_abg01,b_abg06,e_abg06,opening",TRUE)  #FUN-C90083 mark
               CALL cl_set_comp_entry("o_abg00,n_abg00,yy,mm,opening",TRUE)                    #FUN-C90083
            END IF
        #FUN-C90083--begin---
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(o_abg00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  CALL cl_create_qry() RETURNING tm.o_abg00
                  DISPLAY BY NAME tm.o_abg00
                  NEXT FIELD o_abg00
               WHEN INFIELD(n_abg00) #帳別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  CALL cl_create_qry() RETURNING tm.n_abg00
                  DISPLAY BY NAME tm.n_abg00
                  NEXT FIELD n_abg00
            END CASE
        #FUN-C90083---End---
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

            IF NOT cl_null(tm.n_abg00) THEN
               LET g_cnt = 0		 #FUN-C90083
               SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=tm.n_abg00
               IF g_cnt =0 THEN
                  CALL cl_err('','anm-062',0)
                  NEXT FIELD CURRENT
               END IF
               LET g_cnt = 0	     #FUN-C90083
               SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01 = tm.n_abg00 AND aaa13 = 'Y'
               IF g_cnt = 0 THEN	 #FUN-C90083
                  CALL cl_err('','agl1026',0)
                  NEXT FIELD CURRENT
               END IF   
            END IF   

            CALL s_check_bookno(tm.n_abg00,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
                NEXT FIELD CURRENT
            END IF
        #FUN-C90083--begin--
         ON CHANGE opening
            IF g_open = 'N' THEN
               CALL cl_set_comp_entry("abg06",TRUE)
               NEXT FIELD abg06
            ELSE 
               CALL cl_set_comp_entry("abg06",FALSE)
            END IF 
         AFTER FIELD abg06 
            IF NOT cl_null(tm.abg06) THEN
               SELECT aaa07 INTO g_aaa07
                 FROM aaa_file WHERE aaa01 = tm.n_abg00
               IF tm.abg06 <= g_aaa07 THEN               #判斷傳票日期是否小於關帳日期
                  CALL cl_err(tm.abg06,'agl-200',0)
                  NEXT FIELD CURRENT
               END IF
            END IF
        #FUN-C90083---end---
        #FUN-C90083--begin mark--
        #AFTER FIELD o_abg01
        #   IF cl_null(tm.o_abg01) THEN
        #      NEXT FIELD CURRENT
        #   END IF
        #   IF tm.o_abg01 != '*' THEN
        #      LET l_aac16 = NULL
        #      SELECT aac16 INTO l_aac16 FROM aac_file
        #       WHERE aac01 = tm.o_abg01
        #         AND aacacti='Y'
        #      IF cl_null(l_aac16) OR l_aac16 = 'N' THEN
        #         CALL cl_err('','agl-530',0)
        #         NEXT FIELD CURRENT
        #      END IF
        #   END IF
        #AFTER FIELD e_abg06
        #   IF NOT cl_null(tm.e_abg06) THEN
        #      IF tm.b_abg06 > tm.e_abg06 THEN
        #         NEXT FIELD CURRENT
        #      END IF
        #   END IF
        #FUN-C90083---end mark---
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

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         #FUN-CB0111--B--
         ON ACTION p8021
           CALL cl_cmdrun("aglp8021")
         #FUN-CB0111--E--
      END INPUT
     #FUN-C90083--Begin Mark--
     #INPUT tm.abg06 WITHOUT DEFAULTS FROM abg06
     #   BEFORE INPUT
     #      IF g_open = 'N' THEN
     #         CALL cl_set_comp_entry("abg06",TRUE)
     #         NEXT FIELD abg06
     #      ELSE
     #         CALL cl_set_comp_entry("abg06",FALSE)
     #      END IF
     #   AFTER FIELD abg06
     #      IF NOT cl_null(tm.abg06) THEN
     #         SELECT aaa07 INTO g_aaa07
     #           FROM aaa_file WHERE aaa01 = tm.n_abg00 
     #         IF tm.abg06 <= g_aaa07 THEN               #判斷傳票日期是否小於關帳日期
     #            CALL cl_err(tm.abg06,'agl-200',0)
     #            NEXT FIELD CURRENT
     #         END IF
     #      END IF
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE INPUT
     #   ON ACTION exit
     #      LET INT_FLAG = 1
     #      EXIT INPUT
     #   ON ACTION qbe_save
     #      CALL cl_qbe_save()
     #   ON ACTION locale
     #      LET g_change_lang = TRUE
     #      EXIT INPUT
     #END INPUT
     #FUN-C90083---End Mark---

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_more = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aglp802'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp802','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.o_abg00 CLIPPED, "'",
                         " '",tm.n_abg00 CLIPPED, "'",
                        #" '",tm.o_abg01 CLIPPED, "'",    #FUN-C90083 mark
                        #" '",tm.b_abg06 CLIPPED, "'",    #FUN-C90083 mark
                        #" '",tm.e_abg06 CLIPPED, "'",    #FUN-C90083 mark
                         " '",tm.yy CLIPPED, "'",         #FUN-C90083
                         " '",tm.mm CLIPPED, "'",         #FUN-C90083
                         " '",g_more CLIPPED, "'"
            CALL cl_cmdat('aglp802',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p802_abg()
   DEFINE l_sql     STRING,
          l_sql2    STRING,
          l_n       LIKE type_file.num5,
          l_i       LIKE type_file.num10,
          l_chr     LIKE type_file.chr1,
          l_count   LIKE type_file.num5,             #記錄一個科目在目標帳套中存在的個數
         #sr        RECORD LIKE abg_file.*           #FUN-C90083 mark
          sr        RECORD LIKE abi_file.*           #FUN-C90083
   DEFINE l_abg     RECORD LIKE abg_file.*
   DEFINE l_aaa03_1 LIKE aaa_file.aaa03,             #來源帳幣別
          l_aaa03_2 LIKE aaa_file.aaa03,             #拋轉帳幣別
          l_azi04   LIKE azi_file.azi04,             #取位
          l_abb25   LIKE abb_file.abb25,             #匯率  
          l_tag05   LIKE tag_file.tag05	             #FUN-C90083
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
   DEFINE l_aag05_1,l_aag05_2    LIKE aag_file.aag05
   DEFINE l_aag21_1,l_aag21_2    LIKE aag_file.aag21
   DEFINE l_aag23_1,l_aag23_2    LIKE aag_file.aag23

   CALL s_showmsg_init()
   SELECT aaa07 INTO g_aaa07
     FROM aaa_file WHERE aaa01 = tm.n_abg00
  #FUN-C90083--Begin Mark--
  #IF tm.o_abg01 = '*' THEN
  #   LET l_sql = "SELECT abg_file.* FROM abg_file,aag_file,aac_file"
  #              ," WHERE abg00='",tm.o_abg00,"'"                   #帳別
  #              ,"   AND aag01 = abg03 AND aag20 ='Y'"
  #              ,"   AND aag00 = abg00"
  #              ,"   AND abg01[1,",g_doc_len,"]= aac01"
  #              ,"   AND aac16 = 'Y'"
  #ELSE
  #   LET l_sql = "SELECT abg_file.* FROM abg_file,aag_file,aac_file"
  #              ," WHERE abg00='",tm.o_abg00,"'"                   #帳別
  #              ,"   AND aag01 = abg03 AND aag20 ='Y'"
  #              ,"   AND aag00 = abg00"
  #              ,"   AND abg01[1,",g_doc_len,"]='",tm.o_abg01,"'"  #單別
  #              ,"   AND abg01[1,",g_doc_len,"]= aac01" 
  #              ,"   AND aac16 = 'Y'"
  #END IF
  #傳票日期
  #IF tm.b_abg06 IS NOT NULL THEN
  #   LET l_sql = l_sql CLIPPED," AND abg06  >= '",tm.b_abg06,"'"
  #END IF
  #IF tm.e_abg06 IS NOT NULL THEN
  #   LET l_sql = l_sql CLIPPED," AND abg06  <= '",tm.e_abg06,"'"
  #END IF
  #LET l_sql = l_sql CLIPPED," ORDER BY abg01"
  #FUN-C90083---End Mark---
  #FUN-C90083--B--
   LET l_sql = "SELECT * FROM abi_file "
              ," WHERE (abi08-abi09>0) AND abi00='",tm.o_abg00,"'"
              ,"   AND abi03 = ",tm.yy," AND abi04 = ",tm.mm
  #FUN-C90083--E--
   PREPARE p802_p1 FROM l_sql
   DECLARE p802_c1 CURSOR WITH HOLD FOR p802_p1

   FOREACH p802_c1 INTO sr.*
     #FUN-C90083--Begin Mark--
     #IF g_success='N' THEN
     #   LET g_totsuccess='N'
     #   LET g_success='Y'
     #END IF
     #FUN-C90083---End Mark---
      IF SQLCA.sqlcode THEN
        #CALL s_errmsg('abg00',tm.o_abg00,'foreach:',SQLCA.sqlcode,1)   #FUN-C90083 mark
         CALL s_errmsg('abi00',tm.o_abg00,'foreach:',SQLCA.sqlcode,1)   #FUN-C90083
         LET g_success ='N'
         EXIT FOREACH
      END IF

     #FUN-C90083--Begin--
     #是否有拋轉
     #LET l_count = 0
     #SELECT COUNT(*) INTO l_count FROM aba_file
     # WHERE aba00 = tm.n_abg00
     #   AND aba01 = sr.abg01
     #IF l_count = 0 THEN
     #   LET g_showmsg = sr.abg00,"/",sr.abg01
     #   CALL s_errmsg('abg00,abg01',g_showmsg,'','agl-518',1)
     #   LET g_success = 'N'
     #END IF
     #FUN-C90083---End---

     #CHI-CB0068--Begin Mark-- 
     ##檢核是否已經存在資料
     #LET l_count = 0
     #SELECT COUNT(*) INTO l_count FROM abg_file
     # WHERE abg00 = tm.n_abg00
     #   AND abg01 = sr.abi01      #FUN-C90083
     #   AND abg02 = sr.abi02      #MOD-CA0105 add
     #  #AND abg01 = sr.abg01      #FUN-C90083 mark
     #IF l_count > 0 THEN
     #  #LET g_showmsg = sr.abg00,"/",sr.abg01                       #FUN-C90083 mark
     #  	 LET g_showmsg = sr.abi00 CLIPPED,"/",sr.abi01 CLIPPED       #FUN-C90083
     #   CALL s_errmsg('abg00,abg01',g_showmsg,'','mfg-240',1)
     #   LET g_success = 'N'
     #   CONTINUE FOREACH                                            #FUN-C90083
     #END IF        
     #CHI-CB0068---END Mark---

     #檢核是否為關帳日之前的拋轉
      LET l_count = 0
     #判斷傳票日期是否小於關帳日期
     #IF g_open = 'Y' AND sr.abg06 <= g_aaa07 THEN                   #FUN-C90083 mark
     #   CALL s_errmsg('abg00,abg01',g_showmsg,'','agl-200',1)       #FUN-C90083 mark
      IF g_open = 'Y' AND sr.abi06 <= g_aaa07 THEN                   #FUN-C90083
         LET g_showmsg = sr.abi00,"/",sr.abi01                       #FUN-C90083
         CALL s_errmsg('abi00,abi01',g_showmsg,'','agl-200',1)       #FUN-C90083
         LET g_success = 'N'
         CONTINUE FOREACH                                            #FUN-C90083
      END IF
     #檢核異動碼--來源帳別
      SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181
            ,aag20,aag222,aag31,aag311,aag32,aag321,aag33,aag331
            ,aag34,aag341,aag05,aag21,aag23
        INTO l_aag15_1,l_aag151_1,l_aag16_1,l_aag161_1,l_aag17_1
            ,l_aag171_1,l_aag18_1,l_aag181_1,l_aag20_1,l_aag222_1
            ,l_aag31_1,l_aag311_1,l_aag32_1,l_aag321_1,l_aag33_1
            ,l_aag331_1,l_aag34_1,l_aag341_1,l_aag05_1,l_aag21_1
            ,l_aag23_1
        FROM aag_file
       WHERE aag00 = tm.o_abg00
         AND aag01 = sr.abi05    #FUN-C90083
        #AND aag01 = sr.abg03    #FUN-C90083 mark
         AND aagacti = 'Y'
	#FUN-C90083--B--
      LET l_tag05 = ''
      SELECT tag05 INTO l_tag05 FROM tag_file
       WHERE tag01 = tm.yy    AND tag02 = sr.abi00
         AND tag03 = sr.abi05 AND tag06 = '1' AND tagacti = 'Y'
      IF cl_null(l_tag05) THEN
         LET g_showmsg = sr.abi00 CLIPPED,"/",sr.abi05 CLIPPED
         CALL s_errmsg('abi00,abi05',g_showmsg,'','agl1038',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
     #FUN-C90083--E--
     #檢核異動碼--拋轉帳別
      SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181
            ,aag20,aag222,aag31,aag331,aag32,aag321,aag33,aag331
            ,aag34,aag341,aag05,aag21,aag23
        INTO l_aag15_2,l_aag151_2,l_aag16_2,l_aag161_2,l_aag17_2
            ,l_aag171_2,l_aag18_2,l_aag181_2,l_aag20_2,l_aag222_2
            ,l_aag31_2,l_aag311_2,l_aag32_2,l_aag321_2,l_aag33_2
            ,l_aag331_2,l_aag34_2,l_aag341_2,l_aag05_2,l_aag21_2
            ,l_aag23_2
        FROM aag_file
       WHERE aag00 = tm.n_abg00
         AND aag01 = l_tag05     #FUN-C90083
        #AND aag01 = sr.abg03    #FUN-C90083 mark
         AND aagacti = 'Y'
      LET l_count = 0
      SELECT COUNT(*) INTO l_count FROM aag_file
       WHERE aag00 = tm.n_abg00
         AND aag01 = l_tag05     #FUN-C90083
        #AND aag01 = sr.abg03    #FUN-C90083 mark
         AND aagacti = 'Y'
      IF l_count = 0 THEN
        #LET g_showmsg = tm.n_abg00,"/",sr.abg03                     #FUN-C90083 mark
        #CALL s_errmsg('abg00,abg03',g_showmsg,'','agl-229',1)       #FUN-C90083 mark
         LET g_showmsg = tm.n_abg00,"/",sr.abi05                     #FUN-C90083
         CALL s_errmsg('abi00,abi05',g_showmsg,'','agl-229',1)       #FUN-C90083
         LET g_success = 'N'
      END IF
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
      IF cl_null(l_aag05_1)  THEN LET l_aag05_1  =' '  END IF
      IF cl_null(l_aag21_1)  THEN LET l_aag21_1  =' '  END IF
      IF cl_null(l_aag23_1)  THEN LET l_aag23_1  =' '  END IF
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
      IF cl_null(l_aag05_2)  THEN LET l_aag05_2  =' '  END IF
      IF cl_null(l_aag21_2)  THEN LET l_aag21_2  =' '  END IF
      IF cl_null(l_aag23_2)  THEN LET l_aag23_2  =' '  END IF
      IF l_aag15_1 <> l_aag15_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag15"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag15_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag15_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag15',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag151_1 <> l_aag151_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag151"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag151_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag151_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag151',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag16_1 <> l_aag16_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag16"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag16_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag16_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag16',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag161_1 <> l_aag161_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag161"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag161_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag161_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag161',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag17_1 <> l_aag17_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag17"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag17_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag17_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag17',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag171_1 <> l_aag171_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag171"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag171_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag171_1 CLIPPED  #CHI-C90002
         CALL s_errmsg('abg00,abg03,aag171',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag18_1 <> l_aag18_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag11"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag18_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag18_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag18',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag181_1 <> l_aag181_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag181"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag181_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag181_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag181',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag31_1 <> l_aag31_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag31"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag31_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag31_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag31',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag311_1 <> l_aag311_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag311"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag311_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag311_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag311',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag32_1 <> l_aag32_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag32"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag32_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag32_1 CLIPPED  #CHI-C90002
         CALL s_errmsg('abg00,abg03,aag32',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag321_1 <> l_aag321_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag321"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag321_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag321_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag321',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag33_1 <> l_aag33_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag33"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag33_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag33_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag33',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag331_1 <> l_aag331_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag331"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag331_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag331_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag331',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag34_1 <> l_aag34_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag34"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag34_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag34_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag34',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
      IF l_aag341_1 <> l_aag341_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag341"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag341_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag341_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag341',g_showmsg,'','agl-519',1)
         LET g_success = 'N'
      END IF
     #判斷部門管理
      IF l_aag05_1 <> l_aag05_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag051"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag05_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag05_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag051',g_showmsg,'','agl1020',1)
         LET g_success = 'N'
      END IF
     #細項立沖
      IF l_aag20_1 <> l_aag20_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag20"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag20_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag20_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag20',g_showmsg,'','agl-520',1)
         LET g_success = 'N'
      END IF
      IF l_aag222_1 <> l_aag222_2 THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag222"           #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag222_1 CLIPPED  #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag222_1 CLIPPED  #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag222',g_showmsg,'','agl-521',1)
         LET g_success = 'N'
      END IF
     #預算控制
      IF l_aag21_1 <> l_aag21_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag21"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag21_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag21_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag21',g_showmsg,'','agl1024',1)
         LET g_success = 'N'
      END IF
     #專案控制
      IF l_aag23_1 <> l_aag23_2  THEN
        #LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag23"            #CHI-C90002 mark
        #LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abg03 CLIPPED,"/",l_aag23_1 CLIPPED   #FUN-C90083 mark #CHI-C90002
         LET g_showmsg = tm.o_abg00 CLIPPED,"/",sr.abi05 CLIPPED,"/",l_aag23_1 CLIPPED   #FUN-C90083
         CALL s_errmsg('abg00,abg03,aag23',g_showmsg,'','agl1025',1)
         LET g_success = 'N'
      END IF
     #CHI-CB0068--Begin Mark--
     ##Delete
     #DELETE FROM abg_file WHERE abg00 = tm.n_abg00
     #                       AND abg01 = sr.abi01  #FUN-C90083
     #                       AND abg02 = sr.abi02  #FUN-C90083
     #                      #AND abg01 = sr.abg01  #FUN-C90083 mark
     #                      #AND abg02 = sr.abg02  #FUN-C90083 mark
     #CHI-CB0068---End Mark---
     #LET l_abg.* = sr.*                           #FUN-C90083 mark
      LET l_abg.abg00=tm.n_abg00
     #LET l_abg.abg06 = tm.abg06                   #FUN-C90083 mark
     #FUN-C90083--B--
      LET l_abg.abg01 = sr.abi01
      LET l_abg.abg02 = sr.abi02
      LET l_abg.abg03 = l_tag05
      LET l_abg.abg04 = sr.abi10   #摘要
      LET l_abg.abg05 = sr.abi07   #部門
      LET l_abg.abg11 = sr.abi11   #異動碼-1
      LET l_abg.abg12 = sr.abi12   #異動碼-2
      LET l_abg.abg13 = sr.abi13   #異動碼-3
      LET l_abg.abg14 = sr.abi14   #異動碼-4
      LET l_abg.abg31 = sr.abi31   #異動碼-5
      LET l_abg.abg32 = sr.abi32   #異動碼-6
      LET l_abg.abg33 = sr.abi33   #異動碼-7
      LET l_abg.abg34 = sr.abi34   #異動碼-8
     #LET l_abg.abg071= sr.abi08              #立帳金額 #MOD-CA0206 mark
     #LET l_abg.abg072= sr.abi09              #已沖金額 #MOD-CA0206 mark
      LET l_abg.abg071= sr.abi08 - sr.abi09   #立帳金額 #MOD-CA0206 add
      LET l_abg.abg072= 0                     #已沖金額 #MOD-CA0206 add
      LET l_abg.abg073= 0
      LET l_abg.abglegal=g_legal 
     #FUN-C90083--E--

      SELECT aaa03 INTO l_aaa03_1 FROM aaa_file WHERE aaa01 = tm.o_abg00
      SELECT aaa03 INTO l_aaa03_2 FROM aaa_file WHERE aaa01 = tm.n_abg00
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = l_aaa03_2     #CHI-C20025 add
     #來源帳別幣別與目地帳別幣別相同時,傳票金額不需重算
      IF l_aaa03_1 <> l_aaa03_2 THEN
        #匯率抓取應依參數設定aza19(1.月平均 2.每日),
        #再決定要抓取每月或每日匯率                #M:銀行中價匯率
        #CALL s_curr3(l_aaa03_2,l_abg.abg06,'M') RETURNING l_abb25        #FUN-C90083
         CALL s_curr3(l_aaa03_2,sr.abi06,'M') RETURNING l_abb25           #FUN-C90083
         LET l_abg.abg071 = l_abb25 * l_abg.abg071                        #立帳金額
         LET l_abg.abg072 = l_abb25 * l_abg.abg072                        #已沖金額
        #LET l_abg.abg073 = l_abb25 * l_abg.abg073                        #FUN-C90083 mark
         LET l_abg.abg071 = cl_digcut(l_abg.abg071,l_azi04)               #CHI-C20025 add
         LET l_abg.abg072 = cl_digcut(l_abg.abg072,l_azi04)               #CHI-C20025 add
        #LET l_abg.abg073 = cl_digcut(l_abg.abg073,l_azi04)               #FUN-C90083 mark #CHI-C20025 add
      END IF
      IF cl_null(l_abg.abg071) THEN LET l_abg.abg071 = 0 END IF           #FUN-C90083
      IF cl_null(l_abg.abg072) THEN LET l_abg.abg072 = 0 END IF           #FUN-C90083
     #立帳金額 = 立帳金額 - 已沖金額 - 預沖金額
     #LET l_abg.abg071 = l_abg.abg071 - (l_abg.abg072 + l_abg.abg073)     #FUN-C90083 mark
     #開帳日期
      IF g_open = 'N' THEN
         LET l_abg.abg06 = tm.abg06
      ELSE                             #FUN-C90083
         LET l_abg.abg06 = sr.abi06    #FUN-C90083
      END IF

     #來源(由aglp802拋轉來源設為2)
      LET l_abg.abg15 = '2'
     #FUN-C90083--Begin Mark--
     #IF cl_null(l_abg.abg071) THEN
     #   LET l_abg.abg071 = 0
     #   LET g_success = 'N'
     #END IF
     #LET l_abg.abg072 = 0
     #LET l_abg.abg073 = 0
     #LET l_abg.abg11 = sr.abg11
     #LET l_abg.abg12 = sr.abg12
     #LET l_abg.abg13 = sr.abg13
     #LET l_abg.abg14 = sr.abg14
     #LET l_abg.abg31 = sr.abg31
     #LET l_abg.abg32 = sr.abg32
     #LET l_abg.abg33 = sr.abg33
     #LET l_abg.abg34 = sr.abg34
     #FUN-C90083---End Mark---
      IF cl_null(l_abg.abg11) THEN LET l_abg.abg11 = "" END IF
      IF cl_null(l_abg.abg12) THEN LET l_abg.abg12 = "" END IF
      IF cl_null(l_abg.abg13) THEN LET l_abg.abg13 = "" END IF
      IF cl_null(l_abg.abg14) THEN LET l_abg.abg14 = "" END IF
      IF cl_null(l_abg.abg31) THEN LET l_abg.abg31 = "" END IF
      IF cl_null(l_abg.abg32) THEN LET l_abg.abg32 = "" END IF
      IF cl_null(l_abg.abg33) THEN LET l_abg.abg33 = "" END IF
      IF cl_null(l_abg.abg34) THEN LET l_abg.abg34 = "" END IF
      LET l_abg.abg35 = ""
      LET l_abg.abg36 = ""
     #FUN-C90083--B--
      LET sr.abi00 = tm.n_abg00
      LET sr.abi08 = l_abg.abg071
	  LET sr.abi09 = l_abg.abg072
     #FUN-C90083--E--
      INSERT INTO abg_file VALUES(l_abg.*)
      IF STATUS THEN
         CALL s_errmsg('insert abg_file','','',STATUS,1)
         LET g_success = 'N'
      END IF
    END FOREACH
   #FUN-C90083--Begin Mark--
   #IF g_totsuccess="N" THEN
   #   LET g_success="N"
   #END IF
   #FUN-C90083---End Mark---
END FUNCTION
