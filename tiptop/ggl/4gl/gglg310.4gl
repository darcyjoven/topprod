# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: gglg310.4gl
# Descriptions...: 總分類帳列印-套表
# Input parameter:
# Return code....:
# Date & Author..: 2003/04/04 By Winny Wu
# Vtcp printing config : 1*23*24 --> 42  lines
# 立信帳冊名稱...: TW501 余額匯總表（代總帳）
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬aag02
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.FUN-740055 07/04/12 By hongmei 會計科目加帳套
# Modify.........: NO.FUN-770061 08/03/05 By zhaijie 報表輸出改為Crystal Report
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-860252 09/02/17 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/18 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No.FUN-B50018 11/06/02 By xumm CR轉GRW
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改 
# Modify.........: No.FUN-C10036 12/01/11 By qirl 程式規範修改

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(500)     # Where condition
              yy      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
              m1      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
              m2      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
              bookno  LIKE aaa_file.aaa01,       #No.FUN-740055
              h       LIKE type_file.chr1,       #MOD-860252
              e       LIKE type_file.chr1,       #FUN-6C0012
              more    LIKE type_file.chr1        #NO FUN-690009   VARCHAR(01)
	  END RECORD,
	  g_aaa03  LIKE aaa_file.aaa03
DEFINE   g_i          LIKE type_file.num5        #NO FUN-690009    SMALLINT   #count/index for any purpose
DEFINE   g_sql        STRING                     #NO FUN-770061                                                                     
DEFINE   g_str        STRING                     #NO FUN-770061                                                                     
DEFINE   l_table      STRING                     #NO FUN-770061   
###GENGRE###START
TYPE sr1_t RECORD
    tah01 LIKE tah_file.tah01,
    mm LIKE type_file.num5,
    aag02 LIKE aag_file.aag02,
    aag06 LIKE aag_file.aag06,
    aag07 LIKE aag_file.aag07,
    aag13 LIKE aag_file.aag13,
    open_amt LIKE tah_file.tah10,
    open_amtf LIKE tah_file.tah10,
    d_amt LIKE tah_file.tah10,
    d_amtf LIKE tah_file.tah10,
    c_amt LIKE tah_file.tah10,
    c_amtf LIKE tah_file.tah10,
    end_amt LIKE tah_file.tah10,
    end_amtf LIKE tah_file.tah10,
    chr LIKE type_file.chr1
    ,l_d_amt_l LIKE tah_file.tah10,   #FUN-B50018  add
    l_d_amtf_l LIKE tah_file.tah10,   #FUN-B50018  add
    l_c_amt_l LIKE tah_file.tah10,    #FUN-B50018  add
    l_c_amtf_l LIKE tah_file.tah10
   ,l_o_amtf  LIKE tah_file.tah10
   ,l_o_amt   LIKE tah_file.tah10
END RECORD
###GENGRE###END

MAIN
    OPTIONS
 INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
#NO.690009------------------begin----------------------
#    DROP TABLE g310_tmp
#    CREATE TEMP TABLE g310_tmp
#     (tah01     VARCHAR(24),
#      mm        SMALLINT,
#      open_amt  DEC(20,6),
#      open_amtf DEC(20,6),
#      d_amt     DEC(20,6),
#      d_amtf    DEC(20,6),
#      c_amt     DEC(20,6),
#      c_amtf    DEC(20,6))
#NO.690009-------------------END------------------------
#NO.FUN-770061-----------------start------------                                                                                    
    LET g_sql = "tah01.tah_file.tah01,",                                                                                            
                "mm.type_file.num5,",                                                                                               
                "aag02.aag_file.aag02,",                                                                                            
                "aag06.aag_file.aag06,",                                                                                            
                "aag07.aag_file.aag07,",                                                                                            
                "aag13.aag_file.aag13,",                                                                                            
                "open_amt.tah_file.tah10,",                                                                                         
                "open_amtf.tah_file.tah10,",                                                                                        
                "d_amt.tah_file.tah10,",                                                                                            
                "d_amtf.tah_file.tah10,",                                                                                           
                "c_amt.tah_file.tah10,",                                                                                            
                "c_amtf.tah_file.tah10,",                                                                                           
                "end_amt.tah_file.tah10,",                                                                                          
                "end_amtf.tah_file.tah10,",                   
                "chr.type_file.chr1,",           #FUN-B50018 add 
                "l_d_amt_l.tah_file.tah10,",     #FUN-B50018 add
                "l_d_amtf_l.tah_file.tah10,",    #FUN-B50018 add
                "l_c_amt_l.tah_file.tah10,",     #FUN-B50018 add
                "l_c_amtf_l.tah_file.tah10,",    #FUN-B50018 add
                "l_o_amtf.tah_file.tah10,",       #FUN-B50018 add
                "l_o_amt.tah_file.tah10"        #FUN-B50018 add
                                                                                                          
    LET l_table = cl_prt_temptable('gglg310',g_sql) CLIPPED                                                                         
    IF  l_table = -1 THEN EXIT PROGRAM END IF        
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                    
                "        ?,?,?,?,?, ?,?,?,?,?,?)"              #FUN-B50018 add 4?                                                                                  
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#NO.FUN-770061--------------end------------    
#NO.690009------------------begin----------------------                                                                             
    DROP TABLE g310_tmp               
    CREATE TEMP TABLE g310_tmp(      
      tah01     LIKE tah_file.tah01,                                           
      mm        LIKE type_file.num5,                                                                                    
      open_amt  LIKE type_file.num20_6,                                                                                             
      open_amtf LIKE type_file.num20_6,                                                                                             
      d_amt     LIKE type_file.num20_6,                                                                                                 
      d_amtf    LIKE type_file.num20_6,                                                                                                
      c_amt     LIKE type_file.num20_6,                                                                                    
      c_amtf    LIKE type_file.num20_6)                                                                                                         
