# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr308.4gl
# Descriptions...: 記帳憑証列印-套表
# Date & Author..: 02/08/26 By leagh
# VTCP 列印設定..: 1*15*24, 25 lines
# 立信帳冊名稱...: TW101 外幣記帳憑証
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-510007 05/03/04 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加打印額外名稱
# Modify.........: No.TQC-740093 07/04/16 By hongmei 會計科目加帳套
# Modify.........: No.FUN-770061 08/03/05 By baofei 報表改為CR輸出 
# Modify.........: No.MOD-860252 09/02/17 By chenl 增加打印時是否打印貨幣性科目或全部科目的選擇
# Modify.........: No.TQC-940062 09/05/07 By mike 排序字段重復       
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C10039 12/01/13 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-C20064 12/02/09 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片还原
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	       	     #Print condition RECORD
           wc  LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(400)    #Where Condiction
           
           t   LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)      #排列順序
           u   LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)      #排列順序
           w   LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)      #是否列印摘要
           n   LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)      #是否列印外幣金額
           e   LIKE type_file.chr1,       #FUN-6C0012
           h   LIKE type_file.chr1,       #MOD-860252
           m   LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)      #是否輸入其它特殊列印條件
       bookno  LIKE aba_file.aba00        #帳別編號 #No.TQC-740093
           END RECORD,
#      g_bookno  LIKE aba_file.aba00,#帳別編號  #No.TQC-740093
       g_azi02   LIKE azi_file.azi02
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT   #count/index for any purpose
   #No.FUN-770061---Begin                                                                                                           
   DEFINE g_sql     STRING                                                                                                          
   DEFINE g_str     STRING                                                                                                          
   DEFINE l_table  STRING                                                                                                           
   DEFINE l_table1  STRING                                                                                                          
   #No.FUN-770061---End 
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
     #No.FUN-770061---Begin                                                                                                          
   LET g_sql= " aba01.aba_file.aba01,",                                                                                             
              " aba21.aba_file.aba21,",                                                                                             
              " abb02.abb_file.abb02,",                                                                                             
              " abb04.abb_file.abb04,",                                                                                             
              " abb07f.abb_file.abb07f,",                                                                                           
              " abb24.abb_file.abb24,",                                                                                             
              " abb25.abb_file.abb25,",                                                                                             
              " aac02.aac_file.aac02,",                                                                                             
              " l_aag01_l.aag_file.aag01,",                                                                                         
              " l_aag01_r.aag_file.aag01,",                                                                                         
              " l_aag02_l.aag_file.aag01,",                                                                                         
              " l_aag02_r.aag_file.aag01,",                                                                                         
              " l_aag13_l.aag_file.aag01,",                                                                                         
              " l_aag13_r.aag_file.aag01,",                                                                                         
              " l_abb07_l.abb_file.abb07,",                                                                                         
              " l_abb07_r.abb_file.abb07,",                                                                                         
              " azi07.azi_file.azi07,",                                                                                             
              " t_azi04.azi_file.azi04,",                                                                                           
              " t_azi05.azi_file.azi05"
