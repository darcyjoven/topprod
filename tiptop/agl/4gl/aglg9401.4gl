# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: aglg9401.4gl
# Descriptions...: 現金流量表列印(合併)
# Date & Author..: 12/03/07 By Lori(FUN-BC0123)
# Modify.........: No:FUN-C30098 12/03/16 By Belle 合併處理各期異動額時要依群組所屬科目去扣掉agli9431的期初數
# Modify.........: No:CHI-C40004 12/04/05 By Belle 調整本期損益計算
# Modify.........: No:CHI-C40011 12/04/11 By Belle 起迄(月，季，半年)結束不可小於起始
# Modify.........: No:TQC-C50059 12/05/15 By xuxz 勾選要印明細，只有營業活動才會出現科目，其它的投資和理財活動不會出現科目的問題
# Modify.........: No:TQC-C50139 12/05/16 By xuxz giqq04 為 '4'或 '5' 時,不需區分 tm.t 應只需列印一筆
# Modify.........: No:TQC-C50218 12/05/28 By lujh  IF l_last >=0 THEN   LET l_str1 = cl_numfor(l_this,20,tm.e)  --> 改為 l_last   
#                                                  IF l_last_1 >= 0 THEN   LET l_str3 = cl_numfor(l_this_1,20,tm.e) --> 改為 l_last_1
#                                                  針對匯率變動對現金及約當現金之影響的 l_diff/l_diff_1 變數歸零,並將 END IF 判斷式移到差異時才做處理
# Modify.........: No:FUN-C70034 12/07/04 By fengmy CR報表改成GR報表

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           title   LIKE type_file.chr50,  #輸入報表名稱
           y1      LIKE axh_file.axh06,   #輸入起始年度
           m1      LIKE axh_file.axh07,   #Begin 期別
           y2      LIKE axh_file.axh06,   #輸入截止年度
           m2      LIKE axh_file.axh07,   #End   期別
           y11     LIKE axh_file.axh06,   #輸入起始年度
           y21     LIKE axh_file.axh06,   #輸入截止年度
           m11     LIKE axh_file.axh07,   #Begin 期別
           m21     LIKE axh_file.axh07,   #End   期別
           q1      LIKE axh_file.axh06,   #輸入起始季度
           q2      LIKE axh_file.axh06,   #輸入截止季度
           h1      LIKE axh_file.axh07,   #Begin 半年別
           h2      LIKE axh_file.axh07,   #End   半年別
           q11     LIKE axh_file.axh06,   #輸入起始季度
           q21     LIKE axh_file.axh06,   #輸入截止季度
           h11     LIKE axh_file.axh07,   #Begin 半年別
           h21     LIKE axh_file.axh07,   #End   半年別
           axa01   LIKE axa_file.axa01,   #族群代號
           axa02   LIKE axa_file.axa02,   #上層公司
           axa06   LIKE axa_file.axa02,
           b       LIKE aaa_file.aaa01,   #帳別編號
           c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印
           e       LIKE azi_file.azi05,   #小數位數
           d       LIKE type_file.chr1,   #金額單位
           o       LIKE type_file.chr1,   #轉換幣別否
           r       LIKE azi_file.azi01,   #總帳幣別
           p       LIKE azi_file.azi01,   #轉換幣別
           q       LIKE azj_file.azj03,   #匯率
           amt     LIKE type_file.num20_6,#現金流量期初餘額
           s       LIKE type_file.chr1,   #是否有揭露事項
           t       LIKE type_file.chr1,   #列印明細
           more    LIKE type_file.chr1    #Input more condition(Y/N)   #CHI-C40011
           END RECORD,
       bdate,edate LIKE type_file.dat,
       i,j,k       LIKE type_file.num5,
       g_unit      LIKE type_file.num10,  #金額單位基數
       g_bookno    LIKE axh_file.axh00,   #帳別
       g_giyy       DYNAMIC ARRAY OF RECORD
                    giyy01   LIKE giyy_file.giyy01,
                    giyy02   LIKE giyy_file.giyy02,
                    giyy03   LIKE giyy_file.giyy03
                   END RECORD
DEFINE g_aaa03     LIKE aaa_file.aaa03
DEFINE g_cnt       LIKE type_file.num10
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000
DEFINE g_name      LIKE type_file.chr20
DEFINE g_flag      LIKE type_file.chr1     #Y:產生接口數據 N:正常打印
DEFINE g_ym        LIKE type_file.chr6     #年期
DEFINE g_ym1       LIKE type_file.chr6     #年期
DEFINE l_table     STRING
DEFINE g_str       STRING
DEFINE g_sql       STRING
DEFINE g_dbs_axz03 LIKE type_file.chr21
DEFINE g_aaz641    LIKE aaz_file.aaz641
DEFINE g_axa05     LIKE axa_file.axa05
DEFINE g_axz03     LIKE axz_file.axz03

###GENGRE###START
TYPE sr1_t RECORD
   type   LIKE type_file.chr1,
   str1   LIKE type_file.chr50,
   giqq02 LIKE type_file.chr1000,
   str2   LIKE type_file.chr50,
   giqq04 LIKE giqq_file.giqq04,
   str3   LIKE type_file.chr50,
   str4   LIKE type_file.chr50
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET tm.b = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   INITIALIZE tm.* TO NULL
   LET tm.y1 = ARG_VAL(8)
   LET tm.m1 = ARG_VAL(9)
   LET g_name= ARG_VAL(10)
   IF NOT (cl_null(tm.y1) OR cl_null(tm.m1)) THEN
      LET g_flag = 'Y'
      IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
      IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF
      LET g_ym = tm.y1 USING '&&&&',tm.m1 USING '&&'
      LET g_ym1= tm.y11 USING '&&&&',tm.m1 USING '&&'
      SELECT axz06 INTO g_aaa03 FROM axz_file where axz01 = tm.axa02
      SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
      IF cl_null(tm.e) THEN LET tm.e = 1 END IF
      IF cl_null(tm.m2) THEN LET tm.m2 = tm.m1 END IF
      IF cl_null(tm.title) THEN LET tm.title = g_name END IF
      LET tm.r = g_aaa03
      LET tm.c = 'N'              #CHI-C40011 Y->N
      LET tm.d = '1'
      LET tm.o = 'N'
      LET tm.p = tm.r
      LET tm.q = 1
      LET tm.amt  = 0
      LET g_pdate  = g_today
      LET g_bgjob  = 'N'
      LET g_copies = '1'
      LET tm.more = 'N'           #CHI-C40011
      LET tm.t = 'N'
      IF tm.d = '1' THEN LET g_unit = 1 END IF
      IF tm.d = '2' THEN LET g_unit = 1000 END IF
      IF tm.d = '3' THEN LET g_unit = 1000000 END IF
   ELSE
      LET g_flag = 'N'
   END IF

   LET g_rlang  = g_lang
   IF g_flag = 'N' THEN
      IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
      IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
         CALL g9401_tm()                         # Input print condition
      ELSE
         CALL g9401()                            # Read data and create out-file
      END IF
   ELSE
      CALL g9401()                               # Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)
END MAIN

FUNCTION g9401_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_sw           LIKE type_file.chr1     #重要欄位是否空白
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE l_n            LIKE type_file.num5
   DEFINE l_aaa05        LIKE aaa_file.aaa05

   CALL s_dsmark(tm.b)

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE
      LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW g9401_w AT p_row,p_col WITH FORM "agl/42f/aglg9401"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL  s_shwact(0,0,tm.b)
   CALL cl_opmsg('p')

   LET g_sql = "type.type_file.chr1,",
               "str1.type_file.chr50,",
               "giqq02.type_file.chr1000,",
               "str2.type_file.chr50,",
               "giqq04.giqq_file.giqq04,",
               "str3.type_file.chr50,",
               "str4.type_file.chr50"
   LET l_table = cl_prt_temptable('aglg9401',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,? ,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)  
   END IF
   IF cl_null(tm.e) THEN LET tm.e = 1 END IF
   LET tm.c     = 'N'          #CHI-C40011 Y->N
   LET tm.d     = '1'
   LET tm.o     = 'N'
   LET tm.r     = g_aaa03
   LET tm.p     = g_aaa03
   LET tm.q     = 1
   LET tm.amt   = 0
   LET tm.s     = 'N'
   LET tm.t     = 'N'
   LET tm.more = 'N'           #CHI-C40011
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_sw = 1
      INPUT BY NAME tm.axa01,tm.axa02,tm.b,tm.title
                   ,tm.y1,tm.m1,tm.m2,tm.q1,tm.q2,tm.h1,tm.h2
                   ,tm.e,tm.d,tm.c,tm.s,tm.t 
                   ,tm.o,tm.r,tm.p,tm.q,tm.more                 #CHI-C40011 add tm.more
                    WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont() 
            LET g_action_choice = "locale"
            EXIT INPUT

         BEFORE FIELD title
            IF cl_null(tm.title) THEN 
               SELECT gaz06 INTO tm.title FROM gaz_file
                 WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05='Y'
               IF cl_null(tm.title) THEN
                  SELECT gaz06 INTO tm.title FROM gaz_file
                    WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05='N'
               END IF
            END IF

        #FUN-C30098---
         BEFORE FIELD q
            IF tm.o = 'N' THEN
               NEXT FIELD o
            END IF
        #FUN-C30098---
        #CHI-C40011---
         BEFORE FIELD p
            IF tm.o = 'N' THEN NEXT FIELD more END IF
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
            END IF
        #CHI-C40011---

         AFTER FIELD axa01
            IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=tm.axa01
            IF SQLCA.sqlcode THEN LET l_n = 0 END IF
            IF l_n <=0  THEN
               CALL cl_err(tm.axa01,'agl-223',0) 
               NEXT FIELD axa01
            END IF
            LET tm.axa06 = '2'
            SELECT axa05,axa06 INTO g_axa05,tm.axa06    #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
              FROM axa_file
             WHERE axa01 = tm.axa01                     #族群編號
               AND axa04 = 'Y'                          #最上層公司否
            DISPLAY BY NAME tm.axa06
            CALL g9401_set_entry()
            CALL g9401_set_no_entry()
            IF tm.axa06 = '1' THEN
               LET tm.q1 = '' 
               LET tm.h1 = '' 
	       LET tm.q2 = ''
	       LET tm.h2 = ''
               LET tm.q11 = ''     #FUN-C30098  add      
               LET tm.h11 = ''     #FUN-C30098  add
               LET tm.q21 = ''     #FUN-C30098  add
               LET tm.h21 = ''     #FUN-C30098  add
               LET l_aaa05 = 0
               SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                WHERE aaa01=tm.b AND aaaacti MATCHES '[Yy]'
               LET tm.m1 = l_aaa05
               LET tm.m2 = l_aaa05
               LET tm.m11 = l_aaa05
               LET tm.m21 = l_aaa05
            END IF
            IF tm.axa06 = '2' THEN
               LET tm.h1  = '' 
               LET tm.m1  = ''
               LET tm.h2  = ''
               LET tm.m2  = ''
               LET tm.h11 = '' 
               LET tm.m11 = ''
               LET tm.h21 = ''
               LET tm.m21 = ''
            END IF
            IF tm.axa06 = '3' THEN
               LET tm.m1  = ''
               LET tm.q1  = ''
               LET tm.m1  = ''
               LET tm.q1  = ''
               LET tm.m11 = ''
               LET tm.q11 = ''
               LET tm.m11 = ''
               LET tm.q11 = ''
            END IF
            IF tm.axa06 = '4' THEN
               LET tm.m1  = ''
               LET tm.q1  = ''
               let tm.h1  = ''
               LET tm.m2  = ''
               LET tm.q2  = ''
               LET tm.h2  = ''
               LET tm.m11 = ''
               LET tm.q11 = ''
               let tm.h11 = ''
               LET tm.m21 = ''
               LET tm.q21 = ''
               LET tm.h21 = ''
            END IF
            DISPLAY BY NAME tm.m1,tm.m2,tm.q1,tm.q2,tm.h1,tm.h2
            DISPLAY BY NAME tm.m11,tm.m21,tm.q11,tm.q21,tm.h11,tm.h21    #FUN-C30098

         AFTER FIELD axa02
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=tm.axa01 AND axa02=tm.axa02
            IF SQLCA.sqlcode THEN LET l_n = 0 END IF
            IF l_n <=0  THEN
               CALL cl_err(tm.axa02,'agl-223',0)
               NEXT FIELD axa02
            ELSE
               SELECT axa03 INTO tm.b FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               DISPLAY BY NAME tm.b
            END IF
            CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
            CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641
            IF cl_null(g_aaz641) THEN
               CALL cl_err(g_axz03,'agl-601',1)
               NEXT FIELD axa02
            ELSE
               LET tm.b = g_aaz641
               DISPLAY BY NAME tm.b
            END IF
            SELECT axz06 INTO g_aaa03 FROM axz_file where axz01 = tm.axa02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)
            END IF
            LET tm.r = g_aaa03
            DISPLAY BY NAME tm.r

            #使用預設帳別之幣別之小數位數
            SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)
            END IF
            IF cl_null(tm.e) THEN LET tm.e = 1 END IF
                            
         AFTER FIELD title
            IF tm.title IS NULL THEN NEXT FIELD title END IF

         AFTER FIELD y1
            IF tm.y1 IS NULL OR tm.y1 = 0 THEN
               NEXT FIELD y1
            END IF
            IF tm.y1 > YEAR(g_pdate) THEN
               CALL cl_err('','agl-920',0)
               NEXT FIELD y1
            END IF
            LET tm.y2  = tm.y1
            LET tm.y11 = tm.y1 - 1
            LET tm.y21 = tm.y11
            DISPLAY BY NAME tm.y11

         AFTER FIELD m1
            IF NOT cl_null(tm.m1) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.y1
               IF g_azm.azm02 = 1 THEN
                  IF tm.m1 > 12 OR tm.m1 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m1
                  END IF
               ELSE
                  IF tm.m1 > 13 OR tm.m1 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m1
                  END IF
               END IF
            END IF
            IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
            IF tm.y1 = YEAR(g_pdate) AND tm.m1 > MONTH(g_pdate) THEN
               CALL cl_err('','agl-920',0)
               NEXT FIELD m1
            END IF
            LET tm.m11 = tm.m1
            DISPLAY BY NAME tm.m11
 
         AFTER FIELD m2
            IF NOT cl_null(tm.m2) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.y1
               IF g_azm.azm02 = 1 THEN
                  IF tm.m2 > 12 OR tm.m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               ELSE
                  IF tm.m2 > 13 OR tm.m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               END IF
            END IF
            IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
            IF tm.y2 = YEAR(g_pdate) AND tm.m2 > MONTH(g_pdate) THEN
               CALL cl_err('','agl-920',0)
               NEXT FIELD m2
            END IF
            IF tm.y1 = tm.y2 AND tm.m1 > tm.m2 THEN
               CALL cl_err('','9011',0) NEXT FIELD m1
            END IF
            LET tm.m21 = tm.m2
            DISPLAY BY NAME tm.m21

         AFTER FIELD q1    #季
            IF NOT cl_null(tm.q1) AND tm.q1 NOT MATCHES '[1234]' THEN
               NEXT FIELD q1
            END IF
            LET tm.q11 = tm.q1
            DISPLAY BY NAME tm.q11

         AFTER FIELD q2
            IF NOT cl_null(tm.q2) AND tm.q2 NOT MATCHES '[1234]' THEN
               NEXT FIELD q2
            END IF
           #CHI-C40011--
            IF tm.y1 = tm.y2 AND tm.q1 > tm.q2 THEN
               CALL cl_err('','9011',0) NEXT FIELD q1
            END IF
           #CHI-C40011--
            LET tm.q21 = tm.q2
            DISPLAY BY NAME tm.q21

         AFTER FIELD h1 #半年報
            IF (tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
            LET tm.h11 = tm.h1
            DISPLAY BY NAME tm.h11

         AFTER FIELD h2
            IF (tm.h2>2 OR tm.h2<0) AND tm.axa06='4' THEN
               NEXT FIELD h2
            END IF
           #CHI-C40011--
            IF tm.y1 = tm.y2 AND tm.h1 > tm.h2 THEN
               CALL cl_err('','9011',0) NEXT FIELD h1
            END IF
           #CHI-C40011--
            LET tm.h21 = tm.h2
            DISPLAY BY NAME tm.h21

         AFTER FIELD b
            IF tm.b IS NULL THEN NEXT FIELD b END IF
            CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
                NEXT FIELD b 
            END IF 
            SELECT aaa02 FROM aaa_file
             WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)
               NEXT FIELD b
            END IF

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF

         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF

         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN  
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0) 
               NEXT FIELD p
            END IF

         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF

         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF

         AFTER FIELD t
            IF tm.t IS NULL OR tm.t NOT MATCHES'[YN]' THEN 
               NEXT FIELD t
            END IF 
         
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
            END IF
            IF NOT cl_null(tm.axa06) AND tm.axa06 <> '1' THEN
              #CALL s_get_aznn01(g_dbs_axz03,tm.axa06,tm.b,tm.y1,tm.q1,tm.h1)   #FUN-C30098 mark 
               CALL s_get_aznn02(g_dbs_axz03,tm.axa06,tm.b,tm.y1,tm.q1,tm.h1)   #FUN-C30098
                    RETURNING tm.m1
               CALL s_get_aznn01(g_dbs_axz03,tm.axa06,tm.b,tm.y2,tm.q2,tm.h2)   
                    RETURNING tm.m2
               LET tm.m11 = tm.m1
               LET tm.m21 = tm.m2
              #FUN-C30098--
               IF cl_null(tm.m1) OR cl_null(tm.m2) THEN
                  CALL cl_err('','agl-022',0)
                  NEXT FIELD y1
               END IF
              #FUN-C30098--
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution

         ON ACTION mntn_labor_amount
            CALL cl_cmdrun("agli9421")

         ON ACTION mntn_expose_item
            CALL cl_cmdrun("agli9441")

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) OR INFIELD(axa02)         
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_axa'
                  LET g_qryparam.default1 = tm.axa01
                  LET g_qryparam.default2 = tm.axa02
                  LET g_qryparam.default3 = tm.b
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.b
                  DISPLAY BY NAME tm.axa01
                  DISPLAY BY NAME tm.axa02
                  DISPLAY BY NAME tm.b
                  NEXT FIELD axa01

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

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g9401_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g9401()
      ERROR ""
   END WHILE
   CLOSE WINDOW g9401_w
