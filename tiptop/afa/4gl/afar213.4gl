# Prog. Version..: '5.30.06-13.03.28(00006)'     #
#
# Pattern name...: afar213.4gl
# Desc/riptions...: 固定資產報廢明細表
# Date & Author..: 96/06/10 By WUPN
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-FUN-510035 05/03/05 By pengu 修改報表單價、金額欄位寬度
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
#
# Modify.........: NO.FUN-550034 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-7A0036 07/10/31 By lutingting 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C10043 12/02/06 By pauline 增加"列印項目"1.財簽、2.財簽二 
# Modify.........: No:CHI-C60010 12/06/12 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:MOD-D10257 13/01/30 By Polly 調整分頁tm.t參數的傳遞

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010  --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
 
DEFINE tm  RECORD                                # Print condition RECORD
              wc    STRING,                      # Where condition
              s     LIKE type_file.chr3,         # Order by sequence            #No.FUN-680070 VARCHAR(3)
              t     LIKE type_file.chr3,         # Eject sw                     #No.FUN-680070 VARCHAR(3)
              c     LIKE type_file.chr3,         # print gkf_file detail(Y/N)   #No.FUN-680070 VARCHAR(3)
              a     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              b     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              p     LIKE type_file.chr1,         #FUN-C10043 add  #列印項目
              more  LIKE type_file.chr1          # Input more condition(Y/N)    #No.FUN-680070 VARCHAR(1)
           END RECORD,
       g_dates      LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       g_datee      LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       l_bdates     LIKE type_file.dat,          #No.FUN-680070 DATE
       l_bdatee     LIKE type_file.dat,          #No.FUN-680070 DATE
       g_fbg01      LIKE fbg_file.fbg01,         #No.FUN-550034                 #No.FUN-680070 VARCHAR(16)
       g_total      LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(13,3)
       swth         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_str1       LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
       g_str2       LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(15)
       g_str3       LIKE type_file.chr20         #No.FUN-680070 VARCHAR(15)
DEFINE g_i          LIKE type_file.num5          #count/index for any purpose   #No.FUN-680070 SMALLINT
#No.FUN-580010  --end
DEFINE g_sql    STRING                           #No.FUN-7A0036
DEFINE g_str    STRING                           #No.FUN-7A0036
DEFINE l_table  STRING                           #No.FUN-7A0036  
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_azi05_1  LIKE azi_file.azi05,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#No.FUN-7A0036--start--
   LET g_sql="faj04.faj_file.faj04,",
             "fbg01.fbg_file.fbg01,",
             "fbg02.fbg_file.fbg02,",
             "fbg04.fbg_file.fbg04,",
             "fbg03.fbg_file.fbg03,",
             "fbg05.fbg_file.fbg05,",
             "fbh02.fbh_file.fbh02,",
             "fbh03.fbh_file.fbh03,",
             "fbh031.fbh_file.fbh031,",
             "faj06.faj_file.faj06,",
             "fbh04.fbh_file.fbh04,",
             "faj18.faj_file.faj18,",
             "fbh05.fbh_file.fbh05,",
             "fbh06.fbh_file.fbh06,",
             "fbh07.fbh_file.fbh07,",
             "fbh08.fbh_file.fbh08,",
             "fbh12.fbh_file.fbh12,",
             "cost.fbh_file.fbh12"
   LET l_table = cl_prt_temptable('afar213',g_sql) CLIPPED          
   IF l_table= -1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM 
   END IF           
