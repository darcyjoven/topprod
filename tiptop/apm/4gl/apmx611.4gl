# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: apmx611.4gl
# Desc/riptions...: 退貨明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/11/04 By MAY
# Modify.........: No.FUN-4B0024 04/11/03 By Smapmin 料號開窗
# Modify.........: No.FUN-4C0095 05/01/04 By Mandy 報表轉XML
# Modify.........: No.MOD-530059 05/03/11 By ching fix INPUT order
# Modify.........: No.MOD-530173 05/03/21 By Mandy apmx611畫面上已拿掉tm.y 所以INPUT 段也要拿掉
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-580004 05/08/08 By day  報表加雙單位參數
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0095 06/11/15 By Ray 最后頁的橫線未緊跟數據
# Modify.........: No.MOD-710148 07/01/24 By jamie 退貨理由關連azf時,應改為azf02 = "2" 
# Modify.........: No.FUN-830001 08/03/03 By zhaijie報表格式改為CR輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.FUN-CB0001 12/11/06 By yangtt CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By wangrr XtraGrid報表畫面檔上小計條件去除，4gl中并去除grup_sum_field
# Modify.........: No:FUN-D40128 13/05/07 By wangrr 報表增加倉庫名稱,庫位名稱欄位
# Modify.........: No:FUN-D40129 13/05/24 By yangtt 廠商編號開窗【廠商名稱】
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004-begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004-end
 
  DEFINE tm  RECORD				# Print condition RECORD
                #wc   VARCHAR(500),		# Where condition        #TQC-630166 mark
                 wc  	STRING,	 	        # Where condition        #TQC-630166
                 bdate  LIKE type_file.chr14,   #LIKE cqw_file.cqw04,    #No.FUN-680136 VARCHAR(13)   #TQC-B90211
                 a    	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)		
                 b    	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                 h    	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                 s    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)   # Order by sequence
                 t    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)   # Eject sw
                #u    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)   # print gkf_file detail(Y/N) #FUN-D30070 mark
                 y      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                 more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)	 # Input more condition(Y/N)
              END RECORD,
          g_rvu01       LIKE rvu_file.rvu01,
          g_aza17       LIKE aza_file.aza17,    # 本國幣別
          g_total1      LIKE rvv_file.rvv17     #FUN-4C0095
  DEFINE  g_i           LIKE type_file.num5     #count/index for any purpose #No.FUN-680136 SMALLINT
  DEFINE  g_sma115      LIKE sma_file.sma115    #No.FUN-580004
#NO.FUN-830001----------------start----------
  DEFINE  l_table       STRING
  DEFINE  g_sql         STRING
  DEFINE  g_str         STRING
#NO.FUN-830001--------------end-------
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
#NO.FUN-830001---------------START-------------
   LET g_sql = "rvu01.rvu_file.rvu01,",
               "rvu02.rvu_file.rvu02,",
               "rvu03.rvu_file.rvu03,",
               "rvu04.rvu_file.rvu04,",
               "rvu05.rvu_file.rvu05,",
               "rvu06.rvu_file.rvu06,",
               "rvu09.rvu_file.rvu09,",
               "rvv02.rvv_file.rvv02,",
               "rvv05.rvv_file.rvv05,",
               "rvv17.rvv_file.rvv17,",
               "rvv26.rvv_file.rvv26,",
               "rvv18.rvv_file.rvv18,",
               "rvv36.rvv_file.rvv36,",
               "rvv37.rvv_file.rvv37,",
               "rvv31.rvv_file.rvv31,",
               "rvv031.rvv_file.rvv031,",
               "rvv32.rvv_file.rvv32,",
               "rvv33.rvv_file.rvv33,",
               "rvv34.rvv_file.rvv34,",
               "rvv35.rvv_file.rvv35,",
               "rvv80.rvv_file.rvv80,",
               "rvv82.rvv_file.rvv82,",
               "rvv83.rvv_file.rvv83,",
               "rvv85.rvv_file.rvv85,",
               "l_azf03.azf_file.azf03,",
               "l_ima021.ima_file.ima021,",
               "l_s.type_file.chr1000,",
               "azi05.azi_file.azi05,",    #FUN-CB0001
               "l_num1.type_file.num5"      #FUN-CB0001
              ,",imd02.imd_file.imd02,",  #FUN-D40128
               "ime03.ime_file.ime03"     #FUN-D40128
   LET l_table = cl_prt_temptable('apmx611',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?)"    #FUN-CB0001  2? #FUN-D40128 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
