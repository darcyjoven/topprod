# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar510.4gl
# Desc/riptions..: 保險單標的物明細表
# Date & Author..: 97/08/29 By Sophia
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-560060 05/06/15 By day   單據編號修改
# Modify.........: No.FUN-590110 05/10/08 By jackie 報表轉XML
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-770052 07/08/01 By xiaofeizhu 制作水晶報表 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
		wc    STRING,  		# Where condition
   		s     LIKE type_file.chr3,  		# Order by sequence       #No.FUN-680070 VARCHAR(3)
   		t     LIKE type_file.chr3,                  # Eject sw       #No.FUN-680070 VARCHAR(3)
         	u     LIKE type_file.chr3,  	       #No.FUN-680070 VARCHAR(3)
                a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                b     LIKE type_file.chr1,  		       #No.FUN-680070 VARCHAR(1)
   		more LIKE type_file.chr1             	# Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
         g_desc     ARRAY[3] of LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
DEFINE   g_i          LIKE type_file.num5               #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   l_table      STRING,                           ### FUN-770052 ###                                                               
         g_str        STRING,                           ### FUN-770052 ###                                                               
         g_sql        STRING                            ### FUN-770052 ### 
DEFINE   g_head1      LIKE type_file.chr1000            #No.FUN-770052 VARCHAR(400)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "fdc01.fdc_file.fdc01,",                                                                                            
                "fda02.fda_file.fda02,",                                                                                            
                "fdc07.fdc_file.fdc07,",                                                                                            
                "fdc08.fdc_file.fdc08,", 
                "fdc10.fdc_file.fdc10,",                                                                                            
                "fdd05.fdd_file.fdd05,",                                                                                            
                "fdc11.fdc_file.fdc11,",                                                                                            
                "fda03.fda_file.fda03,",                                                                                            
                "fda04.fda_file.fda04,",                                                                                            
                "fdc03.fdc_file.fdc03,",                                                                                            
                "fdc032.fdc_file.fdc032,",                                                                                            
                "fdb03.fdb_file.fdb03,",                                                                                            
                "fdc05.fdc_file.fdc05,",                                                                                            
                "faj04.faj_file.faj04,",                                                                                           
                "fdc04.fdc_file.fdc04,",                                                                                           
                "gem02.gem_file.gem02,",                                                                                           
                "fdd03.fdd_file.fdd03,",                                                                                            
                "fdd033.fdd_file.fdd033"    
    LET l_table = cl_prt_temptable('afar510',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                    
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#                                                                                         
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r510_tm(0,0)		# Input print condition
      ELSE CALL afar510()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r510_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r510_w AT p_row,p_col WITH FORM "afa/42f/afar510"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '234'
   LET tm.t    = 'Y  '
   LET tm.u    = 'Y  '
   LET tm.a    = '1'
   LET tm.b    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fdd03,fdd033,fdc01,fdc05,fdc03,faj04,fdc04
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r510_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.s,tm.t,tm.u,tm.a,tm.b,tm.more
                      # Condition
         INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD a
               IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN
                  NEXT FIELD a
               END IF
            BEFORE FIELD b
               IF tm.a != '2' THEN
                  NEXT FIELD more
               END IF
            AFTER FIELD b
               IF tm.b NOT MATCHES "[1234]" OR tm.b IS NULL THEN
                  NEXT FIELD b
               END IF
            AFTER FIELD more
              # genero  script marked
              #IF cl_ku() THEN
              #   IF tm.a ='1' THEN
              #      NEXT FIELD a
              #   ELSE
              #      NEXT FIELD b
              #   END IF
              #END IF
               IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
                  NEXT FIELD more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()	# Command execution
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
               LET tm.t = tm2.t1,tm2.t2,tm2.t3
               LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW r510_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar510'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar510','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                            " '",tm.u CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar510',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r510_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar510()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r510_w
END FUNCTION
 
FUNCTION afar510()
   DEFINE l_name  LIKE type_file.chr20,               # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8      #No.FUN-6A0069
          l_sql   LIKE type_file.chr1000,             # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(600)
          l_chr	  LIKE type_file.chr1,                #No.FUN-680070 VARCHAR(1)
          l_za05  LIKE type_file.chr1000,             #No.FUN-680070 VARCHAR(40)
          l_order ARRAY[6] OF LIKE fdc_file.fdc01,    #No.FUN-680070 VARCHAR(10)
          l_gem02 LIKE gem_file.gem02,                #No.FUN-770052    
          sr      RECORD
                     order1 LIKE fdc_file.fdc01,      #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                     order2 LIKE fdc_file.fdc01,      #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                     order3 LIKE fdc_file.fdc01,      #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                     order4 LIKE fdc_file.fdc01,      #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                     fdd03    LIKE fdd_file.fdd03,
                     fdd033   LIKE fdd_file.fdd033,
                     fdc01    LIKE fdc_file.fdc01,
                     fda02    LIKE fda_file.fda02,
                     fdc07    LIKE fdc_file.fdc07,
                     fdc08    LIKE fdc_file.fdc08,
                     fdc09    LIKE fdc_file.fdc09,
                     fdc10    LIKE fdc_file.fdc10,
                     fdd05    LIKE fdd_file.fdd05,
                     fdc11    LIKE fdc_file.fdc11,
                     fda03    LIKE fda_file.fda03,
                     fda04    LIKE fda_file.fda04,
                     fdc03    LIKE fdc_file.fdc03,
                     fdc032   LIKE fdc_file.fdc032,
                     fdb03    LIKE fdb_file.fdb03,    #保險標的物
                     fdc05    LIKE fdc_file.fdc05,
                     faj04    LIKE faj_file.faj04,
                     fdc04    LIKE fdc_file.fdc04
                  END RECORD
     DEFINE  l_name1          LIKE type_file.chr20        #No.FUN-770052
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar510'
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fdduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fddgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fddgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fdduser', 'fddgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','','',",
                 " fdd03,fdd033,fdc01,fda02,fdc07,fdc08,fdc09,fdc10,fdd05,",
                 " fdc11,fda03,fda04,fdc03,fdc032,fdb03,fdc05,faj04,fdc04",
                 " FROM fdc_file,fda_file,fdb_file,fdd_file,OUTER faj_file ",
                 " WHERE fdc01 = fda01 ",
                 "   AND fda01 = fdb01 ",
                 "   AND fda01 = fdd01 ",
                 "   AND fdb02 = fdc04 ",
               # 98/05/28 by clin
                 "   AND fdd02 = fdc03 ",
                 "   AND fdd022= fdc032",
               # 98/05/28 by clin
                  "   AND fdd_file.fdd02=faj_file.faj02 ",
                 "   AND fdd_file.fdd022=faj_file.faj022 ",
                 "   AND ",tm.wc
 
     PREPARE r510_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r510_cs1 CURSOR FOR r510_prepare1
#    CALL cl_outnam('afar510') RETURNING l_name                       #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------#  
#No.FUN-590110 --start--
     IF tm.a='1' THEN
#    {  LET g_zaa[41].zaa06='N'                                            #FUN-770052
#       LET g_zaa[42].zaa06='N'
#       LET g_zaa[43].zaa06='N'
#       LET g_zaa[44].zaa06='N'
#       LET g_zaa[45].zaa06='N'
#       LET g_zaa[46].zaa06='N'
#       LET g_zaa[47].zaa06='N'
#       LET g_zaa[48].zaa06='N'
#       LET g_zaa[49].zaa06='N'
#       LET g_zaa[50].zaa06='N'
#       LET g_zaa[51].zaa06='N'
#       LET g_zaa[52].zaa06='N'
#       LET g_zaa[53].zaa06='N'
#       LET g_zaa[54].zaa06='N'
#       LET g_zaa[55].zaa06='Y'
#       LET g_zaa[56].zaa06='Y'
#       LET g_zaa[57].zaa06='Y'
#       LET g_zaa[58].zaa06='Y'
#       LET g_zaa[59].zaa06='Y'
#       LET g_zaa[60].zaa06='Y'
#       LET g_zaa[61].zaa06='Y'
#       LET g_zaa[62].zaa06='Y'
#       LET g_zaa[63].zaa06='Y'}                                           #FUN-770052
        LET l_name1 = 'afar510'                                            #FUN-770052
    ELSE
#     { LET g_zaa[41].zaa06='Y'                                            #FUN-770052
#       LET g_zaa[42].zaa06='Y'
#       LET g_zaa[43].zaa06='Y'
#       LET g_zaa[44].zaa06='Y'
#       LET g_zaa[45].zaa06='Y'
#       LET g_zaa[46].zaa06='Y'
#       LET g_zaa[47].zaa06='Y'
#       LET g_zaa[48].zaa06='Y'
#       LET g_zaa[49].zaa06='Y'
#       LET g_zaa[50].zaa06='Y'
#       LET g_zaa[51].zaa06='Y'
#       LET g_zaa[52].zaa06='Y'
#       LET g_zaa[53].zaa06='Y'
#       LET g_zaa[54].zaa06='Y'
#       LET g_zaa[60].zaa06='N'
#       LET g_zaa[61].zaa06='N'
#       LET g_zaa[62].zaa06='N'
#       LET g_zaa[63].zaa06='N'}                                          #FUN-770052
      CASE
       WHEN tm.b='1'
#     { LET g_zaa[55].zaa06='N'                                           #FUN-770052
#       LET g_zaa[56].zaa06='Y'
#       LET g_zaa[57].zaa06='Y'
#       LET g_zaa[58].zaa06='Y'
#       LET g_zaa[59].zaa06='Y'}                                          #FUN-770052
        LET l_name1 = 'afar510_1'                                         #FUN-770052
       WHEN tm.b='2'
#     { LET g_zaa[55].zaa06='Y'                                           #FUN-770052
#       LET g_zaa[56].zaa06='N'
#       LET g_zaa[57].zaa06='N'
#       LET g_zaa[58].zaa06='Y'
#       LET g_zaa[59].zaa06='Y'}                                          #FUN-770052
        LET l_name1 = 'afar510_2'                                         #FUN-770052
       WHEN tm.b='3'
#     { LET g_zaa[55].zaa06='Y'                                           #FUN-770052
#       LET g_zaa[56].zaa06='Y'
#       LET g_zaa[57].zaa06='Y'
#       LET g_zaa[58].zaa06='N'
#       LET g_zaa[59].zaa06='Y'}                                          #FUN-770052
        LET l_name1 = 'afar510_3'                                         #FUN-770052
       WHEN tm.b='4'
#     { LET g_zaa[55].zaa06='Y'                                           #FUN-770052
#       LET g_zaa[56].zaa06='Y'
#       LET g_zaa[57].zaa06='Y'
#       LET g_zaa[58].zaa06='Y'
#       LET g_zaa[59].zaa06='N'}                                          #FUN-770052
        LET l_name1 = 'afar510_4'                                         #FUN-770052
      END CASE
     END IF
#    CALL cl_prt_pos_len()                                                #FUN-770052
 
#    START REPORT r510_rep TO l_name    #明細表                           #FUN-770052
     LET g_pageno = 0
#No.FUN-590110 --end--
     FOREACH r510_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.fdc05       #FUN-770052 
           IF SQLCA.sqlcode THEN
               LET l_gem02 = ' '
           END IF
  {    FOR g_i = 1 TO 3                                                   #FUN-770052
          CASE WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fdc01
                                        LET g_desc[g_i] = g_x[22] CLIPPED
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fdc05
                                        LET g_desc[g_i] = g_x[23] CLIPPED
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fdc03
                                        LET g_desc[g_i] = g_x[24] CLIPPED
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj04
                                        LET g_desc[g_i] = g_x[27] CLIPPED
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fdc04
                                        LET g_desc[g_i] = g_x[28] CLIPPED
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
#No.FUN-590110 --start--
IF tm.a='1' THEN
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF cl_null(sr.order3) THEN LET sr.order3 = '---' END IF
       LET sr.order4=''
ELSE
       LET sr.order1 = ''
       LET sr.order2 = ''
       LET sr.order3 = ''
          CASE
            WHEN tm.b = '1'    #表單
              LET sr.order4 = sr.fdc01
            WHEN tm.b = '2'    #部門
              LET sr.order4 = sr.fdc05
            WHEN tm.b = '3'    #資產類別
              LET sr.order4 = sr.faj04
            WHEN tm.b = '4'    #標的物
              LET sr.order4 = sr.fdc04
          END CASE
END IF
#     OUTPUT TO REPORT r510_rep(sr.*)  }  #明細表                    #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING      
                   sr.fdc01,sr.fda02,sr.fdc07,sr.fdc08,sr.fdc10,sr.fdd05,sr.fdc11,sr.fda03,
                   sr.fda04,sr.fdc03,sr.fdc032,sr.fdb03,sr.fdc05,sr.faj04,sr.fdc04,l_gem02,
                   sr.fdd03,sr.fdd033                                                                                          
          #------------------------------ CR (3) ------------------------------# 
     END FOREACH
 
#    FINISH REPORT r510_rep                                          #FUN-770052
#No.FUN-770052--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fdd03,fdd033,fdc01,fdc05,fdc03,faj04,fdc04')                                                                
              RETURNING tm.wc                                                                                                       
      END IF
      IF tm.a='1' THEN                                                                                                                
         LET g_head1=sr.fdd03 USING '####',sr.fdd033 USING '&&'   #,                                                         
      ELSE                                                                                                                            
         LET g_head1=sr.fdd03                                                                                                
      END IF
     
#No.FUN-590110 --end--
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                     #FUN-770052
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.a,";",tm.b,";",tm.wc,";",g_azi05,";",tm.s[1,1],";",                                                         
                tm.s[2,2],";",tm.s[3,3],";",                                                                                        
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",g_azi04,";",g_head1                        
    CALL cl_prt_cs3('afar510',l_name1,l_sql,g_str)                                                                                  
    #------------------------------ CR (4) ------------------------------#   
END FUNCTION
 
{REPORT r510_rep(sr)     #明細表                                     #FUN-770052
   DEFINE l_last_sw LIKE type_file.chr1,                #No.FUN-680070 VARCHAR(1)
          l_str     LIKE type_file.chr50,               #列印排列順序說明    #No.FUN-680070 VARCHAR(50)
          l_gem02   LIKE gem_file.gem02,                #No.FUN-590110
          sr        RECORD
                       order1   LIKE fdc_file.fdc01,    #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                       order2   LIKE fdc_file.fdc01,    #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                       order3   LIKE fdc_file.fdc01,    #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                       order4   LIKE fdc_file.fdc01,    #No.FUN-560060       #No.FUN-680070 VARCHAR(16)
                       fdd03    LIKE fdd_file.fdd03,
                       fdd033   LIKE fdd_file.fdd033,
                       fdc01    LIKE fdc_file.fdc01,
                       fda02    LIKE fda_file.fda02,
                       fdc07    LIKE fdc_file.fdc07,
                       fdc08    LIKE fdc_file.fdc08,
                       fdc09    LIKE fdc_file.fdc09,
                       fdc10    LIKE fdc_file.fdc10,
                       fdd05    LIKE fdd_file.fdd05,
                       fdc11    LIKE fdc_file.fdc11,
                       fda03    LIKE fda_file.fda03,
                       fda04    LIKE fda_file.fda04,
                       fdc03    LIKE fdc_file.fdc03,
                       fdc032   LIKE fdc_file.fdc032,
                       fdb03    LIKE fdb_file.fdb03,    #保險標的物
                       fdc05    LIKE fdc_file.fdc05,
                       faj04    LIKE faj_file.faj04,
                       fdc04    LIKE fdc_file.fdc04
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.fdd03,sr.fdd033,sr.order1,sr.order2,sr.order3,sr.order4 #,sr.fdd03,sr.order4
  FORMAT
   PAGE HEADER
#No.FUN-590110 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
    IF tm.a='1' THEN
      PRINT g_x[15] CLIPPED,sr.fdd03 USING '####',sr.fdd033 USING '&&'   #,
    ELSE
      PRINT g_x[15] CLIPPED,sr.fdd03
    END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
            g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],
            g_x[57],g_x[58],g_x[59],g_x[60],g_x[61],g_x[62],g_x[63]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
     IF tm.a='1' THEN
      IF tm.t[1,1] = 'Y' THEN
         SKIP TO TOP OF PAGE
      END IF
     END IF
   BEFORE GROUP OF sr.order2
     IF tm.a='1' THEN
      IF tm.t[2,2] = 'Y' THEN
         SKIP TO TOP OF PAGE
      END IF
     END IF
   BEFORE GROUP OF sr.order3
     IF tm.a='1' THEN
      IF tm.t[3,3] = 'Y' THEN
         SKIP TO TOP OF PAGE
      END IF
     END IF
 
   BEFORE GROUP OF sr.fdd03   #年月
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
#No.FUN-560060-begin
   IF tm.a='1' THEN
      PRINT COLUMN g_c[41],sr.fdc01 CLIPPED,
            COLUMN g_c[42],sr.fda02 CLIPPED,
            COLUMN g_c[43],cl_numfor(sr.fdc07,43,g_azi04),
            COLUMN g_c[44],sr.fdc08 USING '###.##',
            COLUMN g_c[45],cl_numfor(sr.fdc10,45,g_azi04),
            COLUMN g_c[46],cl_numfor(sr.fdd05,46,g_azi04),
            COLUMN g_c[47],cl_numfor(sr.fdc11,47,g_azi04),
            COLUMN g_c[48],sr.fda03,'-',sr.fda04,
            COLUMN g_c[49],sr.fdc03 CLIPPED,
            COLUMN g_c[50],sr.fdc032 CLIPPED,
            COLUMN g_c[51],sr.fdb03 CLIPPED,
            COLUMN g_c[52],sr.fdc05 CLIPPED,
            COLUMN g_c[53],sr.faj04 CLIPPED,
            COLUMN g_c[54],sr.fdc04 USING '###&' #FUN-590118
   END IF
 
   AFTER GROUP OF sr.order4     #保單或部門
    IF tm.a<>'1' THEN
      CASE
         WHEN tm.b='1'
            PRINT COLUMN g_c[55],sr.fdc01 CLIPPED;
         WHEN tm.b = '2'
            LET l_gem02=''
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.fdc05
            PRINT COLUMN g_c[56],sr.fdc05 CLIPPED,
                  COLUMN g_c[57],l_gem02[1,8];
         WHEN tm.b = '3'
            PRINT COLUMN g_c[58],sr.faj04 CLIPPED;
         WHEN tm.b = '4'
            PRINT COLUMN g_c[59],sr.fdc04 CLIPPED;
      END CASE
      PRINT COLUMN g_c[60],cl_numfor(GROUP SUM(sr.fdd05),60,g_azi05),
            COLUMN g_c[61],cl_numfor(GROUP SUM(sr.fdc07),61,g_azi05),
            COLUMN g_c[62],sr.fdc08 USING '###.##',
            COLUMN g_c[63],cl_numfor(GROUP SUM(sr.fdc10),63,g_azi05)
    END IF
 
   AFTER GROUP OF sr.order1
   IF tm.a='1' THEN
      IF tm.u[1,1] = 'Y' THEN
         PRINT g_dash2[1,g_len]
         PRINT COLUMN g_c[41],g_desc[1] CLIPPED,g_x[25] CLIPPED,
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fdc07),43,g_azi05),
               COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fdc10),45,g_azi05),
               COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fdd05),46,g_azi05),
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.fdc11),47,g_azi05)
         PRINT g_dash2[1,g_len]
       END IF
   END IF
 
   AFTER GROUP OF sr.order2
   IF tm.a='1' THEN
      IF tm.u[2,2] = 'Y' THEN
         PRINT g_dash2[1,g_len]
         PRINT COLUMN g_c[41],g_desc[2] CLIPPED,g_x[20] CLIPPED,
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fdc07),43,g_azi05),
               COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fdc10),45,g_azi05),
               COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fdd05),46,g_azi05),
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.fdc11),47,g_azi05)
         PRINT g_dash2[1,g_len]
      END IF
   END IF
 
   AFTER GROUP OF sr.order3
   IF tm.a='1' THEN
      IF tm.u[3,3] = 'Y' THEN
         PRINT g_dash2[1,g_len]
         PRINT COLUMN g_c[41],g_desc[3] CLIPPED,g_x[26] CLIPPED,
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fdc07),43,g_azi05),
               COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fdc10),45,g_azi05),
               COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fdd05),46,g_azi05),
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.fdc11),47,g_azi05)
         PRINT g_dash2[1,g_len]
      END IF
   END IF
