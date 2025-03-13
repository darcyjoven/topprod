DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           a       LIKE mai_file.mai01,     #報表結構編號  #No.FUN-680098   VARCHAR(6)   
           b       LIKE aaa_file.aaa01,     #帳別編號      #No.FUN-670039 
           abe01   LIKE abe_file.abe01,     #列印族群/部門層級/部門  #No.FUN-680098  VARCHAR(6)  
           yy      LIKE type_file.num5,     #輸入年度      #No.FUN-680098  smallint  
           bm      LIKE type_file.num5,     #Begin 期別    #No.FUN-680098  smallint
           em      LIKE type_file.num5,     # End  期別    #No.FUN-680098  smallint 
           c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印   #No.FUN-680098  VARCHAR(1)  
           d       LIKE type_file.chr1,     #金額單位             #No.FUN-680098   VARCHAR(1)
           e       LIKE type_file.chr1,     #列印額外名稱 #FUN-6C0012
           f       LIKE type_file.num5,     #列印最小階數         #No.FUN-680098   smallint  
           s       LIKE type_file.chr1,     #列印下層部門         #TQC-630157  #No.FUN-680098  VARCHAR(1)   
           p       LIKE type_file.chr1,     #分頁選項            #CHI-B50007  char(1)
           more    LIKE type_file.chr1      #Input more condition(Y/N)         #No.FUN-680098  VARCHAR(1)   
           END RECORD,
       i,j,k,g_mm LIKE type_file.num5,      #No.FUN-680098   smallint
       g_unit     LIKE type_file.num10,     #金額單位基數  #No.FUN-680098  integer
      #g_buf      LIKE type_file.chr1000,   #No.FUN-680098     char(600)  #MOD-B40245 mark 
       g_buf      STRING,                   #MOD-B40245   
       g_cn       LIKE type_file.num5,      #No.FUN-680098     smallint
       g_flag     LIKE type_file.chr1,      #No.FUN-680098     VARCHAR(1)    
       g_bookno   LIKE aah_file.aah00,      #帳別      
       g_gem05    LIKE gem_file.gem05,
       m_dept     DYNAMIC ARRAY OF LIKE gem_file.gem02,   #No.FUN-680098      VARCHAR(300)   #No.FUN-830053 add
       g_mai02    LIKE mai_file.mai02,
       g_mai03    LIKE mai_file.mai03,
       g_abd01    LIKE abd_file.abd01,
       g_abe01    LIKE abe_file.abe01,
       g_total    DYNAMIC ARRAY OF RECORD
                   maj02 LIKE maj_file.maj02,
                   amt    LIKE type_file.num20_6                   #No.FUN-680098  dec(20,6)
                  END RECORD,
       g_tot1     DYNAMIC ARRAY OF  LIKE type_file.num20_6,  #MOD-640583   #No.FUN-680098  dec(20,6)
       g_no       LIKE type_file.num5,                  #No.FUN-680098    smallint
       g_dept     DYNAMIC ARRAY OF RECORD
                  gem01 LIKE gem_file.gem01, #部門編號
                  gem05 LIKE gem_file.gem05  #是否為會計部門
                  END RECORD,
       maj02_max  LIKE type_file.num5     #MOD-640089   #MOD-640583  #No.FUN-680098  smallint 
 
DEFINE g_aaa03    LIKE aaa_file.aaa03
DEFINE g_i,g_cnt  LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
DEFINE g_sql      STRING                  #No.FUN-830053
DEFINE l_table    STRING                  #No.FUN-830053  #MOD-9A0192 mod chr20->STRING
DEFINE l_table1   STRING                  #CHI-B50007
DEFINE g_str      STRING                  #No.FUN-830053
DEFINE g_gem02    LIKE gem_file.gem02
DEFINE        g_bal_a     DYNAMIC ARRAY OF RECORD
                      maj02      LIKE maj_file.maj02,
                      maj03      LIKE maj_file.maj03,
                      maj08      LIKE maj_file.maj08,
                      maj09      LIKE maj_file.maj09
               END RECORD 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
 
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)   #TQC-630157
   LET tm.abe01= ARG_VAL(10)
   LET tm.yy   = ARG_VAL(11)
   LET tm.bm   = ARG_VAL(12)
   LET tm.em   = ARG_VAL(13)
   LET tm.c    = ARG_VAL(14)
   LET tm.d    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   LET tm.s    = ARG_VAL(17)   #TQC-630157
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET tm.e    = ARG_VAL(21)   #FUN-6C0012
   LET tm.p    = ARG_VAL(22)   #CHI-B50007
 
   DROP TABLE r100_file
   LET g_sql="maj02.maj_file.maj02,maj03.maj_file.maj03,",
             "maj04.maj_file.maj04,maj05.maj_file.maj05,",
             "maj07.maj_file.maj07,maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,page.type_file.num5,",
             "m_dept1.gem_file.gem02,m_dept2.gem_file.gem02,",
             "m_dept3.gem_file.gem02,m_dept4.gem_file.gem02,",
             "m_dept5.gem_file.gem02,m_dept6.gem_file.gem02,",
             "m_dept7.gem_file.gem02,m_dept8.gem_file.gem02,",
             "m_dept9.gem_file.gem02,m_dept10.gem_file.gem02,",
             "l_amt1.type_file.num20_6,l_amt2.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt3.type_file.num20_6,l_amt4.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt5.type_file.num20_6,l_amt6.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt7.type_file.num20_6,l_amt8.type_file.num20_6,",   #MOD-870071 mod str->amt
             "l_amt9.type_file.num20_6,l_amt10.type_file.num20_6,",  #MOD-870071 mod str->amt
             "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglr100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