#NO.FUN-830001------------------END-----------
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.h  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.t  = ARG_VAL(12)
  #LET tm.u  = ARG_VAL(13) #FUN-D30070 mark
#--------------No.TQC-610085 modify
  #LET tm.y  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13) #FUN-D30070 mod 14->13
   LET g_rep_clas = ARG_VAL(14) #FUN-D30070 mod 15->14
   LET g_template = ARG_VAL(15) #FUN-D30070 mod 16->15
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078 #FUN-D30070 mod 17->16
   #No.FUN-570264 ---end---
#--------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL x611_tm(0,0)		# Input print condition
      ELSE CALL apmx611()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION x611_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 16
 
   OPEN WINDOW x611_w AT p_row,p_col WITH FORM "apm/42f/apmx611"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.h    = '3'
   LET tm.s    = '123'
  #LET tm.u    = ' '  #FUN-D30070 mark 
   LET tm.t    = ' '
   LET tm.y    = 'N'
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
  #LET tm2.u1   = tm.u[1,1] #FUN-D30070 mark
  #LET tm2.u2   = tm.u[2,2] #FUN-D30070 mark
  #LET tm2.u3   = tm.u[3,3] #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF #FUN-D30070 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF #FUN-D30070 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF #FUN-D30070 mark
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rvu01,rvu02,rvu03,rvu04,rvv36
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION controlp    #FUN-4B0024
         CASE
            WHEN INFIELD(rvu01)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_rvu2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu01
               NEXT FIELD rvu01
            WHEN INFIELD(rvu02)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               #LET g_qryparam.form ="q_rvu_1" #FUN-D40128 mark
               LET g_qryparam.form ="q_rvu3"   #FUN-D40128
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu02
               NEXT FIELD rvu02
            #FUN-CB0001-----add---str--
            WHEN INFIELD(rvu04)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               #LET g_qryparam.form ="q_rvu3" #FUN-D40128 mark
               LET g_qryparam.form ="q_rvu_2" #FUN-D40128
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu04
               NEXT FIELD rvu04
            #FUN-CB0001-----add---end--
            WHEN INFIELD(rvv36)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_rvv3"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvv36
               NEXT FIELD rvv36
         END CASE
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW x611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
  #DISPLAY BY NAME tm.a,tm.b,tm.h,tm.s,tm.u,tm.t,tm.y,tm.more
                   # Condition
#UI
    #MOD-530059
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3, #FUN-D30070 mark
                 tm.a,tm.b,tm.h,
                #tm.y,tm.more
                  tm.more #MOD-530173
                WITHOUT DEFAULTS
   #--
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[123]" OR cl_null(tm.a)
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES "[123]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
      BEFORE FIELD h
         IF tm.a='2' THEN NEXT FIELD NEXT END IF
      AFTER FIELD h
         IF tm.h NOT MATCHES "[123]" OR cl_null(tm.h)
            THEN NEXT FIELD h
         END IF
     # AFTER FIELD y #MOD-530173
    #    IF tm.y NOT MATCHES "[YN]" OR cl_null(tm.y)
    #       THEN NEXT FIELD y
    #    END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3 #FUN-D30070 mark
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
      LET INT_FLAG = 0 CLOSE WINDOW x611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmx611'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmx611','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                        #" '",tm.u CLIPPED,"'", #FUN-D30070 mark
                        # " '",tm.y CLIPPED,"'",     #MOD-530173
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmx611',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW x611_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmx611()
   ERROR ""
