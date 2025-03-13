# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gglr313.4gl
# Descriptions...: 明細分類(幣別)帳 
# Input parameter:
# Return code....:
# Date & Author..: 08/11/07 By douzh
# Modify.........: No.MOD-860252 09/02/20 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-C40076 12/04/12 By Lujh 修改報表無法打印的問題
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc1	STRING,			
                wc2     STRING,                 # Where condition
   		t    	LIKE type_file.chr1,    # none trans print (Y/N) ?
   		x    	LIKE type_file.chr1,    # Eject sw/獨立打印否 
                e       LIKE type_file.chr1,    #
                k       LIKE type_file.chr1,    # 
                h       LIKE type_file.chr1,    #No.MOD-860252
   		more	LIKE type_file.chr1     # Input more condition(Y/N)
             END RECORD,
        yy,mm           LIKE type_file.num10,   #
        mm1,nn1         LIKE type_file.num10,   #
        bdate,edate     LIKE type_file.dat,     #
        l_flag          LIKE type_file.chr1,    #
        bookno          LIKE aaa_file.aaa01,    
        g_cnnt          LIKE type_file.num5     
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose
DEFINE   l_table         STRING                 
DEFINE   g_str           STRING                 
DEFINE   g_sql           STRING                 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET bookno = ARG_VAL(1)     
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc1 = ARG_VAL(8)
   LET tm.wc2 = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.x  = ARG_VAL(11)
   LET tm.k  = ARG_VAL(14)
   LET bdate = ARG_VAL(15)  
   LET edate = ARG_VAL(16) 
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET tm.e  = ARG_VAL(20) 
   LET g_rpt_name = ARG_VAL(21) 
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81 
   END IF
   IF cl_null(tm.h) THEN LET tm.h = 'Y' END IF #No.MOD-860252
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno         
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
   IF SQLCA.sqlcode THEN 
         CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  
   END IF
 
   LET g_sql = " aea05.aea_file.aea05,",
               " aea02.aea_file.aea02,",
               " aea03.aea_file.aea03,",
               " aea04.aea_file.aea04,",
               " aba04.aba_file.aba04,",
               " aba02.aba_file.aba02,",
               " abb04.abb_file.abb04,",
               " abb24.abb_file.abb24,",      #TQC-C40076  add
               " abb06.abb_file.abb06,",
               #" abb24.abb_file.abb24,",     #TQC-C40076  mark
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " aag02.type_file.chr1000,",
               " qcye.abb_file.abb07,",
               " l_abb071.abb_file.abb07,",
               " l_abb072.abb_file.abb07,",
               " l_tah04.abb_file.abb07,",
               " l_tah05.abb_file.abb07,",
               " type.type_file.chr1    "
 
   LET l_table = cl_prt_temptable('gglr313',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?)          "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglr313_tm()	        	# Input print condition
      ELSE CALL gglr313()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr313_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    
          l_i           LIKE type_file.num5,    
          l_cmd		LIKE type_file.chr1000  
   DEFINE li_chk_bookno LIKE type_file.num5        #FUN-B20010
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01        #FUN-B20010
   CALL s_dsmark(bookno)         
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW gglr313_w AT p_row,p_col
        WITH FORM "ggl/42f/gglr313"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(0,0,bookno)   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET bookno = g_aza.aza81     #FUN-B20010
   LET bdate   = g_today
   LET edate   = g_today
   LET tm.t    = 'N'
   LET tm.x    = 'N'
   LET tm.e    = 'N'
   LET tm.k  = '1'            
   LET tm.h  = 'Y'        #No.MOD-860252
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
   #No.FUN-B20010  --Begin
   DIALOG ATTRIBUTE(unbuffered)
   INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)   
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD bookno
         IF NOT cl_null(bookno) THEN
   	       CALL s_check_bookno(bookno,g_user,g_plant) 
                RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
                NEXT FIELD bookno
            END IF
            SELECT aaa02 FROM aaa_file WHERE aaa01 = bookno
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",bookno,"","agl-043","","",0)
               NEXT FIELD bookno 
            END IF
         END IF
     
    END INPUT
    
    #No.FUN-B20010  --End
     CONSTRUCT BY NAME tm.wc1 ON aag01
