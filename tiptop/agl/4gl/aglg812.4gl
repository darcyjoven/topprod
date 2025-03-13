# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg812.4gl
# Descriptions...: 多維度異動碼財務報表
# Input parameter: 
# Return code....: 
# Date & Author..: 10/12/23 FUN-AA0045 BY Summer
# Modify.........: No.FUN-B90027 11/09/13 BY Wangning 明細CR報表轉GR
# Modify.........: No.FUN-C20080 12/02/28 BY yangtt GR調整
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

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

###GENGRE###START
TYPE sr1_t RECORD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    line LIKE type_file.num5,
    aeh31 LIKE aeh_file.aeh31,
    aeh32 LIKE aeh_file.aeh32,
    aeh33 LIKE aeh_file.aeh33,
    aeh34 LIKE aeh_file.aeh34,
    amt LIKE aeh_file.aeh11,
    l_aeh31 LIKE ahe_file.ahe02,
    l_aeh32 LIKE ahe_file.ahe02,
    l_aeh33 LIKE ahe_file.ahe02,
    l_aeh34 LIKE ahe_file.ahe02
END RECORD
###GENGRE###END

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
               "aeh31.aeh_file.aeh31,",
               "aeh32.aeh_file.aeh32,",
               "aeh33.aeh_file.aeh33,",
               "aeh34.aeh_file.aeh34,",
               "amt.aeh_file.aeh11,",
               "l_aeh31.ahe_file.ahe02,",
               "l_aeh32.ahe_file.ahe02,",
               "l_aeh33.ahe_file.ahe02,",
               "l_aeh34.ahe_file.ahe02,"
               

   LET l_table = cl_prt_temptable('aglg812',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN                        # Temp Table產生
      CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
      EXIT PROGRAM
   END IF               
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
      CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
      EXIT PROGRAM                         
   END IF          
   
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   
   IF cl_null(tm.bookno) THEN
      LET tm.bookno = g_aza.aza81
   END IF 
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g812_tm()
   ELSE
      CALL g812()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)        #FUN-B90027
END MAIN

FUNCTION g812_tm()
   DEFINE p_row,p_col       LIKE type_file.num5,
          l_sw              LIKE type_file.chr1,      #重要欄位是否空白
          l_cmd             LIKE type_file.chr1000
   DEFINE li_chk_bookno     LIKE type_file.num5
   DEFINE li_result         LIKE type_file.num5

   CALL s_dsmark(g_bookno)

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW g812_w AT p_row,p_col
     WITH FORM "agl/42f/aglg812"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
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
            CALL g812_set_entry()  
      
         AFTER FIELD rtype 
            IF tm.rtype='1' THEN
               LET tm.bm=0
               CALL g812_set_no_entry()
            END IF
            
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

      END INPUT
           
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglg812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME tm.wc ON aeh31,aeh32,aeh33,aeh34
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
            CASE
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
         CLOSE WINDOW aglg812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
         EXIT PROGRAM
      END IF
      
      DISPLAY BY NAME tm.more
 
      LET l_sw = 1
      INPUT BY NAME tm.bookno,tm.a,tm.yy,tm.bm,tm.em,
                    tm.e,tm.f,tm.d,tm.c,tm.h,
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
         CLOSE WINDOW g812_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aglg812'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg812','9031',1)   
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
            CALL cl_cmdat('aglg812',g_time,l_cmd)    # Execute cmd at later time
         END IF

         DISPLAY "l_cmd 2:" , l_cmd
         CLOSE WINDOW g812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
         EXIT PROGRAM
      END IF

      CALL cl_wait()
      CALL g812()

      ERROR ""
   END WHILE

   CLOSE WINDOW g812_w

END FUNCTION

