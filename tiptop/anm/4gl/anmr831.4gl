# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: anmr831.4gl
# Descriptions...: 應收票據未處理明細表列印
# Modify by      : 03/01/03 By Kammy
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-640396 06/04/11 By Smapmin 付款銀行簡稱有錯
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-830148 08/03/31 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-8A0260 08/10/30 By Sarah 銀行簡稱改抓nmt02
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc  LIKE type_file.chr1000,    #FUN-680107 VARCHAR(300)          #Where Condiction    
              e_date LIKE type_file.dat,     #FUN-680107 DATE
              more   LIKE type_file.chr1     #FUN-680107 VARCHAR(1)          #
              END RECORD,
          l_dash	LIKE type_file.chr1000     #FUN-680107 VARCHAR(132)     # Dash line "-"  
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table1        STRING               ### FUN-830148 ###
DEFINE   l_table2        STRING,              ### FUN-830148 ###                                                         
         g_str           STRING,              ### FUN-830148 ###                                                                    
         g_sql           STRING               ### FUN-830148 ###
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
 
### *** FUN-830148 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "t_azi04.azi_file.azi04,",
               #"l_nma02.nma_file.nma02,",   #MOD-8A0260 mark
                "l_nmt02.nmt_file.nmt02,",   #MOD-8A0260
                "nmh05.nmh_file.nmh05,",
                "nmh11.nmh_file.nmh11,",
                "nmh30.nmh_file.nmh30,",
                "nmh06.nmh_file.nmh06,",
                "nmh07.nmh_file.nmh07,",
                "nmh31.nmh_file.nmh31,",
                "nmh04.nmh_file.nmh04,",
                "nmh02.nmh_file.nmh02,",
                "nmh01.nmh_file.nmh01,",
                "nmh03.nmh_file.nmh03"
 
   LET l_table1 = cl_prt_temptable('anmr8311',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " curr.azi_file.azi01,",                                                                                            
               " amt.type_file.num20_6,",                                                                                            
               " t_azi05.azi_file.azi05"
   LET l_table2 = cl_prt_temptable('anmr8312',g_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
#----------------------------------------------------------CR (1) ------------#
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.e_date = ARG_VAL(8)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   DROP TABLE curr_tmp
#FUN-680107 --start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt     DEC(20,6)                    #票面金額
#   );
 
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6);
#FUN-680107 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr831_tm()	        	# Input print condition
      ELSE CALL anmr831()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr831_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(400)
          l_jmp_flag    LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW anmr831_w AT p_row,p_col
        WITH FORM "anm/42f/anmr831" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.e_date = g_today
   LET tm.more = 'N'    
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh25,nmh11,nmh01,nmh15,nmh05 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr831_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.e_date,tm.more
         WITHOUT DEFAULTS  
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD e_date
         IF cl_null(tm.e_date)
             THEN NEXT FIELD e_date
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
  
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
   AFTER INPUT
      LET l_jmp_flag = 'N' 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr831_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr831'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr831','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.e_date CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr831',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr831_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr831()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr831_w
END FUNCTION
 
FUNCTION anmr831()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680107 VARCHAR(700)
          l_za05	LIKE type_file.chr1000,              #標題內容        #No.FUN-680107 VARCHAR(40)
          l_cnt         LIKE type_file.num5,          #FUN-680107 SMALLINT
          l_cnt1        LIKE type_file.num5,          #FUN-680107 SMALLINT
          l_cntback     LIKE type_file.num5,          #FUN-680107 SMALLINT
          l_order       ARRAY[2] OF LIKE cre_file.cre08,     #FUN-680107 VARCHAR(10)  #排列順序
          l_i           LIKE type_file.num5,                 #No.FUN-680107 SMALLINT
          sr               RECORD 
			   g_nmh     RECORD LIKE nmh_file.*
                        END RECORD
   DEFINE t_azi04       LIKE azi_file.azi04           #NO.FUN-830148 
   DEFINE t_azi05       LIKE azi_file.azi05           #NO.FUN-830148                                                                         
  #DEFINE l_nma02       LIKE nma_file.nma02           #NO.FUN-830148   #MOD-8A0260 mark
   DEFINE l_nmt02       LIKE nmt_file.nmt02                            #MOD-8A0260
   DEFINE sr1           RECORD                                                                                                      
                           curr      LIKE azi_file.azi01,                  #No.FUN-830148                               
                           amt       LIKE type_file.num20_6                #No.FUN-830148                                 
                        END RECORD
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830148 *** ##
     CALL cl_del_data(l_table1)                                                                                                     
     CALL cl_del_data(l_table2)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?, ?, ?, ?, ?, ?,",                                                                          
                 "        ?, ?, ?, ?, ?, ? ) "                                                                             
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                                           
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?, ?, ? )"                                                                                       
     PREPARE insert_prep1 FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                                           
     END IF
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#------------------------CR(2)------------------------------------#
 
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #總計
               "  GROUP BY curr"
     PREPARE tmp_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp_cs CURSOR FOR tmp_pre
 
     LET l_sql = "SELECT nmh_file.* FROM nmh_file",
                 " WHERE ",tm.wc CLIPPED,
                 "  AND  nmh04 <= '",tm.e_date,"'",
                 "  AND  nmh38 = 'Y'",           
                 "  AND  (nmh35 IS NULL OR nmh35 >='",tm.e_date,"')",
                 "  ORDER BY nmh05"
 
 
     PREPARE anmr831_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr831_curs1 CURSOR FOR anmr831_prepare1
