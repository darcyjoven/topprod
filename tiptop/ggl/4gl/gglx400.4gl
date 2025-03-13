# Prog. Version..: '5.30.07-13.05.16(00003)'     #
# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: gglx400.4gl
# Descriptions...: 科目餘額外幣評價表
# Input parameter: 05/07/11 by vivien     
# Modify.........: No.MOD-580211 05/09/08 By ice  修改報表列印格式
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改 
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.FUN-740055 07/04/13 By mike 會計科目加帳套
# Modify.........: No.FUN-780031 07/08/28 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.MOD-860252 09/02/18 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.MOD-950238 09/05/22 By lilingyu 串sql時,加串aag00=tah00,并拿掉UNIQUE
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990164 09/09/17 By mike 幣別不可重復 
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.MOD-C40021 12/04/10 By Polly 本幣取位變數 g_azi04/g_azi05改用tm.a帳別為主的帳別取位
# Modify.........: No.MOD-C70285 12/08/03 By Elise 報表應改用帳別幣別進行資料撈取
# Modify.........: No.FUN-D40020 12/11/02 By wangrr CR轉XtraGrid,幣別欄位tah08開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			# Print condition RECORD
           #  wc      VARCHAR(300),	# Where condition
	      wc      STRING,		#TQC-630166
              a       LIKE aaa_file.aaa01,       #帳別編號  #No.FUN-670004
              t       LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)    
              rate_op LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(01)
              e       LIKE type_file.chr1,       #FUN-6C0012
              h       LIKE type_file.chr1,       #MOD-860252
   	      more    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)    # Input more condition(Y/N)
              END RECORD,
          l_azj07         LIKE azj_file.azj07,
          yy,mm           LIKE type_file.chr4,       #NO FUN-690009   DECIMAL(4,0) 
          g_bookno        LIKE aaa_file.aaa01,
          yymm            LIKE type_file.chr8,       #NO FUN-690009   VARCHAR(06)
          g_tot_bal       LIKE eca_file.eca60      #NO FUN-690009   DECIMAL(13,2)    # User defined variable
DEFINE    g_i             LIKE type_file.num5      #NO FUN-690009   SMALLINT         #count/index for any purpose
DEFINE    l_table         STRING                   #No.FUN-780031
DEFINE    g_str           STRING                   #No.FUN-780031
DEFINE    g_sql           STRING                   #No.FUN-780031
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.wc   = ARG_VAL(8)
   LET tm.a    = ARG_VAL(9)   #TQC-610056
   LET tm.t    = ARG_VAL(10)
   LET tm.rate_op  = ARG_VAL(11)   #TQC-610056
   LET yy  = ARG_VAL(12)   #TQC-610056
   LET mm  = ARG_VAL(13)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-780031  --Begin
   LET g_sql = " tah01.tah_file.tah01,",
               " tah08.tah_file.tah08,",
               " tah09.tah_file.tah09,",
               " tah04.tah_file.tah04,",
               " azj07.azj_file.azj07,",
               " amt1.tah_file.tah10,",
               " amt2.tah_file.tah10,",
               " aag02.aag_file.aag02,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07,",
               "g_azi04.azi_file.azi04,",   #FUN-D40020 add
               "g_azi05.azi_file.azi05,"    #FUN-D40020 add
 
   LET l_table = cl_prt_temptable('gglx400',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?                     ) "  #FUN-D40020 add 2 '?'
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
   LET g_trace = 'N'				# default trace off
   IF g_bookno IS NULL  OR g_bookno='' THEN
      LET g_bookno=g_aaz.aaz64
   END IF
   IF tm.a IS NULL OR tm.a = ' ' THEN   #No.FUN-740055 
      LET tm.a = g_aza.aza81  #No.FUN-740055 
   END IF                       #No.FUN-740055 
#   LET tm.a = g_bookno   #No.FUN-740055

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglx400_tm(0,0)		        # Input print condition
      ELSE CALL gglx400()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
 
 
FUNCTION gglx400_tm(p_row,p_col)
 
DEFINE li_chk_bookno  LIKE type_file.num5     #NO FUN-690009   SMALLINT      #No.FUN-670004
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT	
       l_cmd	      LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(tm.a)
 
   OPEN WINDOW gglx400_w WITH FORM "ggl/42f/gglx400"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.a)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  # LET tm.a = g_bookno
   LET tm.a = g_aza.aza81  #No.FUN-740055 
   LET tm.t    = 'Y'      
   LET tm.e    = 'N'  #FUN-6C0012 
   LET tm.h    = 'Y'  #MOD-860252
   LET tm.more = 'N'
   LET tm.rate_op = 'B' 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET yy = YEAR(TODAY)
   LET mm = MONTH(TODAY)
