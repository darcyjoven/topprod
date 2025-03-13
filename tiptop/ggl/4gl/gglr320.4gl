# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr320.4gl
# Descriptions...: 日記帳
# Date & Author..: 02/09/09 By WINDY
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-560232 05/07/08 By Nicola 金額放大到18碼
# Modify.........: No.MOD-560110 05/07/08 By Nicola 日記帳的期初金額目前都是零,因為程序在判斷期初的時候的條件是aah03='1',應改成aah03='0'
# Modify.........: No.MOD-570145 05/07/07 By wujie  列印資料重復，借貸相反的修正
# Modify.........: No.FUN-570083 05/07/13 By vivien  判斷現金科目
# Modify.........: No.MOD-590097 05/09/08 By jackie 將報表畫線部分寫進zaa
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/13 By mike    會計科目加帳套
# Modify.........: No.TQC-740305 07/04/30 By Lynn FROM:位置在報表名之上
# Modify.........: No.MOD-780004 07/08/23 By Smapmin 修改報表列印內容
# Modify.........: No.FUN-870029 08/07/02 BY TSD.zeak 轉CR報表  
# Modify.........: No.FUN-890102 08/09/23 BY Cockroach CR 21-->31
# Modify.........: No.MOD-860252 09/02/17 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.TQC-940044 09/05/07 By mike 刪除冗余的r320_tmp 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C10024  12/05/23 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
			wc      LIKE type_file.chr1000,    #NO.FUN-690009   VARCHAR(300)   # Where condition                                   
                        yyyy    LIKE type_file.num5,       #NO.FUN-690009   SMALLINT    # year                                              
                        mm      LIKE type_file.num5,       #NO.FUN-690009   SMALLINT    # period                                            
                        nn      LIKE type_file.num5,       #NO.FUN-690009   SMALLINT    # laster                                            
                        p       LIKE type_file.chr1,       #NO.FUN-690009   VARCHAR(1)     # 獨立列印否                                        
                        bb      LIKE azi_file.azi01,       #NO.FUN-690009   VARCHAR(4)     # 幣別                                              
                        h       LIKE type_file.chr1,       #MOD-860252
                        e       LIKE type_file.chr1,       #FUN-6C0012
                        m       LIKE type_file.chr1        #NO.FUN-690009   VARCHAR(1)     # Input more condition(Y/N)
        	END RECORD,
     g_aaa04   LIKE type_file.num5,       #NO.FUN-690009   SMALLINT        #現行會計年度
     g_aaa05   LIKE type_file.num5,       #NO.FUN-690009   SMALLINT         #現行期別
      g_abb01    LIKE abb_file.abb01,     #No.MOD-570145
     g_abb06   LIKE abb_file.abb06,       #NO.FUN-690009   VARCHAR(01)
# Prog. Version..: '5.30.06-13.03.12(04)   #MOD-780004
     g_aac03   LIKE aac_file.aac03,       #NO.FUN-690009   VARCHAR(01)
     g_aac13   LIKE type_file.chr1,       #NO.FUN-690009   VARCHAR(01)
     g_no      LIKE type_file.num5,       #NO.FUN-690009   SMALLINT
     b         LIKE aaa_file.aaa01,       #帳別            #No.FUN-670039 #No.FUN-740055
     g_cn       LIKE type_file.num5,      #NO.FUN-690009   SMALLINT         #add 030731 NO.A085
     g_count    LIKE type_file.num5,      #NO.FUN-690009   SMALLINT         #add 030812 NO.A085
     g_cont_aba LIKE type_file.num5       #NO.FUN-690009   SMALLINT         #add 030812 NO.A085
#DEFINE   g_aaa03         LIKE aaa_file.aaa03   #MOD-780004
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table    STRING                  # FUN-870029
DEFINE   g_str      STRING                  # FUN-870029
DEFINE   g_sql      STRING                  # FUN-870029
DEFINE   g_pagecut  SMALLINT                # FUN-870029            
DEFINE   g_cnt      SMALLINT                # FUN-870029
 
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
 
   #FUN-870029 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>  *** ##
   LET g_sql = "m_aba02.type_file.num5,", 
               "aag01.aag_file.aag01,", 
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "aba02.aba_file.aba02,",
               "aba04.aba_file.aba04,",
               "abb01.abb_file.abb01,",
               "abb02.abb_file.abb02,",
               "abb04.abb_file.abb04,",
               "abb24.abb_file.abb24,",
               "abb25.abb_file.abb25,",
               "aas04.aas_file.aas04,",
               "aas05.aas_file.aas05,",
               "tas04.tas_file.tas04,",
               "tas05.tas_file.tas05,",
               "tas09.tas_file.tas09,",
               "tas10.tas_file.tas10,", 
               "aah04.aah_file.aah04,",
               "aah05.aah_file.aah05,",
               "tah04.tah_file.tah04,",
               "tah05.tah_file.tah05,",
               "tah09.tah_file.tah09,",
               "tah10.tah_file.tah10,",
               "b_bal.type_file.num20_6,",    
               "b_balf.type_file.num20_6,",    
               "b_d.type_file.num20_6,",    
               "b_df.type_file.num20_6,",    
               "l_df.type_file.num20_6,",   
               "b_c.type_file.num20_6,",     
               "b_cf.type_file.num20_6,",    
               "l_cf.type_file.num20_6,",    
               "bala.type_file.num20_6,",    
               "balaf.type_file.num20_6,",    
               "l_d.type_file.num20_6,",    
               "l_c.type_file.num20_6,",    
               "balb.type_file.num20_6,",    
               "balbf.type_file.num20_6,",    
               "bald.type_file.num20_6,",    
               "baldf.type_file.num20_6,",    
               "balc.type_file.num20_6,",    
               "balcf.type_file.num20_6,",    
               "l_abb07_l.type_file.num20_6,", 
               "l_abb07_r.type_file.num20_6,", 
               "s_aas04.type_file.num20_6,", 
               "s_aas05.type_file.num20_6,", 
               "s_tas04.tas_file.tas04,",    
               "s_tas05.tas_file.tas05,",    
               "s_tas09.type_file.num20_6,", 
               "s_tas10.type_file.num20_6,", 
               "l_abb07f_l.type_file.num20_6,", 
               "l_abb07f_r.type_file.num20_6,", 
               "l_aba02.aba_file.aba02,",      
               "aag02_o.aag_file.aag02,",      
               "aag13_o.aag_file.aag13,",      
               "l_aba04.aba_file.aba04,",      
               "l_abb01.abb_file.abb01,",      
               "l_abb06.abb_file.abb06,",      
               "l_abb02.abb_file.abb02,",      
               "l_bala.type_file.num20_6,",   
               "l_balaf.type_file.num20_6,",
               "azi04.azi_file.azi04,",
               "azi07.azi_file.azi07,",  
               "t_azi04.azi_file.azi04,",
               "t_azi07.azi_file.azi07,",
               "aaz51.aaz_file.aaz51,",  
               "sub_tas04.tas_file.tas04,",    
               "sub_tas05.tas_file.tas05,",    
               "sub_tas09.type_file.num20_6,", 
               "sub_tas10.type_file.num20_6,",
               "page.type_file.num10" 
 
   LET l_table = cl_prt_temptable('gglr320',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   
   #FUN-870029- END
 
   LET b = ' '   #No.FUN-740055 
   LET b = ARG_VAL(1)#No.FUN-740055 
   LET g_pdate  = ARG_VAL(2)		# Get arguments from command line
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
   IF b IS NULL OR b = ' ' THEN #No.FUN-740055 
      SELECT aza81 INTO b   #No.FUN-740055 
      FROM aza_file  #No.FUN-740055 
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglr320_tm()	        	# Input print condition
      ELSE CALL gglr320()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr320_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_cmd		LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5  #FUN-B20010
   CALL s_dsmark(b)  #No.FUN-740055
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW gglr320_w AT p_row,p_col WITH FORM "ggl/42f/gglr320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,b)  #No.FUN-740055 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.p    = 'N'
   LET tm.bb   = ' '
   LET tm.h    = 'Y'  #No.MOD-860252
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.m    = 'N'
   LET tm.mm   = '1'
   SELECT aaa04,aaa05 INTO tm.yyyy,tm.nn
     FROM aaa_file WHERE aaa01 = b  #No.FUN-740055 
   #SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = b    #No.FUN-740055       #MOD-780004
   #IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF                                     #使用本國貨幣   #MOD-780004
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
WHILE TRUE
#No.FUN-B20010  --Mark Begin
#    CONSTRUCT BY NAME tm.wc ON aag01
#         #No.FUN-580031 --start--
#         BEFORE CONSTRUCT
#             CALL cl_qbe_init()
#         #No.FUN-580031 ---end---
# 
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
# 
#  END CONSTRUCT
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW gglr320_w EXIT PROGRAM
#    END IF
#    INPUT BY NAME  b,tm.yyyy,tm.mm,tm.nn,tm.p,tm.bb,tm.h,tm.e,tm.m WITHOUT DEFAULTS  #FUN-6C0012  #No.FUN-740055  #No.MOD-860252 add tm.h
#         #No.FUN-580031 --start--
#         BEFORE INPUT
#             CALL cl_qbe_display_condition(lc_qbe_sn)
#         #No.FUN-580031 ---end---
# 
#    #No.FUN-740055  --BEGIN--
#    AFTER FIELD b
#      IF b IS NULL THEN
#         NEXT FIELD b
#      END IF
#    #No.FUN-740055  --END--
#    AFTER FIELD yyyy
#      IF tm.yyyy  IS NULL OR tm.yyyy = 0 THEN NEXT FIELD yyyy END IF
#    AFTER FIELD mm
##No.TQC-720032 -- begin --
#         IF NOT cl_null(tm.mm) THEN
#            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.yyyy
#            IF g_azm.azm02 = 1 THEN
#               IF tm.mm > 12 OR tm.mm < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD mm
#               END IF
#            ELSE
#               IF tm.mm > 13 OR tm.mm < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD mm
#               END IF
#            END IF
#         END IF
##No.TQC-720032 -- end --
#      IF tm.mm IS NULL OR tm.mm = 0 THEN NEXT FIELD mm LET tm.mm = 1 END IF
# 
#    AFTER FIELD nn
##No.TQC-720032 -- begin --
#         IF NOT cl_null(tm.nn) THEN
#            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.yyyy
#            IF g_azm.azm02 = 1 THEN
#               IF tm.nn > 12 OR tm.nn < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD nn
#               END IF
#            ELSE
#               IF tm.nn > 13 OR tm.nn < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD nn
#               END IF
#            END IF
#         END IF
##No.TQC-720032 -- end --
#      IF tm.nn IS NULL OR tm.nn = 0 THEN NEXT FIELD nn LET tm.nn = g_aaa05 END IF
#      IF tm.nn < tm.mm THEN NEXT FIELD nn END IF
#    AFTER FIELD p
#      IF tm.p NOT MATCHES "[YN]" THEN NEXT FIELD p LET tm.p = 'N' END IF
#      IF tm.p  = 'N' THEN LET tm.bb = NULL DISPLAY BY NAME tm.bb END IF 
#     #FUN-6C0012.....begin
#      IF tm.p  = 'N' THEN
#         CALL cl_set_comp_entry("bb",FALSE) 
#      ELSE
#         CALL cl_set_comp_entry("bb",TRUE)
#      END IF  
# 
#    BEFORE FIELD bb
#      IF tm.p  = 'N' THEN
#         CALL cl_set_comp_entry("bb",FALSE)
#      ELSE
#         CALL cl_set_comp_entry("bb",TRUE)
#      END IF 
#     #FUN-6C0012.....end
#    AFTER FIELD bb
#     #FUN-6C0012.....begin
##     IF tm.bb IS NULL THEN NEXT FIELD bb END IF
#      SELECT azi01 FROM azi_file where azi01 = tm.bb
#       IF SQLCA.sqlcode THEN
#          NEXT FIELD bb
#       ELSE
#          DISPLAY BY NAME tm.bb
#       END IF 
#     #FUN-6C0012.....end
#    AFTER FIELD m
#      IF tm.m = 'Y'
#        THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                            g_bgjob,g_time,g_prtway,g_copies)
#                  RETURNING g_pdate,g_towhom,g_rlang,
#                            g_bgjob,g_time,g_prtway,g_copies
#        END IF
# 
#    ON ACTION CONTROLR
#       CALL cl_show_req_fields()
# 
#    ON ACTION CONTROLG
#       CALL cl_cmdask()	# Command execution
# 
#    ON ACTION CONTROLP
#      CASE
#         #No.FUN-740055  --BEGIN--                                                                                                       
#         WHEN INFIELD(b)                                                                                                            
#           CALL cl_init_qry_var()                                                                                                   
#           LET g_qryparam.form='q_aaa'                                                                                              
#           LET g_qryparam.default1=b                                                                                                
#           CALL cl_create_qry()  RETURNING b                                                                                        
#           DISPLAY BY NAME b                                                                                                        
#           NEXT FIELD b                                                                                                             
#         #No.FUN-740055  -END--  
#         WHEN INFIELD(bb)
##          CALL q_azi(0,0,tm.bb) RETURNING tm.bb
##          CALL FGL_DIALOG_SETBUFFER( tm.bb )
#           CALL cl_init_qry_var()
#           LET g_qryparam.form = 'q_azi'
#           LET g_qryparam.default1 = tm.bb
#           CALL cl_create_qry() RETURNING tm.bb
##          CALL FGL_DIALOG_SETBUFFER( tm.bb )
#           DISPLAY BY NAME tm.bb
#         OTHERWISE  EXIT CASE
#      END CASE
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
# 
#    END INPUT
#No.FUN-B20010  --Mark End
        DIALOG ATTRIBUTE(unbuffered)
        INPUT BY NAME b ATTRIBUTE(WITHOUT DEFAULTS)
           BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)
           
           AFTER FIELD b
              IF cl_null(b) THEN NEXT FIELD b END IF
              CALL s_check_bookno(b,g_user,g_plant)
                   RETURNING li_chk_bookno
              IF (NOT li_chk_bookno) THEN
                 NEXT FIELD b
              END IF
              SELECT * FROM aaa_file WHERE aaa01 = b
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aaa_file",b,"","aap-229","","",0)
                 NEXT FIELD b
              END IF
          END INPUT 
          
         CONSTRUCT BY NAME tm.wc ON aag01

            BEFORE CONSTRUCT
             CALL cl_qbe_init()
         
         END CONSTRUCT
   
       INPUT BY NAME tm.yyyy,tm.mm,tm.nn,tm.p,tm.bb,tm.h,tm.e,tm.m ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD yyyy
           IF tm.yyyy  IS NULL OR tm.yyyy = 0 THEN NEXT FIELD yyyy END IF
         AFTER FIELD mm
        
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

             IF tm.mm IS NULL OR tm.mm = 0 THEN NEXT FIELD mm LET tm.mm = 1 END IF
 
          AFTER FIELD nn
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
         IF tm.nn IS NULL OR tm.nn = 0 THEN NEXT FIELD nn LET tm.nn = g_aaa05 END IF
         IF tm.nn < tm.mm THEN NEXT FIELD nn END IF
    AFTER FIELD p
      IF tm.p NOT MATCHES "[YN]" THEN NEXT FIELD p LET tm.p = 'N' END IF
      IF tm.p  = 'N' THEN LET tm.bb = NULL DISPLAY BY NAME tm.bb END IF 
     
      IF tm.p  = 'N' THEN
         CALL cl_set_comp_entry("bb",FALSE) 
      ELSE
         CALL cl_set_comp_entry("bb",TRUE)
      END IF  
 
    BEFORE FIELD bb
      IF tm.p  = 'N' THEN
         CALL cl_set_comp_entry("bb",FALSE)
      ELSE
         CALL cl_set_comp_entry("bb",TRUE)
      END IF 
    AFTER FIELD bb
      SELECT azi01 FROM azi_file where azi01 = tm.bb
       IF SQLCA.sqlcode THEN
          NEXT FIELD bb
       ELSE
          DISPLAY BY NAME tm.bb
       END IF 
     
    AFTER FIELD m
      IF tm.m = 'Y'
        THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
        END IF   
    END INPUT
     ON ACTION CONTROLP
      CASE                                                                                                            
         WHEN INFIELD(b)                                                                                                            
           CALL cl_init_qry_var()                                                                                                   
           LET g_qryparam.form='q_aaa'                                                                                              
           LET g_qryparam.default1=b                                                                                                
           CALL cl_create_qry()  RETURNING b                                                                                        
           DISPLAY BY NAME b                                                                                                        
           NEXT FIELD b 
         WHEN INFIELD(aag01)
           CALL cl_init_qry_var()
           LET g_qryparam.form = 'q_aag'
           LET g_qryparam.state= 'c'
           LET g_qryparam.where = " aag00 = '",b CLIPPED,"'"           
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO aag01
           NEXT FIELD aag01        
         WHEN INFIELD(bb)
           CALL cl_init_qry_var()
           LET g_qryparam.form = 'q_azi'
           LET g_qryparam.default1 = tm.bb
           CALL cl_create_qry() RETURNING tm.bb
           DISPLAY BY NAME tm.bb
         OTHERWISE  EXIT CASE
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
      CLOSE WINDOW gglr320_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglr320'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglr320','9031',1)
       ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",b CLIPPED,"'",   #No.FUN-740055 
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yyyy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.nn CLIPPED,"'",
                         " '",tm.p  CLIPPED,"'",
                         " '",tm.bb CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
          CALL cl_cmdat('gglr320',g_time,l_cmd)	# Execute cmd at later time
       END IF
       CLOSE WINDOW gglr320_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglr320()
    ERROR ""
  END WHILE
  CLOSE WINDOW gglr320_w
END FUNCTION
 
