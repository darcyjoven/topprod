# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Descriptions...: 記帳憑証列印
# Date & Author..: 02/08/26 By leagh
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-510007 05/03/04 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-540170 05/04/25 By day    簽名欄增加“復核:”一項
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.MOD-590097 05/09/08 By vivien  報表調整為標准格式
# Modify.........: No.TQC-5B0044 05/11/07 By Smapmin 報表位置調整
# Modify.........: No.TQC-650055 06/05/12 By kim voucher無寬度的程式修改
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0186 06/11/30 By Judy 報表欄位調整
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印“額外名稱”
# Modify.........: No.FUN-740055 07/04/13 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-750041 07/05/09 By Lynn 報表寬度與實際印出的寬度不符
# Modify.........: No.TQC-750041 07/05/17 By ve 打印條件已選定帳套,但打印結果并沒有按管帳套
# Modify.........: No.TQC-770087 07/07/18 By chenl 報表格式修改。
# Modify.........: No.FUN-7C0066 07/12/27 By jan 報表格式修改為crystal report
# Modify.........: No.MOD-820170 08/02/27 By Smapmin 加入aaz82的判斷
# Modify.........: No.MOD-840503 08/04/22 By Carol調整SQL語法
# Modify.........: No.TQC-880017 08/08/13 By chenyu 去掉l_i<>sr1.l_tot_p這個條件，如果不去，當單身是25的倍數的時候，會少打印5筆資料
# Modify.........: No.MOD-8C0030 08/12/08 By liuxqa 報表列印時，第一次列印的頁碼是正確的，第二次列印時是錯誤的。
# Modify.........: No.MOD-910149 09/01/13 By wujie  按借貸別排列時，下一級排列按項次
# Modify.........: No.MOD-860252 09/02/03 By chenl  增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.FUN-940041 09/05/05 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/10 By vealxu 精簡程式碼
# Modify.........: No:FUN-A30016 10/03/03 By Carrier 科目名称后印出该笔分录的部门和核算项值,核算项值为多个时,按顺序只列第一个有值的核算项
# Modify.........: No:TQC-A50151 10/05/26 By Carrier MOD-9C0095追单
# Modify.........: No:TQC-B60146 11/06/21 By zhangweib 若沒有勾選打印外幣則加上 AND aac13 = 'N'
# Modify.........: No:MOD-B80009 11/08/01 By Carrier tm.wc置换
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-BC0205 11/12/31 By Carrier 附号aba21 取整打印
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.FUN-D10098 13/01/31 By wangrr CR轉GR
# Modify.........: No:FUN-CA0098 13/05/09 By lujh 增加原幣金額列印,並調整報表列印格式
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	       	     #Print condition RECORD
           wc  LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(400)     #Where Condiction
           b_user   LIKE aba_file.abauser,   #FUN-CA0098   Add
           e_user   LIKE aba_file.abauser,   #FUN-CA0098   Add
           t   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #排列順序
           u   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #排列順序
           w   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #是否列印摘要
           n   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #是否列印外幣金額
           h   LIKE type_file.chr1,    #MOD-860252
           e   LIKE type_file.chr1,    #FUN-6C0012
           m   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)       #是否輸入其它特殊列印條件
       bookno  LIKE aba_file.aba00     #帳別編號        #NO.FUN-740055
           END RECORD 
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5  #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE g_sql    STRING             #No.FUN-7C0066
DEFINE l_table  STRING             #No.FUN-7C0066
DEFINE g_str    STRING             #No.FUN-7C0066
###GENGRE###START
TYPE sr1_t RECORD
    aba01 LIKE aba_file.aba01,
    aba02 LIKE aba_file.aba02,
    aba21 LIKE aba_file.aba21,
    zx02 LIKE zx_file.zx02,
    abb02 LIKE abb_file.abb02,
    abb04_1 LIKE abb_file.abb04,
    l_aag_all_1 LIKE type_file.chr1000,
    abb07f_1 LIKE abb_file.abb07f,
    abb25_1 LIKE abb_file.abb25,
    l_abb07_l_1 LIKE abb_file.abb07,
    l_abb07_r_1 LIKE abb_file.abb07,
    azi04_1 LIKE azi_file.azi04,
    azi05_1 LIKE azi_file.azi05,
    azi07_1 LIKE azi_file.azi07,
    abb04_2 LIKE abb_file.abb04,
    l_aag_all_2 LIKE type_file.chr1000,
    abb07f_2 LIKE abb_file.abb07f,
    abb25_2 LIKE abb_file.abb25,
    l_abb07_l_2 LIKE abb_file.abb07,
    l_abb07_r_2 LIKE abb_file.abb07,
    azi04_2 LIKE azi_file.azi04,
    azi05_2 LIKE azi_file.azi05,
    azi07_2 LIKE azi_file.azi07,
    abb04_3 LIKE abb_file.abb04,
    l_aag_all_3 LIKE type_file.chr1000,
    abb07f_3 LIKE abb_file.abb07f,
    abb25_3 LIKE abb_file.abb25,
    l_abb07_l_3 LIKE abb_file.abb07,
    l_abb07_r_3 LIKE abb_file.abb07,
    azi04_3 LIKE azi_file.azi04,
    azi05_3 LIKE azi_file.azi05,
    azi07_3 LIKE azi_file.azi07,
    abb04_4 LIKE abb_file.abb04,
    l_aag_all_4 LIKE type_file.chr1000,
    abb07f_4 LIKE abb_file.abb07f,
    abb25_4 LIKE abb_file.abb25,
    l_abb07_l_4 LIKE abb_file.abb07,
    l_abb07_r_4 LIKE abb_file.abb07,
    azi04_4 LIKE azi_file.azi04,
    azi05_4 LIKE azi_file.azi05,
    azi07_4 LIKE azi_file.azi07,
    abb04_5 LIKE abb_file.abb04,
    l_aag_all_5 LIKE type_file.chr1000,
    abb07f_5 LIKE abb_file.abb07f,
    abb25_5 LIKE abb_file.abb25,
    l_abb07_l_5 LIKE abb_file.abb07,
    l_abb07_r_5 LIKE abb_file.abb07,
    azi04_5 LIKE azi_file.azi04,
    azi05_5 LIKE azi_file.azi05,
    azi07_5 LIKE azi_file.azi07,
    #FUN-CA0098--add--str--
    abb04_6     LIKE abb_file.abb04,
    l_aag_all_6 LIKE type_file.chr1000,
    abb07f_6    LIKE abb_file.abb07f,
    abb25_6     LIKE abb_file.abb25,
    l_abb07_l_6 LIKE abb_file.abb07,
    l_abb07_r_6 LIKE abb_file.abb07,
    azi04_6     LIKE azi_file.azi04,
    azi05_6     LIKE azi_file.azi05,
    azi07_6     LIKE azi_file.azi07,
    #FUN-CA0098--add--end--
    l_abb07_l_c LIKE type_file.chr200,
    l_abb07_l_s LIKE abb_file.abb07,
    l_abb07_r_s LIKE abb_file.abb07,
    l_cur_p LIKE type_file.num5,
    l_tot_p LIKE type_file.num5,
    l_n LIKE type_file.num5,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000,   #FUN-CA0098 add
    #FUN-CA0098--add--str--
    aba03 LIKE aba_file.aba03,       
    aba04 LIKE aba_file.aba04,   
    zo02 LIKE zo_file.zo02,    
    abb24_1 LIKE abb_file.abb24,
    abb24_2 LIKE abb_file.abb24,
    abb24_3 LIKE abb_file.abb24,
    abb24_4 LIKE abb_file.abb24,
    abb24_5 LIKE abb_file.abb24,
    abb24_6 LIKE abb_file.abb24,
    aac02 LIKE aac_file.aac02
    #FUN-CA0098--add--end--