##No.FUN-B20010  --Mark Begin
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()               
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
#       
#       ON ACTION CONTROLP                                                     
#            CASE                                                                
#                WHEN INFIELD(aag01)                                             
#                  CALL cl_init_qry_var()                                        
#                  LET g_qryparam.state= "c"                                     
#                  LET g_qryparam.form = "q_aag"   
#                  LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
#                  DISPLAY g_qryparam.multiret TO aag01                          
#                  NEXT FIELD aag01                                              
#               OTHERWISE                                                        
#                  EXIT CASE                                                     
#            END CASE
#     
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
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
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#No.FUN-B20010  --Mark End
  END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW gglr313_w EXIT PROGRAM
#     END IF
#No.FUN-B20010  --Mark End
     CONSTRUCT BY NAME tm.wc2 ON aba11
#No.FUN-B20010  --Mark Begin
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
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
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#No.FUN-B20010  --Mark End
     END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#     IF INT_FLAG THEN
#         LET INT_FLAG = 0 CLOSE WINDOW gglr313_w EXIT PROGRAM
#     END IF
#     #DISPLAY BY NAME tm.t,tm.x,tm.e,tm.k,tm.more 
#No.FUN-B20010  --Mark End
     #INPUT BY NAME bookno,bdate,edate,tm.t,tm.x,tm.e,tm.h,tm.k,tm.more  #No.MOD-860252 add tm.h #FUN-B20010 mark
      INPUT BY NAME bdate,edate,tm.t,tm.x,tm.e,tm.h,tm.k,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)  #No.FUN-B20010 去掉bookno
         # WITHOUT DEFAULTS
 
          BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)  #FUN-B20010 
          AFTER FIELD bdate
             IF cl_null(bdate) THEN
                NEXT FIELD bdate
             END IF
          AFTER FIELD edate
             IF cl_null(edate) THEN
                LET edate =g_lastdat
             ELSE
                IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF
             END IF
             IF edate < bdate THEN
                CALL cl_err(' ','agl-031',0)
                NEXT FIELD edate
             END IF
          AFTER FIELD t
             IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF
          AFTER FIELD x
             IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
          AFTER FIELD k
             IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]'
             THEN NEXT FIELD k END IF
          AFTER FIELD more
             IF tm.more = 'Y'
                THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
             END IF
 
#No.FUN-B20010  --Mark Begin 
#          AFTER INPUT
#             IF INT_FLAG THEN
#                EXIT INPUT
#             END IF
################################################################################
# START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################

#       ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#       ON IDLE g_idle_seconds
#      
#
#       ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(bookno) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_aaa'
#               LET g_qryparam.default1 =bookno
#               CALL cl_create_qry() RETURNING bookno
#	       DISPLAY BY NAME bookno
#	       NEXT FIELD bookno
#         END CASE
#
#      
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#          ON ACTION about        
#             CALL cl_about()      
# 
#          ON ACTION help          
#             CALL cl_show_help()  
#        
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#No.FUN-B20010  --Mark End
    END INPUT
    ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bookno) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 =bookno
               CALL cl_create_qry() RETURNING bookno
	             DISPLAY BY NAME bookno
	             NEXT FIELD bookno
	          WHEN INFIELD(aag01)                                             
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.state= "c"                                     
                  LET g_qryparam.form = "q_aag"   
                  LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  DISPLAY g_qryparam.multiret TO aag01                          
                  NEXT FIELD aag01                                              
               OTHERWISE 
                  EXIT CASE     
         END CASE
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
            
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION help          
             CALL cl_show_help()  
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG 
            
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
         LET INT_FLAG = 0
         CLOSE WINDOW gglr313_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
     
      #No.FUN-B20010  --End
   
    LET mm1 = MONTH(bdate)
    LET nn1 = MONTH(edate)
 
    SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
        WHERE zz01='gglr313'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglr313','9031',1)   
       ELSE
          LET tm.wc1=cl_wcsub(tm.wc1)
          LET l_cmd = l_cmd CLIPPED,
                     " '",bookno CLIPPED,"'",    
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_rlang CLIPPED,"'", 
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc1 CLIPPED,"'",
                     " '",tm.wc2 CLIPPED,"'",  
                     " '",tm.t CLIPPED,"'",
                     " '",tm.x CLIPPED,"'",
                     " '",tm.e CLIPPED,"'",  
                     " '",tm.h CLIPPED,"'",     #No.MOD-860252
                    " '",tm.k CLIPPED,"'",   
                    " '",bdate CLIPPED,"'",  
                    " '",edate CLIPPED,"'",  
                    " '",g_rep_user CLIPPED,"'",
                    " '",g_rep_clas CLIPPED,"'",
                    " '",g_template CLIPPED,"'",
                    " '",g_rpt_name CLIPPED,"'" 
          CALL cl_cmdat('gglr313',g_time,l_cmd)	# Execute cmd at later time
       END IF
       CLOSE WINDOW gglr313_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr313()
    ERROR ""
   END WHILE
   CLOSE WINDOW gglr313_w