FUNCTION gglr320()
 
   DEFINE l_name	LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0097
          l_sql 	LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_mm          LIKE type_file.num5,       #NO FUN-690009   SMALLINT   # add 030731 NO.A085
          l_aag02_o     LIKE aag_file.aag02,       #NO FUN-690009   VARCHAR(30)   # add 030814 NO.A085
          l_aag02_o_t   LIKE aag_file.aag02,       #NO FUN-690009   VARCHAR(30)   # add 030814 NO.A085
          l_aag13_o     LIKE aag_file.aag13,       #FUN-6C0012
          l_aag13_o_t   LIKE aag_file.aag13,       #FUN-6C0012
          l_aag01       LIKE aag_file.aag01,       # add 030819 NO.A085
          l_aag02       LIKE aag_file.aag02,       # add 030819 NO.A085
          l_aag13       LIKE aag_file.aag13,       #FUN-6C0012
           l_abb01      LIKE abb_file.abb01,       #No.MOD-570145
          l_za05	LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(40)
          #FUN-870029 - START
          l_bdate        LIKE type_file.dat,
          l_edate       LIKE type_file.dat, 
          sub_tas04     LIKE tas_file.tas04,    
          sub_tas05     LIKE tas_file.tas05,    
          sub_tas09     LIKE type_file.num20_6, 
          sub_tas10     LIKE type_file.num20_6, 
          l_preaba02    LIKE aba_file.aba01,
          l_prem_aba02  LIKE type_file.num5,
          l_preaag01    LIKE aag_file.aag01,
          l_aah04       LIKE aah_file.aah04,
          l_aah05       LIKE aah_file.aah05,
          l_tah09       LIKE tah_file.tah09,
          l_tah04       LIKE tah_file.tah04,
          l_tah10       LIKE tah_file.tah10,
          l_tah05       LIKE tah_file.tah05,
          l_page        LIKE type_file.num10,
          srtmp  RECORD
                    aag01  LIKE aag_file.aag01,
                    m_aba02 LIKE type_file.num5,
                    aba02  LIKE aba_file.aba02,
                    aas04  LIKE aas_file.aas04,
                    aas05  LIKE aas_file.aas05,
                    tas04  LIKE tas_file.tas04,
                    tas05  LIKE tas_file.tas05,
                    tas09  LIKE tas_file.tas05,
                    tas10  LIKE tas_file.tas05,
                    s_tas04  LIKE tas_file.tas04,
                    s_tas05  LIKE tas_file.tas05,
                    s_tas09  LIKE tas_file.tas09,
                    s_tas10  LIKE tas_file.tas10,
                    tah04 LIKE tah_file.tah04,
                    tah05 LIKE tah_file.tah05,
                    tah09 LIKE tah_file.tah09,
                    tah10 LIKE tah_file.tah10
                 END RECORD,
          #FUN-870029 - END 
          sr     RECORD
                    m_aba02 LIKE type_file.num5,   #NO FUN-690009   SMALLINT
                    aag01   LIKE aag_file.aag01,   # acct. name
                    aag02   LIKE aag_file.aag02,   # acct. name
                    aag13   LIKE aag_file.aag13,   #FUN-6C0012
                    aba02   LIKE aba_file.aba02,
                    aba04   LIKE aba_file.aba04,
                    abb     RECORD LIKE abb_file.*,
                    abbl    RECORD LIKE abb_file.*,
                    aas     RECORD LIKE aas_file.*,
                    tas     RECORD LIKE tas_file.*,
                    aah     RECORD LIKE aah_file.*,
                    tah     RECORD LIKE tah_file.*,
                    b_bal   LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    b_balf  LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6) 
                    b_d     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    b_df    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_df    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    b_c     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    b_cf    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_cf    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    bala    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    balaf   LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_d     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_c     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    balb    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    balbf   LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    bald    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    baldf   LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    balc    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    balcf   LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_abb07_l  LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_abb07_r  LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    s_aas04    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    s_aas05    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    s_tas04    LIKE tas_file.tas04,       #NO FUN-690009   DECIMAL(20,6)
                    s_tas05    LIKE tas_file.tas05,       #NO FUN-690009   DECIMAL(20,6)
                    s_tas09    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    s_tas10    LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_abb07f_l LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_abb07f_r LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
                    l_aba02    LIKE aba_file.aba02,       #NO FUN-690009   DATE
                    aag02_o    LIKE aag_file.aag02,       #NO FUN-690009   VARCHAR(30)
                    aag13_o    LIKE aag_file.aag13,       #FUN-6C0012
                    l_aba04    LIKE aba_file.aba04,       #NO FUN-690009   SMALLINT
                     l_abb01   LIKE abb_file.abb01,       #No.MOD-570145
                    l_abb06    LIKE abb_file.abb06,       #NO FUN-690009   VARCHAR(01)
                    l_abb02    LIKE abb_file.abb02,       #NO FUN-690009   SMALLINT
                    l_bala     LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)   # add 030819 NO.A085
                    l_balaf    LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)   # add 030819 NO.A085
                END RECORD
 
     #No.FUN-B80096--mark--Begin---  
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     #FUN-870029 - START 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>*** ##
     CALL cl_del_data(l_table)
    #DELETE FROM r320_tmp #TQC-940044  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     LET l_page = 0
     #FUN-870029 - END
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #add 030731 NO.A085
#     LET l_sql = "SELECT tpg04 FROM tpg_file ",
#                " WHERE tpg01 = ",tm.yyyy,
#                "   AND tpg02 = ? ",
#                "   AND tpg03 = ? ",
#                "   AND tpg05 = 'gglr320' "
#    PREPARE prepare_pageno FROM l_sql
#    IF STATUS THEN
#       CALL cl_err('prepare_pageno',STATUS,0) EXIT PROGRAM
#    END IF
#    DECLARE curs_pageno CURSOR FOR prepare_pageno
#     ###
  #  SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = b   #No.FUN-740055 
  #		AND aaf02 = g_lang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr320'
       IF g_len = 0 OR g_len IS NULL THEN LET g_len = 160 END IF
     #使用預設帳別之幣別
     IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
     #SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aaa03    #No.CHI-6A0004   #MOD-780004
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
 
#No.FUN-570083 --start
     LET l_sql = " SELECT aag01,aag02,aag13",  #FUN-6C0012
                 "   FROM aag_file ",
                 "  WHERE aag19 = 1 ",
                 "   AND  aag00 ='",b,"' ",  #No.FUN-740055  
                 "   AND ",tm.wc CLIPPED
#No.FUN-570083 --end
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql , "  AND aag09 = 'Y'  "
     END IF 
     #No.MOD-860252---end---
     PREPARE prepare_aag FROM l_sql
     DECLARE curs_aag CURSOR FOR prepare_aag
#     LET g_pageno = 0         #No.FUN-890102
#     CALL cl_outnam('gglr320') RETURNING l_name
     IF tm.p = 'N'
       THEN LET g_aac13 = 'N' #LET g_abb24 = g_aaa03   #MOD-780004
#       START REPORT gglr320_rep TO l_name             #No.FUN-890102
#       LET g_pageno = 0                               #No.FUN-890102
     ELSE
       LET g_aac13 = 'Y' #LET g_abb24 = tm.bb   #MOD-780004
#       START REPORT gglr320_rep_f TO l_name           #No.FUN-890102
#       LET g_pageno = 0                               #No.FUN-890102
     END IF
     #NO:7911
     #SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_abb24      #No.CHI-6A0004   #MOD-780004
     SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01 = tm.bb   #MOD-780004
     #NO:7911 end
    ### add by NO.A085
     INITIALIZE sr.* TO NULL
     LET g_count    = 0
     ###
 
     FOREACH curs_aag INTO sr.aag01,sr.aag02,sr.aag13   #FUN-6C0012
     ### add by NO.A085
       LET sr.l_bala   = NULL
       LET sr.l_balaf  = NULL
     ###
 
       #-----MOD-780004---------
#      {
#      SELECT MAX(aba04) INTO sr.l_aba04
#        FROM aba_file,abb_file
#          WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01   #No.FUN-740055 
#            AND abb03 = sr.aag01   AND aba03 = tm.yyyy
#            AND abb24 = g_abb24    AND aba04 >= tm.mm
#            AND aba04 <= tm.nn     AND abapost = 'Y'
#          
#      }
       IF tm.p = 'N' THEN
          SELECT MAX(aba04) INTO sr.l_aba04
            FROM aba_file,abb_file
              WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01
                AND abb03 = sr.aag01   AND aba03 = tm.yyyy
                AND aba04 >= tm.mm
                AND aba04 <= tm.nn     AND abapost = 'Y'
              
       ELSE
          SELECT MAX(aba04) INTO sr.l_aba04
            FROM aba_file,abb_file
              WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01
                AND abb03 = sr.aag01   AND aba03 = tm.yyyy
                AND abb24 = tm.bb    AND aba04 >= tm.mm
                AND aba04 <= tm.nn     AND abapost = 'Y'
              
       END IF
       #-----END MOD-780004-----
       ###add 030813 NO.A085
       LET g_cont_aba = 0
       IF cl_null(sr.l_aba04) THEN LET sr.l_aba04 = -1 END IF
       IF sr.l_aba04 < tm.mm OR sr.l_aba04 > tm.nn THEN
          LET g_cont_aba = tm.mm - 1
          LET sr.l_aba04 = tm.nn
       ELSE
          IF (sr.l_aba04 <= tm.nn) THEN
             LET g_cont_aba = sr.l_aba04
             LET sr.l_aba04 = tm.nn
          END IF
       END IF
       ###
       #-----MOD-780004---------
#      {
#      DECLARE curs_d CURSOR FOR
#        SELECT DISTINCT aba02
#          FROM aba_file,abb_file
#            WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01   #No.FUN-740055 
#              AND abb03 = sr.aag01   AND abb24 = g_abb24
#              AND aba03 = tm.yyyy    AND aba04 >= tm.mm
#              AND aba04 <= tm.nn     AND abapost = 'Y'
#            
#      }
       LET l_sql = "SELECT DISTINCT aba02 FROM aba_file,abb_file ",
                   " WHERE aba00 ='",b,"' AND aba00 = abb00 AND aba01 = abb01 ",
                   " AND abb03 ='",sr.aag01,"' ",
                   " AND aba03 ='",tm.yyyy,"' AND aba04 >= '",tm.mm,"' ",
                   " AND aba04 <='",tm.nn,"' AND abapost = 'Y'" 
       IF tm.p = 'Y' THEN
          LET l_sql = l_sql , " AND abb24 = '",tm.bb,"' "
       ELSE
          LET l_sql = l_sql , " "
       END IF
       PREPARE curs_p FROM l_sql
       DECLARE curs_d CURSOR FOR curs_p
       #-----END MOD-780004-----
       FOREACH curs_d INTO sr.aba02
         LET sr.m_aba02 = MONTH(sr.aba02)
         #-----MOD-780004---------
#        {
#        DECLARE curs_last SCROLL CURSOR FOR
#        SELECT abb01,abb02,abb06
#          FROM aba_file,abb_file
#            WHERE aba00 = abb00 AND aba00 = b AND aba01 = abb01   #No.FUN-740055 
#              AND abb24 = g_abb24
#              AND aba02 = sr.aba02 AND abb03 = sr.aag01 AND abapost = 'Y'
#            ORDER BY abb01,abb02,abb06
#        }
         LET l_sql = "SELECT abb01,abb02,abb06 FROM aba_file,abb_file ",
                     " WHERE aba00 = abb00 AND aba00 ='",b,"' AND aba01 = abb01 ",
                     " AND aba02 ='",sr.aba02,"' AND abb03 ='",sr.aag01,"' AND abapost = 'Y'"
         IF tm.p = 'Y' THEN
            LET l_sql = l_sql ," AND abb24 = '",tm.bb,"' ORDER BY abb01,abb02,abb06"
         ELSE
            LET l_sql = l_sql ," ORDER BY abb01,abb02,abb06"
         END IF
         PREPARE curs_last_p FROM l_sql
         DECLARE curs_last SCROLL CURSOR FOR curs_last_p
         #-----END MOD-780004-----
         OPEN curs_last
         FETCH LAST curs_last INTO sr.abbl.abb01,sr.abbl.abb02,sr.abbl.abb06
         CLOSE curs_last
         #-----MOD-780004---------
#        {
#        SELECT MAX(abb02) INTO sr.abbl.abb02 FROM abb_file
#            WHERE abb00 = b       AND abb01 = sr.abbl.abb01    #No.FUN-740055 
#              AND abb06 != sr.abbl.abb06 AND abb24 = g_abb24
#             ### add 030814 NO.A085
#              AND abb03 = sr.aag01
#              ###
#              
#        SELECT MAX(aba02) INTO sr.l_aba02
#          FROM aba_file,abb_file
#            WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01   #No.FUN-740055 
#              AND aba03 = tm.yyyy
#              AND abb03 = sr.aag01   AND abb24 = g_abb24
#              AND MONTH(aba02) = MONTH(sr.aba02) AND abapost = 'Y'
#            
#        DECLARE curs_table CURSOR FOR
#          SELECT DISTINCT abb01,abb06 FROM aba_file,abb_file
#            WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01  #No.FUN-740055 
#              AND abb03 = sr.aag01   AND abb24 = g_abb24
#              AND aba03 = tm.yyyy    AND aba04 >= tm.mm
#              AND aba04 <= tm.nn     AND abapost = 'Y'
#            
#        }
         IF tm.p = 'N' THEN
            SELECT MAX(abb02) INTO sr.abbl.abb02 FROM abb_file
                WHERE abb00 = b   AND abb01 = sr.abbl.abb01
                  AND abb06 != sr.abbl.abb06
                  AND abb03 = sr.aag01
                  
            SELECT MAX(aba02) INTO sr.l_aba02
              FROM aba_file,abb_file
                WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01
                  AND aba03 = tm.yyyy
                  AND abb03 = sr.aag01   
                  AND MONTH(aba02) = MONTH(sr.aba02) AND abapost = 'Y'
                
         ELSE
            SELECT MAX(abb02) INTO sr.abbl.abb02 FROM abb_file
                WHERE abb00 = b   AND abb01 = sr.abbl.abb01
                  AND abb06 != sr.abbl.abb06 AND abb24 = tm.bb
                  AND abb03 = sr.aag01
                  
            SELECT MAX(aba02) INTO sr.l_aba02
              FROM aba_file,abb_file
                WHERE aba00 = b   AND aba00 = abb00 AND aba01 = abb01
                  AND aba03 = tm.yyyy
                  AND abb03 = sr.aag01   AND abb24 = tm.bb
                  AND MONTH(aba02) = MONTH(sr.aba02) AND abapost = 'Y'
                
         END IF
         LET l_sql = "SELECT DISTINCT abb01,abb06 FROM aba_file,abb_file ",
                     " WHERE aba00 = '",b,"' AND aba00 = abb00 AND aba01 = abb01 ",
                     "   AND abb03 = '",sr.aag01,"' ",
                     "   AND aba03 = '",tm.yyyy,"' AND aba04 >= '",tm.mm,"' ",
                     "   AND aba04 <= '",tm.nn,"' AND abapost = 'Y'"
         IF tm.p = 'Y' THEN
            LET l_sql = l_sql," AND abb24='",tm.bb,"' "
         ELSE
            LET l_sql = l_sql," "
         END IF
         PREPARE curs_table_p FROM l_sql
         DECLARE curs_table CURSOR FOR curs_table_p
         #-----END MOD-780004-----
          LET l_abb01 = ''                      #No.MOD-570145
         FOREACH curs_table INTO g_abb01,g_abb06
 #No.MOD-570145--begin
           IF g_abb01  = l_abb01 THEN
              CONTINUE FOREACH
           END IF
           LET l_abb01 = g_abb01
 #No.MOD-570145--end
           DECLARE curs_content CURSOR FOR
             SELECT aba02,aba04,abb_file.*
               FROM aba_file,abb_file
                 WHERE aba00 = abb00    AND aba00 =b   #No.FUN-740055 
                   AND aba01 = abb01
                   AND aba02 = sr.aba02
                   AND abb01 = g_abb01
                  ### add 030814 NO.A085
                   AND abb03 = sr.aag01
                   AND aba19 <> 'X'  #CHI-C80041
                 # AND abb06 != g_abb06 AND abapost = 'Y'
                   ###
                 ORDER BY aba02,abb01,abb02
           FOREACH curs_content INTO sr.aba02,sr.aba04,sr.abb.*
            ###add 030814 NO.A085
             IF cl_null(sr.aba04) THEN
                CONTINUE FOREACH
             END IF
             LET sr.aag02_o = ' '
             LET l_aag02_o  = ' '
             LET sr.aag13_o = ' '  #FUN-6C0012
             LET l_aag13_o  = ' '  #FUN-6C0012
             DECLARE curs_aag02 CURSOR FOR
               SELECT aag02,aag13 FROM aag_file,abb_file   #FUN-6C0012
                WHERE abb00 = b AND abb01 = g_abb01   #No.FUN-740055 