#CHI-B50007 -- begin --
   LET g_sql="maj02.maj_file.maj02,maj03.maj_file.maj03,",
             "maj04.maj_file.maj04,maj05.maj_file.maj05,",
             "maj07.maj_file.maj07,maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,page.type_file.num5,",
             "m_dept.gem_file.gem02,l_amt.type_file.num20_6,",
             "line.type_file.num5"
   LET l_table1 = cl_prt_temptable('aglr1001',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      EXIT PROGRAM 
   END IF
#CHI-B50007 -- end --
 
   CREATE TEMP TABLE r100_file(
       no        LIKE type_file.num5,  
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       maj21     LIKE maj_file.maj21,
       maj22     LIKE maj_file.maj22,
       bal1      LIKE type_file.num20_6)  
 create        index r100_01 on r100_file (no,maj02);     #add by TPS.hermeso130614
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF         #No.FUN-740020
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   DROP TABLE dept_tmp;
   DROP TABLE dept1_tmp;
   DROP TABLE q011_tmp;
   DROP TABLE speed_tmp;
   DROP TABLE abb_tmp;  
   DROP TABLE sw_tmp;  

   CALL q011_cre_temp_table()
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r100_tm()                        # Input print condition
   ELSE
      CALL r100()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION r100_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098  VARCHAR(1)   
          l_cmd          LIKE type_file.chr1000        #No.FUN-680098   VARCHAR(400)   
   DEFINE li_chk_bookno LIKE type_file.num5            #No.FUN-670005   #No.FUN-680098   smallint
   DEFINE li_result      LIKE type_file.num5           #No.FUN-6C0068   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r100_w AT p_row,p_col WITH FORM "agl/42f/aglr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF         #No.FUN-740020
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b     #No.FUN-740020
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)   # NO.FUN-660123 #No.FUN-740020 
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
   LET tm.b = g_aza.aza81    #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.p = '1'  #CHI-B50007
   LET tm.f = 0
   LET tm.s = 'N'   #TQC-630157
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
 
    INPUT BY NAME tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.s,tm.e,tm.p,tm.more   #TQC-630157   #FUN-6C0012 #No.FUN-740020  #CHI-B50007
		  WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b  #No.FUN-740020
         IF STATUS THEN
            CALL cl_err3("sel","mai_file",tm.b,"",STATUS,"","sel mai:",0)   # NO.FUN-660123   #No.FUN-740020
            NEXT FIELD a
        #No.TQC-C50042   ---start---   Add
         ELSE
            IF g_mai03 = '5' OR g_mai03 = '6' THEN
               CALL cl_err('','agl-268',0)
               NEXT FIELD a
            END IF
        #No.TQC-C50042   ---end---     Add
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN 
             NEXT FIELD b END IF
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN
            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   # NO.FUN-660123
            NEXT FIELD b
         END IF
 
      AFTER FIELD abe01
         IF cl_null(tm.abe01) THEN NEXT FIELD abe01 END IF
 
         SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
         IF STATUS=100 THEN
           LET g_abe01 =' '
           SELECT UNIQUE abd01 INTO g_abd01 FROM abd_file WHERE abd01=tm.abe01
           IF STATUS=100 THEN
             LET g_abd01=' '
             SELECT gem05 INTO g_gem05 FROM gem_file WHERE gem01=tm.abe01
             IF STATUS THEN NEXT FIELD abe01 END IF
           END IF
         ELSE
           IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
         END IF
 
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD s
         IF cl_null(tm.s) OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD yy
         IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
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
         IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
 
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
         IF cl_null(tm.em) THEN NEXT FIELD em END IF
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f < 0  THEN
            LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
         END IF

     AFTER FIELD p
         IF cl_null(tm.p) OR tm.p NOT MATCHES'[12]' THEN NEXT FIELD p END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.yy) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy
            CALL cl_err('',9033,0)
         END IF
         IF cl_null(tm.bm) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm
         END IF
         IF cl_null(tm.em) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.em
        END IF
        CASE
           WHEN tm.d = '1'  LET g_unit = 1
           WHEN tm.d = '2'  LET g_unit = 1000
           WHEN tm.d = '3'  LET g_unit = 1000000
        END CASE
        IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"   #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6') "     #No.TQC-C50042   Add
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
 
            WHEN INFIELD(abe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_abe'
               LET g_qryparam.default1 = tm.abe01
               CALL cl_create_qry() RETURNING tm.abe01
               DISPLAY BY NAME tm.abe01
               NEXT FIELD abe01
      END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr100','9031',1)  
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-630157
                         " '",tm.abe01 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",    #FUN-6C0012
                         " '",tm.f CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,   #TQC-630157
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION

FUNCTION r100()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20)   
   DEFINE l_name1   LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098   VARCHAR(20)   
  #DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT        #No.FUN-680098   char(1000)  #MOD-B40245 mark 
   DEFINE l_sql     STRING                        # RDSQL STATEMENT        #MOD-B40245 
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1)   
   DEFINE l_leng,l_leng2  LIKE type_file.num5     #No.FUN-680098  smallint
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE l_abd02   LIKE abd_file.abd02
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01
   DEFINE l_maj20   LIKE maj_file.maj20        #No.FUN-680098    VARCHAR(30)   
   DEFINE l_bal     LIKE type_file.num20_6     #No.FUN-680098    DEC(20,6)  
   DEFINE sr  RECORD
              no    LIKE type_file.num5,       #No.FUN-680098   SMALLINT
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6    #實際    #No.FUN-680098  DECIMAL(20,6)
              END RECORD
    DEFINE sr1 RECORD
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e
              END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5     LIKE type_file.chr20     #No.FUN-680098   VARCHAR(20)   #MOD-870071 mark
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10    LIKE type_file.chr20     #No.FUN-680098   VARCHAR(20)   #MOD-870071 mark
   DEFINE m_abd02 LIKE abd_file.abd02
   DEFINE l_no,l_cn,l_cnt,l_i,l_j,g_cnt LIKE type_file.num5       #No.FUN-680098 smallint
   DEFINE l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)    
   DEFINE l_amtstr                DYNAMIC ARRAY OF LIKE type_file.chr20    #No.FUN-830053 add
   DEFINE l_amt                   DYNAMIC ARRAY OF LIKE type_file.num20_6  #MOD-870071 add
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(1)   
          l_zero2       LIKE type_file.chr1            #No.FUN-680098  VARCHAR(1)    
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01=tm.b AND aaf02=g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr100'
 
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF

