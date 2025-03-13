# Prog. Version..: '5.30.07-13.05.20(00005)'     #
#
# Pattern name...: aglr815.4gl
# Descriptions...: 合併后單一異動碼兩期比較表
# Input parameter:
# Date & Author..: FUN-B50057 11/03/28 BY zhangweib
# Modify.........: No:MOD-BC0032 11/12/05 By Carrier 帐结法时,损益科目月结金额会被结清,报表呈现时,要把CE凭证的金额减回
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.CHI-C70031 12/10/18 By wangwei 加傳參數
# Modify.........: No:FUN-D40044 13/04/25 By zhangweib 增加選項：是否包含結轉憑證.若=N,則扣除CE/CA（axcq310）的金額

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm          RECORD
          wc       STRING,                         #FUN-B50057
          rtype    LIKE type_file.chr1,            #報表結構編號
          s        LIKE type_file.chr1,
          aeh31    LIKE aeh_file.aeh31,
          aeh32    LIKE aeh_file.aeh32,
          aeh33    LIKE aeh_file.aeh33,
          aeh34    LIKE aeh_file.aeh34,
          aeh00    LIKE aeh_file.aeh00,            #帳別
          a        LIKE mai_file.mai01,            #報表結構編號
          b        LIKE aaa_file.aaa01,            #報表結構編號
          title1   LIKE type_file.chr50,           #輸入期別名稱
          title1_1 LIKE type_file.chr50,           #輸入期別名稱
          yy1      LIKE type_file.num5,            #輸入年度
          bm1      LIKE type_file.num5,            #Begin 期別
          em1      LIKE type_file.num5,            # End  期別
          title2   LIKE type_file.chr50,           #輸入期別名稱
          title2_1 LIKE type_file.chr50,           #輸入期別名稱
          yy2      LIKE type_file.num5,            #輸入年度
          bm2      LIKE type_file.num5,            #Begin 期別
          em2      LIKE type_file.num5,            # End  期別
          c        LIKE type_file.chr1,            #異動額及餘額為0者是否列印
          d        LIKE type_file.chr1,            #金額單位
          e        LIKE type_file.num5,            #小數位數
          f        LIKE type_file.num5,            #列印最小階數
          h        LIKE type_file.chr4,            #額外說明類別
          o        LIKE type_file.chr1,            #轉換幣別否
          p        LIKE azi_file.azi01,            #幣別
          q        LIKE azj_file.azj03,            #匯率
          r        LIKE azi_file.azi01,            #幣別
          ce       LIKE type_file.chr1,            #No.FUN-D40044   Add
          more     LIKE type_file.chr1             #Input more condition(Y/N)
                   END RECORD,
       g_unit      LIKE type_file.num10,           #金額單位基數
       g_bookno    LIKE axh_file.axh00,            #帳別  
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_tot1      ARRAY[100] OF LIKE type_file.num20_6,   
       g_tot2      ARRAY[100] OF LIKE type_file.num20_6,
       g_basetot1  LIKE axh_file.axh08,
       g_basetot2  LIKE axh_file.axh08
DEFINE g_aaa03     LIKE aaa_file.aaa03   
DEFINE g_i         LIKE type_file.num5             #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000 
DEFINE l_table     STRING                
DEFINE l_table1    STRING        #No.FUN-D40044   Add       
DEFINE g_str       STRING               
DEFINE g_sql       STRING              
DEFINE g_sql_1     STRING              
DEFINE x_aaa03     LIKE aaa_file.aaa03
DEFINE g_aaz641    LIKE aaz_file.aaz641
DEFINE g_axz03     LIKE axz_file.axz03
DEFINE g_axa09     LIKE axa_file.axa09 
DEFINE g_axa05     LIKE axa_file.axa05   
DEFINE g_aeh31     LIKE aeh_file.aeh31
DEFINE g_cnt       LIKE type_file.num5
DEFINE t_aeh31     LIKE aeh_file.aeh31
                 
