# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr301.4gl
# Descriptions...: 明細分類帳
# Input parameter:
# Return code....:
# Date & Author..: 02/08/26 By Carrier
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.A114 04/03/11 By Danny
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-560280 05/07/01 By Carrier
#                  每筆資料的余額值都是在列印前被計算出來的.
#                  列印時要嚴格遵照SELECT的順序,否則最后的余額值會不正確
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.TQC-630194 06/03/21 By Smapmin 重新抓取g_len
# Modify.........: No.MOD-640022 06/04/13 By Smapmin abb24 MATCHES改為=
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670106 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 報表打印額外名稱
# Modify.........: No.FUN-740055 07/04/13 By arman 會計科目加帳套
# Modify.........: No.TQC-750022 07/05/09 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-7C0064 07/12/25 By Carrier 報表格式轉CR
# Modify.........: No.MOD-820082 08/02/19 By Smapmin 修正SQL語法
# Modify.........: No.MOD-890094 08/09/16 By chenl   幣種欄位僅在勾選打印外幣欄位后才能輸入。
# Modify.........: No.MOD-8C0126 08/12/15 By wujie   異動期間借貸扺消的應該被抓出來
# Modify.........: No.MOD-860252 09/02/03 By chenl   增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.TQC-930163 09/04/08 By elva 隱藏tm.d 按幣別分頁
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50151 10/05/26 By Carrier tm.k <> '3'时foreach curs1 时会报 -324的错误
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/17 By yinhy END INPUT改為END DIALOG 
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.MOD-B80143 11/08/15 By yinhy 部分欄位不可輸入
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc1  VARCHAR(300),		# Where condition
		wc1	STRING,			# TQC-630166
	       #wc2  VARCHAR(300),		# Where condition
                wc2     STRING,                 # TQC-630166
   		t    	LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   # none trans print (Y/N) ?
   		x    	LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   # Eject sw/獨立打印否 #FUN-670106
   		n    	LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   # 列印外幣否 (Y/N)    #FUN-670106
                e       LIKE type_file.chr1,    #FUN-6C0012
                h       LIKE type_file.chr1,    #MOD-860252
   		o    	LIKE azi_file.azi01,    #NO FUN-690009   VARCHAR(4)   # 分類別
                k       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)   #add 030901 NO.A085
   		more	LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)   #Input more condition(Y/N)
             END RECORD,
        yy,mm           LIKE type_file.num10,   #NO FUN-690009   INTEGER
        mm1,nn1         LIKE type_file.num10,   #NO FUN-690009   INTEGER
        bdate,edate     LIKE type_file.dat,     #NO FUN-690009   DATE
        l_flag          LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#       g_bookno        LIKE aaa_file.aaa01,
        bookno          LIKE aaa_file.aaa01,    #NO.FUN-740055
        g_cnnt          LIKE type_file.num5     #NO FUN-690009   SMALLINT
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                  #No.FUN-7C0064
DEFINE   g_str           STRING                  #No.FUN-7C0064
DEFINE   g_sql           STRING                  #No.FUN-7C0064
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
 
 
#  LET g_bookno = ARG_VAL(1)            #NO.FUN-740055
   LET bookno = ARG_VAL(1)            #NO.FUN-740055
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
   LET tm.n  = ARG_VAL(12)
   LET tm.o  = ARG_VAL(13)
   LET tm.k  = ARG_VAL(14)                    #add 030901 NO.A085
   LET bdate = ARG_VAL(15)   #TQC-610056
   LET edate = ARG_VAL(16)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(20)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
#NO.FUN-740055   --Begin
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81 
   END IF
#NO.FUN-740055  --End
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno          #NO.FUN-740055
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
#  SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03      #No.CHI-6A0004
   IF SQLCA.sqlcode THEN 
#        CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660124
         CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)    #No.FUN-660124
   END IF
 
   #No.FUN-7C0064  --Begin
   LET g_sql = " aea05.aea_file.aea05,",
               " aea02.aea_file.aea02,",
               " aea03.aea_file.aea03,",
               " aea04.aea_file.aea04,",
               " aba04.aba_file.aba04,",
               " aba02.aba_file.aba02,",
               " abb04.abb_file.abb04,",
               " abb24.abb_file.abb24,",
               " abb25.abb_file.abb25,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " aag02.type_file.chr1000,",
               " aag08.aag_file.aag08,",
               " qcye.abb_file.abb07,",
               " qcye1.abb_file.abb07,",
               " azi04.azi_file.azi04,",
               " azi07.azi_file.azi07,",
               " l_abb07f1.abb_file.abb07,",
               " l_abb071.abb_file.abb07,",
               " l_abb07f2.abb_file.abb07,",
               " l_abb072.abb_file.abb07,",
               " l_tah09.abb_file.abb07,",
               " l_tah04.abb_file.abb07,",
               " l_tah10.abb_file.abb07,",
               " l_tah05.abb_file.abb07,",
               " type.type_file.chr1    "
 
   LET l_table = cl_prt_temptable('gglr301',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?)          "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0064  --End

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglr301_tm()	        	# Input print condition
      ELSE CALL gglr301()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr301_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_i           LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd		LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_chk_bookno LIKE type_file.num5     #FUN-B20010
   
   CALL s_dsmark(bookno)          #NO.FUN-740055
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW gglr301_w AT p_row,p_col
        WITH FORM "ggl/42f/gglr301"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("d",FALSE) #TQC-930163 
 
 #modify 030904 NO.A085
# END genero shell script ADD
################################################################################
   CALL s_shwact(0,0,bookno)     #NO.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET bookno  = g_aza.aza81
   LET bdate   = g_today
   LET edate   = g_today
   LET tm.t    = 'N'
   LET tm.x    = 'N'
   LET tm.n    = 'N'
   LET tm.e    = 'N' #FUN-6C0012
   LET tm.h    = 'Y' #No.MOD-860252
   LET tm.o    = '    '
   LET tm.k  = '1'                    #add 030901 NO.A085
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
             IF tm.n = 'Y' THEN
                CALL cl_set_comp_entry("o",TRUE)
             ELSE 
                CALL cl_set_comp_entry("o",FALSE)
             END IF 
         
          AFTER FIELD bookno
            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF
     END INPUT
    #No.FUN-B20010  --End
#No.FUN-B20010  --Begin    
     CONSTRUCT BY NAME tm.wc1 ON aag01
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
#No.FUN-B20010  --Mark Begin
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
#       #No.FUN-B20010  --End
#       
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
#     
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
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
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
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
#        LET INT_FLAG = 0 CLOSE WINDOW gglr301_w EXIT PROGRAM
#     END IF
     CONSTRUCT BY NAME tm.wc2 ON aba11
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
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
#         LET INT_FLAG = 0 CLOSE WINDOW gglr301_w EXIT PROGRAM
#     END IF
#No.FUN-B20010  --Mark ENd
 #modify 030901 NO.A085
     #DISPLAY BY NAME tm.t,tm.x,tm.n,tm.e,tm.h,tm.o,tm.k,tm.more #FUN-6C0012 #No.MOD-860252 add tm.h
     #INPUT BY NAME bookno,bdate,edate,tm.t,tm.x,tm.n,tm.e,tm.h,tm.o,tm.k,tm.more #FUN-6C0012 #No.MOD-860252 #FUN-B20010 mark
     # WITHOUT DEFAULTS
#end NO.A085----------    #NO.FUN-740055
     INPUT BY NAME bdate,edate,tm.t,tm.x,tm.n,tm.e,tm.h,tm.o,tm.k,tm.more  ATTRIBUTE(WITHOUT DEFAULTS) #MOD-B80143 
         
 
         #No.MOD-890094--begin--
          BEFORE INPUT
             IF tm.n = 'Y' THEN
                CALL cl_set_comp_entry("o",TRUE)
             ELSE 
                CALL cl_set_comp_entry("o",FALSE)
             END IF 
         #No.MOD-890094---end---  
 
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
          AFTER FIELD n
             IF cl_null(tm.n) OR tm.n NOT MATCHES'[YN]' THEN NEXT FIELD n END IF
             IF tm.n = 'N' THEN
                LET tm.o = NULL
                DISPLAY BY NAME tm.o
             END IF
 
         #No.MOD-890094--begin--  
          ON CHANGE n 
             IF tm.n = 'Y' THEN
                CALL cl_set_comp_entry("o",TRUE)
             ELSE 
                LET tm.o = NULL 
                DISPLAY tm.o TO FORMONLY.o 
                CALL cl_set_comp_entry("o",FALSE)
             END IF
         #No.MOD-890094---end--- 
 
          BEFORE FIELD o
             IF tm.n = 'N' THEN
# genero  script marked                 IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
             END IF
          AFTER FIELD o
             SELECT azi01 FROM azi_file WHERE azi01 = tm.o
             IF SQLCA.sqlcode THEN
#               CALL cl_err(tm.o,'agl-109',0)    #No.FUN-660124
                CALL cl_err3("sel","azi_file",tm.o,"","agl-109","","",0)   #No.FUN-660124
                NEXT FIELD o
             END IF
  #modify 030901 NO.A085
          AFTER FIELD k
             IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]'
             THEN NEXT FIELD k END IF
          #end NO.A085----------
          AFTER FIELD more
             IF tm.more = 'Y'
                THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
             END IF
 
          #No.MOD-890094--begin--
          AFTER INPUT
             IF INT_FLAG THEN
                #EXIT INPUT    #TQC-B30147
                EXIT DIALOG    #TQC-B30147
             END IF
             IF tm.n = 'Y' THEN 
                IF cl_null(tm.o) THEN 
                   NEXT FIELD o
                END IF 
             END IF 
          #No.MOD-890094---end---
