# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr309.4gl
# Descriptions...: 日記帳列印-套表
# Date & Author..: 03/04/17 By SAM
# Memo...........: Vtcp printing config : 1*23*24 --> 42  lines
#                  立信帳冊名稱...: 無外幣時，TW213 日記帳（明細帳）
#                                   有外幣時，TW211 外幣日記帳（明細帳）
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼 
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/12 By hongmei 會計科目加帳套
# Modify.........: No.TQC-740135 07/04/27 By arman   把"agg"改為"aag"
# Modify.........: No.FUN-850058 08/05/12 By ve007報表輸出方式改為CR  
#                                08/08/18 By Cockroach 5X-->5.1X
# Modify.........: No.MOD-860252 09/02/17 By chenl  增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.TQC-920076 09/02/23 By dxfwo  修改903行的-254錯誤 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位 
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm    RECORD                  # Print condition RECORD
                wc      LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(300)    # Where condition
                yyyy    LIKE type_file.num5,       #NO FUN-690009   SMALLINT     # year
                mm      LIKE type_file.num5,       #NO FUN-690009   SMALLINT     # period
                nn      LIKE type_file.num5,       #NO FUN-690009   SMALLINT     # laster
                bookno  LIKE aaa_file.aaa01,       #No.FUN-740055 
                p       LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)      # 獨立列印否
                bb      LIKE azi_file.azi01,       #NO FUN-690009   VARCHAR(4)      # 幣別
                h       LIKE type_file.chr1,       #MOD-860252
                e       LIKE type_file.chr1,       #FUN-6C0012
                more    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)      # Input more condition(Y/N)
                END RECORD,
     g_abb24    LIKE abb_file.abb24,       #NO FUN-690009   VARCHAR(04)
     g_aag01    LIKE aag_file.aag01,
     g_cn       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
     g_aac13    LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(01)
     g_no       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
     g_record   LIKE type_file.num5,       #NO FUN-690009   SMALLINT
     g_flag     LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table        STRING,                           #No.FUN-850058                                                            
         g_sql          STRING,                           #No.FUN-850058                                                            
         g_str          STRING                            #No.FUN-850058      
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-850058--begin--                                                                                                          
     LET g_sql = "s_date.type_file.dat,",                                                                                           
                 "s_month.type_file.num5,",                                                                                         
                 "s_day.type_file.chr2,",                                                                                           
                 "abb01.abb_file.abb01,",                                                                                           
                 "abb04.abb_file.abb04,",                                                                                           
                 "s_kemu.type_file.chr20,",                                                                                         
                 "abb25.abb_file.abb25,",                                                                                           
                 "abb07.abb_file.abb07,",                                                                                           
                 "abb07f.abb_file.abb07,",                                                                                          
                 "balance.abb_file.abb07,",                                                                                         
                 "balance_f.abb_file.abb07,",                                                                                       
                 "aag01.aag_file.aag01,",                                                                                           
                 "aag02.aag_file.aag02,",                                                                                           
                 "aag13.aag_file.aag13,",                                                                                           
                 "aag06.aag_file.aag06,",                                                                                           
                 "abb06.abb_file.abb06,",                                                                                           
                 "aba00.aba_file.aba00,",                                                                                           
                 "azi04.azi_file.azi04,",                                                                                           
                 "azi05.azi_file.azi05,",                                                                                           
                 "p_balance.abb_file.abb07,",      
                 "p_balance_f.abb_file.abb07,",                                                                                     
                 "p_last_balance.abb_file.abb07,",                                                                                  
                 "p_last_balance_f.abb_file.abb07,",                                                                                
                 "d_debit.abb_file.abb07,",                                                                                         
                 "d_credit.abb_file.abb07,",                                                                                        
                 "d_balance.abb_file.abb07,",                                                                                       
                 "m_debit.abb_file.abb07,",                                                                                         
                 "m_credit.abb_file.abb07,",                                                                                        
                 "m_balance.abb_file.abb07,",                                                                                       
                 "y_debit.abb_file.abb07,",                                                                                         
                 "y_credit.abb_file.abb07,",                                                                                        
                 "y_balance.abb_file.abb07,",                                                                                       
                 "d_debit_f.abb_file.abb07,",                                                                                       
                 "d_credit_f.abb_file.abb07,",                                                                                      
                 "d_balance_f.abb_file.abb07,",                                                                                     
                 "m_debit_f.abb_file.abb07,",                                                                                       
                 "m_credit_f.abb_file.abb07,",                                                                                      
                 "m_balance_f.abb_file.abb07,",                                                                                     
                 "y_debit_f.abb_file.abb07,",                                                                                       
                 "y_credit_f.abb_file.abb07,",                                                                                      
                 "y_balance_f.abb_file.abb07,",                                                                                     
                 "g_pageno.type_file.chr2,",             
                 "l_day.type_file.chr2"                                                                                             
     LET l_table = cl_prt_temptable('gglr309',g_sql) CLIPPED                                                                        
     IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                       
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",                                                                
                 "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                          
                                                                                                                                    
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                           
     END IF                                                                                                                         
   #No.FUN-850058--end--                                
 
   LET g_trace = 'N'                            # default trace off
   LET tm.bookno = ARG_VAL(1)           #No.FUN-740055 
   LET g_pdate  = ARG_VAL(2)            # Get arguments from command line   
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.yyyy  = ARG_VAL(9)
   LET tm.mm    = ARG_VAL(10)
   LET tm.nn    = ARG_VAL(11)
   LET tm.p     = ARG_VAL(12)
   LET tm.bb    = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
#     LET tm.bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別  #No.FUN-740055
      LET tm.bookno = g_aza.aza81   #No.FUN-740055
   END IF
   
   #No.FUN-740055 ---Begin
   IF cl_null(tm.bookno) THEN LET tm.bookno=g_aza.aza81 END IF                                                                      
   #使用預設帳別之幣別                                                                                                              
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno
   #No.FUN-740055 ---End
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL gglr309_tm()                    # Input print condition
      ELSE CALL gglr309()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr309_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01,       #No.FUN-580031
          l_n           LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_cmd         LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
DEFINE li_chk_bookno    LIKE type_file.num5        #FUN-B20010
   CALL s_dsmark(tm.bookno)    #No.FUN-740055
   OPEN WINDOW gglr309_w WITH FORM "ggl/42f/gglr309"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740055
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bookno = g_aza.aza81     #FUN-B20010
   LET tm.p    = 'N'
   LET tm.bb   = ' '
   LET tm.h    = 'Y'  #MOD-860252
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.more = 'N'
   LET tm.mm   = '1'
   SELECT aaa03,aaa04,aaa05 INTO g_aaa03,tm.yyyy,tm.nn
     FROM aaa_file WHERE aaa01 = tm.bookno     #No.FUN-740055
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
  #No.FUN-B20010  --Begin
  DIALOG ATTRIBUTE(unbuffered)
  INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS) 
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 

      AFTER FIELD bookno                                                                                                         
            IF NOT cl_null(tm.bookno) THEN                                                                                          
               CALL r309_bookno(tm.bookno)                                                                                          
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(tm.bookno,g_errno,0)                                                                                  
                  LET tm.bookno = g_aza.aza81                                                                                       
                  DISPLAY BY NAME tm.bookno                                                                                         
                  NEXT FIELD bookno                                                                                                 
               END IF                                                                                                               
            END IF
    END INPUT
    #No.FUN-B20010  --End
    
 CONSTRUCT BY NAME tm.wc ON aag01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark Begin 
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
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
  END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW gglr309_w EXIT PROGRAM
#    END IF
#    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 #INPUT BY NAME tm.yyyy,tm.mm,tm.nn,tm.bookno,tm.p,tm.bb,tm.h,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012  #No.FUN-740055 #No.MOD-860252 add tm.h #FUN-B20010 mark
#No.FUN-B20010  --Mark End
 INPUT BY NAME tm.yyyy,tm.mm,tm.nn,tm.p,tm.bb,tm.h,tm.e,tm.more ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20010 去掉tm.bookno
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
    AFTER FIELD yyyy
      IF cl_null(tm.yyyy) THEN NEXT FIELD yyyy END IF
    AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
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
#      IF cl_null(tm.mm) OR tm.mm <= 0 OR tm.mm >13 THEN
#         NEXT FIELD mm
#      END IF
#No.TQC-720032 -- end --
 
    AFTER FIELD nn
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.nn) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
            IF g_azm.azm02 = 1 THEN
               IF tm.nn > 12 OR tm.nn < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD nn
               END IF
            ELSE
               IF tm.nn > 13 OR tm.nn < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD nn
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
#      IF cl_null(tm.nn) OR tm.nn <= 0 OR tm.nn >13 THEN
#         NEXT FIELD nn
#      END IF
#No.TQC-720032 -- end --
      IF tm.nn < tm.mm THEN NEXT FIELD nn END IF
    
    #No.FUN-B20010  --Mark Begin
    #No.FUN-740055 ---Begin
    #AFTER FIELD bookno                                                                                                         
    #        IF NOT cl_null(tm.bookno) THEN                                                                                          
    #           CALL r309_bookno(tm.bookno)                                                                                          
    #           IF NOT cl_null(g_errno) THEN                                                                                         
    #              CALL cl_err(tm.bookno,g_errno,0)                                                                                  
    #              LET tm.bookno = g_aza.aza81                                                                                       
    #              DISPLAY BY NAME tm.bookno                                                                                         
    #              NEXT FIELD bookno                                                                                                 
    #           END IF                                                                                                               
    #        END IF
    #No.FUN-740055 ---End
    #No.FUN-B20010  --Mark End
    AFTER FIELD p
      IF cl_null(tm.p) OR tm.p NOT MATCHES "[YN]" THEN NEXT FIELD p END IF
      IF tm.p  = 'N' THEN LET tm.bb = NULL DISPLAY BY NAME tm.bb END IF
    BEFORE FIELD bb
      IF tm.p = 'N' THEN
#       IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
      END IF
    AFTER FIELD bb
#     IF cl_null(tm.bb) THEN NEXT FIELD bb END IF                    #FUN-6C0012
      IF cl_null(tm.bb) AND tm.p = 'Y' THEN NEXT FIELD bb END IF     #FUN-6C0012
      IF NOT cl_null(tm.bb) THEN   #FUN-6C0012
         SELECT azi01 FROM azi_file WHERE azi01 = tm.bb AND aziacti = 'Y'
         IF STATUS THEN