MAIN       
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.wc = ARG_VAL(9)
   LET tm.aeh00 = ARG_VAL(12)
   LET tm.a = ARG_VAL(13)
   LET tm.yy1 = ARG_VAL(16)
   LET tm.bm1 = ARG_VAL(17)
   LET tm.em1 = ARG_VAL(18)
   LET tm.yy2 = ARG_VAL(23)
   LET tm.bm2 = ARG_VAL(24)
   LET tm.em2 = ARG_VAL(25)
   LET tm.e = ARG_VAL(30) 
   LET tm.f = ARG_VAL(31)
   LET tm.d = ARG_VAL(32)
   LET tm.c = ARG_VAL(33)
   LET tm.h = ARG_VAL(34)
   LET tm.o = ARG_VAL(35)
   LET tm.r = ARG_VAL(36)
   LET tm.p = ARG_VAL(37)
   LET tm.q = ARG_VAL(38)
   LET tm.ce= ARG_VAL(39)
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   

   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " maj01.maj_file.maj01, ",
               " maj02.maj_file.maj02, ",
               " maj03.maj_file.maj03, ",
               " maj04.maj_file.maj04, ",
               " maj05.maj_file.maj05, ",
               " maj06.maj_file.maj06, ",
               " maj07.maj_file.maj07, ",
               " maj08.maj_file.maj08, ",
               " maj09.maj_file.maj09, ",
               " maj10.maj_file.maj10, ",
               " maj11.maj_file.maj11, ",
               " maj20.maj_file.maj20, ",
               " maj20e.maj_file.maj20e, ",
               " maj21.maj_file.maj21, ",
               " maj22.maj_file.maj22, ",
               " maj23.maj_file.maj23, ",
               " maj24.maj_file.maj24, ",
               " maj25.maj_file.maj25, ",
               " maj26.maj_file.maj26, ",
               " maj27.maj_file.maj27, ",
               " maj28.maj_file.maj28, ",
               " maj29.maj_file.maj29, ",
               " maj30.maj_file.maj30, ",
               " line.type_file.num5, ",
               " amt1.axh_file.axh08,  ",
               " amt2.axh_file.axh08,  ",
               " azi03.azi_file.azi03, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05, ",
               " aeh31.aeh_file.aeh31,  ",
               " yy1.type_file.chr5, ",
               " yy2.type_file.chr5, ",
               " title1.type_file.chr50, ",
               " title2.type_file.chr50 "
  
   LET l_table = cl_prt_temptable('aglr815',g_sql) CLIPPED  # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生有錯
  #No.FUN-D40044 ---Add--- Start
   LET l_table1 = cl_prt_temptable('aglr8151',g_sql) CLIPPED  # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生有錯
  #No.FUN-D40044 ---Add--- End
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
               
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r815_tm()
   ELSE 
      CALL r815()
   END IF       

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN        