#NO.690009-------------------END------------------------
    IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF    
    LET g_trace = 'N'                     # default trace off
#   LET tm.bookno = ' '                   #No.FUN-740055
    LET tm.bookno = ARG_VAL(1)            #No.FUN-740055  
    LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
    LET g_towhom = ARG_VAL(3)
    LET g_rlang  = ARG_VAL(4)
    LET g_bgjob  = ARG_VAL(5)
    LET g_prtway = ARG_VAL(6)
    LET g_copies = ARG_VAL(7)
    LET tm.wc    = ARG_VAL(8)
    LET tm.yy    = ARG_VAL(9)
    LET tm.m1    = ARG_VAL(10)
    LET tm.m2    = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
    IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
#      LET tm.bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別  #No.FUN-740055
       LET tm.bookno =g_aza.aza81    #No.FUN-740055
    END IF
    #No.FUN-740055 ---Begin
    IF cl_null(tm.bookno) THEN LET tm.bookno=g_aza.aza81 END IF                                                                      
    #使用預設帳別之幣別                                                                                                              
    SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno
    #No.FUN-740055 ---End

    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
 
    IF cl_null(g_bgjob) OR g_bgjob = 'N'       # If background job sw is off
       THEN CALL gglg310_tm()                  # Input print condition
       ELSE CALL gglg310()                     # Read data and create out-file
    END IF

    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
    CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
END MAIN
 
FUNCTION gglg310_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE p_row,p_col 	LIKE type_file.num5,       #NO FUN-690009   SMALLINT
	   l_cmd	LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
 
    CALL s_dsmark(tm.bookno)     #No.FUN-740055
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW gglg310_w AT p_row,p_col
        WITH FORM "ggl/42f/gglg310"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,tm.bookno)    #No.FUN-740055
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL  
    LET tm.bookno = g_aza.aza81     #FUN-B20010   
    SELECT aaa03,aaa04,aaa05 INTO g_aaa03,tm.yy,tm.m1
      FROM aaa_file WHERE aaa01 = tm.bookno   #No.FUN-740055
    IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF    
    LET tm.m2    = tm.m1
    LET tm.e     = 'N'  #FUn-6C0012
    LET tm.h     = 'Y'  #MOD-860252
    LET tm.more  = 'N'
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
               CALL g310_bookno(tm.bookno)                                                                                          
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(tm.bookno,g_errno,0)                                                                                  
                  LET tm.bookno = g_aza.aza81                                                                                       
                  DISPLAY BY NAME tm.bookno                                                                                         
                  NEXT FIELD bookno                                                                                                 
               END IF                                                                                                               
            END IF
 
    END INPUT
    #No.FUN-B20010  --End
    
    #DELETE FROM g310_tmp
    CONSTRUCT BY NAME tm.wc ON tah01
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
#  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
#    IF INT_FLAG THEN
#	LET INT_FLAG = 0 CLOSE WINDOW gglg310_w EXIT PROGRAM
#    END IF
#    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    #INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.bookno,tm.h,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012  #No.FUN-740055  #No.MOD-860252 add tm.h #FUN-B20010 mark
#No.FUN-B20010  --Mark End
    INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.h,tm.e,tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 去掉tm.bookno 
    
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      	AFTER FIELD yy
      	    IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      	AFTER FIELD m1
      	    IF cl_null(tm.m1) OR tm.m1 <=0 OR tm.m1 > 13 THEN
                     NEXT FIELD m1
                  END IF
      	AFTER FIELD m2
      	    IF cl_null(tm.m2) OR tm.m2 <=0 OR tm.m2 > 13 THEN
                     NEXT FIELD m2
                  END IF
                  IF tm.m2 < tm.m1 THEN NEXT FIELD m2 END IF
        #No.FUN-B20010  --Mark Begin
        #No.FUN-740055 ---Begin
        #AFTER FIELD bookno                                                                                                         
        #    IF NOT cl_null(tm.bookno) THEN                                                                                          
        #       CALL g310_bookno(tm.bookno)                                                                                          
        #       IF NOT cl_null(g_errno) THEN                                                                                         
        #          CALL cl_err(tm.bookno,g_errno,0)                                                                                  
        #          LET tm.bookno = g_aza.aza81                                                                                       
        #          DISPLAY BY NAME tm.bookno                                                                                         
        #          NEXT FIELD bookno                                                                                                 
        #       END IF                                                                                                               
        #    END IF
        #No.FUN-740055 ---End
        #No.FUN-B20010  --Mark End
        AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

#No.FUN-B20010  --Mark Begin
        #No.FUN-740055 ---Begin
#       ON ACTION CONTROLP                                                                                                         
#           CASE                                                                                                                    
#              WHEN INFIELD(bookno)                                                                                                 
#                 CALL cl_init_qry_var()                                                                                            
#                 LET g_qryparam.form ="q_aaa"                                                                                      
#                 LET g_qryparam.default1 = tm.bookno                                                                               
#                 CALL cl_create_qry() RETURNING tm.bookno                                                                          
#                 DISPLAY BY NAME tm.bookno                                                                                         
#                 NEXT FIELD bookno                                                                                                 
#           END CASE
        #No.FUN-740055 ---End

