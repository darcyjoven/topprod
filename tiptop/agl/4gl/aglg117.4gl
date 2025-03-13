# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg117.4gl
# Descriptions...: 差異調節表(IFRS) - 總賬 FUN-B70002
# Modify.........: No.MOD-C20238 12/03/03 By Polly 調整l_aaz126/l_aaz127變數長度
# Modify.........: No.FUN-C40071 12/05/23 By zhangwei CR轉GR

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm         RECORD
          rtype   LIKE type_file.chr1,            #報表結構編號    FUN-B70002
          a       LIKE mai_file.mai01,            #報表結構編號
          b       LIKE aaa_file.aaa01,            #帳別編號
          b1      LIKE aaa_file.aaa01,            #帳別編號 
          yy      LIKE type_file.num5,            #輸入年度
          bm      LIKE type_file.num5,            #Begin 期 別
          em      LIKE type_file.num5,            # End  期別
          c       LIKE type_file.chr1,            #異動額及餘額為0者是否列印
          d       LIKE type_file.chr1,            #金額單位
          e       LIKE type_file.num5,            #小數位數
          f       LIKE type_file.num5,            #列印最小階數
          h       LIKE type_file.chr4,            #額外說明類別
          o       LIKE type_file.chr1,            #轉換幣別否
          p       LIKE azi_file.azi01,            #幣別
          q       LIKE azj_file.azj03,            #匯率
          r       LIKE azi_file.azi01,            #幣別
          more    LIKE type_file.chr1             #Input more condition(Y/N
                  END RECORD,
   bdate,edate    LIKE type_file.dat,
   i,j,k          LIKE type_file.num5,
   g_unit         LIKE type_file.num10,          #金額單位基數
   g_bookno       LIKE aah_file.aah00,           #帳別
   g_mai02        LIKE mai_file.mai02,
   g_mai03        LIKE mai_file.mai03,
   g_tot1         ARRAY[100] OF  LIKE type_file.num20_6,
   g_tot2         ARRAY[100] OF  LIKE type_file.num20_6,
   g_tot3_1       ARRAY[100] OF  LIKE type_file.num20_6,
   g_tot3_2       ARRAY[100] OF  LIKE type_file.num20_6
DEFINE g_basetot1 LIKE aah_file.aah04
DEFINE g_basetot2 LIKE aah_file.aah04
DEFINE g_basetot3 LIKE aah_file.aah04
DEFINE g_basetot4 LIKE aah_file.aah04
DEFINE g_aaa03    LIKE aaa_file.aaa03
DEFINE g_i        LIKE type_file.num5
DEFINE g_msg      LIKE type_file.chr1000 
DEFINE g_aaa09    LIKE aaa_file.aaa09
DEFINE l_table    STRING
DEFINE g_sql      STRING
DEFINE g_str      STRING
DEFINE m_dbs      ARRAY[10] OF LIKE type_file.chr20
DEFINE g_str1     LIKE type_file.chr20
DEFINE g_yy       LIKE type_file.num5
DEFINE g_ss       LIKE type_file.num5
DEFINE g_name1    LIKE type_file.chr100
DEFINE g_zo16     LIKE zo_file.zo16
DEFINE g_cmd      LIKE type_file.chr100
DEFINE sheet1     STRING
DEFINE sheet2     STRING
DEFINE g_r        LIKE type_file.num5

###GENGRE###START
TYPE sr1_t RECORD
    maj32 LIKE maj_file.maj32,
    bal2 LIKE aah_file.aah04,
    bal3 LIKE aah_file.aah04,
    bal4 LIKE aah_file.aah04,
    bal1 LIKE aah_file.aah04,
    maj20 LIKE maj_file.maj20,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    line LIKE type_file.num5
