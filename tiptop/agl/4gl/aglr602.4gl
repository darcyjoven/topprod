# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr602.4gl
# Descriptions...: 預算消耗狀況表
# Input parameter:
# Return code....:
# Date & Author..: 92/08/11 By Nora
# Modify.........: No.FUN-510007 05/02/22 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱欄位 
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.FUN-780061 07/08/30 By zhoufeng 報表輸出改為Crystal Report
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控
# Modify.........: No.FUN-840227 08/04/29 By Carrier s_bug改成s_bug1
# Modify.........: No.MOD-8C0064 08/12/09 By Sarah CR Temptable增加aag07
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0122 09/12/14 By Sarah 報表應該只抓科目預算的資料
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD	    		# Print condition RECORD
              wc  LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(500)
              bugno LIKE afb_file.afb01,#預算編號
              yy  LIKE aah_file.aah02,  #輸入年度
              mm  LIKE aah_file.aah03,  #期別
              e   LIKE type_file.chr1,  #FUN-6C0012
              more	LIKE type_file.chr1   		    #Input more condition(Y/N)#No.FUN-680098  VARCHAR(1)
              END RECORD 
#          g_bookno  LIKE aah_file.aah00 #帳別     #No.FUN-740020
  DEFINE      bookno LIKE aag_file.aag00    #No.FUN-740020       #No.TQC-740093
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098 integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_sql           STRING                  #No.FUN-780061
DEFINE   g_str           STRING                  #No.FUN-780061
DEFINE   l_table         STRING                  #No.FUN-780061
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-780061 --start--
   LET g_sql="aag01.aag_file.aag01,aag02.aag_file.aag02,",
             "aag13.aag_file.aag13,aag07.aag_file.aag07,",  #MOD-8C0064 add aag07
             "bug1.afc_file.afc06, bug2.afc_file.afc06,",
             "bug3.afc_file.afc06, bug4.afc_file.afc06,",
             "bug5.afc_file.afc06"
   LET l_table = cl_prt_temptable('aglr602',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"  #MOD-8C0064 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780061 --end--
 
   LET bookno = ARG_VAL(1)    #No.FUN-740020
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.bugno  = ARG_VAL(9)
   LET tm.yy = ARG_VAL(10)
   LET tm.mm = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(15)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
#No.FUN-740020 ---begin
    IF cl_null(bookno) THEN
       LET bookno = g_aza.aza81
    END IF
#No.FUN-740020 ---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r602_tm()	        	# Input print condition
      ELSE CALL r602()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r602_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col  	LIKE type_file.num5,       #No.FUN-680098 smallint
       l_sw             LIKE type_file.chr1,       #重要欄位是否空白  #No.FUN-680098 VARCHAR(1)
       l_afbacti        LIKE afb_file.afbacti,
       l_cmd	        LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno    LIKE type_file.num5   #FUN-B20054 
   CALL s_dsmark(bookno)     #No.FUN-740020
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r602_w AT p_row,p_col
        WITH FORM "agl/42f/aglr602"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(0,0,bookno)    #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   #使用預設帳別之幣別
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM aaa_file,azi_file
		  WHERE aaa01 = bookno AND aaa03 = azi01   #No.FUN-740020
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","aaa_file,azi_file",bookno,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123    #No.FUN-740020
   END IF
   LET tm.e    = 'N'   #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_sw = 1

   DISPLAY BY NAME tm.more 		# Condition #FUN-B20054
WHILE TRUE
   #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)
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
     #FUN-B20054--add--end

   CONSTRUCT BY NAME tm.wc ON aag01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#FUN-B20054--mark--str-- 
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
  END CONSTRUCT

#FUN-B20054--mark--str--  
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW r602_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-B20054--mark--end
   
  # DISPLAY BY NAME tm.more 		# Condition  #FUN-B20054
  # INPUT BY NAME bookno,tm.bugno,tm.yy,tm.mm,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012     #No.FUN-740020  #FUN-B20054
    INPUT BY NAME tm.bugno,tm.yy,tm.mm,tm.e,tm.more
                  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054

#FUN-B20054--mark--str--  
#    #No.FUN-740020 -- begin --                                                                                                          
#         AFTER FIELD bookno                                                                                                         
#            IF bookno IS NULL THEN                                                                                                 
#               NEXT FIELD bookno                                                                                                    
#            END IF                                                                                                                  
#    #No.FUN-740020 -- end -- 
#FUN-B20054--mark--end
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#FUN-810069 --- STA
#     AFTER FIELD bugno
#           IF tm.bugno IS NULL THEN NEXT FIELD bookno END IF
#       	SELECT COUNT(*) INTO g_cnt
#           	FROM afb_file WHERE afb00 = bookno AND afb01 = tm.bugno AND      #No.FUN-740020 
#                                   afbacti = 'Y'   #TQC-630238
#               LET g_errno = ' '
#   		IF NOT g_cnt THEN
#       	   CALL cl_err(tm.bugno,'agl-005',0)
#       	   NEXT FIELD bookno
#   		END IF
      AFTER FIELD bugno
            IF tm.bugno IS NULL THEN NEXT FIELD bookno END IF
               SELECT COUNT(*) INTO g_cnt
               FROM azf_file WHERE azfacti = 'Y' AND azf02 = '2' AND azf01 = tm.bugno
               LET g_errno = ' '
               IF NOT g_cnt THEN
                  CALL cl_err(tm.bugno,'agl-005',0)
                  NEXT FIELD bookno 
               END IF 
#FUN-810069 --- END
 
#No.TQC-720032 -- begin --
      AFTER FIELD yy
         IF tm.yy IS NULL OR tm.yy = 0 THEN
            NEXT FIELD yy
         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
#No.TQC-720032 -- begin --
#         IF tm.mm <1 OR tm.mm > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD mm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
	#	 IF INT_FLAG THEN EXIT INPUT END IF   #FUN-B20054
		 IF tm.bugno IS NULL THEN
			LET l_sw = 0
			DISPLAY BY NAME tm.bugno
		END IF
		 IF tm.yy IS NULL THEN
			LET l_sw = 0
			DISPLAY BY NAME tm.yy
		END IF
		 IF tm.mm IS NULL THEN
			LET l_sw = 0
			DISPLAY BY NAME tm.mm
		END IF
		IF l_sw = 0 THEN
			LET l_sw = 1
			NEXT FIELD bugno
			CALL cl_err('',9033,0)
		END IF

#FUN-B20054--mark-str--
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()	# Command execution
# 
#        ON ACTION CONTROLP
#    #No.FUN-740020  ---begin                                                                                                            
#        CASE                                                                                                                        
#          WHEN INFIELD(bookno)                                                                                                      
#             CALL cl_init_qry_var()                                                                                                 
#             LET g_qryparam.form = 'q_aaa'                                                                                          
#             LET g_qryparam.default1 = bookno                                                                                    
#             CALL cl_create_qry() RETURNING bookno                                                                               
#             DISPLAY BY NAME bookno                                                                                              
#             NEXT FIELD bookno                                                                                                      
#   #No.FUN-740020  ---end
#           WHEN INFIELD(bugno)   # 96/02/29 modify Grace q_afb ->q_afa
#   # 	      CALL q_afa(0,0,tm.bugno,bookno) RETURNING tm.bugno
#               CALL cl_init_qry_var()
#   #             LET g_qryparam.form = 'q_afa'         #FUN-810069
#               LET g_qryparam.form = 'q_azf'         #FUN-810069
#               LET g_qryparam.default1 = tm.bugno
#   #            LET g_qryparam.arg1 = bookno        #No.FUN-740020     #FUN-810069
#               LET g_qryparam.arg1 = '2'           #FUN-810069
#               CALL cl_create_qry() RETURNING tm.bugno
#   #            CALL FGL_DIALOG_SETBUFFER( tm.bugno )
#               DISPLAY BY NAME tm.bugno
#               NEXT FIELD bugno
#           END CASE
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
   END INPUT

  #FUN-B20054--add--str--
    ON ACTION CONTROLP
     #No.FUN-740020  ---begin                                                                                                            
        CASE                                                                                                                        
          WHEN INFIELD(bookno)                                                                                                      
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form = 'q_aaa'                                                                                          
             LET g_qryparam.default1 = bookno                                                                                    
             CALL cl_create_qry() RETURNING bookno                                                                               
             DISPLAY BY NAME bookno                                                                                              
             NEXT FIELD bookno  
           WHEN INFIELD(aag01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag02"
              LET g_qryparam.state = "c"
              LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aag01
              NEXT FIELD aag01             
    #No.FUN-740020  ---end
           WHEN INFIELD(bugno)   # 96/02/29 modify Grace q_afb ->q_afa
   # 	      CALL q_afa(0,0,tm.bugno,bookno) RETURNING tm.bugno
               CALL cl_init_qry_var()
   #              LET g_qryparam.form = 'q_afa'         #FUN-810069
               LET g_qryparam.form = 'q_azf'         #FUN-810069
               LET g_qryparam.default1 = tm.bugno
   #              LET g_qryparam.arg1 = bookno        #No.FUN-740020     #FUN-810069
               LET g_qryparam.arg1 = '2'           #FUN-810069
               CALL cl_create_qry() RETURNING tm.bugno
   #               CALL FGL_DIALOG_SETBUFFER( tm.bugno )
               DISPLAY BY NAME tm.bugno
               NEXT FIELD bugno
           END CASE
   
   ON ACTION locale
     #   CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      LET g_action_choice = "locale"
      EXIT DIALOG
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG
 
   ON ACTION about         #MOD-4C0121
      CALL cl_about()      #MOD-4C0121
 
   ON ACTION help          #MOD-4C0121
      CALL cl_show_help()  #MOD-4C0121
 
   ON ACTION controlg      #MOD-4C0121
      CALL cl_cmdask()     #MOD-4C0121
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
           
   ON ACTION exit
      LET INT_FLAG = 1
      EXIT DIALOG
  #No.FUN-580031 --start--
   ON ACTION qbe_select
      CALL cl_qbe_select()
  #No.FUN-580031 ---end---

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
      LET INT_FLAG = 0 CLOSE WINDOW r602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 #FUN-B20054--add--end
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aglr602'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr602','9031',1)  
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",bookno CLIPPED,"'",     #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bugno CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",      #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr602',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r602_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r602()
   ERROR ""
END WHILE
   CLOSE WINDOW r602_w
END FUNCTION
 
FUNCTION r602()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0073
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
	  l_flag	LIKE type_file.num5,  		#判斷是否有預算資料               #No.FUN-680098 smallint
          l_chr		LIKE type_file.chr1,            #No.FUN-680098 VARCHAR(1)                             
          l_za05	LIKE za_file.za05,              #No.FUN-680098 VARCHAR(40)
	  l_debit		   LIKE abb_file.abb07,				#借方金額
	  l_credit		   LIKE abb_file.abb07,				#貸方金額
          #No.FUN-840227  --Begin
          sr            RECORD
                        aag01   LIKE aag_file.aag01,    #科目編號
                        aag02   LIKE aag_file.aag02,    #科目名稱
                        aag13   LIKE aag_file.aag13,    #FUN-6C0012
                        aag06   LIKE aag_file.aag06,    #借貸別
                        aag07   LIKE aag_file.aag07,    #統制明細別
                        afb04   LIKE afb_file.afb04,
                        afb041  LIKE afb_file.afb041,
                        afb042  LIKE afb_file.afb042,
                        bug1    LIKE afc_file.afc06,    #當期預算
                        bug2    LIKE afc_file.afc06,    #上期未消耗
                        bug3    LIKE afc_file.afc06,    #本期己消耗
                        bug4    LIKE afc_file.afc06,    #本期預計消耗
                        bug5    LIKE afc_file.afc06     #剩餘預算
                        END RECORD
DEFINE l_flag1         LIKE type_file.chr1
DEFINE l_bookno1       LIKE aaa_file.aaa01
DEFINE l_bookno2       LIKE aaa_file.aaa01
          #No.FUN-840227  --End  
 
     CALL cl_del_data(l_table)                                          #No.FUN-780061
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno     #No.FUN-740020
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
 
 
     #No.FUN-840227  --Begin
     LET l_sql = "SELECT aag01,aag02,aag13,aag06,aag07,afb04,afb041,afb042",
                 "  FROM aag_file,afb_file,afc_file",
                 " WHERE aag03 = '2' ",
                 "   AND aag00 = '",bookno,"'",               #No.FUN-740020
                 "   AND aag00 = afb00 ",
                 "   AND aag01 = afb02 ",
                 "   AND afb00 = afc00 ",
                 "   AND afb01 = afc01 ",
                 "   AND afb02 = afc02 ",
                 "   AND afb03 = afc03 ",
                 "   AND afb04 = afc04 ",
                 "   AND afb041= afc041",
                 "   AND afb042= afc042",
                 "   AND afb01 = '",tm.bugno,"'",
                 "   AND afb03 =  ",tm.yy,
                 "   AND afc05 =  ",tm.mm,
                 "   AND afb04 = ' '",   #MOD-9C0122 add 
                 "   AND afb041= ' '",   #MOD-9C0122 add
                 "   AND afb042= ' '",   #MOD-9C0122 add 
                 "   AND afbacti = 'Y' ", #FUN-D70090
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY aag01,afb04,afb041,afb042"
     PREPARE r602_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('p1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r602_c1 CURSOR FOR r602_p1
 
     #本期預計消耗預算----> 借方
     LET l_sql = "SELECT SUM(abb07) FROM aba_file,abb_file",
                 " WHERE aba00 = abb00 ",
                 "   AND aba01 = abb01 ",
                 "   AND abb00 = '",bookno,"'",
                 "   AND abb36 = '",tm.bugno,"'", 
                 "   AND abb03 = ?",
                 "   AND aba03 =  ",tm.yy,
                 "   AND aba04 =  ",tm.mm,
                 "   AND abb35 = ?",
                 "   AND abb05 = ?",
                 "   AND abb08 = ?",
                 "   AND abb06 = ?",
                 "   AND aba19 <> 'X' ",  #CHI-C80041     
                 "   AND abapost = 'N' AND abaacti='Y'"
     PREPARE r602_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('p2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r602_c2 CURSOR FOR r602_p2
 
     FOREACH r602_c1 INTO sr.aag01,sr.aag02,sr.aag13,sr.aag06,sr.aag07,
                          sr.afb04,sr.afb041,sr.afb042
     #No.FUN-840227  --End
        #上期未消耗,當期預算,當期已消耗
        #No.FUN-840227  --Begin
        #CALL s_bug(bookno,tm.bugno,sr.aag01,sr.aag07,tm.yy,tm.mm)     #No.FUN-740020
        #     RETURNING l_flag,sr.bug2,sr.bug1,sr.bug3
        CALL s_get_bookno(tm.yy) RETURNING l_flag,l_bookno1,l_bookno2
        IF l_bookno1 = bookno THEN
           LET l_flag1 = '0'
        ELSE
           LET l_flag1 = '1'
        END IF
        CALL s_bug1(bookno,tm.bugno,sr.aag01,tm.yy,sr.afb04,sr.afb041,
                    sr.afb042,tm.mm,l_flag1)
             RETURNING l_flag,sr.bug2,sr.bug1,sr.bug3
        #No.FUN-840227  --End  
        IF l_flag THEN CONTINUE FOREACH END IF
 
        #No.FUN-840227  --Begin
        #本期預計消耗
        OPEN r602_c2 USING sr.aag01,sr.afb04,sr.afb041,sr.afb042,'1'
        FETCH r602_c2 INTO l_debit
        IF STATUS THEN CALL cl_err('c2:',STATUS,0) EXIT FOREACH END IF
        IF l_debit IS NULL THEN LET l_debit = 0 END IF
        OPEN r602_c2 USING sr.aag01,sr.afb04,sr.afb041,sr.afb042,'2'
        FETCH r602_c2 INTO l_credit
        IF STATUS THEN CALL cl_err('c2:',STATUS,0) EXIT FOREACH END IF
        IF l_credit IS NULL THEN LET l_credit = 0 END IF
        #No.FUN-840227  --End  
        IF sr.aag06 = '1' THEN
           LET sr.bug4 = l_debit - l_credit
        ELSE
           LET sr.bug4 = l_credit - l_debit
        END IF
 
        #剩餘預算
        LET sr.bug5 = sr.bug1+sr.bug2-sr.bug3-sr.bug4
        IF sr.bug1=0 AND sr.bug2 = 0 AND sr.bug3 = 0 AND
           sr.bug4=0 AND sr.bug5 =0 THEN 
           CONTINUE FOREACH
        END IF
 
#       OUTPUT TO REPORT r602_rep(sr.*)              #No.FUN-780061
        #No.FUN-780061 --add--
        EXECUTE insert_prep USING
           sr.aag01,sr.aag02,sr.aag13,sr.aag07,   #MOD-8C0064 add sr.aag07
           sr.bug1,sr.bug2,sr.bug3,sr.bug4,sr.bug5
        #No.FUN-780061 --end--
     END FOREACH
 
#     FINISH REPORT r602_rep                                 #No.FUN-780061
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)            #No.FUN-780061
     #No.FUN-780061 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bugno,";",tm.yy,";",tm.mm,";",tm.e,";",
                 g_azi04,";",g_azi05
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aglr602','aglr602',l_sql,g_str)
     #No.FUN-780061 --end--
END FUNCTION
#No.FUN-780061 --start-- mark
{REPORT r602_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,                    #No.FUN-680098 VARCHAR(1)
          g_head1       STRING,
            l_tot1             LIKE afc_file.afc06,                    #當期預算合計
            l_tot2             LIKE afc_file.afc06,                    #上期未消耗合計
            l_tot3             LIKE afc_file.afc06,                    #本期已消耗合計
            l_tot4             LIKE afc_file.afc06,                    #本期預計消耗合計
            l_tot5             LIKE afc_file.afc06,                    #剩餘預算合計
          sr               RECORD
                                 aag01     LIKE aag_file.aag01,     #科目編號
                                 aag02     LIKE aag_file.aag02,     #科目名稱
                                                   aag13        LIKE aag_file.aag13,    #FUN-6C0012
                                 aag06     LIKE aag_file.aag06,     #借貸別
                                 aag07     LIKE aag_file.aag07,     #統制明細別
                                 bug1          LIKE afc_file.afc06,     #當期預算
                                 bug2          LIKE afc_file.afc06,     #上期未消耗
                                 bug3          LIKE afc_file.afc06,     #本期己消耗
                                 bug4          LIKE afc_file.afc06,     #本期預計消耗
                                 bug5          LIKE afc_file.afc06      #剩餘預算
                           END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.aag01
  FORMAT
 
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[13] CLIPPED,tm.bugno CLIPPED,'   ',
                    g_x[14] CLIPPED,tm.yy USING '&&&&','   ',
              g_x[15] CLIPPED,tm.mm USING'&&'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1
      PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]           #FUN-6C0012
      PRINT g_x[31],g_x[37],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]   #FUN-6C0012
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 
   ON EVERY ROW
       PRINT COLUMN g_c[31],sr.aag02
          PRINT COLUMN g_c[37],sr.aag13  #FUN-6C0012
       PRINT COLUMN g_c[32],cl_numfor(sr.bug1,32,g_azi04) CLIPPED,
          COLUMN g_c[33],cl_numfor(sr.bug2,33,g_azi04) CLIPPED,
          COLUMN g_c[34],cl_numfor(sr.bug3,34,g_azi04) CLIPPED,
          COLUMN g_c[35],cl_numfor(sr.bug4,35,g_azi04) CLIPPED,
          COLUMN g_c[36],cl_numfor(sr.bug5,36,g_azi04) CLIPPED
 
   ON LAST ROW
       LET l_tot1 = SUM(sr.bug1)
       LET l_tot2 = SUM(sr.bug2)
       LET l_tot3 = SUM(sr.bug3)
       LET l_tot4 = SUM(sr.bug4)
       LET l_tot5 = SUM(sr.bug5)
       PRINT COLUMN g_c[31],g_x[16] CLIPPED,
          COLUMN g_c[32],cl_numfor(l_tot1,32,g_azi05) CLIPPED,
          COLUMN g_c[33],cl_numfor(l_tot2,33,g_azi05) CLIPPED,
          COLUMN g_c[34],cl_numfor(l_tot3,34,g_azi05) CLIPPED,
          COLUMN g_c[35],cl_numfor(l_tot4,35,g_azi05) CLIPPED,
          COLUMN g_c[36],cl_numfor(l_tot5,36,g_azi05) CLIPPED
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-780061 --end--
#Patch....NO.TQC-610035 <001> #