END RECORD
###GENGRE###END

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

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-B80009
 
   LET g_sql="aba01.aba_file.aba01,",                                                                                               
             "aba02.aba_file.aba02,",
             "aba21.aba_file.aba21,",
             "zx02.zx_file.zx02,",
             "abb02.abb_file.abb02,",                                                                                               
             "abb04_1.abb_file.abb04,",                                                                                               
             "l_aag_all_1.type_file.chr1000,",                                                                                               
             "abb07f_1.abb_file.abb07f,",                                                                                               
             "abb25_1.abb_file.abb25,",
             "l_abb07_l_1.abb_file.abb07,",
             "l_abb07_r_1.abb_file.abb07,",
             "azi04_1.azi_file.azi04,",
             "azi05_1.azi_file.azi05,",
             "azi07_1.azi_file.azi07,",
             "abb04_2.abb_file.abb04,",                                                                                               
             "l_aag_all_2.type_file.chr1000,",                                                                                               
             "abb07f_2.abb_file.abb07f,",                                                                                               
             "abb25_2.abb_file.abb25,",
             "l_abb07_l_2.abb_file.abb07,",
             "l_abb07_r_2.abb_file.abb07,",
             "azi04_2.azi_file.azi04,",
             "azi05_2.azi_file.azi05,",
             "azi07_2.azi_file.azi07,",
             "abb04_3.abb_file.abb04,",                                                                                               
             "l_aag_all_3.type_file.chr1000,",                                                                                               
             "abb07f_3.abb_file.abb07f,",                                                                                               
             "abb25_3.abb_file.abb25,",
             "l_abb07_l_3.abb_file.abb07,",
             "l_abb07_r_3.abb_file.abb07,",
             "azi04_3.azi_file.azi04,",
             "azi05_3.azi_file.azi05,",
             "azi07_3.azi_file.azi07,",
             "abb04_4.abb_file.abb04,",                                                                                               
             "l_aag_all_4.type_file.chr1000,",                                                                                               
             "abb07f_4.abb_file.abb07f,",                                                                                               
             "abb25_4.abb_file.abb25,",
             "l_abb07_l_4.abb_file.abb07,",
             "l_abb07_r_4.abb_file.abb07,",
             "azi04_4.azi_file.azi04,",
             "azi05_4.azi_file.azi05,",
             "azi07_4.azi_file.azi07,", 
             "abb04_5.abb_file.abb04,",                                                                                               
             "l_aag_all_5.type_file.chr1000,",                                                                                               
             "abb07f_5.abb_file.abb07f,",                                                                                               
             "abb25_5.abb_file.abb25,",
             "l_abb07_l_5.abb_file.abb07,",
             "l_abb07_r_5.abb_file.abb07,",
             "azi04_5.azi_file.azi04,",
             "azi05_5.azi_file.azi05,",
             "azi07_5.azi_file.azi07,",
             #FUN-CA0098--add--str-- 
             "abb04_6.abb_file.abb04,",
             "l_aag_all_6.type_file.chr1000,",
             "abb07f_6.abb_file.abb07f,",
             "abb25_6.abb_file.abb25,",
             "l_abb07_l_6.abb_file.abb07,",
             "l_abb07_r_6.abb_file.abb07,",
             "azi04_6.azi_file.azi04,",
             "azi05_6.azi_file.azi05,",
             "azi07_6.azi_file.azi07,",
             #FUN-CA0098--add--end--
             "l_abb07_l_c.type_file.chr200,",   #No.TQC-A50151
             "l_abb07_l_s.abb_file.abb07,",
             "l_abb07_r_s.abb_file.abb07,",
             " l_cur_p.type_file.num5,",
             " l_tot_p.type_file.num5,",
             " l_n.type_file.num5,",        #No.MOD-8C0030 add by liuxqa     
             "sign_type.type_file.chr1,",   #簽核方式     #FUN-940041
             "sign_img.type_file.blob,",    #簽核圖檔     #FUN-940041
             "sign_show.type_file.chr1,",    #是否顯示簽核資料(Y/N)  #FUN-940041
             "sign_str.type_file.chr1000,", #FUN-CA0098 add
             #FUN-CA0098--add--str-- 
             "aba03.aba_file.aba03,",
             "aba04.aba_file.aba04,",
             "zo02.zo_file.zo02,",
             "abb24_1.abb_file.abb24,",
             "abb24_2.abb_file.abb24,",
             "abb24_3.abb_file.abb24,",
             "abb24_4.abb_file.abb24,",
             "abb24_5.abb_file.abb24,",
             "abb24_6.abb_file.abb24,", 
             "aac02.aac_file.aac02"
             #FUN-CA0098--add--end--
    LET l_table=cl_prt_temptable("gglg304",g_sql) CLIPPED                                                                           
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", #No.MOD-8C0030 add by liuxqa  #FUN-940041 Add 3 ?   #FUN-CA0098 add ?
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", #FUN-CA0098 add
              "        ?,?,?,? ) "                          #FUN-CA0098 add 
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("insert_prep:",status,1)                                                                                         
    END IF
 
   LET tm.bookno = ARG_VAL(1)           #NO.FUN-740055
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.wc=cl_replace_str(tm.wc, '\\\"', "'")   #No.MOD-B80009
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.w  = ARG_VAL(11)
   LET tm.n  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   LET tm.b_user  = ARG_VAL(17)  #FUN-CA0098   add
   LET tm.e_user  = ARG_VAL(18)  #FUN-CA0098   add
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN                           #NO.FUN-740055
      LET tm.bookno = g_aza.aza81  #帳別若為空白則使用預設帳別            #NO.FUN-740055
   END IF                                                                 #NO.FUN-740055     
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglg304_tm()	        	# Input print condition
      ELSE CALL gglg304()			# Read data and create out-file
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-B80009
END MAIN
 