WHILE TRUE
   #No.FUN-B20010  --Beign
   DIALOG ATTRIBUTE(unbuffered)
   INPUT BY NAME tm.a ATTRIBUTE(WITHOUT DEFAULTS) 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)              
 
      AFTER FIELD a
         IF NOT cl_null(tm.a) THEN
	       CALL s_check_bookno(tm.a,g_user,g_plant) 
               RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD a
            END IF
         SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.a
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",tm.a,"","agl-043","","",0)
               NEXT FIELD a 
            END IF
         END IF

   END INPUT
#No.FUN-B20010  --Mark Begin 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglx400_w EXIT PROGRAM
#   END IF
#No.FUN-B20010  --Mark End
   CONSTRUCT BY NAME tm.wc ON tah01,tah08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark Begin
#       ON ACTION CONTROLP                                                     
#            CASE                                                                
#                WHEN INFIELD(tah01)                                             
#                  CALL cl_init_qry_var()                                        
#                  LET g_qryparam.state= "c"                                     
#                  LET g_qryparam.form = "q_aag"   
#                  LET g_qryparam.where = " aag00 = '",tm.a CLIPPED,"'"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
#                  DISPLAY g_qryparam.multiret TO tah01                          
#                  NEXT FIELD tah01                                              
#               OTHERWISE                                                        
#                  EXIT CASE                                                     
#            END CASE
#        #No.FUN-B20010  --End
#         ON ACTION locale
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
   END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030 
 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF

 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglx400_w EXIT PROGRAM
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#No.FUN-B20010  --Mark End
   #DISPLAY BY NAME yy,mm,tm.a,tm.rate_op,tm.t,tm.e,tm.more #ATTRIBUTE(YELLOW)	# Condition  #FUN-6C0012 #TQC-8C0076 #No.FUN-B20010
 
   #INPUT BY NAME yy,mm,tm.a,tm.rate_op,tm.t,tm.e,tm.h,tm.more WITHOUT DEFAULTS  #FUN-6C0012 #No.MOD-860252 add tm.h #B20010 mark
    INPUT BY NAME yy,mm,tm.rate_op,tm.e,tm.h,tm.more ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20010   #No.FUN-D40020   Del tm.t
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---    
 
      AFTER FIELD mm
         IF mm < 0 OR mm > 12 THEN 
            NEXT FIELD mm
         END IF
 
     #No.FUN-D40020 ---start--- Mark
      AFTER FIELD t                                                                                                              
         IF tm.t NOT MATCHES "[YN]" THEN                                                                                         
            NEXT FIELD t                                                                                                         
         END IF  
     #No.FUN-D40020 ---end  --- Mark
 
     #No.FUN-B20010  --Mark Begin
     #AFTER FIELD a
     #   IF NOT cl_null(tm.a) THEN
     #      #No.FUN-670004--begin
	   #   CALL s_check_bookno(tm.a,g_user,g_plant) 
     #         RETURNING li_chk_bookno
     #      IF (NOT li_chk_bookno) THEN
     #         NEXT FIELD a
     #      END IF
     #      #No.FUN-670004--end
     #   SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.a
     #      IF STATUS THEN 
#    #         CALL cl_err(tm.a,'agl-043',0)  # No.FUN-660124
     #         CALL cl_err3("sel","aaa_file",tm.a,"","agl-043","","",0)   # No.FUN-660124
     #         NEXT FIELD a 
     #      END IF
     #   END IF
     #No.FUN-B20010  --Mark End
     
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20010  --Mark Begin        
#      ON ACTION locale
#         LET g_action_choice = "locale"
# 
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG                                                                                                         
#         CALL cl_cmdask()  
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#   
#      ON ACTION controlp                                                        
#        CASE                
#           WHEN INFIELD(a)
#              CALL cl_init_qry_var()                                           
#              LET g_qryparam.form ="q_aaa"                                     
#              LET g_qryparam.default1 = tm.a
#              CALL cl_create_qry() RETURNING tm.a                              
#              DISPLAY BY NAME tm.a
#              NEXT FIELD a                                                     
#           OTHERWISE EXIT CASE                                                 
#         END CASE   
#                     
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End 
   END INPUT
   #No.FUN-B20010  --Bein
       ON ACTION CONTROLP                          
          CASE 
             WHEN INFIELD(tah01)                                    
                CALL cl_init_qry_var()                               
                LET g_qryparam.state= "c"                            
                LET g_qryparam.form = "q_aag"                        
                LET g_qryparam.where = " aag00 = '",tm.a CLIPPED,"'" 
                CALL cl_create_qry() RETURNING g_qryparam.multiret   
                DISPLAY g_qryparam.multiret TO tah01                 
                NEXT FIELD tah01                                      
             WHEN INFIELD(a)                         
                CALL cl_init_qry_var()               
                LET g_qryparam.form ="q_aaa"         
                LET g_qryparam.default1 = tm.a       
                CALL cl_create_qry() RETURNING tm.a  
                DISPLAY BY NAME tm.a                 
                NEXT FIELD a