#No.FUN-560060-end
 
   AFTER GROUP OF sr.fdd03
   IF tm.a<>'1' THEN
      PRINT g_dash2[1,g_len]
      CASE  WHEN  tm.b = '1'
               PRINT COLUMN g_c[55],g_x[20] CLIPPED,
                     COLUMN g_c[60],cl_numfor(GROUP SUM(sr.fdd05),60,g_azi05),
                     COLUMN g_c[61],cl_numfor(GROUP SUM(sr.fdc07),61,g_azi05),
                     COLUMN g_c[63],cl_numfor(GROUP SUM(sr.fdc10),63,g_azi05)
            WHEN  tm.b = '2'
               PRINT COLUMN g_c[57],g_x[20] CLIPPED,
                     COLUMN g_c[60],cl_numfor(GROUP SUM(sr.fdd05),60,g_azi05),
                     COLUMN g_c[61],cl_numfor(GROUP SUM(sr.fdc07),61,g_azi05),
                     COLUMN g_c[63],cl_numfor(GROUP SUM(sr.fdc10),63,g_azi05)
            WHEN  tm.b = '3'
               PRINT COLUMN g_c[58],g_x[20] CLIPPED,
                     COLUMN g_c[60],cl_numfor(GROUP SUM(sr.fdd05),60,g_azi05),
                     COLUMN g_c[61],cl_numfor(GROUP SUM(sr.fdc07),61,g_azi05),
                     COLUMN g_c[63],cl_numfor(GROUP SUM(sr.fdc10),63,g_azi05)
 
            WHEN  tm.b = '4'
               PRINT COLUMN g_c[59],g_x[20] CLIPPED,
                     COLUMN g_c[60],cl_numfor(GROUP SUM(sr.fdd05),60,g_azi05),
                     COLUMN g_c[61],cl_numfor(GROUP SUM(sr.fdc07),61,g_azi05),
                     COLUMN g_c[63],cl_numfor(GROUP SUM(sr.fdc10),63,g_azi05)
      END CASE
   END IF
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
  IF tm.a='1' THEN
      PRINT COLUMN g_c[41],g_x[20] CLIPPED,
            COLUMN g_c[43],cl_numfor(SUM(sr.fdc07),43,g_azi05),
            COLUMN g_c[45],cl_numfor(SUM(sr.fdc10),45,g_azi05),
            COLUMN g_c[46],cl_numfor(SUM(sr.fdd05),46,g_azi05),
            COLUMN g_c[47],cl_numfor(SUM(sr.fdc11),47,g_azi05)
  END IF
#No.FUN-590110 --end--
      PRINT g_dash[1,g_len]
      PRINT g_x[21] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}                                                            #FUN-770052
 
#Patch....NO.TQC-610035 <> #