FUNCTION gglg304_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd		LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(tm.bookno)      #NO.FUN-740055 
   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW gglg304_w AT p_row,p_col
        WITH FORM "ggl/42f/gglg304"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#  CALL s_shwact(3,2,g_bookno)     #NO.FUN-740055
   CALL s_shwact(3,2,tm.bookno)    #NO.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.t = '3'
   LET tm.u = '3'
   LET tm.w = '3'
   LET tm.n = 'N'
   LET tm.h = 'Y'  #NO.MOD-860252
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON aba01,aba02,aba06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

     #FUN-CA0098--str--add--
     ON ACTION controlp
          CASE
            WHEN INFIELD(aba01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = 'q_aba02'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aba01
              NEXT FIELD aba01
          END CASE
     #FUN-CA0098--str--end--
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gglg304_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-B80009
      EXIT PROGRAM
   END IF
   #INPUT BY NAME tm.bookno,tm.t,tm.u,tm.w,tm.n,tm.h,tm.e,tm.m WITHOUT DEFAULTS  #FUN-6C0012   #No.FUN-740055 #No.MOD-860252 add tm.h   #FUN-CA0098  mark
   INPUT BY NAME tm.bookno,tm.b_user,tm.e_user,tm.t,tm.u,tm.w,tm.h,tm.e,tm.m WITHOUT DEFAULTS    #FUN-CA0098 add
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
             #FUN-CA0098--add--str--
             LET tm.b_user = '0'
             LET tm.e_user = 'z'
             DISPLAY BY NAME tm.b_user,tm.e_user
             #FUN-CA0098--add--end--
 
       AFTER FIELD bookno
        IF tm.bookno IS NULL THEN NEXT FIELD bookno   END IF   #No.FUN-740055 
       AFTER FIELD t
          IF tm.t NOT MATCHES "[123]" THEN NEXT FIELD t END IF
       AFTER FIELD u
          IF tm.u NOT MATCHES "[123]" THEN NEXT FIELD u END IF
       AFTER FIELD w
          IF tm.w NOT MATCHES "[123]" THEN NEXT FIELD w END IF
       #FUN-CA0098--mark--str--
       #AFTER FIELD n
       #   IF tm.n NOT MATCHES "[YN]" THEN NEXT FIELD n END IF
       #FUN-CA0098--mark--end--
       AFTER FIELD m
          IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
          IF tm.m = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
###############################################################################
         ON ACTION CONTROLP                                                                                                         
          CASE                                                                                                                      
            WHEN INFIELD(bookno)                                                                                                    
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = 'q_aaa'                                                                                         
              LET g_qryparam.default1 =tm.bookno                                                                                    
              CALL cl_create_qry() RETURNING tm.bookno                                                                              
              DISPLAY BY NAME tm.bookno                                                                                             
              NEXT FIELD bookno                                                                                                     
          END CASE                                                                                                                  
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gglg304_w 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-B80009
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglg304'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglg304','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",tm.bookno CLIPPED,"'",    #NO.FUN-740055
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gglg304',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglg304_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-B80009
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglg304()
   ERROR ""
END WHILE
   CLOSE WINDOW gglg304_w
END FUNCTION
 
FUNCTION gglg304()
   DEFINE l_name	LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
          l_sql 	LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_za05	LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)   #標題內容
          l_abauser     LIKE aba_file.abauser,              #No.FUN-7C0066
          l_zx02        LIKE zx_file.zx02,                  #No.FUN-7C0066
          l_i           LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_temp1       LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_temp2       LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_n           LIKE type_file.num5,    #No.MOD-8C0030   add by liuxqa
          sr               RECORD
                           aba01     LIKE aba_file.aba01,#傳票編號
                           aba02     LIKE aba_file.aba02,#傳票日期
                           aba10     LIKE aba_file.aba10,
                           aba21     LIKE aba_file.aba21,#附件分數
                           abb02     LIKE abb_file.abb02,#項次
                           abb04     LIKE abb_file.abb04,#摘要
                           abb06     LIKE abb_file.abb06,
                           abb24     LIKE abb_file.abb24,
                           abb25     LIKE abb_file.abb25,
                           abb07f    LIKE abb_file.abb07f,
                           aag01     LIKE aag_file.aag01,
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱#FUN-6C0012
                           aag07     LIKE aag_file.aag07,
                           aag08     LIKE aag_file.aag08,
                           abb07     LIKE abb_file.abb07,    #異動金額
                           azi07     LIKE azi_file.azi07,    #add 030725 NO.A085
                           l_pageno  LIKE type_file.num5,    #NO FUN-690009   SMALLINT
                           l_aag01_l LIKE aag_file.aag01,    #NO FUN-690009   VARCHAR(24)
                           l_aag01_r LIKE aag_file.aag01,    #NO FUN-690009   VARCHAR(24)
                           l_aag02_l LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(30)
                           l_aag02_r LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(30)
                           l_aag_all LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(80)   #No.A117
                           l_abb07_l LIKE abb_file.abb07,    #NO FUN-690009   DEC(20,6)
                           l_abb07_r LIKE abb_file.abb07,    #NO FUN-690009   DEC(20,6)
                           aba03     LIKE aba_file.aba03,    #FUN-CA0098 add
                           aba04     LIKE aba_file.aba04,    #FUN-CA0098 add
                           aba24     LIKE aba_file.aba24     #FUN-CA0098 add
                        END RECORD
          DEFINE  l_l_abb07_l   LIKE abb_file.abb07
          DEFINE  l_l_abb07_r   LIKE abb_file.abb07
          DEFINE  l_aag02       LIKE aag_file.aag02
          DEFINE  l_aba01       LIKE aba_file.aba01
          DEFINE  l_str1        STRING                     #TQC-A50151 add      
          DEFINE  l_str2        STRING                     #TQC-A50151 add 
          DEFINE  sr1           RECORD
                                aba01       LIKE aba_file.aba01,                                                                                               
                                aba02       LIKE aba_file.aba02,
                                aba21       LIKE aba_file.aba21,
                                zx02        LIKE zx_file.zx02,
                                abb02       LIKE abb_file.abb02,                                                                                              
                                abb04_1     LIKE abb_file.abb04,                                                                                               
                                l_aag_all_1 LIKE type_file.chr1000,                                                                                               
                                abb07f_1    LIKE abb_file.abb07f,                                                                                               
                                abb25_1     LIKE abb_file.abb25,
                                l_abb07_l_1 LIKE abb_file.abb07,
                                l_abb07_r_1 LIKE abb_file.abb07,
                                azi04_1     LIKE azi_file.azi04,
                                azi05_1     LIKE azi_file.azi05,
                                azi07_1     LIKE azi_file.azi07,
                                abb04_2     LIKE abb_file.abb04,                                                                                               
                                l_aag_all_2 LIKE type_file.chr1000,                                                                                               
                                abb07f_2    LIKE abb_file.abb07f,                                                                                               
                                abb25_2     LIKE abb_file.abb25,
                                l_abb07_l_2 LIKE abb_file.abb07,
                                l_abb07_r_2 LIKE abb_file.abb07,
                                azi04_2     LIKE azi_file.azi04,
                                azi05_2     LIKE azi_file.azi05,
                                azi07_2     LIKE azi_file.azi07,
                                abb04_3     LIKE abb_file.abb04,                                                                                               
                                l_aag_all_3 LIKE type_file.chr1000,                                                                                               
                                abb07f_3    LIKE abb_file.abb07f,                                                                                               
                                abb25_3     LIKE abb_file.abb25,
                                l_abb07_l_3 LIKE abb_file.abb07,
                                l_abb07_r_3 LIKE abb_file.abb07,
                                azi04_3     LIKE azi_file.azi04,
                                azi05_3     LIKE azi_file.azi05,
                                azi07_3     LIKE azi_file.azi07,
                                abb04_4     LIKE abb_file.abb04,                                                                                               
                                l_aag_all_4 LIKE type_file.chr1000,                                                                                               
                                abb07f_4    LIKE abb_file.abb07f,                                                                                               
                                abb25_4     LIKE abb_file.abb25,
                                l_abb07_l_4 LIKE abb_file.abb07,
                                l_abb07_r_4 LIKE abb_file.abb07,
                                azi04_4     LIKE azi_file.azi04,
                                azi05_4     LIKE azi_file.azi05,
                                azi07_4     LIKE azi_file.azi07,
                                abb04_5     LIKE abb_file.abb04,                                                                                               
                                l_aag_all_5 LIKE type_file.chr1000,                                                                                               
                                abb07f_5    LIKE abb_file.abb07f,                                                                                               
                                abb25_5     LIKE abb_file.abb25,
                                l_abb07_l_5 LIKE abb_file.abb07,
                                l_abb07_r_5 LIKE abb_file.abb07,
                                azi04_5     LIKE azi_file.azi04,
                                azi05_5     LIKE azi_file.azi05,
                                azi07_5     LIKE azi_file.azi07,
                                #FUN-CA0098--add--str--
                                abb04_6     LIKE abb_file.abb04,
                                l_aag_all_6 LIKE type_file.chr1000,
                                abb07f_6    LIKE abb_file.abb07f,
                                abb25_6     LIKE abb_file.abb25,
                                l_abb07_l_6 LIKE abb_file.abb07,
                                l_abb07_r_6 LIKE abb_file.abb07,
                                azi04_6     LIKE azi_file.azi04,
                                azi05_6     LIKE azi_file.azi05,
                                azi07_6     LIKE azi_file.azi07,
                                #FUN-CA0098--add--end--
                                l_abb07_l_c LIKE type_file.chr200,  #No.TQC-A50151
                                l_abb07_l_s LIKE abb_file.abb07,
                                l_abb07_r_s LIKE abb_file.abb07,
                                l_cur_p     LIKE type_file.num5,
                                l_tot_p     LIKE type_file.num5 
                              END RECORD
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_ii           INTEGER
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE aba_file.aba01
             END RECORD
   DEFINE l_str               LIKE type_file.chr1000    #No.FUN-A30016
   #FUN-CA0098--add--str--
   DEFINE l_zo02      LIKE zo_file.zo02
   DEFINE l_abb24_1   LIKE abb_file.abb24
   DEFINE l_abb24_2   LIKE abb_file.abb24
   DEFINE l_abb24_3   LIKE abb_file.abb24
   DEFINE l_abb24_4   LIKE abb_file.abb24
   DEFINE l_abb24_5   LIKE abb_file.abb24
   DEFINE l_abb24_6   LIKE abb_file.abb24
   DEFINE l_aac01     LIKE aac_file.aac01
   DEFINE l_aac02     LIKE aac_file.aac02
   DEFINE l_aba24     LIKE aba_file.aba24
   #FUN-CA0098--add--end--
                           
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097  #No.MOD-B80009
     CALL cl_del_data(l_table)     #No.FUN-7C0066
     LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
     
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno   #NO.FUN-740055
    	 AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglg304'
     #使用預設帳別之幣別
     SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno    #NO.FUN-740055
     IF SQLCA.sqlcode THEN 
          CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124   #NO.FUN-740055
     END IF
     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file       #No.CHI-6A0004
      WHERE azi01 = g_aaa03
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
 
  LET l_sql = "SELECT aba01,aba02,aba10,aba21,abb02,abb04,abb06,",
                 "       abb24,abb25,abb07f,aag01,aag02,aag13,aag07,aag08,abb07,",  #FUN-6C0012
                 "       azi07,0,'','','','','',0,0,",     #No.A117
                 "       aba03,aba04,aba24,aba24 ",                      #FUN-CA0098 add
                 "   FROM aba_file,abb_file,aac_file,aag_file,OUTER azi_file",
                 "  WHERE aba00 = abb00",
                 "    AND aba00 = aag00",                 #NO.FUN-740055
                 "    AND aba01 = abb01",
                 "    AND abb03 = aag01",
                 "    AND aba01 like ltrim(rtrim(aac01)) || '-%'",   #No.FUN-550028
                 "    AND aac03 = '0'",
                 "    AND aag07 IN ('2','3')",
                 "    AND aba19 <> 'X' ",  #CHI-C80041
                 "    AND azi_file.azi01 = abb_file.abb24 ",
                 "    AND aba00 = '",tm.bookno,"'",          #No.TQC-750041
                 "    AND ",tm.wc CLIPPED
    #No.FUN-CA0098 ---Mark--- Start
    #IF tm.n = 'Y' THEN
    #    LET l_sql = l_sql CLIPPED," AND aac13 = 'Y'"                 
    #ELSE                                            #TQC-B60146   Add
    #    LET l_sql = l_sql CLIPPED," AND aac13 = 'N'" #TQC-B60146   Add
    #END IF
    #No.FUN-CA0098 ---Mark--- End
     CASE WHEN tm.t = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
          WHEN tm.t = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
     END CASE
     CASE WHEN tm.u = '1' LET l_sql = l_sql CLIPPED," AND abaacti = 'Y' "
          WHEN tm.u = '2' LET l_sql = l_sql CLIPPED," AND abaacti = 'N' "
     END CASE
     CASE WHEN tm.w = '1' LET l_sql = l_sql CLIPPED," AND abaprno = 0 "
          WHEN tm.w = '2' LET l_sql = l_sql CLIPPED," AND abaprno > 0 "
     END CASE
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql CLIPPED, " AND aag09 = 'Y' " 
     END IF
     IF g_aaz.aaz82 = 'Y' THEN 
        LET l_sql = l_sql CLIPPED," ORDER BY aba02,aba01,abb06,abb02 "      #No.MOD-910149 
     ELSE
        LET l_sql = l_sql CLIPPED," ORDER BY aba02,aba01,abb02 "   
     END IF
     PREPARE gglg304_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-B80009
        EXIT PROGRAM
     END IF
     DECLARE gglg304_curs1 CURSOR FOR gglg304_prepare1
     LET l_aba01 = NULL
     LET l_i = 0
     LET l_l_abb07_l = 0
     LET l_l_abb07_r = 0
     LET l_n = 1         #No.MOD-8C0030  add by liuxqa
     INITIALIZE sr1.* TO NULL
     FOREACH gglg304_curs1 INTO sr.*,l_aba24     #FUN-CA0098 add l_aba24
       #FUN-CA0098--add--str--
       IF l_aba24<tm.b_user OR l_aba24>tm.e_user THEN CONTINUE FOREACH END IF
       LET l_aac01 = s_get_doc_no(sr.aba01)
       SELECT aac02 INTO l_aac02 FROM aac_file WHERE aac01 = l_aac01
       #FUN-CA0098--add--end--
       IF sr.abb06 = '1'
          THEN LET sr.l_abb07_l = sr.abb07
               LET sr.l_abb07_r = null
          ELSE IF sr.abb06 = '2' THEN
                  LET sr.l_abb07_l = null
                  LET sr.l_abb07_r = sr.abb07
               END IF
       END IF
       IF tm.e ='Y' THEN                                                        
          LET sr.l_aag02_l = sr.aag13                                           
       ELSE
          LET sr.l_aag02_l = sr.aag02
       END IF  #FUN-6C0012
       LET sr.l_aag01_l = sr.aag01
       LET sr.l_aag01_r = sr.aag01[1,4]
       IF tm.e = 'Y' THEN
          SELECT aag13 INTO sr.l_aag02_r FROM aag_file                          
            WHERE aag01 = sr.l_aag01_r                                          
              AND aag00 = tm.bookno          #NO.FUN-740055    
       ELSE
          SELECT aag02 INTO sr.l_aag02_r FROM aag_file
           WHERE aag01 = sr.l_aag01_r
             AND aag00 = tm.bookno          #NO.FUN-740055    
       END IF  #FUN-6C0012
       IF cl_null(sr.l_aag02_r) THEN
          LET sr.l_aag02_r=' '
       END IF
       #No.FUN-A30016  --Begin                                                  
       CALL r304_get_dimention(sr.aba01,sr.abb02) RETURNING l_str               
       #LET sr.l_aag_all = sr.l_aag02_r CLIPPED,
       #                   '-(',sr.l_aag01_l CLIPPED,')',sr.l_aag02_l CLIPPED  #MOD-590097
       LET sr.l_aag_all = sr.l_aag02_r CLIPPED,                                 
                          '-(',sr.l_aag01_l CLIPPED,')',sr.l_aag02_l CLIPPED, 
                          l_str CLIPPED                                         
       #No.FUN-A30016  --End    
        IF NOT cl_null(l_aba01) THEN
           #新一筆憑証
           IF l_aba01 <> sr.aba01 THEN
              #當前頁
              LET sr1.l_cur_p = l_i / 6          #FUN-CA0098  Mod 5 --> 6
              IF l_i MOD 6 <> 0 THEN             #FUN-CA0098  Mod 5 --> 6
                 LET sr1.l_cur_p = sr1.l_cur_p + 1
              END IF
 
              LET sr1.l_abb07_l_s = l_l_abb07_l
              LET sr1.l_abb07_r_s = l_l_abb07_r
             #TQC-A50151---modify---start---                                    
              IF g_lang = '0' OR g_lang = '2' THEN                              
                 LET sr1.l_abb07_l_c = s_sayc2(l_l_abb07_l,50)                  
              ELSE                                                              
                 CALL cl_say(l_l_abb07_l,80) RETURNING l_str1,l_str2            
                 LET sr1.l_abb07_l_c = l_str1 CLIPPED," ",l_str2 CLIPPED        
              END IF                                                            
             #TQC-A50151---modify---end---
              UPDATE aba_file SET abaprno = abaprno + 1
                     WHERE aba01 = sr.aba01
                       AND aba00 = tm.bookno     
              IF sqlca.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","aba_file",sr.aba01,tm.bookno,STATUS,"","upd abaprno",0)  
              END IF
              
             #No.FUN-CA0098 ---Add--- Start
              IF cl_null(sr1.l_aag_all_1) THEN LET l_abb24_1 = Null END IF
              IF cl_null(sr1.l_aag_all_2) THEN LET l_abb24_2 = Null END IF
              IF cl_null(sr1.l_aag_all_3) THEN LET l_abb24_3 = Null END IF
              IF cl_null(sr1.l_aag_all_4) THEN LET l_abb24_4 = Null END IF
              IF cl_null(sr1.l_aag_all_5) THEN LET l_abb24_5 = Null END IF
              IF cl_null(sr1.l_aag_all_6) THEN LET l_abb24_6 = Null END IF
             #No.FUN-CA0098 ---Add--- End
              EXECUTE insert_prep USING sr1.*,l_n,       #No.MOD-8C0030 add by liuxqa
                                         "",l_img_blob,"N","",    #FUN-940041   
                                        sr.aba03,sr.aba04,l_zo02,    #FUN-CA0098 add
                                        l_abb24_1,l_abb24_2,l_abb24_3,l_abb24_4,l_abb24_5,l_abb24_6,l_aac02  #FUN-CA0098 add 
              INITIALIZE sr1.* TO NULL 
              LET l_n = l_n + 1                          #No.MOD-8C0030 add by liuxqa
              LET l_i = 0
              LET l_l_abb07_l = 0
              LET l_l_abb07_r = 0
           ELSE
              #每5筆,打一頁,加入AND條件,否則可能多打一頁
              IF l_i MOD 6 = 0 THEN   #TQC-880017       #No.FUN-CA0098  Mod 5 --> 6
                 LET sr1.l_cur_p = l_i / 6              #No.FUN-CA0098  Mod 5 --> 6    
                 
             #No.FUN-CA0098 ---Add--- Start
              IF cl_null(sr1.l_aag_all_1) THEN LET l_abb24_1 = Null END IF
              IF cl_null(sr1.l_aag_all_2) THEN LET l_abb24_2 = Null END IF
              IF cl_null(sr1.l_aag_all_3) THEN LET l_abb24_3 = Null END IF
              IF cl_null(sr1.l_aag_all_4) THEN LET l_abb24_4 = Null END IF
              IF cl_null(sr1.l_aag_all_5) THEN LET l_abb24_5 = Null END IF
              IF cl_null(sr1.l_aag_all_6) THEN LET l_abb24_6 = Null END IF
             #No.FUN-CA0098 ---Add--- End
                 EXECUTE insert_prep USING sr1.*,l_n,    #No.MOD-8C0030 add by liuxqa
                                           "",l_img_blob,"N","",    #FUN-940041   
                                           sr.aba03,sr.aba04,l_zo02,   #FUN-CA0098 add
                                           l_abb24_1,l_abb24_2,l_abb24_3,l_abb24_4,l_abb24_5,l_abb24_6,l_aac02  #FUN-CA0098 add
                 INITIALIZE sr1.* TO NULL
                 LET l_n = l_n + 1                       #No.MOD-8C0030 add by liuxqa
              END IF
           END IF
        END IF
       SELECT COUNT(*) INTO sr1.l_tot_p FROM aba_file,abb_file
         WHERE aba00 = abb00
           AND aba01 = abb01
           AND aba01 = sr.aba01
       LET l_temp1 = sr1.l_tot_p/6              #FUN-CA0098  Mod 5 --> 6
       IF sr1.l_tot_p MOD 6 <> 0 THEN           #FUN-CA0098  Mod 5 --> 6
           LET sr1.l_tot_p = l_temp1 + 1
        ELSE
           LET sr1.l_tot_p = l_temp1
        END IF
        SELECT abauser INTO l_abauser FROM aba_file WHERE aba01=sr.aba01
        SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_abauser
        #每一筆處理
        LET sr1.aba01 = sr.aba01
        LET sr1.aba02 = sr.aba02
        #No.TQC-BC0205  --Begin
        #LET sr1.aba21 = sr.aba21
        LET sr1.aba21 = sr.aba21 USING "##&"
        #No.TQC-BC0205  --End  
        LET sr1.abb02 = sr.abb02
        LET sr1.zx02  = l_zx02
       SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file      
        WHERE azi01 = sr.abb24
        CASE l_i MOD 6             #FUN-CA0098  Mod 5 --> 6
            WHEN 0 LET sr1.abb04_1 = sr.abb04
                   LET sr1.l_aag_all_1 = sr.l_aag_all
                   LET sr1.abb07f_1 = sr.abb07f
                   LET sr1.abb25_1 = sr.abb25
                   LET sr1.l_abb07_l_1 = sr.l_abb07_l
                   LET sr1.l_abb07_r_1 = sr.l_abb07_r
                   LET sr1.azi04_1 = t_azi04
                   LET sr1.azi05_1 = t_azi05
                   LET sr1.azi07_1 = sr.azi07
                   LET l_abb24_1 = sr.abb24   #FUN-CA0098   Add
            WHEN 1 LET sr1.abb04_2 = sr.abb04
                   LET sr1.l_aag_all_2 = sr.l_aag_all
                   LET sr1.abb07f_2 = sr.abb07f
                   LET sr1.abb25_2 = sr.abb25
                   LET sr1.l_abb07_l_2 = sr.l_abb07_l
                   LET sr1.l_abb07_r_2 = sr.l_abb07_r
                   LET sr1.azi04_2 = t_azi04
                   LET sr1.azi05_2 = t_azi05
                   LET sr1.azi07_2 = sr.azi07
                   LET l_abb24_2 = sr.abb24   #FUN-CA0098   Add
            WHEN 2 LET sr1.abb04_3 = sr.abb04
                   LET sr1.l_aag_all_3 = sr.l_aag_all
                   LET sr1.abb07f_3 = sr.abb07f
                   LET sr1.abb25_3 = sr.abb25
                   LET sr1.l_abb07_l_3 = sr.l_abb07_l
                   LET sr1.l_abb07_r_3 = sr.l_abb07_r
                   LET sr1.azi04_3 = t_azi04
                   LET sr1.azi05_3 = t_azi05
                   LET sr1.azi07_3 = sr.azi07
                   LET l_abb24_3 = sr.abb24   #FUN-CA0098   Add
            WHEN 3 LET sr1.abb04_4 = sr.abb04
                   LET sr1.l_aag_all_4 = sr.l_aag_all
                   LET sr1.abb07f_4 = sr.abb07f
                   LET sr1.abb25_4 = sr.abb25
                   LET sr1.l_abb07_l_4 = sr.l_abb07_l
                   LET sr1.l_abb07_r_4 = sr.l_abb07_r
                   LET sr1.azi04_4 = t_azi04
                   LET sr1.azi05_4 = t_azi05
                   LET sr1.azi07_4 = sr.azi07
                   LET l_abb24_4 = sr.abb24   #FUN-CA0098   Add
            WHEN 4 LET sr1.abb04_5 = sr.abb04
                   LET sr1.l_aag_all_5 = sr.l_aag_all
                   LET sr1.abb07f_5 = sr.abb07f
                   LET sr1.abb25_5 = sr.abb25
                   LET sr1.l_abb07_l_5 = sr.l_abb07_l
                   LET sr1.l_abb07_r_5 = sr.l_abb07_r
                   LET sr1.azi04_5 = t_azi04
                   LET sr1.azi05_5 = t_azi05
                   LET sr1.azi07_5 = sr.azi07
                   LET l_abb24_5 = sr.abb24   #FUN-CA0098   Add
            #FUN-CA0098--add--str--
            WHEN 5 LET sr1.abb04_6 = sr.abb04
                   LET sr1.l_aag_all_6 = sr.l_aag_all
                   LET sr1.abb07f_6 = sr.abb07f
                   LET sr1.abb25_6 = sr.abb25
                   LET sr1.l_abb07_l_6 = sr.l_abb07_l
                   LET sr1.l_abb07_r_6 = sr.l_abb07_r
                   LET sr1.azi04_6 = t_azi04
                   LET sr1.azi05_6 = t_azi05
                   LET sr1.azi07_6 = sr.azi07
                   LET l_abb24_6 = sr.abb24
            #FUN-CA0098--add--end--
        END CASE
        
        LET l_i = l_i + 1
        LET l_aba01 = sr.aba01
        IF sr.l_abb07_l IS NULL THEN LET sr.l_abb07_l = 0 END IF
        IF sr.l_abb07_r IS NULL THEN LET sr.l_abb07_r = 0 END IF
        LET l_l_abb07_l = l_l_abb07_l + sr.l_abb07_l
        LET l_l_abb07_r = l_l_abb07_r + sr.l_abb07_r
     END FOREACH
     #最后一筆
     IF l_i > 0 THEN
        #當前頁
        LET sr1.l_cur_p = l_i / 6       #FUN-CA0098  Mod 5 --> 6 
        IF l_i MOD 6 <> 0 THEN          #FUN-CA0098  Mod 5 --> 6
           LET sr1.l_cur_p = sr1.l_cur_p + 1
        END IF
 
        LET sr1.l_abb07_l_s = l_l_abb07_l
        LET sr1.l_abb07_r_s = l_l_abb07_r
       #TQC-A50151---modify---start---                                          
        IF g_lang = '0' OR g_lang = '2' THEN                                    
           LET sr1.l_abb07_l_c = s_sayc2(l_l_abb07_l,50)                        
        ELSE                                                                    
           CALL cl_say(l_l_abb07_l,80) RETURNING l_str1,l_str2                  
           LET sr1.l_abb07_l_c = l_str1 CLIPPED," ",l_str2 CLIPPED              
        END IF                                                                  
       #TQC-A50151---modify---end---
        UPDATE aba_file SET abaprno = abaprno + 1
                     WHERE aba01 = sr.aba01
                       AND aba00 = tm.bookno     
        IF sqlca.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","aba_file",sr.aba01,tm.bookno,STATUS,"","upd abaprno",0) 
        END IF
        
             #No.FUN-CA0098 ---Add--- Start
              IF cl_null(sr1.l_aag_all_1) THEN LET l_abb24_1 = Null END IF
              IF cl_null(sr1.l_aag_all_2) THEN LET l_abb24_2 = Null END IF
              IF cl_null(sr1.l_aag_all_3) THEN LET l_abb24_3 = Null END IF
              IF cl_null(sr1.l_aag_all_4) THEN LET l_abb24_4 = Null END IF
              IF cl_null(sr1.l_aag_all_5) THEN LET l_abb24_5 = Null END IF
              IF cl_null(sr1.l_aag_all_6) THEN LET l_abb24_6 = Null END IF
             #No.FUN-CA0098 ---Add--- End
        EXECUTE insert_prep USING sr1.*,l_n,      #No.MOD-8C0030  add by liuxqa
                                   "",l_img_blob,"N","",    #FUN-940041   
                                  sr.aba03,sr.aba04,l_zo02,    #FUN-CA0098 add
                                  l_abb24_1,l_abb24_2,l_abb24_3,l_abb24_4,l_abb24_5,l_abb24_6,l_aac02  #FUN-CA0098 add
        INITIALIZE sr1.* TO NULL
        LET l_n = l_n + 1                         #No.MOD-8C0030  add by liuxqa
        LET l_i = 0
     END IF
     #IF tm.n = 'N' THEN     #FUN-CA0098 mark
         LET l_name = 'gglg304'
     #FUN-CA0098--mark--str--
     #ELSE
     #    LET l_name = 'gglg304_1'
     #END IF
     #FUN-CA0098--mark--end--