FUNCTION g812()
   DEFINE l_name    LIKE type_file.chr20
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       aeh31      LIKE aeh_file.aeh31,
                       aeh32      LIKE aeh_file.aeh32,
                       aeh33      LIKE aeh_file.aeh33,
                       aeh34      LIKE aeh_file.aeh34,
                       amt        LIKE aeh_file.aeh11
                    END RECORD
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE i,k       LIKE type_file.num5
   DEFINE l_aeh31   LIKE ahe_file.ahe02
   DEFINE l_aeh32   LIKE ahe_file.ahe02
   DEFINE l_aeh33   LIKE ahe_file.ahe02
   DEFINE l_aeh34   LIKE ahe_file.ahe02
   DEFINE l_i_cnt31 LIKE type_file.num5
   DEFINE l_i_cnt32 LIKE type_file.num5
   DEFINE l_i_cnt33 LIKE type_file.num5
   DEFINE l_i_cnt34 LIKE type_file.num5
   
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
   PREPARE g812_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)               #FUN-B90027
      EXIT PROGRAM 
   END IF
   DECLARE g812_c CURSOR FOR g812_p

   LET g_mm = tm.em

   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0
   END FOR

   FOREACH g812_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
      
      LET l_flag='Y'
      LET sr.aeh31 = ''
      LET sr.aeh32 = ''
      LET sr.aeh33 = ''
      LET sr.aeh34 = ''
      LET sr.amt = 0
      
      IF NOT cl_null(maj.maj21) THEN
         IF cl_null(maj.maj22) THEN
            LET maj.maj22 = maj.maj21
         END IF
         LET l_sql=" SELECT aeh31,aeh32,aeh33,aeh34,SUM(aeh11-aeh12)",
                   "   FROM aeh_file ",
                   "  WHERE aeh00 = '",tm.bookno,"'",
                   "    AND aeh01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
                   "    AND aeh09 =  ",tm.yy,
                   "    AND aeh10 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
                   "    AND ",tm.wc CLIPPED,
                   " GROUP BY aeh31,aeh32,aeh33,aeh34 "
         PREPARE g812_prepare1 FROM l_sql                                                                                          
         DECLARE g812_c1  CURSOR FOR g812_prepare1 
         FOREACH g812_c1 INTO sr.*
            LET l_flag='N'
            

            #-->匯率的轉換
            IF tm.o = 'Y' THEN 
               LET sr.amt = sr.amt * tm.q
            END IF 

            #-->合計階數處理
            IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
               FOR i = 1 TO 100
                  IF maj.maj09 = '-' THEN
                     LET g_tot1[i] = g_tot1[i] - sr.amt
                  ELSE
                     LET g_tot1[i] = g_tot1[i] + sr.amt
                  END IF
               END FOR
               LET k=maj.maj08  LET sr.amt=g_tot1[k]
               IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
                  LET sr.amt = sr.amt *-1
               END IF

               FOR i = 1 TO maj.maj08
                  LET g_tot1[i] = 0
               END FOR
            ELSE
               IF maj.maj03 <> '5' THEN
                  LET sr.amt = NULL
               END IF
            END IF

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
            
            CALL g812_ahe02(g_aaz.aaz121) RETURNING l_aeh31
            CALL g812_ahe02(g_aaz.aaz122) RETURNING l_aeh32
            CALL g812_ahe02(g_aaz.aaz123) RETURNING l_aeh33
            CALL g812_ahe02(g_aaz.aaz124) RETURNING l_aeh34
            
            EXECUTE insert_prep USING                                              
                    maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'2',
                    sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
                    l_aeh31,l_aeh32,l_aeh33,l_aeh34
            IF maj.maj04 > 0 THEN                                                     
               #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
               #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
               #讓空行的這筆資料排在正常的資料前面印出
               FOR i = 1 TO maj.maj04                                                 
               EXECUTE insert_prep USING                                              
                  maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'1',                     
                  sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
                  l_aeh31,l_aeh32,l_aeh33,l_aeh34                                                            
               END FOR                                                                
            END IF
         END FOREACH
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

         #-->合計階數處理
         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
            FOR i = 1 TO 100
               IF maj.maj09 = '-' THEN
                  LET g_tot1[i] = g_tot1[i] - sr.amt
               ELSE
                  LET g_tot1[i] = g_tot1[i] + sr.amt
               END IF
            END FOR
            LET k=maj.maj08  LET sr.amt=g_tot1[k]
            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
               LET sr.amt = sr.amt *-1
            END IF

            FOR i = 1 TO maj.maj08
               LET g_tot1[i] = 0
            END FOR
         ELSE
            IF maj.maj03 <> '5' THEN
               LET sr.amt = NULL
            END IF
         END IF

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
         
         CALL g812_ahe02(g_aaz.aaz121) RETURNING l_aeh31
         CALL g812_ahe02(g_aaz.aaz122) RETURNING l_aeh32
         CALL g812_ahe02(g_aaz.aaz123) RETURNING l_aeh33
         CALL g812_ahe02(g_aaz.aaz124) RETURNING l_aeh34
         
         EXECUTE insert_prep USING                                              
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'2',
                 sr.aeh31,sr.aeh32,sr.aeh33,sr.aeh34,sr.amt,
                 l_aeh31,l_aeh32,l_aeh33,l_aeh34
         IF maj.maj04 > 0 THEN                                                     
            #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
            #讓空行的這筆資料排在正常的資料前面印出
            FOR i = 1 TO maj.maj04                                                 
            EXECUTE insert_prep USING                                              
               maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'1',                     
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
   
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.e,";",l_i_cnt31,";",l_i_cnt32,";",
###GENGRE###               l_i_cnt33,";",l_i_cnt34

