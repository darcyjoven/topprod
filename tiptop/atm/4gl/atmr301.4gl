# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amtr301.4gl
# Descriptions...: 客戶庫存月統計表
# Date & Author..: 2006/03/29 By Sarah
# Modify.........: No.FUN-630027 06/03/29 By Sarah 新增"客戶庫存月統計表"
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740127 07/04/27 By jamie g_program->g_prog
# Modify.........: NO.FUN-740081 07/05/04 By TSD.c123k 改為crystal report
# Modify.........: No.TQC-760162 07/06/22 By Sarah atmr301/atmr311共用程式,311出表有問題
# Modify.........: No.MOD-930175 09/03/17 By chenyu select tur06,tur07等幾個欄位之前要把變量里面的值清空
# Modify.........: No.FUN-8B0104 09/06/04 By liuxqa 加上送貨客戶這個欄位。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0036 09/10/07 By Smapmin 品名規格改抓ima_file的資料
# Modify.........: No.TQC-A50164 10/05/31 By Carrier MOD-9A0036 追单
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD                  
                  wc      STRING,      
                  yyyy    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
                  m1      LIKE type_file.num5,             #No.FUN-680120 SMALLINT
                  m2      LIKE type_file.num5,             #No.FUN-680120 SMALLINT
                  a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
                  more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
                 END RECORD
DEFINE g_tur11   LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE g_program LIKE gaz_file.gaz01            #No.FUN-680120 VARCHAR(10)   #FUN-740127 mark
DEFINE g_gaz03   LIKE gaz_file.gaz03
DEFINE   l_table    STRING                  # FUN-740081
DEFINE   g_sql      STRING                  # FUN-740081
DEFINE   g_str      STRING                  # FUN-740081
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                   
 
   LET g_tur11  = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)          
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
#-------------No.TQC-610088 modify
   LET tm.wc    = ARG_VAL(8)
   LET tm.yyyy  = ARG_VAL(9)
   LET tm.m1    = ARG_VAL(10)
   LET tm.m2    = ARG_VAL(11)
   LET tm.a     = ARG_VAL(12)
#-------------No.TQC-610088 modify
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   CASE g_tur11
     #FUN-740127---mod---str---
      WHEN 1 LET g_prog = 'atmr301'
      WHEN 2 LET g_prog = 'atmr311'
     #WHEN 1 LET g_program = 'atmr301'
     #WHEN 2 LET g_program = 'atmr311'
     #FUN-740127---mod---end---
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
#FUN-740081 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740081 *** ##
   LET g_sql = "tur01.tur_file.tur01,",  
               "occ02.occ_file.occ02,",
               "occ021.occ_file.occ02,",    #No.FUN-8B0104 add by liuxqa 
               "tur02.tur_file.tur02,",
               #"cob02.cob_file.cob02,",   #MOD-9A0036                          
               #"cob021.cob_file.cob021,", #MOD-9A0036                          
               " ima02.ima_file.ima02,",   #MOD-9A0036                          
               " ima021.ima_file.ima021,", #MOD-9A0036
               "tur03.tur_file.tur03,",  
               "tur04.tur_file.tur04,",  
               "tur05.tur_file.tur05,",  
               "tur06.tur_file.tur06,",  
               "tur07.tur_file.tur07,",  
               "tur08.tur_file.tur08,",  
               "tur09.tur_file.tur09,",
               "tur12.tur_file.tur12,",     #No.FUN-8B0104 add
               "last_tur09.tur_file.tur09"
 
   LET l_table = cl_prt_temptable('atmr301',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?) "         #No.FUN-8B0104 add 2 ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
#FUN-740081 - END
 
   IF NOT cl_null(tm.wc) THEN                                                   
      CALL r301()                                                               
   ELSE                                                                         
      CALL r301_tm(0,0)                                                         
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r301_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680120 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 12 
   
   OPEN WINDOW r301_w AT p_row,p_col
        WITH FORM "atm/42f/atmr301" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL       
   LET tm.yyyy = YEAR(g_today)  
   LET tm.m1   = MONTH(g_today)
   LET tm.m2   = MONTH(g_today)
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tur01,tur02,tur03
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
         LET INT_FLAG = 0 
         CLOSE WINDOW r301_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN 
         CALL cl_err('','9046',0) 
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.yyyy,tm.m1,tm.m2,tm.a,tm.more WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yyyy
             IF cl_null(tm.yyyy) THEN NEXT FIELD yyyy END IF
         AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
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
#No.TQC-720032 -- end --
            IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF
