# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr750.4gl.4gl
# Descriptions...: 訂單變更影響之工單一覽表
# Date & Author..: 01/09/19 By Mandy
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0096 05/03/03 By Echo  調整單價、金額、匯率欄位大小
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550070 05/05/26 By day   單據編號加大
# Modify.........: No.FUN-590110 05/09/23 By Tracy 報表修改,轉XML格式
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima021規格
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-750112 07/06/28 By ice CR報表修改
#
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)  # Where condition
                a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)    #列印方式:1.確認 2.未確認 3.全部
   		more	LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD,
        g_argv1      LIKE faj_file.faj02,      # No.FUN-680137 VARCHAR(10)
        l_str        LIKE gsb_file.gsb05       # No.FUN-680137 VARCHAR(4)
 
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72)
DEFINE  l_table     STRING                 ### FUN-750112 ###
DEFINE  g_str       STRING                 ### FUN-750112 ###
DEFINE  g_sql       STRING                 ### FUN-750112 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "order_no.type_file.num5,",
                "flag.type_file.chr1,",
                "oep01.oep_file.oep01,",
                "oep04.oep_file.oep04,",
                "oep02.oep_file.oep02,",
                "oep08.oep_file.oep08,",
                "oep06.oep_file.oep06,",
                "oep07.oep_file.oep07,",
                "oep08b.oep_file.oep08b,",
                "oep06b.oep_file.oep06b,",
                "oep07b.oep_file.oep07b,",
                "oeq01.oeq_file.oeq01,",
                "oeq03.oeq_file.oeq03,",
                "oeq04b.oeq_file.oeq04b,",
                "oeq041b.oeq_file.oeq041b,",
                "oeq12b.oeq_file.oeq12b,",
                "oeq05b.oeq_file.oeq05b,",
                "oeq13b.oeq_file.oeq13b,",
                "oeq14b.oeq_file.oeq14b,",
                "oeq15b.oeq_file.oeq15b,",
                "oeq04a.oeq_file.oeq04a,",
                "oeq041a.oeq_file.oeq041a,",
                "oeq12a.oeq_file.oeq12a,",
                "oeq05a.oeq_file.oeq05a,",
                "oeq13a.oeq_file.oeq13a,",
                "oeq14a.oeq_file.oeq14a,",
                "oeq15a.oeq_file.oeq15a,",
                "ima021.ima_file.ima021,",
                "ima021_1.ima_file.ima021,",
                "azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05,",
                "azi03_1.azi_file.azi03,",
                "azi04_1.azi_file.azi04,",
                "azi05_1.azi_file.azi05,",
                "sr_sfb01.sfb_file.sfb01,",
                "sr_sfb04.sfb_file.sfb04,",
                "sr_sfb13.sfb_file.sfb13,",
                "sr_sfb15.sfb_file.sfb15,",
                "sr_sfa03.sfb_file.sfb03,",
                "sr_ima02.ima_file.ima02,",
                "sr_ima021.ima_file.ima021,",
                "sr_sfb08.sfb_file.sfb08,",
                "sr_sfb09.sfb_file.sfb09,",
                "sr_sfa05.sfa_file.sfa05,",
                "sr_sfa06.sfa_file.sfa06,",
                "sr_sfa05_06.sfa_file.sfa05"
 
    LET l_table = cl_prt_temptable('axmr750',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ? ,?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ? ,?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ? ,?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ? ,?, ?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#--------------------No.FUN-750112--end------CR (1) ------------#
 
   INITIALIZE tm.* TO NULL			# Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.a ='1'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
 
 #--------------No.TQC-610089 modify
  #IF cl_null(g_argv1)
   IF cl_null(tm.wc)
      THEN CALL r750_tm()	             	# Input print condition
   ELSE  
     #LET tm.wc=" oep01='",g_argv1,"'"
      CALL r750()		          	# Read data and create out-file
   END IF
 #--------------No.TQC-610089 end
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r750_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          p_row         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          p_col         LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET p_row = 6 LET p_col = 17
 
   OPEN WINDOW r750_w AT p_row,p_col WITH FORM "axm/42f/axmr750"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a ='1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oep01,oep04
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
      LET INT_FLAG = 0 CLOSE WINDOW r750_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
          IF tm.a NOT MATCHES "[123]" THEN NEXT FIELD a END IF
          IF cl_null(tm.a) THEN NEXT FIELD a END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r750_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmr750'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr750','9031',1)
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
                         " '",tm.a CLIPPED,"'",                #No.TQC-610089 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr750',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r750_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r750()
   ERROR ""