END FUNCTION
 
FUNCTION gglr313()
   DEFINE l_name     	   LIKE type_file.chr20,     # External(Disk) file name
          l_sql,l_sql1 	   LIKE type_file.chr1000,   # RDSQL STATEMENT
          l_aea03          LIKE type_file.chr5,    
          l_bal,l_bal2     LIKE type_file.num20_6, 
          s_abb07,s_abb07f LIKE type_file.num20_6, 
          l_za05	   LIKE type_file.chr1000, 
          l_date,l_date1   LIKE aba_file.aba02,    
          p_aag02          LIKE type_file.chr1000, 
          l_i              LIKE type_file.num5,    
          l_creid          LIKE abb_file.abb07,  
          l_creidf         LIKE abb_file.abb07f, 
          l_debit          LIKE abb_file.abb07,  
          l_debitf         LIKE abb_file.abb07f, 
          sr1    RECORD
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    aag08  LIKE aag_file.aag08,
                    aag07  LIKE aag_file.aag07,
                    aag24  LIKE aag_file.aag24,
                    abb24  LIKE abb_file.abb24
                 END RECORD,
          sr     RECORD
                    aea05  LIKE aea_file.aea05,
                    aea02  LIKE aea_file.aea02,
                    aea03  LIKE aea_file.aea03,
                    aea04  LIKE aea_file.aea04,
                    aba04  LIKE aba_file.aba04,
                    aba02  LIKE aba_file.aba02,
                    abb04  LIKE abb_file.abb04,
                    abb24  LIKE abb_file.abb24,     #TQC-C40076  add
                    abb06  LIKE abb_file.abb06,
                    #abb24  LIKE abb_file.abb24,    #TQC-C40076  mark
                    abb07  LIKE abb_file.abb07,
                    abb07f LIKE abb_file.abb07f,
                    aag02  LIKE type_file.chr1000,
                    qcye   LIKE abb_file.abb07
                 END RECORD
  DEFINE l_abb071,l_abb072   LIKE type_file.num20_6
  DEFINE l_tah04,l_tah05     LIKE type_file.num20_6 
  DEFINE l_tah09,l_tah10     LIKE type_file.num20_6 
  DEFINE t_tah04,t_tah05     LIKE type_file.num20_6 
  DEFINE t_tah09,t_tah10     LIKE type_file.num20_6 
  DEFINE l_abb07f1,l_abb07f2 LIKE type_file.num20_6 
  DEFINE l_year              LIKE type_file.num10
  DEFINE l_month             LIKE type_file.num10
 
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
     #No.FUN-B80096--mark--End-----
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno  
	AND aaf02 = g_lang
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #群組權限
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     LET l_sql1= "SELECT aag01,aag02,aag08,aag07,aag24,abb24 ",
                 "  FROM aag_file,abb_file ",
                 " WHERE aag03 ='2' AND aag07 IN ('2','3')",
                 "   AND aag00 = '",bookno,"' ",     
                 "   AND aag01 = abb03 ",     
                 "   AND ",tm.wc1 CLIPPED
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql1 = l_sql1," AND aag09 = 'Y' "
     END IF 
     #No.MOD-860252---end---
     PREPARE gglr313_prepare2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr313_curs2 CURSOR FOR gglr313_prepare2
 
     #modify 030901 NO.A085
     IF tm.k = '3' THEN
        LET l_sql = "SELECT aea05,aea02,aea03,aea04,aba04,",
                    #"       aba02,abb04,abb06,abb24,",   #TQC-C40076  mark
                    "       aba02,abb04,abb24,abb06,",    #TQC-C40076  add
                    "       abb07,abb07f,'',''",
                    "  FROM aea_file,aba_file,abb_file ",
                    " WHERE aea05 =  ? ",
                    "   AND aea00 = '",bookno,"' ", 
                    "   AND aea00 = aba00 ",
                    "   AND aba00 = abb00 ",
                    "   AND aba01 = abb01 ",
                    "   AND abb03 = aea05 ",
                    "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
                    "   AND abb01 = aea03 AND abb02 = aea04 ",
                    "   AND aba01 = aea03",
                    "   AND abapost = 'Y' ",
                    "   AND aba04 = ? ",
                    "   AND abb24 = ? ",
                    "   AND ",tm.wc2 CLIPPED
     ELSE
        LET l_sql = "SELECT abb03,aba02,abb01,abb02,aba04,",
                    "       aba02,abb04,abb06,",
                    "       abb07,abb07f,'',''",
                    "  FROM aba_file,abb_file ",
                    " WHERE abb03 =  ? ",
                    "   AND abb00 = '",bookno,"' ",
                    "   AND aba00 = abb00 ",
                    "   AND aba01 = abb01 ",
                    "   AND aba02 BETWEEN '",bdate,"' AND '",edate,"' ",
                    "   AND abaacti='Y' ",
                    "   AND aba19 <> 'X' ",  #CHI-C80041
                    "   AND aba04 = ? ",
                    "   AND abb24 = ? ",
                    "   AND ",tm.wc2 CLIPPED
     END IF
     IF tm.k = '2' THEN
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
     END IF
     IF tm.k = '3' THEN
        LET l_sql = l_sql CLIPPED," ORDER BY aea05,aba04,aea02,aea03,aea04 "
     ELSE
        LET l_sql = l_sql CLIPPED," ORDER BY abb03,aba04,aba02,abb01,abb02 "
     END IF
     PREPARE gglr313_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr313_curs1 CURSOR FOR gglr313_prepare1
 
     LET l_name = 'gglr313'
     FOREACH gglr313_curs2 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF tm.x = 'N' AND sr1.aag07 = '3' THEN CONTINUE FOREACH END IF
        CALL gglr313_qcye(sr1.aag01,sr1.abb24)      #期初余額(依幣別)
             RETURNING l_bal,l_bal2
        #計算tm.k=1/2時的期初余額
        IF tm.k = '1' THEN
           SELECT SUM(abb07) INTO l_debit
             FROM abb_file,aba_file
            WHERE abb00 = aba00
              AND abb01 = aba01
              AND aba00 = bookno    
              AND abb03 = sr1.aag01
              AND aba02 < bdate
              AND aba03 = yy
              AND abb06 ='1'
              AND abapost ='N'
              AND abaacti ='Y'
              AND aba19 <> 'X'  #CHI-C80041
              AND abb24 = sr1.abb24
           SELECT SUM(abb07) INTO l_creid
             FROM abb_file,aba_file
            WHERE abb00 = aba00
              AND abb01 = aba01
              AND aba00 = bookno             
              AND abb03 = sr1.aag01
              AND aba02 < bdate
              AND aba03 = yy
              AND abb06 ='2'
              AND abapost ='N'
              AND abaacti ='Y'
              AND aba19 <> 'X'  #CHI-C80041
              AND abb24 = sr1.abb24
           IF l_debit IS NULL THEN LET l_debit = 0 END IF
           IF l_debitf IS NULL THEN LET l_debitf = 0 END IF
           IF l_creid IS NULL THEN LET l_creid = 0 END IF
           IF l_creidf IS NULL THEN LET l_creidf = 0 END IF
           LET l_bal = l_bal+l_debit - l_creid
           LET l_bal2 = l_bal2 + l_debitf - l_creidf
        END IF
        IF tm.k = '2' THEN
           SELECT SUM(abb07) INTO l_debit
             FROM abb_file,aba_file
            WHERE abb00 = aba00
              AND abb01 = aba01
              AND aba00 = bookno     
              AND abb03 = sr1.aag01
              AND aba02 < bdate
              AND aba03 = yy
              AND abb06 ='1'
              AND abapost ='N'
              AND aba19   ='Y'
              AND abaacti ='Y'
              AND abb24 = sr1.abb24
           SELECT SUM(abb07) INTO l_creid
             FROM abb_file,aba_file
            WHERE abb00 = aba00
              AND abb01 = aba01
              AND aba00 = bookno    
              AND abb03 = sr1.aag01
              AND aba02 < bdate
              AND aba03 = yy
              AND abb06 ='2'
              AND abapost ='N'
              AND aba19   = 'Y'
              AND abaacti ='Y'
              AND abb24=sr1.abb24
           IF l_debit IS NULL THEN LET l_debit = 0 END IF
           IF l_debitf IS NULL THEN LET l_debitf = 0 END IF
           IF l_creid IS NULL THEN LET l_creid = 0 END IF
           IF l_creidf IS NULL THEN LET l_creidf = 0 END IF
           LET l_bal = l_bal+l_debit - l_creid
           LET l_bal2 = l_bal2 + l_debitf - l_creidf
        END IF
 #計算有沒有期間異動
        IF tm.k ='1' THEN
           SELECT SUM(abb07) INTO s_abb07 FROM abb_file,aba_file
            WHERE abb03 = sr1.aag01 AND aba01 = abb01
              AND abb00 = aba00     AND aba00 = bookno
              AND aba02 >= bdate    AND aba02 <= edate
              AND aba03=yy
              AND abaacti='Y'
              AND aba19 <> 'X'  #CHI-C80041
              AND abb24=sr1.abb24
        END IF
        IF tm.k ='2' THEN
           SELECT SUM(abb07) INTO s_abb07 FROM abb_file,aba_file
            WHERE abb03 = sr1.aag01 AND aba01 = abb01
              AND abb00 = aba00     AND aba00 = bookno 
              AND aba02 >= bdate    AND aba02 <= edate
              AND aba03=yy
              AND abaacti='Y'       AND aba19='Y'
              AND abb24=sr1.abb24
        END IF
        IF tm.k ='3' THEN
           SELECT SUM(abb07) INTO s_abb07 FROM abb_file,aba_file
            WHERE abb03 = sr1.aag01 AND aba01 = abb01
              AND abb00 = aba00     AND aba00 = bookno  
              AND aba02 >= bdate    AND aba02 <= edate
              AND aba03=yy
              AND abapost='Y'
              AND abb24=sr1.abb24
        END IF
        IF cl_null(s_abb07) THEN LET s_abb07 = 0 END IF
        IF cl_null(s_abb07f) THEN LET s_abb07f = 0 END IF
        IF l_bal = 0 AND s_abb07 = 0 AND s_abb07f = 0 THEN CONTINUE FOREACH END IF
        FOR l_i = mm1 TO nn1
            LET g_cnt = 0
            LET l_flag='N'
            FOREACH gglr313_curs1 USING sr1.aag01,l_i,sr1.abb24 INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02 = l_date1
               LET l_flag='Y'
               LET sr.aag02=sr1.aag02
