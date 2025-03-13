# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg023.4gl
# Descriptions...: 合併後差異調節表(IFRS) FUN-B60143
# Modify.........: NO.FUN-C40071  12/104/25 By JinJJ 明細CR報表轉GR

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm         RECORD
          rtype   LIKE type_file.chr1,            #報表結構編號   FUN-B60143
          axa01   LIKE axa_file.axa01,            #族群代號
          axa02   LIKE axa_file.axa02,            #上層公司
          axa03   LIKE axa_file.axa03,            #帳別編號
          b       LIKE aaa_file.aaa01,            #合併帳別編號
          axa01_1 LIKE axa_file.axa01,            #族群代號
          axa02_1 LIKE axa_file.axa02,            #上層公司
          axa03_1 LIKE axa_file.axa03,            #帳別編號
          b_1     LIKE aaa_file.aaa01,            #合併帳別編號
          a       LIKE mai_file.mai01,            #報表結構編號
          yy      LIKE type_file.num5,            #輸入年度
          axa06   LIKE axa_file.axa06,            #編製合併期別
          bm      LIKE type_file.num5,            #Begin 期 別
          em      LIKE type_file.num5,            # End  期別
          q1      LIKE type_file.chr1,            #季度
          h1      LIKE type_file.chr1,            #半年
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
   g_tot3         ARRAY[100] OF  LIKE type_file.num20_6,
   g_tot4         ARRAY[100] OF  LIKE type_file.num20_6
DEFINE g_dbs_axz03    STRING
DEFINE g_aaz641       LIKE aaz_file.aaz641
DEFINE g_basetot1 LIKE aah_file.aah04
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
DEFINE x_aaa03    LIKE aaa_file.aaa03
DEFINE l_aaa03    LIKE aaa_file.aaa03
DEFINE l_length       LIKE type_file.num5

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
    line LIKE type_file.num5,
    maj05 LIKE maj_file.maj05
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
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "maj32.maj_file.maj32,",
               "bal2.aah_file.aah04,",
               "bal3.aah_file.aah04,",
               "bal4.aah_file.aah04,",
               "bal1.aah_file.aah04,",
               "maj20.maj_file.maj20,",
               "maj02.maj_file.maj02,",   #項次(排序要用的)
               "maj03.maj_file.maj03,",   #列印碼
               "line.type_file.num5,",
               "maj05.maj_file.maj05"

   LET l_table = cl_prt_temptable('aglg023',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,? )"            
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM                         
   END IF          
 
   LET g_bookno   = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.rtype   = ARG_VAL(8)
   LET tm.axa01   = ARG_VAL(9)
   LET tm.axa02   = ARG_VAL(10)
   LET tm.axa03   = ARG_VAL(11)
   LET tm.b       = ARG_VAL(12)
   LET tm.axa01_1 = ARG_VAL(13)
   LET tm.axa02_1 = ARG_VAL(14)
   LET tm.axa03_1 = ARG_VAL(15)
   LET tm.b_1     = ARG_VAL(16)
   LET tm.a       = ARG_VAL(17)
   LET tm.yy      = ARG_VAL(18)
   LET tm.axa06   = ARG_VAL(19)
   LET tm.yy      = ARG_VAL(20)
   LET tm.em      = ARG_VAL(21)
   LET tm.q1      = ARG_VAL(22)
   LET tm.h1      = ARG_VAL(23)
   LET tm.c       = ARG_VAL(24)
   LET tm.d       = ARG_VAL(25)
   LET tm.e       = ARG_VAL(26)
   LET tm.f       = ARG_VAL(27)
   LET tm.h       = ARG_VAL(28)
   LET tm.o       = ARG_VAL(29)
   LET tm.p       = ARG_VAL(30)
   LET tm.q       = ARG_VAL(31)
   LET tm.r       = ARG_VAL(32)
   LET g_rep_user = ARG_VAL(33)
   LET g_rep_clas = ARG_VAL(34)
   LET g_template = ARG_VAL(35)
   LET g_rpt_name = ARG_VAL(36)

   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64 
   END IF
   IF cl_null(tm.b) THEN
      LET tm.axa03_1 = g_aza.aza81
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g023_tm()
   ELSE
      CALL g023()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