END RECORD
###GENGRE###END

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
 
   LET g_sql = "maj32.maj_file.maj32,",
               "bal2.aah_file.aah04,",
               "bal3.aah_file.aah04,",
               "bal4.aah_file.aah04,",
               "bal1.aah_file.aah04,",
               "maj20.maj_file.maj20,",
               "maj02.maj_file.maj02,",   #項次(排序要用的)
               "maj03.maj_file.maj03,",   #列印碼
               "line.type_file.num5"

   LET l_table = cl_prt_temptable('aglg117',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-C40071 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-C40071 add
      EXIT PROGRAM 
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,? )" 
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-C40071 add
       CALL cl_gre_drop_temptable(l_table)               #FUN-C40071 add
      EXIT PROGRAM                         
   END IF          
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)
   LET tm.b1 = ARG_VAL(11)
   LET tm.yy = ARG_VAL(12)
   LET tm.bm = ARG_VAL(13)
   LET tm.em = ARG_VAL(14)
   LET tm.c  = ARG_VAL(15)
   LET tm.d  = ARG_VAL(16)
   LET tm.e  = ARG_VAL(17)
   LET tm.f  = ARG_VAL(18)
   LET tm.h  = ARG_VAL(19)
   LET tm.o  = ARG_VAL(20)
   LET tm.p  = ARG_VAL(21)
   LET tm.q  = ARG_VAL(22)
   LET tm.r  = ARG_VAL(23)
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)

   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64 
   END IF
   IF cl_null(tm.b) THEN
      LET tm.b = g_aza.aza81
   END IF 

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g117_tm()
   ELSE
      CALL g117()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION g117_tm()
DEFINE p_row,p_col       LIKE type_file.num5,
       l_sw              LIKE type_file.chr1,      #重要欄位是否空白
       l_cmd             LIKE type_file.chr1000         
DEFINE li_chk_bookno     LIKE type_file.num5
DEFINE li_result         LIKE type_file.num5
DEFINE l_bdate,l_edate   LIKE type_file.dat 
DEFINE l_flag            LIKE type_file.chr1
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW g117_w AT p_row,p_col
     WITH FORM "agl/42f/aglg117"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL  s_shwact(0,0,g_bookno)
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
 
   LET tm.rtype = 1
   LET tm.bm = 0
   CALL cl_set_comp_entry("bm",FALSE)
   LET tm.b= g_aza.aza81
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.yy = Year(g_today)
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   SELECT azn04 INTO tm.em FROM azn_file WHERE azn01 = g_today
 
   WHILE TRUE

      LET l_sw = 1

      INPUT BY NAME tm.rtype,
                    tm.b,tm.b1,tm.a,tm.yy,tm.bm,tm.em,
                    tm.e,tm.f,tm.d,tm.c,tm.h,
                    tm.o,tm.r,
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         AFTER FIELD rtype
            IF NOT cl_null(tm.rtype) THEN 
               CALL g117_set_entry()
               IF tm.rtype = 1 THEN
                  CALL g117_set_no_entry()
               END IF
            END IF

         AFTER FIELD a
            IF NOT cl_null(tm.a) THEN
               CALL s_chkmai(tm.a,'RGL') RETURNING li_result
               IF NOT li_result THEN
                 CALL cl_err(tm.a,g_errno,1)
                 NEXT FIELD a
               END IF
 
               SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a 
                  AND mai00 = tm.b1
                  AND mai03 IN ('5','6')
                  AND maiacti IN ('Y','y')
               IF STATUS THEN 
                  CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)
                  NEXT FIELD a 
               END IF
               IF g_mai03 = '5' THEN LET tm.rtype = '1' END IF
               IF g_mai03 = '6' THEN LET tm.rtype = '2' END IF
               DISPLAY BY NAME tm.rtype
               CALL g117_set_entry()
               CALL g117_set_no_entry()

            END IF
      
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
                CALL s_check_bookno(tm.b,g_user,g_plant) RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                   NEXT FIELD b
                END IF

                SELECT aaa02 FROM aaa_file 
                 WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
               IF STATUS THEN 
                  CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)
                  NEXT FIELD b
               END IF
            END IF

         AFTER FIELD b1
            IF NOT cl_null(tm.b1) THEN
                CALL s_check_bookno(tm.b1,g_user,g_plant) RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                   NEXT FIELD b1
                END IF

                SELECT aaa02 FROM aaa_file
                 WHERE aaa01=tm.b1 AND aaaacti IN ('Y','y')
               IF STATUS THEN
                  CALL cl_err3("sel","aaa_file",tm.b1,"",STATUS,"","sel aaa:",0)
                  NEXT FIELD b1
               END IF
            END IF

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c 
            END IF

         AFTER FIELD yy
            IF  tm.yy = 0 THEN
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
      
      
         AFTER FIELD d
            IF tm.d NOT MATCHES'[123]' THEN
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
      
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
      
         AFTER FIELD f
            IF tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h 
            END IF
      
         AFTER FIELD o
            IF tm.o NOT MATCHES'[YN]' THEN 
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
            IF INFIELD(a) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mai00 = '",tm.b1,"' AND mai03 IN ('5','6')"
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF

            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF

            IF INFIELD(b1) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b1
               CALL cl_create_qry() RETURNING tm.b1
               DISPLAY BY NAME tm.b1
               NEXT FIELD b1
            END IF
            
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF

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
         CLOSE WINDOW g117_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)      #FUN-C40071
         EXIT PROGRAM
      END IF

      IF tm.o = 'Y' THEN  
         SELECT azi04 INTO t_azi04
           FROM azi_file 
          WHERE azi01 = tm.p 
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg117'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg117','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.b1 CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
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
            CALL cl_cmdat('aglg117',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g117_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)      #FUN-C40071
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g117()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g117_w
 
