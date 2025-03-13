# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr103.4gl
# Descriptions...: 應付票據明細表列表
# Input parameter:
# Return code....:
# Date & Author..: 92/05/01 By Jones
# Modify.........: 94/06/02 By Pin  (票据資料選擇)
# Modify.........: No.FUN-4C0098 04/12/23 By pengu 報表轉XML
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 放寬變數for Unicode
# Modify.........: No.TQC-630097 06/03/09 By Pengu 該份報表列印無資料 
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-750131 07/05/30 By kim 票況說明未顯示
# Modify.........: No.FUN-770038 07/07/26 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			   # Print condition RECORD
              wc  LIKE type_file.chr1000,  #No.FUN-680107 #Where Condiction
              x   LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1) #票据資料選擇(
              c   LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2) #排列順序
              d   LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2) #跳頁否
              e   LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2) #合計否
           more   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1) #額外摘要是否列印
              END RECORD,
        g_bookno  LIKE aba_file.aba00,     #帳別編號
      # g_azi05   LIKE azi_file.azi05,     #合計小數位數
        l_dash	  LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(132) # Dash line "-"
        l_orderA  ARRAY[2] OF LIKE zaa_file.zaa08  #No.FUN-680107 ARRAY[2] OF VARCHAR(8) #排序名稱
 
DEFINE   g_cnt    LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE   g_i      LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1  STRING
DEFINE   l_table  STRING  #No.FUN-770038
DEFINE   g_str    STRING  #No.FUN-770038
DEFINE   g_sql    STRING  #No.FUN-770038
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.x  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
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
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   #No.FUN-770038  --Begin
   LET g_sql = " nmd01.nmd_file.nmd01,",
               " nmd02.nmd_file.nmd02,",
               " nmd03.nmd_file.nmd03,",
               " nmd04.nmd_file.nmd04,",
               " nmd05.nmd_file.nmd05,",
               " nmd06.nmd_file.nmd06,",
               " nmd07.nmd_file.nmd07,",
               " nmd08.nmd_file.nmd08,",
               " nmd12.nmd_file.nmd12,",
               " nmd13.nmd_file.nmd13,",
               " nmd14.nmd_file.nmd14,",
               " nmd20.nmd_file.nmd20,",
               " nmd21.nmd_file.nmd21,",
               " nmd24.nmd_file.nmd24,",
               " l_nma02.nma_file.nma02,",
               " l_nmd12.ze_file.ze03,",
               " l_nmd14.ze_file.ze03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05 "
 
   LET l_table = cl_prt_temptable('anmr103',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?  )  " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770038  --End
 
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start 欄位類型修改
#  CREATE TEMP TABLE curr_tmp                                                   
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別                                 
#    amt     DEC(20,6),                   #票面金額                             
#    order1  VARCHAR(80),                    #FUN-560011                           
#    order2  VARCHAR(80)                     #FUN-560011                           
#   );                                                  
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE nmd_file.nmd03,
     order2 LIKE nmd_file.nmd03);
#No.FUN-680107 --end
   #no.5195(end)
   #使用預設帳別之幣別
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	THEN    # If background job sw is off
      CALL anmr103_tm()	                        # Input print condition
   ELSE
      CALL anmr103()                            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr103_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd       LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
       l_jmp_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr103_w AT p_row,p_col WITH FORM "anm/42f/anmr103"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL 		   # Default condition
   LET tm.x = '3'
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
   LET tm2.u1   = tm.e[1,1]
   LET tm2.u2   = tm.e[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmd07,nmd01,nmd03,nmd06,nmd20,
                              nmd08,nmd14,nmd05,nmd12
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr103_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.x,
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD x
         IF cl_null(tm.x) OR tm.x NOT MATCHES '[123]'
             THEN NEXT FIELD x
         END IF
 
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
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
   AFTER INPUT
      LET l_jmp_flag = 'N'
      LET tm.c = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.d = tm2.t1,tm2.t2
      LET tm.e = tm2.u1,tm2.u2
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr103_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr103'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr103','9031',1)   
      ELSE
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
                         " '",tm.x CLIPPED,"'",   #TQC-610058
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr103',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr103_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr103()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr103_w
END FUNCTION
 