#No.FUN-B20010  --Mark Begin 
################################################################################
# START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
#          ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#       ON IDLE g_idle_seconds

#NO.FUN-740055   --- Begin
#      ON ACTION CONTROLP
#	      CASE
#           WHEN INFIELD(bookno) 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_aaa'
#              LET g_qryparam.default1 =bookno
#              CALL cl_create_qry() RETURNING bookno
#	      DISPLAY BY NAME bookno
#	      NEXT FIELD bookno
#        END CASE
##NO.FUN-740055   ---End
#
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
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
          OTHERWISE EXIT CASE   
       END CASE
         ON ACTION locale
        CALL cl_show_fld_cont() 
        LET g_action_choice = "locale"
        EXIT DIALOG
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
       CLOSE WINDOW gglr301_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    #No.FUN-B20010  --End
    LET mm1 = MONTH(bdate)
    LET nn1 = MONTH(edate)
 
    SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
        WHERE zz01='gglr301'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglr301','9031',1)   
       ELSE
          LET tm.wc1=cl_wcsub(tm.wc1)
          LET l_cmd = l_cmd CLIPPED,
                     " '",bookno CLIPPED,"'",         #NO.FUN-740055
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc1 CLIPPED,"'",
                     " '",tm.wc2 CLIPPED,"'",   #TQC-610056
                     " '",tm.t CLIPPED,"'",
                     " '",tm.x CLIPPED,"'",
                     " '",tm.n CLIPPED,"'",
                     " '",tm.e CLIPPED,"'",  #FUN-6C0012
                     " '",tm.o CLIPPED,"'",
                    " '",tm.k CLIPPED,"'",   #TQC-610056
                    " '",bdate CLIPPED,"'",   #TQC-610056
                    " '",edate CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('gglr301',g_time,l_cmd)	# Execute cmd at later time
       END IF
       CLOSE WINDOW gglr301_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr301()
    ERROR ""
   END WHILE
   CLOSE WINDOW gglr301_w
END FUNCTION
 