END WHILE
   CLOSE WINDOW x611_w
END FUNCTION
 
FUNCTION apmx611()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,		                # RDSQL STATEMENT   #TQC-630166
          l_chr		LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,         #No.FUN-680136 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE type_file.chr20,       #No.FUN-680136 VARCHAR(20) 
          sr               RECORD order1 LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
                                  order2 LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
                                  order3 LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
                                  rvu01 LIKE rvu_file.rvu01,	# 單號
                                  rvu02 LIKE rvu_file.rvu02, 	# 性質
                                  rvu03 LIKE rvu_file.rvu03, 	# 更動序號
                                  rvu04 LIKE rvu_file.rvu04, 	# 廠商編號
                                  rvu05 LIKE rvu_file.rvu05, 	# 廠商簡稱
                                  rvu06 LIKE rvu_file.rvu06,	# 廠商編號
                                  rvu09 LIKE rvu_file.rvu09,	# 取回日期
                                  rvv02 LIKE rvv_file.rvv02,    # 項次
                                  rvv05 LIKE rvv_file.rvv05,    # 驗收項次
                                  rvv17 LIKE rvv_file.rvv17,    # 數量
                                  rvv26 LIKE rvv_file.rvv26,    # 退貨理由
                                  rvv18 LIKE rvv_file.rvv18,    # 工單單號
                                  rvv36 LIKE rvv_file.rvv36,    # 採購單號
                                  rvv37 LIKE rvv_file.rvv37,    # 採購項次
                                  rvv31 LIKE rvv_file.rvv31,    # 料件編號
                                  rvv031 LIKE rvv_file.rvv031,  # 品名
                                  rvv32 LIKE rvv_file.rvv32,    # 倉庫
                                  rvv33 LIKE rvv_file.rvv33,    # 儲位
                                  rvv34 LIKE rvv_file.rvv34,    # 批號
                                  rvv35 LIKE rvv_file.rvv35,    # 單位
                                  #No.FUN-580004-begin
                                  rvv80 LIKE rvv_file.rvv80,
                                  rvv82 LIKE rvv_file.rvv82,
                                  rvv83 LIKE rvv_file.rvv83,
                                  rvv85 LIKE rvv_file.rvv85
                                  #No.FUN-580004-end
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5              #No.FUN-580004  #No.FUN-680136 SMALLINT
     DEFINE i                  LIKE type_file.num5              #No.FUN-580004  #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02              #No.FUN-580004
