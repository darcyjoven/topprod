# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmr832.4gl
# Descriptions...: 應收票據已託收未兌現明細表列印
# Modify By......: 03/01/03 By Kammy
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify.........: No.MOD-540160 05/05/09 By ching fix排序問題
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-640398 06/04/11 by Smapmin 修改小計部份
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-770087 07/07/18 By chenl  1.修正報表title無法打印的錯誤。
# Modify.........:                                  2.修改報表格式
# Modify.........: No.FUN-760020 07/08/03 By jamie QBE條件增加【票別一】、【票別二】供輸入.
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-830148 08/09/23 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.MOD-920120 09/02/09 By chenl 若存在重估匯率，則應該將票據金額顯示為原幣金額*重估匯率。
# Modify.........: No.TQC-970063 07/07/08 By destiny mark curr_tmp相關內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD	                       # Print condition RECORD
           wc     LIKE type_file.chr1000,    #FUN-680107 VARCHAR(300)              #Where Condiction    
           e_date LIKE type_file.dat,        #FUN-680107 DATE
           a      LIKE type_file.chr1,       #FUN-680107 VARCHAR(1)
           s      LIKE type_file.chr2,       #FUN-680107 VARCHAR(2)
           t      LIKE type_file.chr2,       #FUN-680107 VARCHAR(2)
           u      LIKE type_file.chr2,       #FUN-680107 VARCHAR(2)
           more   LIKE type_file.chr1        #FUN-680107 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5           #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_order   ARRAY[2] OF LIKE type_file.chr1000    #FUN-680107 VARCHAR(10)  #MOD-640398
DEFINE   l_table         STRING,             ### FUN-830148 ###                                                                  
         g_str           STRING,             ### FUN-830148 ###
         g_sql           STRING              ### FUN-830148 ###
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
    LET g_sql = "l_nma02.nma_file.nma02,",
                "l_nmo02.nmo_file.nmo02,",
                "l_nmo02_2.nmo_file.nmo02,",
                "nmh04.nmh_file.nmh04,",
                "nmh11.nmh_file.nmh11,",
                "nmh30.nmh_file.nmh30,",
                "nmh31.nmh_file.nmh31,",
                "nmh05.nmh_file.nmh05,",
                "nmh20.nmh_file.nmh20,",
                "nmh32.nmh_file.nmh32,",
                "nmh09.nmh_file.nmh09,",
                "nmh21.nmh_file.nmh21,",
                "nmh01.nmh_file.nmh01,",
                "nmh25.nmh_file.nmh25,",
                "nmh15.nmh_file.nmh15,",
                "nmh10.nmh_file.nmh10,",
                "nmh29.nmh_file.nmh29"
    LET l_table = cl_prt_temptable('anmr832',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                                       
                         ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)   #TQC-610058
   LET tm.t = ARG_VAL(9)   #TQC-610058
   LET tm.u = ARG_VAL(10)   #TQC-610058
   LET tm.e_date = ARG_VAL(11)   #TQC-610058
   LET tm.a = ARG_VAL(12)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   #no.5195
#   DROP TABLE curr_tmp                    #No.TQC-970063 
#FUN-680107 --start
#   CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#     amt     DEC(20,6),                   #票面金額
#     order1  VARCHAR(20),                   
#     order2  VARCHAR(20)
#    );
#No.TQC-970063--begin--mark 
#  CREATE TEMP TABLE curr_tmp(
#   curr LIKE azi_file.azi01,
#    amt LIKE type_file.num20_6,
#    order1 LIKE type_file.chr20, 
#    order2 LIKE type_file.chr20);
#No.TQC-970063--end 
#FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr832_tm()	        	# Input print condition
      ELSE CALL anmr832()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr832_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(400)
          l_jmp_flag    LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW anmr832_w AT p_row,p_col
        WITH FORM "anm/42f/anmr832" 
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
   LET tm.a    = '2'
   LET tm.s    = '65'
   LET tm.t    = '  '
   LET tm.u    = 'Y '
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
    #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