#        CALL cl_err(tm.bb,'agl-109',0)   FIELD bb   #No.FUN-660124
            CALL cl_err3("sel","azi_file",tm.bb,"","agl-109","","",0)   #No.FUN-660124
            NEXT FIELD bb 
         END IF
      END IF   #FUN-6C0012
    AFTER FIELD more
      IF tm.more = 'Y'
        THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
        END IF
    
#No.FUN-B20010  --Mark Begin 
#    ON ACTION CONTROLR
#       CALL cl_show_req_fields()
# 
#    ON ACTION CONTROLG
#       CALL cl_cmdask()	# Command execution
# 
#    ON ACTION CONTROLP
#    CASE
#       WHEN INFIELD(bb)
##         CALL q_azi(0,0,tm.bb) RETURNING tm.bb
##         CALL FGL_DIALOG_SETBUFFER( tm.bb )
#          CALL cl_init_qry_var()
#          LET g_qryparam.form = 'q_azi'
#          LET g_qryparam.default1 = tm.bb
#          CALL cl_create_qry() RETURNING tm.bb
##          CALL FGL_DIALOG_SETBUFFER( tm.bb )
#          DISPLAY BY NAME tm.bb
#        #No.FUN-740055 ---Begin
#         WHEN INFIELD(bookno)                                                                                                 
#            CALL cl_init_qry_var()                                                                                            
#            LET g_qryparam.form ="q_aaa"                                                                                      
#            LET g_qryparam.default1 = tm.bookno                                                                               
#             CALL cl_create_qry() RETURNING tm.bookno                                                                          
#            DISPLAY BY NAME tm.bookno                                                                                         
#            NEXT FIELD bookno                                                                                                 
#        #No.FUN-740055 ---End
#
#       OTHERWISE
#    END CASE
#       ON IDLE g_idle_seconds
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
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
 
    END INPUT
    #No.FUN-B20010  --Begin
    ON ACTION CONTROLP
       CASE      
          WHEN INFIELD(bookno)                                                                                                 
             CALL cl_init_qry_var()                                                                                            
             LET g_qryparam.form ="q_aaa"                                                                                      
             LET g_qryparam.default1 = tm.bookno                                                                               
             CALL cl_create_qry() RETURNING tm.bookno                                                                          
             DISPLAY BY NAME tm.bookno                                                                                         
             NEXT FIELD bookno 
          WHEN INFIELD(aag01)                                             
             CALL cl_init_qry_var()                                        
             LET g_qryparam.state= "c"                                     
             LET g_qryparam.form = "q_aag"   
             LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
             CALL cl_create_qry() RETURNING g_qryparam.multiret            
             DISPLAY g_qryparam.multiret TO aag01                          
             NEXT FIELD aag01 
          WHEN INFIELD(bb)
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_azi'
             LET g_qryparam.default1 = tm.bb
             CALL cl_create_qry() RETURNING tm.bb
             DISPLAY BY NAME tm.bb 
           OTHERWISE
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
           NEXT FIELD aag01
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
      CLOSE WINDOW gglr309_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)
    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    #No.FUN-B20010  --End
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='gglr309'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr309','9031',1)   
       ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'",    #No.FUN-740055
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.yyyy  CLIPPED,"'",
                         " '",tm.mm    CLIPPED,"'",
                         " '",tm.nn    CLIPPED,"'",
                         " '",tm.p     CLIPPED,"'",
                         " '",tm.bb    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
          IF g_trace = 'Y' THEN
             ERROR l_cmd
          END IF
          CALL cl_cmdat('gglr309',g_time,l_cmd) # Execute cmd at later time
       END IF
       CLOSE WINDOW gglr309_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr309()
    ERROR ""
  END WHILE
  CLOSE WINDOW gglr309_w
END FUNCTION
 
#No.FUN-740055 ---Begin
FUNCTION r309_bookno(p_bookno)                                                                                                      
  DEFINE p_bookno   LIKE aaa_file.aaa01,                                                                                            
         l_aaaacti  LIKE aaa_file.aaaacti                                                                                           
                                                                                                                                    
    LET g_errno = ' '                                                                                                               
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno                                                                
    CASE                                                                                                                            
        WHEN l_aaaacti = 'N' LET g_errno = '9028'                                                                                   
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926                                                                       
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'                                                                        
        END CASE                                                                                                                    
END FUNCTION
#No.FUN-740055 ---End
 
FUNCTION gglr309_curs()
  DEFINE l_sql   LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(600)
 
     LET l_sql = "SELECT tpg04 FROM tpg_file ",
                 " WHERE tpg01 = ",tm.yyyy,
                 "   AND tpg02 = ? ",
                 "   AND tpg03 = ? ",
                 "   AND tpg05 = 'gglr309'"
     PREPARE prepare_pageno FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_pageno',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_pageno CURSOR FOR prepare_pageno
 
     LET l_sql = "SELECT SUM(tas04),SUM(tas05),SUM(tas09),SUM(tas10)",
                 "  FROM tas_file ",
                 " WHERE tas00 = ? AND tas01 = ? ",
                 "   AND tas02 = ? ",
                 "   AND tas08 = '",g_abb24,"'"
     PREPARE prepare_tas FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tas',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tas CURSOR FOR prepare_tas
 
     LET l_sql = "SELECT SUM(tas04)-SUM(tas05),SUM(tas09)-SUM(tas10)",
                 "  FROM tas_file ",
                 " WHERE tas00 = ? AND tas01 = ? ",
                 "   AND tas02 <= ? ",
                 "   AND tas08 = '",g_abb24,"'",
                 "   AND YEAR(tas02) = ",tm.yyyy,
                 "   AND MONTH(tas02) <= ? ",
                 "   AND tas08 = '",g_abb24,"'"
     PREPARE prepare_tas2 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tas2',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tas2 CURSOR FOR prepare_tas2
 
     LET l_sql = "SELECT SUM(tah04)-SUM(tah05),SUM(tah09)-SUM(tah10) ",
                 "  FROM tah_file ",
                 " WHERE tah00 = ? AND tah01 = ? ",
                 "   AND tah02 = ",tm.yyyy," AND tah03 < ? ",
                 "   AND tah08 = '",g_abb24,"'"
     PREPARE prepare_tah FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tah',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tah CURSOR FOR prepare_tah
 
     LET l_sql = "SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10) ",
                 "  FROM tah_file ",
                 " WHERE tah00 = ? AND tah01 = ? ",
                 "   AND tah02 = ",tm.yyyy," AND tah03 = ? ",
                 "   AND tah08 = '",g_abb24,"'"
     PREPARE prepare_tah2 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tah2',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tah2 CURSOR FOR prepare_tah2
 
     LET l_sql = "SELECT SUM(tah04)-SUM(tah05),SUM(tah09)-SUM(tah10) ",
                 "  FROM tah_file ",
                 " WHERE tah00 = ? AND tah01 = ? ",
                 "   AND tah02 = ",tm.yyyy," AND tah03 <= ? ",
                 "   AND tah08 = '",g_abb24,"'"
     PREPARE prepare_tah3 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tah3',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tah3 CURSOR FOR prepare_tah3
 
     LET l_sql = "SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10) ",
                 "  FROM tah_file ",
                 " WHERE tah00 = ? AND tah01 = ? ",
                 "   AND tah02 = ",tm.yyyy,
                 "   AND tah03 >0 AND tah03 <= ? ",
                 "   AND tah08 = '",g_abb24,"'"
     PREPARE prepare_tah4 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tah4',STATUS,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tah4 CURSOR FOR prepare_tah4
 
     LET l_sql = "SELECT SUM(tah04)-SUM(tah05),SUM(tah09)-SUM(tah10) ",
                 "  FROM tah_file ",
                 " WHERE tah00 = ? AND tah01 = ? ",
                 "   AND tah02 = ",tm.yyyy," AND tah03 <= ? ",
                 "   AND tah08 = '",g_abb24,"'"
     PREPARE prepare_tah5 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_tah5',STATUS,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tah5 CURSOR FOR prepare_tah5
END FUNCTION
 
FUNCTION gglr309()
   DEFINE l_name        LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0097
          l_pageno      LIKE type_file.num5,       #NO FUN-690009   smallint
          l_sql         LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_za05        LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(40)
          b_date        LIKE type_file.dat,        #NO FUN-690009   DATE
          l_aag01       LIKE aag_file.aag01,
          l_aag02       LIKE aag_file.aag02,
          l_aag13       LIKE aag_file.aag13,  #FUN-6C0012
          l_aag06       LIKE aag_file.aag06,
          l_aba00       LIKE aba_file.aba00,
          l_aba01       LIKE aba_file.aba01,
          l_aba02       LIKE aba_file.aba02,
          l_aba04       LIKE aba_file.aba04,
          l_abb03       LIKE abb_file.abb03,
          l_abb04       LIKE abb_file.abb04,
          l_abb06       LIKE abb_file.abb06,
          l_abb07f      LIKE abb_file.abb07f,
          l_abb07       LIKE abb_file.abb07,
          l_abb24       LIKE abb_file.abb24,
          l_abb25       LIKE abb_file.abb25,
          l_azi04       LIKE azi_file.azi04,
          l_azi05       LIKE azi_file.azi05,
          l_cn,l_mm     LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          n_kemu        LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)
          n_abb03       LIKE abb_file.abb03,
          sr            RECORD
                        s_date        LIKE type_file.dat,     #NO FUN-690009   DATE    #日期
