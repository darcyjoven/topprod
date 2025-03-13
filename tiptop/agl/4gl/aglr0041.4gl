# Prog. Version..: '5.30.06-13.04.02(00007)'     #
# PROG. VERSION..: '5.10.20-11.06.10(00000)'     #
#
# PATTERN NAME...: AGLR0041.4GL
# DESCRIPTIONS...: 股東權益變動表(總賬)
# DATE & AUTHOR..: FUN-B70031 11/07/21 BY ZHANGWEIB
# Modify.........: No.MOD-B90160 11/09/20 By belle 程式中的aya07 = 'Y'應改為'N'，才是總帳可使用
# Modify.........: No.TQC-BB0246 12/03/06 By belle g_azi(本幣取位)與t_azi(原幣取位)問題修改
# Modify.........: NO.FUN-BB0065 12/03/06 by belle 金額己是累計概念，取金額時直接取條件中的月份即可
# Modify.........: NO.MOD-C10053 12/03/06 by belle 期出金額應是當年度月數最小的那筆 
# Modify.........: No.MOD-C60248 12/07/02 By Polly 金額為0且agli005列印碼為2時，則不印出
# Modify.........: No.FUN-C80098 12/10/25 By Belle 增加列印餘額為零選項 
# Modify.........: No.MOD-D10235 13/01/25 By apo 修正報表公司名稱未顯示的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm          RECORD                 #fun-b70031
          axm01    LIKE axm_file.axm01,   #報表編號
          axz05    LIKE axz_file.axz05,   #帳別
          a        LIKE type_file.chr1,
          yy       LIKE type_file.num5,
          q1       LIKE type_file.num5,
          mm       LIKE type_file.num5,
          h1       LIKE type_file.num5,
          py       LIKE type_file.num5,
          q2       LIKE type_file.num5,
          pm       LIKE type_file.num5,
          h2       LIKE type_file.num5,
          d        LIKE type_file.chr1,
          e        LIKE type_file.chr1,
          MORE     LIKE type_file.chr1
         ,c        LIKE type_file.chr1            #FUN-C80098
                   END RECORD
DEFINE k_n         LIKE type_file.num5,
       g_bookno    LIKE type_file.chr8,
       g_unit      LIKE type_file.num10,
       l_unit      LIKE zaa_file.zaa08