FUNCTION gglr301()
   DEFINE l_name     	   LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8               #No.FUN-6A0097
          l_sql,l_sql1 	   LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_aea03          LIKE type_file.chr5,    #NO FUN-690009   VARCHAR(5)
          l_bal,l_bal2     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
          s_abb07,s_abb07f LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
          l_za05	   LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          l_date,l_date1   LIKE aba_file.aba02,    #NO FUN-690009   DATE
          p_aag02          LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(100)
          l_i              LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_creid          LIKE abb_file.abb07,  #add 030901 NO.A085
          l_creidf         LIKE abb_file.abb07f, #add 030901 NO.A085
          l_debit          LIKE abb_file.abb07,  #add 030901 NO.A085
          l_debitf         LIKE abb_file.abb07f, #add 030901 NO.A085
          sr1    RECORD
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    aag08  LIKE aag_file.aag08,
                    aag07  LIKE aag_file.aag07,
                    aag24  LIKE aag_file.aag24
                 END RECORD,
          sr     RECORD
                    aea05  LIKE aea_file.aea05,
                    aea02  LIKE aea_file.aea02,
                    aea03  LIKE aea_file.aea03,
                    aea04  LIKE aea_file.aea04,
                    aba04  LIKE aba_file.aba04,
                    aba02  LIKE aba_file.aba02,
                    abb04  LIKE abb_file.abb04,
                    abb24  LIKE abb_file.abb24,
                    abb25  LIKE abb_file.abb25,
                    abb06  LIKE abb_file.abb06,
                    abb07  LIKE abb_file.abb07,
                    abb07f LIKE abb_file.abb07f,
                    aag02  LIKE type_file.chr1000,  #NO FUN-690009   VARCHAR(100)
                    aag08  LIKE aag_file.aag08,
                    qcye   LIKE abb_file.abb07,     #No.A114
                    qcye1  LIKE abb_file.abb07      #No.A114
                 END RECORD
  #No.FUN-7C0064  --Begin
  DEFINE l_abb071,l_abb072   LIKE type_file.num20_6
  DEFINE l_tah04,l_tah05     LIKE type_file.num20_6 
  DEFINE l_tah09,l_tah10     LIKE type_file.num20_6 
  DEFINE t_tah04,t_tah05     LIKE type_file.num20_6 
  DEFINE t_tah09,t_tah10     LIKE type_file.num20_6 
  DEFINE l_abb07f1,l_abb07f2 LIKE type_file.num20_6 
  DEFINE l_year              LIKE type_file.num10
  DEFINE l_month             LIKE type_file.num10
  #No.FUN-7C0064  --End  
  DEFINE l_n                 LIKE type_file.num5     #No.MOD-8C0126 
     
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     #No.FUN-7C0064  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-7C0064  --End
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno      #NO.FUN-740055
	AND aaf02 = g_lang
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     LET l_sql1= "SELECT aag01,aag02,aag08,aag07,aag24 ",
                 "  FROM aag_file ",
                 " WHERE aag03 ='2' AND aag07 IN ('2','3')",
                 "   AND aag00 = '",bookno,"' ",      #No.fun-740055
                 "   AND ",tm.wc1 CLIPPED
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql1 = l_sql1, " AND aag09 = 'Y' "
     END IF
     #No.MOD-860252---end---
     PREPARE gglr301_prepare2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr301_curs2 CURSOR FOR gglr301_prepare2
 
     #modify 030901 NO.A085
     IF tm.k = '3' THEN
        LET l_sql = "SELECT aea05,aea02,aea03,aea04,aba04,",
                    "       aba02,abb04,abb24,abb25,abb06,",
                    "       abb07,abb07f,'','',''",
                    "  FROM aea_file,aba_file,abb_file ",
                    " WHERE aea05 =  ? ",
                    "   AND aea00 = '",bookno,"' ",    #NO.FUN-740055
                    "   AND aea00 = aba00 ",
                    "   AND aba00 = abb00 ",
                    "   AND aba01 = abb01 ",
                    "   AND abb03 = aea05 ",
                    "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
                    "   AND abb01 = aea03 AND abb02 = aea04 ",
                    "   AND aba01 = aea03",
                    "   AND abapost = 'Y' ",
                    "   AND aba04 = ? ",
                    "   AND ",tm.wc2 CLIPPED
     ELSE
        LET l_sql = "SELECT abb03,''   ,abb01,abb02,aba04,",  #No.TQC-A50151
                    "       aba02,abb04,abb24,abb25,abb06,",
                    "       abb07,abb07f,'','',''",
                    "  FROM aba_file,abb_file ",
                    " WHERE abb03 =  ? ",
                    "   AND abb00 = '",bookno,"' ", #NO.FUN-740055
                    "   AND aba00 = abb00 ",
                    "   AND aba01 = abb01 ",
                    "   AND aba02 BETWEEN '",bdate,"' AND '",edate,"' ",
                    "   AND abaacti='Y' ",
                    "   AND aba19 <> 'X' ",  #CHI-C80041
                    "   AND aba04 = ? ",
                    "   AND ",tm.wc2 CLIPPED
     END IF
     IF tm.k = '2' THEN
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
     END IF
    #end NO.A085---------
     IF tm.n = "Y" THEN
        #LET l_sql = l_sql CLIPPED," AND abb24 MATCHES '",tm.o CLIPPED,"'"   #MOD-640022
        LET l_sql = l_sql CLIPPED," AND abb24 = '",tm.o CLIPPED,"'"   #MOD-640022
     END IF
     #modify 030901 NO.A085
      #No.MOD-560280  --begin
     IF tm.k = '3' THEN
        LET l_sql = l_sql CLIPPED," ORDER BY aea05,aba04,aea02,aea03,aea04 "
     ELSE
        LET l_sql = l_sql CLIPPED," ORDER BY abb03,aba04,aba02,abb01,abb02 "
        #LET l_sql = l_sql CLIPPED," ORDER BY abb03,aba04,aba02,abb01,abb02 "
     END IF
      #No.MOD-560280  --end
    #end NO.A085---------
     PREPARE gglr301_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr301_curs1 CURSOR FOR gglr301_prepare1
 
     #No.FUN-7C0064  --Begin
     #CALL cl_outnam('gglr301') RETURNING l_name
     #-----TQC-630194---------
     ##    IF tm.n = "Y" THEN
     ##       IF g_len = 0 OR g_len IS NULL THEN LET g_len = 190 END IF
     ##    ELSE
     ##       IF g_len = 0 OR g_len IS NULL THEN LET g_len = 114  END IF
     ##    END IF
     ##    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #-----END TQC-630194-----
     #START REPORT gglr301_rep TO l_name
     #LET g_pageno = 0
     ##FUN-670106--begin
     #IF tm.n='Y' THEN
     #   LET g_zaa[34].zaa06='N'
     #   LET g_zaa[35].zaa06='N'
     #   LET g_zaa[36].zaa06='N'
     #   LET g_zaa[37].zaa06='N'
     #   LET g_zaa[38].zaa06='N'
     #   LET g_zaa[39].zaa06='N'
     #   LET g_zaa[40].zaa06='N'
     #   LET g_zaa[41].zaa06='N'
     #   LET g_zaa[42].zaa06='N'
     #   LET g_zaa[43].zaa06='Y'
     #   LET g_zaa[44].zaa06='Y'
     #   LET g_zaa[45].zaa06='Y'
     #   LET g_zaa[46].zaa06='Y'
     #ELSE
     #   LET g_zaa[34].zaa06='Y'
     #   LET g_zaa[35].zaa06='Y'
     #   LET g_zaa[36].zaa06='Y'
     #   LET g_zaa[37].zaa06='Y'
     #   LET g_zaa[38].zaa06='Y'
     #   LET g_zaa[39].zaa06='Y'
     #   LET g_zaa[40].zaa06='Y'
     #   LET g_zaa[41].zaa06='Y'
     #   LET g_zaa[42].zaa06='Y'
     #   LET g_zaa[43].zaa06='N'
     #   LET g_zaa[44].zaa06='N'
     #   LET g_zaa[45].zaa06='N'
     #   LET g_zaa[46].zaa06='N'
     #END IF
     #CALL cl_prt_pos_len() 
     ##FUN-670106--end   
     IF tm.n = 'N' THEN 
         LET l_name = 'gglr301'
     ELSE
         LET l_name = 'gglr301_1'
     END IF
     #No.FUN-7C0064  --End  
     FOREACH gglr301_curs2 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF tm.x = 'N' AND sr1.aag07 = '3' THEN CONTINUE FOREACH END IF
        CALL gglr301_qcye(sr1.aag01)      #期初余額
             RETURNING l_bal,l_bal2
         #modify 030901 NO.A085
        #計算tm.k=1/2時的期初余額
        IF tm.k = '1' THEN
           IF tm.n = 'N' THEN
              SELECT SUM(abb07) INTO l_debit
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno     #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='1'
                 AND abapost ='N'
                 AND abaacti ='Y'
                 AND aba19 <> 'X'  #CHI-C80041
              SELECT SUM(abb07) INTO l_creid
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno               #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='2'
                 AND abapost ='N'
                 AND abaacti ='Y'
                 AND aba19 <> 'X'  #CHI-C80041
            ELSE
              SELECT SUM(abb07),SUM(abb07f) INTO l_debit,l_debitf
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno        #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='1'
                 AND abapost ='N'
                 AND abaacti ='Y'
                 AND aba19 <> 'X'  #CHI-C80041
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
              SELECT SUM(abb07),SUM(abb07f) INTO l_creid,l_creidf
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno       #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='2'
                 AND abapost ='N'
                 AND abaacti ='Y'
                 AND aba19 <> 'X'  #CHI-C80041
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
            END IF
            IF l_debit IS NULL THEN LET l_debit = 0 END IF
            IF l_debitf IS NULL THEN LET l_debitf = 0 END IF
            IF l_creid IS NULL THEN LET l_creid = 0 END IF
            IF l_creidf IS NULL THEN LET l_creidf = 0 END IF
            LET l_bal = l_bal+l_debit - l_creid
            LET l_bal2 = l_bal2 + l_debitf - l_creidf
        END IF
        IF tm.k = '2' THEN
           IF tm.n = 'N' THEN
              SELECT SUM(abb07) INTO l_debit
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno      #No.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='1'
                 AND abapost ='N'
                 AND aba19   ='Y'
                 AND abaacti ='Y'
              SELECT SUM(abb07) INTO l_creid
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno     #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='2'
                 AND abapost ='N'
                 AND aba19   = 'Y'
                 AND abaacti ='Y'
           ELSE
              SELECT SUM(abb07),SUM(abb07f) INTO l_debit,l_debitf
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno      #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='1'
                 AND abapost ='N'
                 AND aba19   ='Y'
                 AND abaacti ='Y'
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
              SELECT SUM(abb07),SUM(abb07f) INTO l_creid,l_creidf
                FROM abb_file,aba_file
               WHERE abb00 = aba00
                 AND abb01 = aba01
                 AND aba00 = bookno     #NO.FUN-740055
                 AND abb03 = sr1.aag01
                 AND aba02 < bdate
                 AND aba03 = yy
                 AND abb06 ='2'
                 AND abapost ='N'
                 AND aba19   = 'Y'
                 AND abaacti ='Y'
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
            END IF
            IF l_debit IS NULL THEN LET l_debit = 0 END IF
            IF l_debitf IS NULL THEN LET l_debitf = 0 END IF
            IF l_creid IS NULL THEN LET l_creid = 0 END IF
            IF l_creidf IS NULL THEN LET l_creidf = 0 END IF
            LET l_bal = l_bal+l_debit - l_creid
            LET l_bal2 = l_bal2 + l_debitf - l_creidf
        END IF
 #計算有沒有期間異動
        IF tm.k ='1' THEN
           IF tm.n = 'N' THEN
              SELECT SUM(abb07) INTO s_abb07 FROM abb_file,aba_file
               WHERE abb03 = sr1.aag01 AND aba01 = abb01
                 AND abb00 = aba00     AND aba00 = bookno    #NO.FUN-740055
                 AND aba02 >= bdate    AND aba02 <= edate
                 AND aba03=yy
                 AND abaacti='Y'
                 AND aba19 <> 'X'  #CHI-C80041
           ELSE
              SELECT SUM(abb07),SUM(abb07f)
                INTO s_abb07,s_abb07f FROM abb_file,aba_file
               WHERE abb03 = sr1.aag01 AND aba01 = abb01
                 AND abb00 = aba00     AND aba00 = bookno   #NO.FUN-740055
                 AND aba02 >= bdate    AND aba02 <= edate
                 AND aba03=yy
                 AND abaacti='Y'
                 AND aba19 <> 'X'  #CHI-C80041
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
           END IF
        END IF
  IF tm.k ='2' THEN
           IF tm.n = 'N' THEN
              SELECT SUM(abb07) INTO s_abb07 FROM abb_file,aba_file
               WHERE abb03 = sr1.aag01 AND aba01 = abb01
                 AND abb00 = aba00     AND aba00 = bookno     #NO.FUN-740055
                 AND aba02 >= bdate    AND aba02 <= edate
                 AND aba03=yy
                 AND abaacti='Y'       AND aba19='Y'
           ELSE
              SELECT SUM(abb07),SUM(abb07f)
                INTO s_abb07,s_abb07f FROM abb_file,aba_file
               WHERE abb03 = sr1.aag01 AND aba01 = abb01
                 AND abb00 = aba00     AND aba00 = bookno    #NO.FUN-740055
                 AND aba02 >= bdate    AND aba02 <= edate
                 AND aba03=yy
                 AND abaacti='Y'       AND aba19='Y'
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
           END IF
        END IF
 IF tm.k ='3' THEN
           IF tm.n = 'N' THEN
              SELECT SUM(abb07) INTO s_abb07 FROM abb_file,aba_file
               WHERE abb03 = sr1.aag01 AND aba01 = abb01
                 AND abb00 = aba00     AND aba00 = bookno     #NO.FUN-740055 
                 AND aba02 >= bdate    AND aba02 <= edate
                 AND aba03=yy
                 AND abapost='Y'
           ELSE
              SELECT SUM(abb07),SUM(abb07f)
                INTO s_abb07,s_abb07f FROM abb_file,aba_file
               WHERE abb03 = sr1.aag01 AND aba01 = abb01
                 AND abb00 = aba00     AND aba00 = bookno    #NO.FUN-740055
                 AND aba02 >= bdate    AND aba02 <= edate
                 AND aba03=yy
                 AND abapost='Y'
                 #AND abb24 MATCHES tm.o   #MOD-640022
                 AND abb24 = tm.o   #MOD-640022
           END IF
        END IF
        #end NO.A085---------
#No.MOD-8C0126 --begin  
        IF tm.n ='N' THEN
           SELECT COUNT(*) INTO l_n
             FROM abb_file,aba_file
            WHERE abb00 = aba00
              AND abb01 = aba01
              AND aba00 = bookno     
              AND abb03 = sr1.aag01
              AND aba02 >= bdate
              AND aba02 <= edate
              AND aba03 = yy
              AND abapost ='Y'
              AND abaacti ='Y'
              AND abb07 !=0
        ELSE
           SELECT COUNT(*) INTO l_n
             FROM abb_file,aba_file
            WHERE abb00 = aba00
              AND abb01 = aba01
              AND aba00 = bookno    
              AND abb03 = sr1.aag01
              AND aba02 >= bdate
              AND aba02 <= edate
              AND aba03 = yy
              AND abapost ='Y'
              AND abaacti ='Y'
              AND abb24 = tm.o        	
              AND abb07 !=0
        END IF
 
#No.MOD-8C0126 --end
        IF cl_null(s_abb07) THEN LET s_abb07 = 0 END IF
        IF cl_null(s_abb07f) THEN LET s_abb07f = 0 END IF
#       IF l_bal = 0 AND s_abb07 = 0 AND s_abb07f = 0 THEN CONTINUE FOREACH END IF
        IF l_bal = 0 AND s_abb07 = 0 AND s_abb07f = 0 AND l_n =0 THEN CONTINUE FOREACH END IF  #No.MOD-8C0126
        FOR l_i = mm1 TO nn1
            LET g_cnt = 0
            LET l_flag='N'
            FOREACH gglr301_curs1 USING sr1.aag01,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               #No.TQC-A50151  --Begin
               IF tm.k <> '3' THEN
                  LET sr.aea02 = sr.aba02
               END IF
               #No.TQC-A50151  --End n
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02 = l_date1
               LET l_flag='Y'
               LET sr.aag02=sr1.aag02
               LET sr.aag08=sr1.aag08
               LET sr.qcye = l_bal
               LET sr.qcye1 = l_bal2
               IF sr1.aag07 = '3' THEN
                  LET sr.aag08 = ''
               ELSE
                  #FUN-6C0012.....begin
