# Prog. Version..: '5.30.06-13.04.16(00004)'     #
#
# Pattern name...: aglr113.4gl
# Descriptions...: 账户式资产负债去年同期比较表
# Date & Author..: 11/07/04 By zhangweib #FUN-B70006
# Modify.........: No.FUN-B90140 11/10/11 By minpp 增加checkbox"列印會計科目"
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-CA0212 12/10/31 By Polly l_lastday抓取時，先到用s_yp抓出正確期間來

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
            a     LIKE mai_file.mai01,        #報表結構編號  #FUN-B70006
            b     LIKE aaa_file.aaa01,        #帳別編號
            yy    LIKE type_file.num5,        #輸入年度
            bm    LIKE type_file.num5,        #Begin 期別
            yy1   LIKE type_file.num5,        #去年
            bm1   LIKE type_file.num5,        #去年同期
            c     LIKE type_file.chr1,        #異動額及餘額為0者是否列印
            d     LIKE type_file.chr1,        #金額單位
            e     LIKE type_file.num5,        #小數位數
            f     LIKE type_file.num5,        #列印最小階數
            h     LIKE type_file.chr4,        #額外說明類別
            o     LIKE type_file.chr1,        #轉換幣別否
            p     LIKE azi_file.azi01,        #幣別
            q     LIKE azj_file.azj03,        #匯率
            r     LIKE azi_file.azi01,        #幣別
            more  LIKE type_file.chr1,        #Input more condition(Y/N)
            acc_code  LIKE type_file.chr1    #FUN-B90140   Add
           END RECORD,
       i,j,k      LIKE type_file.num5,
       g_unit     LIKE type_file.num10,       #金額單位基數
       l_row      LIKE type_file.num5,
       r_row      LIKE type_file.num5,
       g_bookno   LIKE aah_file.aah00,        #帳別
       g_mai02    LIKE mai_file.mai02,
       g_mai03    LIKE mai_file.mai03,
       g_tot1     ARRAY[100] OF LIKE type_file.num20_6,
       g_tot2     ARRAY[100] OF LIKE type_file.num20_6,
       g_basetot1 LIKE aah_file.aah04,
       g_basetot2 LIKE aah_file.aah04