#No.FUN-850058           s_month       LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2) #月
                        s_month       LIKE type_file.num5,    #No.FUN-850058    
                        s_day         LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2) #日
                        abb01         LIKE abb_file.abb01,    #憑証號
                        abb04         LIKE abb_file.abb04,    #摘要
                        s_kemu        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)#對方科目
                        abb25         LIKE abb_file.abb25,    #匯率
                        abb07f        LIKE abb_file.abb07f,   #外幣金額
                        abb07         LIKE abb_file.abb07,    #本幣金額
                        s_dc          LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(2)  #借貸
                        balancef      LIKE abb_file.abb07f,   #外幣餘額
                        balance       LIKE abb_file.abb07,    #本幣餘額
                        aag01         LIKE aag_file.aag01,
                        aag02         LIKE aag_file.aag02,
                        aag13         LIKE aag_file.aag13,    #FUN-6C0012
                        aag06         LIKE aag_file.aag06,
                        abb06         LIKE abb_file.abb06,
                        aba00         LIKE aba_file.aba00,
                        azi04         LIKE azi_file.azi04,
                        azi05         LIKE azi_file.azi05
                        END RECORD,
          p_last_balance    LIKE tah_file.tah04,
          p_last_balance_f  LIKE tah_file.tah04
     #No.FUN-850058  --begin--                                                                                                      
     DEFINE l_month,l_day  LIKE type_file.chr2,                                                                                     
            p_balance      LIKE tah_file.tah04,                                                                                     
            q_last_balance LIKE tah_file.tah04,                                                                                     
            p_balance_f    LIKE tah_file.tah04,                                                                                     
            q_last_balance_f LIKE tah_file.tah04,                                                                                   
            d_debit        LIKE abb_file.abb07,                                                                                     
            d_credit       LIKE abb_file.abb07,                                                                                     
            d_balance      LIKE abb_file.abb07,                                                                                     
            ds_balance     LIKE abb_file.abb07,                                                                                     
            d_dc,m_dc      LIKE type_file.chr2,                                                                                     
            m_debit        LIKE abb_file.abb07,                                                                                     
            m_credit       LIKE abb_file.abb07,                                                                                     
            m_balance      LIKE abb_file.abb07,                                                                                     
            y_debit        LIKE abb_file.abb07,                                                                                     
            y_credit       LIKE abb_file.abb07,                                                                                     
            y_balance      LIKE abb_file.abb07,                                                                                     
            d_debit_f      LIKE abb_file.abb07,                                                                                     
            d_credit_f     LIKE abb_file.abb07,                                                                                     
            d_balance_f    LIKE abb_file.abb07,                                                                                     
            ds_balance_f   LIKE abb_file.abb07,    
            m_debit_f      LIKE abb_file.abb07,                                                                                     
            m_credit_f    LIKE abb_file.abb07,                                                                                      
            m_balance_f    LIKE abb_file.abb07,                                                                                     
            y_debit_f      LIKE abb_file.abb07,                                                                                     
            y_credit_f     LIKE abb_file.abb07,                                                                                     
            y_balance_f    LIKE abb_file.abb07,                                                                                     
            y_dc,q_dc      LIKE zaa_file.zaa08,                                                                                     
            l_cnt          LIKE type_file.num5                                                                                      
     #No.FUN-850058  --end--                        
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time                           #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     CALL cl_del_data(l_table)                         #No.FUN-850058                                                               
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-850058  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr309'
       IF g_len = 0 OR g_len IS NULL THEN LET g_len = 130 END IF
     #使用預設帳別之幣別
     IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
      WHERE azi01 = g_aaa03
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     #取出會計科目
     LET l_sql = "SELECT aag01,aag02,aag13,aag06 FROM aag_file ", #FUN-6C0012
                 " WHERE aag03 = '2' ",
                 "   AND (aag07 = '2' OR aag07 ='3' ) ",
                 "   AND aagacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED,
#                 "   AND agg00 = '",tm.bookno,"'"    #No.FUN-740055 #NO.TQC-740135
                  "   AND aag00 = '",tm.bookno,"'"    #No.TQC-740135
 
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql , " AND aag09 = 'Y' "  
     END IF 
     #No.MOD-860252---end---
     PREPARE prepare_aag FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_aag',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_aag CURSOR FOR prepare_aag
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
 
     LET g_pageno = 0
#     CALL cl_outnam('gglr309') RETURNING l_name           #No.FUN-850058  
     IF tm.p = 'N' THEN
        LET g_aac13 = 'N'
        LET g_abb24 = g_aaa03
#        START REPORT gglr309_rep TO l_name                #No.FUN-850058  
     ELSE
        LET g_aac13 = 'Y'
        LET g_abb24 = tm.bb
#        START REPORT gglr309_rep_f TO l_name              #No.FUN-850058  
     END IF
 
     #NO:7911
     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
      WHERE azi01 = g_abb24
     #NO:7911 end
     LET l_sql = "SELECT aba00,aba01,aba02,aba04,abb03,abb04,abb06, ",
                 "       abb07f,abb07,abb24,abb25,azi04,azi05 ",
                 "  FROM aba_file,abb_file,OUTER azi_file ",
                 " WHERE aba00=abb00 ",
                 "   AND aba01=abb01 ",
                 "   AND aba00 = '",tm.bookno,"'",      #No.FUN-740055
                 "   AND aba03 = ",tm.yyyy,
                 "   AND aba04 = ? ",
                 "   AND abb03 = ? ",
                 "   AND abapost = 'Y' ",
                 "   AND abb24 = '",g_abb24,"'",
                 "   AND azi_file.azi01 = abb_file.abb24 "
     PREPARE prepare_aba FROM l_sql
     IF STATUS THEN
#       CALL cl_err('prepare_aba',STATUS,0)    #No.FUN-660124
        CALL cl_err3("sel","t_azi04,t_azi05","","",STATUS,"","",0)   #No.FUN-660124   #No.CHI-6A0004
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_aba CURSOR FOR prepare_aba
 
     #DECLARE CURSOR
     CALL gglr309_curs()
 
     LET g_record = 0            ##記錄筆數
     FOREACH curs_aag INTO l_aag01,l_aag02,l_aag13,l_aag06  #FUN-6C0012
       INITIALIZE sr.* TO NULL
       LET sr.aag01 = l_aag01
       LET sr.aag02 = l_aag02
       LET sr.aag13 = l_aag13  #FUN-6C0012
       LET sr.aag06 = l_aag06
       LET g_flag = ''
       FOR g_no = tm.mm TO tm.nn
           OPEN curs_aba USING g_no,sr.aag01
           FETCH curs_aba
           IF STATUS = 100 THEN
              OPEN curs_tah USING tm.bookno,sr.aag01,g_no        #No.FUN-740055
              FETCH curs_tah INTO p_last_balance,p_last_balance_f
              IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF
              IF cl_null(p_last_balance_f) THEN LET p_last_balance_f=0 END IF
              IF (tm.p = 'N' AND p_last_balance != 0) OR
                 (tm.p = 'Y' AND p_last_balance_f != 0) THEN
                 LET sr.s_month = g_no
                 LET sr.abb25   = 0
                 LET sr.abb07f  = 0
                 LET sr.abb07   = 0
                 LET sr.azi04   = 0
                 LET sr.azi05   = 0
                 LET sr.balancef= 0
                 LET sr.balance = 0
                 LET sr.aba00   = tm.bookno      #No.FUN-740055
                 LET l_mm = tm.mm - 1
                 OPEN curs_pageno USING l_mm,sr.aag01
                 FETCH curs_pageno INTO g_pageno
                 IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
                 LET g_cn = 0
                 IF tm.p = 'N' THEN
#                    OUTPUT TO REPORT gglr309_rep(sr.*)              #No.FUN-850058  
                    #No.FUN-850058 --add begin--                                                                                        
                    LET g_cn = g_cn + 1                                                                                             
                    LET g_pageno = g_pageno + 1                                                                                     
                    LET g_aag01 = sr.aag01                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET l_mm = l_month - 1                                                                                          
                    OPEN curs_pageno USING l_mm,g_aag01                                                                             
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF STATUS = 100 THEN LET g_pageno = 0 END IF                                                                    
                    IF g_cn = 1 THEN                                                                                                
                       LET g_pageno = g_pageno + 1                                                                                  
                    END IF                                                                                                          
                    OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month                                                                
                    FETCH curs_tah INTO p_last_balance                                                                              
                    IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF                                                   
                    LET p_balance = p_last_balance                                                                                  
                     IF sr.abb06 ='1' THEN                            #借方                                                         
                        IF sr.aag06 = '1' THEN                                                                                      
                           LET p_balance = p_balance + sr.abb07                                                                     
                        ELSE                                                                                                        
                           LET p_balance = p_balance - sr.abb07                                                                     
                        END IF           
                     ELSE                                                                                                           
                          IF sr.aag06 = '1' THEN                                                                                    
                           LET p_balance = p_balance - sr.abb07                                                                     
                        ELSE                                                                                                        
                           LET p_balance = p_balance + sr.abb07                                                                     
                        END IF                                                                                                      
                    END IF                                                                                                          
                    OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date                                                                 
                    FETCH curs_tas INTO d_debit,d_credit                                                                            
                    IF cl_null(d_debit) THEN LET d_debit = 0 END IF                                                                 
                    IF cl_null(d_credit) THEN LET d_credit = 0 END IF                                                               
                    OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month                                                     
                    FETCH curs_tas2 INTO d_balance                                                                                  
                    IF cl_null(d_balance) THEN LET d_balance = 0 END IF                                                             
                    LET l_day = cl_days(tm.yyyy,sr.s_month)                                                                         
                    LET l_day = l_day[1,2]                                                                                          
                    SELECT COUNT(*) INTO l_cnt FROM tpg_file                                                                        
                     WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01                                                    
                       AND tpg05='gglr309'                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET g_aag01 = sr.aag01                                                                                          
                    IF l_cnt = 0 THEN                                                                                               
                      INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)   
                                    VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr309')                                              
                    ELSE                                                                                                            
                      UPDATE tpg_file SET tpg04 = g_pageno                                                                          
                       WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01                                                      
                         AND tpg05='gglr309'                                                                                        
                    END IF                                                                                                          
                    OPEN curs_pageno USING l_month,g_aag01                                                                          
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF                                                               
                    OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah2 INTO m_debit,m_credit                                                                           
                    IF cl_null(m_debit) THEN LET m_debit = 0 END IF                                                                 
                    IF cl_null(m_credit) THEN LET m_credit = 0 END IF                                                               
                    OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah3 INTO m_balance                                                                                  
                    IF cl_null(m_balance) THEN LET m_balance = 0 END IF                                                             
                    OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah4 INTO y_debit,y_credit                                                                           
                   IF cl_null(y_debit) THEN LET y_debit = 0 END IF                                                                  
                   IF cl_null(y_credit) THEN LET y_credit = 0 END IF                                                                
                   OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month                                                                
                   FETCH curs_tah5 INTO y_balance                                 
                   IF cl_null(y_balance) THEN LET y_balance = 0 END IF                                                              
                   LET sr.s_month = sr.s_month USING '##'                                                                           
                   EXECUTE insert_prep USING sr.s_date,sr.s_month,sr.s_day,sr.abb01,sr.abb04,                                       
                                              sr.s_kemu,sr.abb25,sr.abb07,'',sr.balance,'',sr.aag01,                                
                                              sr.aag02,sr.aag13,sr.aag06,sr.abb06,sr.aba00,                                         
                                              sr.azi04,sr.azi05,p_balance,'',p_last_balance,'',                                     
                                              d_debit,d_credit,d_balance,m_debit,m_credit,m_balance,                                
                                              y_debit,y_credit,y_balance,'','','','','','','','','',                                
                                              g_pageno,l_day                                                                        
                   #No.FUN-850058 --add end--                                                                            
                 ELSE
