# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: gnmr940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 2003/10/14 By Winny Wu
# Modify.........: No.FUN-520004 05/03/04 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-580110 05/08/24 By Tracy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-640004 06/04/05 By ice 新增傳參供gglp160(會計核算接口程序)調用
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680145 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.MOD-6C0171 06/12/27 By Rayven 報表格式有點奇怪，參照.per檔修改
# Modify.........: No.FUN-710056 07/02/05 By Carrier 透過gglp160無法產生XJLLB_1.TXT
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-720013 07/03/01 By TSD.Ken #CR11
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80038 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
              title   LIKE type_file.chr20,  #NO FUN-680145 VARCHAR(20)    #輸入報表名稱
              y1      LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #輸入起始年度
              m1      LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #Begin 期別
              y2      LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #輸入截止年度
              m2      LIKE type_file.num5,   #NO FUN-680145 SMALLINT    #End   期別
              c       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(1)     #異動額及餘額為0者是否列印
              d       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(1)     #金額單位
              o       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(1)     #轉換幣別否
              r       LIKE azi_file.azi01,   #總帳幣別
              p       LIKE azi_file.azi01,   #轉換幣別
              q       LIKE azj_file.azj03,   #匯率
              more    LIKE type_file.chr1    #NO FUN-680145 VARCHAR(1)     #Input more condition(Y/N)
              END RECORD,
          bdate,edate LIKE type_file.dat,    #NO FUN-680145 DATE
          l_za05      LIKE type_file.chr1000,#NO FUN-680145 VARCHAR(40)
          g_bookno    LIKE aah_file.aah00,   #帳別
          g_unit      LIKE type_file.num10   #NO FUN-680145 INTEGER 
DEFINE   g_i          LIKE type_file.num5    #NO FUN-680145 SMALLINT       #count/index for any purpose
DEFINE   g_before_input_done  LIKE type_file.num5           #NO FUN-680145 SMALLINT
DEFINE   p_cmd        LIKE type_file.chr1    #NO FUN-680145 VARCHAR(1)
DEFINE   g_msg        LIKE type_file.chr1000 #NO FUN-680145 VARCHAR(100)
DEFINE   g_name       LIKE type_file.chr1000 #FILENAME FUN-640004  #NO FUN-680145  VARCHAR(60)
DEFINE   g_flag       LIKE type_file.chr1    #Y:產生接口數據 N:正常打印 FUN-640004  #NO FUN-680145 VARCHAR(01)
DEFINE   g_ym         LIKE azj_file.azj02    #年期 FUN-640004      #NO FUN-680145  VARCHAR(06)
DEFINE   l_zaa02      LIKE zaa_file.zaa02    #No.FUN-640004  
DEFINE   l_zaa08      LIKE zaa_file.zaa08    #No.FUN-640004
DEFINE l_table        STRING,                   ### CR11 ###
       g_str          STRING,                   ### CR11 ###
       g_sql          STRING                    ### CR11 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
 