DEFINE g_aaa03    LIKE aaa_file.aaa03   
DEFINE g_i        LIKE type_file.num5         #count/index for any purpose
DEFINE l_table    STRING
DEFINE g_sql      STRING
DEFINE g_str      STRING
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_sql = "maj31_l.maj_file.maj31, ", #FUN-B90140 add maj31_l
               "maj20_l.maj_file.maj20,",
               "bal_l.type_file.num20_6,",
               "per_l.type_file.num20_6,",
               "bal_l_1.type_file.num20_6,",
               "per_l_1.type_file.num20_6,",
               "maj03_l.maj_file.maj03,",
               "maj02_l.maj_file.maj02,",
               "line_l.type_file.num5,",
               "maj31_r.maj_file.maj31,", #FUN-B90140 add maj31_r
               "maj20_r.maj_file.maj20,",
               "bal_r.type_file.num20_6,",
               "per_r.type_file.num20_6,",
               "bal_r_1.type_file.num20_6,",
               "per_r_1.type_file.num20_6,",
               "maj03_r.maj_file.maj03,",
               "maj02_r.maj_file.maj02,",
               "line_r.type_file.num5,",
               "l_n.type_file.num5"
               
   LET l_table = cl_prt_temptable('aglr113',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #FUN_B90140 add ?,?
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
  
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.yy = ARG_VAL(10)
   LET tm.bm = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   LET tm.h  = ARG_VAL(16)
   LET tm.o  = ARG_VAL(17)
   LET tm.p  = ARG_VAL(18)
   LET tm.q  = ARG_VAL(19)
   LET tm.r  = ARG_VAL(20)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)
   LET tm.yy1 = ARG_VAL(25)
   LET tm.bm1 = ARG_VAL(26)
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      CALL r113_tm()                            # Input print condition
   ELSE 
      CALL r113()                               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r113_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_sw           LIKE type_file.chr1      #重要欄位是否空白
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE li_result      LIKE type_file.num5
   DEFINE l_aaa03        LIKE aaa_file.aaa03
   DEFINE l_azi05        LIKE azi_file.azi05
 
   CALL s_dsmark(g_bookno)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 11
   END IF
 
   OPEN WINDOW aglr113 AT p_row,p_col WITH FORM "agl/42f/aglr113"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
 
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
   LET tm.b = g_aza.aza81
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.acc_code = 'N'   #FUN-B90140   Add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      LET l_row=0
      LET r_row=0
      LET l_sw = 1
      INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.e,tm.f,
                    tm.d,tm.acc_code,tm.c,tm.h,tm.o,tm.r,  #FUN-B90140 add tm.acc_code
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
 
         AFTER FIELD a
            IF NOT cl_null(tm.a) THEN
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
               CALL cl_err(tm.a,g_errno,1)
               NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a 
               AND mai00 = tm.b
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
            END IF
 
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN 
            CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF 
            SELECT aaa03 INTO l_aaa03 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            SELECT azi05 INTO l_azi05 FROM azi_file where azi01=l_aaa03
            LET tm.e=l_azi05
            DISPLAY BY NAME tm.e
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)
               NEXT FIELD b 
            END IF
            END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD yy
            IF NOT cl_null(tm.yy) AND tm.yy = 0 THEN
               NEXT FIELD yy
            ELSE
               LET tm.yy1 = tm.yy - 1
               DISPLAY BY NAME tm.yy1
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
               LET tm.bm1 = tm.bm
               DISPLAY BY NAME tm.bm1
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            IF tm.e IS NULL THEN NEXT FIELD e END IF
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
 
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
 
         BEFORE FIELD p
            IF tm.o = 'N' THEN NEXT FIELD more END IF
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel mai:",0)
               NEXT FIELD p
            END IF
 
         BEFORE FIELD q
            IF tm.o = 'N' THEN NEXT FIELD o END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
            IF tm.bm IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm 
            END IF
            IF l_sw = 0 THEN 
                LET l_sw = 1 
                NEXT FIELD a
                CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                 #LET g_qryparam.where = " mai00 = '",tm.b,"'"   #No.TQC-C50042   Mark
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b 
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form =  'q_azi'
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
         LET INT_FLAG = 0 CLOSE WINDOW aglr113 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aglr113'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglr113','9031',1)   
         ELSE
          LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                      " '",g_bookno CLIPPED,"'" ,
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.bm CLIPPED,"'",
                      " '",tm.c CLIPPED,"'",
                      " '",tm.d CLIPPED,"'",
                      " '",tm.e CLIPPED,"'",
                      " '",tm.f CLIPPED,"'",
                      " '",tm.h CLIPPED,"'",
                      " '",tm.o CLIPPED,"'",
                      " '",tm.p CLIPPED,"'",
                      " '",tm.q CLIPPED,"'",
                      " '",tm.r CLIPPED,"'",
                      " '",g_rep_user CLIPPED,"'",
                      " '",g_rep_clas CLIPPED,"'",
                      " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
          CALL cl_cmdat('aglr113',g_time,l_cmd)
         END IF
         CLOSE WINDOW aglr113
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r113()
      ERROR ""
   END WHILE
   CLOSE WINDOW aglr113
END FUNCTION
 
