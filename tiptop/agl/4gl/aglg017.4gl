# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglg017.4gl
# Descriptions...: 合併換匯後科目餘額檢核表
# Input parameter: 
# Return code....: 
# Date & Author..: 11/01/07 FUN-AB0026 BY Summer
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.FUN-B50001 11/05/10 By lutingting參數檔agls101替換為aaw_file
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B80161 11/09/09 By chenying 明細CR轉GR
# Modify.........: No.FUN-B80161 12/01/05 By qirl FUN-BB0047追单
# Modify.........: No.FUN-C50004 12/05/07 By nanbing GR優化
# Modify.........: No.FUN-C30085 12/06/25 By qirl  GR修改
# Modify.........: NO.FUN-CB0058 12/11/23 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
              yy        LIKE type_file.num5,   #匯入會計年度  
              em        LIKE type_file.num5,   #截止期間     
              axa01     LIKE axa_file.axa01,   #族群代號
              axa02     LIKE axa_file.axa02,   #上層公司編號
              axa03     LIKE axa_file.axa03,   #帳別
              axa06     LIKE axa_file.axa06,  
              q1        LIKE type_file.chr1,  
              h1        LIKE type_file.chr1,  
              t         LIKE type_file.chr1    #報表選項1.換匯後科餘檢核表 2.換匯後異動碼科餘檢核表
           END RECORD,
       g_aaa04        LIKE aaa_file.aaa04,      #現行會計年度
       g_aaa05        LIKE aaa_file.aaa05,      #現行期別           
       g_bookno       LIKE axh_file.axh00,       #帳別
       g_change_lang  LIKE type_file.chr1
DEFINE g_dbs_axz03    LIKE type_file.chr21
#DEFINE g_aaz641       LIKE aaz_file.aaz641   #FUN-B5001
DEFINE g_aaw01       LIKE aaw_file.aaw01
DEFINE g_axa06        LIKE axa_file.axa06    
DEFINE g_axa05        LIKE axa_file.axa05       
DEFINE g_cnt              LIKE type_file.num10       
DEFINE l_table        STRING
DEFINE l_table1       STRING
DEFINE g_sql          STRING
DEFINE g_str          STRING

###GENGRE###START
TYPE sr1_t RECORD
    axg01 LIKE axg_file.axg01,
    axg02 LIKE axg_file.axg02,
    axz02 LIKE axz_file.axz02, #FUN-C50004 add
    axg04 LIKE axg_file.axg04,
    axz02_1  LIKE axz_file.axz02, #FUN-C50004 add
    axg05 LIKE axg_file.axg05,
    aag02 LIKE aag_file.aag02,
    axg13 LIKE axg_file.axg13,
    axg14 LIKE axg_file.axg14,
    amt1 LIKE type_file.num20_6,
    axg18 LIKE axg_file.axg18,
    axg15 LIKE axg_file.axg15,
    axg16 LIKE axg_file.axg16,
    amt2 LIKE type_file.num20_6,
    axg12 LIKE axg_file.axg12,
    axg19 LIKE axg_file.axg19,
    axg08 LIKE axg_file.axg08,
    axg09 LIKE axg_file.axg09,
    amt3 LIKE type_file.num20_6,
    l_axz06 LIKE axz_file.axz06,
    l_axz07 LIKE axz_file.axz07
END RECORD