FUNCTION anmr103()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE nmd_file.nmd03, #No.FUN-680107 ARRAY[2] OF VARCHAR(80) #排列順序 #FUN-560011
          l_i           LIKE type_file.num5,             #No.FUN-680107 SMALLINT
          sr               RECORD
                           order1    LIKE nmd_file.nmd03,#No.FUN-680107 VARCHAR(80) #排列順序-1    #FUN-560011
                           order2    LIKE nmd_file.nmd03,#No.FUN-680107 VARCHAR(80) #FUN-560011
                           g_nmd     RECORD LIKE nmd_file.*
                        END RECORD
   #No.FUN-770038  --Begin
   DEFINE l_nmd12       LIKE ze_file.ze03,
          l_nmd14       LIKE ze_file.ze03,  
          l_nma02       LIKE nma_file.nma02
   #No.FUN-770038  --End  
 
     #No.FUN-770038  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-770038  --End  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
     #No.FUN-770038  ---Begin
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
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
     #          "  GROUP BY curr  "
     #PREPARE tmp3_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp3_cs CURSOR FOR tmp3_pre
     #No.FUN-770038  ---End  
     #no.5195(end)
     LET l_sql = "SELECT '','',nmd_file.* ",
                 " FROM nmd_file",
                 " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED
 
     IF tm.x='1'  #庫存票
       THEN LET l_sql=l_sql clipped,
                " AND (nmd15 IS NULL ) "
     END IF
     IF tm.x='2'  #已寄領
        THEN LET l_sql=l_sql clipped,
                 " AND (nmd15 IS NOT NULL) "
     END IF
 
     PREPARE anmr103_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
     END IF
     DECLARE anmr103_curs1 CURSOR FOR anmr103_prepare1
     #No.FUN-770038  --Begin
     #CALL cl_outnam('anmr103') RETURNING l_name
     #START REPORT anmr103_rep TO l_name
     #No.FUN-770038  --End  
 
     #LET g_pageno = 0
     LET g_cnt    = 1
     FOREACH anmr103_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #No.FUN-770038  --Begin
       #FOR l_i = 1 TO 2
       #    CASE WHEN tm.c[l_i,l_i] = '1'
       #              LET l_order[l_i] = sr.g_nmd.nmd07 using 'yyyymmdd'
       #              LET l_orderA[l_i] = g_x[12]
       #         WHEN tm.c[l_i,l_i] = '2' LET l_order[l_i] = sr.g_nmd.nmd01
       #              LET l_orderA[l_i] = g_x[13]
       #         WHEN tm.c[l_i,l_i] = '3' LET l_order[l_i] = sr.g_nmd.nmd03
       #              LET l_orderA[l_i] = g_x[14]
       #         WHEN tm.c[l_i,l_i] = '4' LET l_order[l_i] = sr.g_nmd.nmd06
       #              LET l_orderA[l_i] = g_x[15]
       #         WHEN tm.c[l_i,l_i] = '5' LET l_order[l_i] = sr.g_nmd.nmd20
       #              LET l_orderA[l_i] = g_x[16]
       #         WHEN tm.c[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmd.nmd08
       #              LET l_orderA[l_i] = g_x[17]
       #         WHEN tm.c[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmd.nmd14
       #              LET l_orderA[l_i] = g_x[18]
       #         WHEN tm.c[l_i,l_i] = '8'
       #              LET l_order[l_i] = sr.g_nmd.nmd05 using 'yyyymmdd'
       #              LET l_orderA[l_i] = g_x[19]
       #         WHEN tm.c[l_i,l_i] = '9' LET l_order[l_i] = sr.g_nmd.nmd12
       #              LET l_orderA[l_i] = g_x[20]
       #         OTHERWISE LET l_order[l_i] = '-'
       #    END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #IF cl_null(sr.order1) THEN LET sr.order1= ' ' END IF
       #IF cl_null(sr.order2) THEN LET sr.order2= ' ' END IF
       #OUTPUT TO REPORT anmr103_rep(sr.*)
       SELECT azi04,azi05
         INTO t_azi04,t_azi05
         FROM azi_file
        WHERE azi01=sr.g_nmd.nmd21
        SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.g_nmd.nmd03
       CALL s_nmd12(sr.g_nmd.nmd12) RETURNING l_nmd12
       LET l_nmd12=sr.g_nmd.nmd12,':',l_nmd12
       CALL s_nmd14(sr.g_nmd.nmd14) RETURNING l_nmd14
       EXECUTE insert_prep USING
               sr.g_nmd.nmd01, sr.g_nmd.nmd02, sr.g_nmd.nmd03, sr.g_nmd.nmd04,
               sr.g_nmd.nmd05, sr.g_nmd.nmd06, sr.g_nmd.nmd07,
               sr.g_nmd.nmd08, sr.g_nmd.nmd12, sr.g_nmd.nmd13,
               sr.g_nmd.nmd14, sr.g_nmd.nmd20, sr.g_nmd.nmd21,
               sr.g_nmd.nmd24, l_nma02, l_nmd12, l_nmd14, 
               t_azi04, t_azi05
       #No.FUN-770038  --End  
 
     END FOREACH
 
     #No.FUN-770038  --Begin
     #FINISH REPORT anmr103_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmd07,nmd01,nmd03,nmd06,nmd20,nmd08,nmd14,nmd05,nmd12')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.c[1,1],";",tm.c[2,2],";",tm.d,";",tm.e
     CALL cl_prt_cs3('anmr103','anmr103',g_sql,g_str)
     #No.FUN-770038  --End