#NO.FUN-830001----------------start---------------
     DEFINE l_azf03       LIKE azf_file.azf03
     DEFINE l_s           LIKE type_file.chr1000 
     DEFINE l_ima906      LIKE ima_file.ima906
     DEFINE l_rvv85       STRING
     DEFINE l_rvv82       STRING
     DEFINE l_ima021      LIKE ima_file.ima021
     DEFINE swth          LIKE type_file.chr1
     DEFINE l_str         STRING    #FUN-CB0001 
     DEFINE l_num         LIKE type_file.num5    #FUN-CB0001 
     DEFINE l_imd02       LIKE imd_file.imd02    #FUN-D40128
     DEFINE l_ime03       LIKE ime_file.ime03    #FUN-D40128
     
     CALL cl_del_data(l_table)
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='apmx611'
#NO.FUN-830001----------------end---------------
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115 INTO g_sma115 FROM sma_file   #No.FUN-580004
#No.CHI-6A0004--------Begin----------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-----End------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rvuuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rvugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rvugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "   rvu01,  rvu02,  rvu03,  rvu04,  rvu05,  rvu06, rvu09,",
                 "   rvv02,  rvv05,  rvv17,  rvv26,  rvv18,  rvv36,  rvv37, ",
                 "   rvv31,  rvv031, rvv32,  rvv33,  rvv34,  rvv35, ",
                 "   rvv80,  rvv82 , rvv83,  rvv85 ",  #No.FUN-580004
                 " FROM rvu_file,rvv_file ",
                 " WHERE rvu01 = rvv01 AND rvuconf !='X' " ,
                 " AND ",tm.wc
    IF tm.a ='1' THEN
       LET l_sql = l_sql CLIPPED, " AND rvu00 = '2' "
    END IF
    IF tm.a ='2' THEN
       LET l_sql = l_sql CLIPPED, " AND rvu00 = '3' "
    END IF
    IF tm.a ='3' THEN
       LET l_sql = l_sql CLIPPED, " AND rvu00 != '1' "
    END IF
    IF tm.b ='1' THEN
       LET l_sql = l_sql CLIPPED, " AND rvuconf = 'Y' "
    END IF
    IF tm.b ='2' THEN
       LET l_sql = l_sql CLIPPED, " AND rvuconf = 'N' "
    END IF
    IF tm.a!='2' AND tm.h ='1' THEN
       LET l_sql = l_sql CLIPPED, " AND (rvu09 IS NOT NULL) "
    END IF
    IF tm.a!='2' AND tm.h ='2' THEN
       LET l_sql = l_sql CLIPPED, " AND (rvu09 IS NULL) "
    END IF
     LET l_sql = l_sql CLIPPED," ORDER BY rvu01  "
     LET  g_total1 = 0
     PREPARE x611_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE x611_cs1 CURSOR FOR x611_prepare1
#     LET l_name = 'apmx611.out'                           #NO.FUN-830001
#     CALL cl_outnam('apmx611') RETURNING l_name           #NO.FUN-830001
#No.FUN-580004-begin
     IF g_sma115 = "Y"  THEN  #是否顯示單位注解
#            LET g_zaa[52].zaa06 = "N"                     #NO.FUN-830001
            LET l_name = 'apmx611_1'                       #NO.FUN-830001
     ELSE
#            LET g_zaa[52].zaa06 = "Y"                     #NO.FUN-830001
            LET l_name = 'apmx611'                         #NO.FUN-830001
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580004-end
 
#     START REPORT x611_rep TO l_name                      #NO.FUN-830001
 
     LET g_pageno = 0
     INITIALIZE g_rvu01 TO NULL
 
#NO.FUN-830001------------start------------
      IF cl_null(g_rvu01) OR g_rvu01!=sr.rvu01 THEN
          LET swth = 'Y'
      ELSE
          LET swth='N'
      END IF
      IF tm.a='2' THEN
          LET sr.rvu09 = NULL
      END IF