#                  CALL gglr301_sjkm(sr1.aag01,sr1.aag24)   #組一級科目到當前
#                       RETURNING p_aag02         #明細科目的科目名稱
                  IF tm.e = 'Y' THEN                                            
                     SELECT aag13 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24   AND aag00 = bookno         #NO.FUN-740055             
                  ELSE                                                          
                     SELECT aag02 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24  AND aag00 = bookno         #NO.FUN-740055           
                  END IF                                                        
                  #FUN-6C0012.....end
                  LET sr.aag02 = p_aag02
               END IF
               #No.FUN-7C0064  --Begin
               #OUTPUT TO REPORT gglr301_rep(sr.*)
               SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
                WHERE azi01 = sr.abb24
               EXECUTE insert_prep USING sr.*,t_azi04,t_azi07,
                       '0','0','0','0','0','0','0','0','0'
               #No.FUN-7C0064  --End
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
               LET sr.aag08= sr1.aag08
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02 = l_date1
               LET sr.qcye = l_bal
               LET sr.qcye1 = l_bal2
               LET sr.abb25 = 1
               LET sr.aba04 = l_i
               LET sr.abb07=0
               LET sr.abb07f = 0
               IF sr1.aag07 = '3' THEN
                  LET sr.aag08 = ''
               ELSE
                  #FUN-6C0012....begin
#                  CALL gglr301_sjkm(sr1.aag01,sr1.aag24)  #組科目名稱
#                       RETURNING p_aag02
                  IF tm.e = 'Y' THEN                                            
                     SELECT aag13 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24  AND aag00 = bookno    #NO.FUN-740055           
                  ELSE                                                          
                     SELECT aag02 INTO p_aag02 FROM aag_file                    
                      WHERE aag01 = sr1.aag01 AND aag24 = sr1.aag24  AND aag00 = bookno    #NO.FUN-740055            
                  END IF
                  #FUN-6C0012.....end
                  LET sr.aag02 = p_aag02
               END IF
               #No.FUN-7C0064  --Begin
               LET l_flag = 'Y'
               #OUTPUT TO REPORT gglr301_rep(sr.*)
               SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
                WHERE azi01 = sr.abb24
               EXECUTE insert_prep USING sr.*,t_azi04,t_azi07,
                       '0','0','0','0','0','0','0','0','0'
               #No.FUN-7C0064  --End  
            END IF
            #No.FUN-7C0064  --Begin
            IF l_flag = 'Y' THEN 
               CALL s_yp(edate) RETURNING l_year,l_month
               IF l_i = l_month THEN
                  LET sr.aba02 = edate
               END IF
               CALL r301_cr(sr1.aag01,l_i) RETURNING l_abb07f1,l_abb071,
                    l_abb07f2,l_abb072,l_tah09,l_tah04,l_tah10,l_tah05
               EXECUTE insert_prep USING sr.*,t_azi04,t_azi07,
                       l_abb07f1,l_abb071,
                       l_abb07f2,l_abb072,l_tah09,l_tah04,l_tah10,l_tah05,'1'
            END IF
            #No.FUN-7C0064  --End  
        END FOR
     END FOREACH
     #No.FUN-7C0064  --Begin
     #FINISH REPORT gglr301_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc1,'aag01')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",yy,";",tm.e,";",bdate USING "yyyy/mm/dd" ,";",g_azi04
     CALL cl_prt_cs3('gglr301',l_name,g_sql,g_str)
     #No.FUN-7C0064  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
#FUN-6C0012.....begin mark
#FUNCTION gglr301_sjkm(l_aag01,l_aag24)   #追溯上級科目名稱且將其連成一體
#   DEFINE l_aag24 LIKE aag_file.aag24
#   DEFINE l_aag01 LIKE aag_file.aag01
#   DEFINE s_aag08 LIKE aag_file.aag08
#   DEFINE s_aag24 LIKE aag_file.aag24
#   DEFINE s_aag02 LIKE aag_file.aag02
#   DEFINE p_aag02,p_aag021    LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(100)
#   DEFINE l_success,l_i       LIKE type_file.num5     #NO FUN-690009   SMALLINT
#   LET l_success = 1
#   LET l_i = 1
#   WHILE l_success
#   SELECT aag02,aag08,aag24 INTO s_aag02,s_aag08,s_aag24 FROM aag_file
#    WHERE aag01 = l_aag01     #NO.FUN-740055
#   IF SQLCA.sqlcode THEN
#      LET l_success = 0
#      EXIT WHILE
#   END IF
#   IF l_i = 1 THEN
#      LET p_aag02 = s_aag02
#   ELSE
#      LET p_aag021 = p_aag02
#      LET p_aag02 = s_aag02 CLIPPED,'-',p_aag021 CLIPPED
#   END IF
#   LET l_i = l_i + 1
#   IF s_aag24 = 1 OR s_aag08 = l_aag01 THEN LET l_success = 1 EXIT WHILE END IF
#   LET l_aag01 = s_aag08
#   LET l_aag24 = l_aag24 - 1
#   END WHILE
#   RETURN p_aag02   #結果
#END FUNCTION
#FUN-6C0012.....end
FUNCTION gglr301_qcye(aea05)   #計算列印期間前的余額
   DEFINE aea05 LIKE aea_file.aea05
   DEFINE l_bal,l_bal1,l_bal2,n_bal,n_bal1,l_d,l_c,l_d1,l_c1 LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
   LET l_bal = 0
   LET l_bal1 = 0
   LET l_d = 0
   LET l_d1 = 0
   LET l_c = 0
   LET l_c1 = 0
   LET n_bal = 0
   LET n_bal1 = 0
   IF tm.n = "N" THEN
      IF g_aaz.aaz51 = 'Y' THEN   #每日餘額檔
         SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
          WHERE aah01 = aea05 AND aah02 = yy AND aah03 = 0
            AND aah00 = bookno   #NO.FUN-740055
         SELECT SUM(aas04-aas05) INTO l_bal1   FROM aas_file
          WHERE aas00 = bookno AND aas01 = aea05    #NO.FUN-740055
            AND YEAR(aas02) = yy AND aas02 < bdate
      ELSE
         SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
          WHERE aah01 = aea05 AND aah02 = yy AND aah03 < mm
            AND aah00 = bookno     #NO.FUN-740055
         SELECT SUM(abb07) INTO l_d FROM abb_file,aba_file
          WHERE abb03 = aea05 AND aba01 = abb01 AND abb06='1'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = bookno AND abapost='Y'      #NO.FUN-740055
            AND aba03=yy AND aba04=mm
         SELECT SUM(abb07) INTO l_c FROM aba_file,abb_file
          WHERE abb03 = aea05 AND aba01 = abb01 AND abb06='2'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = bookno AND abapost='Y'         #NO.FUN-740055
            AND aba03=yy AND aba04=mm
      END IF
   ELSE
      IF g_aaz.aaz51 = 'Y' THEN   #每日餘額檔
         SELECT SUM(tah04-tah05),SUM(tah09-tah10)
           INTO l_bal,n_bal FROM tah_file
          WHERE tah01 = aea05 AND tah02 = yy AND tah03 = 0
            AND tah00 = bookno    #No.FUN-740055
            #AND tah08 MATCHES tm.o   #MOD-820082
            AND tah08 = tm.o   #MOD-820082
         SELECT SUM(tas04-tas05),SUM(tas09-tas10)
           INTO l_bal1,n_bal1 FROM tas_file
          WHERE tas00 = bookno AND tas01 = aea05    #NO.FUN-740055
            AND YEAR(tas02) = yy AND tas02 < bdate
            #AND tas08 MATCHES tm.o   #MOD-820082
            AND tas08 = tm.o   #MOD-820082
      ELSE
         SELECT SUM(tah04-tah05),SUM(tah09-tah10)
           INTO l_bal,n_bal FROM tah_file
          WHERE tah01 = aea05 AND tah02 = yy AND tah03 < mm
            AND tah00 = bookno    #NO.FUN-740055
            #AND tah08 MATCHES tm.o   #MOD-820082
            AND tah08 = tm.o   #MOD-820082
         SELECT SUM(abb07),SUM(abb07f)
           INTO l_d,l_d1 FROM abb_file,aba_file
          WHERE abb03 = aea05 AND aba01 = abb01 AND abb06='1'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = bookno AND abapost='Y'   #NO.FUN-740055
            AND aba03=yy AND aba04=mm
            #AND abb24 MATCHES tm.o   #MOD-640022
            AND abb24 = tm.o   #MOD-640022
         SELECT SUM(abb07),SUM(abb07f)
           INTO l_c,l_c1 FROM aba_file,abb_file
          WHERE abb03 = aea05 AND aba01 = abb01 AND abb06='2'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = bookno AND abapost='Y'     #NO.FUN-740055
            AND aba03=yy AND aba04=mm
            #AND abb24 MATCHES tm.o   #MOD-640022
            AND abb24 = tm.o   #MOD-640022
      END IF
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
 