#No.FUN-7A0036--end--
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)   #TQC-610055
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   LET tm.p  = ARG_VAL(13)  #FUN-C10043 add
   #No.FUN-570264 --start--
  #FUN-C10043 mark START
  #LET g_rep_user = ARG_VAL(13)
  #LET g_rep_clas = ARG_VAL(14)
  #LET g_template = ARG_VAL(15)
  #LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
  #FUN-C10043 mark END
  #FUN-C10043 add START
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
  #FUN-C10043 add EN
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r213_tm(0,0)		# Input print condition
      ELSE CALL afar213()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r213_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r213_w AT p_row,p_col WITH FORM "afa/42f/afar213"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '3'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.p    = '1'  #FUN-C10043 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   LET tm2.u3   = tm.c[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      DISPLAY BY NAME tm.s,tm.c,tm.t,tm.more,tm.a,tm.b
                      # Condition
      CONSTRUCT BY NAME tm.wc ON faj04,fbh03,fbg01,fbg02,fbg04,fbg03,fbg05
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
         LET INT_FLAG = 0 CLOSE WINDOW r213_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.a,tm.b,tm.s,tm.c,tm.t,tm.p,tm.more   #FUN-C10043 add tm.p
                      # Condition
         INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.p,tm.more   #FUN-C10043 add tm.p
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD a
               IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL THEN
                  NEXT FIELD a
               END IF
            AFTER FIELD b
               IF tm.b NOT MATCHES "[123]" OR tm.b IS NULL THEN
                  NEXT FIELD b
               END IF
          #FUN-C10043 add START
            AFTER FIELD p
               IF tm.p NOT MATCHES "[12]" OR cl_null(tm.p) THEN
                  NEXT FIELD p
               END IF
          #FUN-C10043 add END
              # CHI-C60010--add--start
               IF g_faa.faa31='N' AND tm.p='2' THEN
                  CALL cl_err('','afar108',0)
                  NEXT FIELD p
               END IF
              # CHI-C60010--add--end--
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
                  NEXT FIELD more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()	# Command execution
            AFTER INPUT     #no:6819
                LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
                LET tm.t = tm2.t1,tm2.t2,tm2.t3
                LET tm.c = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW r213_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar213'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar213','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                            " '",tm.p CLIPPED,"'",  #FUN-C10043 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar213',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r213_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar213()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r213_w
END FUNCTION
 
FUNCTION afar213()
   DEFINE l_name LIKE type_file.chr20,          # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8     #No.FUN-6A0069
          l_sql  LIKE type_file.chr1000,        # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr  LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
          l_za05 LIKE za_file.za05,             #No.FUN-680070 VARCHAR(40)
          l_order ARRAY[6] OF LIKE fbg_file.fbg01,      #No.FUN-680070 VARCHAR(10)
          sr     RECORD order1 LIKE fbg_file.fbg01,     #No.FUN-680070 VARCHAR(10)
                        order2 LIKE fbg_file.fbg01,     #No.FUN-680070 VARCHAR(10)
                        order3 LIKE fbg_file.fbg01,     #No.FUN-680070 VARCHAR(10)
                        faj04 LIKE faj_file.faj04,
                        fbg01 LIKE fbg_file.fbg01,
                        fbg02 LIKE fbg_file.fbg02,
                        fbg04 LIKE fbg_file.fbg04,
                        fbg03 LIKE fbg_file.fbg03,
                        fbg05 LIKE fbg_file.fbg05,
                        fbh02 LIKE fbh_file.fbh02,
                        fbh03 LIKE fbh_file.fbh03,
                        fbh031 LIKE fbh_file.fbh031,
                        faj06 LIKE faj_file.faj06,
                        fbh04 LIKE fbh_file.fbh04,
                        faj18 LIKE faj_file.faj18,
                        fbh05 LIKE fbh_file.fbh05,
                        fbh06 LIKE fbh_file.fbh06,
                        fbh07 LIKE fbh_file.fbh07,
                        fbh08 LIKE fbh_file.fbh08,
                        fbh12 LIKE fbh_file.fbh12,      #No.CHI-480001
                        cost  LIKE fbh_file.fbh12       #No.CHI-480001
                 END RECORD
     DEFINE l_i,l_cnt         LIKE type_file.num5       #No.FUN-680070 SMALLINT
     DEFINE l_zaa02           LIKE zaa_file.zaa02
     
     CALL cl_del_data(l_table)                          #No.FUN-7A0036
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afar213'   #No.FUN-7A0036
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fbguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fbggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fbggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fbguser', 'fbggrup')
     #End:FUN-980030
 
 
     IF tm.a='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbgconf='Y' " END IF
     IF tm.a='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbgconf='N' " END IF
     IF tm.b='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbgpost='Y' " END IF
     IF tm.b='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbgpost='N' " END IF
     IF tm.p = '1' THEN  #FUN-C10043 add  
        LET l_sql = "SELECT '','','',",
                    " faj04,fbg01,fbg02,fbg04,fbg03,fbg05,fbh02,fbh03,",
                    " fbh031,faj06,fbh04,faj18,fbh05,fbh06,fbh07,",
                    " fbh08,fbh12,0",         #No.CHI-480001
                    " FROM fbg_file,fbh_file,OUTER faj_file  ",
                    " WHERE fbg01 = fbh01 " ,
                    "   AND fbgconf != 'X' " , #010801增
                    "   AND fbh_file.fbh03=faj_file.faj02" ,
                    "   AND fbh_file.fbh031=faj_file.faj022" ,
                    " AND ",tm.wc
    #FUN-C10043 add START
     ELSE
        LET l_sql = "SELECT '','','',",
                    " faj04,fbg01,fbg02,fbg04,fbg03,fbg05,fbh02,fbh03,",
                    " fbh031,faj06,fbh04,faj18,fbh05,fbh062,fbh072,",
                    " fbh082,fbh122,0",         #No.CHI-480001
                    " FROM fbg_file,fbh_file,OUTER faj_file  ",
                    " WHERE fbg01 = fbh01 " ,
                    "   AND fbgconf != 'X' " , #010801增
                    "   AND fbh_file.fbh03=faj_file.faj02" ,
                    "   AND fbh_file.fbh031=faj_file.faj022" ,
                    " AND ",tm.wc
     END IF
    #FUN-C10043 add END
     LET  g_total = 0
 
     PREPARE r213_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r213_cs1 CURSOR FOR r213_prepare1
