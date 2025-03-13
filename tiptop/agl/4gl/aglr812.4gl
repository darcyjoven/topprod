# Prog. Version..: '5.30.07-13.05.20(00006)'     #
#
# Pattern name...: aglr812.4gl
# Descriptions...: 多維度異動碼財務報表
# Input parameter:
# Return code....:
# Date & Author..: 10/12/23 FUN-AA0045 BY Summer
# Modify.........: No:MOD-BC0032 11/12/05 By Carrier 帐结法时,损益科目月结金额会被结清,报表呈现时,要把CE凭证的金额减回
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.CHI-C70031 12/10/18 By wangwei 加傳參數
# Modify.........: No.FUN-CB0068 13/01/07 By zhangweib QBE增加核算項1~4,aeh04~aeh07(大陸版時顯示)
#                                                      報表增加顯示核算項1~4(大陸版時顯示)
# Modify.........: No:FUN-D40044 13/04/25 By zhangweib 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額
# Modify.........: No:FUN-D70095 13/08/22 BY fengmy  參照gglq812,修改讀取agli116計算邏輯
                                                   
DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
                 wc        STRING,
                 rtype  LIKE type_file.chr1,             #報表類型
                 bookno LIKE aaa_file.aaa01,             #帳別
                 a      LIKE mai_file.mai01,             #報表代號
                 yy      LIKE type_file.num5,            #輸入年度
                 bm      LIKE type_file.num5,            #Begin 期別
                 em      LIKE type_file.num5,            #End   期別
                 e       LIKE type_file.num5,            #小數位數
                 f       LIKE type_file.num5,            #列印最小階數
                 d       LIKE type_file.chr1,            #金額單位
                 c       LIKE type_file.chr1,            #列印餘額為零者
                 h       LIKE type_file.chr4,            #列印額外名稱
                 o       LIKE type_file.chr1,            #轉換幣別
                 r       LIKE azi_file.azi01,            #總帳幣別
                 p       LIKE azi_file.azi01,            #轉換幣別
                 q       LIKE azj_file.azj03,            #乘匯率
                 ce      LIKE type_file.chr1,            #No.FUN-D40044   Add
                 more    LIKE type_file.chr1             #其它特殊列印條件
              END RECORD,
          bdate,edate    LIKE type_file.dat,
          g_mm           LIKE type_file.num5,
          g_unit         LIKE type_file.num10,           #金額單位基數
          g_bookno       LIKE aah_file.aah00,            #帳別
          g_mai02        LIKE mai_file.mai02,
          g_mai03        LIKE mai_file.mai03,
          g_tot1         ARRAY[100] OF  LIKE type_file.num20_6
   DEFINE g_aaa03        LIKE aaa_file.aaa03
   DEFINE g_i            LIKE type_file.num5             #count/index for any purpose
   DEFINE g_msg          LIKE type_file.chr1000
   DEFINE l_table         STRING
   DEFINE g_sql           STRING
   DEFINE g_str           STRING
   #No.FUN-D70095  --Begin
   DEFINE g_bal_a     DYNAMIC ARRAY OF RECORD
                      maj02      LIKE maj_file.maj02,
                      maj03      LIKE maj_file.maj03,
                      bal1       LIKE aah_file.aah05,                     
                      maj08      LIKE maj_file.maj08,
                      maj09      LIKE maj_file.maj09
                      END RECORD
   #No.FUN-D70095  --End  
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   LET g_pdate = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET g_bookno = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
   LET tm.yy = ARG_VAL(11)
   LET tm.bm = ARG_VAL(12)
   LET tm.em = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   LET tm.d  = ARG_VAL(16)
   LET tm.c  = ARG_VAL(17)
   LET tm.h  = ARG_VAL(18)
   LET tm.o  = ARG_VAL(19)
   LET tm.r  = ARG_VAL(20)
   LET tm.p  = ARG_VAL(21)
   LET tm.q  = ARG_VAL(22)
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26)
   LET tm.ce =  ARG_VAL(27)   #No.FUN-D40044   add

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "maj02.maj_file.maj02,",   #項次(排序要用的)
               "maj03.maj_file.maj03,",   #列印碼
               "line.type_file.num5,",    #1:表示此筆為空行 2:表示此筆不為空
              #No.FUN-CB0068 ---start--- Add
               "aeh04.ahe_file.ahe04,",
               "aeh05.ahe_file.ahe05,",
               "aeh06.ahe_file.ahe06,",
               "aeh07.ahe_file.ahe07,",
              #No.FUN-CB0068 ---end  --- Add
               "aeh31.aeh_file.aeh31,",
               "aeh32.aeh_file.aeh32,",
               "aeh33.aeh_file.aeh33,",
               "aeh34.aeh_file.aeh34,",
               "amt.aeh_file.aeh11,",
               "l_aeh31.ahe_file.ahe02,",
               "l_aeh32.ahe_file.ahe02,",
               "l_aeh33.ahe_file.ahe02,",
               "l_aeh34.ahe_file.ahe02,"


   LET l_table = cl_prt_temptable('aglr812',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ,?,?,?,? )"   #No.FUN-CB0068   Add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF

   IF cl_null(tm.bookno) THEN
      LET tm.bookno = g_aza.aza81
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r812_tm()
   ELSE
      CALL r812()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION r812_tm()
   DEFINE p_row,p_col       LIKE type_file.num5,
          l_sw              LIKE type_file.chr1,      #重要欄位是否空白
          l_cmd             LIKE type_file.chr1000
   DEFINE li_chk_bookno     LIKE type_file.num5
   DEFINE li_result         LIKE type_file.num5

   CALL s_dsmark(g_bookno)

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r812_w AT p_row,p_col
     WITH FORM "agl/42f/aglr812"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition

   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)
   END IF

   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)
   END IF

  #No.FUN-CB0068 ---start--- Add
   IF g_aza.aza26 != '2' THEN
      CALL cl_set_comp_visible("aeh04,aeh05,aeh06,aeh07",FALSE)
   END IF
  #No.FUN-CB0068 ---end  --- Add

   LET tm.bookno = g_aza.aza81
   LET tm.e = 0
   LET tm.f = 0
   LET tm.d = '1'
   LET tm.c = 'Y'
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.ce= 'N'   #No.FUN-D40044   Add
   LET tm.more = 'N'

   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE

      INPUT BY NAME tm.rtype WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()

         BEFORE FIELD rtype
            CALL r812_set_entry()

         AFTER FIELD rtype
            IF tm.rtype='1' THEN
               LET tm.bm=0
               CALL r812_set_no_entry()
            END IF

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME tm.wc ON aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33,aeh34    #No.FUN-CB0068 Add aeh04,aeh05,aeh06,aeh07
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
            CASE
             #No.FUN-CB0068 ---start--- Add
              WHEN INFIELD(aeh04)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh04"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh04
                NEXT FIELD aeh04
              WHEN INFIELD(aeh05)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh05"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh05
                NEXT FIELD aeh05
              WHEN INFIELD(aeh06)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh06"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh06
                NEXT FIELD aeh06
              WHEN INFIELD(aeh07)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh07"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh07
                NEXT FIELD aeh07
             #No.FUN-CB0068 ---end  --- Add
              WHEN INFIELD(aeh31)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh31"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh31
                NEXT FIELD aeh31
              WHEN INFIELD(aeh32)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh32"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh32
                NEXT FIELD aeh32
              WHEN INFIELD(aeh33)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh33"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh33
                NEXT FIELD aeh33
              WHEN INFIELD(aeh34)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aeh34"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aeh34
                NEXT FIELD aeh34
              OTHERWISE EXIT CASE
            END CASE

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      DISPLAY BY NAME tm.more

      LET l_sw = 1
      INPUT BY NAME tm.bookno,tm.a,tm.yy,tm.bm,tm.em,
                    tm.e,tm.f,tm.d,tm.c,tm.h,tm.ce,   #No.FUN-D40044   Add tm.ce
                    tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
             CALL cl_qbe_init()

         AFTER FIELD bookno
            IF tm.bookno IS NULL THEN
               NEXT FIELD bookno
            END IF

             CALL s_check_bookno(tm.bookno,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD bookno
             END IF
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.bookno AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.bookno,"",STATUS,"","sel aaa:",0)
               NEXT FIELD bookno
            END IF

         AFTER FIELD a
            IF tm.a IS NULL THEN
               NEXT FIELD a
            END IF

            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF

            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = tm.bookno
               AND maiacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)
               NEXT FIELD a
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF

         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF

         BEFORE FIELD bm
            IF tm.rtype='1' THEN
               LET tm.bm = 0
               DISPLAY '' TO bm
            END IF

         AFTER FIELD bm
            IF NOT cl_null(tm.bm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.bm > 12 OR tm.bm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD bm
                  END IF
               ELSE
                  IF tm.bm > 13 OR tm.bm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD bm
                  END IF
               END IF
            END IF

            IF tm.bm IS NULL THEN
               NEXT FIELD bm
            END IF

         AFTER FIELD em
            IF NOT cl_null(tm.em) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.em > 12 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               ELSE
                  IF tm.em > 13 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               END IF
            END IF
            IF tm.em IS NULL THEN
               NEXT FIELD em
            END IF

         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF

         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF

         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
               NEXT FIELD d
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

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c
            END IF

         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF

         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF

         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more
            END IF

         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p AND aziacti = 'Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
               NEXT FIELD p
            END IF

         BEFORE FIELD q
            IF tm.o = 'N' THEN
               NEXT FIELD o
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
            IF tm.yy IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy
               CALL cl_err('',9033,0)
            END IF
            IF tm.bm IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.bm
            END IF
            IF tm.em IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.em
            END IF
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
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

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.bookno
                  CALL cl_create_qry() RETURNING tm.bookno
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                 #LET g_qryparam.where = " mai00 = '",tm.bookno,"'"   #No.TQC-C50042   Mark
                  LET g_qryparam.where = " mai00 = '",tm.bookno,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY BY NAME tm.p
                  NEXT FIELD p

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aglr812'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr812','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",g_bookno CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('aglr812',g_time,l_cmd)    # Execute cmd at later time
         END IF

         DISPLAY "l_cmd 2:" , l_cmd
         CLOSE WINDOW r812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      CALL cl_wait()
      CALL r812()

      ERROR ""
   END WHILE

   CLOSE WINDOW r812_w

END FUNCTION

FUNCTION r812()
   DEFINE l_name    LIKE type_file.chr20
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                      #No.FUN-CB0068 ---start--- Add
                       aeh04      LIKE aeh_file.aeh04,
                       aeh05      LIKE aeh_file.aeh05,
                       aeh06      LIKE aeh_file.aeh06,
                       aeh07      LIKE aeh_file.aeh07,
                      #No.FUN-CB0068 ---end  --- Add
                       aeh31      LIKE aeh_file.aeh31,
                       aeh32      LIKE aeh_file.aeh32,
                       aeh33      LIKE aeh_file.aeh33,
                       aeh34      LIKE aeh_file.aeh34,
                       amt        LIKE aeh_file.aeh11
                    END RECORD
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE i,k       LIKE type_file.num5
   DEFINE l_aeh04   LIKE ahe_file.ahe04   #No.FUN-CB0068   Add
   DEFINE l_aeh05   LIKE ahe_file.ahe05   #No.FUN-CB0068   Add
   DEFINE l_aeh06   LIKE ahe_file.ahe06   #No.FUN-CB0068   Add
   DEFINE l_aeh07   LIKE ahe_file.ahe07   #No.FUN-CB0068   Add
   DEFINE l_aeh31   LIKE ahe_file.ahe02
   DEFINE l_aeh32   LIKE ahe_file.ahe02
   DEFINE l_aeh33   LIKE ahe_file.ahe02
   DEFINE l_aeh34   LIKE ahe_file.ahe02
   DEFINE l_i_cnt31 LIKE type_file.num5
   DEFINE l_i_cnt32 LIKE type_file.num5
   DEFINE l_i_cnt33 LIKE type_file.num5
   DEFINE l_i_cnt34 LIKE type_file.num5
   #No.MOD-BC0032  --Begin
   DEFINE l_aaa09   LIKE aaa_file.aaa09
   DEFINE l_aeh11   LIKE aeh_file.aeh11
   DEFINE l_aeh12   LIKE aeh_file.aeh12
   DEFINE l_aeh15   LIKE aeh_file.aeh15
   DEFINE l_aeh16   LIKE aeh_file.aeh16
   #No.MOD-BC0032  --End
   #No.FUN-D70095--start  
   DEFINE l_sw1        LIKE type_file.num5        
   DEFINE l_i          LIKE type_file.num5
   DEFINE g_cnt        LIKE type_file.num5            
   DEFINE l_maj08      LIKE maj_file.maj08  
   #No.FUN-D70095--end
   DEFINE l_aaz88   LIKE aaz_file.aaz88   #No.FUN-CB0068   Add

   CALL cl_del_data(l_table)

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno
      AND aaf02 = g_rlang

   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE LET g_msg = " 1=1"
   END CASE

   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r812_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r812_c CURSOR FOR r812_p

   #No.MOD-BC0032  --Begin
   SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01 = tm.bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','aaa_file',tm.bookno,'',SQLCA.sqlcode,'','select aaa09',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF cl_null(l_aaa09) THEN
      CALL cl_err('aaa09 is null','ggl-009',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #No.MOD-BC0032  --End

   LET g_mm = tm.em

   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0
   END FOR
   LET g_cnt = 1     #FUN-D70095
   FOREACH r812_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF

      LET l_flag='Y'
      LET sr.aeh04 = ''   #No.FUN-CB0068   Add
      LET sr.aeh05 = ''   #No.FUN-CB0068   Add
      LET sr.aeh06 = ''   #No.FUN-CB0068   Add
      LET sr.aeh07 = ''   #No.FUN-CB0068   Add
      LET sr.aeh31 = ''
      LET sr.aeh32 = ''
      LET sr.aeh33 = ''
      LET sr.aeh34 = ''
      LET sr.amt = 0

      IF NOT cl_null(maj.maj21) THEN
         IF cl_null(maj.maj22) THEN
            LET maj.maj22 = maj.maj21
         END IF
         LET l_sql=" SELECT aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33,aeh34,SUM(aeh11-aeh12)",   #No.FUN-CB0068   Add aeh04,aeh05,aeh06,aeh07
                   "   FROM aeh_file ",
                   "  WHERE aeh00 = '",tm.bookno,"'",
                   "    AND aeh01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
                   "    AND aeh09 =  ",tm.yy,
                   "    AND aeh10 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
                   "    AND ",tm.wc CLIPPED,
                   " GROUP BY aeh04,aeh05,aeh06,aeh07,aeh31,aeh32,aeh33,aeh34 "                  #No.FUN-CB0068   Add aeh04,aeh05,aeh06,aeh07
         PREPARE r812_prepare1 FROM l_sql
         DECLARE r812_c1  CURSOR FOR r812_prepare1
         FOREACH r812_c1 INTO sr.*
            LET l_flag='N'

            #No.TQC-BC0032  --Begin
            IF cl_null(sr.amt) THEN LET sr.amt = 0 END IF
            CALL s_minus_ce(tm.bookno, maj.maj21, maj.maj22, NULL,     NULL,     NULL,
                           #NULL,      NULL,      NULL,      NULL,     NULL,     tm.yy,   #No.FUN-CB0068   Mark
                            sr.aeh04,  sr.aeh05,  sr.aeh06,  sr.aeh07, NULL,     tm.yy,   #No.FUN-CB0068   Add
                            tm.bm,     g_mm,      NULL,      sr.aeh31, sr.aeh32, sr.aeh33,
                            sr.aeh34,  NULL,      NULL,      NULL,     g_plant,  l_aaa09,'0')   #CHI-C70031
                 RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
            #减借加贷
            IF tm.ce = 'N' THEN   #No.FUN-D40044   Add
               LET sr.amt = sr.amt - l_aeh11 + l_aeh12
            END IF                #No.FUN-D40044   Add
            #No.TQC-BC0032  --End

            #-->匯率的轉換
            IF tm.o = 'Y' THEN
               LET sr.amt = sr.amt * tm.q
            END IF
            #---------------FUN-D70095----------(S)
            IF NOT cl_null(maj.maj21) THEN
#               IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
#                  LET sr.amt = sr.amt * -1                  
#               END IF
#               IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
#                  LET sr.amt = sr.amt * -1                  
#               END IF
#               IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
#                  LET sr.amt = sr.amt * -1                  
#               END IF
                IF maj.maj07 = '2' THEN
                   LET sr.amt = sr.amt * -1    
                END IF
            END IF
            #---------------FUN-D70095----------(E)
            #-->合計階數處理
            IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
               #---------------FUN-D70095----------(S)
               IF maj.maj08 = '1' THEN
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].bal1   = sr.amt                
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09
               ELSE
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09                  
                  LET g_bal_a[g_cnt].bal1   = sr.amt                  
                  
                  FOR l_i = g_cnt - 1 TO 1 STEP -1       
                      IF maj.maj08 <= g_bal_a[l_i].maj08 THEN
                         EXIT FOR
                      END IF
                      IF g_bal_a[l_i].maj03 NOT MATCHES "[012]" THEN
                         CONTINUE FOR
                      END IF                    
                      IF l_i = g_cnt - 1 THEN       
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                      IF g_bal_a[l_i].maj09 = '+' THEN
                         LET l_sw1 = 1
                      ELSE
                         LET l_sw1 = -1
                      END IF
                      IF g_bal_a[l_i].maj08 >= l_maj08 THEN   
                         LET g_bal_a[g_cnt].bal1 = g_bal_a[g_cnt].bal1 + 
                             g_bal_a[l_i].bal1 * l_sw1                        
                      END IF
                      IF g_bal_a[l_i].maj08 > l_maj08 THEN
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                  END FOR
               END IF
          ELSE
          IF maj.maj03='5' THEN
              LET g_bal_a[g_cnt].maj02 = maj.maj02
              LET g_bal_a[g_cnt].maj03 = maj.maj03
              LET g_bal_a[g_cnt].bal1  = sr.amt              
              LET g_bal_a[g_cnt].maj08 = maj.maj08
              LET g_bal_a[g_cnt].maj09 = maj.maj09
          ELSE
              LET g_bal_a[g_cnt].maj02 = maj.maj02
              LET g_bal_a[g_cnt].maj03 = maj.maj03
              LET g_bal_a[g_cnt].bal1  = 0              
              LET g_bal_a[g_cnt].maj08 = maj.maj08
              LET g_bal_a[g_cnt].maj09 = maj.maj09
          END IF
       END IF
       LET sr.amt = g_bal_a[g_cnt].bal1       
       LET g_cnt = g_cnt + 1
       #---------------FUN-D70095----------(E)
       #---------------FUN-D70095---mark-------(S)
#               FOR i = 1 TO 100
#                  IF maj.maj09 = '-' THEN
#                     LET g_tot1[i] = g_tot1[i] - sr.amt
#                  ELSE
#                     LET g_tot1[i] = g_tot1[i] + sr.amt
#                  END IF
#               END FOR
#               LET k=maj.maj08  LET sr.amt=g_tot1[k]
#               IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
#                  LET sr.amt = sr.amt *-1
#               END IF
#
#               FOR i = 1 TO maj.maj08
#                  LET g_tot1[i] = 0
#               END FOR
#            ELSE
#               IF maj.maj03 <> '5' THEN
#                  LET sr.amt = NULL
#               END IF
#            END IF
        #---------------FUN-D70095----mark------(E)
            IF maj.maj03 = '0' THEN
               CONTINUE FOREACH
            END IF #本行不印出

            #-->餘額為 0 者不列印
            IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" AND sr.amt=0 THEN
               CONTINUE FOREACH
            END IF

            #-->最小階數起列印
            IF tm.f>0 AND maj.maj08 < tm.f THEN
               CONTINUE FOREACH
            END IF

            IF maj.maj07 = '2' THEN
               LET sr.amt = sr.amt * -1
            END IF

            #-->列印額外名稱
            IF tm.h = 'Y' THEN
               LET maj.maj20 = maj.maj20e
            END IF
            LET maj.maj20 = maj.maj05 SPACES,maj.maj20

            LET sr.amt=sr.amt/g_unit

            CALL r812_ahe02(g_aaz.aaz121) RETURNING l_aeh31
            CALL r812_ahe02(g_aaz.aaz122) RETURNING l_aeh32
            CALL r812_ahe02(g_aaz.aaz123) RETURNING l_aeh33
            CALL r812_ahe02(g_aaz.aaz124) RETURNING l_aeh34

            EXECUTE insert_prep USING
                    maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'2',
                    sr.aeh04,sr.aeh05,sr.aeh06,sr.aeh07,          #No.FUN-CB0068 Add
                    sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
                    l_aeh31,l_aeh32,l_aeh33,l_aeh34
            IF maj.maj04 > 0 THEN
               #空行的部份,以寫入同樣的maj20資料列進Temptable,
               #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
               #讓空行的這筆資料排在正常的資料前面印出
               FOR i = 1 TO maj.maj04
               EXECUTE insert_prep USING
                  maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'1',
                  sr.aeh04,sr.aeh05,sr.aeh06,sr.aeh07,          #No.FUN-CB0068 Add
                  sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
                  l_aeh31,l_aeh32,l_aeh33,l_aeh34
               END FOR
            END IF
         END FOREACH
         IF sr.aeh04 IS NULL THEN LET sr.aeh04 = '' END IF   #No.FUN-CB0068 Add
         IF sr.aeh05 IS NULL THEN LET sr.aeh05 = '' END IF   #No.FUN-CB0068 Add
         IF sr.aeh06 IS NULL THEN LET sr.aeh06 = '' END IF   #No.FUN-CB0068 Add
         IF sr.aeh07 IS NULL THEN LET sr.aeh07 = '' END IF   #No.FUN-CB0068 Add
         IF sr.aeh31 IS NULL THEN LET sr.aeh31 = '' END IF
         IF sr.aeh32 IS NULL THEN LET sr.aeh32 = '' END IF
         IF sr.aeh33 IS NULL THEN LET sr.aeh33 = '' END IF
         IF sr.aeh34 IS NULL THEN LET sr.aeh34 = '' END IF
         IF sr.amt IS NULL THEN LET sr.amt = 0 END IF
      END IF

      IF l_flag='Y' THEN

         #-->匯率的轉換
         IF tm.o = 'Y' THEN
            LET sr.amt = sr.amt * tm.q
         END IF
         #---------------FUN-D70095----------(S)
            IF NOT cl_null(maj.maj21) THEN
               IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
                  LET sr.amt = sr.amt * -1                  
               END IF
               IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
                  LET sr.amt = sr.amt * -1                  
               END IF
               IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
                  LET sr.amt = sr.amt * -1                  
               END IF
            END IF
         #---------------FUN-D70095----------(E)
         #-->合計階數處理
         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
            #---------------FUN-D70095----------(S)
               IF maj.maj08 = '1' THEN
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].bal1   = sr.amt                
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09
               ELSE
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09                  
                  LET g_bal_a[g_cnt].bal1   = sr.amt                  
                  
                  FOR l_i = g_cnt - 1 TO 1 STEP -1       
                      IF maj.maj08 <= g_bal_a[l_i].maj08 THEN
                         EXIT FOR
                      END IF
                      IF g_bal_a[l_i].maj03 NOT MATCHES "[012]" THEN
                         CONTINUE FOR
                      END IF                    
                      IF l_i = g_cnt - 1 THEN       
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                      IF g_bal_a[l_i].maj09 = '+' THEN
                         LET l_sw1 = 1
                      ELSE
                         LET l_sw1 = -1
                      END IF
                      IF g_bal_a[l_i].maj08 >= l_maj08 THEN   
                         LET g_bal_a[g_cnt].bal1 = g_bal_a[g_cnt].bal1 + 
                             g_bal_a[l_i].bal1 * l_sw1                        
                      END IF
                      IF g_bal_a[l_i].maj08 > l_maj08 THEN
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                  END FOR
               END IF
          ELSE
          IF maj.maj03='5' THEN
              LET g_bal_a[g_cnt].maj02 = maj.maj02
              LET g_bal_a[g_cnt].maj03 = maj.maj03
              LET g_bal_a[g_cnt].bal1  = sr.amt              
              LET g_bal_a[g_cnt].maj08 = maj.maj08
              LET g_bal_a[g_cnt].maj09 = maj.maj09
          ELSE
              LET g_bal_a[g_cnt].maj02 = maj.maj02
              LET g_bal_a[g_cnt].maj03 = maj.maj03
              LET g_bal_a[g_cnt].bal1  = 0              
              LET g_bal_a[g_cnt].maj08 = maj.maj08
              LET g_bal_a[g_cnt].maj09 = maj.maj09
          END IF
       END IF
       LET sr.amt = g_bal_a[g_cnt].bal1       
       LET g_cnt = g_cnt + 1
       #---------------FUN-D70095----------(E)
       #---------------FUN-D70095---mark-------(S)
