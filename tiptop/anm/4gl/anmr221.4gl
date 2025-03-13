# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr221.4gl
# Descriptions...: 應收票據明細表列表
# Input parameter:
# Modify by Kitty on 96/02/06 :小計位置格式調整
# Modify.........: No.FUN-4C0098 04/12/28 By pengu 報表轉XML
# Modify.........: No.MOD-580071 05/08/17 By Smapmin nmh24無 'X'的狀況,將相關判斷移除
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5A0250 05/10/21 By Smapmin 付款銀行簡稱改抓nmt02
# Modify.........: No.MOD-640034 06/04/12 By Nicola QBE及排序增加業務員欄位
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.MOD-670074 06/07/17 By Smapmin 將l_sql改為STRING,放大l_order與sr.order1,sr.order2
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-750134 07/05/30 By kim 未託收卻印出上筆托收銀行簡稱
# Modify.........: No.FUN-780011 07/08/07 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0245 10/11/29 By suncx 將 tm.wc 組入 SQL 中過濾
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			               # Print condition RECORD
              wc  LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) #Where Condiction
              c   LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)   #排列順序
              d   LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)   #跳頁否
              a   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
           more   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)   #
              END RECORD,
          l_dash	LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(132) # Dash line "-"
 
DEFINE   g_cnt    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i      LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
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
   LET tm.a  = ARG_VAL(10)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt   DEC(20,6)                    #票面金額
#   );
   CREATE TEMP TABLE curr_tmp(
     curr LIKE azi_file.azi01,
      amt LIKE type_file.num20_6)
#No.FUN-680107 --end
   CREATE UNIQUE INDEX curr_01 ON curr_tmp(curr);
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr221_tm()	        	# Input print condition
      ELSE CALL anmr221()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr221_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd        LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_jmp_flag   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr221_w AT p_row,p_col
        WITH FORM "anm/42f/anmr221"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = '3'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh25,nmh01,nmh15,nmh16   #No.MOD-640034
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr221_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.a,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]'  #No.MOD-640024
             THEN NEXT FIELD a
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
   #  ON ACTION CONTROLP CALL anmr221_wc         # Input detail where condiction
   AFTER INPUT
      LET l_jmp_flag = 'N'
      LET tm.c = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.d = tm2.t1,tm2.t2
      IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr221_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr221'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr221','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr221',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr221_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr221()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr221_w
END FUNCTION
 
FUNCTION anmr221()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
         #l_sql  VARCHAR(1200),		            # RDSQL STATEMENT   #MOD-670074     
          l_sql 	STRING,                   # RDSQL STATEMENT
          l_za05	LIKE type_file.chr1000,   #標題內容 #No.FUN-680107 VARCHAR(40)
         #l_order ARRAY[2] OF VARCHAR(10),     #排列順序 #MOD-670074
          l_order ARRAY[2] OF LIKE nmh_file.nmh01, #No.FUN-680107 ARRAY[2] OF VARCHAR(16) #排列順序   #MOD-670074
          l_i     LIKE type_file.num5,      #No.FUN-680107 SMALLINT
          sr      RECORD
                 #order1    VARCHAR(10),       #排列順序-1   #MOD-670074
                 #order2    VARCHAR(10),       #排列順序-2   #MOD-670074
                  order1    LIKE nmh_file.nmh01,  #排列順序-1   #MOD-670074
                  order2    LIKE nmh_file.nmh01,  #排列順序-2   #MOD-670074
			  g_nmh     RECORD LIKE nmh_file.*
                  END RECORD
 
     #No.FUN-780011  --Begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
     #End:FUN-980030
 
     #No.FUN-780011  --Begin
     #DELETE FROM curr_tmp; #no.5195
     LET l_sql = "SELECT nmh01,nmh02,nmh03,nmh04,nmh05,nmh06,nmh07,nmh10,nmh11,",
                 "       nmh15,nmh16,nmh21,nmh25,nmh29,nmh30,nmh31,nmt02,nma02,",
                 "       gem02,azi03,azi04,azi05 ",