#No.FUN-7C0064  --Begin
#REPORT gglr301_rep(sr)
#   DEFINE
#          sr     RECORD
#                 aea05  LIKE aea_file.aea05,
#                 aea02  LIKE aea_file.aea02,
#                 aea03  LIKE aea_file.aea03,
#                 aea04  LIKE aea_file.aea04,
#                 aba04  LIKE aba_file.aba04,
#                 aba02  LIKE aba_file.aba02,   # Source code
#                 abb04  LIKE abb_file.abb04,
#                 abb24  LIKE abb_file.abb24,
#                 abb25  LIKE abb_file.abb25,
#                 abb06  LIKE abb_file.abb06,
#                 abb07  LIKE abb_file.abb07,
#                 abb07f LIKE abb_file.abb07f,
#                 aag02  LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(100)
#                 aag08  LIKE aag_file.aag08,
#                 qcye   LIKE abb_file.abb07,     #No.A114
#                 qcye1  LIKE abb_file.abb07      #No.A114
#                 END RECORD,
#	  l_bal,n_bal,n_bal2           LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_date2                      LIKE type_file.dat,     #NO FUN-690009   DATE
#          l_last_aba04                 LIKE aba_file.aba04,
#          l_yyyy                       LIKE aba_file.aba03,    #NO FUN-690009   DECIMAL(4,0),
#          l_cc1,l_cc2                  LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_last_sw                    LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#          l_date                       LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(10),
#	  l_abb07,l_aah04,l_aah05      LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_abb07f                     LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          s_abb07,s_abb07f             LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          t_abb071,t_abb07f1           LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          t_abb072,t_abb07f2           LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_abb071,l_abb072            LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_tah04,l_tah05              LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_tah09,l_tah10              LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          t_tah04,t_tah05              LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          t_tah09,t_tah10              LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          l_abb07f1,l_abb07f2          LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#          m_abb071,m_abb072            LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)  #add 030901 NO.A085
#          m_abb07f1,m_abb07f2          LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)  #add 030901 NO.A085
#          m_tah04,m_tah05              LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)  #add 030901 NO.A085
#          m_tah09,m_tah10              LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)  #add 030901 NO.A085
#          l_year                       LIKE type_file.num10,   #NO FUN-690009   INTEGER        #add 030901 NO.A085
#          l_month                      LIKE type_file.num10    #NO FUN-690009   INTEGER         #add 030901 NO.A085
#
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# #modify 030901 NO.A085
#   ORDER BY sr.aea05,sr.aba04,sr.aea02,sr.aea03,sr.aea04 #No.MOD-560280
#  #end NO.A085----------
#  FORMAT
#    PAGE HEADER
##FUN-670106--begin
##     IF tm.n ='Y' THEN    #根據是否列印外幣分成不同的兩個表頭，將兩者行的差
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #異放在列印公司前
##        IF g_towhom IS NULL OR g_towhom = ' ' THEN
##           PRINT '';
##        ELSE
##           PRINT 'TO:',g_towhom;
##        END IF
##        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
##        PRINT g_head CLIPPED,pageno_total     # No.TQC-750022 
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
##        PRINT ' '
#         LET l_yyyy = yy
#         PRINT COLUMN ((g_len-11)/2)+1,"(",l_yyyy,"  )" CLIPPED,g_x[30] CLIPPED
#         PRINT g_head CLIPPED,pageno_total     # No.TQC-750022 
##        LET g_pageno = g_pageno + 1
#         PRINT g_x[11] CLIPPED,sr.aea05 CLIPPED
#         #FUN-6C0012.....begin
#         IF tm.e = 'N' THEN
#            PRINT g_x[12] CLIPPED,sr.aag02 CLIPPED #列印明細科目
#         ELSE
#            PRINT g_x[54] CLIPPED,sr.aag02 CLIPPED
#         END IF
#         #FUN-6C0012.....end
##              COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#         PRINT g_dash[1,g_len]
#         #NO:7911
##        PRINT COLUMN 85,g_x[31] CLIPPED,
##              COLUMN 120,g_x[32] CLIPPED,
##              COLUMN 163,g_x[33] CLIPPED
##        PRINT  COLUMN 70,'------------------------------------- ',
##              '------------------------------------- ',g_x[35] CLIPPED,
##              ' ------------------------------------- '
##
##        PRINT COLUMN 1,g_x[13] CLIPPED,
##              COLUMN 54,g_x[14] CLIPPED,
##              COLUMN 114,g_x[15] CLIPPED,
##              COLUMN 151,g_x[16] CLIPPED,
##              COLUMN 170,g_x[17] CLIPPED
##        PRINT '-------- ------------ ------------------------------ ---- ---------- ',
##              '------------------ ------------------ ------------------ ------------------ ',
##               '-- ------------------ ------------------'
##        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],   --By ice
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                        g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#                        g_x[43],g_x[44],g_x[45],g_x[46]
#         PRINT g_dash1 
#         #NO:7911 end
##     ELSE
##         SKIP 2 LINE             #不列印外幣少兩行，之所以這樣純粹美觀問題
#  #      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#  #      IF g_towhom IS NULL OR g_towhom = ' ' THEN
#  #         PRINT '';
#  #      ELSE
#  #         PRINT 'TO:',g_towhom;
#  #      END IF
#  #      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#  #      LET g_pageno = g_pageno + 1 
#  #      LET pageno_total = PAGENO USING '<<<',"/pageno"
#  #      PRINT g_head CLIPPED,pageno_total 
#  #      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] 
#  #      PRINT ' '
#  #      LET l_yyyy = yy
#  #      PRINT COLUMN ((g_len-11)/2)+1,"(",l_yyyy,"  )" CLIPPED,g_x[30] CLIPPED
#  #      LET g_pageno = g_pageno + 1
#  #      PRINT g_x[11] CLIPPED,sr.aea05 CLIPPED
#  #      PRINT g_x[12] CLIPPED,sr.aag02 CLIPPED  #列印明細科目
#  #            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#  #      PRINT g_dash[1,g_len]
#  #      #NO:7911
#  #      PRINT COLUMN 1,g_x[24] CLIPPED,
#  #            COLUMN 54,g_x[25] CLIPPED,
#  #             COLUMN 84,g_x[26] CLIPPED
#  #      PRINT '-------- ------------ ------------------------------ ',
#  #            '------------------ ------------------ ---- ------------------'
#  #      PRINTX name=H1 g_x[31],g_x[32],g_x[33],
#  #                     g_x[34],g_x[35],g_x[36],
#  #                     g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#  #                     g_x[43],g_x[44],g_x[45],g_x[46]
#  #      PRINT g_dash1 
#  #     #NO:7911 end以下所有的column均有調整
#  #   END IF
##FUN-670106--end 
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.aea05     #明細科目
#      SKIP TO TOP OF PAGE
#      LET l_cc1 = 0
#      LET l_cc2 = 0
#      IF sr.qcye < 0 THEN LET n_bal = sr.qcye * (-1) END IF
#      IF sr.qcye1 < 0 THEN LET n_bal2 = sr.qcye1 * (-1) END IF
# #modify 030901 NO.A085
##      LET l_date = yy USING "####","/",MONTH(bdate) USING "##",'/01'
##      LET l_date2 = l_date
#      LET l_date2 = bdate
#      #end NO.A085
#      #NO:7911
#      SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file     #No.CHI-6A0004
#       WHERE azi01 = sr.abb24
#      #NO:7911 end
#      PRINT COLUMN 1,l_date2;
#      IF tm.n = 'Y' THEN    #根據原幣，本幣列印期初余額
#         PRINT COLUMN 21,g_x[27] CLIPPED;
#         IF sr.qcye1 > 0 THEN
##FUN-670106--begin
#            PRINT COLUMN g_c[40],g_x[28] CLIPPED,
#                  COLUMN g_c[41],cl_numfor(sr.qcye1,40,t_azi04);  #No.CHI-6A0004
#         ELSE
#            IF sr.qcye1 < 0 THEN
#               PRINT COLUMN g_c[40],g_x[29] CLIPPED,
#                     COLUMN g_c[41],cl_numfor(n_bal2,40,t_azi04);  #No.CHI-6A0004
#            ELSE
#               PRINT COLUMN g_c[40],g_x[53] CLIPPED,
#                     COLUMN g_c[41],cl_numfor(sr.qcye1,41,t_azi04);   #No.CHI-6A0004
#            END IF
#         END IF
#         IF sr.qcye >= 0 THEN
#            PRINT COLUMN g_c[42],cl_numfor(sr.qcye,42,t_azi04)          #No.CHI-6A0004
#         ELSE
#            PRINT COLUMN g_c[42],cl_numfor(n_bal,42,t_azi04)          #No.CHI-6A0004
#         END IF
#      ELSE
#         PRINT COLUMN 21,g_x[27] CLIPPED;
#         IF sr.qcye > 0 THEN
#            PRINT COLUMN g_c[45] ,g_x[28] CLIPPED,
#                  COLUMN g_c[46],cl_numfor(sr.qcye,46,t_azi04)       #No.CHI-6A0004
#         ELSE
#            IF sr.qcye < 0 THEN
#               PRINT COLUMN g_c[45],g_x[29] CLIPPED,
#                     COLUMN g_c[46],cl_numfor(n_bal,46,t_azi04)      #No.CHI-6A0004
#            ELSE
#               PRINT COLUMN g_c[45],g_x[53] CLIPPED,
#                     COLUMN g_c[46],cl_numfor(sr.qcye,46,t_azi04)    #No.CHI-6A0004
#            END IF
#         END IF
#      END IF
#   ON EVERY ROW
#      #NO:7911
#      SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file    #No.CHI-6A0004
#       WHERE azi01 = sr.abb24
#      #NO:7911 end
#      IF cl_null(sr.abb07) THEN LET sr.abb07 = 0 END IF
#      IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
#      IF sr.abb06 = 1 THEN
#         LET l_cc1 = sr.qcye + sr.abb07
#         LET l_cc2 = sr.qcye1 + sr.abb07f
#      ELSE
#         LET l_cc1 = sr.qcye - sr.abb07
#         LET l_cc2 = sr.qcye1 - sr.abb07f
#      END IF
#      IF cl_null(l_cc1) THEN LET l_cc1 = 0 END IF
#      IF cl_null(l_cc2) THEN LET l_cc2 = 0 END IF
#      IF sr.qcye < 0 THEN LET n_bal = sr.qcye * (-1) END IF
#      IF sr.qcye1 < 0 THEN LET n_bal2 = sr.qcye1 * (-1) END IF
#      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
#         IF tm.n = 'N' THEN
#            PRINT COLUMN g_c[31],sr.aea02 CLIPPED,
#                  COLUMN g_c[32],sr.aea03 CLIPPED,
#                  COLUMN g_c[33],sr.abb04 CLIPPED;
#            IF sr.abb06 = 1 THEN
#               PRINT COLUMN g_c[43],cl_numfor(sr.abb07,43,t_azi04);  #No.CHI-6A0004
#            ELSE 
#               PRINT COLUMN g_c[44],cl_numfor(sr.abb07,44,t_azi04);  #No.CHI-6A0004
#            END IF
#            IF l_cc1 > 0 THEN
#               PRINT COLUMN g_c[45] ,g_x[28] CLIPPED,
#                     COLUMN g_c[46] ,cl_numfor(l_cc1,46,t_azi04)     #No.CHI-6A0004
#            ELSE
#               IF l_cc1 < 0 THEN
#                  LET l_cc1 = l_cc1 * (-1)
#                  PRINT COLUMN g_c[45] ,g_x[29] CLIPPED,
#                        COLUMN g_c[46] ,cl_numfor(l_cc1,46,t_azi04)  #No.CHI-6A0004
#                  LET l_cc1 = l_cc1 * (-1)
#               ELSE
#               PRINT COLUMN g_c[45] ,'  ',
#                     COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)      #No.CHI-6A0004
#               END IF
#            END IF
#         ELSE
#
#            PRINT COLUMN g_c[31],sr.aea02,
#                  COLUMN g_c[32],sr.aea03 CLIPPED,
#                  COLUMN g_c[33],sr.abb04 CLIPPED,
#                  COLUMN g_c[34],sr.abb24 CLIPPED,
#                  COLUMN g_c[35],cl_numfor(sr.abb25,35,t_azi07);     #No.CHI-6A0004
#
#            IF sr.abb06 = 1 THEN
#               PRINT COLUMN g_c[36],cl_numfor(sr.abb07f,36,t_azi04),  #No.CHI-6A0004
#                     COLUMN g_c[37],cl_numfor(sr.abb07,37,t_azi04);   #No.CHI-6A0004
#            ELSE
#               PRINT COLUMN g_c[38],cl_numfor(sr.abb07f,38,t_azi04),  #No.CHI-6A0004
#                     COLUMN g_c[39],cl_numfor(sr.abb07,39,t_azi04);   #No.CHI-6A0004
#            END IF
#            IF l_cc2 > 0 THEN
#               PRINT COLUMN g_c[40],g_x[28] CLIPPED;
#               PRINT COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04);      #No.CHI-6A0004
#            ELSE
#               IF l_cc2 < 0 THEN
#                  LET l_cc2 = l_cc2 * (-1)
#                  PRINT COLUMN g_c[40],g_x[29] CLIPPED;
#                  PRINT COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04);   #No.CHI-6A0004
#                  LET l_cc2 = l_cc2 * (-1)
#               ELSE
#                  PRINT COLUMN g_c[40],'  ',
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04);   #No.CHI-6A0004
#               END IF
#            END IF
#            IF l_cc1 > 0 THEN
#               PRINT COLUMN g_c[42],cl_numfor(l_cc1,42,t_azi04)       #No.CHI-6A0004
#            ELSE
#               IF l_cc1 < 0 THEN
#                  LET l_cc1 = l_cc1 * (-1)
#                  PRINT COLUMN g_c[42],cl_numfor(l_cc1,42,t_azi04)    #No.CHI-6A0004
#                  LET l_cc1 = l_cc1 * (-1)
#               ELSE
#                  PRINT COLUMN g_c[42],cl_numfor(l_cc1,42,t_azi04)    #No.CHI-6A0004
#               END IF
#            END IF
#         END IF
#      END IF
##FUN-670106--end
# 
#   AFTER GROUP OF sr.aba04
#      #NO:7911
#      SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file     #No.CHI-6A0004
#       WHERE azi01 = sr.abb24
#      #NO:7911 end
#
#  #modify 030901 NO.A085
#      IF tm.n = 'N' THEN   #本幣當期當年異動總和
#         SELECT SUM(abb07) INTO l_abb071 FROM abb_file,aba_file #借 當期
#          WHERE abb03 = sr.aea05 AND aba01 = abb01 AND abb06='1'
#            AND abb00 = aba00
#            AND aba02 >= bdate   AND aba02 <= edate
#            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
#            AND aba03=yy AND aba04=sr.aba04
#         SELECT SUM(abb07) INTO l_abb072 FROM abb_file,aba_file #貸 當期
#          WHERE abb03 = sr.aea05 AND aba01 = abb01 AND abb06='2'
#            AND abb00 = aba00
#            AND aba02 >= bdate   AND aba02 <= edate
#            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
#            AND aba03=yy AND aba04=sr.aba04
#         SELECT SUM(abb07) INTO l_tah04 FROM abb_file,aba_file #借 本年
#          WHERE abb03 = sr.aea05 AND aba01 = abb01
#            AND abb00 = aba00 AND aba00 = bookno     #NO.FUN-740055
#            AND aba03 = yy AND aba04 <=sr.aba04
#            AND aba02 <= edate
#            AND abapost='Y' AND abb06='1'
#         SELECT SUM(abb07) INTO l_tah05 FROM abb_file,aba_file #貸 本年
#          WHERE abb03 = sr.aea05 AND aba01 = abb01
#            AND abb00 = aba00 AND aba00 = bookno     #NO.FUN-740055
#            AND aba03 = yy AND aba04 <=sr.aba04
#            AND aba02 <= edate
#            AND abapost='Y' AND abb06='2'
#      ELSE   #原幣，本幣當期異動總和
#         SELECT SUM(abb07),SUM(abb07f) INTO l_abb071,l_abb07f1  #借 當期
#           FROM abb_file,aba_file
#          WHERE abb03 = sr.aea05 AND aba01 = abb01 AND abb06='1'
#            AND abb00 = aba00
#            AND aba02 >= bdate   AND aba02 <= edate
#            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
#            AND aba03 = yy AND aba04=sr.aba04
#            #AND abb24 MATCHES tm.o   #MOD-640022
#            AND abb24 = tm.o   #MOD-640022
#         SELECT SUM(abb07),SUM(abb07f) INTO l_abb072,l_abb07f2 #貸 當期
#           FROM abb_file,aba_file
#          WHERE abb03 = sr.aea05 AND aba01 = abb01 AND abb06='2'
#            AND abb00 = aba00
#            AND aba02 >= bdate   AND aba02 <= edate
#            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
#            AND aba03 = yy AND aba04=sr.aba04
#            #AND abb24 MATCHES tm.o   #MOD-640022
#            AND abb24 = tm.o   #MOD-640022
#         SELECT SUM(abb07),SUM(abb07f) INTO l_tah04,l_tah09
#           FROM abb_file,aba_file                           #借 本年
#          WHERE abb03 = sr.aea05 AND aba01 = abb01
#            AND abb00 = aba00 AND aba00 = bookno                     #NO.FUN-740055
#            AND aba03 = yy AND aba04 <=sr.aba04
#            AND aba02 <= edate
#            AND abapost='Y' AND abb06='1'
#            #AND abb24 MATCHES tm.o   #MOD-640022
#            AND abb24 = tm.o   #MOD-640022
#         SELECT SUM(abb07),SUM(abb07f) INTO l_tah05,l_tah10
#           FROM abb_file,aba_file                           #貸 本年
#          WHERE abb03 = sr.aea05 AND aba01 = abb01
#            AND abb00 = aba00 AND aba00 = bookno   #NO.FUN-740055
#            AND aba03 = yy AND aba04 <=sr.aba04
#            AND aba02 <= edate
#            AND abapost='Y' AND abb06='2'
#            #AND abb24 MATCHES tm.o   #MOD-640022
#            AND abb24 = tm.o   #MOD-640022
#      END IF
#
#      IF cl_null(l_abb071) THEN LET l_abb071 =0 END IF
#      IF cl_null(l_abb072) THEN LET l_abb072 =0 END IF
#      IF cl_null(l_abb07f1) THEN LET l_abb07f1 =0 END IF
#      IF cl_null(l_abb07f2) THEN LET l_abb07f2 =0 END IF
#      IF cl_null(l_tah04) THEN LET l_tah04 =0 END IF
#      IF cl_null(l_tah05) THEN LET l_tah05 =0 END IF
#      IF cl_null(l_tah09) THEN LET l_tah09 =0 END IF
#      IF cl_null(l_tah10) THEN LET l_tah10 =0 END IF
#
#      IF tm.k ='1' THEN
#         IF tm.n = 'N' THEN
#            SELECT SUM(abb07) INTO m_abb071
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno    #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 =sr.aba04
#            SELECT SUM(abb07) INTO m_abb072
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno     #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 =sr.aba04
#            SELECT SUM(abb07) INTO m_tah04
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno       #NO.FUN-740055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#            SELECT SUM(abb07) INTO m_tah05
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno     #NO.FUN-740055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#         ELSE
#            SELECT SUM(abb07),SUM(abb07f) INTO m_abb071,m_abb07f1
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno      #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 =sr.aba04
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#            SELECT SUM(abb07),SUM(abb07f) INTO m_abb072,m_abb07f2
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno      #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 =sr.aba04
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#            SELECT SUM(abb07),SUM(abb07f) INTO m_tah04,m_tah09
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno     #NO.FUN-740055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#            SELECT SUM(abb07),SUM(abb07f) INTO m_tah05,m_tah10
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno      #NO.FUN-740055 
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#         END IF
#      IF m_abb071 IS NULL THEN LET m_abb071 = 0 END IF
#         IF m_abb072 IS NULL THEN LET m_abb072 = 0 END IF
#         IF m_abb07f1 IS NULL THEN LET m_abb07f1 =0 END IF
#         IF m_abb07f2 IS NULL THEN LET m_abb07f2 =0 END IF
#         IF m_tah04  IS NULL THEN LET m_tah04 = 0 END IF
#         IF m_tah05  IS NULL THEN LET m_tah05 = 0 END IF
#         IF m_tah09  IS NULL THEN LET m_tah09 = 0 END IF
#         IF m_tah10  IS NULL THEN LET m_tah10 = 0 END IF
#         LET l_abb071 = l_abb071 + m_abb071
#         LET l_abb072 = l_abb072 + m_abb072
#         LET l_abb07f1 = l_abb07f1 + m_abb07f1
#         LET l_abb07f2 = l_abb07f2 + m_abb07f2
#         LET l_tah04   = l_tah04 + m_tah04
#         LET l_tah05   = l_tah05 + m_tah05
#         LET l_tah09   = l_tah09 + m_tah09
#         LET l_tah10   = l_tah10 + m_tah10
#      END IF
#      IF tm.k ='2' THEN
#         IF tm.n = 'N' THEN
#            SELECT SUM(abb07) INTO m_abb071
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno      #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19   ='Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 =sr.aba04
#            SELECT SUM(abb07) INTO m_abb072
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno      #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19  = 'Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 =sr.aba04
#            SELECT SUM(abb07) INTO m_tah04
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno       #NO.FUN-740055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19   ='Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#            SELECT SUM(abb07) INTO m_tah05
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno       #NO.FUN-740055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19   ='Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#         ELSE
#            SELECT SUM(abb07),SUM(abb07f) INTO m_abb071,m_abb07f1
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno     #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19   ='Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 =sr.aba04
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#            SELECT SUM(abb07),SUM(abb07f) INTO m_abb072,m_abb07f2
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno   #NO.FUN-740055
#               AND aba02 >=bdate  AND aba02 <=edate
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19  = 'Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 =sr.aba04
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#            SELECT SUM(abb07),SUM(abb07f) INTO m_tah04,m_tah09
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno     #NO.FUN-70055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19   ='Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='1'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#            SELECT SUM(abb07),SUM(abb07f) INTO m_tah05,m_tah10
#              FROM  abb_file,aba_file
#             WHERE aba00 = abb00
#               AND aba01 = abb01
#               AND aba00 = bookno    #NO.FUN-740055
#               AND abaacti ='Y'
#               AND abapost ='N'
#               AND aba19   ='Y'
#               AND abb03  = sr.aea05
#               AND abb06 ='2'
#               AND aba03 =yy AND aba04 <=sr.aba04  AND aba02<=edate
#               #AND abb24 MATCHES tm.o   #MOD-640022
#               AND abb24 = tm.o   #MOD-640022
#         END IF
#         IF m_abb071 IS NULL THEN LET m_abb071 = 0 END IF
#         IF m_abb072 IS NULL THEN LET m_abb072 = 0 END IF
#         IF m_abb07f1 IS NULL THEN LET m_abb07f1 =0 END IF
#         IF m_abb07f2 IS NULL THEN LET m_abb07f2 =0 END IF
#         IF m_tah04  IS NULL THEN LET m_tah04 = 0 END IF
#         IF m_tah05  IS NULL THEN LET m_tah05 = 0 END IF
#         IF m_tah09  IS NULL THEN LET m_tah09 = 0 END IF
#         IF m_tah10  IS NULL THEN LET m_tah10 = 0 END IF
#         LET l_abb071 = l_abb071 + m_abb071
#         LET l_abb072 = l_abb072 + m_abb072
#         LET l_abb07f1 = l_abb07f1 + m_abb07f1
#         LET l_abb07f2 = l_abb07f2 + m_abb07f2
#         LET l_tah04   = l_tah04 + m_tah04
#         LET l_tah05   = l_tah05 + m_tah05
#         LET l_tah09   = l_tah09 + m_tah09
#   LET l_tah10   = l_tah10 + m_tah10
#      END IF
#
#      CALL s_yp(edate) RETURNING l_year,l_month
#      IF sr.aba04 = l_month THEN
#         LET sr.aba02 = edate
#      END IF
#      #end NO.A085----------
##FUN-670106--begin
#      PRINT COLUMN g_c[31],sr.aba02;
#      IF tm.n = 'Y' THEN
#         PRINT COLUMN 34,g_x[19] CLIPPED,               #當期
#               COLUMN g_c[36],cl_numfor(l_abb07f1,36,t_azi04),  #No.CHI-6A0004
#               COLUMN g_c[37],cl_numfor(l_abb071,37,t_azi04),   #No.CHI-6A0004
#               COLUMN g_c[38],cl_numfor(l_abb07f2,38,t_azi04),  #No.CHI-6A0004
#               COLUMN g_c[39],cl_numfor(l_abb072,39,t_azi04);   #No.CHI-6A0004
#         CASE
#             WHEN l_cc2 > 0
#                  PRINT COLUMN g_c[40],g_x[28] CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04); #No.CHI-6A0004
#             WHEN l_cc2 < 0
#                  LET l_cc2 = l_cc2 * (-1)
#                  PRINT COLUMN g_c[40],g_x[29] CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04); #No.CHI-6A0004 
#                  LET l_cc2 = l_cc2 * (-1)
#             OTHERWISE
#                  PRINT COLUMN g_c[40],g_x[53] CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04); #No.CHI-6A0004
#         END CASE
#         IF l_cc1 >= 0 THEN
#            PRINT COLUMN g_c[42],cl_numfor(l_cc1,42,t_azi04)    #No.CHI-6A0004
#         ELSE
#            LET l_cc1 = l_cc1 * (-1)
#            PRINT COLUMN g_c[42],cl_numfor(l_cc1,42,t_azi04)    #No.CHI-6A0004
#            LET l_cc1 = l_cc1 * (-1)
#         END IF
#         PRINT COLUMN g_c[31],sr.aba02;
#         PRINT COLUMN 34,g_x[20] CLIPPED,             #當年
#               COLUMN g_c[36],cl_numfor(l_tah09,36,t_azi04),   #No.CHI-6A0004
#               COLUMN g_c[37],cl_numfor(l_tah04,37,t_azi04),   #No.CHI-6A0004
#               COLUMN g_c[38],cl_numfor(l_tah10,38,t_azi04),   #No.CHI-6A0004
#               COLUMN g_c[39],cl_numfor(l_tah05,39,t_azi04);   #No.CHI-6A0004
#         CASE
#             WHEN l_cc2 > 0
#                  PRINT COLUMN g_c[40],g_x[28] CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04);   #No.CHI-6A0004
#             WHEN l_cc2 < 0
#                  LET l_cc2 = l_cc2 * (-1)
#                  PRINT COLUMN g_c[40],g_x[29] CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04);   #No.CHI-6A0004
#                  LET l_cc2 = l_cc2 * (-1)
#             OTHERWISE
#                  PRINT COLUMN g_c[40],g_x[53] CLIPPED,
#                        COLUMN g_c[41],cl_numfor(l_cc2,41,t_azi04);   #No.CHI-6A0004
#         END CASE
#         IF l_cc1 >= 0 THEN
#            PRINT COLUMN g_c[42],cl_numfor(l_cc1,41,t_azi04)          #No.CHI-6A0004
#         ELSE
#            LET l_cc1 = l_cc1 * (-1)
#            PRINT COLUMN g_c[42],cl_numfor(l_cc1,42,t_azi04)          #No.CHI-6A0004
#            LET l_cc1 = l_cc1 * (-1)
#         END IF
#      ELSE
#         PRINT COLUMN 39,g_x[19] CLIPPED,                #當期
#               COLUMN g_c[43],cl_numfor(l_abb071,43,t_azi04),         #No.CHI-6A0004
#               COLUMN g_c[44],cl_numfor(l_abb072,44,t_azi04);         #No.CHI-6A0004
#         CASE
#             WHEN l_cc1 > 0
#                  PRINT COLUMN g_c[45],g_x[28] CLIPPED,
#                        COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)    #No.CHI-6A0004
#             WHEN l_cc1 < 0
#                  LET l_cc1 = l_cc1 * (-1)
#                  PRINT COLUMN g_c[45],g_x[29] CLIPPED,
#                        COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)    #No.CHI-6A0004
#                  LET l_cc1 = l_cc1 * (-1)
#             OTHERWISE
#                  PRINT COLUMN g_c[45],g_x[53] CLIPPED,
#                        COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)    #No.CHI-6A0004
#         END CASE
#         PRINT COLUMN g_c[31],sr.aba02;
#         PRINT COLUMN 39,g_x[20] CLIPPED;               #當年
#         PRINT COLUMN g_c[43],cl_numfor(l_tah04,43,t_azi04),          #No.CHI-6A0004
#               COLUMN g_c[44],cl_numfor(l_tah05,44,t_azi04);          #No.CHI-6A0004
#         CASE
#             WHEN l_cc1 > 0
#                  PRINT COLUMN g_c[45],g_x[28] CLIPPED,
#                        COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)    #No.CHI-6A0004
#             WHEN l_cc1 < 0
#                  LET l_cc1 = l_cc1 * (-1)
#                  PRINT COLUMN g_c[45],g_x[29] CLIPPED,
#                        COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)    #No.CHI-6A0004
#                  LET l_cc1 = l_cc1 * (-1)
#             OTHERWISE
#                  PRINT COLUMN g_c[45],g_x[53] CLIPPED,
#                        COLUMN g_c[46],cl_numfor(l_cc1,46,t_azi04)    #No.CHI-6A0004
#         END CASE
#      END IF
#      PRINT
##FUN-670106--end
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc1,'aag01') RETURNING tm.wc1
#         PRINT g_dash[1,g_len]
#	 #TQC-630166
#         #     IF tm.wc1[001,070] > ' ' THEN			# for 80
#	 #	 PRINT g_x[8] CLIPPED,tm.wc1[001,070] CLIPPED END IF
#         #     IF tm.wc1[071,140] > ' ' THEN
#	 #	 PRINT COLUMN 10,     tm.wc1[071,140] CLIPPED END IF
#         #     IF tm.wc1[141,210] > ' ' THEN
#	 # 	 PRINT COLUMN 10,     tm.wc1[141,210] CLIPPED END IF
#         #     IF tm.wc1[211,280] > ' ' THEN
#	 #	 PRINT COLUMN 10,     tm.wc1[211,280] CLIPPED END IF
#	 CALL cl_prt_pos_wc(tm.wc1)
#         #END TQC-630166
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#Patch....NO.TQC-610037 <001> #
 