#FUN-720013 - START
## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
 
 LET g_sql = "  chr.type_file.chr1, ",
             " type.type_file.chr1, ",
             " nml01.nml_file.nml01, ",
             " nml02.nml_file.nml02, ",
             " nml03.nml_file.nml03, ",
             " amt.nme_file.nme08,   ",
             " azi04.azi_file.azi04 "
 
  LET l_table = cl_prt_temptable('gnmr940',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
# LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,          #No.TQC-780054
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-780054
              " VALUES(?, ?, ?, ?, ?, ?, ?) "
 
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
#----------------------------------------------------------CR (1) ------------#
#FUN-720013 - END
 
   LET g_trace = 'N'               # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   #-----TQC-610056---------
   LET tm.title = ARG_VAL(8)
   LET tm.y1 = ARG_VAL(9)
   LET tm.y2 = ARG_VAL(10)
   LET tm.m1 = ARG_VAL(11)
   LET tm.m2 = ARG_VAL(12)
   LET tm.c = ARG_VAL(13)
   LET tm.d = ARG_VAL(14)
   LET tm.o = ARG_VAL(15)
   LET tm.r = ARG_VAL(16)
   LET tm.p = ARG_VAL(17)
   LET tm.q = ARG_VAL(18)
   #-----END TQC-610056-----
   #No.FUN-630090 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
   #No.FUN-640004 --start--
   IF NOT (cl_null(tm.y1) OR cl_null(tm.m1)) THEN
      LET g_flag = 'Y'
      LET g_ym = tm.y1 USING '&&&&',tm.m1 USING '&&'
      SELECT aaa03 INTO tm.r FROM aaa_file WHERE aaa01 = g_nmz.nmz02b
      IF cl_null(tm.m2) THEN LET tm.m2 = tm.m1 END IF
      IF cl_null(tm.title) THEN LET tm.title = g_name END IF
      LET tm.c = 'Y'
      LET tm.d = '1'
      LET tm.o = 'N'
      LET tm.p = tm.r
      LET tm.q = 1
      LET tm.more = 'N'
      LET g_pdate  = g_today
      LET g_bgjob  = 'N'
      LET g_copies = '1'
      IF tm.d = '1' THEN LET g_unit = 1 END IF
      IF tm.d = '2' THEN LET g_unit = 1000 END IF
      IF tm.d = '3' THEN LET g_unit = 1000000 END IF
   ELSE
      LET g_flag = 'N'
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80038--add--
   IF g_flag = 'N' THEN
      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL r940_tm()         # Input print condition
         ELSE CALL r940()            # Read data and create out-file
      END IF
   ELSE
      CALL r940()                    # Read data and create out-file
   END IF
   #No.FUN-640004 --end--
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
END MAIN
 
FUNCTION r940_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO FUN-680145 SMALLINT
          l_sw           LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01)  #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000   #NO FUN-680145 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r940_w AT p_row,p_col
        WITH FORM "gnm/42f/gnmr940"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL            # Default condition
   SELECT aaa03 INTO tm.r FROM aaa_file WHERE aaa01 = g_nmz.nmz02b
   LET tm.title = g_x[1]
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.p = tm.r
   LET tm.q = 1
   LET tm.more = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET g_rlang = g_lang   #No.MOD-6C0171 因為抓不到語言別，所以取不到zaa里維護的數據
WHILE TRUE
 INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,
                  tm.d,tm.c,tm.o,tm.r,tm.p,tm.q,tm.more
                  WITHOUT DEFAULTS
 
      ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
      BEFORE INPUT
         CALL r940_set_entry(p_cmd)
         CALL r940_set_no_entry(p_cmd)
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD y1
         IF NOT cl_null(tm.y1) THEN
            IF tm.y1 = 0 THEN
               NEXT FIELD y1
            END IF
            LET tm.y2=tm.y1
         END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
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
#         IF tm.m1 <1 OR tm.m1 > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD m1
#         END IF
#No.TQC-720032 -- end -- 
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
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
#         IF tm.m2 <1 OR tm.m2 > 13 THEN
#            CALL cl_err('','anm-013',0) NEXT FIELD m2
#         END IF
#No.TQC-720032 -- end --
         IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
            CALL cl_err('','9011',0) NEXT FIELD m1
         END IF
 
      BEFORE FIELD o
         CALL r940_set_entry(p_cmd)
 
      AFTER FIELD o
         IF tm.o IS NOT NULL THEN
            IF tm.o = 'N' THEN
               LET tm.q = 1
               LET tm.p = tm.r
               DISPLAY BY NAME tm.q,tm.p
            END IF
         END IF
         CALL r940_set_no_entry(p_cmd)
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(tm.p,'mfg3008',0)   #No.FUN-660146
            CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0)    #No.FUN-660146
            NEXT FIELD p 
         END IF
 
      AFTER FIELD q
         IF tm.q <= 0 THEN
            NEXT FIELD q
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
         IF tm.o = 'N' THEN
            LET tm.q = 1
            LET tm.p = tm.r
         END IF
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
      ON ACTION CONTROLP
         CASE
                 WHEN INFIELD(p)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = tm.p
                   CALL cl_create_qry() RETURNING tm.p
                   DISPLAY tm.p TO p
            NEXT FIELD p
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
  #-----TQC-610056---------
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='gnmr940'
     IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('gnmr940','9031',1)
     ELSE
        LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_bookno CLIPPED,"'" ,
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.title CLIPPED,"'",
                     " '",tm.y1 CLIPPED,"'",
                     " '",tm.y2 CLIPPED,"'",
                     " '",tm.m1 CLIPPED,"'",
                     " '",tm.m2 CLIPPED,"'",
                     " '",tm.c CLIPPED,"'",
                     " '",tm.d CLIPPED,"'",
                     " '",tm.o CLIPPED,"'",
                     " '",tm.r CLIPPED,"'",
                     " '",tm.p CLIPPED,"'",
                     " '",tm.q CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",
                     " '",g_rep_clas CLIPPED,"'",
                     " '",g_template CLIPPED,"'"
         CALL cl_cmdat('gnmr940',g_time,l_cmd)    # Execute cmd at later time #
     END IF
     CLOSE WINDOW r940_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
     EXIT PROGRAM
  END IF
  #-----END TQC-610056-----
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r940_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r940()
   ERROR ""