#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()	# Command execution
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
# 
##--NO.MOD-860078 start---
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
#--NO.MOD-860078 end------- 
#No.FUN-B20010  --Mark End
    END INPUT
    ON ACTION CONTROLP                                                                                                         
            CASE                                                                                                                    
               WHEN INFIELD(bookno)                                                                                                 
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_aaa"                                                                                      
                  LET g_qryparam.default1 = tm.bookno                                                                               
                  CALL cl_create_qry() RETURNING tm.bookno                                                                          
                  DISPLAY BY NAME tm.bookno                                                                                         
                  NEXT FIELD bookno  
               WHEN INFIELD(tah01)                                             
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.state= "c"                                     
                  LET g_qryparam.form = "q_aag"   
                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  DISPLAY g_qryparam.multiret TO tah01                          
                  NEXT FIELD tah01                                                                                                
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
        CLOSE WINDOW gglg310_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM
      END IF
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      #No.FUN-B20010  --End
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='gglg310'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglg310','9031',1)   
       ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'",          #No.FUN-740055
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.yy    CLIPPED,"'",
                         " '",tm.m1    CLIPPED,"'",
                         " '",tm.m2    CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          IF g_trace = 'Y' THEN
             ERROR l_cmd
          END IF
          CALL cl_cmdat('gglg310',g_time,l_cmd) # Execute cmd at later time
       END IF
       CLOSE WINDOW gglg310_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add 
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglg310()
    ERROR ""
  END WHILE
  CLOSE WINDOW gglg310_w
END FUNCTION
 
#No.FUN-740055 ---Begin
FUNCTION g310_bookno(p_bookno)                                                                                                      
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
 
FUNCTION gglg310()
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0097
DEFINE     l_name	LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)
	   l_sql	LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
           l_m1,l_m2    LIKE type_file.num5,       #NO FUN-690009   SMALLINT
           l_i,l_mm     LIKE type_file.num5,       #NO FUN-690009   SMALLINT
	   sr           RECORD
                        tah01     LIKE tah_file.tah01,
                        mm        LIKE type_file.num5,       #NO FUN-690009   SMALLINT
                        aag02     LIKE aag_file.aag02,
                        aag06     LIKE aag_file.aag06,
                        aag07     LIKE aag_file.aag07,
                        aag13     LIKE aag_file.aag13,  #FUN-6C0012
                        open_amt  LIKE tah_file.tah10,
                        open_amtf LIKE tah_file.tah10,
                        d_amt     LIKE tah_file.tah10,
                        d_amtf    LIKE tah_file.tah10,
                        c_amt     LIKE tah_file.tah10,
                        c_amtf    LIKE tah_file.tah10,
                        end_amt   LIKE tah_file.tah10,
                        end_amtf  LIKE tah_file.tah10,
                        chr       LIKE type_file.chr1        #NO FUN-690009   VARCHAR(01)
                        ,l_d_amt_l LIKE tah_file.tah10,       #FUN-B50018 add
                        l_d_amtf_l LIKE tah_file.tah10,       #FUN-B50018 add
                        l_c_amt_l  LIKE tah_file.tah10,       #FUN-B50018 add
                        l_c_amtf_l LIKE tah_file.tah10       
                       ,l_o_amtf   LIKE tah_file.tah10        #FUN-B50018 add
                       ,l_o_amt    LIKE tah_file.tah10        #FUN-B50018 add
	                END RECORD,
	   sr2          RECORD
                        tah01     LIKE tah_file.tah01,
                        mm        LIKE tah_file.tah03,
                        aag06     LIKE aag_file.aag06,
                        d_amt     LIKE tah_file.tah04,
                        d_amtf    LIKE tah_file.tah05,
                        c_amt     LIKE tah_file.tah09,
                        c_amtf    LIKE tah_file.tah10,
                        open_amt  LIKE tah_file.tah10,
                        open_amtf LIKE tah_file.tah10
	                END RECORD
     CALL cl_del_data(l_table)                             #NO.FUN-770061
     #No.FUN-B80096--mark--Begin---  
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.bookno AND aaf02 = g_lang  AND aaf01 = tm.bookno    #No.FUN-740055
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglg310'
    #TQC-650055...............begin
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #TQC-650055...............end
 
