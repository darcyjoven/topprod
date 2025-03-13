# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: acor207.4gl
# Descriptions...: 原材料出入庫明細帳
# Date & Author..: 05/01/27 by ice
# Modify.........: No.FUN-550036 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0108 05/11/12 By Claire 單據欄位放大
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-770006 07/07/24 By zhoufeng 報表打印產出改為Crystal Reports
# Modify.........: No.TQC-930034 09/03/10 By mike 解決溢位問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm  RECORD
                wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(500)
                wc1     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200)
                bdate   LIKE type_file.dat,          #No.FUN-680069 DATE
                edate   LIKE type_file.dat,          #No.FUN-680069 DATE
                s       LIKE type_file.chr4,         #No.FUN-680069 VARCHAR(3) # Order by sequence
                a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
                more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
             END RECORD
DEFINE   g_i           LIKE type_file.num5           #No.FUN-680069 SMALLINT
DEFINE   l_wc          LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(500)
DEFINE   l_i           LIKE type_file.num5           #No.FUN-680069 SMALLINT
DEFINE   g_head1       STRING
DEFINE   g_orderA ARRAY[3] OF LIKE qcs_file.qcs03    #No.FUN-680069 VARCHAR(10)
DEFINE   g_sql         STRING                        #No.FUN-770006
DEFINE   g_str         STRING                        #No.FUN-770006
DEFINE   l_table       STRING                        #No.FUN-770006
DEFINE   l_table1      STRING                        #No.FUN-770006
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
#------------------No.TQC-610082 modify
   LET tm.wc1   = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.a     = ARG_VAL(11)
   LET tm.s     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