END FUNCTION

FUNCTION g117()
  DEFINE l_name    LIKE type_file.chr20     # External(Disk) file name
  DEFINE l_sql     LIKE type_file.chr1000
  DEFINE l_chr     LIKE type_file.chr1
  DEFINE amt1      LIKE aah_file.aah04
  DEFINE amt2      LIKE aah_file.aah04
  DEFINE amt3_1    LIKE aah_file.aah04
  DEFINE amt3_2    LIKE aah_file.aah04
  DEFINE l_d,l_c   LIKE aah_file.aah04
  DEFINE l_tmp     LIKE aah_file.aah04
  DEFINE maj       RECORD LIKE maj_file.*
  DEFINE sr        RECORD
            bal1   LIKE aah_file.aah04,
            bal2   LIKE aah_file.aah04,
            bal3_1 LIKE aah_file.aah04,
            bal3_2 LIKE aah_file.aah04
                   END RECORD
  DEFINE l_bdate   LIKE type_file.dat
  DEFINE l_edate   LIKE type_file.dat
  DEFINE l_flag    LIKE type_file.chr1
  DEFINE l_endy1   LIKE abb_file.abb07 
  DEFINE l_endy2   LIKE abb_file.abb07
  DEFINE per1      LIKE rmc_file.rmc31
  DEFINE l_azp03   LIKE azp_file.azp03
  DEFINE l_dbs     LIKE azp_file.azp03
  DEFINE l_i       LIKE type_file.num5
  DEFINE i         LIKE type_file.num5
  DEFINE l_aah01   LIKE aah_file.aah01
 #DEFINE l_aaz126  LIKE aaz_file.aaz126   #MOD-C20238 mark
 #DEFINE l_aaz127  LIKE aaz_file.aaz127   #MOD-C20238 mark
  DEFINE l_aaz126  LIKE type_file.chr6    #MOD-C20238 add
  DEFINE l_aaz127  LIKE type_file.chr6    #MOD-C20238 add
  DEFINE l_lastday LIKE type_file.dat
   
   CALL cl_del_data(l_table)
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE LET g_msg = " 1=1" 
   END CASE
 
   LET g_basetot1 = NULL
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g117_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)      #FUN-C40071
      EXIT PROGRAM 
   END IF
   DECLARE g117_c CURSOR FOR g117_p

   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0 
      LET g_tot2[g_i] = 0 
      LET g_tot3_1[g_i] = 0 
      LET g_tot3_2[g_i] = 0 
   END FOR

   LET status = NULl

   FOREACH g117_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
 
      LET amt1 = 0
      IF NOT cl_null(maj.maj21) THEN
         IF cl_null(maj.maj22) THEN
            LET maj.maj22 = maj.maj21
         END IF
         IF maj.maj24 IS NULL THEN
            LET l_sql = " SELECT SUM(aah04-aah05) ",
                        " FROM aah_file,aag_file ",
                        " WHERE aah00 = '",tm.b1,"' ",
                        " AND aag00 = '",tm.b1,"' ",  
                        " AND aah01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
                        " AND aah02 = '",tm.yy,"' ",
                        " AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"' ",
                        " AND aah01 = aag01 ",
                        " AND aag07 IN ('2','3') "
            PREPARE g117_prepare1 FROM l_sql                                                                                          
            DECLARE g117_c1  CURSOR FOR g117_prepare1                                                                                 
            OPEN g117_c1                                                                                    
            FETCH g117_c1 INTO amt1
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","aah_file,aag_file",tm.b1,tm.yy,STATUS,"","sel aah:",1)
               EXIT FOREACH 
            END IF
         ELSE
            LET l_sql = " SELECT SUM(aao05-aao06) ",
                        " FROM aao_file,aag_file ",
                        " WHERE aao00 = '",tm.b,"' ",
                        " AND aag00 = '",tm.b,"' ",   
                        " AND aao01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
                        " AND aao02 BETWEEN '",maj.maj24,"' AND '",maj.maj25,"' ",
                        " AND aao03 = '",tm.yy,"' ",
                        " AND aao04 BETWEEN '",tm.bm,"' AND '",tm.em,"' ",
                        " AND aao01 = aag01 ",
                        " AND aag07 IN ('2','3') "
            PREPARE g117_prepare2 FROM l_sql                                                                                          
            DECLARE g117_c2  CURSOR FOR g117_prepare2                                                                                 
            OPEN g117_c2                                                                                    
            FETCH g117_c2 INTO amt1
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","aao_file,aag_file",tm.yy,"",STATUS,"","sel aao:",1)
               EXIT FOREACH 
            END IF
         END IF
 
         IF amt1 IS NULL THEN
            LET amt1 = 0 
         END IF
      END IF

      LET amt2 = 0
      IF NOT cl_null(maj.maj34) THEN
         IF cl_null(maj.maj35) THEN
            LET maj.maj35 = maj.maj34
         END IF
         LET l_sql = " SELECT SUM(aah04-aah05) ",
                     " FROM aah_file,aag_file ",
                     " WHERE aah00 = '",tm.b,"' ",
                     " AND aag00 = '",tm.b,"' ",  
                     " AND aah01 BETWEEN '",maj.maj34,"' AND '",maj.maj35,"' ",
                     " AND aah02 = '",tm.yy,"' ",
                     " AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"' ",
                     " AND aah01 = aag01 ",
                     " AND aag07 IN ('2','3') "
         PREPARE g117_prepare3 FROM l_sql                                                                                          
         DECLARE g117_c3  CURSOR FOR g117_prepare3                                                                                 
         OPEN g117_c3                                                                                    
         FETCH g117_c3 INTO amt2
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("sel","aah_file,aag_file",tm.b,tm.yy,STATUS,"","sel aah:",1)
            EXIT FOREACH 
         END IF
         IF amt2 IS NULL THEN
            LET amt2 = 0 
         END IF
      END IF

      SELECT aaz126 INTO l_aaz126 FROM aaz_file
      SELECT aaz127 INTO l_aaz127 FROM aaz_file
      LET l_aaz126 = l_aaz126,'%'
      LET l_aaz127 = l_aaz127,'%'
      LET l_d = 0
      SELECT sum(abb07) INTO l_d
        FROM abb_file,aba_file
       WHERE abb03 BETWEEN maj.maj21 and maj.maj22
         AND aba01 = abb01
         AND aba01 LIKE l_aaz126
         AND aba00 = abb00
         AND abb06 = '1'
         AND aba00 = tm.b1
         AND abapost = 'Y'
         AND aba03 = tm.yy
         AND aba04 BETWEEN tm.bm AND tm.em
      IF l_d IS NULL THEN LET l_d = 0 END IF
      LET l_c = 0
      SELECT sum(abb07) INTO l_c
        FROM aba_file,abb_file
       WHERE abb03 BETWEEN maj.maj21 and maj.maj22
         AND aba01 = abb01
         AND aba01 LIKE l_aaz126
         AND aba00 = abb00
         AND abb06 = '2'
         AND aba00 = tm.b1
         AND abapost = 'Y'
         AND aba03 = tm.yy
         AND aba04 BETWEEN tm.bm AND tm.em      
      IF l_c IS NULL THEN LET l_c = 0 END IF
      LET amt3_1 = l_d - l_c
      LET l_d = 0
      SELECT sum(abb07) INTO l_d
        FROM abb_file,aba_file
       WHERE abb03 BETWEEN maj.maj21 and maj.maj22
         AND aba01 = abb01
         AND aba01 LIKE l_aaz127
         AND aba00 = abb00
         AND abb06 = '1'
         AND aba00 = tm.b1
         AND abapost = 'Y'
         AND aba03 = tm.yy
         AND aba04 BETWEEN tm.bm AND tm.em
      IF l_d IS NULL THEN LET l_d = 0 END IF
      LET l_c = 0
      SELECT sum(abb07) INTO l_c
        FROM aba_file,abb_file
       WHERE abb03 BETWEEN maj.maj21 and maj.maj22
         AND aba01 = abb01
         AND aba01 LIKE l_aaz127
         AND aba00 = abb00
         AND abb06 = '2'
         AND aba00 = tm.b1
         AND abapost = 'Y'
         AND aba03 = tm.yy
         AND aba04 BETWEEN tm.bm AND tm.em      
      IF l_c IS NULL THEN LET l_c = 0 END IF
      LET amt3_2 = l_d - l_c

      #-->匯率的轉換
      IF tm.o = 'Y' THEN 
         LET amt1 = amt1 * tm.q
         LET amt2 = amt2 * tm.q
         LET amt3_1 = amt3_1 * tm.q
         LET amt3_2 = amt3_2 * tm.q
      END IF 
 
      #-->合計階數處理
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
         FOR i = 1 TO 100
            LET g_tot1[i] = g_tot1[i] + amt1
            LET g_tot2[i] = g_tot2[i] + amt2
            LET g_tot3_1[i] = g_tot3_1[i] + amt3_1
            LET g_tot3_2[i] = g_tot3_2[i] + amt3_2
         END FOR
 
         LET k = maj.maj08
         LET sr.bal1 = g_tot1[k]
         LET sr.bal2 = g_tot2[k]
         LET sr.bal3_1 = g_tot3_1[k]
         LET sr.bal3_2 = g_tot3_2[k]
 
         FOR i = 1 TO maj.maj08
            LET g_tot1[i] = 0
            LET g_tot2[i] = 0
            LET g_tot3_1[i] = 0
            LET g_tot3_2[i] = 0
         END FOR
      ELSE
         IF maj.maj03 = '5' THEN
            LET sr.bal1 = amt1
            LET sr.bal2 = amt2
            LET sr.bal3_1 = amt3_1
            LET sr.bal3_2 = amt3_2
         ELSE
            LET sr.bal1 = NULL
            LET sr.bal2 = NULL
            LET sr.bal3_1 = NULL
            LET sr.bal3_2 = NULL
         END IF
      END IF
 
      #-->百分比基準科目
      IF maj.maj11 = 'Y' THEN                  
         LET g_basetot1 = sr.bal1
         LET g_basetot2 = sr.bal2
         LET g_basetot3 = sr.bal3_1
         LET g_basetot4 = sr.bal3_2
         IF g_basetot1 = 0 THEN
            LET g_basetot1 = NULL
         END IF
         IF g_basetot2 = 0 THEN
            LET g_basetot2 = NULL
         END IF
         IF g_basetot3 = 0 THEN
            LET g_basetot3 = NULL
         END IF
         IF g_basetot4 = 0 THEN
            LET g_basetot4 = NULL
         END IF
         IF maj.maj07='2' THEN
            LET g_basetot1 = g_basetot1 * -1
            LET g_basetot2 = g_basetot2 * -1
            LET g_basetot3 = g_basetot3 * -1
            LET g_basetot4 = g_basetot4 * -1
         END IF
         LET g_basetot1=g_basetot1/g_unit
         LET g_basetot2=g_basetot2/g_unit
         LET g_basetot3=g_basetot3/g_unit
         LET g_basetot4=g_basetot4/g_unit
      END IF
 
      IF maj.maj03 = '0' THEN 
         CONTINUE FOREACH 
      END IF #本行不印出
 
      #-->餘額為 0 者不列印
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" 
       AND sr.bal1=0 AND sr.bal2=0 THEN
         CONTINUE FOREACH                        
      END IF
 
      #-->最小階數起列印
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        
      END IF
 
      IF maj.maj07 = '2' THEN                                                
         LET sr.bal1 = sr.bal1 * -1
         LET sr.bal2 = sr.bal2 * -1
         LET sr.bal3_1 = sr.bal3_1 * -1
         LET sr.bal3_2 = sr.bal3_2 * -1
      END IF   
      IF tm.h = 'Y' THEN                                                        
         LET maj.maj20 = maj.maj20e
         LET maj.maj32 = maj.maj33         
      END IF                                                                    
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
      LET maj.maj32 = maj.maj05 SPACES,maj.maj32      
      LET sr.bal1 = sr.bal1/g_unit
      LET sr.bal2 = sr.bal2/g_unit 
      LET sr.bal3_1 = sr.bal3_1/g_unit 
      LET sr.bal3_2 = sr.bal3_2/g_unit  
      LET per1 = 0
 
      IF maj.maj04 = 0 THEN                                                     
         EXECUTE insert_prep USING                                              
            maj.maj32,sr.bal2,sr.bal3_1,sr.bal3_2,sr.bal1,maj.maj20,maj.maj02,maj.maj03,'2'
      ELSE                                                                      
         EXECUTE insert_prep USING                                              
            maj.maj32,sr.bal2,sr.bal3_1,sr.bal3_2,sr.bal1,maj.maj20,maj.maj02,maj.maj03,'2'
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
         #讓空行的這筆資料排在正常的資料前面印出                                
         FOR i = 1 TO maj.maj04                                                 
            EXECUTE insert_prep USING                                           
               maj.maj32,'0','0','0','0',maj.maj20,maj.maj02,maj.maj03,'1'
         END FOR                                                                
      END IF 
                             
   END FOREACH

   LET l_lastday = MDY(tm.em,'1',tm.yy)
   LET l_lastday = s_last(l_lastday)
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY maj02"
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",tm.bm,";",               
###GENGRE###               tm.e,";",l_lastday,";",tm.rtype,";",tm.em
###GENGRE###   CALL cl_prt_cs3('aglg117','aglg117',g_sql,g_str)

  #No.FUN-C40071   ---start---   Add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET maj32 = NULL,",
               "       bal2  = NULL,",
               "       bal3  = NULL,",
               "       bal4  = NULL,",
               "       bal1  = NULL,",
               "       maj20 = NULL",
               " WHERE line  = 1 ",
               "    OR maj03 = '3' ",
               "    OR maj03 = '4'"
   PREPARE g117_upd_line FROM g_sql
   EXECUTE g117_upd_line
  #No.FUN-C40071   ---end---     Add

    CALL aglg117_grdata()    ###GENGRE###
 