#     SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file      #No.CHI-6A0004
#     WHERE azi01 = g_aza.aza17                                  #No.CHI-6A0004
 
     #當期異動
     LET l_sql = " SELECT tah01,tah03,aag06,",
 		 "        SUM(tah04),SUM(tah09),SUM(tah05),SUM(tah10),0,0",
		 "   FROM tah_file,aag_file ",
		 "  WHERE ",tm.wc CLIPPED,
		 "    AND tah00 = '",tm.bookno,"'",    #No.FUN-740055
		 "    AND tah02 = ",tm.yy,
    	         "    AND tah03 BETWEEN ",tm.m1," AND ",tm.m2,
		 "    AND aag01 = tah01 ",
                 "    AND aag00 = tah00 "      #No.FUN-740055
		#"  GROUP BY tah01,tah03,aag06 "    #No.MOD-860252 mark
     #No.MOD-860252--begin-- 
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql , " AND aag09 = 'Y'  "
     END IF
     LET l_sql = l_sql , " GROUP BY tah01,tah03,aag06  "
     #No.MOD-860252---end---
     PREPARE gglg310_prepare FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM
     END IF
     DECLARE gglg310_curs CURSOR FOR gglg310_prepare
 
     FOREACH gglg310_curs INTO sr2.*
	IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
	END IF
        IF cl_null(sr2.d_amt)  THEN LET sr2.d_amt = 0 END IF
        IF cl_null(sr2.d_amtf) THEN LET sr2.d_amtf= 0 END IF
        IF cl_null(sr2.c_amt)  THEN LET sr2.c_amt = 0 END IF
        IF cl_null(sr2.c_amtf) THEN LET sr2.c_amtf= 0 END IF
        INSERT INTO g310_tmp VALUES(sr2.tah01,sr2.mm,0,0,sr2.d_amt,              
                                    sr2.d_amtf,sr2.c_amt,sr2.c_amtf)            
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('ins tmp',STATUS,0)    #No.FUN-660124
           CALL cl_err3("ins","g310_tmp",sr2.tah01,sr2.mm,STATUS,"","ins tmp",0)   #No.FUN-660124   
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
           CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
           EXIT PROGRAM
        END IF
     END FOREACH
 
     LET l_m1 = tm.m1 - 1
     LET l_m2 = tm.m2 - 1
 
     FOR l_i = l_m1 TO l_m2
         #期初余額
         LET l_sql = " SELECT tah01,tah03,aag06,0,0,0,0,",
                     "        SUM(tah04-tah05),SUM(tah09-tah10)",
    		     "   FROM tah_file,aag_file ",
    		     "  WHERE ",tm.wc CLIPPED,
		     "    AND tah00 = '",tm.bookno,"'",  #No.FUN-740055
    		     "    AND tah02 = ",tm.yy,
    	             "    AND tah03 <= ",l_i,
    		     "    AND aag01 = tah01 ",
                     "    AND aag00 = tah00 "       #No.FUN-740055
         #No.MOD-860252--begin-- modify
         #          "  GROUP BY tah01,tah03,aag06 "
         IF tm.h = 'Y' THEN 
            LET l_sql = l_sql , " AND aag09 = 'Y' " 
         END IF 
         LET l_sql = l_sql , " GROUP BY tah01,tah03,aag06  "
         #No.MOD-860252---end--- modify
         PREPARE gglg310_pre2 FROM l_sql
         IF STATUS != 0 THEN
            CALL cl_err('pre2:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
            CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
            EXIT PROGRAM 
         END IF
         DECLARE gglg310_curs2 CURSOR FOR gglg310_pre2
         FOREACH gglg310_curs2 INTO sr2.*
    	    IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach curs2:',SQLCA.sqlcode,1) EXIT FOREACH
	    END IF
            IF cl_null(sr2.open_amt) THEN LET sr2.open_amt = 0 END IF
            IF cl_null(sr2.open_amtf) THEN LET sr2.open_amtf = 0 END IF
            IF sr2.aag06 = '2' THEN
               LET sr2.open_amt  = sr2.open_amt  * -1
               LET sr2.open_amtf = sr2.open_amtf * -1
            END IF
            IF sr2.open_amt = 0 AND sr2.open_amtf = 0 THEN
               CONTINUE FOREACH
            END IF
            LET l_mm = l_i + 1
            INSERT INTO g310_tmp VALUES(sr2.tah01,l_mm,sr2.open_amt,
                                        sr2.open_amtf,0,0,0,0)                   
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('ins tmp2',STATUS,0)    #No.FUN-660124
               CALL cl_err3("ins","g310_tmp",sr2.tah01,l_mm,STATUS,"","ins tmp2",0)   #No.FUN-660124  
               CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
               CALL cl_gre_drop_temptable(l_table)       #FUN-C10036 ADD 
               EXIT PROGRAM
            END IF
         END FOREACH
     END FOR
 
#     CALL cl_outnam('gglg310') RETURNING l_name     #NO.FUN-770061
    #TQC-650055...............begin
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 195 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #TQC-650055...............end
#     START REPORT gglg310_rep TO l_name    #NO.FUN-770061
#     LET g_pageno = 0                      #NO.FUN-770061
     CALL cl_prt_pos_len()  #FUN-6C0012
 
    #No.MOD-860252---begin- modify
    #DECLARE tmp_curs CURSOR FOR
    # SELECT tah01,mm,aag02,aag06,aag07,aag13,SUM(open_amt),SUM(open_amtf), #FUN-6C0012
    #        SUM(d_amt),SUM(d_amtf),SUM(c_amt),SUM(c_amtf),0,0,''
    #   FROM g310_tmp,aag_file
    #  WHERE aag01 = tah01
    #    AND aag00 = tm.bookno     #No.FUN-740055
    #  #FUN-6C0012.....begin
    #  GROUP BY tah01,mm,aag02,aag06,aag07,aag13    
    #  #FUN-6C0012.....end
    #  ORDER BY tah01,mm
     LET l_sql = " SELECT tah01,mm,aag02,aag06,aag07,aag13, ",
                 "        SUM(open_amt),SUM(open_amtf), ",
                 "        SUM(d_amt),SUM(d_amtf),SUM(c_amt),SUM(c_amtf),0,0,'',' ',' ',' ',' ' ",   #FUN-B50018 add 4 ''
                 "   FROM g310_tmp,aag_file ",
                 "  WHERE aag01 = tah01 ",
                 "    AND aag00 = '",tm.bookno CLIPPED,"'"
     IF tm.h = 'Y' THEN
        LET l_sql = l_sql , " AND aag09 = 'Y' "
     END IF                                          
     LET l_sql = l_sql , " GROUP BY tah01,mm,aag02,aag06,aag07,aag13 ",
                         " ORDER BY tah01,mm "
     PREPARE tmp_prep FROM l_sql
     DECLARE tmp_curs CURSOR FOR tmp_prep
    #No.MOD-860252---end--- modify
     IF STATUS THEN 
#         CALL cl_err('tmp_curs',STATUS,0)  #No.FUN-660124
          CALL cl_err3("sel","g310_tmp,aag_file","","",STATUS,"","tmp_curs",0)   #No.FUN-660124
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
          CALL cl_gre_drop_temptable(l_table)       #FUN-C10036 ADD
          EXIT PROGRAM 
     END IF
 
     FOREACH tmp_curs INTO sr.*    
	IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
	END IF
        LET sr.chr = sr.tah01[1,1]
        IF cl_null(sr.open_amt)  THEN LET sr.open_amt = 0 END IF
        IF cl_null(sr.open_amtf) THEN LET sr.open_amtf= 0 END IF
        IF cl_null(sr.d_amt)  THEN LET sr.d_amt = 0 END IF
        IF cl_null(sr.d_amtf) THEN LET sr.d_amtf= 0 END IF
        IF cl_null(sr.c_amt)  THEN LET sr.c_amt = 0 END IF
        IF cl_null(sr.c_amtf) THEN LET sr.c_amtf= 0 END IF
        LET sr.end_amt  = sr.open_amt  + sr.d_amt  - sr.c_amt
        LET sr.end_amtf = sr.open_amtf + sr.d_amtf - sr.c_amtf
        IF sr.open_amt = 0 AND sr.open_amtf = 0 AND sr.end_amt = 0 AND
           sr.end_amtf = 0 AND sr.d_amt = 0 AND sr.d_amtf = 0 AND
           sr.c_amt = 0 AND sr.c_amtf = 0 THEN
           CONTINUE FOREACH
        END IF
#FUN_B50018-----------add-----------------str--------------
        IF (sr.aag07 = '2' OR  sr.aag07 = '3') AND sr.d_amtf != sr.d_amt THEN
            LET sr.l_d_amtf_l = sr.d_amtf
        ELSE
            LET sr.l_d_amtf_l = 0
        END IF

        IF sr.aag07 = '2' OR  sr.aag07 = '3' THEN
          LET sr.l_d_amt_l = sr.d_amt
        ELSE
          LET sr.l_d_amt_l = 0
        END IF
        
        IF (sr.aag07 = '2' OR  sr.aag07 = '3') AND sr.c_amtf != sr.c_amt THEN
            LET sr.l_c_amtf_l = sr.c_amtf
        ELSE
            LET sr.l_c_amtf_l = 0
        END IF

        IF sr.aag07 = '2' OR  sr.aag07 = '3' THEN
           LET sr.l_c_amt_l = sr.c_amt
        ELSE
            LET sr.l_c_amt_l = 0
        END IF

        IF (sr.aag07 = '2' OR  sr.aag07 = '3') AND sr.open_amtf != sr.open_amt AND sr.open_amtf != 0 THEN
           IF sr.open_amtf < 0 THEN
              LET sr.l_o_amtf = sr.open_amtf *( -1)
           ELSE
              LET sr.l_o_amtf = sr.open_amtf
           END IF
        ELSE
           LET sr.l_o_amtf = 0 
        END IF 


        IF sr.aag07 = '2' OR  sr.aag07 = '3' THEN
           LET sr.l_o_amt = sr.open_amt
        ELSE
           LET sr.l_o_amt = 0
        END IF
#FUN_B50018-----------add-----------------end--------------
#	OUTPUT TO REPORT gglg310_rep(sr.*) #NO.FUN-770061
#NO.FUN-770061------------------start----------------                                                                               
        EXECUTE insert_prep USING                                                                                                   
           sr.tah01,sr.mm,sr.aag02,sr.aag06,sr.aag07,sr.aag13,sr.open_amt,                                                          
           sr.open_amtf,sr.d_amt,sr.d_amtf,sr.c_amt,sr.c_amtf,sr.end_amt,                                                           
           #sr.end_amtf,sr.chr                                                  #FUN-B50018 mark
           sr.end_amtf,sr.chr ,sr.l_d_amt_l,sr.l_d_amtf_l,sr.l_c_amt_l,sr.l_c_amtf_l,sr.l_o_amtf,sr.l_o_amt    #FUN-B50018 add                                                                                             
#NO.FUN-770061----------------END----------  
     END FOREACH
 
#     FINISH REPORT gglg310_rep      #NO.FUN-770061 
#NO.FUN-770061----------------start----------                                                                                       
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'tah01')  RETURNING tm.wc                                                                               
     END IF                                                                                                                         