#                    OUTPUT TO REPORT gglr309_rep_f(sr.*)   #No.FUN-850058 
                        #No.FUN-850058 --begin--                                                                                    
                    LET g_cn = g_cn + 1                                                                                             
                    LET g_pageno = g_pageno + 1                                                                                     
                    LET g_aag01 = sr.aag01                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET l_mm = l_month - 1                                                                                          
                    OPEN curs_pageno USING l_mm,g_aag01                                                                             
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF STATUS = 100 THEN LET g_pageno = 0 END IF                                                                    
                    IF g_cn = 1 THEN                                                                                                
                       LET g_pageno = g_pageno + 1                                                                                  
                    END IF                                                                                                          
                    OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month                                                                
                    FETCH curs_tah INTO p_last_balance,p_last_balance_f                                                             
                    IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF                                                   
                    IF cl_null(p_last_balance_f) THEN LET p_last_balance_f = 0 END IF                                               
                    LET p_balance = p_last_balance                                                                                  
                    LET p_balance_f = p_last_balance_f                                                                              
                     IF sr.abb06 ='1' THEN                            #借方    
                        IF sr.aag06 = '1' THEN                                                                                      
                           LET p_balance = p_balance + sr.abb07                                                                     
                           LET p_balance_f = p_balance_f + sr.abb07                                                                 
                        ELSE                                                                                                        
                           LET p_balance = p_balance - sr.abb07                                                                     
                           LET p_balance_f = p_balance_f - sr.abb07                                                                 
                        END IF                                                                                                      
                     ELSE                                                                                                           
                          IF sr.aag06 = '1' THEN                                                                                    
                           LET p_balance = p_balance - sr.abb07                                                                     
                           LET p_balance_f = p_balance_f - sr.abb07                                                                 
                        ELSE                                                                                                        
                           LET p_balance = p_balance + sr.abb07                                                                     
                           LET p_balance_f = p_balance_f + sr.abb07                                                                 
                        END IF                                                                                                      
                    END IF                                                                                                          
                    OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date                                                                 
                    FETCH curs_tas INTO d_debit,d_credit,d_debit_f,d_credit_f                                                       
                    IF cl_null(d_debit) THEN LET d_debit = 0 END IF                                                                 
                    IF cl_null(d_credit) THEN LET d_credit = 0 END IF                                                               
                    IF cl_null(d_debit_f) THEN LET d_debit_f = 0 END IF     
                    IF cl_null(d_credit_f) THEN LET d_credit_f = 0 END IF                                                           
                    OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month                                                     
                    FETCH curs_tas2 INTO d_balance,d_balance_f                                                                      
                    IF cl_null(d_balance) THEN LET d_balance = 0 END IF                                                             
                    LET l_day = cl_days(tm.yyyy,sr.s_month)                                                                         
                    LET l_day = l_day[1,2]                                                                                          
                    SELECT COUNT(*) INTO l_cnt FROM tpg_file                                                                        
                     WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01                                                    
                       AND tpg05='gglr309'                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET g_aag01 = sr.aag01                                                                                          
                    IF l_cnt = 0 THEN                                                                                               
                      INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)                                                           
                                    VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr309')                                              
                    ELSE                                                                                                            
                      UPDATE tpg_file SET tpg04 = g_pageno                                                                          
                       WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01                                                      
                         AND tpg05='gglr309'                                                                                        
                    END IF                                                                                                          
                    OPEN curs_pageno USING l_month,g_aag01                                                                          
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF                                                               
                    OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month      
                    FETCH curs_tah2 INTO m_debit,m_credit,m_debit_f,m_credit_f                                                      
                    IF cl_null(m_debit) THEN LET m_debit = 0 END IF                                                                 
                    IF cl_null(m_credit) THEN LET m_credit = 0 END IF                                                               
                    IF cl_null(m_debit_f) THEN LET m_debit_f = 0 END IF                                                             
                    IF cl_null(m_credit_f) THEN LET m_credit_f = 0 END IF                                                           
                    OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah3 INTO m_balance,m_balance_f                                                                      
                    IF cl_null(m_balance) THEN LET m_balance = 0 END IF                                                             
                    IF cl_null(m_balance_f) THEN LET m_balance_f = 0 END IF                                                         
                    OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah4 INTO y_debit,y_credit,y_debit_f,y_credit_f                                                      
                    IF cl_null(y_debit) THEN LET y_debit = 0 END IF                                                                 
                    IF cl_null(y_credit) THEN LET y_credit = 0 END IF                                                               
                    IF cl_null(y_debit_f) THEN LET y_debit_f = 0 END IF                                                             
                    IF cl_null(y_credit_f) THEN LET y_credit_f = 0 END IF                                                           
                    OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah5 INTO y_balance,y_balance_f                                                                      
                    IF cl_null(y_balance) THEN LET y_balance = 0 END IF                                                             
                    IF cl_null(y_balance_f) THEN LET y_balance_f = 0 END IF                                                         
                    LET sr.s_month = sr.s_month USING '##'                                                                          
                    EXECUTE insert_prep USING sr.s_date,sr.s_month,sr.s_day,sr.abb01,sr.abb04,
                                              sr.s_kemu,sr.abb25,sr.abb07,sr.abb07f,sr.balance,sr.balancef,sr.aag01,                
                                              sr.aag02,sr.aag13,sr.aag06,sr.abb06,sr.aba00,                                         
                                             sr.azi04,sr.azi05,p_balance,p_balance_f,p_last_balance,p_last_balance_f,               
                                             d_debit,d_credit,d_balance,m_debit,m_credit,m_balance,                                 
                                             y_debit,y_credit,y_balance,d_debit_f,d_credit_f,                                       
                                             d_balance_f,m_debit_f,m_credit_f,m_balance_f,                                          
                                             y_debit_f,y_credit_f,y_balance_f,g_pageno,l_day                                        
                   #No.FUN-850058 --add end--                                                 
                 END IF
              END IF
           ELSE
#             OPEN curs_aba USING g_no,sr.aag01   #TQC-920076
#             FOREACH curs_aba INTO l_aba00,l_aba01,l_aba02,l_aba04,
              FOREACH curs_aba USING g_no,sr.aag01 INTO l_aba00,l_aba01,l_aba02,l_aba04,
                                    l_abb03,l_abb04,l_abb06,l_abb07f,
                                    l_abb07,l_abb24,l_abb25,l_azi04,l_azi05 
                 IF STATUS THEN
                    CALL cl_err('curs_aba',STATUS,0) EXIT FOREACH
                 END IF
                 LET sr.s_date = l_aba02      #憑証日期
                 LET sr.s_month = l_aba04     #月
                 LET sr.s_day = DAY(l_aba02)  #日
                 IF LENGTH(sr.s_day)=1 THEN
                    LET sr.s_day = '0',sr.s_day
                 END IF
                 LET sr.abb01 = l_aba01       #憑証號
                 LET sr.abb04 = l_abb04       #摘要
                 LET n_kemu = ' '
                 LET l_sql = "SELECT abb03 FROM abb_file ",
                             " WHERE abb00 = '",l_aba00,"'",
                             "   AND abb01 = '",l_aba01,"'",
                             "   AND abb06 <> '",l_abb06,"'"
                 PREPARE prepare_abb FROM l_sql
                 IF STATUS THEN
                    CALL cl_err('prepare_abb',STATUS,0)
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE curs_abb CURSOR FOR prepare_abb
                 FOREACH curs_abb INTO n_abb03
                    LET n_kemu = n_kemu CLIPPED ,'/',n_abb03 CLIPPED
                 END FOREACH
                 LET sr.s_kemu  = n_kemu        #對方科目
                 LET sr.abb25   = l_abb25       #匯率
                 LET sr.abb07f  = l_abb07f      #外幣金額
                 LET sr.abb07   = l_abb07       #本幣金額
                 LET sr.abb06   = l_abb06       #借貸
                 LET sr.s_dc    = ' '
                 LET sr.balancef= ' '
                 LET sr.balance = ' '
                 LET sr.aba00   = l_aba00
                 LET sr.azi04   = l_azi04
                 LET sr.azi05   = l_azi05
                 LET l_mm = tm.mm - 1
                 OPEN curs_pageno USING l_mm,sr.aag01
                 FETCH curs_pageno INTO g_pageno
                 IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
                 LET g_cn = 0
                 IF tm.p = 'N' THEN