#No.FUN-7A0036--start--
#     CALL cl_outnam('afar213') RETURNING l_name
 
#No.FUN-580010 --start
           IF g_aza.aza26 = '2' THEN
#            LET g_zaa[46].zaa06 = "N"                 
             LET l_name='afar213'                                       
           ELSE
#            LET g_zaa[46].zaa06 = "Y"                       
             LET l_name='afar213_1'                          
           END IF
#      CALL cl_prt_pos_len()
#No.FUN-580010 --end
 
#     START REPORT r213_rep TO l_name
#     LET g_pageno = 0
 
   { IF NOT cl_null(tm.s[1,1]) THEN
        LET g_i=tm.s[1,1] LET g_str1=g_x[14+g_i]
     END IF
     IF NOT cl_null(tm.s[2,2]) THEN
        LET g_i=tm.s[2,2] LET g_str2=g_x[14+g_i]
     END IF
     IF NOT cl_null(tm.s[3,3]) THEN
        LET g_i=tm.s[3,3] LET g_str3=g_x[14+g_i]
     END IF}
 
     FOREACH r213_cs1 INTO sr.*
       IF g_fbg01 IS NULL OR  g_fbg01!=sr.fbg01 THEN                                                                                 
            LET swth = 'Y'                                                                                                            
       ELSE LET swth='N'                                                                                                             
       END IF  
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
     { FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fbh03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fbg01
               WHEN tm.s[g_i,g_i] = '4'
                    LET l_order[g_i] = sr.fbg02 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fbg04
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fbg03
               WHEN tm.s[g_i,g_i] = '7'
                    LET l_order[g_i] = sr.fbg05 USING 'yyyymmdd'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]}
       INITIALIZE g_fbg01 TO NULL
       IF cl_null(sr.fbh06) THEN LET sr.fbh06=0 END IF
       IF cl_null(sr.fbh07) THEN LET sr.fbh07=0 END IF
       IF cl_null(sr.fbh08) THEN LET sr.fbh08=0 END IF
       #No.CHI-480001
       IF cl_null(sr.fbh12) THEN LET sr.fbh12=0 END IF
       LET sr.cost = sr.fbh08 - sr.fbh12
       #end
#      OUTPUT TO REPORT r213_rep(sr.*)
       EXECUTE insert_prep USING
               sr.faj04,sr.fbg01,sr.fbg02,sr.fbg04,sr.fbg03,sr.fbg05,sr.fbh02,sr.fbh03,sr.fbh031,
               sr.faj06,sr.fbh04,sr.faj18,sr.fbh05,sr.fbh06,sr.fbh07,sr.fbh08,sr.fbh12,sr.cost
     END FOREACH
 
