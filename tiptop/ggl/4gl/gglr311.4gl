# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr311.4gl
# Descriptions...: 記帳傳票列印
# Date & Author..: 05/07/06 By Trisy
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680025 06/08/24 By Jackho voucher型報表轉template1 
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/12 By hongmei 會計科目加帳套
# Modify.........: No.FUN-780031 07/08/27 By Carrier 報表轉Crystal Report格式 & FOREACH aba有問題
# Modify.........: No.TQC-780085 07/10/23 By wujie   sr的初始化位置有錯誤
# Modify.........: No.MOD-860252 09/02/17 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位        
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm    RECORD                  # Print condition RECORD
                wc      LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(300)   # Where condition
                yyyy    LIKE type_file.num5,       #NO FUN-690009   SMALLINT    # year
                mm      LIKE type_file.num5,       #NO FUN-690009   SMALLINT    # period
                nn      LIKE type_file.num5,       #NO FUN-690009   SMALLINT    # laster
                bookno  LIKE aaa_file.aaa01,       #No.FUN-740055
                p       LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)     # 獨立列印否
                bb      LIKE azi_file.azi01,       #NO FUN-690009   VARCHAR(4)     # 幣別
                e       LIKE type_file.chr1,       #FUN-6C0012
                h       LIKE type_file.chr1,       #MOD-860252
                more    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)     # Input more condition(Y/N)
                END RECORD,
     g_abb24    LIKE abb_file.abb24,
     g_aag01    LIKE aag_file.aag01,
     g_cn       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
     g_aac13    LIKE aac_file.aac13,
     g_no       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
     g_record   LIKE type_file.num5,       #NO FUN-690009   SMALLINT
     g_flag     LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