END FUNCTION

FUNCTION g9401()
   DEFINE l_name    LIKE type_file.chr20         
   DEFINE l_chr     LIKE type_file.chr1          
   DEFINE amt1      LIKE type_file.num20_6       
   DEFINE amt1_1    LIKE type_file.num20_6       
   DEFINE l_tmp     LIKE type_file.num20_6       

   #移至前面主要因為tm.title 多語言的關係
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b  
      AND aaf02 = g_rlang
 
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg9401'

#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF      #FUN-C70034
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR         #FUN-C70034
    CALL cl_del_data(l_table)
    CALL g9401_cr()

END FUNCTION

FUNCTION g9401_cr()
   DEFINE l_sql       LIKE type_file.chr1000,       # RDSQL STATEMENT
          l_str1      LIKE type_file.chr50,
          l_str2      LIKE type_file.chr50,
          l_str3      LIKE type_file.chr50,
          l_str4      LIKE type_file.chr50,
          l_d1        LIKE type_file.num5,         
          l_d2        LIKE type_file.num5,         
          l_flag      LIKE type_file.chr1,         
          l_flag1     LIKE type_file.chr1,           #FUN-C30098
          l_str       LIKE type_file.chr21,        
          l_bdate     LIKE type_file.dat,          
          l_edate     LIKE type_file.dat,          
          l_type      LIKE aag_file.aag06,           #正常餘額型態(1.借餘/2.貨餘) 
          l_cnt       LIKE type_file.num5,           #揭露事項筆數       
          l_last_y    LIKE type_file.num5,           #期初年份 
          l_last_m    LIKE type_file.num5,           #期初月份 
          l_this      LIKE type_file.num20_6,        #本期餘額 
          l_last      LIKE type_file.num20_6,        #期初餘額 
          l_diff      LIKE type_file.num20_6,        #匯差
          l_modamt    LIKE type_file.num20_6,        #調整金額
          l_amt       LIKE type_file.num20_6,        #科目現金流量 
          l_amt_s     LIKE type_file.num20_6,        #群組現金流量 
          l_sub_amt   LIKE type_file.num20_6,        #各活動產生之淨現金 
          l_tot_amt   LIKE type_file.num20_6,        #本期現金淨增數
          l_last_y1   LIKE type_file.num5,
          l_str_1     LIKE type_file.chr21,        
          l_this_1    LIKE type_file.num20_6,        #本期餘額 
          l_last_1    LIKE type_file.num20_6,        #期初餘額 
          l_diff_1    LIKE type_file.num20_6,        #匯差 
          l_modamt_1  LIKE type_file.num20_6,        #調整金額
          l_amt_1     LIKE type_file.num20_6,        #科目現金流量(前期)
          l_amt_s_1   LIKE type_file.num20_6,        #群組現金流量(前期)
          l_sub_amt_1 LIKE type_file.num20_6,        #各活動產生之淨現金 
          l_tot_amt_1 LIKE type_file.num20_6        　#本期現金淨增數 
          
   DEFINE tmp         RECORD
          aag01       LIKE aag_file.aag01,
          aag02       LIKE aag_file.aag02,
          giww03      LIKE giww_file.giww03,
          giww04      LIKE giww_file.giww04
                  END RECORD
   DEFINE giqq        RECORD                         #群組代號
          giqq01      LIKE giqq_file.giqq01,
          giqq02      LIKE giqq_file.giqq02,
          giqq04      LIKE giqq_file.giqq04
                  END RECORD
   DEFINE l_giqq02    LIKE type_file.chr1000                   
   DEFINE gixx        RECORD 
          gixx02      LIKE gixx_file.gixx02,
          aag02       LIKE aag_file.aag02,
          gixx05      LIKE gixx_file.gixx05
                  END RECORD
   DEFINE l_gixx  DYNAMIC ARRAY OF RECORD 
          giqq02      LIKE type_file.chr1000,
          gixx05      LIKE gixx_file.gixx05,
          gixx051     LIKE gixx_file.gixx05
                  END RECORD       
   DEFINE l_i_1       LIKE type_file.num5       
   DEFINE l_i_2       LIKE type_file.num5
   DEFINE l_space     STRING
   DEFINE l_len       LIKE type_file.num5 
   DEFINE l_num       LIKE type_file.num5 
   DEFINE l_giqq04    LIKE giqq_file.giqq04           #行次
   DEFINE l_axh08     LIKE axh_file.axh08
   DEFINE l_axh09     LIKE axh_file.axh09
   DEFINE tmp1        RECORD
          type        LIKE type_file.chr1,
          str1        LIKE type_file.chr50,
          giqq02      LIKE type_file.chr1000,
          str2        LIKE type_file.chr50,
          giqq04      LIKE giqq_file.giqq04,
          str3        LIKE type_file.chr50,
          str4        LIKE type_file.chr50
                  END RECORD
   DEFINE l_n         LIKE type_file.num10        #FUN-C30098
   DEFINE l_n1        LIKE type_file.num10        #FUN-C30098

   CALL g9401_create_temp_table()

   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y1,tm.m1,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate
   END IF
   LET l_d1 = DAY(l_bdate)
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y2,tm.m2,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate
   END IF
   LET l_d2 = DAY(l_edate)
   IF tm.m1=1 THEN
      LET l_last_y = tm.y1 - 1
      LET l_last_y1= tm.y11- 1
      LET l_last_m = 12
   ELSE
      LET l_last_y = tm.y1
      LET l_last_y1= tm.y11
      LET l_last_m = tm.m1 - 1
   END IF

   LET l_amt = 0
   LET l_amt_s = 0
   LET l_this = 0
   LET l_last = 0
   LET l_sub_amt = 0
   LET l_tot_amt = 0
   LET l_this_1 = 0
   LET l_last_1 = 0
   LET l_amt_1 = 0
   LET l_amt_s_1 = 0
   LET l_sub_amt_1 = 0
   LET l_tot_amt_1 = 0
   LET l_giqq04 = 0
  #營業活動之現金流量
   LET l_type = '1'
   LET l_flag = 'N'
  #=========================本期淨利(損)=========================#
   CALL g9401_axh5(g_aaz.aaz114,tm.y1 ,tm.m2) RETURNING l_amt            #CHI-C40004  g9401_axh-->g9401_axh5
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF
   CALL g9401_axh5(g_aaz.aaz114,tm.y11,tm.m2) RETURNING l_amt_1          #CHI-C40004  g9401_axh-->g9401_axh5
   IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
  #將本期淨利(損)金額加至 營業活動產生之淨現金l_sub_amt
   LET l_sub_amt = l_sub_amt + l_amt
   LET l_amt = l_amt*tm.q/g_unit                #依匯率及單位換算
   LET l_sub_amt_1 = l_sub_amt_1 + l_amt_1
   LET l_amt_1 = l_amt_1*tm.q/g_unit            #依匯率及單位換算
   IF l_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_amt,20,tm.e)
   ELSE
      CALL g9401_str(l_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   IF l_amt_1 >= 0 THEN
      LET l_str3 = cl_numfor(l_amt_1,20,tm.e)
   ELSE
      CALL g9401_str(l_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
  #調整項目
  #=========================營業科目=========================#
   LET l_sql= "SELECT giqq01,giqq02,giqq04 FROM giqq_file "
             ," WHERE giqq03 = '1'"
             ," ORDER BY giqq04,giqq02"
   PREPARE g9401_giqq_p1 FROM l_sql
   DECLARE g9401_giqq_c1 CURSOR FOR g9401_giqq_p1
   LET l_sql= "SELECT aag01,aag02,giww03,giww04 "
             ,"  FROM aag_file,giww_file,giqq_file"
             ," WHERE aag00=giww00 AND aag01=giww02 AND giqq01=giww01 "
             ,"   AND aag00 = '",tm.b,"' "
             ,"   AND giww01 = ? "
             ,"   AND giww05 = '",tm.axa01,"'"
             ,"   AND giww06 = '",tm.axa02,"'"
   PREPARE g9401_giww_p1 FROM l_sql
   DECLARE g9401_giww_c1 CURSOR FOR g9401_giww_p1
   FOREACH g9401_giqq_c1 INTO giqq.*
      LET l_i_1 = 1
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      FOREACH g9401_giww_c1 USING giqq.giqq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0
         CASE tmp.giww04  
            WHEN '1'
              #CALL g9401_axh(tmp.aag01,tm.y2 ,tm.m2) RETURNING l_amt                            #FUN-C30098 mark
              #CALL g9401_axh(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1                          #FUN-C30098 mark
               CALL g9401_axh3(tmp.aag01,tm.y2 ,tm.m2,giqq.giqq01) RETURNING l_amt               #FUN-C30098
               CALL g9401_axh3(tmp.aag01,tm.y21,tm.m2,giqq.giqq01) RETURNING l_amt_1             #FUN-C30098
            WHEN '2'
              #CALL g9401_axh2(tmp.aag01,l_last_y ,l_last_m) RETURNING l_amt                     #FUN-C30098 mark
              #CALL g9401_axh2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1                   #FUN-C30098 mark
               CALL g9401_axh4(tmp.aag01,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt         #FUN-C30098
               CALL g9401_axh4(tmp.aag01,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1       #FUN-C30098
            WHEN '3'
              #CALL g9401_axh2(tmp.aag01,tm.y2 ,tm.m2) RETURNING l_amt                           #FUN-C30098 mark
              #CALL g9401_axh2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1                         #FUN-C30098 mark
               CALL g9401_axh4(tmp.aag01,tm.y2 ,tm.m2,giqq.giqq01) RETURNING l_amt               #FUN-C30098
               CALL g9401_axh4(tmp.aag01,tm.y21,tm.m2,giqq.giqq01) RETURNING l_amt_1             #FUN-C30098
            WHEN '4'
               SELECT SUM(gixx05) INTO l_amt FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y1       AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               LET l_str_1 = tmp.aag01
               LET l_len = LENGTH(l_str_1)
               LET l_num = 26 - l_len
               LET l_space = l_num spaces
               LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02
               LET l_gixx[l_i_1].gixx05 = l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gixx05) INTO l_amt_1 FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               LET l_gixx[l_i_1].gixx051 = l_amt_1
               IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
               LET l_i_1 = l_i_1 + 1
            WHEN '5'  #借方異動
              #CALL g9401_axh08(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt                 #FUN-C30098 mark 
              #CALL g9401_axh08(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1               #FUN-C30098 mark
               CALL g9401_axh081(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt    #FUN-C30098
               CALL g9401_axh081(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1  #FUN-C30098
            WHEN '6'  #貸方異動
              #CALL g9401_axh09(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt                 #FUN-C30098 mark 
              #CALL g9401_axh09(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1               #FUN-C30098 mark
               CALL g9401_axh091(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt    #FUN-C30098 
               CALL g9401_axh091(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1  #FUN-C30098
         END CASE
         IF cl_null(l_amt)   THEN LET l_amt   = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
         IF tmp.giww04 <> '4' THEN
            SELECT SUM(gixx05) INTO l_modamt 
              FROM gixx_file,giqq_file
             WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
               AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
               AND gixx01 = giqq01
               AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
            IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
            LET l_amt = l_amt + l_modamt
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02
            LET l_gixx[l_i_1].gixx05 = l_amt
            SELECT SUM(gixx05) INTO l_modamt_1 
              FROM gixx_file,giqq_file
             WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
               AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
               AND gixx01 = giqq01
               AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
            LET l_gixx[l_i_1].gixx051 = l_amt_1
            IF cl_null(l_modamt_1) THEN LET l_modamt_1 = 0 END IF
            LET l_amt_1 = l_amt_1 + l_modamt_1
            LET l_i_1 = l_i_1 + 1
         END IF
        #若為減項
         IF tmp.giww03 = '-' THEN
            LET l_amt = l_amt * -1
            LET l_amt_1 = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1

      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_sub_amt = l_sub_amt + l_amt_s         #計算營業活動產生之淨現金
      LET l_amt_s = l_amt_s*tm.q/g_unit           #依匯率及單位換算
      LET l_sub_amt_1 = l_sub_amt_1 + l_amt_s_1   #計算營業活動產生之淨現金
      LET l_amt_s_1 = l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,')'
      END IF
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,')'
      END IF
      LET l_flag = 'Y'
      IF tm.t = 'N' THEN 
         INSERT INTO g9401_tmp VALUES (l_type,l_str1,giqq.giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
      ELSE 
      	 FOR l_i_2 = 1 TO l_i_1
            IF cl_null(l_gixx[l_i_2].gixx05) THEN
               LET l_gixx[l_i_2].gixx05 = 0
            END IF
            IF cl_null(l_gixx[l_i_2].gixx051) THEN
               LET l_gixx[l_i_2].gixx051 = 0
            END IF
            IF l_gixx[l_i_2].gixx05 >= 0 THEN
               LET l_str2 = cl_numfor(l_gixx[l_i_2].gixx05,20,tm.e)
            ELSE
               CALL g9401_str(l_gixx[l_i_2].gixx05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
            END IF
            IF l_gixx[l_i_2].gixx051 >= 0 THEN
               LET l_str4 = cl_numfor(l_gixx[l_i_2].gixx051,20,tm.e)
            ELSE
               CALL g9401_str(l_gixx[l_i_2].gixx051,l_str4) RETURNING l_str4
               LET l_str4 = l_str4 CLIPPED,')'
            END IF
            INSERT INTO g9401_tmp VALUES (l_type,l_str1,l_gixx[l_i_2].giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
      	 END FOR     
      END IF
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO g9401_tmp VALUES (l_type,l_str1,'','',l_giqq04,l_str3,'')
   END IF
  #=========================營業活動產生之淨現金=========================#
   LET l_type = '2' 
   LET l_tot_amt = l_tot_amt + l_sub_amt          #計算本期現金淨增數
   LET l_sub_amt = l_sub_amt * tm.q/g_unit        #依匯率及單位換算
   LET l_tot_amt_1 = l_tot_amt_1 + l_sub_amt_1    #計算本期現金淨增數
   LET l_sub_amt_1 = l_sub_amt_1 * tm.q/g_unit    #依匯率及單位換算
   IF l_sub_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL g9401_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   IF l_sub_amt_1 >= 0 THEN
      LET l_str3 = cl_numfor(l_sub_amt_1,20,tm.e)
   ELSE
      CALL g9401_str(l_sub_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO g9401_tmp VALUES (l_type,l_str1,'','',l_giqq04,l_str3,'')
   LET l_sub_amt = 0
   LET l_sub_amt_1 = 0

  #=========================投資活動之現金流量=========================#
   LET l_type = '3'
   LET l_flag = 'N'
   LET l_sql= "SELECT giqq01,giqq02,giqq04 FROM giqq_file "
             ," WHERE giqq03 = '2'"
             ," ORDER BY giqq04,giqq02"
   PREPARE g9401_giqq_p2 FROM l_sql
   DECLARE g9401_giqq_c2 CURSOR FOR g9401_giqq_p2
   LET l_sql= "SELECT aag01,aag02,giww03,giww04 "
             ,"  FROM aag_file,giww_file,giqq_file"
             ," WHERE aag00=giww00 AND aag01=giww02 AND giqq01=giww01 "
             ,"   AND aag00 = '",tm.b,"' "
             ,"   AND giww01 = ?"
             ,"   AND giww05 = '",tm.axa01,"'"
             ,"   AND giww06 = '",tm.axa02,"'"
   PREPARE g9401_giww_p2 FROM l_sql
   DECLARE g9401_giww_c2 CURSOR FOR g9401_giww_p2
   FOREACH g9401_giqq_c2 INTO giqq.*
      LET l_i_1 = 1
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      FOREACH g9401_giww_c2 USING giqq.giqq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0
         CASE tmp.giww04
            WHEN '1'
              #CALL g9401_axh(tmp.aag01,tm.y2 ,tm.m2) RETURNING l_amt                            #FUN-C30098 mark
              #CALL g9401_axh(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1                          #FUN-C30098 mark
               CALL g9401_axh3(tmp.aag01,tm.y2 ,tm.m2,giqq.giqq01) RETURNING l_amt               #FUN-C30098
               CALL g9401_axh3(tmp.aag01,tm.y21,tm.m2,giqq.giqq01) RETURNING l_amt_1             #FUN-C30098
            WHEN '2'
              #CALL g9401_axh2(tmp.aag01,l_last_y ,l_last_m) RETURNING l_amt                     #FUN-C30098 mark
              #CALL g9401_axh2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1                   #FUN-C30098 mark
               CALL g9401_axh4(tmp.aag01,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt         #FUN-C30098
               CALL g9401_axh4(tmp.aag01,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1       #FUN-C30098
            WHEN '3'
              #CALL g9401_axh2(tmp.aag01,tm.y2 ,tm.m2) RETURNING l_amt                           #FUN-C30098 mark
              #CALL g9401_axh2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1                         #FUN-C30098 mark
               CALL g9401_axh4(tmp.aag01,tm.y2 ,tm.m2,giqq.giqq01) RETURNING l_amt               #FUN-C30098
               CALL g9401_axh4(tmp.aag01,tm.y21,tm.m2,giqq.giqq01) RETURNING l_amt_1             #FUN-C30098
            WHEN '4'
               SELECT SUM(gixx05) INTO l_amt FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               LET l_str_1 = tmp.aag01
               LET l_len = LENGTH(l_str_1)
               LET l_num = 26 - l_len
               LET l_space = l_num spaces
               LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02   
               LET l_gixx[l_i_1].gixx05=l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gixx05) INTO l_amt_1 FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
               LET l_i_1 = l_i_1 + 1
            WHEN '5'  #借方異動
              #CALL g9401_axh08(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt                 #FUN-C30098 mark   
              #CALL g9401_axh08(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1               #FUN-C30098 mark
               CALL g9401_axh081(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt    #FUN-C30098 
               CALL g9401_axh081(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1  #FUN-C30098
            WHEN '6'  #貸方異動
              #CALL g9401_axh09(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt                 #FUN-C30098 mark
              #CALL g9401_axh09(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1               #FUN-C30098 mark
               CALL g9401_axh091(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt    #FUN-C30098
               CALL g9401_axh091(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1  #FUN-C30098
         END CASE
         IF cl_null(l_amt)   THEN LET l_amt   = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
         #TQC-C50059--add--str
         IF tmp.giww04 <> '4' THEN
            SELECT SUM(gixx05) INTO l_modamt
              FROM gixx_file,giqq_file
             WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
               AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
               AND gixx01 = giqq01
               AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
            IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
            LET l_amt = l_amt + l_modamt
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02
            LET l_gixx[l_i_1].gixx05 = l_amt
            SELECT SUM(gixx05) INTO l_modamt_1
              FROM gixx_file,giqq_file
             WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
               AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
               AND gixx01 = giqq01
               AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
            LET l_gixx[l_i_1].gixx051 = l_amt_1
            IF cl_null(l_modamt_1) THEN LET l_modamt_1 = 0 END IF
            LET l_amt_1 = l_amt_1 + l_modamt_1
            LET l_i_1 = l_i_1 + 1
         END IF
	 #TQC-C50059--add--end
        #若為減項
         IF tmp.giww03 = '-' THEN
            LET l_amt = l_amt * -1
            LET l_amt_1 = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
     #計算投資活動產生之淨現金
      LET l_sub_amt = l_sub_amt + l_amt_s
      LET l_amt_s = l_amt_s*tm.q/g_unit           #依匯率及單位換算
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")" 
      END IF
      LET l_sub_amt_1 = l_sub_amt_1 + l_amt_s_1
      LET l_amt_s_1 = l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")" 
      END IF
      LET l_flag = 'Y'
      IF tm.t = 'N' THEN 
         INSERT INTO g9401_tmp VALUES (l_type,'',giqq.giqq02,l_str2,giqq.giqq04,'',l_str4)
      ELSE 
      	 FOR l_i_2 = 1 TO l_i_1
            IF cl_null(l_gixx[l_i_2].gixx05) THEN
               LET l_gixx[l_i_2].gixx05 = 0
            END IF
            IF cl_null(l_gixx[l_i_2].gixx051) THEN
               LET l_gixx[l_i_2].gixx051 = 0
            END IF
            IF l_gixx[l_i_2].gixx05 >= 0 THEN
               LET l_str2 = cl_numfor(l_gixx[l_i_2].gixx05,20,tm.e)
            ELSE
               CALL g9401_str(l_gixx[l_i_2].gixx05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
            END IF
            IF l_gixx[l_i_2].gixx051 >= 0 THEN
               LET l_str4 = cl_numfor(l_gixx[l_i_2].gixx051,20,tm.e)
            ELSE
               CALL g9401_str(l_gixx[l_i_2].gixx051,l_str4) RETURNING l_str4
               LET l_str4 = l_str4 CLIPPED,')'
            END IF
            INSERT INTO g9401_tmp VALUES (l_type,l_str1,l_gixx[l_i_2].giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
     	 END FOR
      END IF
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO g9401_tmp VALUES (l_type,'','','',l_giqq04,'','')
   END IF
   
   LET l_type = '4'
   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
   LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   IF l_sub_amt >= 0 THEN
      LET l_str1 =cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL g9401_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   LET l_tot_amt_1 = l_tot_amt_1 + l_sub_amt_1    #計算本期現金淨增數
   LET l_sub_amt_1 = l_sub_amt_1*tm.q/g_unit      #依匯率及單位換算
   IF l_sub_amt_1 >= 0 THEN
      LET l_str3 =cl_numfor(l_sub_amt_1,20,tm.e)
   ELSE
      CALL g9401_str(l_sub_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO g9401_tmp VALUES (l_type,l_str1,'','',l_giqq04,l_str3,'')
   LET l_sub_amt = 0
   LET l_sub_amt_1 = 0
  #=========================理財活動之現金流量=========================# 
  #理財活動之現金流量
   LET l_type = '5'
   LET l_flag = 'N'
   LET l_sql = "SELECT giqq01,giqq02,giqq04 FROM giqq_file "
              ," WHERE giqq03 = '3'"
              ," ORDER BY giqq04,giqq02"
   PREPARE g9401_giqq_p3 FROM l_sql
   DECLARE g9401_giqq_c3 CURSOR FOR g9401_giqq_p3
   LET l_sql= "SELECT aag01,aag02,giww03,giww04 "
             ,"  FROM aag_file,giww_file,giqq_file"
             ," WHERE aag00=giww00 AND aag01=giww02 AND giqq01=giww01 "
             ,"   AND aag00 = '",tm.b,"' "
             ,"   AND giww01 = ? "
             ,"   AND giww05 = '",tm.axa01,"'"
             ,"   AND giww06 = '",tm.axa02,"'"
   PREPARE g9401_giww_p3 FROM l_sql
   DECLARE g9401_giww_c3 CURSOR FOR g9401_giww_p3
   FOREACH g9401_giqq_c3 INTO giqq.*
      LET l_i_1 = 1
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      FOREACH g9401_giww_c3 USING giqq.giqq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0
         CASE tmp.giww04  
            WHEN '1'
              #CALL g9401_axh(tmp.aag01,tm.y2 ,tm.m2) RETURNING l_amt                            #FUN-C30098 mark
              #CALL g9401_axh(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1                          #FUN-C30098 mark
               CALL g9401_axh3(tmp.aag01,tm.y2 ,tm.m2,giqq.giqq01) RETURNING l_amt               #FUN-C30098
               CALL g9401_axh3(tmp.aag01,tm.y21,tm.m2,giqq.giqq01) RETURNING l_amt_1             #FUN-C30098
            WHEN '2'
              #CALL g9401_axh2(tmp.aag01,l_last_y ,l_last_m) RETURNING l_amt                     #FUN-C30098 mark
              #CALL g9401_axh2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1                   #FUN-C30098 mark
               CALL g9401_axh4(tmp.aag01,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt         #FUN-C30098
               CALL g9401_axh4(tmp.aag01,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1       #FUN-C30098
            WHEN '3'
              #CALL g9401_axh2(tmp.aag01,tm.y2 ,tm.m2) RETURNING l_amt                           #FUN-C30098 mark
              #CALL g9401_axh2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1                         #FUN-C30098 mark
               CALL g9401_axh4(tmp.aag01,tm.y2 ,tm.m2,giqq.giqq01) RETURNING l_amt               #FUN-C30098
               CALL g9401_axh4(tmp.aag01,tm.y21,tm.m2,giqq.giqq01) RETURNING l_amt_1             #FUN-C30098
            WHEN '4'
               SELECT SUM(gixx05) INTO l_amt FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               LET l_str_1 = tmp.aag01
               LET l_len = LENGTH(l_str_1)
               LET l_num = 26 - l_len
               LET l_space = l_num spaces
               LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02
               LET l_gixx[l_i_1].gixx05=l_amt
               SELECT SUM(gixx05) INTO l_amt_1 FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
               LET l_i_1 = l_i_1 + 1  
            WHEN '5'  #借方異動
              #CALL g9401_axh08(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt                   #FUN-C30098 mark 
              #CALL g9401_axh08(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1                 #FUN-C30098 mark
               CALL g9401_axh081(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt      #FUN-C30098 
               CALL g9401_axh081(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1    #FUN-C30098
            WHEN '6'  #貸方異動
              #CALL g9401_axh09(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt                   #FUN-C30098 mark
              #CALL g9401_axh09(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1                 #FUN-C30098 mark
               CALL g9401_axh091(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m,giqq.giqq01) RETURNING l_amt      #FUN-C30098 
               CALL g9401_axh091(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m,giqq.giqq01) RETURNING l_amt_1    #FUN-C30098
         END CASE
         IF cl_null(l_amt)   THEN LET l_amt   = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
         #TQC-C50059--add--str
         IF tmp.giww04 <> '4' THEN
            SELECT SUM(gixx05) INTO l_modamt
              FROM gixx_file,giqq_file
             WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
               AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
               AND gixx01 = giqq01
               AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
            IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
            LET l_amt = l_amt + l_modamt
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02
            LET l_gixx[l_i_1].gixx05 = l_amt
            SELECT SUM(gixx05) INTO l_modamt_1
              FROM gixx_file,giqq_file
             WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
               AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
               AND gixx01 = giqq01
               AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
            LET l_gixx[l_i_1].gixx051 = l_amt_1
            IF cl_null(l_modamt_1) THEN LET l_modamt_1 = 0 END IF
            LET l_amt_1 = l_amt_1 + l_modamt_1
            LET l_i_1 = l_i_1 + 1
         END IF
	 #TQC-C50059--add--end
        #若為減項
         IF tmp.giww03 = '-' THEN
            LET l_amt = l_amt * -1
            LET l_amt_1 = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
     #計算理財活動產生之淨現金
      LET l_sub_amt = l_sub_amt + l_amt_s
      LET l_amt_s= l_amt_s*tm.q/g_unit           #依匯率及單位換算
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_sub_amt_1 = l_sub_amt_1 + l_amt_s_1
      LET l_amt_s_1= l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
      IF tm.t = 'N' THEN 
         INSERT INTO g9401_tmp VALUES (l_type,'',giqq.giqq02,l_str2,giqq.giqq04,'',l_str4)
      ELSE 
         FOR l_i_2 = 1 TO l_i_1
            IF cl_null(l_gixx[l_i_2].gixx05) THEN
               LET l_gixx[l_i_2].gixx05 = 0
            END IF
            IF cl_null(l_gixx[l_i_2].gixx051) THEN
               LET l_gixx[l_i_2].gixx051 = 0
            END IF
            IF l_gixx[l_i_2].gixx05 >= 0 THEN
               LET l_str2 = cl_numfor(l_gixx[l_i_2].gixx05,20,tm.e)
            ELSE
               CALL g9401_str(l_gixx[l_i_2].gixx05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
            END IF
            IF l_gixx[l_i_2].gixx051 >= 0 THEN
               LET l_str4 = cl_numfor(l_gixx[l_i_2].gixx051,20,tm.e)
            ELSE
               CALL g9401_str(l_gixx[l_i_2].gixx051,l_str4) RETURNING l_str4
               LET l_str4 = l_str4 CLIPPED,')'
            END IF
            INSERT INTO g9401_tmp VALUES (l_type,l_str1,l_gixx[l_i_2].giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
    	 END FOR     
      END IF
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO g9401_tmp VALUES (l_type,'','','',l_giqq04,'','')
   END IF
   LET l_type = '6'
   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
   LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   IF l_sub_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL g9401_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF

   LET l_tot_amt_1 = l_tot_amt_1 + l_sub_amt_1   #計算本期現金淨增數
   LET l_sub_amt_1 = l_sub_amt_1*tm.q/g_unit     #依匯率及單位換算
   IF l_sub_amt_1 >= 0 THEN
      LET l_str3 = cl_numfor(l_sub_amt_1,20,tm.e)
   ELSE
      CALL g9401_str(l_sub_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO g9401_tmp VALUES (l_type,l_str1,'','',l_giqq04,l_str3,'')

  #=========================本期現金及約當現金增加數=========================#
   LET l_type = '7'
   LET l_flag = 'N'
   LET l_amt = l_tot_amt                  #本期現金淨增數
   LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
   LET l_amt_1 = l_tot_amt_1              #本期現金淨增數
   LET l_amt_1 = l_amt_1*tm.q/g_unit      #依匯率及單位換算
   IF l_amt >=0 THEN
      LET l_str1 = cl_numfor(l_amt,20,tm.e)
   ELSE
      CALL g9401_str(l_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   IF l_amt_1 >=0 THEN
      LET l_str3 = cl_numfor(l_amt_1,20,tm.e)
   ELSE
     #CALL g9401_str(l_amt,l_str3) RETURNING l_str3           #FUN-C30098 mark
      CALL g9401_str(l_amt_1,l_str3) RETURNING l_str3         #FUN-C30098
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO g9401_tmp VALUES (l_type,l_str1,'','',l_giqq04,l_str3,'')

  #=========================期初現金及約當現金餘額=========================#
   LET l_type = '9'
   LET l_flag = 'N'
   INITIALIZE giqq.* TO NULL
  #FUN-C30098--Begin Mark--
  #LET g_sql = " SELECT gizz05 FROM gizz_file"
  #            ," WHERE gizz00 = ? AND gizz01 = ? "
  #            ,"   AND gizz02 = ? AND gizz03 = ? "
  #            ,"   AND gizz04 <  (SELECT MAX(gizz04) FROM gizz_file"
  #            ,"                   WHERE gizz00 = ? AND gizz01 = ?"
  #            ,"                     AND gizz02 = ? AND gizz03 = ? "
  #            ,"                     AND gizz04 = ?)"
  #PREPARE i9401_gizz05_p1 FROM g_sql
  #DECLARE i9401_gizz05_c1 SCROLL CURSOR FOR i9401_gizz05_p1
  #OPEN  i9401_gizz05_c1 USING tm.b,tm.axa01,tm.axa02,l_last_y,tm.b,tm.axa01,tm.axa02,l_last_y,l_last_m
  #FETCH i9401_gizz05_c1 INTO  l_last
  #OPEN  i9401_gizz05_c1 USING tm.b,tm.axa01,tm.axa02,l_last_y1,tm.b,tm.axa01,tm.axa02,l_last_y1,l_last_m
  #FETCH i9401_gizz05_c1 INTO  l_last_1
  #IF cl_null(l_last)   THEN LET l_last   = 0 END IF
  #IF cl_null(l_last_1) THEN LET l_last_1 = 0 END IF
  #FUN-C30098---End Mark---
   
   LET l_sql = "SELECT giqq01,giqq02,giqq04 FROM giqq_file "
              ," WHERE giqq03 = '4'"
              ," ORDER BY giqq04,giqq02"
   PREPARE g9401_giqq_p4 FROM l_sql
   DECLARE g9401_giqq_c4 CURSOR FOR g9401_giqq_p4
   LET l_sql= "SELECT aag01,aag02,giww03,giww04 "
             ,"  FROM aag_file,giww_file,giqq_file"
             ," WHERE aag00 = giww00 AND aag01 = giww02 AND giqq01 = giww01 "
             ,"   AND aag00 = '",tm.b,"' "
             ,"   AND giww01 = ?"
             ,"   AND giww05 = '",tm.axa01,"'"
             ,"   AND giww06 = '",tm.axa02,"'"
   PREPARE g9401_giww_p4 FROM l_sql
   DECLARE g9401_giww_c4 CURSOR FOR g9401_giww_p4
   FOREACH g9401_giqq_c4 INTO giqq.*
      LET l_i_1 = 1
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      FOREACH g9401_giww_c4 USING giqq.giqq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0
        #FUN-C30098--Begin--
         LET g_sql = " SELECT gizz05 FROM gizz_file"
                    ," WHERE gizz00 = ? AND gizz01 = ? AND gizz02 = ? AND gizz03 = ? "
                    ,"   AND gizz06 = ? AND gizz07 = ? AND gizz04 = ? "
         PREPARE i9401_gizz05_p1 FROM g_sql
         DECLARE i9401_gizz05_c1 SCROLL CURSOR FOR i9401_gizz05_p1
         IF tm.m1 = 1 THEN
            SELECT COUNT(*) INTO l_n FROM gizz_file
             WHERE gizz00 = tm.b AND gizz03 = tm.y1 AND gizz04 = 0
               AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = giqq.giqq01
            SELECT COUNT(*) INTO l_n1 FROM gizz_file
             WHERE gizz00 = tm.b AND gizz03 = tm.y11 AND gizz04 = 0
               AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = giqq.giqq01
            IF cl_null(l_n)  THEN LET l_n  = 0 END IF
            IF cl_null(l_n1) THEN LET l_n1 = 0 END IF
            IF l_n > 0 THEN
               OPEN  i9401_gizz05_c1 USING tm.b,tm.axa01,tm.axa02,tm.y1,tmp.aag01,giqq.giqq01,'0'
               FETCH i9401_gizz05_c1 INTO  l_amt
            END IF
            IF l_n1 > 0 THEN
               OPEN  i9401_gizz05_c1 USING tm.b,tm.axa01,tm.axa02,tm.y11,tmp.aag01,giqq.giqq01,'0'
               FETCH i9401_gizz05_c1 INTO  l_amt_1
            END IF
         ELSE
            SELECT COUNT(*) INTO l_n FROM gizz_file
             WHERE gizz00 = tm.b AND gizz03 = l_last_y AND gizz04 = l_last_m
               AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = giqq.giqq01
            SELECT COUNT(*) INTO l_n1 FROM gizz_file                                     #CHI-C40004 l_n-->l_n1
             WHERE gizz00 = tm.b AND gizz03 = l_last_y1 AND gizz04 = l_last_m
               AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = giqq.giqq01
            IF cl_null(l_n)  THEN LET l_n  = 0 END IF
            IF cl_null(l_n1) THEN LET l_n1 = 0 END IF
            IF l_n > 0 THEN
               OPEN  i9401_gizz05_c1 USING tm.b,tm.axa01,tm.axa02,l_last_y,tmp.aag01,giqq.giqq01,l_last_m
               FETCH i9401_gizz05_c1 INTO  l_amt
            END IF
            IF l_n1 > 0 THEN
               OPEN  i9401_gizz05_c1 USING tm.b,tm.axa01,tm.axa02,l_last_y1,tmp.aag01,giqq.giqq01,l_last_m
               FETCH i9401_gizz05_c1 INTO  l_amt_1
            END IF
         END IF
        #FUN-C30098---End---
         CASE tmp.giww04
            WHEN '1'
              #IF l_last = 0 THEN        #FUN-C30098 mark
               IF l_n = 0 THEN           #FUN-C30098
                  CALL g9401_axh(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               END IF
              #IF l_last_1 = 0 THEN      #FUN-C30098 mark
               IF l_n1 = 0 THEN          #FUN-C30098
                  CALL g9401_axh(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
               END IF
            WHEN '2'
              #IF l_last = 0 THEN        #FUN-C30098 mark
               IF l_n = 0 THEN           #FUN-C30098
                  CALL g9401_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               END IF
              #IF l_last_1 = 0 THEN      #FUN-C30098 mark
               IF l_n1 = 0 THEN          #FUN-C30098
                  CALL g9401_axh2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1
               END IF
            WHEN '3'
              #IF l_last = 0 THEN        #FUN-C30098 mark
               IF l_n = 0 THEN           #FUN-C30098
                  CALL g9401_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               END IF
              #IF l_last_1 = 0 THEN      #FUN-C30098 mark
               IF l_n1 = 0 THEN          #FUN-C30098
                  CALL g9401_axh2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
               END IF
            WHEN '4'
               LET l_str_1 = tmp.aag01
               LET l_len = LENGTH(l_str_1)
               LET l_num = 26 - l_len
               LET l_space = l_num spaces
               LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02
               IF l_last = 0 THEN
                  SELECT SUM(gixx05) INTO l_amt FROM gixx_file,giqq_file
                   WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                     AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
                     AND gixx01 = giqq01
                     AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
                  LET l_gixx[l_i_1].gixx05=l_amt
               END IF
               IF l_last_1 = 0 THEN
                  SELECT SUM(gixx05) INTO l_amt_1 FROM gixx_file,giqq_file
                      WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                     AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
                     AND gixx01 = giqq01
                     AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
                  LET l_gixx[l_i_1].gixx051=l_amt_1
               END IF
               LET l_i_1 = l_i_1 + 1
            WHEN '5'  #借方異動
              #IF l_last = 0 THEN        #FUN-C30098 mark
               IF l_n = 0 THEN           #FUN-C30098
                  CALL g9401_axh08(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt 
               END IF
              #IF l_last_1 = 0 THEN      #FUN-C30098 mark
               IF l_n1 = 0 THEN          #FUN-C30098
                  CALL g9401_axh08(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1
               END IF
            WHEN '6'  #貸方異動
              #IF l_last = 0 THEN        #FUN-C30098 mark
               IF l_n = 0 THEN           #FUN-C30098
                  CALL g9401_axh09(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt   
               END IF
              #IF l_last_1 = 0 THEN      #FUN-C30098 mark
               IF l_n1 = 0 THEN          #FUN-C30098
                  CALL g9401_axh09(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1
               END IF
         END CASE
         IF cl_null(l_amt)   THEN LET l_amt   = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
         #若為減項
         IF tmp.giww03 = '-' THEN 
            LET l_amt = l_amt * -1
            LET l_amt_1 = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_amt_s= l_amt_s*tm.q/g_unit        #依匯率及單位換算
      LET l_this = l_this + l_amt_s
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_amt_s_1= l_amt_s_1*tm.q/g_unit    #依匯率及單位換算
      LET l_this_1 = l_this_1 + l_amt_s_1
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
      IF l_last <> 0 THEN LET l_this = l_last END IF
      IF l_last_1 <> 0 THEN LET l_this_1 = l_last_1 END IF
      IF l_this >= 0 THEN 
         LET l_str1 = cl_numfor(l_this,20,tm.e)     
      END IF
      IF l_this_1 >= 0 THEN 
         LET l_str3 = cl_numfor(l_this_1,20,tm.e)   
      END IF
     #IF tm.t = 'N' THEN #TQC-C50139 mark
         INSERT INTO g9401_tmp VALUES (l_type,l_str1,giqq.giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
     #TQC-C50139--mark--str
     #ELSE
     #   FOR l_i_2 = 1 TO l_i_1
     #      IF cl_null(l_gixx[l_i_2].gixx05) THEN
     #         LET l_gixx[l_i_2].gixx05 = 0
     #      END IF
     #      IF cl_null(l_gixx[l_i_2].gixx051) THEN
     #         LET l_gixx[l_i_2].gixx051 = 0
     #      END IF
     #      IF l_gixx[l_i_2].gixx05 >= 0 THEN
     #         LET l_str2 = cl_numfor(l_gixx[l_i_2].gixx05,20,tm.e)
     #      ELSE
     #         CALL g9401_str(l_gixx[l_i_2].gixx05,l_str2) RETURNING l_str2
     #         LET l_str2 = l_str2 CLIPPED,')'
     #      END IF
     #      IF l_gixx[l_i_2].gixx051 >= 0 THEN
     #         LET l_str4 = cl_numfor(l_gixx[l_i_2].gixx051,20,tm.e)
     #      ELSE
     #         CALL g9401_str(l_gixx[l_i_2].gixx051,l_str4) RETURNING l_str4
     #         LET l_str4 = l_str4 CLIPPED,')'
     #      END IF
     #      INSERT INTO g9401_tmp VALUES (l_type,l_str1,l_gixx[l_i_2].giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
     #   END FOR     
     #END IF 
     #TQC-C50139--mark--end
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO g9401_tmp VALUES (l_type,'0','','',l_giqq04,'0','')
   END IF
  #=========================期末現金及約當現金餘額=========================#
   LET l_type ='A'
   LET l_flag = 'N'
   INITIALIZE giqq.* TO NULL
   LET l_sql = "SELECT giqq01,giqq02,giqq04 FROM giqq_file "
              ," WHERE giqq03 = '5'"
              ," ORDER BY giqq04,giqq02"
   PREPARE g9401_giqq_p5 FROM l_sql
   DECLARE g9401_giqq_c5 CURSOR FOR g9401_giqq_p5
   LET l_sql= "SELECT aag01,aag02,giww03,giww04 "
             ,"  FROM aag_file,giww_file,giqq_file"
             ," WHERE aag00=giww00 AND aag01=giww02 AND giqq01=giww01 "
             ,"   AND aag00 = '",tm.b,"' "
             ,"   AND giww01 = ?"
             ,"   AND giww05 = '",tm.axa01,"'"
             ,"   AND giww06 = '",tm.axa02,"'"
   PREPARE g9401_giww_p5 FROM l_sql
   DECLARE g9401_giww_c5 CURSOR FOR g9401_giww_p5
   FOREACH g9401_giqq_c5 INTO giqq.*
      LET l_i_1 = 1
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      FOREACH g9401_giww_c5 USING giqq.giqq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0      
         CASE tmp.giww04 
            WHEN '1'
               CALL g9401_axh(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               CALL g9401_axh(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
            WHEN '2'
               CALL g9401_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               CALL g9401_axh2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1
            WHEN '3'
               CALL g9401_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               CALL g9401_axh2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
            WHEN '4'
               SELECT SUM(gixx05) INTO l_amt FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y1 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               LET l_str_1 = tmp.aag01
               LET l_len = LENGTH(l_str_1)
               LET l_num = 26 - l_len
               LET l_space = l_num spaces
               LET l_gixx[l_i_1].giqq02 = tmp.aag01||l_space||tmp.aag02    
               LET l_gixx[l_i_1].gixx05=l_amt 
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gixx05) INTO l_amt_1 FROM gixx_file,giqq_file
                WHERE gixx01 = giqq.giqq01 AND gixx02 = tmp.aag01
                  AND gixx06 = tm.y11 AND gixx07 BETWEEN tm.m1 AND tm.m2
                  AND gixx01 = giqq01
                  AND gixx00 = tm.b AND gixx08 = tm.axa01 AND gixx09 = tm.axa02
               IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
               LET l_i_1 = l_i_1 + 1  
            WHEN '5'  #借方異動
               CALL g9401_axh08(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt 
               CALL g9401_axh08(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1
            WHEN '6'  #貸方異動
               CALL g9401_axh09(tmp.aag01,tm.y1 ,tm.m2,l_last_y ,l_last_m) RETURNING l_amt   
               CALL g9401_axh09(tmp.aag01,tm.y11,tm.m2,l_last_y1,l_last_m) RETURNING l_amt_1
         END CASE
         IF cl_null(l_amt)   THEN LET l_amt   = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
        #若為減項
         IF tmp.giww03 = '-' THEN
            LET l_amt = l_amt * -1
            LET l_amt_1 = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_amt_s= l_amt_s*tm.q/g_unit            #依匯率及單位換算
      LET l_last = l_last + l_amt_s
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_amt_s_1= l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      LET l_last_1 = l_last_1 + l_amt_s_1
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL g9401_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")"
      END IF
      IF l_last >= 0 THEN 
         #LET l_str1 = cl_numfor(l_this,20,tm.e)    #TQC-C50218  mark
         LET l_str1 = cl_numfor(l_last,20,tm.e)     #TQC-C50218  add 
      END IF
      IF l_last_1 >= 0 THEN 
         #LET l_str3 = cl_numfor(l_this_1,20,tm.e)  #TQC-C50218  mark
         LET l_str3 = cl_numfor(l_last_1,20,tm.e)   #TQC-C50218  add
      END IF
      
      LET l_flag = 'Y'
     #IF tm.t = 'N' THEN #TQC-C50139 mark
         INSERT INTO g9401_tmp VALUES (l_type,l_str1,giqq.giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
     #TQC-C50139--mark--str
     #ELSE 
     #	 FOR l_i_2 = 1 TO l_i_1
     #      IF cl_null(l_gixx[l_i_2].gixx05) THEN
     #         LET l_gixx[l_i_2].gixx05 = 0
     #      END IF
     #      IF cl_null(l_gixx[l_i_2].gixx051) THEN
     #         LET l_gixx[l_i_2].gixx051 = 0
     #      END IF
     #      IF l_gixx[l_i_2].gixx05 >= 0 THEN
     #         LET l_str2 = cl_numfor(l_gixx[l_i_2].gixx05,20,tm.e)
     #      ELSE
     #         CALL g9401_str(l_gixx[l_i_2].gixx05,l_str2) RETURNING l_str2
     #         LET l_str2 = l_str2 CLIPPED,')'
     #      END IF
     #      IF l_gixx[l_i_2].gixx051 >= 0 THEN
     #         LET l_str4 = cl_numfor(l_gixx[l_i_2].gixx051,20,tm.e)
     #      ELSE
     #         CALL g9401_str(l_gixx[l_i_2].gixx051,l_str4) RETURNING l_str4
     #         LET l_str4 = l_str4 CLIPPED,')'
     #      END IF
     #      INSERT INTO g9401_tmp VALUES (l_type,l_str1,l_gixx[l_i_2].giqq02,l_str2,giqq.giqq04,l_str3,l_str4)
     #   END FOR     
     #END IF
     #TQC-C50139--mark--end
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO g9401_tmp VALUES (l_type,'0','','',l_giqq04,'0','')
   END IF
  #=========================匯率變動對現金及約當現金之影響=========================#
   LET l_type = '8'
   LET l_flag = 'N'
   LET l_str1 = cl_numfor(l_str1,20,tm.e)
   LET l_str3 = cl_numfor(l_str3,20,tm.e)
  #IF l_last != l_this  + l_amt THEN                   #FUN-C30098 mark
  #   LET l_diff = l_last - (l_this  + l_amt)          #FUN-C30098 mark
   LET l_diff = 0      #TQC-C50218   add
   IF l_last != (l_this + l_tot_amt) THEN              #FUN-C30098
      LET l_diff = l_last - (l_this + l_tot_amt )      #FUN-C30098
   END IF    #TQC-C50218   add
     #FUN-C30098--Begin--
     #LET l_str1 =  cl_numfor(l_diff,20,tm.e)
      IF l_diff >= 0 THEN
         LET l_str1 =  cl_numfor(l_diff,20,tm.e)
      ELSE
         CALL g9401_str(l_diff,l_str1) RETURNING l_str1
         LET l_str1 = l_str1 CLIPPED,")"
      END IF 
     #FUN-C30098---End---
   #END IF      #TQC-C50218   mark
   LET l_diff_1 = 0     #TQC-C50218   add
  #IF l_last_1 != l_this_1  + l_amt_1 THEN                #FUN-C30098 mark
  #   LET l_diff_1 = l_last_1 - (l_this_1  + l_amt_1)     #FUN-C30098 mark
   IF l_last_1 != (l_this_1 + l_tot_amt_1 )THEN           #FUN-C30098
      LET l_diff_1 = l_last_1 - (l_this_1 + l_tot_amt_1)  #FUN-C30098
   END IF   #TQC-C50218   add
     #FUN-C30098--Begin--
     #LET l_str3 =  cl_numfor(l_diff_1,20,tm.e)
      IF l_diff_1 >= 0 THEN
         LET l_str3 =  cl_numfor(l_diff_1,20,tm.e)
      ELSE
         CALL g9401_str(l_diff_1,l_str3) RETURNING l_str3
         LET l_str3 = l_str3 CLIPPED,")"
      END IF 
     #FUN-C30098---End---
   #END IF    #TQC-C50218   mark
   INSERT INTO g9401_tmp VALUES (l_type,l_str1,'','',l_giqq04,l_str3,'')
   
   #=========================揭露事項=========================#
   IF tm.s = 'Y' THEN
      LET l_type = 'B'
      LET l_flag = 'N'
      LET g_cnt = 1
      DECLARE g9401_giyy CURSOR FOR
         SELECT giyy01,giyy02,giyy03 FROM giyy_file
          WHERE giyy06 = tm.axa01 AND giyy07 = tm.axa02
            AND giyy04 = tm.y1 AND giyy05 BETWEEN tm.m1 AND tm.m2
          ORDER BY giyy04,giyy05,giyy01
      FOREACH g9401_giyy INTO g_giyy[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
         END IF
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_cnt = g_cnt - 1
      FOR i = 1 TO g_cnt
         LET l_str2 = cl_numfor(g_giyy[i].giyy03,20,tm.e)
         LET l_str4 = cl_numfor(g_giyy[i].giyy03,20,tm.e)
         LET l_flag = 'Y'
         INSERT INTO g9401_tmp VALUES (l_type,'',g_giyy[i].giyy02,l_str2,g_giyy[i].giyy01,'',l_str4)
      END FOR
      IF l_flag = 'N' THEN
         INSERT INTO g9401_tmp VALUES (l_type,'','','',l_giqq04,'','')
      END IF
   END IF
  #FUN-C30098--
  #IF cl_null(l_last) THEN LET l_last = 0 END IF
  #IF cl_null(l_last_1) THEN LET l_last_1 = 0 END IF
  #IF l_last = 0 THEN
  #   SELECT SUM(str2) INTO l_last  FROM r940_tmp WHERE l_type ='8'
  #END IF
  #IF l_last_1 = 0 THEN
  #   SELECT SUM(str4) INTO l_last_1  FROM r940_tmp WHERE l_type ='8'
  #END IF
  #FUN-C30098--

   LET l_flag = 'N'
   LET l_flag1= 'N'				 #FUN-C30098
   LET l_sql = " SELECT * FROM g9401_tmp "
              ," ORDER BY type,giqq04,giqq02 "
   PREPARE g9401_p1 FROM l_sql
   DECLARE g9401_c1 CURSOR FOR g9401_p1
   FOREACH g9401_c1 INTO tmp1.*
      CASE tmp1.type
         WHEN '9'
           #FUN-C30098--
            SELECT SUM(str2) INTO l_last   FROM g9401_tmp WHERE l_type ='9'
            SELECT SUM(str4) INTO l_last_1 FROM g9401_tmp WHERE l_type ='9'
            IF cl_null(l_last) THEN LET l_last = 0 END IF
            IF cl_null(l_last_1) THEN LET l_last_1 = 0 END IF
           #FUN-C30098--
            IF l_last >=0 THEN
               LET tmp1.str1 = cl_numfor(l_last,20,tm.e)
            ELSE
               CALL g9401_str(l_last,tmp1.str1) RETURNING tmp1.str1
               LET tmp1.str1 = tmp1.str1 CLIPPED,')'                   #FUN-C40004 mod
            END IF
            IF l_last_1 >=0 THEN
               LET tmp1.str3 = cl_numfor(l_last_1,20,tm.e)
            ELSE
               CALL g9401_str(l_last_1,tmp1.str3) RETURNING tmp1.str3
               LET tmp1.str3 = tmp1.str3 CLIPPED,')'                   #FUN-C40004 mod
            END IF
         WHEN 'A'
           #FUN-C30098--
           #SELECT SUM(str2) INTO l_amt   FROM g9401_tmp WHERE l_type ='9'
           #SELECT SUM(str4) INTO l_amt_1 FROM g9401_tmp WHERE l_type ='9'
           #FUN-C30098--
            SELECT SUM(str2) INTO l_amt   FROM g9401_tmp WHERE l_type ='A'  #FUN-C30098
            SELECT SUM(str4) INTO l_amt_1 FROM g9401_tmp WHERE l_type ='A'  #FUN-C30098
            IF cl_null(l_amt) THEN LET l_amt = 0 END IF
            IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
            IF l_amt >=0 THEN
               LET tmp1.str1 = cl_numfor(l_amt,20,tm.e)
            ELSE
               CALL g9401_str(l_amt,tmp1.str1) RETURNING tmp1.str1
               LET tmp1.str1 = tmp1.str1 CLIPPED,')'                   #FUN-C40004 mod
            END IF
            IF l_amt_1 >=0 THEN
               LET tmp1.str3 = cl_numfor(l_amt_1,20,tm.e)
            ELSE
               CALL g9401_str(l_amt_1,tmp1.str3) RETURNING tmp1.str3
               LET tmp1.str3 = tmp1.str3 CLIPPED,')'                   #FUN-C40004 mod
            END IF
      END CASE
     #IF (tmp1.type = 'A') THEN                           #FUN-C30098 mark
     #   IF (l_flag = 'N') THEN                           #FUN-C30098 mark
      IF (tmp1.type = '9' OR tmp1.type = 'A') THEN        #FUN-C30098
         IF (tmp1.type = '9' AND l_flag = 'N') THEN    #FUN-C30098
            LET l_flag = 'Y'
           #EXECUTE insert_prep USING tmp1.type,tmp1.str1,tmp1.giqq02,tmp1.str2,tmp1.giqq04,tmp1.str3,tmp1.str4   #FUN-C30098
            EXECUTE insert_prep USING tmp1.type,tmp1.str2,'','','0',tmp1.str4,''                                  #FUN-C30098
         END IF
        #FUN-C30098--
         IF (tmp1.type = 'A' AND l_flag1= 'N') THEN
            LET l_flag1= 'Y'
            EXECUTE insert_prep USING tmp1.type,tmp1.str2,'','','0',tmp1.str4,''
         END IF
        #FUN-C30098--
      ELSE
         EXECUTE insert_prep USING tmp1.type,tmp1.str1,tmp1.giqq02,tmp1.str2,tmp1.giqq04,tmp1.str3,tmp1.str4
      END IF
   END FOREACH
  #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                           #FUN-C30098 mark
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY type,giqq04"   #FUN-C30098
   LET g_str = ''
###GENGRE###   LET g_str = tm.d,";",tm.title,";",tm.p,";","",";",tm.y1,";",tm.m1,";",
###GENGRE###               l_d1,";",tm.y2,";",tm.m2,";",l_d2
###GENGRE###   CALL cl_prt_cs3('aglg9401','aglg9401',g_sql,g_str)
   CALL aglg9401_grdata()    ###GENGRE###
        
END FUNCTION

FUNCTION g9401_axh(p_axh05,p_axh06,p_axh07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          l_axh08     LIKE axh_file.axh08, 
          l_axh081    LIKE axh_file.axh08,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07  
   DEFINE l_type      LIKE aag_file.aag06   
   DEFINE l_sql       LIKE type_file.chr1000
   DEFINE l_n         LIKE type_file.num10        #CHI-C40004

   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_axh05
                                            AND aag00= tm.b 
   LET l_axh08 = 0
   LET l_axh081 = 0
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF
     #FUN-C30098--
     #LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"           #FUN-C30098 mark
      IF l_type = '1' THEN
         LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"
      ELSE
         LET l_sql = " SELECT SUM(axh09-axh08) FROM axh_file"
      END IF
      LET l_sql = l_sql CLIPPED
     #FUN-C30098--
                 ,"  WHERE axh00 = '",tm.b,"'"
                 ,"    AND axh01 = '",tm.axa01,"'"
                 ,"    AND axh02 = '",tm.axa02,"'"
                 ,"    AND axh05 = '",p_axh05,"'"
                 ,"    AND axh06 = '",l_axh06,"'"
                 ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
                 ,"                  WHERE axh00 = '",g_aaz641,"'"
                 ,"                    AND axh01 = '",tm.axa01,"'"
                 ,"                    AND axh02 = '",tm.axa02,"'"
                 ,"                    AND axh05 = '",p_axh05,"'"
                 ,"                    AND axh06 = '",l_axh06,"'"
                 ,"                    AND axh07 <= '",l_axh07,"')"
      PREPARE i9401_axh_p1 FROM l_sql
      DECLARE i9401_axh_c1 SCROLL CURSOR FOR i9401_axh_p1
      OPEN i9401_axh_c1
      FETCH i9401_axh_c1 INTO l_axh081

   IF l_type = '1' THEN
      SELECT SUM(axh08-axh09) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = tm.m2
   ELSE
      SELECT SUM(axh09-axh08) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = tm.m2
   END IF
   IF cl_null(l_axh08) THEN LET l_axh08 = 0 END IF
   IF cl_null(l_axh081) THEN LET l_axh081 = 0 END IF
   LET l_axh08 = l_axh08 - l_axh081
   RETURN l_axh08
END FUNCTION

FUNCTION g9401_axh2(p_axh05,p_axh06,p_axh07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          l_axh08     LIKE axh_file.axh08, 
          l_axh081    LIKE axh_file.axh08,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07  
   DEFINE l_type      LIKE aag_file.aag06   
   DEFINE l_sql       LIKE type_file.chr1000

   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_axh05
                                            AND aag00=tm.b  

   LET l_axh08 = 0
   LET l_axh081 = 0
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF              
  #FUN-C30098--
  #LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"           #FUN-C30098 mark
   IF l_type = '1' THEN
      LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"
   ELSE
      LET l_sql = " SELECT SUM(axh09-axh08) FROM axh_file"
   END IF
   LET l_sql = l_sql CLIPPED
  #FUN-C30098--
              ,"  WHERE axh00 = '",tm.b,"'"
              ,"    AND axh01 = '",tm.axa01,"'"
              ,"    AND axh02 = '",tm.axa02,"'"
              ,"    AND axh05 = '",p_axh05,"'"
              ,"    AND axh06 = '",l_axh06,"'"
              ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
              ,"                  WHERE axh00 = '",g_aaz641,"'"
              ,"                    AND axh01 = '",tm.axa01,"'"
              ,"                    AND axh02 = '",tm.axa02,"'"
              ,"                    AND axh05 = '",p_axh05,"'"
              ,"                    AND axh06 = '",l_axh06,"'"
              ,"                    AND axh07 <= '",l_axh07,"')"
   PREPARE i9401_axh2_p1 FROM l_sql
   DECLARE i9401_axh2_c1 SCROLL CURSOR FOR i9401_axh2_p1
   OPEN i9401_axh2_c1
   FETCH i9401_axh2_c1 INTO l_axh08

   IF l_type = '1' THEN
      SELECT SUM(axh08-axh09) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = p_axh07
   ELSE
      SELECT SUM(axh09-axh08) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = p_axh07
   END IF
   IF cl_null(l_axh08) THEN LET l_axh08 = 0 END IF
   IF cl_null(l_axh081) THEN LET l_axh081 = 0 END IF
   LET l_axh08 = l_axh08 - l_axh081
   RETURN l_axh08
END FUNCTION
FUNCTION g9401_axh08(p_axh05,p_axh06,p_axh07,p_axh061,p_axh071)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_axh08     LIKE axh_file.axh08,
          p_axh061    LIKE axh_file.axh06,
          p_axh071    LIKE axh_file.axh07,
          p_axh081    LIKE axh_file.axh08
   DEFINE l_sql       LIKE type_file.chr1000
   LET p_axh08  = 0          #借方科餘
   LET l_sql = " SELECT axh08 FROM axh_file"
              ,"  WHERE axh00 = '",g_aaz641,"'"
              ,"    AND axh01 = '",tm.axa01,"'"
              ,"    AND axh02 = '",tm.axa02,"'"
              ,"    AND axh05 = '",p_axh05,"'"
              ,"    AND axh06 = '",p_axh061,"'"
              ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
              ,"                  WHERE axh00 = '",g_aaz641,"'"
              ,"                    AND axh01 = '",tm.axa01,"'"
              ,"                    AND axh02 = '",tm.axa02,"'"
              ,"                    AND axh05 = '",p_axh05,"'"
              ,"                    AND axh06 = '",p_axh061,"'"
  #如果是上期是12月,用<會取不到12月的值
   IF p_axh07=12 THEN
      LET l_sql = l_sql," AND axh07 <= '",p_axh071,"')"
   ELSE
      LET l_sql = l_sql," AND axh07 < '",p_axh071,"')"
   END IF
   PREPARE i9401_axh08_p1 FROM l_sql
   DECLARE i9401_axh08_c1 SCROLL CURSOR FOR i9401_axh08_p1
   OPEN i9401_axh08_c1
   FETCH i9401_axh08_c1 INTO p_axh081
   
   SELECT SUM(axh08) INTO p_axh08 FROM axh_file
    WHERE axh00 = tm.b    AND axh05 = p_axh05
      AND axh06 = p_axh06 AND axh07 = p_axh07
   IF cl_null(p_axh08) THEN LET p_axh08 = 0 END IF
   IF cl_null(p_axh081) THEN LET p_axh081 = 0 END IF
   LET p_axh08 = p_axh08 - p_axh081
   RETURN p_axh08
   CLOSE i9401_axh08_c1
END FUNCTION

FUNCTION g9401_axh09(p_axh05,p_axh06,p_axh07,p_axh061,p_axh071)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_axh09     LIKE axh_file.axh09,
          p_axh061    LIKE axh_file.axh06,
          p_axh071    LIKE axh_file.axh07,
          p_axh091    LIKE axh_file.axh09
   DEFINE l_sql       LIKE type_file.chr1000
          
   LET p_axh09  = 0          #貸方科餘
   LET l_sql = " SELECT axh09 FROM axh_file"
              ,"  WHERE axh00 = '",g_aaz641,"'"
              ,"    AND axh01 = '",tm.axa01,"'"
              ,"    AND axh02 = '",tm.axa02,"'"
              ,"    AND axh05 = '",p_axh05,"'"
              ,"    AND axh06 = '",p_axh061,"'"
              ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
              ,"                  WHERE axh00 = '",g_aaz641,"'"
              ,"                    AND axh01 = '",tm.axa01,"'"
              ,"                    AND axh02 = '",tm.axa02,"'"
              ,"                    AND axh05 = '",p_axh05,"'"
              ,"                    AND axh06 = '",p_axh061,"'"
  #如果是上期是12月,用<會取不到12月的值
   IF p_axh07=12 THEN
      LET l_sql = l_sql," AND axh07 <= '",p_axh071,"')"
   ELSE
      LET l_sql = l_sql," AND axh07 < '",p_axh071,"')"
   END IF
   PREPARE i9401_axh09_p1 FROM l_sql
   DECLARE i9401_axh09_c1 SCROLL CURSOR FOR i9401_axh09_p1
   OPEN i9401_axh09_c1
   FETCH i9401_axh09_c1 INTO p_axh091
   
   SELECT SUM(axh09) INTO p_axh09 FROM axh_file
    WHERE axh00 = tm.b    AND axh05 = p_axh05
      AND axh06 = p_axh06 AND axh07 = p_axh07
   IF cl_null(p_axh09)  THEN LET p_axh09 = 0 END IF
   IF cl_null(p_axh091) THEN LET p_axh091 = 0 END IF
   LET p_axh09 = p_axh09 - p_axh091
   RETURN p_axh09
   CLOSE i9401_axh09_c1
END FUNCTION
FUNCTION g9401_str(p_amt,p_str)
   DEFINE p_amt LIKE type_file.num20_6,   
          p_str LIKE type_file.chr1000,  
          l_x   LIKE type_file.num5  

   LET p_str = cl_numfor(p_amt*(-1),20,tm.e)
   FOR l_x = 1 TO 20
       IF cl_null(p_str[l_x,l_x]) THEN
           LET l_x = l_x - 1
           EXIT FOR
       END IF
   END FOR
   IF l_x != 0 THEN
      LET p_str[l_x,l_x] = '('
   ELSE
      LET p_str[1,1] = '('
   END IF

   RETURN p_str

END FUNCTION
FUNCTION g9401_set_entry()
   CALL cl_set_comp_entry("q1,m1,h1,q2,m2,h2",TRUE)
END FUNCTION
FUNCTION g9401_set_no_entry()
   IF tm.axa06 ="1" THEN  #月
      CALL cl_set_comp_entry("q1,h1,q2,h2",FALSE)  
   END IF
   IF tm.axa06 ="2" THEN  #季
      CALL cl_set_comp_entry("m1,h1,m2,h2",FALSE)
   END IF
   IF tm.axa06 ="3" THEN  #半年
      CALL cl_set_comp_entry("m1,q1,m2,q2",FALSE)
   END IF
   IF tm.axa06 ="4" THEN  #年
      CALL cl_set_comp_entry("q1,m1,h1,q2,m2,g2",FALSE)
   END IF
END FUNCTION


FUNCTION g9401_create_temp_table()
   DROP TABLE g9401_tmp
   CREATE TEMP TABLE g9401_tmp(
   type   LIKE type_file.chr1,
   str1   LIKE type_file.chr50,
   giqq02 LIKE type_file.chr1000,
   str2   LIKE type_file.chr50,
   giqq04 LIKE giqq_file.giqq04,
   str3   LIKE type_file.chr50,
   str4   LIKE type_file.chr50)
END FUNCTION

#FUN-C30098--Begin--
FUNCTION g9401_axh3(p_axh05,p_axh06,p_axh07,p_gizz07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_gizz07    LIKE gizz_file.gizz07,
          l_axh08     LIKE axh_file.axh08, 
          l_axh081    LIKE axh_file.axh08,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07  
   DEFINE l_type      LIKE aag_file.aag06   
   DEFINE l_sql       LIKE type_file.chr1000
   DEFINE l_n         LIKE type_file.num10

   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_axh05
                                            AND aag00= tm.b 
   LET l_axh08 = 0
   LET l_axh081 = 0
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF                      
   LET l_n = 0
   IF tm.m1 = 1 THEN
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = p_axh06  AND gizz04 = 0               #CHI-C40004 gizz00-->gizz06 
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   ELSE
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = l_axh06  AND gizz04 = l_axh07         #CHI-C40004 gizz00-->gizz06
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   END IF
   IF l_n > 0 THEN
      LET l_sql = " SELECT gizz05 FROM gizz_file"
                 ,"  WHERE gizz06 = '",p_axh05 ,"'"                               #CHI-C40004 gizz00-->gizz06
                 ,"    AND gizz01 = '",tm.axa01,"' AND gizz02 = '",tm.axa02,"'"   #CHI-C40004
                 ,"    AND gizz07 = '",p_gizz07,"'"                               #CHI-C40004
      IF tm.m1 = 1 THEN
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",p_axh06," AND gizz04 = 0"
      ELSE
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",l_axh06," AND gizz04 = ",l_axh07
      END IF
      PREPARE i9401_axh_p4 FROM l_sql
      DECLARE i9401_axh_c4 SCROLL CURSOR FOR i9401_axh_p4
      OPEN i9401_axh_c4
      FETCH i9401_axh_c4 INTO l_axh081
   ELSE
      IF l_type = '1' THEN
         LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"
      ELSE
         LET l_sql = " SELECT SUM(axh09-axh08) FROM axh_file"
      END IF
      LET l_sql = l_sql CLIPPED
                 ,"  WHERE axh00 = '",tm.b,"'"
                 ,"    AND axh01 = '",tm.axa01,"'"
                 ,"    AND axh02 = '",tm.axa02,"'"
                 ,"    AND axh05 = '",p_axh05,"'"
                 ,"    AND axh06 = '",l_axh06,"'"
                 ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
                 ,"                  WHERE axh00 = '",g_aaz641,"'"
                 ,"                    AND axh01 = '",tm.axa01,"'"
                 ,"                    AND axh02 = '",tm.axa02,"'"
                 ,"                    AND axh05 = '",p_axh05,"'"
                 ,"                    AND axh06 = '",l_axh06,"'"
                 ,"                    AND axh07 <= '",l_axh07,"')"
      PREPARE i9401_axh_p3 FROM l_sql
      DECLARE i9401_axh_c3 SCROLL CURSOR FOR i9401_axh_p3
      OPEN i9401_axh_c3
      FETCH i9401_axh_c3 INTO l_axh081
   END IF
   IF l_type = '1' THEN
      SELECT SUM(axh08-axh09) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = tm.m2
   ELSE
      SELECT SUM(axh09-axh08) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = tm.m2
   END IF
   IF cl_null(l_axh08) THEN LET l_axh08 = 0 END IF
   IF cl_null(l_axh081) THEN LET l_axh081 = 0 END IF
   LET l_axh08 = l_axh08 - l_axh081
   RETURN l_axh08
END FUNCTION

FUNCTION g9401_axh4(p_axh05,p_axh06,p_axh07,p_gizz07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_gizz07    LIKE gizz_file.gizz07,
          l_axh08     LIKE axh_file.axh08, 
          l_axh081    LIKE axh_file.axh08,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07  
   DEFINE l_type      LIKE aag_file.aag06   
   DEFINE l_sql       LIKE type_file.chr1000
   DEFINE l_n         LIKE type_file.num10

   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_axh05
                                            AND aag00=tm.b  

   LET l_axh08 = 0
   LET l_axh081 = 0
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF
   LET l_n = 0
   IF tm.m1 = 1 THEN
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = p_axh06  AND gizz04 = 0               #CHI-C40004 gizz00-->gizz06 
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   ELSE
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = l_axh06  AND gizz04 = l_axh07         #CHI-C40004 gizz00-->gizz06
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   END IF
   IF l_n > 0 THEN
      LET l_sql = " SELECT gizz05 FROM gizz_file"
                 ,"  WHERE gizz06 = '",p_axh05 ,"'"                               #CHI-C40004 gizz00-->gizz06
                 ,"    AND gizz01 = '",tm.axa01,"' AND gizz02 = '",tm.axa02,"'"   #CHI-C40004
                 ,"    AND gizz07 = '",p_gizz07,"'"                               #CHI-C40004
      IF tm.m1 = 1 THEN
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",p_axh06," AND gizz04 = 0"
      ELSE
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",l_axh06," AND gizz04 = ",l_axh07
      END IF
      PREPARE i9401_axh_p5 FROM l_sql
      DECLARE i9401_axh_c5 SCROLL CURSOR FOR i9401_axh_p5
      OPEN i9401_axh_c5
      FETCH i9401_axh_c5 INTO l_axh081
   ELSE
      IF l_type = '1' THEN
         LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"
      ELSE
         LET l_sql = " SELECT SUM(axh09-axh08) FROM axh_file"
      END IF
      LET l_sql = l_sql CLIPPED
                 ,"  WHERE axh00 = '",tm.b,"'"
                 ,"    AND axh01 = '",tm.axa01,"'"
                 ,"    AND axh02 = '",tm.axa02,"'"
                 ,"    AND axh05 = '",p_axh05,"'"
                 ,"    AND axh06 = '",l_axh06,"'"
                 ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
                 ,"                  WHERE axh00 = '",g_aaz641,"'"
                 ,"                    AND axh01 = '",tm.axa01,"'"
                 ,"                    AND axh02 = '",tm.axa02,"'"
                 ,"                    AND axh05 = '",p_axh05,"'"
                 ,"                    AND axh06 = '",l_axh06,"'"
                 ,"                    AND axh07 <= '",l_axh07,"')"
      PREPARE i9401_axh2_p2 FROM l_sql
      DECLARE i9401_axh2_c2 SCROLL CURSOR FOR i9401_axh2_p2
      OPEN i9401_axh2_c2
      FETCH i9401_axh2_c2 INTO l_axh08
   END IF

   IF l_type = '1' THEN
      SELECT SUM(axh08-axh09) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = p_axh07
   ELSE
      SELECT SUM(axh09-axh08) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = p_axh07
   END IF
   IF cl_null(l_axh08) THEN LET l_axh08 = 0 END IF
   IF cl_null(l_axh081) THEN LET l_axh081 = 0 END IF
   LET l_axh08 = l_axh08 - l_axh081
   RETURN l_axh08
END FUNCTION
FUNCTION g9401_axh081(p_axh05,p_axh06,p_axh07,p_axh061,p_axh071,p_gizz07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_axh08     LIKE axh_file.axh08,
          p_axh061    LIKE axh_file.axh06,
          p_axh071    LIKE axh_file.axh07,
          p_axh081    LIKE axh_file.axh08,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07,
          p_gizz07    LIKE gizz_file.gizz07
   DEFINE l_n         LIKE type_file.num10
   DEFINE l_sql       LIKE type_file.chr1000
   LET p_axh08  = 0          #借方科餘
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF 
   LET l_n = 0   
   IF tm.m1 = 1 THEN
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = p_axh06  AND gizz04 = 0               #CHI-C40004 gizz00-->gizz06 
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   ELSE
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = l_axh06  AND gizz04 = l_axh07         #CHI-C40004 gizz00-->gizz06
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   END IF
   IF l_n > 0 THEN
      LET l_sql = " SELECT gizz05 FROM gizz_file"
                 ,"  WHERE gizz06 = '",p_axh05 ,"'"                               #CHI-C40004 gizz00-->gizz06
                 ,"    AND gizz01 = '",tm.axa01,"' AND gizz02 = '",tm.axa02,"'"   #CHI-C40004
                 ,"    AND gizz07 = '",p_gizz07,"'"                               #CHI-C40004
      IF tm.m1 = 1 THEN
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",p_axh06," AND gizz04 = 0"
      ELSE
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",l_axh06," AND gizz04 = ",l_axh07
      END IF
      PREPARE i9401_axh_p6 FROM l_sql
      DECLARE i9401_axh_c6 SCROLL CURSOR FOR i9401_axh_p6
      OPEN i9401_axh_c6
      FETCH i9401_axh_c6 INTO p_axh081
   ELSE
      LET l_sql = " SELECT axh08 FROM axh_file"
                 ,"  WHERE axh00 = '",g_aaz641,"'"
                 ,"    AND axh01 = '",tm.axa01,"'"
                 ,"    AND axh02 = '",tm.axa02,"'"
                 ,"    AND axh05 = '",p_axh05,"'"
                 ,"    AND axh06 = '",p_axh061,"'"
                 ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
                 ,"                  WHERE axh00 = '",g_aaz641,"'"
                 ,"                    AND axh01 = '",tm.axa01,"'"
                 ,"                    AND axh02 = '",tm.axa02,"'"
                 ,"                    AND axh05 = '",p_axh05,"'"
                 ,"                    AND axh06 = '",p_axh061,"'"
     #如果是上期是12月,用<會取不到12月的值
      IF p_axh07=12 THEN
         LET l_sql = l_sql," AND axh07 <= '",p_axh071,"')"
      ELSE
         LET l_sql = l_sql," AND axh07 < '",p_axh071,"')"
      END IF
      PREPARE i9401_axh08_p2 FROM l_sql
      DECLARE i9401_axh08_c2 SCROLL CURSOR FOR i9401_axh08_p2
      OPEN i9401_axh08_c2
      FETCH i9401_axh08_c2 INTO p_axh081
   END IF
   
   SELECT SUM(axh08) INTO p_axh08 FROM axh_file
    WHERE axh00 = tm.b    AND axh05 = p_axh05
      AND axh06 = p_axh06 AND axh07 = p_axh07
   IF cl_null(p_axh08) THEN LET p_axh08 = 0 END IF
   IF cl_null(p_axh081) THEN LET p_axh081 = 0 END IF
   LET p_axh08 = p_axh08 - p_axh081
   RETURN p_axh08
   CLOSE i9401_axh08_c2
END FUNCTION

FUNCTION g9401_axh091(p_axh05,p_axh06,p_axh07,p_axh061,p_axh071,p_gizz07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_axh09     LIKE axh_file.axh09,
          p_axh061    LIKE axh_file.axh06,
          p_axh071    LIKE axh_file.axh07,
          p_axh091    LIKE axh_file.axh09,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07,
          p_gizz07    LIKE gizz_file.gizz07
   DEFINE l_n         LIKE type_file.num10
   DEFINE l_sql       LIKE type_file.chr1000
          
   LET p_axh09  = 0          #貸方科餘
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF    
   LET l_n = 0
   IF tm.m1 = 1 THEN
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = p_axh06  AND gizz04 = 0               #CHI-C40004 gizz00-->gizz06
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   ELSE
      SELECT COUNT(*) INTO l_n FROM gizz_file 
       WHERE gizz06 = p_axh05  AND gizz03 = l_axh06  AND gizz04 = l_axh07         #CHI-C40004 gizz00-->gizz06
         AND gizz01 = tm.axa01 AND gizz02 = tm.axa02 AND gizz07 = p_gizz07
   END IF
   IF l_n > 0 THEN
      LET l_sql = " SELECT gizz05 FROM gizz_file"
                 ,"  WHERE gizz06 = '",p_axh05 ,"'"                               #CHI-C40004 gizz00-->gizz06
                 ,"    AND gizz01 = '",tm.axa01,"' AND gizz02 = '",tm.axa02,"'"   #CHI-C40004
                 ,"    AND gizz07 = '",p_gizz07,"'"                               #CHI-C40004
      IF tm.m1 = 1 THEN
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",p_axh06," AND gizz04 = 0"
      ELSE
         LET l_sql = l_sql CLIPPED," AND gizz03 = ",l_axh06," AND gizz04 = ",l_axh07
      END IF
      PREPARE i9401_axh_p7 FROM l_sql
      DECLARE i9401_axh_c7 SCROLL CURSOR FOR i9401_axh_p7
      OPEN i9401_axh_c7
      FETCH i9401_axh_c7 INTO p_axh091
   ELSE
      LET l_sql = " SELECT axh09 FROM axh_file"
                 ,"  WHERE axh00 = '",g_aaz641,"'"
                 ,"    AND axh01 = '",tm.axa01,"'"
                 ,"    AND axh02 = '",tm.axa02,"'"
                 ,"    AND axh05 = '",p_axh05,"'"
                 ,"    AND axh06 = '",p_axh061,"'"
                 ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
                 ,"                  WHERE axh00 = '",g_aaz641,"'"
                 ,"                    AND axh01 = '",tm.axa01,"'"
                 ,"                    AND axh02 = '",tm.axa02,"'"
                 ,"                    AND axh05 = '",p_axh05,"'"
                 ,"                    AND axh06 = '",p_axh061,"'"
     #如果是上期是12月,用<會取不到12月的值
      IF p_axh07=12 THEN
         LET l_sql = l_sql," AND axh07 <= '",p_axh071,"')"
      ELSE
         LET l_sql = l_sql," AND axh07 < '",p_axh071,"')"
      END IF
      PREPARE i9401_axh09_p2 FROM l_sql
      DECLARE i9401_axh09_c2 SCROLL CURSOR FOR i9401_axh09_p2
      OPEN i9401_axh09_c2
      FETCH i9401_axh09_c2 INTO p_axh091
   END IF
   SELECT SUM(axh09) INTO p_axh09 FROM axh_file
    WHERE axh00 = tm.b    AND axh05 = p_axh05
      AND axh06 = p_axh06 AND axh07 = p_axh07
   IF cl_null(p_axh09)  THEN LET p_axh09 = 0 END IF
   IF cl_null(p_axh091) THEN LET p_axh091 = 0 END IF
   LET p_axh09 = p_axh09 - p_axh091
   RETURN p_axh09
   CLOSE i9401_axh09_c2
END FUNCTION
#FUN-C30098---ENd---
#CHI-C40004--Begin--
FUNCTION g9401_axh5(p_axh05,p_axh06,p_axh07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          l_axh08     LIKE axh_file.axh08, 
          l_axh081    LIKE axh_file.axh08,
          l_axh06     LIKE axh_file.axh06,
          l_axh07     LIKE axh_file.axh07  
   DEFINE l_type      LIKE aag_file.aag06   
   DEFINE l_sql       LIKE type_file.chr1000
   DEFINE l_n         LIKE type_file.num10

   SELECT aag06 INTO l_type FROM aag_file WHERE aag01 = p_axh05
                                            AND aag00 = tm.b 
   LET l_axh08 = 0
   LET l_axh081 = 0
   IF tm.m1=1 THEN
      LET l_axh06 = p_axh06 - 1
      LET l_axh07 = 12
   ELSE
      LET l_axh06 = p_axh06
      LET l_axh07 = tm.m1 - 1
   END IF
   LET l_n = 0 
   IF tm.m1 = 1 THEN
      SELECT COUNT(*) INTO l_n FROM giz_file 
       WHERE giz01 = p_axh06  AND giz02 = 0
         AND giz04 = tm.axa01 AND giz05 = tm.axa02
   ELSE
      SELECT COUNT(*) INTO l_n FROM giz_file
       WHERE giz01 = l_axh06  AND giz02 = l_axh07 
         AND giz04 = tm.axa01 AND giz05 = tm.axa02 
   END IF
   IF l_n > 0 THEN
      LET l_sql = " SELECT giz03 FROM giz_file"
                 ,"  WHERE giz04 = '",tm.axa01,"' AND giz05 = '",tm.axa02,"'"
      IF tm.m1 = 1 THEN
         LET l_sql = l_sql CLIPPED," AND giz01 = ",p_axh06," AND giz02 = 0"
      ELSE
         LET l_sql = l_sql CLIPPED," AND giz01 = ",l_axh06," AND giz02 = ",l_axh07
      END IF
      PREPARE i9401_axh5_p1 FROM l_sql
      DECLARE i9401_axh5_c1 SCROLL CURSOR FOR i9401_axh5_p1
      OPEN i9401_axh5_c1
      FETCH i9401_axh5_c1 INTO l_axh081
   ELSE
      IF l_type = '1' THEN
         LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"
      ELSE
         LET l_sql = " SELECT SUM(axh09-axh08) FROM axh_file"
      END IF
      LET l_sql = l_sql CLIPPED
                 ,"  WHERE axh00 = '",tm.b,"'"
                 ,"    AND axh01 = '",tm.axa01,"'"
                 ,"    AND axh02 = '",tm.axa02,"'"
                 ,"    AND axh05 = '",p_axh05,"'"
                 ,"    AND axh06 = '",l_axh06,"'"
                 ,"    AND axh07 = (SELECT MAX(axh07) FROM axh_file "
                 ,"                  WHERE axh00 = '",g_aaz641,"'"
                 ,"                    AND axh01 = '",tm.axa01,"'"
                 ,"                    AND axh02 = '",tm.axa02,"'"
                 ,"                    AND axh05 = '",p_axh05,"'"
                 ,"                    AND axh06 = '",l_axh06,"'"
                 ,"                    AND axh07 <= '",l_axh07,"')"
      PREPARE i9401_axh5_p2 FROM l_sql
      DECLARE i9401_axh5_c2 SCROLL CURSOR FOR i9401_axh5_p2
      OPEN i9401_axh5_c2
      FETCH i9401_axh5_c2 INTO l_axh081
   END IF

   IF l_type = '1' THEN
      SELECT SUM(axh08-axh09) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = tm.m2
   ELSE
      SELECT SUM(axh09-axh08) INTO l_axh08 FROM axh_file
       WHERE axh00 = tm.b AND axh05=p_axh05
         AND axh01 = tm.axa01 AND axh02 = tm.axa02
         AND axh06 = p_axh06 AND axh07 = tm.m2
   END IF
   IF cl_null(l_axh08) THEN LET l_axh08 = 0 END IF
   IF cl_null(l_axh081) THEN LET l_axh081 = 0 END IF
   LET l_axh08 = l_axh08 - l_axh081
   RETURN l_axh08
END FUNCTION
#CHI-C40004---End---

###GENGRE###START
FUNCTION aglg9401_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg9401")
        IF handler IS NOT NULL THEN
            START REPORT aglg9401_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg9401_datacur1 CURSOR FROM l_sql
            FOREACH aglg9401_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg9401_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg9401_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg9401_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
 #FUN-C70034--add--begin--
    DEFINE l_unit   STRING
    DEFINE l_h1     STRING
    DEFINE l_h2     STRING
    DEFINE l_h3     STRING  
    DEFINE l_d1     LIKE type_file.num5
    DEFINE l_d2     LIKE type_file.num5
    DEFINE l_bdate  LIKE type_file.dat
    DEFINE l_flag   LIKE type_file.chr1
    DEFINE l_edate  LIKE type_file.dat
    DEFINE l_str1   STRING
    DEFINE l_str2   STRING
    DEFINE l_str3   STRING 
    DEFINE l_str4   STRING
 #FUN-C70034--add--end--
    
    ORDER EXTERNAL BY sr1.type 
    
    FORMAT
        FIRST PAGE HEADER
            LET l_str1 = NULL    #FUN-C70034 add
            LET l_str2 = NULL    #FUN-C70034 add
            LET l_str3 = NULL    #FUN-C70034 add
            LET l_str4 = NULL    #FUN-C70034 add
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
          #FUN-C70034-------add----str----
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit  
            IF g_aza.aza63 = 'Y' THEN   #aza63(使用多帐别功能)
               CALL s_azmm(tm.y1,tm.m1,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
            ELSE
               CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate
            END IF
            LET l_d1 = DAY(l_bdate)
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(tm.y2,tm.m2,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
            ELSE
               CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate
            END IF
            LET l_d2 = DAY(l_edate)
            LET l_h1 = cl_gr_getmsg("gre-228",g_lang,1),':',tm.p,"    ",cl_gr_getmsg("gre-228",g_lang,2),':',l_unit
            PRINTX l_h1
            #gre-228(1:幣別|2:單位)l_h1显示为（幣別:NTD    單位:元）
            LET l_h2 = tm.y1 USING '&&&&','/',tm.m1 USING '&&','/',l_d1 USING '&&','~',tm.y2 USING '&&&&','/',tm.m2 USING '&&','/',l_d2 USING '&&'
            PRINTX l_h2
            #2010/01/01~2010/04/30
            LET l_h3 = tm.y1-1 USING '&&&&','/',tm.m1 USING '&&','/',l_d1 USING '&&','~',tm.y2-1 USING '&&&&','/',tm.m2 USING '&&','/',l_d2 USING '&&' 
            PRINTX l_h3
            #2009/01/01~2009/04/30
          #FUN-C70034---------add-------end----              

        BEFORE GROUP OF sr1.type
          #FUN-C70034-------add----str----
            LET l_str1 = sr1.str1
            LET l_str1 = l_str1.trim()
            PRINTX l_str1 
            LET l_str3 = sr1.str3
            LET l_str3 = l_str3.trim()
            PRINTX l_str3 
          #FUN-C70034---------add-------end----       
 
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

          #FUN-C70034-------add----str----
            LET l_str2 = sr1.str2
            LET l_str2 = l_str2.trim()
            PRINTX l_str2 
            LET l_str4 = sr1.str4
            LET l_str4 = l_str4.trim()
            PRINTX l_str4 
          #FUN-C70034---------add-------end----

            PRINTX sr1.*

        AFTER GROUP OF sr1.type
        
        ON LAST ROW

END REPORT
###GENGRE###END

