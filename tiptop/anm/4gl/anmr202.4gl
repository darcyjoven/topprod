# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr202.4gl
# Descriptions...: 應收票據異動列印
# Input parameter:
# Modify.........: No.FUN-4C0098 04/12/26 By pengu 報表轉XML
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0068 06/11/27 By Smapmin 顯示票別說明
# Modify.........: No.FUN-710058 07/02/05 By jamie 放寬項次位數
# Modify.........: No.FUN-760018 07/08/03 By jamie QBE條件增加【票別一】、【票別二】供輸入.
# Modify.........: No.FUN-780011 07/08/07 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-780027 07/08/08 By Rayven 第二個跳頁沒有說明，分頁合計都是用一個跳頁來顯示，不直觀，增加合計選項
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				             # Print condition RECORD
              wc  LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) #Where Condiction
              c   LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2) #排列順序
              d   LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2) #跳頁否
              f   LIKE type_file.chr2,   #No.TQC-780027         #合計否
              a   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              e   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
           more   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)       
              END RECORD
          #l_dash VARCHAR(132),      # Dash line "-"
 
DEFINE   g_i      LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1  STRING
DEFINE   g_str    STRING  #No.FUN-780011
 
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
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)
   LET tm.d  = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
   LET tm.e  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET tm.f  = ARG_VAL(15)   #No.TQC-780027
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt   DEC(20,6),                   #票面金額
#    order1  VARCHAR(20),
#    order2  VARCHAR(20)
#   );
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE nmh_file.nmh01,
     order2 LIKE nmh_file.nmh01);
#No.FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr202_tm()	        	# Input print condition
      ELSE CALL anmr202()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr202_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
       l_jmp_flag     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr202_w AT p_row,p_col
        WITH FORM "anm/42f/anmr202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a ='8'
   LET tm.e ='3'
   LET tm.c = '12'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.c[1,1]
   LET tm2.s2   = tm.c[2,2]
   LET tm2.t1   = tm.d[1,1]
   LET tm2.t2   = tm.d[2,2]
   LET tm2.u1   = tm.f[1,1]    #No.TQC-780027
   LET tm2.u2   = tm.f[2,2]    #No.TQC-780027
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF  #No.TQC-780027
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF  #No.TQC-780027
WHILE TRUE
  #CONSTRUCT BY NAME tm.wc ON npn01,npn02,nmh21,nmh11,nmh10,nmh01,nmh31        #FUN-760018 mark
   CONSTRUCT BY NAME tm.wc ON npn01,npn02,nmh21,nmh11,nmh10,nmh29,nmh01,nmh31  #FUN-760018 mod
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr202_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,tm.a,tm.e,tm.more  #No.TQC-780027 add u1,u2
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12345678]'
             THEN NEXT FIELD a
         END IF
 
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES '[123]'
             THEN NEXT FIELD e
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
   #  ON ACTION CONTROLP CALL anmr202_wc         # Input detail where condiction
   AFTER INPUT
      LET l_jmp_flag = 'N'
      IF INT_FLAG THEN EXIT INPUT END IF
      LET tm.c = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.d = tm2.t1,tm2.t2
      LET tm.f = tm2.u1,tm2.u2  #No.TQC-780027
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr202_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr202'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr202','9031',1)
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
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr202',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr202_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr202()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr202_w
END FUNCTION
 