###GENGRE###     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN                                                                                                              
        CALL cl_wcchp(tm.wc,'aba01,aba02,aba06')                                                           
        RETURNING tm.wc                                                                                                              
     END IF
###GENGRE###     LET g_str = tm.wc
     #FUN-D10098--mark--str--
     #LET g_cr_table = l_table                 #主報表的temp table名稱
     #LET g_cr_gcx01 = "agli108"               #單別維護程式
     #LET g_cr_apr_key_f = "aba01"             #報表主鍵欄位名稱，用"|"隔開 
     #LET l_sql = "SELECT DISTINCT aba01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #PREPARE key_pr FROM l_sql
     #DECLARE key_cs CURSOR FOR key_pr
     #LET l_ii = 1
     #報表主鍵值
     #CALL g_cr_apr_key.clear()                #清空
     #FOREACH key_cs INTO l_key.*            
     #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #   LET l_ii = l_ii + 1
     #END FOREACH
     #FUN-D10098--mark--end
###GENGRE###     CALL cl_prt_cs3('gglg304',l_name,g_sql,g_str)
    
    LET g_template =l_name #FUN-D10098 
    
    CALL gglg304_grdata()    ###GENGRE###
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097   #No.MOD-B80009
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
#No.FUN-A30016  --Begin

FUNCTION r304_get_dimention(p_aba01,p_abb02)
   DEFINE p_aba01 LIKE aba_file.aba01
   DEFINE p_abb02 LIKE abb_file.abb02
   DEFINE l_str   LIKE type_file.chr1000
   DEFINE l_flag  LIKE type_file.chr1
   DEFINE l_gem02 LIKE gem_file.gem02
   DEFINE l_abb   RECORD
                  abb05   LIKE abb_file.abb05,
                  abb11   LIKE abb_file.abb11,
                  abb12   LIKE abb_file.abb12,
                  abb13   LIKE abb_file.abb13,
                  abb14   LIKE abb_file.abb14,
                  abb31   LIKE abb_file.abb31,
                  abb32   LIKE abb_file.abb32,
                  abb33   LIKE abb_file.abb33,
                  abb34   LIKE abb_file.abb34,
                  abb35   LIKE abb_file.abb35,
                  abb36   LIKE abb_file.abb36,
                  abb37   LIKE abb_file.abb37,
                  abb03   LIKE abb_file.abb03   #FUN-CA0098   Add
                  END RECORD
   DEFINE l_aee04 LIKE aee_file.aee04           #No.FUN-CA0098   Add

   SELECT abb05,abb11,abb12,abb13,abb14,abb31,abb32,abb33,
          abb34,abb35,abb36,abb37,abb03         #FUN-CA0098   Add abb03
     INTO l_abb.*
     FROM abb_file
    WHERE abb00 = tm.bookno
      AND abb01 = p_aba01
      AND abb02 = p_abb02
   LET l_str = NULL  
   IF NOT cl_null(l_abb.abb05) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_abb.abb05
      IF cl_null(l_gem02) THEN LET l_gem02 = l_abb.abb05 END IF
      #LET l_str = '-',l_gem02    #FUN-CA0098   Mark
      LET l_str = '/',l_abb.abb05 CLIPPED,'-',l_gem02   #FUN-CA0098   Add
   END IF

   LET l_flag = 'N'
   IF NOT cl_null(l_abb.abb11) THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb11,'aag15','1') RETURNING l_aee04 #FUN-CA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb11         #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb11 CLIPPED ,'-',l_aee04 #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb11         #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb11 CLIPPED ,'-',l_aee04   #FUN-CA0098 
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb12) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb12,'aag16','2') RETURNING l_aee04  #FUN-CA0098 add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb12                      #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb12 CLIPPED ,'-',l_aee04  #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb12        #FUN_CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb12 CLIPPED ,'-',l_aee04   #FUN-CA0098  add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb13) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb12,'aag16','2') RETURNING l_aee04  #FUN-CA0098 add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb13                      #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb13 CLIPPED ,'-',l_aee04  #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb13        #FUN_CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb13 CLIPPED ,'-',l_aee04   #FUN-CA0098  add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb14) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb14,'aag18','4') RETURNING l_aee04   #No.FUN-CA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb14                      #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb14 CLIPPED ,'-',l_aee04  #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb14        #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb14 CLIPPED ,'-',l_aee04   #FUN-CA0098  add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb31) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb31,'aag31','4') RETURNING l_aee04   #FUN-CA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb31                       #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb31 CLIPPED ,'-',l_aee04   #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb31         #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb31 CLIPPED ,'-',l_aee04   #FUN-CA0098 add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb32) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb32,'aag32','6') RETURNING l_aee04   #FUN-CA0098   Add
      IF cl_null(l_str) THEN
         LET l_str = '-',l_abb.abb32
      ELSE
         LET l_str = l_str CLIPPED,'-',l_abb.abb32
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb33) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb33,'aag33','7') RETURNING l_aee04   #No.FUN-CA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb33                       #FUN-CA0098  Mark
         LET l_str = '/',l_abb.abb33 CLIPPED ,'-',l_aee04   #FUN-CA0098  Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb33         #FUN-CA0098  Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb33 CLIPPED ,'-',l_aee04   #FUN-CA0098 add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb34) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb34,'aag34','8') RETURNING l_aee04   #FUN-cA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb34                       #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb34 CLIPPED ,'-',l_aee04   #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb34         #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb34 CLIPPED ,'-',l_aee04   #FUN-CA0098   Add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb35) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb35,'aag35','9') RETURNING l_aee04   #FUN-cA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb35                        #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb35 CLIPPED ,'-',l_aee04    #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb35          #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb35 CLIPPED ,'-',l_aee04 #FUN-CA0098   Add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb36) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb36,'aag36','10') RETURNING l_aee04    #FUN-CCCA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb36                        #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb36 CLIPPED ,'-',l_aee04    #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb36                     #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb36 CLIPPED ,'-',l_aee04 #FUN-CA0098   Add
      END IF
      LET l_flag = 'Y'
   END IF
  
   IF NOT cl_null(l_abb.abb37) AND l_flag = 'N' THEN
      CALL r999_get_ahe02(l_abb.abb03,l_abb.abb37,'aag37','99') RETURNING l_aee04  #FUN-CA0098   Add
      IF cl_null(l_str) THEN
         #LET l_str = '-',l_abb.abb37                        #FUN-CA0098   Mark
         LET l_str = '/',l_abb.abb37 CLIPPED ,'-',l_aee04    #FUN-CA0098   Add
      ELSE
         #LET l_str = l_str CLIPPED,'-',l_abb.abb37          #FUN-CA0098   Mark
         LET l_str = l_str CLIPPED,'/',l_abb.abb37 CLIPPED ,'-',l_aee04 #FUN-CA0098   Add
      END IF
      LET l_flag = 'Y'
   END IF
  
   RETURN l_str