#NO.FUN-830001------------end------------
 
     FOREACH x611_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#NO.FUN-830001------------start------------
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rvu01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rvu02
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rvu03 USING 'YYYYMMDD'
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rvu04
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rvv36
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT x611_rep(sr.*)
 
        SELECT ima021
          INTO l_ima021
          FROM ima_file
        WHERE ima01=sr.rvv31
        IF SQLCA.sqlcode THEN
           LET l_ima021 = NULL
        END IF
        SELECT azf03 INTO l_azf03 FROM azf_file
            WHERE azf01 = sr.rvv26
             AND azf02 = "2"    #MOD-710148 mod 
        IF SQLCA.sqlcode THEN
             LET l_azf03 = NULL
        END IF
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.rvv31
      LET l_s = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                LET l_s = l_rvv85 , sr.rvv83  CLIPPED
                IF cl_null(sr.rvv85) OR sr.rvv85  = 0 THEN
                    CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                    LET l_s = l_rvv82,sr.rvv80  CLIPPED
                ELSE
                   IF NOT cl_null(sr.rvv82) AND sr.rvv82 > 0 THEN
                      CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                      LET l_s = l_s CLIPPED,',',l_rvv82,sr.rvv80  CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.rvv85) AND sr.rvv85 > 0 THEN
                    CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                    LET l_s = l_rvv85,sr.rvv83  CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      LET  g_rvu01 =sr.rvu01
 
      LET l_num = 0    #FUN-CB0001
      #FUN-D40128--add--str--
      LET l_imd02=''
      LET l_ime03=''
      SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01=sr.rvv32
      SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime01=sr.rvv32 AND ime02=sr.rvv33
      #FUN-D40128--add--end
      EXECUTE insert_prep USING
         sr.rvu01,sr.rvu02,sr.rvu03,sr.rvu04,sr.rvu05,sr.rvu06,sr.rvu09,
         sr.rvv02,sr.rvv05,sr.rvv17,sr.rvv26,sr.rvv18,sr.rvv36,sr.rvv37,
         sr.rvv31,sr.rvv031,sr.rvv32,sr.rvv33,sr.rvv34,sr.rvv35,sr.rvv80,
         sr.rvv82,sr.rvv83,sr.rvv85,l_azf03,l_ima021,l_s,g_azi05,l_num     #FUN-CB0001 g_azi05,l_num
        ,l_imd02,l_ime03  #FUN-D40128
#NO.FUN-830001------------end------------
     END FOREACH
 
#     FINISH REPORT x611_rep                               #NO.FUN-830001
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-830001
#NO.FUN-830001------------start------------
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
###XtraGrid###     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
###XtraGrid###                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
###XtraGrid###                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
###XtraGrid###                 g_azi05
                 
 
###XtraGrid###     CALL cl_prt_cs3('apmx611',l_name,g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-CB0001-----add---str---
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rvu01,rvu02,rvu03,rvu04,rvv36')
            RETURNING tm.wc
     ELSE 
        LET tm.wc = ""
     END IF 
    IF g_sma115 = "Y"  THEN  #是否顯示單位注解
       LET l_name = 'apmx611_2|apmx611_3'
    ELSE
       LET l_name = 'apmx611|apmx611_1'
    END IF 
    LET g_xgrid.template = l_name 
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"rvu01,rvu02,rvu03,rvu04,rvv36")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"rvu01,rvu02,rvu03,rvu04,rvv36")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"rvu01,rvu02,rvu03,rvu04,rvv36") #FUN-D30070 mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"rvu01,rvu02,rvu03,rvu04,rvv36")
   #LET l_str = cl_wcchp(g_xgrid.order_field,"rvu01,rvu02,rvu03,rvu04,rvv36") #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',','-') #FUN-D30070 mark
   #LET g_xgrid.footerinfo1 = cl_getmsg('lib-626',g_lang),l_str #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    #FUN-CB0001-----add---end---
    CALL cl_xg_view()    ###XtraGrid###
#NO.FUN-830001------------end------------
END FUNCTION
 
#NO.FUN-830001-----------------MARK-----------------
#REPORT x611_rep(sr)
#   DEFINE l_ima021      LIKE ima_file.ima021    #FUN-4C0095
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         #TQC-630166
         #l_str         VARCHAR(50),                    #列印排列順序說明
         #l_str1        VARCHAR(10),                    #列印合計的前置說明
         #l_str2        VARCHAR(10),                    #列印合計的前置說明
         #l_str3        VARCHAR(10),                    #列印合計的前置說明
