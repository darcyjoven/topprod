# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr305.4gl
# Descriptions...: 科目餘額表
# Date & Author..: 02/09/10 by Jack
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify ........: No.A119 04/04/01 By Danny
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-540171 05/05/17 By ching fix科目層級小計累加問題
# Modify.........: No.MOD-560249 05/07/01 By wujie 修正查詢期間無異動時，有期初余額卻無法抓取
# Modify.........: No.MOD-580314 05/08/29 By Smapmin GROUP BY 有誤
# Modify.........: No.TQC-630127 06/03/21 By yoyo 程序當出，沒有勾選外幣,但幣別欄位為空時，無法離開i狀態
# Modify.........: No.MOD-650021 06/05/12 By Smapmin 修改g_len
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670107 06/08/24 By cheunl voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 報表打印額外名稱
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.TQC-740053 07/04/12 By Xufeng SQL語句mark了，后邊判斷sql出錯的語句應去掉
# Modify.........: No.FUN-740055 07/04/13 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-740305 07/04/30 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-780031 07/08/21 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-780073 07/10/26 By wujie   期末余額有錯
# Modify.........: No.MOD-860252 09/02/03 By chenl   增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.MOD-920174 09/02/18 By liuxqa 修正TQC-780073 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/14 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/17 By yinhy 查詢條件為空，跳到科目編號欄位 
# Modify.........: No:MOD-B30662 11/03/24 By Dido 當勾選外幣後,幣別需要設定為 required 
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			#Print condition RECORD
              wc       LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(500)    #Where Condiction
              yy,m1,m2 LIKE type_file.num10,   #NO FUN-690009   INTEGER
              a        LIKE type_file.num5,    #NO FUN-690009   SMALLINT
              y        LIKE type_file.num5,    #NO FUN-690009   SMALLINT      #層級
              n        LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #print 外幣
              b        LIKE azi_file.azi01,    #NO FUN-690009   VARCHAR(4)       #幣別
              e        LIKE type_file.chr1,    #FUN-6C0012
              h        LIKE type_file.chr1,    #MOD-860252
              more     LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #是輸入其它特殊列印條件
           bookno      LIKE aba_file.aba00     #帳別編號        #No.FUN-740055
              END RECORD,
          g_tah4ysum    LIKE tah_file.tah09,
          g_tah5bsum    LIKE tah_file.tah04,
          g_tah7ysum    LIKE tah_file.tah09,
          g_tah8bsum    LIKE tah_file.tah04,