FUNCTION r815_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_sw           LIKE type_file.chr1          #重要欄位是否空白
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5
   DEFINE l_dbs          LIKE type_file.chr21
   DEFINE l_aaa05        LIKE aaa_file.aaa05
   DEFINE l_aznn01       LIKE aznn_file.aznn01
   DEFINE l_dbs2         LIKE type_file.chr21

   CALL s_dsmark(g_bookno)

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r815_w AT p_row,p_col WITH FORM "agl/42f/aglr815"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
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

   LET tm.aeh00 = g_bookno
   LET tm.e = 0
   LET tm.f = 0
   LET tm.d = '1'
   LET tm.c = 'Y'
   LET tm.h = 'N' 
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.ce= 'N'    #No.FUN-D40044   Add
   LET tm.more = 'N'
   
   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   
   LET tm.title1 = 'M.T.D.'
   LET tm.title2 = 'Y.T.D.'

   WHILE TRUE
      INPUT BY NAME tm.rtype WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr815_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      INPUT BY NAME tm.s,tm.aeh31,tm.aeh32,tm.aeh33,tm.aeh34 WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
   
         AFTER FIELD s
            IF NOT cl_null(tm.s) THEN
               CALL cl_set_comp_entry("aeh31,aeh32,aeh33,aeh34",TRUE)
               IF tm.s = '1' THEN
                  LET tm.aeh32 = ''
                  LET tm.aeh33 = ''
                  LET tm.aeh34 = ''
                  CALL cl_set_comp_entry("aeh32,aeh33,aeh34",FALSE)
               END IF 
               IF tm.s = '2' THEN 
                  LET tm.aeh31 = ''
                  LET tm.aeh33 = ''
                  LET tm.aeh34 = '' 
                  CALL cl_set_comp_entry("aeh31,aeh33,aeh34",FALSE)
               END IF
               IF tm.s = '3' THEN
                  LET tm.aeh31 = ''
                  LET tm.aeh32 = ''
                  LET tm.aeh34 = ''
                  CALL cl_set_comp_entry("aeh31,aeh32,aeh34",FALSE)
               END IF
              IF tm.s = '4' THEN
                  LET tm.aeh31 = ''
                  LET tm.aeh32 = ''
                  LET tm.aeh33 = ''
                  CALL cl_set_comp_entry("aeh31,aeh32,aeh33",FALSE)
              END IF
               DISPLAY BY NAME tm.aeh31,tm.aeh32,tm.aeh33,tm.aeh34
            ELSE
               NEXT FIELD s
            END IF

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr815_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      DISPLAY BY NAME tm.more

      LET l_sw = 1

      INPUT BY NAME tm.aeh00,tm.a,tm.yy1,tm.bm1,tm.em1,
                    tm.yy2,tm.bm2,tm.em2,
                    tm.e,tm.f,tm.d,tm.c,tm.h,tm.ce,tm.o,tm.r,   #No.FUN-D40044   Add
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_init()

      BEFORE FIELD bm1
         IF tm.rtype='1' THEN
            LET tm.bm1= 0
            DISPLAY  BY NAME tm.bm1
         END IF

      AFTER FIELD bm1
         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
         IF NOT cl_null(tm.em1) AND tm.em1 <> 0 THEN
            IF tm.em1 < tm.bm1 THEN NEXT FIELD bm1 END IF
         END IF 
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
         IF tm.yy2 IS NULL THEN
            LET tm.yy2 = tm.yy1
            LET tm.bm2 = tm.bm1
         END IF

         BEFORE FIELD bm2
            IF tm.rtype='1' THEN
               LET tm.bm2 = 0
               DISPLAY  BY NAME tm.bm2
            END IF

         AFTER FIELD bm2
            IF NOT cl_null(tm.em2) AND tm.em2 <> 0 THEN
               IF tm.em2 < tm.bm2 THEN NEXT FIELD bm2 END IF
            END IF

         AFTER FIELD em2
            IF tm.em2 IS NULL THEN NEXT FIELD em2 END IF
            IF tm.em2 < tm.bm2 THEN NEXT FIELD em2 END IF
            IF NOT cl_null(tm.em2) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy2
               IF g_azm.azm02 = 1 THEN
                  IF tm.em2 > 12 OR tm.em2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em2
                  END IF
               ELSE
                  IF tm.em2 > 13 OR tm.em2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em2
                  END IF
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
                AND mai00 = tm.aeh00
                AND maiacti ='Y'
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
             IF g_mai03 = '2' THEN LET tm.rtype = '1' END IF
             IF g_mai03 = '3' THEN LET tm.rtype = '2' END IF
          END IF

      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
            
      AFTER FIELD yy1
         IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
            NEXT FIELD yy1
         END IF
          
      AFTER FIELD em1
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
         IF tm.em1 < tm.bm1 THEN NEXT FIELD em1 END IF
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
         IF tm.yy2 IS NULL THEN
            LET tm.yy2 = tm.yy1
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
         END IF

      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
         
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
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)
            NEXT FIELD p
         END IF

      BEFORE FIELD q
         IF tm.o = 'N' THEN NEXT FIELD o END IF

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF 
            
      AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.yy1 IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy1
            CALL cl_err('',9033,0)
        END IF
        IF l_sw = 0 THEN
            LET l_sw = 1 
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
         CALL r815_getmsg(tm.bm1) RETURNING tm.title1_1
         CALL r815_getmsg(tm.bm2) RETURNING tm.title2_1
         CALL r815_getmsg(tm.em1) RETURNING tm.title1  
         CALL r815_getmsg(tm.em2) RETURNING tm.title2  
             
         LET tm.title1 = tm.title1_1,"-",tm.title1
         LET tm.title2 = tm.title2_1,"-",tm.title2