#    CALL cl_outnam('anmr831') RETURNING l_name                                        #FUN-830148 mrak
#    START REPORT anmr831_rep TO l_name                                                #FUN-830148 mrak
 
     LET g_pageno = 0
     FOREACH anmr831_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt FROM nmi_file
        WHERE nmi01 = sr.g_nmh.nmh01 AND
              nmi06 <> '1' AND nmi02 <= tm.e_date
 
       SELECT COUNT(*) INTO l_cnt1 FROM nmi_file
        WHERE nmi01 = sr.g_nmh.nmh01 AND
              nmi06 = '1' AND nmi02 <= tm.e_date
 
#No.FUN-830148--Add-Begin--#
      SELECT azi04 INTO t_azi04 FROM azi_file                                                                        
                        WHERE azi01 = sr.g_nmh.nmh03                                                                                
     #str MOD-8A0260 mod
     #銀行簡稱改抓nmt02
     #LET l_nma02 = ''
     #SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.g_nmh.nmh06
      LET l_nmt02 = ''
      SELECT nmt02 INTO l_nmt02 FROM nmt_file WHERE nmt01=sr.g_nmh.nmh06
     #end MOD-8A0260 mod
#No.FUN-830148--Add-End--#
 
       IF ( l_cnt < 1  ) AND l_cnt1 = 1 THEN
#         OUTPUT TO REPORT anmr831_rep(sr.*)                                         #FUN-830148 mrak
      INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh02)
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830148 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
             #t_azi04,l_nma02,sr.g_nmh.nmh05,sr.g_nmh.nmh11,sr.g_nmh.nmh30,   #MOD-8A0260 mark
              t_azi04,l_nmt02,sr.g_nmh.nmh05,sr.g_nmh.nmh11,sr.g_nmh.nmh30,   #MOD-8A0260
              sr.g_nmh.nmh06,sr.g_nmh.nmh07,sr.g_nmh.nmh31,sr.g_nmh.nmh04,
              sr.g_nmh.nmh02,sr.g_nmh.nmh01,sr.g_nmh.nmh03
       END IF
 
     END FOREACH
 
         FOREACH tmp_cs INTO sr1.*                                                                                                  
             SELECT azi05 INTO t_azi05 FROM azi_file                                                       
              WHERE azi01 = sr1.curr        
           EXECUTE insert_prep1 USING                                                                                                
                   sr1.curr,sr1.amt,t_azi05                                                                                        
         END FOREACH
 