DEFINE   g_aaa03        LIKE aaa_file.aaa03
DEFINE   g_i            LIKE type_file.num5        #NO FUN-690009    SMALLINT    #count/index for any purpose
DEFINE   l_table        STRING  #No.FUN-780031
DEFINE   g_str          STRING  #No.FUN-780031
DEFINE   g_sql          STRING  #No.FUN-780031
 
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
 
   #No.FUN-780031  --Begin
   LET g_sql = " aag01.aag_file.aag01,",
               " aag02.aag_file.aag02,",
               " aag06.aag_file.aag06,",
               " s_month.type_file.chr2,",
               " s_day.type_file.chr2,",
               " s_date.type_file.dat,",
               " abb01.abb_file.abb01,",
               " abb04.abb_file.abb04,",
               " abb06.abb_file.abb06,",
               " abb07f.abb_file.abb07f,",
               " abb07.abb_file.abb07,",
               " abb25.abb_file.abb25,",
               " db_b.aah_file.aah04,",  #借  -- 截止到上一個月的本年借方異動值
               " db_bf.aah_file.aah04,",
               " cr_b.aah_file.aah04,",  #貸  -- 截止至上一個月的本年貸方異動值
               " cr_bf.aah_file.aah04,", 
               " bal.aah_file.aah04,",   #余額 --上月的結余     
               " balf.aah_file.aah04,",
               " l_day.type_file.chr2 "
 
   LET l_table = cl_prt_temptable('gglr311',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?   ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
   LET g_trace = 'N'                            # default trace off
#  LET tm.bookno = ' '                          #No.FUN-740055
   LET tm.bookno = ARG_VAL(1)                   #No.FUN-740055
   LET g_pdate  = ARG_VAL(2)                    # Get arguments from command line
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
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
#     LET tm.bookno = g_aaz.aaz64                #帳別若為空白則使用預設帳別  #No.FUN-740055
      LET tm.bookno = g_aza.aza81                #No.FUN-740055
   END IF
 
   #No.FUN-740055 ---Begin
   IF cl_null(tm.bookno) THEN LET tm.bookno=g_aza.aza81 END IF                                                                      
   #使用預設帳別之幣別                                                                                                              
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno
   #No.FUN-740055 ---End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL gglr311_tm()                    # Input print condition
      ELSE CALL gglr311()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr311_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_n           LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_cmd         LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
   DEFINE p_cmd         LIKE type_file.chr1        #NO FUN-690009   VARCHAR(01)
 
   CALL s_dsmark(tm.bookno)     #No.FUN-740055
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW gglr311_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr311"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740055
   CALL cl_opmsg('p')
 
INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bookno = g_aza.aza81     #FUN-B20010
   LET tm.p    = 'N'
   LET tm.bb   = ' '
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.h    = 'Y'  #MOD-860252
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
      CALL r311_set_entry(p_cmd)
      CALL r311_set_no_entry(p_cmd)
      CALL cl_qbe_display_condition(lc_qbe_sn)
    
    AFTER FIELD bookno                                                                                                         
            IF NOT cl_null(tm.bookno) THEN                                                                                          
               CALL r311_bookno(tm.bookno)                                                                                          
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(tm.bookno,g_errno,0)                                                                                  
                  LET tm.bookno = g_aza.aza81                                                                                       
                  DISPLAY BY NAME tm.bookno                                                                                         
                  NEXT FIELD bookno                                                                                                 
               END IF                                                                                                               
            END IF
        
    END INPUT
    
    #No.FUN-B20010  --End
 CONSTRUCT BY NAME tm.wc ON aag01 HELP 1
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark Begin       
#       ON ACTION locale
#          LET g_action_choice = "locale"
#          EXIT CONSTRUCT
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#       ON ACTION CONTROLG
#          CALL cl_cmdask()      # Command execution
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark Begin
 
    END CONSTRUCT
#No.FUN-B20010  --Mark Begin 
#    IF g_action_choice = "locale" THEN
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE
#    END IF
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW gglr311_w EXIT PROGRAM
#    END IF

#    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#No.FUN-B20010  --Mark End
  #INPUT BY NAME tm.yyyy,tm.mm,tm.nn,tm.bookno,tm.p,tm.bb,tm.e,tm.h,tm.more WITHOUT DEFAULTS  #FUN-6C0012  #No.FUN-740055 #No.MOD-860252 add tm.h #FUN-B20010 mark
  INPUT BY NAME tm.yyyy,tm.mm,tm.nn,tm.p,tm.bb,tm.e,tm.h,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉tm.bookno

    BEFORE INPUT
      CALL r311_set_entry(p_cmd)
      CALL r311_set_no_entry(p_cmd)
 
         #No.FUN-580031 --start--
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
#      IF cl_null(tm.nn) OR tm.nn <= 0 OR tm.nn >13 THEN
#         NEXT FIELD nn
#      END IF
#No.TQC-720032 -- end --
      IF tm.nn < tm.mm THEN NEXT FIELD nn END IF
    #No.FUN-B20010  --Mark Begin
    #No.FUN-740055 ---Begin
    #AFTER FIELD bookno                                                                                                         
    #       IF NOT cl_null(tm.bookno) THEN                                                                                          
    #          CALL r311_bookno(tm.bookno)                                                                                          
    #          IF NOT cl_null(g_errno) THEN                                                                                         
    #             CALL cl_err(tm.bookno,g_errno,0)                                                                                  
    #             LET tm.bookno = g_aza.aza81                                                                                       
    #             DISPLAY BY NAME tm.bookno                                                                                         
    #             NEXT FIELD bookno                                                                                                 
    #          END IF                                                                                                               
    #       END IF
    #No.FUN-740055 ---End
    #No.FUN-B20010  --Mark End
 
    BEFORE FIELD p
      CALL r311_set_entry(p_cmd)
 
    AFTER FIELD p
      IF cl_null(tm.p) OR tm.p NOT MATCHES "[YN]" THEN NEXT FIELD p END IF
      IF tm.p  = 'N' THEN
         LET tm.bb = NULL
         DISPLAY BY NAME tm.bb
      END IF
      CALL r311_set_no_entry(p_cmd)
 
    AFTER FIELD bb
      IF cl_null(tm.bb) THEN NEXT FIELD bb END IF
      SELECT azi01 FROM azi_file WHERE azi01 = tm.bb AND aziacti = 'Y'
      IF STATUS THEN
#        CALL cl_err(tm.bb,'agl-109',0)    #No.FUN-660124
         CALL cl_err3("sel","azi_file",tm.bb,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
         NEXT FIELD bb
      END IF
 
    AFTER FIELD more
      IF tm.more = 'Y'
        THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
        END IF
#No.FUN-B20010  --Mark Begin 
#    ON ACTION CONTROLP
#        CASE
#           #No.FUN-740055 ---Begin
#           WHEN INFIELD(bookno)                                                                                                 
#                 CALL cl_init_qry_var()                                                                                            
#                 LET g_qryparam.form ="q_aaa"                                                                                      
#                 LET g_qryparam.default1 = tm.bookno                                                                               
#                 CALL cl_create_qry() RETURNING tm.bookno                                                                          
#                 DISPLAY BY NAME tm.bookno                                                                                         
#                 NEXT FIELD bookno
#           #No.FUN-740055 ---End
#          WHEN INFIELD(bb)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azi'
#              LET g_qryparam.default1 = tm.bb
#              CALL cl_create_qry() RETURNING tm.bb
#              DISPLAY BY NAME tm.bb
#              NEXT FIELD bb
#            OTHERWISE  EXIT CASE
#        END CASE
#        ON ACTION locale
#          LET g_action_choice = "locale"
 
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#       ON ACTION exit
#       LET INT_FLAG = 1
#       EXIT INPUT
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
              NEXT FIELD bb 
            OTHERWISE  EXIT CASE
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
        CLOSE WINDOW gglr311_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
      END IF
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      
    #No.FUN-B20010  --End
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='gglr311'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr311','9031',1)   
       ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'",    #No.FUN-740055
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
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
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          IF g_trace = 'Y' THEN
             ERROR l_cmd
          END IF
          CALL cl_cmdat('gglr311',g_time,l_cmd) # Execute cmd at later time
       END IF
       CLOSE WINDOW gglr311_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr311()
    ERROR ""
  END WHILE
  CLOSE WINDOW gglr311_w
END FUNCTION
 
#No.FUN-740055 -Begin
FUNCTION r311_bookno(p_bookno)                                                                                                      
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
 
FUNCTION gglr311_curs()
  DEFINE l_sql   LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(600)
 
     LET l_sql = "SELECT tpg04 FROM tpg_file ",
                 " WHERE tpg01 = ",tm.yyyy,
                 "   AND tpg02 = ? ",
                 "   AND tpg03 = ? ",
                 "   AND tpg05 = 'gglr311'"
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
 
FUNCTION gglr311()
   DEFINE l_name        LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)     # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0097
          l_pageno      LIKE type_file.num5,       #NO FUN-690009   smallint
          l_sql         LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)   # RDSQL STATEMENT
          l_za05        LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(40)
          b_date        LIKE type_file.dat,        #NO FUN-690009   DATE
          l_aag01       LIKE aag_file.aag01,
          l_aag02       LIKE aag_file.aag02,
          l_aag13       LIKE aag_file.aag13,       #FUN-6C0012
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
                        s_date        LIKE type_file.dat,     #NO FUN-690009   DATE     #日期
                        s_month       LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)  #月
                        s_day         LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)  #日
                        abb01         LIKE abb_file.abb01,    #憑証號
                        abb04         LIKE abb_file.abb04,    #摘要
                        s_kemu        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20) #對方科目
                        abb25         LIKE abb_file.abb25,    #匯率
                        abb07f        LIKE abb_file.abb07f,   #外幣金額
                        abb07         LIKE abb_file.abb07,    #本幣金額
                        s_dc          LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)   #借貸
                        balancef      LIKE abb_file.abb07f,   #外幣余額
                        balance       LIKE abb_file.abb07,    #本幣余額
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
   #No.FUN-780031  --Begin
   DEFINE db_b         LIKE aah_file.aah04
   DEFINE db_bf        LIKE aah_file.aah04
   DEFINE cr_b         LIKE aah_file.aah04
   DEFINE cr_bf        LIKE aah_file.aah04
   DEFINE bal          LIKE aah_file.aah04
   DEFINE balf         LIKE aah_file.aah04
   DEFINE l_day        LIKE type_file.chr2
   #No.FUN-780031  --End  
 
     #No.FUN-780031  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780031  --End
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time                           #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gglr311'               #No.FUN-680025
     #使用預設帳別之幣別
     IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
      SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file                 #No.CHI-6A0004
      WHERE azi01 = g_aaa03
     #資料權限的檢查
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
     LET l_sql = "SELECT aag01,aag02,aag13,aag06 FROM aag_file ",  #FUN-6C0012
                 " WHERE aag03 = '2' ",
                 "   AND (aag07 = '2' OR aag07 ='3' ) ",
                 "   AND aagacti = 'Y' ",
                 "   AND aag00 = '",tm.bookno,"'",     #No.FUN-740055
                 "   AND ",tm.wc CLIPPED
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql , " AND aag09 = 'Y'  " 
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
 
     #No.FUN-780031  --Begin
     #CALL cl_outnam('gglr311') RETURNING l_name
     #LET g_pageno = 0
     ##No.FUN-680025--begin
     #IF tm.p = 'N' THEN
     #   LET g_zaa[36].zaa06='Y'
     #   LET g_zaa[37].zaa06='Y'
     #   LET g_zaa[38].zaa06='Y'
     #   LET g_zaa[39].zaa06='Y'
     #   LET g_zaa[40].zaa06='Y'
     #   LET g_zaa[43].zaa06='Y'
     #   LET g_zaa[44].zaa06='Y'
     #END IF    
     #IF tm.p = 'Y' THEN
     #   LET g_zaa[34].zaa06='Y'
     #   LET g_zaa[35].zaa06='Y'
     #   LET g_zaa[42].zaa06='Y'
     #END IF    
     #CALL cl_prt_pos_len()
     ##No.FUN-680025--end
     IF tm.p = 'N' THEN 
         LET l_name = 'gglr311'
         LET g_abb24 = g_aaa03
     ELSE
         LET l_name = 'gglr311_1'
         LET g_abb24 = tm.bb
     END IF
     #IF tm.p = 'N' THEN
     #   LET g_aac13 = 'N'
     #   LET g_abb24 = g_aaa03
     #   START REPORT gglr311_rep TO l_name
     #ELSE
     #   LET g_aac13 = 'Y'
     #   LET g_abb24 = tm.bb
     #   START REPORT gglr311_rep_f TO l_name
     #END IF
     #SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
     # WHERE azi01 = g_abb24
     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07
       FROM azi_file
      WHERE azi01 = tm.bb
     #No.FUN-780031  --End  
 
     LET l_sql = "SELECT aba00,aba01,aba02,aba04,abb03,abb04,abb06, ",
                 "       abb07f,abb07,abb24,abb25,azi04,azi05 ",
                 "  FROM aba_file,abb_file,OUTER azi_file ",
                 " WHERE aba00=abb00 ",
                 "   AND aba01=abb01 ",
                 "   AND aba00 = '",tm.bookno,"'",     #No.FUN-740055
                 "   AND aba03 = ",tm.yyyy,
                 "   AND aba04 = ? ",
                 "   AND abb03 = ? ",
                 "   AND abapost = 'Y' ",
                 "   AND abb24 = '",g_abb24,"'",
                 "   AND azi_file.azi01 = abb_file.abb24 "
     PREPARE prepare_aba FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare_aba',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM    
     END IF
     DECLARE curs_aba CURSOR FOR prepare_aba
 
     CALL gglr311_curs()
 
     LET g_record = 0            #記錄筆數
     FOREACH curs_aag INTO l_aag01,l_aag02,l_aag13,l_aag06  #FUN-6C0012
#No.TQC-780085 --begin
#       INITIALIZE sr.* TO NULL
#       LET sr.aag01 = l_aag01
#       LET sr.aag02 = l_aag02
#       LET sr.aag13 = l_aag13  #FUN-6C0012
#       LET sr.aag06 = l_aag06
#       #No.FUN-780031  --Begin
#       IF tm.e = 'Y' THEN
#          LET sr.aag02 = l_aag13 
#       END IF
#       #No.FUN-780031  --End  
#       LET g_flag = ''
#No.TQC-780085 --end
       FOR g_no = tm.mm TO tm.nn
#No.TQC-780085 --begin
           INITIALIZE sr.* TO NULL
           LET sr.aag01 = l_aag01
           LET sr.aag02 = l_aag02
           LET sr.aag13 = l_aag13  #FUN-6C0012
           LET sr.aag06 = l_aag06
           #No.FUN-780031  --Begin
           IF tm.e = 'Y' THEN
              LET sr.aag02 = l_aag13 
           END IF
           #No.FUN-780031  --End  
           LET g_flag = ''
