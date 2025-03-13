# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr430.4gl
# Descriptions...: 外匯交易報表列印
# Date & Author..: 99/05/10 By Iceman
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-580010 05/08/08 By will 報表轉XML格式
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/11/06 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.CHI-760004 07/06/15 By kim 小計未對齊
# Modify.........: No.FUN-780011 07/08/14 By Carrier 報表轉Crystal Report格式
# Modify.........: No.CHI-8A0015 08/11/04 By Sarah 交割日期改為INPUT條件,組SQL時抓取gxc04<=交割日期<=gxc041的資料
# Modify.........: No.FUN-8B0013 08/11/12 By jan gxe01-->gxe19
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40115 10/04/23 By Carrier CHI-9A0047追单
# Modify.........: No.MOD-B70168 11/07/19 By Polly 取消此 RPT gxc09/gxc10/gxc11 取位動作 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD			   # Print condition RECORD
                   wc    LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(600) #Where Condiction
                   gxc04 LIKE gxc_file.gxc04,      #CHI-8A0015 add
                   a     LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)   #交易性質
                   b     LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)   #交易性質
                   s     LIKE type_file.chr3,      #No.FUN-680107 VARCHAR(3)
                   t     LIKE type_file.chr3,      #No.FUN-680107 VARCHAR(3)
                   u     LIKE type_file.chr3,      #No.FUN-680107 VARCHAR(3)
                   more  LIKE type_file.chr1       #No.FUN-680107 VARCHAR(1)
                  END RECORD
DEFINE g_cnt      LIKE type_file.num10             #No.FUN-680107 INTEGER
DEFINE g_i        LIKE type_file.num5              #count/index for any purpose  #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE g_dash    VARCHAR(400)  #Dash line
#DEFINE g_len     SMALLINT   #Report width(79/132/136)
#DEFINE g_pageno  SMALLINT   #Report page no
#DEFINE g_zz05    VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE l_table    STRING  #No.FUN-780011
DEFINE g_str      STRING  #No.FUN-780011
DEFINE g_sql      STRING  #No.FUN-780011
 
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
   LET g_sql = " gxc03.gxc_file.gxc03,",                                                       
               " gxc04.gxc_file.gxc04,",                                                       
               " gxc041.gxc_file.gxc041,",                                                       
               " gxc05.gxc_file.gxc05,",                                                       
               " gxc06.gxc_file.gxc06,",                                                       
               " gxc07.gxc_file.gxc07,",                                                       
               " gxc08.gxc_file.gxc08,",                                                       
               " gxc09.gxc_file.gxc09,",                                                       
               " gxc10.gxc_file.gxc10,",                                                       
               " gxc11.gxc_file.gxc11,",                                                       
               " alg021.alg_file.alg021,",                                                     
               " gxe08.gxe_file.gxe08,",                                                       
               " rem.gxc_file.gxc08,",                                                         
               " amt1.gxc_file.gxc08,",                                                        
               " amt2.gxc_file.gxc08,",                                                        
               " azi04.azi_file.azi04,",                                                       
               " azi05.azi_file.azi05,",                                                       
               " azi07.azi_file.azi07 "
   LET l_table = cl_prt_temptable('anmr430',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?     )  "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780011  --End
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.gxc04 = ARG_VAL(8)    #CHI-8A0015 add
   LET tm.s     = ARG_VAL(9)    #TQC-610058
   LET tm.t     = ARG_VAL(10)   #TQC-610058
   LET tm.u     = ARG_VAL(11)   #TQC-610058
   LET tm.a     = ARG_VAL(12)
   LET tm.b     = ARG_VAL(13)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt   DEC(20,6),                   #承作金額
#    order1  VARCHAR(20),
#    order2  VARCHAR(20),
#    order3  VARCHAR(20)
#   );
 
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE gxc_file.gxc11,
     order2 LIKE gxc_file.gxc11,
     order3 LIKE gxc_file.gxc11);
