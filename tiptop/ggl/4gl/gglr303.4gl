# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr303.4gl
# Descriptions...:
# Date & Author..: 02/08/26 By leagh
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-510007 05/03/04 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.MOD-590097 05/09/08 By vivien  報表調整為標准格
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印“額外名稱”
# Modify.........: No.FUN-740055 07/04/13 By arman   會計科目加帳套
# Modify.........: No.TQC-750041 07/05/14 By Lynn 系統設置的報表寬度與實際印出的寬度不符
# Modify.........: No.TQC-770131 07/07/31 BY johnray 去掉橫線
# Modify.........: No.FUN-7C0064 07/12/26 By Carrier 報表格式轉CR
# Modify.........: No.MOD-860252 09/02/03 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	       	       #Print condition RECORD
           wc  LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(400)   #Where Condiction
           t   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     #排列順序
           u   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1      #排列順序
           w   LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     #是否列印摘要
           h   LIKE type_file.chr1,    #MOD-860252
           e   LIKE type_file.chr1,    #FUN-6C0012
           m   LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)     #是否輸入其它特殊列印條件
           END RECORD,
#       g_bookno  LIKE aba_file.aba00 #帳別編號
        bookno    LIKE aba_file.aba00    #NO.FUN-740055
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009    SMALLINT   #count/index for any purpose
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
 
 
 
#   LET g_bookno = ARG_VAL(1)   #NO.FUN-740055
 
    LET bookno = ARG_VAL(1)   #NO.FUN-740055
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.w  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #NO.FUN-740055 --- Begin
   IF bookno = ' ' OR bookno IS NULL THEN
      LET bookno = g_aza.aza81   #帳別若為空白則使用預設帳別
   END IF
   #NO.FUN-740055
 
   #No.FUN-7C0064  --Begin
   LET g_sql = " aba01.aba_file.aba01,",
               " aba02.aba_file.aba02,",
               " aba10.aba_file.aba10,",
               " aag02.aag_file.aag02,",
               " aba21.aba_file.aba21,",
               " abb02_1.abb_file.abb02,",
               " abb04_1.abb_file.abb04,",
               " aag01_1.aag_file.aag01,",
               " aag02_1.aag_file.aag02,",
               " abb07_1.abb_file.abb07,",
               " abb24_1.abb_file.abb24,",
               " t_azi04_1.azi_file.azi04,",
               " abb02_2.abb_file.abb02,",
               " abb04_2.abb_file.abb04,",
               " aag01_2.aag_file.aag01,",
               " aag02_2.aag_file.aag02,",
               " abb07_2.abb_file.abb07,",
               " abb24_2.abb_file.abb24,",
               " t_azi04_2.azi_file.azi04,",
               " abb02_3.abb_file.abb02,",
               " abb04_3.abb_file.abb04,",
               " aag01_3.aag_file.aag01,",
               " aag02_3.aag_file.aag02,",
               " abb07_3.abb_file.abb07,",
               " abb24_3.abb_file.abb24,",
               " t_azi04_3.azi_file.azi04,",
               " abb02_4.abb_file.abb02,",
               " abb04_4.abb_file.abb04,",
               " aag01_4.aag_file.aag01,",
               " aag02_4.aag_file.aag02,",
               " abb07_4.abb_file.abb07,",
               " abb24_4.abb_file.abb24,",
               " t_azi04_4.azi_file.azi04,",
               " abb02_5.abb_file.abb02,",
               " abb04_5.abb_file.abb04,",
               " aag01_5.aag_file.aag01,",
               " aag02_5.aag_file.aag02,",
               " abb07_5.abb_file.abb07,",
               " abb24_5.abb_file.abb24,",
               " t_azi04_5.azi_file.azi04,",
               " abb07_c.type_file.chr50,",
               " abb07_s.abb_file.abb07,",
               " l_cur_p.type_file.num5,",
               " l_tot_p.type_file.num5 "
 
   LET l_table = cl_prt_temptable('gglr303',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?        )           "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0064  --End

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglr303_tm()	        	# Input print condition
      ELSE CALL gglr303()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr303_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd		LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(bookno)        #NO.FUN-740055
   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW gglr303_w AT p_row,p_col
        WITH FORM "ggl/42f/gglr303"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(3,2,bookno)                   #NO.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.t = '3'
   LET tm.u = '3'
   LET tm.w = '3'
   LET tm.h = 'Y' #MOD-860252
   LET tm.e = 'N' #FUN-6C0012
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON aba01,aba02,aba06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW gglr303_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   INPUT BY NAME bookno, tm.t,tm.u,tm.w,tm.h,tm.e,tm.m WITHOUT DEFAULTS  #FUN-6C0012    #NO.FUN-740055 #No.MOD-860252 add tm.h
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD t
          IF tm.t NOT MATCHES "[123]" THEN NEXT FIELD t END IF
       AFTER FIELD u
          IF tm.u NOT MATCHES "[123]" THEN NEXT FIELD u END IF
       AFTER FIELD w
          IF tm.w NOT MATCHES "[123]" THEN NEXT FIELD w END IF
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
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#NO.FUN-740055   --Begin
      ON ACTION CONTROLP
	 CASE
            WHEN INFIELD(bookno) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 =bookno
               CALL cl_create_qry() RETURNING bookno
	       DISPLAY BY NAME bookno
	       NEXT FIELD bookno
         END CASE