END FUNCTION
#No.FUN-A30016  --End  
#FUN-B80096

#FUN-CA0098--add--str--
FUNCTION r999_get_ahe02(p_aag01,p_aed02,p_gaq01,p_aee02)
  DEFINE p_aag01         LIKE type_file.chr50
  DEFINE p_aed02         LIKE aed_file.aed02
  DEFINE p_gaq01         LIKE gaq_file.gaq01
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe03         LIKE ahe_file.ahe03
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE l_sql1          STRING
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE p_aee02         LIKE aee_file.aee02

     IF g_aaz.aaz119 ='N' THEN RETURN ' ' END IF
     #查找異動碼(核算項)值
     LET l_sql1 = " SELECT ",p_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",tm.bookno,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",p_gaq01 CLIPPED," IS NOT NULL"
     PREPARE t110_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
     END IF
     DECLARE t110_gaq01_cs SCROLL CURSOR FOR t110_gaq01_p

     #取異動碼(核算項)名稱
     LET l_ahe01 = NULL
     OPEN t110_gaq01_cs USING p_aag01
     IF SQLCA.sqlcode THEN
        CLOSE t110_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST t110_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE t110_gaq01_cs
        RETURN NULL
     END IF
     CLOSE t110_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
        LET l_ahe03 = ''
        LET l_ahe04 = ''
        LET l_ahe05 = ''
        LET l_ahe07 = ''
        SELECT ahe03,ahe04,ahe05,ahe07 INTO l_ahe03,l_ahe04,l_ahe05,l_ahe07
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
           NOT cl_null(l_ahe07) AND l_ahe03 = '1' THEN
           LET l_ahe02_d = ''
           LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                        "  FROM ",l_ahe04 CLIPPED,
                        " WHERE ",l_ahe05 CLIPPED," = '",p_aed02,"'"
           PREPARE ahe_p1 FROM l_sql1
           EXECUTE ahe_p1 INTO l_ahe02_d
        END IF
        IF l_ahe03 = '2' THEN
           LET l_ahe02_d = ''
           SELECT aee04 INTO l_ahe02_d
             FROM aee_file
            WHERE aee00 = g_bookno
              AND aee01 = p_aag01
              AND aee02 = p_aee02
              AND aee03 = p_aed02
        END IF
     END IF

     RETURN l_ahe02_d