DEFINE g_title     DYNAMIC ARRAY OF LIKE type_file.chr50
DEFINE g_axm       DYNAMIC ARRAY OF RECORD LIKE axm_file.*
DEFINE i,j,g_no    LIKE type_file.num5
DEFINE k           LIKE type_file.num5
DEFINE sr          ARRAY[30] OF RECORD
          y1       LIKE type_file.num5,
          m1       LIKE type_file.num5,
          y2       LIKE type_file.num5,
          m2       LIKE type_file.num5,
          y3       LIKE type_file.num5,
          m3       LIKE type_file.num5
                   END RECORD
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg       LIKE ze_file.ze03
DEFINE g_cnt       LIKE type_file.num5
DEFINE g_cnt1      LIKE type_file.num5
DEFINE l_table     STRING
DEFINE l_table1    STRING
DEFINE g_str       STRING
DEFINE g_sql       STRING
DEFINE g_tot       ARRAY[100] OF  LIKE type_file.num20_6
DEFINE g_aaa03     LIKE aaa_file.aaa03

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("agl")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = "l_i.type_file.num5,",
               "axm03.axm_file.axm03,",
               "axm09.axm_file.axm09,",
               "axm05.axm_file.axm05,",
               "axm04.axm_file.axm04,",
               "axm10.axm_file.axm10,",
               "amt1.type_file.num20_6,",
               "g_y_1.type_file.num20_6,",
               "g_y_2.type_file.num20_6,",
               "g_y_3.type_file.num20_6,",
               "g_y_4.type_file.num20_6,",
               "g_y_5.type_file.num20_6,",
               "g_y_6.type_file.num20_6,",
               "g_y_7.type_file.num20_6,",
               "g_y_8.type_file.num20_6,",
               "g_y_9.type_file.num20_6,",
               "g_y_10.type_file.num20_6,",
               "g_y_11.type_file.num20_6,",
               "g_y_12.type_file.num20_6,",
               "g_y_13.type_file.num20_6,",
               "g_y_14.type_file.num20_6,",
               "g_y_15.type_file.num20_6,",
               "g_y_16.type_file.num20_6,",
               "g_y_17.type_file.num20_6,",
               "g_y_18.type_file.num20_6,",
               "g_y_19.type_file.num20_6,",
               "g_y_20.type_file.num20_6,",
               "g_y_21.type_file.num20_6,",
               "g_y_22.type_file.num20_6,",
               "g_y_23.type_file.num20_6,",
               "g_y_24.type_file.num20_6,",
               "g_y_25.type_file.num20_6,",
               "g_y_26.type_file.num20_6,",
               "g_y_27.type_file.num20_6,",
               "g_y_28.type_file.num20_6,",
               "g_y_29.type_file.num20_6,",
               "g_y_30.type_file.num20_6"

   LET l_table = cl_prt_temptable('aglr0041',g_sql) CLIPPED   # 產生temp table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # temp table產生

   LET g_sql = "l_i.type_file.num5,",
               "title_1.type_file.chr50,",
               "title_2.type_file.chr50,",
               "title_3.type_file.chr50,",
               "title_4.type_file.chr50,",
               "title_5.type_file.chr50,",
               "title_6.type_file.chr50,",
               "title_7.type_file.chr50,",
               "title_8.type_file.chr50,",
               "title_9.type_file.chr50,",
               "title_10.type_file.chr50,",
               "title_11.type_file.chr50,",
               "title_12.type_file.chr50,",
               "title_13.type_file.chr50,",
               "title_14.type_file.chr50,",
               "title_15.type_file.chr50,",
               "title_16.type_file.chr50,",
               "title_17.type_file.chr50,",
               "title_18.type_file.chr50,",
               "title_19.type_file.chr50,",
               "title_20.type_file.chr50,",
               "title_21.type_file.chr50,",
               "title_22.type_file.chr50,",
               "title_23.type_file.chr50,",
               "title_24.type_file.chr50,",
               "title_25.type_file.chr50,",
               "title_26.type_file.chr50,",
               "title_27.type_file.chr50,",
               "title_28.type_file.chr50,",
               "title_29.type_file.chr50,",
               "title_30.type_file.chr50"

   LET l_table1 = cl_prt_temptable('aglr00411',g_sql) CLIPPED   # 產生temp table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # temp table產生

   LET g_bookno = arg_val(1)
   LET g_pdate  = arg_val(2)
   LET g_towhom = arg_val(3)
   LET g_rlang  = arg_val(4)
   LET g_bgjob  = arg_val(5)
   LET g_prtway = arg_val(6)
   LET g_copies = arg_val(7)
   LET tm.axm01 = arg_val(8)
   LET tm.axz05 = arg_val(10)
   LET tm.a  = arg_val(12)
   LET tm.yy = arg_val(13)
   LET tm.q1 = arg_val(14)
   LET tm.mm = arg_val(15)
   LET tm.h1 = arg_val(16)
   LET tm.py = arg_val(17)
   LET tm.q2 = arg_val(18)
   LET tm.pm = arg_val(19)
   LET tm.h2 = arg_val(20)
   LET tm.d  = arg_val(21)
   LET tm.e  = arg_val(22)
   LET g_rep_user = arg_val(23)
   LET g_rep_clas = arg_val(24)
   LET g_template = arg_val(25)
   LET g_rpt_name = arg_val(26)
   LET tm.c = ARG_VAL(27)             #FUN-C80098

   IF g_bookno = ' ' THEN LET g_bookno = g_aaz.aaz64 END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'n' THEN
      CALL r0041_tm(0,0)
   ELSE
      CALL r0041()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r0041_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000

   LET p_row = 3 LET p_col = 22

   OPEN WINDOW r0041_w AT p_row,p_col WITH FORM "agl/42f/aglr0041"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')

 WHILE TRUE
   INITIALIZE tm.* TO NULL
   LET tm.a = '1'
   LET tm.d = '1'
   LET tm.e = 0
   LET tm.c = 'Y'            #FUN-C80098
   LET tm.more = 'n'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'n'
   LET g_copies = '1'
   DISPLAY BY NAME tm.a,tm.d,tm.e,tm.more
                  ,tm.c                      #FUN-C80098
   INPUT BY NAME tm.axz05,tm.axm01,tm.a,tm.yy,tm.q1,tm.mm,
                 tm.h1,tm.py,tm.q2,tm.pm,tm.h2,tm.d,tm.e,tm.more
                ,tm.c                        #FUN-C80098
                 WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_init()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"

      AFTER FIELD axm01
        IF cl_null(tm.axm01) THEN NEXT FIELD axm01 END IF
         SELECT COUNT(*) INTO k_n FROM axm_file
           WHERE axm01 = tm.axm01
             AND axm00 = tm.axz05
         IF k_n < 1 THEN
             CALL cl_err(tm.axm01,'mfg9002',0) NEXT FIELD axm01
         END IF

      AFTER FIELD axz05    #帳別
         IF cl_null(tm.axz05) THEN NEXT FIELD axz05 END IF
         SELECT COUNT(*) INTO k_n FROM aaa_file
          WHERE aaa01 = tm.axz05
         IF k_n = 0 THEN
            CALL cl_err(tm.axz05,'agl-946',0) NEXT FIELD axz05
         END IF

      BEFORE FIELD a
         CALL r0041_set_entry()

      ON CHANGE a
         LET tm.yy=""
         LET tm.py=""
         LET tm.q1=""
         LET tm.q2=""
         LET tm.mm=""
         LET tm.pm=""
         LET tm.h1=""
         LET tm.h2=""
         DISPLAY BY NAME tm.yy,tm.py,tm.q1,tm.q2,tm.mm,tm.pm,tm.h1,tm.h2

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN NEXT FIELD a END IF
         CALL r0041_set_no_entry()

      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         IF tm.yy < 1911 THEN LET tm.yy = tm.yy + 1911 END IF
         IF tm.a = '1' THEN
            LET tm.mm = 12
            LET tm.py = tm.yy - 1
            LET tm.pm = 12
            DISPLAY BY NAME tm.yy,tm.py
         END IF

      AFTER FIELD q1
         IF cl_null(tm.q1) AND tm.a = '2' THEN
            NEXT FIELD q1
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF
        #若輸入2007年第2季,則前期應default為2006年第2季
         LET tm.py = tm.yy - 1
         LET tm.q2 = tm.q1
         CASE tm.q1
           WHEN '1'
              LET tm.mm = 3   LET tm.pm=3
           WHEN '2'
              LET tm.mm = 6   LET tm.pm=6
           WHEN '3'
              LET tm.mm = 9   LET tm.pm=9
           WHEN '4'
              LET tm.mm = 12  LET tm.pm=12
         END CASE
         DISPLAY BY NAME tm.yy,tm.q1,tm.py,tm.q2

      AFTER FIELD mm
         IF (cl_null(tm.mm) OR tm.mm >12 OR tm.mm< 0) AND tm.a='3' THEN
            NEXT FIELD mm
         END IF
         LET tm.py = tm.yy - 1
         LET tm.pm = tm.mm
         DISPLAY BY NAME tm.yy,tm.mm,tm.py,tm.pm

      AFTER FIELD h1 #半年報
          IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.a='4' THEN
            NEXT FIELD h1
         END IF
         LET tm.py = tm.yy - 1
         LET tm.h2 = tm.h1
         IF tm.h1=1 THEN
            LET tm.mm=6  LET tm.pm=6
         ELSE
            LET tm.mm=12 LET tm.pm=12
         END IF
         DISPLAY BY NAME tm.yy,tm.h1,tm.py,tm.h2,tm.mm

      AFTER FIELD h2 #半年報
         IF (cl_null(tm.h2) OR tm.h2>2 OR tm.h2<0) AND tm.a='4' THEN
            NEXT FIELD h2
         END IF
         IF tm.h2=1 THEN
            LET tm.pm=6
         ELSE
            LET tm.pm=12
         END IF
         DISPLAY BY NAME tm.yy,tm.h1,tm.py,tm.h2,tm.pm

      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF

      AFTER FIELD e
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF

      BEFORE FIELD MORE
         DISPLAY BY NAME tm.axm01,tm.a,tm.yy,tm.q1,tm.mm,tm.py,tm.q2,tm.pm

      AFTER FIELD MORE
         IF tm.more = 'y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF

      AFTER INPUT
         IF NOT cl_null(tm.axz05) AND NOT cl_null(tm.axm01) THEN
            SELECT COUNT(*) INTO k_n FROM axm_file
             WHERE axm00 = tm.axz05
               AND axm01 = tm.axm01
            IF k_n < 1 THEN
               CALL cl_err(tm.axm01,'mfg9002',0) NEXT FIELD axm01
            END IF
         END IF
         IF tm.d = '1' THEN LET l_unit ='元'   LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET l_unit ='千元' LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET l_unit ='百萬' LET g_unit = 1000000 END IF
      ON ACTION controlr
         CALL cl_show_req_fields()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION controlp
         CASE
            WHEN INFIELD(axm01)   #報表格式
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_axm'
                LET g_qryparam.default1 = tm.axm01
                LET g_qryparam.where = "axm00 = '",tm.axz05,"'"
                CALL cl_create_qry() RETURNING tm.axm01
                DISPLAY BY NAME tm.axm01
                NEXT FIELD axm01
            WHEN INFIELD(axz05)   #帳別
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 = tm.axz05
                CALL cl_create_qry() RETURNING tm.axz05
                DISPLAY BY NAME tm.axz05
                NEXT FIELD axz05
             OTHERWISE EXIT CASE
           END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r0041_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='aglr0041'
      IF sqlca.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr0041','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.axm01 CLIPPED,"'",
                         " '",tm.axz05 CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.q1 CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.h1 CLIPPED,"'",
                         " '",tm.py CLIPPED,"'",
                         " '",tm.q2 CLIPPED,"'",
                         " '",tm.pm CLIPPED,"'",
                         " '",tm.h2 CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
                        ," '",tm.c CLIPPED,"'"         #FUN-C80098
         CALL cl_cmdat('aglr0041',g_time,l_cmd)
      END IF
      CLOSE WINDOW r0041_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r0041()
   ERROR ""
 END WHILE
   CLOSE WINDOW r0041_w
