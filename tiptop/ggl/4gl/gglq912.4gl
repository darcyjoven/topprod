# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglq912.4gl
# Descriptions...: 集團利潤表列印
# Date & Author..: 08/08/26 By Carrier  #No.FUN-8A0028
# Modify.........: No.MOD-910123 09/01/13 By wujie   年結后，有部門編號時不應抓CE類的傳票金額
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/07 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70025 10/07/13 By Summer 將本來不應該是實際ERP table 的都改成 create temp table
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds  #No.FUN-8A0028
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.num5,
              b       LIKE aaa_file.aaa01,      #帳別編號
              axa02   LIKE axa_file.axa02,      #上層公司
              axa01   LIKE axa_file.axa01,      #集團編號
              a       LIKE mai_file.mai01,      #報表結構
              yy      LIKE type_file.num5,
              bm      LIKE type_file.num5,
              em      LIKE type_file.num5,
              c       LIKE type_file.chr1,      #余額為零
              d       LIKE type_file.chr1,      #金額單位
              e       LIKE type_file.num5,      #小數位數
              f       LIKE type_file.num5,      #層級
              h       LIKE type_file.chr4,      #額外名稱
              o       LIKE type_file.chr1,      #轉換幣種
              p       LIKE azi_file.azi01,      #打印幣種
              q       LIKE azj_file.azj03,      #匯率
              r       LIKE azi_file.azi01,      #總帳幣種
              more    LIKE type_file.chr1
              END RECORD,
          bdate,edate LIKE type_file.dat,
          i,j,k       LIKE type_file.num5,
          g_unit      LIKE type_file.num10,
          g_bookno    LIKE aah_file.aah00,
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_bal_a     DYNAMIC ARRAY OF RECORD
                      maj02      LIKE maj_file.maj02,
                      maj03      LIKE maj_file.maj03,
                      maj21      LIKE maj_file.maj21,
                      maj22      LIKE maj_file.maj22,
                      maj24      LIKE maj_file.maj24,
                      maj25      LIKE maj_file.maj25,
                      bal1       LIKE aah_file.aah05,
                      bal2       LIKE aah_file.aah05,
                      lbal1      LIKE aah_file.aah05,
                      lbal2      LIKE aah_file.aah05,
                      maj08      LIKE maj_file.maj08,
                      maj09      LIKE maj_file.maj09
                      END RECORD,
 
          g_basetot1  LIKE aah_file.aah05,
          g_basetot2  LIKE aah_file.aah05
 
 
DEFINE   g_formula   DYNAMIC ARRAY OF RECORD
                        maj02        LIKE maj_file.maj02,
                        maj27        LIKE maj_file.maj27,
                        lbal1,lbal2  LIKE aah_file.aah05,
                        bal1,bal2    LIKE aah_file.aah05
                     END RECORD,
         g_sql       STRING,
         g_for_str   STRING,
         g_ser_str   STRING,
         g_str_len   LIKE type_file.num5,
         g_str_cnt   LIKE type_file.num5,
         g_for_cnt   LIKE type_file.num5,
         g_beg_pos   LIKE type_file.num5,
         g_end_pos   LIKE type_file.num5,
         g_lbasetot1 LIKE aah_file.aah05,
         g_lbasetot2 LIKE aah_file.aah05
 
DEFINE   l_ac            LIKE type_file.num10
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_msg1          LIKE type_file.chr1000
 
DEFINE   g_str           STRING
DEFINE   l_table         STRING
 
DEFINE g_cnt  LIKE type_file.num5
 
 
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_rec_b1   LIKE type_file.num10
DEFINE   g_aag      DYNAMIC ARRAY OF RECORD
                    aag01  LIKE maj_file.maj20,
                    cnt    LIKE type_file.num10,
                    sum1   LIKE aah_file.aah04,
                    sum2   LIKE aah_file.aah04,
                    sum3   LIKE aah_file.aah04,
                    sum4   LIKE aah_file.aah04,
                    sum5   LIKE aah_file.aah04,
                    sum6   LIKE aah_file.aah04,
                    sum7   LIKE aah_file.aah04,
                    sum8   LIKE aah_file.aah04,
                    sum9   LIKE aah_file.aah04,
                    sum10  LIKE aah_file.aah04,
                    sum11  LIKE aah_file.aah04,
                    sum12  LIKE aah_file.aah04,
                    sum13  LIKE aah_file.aah04,
                    sum14  LIKE aah_file.aah04,
                    sum15  LIKE aah_file.aah04,
                    sum16  LIKE aah_file.aah04,
                    sum17  LIKE aah_file.aah04,
                    sum18  LIKE aah_file.aah04,
                    sum19  LIKE aah_file.aah04,
                    sum20  LIKE aah_file.aah04
                    END RECORD
DEFINE   g_pr_ar    DYNAMIC ARRAY OF RECORD
                    maj20  LIKE maj_file.maj20,
                    maj02  LIKE maj_file.maj02,
                    maj03  LIKE maj_file.maj03,
                    maj26  LIKE maj_file.maj26,
                    bal1   LIKE aah_file.aah05,
                    bal2   LIKE aah_file.aah05,
                    lbal1  LIKE aah_file.aah05,
                    lbal2  LIKE aah_file.aah05,
                    line   LIKE type_file.num5,
                    maj06  LIKE maj_file.maj06
                    END RECORD
DEFINE   g_pr       RECORD
                    cnt    LIKE type_file.num10,
                    maj20  LIKE maj_file.maj20,
                    maj02  LIKE maj_file.maj02,
                    maj03  LIKE maj_file.maj03,
                    line   LIKE type_file.num5,
                    maj06  LIKE maj_file.maj06
                    END RECORD