###GENGRE###     LET g_str = tm.wc,";",tm.yy,";",tm.e,";",g_azi04,";",g_azi05                                                                   
###GENGRE###     CALL cl_prt_cs3('gglg310','gglg310',g_sql,g_str)                                                                               
    CALL gglg310_grdata()    ###GENGRE###
#NO.FUN-770061----------------END----------    
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #NO.FUN-770061
       
       #No.FUN-B80096--mark--Begin---
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
       #No.FUN-B80096--mark--End-----
 
       CALL cl_gre_drop_temptable(l_table)
END FUNCTION
#NO.FUN-770061---------------start----------  
#REPORT gglg310_rep(sr)
#    DEFINE sr           RECORD
#                       tah01     LIKE tah_file.tah01,
#                       mm        LIKE type_file.num5,       #NO FUN-690009   SMALLINT
#                       aag02     LIKE aag_file.aag02,
#                       aag06     LIKE aag_file.aag06,
#                       aag07     LIKE aag_file.aag07,
#                       aag13     LIKE aag_file.aag13,  #FUN-6C0012
#                       open_amt  LIKE tah_file.tah10,
#                       open_amtf LIKE tah_file.tah10,
#                       d_amt     LIKE tah_file.tah10,
#                       d_amtf    LIKE tah_file.tah10,
#                       c_amt     LIKE tah_file.tah10,
#                       c_amtf    LIKE tah_file.tah10,
#                       end_amt   LIKE tah_file.tah10,
#                       end_amtf  LIKE tah_file.tah10,
#                       chr       LIKE type_file.chr1        #NO FUN-690009   VARCHAR(01)
#                       END RECORD
#   DEFINE l_count      LIKE type_file.num5        #NO FUN-690009   SMALLINT
#   DEFINE l_o_sum,l_e_sum,l_d_sum,l_c_sum        LIKE tah_file.tah04
#   DEFINE l_o_sumf,l_e_sumf,l_d_sumf,l_c_sumf    LIKE tah_file.tah09
 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.mm,sr.chr,sr.tah01
#  FORMAT
#  PAGE HEADER
#     SKIP 2 LINE
#     PRINT COLUMN 83,g_company CLIPPED,'(',g_x[1] CLIPPED,')'    #LINE NO 3
#     PRINT
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN 1,g_x[2] CLIPPED,tm.yy USING '###&',g_x[5] CLIPPED,5 SPACES,sr.mm USING '#&',g_x[9] CLIPPED
#     PRINT COLUMN 175,g_x[3] CLIPPED,g_pageno USING '<<<'              #LINE NO 5
#     PRINT "=================================================================================================",
#           "========================================================================================="
#   SKIP 2 LINE
#
#  BEFORE GROUP OF sr.mm
#     SKIP TO TOP OF PAGE
 