#                 AND aag01 = abb03    AND abb06!= g_abb06
                   AND aag01 = abb03    AND abb06!= sr.abb.abb06  AND aag00 = abb00        #No.MOD-570145   #FUN-C10024 add "AND aag00 = abb00"
             FOREACH curs_aag02 INTO l_aag02_o,l_aag13_o   #FUN-6C0012
             IF cl_null(l_aag02_o) THEN LET l_aag02_o = '' END IF
             LET l_aag02_o_t   = sr.aag02_o CLIPPED
             IF cl_null(l_aag13_o) THEN LET l_aag13_o = '' END IF   #FUN-6C0012
             LET l_aag13_o_t   = sr.aag13_o CLIPPED                 #FUN-6C0012
             IF cl_null(sr.aag02_o) OR sr.aag02_o = '' THEN
                LET sr.aag02_o = l_aag02_o CLIPPED
             ELSE
                LET sr.aag02_o = sr.aag02_o CLIPPED,',',l_aag02_o CLIPPED
             END IF
             #FUN-6C0012.....begin
             IF cl_null(sr.aag13_o) OR sr.aag13_o = '' THEN                     
                LET sr.aag13_o = l_aag13_o CLIPPED                              
             ELSE                                                               
                LET sr.aag13_o = sr.aag13_o CLIPPED,',',l_aag13_o CLIPPED       
             END IF
             IF tm.e = 'N' THEN
                IF LENGTH(sr.aag02_o) < 30 THEN                                 
                   CONTINUE FOREACH                                             
                ELSE                                                            
                   LET sr.aag02_o = l_aag02_o_t CLIPPED                         
                   EXIT FOREACH                                                 
                END IF                                                          
             ELSE                                                               
                IF LENGTH(sr.aag13_o) < 30 THEN                                 
                   CONTINUE FOREACH                                             
                ELSE                                                            
                   LET sr.aag13_o = l_aag13_o_t CLIPPED                         
                   EXIT FOREACH                                                 
                END IF                                                          
             END IF
             #FUN-6C0012.....end
             END FOREACH
             ###
              SELECT COUNT(*) INTO g_no FROM abb_file
               WHERE abb00 = b AND abb01 = g_abb01  #No.FUN-740055 
               ###add 030820 NO.A085
               # AND abb06 != g_abb06 AND abb24 = g_abb24
               ###
             IF g_no = 1 THEN
               #-----MOD-780004---------
               {
               SELECT abb07,abb07f INTO sr.abb.abb07,sr.abb.abb07f FROM abb_file
                   WHERE abb00 = b AND abb01 = g_abb01   #No.FUN-740055 
                     AND abb03 = sr.aag01 AND abb24 = g_abb24
               }
               IF tm.p = 'N' THEN
                  SELECT abb07,abb07f INTO sr.abb.abb07,sr.abb.abb07f FROM abb_file
                      WHERE abb00 = b AND abb01 = g_abb01
                        AND abb03 = sr.aag01 
               ELSE
                  SELECT abb07,abb07f INTO sr.abb.abb07,sr.abb.abb07f FROM abb_file
                      WHERE abb00 = b AND abb01 = g_abb01
                        AND abb03 = sr.aag01 AND abb24 = tm.bb
               END IF
               #-----END MOD-780004-----
             END IF
              #-----MOD-780004---------
              IF sr.abb.abb07 IS NULL THEN LET sr.abb.abb07 = 0 END IF
              IF sr.abb.abb07f IS NULL THEN LET sr.abb.abb07f = 0 END IF
              #-----END MOD-780004-----
              IF sr.abb.abb06 = '2' THEN        #No.MOD-570145
                LET sr.l_abb07_r = sr.abb.abb07
                LET sr.l_abb07f_r= sr.abb.abb07f
                LET sr.l_abb07_l = 0
                LET sr.l_abb07f_l= 0
             ELSE
                LET sr.l_abb07_r = 0
                LET sr.l_abb07f_r= 0
                LET sr.l_abb07_l = sr.abb.abb07
                LET sr.l_abb07f_l= sr.abb.abb07f
             END IF
             IF sr.s_aas04 IS NULL THEN LET sr.s_aas04 = 0 END IF
             IF sr.s_aas05 IS NULL THEN LET sr.s_aas05 = 0 END IF
             IF sr.s_tas04 IS NULL THEN LET sr.s_tas04 = 0 END IF
             IF sr.s_tas05 IS NULL THEN LET sr.s_tas05 = 0 END IF
             IF sr.s_tas09 IS NULL THEN LET sr.s_tas09 = 0 END IF
             IF sr.s_tas10 IS NULL THEN LET sr.s_tas10 = 0 END IF
             LET sr.s_aas04 = sr.s_aas04 + sr.l_abb07_l
             LET sr.s_aas05 = sr.s_aas05 + sr.l_abb07_r
             LET sr.s_tas04 = sr.s_tas04 + sr.l_abb07_l
             LET sr.s_tas05 = sr.s_tas05 + sr.l_abb07_r
             LET sr.s_tas09 = sr.s_tas09 + sr.l_abb07f_l
             LET sr.s_tas10 = sr.s_tas10 + sr.l_abb07f_r
             IF sr.l_abb07_l = 0 THEN LET sr.l_abb07_l = null END IF
             IF sr.l_abb07_r = 0 THEN LET sr.l_abb07_r = null END IF
             IF sr.l_abb07f_l= 0 THEN LET sr.l_abb07f_l = null END IF
             IF sr.l_abb07f_r= 0 THEN LET sr.l_abb07f_r = null END IF
             IF tm.p = 'N' THEN
                  SELECT SUM(aah04-aah05) INTO sr.b_bal FROM aah_file
                    WHERE aah00 = b AND aah01 = sr.aag01   #No.FUN-740055 
                       AND aah02 = tm.yyyy  AND aah03 ='0'   #No.MOD-560110
                  IF sr.b_bal IS NULL THEN LET sr.b_bal = 0 END IF
                  SELECT SUM(aah04),SUM(aah05) INTO sr.b_d,sr.b_c FROM aah_file
                    WHERE aah00 = b  AND aah01 = sr.aag01  #No.FUN-740055 
                      AND aah02 = tm.yyyy
                      AND aah03 <= MONTH(sr.aba02)-1
                      AND aah03 <> '0'   #MOD-780004
                  IF sr.b_d IS NULL THEN LET sr.b_d = 0 END IF
                  IF sr.b_c IS NULL THEN LET sr.b_c = 0 END IF
                  SELECT SUM(aah04),SUM(aah05) INTO sr.l_d,sr.l_c FROM aah_file
                   WHERE aah00 = b AND aah01 = sr.aag01 AND aah02 = tm.yyyy   #No.FUN-740055 
                     #AND aah03 <= MONTH(sr.aba02) AND aah03 > 1   #MOD-780004
                     AND aah03 <= MONTH(sr.aba02) AND aah03 > 0   #MOD-780004
                  IF sr.l_d IS NULL THEN LET sr.l_d = 0 END IF
                  IF sr.l_c IS NULL THEN LET sr.l_c = 0 END IF
                  SELECT aah04,aah05 INTO sr.aah.aah04,sr.aah.aah05 FROM aah_file
                    WHERE aah00 = b AND aah01 = sr.aag01  #No.FUN-740055 
                      AND aah02 = tm.yyyy  AND aah03 = MONTH(sr.aba02)
                  IF sr.aah.aah04 IS NULL THEN LET sr.aah.aah04 = 0 END IF
                  IF sr.aah.aah05 IS NULL THEN LET sr.aah.aah05 = 0 END IF
                  IF MONTH(sr.aba02) = '1'
                    THEN LET sr.bala = sr.b_bal
                    ELSE LET sr.bala = sr.b_bal +( sr.b_d - sr.b_c)
                  END IF
                  #-----MOD-780004---------
                  IF cl_null(sr.l_bala) THEN
                     LET sr.l_bala  = sr.bala
                     IF cl_null(sr.l_bala) THEN LET sr.l_bala = 0 END IF
                  END IF
                  #-----END MOD-780004-----
                  LET sr.balc = sr.b_bal +( sr.l_d - sr.l_c)
                  LET sr.bald = sr.b_bal + sr.l_d - sr.l_c
                   #add 030731 NO.A085
                  LET l_mm = 0
                  LET l_mm = tm.mm - 1
#                  OPEN curs_pageno USING l_mm,sr.aag01               #No.FUN-890102 
#                  FETCH curs_pageno INTO g_pageno                    #No.FUN-890102
#                  IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF  #No.FUN-890102
                  LET g_cn = 0
                  ###
#                  OUTPUT TO REPORT gglr320_rep(sr.*)   #No.FUN-890102
                  #FUN-870029 - START 
                  EXECUTE insert_prep USING
                   sr.m_aba02, sr.aag01, sr.aag02, sr.aag13, sr.aba02, sr.aba04,
                   sr.abb.abb01,  sr.abb.abb02,  sr.abb.abb04,  sr.abb.abb24,
                   sr.abb.abb25,  sr.aas.aas04,  sr.aas.aas05,  sr.tas.tas04,
                   sr.tas.tas05,  sr.tas.tas09,  sr.tas.tas10,  sr.aah.aah04,
                   sr.aah.aah05,  sr.tah.tah04,  sr.tah.tah05,  sr.tah.tah09,
                   sr.tah.tah10,  sr.b_bal,      sr.b_balf,     sr.b_d,
                   sr.b_df,       sr.l_df,       sr.b_c,        sr.b_cf,
                   sr.l_cf,       sr.bala,       sr.balaf,      sr.l_d,
                   sr.l_c,        sr.balb,       sr.balbf,      sr.bald,
                   sr.baldf,      sr.balc,       sr.balcf,      sr.l_abb07_l,
                   sr.l_abb07_r,  sr.s_aas04,    sr.s_aas05,    sr.s_tas04,
                   sr.s_tas05,    sr.s_tas09,    sr.s_tas10,    sr.l_abb07f_l,
                   sr.l_abb07f_r, sr.l_aba02,    sr.aag02_o,
                   sr.aag13_o,    sr.l_aba04,    sr.l_abb01,    sr.l_abb06,
                   sr.l_abb02,    sr.l_bala,     sr.l_balaf,    g_azi04,
                   g_azi07 ,      t_azi04,       t_azi07,       g_aaz.aaz51,
                   sub_tas04,     sub_tas05,     sub_tas09,     sub_tas10,
                   l_page  
                   #FUN-870029 - END 
 
             ELSE
                SELECT SUM(tah04-tah05) INTO sr.b_bal FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    #AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '1'   #MOD-780004
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '0'   #MOD-780004
                IF sr.b_bal IS NULL THEN LET sr.b_bal = 0 END IF
                SELECT SUM(tah09-tah10) INTO sr.b_balf FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    #AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '1'   #MOD-780004
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '0'   #MOD-780004
                IF sr.b_balf IS NULL THEN LET sr.b_balf = 0 END IF
                SELECT SUM(tah04),SUM(tah05) INTO sr.b_d,sr.b_c FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb
                    AND MONTH(sr.aba02)>= 2
                    AND tah03 < MONTH(sr.aba02)
                    AND tah03 <> '0'   #MOD-780004
                IF sr.b_d IS NULL THEN LET sr.b_d = 0 END IF
                IF sr.b_c IS NULL THEN LET sr.b_c = 0 END IF
                SELECT SUM(tah09),SUM(tah10) INTO sr.b_df,sr.b_cf FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01   #No.FUN-740055 
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb
                    AND MONTH(sr.aba02)>= 2
                    AND tah03 < MONTH(sr.aba02)
                    AND tah03 <> '0'   #MOD-780004
                IF sr.b_df IS NULL THEN LET sr.b_df = 0 END IF
                IF sr.b_cf IS NULL THEN LET sr.b_cf = 0 END IF
                SELECT tah04,tah05,tah09,tah10 INTO
                       sr.tah.tah04,sr.tah.tah05,sr.tah.tah09,sr.tah.tah10
                       FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    AND tah02 = tm.yyyy AND tah03 = MONTH(sr.aba02)
                    AND tah08 = tm.bb
                IF sr.tah.tah04 IS NULL THEN LET sr.tah.tah04 = 0 END IF
                IF sr.tah.tah05 IS NULL THEN LET sr.tah.tah05 = 0 END IF
                IF sr.tah.tah09 IS NULL THEN LET sr.tah.tah09 = 0 END IF
                IF sr.tah.tah10 IS NULL THEN LET sr.tah.tah10 = 0 END IF
                SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
                  INTO sr.l_d,sr.l_c,sr.l_df,sr.l_cf FROM tah_file
                 WHERE tah00 = b AND tah01 = sr.aag01   #No.FUN-740055 
                   AND tah02 = tm.yyyy AND tah03 <= MONTH(sr.aba02)
                   #AND tah08 = tm.bb   AND tah03 > 1   #MOD-780004
                   AND tah08 = tm.bb   AND tah03 > 0   #MOD-780004
                IF sr.l_d IS  NULL THEN LET sr.l_d = 0  END IF
                IF sr.l_c IS  NULL THEN LET sr.l_c = 0  END IF
                IF sr.l_df IS NULL THEN LET sr.l_df = 0 END IF
                IF sr.l_cf IS NULL THEN LET sr.l_cf = 0 END IF
                IF MONTH(sr.aba02) = '1' THEN
#---------- year begin balance ------------------------------------------------
                    LET sr.bala  = sr.b_bal
                    LET sr.balaf = sr.b_balf
#---------- month begin D / C ------------------------------------------------
                ELSE
                    LET sr.bala = sr.b_bal +( sr.b_d - sr.b_c)
                    LET sr.balaf = sr.b_balf +(sr.b_df-sr.b_cf)
                END IF
                #-----MOD-780004---------
                IF cl_null(sr.l_bala) OR cl_null(sr.l_balaf) THEN
                   LET sr.l_bala   = sr.bala
                   LET sr.l_balaf  = sr.balaf
                   IF cl_null(sr.l_bala)  THEN LET sr.l_bala = 0 END IF
                   IF cl_null(sr.l_balaf) THEN LET sr.l_balaf= 0 END IF
                END IF
                #-----END MOD-780004-----
#---------- monthly tot D / C ------------------------------------------------
                    LET sr.balc = sr.b_bal +( sr.l_d - sr.l_c)
                    LET sr.balcf = sr.b_balf+( sr.l_df - sr.l_cf)
#----------year tot D/C------------------------------------------------------
                    LET sr.bald = sr.b_bal +sr.l_d - sr.l_c
                    LET sr.baldf = sr.b_balf +sr.l_df - sr.l_cf
                    #add 030731 NO.A085
                    LET l_mm = tm.mm - 1
#                    OPEN curs_pageno USING l_mm,sr.aag01               #No.FUN-890102
#                    FETCH curs_pageno INTO g_pageno                    #No.FUN-890102
#                    IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF  #No.FUN-890102
                    LET g_cn = 0
                    ###
#                    OUTPUT TO REPORT gglr320_rep_f(sr.*)    #No.FUN-890102
                  #FUN-870029 - START 
                  EXECUTE insert_prep USING
                   sr.m_aba02, sr.aag01, sr.aag02, sr.aag13, sr.aba02, sr.aba04,
                   sr.abb.abb01,  sr.abb.abb02,  sr.abb.abb04,  sr.abb.abb24,
                   sr.abb.abb25,  sr.aas.aas04,  sr.aas.aas05,  sr.tas.tas04,
                   sr.tas.tas05,  sr.tas.tas09,  sr.tas.tas10,  sr.aah.aah04,
                   sr.aah.aah05,  sr.tah.tah04,  sr.tah.tah05,  sr.tah.tah09,
                   sr.tah.tah10,  sr.b_bal,      sr.b_balf,     sr.b_d,
                   sr.b_df,       sr.l_df,       sr.b_c,        sr.b_cf,
                   sr.l_cf,       sr.bala,       sr.balaf,      sr.l_d,
                   sr.l_c,        sr.balb,       sr.balbf,      sr.bald,
                   sr.baldf,      sr.balc,       sr.balcf,      sr.l_abb07_l,
                   sr.l_abb07_r,  sr.s_aas04,    sr.s_aas05,    sr.s_tas04,
                   sr.s_tas05,    sr.s_tas09,    sr.s_tas10,    sr.l_abb07f_l,
                   sr.l_abb07f_r, sr.l_aba02,    sr.aag02_o,
                   sr.aag13_o,    sr.l_aba04,    sr.l_abb01,    sr.l_abb06,
                   sr.l_abb02,    sr.l_bala,     sr.l_balaf,    g_azi04,
                   g_azi07 ,      t_azi04,       t_azi07,       g_aaz.aaz51, 
                   sub_tas04,     sub_tas05,     sub_tas09,     sub_tas10,
                   l_page  
                   #FUN-870029 - END 
             END IF
           END FOREACH
           LET sr.abbl.abb25 = sr.abb.abb25
         END FOREACH
       END FOREACH
       LET sr.s_aas04 = 0
       LET sr.s_aas05 = 0
       LET sr.s_tas04 = 0
       LET sr.s_tas05 = 0
       LET sr.s_tas09 = 0
       LET sr.s_tas10 = 0
       ### add by NO.A085
       IF (g_cont_aba < tm.nn) OR (g_cont_aba < tm.nn OR g_cont_aba > tm.nn) THEN
          FOR g_count = g_cont_aba+1 TO tm.nn
             IF tm.p = 'N' THEN
              SELECT SUM(aah04-aah05) INTO sr.b_bal FROM aah_file
               WHERE aah00 = b AND aah01 = sr.aag01  #No.FUN-740055 
                  AND aah02 = tm.yyyy  AND aah03 ='0'   #No.MOD-560110
              IF sr.b_bal IS NULL THEN LET sr.b_bal = 0 END IF
                 SELECT SUM(aah04),SUM(aah05) INTO sr.b_d,sr.b_c FROM aah_file
                  WHERE aah00 = b AND aah01 = sr.aag01   #No.FUN-740055 
                    AND aah02 = tm.yyyy  AND aah03 <= g_count-1
                    AND aah03 <> '0'   #MOD-780004
                 IF sr.b_d IS NULL THEN LET sr.b_d = 0 END IF
                 IF sr.b_c IS NULL THEN LET sr.b_c = 0 END IF
                 SELECT SUM(aah04),SUM(aah05) INTO sr.l_d,sr.l_c FROM aah_file
                  WHERE aah00 = b AND aah01 = sr.aag01 AND aah02 = tm.yyyy   #No.FUN-740055 
                    #AND aah03 <= g_count AND aah03 > 1   #MOD-780004
                    AND aah03 <= g_count AND aah03 > 0   #MOD-780004
                 IF sr.l_d IS NULL THEN LET sr.l_d = 0 END IF
                 IF sr.l_c IS NULL THEN LET sr.l_c = 0 END IF
                 SELECT aah04,aah05 INTO sr.aah.aah04,sr.aah.aah05 FROM aah_file
                  WHERE aah00 = b AND aah01 = sr.aag01   #No.FUN-740055 
                    AND aah02 = tm.yyyy  AND aah03 = g_count
                 IF sr.aah.aah04 IS NULL THEN LET sr.aah.aah04 = 0 END IF
                 IF sr.aah.aah05 IS NULL THEN LET sr.aah.aah05 = 0 END IF
                 IF g_count = 1
                    THEN LET sr.bala = sr.b_bal
                    ELSE LET sr.bala = sr.b_bal +( sr.b_d - sr.b_c)
                 END IF
                 LET sr.balc = sr.b_bal +( sr.l_d - sr.l_c)
                 LET sr.bald = sr.b_bal + sr.l_d - sr.l_c
                 #add 030731 NO.A085
                 LET l_mm = 0
                 LET l_mm = tm.mm - 1
#                 OPEN curs_pageno USING l_mm,sr.aag01                #No.FUN-890102
#                 FETCH curs_pageno INTO g_pageno                     #No.FUN-890102
#                 IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF   #No.FUN-890102
                 LET g_cn = 0
                 ###
                 LET sr.m_aba02 = g_count
                 LET sr.aba02 = NULL
                 IF sr.m_aba02 = tm.nn THEN
                    LET sr.aba04 = tm.nn
                 ELSE
                    LET sr.aba04 = g_count
                 END IF
                 #IF sr.bala > 0  THEN   #MOD-780004