END WHILE
   CLOSE WINDOW r750_w
END FUNCTION
 
FUNCTION r750()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0094
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_order	ARRAY[5] OF LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
          l_bmz02       LIKE bmz_file.bmz02,
          sr            RECORD
                            sfb01  LIKE sfb_file.sfb01,
                            sfb04  LIKE sfb_file.sfb04,
                            sfb13  LIKE sfb_file.sfb13,
                            sfb15  LIKE sfb_file.sfb15,
                            sfa03  LIKE sfa_file.sfa03,
                            ima02  LIKE ima_file.ima02,
                            ima021 LIKE ima_file.ima021,   #FUN-5A0060 add
                            sfb08  LIKE sfb_file.sfb08,
                            sfb09  LIKE sfb_file.sfb09,
                            sfa05  LIKE sfa_file.sfa05,
                            sfa06  LIKE sfa_file.sfa06,
                            sfa05_06  LIKE sfa_file.sfa05    #未發數量
                        END RECORD,
#--------------------No.FUN-750112--begin-------------------------#
#         oep		RECORD LIKE oep_file.*,
          oep		RECORD 
                           oep01 LIKE oep_file.oep01,
                           oep04 LIKE oep_file.oep04,
                           oep02 LIKE oep_file.oep02,
                           oep08 LIKE oep_file.oep08,
                           oep06 LIKE oep_file.oep06,
                           oep07 LIKE oep_file.oep07,
                           oep08b LIKE oep_file.oep08b,
                           oep06b LIKE oep_file.oep06b,
                           oep07b LIKE oep_file.oep07b
                        END RECORD,
#         oeq		RECORD LIKE oeq_file.*
          oeq		RECORD 
                           oeq01 LIKE oeq_file.oeq01,
                           oeq03 LIKE oeq_file.oeq03,
                           oeq04b LIKE oeq_file.oeq04b,
                           oeq041b LIKE oeq_file.oeq041b,
                           oeq12b LIKE oeq_file.oeq12b,
                           oeq05b LIKE oeq_file.oeq05b,
                           oeq13b LIKE oeq_file.oeq13b,
                           oeq14b LIKE oeq_file.oeq14b,
                           oeq15b LIKE oeq_file.oeq15b,
                           oeq04a LIKE oeq_file.oeq04a,
                           oeq041a LIKE oeq_file.oeq041a,
                           oeq12a LIKE oeq_file.oeq12a,
                           oeq05a LIKE oeq_file.oeq05a,
                           oeq13a LIKE oeq_file.oeq13a,
                           oeq14a LIKE oeq_file.oeq14a,
                           oeq15a LIKE oeq_file.oeq15a
                        END RECORD
          DEFINE l_order_no   LIKE type_file.num5  #No.FUN-750112 為了確保報表顯示的一定正確
          DEFINE l_flag       LIKE type_file.chr1  #No.FUN-750112 標識是否要打印明細單頭 Y:是 N:否
          DEFINE t_azi03      LIKE azi_file.azi03  #No.FUN-750112
          DEFINE t_azi04      LIKE azi_file.azi04  #No.FUN-750112
          DEFINE t_azi05      LIKE azi_file.azi05  #No.FUN-750112
          DEFINE l_ima021     LIKE ima_file.ima021 #No.FUN-750112
          DEFINE l_ima021_1   LIKE ima_file.ima021 #No.FUN-750112
          DEFINE t_azi03_1    LIKE azi_file.azi03  #No.FUN-750112
          DEFINE t_azi04_1    LIKE azi_file.azi04  #No.FUN-750112
          DEFINE t_azi05_1    LIKE azi_file.azi05  #No.FUN-750112
 