TYPE sr2_t RECORD
    axk01 LIKE axk_file.axk01,
    axk02 LIKE axk_file.axk02,
    axz02 LIKE axz_file.axz02, #FUN-C50004 add
    axk04 LIKE axk_file.axk04,
    axz02_1  LIKE axz_file.axz02, #FUN-C50004 add
    axk05 LIKE axk_file.axk05,
    aag02_1 LIKE aag_file.aag02,
    axk06 LIKE axk_file.axk06,
    axk07 LIKE axk_file.axk07,
    axk18 LIKE axk_file.axk18,
    axk19 LIKE axk_file.axk19,
    amt4 LIKE type_file.num20_6,
    axk16 LIKE axk_file.axk16,
    axk20 LIKE axk_file.axk20,
    axk21 LIKE axk_file.axk21,
    amt5 LIKE type_file.num20_6,
    axk14 LIKE axk_file.axk14,
    axk17 LIKE axk_file.axk17,
    axk10 LIKE axk_file.axk10,
    axk11 LIKE axk_file.axk11,
    amt6 LIKE type_file.num20_6,
    l_axz06 LIKE axz_file.axz06,
    l_axz07 LIKE axz_file.axz07
    
    
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   
   
   LET g_pdate  = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)

   LET tm.axa01 = ARG_VAL(7)
   LET tm.axa02 = ARG_VAL(8)
   LET tm.axa03 = ARG_VAL(9)
   LET tm.yy    = ARG_VAL(10)
   LET tm.axa06 = ARG_VAL(11)
   LET tm.em    = ARG_VAL(12)
   LET tm.q1    = ARG_VAL(13)
   LET tm.h1    = ARG_VAL(14)
   LET tm.t     = ARG_VAL(15)
   
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)
   
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B80161 mark   
   LET g_sql = "axg01.axg_file.axg01,",
               "axg02.axg_file.axg02,",
               "axz02.axz_file.axz02,", #FUN-C50004 add
               "axg04.axg_file.axg04,",
               "axz02_1.axz_file.axz02,", #FUN-C50004 add
               "axg05.axg_file.axg05,",
               "aag02.aag_file.aag02,",
               "axg13.axg_file.axg13,",
               "axg14.axg_file.axg14,",
               "amt1.type_file.num20_6,",
               "axg18.axg_file.axg18,",
               "axg15.axg_file.axg15,",
               "axg16.axg_file.axg16,",
               "amt2.type_file.num20_6,",
               "axg12.axg_file.axg12,",
               "axg19.axg_file.axg19,",
               "axg08.axg_file.axg08,",
               "axg09.axg_file.axg09,",
               "amt3.type_file.num20_6,",
               "l_axz06.axz_file.axz06,",
               "l_axz07.axz_file.axz07"
               
               
   
   LET l_table = cl_prt_temptable('aglg017',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #FUN-B80161 add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add
      EXIT PROGRAM 
   END IF

   LET g_sql = "axk01.axk_file.axk01,",
               "axk02.axk_file.axk02,",
               "axz02.axz_file.axz02,", #FUN-C50004 add
               "axk04.axk_file.axk04,",
               "axz02_1.axz_file.axz02,", #FUN-C50004 add
               "axk05.axk_file.axk05,",
               "aag02_1.aag_file.aag02,",
               "axk06.axk_file.axk06,",
               "axk07.axk_file.axk07,",
               "axk18.axk_file.axk18,",
               "axk19.axk_file.axk19,",
               "amt4.type_file.num20_6,",
               "axk16.axk_file.axk16,",
               "axk20.axk_file.axk20,",
               "axk21.axk_file.axk21,",
               "amt5.type_file.num20_6,",
               "axk14.axk_file.axk14,",
               "axk17.axk_file.axk17,",
               "axk10.axk_file.axk10,",
               "axk11.axk_file.axk11,",
               "amt6.type_file.num20_6,",
               "l_axz06.axz_file.axz06,",
               "l_axz07.axz_file.axz07"
   
   LET l_table1 = cl_prt_temptable('aglg017_1',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table1 = -1 THEN 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #FUN-B80161 add
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add
      EXIT PROGRAM 
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B80161 add
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL g017_tm()
   ELSE
      IF tm.t = '1' THEN
         CALL g017_1()
      ELSE
         CALL g017_2()
      END IF
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add 
END MAIN

FUNCTION g017_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_axa03        LIKE axa_file.axa03
   DEFINE l_aznn01      LIKE aznn_file.aznn01
   DEFINE l_axz03        LIKE axz_file.axz03          #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW g017_w AT p_row,p_col WITH FORM "agl/42f/aglg017" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   
   WHILE TRUE

      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05   
        FROM aaa_file 
       WHERE aaa01 = g_bookno

      LET tm.yy = g_aaa04
      LET tm.t = '1'
      LET g_bgjob = 'N'
      LET g_pdate = g_today #FUN-B80161 add

      INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,tm.t WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_init()
            CALL g017_set_entry()    
            CALL g017_set_no_entry() 

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
            
         AFTER FIELD q1    #季
             IF cl_null(tm.q1) AND  g_axa06 = '2' THEN 
                NEXT FIELD q1 
             END IF
             IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
                NEXT FIELD q1
             END IF
 
         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
           
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01 #no.6155
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)  #No.FUN-660123
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02  #公司編號
            IF NOT cl_null(tm.axa02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
               END IF
               SELECT DISTINCT axa03 INTO l_axa03 FROM axa_file
                WHERE axa01=tm.axa01  
                  AND axa02=tm.axa02 
               LET tm.axa03 = l_axa03 
               DISPLAY l_axa03 TO axa03  
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03  
               #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641         #FUN-B50001 
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
            END IF
            DISPLAY l_axa03 TO axa03 

            SELECT axa05,axa06 
              INTO g_axa05,g_axa06  #編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'          #最上層公司否
            LET tm.axa06 = g_axa06
            DISPLAY BY NAME tm.axa06
            CALL g017_set_entry()    
            CALL g017_set_no_entry()

            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
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

         AFTER INPUT
            IF NOT cl_null(tm.axa06) THEN
               #CHI-B10030 add --start--
               IF tm.axa06 MATCHES '[234]' THEN
                  CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                  CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
               END IF
               #CHI-B10030 add --end--
               #CHI-B10030 mark --start--
               #CASE
               #    WHEN tm.axa06 = '2'  #季 
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.axa03
               #            AND aznn02 = tm.yy
               #            AND aznn03 = tm.q1
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.axa06 = '3'  #半年
               #         IF tm.h1 = '1' THEN  #上半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.axa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 < 3
               #         ELSE                 #下半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.axa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 >='3' #大於等於第三季
               #         END IF
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.axa06 = '4'  #年
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.axa03
               #            AND aznn02 = tm.yy
               #         LET tm.em = MONTH(l_aznn01)
               #END CASE
               #CHI-B10030 mark --end--
            END IF            
  
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
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
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g017_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg017'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg017','9031',1)  
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.axa01,"'", 
                        " '",tm.axa02,"'", 
                        " '",tm.axa03,"'", 
                        " '",tm.yy,"'",    
                        " '",tm.axa06,"'", 
                        " '",tm.em,"'",    
                        " '",tm.q1,"'",    
                        " '",tm.h1,"'",  
                        " '",tm.t CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
                        
            CALL cl_cmdat('aglg017',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g017_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      IF tm.t = '1' THEN
         CALL g017_1()
      ELSE
         CALL g017_2()
      END IF
          
      ERROR ""
   END WHILE
   CLOSE WINDOW g017_w
END FUNCTION

FUNCTION g017_1()
   DEFINE l_sql     STRING
   DEFINE sr       RECORD
            axg01     LIKE axg_file.axg01,
            axg02     LIKE axg_file.axg02,
            axz02     LIKE axz_file.axz02, #FUN-C50004 add
            axg04     LIKE axg_file.axg04,
            axz02_1   LIKE axz_file.axz02, #FUN-C50004 add
            axg05     LIKE axg_file.axg05,
            aag02     LIKE aag_file.aag02,
            axg13     LIKE axg_file.axg13,
            axg14     LIKE axg_file.axg14,
            amt1      LIKE type_file.num20_6,
            axg18     LIKE axg_file.axg18,
            axg15     LIKE axg_file.axg15,
            axg16     LIKE axg_file.axg16,
            amt2      LIKE type_file.num20_6,
            axg12     LIKE axg_file.axg12,
            axg19     LIKE axg_file.axg19,
            axg08     LIKE axg_file.axg08,
            axg09     LIKE axg_file.axg09,
            amt3      LIKE type_file.num20_6
           END RECORD
   DEFINE l_gae04 LIKE gae_file.gae04
   DEFINE l_axz06 LIKE axz_file.axz06  
   DEFINE l_axz07 LIKE axz_file.axz07   
   
   CALL cl_del_data(l_table)
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ,?,?)" #FUN-C50004 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80161--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add
      EXIT PROGRAM
   END IF
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
   LET l_sql =
       # "SELECT axg01,axg02,axg04,axg05,aag02,axg13,axg14,(axg13-axg14),axg18,axg15,", #FUN-C50004 mark
        "SELECT axg01,axg02,a.axz02,axg04,b.axz02,axg05,aag02,axg13,axg14,(axg13-axg14),axg18,axg15,",#FUN-C50004 add 
       # "       axg16,(axg15-axg16),axg12,axg19,axg08,axg09,(axg08-axg09)",#FUN-C50004 mark
        "       axg16,(axg15-axg16),axg12,axg19,axg08,axg09,(axg08-axg09),b.axz06,b.axz07 ",#FUN-C50004 add
          # "  FROM axg_file,aag_file ",  #FUN-C50004 mark
        "  FROM axg_file LEFT OUTER JOIN axz_file b ON b.axz01=axg04 ", #FUN-C50004 add 
        "                LEFT OUTER JOIN axz_file a ON a.axz01=axg02,aag_file " ,#FUN-C50004 add 
        " WHERE axg00 = aag00 ",
        "   AND axg05 = aag01",
        "   AND axg01 ='",tm.axa01,"'  ",
        "   AND axg02 ='",tm.axa02,"'  ",
        "   AND axg03 ='",tm.axa03,"'  ",
        "   AND axg06 =",tm.yy,
        "   AND axg07 =",tm.em
    PREPARE g017_p1 FROM l_sql
    DECLARE g017_c1
        CURSOR FOR g017_p1

    LET g_cnt = 1
   # FOREACH g017_c1 INTO sr.* #FUN-C50004 mark
    FOREACH g017_c1 INTO sr.*,l_axz06,l_axz07 #FUN-C50004 add
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        
        #記帳幣別,功能幣別
       # SELECT axz06,axz07 INTO l_axz06,l_axz07 FROM axz_file  #FUN-C50004 mark
       #  WHERE axz01 = sr.axg04  #FUN-C50004 mark

        LET g_cnt = g_cnt + 1
        
        EXECUTE insert_prep USING                                              
                sr.*,l_axz06,l_axz07
       
    END FOREACH

   SELECT gae04 INTO l_gae04 FROM gae_file WHERE gae01='aglg017' AND gae02='t_1' AND gae03=g_rlang

###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = l_gae04,";",tm.yy,";",tm.em
 
###GENGRE###   CALL cl_prt_cs3('aglg017','aglg017',g_sql,g_str)
    LET g_template = 'aglg017'   #FUN-B80161 add
    CALL aglg017_grdata()    ###GENGRE###
     
END FUNCTION

FUNCTION g017_2()
   DEFINE l_sql     STRING   
   DEFINE sr       RECORD
            axk01     LIKE axk_file.axk01,
            axk02     LIKE axk_file.axk02,
            axz02     LIKE axz_file.axz02, #FUN-C50004 add
            axk04     LIKE axk_file.axk04,
            axz02_1   LIKE axz_file.axz02, #FUN-C50004 add
            axk05     LIKE axk_file.axk05,
            aag02_1   LIKE aag_file.aag02,
            axk06     LIKE axk_file.axk06,
            axk07     LIKE axk_file.axk07,
            axk18     LIKE axk_file.axk18,
            axk19     LIKE axk_file.axk19,
            amt4      LIKE type_file.num20_6,
            axk16     LIKE axk_file.axk16,
            axk20     LIKE axk_file.axk20,
            axk21     LIKE axk_file.axk21,
            amt5      LIKE type_file.num20_6,
            axk14     LIKE axk_file.axk14,
            axk17     LIKE axk_file.axk17,
            axk10     LIKE axk_file.axk10,
            axk11     LIKE axk_file.axk11,
            amt6      LIKE type_file.num20_6
           END RECORD
   DEFINE l_gae04 LIKE gae_file.gae04
   DEFINE l_axz06 LIKE axz_file.axz06  
   DEFINE l_axz07 LIKE axz_file.axz07  
   
   CALL cl_del_data(l_table1)
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? )" #FUN-C50004 add 2?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80161--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)             #FUN-B80161 add
      EXIT PROGRAM
   END IF    
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   LET l_sql =
      #  "SELECT axk01,axk02,axk04,axk05,aag02,axk06,axk07,axk18,axk19,(axk18-axk19),", #FUN-C50004 mark
        "SELECT axk01,axk02,a.axz02,axk04,b.axz02,axk05,aag02,axk06,axk07,axk18,axk19,(axk18-axk19),",#FUN-C50004 add 
        "       axk16,axk20,axk21,(axk20-axk21),axk14,axk17,axk10,axk11,",
      #  "       (axk10-axk11)", #FUN-C50004 mark
      #  "  FROM axk_file,aag_file ", #FUN-C50004 mark
        " (axk10-axk11),b.axz06,b.axz07 ", #FUN-C50004 add
        " FROM axk_file LEFT OUTER JOIN axz_file a ON a.axz01=axk02",#FUN-C50004 add 
        "   LEFT OUTER JOIN axz_file b ON b.axz01=axk04,aag_file ", #FUN-C50004 add 
        " WHERE axk00 = aag00 ",
        "   AND axk05 = aag01",
        "   AND axk01 ='",tm.axa01,"'  ",
        "   AND axk02 ='",tm.axa02,"'  ",
        "   AND axk03 ='",tm.axa03,"'  ",
        "   AND axk06 = '99'",
        "   AND axk08 =",tm.yy,
        "   AND axk09 =",tm.em
    PREPARE g017_p2 FROM l_sql
    DECLARE g017_c2              
        CURSOR FOR g017_p2

    LET g_cnt = 1
   # FOREACH g017_c2 INTO sr.*  #FUN-C50004 mark
    FOREACH g017_c2 INTO sr.*,l_axz06,l_axz07 #FUN-C50004 add
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        
        #記帳幣別,功能幣別
       # SELECT axz06,axz07 INTO l_axz06,l_axz07 FROM axz_file   #FUN-C50004 mark
       #  WHERE axz01 = sr.axk04  #FUN-C50004 mark

        LET g_cnt = g_cnt + 1
        
        EXECUTE insert_prep1 USING                                              
                sr.*,l_axz06,l_axz07
       
    END FOREACH
    
   SELECT gae04 INTO l_gae04 FROM gae_file WHERE gae01='aglg017' AND gae02='t_2' AND gae03=g_rlang
   
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   LET g_str = l_gae04,";",tm.yy,";",tm.em
 
