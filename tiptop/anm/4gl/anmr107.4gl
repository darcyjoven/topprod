# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr107.4gl
# Descriptions...: 支票使用清單列印
# Date & Author..: 99/05/09 By Iceman
# Modify.........: No.FUN-4C0098 05/01/07 By pengu 報表轉XML
# Modify.........: NO.TQC-5B0047 05/11/08 By Niocla 報表修改
# Modify.........: No.MOD-5A0283 05/11/28 By Smapmin 報表資料有誤
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Mofify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/21 By johnray 報表修改
# Modify.........: No.TQC-6B0189 06/12/04 By Smapmin 增加報表列印條件
# Modify.........: No.FUN-780011 07/08/16 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-7B0046 07/11/07 By Smapmin 未使用支票列印有誤
# Modify.........: No.FUN-7B0082 07/11/18 By jamie 放大i為num10,因為l_begin為num10,而程式FOR i = l_begin TO l_end。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			   # Print condition RECORD
              wc    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) #Where Condiction
              more  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)             
              END RECORD,
          g_buf     LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
 
 DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
 DEFINE   g_head1    STRING
#DEFINE   i          LIKE type_file.num5    #FUN-7B0082 mod #No.FUN-680107 SMALLINT
 DEFINE   i          LIKE type_file.num10   #FUN-7B0082 mod #No.FUN-680107 SMALLINT
 DEFINE   j          LIKE type_file.num5    #No.FUN-680107 SMALLINT
 DEFINE   l_table    STRING  #No.FUN-780011
 DEFINE   g_str      STRING  #No.FUN-780011
 DEFINE   g_sql      STRING  #No.FUN-780011
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-780011  --Begin
   LET g_sql = " nmw01.nmw_file.nmw01,",
               " nmw03.nmw_file.nmw03,",
               " nmw04.nmw_file.nmw04,",
               " nmw05.nmw_file.nmw05,",
               " nmw06.nmw_file.nmw06,",
               " type.type_file.chr1,",
               " nmd01.nmd_file.nmd01,",
               " nmd02.nmd_file.nmd02,",
               " nmd04.nmd_file.nmd04,",
               " nmd05.nmd_file.nmd05,",
               " nmd07.nmd_file.nmd07,",
               " nmd08.nmd_file.nmd08,",
               " nmd21.nmd_file.nmd21,",
               " nmd24.nmd_file.nmd24,",
               " nnz03.nnz_file.nnz03,",
               " nnzuser.nnz_file.nnzuser,",
               " nma03.nma_file.nma03,",
               " azi04.azi_file.azi04,",
               #" cnt1.type_file.num10,",   #MOD-7B0046
               " tot.type_file.num10  "
   LET l_table = cl_prt_temptable('anmr107',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               #"        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "   #MOD-7B0046
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?) "   #MOD-7B0046
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780011  --End
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr107_tm()	        	# Input print condition
      ELSE CALL anmr107()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr107_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd	     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
       l_jmp_flag    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr107_w AT p_row,p_col
        WITH FORM "anm/42f/anmr107"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmw01,nmw03
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr107_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr107_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr107'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr107','9031',1)   
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr107',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr107_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr107()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr107_w
END FUNCTION
 
FUNCTION anmr107()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容  #No.FUN-680107 VARCHAR(40)
          l_nmw         RECORD LIKE nmw_file.*,
          l_nna04       LIKE nna_file.nna04,
          l_nna05       LIKE nna_file.nna05,
          g_msg         LIKE type_file.chr1000,         #No.FUN-680107 VARCHAR(40)
          sr,sr1        RECORD  #No.FUN-780011
                        type    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
                        nmd01   LIKE nmd_file.nmd01,
                        nmd02   LIKE nmd_file.nmd02,
                        nmd04   LIKE nmd_file.nmd04,
                        nmd05   LIKE nmd_file.nmd05,
                        nmd07   LIKE nmd_file.nmd07,
                        nmd08   LIKE nmd_file.nmd08,
                        nmd21   LIKE nmd_file.nmd21,
                        nmd24   LIKE nmd_file.nmd24,
                        nnz03   LIKE nnz_file.nnz03,
                        nnzuser LIKE nnz_file.nnzuser
                        END RECORD