#             , "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039  #MOD-C20064 Mark TQC-C10039
#              "sign_show.type_file.chr1,sign_str.type_file.chr1000"    #是否顯示簽核資料(Y/N)  #TQC-C10039  #MOD-C20064 Mark TQC-C10039                                                                                           
   LET l_table = cl_prt_temptable('gglr308',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF      
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                                       
#                 "        ?,?,?,?, ?,?,?,? )"     #TQC-C10039 add 4?    #MOD-C20064 Mark TQC-C10039
                 "        ?,?,?,? )"                                                                           
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                           
     END IF                                                                                                                         
   #No.FUN-770061---End   
   LET g_trace = 'N'				# default trace off
#  LET g_bookno= ARG_VAL(1)     #No.TQC-740093
   LET tm.bookno= ARG_VAL(1)    #No.TQC-740093
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.wc   = ARG_VAL(8)
LET tm.t    = ARG_VAL(9)
LET tm.u    = ARG_VAL(10)
LET tm.w    = ARG_VAL(11)
   LET tm.n    = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.TQC-740093 ---Begin
#  IF g_bookno = ' ' OR g_bookno IS NULL THEN
#     LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
#  END IF
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN                                          
      LET tm.bookno = g_aza.aza81  #帳別若為空白則使用預設帳別                                 
   END IF
   #No.TQC-740093 ---Endi

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglr308_tm()	        	# Input print condition
      ELSE CALL gglr308()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION gglr308_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_cmd		LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
 
#  CALL s_dsmark(g_bookno)   #No.TQC-740093
   CALL s_dsmark(tm.bookno)  #No.TQC-740093
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW gglr308_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr308"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#  CALL s_shwact(3,2,g_bookno)    #No.TQC-740093
   CALL s_shwact(3,2,tm.bookno)   #No.TQC-740093
 
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL			# Default condition
   LET tm.t = '3'
   LET tm.u = '3'
   LET tm.w = '3'
   LET tm.n = 'N'
   LET tm.e = 'N' #FUN-6C0012
   LET tm.h = 'Y' #MOD-860252
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
      CLOSE WINDOW gglr308_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bookno,tm.t,tm.u,tm.w,tm.n,tm.e,tm.h,tm.m WITHOUT DEFAULTS  #FUn-6C0012 #No.TQC-740093 #MOD-860252 add tm.h
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
       AFTER FIELD n
          IF tm.n NOT MATCHES "[YN]" THEN NEXT FIELD n END IF
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
       
       #No.TQC-740093 ---Begin
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
       #No.TQC-740093 ---End
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW gglr308_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglr308'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr308','9031',1)   
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
		#        " '",g_bookno CLIPPED,"'",       #No.TQC-740093
		         " '",tm.bookno CLIPPED,"'",      #No.TQC-740093
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                      " '",tm.t     CLIPPED,"'",
                      " '",tm.u     CLIPPED,"'",
                      " '",tm.w     CLIPPED,"'",
                      " '",tm.n     CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gglr308',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglr308_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglr308()
   ERROR ""
END WHILE
   CLOSE WINDOW gglr308_w
END FUNCTION
 
FUNCTION gglr308()
   DEFINE l_name	LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0097
          l_sql 	LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_za05	LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(40)   #標題內容
          l_i           LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_temp1       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_temp2       LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_aag08       LIKE aag_file.aag08,
          l_str         LIKE type_file.chr1000,    #No.FUN-770061                                                                   
          l_str1        LIKE type_file.chr1000,    #No.FUN-770061     
          n_aag08       LIKE aag_file.aag08,
       sr            RECORD
                        aba01     LIKE aba_file.aba01,   #傳票編號
                        aba02     LIKE aba_file.aba02,   #傳票日期
                        aba10     LIKE aba_file.aba10,
                        aba21     LIKE aba_file.aba21,   #附件張數
                        abb02     LIKE abb_file.abb02,   #項次
                        abb04     LIKE abb_file.abb04,   #摘要
                        abb06     LIKE abb_file.abb06,
                        abb07     LIKE abb_file.abb07,   #異動金額
                        abb07f    LIKE abb_file.abb07f,
                        abb24     LIKE abb_file.abb24,
                        abb25     LIKE abb_file.abb25,
                        aag01     LIKE aag_file.aag01,
                        aag02     LIKE aag_file.aag02,   #科目名稱
                        aag13     LIKE aag_file.aag13,   #FUN-6C0012
                        aag07     LIKE aag_file.aag07,
                        aag08     LIKE aag_file.aag08,
                        azi07     LIKE azi_file.azi07,
                        aac02     LIKE aac_file.aac02,
                        l_pageno  LIKE type_file.num5,       #NO FUN-690009   SMALLINT
                        l_aag01_l LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(24)
                        l_aag01_r LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(24)
                        l_aag02_l LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(30)
                        l_aag02_r LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(30)
                        l_aag13_l LIKE aag_file.aag01,       #FUN-6C0012
                        l_aag13_r LIKE aag_file.aag01,       #FUN-6C0012
                        l_abb07_l LIKE abb_file.abb07,       #NO FUN-690009   DEC(20,6)
                        l_abb07_r LIKE abb_file.abb07        #NO FUN-690009   DEC(20,6)
                        END RECORD