END FUNCTION
 
#No.FUN-770038  --Begin
#REPORT anmr103_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#         #l_nmd12       LIKE nmd_file.nmd12,     #No.FUN-680107 VARCHAR(8) #No.TQC-5C0051      #No.TQC-630097 modify  
#          l_nmd12       LIKE ze_file.ze03, #FUN-750131
#          l_nmd14       LIKE nmd_file.nmd14,     #No.FUN-680107 VARCHAR(8) #No.TQC-5C0051      #No.TQC-630097 modify
#          l_cnt_1       LIKE type_file.num5,     #No.FUN-680107 SMALLINT #group 1 合計票據張數
#          l_cnt_2       LIKE type_file.num5,     #No.FUN-680107 SMALLINT #group 2 合計票據張數
#          l_cnt_tot     LIKE type_file.num5,     #No.FUN-680107 SMALLINT
#          l_total       LIKE nmd_file.nmd04,     #票面金額合計
#          l_nma02       LIKE nma_file.nma02,     #銀行簡稱
#          sr               RECORD
#                           order1    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80) #排列順序-1 #FUN-560011
#                           order2    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(80) #FUN-560011
#                           g_nmd     RECORD LIKE nmd_file.*
#                        END RECORD,
#          sr1           RECORD
#                           curr      LIKE azi_file.azi01,   #No.FUN-680107 VARCHAR(4)
#                           amt       LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6)
#                        END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.g_nmd.nmd07
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[11] CLIPPED, l_orderA[1] CLIPPED,'-',
#            l_orderA[2] CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.d[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.d[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#
#      SELECT azi03,azi04,azi05
#        INTO t_azi03,t_azi04,t_azi05  #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.g_nmd.nmd21
#       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.g_nmd.nmd03
#
#      CALL s_nmd12(sr.g_nmd.nmd12) RETURNING l_nmd12
#      LET l_nmd12=sr.g_nmd.nmd12,':',l_nmd12
#      CALL s_nmd14(sr.g_nmd.nmd14) RETURNING l_nmd14
#      PRINT COLUMN g_c[31],sr.g_nmd.nmd07,
#            COLUMN g_c[32],sr.g_nmd.nmd02,
#            COLUMN g_c[33],sr.g_nmd.nmd01,
#            COLUMN g_c[34],sr.g_nmd.nmd06,
#            COLUMN g_c[35],sr.g_nmd.nmd20,
#            COLUMN g_c[36],sr.g_nmd.nmd21,
#            COLUMN g_c[37],cl_numfor(sr.g_nmd.nmd04,37,t_azi04),  #NO.CHI-6A0004
#            COLUMN g_c[38],sr.g_nmd.nmd05,
#            COLUMN g_c[39],sr.g_nmd.nmd08,
#            COLUMN g_c[40],sr.g_nmd.nmd24,
#            COLUMN g_c[41],sr.g_nmd.nmd03,
#            COLUMN g_c[42],l_nma02,
#            COLUMN g_c[43],l_nmd12,
#            COLUMN g_c[44],sr.g_nmd.nmd13,
#            COLUMN g_c[45],l_nmd14 CLIPPED
#      LET l_cnt_1 = l_cnt_1 + 1
#      LET l_cnt_2 = l_cnt_2 + 1
#      LET l_cnt_tot = l_cnt_tot + 1
#      #no.5195
#      INSERT INTO curr_tmp VALUES(sr.g_nmd.nmd21,sr.g_nmd.nmd04,
#                                  sr.order1,sr.order2)
#      IF STATUS THEN 
##     CALL cl_err('ins tmp:',STATUS,1) #FUN-660148
#      CALL cl_err3("ins","curr_tmp","","",STATUS,"","ins tmp:",1) #FUN-660148
#      END IF
#      #no.5195(end)
# 
#   AFTER GROUP OF sr.order1
#      LET l_total = GROUP SUM(sr.g_nmd.nmd04)
#      IF tm.e[1,1] = 'Y' THEN
#         PRINT COLUMN 10,l_orderA[1],"  ", g_x[10] CLIPPED,
#               COLUMN 24,l_cnt_1,' ',g_x[9] CLIPPED;
#         #no.5195
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
#                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED   #NO.CHI-6A0004  
#         END FOREACH
#         #no.5195(end)
# 
#         PRINT g_dash2[1,g_len]   #l_dash[1,g_len]
#      END IF
#      LET l_cnt_1 = 0
# 
#   AFTER GROUP OF sr.order2
#      LET l_total = GROUP SUM(sr.g_nmd.nmd04)
#      IF tm.e[2,2] = 'Y' THEN
#         PRINT COLUMN 10,l_orderA[2],"  ", g_x[10] CLIPPED,
#               COLUMN 24,l_cnt_2,' ',g_x[9] CLIPPED;
#         #no.5195
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file    #NO.CHI-6A0004  
#              WHERE azi01 = sr1.curr
#             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
#                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED   #NO.CHI-6A0004  
#         END FOREACH
#         #no.5195(end)
#      END IF
#      LET l_cnt_2 = 0
# 
#   ON LAST ROW
#   #  LET l_total = SUM(sr.g_nmd.nmd04)
#      PRINT COLUMN 16,g_x[10] CLIPPED,COLUMN 24,l_cnt_tot;
#      #no.5195
#      FOREACH tmp3_cs INTO sr1.*
#          SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004  
#           WHERE azi01 = sr1.curr
#          PRINT COLUMN g_c[36],sr1.curr CLIPPED,
#                COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED   #NO.CHI-6A0004  
#      END FOREACH
#      #no.5195(end)
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_cnt_1 = 0
#      LET l_cnt_2 = 0
#      LET l_cnt_tot = 0
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],COLUMN (g_len-9),g_x[6] CLIPPED
#      #PRINT g_x[30],g_x[31]
#       PRINT g_dash2[1,g_len]
#         ELSE SKIP 3 LINE
#      END IF
#END REPORT
#No.FUN-770038  --End  