#                    OUTPUT TO REPORT gglr309_rep(sr.*)          #No.FUN-850058 --mark-- 
                     #No.FUN-850058 --begin--                                                                                       
                    LET g_cn = g_cn + 1                                                                                             
                    LET g_pageno = g_pageno + 1                                                                                     
                    LET g_aag01 = sr.aag01                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET l_mm = l_month - 1                                                                                          
                    OPEN curs_pageno USING l_mm,g_aag01                                                                             
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF STATUS = 100 THEN LET g_pageno = 0 END IF                                                                    
                    IF g_cn = 1 THEN                                                                                                
                       LET g_pageno = g_pageno + 1                                                                                  
                    END IF                                                                                                          
                    OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month                                                                
                    FETCH curs_tah INTO p_last_balance                                                                              
                    IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF                                                   
                    LET p_balance = p_last_balance                                                                                  
                     IF sr.abb06 ='1' THEN                            #借方                                                         
                        IF sr.aag06 = '1' THEN                                   
                           LET p_balance = p_balance + sr.abb07                                                                     
                        ELSE                                                                                                        
                           LET p_balance = p_balance - sr.abb07                                                                     
                        END IF                                                                                                      
                     ELSE                                                                                                           
                          IF sr.aag06 = '1' THEN                                                                                    
                           LET p_balance = p_balance - sr.abb07                                                                     
                        ELSE                                                                                                        
                           LET p_balance = p_balance + sr.abb07                                                                     
                        END IF                                                                                                      
                    END IF                                                                                                          
                    OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date                                                                 
                    FETCH curs_tas INTO d_debit,d_credit                                                                            
                    IF cl_null(d_debit) THEN LET d_debit = 0 END IF                                                                 
                    IF cl_null(d_credit) THEN LET d_credit = 0 END IF                                                               
                    OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month                                                     
                    FETCH curs_tas2 INTO d_balance                                                                                  
                    IF cl_null(d_balance) THEN LET d_balance = 0 END IF                                                             
                    LET l_day = cl_days(tm.yyyy,sr.s_month)                                                                         
                    LET l_day = l_day[1,2]                                                                                          
                    SELECT COUNT(*) INTO l_cnt FROM tpg_file                                                                        
                     WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01   
                       AND tpg05='gglr309'                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET g_aag01 = sr.aag01                                                                                          
                    IF l_cnt = 0 THEN                                                                                               
                      INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)                                                           
                                    VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr309')                                              
                    ELSE                                                                                                            
                      UPDATE tpg_file SET tpg04 = g_pageno                                                                          
                       WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01                                                      
                         AND tpg05='gglr309'                                                                                        
                    END IF                                                                                                          
                    OPEN curs_pageno USING l_month,g_aag01                                                                          
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF                                                               
                    OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah2 INTO m_debit,m_credit                                                                           
                    IF cl_null(m_debit) THEN LET m_debit = 0 END IF                                                                 
                    IF cl_null(m_credit) THEN LET m_credit = 0 END IF                                                               
                    OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah3 INTO m_balance                                                                                  
                    IF cl_null(m_balance) THEN LET m_balance = 0 END IF                                                             
                    OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah4 INTO y_debit,y_credit                    
                   IF cl_null(y_debit) THEN LET y_debit = 0 END IF                                                                  
                   IF cl_null(y_credit) THEN LET y_credit = 0 END IF                                                                
                   OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month                                                                
                   FETCH curs_tah5 INTO y_balance                                                                                   
                   IF cl_null(y_balance) THEN LET y_balance = 0 END IF                                                              
                   LET sr.s_month = sr.s_month USING '##'                                                                           
                   EXECUTE insert_prep USING sr.s_date,sr.s_month,sr.s_day,sr.abb01,sr.abb04,                                       
                                              sr.s_kemu,sr.abb25,sr.abb07,'',sr.balance,'',sr.aag01,                                
                                              sr.aag02,sr.aag13,sr.aag06,sr.abb06,sr.aba00,                                         
                                              sr.azi04,sr.azi05,p_balance,'',p_last_balance,'',                                     
                                              d_debit,d_credit,d_balance,m_debit,m_credit,m_balance,                                
                                              y_debit,y_credit,y_balance,'','','','','','','','','',                                
                                              g_pageno,l_day                                                                        
                   #No.FUN-850058 --end--                                            
 
                 ELSE
#                    OUTPUT TO REPORT gglr309_rep_f(sr.*)        #No.FUN-850058 --mark-- 
                                #No.FUN-850058 --begin--                                                                            
                    LET g_cn = g_cn + 1                                                                                             
                    LET g_pageno = g_pageno + 1                                                                                     
                    LET g_aag01 = sr.aag01                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET l_mm = l_month - 1                                                                                          
                    OPEN curs_pageno USING l_mm,g_aag01                                                                             
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF STATUS = 100 THEN LET g_pageno = 0 END IF                                                                    
                    IF g_cn = 1 THEN                                                                                                
                       LET g_pageno = g_pageno + 1                                                                                  
                    END IF                                                                                                          
                    OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month                                                                
                    FETCH curs_tah INTO p_last_balance,p_last_balance_f                                                             
                    IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF                                                   
                    IF cl_null(p_last_balance_f) THEN LET p_last_balance_f = 0 END IF                                               
                    LET p_balance = p_last_balance                                                                                  
                    LET p_balance_f = p_last_balance_f                                                                              
                     IF sr.abb06 ='1' THEN                            #借方                                                         
                        IF sr.aag06 = '1' THEN                                                                                      
                           LET p_balance = p_balance + sr.abb07                                                                     
                           LET p_balance_f = p_balance_f + sr.abb07           
                        ELSE                                                                                                        
                           LET p_balance = p_balance - sr.abb07                                                                     
                           LET p_balance_f = p_balance_f - sr.abb07                                                                 
                        END IF                                                                                                      
                     ELSE                                                                                                           
                          IF sr.aag06 = '1' THEN                                                                                    
                           LET p_balance = p_balance - sr.abb07                                                                     
                           LET p_balance_f = p_balance_f - sr.abb07                                                                 
                        ELSE                                                                                                        
                           LET p_balance = p_balance + sr.abb07                                                                     
                           LET p_balance_f = p_balance_f + sr.abb07                                                                 
                        END IF                                                                                                      
                    END IF                                                                                                          
                    OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date                                                                 
                    FETCH curs_tas INTO d_debit,d_credit,d_debit_f,d_credit_f                                                       
                    IF cl_null(d_debit) THEN LET d_debit = 0 END IF                                                                 
                    IF cl_null(d_credit) THEN LET d_credit = 0 END IF                                                               
                    IF cl_null(d_debit_f) THEN LET d_debit_f = 0 END IF                                                             
                    IF cl_null(d_credit_f) THEN LET d_credit_f = 0 END IF                                                           
                    OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month                                                     
                    FETCH curs_tas2 INTO d_balance,d_balance_f                                                                      
                    IF cl_null(d_balance) THEN LET d_balance = 0 END IF                                                             
                    LET l_day = cl_days(tm.yyyy,sr.s_month)            
                    LET l_day = l_day[1,2]                                                                                          
                    SELECT COUNT(*) INTO l_cnt FROM tpg_file                                                                        
                     WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01                                                    
                       AND tpg05='gglr309'                                                                                          
                    LET l_month = sr.s_month                                                                                        
                    LET g_aag01 = sr.aag01                                                                                          
                    IF l_cnt = 0 THEN                                                                                               
                      INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)                                                           
                                    VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr309')                                              
                    ELSE                                                                                                            
                      UPDATE tpg_file SET tpg04 = g_pageno                                                                          
                       WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01                                                      
                         AND tpg05='gglr309'                                                                                        
                    END IF                                                                                                          
                    OPEN curs_pageno USING l_month,g_aag01                                                                          
                    FETCH curs_pageno INTO g_pageno                                                                                 
                    IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF                                                               
                    OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah2 INTO m_debit,m_credit,m_debit_f,m_credit_f                                                      
                    IF cl_null(m_debit) THEN LET m_debit = 0 END IF                                                                 
                    IF cl_null(m_credit) THEN LET m_credit = 0 END IF                                                               
                    IF cl_null(m_debit_f) THEN LET m_debit_f = 0 END IF                                                             
                    IF cl_null(m_credit_f) THEN LET m_credit_f = 0 END IF          
                    OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah3 INTO m_balance,m_balance_f                                                                      
                    IF cl_null(m_balance) THEN LET m_balance = 0 END IF                                                             
                    IF cl_null(m_balance_f) THEN LET m_balance_f = 0 END IF                                                         
                    OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah4 INTO y_debit,y_credit,y_debit_f,y_credit_f                                                      
                    IF cl_null(y_debit) THEN LET y_debit = 0 END IF                                                                 
                    IF cl_null(y_credit) THEN LET y_credit = 0 END IF                                                               
                    IF cl_null(y_debit_f) THEN LET y_debit_f = 0 END IF                                                             
                    IF cl_null(y_credit_f) THEN LET y_credit_f = 0 END IF                                                           
                    OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month                                                               
                    FETCH curs_tah5 INTO y_balance,y_balance_f                                                                      
                    IF cl_null(y_balance) THEN LET y_balance = 0 END IF                                                             
                    IF cl_null(y_balance_f) THEN LET y_balance_f = 0 END IF                                                         
                    LET sr.s_month = sr.s_month USING '##'                                                                          
                    EXECUTE insert_prep USING sr.s_date,sr.s_month,sr.s_day,sr.abb01,sr.abb04,                                      
                                              sr.s_kemu,sr.abb25,sr.abb07,sr.abb07f,sr.balance,sr.balancef,sr.aag01,                
                                              sr.aag02,sr.aag13,sr.aag06,sr.abb06,sr.aba00,                                         
                                             sr.azi04,sr.azi05,p_balance,p_balance_f,p_last_balance,p_last_balance_f,               
                                             d_debit,d_credit,d_balance,m_debit,m_credit,m_balance,                                 
                                             y_debit,y_credit,y_balance,d_debit_f,d_credit_f,                                       
                                             d_balance_f,m_debit_f,m_credit_f,m_balance_f,                                          
                                             y_debit_f,y_credit_f,y_balance_f,g_pageno,l_day                                        
                   #No.FUN-850058 --end--                         
                 END IF
                 LET g_record = g_record + 1
              END FOREACH
           END IF
       END FOR
     END FOREACH
 
     IF tm.p = 'N' THEN
#        FINISH REPORT gglr309_rep                       #No.FUN-850058 --mark-- 
        #No.FUN-850058 --begin--                                                                                                    
        IF g_zz05 = 'Y' THEN                                                                                                        
           CALL cl_wcchp(tm.wc,'aag01')                                                                                             
              RETURNING tm.wc                                                                                                       
        END IF                                                                                                                      
        LET g_str=tm.wc ,";",tm.yyyy,";",tm.e,";",t_azi04,";",t_azi05                                                               
        LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                          
        CALL cl_prt_cs3('gglr309','gglr309',l_sql,g_str)                                                                            
      #No.FUN-850058  -END--     
     ELSE
#        FINISH REPORT gglr309_rep_f                     #No.FUN-850058 --mark-- 
 
         #No.FUN-850058 --begin--                                                                                                   
        IF g_zz05 = 'Y' THEN                                                                                                        
           CALL cl_wcchp(tm.wc,'aag01')                                                                                             
              RETURNING tm.wc                                                                                                       
        END IF                                                                                                                      
        LET g_str=tm.wc ,";",tm.yyyy,";",tm.e,";",t_azi04,";",t_azi05                                                               
        LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                          
        CALL cl_prt_cs3('gglr309','gglr309_1',l_sql,g_str)                                                                          
      #No.FUN-850058  -END--                                     
     END IF
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)        #No.FUN-850058 --mark--  
      #No.FUN-B80096--mark--Begin---   
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
      #No.FUN-B80096--mark--End-----