FUNCTION anmr202()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,   #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order ARRAY[2] OF LIKE nmh_file.nmh01, #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          l_i     LIKE type_file.num5,             #No.FUN-680107 SMALLINT
          sr      RECORD
                    order1   LIKE nmh_file.nmh01,  #No.FUN-680107 VARCHAR(10) #排列順序-1
                    order2   LIKE nmh_file.nmh01,  #No.FUN-680107 VARCHAR(10) #排列順序-2
			   npn01     LIKE npn_file.npn01,
			   npo02     LIKE npo_file.npo02,
			   npn02     LIKE npn_file.npn02,
			   nmh21     LIKE nmh_file.nmh21,
			   g_nmh     RECORD LIKE nmh_file.*,
			   nma02     LIKE nma_file.nma02,
         azi04     LIKE azi_file.azi04
                        END RECORD
 
     #No.FUN-780011  --Begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND npnuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND npngrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND npngrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('npnuser', 'npngrup')
     #End:FUN-980030
 
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
 
     #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
     #          "  GROUP BY curr  "
     #PREPARE tmp3_pre FROM l_sql
     #IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     #DECLARE tmp3_cs CURSOR FOR tmp3_pre
     ##no.5195(end)
 
     LET l_sql = "SELECT npn01,npo02,npn02,nmh01,nmh02,nmh03,nmh04,nmh10,",
                 "       nmh11,nmh17,nmh21,nmh29,nmh30,nmh31,a.nmo02 nmo02_1,",
                 "       b.nmo02 nmo02_2,nma02,azi04,azi05 ",
            " FROM npn_file,npo_file,",
	    " nmh_file LEFT OUTER JOIN nma_file ON nmh21 = nma01 ",
	    " LEFT OUTER JOIN azi_file ON nmh03 = azi01 ",
	    " LEFT OUTER JOIN nmo_file a ON nmh10 = a.nmo01 ",
	    " LEFT OUTER JOIN nmo_file b ON nmh29 = b.nmo01 ",
	    " WHERE npn01 = npo01 ",
	    " AND npo03 = nmh01 ",
            " AND npn03 = '",tm.a,"'",
            " AND nmh38 <> 'X' ",
	    " AND npnconf <> 'X' ",
	    " AND ",tm.wc CLIPPED
 
     IF tm.e = '1' THEN LET l_sql = l_sql CLIPPED,"  AND npnconf = 'Y' " END IF
     IF tm.e = '2' THEN LET l_sql = l_sql CLIPPED,"  AND npnconf = 'N' " END IF
 
     #PREPARE anmr202_prepare1 FROM l_sql
     #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
     #   EXIT PROGRAM 
     #END IF
     #DECLARE anmr202_curs1 CURSOR FOR anmr202_prepare1
     #CALL cl_outnam('anmr202') RETURNING l_name
     #START REPORT anmr202_rep TO l_name
 
     #LET g_pageno = 0
     #FOREACH anmr202_curs1 INTO sr.*
     #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #  FOR l_i = 1 TO 2
     #      CASE WHEN tm.c[l_i,l_i] = '1' LET l_order[l_i] = sr.npn01
     #           WHEN tm.c[l_i,l_i] = '2' LET l_order[l_i] = sr.npn02
     #                                                    USING 'yyyymmdd'
     #           WHEN tm.c[l_i,l_i] = '3' LET l_order[l_i] = sr.nmh21
     #           WHEN tm.c[l_i,l_i] = '4' LET l_order[l_i] = sr.g_nmh.nmh11
     #           WHEN tm.c[l_i,l_i] = '5' LET l_order[l_i] = sr.g_nmh.nmh10
     #          #FUN-760018---mod---str---
     #           WHEN tm.c[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmh.nmh29
     #           WHEN tm.c[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmh.nmh01
     #           WHEN tm.c[l_i,l_i] = '8' LET l_order[l_i] = sr.g_nmh.nmh31
     #          #WHEN tm.c[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmh.nmh01
     #          #WHEN tm.c[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmh.nmh31
     #          #FUN-760018---mod---end---
     #           OTHERWISE LET l_order[l_i] = '-'
     #      END CASE
     #  END FOR
     #  LET sr.order1 = l_order[1]
     #  LET sr.order2 = l_order[2]
     #  IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
     #  IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
     #  OUTPUT TO REPORT anmr202_rep(sr.*)
 
     #END FOREACH
 
     #FINISH REPORT anmr202_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'npn01,npn02,nmh21,nmh11,nmh10,nmh29,nmh01,nmh31')
             RETURNING g_str
     END IF
#    LET g_str = g_str,";",tm.c[1,1],";",tm.c[2,2],";",tm.d,";",tm.a           #No.TQC-780027 mark
     LET g_str = g_str,";",tm.c[1,1],";",tm.c[2,2],";",tm.d,";",tm.a,";",tm.f  #No.TQC-780027
     CALL cl_prt_cs1('anmr202','anmr202',l_sql,g_str)
     #No.FUN-780011  --End
 