DEFINE   g_title    DYNAMIC ARRAY OF RECORD
                    axb04  LIKE axb_file.axb04,
                    axb05  LIKE axb_file.axb05,
                    dbs    LIKE azp_file.azp03,
                    azp02  LIKE azp_file.azp02,
                    azp01  LIKE azp_file.azp01   #FUN-A50102
                    END RECORD
 
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
 
   LET tm.rtype   = '2'
   LET g_bookno   = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.b       = ARG_VAL(8)
   LET tm.axa02   = ARG_VAL(9)
   LET tm.axa01   = ARG_VAL(10)
   LET tm.a       = ARG_VAL(11)
   LET tm.yy      = ARG_VAL(12)
   LET tm.bm      = ARG_VAL(13)
   LET tm.em      = ARG_VAL(14)
   LET tm.c       = ARG_VAL(15)
   LET tm.d       = ARG_VAL(16)
   LET tm.e       = ARG_VAL(17)
   LET tm.f       = ARG_VAL(18)
   LET tm.h       = ARG_VAL(19)
   LET tm.o       = ARG_VAL(20)
   LET tm.p       = ARG_VAL(21)
   LET tm.q       = ARG_VAL(22)
   LET tm.r       = ARG_VAL(23)
   LET tm.rtype   = ARG_VAL(24)
 
   LET g_rep_user = ARG_VAL(25)
   LET g_rep_clas = ARG_VAL(26)
   LET g_template = ARG_VAL(27)
   LET g_rpt_name = ARG_VAL(28)
 
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW q912_w AT 5,10
        WITH FORM "ggl/42f/gglq912_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("cnt",FALSE)
 
   DROP TABLE gglq912_tmp;
   CREATE TEMP TABLE gglq912_tmp(
   cnt    LIKE type_file.num10,
   maj20  LIKE maj_file.maj20,
   maj02  LIKE maj_file.maj02,
   maj03  LIKE maj_file.maj03,
   axb04  LIKE axb_file.axb04,
   bal1   LIKE aah_file.aah04,
   bal2   LIKE aah_file.aah04,
   line   LIKE type_file.num5,
   maj06  LIKE maj_file.maj06);
 
   DROP TABLE gglq912_tmp1;
   #CREATE TEMP TABLE gglq912_tmp1(
   #CHI-A70025 mod CREAT TABLE gglq912_tmp1-> CREAT TEMP TABLE gglq912_tmp1
   CREATE TEMP TABLE gglq912_tmp1(
   cnt    DECIMAL(10),
   maj21  VARCHAR(24),
   maj22  VARCHAR(24),
   maj24  VARCHAR(10),
   maj25  VARCHAR(10));
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL q912_tm()
   ELSE
      CALL q912()
   END IF
   CALL q912_menu()
   DROP TABLE gglq912_tmp1;
   CLOSE WINDOW q912_w
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
 
END MAIN
 
FUNCTION q912_menu()
   WHILE TRUE
      CALL q912_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q912_tm()
            END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL q912_out()