END WHILE
   CLOSE WINDOW r940_w
END FUNCTION
 
FUNCTION r940()
     DEFINE l_name    LIKE type_file.chr20    #NO FUN-680145 VARCHAR(20)       # External(Disk) file name
#     DEFINE     l_time LIKE type_file.chr8        #No.FUN-6A0098
     DEFINE l_chr     LIKE type_file.chr1     #NO FUN-680145 VARCHAR(1)
     DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-680145 VARCHAR(1000)     # RDSQL STATEMENT
     DEFINE l_bdate,l_edate    LIKE type_file.dat        #NO FUN-680145 DATE
     DEFINE sr        RECORD
                      chr      LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)
                      type     LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)
                      nml01    LIKE nml_file.nml01,
                      nml02    LIKE nml_file.nml02,
                      nml03    LIKE nml_file.nml03,
                      amt      LIKE nme_file.nme08
                      END RECORD
     #No.FUN-640004 --start--
     DEFINE sr1       RECORD
                      chr      LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)  
                      type     LIKE type_file.chr1,      #NO FUN-680145 VARCHAR(01)
                      nml01    LIKE nml_file.nml01,
                      nml02    LIKE nml_file.nml02,
                      nml03    LIKE nml_file.nml03,
                      amt      LIKE nme_file.nme08
                      END RECORD
     #No.FUN-640004 --end--
 
     #No.FUN-B80038--mark--Begin---
     # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-B80038--mark--End-----
     #FUN-720013 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
        CALL cl_del_data(l_table)
        SELECT zz05 INTO g_zz05 
          FROM zz_file 
         WHERE zz01 = g_prog   ### CR11 add ###
     #FUN-720013 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     CALL s_azn01(tm.y1,tm.m1) RETURNING bdate,l_edate
     CALL s_azn01(tm.y1,tm.m2) RETURNING l_bdate,edate
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = tm.r   #No.CHI-6A0004
     IF tm.d != '1' THEN LET t_azi04 = 0 END IF                   #No.CHI-6A0004
 
    #No.FUN-710056  --Begin                                                     
    IF g_flag = 'N' THEN                                                        
       LET l_sql = "SELECT '1','',nml01,nml02,nml03,SUM(nme08),' ' ",               
                   "  FROM nml_file,OUTER nme_file ",                           
                   " WHERE nml01 = nme14 ",                                     
                   "   AND nmlacti = 'Y' AND nmeacti = 'Y' ",                   
                   "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
                   "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
                   "                  WHERE nmc03 = '1' and nmcacti='Y') ",     
                   " GROUP BY 1,2,3,4,5 ",                                      
                   " UNION ALL ",                                               
                   "SELECT '2','',nml01,nml02,nml03,SUM(nme08),' ' ",               
                   "  FROM nml_file,OUTER nme_file ",                           
                   " WHERE nml01 = nme14 ",                                     
                   "   AND nmlacti = 'Y' AND nmeacti = 'Y' ",                   
                   "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
                   "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
                   "                  WHERE nmc03 = '2' and nmcacti='Y') ",     
                   " GROUP BY 1,2,3,4,5 ",                                      
                   " ORDER BY nml03,nml01"                                      
    ELSE                                                                        
       LET l_sql = "SELECT '1','',nml01,nml02,nml03,SUM(nme08) ",               
                   "  FROM nml_file LEFT OUTER JOIN nme_file ",
                   "    ON (nml01 = nme14 AND nmeacti = 'Y' ",                  
                   "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
                   "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
                   "                  WHERE nmc03 = '1' and nmcacti='Y')) ",    
                   " WHERE nmlacti = 'Y' ",                                     
                   " GROUP BY '1','',nml01,nml02,nml03 ",                       
                   " UNION ALL ",                                               
                   "SELECT '2','',nml01,nml02,nml03,SUM(nme08) ",               
                   "  FROM nml_file LEFT OUTER JOIN nme_file ",                 
                   "    ON (nml01 = nme14 AND nmeacti = 'Y' ",                  
                   "   AND nme16 BETWEEN '",bdate,"' AND '",edate,"'",          
                   "   AND nme03 IN (SELECT nmc01 FROM nmc_file ",              
                   "                  WHERE nmc03 = '2' and nmcacti='Y')) ",    
                   " WHERE nmlacti = 'Y' ",                                     
                   " GROUP BY '2','',nml01,nml02,nml03 ",                       
                   " ORDER BY nml03,nml01"                                      
    END IF                                                                      
    #No.FUN-710056  --End   
     PREPARE gnmr940_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmr940_curs CURSOR FOR gnmr940_prepare
 
     #No.FUN-640004 --start--
     IF g_flag = 'Y' THEN
        LET l_name = g_name
        DECLARE r940_r2 CURSOR FOR
           SELECT zaa02,zaa08
             FROM zaa_file 
            WHERE zaa01 = g_prog
              AND zaa03 = g_lang
              AND ((zaa04='default' AND zaa17='default') 
                  OR zaa04=g_user OR zaa17 = g_clas)
              AND zaa10 = 'N'
        FOREACH r940_r2 INTO l_zaa02,l_zaa08
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_x[l_zaa02] = l_zaa08
        END FOREACH
        CALL cl_outnam('gnmr940') RETURNING l_name
        LET l_name = tm.title  #No.FUN-710056 
        START REPORT r940_rep1 TO l_name
     ELSE
     END IF
     #No.FUN-640004 --end--
 
     LET g_pageno = 0
     FOREACH gnmr940_curs INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET sr.type = sr.nml03[1,1]
        #No.FUN-640004 --start--
        IF g_flag = 'Y' THEN
           LET sr1.* = sr.*
           OUTPUT TO REPORT r940_rep1(sr1.*)
        ELSE
           #FUN-720013 - START
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.chr,   sr.type, sr.nml01, sr.nml02,
                                     sr.nml03, sr.amt,  t_azi04
           #------------------------------ CR (3) ------------------------------#
           #FUN-720013 - END
        END IF
        #No.FUN-640004 --end--
     END FOREACH
 
     #No.FUN-640004 --start--
     IF g_flag = 'Y' THEN
        FINISH REPORT r940_rep1
     ELSE
          #FUN-720013 - START
          ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
          LET g_str = ''
          #是否列印選擇條件
          IF g_zz05 = 'Y' THEN
             #CALL cl_wcchp(tm.wc,'')
             #     RETURNING tm.wc
             #LET g_str = tm.wc
          END IF
          LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          LET g_str = g_str
          CALL cl_prt_cs3('gnmr940','gnmr940',l_sql,g_str)
          #------------------------------ CR (4) ------------------------------#
          #FUN-720013 - END
     END IF
     #No.FUN-640004 --end--
 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT r940_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1      #NO FUN-680145 VARCHAR(01)
   DEFINE l_amt       LIKE nme_file.nme08
   DEFINE l_amt2      LIKE nme_file.nme08
   DEFINE l_cash      LIKE nme_file.nme08
   DEFINE cash_in     LIKE nme_file.nme08
   DEFINE cash_out    LIKE nme_file.nme08
   DEFINE l_count     LIKE nme_file.nme08
   DEFINE l_count_in  LIKE nme_file.nme08
   DEFINE l_count_out LIKE nme_file.nme08
   DEFINE l_unit      LIKE type_file.chr4      #NO FUN-680145 VARCHAR(04)
   DEFINE l_x         LIKE type_file.num5      #NO FUN-680145 SMALLINT
   DEFINE sr          RECORD
                      chr      LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                      type     LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                      nml01    LIKE nml_file.nml01,
                      nml02    LIKE nml_file.nml02,
                      nml03    LIKE nml_file.nml03,
                      amt      LIKE nme_file.nme08
                      END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.type,sr.nml03,sr.nml01,sr.chr
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED  #No.MOD-6C0171
      PRINT #No.MOD-6C0171
      PRINT COLUMN (g_len-FGL_WIDTH(tm.title))/2,tm.title CLIPPED
      #報表結構,報表名稱,幣別,單位
      CASE tm.d
           WHEN '1'  LET l_unit = g_x[19]
           WHEN '2'  LET l_unit = g_x[20]
           WHEN '3'  LET l_unit = g_x[21]
           OTHERWISE LET l_unit = ' '
      END CASE
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"   #No.MOD-6C0171
      PRINT g_x[25] CLIPPED,tm.p,
            COLUMN 13,g_x[8] CLIPPED,l_unit
      PRINT g_head CLIPPED,pageno_total                 #No.MOD-6C0171
      PRINT g_dash
      PRINT g_x[31],g_x[32]
      PRINT g_dash1
      LET l_last_sw = 'n'
      IF g_pageno = 1 THEN
         LET l_count = 0
         LET cash_in = 0
         LET cash_out= 0
      END IF
 
   BEFORE GROUP OF sr.type
      CASE sr.type
        WHEN '1' PRINT COLUMN g_c[31],g_x[9]
        WHEN '2' PRINT COLUMN g_c[31],g_x[11]
        WHEN '3' PRINT COLUMN g_c[31],g_x[13]
        WHEN '4' PRINT COLUMN g_c[31],g_x[15]
        OTHERWISE EXIT CASE
      END CASE
      PRINT g_dash2
 
   AFTER GROUP OF sr.nml01
      LET l_amt  = GROUP SUM(sr.amt) WHERE sr.chr = '1'    #存入
      LET l_amt2 = GROUP SUM(sr.amt) WHERE sr.chr = '2'    #提出
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
      IF sr.nml03[2,2]='0' THEN     #流入
         LET l_amt = l_amt - l_amt2
         LET cash_in = cash_in + l_amt
         LET l_count = l_count + l_amt
      ELSE                          #流出
         LET l_amt = l_amt2 - l_amt
         LET cash_out = cash_out + l_amt
         LET l_count = l_count - l_amt
      END IF
      LET l_amt = l_amt * tm.q / g_unit
      IF tm.c = 'Y' OR sr.amt != 0 THEN
         PRINT COLUMN g_c[31],sr.nml02,
               COLUMN g_c[32],cl_numfor(l_amt,18,t_azi04)  #No.CHI-6A0004
         PRINT g_dash2
      END IF
 
   AFTER GROUP OF sr.nml03
      IF sr.nml03 <> '40' THEN
          PRINT COLUMN g_c[31],g_x[sr.nml03 MOD 10 + 17];#No.FUN-580110
          IF sr.nml03[2,2] = '0' THEN
              LET cash_in = cash_in * tm.q / g_unit
              PRINT COLUMN g_c[32],cl_numfor(cash_in,18,t_azi04) #No.FUN-580110  #No.CHI-6A0004
              PRINT g_dash2
          ELSE
              LET cash_out = cash_out * tm.q / g_unit
              PRINT COLUMN g_c[32],cl_numfor(cash_out,18,t_azi04) #No.FUN-580110  #No.CHI-6A0004
              PRINT g_dash2
          END IF
      END IF
 
   AFTER GROUP OF sr.type
      CASE sr.type
        WHEN '1'
             LET l_cash = (cash_in - cash_out) * tm.q / g_unit
             PRINT COLUMN g_c[31],g_x[10] CLIPPED,
                   COLUMN g_c[32],cl_numfor(l_cash,18,t_azi04)  #No.CHI-6A0004
             PRINT g_dash2
             LET cash_in = 0
             LET cash_out = 0
        WHEN '2'
             LET l_cash = (cash_in - cash_out) * tm.q / g_unit
             PRINT COLUMN g_c[31],g_x[12] CLIPPED,
                   COLUMN g_c[32],cl_numfor(l_cash,18,t_azi04)   #No.CHI-6A0004
             PRINT g_dash2
             LET cash_in = 0
             LET cash_out = 0
        WHEN '3'
             LET l_cash = (cash_in - cash_out) * tm.q / g_unit
             PRINT COLUMN g_c[31],g_x[14] CLIPPED,
                   COLUMN g_c[32],cl_numfor(l_cash,18,t_azi04)   #No.CHI-6A0004
             PRINT g_dash2
             LET cash_in = 0
             LET cash_out = 0
        OTHERWISE EXIT CASE
      END CASE
 
   ON LAST ROW
      LET l_last_sw = 'y'
      LET l_count = l_count * tm.q / g_unit
      PRINT COLUMN g_c[31],g_x[16],
            COLUMN g_c[32],cl_numfor(l_count,18,t_azi04)  #No.CHI-6A0004
      PRINT g_dash
      PRINT g_x[4], COLUMN (g_len-9), g_x[7] CLIPPED                #No.MOD-6C0171
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4], COLUMN (g_len-9), g_x[6] CLIPPED                #No.MOD-6C0171
      ELSE SKIP 2 LINE
      END IF
 