#--------------------No.FUN-750112--end---------------------------#
 
#--------------------No.FUN-750112--begin----CR(2)----------------#
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
#--------------------No.FUN-750112--end------CR(2)----------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oepuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oepgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oepgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oepuser', 'oepgrup')
     #End:FUN-980030
 
#--------------------No.FUN-750112--begin---------mark------#
#    LET l_sql = "SELECT * ",
     LET l_sql = "SELECT oep01,oep04,oep02,oep08,oep06,oep07,oep08b,oep06b,oep07b, ",
                 "       oeq01,oeq03,oeq04b,oeq041b,oeq12b,oeq05b,oeq13b,oeq14b,oeq15b, ",
                 "       oeq04a,oeq041a,oeq12a,oeq05a,oeq13a,oeq14a,oeq15a ",
                 "  FROM oep_file, oeq_file",
                 " WHERE oep01=oeq01 ",
                 "   AND oep02=oeq02 ",
                 "   AND oepconf <> 'X'",
                 "   AND oep02=(SELECT MAX(oep02) FROM oep_file WHERE oep01=oeq01) ",
                 "   AND ",tm.wc CLIPPED
     CASE tm.a
         WHEN '1' #1.確認
             LET l_sql = l_sql CLIPPED," AND oepconf = 'Y' "
         WHEN '2' #2.未確認
             LET l_sql = l_sql CLIPPED," AND oepconf = 'N' "
         WHEN '3' #3.全部
             LET l_sql = l_sql CLIPPED," AND oepconf <> 'X' "
     END CASE
     LET l_sql = l_sql CLIPPED," ORDER BY oep01,oeq03,oep04,oep02"
     PREPARE r750_prepare1 FROM l_sql
#--------------------No.FUN-750112--begin---------mark------#
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE r750_c1 CURSOR FOR r750_prepare1
 
    #去串影響到的工單(已確認,未結案)
     LET l_sql="SELECT sfb01,sfb04,sfb13,sfb15,sfa03,ima02,ima021,", #BugNo:4516   #FUN-5A0060 add ima021
               "       sfb08,sfb09,sfa05,sfa06,(sfa05-sfa06)",
               "  FROM sfa_file,sfb_file,OUTER ima_file ",
               " WHERE sfb01=sfa01 ",
               "   AND sfb04!='8' ", #工單狀態 != '8' ==>未結案
               "   AND sfb87='Y' ",  #已確認
               "   AND sfa_file.sfa03 = ima_file.ima01",
               "   AND sfb22 = ?  ", #訂單編號
               "   AND sfb221= ?  ", #訂單項次
               " ORDER BY sfb01"
     PREPARE r750_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE r750_c2 CURSOR FOR r750_prepare2
 
     LET l_sql="SELECT COUNT(*) ",
               "  FROM sfa_file,sfb_file",
               " WHERE sfb01=sfa01 ",
               "   AND sfb04!='8' ",
               "   AND sfb87='Y' ",
               "   AND sfb22 = ?  ", #訂單編號
               "   AND sfb221= ?  "  #訂單項次
     PREPARE r750_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE r750_c3 CURSOR FOR r750_prepare3
 
#--------------------No.FUN-750112--begin---------mark------#
#      CALL cl_outnam('axmr750') RETURNING l_name
# #No.FUN-550070-begin
# #    LET g_len = 150
# #    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
# #    FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
# #No.FUN-550070-end
#      START REPORT r750_rep TO l_name
#      LET g_pageno = 0
#--------------------No.FUN-750112--end------------mark-----#
 