END MAIN

FUNCTION g023_tm()
DEFINE p_row,p_col       LIKE type_file.num5,
       l_cnt             LIKE type_file.num5,
       l_sw              LIKE type_file.chr1,      #重要欄位是否空白
       l_cmd             LIKE type_file.chr1000         
DEFINE li_chk_bookno     LIKE type_file.num5
DEFINE li_result         LIKE type_file.num5
DEFINE l_bdate,l_edate   LIKE type_file.dat 
DEFINE l_flag            LIKE type_file.chr1
DEFINE l_dbs             LIKE type_file.chr21
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW aglg023 AT p_row,p_col
     WITH FORM "agl/42f/aglg023"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL  s_shwact(0,0,g_bookno)
   INITIALIZE tm.* TO NULL            # Default condition

   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)
   END IF
 
   #使用預設帳別之幣別之小數位數
   SELECT azi04 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)
   END IF
 
   LET tm.rtype = 1
   LET tm.bm = 0
   LET tm.b_1= g_aza.aza81
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.yy = Year(g_today)
   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   SELECT azn04 INTO tm.em FROM azn_file WHERE azn01 = g_today
 
   WHILE TRUE

      LET l_sw = 1

      INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.axa03,tm.b,
                    tm.axa01_1,tm.axa02_1,tm.axa03_1,tm.b_1,
                    tm.a,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,
                    tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         AFTER FIELD rtype
            IF NOT cl_null(tm.rtype) THEN 
               CALL g023_set_entry()
               IF tm.rtype = 1 THEN
                  CALL g023_set_no_entry()
               END IF
            END IF

         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file 
                WHERE axa01 = tm.axa01
               IF l_cnt <=0  THEN
                  CALL cl_err(tm.axa01,'agl-223',0)
                  NEXT FIELD axa01
               END IF
            END IF

         AFTER FIELD axa02
           IF NOT cl_null(tm.axa02) THEN
              SELECT COUNT(*) INTO l_cnt FROM axa_file
               WHERE axa01=tm.axa01 AND axa02=tm.axa02
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN 
                 CALL cl_err(tm.axa02,'agl-223',0)
                 NEXT FIELD axa02 
              ELSE 
                 SELECT axa03 INTO tm.axa03 FROM axa_file
                  WHERE axa01=tm.axa01 AND axa02=tm.axa02
                 DISPLAY BY NAME tm.axa03
              END IF
              CALL  s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03        
              CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641
              LET g_plant_new = g_dbs_axz03                            
              LET tm.b = g_aaz641
              DISPLAY BY NAME tm.b        
           END IF

         AFTER FIELD axa03
           IF NOT cl_null(tm.axa03) THEN
              SELECT COUNT(*) INTO l_cnt FROM axa_file
               WHERE axa01 = tm.axa01 AND axa02 = tm.axa02 AND axa03 = tm.axa03
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <= 0 THEN 
                 CALL cl_err(tm.axa03,'agl-223',0) NEXT FIELD axa03
                 NEXT FIELD axa03 
              END IF
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

         AFTER FIELD axa01_1
            IF NOT cl_null(tm.axa01_1) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file 
                WHERE axa01 = tm.axa01_1
               IF l_cnt <=0  THEN
                  CALL cl_err(tm.axa01_1,'agl-223',0)
                  NEXT FIELD axa01_1
               END IF
               LET tm.axa06 = '2'
               SELECT axa06 INTO tm.axa06
                 FROM axa_file
                WHERE axa01 = tm.axa01_1     
                  AND axa04 = 'Y'
               DISPLAY BY NAME tm.axa06                                                                                   
               CALL g023_set_entry()
               CALL g023_set_no_entry()
               CASE 
                  WHEN tm.axa06 = '1'
                     LET tm.q1 = '' 
                     LET tm.h1 = '' 
                  WHEN tm.axa06 = '2'
                     LET tm.h1 = '' 
                     LET tm.em = '' 
                  WHEN tm.axa06 = '3'
                     LET tm.em = '' 
                     LET tm.q1 = ''
                  WHEN tm.axa06 = '4'
                     LET tm.em = '' 
                     LET tm.q1 = ''
                     LET tm.h1 = ''
               END CASE
            END IF
            DISPLAY BY NAME tm.em,tm.q1,tm.h1

         AFTER FIELD axa02_1
           IF NOT cl_null(tm.axa02_1) THEN
              SELECT COUNT(*) INTO l_cnt FROM axa_file
               WHERE axa01 = tm.axa01_1 AND axa02 = tm.axa02_1
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN 
                 CALL cl_err(tm.axa02_1,'agl-223',0) NEXT FIELD axa02_1
              ELSE 
                 SELECT axa03 INTO tm.axa03_1 FROM axa_file
                  WHERE axa01=tm.axa01_1 AND axa02=tm.axa02_1
                 DISPLAY BY NAME tm.axa03_1
              END IF
              CALL  s_aaz641_dbs(tm.axa01_1,tm.axa02_1) RETURNING g_dbs_axz03        
              CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641
              LET g_plant_new = g_dbs_axz03                            
              LET tm.b_1 = g_aaz641
              DISPLAY BY NAME tm.b_1        
              SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02_1        
              LET tm.r = x_aaa03                                                    
              LET tm.p = x_aaa03                                                    
              SELECT azi04 INTO tm.e FROM azi_file WHERE azi01 = x_aaa03            
              DISPLAY BY NAME tm.r                                                  
              DISPLAY BY NAME tm.p                                                  
              DISPLAY BY NAME tm.e                                                  
              IF NOT cl_null(g_dbs_axz03) THEN                                      
                 LET l_length = LENGTH(g_dbs_axz03)                                 
                 IF l_length > 1 THEN                                               
                    LET l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)                 
                 END IF                                                             
              ELSE                                                                  
                 LET l_dbs=g_dbs                                                    
              END IF
           END IF

         AFTER FIELD axa03_1
            IF NOT cl_null(tm.axa03_1) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file
                WHERE axa01 = tm.axa01_1 AND axa02 = tm.axa02_1 AND axa03 = tm.axa03_1
               IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
               IF l_cnt <= 0 THEN 
                  CALL cl_err(tm.axa03_1,'agl-223',0) NEXT FIELD axa03_1
                  NEXT FIELD axa03_1 
               END IF
            END IF

         AFTER FIELD b_1
            IF NOT cl_null(tm.b_1) THEN
                CALL s_check_bookno(tm.b_1,g_user,g_plant) RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                   NEXT FIELD b_1
                END IF

                SELECT aaa02 FROM aaa_file
                 WHERE aaa01=tm.b_1 AND aaaacti IN ('Y','y')
               IF STATUS THEN
                  CALL cl_err3("sel","aaa_file",tm.b_1,"",STATUS,"","sel aaa:",0)
                  NEXT FIELD b_1
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
                  AND mai00 = tm.b_1
                  AND mai03 IN ('5','6')
                  AND maiacti IN ('Y','y')
               IF STATUS THEN 
                  CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)
                  NEXT FIELD a 
               END IF
               IF g_mai03 = '5' THEN LET tm.rtype = '1' END IF
               IF g_mai03 = '6' THEN LET tm.rtype = '2' END IF
               DISPLAY BY NAME tm.rtype
               CALL g023_set_entry()
               CALL g023_set_no_entry()
            END IF

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c 
            END IF

         AFTER FIELD yy
            IF  tm.yy = 0 THEN
               NEXT FIELD yy
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
            IF cl_null(tm.em) AND NOT cl_null(tm.q1) THEN
               SELECT azn04 INTO tm.em FROM azn_file WHERE azn02 = tm.yy AND azn03 = tm.q1
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
               LET g_qryparam.where = " mai00 = '",tm.b_1,"' AND mai03 IN ('5','6')"
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

            IF INFIELD(b_1) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b_1
               CALL cl_create_qry() RETURNING tm.b_1
               DISPLAY BY NAME tm.b_1
               NEXT FIELD b_1
            END IF

            IF INFIELD(axa03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.axa03
               CALL cl_create_qry() RETURNING tm.axa03 
               DISPLAY BY NAME tm.axa03
               NEXT FIELD axa03
            END IF

            IF INFIELD(axa01) OR INFIELD(axa02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axa'
               LET g_qryparam.default1 = tm.axa01
               LET g_qryparam.default2 = tm.axa02
               LET g_qryparam.default3 = tm.axa03
               CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
               DISPLAY BY NAME tm.axa01
               DISPLAY BY NAME tm.axa02
               DISPLAY BY NAME tm.axa03
               NEXT FIELD axa01
            END IF

            IF INFIELD(axa03_1) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.axa03_1
               CALL cl_create_qry() RETURNING tm.axa03_1
               DISPLAY BY NAME tm.axa03_1
               NEXT FIELD axa03_1
            END IF

            IF INFIELD(axa01_1) OR INFIELD(axa02_1) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axa'
               LET g_qryparam.default1 = tm.axa01_1
               LET g_qryparam.default2 = tm.axa02_1
               LET g_qryparam.default3 = tm.axa03_1
               CALL cl_create_qry() RETURNING tm.axa01_1,tm.axa02_1,tm.axa03_1
               DISPLAY BY NAME tm.axa01_1
               DISPLAY BY NAME tm.axa02_1
               DISPLAY BY NAME tm.axa03_1
               NEXT FIELD axa01_1
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
         CLOSE WINDOW aglg023 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
         EXIT PROGRAM
      END IF

      IF tm.o = 'Y' THEN  
         SELECT azi04 INTO tm.e
           FROM azi_file 
          WHERE azi01 = tm.p 
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg023'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg023','9031',1)   
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
                        " '",tm.axa01 CLIPPED,"'",
                        " '",tm.axa02 CLIPPED,"'",
                        " '",tm.axa03 CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.axa01_1 CLIPPED,"'",
                        " '",tm.axa01_1 CLIPPED,"'",
                        " '",tm.axa01_1 CLIPPED,"'",
                        " '",tm.b_1 CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
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
            CALL cl_cmdat('aglg023',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg023
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g023()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg023
 
END FUNCTION

FUNCTION g023()
DEFINE l_name    LIKE type_file.chr20      # External(Disk) file name
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_chr     LIKE type_file.chr1
DEFINE amt1      LIKE axh_file.axh08
DEFINE amt2      LIKE axh_file.axh08
DEFINE amt3      LIKE axh_file.axh08
DEFINE amt4      LIKE axh_file.axh08
DEFINE l_d,l_c   LIKE aah_file.aah04
DEFINE maj       RECORD LIKE maj_file.*
DEFINE g_i       LIKE type_file.num5
DEFINE sr        RECORD
        bal1     LIKE axh_file.axh08,
        bal2     LIKE axh_file.axh08,
        bal3     LIKE axh_file.axh08,
        bal4     LIKE axh_file.axh08
                 END RECORD
DEFINE per1      LIKE fid_file.fid03
DEFINE l_temp    LIKE axh_file.axh08
DEFINE l_str     STRING
DEFINE l_axz02   LIKE axz_file.axz02
DEFINE l_bm      LIKE type_file.num5
DEFINE l_lastday LIKE type_file.dat
DEFINE l_e       LIKE type_file.num5

## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
#------------------------------ CR (2) ------------------------------#

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02_1
   SELECT axz06 INTO l_aaa03 FROM axz_file where axz01 = tm.axa02

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang

   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" SUBSTR(maj23,1,1)='1'"
        WHEN tm.rtype='2' LET g_msg=" SUBSTR(maj23,1,1)='2'"
        OTHERWISE LET g_msg = " 1=1" 
   END CASE
   LET l_sql = "SELECT * FROM ",g_dbs_axz03 CLIPPED,"maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE g023_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)  #FUN-C40071
      EXIT PROGRAM 
   END IF
   DECLARE g023_c CURSOR FOR g023_p
   FOR g_i = 1 TO 100 
      LET g_tot1[g_i] = 0
      LET g_tot2[g_i] = 0
      LET g_tot3[g_i] = 0
      LET g_tot4[g_i] = 0
   END FOR

   LET tm.bm = 0
   IF tm.rtype = '1' THEN  
      LET l_bm = tm.bm 
      LET tm.bm = tm.em 
   END IF
   LET g_pageno = 0
   FOREACH g023_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      IF NOT cl_null(maj.maj21) THEN
         IF cl_null(maj.maj22) THEN LET maj.maj22 = maj.maj21 END IF
         LET l_sql = "SELECT SUM(axh08-axh09) ",
                     "  FROM axh_file,",g_dbs_axz03,"aag_file",
                     " WHERE axh00 = '",tm.b_1,"'",
                     "   AND axh01 = '",tm.axa01_1,"'",
                     "   AND axh02 = '",tm.axa02_1,"'",
                     "   AND axh03 = '",tm.axa03_1,"'",
                     "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
                     "   AND axh00 = aag00", 
                     "   AND aag00 = '",tm.b_1,"'",
                     "   AND axh06 = '",tm.yy,"'",
                     "   AND axh07 = '",tm.em,"'",
                     "   AND axh05 = aag01 AND aag07 IN('2','3')",
                     "   AND axh12 = '",x_aaa03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE g023_sum_p FROM l_sql
         DECLARE g023_sum_c CURSOR FOR g023_sum_p
         OPEN g023_sum_c
         FETCH g023_sum_c INTO amt1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","axh_file,aag_file",tm.yy,"",STATUS,"","sel axh:",1)
            EXIT FOREACH 
         END IF
         IF amt1 IS NULL THEN LET amt1 = 0 END IF

      LET amt2 = 0
      IF NOT cl_null(maj.maj34) THEN
         IF cl_null(maj.maj35) THEN LET maj.maj35 = maj.maj34 END IF
         LET l_sql = "SELECT SUM(axh08-axh09) ",
                     "  FROM axh_file,",g_dbs_axz03,"aag_file",
                     " WHERE axh00 = '",tm.b,"'",
                     "   AND axh01 = '",tm.axa01,"'",
                     "   AND axh02 = '",tm.axa02,"'",
                     "   AND axh03 = '",tm.axa03,"'",
                     "   AND axh05 BETWEEN '",maj.maj34,"' AND '",maj.maj35,"'",
                     "   AND axh00 = aag00", 
                     "   AND aag00 = '",tm.b,"'",
                     "   AND axh06 = '",tm.yy,"'",
                     "   AND axh07 = '",tm.em,"'",
                     "   AND axh05 = aag01 AND aag07 IN ('2','3')",
                     "   AND axh12 = '",l_aaa03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE g023_sum_p1 FROM l_sql
         DECLARE g023_sum_c1 CURSOR FOR g023_sum_p1
         OPEN g023_sum_c1
         FETCH g023_sum_c1 INTO amt2
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","axh_file,aag_file",tm.yy,"",STATUS,"","sel axh:",1)
            EXIT FOREACH 
         END IF
         IF amt2 IS NULL THEN LET amt2 = 0 END IF
      END IF

      LET amt3 = 0
      LET l_d = 0
      LET l_c = 0
      SELECT SUM(axj07) INTO l_d
        FROM axi_file,axj_file
       WHERE axi00 = axj00 
         AND axj03 BETWEEN maj.maj21 AND maj.maj22
         AND axi01 = axj01
         AND axi00 = tm.b_1
         AND axi03 = tm.yy
         AND axi04 = tm.em
         AND axi08 = '5'
         AND axi05 = tm.axa01_1
         AND axi06 = tm.axa02_1
         AND axi09 = 'N'
         AND axiconf = 'Y'
         AND axj06 = '1'  #借方
      IF cl_null(l_d) THEN LET l_d = 0 END IF

      SELECT SUM(axj07) INTO l_c
        FROM axi_file,axj_file
       WHERE axi00 = axj00 
         AND axj03 BETWEEN maj.maj21 AND maj.maj22
         AND axi01 = axj01
         AND axi00 = tm.b_1
         AND axi03 = tm.yy
         AND axi04 = tm.em
         AND axi08 = '5'
         AND axi05 = tm.axa01_1
         AND axi06 = tm.axa02_1
         AND axi09 = 'N'
         AND axiconf = 'Y'
         AND axj06 = '2'  #貸方
      IF cl_null(l_c) THEN LET l_c = 0 END IF
      LET amt3 = l_d - l_c

      LET amt4 = 0
      LET l_d = 0
      LET l_c = 0
      SELECT SUM(axj07) INTO l_d
        FROM axi_file,axj_file
       WHERE axi00 = axj00 
         AND axj03 BETWEEN maj.maj21 AND maj.maj22
         AND axi01 = axj01
         AND axi00 = tm.b_1
         AND axi03 = tm.yy
         AND axi04 = tm.em
         AND axi08 = '6'
         AND axi05 = tm.axa01_1
         AND axi06 = tm.axa02_1
         AND axi09 = 'N'
         AND axiconf = 'Y'
         AND axj06 = '2'  #借方
      IF cl_null(l_d) THEN LET l_d = 0 END IF

      SELECT SUM(axj07) INTO l_c
        FROM axi_file,axj_file
       WHERE axi00 = axj00 
         AND axj03 BETWEEN maj.maj21 AND maj.maj22
         AND axi01 = axj01
         AND axi00 = tm.b_1
         AND axi03 = tm.yy
         AND axi04 = tm.em
         AND axi08 = '6'
         AND axi05 = tm.axa01_1
         AND axi06 = tm.axa02_1
         AND axi09 = 'N'
         AND axiconf = 'Y'
         AND axj06 = '2'  #貸方
      IF cl_null(l_c) THEN LET l_c = 0 END IF
      LET amt4 = l_d - l_c

      END IF
     #-->匯率的轉換
      IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF
     #-->合計階數處理
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
         FOR i = 1 TO 100
            IF maj.maj09 = '-' THEN
               LET g_tot1[i] = g_tot1[i] - amt1
               LET g_tot2[i] = g_tot2[i] - amt2
               LET g_tot3[i] = g_tot3[i] - amt3
               LET g_tot4[i] = g_tot4[i] - amt4
           ELSE
               LET g_tot1[i] = g_tot1[i] + amt1
               LET g_tot2[i] = g_tot2[i] + amt2
               LET g_tot3[i] = g_tot3[i] + amt3
               LET g_tot4[i] = g_tot4[i] + amt4
           END IF
         END FOR
         LET k=maj.maj08
         LET sr.bal1=g_tot1[k]
         LET sr.bal2=g_tot2[k]
         LET sr.bal3=g_tot3[k]
         LET sr.bal4=g_tot4[k]
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal2 = sr.bal2 *-1
            LET sr.bal3 = sr.bal3 *-1
            LET sr.bal4 = sr.bal4 *-1
         END IF
         FOR i = 1 TO maj.maj08 
            LET g_tot1[i]=0
            LET g_tot2[i]=0
            LET g_tot3[i]=0
            LET g_tot4[i]=0
         END FOR
      ELSE
         IF maj.maj03='5' THEN
            LET sr.bal1=amt1
            LET sr.bal2=amt2
            LET sr.bal3=amt3
            LET sr.bal4=amt4
         ELSE
            LET sr.bal1=NULL
         END IF
      END IF
      IF maj.maj07 = '2' THEN
         LET sr.bal1 = sr.bal1 * -1
         LET sr.bal2 = sr.bal2 * -1
         LET sr.bal3 = sr.bal3 * -1
         LET sr.bal4 = sr.bal4 * -1
      END IF

     #-->百分比基準科目  ?
#     IF maj.maj11 = 'Y' THEN                  
#        LET g_basetot1=sr.bal1
#        IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
#        LET g_basetot1=g_basetot1/g_unit
#     END IF
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
     #-->餘額為 0 者不列印
      IF (tm.c='N' OR maj.maj03='2') AND
          maj.maj03 MATCHES "[0125]" AND sr.bal1=0 THEN
         CONTINUE FOREACH                        
      END IF
     #-->最小階數起列印
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        
      END IF

     #-->列印額外名稱
      IF tm.h = 'Y' THEN
         LET maj.maj20 = maj.maj20e
         LET maj.maj32 = maj.maj33
      END IF
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
      LET maj.maj32 = maj.maj05 SPACES,maj.maj32
     
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      IF maj.maj04 = 0 THEN
         EXECUTE insert_prep USING maj.maj32,sr.bal2,sr.bal3,sr.bal4,sr.bal1,
                                   maj.maj20,maj.maj02,maj.maj03,'2',maj.maj05
      ELSE
         EXECUTE insert_prep USING maj.maj32,sr.bal2,sr.bal3,sr.bal4,sr.bal1,
                                   maj.maj20,maj.maj02,maj.maj03,'2',maj.maj05
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING maj.maj32,'0','0','0','0',
                                      maj.maj20,maj.maj02,maj.maj03,'1',maj.maj05
         END FOR
      END IF
   END FOREACH

   IF tm.rtype = '1' THEN  
      LET tm.bm = l_bm 
      DISPLAY BY NAME tm.bm 
   END IF
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   SELECT azi05 INTO l_e FROM azi_file WHERE azi01 = tm.p
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY maj02"
   LET l_lastday = MDY(tm.em,'1',tm.yy)
   LET l_lastday = s_last(l_lastday)
             #     p1        p2       p3       p4       p5       p6
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",tm.bm,";",
###GENGRE###             #    p7         p8           p9        p10       p11
###GENGRE###               tm.e,";",l_lastday,";",tm.rtype,";",tm.em,";",l_e
 
###GENGRE###   CALL cl_prt_cs3('aglg023','aglg023',l_sql,g_str)
    CALL aglg023_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
   
END FUNCTION

FUNCTION g023_set_entry()
  CALL cl_set_comp_entry("q1,em,h1",TRUE)
END FUNCTION
 
FUNCTION g023_set_no_entry()
   IF tm.axa06 ="1" THEN  
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN  
      CALL cl_set_comp_entry("em,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN
      CALL cl_set_comp_entry("em,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN  
      CALL cl_set_comp_entry("q1,em,h1",FALSE)
   END IF
END FUNCTION


###GENGRE###START
FUNCTION aglg023_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg023")
        IF handler IS NOT NULL THEN
            START REPORT aglg023_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"  ORDER BY maj02, line"
          
            DECLARE aglg023_datacur1 CURSOR FROM l_sql
            FOREACH aglg023_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg023_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg023_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg023_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_unit     STRING
    DEFINE l_lastday     STRING
    DEFINE l_amt_fmt  STRING  

    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit
            LET l_lastday = MDY(tm.em,'1',tm.yy)
            LET l_lastday = s_last(l_lastday)
            PRINTX l_lastday
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_amt_fmt = cl_gr_numfmt('axh_file','axh08',tm.e)
            PRINTX l_amt_fmt            
            PRINTX sr1.*

        
        ON LAST ROW

END REPORT
###GENGRE###END