###GENGRE###   CALL cl_prt_cs3('aglg812','aglg812',g_sql,g_str)               
    CALL aglg812_grdata()    ###GENGRE###

END FUNCTION

FUNCTION g812_ahe02(p_giu)
 DEFINE  p_giu     LIKE giu_file.giu15,
         l_ahe02   LIKE ahe_file.ahe02

 SELECT ahe02 INTO l_ahe02 FROM ahe_file
  WHERE ahe01 = p_giu

 RETURN l_ahe02

END FUNCTION

FUNCTION g812_set_entry() 

   IF INFIELD(rtype) THEN
      CALL cl_set_comp_entry("bm",TRUE)
   END IF 

END FUNCTION

FUNCTION g812_set_no_entry()

   IF INFIELD(rtype) AND tm.rtype = '1' THEN
      CALL cl_set_comp_entry("bm",FALSE)
   END IF 

END FUNCTION
#FUN-AA0045

###GENGRE###START
FUNCTION aglg812_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg812")
        IF handler IS NOT NULL THEN
            START REPORT aglg812_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg812_datacur1 CURSOR FROM l_sql
            FOREACH aglg812_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg812_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg812_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg812_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B90027----add----str--------
    DEFINE l_fmt   STRING
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_display3  LIKE type_file.chr1
    DEFINE l_display4  LIKE type_file.chr1
    DEFINE l_title2      STRING
    #FUN-B90027----add----end-------

    
    ORDER EXTERNAL BY sr1.maj20
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name            #FUN-B90027  add g_ptime,g_user_name
#FUN-B90027---------STAR----------
            IF g_aaz.aaz77 = 'Y' THEN
               LET l_title2 = g_mai02
            ELSE
               LET l_title2 = g_grPageHeader.title2
            END IF
            PRINTX l_title2
#FUN-B90027---------END---------
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.maj20

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B90027----add----str--------
       #    LET l_fmt = cl_gr_numfmt("type_file","num5",tm.e)       #FUN-C20080 mark
            LET l_fmt = cl_gr_numfmt("aeh_file","aeh11",tm.e)       #FUN-C20080 add
            PRINTX l_fmt
  
            IF cl_null(sr1.l_aeh31) THEN
               LET l_display1 = 'N'
            ELSE
               LET l_display1 = 'Y'
            END IF
            PRINTX l_display1

            IF cl_null(sr1.l_aeh32) THEN
               LET l_display2 = 'N'
            ELSE
               LET l_display2 = 'Y'
            END IF
            PRINTX l_display2

            IF cl_null(sr1.l_aeh33) THEN
               LET l_display3 = 'N'
            ELSE
               LET l_display3 = 'Y'
            END IF
            PRINTX l_display3

            IF cl_null(sr1.l_aeh34) THEN
               LET l_display4 = 'N'
            ELSE
               LET l_display4 = 'Y'
            END IF
            PRINTX l_display4
            #FUN-B90027----add----end--------

            PRINTX sr1.*

        AFTER GROUP OF sr1.maj20

        
        ON LAST ROW

END REPORT
###GENGRE###END