#--------------------No.FUN-750112--begin----CR(3)----------------#
     LET l_order_no = 0
     FOREACH r750_c1 INTO oep.*, oeq.*
         IF STATUS THEN CALL cl_err('r750_c1',STATUS,1) EXIT FOREACH END IF
         LET g_cnt = 0
         OPEN r750_c3 USING oeq.oeq01,oeq.oeq03
         FETCH r750_c3 INTO g_cnt
         IF g_cnt > 0 THEN
             LET l_order_no = l_order_no + 1
             LET l_flag = 'X'
             SELECT azi03,azi04,azi05 
               INTO t_azi03,t_azi04,t_azi05
               FROM azi_file WHERE azi01 = oep.oep08
             SELECT ima021 INTO l_ima021 
               FROM ima_file 
              WHERE ima01=oeq.oeq04b
             IF STATUS THEN LET l_ima021 = ' ' END IF
             IF NOT cl_null(oep.oep08b) THEN
                SELECT azi03,azi04,azi05 
                  INTO t_azi03_1,t_azi04_1,t_azi05_1
                  FROM azi_file WHERE azi01 = oep.oep08b
             END IF
             LET l_ima021_1 = ''
             SELECT ima021 INTO l_ima021_1 
               FROM ima_file
              WHERE ima01=oeq.oeq04a
             IF STATUS THEN LET l_ima021_1 = ' ' END IF
             EXECUTE insert_prep USING l_order_no,l_flag,oep.oep01,oep.oep04,oep.oep02,
                                       oep.oep08,oep.oep06,oep.oep07,oep.oep08b,oep.oep06b,
                                       oep.oep07b,oeq.oeq01,oeq.oeq03,oeq.oeq04b,oeq.oeq041b,
                                       oeq.oeq12b,oeq.oeq05b,oeq.oeq13b,oeq.oeq14b,oeq.oeq15b,
                                       oeq.oeq04a,oeq.oeq041a,oeq.oeq12a,oeq.oeq05a,oeq.oeq13a,
                                       oeq.oeq14a,oeq.oeq15a,l_ima021,l_ima021_1,t_azi03,
                                       t_azi04,t_azi05,t_azi03_1,t_azi04_1,t_azi05_1,
                                       '','','','','', '','','','','', '',''
#            OUTPUT TO REPORT r750_rep(oep.*,oeq.*)
#            以oeq03(訂單項次分組),找出對應的工單檔/根據表結構,可以認定每筆資料都在分組
             FOREACH r750_c2 USING oeq.oeq01,oeq.oeq03 INTO sr.*
                IF STATUS THEN CALL cl_err('r750_c2',STATUS,1) EXIT FOREACH END IF
                IF l_flag <> 'N' THEN
                   #第一步,顯示抬頭標題
                   LET l_flag = 'Y'
                   LET l_order_no = l_order_no + 1
                   EXECUTE insert_prep USING l_order_no,l_flag,'','','',
                                             '','','','','', '','','','','',
                                             '','','','','', '','','','','',
                                             '','','','','', '','','','','',
                                             '','','','','', '','','','','',
                                             '',''
                   LET l_flag = 'N'
                END IF
                LET l_order_no = l_order_no + 1
                EXECUTE insert_prep USING l_order_no,l_flag,oep.oep01,oep.oep04,oep.oep02,
                                          oep.oep08,oep.oep06,oep.oep07,oep.oep08b,oep.oep06b,
                                          oep.oep07b,oeq.oeq01,oeq.oeq03,oeq.oeq04b,oeq.oeq041b,
                                          oeq.oeq12b,oeq.oeq05b,oeq.oeq13b,oeq.oeq14b,oeq.oeq15b,
                                          oeq.oeq04a,oeq.oeq041a,oeq.oeq12a,oeq.oeq05a,oeq.oeq13a,
                                          oeq.oeq14a,oeq.oeq15a,l_ima021,l_ima021_1,t_azi03,
                                          t_azi04,t_azi05,t_azi03_1,t_azi04_1,t_azi05_1,
                                          sr.sfb01,sr.sfb04,sr.sfb13,sr.sfb15,sr.sfa03,
                                          sr.ima02,sr.ima021,sr.sfb08,sr.sfb09,sr.sfa05,
                                          sr.sfa06,sr.sfa05_06
             END FOREACH
         END IF
     END FOREACH