#No.FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr430_tm()	        	# Input print condition
      ELSE CALL anmr430()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr430_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr430_w AT p_row,p_col WITH FORM "anm/42f/anmr430"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.s = '431' #CHI-9A0047                                                 
   LET tm.s = '432' #CHI-9A0047
   LET tm.a = '1'
   LET tm.b = '1'
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
     #CONSTRUCT BY NAME tm.wc ON gxc03,gxc04,gxc05,gxc07   #CHI-8A0015 mark
     #CONSTRUCT BY NAME tm.wc ON gxc03,gxc05,gxc07         #CHI-8A0015
      CONSTRUCT BY NAME tm.wc ON gxc03,gxc05,gxc06,gxc07   #No.TQC-A40115
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
         LET INT_FLAG = 0 CLOSE WINDOW anmr430_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
      INPUT BY NAME tm.gxc04,   #CHI-8A0015 add tm.gxc04
                    tm2.s1,tm2.s2,tm2.s3,
                    tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,
                    tm.a,tm.b,
                    tm.more
                    WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        #str CHI-8A0015 add
        #從QBE條件改為INPUT條件
         AFTER FIELD gxc04   #交割日期
            IF cl_null(tm.gxc04) THEN
               NEXT FIELD gxc04
            END IF
        #end CHI-8A0015 add
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[123]' THEN NEXT FIELD b END IF
 
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
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
            IF INT_FLAG THEN EXIT INPUT END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
    
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
         LET INT_FLAG = 0 CLOSE WINDOW anmr430_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='anmr430'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr430','9031',1)
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
                        " '",tm.gxc04 CLIPPED,"'",   #CHI-8A0015 add
                        " '",tm.s CLIPPED,"'",   #TQC-610058
                        " '",tm.t CLIPPED,"'",   #TQC-610058
                        " '",tm.u CLIPPED,"'",   #TQC-610058
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('anmr430',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW anmr430_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL anmr430()
      ERROR ""
   END WHILE
   CLOSE WINDOW anmr430_w
END FUNCTION
 
FUNCTION anmr430()
   DEFINE l_name	LIKE type_file.chr20, 		  # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		  # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,           #標題內容  #No.FUN-680107 VARCHAR(40)
          l_rate        LIKE gxc_file.gxc09,
          l_order       ARRAY[3] OF LIKE gxc_file.gxc11,  #No.FUN-680107 ARRAY[3] OF VARCHAR(15)
          sr            RECORD
                        order1 LIKE gxc_file.gxc11,       #No.FUN-680107 VARCHAR(15) #排列順序項目
                        order2 LIKE gxc_file.gxc11,       #No.FUN-680107 VARCHAR(15) #排列順序項目
                        order3 LIKE gxc_file.gxc11,       #No.FUN-680107 VARCHAR(15) #排列順序項目
                        gxc    RECORD LIKE gxc_file.*,    #外匯交割資料檔
                        alg021 LIKE alg_file.alg021,      #信貸銀行全名
                        amt1   LIKE gxc_file.gxc08,
                        amt2   LIKE gxc_file.gxc08,
                        gxe08  LIKE gxe_file.gxe08,
                        rem    LIKE gxe_file.gxe08        #餘額
                        END RECORD
 
     #No.FUN-780011  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr430'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len =98  END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
     #No.FUN-780011  --Begin
     ##no.5195   (針對幣別加總)
     #DELETE FROM curr_tmp;
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
     #          "  WHERE order1=? ",
     #          "  GROUP BY curr"
     #PREPARE tmp1_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "  GROUP BY curr  "
     #PREPARE tmp2_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "    AND order3=? ",
     #          "  GROUP BY curr  "
     #PREPARE tmp3_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
     #          "  GROUP BY curr  "
     #PREPARE tmp_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp_cs CURSOR FOR tmp_pre
     ##no.5195(end)
     #No.FUN-780011  --End  
 
     LET l_sql = "SELECT '','','',gxc_file.*,alg021,0,0,0",
                 "  FROM gxc_file,OUTER alg_file ",
                 " WHERE alg_file.alg01 = gxc_file.gxc07 ",  #No.FUN-780011
                 "   AND gxc13 = 'Y' ",
                 "   AND ",tm.wc CLIPPED,
                 "   AND gxc04 <='",tm.gxc04,"'",   #CHI-8A0015 add
                 "   AND gxc041>='",tm.gxc04,"'"    #CHI-8A0015 add
     IF tm.a = '1'
        THEN LET l_sql = l_sql CLIPPED," AND gxc02 = '1' "
        ELSE LET l_sql = l_sql CLIPPED," AND gxc02 = '2' "
     END IF
     PREPARE anmr430_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr430_curs1 CURSOR FOR anmr430_prepare1
 
     #No.FUN-780011  --Begin
     #CALL cl_outnam('anmr430') RETURNING l_name
     #START REPORT anmr430_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-780011  --End  
     FOREACH anmr430_curs1 INTO sr.*
       IF STATUS  THEN CALL cl_err('',STATUS,0) EXIT FOREACH END IF
       #--->已交割承作金額
       SELECT SUM(gxe08) INTO sr.gxe08 FROM gxe_file
#       WHERE gxe01=sr.gxc.gxc01 AND gxe13 = 'Y'    #No.FUN-8B0013
        WHERE gxe19=sr.gxc.gxc01 AND gxe13 = 'Y'    #No.FUN-8B0013
       IF cl_null(sr.gxe08) THEN LET sr.gxe08 = 0 END IF
       LET sr.rem = sr.gxc.gxc08 - sr.gxe08
       IF tm.b = '1' AND sr.gxc.gxc08 <  sr.gxe08 THEN    #未交割
          CONTINUE FOREACH
       END IF
       IF tm.b = '2' AND sr.gxc.gxc08 >= sr.gxe08  THEN    #已交割
          CONTINUE FOREACH
       END IF
       LET sr.amt1 = sr.rem * sr.gxc.gxc10 * sr.gxc.gxc11   #交割匯率
       LET sr.amt2 = sr.rem * sr.gxc.gxc09 * sr.gxc.gxc11   #即期匯率
 
       #No.FUN-780011  --Begin
       #FOR g_i = 1 TO 3
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.gxc.gxc03
       #                                                    USING 'yyyymmdd'
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gxc.gxc04
       #                                                    USING 'yyyymmdd'
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.gxc.gxc05
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.gxc.gxc07
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #LET sr.order3 = l_order[3]
       #IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       #IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       #IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
       #OUTPUT TO REPORT anmr430_rep(sr.*)
       SELECT azi04,azi05,azi07
         INTO t_azi04,t_azi05,t_azi07      #NO.CHI-6A0004
         FROM azi_file
        WHERE azi01=sr.gxc.gxc05
       LET t_azi07 = 10         #No.MOD-B70168 add
       EXECUTE insert_prep USING sr.gxc.gxc03,sr.gxc.gxc04,sr.gxc.gxc041,
                                 sr.gxc.gxc05,sr.gxc.gxc06,sr.gxc.gxc07,
                                 sr.gxc.gxc08,sr.gxc.gxc09,sr.gxc.gxc10,
                                 sr.gxc.gxc11,sr.alg021,sr.gxe08,sr.rem,
                                 sr.amt1,sr.amt2,t_azi04,t_azi05,t_azi07
       #No.FUN-780011  --End  
     END FOREACH
 
     #No.FUN-780011  --Begin
     #FINISH REPORT anmr430_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
#       CALL cl_wcchp(tm.wc,'gxc03,gxc05,gxc07')   #CHI-8A0015 mod
        CALL cl_wcchp(tm.wc,'gxc03,gxc05,gxc06,gxc07')  #No.TQC-A40115
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t,";",tm.u,";",tm.a,";",g_azi04,";",g_azi05
     CALL cl_prt_cs3('anmr430','anmr430',g_sql,g_str)
     #No.FUN-780011  --End  
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT anmr430_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,           #No.FUN-680107 VARCHAR(1)
#        #  l_azi03       LIKE azi_file.azi03,           #NO.CHI-6A0004
#        #  l_azi04       LIKE azi_file.azi04,           #NO.CHI-6A0004
#        #  l_azi05       LIKE azi_file.azi05,           #NO.CHI-6A0004
#          sr            RECORD
#                        order1 LIKE gxc_file.gxc11,    #No.FUN-680107 VARCHAR(15) #排列順序項目
#                        order2 LIKE gxc_file.gxc11,    #No.FUN-680107 VARCHAR(15) #排列順序項目
#                        order3 LIKE gxc_file.gxc11,    #No.FUN-680107 VARCHAR(15) #排列順序項目
#                        gxc    RECORD LIKE gxc_file.*, #外匯交割資料檔
#                        alg021 LIKE alg_file.alg021,   #信貸銀行全名
#                        amt1   LIKE gxc_file.gxc08,
#                        amt2   LIKE gxc_file.gxc08,
#                        gxe08  LIKE gxe_file.gxe08,
#                        rem    LIKE gxc_file.gxc08
#                        END RECORD,
#          sr1           RECORD
#                        curr   LIKE azi_file.azi01,    #No.FUN-680107 VARCHAR(4)
#                        amt    LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6)
#                        END RECORD,
#          l_tot,l_amt1,l_amt2                 LIKE gxc_file.gxc08,
#          a_tot,b_tot,c_tot,a_amt,b_amt,c_amt LIKE gxc_file.gxc08,
#          l_rate1,l_rate2                     LIKE gxc_file.gxc10
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.gxc.gxc07,sr.gxc.gxc03,sr.gxc.gxc04
#  FORMAT
#   PAGE HEADER
##No.FUN-580010  --begin
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
#      IF tm.a = '1' THEN
#         LET g_x[1] = g_x[16] CLIPPED,g_x[1] CLIPPED
#      ELSE
#         LET g_x[1] = g_x[17] CLIPPED,g_x[1] CLIPPED
#      END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##     PRINT g_dash[1,g_len]
##     PRINT COLUMN 08,g_x[11] CLIPPED,COLUMN 43,g_x[12] CLIPPED,
##                     COLUMN 82,g_x[13] CLIPPED,
##                     COLUMN 130,g_x[14] CLIPPED,'(',g_aza.aza17 CLIPPED,')'
##     PRINT '--------------------',COLUMN 22,'------------------- -------- ',
##           '-----------------',COLUMN 69,'-----------',
##           COLUMN 81,'-----------',COLUMN 93,'-----------',COLUMN 105,'-------------------',
##           COLUMN 125, '-------------------',COLUMN 145,'-------------------'
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
##      PRINT  #No.TQC-6A0110
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT  #No.TQC-6A0110
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42] #,'(',g_aza.aza17 CLIPPED,')'
#      PRINT g_dash1
##No.FUN-580010  --end
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.gxc.gxc07
##     PRINT sr.alg021[1,20];
#      PRINT COLUMN g_c[31],sr.alg021[1,20];  #No.FUN-580010
#
#   ON EVERY ROW
#
#      SELECT azi03,azi04,azi05,azi07
#        INTO t_azi03,t_azi04,t_azi05,t_azi07      #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.gxc.gxc05
##No.FUN-580010  -begin
##     PRINT COLUMN 22,cl_numfor(sr.gxc.gxc08,18,l_azi04),
##           COLUMN 42,sr.gxc.gxc03,
##           COLUMN 51,sr.gxc.gxc04,'-',sr.gxc.gxc041,
##           COLUMN 69,cl_numfor(sr.gxc.gxc09 ,10,t_azi07),
##           COLUMN 81,cl_numfor(sr.gxc.gxc10 ,10,t_azi07),
##           COLUMN 93,cl_numfor(sr.gxc.gxc11 ,10,t_azi07),
##           COLUMN 105,cl_numfor(sr.gxe08,18,l_azi04),
##           COLUMN 125,cl_numfor(sr.rem,  18,l_azi04),
##           COLUMN 145,cl_numfor(sr.amt1 ,18,g_azi04)
##     PRINT COLUMN 69,sr.gxc.gxc05 CLIPPED,'/',sr.gxc.gxc06 CLIPPED,
##           COLUMN 81,sr.gxc.gxc05 CLIPPED,'/',sr.gxc.gxc06 CLIPPED
#      PRINT COLUMN g_c[32],cl_numfor(sr.gxc.gxc08,32,t_azi04),  #NO.CHI-6A0004
#            COLUMN g_c[33],sr.gxc.gxc03,
#            COLUMN g_c[34],sr.gxc.gxc04,'-',sr.gxc.gxc041,
#            COLUMN g_c[35],sr.gxc.gxc05,
#            COLUMN g_c[36],sr.gxc.gxc06,
#            COLUMN g_c[37],cl_numfor(sr.gxc.gxc09 ,37,t_azi07),
#            COLUMN g_c[38],cl_numfor(sr.gxc.gxc10 ,38,t_azi07),
#            COLUMN g_c[39],cl_numfor(sr.gxc.gxc11 ,39,t_azi07),
#            COLUMN g_c[40],cl_numfor(sr.gxe08,40,t_azi04),      #NO.CHI-6A0004
#            COLUMN g_c[41],cl_numfor(sr.rem,  41,t_azi04),      #NO.CHI-6A0004
#            COLUMN g_c[42],cl_numfor(sr.amt1 ,42,g_azi04)
##No.FUN-580010  -end
#      #no.5195
#      INSERT INTO curr_tmp VALUES(sr.gxc.gxc05,sr.gxc.gxc08,sr.order1,sr.order2,sr.order3)
#      #no.5195(end)
#
#   AFTER GROUP OF sr.order1
#      LET a_tot = GROUP SUM(sr.gxc.gxc08)
#      LET a_amt = GROUP SUM(sr.amt1)
#      IF tm.u[1,1] = 'Y' THEN
#         #no.5195
#         LET g_cnt = 1
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file                 #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             #No.FUN-580010  --begin
#             LET sr1.curr = ' ',sr1.curr   #No.FUN-580010
##            IF g_cnt != 1 THEN
##               LET sr1.curr = '       ',sr1.curr
##            END IF
#             #No.FUN-580010  --end
#             PRINT g_x[18] CLIPPED,sr1.curr,':',
##                    COLUMN 22,cl_numfor(sr1.amt,18,l_azi05);
#                    COLUMN g_c[32],cl_numfor(sr1.amt,32,t_azi05);  #No.FUN-580010    #NO.CHI-6A0004 #CHI-760004
#             IF g_cnt = 1 THEN
##               PRINT COLUMN 145,cl_numfor(a_amt,18,g_azi05)
#                PRINT COLUMN g_c[42],cl_numfor(a_amt,42,g_azi05)   #No.FUN-580010 #CHI-760004
#             ELSE PRINT END IF
#             LET g_cnt = g_cnt + 1
#         END FOREACH
#         #no.5195(end)
#      END IF
#
#   AFTER GROUP OF sr.order2
#      LET b_tot = GROUP SUM(sr.gxc.gxc08)
#      LET b_amt = GROUP SUM(sr.amt1)
#      IF tm.u[2,2] = 'Y' THEN
#         #no.5195
#         LET g_cnt = 1
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file               #NO.CHI-6A0004    
#              WHERE azi01 = sr1.curr
#             LET sr1.curr = ' ',sr1.curr   #No.FUN-580010
#             PRINT g_x[18] CLIPPED,sr1.curr,':',
##                   COLUMN 22,cl_numfor(sr1.amt,18,l_azi05);
#                    COLUMN g_c[32],cl_numfor(sr1.amt,32,t_azi05);  #No.FUN-580010   #NO.CHI-6A0004 #CHI-760004
#             IF g_cnt = 1 THEN
##               PRINT COLUMN 145,cl_numfor(b_amt,18,g_azi05)
#                PRINT COLUMN g_c[42],cl_numfor(b_amt,42,g_azi05)   #No.FUN-580010 #CHI-760004
#             ELSE PRINT END IF
#             LET g_cnt = g_cnt + 1
#         END FOREACH
#         #no.5195(end)
#      END IF
#
#   AFTER GROUP OF sr.order3
#      LET c_tot = GROUP SUM(sr.gxc.gxc08)
#      LET c_amt = GROUP SUM(sr.amt1)
#      IF tm.u[3,3] = 'Y' THEN
#         #no.5195
#         LET g_cnt = 1
#         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file                 #NO.CHI-6A0004     
#              WHERE azi01 = sr1.curr
#             LET sr1.curr = ' ',sr1.curr   #No.FUN-580010
#             PRINT  g_x[18] CLIPPED,sr1.curr,':',
##                   COLUMN 22,cl_numfor(sr1.amt,18,l_azi05);
#                    COLUMN g_c[32],cl_numfor(sr1.amt,32,t_azi05);  #No.FUN-580010    #NO.CHI-6A0004 #CHI-760004
#             IF g_cnt = 1 THEN
##               PRINT COLUMN 145,cl_numfor(c_amt,18,g_azi05)
#                PRINT COLUMN g_c[42],cl_numfor(c_amt,32,g_azi05) #CHI-760004
#             ELSE PRINT END IF
#             LET g_cnt = g_cnt + 1
#         END FOREACH
#         #no.5195(end)
#      END IF
#
#   ON LAST ROW
#      LET l_tot = SUM(sr.gxc.gxc08)
#      IF cl_null(l_tot) THEN LET l_tot = 0 END IF
#      LET l_amt1 = SUM(sr.amt1)
#      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#      LET l_amt2 = SUM(sr.amt2)
#      IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#      IF l_tot > 0 THEN
#         LET l_rate1 = l_amt1 / l_tot   #交割匯率
#         LET l_rate2 = l_amt2 / l_tot   #即期匯率
#      ELSE
#         LET l_rate1 = 0
#         LET l_rate2 = 0
#      END IF
#      PRINT ''
#      #no.5195
#      LET g_cnt = 1
#      FOREACH tmp_cs INTO sr1.*
#          SELECT azi05,azi07 INTO t_azi05,t_azi07 FROM azi_file  #NO.CHI-6A0004
#           WHERE azi01 = sr1.curr
#          LET sr1.curr = ' ',sr1.curr   #No.FUN-580010
#          PRINT  g_x[15] CLIPPED,sr1.curr,':',
##                COLUMN 22,cl_numfor(sr1.amt,18,l_azi05);
#                 COLUMN g_c[32],cl_numfor(sr1.amt,32,t_azi05);   #No.FUN-580010   #NO.CHI-6A0004 #CHI-760004
#          IF g_cnt = 1 THEN
##No.FUN-580010  -begin
##            PRINT COLUMN 69,cl_numfor(l_rate2 ,10,t_azi07),
##                  COLUMN 81,cl_numfor(l_rate1 ,10,t_azi07),
##                  COLUMN 145,cl_numfor(l_amt1,18,g_azi05)
#             PRINT COLUMN g_c[37],cl_numfor(l_rate2 ,37,t_azi07), #CHI-760004
#                   COLUMN g_c[38],cl_numfor(l_rate1 ,38,t_azi07), #CHI-760004
#                   COLUMN g_c[42],cl_numfor(l_amt1,42,g_azi05)    #CHI-760004
##No.FUN-580010  -end
#          ELSE PRINT END IF
#          LET g_cnt = g_cnt + 1
#      END FOREACH
#      #no.5195(end)
#
#      PRINT g_dash[1,g_len]
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
##Patch....NO.TQC-610036 <> #
#No.FUN-780011  --End  