#            IF tm.m1 < 1 OR tm.m1 > 12 THEN NEXT FIELD m1 END IF        #No.TQC-720032
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
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
#No.TQC-720032 -- end --
            IF cl_null(tm.m2) THEN NEXT FIELD m2 END IF
#            IF tm.m2 < 1 OR tm.m2 > 12 THEN NEXT FIELD m2 END IF        #No.TQC-720032
            IF tm.m2 < tm.m1 THEN NEXT FIELD m1 END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()  
 
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
         LET INT_FLAG = 0 
         CLOSE WINDOW r301_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01 = 'atmr301'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr301','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,     
                            " '",g_tur11  CLIPPED,"'",
                            " '",g_pdate  CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob  CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc    CLIPPED,"'" ,     #No.TQC-610088 add
                            " '",tm.yyyy  CLIPPED,",",
                            " '",tm.m1    CLIPPED,",",
                            " '",tm.m2    CLIPPED,",",
                            " '",tm.a     CLIPPED,",",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('atmr301',g_time,l_cmd)   
         END IF
         CLOSE WINDOW r301_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r301()
      ERROR ""
   END WHILE
   CLOSE WINDOW r301_w
END FUNCTION
 
FUNCTION r301()
   DEFINE l_name      LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)
#         l_time      LIKE type_file.chr8,             #No.FUN-6B0014
          l_prog      LIKE type_file.chr10,            #TQC-760162 add
          l_sql       STRING,    
          l_yy,l_mm   LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_i,l_j     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_tur09     LIKE tur_file.tur09,
          sr1         RECORD 
                       tur01      LIKE tur_file.tur01,  
                       tur02      LIKE tur_file.tur02,  
                       tur03      LIKE tur_file.tur03,
                       tur12      LIKE tur_file.tur12    #No.FUN-8B0104 add
                      END RECORD,
          sr          RECORD 
                       tur01      LIKE tur_file.tur01,  
                       occ02      LIKE occ_file.occ02,
                       occ021     LIKE occ_file.occ02,  #No.FUN-8B0104 add
                       tur02      LIKE tur_file.tur02,  
                       #cob02      LIKE cob_file.cob02,   #MOD-9A0036           
                       #cob021     LIKE cob_file.cob021,  #MOD-9A0036           
                       ima02      LIKE ima_file.ima02,    #MOD-9A0036           
                       ima021     LIKE ima_file.ima021,    #MOD-9A0036     
                       tur03      LIKE tur_file.tur03,  
                       tur04      LIKE tur_file.tur04,  
                       tur05      LIKE tur_file.tur05,  
                       tur06      LIKE tur_file.tur06,  
                       tur07      LIKE tur_file.tur07,  
                       tur08      LIKE tur_file.tur08,  
                       tur09      LIKE tur_file.tur09,
                       tur12      LIKE tur_file.tur12,   #No.FUN-8B0104 add
                       last_tur09 LIKE tur_file.tur09
                      END RECORD
 
