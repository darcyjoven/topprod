# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmr703.4gl
# Descriptions...: 廠商收貨狀況查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/11/13 By MAY
# Modify.........: 93/11/08 By Apple
# Modify.........: No.FUN-4C0095 04/12/28 By Mandy 報表轉XML
# Modify.........: No.FUN-550018 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.TQC-5B0212 05/12/27 By kevin 結束位置調整
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-7A0112 07/10/19 By claire 變數清空避免保留舊值
# Modify.........: No.FUN-7C0034 07/12/27 By dxfwo   CR報表的制作 
# Modify.........: No.MOD-980181 09/08/22 By Dido 排除 AXM 與 AOM 資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C60087 12/06/11 By Elise 查詢條件後需再重新給予 INPUT 欄位變數
# Modify.........: No:TQC-C60102 12/06/12 By yangtt pmc01欄位添加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
  	       #wc   VARCHAR(500),   #TQC-630166 mark
  		wc  	STRING,      #TQC-630166
                b_date  LIKE type_file.dat,     #No.FUN-680136 DATE
                e_date  LIKE type_file.dat,     #No.FUN-680136 DATE
                a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                b       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                t       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total        LIKE tlf_file.tlf18    #No.FUN-680136 DECIMAL(13,3)
   DEFINE g_i            LIKE type_file.num5    #count/index for any purpose   #No.FUN-680136 SMALLINT
   DEFINE l_table        STRING                 #No.FUN-7C0034                                                              
   DEFINE g_sql          STRING                 #No.FUN-7C0034                                                             
   DEFINE g_str          STRING                 #No.FUN-7C0034
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   #No.FUN-7C0034---Begin 
      LET g_sql = " pmc01.pmc_file.pmc01,",
                  " pmc03.pmc_file.pmc03,",
                  " l_print31.type_file.chr1,",
                  " tlf06.tlf_file.tlf06,",
                  " tlf01.tlf_file.tlf01,",
                  " l_ima02.ima_file.ima02,",
                  " l_ima021.ima_file.ima021,",
                  " l_print36.tlf_file.tlf10,",
                  " l_print37.tlf_file.tlf10,",
                  " l_print38.tlf_file.tlf10,",
                  " tlf13.tlf_file.tlf13,",
                  " tlf036.tlf_file.tlf036,",
                  " tlf037.tlf_file.tlf037,",
                  " tlf026.tlf_file.tlf026,",
                  " tlf027.tlf_file.tlf027,",
                  " l_no.oea_file.oea01 "
      LET l_table = cl_prt_temptable('apmr703',g_sql) CLIPPED                                                                          
      IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  
      PREPARE insert_prep FROM g_sql                                                                                                   
      IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
      END IF
   #No.FUN-7C0034---End  
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b_date = ARG_VAL(8)
   LET tm.e_date = ARG_VAL(9)
   LET tm.a   = ARG_VAL(10)
   LET tm.b   = ARG_VAL(11)
#-----------------No.TQC-610085 modify
   LET tm.t   = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r703_tm(0,0)		# Input print condition
      ELSE CALL apmr703()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r703_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 33
 
   OPEN WINDOW r703_w AT p_row,p_col WITH FORM "apm/42f/apmr703"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.e_date = g_today
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.t    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.b_date,tm.e_date,tm.a,tm.b,tm.t,tm.more
               # Condition
   CONSTRUCT BY NAME tm.wc ON pmc01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

    #TQC-C60102-----add----str--
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(pmc01)
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_pmc01"
          LET g_qryparam.state = "c"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO pmc01
          NEXT FIELD pmc01
        END CASE
    #TQC-C60102-----add----end--
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r703_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.b_date,tm.e_date,tm.a,tm.b,tm.t,tm.more
               # Condition
   INPUT BY NAME tm.b_date,tm.e_date,tm.a,tm.b,tm.t,tm.more
               WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
            #MOD-C60087---S---
             LET tm.b_date = GET_FLDBUF(b_date)
             LET tm.e_date = GET_FLDBUF(e_date)
             LET tm.a = GET_FLDBUF(a)
             LET tm.b = GET_FLDBUF(b)
             LET tm.t = GET_FLDBUF(t)
            #MOD-C60087---E---
         #No.FUN-580031 ---end---
 
      AFTER FIELD e_date
         IF tm.e_date < tm.b_date
         THEN NEXT FIELD e_date
         END IF
      AFTER FIELD a
         IF tm.a    NOT MATCHES "[YN]" OR tm.a IS NULL  THEN
                NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b    NOT MATCHES "[YN]" OR tm.b IS NULL  THEN
                NEXT FIELD b
         END IF
      AFTER FIELD t
         IF tm.t    NOT MATCHES "[YN]" OR tm.t IS NULL  THEN
             NEXT FIELD t
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL  THEN
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
      LET INT_FLAG = 0
      CLOSE WINDOW r703_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='apmr703'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr703','9031',1)
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
                         " '",tm.b_date CLIPPED,"'",         #No.TQC-610085 add
                         " '",tm.e_date CLIPPED,"'",         #No.TQC-610085 add
                         " '",tm.a  CLIPPED,"'",
                         " '",tm.b  CLIPPED,"'",
                         " '",tm.t  CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'"  ,         #TQC-610085 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr703',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r703_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr703()
   ERROR ""