#          l_str         STRING,                      #列印排列順序說明
#          l_str1        STRING,                      #列印合計的前置說明
#          l_str2        STRING,                      #列印合計的前置說明
#          l_str3        STRING,                      #列印合計的前置說明
#         #END TQC-630166
#          sq1           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#          sq2           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#          sq3           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#          swth          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#          l_i           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
#          l_azf03       LIKE azf_file.azf03,    #FUN-4C0095
#          sr               RECORD order1 LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
#                                  order2 LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
#                                  order3 LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
#                                  rvu01 LIKE rvu_file.rvu01,	# 單號
#                                  rvu02 LIKE rvu_file.rvu02, 	# 性質
#                                  rvu03 LIKE rvu_file.rvu03, 	# 更動序號
#                                  rvu04 LIKE rvu_file.rvu04, 	# 廠商編號
#                                  rvu05 LIKE rvu_file.rvu05, 	# 廠商簡稱
#                                  rvu06 LIKE rvu_file.rvu06,	# 廠商編號
#                                  rvu09 LIKE rvu_file.rvu09,	# 取回日期
#                                  rvv02 LIKE rvv_file.rvv02,    # 項次
#                                  rvv05 LIKE rvv_file.rvv05,    # 驗收項次
#                                  rvv17 LIKE rvv_file.rvv17,    # 數量
#                                  rvv26 LIKE rvv_file.rvv26,    # 退貨理由
#                                  rvv18 LIKE rvv_file.rvv18,    # 工單單號
#                                  rvv36 LIKE rvv_file.rvv36,    # 採購單號
#                                  rvv37 LIKE rvv_file.rvv37,    # 採購項次
#                                  rvv31 LIKE rvv_file.rvv31,    # 料件編號
#                                  rvv031 LIKE rvv_file.rvv031,  # 品名
#                                  rvv32 LIKE rvv_file.rvv32,    # 倉庫
#                                  rvv33 LIKE rvv_file.rvv33,    # 儲位
#                                  rvv34 LIKE rvv_file.rvv34,    # 批號
#                                  rvv35 LIKE rvv_file.rvv35,    # 單位
#                                  #No.FUN-580004-begin
#                                  rvv80 LIKE rvv_file.rvv80,
#                                  rvv82 LIKE rvv_file.rvv82,
#                                  rvv83 LIKE rvv_file.rvv83,
#                                  rvv85 LIKE rvv_file.rvv85
#                                  #No.FUN-580004-end
#                        END RECORD
##No.FUN-580004-begin
##DEFINE  l_s          VARCHAR(100),   #TQC-630166 mark
#DEFINE   l_s          STRING,      #TQC-630166
#         l_ima906     LIKE ima_file.ima906,
#         l_rvv85      STRING,
#         l_rvv82      STRING
##No.FUN-580004-end
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.rvu01,sr.rvv02
#  FORMAT
#   PAGE HEADER
## 處理排列順序於列印時所需控制
#      LET sq1=tm.s[1,1]
#      LET sq2=tm.s[2,2]
#      LET sq3=tm.s[3,3]
#      LET l_str=g_x[18] CLIPPED
#      CASE
#         WHEN sq1='1'    LET l_str=l_str CLIPPED,g_x[19]
#                         LET l_str1=g_x[19] CLIPPED
#         WHEN sq1='2'    LET l_str=l_str CLIPPED,g_x[20]
#                         LET l_str1=g_x[20] CLIPPED
#         WHEN sq1='3'    LET l_str=l_str CLIPPED,g_x[21]
#                         LET l_str1=g_x[21] CLIPPED
#         WHEN sq1='4'    LET l_str=l_str CLIPPED,g_x[22]
#                         LET l_str1=g_x[22] CLIPPED
#         WHEN sq1='5'    LET l_str=l_str CLIPPED,g_x[23]
#                         LET l_str1=g_x[23] CLIPPED
#      END CASE
#      CASE
#         WHEN sq2='1'    LET l_str=l_str CLIPPED,' ',g_x[19]
#                         LET l_str2=g_x[19] CLIPPED
#         WHEN sq2='2'    LET l_str=l_str CLIPPED,' ',g_x[20]
#                         LET l_str2=g_x[20] CLIPPED
#         WHEN sq2='3'    LET l_str=l_str CLIPPED,' ',g_x[21]
#                         LET l_str2=g_x[21] CLIPPED
#         WHEN sq2='4'    LET l_str=l_str CLIPPED,' ',g_x[22]
#                         LET l_str2=g_x[22] CLIPPED
#         WHEN sq2='5'    LET l_str=l_str CLIPPED,' ',g_x[23]
#                         LET l_str2=g_x[23] CLIPPED
#      END CASE
#      CASE
#         WHEN sq3='1'    LET l_str=l_str CLIPPED,' ',g_x[19] CLIPPED
#                         LET l_str3=g_x[19] CLIPPED
#         WHEN sq3='2'    LET l_str=l_str CLIPPED,' ',g_x[20] CLIPPED
#                         LET l_str3=g_x[20] CLIPPED
#         WHEN sq3='3'    LET l_str=l_str CLIPPED,' ',g_x[21] CLIPPED
#                         LET l_str3=g_x[21] CLIPPED
#         WHEN sq3='4'    LET l_str=l_str CLIPPED,' ',g_x[22] CLIPPED
#                         LET l_str3=g_x[22] CLIPPED
#         WHEN sq3='5'    LET l_str=l_str CLIPPED,' ',g_x[23] CLIPPED
#                         LET l_str3=g_x[23] CLIPPED
#      END CASE
##     LET g_len=0
##     IF tm.y = 'Y' THEN
##         FOR l_i=31 to 51
##            LET g_len=g_len+g_w[l_i]+1
#         END FOR
##     ELSE
##         FOR l_i=31 to 49
##            LET g_len=g_len+g_w[l_i]+1
##         END FOR
##     END IF
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT l_str
#      PRINT g_dash
##     IF tm.y = 'Y' THEN
#          PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#                g_x[51],g_x[52]    #No.FUN-580004
##     ELSE
##         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
##               g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
##     END IF
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN
#          SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.rvu01
#      IF cl_null(g_rvu01) OR g_rvu01!=sr.rvu01 THEN
#          LET swth = 'Y'
#      ELSE
#          LET swth='N'
#      END IF
#      IF tm.a='2' THEN
#          LET sr.rvu09 = NULL
#      END IF
#      PRINT COLUMN g_c[31],sr.rvu01,
#            COLUMN g_c[32],sr.rvu03,
#            COLUMN g_c[33],sr.rvu09,
#            COLUMN g_c[34],sr.rvu02,
#            COLUMN g_c[35],sr.rvu04,
#            COLUMN g_c[36],sr.rvu05;
#
#   ON EVERY ROW
#      SELECT ima021
#        INTO l_ima021
#        FROM ima_file
#       WHERE ima01=sr.rvv31
#      IF SQLCA.sqlcode THEN
#          LET l_ima021 = NULL
#      END IF
#     IF tm.y = 'Y' THEN
#          SELECT azf03 INTO l_azf03 FROM azf_file
#           WHERE azf01 = sr.rvv26
#            #AND azf02 = "8"    #MOD-710148 mod
#             AND azf02 = "2"    #MOD-710148 mod 
#          IF SQLCA.sqlcode THEN
#              LET l_azf03 = NULL
#          END IF
#
##No.FUN-580004-begin
#      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                         WHERE ima01=sr.rvv31
#      LET l_s = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
#                LET l_s = l_rvv85 , sr.rvv83  CLIPPED
#                IF cl_null(sr.rvv85) OR sr.rvv85  = 0 THEN
#                    CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
#                    LET l_s = l_rvv82,sr.rvv80  CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.rvv82) AND sr.rvv82 > 0 THEN
#                      CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
#                      LET l_s = l_s CLIPPED,',',l_rvv82,sr.rvv80  CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.rvv85) AND sr.rvv85 > 0 THEN
#                    CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
#                    LET l_s = l_rvv85  , sr.rvv83  CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
##No.FUN-580004-end
 
