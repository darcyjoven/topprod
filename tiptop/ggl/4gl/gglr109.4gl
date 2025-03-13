# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr109.4gl
# Descriptions...: 科目彙總表
# Modify.........: No.FUN-510007 05/01/17 By Nicola 報表架構修改
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 打印“額外科目名稱”
# Modify.........: No.FUN-740032 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-750022 07/05/09 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-780061 07/08/31 By zhoufeng 報表輸出改為Crystal Report
# Modify.........: No.MOD-860252 09/02/03 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料 
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
              wc  LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)     #Where Condiction
              bookno         LIKE aaa_file.aaa01,       #No.FUN-740032
              b_date, e_date LIKE type_file.dat,        #NO FUN-690009   DATE
              d   LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)          #選擇過帳碼
              h   LIKE type_file.chr1,       #No.MOD-860252  
              e   LIKE type_file.chr1,       #FUN-6C0012
              g   LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)          #輸入其它特殊列印條件
           END RECORD,
         g_bookno  LIKE aba_file.aba00  #帳別編號
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT  #count/index for any purpose
DEFINE   g_sql           STRING                     #No.FUN-780061
DEFINE   g_str           STRING                     #No.FUN-780061
DEFINE   l_table         STRING                     #No.FUN-780061
 
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
 
   #No.FUN-780061 --start--
   LET g_sql="aag08.aag_file.aag08,aag02.aag_file.aag02,aag13.aag_file.aag13,",
             "abb06.abb_file.abb06,abb07.abb_file.abb07"
   LET l_table = cl_prt_temptable('gglr109',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780061 --end--
 
   LET g_bookno=ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   #No.FUN-740032  --Begin
   LET tm.bookno = ARG_VAL(9)
   LET tm.b_date = ARG_VAL(10)   #TQC-610056
   LET tm.e_date = ARG_VAL(11)   #TQC-610056
   LET tm.d  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-740032  --End  
 
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
      LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
   END IF
 
   #No.FUN-740032  --Begin
   IF cl_null(tm.bookno) THEN LET tm.bookno=g_aza.aza81 END IF
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno  
   #No.FUN-740032  --End  
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF     #使用本國幣別
 
  #SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03  #No.CHI-6A0004
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660124
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglr109_tm()
   ELSE
      CALL gglr109()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD

END MAIN
 
FUNCTION gglr109_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          l_cmd         LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW gglr109_w AT p_row,p_col
     WITH FORM "ggl/42f/gglr109"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bookno= g_aza.aza81  #FUN-B20010
   LET tm.d = '3'
   LET tm.h = 'Y'  #No.MOD-860252
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.g = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      #No.FUN-B20010  --Begin
      DIALOG ATTRIBUTE(unbuffered)
      INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL r109_bookno(tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               END IF
            END IF

      END INPUT 
      #No.FUN-B20010  --End
      
      CONSTRUCT BY NAME tm.wc ON abb03
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark Begin                          
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
      END CONSTRUCT
#No.FUN-B20010  --Mark Begin 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW gglr109_w
#         EXIT PROGRAM
#      END IF
# 
#      INPUT BY NAME tm.bookno,tm.b_date,tm.e_date,tm.d,tm.h,tm.e,tm.g WITHOUT DEFAULTS #FUN-6C0012  #No.FUN-740032 #No.MOD-860252 add tm.h #FUN-B20010 mark
#No.FUN-B20010  --Mark End     
      INPUT BY NAME tm.b_date,tm.e_date,tm.d,tm.h,tm.e,tm.g ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20010 #去掉tm.bookno
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
        
        #No.FUN-B20010  --Mark Begin
        #No.FUN-740032  --Begin
        #AFTER FIELD bookno
        #   IF NOT cl_null(tm.bookno) THEN
        #      CALL r109_bookno(tm.bookno)
        #      IF NOT cl_null(g_errno) THEN
        #         CALL cl_err(tm.bookno,g_errno,0)
        #         LET tm.bookno = g_aza.aza81
        #         DISPLAY BY NAME tm.bookno
        #         NEXT FIELD bookno
        #      END IF
        #   END IF
        #No.FUN-740032  --End 
        #No.FUN-B20010  --Mark End
 
         AFTER FIELD d
            IF tm.d NOT MATCHES "[123]" THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD g
            IF tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
            END IF
 
            IF tm.g = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#No.FUN-B20010  --Mark Begin 
        #No.FUN-740032  --Begin
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(bookno) 
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_aaa"
#                 LET g_qryparam.default1 = tm.bookno
#                 CALL cl_create_qry() RETURNING tm.bookno
#                 DISPLAY BY NAME tm.bookno
#                 NEXT FIELD bookno
#           END CASE
#        #No.FUN-740032  --End  
#    
#        ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
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
                WHEN INFIELD(abb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aag'
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb03
                  NEXT FIELD abb03
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
   #No.FUN-B20010  --End
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglr109_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='gglr109'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr109','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.bookno CLIPPED,"'",   #No.FUN-740032
                        " '",tm.b_date CLIPPED,"'",   #TQC-610056
                        " '",tm.e_date CLIPPED,"'",   #TQC-610056
                        " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gglr109',g_time,l_cmd)  # Execute cmd at later time
         END IF
 
         CLOSE WINDOW gglr109_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL gglr109()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW gglr109_w
 
END FUNCTION
 
#No.FUN-740032  --Begin
FUNCTION r109_bookno(p_bookno)
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
#No.FUN-740032  --End  
 
FUNCTION gglr109()
   DEFINE l_name        LIKE type_file.chr20,      #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0097
          l_sql         LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr         LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)
          l_order       ARRAY[5] OF LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)   #排列順序
          l_i           LIKE type_file.num5,       #NO FUN-690009   SMALLINT
          sr            RECORD
                           aag08     LIKE abb_file.abb03,#統制科目
                           aag021    LIKE aag_file.aag02,#統制科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           abb03     LIKE abb_file.abb03,#科目
                           aag022    LIKE aag_file.aag02,#科目名稱
                           abb06     LIKE abb_file.abb06,
                           abb07     LIKE abb_file.abb07
                        END RECORD
 
     CALL cl_del_data(l_table)                      #No.FUN-780061
 
   #No.FUN-B80096--mark--Begin--- 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   #No.FUN-740032 --Begin
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno  
      AND aaf02 = g_rlang
   #No.FUN-740032 --End  
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT aag1.aag08, aag2.aag02, aag2.aag13, aag1.aag01, aag1.aag02,",  #FUN-6C0012
               "       abb06, abb07",
               " FROM aba_file, abb_file, aag_file aag1, aag_file aag2",
               " WHERE aba00 = '",tm.bookno,"'", #若為空白使用預設帳別  #No.FUN-740032
               "   AND abb00 = aag1.aag00",  #No.FUN-740032
               "   AND aba00 = abb00",
               "   AND aba01 = abb01",
               "   AND abb03 = aag1.aag01",
               "   AND aag1.aag08 = aag2.aag01",
               "   AND aag1.aag00 = aag2.aag00",  #No.FUN-740032
               "   AND abaacti = 'Y'",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND aba02 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
               "   AND ",tm.wc
   #No.MOD-860252--begin--
   IF tm.h = 'Y' THEN
      LET l_sql = l_sql," AND aag1.aag09 = aag2.aag09 AND aag1.aag09 ='Y'  "
   END IF 
   #No.MOD-860252---end---
   CASE
      WHEN tm.d = '1'
         LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
      WHEN tm.d = '2'
         LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   END CASE
 
   PREPARE gglr109_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE gglr109_curs1 CURSOR FOR gglr109_prepare1
 
   #No.FUN-780061 --mark--
#   CALL cl_outnam('gglr109') RETURNING l_name
#
#   #FUN-6C0012.....begin
#   IF tm.e = 'Y' THEN                                                           
#      LET g_zaa[32].zaa06= 'Y'                                                  
#      LET g_zaa[35].zaa06= 'N'                                                  
#   ELSE                                                                         
#      LET g_zaa[32].zaa06= 'N'                                                  
#      LET g_zaa[35].zaa06= 'Y'                                                  
#   END IF                                                                       
#   CALL cl_prt_pos_len()
#   #FUN-6C0012.....end
#   START REPORT gglr109_rep TO l_name
#
#   LET g_pageno = 0
#   LET g_cnt    = 1
   #No.FUN-780061 --end--
 
   FOREACH gglr109_curs1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
#      OUTPUT TO REPORT gglr109_rep(sr.*)       #No.FUN-780061
      #No.FUN-780061 --add--
      IF sr.abb07 IS NULL THEN
         LET sr.abb07 = 0
       END IF
      EXECUTE insert_prep USING
                          sr.aag08,sr.aag021,sr.aag13,sr.abb06,sr.abb07
      #No.FUN-780061 --end--
   END FOREACH
 
#   FINISH REPORT gglr109_rep                   #No.FUN-780061
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-780061
   #No.FUN-780061 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'abb03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.b_date,";",tm.e_date,";",
               tm.e,";",g_azi04,";",g_azi05
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('gglr109','gglr109',l_sql,g_str)
   #No.FUN-780061
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
#No.FUN-780061 --start-- mark
{REPORT gglr109_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)
          amt1,amt2     LIKE abb_file.abb07,
          sr            RECORD
                           aag08     LIKE abb_file.abb03,#統制科目
                           aag021    LIKE aag_file.aag02,#統制科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           abb03     LIKE abb_file.abb03,#科目
                           aag022    LIKE aag_file.aag02,#科目名稱
                           abb06     LIKE abb_file.abb06,
                           abb07     LIKE abb_file.abb07
                        END RECORD
   DEFINE g_head1       STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aag08
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total           # No.TQC-750022
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6A0094
         LET g_head1 = g_x[9] CLIPPED,tm.b_date,'-',tm.e_date
         PRINT g_head1
         PRINT g_head CLIPPED,pageno_total           # No.TQC-750022
         PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34]          #FUN-6C0012
         PRINT g_x[31],g_x[32],g_x[35],g_x[33],g_x[34]  #FUN-6C0012 
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      AFTER GROUP OF sr.aag08
         LET amt1 = GROUP SUM(sr.abb07) WHERE sr.abb06='1'
         LET amt2 = GROUP SUM(sr.abb07) WHERE sr.abb06='2'
 
         IF amt1 IS NULL THEN
            LET amt1 = 0
         END IF
 
         IF amt2 IS NULL THEN
            LET amt2 = 0
         END IF
 
         PRINT COLUMN g_c[31],sr.aag08,
               COLUMN g_c[32],sr.aag021,
               COLUMN g_c[35],sr.aag13,   #FUN-6C0012
               COLUMN g_c[33],cl_numfor(amt1,33,g_azi04),
               COLUMN g_c[34],cl_numfor(amt2,34,g_azi04)
 
      ON LAST ROW
         LET amt1 = SUM(sr.abb07) WHERE sr.abb06 = '1'
         LET amt2 = SUM(sr.abb07) WHERE sr.abb06 = '2'
 
         IF amt1 IS NULL THEN
            LET amt1 = 0
         END IF
 
         IF amt2 IS NULL THEN
            LET amt2 = 0
         END IF
#No.TQC-6A0094 -- begin --
#         PRINT COLUMN g_c[33],g_dash2[1,g_w[33]+g_w[34]+1]
         PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
               COLUMN g_c[34],g_dash2[1,g_w[34]]
#No.TQC-6A0094 -- end --
         PRINT COLUMN g_c[32],g_x[10] CLIPPED,
               COLUMN g_c[35],g_x[10] CLIPPED,  #FUN-6C0012
               COLUMN g_c[33],cl_numfor(amt1,33,g_azi05),
               COLUMN g_c[34],cl_numfor(amt2,34,g_azi05)
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
#No.TQC-6A0094
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[34],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[7] CLIPPED
#No.TQC-6A0094
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#No.TQC-6A0094
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[34],g_x[6] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
#No.TQC-6A0094
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-780061 --end--
#Patch....NO.TQC-610037 <001> #
