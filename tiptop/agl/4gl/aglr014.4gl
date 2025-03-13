# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aglr014.4gl
# Descriptions...: 合併多維度異動碼財務報表
# Input parameter: 
# Return code....: 
# Date & Author..: 11/01/07 FUN-AA0056 BY Summer
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO:FUN-BA0111 12/04/17 By Belle  增加異動碼1~4
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm  RECORD
              wc      STRING,
              rtype   LIKE type_file.chr1,       #報表類型
              axa01   LIKE axa_file.axa01,       #族群代號
              axa02   LIKE axa_file.axa02,       #上層公司
              axa03   LIKE axa_file.axa03,       #帳別
              a       LIKE mai_file.mai01,       #報表代號
              b       LIKE aaa_file.aaa01,       #合併帳別
              yy      LIKE type_file.num5,       #輸入年度
              axa06   LIKE axa_file.axa06,       #編製合併期別
              em      LIKE type_file.num5,       #截止期別
              q1      LIKE type_file.chr1,       #季
              h1      LIKE type_file.chr1,       #半年
              e       LIKE type_file.num5,       #小數位數
              f       LIKE type_file.num5,       #列印最小階數
              d       LIKE type_file.chr1,       #金額單位
              c       LIKE type_file.chr1,       #列印餘額為零者
              h       LIKE type_file.chr4,       #列印額外名稱
              o       LIKE type_file.chr1,       #轉換幣別
              r       LIKE azi_file.azi01,       #總帳幣別
              p       LIKE azi_file.azi01,       #轉換幣別
              q       LIKE azj_file.azj03,       #乘匯率
              more    LIKE type_file.chr1        #其它特殊列印條件
           END RECORD,
       g_unit         LIKE type_file.num10,        #金額單位基數
       g_bookno       LIKE axh_file.axh00,         #帳別
       g_mai02        LIKE mai_file.mai02,
       g_mai03        LIKE mai_file.mai03,
       g_tot1         ARRAY[100] OF LIKE type_file.num20_6