END FUNCTION
#FUN-CA0098--add--end--

###GENGRE###START
FUNCTION gglg304_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

   LOCATE sr1.sign_img IN MEMORY   
    CALL cl_gre_init_apr()          

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gglg304")
        IF handler IS NOT NULL THEN
            START REPORT gglg304_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                       ," ORDER BY aba01 "   #FUN-D10098
          
            DECLARE gglg304_datacur1 CURSOR FROM l_sql
            FOREACH gglg304_datacur1 INTO sr1.*
                OUTPUT TO REPORT gglg304_rep(sr1.*)
            END FOREACH
            FINISH REPORT gglg304_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gglg304_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-D10098--add--str--
    DEFINE l_date   STRING
    DEFINE l_page   STRING
    DEFINE l_abb07f_1_fmt   STRING
    DEFINE l_abb07f_2_fmt   STRING
    DEFINE l_abb07f_3_fmt   STRING
    DEFINE l_abb07f_4_fmt   STRING
    DEFINE l_abb07f_5_fmt   STRING
    DEFINE l_abb07f_6_fmt   STRING   #FUN-CA0098 add
    DEFINE l_abb25_1_fmt    STRING
    DEFINE l_abb25_2_fmt    STRING
    DEFINE l_abb25_3_fmt    STRING
    DEFINE l_abb25_4_fmt    STRING
    DEFINE l_abb25_5_fmt    STRING
    DEFINE l_abb25_6_fmt    STRING   #FUN-CA0098 add
    DEFINE l_abb07_1_fmt    STRING
    DEFINE l_abb07_2_fmt    STRING
    DEFINE l_abb07_3_fmt    STRING
    DEFINE l_abb07_4_fmt    STRING
    DEFINE l_abb07_5_fmt    STRING
    DEFINE l_abb07_6_fmt    STRING   #FUN-CA0098 add
    DEFINE l_abb07_l_s_fmt  STRING
    DEFINE l_abb07_r_s_fmt  STRING
    DEFINE l_aac01          LIKE aac_file.aac01
    #FUN-D10098--add--end
    
    ORDER EXTERNAL BY sr1.aba01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aba01
            LET l_lineno = 0
            #FUN-D10098--add--str--
            LET l_date=YEAR(sr1.aba02),cl_getmsg('anm-156',g_lang),
                       MONTH(sr1.aba02) USING '<<',cl_getmsg('anm-157',g_lang),
                       DAY(sr1.aba02) USING '<<',cl_getmsg('apj-025',g_lang)
            LET l_page = sr1.l_tot_p
            LET l_page = l_page.trim()
            LET l_page=sr1.l_cur_p,"/",l_page
            LET l_page = l_page.trim() 
            PRINTX l_date,l_page
            LET sr1.aba03 = YEAR(sr1.aba02)    #FUN-CA0098 add
            LET sr1.aba04 = MONTH(sr1.aba02)   #FUN-CA0098 add
            #FUN-D10098--add--end
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-D10098--add--str--
            LET l_abb07f_1_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04_1)
            LET l_abb07f_2_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04_2)
            LET l_abb07f_3_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04_3)
            LET l_abb07f_4_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04_4)
            LET l_abb07f_5_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04_5)
            LET l_abb07f_6_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04_6)   #FUN-CA0098 add
            PRINTX l_abb07f_1_fmt,l_abb07f_2_fmt,l_abb07f_3_fmt,
                   l_abb07f_4_fmt,l_abb07f_5_fmt,l_abb07f_6_fmt        #FUN-CA0098 add l_abb07f_6_fmt       
            LET l_abb25_1_fmt = cl_gr_numfmt('abb_file','abb25',sr1.azi07_1)
            LET l_abb25_2_fmt = cl_gr_numfmt('abb_file','abb25',sr1.azi07_2)
            LET l_abb25_3_fmt = cl_gr_numfmt('abb_file','abb25',sr1.azi07_3)
            LET l_abb25_4_fmt = cl_gr_numfmt('abb_file','abb25',sr1.azi07_4)
            LET l_abb25_5_fmt = cl_gr_numfmt('abb_file','abb25',sr1.azi07_5)
            LET l_abb25_6_fmt = cl_gr_numfmt('abb_file','abb25',sr1.azi07_6)   #FUN-CA0098 add
            PRINTX l_abb25_1_fmt,l_abb25_2_fmt,l_abb25_3_fmt,
                   l_abb25_4_fmt,l_abb25_5_fmt,l_abb25_6_fmt           #FUN-CA0098 add l_abb25_6_fmt
            LET l_abb07_1_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04_1)
            LET l_abb07_2_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04_2)
            LET l_abb07_3_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04_3)
            LET l_abb07_4_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04_4)
            LET l_abb07_5_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04_5)
            LET l_abb07_6_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04_6)    #FUN-CA0098 add
            PRINTX l_abb07_1_fmt,l_abb07_2_fmt,l_abb07_3_fmt,
                   l_abb07_4_fmt,l_abb07_5_fmt,l_abb07_6_fmt    #FUN-CA0098 add l_abb07_6_fmt
            IF sr1.l_abb07_l_s =0 THEN LET sr1.l_abb07_l_s=0.00 END IF
            LET l_abb07_l_s_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi05_1)
            IF sr1.l_abb07_r_s=0 THEN LET sr1.l_abb07_r_s=0.00 END IF
            LET l_abb07_r_s_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi05_1)
            PRINTX l_abb07_l_s_fmt,l_abb07_r_s_fmt

            #FUN-CA0098--add--str--
            SELECT zo02 INTO sr1.zo02 FROM zo_file WHERE zo01 = g_rlang   
            LET l_aac01 = s_get_doc_no(sr1.aba01)
            SELECT aac02 INTO sr1.aac02 FROM aac_file WHERE aac01 = l_aac01  
            #FUN-CA0098--add--end--
            
            #FUN-D10098--add--end

            PRINTX sr1.*

        AFTER GROUP OF sr1.aba01

        
        ON LAST ROW

END REPORT
###GENGRE###END