#--------------------No.FUN-750112--end------CR(3)----------------#
 
#--------------------No.FUN-750112--begin----CR(4)----------------#
#    FINISH REPORT r750_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY order_no" 
    CALL cl_wcchp(tm.wc,'oep01,oep04')
         RETURNING tm.wc
    LET g_str = tm.wc,";",g_zz05
    CALL cl_prt_cs3('axmr750','axmr750',l_sql,g_str)     
#--------------------No.FUN-750112--end------CR(4)----------------#
END FUNCTION
 
#--------------------No.FUN-750112--begin----mark--------------#
# REPORT r750_rep(oep,oeq)
#    DEFINE l_last_sw	LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#           sr            RECORD
#                             sfb01  LIKE sfb_file.sfb01,
#                             sfb04  LIKE sfb_file.sfb04,
#                             sfb13  LIKE sfb_file.sfb13,
#                             sfb15  LIKE sfb_file.sfb15,
#                             sfa03  LIKE sfa_file.sfa03,
#                             ima02  LIKE ima_file.ima02,
#                             ima021 LIKE ima_file.ima021,   #FUN-5A0060 add
#                             sfb08  LIKE sfb_file.sfb08,
#                             sfb09  LIKE sfb_file.sfb09,
#                             sfa05  LIKE sfa_file.sfa05,
#                             sfa06  LIKE sfa_file.sfa06,
#                             sfa05_06 LIKE sfa_file.sfa05        #未發數量
#                         END RECORD,
# #--------------------No.FUN-750112--begin-------------------------#
# #         oep		RECORD LIKE oep_file.*,
#           oep		RECORD 
#                            oep01 LIKE oep_file.oep01,
#                            oep04 LIKE oep_file.oep04,
#                            oep02 LIKE oep_file.oep02,
#                            oep08 LIKE oep_file.oep08,
#                            oep06 LIKE oep_file.oep06,
#                            oep07 LIKE oep_file.oep07,
#                            oep08b LIKE oep_file.oep08b,
#                            oep06b LIKE oep_file.oep06b,
#                            oep07b LIKE oep_file.oep07b
#                         END RECORD,
# #         oeq		RECORD LIKE oeq_file.*
#           oeq		RECORD 
#                            oeq01 LIKE oeq_file.oeq01,
#                            oeq03 LIKE oeq_file.oeq03,
#                            oeq04b LIKE oeq_file.oeq04b,
#                            oeq041b LIKE oeq_file.oeq041b,
#                            oeq12b LIKE oeq_file.oeq12b,
#                            oeq05b LIKE oeq_file.oeq05b,
#                            oeq13b LIKE oeq_file.oeq13b,
#                            oeq14b LIKE oeq_file.oeq14b,
#                            oeq15b LIKE oeq_file.oeq15b,
#                            oeq04a LIKE oeq_file.oeq04a,
#                            oeq041a LIKE oeq_file.oeq041a,
#                            oeq12a LIKE oeq_file.oeq12a,
#                            oeq05a LIKE oeq_file.oeq05a,
#                            oeq13a LIKE oeq_file.oeq13a,
#                            oeq14a LIKE oeq_file.oeq14a,
#                            oeq15a LIKE oeq_file.oeq15a
#                         END RECORD
# #--------------------No.FUN-750112--end---------------------------#
#   DEFINE  l_n           LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#           l_sfb01_last  LIKE sfb_file.sfb01
#   DEFINE  l_ima021      LIKE ima_file.ima021   #FUN-5A0060 add
 
