# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor302.4gl
# Descriptions...: 在制工單折合原料明細表列印
# Date & Author..: 02/12/26 By Carrier
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.MOD-490398 04/11/26 BY Elva add HS Code,去掉ima75,ima77,LIKE定義方式
# Modify.........: No.FUN-550036 05/05/26 By Trisy 單據編號加大
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗 
# Modify.........: No.FUN-590110 05/10/08 By jackie 報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/05/15 By TSD.lucasyeh   報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_sql        STRING,
         g_str        STRING,
         l_table      STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   LET g_sql = "cob01.cob_file.cob01,",          #SR 
               "cob02.cob_file.cob02,",          #SR   
               "cob021.cob_file.cob021,",        #SR  
               "coq02.coq_file.coq02,",          #SR
               "coq11.coq_file.coq11,",          #SR
               "ima02.ima_file.ima02,",          #SR
               "ima021.ima_file.ima021,",        #SR
               "coq12.coq_file.coq12,",          #SR          
               "coq13.coq_file.coq13,",          #SR     
               "coq14.coq_file.coq14,",          #SR  
               "coq15.coq_file.coq15,",          #SR
               "coq16.coq_file.coq16,",          #SR
               "coq17.coq_file.coq17,",          #SR
               "cob04.cob_file.cob04,",          #SR
               "order1.coq_file.coq02,",         #SR
               "order2.coq_file.coq02,",         #SR
               "order3.coq_file.coq02,",         #SR
               "l_cob01.cob_file.cob01,",        #CR need生產料號
               "l_cob02.cob_file.cob02,",        #CR need生產品名
               "l_cob021.cob_file.cob021,",      #CR need生產規格
               "l_cob.type_file.num5,",          #CR need
               "l_cob04_s.coq_file.coq17"        #CR need合同數量
                                        #23 items
 
   LET l_table = cl_prt_temptable('acor302',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
#FUN-840238 add---E
 
   INITIALIZE tm.* TO NULL                # Default condition
#---------------No.TQC-610082 modify
  #LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
  #LET tm.more = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#---------------No.TQC-610082 end
  
  
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN CALL acor302_tm(0,0)
   ELSE CALL acor302()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor302_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW acor302_w AT p_row,p_col WITH FORM "aco/42f/acor302" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
   LET tm.a   = '1'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON coq02,coq01,cob01 
#No.FUN-570243 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP                                                                                              
            IF INFIELD(coq01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO coq01                                                                                 
               NEXT FIELD coq01                                                                                                     
            END IF  
#No.FUN-570243 --end-- 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN 
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='acor302'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor302','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a  CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",          #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('acor302',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor302_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor302()
   ERROR ""
END WHILE
   CLOSE WINDOW acor302_w
END FUNCTION
 
FUNCTION acor302()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,           # NO.MOD-490398
          sr            RECORD cob01    LIKE cob_file.cob01,              
                               cob02    LIKE cob_file.cob02,               
                               cob021   LIKE cob_file.cob021,               
                               coq02    LIKE coq_file.coq02,             
                               coq11    LIKE coq_file.coq11,             
                               ima02    LIKE ima_file.ima02,
                               ima021   LIKE ima_file.ima021,
                               coq12    LIKE coq_file.coq12,               
                               coq13    LIKE coq_file.coq13,             
                               coq14    LIKE coq_file.coq14,             
                               coq15    LIKE coq_file.coq15,              
                               coq16    LIKE coq_file.coq16,               
                               coq17    LIKE coq_file.coq17,              
                               cob04    LIKE cob_file.cob04,
                               order1   LIKE coq_file.coq02,       #No.FUN-680069 VARCHAR(20) #No.FUN-590110
                               order2   LIKE coq_file.coq02,       #No.FUN-680069 VARCHAR(20) #No.FUN-590110
                               order3   LIKE coq_file.coq02        #No.FUN-680069 VARCHAR(20) #No.FUN-590110
                        END RECORD,
#FUN-840238 add ---start
          sr2           RECORD coq01    LIKE coq_file.coq01, #原料料號
                               ima25    LIKE ima_file.ima25, #庫存單位
                               coa04    LIKE coa_file.coa04, #NO.MOD-490398
                               coq17    LIKE coq_file.coq17  #在制量
                        END RECORD,
          l_cob01       LIKE cob_file.cob01,         #CR need
          l_cob02       LIKE cob_file.cob02,         #CR need
          l_cob021      LIKE cob_file.cob021,        #CR need
          l_cob         LIKE type_file.num5,         #No.FUN-680069 SMALLINT #CR need
          l_cob04_s     LIKE coq_file.coq17,         #No.FUN-680069 DEC(15,3)#CR need
          t_cob04_s     LIKE coq_file.coq17,         #No.FUN-680069 DEC(15,3) #No.FUN-590110
          t_cob06_s     LIKE coq_file.coq10,         #No.FUN-680069 DEC(15,3)
          g_cob06_s     LIKE coq_file.coq10,         #No.FUN-680069 DEC(15,3)
          l_fac         LIKE coq_file.coq10,         #No.FUN-680069 DEC(15,3)
          l_flag        LIKE type_file.num5          #No.FUN-680069 SMALLINT,
#FUN-840238 add --end
 
 
 
#FUN-840238 add---start
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#a
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740014 add ###
#FUN-840238 add---end
 
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 #NO.MOD-490398--begin
     LET l_sql = "SELECT cob01,cob02,cob021,coq02,coq11,'','',coq12,",
                 "       coq13,SUM(coq14*coa04),SUM(coq15*coa04),coq16,SUM(coq17*coa04),",
                 "       cob04 ",
                 "  FROM coq_file,cob_file,ima_file,coa_file LEFT OUTER JOIN coz_file ON coa05 = coz02   ",
                 " WHERE coq00 = '1'   AND coq01 = ima01",
                 "   AND cob01 = coa03 AND coa01 =ima01",
          #      "   AND coz_file.coz00='0'",
                 "   AND ",tm.wc CLIPPED,
                 " GROUP BY cob01,cob02,cob021,coq02,coq11,coq16,coq12,coq13,",
                 "          cob04 "
     IF tm.a = "1" THEN LET l_sql = l_sql CLIPPED," ORDER BY coq02,coq11" END IF 
     IF tm.a = "2" THEN LET l_sql = l_sql CLIPPED," ORDER BY cob01,coq02" END IF  
     PREPARE acor302_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor302_curs1 CURSOR FOR acor302_prepare1
 
     LET l_sql = "SELECT coq01,ima25,coa04,coq17 ",                           
                 "  FROM coq_file,cob_file,ima_file,coa_file LEFT OUTER JOIN coz_file ON coa05 = coz02  ",
                 " WHERE coq00 = '1' AND coq01 = ima01 ",
                 "   AND cob01 = coa03 AND coa01 = ima01 ",
                 "   AND ",tm.wc CLIPPED,
                 "   AND cob01 = ? AND coq02 = ? ",
                 "   AND coq11 = ? AND coq16 = ?  AND cob04 = ? "
 #NO.MOD-490398--end
     PREPARE acor302_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor302_curs2 CURSOR FOR acor302_prepare2
 
#FUN-840238 mark---Start
{ 
    CALL cl_outnam('acor302') RETURNING l_name
#No.FUN-590110 --start-- 
     IF tm.a='1' THEN
        LET g_zaa[31].zaa06='Y'
        LET g_zaa[39].zaa06='Y'
        LET g_zaa[47].zaa06='Y'
        LET g_zaa[35].zaa06='N'
        LET g_zaa[43].zaa06='N'
        LET g_zaa[51].zaa06='N'
     ELSE
        LET g_zaa[31].zaa06='N'
        LET g_zaa[39].zaa06='N'
        LET g_zaa[47].zaa06='N'
        LET g_zaa[35].zaa06='Y'
        LET g_zaa[43].zaa06='Y'
        LET g_zaa[51].zaa06='Y'
     END IF
     CALL cl_prt_pos_len()
     START REPORT acor302_rep1 TO l_name
     LET g_pageno = 0
}  #FUN-840238 mark---End
 
     FOREACH acor302_curs1 INTO sr.*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
       END IF
 
       SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file WHERE ima01 = sr.coq11
 
       IF tm.a='1' THEN
          LET sr.order1=sr.coq02
          LET sr.order2=sr.coq11
          LET sr.order3=sr.cob01
       ELSE
          LET sr.order1=sr.cob01
          LET sr.order2=sr.coq02
          LET sr.order3=sr.coq11
       END IF
 
#      OUTPUT TO REPORT acor302_rep1(sr.*)   #FUN-840238  mark
 
#FUN-840238 add ----start
        LET l_cob = 1
        LET l_cob04_s = 0        # FOR TEST 
        IF cl_null(t_cob04_s) THEN
           LET t_cob04_s=0
        END IF
 
        SELECT cob01,cob02,cob021 INTO l_cob01,l_cob02,l_cob021 
          FROM cob_file,ima_file,coa_file LEFT OUTER JOIN  coz_file ON coa05 = coz02
         WHERE ima01 = sr.coq11 
           AND cob01 = coa03 AND coa01=ima01
        IF tm.a = '1' THEN
           IF STATUS THEN
              LET l_cob = 0
           END IF
        ELSE
           IF STATUS = 100 THEN
              LET l_cob = 0
           END IF
        END IF
 
        FOREACH acor302_curs2 USING sr.cob01,sr.coq02,sr.coq11,
                                    sr.coq16,sr.cob04 INTO sr2.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
           END IF
           IF cl_null(sr2.coq17) THEN LET sr2.coq17 = 0 END IF
           LET l_fac = 0
           CALL s_umfchk(sr2.coq01,sr.coq16,sr2.ima25) RETURNING l_flag,l_fac
           IF l_flag THEN
              CALL cl_err(sr.coq11,'mfg2721',0)
              LET l_fac = 1
           END IF
           LET l_cob04_s = l_cob04_s + sr2.coq17 * l_fac * sr2.coa04 #NO.MOD-490398
 
           IF tm.a = '1' THEN
              SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=l_cob01
              SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01=sr.coq11
           ELSE
              IF cl_null(l_cob04_s) THEN LET l_cob04_s = 0 END IF                                                                            
           END IF
 
 
          #-----------------------CR (3)--------------------------#
        END FOREACH
 
        #LET test_counter = test_counter + 1
        #LET t_cob04_s = t_cob04_s + l_cob04_s                                                                                          
        EXECUTE insert_prep USING sr.*,
                                  l_cob01, l_cob02,   l_cob021,
                                  l_cob,   l_cob04_s
 
        IF SQLCA.sqlcode  THEN
           CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
        END IF
 
        #LET t_cob04_s = 0        # FUN-840238 FOR TEST 
#FUN-840238 add ----end
 
     END FOREACH
 
     #FUN-840238  ---start---
       ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'zu01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.a
     CALL cl_prt_cs3('acor302','acor302',l_sql,g_str)
        #------------------------------ CR (4) ------------------------------#
     #FUN-840238  ----end----  
 
#    FINISH REPORT acor302_rep1                  #FUN-840238-mark
#No.FUN-590110 --end--
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #FUN-840238 mark
END FUNCTION
 
#FUN-840238 mark --- start
{
REPORT acor302_rep1(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          sr            RECORD cob01    LIKE cob_file.cob01,              
                               cob02    LIKE cob_file.cob02,               
                               cob021   LIKE cob_file.cob021,               
                               coq02    LIKE coq_file.coq02,             
                               coq11    LIKE coq_file.coq11,             
                               ima02    LIKE ima_file.ima02,
                               ima021   LIKE ima_file.ima021,
                               coq12    LIKE coq_file.coq12,               
                               coq13    LIKE coq_file.coq13,             
                               coq14    LIKE coq_file.coq14,             
                               coq15    LIKE coq_file.coq15,              
                               coq16    LIKE coq_file.coq16,               
                               coq17    LIKE coq_file.coq17,              
                               cob04    LIKE cob_file.cob04,
                               order1   LIKE coq_file.coq02,       #No.FUN-680069 VARCHAR(20) #No.FUN-590110
                               order2   LIKE coq_file.coq02,       #No.FUN-680069 VARCHAR(20) #No.FUN-590110
                               order3   LIKE coq_file.coq02        #No.FUN-680069 VARCHAR(20) #No.FUN-590110
                        END RECORD,
          sr2           RECORD coq01    LIKE coq_file.coq01,
                               ima25    LIKE ima_file.ima25,
 #                             ima77    LIKE ima_file.ima77, #NO.MOD-490398
                               coa04    LIKE coa_file.coa04, #NO.MOD-490398
                               coq17    LIKE coq_file.coq17
                        END RECORD,
          l_cob01       LIKE cob_file.cob01,
          l_cob02       LIKE cob_file.cob02,
          l_cob021      LIKE cob_file.cob021,
          l_cob         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_cob04_s     LIKE coq_file.coq17,         #No.FUN-680069 DEC(15,3)
          t_cob04_s     LIKE coq_file.coq17,         #No.FUN-680069 DEC(15,3) #No.FUN-590110
          t_cob06_s     LIKE coq_file.coq10,         #No.FUN-680069 DEC(15,3)
          g_cob06_s     LIKE coq_file.coq10,         #No.FUN-680069 DEC(15,3)
          l_fac         LIKE coq_file.coq10,         #No.FUN-680069 DEC(15,3)
          l_first       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_first1      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_first2      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_flag        LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3                 
  FORMAT
   PAGE HEADER
#No.FUN-590110 --start--
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED                   
         LET g_pageno = g_pageno+1                                                 
         LET pageno_total=PAGENO USING '<<<',"/pageno"                             
         PRINT g_head CLIPPED,pageno_total                                         
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     
         PRINT g_dash[1,g_len]
         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
         PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
         PRINTX name=H3 g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
     IF tm.a='1' THEN
        PRINTX name=D1 COLUMN g_c[32],sr.coq02 CLIPPED;     #No.FUN-550036
     ELSE
        LET l_first = 0                                                                                                             
        LET t_cob04_s = 0                                                                                                           
        PRINTX name=D1 COLUMN  g_c[31],sr.cob01 CLIPPED;
     END IF  
 
   BEFORE GROUP OF sr.order2
     IF tm.a='1' THEN
        LET l_cob = 1
 #NO.MOD-490398--begin
        SELECT cob01,cob02,cob021 INTO l_cob01,l_cob02,l_cob021 
          FROM cob_file,ima_file,coa_file LEFT OUTER JOIN  coz_file ON coa05 = coz02
         WHERE ima01 = sr.coq11 
           AND cob01 = coa03 AND coa01=ima01
 #NO.MOD-490398--end  
        IF STATUS THEN LET l_cob = 0 END IF
        LET l_first = 0
        IF l_cob = 1 THEN
           #PRINTX name=D1 COLUMN g_c[33],l_cob01[1,15] CLIPPED;#No.FUN-550036#FUN-5B0013 mark
           PRINTX name=D1 COLUMN g_c[33],l_cob01 CLIPPED; #FUN-5B0013 add
        ELSE
           PRINTX name=D1 COLUMN g_c[33],sr.coq11 CLIPPED;#No.FUN-550036 #FUN-5B0013 addCLIPPED
        END IF 
        PRINTX name=D1 COLUMN g_c[34],sr.coq12 USING "##########&.###";      #No.FUN-550036
     ELSE
        PRINTX name=D1 COLUMN g_c[32],sr.coq02;  
     END IF
 
   BEFORE GROUP OF sr.order3
    IF tm.a='1' THEN
     LET l_cob04_s = 0
     LET l_first1 = 0
     LET l_first2 = 0
     FOREACH acor302_curs2 USING sr.cob01,sr.coq02,sr.coq11,
                  sr.coq16,sr.cob04 INTO sr2.*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
       END IF
       IF cl_null(sr2.coq17) THEN LET sr2.coq17 = 0 END IF
       LET l_fac = 0
       CALL s_umfchk(sr2.coq01,sr.coq16,sr2.ima25) RETURNING l_flag,l_fac
       IF l_flag THEN
          CALL cl_err(sr.coq11,'mfg2721',0)
          LET l_fac = 1
       END IF
        LET l_cob04_s = l_cob04_s + sr2.coq17 * l_fac * sr2.coa04 #NO.MOD-490398
     END FOREACH
     PRINTX name=D1 COLUMN g_c[35],sr.cob01 CLIPPED;        #No.FUN-550036                         
    ELSE
        LET l_first1 = 0                                                                                                            
        LET l_cob = 1                                                                                                               
 #NO.MOD-490398--begin                                                                                                              
        SELECT cob01,cob02,cob021 INTO l_cob01,l_cob02,l_cob021                                                                     
          FROM cob_file,ima_file,coa_file LEFT OUTER JOIN  coz_file ON coa05 = coz02                                                                            
         WHERE ima01 = sr.coq11                                                                                                     
           AND cob01 = coa03 AND coa01 = ima01 AND coa05 = coz_file.coz02                                                           
 #NO.MOD-490398--end                                                                                                                
        IF STATUS=100 THEN LET l_cob = 0 END IF                                                                                     
     LET l_cob04_s = 0                                                                                                              
     FOREACH acor302_curs2 USING sr.cob01,sr.coq02,sr.coq11,                                                                        
                  sr.coq16,sr.cob04 INTO sr2.*                                                                                      
       IF SQLCA.sqlcode  THEN                                                                                                       
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH                                                                             
       END IF                                                                                                                       
       IF cl_null(sr2.coq17) THEN LET sr2.coq17 = 0 END IF                                                                          
       LET l_fac = 0                                                                                                                
       CALL s_umfchk(sr2.coq01,sr.coq16,sr2.ima25) RETURNING l_flag,l_fac                                                           
       IF l_flag THEN                                                                                                               
          CALL cl_err(sr.coq11,'mfg2721',0)                                                                                         
          LET l_fac = 1                                                                                                             
       END IF      
        LET l_cob04_s = l_cob04_s + sr2.coq17 * l_fac * sr2.coa04 #NO.MOD-490398                                                    
     END FOREACH                                                                                                                    
     IF cl_null(l_cob04_s) THEN LET l_cob04_s = 0 END IF                                                                            
     LET t_cob04_s = t_cob04_s + l_cob04_s                                                                                          
     IF l_cob = 1 THEN                                                                                                              
        #PRINTX name=D1 COLUMN g_c[33],l_cob01[1,15] CLIPPED;#No.FUN-550036#FUN-5B0013 mark                                                           
        PRINTX name=D1 COLUMN g_c[33],l_cob01 CLIPPED; #FUN-5B0013 add                                                          
     ELSE                                                                                                                           
        PRINTX name=D1 COLUMN g_c[33],sr.coq11 CLIPPED;      #No.FUN-550036                                                                               
     END IF  
    END IF
        
   ON EVERY ROW
      IF tm.a<>'1' THEN
        PRINTX name=D1
              COLUMN  80,sr.coq12 USING "##########&.###";     
      END IF
        PRINTX name=D1
              COLUMN g_c[36],sr.coq14 USING "##########&.###",    #No.FUN-550036
              COLUMN g_c[37],sr.coq16,        #No.FUN-550036                         
              COLUMN g_c[38],sr.cob04         #No.FUN-550036
     IF tm.a='1' THEN
        IF l_first = 0 THEN
           IF l_cob = 1 THEN
              #PRINTX name=D2 COLUMN g_c[41],l_cob02[1,30]; #No.FUN-550036 #FUN-5B0013 mark                            
              PRINTX name=D2 COLUMN g_c[41],l_cob02 CLIPPED;#FUN-5B0013 add                            
           ELSE 
              PRINTX name=D2 COLUMN g_c[41],sr.ima02 CLIPPED; #MOD-4A0238      #No.FUN-550036
           END IF
           PRINTX name=D2 COLUMN g_c[42],sr.coq13 USING "##########&.###";    #No.FUN-550036
        END IF
        IF l_first1 = 0 THEN
           #PRINTX name=D2 COLUMN g_c[43],sr.cob02[1,30];#FUN-5B0013 mark                           
           PRINTX name=D2 COLUMN g_c[43],sr.cob02 CLIPPED; #FUN-5B0013 add                           
        END IF
     ELSE
        IF l_first = 0 THEN                                                                                                         
           #PRINTX name=D2 COLUMN g_c[39],sr.cob02[1,30];#FUN-5B0013 mark                                                                                         
           PRINTX name=D2 COLUMN g_c[39],sr.cob02 CLIPPED; #FUN-5B0013 add                                                                                         
        END IF                                                                                                                      
        IF l_first1 = 0 THEN                                                                                                        
           IF l_cob = 1 THEN                                                                                                        
              #PRINTX name=D2 COLUMN g_c[41],l_cob02[1,30]; #No.FUN-550036#FUN-5B0013 mark                                                                  
              PRINTX name=D2 COLUMN g_c[41],l_cob02 CLIPPED; #FUN-5B0013 add                                                                  
           ELSE                                                                                                                     
              PRINTX name=D2 COLUMN g_c[41],sr.ima02 CLIPPED; #MOD-4A0238        #No.FUN-5500                                                    
           END IF                                                                                                                   
        END IF                                                                                                                      
        PRINTX name=D2 COLUMN g_c[42],sr.coq13 USING "##########&.###";
     END IF   
 
           PRINTX name=D2
                 COLUMN g_c[44],sr.coq15 USING "##########&.###",    #No.FUN-550036
                 COLUMN g_c[45],sr.coq17 USING "##########&.###",    #No.FUN-550036
                 COLUMN g_c[46],l_cob04_s USING "##########&.###"    #No.FUN-550036
 
     IF tm.a='1' THEN
        SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=l_cob01
        SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01=sr.coq11
 
        IF l_first = 0 THEN
          IF l_cob=1 THEN
             PRINTX name=D3 COLUMN g_c[49],l_cob021 CLIPPED; #No.FUN-550036 #FUN-5B0013 add CLIPPED
          ELSE
             PRINTX name=D3 COLUMN g_c[49],sr.ima021 CLIPPED;#No.FUN-550036 #FUN-5B0013 add CLIPPED
          END IF
        END IF
 
        SELECT cob021 INTO sr.cob021 FROM cob_file WHERE cob01=sr.cob01
        PRINTX name=D3 COLUMN g_c[51],sr.cob021 CLIPPED #No.FUN-550036 #FUN-5B0013 add CLIPPED
     ELSE
        IF l_first = 0 THEN                                                                                                         
           #PRINTX name=D3 COLUMN  g_c[47],sr.cob021[1,30];#FUN-5B0013 mark                                                                                        
           PRINTX name=D3 COLUMN  g_c[47],sr.cob021 CLIPPED; #FUN-5B0013 add CLIPPED                                                                                        
        END IF                                                                                                                      
        IF l_first1 = 0 THEN                                                                                                        
           IF l_cob = 1 THEN                                                                                                        
              #PRINTX name=D3 COLUMN g_c[49],l_cob021[1,30]#No.FUN-550036#FUN-5B0013 mark                                                                
              PRINTX name=D3 COLUMN g_c[49],l_cob021 CLIPPED #FUN-5B0013 add                                                                  
           ELSE                                                                                                                     
               PRINTX name=D3 COLUMN g_c[49],sr.ima021 CLIPPED #MOD-4A0238        #No.FUN-5500                                                    
           END IF                                                                                                                   
        END IF                 
     END IF
 
      LET l_first = l_first + 1 
      LET l_first1 = l_first1 + 1 
 
 
   AFTER GROUP OF sr.order1           
    IF tm.a<>'1' THEN                                                                                               
      IF cl_null(t_cob04_s) THEN LET t_cob04_s = 0 END IF                                                                           
      PRINT                                                                                                                         
      PRINTX name=S2 COLUMN g_c[40],g_x[21] CLIPPED;                                                                                              
      PRINTX name=S2 COLUMN g_c[46],t_cob04_s USING "##########&.###"        #No.FUN-550036                                                       
      PRINTX name=S2 COLUMN g_c[40],g_dash2[1,g_w[40]+1+g_w[42]+1+g_w[43]+1+g_w[44]+1+g_w[45]+1+g_w[46]]                                                          
    END IF
#No.FUN-590110 --end--
 
   ON LAST ROW
       PRINT g_dash[1,g_len] CLIPPED
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN 
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
END REPORT
}
#FUN-840238 mark ---end
#No.FUN-870144 