#FUN-740081 - add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740081 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
#FUN-740081 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  #SELECT gaz03 INTO g_gaz03 FROM gaz_file WHERE gaz01=g_program AND gaz02=g_rlang  #FUN-740127 mark
   SELECT gaz03 INTO g_gaz03 FROM gaz_file WHERE gaz01=g_prog AND gaz02=g_rlang     #FUN-740127 mod
 
   LET l_sql = "SELECT UNIQUE tur01,tur02,tur03,tur12",  #No.FUN-8B0104 add 
               "  FROM tur_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND tur11='",g_tur11,"' ",
               " ORDER BY tur01,tur02,tur03"
   PREPARE r301_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM 
   END IF
   DECLARE r301_curs1 CURSOR FOR r301_prepare1
 
   LET l_prog = g_prog      #TQC-760162 add
   LET g_prog = 'atmr301'   #TQC-760162 add
 
   #CALL cl_outnam('atmr301') RETURNING l_name  #FUN-740127 mark
   #CALL cl_outnam(g_prog) RETURNING l_name    #FUN-740127 mod   #TSD.c123k mark
   #START REPORT r301_rep TO l_name            #TSD.c123k mark
   LET g_pageno = 0
 
   IF tm.m1 = 1 THEN   #期初
      LET l_mm = 12
      LET l_yy = tm.yyyy - 1
   ELSE
      LET l_mm = tm.m1 - 1
      LET l_yy = tm.yyyy
   END IF
 
   FOREACH r301_curs1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF
      #計算期初數量
      SELECT tur09 INTO l_tur09 FROM tur_file
       WHERE tur01 = sr1.tur01 AND tur02 = sr1.tur02 
         AND tur03 = sr1.tur03 
         AND tur04 = l_yy AND tur05 = l_mm
         AND tur11 = g_tur11
         AND tur12 = sr1.tur12  #No.FUN-8B0104 add
 
      IF cl_null(l_tur09) THEN LET l_tur09 = 0 END IF
      #計算期間
      SELECT COUNT(*) INTO l_j 
        FROM tur_file
       WHERE tur01 = sr1.tur01 AND tur02 = sr1.tur02 
         AND tur03 = sr1.tur03 AND tur04 = tm.yyyy
         AND tur05 BETWEEN tm.m1 AND tm.m2
         AND (tur06 <> 0 OR tur07 <> 0 OR tur08 <> 0 OR tur09 <>0)
         AND tur11 = g_tur11
         AND tur12 = sr1.tur12    #No.FUN-8B0104 add by liuxqa 
 
      IF cl_null(l_j) THEN LET l_j = 0 END IF
      IF l_tur09=0 AND l_j=0 THEN 
         #期初為零且期間為零
         IF tm.a = 'Y' THEN
            LET sr.tur01=sr1.tur01
            LET sr.tur02=sr1.tur02
            LET sr.tur03=sr1.tur03
            LET sr.tur12=sr1.tur12     #No.FUN-8B0104 add
            LET sr.tur04=0
            LET sr.tur05=0
            LET sr.last_tur09=0
            #OUTPUT TO REPORT r301_rep(sr.*)  #TSD.c123k mark
 
            #FUN-740081 TSD.c123k add --------------------
            SELECT occ02 INTO sr.occ02 FROM occ_file
             WHERE occ01 = sr.tur01
            IF cl_null(sr.occ02) THEN LET sr.occ02 = ' ' END IF
 
#No.FUN-8B0104 add --begin
            SELECT occ02 INTO sr.occ021 FROM occ_file
             WHERE occ01 = sr.tur12
             IF cl_null(sr.occ021) THEN LET sr.occ021 = ' ' END IF
#No.FUN-8B0104 add --end--
 
            #-----MOD-9A0036---------                                           
            #SELECT cob02 INTO sr.cob02 FROM cob_file                           
            # WHERE cob01 = sr.tur02                                            
            #IF cl_null(sr.cob02) THEN LET sr.cob02 = ' ' END IF                
            #                                                                   
            #SELECT cob021 INTO sr.cob021 FROM cob_file                         
            # WHERE cob01 = sr.tur02                                            
            #IF cl_null(sr.cob021) THEN LET sr.cob021 = ' ' END IF              
            SELECT ima02 INTO sr.ima02 FROM ima_file                            
             WHERE ima01 = sr.tur02                                             
            IF cl_null(sr.ima02) THEN LET sr.ima02 = ' ' END IF                 
                                                                                
            SELECT ima021 INTO sr.ima021 FROM ima_file                          
             WHERE ima01 = sr.tur02                                             
            IF cl_null(sr.ima021) THEN LET sr.ima021 = ' ' END IF               
            #-----END MOD-9A0036-----
            
            #FUN-740081 TSD.c123k end ---------------------
 
            ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740081 *** #
            EXECUTE insert_prep USING
            #  sr.tur01,  sr.occ02,  sr.occ021, sr.tur02,  sr.cob02,  sr.cob021,  #No.FUN-8B0104 add   #No.TQC-A50164
               sr.tur01,  sr.occ02,  sr.occ021, sr.tur02,  sr.ima02,  sr.ima021,  #No.FUN-8B0104 add   #No.TQC-A50164
               sr.tur03,  sr.tur04,  sr.tur05,  sr.tur06,  sr.tur07, 
               sr.tur08,  sr.tur09,  sr.tur12,  sr.last_tur09    #No.FUN-8B0104 add 
            #------------------------------ CR (3) -------------------------------
         ELSE
            CONTINUE FOREACH
         END IF
      ELSE
         #期初不為零或期間不為零
         FOR l_i = tm.m1 TO tm.m2
            LET sr.tur01=sr1.tur01
            LET sr.tur02=sr1.tur02
            LET sr.tur03=sr1.tur03
            LET sr.tur12=sr1.tur12    #No.FUN-8B0104 
            LET sr.tur04=tm.yyyy
            LET sr.tur05=l_i
            LET sr.last_tur09 = l_tur09
            #No.MOD-930175 add --begin
            LET sr.tur06 = NULL  LET sr.tur07 = NULL
            LET sr.tur08 = NULL  LET sr.tur09 = NULL
            #No.MOD-930175 add --end
            SELECT tur06,tur07,tur08,tur09 
              INTO sr.tur06,sr.tur07,sr.tur08,sr.tur09
              FROM tur_file
             WHERE tur01=sr.tur01 AND tur02=sr.tur02
               AND tur03=sr.tur03 AND tur04=sr.tur04
               AND tur05=sr.tur05
               AND tur11 = g_tur11
               AND tur12 = sr.tur12   #No.FUN-8B0104 add
 
            IF cl_null(sr.tur06) THEN LET sr.tur06=0 END IF 
            IF cl_null(sr.tur07) THEN LET sr.tur07=0 END IF 
            IF cl_null(sr.tur08) THEN LET sr.tur08=0 END IF 
            IF cl_null(sr.tur09) THEN LET sr.tur09=0 END IF
            IF sr.tur06 = 0 AND sr.tur07 = 0 AND
               sr.tur08 = 0 AND sr.tur09 = 0 AND tm.a = 'N' THEN
               CONTINUE FOR
            END IF
            #OUTPUT TO REPORT r301_rep(sr.*)  #TSD.c123k mark
            
            #FUN-740081 TSD.c123k add --------------------
            SELECT occ02 INTO sr.occ02 FROM occ_file
             WHERE occ01 = sr.tur01
            IF cl_null(sr.occ02) THEN LET sr.occ02 = ' ' END IF
 