#                    OUTPUT TO REPORT gglr320_rep(sr.*)   #No.FUN-890102
                  #FUN-870029 - START 
                  EXECUTE insert_prep USING
                   sr.m_aba02, sr.aag01, sr.aag02, sr.aag13, sr.aba02, sr.aba04,
                   sr.abb.abb01,  sr.abb.abb02,  sr.abb.abb04,  sr.abb.abb24,
                   sr.abb.abb25,  sr.aas.aas04,  sr.aas.aas05,  sr.tas.tas04,
                   sr.tas.tas05,  sr.tas.tas09,  sr.tas.tas10,  sr.aah.aah04,
                   sr.aah.aah05,  sr.tah.tah04,  sr.tah.tah05,  sr.tah.tah09,
                   sr.tah.tah10,  sr.b_bal,      sr.b_balf,     sr.b_d,
                   sr.b_df,       sr.l_df,       sr.b_c,        sr.b_cf,
                   sr.l_cf,       sr.bala,       sr.balaf,      sr.l_d,
                   sr.l_c,        sr.balb,       sr.balbf,      sr.bald,
                   sr.baldf,      sr.balc,       sr.balcf,      sr.l_abb07_l,
                   sr.l_abb07_r,  sr.s_aas04,    sr.s_aas05,    sr.s_tas04,
                   sr.s_tas05,    sr.s_tas09,    sr.s_tas10,    sr.l_abb07f_l,
                   sr.l_abb07f_r, sr.l_aba02,    sr.aag02_o,
                   sr.aag13_o,    sr.l_aba04,    sr.l_abb01,    sr.l_abb06,
                   sr.l_abb02,    sr.l_bala,     sr.l_balaf,    g_azi04,
                   g_azi07 ,      t_azi04,       t_azi07,       g_aaz.aaz51, 
                   sub_tas04,     sub_tas05,     sub_tas09,     sub_tas10,
                   l_page  
                   #FUN-870029 - END 
                 #END IF   #MOD-780004
             ELSE
                SELECT SUM(tah04-tah05) INTO sr.b_bal FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    #AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '1'   #MOD-780004
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '0'   #MOD-780004
                IF sr.b_bal IS NULL THEN LET sr.b_bal = 0 END IF
                SELECT SUM(tah09-tah10) INTO sr.b_balf FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    #AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '1'   #MOD-780004
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb AND tah03 = '0'   #MOD-780004
                IF sr.b_balf IS NULL THEN LET sr.b_balf = 0 END IF
                SELECT SUM(tah04),SUM(tah05) INTO sr.b_d,sr.b_c FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb
                    AND g_count>= 2
                    AND tah03 < g_count
                    AND tah03 <> '0'   #MOD-780004
                IF sr.b_d IS NULL THEN LET sr.b_d = 0 END IF
                IF sr.b_c IS NULL THEN LET sr.b_c = 0 END IF
                SELECT SUM(tah09),SUM(tah10) INTO sr.b_df,sr.b_cf FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    AND tah02 = tm.yyyy  AND tah08 = tm.bb
                    AND g_count>= 2
                    AND tah03 < g_count
                    AND tah03 <> '0'   #MOD-780004
                IF sr.b_df IS NULL THEN LET sr.b_df = 0 END IF
                IF sr.b_cf IS NULL THEN LET sr.b_cf = 0 END IF
                SELECT tah04,tah05,tah09,tah10 INTO
                       sr.tah.tah04,sr.tah.tah05,sr.tah.tah09,sr.tah.tah10
                       FROM tah_file
                  WHERE tah00 = b AND tah01 = sr.aag01  #No.FUN-740055 
                    AND tah02 = tm.yyyy AND tah03 = g_count
                    AND tah08 = tm.bb
                IF sr.tah.tah04 IS NULL THEN LET sr.tah.tah04 = 0 END IF
                IF sr.tah.tah05 IS NULL THEN LET sr.tah.tah05 = 0 END IF
                IF sr.tah.tah09 IS NULL THEN LET sr.tah.tah09 = 0 END IF
                IF sr.tah.tah10 IS NULL THEN LET sr.tah.tah10 = 0 END IF
                SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
                  INTO sr.l_d,sr.l_c,sr.l_df,sr.l_cf FROM tah_file
                 WHERE tah00 = b AND tah01 = sr.aag01   #No.FUN-740055 
                   AND tah02 = tm.yyyy AND tah03 <= g_count
                   #AND tah08 = tm.bb   AND tah03 > 1   #MOD-780004
                   AND tah08 = tm.bb   AND tah03 > 0   #MOD-780004
                IF sr.l_d IS  NULL THEN LET sr.l_d = 0  END IF
                IF sr.l_c IS  NULL THEN LET sr.l_c = 0  END IF
                IF sr.l_df IS NULL THEN LET sr.l_df = 0 END IF
                IF sr.l_cf IS NULL THEN LET sr.l_cf = 0 END IF
                IF g_count = 1 THEN
                   LET sr.bala  = sr.b_bal
                   LET sr.balaf = sr.b_balf
                ELSE
                   LET sr.bala = sr.b_bal +( sr.b_d - sr.b_c)
                   LET sr.balaf = sr.b_balf +(sr.b_df-sr.b_cf)
                END IF
                LET sr.balc = sr.b_bal +( sr.l_d - sr.l_c)
                LET sr.balcf = sr.b_balf+( sr.l_df - sr.l_cf)
                LET sr.bald = sr.b_bal +sr.l_d - sr.l_c
                LET sr.baldf = sr.b_balf +sr.l_df - sr.l_cf
                #add 030731 NO.A085
                LET l_mm = tm.mm - 1
#                OPEN curs_pageno USING l_mm,sr.aag01                #No.FUN-890102
#                FETCH curs_pageno INTO g_pageno                     #No.FUN-890102
#                IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF   #No.FUN-890102
                LET g_cn = 0
                ###
                LET sr.m_aba02 = g_count
                LET sr.aba02 = NULL
                IF sr.m_aba02 = tm.nn THEN
                   LET sr.aba04 = tm.nn
                ELSE
                   LET sr.aba04 = g_count
                END IF
                #IF sr.bala > 0 OR sr.balaf > 0 THEN   #MOD-780004
#                   OUTPUT TO REPORT gglr320_rep_f(sr.*)      #No.FUN-890102
                  #FUN-870029 - START 
                  EXECUTE insert_prep USING
                   sr.m_aba02, sr.aag01, sr.aag02, sr.aag13, sr.aba02, sr.aba04,
                   sr.abb.abb01,  sr.abb.abb02,  sr.abb.abb04,  sr.abb.abb24,
                   sr.abb.abb25,  sr.aas.aas04,  sr.aas.aas05,  sr.tas.tas04,
                   sr.tas.tas05,  sr.tas.tas09,  sr.tas.tas10,  sr.aah.aah04,
                   sr.aah.aah05,  sr.tah.tah04,  sr.tah.tah05,  sr.tah.tah09,
                   sr.tah.tah10,  sr.b_bal,      sr.b_balf,     sr.b_d,
                   sr.b_df,       sr.l_df,       sr.b_c,        sr.b_cf,
                   sr.l_cf,       sr.bala,       sr.balaf,      sr.l_d,
                   sr.l_c,        sr.balb,       sr.balbf,      sr.bald,
                   sr.baldf,      sr.balc,       sr.balcf,      sr.l_abb07_l,
                   sr.l_abb07_r,  sr.s_aas04,    sr.s_aas05,    sr.s_tas04,
                   sr.s_tas05,    sr.s_tas09,    sr.s_tas10,    sr.l_abb07f_l,
                   sr.l_abb07f_r, sr.l_aba02,    sr.aag02_o,
                   sr.aag13_o,    sr.l_aba04,    sr.l_abb01,    sr.l_abb06,
                   sr.l_abb02,    sr.l_bala,     sr.l_balaf,    g_azi04,
                   g_azi07 ,      t_azi04,       t_azi07,       g_aaz.aaz51, 
                   sub_tas04,     sub_tas05,     sub_tas09,     sub_tas10,
                   l_page  
                   #FUN-870029 - END 
                #END IF   #MOD-780004
             END IF
           END FOR
        END IF
        ###
     END FOREACH
     #FUN-870029 START
    
     #把原本rep段裡的GROUP SUM拿到前面來做 
     LET l_preaba02 = NULL
     LET l_preaag01 = NULL
     LET l_prem_aba02 = NULL
 
     LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "   SET aas04 = ? , aas05 = ? ", 
                 " WHERE aag01 = ?  AND m_aba02 = ? AND aba02 = ?" 
     PREPARE upd_prep3 FROM l_sql
 
     LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "   SET tas04 =?,    tas05 = ?,   tas09 = ?,  tas10 = ?,",
                 "       sub_tas04=?, sub_tas05=?, sub_tas09=?, sub_tas10=?",
                 " WHERE aag01 = ?  AND m_aba02 = ? AND aba02 = ?" 
     PREPARE upd_prep4 FROM l_sql
 
     LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "   SET  aah04=?,    aah05 = ?",
                 " WHERE aag01 = ?  AND m_aba02 = ? AND aba02 IS NULL" 
     PREPARE upd_prep5 FROM l_sql
 
     LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "   SET  tah04=?,    tah05=?,  tah09=?,  tah10=?",
                 " WHERE aag01 = ?  AND m_aba02 = ? AND aba02 IS NULL" 
     PREPARE upd_prep6 FROM l_sql
 
     LET l_sql = "SELECT aag01,m_aba02,aba02,SUM(l_abb07_l),SUM(l_abb07_r),",
                 "       SUM(l_abb07_l),SUM(l_abb07_r),",
                 "       SUM(l_abb07f_l),SUM(l_abb07f_r),",
                 "       0,0,0,0,0,0,0,0 ",
                 "  FROM  ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "  GROUP BY aag01,m_aba02,aba02",
                 "  ORDER BY aag01,m_aba02,aba02"
     PREPARE pre_tmp FROM l_sql
     IF STATUS THEN
        CALL cl_err('pre_tmp',STATUS,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE curs_tmp CURSOR FOR pre_tmp
     FOREACH curs_tmp INTO srtmp.*
       IF tm.p = 'N' THEN
          IF g_aaz.aaz51 = 'Y' THEN 
             SELECT aas04,aas05 INTO srtmp.aas04,srtmp.aas05
                FROM aas_file
               WHERE aas00 = b AND aas01 = srtmp.aag01 AND aas02 = srtmp.aba02 
          ELSE
             LET srtmp.aas04 = cl_digcut(srtmp.aas04,g_azi04) 
             LET srtmp.aas05 = cl_digcut(srtmp.aas05,g_azi04)
          END IF
          IF srtmp.aas04 IS NULL THEN LET srtmp.aas04 = 0 END IF
          IF srtmp.aas05 IS NULL THEN LET srtmp.aas05 = 0 END IF
          
          IF cl_null(srtmp.aba02) THEN
             LET l_aah04 = 0
             LET l_aah05 = 0
             EXECUTE upd_prep5 USING l_aah04,l_aah05, 
                                  srtmp.aag01,srtmp.m_aba02
          END IF
        
          EXECUTE upd_prep3 USING srtmp.aas04,srtmp.aas05,
                                  srtmp.aag01,srtmp.m_aba02,srtmp.aba02
       ELSE ###---------
          CALL s_azn01(tm.yyyy,srtmp.m_aba02) RETURNING l_bdate,l_edate
          CALL s_azn01(tm.yyyy,1) RETURNING l_bdate,l_edate
          IF g_aaz.aaz51 = 'Y' THEN
             SELECT tas04,tas05,tas09,tas10
               INTO srtmp.tas04,srtmp.tas05,srtmp.tas09,srtmp.tas10
               FROM tas_file
              WHERE tas00 = b AND tas01 = srtmp.aag01  
                AND tas02 = srtmp.aba02 AND tas08 = tm.bb
       
             SELECT SUM(tas04),SUM(tas05),SUM(tas09),SUM(tas10)
               INTO srtmp.s_tas04,srtmp.s_tas05,srtmp.s_tas09,srtmp.s_tas10
               FROM tas_file
              WHERE tas00 = b AND tas01 = srtmp.aag01 AND tas08 = tm.bb
                AND tas02 <= srtmp.aba02 AND tas02 >= l_bdate
          ELSE
            LET srtmp.tas04 = cl_digcut(srtmp.tas04,g_azi04)
            LET srtmp.tas05 = cl_digcut(srtmp.tas05,g_azi04)
            LET srtmp.tas09 = cl_digcut(srtmp.tas09,t_azi04)
            LET srtmp.tas10 = cl_digcut(srtmp.tas10,t_azi04) 
          END IF
          IF srtmp.tas04 IS NULL THEN LET srtmp.tas04 = 0 END IF
          IF srtmp.tas05 IS NULL THEN LET srtmp.tas05 = 0 END IF
          IF srtmp.tas09 IS NULL THEN LET srtmp.tas09 = 0 END IF
          IF srtmp.tas10 IS NULL THEN LET srtmp.tas10 = 0 END IF
          IF srtmp.s_tas04 IS NULL THEN LET srtmp.s_tas04 = 0 END IF
          IF srtmp.s_tas05 IS NULL THEN LET srtmp.s_tas05 = 0 END IF
          IF srtmp.s_tas09 IS NULL THEN LET srtmp.s_tas09 = 0 END IF
          IF srtmp.s_tas10 IS NULL THEN LET srtmp.s_tas10 = 0 END IF
          IF cl_null(srtmp.aba02) THEN
             LET  l_tah04 = 0
             LET  l_tah05 = 0
             LET  l_tah09 = 0
             LET  l_tah10 = 0
             EXECUTE upd_prep6 USING l_tah04,l_tah05,l_tah09,l_tah10, 
                                  srtmp.aag01,srtmp.m_aba02
           END IF
          EXECUTE upd_prep4 USING srtmp.tas04,srtmp.tas05,srtmp.tas09,srtmp.tas10,
                                  srtmp.s_tas04,srtmp.s_tas05,
                                  srtmp.s_tas09,srtmp.s_tas10, 
                                  srtmp.aag01,srtmp.m_aba02,srtmp.aba02
       END IF 
       LET l_preaag01 = srtmp.aag01
       LET l_preaba02 = srtmp.aba02
       LET l_prem_aba02 = srtmp.m_aba02
     END FOREACH
 
     #若要修改cr每頁可印的行數 請直接修改此處行數
     #設定列頁行數
     IF tm.p = 'Y' THEN
        LET g_pagecut = 28
     ELSE
        LET g_pagecut = 22
     END IF
     CALL r320_pageno()
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.yyyy,";",tm.mm,";",tm.p,";",tm.e,";",g_pagecut 
     IF tm.p = 'Y' THEN
        CALL cl_prt_cs3('gglr320','gglr320_1',l_sql,g_str)
     ELSE
        CALL cl_prt_cs3('gglr320','gglr320',l_sql,g_str)
     END IF
     #------------------------------ CR (4) ------------------------------#
     # FUN-870029 END 
         
         
#No.FUN-890102  BEGIN   
#     IF tm.p = 'N' THEN
#       FINISH REPORT gglr320_rep
#     ELSE
#       FINISH REPORT gglr320_rep_f
#     END IF
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-890102   END
      #No.FUN-B80096--mark--Begin---      
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
      #No.FUN-B80096--mark--End-----
END FUNCTION
 
 
#FUN-870029 - start-
FUNCTION r320_pageno()
   DEFINE l_sql STRING
   DEFINE l_page SMALLINT
   DEFINE l_line SMALLINT
   DEFINE l_aag01    LIKE aag_file.aag01,
          l_m_aba02  SMALLINT,
          l_prem     SMALLINT,
          l_preaag01 LIKE aag_file.aag01,
          l_prepage  SMALLINT,
          l_aba02    LIKE aba_file.aba02,
          l_count    SMALLINT,
          l_first_aba02 SMALLINT
 
   LET l_prem = 0
   LET l_preaag01 = NULL
 
   LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET page = ? ", 
               " WHERE aag01 = ?  " 
   PREPARE upd_page FROM l_sql
 
   LET l_sql = "SELECT DISTINCT  aag01",
                "  FROM  ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "  ORDER BY aag01"
   PREPARE pre_pag1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('pre_pag1',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE curs_pag1 CURSOR FOR pre_pag1
   FOREACH curs_pag1 INTO l_aag01
      IF (l_aag01 <> l_preaag01) OR cl_null(l_preaag01) THEN
         
         #(1)換科目時重置行數。
         LET l_line = 0
 
         #(2)取得此科目 此次列印的第一期
         LET l_sql = "SELECT DISTINCT  m_aba02",
                      "  FROM  ",g_cr_db_str CLIPPED,l_table CLIPPED,
                      "  WHERE aag01 = '",l_aag01 CLIPPED,"'",
                      "    AND ROWNUM = 1 ",
                      "  ORDER BY m_aba02"
         PREPARE pre_pag4 FROM l_sql
         IF STATUS THEN
            CALL cl_err('pre_pag4',STATUS,0) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
            EXIT PROGRAM
         END IF
         DECLARE curs_pag4 CURSOR FOR pre_pag4
         FOREACH curs_pag4 INTO l_first_aba02
            #(1)取得此科目 上期印到哪一頁
            LET l_prem = l_first_aba02 - 1 
            LET l_prepage = 0 
            SELECT tpg04 INTO l_prepage 
             FROM tpg_file 
            WHERE tpg01 = tm.yyyy AND tpg02 = l_prem
              AND tpg03 = l_aag01 AND tpg05 = "gglr320" 
            IF cl_null(l_prepage) THEN LET l_prepage = 0  END IF
            LET l_page = l_prepage + 1
 
            #(2)將cr-TEMPTABEL的基礎頁更新 
            EXECUTE upd_page USING l_page,l_aag01
 
            #(3)期別計算所須行數
            LET l_sql = "SELECT DISTINCT  m_aba02",
                         "  FROM  ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         "  WHERE aag01 = '",l_aag01 CLIPPED,"'",
                         "  ORDER BY m_aba02"
            PREPARE pre_pag2 FROM l_sql
            IF STATUS THEN
               CALL cl_err('pre_pag2',STATUS,0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
               EXIT PROGRAM
            END IF
            DECLARE curs_pag2 CURSOR FOR pre_pag2
            FOREACH curs_pag2 INTO l_m_aba02
              #(4)每個期別頭(上期結轉)
              LET l_line = l_line + 1
              IF l_line >= g_pagecut THEN
                 LET l_page = l_page + 1 
                 LET l_line = l_line - g_pagecut
              END IF
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt
                FROM tpg_file 
               WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02 
                 AND tpg03 = l_aag01 AND tpg05 = 'gglr320'
              IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
              IF g_cnt = 0 THEN 
                 IF l_line = 0 THEN
                   INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page -1,
                                             "gglr320",' ',' ')
                 ELSE  
                   INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page,
                                             "gglr320",' ',' ')
                 END IF
              ELSE 
                 IF l_line = 0 THEN
                   UPDATE tpg_file SET tpg04 = l_page -1
                    WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                      AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                 ELSE
                    UPDATE tpg_file SET tpg04 = l_page
                    WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                      AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                 END IF
              END IF
              
              #(5)計算每日行數
              LET l_sql = "SELECT aba02,COUNT(*) ",
                          "  FROM  ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         "  WHERE aag01 = '",l_aag01 CLIPPED,"'",
                         "    AND m_aba02 = ",l_m_aba02,
                         "    AND aba02 IS NOT NULL ",
                         "  GROUP BY aba02",
                         "  ORDER BY aba02" 
              PREPARE pre_pag3 FROM l_sql
              IF STATUS THEN
                 CALL cl_err('pre_pag3',STATUS,0)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
                 EXIT PROGRAM
              END IF
              DECLARE curs_pag3 CURSOR FOR pre_pag3
              FOREACH curs_pag3 INTO l_aba02,l_count
                #(6)每日資料(detail)
                FOR g_i = 1 to l_count
                  #(7)若為印原幣 每筆資料要2行
                  IF tm.p = 'Y' THEN
                     LET l_line = l_line + 2 
                     IF (l_line = g_pagecut)  THEN
                        LET l_page = l_page + 1 
                        LET l_line = l_line - g_pagecut
                     END IF
                     IF l_line = g_pagecut + 1 THEN
                        LET l_page = l_page + 1 
                        LET l_line = 2 
                     END IF    
                  ELSE
                     LET l_line = l_line +1 
                     IF l_line >= g_pagecut THEN
                        LET l_page = l_page + 1 
                        LET l_line = l_line - g_pagecut
                     END IF
                  END IF
                  LET g_cnt = 0
                  SELECT COUNT(*) INTO g_cnt
                    FROM tpg_file 
                   WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02 
                     AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                  IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                  IF g_cnt = 0 THEN 
                     IF l_line = 0  THEN
                       INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page -1,
                                                 "gglr320",' ',' ')
                     ELSE  
                       INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page,
                                                 "gglr320",' ',' ')
                     END IF
                  ELSE 
                     IF l_line = 0 THEN
                       UPDATE tpg_file SET tpg04 = l_page -1
                        WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                          AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                     ELSE
                        UPDATE tpg_file SET tpg04 = l_page
                        WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                          AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                     END IF
                  END IF
                END FOR
                   
                #(7)本日小計 要再加一行
                LET l_line = l_line +1 
                IF l_line >= g_pagecut THEN
                   LET l_page = l_page + 1 
                   LET l_line = l_line - g_pagecut
                   LET g_cnt = 0
                   SELECT COUNT(*) INTO g_cnt
                     FROM tpg_file 
                    WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02 
                      AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                   IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                   IF g_cnt = 0 THEN 
                      IF l_line = 0 THEN
                        INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page -1,
                                                  "gglr320",' ',' ')
                      ELSE  
                        INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page,
                                                  "gglr320",' ',' ')
                      END IF
                   ELSE 
                      IF l_line = 0  THEN
                        UPDATE tpg_file SET tpg04 = l_page -1
                         WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                           AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                      ELSE
                         UPDATE tpg_file SET tpg04 = l_page
                         WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                           AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                      END IF
                   END IF
                END IF
              END FOREACH   
              #(4)每個期別尾(本月合計)
              LET l_line = l_line + 1
              IF l_line >= g_pagecut THEN  
                 LET l_page = l_page + 1 
                 LET l_line = l_line - g_pagecut
              END IF
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt
                FROM tpg_file 
               WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02 
                 AND tpg03 = l_aag01 AND tpg05 = 'gglr320'
              IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
              IF g_cnt = 0 THEN 
                 IF l_line = 0 THEN
                   INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page -1,
                                             "gglr320",' ',' ')
                 ELSE  
                   INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page,
                                             "gglr320",' ',' ')
                 END IF
              ELSE 
                 IF l_line = 0 THEN
                   UPDATE tpg_file SET tpg04 = l_page -1
                    WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                      AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                 ELSE
                    UPDATE tpg_file SET tpg04 = l_page
                    WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                      AND tpg03 = l_aag01 AND tpg05 = "gglr320"
                 END IF
              END IF
            END FOREACH   
         #(1)換科目時重置行數。每個科目至少有一個本年合計(1行)
         LET l_line = l_line + 1
         IF l_line >= g_pagecut THEN
            LET l_page = l_page + 1 
            LET l_line = l_line - g_pagecut
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM tpg_file 
          WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02 
            AND tpg03 = l_aag01 AND tpg05 = 'gglr320'
         IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
         IF g_cnt = 0 THEN 
            IF l_line = 0 THEN
              INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page -1,
                                        "gglr320",' ',' ')
            ELSE  
              INSERT INTO tpg_file VALUES(tm.yyyy,l_m_aba02,l_aag01,l_page,
                                        "gglr320",' ',' ')
            END IF
         ELSE 
            IF l_line = 0 THEN
              UPDATE tpg_file SET tpg04 = l_page -1
               WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                 AND tpg03 = l_aag01 AND tpg05 = "gglr320"
            ELSE
               UPDATE tpg_file SET tpg04 = l_page
               WHERE tpg01 = tm.yyyy AND tpg02 = l_m_aba02
                 AND tpg03 = l_aag01 AND tpg05 = "gglr320"
            END IF
         END IF
         END FOREACH
      END IF
      LET l_preaag01 = l_aag01
 
   END FOREACH
 