#         g_bookno      LIKE aba_file.aba00,#帳別編號
          g_dash1_1     LIKE type_file.chr1000 #NO FUN-690009   VARCHAR(300)
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING  #No.FUN-780031
DEFINE   g_str           STRING  #No.FUN-780031
DEFINE   g_sql           STRING  #No.FUN-780031
 
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
   #No.FUN-780031  --Begin
   LET g_sql = " tah01.tah_file.tah01,",                                        
               " aag02.aag_file.aag02,",                                        
               " aag13.aag_file.aag13,",                                        
               " aag07.aag_file.aag07,",                                        
               " aag24.aag_file.aag24,",                                        
               " tah08.tah_file.tah08,",                                        
               " taha.zaa_file.zaa08,",                                         
               " tah4y.tah_file.tah09,",                                        
               " tah5b.tah_file.tah04,",                                        
               " tah09.tah_file.tah09,",                                        
               " tah04.tah_file.tah04,",                                        
               " tah10.tah_file.tah10,",                                        
               " tah05.tah_file.tah05,",                                        
               " tahb.zaa_file.zaa08,",                                         
               " tah7y.tah_file.tah09,",                                        
               " tah8b.tah_file.tah04,",                                        
               " azi04.azi_file.azi04,",                                        
               " azi05.azi_file.azi05 " 
 
   LET l_table = cl_prt_temptable('gglr305',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?      ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780031  --End
 
#NO.FUN-690009------------------begin--------------------
 #No.MOD-560249--begin
#   DROP TABLE r305_tmp
#   CREATE TEMP TABLE r305_tmp
#   (aah01     VARCHAR(24))
#   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF
#No.MOD-560249--end
#NO.FUN-690009------------------END-----------------------
#NO.FUN-690009------------------begin--------------------                                                                           
 #No.MOD-560249--begin                                                                                                              
   DROP TABLE r305_tmp                                                                                                              
   CREATE TEMP TABLE r305_tmp(                                 
                                 aah01    LIKE aah_file.aah01)                                                                                                             
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF                                                            
 #No.MOD-560249--end                                                                                                                
#NO.FUN-690009------------------END-----------------------
 
#  LET g_bookno=ARG_VAL(1)     #No.FUN-740055
   LET tm.bookno=ARG_VAL(1)    #No.FUN-740055
   LET g_pdate =ARG_VAL(2)              	# Get arguments from command line
   LET g_towhom=ARG_VAL(3)
   LET g_rlang =ARG_VAL(4)
   LET g_bgjob =ARG_VAL(5)
   LET g_prtway=ARG_VAL(6)
   LET g_copies=ARG_VAL(7)
   LET tm.wc   =ARG_VAL(8)
  #-----TQC-610056---------
  LET tm.yy = ARG_VAL(9)
  LET tm.m1 = ARG_VAL(10)
  LET tm.m2 = ARG_VAL(11)
  LET tm.a = ARG_VAL(12)
  LET tm.y = ARG_VAL(13)
  LET tm.n = ARG_VAL(14)
  LET tm.b = ARG_VAL(15)
  #-----END TQC-610056-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#  IF g_bookno = ' ' OR g_bookno IS NULL THEN   #No.FUN-740055
#     LET g_bookno = g_aaz.aaz64                #帳別若為空白則使用預設帳別     #No.FUN-740055
#  END IF                                       #No.FUN-740055
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN #No.FUN-740055 
      LET tm.bookno = g_aza.aza81               #帳別若為空白則使用預設帳別     #No.FUN-740055
   END IF                                       #No.FUN-740055   
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aag00
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
#  SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004
#  IF SQLCA.sqlcode THEN   #No.TQC-740053
#        CALL cl_err(g_aaa03,SQLCA.sqlcode,0)    No.FUN-660124
#        CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124 #No.TQC-740053
#  END IF  #No.TQC-740053

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglr305_tm()	        	# Input print condition
      ELSE CALL gglr305()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr305_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd		LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_chk_bookno    LIKE type_file.num5      #FUN-B20010
   
#  CALL s_dsmark(g_bookno)  #No.FUN-740055   
   CALL s_dsmark(tm.bookno) #No.FUN-740055
   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW gglr305_w AT p_row,p_col
        WITH FORM "ggl/42f/gglr305"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)    #No.FUN-740055 
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bookno = g_aza.aza81     #FUN-B20010
   LET tm.yy    = YEAR(TODAY)
   LET tm.m1    = 1
   LET tm.m2    = MONTH(TODAY)
   LET tm.a     = '1'
   LET tm.n     = 'N'
   LET tm.b     = '    '
   LET tm.e     = 'N'  #FUN-6C0012
   LET tm.h     = 'Y'  #No.MOD-860252
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
            IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(tm.bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
               NEXT FIELD bookno
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
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
 
  END CONSTRUCT
#No.FUN-B20010  --Mark Begin

#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW gglr305_w EXIT PROGRAM
#   END IF
 
   #INPUT BY NAME tm.bookno,tm.yy, tm.m1, tm.m2,tm.a,tm.y,tm.n, tm.b, tm.e, tm.h, tm.more #FUN-6C0012   #No.FUN-740055 #No.MOD-860252 #FUN-B20010 mark
#No.FUN-B20010  --Mark End
   INPUT BY NAME tm.yy, tm.m1, tm.m2,tm.a,tm.y,tm.n, tm.b, tm.e, tm.h, tm.more ATTRIBUTE(WITHOUT DEFAULTS) #FUN-B20010 
         #WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
   
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
     
      AFTER FIELD m1
         IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF
         IF tm.m1<1 OR tm.m1>13 THEN NEXT FIELD m1 END IF
     
      AFTER FIELD m2
         IF cl_null(tm.m2) THEN NEXT FIELD m2 END IF
         IF tm.m2<1 OR tm.m2>13 THEN NEXT FIELD m2 END IF
         IF tm.m2<tm.m1 THEN NEXT FIELD m2 END IF
     
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES "[12]" THEN NEXT FIELD a END IF
     
      BEFORE FIELD y
         IF g_aza.aza26 != '2' THEN
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
         END IF
         IF tm.a = '2' THEN
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
         END IF
   
      AFTER FIELD n
         IF tm.n NOT MATCHES "[YN]" THEN NEXT FIELD n END IF
         IF tm.n = 'N' THEN
            CALL cl_set_comp_entry("b",FALSE)          #TQC-630127
            LET tm.b = ' '
            DISPLAY BY NAME tm.b
         END IF
#TQC-630127--start
         IF tm.n='Y' THEN
            CALL cl_set_comp_entry("b",TRUE)    
            CALL cl_set_comp_required("b",TRUE)  #MOD-B30662 
         END IF 
#TQC-630127--end

      BEFORE FIELD b
         IF tm.n = 'N' THEN
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
         END IF
      
      AFTER FIELD b
        IF tm.n='Y' THEN      #TQC-630127
         SELECT azi01 FROM azi_file WHERE azi01 = tm.b
           IF SQLCA.sqlcode THEN
#             CALL cl_err(tm.b,'agl-109',0)   #No.FUN-660124
              CALL cl_err3("sel","azi_file",tm.b,"","agl-109","","",0)   #No.FUN-660124
              NEXT FIELD b
           END IF
        END IF       #TQC-630127
      
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

#No.FUN-B20010  --Mark Begin 
################################################################################
# START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
#
#        #No.FUN-740055  --Begin                                                                                                    
#        ON ACTION CONTROLP                                                                                                         
#         CASE                                                                                                                      
#           WHEN INFIELD(bookno)                                                                                                    
#             CALL cl_init_qry_var()                                                                                                
#             LET g_qryparam.form = 'q_aaa'                                                                                         
#             LET g_qryparam.default1 =tm.bookno                                                                                    
#             CALL cl_create_qry() RETURNING tm.bookno                                                                              
#             DISPLAY BY NAME tm.bookno                                                                                             
#             NEXT FIELD bookno                                                                                                     
#         END CASE                                                                                                                  
#         #No.FUN-740055  --End
#
#   ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
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
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
   END INPUT
   ON ACTION CONTROLP                                                                                                         
       CASE                                                                                                                      
         WHEN INFIELD(bookno)                                                                                                    
           CALL cl_init_qry_var()                                                                                                
           LET g_qryparam.form = 'q_aaa'                                                                                         
           LET g_qryparam.default1 =tm.bookno                                                                                    
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
         OTHERWISE                                                        
           EXIT CASE                                                                                                    
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
      CLOSE WINDOW gglr305_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglr305'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr305','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
          #              " '",g_bookno CLIPPED,"'" ,   #No.FUN-740055
                         " '",tm.bookno CLIPPED,"'" ,  #No.FUN-740055
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                        #-----TQC-610056---------
                        " '",tm.yy    CLIPPED,"'",
                        " '",tm.m1    CLIPPED,"'",
                        " '",tm.m2    CLIPPED,"'",
                        " '",tm.a    CLIPPED,"'",
                        " '",tm.y    CLIPPED,"'",
                        " '",tm.n    CLIPPED,"'",
                        " '",tm.b    CLIPPED,"'",
                        #-----END TQC-610056-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gglr305',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglr305_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglr305()
   ERROR ""
END WHILE
   CLOSE WINDOW gglr305_w
END FUNCTION
 
FUNCTION gglr305()
   DEFINE l_name	LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
         #l_sql 	LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(2000) # RDSQL STATEMENT                     #No.MOD-860252 mark 
          l_sql   STRING,                 #No.MOD-860252
          l_chr		LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_aah45       LIKE aah_file.aah04,
          l_aah451      LIKE aah_file.aah04,
          l_aag06       LIKE aag_file.aag06,
          l_aah         LIKE aah_file.aah04,
          l_tah08       LIKE tah_file.tah08,
          l_tah47       LIKE tah_file.tah09,#SUM(tah09-tah10)
          l_tah09       LIKE tah_file.tah09,
          l_tah04       LIKE tah_file.tah04,
          l_tah10       LIKE tah_file.tah10,
          l_tah05       LIKE tah_file.tah05,
          l_tah58       LIKE tah_file.tah04,#SUM(tah04-tah05)
          l_tah7y       LIKE tah_file.tah09,
          l_tah8b       LIKE tah_file.tah04,
          l_tah         LIKE tah_file.tah04,
           l_cnt        LIKE type_file.num5,    #NO FUN-690009   SMALLINT    #No.MOD-560249
          sr               RECORD
                           aah01     LIKE aah_file.aah01,#科目
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           aag07     LIKE aag_file.aag07,
                           aag24     LIKE aag_file.aag24,
                           aah1j     LIKE aah_file.aah04,#注一借-1j
                           aah1d     LIKE aah_file.aah04,#注一貸-1d
                           aah04     LIKE aah_file.aah04,
                           aah05     LIKE aah_file.aah05,
                           aah3j     LIKE aah_file.aah04,#注三借-3j
                           aah3d     LIKE aah_file.aah04 #注三貸-3d
                        END RECORD,
          sr1               RECORD
                           tah01     LIKE tah_file.tah01,
                           aag02     LIKE aag_file.aag02,
                           aag13     LIKE aag_file.aag13,#FUN-6C0012
                           aag07     LIKE aag_file.aag07,
                           aag24     LIKE aag_file.aag24,
                           tah08     LIKE tah_file.tah08,#幣別
                           taha      LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(4)
                           tah4y     LIKE tah_file.tah09,#注四原幣
                           tah5b     LIKE tah_file.tah04,#注五本幣
                           tah09     LIKE tah_file.tah09,
                           tah04     LIKE tah_file.tah04,
                           tah10     LIKE tah_file.tah10,
                           tah05     LIKE tah_file.tah05,
                           tahb      LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(4)
                           tah7y     LIKE tah_file.tah09,#注七原幣
                           tah8b     LIKE tah_file.tah04 #注八本幣
                        END RECORD
 
     #No.FUN-780031  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780031  --End  
 
       LET g_tah4ysum=0      #用於做纍加，放入小計中
       LET g_tah5bsum=0
       LET g_tah7ysum=0
       LET g_tah8bsum=0
       LET l_tah=0           #用於在數據庫中無此筆資料時打0.00
       LET l_aah=0           #在數據庫無相應資料時打印0
   
     #No.FUN-B80096--mark--Begin---   
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno     #No.FUN-740055
  			AND aaf02 = g_rlang
 
 
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
 
     #-MOD-B30662-add-
      IF tm.n = 'Y' AND cl_null(tm.b) THEN
         CALL cl_err3("sel","azi_file",tm.b,"","anm-040","","",1)   
         RETURN 
      END IF        
     #-MOD-B30662-end-
 
     IF tm.n = 'N' THEN                   #不列印外幣
       IF tm.a = '1' THEN                 #print 1
        LET l_sql = "SELECT aah01,aag02,aag13,aag07,aag24,'','',",  #FUN-6C0012
                    "       SUM(aah04),SUM(aah05),'','' ",
                    "  FROM aag_file, aah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 =aah00 ",   #NO.FUN-740055
                    "   AND aag01 = aah01",
                    "   AND aag07 IN ('1','3')",
               #    "   AND aah00 = '",g_bookno,"'",  #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah00 = '",tm.bookno,"'", #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah02 = ",tm.yy,
                    "   AND aah03 BETWEEN ",tm.m1," AND ",tm.m2 
                    #FUN-6C0012.....begin
#                    " GROUP BY 1,2,3,4"   
                  # " GROUP BY aah01,aag02,aag13,aag07,aag24"   #NO.MOD-860252 mark
                    #FUN-6C0012.....end 
       ELSE                               #print 2 and 3
        LET l_sql = "SELECT aah01,aag02,aag13,aag07,aag24,'','',", #FUN-6C0012
                    "       SUM(aah04),SUM(aah05),'','' ",
                    "  FROM aag_file, aah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 =aah00 ",   #NO.FUN-740055
                    "   AND aag01 = aah01",
                    "   AND aag07 IN ('2','3')",
       #            "   AND aah00 = '",g_bookno,"'",  #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah00 = '",tm.bookno,"'", #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah02 = ",tm.yy,
                    "   AND aah03 BETWEEN ",tm.m1," AND ",tm.m2 
                    #FUN-6C0012.....begin
#                    " GROUP BY 1,2,3,4"   
               #    " GROUP BY aah01,aag02,aag13,aag07,aag24"   #NO.MOD-860252 mark
                    #FUN-6C0012.....end
       END IF
       #No.MOD-860252--begin--
       IF tm.h = 'Y' THEN 
          LET l_sql = l_sql , " AND aag09 = 'Y' "
       END IF 
       LET l_sql = l_sql , " GROUP BY aah01,aag02,aag13,aag07,aag24 " 
       #No.MOD-860252---end---
     ELSE                                 #列印外幣
       IF tm.a = '1' THEN                 #print 1
        LET l_sql = "SELECT tah01,aag02,aag13,aag07,aag24,tah08,'','','',",#FUN-6C0012
                    "       SUM(tah09),SUM(tah04),SUM(tah10),SUM(tah05),",
                    "       '','','' ",
                    "  FROM aag_file,tah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 =tah00 ",   #NO.FUN-740055
                    "   AND aag01 = tah01",
                    "   AND aag07 IN ('1','3')",
             #      "   AND tah00 = '",g_bookno,"'",     #No.FUN-740055
                    "   AND tah00 = '",tm.bookno,"'",    #No.FUN-740055
                    "   AND tah02 = ",tm.yy,
                    "   AND tah03 BETWEEN ",tm.m1," AND ",tm.m2,
                    "   AND tah08 = '",tm.b CLIPPED,"'" 
                    #FUN-6C0012.....begin
#                    " GROUP BY aah01,aag02,aag13,aag07,aag24"
                 #  " GROUP BY tah01,aag02,aag13,aag07,aag24,tah08"  #No.MOD-860252 mark
                    #FUN-6C0012.....end
       ELSE                               #print 2 and 3
        LET l_sql = "SELECT tah01,aag02,aag13,aag07,aag24,tah08,'','','',", #FUN-6C0012
                    "       SUM(tah09),SUM(tah04),SUM(tah10),SUM(tah05),",
                    "       '','','' ",
                    "  FROM aag_file,tah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 =tah00 ",   #NO.FUN-740055
                    "   AND aag01 = tah01",
                    "   AND aag07 IN ('2','3')",
           #        "   AND tah00 = '",g_bookno,"'",     #No.FUN-740055
                    "   AND tah00 = '",tm.bookno,"'",    #No.FUN-740055
                    "   AND tah02 = ",tm.yy,
                    "   AND tah03 BETWEEN ",tm.m1," AND ",tm.m2,
                    "   AND tah08 = '",tm.b CLIPPED,"'" 
                    #FUN-6C0012.....begin
#                    " GROUP BY aah01,aag02,aag13,aag07,aag24"
                #   " GROUP BY tah01,aag02,aag13,aag07,aag24,tah08"    #No.MOD-860252 mark
                    #FUN-6C0012.....end
       END IF
       #No.MOD-860252--begin--
       IF tm.h = 'Y' THEN 
          LET l_sql = l_sql , " AND aag09 = 'Y' " 
       END IF
       LET l_sql = l_sql , " GROUP BY tah01,aag02,aag13,aag07,aag24,tah08 "
       #No.MOD-860252---end---
     END IF
 
     PREPARE gglr305_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr305_curs1 CURSOR FOR gglr305_prepare1
 
    #No.FUN-780031  --Begin
    #CALL cl_outnam('gglr305') RETURNING l_name  
    #IF tm.n = 'N' THEN                                                                                                             
     # LET g_zaa[31].zaa06 = "N"                                                                                                     
     # LET g_zaa[32].zaa06 = "N"                                                                                                     
     # LET g_zaa[33].zaa06 = "N"                                                                                                     
     # LET g_zaa[34].zaa06 = "N"                                                                                                     
     # LET g_zaa[35].zaa06 = "N"                                                                                                     
     # LET g_zaa[36].zaa06 = "N"                                                                                                     
     # LET g_zaa[37].zaa06 = "N"                                                                                                     
     # LET g_zaa[38].zaa06 = "N"                                                                                                     
     # LET g_zaa[39].zaa06 = "Y"                                                                                                     
     # LET g_zaa[40].zaa06 = "Y"                                                                                                     
     # LET g_zaa[41].zaa06 = "Y"                                                                                                     
     # LET g_zaa[42].zaa06 = "Y"                                                                                                     
     # LET g_zaa[43].zaa06 = "Y"                                                                                                     
     # LET g_zaa[44].zaa06 = "Y"                                                                                                     
     # LET g_zaa[45].zaa06 = "Y"                                                                                                     
     # LET g_zaa[46].zaa06 = "Y"                                                                                                     
     # LET g_zaa[47].zaa06 = "Y"                                                                                                     
     # LET g_zaa[48].zaa06 = "Y"
     # LET g_zaa[49].zaa06 = "Y"
    #ELSE
     # LET g_zaa[31].zaa06 = "N"                                                                                                     
     # LET g_zaa[32].zaa06 = "N"                                                                                                     
     # LET g_zaa[33].zaa06 = "Y"                                                                                                     
     # LET g_zaa[34].zaa06 = "Y"                                                                                                     
     # LET g_zaa[35].zaa06 = "Y"                                                                                                     
     # LET g_zaa[36].zaa06 = "Y"                                                                                                     
     # LET g_zaa[37].zaa06 = "Y"                                                                                                     
     # LET g_zaa[38].zaa06 = "Y"                                                                                                     
     # LET g_zaa[39].zaa06 = "N"                                                                                                     
     # LET g_zaa[40].zaa06 = "N"                                                                                                     
     # LET g_zaa[41].zaa06 = "N"                                                                                                     
     # LET g_zaa[42].zaa06 = "N"                                                                                                     
     # LET g_zaa[43].zaa06 = "N"                                                                                                     
     # LET g_zaa[44].zaa06 = "N"                                                                                                     
     # LET g_zaa[45].zaa06 = "N"                                                                                                     
     # LET g_zaa[46].zaa06 = "N"                                                                                                     
     # LET g_zaa[47].zaa06 = "N"                                                                                                     
     # LET g_zaa[48].zaa06 = "N"
     # LET g_zaa[49].zaa06 = "N"
    #END IF
    ##FUN-6C0012.....begin
    #IF tm.e = 'Y' THEN
    #   LET g_zaa[32].zaa06 = 'Y'
    #   LET g_zaa[51].zaa06 = 'N'
    #ELSE
    #   LET g_zaa[32].zaa06 = 'N'
    #   LET g_zaa[51].zaa06 = 'Y'
    #END IF
    ##FUN-6C0012.....end 
    #CALL cl_prt_pos_len()
    IF tm.n = 'N' THEN 
        LET l_name = 'gglr305'
    ELSE
        LET l_name = 'gglr305_1'
    END IF
    #No.FUN-780031  --End
     IF tm.n = 'N' THEN                  #不列印外幣
        #No.FUN-780031  --Begin
        #START REPORT gglr305_rep TO l_name
        #LET g_pageno = 0
        #LET g_cnt    = 1
        #No.FUN-780031  --End
        FOREACH gglr305_curs1 INTO sr.*
           IF STATUS THEN
              CALL cl_err('foreach:',STATUS,1) 
              EXIT FOREACH
           END IF
           #統制科目要按層次取出
          #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN #CHI-710005
           IF NOT cl_null(tm.y) THEN #CHI-710005 
             #IF sr.aag07 = '1' AND sr.aag24 != tm.y THEN
               IF sr.aag24 != tm.y THEN        #MOD-540171
                 CONTINUE FOREACH
              END IF
           END IF
 
 #No.MOD-560249--begin
           INSERT INTO r305_tmp VALUES(sr.aah01)
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#             CALL cl_err('ins tmp',STATUS,0)    #No.FUN-660124
              CALL cl_err3("ins","r305_tmp","","",STATUS,"","ins tmp",0)   #No.FUN-660124
              CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
              EXIT PROGRAM
           END IF
 #No.MOD-560249--end
 
           SELECT SUM(aah04-aah05) INTO l_aah45 FROM aah_file
            WHERE aah01 = sr.aah01
              AND aah02 = tm.yy
              #AND aah03 < tm.m1 AND aah03 > 0
              AND aah03 < tm.m1              #No.A119
   #          AND aah00 = g_bookno       #No.FUN-740055
              AND aah00 = tm.bookno      #No.FUN-740055
           IF cl_null(l_aah45) THEN
              LET sr.aah1j = l_aah
              LET sr.aah1d = l_aah
           ELSE
              IF l_aah45>0 THEN
                  LET sr.aah1j = l_aah45
                  LET sr.aah1d = l_aah
              END IF
              IF l_aah45=0 THEN
                 SELECT aag06 INTO l_aag06 FROM aag_file
                  WHERE aag01 = sr.aah01
                    AND aag00 = tm.bookno  #NO.FUN-740055    
                 IF l_aag06 = 1 THEN
                    LET sr.aah1j = l_aah45
                    LET sr.aah1d = l_aah
                 END IF
                 IF l_aag06 = 2 THEN
                    LET sr.aah1j = l_aah
                    LET sr.aah1d = l_aah45
                 END IF
              END IF
              IF l_aah45<0 THEN
                 LET sr.aah1j = l_aah
                 LET sr.aah1d = l_aah45*(-1)
              END IF
           END IF
 
           SELECT SUM(aah04-aah05) INTO l_aah451 FROM aah_file
              WHERE aah01 = sr.aah01
                AND aah02 = tm.yy
                AND aah03 <= tm.m2
         #      AND aah00 = g_bookno     #No.FUN-740055
                AND aah00 = tm.bookno    #No.FUN-740055
           IF cl_null(l_aah451) THEN
             LET sr.aah3j = l_aah
             LET sr.aah3d = l_aah
           ELSE
             IF l_aah451>0 THEN
               LET sr.aah3j = l_aah451
               LET sr.aah3d = l_aah
             END IF
             IF l_aah451=0 THEN
               SELECT aag06 INTO l_aag06 FROM aag_file
                  WHERE aag01 = sr.aah01
                    AND aag00 = tm.bookno  #NO.FUN-740055 
               IF l_aag06 = 1 THEN
                 LET sr.aah3j = l_aah451
                 LET sr.aah3d = l_aah
               END IF
               IF l_aag06 = 2 THEN
                 LET sr.aah3j = l_aah
                 LET sr.aah3d = l_aah451
               END IF
             END IF
             IF l_aah451<0 THEN
               LET sr.aah3j = l_aah
               LET sr.aah3d = l_aah451*(-1)
             END IF
           END IF
 
           #No.FUN-780031  --Begin
           #OUTPUT TO REPORT gglr305_rep(sr.*)
           EXECUTE insert_prep USING sr.aah01,sr.aag02,sr.aag13,sr.aag07,
                   sr.aag24,'','',sr.aah1j,sr.aah1d,sr.aah04,sr.aah05,
                   sr.aah3j,sr.aah3d,'','0','0',g_azi04,g_azi05
           #No.FUN-780031  --End
        END FOREACH
  #       FINISH REPORT gglr305_rep   #No.MOD-560249
     ELSE
        #No.FUN-780031  --Begin
        #START REPORT gglr305_rep1 TO l_name
        #LET g_pageno = 0
        #LET g_cnt    = 1
        #No.FUN-780031  --End
        FOREACH gglr305_curs1 INTO sr1.*
           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           #統制科目要按層次取出
          #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN #CHI-710005
           IF NOT cl_null(tm.y) THEN #CHI-710005 
             #IF sr1.aag07 = '1' AND sr1.aag24 != tm.y THEN
               IF sr1.aag24 != tm.y THEN        #MOD-540171
                 CONTINUE FOREACH
              END IF
           END IF
 
 #No.MOD-560249--begin
           INSERT INTO r305_tmp VALUES(sr1.tah01)
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#             CALL cl_err('ins tmp',STATUS,0)    #No.FUN-660124
              CALL cl_err3("ins","r305_tmp","","",STATUS,"","ins tmp",0)   #No.FUN-660124
              CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
              EXIT PROGRAM
           END IF
 #No.MOD-560249--end
 
           SELECT SUM(tah09-tah10),SUM(tah04-tah05)
               INTO l_tah47,l_tah58
               FROM tah_file
               WHERE tah01 = sr1.tah01
                 AND tah02 = tm.yy
                 #AND tah03 < tm.m1 AND tah03 > 0
                 AND tah03 < tm.m1            #No.A119
         #       AND tah00 = g_bookno    #No.FUN-740055
                 AND tah00 = tm.bookno   #No.FUN-740055
                 AND tah08 = sr1.tah08
           IF cl_null(l_tah58) THEN
              #No.FUN-780031 --Begin
              #LET sr1.taha = g_x[28] CLIPPED
              CALL cl_getmsg('ggl-103',g_lang) RETURNING sr1.taha
              #No.FUN-780031 --End  
              LET sr1.tah4y = l_tah
              LET sr1.tah5b = l_tah
           ELSE
             IF l_tah58 > 0 THEN
                #No.FUN-780031 --Begin
                #LET sr1.taha  = g_x[26] CLIPPED
                CALL cl_getmsg('ggl-101',g_lang) RETURNING sr1.taha
                #No.FUN-780031 --End  
                LET sr1.tah4y = l_tah47
                LET sr1.tah5b = l_tah58
                LET g_tah4ysum=g_tah4ysum+l_tah47
                LET g_tah5bsum=g_tah5bsum+l_tah58
             ELSE
                IF l_tah58 < 0 THEN
                   #No.FUN-780031 --Begin
                   #LET sr1.taha  = g_x[27] CLIPPED
                   CALL cl_getmsg('ggl-102',g_lang) RETURNING sr1.taha
                   #No.FUN-780031 --End  
                   LET sr1.tah4y = l_tah47*(-1)
                   LET sr1.tah5b = l_tah58*(-1)
                   LET g_tah4ysum=g_tah4ysum+l_tah47
                   LET g_tah5bsum=g_tah5bsum+l_tah58
                ELSE
                   #No.FUN-780031 --Begin
                   #LET sr1.taha  = g_x[28] CLIPPED
                   CALL cl_getmsg('ggl-103',g_lang) RETURNING sr1.taha
                   #No.FUN-780031 --End  
                   LET sr1.tah4y = l_tah47
                   LET sr1.tah5b = l_tah58
                END IF
             END IF
          END IF
 
 
          SELECT SUM(tah09),SUM(tah04),SUM(tah10),SUM(tah05)
            INTO l_tah09,l_tah04,l_tah10,l_tah05
            FROM tah_file
            WHERE tah01 = sr1.tah01
              AND tah02 = tm.yy
              AND tah03 BETWEEN tm.m1 AND tm.m2
   #          AND tah00 = g_bookno     #No.FUN-740055
              AND tah00 = tm.bookno    #No.FUN-740055 
              AND tah08 = sr1.tah08
 
          IF cl_null(l_tah09) THEN
             LET sr1.tah09 = l_tah
          ELSE
             LET sr1.tah09 = l_tah09
          END IF
 
          IF cl_null(l_tah04) THEN
             LET sr1.tah04 = l_tah
          ELSE
             LET sr1.tah04 = l_tah04
          END IF
 
          IF cl_null(l_tah10) THEN
             LET sr1.tah10 = l_tah
          ELSE
             LET sr1.tah10 = l_tah10
          END IF
 
          IF cl_null(l_tah05) THEN
             LET sr1.tah05 = l_tah
          ELSE
             LET sr1.tah05 = l_tah05
          END IF
 
 
          SELECT SUM(tah09-tah10),SUM(tah04-tah05)
            INTO l_tah7y,l_tah8b
            FROM tah_file
           WHERE tah01 = sr1.tah01
             AND tah02 = tm.yy
             AND tah03 <= tm.m2
       #     AND tah00 = g_bookno      #No.FUN-740055
             AND tah00 = tm.bookno     #No.FUN-740055
             AND tah08 = sr1.tah08
          IF cl_null(l_tah8b) THEN
             #No.FUN-780031 --Begin
             #LET sr1.tahb = g_x[28] CLIPPED
             CALL cl_getmsg('ggl-103',g_lang) RETURNING sr1.tahb
             #No.FUN-780031 --End  
             LET sr1.tah7y = l_tah
             LET sr1.tah8b = l_tah
          ELSE
             IF l_tah8b > 0 THEN
                #No.FUN-780031 --Begin
                #LET sr1.tahb = g_x[26] CLIPPED
                CALL cl_getmsg('ggl-101',g_lang) RETURNING sr1.tahb
                #No.FUN-780031 --End  
                LET sr1.tah7y = l_tah7y
                LET sr1.tah8b = l_tah8b
                LET g_tah7ysum=g_tah7ysum+l_tah7y
                LET g_tah8bsum=g_tah8bsum+l_tah8b
             ELSE
                IF l_tah8b < 0 THEN
                   #No.FUN-780031 --Begin
                   #LET sr1.tahb = g_x[27] CLIPPED
                   CALL cl_getmsg('ggl-102',g_lang) RETURNING sr1.tahb
                   #No.FUN-780031 --End  
                   LET sr1.tah7y = l_tah7y*(-1)
                   LET sr1.tah8b = l_tah8b*(-1)
                   LET g_tah7ysum=g_tah7ysum+l_tah7y
                   LET g_tah8bsum=g_tah8bsum+l_tah8b
                ELSE
                   #No.FUN-780031 --Begin
                   #LET sr1.tahb = g_x[28] CLIPPED
                   CALL cl_getmsg('ggl-103',g_lang) RETURNING sr1.tahb
                   #No.FUN-780031 --End  
                   LET sr1.tah7y = l_tah7y
                   LET sr1.tah8b = l_tah8b
                END IF
             END IF
          END IF
 
          #No.FUN-780031  --Begin
          #OUTPUT TO REPORT gglr305_rep1(sr1.*)
          SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
           WHERE azi01 = sr1.tah08
          EXECUTE insert_prep USING sr1.*,t_azi04,t_azi05
          #No.FUN-780031  --End
       END FOREACH
 #       FINISH REPORT gglr305_rep1   #No.MOD-560249
     END IF
 
 #No.MOD-560249--begin
     IF tm.n = 'N' THEN                   #不列印外幣
       IF tm.a = '1' THEN                 #print 1
        LET l_sql = "SELECT UNIQUE aah01,aag02,aag13,aag07,aag24,'','',", #FUN-6C0012
                    "       0,0,'','' ",
                    "  FROM aag_file, aah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 = aah00",           #NO.FUN-740055   
                    "   AND aag01 = aah01",
                    "   AND aag07 IN ('1','3')",
         #          "   AND aah00 = '",g_bookno,"'",  #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah00 = '",tm.bookno,"'", #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah02 = ",tm.yy,
                    "   AND aah03 < ",tm.m1 
                    #FUN-6C0012.....begin
#                    " GROUP BY 1,2,3,4"
                 #  " GROUP BY aah01,aag02,aag13,aag07,aag24"      #NO.MOD-860252 mark
                    #FUN-6C0012.....end
       ELSE                               #print 2 and 3
        LET l_sql = "SELECT UNIQUE aah01,aag02,aag13,aag07,aag24,'','',",  #FUN-6C0012
                    "       0,0,'',''",
                    "  FROM aag_file, aah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 = aah00",           #NO.FUN-740055   
                    "   AND aag01 = aah01",
                    "   AND aag07 IN ('2','3')",
         #          "   AND aah00 = '",g_bookno,"'", #若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah00 = '",tm.bookno,"'",#若為空白使用預設帳別    #No.FUN-740055
                    "   AND aah02 = ",tm.yy,
                    "   AND aah03 < ",tm.m1 
 #                    " GROUP BY 1,2,3,4,11,12"   #MOD-580314
                    #FUN-6C0012.....begin
#                     " GROUP BY 1,2,3,4"   #MOD-580314 
                #   " GROUP BY aah01,aag02,aag13,aag07,aag24"   #NO.MOD-860252 mark
                    #FUN-6C0012.....end
       END IF
       #No.MOD-860252--begin--
       IF tm.h = 'Y' THEN 
          LET l_sql = l_sql , " AND aag09 = 'Y'  "   
       END IF 
       LET l_sql = l_sql , " GROUP BY aah01,aag02,aag13,aag07,aag24 "
       #No.MOD-860252---end---
     ELSE                                 #列印外幣
       IF tm.a = '1' THEN                 #print 1
        LET l_sql = "SELECT UNIQUE tah01,aag02,aag13,aag07,aag24,tah08,'','','',", #FUN-6C0012
                    "       0,0,0,0,",
                    "       '','','' ",
                    "  FROM aag_file,tah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 = tah00",           #NO.FUN-740055   
                    "   AND aag01 = tah01",
                    "   AND aag07 IN ('1','3')",
          #         "   AND tah00 = '",g_bookno,"'",    #No.FUN-740055
                    "   AND tah00 = '",tm.bookno,"'",   #No.FUN-740055
                    "   AND tah02 = ",tm.yy,
                    "   AND tah03 < ",tm.m1,
                    "   AND tah08 = '",tm.b CLIPPED,"'" 
                    #FUN-6C0012.....begin
#                    " GROUP BY aah01,aag02,aag13,aag07,aag24"
                  # " GROUP BY tah01,aag02,aag13,aag07,aag24,tah08"   #No.MOD-860252
                    #FUN-6C0012.....end
       ELSE                               #print 2 and 3
        LET l_sql = "SELECT UNIQUE tah01,aag02,aag13,aag07,aag24,tah08,'','','',", #FUN-6C0012
                    "       0,0,0,0,",
                    "       '','','' ",
                    "  FROM aag_file,tah_file",
                    " WHERE aag03 = '2' AND ",tm.wc CLIPPED,
                    "   AND aag00 = tah00",           #NO.FUN-740055   
                    "   AND aag01 = tah01",
                    "   AND aag07 IN ('2','3')",
          #         "   AND tah00 = '",g_bookno,"'",     #No.FUN-740055
                    "   AND tah00 = '",tm.bookno,"'",    #No.FUN-740055
                    "   AND tah02 = ",tm.yy,
                    "   AND tah03 < ",tm.m1,
                    "   AND tah08 = '",tm.b CLIPPED,"'" 
                    #FUN-6C0012.....begin
#                    " GROUP BY aah01,aag02,aag13,aag07,aag24" 
                 # " GROUP BY tah01,aag02,aag13,aag07,aag24,tah08"  #No.MOD-860252 mark
                    #FUN-6C0012.....end
       END IF
       #No.MOD-860252--begin--
       IF tm.h = 'Y' THEN 
          LET l_sql = l_sql , " AND aag09 = 'Y'  "   
       END IF 
       LET l_sql = l_sql , " GROUP BY tah01,aag02,aag13,aag07,aag24,tah08 "
       #No.MOD-860252---end---
     END IF
 
     PREPARE gglr305_prepare2 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr305_curs2 CURSOR FOR gglr305_prepare2
 
 
 
     IF tm.n = 'N' THEN                  #不列印外幣
        LET g_pageno = 0
        LET g_cnt    = 1
        FOREACH gglr305_curs2 INTO sr.*
           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           #統制科目要按層次取出
          #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN #CHI-710005
           IF NOT cl_null(tm.y) THEN #CHI-710005 
              IF sr.aag24 != tm.y THEN
                 CONTINUE FOREACH
              END IF
           END IF
        SELECT COUNT(*) INTO l_cnt FROM r305_tmp
               WHERE aah01 = sr.aah01
        IF l_cnt >0 THEN
           CONTINUE FOREACH
        END IF
           SELECT SUM(aah04-aah05) INTO l_aah45 FROM aah_file
            WHERE aah01 = sr.aah01
              AND aah02 = tm.yy
              AND aah03 < tm.m1              #No.A119
        #     AND aah00 = g_bookno         #No.FUN-740055
              AND aah00 = tm.bookno        #No.FUN-740055
            IF NOT cl_null(l_aah45) OR (l_aah45!= 0) THEN
              IF l_aah45>0 THEN
                  LET sr.aah1j = l_aah45
                  LET sr.aah1d = l_aah
              END IF
              IF l_aah45<0 THEN
                 LET sr.aah1j = l_aah
                 LET sr.aah1d = l_aah45*(-1)
              END IF
 
              LET sr.aah3j = sr.aah1j
              LET sr.aah3d = sr.aah1d
 
              #No.FUN-780031  --Begin
              #OUTPUT TO REPORT gglr305_rep(sr.*)
              EXECUTE insert_prep USING sr.aah01,sr.aag02,sr.aag13,sr.aag07,
                      sr.aag24,'','',sr.aah1j,sr.aah1d,sr.aah04,sr.aah05,
                      sr.aah3j,sr.aah3d,'','0','0',g_azi04,g_azi05
              #No.FUN-780031  --End
            END IF
        END FOREACH
        #FINISH REPORT gglr305_rep  #No.FUN-780031
     ELSE
        LET g_pageno = 0
        LET g_cnt    = 1
        FOREACH gglr305_curs2 INTO sr1.*
           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           #統制科目要按層次取出
          #IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN #CHI-710005
           IF NOT cl_null(tm.y) THEN #CHI-710005 
             #IF sr1.aag07 = '1' AND sr1.aag24 != tm.y THEN
               IF sr1.aag24 != tm.y THEN        #MOD-540171
                 CONTINUE FOREACH
              END IF
           END IF
        SELECT COUNT(*) INTO l_cnt FROM r305_tmp
              #WHERE tah01 = sr1.tah01  #No.FUN-780031
               WHERE aah01 = sr1.tah01  #No.FUN-780031
        IF l_cnt >0 THEN
           CONTINUE FOREACH
        END IF
 
           SELECT SUM(tah09-tah10),SUM(tah04-tah05)
               INTO l_tah47,l_tah58
               FROM tah_file
               WHERE tah01 = sr1.tah01
                 AND tah02 = tm.yy
                 AND tah03 < tm.m1            #No.A119
             #   AND tah00 = g_bookno     #No.FUN-740055
                 AND tah00 = tm.bookno    #No.FUN-740055
                 AND tah08 = sr1.tah08
           IF NOT cl_null(l_tah58) OR (l_tah58 !=0) THEN
             IF l_tah58 > 0 THEN
                #No.FUN-780031 --Begin
                #LET sr1.taha  = g_x[26] CLIPPED
                CALL cl_getmsg('ggl-101',g_lang) RETURNING sr1.taha
                #No.FUN-780031 --End  
                LET sr1.tah4y = l_tah47
                LET sr1.tah5b = l_tah58
                LET g_tah4ysum=g_tah4ysum+l_tah47
                LET g_tah5bsum=g_tah5bsum+l_tah58
             END IF
             IF l_tah58 < 0 THEN
                #No.FUN-780031 --Begin
                #LET sr1.taha  = g_x[27] CLIPPED
                CALL cl_getmsg('ggl-102',g_lang) RETURNING sr1.taha
                #No.FUN-780031 --End  
                LET sr1.tah4y = l_tah47*(-1)
                LET sr1.tah5b = l_tah58*(-1)
                LET g_tah4ysum=g_tah4ysum+l_tah47
                LET g_tah5bsum=g_tah5bsum+l_tah58
             END IF
             LET sr1.tah7y = sr1.tah4y
             LET sr1.tah8b = sr1.tah5b
             #No.FUN-780031  --Begin
             LET g_tah7ysum=g_tah7ysum+l_tah47   #No.MOD-920174 mod by liuxqa
             LET g_tah8bsum=g_tah8bsum+l_tah58   #No.MOD-920174 mod by liuxqa 
             #OUTPUT TO REPORT gglr305_rep1(sr1.*)
             LET sr1.tahb = sr1.taha
#No.TQC-780073 --begin
#            LET g_tah7ysum=g_tah4ysum  #期間沒有異動,期末=期初
#            LET g_tah8bsum=g_tah5bsum
#No.TQC-780073 --end
             SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
              WHERE azi01 = sr1.tah08
             EXECUTE insert_prep USING sr1.*,t_azi04,t_azi05
             #No.FUN-780031  --End
          END IF
 
       END FOREACH
#No.TQC-780073 --begin
#       LET g_tah7ysum=g_tah7ysum + g_tah4ysum  #期間沒有異動,期末=期初  #No.MOD-920174 mark by liuxqa
#       LET g_tah8bsum=g_tah8bsum + g_tah5bsum  #No.MOD-920174 mark by liuxqa
#No.TQC-780073 --end
       #FINISH REPORT gglr305_rep1  #No.FUN-780031
     END IF
 #No.MOD-560249--end
 
     #No.FUN-780031  --Begin
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING g_str
     END IF
     IF cl_null(g_tah4ysum) THEN LET g_tah4ysum = 0 END IF
     IF cl_null(g_tah5bsum) THEN LET g_tah5bsum = 0 END IF
     IF cl_null(g_tah7ysum) THEN LET g_tah7ysum = 0 END IF
     IF cl_null(g_tah8bsum) THEN LET g_tah8bsum = 0 END IF
     LET g_str = g_str,";",tm.e,";",tm.yy,";",tm.m1,";",tm.m2,";",g_azi04,";",
                 g_tah4ysum,";",g_tah5bsum,";",g_tah7ysum,";",g_tah8bsum,";",
                 g_azi05
     CALL cl_prt_cs3('gglr305',l_name,g_sql,g_str)
     #No.FUN-780031  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780031  --Begin
#REPORT gglr305_rep1(sr1)
#   DEFINE l_last_sw     LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#          l_rowno       LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#          l_amt1,l_amt2,l_amt3,l_amt4    LIKE aah_file.aah04,
#          l_amt5,l_amt6,l_amt7,l_amt8    LIKE aah_file.aah04,
#          sr1           RECORD
#                        tah01     LIKE tah_file.tah01,
#                        aag02     LIKE aag_file.aag02,
#                        aag13     LIKE aag_file.aag13, #FUN-6C0012
#                        aag07     LIKE aag_file.aag07,
#                        aag24     LIKE aag_file.aag24,
#                        tah08     LIKE tah_file.tah08,
#                        taha      LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(4)
#                        tah4y     LIKE tah_file.tah09,
#                        tah5b     LIKE tah_file.tah04,
#                        tah09     LIKE tah_file.tah09,
#                        tah04     LIKE tah_file.tah04,
#                        tah10     LIKE tah_file.tah10,
#                        tah05     LIKE tah_file.tah05,
#                        tahb      LIKE zaa_file.zaa08,    #NO FUN-690009   VARCHAR(4)
#                        tah7y     LIKE tah_file.tah09,
#                        tah8b     LIKE tah_file.tah04
#                        END RECORD
#
#   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# 
#   ORDER BY sr1.tah01
#   FORMAT
#     PAGE HEADER
#       PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED    #NO.FUN-670107
#       LET g_pageno = g_pageno + 1                                                   #No.FUN-670107                                                
#       LET pageno_total = PAGENO USING '<<<',"/pageno"                               #No.FUN-670107                                                
#       PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2 ,g_x[1]
#       PRINT ' '                                                                                                                     
#       PRINT g_head CLIPPED,pageno_total                     # No.TQC-740305 
#       PRINT 
#             COLUMN g_c[2],g_x[29] CLIPPED,tm.yy USING '&&&&',g_x[30], 
#             tm.m1 USING '&&',g_x[50],' - ',
#             tm.yy USING '&&&&',g_x[30],
#             tm.m2 USING '&&',g_x[50] 
#       PRINT g_dash[1,g_len]
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#             g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[51]   #FUN-6C0012
#       PRINT g_dash1 
#       LET l_last_sw = 'n'
#
#     ON EVERY ROW
#        #NO:7911
#        SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file  #No.CHI-6A0004
#         WHERE azi01 = sr.tah08
#        #NO:7911 end
#        PRINT COLUMN g_c[31],sr1.tah01[1,20] CLIPPED, 
#              COLUMN g_c[32],sr1.aag02 CLIPPED,                              
#              COLUMN g_c[51],sr1.aag13 CLIPPED;           #FUN-6C0012                   
#        PRINT COLUMN g_c[39],sr1.tah08 CLIPPED,
#              COLUMN g_c[40],sr1.taha CLIPPED,
#              COLUMN g_c[41],cl_numfor(sr1.tah4y,41,t_azi04),    #No.CHI-6A0004                                                                       
#              COLUMN g_c[42],cl_numfor(sr1.tah5b,42,t_azi04),    #No.CHI-6A0004                                                                       
#              COLUMN g_c[43],cl_numfor(sr1.tah09,43,t_azi04),    #No.CHI-6A0004                                                                       
#              COLUMN g_c[44],cl_numfor(sr1.tah04,44,t_azi04),    #No.CHI-6A0004                                                                       
#              COLUMN g_c[45],cl_numfor(sr1.tah10,45,t_azi04),    #No.CHI-6A0004                                                                       
#              COLUMN g_c[46],cl_numfor(sr1.tah05,46,t_azi04),    #No.CHI-6A0004
#              COLUMN g_c[49],sr1.tahb CLIPPED,     
#              COLUMN g_c[47],cl_numfor(sr1.tah7y,47,t_azi04),    #No.CHI-6A0004                                                                       
#              COLUMN g_c[48],cl_numfor(sr1.tah8b,48,t_azi04)     #No.CHI-6A0004
#     ON LAST ROW
#        #NO:7911
#        SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
#         WHERE azi01 = sr.tah08
#        #NO:7911 end
#        PRINT g_dash2
#        LET l_amt1    = g_tah4ysum
#        LET l_amt2    = g_tah5bsum
#        LET l_amt3    = SUM(sr1.tah09)
#        LET l_amt4    = SUM(sr1.tah04)
#        LET l_amt5    = SUM(sr1.tah10)
#        LET l_amt6    = SUM(sr1.tah05)
#        LET l_amt7    = g_tah7ysum
#        LET l_amt8    = g_tah8bsum
#        PRINT COLUMN g_c[40],g_x[15] CLIPPED; 
#        IF l_amt2>0 THEN
#           PRINT COLUMN g_x[26];
#           PRINT COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi04),  #No.CHI-6A0004
#                 COLUMN g_c[42],cl_numfor(l_amt2,42,t_azi04);  #No.CHI-6A0004
#        ELSE
#           IF l_amt2<0 THEN
#              PRINT COLUMN g_x[27]; 
#              LET l_amt1=l_amt1*(-1)
#              LET l_amt2=l_amt2*(-1)
#              PRINT COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi04),    #No.CHI-6A0004                                                                       
#                    COLUMN g_c[42],cl_numfor(l_amt2,42,t_azi04);    #No.CHI-6A0004
#           ELSE
#              PRINT COLUMN g_x[28]; 
#              PRINT COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi04),    #No.CHI-6A0004
#                    COLUMN g_c[42],cl_numfor(l_amt2,42,t_azi04);    #No.CHI-6A0004
#           END IF
#        END IF
#        PRINT COLUMN g_c[43],cl_numfor(l_amt3,43,t_azi04),  #No.CHI-6A0004                                                                         
#              COLUMN g_c[44],cl_numfor(l_amt4,44,t_azi04),  #No.CHI-6A0004                                                                        
#              COLUMN g_c[45],cl_numfor(l_amt5,45,t_azi04),  #No.CHI-6A0004                                                                        
#              COLUMN g_c[46],cl_numfor(l_amt6,46,t_azi04);  #No.CHI-6A0004
#        IF l_amt8>0 THEN
#           PRINT COLUMN g_c[49],g_x[26],
#                 COLUMN g_c[47],cl_numfor(l_amt7,47,t_azi04),  #No.CHI-6A0004
#                 COLUMN g_c[48],cl_numfor(l_amt8,48,t_azi04)   #No.CHI-6A0004
#        ELSE
#           IF l_amt8<0 THEN
#              PRINT COLUMN g_c[49],g_x[27];
#              LET l_amt7=l_amt7*(-1)
#              LET l_amt8=l_amt8*(-1)
#              PRINT COLUMN g_c[47],cl_numfor(l_amt7,47,t_azi04),  #No.CHI-6A0004                                                                     
#                    COLUMN g_c[48],cl_numfor(l_amt8,48,t_azi04)   #No.CHI-6A0004
#           ELSE
#              PRINT COLUMN g_c[49],g_x[28],                                                                                                    
#                    COLUMN g_c[47],cl_numfor(l_amt7,47,t_azi04),  #No.CHI-6A0004                                                                     
#                    COLUMN g_c[48],cl_numfor(l_amt8,48,t_azi04)   #No.CHI-6A0004
#           END IF
#        END IF
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#    PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash 
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#
#REPORT gglr305_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#          l_rowno       LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#          l_amt1,l_amt2,l_amt3    LIKE aah_file.aah04,
#          l_amt4,l_amt5,l_amt6    LIKE aah_file.aah04,
#          sr               RECORD
#                           aah01     LIKE aah_file.aah01,#科目
#                           aag02     LIKE aag_file.aag02,#科目名稱
#                           aag13     LIKE aag_file.aag13,#FUN-6C0012
#                           aag07     LIKE aag_file.aag07,
#                           aag24     LIKE aag_file.aag24,
#                           aah1j     LIKE aah_file.aah04,
#                           aah1d     LIKE aah_file.aah04,
#                           aah04     LIKE aah_file.aah04,
#                           aah05     LIKE aah_file.aah05,
#                           aah3j     LIKE aah_file.aah04,
#                           aah3d     LIKE aah_file.aah04
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#  ORDER BY sr.aah01
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED 
#      LET g_pageno = g_pageno + 1                                            
#      LET pageno_total = PAGENO USING '<<<',"/pageno"           
#      PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2 ,g_x[1]
#      PRINT ' '
#      PRINT g_head CLIPPED,pageno_total    # No.TQC-740305
#      PRINT 
#            COLUMN g_c[2],g_x[13] CLIPPED,tm.yy USING '&&&&',' ',
#            g_x[14] CLIPPED,tm.m1 USING '&&','-',tm.m2 USING '&&' 
#      PRINT g_dash 
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[51]   #FUN-6C0012
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.aah01[1,20] CLIPPED,
#            COLUMN g_c[32],sr.aag02 CLIPPED,
#            COLUMN g_c[51],sr.aag13 CLIPPED;   #FUN-6C0012
#
#      PRINT COLUMN g_c[33],cl_numfor(sr.aah1j,33,t_azi04),  #No.CHI-6A0004
#            COLUMN g_c[34],cl_numfor(sr.aah1d,34,t_azi04),  #No.CHI-6A0004
#            COLUMN g_c[35],cl_numfor(sr.aah04,35,t_azi04),  #No.CHI-6A0004
#            COLUMN g_c[36],cl_numfor(sr.aah05,36,t_azi04),  #No.CHI-6A0004
#            COLUMN g_c[37],cl_numfor(sr.aah3j,37,t_azi04),  #No.CHI-6A0004
#            COLUMN g_c[38],cl_numfor(sr.aah3d,38,t_azi04)   #No.CHI-6A0004
# 
#   ON LAST ROW
#      PRINT g_dash2
#      LET l_amt1    = SUM(sr.aah1j)
#      LET l_amt2    = SUM(sr.aah1d)
#      LET l_amt3    = SUM(sr.aah04)
#      LET l_amt4    = SUM(sr.aah05)
#      LET l_amt5    = SUM(sr.aah3j)
#      LET l_amt6    = SUM(sr.aah3d)
#      PRINT COLUMN  36,g_x[15] CLIPPED;
#      PRINT COLUMN g_c[33],cl_numfor(l_amt1,33,t_azi04),    #No.CHI-6A0004 
#            COLUMN g_c[34],cl_numfor(l_amt2,34,t_azi04),    #No.CHI-6A0004
#            COLUMN g_c[35],cl_numfor(l_amt3,35,t_azi04),    #No.CHI-6A0004
#            COLUMN g_c[36],cl_numfor(l_amt4,36,t_azi04),    #No.CHI-6A0004
#            COLUMN g_c[37],cl_numfor(l_amt5,37,t_azi04),    #No.CHI-6A0004
#            COLUMN g_c[38],cl_numfor(l_amt6,38,t_azi04)     #No.CHI-6A0004
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#     IF l_last_sw = 'n'  THEN
#              PRINT g_dash  
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#     END IF
#END REPORT
##Patch....NO.TQC-610037 <001,002,003,004> #
#No.FUN-780031  --End  