END REPORT
FUNCTION r940_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-680145 VARCHAR(01)
 
    CALL cl_set_comp_entry("p,q",TRUE)
 
END FUNCTION
 
FUNCTION r940_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-680145 VARCHAR(01)
 
    IF tm.o = 'N' THEN
       CALL cl_set_comp_entry("p,q",FALSE)
    END IF
 
END FUNCTION
 
#Patch....NO.TQC-610037 <> #
#No.FUN-640004 --start--
REPORT r940_rep1(sr1)
   DEFINE l_amt1       LIKE nme_file.nme08
   DEFINE l_amt21      LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   DEFINE l_count_in1  LIKE nme_file.nme08
   DEFINE l_count_out1 LIKE nme_file.nme08
   DEFINE l_unit1      LIKE type_file.chr4     #NO FUN-680145 VARCHAR(04)
   DEFINE l_nml05      LIKE nml_file.nml05     #行次
   DEFINE l_sharp      LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE i            LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE l_n          LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE sr1          RECORD
                       chr      LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                       type     LIKE type_file.chr1,    #NO FUN-680145 VARCHAR(01)
                       nml01    LIKE nml_file.nml01,
                       nml02    LIKE nml_file.nml02,
                       nml03    LIKE nml_file.nml03,
                       amt      LIKE nme_file.nme08
                       END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr1.type,sr1.nml03,sr1.nml01,sr1.chr
   FORMAT
      PAGE HEADER
         #報表結構,報表名稱,幣別,單位
         CASE tm.d
            WHEN '1'  LET l_unit1 = g_x[19]
            WHEN '2'  LET l_unit1 = g_x[20]
            WHEN '3'  LET l_unit1 = g_x[21]
            OTHERWISE LET l_unit1 = ' '
         END CASE
         LET g_pageno = g_pageno + 1
         IF g_pageno = 1 THEN
            LET l_count1 = 0
            LET cash_in1 = 0
            LET cash_out1= 0
         END IF
         LET t_azi04 = 2    #取兩位小數   #No.CHI-6A0004
         LET g_x[9]  = g_x[26]
         LET g_x[11] = g_x[27]
         LET g_x[13] = g_x[28]
         LET g_x[15] = g_x[29]
         LET g_x[16] = g_x[30]
         LET g_x[10] = g_x[33]
         LET g_x[12] = g_x[34]
         LET g_x[14] = g_x[35]
 
      BEFORE GROUP OF sr1.type
         CASE sr1.type
            WHEN '1' 
               PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                     '\t',
                     '\"',g_company CLIPPED,'\"',  #編制單位
                     '\t',
                     '\"',g_ym CLIPPED,'\"',       #報告期
                     '\t',
                     '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                     '\t',
                     '\"',g_x[9] CLIPPED,'\"',    #項目
                     '\t','\t'
            WHEN '2'
               PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                     '\t',
                     '\"',g_company CLIPPED,'\"',  #編制單位
                     '\t',
                     '\"',g_ym CLIPPED,'\"',       #報告期
                     '\t',
                     '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                     '\t',
                     '\"',g_x[11] CLIPPED,'\"',   #項目
                     '\t','\t'
            WHEN '3'
               PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                     '\t',
                     '\"',g_company CLIPPED,'\"',  #編制單位
                     '\t',
                     '\"',g_ym CLIPPED,'\"',       #報告期
                     '\t',
                     '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                     '\t',
                     '\"',g_x[13] CLIPPED,'\"',   #項目
                     '\t','\t'