#FUN-D40020--add--str--
             WHEN INFIELD(tah08)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_tah08"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tah08
                NEXT FIELD tah08
   #FUN-D40020--add--end                         
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
          #No.TQC-B30147 --Begin
          IF cl_null(tm.wc) OR tm.wc = ' 1=1' THEN
             CALL cl_err('','9046',0)
             NEXT FIELD tah01
          END IF
          #No.TQC-B30147 --End
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
       CLOSE WINDOW gglx400_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
    IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF    
   #No.FUN-B20010  --End
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
       WHERE zz01='gglx400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglx400','9031',1)   
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '", tm.a CLIPPED,"'",  #No.FUN-740055 
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",   #TQC-610056
                         " '",tm.t CLIPPED,"'",   #TQC-610056
                         " '",tm.rate_op CLIPPED,"'",   #TQC-610056
                         " '",yy CLIPPED,"'",   #TQC-610056
                         " '",mm CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gglx400',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglx400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglx400()
   ERROR ""
END WHILE
   CLOSE WINDOW gglx400_w
END FUNCTION
 
FUNCTION gglx400()
   DEFINE l_name  LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8      #No.FUN-6A0097
          l_sql   LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr	  LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_date  LIKE cre_file.cre08     #NO FUN-690009   VARCHAR(10)  
   DEFINE l_aag  RECORD LIKE aag_file.*,
          l_tah08       LIKE tah_file.tah08,
          sr     RECORD 
                 tah01  LIKE tah_file.tah01,
                 tah08  LIKE tah_file.tah08,
                 tah09  LIKE tah_file.tah09,
                 tah04  LIKE tah_file.tah04,
                 azj07  LIKE azj_file.azj07,
                 amt1   LIKE tah_file.tah10,
                 amt2   LIKE tah_file.tah10
                 END RECORD
   DEFINE l_aaa03 LIKE aaa_file.aaa03                          #MOD-C40021 add
 
     #No.FUN-780031  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file 
      WHERE aaf01 = tm.a AND aaf02 = g_rlang
 
   # LET l_sql = "SELECT UNIQUE aag_file.*,tah08 ",     #MOD-950238 MARK
    #MOD-990164   ---start    
    #LET l_sql = "SELECT aag_file.*,tah08 ",            #MOD-950238
    #            "  FROM aag_file,tah_file ",
    #            " WHERE ",tm.wc CLIPPED,
    #            "   AND aag01 = tah01",
    #            "   AND aag00 = tah00",                #MOD-950238 ADD
    #            "   AND aag00 ='",tm.a,"' ",  #No.FUN-740055 
     LET l_sql = "SELECT aag_file.* ",                                                                                             
                 "  FROM aag_file ",                                                                                               
                 " WHERE aag00 ='",tm.a,"' ",                                                                                      
     #MOD-990164   ---end                          
                 "   AND aag07 <> '1' AND aagacti = 'Y' " 
               # " ORDER BY aag01 "     #No.MOD-860252 mark
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql , " AND aag09 = 'Y'   "
     END IF
     LET l_sql = l_sql ," ORDER BY aag01   "
     #No.MOD-860252---end---
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE gglx400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM 
     END IF
 
     DECLARE gglx400_curs1 CURSOR FOR gglx400_prepare1
 
     #No.FUN-780031  --Begin
     #CALL cl_outnam('gglx400') RETURNING l_name 
     #START REPORT gglx400_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-780031  --End  
     LET yymm = yy USING "&&&&",mm USING "&&"
    #------------------------MOD-C40021-------------------(S)
     SELECT aaa03 INTO l_aaa03
       FROM aaa_file
      WHERE aaa01 = tm.a
    #------------------------MOD-C40021-------------------(E)
    #MOD-C70285------S------
     LET g_azi04 = 0
     LET g_azi05 = 0
     SELECT azi04,azi05 INTO g_azi04,g_azi05
       FROM azi_file
      WHERE azi01 = l_aaa03
    #MOD-C70285------E------
    #FOREACH gglx400_curs1 INTO l_aag.*,l_tah08 #MOD-990164                                                                         
     FOREACH gglx400_curs1 INTO l_aag.* #MOD-990164      
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
       #MOD-990164   ---start        
       #DECLARE b_curs CURSOR FOR
        #SELECT tah01,tah08,SUM(tah09-tah10),SUM(tah04-tah05) FROM tah_file
        # WHERE tah01 = l_aag.aag01 AND tah02 = yy AND tah03 <= mm
        #   AND tah00 = tm.a
        #   AND tah08 = l_tah08
        #   AND (tah08 <> g_aza.aza17)
        # GROUP BY tah01,tah08
        #HAVING SUM(tah09-tah10) <> 0
         LET l_sql="SELECT tah01,tah08,SUM(tah09-tah10),SUM(tah04-tah05) FROM tah_file ",                                           
                   " WHERE tah01 = '",l_aag.aag01,"' AND tah02 = '",yy,"' AND tah03 <= '",mm,"' ",                                  
                   "   AND tah00 = '",tm.a,"' ",                                                                                    
                  #"   AND (tah08 <> '",g_aza.aza17,"') ",  #MOD-C70285 mark                                                                        
                   "   AND (tah08 <> '",l_aaa03,"') ",      #MOD-C70285
                   "   AND ",tm.wc CLIPPED,                                                                                         
                   " GROUP BY tah01,tah08    ",                                                                                     
                   "HAVING SUM(tah09-tah10) <> 0    "                                                                               
         PREPARE b_prepare FROM l_sql                                                                                               
         DECLARE b_curs CURSOR FOR b_prepare                                                                                        
        #MOD-990164   ---end                    
        FOREACH b_curs INTO sr.tah01,sr.tah08,sr.tah09,sr.tah04
            IF l_aag.aag06 = '2' THEN                #貸餘
               LET sr.tah09 = sr.tah09 * -1
               LET sr.tah04 = sr.tah04 * -1
            END IF
 
            IF mm = '12' THEN                                                  
               LET l_date = MDY(1,1,yy+1) - 1                                  
            ELSE                                                                  
               LET l_date = MDY(mm+1,1,yy) - 1                              
            END IF                                                                
           #CALL s_curr3(sr.tah08,l_date,tm.rate_op) RETURNING sr.azj07    #按參數取得評價匯率  #MOD-C70285 mark     
            CALL s_curr3(l_aaa03,l_date,tm.rate_op) RETURNING sr.azj07     #按參數取得評價匯率  #MOD-C70285
            CALL s_newrate(g_aza.aza81,tm.a,sr.tah08,sr.azj07,l_date) RETURNING sr.azj07        #MOD-C70285 add

            LET sr.amt1  = 0
            LET sr.amt2  = 0
 
            LET sr.amt1 = sr.tah09 * sr.azj07           #本幣評價金額
            IF l_aag.aag06 = '2' THEN 
               LET sr.amt2 = sr.tah04 - sr.amt1
            ELSE
               LET sr.amt2 = sr.amt1 - sr.tah04 
            END IF
            #No.FUN-780031  --Begin
            #OUTPUT TO REPORT gglx400_rep(sr.*)
            IF tm.e = 'Y' THEN                                                        
               LET l_aag.aag02 = l_aag.aag13
            END IF
            LET t_azi04 = 0  #MOD-C70285
            LET t_azi05 = 0  #MOD-C70285
            LET t_azi07 = 0  #MOD-C70285
            SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07
              FROM azi_file 
             WHERE azi01 = sr.tah08                                    #MOD-C40021 mark  #MOD-C70285 remark
            #WHERE azi01 = l_aaa03                                     #MOD-C40021 add   #MOD-C70285 mark 
            LET l_aag.aag02=sr.tah01,"     ",l_aag.aag02   #FUN-D40020 add
            EXECUTE insert_prep USING sr.*,l_aag.aag02,t_azi04,t_azi05,t_azi07
                                     ,g_azi04,g_azi05  #FUN-D40020 add
            #No.FUN-780031  --End  
 
        END FOREACH
     END FOREACH
 
     #No.FUN-780031  --Begin
     #FINISH REPORT gglx400_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'tah01,tah08')
             RETURNING g_str
     END IF