END FUNCTION
#FUN-870029 - end---
 
 
#No.FUN-890102  BEGIN 
#REPORT gglr320_rep(sr)
#  DEFINE sr     RECORD
#                   m_aba02    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#                   aag01      LIKE aag_file.aag01,    # acct. name
#                   aag02      LIKE aag_file.aag02,    # acct. name
#                   aag13      LIKE aag_file.aag13,    #FUN-6C0012
#                   aba02      LIKE aba_file.aba02,
#                   aba04      LIKE aba_file.aba04,
#                   abb        RECORD LIKE abb_file.*,
#                   abbl       RECORD LIKE abb_file.*,
#                   aas        RECORD LIKE aas_file.*,
#                   tas        RECORD LIKE tas_file.*,
#                   aah        RECORD LIKE aah_file.*,
#                   tah        RECORD LIKE tah_file.*,
#                   b_bal      LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   b_balf     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   b_d        LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   b_df       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   l_df       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   b_c        LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   b_cf       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   l_cf       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   bala       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   balaf      LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   l_d        LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   l_c        LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   balb       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   balbf      LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   bald       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   baldf      LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   balc       LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   balcf      LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#                   l_abb07_l  LIKE abb_file.abb07,       #NO FUN-690009   DEC(20,6)
#                   l_abb07_r  LIKE abb_file.abb07,       #NO FUN-690009   DEC(20,6)
#                   s_aas04    LIKE aas_file.aas04,       #NO FUN-690009   DEC(20,6)
#                   s_aas05    LIKE aas_file.aas05,       #NO FUN-690009   DEC(20,6)
#                   s_tas04    LIKE tas_file.tas04,       #NO FUN-690009   DEC(20,6)
#                   s_tas05    LIKE tas_file.tas05,       #NO FUN-690009   DEC(20,6)
#                   s_tas09    LIKE tas_file.tas09,       #NO FUN-690009   DEC(20,6)
#                   s_tas10    LIKE tas_file.tas10,       #NO FUN-690009   DEC(20,6)
#                   l_abb07f_l LIKE abb_file.abb07,       #NO FUN-690009   DEC(20,6)
#                   l_abb07f_r LIKE abb_file.abb07,       #NO FUN-690009   DEC(20,6)
#                   l_aba02    LIKE aba_file.aba02,       #NO FUN-690009   DATE
#                   aag02_o    LIKE aag_file.aag02,       #NO FUN-690009   VARCHAR(30)
#                   aag13_o    LIKE aag_file.aag13,       #FUN-6C0012
#                   l_aba04    LIKE aba_file.aba04,       #NO FUN-690009   SMALLINT
#                   l_abb01    LIKE abb_file.abb01,       #No.MOD-570145
#                   l_abb06    LIKE abb_file.abb06,       #NO FUN-690009   VARCHAR(01)
#                   l_abb02    LIKE abb_file.abb02,       #NO FUN-690009   SMALLINT
#                   l_bala     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)   # add 030819 NO.A085
#                   l_balaf    LIKE type_file.num20_6     #NO FUN-690009   DECIMAL(20,6)   # add 030819 NO.A085
#                END RECORD
# DEFINE l_bal,l_amt     LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
# Prog. Version..: '5.30.06-13.03.12(02)        #add 030731 NO.A085
#        l_res           LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)   #add 030731 NO.A085
#        l_cnt           LIKE type_file.num5,       #NO FUN-690009   SMALLINT        #add 030731 NO.A085
#        l_month         LIKE type_file.chr2,       #NO FUN-690009   VARCHAR(2)         #add 030731 NO.A085
#        s_aas04,s_aas05 LIKE type_file.num20_6,    #NO FUN-690009   DECIMAL(20,6)
#        e_date,b_date   LIKE type_file.dat         #NO FUN-690009   DATE
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.aag01,sr.aba04,sr.m_aba02,sr.aba02,sr.abb.abb01,sr.abb.abb02
#
#  FORMAT
#     PAGE HEADER
##No.MOD-590097 --start--
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        IF g_towhom IS NULL OR g_towhom = ' ' THEN
#           PRINT '';
#        ELSE
#           PRINT 'TO:',g_towhom;
#        END IF
##        PRINT COLUMN 150,'FROM:',g_user CLIPPED       # No.TQC-740305 
#        PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#        PRINT COLUMN 150,'FROM:',g_user CLIPPED       # No.TQC-740305
#        PRINT ' '
#        LET g_cn = g_cn + 1                       #add 030731 NO.A085
#        LET g_pageno = g_pageno + 1
#        PRINT COLUMN 76,tm.yyyy CLIPPED,
#              COLUMN 68,g_x[3] CLIPPED
#        PRINT COLUMN 2,g_x[2] CLIPPED,sr.aag01
#        #FUN-6C0012.....begin
#        IF tm.e = 'N'  THEN
#           PRINT COLUMN 2,g_x[5] CLIPPED,sr.aag02;
#        ELSE
#           PRINT COLUMN 2,g_x[5] CLIPPED,sr.aag13;
#        END IF
#        #FUN-6C0012.....end
#        PRINT COLUMN 150,g_x[4] CLIPPED,g_pageno USING '<<<'
##        PRINT '┌───┬────────┬────────────────┬',  #No.MOD-570145
##              '───────────────┬──────────┬─────',
##              '─────┬──┬──────────┐'
#        PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55] CLIPPED
#        PRINT COLUMN 1,g_x[11] CLIPPED,g_x[12] CLIPPED,g_x[13] CLIPPED,
#                       g_x[14] CLIPPED,g_x[15] CLIPPED
#        PRINT g_x[149],g_x[150],g_x[151]   #MOD-780004
#      BEFORE GROUP OF sr.aag01
#        #add 030731 NO.A085
#        LET l_month = sr.m_aba02 - 1
#        OPEN curs_pageno USING l_month,sr.aag01
#        FETCH curs_pageno INTO g_pageno
#        IF STATUS = 100 THEN LET g_pageno = 0 END IF
#        IF g_cn = 1 THEN
#           LET g_pageno = g_pageno + 1
#        END IF
#        ###
#        SKIP TO TOP OF PAGE
#
#      ON EVERY ROW
#        ### add 030812 NO.A085
#        IF NOT cl_null(sr.aba02) THEN
#        ###
#        IF LINENO = 9 THEN
##          PRINT '├───┼────────┼───────────────',
##                '─┼───────────────┼──────────┼─',
##                '─────────┼──┼──────────┤'
#          PRINT g_x[56],g_x[57],g_x[58],g_x[59],g_x[60] CLIPPED
#        END IF
#        #add 030731 NO.A085
#        IF sr.l_abb07_l IS NULL THEN LET sr.l_abb07_l = 0 END IF
#        IF sr.l_abb07_r IS NULL THEN LET sr.l_abb07_r = 0 END IF
#        LET l_res = 0
#        LET l_dir = ''
#      # LET l_res = sr.bala + sr.l_abb07_l - sr.l_abb07_r
#        IF tm.mm = 1 THEN
#           LET l_res = sr.b_bal  + sr.s_aas04 - sr.s_aas05
#        ELSE
#           LET l_res = sr.l_bala  + sr.s_aas04 - sr.s_aas05
#        END IF
#        CASE
#            WHEN l_res > 0 LET l_dir = g_x[47] CLIPPED
#            WHEN l_res = 0 LET l_dir = g_x[48] CLIPPED
#            WHEN l_res < 0 LET l_dir = g_x[49] CLIPPED
#                           LET l_res = l_res*-1
#        OTHERWISE
#        END CASE
#        IF sr.l_abb07_l = 0 THEN LET sr.l_abb07_l = NULL END IF
#        IF sr.l_abb07_r = 0 THEN LET sr.l_abb07_r = NULL END IF
#        ###
#        IF sr.abb.abb01 = sr.abbl.abb01
#          AND sr.abb.abb02 = sr.abbl.abb02 THEN
#          PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[50],sr.abb.abb01 CLIPPED,COLUMN 27,g_x[50],sr.abb.abb04 CLIPPED;
#          #FUN-6C0012.....begin
#          IF tm.e = 'N' THEN
#             PRINT COLUMN 61,g_x[50],sr.aag02_o CLIPPED;
#          ELSE
#             PRINT COLUMN 61,g_x[50],sr.aag13_o CLIPPED;
#          END IF
#          #FUN-6C0012.....end
#          PRINT COLUMN 93,g_x[50],cl_numfor(sr.l_abb07_l,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#                COLUMN 115,g_x[50],cl_numfor(sr.l_abb07_r,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#                COLUMN 137,g_x[50],l_dir CLIPPED,                #add 030731 NO.A085
#                COLUMN 143,g_x[50],cl_numfor(l_res,18,g_azi04) CLIPPED,  #add 030731 NO.A085     #No.CHI-6A0004   #MOD-780004
#                COLUMN 165,g_x[50]
#          IF LINENO > 60 THEN
#            PRINT '└───┴────────┴──────────────',
#                  '──┴───────────────┴──────────',
#                  '┴──────────┴──┴──────────┘'
#            PRINT g_x[61],g_x[62],g_x[63],g_x[64],g_x[65] CLIPPED
#            PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                  COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                  COLUMN 112,g_x[44] CLIPPED
#            SKIP TO TOP OF PAGE
#          ELSE
##            PRINT '├───┼────────┼──────────────',
##                  '──┼───────────────┼──────────',
##                  '┼──────────┼──┼──────────┤'
#            PRINT g_x[56],g_x[57],g_x[58],g_x[59],g_x[60] CLIPPED
#          END IF
#        ELSE
#          PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[50],sr.abb.abb01 CLIPPED,
#                COLUMN 27,g_x[50],sr.abb.abb04 CLIPPED;
#          #FUN-6C0012.....begin
#          IF tm.e = 'N' THEN
#             PRINT COLUMN 61,g_x[50],sr.aag02_o CLIPPED;
#          ELSE
#             PRINT COLUMN 61,g_x[50],sr.aag13_o CLIPPED;
#          END IF
#          #FUN-6C0012.....end
#          PRINT COLUMN 93,g_x[50],cl_numfor(sr.l_abb07_l,18,g_azi04) CLIPPED,     #No.CHI-6A0004   #MOD-780004
#                COLUMN 115,g_x[50],cl_numfor(sr.l_abb07_r,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#                COLUMN 137,g_x[50],l_dir CLIPPED,                #add 030731 NO.A085
#                COLUMN 143,g_x[50],cl_numfor(l_res,18,g_azi04),  #add 030731 NO.A085    #No.CHI-6A0004   #MOD-780004
#                COLUMN 165,g_x[50]
#          IF LINENO > 60 THEN
##             PRINT '└───┴────────┴──────────────',  #No.MOD-570145
##                  '──┴───────────────┴──────────',
##                  '┴──────────┴──┴──────────┘'
#            PRINT g_x[61],g_x[62],g_x[63],g_x[64],g_x[65] CLIPPED
#            PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                  COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                  COLUMN 112,g_x[44] CLIPPED
#            SKIP TO TOP OF PAGE
#          ELSE
##            PRINT '├───┼────────┴──────────────',
##                  '──┴───────────────┼──────────',
##                  '┼──────────┼──┼──────────┤'
#            PRINT g_x[146],g_x[147],g_x[58],g_x[59],g_x[60] CLIPPED
#          END IF
#        END IF
#        ### add 030812 NO.A085
#        END IF
#        ###
#
#      AFTER GROUP OF sr.aba02
#        ### add 030812 NO.A085
#        IF NOT cl_null(sr.aba02) THEN
#        ###
#        IF LINENO = 9 THEN
##           PRINT '├───┼────────┼───────────────',  #No.MOD-570145
##                '─┼───────────────┼──────────┼─',
##                '─────────┼──┼──────────┤'
#           PRINT g_x[91],g_x[92],g_x[93],g_x[94],g_x[95],g_x[96] CLIPPED
#        END IF
#        CALL s_azn01(tm.yyyy,1) RETURNING b_date,e_date
#        IF g_aaz.aaz51 = 'Y'
#          THEN SELECT aas04,aas05 INTO sr.aas.aas04,sr.aas.aas05 FROM aas_file
#                WHERE aas00 = b AND aas01 = sr.aag01 AND aas02 = sr.aba02  #No.FUN-740055 
#          ELSE LET sr.aas.aas04 = cl_numfor(GROUP SUM(sr.l_abb07_l),18,g_azi04)    #No.CHI-6A0004   #MOD-780004
#               LET sr.aas.aas05 = cl_numfor(GROUP SUM(sr.l_abb07_r),18,g_azi04)    #No.CHI-6A0004   #MOD-780004
#        END IF
#        IF sr.aas.aas04 IS NULL THEN LET sr.aas.aas04 = 0 END IF
#        IF sr.aas.aas05 IS NULL THEN LET sr.aas.aas05 = 0 END IF
#        ### add 030815 NO.A085
#        IF tm.mm = 1 THEN
#           LET sr.balb = sr.b_bal + sr.s_aas04 - sr.s_aas05
#        ELSE
#           LET sr.balb = sr.l_bala + sr.s_aas04 - sr.s_aas05
#        END IF
#        ###
#        IF sr.aba02 = sr.l_aba02 THEN
#          PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[16] CLIPPED,g_x[17] CLIPPED,
#                COLUMN 93,g_x[50],cl_numfor(sr.aas.aas04,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#                COLUMN 115,g_x[50],cl_numfor(sr.aas.aas05,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#                COLUMN 137,g_x[50];
#                IF sr.balb>0
#                  THEN PRINT g_x[47] CLIPPED;
#                  ELSE IF sr.balb = 0 THEN PRINT g_x[48] CLIPPED;
#                                      ELSE PRINT g_x[49] CLIPPED;
#                       END IF
#                END IF
#          PRINT COLUMN 143,g_x[50] CLIPPED;
#              IF cl_numfor(sr.balb,18,g_azi04)<0    #No.CHI-6A0004   #MOD-780004
#                THEN PRINT COLUMN 145,cl_numfor(-1*sr.balb,18,g_azi04) CLIPPED;    #No.CHI-6A0004   #MOD-780004
#                ELSE PRINT COLUMN 145,cl_numfor(sr.balb,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#              END IF
#          PRINT COLUMN 165,g_x[50] CLIPPED
#          IF LINENO > 60 THEN
##            PRINT '└───┴────────────────────────',
##                  '─────────────────┴──────────┴─',
##                  '─────────┴──┴──────────┘'
#            PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#            PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                  COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                  COLUMN 112,g_x[44] CLIPPED
#            SKIP TO TOP OF PAGE
#          ELSE
##            PRINT '├───┼─────────────────────────',
##                  '────────────────┼──────────┼───',
##                  '───────┼──┼──────────┤'
#            PRINT g_x[91],g_x[92],g_x[93],g_x[94],g_x[95],g_x[96] CLIPPED
#          END IF
#        ELSE
#          PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[16] CLIPPED,g_x[17] CLIPPED,
#                COLUMN 93,g_x[50],cl_numfor(sr.aas.aas04,18,g_azi04) CLIPPED,  #No.CHI-6A0004   #MOD-780004
#                COLUMN 115,g_x[50],cl_numfor(sr.aas.aas05,18,g_azi04) CLIPPED, #No.CHI-6A0004   #MOD-780004
#                COLUMN 137,g_x[50] CLIPPED;
#                IF sr.balb>0
#                  THEN PRINT g_x[47] CLIPPED;
#                  ELSE IF sr.balb = 0 THEN PRINT g_x[48] CLIPPED;
#                                      ELSE PRINT g_x[49] CLIPPED;
#                       END IF
#                END IF
#          PRINT COLUMN 143,g_x[50] CLIPPED;
#              IF cl_numfor(sr.balb,18,g_azi04)<0              #No.CHI-6A0004   #MOD-780004
#                THEN PRINT COLUMN 145,cl_numfor(-1*sr.balb,18,g_azi04) CLIPPED;    #No.CHI-6A0004   #MOD-780004
#                ELSE PRINT COLUMN 145,cl_numfor(sr.balb,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#              END IF
#          PRINT COLUMN 165,g_x[50] CLIPPED
#          IF LINENO > 60 THEN
##            PRINT '└───┴────────────────────────',
##                  '─────────────────┴──────────┴─',
##                  '─────────┴──┴──────────┘'
#            PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#            PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                  COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                  COLUMN 112,g_x[44] CLIPPED
#            SKIP TO TOP OF PAGE
#          ELSE
##            PRINT '├───┼────────┬────────────────',
##                  '┬───────────────┼──────────┼───',
##                  '───────┼──┼──────────┤'
#            PRINT g_x[76],g_x[77],g_x[78],g_x[79],g_x[80] CLIPPED
#          END IF
#        END IF
#        ### add 030812 NO.A085
#        END IF
#        ###
#
#      BEFORE GROUP OF sr.m_aba02
#        IF LINENO = 9 OR LINENO = 0 THEN
##          PRINT '├───┼────────┴──────────────',
##                '──┴───────────────┴──────────┴',
##                '──────────┼──┼──────────┤'
#          PRINT g_x[81],g_x[82],g_x[83],g_x[84],g_x[85] CLIPPED
#        END IF
#        CALL s_azn01(tm.yyyy,sr.m_aba02) RETURNING b_date,e_date
#        PRINT g_x[50],b_date USING "mm/dd" CLIPPED,
#              COLUMN 9,g_x[18] CLIPPED,g_x[19] CLIPPED,
#              COLUMN 137,g_x[50] CLIPPED;
#              IF sr.bala>0
#                THEN PRINT g_x[47] CLIPPED;
#                ELSE IF sr.bala = 0 THEN PRINT g_x[48] CLIPPED;
#                                    ELSE PRINT g_x[49] CLIPPED;
#                     END IF
#              END IF
#        PRINT COLUMN 143,g_x[50] CLIPPED;
#            IF cl_numfor(sr.bala,18,g_azi04)<0      #No.CHI-6A0004   #MOD-780004
#              THEN PRINT COLUMN 145,cl_numfor(-1*sr.bala,18,g_azi04) CLIPPED;      #No.CHI-6A0004   #MOD-780004
#              ELSE PRINT COLUMN 145,cl_numfor(sr.bala,18,g_azi04) CLIPPED;         #No.CHI-6A0004   #MOD-780004
#            END IF
#        PRINT COLUMN 165,g_x[50]   CLIPPED
#        IF LINENO > 60 THEN
#          ### add 030812 NO.A085
#          IF cl_null(sr.aba02) THEN
##             PRINT '└───┴───────────────────────',
##                   '───────────────────────────',
##                   '─────────────┴──┴──────────┘'
#             PRINT g_x[71],g_x[72],g_x[86],g_x[74],g_x[75] CLIPPED
#          ELSE
##             PRINT '└───┴───────────────────────',
##                   '──────────────────┴──────────',
##                   '┴──────────┴──┴──────────┘'
#             PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#          END IF
#          ###
#          PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                COLUMN 112,g_x[44] CLIPPED
#          SKIP TO TOP OF PAGE
#        ELSE
#          ### add 030812 NO.A085
#          IF cl_null(sr.aba02) THEN
##             PRINT '├───┼────────────────────────',
##                   '─────────────────┬──────────┬─',
##                   '─────────┼──┼──────────┤'
#             PRINT g_x[66],g_x[67],g_x[68],g_x[69],g_x[70] CLIPPED
#          ELSE
##             PRINT '├───┼────────┬──────────────',
##                   '──┬───────────────┬──────────',
##                   '┬──────────┼──┼──────────┤'
#             PRINT g_x[76],g_x[77],g_x[88],g_x[79],g_x[80] CLIPPED
#          END IF
#          ###
#        END IF
#
#      AFTER GROUP OF sr.m_aba02
#        #add 030731 NO.A085
#        #PAGENO
#        LET l_cnt = 0
#        SELECT COUNT(*) INTO l_cnt FROM tpg_file
#         WHERE tpg01=tm.yyyy AND tpg02=sr.m_aba02 AND tpg03=sr.aag01
#           AND tpg05='gglr320'
#        IF l_cnt = 0 THEN
#           INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04,tpg05)
#                         VALUES(tm.yyyy,sr.m_aba02,sr.aag01,g_pageno,'gglr320')
#        ELSE
#           UPDATE tpg_file SET tpg04 = g_pageno
#            WHERE tpg01=tm.yyyy AND tpg02 = sr.m_aba02 AND tpg03 = sr.aag01
#              AND tpg05='gglr320'
#        END IF
#        OPEN curs_pageno USING sr.m_aba02,sr.aag01
#        FETCH curs_pageno INTO g_pageno
#        IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#        ###
#        IF LINENO = 9 THEN
##          PRINT '├───┼────────┼───────────────',
##                '─┼───────────────┼──────────┼─',
##                '─────────┼──┼──────────┤'
#          PRINT g_x[56],g_x[57],g_x[58],g_x[59],g_x[60] CLIPPED
#        END IF
#        CALL s_azn01(tm.yyyy,sr.m_aba02) RETURNING b_date,e_date
#        ### add 030812 NO.A085
#        IF cl_null(sr.aba02) THEN
#           LET sr.aah.aah04 = 0
#           LET sr.aah.aah05 = 0
#        END IF
#        ###
#        IF sr.aba04 != sr.l_aba04 THEN
#          PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[20] CLIPPED,g_x[21] CLIPPED,
#                COLUMN 93,g_x[50],cl_numfor(sr.aah.aah04,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#                COLUMN 115,g_x[50],cl_numfor(sr.aah.aah05,18,g_azi04) CLIPPED,  #No.CHI-6A0004   #MOD-780004
#                COLUMN 137,g_x[50];
#                IF sr.balc>0
#                  THEN PRINT g_x[47] CLIPPED;
#                  ELSE IF sr.balc = 0 THEN PRINT g_x[48] CLIPPED;
#                                      ELSE PRINT g_x[49] CLIPPED;
#                       END IF
#                END IF
#          PRINT COLUMN 143,g_x[50] CLIPPED;
#              IF cl_numfor(sr.balc,18,g_azi04)<0          #No.CHI-6A0004   #MOD-780004
#                THEN PRINT COLUMN 145,cl_numfor(-1*sr.balc,18,g_azi04) CLIPPED;  #No.CHI-6A0004   #MOD-780004
#                ELSE PRINT COLUMN 145,cl_numfor(sr.balc,18,g_azi04) CLIPPED;     #No.CHI-6A0004   #MOD-780004
#              END IF
#          PRINT COLUMN 165,g_x[50]      CLIPPED
#          IF LINENO > 60 THEN
##            PRINT '└───┴───────────────────────',
##                  '──────────────────┴──────────',
##                  '┴──────────┴──┴──────────┘'
#            PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#            PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                  COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                  COLUMN 112,g_x[44] CLIPPED
#            SKIP TO TOP OF PAGE
#          ELSE
##            PRINT '├───┼──────────────────────',
##                  '───────────────────┼────────',
##                  '──┼──────────┼──┼──────────┤'
#            #PRINT g_x[91],g_x[92],g_x[93],g_x[94],g_x[95],g_x[96] CLIPPED   #MOD-780004
#            PRINT g_x[152],g_x[153],g_x[154]   #MOD-780004
#          END IF
#          IF LINENO = 9 OR LINENO = 0 THEN
##            PRINT '├───┼────────┴──────────────',
##                  '──┴───────────────┼──────────┼',
##                  '──────────┼──┼──────────┤'
#          PRINT g_x[81],g_x[82],g_x[83],g_x[84],g_x[85] CLIPPED
#          END IF
#          #-----MOD-780004---------
#          {
#          PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[22] CLIPPED,g_x[23] CLIPPED,
#                COLUMN 93,g_x[50],cl_numfor(sr.l_d,18,t_azi04) CLIPPED,     #No.CHI-6A0004
#                COLUMN 115,g_x[50],cl_numfor(sr.l_c,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#                COLUMN 137,g_x[50];
#                IF sr.bald>0
#                  THEN PRINT g_x[47] CLIPPED;
#                  ELSE IF sr.bald = 0 THEN PRINT g_x[48] CLIPPED;
#                                      ELSE PRINT g_x[49] CLIPPED;
#                       END IF
#                END IF
#          PRINT COLUMN 143,g_x[50] CLIPPED;
#              IF cl_numfor(sr.bald,18,t_azi04)<0      #No.CHI-6A0004
#                THEN PRINT COLUMN 145,cl_numfor(-1*sr.bald,18,t_azi04) CLIPPED;    #No.CHI-6A0004
#                ELSE PRINT COLUMN 145,cl_numfor(sr.bald,18,t_azi04) CLIPPED;       #No.CHI-6A0004
#              END IF
#          PRINT COLUMN 165,g_x[50]  CLIPPED
#          IF LINENO > 60 THEN
##            PRINT '└───┴──────────────────────',
##                  '───────────────────┴────────',
##                  '──┴──────────┴──┴──────────┘'
#            PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#            PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                  COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                  COLUMN 112,g_x[44] CLIPPED
#            SKIP TO TOP OF PAGE
#          ELSE
##            PRINT '└───┴──────────────────────',
##                 '───────────────────┴────────',
##                  '──┴──────────┴──┴──────────┘'
#            PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#          END IF
#          }
#          #-----END MOD-780004-----
#        ELSE
#            PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#                COLUMN 9,g_x[20] CLIPPED,g_x[21] CLIPPED,
#                COLUMN 93,g_x[50],cl_numfor(sr.aah.aah04,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#                COLUMN 115,g_x[50],cl_numfor(sr.aah.aah05,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#                COLUMN 137,g_x[50] CLIPPED;
#                IF sr.balc>0
#                  THEN PRINT g_x[47] CLIPPED;
#                  ELSE IF sr.balc = 0 THEN PRINT g_x[48] CLIPPED;
#                                      ELSE PRINT g_x[49] CLIPPED;
#                       END IF
#                END IF
#            PRINT COLUMN 143,g_x[50] CLIPPED;
#                IF cl_numfor(sr.balc,18,g_azi04)<0      #No.CHI-6A0004   #MOD-780004
#                  THEN PRINT COLUMN 145,cl_numfor(-1*sr.balc,18,g_azi04) CLIPPED;    #No.CHI-6A0004   #MOD-780004
#                  ELSE PRINT COLUMN 145,cl_numfor(sr.balc,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#                END IF
#            PRINT COLUMN 165,g_x[50]  CLIPPED
#            IF LINENO > 60 THEN
##              PRINT '└───┴──────────────────────',
##                    '───────────────────┴────────',
##                    '──┴──────────┴──┴──────────┘'
#              PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#              PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                    COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                    COLUMN 112,g_x[44] CLIPPED
#              SKIP TO TOP OF PAGE
#            ELSE
##              PRINT '├───┼──────────────────────',
##                    '───────────────────┼────────',
##                    '──┼──────────┼──┼──────────┤'
#              PRINT g_x[89],g_x[90],g_x[58],g_x[59],g_x[60] CLIPPED
#            END IF
#            IF LINENO = 9 THEN
##              PRINT '├───┼────────┼─────────────',
##                    '───┼───────────────┼────────',
##                    '──┼──────────┼──┼──────────┤'
#              PRINT g_x[56],g_x[57],g_x[58],g_x[59],g_x[60] CLIPPED
#            END IF
#            PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#                  COLUMN 9,g_x[22] CLIPPED,g_x[23] CLIPPED,
#                  COLUMN 93,g_x[50],cl_numfor(sr.l_d,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#                  COLUMN 115,g_x[50],cl_numfor(sr.l_c,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#                  COLUMN 137,g_x[50] CLIPPED;
#                  IF sr.bald>0
#                    THEN PRINT g_x[47] CLIPPED;
#                    ELSE IF sr.bald = 0 THEN PRINT g_x[48] CLIPPED;
#                                        ELSE PRINT g_x[49] CLIPPED;
#                         END IF
#                  END IF
#            PRINT COLUMN 143,g_x[50] CLIPPED;
#                IF cl_numfor(sr.bald,18,g_azi04)<0    #No.CHI-6A0004   #MOD-780004
#                  THEN PRINT COLUMN 145,cl_numfor(-1*sr.bald,18,g_azi04) CLIPPED;   #No.CHI-6A0004   #MOD-780004
#                  ELSE PRINT COLUMN 145,cl_numfor(sr.bald,18,g_azi04) CLIPPED;      #No.CHI-6A0004   #MOD-780004
#                END IF
#            PRINT COLUMN 165,g_x[50] CLIPPED
##              PRINT '└───┴───────────────────────',
##                    '──────────────────┴──────────',
##                    '┴──────────┴──┴──────────┘'
#              PRINT g_x[71],g_x[72],g_x[73],g_x[74],g_x[75] CLIPPED
#              PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 34,g_x[45] CLIPPED,
#                    COLUMN 60,g_x[7] CLIPPED,COLUMN 86,g_x[46] CLIPPED,
#                    COLUMN 112,g_x[44] CLIPPED
#        END IF
#END REPORT
 