#CHI-B50007 -- begin -- 
   CALL cl_del_data(l_table1)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
#CHI-B50007 -- end --

   DISPLAY "department fill begin:",TIME
   CALL q011_dept_fill()
   DISPLAY "department fill end  :",TIME      
   IF tm.p = '1' THEN
      CALL r100_page()
   ELSE 
   	  DELETE FROM dept1_tmp
   	  LET l_sql ="INSERT INTO dept1_tmp ",
                 "SELECT * FROM dept_tmp "
      PREPARE dept FROM l_sql
      EXECUTE dept
   	  DISPLAY "process1        begin:",TIME
      CALL q011_process1()
      DISPLAY "process1        end  :",TIME
      DISPLAY "process2        begin:",TIME
      CALL q011_process2()
      DISPLAY "process2        end  :",TIME
   	  DISPLAY "fill array      begin:",TIME     
      CALL q011_fill_arr(l_i)
      DISPLAY "fill array      end  :",TIME
   END IF
   
END FUNCTION

FUNCTION r100_page()
   DEFINE l_name1   LIKE type_file.chr20
   DEFINE l_chr     LIKE type_file.chr1  
   DEFINE l_leng,l_leng2  LIKE type_file.num5
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01  
   DEFINE sr  RECORD
              no    LIKE type_file.num5,
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6
              END RECORD
    DEFINE sr1 RECORD
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e
              END RECORD
   DEFINE l_no,l_cn,l_cnt,l_i,l_j,l_maj02_cnt LIKE type_file.num5
   DEFINE l_amt                   DYNAMIC ARRAY OF LIKE type_file.num20_6
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,
          l_zero2       LIKE type_file.chr1
   DEFINE l_sum         DYNAMIC ARRAY OF  LIKE type_file.num20_6   
   DEFINE l_maj_arr      DYNAMIC ARRAY OF RECORD
                         maj02   LIKE maj_file.maj02,
                         maj20   LIKE maj_file.maj20,
                         maj20e  LIKE maj_file.maj20e,
                         maj03   LIKE maj_file.maj03
                         END RECORD 
   DEFINE l_sql       LIKE STRING
   LET l_cnt=(10-(g_no MOD 10))+g_no     ###一行 10 個
   LET l_i = 0
   FOR g_i = 1 TO maj02_max LET l_sum[g_i] = 0 END FOR   
   FOR l_i = 10 TO l_cnt STEP 10
      LET g_flag = 'n'
      LET l_name1='r100_',l_i/10 USING '&&&','.out'
 
      LET g_pageno = 0
 
      LET g_cn = 0
      DELETE FROM dept1_tmp
      DELETE FROM q011_tmp
      CALL m_dept.clear()          #No.FUN-830053 add
      IF l_i <= g_no THEN
         LET l_no = l_i - 10
         LET l_sql ="INSERT INTO dept1_tmp ",
                      "SELECT TOP 10 * FROM (SELECT TOP  '",l_i,"' * FROM dept_tmp ORDER BY dept_m) as p ",
                      " ORDER BY p.dept_m desc "
         PREPARE dept1 FROM l_sql
         EXECUTE dept1
         DISPLAY "process1        begin:",TIME
         CALL q011_process1()
         DISPLAY "process1        end  :",TIME
         DISPLAY "process2        begin:",TIME
         CALL q011_process2()
         DISPLAY "process2        end  :",TIME
   	     DISPLAY "fill array      begin:",TIME     
         CALL q011_fill_arr(l_i)
         DISPLAY "fill array      end  :",TIME
      ELSE
      	 LET g_flag = 'y'
      	 IF (g_no MOD 10) = 0 THEN
      	    #fill maj值                   
            DECLARE q011_fill_maj02_cs1 CURSOR FOR  
             SELECT UNIQUE maj02,maj03,maj04,maj05,maj07,maj20,maj20e FROM q011_tmp
              ORDER BY maj02
            LET l_maj02_cnt = 1
            FOREACH q011_fill_maj02_cs1 INTO l_maj_arr[l_maj02_cnt].*
                LET l_maj02_cnt = l_maj02_cnt + 1
            END FOREACH
            LET l_maj02_cnt = l_maj02_cnt - 1 
            FOR i = 1 TO l_maj02_cnt
                LET l_amt[1]=l_sum[i]
                LET m_dept[1] = '合  計'
                EXECUTE insert_prep USING
                     l_maj_arr[i].*,l_i,
                     m_dept[1],m_dept[2],m_dept[3],m_dept[4],m_dept[5],
                     m_dept[6],m_dept[7],m_dept[8],m_dept[9],m_dept[10],
                     l_amt[1],'','','','','','','','','','2'
                IF STATUS THEN
                   CALL cl_err("execute insert_prep:",STATUS,1)
                   EXIT FOR
                END IF
            END FOR          	    
      	 ELSE      	 	  
      	    LET l_no = (l_i - 10)
      	    LET l_cn =  g_no - (l_i - 10)
      	    LET l_sql = "INSERT INTO dept1_tmp ",
                         "SELECT TOP '",l_cn,"' * FROM dept_tmp ORDER BY dept_m DESC "
            PREPARE dept2 FROM l_sql
            EXECUTE dept2
            DISPLAY "process1        begin:",TIME
            CALL q011_process1()
            DISPLAY "process1        end  :",TIME
            DISPLAY "process2        begin:",TIME
            CALL q011_process2()
            DISPLAY "process2        end  :",TIME
            DISPLAY "fill array      begin:",TIME     
            CALL q011_fill_arr(l_i)
            DISPLAY "fill array      end  :",TIME  
         END IF
      END IF
   END FOR 
   LET g_str = g_aaz.aaz77,";",g_mai02,";",tm.yy USING '<<<<',";",
               tm.bm USING'&&',";",tm.em USING'&&',";",tm.d,";",tm.e,";",
               g_azi04            #MOD-BC0237
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aglr100','aglr100',g_sql,g_str)
END FUNCTION