WHILE TRUE
  #CONSTRUCT BY NAME tm.wc ON nmh25,nmh11,nmh01,nmh15,nmh05,nmh21               #FUN-760020 mark
   CONSTRUCT BY NAME tm.wc ON nmh25,nmh11,nmh01,nmh15,nmh05,nmh21,nmh10,nmh29   #FUN-760020 mod
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr832_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.e_date,
                 tm.a,tm.more 
                 WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD e_date
         IF cl_null(tm.e_date)
             THEN NEXT FIELD e_date
         END IF
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN
           NEXT FIELD a
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
         IF INT_FLAG THEN EXIT INPUT END IF
         
         #MOD-540160
        LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
        LET tm.t = tm2.t1[1,1],tm2.t2[1,1]
        LET tm.u = tm2.u1[1,1],tm2.u2[1,1]
        #--
 
      
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr832_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr832'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr832','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",   #TQC-610058
                         " '",tm.t CLIPPED,"'",   #TQC-610058
                         " '",tm.u CLIPPED,"'",   #TQC-610058
                         " '",tm.e_date CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr832',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr832_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr832()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr832_w
END FUNCTION
 
FUNCTION anmr832()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680107 VARCHAR(700)
          l_nmi02       LIKE nmi_file.nmi02,
          l_za05	LIKE type_file.chr1000,       #標題內容        #No.FUN-680107 VARCHAR(40)
          l_cnt         LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cnt1        LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_order ARRAY[2] OF LIKE nmh_file.nmh01,     #FUN-680107 VARCHAR(10)   #排列順序
          l_i     LIKE type_file.num5,                 #No.FUN-680107 SMALLINT
          sr               RECORD 
                           order1    LIKE nmh_file.nmh01,     #FUN-680107 VARCHAR(10) #排列順序-1
                           order2    LIKE nmh_file.nmh01,     #FUN-680107 VARCHAR(10) #排列順序-2
                          #title     LIKE type_file.chr1,     #FUN-680107 VARCHAR(1)    #No.TQC-770087 mark
                           title     LIKE type_file.chr1000,  #No.TQC-770087 
			   g_nmh     RECORD LIKE nmh_file.*
                        END RECORD
  DEFINE l_nma02       LIKE nma_file.nma02                    #FUN-830148
  DEFINE l_nmo02       LIKE nmo_file.nmo02                    #FUN-830148
  DEFINE l_nmo02_2     LIKE nmo_file.nmo02                    #FUN-830148
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830148 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                     #FUN-830148                                       
     #------------------------------ CR (2) ------------------------------#
#No.TQC-970063--begin--mark
     #no.5195   (針對幣別加總)
#    DELETE FROM curr_tmp;
 
#    LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
#              "  WHERE order1=? ",
#              "  GROUP BY curr"
#    PREPARE tmp1_pre FROM l_sql
#    IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
#    DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
#    LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計 
#              "  WHERE order1=? ",
#              "    AND order2=? ",
#              "  GROUP BY curr  "
#    PREPARE tmp2_pre FROM l_sql
#    IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
#    DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
#    LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
#              "  GROUP BY curr  "
#    PREPARE tmp3_pre FROM l_sql
#    IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
#    DECLARE tmp3_cs CURSOR FOR tmp3_pre
#No.TQC-970063--end 
     #no.5195(end)
 
     LET l_sql = "SELECT '','','',nmh_file.* FROM nmh_file",
                 " WHERE ",tm.wc CLIPPED,
                 "  AND  nmh04 <= '",tm.e_date,"'",
                 "  AND  (nmh35 IS NULL OR nmh35 > '",tm.e_date,"')",
                 " ORDER BY nmh21,nmh05"
 
     PREPARE anmr832_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr832_curs1 CURSOR FOR anmr832_prepare1