END FUNCTION
#No.FUN-850058 --mark--  
##無外幣
#REPORT gglr309_rep(sr)
# DEFINE  sr            RECORD
#                       s_date        LIKE type_file.dat,     #NO FUN-690009   DATE       #日期
#                       s_month       LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)    #月
#                       s_day         LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)    #日
#                       abb01         LIKE abb_file.abb01,    #憑証號
#                       abb04         LIKE abb_file.abb04,    #摘要
#                       s_kemu        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   #對方科目
#                       abb25         LIKE abb_file.abb25,    #匯率
#                       abb07f        LIKE abb_file.abb07f,   #外幣金額
#                       abb07         LIKE abb_file.abb07,    #本幣金額
#                       s_dc          LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(2)    #借貸
#                       balancef      LIKE abb_file.abb07f,   #外幣餘額
#                       balance       LIKE abb_file.abb07,    #本幣餘額
#                       aag01         LIKE aag_file.aag01,
#                       aag02         LIKE aag_file.aag02,
#                       aag13         LIKE aag_file.aag13,    #FUN-6C0012
#                       aag06         LIKE aag_file.aag06,
#                       abb06         LIKE abb_file.abb06,
#                       aba00         LIKE aba_file.aba00,
#                       azi04         LIKE azi_file.azi04,
#                       azi05         LIKE azi_file.azi05
#                       END RECORD
# DEFINE l_month,l_day  LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)
#        p_balance      LIKE tah_file.tah04,
#        p_last_balance LIKE tah_file.tah04,
#        q_last_balance LIKE tah_file.tah04,
#        d_debit        LIKE abb_file.abb07,
#        d_credit       LIKE abb_file.abb07,
#        d_balance      LIKE abb_file.abb07,
#        ds_balance     LIKE abb_file.abb07,
#        d_dc,m_dc      LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)
#        m_debit        LIKE abb_file.abb07,
#        m_credit       LIKE abb_file.abb07,
#        m_balance      LIKE abb_file.abb07,
#        y_debit        LIKE abb_file.abb07,
#        y_credit       LIKE abb_file.abb07,
#        y_balance      LIKE abb_file.abb07,
#        y_dc,q_dc      LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)
#        l_pageno,l_cnt LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#        l_mm           LIKE type_file.num5     #NO FUN-690009   SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.aag01,sr.s_month,sr.s_day,sr.abb01
 
# FORMAT
#   PAGE HEADER
#     SKIP 2 LINE
#     PRINT COLUMN 60,g_x[1] CLIPPED           #LINE 3
#     LET g_cn = g_cn + 1
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN 01,sr.aag01,                #科目編號
#           COLUMN 55,tm.yyyy USING '###&'     #LINE NO 4
#     #FUN-6C0012.....begin
#     IF tm.e = 'Y' THEN
#        PRINT COLUMN 01,sr.aag13;
#     ELSE
#     #FUN-6C0012.....end
#        PRINT COLUMN 01,sr.aag02;                #LINE NO 5
#     END IF  #FUN-6C0012
#     PRINT COLUMN 123,g_pageno USING '<<<'
#     SKIP 2 LINES
 
#   BEFORE GROUP OF sr.aag01
#     LET g_aag01 = sr.aag01
#     LET l_month = sr.s_month
#     LET l_mm = l_month - 1
#     OPEN curs_pageno USING l_mm,g_aag01
#     FETCH curs_pageno INTO g_pageno
#     IF STATUS = 100 THEN LET g_pageno = 0 END IF
#     IF g_cn = 1 THEN
#        LET g_pageno = g_pageno + 1
#     END IF
#     SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF sr.s_month
#       SKIP TO TOP OF PAGE
#       ##上期結轉
#       OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah INTO p_last_balance
#       IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF
#       IF sr.aag06 ='2' THEN
#          LET p_last_balance   = p_last_balance * -1
#       END IF
#       IF p_last_balance > 0 THEN
#          IF sr.aag06 ='2'
#             THEN LET q_dc = g_x[12]
#             ELSE LET q_dc = g_x[11]
#          END IF
#          LET q_last_balance = p_last_balance
#       ELSE
#          IF p_last_balance < 0 THEN
#             IF sr.aag06 ='2'
#                THEN LET q_dc = g_x[11]
#                ELSE LET q_dc = g_x[12]
#             END IF
#             LET q_last_balance = 0 - p_last_balance
#          ELSE
#             LET q_dc = g_x[13]
#             LET p_last_balance = 0
#             LET q_last_balance = 0
#          END IF
#       END IF
#       LET sr.s_dc = q_dc
#       LET p_balance = p_last_balance
#       PRINT COLUMN 01,sr.s_month,'01',                  #LINE NO 9
#             COLUMN 20,g_x[14] CLIPPED,
#             COLUMN 111,q_dc[1,2],
#             COLUMN 115,cl_numfor(q_last_balance,15,t_azi04)    #No.CHI-6A0004
 
#   ON EVERY ROW
#      IF LINENO>=37 THEN SKIP TO TOP OF PAGE END IF
#      IF cl_null(sr.s_day) THEN
#         PRINT
#      ELSE
#         IF g_record >= 28 THEN
#            IF LINENO = 36 THEN
#               PRINT COLUMN 20,g_x[6] CLIPPED
#               SKIP TO TOP OF PAGE
#               PRINT COLUMN 20,g_x[15] CLIPPED
#            END IF
#         END IF
#         PRINT COLUMN 01,sr.s_month[1,2],sr.s_day[1,2],
#               COLUMN 06,sr.abb01[1,8],                   #憑証號
#               COLUMN 16,sr.abb04[1,30],                  #摘要
#               COLUMN 51,sr.s_kemu CLIPPED;
#         IF sr.abb06 ='1' THEN                            #借方
#            PRINT COLUMN 75,cl_numfor(sr.abb07,14,t_azi04);   #No.CHI-6A0004
#            PRINT COLUMN 91,' ';
#            IF sr.aag06 = '1' THEN
#               LET p_balance = p_balance + sr.abb07
#            ELSE
#               LET p_balance = p_balance - sr.abb07
#            END IF
#            IF p_balance < 0 THEN
#               LET sr.balance = 0-p_balance
#               IF sr.aag06 = '1'
#                  THEN LET sr.s_dc = g_x[12]
#                  ELSE LET sr.s_dc = g_x[11]
#               END IF
#            ELSE
#               IF p_balance > 0 THEN
#                  LET sr.balance = p_balance
#                  IF sr.aag06 = '1'
#                     THEN LET sr.s_dc = g_x[11]
#                     ELSE LET sr.s_dc = g_x[12]
#                  END IF
#               ELSE
#                  LET sr.balance = 0
#                  LET p_balance = 0
#                  LET sr.s_dc = g_x[13]
#               END IF
#            END IF
#         ELSE                               #貸方
#            PRINT COLUMN 75,' ',COLUMN 91,cl_numfor(sr.abb07,14,t_azi04);   #No.CHI-6A0004
#            IF sr.aag06 = '1' THEN
#               LET p_balance = p_balance - sr.abb07
#            ELSE
#               LET p_balance = p_balance + sr.abb07
#            END IF
#            IF p_balance < 0 THEN
#               LET sr.balance = 0-p_balance
#               IF sr.aag06 = '1'
#                  THEN LET sr.s_dc = g_x[12]
#                  ELSE LET sr.s_dc = g_x[11]
#               END IF
#            ELSE
#               IF p_balance > 0 THEN
#                  LET sr.balance = p_balance
#                  IF sr.aag06 = '1'
#                     THEN LET sr.s_dc = g_x[11]
#                     ELSE LET sr.s_dc = g_x[12]
#                  END IF
#               ELSE
#                  LET p_balance = 0
#                  LET sr.balance = 0
#                  LET sr.s_dc = g_x[13]
#               END IF
#            END IF
#         END IF
#         PRINT COLUMN 111,sr.s_dc,
#               COLUMN 115,cl_numfor(sr.balance,15,t_azi04)    #No.CHI-6A0004
#      END IF
#
#   AFTER GROUP OF sr.s_day
#      OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date
#      FETCH curs_tas INTO d_debit,d_credit
#      IF cl_null(d_debit) THEN LET d_debit = 0 END IF
#      IF cl_null(d_credit) THEN LET d_credit = 0 END IF
#      OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month
#      FETCH curs_tas2 INTO d_balance
#      IF cl_null(d_balance) THEN LET d_balance = 0 END IF
#      IF sr.aag06 = '2' THEN
#         LET d_balance = d_balance * -1
#      END IF
#      LET ds_balance = d_balance
#      IF ds_balance > 0 THEN
#         IF sr.aag06 = '2'
#            THEN LET d_dc = g_x[12]
#            ELSE LET d_dc = g_x[11]
#         END IF
#         LET ds_balance = ds_balance
#      ELSE
#        IF ds_balance < 0 THEN
#           IF sr.aag06 = '2'
#              THEN LET d_dc = g_x[11]
#              ELSE LET d_dc = g_x[12]
#           END IF
#           LET ds_balance = 0 - ds_balance
#        ELSE
#           LET d_dc = g_x[13]
#           LET ds_balance = 0
#        END IF
#      END IF
#      LET l_day = cl_days(tm.yyyy,sr.s_month)
#      IF cl_null(sr.s_day) THEN
#         PRINT COLUMN 1,sr.s_month[1,2],l_day[1,2];
#      ELSE
#         PRINT COLUMN 1,sr.s_month[1,2],sr.s_day[1,2];
#      END IF
#      PRINT COLUMN 20,g_x[16] CLIPPED,
#            COLUMN 75,cl_numfor(d_debit,14,t_azi05),   #No.CHI-6A0004
#            COLUMN 91,cl_numfor(d_credit,14,t_azi05),  #No.CHI-6A0004
#            COLUMN 111,d_dc,
#            COLUMN 115,cl_numfor(ds_balance,15,t_azi05)  #No.CHI-6A0004
#
#   AFTER GROUP OF sr.s_month
#      #PAGENO
#      SELECT COUNT(*) INTO l_cnt FROM tpg_file
#       WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01
#         AND tpg05='gglr309'
#      LET l_month = sr.s_month
#      LET g_aag01 = sr.aag01
#      IF l_cnt = 0 THEN
#         INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)
#                       VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr309')
#      ELSE
#         UPDATE tpg_file SET tpg04 = g_pageno
#          WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01
#            AND tpg05='gglr309'
#      END IF
#      OPEN curs_pageno USING l_month,g_aag01
#      FETCH curs_pageno INTO g_pageno
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
 