END FUNCTION

FUNCTION r0041_set_entry()

   IF INFIELD(a) THEN
      CALL cl_set_comp_entry("q1,mm,h1",TRUE)
   END IF

END FUNCTION

FUNCTION r0041_set_no_entry()

   IF INFIELD(a) THEN
      IF tm.a ="1" THEN
         CALL cl_set_comp_entry("q1,mm,h1",FALSE)
      END IF
      IF tm.a ="2" THEN
         CALL cl_set_comp_entry("mm,h1,pm,h2",FALSE)
      END IF
      IF tm.a ="3" THEN
         CALL cl_set_comp_entry("q1,h1,q2,h2",FALSE)
      END IF
      IF tm.a ="4" THEN
         CALL cl_set_comp_entry("q1,mm,q2,pm",FALSE)
      END IF
   END IF

END FUNCTION

FUNCTION r0041()
   DEFINE l_name    LIKE type_file.chr20     # external(disk) file name
   DEFINE l_sql     STRING                   # rdsql statement
   DEFINE l_bm      LIKE type_file.num5
   DEFINE l_aya     RECORD LIKE aya_file.*
   DEFINE l_aya01   LIKE aya_file.aya01
   DEFINE l_aya02   LIKE aya_file.aya02
   DEFINE l_aya06   LIKE aya_file.aya06
   DEFINE l_axm05   LIKE axm_file.axm05
   DEFINE l_axm02   LIKE axm_file.axm02
   DEFINE l_no      LIKE type_file.num5
   DEFINE l_str     STRING
   DEFINE l_axn18_1 LIKE axn_file.axn18
   DEFINE l_axn18_2 LIKE axn_file.axn18
   DEFINE l_axn18_3 LIKE axn_file.axn18   #FUN-BB0065 add
   DEFINE l_axn02_1 LIKE axn_file.axn02   #MOD-C10053 add
   DEFINE l_axn02_2 LIKE axn_file.axn02   #MOD-C10053 add
   DEFINE l_axn02_3 LIKE axn_file.axn02   #MOD-C10053 add
   DEFINE p_axo04_1 LIKE axo_file.axo04
   DEFINE p_axo04_2 LIKE axo_file.axo04
   DEFINE l_axo04_1 LIKE axo_file.axo04
   DEFINE l_axo04_2 LIKE axo_file.axo04
   DEFINE l_axo04_3 LIKE axo_file.axo04   #FUN-BB0065 add
   DEFINE l_tol     DYNAMIC ARRAY WITH DIMENSION 2 OF LIKE type_file.num20_6
   DEFINE amt1                LIKE axo_file.axo04,
          l_n,k_n,old_i       LIKE type_file.num5
   DEFINE l_i                 LIKE type_file.num5,
          l_axo04             LIKE axo_file.axo04
   DEFINE l_azi04             LIKE azi_file.azi04,
          l_azi05             LIKE azi_file.azi05

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   #MOD-D10235
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)

   LET g_sql = "insert into ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #MOD-B90160
      EXIT PROGRAM
   END IF

   LET g_sql = "insert into ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #MOD-B90160
      EXIT PROGRAM
   END IF

   SELECT axm02 INTO l_axm02 FROM axm_file WHERE axm00 = tm.axz05 AND axm01 = tm.axm01

   FOR g_i = 1 TO 100
      LET g_tot[g_i] = 0
      LET g_title[g_i] = " "
   END FOR


   CALL g_axm.clear()

   CALL r0041_dat()

   LET l_sql = "select * from axm_file ",
               " where axm01 ='",tm.axm01,"' ",
               "   and axm00 ='",tm.axz05,"' ",
               " order by axm03"

   PREPARE r0041_prepare FROM l_sql
   IF sqlca.sqlcode != 0 THEN
      CALL cl_err('prepare:',sqlca.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r0041_curs CURSOR FOR r0041_prepare

   LET g_pageno = 0
   LET g_no = 1

   CALL l_tol.clear()

   FOREACH r0041_curs INTO g_axm[g_no].*
      IF sqlca.sqlcode != 0 THEN
         CALL cl_err('foreach:',sqlca.sqlcode,1)
         EXIT FOREACH
      END IF


       LET l_sql = "select aya01,aya02,aya06 from aya_file ",
                  #" where aya07 = 'y' order by aya06"      #MOD-B90160 mark
                   " where aya07 = 'N' order by aya06"      #MOD-B90160
      PREPARE r0041_prepare1 FROM l_sql
      DECLARE r0041_curs1 CURSOR FOR r0041_prepare1

      LET l_i = 1
      FOREACH r0041_curs1 INTO l_aya01,l_aya02,l_aya06
         IF sqlca.sqlcode != 0 THEN
            CALL cl_err('foreach:',sqlca.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_title[l_i] = l_aya02
         IF g_axm[g_no].axm10 != 0 THEN
         IF cl_null(l_tol[1,l_i]) THEN LET l_tol[1,l_i] = 0 END IF

         #--FUN-BB0065 start--
         LET l_axn18_1 = 0
         LET l_axn18_2 = 0
         LET l_axn18_3 = 0
         LET l_axo04_1 = 0
         LET l_axo04_2 = 0  
         LET l_axo04_3 = 0 
         #--FUN-BB0065 end---    
         #MOD-C10053--Begin--
         LET l_axn02_1 = 0
         LET l_axn02_2 = 0  
         LET l_axn02_3 = 0 
         #MOD-C10053---End---
         #MOD-C10053--Begin--
         SELECT MIN(axn02) INTO l_axn02_1 FROM axn_file
          WHERE axn17 = l_aya01
            AND axn15 = g_axm[g_no].axm00
            AND axn01 = tm.py
            AND axn20 = 'N'
         #MOD-C10053---End---

         SELECT SUM(axn18) INTO l_axn18_1 FROM axn_file  #前期期初金額
          WHERE axn17 = l_aya01
            AND axn15 = g_axm[g_no].axm00
            #AND axn01 = sr[1].y1   #FUN-BB0065 MARK
            #AND axn02 = sr[1].m1   #FUN-BB0065 MARK
            AND axn01 = tm.py   #FUN-BB0065
           #AND axn02 = tm.mm      #MOD-C10053 MARK #FUN-BB0065
            AND axn02 = l_axn02_1  #MOD-C10053
            AND axn20 = 'N'
         IF cl_null(l_axn18_1) THEN LET l_axn18_1 = 0 END IF

#---FUN-BB0065 MARK---
#         SELECT SUM(axo04) INTO l_axo04_1 FROM axo_file  #前期各期金額
#          WHERE axo14 = l_aya01
#            AND axo15 = g_axm[g_no].axm04   #FUN-BB0065
#            AND axo12 = g_axm[g_no].axm00
#            AND axo01 = sr[1].y1
#            AND axo02 = sr[1].m1
#            AND axo16 = 'N'
#         IF cl_null(l_axo04_1) THEN LET l_axo04_1 = 0 END IF
#         LET l_axn18_1 = l_axn18_1 + l_axo04_1
#---FUN-BB0065 MARK---
        #MOD-C10053--Begin--
         SELECT MIN(axn02) INTO l_axn02_2 FROM axn_file
          WHERE axn17 = l_aya01
            AND axn15 = g_axm[g_no].axm00
            AND axn01 = tm.yy
            AND axn20 = 'N'
        #MOD-C10053---End---


         SELECT sum(axn18) INTO l_axn18_2 FROM axn_file  #當期期初金額
          WHERE axn17 = l_aya01
            AND axn15 = g_axm[g_no].axm00
            #AND axn01 = sr[3].y1            #FUN-BB0065  MARK
            #AND axn02 = sr[3].m1            #FUN-BB0065 MARK
            AND axn01 = tm.yy           #FUN-BB0065 MOD
           #AND axn02 = tm.mm               #MOD-C10053 Mark #FUN-BB0065 MOD   
            AND axn02 = l_axn02_2           #MOD-C10053 MOD   
            AND axn20 = 'N'
         IF cl_null(l_axn18_2) THEN LET l_axn18_2 = 0 END IF
        #MOD-C10053--Begin--
         SELECT MIN(axn02) INTO l_axn02_3 FROM axn_file
          WHERE axn17 = l_aya01
            AND axn15 = g_axm[g_no].axm00
            AND axn01 = tm.py - 1
            AND axn20 = 'N'
        #MOD-C10053---End---
 
#-FUN-BB0065 start--
         SELECT sum(axn18) INTO l_axn18_3 FROM axn_file  #大前年期初金額
          WHERE axn17 = l_aya01
            AND axn15 = g_axm[g_no].axm00
            AND axn01 = tm.py - 1
           #AND axn02 = tm.mm        #MOD-C10053 Mark
            AND axn02 = l_axn02_3    #MOD-C10053 Mod
            AND axn20 = 'N'
         IF cl_null(l_axn18_3) THEN LET l_axn18_3 = 0 END IF
#--FUN-BB0065 end---

#--FUN-BB0065 MARK-
#         SELECT SUM(axo04) INTO l_axo04_2 FROM axo_file  #當期各期金額
#          WHERE axo14 = l_aya01
#            AND axo12 = g_axm[g_no].axm00
#            AND axo01 = sr[3].y1 
#            AND axo02 = sr[3].m1
#            AND axo16 = 'N'
#         IF cl_null(l_axo04_2) THEN LET l_axo04_2 = 0 END IF
#         LET l_axn18_2 = l_axn18_2 + l_axo04_2
#--FUN-BB0065 MARK---

         SELECT SUM(axo04) INTO l_axo04_1 FROM axo_file  #前期各期金額
          WHERE axo14 = l_aya01
            AND axo15 = g_axm[g_no].axm04
            AND axo12 = g_axm[g_no].axm00
            #AND axo01 = sr[1].y2                       #FUN-BB0065 MARK  
            #AND axo02 BETWEEN sr[1].m2 AND sr[1].m3    #FUN-BB0065 MARK
            AND axo01 = tm.py   #FUN-BB0065 MOD
            AND axo02 = tm.mm   #FUN-BB0065 MOD
            AND axo16 = 'N'
         IF cl_null(l_axo04_1) THEN LET l_axo04_1 = 0 END IF
         SELECT SUM(axo04) INTO l_axo04_2 FROM axo_file  #當期各期金額
          WHERE axo14 = l_aya01
            AND axo15 = g_axm[g_no].axm04
            AND axo12 = g_axm[g_no].axm00
            #AND axo01 = sr[3].y2                        #FUN-BB0065 MARK
            #AND axo02 BETWEEN sr[3].m2 AND sr[3].m3     #FUN-BB0065 MARK
            AND axo01 = tm.yy   #FUN-BB0065 MOD
            AND axo02 = tm.mm   #FUN-BB0065 MOD
            AND axo16 = 'N'
         IF cl_null(l_axo04_2) THEN LET l_axo04_2 = 0 END IF

#--FUN-BB0065 start--
         SELECT SUM(axo04) INTO l_axo04_3 FROM axo_file  #當期各期金額
          WHERE axo14 = l_aya01
            AND axo15 = g_axm[g_no].axm04
            AND axo12 = g_axm[g_no].axm00
            AND axo01 = tm.py - 1
            AND axo02 = tm.mm 
            AND axo16 = 'N'
         IF cl_null(l_axo04_3) THEN LET l_axo04_3 = 0 END IF
#--FUN-BB0065 end---

         IF g_axm[g_no].axm10 = 0 THEN
            LET g_tot[l_i] = 0
         END IF

         IF g_axm[g_no].axm10 = 1 THEN
            LET l_tol[1,l_i] = 0
            #--FUN-BB0065 start
            IF g_axm[g_no].axm12 = 3 THEN
               LET g_tot[l_i] = l_axn18_3
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_axn18_3
            END IF
            #--FUN-BB0065 end---
            IF g_axm[g_no].axm12 = 2 THEN
               LET g_tot[l_i] = l_axn18_1
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_axn18_1
            END IF
            IF g_axm[g_no].axm12 = 1 THEN
               LET g_tot[l_i] = l_axn18_2
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_axn18_2
            END IF
         END IF

         IF g_axm[g_no].axm10 = 2 THEN
            #--FUN-BB0065 start--
            IF g_axm[g_no].axm12 = 3 THEN
               LET g_tot[l_i] = l_axo04_3
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_axo04_3
            END IF
            #--FUN-BB0065 end---    
            IF g_axm[g_no].axm12 = 2 THEN
               LET g_tot[l_i] = l_axo04_1
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_axo04_1
            END IF
            IF g_axm[g_no].axm12 = 1 THEN
               LET g_tot[l_i] = l_axo04_2
               LET l_tol[1,l_i] = l_tol[1,l_i] + l_axo04_2
            END IF
         END IF
         IF g_axm[g_no].axm10 = 3 THEN
            LET g_tot[l_i] = l_tol[1,l_i]
         END IF
         END IF
         LET l_i = l_i + 1
      END FOREACH

      LET l_i = l_i - 1
      LET amt1 = 0

      CALL r0041_to_dat(g_axm[g_no].axm05,g_axm[g_no].axm12)
           RETURNING g_axm[g_no].axm05
      LET l_axm05 = g_axm[g_no].axm11 SPACES,g_axm[g_no].axm05

      FOR g_i = 1 TO 100
         LET amt1 = amt1 + g_tot[g_i]
      END FOR
      LET amt1 = amt1/g_unit

     #----------------------MOD-C60248-------------------(S)
      IF g_axm[g_no].axm09 = '2' AND amt1 = 0 THEN
         CONTINUE FOREACH
      END IF
     #----------------------MOD-C60248-------------------(E)

      FOR g_i = 1 TO 100
         LET g_tot[g_i] = g_tot[g_i]/g_unit
      END FOR
     #FUN-C80098--Begin--
      IF tm.c = 'N' AND g_axm[g_no].axm10 = 2 AND amt1 = 0 THEN
         CONTINUE FOREACH
      END IF
     #FUN-C80098---End---

      EXECUTE insert_prep USING
              l_i,g_axm[g_no].axm03,g_axm[g_no].axm09,l_axm05,
              g_axm[g_no].axm04,g_axm[g_no].axm10,amt1,
              g_tot[1], g_tot[2], g_tot[3], g_tot[4], g_tot[5], g_tot[6],
              g_tot[7], g_tot[8], g_tot[9], g_tot[10],g_tot[11],g_tot[12],
              g_tot[13],g_tot[14],g_tot[15],g_tot[16],g_tot[17],g_tot[18],
              g_tot[19],g_tot[20],g_tot[21],g_tot[22],g_tot[23],g_tot[24],
              g_tot[25],g_tot[26],g_tot[27],g_tot[28],g_tot[29],g_tot[30]

      LET g_no = g_no + 1
   END FOREACH

   IF g_no = 1 THEN
      CALL cl_err('','azz-066',1)   #此報表無資料
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

  #LET l_sql ="select aya02 from aya_file where aya07 = 'y' order by aya06"   #MOD-B90160 mark
   LET l_sql ="select aya02 from aya_file where aya07 = 'N' order by aya06"   #MOD-B90160
   PREPARE r0041_pre_1 FROM l_sql
   DECLARE r0041_cur_1 CURSOR FOR r0041_pre_1

   LET l_i = 1
   FOREACH r0041_cur_1 INTO g_title[l_i]
      LET l_i = l_i + 1
   END FOREACH

  #SELECT COUNT(*) INTO g_no FROM aya_file WHERE aya07 = 'y'  #MOD-B90160 mark
   SELECT COUNT(*) INTO g_no FROM aya_file WHERE aya07 = 'N'  #MOD-B90160

   EXECUTE insert_prep1 USING g_no,
           g_title[1], g_title[2], g_title[3], g_title[4], g_title[5],
           g_title[6], g_title[7], g_title[8], g_title[9], g_title[10],
           g_title[11],g_title[12],g_title[13],g_title[14],g_title[15],
           g_title[16],g_title[17],g_title[18],g_title[19],g_title[20],
           g_title[21],g_title[22],g_title[23],g_title[24],g_title[25],
           g_title[26],g_title[27],g_title[28],g_title[29],g_title[30]

   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.axz05
   #SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file WHERE azi01 = g_aaa03
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03 #No.TQC-BB0246 modify:l_azi->t_azi

   LET l_sql = "select * from ",g_cr_db_str CLIPPED,l_table CLIPPED," order by axm03"
   LET l_sql = l_sql,"|",
               "select * from ",g_cr_db_str CLIPPED,l_table1 CLIPPED
#              p1         p2         p3         p4          p5
   LET g_str =tm.a,";", tm.yy,";",tm.q1,";",  tm.py,";",  tm.q2,";",
#              p6         p7         p8         p9          p10
              tm.mm,";",tm.pm,";",g_no,";",   tm.h1,";",  tm.h2,";",
#              p11        p12        p13        p14         p15
#              l_unit,";",tm.e,";",l_azi04,";",l_azi05,";",l_axm02
              l_unit,";",tm.e,";",t_azi04,";",t_azi05,";",l_axm02    #No.TQC-BB0246 modify:l_azi->t_azi

   CALL cl_prt_cs3('aglr0041','aglr0041',l_sql,g_str)

END FUNCTION

FUNCTION r0041_to_dat(p_str,p_axm12)
   DEFINE l_year    LIKE type_file.num5
   DEFINE l_month   LIKE type_file.num5
   DEFINE l_date    LIKE type_file.num5
   DEFINE l_str     STRING
   DEFINE l_str2    STRING
   DEFINE l_str3    STRING
   DEFINE l_str4    STRING
   DEFINE l_str5    STRING
   DEFINE l_str6    STRING
   DEFINE l_yy      STRING
   DEFINE l_mm      STRING
   DEFINE l_dd      STRING
   DEFINE p_str     LIKE axm_file.axm05
   DEFINE p_axm12   LIKE axm_file.axm12
   DEFINE l_azm     RECORD LIKE azm_file.*
   DEFINE l_azm011  LIKE azm_file.azm011

   IF p_axm12 = 3 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy - 2
      ELSE
         LET l_year  = tm.yy - 2 - 1911
      END IF
      IF g_axm[g_no].axm10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF
   IF p_axm12 = 2 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy - 1
      ELSE
         LET l_year  = tm.yy - 1911
      END IF
      IF g_axm[g_no].axm10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF
   IF p_axm12 = 1 THEN
      IF tm.yy > 1910 THEN
         LET l_year  = tm.yy
      ELSE
         LET l_year  = tm.yy - 1911
      END IF
      IF g_axm[g_no].axm10 = 1 THEN
         LET l_month = sr[1].m2
      ELSE
         LET l_month = sr[1].m3
      END IF
   END IF


   IF p_axm12 = 3 THEN
      SELECT * INTO l_azm.* FROM azm_file WHERE  azm01 = tm.yy
   ELSE
      SELECT * INTO l_azm.* FROM azm_file WHERE  azm01 = tm.py
   END IF
   CASE l_month
      WHEN 1  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm011 ELSE LET l_azm011 = l_azm.azm012 END IF
      WHEN 2  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm021 ELSE LET l_azm011 = l_azm.azm022 END IF
      WHEN 3  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm031 ELSE LET l_azm011 = l_azm.azm032 END IF
      WHEN 4  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm041 ELSE LET l_azm011 = l_azm.azm042 END IF
      WHEN 5  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm051 ELSE LET l_azm011 = l_azm.azm052 END IF
      WHEN 6  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm061 ELSE LET l_azm011 = l_azm.azm062 END IF
      WHEN 7  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm071 ELSE LET l_azm011 = l_azm.azm072 END IF
      WHEN 8  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm081 ELSE LET l_azm011 = l_azm.azm082 END IF
      WHEN 9  IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm091 ELSE LET l_azm011 = l_azm.azm092 END IF
      WHEN 10 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm101 ELSE LET l_azm011 = l_azm.azm102 END IF
      WHEN 11 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm111 ELSE LET l_azm011 = l_azm.azm112 END IF
      WHEN 12 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm121 ELSE LET l_azm011 = l_azm.azm122 END IF
      WHEN 13 IF g_axm[g_no].axm10 = 1 THEN LET l_azm011 = l_azm.azm131 ELSE LET l_azm011 = l_azm.azm132 END IF
   END CASE

   IF l_month < 10 THEN
      LET l_mm = l_month
      LET l_mm = "0",l_mm
   ELSE
      LET l_mm = l_month
   END IF
   LET l_date = DAY(l_azm011)
   IF l_date < 10 THEN
      LET l_dd = l_date
      LET l_dd = "0",l_dd
   ELSE
      LET l_dd = l_date
   END IF

   IF l_year < 100 THEN
      LET l_yy = l_year
      LET l_yy = "0" CLIPPED,l_yy
   ELSE
      LET l_yy = l_year
   END IF
   LET l_str6 = l_yy
   LET l_str  = l_yy,"/",l_mm,"/",l_dd
   LET l_str2 = l_mm,"/",l_dd,"/",l_yy
   LET l_str3 = l_dd,"/",l_mm,"/",l_yy
   LET l_str4 = l_yy.substring(3,4)
   LET l_str4 = l_str4,"/",l_mm,"/",l_dd
   IF l_year > 1910 THEN
      LET  l_yy = l_year - 1911
      IF l_yy < 100 THEN
         LET l_yy = "0" CLIPPED,l_yy
      END IF
   END IF
   LET l_str5 = l_yy,"/",l_mm,"/",l_dd
   CALL cl_replace_str(p_str,"yyyymmdd",l_str ) RETURNING p_str
   CALL cl_replace_str(p_str,"mmddyyyy",l_str2) RETURNING p_str
   CALL cl_replace_str(p_str,"ddmmyyyy",l_str3) RETURNING p_str
   CALL cl_replace_str(p_str,"yyyy",    l_str6) RETURNING p_str
   CALL cl_replace_str(p_str,"yyymmdd" ,l_str5) RETURNING p_str
   CALL cl_replace_str(p_str,"yyy"     ,l_yy  ) RETURNING p_str
   CALL cl_replace_str(p_str,"yymmdd"  ,l_str4) RETURNING p_str
   RETURN p_str
END FUNCTION

FUNCTION r0041_dat()
DEFINE l_yy,l_mm,l_mm1,l_mm2   LIKE type_file.num5
   LET l_yy = tm.py - 1
   SELECT MAX(aznn04) INTO l_mm2 FROM aznn_file          #本期期初期別
    WHERE aznn00 = tm.axz05
      AND aznn02 = l_yy
   CASE
      WHEN tm.a = '1' #年
         LET sr[1].y1 = tm.py-1 LET sr[1].m1 = l_mm2   #前期期初
         LET sr[1].y2 = tm.py   LET sr[1].m2 = 1       #前期異動(起)
         LET sr[1].y3 = tm.py   LET sr[1].m3 = l_mm2   #前期異動(迄)
         LET sr[2].y1 = tm.py   LET sr[2].m1 = l_mm2   #前期期末

         LET sr[3].y1 = tm.py   LET sr[3].m1 = l_mm2   #本期期初
         LET sr[3].y2 = tm.yy   LET sr[3].m2 = 1       #本期異動(起)
         LET sr[3].y3 = tm.yy   LET sr[3].m3 = l_mm2   #本期異動(迄)
         LET sr[4].y1 = tm.yy   LET sr[4].m1 = l_mm2   #本期期末

      WHEN tm.a = '2' #季
         LET l_yy = tm.py - 1
         SELECT MAX(aznn04) INTO l_mm FROM aznn_file
          WHERE aznn00 = tm.axz05
            AND aznn02 = l_yy
            AND aznn03 = tm.q1
         SELECT MIN(aznn04) INTO l_mm1 FROM aznn_file
          WHERE aznn00 = tm.axz05
            AND aznn02 = l_yy
            AND aznn03 = tm.q1
         IF l_mm1 = 1 THEN
            LET sr[1].y1 = tm.py-1  LET sr[1].m1 = l_mm2
         ELSE
            LET sr[1].y1 = tm.py    LET sr[1].m1 = l_mm1 - 1
         END IF
         LET sr[1].y2 = tm.py       LET sr[1].m2 = l_mm1
         LET sr[1].y3 = tm.py       LET sr[1].m3 = l_mm
         LET sr[2].y1 = tm.py       LET sr[2].m1 = l_mm
         IF l_mm1 = 1 THEN
            LET sr[3].y1 = tm.yy-1  LET sr[3].m1 = l_mm2
         ELSE
            LET sr[3].y1 = tm.yy    LET sr[3].m1 = l_mm1 - 1
         END IF
         LET sr[3].y2 = tm.yy       LET sr[3].m2 = l_mm1
         LET sr[3].y3 = tm.yy       LET sr[3].m3 = l_mm
         LET sr[4].y1 = tm.yy       LET sr[4].m1 = l_mm

      WHEN tm.a = '3' #月
         IF tm.pm = 1  THEN
            LET sr[1].y1 = tm.py-1  LET sr[1].m1 = l_mm2
         ELSE
            LET sr[1].y1 = tm.py    LET sr[1].m1 = tm.pm-1
         END IF
         LET sr[1].y2 = tm.py       LET sr[1].m2 = tm.pm
         LET sr[1].y3 = tm.py       LET sr[1].m3 = tm.pm
         LET sr[2].y1 = tm.py       LET sr[2].m1 = tm.pm

         IF tm.mm = 1  THEN
            LET sr[3].y1 = tm.yy-1  LET sr[3].m1 = l_mm2
         ELSE
            LET sr[3].y1 = tm.yy    LET sr[3].m1 = tm.mm-1
         END IF
         LET sr[3].y2 = tm.yy       LET sr[3].m2 = tm.mm
         LET sr[3].y3 = tm.yy       LET sr[3].m3 = tm.mm
         LET sr[4].y1 = tm.yy       LET sr[4].m1 = tm.mm

      WHEN tm.a='4' #半年報
         SELECT MAX(aznn04) INTO l_mm FROM aznn_file
          WHERE aznn00 = tm.axz05
            AND aznn02 = l_yy
            AND aznn03 < 3
        IF tm.h2='1' THEN
           LET sr[1].y1=tm.py-1     LET sr[1].m1=l_mm2
           LET sr[1].y2=tm.py       LET sr[1].m2=1
           LET sr[1].y3=tm.py       LET sr[1].m3=l_mm

           LET sr[3].y1=tm.py       LET sr[3].m1=l_mm2
           LET sr[3].y2=tm.yy       LET sr[3].m2=1
           LET sr[3].y3=tm.yy       LET sr[3].m3=l_mm
        ELSE
           LET sr[1].y1=tm.py       LET sr[1].m1=l_mm
           LET sr[1].y2=tm.py       LET sr[1].m2=l_mm + 1
           LET sr[1].y3=tm.py       LET sr[1].m3=l_mm2

           LET sr[3].y1=tm.py       LET sr[3].m1=l_mm
           LET sr[3].y2=tm.yy       LET sr[3].m2=l_mm + 1
           LET sr[3].y3=tm.yy       LET sr[3].m3=l_mm2
        END IF
   END CASE
END FUNCTION