#    CALL cl_outnam('anmr832') RETURNING l_name                                         #FUN-830148 Mark
#    START REPORT anmr832_rep TO l_name                                                 #FUN-830148 Mark
 
     LET g_pageno = 0
     FOREACH anmr832_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.g_nmh.nmh35 <= tm.e_date THEN CONTINUE FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt FROM nmi_file
        WHERE nmi01 = sr.g_nmh.nmh01 AND
              nmi06 = tm.a AND nmi02 <= tm.e_date
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF
 
      #No.MOD-920120--begin--
       IF NOT cl_null(sr.g_nmh.nmh39) THEN 
          LET sr.g_nmh.nmh32 = sr.g_nmh.nmh02 * sr.g_nmh.nmh39
       ELSE
          LET sr.g_nmh.nmh32 = sr.g_nmh.nmh02 * sr.g_nmh.nmh28
       END IF
      #No.MOD-920120---end---
 
#No.FUN-830148--Mark-Begin--#
#      FOR g_i = 1 TO 2
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.g_nmh.nmh25
#                    USING 'yyyymmdd'
#                                        LET g_order[g_i] = g_x[16]   #MOD-640398
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.g_nmh.nmh11
#                                        LET g_order[g_i] = g_x[17]   #MOD-640398
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.g_nmh.nmh01
#                                        LET g_order[g_i] = g_x[18]   #MOD-640398
#	        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.g_nmh.nmh15
#                                        LET g_order[g_i] = g_x[19]   #MOD-640398
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.g_nmh.nmh05
#                     USING 'yyyymmdd'
#                                        LET g_order[g_i] = g_x[20]   #MOD-640398
#               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.g_nmh.nmh21
#                                        LET g_order[g_i] = g_x[21]   #MOD-640398
#              #FUN-760020---add---str---
#               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.g_nmh.nmh10
#                                        LET g_order[g_i] = g_x[21]   
#               WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.g_nmh.nmh29
#                                        LET g_order[g_i] = g_x[21]   
#              #FUN-760020---add---end---
#                    OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      IF cl_null(sr.order1) THEN LET sr.order1 = ' '  END IF
#      IF cl_null(sr.order2) THEN LET sr.order2 = ' '  END IF
 
#     CASE 
#        WHEN tm.a='1' LET sr.title = g_x[15]
#        WHEN tm.a='2' LET sr.title = g_x[1]
#        WHEN tm.a='3' LET sr.title = g_x[13]
#        WHEN tm.a='4' LET sr.title = g_x[14]
#        OTHERWISE LET sr.title = ' '
#     END CASE
 
#      OUTPUT TO REPORT anmr832_rep(sr.*)
#No.FUN-830148--Mark-End--#
#No.FUN-830148--Add-Begin--#
      SELECT nma02 INTO l_nma02 FROM nma_file                                                                                       
       WHERE nma01 = sr.g_nmh.nmh21                                                                                                 
      IF STATUS THEN LET l_nma02 = NULL END IF                                                                                      
                                                                                                                                    
     #票別一                                                                                                                        
      LET l_nmo02 = ''                                                                                                              
      SELECT nmo02 INTO l_nmo02 FROM nmo_file WHERE nmo01 = sr.g_nmh.nmh10                                                          
     #票別二                                                                                                                        
      LET l_nmo02_2 = ''                                                                                                            
      SELECT nmo02 INTO l_nmo02_2 FROM nmo_file WHERE nmo01 = sr.g_nmh.nmh29
 
#      INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh32,             #No.TQC-970063                                                          
#                                  sr.order1,sr.order2)                       #No.TQC-970063
#No.FUN-830148--Add-End--#
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830148 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 l_nma02,l_nmo02,l_nmo02_2,sr.g_nmh.nmh04,sr.g_nmh.nmh11,sr.g_nmh.nmh30,
                 sr.g_nmh.nmh31,sr.g_nmh.nmh05,sr.g_nmh.nmh20,sr.g_nmh.nmh32,sr.g_nmh.nmh09,
                 sr.g_nmh.nmh21,sr.g_nmh.nmh01,sr.g_nmh.nmh25,sr.g_nmh.nmh15,sr.g_nmh.nmh10,
                 sr.g_nmh.nmh29                                         
     #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#    FINISH REPORT anmr832_rep                                               #FUN-830148 Mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                             #FUN-830148 Mark
 