#      OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah2 INTO m_debit,m_credit
#      IF cl_null(m_debit) THEN LET m_debit = 0 END IF
#      IF cl_null(m_credit) THEN LET m_credit = 0 END IF
#      OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah3 INTO m_balance
#      IF cl_null(m_balance) THEN LET m_balance = 0 END IF
#      IF sr.aag06 = '2' THEN
#         LET m_balance = m_balance * -1
#      END IF
#      IF m_balance > 0 THEN
#         IF sr.aag06 = '2'
#            THEN LET m_dc = g_x[12]
#            ELSE LET m_dc = g_x[11]
#         END IF
#      ELSE
#         IF m_balance < 0 THEN
#            IF sr.aag06 = '2'
#               THEN LET m_dc = g_x[11]
#               ELSE LET m_dc = g_x[12]
#            END IF
#            LET m_balance = 0 - m_balance
#         ELSE
#            LET m_dc = g_x[13]
#            LET m_balance =0
#         END IF
#      END IF
#      LET l_day = cl_days(tm.yyyy,sr.s_month)
#      PRINT COLUMN 1,sr.s_month[1,2],l_day[1,2];
#      PRINT COLUMN 20,g_x[17] CLIPPED,
#            COLUMN 75,cl_numfor(m_debit,14,t_azi05),   #No.CHI-6A0004
#            COLUMN 91,cl_numfor(m_credit,14,t_azi05),  #No.CHI-6A0004
#            COLUMN 111,m_dc,
#            COLUMN 115,cl_numfor(m_balance,15,t_azi05) #No.CHI-6A0004
#
#      OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah4 INTO y_debit,y_credit
#      IF cl_null(y_debit) THEN LET y_debit = 0 END IF
#      IF cl_null(y_credit) THEN LET y_credit = 0 END IF
#      OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah5 INTO y_balance
#      IF cl_null(y_balance) THEN LET y_balance = 0 END IF
#      IF sr.aag06 = '2' THEN
#         LET y_balance = y_balance * -1
#      END IF
#      IF y_balance > 0 THEN
#         IF sr.aag06 = '2'
#            THEN LET y_dc = g_x[12]
#            ELSE LET y_dc = g_x[11]
#         END IF
#      ELSE
#         IF y_balance < 0 THEN
#            IF sr.aag06 = '2'
#               THEN LET y_dc = g_x[11]
#               ELSE LET y_dc = g_x[12]
#            END IF
#            LET y_balance = 0 - y_balance
#         ELSE
#            LET y_dc = g_x[13]
#            LET y_balance = 0
#         END IF
#      END IF
#      PRINT COLUMN 1,sr.s_month[1,2],l_day[1,2],
#            COLUMN 20,g_x[18] CLIPPED,
#            COLUMN 75,cl_numfor(y_debit,14,t_azi05),     #No.CHI-6A0004
#            COLUMN 91,cl_numfor(y_credit,14,t_azi05),    #No.CHI-6A0004
#            COLUMN 111,y_dc,
#            COLUMN 115,cl_numfor(y_balance,15,t_azi05)   #No.CHI-6A0004
#      PRINT COLUMN 20,g_x[7] CLIPPED
#END REPORT
 
#REPORT gglr309_rep_f(sr)   #有外幣
# DEFINE  sr            RECORD
#                       s_date        LIKE type_file.dat,     #NO FUN-690009   DATE      #日期
#                       s_month       LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)   #月
#                       s_day         LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)   #日
#                       abb01         LIKE abb_file.abb01,    #憑証號
#                       abb04         LIKE abb_file.abb04,    #摘要
#                       s_kemu        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)  #對方科目
#                       abb25         LIKE abb_file.abb25,    #匯率
#                       abb07f        LIKE abb_file.abb07f,   #外幣金額
#                       abb07         LIKE abb_file.abb07,    #本幣金額
#                       s_dc          LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)    #借貸
#                       balancef      LIKE abb_file.abb07f,   #外幣餘額
#                       balance       LIKE abb_file.abb07,    #本幣餘額
#                       aag01         LIKE aag_file.aag01,
#                       aag02         LIKE aag_file.aag02,
#                       aag13         LIKE aag_file.aag13,    #FUN-6C0012
#                       aag06         LIKE aag_file.aag06,
#                       abb06         LIKE abb_file.abb06,
#                       aba00         LIKE aba_file.aba00,
#                       azi04         LIKE azi_file.azi04,
#                       azi05         LIKE azi_file.azi05
#                       END RECORD
# DEFINE l_month,l_day                LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)
#        p_balance,p_balance_f        LIKE tah_file.tah04,
#        p_last_balance               LIKE tah_file.tah04,
#        p_last_balance_f             LIKE tah_file.tah04,
#        q_last_balance               LIKE tah_file.tah04,
#        q_last_balance_f             LIKE tah_file.tah04,
#        d_debit,d_debit_f            LIKE abb_file.abb07,
#        d_credit,d_credit_f          LIKE abb_file.abb07,
#        d_balance,d_balance_f        LIKE abb_file.abb07,
#        ds_balance,ds_balance_f      LIKE abb_file.abb07,
#        d_dc,m_dc,y_dc,q_dc          LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)
#        m_debit,m_debit_f            LIKE abb_file.abb07,
#        m_credit,m_credit_f          LIKE abb_file.abb07,
#        m_balance,m_balance_f        LIKE abb_file.abb07,
#        y_debit,y_debit_f            LIKE abb_file.abb07,
#        y_credit,y_credit_f          LIKE abb_file.abb07,
#        y_balance,y_balance_f        LIKE abb_file.abb07,
#        l_pageno,l_cnt,l_mm          LIKE type_file.num5        #NO FUN-690009   SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.aag01,sr.s_month,sr.s_day,sr.abb01
 
# FORMAT
#  PAGE HEADER
#     SKIP 2 LINE
#     PRINT COLUMN 86,g_x[1] CLIPPED   #LINE 3
#     LET g_cn = g_cn + 1
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN 02,sr.aag01,                #科目編號
#           COLUMN 84,tm.yyyy USING '###&'     #LINE NO 4
#     #FUN-6C0012.....begin
#     IF tm.e = 'Y' THEN
#        PRINT COLUMN 02,sr.aag13;
#     ELSE
#     #FUN-6C0012.....end
#        PRINT COLUMN 02,sr.aag02;                #LINE NO 5
#     END IF   #FUN-6C0012
#     PRINT COLUMN 175,g_pageno USING '<<<'
#     SKIP 2 LINES
 
#  BEFORE GROUP OF sr.aag01
#     LET g_aag01 = sr.aag01
#     LET l_month = sr.s_month
#     LET l_mm = l_month - 1
#     OPEN curs_pageno USING l_mm,g_aag01
#     FETCH curs_pageno INTO g_pageno
#     IF STATUS = 100 THEN LET g_pageno = 0 END IF
#     IF g_cn = 1 THEN
#        LET g_pageno = g_pageno + 1
#     END IF
#     SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF sr.s_month
#     SKIP TO TOP OF PAGE
#     ##上期結轉
#     OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month
#     FETCH curs_tah INTO p_last_balance,p_last_balance_f
#     IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF
#     IF cl_null(p_last_balance_f) THEN LET p_last_balance_f = 0 END IF
#     IF sr.aag06 ='2' THEN
#        LET p_last_balance   = p_last_balance * -1
#        LET p_last_balance_f = p_last_balance_f * -1
#       END IF
#     IF p_last_balance > 0 THEN
#        IF sr.aag06 ='2'
#           THEN LET q_dc = g_x[12]
#           ELSE LET q_dc = g_x[11]
#        END IF
#        LET q_last_balance   = p_last_balance
#        LET q_last_balance_f = p_last_balance_f
#     ELSE
#        IF p_last_balance < 0 THEN
#           IF sr.aag06 ='2'
#              THEN LET q_dc = g_x[11]
#              ELSE LET q_dc = g_x[12]
#           END IF
#           LET q_last_balance   = 0 - p_last_balance
#           LET q_last_balance_f = 0 - p_last_balance_f
#        ELSE
#           LET q_dc = g_x[13]
#           LET p_last_balance   = 0
#           LET q_last_balance   = 0
#           LET p_last_balance_f = 0
#           LET q_last_balance_f = 0
#        END IF
#     END IF
#     LET sr.s_dc = q_dc
#     LET p_balance   = p_last_balance
#     LET p_balance_f = p_last_balance_f
#     PRINT COLUMN 01,sr.s_month,'01',                  #LINE NO 9
#           COLUMN 20,g_x[14] CLIPPED,
#           COLUMN 151,q_dc[1,2],
#           COLUMN 154,cl_numfor(q_last_balance_f,15,sr.azi04),
#           COLUMN 172,cl_numfor(q_last_balance,15,t_azi04)     #No.CHI-6A0004
 
