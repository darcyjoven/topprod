# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr833.4gl
# Descriptions...: 應收票據已票貼未到期明細表列印
# Modify by .....: 03/01/03 By Kammy
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-830154 08/04/11 By destiny 報表轉為CR輸出 
#                                08/08/18 By Cockroach 5X追至5.1X
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		        # Print condition RECORD
              wc     LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(300)         #Where Condiction    
              e_date LIKE type_file.dat,        #No.FUN-680107 DATE
              s      LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
              t      LIKE type_file.chr2,       #No.FUN-680107 VARCHAR(2)
              more   LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)           #
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_head1         STRING
#No.FUN-830154-begin--                                                                                                              
DEFINE l_table        STRING                                                                                                        
DEFINE g_str          STRING                                                                                                        
DEFINE g_sql          STRING                                                                                                        
#No.FUN-830154--end--    
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
#No.FUN-830154-begin--                                                                                                              
   LET g_sql = "nmh21.nmh_file.nmh21,",                                                                                             
               "nma02.nma_file.nma02,",                                                                                             
               "nmh20.nmh_file.nmh20,",                                                                                             
               "nmh11.nmh_file.nmh11,",                                                                                             
               "nmh30.nmh_file.nmh30,",                                                                                             
               "nmh31.nmh_file.nmh31,",                                                                                             
               "nmh05.nmh_file.nmh05,",                                                                                             
               "nmh32.nmh_file.nmh32,",                                                                                             
               "nmi02.nmi_file.nmi02,",                                                                                             
               "nmh03.nmh_file.nmh03,",                                                                                             
               "azi04.azi_file.azi04,",                                                                                             
               "azi05.azi_file.azi05,",                                                                                             
               "nmh01.nmh_file.nmh01,",                                                                                             
               "nmh15.nmh_file.nmh15,",                                                                                             
               "nmh25.nmh_file.nmh25"                                                                                               
   LET l_table = cl_prt_temptable('anmr833',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                                                                           
   PREPARE insert_prep FROM g_sql                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830154--end--                     
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.t = ARG_VAL(8)   #TQC-610058
   LET tm.e_date = ARG_VAL(9)  #TQC-610058
   LET tm.s = ARG_VAL(10)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   #no.5195
#No.FUN-830154-begin--  
#   DROP TABLE curr_tmp
##FUN-680107 --start
##  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
##    amt     DEC(20,6),                   #票面金額
##    order1  VARCHAR(20)
##    );
#
#   CREATE TEMP TABLE curr_tmp(
#    curr LIKE azi_file.azi01,
#     amt LIKE type_file.num20_6,
#     order1 LIKE type_file.chr20);
##FUN-680107 --end
#No.FUN-830154-begin--  
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr833_tm()	        	# Input print condition
      ELSE CALL anmr833()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr833_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680107
          l_jmp_flag LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW anmr833_w AT p_row,p_col
        WITH FORM "anm/42f/anmr833" 
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
   LET tm.t    = '52'
   LET tm.s    = '2'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #genero版本default 排序
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "" END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.t1,tm2.t2,
                 tm.e_date,
                 tm.s,tm.more 
                 WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD e_date
         IF cl_null(tm.e_date)
             THEN NEXT FIELD e_date
         END IF
      AFTER FIELD s
         IF cl_null(tm.s) OR tm.s NOT MATCHES '[234]' THEN
           NEXT FIELD s
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr833'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr833','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",   #TQC-610058
                         " '",tm.e_date CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr833',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr833_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr833()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr833_w
END FUNCTION
 
FUNCTION anmr833()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name             #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	STRING,		# RDSQL STATEMENT        #No.FUN-680107
          l_nmi02       LIKE nmi_file.nmi02,
          l_za05	LIKE type_file.chr1000,               #標題內容      #No.FUN-680107 VARCHAR(40)
          l_cnt         LIKE type_file.num5,                  #No.FUN-680107 SMALLINT
          l_cnt1        LIKE type_file.num5,                  #No.FUN-680107 SMALLINT
          l_order       ARRAY[2] OF LIKE nmh_file.nmh01,      #No.FUN-680107 VARCHAR(10)   #排列順序
          l_i           LIKE type_file.num5,                  #No.FUN-680107 SMALLINT
          sr               RECORD 
                           order1    LIKE nmh_file.nmh01,     #No.FUN-680107    #排列順序-1
                           order2    LIKE nmh_file.nmh01,     #No.FUN-680107    #排列順序-2
                           title     LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(40)
			   g_nmh     RECORD LIKE nmh_file.*
                        END RECORD
   DEFINE l_nma02       LIKE nma_file.nma02                   #No.FUN-830154  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang                                                                   
     CALL cl_del_data(l_table)                                         #No.FUN-830154                                               
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog          #No.FUN-830154                                               
#No.FUN-830154-begin--mark    
#    #no.5195   (針對幣別加總)
#    DELETE FROM curr_tmp;
 
#    LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
#              "  WHERE order1=? ",
#              "  GROUP BY curr "
#    PREPARE tmp1_pre FROM l_sql
#    IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
#    DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
#    LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
#              "  GROUP BY curr  "
#    PREPARE tmp3_pre FROM l_sql
#    IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
#    DECLARE tmp3_cs CURSOR FOR tmp3_pre
#    #no.5195(end)
#No.FUN-830154--end--
     LET l_sql = "SELECT '','','',nmh_file.* FROM nmh_file",
                 " WHERE ",tm.wc CLIPPED,
                 "  AND  nmh04 <= '",tm.e_date,"'",
                 "  AND  (nmh35 IS NULL OR nmh35 >'",tm.e_date,"')",
                 " ORDER BY nmh21,nmh05"
 
     PREPARE anmr833_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr833_curs1 CURSOR FOR anmr833_prepare1
#     CALL cl_outnam('anmr833') RETURNING l_name                           #No.FUN-830154 
#     START REPORT anmr833_rep TO l_name                                   #No.FUN-830154 
 
#     LET g_pageno = 0                                                     #No.FUN-830154 
     FOREACH anmr833_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF sr.g_nmh.nmh35 <= tm.e_date THEN CONTINUE FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt FROM nmi_file
        WHERE nmi01 = sr.g_nmh.nmh01 AND
              nmi06 = tm.s AND nmi02 <= tm.e_date
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF
#No.FUN-830154-begin-- 
#       FOR g_i = 1 TO 2
#           CASE WHEN tm.t[g_i,g_i] = '1' LET l_order[g_i] = sr.g_nmh.nmh25
#                     USING 'yyyymmdd'
#                WHEN tm.t[g_i,g_i] = '2' LET l_order[g_i] = sr.g_nmh.nmh11
#                WHEN tm.t[g_i,g_i] = '3' LET l_order[g_i] = sr.g_nmh.nmh01
#                WHEN tm.t[g_i,g_i] = '4' LET l_order[g_i] = sr.g_nmh.nmh15
#                WHEN tm.t[g_i,g_i] = '5' LET l_order[g_i] = sr.g_nmh.nmh05
#                    USING 'yyyymmdd'
#                OTHERWISE LET l_order[g_i] = '-'
#           END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      IF cl_null(sr.order1) THEN LET sr.order1 = ' '  END IF
#      IF cl_null(sr.order2) THEN LET sr.order2 = ' '  END IF
 
#      CASE 
#         WHEN tm.s='2' LET sr.title = g_x[14]
#         WHEN tm.s='3' LET sr.title = g_x[13]
#         WHEN tm.s='4' LET sr.title = g_x[1]
#         OTHERWISE LET sr.title = ' '
#      END CASE
 
#      OUTPUT TO REPORT anmr833_rep(sr.*)
#No.FUN-830154--mark end-- 
#No.FUN-830154-add begin--
      SELECT nma02 INTO l_nma02 FROM nma_file                                                                                       
       WHERE nma01 = sr.g_nmh.nmh21                                                                                                 
      IF STATUS THEN LET l_nma02 = NULL END IF                                                                                      
      SELECT nmi02 INTO l_nmi02 FROM nmi_file                                                                                       
        WHERE nmi01 = sr.g_nmh.nmh01 AND                                                                                            
              nmi06 = '8'                                                                                                           
      IF STATUS THEN  LET l_nmi02 = null   END IF                                                                                   
      SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = sr.g_nmh.nmh03                                            
     EXECUTE insert_prep USING sr.g_nmh.nmh21,l_nma02,sr.g_nmh.nmh20,sr.g_nmh.nmh11,                                                
                               sr.g_nmh.nmh30,sr.g_nmh.nmh31,sr.g_nmh.nmh05,sr.g_nmh.nmh32,                                         
                               l_nmi02,sr.g_nmh.nmh03,t_azi04,t_azi05,sr.g_nmh.nmh01,                                               
                               sr.g_nmh.nmh15,sr.g_nmh.nmh25  
     END FOREACH
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'nmh25,nmh11,nmh01,nmh15,nmh05')                                                                       
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",tm.s,";",tm.e_date,";",tm.t[1,1],";",tm.t[2,2]                                                           
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                            
      CALL cl_prt_cs3('anmr833','anmr833',l_sql,g_str)           