#              LET sr.aag08=sr1.aag08
               LET sr.qcye = l_bal
#              LET sr.qcye1 = l_bal2
               IF sr1.aag07 = '3' THEN
#                 LET sr.aag08 = ''
               ELSE
                  IF tm.e = 'Y' THEN                                            
                     SELECT aag13 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24   AND aag00 = bookno       
                  ELSE                                                          
                     SELECT aag02 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24  AND aag00 = bookno       
                  END IF                                                        
                  LET sr.aag02 = p_aag02
               END IF
               SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
                WHERE azi01 = sr.abb24
               EXECUTE insert_prep USING sr.*,'0','0','0','0','0'  
               IF sr.abb06 = "1" THEN                      #計算當月的借貸余額
                  LET l_bal = l_bal + sr.abb07
                  LET l_bal2 = l_bal2 + sr.abb07f
               ELSE
                  LET l_bal = l_bal - sr.abb07
                  LET l_bal2 = l_bal2 - sr.abb07f
               END IF
            END FOREACH
            IF l_flag = "N" AND (l_bal <> 0 OR tm.t = 'Y') THEN  #當期沒異動
               LET sr.aea05=sr1.aag01      #但是前期有結余或者沒有異動資料
               LET sr.aea02=NULL           #需要列印
               LET sr.aag02=sr1.aag02
