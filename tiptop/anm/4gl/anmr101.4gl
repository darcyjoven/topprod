# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmr101.4gl
# Descriptions...: 票據狀況異動明細表列表作業
# Input parameter:
# Return code....:
# Date & Author..: 92/05/04 By Jones
# Modify.........: No.FUN-4C0098 04/12/22 By pengu 報表轉XML
# Modify.........: No.MOD-530176 05/03/21 By pengu 調整金額、匯率之位數與小數位數
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.MOD-640404 06/04/26 By Smapmin 取消小計
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-750247 07/05/30 By kim 票面金額未列印出
# Modify.........: No.TQC-830029 08/03/21 By Carol l_cmd型態改為 LIKE type_file.chr1000
# Modify.........: No.FUN-830119 08/03/24 By lala 制作CR
# Modify.........: No.MOD-930176 09/03/19 By Sarah anmr101()段加上CALL cl_del_data(l_table)
# Modify.........: No.MOD-970188 09/07/21 By mike EXECUTE中有寫到sr.nmf*欄位的,需改成sr.g_nmf.nmf*                                  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-830029 11/01/25 By Summer l_cmd型態改為STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		 	     #Print condition RECORD
              wc  LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) #Where Condiction
              c   LIKE type_file.chr2,       #No.FUN-680107 VARCHAR(2) #排列順序
              d   LIKE type_file.chr2,       #No.FUN-680107 VARCHAR(2) #跳頁否
           more   LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #額外摘要是否列印
              END RECORD,
          g_bookno  LIKE aba_file.aba00      #帳別編號
 