#  ON EVERY ROW
#     IF LINENO>=37 THEN
#        SKIP TO TOP OF PAGE
#     END IF
#     IF LINENO = 36 THEN
#        PRINT COLUMN 20 ,g_x[6] CLIPPED
#        SKIP TO TOP OF PAGE
#        PRINT COLUMN 20 ,g_x[13] CLIPPED
#     END IF
#     #FUN-6C0012.....begin
#     IF tm.e = 'Y' THEN
#        PRINT COLUMN 01,sr.tah01 CLIPPED,' ',sr.aag13 CLIPPED;
#     ELSE
#     #FUN-6C0012.....end
#        PRINT COLUMN 01,sr.tah01 CLIPPED,' ',sr.aag02 CLIPPED;  #MOD-4A0238
#     END IF   #FUN-6C0012 
#     IF sr.open_amtf = 0 THEN
#        PRINT COLUMN 36,g_x[16] CLIPPED;
#     ELSE
#        IF sr.aag06 = '1' THEN
#           IF sr.open_amtf > 0 THEN PRINT COLUMN 36,g_x[14] CLIPPED;
#              ELSE PRINT COLUMN 36,g_x[15] CLIPPED;
#                   LET sr.open_amt  = sr.open_amt  * -1
#                   LET sr.open_amtf = sr.open_amtf * -1
#           END IF
#        ELSE
#           IF sr.open_amtf < 0 THEN
#              LET sr.open_amt  = sr.open_amt  * -1
#              LET sr.open_amtf = sr.open_amtf * -1
#              PRINT COLUMN 36,g_x[14] CLIPPED;
#           ELSE PRINT COLUMN 36,g_x[15] CLIPPED;
#           END IF
#        END IF
#     END IF
#     #明細和獨立科目時才列印原幣金額,當為外幣時才印外幣金額
#     IF sr.aag07 MATCHES '[23]' AND sr.open_amtf != sr.open_amt THEN
#        IF sr.open_amtf <> 0 THEN
#           PRINT COLUMN 40,cl_numfor(sr.open_amtf,15,g_azi04);
#        END IF
#     END IF
#     PRINT COLUMN 58,cl_numfor(sr.open_amt,15,g_azi04);
#
#     #本期借方發生
#     IF sr.aag07 MATCHES '[23]' AND sr.d_amt != sr.d_amtf THEN
#        IF sr.d_amtf <> 0 THEN
#           PRINT COLUMN 77,cl_numfor(sr.d_amtf,15,g_azi04);
#        END IF
#     END IF
#     IF sr.d_amt <> 0 THEN
#        PRINT COLUMN 95,cl_numfor(sr.d_amt,15,g_azi04);
#     END IF
#
#     #本期貸方發生
#     IF sr.aag07 MATCHES '[23]' AND sr.c_amt != sr.c_amtf THEN
#        IF sr.c_amtf <> 0 THEN
#           PRINT COLUMN 113,cl_numfor(sr.c_amtf,15,g_azi04);
#        END IF
#     END IF
#     IF sr.c_amt <> 0 THEN
#        PRINT COLUMN 132,cl_numfor(sr.c_amt,15,g_azi04);
#     END IF
#
#     #期末金額
#     IF sr.end_amtf = 0 THEN
#        PRINT COLUMN 149,g_x[16] CLIPPED;
#     ELSE
#        IF sr.aag06 = '1' THEN
#           IF sr.end_amtf > 0 THEN PRINT COLUMN 149,g_x[14] CLIPPED;
#              ELSE PRINT COLUMN 149,g_x[15] CLIPPED;
#                   LET sr.end_amt  = sr.end_amt  * -1
#                   LET sr.end_amtf = sr.end_amtf * -1
#           END IF
#        ELSE
#           IF sr.end_amtf < 0 THEN
#              LET sr.end_amt  = sr.end_amt  * -1
#              LET sr.end_amtf = sr.end_amtf * -1
#              PRINT COLUMN 149,g_x[14] CLIPPED;
#           ELSE PRINT COLUMN 149,g_x[15] CLIPPED;
#           END IF
#        END IF
#     END IF
 
#     IF sr.aag07 MATCHES '[23]' AND sr.end_amt != sr.end_amtf THEN
#        IF sr.end_amtf <> 0 THEN
#           PRINT COLUMN 153,cl_numfor(sr.end_amtf,15,g_azi04);
#        END IF
#     END IF
#     PRINT COLUMN 171,cl_numfor(sr.end_amt,15,g_azi04)
#       
#  AFTER GROUP OF sr.chr
#     LET l_o_sum = GROUP SUM(sr.open_amt) WHERE sr.aag07 MATCHES '[23]'
#     LET l_o_sumf= GROUP SUM(sr.open_amtf)
#                   WHERE sr.aag07 MATCHES '[23]' AND sr.open_amt!=sr.open_amtf
#     LET l_d_sum = GROUP SUM(sr.d_amt) WHERE sr.aag07 MATCHES '[23]'
#     LET l_d_sumf= GROUP SUM(sr.d_amtf)
#                   WHERE sr.aag07 MATCHES '[23]' AND sr.d_amt != sr.d_amt
#     LET l_c_sum = GROUP SUM(sr.c_amt) WHERE sr.aag07 MATCHES '[23]'
#     LET l_c_sumf= GROUP SUM(sr.c_amtf)
#                   WHERE sr.aag07 MATCHES '[23]' AND sr.c_amt != sr.c_amtf
#     IF cl_null(l_o_sum)  THEN LET l_o_sum  = 0 END IF
#     IF cl_null(l_o_sumf) THEN LET l_o_sumf = 0 END IF
#     IF cl_null(l_d_sum)  THEN LET l_d_sum  = 0 END IF
#     IF cl_null(l_d_sumf) THEN LET l_d_sumf = 0 END IF
#     IF cl_null(l_c_sum)  THEN LET l_c_sum  = 0 END IF
#     IF cl_null(l_c_sumf) THEN LET l_c_sumf = 0 END IF
 