#No.FUN-830154--add end--   
#No.FUN-830154--mark begin--   
#     FINISH REPORT anmr833_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT anmr833_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,     #FUN-680107 VARCHAR(1)
#         l_cnt_tot     LIKE type_file.num5,     #FUN-680107 SMALLINT
#         l_total       LIKE nmh_file.nmh32,     #DECIMAL(15,3)   #票面金額合計
#         l_nma02       LIKE nma_file.nma02,     #FUN-680107 VARCHAR(16)
#         l_count       LIKE oea_file.oea01,     #FUN-680107 VARCHAR(16)
#         l_curr        LIKE oea_file.oea01,     #FUN-680107 VARCHAR(16)
#         l_nmi02       LIKE nmi_file.nmi02,
#      #   l_azi04       LIKE azi_file.azi04,     #NO.CHI-6A0004
#         l_orderA      ARRAY[2] OF LIKE type_file.chr8,      #FUN-680107 VARCHAR(8)  #排序名稱
#         sr               RECORD 
#                          order1    LIKE nmh_file.nmh01,     #FUN-680107 VARCHAR(10) #排列順序-1
#                          order2    LIKE nmh_file.nmh01,     #FUN-680107 VARCHAR(10) #排列順序-2
#                          title     LIKE type_file.chr1000,  #FUN-680107 VARCHAR(40)
#       		   g_nmh     RECORD LIKE nmh_file.*
#                       END RECORD,
#         sr1           RECORD
#                          curr      LIKE azi_file.azi01,     #FUN-680107 #TQC-840066
#                          amt       LIKE type_file.num20_6   #FUN-680107
#                       END RECORD
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.g_nmh.nmh21,sr.order1,sr.order2  #已託貼銀行為 order first
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(sr.title))/2)+1,sr.title
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total 
#     LET g_head1=g_x[10] CLIPPED, ' ',tm.e_date
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED
#     
#     #PRINT l_dash[1,g_len]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     SELECT nma02 INTO l_nma02 FROM nma_file
#      WHERE nma01 = sr.g_nmh.nmh21
#     IF STATUS THEN LET l_nma02 = NULL END IF
#     SELECT nmi02 INTO l_nmi02 FROM nmi_file                                  
#       WHERE nmi01 = sr.g_nmh.nmh01 AND                                        
#             nmi06 = '8'   
#     IF STATUS THEN  LET l_nmi02 = null   END IF
#     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.g_nmh.nmh03   #NO.CHI-6A0004
#     PRINT COLUMN g_c[31],sr.g_nmh.nmh21,
#           COLUMN g_c[32],l_nma02,
#           COLUMN g_c[33],sr.g_nmh.nmh20,
#           COLUMN g_c[34],sr.g_nmh.nmh11,
#           COLUMN g_c[35],sr.g_nmh.nmh30,
#           COLUMN g_c[36],sr.g_nmh.nmh31,
#           COLUMN g_c[37],sr.g_nmh.nmh05,
#           COLUMN g_c[38],cl_numfor(sr.g_nmh.nmh32,38,t_azi04), #NO.CHI-6A0004
#           COLUMN g_c[39],l_nmi02
 
