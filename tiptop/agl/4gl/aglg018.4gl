# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglg018.4gl
# Descriptions...: 合併後帳戶式資產負債去年同期比較表
# Date & Author..: 11/06/29 FUN-B60151 By zhangweib
# Modify.........: No.FUN-C10036 12/01/18 By yangtt 明細類CR轉換成GRW
# Modify.........: No.FUN-C20073 12/03/05 By qirl 
# Modify.........: No.FUN-C50004 12/05/07 By nanbing GR 優化 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                              #FUN-B60151
            axa01  LIKE axa_file.axa01,        #族群編號
            axa02  LIKE axa_file.axa02,        #上層公司編號
            b      LIKE aaa_file.aaa01,        #帳別編號    
            aaz641 LIKE aaz_file.aaz641,       #合并帳別
            a      LIKE mai_file.mai01,        #報表結構編號     
            yy1    LIKE type_file.num5,        #輸入年度
            axa06  LIKE axa_file.axa06,
            bm1    LIKE type_file.num5,        #Begin 期別
            em1    LIKE type_file.num5,        #End 期別
            q1     LIKE type_file.chr1,
            h1     LIKE type_file.chr1,
            yy2    LIKE type_file.num5,
            bm2    LIKE type_file.num5,
            em2    LIKE type_file.num5,
            q2     LIKE type_file.chr1,
            h2     LIKE type_file.chr1,
            title1 LIKE type_file.chr20,
            title2 LIKE type_file.chr20,
            e      LIKE type_file.num5,        #小數位數     
            f      LIKE type_file.num5,        #列印最小階數
            d      LIKE type_file.chr1,        #金額單位
            c      LIKE type_file.chr1,        #異動額及餘額為0者是否列印   
            h      LIKE type_file.chr4,        #額外說明類別  
            o      LIKE type_file.chr1,        #轉換幣別否   
            r      LIKE azi_file.azi01,        #幣別    
            p      LIKE azi_file.azi01,        #幣別
            q      LIKE azj_file.azj03,        #匯率
            more   LIKE type_file.chr1         #Input more condition(Y/N) 
           END RECORD,
       i,j,k       LIKE type_file.num5,       
       g_unit      LIKE type_file.num10,       #金額單位基數  
       l_row       LIKE type_file.num5,                      
       r_row       LIKE type_file.num5,                     
       g_bookno    LIKE axh_file.axh00,        #帳別
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_tot1      ARRAY[100] OF LIKE type_file.num20_6,   
       g_tot2      ARRAY[100] OF LIKE type_file.num20_6,
       g_basetot1  LIKE axh_file.axh08
      ,g_basetot2  LIKE axh_file.axh08