###XtraGrid###     LET g_str = g_str,";",yymm,";",tm.t,";",g_azi04,";",g_azi05
###XtraGrid###     CALL cl_prt_cs3('gglx400','gglx400',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-D40020--add--str--
    LET g_xgrid.headerinfo1=cl_getmsg('agl-272',g_lang),yymm
    LET g_xgrid.condition=g_str
    LET g_xgrid.order_field='aag02'
    LET g_xgrid.grup_field='tah01'
    LET g_xgrid.skippage_field='tah01'
#FUN-D40020--add--end
    CALL cl_xg_view()    ###XtraGrid###
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin---    
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780031  --Begin
#REPORT gglx400_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#          sr    RECORD 
#                tah01  LIKE tah_file.tah01,
#                tah08  LIKE tah_file.tah08,
#                tah09  LIKE tah_file.tah09,
#                tah04  LIKE tah_file.tah04,
#                azj07  LIKE azj_file.azj07,
#                amt1   LIKE tah_file.tah10,
#                amt2   LIKE tah_file.tah10
#                END RECORD,
#          l_aag02   LIKE aag_file.aag02,
#          l_aag13   LIKE aag_file.aag13,   #FUN-6C0012
#          t_azi07   LIKE azi_file.azi07,   #No.CHI-6A0004
#          g_head1   STRING, 
#          l_chr     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
#
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#  ORDER BY sr.tah01,sr.tah08
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total     
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_head1 = g_x[10],yymm
#      PRINT g_head1                                                                                                              
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]                                                                      
#      PRINT g_dash1                                                        
#      LET l_last_sw = 'n' 
#
#      #FUN-6C0012.....begin                                                     
#      IF tm.e = 'Y' THEN                                                        
#         PRINT g_x[9],sr.tah01,'  ',l_aag13  CLIPPED                            
#      ELSE                                                                      
#      #FUN-6C0012.....end                                                       
#         PRINT g_x[9],sr.tah01,'  ',l_aag02  CLIPPED                            
#      END IF   #FUN-6C0012 
#
#   BEFORE GROUP OF sr.tah01
#      IF tm.t='Y' THEN                                                                                                           
#         SKIP TO TOP OF PAGE                                                                                                     
#      END IF      
#      SELECT aag02,aag13 INTO l_aag02,l_aag13 FROM aag_file   #FUN-6C0012
#       WHERE aag01 = sr.tah01
#         AND aag00 = tm.a   #No.FUN-740055 
##      PRINT g_x[9],sr.tah01,'  ',l_aag02  CLIPPED   #FUN-6C0012
#
#   ON EVERY ROW 
#      LET t_azi04 = 0   #No.CHI-6A0004
#      SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file   #No.CHI-6A0004
#       WHERE azi01 = sr.tah08
#
#      PRINT COLUMN g_c[31],sr.tah08 CLIPPED,
#            COLUMN g_c[32],cl_numfor(sr.tah09,32,t_azi04),    #No.CHI-6A0004
#            COLUMN g_c[33],cl_numfor(sr.tah04,33,t_azi04) ,   #No.CHI-6A0004
#            COLUMN g_c[34],cl_numfor(sr.azj07,34,t_azi07),    #No.CHI-6A0004
#            COLUMN g_c[35],cl_numfor(sr.amt1,35,t_azi04) ,    #No.CHI-6A0004
#            COLUMN g_c[36],cl_numfor(sr.amt2,36,t_azi04)      #No.CHI-6A0004
#
#   AFTER GROUP OF sr.tah01
#      PRINT
#      PRINTX name=S1 COLUMN g_c[32],g_x[17] CLIPPED,
#            COLUMN g_c[33],cl_numfor(GROUP SUM(sr.tah04),33,t_azi04),   #No.CHI-6A0004
#            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt1),35,t_azi04),    #No.CHI-6A0004
#            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt2),36,t_azi04)     #No.CHI-6A0004
#      PRINT
#
#   ON LAST ROW
#      PRINT
#      PRINTX name=S2 COLUMN g_c[32],g_x[18] CLIPPED,
#            COLUMN g_c[33],cl_numfor(SUM(sr.tah04),33,t_azi04),      #No.CHI-6A0004
#            COLUMN g_c[35],cl_numfor(SUM(sr.amt1),35,t_azi04),       #No.CHI-6A0004
#            COLUMN g_c[36],cl_numfor(SUM(sr.amt2),36,t_azi04)        #No.CHI-6A0004
#
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'aec01,aec05,aec02,aec051')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#	#TQC-630166
#        #      IF tm.wc[001,070] > ' ' THEN			# for 80
#	#	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #      IF tm.wc[071,140] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #      IF tm.wc[141,210] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #      IF tm.wc[211,280] > ' ' THEN
#	# 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.MOD-580211
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.MOD-580211
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780031  --End  


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