#     #no.5195
#     INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh32,sr.g_nmh.nmh21)
#     #no.5195(end)
#
 
#  AFTER GROUP OF sr.g_nmh.nmh21
 
#       LET l_total = GROUP SUM(sr.g_nmh.nmh32)
#       #no.5195
#       FOREACH tmp1_cs USING sr.g_nmh.nmh21 INTO sr1.*
#           SELECT azi05 INTO t_azi05 FROM azi_file  #NO.CHI-6A0004
#            WHERE azi01 = sr1.curr
#           PRINT COLUMN g_c[34],sr1.curr CLIPPED,' ',g_x[9] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(sr1.amt,38,t_azi05) CLIPPED  #NO.CHI-6A0004
#       END FOREACH
#       #no.5195(end)
#       PRINT g_dash[1,g_len]
 
#           
 
#  ON LAST ROW
#        LET l_total = SUM(sr.g_nmh.nmh02) 
#        LET l_cnt_tot  =COUNT(*) 
#        PRINT
#        LET l_count=l_cnt_tot,g_x[12] CLIPPED
#        PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#              COLUMN g_c[32],l_count;
#       #no.5195
#       FOREACH tmp3_cs INTO sr1.*
#           SELECT azi05 INTO t_azi05 FROM azi_file #NO.CHI-6A0004
#            WHERE azi01 = sr1.curr
#           LET l_curr=sr1.curr CLIPPED,' ',g_x[11] CLIPPED
#           PRINT COLUMN g_c[34],l_curr,
#                 COLUMN g_c[38],cl_numfor(sr1.amt,38,t_azi05) CLIPPED   #NO.CHI-6A0004
#       END FOREACH
#       #no.5195(end)
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
#No.FUN-830154--mark end--   