END WHILE
   CLOSE WINDOW r703_w
END FUNCTION
 
FUNCTION apmr703()
   DEFINE l_name	LIKE type_file.chr20, 		   # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	     # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sw          LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)	# Used time for running the job
         #l_sql  	LIKE type_file.chr1000,		   # RDSQL STATEMENT  #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql  	STRING,	                     # RDSQL STATEMENT  #TQC-630166 
         #l_wc   	LIKE type_file.chr1000,	     # RDSQL STATEMENT  #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_wc   	STRING,	                     # RDSQL STATEMENT  #TQC-630166
          l_za05	LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(40)
   DEFINE l_ima02       LIKE ima_file.ima02    #FUN-4C0095
   DEFINE l_ima021      LIKE ima_file.ima021   #FUN-4C0095
   DEFINE l_print31	    LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1) #FUN-4C0095
   DEFINE l_print36     LIKE tlf_file.tlf10    #FUN-4C0095
   DEFINE l_print37     LIKE tlf_file.tlf10    #FUN-4C0095
   DEFINE l_print38     LIKE tlf_file.tlf10    #FUN-4C0095
   DEFINE l_last_sw	    LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
          l_tlf13       LIKE apo_file.apo02,   #No.FUN-680136 VARCHAR(4)
          l_no          LIKE oea_file.oea01,          
          sr               RECORD
                           pmc01 LIKE pmc_file.pmc01,   #廠商編號
                           pmc03 LIKE pmc_file.pmc03,   #廠商簡稱
                           tlf01 LIKE tlf_file.tlf01,   #異動料件
                           tlf02 LIKE tlf_file.tlf02,   #異動料件
                           tlf03 LIKE tlf_file.tlf03,   #來源狀況	
                           tlf06 LIKE tlf_file.tlf06,   #單據日期
                           tlf10 LIKE tlf_file.tlf10,   #異動數量
                           tlf13 LIKE tlf_file.tlf13,   #異動命令代號
                           tlf026 LIKE tlf_file.tlf026, #來源單據編號
                           tlf027 LIKE tlf_file.tlf027, #來源項次
                           tlf036 LIKE tlf_file.tlf036, #目的單據編號
                           tlf037 LIKE tlf_file.tlf037  #目的項次
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004------Begin----------------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-----End-----------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
     #End:FUN-980030
 
#BugNo:6184
     LET l_sql = " SELECT  ",
                 "       pmc01,pmc03,tlf01,tlf02,tlf03,",
                 "       tlf06,tlf10,tlf13,tlf026,tlf027,tlf036,tlf037 ",
                 "   FROM pmc_file,tlf_file",
                 "  WHERE  pmc01 = tlf19 ",
                 "    AND ",tm.wc CLIPPED ,
                 "    AND (tlf03 BETWEEN  10 AND  50 ) ",
                 "    AND tlf13 NOT LIKE 'axm%' AND tlf13 NOT LIKE 'aom%' "	#MOD-980181
     IF tm.a  = 'N' THEN  #採購收貨
         LET l_sql = l_sql clipped, " AND tlf03 != 50 "
     END IF
     IF tm.b = 'N' THEN  #退貨是否列印
         LET l_sql = l_sql clipped, " AND (tlf03 NOT BETWEEN 30 AND 32 ) "
     END IF
#BugNo:6184
     #--->日期範圍限制
     IF tm.b_date IS NOT NULL AND tm.b_date != ' '
     THEN LET l_sql = l_sql clipped," AND tlf06 >= '",tm.b_date,"'"
     END IF
     IF tm.e_date IS NOT NULL AND tm.e_date != ' '
     THEN LET l_sql = l_sql clipped," AND tlf06 <= '",tm.e_date,"'"
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY tlf06 "
     PREPARE r703_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
            
     END IF
     DECLARE r703_cs1 CURSOR FOR r703_prepare1
 