DEFINE g_aaa03        LIKE aaa_file.aaa03   
DEFINE g_msg          LIKE type_file.chr1000
DEFINE x_aaa03        LIKE aaa_file.aaa03          #幣別
DEFINE l_table        STRING
DEFINE g_sql          STRING
DEFINE g_str          STRING
DEFINE g_dbs_axz03    STRING             
DEFINE g_aaz641       LIKE aaz_file.aaz641
DEFINE l_length       LIKE type_file.num5 
DEFINE g_axa05        LIKE axa_file.axa05  

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)      # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
   LET tm.axa01 = ARG_VAL(9)
   LET tm.axa02 = ARG_VAL(10)
   LET tm.axa03 = ARG_VAL(11)
   LET tm.a     = ARG_VAL(12)
   LET tm.b     = ARG_VAL(13)
   LET tm.yy    = ARG_VAL(14)
   LET tm.axa06 = ARG_VAL(15)
   LET tm.em = ARG_VAL(16)
   LET tm.q1 = ARG_VAL(17)
   LET tm.h1 = ARG_VAL(18)
   LET tm.e  = ARG_VAL(19)
   LET tm.f  = ARG_VAL(20)
   LET tm.d  = ARG_VAL(21)
   LET tm.c  = ARG_VAL(22)
   LET tm.h  = ARG_VAL(23)
   LET tm.o  = ARG_VAL(24)
   LET tm.r  = ARG_VAL(25)
   LET tm.p  = ARG_VAL(26)
   LET tm.q  = ARG_VAL(27)
   LET g_rep_user = ARG_VAL(28)
   LET g_rep_clas = ARG_VAL(29)
   LET g_template = ARG_VAL(30)
   LET g_rpt_name = ARG_VAL(31)

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
               "aeii05.aeii_file.aeii05,",
               "aeii06.aeii_file.aeii06,",
               "aeii07.aeii_file.aeii07,",
               "aeii08.aeii_file.aeii08,",
               "amt.aeh_file.aeh11,",
               "l_aeii05.ahe_file.ahe02,",
               "l_aeii06.ahe_file.ahe02,",
               "l_aeii07.ahe_file.ahe02,",
               "l_aeii08.ahe_file.ahe02,"
              ,"aeii19.aeii_file.aeii19,"   #FUN-BA0111
              ,"aeii20.aeii_file.aeii20,"   #FUN-BA0111
              ,"aeii21.aeii_file.aeii21,"   #FUN-BA0111
              ,"aeii22.aeii_file.aeii22,"   #FUN-BA0111
   
   LET l_table = cl_prt_temptable('aglr014',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #FUN-BA0111
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r014_tm()
   ELSE
      CALL r014()
   END IF   

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r014_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_sw           LIKE type_file.chr1          #重要欄位是否空白
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5   
   DEFINE l_dbs          LIKE type_file.chr21  
   DEFINE l_aaa05        LIKE aaa_file.aaa05   
   DEFINE l_aznn01       LIKE aznn_file.aznn01 
   DEFINE l_axz03        LIKE axz_file.axz03          #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r014_w AT p_row,p_col WITH FORM "agl/42f/aglr014" 
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
   
   LET tm.b = g_bookno
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
            CALL r014_set_entry() 
            
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

      END INPUT
           
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr014_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      
     #CONSTRUCT BY NAME tm.wc ON aeii05,aeii06,aeii07,aeii08    #FUN-BA0111
      CONSTRUCT BY NAME tm.wc ON aeii19,aeii20,aeii21,aeii22    #FUN-BA0111
                                ,aeii05,aeii06,aeii07,aeii08    #FUN-BA0111
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

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
         CLOSE WINDOW aglr014_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      
      DISPLAY BY NAME tm.more
 
      LET l_sw = 1      

      INPUT BY NAME tm.axa01,tm.axa02,tm.axa03,
                    tm.a,tm.b,tm.yy,tm.em,tm.q1,tm.h1,
                    tm.e,tm.f,tm.d,tm.c,tm.h,
                    tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS  

         BEFORE INPUT
            CALL cl_qbe_init()
            CALL r014_set_entry()
            CALL r014_set_no_entry()

         AFTER FIELD axa01
            IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
            SELECT COUNT(*) INTO l_cnt FROM axa_file 
             WHERE axa01=tm.axa01
            IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
            LET tm.axa06 = '2'
            SELECT axa05,axa06 
              INTO g_axa05,tm.axa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'   #最上層公司否
            DISPLAY BY NAME tm.axa06
            CALL r014_set_entry()
            CALL r014_set_no_entry()
            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET l_aaa05 = 0
                SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                 WHERE aaa01=tm.b 
                   AND aaaacti IN ('Y','y')
                LET tm.em = l_aaa05
            END IF
            IF tm.axa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.axa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1

         AFTER FIELD q1    #季
            IF cl_null(tm.q1) AND  tm.axa06 = '2' THEN
               NEXT FIELD q1
            END IF
            IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
               NEXT FIELD q1
            END IF

         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF

         AFTER FIELD axa02
           IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
           SELECT COUNT(*) INTO l_cnt FROM axa_file
            WHERE axa01=tm.axa01 AND axa02=tm.axa02
           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
           IF l_cnt <=0  THEN 
              CALL cl_err(tm.axa02,'agl-223',0) NEXT FIELD axa02
              NEXT FIELD axa02 
           ELSE 
              SELECT axa03 INTO tm.axa03 FROM axa_file
               WHERE axa01=tm.axa01 AND axa02=tm.axa02
              DISPLAY BY NAME tm.axa03
           END IF

           CALL  s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
           CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641
           LET tm.b = g_aaz641  #合併帳別
           DISPLAY BY NAME tm.b

           SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02  
           LET tm.r = x_aaa03
           LET tm.p = x_aaa03
           SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = x_aaa03
           DISPLAY BY NAME tm.r
           DISPLAY BY NAME tm.p
           DISPLAY BY NAME tm.e
           SELECT azi03,azi04,azi05 
             INTO g_azi03,g_azi04,g_azi05
             FROM azi_file WHERE azi01 = x_aaa03
           IF cl_null(g_azi03) THEN LET g_azi03 = 0 END IF
           IF cl_null(g_azi04) THEN LET g_azi05 = 0 END IF
           IF cl_null(g_azi05) THEN LET g_azi05 = 0 END IF
           IF NOT cl_null(g_dbs_axz03) THEN
              LET l_length = LENGTH(g_dbs_axz03)
              IF l_length > 1 THEN
                 LET l_dbs = g_dbs_axz03.subSTRING(1,l_length-1)
              END IF
           ELSE
              LET l_dbs=g_dbs
           END IF

        #No.TQC-C50042   ---start---   Add
         AFTER FIELD a
            IF tm.a IS NULL THEN NEXT FIELD a END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
               CALL cl_err(tm.a,g_errno,1)
               NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = g_aaz641
               AND maiacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)
               NEXT FIELD a
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
            END IF
        #No.TQC-C50042   ---end---     Add


        AFTER FIELD axa03
           IF cl_null(tm.axa03) THEN NEXT FIELD axa03 END IF
           SELECT COUNT(*) INTO l_cnt FROM axa_file
            WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
           IF l_cnt <=0  THEN 
              CALL cl_err(tm.axa03,'agl-223',0) NEXT FIELD axa03
              NEXT FIELD axa03 
           END IF

        ON CHANGE a
           IF tm.a IS NULL THEN NEXT FIELD a END IF
           CALL s_chkdbs_mai(tm.a,'RGL',g_dbs_axz03) RETURNING li_result
           IF NOT li_result THEN
             CALL cl_err(tm.a,g_errno,1)
             NEXT FIELD a
           END IF
           LET g_sql = "SELECT mai02,mai03 FROM ",cl_get_target_table(g_dbs_axz03, 'mai_file'),
                       " WHERE mai01 = '",tm.a,"'",
                       "   AND mai00 = '",tm.b,"'",
                       "   AND maiacti IN ('Y','y')"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_dbs_axz03) RETURNING g_sql
           PREPARE r014_pre FROM g_sql
           DECLARE r014_cur CURSOR FOR r014_pre
           OPEN r014_cur
           FETCH r014_cur INTO g_mai02,g_mai03
           IF STATUS THEN 
              CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)
              NEXT FIELD a 
           END IF

        AFTER FIELD b
           IF tm.b IS NULL THEN NEXT FIELD b END IF
           LET l_aaa05 = 0
           SELECT aaa05 INTO l_aaa05 FROM aaa_file                                                                                    
            WHERE aaa01=tm.b                                                                                                          
              AND aaaacti IN ('Y','y')
           LET tm.em = l_aaa05                                                                                                        
           DISPLAY tm.em TO em

        AFTER FIELD c
           IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

        AFTER FIELD yy
           IF tm.yy IS NULL OR tm.yy = 0 THEN
              NEXT FIELD yy
           END IF

        AFTER FIELD em
           IF NOT cl_null(tm.em) THEN
              SELECT azm02 INTO g_azm.azm02 FROM azm_file
               WHERE azm01 = tm.yy
              IF g_azm.azm02 = 1 THEN
                 IF tm.em > 12 OR tm.em < 0 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD em
                 END IF
              ELSE
                 IF tm.em > 13 OR tm.em < 0 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD em
                 END IF
              END IF
           END IF

        AFTER FIELD d
           IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
              NEXT FIELD d
           END IF
           CASE 
              WHEN tm.d = '1' 
                 LET g_unit = 1
              WHEN tm.d = '2' 
                 LET g_unit = 1000
              WHEN tm.d = '3' 
                 LET g_unit = 1000000
           END CASE

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
              LET tm.p = x_aaa03
              LET tm.q = 1
              DISPLAY g_aaa03 TO p   
              DISPLAY BY NAME tm.q
           END IF

        BEFORE FIELD p
           IF tm.o = 'N' THEN NEXT FIELD more END IF

        AFTER FIELD p
           SELECT azi01 FROM azi_file WHERE azi01 = tm.p AND aziacti = 'Y'
           IF SQLCA.sqlcode THEN 
              CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
              NEXT FIELD p
           END IF
           IF tm.o = 'Y' THEN
              SELECT azi03,azi04,azi05 
                INTO g_azi03,g_azi04,g_azi05
                FROM azi_file WHERE azi01 = tm.p
              IF cl_null(g_azi03) THEN LET g_azi03 = 0 END IF
              IF cl_null(g_azi04) THEN LET g_azi05 = 0 END IF
              IF cl_null(g_azi05) THEN LET g_azi05 = 0 END IF
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

           CASE 
              WHEN tm.d = '1' 
                 LET g_unit = 1
              WHEN tm.d = '2' 
                 LET g_unit = 1000
              WHEN tm.d = '3' 
                 LET g_unit = 1000000
           END CASE
           IF NOT cl_null(tm.axa06) THEN
              CASE
                 WHEN tm.axa06 = '1'  #月 
                    
                #CHI-B10030 add --start--
                 OTHERWISE      
                      CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                      CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                #CHI-B10030 add --end--
                #CHI-B10030 mark --start--
                #WHEN tm.axa06 = '2'  #季 
                #   SELECT MAX(aznn01) INTO l_aznn01
                #     FROM aznn_file
                #    WHERE aznn00 = tm.axa03
                #      AND aznn02 = tm.yy
                #      AND aznn03 = tm.q1
                #   LET tm.em = MONTH(l_aznn01)
                #WHEN tm.axa06 = '3'  #半年
                #   IF tm.h1 = '1' THEN  #上半年
                #      SELECT MAX(aznn01) INTO l_aznn01
                #        FROM aznn_file
                #       WHERE aznn00 = tm.axa03
                #         AND aznn02 = tm.yy
                #         AND aznn03 < 3
                #   ELSE                 #下半年
                #      SELECT MAX(aznn01) INTO l_aznn01
                #        FROM aznn_file
                #       WHERE aznn00 = tm.axa03
                #         AND aznn02 = tm.yy
                #         AND aznn03 >='3' #大於等於第三季
                #   END IF
                #   LET tm.em = MONTH(l_aznn01)
                #WHEN tm.axa06 = '4'  #年
                #   SELECT MAX(aznn01) INTO l_aznn01
                #     FROM aznn_file
                #    WHERE aznn00 = tm.axa03
                #      AND aznn02 = tm.yy
                #   LET tm.em = MONTH(l_aznn01)
                #CHI-B10030 mark --end--
              END CASE
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(axa01) OR INFIELD(axa02)
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
                 LET g_qryparam.form = 'q_aaa5'
                 LET g_qryparam.default1 = tm.b
                 LET g_qryparam.arg1 = l_dbs
                 CALL cl_create_qry() RETURNING tm.b                             
                 DISPLAY BY NAME tm.b                                            
                 NEXT FIELD b                                                    
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
         LET INT_FLAG = 0 CLOSE WINDOW r014_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr014'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr014','9031',1)  
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
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.axa06 CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.q1 CLIPPED,"'",    
                        " '",tm.h1 CLIPPED,"'",
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
                        " '",g_template CLIPPED,"'"

            CALL cl_cmdat('aglr014',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r014_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r014()
    
      ERROR ""
   END WHILE
   CLOSE WINDOW r014_w
END FUNCTION

FUNCTION r014()
   DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE g_i       LIKE type_file.num5   
   DEFINE sr        RECORD
                       aeii05      LIKE aeii_file.aeii05,
                       aeii06      LIKE aeii_file.aeii06,
                       aeii07      LIKE aeii_file.aeii07,
                       aeii08      LIKE aeii_file.aeii08,
                       amt         LIKE aeii_file.aeii11
                      ,aeii19      LIKE aeii_file.aeii19    #FUN-BA0111
                      ,aeii20      LIKE aeii_file.aeii20    #FUN-BA0111
                      ,aeii21      LIKE aeii_file.aeii21    #FUN-BA0111
                      ,aeii22      LIKE aeii_file.aeii22    #FUN-BA0111
                    END RECORD
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE i,k       LIKE type_file.num5
   DEFINE l_aeii05  LIKE ahe_file.ahe02
   DEFINE l_aeii06  LIKE ahe_file.ahe02
   DEFINE l_aeii07  LIKE ahe_file.ahe02
   DEFINE l_aeii08  LIKE ahe_file.ahe02
   DEFINE l_i_cnt05 LIKE type_file.num5
   DEFINE l_i_cnt06 LIKE type_file.num5
   DEFINE l_i_cnt07 LIKE type_file.num5
   DEFINE l_i_cnt08 LIKE type_file.num5   

   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang

   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1'
        #  LET g_msg=" substr(maj23,1,1)='1'"
           LET g_msg=" maj23[1,1]='1'"   #FUN-B40029
        WHEN tm.rtype='2'
        #  LET g_msg=" substr(maj23,1,1)='2'"
           LET g_msg=" maj23[1,1]='2'"   #FUN-B40029
        OTHERWISE LET g_msg = " 1=1" 
   END CASE
    LET l_sql = "SELECT * FROM ",cl_get_target_table(g_dbs_axz03, 'maj_file'),
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_dbs_axz03) RETURNING l_sql
   PREPARE r014_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE r014_c CURSOR FOR r014_p
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR


   LET g_pageno = 0
   FOREACH r014_c INTO maj.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     
     LET l_flag='Y'
     LET sr.aeii05 = ''
     LET sr.aeii06 = ''
     LET sr.aeii07 = ''
     LET sr.aeii08 = ''
     LET sr.amt = 0
     LET sr.aeii19 = ''   #FUN-BA0111
     LET sr.aeii20 = ''   #FUN-BA0111
     LET sr.aeii21 = ''   #FUN-BA0111
     LET sr.aeii22 = ''   #FUN-BA0111
     
     IF NOT cl_null(maj.maj21) THEN
        IF cl_null(maj.maj22) THEN LET maj.maj22 = maj.maj21 END IF
        
        
        LET l_sql = "SELECT aeii05,aeii06,aeii07,aeii08,SUM(aeii11-aeii12)",
                    "      ,aeii19,aeii20,aeii21,aeii22",         #FUN-BA0111
                    "  FROM aeii_file,aag_file",
                    " WHERE aeii00 = '",tm.b,"'",
                    "   AND aeii01 = '",tm.axa01,"'",
                    "   AND aeii02 = '",tm.axa02,"'",
                    "   AND aeii021 = '",tm.axa03,"'",
                    "   AND aeii04 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
                    "   AND aeii00 = aag00",
                    "   AND aag00 = '",tm.b,"'",    
                    "   AND aeii09 = ",tm.yy,
                    "   AND aeii10 = ",tm.em, 
                    "   AND aeii04 = aag01 AND aag07 <> '1'",
                    "   AND aeii18 = '",x_aaa03,"'",
                    "   AND ",tm.wc CLIPPED,
                    " GROUP BY aeii05,aeii06,aeii07,aeii08 "
                   ,"         ,aeii19,aeii20,aeii21,aeii22 "         #FUN-BA0111
        PREPARE r014_prepare1 FROM l_sql                                                                                          
        DECLARE r014_c1  CURSOR FOR r014_prepare1                                                                                 
        FOREACH r014_c1 INTO sr.*
            LET l_flag='N'

            #-->匯率的轉換
            IF tm.o = 'Y' THEN LET sr.amt = sr.amt * tm.q END IF 

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
               
               FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
            ELSE
               IF maj.maj03 <> '5' THEN
                  LET sr.amt = NULL
               END IF
            END IF
            
            IF maj.maj07 = '2' THEN
               LET sr.amt = sr.amt * -1
            END IF

            IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
            
            #-->餘額為 0 者不列印
            IF (tm.c='N' OR maj.maj03='2') AND
               maj.maj03 MATCHES "[0125]" AND sr.amt=0 THEN
               CONTINUE FOREACH                        
            END IF
            
            #-->最小階數起列印
            IF tm.f>0 AND maj.maj08 < tm.f THEN
               CONTINUE FOREACH                        
            END IF

            #-->列印額外名稱
            IF tm.h = 'Y' THEN
                LET maj.maj20 = maj.maj20e 
            END IF
            LET maj.maj20 = maj.maj05 SPACES,maj.maj20
            LET sr.amt=sr.amt/g_unit
            
            CALL r014_ahe02(g_aaz.aaz121) RETURNING l_aeii05
            CALL r014_ahe02(g_aaz.aaz122) RETURNING l_aeii06
            CALL r014_ahe02(g_aaz.aaz123) RETURNING l_aeii07
            CALL r014_ahe02(g_aaz.aaz124) RETURNING l_aeii08
            
            EXECUTE insert_prep USING                                              
                     maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'2',
                     sr.aeii05,sr.aeii06,sr.aeii07,sr.aeii08,sr.amt,
                     l_aeii05,l_aeii06,l_aeii07,l_aeii08
                    ,sr.aeii19,sr.aeii20,sr.aeii21,sr.aeii22   #FUN-BA0111
             IF maj.maj04 > 0 THEN                                                     
                #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
                #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
                #讓空行的這筆資料排在正常的資料前面印出
                FOR i = 1 TO maj.maj04                                                 
                EXECUTE insert_prep USING                                              
                        maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'1',
                        sr.aeii05,sr.aeii06,sr.aeii07,sr.aeii08,sr.amt,
                        l_aeii05,l_aeii06,l_aeii07,l_aeii08                                                         
                       ,sr.aeii19,sr.aeii20,sr.aeii21,sr.aeii22  #FUN-BA0111
                END FOR                                                                
             END IF            
        END FOREACH
        IF sr.aeii05 IS NULL THEN LET sr.aeii05 = '' END IF
        IF sr.aeii06 IS NULL THEN LET sr.aeii06 = '' END IF
        IF sr.aeii07 IS NULL THEN LET sr.aeii07 = '' END IF
        IF sr.aeii08 IS NULL THEN LET sr.aeii08 = '' END IF
        IF sr.amt IS NULL THEN LET sr.amt = 0 END IF    
     END IF

     IF l_flag='Y' THEN                
     
        #-->匯率的轉換
        IF tm.o = 'Y' THEN LET sr.amt = sr.amt * tm.q END IF 

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
           
           FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
        ELSE
           IF maj.maj03 <> '5' THEN
              LET sr.amt = NULL
           END IF
        END IF
        
        IF maj.maj07 = '2' THEN
           LET sr.amt = sr.amt * -1
        END IF

        IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
        
        #-->餘額為 0 者不列印
        IF (tm.c='N' OR maj.maj03='2') AND
           maj.maj03 MATCHES "[0125]" AND sr.amt=0 THEN
           CONTINUE FOREACH                        
        END IF
        
        #-->最小階數起列印
        IF tm.f>0 AND maj.maj08 < tm.f THEN
           CONTINUE FOREACH                        
        END IF

        #-->列印額外名稱
        IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e 
        END IF
        LET maj.maj20 = maj.maj05 SPACES,maj.maj20
        LET sr.amt=sr.amt/g_unit
        
        CALL r014_ahe02(g_aaz.aaz121) RETURNING l_aeii05
        CALL r014_ahe02(g_aaz.aaz122) RETURNING l_aeii06
        CALL r014_ahe02(g_aaz.aaz123) RETURNING l_aeii07
        CALL r014_ahe02(g_aaz.aaz124) RETURNING l_aeii08
        
        EXECUTE insert_prep USING                                              
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'2',
                 sr.aeii05,sr.aeii06,sr.aeii07,sr.aeii08,sr.amt,
                 l_aeii05,l_aeii06,l_aeii07,l_aeii08
                ,sr.aeii19,sr.aeii20,sr.aeii21,sr.aeii22       #FUN-BA0111
         IF maj.maj04 > 0 THEN                                                     
            #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
            #讓空行的這筆資料排在正常的資料前面印出
            FOR i = 1 TO maj.maj04                                                 
            EXECUTE insert_prep USING                                              
                    maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'1',
                    sr.aeii05,sr.aeii06,sr.aeii07,sr.aeii08,sr.amt,
                    l_aeii05,l_aeii06,l_aeii07,l_aeii08                                                         
                   ,sr.aeii19,sr.aeii20,sr.aeii21,sr.aeii22     #FUN-BA0111
            END FOR                                                                
         END IF
      END IF      
   END FOREACH
  
   LET l_i_cnt05 = 0
   LET l_i_cnt06 = 0
   LET l_i_cnt07 = 0
   LET l_i_cnt08 = 0
   IF cl_null(l_aeii05) THEN
      LET l_i_cnt05 = l_i_cnt05 + 1
      LET l_i_cnt06 = l_i_cnt06 + 1
      LET l_i_cnt07 = l_i_cnt07 + 1
      LET l_i_cnt08 = l_i_cnt08 + 1
   END IF
   IF cl_null(l_aeii06) THEN
      LET l_i_cnt06 = l_i_cnt06 + 1
      LET l_i_cnt07 = l_i_cnt07 + 1
      LET l_i_cnt08 = l_i_cnt08 + 1
   END IF
   IF cl_null(l_aeii07) THEN
      LET l_i_cnt07 = l_i_cnt07 + 1
      LET l_i_cnt08 = l_i_cnt08 + 1
   END IF
   IF cl_null(l_aeii08) THEN
      LET l_i_cnt08 = l_i_cnt08 + 1
   END IF  

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = g_mai02,";",tm.a,";",tm.e,";",l_i_cnt05,";",l_i_cnt06,";",
               l_i_cnt07,";",l_i_cnt08
 
   CALL cl_prt_cs3('aglr014','aglr014',g_sql,g_str)
     
END FUNCTION

FUNCTION r014_ahe02(p_giu)
 DEFINE  p_giu     LIKE giu_file.giu15,
         l_ahe02   LIKE ahe_file.ahe02

 SELECT ahe02 INTO l_ahe02 FROM ahe_file
  WHERE ahe01 = p_giu

 RETURN l_ahe02

END FUNCTION

FUNCTION r014_set_entry()
  CALL cl_set_comp_entry("q1,em,h1",TRUE)
END FUNCTION

FUNCTION r014_set_no_entry()
   IF tm.axa06 ="1" THEN  #月
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN  #季
      CALL cl_set_comp_entry("em,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN  #半年
      CALL cl_set_comp_entry("em,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN  #年
      CALL cl_set_comp_entry("q1,em,h1",FALSE)
   END IF
END FUNCTION
#FUN-AA0056