END FUNCTION

FUNCTION g117_set_entry()
     CALL cl_set_comp_entry("bm",TRUE)
END FUNCTION

FUNCTION g117_set_no_entry()
   IF tm.rtype = 1 THEN
      CALL cl_set_comp_entry("bm",FALSE)
   END IF
END FUNCTION



###GENGRE###START
FUNCTION aglg117_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg117")
        IF handler IS NOT NULL THEN
            START REPORT aglg117_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY maj02,line DESC"
          
            DECLARE aglg117_datacur1 CURSOR FROM l_sql
            FOREACH aglg117_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg117_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg117_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg117_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_bal1   STRING
    DEFINE l_bal2   STRING
    DEFINE l_bal3   STRING
    DEFINE l_bal4   STRING
    DEFINE l_lastday LIKE type_file.dat
    DEFINE l_curr    STRING
    DEFINE l_title2  LIKE gaz_file.gaz06
    
    FORMAT
        FIRST PAGE HEADER
            SELECT gaz06 INTO l_title2 FROM gaz_file WHERE gaz01 = g_prog AND gaz02 = g_lang
            LET g_grPageHeader.title2 = l_title2
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            LET l_lastday = MDY(tm.em,'1',tm.yy)
            LET l_lastday = s_last(l_lastday)
            PRINTX l_lastday
            LET l_curr = cl_gr_getmsg("gre-246",g_lang,tm.d)
            PRINTX l_curr
            PRINTX tm.*
              
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_bal1 = cl_gr_numfmt("aah_file","aah04",tm.e)
            LET l_bal2 = cl_gr_numfmt("aah_file","aah04",tm.e)
            LET l_bal3 = cl_gr_numfmt("aah_file","aah04",tm.e)
            LET l_bal4 = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal1,l_bal2,l_bal3,l_bal4
            PRINTX sr1.*

        ON LAST ROW

END REPORT
###GENGRE###END