#     LET l_e_sum = l_o_sum + l_d_sum - l_c_sum
#     LET l_e_sumf= l_o_sumf + l_d_sumf - l_c_sumf
 
#     IF l_o_sum < 0 THEN
#        LET l_o_sum  = l_o_sum  * -1
#        LET l_o_sumf = l_o_sumf * -1
#     END IF
#     IF l_e_sum < 0 THEN
#        LET l_e_sum  = l_e_sum  * -1
#        LET l_e_sumf = l_e_sumf * -1
#     END IF
 
#     PRINT COLUMN  01,g_x[12] CLIPPED;
#     PRINT COLUMN  40,cl_numfor(l_o_sumf,15,g_azi05);
#     PRINT COLUMN  58,cl_numfor(l_o_sum,15,g_azi05);
#     PRINT COLUMN  77,cl_numfor(l_d_sumf,15,g_azi05);
#     PRINT COLUMN  95,cl_numfor(l_d_sum,15,g_azi05);
#     PRINT COLUMN 113,cl_numfor(l_c_sumf,15,g_azi05);
#     PRINT COLUMN 132,cl_numfor(l_c_sum,15,g_azi05);
#     PRINT COLUMN 153,cl_numfor(l_e_sumf,15,g_azi05);
#     PRINT COLUMN 171,cl_numfor(l_e_sum,15,g_azi05)
# END REPORT	
#Patch....NO.TQC-610037 <001> #
#NO.FUN-770061-----------------END-------    

###GENGRE###START
FUNCTION gglg310_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gglg310")
        IF handler IS NOT NULL THEN
            START REPORT gglg310_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY mm,chr"                #FUN-C10036
          
            DECLARE gglg310_datacur1 CURSOR FROM l_sql
            FOREACH gglg310_datacur1 INTO sr1.*
                OUTPUT TO REPORT gglg310_rep(sr1.*)
            END FOREACH
            FINISH REPORT gglg310_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gglg310_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE l_d_amtf_l_sum   LIKE tah_file.tah10
    DEFINE l_d_amt_l_sum    LIKE tah_file.tah10
    DEFINE l_c_amtf_l_sum   LIKE tah_file.tah10
    DEFINE l_c_amt_l_sum    LIKE tah_file.tah10
    DEFINE l_d_amtf         LIKE tah_file.tah10
    DEFINE l_d_amt          LIKE tah_file.tah10
    DEFINE l_c_amtf         LIKE tah_file.tah10
    DEFINE l_c_amt          LIKE tah_file.tah10
    DEFINE l_e_amtf         LIKE tah_file.tah10
    DEFINE l_e_amt          LIKE tah_file.tah10
    DEFINE l_g_c01          STRING
    DEFINE l_g_c149         STRING
    DEFINE l_g_c171         LIKE tah_file.tah10
    DEFINE l_g_c36          STRING
    DEFINE l_g_c58          LIKE tah_file.tah10
    DEFINE l_e_sum          LIKE tah_file.tah10
    DEFINE l_e_sum_1        LIKE tah_file.tah10
    DEFINE l_e_sum_2        LIKE tah_file.tah10
    DEFINE l_e_sum_3        LIKE tah_file.tah10
    DEFINE l_e_sumf         LIKE tah_file.tah10
    DEFINE l_e_sumf_1       LIKE tah_file.tah10
    DEFINE l_e_sumf_2       LIKE tah_file.tah10
    DEFINE l_e_sumf_3       LIKE tah_file.tah10
    DEFINE l_e_sumffin      LIKE tah_file.tah10
    DEFINE l_e_sumfin       LIKE tah_file.tah10
    DEFINE l_o_sumffin      LIKE tah_file.tah10
    DEFINE l_o_sumfin       LIKE tah_file.tah10
    DEFINE l_o_amt_l        LIKE tah_file.tah10
    DEFINE l_o_amtf         LIKE tah_file.tah10
    DEFINE l_o_amt_l_sum    LIKE tah_file.tah10
    DEFINE l_o_amtf_l_sum   LIKE tah_file.tah10
    DEFINE l_o_amtf_l       LIKE tah_file.tah10
    DEFINE l_recordnumber   LIKE tah_file.tah10
    #FUN-B50018----add-----end-----------------
    DEFINE l_fmt2           STRING               #FUN-C10036
    DEFINE l_fmt1           STRING               #FUN-C10036 
    DEFINE l_cnt            LIKE type_file.num5  #FUN-C10036
    DEFINE l_display        LIKE type_file.chr1  #FUN-C10036
    DEFINE sr1_o            sr1_t                #FUN-C10036

    
    ORDER EXTERNAL BY sr1.mm,sr1.chr
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.mm
            LET l_lineno = 0
            LET l_cnt = 0 #FUN-C10036
        BEFORE GROUP OF sr1.chr

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-C10036---------add----str---
            LET l_fmt1 = cl_gr_numfmt('tah_file','tah10',g_azi04)
            PRINTX l_fmt1
            LET l_fmt2 = cl_gr_numfmt('tah_file','tah10',g_azi05)
            PRINTX l_fmt2