#No.FUN-780011  --Begin
DEFINE    l_nma03       LIKE nma_file.nma03
DEFINE    l_nmd02       LIKE nmd_file.nmd02
DEFINE    l_no          LIKE nmd_file.nmd02
DEFINE    l_point,l_begin,l_end      LIKE type_file.num10
DEFINE    l_tot,l_cnt1,l_cnt2,l_cnt3 LIKE type_file.num10
DEFINE    l_x           LIKE zaa_file.zaa08              
#No.FUN-780011  --End  
DEFINE    l_cnt    SMALLINT   #MOD-7B0046
DEFINE    max_nmd02 LIKE nmd_file.nmd02   #MOD-7B0046
 
     #No.FUN-780011  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmwuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmwgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmwgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmwuser', 'nmwgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT * FROM nmw_file WHERE ",tm.wc CLIPPED," ORDER BY nmw03"
     PREPARE anmr107_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr107_curs1 CURSOR FOR anmr107_prepare1
 
     #No.FUN-780011  --Begin
     #CALL cl_outnam('anmr107') RETURNING l_name
     #START REPORT anmr107_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-780011  --End  
 
     FOREACH anmr107_curs1 INTO l_nmw.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-780011  --Begin
       SELECT nma03 INTO l_nma03 FROM nma_file WHERE nma01 = l_nmw.nmw01
       SELECT nna04,nna05 INTO l_nna04,l_nna05
         FROM nna_file
        WHERE nna01=l_nmw.nmw01
          AND nna021=l_nmw.nmw03 AND nna02=l_nmw.nmw06
        #-----MOD-7B0046---------
        LET l_point = l_nna04 - l_nna05 + 1
        LET l_end   = l_nmw.nmw05[l_point,l_nna04]
        LET l_begin = l_nmw.nmw04[l_point,l_nna04]
        LET l_tot = (l_end - l_begin) + 1   
        #-----END MOD-7B0046-----
       LET l_nmd02 = NULL
       #LET l_cnt1 = 0  #MOD-7B0046
       #LET l_tot = 0   #MOD-7B0046
       #No.FUN-780011  --End  
 
       DECLARE r107_curs2 CURSOR FOR
        SELECT '1',nmd01,nmd02,nmd04,nmd05,nmd07,nmd08,nmd21,nmd24,'',''
          FROM nmd_file
         WHERE nmd03 = l_nmw.nmw01
           AND nmd31 = l_nmw.nmw06
           AND nmd30 <> 'X'
           AND nmd02 BETWEEN l_nmw.nmw04 AND l_nmw.nmw05
       FOREACH r107_curs2 INTO sr.*
          #-----MOD-7B0046---------
          {
          #no.5862
          SELECT nna04,nna05 INTO l_nna04,l_nna05 FROM nna_file
           WHERE nna01=l_nmw.nmw01 AND nna021=l_nmw.nmw03
             AND nna02=l_nmw.nmw06
          IF STATUS THEN
             LET g_msg='check:',l_nmw.nmw01 ,' date:',l_nmw.nmw03,
                       ' no:',l_nmw.nmw06
#            CALL cl_err(g_msg,STATUS,1)  #No.FUN-660148
             CALL cl_err3("sel","nna_file",l_nmw.nmw01,l_nmw.nmw03,STATUS,"","",1) #No.FUN-660148
             CONTINUE FOREACH  
          END IF
          #no.5862(end)
          #No.FUN-780011  --Begin
          LET l_point = l_nna04 - l_nna05 + 1
          LET l_end   = l_nmw.nmw05[l_point,l_nna04]
          LET l_begin = l_nmw.nmw04[l_point,l_nna04]
          LET l_tot = (l_end - l_begin) + 1
          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nmd21
          IF l_nmd02 = sr.nmd02 THEN
             LET l_cnt1 = l_cnt1 - 1
          END IF
          LET i = l_nmd02[l_point,l_nna04] - sr.nmd02[l_point,l_nna04]
          FOR j = i+1 TO -1
              LET l_no = sr.nmd02[l_point,l_nna04]
              CALL r107_using(l_no,l_nna05,j) RETURNING l_no
              LET l_nmd02 = sr.nmd02[1,l_point-1],l_no
              LET sr1.* = sr.*
              LET sr1.nmd02 = l_nmd02
              LET sr1.type = '3'      #空號
              EXECUTE insert_prep USING l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
                      l_nmw.nmw05,l_nmw.nmw06,sr1.*,l_nma03,t_azi04,l_cnt1,
                      l_tot
          END FOR
          }
          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nmd21
          #-----END MOD-7B0046----- 
          #OUTPUT TO REPORT anmr107_rep(l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
          #                             l_nmw.nmw05,l_nmw.nmw06,sr.*)
          EXECUTE insert_prep USING l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
                  #l_nmw.nmw05,l_nmw.nmw06,sr.*,l_nma03,t_azi04,l_cnt1,   #MOD-7B0046
                  l_nmw.nmw05,l_nmw.nmw06,sr.*,l_nma03,t_azi04,   #MOD-7B0046
                  l_tot
          #LET l_nmd02 = sr.nmd02   #MOD-7B0046
          #No.FUN-780011  --End  
       END FOREACH
       DECLARE r107_curs3 CURSOR FOR
        SELECT '2','',nnz02,'','','','','','',nnz03,nnzuser
          FROM nnz_file
         WHERE nnz01 = l_nmw.nmw01
           AND nnz02 BETWEEN l_nmw.nmw04 AND l_nmw.nmw05
       FOREACH r107_curs3 INTO sr.*
          #-----MOD-7B0046---------
          {   
          #no.5862
          SELECT nna04,nna05 INTO l_nna04,l_nna05 FROM nna_file
           WHERE nna01=l_nmw.nmw01 AND nna021=l_nmw.nmw03
             AND nna02=l_nmw.nmw06
          IF STATUS THEN
             LET g_msg='check:',l_nmw.nmw01 ,' date:',l_nmw.nmw03,
                       ' no:',l_nmw.nmw06
#            CALL cl_err(g_msg,STATUS,1)   #No.FUN-660148
             CALL cl_err3("sel","nna_file",l_nmw.nmw01,l_nmw.nmw03,STATUS,"","",1) #No.FUN-660148
             CONTINUE FOREACH 
          END IF
          #no.5862(end)
          #No.FUN-780011  --Begin
          LET l_point = l_nna04 - l_nna05 + 1
          LET l_end   = l_nmw.nmw05[l_point,l_nna04]
          LET l_begin = l_nmw.nmw04[l_point,l_nna04]
          LET l_tot = (l_end - l_begin) + 1
          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nmd21
          IF l_nmd02 = sr.nmd02 THEN
             LET l_cnt1 = l_cnt1 - 1
          END IF
          LET i = l_nmd02[l_point,l_nna04] - sr.nmd02[l_point,l_nna04]
          FOR j = i+1 TO -1
              LET l_no = sr.nmd02[l_point,l_nna04]
              CALL r107_using(l_no,l_nna05,j) RETURNING l_no
              LET l_nmd02 = sr.nmd02[1,l_point-1],l_no
              LET sr1.* = sr.*
              LET sr1.nmd02 = l_nmd02
              LET sr1.type = '3'      #空號
              EXECUTE insert_prep USING l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
                      l_nmw.nmw05,l_nmw.nmw06,sr1.*,l_nma03,t_azi04,l_cnt1,
                      l_tot
          END FOR
          }
          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nmd21
          #-----END MOD-7B0046-----
          #OUTPUT TO REPORT anmr107_rep(l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
          #                             l_nmw.nmw05,l_nmw.nmw06,sr.*)
          EXECUTE insert_prep USING l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
                  #l_nmw.nmw05,l_nmw.nmw06,sr.*,l_nma03,t_azi04,l_cnt1,   #MOD-7B0046
                  l_nmw.nmw05,l_nmw.nmw06,sr.*,l_nma03,t_azi04,   #MOD-7B0046
                  l_tot
          #LET l_nmd02 = sr.nmd02   #MOD-7B0046
          #No.FUN-780011  --End
       END FOREACH
       #-----MOD-7B0046---------
       LET l_sql = "SELECT MAX(nmd02) FROM ",g_cr_db_str CLIPPED,
                    l_table CLIPPED,
                   " WHERE nmw04 = '",l_nmw.nmw04,"'"
       PREPARE r107_pre2 FROM l_sql
       DECLARE r107_curs4 CURSOR FOR r107_pre2
       OPEN r107_curs4
       FETCH r107_curs4 INTO max_nmd02
 
       FOR i = l_begin TO l_end
           LET l_nmd02[1,l_point-1] = l_nmw.nmw04[1,l_point-1] 
           LET l_nmd02[l_point,l_nna04] = r107_using2(i,l_nna04-l_point+1) 
           LET l_cnt = 0
           LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,
                        l_table CLIPPED,
                       " WHERE nmd02 = '",l_nmd02,"'"
           PREPARE r107_pre3 FROM l_sql
           DECLARE r107_curs5 CURSOR FOR r107_pre3
           OPEN r107_curs5
           FETCH r107_curs5 INTO l_cnt
 
           IF l_cnt = 0 AND l_nmd02 <= max_nmd02 THEN
              LET sr.type='3'
              LET sr.nmd02=l_nmd02
              EXECUTE insert_prep USING l_nmw.nmw01,l_nmw.nmw03,l_nmw.nmw04,
                      l_nmw.nmw05,l_nmw.nmw06,sr.*,l_nma03,t_azi04, 
                      l_tot
           END IF
       END FOR
       #-----END MOD-7B0046-----
     END FOREACH
 
     #No.FUN-780011  --Begin
     #FINISH REPORT anmr107_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmw01,nmw03')
             RETURNING g_str
     END IF
     CALL cl_prt_cs3('anmr107','anmr107',g_sql,g_str)
     #No.FUN-780011  --End  
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT anmr107_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,            #No.FUN-680107 VARCHAR(1)
#          sr            RECORD
#                        nmw01   LIKE nmw_file.nmw01,
#                        nmw03   LIKE nmw_file.nmw03,
#                        nmw04   LIKE nmw_file.nmw04,
#                        nmw05   LIKE nmw_file.nmw05,
#                        nmw06   LIKE nmw_file.nmw06,
#                        type    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
#                        nmd01   LIKE nmd_file.nmd01,
#                        nmd02   LIKE nmd_file.nmd02,
#                        nmd04   LIKE nmd_file.nmd04,
#                        nmd05   LIKE nmd_file.nmd05,
#                        nmd07   LIKE nmd_file.nmd07,
#                        nmd08   LIKE nmd_file.nmd08,
#                        nmd21   LIKE nmd_file.nmd21,
#                        nmd24   LIKE nmd_file.nmd24,
#                        nnz03   LIKE nnz_file.nnz03,
#                        nnzuser LIKE nnz_file.nnzuser
#                        END RECORD,
#          l_nma03       LIKE nma_file.nma03,
#          l_nna04       LIKE nna_file.nna04,
#          l_nna05       LIKE nna_file.nna05,
#          l_nmd02       LIKE nmd_file.nmd02,
#          l_no          LIKE nmd_file.nmd02,
#          l_point,l_begin,l_end      LIKE type_file.num10,   #No.FUN-680107 INTEGER
#          l_tot,l_cnt1,l_cnt2,l_cnt3 LIKE type_file.num10,   #No.FUN-680107 INTEGER
#          l_x           LIKE zaa_file.zaa08                  #No.FUN-680107 VARCHAR(10)
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#  ORDER BY sr.nmw01,sr.nmw03,sr.nmw04,sr.nmw05,sr.nmw06,sr.nmd02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.nmw06
#      LET l_tot  = 0
#      LET l_cnt1 = 0
#      LET l_cnt2 = 0
#      LET l_cnt3 = 0
#      SKIP TO TOP OF PAGE
#      SELECT nma03 INTO l_nma03 FROM nma_file WHERE nma01 = sr.nmw01
#      SELECT nna04,nna05 INTO l_nna04,l_nna05
#        FROM nna_file WHERE nna01=sr.nmw01
#                        AND nna021=sr.nmw03 AND nna02=sr.nmw06
#      LET l_point = l_nna04 - l_nna05 + 1
#      LET l_end   = sr.nmw05[l_point,l_nna04]
#      LET l_begin = sr.nmw04[l_point,l_nna04]
#      LET l_tot = (l_end - l_begin) + 1
##      LET l_nmd02 = sr.nmw04   #MOD-5A0283
#     LET l_nmd02 = ''   #MOD-5A0283
#      PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#            COLUMN g_c[32],sr.nmw01 CLIPPED,
#            COLUMN g_c[33],l_nma03 CLIPPED,
#            COLUMN g_c[35],g_x[18] CLIPPED,
#            COLUMN g_c[36],sr.nmw03
#      PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#            COLUMN g_c[32],sr.nmw04,
#            COLUMN g_c[33],sr.nmw05,
#            COLUMN g_c[35],g_x[19] CLIPPED,
#            COLUMN g_c[36],sr.nmw06 USING '<<'
#      SKIP 1 LINE
#
#   ON EVERY ROW
#
#      SELECT azi03,azi04,azi05
#        INTO t_azi03,t_azi04,t_azi05    #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.nmd21
##MOD-5A0283
#       IF l_nmd02 = sr.nmd02 THEN
#          LET l_cnt1 = l_cnt1 - 1
#       END IF
#       LET i = l_nmd02[l_point,l_nna04] - sr.nmd02[l_point,l_nna04]
#       FOR j = i+1 TO -1
#           LET l_no = sr.nmd02[l_point,l_nna04]
#           CALL r107_using(l_no,l_nna05,j) RETURNING l_no
#           LET l_nmd02 = sr.nmd02[1,l_point-1],l_no
#           PRINT l_nmd02,COLUMN 12,g_x[16] CLIPPED
#       END FOR
##     IF sr.nmd02 != l_nmd02 THEN
##        LET l_x = g_x[20] CLIPPED
##        PRINT l_nmd02,COLUMN 12,l_x CLIPPED
##     END IF
##     LET i = sr.nmd02[l_point,l_nna04] - l_nmd02[l_point,l_nna04]
##     FOR j = 1 TO i - 1
##         LET l_no = l_nmd02[l_point,l_nna04]
##         CALL r107_using(l_no,l_nna05) RETURNING l_no
##         LET l_nmd02 = l_nmd02[1,l_point-1],l_no
##         LET l_x = g_x[16] CLIPPED
##         PRINT l_nmd02,COLUMN 12,l_x CLIPPED
##     END FOR
##END MOD-5A0283
#      IF sr.type = '1' THEN
#         LET l_cnt1 = l_cnt1 + 1
#         PRINT COLUMN g_c[31],sr.nmd02,
#               COLUMN g_c[32],sr.nmd07,
#               COLUMN g_c[33],sr.nmd05,
#               COLUMN g_c[34],cl_numfor(sr.nmd04,34,t_azi04),  #NO.CHI-6A0004
#               COLUMN g_c[35],sr.nmd08,
#               COLUMN g_c[36],sr.nmd24,
#               COLUMN g_c[37],sr.nmd01
#      ELSE
#         LET l_cnt2 = l_cnt2 + 1
#         LET l_x = g_x[13] CLIPPED
#         PRINT COLUMN g_c[31],sr.nmd02,
#               COLUMN g_c[32],l_x CLIPPED,
#               COLUMN g_c[33],sr.nnz03 CLIPPED,
#               COLUMN g_c[34],sr.nnzuser
#      END IF
##MOD-5A0283
##      LET l_no = sr.nmd02[l_point,l_nna04]
##      CALL r107_using(l_no,l_nna05) RETURNING l_no
##      LET l_nmd02 = sr.nmd02[1,l_point-1],l_no
#      LET l_nmd02 = sr.nmd02
##END MOD-5A0283
#
#   AFTER GROUP OF sr.nmw06
#      SKIP 1 LINE
#      LET l_cnt3 = l_tot - l_cnt1 - l_cnt2
#      PRINT COLUMN g_c[31],g_x[11] CLIPPED,
##            COLUMN g_c[32],l_tot USING '######&',   #MOD-5A0283
#           COLUMN g_c[32],l_tot USING '#######&',   #MOD-5A0283
#            COLUMN g_c[33],g_x[15] CLIPPED
#      PRINT COLUMN g_c[31],g_x[12] CLIPPED,
##            COLUMN g_c[32],l_cnt1 USING '######&',  #MOD-5A0283
#           COLUMN g_c[32],l_cnt1 USING '#######&',  #MOD-5A0283
#            COLUMN g_c[33],g_x[15] CLIPPED
#      PRINT COLUMN g_c[31],g_x[13] CLIPPED,
##            COLUMN g_c[32],l_cnt2 USING '######&',  #MOD-5A0283
#           COLUMN g_c[32],l_cnt2 USING '#######&',  #MOD-5A0283
#            COLUMN g_c[33],g_x[15] CLIPPED
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
##            COLUMN g_c[32],l_cnt3 USING '######&',  #MOD-5A0283
#           COLUMN g_c[32],l_cnt3 USING '#######&',  #MOD-5A0283
#            COLUMN g_c[33],g_x[15] CLIPPED
##      PRINT COLUMN g_c[31],'------------------------------'  #No.TQC-5B0047  #No.TQC-6A0110#
#      #PRINT '------------------------------'  #No.TQC-5B0047  #No.TQC-6A0110
#
#   ON LAST ROW
#      #-----TQC-6B0189---------
#      IF  g_zz05 = 'Y' THEN
#          CALL cl_wcchp(tm.wc,'nmw01,nmw03')
#               RETURNING tm.wc
#          PRINT g_dash
#          CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      #-----END TQC-6B0189-----
#      PRINT g_dash[1,g_len] CLIPPED
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780011  --End  
 