FUNCTION r113()
   DEFINE l_name    LIKE type_file.chr20
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_chr     LIKE type_file.chr1
   DEFINE amt1      LIKE aah_file.aah04
   DEFINE amt2      LIKE aah_file.aah04
   DEFINE per1      LIKE fid_file.fid03
   DEFINE per2      LIKE fid_file.fid03
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5
   DEFINE l_lastday LIKE type_file.dat
   DEFINE sr        RECORD
                       bal1      LIKE aah_file.aah04,
                       bal2      LIKE aah_file.aah04 
                    END RECORD
   DEFINE prt_l     DYNAMIC ARRAY OF RECORD                   #--- 陣列 for 資產類 (左)
                       maj31    LIKE maj_file.maj31, #FUN-B90140 add maj31
                       maj20    LIKE maj_file.maj20,
                       bal      LIKE type_file.num20_6,
                       per      LIKE type_file.num20_6,
                       bal1     LIKE type_file.num20_6,
                       per1     LIKE type_file.num20_6,
                       maj03    LIKE maj_file.maj03,
                       maj02    LIKE maj_file.maj02,
                       line     LIKE type_file.num5
                    END RECORD
   DEFINE prt_r     DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
                       maj31    LIKE maj_file.maj31, #FUN-B90140 add maj31
                       maj20    LIKE maj_file.maj20,
                       bal      LIKE type_file.num20_6,
                       per      LIKE type_file.num20_6,
                       bal1     LIKE type_file.num20_6,
                       per1     LIKE type_file.num20_6,
                       maj03    LIKE maj_file.maj03,
                       maj02    LIKE maj_file.maj02,
                       line     LIKE type_file.num5
                    END RECORD
   DEFINE tmp1      RECORD
                       maj23      LIKE maj_file.maj23,
                       maj31  LIKE maj_file.maj31, #FUN-B90140 add maj31
                       maj20      LIKE maj_file.maj20,
                       bal        LIKE type_file.num20_6,
                       per        LIKE type_file.num20_6,
                       bal1       LIKE type_file.num20_6,
                       per1       LIKE type_file.num20_6,
                       maj03      LIKE maj_file.maj03,
                       maj02      LIKE maj_file.maj02,
                       line       LIKE type_file.num5
                    END RECORD
   DEFINE l_maj02_l  LIKE maj_file.maj02
   DEFINE l_maj02_r  LIKE maj_file.maj02
   DEFINE l_row_l    LIKE type_file.num5
   DEFINE l_row_r    LIKE type_file.num5
   DEFINE r,l,i      LIKE type_file.num5
 
   DROP TABLE aglr113_tmp
   CREATE TEMP TABLE aglr113_tmp(
      maj23    LIKE maj_file.maj23,
      maj31  LIKE maj_file.maj31, #FUN-B90140 add maj31
      maj20    LIKE maj_file.maj20,
      bal      LIKE type_file.num20_6,
      per      LIKE type_file.num20_6,
      bal1     LIKE type_file.num20_6,
      per1     LIKE type_file.num20_6,
      maj03    LIKE maj_file.maj03,
      maj02    LIKE maj_file.maj02,
      line     LIKE type_file.num5)
 
   #帳別名稱
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01=tm.b AND aaf02=g_rlang
 
   CALL cl_del_data(l_table)
 
   LET l_sql = "SELECT * FROM maj_file ",
               " WHERE maj01 = '",tm.a,"' ",
               "   AND maj23[1,1]='1' ",
               " ORDER BY maj02"
   PREPARE r113_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE r113_c CURSOR FOR r113_p
 
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
   LET g_basetot1 = NULL
   LET g_basetot2 = NULL
   FOREACH r113_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      IF NOT cl_null(maj.maj21) THEN
         IF maj.maj24 IS NULL THEN    #起始部門編號
            #會計科目各期餘額檔
            SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy AND aah03 <= tm.bm
               AND aah01 = aag01 AND aag07 IN ('2','3')
            #去年同期會計科目各期餘額檔
            SELECT SUM(aah04-aah05) INTO amt2 FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy1 AND aah03 <= tm.bm1
               AND aah01 = aag01 AND aag07 IN ('2','3')
         ELSE
            #部門科目餘額檔
            SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b  
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy AND aao04 <= tm.bm
               AND aao01 = aag01 AND aag07 IN ('2','3')
          #去年同期部門科目餘額檔
            SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b  
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy1 AND aao04 <= tm.bm1
               AND aao01 = aag01 AND aag07 IN ('2','3')
         END IF
         IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
         IF amt1 IS NULL THEN LET amt1 = 0 END IF
         IF amt2 IS NULL THEN LET amt2 = 0 END IF
      END IF
      IF tm.o = 'Y' THEN         #匯率的轉換
         LET amt1 = amt1 * tm.q 
         LET amt2 = amt2 * tm.q 
      END IF 
      IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0 THEN    #合計階數處理
         FOR i = 1 TO 100 
             IF maj.maj09 = '-' THEN
                LET g_tot1[i] = g_tot1[i] - amt1
                LET g_tot2[i] = g_tot2[i] - amt2
             ELSE
                LET g_tot1[i] = g_tot1[i] + amt1
                LET g_tot2[i] = g_tot2[i] + amt2
             END IF
         END FOR
         LET k=maj.maj08
         LET sr.bal1=g_tot1[k]
         LET sr.bal2=g_tot2[k]
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal2 = sr.bal2 *-1
         END IF
         FOR i = 1 TO maj.maj08
            LET g_tot1[i]=0
            LET g_tot2[i]=0 
         END FOR
      ELSE  
         IF maj.maj03='5' THEN                       #本行要印出,但金額不作加總
            LET sr.bal1=amt1
            LET sr.bal2=amt2
         ELSE
            LET sr.bal1=NULL
            LET sr.bal2=NULL
         END IF
      END IF
      IF maj.maj11 = 'Y' THEN                        #百分比基準科目
         LET g_basetot1=sr.bal1
         LET g_basetot2=sr.bal2
         IF g_basetot1 = 0 THEN 
            LET g_basetot1 = NULL
         END IF
         IF g_basetot2 = 0 THEN 
            LET g_basetot2 = NULL
         END IF
         IF maj.maj07='2' THEN 
            LET g_basetot1=g_basetot1*-1
            LET g_basetot2=g_basetot2*-1
         END IF
         #金額單位(1.元 2.千 3.百萬)
         IF tm.d MATCHES '[23]' THEN 
            LET g_basetot1=g_basetot1/g_unit
            LET g_basetot2=g_basetot2/g_unit
         END IF
      END IF
      IF maj.maj03='0' THEN                          #本行不印出
         CONTINUE FOREACH
      END IF
      IF (tm.c='N' OR maj.maj03='2') AND             #餘額為 0 者不列印
          maj.maj03 MATCHES "[012345]" AND sr.bal1=0 THEN
         CONTINUE FOREACH
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN            #最小階數起列印
         CONTINUE FOREACH
      END IF
      #正常餘額型態=2.貸餘,金額要乘以-1 
      IF maj.maj07='2' THEN
         LET sr.bal1=sr.bal1*-1
         LET sr.bal2=sr.bal2*-1
      END IF
      LET sr.bal1=cl_numfor(sr.bal1,17,tm.e)
      LET sr.bal2=cl_numfor(sr.bal2,17,tm.e)
      #列印額外名稱
      IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
      LET per1 = (sr.bal1 / g_basetot1) * 100
      LET per2 = (sr.bal2 / g_basetot2) * 100
      IF maj.maj03 = 'H' THEN 
         LET sr.bal1=NULL
         LET sr.bal2=NULL
         LET per1= ' '
         LET per2= ' '
      END IF
      #金額單位(1.元 2.千 3.百萬)
      IF tm.d MATCHES '[23]' THEN LET sr.bal1=sr.bal1/g_unit END IF
      IF tm.d MATCHES '[23]' THEN LET sr.bal2=sr.bal2/g_unit END IF
      LET maj.maj20=maj.maj05 SPACES,maj.maj20
 
      IF maj.maj03='3' OR maj.maj03='4' THEN
         IF NOT cl_null(maj.maj20) THEN
            INSERT INTO aglr113_tmp VALUES
             (maj.maj23,maj.maj31,maj.maj20,sr.bal1,per1,sr.bal2,per2,'1',maj.maj02,2)     #FUN-B90140 add maj31
         END IF
         INSERT INTO aglr113_tmp VALUES
          (maj.maj23,maj.maj31,maj.maj20,sr.bal1,per1,sr.bal2,per2,maj.maj03,maj.maj02,2)  #FUN-B90140 add maj31
      ELSE
         INSERT INTO aglr113_tmp VALUES
          (maj.maj23,maj.maj31,maj.maj20,sr.bal1,per1,sr.bal2,per2,maj.maj03,maj.maj02,2)  #FUN-B90140 add maj31
      END IF
      IF maj.maj04 > 0 THEN
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            INSERT INTO aglr113_tmp VALUES
             (maj.maj23,'',maj.maj20,0,0,0,0,maj.maj03,maj.maj02,1)      #FUN-B90140 add ''
         END FOR
      END IF
   END FOREACH
 
   #抓報表結構裡帳戶左邊最大序號
   SELECT MAX(maj02) INTO l_maj02_l FROM aglr113_tmp WHERE maj23='11'
   #抓報表結構裡帳戶右邊最大序號
   SELECT MAX(maj02) INTO l_maj02_r FROM aglr113_tmp WHERE maj23='12'
   IF cl_null(l_maj02_l) THEN LET l_maj02_l = 0 END IF
   IF cl_null(l_maj02_r) THEN LET l_maj02_r = 0 END IF
   LET r_row = 0  LET l_row = 0
   DECLARE r113_c1 CURSOR FOR SELECT * FROM aglr113_tmp ORDER BY maj23,maj02,line
   FOREACH r113_c1 INTO tmp1.*
      IF tmp1.maj23[2,2]='2' THEN     #--- 右邊(負債&業主權益)
         LET r_row=r_row+1
         LET prt_r[r_row].maj31=tmp1.maj31 #FUN-B90140 add
         LET prt_r[r_row].maj20=tmp1.maj20
         LET prt_r[r_row].bal  =tmp1.bal
         LET prt_r[r_row].per  =tmp1.per
         LET prt_r[r_row].bal1 =tmp1.bal1
         LET prt_r[r_row].per1 =tmp1.per1
         LET prt_r[r_row].maj03=tmp1.maj03
         LET prt_r[r_row].maj02=tmp1.maj02
         LET prt_r[r_row].line =tmp1.line
         IF l_maj02_r != 0 THEN
            IF tmp1.maj02 = l_maj02_r THEN    #判斷是不是到最後一筆
               LET l_row_r = r_row
            END IF
         END IF
      ELSE                           #--- 左邊(資產)
         LET l_row=l_row+1
         LET prt_l[l_row].maj31=tmp1.maj31 #FUN-B90140 add
         LET prt_l[l_row].maj20=tmp1.maj20
         LET prt_l[l_row].bal  =tmp1.bal
         LET prt_l[l_row].per  =tmp1.per
         LET prt_l[l_row].bal1 =tmp1.bal1
         LET prt_l[l_row].per1 =tmp1.per1
         LET prt_l[l_row].maj03=tmp1.maj03
         LET prt_l[l_row].maj02=tmp1.maj02
         LET prt_l[l_row].line =tmp1.line
         IF l_maj02_l != 0 THEN
            IF tmp1.maj02 = l_maj02_l THEN    #判斷是不是到最後一筆
               LET l_row_l = l_row
            END IF
         END IF
      END IF
   END FOREACH
 
   IF r_row = 0 THEN LET r_row = 1 END IF
   IF l_row = 0 THEN LET l_row = 1 END IF
   IF l_maj02_r != 0 AND l_maj02_l != 0 THEN
      IF l_row_l > l_row_r THEN
         LET l_last=l_row
         LET prt_r[l_row_l+1].* = prt_r[l_row_r+1].*
         INITIALIZE prt_r[l_row_r+1].* TO NULL
         IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
            IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
               LET prt_r[l_row_l-1].* = prt_r[l_row_r-1].*
               INITIALIZE prt_r[l_row_r-1].* TO NULL
            ELSE
               LET prt_r[l_row_l-1].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
            END IF
         ELSE
            IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
               LET prt_l[l_row_l+1].* = prt_r[l_row_r].*
               LET prt_l[l_row_l+1].maj02=prt_l[l_row_l].maj02
               LET prt_l[l_row_l+1].maj03='1'
               LET prt_l[l_row_l+1].maj20=''
               LET prt_l[l_row_l+1].maj31='' #FUN-B90140 add
               LET prt_r[l_row_l+1].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
               LET prt_r[l_row_l].* = prt_r[l_row_r-1].*
               INITIALIZE prt_r[l_row_r-1].* TO NULL
               LET l_last=l_row_l+1
            ELSE
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
            END IF
         END IF
      END IF
   
      IF l_row_l < l_row_r THEN
         LET l_last=r_row
         LET prt_l[l_row_r+1].* = prt_l[l_row_l+1].*
         INITIALIZE prt_l[l_row_l+1].* TO NULL
         IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
            IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
               LET prt_l[l_row_r].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
               LET prt_l[l_row_r-1].* = prt_l[l_row_l-1].*
               INITIALIZE prt_l[l_row_l-1].* TO NULL
            ELSE
               LET prt_l[l_row_r-1].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
            END IF
         ELSE
            IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
               LET prt_r[l_row_r+1].* = prt_l[l_row_l].*
               LET prt_r[l_row_r+1].maj02=prt_r[l_row_r].maj02
               LET prt_r[l_row_r+1].maj03='1'
               LET prt_r[l_row_r+1].maj31='' #FUN-B90140 add
               LET prt_r[l_row_r+1].maj20=''
               LET prt_l[l_row_r+1].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
               LET prt_l[l_row_r].* = prt_l[l_row_l-1].* 
               INITIALIZE prt_l[l_row_l-1].* TO NULL
               LET l_last=l_row_r+1
            ELSE
               LET prt_l[l_row_r].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
            END IF
         END IF
      END IF
      IF l_row_l = l_row_r THEN 
         IF l_row > r_row THEN 
            LET l_last = l_row
         ELSE
            LET l_last = r_row
         END IF
      END IF
   ELSE
      IF l_maj02_r = 0 THEN LET l_last = r_row END IF
      IF l_maj02_l = 0 THEN LET l_last = l_row END IF
   END IF
 
   FOR i=1 TO l_last
      EXECUTE insert_prep USING 
         prt_l[i].maj31,  #FUN-B90140 add maj31
         prt_l[i].maj20,prt_l[i].bal,  prt_l[i].per,
         prt_l[i].bal1, prt_l[i].per1,
         prt_l[i].maj03,prt_l[i].maj02,prt_l[i].line,
         prt_r[i].maj31,   #FUN-B90140 add maj31
         prt_r[i].maj20,prt_r[i].bal,  prt_r[i].per,
         prt_r[i].bal1, prt_r[i].per1,
         prt_r[i].maj03,prt_r[i].maj02,prt_r[i].line,i
   END FOR
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   CALL s_yp(MDY(tm.bm,'1',tm.yy)) RETURNING tm.yy,tm.bm               #MOD-CA0212 add
   LET l_lastday = MDY(tm.bm,'1',tm.yy)
   LET l_lastday = s_last(l_lastday)
#                p1         p2        p3      p4        p5
   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",
#                p6         p7        p8            p9           p10   
               tm.bm,";",tm.e,";",l_lastday,";",g_basetot1,";",tm.yy,";",
#                p11        p12
               tm.yy1,";",tm.bm
               ,";",tm.acc_code   #FUN-B90140   Add
   CALL cl_prt_cs3('aglr113','aglr113',g_sql,g_str) 
END FUNCTION