#           WHEN '4' 
#              PRINT '\"',g_x[15] CLIPPED,'\"';   #項目
#           OTHERWISE PRINT '';
         END CASE
 
   AFTER GROUP OF sr1.nml01
      LET l_amt1  = GROUP SUM(sr1.amt) WHERE sr1.chr = '1'    #存入
      LET l_amt21 = GROUP SUM(sr1.amt) WHERE sr1.chr = '2'    #提出
      SELECT nml05 INTO l_nml05 FROM nml_file WHERE nml01 = sr1.nml01
      IF NOT cl_null(l_nml05) THEN
         LET l_sharp = FGL_WIDTH(l_nml05)
      END IF
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      IF cl_null(l_amt21) THEN LET l_amt21 = 0 END IF
      IF sr1.nml03[2,2]='0' THEN     #流入
         LET l_amt1 = l_amt1 - l_amt21
         LET cash_in1 = cash_in1 + l_amt1
#        LET l_count1 = l_count1 + l_amt1
      ELSE                          #流出
         LET l_amt1 = l_amt21 - l_amt1
         LET cash_out1 = cash_out1 + l_amt1
#        LET l_count1 = l_count1 - l_amt1
      END IF
      LET l_amt1 = l_amt1 * tm.q / g_unit
      IF tm.c = 'Y' OR sr1.amt != 0 THEN
         PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
               '\t',
               '\"',g_company CLIPPED,'\"',  #編制單位
               '\t',
               '\"',g_ym CLIPPED,'\"',       #報告期
               '\t',
               '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
               '\t',
               '\"',sr1.nml02 CLIPPED,'\"',   #項目
               '\t';
         IF cl_null(l_nml05) THEN
            PRINT '\"','\"';                     #行次
         ELSE
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_nml05 USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_nml05 USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_nml05 USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_nml05 USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_nml05 USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
         END IF
         PRINT '\t',
               r940_numfor(l_amt1,t_azi04)  #No.CHI-6A0004
      END IF
 
   AFTER GROUP OF sr1.nml03
      IF sr1.nml03 <> '40' THEN
         SELECT MAX(nml05) +1 INTO l_n 
           FROM nml_file
          WHERE nml03 = sr1.nml03
      IF sr1.nml03 = '11' THEN
         LET l_n = l_n + 1
      END IF
      IF NOT cl_null(l_n) THEN
         LET l_sharp = FGL_WIDTH(l_n)
      END IF
      PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
            '\t',
            '\"',g_company CLIPPED,'\"',  #編制單位
            '\t',
            '\"',g_ym CLIPPED,'\"',       #報告期
            '\t',
            '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
            '\t',
            '\"',g_x[sr1.nml03 MOD 10 + 17] CLIPPED,'\"',     #項目
            '\t';
      CASE l_sharp
         WHEN "1"
            PRINT '\"',l_n USING '#','\"';  #行次
         WHEN "2"
            PRINT '\"',l_n USING '##','\"';  #行次
         WHEN "3"
            PRINT '\"',l_n USING '###','\"';  #行次
         WHEN "4"
            PRINT '\"',l_n USING '####','\"';  #行次
         WHEN "5"
            PRINT '\"',l_n USING '#####','\"';  #行次
         OTHERWISE 
            PRINT ;
      END CASE
      PRINT '\t';
          IF sr1.nml03[2,2] = '0' THEN
              LET cash_in1 = cash_in1 * tm.q / g_unit
              PRINT r940_numfor(cash_in1,t_azi04)   #No.CHI-6A0004
          ELSE
              LET cash_out1 = cash_out1 * tm.q / g_unit
              PRINT r940_numfor(cash_out1,t_azi04)    #No.CHI-6A0004
          END IF
      END IF
 
   AFTER GROUP OF sr1.type
      SELECT MAX(nml05) + 2 INTO l_n
        FROM nml_file
       WHERE nml03[1,1] = sr1.type
      IF sr1.nml03 = '11' THEN
         LET l_n = l_n + 1
      END IF
      IF NOT cl_null(l_n) THEN
         LET l_sharp = FGL_WIDTH(l_n)
      END IF
      CASE sr1.type
         WHEN '1'
            LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
            PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                        '\t',
                  '\"',g_company CLIPPED,'\"',  #編制單位
                  '\t',
                  '\"',g_ym CLIPPED,'\"',       #報告期
                  '\t',
                  '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                  '\t',
                  '\"',g_x[10] CLIPPED,'\"',     #項目
                  '\t';
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_n USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_n USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_n USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_n USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_n USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
            PRINT '\t',
                  r940_numfor(l_cash1,t_azi04)    #No.CHI-6A0004
            LET cash_in1 = 0
            LET cash_out1 = 0
            LET l_count1 = l_count1 + l_cash1
         WHEN '2'
            LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
            PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                        '\t',
                  '\"',g_company CLIPPED,'\"',  #編制單位
                  '\t',
                  '\"',g_ym CLIPPED,'\"',       #報告期
                  '\t',
                  '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                  '\t';
            PRINT '\"',g_x[12] CLIPPED,'\"',     #項目
                  '\t';