#           IF l_lineno = 1 THEN
#              LET l_cnt = 1
#           ELSE
#             IF sr1_o.mm != sr1.mm THEN
#                LET l_cnt = 0
#             ELSE
#                IF sr1_o.chr != sr1.chr THEN
#                   LET l_cnt = l_cnt +2
#                ELSE
#                   LET l_cnt = l_cnt +1
#                END IF
#             END IF
#          END IF
#   
#         IF l_cnt mod 27 = 0 AND sr1.mm =sr1_o.mm THEN
#            LET l_display = 'Y' 
#         ELSE
#            LET l_display = 'N' 
#         END IF
#         PRINTX l_display
            #FUN-C10036---------add----end---

            #FUN-B50018----add-----str-----------------
            IF sr1.d_amtf = 0 THEN
               LET sr1.d_amtf = ' '
            END IF

            IF sr1.d_amt = 0 THEN
               LET sr1.d_amt = ' '
            END IF

            IF sr1.c_amtf = 0 THEN
               LET sr1.c_amtf = ' '
            END IF

            IF sr1.c_amt = 0 THEN
               LET sr1.c_amt = ' '
            END IF

            IF tm.e = 'Y' THEN 
               LET l_g_c01 = sr1.tah01, ' ',sr1.aag13
            ELSE
               LET l_g_c01 = sr1.tah01, ' ',sr1.aag02
            END IF
            PRINTX l_g_c01

            IF (sr1.aag07 = '2' OR  sr1.aag07 = '3') AND sr1.open_amtf != sr1.open_amt AND sr1.open_amtf != 0 THEN
               IF sr1.open_amtf < 0 THEN
                  LET l_e_amtf = sr1.open_amtf *( -1)
               ELSE
                  LET l_e_amtf = sr1.open_amtf
               END IF
            ELSE
                LET l_e_amtf = 0 
            END IF
            PRINTX l_e_amtf

            IF sr1.end_amtf = 0 THEN 
               LET l_g_c149 = cl_gr_getmsg("gre-068",g_lang,'2') 
            ELSE
               IF sr1.aag06 = '1' THEN
                  IF sr1.end_amtf > 0 THEN 
                     LET l_g_c149 = cl_gr_getmsg("gre-068",g_lang,'1')
                  ELSE 
                     LET l_g_c149 = cl_gr_getmsg("gre-068",g_lang,'3')
                  END IF
               ELSE
                  IF sr1.end_amtf < 0 THEN 
                     LET l_g_c149 = cl_gr_getmsg("gre-068",g_lang,'1')
                  ELSE  
                     LET l_g_c149 = cl_gr_getmsg("gre-068",g_lang,'3')
                  END IF 
               END IF
            END IF                  
            PRINTX l_g_c149
    

            IF sr1.open_amtf = 0 THEN 
               LET l_g_c36 = cl_gr_getmsg("gre-068",g_lang,'2') 
            ELSE
                IF sr1.aag06 = '1' THEN
                   IF sr1.open_amtf > 0 THEN 
                      LET l_g_c36 = cl_gr_getmsg("gre-068",g_lang,'1')
                   ELSE 
                      LET l_g_c36 = cl_gr_getmsg("gre-068",g_lang,'3')
                   END IF
               ELSE
                   IF sr1.open_amtf < 0 THEN 
                      LET l_g_c36 = cl_gr_getmsg("gre-068",g_lang,'1')
                   ELSE 
                      LET l_g_c36 = cl_gr_getmsg("gre-068",g_lang,'3')
                   END IF 
               END IF
            END IF                  
            PRINTX l_g_c36           

            IF sr1.end_amtf < 0 THEN           
               LET l_g_c171 = sr1.end_amt * -1
            ELSE
               LET l_g_c171 = sr1.end_amt
            END IF
            PRINTX l_g_c171

            IF sr1.open_amtf < 0 THEN
               LET l_g_c58 = sr1.open_amt * -1
            ELSE
               LET l_g_c58 = sr1.open_amt
            END IF
            PRINTX l_g_c58


            #FUN-B50018----add-----end-----------------
            LET sr1_o.* = sr1.*       #FUN-C10036

            PRINTX sr1.*

        AFTER GROUP OF sr1.mm
        AFTER GROUP OF sr1.chr

            #FUN-B50018----add-----str-----------------
            LET l_d_amtf_l_sum = GROUP SUM (sr1.l_d_amtf_l)
            PRINTX l_d_amtf_l_sum

            LET l_d_amt_l_sum = GROUP SUM (sr1.l_d_amt_l)
            PRINTX l_d_amt_l_sum

            LET l_c_amtf_l_sum = GROUP SUM (sr1.l_c_amtf_l)
            PRINTX l_c_amtf_l_sum

	    LET l_c_amt_l_sum = GROUP SUM (sr1.l_c_amt_l)
            PRINTX l_c_amt_l_sum

            LET l_o_amt_l_sum = GROUP SUM(sr1.l_o_amt)
          
            IF l_g_c36 = cl_gr_getmsg("gre-068",g_lang,'1') THEN
                LET l_o_amtf_l_sum = GROUP SUM(sr1.l_o_amtf)
            ELSE
                LET l_o_amtf_l_sum = - GROUP SUM(sr1.l_o_amtf)   
            END IF

            IF l_o_amt_l_sum < 0 THEN 
               LET l_o_sumffin = l_o_amtf_l_sum * (-1)
            ELSE
               LET l_o_sumffin = l_o_amtf_l_sum
            END IF  
            PRINT l_o_sumffin

            IF l_o_amt_l_sum < 0 THEN
               LET l_o_sumfin = l_o_amt_l_sum * (-1)
            ELSE
               LET l_o_sumfin = l_o_amt_l_sum
            END IF
            PRINT l_o_sumfin 


            LET l_e_sum = l_o_amt_l_sum + l_d_amt_l_sum - l_c_amt_l_sum
            LET l_e_sumf= l_o_amtf_l_sum + l_d_amtf_l_sum - l_c_amtf_l_sum
            
            IF l_e_sum < 0 THEN
               LET l_e_sumffin = l_e_sumf * (-1)
            ELSE
               LET l_e_sumffin = l_e_sumf
            END IF
            PRINTX l_e_sumffin   
            
            IF l_e_sum < 0 THEN
               LET l_e_sumfin = l_e_sum * (-1)
            ELSE
               LET l_e_sumfin = l_e_sum
            END IF
            PRINTX l_e_sumfin   



            #FUN-B50018----add-----end-----------------
            

        
        ON LAST ROW

END REPORT
###GENGRE###END