################################################################################
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
################################################################################
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
         IF INFIELD(a) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
           #LET g_qryparam.where = " mai00 = '",tm.aeh00,"'"   #No.TQC-C50042   Mark
            LET g_qryparam.where = " mai00 = '",tm.aeh00,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
            CALL cl_create_qry() RETURNING tm.a
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
            
      ON ACTION about        
         CALL cl_about()

      ON ACTION help
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
      LET INT_FLAG = 0 CLOSE WINDOW r815_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM

   END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr815'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr815','9031',1)
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
                         " '",tm.wc  CLIPPED,"'",
                         " '",tm.aeh00  CLIPPED,"'",
                         " '",tm.a  CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.bm1 CLIPPED,"'",
                         " '",tm.em1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.bm2 CLIPPED,"'",
                         " '",tm.em2 CLIPPED,"'",
                         " '",tm.e  CLIPPED,"'",
                         " '",tm.f  CLIPPED,"'",
                         " '",tm.d  CLIPPED,"'",
                         " '",tm.c  CLIPPED,"'",
                         " '",tm.h  CLIPPED,"'",
                         " '",tm.o  CLIPPED,"'",
                         " '",tm.r  CLIPPED,"'",
                         " '",tm.p  CLIPPED,"'",
                         " '",tm.q  CLIPPED,"'"

            CALL cl_cmdat('aglr815',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r815_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r815()

      ERROR ""
      LET tm.title1   = NULL
      LET tm.title1_1 = NULL
      LET tm.title2   = NULL
      LET tm.title2_1 = NULL
   END WHILE
   CLOSE WINDOW r815_w
END FUNCTION

FUNCTION r815()
   DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT     
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE g_i       LIKE type_file.num5   
   DEFINE amt1,amt2  LIKE axh_file.axh08
   DEFINE amt1_pro   LIKE axh_file.axh08
   DEFINE amt2_pro   LIKE axh_file.axh08
   DEFINE sr        RECORD 
                       bal1      LIKE axh_file.axh08,
                       bal2      LIKE axh_file.axh08,
                       bal3      LIKE axh_file.axh08
                    END RECORD
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE i,k       LIKE type_file.num5
  #DEFINE l_aeh31  LIKE ahe_file.ahe02      #FUN-BC0004 Mark
  #DEFINE l_i_cnt05 LIKE type_file.num5     #FUN-BC0004 Mark
   DEFINE l_aeh10_f1 LIKE aeh_file.aeh10
   DEFINE l_aeh10_f2 LIKE aeh_file.aeh10
   #No.TQC-BC0032  --Begin
   DEFINE l_aaa09     LIKE aaa_file.aaa09
   DEFINE l_aeh11     LIKE aeh_file.aeh11
   DEFINE l_aeh12     LIKE aeh_file.aeh12
   DEFINE l_aeh15     LIKE aeh_file.aeh15
   DEFINE l_aeh16     LIKE aeh_file.aeh16
   DEFINE l_aeh31     LIKE aeh_file.aeh31
   DEFINE l_aeh32     LIKE aeh_file.aeh32
   DEFINE l_aeh33     LIKE aeh_file.aeh33
   DEFINE l_aeh34     LIKE aeh_file.aeh34
   #No.TQC-BC0032  --End
         
   CALL cl_del_data(l_table)
      
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.aeh00 AND aaf02 = g_rlang

   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" SUBSTR(maj23,1,1)='1'"
        WHEN tm.rtype='2' LET g_msg=" SUBSTR(maj23,1,1)='2'"
        OTHERWISE LET g_msg = " 1=1"
   END CASE

   #No.MOD-BC0032  --Begin
   SELECT aaa09 INTO l_aaa09 FROM aaa_file WHERE aaa01 = tm.aeh00
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','aaa_file',tm.aeh00,'',SQLCA.sqlcode,'','select aaa09',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF cl_null(l_aaa09) THEN
      CALL cl_err('aaa09 is null','ggl-009',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   LET l_aeh31 = NULL   LET l_aeh32 = NULL
   LET l_aeh33 = NULL   LET l_aeh34 = NULL
   #No.MOD-BC0032  --End
  #No.FUN-D40044 ---Mark--- Start
  #CASE 
  #   WHEN tm.s = '1'
  #      LET g_aeh31 = tm.aeh31
  #      LET l_aeh31 = g_aeh31   #No.MOD-BC0032
  #   WHEN tm.s = '2'
  #      LET g_aeh31 = tm.aeh32
  #      LET l_aeh32 = g_aeh31   #No.MOD-BC0032
  #   WHEN tm.s = '3'
  #      LET g_aeh31 = tm.aeh33
  #      LET l_aeh33 = g_aeh31   #No.MOD-BC0032
  #   WHEN tm.s = '4'            
  #      LET g_aeh31 = tm.aeh34
  #      LET l_aeh34 = g_aeh31   #No.MOD-BC0032
  #END CASE
  #No.FUN-D40044 ---Mark--- End
  #No.FUN-D40044 ---Add--- Start
   LET g_sql = "SELECT * FROM "
   CASE
      WHEN tm.s = '1'
         LET g_sql = g_sql CLIPPED," (SELECT DISTINCT aeh31 "
      WHEN tm.s = '2'
         LET g_sql = g_sql CLIPPED," (SELECT DISTINCT aeh32 "
      WHEN tm.s = '3'
         LET g_sql = g_sql CLIPPED," (SELECT DISTINCT aeh33 "
      WHEN tm.s = '4'
         LET g_sql = g_sql CLIPPED," (SELECT DISTINCT aeh34 "
   END CASE
   LET g_sql = g_sql CLIPPED,
             "  FROM aeh_file",
             " WHERE aeh00 = '",tm.aeh00,"'",
             "   AND (aeh09 = ",tm.yy1," OR aeh09 = ",tm.yy2,")"
   CASE
      WHEN tm.s = '1' AND tm.aeh31 != '*'
         LET g_sql = g_sql CLIPPED,"  AND aeh31 IS NOT NULL  AND aeh31 <> ' '",
                                   "   AND ",tm.aeh31 CLIPPED,
                                   ") z "
      WHEN tm.s = '2' AND tm.aeh32 != '*'
         LET g_sql = g_sql CLIPPED,"  AND aeh32 IS NOT NULL  AND aeh32 <> ' '",
                                   "   AND ",tm.aeh32 CLIPPED,
                                   ") z "
      WHEN tm.s = '3' AND tm.aeh33 != '*'
         LET g_sql = g_sql CLIPPED,"  AND aeh33 IS NOT NULL  AND aeh33 <> ' '",
                                   "   AND ",tm.aeh33 CLIPPED,
                                   ") z "
      WHEN tm.s = '4' AND tm.aeh34 != '*'
         LET g_sql = g_sql CLIPPED,"  AND aeh34 IS NOT NULL  AND aeh34 <> ' '",
                                   "   AND ",tm.aeh34 CLIPPED,
                                   ") z "
      OTHERWISE
         LET g_sql = g_sql CLIPPED,") z "
   END CASE
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE sel_aeh31_pre FROM g_sql
   DECLARE sel_aeh31_cs CURSOR FOR sel_aeh31_pre
   FOREACH sel_aeh31_cs INTO g_aeh31
   CASE
      WHEN tm.s = '1' LET t_aeh31 = tm.aeh31 LET l_aeh31 = g_aeh31
      WHEN tm.s = '2' LET t_aeh31 = tm.aeh32 LET l_aeh32 = g_aeh31
      WHEN tm.s = '3' LET t_aeh31 = tm.aeh33 LET l_aeh33 = g_aeh31
      WHEN tm.s = '4' LET t_aeh31 = tm.aeh34 LET l_aeh34 = g_aeh31
   END CASE
  #No.FUN-D40044 ---Add--- End

   LET l_sql = "SELECT * FROM maj_file",
              " WHERE maj01 = '",tm.a,"'",
              "   AND ",g_msg CLIPPED,
              " ORDER BY maj02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE r815_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r815_c CURSOR FOR r815_p
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR

   LET g_pageno = 0
   INITIALIZE maj.* TO NULL
   FOREACH r815_c INTO maj.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         IF NOT cl_null(maj.maj21) THEN
            IF cl_null(maj.maj22) THEN LET maj.maj22 = maj.maj21 END IF
            #第一期
            LET g_sql="SELECT SUM(aeh11-aeh12)",
             "  FROM aeh_file",
             " WHERE aeh00 = '",tm.aeh00,"'",
             "   AND aeh01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'", 
             "   AND aeh09 = '",tm.yy1,"'",
             "   AND aeh10 BETWEEN '",tm.bm1,"' AND '",tm.em1,"'"
             CASE 
                WHEN tm.s = '1'
                   LET g_sql = g_sql CLIPPED," AND aeh31 = '",l_aeh31,"'"   #No.FUN-D40044   Mod tm.aeh31 --> l_aeh31
                WHEN tm.s = '2'
                   LET g_sql = g_sql CLIPPED," AND aeh32 = '",l_aeh32,"'"   #No.FUN-D40044   Mod tm.aeh32 --> l_aeh32
                WHEN tm.s = '3'
                   LET g_sql = g_sql CLIPPED," AND aeh33 = '",l_aeh33,"'"   #No.FUN-D40044   Mod tm.aeh33 --> l_aeh33
                WHEN tm.s = '4'
                   LET g_sql = g_sql CLIPPED," AND aeh34 = '",l_aeh34,"'"   #No.FUN-D40044   Mod tm.aeh34 --> l_aeh34
             END CASE
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            PREPARE sel_aeh_pre1 FROM g_sql
            DECLARE sel_aeh_cs1 CURSOR FOR sel_aeh_pre1
            OPEN sel_aeh_cs1 
            LET amt1 = 0
            FETCH sel_aeh_cs1 INTO amt1
            IF amt1 IS NULL THEN LET amt1 = 0 END IF

            #No.TQC-BC0032  --Begin
            CALL s_minus_ce(tm.aeh00, maj.maj21, maj.maj22, NULL,    NULL,    NULL,
                            NULL,     NULL,      NULL,      NULL,    NULL,    tm.yy1,
                            tm.bm1,   tm.em1,    NULL,      l_aeh31, l_aeh32, l_aeh33,
                            l_aeh34,  NULL,      NULL,      NULL,    g_plant, l_aaa09,'0')  #CHI-C70031
                 RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
            #减借加贷
            IF tm.ce = 'N' THEN   #No.FUN-D40044   Add
               LET amt1 = amt1 - l_aeh11 + l_aeh12
            END IF                #No.FUN-D40044   Add
            #No.TQC-BC0032  --End

            #第二期
            LET g_sql="SELECT SUM(aeh11-aeh12)",
             "  FROM aeh_file,aag_file",
             " WHERE aeh00 = '",tm.aeh00,"'",
             "   AND aeh01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'", 
             "   AND aeh09 = '",tm.yy2,"'",
             "   AND aeh10 BETWEEN '",tm.bm2,"' AND '",tm.em2,"'"
            CASE
               WHEN tm.s = '1'
                  LET g_sql = g_sql CLIPPED," AND aeh31 = '",l_aeh31,"'"   #No.FUN-D40044   Mod tm.aeh31 --> l_aeh31
               WHEN tm.s = '2'
                  LET g_sql = g_sql CLIPPED," AND aeh32 = '",l_aeh32,"'"   #No.FUN-D40044   Mod tm.aeh32 --> l_aeh32
               WHEN tm.s = '3'
                  LET g_sql = g_sql CLIPPED," AND aeh33 = '",l_aeh33,"'"   #No.FUN-D40044   Mod tm.aeh33 --> l_aeh33
               WHEN tm.s = '4'
                  LET g_sql = g_sql CLIPPED," AND aeh34 = '",l_aeh34,"'"   #No.FUN-D40044   Mod tm.aeh34 --> l_aeh34
            END CASE
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            PREPARE sel_aeh_pre4 FROM g_sql
            DECLARE sel_aeh_cs4 CURSOR FOR sel_aeh_pre4
            OPEN sel_aeh_cs4 
            LET amt2 = 0
            FETCH sel_aeh_cs4 INTO amt2
            IF amt2 IS NULL THEN LET amt2 = 0 END IF
            #No.TQC-BC0032  --Begin
            CALL s_minus_ce(tm.aeh00, maj.maj21, maj.maj22, NULL,    NULL,    NULL,
                            NULL,     NULL,      NULL,      NULL,    NULL,    tm.yy2,
                            tm.bm2,   tm.em2,    NULL,      l_aeh31, l_aeh32, l_aeh33,
                            l_aeh34,  NULL,      NULL,      NULL,    g_plant, l_aaa09,'0')  #CHI-C70031
                 RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
            #减借加贷
            IF tm.ce = 'N' THEN   #No.FUN-D40044   Add
               LET amt2 = amt2 - l_aeh11 + l_aeh12
            END IF                #No.FUN-D40044   Add
            #No.TQC-BC0032  --End
         END IF

         IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF #匯率的轉換
         IF tm.o = 'Y' THEN LET amt2 = amt2 * tm.q END IF #匯率的轉換

         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN     #合計階數處理
             FOR i = 1 TO 100 
                 IF maj.maj09 = '-' THEN
                     LET g_tot1[i] = g_tot1[i] - amt1
                     LET g_tot2[i] = g_tot2[i] - amt2 
                 ELSE
                     LET g_tot1[i] = g_tot1[i] + amt1
                     LET g_tot2[i] = g_tot2[i] + amt2 
                 END IF
             END FOR
             LET k=maj.maj08  LET sr.bal1=g_tot1[k] LET sr.bal2=g_tot2[k]
             IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
                 LET sr.bal1 = sr.bal1 *-1
                 LET sr.bal2 = sr.bal2 *-1
             END IF
             FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
             FOR i = 1 TO maj.maj08 LET g_tot2[i]=0 END FOR
         ELSE 
             IF maj.maj03='5' THEN
                 LET sr.bal1=amt1
                 LET sr.bal2=amt2
             ELSE
                 LET sr.bal1=NULL        
                 LET sr.bal2=NULL       
             END IF
         END IF
         IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
            LET g_basetot1=sr.bal1
            LET g_basetot2=sr.bal2
            IF g_basetot1 = 0 THEN
               LET g_basetot1 = NULL
            END IF
            IF g_basetot2 = 0 THEN
               LET g_basetot2 = NULL
            END IF
            IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
            IF maj.maj07='2' THEN LET g_basetot2=g_basetot2*-1 END IF
            LET g_basetot1=g_basetot1/g_unit 
            LET g_basetot2=g_basetot2/g_unit 
         END IF

         IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
         IF (tm.c='N' OR maj.maj03='2') AND
            maj.maj03 MATCHES "[0125]" AND sr.bal1=0 AND sr.bal2=0 THEN 
            CONTINUE FOREACH                        #餘額為 0 者不列印
         END IF
         IF tm.f>0 AND maj.maj08 < tm.f THEN
            CONTINUE FOREACH                        #最小階數起列印
         END IF

         IF maj.maj07 = '2' THEN
            LET sr.bal1 = sr.bal1 * -1
            LET sr.bal2 = sr.bal2 * -1
         END IF
  
         LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
  
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e
         END IF

         LET sr.bal1=sr.bal1/g_unit             
         LET sr.bal2=sr.bal2/g_unit             

         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
         EXECUTE insert_prep USING
            maj.maj01,maj.maj02,maj.maj03,maj.maj04,maj.maj05,
            maj.maj06,maj.maj07,maj.maj08,maj.maj09,maj.maj10,
            maj.maj11,maj.maj20,maj.maj20e,maj.maj21,maj.maj22,
            maj.maj23,maj.maj24,maj.maj25,maj.maj26,maj.maj27,
            maj.maj28,maj.maj29,maj.maj30,'2',sr.bal1,sr.bal2,
            g_azi03,g_azi04,g_azi05,g_aeh31,tm.yy1,tm.yy2,tm.title1,tm.title2
         IF maj.maj04 > 0 THEN
            #空行的部份,以寫入同樣的maj20資料列進Temptable,
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
            #讓空行的這筆資料排在正常的資料前面印出
            FOR i = 1 TO maj.maj04
               EXECUTE insert_prep USING
                  maj.maj01,maj.maj02,maj.maj03,maj.maj04,maj.maj05,
                  maj.maj06,maj.maj07,maj.maj08,maj.maj09,maj.maj10,
                  maj.maj11,maj.maj20,maj.maj20e,maj.maj21,maj.maj22,
                  maj.maj23,maj.maj24,maj.maj25,maj.maj26,maj.maj27,
                  maj.maj28,maj.maj29,maj.maj30,'1','0',sr.bal2,
                  g_azi03,g_azi04,g_azi05,g_aeh31,tm.yy1,tm.yy2,tm.title1,tm.title2
               IF STATUS THEN
                  CALL cl_err("execute insert_prep:",STATUS,1)
                  EXIT FOR
               END IF
            END FOR
         END IF
      END FOREACH
   END FOREACH   #No.FUN-D40044   Add
  
  #FUN-BC0004   Mark   start
  #LET l_i_cnt05 = 0
  #IF cl_null(l_aeh31) THEN
  #   LET l_i_cnt05 = l_i_cnt05 + 1
  #END IF
  #FUN-BC0004   Mark   end
  #No.FUN-D40044 ---Add--- start
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " SELECT maj01,maj02,maj03,maj04,maj05,maj06,maj07,maj08,",
               "        maj09,maj10,maj11,maj20,maj20e,maj21,maj22,maj23,",
               "        maj24,maj25,maj26,maj27,maj28,maj29,maj30,line,",
               "        SUM(amt1),SUM(amt2),azi03,azi04,azi05,'",t_aeh31,"',yy1,yy2,title1,title2",
               "        FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "  GROUP BY maj01,maj02,maj03,maj04,maj05,maj06,maj07,maj08,",
               "           maj09,maj10,maj11,maj20,maj20e,maj21,maj22,maj23,",
               "           maj24,maj25,maj26,maj27,maj28,maj29,maj30,line,azi03,azi04,azi05,yy1,yy2,title1,title2",
               "  ORDER BY maj02"
  PREPARE r815_ins FROM l_sql
  EXECUTE r815_ins
  LET l_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  PREPARE r815_del FROM l_sql
  EXECUTE r815_del
  LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
  PREPARE r815_ins1 FROM l_sql
  EXECUTE r815_ins1
  #No.FUN-D40044 ---Add--- End

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY maj02"
  #LET g_str = g_mai02,";",tm.a,";",tm.e,";",l_i_cnt05,";",l_i_cnt05,";",l_i_cnt05,";",l_i_cnt05 #FUN-BC0004   Mark
   LET g_str = g_mai02,";",tm.a,";",tm.e                                                         #FUN-BC0004   Add
 
   CALL cl_prt_cs3('aglr815','aglr815',g_sql,g_str)
     
END FUNCTION

FUNCTION r815_getmsg(p_tmp)
DEFINE p_tmp     LIKE type_file.num5
DEFINE l_title   LIKE type_file.chr50
   CASE p_tmp
      WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING l_title
      WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING l_title
      WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING l_title
      WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING l_title
      WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING l_title
      WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING l_title
      WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING l_title
      WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING l_title
      WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING l_title
      WHEN 10 CALL cl_getmsg('agl-328',g_lang) RETURNING l_title
      WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING l_title
      WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING l_title
      WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING l_title
      OTHERWISE LET l_title = ' '
   END CASE
   RETURN  l_title
END FUNCTION