#                 '\"','\"',                     #行次
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_n USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_n USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_n USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_n USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_n USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
            PRINT '\t',
                  r940_numfor(l_cash1,t_azi04)    #No.CHI-6A0004
            LET cash_in1 = 0
            LET cash_out1 = 0
            LET l_count1 = l_count1 + l_cash1
         WHEN '3'
            LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
            PRINT '\"',g_x[5] CLIPPED,'\"',                    #報表編號
                        '\t',
                  '\"',g_company CLIPPED,'\"',  #編制單位
                  '\t',
                  '\"',g_ym CLIPPED,'\"',       #報告期
                  '\t',
                  '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
                  '\t';
            PRINT '\"',g_x[14] CLIPPED,'\"',     #項目
                  '\t';
#                 '\"','\"',                     #行次
            CASE l_sharp
               WHEN "1"
                  PRINT '\"',l_n USING '#','\"';  #行次
               WHEN "2"
                  PRINT '\"',l_n USING '##','\"';  #行次
               WHEN "3"
                  PRINT '\"',l_n USING '###','\"';  #行次
               WHEN "4"
                  PRINT '\"',l_n USING '####','\"';  #行次
               WHEN "5"
                  PRINT '\"',l_n USING '#####','\"';  #行次
               OTHERWISE 
                  PRINT ;
            END CASE
            PRINT '\t',
                  r940_numfor(l_cash1,t_azi04)  #No.CHI-6A0004
            LET cash_in1 = 0
            LET cash_out1 = 0
            LET l_count1 = l_count1 + l_cash1