#          PRINT COLUMN g_c[37],sr.rvv02 USING '########',
#                COLUMN g_c[38],sr.rvv05 USING '######## ',
#                COLUMN g_c[39],sr.rvv36,
#                COLUMN g_c[40],sr.rvv18,
#                COLUMN g_c[41],sr.rvv37 USING '########',
#                COLUMN g_c[42],sr.rvv31,
#                COLUMN g_c[43],sr.rvv031,
#                COLUMN g_c[44],l_ima021,
#                COLUMN g_c[45],sr.rvv32,
#                COLUMN g_c[46],sr.rvv33,
#                COLUMN g_c[47],sr.rvv34,
#                COLUMN g_c[48],cl_numfor(sr.rvv17,48,g_azi05),
#                COLUMN g_c[49],sr.rvv35,
#                COLUMN g_c[52],l_s CLIPPED,    #No.FUN-580004
#                COLUMN g_c[50],sr.rvv26,
#                COLUMN g_c[51],l_azf03
##     ELSE
##         PRINT COLUMN g_c[37],sr.rvv02 USING '########',
##               COLUMN g_c[38],sr.rvv05 USING '######## ',
##               COLUMN g_c[39],sr.rvv36,
#               COLUMN g_c[40],sr.rvv18,
#               COLUMN g_c[41],sr.rvv37 USING '########',
#               COLUMN g_c[42],sr.rvv31,
#               COLUMN g_c[43],sr.rvv031,
#               COLUMN g_c[44],l_ima021,
#               COLUMN g_c[45],sr.rvv32,
#               COLUMN g_c[46],sr.rvv33,
#               COLUMN g_c[47],sr.rvv34,
#               COLUMN g_c[48],cl_numfor(sr.rvv17,48,g_azi05),
#               COLUMN g_c[49],sr.rvv35
##     END IF
#      LET  g_rvu01 =sr.rvu01
#
#   AFTER GROUP OF sr.order1
#      IF  tm.u[1,1] = 'Y' THEN
#         LET g_total1 = GROUP SUM(sr.rvv17)
#         IF g_total1 IS NULL THEN
#             LET g_total1 = 0
#         END IF
#         PRINT COLUMN g_c[47],l_str1 CLIPPED,g_x[24] CLIPPED,
#               COLUMN g_c[48],cl_numfor(g_total1,48,g_azi05) CLIPPED
#       END IF
#
#   AFTER GROUP OF sr.order2
#      IF  tm.u[2,2] = 'Y' THEN
#         LET g_total1 = GROUP SUM(sr.rvv17)
#         IF g_total1 IS NULL THEN
#             LET g_total1 = 0
#         END IF
#         PRINT COLUMN g_c[47],l_str1 CLIPPED,g_x[24] CLIPPED,
#               COLUMN g_c[48],cl_numfor(g_total1,48,g_azi05) CLIPPED
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#        LET g_total1 = GROUP SUM(sr.rvv17)
#        IF g_total1 IS NULL THEN
#             LET g_total1 = 0
#         END IF
#         PRINT COLUMN g_c[47],l_str1 CLIPPED,g_x[24] CLIPPED,
#               COLUMN g_c[48],cl_numfor(g_total1,48,g_azi05) CLIPPED
#      END IF
#
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN
#              PRINT g_dash
#             #TQC-630166
#             #IF tm.wc[001,120] > ' ' THEN			# for 132
# 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             #IF tm.wc[121,240] > ' ' THEN
# 	     #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             #IF tm.wc[241,300] > ' ' THEN
# 	     #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
#      END IF
#      PRINT g_dash     #No.TQC-6B0095
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED     #No.TQC-6B0095
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
 
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     IF tm.y = 'Y' THEN
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     ELSE
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash[1,g_len]
#            IF tm.y = 'Y' THEN
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            END IF
#       ELSE SKIP 2 LINES
#    END IF
#END REPORT
#NO.FUN-830001--------------MARK---END-----
#Patch....NO.TQC-610036 <001> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