###GENGRE###   CALL cl_prt_cs3('aglg017','aglg017_1',g_sql,g_str)  
    LET g_template = 'aglg017_1'   #FUN-B80161 add
    CALL aglg017_1_grdata()    ###GENGRE###

END FUNCTION

FUNCTION g017_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION g017_set_no_entry() 

      CALL cl_set_comp_entry("axa06",FALSE) 

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

#FUN-AB0026

#FUN-B80161---add-----str----
FUNCTION aglg017_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("aglg017")
        IF handler IS NOT NULL THEN
            START REPORT aglg017_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                        ," ORDER BY axk01,axk02,axk04,axk05,axk07"

            DECLARE aglg017_datacur2 CURSOR FROM l_sql
            FOREACH aglg017_datacur2 INTO sr2.*
                OUTPUT TO REPORT aglg017_1_rep(sr2.*)
            END FOREACH
            FINISH REPORT aglg017_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg017_1_rep(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_yymm    STRING
    DEFINE l_yy      STRING
    DEFINE l_em      STRING
    DEFINE sr2_o     sr2_t
    DEFINE l_display LIKE type_file.chr1
    DEFINE l_axk01     LIKE axk_file.axk01     #FUN-CB0058
    DEFINE l_axk02     LIKE axk_file.axk02     #FUN-CB0058
    DEFINE l_axk04     LIKE axk_file.axk04     #FUN-CB0058
    DEFINE l_axz02     LIKE axz_file.axz02     #FUN-CB0058
    DEFINE l_axz02_1   LIKE axz_file.axz02     #FUN-CB0058

    ORDER EXTERNAL BY sr2.axk01,sr2.axk02,sr2.axk04

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name     #FUN-B80161    add g_ptime,g_user_name
            PRINTX tm.*
            LET sr2_o.axk01 = NULL

        BEFORE GROUP OF sr2.axk01
        BEFORE GROUP OF sr2.axk02
        BEFORE GROUP OF sr2.axk04

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_yy = tm.yy
            LET l_em = tm.em
            LET l_yymm = l_yy.trim(),'/',l_em.trim()
            PRINTX l_yymm

            IF NOT cl_null(sr2_o.axk01) AND NOT cl_null(sr2_o.axk02) AND NOT cl_null(sr2_o.axk04) THEN
               IF sr2.axk01 = sr2_o.axk01 AND sr2.axk02 = sr2_o.axk02 AND sr2.axk04 = sr2_o.axk04 THEN
                  LET l_display = 'N'
                  LET l_axk01 = "    "       #FUN-CB0058
                  LET l_axk02 = "    "       #FUN-CB0058
                  LET l_axk04 = "    "       #FUN-CB0058
                  LET l_axz02 = "    "       #FUN-CB0058
                  LET l_axz02_1 = "    "     #FUN-CB0058
               ELSE
                  LET l_display = 'Y'
                  LET l_axk01 = sr2.axk01    #FUN-CB0058
                  LET l_axk02 = sr2.axk02    #FUN-CB0058
                  LET l_axk04 = sr2.axk04    #FUN-CB0058
                  LET l_axz02 = sr2.axz02    #FUN-CB0058
                  LET l_axz02_1 = sr2.axz02_1  #FUN-CB0058
               END IF
            ELSE 
               LET l_display = 'Y'
               LET l_axk01 = sr2.axk01    #FUN-CB0058
               LET l_axk02 = sr2.axk02    #FUN-CB0058
               LET l_axk04 = sr2.axk04    #FUN-CB0058
               LET l_axz02 = sr2.axz02    #FUN-CB0058
               LET l_axz02_1 = sr2.axz02_1  #FUN-CB0058
            END IF
            PRINTX l_display
            PRINTX l_axk01      #FUN-CB0058
            PRINTX l_axk02      #FUN-CB0058
            PRINTX l_axk04      #FUN-CB0058
            PRINTX l_axz02      #FUN-CB0058
            PRINTX l_axz02_1    #FUN-CB0058

            LET sr2_o.* = sr2.*
            PRINTX sr2.*

        AFTER GROUP OF sr2.axk01
        AFTER GROUP OF sr2.axk02
        AFTER GROUP OF sr2.axk04

        ON LAST ROW

END REPORT

#FUN-B80161---add-----end----

###GENGRE###START
FUNCTION aglg017_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg017")
        IF handler IS NOT NULL THEN
            START REPORT aglg017_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY axg01,axg02,axg04,axg05"   #FUN-B80161 add          

            DECLARE aglg017_datacur1 CURSOR FROM l_sql
            FOREACH aglg017_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg017_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg017_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg017_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80161---add----str---------
    DEFINE l_yymm    STRING
    DEFINE l_yy      STRING
    DEFINE l_em      STRING
    DEFINE sr1_o     sr1_t
    DEFINE l_display1 LIKE type_file.chr1
    #FUN-B80161---add----end---------    
    DEFINE l_axg01     LIKE axg_file.axg01     #FUN-CB0058
    DEFINE l_axg02     LIKE axg_file.axg02     #FUN-CB0058
    DEFINE l_axg04     LIKE axg_file.axg04     #FUN-CB0058
    DEFINE l_axz02     LIKE axz_file.axz02     #FUN-CB0058
    DEFINE l_axz02_1   LIKE axz_file.axz02     #FUN-CB0058

    ORDER EXTERNAL BY sr1.axg01,sr1.axg02,sr1.axg04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B80161 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.axg01 = NULL  
        BEFORE GROUP OF sr1.axg01
        BEFORE GROUP OF sr1.axg02
        BEFORE GROUP OF sr1.axg04

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B80161----add------str---------
            LET l_yy = tm.yy
            LET l_em = tm.em
            LET l_yymm = l_yy.trim(),'/',l_em.trim()
            PRINTX l_yymm

            IF NOT cl_null(sr1_o.axg01) AND NOT cl_null(sr1_o.axg02) AND NOT cl_null(sr1_o.axg04) THEN
               IF sr1.axg01 = sr1_o.axg01 AND sr1.axg02 = sr1_o.axg02 AND sr1.axg04 = sr1_o.axg04 THEN
                  LET l_display1 = 'N'
                  LET l_axg01 = "   "        #FUN-CB0058
                  LET l_axg02 = "   "        #FUN-CB0058
                  LET l_axg04 = "   "        #FUN-CB0058
                  LET l_axz02 = "   "        #FUN-CB0058
                  LET l_axz02_1 = "    "     #FUN-CB0058
               ELSE
                  LET l_display1 = 'Y'
                  LET l_axg01 = sr1.axg01    #FUN-CB0058
                  LET l_axg02 = sr1.axg02    #FUN-CB0058
                  LET l_axg04 = sr1.axg04    #FUN-CB0058
                  LET l_axz02 = sr1.axz02    #FUN-CB0058
                  LET l_axz02_1 = sr1.axz02_1  #FUN-CB0058
               END IF
            ELSE 
               LET l_display1 = 'Y'
               LET l_axg01 = sr1.axg01    #FUN-CB0058
               LET l_axg02 = sr1.axg02    #FUN-CB0058
               LET l_axg04 = sr1.axg04    #FUN-CB0058
               LET l_axz02 = sr1.axz02    #FUN-CB0058
               LET l_axz02_1 = sr1.axz02_1  #FUN-CB0058
            END IF
            PRINTX l_display1
            PRINTX l_axg01      #FUN-CB0058
            PRINTX l_axg02      #FUN-CB0058
            PRINTX l_axg04      #FUN-CB0058
            PRINTX l_axz02      #FUN-CB0058
            PRINTX l_axz02_1    #FUN-CB0058

            LET sr1_o.* = sr1.*
            #FUN-B80161----add------end---------

            PRINTX sr1.*

        AFTER GROUP OF sr1.axg01
        AFTER GROUP OF sr1.axg02
        AFTER GROUP OF sr1.axg04

        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C30085