#    FINISH REPORT r213_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'faj04,fbh03,fbg01,fbg02,fbg04,fbg03,
                      fbg05')
             RETURNING tm.wc
             LET g_str = tm.wc
#     ELSE
#        LET tm.wc="" 
     END IF
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #CHI-C60010---str---
     SELECT aaa03 INTO g_faj143 FROM aaa_file
      WHERE aaa01 = g_faa.faa02c
     IF NOT cl_null(g_faj143) THEN
       SELECT azi04,azi05 INTO g_azi04_1,g_azi05_1 FROM azi_file
        WHERE azi01 = g_faj143
     END IF
     IF tm.p = '2' THEN
       #-----------------------------MOD-D10257---------------------------------(S)
       #--MOD-D10257--mark
       #LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
       #            tm.t[2,2],";",tm.t[3,3],";",tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",
       #            g_azi04_1,";",g_azi05_1
       #--MOD-D10257--mark
        LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",
                    tm.t,";",tm.t,";",tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",
                    g_azi04_1,";",g_azi05_1
       #-----------------------------MOD-D10257---------------------------------(E)
     ELSE
    #CHI-C60010---end---
       #-----------------------------MOD-D10257---------------------------------(S)
       #--MOD-D10257--mark
       #LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
       #            tm.t[2,2],";",tm.t[3,3],";",tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",
       #            g_azi04,";",g_azi05
       #--MOD-D10257--mark
        LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",
                    tm.t,";",tm.t,";",tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",
                    g_azi04,";",g_azi05
       #-----------------------------MOD-D10257---------------------------------(E)
     END IF    #CHI-C60010
 
     CALL cl_prt_cs3('afar213',l_name,g_sql,g_str)
#No.FUN-7A0036--end--
END FUNCTION
 
#No.FUN-7A0036--start
{REPORT r213_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_str         LIKE type_file.chr50,                     #列印排列順序說明       #No.FUN-680070 VARCHAR(50)
          l_str1        LIKE type_file.chr20,                     #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_str2        LIKE type_file.chr20,                     #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_str3        LIKE type_file.chr20,                     #列印合計的前置說明       #No.FUN-680070 VARCHAR(10)
          l_total       LIKE type_file.num20_6,      #No.FUN-680070 DECMIAL(12,3)
          sq1           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sq2           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sq3           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_ima08       LIKE ima_file.ima08,
          l_ima37       LIKE ima_file.ima08,
          sr               RECORD order1 LIKE fbg_file.fbg01,       #No.FUN-680070 VARCHAR(10)
                                  order2 LIKE fbg_file.fbg01,       #No.FUN-680070 VARCHAR(10)
                                  order3 LIKE fbg_file.fbg01,       #No.FUN-680070 VARCHAR(10)
                                  faj04 LIKE faj_file.faj04,	#
                                  fbg01 LIKE fbg_file.fbg01,	#
                                  fbg02 LIKE fbg_file.fbg02,	#
                                  fbg04 LIKE fbg_file.fbg04,	#
                                  fbg03 LIKE fbg_file.fbg03,	#
                                  fbg05 LIKE fbg_file.fbg05,	#
                                  fbh02 LIKE fbh_file.fbh02,	#
                                  fbh03 LIKE fbh_file.fbh03,	#
                                  fbh031 LIKE fbh_file.fbh031,	#
                                  faj06 LIKE faj_file.faj06,	#
                                  fbh04 LIKE fbh_file.fbh04,	#
                                  faj18 LIKE faj_file.faj18,	#
                                  fbh05 LIKE fbh_file.fbh05,	#
                                  fbh06 LIKE fbh_file.fbh06,	#
                                  fbh07 LIKE fbh_file.fbh07,	#
                                  fbh08 LIKE fbh_file.fbh08,	#
                                  fbh12 LIKE fbh_file.fbh12,	#No.CHI-480001
                                  cost  LIKE fbh_file.fbh12 	#No.CHI-480001
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.fbg01,sr.fbh02
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46]
      PRINT g_dash1
      LET l_last_sw = 'n'
#No.FUN-580010 --end
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
 
     BEFORE GROUP OF sr.fbg01
      IF g_fbg01 IS NULL OR  g_fbg01!=sr.fbg01 THEN
          LET swth = 'Y'
      ELSE LET swth='N'
      END IF
 
   ON EVERY ROW
      IF swth='Y' THEN