#       DEFINE l_img_blob     LIKE type_file.blob    #TQC-C10039   #MOD-C20064 Mark TQC-C10039
       CALL cl_del_data(l_table)                  #No.FUN-770061
#       LOCATE l_img_blob IN MEMORY    #TQC-C10039  #MOD-C20064 Mark TQC-C10039
      
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----

#No.TQC-740093 ---Begin
#    SELECT aaf03 INTO g_company FROM aaf_file
#     WHERE aaf01 = g_bookno AND aaf02 = g_rlang
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.bookno AND aaf02 = g_rlang
#No.TQC-740093 ---End
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr308'
    #TQC-650055...............begin
    #IF g_len = 0 OR g_len IS NULL THEN
    #   IF tm.n = 'N' THEN LET g_len = 122 ELSE LET g_len = 140 END IF
    #END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #TQC-650055...............end
     #使用預設帳別之幣別
#    SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno          #No.TQC-740093
     SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno         #No.TQC-740093
     IF SQLCA.sqlcode THEN 
 #        CALL cl_err('',SQLCA.sqlcode,0)     #No.FUN-660124
          CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124 #No.TQC-740093
     END IF
     SELECT azi02,azi04,azi05 INTO g_azi02,t_azi04,t_azi05 FROM azi_file   #No.CHI-6A0004
      WHERE azi01 = g_aaa03
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc CLIPPED," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc CLIPPED," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc CLIPPED," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
  LET l_sql = "SELECT aba01,aba02,aba10,aba21,abb02,abb04,abb06,",
                 "       abb07,abb07f,abb24,abb25,aag01,aag02,aag13,aag07,aag08,",  #FUN-6C0012
                 "       azi07,aac02,0,'','','','',0,0",
                 "  FROM aba_file,abb_file,aac_file,aag_file,OUTER azi_file",
                 " WHERE aba00 = abb00",
                 "   AND aba01 = abb01",
                 "   AND abb00 = aag00 AND aag00 = '",tm.bookno,"'",    #No.TQC-740093
                 "   AND abb03 = aag01",
#                "   AND aba01[1,3] = aac01",
                 "   AND aba01 like ltrim(rtrim(aac01)) || '-%'",  #No.FUN-550028
                 "   AND aac03 = '0'",
                 "   AND aag07 IN ('2','3')",
                 "   AND aba19 <> 'X' ",  #CHI-C80041
                 "   AND azi_file.azi01 = abb_file.abb24 ",
                 "   AND ",tm.wc CLIPPED
 
     IF tm.n = 'Y' THEN LET l_sql = l_sql CLIPPED," AND aac13 = 'Y'" END IF
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
     #LET l_sql = l_sql CLIPPED," ORDER BY aba21,abb07f,abb24,abb25 DESC,aba01,aba21" #TQC-940062 mark                                                     
     LET l_sql = l_sql CLIPPED," ORDER BY 4,9,10,11 DESC,1" #TQC-940062 add     
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE gglr308_prepare1 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM 
     END IF
     DECLARE gglr308_curs1 CURSOR FOR gglr308_prepare1