#No.FUN-7C0064  --Begin
FUNCTION r301_cr(p_aea05,p_aba04)
  DEFINE p_aea05             LIKE aea_file.aea05
  DEFINE p_aba04             LIKE aba_file.aba04
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
      IF tm.n = 'N' THEN   #本幣當期當年異動總和
         SELECT SUM(abb07) INTO l_abb071 FROM abb_file,aba_file #借 當期
          WHERE abb03 = p_aea05 AND aba01 = abb01 AND abb06='1'
            AND abb00 = aba00
            AND aba02 >= bdate   AND aba02 <= edate
            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
            AND aba03=yy AND aba04=p_aba04
         SELECT SUM(abb07) INTO l_abb072 FROM abb_file,aba_file #貸 當期
          WHERE abb03 = p_aea05 AND aba01 = abb01 AND abb06='2'
            AND abb00 = aba00
            AND aba02 >= bdate   AND aba02 <= edate
            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
            AND aba03=yy AND aba04=p_aba04
         SELECT SUM(abb07) INTO l_tah04 FROM abb_file,aba_file #借 本年
          WHERE abb03 = p_aea05 AND aba01 = abb01
            AND abb00 = aba00 AND aba00 = bookno     #NO.FUN-740055
            AND aba03 = yy AND aba04 <=p_aba04
            AND aba02 <= edate
            AND abapost='Y' AND abb06='1'
         SELECT SUM(abb07) INTO l_tah05 FROM abb_file,aba_file #貸 本年
          WHERE abb03 = p_aea05 AND aba01 = abb01
            AND abb00 = aba00 AND aba00 = bookno     #NO.FUN-740055
            AND aba03 = yy AND aba04 <=p_aba04
            AND aba02 <= edate
            AND abapost='Y' AND abb06='2'
      ELSE   #原幣，本幣當期異動總和
         SELECT SUM(abb07),SUM(abb07f) INTO l_abb071,l_abb07f1  #借 當期
           FROM abb_file,aba_file
          WHERE abb03 = p_aea05 AND aba01 = abb01 AND abb06='1'
            AND abb00 = aba00
            AND aba02 >= bdate   AND aba02 <= edate
            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
            AND aba03 = yy AND aba04=p_aba04
            AND abb24 = tm.o   #MOD-640022
         SELECT SUM(abb07),SUM(abb07f) INTO l_abb072,l_abb07f2 #貸 當期
           FROM abb_file,aba_file
          WHERE abb03 = p_aea05 AND aba01 = abb01 AND abb06='2'
            AND abb00 = aba00
            AND aba02 >= bdate   AND aba02 <= edate
            AND aba00 = bookno AND abapost='Y'    #NO.FUN-740055
            AND aba03 = yy AND aba04=p_aba04
            AND abb24 = tm.o   #MOD-640022
         SELECT SUM(abb07),SUM(abb07f) INTO l_tah04,l_tah09
           FROM abb_file,aba_file                           #借 本年
          WHERE abb03 = p_aea05 AND aba01 = abb01
            AND abb00 = aba00 AND aba00 = bookno                     #NO.FUN-740055
            AND aba03 = yy AND aba04 <=p_aba04
            AND aba02 <= edate
            AND abapost='Y' AND abb06='1'
            AND abb24 = tm.o   #MOD-640022
         SELECT SUM(abb07),SUM(abb07f) INTO l_tah05,l_tah10
           FROM abb_file,aba_file                           #貸 本年
          WHERE abb03 = p_aea05 AND aba01 = abb01
            AND abb00 = aba00 AND aba00 = bookno   #NO.FUN-740055
            AND aba03 = yy AND aba04 <=p_aba04
            AND aba02 <= edate
            AND abapost='Y' AND abb06='2'
            AND abb24 = tm.o   #MOD-640022
      END IF
 
      IF cl_null(l_abb071) THEN LET l_abb071 =0 END IF
      IF cl_null(l_abb072) THEN LET l_abb072 =0 END IF
      IF cl_null(l_abb07f1) THEN LET l_abb07f1 =0 END IF
      IF cl_null(l_abb07f2) THEN LET l_abb07f2 =0 END IF
      IF cl_null(l_tah04) THEN LET l_tah04 =0 END IF
      IF cl_null(l_tah05) THEN LET l_tah05 =0 END IF
      IF cl_null(l_tah09) THEN LET l_tah09 =0 END IF
      IF cl_null(l_tah10) THEN LET l_tah10 =0 END IF
 
      IF tm.k ='1' THEN
         IF tm.n = 'N' THEN
            SELECT SUM(abb07) INTO m_abb071
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno    #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 =p_aba04
            SELECT SUM(abb07) INTO m_abb072
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno     #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 =p_aba04
            SELECT SUM(abb07) INTO m_tah04
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno       #NO.FUN-740055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
            SELECT SUM(abb07) INTO m_tah05
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno     #NO.FUN-740055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
         ELSE
            SELECT SUM(abb07),SUM(abb07f) INTO m_abb071,m_abb07f1
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno      #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 =p_aba04
               AND abb24 = tm.o   #MOD-640022
            SELECT SUM(abb07),SUM(abb07f) INTO m_abb072,m_abb07f2
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno      #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 =p_aba04
               AND abb24 = tm.o   #MOD-640022
            SELECT SUM(abb07),SUM(abb07f) INTO m_tah04,m_tah09
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno     #NO.FUN-740055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
               AND abb24 = tm.o   #MOD-640022
            SELECT SUM(abb07),SUM(abb07f) INTO m_tah05,m_tah10
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno      #NO.FUN-740055 
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19 <> 'X'  #CHI-C80041
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
               AND abb24 = tm.o   #MOD-640022
         END IF
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
         IF tm.n = 'N' THEN
            SELECT SUM(abb07) INTO m_abb071
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno      #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19   ='Y'
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 =p_aba04
            SELECT SUM(abb07) INTO m_abb072
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno      #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19  = 'Y'
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 =p_aba04
            SELECT SUM(abb07) INTO m_tah04
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno       #NO.FUN-740055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19   ='Y'
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
            SELECT SUM(abb07) INTO m_tah05
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno       #NO.FUN-740055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19   ='Y'
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
         ELSE
            SELECT SUM(abb07),SUM(abb07f) INTO m_abb071,m_abb07f1
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno     #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19   ='Y'
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 =p_aba04
               AND abb24 = tm.o   #MOD-640022
            SELECT SUM(abb07),SUM(abb07f) INTO m_abb072,m_abb07f2
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno   #NO.FUN-740055
               AND aba02 >=bdate  AND aba02 <=edate
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19  = 'Y'
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 =p_aba04
               AND abb24 = tm.o   #MOD-640022
            SELECT SUM(abb07),SUM(abb07f) INTO m_tah04,m_tah09
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno     #NO.FUN-70055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19   ='Y'
               AND abb03  = p_aea05
               AND abb06 ='1'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
               AND abb24 = tm.o   #MOD-640022
            SELECT SUM(abb07),SUM(abb07f) INTO m_tah05,m_tah10
              FROM  abb_file,aba_file
             WHERE aba00 = abb00
               AND aba01 = abb01
               AND aba00 = bookno    #NO.FUN-740055
               AND abaacti ='Y'
               AND abapost ='N'
               AND aba19   ='Y'
               AND abb03  = p_aea05
               AND abb06 ='2'
               AND aba03 =yy AND aba04 <=p_aba04  AND aba02<=edate
               AND abb24 = tm.o   #MOD-640022
         END IF
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
#No.FUN-7C0064  --End