#   OUTPUT TOP MARGIN g_top_margin
#          LEFT MARGIN g_left_margin
#          BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH g_page_line
 
#   ORDER BY oep.oep01,oeq.oeq03,oep.oep04,oep.oep02
#   FORMAT
#     PAGE HEADER
#   #No.FUN-590110 --start--
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#       PRINT ' '
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<',"/pageno"
#       PRINT g_head CLIPPED, pageno_total
# #No.FUN-590110 --end--
#       PRINT g_dash[1,g_len]
# #No.FUN-590110 --start--
#       PRINTX name=H1
#              g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[57],g_x[59],   #FUN-5A0060 add g_x[59]
#              g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#              g_x[46],g_x[47],g_x[58],g_x[60],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]    #FUN-5A0060 add g_x[60]
#       PRINTX name=H2
#              g_x[53],g_x[54],g_x[55],g_x[56]
#       PRINT  g_dash1
# #No.FUN-590110 --end--
#       LET l_last_sw = 'n'
#     BEFORE GROUP OF oep.oep01
# #No.FUN-590110 --start--
#        PRINTX name=D1
#               COLUMN g_c[31],oep.oep01,
#               COLUMN g_c[32],oeq.oeq03 USING "####";
# #No.FUN-590110 --end--
#     ON EVERY ROW
#         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
#           FROM azi_file WHERE azi01 = oep.oep08
#        #start FUN-5A0060 add
#         SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=oeq.oeq04b
#         IF STATUS THEN LET l_ima021 = ' ' END IF
#        #end FUN-5A0060 add
#         #前:
# #No.FUN-590110 --start--
#        PRINTX name=D1
#               COLUMN g_c[33],oep.oep04,
#               COLUMN g_c[34],oep.oep06,
#               COLUMN g_c[35],oep.oep07,
#               COLUMN g_c[36],oep.oep08[1,4],
#               COLUMN g_c[37],oeq.oeq04b CLIPPED,   #NO.FUN-5B0015
#               #COLUMN g_c[37],oeq.oeq04b[1,20],
#               #COLUMN g_c[57],oeq.oeq041b[1,20],
#               COLUMN g_c[57],oeq.oeq041b clipped,  #NO.FUN-5B0015
#               COLUMN g_c[59],l_ima021 CLIPPED,     #FUN-5A0060 add
#               COLUMN g_c[38],oeq.oeq12b USING "########",
#               COLUMN g_c[39],oeq.oeq05b,
#               COLUMN g_c[40],cl_numfor(oeq.oeq13b,15,t_azi03),
#               COLUMN g_c[41],cl_numfor(oeq.oeq14b,18,t_azi04),
#               COLUMN g_c[42],oeq.oeq15b
# #No.FUN-590110 --end--
#         IF NOT cl_null(oep.oep08b) THEN
#            SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
#              FROM azi_file WHERE azi01 = oep.oep08b
#         END IF
#        #start FUN-5A0060 add
#         LET l_ima021 = ''
#         SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=oeq.oeq04a
#         IF STATUS THEN LET l_ima021 = ' ' END IF
#        #end FUN-5A0060 add
#         #後:
# #No.FUN-590110 --start--
#        PRINTX name=D1
#               COLUMN g_c[34],oep.oep06b,
#               COLUMN g_c[35],oep.oep07b,
#               COLUMN g_c[36],oep.oep08b[1,4],
#               #COLUMN g_c[37],oeq.oeq04a[1,20],
#               COLUMN g_c[37],oeq.oeq04a clipped, #NO.FUN-5B0015
#               #COLUMN g_c[57],oeq.oeq041a[1,20],
#               COLUMN g_c[57],oeq.oeq041a clipped,  #NO.FUN-5B0015
#               COLUMN g_c[59],l_ima021 CLIPPED,     #FUN-5A0060 add
#               COLUMN g_c[38],oeq.oeq12a USING "########",
#               COLUMN g_c[39],oeq.oeq05a,
#               COLUMN g_c[40],cl_numfor(oeq.oeq13a,15,t_azi03),
#               COLUMN g_c[41],cl_numfor(oeq.oeq14a,18,t_azi04),
#               COLUMN g_c[42],oeq.oeq15a;
# #No.FUN-590110 --end--
# 
#     AFTER GROUP OF oeq.oeq03
#         LET l_n = 1
#         LET l_sfb01_last = ''
#         FOREACH r750_c2
#         USING oeq.oeq01,oeq.oeq03
#         INTO sr.*
#             IF STATUS THEN CALL cl_err('r750_c2',STATUS,1) EXIT FOREACH END IF
#             CALL r750_sfb04(sr.sfb04) RETURNING g_msg
#           IF l_sfb01_last != sr.sfb01 OR l_n = 1 THEN
# #No.FUN-590110 --start--
#            PRINTX name=D1
#                   COLUMN  g_c[43],sr.sfb01,
#                   COLUMN  g_c[44],g_msg[1,4],
#                   COLUMN  g_c[45],sr.sfb13,
#                   COLUMN  g_c[46],sr.sfb15;
# #No.FUN-590110 --end--
#           END IF
# #No.FUN-590110 --start--
#            PRINTX name=D1
#                   #COLUMN g_c[47],sr.sfa03[1,20],                   #發料料號
#                   COLUMN g_c[47],sr.sfa03 CLIPPED,    #NO.FUN-5B0015  #發料料號
#                   #COLUMN g_c[58],sr.ima02[1,20],
#                   COLUMN g_c[58],sr.ima02 clipped,  #NO.FUN-5B0015
#                   COLUMN g_c[60],sr.ima021 clipped,  #FUN-5A0060 add
#                   COLUMN g_c[48],sr.sfb08    USING "########",
#                   COLUMN g_c[49],sr.sfb09    USING "########",
#                   COLUMN g_c[50],sr.sfa05    USING "########",
#                   COLUMN g_c[51],sr.sfa06    USING "########",
#                   COLUMN g_c[52],sr.sfa05_06 USING "########"
# #No.FUN-590110 --end--
#           LET l_n = l_n + 1
#           LET l_sfb01_last = sr.sfb01
#         END FOREACH
#         PRINT g_dash2[1,g_len]
# 
#    ON LAST ROW
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#              g_x[7] CLIPPED
#        LET l_last_sw = 'y'
# 
#    PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#          PRINT ' '
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#          SKIP 3 LINE
#       END IF
# END REPORT
#--------------------No.FUN-750112--end------mark--------------#
 