#REPORT gglr320_rep_f(sr)
#  DEFINE
#       sr     RECORD
#                   m_aba02 LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#                   aag01   LIKE aag_file.aag01,    # acct. name
#                   aag02   LIKE aag_file.aag02,    # acct. name
#                   aag13   LIKE aag_file.aag13,    #FUN-6C0012
#                   aba02   LIKE aba_file.aba02,
#                   aba04   LIKE aba_file.aba04,
#                   abb     RECORD LIKE abb_file.*,
#                   abbl    RECORD LIKE abb_file.*,
#                   aas     RECORD LIKE aas_file.*,
#                   tas     RECORD LIKE tas_file.*,
#                   aah     RECORD LIKE aah_file.*,
#                   tah     RECORD LIKE tah_file.*,
#                   b_bal      LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   b_balf     LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   b_d        LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   b_df       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   l_df       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   b_c        LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   b_cf       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   l_cf       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   bala       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   balaf      LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   l_d        LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   l_c        LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   balb       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   balbf      LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   bald       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   baldf      LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   balc       LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   balcf      LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                            
#                   l_abb07_l  LIKE abb_file.abb07,       #NO.FUN-690009   DEC(20,6)                                                
#                   l_abb07_r  LIKE abb_file.abb07,       #NO.FUN-690009   DEC(20,6)                                                
#                   s_aas04    LIKE aas_file.aas04,       #NO.FUN-690009   DEC(20,6)                                                
#                   s_aas05    LIKE aas_file.aas05,       #NO.FUN-690009   DEC(20,6)                                                
#                   s_tas04    LIKE tas_file.tas04,       #NO.FUN-690009   DEC(20,6)
#                   s_tas05    LIKE tas_file.tas05,       #NO.FUN-690009   DEC(20,6)                                                
#                   s_tas09    LIKE tas_file.tas09,       #NO.FUN-690009   DEC(20,6)                                                
#                   s_tas10    LIKE tas_file.tas10,       #NO.FUN-690009   DEC(20,6)                                                
#                   l_abb07f_l LIKE abb_file.abb07,       #NO.FUN-690009   DEC(20,6)                                                
#                   l_abb07f_r LIKE abb_file.abb07,       #NO.FUN-690009   DEC(20,6)                                                
#                   l_aba02    LIKE aba_file.aba02,       #NO.FUN-690009   DATE                                                     
#                   aag02_o    LIKE aag_file.aag02,       #NO.FUN-690009   VARCHAR(30)                                                 
#                   aag13_o    LIKE aag_file.aag13,       #FUN-6C0012
#                   l_aba04    LIKE aba_file.aba04,       #NO.FUN-690009   SMALLINT                                                 
#                   l_abb01    LIKE abb_file.abb01,       #No.MOD-570145                                                            
#                   l_abb06    LIKE abb_file.abb06,       #NO.FUN-690009   VARCHAR(01)                                                 
#                   l_abb02    LIKE abb_file.abb02,       #NO.FUN-690009   SMALLINT                                                 
#                   l_bala     LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)   # add 030819 NO.A085                     
#                   l_balaf    LIKE type_file.num20_6     #NO.FUN-690009   DECIMAL(20,6)   # add 030819 NO.A085                     
#                END RECORD                                                                                                         
# DEFINE l_bal,l_amt     LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                                  
# Prog. Version..: '5.30.06-13.03.12(02)        #add 030731 NO.A085                            
#        l_res           LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)   #add 030731 NO.A085                            
#        l_resf          LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)   #A085 03/07/31
#        l_cnt           LIKE type_file.num5,       #NO.FUN-690009   SMALLINT        #add 030731 NO.A085                            
#        l_month         LIKE type_file.chr2,       #NO.FUN-690009   VARCHAR(2)         #add 030731 NO.A085                            
#        s_tas04,s_tas05 LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)                                                  
#        s_tas09,s_tas10 LIKE type_file.num20_6,    #NO.FUN-690009   DECIMAL(20,6)
#        e_date,b_date   LIKE type_file.dat         #NO.FUN-690009   DATE          
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
# ORDER BY sr.aag01,sr.aba04,sr.m_aba02,sr.aba02,sr.abb.abb01,sr.abb.abb02
# FORMAT
#  PAGE HEADER
#     PRINT (250-FGL_WIDTH(g_company))/2 SPACES,g_company
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN 225,'FROM:',g_user CLIPPED
#     PRINT (250-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_cn = g_cn + 1                 #add 030731 NO.A085
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN 121,tm.yyyy CLIPPED,g_x[3] CLIPPED
#     PRINT COLUMN 2,g_x[2] CLIPPED,sr.aag01
#     #FUN-6C0012.....begin
#     IF tm.e = 'N' THEN
#        PRINT COLUMN 2,g_x[5] CLIPPED,sr.aag02;
#     ELSE
#        PRINT COLUMN 2,g_x[5] CLIPPED,sr.aag13;
#     END IF  
#     #FUN-6C0012.....end
#     PRINT COLUMN 225,g_x[4] CLIPPED,
#           g_pageno USING '<<<'
##     PRINT '┌───┬────────┬────────────────┬',   #No.MOD-570145
##           '───────────────┬────┬────────',
##           '─────────────┬───────────────',
##           '──────┬───────────────────────┐'
#     PRINT g_x[101],g_x[102],g_x[103],g_x[104],g_x[105],g_x[106],g_x[107],
#           g_x[108] CLIPPED
#     PRINT COLUMN 1,g_x[24] CLIPPED,g_x[25] CLIPPED,g_x[26] CLIPPED,
#                    g_x[27] CLIPPED,g_x[28] CLIPPED,g_x[29] CLIPPED
##     PRINT '├───┼────────┼────────────────┼',   #No.MOD-570145
##           '───────────────q────┼──────────┬─',
##           '─────────┼──────────┬──────────┼─┬──────────┬',
##           '──────────┤'
#     PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[115],g_x[116],g_x[117],
#           g_x[118] CLIPPED
#     PRINT COLUMN 1,g_x[30] CLIPPED,g_x[31] CLIPPED,g_x[32] CLIPPED,
#                    g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED
#     #PRINT COLUMN 1,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,   #MOD-780004
#     #               g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED    #MOD-780004
#
#   BEFORE GROUP OF sr.aag01
#     #add 030731 NO.A085
#     LET l_month = sr.m_aba02 - 1
#     OPEN curs_pageno USING l_month,sr.aag01
#     FETCH curs_pageno INTO g_pageno
#     IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#     IF g_cn = 1 THEN
#        LET g_pageno = g_pageno + 1
#     END IF
#     ###
#     SKIP TO TOP OF PAGE
 