#No.FUN-770061---Begin
#     CALL cl_outnam('gglr308') RETURNING l_name
#    #TQC-650055...............begin
#     IF g_len = 0 OR g_len IS NULL THEN
#       #IF tm.n = 'N' THEN LET g_len = 122 ELSE LET g_len = 140 END IF
#        IF tm.n = 'N' THEN LET g_len = 122 ELSE LET g_len = 145 END IF
#     END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    #TQC-650055...............end
#     START REPORT gglr308_rep TO l_name
 
#     LET g_pageno = 0
#No.FUN-770061---End
     FOREACH gglr308_curs1 INTO sr.*
       IF sr.abb06 = '1' THEN
          LET sr.l_abb07_l = sr.abb07
          LET sr.l_abb07_r = null
       ELSE
          LET sr.l_abb07_l = null
          LET sr.l_abb07_r = sr.abb07
       END IF
       LET sr.l_aag02_r = sr.aag02
       LET sr.l_aag13_r = sr.aag13  #FUN-6C0012
       LET sr.l_aag01_r = sr.aag01
       LET sr.l_aag02_l = sr.aag02
       LET sr.l_aag13_l = sr.aag13  #FUN-6C0012
       LET sr.l_aag01_l = sr.aag01
       IF sr.aag07 = '2' THEN
          LET l_aag08 = sr.aag01
          LET n_aag08 = sr.aag01
          SELECT aag08 INTO n_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = tm.bookno   #No.TQC-740093
          WHILE l_aag08 <> n_aag08
             LET l_aag08 = n_aag08
             SELECT aag08 INTO n_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = tm.bookno   #No.TQC-740093
             IF SQLCA.sqlcode THEN EXIT WHILE END IF
          END WHILE
          SELECT aag02 INTO sr.l_aag02_l FROM aag_file WHERE aag01 = n_aag08 AND aag00 = tm.bookno   #No.TQC-740093
          IF NOT cl_null(n_aag08) THEN
             LET sr.l_aag01_l = n_aag08
          END IF
          SELECT aag13 INTO sr.l_aag13_l FROM aag_file WHERE aag01 = n_aag08 AND aag00 = tm.bookno   #No.TQC-740093 #FUN-6C0012
       END IF
       IF sr.aag07 = '3' THEN
          LET sr.l_aag01_l = ''
          LET sr.l_aag02_l = ''
          LET sr.l_aag13_l = ''  #FUN-6C0012
       END IF
       IF tm.n = 'N' THEN
          SELECT aba01,COUNT(*) INTO sr.aba01,sr.l_pageno
            FROM aba_file,abb_file
           WHERE aba00 = abb00 AND aba01 = abb01 AND aba01 = sr.aba01
          GROUP BY aba01 ORDER BY aba01
       ELSE
          SELECT aba01,COUNT(*) INTO sr.aba01,sr.l_pageno
            FROM aba_file,abb_file
           WHERE aba00 = abb00 AND aba01 = abb01 AND aba01 = sr.aba01
             AND abb24 <> g_aaa03
          GROUP BY aba01 ORDER BY aba01
       END IF
       LET l_temp1 = sr.l_pageno/5
       LET l_temp2 = sr.l_pageno MOD 5
       IF l_temp2 > 0
          THEN LET sr.l_pageno = l_temp1 + 1
          ELSE LET sr.l_pageno = l_temp1
       END IF
#No.FUN-770061---Begin                                                                                                              
        EXECUTE insert_prep USING sr.aba01,sr.aba21,sr.abb02,sr.abb04,sr.abb07f,                                                    
                                  sr.abb24,sr.abb25,sr.aac02,sr.l_aag01_l,sr.l_aag01_r,                                             
                                  sr.l_aag02_l,sr.l_aag02_r,sr.l_aag13_l,sr.l_aag13_r,                                              
                                  sr.l_abb07_l,sr.l_abb07_r,sr.azi07,t_azi04,t_azi05
#                                  , "",l_img_blob,"N",""                                   #TQC-C10039  #MOD-C20064 Mark TQC-C10039                                              
#       OUTPUT TO REPORT gglr308_rep(sr.*)                                                                                          
#No.FUN-770061---End
     END FOREACH