FUNCTION r750_sfb04(p_sfb04)
    DEFINE p_sfb04      LIKE type_file.num5        # No.FUN-680137 SMALLINT
    DEFINE l_str        LIKE gsb_file.gsb05      # No.FUN-680137 VARCHAR(10)
     #1.開立 2.發放 3.列印 4.發料 5.WIP 6.FQC 7.入庫 8.結案
     CASE WHEN p_sfb04 ='1' LET l_str=g_x[28] CLIPPED
          WHEN p_sfb04 ='2' LET l_str=g_x[29] CLIPPED
          WHEN p_sfb04 ='3' LET l_str=g_x[30] CLIPPED
          WHEN p_sfb04 ='4' LET l_str=g_x[23] CLIPPED  #No.FUN-590110
          WHEN p_sfb04 ='5' LET l_str=g_x[24] CLIPPED  #No.FUN-590110
          WHEN p_sfb04 ='6' LET l_str=g_x[25] CLIPPED  #No.FUN-590110
          WHEN p_sfb04 ='7' LET l_str=g_x[26] CLIPPED  #No.FUN-590110
          WHEN p_sfb04 ='8' LET l_str=g_x[27] CLIPPED  #No.FUN-590110
     END CASE
    RETURN l_str
END FUNCTION
#Patch....NO.TQC-610037 <> #