DEFINE   g_cnt      LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE   g_i        LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
DEFINE   l_table    STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-830119---start---
   LET g_sql="nmf02.nmf_file.nmf02,",
             "nmf07.nmf_file.nmf07,",
             "nmf13.nmf_file.nmf13,",
             "nmf11.nmf_file.nmf11,",
             "nmd12_1.type_file.chr8,",
             "nmd12_2.type_file.chr8,",
             "nmd01.nmd_file.nmd01,",
             "nmd06.nmd_file.nmd06,",
             "nmd20.nmd_file.nmd20,", 
             "nmd21.nmd_file.nmd21,",
             "nmd04.nmd_file.nmd04,",
             "nmd08.nmd_file.nmd08,",
             "nmd24.nmd_file.nmd24,",
             "nmd07.nmd_file.nmd07,",
             "nmd10.nmd_file.nmd10,",
             "nmd03.nmd_file.nmd03,",
             "nma02.nma_file.nma02"
   LET l_table = cl_prt_temptable('anmr101',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-830119---end-`---
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   LET tm.d  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #no.5195
   DROP TABLE curr_tmp
#FUN-680107 --start 欄位類型修改
#  CREATE TEMP TABLE curr_tmp                                                   
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別                                 
#    amt     DEC(20,6)                    #票面金額  
#   );
 
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE nmd_file.nmd04);
#FUN-680107 --end
   CREATE UNIQUE INDEX curr_01 ON curr_tmp(curr);
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr101_tm()	        	# Input print condition
      ELSE CALL anmr101()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr101_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd	   STRING,                 #TQC-830029-modify     #No.FUN-680107 CHAR(400)
       l_jmp_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE l_zz08      LIKE zz_file.zz08       #TQC-830029 add
 
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr101_w AT p_row,p_col
        WITH FORM "anm/42f/anmr101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c = '12'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.c[1,1]
   LET tm2.s2   = tm.c[2,2]
   LET tm2.t1   = tm.d[1,1]
   LET tm2.t2   = tm.d[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmf02,nmd03,nmf07,nmd06,nmd20,nmd01,
                              nmf11,nmf13,nmf05,nmf06
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr101_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more    #是否輸入其它條件
         IF tm.more NOT MATCHES "[YN]"
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
 
   AFTER INPUT
      LET l_jmp_flag = 'N'
      LET tm.c = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.d = tm2.t1,tm2.t2
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr101_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
     #SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx) #TQC-830029 mark
      SELECT zz08 INTO l_zz08 FROM zz_file	#get exec cmd (fglgo xxxx) #TQC-830029
             WHERE zz01='anmr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr101','9031',1)
      ELSE
         LET l_cmd = l_zz08 #TQC-830029 add
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('anmr101',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr101()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr101_w
END FUNCTION
#No.FUN-830119---start---
FUNCTION anmr101()
   DEFINE l_name	LIKE type_file.chr20, 		     # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,	             # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,              #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE nmf_file.nmf11,     #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          l_i           LIKE type_file.num5,                 #No.FUN-680107 SMALLINT
          l_nmd12_1       LIKE type_file.chr8,
	  l_nmd12_2       LIKE type_file.chr8,
          l_nma02         LIKE nma_file.nma02,
          sr               RECORD
                           order1    LIKE nmf_file.nmf11,    #No.FUN-680107 VARCHAR(10) #排列順序-1
                           order2    LIKE nmf_file.nmf11,    #No.FUN-680107 VARCHAR(10) #排列順序-2
                           g_nmf     RECORD LIKE nmf_file.*,
                           nmd01     LIKE nmd_file.nmd01, #票號
                           nmd06     LIKE nmd_file.nmd06, #票別一
                           nmd20     LIKE nmd_file.nmd20, #票別二
                           nmd21     LIKE nmd_file.nmd21, #幣別
                           nmd04     LIKE nmd_file.nmd04, #票面金額
                           nmd08     LIKE nmd_file.nmd08, #廠商代號
                           nmd07     LIKE nmd_file.nmd07, #開票日
                           nmd10     LIKE nmd_file.nmd10, #付款單號
                           nmd03     LIKE nmd_file.nmd03, #付款銀行
                           nmd17     LIKE nmd_file.nmd17, #帳別
                           nmd24     LIKE nmd_file.nmd24,  #簡稱
                           nmf02     LIKE nmf_file.nmf02,
                           nmf07     LIKE nmf_file.nmf07,
                           nmf13     LIKE nmf_file.nmf13,
                           nmf11     LIKE nmf_file.nmf11
                        END RECORD
 
   CALL cl_del_data(l_table)   #MOD-930176 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
   #End:FUN-980030
 
   DELETE FROM curr_tmp; #no.5195
   LET l_sql = "SELECT '','',nmf_file.*,nmd01,nmd06,nmd20,nmd21,nmd04,",
               " nmd08,nmd07,nmd10,nmd03,nmd17,nmd24 ",
               " FROM nmf_file,nmd_file",
               " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED,
               " AND nmd01 = nmf01 "
 
   PREPARE anmr101_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   DECLARE anmr101_curs1 CURSOR FOR anmr101_prepare1
#  CALL cl_outnam('anmr101') RETURNING l_name
#  START REPORT anmr101_rep TO l_name
 
   LET g_pageno = 0
   LET g_cnt    = 1
   FOREACH anmr101_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      FOR l_i = 1 TO 2
         CASE WHEN tm.c[l_i,l_i] = '1'
                   LET l_order[l_i] = sr.nmf02 using 'yyyymmdd'
              WHEN tm.c[l_i,l_i] = '2' LET l_order[l_i] = sr.nmd03
              WHEN tm.c[l_i,l_i] = '3' LET l_order[l_i] = sr.nmf07
              WHEN tm.c[l_i,l_i] = '4' LET l_order[l_i] = sr.nmd06
              WHEN tm.c[l_i,l_i] = '5' LET l_order[l_i] = sr.nmd20
              WHEN tm.c[l_i,l_i] = '6' LET l_order[l_i] = sr.nmd01
              WHEN tm.c[l_i,l_i] = '7' LET l_order[l_i] = sr.nmf11
              WHEN tm.c[l_i,l_i] = '8'
                   LET l_order[l_i] = sr.g_nmf.nmf13 using 'yyyymmdd'
              OTHERWISE LET l_order[l_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
#     OUTPUT TO REPORT anmr101_rep(sr.*)
      IF NOT cl_null(sr.g_nmf.nmf05) THEN
         CALL s_nmd12(sr.g_nmf.nmf05) RETURNING l_nmd12_1
         LET l_nmd12_1=sr.g_nmf.nmf05,':',l_nmd12_1
      END IF
      IF NOT cl_null(sr.g_nmf.nmf06) THEN
         CALL s_nmd12(sr.g_nmf.nmf06) RETURNING l_nmd12_2
         LET l_nmd12_2=sr.g_nmf.nmf06,':',l_nmd12_2
      END IF
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmd03
      EXECUTE insert_prep USING
        #sr.nmf02, sr.nmf07,sr.nmf13,sr.nmf11,l_nmd12_1, #MOD-970188                                                                
         sr.g_nmf.nmf02,sr.g_nmf.nmf07,sr.g_nmf.nmf13, sr.g_nmf.nmf11,l_nmd12_1, #MOD-970188 
         l_nmd12_2,sr.nmd01,sr.nmd06,sr.nmd20,sr.nmd21,
         sr.nmd04, sr.nmd08,sr.nmd24,sr.nmd07,sr.nmd10,
         sr.nmd03,l_nma02
   END FOREACH
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_wcchp(tm.wc,'nmf02,nmd03,nmf07,nmd06,nmd20,nmd01,nmf11,nmf13,nmf05,nmf06')
           RETURNING tm.wc
   LET g_str=tm.wc,";",tm.c[1,1],";",tm.c[2,2]
   CALL cl_prt_cs3('anmr101','anmr101',g_sql,g_str)
#  FINISH REPORT anmr101_rep
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
{REPORT anmr101_rep(sr)
   DEFINE l_last_sw	  LIKE type_file.chr1,          #No.FUN-680107
	  l_nmd12_1       LIKE type_file.chr8,          #No.FUN-680107
	  l_nmd12_2       LIKE type_file.chr8,          #No.FUN-680107
          l_orderA        ARRAY[2] OF LIKE zaa_file.zaa08, #FUN-680107 ARRAY[2] OF VARCHAR(8) #排序名稱
	  l_cnt           LIKE type_file.num5,          #合計票據張數 #No.FUN-680107 SMALLINT
          l_total         LIKE nmd_file.nmd04,          #票面金額合計
          l_nma02         LIKE nma_file.nma02,          #銀行簡稱
          sr               RECORD
                           order1    LIKE nmf_file.nmf11, #No.FUN-680107 VARCHAR(10) #排列順序-1
                           order2    LIKE nmf_file.nmf11, #No.FUN-680107 VARCHAR(10) #排列順序-2
                           g_nmf     RECORD LIKE nmf_file.*,
                           nmd01     LIKE nmd_file.nmd01, #票號
                           nmd06     LIKE nmd_file.nmd06, #票別一
                           nmd20     LIKE nmd_file.nmd20, #票別二
                           nmd21     LIKE nmd_file.nmd21, #幣別
                           nmd04     LIKE nmd_file.nmd04, #票面金額
                           nmd08     LIKE nmd_file.nmd08, #廠商代號
                           nmd07     LIKE nmd_file.nmd07, #開票日
                           nmd10     LIKE nmd_file.nmd10, #付款單號
                           nmd03     LIKE nmd_file.nmd03, #付款銀行
                           nmd17     LIKE nmd_file.nmd17, #帳別
                           nmd24     LIKE nmd_file.nmd24  #廠商簡稱
                        END RECORD,
          sr1           RECORD
                           curr      LIKE azi_file.azi01, #No.FUN-680107 VARCHAR(4)
                           amt       LIKE nmd_file.nmd04
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.g_nmf.nmf02
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      FOR g_i = 1 TO 2
         CASE WHEN tm.c[g_i,g_i] = '1' LET l_orderA[g_i] = g_x[10]
              WHEN tm.c[g_i,g_i] = '2' LET l_orderA[g_i] = g_x[11]
              WHEN tm.c[g_i,g_i] = '3' LET l_orderA[g_i] = g_x[12]
              WHEN tm.c[g_i,g_i] = '4' LET l_orderA[g_i] = g_x[13]
              WHEN tm.c[g_i,g_i] = '5' LET l_orderA[g_i] = g_x[14]
              WHEN tm.c[g_i,g_i] = '6' LET l_orderA[g_i] = g_x[15]
              OTHERWISE LET l_orderA[g_i] = ' '
         END CASE
      END FOR
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[9] CLIPPED, l_ordera[1] CLIPPED,'-',
            l_ordera[2] CLIPPED
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED
 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.d[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.d[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.g_nmf.nmf02,
            COLUMN g_c[32],sr.g_nmf.nmf13,
            COLUMN g_c[33],sr.g_nmf.nmf11;
      IF NOT cl_null(sr.g_nmf.nmf05) THEN
               CALL s_nmd12(sr.g_nmf.nmf05) RETURNING l_nmd12_1
         LET l_nmd12_1=sr.g_nmf.nmf05,':',l_nmd12_1
         PRINT COLUMN g_c[34],l_nmd12_1 CLIPPED;
      END IF
      IF NOT cl_null(sr.g_nmf.nmf06) THEN
         CALL s_nmd12(sr.g_nmf.nmf06) RETURNING l_nmd12_2
         LET l_nmd12_2=sr.g_nmf.nmf06,':',l_nmd12_2
         PRINT COLUMN g_c[35],l_nmd12_2 CLIPPED;
      END IF
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.nmd21
 
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmd03
 
      PRINT COLUMN g_c[36],sr.nmd01,
            COLUMN g_c[37],sr.nmd06,
            COLUMN g_c[38],sr.nmd21 CLIPPED,
            COLUMN g_c[39],cl_numfor(sr.nmd04,39,t_azi04), #TQC-750247
            COLUMN g_c[40],sr.nmd08,
            COLUMN g_c[41],sr.nmd24,
            COLUMN g_c[42],sr.nmd07,
            COLUMN g_c[43],sr.nmd10,
            COLUMN g_c[44],sr.nmd03,
            COLUMN g_c[45],l_nma02
      LET l_cnt = l_cnt + 1
      #no.5195
      SELECT COUNT(*) INTO g_cnt FROM curr_tmp WHERE curr = sr.nmd21
      IF g_cnt > 0 THEN
         UPDATE curr_tmp SET amt = amt + sr.nmd04
          WHERE curr = sr.nmd21
      ELSE
          INSERT INTO curr_tmp VALUES(sr.nmd21,sr.nmd04)
      END IF
      #no.5195(end)
 
   ON LAST ROW
          LET l_total = SUM(sr.nmd04)
          PRINT COLUMN 16,g_x[16] CLIPPED,COLUMN 24,l_cnt,' ',
	  g_x[17] CLIPPED;
          #-----MOD-640404----------
          ##no.5195
          #DECLARE tmp_cs CURSOR FOR SELECT * FROM curr_tmp
          #FOREACH tmp_cs INTO sr1.*
          #    IF STATUS THEN
          #       CALL cl_err('sel curr:',STATUS,1) EXIT FOREACH
          #    END IF
          #    SELECT azi05 INTO g_azi05 FROM azi_file
          #     WHERE azi01 = sr1.curr
          #    PRINT COLUMN g_c[38],sr1.curr CLIPPED,
          #          COLUMN g_c[39],cl_numfor(sr1.amt,17,g_azi05) CLIPPED #No.TQC-5C0059
          #END FOREACH
          ##no.5195(end)
          #-----END MOD-640404-----
 
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_cnt = 0
      FOR g_i = 1 TO 2 LET l_orderA[g_i] = ' ' END FOR
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-830119---end---