#NO.FUN-740055   ---End
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW gglr303_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglr303'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr303','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",bookno CLIPPED,"'",         #NO.FUN-740055
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gglr303',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglr303_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglr303()
   ERROR ""
END WHILE
   CLOSE WINDOW gglr303_w
END FUNCTION
 
FUNCTION gglr303()
   DEFINE l_name	LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0097
          l_sql 	LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_za05	LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)   #標題內容
          l_i           LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_temp1       LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_temp2       LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          sr               RECORD
                           aba01     LIKE aba_file.aba01,#傳票編號
                           aba02     LIKE aba_file.aba02,#傳票日期
                           aba10     LIKE aba_file.aba10,
                           aba21     LIKE aba_file.aba21,#附件分數
                           abb02     LIKE abb_file.abb02,#項次
                           abb04     LIKE abb_file.abb04,#摘要
                           aag01     LIKE aag_file.aag01,
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           aag07     LIKE aag_file.aag07,
                           aag08     LIKE aag_file.aag08,
                           abb07     LIKE abb_file.abb07,#異動金額
                           abb24     LIKE abb_file.abb24,    #NO:7911
                           l_pageno  LIKE type_file.num5     #NO FUN-690009   SMALLINT
                        END RECORD 
  #No.FUN-7C0064  --Begin
  DEFINE  l_abb07       LIKE abb_file.abb07
  DEFINE  l_aag02       LIKE aag_file.aag02
  DEFINE  l_aba01       LIKE aba_file.aba01
  DEFINE  sr1           RECORD
                        aba01     LIKE aba_file.aba01,  #傳票編號
                        aba02     LIKE aba_file.aba02,  #傳票日期
                        aba10     LIKE aba_file.aba10,  
                        aag02     LIKE aag_file.aag02,  
                        aba21     LIKE aba_file.aba21,  #附件分數
                        abb02_1   LIKE abb_file.abb02,  #項次
                        abb04_1   LIKE abb_file.abb04,  #摘要
                        aag01_1   LIKE aag_file.aag01,  
                        aag02_1   LIKE aag_file.aag02,  #科目名稱
                        abb07_1   LIKE abb_file.abb07,  #異動金額
                        abb24_1   LIKE abb_file.abb24,
                        t_azi04_1 LIKE azi_file.azi04,
                        abb02_2   LIKE abb_file.abb02,  #項次
                        abb04_2   LIKE abb_file.abb04,  #摘要
                        aag01_2   LIKE aag_file.aag01,  
                        aag02_2   LIKE aag_file.aag02,  #科目名稱
                        abb07_2   LIKE abb_file.abb07,  #異動金額
                        abb24_2   LIKE abb_file.abb24,
                        t_azi04_2 LIKE azi_file.azi04,
                        abb02_3   LIKE abb_file.abb02,  #項次
                        abb04_3   LIKE abb_file.abb04,  #摘要
                        aag01_3   LIKE aag_file.aag01,  
                        aag02_3   LIKE aag_file.aag02,  #科目名稱
                        abb07_3   LIKE abb_file.abb07,  #異動金額
                        abb24_3   LIKE abb_file.abb24,
                        t_azi04_3 LIKE azi_file.azi04,
                        abb02_4   LIKE abb_file.abb02,  #項次
                        abb04_4   LIKE abb_file.abb04,  #摘要
                        aag01_4   LIKE aag_file.aag01,  
                        aag02_4   LIKE aag_file.aag02,  #科目名稱
                        abb07_4   LIKE abb_file.abb07,  #異動金額
                        abb24_4   LIKE abb_file.abb24,
                        t_azi04_4 LIKE azi_file.azi04,
                        abb02_5   LIKE abb_file.abb02,  #項次
                        abb04_5   LIKE abb_file.abb04,  #摘要
                        aag01_5   LIKE aag_file.aag01,  
                        aag02_5   LIKE aag_file.aag02,  #科目名稱
                        abb07_5   LIKE abb_file.abb07,  #異動金額
                        abb24_5   LIKE abb_file.abb24,
                        t_azi04_5 LIKE azi_file.azi04,
                        abb07_c   LIKE type_file.chr50, #大寫的金額
                        abb07_s   LIKE abb_file.abb07,  #金額匯總
                        l_cur_p   LIKE type_file.num5,
                        l_tot_p   LIKE type_file.num5 
                        END RECORD
  #No.FUN-7C0064  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     #No.FUN-7C0064  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-7C0064  --End
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno   #NO.FUN-740055
    	 AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr303'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 99 END IF
     #使用預設帳別之幣別
     SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = bookno    #NO.FUN-740055
     IF SQLCA.sqlcode THEN