#No.TQC-780085 --end
           OPEN curs_aba USING g_no,sr.aag01
           FETCH curs_aba
           IF STATUS = 100 THEN
              OPEN curs_tah USING tm.bookno,sr.aag01,g_no    #No.FUN-740055
              FETCH curs_tah INTO p_last_balance,p_last_balance_f
              IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF
              IF cl_null(p_last_balance_f) THEN LET p_last_balance_f=0 END IF
              IF (tm.p = 'N' AND p_last_balance != 0) OR
                 (tm.p = 'Y' AND p_last_balance_f != 0) THEN
                 LET sr.s_month = g_no
                 #No.FUN-780031  --Begin
                 IF LENGTH(sr.s_month)=1 THEN
                    LET sr.s_month = '0',sr.s_month
                 END IF
                 #No.FUN-780031  --End  
                 LET sr.abb25   = 0
                 LET sr.abb07f  = 0
                 LET sr.abb07   = 0
                 LET sr.azi04   = 0
                 LET sr.azi05   = 0
                 LET sr.balancef= 0
                 LET sr.balance = 0
                 LET sr.aba00   = tm.bookno    #No.FUN-740055
                 LET l_mm = tm.mm - 1
                 OPEN curs_pageno USING l_mm,sr.aag01
                 FETCH curs_pageno INTO g_pageno
                 IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF                  
                 LET g_cn = 0
                 #No.FUN-780031  --Begin
                 #IF tm.p = 'N' THEN
                 #   OUTPUT TO REPORT gglr311_rep(sr.*)
                 #ELSE
                 #   OUTPUT TO REPORT gglr311_rep_f(sr.*)
                 #END IF
                 #取出起始月之前的借貸異動額
                 OPEN curs_tah4 USING tm.bookno,sr.aag01,l_mm
                 FETCH curs_tah4 INTO db_b,cr_b,db_bf,cr_bf
                 IF cl_null(db_b)  THEN LET db_b = 0  END IF
                 IF cl_null(db_bf) THEN LET db_bf = 0 END IF
                 IF cl_null(cr_b)  THEN LET cr_b = 0  END IF
                 IF cl_null(cr_bf) THEN LET cr_bf = 0 END IF
                 #取出起始月末結余
                 OPEN curs_tah3 USING tm.bookno,sr.aag01,l_mm
                 FETCH curs_tah3 INTO bal,balf
                 IF cl_null(bal)  THEN LET bal  = 0 END IF
                 IF cl_null(balf) THEN LET balf = 0 END IF
                 LET l_day = cl_days(tm.yyyy,sr.s_month)
                 EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.aag06,
                         sr.s_month,'','','','','',sr.abb07f,sr.abb07,
                         sr.abb25,db_b,db_bf,cr_b,cr_bf,bal,balf,l_day
                 #No.FUN-780031  --End  
              END IF
           ELSE