#   ON EVERY ROW
#     ### add 030812 NO.A085
#     IF NOT cl_null(sr.aba02) THEN
#     ###
#     IF LINENO = 12 THEN
##       PRINT '├───┼────────┼───────────────',    #No.MOD-570145
##             '─┼───────────────┼────┼────────',
##             '──┼──────────┼──────────┼──────────┼─┼─',
##             '─────────┼──────────┤'
#       PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[119],g_x[120],g_x[121],
#             g_x[122] CLIPPED
#     END IF
#     #add 030731 NO.A085
#     IF sr.l_abb07_l  IS NULL THEN LET sr.l_abb07_l = 0 END IF
#     IF sr.l_abb07_r  IS NULL THEN LET sr.l_abb07_r = 0 END IF
#     IF sr.l_abb07f_l IS NULL THEN LET sr.l_abb07f_l= 0 END IF
#     IF sr.l_abb07f_r IS NULL THEN LET sr.l_abb07f_r= 0 END IF
#     LET l_res = 0
#     LET l_dir = ''
#     #add 030815 NO.A085
#    #LET l_res = sr.bala + sr.l_abb07_l - sr.l_abb07_r
#    #LET l_resf= sr.balaf+ sr.l_abb07f_l - sr.l_abb07f_r
#     IF tm.mm = 1 THEN
#        LET l_res = sr.b_bal + sr.s_tas04 - sr.s_tas05 CLIPPED
#        LET l_resf= sr.b_balf + sr.s_tas09 - sr.s_tas10 CLIPPED
#     ELSE
#        LET l_res = sr.l_bala  + sr.s_tas04 - sr.s_tas05 CLIPPED
#        LET l_resf= sr.l_balaf + sr.s_tas09 - sr.s_tas10 CLIPPED
#     END IF
#     CASE
#         WHEN l_res > 0 LET l_dir = g_x[47] CLIPPED
#         WHEN l_res = 0 LET l_dir = g_x[48] CLIPPED
#         WHEN l_res < 0 LET l_dir = g_x[49] CLIPPED
#                        LET l_res = l_res*-1
#     OTHERWISE
#     END CASE
#     IF sr.l_abb07_l = 0 THEN LET sr.l_abb07_l = NULL END IF
#     IF sr.l_abb07_r = 0 THEN LET sr.l_abb07_r = NULL END IF
#     IF sr.l_abb07f_l= 0 THEN LET sr.l_abb07f_l= NULL END IF
#     IF sr.l_abb07f_r= 0 THEN LET sr.l_abb07f_r= NULL END IF
#     ###
#     IF sr.abb.abb01 = sr.abbl.abb01 AND sr.abb.abb02 = sr.abbl.abb02 THEN
##No.MOD-570145 --start
#       PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,COLUMN 9,g_x[50] CLIPPED,
#                  sr.abb.abb01 CLIPPED,COLUMN 27,g_x[50] CLIPPED,sr.abb.abb04 CLIPPED;
#       #FUN-6C0012.....begin
#       IF tm.e ='N' THEN
#          PRINT COLUMN 61,g_x[50] CLIPPED,sr.aag02_o CLIPPED,COLUMN 93,g_x[50] CLIPPED;
#       ELSE
#          PRINT COLUMN 61,g_x[50] CLIPPED,sr.aag13_o CLIPPED,COLUMN 93,g_x[50] CLIPPED;
#       END IF
#       #FUN-6C0012.....end
#       PRINT sr.abb.abb24 CLIPPED,COLUMN 103,g_x[50],COLUMN 125,g_x[50],
#             COLUMN 147,g_x[50],COLUMN 169,g_x[50],COLUMN 191,g_x[50],
#             COLUMN 195,g_x[50],COLUMN 217,g_x[50],COLUMN 239,g_x[50]
#       PRINT g_x[50],COLUMN 9,g_x[50],COLUMN 27,g_x[50],COLUMN 61,g_x[50],
#             COLUMN 93,g_x[50],
#             COLUMN 97,cl_numfor(sr.abb.abb25,5,t_azi07) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#             COLUMN 103,g_x[50],
#             COLUMN 104,cl_numfor(sr.l_abb07f_l,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#             COLUMN 125,g_x[50],COLUMN 118,cl_numfor(sr.l_abb07_l,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50],cl_numfor(sr.l_abb07f_r,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#             COLUMN 169,g_x[50],cl_numfor(sr.l_abb07_r,18,g_azi04) CLIPPED,     #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50],l_dir CLIPPED ,                     #add NO.A085
#             COLUMN 195,g_x[50],cl_numfor(l_resf,18,t_azi04) CLIPPED,#add NO.A085    #No.CHI-6A0004
#             COLUMN 217,g_x[50],cl_numfor(l_res,18,g_azi04) CLIPPED,#add NO.A085     #No.CHI-6A0004   #MOD-780004
#             COLUMN 239,g_x[50]
#       IF LINENO >= 60 THEN
##         PRINT '└───┴────────┴──────────────',
##               '──┴───────────────┴────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[123],g_x[124],g_x[125],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '├───┼────────┼──────────────',
##               '──┼───────────────┼────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[119],g_x[120],g_x[121],
#               g_x[122] CLIPPED
#       END IF
#     ELSE
#       PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,COLUMN 9,g_x[50] CLIPPED,
#                  sr.abb.abb01 CLIPPED,COLUMN 27,g_x[50] CLIPPED,sr.abb.abb04 CLIPPED;
#       #FUN-6C0012.....begin
#       IF tm.e = 'N' THEN
#          PRINT COLUMN 61,g_x[50] CLIPPED,sr.aag02_o CLIPPED,COLUMN 93,g_x[50] CLIPPED;
#       ELSE
#          PRINT COLUMN 61,g_x[50] CLIPPED,sr.aag13_o CLIPPED,COLUMN 93,g_x[50] CLIPPED;
#       END IF
#       #FUN-6C0012.....end
#       PRINT sr.abb.abb24 CLIPPED,COLUMN 103,g_x[50],COLUMN 125,g_x[50] CLIPPED,
#             COLUMN 147,g_x[50],COLUMN 169,g_x[50],COLUMN 191,g_x[50] CLIPPED,
#             COLUMN 195,g_x[50],COLUMN 217,g_x[50],COLUMN 239,g_x[50]
#       PRINT g_x[50],COLUMN 9,g_x[50],COLUMN 27,g_x[50],COLUMN 61,g_x[50],
#             COLUMN 93,g_x[50],
#             COLUMN 97,cl_numfor(sr.abb.abb25,5,t_azi07) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 103,g_x[50],
#             COLUMN 104,cl_numfor(sr.l_abb07f_l,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#             COLUMN 125,g_x[50],
#             COLUMN 118,cl_numfor(sr.l_abb07_l,18,g_azi04) CLIPPED,     #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50],cl_numfor(sr.l_abb07f_r,18,t_azi04) CLIPPED,   #No.CHI-6A0004
#             COLUMN 169,g_x[50],cl_numfor(sr.l_abb07_r,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50],l_dir CLIPPED ,                     #add A085
#             COLUMN 195,g_x[50],cl_numfor(l_resf,18,t_azi04) CLIPPED,#add A085  #No.CHI-6A0004
#             COLUMN 217,g_x[50],cl_numfor(l_res,18,g_azi04) CLIPPED,#add A085   #No.CHI-6A0004   #MOD-780004
#             COLUMN 239,g_x[50]
#       IF LINENO >= 60 THEN
##         PRINT '└───┴────────┴──────────────',
##               '──┴───────────────┴────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[123],g_x[124],g_x[125],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '├───┼────────┴────────────────',
##               '┴───────────────┴────┼──────────',
##               '┼──────────┼──────────┼──────────┼─┼────',
##               '──────┼──────────┤'
#         PRINT g_x[131],g_x[132],g_x[133],g_x[134],g_x[135],g_x[136],g_x[137],
#               g_x[138] CLIPPED
#       END IF
#     END IF
#     ### add 030812 NO.A085
#     END IF
#     ###
 