#No.FUN-8B0104 add --begin
            SELECT occ02 INTO sr.occ021 FROM occ_file
             WHERE occ01 = sr.tur12
            IF cl_null(sr.occ021) THEN LET sr.occ021 = ' ' END IF 
#No.FUN-8B0104 add --end--
 
            #-----MOD-9A0036---------                                           
            #SELECT cob02 INTO sr.cob02 FROM cob_file                           
            # WHERE cob01 = sr.tur02                                            
            #IF cl_null(sr.cob02) THEN LET sr.cob02 = ' ' END IF                
            #                                                                   
            #SELECT cob021 INTO sr.cob021 FROM cob_file                         
            # WHERE cob01 = sr.tur02                                            
            #IF cl_null(sr.cob021) THEN LET sr.cob021 = ' ' END IF              
            SELECT ima02 INTO sr.ima02 FROM ima_file                            
             WHERE ima01 = sr.tur02                                             
            IF cl_null(sr.ima02) THEN LET sr.ima02 = ' ' END IF                 
                                                                                
            SELECT ima021 INTO sr.ima021 FROM ima_file                          
             WHERE ima01 = sr.tur02                                             
            IF cl_null(sr.ima021) THEN LET sr.ima021 = ' ' END IF               
            #-----END MOD-9A0036-----
            #FUN-740081 TSD.c123k end ---------------------
 
            ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740081 *** #
            EXECUTE insert_prep USING
            #  sr.tur01,  sr.occ02,  sr.occ021, sr.tur02,  sr.cob02,  sr.cob021,  #No.FUN-8B0104 add  #No.TQC-A50164
               sr.tur01,  sr.occ02,  sr.occ021, sr.tur02,  sr.ima02,  sr.ima021,  #No.FUN-8B0104 add  #No.TQC-A50164
               sr.tur03,  sr.tur04,  sr.tur05,  sr.tur06,  sr.tur07, 
               sr.tur08,  sr.tur09,  sr.tur12,  sr.last_tur09      #No.FUN-8B0104 add
            #------------------------------ CR (3) -------------------------------
         END FOR
      END IF
   END FOREACH
 
   #FINISH REPORT r301_rep  #TSD.c123k mark
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #TSD.c123k mark
 
   # FUN-740081 START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'tur01,tur02,tur03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.yyyy,";",tm.m1,";",tm.m2,";",tm.a,";",g_tur11   #TQC-760162 add g_tur11
 
   CALL cl_prt_cs3('atmr301','atmr301',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   # FUN-740081 end
   LET g_prog = l_prog      #TQC-760162 add
 
END FUNCTION
