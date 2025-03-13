# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor300.4gl
# Descriptions...: 合同進口原料庫存明細表列印
# Date & Author..: 02/12/26 By Carrier
# Modify.........: No.MOD-490398 04/12/13 By Carrier
#                  add HS Code,用coa04替換ima77,coa03替換ima75
#                  modify sql error
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗 
# Modify.........: No.FUN-590110 05/09/29 By jackie 報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660045 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/05/02 By TSD.zeak 報表改寫由Crystal Report產出
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-8A0029 09/02/23 By destiny 打印報錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
           a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
           more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
           END RECORD,
           g_sql   STRING     # No.MOD-490398    #No.FUN-580092 HCN        #No.FUN-680069
DEFINE   g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE l_table       STRING                   
DEFINE g_str         STRING                   
 
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
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "coa03.coa_file.coa03,", #商品編號 
               "cob02.cob_file.cob02,", 
               "cob021.cob_file.cob021,",
               "cob04.cob_file.cob04,",  #合同單位
               "coa01.coa_file.coa01,",  #原料編號
               "ima02.ima_file.ima02,",  #品名
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",  #庫存單位
               "coq03.coq_file.coq03,",  #倉庫編號
               "coq04.coq_file.coq04,",  #儲位    
               "coq05.coq_file.coq05,",  #庫位    
               "coq06.coq_file.coq06,",  #單位    
               "coq07.coq_file.coq07,",  #數量    
               "coa04.coa_file.coa04,",  #換算率  
               "i_qty.coq_file.coq12,",  #基于ima25的數量
               "c_qty.coq_file.coq12,",  #基于cob04的數量
               "coq12.coq_file.coq12,",    #FUN-840238
               "flag.coq_file.coq00"
   
   LET l_table = cl_prt_temptable('acor300',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-840238  ----end----  
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET tm.y = 'N'                         #MOD-490398
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.y    = ARG_VAL(9)                  #MOD-490398
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
  
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor300_tm(0,0)
      ELSE CALL acor300()
            DROP TABLE r300_cna #No.MOD-490398
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor300_w AT p_row,p_col WITH FORM "aco/42f/acor300" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
    LET tm.y = 'N'                         #MOD-490398
   LET tm.a   = 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON coa03,coq01,coq03,coq04,coq05  #MOD-490398
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#No.FUN-570243 --start--                                                                                    
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('coauser', 'coagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.a,tm.y,tm.more WITHOUT DEFAULTS   #MOD-490398
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF 
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      LET INT_FLAG = 0 CLOSE WINDOW acor300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor300','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                          " '",tm.y     CLIPPED,"'",  #MOD-490398
                        #" '",tm.more  CLIPPED,"'",          #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('acor300',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor300()
   ERROR ""
END WHILE
   CLOSE WINDOW acor300_w
END FUNCTION
 
FUNCTION acor300()
   DEFINE l_name    LIKE type_file.chr20,            #No.FUN-680069 VARCHAR(20) # External(Disk) file name
         #l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,          #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05, #MOD-490398
          #NO.MOD-490398  --begin
          l_sw  	LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_factor      LIKE bmb_file.bmb10_fac,
          l_n,l_i       LIKE type_file.num5,         #MOD-490398        #No.FUN-680069 SMALLINT
          #FUN-840238 ---start---
          l_coa03       LIKE coa_file.coa03,
          l_cob04       LIKE cob_file.cob04,
          sr            RECORD coa03  LIKE coa_file.coa03,  #商品編號 
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               cob04  LIKE cob_file.cob04,  #合同單位
                               coa01  LIKE coa_file.coa01,  #原料編號
                               ima02  LIKE ima_file.ima02,  #品名
                               ima021 LIKE ima_file.ima021,
                               ima25  LIKE ima_file.ima25,  #庫存單位
                               coq03  LIKE coq_file.coq03,  #倉庫編號
                               coq04  LIKE coq_file.coq04,  #儲位    
                               coq05  LIKE coq_file.coq05,  #庫位    
                               coq06  LIKE coq_file.coq06,  #單位    
                               coq07  LIKE coq_file.coq07,  #數量    
                               coa04  LIKE coa_file.coa04,  #換算率  
                               i_qty  LIKE coq_file.coq12,  #基于ima25的數量
                               c_qty  LIKE coq_file.coq12,  #基于cob04的數量
                               coq12  LIKE coq_file.coq12,  #FUN-840238
                               flag   LIKE coq_file.coq00   #FUN-840238 
                        END RECORD
           
           #NO.MOD-490398  --end   
     #FUN-840238  ---start---  
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740014 add ###
     #------------------------------ CR (2) ------------------------------#
     #FUN-840238  ----end----  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.MOD-490398  --begin
     DROP TABLE r300_cna
     #No.FUN-680069-begin
     CREATE TEMP TABLE r300_cna (
                 cna01  LIKE cna_file.cna01,
                 lvl    LIKE type_file.num5);
     #No.FUN-680069-end
     IF SQLCA.sqlcode THEN
        CALL cl_err('create r300_cna',SQLCA.sqlcode,0)
     END IF
 
     INSERT INTO r300_cna SELECT cna01,99 FROM cna_file
     IF SQLCA.sqlcode THEN
        #CALL cl_err('insert r300_cna',SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cna_file","","",SQLCA.sqlcode,"","insert r300_cna",0) #No.TQC-660045
     END IF
     UPDATE r300_cna SET lvl=0 WHERE cna01=g_coz.coz02
     IF SQLCA.sqlcode or SQLCA.sqlerrd[3]=0 THEN
        #CALL cl_err('update r300_cna',SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("upd","r300_cna",g_coz.coz02,"",SQLCA.sqlcode,"","update r300_cna",0) #No.TQC-66045
     END IF
     
     DROP TABLE r300_coq
     #No.MOD-490398  --begin
     #LET l_sql="CREATE TABLE r300_coq AS SELECT * FROM coq_file",
     #        " WHERE  coq00='0'"
     LET l_sql="SELECT * FROM coq_file WHERE coq00='0' INTO TEMP r300_coq"
     #No.MOD-490398  --end   
     PREPARE cre_coq FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare create coq',SQLCA.sqlcode,0)
        RETURN
     END IF
     EXECUTE cre_coq 
     IF SQLCA.sqlcode THEN
        CALL cl_err('execute create coq',SQLCA.sqlcode,0)
        RETURN
     END IF
 
     DROP TABLE r300_coq1
      #No.MOD-490398  --begin
     #LET l_sql="CREATE TABLE r300_coq1 AS SELECT * FROM coq_file",
     #         " WHERE  coq00='0'"
     LET l_sql="SELECT * FROM coq_file WHERE coq00='0' INTO TEMP r300_coq1"
      #No.MOD-490398  --end   
     PREPARE cre_coq1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare create coq1',SQLCA.sqlcode,0)
        RETURN
     END IF
     EXECUTE cre_coq1 
     IF SQLCA.sqlcode THEN
        CALL cl_err('execute create coq1',SQLCA.sqlcode,0)
        RETURN
     END IF
     UPDATE r300_coq1 SET coq12=0
     
     IF tm.y = 'N' THEN
       LET l_sql = "SELECT coa03,cob02,cob021,cob04,coa01,ima02,ima021,ima25,coq03,coq04,",
                  #"       coq05,coq06,coq07,coa04,0,0",
                   "       coq05,coq06,coq07,coa04,0,0,0,'1'", #FUN-840238 
                   "  FROM coa_file,cob_file,ima_file,coq_file,r300_cna",
                   " WHERE coa01=coq01  AND coa03=cob01 ",
                   "   AND coa01=ima01 AND coa05=cna01 AND ",tm.wc CLIPPED,
                   "   AND coq00='0'",
                   " ORDER BY lvl,coa03,coa01,coq03,coq04,coq05"
    ELSE
       LET l_sql = "SELECT cob09,cob02,cob021,cob04,coa01,ima02,ima021,ima25,coq03,coq04,",
                  #"       coq05,coq06,coq07,coa04,0,0",
                   "       coq05,coq06,coq07,coa04,0,0,0,'1'", #FUN-840238 
                   "  FROM coa_file,cob_file,ima_file,coq_file,r300_cna",
                   " WHERE coa01=coq01 AND coa03=cob01 ",
                   "   AND coa01=ima01 AND coa05=cna01 AND ",tm.wc CLIPPED,
                   "   AND coq00='0'",
                   " ORDER BY lvl,coa03,coa01,coq03,coq04,coq05"
     END IF
     PREPARE acor300_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor300_curs1 CURSOR FOR acor300_prepare1
     #CALL cl_outnam('acor300') RETURNING l_name       #No.FUN-8A0029
     #No.FUN-590110 --start--
     IF tm.a='Y' THEN
        LET g_zaa[39].zaa06='N'
        LET g_zaa[40].zaa06='N'
        LET g_zaa[41].zaa06='N'
     ELSE
        LET g_zaa[39].zaa06='Y'
        LET g_zaa[40].zaa06='Y'
        LET g_zaa[41].zaa06='Y'
     END IF
     CALL cl_prt_pos_len()
     #No.FUN-590110 --end--
     #START REPORT acor300_rep TO l_name
     FOREACH acor300_curs1 INTO sr.*
       LET l_i=0
       SELECT COUNT(*) INTO l_i FROM r300_coq 
        WHERE coq01=sr.coa01 AND coq03=sr.coq03
          AND coq04=sr.coq04 AND coq05=sr.coq05
       IF l_i = 0 THEN
          LET sr.coq07=0
          LET sr.i_qty=0
          LET sr.c_qty=0
       ELSE
          DELETE FROM r300_coq 
           WHERE coq01=sr.coa01 AND coq03=sr.coq03
             AND coq04=sr.coq04 AND coq05=sr.coq05
          IF SQLCA.sqlcode THEN
       #     CALL cl_err('delete r300_coq',SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("del","r300_coq",sr.coa01,sr.coq03,SQLCA.sqlcode,"","delete r300_coq",0) #No.TQC-660045
          END IF
          IF cl_null(sr.coq07) THEN LET sr.coq07=0 END IF
          LET l_factor = 1
          IF sr.coq06 <> sr.ima25 THEN
             CALL s_umfchk(sr.coa01,sr.coq06,sr.ima25)
             RETURNING l_sw,l_factor
             IF l_sw = '1' THEN 
                CALL cl_err(sr.coa01,'mfg1206',0)
                LET l_factor = 1
             END IF
          END IF
          LET sr.i_qty=sr.coq07*l_factor
          IF cl_null(sr.coa04) THEN LET sr.coa04=1 END IF
          LET sr.c_qty=sr.i_qty*sr.coa04
          UPDATE r300_coq1 SET coq11=sr.coa03,
                               coq12=coq12+sr.c_qty,
                               coq09=sr.cob04
           WHERE coq01=sr.coa01 AND coq03=sr.coq03
             AND coq04=sr.coq04 AND coq05=sr.coq05
          IF SQLCA.sqlcode THEN
          #  CALL cl_err('update r300_coq1',SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","r300_coql",sr.coa01,sr.coq03,SQLCA.sqlcode,"","update r300_coql",0) #No.TQC-660045
          END IF
       END IF
     #No.MOD-490398  --end  
      
       EXECUTE insert_prep USING sr.* #FUN-840238
     END FOREACH
 
 
     #FUN-840238      ---start---
     #將flag=1的暫存資料 整理成新的flag=2資料
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
     PREPARE acor300_pre2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor300_curs2 CURSOR FOR acor300_pre2
     FOREACH acor300_curs2 INTO sr.*
       IF cl_null(sr.coq07) THEN LET sr.coq07 = 0 END IF
       SELECT SUM(COALESCE(coq12,0)) INTO sr.coq12 
         FROM r300_coq1
        WHERE coq11=sr.coa03 AND coq09=sr.cob04
        GROUP BY coq11,coq09,coq06
       LET sr.flag = '2'
 
       EXECUTE insert_prep USING sr.*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
    
     END FOREACH
 
     #刪除flag ='1'的資料
     LET l_sql="DELETE " ,g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE flag = '1' " 
     PREPARE del_temp FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare del temp',SQLCA.sqlcode,0)
        RETURN
     END IF
     EXECUTE del_temp 
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'zu01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.a,";",tm.y
     IF tm.a ='Y' THEN
        CALL cl_prt_cs3('acor300','acor300_1',l_sql,g_str)   
     ELSE
        CALL cl_prt_cs3('acor300','acor300',l_sql,g_str)   
     END IF
     #------------------------------ CR (4) ------------------------------#
     #FUN-840238  ----end----  
 
END FUNCTION
#No.FUN-870144