"  FROM nmh_file LEFT OUTER JOIN nmt_file ",   
"  ON ((nmh_file.nmh06 = nmt_file.nmt01))  ",    
"  LEFT OUTER JOIN nma_file ON    ",        
"  ((nmh_file.nmh21 = nma_file.nma01))  ",    
"  LEFT OUTER JOIN gem_file ON    ",      
"  ((nmh_file.nmh15 = gem_file.gem01))  ",  
"  LEFT OUTER JOIN azi_file ON    ",     
"  ((nmh_file.nmh03 = azi_file.azi01))  ",   
#"  WHERE nmh24 matches '[1X]' ",     
"  AND nmh24 = 1 ",    
"  AND nmh38 <> 'X' ", 
"  WHERE ",tm.wc CLIPPED  #TQC-AB0245 
 
     IF tm.a = '1' THEN LET l_sql = l_sql CLIPPED,"  AND nmh38 = 'Y' " END IF
     IF tm.a = '2' THEN LET l_sql = l_sql CLIPPED,"  AND nmh38 = 'N' " END IF
 
     #PREPARE anmr221_prepare1 FROM l_sql
     #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
     #   EXIT PROGRAM 
     #END IF
     #DECLARE anmr221_curs1 CURSOR FOR anmr221_prepare1
     #CALL cl_outnam('anmr221') RETURNING l_name
     #START REPORT anmr221_rep TO l_name
 
     #LET g_pageno = 0
     #FOREACH anmr221_curs1 INTO sr.*
     #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #  FOR l_i = 1 TO 2
     #      CASE WHEN tm.c[l_i,l_i] = '1' LET l_order[l_i] = sr.g_nmh.nmh25
     #   					    USING 'yyyymmdd'
     #           WHEN tm.c[l_i,l_i] = '2' LET l_order[l_i] = sr.g_nmh.nmh01
     #           WHEN tm.c[l_i,l_i] = '3' LET l_order[l_i] = sr.g_nmh.nmh15
     #           WHEN tm.c[l_i,l_i] = '4' LET l_order[l_i] = sr.g_nmh.nmh16  #No.MOD-640024
     #           OTHERWISE LET l_order[l_i] = '-'
     #      END CASE
     #  END FOR
     #  LET sr.order1 = l_order[1]
     #  LET sr.order2 = l_order[2]
     #  OUTPUT TO REPORT anmr221_rep(sr.*)
 
     #END FOREACH
 
     #FINISH REPORT anmr221_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmh25,nmh01,nmh15,nmh16')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.c[1,1],";",tm.c[2,2],";",tm.d
     CALL cl_prt_cs1('anmr221','anmr221',l_sql,g_str)
     #No.FUN-780011  --End
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT anmr221_rep(sr)
#   DEFINE l_last_sw	    LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          l_gem02       LIKE gem_file.gem02,
#		      l_cnt_1       LIKE type_file.num5,   #No.FUN-680107 SMALLINT   #group 1 合計票據張數
#		      l_cnt_2       LIKE type_file.num5,   #No.FUN-680107 SMALLINT   #group 2 合計票據張數
#		      l_cnt_tot     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
##         l_nma02_1     LIKE nma_file.nma02,   #付款銀行簡稱  #MOD-5A0250
#          l_nmt02       LIKE nmt_file.nmt02,   #付款銀行簡稱  #MOD-5A0250
#          l_nma02_2     LIKE nma_file.nma02,   #託收銀行簡稱
#          l_total       LIKE nmh_file.nmh02,   #票面金額合計
#          l_orderA      ARRAY[2] OF LIKE zaa_file.zaa08,      #No.FUN-680107 ARRAY[2] OF VARCHAR(8) #排序名稱
#          sr               RECORD
#                          #order1    VARCHAR(10), #排列順序-1    #MOD-670074
#                          #order2    VARCHAR(10), #排列順序-2    #MOD-670074
#                           order1    LIKE nmh_file.nmh01,     #排列順序-1   #MOD-670074
#                           order2    LIKE nmh_file.nmh01,     #排列順序-2   #MOD-670074
#			   g_nmh     RECORD LIKE nmh_file.*
#                        END RECORD,
#          sr1           RECORD
#                           curr      LIKE azi_file.azi01,     #No.FUN-680107 VARCHAR(4)
#                           amt       LIKE type_file.num20_6   #No.FUN-680107
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.order1,sr.order2
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
#   FOR g_i = 1 TO 2
#      CASE WHEN tm.c[g_i,g_i] = '1' LET l_orderA[g_i] = g_x[12]
#           WHEN tm.c[g_i,g_i] = '2' LET l_orderA[g_i] = g_x[13]
#           WHEN tm.c[g_i,g_i] = '3' LET l_orderA[g_i] = g_x[14]
#           WHEN tm.c[g_i,g_i] = '4' LET l_orderA[g_i] = g_x[17]  #No.MOD-640024
#           OTHERWISE LET l_orderA[g_i] = ' '
#      END CASE
#   END FOR
#      LET g_head1=g_x[11] CLIPPED, l_orderA[1] CLIPPED,'-',
#            l_orderA[2] CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,
#            g_x[47] CLIPPED,g_x[48] CLIPPED,g_x[49] CLIPPED   #No.MOD-640024
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.d[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.d[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   ON EVERY ROW
#
#      SELECT azi03,azi04,azi05
#        INTO t_azi03,t_azi04,t_azi05    #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.g_nmh.nmh03
##      SELECT nma02 INTO l_nma02_1 FROM nma_file WHERE nma01=sr.g_nmh.nmh06   #MOD-5A0250
#      LET l_nmt02 = ''   #MOD-5A0250
#      SELECT nmt02 INTO l_nmt02 FROM nmt_file WHERE nmt01=sr.g_nmh.nmh06    #MOD-5A0250
#      SELECT nma02 INTO l_nma02_2 FROM nma_file WHERE nma01=sr.g_nmh.nmh21
#      #FUN-750134................begin
#      IF SQLCA.sqlcode THEN
#         LET l_nma02_2=NULL
#      END IF
#      #FUN-750134................end
#      SELECT gem02 INTO l_gem02 FROM gem_file
#      WHERE gem01 = sr.g_nmh.nmh15
#      IF l_gem02 IS NULL THEN LET l_gem02 = '-' END IF
#      PRINT COLUMN g_c[31],sr.g_nmh.nmh25,
#            COLUMN g_c[32],sr.g_nmh.nmh01,
#            COLUMN g_c[33],sr.g_nmh.nmh31,
#            COLUMN g_c[34],sr.g_nmh.nmh03,
#            COLUMN g_c[35],cl_numfor(sr.g_nmh.nmh02,35,t_azi04),  #NO.CHI-6A0004
#            COLUMN g_c[36],sr.g_nmh.nmh11,
#            COLUMN g_c[37],sr.g_nmh.nmh30,
#            COLUMN g_c[38],sr.g_nmh.nmh04,
#            COLUMN g_c[39],sr.g_nmh.nmh05,
#            COLUMN g_c[40],sr.g_nmh.nmh10,
#            COLUMN g_c[41],sr.g_nmh.nmh29,
#            COLUMN g_c[42],sr.g_nmh.nmh06,
##            COLUMN g_c[43],l_nma02_1,   #MOD-5A0250
#            COLUMN g_c[43],l_nmt02,    #MOD-5A0250
#            COLUMN g_c[44],sr.g_nmh.nmh07 CLIPPED,
#            COLUMN g_c[45],sr.g_nmh.nmh21,
#            COLUMN g_c[46],l_nma02_2,
#            COLUMN g_c[47],sr.g_nmh.nmh15,
#            COLUMN g_c[48],l_gem02,
#            COLUMN g_c[49],sr.g_nmh.nmh16   #No.MOD-640024
# 
#      #no.5195
#      SELECT COUNT(*) INTO g_cnt FROM curr_tmp WHERE curr = sr.g_nmh.nmh03
#      IF g_cnt > 0 THEN
#         UPDATE curr_tmp SET amt = amt + sr.g_nmh.nmh02
#          WHERE curr = sr.g_nmh.nmh03
#      ELSE
#          INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh02)
#      END IF
#      #no.5195(end)
#  {
#   AFTER GROUP OF sr.order1
#      IF tm.e[1,1] = 'Y' THEN
#         LET l_total = GROUP SUM(sr.g_nmh.nmh02)
#         LET l_cnt_1  = GROUP COUNT(*)
#         PRINT COLUMN 6,l_orderA[1] CLIPPED,g_x[10] CLIPPED,' ',
#               cl_numfor(l_total,13,g_azi04) CLIPPED,'  ',
#               l_cnt_1,' ',g_x[9] CLIPPED
#         PRINT g_dash2
#      END IF
#	  LET l_cnt_1 = 0
#
#   AFTER GROUP OF sr.order2
#      IF tm.e[2,2] = 'Y' THEN
#         LET l_total = GROUP SUM(sr.g_nmh.nmh02)
#         LET l_cnt_2  = GROUP COUNT(*)
#         PRINT COLUMN 6,l_orderA[2] CLIPPED,g_x[10] CLIPPED,' ',
#               cl_numfor(l_total,13,g_azi04) CLIPPED,'  ',
#               l_cnt_2,' ',g_x[9] CLIPPED
#         PRINT g_dash2   #l_dash[1,g_len]
#      END IF
#	  LET l_cnt_2 = 0
#}
#
#   ON LAST ROW
#         LET l_total = SUM(sr.g_nmh.nmh02)
#         LET l_cnt_tot  =COUNT(*)
#         PRINT
#         PRINT COLUMN g_c[31],g_x[15] CLIPPED,
#               COLUMN g_c[32],l_cnt_tot,
#               COLUMN g_c[33],g_x[16] CLIPPED;
#   #           l_total USING '##,###,###,###'
#         #no.5195
#         DECLARE tmp_cs CURSOR FOR SELECT * FROM curr_tmp
#         FOREACH tmp_cs INTO sr1.*
#             IF STATUS THEN
#                CALL cl_err('sel curr:',STATUS,1) EXIT FOREACH
#             END IF
#             SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             PRINT COLUMN g_c[34],sr1.curr CLIPPED,
#                   COLUMN g_c[35],cl_numfor(sr1.amt,35,t_azi05) CLIPPED  #NO.CHI-6A0004
#         END FOREACH
#         #no.5195(end)
#         PRINT g_dash[1,g_len]
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
