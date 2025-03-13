# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor710.4gl
# Descriptions...: 進口材料明細表
# Date & Author..: 00/05/08 By Kammy
# Modify.........: NO.MOD-490398 04/11/22 BY DAY  add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 05/02/28 BY Elva 修改數量
# Modify.........: No.MOD-580212 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-790066 07/09/11 By Judy 打印報表中，表頭在制表日期下方
# Modify.........: No.FUN-840238 08/04/30 By TSD.zeak 報表改寫由Crystal Report產出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
	      wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
 	      y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
	      more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
	      END RECORD,
	  l_order  ARRAY[2] OF LIKE qcs_file.qcs03 #No.FUN-680069 VARCHAR(10)
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
 
#FUN-840238  ---start---  
DEFINE l_table       STRING                   
DEFINE g_sql         STRING                   
DEFINE g_str         STRING                   
#FUN-840238  ----end----  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET tm.more = 'N'
#------------------No.TQC-610082 modify
  #LET tm.y = 'N'                         #MOD-490398
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#------------------No.TQC-610082 end
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   #FUN-840238  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "coc03.coc_file.coc03,",  #合同編號
	       "coc10.coc_file.coc10,",  #海關代號
	       "cod01.cod_file.cod01,",  #申請編號
	       "cod02.cod_file.cod02,",  #序號
	       "cod03.cod_file.cod03,",  #商品編號
 	       "cob09a.cob_file.cob09,",  
 	       "cob09.cob_file.cob09,",  
	       "cod041.cod_file.cod041,",
	       "cod05.cod_file.cod05,",  #申請數量
	       "codqty.cod_file.cod09,",  #出口總量
	       "cod10.cod_file.cod10,",  #加簽數量
               "con03.con_file.con03, ", 
               "con04.con_file.con04,",
               "con05.con_file.con05,",
               "con06.con_file.con06,",
               "cob02a.cob_file.cob02,",
               "cob021a.cob_file.cob021,",
               "cob02.cob_file.cob02,",
               "cob021.cob_file.cob021,",
               "coe07.coe_file.coe07,",
               "A.cod_file.cod05,",
               "Acost.cod_file.cod08,",
               "B.cod_file.cod05,",
               "Bcost.cod_file.cod08,",
               "TOT.cod_file.cod05,",
               "TOTcost.cod_file.cod08,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,"
 
   
   LET l_table = cl_prt_temptable('acor710',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-840238  ----end----  
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   INITIALIZE tm.* TO NULL                # Default condition
 
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      CALL acor710_tm(0,0)
   ELSE
      CALL acor710()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor710_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 7 LET p_col = 20
 
   OPEN WINDOW acor710_w AT p_row,p_col WITH FORM "aco/42f/acor710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
    LET tm.y = 'N'                         #MOD-490398
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
   WHILE TRUE
       CONSTRUCT BY NAME tm.wc ON coc04,coc10,coc03,coc05,cod03  #MOD-490398
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#           #CALL cl_dynamic_locale()
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
         LET INT_FLAG = 0 CLOSE WINDOW acor710_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
    INPUT BY NAME tm.y,tm.more WITHOUT DEFAULTS    #MOD-490398
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
	 IF tm.more = 'Y'
	    THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
				g_bgjob,g_time,g_prtway,g_copies)
		      RETURNING g_pdate,g_towhom,g_rlang,
				g_bgjob,g_time,g_prtway,g_copies
	 END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW acor710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	     WHERE zz01='acor710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
	 CALL cl_err('acor710','9031',1)
      ELSE
	 LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
	 LET l_cmd = l_cmd CLIPPED,
			 " '",g_pdate CLIPPED,"'",
			 " '",g_towhom CLIPPED,"'",
			 " '",g_lang CLIPPED,"'",
			 " '",g_bgjob CLIPPED,"'",
			 " '",g_prtway CLIPPED,"'",
			 " '",g_copies CLIPPED,"'",
			 " '",tm.wc CLIPPED,"'",
			 " '",tm.y CLIPPED,"'",             #No.TQC-610082 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
	 CALL cl_cmdat('acor710',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor710()
   ERROR ""
END WHILE
   CLOSE WINDOW acor710_w
END FUNCTION
 
FUNCTION acor710()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time	  LIKE type_file.chr8        #No.FUN-6A0063
	  l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
	  l_chr     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
 	  l_za05    LIKE za_file.za05,           #MOD-490398
	  l_order    ARRAY[5] OF LIKE qcs_file.qcs03,  #No.FUN-680069 VARCHAR(10)
 	  #NO.MOD-490398  --begin
          l_inserted    VARCHAR(1),
          l_cob02a       LIKE cob_file.cob02,
          l_cob021a      LIKE cob_file.cob021,
          l_cob09a       LIKE cob_file.cob09,         
	  sr            RECORD coc03  LIKE coc_file.coc03,  #合同編號
			       coc10  LIKE coc_file.coc10,  #海關代號
			       cod01  LIKE cod_file.cod01,  #申請編號
			       cod02  LIKE cod_file.cod02,  #序號
			       cod03  LIKE cod_file.cod03,  #商品編號
 			       cob09a  LIKE cob_file.cob09,  #MOD-490398
 			       cob09  LIKE cob_file.cob09,  #MOD-490398
			       cod041 LIKE cod_file.cod041,
			       cod05  LIKE cod_file.cod05,  #申請數量
			       codqty LIKE cod_file.cod09,  #出口總量
			       cod10  LIKE cod_file.cod10,  #加簽數量
 
                               con03  LIKE con_file.con03,  #
                               con04  LIKE con_file.con04,
                               con05  LIKE con_file.con05,
                               con06  LIKE con_file.con06,
                               cob02a  LIKE cob_file.cob02,
                               cob021a LIKE cob_file.cob021,
                               cob02  LIKE cob_file.cob02,
                               cob021 LIKE cob_file.cob021,
                               coe07  LIKE coe_file.coe07,
                               A      LIKE cod_file.cod05,
                               Acost  LIKE cod_file.cod08,
                               B      LIKE cod_file.cod05,
                               Bcost  LIKE cod_file.cod08,
                               TOT    LIKE cod_file.cod05,
                               TOTcost LIKE cod_file.cod08,
	                       azi03  LIKE azi_file.azi03,
                               azi04  LIKE azi_file.azi04
                        END RECORD
 	  #NO.MOD-490398  --end
     
     #FUN-840238  ---start---  
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #FUN-840238  ----end----  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740014 add ###
     #--->成品BOM
     #No.MOD-490398  --begin
     LET l_sql = "SELECT con03,con04,con05,con06 ",
		 "  FROM con_file  ",
		 " WHERE con01= ? AND con013 = ? AND con08=?"
     #No.MOD-490398  --end
     PREPARE r710_con_pre FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r710_con_cur CURSOR FOR r710_con_pre
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
	 #	 LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
	 #	 LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
	 #	 LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
     #     END IF
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
     #End:FUN-980030
 
 
     #maggie
     LET l_sql = "SELECT coc03,coc10,cod01,cod02,cod03,'',' ',cod041,cod05,", #MOD-490398
 		 #" (cod09+cod101+cod106+cod105+cod103-cod104),cod10 ", #MOD-490398 050228
 		 " (cod09+cod101+cod106-cod091-cod102-cod104),cod10, ",  #MOD-490398 050228
                 " ' ',' ',0 ,0,' ',' ',' ',' ', 0,0,0,0,0,0,0,0,0  ", #FUN-840238    
                 "  FROM cod_file,coc_file",
		 " WHERE cod01 = coc01 ",
		 "   AND cocacti = 'Y' ",
		 "   AND ",tm.wc CLIPPED,
                 " ORDER BY coc03 , cod02 "
     #end maggie
 
     PREPARE acor710_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor710_curs1 CURSOR FOR acor710_prepare1
 
     FOREACH acor710_curs1 INTO sr.*
       IF SQLCA.sqlcode  THEN
	  CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       IF cl_null(sr.codqty) THEN LET sr.codqty = 0 END IF
       IF cl_null(sr.cod10)  THEN LET sr.cod10  = 0 END IF
       
       LET l_inserted ='N'     
 
         SELECT cob02,cob021 INTO l_cob02a,l_cob021a
           FROM cob_file
          WHERE cob01 = sr.cod03
         IF SQLCA.sqlcode THEN
            LET sr.cob02a= ' '
            LET sr.cob021a = ' '
         END IF
 
         SELECT cob09 INTO l_cob09a
           FROM cob_file
          WHERE cob01=sr.cod03
  
 
       #FUN-840238  ---start---  
       FOREACH r710_con_cur USING sr.cod03,sr.cod041,sr.coc10 
                 INTO sr.con03,sr.con04,sr.con05,sr.con06
         IF SQLCA.sqlcode THEN
            CALL cl_err('r710_con_cur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         IF cl_null(sr.con06) THEN LET sr.con06 = 0 END IF
       
         SELECT cob02,cob021 INTO sr.cob02,sr.cob021
           FROM cob_file
          WHERE cob01 = sr.con03
         IF SQLCA.sqlcode THEN
            LET sr.cob02 = ' '
            LET sr.cob021 = ' '
         END IF
       
 
         SELECT coe07 INTO sr.coe07
           FROM coe_file
          WHERE coe03 = sr.con03
            AND coe01 = sr.cod01
         IF SQLCA.sqlcode THEN LET sr.coe07 = 0 END IF
         #MOD-490398(BEGIN)
         #可轉出量
         #NO.MOD-490398--050228--begin
         LET sr.A     = (sr.cod05 + sr.cod10) * (sr.con05/(1-(sr.con06/100)))
         LET sr.Acost = sr.A      * sr.coe07                  #可轉出金額
         #已轉出量
         LET sr.B     = sr.codqty* (sr.con05 /(1-(sr.con06/100)))
         LET sr.Bcost = sr.B      * sr.coe07                  #已轉出金額
         LET sr.TOT    = sr.A      - sr.B                     #未轉出量
         LET sr.TOTcost= sr.Acost  - sr.Bcost                 #未轉出金額
       
         SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=sr.con03
         LET sr.cob02a = l_cob02a
         LET sr.cob021a= l_cob021a
         LET sr.cob09a = l_cob09a     
         LET sr.azi03 = g_azi03
         LET sr.azi04 = g_azi04
         EXECUTE insert_prep USING sr.coc03, sr.coc10, sr.cod01, sr.cod02,
                                   sr.cod03, sr.cob09a,sr.cob09, sr.cod041,
                                   sr.cod05, sr.codqty, sr.cod10, 
                                   sr.con03, sr.con04, sr.con05, sr.con06,
                                   sr.cob02a,sr.cob021a,
                                   sr.cob02, sr.cob021, sr.coe07, sr.A, sr.Acost,
                                   sr.B, sr.Bcost, sr.TOT, sr.TOTcost,
                                   sr.azi03,sr.azi04
         LET l_inserted = 'Y'
       END FOREACH
      
       IF l_inserted ='N' THEN 
         LET sr.cob02a = l_cob02a
         LET sr.cob021a= l_cob021a
         LET sr.cob09a = l_cob09a     
         LET sr.azi03 = g_azi03
         LET sr.azi04 = g_azi04
          EXECUTE insert_prep USING sr.coc03, sr.coc10, sr.cod01, sr.cod02,
                                    sr.cod03, sr.cob09a,sr.cob09, sr.cod041,
                                    sr.cod05, sr.codqty, sr.cod10, 
                                    sr.con03, sr.con04, sr.con05, sr.con06,
                                    sr.cob02a,sr.cob021a,
                                    sr.cob02, sr.cob021, sr.coe07, sr.A, sr.Acost,
                                    sr.B, sr.Bcost, sr.TOT, sr.TOTcost,
                                    sr.azi03,sr.azi04
        
          IF SQLCA.sqlcode  THEN
             CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
          END IF
       END IF
 #FUN-840238  ----end----  
   
     END FOREACH
 
     #FINISH REPORT acor710_rep
 
 
     #FUN-840238  ---start---  
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'zu01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.y
     CALL cl_prt_cs3('acor710','acor710',l_sql,g_str)   
     #------------------------------ CR (4) ------------------------------#
     #FUN-840238  ----end----  
   
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END FUNCTION
#FUN-870144