#   ON EVERY ROW
#     IF LINENO>=37 THEN
#        SKIP TO TOP OF PAGE
#     END IF
#     IF cl_null(sr.s_day) THEN
#        PRINT
#     ELSE
#        IF g_record >= 28 THEN
#           IF LINENO = 36 THEN
#              PRINT COLUMN 20 ,g_x[6] CLIPPED
#              SKIP TO TOP OF PAGE
#              PRINT COLUMN 20 ,g_x[15] CLIPPED
#           END IF
#        END IF
#        PRINT COLUMN  1,sr.s_month[1,2],sr.s_day[1,2],
#              COLUMN  7,sr.abb01[1,8],                 #憑証號
#              COLUMN 16,sr.abb04[1,30],                #摘要
#              COLUMN 48,sr.s_kemu CLIPPED,             #科目
#              COLUMN 65,sr.abb25;                      #匯率
#        IF sr.abb06 ='1' THEN                   #借方
#           PRINT COLUMN 79,cl_numfor(sr.abb07f,15,sr.azi04);
#           PRINT COLUMN 97,cl_numfor(sr.abb07,15,t_azi04);    #No.CHI-6A0004
#           PRINT COLUMN 114,' ';
#           PRINT COLUMN 130,' ';
#           IF sr.aag06 = '1' THEN
#              LET p_balance_f = p_balance_f + sr.abb07f
#              LET p_balance = p_balance + sr.abb07
#           ELSE
#              LET p_balance_f = p_balance_f - sr.abb07f
#              LET p_balance = p_balance - sr.abb07
#           END IF
#           IF p_balance < 0 THEN
#              LET sr.balancef = 0-p_balance_f
#              LET sr.balance = 0-p_balance
#              IF sr.aag06 = '1'
#                 THEN LET sr.s_dc = g_x[12]
#                 ELSE LET sr.s_dc = g_x[11]
#              END IF
#           ELSE
#              IF p_balance > 0 THEN
#                 LET sr.balancef= p_balance_f
#                 LET sr.balance = p_balance
#                 IF sr.aag06 = '1'
#                    THEN LET sr.s_dc = g_x[11]
#                    ELSE LET sr.s_dc = g_x[12]
#                 END IF
#              ELSE
#                 LET sr.balancef= 0
#                 LET sr.balance = 0
#                 LET sr.s_dc = g_x[13]
#              END IF
#           END IF
#        ELSE                               #貸方
#           PRINT COLUMN 75,' ',COLUMN 97,
#                 COLUMN 115,cl_numfor(sr.abb07f,15,sr.azi04),
#                 COLUMN 132,cl_numfor(sr.abb07,15,t_azi04);    #No.CHI-6A0004
#           IF sr.aag06 = '1' THEN
#              LET p_balance_f = p_balance_f - sr.abb07f
#              LET p_balance = p_balance - sr.abb07
#           ELSE
#              LET p_balance_f = p_balance_f + sr.abb07f
#              LET p_balance = p_balance + sr.abb07
#           END IF
#           IF p_balance < 0 THEN
#              LET sr.balancef= 0-p_balance_f
#              LET sr.balance = 0-p_balance
#              IF sr.aag06 = '1'
#                 THEN LET sr.s_dc = g_x[12]
#                 ELSE LET sr.s_dc = g_x[11]
#              END IF
#           ELSE
#              IF p_balance > 0 THEN
#                 LET sr.balancef = p_balance_f
#                 LET sr.balance = p_balance
#                 IF sr.aag06 = '1'
#                    THEN LET sr.s_dc = g_x[11]
#                    ELSE LET sr.s_dc = g_x[12]
#                 END IF
#              ELSE
#                 LET sr.balancef = 0
#                 LET sr.balance = 0
#                 LET sr.s_dc = g_x[13]
#              END IF
#           END IF
#        END IF
#        PRINT COLUMN 151,sr.s_dc,
#              COLUMN 154,cl_numfor(sr.balancef,15,sr.azi04),
#              COLUMN 172,cl_numfor(sr.balance,15,t_azi04)    #No.CHI-6A0004
#     END IF
#
#   AFTER GROUP OF sr.s_day
#     OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date
#     FETCH curs_tas INTO d_debit,d_credit,d_debit_f,d_credit_f
#     IF cl_null(d_debit) THEN LET d_debit = 0 END IF
#     IF cl_null(d_credit) THEN LET d_credit = 0 END IF
#     IF cl_null(d_debit_f) THEN LET d_debit_f = 0 END IF
#     IF cl_null(d_credit_f) THEN LET d_credit_f = 0 END IF
#     OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month
#     FETCH curs_tas2 INTO d_balance,d_balance_f
#     IF cl_null(d_balance) THEN LET d_balance = 0 END IF
#     IF cl_null(d_balance_f) THEN LET d_balance_f = 0 END IF
#     IF sr.aag06 = '2' THEN
#        LET d_balance   = d_balance   * -1
#        LET d_balance_f = d_balance_f * -1
#     END IF
#     LET ds_balance = d_balance
#     LET ds_balance_f = d_balance_f
#     IF ds_balance > 0 THEN
#        IF sr.aag06 = '2'
#           THEN LET d_dc = g_x[12]
#           ELSE LET d_dc = g_x[11]
#        END IF
#        LET ds_balance = ds_balance
#        LET ds_balance_f = ds_balance_f
#     ELSE
#        IF ds_balance < 0 THEN
#           IF sr.aag06 = '2'
#              THEN LET d_dc = g_x[11]
#              ELSE LET d_dc = g_x[12]
#           END IF
#           LET ds_balance = 0 - ds_balance
#           LET ds_balance_f = 0 - ds_balance_f
#        ELSE
#           LET d_dc = g_x[13]
#           LET ds_balance = 0
#           LET ds_balance_f = 0
#        END IF
#     END IF
#     LET l_day = cl_days(tm.yyyy,sr.s_month)
#     IF cl_null(sr.s_day)  THEN
#        PRINT COLUMN 1,sr.s_month[1,2],l_day[1,2];
#     ELSE
#        PRINT COLUMN 1,sr.s_month[1,2],sr.s_day[1,2];
#     END IF
#     PRINT COLUMN  20,g_x[16] CLIPPED,
#           COLUMN  79,cl_numfor(d_debit_f,15,sr.azi05),
#           COLUMN  97,cl_numfor(d_debit,15,t_azi05),      #No.CHI-6A0004
#           COLUMN 115,cl_numfor(d_credit_f,15,sr.azi05),
#           COLUMN 132,cl_numfor(d_credit,15,t_azi05),     #No.CHI-6A0004
#           COLUMN 151,d_dc,
#           COLUMN 154,cl_numfor(ds_balance_f,15,sr.azi05),
#           COLUMN 172,cl_numfor(ds_balance,15,t_azi05)    #No.CHI-6A0004
#
#   AFTER GROUP OF sr.s_month
#     #PAGENO
#      SELECT COUNT(*) INTO l_cnt FROM tpg_file
#       WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01
#         AND tpg05='gglr309'
#      LET l_month = sr.s_month
#      LET g_aag01 = sr.aag01
#      IF l_cnt = 0 THEN
#         INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)
#                       VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr309')
#      ELSE
#         UPDATE tpg_file SET tpg04 = g_pageno
#          WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01
#            AND tpg05='gglr309'
#      END IF
#      OPEN curs_pageno USING l_month,g_aag01
#      FETCH curs_pageno INTO g_pageno
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
 
#      OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah2 INTO m_debit,m_credit,m_debit_f,m_credit_f
#      IF cl_null(m_debit) THEN LET m_debit = 0 END IF
#      IF cl_null(m_credit) THEN LET m_credit = 0 END IF
#      IF cl_null(m_debit_f) THEN LET m_debit_f = 0 END IF
#      IF cl_null(m_credit_f) THEN LET m_credit_f = 0 END IF
#      OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah3 INTO m_balance,m_balance_f
#      IF cl_null(m_balance) THEN LET m_balance = 0 END IF
#      IF cl_null(m_balance_f) THEN LET m_balance_f = 0 END IF
#      IF sr.aag06 = '2' THEN
#         LET m_balance   = m_balance   * -1
#         LET m_balance_f = m_balance_f * -1
#      END IF
#      IF m_balance > 0 THEN
#         IF sr.aag06 = '2'
#            THEN LET m_dc = g_x[12]
#            ELSE LET m_dc = g_x[11]
#         END IF
#      ELSE
#         IF m_balance < 0 THEN
#            IF sr.aag06 = '2'
#               THEN LET m_dc = g_x[11]
#               ELSE LET m_dc = g_x[12]
#            END IF
#            LET m_balance = 0 - m_balance
#            LET m_balance_f = 0 - m_balance_f
#         ELSE
#            LET m_dc = g_x[13]
#            LET m_balance = 0
#            LET m_balance_f = 0
#         END IF
#      END IF
#      PRINT COLUMN  1,sr.s_month[1,2],l_day[1,2];
#      PRINT COLUMN  20,g_x[17] CLIPPED,
#            COLUMN  79,cl_numfor(m_debit_f,15,sr.azi05),
#            COLUMN  97,cl_numfor(m_debit,15,t_azi05),     #No.CHI-6A0004
#            COLUMN 115,cl_numfor(m_credit_f,15,sr.azi05),
#            COLUMN 132,cl_numfor(m_credit,15,t_azi05),    #No.CHI-6A0004
#            COLUMN 151,m_dc,
#            COLUMN 154,cl_numfor(m_balance_f,15,sr.azi05),
#            COLUMN 172,cl_numfor(m_balance,15,t_azi05)    #No.CHI-6A0004
#
#      OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah4 INTO y_debit,y_credit,y_debit_f,y_credit_f
#      IF cl_null(y_debit) THEN LET y_debit = 0 END IF
#      IF cl_null(y_credit) THEN LET y_credit = 0 END IF
#      IF cl_null(y_debit_f) THEN LET y_debit_f = 0 END IF
#      IF cl_null(y_credit_f) THEN LET y_credit_f = 0 END IF
#      OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah5 INTO y_balance,y_balance_f
#      IF cl_null(y_balance) THEN LET y_balance = 0 END IF
#      IF cl_null(y_balance_f) THEN LET y_balance_f = 0 END IF
#      IF sr.aag06 = '2' THEN
#         LET y_balance   = y_balance   * -1
#         LET y_balance_f = y_balance_f * -1
#      END IF
#      IF y_balance > 0 THEN
#         IF sr.aag06 = '2'
#            THEN LET m_dc = g_x[12]
#            ELSE LET m_dc = g_x[11]
#         END IF
#      ELSE
#         IF y_balance < 0 THEN
#            IF sr.aag06 = '2'
#               THEN LET m_dc = g_x[11]
#               ELSE LET m_dc = g_x[12]
#            END IF
#            LET y_balance = 0 - y_balance
#            LET y_balance_f = 0 - y_balance_f
#         ELSE
#            LET m_dc = g_x[13]
#            LET y_balance=0
#            LET y_balance_f=0
#         END IF
#      END IF
#      PRINT COLUMN  1,sr.s_month[1,2],l_day[1,2];
#      PRINT COLUMN  20,g_x[18] CLIPPED,
#            COLUMN  79,cl_numfor(y_debit_f,15,sr.azi05),
#            COLUMN  97,cl_numfor(y_debit,15,t_azi05),     #No.CHI-6A0004
#            COLUMN 115,cl_numfor(y_credit_f,15,sr.azi05),
#            COLUMN 132,cl_numfor(y_credit,15,t_azi05),    #No.CHI-6A0004
#            COLUMN 151,m_dc,
#            COLUMN 154,cl_numfor(y_balance_f,15,sr.azi05),
#            COLUMN 172,cl_numfor(y_balance,15,t_azi05)    #No.CHI-6A0004
#END REPORT
#No.FUN-850058 --MARK END--
#Patch....NO.TQC-610037 <001> #