#    CALL cl_outnam('apmr703') RETURNING l_name         #No.FUN-7C0034
#    START REPORT r703_rep TO l_name                    #No.FUN-7C0034
     CALL cl_del_data(l_table)                          #No.FUN-7C0034
     
     FOREACH r703_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-7C0034---Begin       
        LET l_print31 = ' '
        LET l_print36 = NULL
        LET l_print37 = NULL
        LET l_print38 = NULL
       #MOD-7A0112-end-add
     IF sr.tlf02 = 18 THEN
        LET l_print31 = '*'
     ELSE
        LET l_print31 = ' '
     END IF
     CASE
         WHEN sr.tlf03 = 20
                 LET l_print36 = sr.tlf10
                 LET l_print37 = NULL
                 LET l_print38 = NULL
         WHEN sr.tlf03 = 30 OR sr.tlf03 = 31 OR sr.tlf03 = 32
                 LET l_print36 = NULL
                 LET l_print37 = sr.tlf10
                 LET l_print38 = NULL
         WHEN sr.tlf03 = 50 OR sr.tlf03 = 55 OR sr.tlf03 = 56 OR sr.tlf03 = 57
                 LET l_print36 = NULL
                 LET l_print37 = NULL
                 LET l_print38 = sr.tlf10
         OTHERWISE EXIT CASE
     END CASE
     IF sr.tlf13 = 'apmt150' OR sr.tlf13 = 'apmt230' THEN
        SELECT rvb04,rvb03 INTO g_tlf.tlf036,g_tlf.tlf037
         FROM rvb_file where rvb01 = sr.tlf036
                         AND rvb02 = sr.tlf037
     END IF
     IF sr.tlf13 = 'asft6001' OR sr.tlf13 = 'apmt1101' THEN
        SELECT rvb22 INTO l_no FROM rvb_file WHERE rvb01=sr.tlf036
                                               AND rvb02=sr.tlf037
     END IF
     IF STATUS THEN LET l_no='' END IF
     SELECT ima02,ima021
       INTO l_ima02,l_ima021
       FROM ima_file
      WHERE ima01 = sr.tlf01
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF       
#      OUTPUT TO REPORT r703_rep(sr.*)
      IF cl_null(sr.tlf03)  THEN LET sr.tlf03 = 0 END IF 
      IF cl_null(l_print36)  THEN LET l_print36 = 0 END IF 
      IF cl_null(l_print37)  THEN LET l_print37 = 0 END IF 
      IF cl_null(l_print38)  THEN LET l_print38 = 0 END IF 
     EXECUTE insert_prep USING sr.pmc01,sr.pmc03,l_print31,sr.tlf06,sr.tlf01,
                               l_ima02,l_ima021,l_print36,l_print37,l_print38,sr.tlf13,
                               sr.tlf036,sr.tlf037,sr.tlf026,sr.tlf027,l_no 
    END FOREACH
#    FINISH REPORT r703_rep
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'pmc01')         
            RETURNING tm.wc                                                     
       LET g_str = tm.wc                                                        
    END IF                                                                                                                          
     LET g_str = tm.wc,";",tm.t                                                                
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('apmr703','apmr703',l_sql,g_str)
#No.FUN-7C0034---End
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)#No.FUN-7C0034
END FUNCTION
 