#           END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  CALL q912_drill_down()
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q912_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5
 
   CALL s_dsmark(tm.b)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW q912_w1 AT p_row,p_col WITH FORM "ggl/42f/gglq912"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('bm',FALSE)
 
   CALL s_shwact(0,0,tm.b)
   CALL cl_opmsg('p')
 
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)
   END IF
 
   INITIALIZE tm.* TO NULL
 
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)
   END IF
 
   LET tm.b     = g_aza.aza81
   LET tm.yy    = YEAR(g_today)
   LET tm.bm    = MONTH(g_today)
   LET tm.em    = MONTH(g_today)
   LET tm.c     = 'Y'
   LET tm.d     = '1'
   LET tm.f     = 0
   LET tm.h     = 'N'
   LET tm.o     = 'N'
   LET tm.p     = g_aaa03
   LET tm.q     = 1
   LET tm.r     = g_aaa03
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.axa02,tm.axa01,tm.a,
                  tm.yy,tm.bm,tm.em,
                  tm.c,tm.d,tm.e,tm.f,tm.h,tm.o,tm.r,
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS
 
       BEFORE INPUT
          CALL cl_qbe_init()
          CALL cl_set_comp_entry("p,q",TRUE)
          IF tm.o = 'N' THEN
             CALL cl_set_comp_entry("p,q",FALSE)
          END IF
 
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT INPUT
 
       AFTER FIELD b
          IF cl_null(tm.b) THEN NEXT FIELD b END IF
          IF NOT cl_null(tm.b) THEN
             CALL s_check_bookno(tm.b,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF
             SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti ='Y'
             IF STATUS THEN
                CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)
                NEXT FIELD b
             END IF
          END IF
 
       AFTER FIELD axa02
          IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
          IF NOT cl_null(tm.axa02) THEN
             SELECT axz02 FROM axz_file WHERE axz01 = tm.axa02
             IF SQLCA.sqlcode THEN
                CALL cl_err3('sel','axz_file',tm.axa02,'','mfg9142','','',0)
                NEXT FIELD axa02
             END IF
          END IF
 
       AFTER FIELD axa01
          IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
          IF NOT cl_null(tm.axa01) THEN
             SELECT DISTINCT axa01 FROM axa_file WHERE axa01 = tm.axa01
             IF SQLCA.sqlcode THEN
                CALL cl_err3('sel','axa_file',tm.axa01,'',SQLCA.sqlcode,'','',0)
                NEXT FIELD axa01
             END IF
          END IF
 
       AFTER FIELD a
         IF tm.a IS NULL THEN NEXT FIELD a END IF
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
            CALL cl_err(tm.a,g_errno,1)
            NEXT FIELD a
         END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND maiacti = 'Y'
            AND mai00 = tm.b
         IF STATUS THEN
            CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)
            NEXT FIELD a
         END IF
 
      AFTER FIELD yy
         IF tm.yy IS NULL OR tm.yy <= 0 THEN
            NEXT FIELD yy
         END IF
 
      BEFORE FIELD bm
         IF tm.rtype='1' THEN
            LET tm.bm = 0
            DISPLAY '' TO bm
         END IF
 
      AFTER FIELD bm
         IF tm.bm IS NULL THEN NEXT FIELD bm END IF
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
 
      AFTER FIELD em
         IF tm.em IS NULL THEN NEXT FIELD em END IF
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
         LET tm.bm = tm.em
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[1234]'  THEN
            NEXT FIELD d
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 10000 END IF
         IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
      AFTER FIELD e
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME  tm.e
         END IF
 
      AFTER FIELD f
         IF tm.f IS NULL OR tm.f < 0  THEN
            LET tm.f = 0
            DISPLAY BY NAME tm.f
            NEXT FIELD f
         END IF
 
      AFTER FIELD h
         IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
      BEFORE FIELD o
         CALL cl_set_comp_entry("p,q",TRUE)
 
      AFTER FIELD o
         IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
         IF tm.o = 'N' THEN
            LET tm.p = g_aaa03
            LET tm.q = 1
            DISPLAY g_aaa03 TO p
            DISPLAY BY NAME tm.q
            CALL cl_set_comp_entry("p,q",FALSE)
         END IF
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
            NEXT FIELD p
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
         IF tm.yy IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy
            CALL cl_err('',9033,0)
        END IF
         LET tm.bm = tm.em
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
        IF tm.d = '1' THEN LET g_unit = 1 END IF
        IF tm.d = '2' THEN LET g_unit = 1000 END IF
        IF tm.d = '3' THEN LET g_unit = 10000 END IF
        IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(b) OR INFIELD(axa01) OR INFIELD(axa02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axa'
               LET g_qryparam.default1 = tm.axa01
               LET g_qryparam.default2 = tm.axa02
               LET g_qryparam.default3 = tm.b
               CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.b
               DISPLAY BY NAME tm.axa01,tm.axa02,tm.b
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mai00 = '",tm.b,"'"
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
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q912_w1 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
       WHERE zz01='gglq912'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglq912','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_bookno   CLIPPED,"'",
                         " '",g_pdate    CLIPPED,"'",
                         " '",g_towhom   CLIPPED,"'",
                         " '",g_rlang    CLIPPED,"'",
                         " '",g_bgjob    CLIPPED,"'",
                         " '",g_prtway   CLIPPED,"'",
                         " '",g_copies   CLIPPED,"'",
                         " '",tm.b       CLIPPED,"'",
                         " '",tm.axa02   CLIPPED,"'",
                         " '",tm.axa01   CLIPPED,"'",
                         " '",tm.a       CLIPPED,"'",
                         " '",tm.yy      CLIPPED,"'",
                         " '",tm.bm      CLIPPED,"'",
                         " '",tm.em      CLIPPED,"'",
                         " '",tm.c       CLIPPED,"'",
                         " '",tm.d       CLIPPED,"'",
                         " '",tm.e       CLIPPED,"'",
                         " '",tm.f       CLIPPED,"'",
                         " '",tm.h       CLIPPED,"'",
                         " '",tm.o       CLIPPED,"'",
                         " '",tm.p       CLIPPED,"'",
                         " '",tm.q       CLIPPED,"'",
                         " '",tm.r       CLIPPED,"'",
                         " '",tm.rtype   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
         CALL cl_cmdat('gglq912',g_time,l_cmd)
      END IF
      CLOSE WINDOW q912_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CLOSE WINDOW q912_w1
   CALL q912()
   ERROR ""
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION q912()
   DEFINE l_name    LIKE type_file.chr20
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql     STRING      #NO.FUN-910082 
   DEFINE l_chr     LIKE type_file.chr1
   DEFINE l_za05    LIKE type_file.chr1000
   DEFINE amt1,amt2,amt3    LIKE aah_file.aah05
 
   DEFINE l_maj08   LIKE maj_file.maj08
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_sw      LIKE type_file.num5
   DEFINE sr  RECORD
              bal1,bal2   LIKE aah_file.aah05,
              lbal1,lbal2 LIKE aah_file.aah05
              END RECORD
   DEFINE l_i       LIKE type_file.num5
 
   DEFINE l_split   LIKE type_file.chr10
   DEFINE l_axb04   LIKE axb_file.axb04
   DEFINE l_axb05   LIKE axb_file.axb05
   DEFINE l_axz03   LIKE axz_file.axz03
   DEFINE l_dbs_sep LIKE type_file.chr50
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_plant   LIKE azp_file.azp01    #FUN-A50102
   DEFINE l_sum1    LIKE aah_file.aah04
   DEFINE l_sum2    LIKE aah_file.aah04
   DEFINE l_sum3    LIKE aah_file.aah04
   DEFINE l_sum4    LIKE aah_file.aah04
   DEFINE l_sum5    LIKE aah_file.aah04
   DEFINE l_sum6    LIKE aah_file.aah04
   DEFINE l_sum7    LIKE aah_file.aah04
   DEFINE l_sum8    LIKE aah_file.aah04
   DEFINE l_bm1     LIKE type_file.num5
   DEFINE l_bm2     LIKE type_file.num5
   DEFINE l_em1     LIKE type_file.num5
   DEFINE l_em2     LIKE type_file.num5
   DEFINE l_dbs     LIKE azp_file.azp03
   DEFINE l_j       LIKE type_file.num5
   DEFINE l_k       LIKE type_file.num5
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.b
        AND aaf02 = g_rlang
 
     DELETE FROM gglq912_tmp;
     DELETE FROM gglq912_tmp1;
 
     CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
          WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
          OTHERWISE         LET g_msg=" 1=1"
     END CASE
     LET l_sql = "SELECT * FROM maj_file",
                 " WHERE maj01 = '",tm.a,"'",
                 "   AND ",g_msg CLIPPED,
                 " ORDER BY maj02"
     PREPARE q912_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM END IF
     DECLARE q912_c CURSOR FOR q912_p
 
     CASE cl_db_get_database_type()
        WHEN "IFX"  LET l_split = ':'
        WHEN "ORA"  LET l_split = '.'
     END CASE
 
     DECLARE axb_curs CURSOR FOR
      SELECT UNIQUE axb04,axb05,axz03 FROM axb_file,axz_file
       WHERE axb01 = tm.axa01
         AND axb02 = tm.axa02
         AND axb03 = tm.b
         AND axb04 = axz01
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare axb_curs',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     LET g_title[1].axb04 = tm.axa02
     LET g_title[1].axb05 = tm.b
     #SELECT azp02,azp03 INTO l_azp02,l_dbs
     SELECT azp01,azp02,azp03 INTO l_plant,l_azp02,l_dbs   #FUN-A50102
       FROM azp_file,axz_file
      WHERE axz01 = tm.axa02
        AND axz03 = azp01
     LET l_dbs_sep = l_dbs CLIPPED,l_split
     LET g_title[1].dbs = l_dbs_sep
     LET g_title[1].azp02 = l_azp02
     LET g_title[1].azp01 = l_plant  #FUN-A50102
 
     LET g_i = 2
     FOREACH axb_curs INTO l_axb04,l_axb05,l_axz03
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach axb_curs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #SELECT azp02,azp03 INTO l_azp02,l_dbs FROM azp_file
        SELECT azp01,azp02,azp03 INTO l_plant,l_azp02,l_dbs FROM azp_file   #FUN-A50102
         WHERE azp01 = l_axz03
        IF SQLCA.sqlcode THEN
           CONTINUE FOREACH
        END IF
        LET l_dbs_sep = l_dbs CLIPPED,l_split
        LET g_title[g_i].axb04 = l_axb04
        LET g_title[g_i].axb05 = l_axb05
        LET g_title[g_i].dbs   = l_dbs_sep
        LET g_title[g_i].azp02 = l_azp02
        LET g_title[g_i].azp01 = l_plant   #FUN-A50102
        LET g_i = g_i + 1
    END FOREACH
    LET g_i = g_i - 1
    FOR l_k = 1 TO g_i
        LET l_dbs_sep = g_title[l_k].dbs
        LET l_axb05 = g_title[l_k].axb05
        LET l_plant =  g_title[l_k].azp01  #FUN-A50102
 
        #LET g_sql = "SELECT SUM(aah04),SUM(aah05) FROM ",l_dbs_sep CLIPPED,"aah_file,",
        #                                                 l_dbs_sep CLIPPED,"aag_file ",
        LET g_sql = "SELECT SUM(aah04),SUM(aah05) FROM ",cl_get_target_table(l_plant,'aah_file'),",", #FUN-A50102
                                                         cl_get_target_table(l_plant,'aag_file'),     #FUN-A50102
                    " WHERE aah00 = aag00 AND aah01 = aag01 ",
                    "   AND aag07 IN ('2','3') ",
                    "   AND aah00 = '",l_axb05,"'",
                    "   AND aah01 BETWEEN ? AND ?",
                    "   AND aah02 = ",tm.yy,
                    "   AND aah03 BETWEEN ? AND ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE q912_aah1 FROM g_sql
 
        #LET g_sql = "SELECT SUM(aao05),SUM(aao06) FROM ",l_dbs_sep CLIPPED,"aao_file,",
        #                                                 l_dbs_sep CLIPPED,"aag_file ",
        LET g_sql = "SELECT SUM(aao05),SUM(aao06) FROM ",cl_get_target_table(l_plant,'aao_file'),",", #FUN-A50102
                                                         cl_get_target_table(l_plant,'aag_file'),     #FUN-A50102
                    " WHERE aao00 = aag00 AND aao01 = aag01 ",
                    "   AND aag07 IN ('2','3') ",
                    "   AND aao00 = '",l_axb05,"'",
                    "   AND aao01 BETWEEN ? AND ? ",
                    "   AND aao02 BETWEEN ? AND ? ",
                    "   AND aao03 = ",tm.yy,
                    "   AND aao04 BETWEEN ? AND ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE q912_aao1 FROM g_sql
 
        #LET g_sql = "SELECT SUM(abb07) FROM ",l_dbs_sep CLIPPED,"abb_file,",
        #                                      l_dbs_sep CLIPPED,"aba_file ",
        LET g_sql = "SELECT SUM(abb07) FROM ",cl_get_target_table(l_plant,'abb_file'),",", #FUN-A50102
                                              cl_get_target_table(l_plant,'aba_file'),     #FUN-A50102
                    " WHERE aba00 = abb00 AND aba01 = abb01",
                    "   AND abb00 = '",l_axb05,"'",
                    "   AND abb03 BETWEEN ? AND ?",
                    "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 = ",tm.yy,
                    "   AND aba04 BETWEEN ? AND ? ",
                    "   AND aba19 <> 'X' "  #CHI-C80041
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE q912_abb1 FROM g_sql
 
        CALL g_bal_a.clear()
        LET g_cnt = 1
        FOREACH q912_c INTO maj.*
           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           LET amt1 = 0 LET amt2 = 0 LET amt3=0
           IF maj.maj06 NOT MATCHES '[12345]' THEN CONTINUE FOREACH END IF
 
           IF NOT cl_null(maj.maj21) THEN
              CASE maj.maj06
                   WHEN '1'   LET l_bm1 = 0      LET l_em1 = tm.bm - 1
                              LET l_bm2 = 0      LET l_em2 = tm.bm - 1
                   WHEN '2'   LET l_bm1 = tm.bm  LET l_em1 = tm.em
                              LET l_bm2 = 1      LET l_em2 = tm.em
                   WHEN '3'   LET l_bm1 = 0      LET l_em1 = tm.em
                              LET l_bm2 = 0      LET l_em1 = tm.em
                   WHEN '4'   LET l_bm1 = tm.bm  LET l_em1 = tm.em
                              LET l_bm2 = 1      LET l_em2 = tm.em
                   WHEN '5'   LET l_bm1 = tm.bm  LET l_em1 = tm.em
                              LET l_bm2 = 1      LET l_em2 = tm.em
              END CASE
              LET l_sum1 = 0   LET l_sum2 = 0
              LET l_sum3 = 0   LET l_sum4 = 0
              LET l_sum5 = 0   LET l_sum6 = 0
              LET l_sum7 = 0   LET l_sum7 = 0
 
              IF maj.maj24 IS NULL THEN
                 EXECUTE q912_aah1 USING maj.maj21,maj.maj22,l_bm1,l_em1 INTO l_sum1,l_sum2
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_aah1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
                 IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
                 EXECUTE q912_aah1 USING maj.maj21,maj.maj22,l_bm2,l_em2 INTO l_sum3,l_sum4
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_aah1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 IF cl_null(l_sum3) THEN LET l_sum3 = 0 END IF
                 IF cl_null(l_sum4) THEN LET l_sum4 = 0 END IF
              ELSE
                 EXECUTE q912_aao1 USING maj.maj21,maj.maj22,maj.maj24,maj.maj25,l_bm1,l_em1 INTO l_sum1,l_sum2
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_aao1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
                 IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
                 EXECUTE q912_aao1 USING maj.maj21,maj.maj22,maj.maj24,maj.maj25,l_bm2,l_em2 INTO l_sum3,l_sum4
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_aaoh1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 IF cl_null(l_sum3) THEN LET l_sum3 = 0 END IF
                 IF cl_null(l_sum4) THEN LET l_sum4 = 0 END IF
              END IF
#             IF maj.maj06 < '4' THEN
              IF maj.maj06 < '4' AND maj.maj24 IS NULL THEN     #No.MOD-910123
                 EXECUTE q912_abb1 USING maj.maj21,maj.maj22,'1',l_bm1,l_em1 INTO l_sum5
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_abb1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 EXECUTE q912_abb1 USING maj.maj21,maj.maj22,'2',l_bm1,l_em1 INTO l_sum6
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_abb1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 EXECUTE q912_abb1 USING maj.maj21,maj.maj22,'1',l_bm2,l_em2 INTO l_sum7
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_abb1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 EXECUTE q912_abb1 USING maj.maj21,maj.maj22,'2',l_bm2,l_em2 INTO l_sum8
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('execute q912_abb1',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 IF cl_null(l_sum5) THEN LET l_sum5 = 0 END IF
                 IF cl_null(l_sum6) THEN LET l_sum6 = 0 END IF
                 IF cl_null(l_sum7) THEN LET l_sum7 = 0 END IF
                 IF cl_null(l_sum8) THEN LET l_sum8 = 0 END IF
              END IF
              CASE maj.maj06
                   WHEN '1' LET amt1 = l_sum1 - l_sum2 + l_sum6 - l_sum5
                            LET amt2 = l_sum3 - l_sum4 + l_sum8 - l_sum7
                   WHEN '2' LET amt1 = l_sum1 - l_sum2 + l_sum6 - l_sum5
                            LET amt2 = l_sum3 - l_sum4 + l_sum8 - l_sum7
                   WHEN '3' LET amt1 = l_sum1 - l_sum2 + l_sum6 - l_sum5
                            LET amt2 = l_sum3 - l_sum4 + l_sum8 - l_sum7
                   WHEN '4' LET amt1 = l_sum1
                            LET amt2 = l_sum3
                   WHEN '5' LET amt1 = l_sum2
                            LET amt2 = l_sum4
              END CASE
 
           END IF
 
           IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF
           IF tm.o = 'Y' THEN LET amt2 = amt2 * tm.q END IF
           IF NOT cl_null(maj.maj21) THEN
              IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
                 LET amt1 = amt1 * -1
                 LET amt2 = amt2 * -1
              END IF
              IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
                 LET amt1 = amt1 * -1
                 LET amt2 = amt2 * -1
              END IF
              IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
                 LET amt1 = amt1 * -1
                 LET amt2 = amt2 * -1
              END IF
           END IF
 
           #for drill down
           IF l_k = 1 THEN
              IF cl_null(maj.maj22) THEN LET maj.maj22 = maj.maj21 END IF
              IF cl_null(maj.maj25) THEN LET maj.maj25 = maj.maj24 END IF
              IF maj.maj03 MATCHES '[0125]' THEN
                 IF NOT cl_null(maj.maj21) OR NOT cl_null(maj.maj22) THEN
                    INSERT INTO gglq912_tmp1 VALUES(
                           g_cnt,maj.maj21,maj.maj22,maj.maj24,maj.maj25);
                 END IF
              END IF
              IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
                 FOR l_i = g_cnt - 1 TO 1 STEP -1
                     IF maj.maj08 <= g_bal_a[l_i].maj08 THEN
                        EXIT FOR
                     END IF
                     IF g_bal_a[l_i].maj03 NOT MATCHES "[012]" THEN
                        CONTINUE FOR
                     END IF
                     IF cl_null(g_bal_a[l_i].maj22) THEN
                        LET g_bal_a[l_i].maj22 = g_bal_a[l_i].maj21
                     END IF
                     IF cl_null(g_bal_a[l_i].maj25) THEN
                        LET g_bal_a[l_i].maj25 = g_bal_a[l_i].maj24
                     END IF
                     IF NOT cl_null(g_bal_a[l_i].maj21) OR
                        NOT cl_null(g_bal_a[l_i].maj22) THEN
                        INSERT INTO gglq912_tmp1 VALUES(
                           g_cnt,g_bal_a[l_i].maj21,g_bal_a[l_i].maj22,
                           g_bal_a[l_i].maj24,g_bal_a[l_i].maj25);
                     END IF
                 END FOR
              END IF
           END IF
           #for drill down -end
 
           IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
              IF maj.maj08 = '1' THEN
                 LET g_bal_a[g_cnt].maj02 = maj.maj02
                 LET g_bal_a[g_cnt].maj03 = maj.maj03
                 LET g_bal_a[g_cnt].maj21 = maj.maj21
                 LET g_bal_a[g_cnt].maj22 = maj.maj22
                 LET g_bal_a[g_cnt].maj24 = maj.maj24
                 LET g_bal_a[g_cnt].maj25 = maj.maj25
                 LET g_bal_a[g_cnt].bal1  = amt1
                 LET g_bal_a[g_cnt].bal2  = amt2
                 LET g_bal_a[g_cnt].maj08 = maj.maj08
                 LET g_bal_a[g_cnt].maj09 = maj.maj09
              ELSE
                 LET g_bal_a[g_cnt].maj02 = maj.maj02
                 LET g_bal_a[g_cnt].maj03 = maj.maj03
                 LET g_bal_a[g_cnt].maj21 = maj.maj21
                 LET g_bal_a[g_cnt].maj22 = maj.maj22
                 LET g_bal_a[g_cnt].maj24 = maj.maj24
                 LET g_bal_a[g_cnt].maj25 = maj.maj25
                 LET g_bal_a[g_cnt].maj08 = maj.maj08
                 LET g_bal_a[g_cnt].maj09 = maj.maj09
                 LET g_bal_a[g_cnt].bal1   = amt1
                 LET g_bal_a[g_cnt].bal2   = amt2
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
                        LET l_sw = 1
                     ELSE
                        LET l_sw = -1
                     END IF
                     IF g_bal_a[l_i].maj08 >= l_maj08 THEN
                        LET g_bal_a[g_cnt].bal1 = g_bal_a[g_cnt].bal1 +
                            g_bal_a[l_i].bal1 * l_sw
                        LET g_bal_a[g_cnt].bal2 = g_bal_a[g_cnt].bal2 +
                            g_bal_a[l_i].bal2 * l_sw
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
                 LET g_bal_a[g_cnt].maj21 = maj.maj21
                 LET g_bal_a[g_cnt].maj22 = maj.maj22
                 LET g_bal_a[g_cnt].maj24 = maj.maj24
                 LET g_bal_a[g_cnt].maj25 = maj.maj25
                 LET g_bal_a[g_cnt].bal1  = amt1
                 LET g_bal_a[g_cnt].bal2  = amt2
                 LET g_bal_a[g_cnt].maj08 = maj.maj08
                 LET g_bal_a[g_cnt].maj09 = maj.maj09
              ELSE
                 LET g_bal_a[g_cnt].maj02 = maj.maj02
                 LET g_bal_a[g_cnt].maj03 = maj.maj03
                 LET g_bal_a[g_cnt].maj21 = maj.maj21
                 LET g_bal_a[g_cnt].maj22 = maj.maj22
                 LET g_bal_a[g_cnt].maj24 = maj.maj24
                 LET g_bal_a[g_cnt].maj25 = maj.maj25
                 LET g_bal_a[g_cnt].bal1  = 0
                 LET g_bal_a[g_cnt].bal2  = 0
                 LET g_bal_a[g_cnt].maj08 = maj.maj08
                 LET g_bal_a[g_cnt].maj09 = maj.maj09
              END IF
           END IF
           LET sr.bal1 = g_bal_a[g_cnt].bal1
           LET sr.bal2 = g_bal_a[g_cnt].bal2
           LET g_cnt = g_cnt + 1
 
           IF maj.maj11 = 'Y' THEN			
              LET g_basetot1=sr.bal1
              LET g_basetot2=sr.bal2
              IF maj.maj07='2' THEN
                 LET g_basetot1=g_basetot1*-1
                 LET g_basetot2=g_basetot2*-1
              END IF
           END IF
           IF maj.maj03='0' THEN CONTINUE FOREACH END IF
           IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"
              AND sr.bal1=0 AND sr.bal2=0 THEN
              CONTINUE FOREACH				
           END IF
           IF tm.f>0 AND maj.maj08 < tm.f THEN
              CONTINUE FOREACH				
           END IF
 
           IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
           LET maj.maj20= maj.maj05 SPACES,maj.maj20
           LET sr.bal1=sr.bal1/g_unit
           LET sr.bal2=sr.bal2/g_unit
           IF maj.maj04=0 THEN
              INSERT INTO gglq912_tmp VALUES(g_cnt-1,
                 maj.maj20,maj.maj02,maj.maj03,g_title[l_k].axb04,sr.bal1,sr.bal2,
                 '2',maj.maj06)
           ELSE
              INSERT INTO gglq912_tmp VALUES(g_cnt-1,
                 maj.maj20,maj.maj02,maj.maj03,g_title[l_k].axb04,sr.bal1,sr.bal2,
                 '2',maj.maj06)
              FOR i=1 TO maj.maj04
                  INSERT INTO gglq912_tmp VALUES(g_cnt-1,
                              maj.maj20,maj.maj02,'',g_title[l_k].axb04,'0','0',
                              '1',maj.maj06)
              END FOR
           END IF
        END FOREACH
     END FOR
 
#  LET g_msg = tm.title1
#  IF NOT cl_null(g_msg) THEN
#     CALL cl_set_comp_att_text("sum1",g_msg CLIPPED)
 
     FOR l_i = 1 TO g_i
         LET g_msg = g_title[l_i].azp02,'本期'
         LET l_j = l_i * 2 - 1
         LET g_msg1= "sum",l_j USING "<<<<<"
         CALL cl_set_comp_visible(g_msg1, TRUE)
         CALL cl_set_comp_att_text(g_msg1,g_msg CLIPPED)
         LET g_msg = g_title[l_i].azp02,'本年'
         LET l_j = l_i * 2
         LET g_msg1= "sum",l_j USING "<<<<<"
         CALL cl_set_comp_visible(g_msg1, TRUE)
         CALL cl_set_comp_att_text(g_msg1,g_msg CLIPPED)
     END FOR
     LET l_i = g_i + 1
     #LET g_msg = '本期合計'
     LET g_msg = '本期合計'
     LET l_j = l_i * 2 - 1
     LET g_msg1= "sum",l_j USING "<<<<<"
     CALL cl_set_comp_visible(g_msg1, TRUE)
     CALL cl_set_comp_att_text(g_msg1,g_msg CLIPPED)
     #LET g_msg = '本年合計'
     LET g_msg = '本年合計'
     LET l_j = l_i * 2
     LET g_msg1= "sum",l_j USING "<<<<<"
     CALL cl_set_comp_att_text(g_msg1,g_msg CLIPPED)
     CALL cl_set_comp_visible(g_msg1, TRUE)
 
     FOR l_i = l_j + 1 TO 20
         LET g_msg1= "sum",l_i USING "<<<<<"
         CALL cl_set_comp_visible(g_msg1,FALSE)
     END FOR
 
     DECLARE gglq912_cur CURSOR FOR
      SELECT UNIQUE cnt,maj20,maj02,maj03,line,maj06 FROM gglq912_tmp
       ORDER BY maj02,line
     CALL g_aag.clear()
     LET l_i = 1
     FOREACH gglq912_cur INTO g_pr.*
         LET g_aag[l_i].aag01 = g_pr.maj20
         LET g_aag[l_i].cnt = g_pr.cnt
         LET l_sum3 = 0
         LET l_sum4 = 0
         FOR l_j = 1 TO g_i
             LET l_sum1 = 0
             LET l_sum2 = 0
             SELECT bal1,bal2 INTO l_sum1,l_sum2 FROM gglq912_tmp
              WHERE maj02 = g_pr.maj02
                AND line = '2'
                AND axb04 = g_title[l_j].axb04
             IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
             IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
             LET l_sum3 = l_sum3 + l_sum1
             LET l_sum4 = l_sum4 + l_sum2
             CASE l_j
                  WHEN 1  LET g_aag[l_i].sum1 = l_sum1
                          LET g_aag[l_i].sum2 = l_sum2
                          LET g_aag[l_i].sum3 = l_sum3
                          LET g_aag[l_i].sum4 = l_sum4
                  WHEN 2  LET g_aag[l_i].sum3 = l_sum1
                          LET g_aag[l_i].sum4 = l_sum2
                          LET g_aag[l_i].sum5 = l_sum3
                          LET g_aag[l_i].sum6 = l_sum4
                  WHEN 3  LET g_aag[l_i].sum5 = l_sum1
                          LET g_aag[l_i].sum6 = l_sum2
                          LET g_aag[l_i].sum7 = l_sum3
                          LET g_aag[l_i].sum8 = l_sum4
                  WHEN 4  LET g_aag[l_i].sum7 = l_sum1
                          LET g_aag[l_i].sum8 = l_sum2
                          LET g_aag[l_i].sum9 = l_sum3
                          LET g_aag[l_i].sum10= l_sum4
                  WHEN 5  LET g_aag[l_i].sum9 = l_sum1
                          LET g_aag[l_i].sum10= l_sum2
                          LET g_aag[l_i].sum11= l_sum3
                          LET g_aag[l_i].sum12= l_sum4
                  WHEN 6  LET g_aag[l_i].sum11= l_sum1
                          LET g_aag[l_i].sum12= l_sum2
                          LET g_aag[l_i].sum13= l_sum3
                          LET g_aag[l_i].sum14= l_sum4
                  WHEN 7  LET g_aag[l_i].sum13= l_sum1
                          LET g_aag[l_i].sum14= l_sum2
                          LET g_aag[l_i].sum15= l_sum3
                          LET g_aag[l_i].sum16= l_sum4
                  WHEN 8  LET g_aag[l_i].sum15= l_sum1
                          LET g_aag[l_i].sum16= l_sum2
                          LET g_aag[l_i].sum17= l_sum3
                          LET g_aag[l_i].sum18= l_sum4
                  WHEN 9  LET g_aag[l_i].sum17= l_sum1
                          LET g_aag[l_i].sum18= l_sum2
                          LET g_aag[l_i].sum19= l_sum3
                          LET g_aag[l_i].sum20= l_sum4
                  WHEN 10 LET g_aag[l_i].sum19= l_sum1
                          LET g_aag[l_i].sum20= l_sum2
             END CASE
         END FOR
#        LET g_pr_ar[l_i].* = g_pr.*
         LET l_i = l_i + 1
     END FOREACH
     LET g_rec_b = l_i - 1
 
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END FUNCTION
 
FUNCTION q912_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY tm.a TO FORMONLY.maj01
   DISPLAY g_mai02 TO FORMONLY.mai02
   DISPLAY tm.yy  TO FORMONLY.yy
   DISPLAY tm.em  TO FORMONLY.mm
   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.d TO FORMONLY.unit
   DISPLAY tm.axa02 TO axa02
   DISPLAY tm.axa01 TO axa01
   IF g_aag.getLength() > 0 THEN
      DISPLAY g_title[1].azp02 TO azp02
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
 
      ON ACTION drill_detail
         LET g_action_choice="drill_detail"
         EXIT DISPLAY
 
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
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUNCTION q912_out()
#  DEFINE l_i     LIKE type_file.num10
#
#   IF g_aag.getLength() = 0  THEN RETURN END IF
#
#   LET g_sql="maj20.maj_file.maj20,",
#             "maj02.maj_file.maj02,",
#             "maj03.maj_file.maj03,",
#             "maj26.maj_file.maj26,",
#             "bal1.aah_file.aah05,",
#             "bal2.aah_file.aah05,",
#             "lbal1.aah_file.aah05,",
#             "lbal2.aah_file.aah05,",
#             "line.type_file.num5,",
#             "maj06.maj_file.maj06"
#
#   LET l_table=cl_prt_temptable('gglq912',g_sql) CLIPPED
#   IF  l_table=-1 THEN EXIT PROGRAM END IF
#   LET g_sql="INSERT INTO ds_report:",l_table CLIPPED,
#             " VALUES(?,?,?,?,?,?,?,?,?,?)"
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err('insert_prep:',status,1)   EXIT PROGRAM
#   END IF
#
#   CALL cl_del_data(l_table)
#
#   FOR l_i = 1 TO g_rec_b
#       EXECUTE insert_prep USING g_pr_ar[l_i].*
#   END FOR
#
#   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#   #LET g_str=g_mai02,';',tm.b,';',tm.a,';',tm.title1,';',tm.yy,';',tm.bm,';',
#   #          tm.em,';',tm.title2,';',tm.yy2,';',tm.bm2,';',tm.em2,';',tm.c,';',
#   #          tm.d,';',tm.e,';',tm.f,';',tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q
#   #CALL cl_prt_cs3('gglq912','gglq912',g_sql,g_str)
#END FUNCTION
 
FUNCTION q912_drill_down()
   DEFINE l_abb   DYNAMIC ARRAY OF RECORD
                  axb04   LIKE azp_file.azp02,
                  dbs     LIKE azp_file.azp03,
                  aba02   LIKE aba_file.aba02,
                  aba01   LIKE aba_file.aba01,
                  abb03   LIKE abb_file.abb03,
                  aag02   LIKE aag_file.aag02,
                  abb05   LIKE abb_file.abb05,
                  gem02   LIKE gem_file.gem02,
                  abb24   LIKE abb_file.abb24,
                  d       DEC(20,2),
                  c       DEC(20,2),
                  bal     DEC(20,2),
                  abb04   LIKE abb_file.abb04
                  END RECORD
   DEFINE l_axb04   LIKE axb_file.axb04
   DEFINE l_axb05   LIKE axb_file.axb05
   DEFINE l_dbs_sep LIKE type_file.chr50
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_k       LIKE type_file.num5
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_abb06   LIKE abb_file.abb06
   DEFINE l_maj21   LIKE maj_file.maj21
   DEFINE l_maj22   LIKE maj_file.maj22
   DEFINE l_maj24   LIKE maj_file.maj24
   DEFINE l_maj25   LIKE maj_file.maj25
   DEFINE l_date1   LIKE type_file.dat
   DEFINE l_date2   LIKE type_file.dat
   DEFINE l_date3   LIKE type_file.dat
   DEFINE l_date4   LIKE type_file.dat
   DEFINE g_debit   LIKE aah_file.aah04
   DEFINE g_credit  LIKE aah_file.aah04
   DEFINE g_tot     LIKE aah_file.aah04
   DEFINE l_d       LIKE aah_file.aah04
   DEFINE l_c       LIKE aah_file.aah04
   DEFINE l_dbs     LIKE azp_file.azp03   
   DEFINE l_dbs_old LIKE azp_file.azp03
   DEFINE l_plant   LIKE azp_file.azp01   #FUN-A50102
   DEFINE lc_tty_no    LIKE zxx_file.zxx02 
   DEFINE ls_tty_no    STRING
   DEFINE l_gbq10      LIKE gbq_file.gbq10
 
    IF g_aag[l_ac].cnt <= 0 OR cl_null(g_aag[l_ac].cnt) THEN
       RETURN
    END IF
    #LET ls_tty_no = FGL_GETENV('FGLSERVER')
    #LET lc_tty_no = ls_tty_no.trim()
    CALL fgl_getenv('LOGTTY') RETURNING lc_tty_no
    IF (lc_tty_no IS NULL) THEN                                         
       LET lc_tty_no = '-'                                              
    END IF
 
    CALL l_abb.clear()
    LET g_rec_b1 = 0
  
    DECLARE gglq912_tmp1_cs CURSOR FOR
     SELECT maj21,maj22,maj24,maj25 FROM gglq912_tmp1
      WHERE cnt = g_aag[l_ac].cnt
      ORDER BY maj21,maj22,maj24,maj25
    LET l_i = 1
    CALL s_azn01(tm.yy,tm.bm) RETURNING l_date1,l_date2
    CALL s_azn01(tm.yy,tm.em) RETURNING l_date3,l_date4
    FOR l_k = 1 TO g_i
        SELECT azp01 INTO l_dbs
          FROM azp_file,axz_file
         WHERE axz01 = g_title[l_k].axb04
           AND axz03 = azp01
 
        LET l_dbs_sep = g_title[l_k].dbs
        LET l_axb05 = g_title[l_k].axb05
        LET l_plant = g_title[l_k].azp01   #FUN-A50102
 
        LET l_j = l_i 
        LET l_abb[l_j].axb04 = g_title[l_k].azp02
        LET l_abb[l_j].aba02 = l_date1
        CALL cl_getmsg('ggl-820',g_lang) RETURNING l_abb[l_j].aag02
 
        LET l_i = l_i + 1
        #credit(period)    #debit(period)    #BOF
        LET g_credit = 0   LET g_debit = 0   LET g_tot = 0
 
        LET g_sql = " SELECT SUM(aah04),SUM(aah05) ",
                    #"   FROM ",l_dbs_sep CLIPPED,"aah_file ",
                    "   FROM ",cl_get_target_table(l_plant,'aah_file'), #FUN-A50102
                    "  WHERE aah00 = '",l_axb05,"'",
                    "    AND aah01 BETWEEN ? AND ? ",
                    "    AND aah02 = ",tm.yy,
                    "    AND aah03 < ",tm.bm
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE gglq912_aah_p1 FROM g_sql
        LET g_sql = " SELECT SUM(aao05),SUM(aao06) ",
                    #"   FROM ",l_dbs_sep CLIPPED,"aao_file ",
                    "   FROM ",cl_get_target_table(l_plant,'aao_file'), #FUN-A50102
                    "  WHERE aao00 = '",l_axb05,"'",
                    "    AND aao01 BETWEEN ? AND ? ",
                    "    AND aao02 BETWEEN ? AND ? ",
                    "    AND aao03 = ",tm.yy,
                    "    AND aao04 < ",tm.bm
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE gglq912_aao_p1 FROM g_sql
 
        FOREACH gglq912_tmp1_cs INTO l_maj21,l_maj22,l_maj24,l_maj25
           IF SQLCA.sqlcode THEN
              CALL cl_err('gglq912_tmp1_cs',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_d = 0     LET l_c = 0
           IF cl_null(l_maj24) THEN
              EXECUTE gglq912_aah_p1 USING l_maj21,l_maj22 INTO l_d,l_c
           ELSE
              EXECUTE gglq912_aao_p1 USING l_maj21,l_maj22,l_maj24,l_maj25 INTO l_d,l_c
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err('exe gglq912_aah_p1|gglq912_aao_p1',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(l_d) THEN LET l_d = 0 END IF
           IF cl_null(l_c) THEN LET l_c = 0 END IF
           LET g_tot = g_tot + l_d - l_c
 
           LET g_sql = " SELECT '','',aba02,aba01,abb03,aag02,abb05,gem02,",
                       "        abb24,abb07,abb07,abb24,0,abb06 ",
                       #"  FROM ",l_dbs_sep CLIPPED,"abb_file,",
                       #          l_dbs_sep CLIPPED,"aba_file, OUTER ",
                       #          l_dbs_sep CLIPPED,"aag_file, OUTER ",
                       #          l_dbs_sep CLIPPED,"gem_file ",
                       "  FROM ",cl_get_target_table(l_plant,'abb_file'),",",        #FUN-A50102
                                 cl_get_target_table(l_plant,'aba_file'),", OUTER ", #FUN-A50102                                 
                                 cl_get_target_table(l_plant,'aag_file'),", OUTER ", #FUN-A50102                                 
                                 cl_get_target_table(l_plant,'gem_file'),            #FUN-A50102
                       " WHERE aba00 = abb00 AND aba01 = abb01 ",
                       "   AND aba00 = '",l_axb05,"'",
                       "   AND abb03 = aag_file.aag01 ",
                       "   AND abb00 = aag_file.aag00 ",
                       "   AND abb05 = gem_file.gem01 ",
                       "   AND aba19 = 'Y' ",
                       "   AND abapost = 'Y' ",
                       "   AND aba03 = ",tm.yy,
                       "   AND aba04 BETWEEN ",tm.bm," AND ",tm.em,
                       "   AND abb03 BETWEEN '",l_maj21,"'",
                       "                 AND '",l_maj22,"'" 
           IF NOT cl_null(l_maj24) THEN
              LET g_sql = g_sql CLIPPED,
                          "   AND abb05 BETWEEN '",l_maj24,"'",
                          "                 AND '",l_maj25,"'" 
           END IF
           LET g_sql = g_sql CLIPPED," ORDER BY aba02,aba01,abb02"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
           PREPARE q912_abb12 FROM g_sql
           IF SQLCA.sqlcode THEN
              CALL cl_err('prepare q912_abb1',SQLCA.sqlcode,1)
           END IF
           DECLARE q912_abb_cs CURSOR FOR q912_abb12
           IF SQLCA.sqlcode THEN
              CALL cl_err('declare q912_abb1',SQLCA.sqlcode,1)
           END IF
           FOREACH q912_abb_cs INTO l_abb[l_i].*,l_abb06
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach q912_abb_cs',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET l_abb[l_i].dbs = l_dbs
              IF l_abb06 = '1' THEN
                 LET l_abb[l_i].c = 0 
                 LET g_debit = g_debit + l_abb[l_i].d
              END IF
              IF l_abb06 = '2' THEN
                 LET l_abb[l_i].d = 0 
                 LET g_credit= g_credit+ l_abb[l_i].c
              END IF
              LET l_abb[l_i].axb04 = g_title[l_k].azp02
   
              LET l_i = l_i + 1
           END FOREACH
 
        END FOREACH
        LET l_abb[l_j].bal = g_tot
        #AOP
        LET l_abb[l_i].axb04 = g_title[l_k].azp02
        LET l_abb[l_i].aba02 = l_date4
        CALL cl_getmsg('ggl-821',g_lang) RETURNING l_abb[l_i].aag02
        LET l_abb[l_i].bal = g_debit - g_credit + g_tot
        LET l_abb[l_i].d = g_debit
        LET l_abb[l_i].c = g_credit
        LET l_i = l_i + 1
    END FOR    
    LET g_rec_b1 = l_i - 1
 
    OPEN WINDOW q912_w2 AT 5,10
         WITH FORM "ggl/42f/gglq912_2" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("gglq912_2")
    CALL cl_set_comp_visible("dbs",FALSE)
 
    DISPLAY g_rec_b1 TO cnt
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY l_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION drill_down
         IF l_ac > 0 AND NOT cl_null(l_abb[l_ac].aba01) THEN
            UPDATE zx_file SET zx08 = l_abb[l_ac].dbs                           
             WHERE zx01=g_user                                                  
            LET l_gbq10 = l_abb[l_ac].dbs CLIPPED,'/',l_abb[l_ac].dbs           
            UPDATE gbq_file SET gbq10=l_gbq10 WHERE gbq03=g_user
            UPDATE zxx_file SET zxx03 = l_abb[l_ac].dbs
             WHERE zxx01 = g_user AND zxx02 = lc_tty_no
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               INSERT INTO zxx_file VALUES(g_user,lc_tty_no,l_abb[l_ac].dbs)
            END IF
            LET g_msg = "aglt110 '",l_abb[l_ac].aba01,"' "
            CALL cl_cmdrun_wait(g_msg)
            UPDATE zxx_file SET zxx03 = g_plant
             WHERE zxx01 = g_user AND zxx02 = lc_tty_no
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               INSERT INTO zxx_file VALUES(g_user,lc_tty_no,g_plant)
            END IF
         END IF 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         CALL cl_cmdask()
         #EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         IF cl_chk_act_auth() THEN
           CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_abb),'','')
         END IF
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CLOSE WINDOW q912_w2
 
END FUNCTION
