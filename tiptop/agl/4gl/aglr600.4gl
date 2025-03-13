# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglr600.4gl
# Descriptions...: 異動碼實際預算比較表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-850027 08/06/10 By douzh 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B90171 11/09/22 By Polly 寫入 temp file 時,將 sr.abb11 改為 l_abbx
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_abb36    LIKE abb_file.abb36
   DEFINE g_abb03    LIKE abb_file.abb03
   DEFINE g_abb36_t  LIKE abb_file.abb36
   DEFINE g_abb03_t  LIKE abb_file.abb03
   DEFINE g_abbx     LIKE abb_file.abb11
 
   DEFINE tm  RECORD	    		 # Print condition RECORD
             # wc  LIKE type_file.chr1000,  
             # wc2 LIKE type_file.chr1000,  
              wc,wc2    STRING,    #NO.FUN-910082
              bookno LIKE afb_file.afb00, #帳別
              yy  LIKE aah_file.aah02,    #輸入年度
              m1  LIKE aah_file.aah03,    #期別起
              m2  LIKE aah_file.aah03,    #期別止
              a   LIKE type_file.chr1,  
              more	LIKE type_file.chr1     #Input more condition(Y/N) 
              END RECORD 
  
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 
DEFINE   g_sql           STRING                 
DEFINE   g_str           STRING                
DEFINE   l_table         STRING               
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql="abb36.abb_file.abb36,azf03.azf_file.azf03,desc1.aff_file.aff05,",
             "abb03.abb_file.abb03,aag02.aag_file.aag02,desc2.aff_file.aff06,",
             "amt_a.aff_file.aff09,amt_b.aff_file.aff09,amt_c.aff_file.aff09"
   LET l_table = cl_prt_temptable('aglr600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET tm.bookno = ARG_VAL(1)  
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.yy = ARG_VAL(9)
   LET tm.m1 = ARG_VAL(10)
   LET tm.m2 = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.a  = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16) 
 
   IF cl_null(tm.bookno) THEN
      LET tm.bookno = g_aza.aza81
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r600_tm()	        	# Input print condition
      ELSE CALL r600()                          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION r600_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     