#REPORT r703_rep(sr)
#   DEFINE l_ima02       LIKE ima_file.ima02    #FUN-4C0095
#   DEFINE l_ima021      LIKE ima_file.ima021   #FUN-4C0095
#   DEFINE l_print31	LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1) #FUN-4C0095
#   DEFINE l_print36     LIKE tlf_file.tlf10    #FUN-4C0095
#   DEFINE l_print37     LIKE tlf_file.tlf10    #FUN-4C0095
#   DEFINE l_print38     LIKE tlf_file.tlf10    #FUN-4C0095
#   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
#          l_tlf13       LIKE apo_file.apo02,   #No.FUN-680136 VARCHAR(4)
#          l_no          LIKE oea_file.oea01,   #No.FUN-680136 VARCHAR(16) #FUN-550018
#          sr               RECORD
#                           pmc01 LIKE pmc_file.pmc01,   #廠商編號
#                           pmc03 LIKE pmc_file.pmc03,   #廠商簡稱
#                           tlf01 LIKE tlf_file.tlf01,   #異動料件
#                           tlf02 LIKE tlf_file.tlf02,   #來源狀況
#                           tlf03 LIKE tlf_file.tlf03,   #目地狀況	
#                           tlf06 LIKE tlf_file.tlf06,   #單據日期
#                           tlf10 LIKE tlf_file.tlf10,   #異動數量
#                           tlf13 LIKE tlf_file.tlf13,   #異動命令代號
#                           tlf026 LIKE tlf_file.tlf026, #來源單據編號
#                           tlf027 LIKE tlf_file.tlf027, #來源項次
#                           tlf036 LIKE tlf_file.tlf036, #目的單據編號
#                           tlf037 LIKE tlf_file.tlf037   #目的項次
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pmc01,sr.tlf06
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.pmc01
#      PRINT COLUMN 01,g_x[12] CLIPPED,sr.pmc03
#      PRINT ' '
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#BEFORE GROUP  OF sr.pmc01
#     IF tm.t = 'Y' THEN
#           SKIP TO TOP OF PAGE
#     END IF
#
#ON EVERY ROW
#       #MOD-7A0112-beign-add
#        LET l_print31 = ' '
#        LET l_print36 = NULL
#        LET l_print37 = NULL
#        LET l_print38 = NULL
#       #MOD-7A0112-end-add
#     IF sr.tlf02 = 18 THEN
#        LET l_print31 = '*'
#     ELSE
#        LET l_print31 = ' '
#     END IF
#     CASE
#         WHEN sr.tlf03 = 20
#                 LET l_print36 = sr.tlf10
#                 LET l_print37 = NULL
#                 LET l_print38 = NULL
#         WHEN sr.tlf03 = 30 OR sr.tlf03 = 31 OR sr.tlf03 = 32
#                 LET l_print36 = NULL
#                 LET l_print37 = sr.tlf10
#                 LET l_print38 = NULL
#         WHEN sr.tlf03 = 50 OR sr.tlf03 = 55 OR sr.tlf03 = 56 OR sr.tlf03 = 57
#                 LET l_print36 = NULL
#                 LET l_print37 = NULL
#                 LET l_print38 = sr.tlf10
#         OTHERWISE EXIT CASE
#     END CASE
#     IF sr.tlf13 = 'apmt150' OR sr.tlf13 = 'apmt230' THEN
#        SELECT rvb04,rvb03 INTO g_tlf.tlf036,g_tlf.tlf037
#         FROM rvb_file where rvb01 = sr.tlf036
#                         AND rvb02 = sr.tlf037
#     END IF
#     IF sr.tlf13 = 'asft6001' OR sr.tlf13 = 'apmt1101' THEN
#        SELECT rvb22 INTO l_no FROM rvb_file WHERE rvb01=sr.tlf036
#                                               AND rvb02=sr.tlf037
#     END IF
#     IF STATUS THEN LET l_no='' END IF
#     SELECT ima02,ima021
#       INTO l_ima02,l_ima021
#       FROM ima_file
#      WHERE ima01 = sr.tlf01
#      IF SQLCA.sqlcode THEN
#          LET l_ima02 = NULL
#          LET l_ima021 = NULL
#      END IF
#      PRINT  COLUMN g_c[31],l_print31,
#             COLUMN g_c[32],sr.tlf06,
#             COLUMN g_c[33],sr.tlf01,
#             COLUMN g_c[34],l_ima02,
#             COLUMN g_c[35],l_ima021,
#             COLUMN g_c[36],l_print36,
#             COLUMN g_c[37],l_print37,
#             COLUMN g_c[38],l_print38,
#             COLUMN g_c[39],sr.tlf13,
#             COLUMN g_c[40],sr.tlf036,
#             COLUMN g_c[41],sr.tlf037 USING '#######&', #No.TQC-5B0212
#             COLUMN g_c[42],sr.tlf026,
#             COLUMN g_c[43],sr.tlf027 USING '#######&' CLIPPED , #No.TQC-5B0212
#             COLUMN g_c[44],l_no CLIPPED
#
#ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN
#              PRINT g_dash
##             IF tm.wc[001,070] > ' ' THEN			# for 80
##	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
## 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
## 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
## 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             #TQC-630166
#             #IF tm.wc[001,120] > ' ' THEN			# for 132
# 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             #IF tm.wc[121,240] > ' ' THEN
# 	     #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             #IF tm.wc[241,300] > ' ' THEN
#             #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
#      END IF
#       PRINT g_dash
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9) , g_x[7] CLIPPED #No.TQC-5B0212
#
#PAGE TRAILER
#    IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9) , g_x[6] CLIPPED #No.TQC-5B0212
#        ELSE SKIP 2 LINES
#     END IF
#END REPORT
##Patch....NO.TQC-610036 <001> #