FUNCTION r107_using(p_no,p_i,i)
  DEFINE p_i   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
         p_no  LIKE cre_file.cre08,    #No.FUN-680107 VARCHAR(10)
         i     LIKE type_file.num5     #MOD-5A0283  #No.FUN-680107 SMALLINT
 
  CASE p_i
#MOD-5A0283
#  WHEN  1 LET p_no = p_no + 1 USING '&'
#  WHEN  2 LET p_no = p_no + 1 USING '&&'
#  WHEN  3 LET p_no = p_no + 1 USING '&&&'
#  WHEN  4 LET p_no = p_no + 1 USING '&&&&'
#  WHEN  5 LET p_no = p_no + 1 USING '&&&&&'
#  WHEN  6 LET p_no = p_no + 1 USING '&&&&&&'
#  WHEN  7 LET p_no = p_no + 1 USING '&&&&&&&'
#  WHEN  8 LET p_no = p_no + 1 USING '&&&&&&&&'
#  WHEN  9 LET p_no = p_no + 1 USING '&&&&&&&&&'
#  WHEN 10 LET p_no = p_no + 1 USING '&&&&&&&&&&'
   WHEN  1 LET p_no = p_no + i USING '&'
   WHEN  2 LET p_no = p_no + i USING '&&'
   WHEN  3 LET p_no = p_no + i USING '&&&'
   WHEN  4 LET p_no = p_no + i USING '&&&&'
   WHEN  5 LET p_no = p_no + i USING '&&&&&'
   WHEN  6 LET p_no = p_no + i USING '&&&&&&'
   WHEN  7 LET p_no = p_no + i USING '&&&&&&&'
   WHEN  8 LET p_no = p_no + i USING '&&&&&&&&'
   WHEN  9 LET p_no = p_no + i USING '&&&&&&&&&'
   WHEN 10 LET p_no = p_no + i USING '&&&&&&&&&&'