#No.FUN-830148--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'nmh25,nmh11,nmh01,nmh15,nmh05,nmh21,nmh10,nmh29')                                        
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-830148--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830148 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.a,";",tm.t[1,1],";",
                tm.t[2,2],";",tm.e_date,";",tm.u[1,1],";",tm.u[2,2],";",
                g_azi05                                                                                                   
    CALL cl_prt_cs3('anmr832','anmr832',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
#No.FUN-830148-Mark--Begin--#
#REPORT anmr832_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,     #FUN-680107 VARCHAR(1)
#          l_cnt_tot     LIKE type_file.num5,     #FUN-680107 SMALLINT
#          l_total       LIKE nmh_file.nmh32,     #DECIMAL(15,3),       #票面金額合計
#          l_nma02       LIKE nma_file.nma02,     #FUN-680107 
#          l_count       LIKE oea_file.oea01,     #FUN-680107 VARCHAR(16)
#          l_curr        LIKE oea_file.oea01,     #FUN-680107 VARCHAR(16)
#          #l_azi04      LIKE azi_file.azi04,     #MOD-640398
#          l_orderA      ARRAY[2] OF LIKE type_file.chr8,      #FUN-680107 VARCHAR(8) #排序名稱
#          sr               RECORD 
#                           order1    LIKE cre_file.cre08,     #FUN-680107 VARCHAR(10) #排列順序-1
#                           order2    LIKE cre_file.cre08,     #FUN-680107 VARCHAR(10) #排列順序-2
#                           title     LIKE type_file.chr1000,  #FUN-680107 VARCHAR(40)
#			   g_nmh     RECORD LIKE nmh_file.*
#                        END RECORD,
#          sr1           RECORD
#                           curr      LIKE azi_file.azi01,     #FUN-680107 VARCHAR(4) #TQC-840066
#                           amt       LIKE type_file.num20_6   #FUN-680107 DEC(20,6)
#                        END RECORD
#  DEFINE  l_nmo02       LIKE nmo_file.nmo02,           #FUN-760020 add
#          l_nmo02_2     LIKE nmo_file.nmo02            #FUN-760020 add
#
#  OUTPUT TOP MARGIN    g_top_margin 
#         LEFT MARGIN   g_left_margin 
#         BOTTOM MARGIN g_bottom_margin 
#         PAGE LENGTH   g_page_line   #No.MOD-580242
#
#  ORDER BY sr.order1,sr.order2
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT                                                        #No.TQC-770087
#      PRINT COLUMN ((g_len-FGL_WIDTH(sr.title))/2)+1,sr.title
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#     #PRINT g_head CLIPPED,pageno_total      #No.TQC-770087 mark
#      LET g_head1=g_x[10] CLIPPED,' ',tm.e_date
#      PRINT g_head1
#      PRINT g_head CLIPPED,pageno_total      #No.TQC-770087 move here
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED  #FUN-760020 add g_x[41],g_x[42]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      SELECT nma02 INTO l_nma02 FROM nma_file
#       WHERE nma01 = sr.g_nmh.nmh21
#      IF STATUS THEN LET l_nma02 = NULL END IF
#
#     #FUN-760020---add---str---
#     #票別一
#      LET l_nmo02 = ''
#      SELECT nmo02 INTO l_nmo02 FROM nmo_file WHERE nmo01 = sr.g_nmh.nmh10
#     #票別二
#      LET l_nmo02_2 = ''
#      SELECT nmo02 INTO l_nmo02_2 FROM nmo_file WHERE nmo01 = sr.g_nmh.nmh29  
#     #FUN-760020---add---end---
#
#      #SELECT azi04 INTO l_azi04 FROM azi_file    #MOD-640398
#      #  WHERE azi01 = sr.g_nmh.nmh03   #MOD-640398
#      PRINT COLUMN g_c[31],sr.g_nmh.nmh04,
#            COLUMN g_c[32],sr.g_nmh.nmh11,
#            COLUMN g_c[33],sr.g_nmh.nmh30,
#            COLUMN g_c[34],sr.g_nmh.nmh31,
#            COLUMN g_c[35],sr.g_nmh.nmh05,
#            COLUMN g_c[36],sr.g_nmh.nmh20,
#            COLUMN g_c[37],cl_numfor(sr.g_nmh.nmh32,37,g_azi04),   #MOD-640398
#            #COLUMN g_c[38],sr.g_nmh.nmh35,   #MOD-640398
#            COLUMN g_c[38],sr.g_nmh.nmh09,   #MOD-640398
#            COLUMN g_c[39],sr.g_nmh.nmh21,
#            COLUMN g_c[40],l_nma02, 
#            COLUMN g_c[41],l_nmo02,   #FUN-760020 add
#            COLUMN g_c[42],l_nmo02_2  #FUN-760020 add
#
#      #no.5195
#      INSERT INTO curr_tmp VALUES(sr.g_nmh.nmh03,sr.g_nmh.nmh32,
#                                  sr.order1,sr.order2)
#      #no.5195(end)
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_total = GROUP SUM(sr.g_nmh.nmh32) 
#         #-----MOD-640398---------
#         PRINT COLUMN g_c[34],g_order[1] CLIPPED,' ',g_x[9] CLIPPED,
#               COLUMN g_c[37],cl_numfor(l_total,37,g_azi05) CLIPPED
#
#         ##no.5195
#         #FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#         #    SELECT azi05 INTO g_azi05 FROM azi_file
#         #     WHERE azi01 = sr1.curr
#         #    PRINT COLUMN g_c[34],sr1.curr CLIPPED,' ',g_x[9] CLIPPED,  
#         #          COLUMN g_c[37],cl_numfor(sr1.amt,37,g_azi05) CLIPPED
#         #END FOREACH
#         ##no.5195(end)
#
#         #-----END MOD-640398-----
#         PRINT g_dash[1,g_len]
#      END IF
#
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_total = GROUP SUM(sr.g_nmh.nmh32) 
#         #-----MOD-640398---------
#         PRINT COLUMN g_c[34],g_order[2] CLIPPED,' ',g_x[9] CLIPPED,
#               COLUMN g_c[37],cl_numfor(l_total,37,g_azi05) CLIPPED
#
#         ##no.5195
#         #FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#         #    SELECT azi05 INTO g_azi05 FROM azi_file
#         #     WHERE azi01 = sr1.curr
#         #    PRINT COLUMN g_c[34],sr1.curr CLIPPED,' ',g_x[9] CLIPPED,   
#         #          COLUMN g_c[37],cl_numfor(sr1.amt,37,g_azi05) CLIPPED
#         #END FOREACH
#         ##no.5195(end)
#         #-----END MOD-640398-----
#         PRINT g_dash[1,g_len]
#      END IF
#
#  ON LAST ROW
#        LET l_total   =SUM(sr.g_nmh.nmh32)
#        LET l_cnt_tot =COUNT(*) 
#        PRINT
#        LET l_count=l_cnt_tot,g_x[12] CLIPPED
#        PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#              COLUMN g_c[32],l_count;
#        #-----MOD-640398---------
#        PRINT COLUMN g_c[37],cl_numfor(l_total,37,g_azi05) CLIPPED
#        ##no.5195
#        #FOREACH tmp3_cs INTO sr1.*
#        #    SELECT azi05 INTO g_azi05 FROM azi_file
#        #     WHERE azi01 = sr1.curr
#        #    LET l_curr=sr1.curr CLIPPED,' ',g_x[9] CLIPPED
#        #    PRINT COLUMN g_c[34],l_curr, 
#        #          COLUMN g_c[37],cl_numfor(sr1.amt,37,g_azi05) CLIPPED
#        #END FOREACH
#        ##no.5195(end)
#        #-----END MOD-640398-----
#        PRINT g_dash[1,g_len]
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
#No.FUN-830148-Mark--End--#