#No.FUN-580010 --start
#No.FUN-550034 --start--
         PRINT COLUMN g_c[31],sr.fbg01 CLIPPED,
               COLUMN g_c[32],sr.fbg02 clipped,
               COLUMN g_c[33],sr.fbg04 CLIPPED,
               COLUMN g_c[34],sr.fbg03 CLIPPED,
               COLUMN g_c[35],sr.fbg05 CLIPPED;
         LET swth='N'
      ELSE
         PRINT ;
      END IF
         PRINT COLUMN g_c[36],sr.fbh02 USING '####',
               COLUMN g_c[37],sr.fbh03 CLIPPED,
               COLUMN g_c[38],sr.fbh031 CLIPPED,
               COLUMN g_c[39],sr.faj06 CLIPPED,
               COLUMN g_c[40],cl_numfor(sr.fbh04,40,0),
               COLUMN g_c[41],sr.faj18 CLIPPED,
               COLUMN g_c[42],sr.fbh05 CLIPPED,
               COLUMN g_c[43],cl_numfor(sr.fbh06,43,g_azi04),
               COLUMN g_c[44],cl_numfor(sr.fbh07,44,g_azi04),
               COLUMN g_c[45],cl_numfor(sr.fbh08,45,g_azi04),
               COLUMN g_c[46],cl_numfor(sr.cost,46,g_azi04)
#No.FUN-580010 --end
               #end
 
   AFTER GROUP OF sr.order1
      IF tm.c[1,1] = 'Y'  AND tm.c[1,1] = 'Y' THEN
         PRINT
#No.FUN-580010 --start
#No.FUN-550034 --start--
         PRINT COLUMN g_c[43],g_dash2[1,g_w[43]],
               COLUMN g_c[44],g_dash2[1,g_w[44]],
               COLUMN g_c[45],g_dash2[1,g_w[45]],
               COLUMN g_c[46],g_dash2[1,g_w[46]]
         PRINTX name=S1 g_str1 CLIPPED,
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fbh06),43,g_azi05),
               COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fbh07),44,g_azi05),
               COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbh08),45,g_azi05),
               COLUMN g_c[46],cl_numfor(GROUP SUM(sr.cost),46,g_azi05)
#No.FUN-580010  --end
       END IF
 
   AFTER GROUP OF sr.order2
      IF tm.c[2,2] = 'Y'  AND tm.c[2,2] = 'Y' THEN
         PRINT
#No.FUN-580010 --start
         PRINT COLUMN g_c[43],g_dash2[1,g_w[43]],
               COLUMN g_c[44],g_dash2[1,g_w[44]],
               COLUMN g_c[45],g_dash2[1,g_w[45]],
               COLUMN g_c[46],g_dash2[1,g_w[46]]
         PRINTX name=S2 g_str2 CLIPPED,
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fbh06),43,g_azi05),
               COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fbh07),44,g_azi05),
               #No.CHI-480001
               COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbh08),45,g_azi05),
               COLUMN g_c[46],cl_numfor(GROUP SUM(sr.cost),46,g_azi05)
#No.FUN-580010 --end
               #end
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.c[3,3] = 'Y' AND tm.c[3,3] = 'Y' THEN
         PRINT
#No.FUN-580010 --start
         PRINT COLUMN g_c[43],g_dash2[1,g_w[43]],
               COLUMN g_c[44],g_dash2[1,g_w[44]],
               COLUMN g_c[45],g_dash2[1,g_w[45]],
               COLUMN g_c[46],g_dash2[1,g_w[46]]
         PRINTX name=S3 g_str3 CLIPPED,
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fbh06),43,g_azi05),
               COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fbh07),44,g_azi05),
               #No.CHI-480001
               COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbh08),45,g_azi05),
               COLUMN g_c[46],cl_numfor(GROUP SUM(sr.cost),46,g_azi05)
#No.FUN-580010 --end
      END IF
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
              #IF tm.wc[001,120] > ' ' THEN			# for 132
 	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
 	      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#No.FUN-7A0036--end--
#Patch....NO.TQC-610035 <> #