#No.FUN-770006 --start--
   LET g_sql="cob01.cob_file.cob01,cob09.cob_file.cob09,cob02.cob_file.cob02,",
             "cob021.cob_file.cob021,cob04.cob_file.cob04,",
             "dat.type_file.dat,gbc05.gbc_file.gbc05,qcs01.qcs_file.qcs01,",
             "cop07.cop_file.cop07,cor15.cor_file.cor15,chr4.type_file.chr4,",
             "cop05.cop_file.cop05,cop01.cop_file.cop01,cop14.cop_file.cop14,",
             "cop16.cop_file.cop16,cop14_1.cop_file.cop14,",
             "cop16_1.cop_file.cop16,cop14_2.cop_file.cop14,",
             "cop16_2.cop_file.cop16,cop21.cop_file.cop21,",
             "cor12.cor_file.cor12,cnl05.cnl_file.cnl05,cnl06.cnl_file.cnl06,",
             "cnl07.cnl_file.cnl07,cnl08.cnl_file.cnl08,cnl09.cnl_file.cnl09,",
             "cnl10.cnl_file.cnl10,cnl11.cnl_file.cnl11,cnl12.cnl_file.cnl12,",
             "cnl13.cnl_file.cnl13,cnl14.cnl_file.cnl14,cnl15.cnl_file.cnl15,",
             "cnl16.cnl_file.cnl16,cob01_1.cob_file.cob01"
 
   LET l_table = cl_prt_temptable('acor206',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql="cob01.cob_file.cob01,cob09.cob_file.cob09,cob02.cob_file.cob02,", 
             "cob021.cob_file.cob021,cob04.cob_file.cob04,",                    
             "dat.type_file.dat,gbc05.gbc_file.gbc05,qcs01.qcs_file.qcs01,",    
             "cop07.cop_file.cop07,cor15.cor_file.cor15,chr4.type_file.chr4,",  
             "cop05.cop_file.cop05,cop01.cop_file.cop01,cop14.cop_file.cop14,", 
             "cop16.cop_file.cop16,cop14_1.cop_file.cop14,",                    
             "cop16_1.cop_file.cop16,cop14_2.cop_file.cop14,",                  
             "cop16_2.cop_file.cop16,cop21.cop_file.cop21,",                    
             "cor12.cor_file.cor12,cnl11.cnl_file.cnl11,cnl12.cnl_file.cnl12,", 
             "cnl13.cnl_file.cnl13,cnl14.cnl_file.cnl14,cnl15.cnl_file.cnl15,", 
             "cnl16.cnl_file.cnl16,cob01_1.cob_file.cob01,num5.type_file.num5"                      
                                                                                
   LET l_table1 = cl_prt_temptable('acor2061',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                     
#No.FUN-770006 --end--
 
   INITIALIZE tm.* TO NULL                       # Default condition
   LET tm.more  = 'N'
   LET tm.a = 'N'
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor207_tm(0,0)
      ELSE CALL acor207()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor207_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
   OPEN WINDOW acor207_w WITH FORM "aco/42f/acor207"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm.a    = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON coe04, cop01, cob01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION help                          #MOD-4C0121
             CALL cl_show_help()                  #MOD-4C0121
 
          ON ACTION controlg                      #MOD-4C0121
             CALL cl_cmdask()                     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
            CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW acor207_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
            
      END IF
 
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
      INPUT BY NAME tm.bdate,tm.edate,tm.a,tm2.s1,tm2.s2,tm2.s3,tm.more
                   WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIElD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
            NEXT FIELD edate
         END IF
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.a
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
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
 
     AFTER INPUT
        LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
     IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW acor207_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
     EXIT PROGRAM
        
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='acor207'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('acor207','9031',1)
        ELSE
           LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc CLIPPED,"'",
                      " '",tm.wc1 CLIPPED,"'",            #No.TQC-610082 add
                      " '",tm.bdate CLIPPED,"'",          #No.TQC-610082 add 
                      " '",tm.edate CLIPPED,"'",          #No.TQC-610082 add 
                      " '",tm.a CLIPPED,"'",              #No.TQC-610082 add
                      " '",tm.s CLIPPED,"'" ,
                      " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                      " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                      " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
           CALL cl_cmdat('acor207',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW acor207_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL acor207()
   END WHILE
     CLOSE WINDOW acor207_w
END FUNCTION
 
FUNCTION acor207()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(2000)
          l_za05    LIKE za_file.za05,
          l_order   ARRAY[5] OF LIKE cnp_file.cnp01, #No.FUN-680069 VARCHAR(20)
          sr        RECORD
                       cob01  LIKE cob_file.cob01,
                       cob09  LIKE cob_file.cob09,
                       cob02  LIKE cob_file.cob02,
                       cob04  LIKE cob_file.cob04
                    END RECORD,
           sr1      RECORD
                       cop10  LIKE cop_file.cop10,         #No.FUN-680069 VARCHAR(1)
                       dt     LIKE cop_file.cop03,         #No.FUN-680069 DATE
                       client LIKE gbc_file.gbc05,         #No.FUN-680069 VARCHAR(80) #FUN-560011
                       inno   LIKE cop_file.cop01,         #No.FUN-680069 VARCHAR(16) #TQC-5B0108 &051112
                       cop07  LIKE cop_file.cop07,         #No.FUN-680069 VARCHAR(20)
                       cor15  LIKE cor_file.cor15,         #No.FUN-680069 VARCHAR(16)
                       cob02  LIKE cob_file.cob02,         #No.FUN-680069 VARCHAR(10)
                       unit   LIKE cob_file.cob04,         #No.FUN-680069 VARCHAR(4)
                       cop05  LIKE cop_file.cop05,         #No.FUN-680069 VARCHAR(10)
                       compan LIKE zo_file.zo02,           #No.FUN-680069 VARCHAR(15)
                       cop14  LIKE cop_file.cop14,         #No.FUN-680069 DEC(13,6)
                       cop16  LIKE cop_file.cop16,         #No.FUN-680069 DEC(13,6)
                       cor12  LIKE cor_file.cor12,         #No.FUN-680069 DEC(13,6)
                       cor14  LIKE cor_file.cor14,         #No.FUN-680069 VARCHAR(1)
                       gno02  LIKE cob_file.cob01          #No.FUN-680069 VARCHAR(15)
                    END RECORD,
           sr2      RECORD
                       order1 LIKE cob_file.cob01,       #No.FUN-680069 VARCHAR(20)
                       order2 LIKE cob_file.cob01,       #No.FUN-680069 VARCHAR(20)
                       order3 LIKE cob_file.cob01        #No.FUN-680069 VARCHAR(20)
                    END RECORD
#No.FUN-770006 --start--
   DEFINE  sr3      RECORD
                       cob01  LIKE cob_file.cob01,                              
                       cob09  LIKE cob_file.cob09,                              
                       cob02  LIKE cob_file.cob02,
                       cob021 LIKE cob_file.cob021,                              
                       cob04  LIKE cob_file.cob04,
                       dat    LIKE type_file.dat,                                            
                       gbc05  LIKE gbc_file.gbc05,                                        
                       qcs01  LIKE qcs_file.qcs01,                                        
                       cop07  LIKE cop_file.cop07,                                           
                       cor15  LIKE cor_file.cor15,                                           
                       chr4   LIKE type_file.chr4,                                           
                       cop05  LIKE cop_file.cop05,  
                       cop01  LIKE cop_file.cop01,                                         
                       cop14  LIKE cop_file.cop14,                                           
                       cop16  LIKE cop_file.cop16,
                       cop141 LIKE cop_file.cop14,                              
                       cop161 LIKE cop_file.cop16,
                       cop142 LIKE cop_file.cop14,                              
                       cop162 LIKE cop_file.cop16,   
                       cop21  LIKE cop_file.cop21,                                        
                       cor12  LIKE cor_file.cor12,
                       cnl05  LIKE cnl_file.cnl05,
                       cnl06  LIKE cnl_file.cnl06, 
                       cnl07  LIKE cnl_file.cnl07, 
                       cnl08  LIKE cnl_file.cnl08, 
                       cnl09  LIKE cnl_file.cnl09, 
                       cnl10  LIKE cnl_file.cnl10,
                       cnl11  LIKE cnl_file.cnl11,
                       cnl12  LIKE cnl_file.cnl12,
                       cnl13  LIKE cnl_file.cnl13,
                       cnl14  LIKE cnl_file.cnl14,
                       cnl15  LIKE cnl_file.cnl15,
                       cnl16  LIKE cnl_file.cnl16,
                       cob011 LIKE cob_file.cob01      
                    END RECORD                                      
   DEFINE l_sum1       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum2       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum3       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum4       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum5       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum6       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum101     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum102     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum201     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum202     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum301     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum302     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum501     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum502     LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou1       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou2       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou3       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou4       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou5       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou6       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou7       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou8       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cou9       LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_cnb20      LIKE cnb_file.cnb20,        # VARCHAR(1)       
          l_yy         LIKE type_file.num5,        # SMALLINT      
          l_mm         LIKE type_file.num5,        # SMALLINT      
          l_py         LIKE type_file.num5,        # SMALLINT      
          l_pm         LIKE type_file.num5,        # SMALLINT      
          l_bdate      LIKE type_file.dat,         # DATE          
          l_edate      LIKE type_file.dat,         # DATE          
          l_cob021     LIKE cob_file.cob021,                                    
          l_cob01_t    LIKE cob_file.cob01,                                     
          l_cob01_t2   LIKE cob_file.cob01,                                     
          l_cob09_t    LIKE cob_file.cob09,                                     
          l_coe04_t    LIKE coe_file.coe04,
          l_sum01      LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum02      LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum03      LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum04      LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum05      LIKE cnl_file.cnl11,        # DEC(13,2)     
          l_sum06      LIKE cnl_file.cnl11,
          l_cop16      LIKE cop_file.cop16,
          l_cob01      LIKE cob_file.cob01,
          l_cnt        LIKE type_file.num5 
#No.FUN-770006 --end--
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",              
                 " ?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                  
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('inser_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
        EXIT PROGRAM                          
     END IF 
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                       
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",              
                 " ?,?,?,?,?,?,?,?,?)"                                            
     PREPARE insert_prep1 FROM g_sql                                              
     IF STATUS THEN                                                               
        CALL cl_err('inser_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
        EXIT PROGRAM                         
     END IF 
 
     CALL cl_del_data(l_table)                     #No.FUN-770006
     CALL cl_del_data(l_table1)                    #No.FUN-770006
     LET l_cob01 = ' '                             #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc = tm.wc clipped," AND cobuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc = tm.wc clipped," AND cobgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND cobgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cobuser', 'cobgrup')
     #End:FUN-980030
 
     LET l_wc = tm.wc
 
#TQC-930034  ----start
    #FOR l_i = 1 TO 296
    #   IF l_wc[l_i,l_i+4] = 'cop01' THEN LET l_wc[l_i,l_i+4] = 'cor01' END IF 
    #END FOR
    LET l_wc=cl_replace_str(l_wc,"cop01","cor01")
#TQC-930034  ----end 
 
        LET l_sql = "SELECT DISTINCT cob01,cob09,cob02,cob04 ",
                    "  FROM cob_file,coe_file,cop_file ",
                    " WHERE cob01 = coe03 AND coe03 = cop11 ",
                    "   AND cobacti = 'Y' ",
                    "   AND copacti = 'Y' AND copconf = 'Y' ",
                    "   AND cop03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                    "   AND ",tm.wc CLIPPED,
                    " UNION ",
                    "SElECT DISTINCT cob01,cob09,cob02,cob04 ",
                    "  FROM cob_file,coe_file,cor_file ",
                    " WHERE cob01 = coe03 AND coe03 = cor05 ",
                    "   AND cobacti = 'Y' ",
                    "   AND coracti = 'Y' ",
                    "   AND cor03 BETWEEN '",tm.bdate,"'  AND '",tm.edate,"'",
                    "   AND ",l_wc CLIPPED
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE acor207_pre1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor207_cs1 CURSOR FOR acor207_pre1
 
     LET l_sql = "SELECT cop10,cop03,smydesc,cop01,cop07,'',",
                 "       cob02, ",
                 "       cop15,cop05,cop06,cop14,cop16,0,'',cop11 ",
                 " FROM  cob_file,cop_file LEFT OUTER JOIN smy_file ON cop01 like ltrim(rtrim(smy_file.smyslip))||'-%' ",
#No.FUN-550036--begin
#                "WHERE  smy_file.smyslip=substr(cop01,1,3)  ",
               " WHERE 1 = 1  ",
#No.FUN-550036--end
                 "  AND  cop11 = ?  ",
                 "  AND  cobacti = 'Y' ",
                 "  AND  cop11 = cob01  ",
                 "  AND  copacti = 'Y' AND copconf = 'Y' ",
                 "  AND  cop03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
     PREPARE r207_pre2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r207_cs2 CURSOR FOR r207_pre2
 
     LET l_sql = "SELECT '',cor03,smydesc,cor01,'',cor15, ",
                 "       cob02,cor10, ",
                 "       cor08,0,0,cor12,cor14,cor05 ",
                 "  FROM cob_file,cor_file LEFT OUTER JOIN smy_file ON cor01 like ltrim(rtrim(smy_file.smyslip))||'-%' ",
#No.FUN-550036--begin
#                " WHERE smy_file.smyslip=substr(cor01,1,3)   ",
               " WHERE 1 = 1 ",
#No.FUN-550036--end
                 "   AND cor05 = ?  ",
                 "   AND cor05 = cob01  ",
                 "   AND coracti = 'Y' ",
                 "   AND cobacti = 'Y' ",
                 "   AND cor03 BETWEEN '",tm.bdate,"'  AND '",tm.edate,"'"
     PREPARE r207_pre3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r207_cs3 CURSOR FOR r207_pre3
 
#    CALL cl_outnam('acor207') RETURNING l_name        #No.FUN-770006
 
     DROP TABLE r207_temp
#No.FUN-680069-begin
     CREATE TEMP TABLE r207_temp(
          cop10  LIKE cop_file.cop10,
          dt     LIKE type_file.dat,   
          client LIKE type_file.chr1000,
          inno   LIKE type_file.chr1000,
          cop07  LIKE cop_file.cop07,
          cor15  LIKE cor_file.cor15,
          cob02  LIKE cob_file.cob02,
          unit   LIKE cop_file.cop17,
          cop05  LIKE cop_file.cop05,
          compan LIKE cop_file.cop09,
          cop14  LIKE cop_file.cop14,
          cop16  LIKE cop_file.cop16,
          cor12  LIKE cor_file.cor12,
          cor14  LIKE cor_file.cor14,
          gno02  LIKE cop_file.cop09)
#No.FUN-680069-end
#    START REPORT acor207_rep TO l_name                 #No.FUN-770006
#    LET g_pageno = 0                                   #No.FUN-770006
     DELETE FROM r207_temp
     FOREACH acor207_cs1 INTO sr.*
        IF SQLCA.sqlcode  THEN
           CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        END IF
#No.FUN-770006 --start--
        LET l_cob01_t = 'NULL'
        LET l_cob09_t = 'NULL'
        LET l_coe04_t = 'NULL'
        LET l_sum1 = 0
        LET l_sum2 = 0
        LET l_sum3 = 0
        LET l_sum4 = 0
        LET l_sum5 = 0
        LET l_sum6 = 0
        LET l_sum01 = 0
        LET l_sum02 = 0
        LET l_sum03 = 0
        LET l_sum04 = 0
        LET l_sum05 = 0
        LET l_sum06 = 0
#No.FUN-770006 --end--
        FOREACH r207_cs2 USING sr.cob01 INTO sr1.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
           INSERT INTO r207_temp VALUES(sr1.*)
        END FOREACH
        FOREACH r207_cs3 USING sr.cob01 INTO sr1.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
           INSERT INTO r207_temp VALUES(sr1.*)
        END FOREACH
        LET l_sql = " SELECT * FROM r207_temp "
        PREPARE r207_pre4 FROM l_sql
        DECLARE r207_cs4 CURSOR FOR r207_pre4
        FOREACH r207_cs4 INTO sr1.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
#No.FUN-770006 --mark--
#           FOR g_i = 1 TO 3
#              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr1.dt
#                                            LET g_orderA[g_i] = g_x[25]
#                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr1.inno
#                                            LET g_orderA[g_i] = g_x[26]
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr1.compan
#                                            LET g_orderA[g_i] = g_x[27]
#                   OTHERWISE LET l_order[g_i] = '-'
#                             LET g_orderA[g_i] = ' '          #清為空白
#              END CASE
#           END FOR
#           LET sr2.order1 = l_order[1]
#           LET sr2.order2 = l_order[2]
#           LET sr2.order3 = l_order[3]
#          OUTPUT TO REPORT acor207_rep(sr.*,sr1.*,sr2.*)     #No.FUN-770006
#No.FUN-770006 --start--
           SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=sr.cob01
           IF (sr.cob01 = sr1.gno02)  THEN                                              
             IF (sr.cob01 <> l_cob01_t OR sr.cob09 <> l_cob09_t ) THEN                 
              #計算當前年度期別                                                      
              CALL s_yp(tm.bdate) RETURNING l_yy,l_mm                                
              CALL s_lsperiod(YEAR(tm.bdate),MONTH(tm.bdate)) RETURNING l_py,l_pm    
              CALL s_azn01(l_yy,l_mm) RETURNING l_bdate,l_edate                      
              #當前年度期別前一期進口、耗用、退貨數量累計                            
              SELECT SUM(cnl05-cnl07),SUM(cnl08-cnl10),                              
                     SUM(cnl11-cnl12)  INTO l_sum1,l_sum2,l_sum3                     
                     FROM cnl_file                                                        
              WHERE cnl02 = sr.cob01 AND cnl03 = l_py AND cnl04 = l_pm              
              IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF                          
              IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF                          
              IF cl_null(l_sum3) THEN LET l_sum3 = 0 END IF                          
              #計算當前年度期別起始日期至日期區間之起始日直接進口異動數量(合同)累計  
              SELECT SUM(cop16)  INTO l_sum101                                       
                     FROM cop_file                                                        
              WHERE cop11 = sr.cob01                                                
                AND cop10='1'                                                       
                AND cop03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum101) THEN LET l_sum101 = 0 END IF
              #計算當前年度期別起始日期至日期區間之起始日國外退貨異動數量(合同)累計  
              SELECT SUM(cop16)  INTO l_sum102                                       
                     FROM cop_file                                                        
              WHERE cop11 = sr.cob01                                                
                AND cop10='4'                                                       
                AND cop03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum102) THEN LET l_sum102 = 0 END IF                      
              #直接進口合同累計                                                      
              LET l_sum1 = l_sum1+l_sum101-l_sum102                                  
              #計算當前年度期別起始日期至日期區間之起始日轉廠進口異動數量(合同)累計  
              SELECT SUM(cop16)  INTO l_sum201                                       
                     FROM cop_file                                                        
              WHERE cop11 = sr.cob01                                                
                AND cop10='2'                                                       
                AND cop03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum201) THEN LET l_sum201 = 0 END IF                      
              SELECT SUM(cop16)  INTO l_sum202                                       
              #計算當前年度期別起始日期至日期區間之起始日轉廠退貨異動數量(合同)累計  
                     FROM cop_file                                                        
              WHERE cop11 = sr.cob01                                                
                AND cop10='5'
                AND cop03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum202) THEN LET l_sum202 = 0 END IF                      
              #轉廠進口合同累計                                                      
              LET l_sum2 = l_sum2+l_sum201-l_sum202                                  
              #計算當前年度期別起始日期至日期區間之起始日國內采購異動數量(合同)累計  
              SELECT SUM(cop16)  INTO l_sum301                                       
                     FROM cop_file                                                        
              WHERE cop11 = sr.cob01                                                
                AND cop10='3'                                                       
                AND cop03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum301) THEN LET l_sum301 = 0 END IF                      
              #計算當前年度期別起始日期至日期區間之起始日內購退貨異動數量(合同)累計  
              SELECT SUM(cop16)  INTO l_sum302                                       
                     FROM cop_file                                                        
              WHERE cop11 = sr.cob01                                                
                AND cop10='6'                                                       
                AND cop03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum302) THEN LET l_sum302 = 0 END IF                      
              #內購合同累計                                                          
              LET l_sum3 = l_sum3 + l_sum301 - l_sum302
              # 入庫累計                                                             
              LET l_sum4 = l_sum1 + l_sum2   + l_sum3                                
              #計算當前年度期別起始日期至日期區間之起始日材料入庫合同數量累計        
              SELECT SUM(cor12)  INTO l_sum501                                       
                     FROM cor_file                                                        
              WHERE cor05 = sr.cob01                                                
                AND cor00='2' AND cor14 <> '2'                                      
                AND cor03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum501) THEN LET l_sum501 = 0 END IF                      
              #計算當前年度期別起始日期至日期區間之起始日成品入庫合同數量累計        
              SELECT SUM(cor12)  INTO l_sum502                                       
                     FROM cor_file                                                        
              WHERE cor05 = sr.cob01                                                
                AND cor00='2' AND cor14 = '2'                                       
                AND cor03 BETWEEN l_bdate AND tm.bdate                              
              IF cl_null(l_sum502) THEN LET l_sum502 = 0 END IF                      
              # 出庫累計                                                             
              LET l_sum5 = l_sum501-l_sum502                                         
              # 合同結余
              LET l_sum6 = l_sum4-l_sum5 
              LET l_sum01 = l_sum1
              LET l_sum02 = l_sum2
              LET l_sum03 = l_sum3
              LET l_sum04 = l_sum4
              LET l_sum05 = l_sum5
              LET l_sum06 = l_sum6
              LET l_cob01_t = sr.cob01
              LET l_cob09_t = sr.cob09
             END IF
             CASE
               WHEN (sr1.cop10 = '1' OR sr1.cop10 = '4')
                  IF (sr1.cop10 = '4') THEN 
                      LET sr1.cop14 = -sr1.cop14
                      LET sr1.cop16 = -sr1.cop16
                  END IF
                  LET l_sum1 = l_sum1 + sr1.cop16                                     
                  LET l_sum4 = l_sum1 + l_sum2   + l_sum3                             
                  LET l_sum6 = l_sum4-l_sum5
                  LET l_cop16= sr1.cop16
                  EXECUTE insert_prep USING sr.cob01,sr.cob09,sr.cob02,
                                            l_cob021,sr.cob04,sr1.dt,
                                            sr1.client,sr1.inno,sr1.cop07,
                                            sr1.cor15,sr1.unit,sr1.cop05,
                                            sr1.compan,sr1.cop14,sr1.cop16,
                                            '','','','',l_cop16,'',
                                            l_sum1,l_sum2,l_sum3,l_sum4,
                                            l_sum5,l_sum6,l_sum01,l_sum02,
                                            l_sum03,l_sum04,l_sum05,l_sum06,
                                            l_cob01
                  LET l_cob01 = sr.cob01
               WHEN (sr1.cop10 = '2' OR sr1.cop10 = '5')                              
                  IF (sr1.cop10 = '5') THEN                                           
                      LET sr1.cop14 = -sr1.cop14                                       
                      LET sr1.cop16 = -sr1.cop16                                       
                  END IF                                                              
                  LET l_sum2 = l_sum2 + sr1.cop16                                     
                  LET l_sum4 = l_sum1 + l_sum2   + l_sum3                             
                  LET l_sum6 = l_sum4-l_sum5
                  LET l_cop16= sr1.cop16                                        
                  EXECUTE insert_prep USING sr.cob01,sr.cob09,sr.cob02,         
                                            l_cob021,sr.cob04,sr1.dt,             
                                            sr1.client,sr1.inno,sr1.cop07,      
                                            sr1.cor15,sr1.unit,sr1.cop05,       
                                            sr1.compan,'','',sr1.cop14,
                                            sr1.cop16,'','',l_cop16,'',
                                            l_sum1,l_sum2,l_sum3,l_sum4,        
                                            l_sum5,l_sum6,l_sum01,l_sum02,      
                                            l_sum03,l_sum04,l_sum05,l_sum06,
                                            l_cob01
                  LET l_cob01 = sr.cob01
               WHEN (sr1.cop10 = '3' OR sr1.cop10 = '6')                              
                  IF (sr1.cop10 = '6') THEN                                            
                      LET sr1.cop14 = -sr1.cop14                                        
                      LET sr1.cop16 = -sr1.cop16                                        
                  END IF                                                               
                  LET l_sum3 = l_sum3 + sr1.cop16                                      
                  LET l_sum4 = l_sum1 + l_sum2   + l_sum3                              
                  LET l_sum6 = l_sum4-l_sum5
                  LET l_cop16= sr1.cop16                                        
                  EXECUTE insert_prep USING sr.cob01,sr.cob09,sr.cob02,         
                                            l_cob021,sr.cob04,sr1.dt,             
                                            sr1.client,sr1.inno,sr1.cop07,      
                                            sr1.cor15,sr1.unit,sr1.cop05,       
                                            sr1.compan,'','','','',
                                            sr1.cop14,sr1.cop16,l_cop16,'',
                                            l_sum1,l_sum2,l_sum3,l_sum4,        
                                            l_sum5,l_sum6,l_sum01,l_sum02,      
                                            l_sum03,l_sum04,l_sum05,l_sum06,
                                            l_cob01
                  LET l_cob01 = sr.cob01
               OTHERWISE                                                               
                  IF (sr1.cor14 = '2')  THEN                                           
                      LET sr1.cor12 = -sr1.cor12                                       
                  END IF                                                               
                  LET l_sum5 = l_sum5 + sr1.cor12                                      
                  LET l_sum6 = l_sum4-l_sum5     
                  EXECUTE insert_prep USING sr.cob01,sr.cob09,sr.cob02,         
                                            l_cob021,sr.cob04,sr1.dt,             
                                            sr1.client,sr1.inno,sr1.cop07,      
                                            sr1.cor15,sr1.unit,sr1.cop05,       
                                            sr1.compan,'','','','','','',
                                            '',sr1.cor12,l_sum1,l_sum2,
                                            l_sum3,l_sum4,l_sum5,l_sum6,
                                            l_sum01,l_sum02,l_sum03,l_sum04,
                                            l_sum05,l_sum06,l_cob01
                  LET l_cob01 = sr.cob01
             END CASE
          END IF
