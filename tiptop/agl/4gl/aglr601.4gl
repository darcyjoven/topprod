# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr601.4gl
# Descriptions...: 部門別異動碼實際預算比較表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-850027 08/06/17 By chenmoyan 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-950059 10/03/05 By huangrh sr.abb08類型無法在MSV中列印
# Modify.........: No.FUN-B20054 11/02/23 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_abb36    LIKE abb_file.abb36
   DEFINE g_abb03    LIKE abb_file.abb03
   DEFINE g_abb36_t  LIKE abb_file.abb36
   DEFINE g_abb03_t  LIKE abb_file.abb03
   DEFINE g_abbx     LIKE abb_file.abb11
 
   DEFINE tm  RECORD	    		 # Print condition RECORD
              #wc  LIKE type_file.chr1000, 
              #wc2 LIKE type_file.chr1000, 
              wc,wc2       STRING,      #NO.FUN-910082
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
   LET g_sql="abb36.abb_file.abb36,",
             "azf02.azf_file.azf02,",
             "abb05.abb_file.abb05,",
             "gem02.gem_file.gem02,",
             "abb03.abb_file.abb03,",
             "aag02.aag_file.aag02,",
             "abb06.abb_file.abb06,",
             "abb07.abb_file.abb07,",
             "abb08.abb_file.abb08,",
             "afg08.afg_file.afg08,",
             "abb11.abb_file.abb11,",
             "abb12.abb_file.abb12,",
             "abb13.abb_file.abb13,",
             "abb14.abb_file.abb14,",
             "abb31.abb_file.abb31,",
             "abb32.abb_file.abb32,",
             "abb33.abb_file.abb33,",
             "abb34.abb_file.abb34"
   LET l_table = cl_prt_temptable('aglr601',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
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
      THEN CALL r601_tm()	        	# Input print condition
      ELSE CALL r601()                          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION r601_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     
DEFINE p_row,p_col  	LIKE type_file.num5,   
       l_sw             LIKE type_file.chr1,       #重要欄位是否空白  
       l_afbacti        LIKE afb_file.afbacti,
       l_cmd	        LIKE type_file.chr1000  
DEFINE li_chk_bookno    LIKE type_file.num5       #FUN-B20054 

   CALL s_dsmark(tm.bookno)  
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r601_w AT p_row,p_col
        WITH FORM "agl/42f/aglr601"
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

   DISPLAY BY NAME tm.more 		# Condition #FUN-B20054
   WHILE TRUE
   #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
   
    CONSTRUCT BY NAME tm.wc ON abb36,abb03,abb05
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
#FUN-B20054--mark--str-- 
#      ON ACTION locale
#         CALL cl_show_fld_cont()                  
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about      
#         CALL cl_about()  
# 
#      ON ACTION help        
#         CALL cl_show_help() 
# 
#      ON ACTION controlg    
#         CALL cl_cmdask()    
# 
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
# 
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#FUN-B20054--mark--end
 
   END CONSTRUCT
#FUN-B20054--mark--str-- 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
#
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-B20054--mark--end 

  #DISPLAY BY NAME tm.more 		# Condition #FUN-B20054
  # INPUT BY NAME tm.bookno,tm.yy,tm.m1,tm.m2,tm.a WITHOUT DEFAULTS  
    INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.a 
                  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
     BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
#FUN-B20054--mark--str-- 
#      AFTER FIELD bookno                                                                                                         
#         IF tm.bookno IS NULL THEN                                                                                                 
#            NEXT FIELD bookno                                                                                                    
#         END IF                                                                                                                  
#FUN-B20054--mark--end 
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
#FUN-B20054--mark--str-- 
#        IF INT_FLAG THEN EXIT INPUT END IF
#        IF tm.bookno IS NULL THEN
#           LET l_sw = 0
#           DISPLAY BY NAME tm.bookno
#        END IF
#FUN-B20054--mark--end        
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
        
#FUN-B20054--mark--str--  
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()	# Command execution
# 
#        ON ACTION CONTROLP
# 
#        CASE                                                                                                                        
#          WHEN INFIELD(bookno)                                                                                                      
#             CALL cl_init_qry_var() 
#             LET g_qryparam.form = 'q_aaa' 
#             LET g_qryparam.default1 = tm.bookno
#             CALL cl_create_qry() RETURNING tm.bookno
#             DISPLAY BY NAME tm.bookno 
#             NEXT FIELD bookno
#           END CASE
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#  
#        ON ACTION about       
#           CALL cl_about()   
# 
#        ON ACTION help      
#           CALL cl_show_help() 
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
# 
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#FUN-B20054--mark--end
 
   END INPUT
#FUN-B20054--mark--str--   
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
#FUN-B20054--mark--end 
 
   CONSTRUCT BY NAME tm.wc2 ON abbx
       AFTER FIELD abbx
          CALL GET_FLDBUF(abbx) RETURNING g_abbx
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
#FUN-B20054--mark--str-- 
#      ON ACTION locale
#         CALL cl_show_fld_cont()                  
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about      
#         CALL cl_about()  
# 
#      ON ACTION help        
#         CALL cl_show_help() 
# 
#      ON ACTION controlg    
#         CALL cl_cmdask()    
# 
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
# 
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#FUN-B20054--mark--end 
 
   END CONSTRUCT
#FUN-B20054--mark--str--  
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
# 
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-B20054--mark--end 
   # INPUT BY NAME tm.more WITHOUT DEFAULTS   #FUN-B20054
     INPUT BY NAME tm.more ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
      BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
 #     AFTER INPUT   #FUN-B20054
 #       IF INT_FLAG THEN EXIT INPUT END IF   #FUN-B20054

#FUN-B20054--mark--str--   
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()	# Command execution
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#  
#        ON ACTION about       
#           CALL cl_about()   
# 
#        ON ACTION help      
#           CALL cl_show_help() 
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
# 
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#FUN-B20054--mark--end  
   END INPUT

  #FUN-B20054--add--str--
   ON ACTION CONTROLP
      CASE                                                                                                                        
          WHEN INFIELD(bookno)                                                                                                      
            CALL cl_init_qry_var() 
            LET g_qryparam.form = 'q_aaa' 
            LET g_qryparam.default1 = tm.bookno
            CALL cl_create_qry() RETURNING tm.bookno
            DISPLAY BY NAME tm.bookno 
            NEXT FIELD bookno
          WHEN INFIELD(abb03)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag02"
            LET g_qryparam.state = "c"
            LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO abb03
            NEXT FIELD abb03
      END CASE
   
   ON ACTION locale
      CALL cl_show_fld_cont()                  
      LET g_action_choice = "locale"
      EXIT DIALOG
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG
 
   ON ACTION about      
      CALL cl_about()  
 
   ON ACTION help        
      CALL cl_show_help() 
 
   ON ACTION controlg    
      CALL cl_cmdask() 

   ON ACTION CONTROLR
           CALL cl_show_req_fields()   

   ON ACTION exit
      LET INT_FLAG = 1
      EXIT DIALOG
 
   ON ACTION qbe_select
      CALL cl_qbe_select()

   ON ACTION accept
         EXIT DIALOG

   ON ACTION cancel
      LET INT_FLAG=1
      EXIT DIALOG
   END DIALOG
    
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  #FUN-B20054--add--end
  
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aglr601'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr601','9031',1)  
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
         CALL cl_cmdat('aglr601',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r601_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r601()
   ERROR ""
END WHILE
   CLOSE WINDOW r601_w
END FUNCTION
 
FUNCTION r601()
   DEFINE l_name    LIKE type_file.chr20,        
          #l_sql     LIKE type_file.chr1000, 
          l_sql      STRING,     #NO.FUN-910082    
          l_chr     LIKE type_file.chr1,                
          sr        RECORD 
                    abb36 LIKE abb_file.abb36,
                    abb05 LIKE abb_file.abb05,
                    abb03 LIKE abb_file.abb03,
                    abb06 LIKE abb_file.abb06,
                    abb07 LIKE abb_file.abb07,
                    abb08 LIKE abb_file.abb08,
                    abb11 LIKE abb_file.abb11,
                    abb12 LIKE abb_file.abb12,
                    abb13 LIKE abb_file.abb13,
                    abb14 LIKE abb_file.abb14,
                    abb31 LIKE abb_file.abb31,
                    abb32 LIKE abb_file.abb32,
                    abb33 LIKE abb_file.abb33,
                    abb34 LIKE abb_file.abb34,
                    aba00 LIKE aba_file.aba00,
                    aba03 LIKE aba_file.aba03,
                    aba04 LIKE aba_file.aba04
                    END RECORD
    DEFINE      l_abbx       LIKE abb_file.abb11
    DEFINE      l_azf02      LIKE azf_file.azf02      
    DEFINE      l_gem02      LIKE gem_file.gem02         
    DEFINE      l_aag02      LIKE aag_file.aag02 
    DEFINE      l_afg08      LIKE afg_file.afg08
    DEFINE      l_abb08      LIKE type_file.num20_6     #No.TQC-950059
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
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
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
    LET l_sql = "SELECT abb36,abb05,abb03,abb06,abb07,abb08,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,aba00,aba03,aba04",
                " FROM aba_file,abb_file",
                 " WHERE aba00=abb00 AND aba01=abb01 AND abapost='Y'",
                 "       AND aba00='",tm.bookno,"'",
                 "       AND aba03=",tm.yy,
                 "       AND aba04 BETWEEN ",tm.m1," AND ",tm.m2,
                 "       AND abb36 is not null",
                 "       AND abb05 is not null",
                 " AND ",tm.wc CLIPPED
    IF NOT cl_null(g_abbx) THEN
        LET l_sql=l_sql," AND ",tm.wc2 CLIPPED
    END IF
 
 
     PREPARE r601_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r601_curs CURSOR FOR r601_prepare
     
     FOREACH r601_curs INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF NOT cl_null(sr.abb36) AND NOT cl_null(sr.abb05) THEN
             IF sr.abb07 ="" THEN LET sr.abb07=0 END IF
             IF tm.a='1' THEN LET l_abbx=sr.abb11 END IF
             IF tm.a='2' THEN LET l_abbx=sr.abb12 END IF
             IF tm.a='3' THEN LET l_abbx=sr.abb13 END IF
             IF tm.a='4' THEN LET l_abbx=sr.abb14 END IF
             IF tm.a='5' THEN LET l_abbx=sr.abb31 END IF
             IF tm.a='6' THEN LET l_abbx=sr.abb32 END IF
             IF tm.a='7' THEN LET l_abbx=sr.abb33 END IF
             IF tm.a='8' THEN LET l_abbx=sr.abb34 END IF
             SELECT azf02 INTO l_azf02 FROM azf_file WHERE azf01=sr.abb36 AND azf02='2'     
             SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.abb05
             SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.abb03
             SELECT afg08 INTO l_afg08 FROM afg_file 
                    WHERE afg00=sr.aba00 AND afg01=sr.aba03 AND afg02=sr.abb36
                      AND afg03=sr.abb03 AND afg04=sr.abb05 AND afg05=tm.a
                      AND afg06=l_abbx
                      AND afg07=sr.aba04  
             IF STATUS=100 THEN LET l_afg08=0   END IF
             IF cl_null(sr.abb08) THEN LET sr.abb08=0 END IF  #No.TQC-950059
             LET l_abb08=sr.abb08                             #No.TQC-950059
             EXECUTE insert_prep USING
                sr.abb36,l_azf02,sr.abb05,l_gem02,sr.abb03,
#                l_aag02,sr.abb06,sr.abb07 ,sr.abb08,l_afg08, #No.TQC-950059
                l_aag02,sr.abb06,sr.abb07,l_abb08,l_afg08,    #No.TQC-950059
                sr.abb11, sr.abb12,sr.abb13,sr.abb14,sr.abb31,
                sr.abb32,sr.abb33,sr.abb34  
             INITIALIZE sr.* ,l_afg08,l_gem02,l_azf02,l_aag02 TO NULL         
         END IF
     END FOREACH
     
     LET g_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'abb36,abb03,abb05')
        RETURNING tm.wc
     END IF
     
     LET g_str = tm.wc,";",tm.a
     
     CALL cl_prt_cs3('aglr601','aglr601',g_sql,g_str)
 
END FUNCTION
#No.FUN-850027