FUNCTION q011_dept_fill()
   DEFINE l_abd02     LIKE abd_file.abd02
   DEFINE l_abe03     LIKE abe_file.abe03
   DEFINE l_chr       LIKE gem_file.gem05

   DELETE FROM dept_tmp;
   
   IF g_abe01 = ' ' THEN
      IF g_abd01 = ' ' THEN                   #--- 部門 
         SELECT gem02 INTO g_gem02 FROM gem_file WHERE gem01 = tm.abe01
         INSERT INTO dept_tmp VALUES(tm.abe01,g_gem02,tm.abe01)
         IF tm.s = 'Y' THEN
            CALL q011_dept(tm.abe01,g_gem02,tm.abe01,'Y')
         END IF 
      ELSE                                    #--- 部門層級
         DECLARE r192_bom1 CURSOR FOR
          SELECT abd02,gem05,gem02 FROM abd_file,gem_file
           WHERE abd01=tm.abe01 AND gem01=abd02
           ORDER BY 1
         FOREACH r192_bom1 INTO l_abd02,l_chr,g_gem02
            IF SQLCA.SQLCODE THEN EXIT FOREACH END IF 
            INSERT INTO dept_tmp VALUES(l_abd02,g_gem02,l_abd02) 
            IF tm.s = 'Y' THEN
               CALL q011_dept(l_abd02,g_gem02,l_abd02,l_chr)
            END IF
         END FOREACH
      END IF
   ELSE                                      #--- 族群
      DECLARE r192_bom2 CURSOR FOR
        SELECT abe03,gem05,gem02 FROM abe_file,gem_file
         WHERE abe01=tm.abe01 AND gem01=abe03
         ORDER BY 1
      FOREACH r192_bom2 INTO l_abe03,l_chr,g_gem02
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF 
         INSERT INTO dept_tmp VALUES(l_abe03,g_gem02,l_abe03)
         IF tm.s = 'Y' THEN
            CALL q011_dept(l_abe03,g_gem02,l_abe03,l_chr)
         END IF 
      END FOREACH
   END IF


END FUNCTION