END FUNCTION
#No.FUN-780011  --Begin
#REPORT anmr202_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,           #No.FUN-680107 VARCHAR(1)
#		      l_cnt_1   LIKE type_file.num5,   #No.FUN-680107 SMALLINT #group 1 合計票據張數
#		      l_cnt_2   LIKE type_file.num5,   #No.FUN-680107 SMALLINT #group 2 合計票據張數
#		      l_cnt_tot LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#          l_npn01     LIKE npn_file.npn01,             #No.FUN-680107 VARCHAR(16) #異動單號
#          l_total     LIKE nmh_file.nmh02,             #票面金額合計
#          l_orderA    ARRAY[2] OF LIKE zaa_file.zaa08, #No.FUN-680107 ARRAY[2] OF VARCHAR(8) #排序名稱
#          l_nmo02       LIKE nmo_file.nmo02,           #FUN-6B0068
#          l_nmo02_2     LIKE nmo_file.nmo02,           #FUN-760018 add
#          sr        RECORD
#                     order1    LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10) #排列順序-1
#                     order2    LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10) #排列順序-2
#                     npn01     LIKE npn_file.npn01,
#		     npo02     LIKE npo_file.npo02,
#		     npn02     LIKE npn_file.npn02,
#		     nmh21     LIKE nmh_file.nmh21,
#		     g_nmh     RECORD LIKE nmh_file.*,
#		     nma02     LIKE nma_file.nma02,
#                     azi04     LIKE azi_file.azi04
#                    END RECORD,
#          sr1       RECORD
#                     curr      LIKE azi_file.azi01,    #No.FUN-680107 VARCHAR(4)
#                     amt       LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6)
#                    END RECORD
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      CASE WHEN tm.a='2' LET g_x[1]=g_x[12]
#           WHEN tm.a='3' LET g_x[1]=g_x[13]
#           WHEN tm.a='4' LET g_x[1]=g_x[14]
#           WHEN tm.a='5' LET g_x[1]=g_x[15]
#           WHEN tm.a='6' LET g_x[1]=g_x[16]
#           WHEN tm.a='7' LET g_x[1]=g_x[17]
#           WHEN tm.a='8' LET g_x[1]=g_x[18]
#      END CASE
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
#   FOR g_i = 1 TO 2
#      CASE WHEN tm.c[g_i,g_i] = '1' LET l_orderA[g_i] = g_x[19]
#           WHEN tm.c[g_i,g_i] = '2' LET l_orderA[g_i] = g_x[20]
#           WHEN tm.c[g_i,g_i] = '3' LET l_orderA[g_i] = g_x[21]
#           WHEN tm.c[g_i,g_i] = '4' LET l_orderA[g_i] = g_x[22]
#           WHEN tm.c[g_i,g_i] = '5' LET l_orderA[g_i] = g_x[23]
#          #FUN-760018---mod---str---
#           WHEN tm.c[g_i,g_i] = '6' LET l_orderA[g_i] = g_x[27]
#           WHEN tm.c[g_i,g_i] = '7' LET l_orderA[g_i] = g_x[24]
#           WHEN tm.c[g_i,g_i] = '8' LET l_orderA[g_i] = g_x[25]
#          #WHEN tm.c[g_i,g_i] = '6' LET l_orderA[g_i] = g_x[24]
#          #WHEN tm.c[g_i,g_i] = '7' LET l_orderA[g_i] = g_x[25]
#          #FUN-760018---mod---end---
#           OTHERWISE LET l_orderA[g_i] = ' '
#      END CASE
#   END FOR
#      LET g_head1=g_x[26] CLIPPED, l_orderA[1] CLIPPED,'-',
#            l_orderA[2] CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED    #FUN-760018 add       
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.order1
#      IF tm.d[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order2
#      IF tm.d[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   ON EVERY ROW
#     #票別一
#     #-----FUN-6B0068---------
#      LET l_nmo02 = ''
#      SELECT nmo02 INTO l_nmo02 FROM nmo_file WHERE nmo01 = sr.g_nmh.nmh10
#     #-----END FUN-6B0068-----
#     #FUN-760018---add---str---
#     #票別二
#      LET l_nmo02_2 = ''
#      SELECT nmo02 INTO l_nmo02_2 FROM nmo_file WHERE nmo01 = sr.g_nmh.nmh29  
#     #FUN-760018---add---end---
#     #LET l_npn01=sr.npn01 CLIPPED,'-',sr.npo02 USING '&&'      #FUN-710058 mod
#      LET l_npn01=sr.npn01 CLIPPED,'-',sr.npo02 USING '&&&&&'   #FUN-710058 mod
#      PRINT COLUMN g_c[31],l_npn01,
#            COLUMN g_c[32],sr.npn02,
#            COLUMN g_c[33],sr.g_nmh.nmh01,
#            #COLUMN g_c[34],sr.g_nmh.nmh10,   #FUN-6B0068
#            COLUMN g_c[34],l_nmo02,     #FUN-6B0068
#           #FUN-760018---mod---str---
#            COLUMN g_c[35],l_nmo02_2,   #FUN-760018  add
#            COLUMN g_c[36],sr.g_nmh.nmh03,
#            COLUMN g_c[37],cl_numfor(sr.g_nmh.nmh02,37,sr.azi04),
#            COLUMN g_c[38],sr.g_nmh.nmh11,
#            COLUMN g_c[39],sr.g_nmh.nmh30,
#            COLUMN g_c[40],sr.g_nmh.nmh04,
#            COLUMN g_c[41],cl_numfor(sr.g_nmh.nmh17,41,sr.azi04),
#            COLUMN g_c[42],sr.g_nmh.nmh21,
#            COLUMN g_c[43],sr.nma02
#           #COLUMN g_c[35],sr.g_nmh.nmh03,
#           #COLUMN g_c[36],cl_numfor(sr.g_nmh.nmh02,36,sr.azi04),
#           #COLUMN g_c[37],sr.g_nmh.nmh11,
#           #COLUMN g_c[38],sr.g_nmh.nmh30,
#           #COLUMN g_c[39],sr.g_nmh.nmh04,
#           #COLUMN g_c[40],cl_numfor(sr.g_nmh.nmh17,40,sr.azi04),
#           #COLUMN g_c[41],sr.g_nmh.nmh21,
#           #COLUMN g_c[42],sr.nma02
#           #FUN-760018---mod---end---
#      #no.5195
#      INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh02,sr.order1,sr.order2)
#      #no.5195(end)
#
#   AFTER GROUP OF sr.order1
#      IF tm.d[1,1] = 'Y' THEN
#         LET l_total = GROUP SUM(sr.g_nmh.nmh02)
#         PRINT COLUMN 25,l_orderA[1] CLIPPED,g_x[9] CLIPPED;
#         #no.5195
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#            #FUN-760018---mod---str---
#             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
#                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED  #NO.CHI-6A0004 
#            #PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#            #      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED  #NO.CHI-6A0004 
#            #FUN-760018---mod---end---
#         END FOREACH
#         #no.5195(end)
#         #PRINT l_dash[1,g_len]
#          PRINT g_dash2
#      END IF
 