#        OTHERWISE PRINT
      END CASE
 
   ON LAST ROW
      SELECT MAX(nml05)+1 INTO l_n FROM nml_file  #尋求最大行次
      LET l_count1 = l_count1 * tm.q / g_unit
      IF NOT cl_null(l_n) THEN
         LET l_sharp = FGL_WIDTH(l_n)
      END IF
         PRINT '\"',g_x[5] CLIPPED,'\"',     #報表編號
               '\t',
               '\"',g_company CLIPPED,'\"',  #編制單位
               '\t',
               '\"',g_ym CLIPPED,'\"',       #報告期
               '\t',
               '\"',l_unit1 CLIPPED,'\"',     #貨幣單位
               '\t',
               '\"',g_x[16] CLIPPED,'\"',     #項目
               '\t';
         CASE l_sharp
            WHEN "1"
               PRINT '\"',l_n USING '#','\"';  #行次
            WHEN "2"
               PRINT '\"',l_n USING '##','\"';  #行次
            WHEN "3"
               PRINT '\"',l_n USING '###','\"';  #行次
            WHEN "4"
               PRINT '\"',l_n USING '####','\"';  #行次
            WHEN "5"
               PRINT '\"',l_n USING '#####','\"';  #行次
            OTHERWISE 
               PRINT ;
         END CASE
         PRINT '\t',
               r940_numfor(l_count1,t_azi04)   #No.CHI-6A0004