#   AFTER GROUP OF sr.aba02
#     ### add 030812 NO.A085
#     IF NOT cl_null(sr.aba02) THEN
#     ###
#     IF LINENO = 12 THEN
##       PRINT '├───┼────────┼───────────────',    #MOD-570145
##             '─┼───────────────┼────┼────',
##             '──────┼──────────┼──────────┼──────────┼─┼─',
##             '─────────┼──────────┤'
#       PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[119],g_x[120],g_x[121],
#             g_x[122] CLIPPED
#     END IF
#     CALL s_azn01(tm.yyyy,1) RETURNING b_date,e_date
#     IF g_aaz.aaz51 = 'Y'
#       THEN SELECT tas04,tas05,tas09,tas10
#              INTO sr.tas.tas04,sr.tas.tas05,sr.tas.tas09,sr.tas.tas10
#              FROM tas_file WHERE tas00 = b AND tas01 = sr.aag01  #No.FUN-740055 
#                              AND tas02 = sr.aba02 AND tas08 = tm.bb
#            SELECT SUM(tas04),SUM(tas05),SUM(tas09),SUM(tas10)
#              INTO s_tas04,s_tas05,s_tas09,s_tas10 FROM tas_file
#             WHERE tas00 = b AND tas01 = sr.aag01 AND tas08 = tm.bb  #No.FUN-740055 
#               AND tas02 <= sr.aba02 AND tas02 >= b_date
#       ELSE LET sr.tas.tas04 = cl_numfor(GROUP SUM(sr.l_abb07_l),13,g_azi04)   #No.CHI-6A0004   #MOD-780004
#            LET sr.tas.tas05 = cl_numfor(GROUP SUM(sr.l_abb07_r),13,g_azi04)   #No.CHI-6A0004   #MOD-780004
#            LET sr.tas.tas09 = cl_numfor(GROUP SUM(sr.l_abb07f_l),13,t_azi04)  #No.CHI-6A0004
#            LET sr.tas.tas10 = cl_numfor(GROUP SUM(sr.l_abb07f_r),13,t_azi04)  #No.CHI-6A0004
#     END IF
#     IF sr.tas.tas04 IS NULL THEN LET sr.tas.tas04 = 0 END IF
#     IF sr.tas.tas05 IS NULL THEN LET sr.tas.tas05 = 0 END IF
#     IF sr.tas.tas09 IS NULL THEN LET sr.tas.tas09 = 0 END IF
#     IF sr.tas.tas10 IS NULL THEN LET sr.tas.tas10 = 0 END IF
#     IF      s_tas04 IS NULL THEN LET      s_tas04 = 0 END IF
#     IF      s_tas05 IS NULL THEN LET      s_tas05 = 0 END IF
#     IF      s_tas09 IS NULL THEN LET      s_tas09 = 0 END IF
#     IF      s_tas10 IS NULL THEN LET      s_tas10 = 0 END IF
#     IF g_aaz.aaz51 = 'Y'
#       THEN LET sr.balb  = sr.b_bal  + s_tas04 - s_tas05
#            LET sr.balbf = sr.b_balf + s_tas09 - s_tas10
#       ELSE IF tm.mm = 1 THEN
#               LET sr.balb  = sr.b_bal  + sr.s_tas04 - sr.s_tas05
#               LET sr.balbf = sr.b_balf + sr.s_tas09 - sr.s_tas10
#            ELSE
#               LET sr.balb  = sr.bala  + sr.s_tas04 - sr.s_tas05
#               LET sr.balbf = sr.balaf + sr.s_tas09 - sr.s_tas10
#            END IF
#     END IF
#     IF sr.aba02 = sr.l_aba02 THEN
#       PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,
#             COLUMN 9,g_x[42] CLIPPED,g_x[43] CLIPPED,
##No.BUF-570145 --start
#             COLUMN 103,g_x[50] CLIPPED,COLUMN 104,cl_numfor(sr.tas.tas09,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#             COLUMN 125,g_x[50] CLIPPED,COLUMN 126,cl_numfor(sr.tas.tas04,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50] CLIPPED,COLUMN 148,cl_numfor(sr.tas.tas10,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#             COLUMN 169,g_x[50] CLIPPED,COLUMN 170,cl_numfor(sr.tas.tas05,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50];
#             IF sr.balb>0
#               THEN PRINT g_x[47] CLIPPED;
#               ELSE IF sr.balb = 0 THEN PRINT g_x[48] CLIPPED;
#                                   ELSE PRINT g_x[49] CLIPPED;
#                    END IF
#             END IF
#       PRINT COLUMN 195,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balbf,18,t_azi04)<0   #No.CHI-6A0004
#               THEN PRINT COLUMN 196,cl_numfor(-1*sr.balbf,18,t_azi04) CLIPPED;   #No.CHI-6A0004
#               ELSE PRINT COLUMN 196,cl_numfor(sr.balbf,18,t_azi04) CLIPPED;      #No.CHI-6A0004
#             END IF
#       PRINT COLUMN 217,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balb,18,g_azi04)<0   #No.CHI-6A0004   #MOD-780004
#               THEN PRINT COLUMN 218,cl_numfor(-1*sr.balb,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#               ELSE PRINT COLUMN 218,cl_numfor(sr.balb,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#             END IF
#       PRINT COLUMN 239,g_x[50] CLIPPED
#       IF LINENO > 60 THEN
##         PRINT '└───┴───────────────────────',
##               '───────────────────────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '├───┼───────────────────────',
##               '───────────────────────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[141],g_x[140],g_x[140],g_x[114],g_x[119],g_x[120],g_x[121],
#               g_x[122] CLIPPED
#       END IF
#     ELSE
#       PRINT g_x[50],sr.aba02 USING "mm/dd" CLIPPED,
#             COLUMN 9,g_x[42] CLIPPED,g_x[43] CLIPPED,
#             COLUMN 103,g_x[50] CLIPPED,COLUMN 104,cl_numfor(sr.tas.tas09,18,t_azi04) CLIPPED,   #No.CHI-6A0004
#             COLUMN 125,g_x[50] CLIPPED,COLUMN 126,cl_numfor(sr.tas.tas04,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50] CLIPPED,COLUMN 148,cl_numfor(sr.tas.tas10,18,t_azi04) CLIPPED,   #No.CHI-6A0004
#             COLUMN 169,g_x[50] CLIPPED,COLUMN 170,cl_numfor(sr.tas.tas05,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50];
#             IF sr.balb>0
#               THEN PRINT g_x[47] CLIPPED;
#               ELSE IF sr.balb = 0 THEN PRINT g_x[48] CLIPPED;
#                                   ELSE PRINT g_x[49] CLIPPED;
#                    END IF
#             END IF
#       PRINT COLUMN 195,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balbf,18,t_azi04)<0     #No.CHI-6A0004
#               THEN PRINT COLUMN 196,cl_numfor(-1*sr.balbf,18,t_azi04) CLIPPED;   #No.CHI-6A0004
#               ELSE PRINT COLUMN 196,cl_numfor(sr.balbf,18,t_azi04) CLIPPED;      #No.CHI-6A0004
#             END IF
#       PRINT COLUMN 217,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balb,18,g_azi04)<0    #No.CHI-6A0004   #MOD-780004
#               THEN PRINT COLUMN 218,cl_numfor(-1*sr.balb,18,g_azi04) CLIPPED;    #No.CHI-6A0004    #MOD-780004
#               ELSE PRINT COLUMN 218,cl_numfor(sr.balb,18,g_azi04) CLIPPED;       #No.CHI-6A0004    #MOD-780004
#             END IF
#       PRINT COLUMN 239,g_x[50]         CLIPPED
#       IF LINENO > 60 THEN
##         PRINT '└───┴───────────────────────',
##               '───────────────────────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '├───┼────────┼─────w────────',
##               '──┼───────────────┼────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[119],g_x[120],g_x[121],
#               g_x[122] CLIPPED
#       END IF
#     END IF
#     ### add 030812 NO.A085
#     END IF
#     ###
#
#   BEFORE GROUP OF sr.m_aba02
#     IF LINENO = 12 THEN
##       PRINT '├───┼────────┴───────────────',
##             '─┴───────────────┴────┼────',
##             '──────┼──────────┼──────────┼──────────┼─┼─',
##             '─────────┼──────────┤'
#       PRINT g_x[131],g_x[132],g_x[133],g_x[134],g_x[135],g_x[136],g_x[137],
#             g_x[138] CLIPPED
#     END IF
#     CALL s_azn01(tm.yyyy,sr.m_aba02) RETURNING b_date,e_date
#     PRINT g_x[50],b_date USING 'mm/dd' CLIPPED,
#           COLUMN 9,g_x[18] CLIPPED,g_x[19] CLIPPED,
#           COLUMN 103,g_x[50],COLUMN 125,g_x[50],COLUMN 147,g_x[50],
#           COLUMN 169,g_x[50],COLUMN 191,g_x[50];
#           IF sr.bala>0
#             THEN PRINT g_x[47] CLIPPED;
#             ELSE IF sr.bala = 0 THEN PRINT g_x[48] CLIPPED;
#                                 ELSE PRINT g_x[49] CLIPPED;
#                  END IF
#           END IF
#     PRINT COLUMN 195,g_x[50] CLIPPED;
#           IF cl_numfor(sr.balaf,18,t_azi04)<0     #No.CHI-6A0004
#             THEN PRINT COLUMN 196,cl_numfor(-1*sr.balaf,18,t_azi04) CLIPPED;   #No.CHI-6A0004
#             ELSE PRINT COLUMN 196,cl_numfor(sr.balaf,18,t_azi04) CLIPPED;      #No.CHI-6A0004
#           END IF
#     PRINT COLUMN 217,g_x[50] CLIPPED;
#           IF cl_numfor(sr.bala,18,g_azi04)<0         #No.CHI-6A0004   #MOD-780004
#             THEN PRINT COLUMN 218,cl_numfor(-1*sr.bala,18,g_azi04) CLIPPED;    #No.CHI-6A0004   #MOD-780004
#             ELSE PRINT COLUMN 218,cl_numfor(sr.bala,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#           END IF
#     PRINT COLUMN 239,g_x[50]   CLIPPED
#     IF LINENO > 60 THEN
##       PRINT '└───┴────────────────────────',
##             '──────────────w───────┴────',
##             '──────┴──────────┴──────────┴──────────┴─┴─',
##             '─────────┴──────────┘'
#       PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#             g_x[130] CLIPPED
#       PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#             COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#             COLUMN 160,g_x[44] CLIPPED
#       SKIP TO TOP OF PAGE
#     ELSE
#       ### add 030812 NO.A085
#       IF cl_null(sr.aba02) THEN
##          PRINT '├───┼────────────────────────',
##                '──────────────────────┼────',
##                '──────┼──────────┼──────────┼──────────┼─┼─',
##                '─────────┼──────────┤'
#         PRINT g_x[141],g_x[140],g_x[140],g_x[114],g_x[119],g_x[120],g_x[121],
#               g_x[122] CLIPPED
#       ELSE
##          PRINT '├───┼────────┬───────────────',
##                '─┬───────────────┬────┼────',
##                '──────┼──────────┼──────────┼──────────┼─┼─',
##                '─────────┼──────────┤'
#          PRINT g_x[142],g_x[143],g_x[144],g_x[134],g_x[135],g_x[136],g_x[137],
#                g_x[138] CLIPPED
#       END IF
#       ###
#     END IF
#
#   AFTER GROUP OF sr.m_aba02
#     #add 030731 NO.A085
#     #PAGENO
#     SELECT COUNT(*) INTO l_cnt FROM tpg_file
#      WHERE tpg01=tm.yyyy AND tpg02=sr.m_aba02 AND tpg03=sr.aag01
#     IF l_cnt = 0 THEN
#        INSERT INTO tpg_file(tpg01,tpg02,tpg03,tpg04)
#                      VALUES(tm.yyyy,sr.m_aba02,sr.aag01,g_pageno)
#     ELSE
#        UPDATE tpg_file SET tpg04 = g_pageno
#         WHERE tpg01=tm.yyyy AND tpg02 = sr.m_aba02 AND tpg03 = sr.aag01
#     END IF
#     OPEN curs_pageno USING sr.m_aba02,sr.aag01
#     FETCH curs_pageno INTO g_pageno
#     IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#     ###
#     ### add 030812 NO.A085
#     IF cl_null(sr.aba02) THEN
#        LET  sr.tah.tah04 = 0
#        LET  sr.tah.tah05 = 0
#        LET  sr.tah.tah09 = 0
#        LET  sr.tah.tah10 = 0
#     END IF
#     ###
#     IF LINENO = 12 THEN
##       PRINT '├───┼────────┴───────────────',
##             '─┴───────────────┴────┼────',
##             '──────┼──────────┼──────────┼──────────┼─┼─',
##             '─────────┼──────────┤'
#       PRINT g_x[131],g_x[132],g_x[133],g_x[134],g_x[135],g_x[136],g_x[137],
#             g_x[138] CLIPPED
#     END IF
#     IF sr.aba04 != sr.l_aba04  THEN
#       CALL s_azn01(tm.yyyy,sr.m_aba02) RETURNING b_date,e_date
#       PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#             COLUMN 9,g_x[20] CLIPPED,g_x[21] CLIPPED,
#             COLUMN 103,g_x[50] CLIPPED,COLUMN 104,cl_numfor(sr.tah.tah09,18,t_azi04) CLIPPED, #No.CHI-6A0004
#             COLUMN 125,g_x[50] CLIPPED,COLUMN 126,cl_numfor(sr.tah.tah04,18,g_azi04) CLIPPED, #No.CHI-6A0004    #MOD-780004
#             COLUMN 147,g_x[50] CLIPPED,COLUMN 148,cl_numfor(sr.tah.tah10,18,t_azi04) CLIPPED, #No.CHI-6A0004
#             COLUMN 169,g_x[50] CLIPPED,COLUMN 170,cl_numfor(sr.tah.tah05,18,g_azi04) CLIPPED, #No.CHI-6A0004    #MOD-780004
#             COLUMN 191,g_x[50];
#             IF sr.balc>0
#               THEN PRINT g_x[47] CLIPPED;
#               ELSE IF sr.balc = 0 THEN PRINT g_x[48] CLIPPED;
#                                   ELSE PRINT g_x[49] CLIPPED;
#                    END IF
#             END IF
#       PRINT COLUMN 195,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balcf,18,t_azi04)<0   #No.CHI-6A0004
#               THEN PRINT COLUMN 196,cl_numfor(-1*sr.balcf,18,t_azi04) CLIPPED;  #No.CHI-6A0004
#               ELSE PRINT COLUMN 196,cl_numfor(sr.balcf,18,t_azi04) CLIPPED;     #No.CHI-6A0004
#             END IF
#       PRINT COLUMN 217,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balc,18,g_azi04)<0    #No.CHI-6A0004   #MOD-780004
#               THEN PRINT COLUMN 218,cl_numfor(-1*sr.balc,18,g_azi04) CLIPPED;   #No.CHI-6A0004   #MOD-780004
#               ELSE PRINT COLUMN 218,cl_numfor(sr.balc,18,g_azi04) CLIPPED;      #No.CHI-6A0004   #MOD-780004
#             END IF
#       PRINT COLUMN 239,g_x[50]
#       IF LINENO > 60 THEN
##         PRINT '└───┴───────────────────────',
##               '───────────────────────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '├───┼───────────────────────',
##               '───────────────────────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[141],g_x[140],g_x[140],g_x[114],g_x[119],g_x[120],g_x[121],
#               g_x[122] CLIPPED
#       END IF
#       IF LINENO = 12 THEN
##         PRINT '├───┼────────┼──────────────',
##               '──┼───────────────┼────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[115],g_x[116],g_x[117],
#               g_x[118] CLIPPED
#       END IF
#       PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#             COLUMN 9,g_x[22] CLIPPED,g_x[23] CLIPPED,
#             COLUMN 103,g_x[50],COLUMN 104,cl_numfor(sr.l_df,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#             COLUMN 125,g_x[50],COLUMN 126,cl_numfor(sr.l_d,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50],COLUMN 148,cl_numfor(sr.l_cf,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#             COLUMN 169,g_x[50],COLUMN 170,cl_numfor(sr.l_c,18,g_azi04) CLIPPED,    #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50];
#             IF sr.bald>0
#               THEN PRINT g_x[47] CLIPPED;
#               ELSE IF sr.bald = 0 THEN PRINT g_x[48] CLIPPED;
#                                   ELSE PRINT g_x[49] CLIPPED;
#                    END IF
#             END IF
#       PRINT COLUMN 195,g_x[50] CLIPPED;
#             IF cl_numfor(sr.baldf,18,t_azi04)<0    #No.CHI-6A0004
#               THEN PRINT COLUMN 196,cl_numfor(-1*sr.baldf,18,t_azi04) CLIPPED;   #No.CHI-6A0004
#               ELSE PRINT COLUMN 196,cl_numfor(sr.baldf,18,t_azi04) CLIPPED;      #No.CHI-6A0004
#             END IF
#       PRINT COLUMN 217,g_x[50] CLIPPED;
#             IF cl_numfor(sr.bald,18,g_azi04)<0     #No.CHI-6A0004   #MOD-780004
#               THEN PRINT COLUMN 218,cl_numfor(-1*sr.bald,18,g_azi04) CLIPPED;    #No.CHI-6A0004   #MOD-780004
#               ELSE PRINT COLUMN 218,cl_numfor(sr.bald,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#             END IF
#       PRINT COLUMN 239,g_x[50]
#       IF LINENO > 60 THEN
##         PRINT '└───┴───────────────────────',
##               '───────────────────────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '└───┴───────────────────────',
##               '───────────────────────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#       END IF
#     ELSE
#       PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#             COLUMN 9,g_x[20] CLIPPED,g_x[21] CLIPPED,
#             COLUMN 103,g_x[50],COLUMN 104,cl_numfor(sr.tah.tah09,18,t_azi04) CLIPPED,   #No.CHI-6A0004
#             COLUMN 125,g_x[50],COLUMN 126,cl_numfor(sr.tah.tah04,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50],COLUMN 148,cl_numfor(sr.tah.tah10,18,t_azi04) CLIPPED,   #No.CHI-6A0004
#             COLUMN 169,g_x[50],COLUMN 170,cl_numfor(sr.tah.tah05,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50];
#             IF sr.balc>0
#               THEN PRINT g_x[47] CLIPPED;
#               ELSE IF sr.balc = 0 THEN PRINT g_x[48] CLIPPED;
#                                   ELSE PRINT g_x[49] CLIPPED;
#                    END IF
#             END IF
#       PRINT COLUMN 195,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balcf,18,t_azi04)<0   #No.CHI-6A0004
#               THEN PRINT COLUMN 196,cl_numfor(-1*sr.balcf,18,t_azi04) CLIPPED;    #No.CHI-6A0004
#               ELSE PRINT COLUMN 196,cl_numfor(sr.balcf,18,t_azi04) CLIPPED;       #No.CHI-6A0004
#             END IF
#       PRINT COLUMN 217,g_x[50] CLIPPED;
#             IF cl_numfor(sr.balc,18,g_azi04)<0   #No.CHI-6A0004   #MOD-780004
#               THEN PRINT COLUMN 218,cl_numfor(-1*sr.balc,18,g_azi04) CLIPPED;     #No.CHI-6A0004   #MOD-780004
#               ELSE PRINT COLUMN 218,cl_numfor(sr.balc,18,g_azi04) CLIPPED;        #No.CHI-6A0004   #MOD-780004
#             END IF
#       PRINT COLUMN 239,g_x[50]
#       IF LINENO > 60 THEN
##         PRINT '└───┴───────────────────────',
##               '───────────────────────┴──',
##               '────────┴──────────┴──────────┴──────────┴',
##               '─┴──────────┴──────────┘'
#         PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#               g_x[130] CLIPPED
#         PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#               COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#               COLUMN 160,g_x[44] CLIPPED
#         SKIP TO TOP OF PAGE
#       ELSE
##         PRINT '├───┼───────────────────────',
##               '───────────────────────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[141],g_x[140],g_x[140],g_x[114],g_x[119],g_x[120],g_x[121],
#               g_x[122] CLIPPED
#       END IF
#       IF LINENO = 12 THEN
##         PRINT '├───┼────────┼──────────────',
##               '──┼───────────────┼────┼──',
##               '────────┼──────────┼──────────┼──────────┼',
##               '─┼──────────┼──────────┤'
#         PRINT g_x[111],g_x[112],g_x[113],g_x[114],g_x[115],g_x[116],g_x[117],
#               g_x[118] CLIPPED
#       END IF
#       PRINT g_x[50],e_date USING "mm/dd" CLIPPED,
#             COLUMN 9,g_x[22] CLIPPED,g_x[23] CLIPPED,
#             COLUMN 103,g_x[50],COLUMN 104,cl_numfor(sr.l_df,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#             COLUMN 125,g_x[50],COLUMN 126,cl_numfor(sr.l_d,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 147,g_x[50],COLUMN 148,cl_numfor(sr.l_cf,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#             COLUMN 169,g_x[50],COLUMN 170,cl_numfor(sr.l_c,18,g_azi04) CLIPPED,   #No.CHI-6A0004   #MOD-780004
#             COLUMN 191,g_x[50];
#             IF sr.bald>0
#               THEN PRINT g_x[47] CLIPPED;
#               ELSE IF sr.bald = 0 THEN PRINT g_x[48] CLIPPED;
#                                   ELSE PRINT g_x[49] CLIPPED;
#                    END IF
#             END IF
#       PRINT COLUMN 195,g_x[50] CLIPPED;
#             IF cl_numfor(sr.baldf,18,t_azi04)<0   #No.CHI-6A0004
#               THEN PRINT COLUMN 196,cl_numfor(-1*sr.baldf,18,t_azi04) CLIPPED;   #No.CHI-6A0004
#               ELSE PRINT COLUMN 196,cl_numfor(sr.baldf,18,t_azi04) CLIPPED;      #No.CHI-6A0004
#             END IF
#       PRINT COLUMN 217,g_x[50] CLIPPED;
#             IF cl_numfor(sr.bald,18,g_azi04)<0    #No.CHI-6A0004   #MOD-780004
#               THEN PRINT COLUMN 218,cl_numfor(-1*sr.bald,18,g_azi04) CLIPPED;    #No.CHI-6A0004   #MOD-780004
#               ELSE PRINT COLUMN 218,cl_numfor(sr.bald,18,g_azi04) CLIPPED;       #No.CHI-6A0004   #MOD-780004
#             END IF
#       PRINT COLUMN 239,g_x[50]
##       PRINT '└───┴────────────────────────',
##             '──────────────────────┴────',
##             '──────┴──────────┴─────────',
##             '─┴──────────┴─┴──────────┴─',
##            '─────────┘'
#       PRINT g_x[139],g_x[140],g_x[140],g_x[126],g_x[127],g_x[128],g_x[129],
#             g_x[130] CLIPPED
##No.MOD-590097 --end--
#       PRINT COLUMN 2,g_x[6] CLIPPED,COLUMN 43,g_x[45] CLIPPED,
#             COLUMN 82,g_x[7] CLIPPED,COLUMN 121,g_x[46] CLIPPED,
#             COLUMN 160,g_x[44] CLIPPED
##No.MOD-570145 --end
#     END IF
#END REPORT
#No.FUN-890102   END
#Patch....NO.TQC-610037 <001> #