#No.FUN-770061---Begin
#     FINISH REPORT gglr308_rep
         IF g_zz05 = 'Y' THEN                                                                                                       
         CALL cl_wcchp(tm.wc,'aba01,aba02,aba06')                                                                                   
              RETURNING tm.wc                                                                                                       
                                                                                                                                    
          END IF                                                                                                                    
      LET l_str = sr.aba01[g_no_sp,g_no_ep] CLIPPED,                                                                                
           '-',g_pageno USING "&&&&",'/',sr.l_pageno USING "&&&&"                                                                   
      LET l_str1 = YEAR(sr.aba02) USING "###&" ,'    ',                                                                             
                   MONTH(sr.aba02) USING "#&",'    ',DAY(sr.aba02) USING "#&"                                                       
      LET g_str=tm.wc ,";",tm.n,";",tm.e,";",g_azi02,";",g_aaz.aaz64,";",l_str,";",l_str1                                           
                                                                                                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED       
#   LET g_cr_table = l_table                 #主報表的temp table名稱   #TQC-C100399  #MOD-C20064 Mark TQC-C10039
#   LET g_cr_apr_key_f = "aba01"       #報表主鍵欄位名稱  #TQC-C10039   #MOD-C20064 Mark TQC-C10039                                                        
   CALL cl_prt_cs3('gglr308','gglr308',l_sql,g_str)  
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-770061---End 
   #No.FUN-B80096--mark--Begin---    
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
#No.FUN-770061---Begin    
#REPORT gglr308_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)
#         l_jump         LIKE type_file.num5,       #NO FUN-690009   SMALLINT
#      sr             RECORD
#                        aba01     LIKE aba_file.aba01,   #傳票編號
#                        aba02     LIKE aba_file.aba02,   #傳票日期
#                        aba10     LIKE aba_file.aba10,
#                        aba21     LIKE aba_file.aba21,   #附件張數
#                        abb02     LIKE abb_file.abb02,   #項次
#                        abb04     LIKE abb_file.abb04,   #摘要
#                        abb06     LIKE abb_file.abb06,
#                        abb07     LIKE abb_file.abb07,   #異動金額
#                        abb07f    LIKE abb_file.abb07f,
#                        abb24     LIKE abb_file.abb24,
#                        abb25     LIKE abb_file.abb25,
#                        aag01     LIKE aag_file.aag01,
#                        aag02     LIKE aag_file.aag02,   #科目名稱
#                        aag13     LIKE aag_file.aag13,   #FUN-6C0012
#                        aag07     LIKE aag_file.aag07,
#                        aag08     LIKE aag_file.aag08,
#                        azi07     LIKE azi_file.azi07,
#                        aac02     LIKE aac_file.aac02,
#                        l_pageno  LIKE type_file.num5,       #NO FUN-690009   SMALLINT                                              
#                        l_aag01_l LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(24)                                              
#                       l_aag01_r LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(24)                                              
#                       l_aag02_l LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(30)                                              
#                       l_aag02_r LIKE aag_file.aag01,       #NO FUN-690009   VARCHAR(30)                                              
#                       l_aag13_l LIKE aag_file.aag01,       #FUN-6C0012
#                       l_aag13_r LIKE aag_file.aag01,       #FUN-6C0012
#                       l_abb07_l LIKE abb_file.abb07,       #NO FUN-690009   DEC(20,6)                                             
#                       l_abb07_r LIKE abb_file.abb07        #NO FUN-690009   DEC(20,6)
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# # VTCP printing config : 1 *  15 * 24  , 25 lines
# ORDER BY sr.aba01,sr.abb02
# FORMAT
#  PAGE HEADER
#     SKIP 2 LINE
#     PRINT (g_len-FGL_WIDTH(sr.aac02 CLIPPED)-10)/2 SPACES,sr.aac02 #LINE 3
#     PRINT COLUMN (g_len-28),g_azi02                             #LINE NO 4
#     PRINT (g_len -20)/2 SPACES,                                 #LINE NO 5
#           YEAR(sr.aba02) USING "###&" ,'    ',
#           MONTH(sr.aba02) USING "#&",'    ',DAY(sr.aba02) USING "#&"
#     LET g_pageno = g_pageno + 1
#      PRINT COLUMN 01,'[',g_aaz.aaz64 CLIPPED,']',g_company CLIPPED; #LINE NO 6
##      PRINT COLUMN 120,sr.aba01[5,12] CLIPPED,                       #LINE NO 6
#     PRINT COLUMN 120,sr.aba01[g_no_sp,g_no_ep] CLIPPED,      #No.FUN-550028
#           '-',g_pageno USING "&&&&",'/',sr.l_pageno USING "&&&&"
#     SKIP 2 LINE
#     LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.aba01
#     SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#     IF tm.n = 'N' THEN
#        IF LINENO>=18 THEN SKIP TO TOP OF PAGE END IF
#        IF LINENO<18 THEN                        #LINE NO 10
#           PRINT COLUMN 5,sr.abb04 CLIPPED,
#                 COLUMN 37, sr.l_aag01_l CLIPPED,
#                 COLUMN 51, sr.l_aag01_r CLIPPED,
#                 COLUMN 104,cl_numfor(sr.l_abb07_l,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#                 COLUMN 122,cl_numfor(sr.l_abb07_r,18,t_azi04) CLIPPED;  #No.CHI-6A0004
#           IF LINENO = 13 THEN
#              PRINT COLUMN 138,sr.aba21 CLIPPED  
#              ELSE PRINT ' '
#           END IF
#           #FUN-6C0012.....begin
#           IF tm.e = 'Y' THEN
#              PRINT COLUMN 37,sr.l_aag13_l CLIPPED,
#                    COLUMN 51,sr.l_aag13_r CLIPPED
#           ELSE
#           #FUN-6C0012.....end
#              PRINT COLUMN 37,sr.l_aag02_l CLIPPED,
#                    COLUMN 51,sr.l_aag02_r CLIPPED
#           END IF  #FUN-6C0012
#        END IF
#     ELSE
#        #NO:7911
#        SELECT azi02,azi04,azi05 INTO g_azi02,t_azi04,t_azi05 FROM azi_file     #No.CHI-6A0004
#         WHERE azi01 = sr.abb24
#        #NO:7911 end
#        IF LINENO>=18 THEN SKIP TO TOP OF PAGE END IF
#        IF LINENO<18 THEN
#           PRINT COLUMN 5,sr.abb04 CLIPPED,
#                 COLUMN 37,sr.l_aag01_l CLIPPED,
#                 COLUMN 51,sr.l_aag01_r CLIPPED,
#                 COLUMN 75,cl_numfor(sr.abb07f,18,t_azi04) CLIPPED,    #No.CHI-6A0004
#                 COLUMN 86,cl_numfor(sr.abb25,10,sr.azi07) CLIPPED,
#                 COLUMN 104,cl_numfor(sr.l_abb07_l,18,t_azi04) CLIPPED,  #No.CHI-6A0004
#                 COLUMN 122,cl_numfor(sr.l_abb07_r,18,t_azi04) CLIPPED;  #No.CHI-6A0004
#           IF LINENO = 13 THEN
#              PRINT COLUMN 138,sr.aba21 CLIPPED  
#              ELSE PRINT ' '
#           END IF
#           #FUN-6C0012.....begin
#           IF tm.e = 'Y' THEN
#              PRINT COLUMN 37,sr.l_aag13_l CLIPPED,                            
#                    COLUMN 51,sr.l_aag13_r CLIPPED,                            
#                    COLUMN 77,sr.abb24
#           ELSE
#           #FUN-6C0012.....end
#              PRINT COLUMN 37,sr.l_aag02_l CLIPPED,
#                    COLUMN 51,sr.l_aag02_r CLIPPED,
#                    COLUMN 77,sr.abb24
#           END IF  #FUN-6C0012
#        END IF
#     END IF
#
#   AFTER GROUP OF sr.aba01
#     IF tm.n = 'N' THEN
#        IF LINENO>10 AND LINENO<18  THEN
#           WHILE LINENO<18
#              IF LINENO = 13 THEN
#                 PRINT COLUMN 138,sr.aba21 CLIPPED;  
#                 ELSE PRINT ' ';
#              END IF
#              PRINT ''
#           END WHILE
#        END IF
#        PRINT COLUMN 46,s_sayc2(GROUP SUM(sr.l_abb07_l),50) CLIPPED; #LINE 20
#        IF cl_numfor(GROUP SUM(sr.l_abb07_l),18,t_azi05) = 0                      #No.CHI-6A0004
#           THEN PRINT COLUMN 104,'0.00' CLIPPED;  #FUN-6C0012 
#           ELSE PRINT COLUMN 104,cl_numfor(GROUP SUM(sr.l_abb07_l),18,t_azi05) CLIPPED;   #No.CHI-6A0004 #FUN-6C0012
#        END IF
#        IF cl_numfor(GROUP SUM(sr.l_abb07_r),18,t_azi05) = 0                      #No.CHI-6A0004
#           THEN PRINT COLUMN 122,'0.00' CLIPPED   #FUN-6C0012  
#           ELSE PRINT COLUMN 122,cl_numfor(GROUP SUM(sr.l_abb07_r),18,t_azi05) CLIPPED   #No.CHI-6A0004  #FUN-6C0012
#        END IF
#     ELSE
#        IF LINENO>10 AND LINENO<18  THEN
#           WHILE LINENO<18
#              IF LINENO = 13 THEN
#                 PRINT COLUMN 138,sr.aba21 CLIPPED;
#                 ELSE PRINT ' ';
#              END IF
#              PRINT ''
#           END WHILE
#        END IF
#        PRINT COLUMN 46,s_sayc2(GROUP SUM(sr.l_abb07_l),50) CLIPPED; #LINE 20
#        IF cl_numfor(GROUP SUM(sr.l_abb07_l),18,t_azi05) = 0   #No.CHI-6A0004
#           THEN PRINT COLUMN 104,'0.00' CLIPPED;  #FUN-6C0012   
#           ELSE PRINT COLUMN 104,cl_numfor(GROUP SUM(sr.l_abb07_l),18,t_azi05) CLIPPED;   #No.CHI-6A0004  #FUN-6C0012
#        END IF
#        IF cl_numfor(GROUP SUM(sr.l_abb07_r),18,t_azi05) = 0     #No.CHI-6A0004
#           THEN PRINT COLUMN 122,'0.00' CLIPPED   #FUN-6C0012
#           ELSE PRINT COLUMN 122,cl_numfor(GROUP SUM(sr.l_abb07_r),18,t_azi05) CLIPPED    #No.CHI-6A0004  #FUN-6C0012
#        END IF
#    END IF
#    UPDATE aba_file SET abaprno = abaprno + 1
#     WHERE aba01 = sr.aba01 AND aba00 = tm.bookno   #No.TQC-740093
#    IF SQLCA.SQLERRD[3]=0 THEN
##       CALL cl_err('upd abaprno',STATUS,0)   #No.FUN-660124
#       CALL cl_err3("upd","aba_file",sr.aba01,tm.bookno,STATUS,"","upd abaprno",0)   #No.FUN-660124  #No.TQC-740093
#    END IF
#    LET g_pageno = 0
# END REPORT
 #Patch....NO.TQC-610037 <001> #
#No.FUN-770061---End    