#              LET sr.aag08= sr1.aag08
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02 = l_date1
               LET sr.qcye = l_bal
#              LET sr.qcye1 = l_bal2
#              LET sr.abb25 = 1
               LET sr.aba04 = l_i
               LET sr.abb07=0
               LET sr.abb07f = 0
               IF sr1.aag07 = '3' THEN
#                 LET sr.aag08 = ''
               ELSE
                  IF tm.e = 'Y' THEN                                            
                     SELECT aag13 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24  AND aag00 = bookno   
                  ELSE                                                          
                     SELECT aag02 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24  AND aag00 = bookno  
                  END IF
                  LET sr.aag02 = p_aag02
               END IF
               LET l_flag = 'Y'
               SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
                WHERE azi01 = sr.abb24
               EXECUTE insert_prep USING sr.*,'0','0','0','0','0'
            END IF
            IF l_flag = 'Y' THEN 
               CALL s_yp(edate) RETURNING l_year,l_month
               IF l_i = l_month THEN
                  LET sr.aba02 = edate
               END IF
               CALL r313_cr(sr1.aag01,l_i,sr1.abb24) RETURNING l_abb07f1,l_abb071,
                    l_abb07f2,l_abb072,l_tah09,l_tah04,l_tah10,l_tah05
               EXECUTE insert_prep USING sr.*,l_abb071,l_abb072,l_tah04,l_tah05,'1'
            END IF
        END FOR
     END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc1,'aag01')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",yy,";",tm.e,";",bdate USING "yyyy/mm/dd" ,";",g_azi04
     CALL cl_prt_cs3('gglr313',l_name,g_sql,g_str)
     #No.FUN-B80096--mark--Begin---    
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
FUNCTION gglr313_qcye(p_aag01,p_abb24)   #計算列印期間前的余額
   DEFINE p_aag01 LIKE aag_file.aag01
   DEFINE p_abb24 LIKE abb_file.abb24
   DEFINE l_bal,l_bal1,l_bal2,n_bal,n_bal1,l_d,l_c,l_d1,l_c1 LIKE type_file.num20_6 
   LET l_bal = 0
   LET l_bal1 = 0
   LET l_d = 0
   LET l_d1 = 0
   LET l_c = 0
   LET l_c1 = 0
   LET n_bal = 0
   LET n_bal1 = 0
   IF g_aaz.aaz51 = 'Y' THEN   #每日餘額檔
      SELECT SUM(tah04-tah05) INTO l_bal FROM tah_file
       WHERE tah01 = p_aag01 AND tah02 = yy AND tah03 = 0
         AND tah00 = bookno  AND tah08 = p_abb24
      SELECT SUM(tas04-tas05) INTO l_bal1   FROM tas_file
       WHERE tas00 = bookno AND tas01 = p_aag01  
         AND YEAR(tas02) = yy AND tas02 < bdate
         AND tas08 = p_abb24
   ELSE
      SELECT SUM(tah04-tah05) INTO l_bal FROM tah_file
       WHERE tah01 = p_aag01 AND tah02 = yy AND tah03 < mm
         AND tah00 = bookno  AND tah08 = p_abb24  
      SELECT SUM(abb07) INTO l_d FROM abb_file,aba_file
       WHERE abb03 = p_aag01 AND aba01 = abb01 AND abb06='1'
         AND aba02 < bdate AND abb00 = aba00
         AND aba00 = bookno AND abapost='Y'
         AND aba03=yy AND aba04=mm
         AND aab24 = p_abb24
      SELECT SUM(abb07) INTO l_c FROM aba_file,abb_file
       WHERE abb03 = p_aag01 AND aba01 = abb01 AND abb06='2'
         AND aba02 < bdate AND abb00 = aba00
         AND aba00 = bookno AND abapost='Y' 
         AND aba03=yy AND aba04=mm
         AND aab24 = p_abb24
   END IF
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   IF cl_null(l_bal1) THEN LET l_bal1 = 0 END IF
   IF cl_null(n_bal) THEN LET n_bal = 0 END IF
   IF cl_null(n_bal1) THEN LET n_bal1 = 0 END IF
   IF cl_null(l_d) THEN LET l_d = 0 END IF
   IF cl_null(l_c) THEN LET l_c = 0 END IF
   IF cl_null(l_d1) THEN LET l_d1 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   LET l_bal = l_bal + l_d - l_c + l_bal1   # 期初餘額
   LET l_bal2 = n_bal + l_d1 - l_c1 + n_bal1
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   IF cl_null(l_bal2) THEN LET l_bal2 = 0 END IF
   RETURN l_bal,l_bal2