#   AFTER GROUP OF sr.order2
#      IF tm.d[2,2] = 'Y' THEN
#         LET l_total = GROUP SUM(sr.g_nmh.nmh02)
#         PRINT COLUMN 25,l_orderA[1] CLIPPED,g_x[9] CLIPPED;
#         #no.5195
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004 
#              WHERE azi01 = sr1.curr
#            #FUN-760018---mod---str---
#             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
#                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED  #NO.CHI-6A0004 
#            #PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#            #      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED  #NO.CHI-6A0004 
#            #FUN-760018---mod---end---
#         END FOREACH
#         #no.5195(end)
#        # PRINT l_dash[1,g_len]
#          PRINT g_dash2
#      END IF
 
#   ON LAST ROW
#         LET l_total = SUM(sr.g_nmh.nmh02)
#         PRINT
#         PRINT COLUMN 33,g_x[9] CLIPPED;
#         #no.5195
#         FOREACH tmp3_cs INTO sr1.*
#             SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004 
#              WHERE azi01 = sr1.curr
#            #FUN_760018---mod---str---
#             PRINT COLUMN g_c[36],sr1.curr CLIPPED,
#                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05) CLIPPED  #NO.CHI-6A0004 
#            #PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#            #      COLUMN g_c[36],cl_numfor(sr1.amt,36,t_azi05) CLIPPED  #NO.CHI-6A0004 
#            #FUN_760018---mod---end---
#         END FOREACH
#         #no.5195(end)
#         #PRINT l_dash[1,g_len]
#         PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780011  --End