#    FINISH REPORT anmr831_rep                                                        #FUN-830148 mrak
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                      #FUN-830148 mrak
#----------------------CR(3)------------------------------#                           #FUN-830148 Add                                            
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                     
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                    
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'nmh25,nmh11,nmh01,nmh15,nmh05')                                                                                    
             RETURNING tm.wc                                                                                                        
     END IF                                                                                                                         
     LET g_str = tm.wc,";",tm.e_date                                                                   
     CALL cl_prt_cs3('anmr831','anmr831',g_sql,g_str)                                                                               
#----------------------CR(3)------------------------------#
END FUNCTION
 
#FUN-830148--Mark--Begin--#
#REPORT anmr831_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,       #FUN-680107 VARCHAR(1)
#         l_count       LIKE oea_file.oea01,       #FUN-680107 VARCHAR(16)
#         l_curr        LIKE oea_file.oea01,       #FUN-680107 VARCHAR(16)
#         l_cnt_tot     LIKE type_file.num5,       #FUN-680107 SMALLINT
#         l_total       LIKE nmh_file.nmh02,       #票面金額合計
#         l_orderA      ARRAY[2] OF LIKE type_file.chr8,       #FUN-680107 VARCHAR(8)#排序名稱
#         t_azi04       LIKE azi_file.azi04, #NO.CHI-6A004
#         l_nma02       LIKE nma_file.nma02, #銀行簡稱
#         sr               RECORD 
#       		   g_nmh     RECORD LIKE nmh_file.*
#                       END RECORD,
#         sr1           RECORD
#                          curr      LIKE azi_file.azi01,     #FUN-680107 VARCHAR(4)
#                          amt       LIKE type_file.num20_6   #FUN-680107 DEC(20,6)
#                       END RECORD
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin 
#        PAGE LENGTH g_page_line   #No.MOD-580242
# ORDER BY sr.g_nmh.nmh05
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[9] CLIPPED,' ',tm.e_date
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
 
#  ON EVERY ROW
#     SELECT azi04 INTO t_azi04 FROM azi_file   #NO.CHI-6A0004
#                       WHERE azi01 = sr.g_nmh.nmh03
#     LET l_nma02 = ''   #MOD-640396
#     SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.g_nmh.nmh06
#     PRINT COLUMN g_c[31],sr.g_nmh.nmh05,
#           COLUMN g_c[32],sr.g_nmh.nmh11,
#           COLUMN g_c[33],sr.g_nmh.nmh30,
#           COLUMN g_c[34],sr.g_nmh.nmh06,
#           COLUMN g_c[35],l_nma02,
#           COLUMN g_c[36],sr.g_nmh.nmh07,
#           COLUMN g_c[37],sr.g_nmh.nmh31,
#           COLUMN g_c[38],sr.g_nmh.nmh04,
#           COLUMN g_c[39],cl_numfor(sr.g_nmh.nmh02,39,t_azi04) #NO.CHI-6A0004
#     #no.5195
#     INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh02)
#     #no.5195(end)
#           
 
#  ON LAST ROW
#        LET l_total = SUM(sr.g_nmh.nmh02) 
#        LET l_cnt_tot  =COUNT(*) 
#        PRINT
#        LET l_count=l_cnt_tot,g_x[11] CLIPPED
#        PRINT COLUMN g_c[34],g_x[10] CLIPPED,
#              COLUMN g_c[35],l_count;
#        FOREACH tmp_cs INTO sr1.*
#            SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_curr=sr1.curr CLIPPED,g_x[10] CLIPPED
#            PRINT COLUMN g_c[37],l_curr,
#                  COLUMN g_c[39],cl_numfor(sr1.amt,39,t_azi05) CLIPPED #NO.CHI-6A0004
#        END FOREACH
#        PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#FUN-830148--Mark--End--#
#FUN-870144