#             OPEN curs_aba USING g_no,sr.aag01      #No.FUN-780031
              FOREACH curs_aba USING g_no,sr.aag01   #No.FUN-780031
                               INTO l_aba00,l_aba01,l_aba02,l_aba04,
                                    l_abb03,l_abb04,l_abb06,l_abb07f,
                                    l_abb07,l_abb24,l_abb25,l_azi04,l_azi05
                 IF STATUS THEN
                    CALL cl_err('curs_aba',STATUS,0) EXIT FOREACH
                 END IF
                 LET sr.s_date = l_aba02      #憑証日期
                 LET sr.s_month = l_aba04     #月
                 #No.FUN-780031  --Begin
                 IF LENGTH(sr.s_month)=1 THEN
                    LET sr.s_month = '0',sr.s_month
                 END IF
                 #No.FUN-780031  --End  
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
                 #No.FUN-780031  --Begin
                 #IF tm.p = 'N' THEN
                 #   OUTPUT TO REPORT gglr311_rep(sr.*)
                 #ELSE
                 #   OUTPUT TO REPORT gglr311_rep_f(sr.*)
                 #END IF
                 #取出起始月之前的借貸異動額
                 OPEN curs_tah4 USING tm.bookno,sr.aag01,l_mm
                 FETCH curs_tah4 INTO db_b,cr_b,db_bf,cr_bf
                 IF cl_null(db_b)  THEN LET db_b = 0  END IF
                 IF cl_null(db_bf) THEN LET db_bf = 0 END IF
                 IF cl_null(cr_b)  THEN LET cr_b = 0  END IF
                 IF cl_null(cr_bf) THEN LET cr_bf = 0 END IF
                 #取出起始月末結余
                 OPEN curs_tah3 USING tm.bookno,sr.aag01,l_mm
                 FETCH curs_tah3 INTO bal,balf
                 IF cl_null(bal)  THEN LET bal  = 0 END IF
                 IF cl_null(balf) THEN LET balf = 0 END IF
                 LET l_day = cl_days(tm.yyyy,sr.s_month)
                 EXECUTE insert_prep USING sr.aag01,sr.aag02,sr.aag06,
                         sr.s_month,sr.s_day,sr.s_date,sr.abb01,sr.abb04,
                         sr.abb06,sr.abb07f,sr.abb07,sr.abb25,
                         db_b,db_bf,cr_b,cr_bf,bal,balf,l_day
                 #No.FUN-780031  --End
                 LET g_record = g_record + 1
              END FOREACH
           END IF
       END FOR
     END FOREACH
 
     #No.FUN-780031  --Begin
     #IF tm.p = 'N' THEN
     #   FINISH REPORT gglr311_rep
     #ELSE
     #   FINISH REPORT gglr311_rep_f
     #END IF
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.e,";",g_azi04,";",g_azi05,";",t_azi04,";",
                 t_azi05,";",t_azi07
     CALL cl_prt_cs3('gglr311',l_name,g_sql,g_str)
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin---    
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780031  --Begin
##無外幣
#REPORT gglr311_rep(sr)
#  DEFINE  sr            RECORD
#                        s_date        LIKE type_file.dat,     #NO FUN-690009   DATE         #日期
#                        s_month       LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)      #月
#                        s_day         LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)      #日
#                        abb01         LIKE abb_file.abb01,    #憑証號
#                        abb04         LIKE abb_file.abb04,    #摘要
#                        s_kemu        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)     #對方科目
#                        abb25         LIKE abb_file.abb25,    #匯率
#                        abb07f        LIKE abb_file.abb07f,   #外幣金額
#                        abb07         LIKE abb_file.abb07,    #本幣金額
#                        s_dc          LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)      #借貸
#                        balancef      LIKE abb_file.abb07f,   #外幣余額
#                        balance       LIKE abb_file.abb07,    #本幣余額
#                        aag01         LIKE aag_file.aag01,
#                        aag02         LIKE aag_file.aag02,
#                        aag13         LIKE aag_file.aag13,    #FUN-6C0012
#                        aag06         LIKE aag_file.aag06,
#                        abb06         LIKE abb_file.abb06,
#                        aba00         LIKE aba_file.aba00,
#                        azi04         LIKE azi_file.azi04,
#                        azi05         LIKE azi_file.azi05
#                        END RECORD
#  DEFINE l_month,l_day  LIKE type_file.chr2,       #NO FUN-690009   VARCHAR(2)
#         p_balance      LIKE tah_file.tah04,
#         p_last_balance LIKE tah_file.tah04,
#         q_last_balance LIKE tah_file.tah04,
#         d_debit        LIKE abb_file.abb07,
#         d_credit       LIKE abb_file.abb07,
#         d_balance      LIKE abb_file.abb07,
#         ds_balance     LIKE abb_file.abb07,
#         d_dc,m_dc      LIKE zaa_file.zaa08,     #NO FUN-690009   VARCHAR(2)
#         m_debit        LIKE abb_file.abb07,
#         m_credit       LIKE abb_file.abb07,
#         m_balance      LIKE abb_file.abb07,
#         y_debit        LIKE abb_file.abb07,
#         y_credit       LIKE abb_file.abb07,
#         y_balance      LIKE abb_file.abb07,
#         y_dc,q_dc      LIKE zaa_file.zaa08,     #NO FUN-690009   VARCHAR(2)
#         x_dc           LIKE zaa_file.zaa08,     #NO FUN-690009   VARCHAR(2)
#         x_balance      LIKE abb_file.abb07,
#         l_pageno,l_cnt LIKE type_file.num5,       #NO FUN-690009   SMALLINT
#         l_mm           LIKE type_file.num5        #NO FUN-690009   SMALLINT
#  DEFINE l_last_sw      LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin   #FUN-580098
#         PAGE LENGTH g_page_line
#  ORDER BY sr.aag01,sr.s_month,sr.s_day,sr.abb01
#
#  FORMAT
#    PAGE HEADER
##No.FUN-680025--begin
##      SKIP 2 LINE
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      LET g_cn = g_cn + 1
#      LET g_pageno = g_pageno + 1
#      PRINT g_head CLIPPED,g_pageno USING "<<<"
##      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##      PRINT g_x[11] CLIPPED,sr.aag01 CLIPPED,g_x[12] CLIPPED,sr.aag02 CLIPPED,
##            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##      PRINT g_dash[1,g_len]
##      PRINT COLUMN 1,g_x[24] CLIPPED, COLUMN 11,g_x[37] CLIPPED,
##            COLUMN 29,g_x[38] CLIPPED,
##            COLUMN 69,g_x[25] CLIPPED,COLUMN 85,g_x[39] CLIPPED,
##            COLUMN 95,g_x[26] CLIPPED,COLUMN 107,g_x[40] CLIPPED
##      PRINT g_dash2[1,g_len]
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT g_x[11] CLIPPED,sr.aag01 CLIPPED,'  ';
#      #FUN-6C0012.....begin
#      IF tm.e = 'Y' THEN
#         PRINT g_x[24] CLIPPED,sr.aag13 CLIPPED
#      ELSE
#      #FUN-6C0012.....end
#         PRINT g_x[12] CLIPPED,sr.aag02 CLIPPED
#      END IF   #FUN-6C0012
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
##No.FUN-680025--end
#     LET l_last_sw = 'n'
# 
#    BEFORE GROUP OF sr.aag01
#      LET g_aag01 = sr.aag01
#      LET l_month = sr.s_month
#      LET l_mm = l_month - 1
#      OPEN curs_pageno USING l_mm,g_aag01
#      FETCH curs_pageno INTO g_pageno
#      IF STATUS = 100 THEN LET g_pageno = 0 END IF
#      IF g_cn = 1 THEN
#         LET g_pageno = g_pageno + 1
#      END IF
#      SKIP TO TOP OF PAGE
# 
#    BEFORE GROUP OF sr.s_month
#        SKIP TO TOP OF PAGE
#        #上期結轉
#        OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month
#        FETCH curs_tah INTO p_last_balance
#        IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF
#        IF sr.aag06 ='2' THEN
#           LET p_last_balance   = p_last_balance * -1
#        END IF
#        IF p_last_balance > 0 THEN
#           IF sr.aag06 ='2'
#              THEN LET q_dc = g_x[29]
#              ELSE LET q_dc = g_x[28]
#           END IF
#           LET q_last_balance = p_last_balance
#        ELSE
#           IF p_last_balance < 0 THEN
#              IF sr.aag06 ='2'
#                 THEN LET q_dc = g_x[28]
#                 ELSE LET q_dc = g_x[29]
#              END IF
#              LET q_last_balance = 0 - p_last_balance
#           ELSE
##No.FUN-680025--begin
##              LET q_dc = g_x[34]
#              LET q_dc = g_x[14] 
##No.FUN-680025--end
#              LET p_last_balance = 0
#              LET q_last_balance = 0
#           END IF
#        END IF
#        LET sr.s_dc = q_dc
#        LET p_balance = p_last_balance
##No.FUN-680025--begin
##        PRINT COLUMN 01,sr.s_month,g_x[36] CLIPPED,'01',        #LINE NO 9
##              COLUMN 29,g_x[27] CLIPPED,
##              COLUMN 95,q_dc CLIPPED,
##              COLUMN 100,cl_numfor(q_last_balance,15,t_azi04)   #No.CHI-6A0004
#        PRINT COLUMN g_c[31],sr.s_month,g_x[13] CLIPPED,'01',
#              COLUMN g_c[33],g_x[27] CLIPPED,
#              COLUMN G_c[41],q_dc CLIPPED,
#              COLUMN g_c[42],cl_numfor(q_last_balance,42,t_azi04) #No.CHI-6A0004   
#        PRINT g_dash2[1,g_len]
##No.FUN-680025--end
#
#    ON EVERY ROW
#       IF LINENO>=37 THEN SKIP TO TOP OF PAGE END IF
#       IF cl_null(sr.s_day) THEN
#          PRINT
#       ELSE
#          IF g_record >= 28 THEN
#             IF LINENO = 36 THEN
##No.FUN-680025--begin
##                PRINT COLUMN 29,g_x[21] CLIPPED,COLUMN 95,x_dc CLIPPED,
##                COLUMN 100,cl_numfor(x_balance,15,g_azi04)
##                PRINT g_dash[1,g_len]
##                SKIP TO TOP OF PAGE
##                PRINT COLUMN 29,g_x[22] CLIPPED,COLUMN 95,x_dc CLIPPED,
##                COLUMN 100,cl_numfor(x_balance,15,g_azi04)
#                PRINT COLUMN g_c[33],g_x[21] CLIPPED,                                                                                       
#                      COLUMN g_c[41],x_dc CLIPPED,
#                      COLUMN g_c[42],cl_numfor(x_balance,42,t_azi04)  #No.CHI-6A0004
#                PRINT g_dash[1,g_len]
#                SKIP TO TOP OF PAGE
#                PRINT COLUMN g_c[33],g_x[22] CLIPPED,                                                                               
#                      COLUMN g_c[41],x_dc CLIPPED,
#                      COLUMN g_c[42],cl_numfor(x_balance,42,t_azi04)  #No.CHI-6A0004
##No.FUN-680025--end
#             END IF
#          END IF
#
##No.FUN-680025--begin
##           PRINT COLUMN 01,sr.s_month,g_x[36] CLIPPED,sr.s_day;
##           PRINT COLUMN 11,sr.abb01 CLIPPED,                   #憑証號
##                 COLUMN 29,sr.abb04 CLIPPED;                   #摘要
#           PRINT COLUMN g_c[31],sr.s_month,g_x[13] CLIPPED,sr.s_day;                                                                       
#           PRINT COLUMN g_c[32],sr.abb01 CLIPPED,              #憑証號                                                                                        
#                 COLUMN g_c[33],sr.abb04 CLIPPED;              #摘要                                                                           
#          IF sr.abb06 ='1' THEN                              #借方
##             PRINT COLUMN 62,cl_numfor(sr.abb07,14,g_azi04);
##             PRINT COLUMN 78,' ';
#           PRINT COLUMN g_c[34],cl_numfor(sr.abb07,34,t_azi04);   #No.CHI-6A0004
##No.FUN-680025--end
#             IF sr.aag06 = '1' THEN
#                LET p_balance = p_balance + sr.abb07
#             ELSE
#                LET p_balance = p_balance - sr.abb07
#             END IF
#             IF p_balance < 0 THEN
#                LET sr.balance = 0-p_balance
#                IF sr.aag06 = '1'
#                   THEN LET sr.s_dc = g_x[29]
#                   ELSE LET sr.s_dc = g_x[28]
#                END IF
#             ELSE
#                IF p_balance > 0 THEN
#                   LET sr.balance = p_balance
#                   IF sr.aag06 = '1'
#                      THEN LET sr.s_dc = g_x[28]
#                      ELSE LET sr.s_dc = g_x[29]
#                   END IF
#                ELSE
#                   LET sr.balance = 0
#                   LET p_balance = 0
#                   LET sr.s_dc = g_x[34]
#                END IF
#             END IF
#          ELSE                               #貸方
##No.FUN-680025--begin
##             PRINT COLUMN 62,' ',COLUMN 78,cl_numfor(sr.abb07,14,g_azi04);
#             PRINT COLUMN g_c[35],cl_numfor(sr.abb07,35,t_azi04);   #No.CHI-6A0004
##No.FUN-680025--end
#             IF sr.aag06 = '1' THEN
#                LET p_balance = p_balance - sr.abb07
#             ELSE
#                LET p_balance = p_balance + sr.abb07
#             END IF
#             IF p_balance < 0 THEN
#                LET sr.balance = 0-p_balance
#                IF sr.aag06 = '1'
#                   THEN LET sr.s_dc = g_x[29]
#                   ELSE LET sr.s_dc = g_x[28]
#                END IF
#             ELSE
#                IF p_balance > 0 THEN
#                   LET sr.balance = p_balance
#                   IF sr.aag06 = '1'
#                      THEN LET sr.s_dc = g_x[28]
#                      ELSE LET sr.s_dc = g_x[29]
#                   END IF
#                ELSE
#                   LET p_balance = 0
#                   LET sr.balance = 0
#                   LET sr.s_dc = g_x[34]
#                END IF
#             END IF
#          END IF
##No.FUN-680025--begin
##          PRINT COLUMN 95,sr.s_dc CLIPPED,
##                COLUMN 100,cl_numfor(sr.balance,15,g_azi04)
#          PRINT COLUMN g_c[41],sr.s_dc CLIPPED,
#                COLUMN g_c[42],cl_numfor(sr.balance,42,t_azi04)   #No.CHI-6A0004
##No.FUN-680025--end
#       END IF
#        LET x_dc = sr.s_dc
#        LET x_balance = sr.balance
# 
#    AFTER GROUP OF sr.s_day
#       OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date
#       FETCH curs_tas INTO d_debit,d_credit
#       IF cl_null(d_debit) THEN LET d_debit = 0 END IF
#       IF cl_null(d_credit) THEN LET d_credit = 0 END IF
#       OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month
#       FETCH curs_tas2 INTO d_balance
#       IF cl_null(d_balance) THEN LET d_balance = 0 END IF
#       IF sr.aag06 = '2' THEN
#          LET d_balance = d_balance * -1
#       END IF
#       LET ds_balance = d_balance
#       IF ds_balance > 0 THEN
#          IF sr.aag06 = '2'
#             THEN LET d_dc = g_x[29]
#             ELSE LET d_dc = g_x[28]
#          END IF
#          LET ds_balance = ds_balance
#       ELSE
#         IF ds_balance < 0 THEN
#            IF sr.aag06 = '2'
#               THEN LET d_dc = g_x[28]
#               ELSE LET d_dc = g_x[29]
#            END IF
#            LET ds_balance = 0 - ds_balance
#         ELSE
#            LET d_dc = g_x[14]
#            LET ds_balance = 0
#         END IF
#       END IF
#       LET l_day = cl_days(tm.yyyy,sr.s_month)
#
#       PRINT g_dash2[1,g_len]
#
#       IF cl_null(sr.s_day) THEN
#            PRINT ' ';
#       ELSE
##No.FUN-680025--begin
##           PRINT COLUMN 01,sr.s_month,g_x[36] CLIPPED,sr.s_day;
#           PRINT COLUMN g_c[31],sr.s_month,g_x[13] CLIPPED,sr.s_day;
#       END IF
##           PRINT COLUMN 29,g_x[15] CLIPPED,
##                 COLUMN 62,cl_numfor(d_debit,14,g_azi05),
##                 COLUMN 78,cl_numfor(d_credit,14,g_azi05),
##                 COLUMN 95,d_dc CLIPPED,
##                 COLUMN 100,cl_numfor(ds_balance,15,g_azi05)
#           PRINT COLUMN g_c[33],g_x[15] CLIPPED,
#                 COLUMN g_c[34],cl_numfor(d_debit,34,t_azi05),   #No.CHI-6A0004
#                 COLUMN g_c[35],cl_numfor(d_credit,35,t_azi05),  #No.CHI-6A0004
#                 COLUMN g_c[41],d_dc CLIPPED,
#                 COLUMN g_c[42],cl_numfor(ds_balance,42,t_azi05) #No.CHI-6A0004
##No.FUN-680025--end
#      PRINT g_dash2[1,g_len]
# 
#    AFTER GROUP OF sr.s_month
#       SELECT COUNT(*) INTO l_cnt FROM tpg_file
#        WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01
#          AND tpg05='gglr311'
#       LET l_month = sr.s_month
#       LET g_aag01 = sr.aag01
#       IF l_cnt = 0 THEN
#          INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)
#                        VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr311')
#       ELSE
#          UPDATE tpg_file SET tpg04 = g_pageno
#           WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01
#             AND tpg05='gglr311'
#       END IF
#       OPEN curs_pageno USING l_month,g_aag01
#       FETCH curs_pageno INTO g_pageno
#       IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#       OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah2 INTO m_debit,m_credit
#       IF cl_null(m_debit) THEN LET m_debit = 0 END IF
#       IF cl_null(m_credit) THEN LET m_credit = 0 END IF
#       OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah3 INTO m_balance
#       IF cl_null(m_balance) THEN LET m_balance = 0 END IF
#       IF sr.aag06 = '2' THEN
#          LET m_balance = m_balance * -1
#       END IF
#       IF m_balance > 0 THEN
#          IF sr.aag06 = '2'
#             THEN LET m_dc = g_x[29]
#             ELSE LET m_dc = g_x[28]
#          END IF
#       ELSE
#          IF m_balance < 0 THEN
#             IF sr.aag06 = '2'
#                THEN LET m_dc = g_x[28]
#                ELSE LET m_dc = g_x[29]
#             END IF
#             LET m_balance = 0 - m_balance
#          ELSE
#             LET m_dc = g_x[14]
#             LET m_balance =0
#          END IF
#       END IF
#       LET l_day = cl_days(tm.yyyy,sr.s_month)
#
##No.FUN-680025--begin
##       PRINT COLUMN 1,sr.s_month[1,2],g_x[36] CLIPPED,l_day[1,2];
##       PRINT COLUMN 29,g_x[19] CLIPPED,
##             COLUMN 62,cl_numfor(m_debit,14,g_azi05) ,
##             COLUMN 78,cl_numfor(m_credit,14,g_azi05),
##             COLUMN 95,m_dc CLIPPED,
##             COLUMN 100,cl_numfor(m_balance,15,g_azi05)
#       PRINT COLUMN g_c[31],sr.s_month[1,2],g_x[13] CLIPPED,l_day[1,2];
#       PRINT COLUMN g_c[33],g_x[19] CLIPPED,
#             COLUMN g_c[34],cl_numfor(m_debit,34,t_azi05),     #No.CHI-6A0004
#             COLUMN g_c[35],cl_numfor(m_credit,35,t_azi05),    #No.CHI-6A0004
#             COLUMN g_c[41],m_dc CLIPPED,
#             COLUMN g_c[42],cl_numfor(m_balance,42,t_azi05)    #No.CHI-6A0004
##No.FUN-680025--end
#       PRINT g_dash2[1,g_len]
# 
#       OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah4 INTO y_debit,y_credit
#       IF cl_null(y_debit) THEN LET y_debit = 0 END IF
#       IF cl_null(y_credit) THEN LET y_credit = 0 END IF
#       OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah5 INTO y_balance
#       IF cl_null(y_balance) THEN LET y_balance = 0 END IF
#       IF sr.aag06 = '2' THEN
#          LET y_balance = y_balance * -1
#       END IF
#       IF y_balance > 0 THEN
#          IF sr.aag06 = '2'
#             THEN LET y_dc = g_x[29]
#             ELSE LET y_dc = g_x[28]
#          END IF
#       ELSE
#          IF y_balance < 0 THEN
#             IF sr.aag06 = '2'
#                THEN LET y_dc = g_x[28]
#                ELSE LET y_dc = g_x[29]
#             END IF
#             LET y_balance = 0 - y_balance
#          ELSE
#             LET y_dc = g_x[14]
#             LET y_balance = 0
#          END IF
#       END IF
#
##No.FUN-680025--begin
##       PRINT COLUMN 1,sr.s_month[1,2],g_x[36] CLIPPED,l_day[1,2],
##             COLUMN 29,g_x[20] CLIPPED,
##             COLUMN 62,cl_numfor(y_debit,14,g_azi05),
##             COLUMN 78,cl_numfor(y_credit,14,g_azi05),
##             COLUMN 95,y_dc CLIPPED,
##             COLUMN 100,cl_numfor(y_balance,15,g_azi05)
##       PRINT
#       PRINT COLUMN g_c[31],sr.s_month[1,2],g_x[13] CLIPPED,l_day[1,2],
#             COLUMN g_c[33],g_x[20] CLIPPED,
#             COLUMN g_c[34],cl_numfor(y_debit,34,t_azi05),   #No.CHI-6A0004                                                                       
#             COLUMN g_c[35],cl_numfor(y_credit,35,t_azi05),  #No.CHI-6A0004                                                                       
#             COLUMN g_c[41],y_dc CLIPPED,                                                                                           
#             COLUMN g_c[42],cl_numfor(y_balance,42,t_azi05)  #No.CHI-6A0004 
##No.FUN-680025--end
#
#   ON LAST ROW
#       PRINT g_dash[1,g_len] CLIPPED
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len] CLIPPED
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT
#
#REPORT gglr311_rep_f(sr)   #有外幣
#  DEFINE l_last_sw      LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
#  DEFINE  sr            RECORD
#                        s_date        LIKE type_file.dat,     #NO FUN-690009   DATE        #日期
#                        s_month       LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)     #月
#                        s_day         LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)     #日
#                        abb01         LIKE abb_file.abb01,    #憑証號
#                        abb04         LIKE abb_file.abb04,    #摘要
#                        s_kemu        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)               #對方科目
#                        abb25         LIKE abb_file.abb25,    #匯率
#                        abb07f        LIKE abb_file.abb07f,   #外幣金額
#                        abb07         LIKE abb_file.abb07,    #本幣金額
#                        s_dc          LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)      #借貸
#                        balancef      LIKE abb_file.abb07f,   #外幣余額
#                        balance       LIKE abb_file.abb07,    #本幣余額
#                        aag01         LIKE aag_file.aag01,
#                        aag02         LIKE aag_file.aag02,
#                        aag13         LIKE aag_file.aag13,    #FUN-6C0012
#                        aag06         LIKE aag_file.aag06,
#                        abb06         LIKE abb_file.abb06,
#                        aba00         LIKE aba_file.aba00,
#                        azi04         LIKE azi_file.azi04,
#                        azi05         LIKE azi_file.azi05
#                        END RECORD
#  DEFINE l_month,l_day                LIKE type_file.chr2,    #NO FUN-690009   VARCHAR(2)
#         p_balance,p_balance_f        LIKE tah_file.tah04,
#         p_last_balance               LIKE tah_file.tah04,
#         p_last_balance_f             LIKE tah_file.tah04,
#         q_last_balance               LIKE tah_file.tah04,
#         q_last_balance_f             LIKE tah_file.tah04,
#         d_debit,d_debit_f            LIKE abb_file.abb07,
#         d_credit,d_credit_f          LIKE abb_file.abb07,
#         d_balance,d_balance_f        LIKE abb_file.abb07,
#         ds_balance,ds_balance_f      LIKE abb_file.abb07,
#         d_dc,m_dc,y_dc,q_dc          LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(2)
#         m_debit,m_debit_f            LIKE abb_file.abb07,
#         m_credit,m_credit_f          LIKE abb_file.abb07,
#         m_balance,m_balance_f        LIKE abb_file.abb07,
#         y_debit,y_debit_f            LIKE abb_file.abb07,
#         y_credit,y_credit_f          LIKE abb_file.abb07,
#         y_balance,y_balance_f        LIKE abb_file.abb07,
#         x_balance,x_balancef         LIKE abb_file.abb07,
#         l_abb25                      LIKE abb_file.abb25,
#         x_dc                         LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(02)
#         l_pageno,l_cnt,l_mm          LIKE type_file.num5     #NO FUN-690009   SMALLINT
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line   #FUN-580098
#  ORDER BY sr.aag01,sr.s_month,sr.s_day,sr.abb01
#
#  FORMAT
#   PAGE HEADER
##No.FUN-680025--begin
##      SKIP 2 LINE
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      LET g_cn = g_cn + 1
#      LET g_pageno = g_pageno + 1
#      PRINT g_head CLIPPED,g_pageno USING "<<<"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##      PRINT g_x[11] CLIPPED,sr.aag01 CLIPPED,g_x[12] CLIPPED,sr.aag02 CLIPPED,
##            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##      PRINT g_dash[1,g_len]
##      PRINT COLUMN 1,g_x[24] CLIPPED, COLUMN 11,g_x[37] CLIPPED,
##            COLUMN 29,g_x[38] CLIPPED,
##            COLUMN 72,g_x[14] CLIPPED,
##            COLUMN 92,g_x[16] CLIPPED,COLUMN 108,g_x[17] CLIPPED,
##            COLUMN 124,g_x[31] CLIPPED,COLUMN 140,g_x[32] CLIPPED,
##            COLUMN 149,g_x[26] CLIPPED,COLUMN 161,g_x[18] CLIPPED,
##            COLUMN 176,g_x[33] CLIPPED
##      PRINT g_dash2[1,g_len]
#       PRINT g_x[11] CLIPPED,sr.aag01 CLIPPED,'  ';                                                                                  
#       #FUN-6C0012.....begin
#       IF tm.e = 'Y' THEN
#          PRINT g_x[24] CLIPPED,sr.aag13 CLIPPED
#       ELSE
#       #FUN-6C0012.....end
#          PRINT g_x[12] CLIPPED,sr.aag02 CLIPPED                
#       END IF   #FUN-6C0012                                                                        
#       PRINT g_dash[1,g_len]                                                                                                         
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#             g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]                                                                 
#       PRINT g_dash1 
##No.FUN-680025--end
#     LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.aag01
#      LET g_aag01 = sr.aag01
#      LET l_month = sr.s_month
#      LET l_mm = l_month - 1
#      OPEN curs_pageno USING l_mm,g_aag01
#      FETCH curs_pageno INTO g_pageno
#      IF STATUS = 100 THEN LET g_pageno = 0 END IF
#      IF g_cn = 1 THEN
#         LET g_pageno = g_pageno + 1
#      END IF
#      SKIP TO TOP OF PAGE
#
#    BEFORE GROUP OF sr.s_month
#      SKIP TO TOP OF PAGE
#      #上期結轉
#      OPEN curs_tah USING sr.aba00,sr.aag01,sr.s_month
#      FETCH curs_tah INTO p_last_balance,p_last_balance_f
#      IF cl_null(p_last_balance) THEN LET p_last_balance = 0 END IF
#      IF cl_null(p_last_balance_f) THEN LET p_last_balance_f = 0 END IF
#      IF sr.aag06 ='2' THEN
#         LET p_last_balance   = p_last_balance * -1
#         LET p_last_balance_f = p_last_balance_f * -1
#        END IF
#      IF p_last_balance > 0 THEN
#         IF sr.aag06 ='2'
#            THEN LET q_dc = g_x[29]
#            ELSE LET q_dc = g_x[28]
#         END IF
#         LET q_last_balance   = p_last_balance
#         LET q_last_balance_f = p_last_balance_f
#      ELSE
#         IF p_last_balance < 0 THEN
#            IF sr.aag06 ='2'
#               THEN LET q_dc = g_x[28]
#               ELSE LET q_dc = g_x[29]
#            END IF
#            LET q_last_balance   = 0 - p_last_balance
#            LET q_last_balance_f = 0 - p_last_balance_f
#         ELSE
#            LET q_dc = g_x[14]
#            LET p_last_balance   = 0
#            LET q_last_balance   = 0
#            LET p_last_balance_f = 0
#            LET q_last_balance_f = 0
#         END IF
#      END IF
#      LET sr.s_dc = q_dc
#      LET p_balance   = p_last_balance
#      LET p_balance_f = p_last_balance_f
##No.FUN-680025--begin 
##      PRINT COLUMN 01,sr.s_month,g_x[36] CLIPPED,'01',       #LINE NO 9
##            COLUMN 29,g_x[27] CLIPPED,
##            COLUMN 151,q_dc CLIPPED,
##            COLUMN 154,cl_numfor(q_last_balance_f,15,sr.azi04),
##            COLUMN 169,cl_numfor(q_last_balance,15,g_azi04)
#      PRINT COLUMN g_c[31],sr.s_month,g_x[13] CLIPPED,'01', 
#            COLUMN g_c[33],g_x[27] CLIPPED,
#            COLUMN g_c[41],q_dc CLIPPED,
#            COLUMN g_c[43],q_last_balance_f USING "#,###,###,###,##&.&&",
#            COLUMN g_c[44],q_last_balance USING "#,###,###,###,##&.&&"
##No.FUN-680025--end 
#      PRINT g_dash2[1,g_len]
#
#    ON EVERY ROW
#      LET l_abb25 = sr.abb25
#      IF LINENO>=37 THEN
#         SKIP TO TOP OF PAGE
#      END IF
#      IF cl_null(sr.s_day) THEN
#         PRINT
#      ELSE
#         IF g_record >= 28 THEN
#            IF LINENO = 36 THEN
##No.FUN-680025--begin 
##               PRINT COLUMN 29 ,g_x[21] CLIPPED, COLUMN 151,x_dc CLIPPED,
##               COLUMN 154,cl_numfor(x_balancef,15,sr.azi04),
##               COLUMN 169,cl_numfor(x_balance,15,g_azi04)
##               PRINT g_dash[1,g_len]
##               SKIP TO TOP OF PAGE
##               PRINT COLUMN 29 ,g_x[22] CLIPPED, COLUMN 151,x_dc CLIPPED,
##               COLUMN 154,cl_numfor(x_balancef,15,sr.azi04),
##               COLUMN 169,cl_numfor(x_balance,15,g_azi04)
#               PRINT COLUMN g_c[33],g_x[21] CLIPPED,
#                     COLUMN g_c[41],x_dc CLIPPED,
#                     COLUMN g_c[43],x_balancef USING "#,###,###,###,##&.&&",
#                     COLUMN g_c[44],x_balance USING "#,###,###,###,##&.&&"
#               PRINT g_dash[1,g_len]                                                                                               
#               SKIP TO TOP OF PAGE
#               PRINT COLUMN g_c[33],g_x[22] CLIPPED,                                                                                
#                     COLUMN g_c[41],x_dc CLIPPED,                                                                                   
#                     COLUMN g_c[43],x_balancef USING "#,###,###,###,##&.&&",                                                              
#                     COLUMN g_c[44],x_balance USING "#,###,###,###,##&.&&"
##No.FUN-680025--end 
#            END IF
#         END IF
##No.FUN-680025--begin 
##         PRINT COLUMN 01,sr.s_month,g_x[36] CLIPPED,sr.s_day;
##         PRINT COLUMN 11,sr.abb01 CLIPPED,                #憑証號
##               COLUMN 29,sr.abb04 CLIPPED,                #摘要
##               COLUMN 62,l_abb25 CLIPPED;                 #匯率
#         PRINT COLUMN g_c[31],sr.s_month,g_x[13] CLIPPED,sr.s_day;
#         PRINT COLUMN g_c[32],sr.abb01 CLIPPED,                                #憑証號
#               COLUMN g_c[33],sr.abb04 CLIPPED,                                #摘要
#               COLUMN g_c[36],l_abb25 CLIPPED USING "########&.&&&&&#####";    #匯率       
#         IF sr.abb06 ='1' THEN                             #借方
##            PRINT COLUMN 85,cl_numfor(sr.abb07f,15,sr.azi04);
##            PRINT COLUMN 101,cl_numfor(sr.abb07,15,g_azi04);
##            PRINT COLUMN 117,' ';
##            PRINT COLUMN 133,' ';
#            PRINT COLUMN g_c[37],sr.abb07f USING "#,###,###,###,##&.&&"; 
#            PRINT COLUMN g_c[38],sr.abb07 USING "#,###,###,###,##&.&&"; 
#            PRINT COLUMN g_c[39],' '; 
#            PRINT COLUMN g_c[40],' '; 
##No.FUN-680025--end 
#            IF sr.aag06 = '1' THEN
#               LET p_balance_f = p_balance_f + sr.abb07f
#               LET p_balance = p_balance + sr.abb07
#            ELSE
#               LET p_balance_f = p_balance_f - sr.abb07f
#               LET p_balance = p_balance - sr.abb07
#            END IF
#            IF p_balance < 0 THEN
#               LET sr.balancef = 0-p_balance_f
#               LET sr.balance = 0-p_balance
#               IF sr.aag06 = '1'
#                  THEN LET sr.s_dc = g_x[29]
#                  ELSE LET sr.s_dc = g_x[28]
#               END IF
#            ELSE
#               IF p_balance > 0 THEN
#                  LET sr.balancef= p_balance_f
#                  LET sr.balance = p_balance
#                  IF sr.aag06 = '1'
#                     THEN LET sr.s_dc = g_x[28]
#                     ELSE LET sr.s_dc = g_x[29]
#                  END IF
#               ELSE
#                  LET sr.balancef= 0
#                  LET sr.balance = 0
#                  LET sr.s_dc = g_x[34]
#               END IF
#            END IF
#         ELSE                               #貸方
##No.FUN-680025--begin
##            PRINT COLUMN 85,' ',
##                  COLUMN 117,cl_numfor(sr.abb07f,15,sr.azi04),
##                  COLUMN 133,cl_numfor(sr.abb07,15,g_azi04);
##            PRINT COLUMN g_c[36],' ',
#            PRINT COLUMN g_c[39],sr.abb07f USING "#,###,###,###,##&.&&",
#                  COLUMN g_c[40],sr.abb07 USING "#,###,###,###,##&.&&";
##No.FUN-680025--end
#            IF sr.aag06 = '1' THEN
#               LET p_balance_f = p_balance_f - sr.abb07f
#               LET p_balance = p_balance - sr.abb07
#            ELSE
#               LET p_balance_f = p_balance_f + sr.abb07f
#               LET p_balance = p_balance + sr.abb07
#            END IF
#            IF p_balance < 0 THEN
#               LET sr.balancef= 0-p_balance_f
#               LET sr.balance = 0-p_balance
#               IF sr.aag06 = '1'
#                  THEN LET sr.s_dc = g_x[29]
#                  ELSE LET sr.s_dc = g_x[28]
#               END IF
#            ELSE
#               IF p_balance > 0 THEN
#                  LET sr.balancef = p_balance_f
#                  LET sr.balance = p_balance
#                  IF sr.aag06 = '1'
#                     THEN LET sr.s_dc = g_x[28]
#                     ELSE LET sr.s_dc = g_x[29]
#                  END IF
#               ELSE
#                  LET sr.balancef = 0
#                  LET sr.balance = 0
#                  LET sr.s_dc = g_x[34]
#               END IF
#            END IF
#         END IF
##No.FUN-680025--begin
##         PRINT COLUMN 151,sr.s_dc,
##               COLUMN 154,cl_numfor(sr.balancef,15,sr.azi04),
##               COLUMN 169,cl_numfor(sr.balance,15,g_azi04)
#         PRINT COLUMN g_c[41],sr.s_dc,
#               COLUMN g_c[43],sr.balancef USING "#,###,###,###,##&.&&",   
#               COLUMN g_c[44],sr.balancef USING "#,###,###,###,##&.&&"   
##No.FUN-680025--end
#      END IF
#      LET x_dc = sr.s_dc
#      LET x_balancef = sr.balancef
#      LET x_balance = sr.balance
# 
#    AFTER GROUP OF sr.s_day
#      OPEN curs_tas USING sr.aba00,sr.aag01,sr.s_date
#      FETCH curs_tas INTO d_debit,d_credit,d_debit_f,d_credit_f
#      IF cl_null(d_debit) THEN LET d_debit = 0 END IF
#      IF cl_null(d_credit) THEN LET d_credit = 0 END IF
#      IF cl_null(d_debit_f) THEN LET d_debit_f = 0 END IF
#      IF cl_null(d_credit_f) THEN LET d_credit_f = 0 END IF
#      OPEN curs_tas2 USING sr.aba00,sr.aag01,sr.s_date,sr.s_month
#      FETCH curs_tas2 INTO d_balance,d_balance_f
#      IF cl_null(d_balance) THEN LET d_balance = 0 END IF
#      IF cl_null(d_balance_f) THEN LET d_balance_f = 0 END IF
#      IF sr.aag06 = '2' THEN
#         LET d_balance   = d_balance   * -1
#         LET d_balance_f = d_balance_f * -1
#      END IF
#      LET ds_balance = d_balance
#      LET ds_balance_f = d_balance_f
#      IF ds_balance > 0 THEN
#         IF sr.aag06 = '2'
#            THEN LET d_dc = g_x[29]
#            ELSE LET d_dc = g_x[28]
#         END IF
#         LET ds_balance = ds_balance
#         LET ds_balance_f = ds_balance_f
#      ELSE
#         IF ds_balance < 0 THEN
#            IF sr.aag06 = '2'
#               THEN LET d_dc = g_x[28]
#               ELSE LET d_dc = g_x[29]
#            END IF
#            LET ds_balance = 0 - ds_balance
#            LET ds_balance_f = 0 - ds_balance_f
#         ELSE
#            LET d_dc = g_x[14]
#            LET ds_balance = 0
#            LET ds_balance_f = 0
#         END IF
#      END IF
#      LET l_day = cl_days(tm.yyyy,sr.s_month)
#      PRINT g_dash2[1,g_len]        
#      IF cl_null(sr.s_day)  THEN
#         PRINT    ' ';
#      ELSE
##No.FUN-680025--begin
##         PRINT COLUMN 1,sr.s_month[1,2],g_x[36] CLIPPED,sr.s_day[1,2];
#         PRINT COLUMN g_c[31],sr.s_month[1,2],g_x[13] CLIPPED,sr.s_day[1,2];
#      END IF
##         PRINT COLUMN  29,g_x[15] CLIPPED,
##               COLUMN  85,cl_numfor(d_debit_f,15,sr.azi05),
##               COLUMN 101,cl_numfor(d_debit,15,g_azi05),
##               COLUMN 117,cl_numfor(d_credit_f,15,sr.azi05),
##               COLUMN 133,cl_numfor(d_credit,15,g_azi05),
##               COLUMN 151,d_dc CLIPPED,
##               COLUMN 154,cl_numfor(ds_balance_f,15,sr.azi05),
##               COLUMN 169,cl_numfor(ds_balance,15,g_azi05)
#         PRINT COLUMN g_c[33],g_x[15] CLIPPED,
#               COLUMN g_c[37],d_debit_f USING "#,###,###,###,##&.&&",
#               COLUMN g_c[38],d_debit USING "#,###,###,###,##&.&&",
#               COLUMN g_c[39],d_credit_f USING "#,###,###,###,##&.&&",
#               COLUMN g_c[40],d_credit USING "#,###,###,###,##&.&&",
#               COLUMN g_c[41],d_dc CLIPPED,
#               COLUMN g_c[43],ds_balance_f USING "#,###,###,###,##&.&&",
#               COLUMN g_c[44],ds_balance USING "#,###,###,###,##&.&&"
##No.FUN-680025--end
# 
#    AFTER GROUP OF sr.s_month
#       SELECT COUNT(*) INTO l_cnt FROM tpg_file
#        WHERE tpg01=tm.yyyy AND tpg02=sr.s_month AND tpg03=sr.aag01
#          AND tpg05='gglr311'
#       LET l_month = sr.s_month
#       LET g_aag01 = sr.aag01
#       IF l_cnt = 0 THEN
#          INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)
#                        VALUES(tm.yyyy,l_month,g_aag01,g_pageno,'gglr311')
#       ELSE
#          UPDATE tpg_file SET tpg04 = g_pageno
#           WHERE tpg01=tm.yyyy AND tpg02=l_month AND tpg03=g_aag01
#             AND tpg05='gglr311'
#       END IF
#       OPEN curs_pageno USING l_month,g_aag01
#       FETCH curs_pageno INTO g_pageno
#       IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#       OPEN curs_tah2 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah2 INTO m_debit,m_credit,m_debit_f,m_credit_f
#       IF cl_null(m_debit) THEN LET m_debit = 0 END IF
#       IF cl_null(m_credit) THEN LET m_credit = 0 END IF
#       IF cl_null(m_debit_f) THEN LET m_debit_f = 0 END IF
#       IF cl_null(m_credit_f) THEN LET m_credit_f = 0 END IF
#       OPEN curs_tah3 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah3 INTO m_balance,m_balance_f
#       IF cl_null(m_balance) THEN LET m_balance = 0 END IF
#       IF cl_null(m_balance_f) THEN LET m_balance_f = 0 END IF
#       IF sr.aag06 = '2' THEN
#          LET m_balance   = m_balance   * -1
#          LET m_balance_f = m_balance_f * -1
#       END IF
#       IF m_balance > 0 THEN
#          IF sr.aag06 = '2'
#             THEN LET m_dc = g_x[29]
#             ELSE LET m_dc = g_x[28]
#          END IF
#       ELSE
#          IF m_balance < 0 THEN
#             IF sr.aag06 = '2'
#                THEN LET m_dc = g_x[28]
#                ELSE LET m_dc = g_x[29]
#             END IF
#             LET m_balance = 0 - m_balance
#             LET m_balance_f = 0 - m_balance_f
#          ELSE
#             LET m_dc = g_x[14]
#             LET m_balance = 0
#             LET m_balance_f = 0
#          END IF
#       END IF
#       PRINT g_dash2[1,g_len]
##No.FUN-680025--begin
##       PRINT COLUMN  1,sr.s_month[1,2],g_x[36] CLIPPED,l_day[1,2];
##       PRINT COLUMN  29,g_x[19] CLIPPED,
##             COLUMN  85,cl_numfor(m_debit_f,15,sr.azi05),
##             COLUMN 101,cl_numfor(m_debit,15,g_azi05),
##             COLUMN 117,cl_numfor(m_credit_f,15,sr.azi05),
##             COLUMN 133,cl_numfor(m_credit,15,g_azi05),
##             COLUMN 151,m_dc CLIPPED,
##             COLUMN 154,cl_numfor(m_balance_f,15,sr.azi05),
##             COLUMN 169,cl_numfor(m_balance,15,g_azi05)
#       PRINT COLUMN g_c[31],sr.s_month[1,2],g_x[13] CLIPPED,l_day[1,2];
#       PRINT COLUMN g_c[33],g_x[19] CLIPPED,
#             COLUMN g_c[37],m_debit_f USING "#,###,###,###,##&.&&",
#             COLUMN g_c[38],m_debit USING "#,###,###,###,##&.&&",
#             COLUMN g_c[39],m_credit_f USING "#,###,###,###,##&.&&",
#             COLUMN g_c[40],m_credit USING "#,###,###,###,##&.&&",
#             COLUMN g_c[41],m_dc CLIPPED,
#             COLUMN g_c[43],m_balance_f USING "#,###,###,###,##&.&&",   
#             COLUMN g_c[44],m_balance USING "#,###,###,###,##&.&&"   
##No.FUN-680025--end
#       PRINT g_dash2[1,g_len]
#       OPEN curs_tah4 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah4 INTO y_debit,y_credit,y_debit_f,y_credit_f
#       IF cl_null(y_debit) THEN LET y_debit = 0 END IF
#       IF cl_null(y_credit) THEN LET y_credit = 0 END IF
#       IF cl_null(y_debit_f) THEN LET y_debit_f = 0 END IF
#       IF cl_null(y_credit_f) THEN LET y_credit_f = 0 END IF
#       OPEN curs_tah5 USING sr.aba00,sr.aag01,sr.s_month
#       FETCH curs_tah5 INTO y_balance,y_balance_f
#       IF cl_null(y_balance) THEN LET y_balance = 0 END IF
#       IF cl_null(y_balance_f) THEN LET y_balance_f = 0 END IF
#       IF sr.aag06 = '2' THEN
#          LET y_balance   = y_balance   * -1
#          LET y_balance_f = y_balance_f * -1
#       END IF
#       IF y_balance > 0 THEN
#          IF sr.aag06 = '2'
#             THEN LET m_dc = g_x[29]
#             ELSE LET m_dc = g_x[28]
#          END IF
#       ELSE
#          IF y_balance < 0 THEN
#             IF sr.aag06 = '2'
#                THEN LET m_dc = g_x[28]
#                ELSE LET m_dc = g_x[29]
#             END IF
#             LET y_balance = 0 - y_balance
#             LET y_balance_f = 0 - y_balance_f
#          ELSE
#             LET m_dc = g_x[14]
#             LET y_balance=0
#             LET y_balance_f=0
#          END IF
#       END IF
##No.FUN-680025--begin     
##       PRINT COLUMN  1,sr.s_month[1,2],g_x[36] CLIPPED,l_day[1,2];
##       PRINT COLUMN  29,g_x[20] CLIPPED,
##             COLUMN  85,cl_numfor(y_debit_f,15,sr.azi05),
##             COLUMN 101,cl_numfor(y_debit,15,g_azi05),
##             COLUMN 117,cl_numfor(y_credit_f,15,sr.azi05),
##             COLUMN 133,cl_numfor(y_credit,15,g_azi05),
##             COLUMN 151,m_dc CLIPPED,
##             COLUMN 154,cl_numfor(y_balance_f,15,sr.azi05),
##             COLUMN 169,cl_numfor(y_balance,15,g_azi05)
#       PRINT COLUMN g_c[31],sr.s_month[1,2],g_x[13] CLIPPED,l_day[1,2];
#       PRINT COLUMN g_c[33],g_x[20] CLIPPED, 
#             COLUMN g_c[37],y_debit_f USING "#,###,###,###,##&.&&",
#             COLUMN g_c[38],y_debit USING "#,###,###,###,##&.&&",
#             COLUMN g_c[39],y_credit_f USING "#,###,###,###,##&.&&",
#             COLUMN g_c[40],y_credit USING "#,###,###,###,##&.&&",
#             COLUMN g_c[41],m_dc CLIPPED,
#             COLUMN g_c[43],y_balance_f USING "#,###,###,###,##&.&&",
#             COLUMN g_c[44],y_balance USING "#,###,###,###,##&.&&"
##No.FUN-680025--end     
#
#   ON LAST ROW
#       PRINT g_dash[1,g_len] CLIPPED
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len] CLIPPED
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780031  --End  
 
FUNCTION r311_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
 
   CALL cl_set_comp_entry("bb",TRUE)
 
END FUNCTION
 
FUNCTION r311_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
 
   IF tm.p = 'N' THEN
      CALL cl_set_comp_entry("bb",FALSE)
   END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <001> #