#No.FUN-770006 --end--
        END FOREACH
     END FOREACH
 
#   FINISH REPORT acor207_rep                      #No.FUN-770006
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-770006
#No.FUN-770006 --start--
           FOR g_i = 1 TO 3                                                     
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = "dat"              
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = "qcs01"            
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = "cop01"            
                   OTHERWISE LET l_order[g_i] = '-'                             
                             LET g_orderA[g_i] = ' '                            
              END CASE                                                          
           END FOR                                                              
           LET sr2.order1 = l_order[1]                                          
           LET sr2.order2 = l_order[2]                                          
           LET sr2.order3 = l_order[3]   
    LET l_cnt = 0
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED,         
                " ORDER By cob01,",sr2.order1,",",sr2.order2,",",sr2.order3
    PREPARE r207_precr FROM l_sql
    IF STATUS THEN CALL cl_err('precr:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE r207_cr CURSOR FOR r207_precr
    FOREACH r207_cr  INTO sr3.*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET l_cnt = l_cnt+1
       EXECUTE insert_prep1 USING sr3.cob01,sr3.cob09,sr3.cob02,sr3.cob021,
                                  sr3.cob04,sr3.dat,sr3.gbc05,sr3.qcs01,
                                  sr3.cop07,sr3.cor15,sr3.chr4,sr3.cop05,
                                  sr3.cop01,sr3.cop14,sr3.cop16,sr3.cop141,
                                  sr3.cop161,sr3.cop142,sr3.cop162,sr3.cop21,
                                  sr3.cor12,sr3.cnl11,sr3.cnl12,sr3.cnl13,
                                  sr3.cnl14,sr3.cnl15,sr3.cnl16,sr3.cob011,
                                  l_cnt
    END FOREACH
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
       CALL cl_wcchp(tm.wc,'coe04, cop01, cob01')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = tm.bdate,";",tm.edate,";",tm.a,";",tm.s[1,1],";",
                tm.s[2,2],";",tm.s[3,3],";",g_str
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED
    CALL cl_prt_cs3('acor207','acor207',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT acor207_rep(sr,sr1,sr2)
   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680069 VARCHAR(1)
          l_sum1       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum2       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum3       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum4       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum5       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum6       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum101     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum102     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum201     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum202     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum301     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum302     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum501     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_sum502     LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou1       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou2       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou3       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou4       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou5       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou6       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou7       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou8       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cou9       LIKE cnl_file.cnl11,        #No.FUN-680069 DEC(13,2)
          l_cnb20      LIKE cnb_file.cnb20,        #No.FUN-680069 VARCHAR(1)
          l_xx         LIKE cob_file.cob04,        #No.FUN-680069 VARCHAR(4)
          l_title      LIKE cob_file.cob08,        #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,         #No.FUN-680069 DATE
          l_edate      LIKE type_file.dat,         #No.FUN-680069 DATE
          l_cob021     LIKE cob_file.cob021,
          l_cob01_t    LIKE cob_file.cob01,
          l_cob01_t2   LIKE cob_file.cob01,
          l_cob09_t    LIKE cob_file.cob09,
          l_coe04_t    LIKE coe_file.coe04,
          sr        RECORD
                       cob01  LIKE cob_file.cob01,
                       cob09  LIKE cob_file.cob09,
                       cob02  LIKE cob_file.cob02,
                       cob04  LIKE cob_file.cob04
                    END RECORD,
          sr1       RECORD
               cop10  LIKE cop_file.cop10,         #No.FUN-680069 VARCHAR(1)
               dt     LIKE type_file.dat,          #No.FUN-680069 DATE
               client LIKE gbc_file.gbc05,         #No.FUN-680069 VARCHAR(80)       #FUN-560011
               inno   LIKE cop_file.cop01,         #No.FUN-680069 VARCHAR(16) #TQC-5B0108 &051112
               cop07  LIKE cop_file.cop07,
               cor15  LIKE cor_file.cor15,         #No.FUN-550036
               cob02  LIKE cob_file.cob02,
               unit   LIKE cob_file.cob04,         #No.FUN-680069 VARCHAR(4)
               cop05  LIKE cop_file.cop05,
               compan LIKE cop_file.cop01,         #No.FUN-680069 VARCHAR(15)
               cop14  LIKE cop_file.cop14,
               cop16  LIKE cop_file.cop16,
               cor12  LIKE cor_file.cor12,
               cor14  LIKE cor_file.cor14,
               gno02  LIKE cob_file.cob01          #No.FUN-680069 VARCHAR(15)
                    END RECORD,
          sr2       RECORD
               order1 LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(20)
               order2 LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(20)
               order3 LIKE cob_file.cob01          #No.FUN-680069 VARCHAR(20)
                     END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.cob01,sr2.order1,sr2.order2,sr2.order3
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN (((g_len-FGL_WIDTH(g_x[1])))/2)+1 ,g_x[1]
      LET g_head1 = g_x[24] CLIPPED, g_orderA[1] CLIPPED, '-',
                    g_orderA[2] CLIPPED, '-', g_orderA[3]
      PRINT g_head1
 
      SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=sr.cob01
      IF (tm.a = 'N') THEN
          PRINT COLUMN 1,g_x[9] CLIPPED,sr.cob01,' ';
      ELSE
          PRINT COLUMN 1,g_x[9] CLIPPED,sr.cob09,' ';
      END IF
      PRINT g_x[10] CLIPPED,sr.cob02
      PRINT g_x[28] CLIPPED,l_cob021,
            COLUMN 146,tm.bdate,'-',tm.edate,
            COLUMN (g_len-(length(g_x[12])+FGL_WIDTH(sr.cob04))-4),g_x[12] CLIPPED,sr.cob04
      PRINT g_dash[1,g_len]
 
      PRINT COLUMN r207_getStartPos(31,38,g_x[13]),g_x[13],
            COLUMN r207_getStartPos(39,49,g_x[14]),g_x[14]
      PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+g_w[32]+g_w[33]+g_w[34]+g_w[35]
                                   +g_w[36]+g_w[37]+g_w[38]+7],
            COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]
                                   +g_w[44]+g_w[45]+g_w[46]+g_w[47]+g_w[48]
                                   +g_w[49]+10]
      PRINT COLUMN g_c[31],g_x[15],
            COLUMN r207_getStartPos(32,38,g_x[16]),g_x[16],
            COLUMN r207_getStartPos(39,41,g_x[17]),g_x[17],
            COLUMN r207_getStartPos(42,44,g_x[18]),g_x[18],
            COLUMN r207_getStartPos(45,47,g_x[19]),g_x[19],
            COLUMN r207_getStartPos(48,49,g_x[20]),g_x[20],
            COLUMN r207_getStartPos(50,51,g_x[21]),g_x[21],
            COLUMN g_c[52],g_x[22]
      PRINT COLUMN g_c[31],g_dash2[1,g_w[31]],
            COLUMN g_c[32],g_dash2[1,g_w[32]+g_w[33]+g_w[34]+g_w[35]
                                   +g_w[36]+g_w[37]+g_w[38]+6],
            COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+2],
            COLUMN g_c[42],g_dash2[1,g_w[42]+g_w[43]+g_w[44]+2],
            COLUMN g_c[45],g_dash2[1,g_w[45]+g_w[46]+g_w[47]+2],
            COLUMN g_c[48],g_dash2[1,g_w[48]+g_w[49]+1],
            COLUMN g_c[50],g_dash2[1,g_w[50]+g_w[51]+1],
            COLUMN g_c[52],g_dash2[1,g_w[52]]
 
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52]
      PRINT g_dash1
 
   LET l_last_sw='n'
   LET l_cob01_t = 'NULL'
   LET l_cob09_t = 'NULL'
   LET l_coe04_t = 'NULL'
 
   BEFORE GROUP OF sr.cob01
         LET l_xx = l_xx - 1
         LET l_sum1 = 0
         LET l_sum2 = 0
         LET l_sum3 = 0
         LET l_sum4 = 0
         LET l_sum5 = 0
         LET l_sum6 = 0
         SKIP TO TOP OF PAGE
 
   ON EVERY ROW
   IF (sr.cob01 = sr1.gno02)  THEN
      IF (sr.cob01 <> l_cob01_t OR sr.cob09 <> l_cob09_t ) THEN
         #計算當前年度期別
         CALL s_yp(tm.bdate) RETURNING l_yy,l_mm
         CALL s_lsperiod(YEAR(tm.bdate),MONTH(tm.bdate)) RETURNING l_py,l_pm
         CALL s_azn01(l_yy,l_mm) RETURNING l_bdate,l_edate
         #當前年度期別前一期進口、耗用、退貨數量累計
         SELECT SUM(cnl05-cnl07),SUM(cnl08-cnl10),
                SUM(cnl11-cnl12)  INTO l_sum1,l_sum2,l_sum3
           FROM cnl_file
          WHERE cnl02 = sr.cob01 AND cnl03 = l_py AND cnl04 = l_pm
         IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
         IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
         IF cl_null(l_sum3) THEN LET l_sum3 = 0 END IF
         #計算當前年度期別起始日期至日期區間之起始日直接進口異動數量(合同)累計
         SELECT SUM(cop16)  INTO l_sum101
           FROM cop_file
          WHERE cop11 = sr.cob01
            AND cop10='1'
            AND cop03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum101) THEN LET l_sum101 = 0 END IF
         #計算當前年度期別起始日期至日期區間之起始日國外退貨異動數量(合同)累計
         SELECT SUM(cop16)  INTO l_sum102
           FROM cop_file
          WHERE cop11 = sr.cob01
            AND cop10='4'
            AND cop03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum102) THEN LET l_sum102 = 0 END IF
         #直接進口合同累計
         LET l_sum1 = l_sum1+l_sum101-l_sum102
         #計算當前年度期別起始日期至日期區間之起始日轉廠進口異動數量(合同)累計
         SELECT SUM(cop16)  INTO l_sum201
           FROM cop_file
          WHERE cop11 = sr.cob01
            AND cop10='2'
            AND cop03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum201) THEN LET l_sum201 = 0 END IF
         SELECT SUM(cop16)  INTO l_sum202
         #計算當前年度期別起始日期至日期區間之起始日轉廠退貨異動數量(合同)累計
           FROM cop_file
          WHERE cop11 = sr.cob01
            AND cop10='5'
            AND cop03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum202) THEN LET l_sum202 = 0 END IF
         #轉廠進口合同累計
         LET l_sum2 = l_sum2+l_sum201-l_sum202
         #計算當前年度期別起始日期至日期區間之起始日國內采購異動數量(合同)累計
         SELECT SUM(cop16)  INTO l_sum301
           FROM cop_file
          WHERE cop11 = sr.cob01
            AND cop10='3'
            AND cop03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum301) THEN LET l_sum301 = 0 END IF
         #計算當前年度期別起始日期至日期區間之起始日內購退貨異動數量(合同)累計
         SELECT SUM(cop16)  INTO l_sum302
           FROM cop_file
          WHERE cop11 = sr.cob01
            AND cop10='6'
            AND cop03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum302) THEN LET l_sum302 = 0 END IF
         #內購合同累計
         LET l_sum3 = l_sum3 + l_sum301 - l_sum302
         # 入庫累計
         LET l_sum4 = l_sum1 + l_sum2   + l_sum3
         #計算當前年度期別起始日期至日期區間之起始日材料入庫合同數量累計
         SELECT SUM(cor12)  INTO l_sum501
           FROM cor_file
          WHERE cor05 = sr.cob01
            AND cor00='2' AND cor14 <> '2'
            AND cor03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum501) THEN LET l_sum501 = 0 END IF
         #計算當前年度期別起始日期至日期區間之起始日成品入庫合同數量累計
         SELECT SUM(cor12)  INTO l_sum502
           FROM cor_file
          WHERE cor05 = sr.cob01
            AND cor00='2' AND cor14 = '2'
            AND cor03 BETWEEN l_bdate AND tm.bdate
         IF cl_null(l_sum502) THEN LET l_sum502 = 0 END IF
         # 出庫累計
         LET l_sum5 = l_sum501-l_sum502
         # 合同結余
         LET l_sum6 = l_sum4-l_sum5
         PRINTX name=S1 COLUMN g_c[31],g_x[23] CLIPPED,
               COLUMN g_c[41],l_sum1 USING '-----------&.&&',
               COLUMN g_c[44],l_sum2 USING '-----------&.&&',
               COLUMN g_c[47],l_sum3 USING '-----------&.&&',
               COLUMN g_c[49],l_sum4 USING '-----------&.&&',
               COLUMN g_c[51],l_sum5
            PRINT  COLUMN g_c[31],sr1.dt,
                   COLUMN g_c[32],sr1.client,
                   COLUMN g_c[33],sr1.inno  ,
                   COLUMN g_c[34],sr1.cop07 ,
                   COLUMN g_c[35],sr1.cor15 ,
                   COLUMN g_c[36],sr1.unit,
                   COLUMN g_c[37],sr1.cop05,
                   COLUMN g_c[38],sr1.compan,
                   COLUMN g_c[39],sr1.cop14  USING '-----------&.&&',
                   COLUMN g_c[40],sr1.cop16  USING '-----------&.&&',
                   COLUMN g_c[41],l_sum1    USING '-----------&.&&',
                   COLUMN g_c[44],l_sum2    USING '-----------&.&&',
                   COLUMN g_c[47],l_sum3    USING '-----------&.&&',
                   COLUMN g_c[48],sr1.cop16 USING '-----------&.&&',
                   COLUMN g_c[49],l_sum4    USING '-----------&.&&',
                   COLUMN g_c[51],l_sum5    USING '-----------&.&&',
                   COLUMN g_c[52],l_sum6    USING '-----------&.&&'
         WHEN (sr1.cop10 = '2' OR sr1.cop10 = '5')
            IF (sr1.cop10 = '5') THEN
               LET sr1.cop14 = -sr1.cop14
               LET sr1.cop16 = -sr1.cop16
            END IF
            LET l_sum2 = l_sum2 + sr1.cop16
            LET l_sum4 = l_sum1 + l_sum2   + l_sum3
            LET l_sum6 = l_sum4-l_sum5
            PRINT  COLUMN g_c[31],sr1.dt,
                   COLUMN g_c[32],sr1.client,
                   COLUMN g_c[33],sr1.inno  ,
                   COLUMN g_c[34],sr1.cop07 ,
                   COLUMN g_c[35],sr1.cor15 ,
                   COLUMN g_c[36],sr1.unit  ,
                   COLUMN g_c[37],sr1.cop05 ,
                   COLUMN g_c[38],sr1.compan,
                   COLUMN g_c[41],l_sum1    USING '-----------&.&&',
                   COLUMN g_c[42],sr1.cop14 USING '-----------&.&&',
                   COLUMN g_c[43],sr1.cop16 USING '-----------&.&&',
                   COLUMN g_c[44],l_sum2    USING '-----------&.&&',
                   COLUMN g_c[47],l_sum3    USING '-----------&.&&',
                   COLUMN g_c[48],sr1.cop16 USING '-----------&.&&',
                   COLUMN g_c[49],l_sum4    USING '-----------&.&&',
                   COLUMN g_c[51],l_sum5    USING '-----------&.&&',
                   COLUMN g_c[52],l_sum6    USING '-----------&.&&'
         WHEN (sr1.cop10 = '3' OR sr1.cop10 = '6')
           IF (sr1.cop10 = '4') THEN
              LET sr1.cop14 = -sr1.cop14
              LET sr1.cop16 = -sr1.cop16
           END IF
           LET l_sum3 = l_sum3 + sr1.cop16
           LET l_sum4 = l_sum1 + l_sum2   + l_sum3
           LET l_sum6 = l_sum4-l_sum5
           PRINT  COLUMN g_c[31],sr1.dt,
                  COLUMN g_c[32],sr1.client,
                  COLUMN g_c[33],sr1.inno  ,
                  COLUMN g_c[34],sr1.cop07 ,
                  COLUMN g_c[35],sr1.cor15 ,
                  COLUMN g_c[36],sr1.unit  ,
                  COLUMN g_c[37],sr1.cop05 ,
                  COLUMN g_c[38],sr1.compan,
                  COLUMN g_c[41],l_sum1    USING '-----------&.&&',
                  COLUMN g_c[44],l_sum2    USING '-----------&.&&',
                  COLUMN g_c[45],sr1.cop14 USING '-----------&.&&',
                  COLUMN g_c[46],sr1.cop16 USING '-----------&.&&',
                  COLUMN g_c[47],l_sum3    USING '-----------&.&&',
                  COLUMN g_c[48],sr1.cop16 USING '-----------&.&&',
                  COLUMN g_c[49],l_sum4    USING '-----------&.&&',
                  COLUMN g_c[51],l_sum5    USING '-----------&.&&',
                  COLUMN g_c[52],l_sum6    USING '-----------&.&&'
        # 計算出庫明細各欄位數據
        OTHERWISE
           IF (sr1.cor14 = '2')  THEN
               LET sr1.cor12 = -sr1.cor12
           END IF
           LET l_sum5 = l_sum5 + sr1.cor12
           LET l_sum6 = l_sum4-l_sum5
           PRINT  COLUMN g_c[31],sr1.dt,
                  COLUMN g_c[32],sr1.client,
                  COLUMN g_c[33],sr1.inno  ,
                  COLUMN g_c[34],sr1.cop07 ,
                  COLUMN g_c[35],sr1.cor15 ,
                  COLUMN g_c[36],sr1.unit  ,
                  COLUMN g_c[37],sr1.cop05 ,
                  COLUMN g_c[38],sr1.compan,
                  COLUMN g_c[41],l_sum1    USING '-----------&.&&',
                  COLUMN g_c[44],l_sum2    USING '-----------&.&&',
                  COLUMN g_c[47],l_sum3    USING '-----------&.&&',
                  COLUMN g_c[49],l_sum4    USING '-----------&.&&',
                  COLUMN g_c[50],sr1.cor12 USING '-----------&.&&',
                  COLUMN g_c[51],l_sum5    USING '-----------&.&&',
                  COLUMN g_c[52],l_sum6    USING '-----------&.&&'
     END CASE
  END IF
  AFTER GROUP OF sr.cob01
     LET l_xx = '1'
     LET sr1.dt = sr1.dt
  ON LAST ROW
     LET l_last_sw = 'Y'
     PRINT   g_dash[1,g_len] CLIPPED
     PRINT   g_x[4] CLIPPED,
      COLUMN (g_len-9), g_x[7] CLIPPED
  PAGE TRAILER
     LET l_xx = 'n'
     IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
FUNCTION r207_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_str       STRING       #No.FUN-680069
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION}
#No.FUN-770006 --end--