#         CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660124
          CALL cl_err3("sel","aaa_file",bookno,"",SQLCA.sqlcode,"","",0)    #No.FUN-660124  #NO.FUN-740055
     END IF
     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file     #No.CHI-6A0004
      WHERE azi01 = g_aaa03
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT aba01,aba02,aba10,aba21,abb02,abb04,",
                 "       aag01,aag02,aag13,aag07,aag08,abb07,abb24,''",#FUN-6C0012
                 "   FROM aba_file,abb_file,aac_file,aag_file",
                 "  WHERE aba00 = abb00",
                 "    AND aba01 = abb01",
                 "    AND abb00 = aag00 AND aag00 = '",bookno,"'",    #NO.FUN-740055
                 "    AND abb06 = '2'  ",
                 "    AND abb03 = aag01",
#                 "    AND aba01[1,3] = aac01",
                 "    AND aba01 like ltrim(rtrim(aac01)) || '-%'",   #No.FUN-550028
                 "    AND aac03 = '1'",
                 "    AND aag07 IN ('2','3') ",
                 "    AND aba19 <> 'X' ",  #CHI-C80041
                 "    AND ",tm.wc CLIPPED
     CASE WHEN tm.t = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
          WHEN tm.t = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
     END CASE
     CASE WHEN tm.u = '1' LET l_sql = l_sql CLIPPED," AND abaacti = 'Y' "
          WHEN tm.u = '2' LET l_sql = l_sql CLIPPED," AND abaacti = 'N' "
     END CASE
     CASE WHEN tm.w = '1' LET l_sql = l_sql CLIPPED," AND abaprno = 0 "
          WHEN tm.w = '2' LET l_sql = l_sql CLIPPED," AND abaprno > 0 "
     END CASE
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql , " AND aag09 = 'Y' "
     END IF 
     #No.MOD-860252---end---
     #LET l_sql = l_sql CLIPPED," ORDER BY 4,9,10,11 DESC,1,4"  #No.FUN-7C0064
     LET l_sql = l_sql CLIPPED," ORDER BY aba02,aba01,abb02 "   #No.FUN-7C0064
     PREPARE gglr303_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
     END IF
     DECLARE gglr303_curs1 CURSOR FOR gglr303_prepare1
 
     #No.FUN-7C0064  --Begin
     #CALL cl_outnam('gglr303') RETURNING l_name
     #LET g_pageno = 1
     #START REPORT gglr303_rep TO l_name
     LET l_aba01 = NULL
     LET l_i = 0
     LET l_abb07 = 0
     INITIALIZE sr1.* TO NULL
     #No.FUN-7C0064  --End  
     FOREACH gglr303_curs1 INTO sr.*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
           EXIT PROGRAM
        END IF
        #No.FUN-7C0064  --Begin
        IF NOT cl_null(l_aba01) THEN
           #新一筆憑証
           IF l_aba01 <> sr.aba01 THEN
              #當前頁
              LET sr1.l_cur_p = l_i / 5
              IF l_i MOD 5 <> 0 THEN
                 LET sr1.l_cur_p = sr1.l_cur_p + 1
              END IF
 
              LET sr1.abb07_s = l_abb07
              LET sr1.abb07_c = s_sayc2(l_abb07,50)
              UPDATE aba_file SET abaprno = abaprno + 1
               WHERE aba01 = sr.aba01
                 AND aba00 = bookno
              IF sqlca.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","aba_file",sr.aba01,bookno,STATUS,"","upd abaprno",0)
              END IF
 
              EXECUTE insert_prep USING sr1.*
              INITIALIZE sr1.* TO NULL
              LET l_i = 0
              LET l_abb07 = 0
           ELSE
              #每5筆,打一頁,加入AND條件,否則可能多打一頁
              IF l_i MOD 5 = 0 AND l_i <> sr1.l_tot_p THEN
                 LET sr1.l_cur_p = l_i / 5
                 EXECUTE insert_prep USING sr1.*
                 INITIALIZE sr1.* TO NULL
              END IF
           END IF
        END IF
        #總頁數
        SELECT COUNT(*) INTO sr1.l_tot_p FROM aba_file,abb_file
          WHERE aba00 = abb00
            AND aba01 = abb01
            AND aba00 = bookno
            AND aba01 = sr.aba01
            AND abb06 = '2'
        LET l_temp1 = sr1.l_tot_p / 5
        IF sr1.l_tot_p MOD 5 <> 0 THEN 
           LET sr1.l_tot_p = l_temp1 + 1
        ELSE
           LET sr1.l_tot_p = l_temp1
        END IF
        #每一筆處理
        LET sr1.aba01 = sr.aba01
        LET sr1.aba02 = sr.aba02
        LET sr1.aba10 = sr.aba10
        IF tm.e ='Y' THEN                                                         
           SELECT aag02 INTO sr1.aag02 FROM aag_file
            WHERE aag01 = sr.aba10 AND aag00 = bookno
        ELSE
           SELECT aag13 INTO sr1.aag02 FROM aag_file
            WHERE aag01 = sr.aba10 AND aag00 = bookno
        END IF
        LET sr1.aba21 = sr.aba21
 
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.abb24
        CALL gglr303_sjkm(sr.aag01) RETURNING l_aag02
        CASE l_i MOD 5
            WHEN 0 LET sr1.abb04_1 = sr.abb04
                   LET sr1.aag01_1 = sr.aag01
                   LET sr1.aag02_1 = l_aag02
                   LET sr1.abb07_1 = sr.abb07
                   LET sr1.t_azi04_1 = t_azi04
            WHEN 1 LET sr1.abb04_2 = sr.abb04
                   LET sr1.aag01_2 = sr.aag01
                   LET sr1.aag02_2 = l_aag02
                   LET sr1.abb07_2 = sr.abb07
                   LET sr1.t_azi04_2 = t_azi04
            WHEN 2 LET sr1.abb04_3 = sr.abb04
                   LET sr1.aag01_3 = sr.aag01
                   LET sr1.aag02_3 = l_aag02
                   LET sr1.abb07_3 = sr.abb07
                   LET sr1.t_azi04_3 = t_azi04
            WHEN 3 LET sr1.abb04_4 = sr.abb04
                   LET sr1.aag01_4 = sr.aag01
                   LET sr1.aag02_4 = l_aag02
                   LET sr1.abb07_4 = sr.abb07
                   LET sr1.t_azi04_4 = t_azi04
            WHEN 4 LET sr1.abb04_5 = sr.abb04
                   LET sr1.aag01_5 = sr.aag01
                   LET sr1.aag02_5 = l_aag02
                   LET sr1.abb07_5 = sr.abb07
                   LET sr1.t_azi04_5 = t_azi04
        END CASE
 
        LET l_i = l_i + 1
        LET l_aba01 = sr.aba01
        LET l_abb07 = l_abb07 + sr.abb07
        #OUTPUT TO REPORT gglr303_rep(sr.*)
        #No.FUN-7C0064  --End  
     END FOREACH
     #No.FUN-7C0064  --Begin
     #最后一筆
     IF l_i > 0 THEN
        #當前頁
        LET sr1.l_cur_p = l_i / 5
        IF l_i MOD 5 <> 0 THEN
           LET sr1.l_cur_p = sr1.l_cur_p + 1
        END IF
 
        LET sr1.abb07_s = l_abb07
        LET sr1.abb07_c = s_sayc2(l_abb07,50)
        UPDATE aba_file SET abaprno = abaprno + 1
         WHERE aba01 = sr.aba01
           AND aba00 = bookno
        IF SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","aba_file",sr.aba01,bookno,STATUS,"","upd abaprno",0)
        END IF
 
        EXECUTE insert_prep USING sr1.*
        INITIALIZE sr1.* TO NULL
        LET l_i = 0
     END IF
     #No.FUN-7C0064  --End  
 
     #No.FUN-7C0064  --Begin
     #FINISH REPORT gglr303_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aba01,aba02,aba06')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",g_azi05
     CALL cl_prt_cs3('gglr303','gglr303',g_sql,g_str)
     #No.FUN-7C0064  --End  
     #No.FUN-B80096--mark--Begin---   
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-7C0064  --Begin
#REPORT gglr303_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#         d_aag02        LIKE aag_file.aag02,    #科目名稱
#         d_aag13        LIKE aag_file.aag13,    #FUN-6C0012
#         l_aag02        LIKE aag_file.aag02,    #FUN-6C0012
#          sr               RECORD
#                           aba01     LIKE aba_file.aba01,#傳票編號
#                           aba02     LIKE aba_file.aba02,#傳票日期
#                           aba10     LIKE aba_file.aba10,
#                           aba21     LIKE aba_file.aba21,
#                           abb02     LIKE abb_file.abb02,
#                           abb04     LIKE abb_file.abb04,#摘要
#                           aag01     LIKE aag_file.aag01,
#                           aag02     LIKE aag_file.aag02,#科目名稱
#                           aag13     LIKE aag_file.aag13,#FUN-6C0012
#                           aag07     LIKE aag_file.aag07,
#                           aag08     LIKE aag_file.aag08,
#                           abb07     LIKE abb_file.abb07,#異動金額
#                           abb24     LIKE abb_file.abb24,   #NO:7911
#                           l_pageno  LIKE type_file.num5     #NO FUN-690009   SMALLINT
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.aba01,sr.abb02
#  FORMAT
#   PAGE HEADER
#      IF g_company IS NULL OR g_company = ' '
#        THEN LET g_company = ' ' END IF
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED CLIPPED
#      PRINT
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT
#      PRINT COLUMN 40,YEAR(sr.aba02)  CLIPPED,g_x[43] CLIPPED,
#                      MONTH(sr.aba02) CLIPPED,g_x[44] CLIPPED,
#                      DAY(sr.aba02)   CLIPPED,g_x[45] CLIPPED
#      PRINT ''
#      SELECT aag02 INTO d_aag02 FROM aag_file WHERE aag01 = sr.aba10  AND aag00 = bookno  #NO.FUN-740055
#      SELECT aag13 INTO d_aag13 FROM aag_file WHERE aag01 = sr.aba10 AND aag00 = bookno   #FUN-6C0012    #NO.FUN-740055
#      #FUN-6C0012.....begin
#      IF tm.e ='Y' THEN                                                         
#         LET l_aag02 =sr.aba10 CLIPPED,' ',d_aag13                              
#      ELSE                                                                      
#         LET l_aag02 =sr.aba10 CLIPPED,' ',d_aag02                              
#      END IF                                                                    
#      PRINT COLUMN 1 ,g_x[11] CLIPPED,sr.aba10 CLIPPED,' ',l_aag02 CLIPPED,    
##     PRINT COLUMN 1 ,g_x[11] CLIPPED,sr.aba10 CLIPPED,' ',d_aag02 CLIPPED,
#      #FUN-6C0012.....end
##            COLUMN 72,g_x[12] CLIPPED,sr.aba01 CLIPPED,
#            COLUMN 67,g_x[12] CLIPPED,sr.aba01 CLIPPED,    #No.FUN-550028
#    #MOD-590097--start--
#            COLUMN 93,g_x[47],COLUMN 92,g_pageno USING "##",
#            COLUMN 96,g_x[48],COLUMN 95,sr.l_pageno USING "##",
#            COLUMN 99,g_x[49] CLIPPED
#    #MOD-590097--end--
##No.TQC-770131 -- begin -- 撐開報表寬度，修正lib-301寬度報錯
##      PRINT COLUMN 1 ,"-------------------------------------------------------------------------------------------------------------"    # No.TQC-750041
#      PRINT COLUMN 1 ,"                                                       ",
#                      "                                                      "
##No.TQC-770131 -- end --
#      PRINT COLUMN 1 ,g_x[13] CLIPPED,g_x[14] CLIPPED,
#                      g_x[15] CLIPPED
#      PRINT COLUMN 1 ,g_x[16] CLIPPED,
#            COLUMN 41,g_x[17] CLIPPED,
#            COLUMN 83,g_x[18] CLIPPED
#      PRINT COLUMN 1 ,g_x[19] CLIPPED,g_x[20] CLIPPED,g_x[21] CLIPPED
#      PRINT COLUMN 1 ,g_x[22] CLIPPED,g_x[23] CLIPPED,g_x[24] CLIPPED,
#            COLUMN 83,g_x[46],COLUMN 105,g_x[46]   #MOD-590097
#      PRINT COLUMN 1 ,g_x[25] CLIPPED,g_x[42] CLIPPED,g_x[27] CLIPPED
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.aba01
#     LET g_pageno = 1
#     SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#        #NO:7911
#        SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
#         WHERE azi01 = sr.abb24
#        #NO:7911 end
#
#        IF LINENO>20 THEN
#   #MOD-590097--start--
#        PRINT COLUMN 1,g_x[28] CLIPPED,COLUMN 83,g_x[46],
#              COLUMN 99,g_x[46]
#   #MOD-590097--end--
#        PRINT COLUMN 1,g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[33] CLIPPED
#        PRINT COLUMN 1,g_x[31] CLIPPED,COLUMN 45,g_x[32] CLIPPED
#        LET g_pageno = g_pageno + 1
#        SKIP TO TOP OF PAGE
#      END IF
#      IF LINENO<20 THEN
#   #MOD-590097--start--
#          #FUN-6C0012.....begin
#          IF tm.e ='Y' THEN                                                     
#             LET l_aag02 =sr.aag01 CLIPPED,' ',sr.aag13                         
#          ELSE                                                                  
#             LET l_aag02 =sr.aag01 CLIPPED,' ',sr.aag02                         
#          END IF
#          #FUN-6C0012.....end
#          PRINT COLUMN 1, g_x[46],sr.abb04 CLIPPED,
##               COLUMN 31,g_x[46],sr.aag01 CLIPPED,' ',sr.aag02 CLIPPED,
#                COLUMN 31,g_x[46],sr.aag01 CLIPPED,' ',l_aag02 CLIPPED, #FUN-6C0012
#                COLUMN 83,g_x[46],cl_numfor(sr.abb07,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#                COLUMN 105,g_x[46] CLIPPED;
#   #MOD-590097--end--
#          CASE
#            WHEN LINENO = 12 PRINT g_x[39] CLIPPED
#            WHEN LINENO = 14 PRINT g_x[40] CLIPPED
#            WHEN LINENO = 16 PRINT sr.aba21 CLIPPED
#            WHEN LINENO = 18 PRINT g_x[41] CLIPPED
#            OTHERWISE PRINT ' '
#          END CASE
#          PRINT COLUMN 1,g_x[25] CLIPPED,g_x[26] CLIPPED,g_x[27] CLIPPED
#        ELSE IF LINENO=20 THEN
#   #MOD-590097--start--
#          #FUN-6C0012.....begin
#          IF tm.e ='Y' THEN                                                     
#             LET l_aag02 =sr.aag01 CLIPPED,' ',sr.aag13                         
#          ELSE                                                                  
#             LET l_aag02 =sr.aag01 CLIPPED,' ',sr.aag02                         
#          END IF
#          #FUN-6C0012.....end
#          PRINT COLUMN 1, g_x[46],sr.abb04 CLIPPED,
##               COLUMN 31,g_x[46],sr.aag01 CLIPPED,' ',sr.aag02 CLIPPED,
#                COLUMN 31,g_x[46],sr.aag01 CLIPPED,' ',l_aag02 CLIPPED, #FUN-6C0012
#                COLUMN 83,g_x[46],cl_numfor(sr.abb07,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#                COLUMN 105,g_x[46]
#   #MOD-590097--end--
#          PRINT COLUMN 1,g_x[36] CLIPPED,g_x[37] CLIPPED,
#                         g_x[38] CLIPPED
#        END IF
# 
#      END IF
# 
#   AFTER GROUP OF sr.aba01
#        #NO:7911
#        SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
#         WHERE azi01 = sr.abb24
#        #NO:7911 end
#
#     IF LINENO>=11 AND LINENO<21  THEN
#       WHILE LINENO<20
#    #MOD-590097--start--
#        PRINT COLUMN 1, g_x[46],
#              COLUMN 31,g_x[46],
#              COLUMN 83,g_x[46],
#              COLUMN 105,g_x[46];
#    #MOD-590097--end--
#        CASE
#          WHEN LINENO = 12 PRINT g_x[39] CLIPPED
#          WHEN LINENO = 14 PRINT g_x[40] CLIPPED
#          WHEN LINENO = 16 PRINT sr.aba21 CLIPPED
#          WHEN LINENO = 18 PRINT g_x[41] CLIPPED
#          OTHERWISE PRINT ' '
#        END CASE
#        PRINT COLUMN 1,g_x[25] CLIPPED,g_x[26] CLIPPED,
#                       g_x[27] CLIPPED
#       END WHILE
#    #MOD-590097--start--
#        PRINT COLUMN 1, g_x[46],
#              COLUMN 31,g_x[46],
#              COLUMN 83,g_x[46],
#              COLUMN 105,g_x[46]
#    #MOD-590097--end--
#        PRINT COLUMN 1,g_x[36] CLIPPED,g_x[37] CLIPPED,
#                       g_x[38] CLIPPED
#     END IF
#     PRINT COLUMN 1, g_x[28] CLIPPED,
#           COLUMN 31,s_sayc2(GROUP SUM(sr.abb07),50) CLIPPED,
#    #MOD-590097--start--
#           COLUMN 83,g_x[46],cl_numfor(GROUP SUM(sr.abb07),18,t_azi05),   #No.CHI-6A0004
#           COLUMN 105,g_x[46]
#    #MOD-590097--end--
#     PRINT COLUMN 1,g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[33] CLIPPED
#     PRINT COLUMN 1,g_x[31] CLIPPED,COLUMN 45,g_x[32] CLIPPED
#     UPDATE aba_file SET abaprno = abaprno + 1
#                     WHERE aba01 = sr.aba01
#                       AND aba00 = bookno    #NO.FUN-740055
#     IF sqlca.sqlerrd[3]=0 THEN
# #       CALL cl_err('upd abaprno',STATUS,0)     #No.FUN-660124
#         CALL cl_err3("upd","aba_file",sr.aba01,bookno,STATUS,"","upd abaprno",0)   #No.FUN-660124   #NO.FUN-740055
#     END IF
#END REPORT
#Patch....NO.TQC-610037 <001> #
#No.FUN-7C0064  --End   
 