#当参数tm.s='Y'打印下阶部门时,把下阶部门的值insert至dept_tmp中
FUNCTION q011_dept(l_dept_s,l_gem02,l_dept_d,l_sw)
    DEFINE l_dept_s       LIKE abd_file.abd01 
    DEFINE l_gem02        LIKE gem_file.gem02
    DEFINE l_dept_d       LIKE abd_file.abd01     
    DEFINE l_sw           LIKE type_file.chr1        
    DEFINE l_abd02        LIKE abd_file.abd02           
    DEFINE l_cnt1,l_cnt2  LIKE type_file.num5          
    DEFINE l_arr          DYNAMIC ARRAY OF RECORD
                          gem01 LIKE gem_file.gem01,
                          gem05 LIKE gem_file.gem05
                          END RECORD
 
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept_d
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN
           CALL q011_dept(l_dept_s,l_gem02,l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN 
       INSERT INTO dept_tmp VALUES(l_dept_s,l_gem02,l_dept_d)
    END IF
END FUNCTION

#按maj02+dept_m的形式将金额设置好
FUNCTION q011_process1()
    DEFINE l_factor    LIKE type_file.num20_6
    DEFINE l_sql       LIKE STRING
    DELETE FROM q011_tmp;
    DELETE FROM abb_tmp;
    
    INSERT INTO q011_tmp SELECT maj02,dept_m,maj20,maj20e,maj03,maj08,0,0,0,0,0,0
                           FROM mai_file,maj_file,dept1_tmp
                          WHERE mai01 = maj01
                            AND mai01 = tm.a
                            AND mai00 = tm.b

    LET g_sql = "UPDATE q011_tmp a SET d = ( SELECT NVL(SUM(aao05),0) FROM aao_file,aag_file,mai_file,maj_file b",
                " WHERE mai01 = b.maj01  AND mai01 = '",tm.a,"' AND mai00 = '",tm.b,"' ",
                "   AND b.maj02 = a.maj02 ",
                "   AND aao00 = '",tm.b,"'  AND aao01 BETWEEN maj21 AND maj22 ",
                "   AND aao03 =  ",tm.yy,"  AND aao04 BETWEEN  ",tm.bm," AND ",tm.em,
                "   AND aag00 = aao00 AND aag01 = aao01 ",
                "   AND aag07 IN ('2','3') ",
                "   AND aao02 IN (SELECT c.dept_d FROM dept1_tmp c WHERE c.dept_m = a.dept_m) ) "
    PREPARE pp5 FROM g_sql
    EXECUTE pp5
  
    LET g_sql = "UPDATE q011_tmp a SET c = ( SELECT NVL(SUM(aao06),0) FROM aao_file,aag_file,mai_file,maj_file b",
                " WHERE mai01 = b.maj01  AND mai01 = '",tm.a,"' AND mai00 = '",tm.b,"' ",
                "   AND b.maj02 = a.maj02 ",
                "   AND aao00 = '",tm.b,"'  AND aao01 BETWEEN maj21 AND maj22 ",
                "   AND aao03 =  ",tm.yy,"  AND aao04 BETWEEN  ",tm.bm," AND ",tm.em,
                "   AND aag00 = aao00 AND aag01 = aao01 ",
                "   AND aag07 IN ('2','3') ",
                "   AND aao02 IN (SELECT c.dept_d FROM dept1_tmp c WHERE c.dept_m = a.dept_m) ) "
    PREPARE pp6 FROM g_sql
    EXECUTE pp6
  
    #取期间的部门异动借方金额及贷方金额
    INSERT INTO abb_tmp SELECT abb03,abb05,abb06,abb07 FROM aba_file,abb_file
                         WHERE abb00 = aba00 AND abb01 = aba01
                           AND aba00 = tm.b
                           AND aba06 = 'CE'
                           AND aba03 = tm.yy 
                           AND aba04 BETWEEN tm.bm AND tm.em
                           AND abapost = 'Y' 

    #取期间CE凭证中的借方金额及贷方金额        

    LET l_sql = " UPDATE q011_tmp a SET d_ce = (SELECT NVL(SUM(abb07),0) FROM abb_tmp,maj_file b,mai_file ",
                "                 WHERE abb06 = '1'  ",
                "                   AND mai01 = b.maj01 ",
                "                   AND mai01 = '",tm.a,"'",
                "                   AND mai00 = '",tm.b,"'",
                "                   AND abb03 BETWEEN b.maj21 AND b.maj22  ",
                "                   AND b.maj02 =  a.maj02 ",                                   
                "                   AND abb05 IN (SELECT d.dept_d FROM dept1_tmp d WHERE d.dept_m = a.dept_m ) ",
                "              )       "
     PREPARE p1 FROM l_sql
     EXECUTE p1

    LET l_sql = " UPDATE q011_tmp a SET c_ce = (SELECT NVL(SUM(abb07),0) FROM abb_tmp,maj_file b,mai_file ",
                "                  WHERE abb06 = '2'   ",
                "                    AND mai01 = b.maj01",
                "                    AND mai01 = '",tm.a,"'",
                "                    AND mai00 = '",tm.b,"'",
                "                    AND abb03 BETWEEN b.maj21 AND b.maj22  ",
                "                    AND b.maj02 =  a.maj02   ",                                   
                "                    AND abb05 IN (SELECT d.dept_d FROM dept1_tmp d WHERE d.dept_m = a.dept_m ) ",
                "               )  "
    PREPARE p2 FROM l_sql
    EXECUTE p2
  
    #根据maj06的值,对sum进行更新
    #maj06='2'期间异动   maj06='4' 期间借  maj06='5' 期间贷   
    #目前暂时将maj06='3/8/9'也放进来,其实是不对的,因为期末的部分要加上期初才对
   
    #下面的借/贷要好好测试,可能会有问题 ,还没想好!!!!!!#check check!!!
    UPDATE q011_tmp   SET sum = d - c - d_ce + c_ce ,amt = d - c - d_ce + c_ce
     WHERE maj02 IN ( SELECT maj02 FROM mai_file,maj_file
                         WHERE maj01 = mai01
                           AND mai00 = tm.b
                           AND maj01 = tm.a
                           AND maj06 IN ('2','3')
                       )
                        
    UPDATE q011_tmp   SET sum = d  - d_ce ,amt = d  - d_ce
     WHERE maj02 IN ( SELECT maj02 FROM mai_file,maj_file
                         WHERE maj01 = mai01
                           AND mai00 = tm.b
                           AND maj01 = tm.a
                           AND maj06 IN ('4','8')
                      )
                        
    UPDATE q011_tmp   SET sum = c - c_ce ,amt = c - c_ce
     WHERE maj02 IN ( SELECT maj02 FROM mai_file,maj_file
                         WHERE maj01 = mai01
                           AND mai00 = tm.b
                           AND maj01 = tm.a
                           AND maj06 IN ('5','9')
     
                      )

   #unit -- trousand
   #unit - million
   IF tm.d MATCHES '[23]' THEN
      IF tm.d = '2' THEN
         LET l_factor = 1000
      ELSE
         LET l_factor = 1000000
      END IF
      LET l_sql = " UPDATE q011_tmp SET d    = d    / ",l_factor,",",
                                    "   c    = c    / ",l_factor,",",
                                    "   d_ce = d_ce / ",l_factor,",",
                                    "   c_ce = c_ce / ",l_factor,",",
                                    "   sum  = sum  / ",l_factor,",",
                                    "   amt  = amt  / ",l_factor
      PREPARE pp9 FROM l_sql
      EXECUTE pp9
   END IF

END FUNCTION

#比如合计阶等,amt的金额为最终计算的金额值
FUNCTION q011_process2()
   DEFINE l_maj        RECORD LIKE maj_file.*   
   DEFINE l_sw         LIKE type_file.num5
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_maj08      LIKE maj_file.maj08 
   DEFINE l_max_maj08  LIKE maj_file.maj08
   DEFINE l_flag       LIKE type_file.chr1
   
   DELETE FROM  speed_tmp;
   DELETE FROM  sw_tmp;
   
   DECLARE q011_maj_cs CURSOR FOR
     SELECT * FROM maj_file WHERE maj01 = tm.a 
      ORDER BY maj02

   CALL g_bal_a.clear()
   LET g_cnt = 1 
   LET l_max_maj08 = 0
   FOREACH q011_maj_cs INTO l_maj.* 
        IF l_maj.maj09 = '+' THEN LET l_sw = 1 ELSE LET l_sw = -1 END IF
        INSERT INTO sw_tmp VALUES(l_maj.maj02,l_sw)
       
        IF l_maj.maj08 > l_max_maj08 THEN LET l_max_maj08 = l_maj.maj08 END IF
        #余额方向不同时,sum * -1
        IF l_maj.maj06 MATCHES '[579]' AND l_maj.maj07 = '1' THEN
          #LET l_sql = " UPDATE q011_tmp SET sum = -1 * sum   WHERE maj02 = ",l_maj.maj02   #fengmy mark 130828
           LET l_sql = " UPDATE q011_tmp SET sum = -1 * sum , amt = -1 * amt  WHERE maj02 = ",l_maj.maj02  #fengmy add 130828
           PREPARE pp1 FROM l_sql
           EXECUTE pp1
        END IF
         
        IF l_maj.maj06 MATCHES '[123468]' AND l_maj.maj07 = '2' THEN
          #LET l_sql = " UPDATE q011_tmp SET sum = -1 * sum   WHERE maj02 = ",l_maj.maj02   #fengmy mark 130828
           LET l_sql = " UPDATE q011_tmp SET sum = -1 * sum , amt = -1 * amt  WHERE maj02 = ",l_maj.maj02  #fengmy add 130828
           PREPARE pp2 FROM l_sql
           EXECUTE pp2
        END IF

        LET g_bal_a[g_cnt].maj02 = l_maj.maj02
        LET g_bal_a[g_cnt].maj03 = l_maj.maj03
        LET g_bal_a[g_cnt].maj08 = l_maj.maj08 
        LET g_bal_a[g_cnt].maj09 = l_maj.maj09

        IF l_maj.maj03 MATCHES '[012]' AND l_maj.maj08 > 0 THEN 
           IF l_maj.maj08 = '1' THEN
              LET l_sw = 1
              IF l_maj.maj09 = '-' THEN LET l_sw = -1 END IF
              INSERT INTO speed_tmp VALUES(l_maj.maj02,l_maj.maj02,l_sw)
           ELSE
              LET l_flag = 'N'
              FOR l_i = g_cnt - 1 TO 1 STEP -1
                  IF l_maj.maj08 <= g_bal_a[l_i].maj08 THEN
                     EXIT FOR
                  END IF
                  IF g_bal_a[l_i].maj03 NOT MATCHES '[012]' THEN
                     CONTINUE FOR
                  END IF
 
                  IF l_i = g_cnt - 1 THEN
                     LET l_maj08 = g_bal_a[l_i].maj08
                  END IF
                  IF g_bal_a[l_i].maj08 >= l_maj08 THEN 
                     IF g_bal_a[l_i].maj09 = '+' THEN LET l_sw = 1 ELSE LET l_sw = -1 END IF
                     INSERT INTO speed_tmp VALUES(l_maj.maj02,g_bal_a[l_i].maj02,l_sw)
                     LET l_flag = 'Y'
                  END IF
                  IF g_bal_a[l_i].maj08 > l_maj08 THEN
                     LET l_maj08 = g_bal_a[l_i].maj08
                  END IF
              END FOR
              IF l_flag = 'N' THEN
                 IF l_maj.maj09 = '+' THEN LET l_sw = 1 ELSE LET l_sw = -1 END IF
                 INSERT INTO speed_tmp VALUES(l_maj.maj02,l_maj.maj02,l_sw)
              END IF
           END IF          
        END IF        
        LET g_cnt = g_cnt + 1
      
   END FOREACH
    
   #更新经过合计阶运算过后的amt  
   #b.sum为每行本身的金额 c.sw为该行要进行加还是减  
   IF l_max_maj08 > 1 THEN 
      LET l_sql = " UPDATE q011_tmp a SET a.amt  = (SELECT SUM(b.amt * d.sw) FROM q011_tmp b ,speed_tmp c ,sw_tmp d",
                  "                                  WHERE a.dept_m = b.dept_m AND a.maj02 = c.maj02_d ",
                  "                                    AND b.maj02 = c.maj02_s AND b.maj02 = d.maj02  )",
#                 "                      AND a.maj02 <> c.maj02_s  )",
                  "  WHERE a.maj08 =  ? ",
                  "    AND a.maj02 NOT IN (select e.maj02_d from speed_tmp e where e.maj02_d = e.maj02_s ) "  #fengmy add 130828  #只对speed_tmp 用以合计低阶总和的项update ！！！
              
#select a.maj02,a.dept_m,SUM(b.amt * d.sw ) FROM TT1824328_q011_tmp a,TT1824328_q011_tmp b ,TT1824328_speed_tmp c,TT1824328_sw_tmp d
# where a.maj02 = 139.1 and a.dept_m = 'BJHFIN'
#   and a.dept_m = b.dept_m 
#   AND b.maj02 = c.maj02_s
#   and b.maj02 = d.maj02
# group by a.maj02,a.dept_m


#SELECT a.maj02,a.dept_m,SUM(b.amt * d.sw) FROM TT1824007_q011_tmp b ,TT1824007_speed_tmp c ,TT1824007_sw_tmp d ,TT1824007_q011_tmp a
#WHERE a.dept_m = b.dept_m AND a.maj02 = c.maj02_d AND b.maj02 = c.maj02_s AND b.maj02 = d.maj02
#  AND a.maj02 <> c.maj02_s     
#    and a.dept_m = 'BJHFIN' 
#group by a.maj02,a.dept_m

      PREPARE pp3 FROM l_sql 
      FOR l_i = 2 TO l_max_maj08 
          EXECUTE pp3 USING l_i
      END FOR
    END IF

                                       
END FUNCTION



#建立临时表
FUNCTION q011_cre_temp_table()

    #dept_tmp 为部门临时表
    #dept_m 为在array中显示的部门
    #若参数为印下层部门,则dept_d为所属dept_m下的下属部门清单,若tm.s='N'时,dept_d = dept_m
    CREATE TEMP TABLE dept_tmp(
       dept_m    LIKE gem_file.gem01,
       gem02     LIKE gem_file.gem02,
       dept_d    LIKE gem_file.gem01)
 
    CREATE UNIQUE INDEX dept_tmp_01 ON dept_tmp(dept_m,dept_d);
     
    CREATE TEMP TABLE dept1_tmp(
       dept_m    LIKE gem_file.gem01,
       gem02     LIKE gem_file.gem02,
       dept_d    LIKE gem_file.gem01)
 
    CREATE UNIQUE INDEX dept1_tmp_01 ON dept1_tmp(dept_m,dept_d);
     
     
        
    #q011_tmp 为部门BY maj02各项次的发生额 
    #maj02为项次
    #dept_m为主部门
    #d 为借方金额 c 为贷方金额 d_ce 为CE凭证的借方金额 c_ce 为CE凭证的借方金额 
    #sum为参与计算的金额 
    #amt为在ARRAY中显示的金额,此金额经过合计阶等处理过的值 
    CREATE TEMP TABLE q011_tmp(
       maj02     LIKE maj_file.maj02,
       dept_m    LIKE gem_file.gem01, 
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       maj03     LIKE maj_file.maj03,
       maj08     LIKE maj_file.maj08,
       d         LIKE aao_file.aao05,
       c         LIKE aao_file.aao06,
       d_ce      LIKE aao_file.aao05,
       c_ce      LIKE aao_file.aao06,
       sum       LIKE aao_file.aao05,
       amt       LIKE aao_file.aao05) ;
    CREATE INDEX q011_tmp_01 ON q011_tmp(maj02);

    CREATE TEMP TABLE sw_tmp(
       maj02     LIKE maj_file.maj02,
       sw        LIKE type_file.num5);
    CREATE INDEX sw_tmp_01 ON sw_tmp(maj02);
                                      
    #用于合计阶处理的提速档
    #maj02_d为当前项次   #maj02_s为要合计哪些项次
    #sw 为 1 或是 -1,用于累算maj02_s时为加还是为减                                  
    CREATE TEMP TABLE speed_tmp(
       maj02_d   LIKE maj_file.maj02,
       maj02_s   LIKE maj_file.maj02,
       sw        LIKE type_file.num5)

    #speed up FOR SELECT CE DATA
    CREATE TEMP TABLE abb_tmp(
      abb03     LIKE abb_file.abb03,
      abb05     LIKE abb_file.abb05,
      abb06     LIKE abb_file.abb06,
      abb07     LIKE abb_file.abb07);
END FUNCTION


#将部门的名字设置至screen上             
FUNCTION q011_fill_arr(l_i) 
   DEFINE l_maj02        LIKE maj_file.maj02
   DEFINE l_maj20        LIKE maj_file.maj20
   DEFINE l_maj20e       LIKE maj_file.maj20e 
   DEFINE l_maj_arr      DYNAMIC ARRAY OF RECORD
                         maj02   LIKE maj_file.maj02,
                         maj20   LIKE maj_file.maj20,
                         maj20e  LIKE maj_file.maj20e,
                         maj03   LIKE maj_file.maj03
                         END RECORD 
   DEFINE l_dept_arr     DYNAMIC ARRAY OF RECORD
                         dept_m  LIKE gem_file.gem01 ,
                         gem02   LIKE gem_file.gem02
                         END RECORD
   DEFINE l_dept_cnt     LIKE type_file.num5
   DEFINE l_maj02_cnt    LIKE type_file.num5
   DEFINE l_k,l_j,l_cnt  LIKE type_file.num5
   DEFINE l_amt1          LIKE aao_file.aao05
   DEFINE l_amt          ARRAY[10] OF LIKE type_file.num20_6 
   DEFINE l_str          LIKE type_file.chr50
   DEFINE l_i            LIKE type_file.num5
   #fill 部门值
   DECLARE q011_fill_dept_cs CURSOR FOR
    SELECT UNIQUE dept_m,gem02 FROM dept1_tmp
     ORDER BY dept_m
   LET l_dept_cnt = 1  
   FOREACH q011_fill_dept_cs INTO l_dept_arr[l_dept_cnt].*
      LET l_dept_cnt = l_dept_cnt + 1
   END FOREACH    
   LET l_dept_cnt = l_dept_cnt - 1
       
   #fill maj值                   
   DECLARE q011_fill_maj02_cs CURSOR FOR  
    SELECT UNIQUE maj02,maj03,maj04,maj05,maj07,maj20,maj20e FROM q011_tmp
     ORDER BY maj02
   LET l_maj02_cnt = 1
   FOREACH q011_fill_maj02_cs INTO l_maj_arr[l_maj02_cnt].*
       LET l_maj02_cnt = l_maj02_cnt + 1
   END FOREACH
   LET l_maj02_cnt = l_maj02_cnt - 1 
                                   
   LET l_sql = "SELECT amt FROM q011_tmp ",
               " WHERE maj02 = ? AND dept_m = ? "
   PREPARE q011_sel_amt_cs FROM l_sql   
#   CALL g_maj.clear()
   LET l_cnt = 1
   FOR l_k = 1 TO l_maj02_cnt
       IF l_maj_arr[l_k].maj03 = '0' THEN  #NOT PRINT
           CONTINUE FOR
       END IF
       
#       LET sr2.maj20 = l_maj_arr[l_k].maj20
#       LET sr2.maj20e= l_maj_arr[l_k].maj20e
       FOR l_j = 1 TO l_dept_cnt
           LET l_amt = 0
           EXECUTE q011_sel_amt_cs INTO l_amt1 USING l_maj_arr[l_k].maj02,l_dept_arr[l_j].dept_m
#           IF l_cnt = 1 THEN
#              LET l_str = "dept",l_j USING "<<<<<<"
#              CALL cl_set_comp_visible(l_str,TRUE)
#              CALL cl_set_comp_att_text(l_str,l_dept_arr[l_j].gem02 CLIPPED)
#           END IF
 
           IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
           CASE l_j
              WHEN 1   LET l_amt[1] = l_amt1  LET m_dept[1]  = l_dept_arr[1].gem02 
              WHEN 2   LET l_amt[2] = l_amt1  LET m_dept[2]  = l_dept_arr[2].gem02 
              WHEN 3   LET l_amt[3] = l_amt1  LET m_dept[3]  = l_dept_arr[3].gem02 
              WHEN 4   LET l_amt[4] = l_amt1  LET m_dept[4]  = l_dept_arr[4].gem02 
              WHEN 5   LET l_amt[5] = l_amt1  LET m_dept[5]  = l_dept_arr[5].gem02 
              WHEN 6   LET l_amt[6] = l_amt1  LET m_dept[6]  = l_dept_arr[6].gem02 
              WHEN 7   LET l_amt[7] = l_amt1  LET m_dept[7]  = l_dept_arr[7].gem02 
              WHEN 8   LET l_amt[8] = l_amt1  LET m_dept[8]  = l_dept_arr[8].gem02 
              WHEN 9   LET l_amt[9] = l_amt1  LET m_dept[9]  = l_dept_arr[9].gem02 
              WHEN 10  LET l_amt[10]= l_amt1  LET m_dept[10] = l_dept_arr[10].gem02
           END CASE
       END FOR
       IF g_flag = 'n' THEN
          LET l_sum[l_k] =l_sum[l_k]+l_amt[1]+l_amt[2]+l_amt[3]+l_amt[4]+l_amt[5]
                     +l_amt[6]+l_amt[7]+l_amt[8]+l_amt[9]+l_amt[10]
       ELSE       	  
       	  FOR l_j =1 TO l_dept_cnt
       	      LET l_sum[l_k] = l_sum[l_k] + l_amt[l_j]
       	  END FOR   
       	  LET l_amt[l_dept_cnt +1] = l_sum[l_k]  
       	  LET m_dept[l_dept_cnt + 1] = '合  計'   	   
       END IF
       
#       LET sr2.sum =  sr2.dept1  + sr2.dept2  + sr2.dept3  + sr2.dept4  + sr2.dept5 
#                           + sr2.dept6  + sr2.dept7  + sr2.dept8  + sr2.dept9  + sr2.dept10
#                           + sr2.dept11 + sr2.dept12 + sr2.dept13 + sr2.dept14 + sr2.dept15
#                           + sr2.dept16 + sr2.dept17 + sr2.dept18 + sr2.dept19 + sr2.dept20
#                           + sr2.dept21 + sr2.dept22 + sr2.dept23 + sr2.dept24 + sr2.dept25
#                           + sr2.dept26 + sr2.dept27 + sr2.dept28 + sr2.dept29 + sr2.dept30
#                           + sr2.dept31 + sr2.dept32 + sr2.dept33 + sr2.dept34 + sr2.dept35
#                           + sr2.dept36 + sr2.dept37 + sr2.dept38 + sr2.dept39 + sr2.dept40
#                           + sr2.dept41 + sr2.dept42 + sr2.dept43 + sr2.dept44 + sr2.dept45
#                           + sr2.dept46 + sr2.dept47 + sr2.dept48 + sr2.dept49 + sr2.dept50       
#                           + sr2.dept51 + sr2.dept52 + sr2.dept53 + sr2.dept54 + sr2.dept55
#                           + sr2.dept56 + sr2.dept57 + sr2.dept58 + sr2.dept59 + sr2.dept60       
#                           + sr2.dept61 + sr2.dept62 + sr2.dept63 + sr2.dept64 + sr2.dept65
#                           + sr2.dept66 + sr2.dept67 + sr2.dept68 + sr2.dept69 + sr2.dept70       
#                           + sr2.dept71 + sr2.dept72 + sr2.dept73 + sr2.dept74 + sr2.dept75
#                           + sr2.dept76 + sr2.dept77 + sr2.dept78 + sr2.dept79 + sr2.dept80       
#                           + sr2.dept81 + sr2.dept82 + sr2.dept83 + sr2.dept84 + sr2.dept85
#                           + sr2.dept86 + sr2.dept87 + sr2.dept88 + sr2.dept89 + sr2.dept90       
#                           + sr2.dept91 + sr2.dept92 + sr2.dept93 + sr2.dept94 + sr2.dept95
#                           + sr2.dept96 + sr2.dept97 + sr2.dept98 + sr2.dept99 + sr2.dept100      
#                           + sr2.dept101 + sr2.dept102 + sr2.dept103 + sr2.dept104 + sr2.dept105
#                           + sr2.dept106 + sr2.dept107 + sr2.dept108 + sr2.dept109 + sr2.dept110      
#                           + sr2.dept111 + sr2.dept112 + sr2.dept113 + sr2.dept114 + sr2.dept115
#                           + sr2.dept116 + sr2.dept117 + sr2.dept118 + sr2.dept119 + sr2.dept120      
#       IF cl_null(sr2.sum) THEN LET sr2.sum = 0 END IF
       IF cl_null(l_sum[l_k]) THEN LET l_sum[l_k] = 0 END IF
       EXECUTE insert_prep USING
          l_maj_arr[l_k].*,l_i,
          m_dept[1],m_dept[2],m_dept[3],m_dept[4],m_dept[5],
          m_dept[6],m_dept[7],m_dept[8],m_dept[9],m_dept[10],
          l_amt[1],l_amt[2],l_amt[3],l_amt[4],l_amt[5],
          l_amt[6],l_amt[7],l_amt[8],l_amt[9],l_amt[10],
          '2'
       IF STATUS THEN
          CALL cl_err("execute insert_prep:",STATUS,1)
          EXIT FOREACH
       END IF      
   END FOR  
    

END FUNCTION             