DEFINE g_aaa03     LIKE aaa_file.aaa03   
DEFINE g_i         LIKE type_file.num5         #count/index for any purpose  
DEFINE l_table     STRING              
DEFINE g_sql       STRING             
DEFINE g_str       STRING            
DEFINE g_aaz641    LIKE aaz_file.aaz641
DEFINE g_axz03     LIKE axz_file.axz03
DEFINE g_dbs_axz03 STRING
DEFINE g_axa09     LIKE axa_file.axa09
DEFINE g_axa05     LIKE axa_file.axa05
###GENGRE###START
TYPE sr1_t RECORD
    maj20_l LIKE type_file.chr50,
    bal_l LIKE type_file.num20_6,
    bal_l_2 LIKE type_file.num20_6,
    per_l LIKE type_file.num20_6,
    per_l_2 LIKE type_file.num20_6,
    maj03_l LIKE maj_file.maj03,
    maj02_l LIKE maj_file.maj02,
    line_l LIKE type_file.num5,
    maj20_r LIKE type_file.chr50,
    bal_r LIKE type_file.num20_6,
    bal_r_2 LIKE type_file.num20_6,
    per_r LIKE type_file.num20_6,
    per_r_2 LIKE type_file.num20_6,
    maj03_r LIKE maj_file.maj03,
    maj02_r LIKE maj_file.maj02,
    line_r LIKE type_file.num5
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

   LET g_sql = "maj20_l.type_file.chr50,",
               "bal_l.type_file.num20_6,",
               "bal_l_2.type_file.num20_6,",
               "per_l.type_file.num20_6,",
               "per_l_2.type_file.num20_6,",
               "maj03_l.maj_file.maj03,",
               "maj02_l.maj_file.maj02,",
               "line_l.type_file.num5,",
               "maj20_r.type_file.chr50,",
               "bal_r.type_file.num20_6,",  
               "bal_r_2.type_file.num20_6,",
               "per_r.type_file.num20_6,", 
               "per_r_2.type_file.num20_6,",
               "maj03_r.maj_file.maj03,",
               "maj02_r.maj_file.maj02,",
               "line_r.type_file.num5,"
               
   LET l_table = cl_prt_temptable('aglg018',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
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
   LET tm.yy1= ARG_VAL(10)
   LET tm.axa06= ARG_VAL(11)
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
   LET tm.q1 = ARG_VAL(25)
   LET tm.h1 = ARG_VAL(26)
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.aaz641) THEN LET tm.aaz641 = g_aza.aza81 END IF    
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g018_tm()                      # Input print condition
      ELSE CALL g018()                         # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION g018_tm()
   DEFINE p_row,p_col    LIKE type_file.num5     
   DEFINE l_sw           LIKE type_file.chr1      #重要欄位是否空白  
   DEFINE l_cmd          LIKE type_file.chr1000   
   DEFINE li_chk_bookno  LIKE type_file.num5     
   DEFINE li_result      LIKE type_file.num5    
   DEFINE l_aaa03        LIKE aaa_file.aaa03   
   DEFINE l_azi05        LIKE azi_file.azi05  
   DEFINE l_cnt          LIKE type_file.num5 
   DEFINE l_aaa05        LIKE aaa_file.aaa05
   DEFINE l_aznn01       LIKE aznn_file.aznn01
   DEFINE l_dbs          LIKE type_file.chr21

   CALL s_dsmark(g_bookno)

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 11
   END IF

   OPEN WINDOW g018_w AT p_row,p_col WITH FORM "agl/42f/aglg018"
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
   LET tm.c = 'N'
   LET tm.e = 2
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.q = 1
   LET tm.p = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_row=0
      LET r_row=0
      LET l_sw = 1
      INPUT BY NAME tm.axa01,tm.axa02,tm.b,tm.aaz641,tm.a,
               tm.yy1,tm.em1,tm.q1,tm.h1,
               tm.yy2,tm.em2,tm.q2,tm.h2,tm.e,tm.f,
               tm.d,tm.c,tm.h,tm.o,tm.r,
               tm.p,tm.q,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_init()
            CALL g018_set_entry()
            CALL g018_set_no_entry()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                

         AFTER FIELD axa01
            IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
            SELECT COUNT(*) INTO l_cnt FROM axa_file
             WHERE axa01=tm.axa01
            IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
            IF l_cnt <=0  THEN
               CALL cl_err(tm.axa01,'agl-223',0) 
               NEXT FIELD axa01
            END IF
            LET tm.axa06 = '2'
            SELECT axa05,axa06 
              INTO g_axa05,tm.axa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'   #最上層公司否
            DISPLAY BY NAME tm.axa06
            CALL g018_set_entry()
            CALL g018_set_no_entry()
            IF tm.axa06 = '1' THEN
               LET tm.q1 = '' 
               LET tm.h1 = '' 
	           LET tm.q2 = ''
	           LET tm.h2 = ''
               LET l_aaa05 = 0
               SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                WHERE aaa01=tm.b 
                  AND aaaacti MATCHES '[Yy]'
               LET tm.em1 = l_aaa05
               LET tm.em2 = l_aaa05
            END IF
            IF tm.axa06 = '2' THEN
               LET tm.h1 = '' 
               LET tm.em1 = ''
               LET tm.h2 = ''
               LET tm.em2 = ''
            END IF
            IF tm.axa06 = '3' THEN
               LET tm.em1 = ''
               LET tm.q1 = ''
               LET tm.em1 = ''
               LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
               LET tm.em1 = ''
               LET tm.q1  = ''
               let tm.h1  = ''
               LET tm.em2 = ''
               LET tm.q2  = ''
               let tm.h2  = ''
            END IF
            DISPLAY BY NAME tm.em1,tm.em2,tm.q1,tm.q2,tm.h1,tm.h2

         AFTER FIELD em1
            IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
            LET tm.em2 = tm.em1
            DISPLAY BY NAME tm.em2
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
            CASE tm.em1
               WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING tm.title1
               WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING tm.title1
               WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING tm.title1
               WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING tm.title1
               WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING tm.title1
               WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING tm.title1
               WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING tm.title1
               WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING tm.title1
               WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING tm.title1
               WHEN 10 CALL cl_getmsg('agl-328',g_lang) RETURNING tm.title1
               WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING tm.title1
               WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING tm.title1
               WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING tm.title1
               OTHERWISE LET tm.title1 = ' '
            END CASE
            CASE tm.em2
               WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING tm.title2
               WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING tm.title2
               WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING tm.title2
               WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING tm.title2
               WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING tm.title2
               WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING tm.title2
               WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING tm.title2
               WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING tm.title2
               WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING tm.title2
               WHEN 10 CALL cl_getmsg('agl-328',g_lang) RETURNING tm.title2
               WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING tm.title2
               WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING tm.title2
               WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING tm.title2
               OTHERWISE LET tm.title2 = ' '
            END CASE

        AFTER FIELD em2
           CASE tm.em2
              WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING tm.title2
              WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING tm.title2
              WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING tm.title2
              WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING tm.title2
              WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING tm.title2
              WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING tm.title2
              WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING tm.title2
              WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING tm.title2
              WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING tm.title2
              WHEN 10  CALL cl_getmsg('agl-328',g_lang) RETURNING tm.title2
              WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING tm.title2
              WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING tm.title2
              WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING tm.title2
              OTHERWISE LET tm.title2 = ' '
           END CASE

        AFTER FIELD q1    #季
           IF NOT cl_null(tm.q1) AND tm.q1 NOT MATCHES '[1234]' THEN
              NEXT FIELD q1
           END IF
           LET tm.q2 = tm.q1
           DISPLAY BY NAME tm.q2
           CASE tm.q1
              WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title1
              WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title1
              WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title1
              WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title1
              OTHERWISE LET tm.title1 = ' '
           END CASE
           CASE tm.q2
              WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title2
              WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title2
              WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title2
              WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title2
              OTHERWISE LET tm.title2 = ' '
           END CASE

        AFTER FIELD q2
           IF NOT cl_null(tm.q2) AND tm.q2 NOT MATCHES '[1234]' THEN
              NEXT FIELD q2
           END IF
           CASE tm.q2
              WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title2
              WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title2
              WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title2
              WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title2
              OTHERWISE LET tm.title2 = ' '
           END CASE

        AFTER FIELD h1 #半年報
           IF (tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
              NEXT FIELD h1
           END IF
           CASE tm.h1
              WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title1
              WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title1
              OTHERWISE LET tm.title1 = ' '
           END CASE
           LET tm.h2 = tm.h1
           DISPLAY BY NAME tm.h2
           CASE tm.h2
              WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title2
              WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title2
              OTHERWISE LET tm.title2 = ' '
           END CASE

        AFTER FIELD h2
           IF (tm.h2>2 OR tm.h2<0) AND tm.axa06='4' THEN
              NEXT FIELD h2
           END IF
           CASE tm.h2
              WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title2
              WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title2
              OTHERWISE LET tm.title2 = ' '
           END CASE

        AFTER FIELD axa02
           SELECT COUNT(*) INTO l_cnt FROM axa_file
            WHERE axa01=tm.axa01 AND axa02=tm.axa02
           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
           IF l_cnt <=0  THEN
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
              LET tm.aaz641 = g_aaz641
              DISPLAY BY NAME tm.aaz641
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
                  AND mai00 = tm.aaz641    
                  AND maiacti IN('Y','y')
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

         AFTER FIELD aaz641
            LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_dbs_axz03,'aaz_file'),
                       " WHERE aaz641 = '",tm.aaz641,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            PREPARE g018_cnt_p FROM g_sql
            DECLARE g018_cnt_c CURSOR FOR g018_cnt_p
            OPEN g018_cnt_c
            FETCH g018_cnt_c INTO l_cnt
            IF cl_null(l_cnt) OR l_cnt=0 THEN
               CALL cl_err('','agl-965',1)
               NEXT FIELD aaz641
            END IF   

         AFTER FIELD c
            IF NOT cl_null(tm.c) AND     tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

         AFTER FIELD yy1
            IF NOT　cl_null(tm.yy1) AND tm.yy1 = 0 THEN
               NEXT FIELD yy1
            END IF
            LET tm.yy2 = tm.yy1 - 1
            DISPLAY BY NAME tm.yy2

         AFTER FIELD d
            IF NOT cl_null(tm.d) AND tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF

         AFTER FIELD e
            IF NOT cl_null(tm.e) AND tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF

         AFTER FIELD f
            IF NOT cl_null(tm.f) AND tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF

         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF

         AFTER FIELD o
            IF NOT cl_null(tm.o) AND tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
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
            IF NOT cl_null(tm.axa06) THEN
               CASE
                  WHEN tm.axa06 = '1'  #月 
                     LET tm.bm1 = 0
                     LET tm.bm2 = 0
                  OTHERWISE      
                     CALL s_axz03_dbs(tm.axa02) RETURNING l_dbs 
                     CALL s_get_aznn01(l_dbs,tm.axa06,tm.b,tm.yy1,tm.q1,tm.h1) 
                          RETURNING tm.em1
                     CALL s_get_aznn01(l_dbs,tm.axa06,tm.b,tm.yy2,tm.q2,tm.h2) 
                          RETURNING tm.em2
               END CASE
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution

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

               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                 #LET g_qryparam.where = " mai00 = '",tm.aaz641,"'"  #No.TQC-C50042   Add
                  LET g_qryparam.where = " mai00 = '",tm.aaz641,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a

               WHEN INFIELD(aaz641)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.aaz641
                  CALL cl_create_qry() RETURNING tm.aaz641 
                  DISPLAY BY NAME tm.aaz641
                  NEXT FIELD aaz641

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
         LET INT_FLAG = 0 CLOSE WINDOW g018_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg018'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg018','9031',1)   
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
                   " '",tm.yy1 CLIPPED,"'",
                   " '",tm.yy2 CLIPPED,"'",
                   " '",tm.axa06 CLIPPED,"'",
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
                   " '",g_rpt_name CLIPPED,"'",
                   " '",tm.q1 CLIPPED,"'",
                   " '",tm.h1 CLIPPED,"'"
            CALL cl_cmdat('aglg018',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g018_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g018()
      ERROR ""
   END WHILE
   CLOSE WINDOW g018_w
END FUNCTION

FUNCTION g018()
   DEFINE l_name    LIKE type_file.chr20         #External(Disk) file name     
   DEFINE l_sql     LIKE type_file.chr1000       #RDSQL STATEMENT             
   DEFINE l_chr     LIKE type_file.chr1         
   DEFINE amt1      LIKE axh_file.axh08
   DEFINE amt2      LIKE axh_file.axh08
   DEFINE per1      LIKE fid_file.fid03        
   DEFINE per2      LIKE fid_file.fid03        
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5       
   DEFINE l_lastday LIKE type_file.dat       
   DEFINE sr        RECORD
             bal1   LIKE axh_file.axh08,
             bal2   LIKE axh_file.axh08
                    END RECORD
   DEFINE prt_l     DYNAMIC ARRAY OF RECORD                   #--- 陣列 for 資產類 (左)
             maj20  LIKE type_file.chr50,    
             bal    LIKE type_file.num20_6, 
             bal_1  LIKE type_file.num20_6, 
             per    LIKE type_file.num20_6,   
             per_1  LIKE type_file.num20_6,   
             maj03  LIKE maj_file.maj03,     
             maj02  LIKE maj_file.maj02,    
             line   LIKE type_file.num5    
                    END RECORD
   DEFINE prt_r     DYNAMIC ARRAY OF RECORD                   #--- 陣列 for 資產類 (右)
             maj20  LIKE type_file.chr50,    
             bal    LIKE type_file.num20_6, 
             bal_1  LIKE type_file.num20_6, 
             per    LIKE type_file.num20_6,   
             per_1  LIKE type_file.num20_6,   
             maj03  LIKE maj_file.maj03,     
             maj02  LIKE maj_file.maj02,    
             line   LIKE type_file.num5    
                    END RECORD
   DEFINE tmp1      RECORD    
             maj23  LIKE maj_file.maj23,
             maj20  LIKE type_file.chr50,
             bal    LIKE type_file.num20_6,
             bal_1  LIKE type_file.num20_6,
             per    LIKE type_file.num20_6,
             per_1  LIKE type_file.num20_6,
             maj03  LIKE maj_file.maj03,
             maj02  LIKE maj_file.maj02,
             line   LIKE type_file.num5
                    END RECORD
   DEFINE l_maj02_l LIKE maj_file.maj02     
   DEFINE l_maj02_r LIKE maj_file.maj02    
   DEFINE l_row_l   LIKE type_file.num5   
   DEFINE l_row_r   LIKE type_file.num5  
   DEFINE r,l,i     LIKE type_file.num5 

   DROP TABLE aglg018_tmp
   CREATE TEMP TABLE aglg018_tmp(
      maj23    LIKE maj_file.maj23,
      maj20    LIKE type_file.chr50,
      bal      LIKE type_file.num20_6,
      bal_1    LIKE type_file.num20_6,
      per      LIKE type_file.num20_6,
      per_1    LIKE type_file.num20_6,
      maj03    LIKE maj_file.maj03,
      maj02    LIKE maj_file.maj02,
      line     LIKE type_file.num5)

   #帳別名稱
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01=tm.aaz641 AND aaf02=g_rlang

   CALL cl_del_data(l_table)          

   LET l_sql = "SELECT * FROM maj_file ",
               " WHERE maj01 = '",tm.a,"' ",
               "   AND maj23[1,1]='1' ",
               " ORDER BY maj02"
   PREPARE g018_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE g018_c CURSOR FOR g018_p

   #FUN-C50004 sta
   LET g_sql="SELECT SUM(axh08-axh09) ",
             "  FROM axh_file,",cl_get_target_table(g_dbs_axz03,'aag_file'),
             " WHERE axh00 = '",tm.aaz641,"'",
             "   AND axh00 = aag00 ",
             "   AND axh01 = '",tm.axa01,"'",
             "   AND axh02 = '",tm.axa02,"'",
             "   AND axh03 = '",tm.b,"'",    
             "   AND axh05 BETWEEN ? AND ? ",
             "   AND axh06 = '",tm.yy1,"' AND axh07 = '",tm.em1,"'",
             "   AND axh05 = aag01 AND aag07 !='1' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE sel_amt1_pre FROM g_sql
   DECLARE sel_amt1_cs CURSOR FOR sel_amt1_pre


   LET g_sql="SELECT SUM(axh08-axh09)",
             "  FROM axh_file,",cl_get_target_table(g_dbs_axz03,'aag_file'),
             " WHERE axh00 = '",tm.aaz641,"'",
             "   AND aag00 = axh00 ",
             "   AND axh01 = '",tm.axa01,"'",
             "   AND axh02 = '",tm.axa02,"'",
             "   AND axh03 = '",tm.b,"'",    
             "   AND axh05 BETWEEN ? AND ? ",
             "   AND axh06 = ",tm.yy2," AND axh07 = ",tm.em2,
             "   AND axh05 = aag01 AND aag07 !='1' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE sel_amt_pre FROM g_sql
   DECLARE sel_amt_cs CURSOR FOR sel_amt_pre         
   #FUN-C50004 end
   
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   
   FOREACH g018_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      LET amt2 = 0
      IF NOT cl_null(maj.maj21) THEN
        #會計科目各期余額檔 
        #FUN-C50004 mark sta
        # LET g_sql="SELECT SUM(axh08-axh09) ",
        #           "  FROM axh_file,",cl_get_target_table(g_dbs_axz03,'aag_file'),
        #           " WHERE axh00 = '",tm.aaz641,"'",
        #           "   AND axh00 = aag00 ",
        #           "   AND axh01 = '",tm.axa01,"'",
        #           "   AND axh02 = '",tm.axa02,"'",
        #           "   AND axh03 = '",tm.b,"'",    
        #           "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
        #           "   AND axh06 = '",tm.yy1,"' AND axh07 = '",tm.em1,"'",
        #           "   AND axh05 = aag01 AND aag07 !='1' "
        # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        # PREPARE sel_amt1_pre FROM g_sql
        # DECLARE sel_amt1_cs CURSOR FOR sel_amt1_pre
        #OPEN sel_amt1_cs 
        #FUN-C50004 mark end
         OPEN sel_amt1_cs USING maj.maj21,maj.maj22 #FUN-C50004 add
         FETCH sel_amt1_cs INTO amt1
         IF amt1 IS NULL THEN LET amt1 = 0 END IF
      END IF
      IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
         #FUN-C50004 mark sta
         #LET g_sql="SELECT SUM(axh08-axh09)",
         #          "  FROM axh_file,",cl_get_target_table(g_dbs_axz03,'aag_file'),
         #          " WHERE axh00 = '",tm.aaz641,"'",
         #          "   AND aag00 = axh00 ",
         #          "   AND axh01 = '",tm.axa01,"'",
         #          "   AND axh02 = '",tm.axa02,"'",
         #          "   AND axh03 = '",tm.b,"'",    
         #          "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
         #          "   AND axh06 = ",tm.yy2," AND axh07 = ",tm.em2,
         #          "   AND axh05 = aag01 AND aag07 !='1' "
         #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         #PREPARE sel_amt_pre FROM g_sql
         #DECLARE sel_amt_cs CURSOR FOR sel_amt_pre
         #OPEN sel_amt_cs 
         #FUN-C50004 mark end
         OPEN sel_amt_cs USING maj.maj21,maj.maj22 #FUN-C50004 add
         FETCH sel_amt_cs INTO amt2
         IF amt2 IS NULL THEN LET amt2 = 0 END IF
      END IF
      IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF          #匯率的轉換
      IF tm.o = 'Y' THEN LET amt2 = amt2 * tm.q END IF          #匯率的轉換
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
         LET k=maj.maj08  LET sr.bal1=g_tot1[k]
         LET k=maj.maj08  LET sr.bal2=g_tot2[k]
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal2 = sr.bal2 *-1
         END IF
         FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
         FOR i = 1 TO maj.maj08 LET g_tot2[i]=0 END FOR
      ELSE  
         IF maj.maj03='5' THEN                       #本行要印出,但金額不作加總
            LET sr.bal1=amt1
            LET sr.bal2=amt1
         ELSE
            LET sr.bal1=NULL
            LET sr.bal2=NULL
         END IF
      END IF
      IF maj.maj11 = 'Y' THEN                        #百分比基準科目
         LET g_basetot1=sr.bal1
         LET g_basetot2=sr.bal2
         IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
         IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
         IF maj.maj07='2' THEN LET g_basetot2=g_basetot2*-1 END IF
         #金額單位(1.元 2.千 3.百萬)
         IF tm.d MATCHES '[23]' THEN LET g_basetot1=g_basetot1/g_unit END IF
      END IF
      IF maj.maj03='0' THEN                          #本行不印出
         CONTINUE FOREACH
      END IF
      IF (tm.c='N' OR maj.maj03='2') AND             #餘額為 0 者不列印
          maj.maj03 MATCHES "[012345]" AND sr.bal1=0 AND sr.bal2=0 THEN
         CONTINUE FOREACH
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN            #最小階數起列印
         CONTINUE FOREACH
      END IF
      #正常餘額型態=2.貸餘,金額要乘以-1 
      IF maj.maj07='2' THEN LET sr.bal1=sr.bal1*-1 END IF
      IF maj.maj07='2' THEN LET sr.bal2=sr.bal2*-1 END IF
      LET sr.bal1=cl_numfor(sr.bal1,17,tm.e)
      LET sr.bal2=cl_numfor(sr.bal2,17,tm.e)
      #列印額外名稱
      IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
      LET per1 = (sr.bal1 / g_basetot1) * 100
      LET per2 = (sr.bal2 / g_basetot2) * 100
      IF maj.maj03 = 'H' THEN 
         LET sr.bal1=NULL
         LET per1= ' '
         LET sr.bal2=NULL
         LET per2= ' '
      END IF
      #金額單位(1.元 2.千 3.百萬)
      IF tm.d MATCHES '[23]' THEN LET sr.bal1=sr.bal1/g_unit END IF
      IF tm.d MATCHES '[23]' THEN LET sr.bal2=sr.bal2/g_unit END IF
      LET maj.maj20=maj.maj05 SPACES,maj.maj20   

      IF maj.maj03='3' OR maj.maj03='4' THEN
         IF NOT cl_null(maj.maj20) THEN
            INSERT INTO aglg018_tmp VALUES
             (maj.maj23,maj.maj20,sr.bal1,sr.bal2,per1,per2,'1',maj.maj02,2)
         END IF
         INSERT INTO aglg018_tmp VALUES
          (maj.maj23,maj.maj20,sr.bal1,sr.bal2,per1,per2,maj.maj03,maj.maj02,2)
      ELSE
         INSERT INTO aglg018_tmp VALUES
          (maj.maj23,maj.maj20,sr.bal1,sr.bal2,per1,per2,maj.maj03,maj.maj02,2)
      END IF
      IF maj.maj04 > 0 THEN
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            INSERT INTO aglg018_tmp VALUES
             (maj.maj23,maj.maj20,0,0,0,0,maj.maj03,maj.maj02,1)
         END FOR
      END IF
   END FOREACH

   #抓報表結構裡帳戶左邊最大序號
   SELECT MAX(maj02) INTO l_maj02_l FROM aglg018_tmp WHERE maj23='11'
   #抓報表結構裡帳戶右邊最大序號
   SELECT MAX(maj02) INTO l_maj02_r FROM aglg018_tmp WHERE maj23='12'
   IF cl_null(l_maj02_l) THEN LET l_maj02_l = 0 END IF
   IF cl_null(l_maj02_r) THEN LET l_maj02_r = 0 END IF
   LET r_row = 0  LET l_row = 0
   DECLARE g018_c1 CURSOR FOR SELECT * FROM aglg018_tmp ORDER BY maj23,maj02,line
   FOREACH g018_c1 INTO tmp1.*
      IF tmp1.maj23[2,2]='2' THEN     #--- 右邊(負債&業主權益)
         LET r_row=r_row+1
         LET prt_r[r_row].maj20=tmp1.maj20
         LET prt_r[r_row].bal  =tmp1.bal
         LET prt_r[r_row].bal_1=tmp1.bal_1
         LET prt_r[r_row].per  =tmp1.per
         LET prt_r[r_row].per_1=tmp1.per_1
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
         LET prt_l[l_row].maj20=tmp1.maj20
         LET prt_l[l_row].bal  =tmp1.bal
         LET prt_l[l_row].bal_1=tmp1.bal_1
         LET prt_l[l_row].per  =tmp1.per
         LET prt_l[l_row].per_1=tmp1.per_1
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
               LET prt_r[l_row_l+1].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
               LET prt_r[l_row_l].* = prt_r[l_row_r-1].*
               INITIALIZE prt_r[l_row_r-1].* TO NULL
               LET l_last=l_row_l+1
            ELSE
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
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
         prt_l[i].maj20,prt_l[i].bal,    prt_l[i].bal_1,prt_l[i].per,    prt_l[i].per_1,
         prt_l[i].maj03,prt_l[i].maj02,  prt_l[i].line,
         prt_r[i].maj20,prt_r[i].bal,    prt_r[i].bal_1,prt_r[i].per,    prt_r[i].per_1,
         prt_r[i].maj03,prt_r[i].maj02,  prt_r[i].line
   END FOR

###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET l_lastday = MDY(tm.em1,'1',tm.yy1)
   LET l_lastday = s_last(l_lastday)    
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy1,";",
###GENGRE###               tm.bm1,";",tm.e,";",l_lastday,";",g_basetot1,
###GENGRE###               ";",tm.yy2,";",tm.title1,";",tm.title2
###GENGRE###   CALL cl_prt_cs3('aglg018','aglg018',g_sql,g_str) 
    CALL aglg018_grdata()    ###GENGRE###
END FUNCTION

FUNCTION g018_set_entry()                                                                                                           
   CALL cl_set_comp_entry("q1,em1,h1",TRUE)
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION g018_set_no_entry()                                                                                                        
   IF tm.axa06 ="1" THEN  #月
      CALL cl_set_comp_entry("q1,h1",FALSE)  
   END IF
   IF tm.axa06 ="2" THEN  #季
      CALL cl_set_comp_entry("em1,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN  #半年
      CALL cl_set_comp_entry("em1,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN  #年
      CALL cl_set_comp_entry("q1,em1,h1",FALSE)
   END IF
END FUNCTION

###GENGRE###START
FUNCTION aglg018_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg018")
        IF handler IS NOT NULL THEN
            START REPORT aglg018_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY maj02_l,line_l,maj02_r,line_r"    #FUN-C10036 add
          
            DECLARE aglg018_datacur1 CURSOR FROM l_sql
            FOREACH aglg018_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg018_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg018_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg018_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-C10036-----add----str--
    DEFINE l_unit      STRING
    DEFINE l_per_l     LIKE type_file.num20_6
    DEFINE l_per_l_2   LIKE type_file.num20_6
    DEFINE l_per_r     LIKE type_file.num20_6
    DEFINE l_per_r_2   LIKE type_file.num20_6
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_lastday   LIKE type_file.dat       
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_display3  LIKE type_file.chr1
    DEFINE l_display4  LIKE type_file.chr1
    DEFINE l_fmt       STRING
    #FUN-C10036-----add----end--

    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-C10036 add g_ptime,g_user_name
            PRINTX tm.*
              

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C10036------add---str--
            LET l_lastday = MDY(tm.em1,'1',tm.yy1)
            LET l_lastday = s_last(l_lastday)
            PRINTX l_lastday

            LET l_fmt = cl_gr_numfmt("type_file","num20_6",tm.e)
            PRINTX l_fmt

            IF cl_null(sr1.per_l) THEN
               LET l_display1 = 'N'
            ELSE
               LET l_display1 = 'Y'
            END IF
            PRINTX l_display1

            IF cl_null(sr1.per_l_2) THEN
               LET l_display2 = 'N'
            ELSE
               LET l_display2 = 'Y'
            END IF
            PRINTX l_display2

            IF cl_null(sr1.per_r) THEN
               LET l_display3 = 'N'
            ELSE
               LET l_display3 = 'Y'
            END IF
            PRINTX l_display3

            IF cl_null(sr1.per_r_2) THEN
               LET l_display4 = 'N'
            ELSE
               LET l_display4 = 'Y'
            END IF
            PRINTX l_display4

            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit

            IF g_basetot1 != "" THEN
               LET l_per_l = (sr1.bal_l/g_basetot1) * 100
            ELSE
               LET l_per_l = ""
            END IF
            PRINTX l_per_l

            IF g_basetot1 != "" THEN
               LET l_per_l_2 = (sr1.bal_l_2/g_basetot1) * 100
            ELSE
               LET l_per_l_2 = ""
            END IF
            PRINTX l_per_l_2

           IF g_basetot1 != "" THEN
              LET l_per_r = (sr1.bal_r/g_basetot1) * 100
           ELSE
              LET l_per_r = ""
           END IF
           PRINTX l_per_r

           IF g_basetot1 != "" THEN
              LET l_per_r_2 = (sr1.bal_r_2/g_basetot1) * 100
           ELSE
              LET l_per_r_2 = ""
           END IF
           PRINTX l_per_r_2

           IF l_lineno = 1 THEN
              IF sr1.maj03_l = "3" OR sr1.maj03_l = "4" OR sr1.maj03_r = "3" OR sr1.maj03_r ="4" THEN 
                 LET l_display = "N"
              ELSE
                 LET l_display = "Y"
              END IF
           ELSE
              IF (sr1.maj03_l = "3" OR sr1.maj03_l = "4") AND (sr1.maj03_r ="3" OR sr1.maj03_r ="4") THEN 
                 LET l_display = "N" 
              ELSE 
                 LET l_display = "Y"
              END IF
           END IF
           PRINTX l_display
  
           #FUN-C10036------add---end--

            PRINTX sr1.*


        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C20073