DEFINE p_row,p_col  	LIKE type_file.num5,   
       l_sw             LIKE type_file.chr1,       #重要欄位是否空白  
       l_afbacti        LIKE afb_file.afbacti,
       l_cmd	        LIKE type_file.chr1000  
 
   CALL s_dsmark(tm.bookno)  
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r600_w AT p_row,p_col
        WITH FORM "agl/42f/aglr600"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(0,0,tm.bookno) 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
 
   LET tm.bookno = g_aza.aza81
   LET tm.yy = YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_sw = 1
 
   #使用預設帳別之幣別
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM aaa_file,azi_file
		  WHERE aaa01 = tm.bookno AND aaa03 = azi01  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file,azi_file",tm.bookno,"",SQLCA.sqlcode,"","",0) 
   END IF
 
   WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON abb36,abb03
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION locale
         CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()    
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.bookno,tm.yy,tm.m1,tm.m2,tm.a WITHOUT DEFAULTS  
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bookno                                                                                                         
         IF tm.bookno IS NULL THEN                                                                                                 
            NEXT FIELD bookno                                                                                                    
         END IF                                                                                                                  
 
      AFTER FIELD yy
         IF tm.yy IS NULL OR tm.yy = 0 THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD m1
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
         IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
 
      AFTER FIELD m2
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
            IF NOT cl_null(tm.m1) THEN
               IF tm.m2 < tm.m1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
         IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
 
      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF tm.bookno IS NULL THEN
           LET l_sw = 0
           DISPLAY BY NAME tm.bookno
        END IF
        IF tm.yy IS NULL THEN
           LET l_sw = 0
           DISPLAY BY NAME tm.yy
        END IF
        IF tm.m1 IS NULL THEN
           LET l_sw = 0
           DISPLAY BY NAME tm.m1
        END IF
        IF tm.m2 IS NULL THEN
           LET l_sw = 0
           DISPLAY BY NAME tm.m2
        END IF
        IF l_sw = 0 THEN
           LET l_sw = 1
           NEXT FIELD bookno
           CALL cl_err('',9033,0)
        END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()	# Command execution
 
        ON ACTION CONTROLP
 
        CASE                                                                                                                        
          WHEN INFIELD(bookno)                                                                                                      
             CALL cl_init_qry_var() 
             LET g_qryparam.form = 'q_aaa' 
             LET g_qryparam.default1 = tm.bookno
             CALL cl_create_qry() RETURNING tm.bookno
             DISPLAY BY NAME tm.bookno 
             NEXT FIELD bookno
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about       
           CALL cl_about()   
 
        ON ACTION help      
           CALL cl_show_help() 
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
 
   CONSTRUCT BY NAME tm.wc2 ON abbx
 
      AFTER FIELD abbx
         CALL GET_FLDBUF(abbx) RETURNING g_abbx
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION locale
         CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()    
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.more WITHOUT DEFAULTS  
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()	# Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about       
           CALL cl_about()   
 
        ON ACTION help      
           CALL cl_show_help() 
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aglr600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr600','9031',1)  
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",tm.bookno CLIPPED,"'",  
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.m2 CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",     
                         " '",g_rep_user CLIPPED,"'",  
                         " '",g_rep_clas CLIPPED,"'", 
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"  
         CALL cl_cmdat('aglr600',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r600()
   ERROR ""
END WHILE
   CLOSE WINDOW r600_w
END FUNCTION
 
FUNCTION r600()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT            
	  l_flag	LIKE type_file.num5,  		#判斷是否有預算資料        
          l_chr		LIKE type_file.chr1,           
          l_za05	LIKE za_file.za05,            
	  l_debit		   LIKE abb_file.abb07,				#借方金額
	  l_credit		   LIKE abb_file.abb07,				#貸方金額
          sr            RECORD
                        abb36      LIKE  abb_file.abb36,    #預算項目
                        azf03      LIKE  azf_file.azf03,    #預算說明
                        aff05      LIKE  aff_file.aff05,    #異動碼別
                        abb03      LIKE  abb_file.abb03,    #科目編號
                        aag02      LIKE  aag_file.aag02,    #科目名稱
                        aff06      LIKE  aff_file.aff06,    #異動碼值
                        abb07      LIKE  abb_file.abb07,    #借貸金額
                        abb11      LIKE  abb_file.abb11,
                        abb12      LIKE  abb_file.abb12,
                        abb13      LIKE  abb_file.abb13,
                        abb14      LIKE  abb_file.abb14,
                        abb31      LIKE  abb_file.abb31,
                        abb32      LIKE  abb_file.abb32,
                        abb33      LIKE  abb_file.abb33,
                        abb34      LIKE  abb_file.abb34,
                        aba00      LIKE  aba_file.aba00,
                        aba03      LIKE  aba_file.aba03,
                        aba04      LIKE  aba_file.aba04
                        END RECORD
DEFINE l_abbx          LIKE abb_file.abb11
DEFINE l_azf03         LIKE azf_file.azf03 
DEFINE l_aag02         LIKE aag_file.aag02 
DEFINE l_afg08         LIKE afg_file.afg08
DEFINE l_dec           LIKE afg_file.afg08
DEFINE l_sum1          LIKE abb_file.abb07
DEFINE l_sum2          LIKE abb_file.abb07
 
     CALL cl_del_data(l_table)                       
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno    
			AND aaf02 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN  
     #         LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     IF tm.a MATCHES '[12345678]' THEN
        IF tm.a='1' THEN LET tm.wc2="abb11='",g_abbx,"'" END IF
        IF tm.a='2' THEN LET tm.wc2="abb12='",g_abbx,"'" END IF
        IF tm.a='3' THEN LET tm.wc2="abb13='",g_abbx,"'" END IF
        IF tm.a='4' THEN LET tm.wc2="abb14='",g_abbx,"'" END IF
        IF tm.a='5' THEN LET tm.wc2="abb31='",g_abbx,"'" END IF
        IF tm.a='6' THEN LET tm.wc2="abb32='",g_abbx,"'" END IF
        IF tm.a='7' THEN LET tm.wc2="abb33='",g_abbx,"'" END IF
        IF tm.a='8' THEN LET tm.wc2="abb34='",g_abbx,"'" END IF
    ELSE 
        LET tm.wc2=""
    END IF
 
    LET l_sql = "SELECT abb36,'',aff05,abb03,'',aff06,abb07,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,aba00,aba03,aba04",
                " FROM aba_file,abb_file,aff_file",
                 " WHERE aba00=abb00 AND aba01=abb01 AND abapost='Y'",
                 "       AND aba00='",tm.bookno,"'",
                 "       AND aba03=",tm.yy,
                 "       AND aba04 BETWEEN ",tm.m1," AND ",tm.m2,
                 "       AND aff00=aba00",
                 "       AND aff01=aba03",
                 "       AND aff02=abb36",
                 "       AND aff03=abb03",
                 "       AND aff04=abb05",
                 "       AND aff05= '",tm.a,"'",
                 " AND ",tm.wc CLIPPED 
     IF NOT cl_null(g_abbx) THEN
        LET l_sql=l_sql," AND ",tm.wc2 CLIPPED
     END IF
 
     PREPARE r600_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('p1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r600_c1 CURSOR FOR r600_p1
 
     FOREACH r600_c1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         #本期預計消耗預算----> 借方
         SELECT SUM(abb07) INTO l_sum1 FROM aba_file,abb_file
                WHERE aba00 = abb00 
                  AND aba01 = abb01 
                  AND abb00 = tm.bookno
                  AND abb03 = sr.abb03
                  AND aba03 = tm.yy
                  AND aba04 BETWEEN tm.m1 AND tm.m2
                  AND abb36 = sr.abb36
                  AND abb06 = '1'
                  AND abapost='Y'
                  AND abaacti='Y' 
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('p2:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
 
         #本期預計消耗預算----> 貸方
         SELECT SUM(abb07) INTO l_sum2 FROM aba_file,abb_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND abb00 = tm.bookno
            AND abb03 = sr.abb03
            AND aba03 = tm.yy
            AND aba04 BETWEEN tm.m1 AND tm.m2
            AND abb36 = sr.abb36
            AND abb06 = '2'
            AND abapost='Y'
            AND abaacti='Y'
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('p3:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         IF cl_null(l_sum1) THEN LET l_sum1=0 END IF 
         IF cl_null(l_sum2) THEN LET l_sum2=0 END IF 
         LET sr.abb07=l_sum1-l_sum2
         IF sr.abb07 ="" THEN LET sr.abb07=0 END IF
         IF tm.a='1' THEN LET l_abbx=sr.abb11 END IF
         IF tm.a='2' THEN LET l_abbx=sr.abb12 END IF
         IF tm.a='3' THEN LET l_abbx=sr.abb13 END IF
         IF tm.a='4' THEN LET l_abbx=sr.abb14 END IF
         IF tm.a='5' THEN LET l_abbx=sr.abb31 END IF
         IF tm.a='6' THEN LET l_abbx=sr.abb32 END IF
         IF tm.a='7' THEN LET l_abbx=sr.abb33 END IF
         IF tm.a='8' THEN LET l_abbx=sr.abb34 END IF
         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.abb36 AND azf02='2'     
         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag00=sr.aba00 AND aag01=sr.abb03
         SELECT SUM(afg08) INTO l_afg08 FROM afg_file 
                WHERE afg00=sr.aba00 AND afg01=sr.aba03 AND afg02=sr.abb36
                  AND afg03=sr.abb03 AND afg05=tm.a
                  AND afg06=l_abbx
                  AND afg07 BETWEEN tm.m1 AND tm.m2
         IF cl_null(l_afg08) THEN LET l_afg08=0   END IF
         LET l_dec = sr.abb07 - l_afg08
         EXECUTE insert_prep USING
             sr.abb36,l_azf03,sr.aff05,sr.abb03,
             l_aag02,l_abbx,sr.abb07,l_afg08,l_dec      #MOD-B90171 sr.abb11改l_abbx
            #l_aag02,sr.abb11,sr.abb07,l_afg08,l_dec    #MOD-B90171 mark
         INITIALIZE sr.* ,l_afg08,l_azf03,l_aag02 TO NULL         
     END FOREACH
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
 
     LET g_str = tm.wc,";",tm.a
 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aglr600','aglr600',l_sql,g_str)
END FUNCTION
#No.FUN-850027