#END MOD-5A0283
  END CASE
  RETURN p_no
END FUNCTION
 
#-----MOD-7B0046---------
FUNCTION r107_using2(p_no,p_i)
  DEFINE p_i   LIKE type_file.num5,    
         p_no  LIKE cre_file.cre08     
 
  CASE p_i
   WHEN  1 LET p_no = p_no USING '&'
   WHEN  2 LET p_no = p_no USING '&&'
   WHEN  3 LET p_no = p_no USING '&&&'
   WHEN  4 LET p_no = p_no USING '&&&&'
   WHEN  5 LET p_no = p_no USING '&&&&&'
   WHEN  6 LET p_no = p_no USING '&&&&&&'
   WHEN  7 LET p_no = p_no USING '&&&&&&&'
   WHEN  8 LET p_no = p_no USING '&&&&&&&&'
   WHEN  9 LET p_no = p_no USING '&&&&&&&&&'
   WHEN 10 LET p_no = p_no USING '&&&&&&&&&&'
   WHEN 11 LET p_no = p_no USING '&&&&&&&&&&&'
   WHEN 12 LET p_no = p_no USING '&&&&&&&&&&&&'
   WHEN 13 LET p_no = p_no USING '&&&&&&&&&&&&&'
   WHEN 14 LET p_no = p_no USING '&&&&&&&&&&&&&&'
   WHEN 15 LET p_no = p_no USING '&&&&&&&&&&&&&&&'
  END CASE
  RETURN p_no
END FUNCTION
#-----END MOD-7B0046-----