END REPORT
 
FUNCTION r940_numfor(p_value,p_n)
   DEFINE p_value	LIKE type_file.num26_10, #NO FUN-680145 DECIMAL(26,10)
          p_len,p_n     LIKE type_file.num5,     #NO FUN-680145	SMALLINT
          l_len 	LIKE type_file.num5,     #NO FUN-680145 SMALLINT
          l_str		LIKE type_file.chr1000,  #NO FUN-680145 VARCHAR(37)
          l_str1        LIKE type_file.chr1,     #NO FUN-680145 VARCHAR(37)    
          l_length      LIKE type_file.num5,     #NO FUN-680145 SMALLINT
          i,j,k         LIKE type_file.num5      #NO FUN-680145 SMALLINT
     
   LET p_value = cl_digcut(p_value,p_n)
   CASE WHEN p_n = 0  LET l_str = p_value USING '------------------------------------&'
        WHEN p_n = 10 LET l_str = p_value USING '-------------------------&.&&&&&&&&&&'
        WHEN p_n = 9  LET l_str = p_value USING '--------------------------&.&&&&&&&&&'
        WHEN p_n = 8  LET l_str = p_value USING '---------------------------&.&&&&&&&&'
        WHEN p_n = 7  LET l_str = p_value USING '----------------------------&.&&&&&&&'
        WHEN p_n = 6  LET l_str = p_value USING '-----------------------------&.&&&&&&'
        WHEN p_n = 5  LET l_str = p_value USING '------------------------------&.&&&&&'
        WHEN p_n = 4  LET l_str = p_value USING '-------------------------------&.&&&&'
        WHEN p_n = 3  LET l_str = p_value USING '--------------------------------&.&&&'
        WHEN p_n = 2  LET l_str = p_value USING '---------------------------------&.&&'
        WHEN p_n = 1  LET l_str = p_value USING '----------------------------------&.&'
   END CASE
   LET j=37                    #TQC-640038 
#  LET p_len = FGL_WIDTH(p_value)+p_n+1
   LET p_len = FGL_WIDTH(p_value)
   LET i = j - p_len + 9
   IF i < 0 THEN               #FUN-560048
        IF not cl_null(g_xml_rep) THEN
          LET i = 0
        ELSE
          LET i = 1
        END IF
   END IF
 
   LET l_length = 0
   #當傳進的金額位數實際上大於所要求回傳的位數時，該欄位應show"*****" NO:0508
   FOR k = 37 TO 1 STEP -1                        #MOD-590093 #TQC-640038
       LET l_str1 = l_str[k,k]
       IF cl_null(l_str1) THEN EXIT FOR END IF
       LET l_length = l_length + 1
   END FOR
   IF l_length > p_len THEN
      LET i = j - l_length
      IF i < 0 THEN
            RETURN l_str
      END IF
   END IF
   IF not cl_null(g_xml_rep) THEN
      RETURN l_str[i+1,j]
   ELSE 
      RETURN l_str[i,j]
   END IF
END FUNCTION
#No.FUN-640004 --end--