END FUNCTION
 
FUNCTION r313_cr(p_aea05,p_aba04,p_abb24)
  DEFINE p_aea05             LIKE aea_file.aea05
  DEFINE p_aba04             LIKE aba_file.aba04
  DEFINE p_abb24             LIKE abb_file.abb24
  DEFINE l_abb071,l_abb072   LIKE type_file.num20_6
  DEFINE l_tah04,l_tah05     LIKE type_file.num20_6 
  DEFINE l_tah09,l_tah10     LIKE type_file.num20_6 
  DEFINE t_tah04,t_tah05     LIKE type_file.num20_6 
  DEFINE t_tah09,t_tah10     LIKE type_file.num20_6 
  DEFINE l_abb07f1,l_abb07f2 LIKE type_file.num20_6 
  DEFINE m_abb071,m_abb072   LIKE type_file.num20_6
  DEFINE m_abb07f1,m_abb07f2 LIKE type_file.num20_6
  DEFINE m_tah04,m_tah05     LIKE type_file.num20_6
  DEFINE m_tah09,m_tah10     LIKE type_file.num20_6
 
      LET l_abb07f1 = 0    LET l_abb071 = 0
      LET l_abb07f2 = 0    LET l_abb072 = 0
      LET l_tah09   = 0    LET l_tah04  = 0
      LET l_tah10   = 0    LET l_tah05  = 0
      SELECT SUM(abb07) INTO l_abb071 FROM abb_file,aba_file #借 當期
       WHERE abb03 = p_aea05 AND aba01 = abb01 AND abb06='1'
         AND abb00 = aba00
         AND aba02 >= bdate   AND aba02 <= edate
         AND aba00 = bookno AND abapost='Y'   
         AND aba03=yy AND aba04=p_aba04
         AND abb24=p_abb24
      SELECT SUM(abb07) INTO l_abb072 FROM abb_file,aba_file #貸 當期
       WHERE abb03 = p_aea05 AND aba01 = abb01 AND abb06='2'
         AND abb00 = aba00
         AND aba02 >= bdate   AND aba02 <= edate
         AND aba00 = bookno AND abapost='Y'  
         AND aba03=yy AND aba04=p_aba04
         AND abb24=p_abb24
      SELECT SUM(abb07) INTO l_tah04 FROM abb_file,aba_file #借 本年
       WHERE abb03 = p_aea05 AND aba01 = abb01
         AND abb00 = aba00 AND aba00 = bookno 
         AND aba03 = yy AND aba04 <=p_aba04
         AND aba02 <= edate
         AND abapost='Y' AND abb06='1'
         AND abb24=p_abb24
      SELECT SUM(abb07) INTO l_tah05 FROM abb_file,aba_file #貸 本年
       WHERE abb03 = p_aea05 AND aba01 = abb01
         AND abb00 = aba00 AND aba00 = bookno    
         AND aba03 = yy AND aba04 <=p_aba04
         AND aba02 <= edate
         AND abapost='Y' AND abb06='2'
         AND abb24=p_abb24
 
      IF cl_null(l_abb071) THEN LET l_abb071 =0 END IF
      IF cl_null(l_abb072) THEN LET l_abb072 =0 END IF
      IF cl_null(l_abb07f1) THEN LET l_abb07f1 =0 END IF
      IF cl_null(l_abb07f2) THEN LET l_abb07f2 =0 END IF
      IF cl_null(l_tah04) THEN LET l_tah04 =0 END IF
      IF cl_null(l_tah05) THEN LET l_tah05 =0 END IF
      IF cl_null(l_tah09) THEN LET l_tah09 =0 END IF
      IF cl_null(l_tah10) THEN LET l_tah10 =0 END IF
 
      IF tm.k ='1' THEN
         SELECT SUM(abb07) INTO m_abb071
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno  
            AND aba02 >=bdate  AND aba02 <=edate
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19 <> 'X'  #CHI-C80041
            AND abb03  = p_aea05
            AND abb06 ='1'
            AND aba03 =yy AND aba04 =p_aba04
            AND abb24=p_abb24
         SELECT SUM(abb07) INTO m_abb072
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno   
            AND aba02 >=bdate  AND aba02 <=edate
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19 <> 'X'  #CHI-C80041
            AND abb03  = p_aea05
            AND abb06 ='2'
            AND aba03 =yy AND aba04 =p_aba04
            AND abb24=p_abb24
         SELECT SUM(abb07) INTO m_tah04
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno   
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19 <> 'X'  #CHI-C80041
            AND abb03  = p_aea05
            AND abb06 ='1'
            AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
            AND abb24=p_abb24
         SELECT SUM(abb07) INTO m_tah05
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno  
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19 <> 'X'  #CHI-C80041
            AND abb03  = p_aea05
            AND abb06 ='2'
            AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
            AND abb24=p_abb24
      IF m_abb071 IS NULL THEN LET m_abb071 = 0 END IF
         IF m_abb072 IS NULL THEN LET m_abb072 = 0 END IF
         IF m_abb07f1 IS NULL THEN LET m_abb07f1 =0 END IF
         IF m_abb07f2 IS NULL THEN LET m_abb07f2 =0 END IF
         IF m_tah04  IS NULL THEN LET m_tah04 = 0 END IF
         IF m_tah05  IS NULL THEN LET m_tah05 = 0 END IF
         IF m_tah09  IS NULL THEN LET m_tah09 = 0 END IF
         IF m_tah10  IS NULL THEN LET m_tah10 = 0 END IF
         LET l_abb071 = l_abb071 + m_abb071
         LET l_abb072 = l_abb072 + m_abb072
         LET l_abb07f1 = l_abb07f1 + m_abb07f1
         LET l_abb07f2 = l_abb07f2 + m_abb07f2
         LET l_tah04   = l_tah04 + m_tah04
         LET l_tah05   = l_tah05 + m_tah05
         LET l_tah09   = l_tah09 + m_tah09
         LET l_tah10   = l_tah10 + m_tah10
      END IF
      IF tm.k ='2' THEN
         SELECT SUM(abb07) INTO m_abb071
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno    
            AND aba02 >=bdate  AND aba02 <=edate
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19   ='Y'
            AND abb03  = p_aea05
            AND abb06 ='1'
            AND aba03 =yy AND aba04 =p_aba04
            AND abb24=p_abb24
         SELECT SUM(abb07) INTO m_abb072
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno   
            AND aba02 >=bdate  AND aba02 <=edate
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19  = 'Y'
            AND abb03  = p_aea05
            AND abb06 ='2'
            AND aba03 =yy AND aba04 =p_aba04
            AND abb24=p_abb24
         SELECT SUM(abb07) INTO m_tah04
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno  
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19   ='Y'
            AND abb03  = p_aea05
            AND abb06 ='1'
            AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
            AND abb24=p_abb24
         SELECT SUM(abb07) INTO m_tah05
           FROM  abb_file,aba_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno   
            AND abaacti ='Y'
            AND abapost ='N'
            AND aba19   ='Y'
            AND abb03  = p_aea05
            AND abb06 ='2'
            AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
            AND abb24=p_abb24
         IF m_abb071 IS NULL THEN LET m_abb071 = 0 END IF
         IF m_abb072 IS NULL THEN LET m_abb072 = 0 END IF
         IF m_abb07f1 IS NULL THEN LET m_abb07f1 =0 END IF
         IF m_abb07f2 IS NULL THEN LET m_abb07f2 =0 END IF
         IF m_tah04  IS NULL THEN LET m_tah04 = 0 END IF
         IF m_tah05  IS NULL THEN LET m_tah05 = 0 END IF
         IF m_tah09  IS NULL THEN LET m_tah09 = 0 END IF
         IF m_tah10  IS NULL THEN LET m_tah10 = 0 END IF
         LET l_abb071 = l_abb071 + m_abb071
         LET l_abb072 = l_abb072 + m_abb072
         LET l_abb07f1 = l_abb07f1 + m_abb07f1
         LET l_abb07f2 = l_abb07f2 + m_abb07f2
         LET l_tah04   = l_tah04 + m_tah04
         LET l_tah05   = l_tah05 + m_tah05
         LET l_tah09   = l_tah09 + m_tah09
         LET l_tah10   = l_tah10 + m_tah10
      END IF
      RETURN l_abb07f1,l_abb071,l_abb07f2,l_abb072,
             l_tah09,l_tah04,l_tah10,l_tah05
END FUNCTION