#No.FUN-7C0064  --Begin
FUNCTION gglr303_sjkm(p_aag01)   #追溯上級科目名稱且將其連成一體
   DEFINE p_aag01 LIKE aag_file.aag01
   DEFINE s_aag08 LIKE aag_file.aag08
   DEFINE s_aag24 LIKE aag_file.aag24
   DEFINE s_aag02 LIKE aag_file.aag02
   DEFINE s_aag13 LIKE aag_file.aag13
   DEFINE p_aag02,p_aag021    LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(100)
   DEFINE l_success,l_i       LIKE type_file.num5     #NO FUN-690009   SMALLINT
 
   LET l_success = 1
   LET l_i = 1
   WHILE l_success
      SELECT aag02,aag13,aag08,aag24 INTO s_aag02,s_aag13,s_aag08,s_aag24
        FROM aag_file
       WHERE aag01 = p_aag01
         AND aag00 = bookno
      IF SQLCA.sqlcode THEN
         LET l_success = 0
         EXIT WHILE
      END IF
      IF tm.e = 'Y' THEN LET s_aag02 = s_aag13 END IF
      IF l_i = 1 THEN
         LET p_aag02 = s_aag02
      ELSE
         IF s_aag24 = 1 THEN   #只要第一級科目名稱與自身科目名稱
            LET p_aag021 = p_aag02
            LET p_aag02 = s_aag02 CLIPPED,'-',p_aag021 CLIPPED
         END IF
      END IF
      LET l_i = l_i + 1
      IF s_aag24 = 1 OR s_aag08 = p_aag01 THEN LET l_success = 1 EXIT WHILE END IF
      LET p_aag01 = s_aag08
   END WHILE
   RETURN p_aag02   #結果
END FUNCTION
#No.FUN-7C0064  --End  