#            FOR i = 1 TO 100
#               IF maj.maj09 = '-' THEN
#                  LET g_tot1[i] = g_tot1[i] - sr.amt
#               ELSE
#                  LET g_tot1[i] = g_tot1[i] + sr.amt
#               END IF
#            END FOR
#            LET k=maj.maj08  LET sr.amt=g_tot1[k]
#            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
#               LET sr.amt = sr.amt *-1
#            END IF
#
#            FOR i = 1 TO maj.maj08
#               LET g_tot1[i] = 0
#            END FOR
#         ELSE
#            IF maj.maj03 <> '5' THEN
#               LET sr.amt = NULL
#            END IF
#         END IF
      #---------------FUN-D70095---mark-------(E)
         IF maj.maj03 = '0' THEN
            CONTINUE FOREACH
         END IF #本行不印出

         #-->餘額為 0 者不列印
         IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" AND sr.amt=0 THEN
            CONTINUE FOREACH
         END IF

         #-->最小階數起列印
         IF tm.f>0 AND maj.maj08 < tm.f THEN
            CONTINUE FOREACH
         END IF
#---------------FUN-D70095---mark-------(S)
#         IF maj.maj07 = '2' THEN
#            LET sr.amt = sr.amt * -1
#         END IF
#---------------FUN-D70095---mark-------(E)
         #-->列印額外名稱
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e
         END IF
         LET maj.maj20 = maj.maj05 SPACES,maj.maj20

         LET sr.amt=sr.amt/g_unit

         CALL r812_ahe02(g_aaz.aaz121) RETURNING l_aeh31
         CALL r812_ahe02(g_aaz.aaz122) RETURNING l_aeh32
         CALL r812_ahe02(g_aaz.aaz123) RETURNING l_aeh33
         CALL r812_ahe02(g_aaz.aaz124) RETURNING l_aeh34

         EXECUTE insert_prep USING
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'2',
                 sr.aeh04,sr.aeh05,sr.aeh06,sr.aeh07,          #No.FUN-CB0068 Add
                 sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
                 l_aeh31,l_aeh32,l_aeh33,l_aeh34
         IF maj.maj04 > 0 THEN
            #空行的部份,以寫入同樣的maj20資料列進Temptable,
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
            #讓空行的這筆資料排在正常的資料前面印出
            FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING
               maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'1',
               sr.aeh04,sr.aeh05,sr.aeh06,sr.aeh07,          #No.FUN-CB0068 Add
               sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
               l_aeh31,l_aeh32,l_aeh33,l_aeh34
            END FOR
         END IF
      END IF
   END FOREACH

   LET l_i_cnt31 = 0
   LET l_i_cnt32 = 0
   LET l_i_cnt33 = 0
   LET l_i_cnt34 = 0
   IF cl_null(l_aeh31) THEN
      LET l_i_cnt31 = l_i_cnt31 + 1
      LET l_i_cnt32 = l_i_cnt32 + 1
      LET l_i_cnt33 = l_i_cnt33 + 1
      LET l_i_cnt34 = l_i_cnt34 + 1
   END IF
   IF cl_null(l_aeh32) THEN
      LET l_i_cnt32 = l_i_cnt32 + 1
      LET l_i_cnt33 = l_i_cnt33 + 1
      LET l_i_cnt34 = l_i_cnt34 + 1
   END IF
   IF cl_null(l_aeh33) THEN
      LET l_i_cnt33 = l_i_cnt33 + 1
      LET l_i_cnt34 = l_i_cnt34 + 1
   END IF
   IF cl_null(l_aeh34) THEN
      LET l_i_cnt34 = l_i_cnt34 + 1
   END IF

   SELECT aaz88 INTO l_aaz88 FROM aaz_file WHERE aaz00 = '0'   #No.FUN-CB0068   Add
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = g_mai02,";",tm.a,";",tm.e,";",l_i_cnt31,";",l_i_cnt32,";",
               l_i_cnt33,";",l_i_cnt34,";",g_aza.aza26,";",l_aaz88    #No.FUN-CB0068   Add g_aza.aza26   l_aaz88
  #No.FUN-CB0068 ---start--- Add
   IF g_aza.aza26 = '2' THEN
      CALL cl_prt_cs3('aglr812','aglr812_1',g_sql,g_str)
   ELSE
  #No.FUN-CB0068 ---end  --- Add
      CALL cl_prt_cs3('aglr812','aglr812',g_sql,g_str)
   END IF   #No.FUN-CB0068   Add

END FUNCTION

FUNCTION r812_ahe02(p_giu)
 DEFINE  p_giu     LIKE giu_file.giu15,
         l_ahe02   LIKE ahe_file.ahe02

 SELECT ahe02 INTO l_ahe02 FROM ahe_file
  WHERE ahe01 = p_giu

 RETURN l_ahe02

END FUNCTION

FUNCTION r812_set_entry()

   IF INFIELD(rtype) THEN
      CALL cl_set_comp_entry("bm",TRUE)
   END IF

END FUNCTION

FUNCTION r812_set_no_entry()

   IF INFIELD(rtype) AND tm.rtype = '1' THEN
      CALL cl_set_comp_entry("bm",FALSE)
   END IF

END FUNCTION
#FUN-AA0045
