# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr330.4gl
# Descriptions...: 付款清單列印
# Date & Author..: 93/11/10  By  Roger
# Modify.........: No.MOD-4A0267 93/10/21 By Yuna aph06已不用,由報表中移除
# Modify.........: No.FUN-4C0097 04/12/28 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02、付款廠商apf03、銀行名稱pma02、方式aph03a
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.MOD-580328 05/09/12 By Smapmin tm.a不可給預設值
# Modify.........: No.MOD-5A0016 05/10/20 By Smapmin 將tm.a清空
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-670037 06/07/11 By Smapmin 修改付款性質選項
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 未依幣別合計
# Modify.........: No.MOD-730134 07/03/28 By Smapmin 總計金額有錯
# Modify.........: No.TQC-740326 07/04/28 By dxfwo   排序第二欄位未有默認值
# Modify.........: No.MOD-750052 07/05/11 By Smapmin 畫面已有排序條件,l_sql就不再做ORDER BY
# Modify.........: No.FUN-7A0025 07/10/17 By xiaofeizhu 報表轉Crystal Report格式
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980057 10/08/22 By vealxu QBE add apf44
# Modify.........: NO.FUN-B20014 11/02/12 By lilingyu SQL增加apf00<>'32' or apf00<>'36'的條件
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:CHI-B80065 11/10/17 By Dido 查詢條件後需再重新給予 INPUT 欄位變數 
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:FUN-C30287 12/03/27 By yinhy 條件選項付款性質選項增加收票轉付類型
# Modify.........: No.TQC-C40097 12/04/13 By JinJJ 增加审核否条件选项

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
                 #wc       LIKE type_file.chr1000,    # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc       STRING,      # Where condition   #TQC-630166
                 a        LIKE type_file.chr20,           # No.FUN-690028 VARCHAR(10),
                 s        LIKE type_file.chr2,          # No.FUN-690028 VARCHAR(2),        # Order by sequence
                 t        LIKE type_file.chr2,          # No.FUN-690028 VARCHAR(2),        # Eject sw
                 u        LIKE type_file.chr2,          # No.FUN-690028 VARCHAR(2),        # Group total sw
                 more     LIKE type_file.chr1           # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          tm3 RECORD
                 b,c,d    LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
                 e,f,g    LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
                 h        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
                 i,j,k,l,n,o,p LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)   #MOD-670037
                 m        LIKE type_file.chr1         # No.FUN-C30287
              END RECORD,
          g_due ARRAY[40] OF LIKE type_file.dat,         # No.FUN-690028 DATE,
          g_tot ARRAY[40] OF LIKE type_file.num20_6,     # No.FUN-690028 DECIMAL(20,6),
          i		LIKE type_file.num5,    #No.FUN-690028 SMALLINT
#         g_orderA    ARRAY[2] OF VARCHAR(10) #排序名稱
          g_orderA    ARRAY[2] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16) #排序名稱
                                           #No.FUN-550030
   DEFINE conf LIKE type_file.chr1     #No.TQC-C40097 
   DEFINE apf08_t1,apf09_t1	LIKE apf_file.apf08
   DEFINE apf08_t2,apf09_t2	LIKE apf_file.apf08
   DEFINE apf08_t3,apf09_t3	LIKE apf_file.apf08
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE   l_table1        STRING     #No.FUN-7A0025                                                                                  
DEFINE   g_str           STRING     #No.FUN-7A0025                                                                                  
DEFINE   g_sql           STRING     #No.FUN-7A0025
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #No.FUN-7A0025 --Begin                                                                                                          
   LET g_sql = "apf04.apf_file.apf04,",                                                                                        
               "apf02.apf_file.apf02,",
               "apf01.apf_file.apf01,",
               "apf03.apf_file.apf03,",           
               "apf12.apf_file.apf12,",
               "apf06.apf_file.apf06,",
               "apf44.apf_file.apf44,",     #FUN-980057 add
               "apf08.apf_file.apf08,",
               "apf09.apf_file.apf09,",
               "aph03.aph_file.aph03,",
               "aph05.aph_file.aph05,",
               "aph07.aph_file.aph07,",
               "aph08.aph_file.aph08,",
               "gen02.gen_file.gen02,",
               "nmd02.nmd_file.nmd02,",
               "nma02.nma_file.nma02,",
               "apf08_t1.apf_file.apf08,",
               "apf08_t2.apf_file.apf08,",   
               "apf09_t1.apf_file.apf08,",                                                                                          
               "apf09_t2.apf_file.apf08,",
               "l_aph03a.zaa_file.zaa08" 
 
   LET l_table1 = cl_prt_temptable('aapr3301',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #No.FUN-7A0025  --End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
  #------TQC-610053---------
  LET tm3.b = ARG_VAL(12)
  LET tm3.c = ARG_VAL(13)
  LET tm3.d = ARG_VAL(14)
  LET tm3.e = ARG_VAL(15)
  LET tm3.f = ARG_VAL(16)
  LET tm3.g = ARG_VAL(17)
  LET tm3.h = ARG_VAL(18)
  LET tm3.i = ARG_VAL(19)   #MOD-670037
  LET tm3.j = ARG_VAL(20)   #MOD-670037
  LET tm3.k = ARG_VAL(21)   #MOD-670037
  LET tm3.l = ARG_VAL(22)   #MOD-670037
  LET tm3.n = ARG_VAL(23)   #MOD-670037
  LET tm3.o = ARG_VAL(24)   #MOD-670037
  LET tm3.p = ARG_VAL(25)   #MOD-670037
  #-----END TQC-610053-----
  LET tm3.m = ARG_VAL(26)   #FUN-C30287
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(27)
   LET g_rep_clas = ARG_VAL(28)
   LET g_template = ARG_VAL(29)
   LET g_rpt_name = ARG_VAL(30)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #TQC-6A0088 ---begin---                                                                                                          
    DROP TABLE curr_tmp
    CREATE TEMP TABLE curr_tmp
       (curr    LIKE apf_file.apf06,
        amt1    LIKE apf_file.apf08,
        amt2    LIKE apf_file.apf08,
        amt3    LIKE apf_file.apf08);
   #TQC-6A0088 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r330_tm(0,0)
   ELSE
      CALL r330()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r330_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 17
   OPEN WINDOW r330_w AT p_row,p_col
     WITH FORM "aap/42f/aapr330"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.a    = '1'   #MOD-580328
#  LET tm.s    = '3'
   LET tm.s    = '34'   #TQC-740326 
   LET tm.u    = ''
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   LET tm3.b = 'Y'
   LET tm3.c = 'N'
   LET tm3.d = 'N'
   LET tm3.e = 'N'
   LET tm3.f = 'N'
   LET tm3.g = 'N'
   LET tm3.h = 'N'
   LET tm3.i = 'N'   #MOD-670037
   LET tm3.j = 'N'   #MOD-670037
   LET tm3.k = 'N'   #MOD-670037
   LET tm3.l = 'N'   #MOD-670037
   LET tm3.n = 'N'   #MOD-670037
   LET tm3.o = 'N'   #MOD-670037
   LET tm3.p = 'N'   #MOD-670037
   LET tm3.m = 'N'   #FUN-C30287
   LET conf = 'N'    #TQC-C40097
 
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apf04,apf02,apf01,apf03,apf06,apf44       #FUN-980057 add apf44
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CLOSE WINDOW r330_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm3.b,tm3.c,tm3.d,tm3.e,tm3.f,tm3.g,tm3.h,
                    tm3.i,tm3.j,tm3.k,tm3.l,tm3.n,tm3.o,tm3.p,tm3.m,   #MOD-670037 #FUN-C30287 add tm3.m
                    tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,
                    tm.more,conf WITHOUT DEFAULTS  #TQC-C40097 add conf
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
            #-CHI-B80065-add-
             LET tm3.b = GET_FLDBUF(b)
             LET tm3.c = GET_FLDBUF(c)
             LET tm3.d = GET_FLDBUF(d)
             LET tm3.e = GET_FLDBUF(e)
             LET tm3.f = GET_FLDBUF(f)
             LET tm3.g = GET_FLDBUF(g)
             LET tm3.h = GET_FLDBUF(h)
             LET tm3.i = GET_FLDBUF(i)
             LET tm3.j = GET_FLDBUF(j)
             LET tm3.k = GET_FLDBUF(k)
             LET tm3.l = GET_FLDBUF(l)
             LET tm3.n = GET_FLDBUF(n)
             LET tm3.o = GET_FLDBUF(o)
             LET tm3.p = GET_FLDBUF(p)
            #-CHI-B80065-end-
             LET conf = GET_FLDBUF(conf)   #TQC-C40097 add
            
             LET tm3.m = GET_FLDBUF(m)  #FUN-C30287
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.a = null   #MOD-5A0016
            #-----MOD-670037---------
            IF tm3.b = 'Y' THEN LET tm.a = tm.a CLIPPED,'1' END IF
            IF tm3.c = 'Y' THEN LET tm.a = tm.a CLIPPED,'2' END IF
            IF tm3.d = 'Y' THEN LET tm.a = tm.a CLIPPED,'3' END IF
            IF tm3.e = 'Y' THEN LET tm.a = tm.a CLIPPED,'4' END IF
            IF tm3.f = 'Y' THEN LET tm.a = tm.a CLIPPED,'5' END IF
            IF tm3.g = 'Y' THEN LET tm.a = tm.a CLIPPED,'6' END IF
            IF tm3.h = 'Y' THEN LET tm.a = tm.a CLIPPED,'7' END IF
            IF tm3.i = 'Y' THEN LET tm.a = tm.a CLIPPED,'8' END IF
            IF tm3.j = 'Y' THEN LET tm.a = tm.a CLIPPED,'9' END IF
            IF tm3.k = 'Y' THEN LET tm.a = tm.a CLIPPED,'A' END IF
            IF tm3.l = 'Y' THEN LET tm.a = tm.a CLIPPED,'B' END IF
            IF tm3.n = 'Y' THEN LET tm.a = tm.a CLIPPED,'C' END IF
            IF tm3.o = 'Y' THEN LET tm.a = tm.a CLIPPED,'Z' END IF
            #-----END MOD-670037-----
            IF tm3.m = 'Y' THEN LET tm.a = tm.a CLIPPED,'D' END IF  #FUN-C30287
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.u = tm2.u1,tm2.u2
 
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
         CLOSE WINDOW r330_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr330'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr330','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",   #TQC-610053
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                       #-----TQC-610053---------
                       " '",tm3.b CLIPPED,"'",
                       " '",tm3.c CLIPPED,"'",
                       " '",tm3.d CLIPPED,"'",
                       " '",tm3.e CLIPPED,"'",
                       " '",tm3.f CLIPPED,"'",
                       " '",tm3.g CLIPPED,"'",
                       " '",tm3.h CLIPPED,"'",
                       " '",tm3.i CLIPPED,"'",   #MOD-670037
                       " '",tm3.j CLIPPED,"'",   #MOD-670037
                       " '",tm3.k CLIPPED,"'",   #MOD-670037
                       " '",tm3.l CLIPPED,"'",   #MOD-670037
                       " '",tm3.n CLIPPED,"'",   #MOD-670037
                       " '",tm3.o CLIPPED,"'",   #MOD-670037
                       " '",tm3.p CLIPPED,"'",   #MOD-670037
                       #-----END TQC-610053-----
                       " '",tm3.m CLIPPED,"'",   #FUN-C30287
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",conf CLIPPED,"'"            #No.TQC-C40097
            CALL cl_cmdat('aapr330',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r330_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
        EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r330()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r330_w
 
END FUNCTION
 
FUNCTION r330()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_dbs_anm,l_dbs LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(20),
          l_order   ARRAY[2] OF LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),             #No.FUN-550030
          sr        RECORD order1 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),           #No.FUN-550030
                           order2 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),           #No.FUN-550030
                           apf04 LIKE apf_file.apf04, #付款單單頭檔
                           apf02 LIKE apf_file.apf02,
                           apf01 LIKE apf_file.apf01,
                           apf03 LIKE apf_file.apf03,
                           apf12 LIKE apf_file.apf12,
                           apf06 LIKE apf_file.apf06,
                           apf44 LIKE apf_file.apf44,  #FUN-980057 add
                           apf08 LIKE apf_file.apf08,
                           apf09 LIKE apf_file.apf09,
                           azi03 LIKE azi_file.azi03,
                           azi04 LIKE azi_file.azi04,
                           azi05 LIKE azi_file.azi05,
                           aph01 LIKE aph_file.aph01,
                           aph02 LIKE aph_file.aph02,
                           aph03 LIKE aph_file.aph03,
                           aph05 LIKE aph_file.aph05,
                        #    aph06 LIKE aph_file.aph06,  #No.MOD-4A0267
                           aph07 LIKE aph_file.aph07,
                           aph08 LIKE aph_file.aph08,
                           aph09 LIKE aph_file.aph09,
                           gen02 LIKE gen_file.gen02,
                           aph03a LIKE zaa_file.zaa08,  #No.FUN-690028 VARCHAR(10),
                           nmd02 LIKE nmd_file.nmd02,
                           nma02 LIKE nma_file.nma02
                    END RECORD
 
     #No.FUN-7A0025  --Begin          
     DEFINE      sr1       RECORD                                                                                             
                           curr      LIKE apf_file.apf06,                                                                           
                           amt1      LIKE apf_file.apf08,                                                                           
                           amt2      LIKE apf_file.apf09,                                                                           
                           amt3      LIKE apf_file.apf10                                                                            
                        END RECORD             
    DEFINE       l_aph03a            LIKE zaa_file.zaa08                                                                                 
     CALL cl_del_data(l_table1)                                                                                                     
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                         
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "     #FUN-980057 add ?                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM                                                                           
     END IF
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     #No.FUN-7A0025  --End
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apfuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
   #End:FUN-980030
 
#-----BEGIN TQC-6A0088----                                                                                                       
        DELETE FROM curr_tmp;                                                                                                       
      LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3)",                                                                       
                "   FROM curr_tmp ",    #總計                                                                                       
                "  GROUP BY curr  "                                                                                                 
      PREPARE tmp4_pre FROM l_sql                                                                                                   
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err('pre_4:',SQLCA.sqlcode,1)                                                                                      
         RETURN                                                                                                                     
      END IF                                                                                                                        
      DECLARE tmp4_cs CURSOR FOR tmp4_pre                                                                                           
   #-----END TQC-6A0088----
   #-->列印付款單的貸方
   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_apz.apz04p
   IF l_dbs IS NOT NULL AND l_dbs != ' ' THEN
     #LET l_dbs_anm = s_dbstring(l_dbs)  #TQC-940178 MARK
      LET l_dbs_anm = s_dbstring(l_dbs clipped)  #TQC-940178 ADD 
   ELSE
      LET l_dbs_anm = ' '
   END IF
   
#----TQC-C40097 START--------
         LET l_sql = "SELECT '','',",
               " apf04, apf02, apf01, apf03, apf12, apf06,apf44,",  
               " apf08, apf09, azi03, azi04, azi05,",
                " aph01, aph02, aph03, aph05, aph07, aph08, aph09,'','','',''",
               " FROM apf_file, aph_file, OUTER azi_file ",
               " WHERE apf01 = aph01 AND azi_file.azi01 = apf_file.apf06 ",
              #"   AND apf41 <> 'X' ",                   #TQC-C40097 mark
               "   AND apf41 =  ","'", conf, "'",        #TQC-C40097 add
               "   AND (apf00 <> '32' OR apf00 <> '36')",
               " AND ", tm.wc CLIPPED 
    #----TQC-C40097 END--------
   #-----MOD-670037---------
   IF tm3.p = 'N' THEN
      LET l_sql = l_sql," AND aph03 IN ",cl_parse(tm.a CLIPPED)
   ELSE
      IF NOT cl_null(tm.a) THEN
         LET l_sql = l_sql," AND (aph03 IN ",cl_parse(tm.a CLIPPED)," OR ",
                           " aph03 NOT IN ('1','2','3','4','5','6','7','8','9','A','B','C','Z','D')) "    #FUN-C30287 add D
      ELSE
         LET l_sql = l_sql," AND aph03 NOT IN ('1','2','3','4','5','6','7','8','9','A','B','C','Z','D')"  #FUN-C30287 add D
      END IF
   END IF
   #-----END MOD-670037-----
 
   #-----MOD-750052---------
   ##-->日期可依大小彙總
   #LET l_sql = l_sql clipped," ORDER BY aph07 "
   #-----END MOD-750052-----
   PREPARE r330_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r330_curs1 CURSOR FOR r330_prepare1
 
#  CALL cl_outnam('aapr330') RETURNING l_name                  #FUN-7A0025
#  START REPORT r330_rep TO l_name                             #FUN-7A0025
 
   LET g_pageno = 0
 
   FOR i = 1 TO 40
      LET g_due[i] = NULL
      LET g_tot[i] = 0
   END FOR
 
   LET apf08_t3 = 0
   LET apf09_t3 = 0
 
   FOREACH r330_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gen02 INTO sr.gen02 FROM gen_file
       WHERE gen01 = sr.apf04
 
      SELECT nma02 INTO sr.nma02 FROM nma_file
       WHERE nma01 = sr.aph08
     #-----MOD-670037---------
     LET sr.aph03a = ''
     
    #No.FUN-7A0025--MARK--BEGIN--
    #CASE
    #   WHEN sr.aph03 = '1'
    #      LET sr.aph03a = g_x[18] CLIPPED
    #   WHEN sr.aph03 = '2'
    #      LET sr.aph03a = g_x[19] CLIPPED
    #   WHEN sr.aph03 = '3'
    #      LET sr.aph03a = g_x[46] CLIPPED
    #   WHEN sr.aph03 = '4'
    #      LET sr.aph03a = g_x[47] CLIPPED
    #   WHEN sr.aph03 = '5'
    #      LET sr.aph03a = g_x[48] CLIPPED
    #   WHEN sr.aph03 = '6'
    #      LET sr.aph03a = g_x[21] CLIPPED
    #   WHEN sr.aph03 = '7'
    #      LET sr.aph03a = g_x[22] CLIPPED
    #   WHEN sr.aph03 = '8'
    #      LET sr.aph03a = g_x[23] CLIPPED
    #   WHEN sr.aph03 = '9'
    #      LET sr.aph03a = g_x[24] CLIPPED
    #   WHEN sr.aph03 = 'A'
    #      LET sr.aph03a = g_x[49] CLIPPED
    #   WHEN sr.aph03 = 'B'
    #      LET sr.aph03a = g_x[50] CLIPPED
    #   WHEN sr.aph03 = 'C'
    #      LET sr.aph03a = g_x[51] CLIPPED
    #   WHEN sr.aph03 = 'Z'
    #      LET sr.aph03a = g_x[52] CLIPPED
    #   OTHERWISE
    #No.FUN-7A0025-MARK-END--
    
    #No.FUN-7A0025-ADD-BEGIN--
     IF sr.aph03 !='1'or'2'or'3'or'4'or'5'or'6'or'7'or'8'or'9'or'A'or'B'or'C'or'Z'OR'D' THEN  #FUN-C30287 add D
    #No.FUN-7A0025-ADD-END--
           SELECT apw02 INTO sr.aph03a FROM apw_file WHERE apw01 = sr.aph03
           LET l_aph03a = sr.aph03a                         #FUN-7A0025
     END IF                                                 #FUN-7A0025
    #      LET sr.aph03a = sr.aph03,'.',sr.aph03a           #FUN-7A0025
    #END CASE                                               #FUN-7A0025
     IF cl_null(sr.aph03a) THEN
        LET sr.aph03a = sr.aph03
     END IF
     #-----END MOD-670037-----
 
      SELECT nmd02 INTO sr.nmd02 FROM nmd_file
       WHERE nmd10=sr.apf01 AND nmd101=sr.aph02
         AND nmd30 <> 'X'
 
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
      IF cl_null(sr.apf08) THEN LET sr.apf08 = 0 END IF
      IF cl_null(sr.apf09) THEN LET sr.apf09 = 0 END IF
      IF cl_null(sr.aph05) THEN LET sr.aph05 = 0 END IF
 
      #-->到期日金額合計
      FOR i = 1 TO 40
         IF g_tot[i] = 0 THEN
            LET g_due[i] = sr.aph07
            LET g_tot[i] = sr.aph05
            EXIT FOR
         END IF
         IF sr.aph07 = g_due[i] THEN
            LET g_tot[i]=g_tot[i] + sr.aph05
            EXIT FOR
         END IF
      END FOR
 
     #No.FUN-7A0025-MARK-BEGIN--
     #FOR g_i = 1 TO 2
     #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apf04
     #                                 LET g_orderA[g_i]= g_x[10]
     #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apf02 USING 'YYYYMMDD'
     #                                 LET g_orderA[g_i]= g_x[11]
     #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apf01
     #                                 LET g_orderA[g_i]= g_x[12]
     #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apf03,sr.apf12
     #                                 LET g_orderA[g_i]= g_x[13]
     #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apf06
     #                                 LET g_orderA[g_i]= g_x[14]
     #        OTHERWISE LET l_order[g_i]  = '-'
     #                  LET g_orderA[g_i] = ' '    #清為空白
     #   END CASE
     #END FOR
 
     #LET sr.order1 = l_order[1]
     #LET sr.order2 = l_order[2]
     #No.FUN-7A0025-MARK-END--
 
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
 
     #No.FUN-7A0025-ADD--BEGIN--
         INSERT INTO curr_tmp VALUES(sr.apf06,sr.apf08,sr.apf09,0)                                                      
                                                                                                                                    
         LET apf08_t1 = apf08_t1 + sr.apf08                                                                                         
         LET apf08_t2 = apf08_t2 + sr.apf08                                                                                         
         LET apf08_t3 = apf08_t3 + sr.apf08                                                                                         
         LET apf09_t1 = apf09_t1 + sr.apf09                                                                                         
         LET apf09_t2 = apf09_t2 + sr.apf09                                                                                         
         LET apf09_t3 = apf09_t3 + sr.apf09
         INSERT INTO curr_tmp VALUES(sr.apf06,0,0,sr.aph05)
 
     #OUTPUT TO REPORT r330_rep(sr.*)                            #FUN-7A0025     
        EXECUTE insert_prep USING sr.apf04,sr.apf02,sr.apf01,sr.apf03,sr.apf12,sr.apf06,sr.apf44,sr.apf08,sr.apf09,  #FUN-980057 add apf44
                                  sr.aph03,sr.aph05,sr.aph07,sr.aph08,sr.gen02,sr.nmd02,sr.nma02,apf08_t1,
                                  apf08_t2,apf09_t1,apf09_t2,l_aph03a
     #No.FUN-7A0025-ADD-END--
   END FOREACH
  #No.FUN-7A0025--ADD-BEGIN--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                                                              
                                                                                                                                    
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                          
           CALL cl_wcchp(tm.wc,'apf01,apf02,apf12,apf04,apf05') RETURNING tm.wc
     END IF 
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",                                                                       
                 tm.t[2,2],";",g_azi05,";",g_azi04,";",                                                                                 
                 tm.u[1,1],";",tm.u[2,2]                                                                               
     CALL cl_prt_cs3('aapr330','aapr330',g_sql,g_str)
  #No.FUN-7A0025--ADD-END--
  #FINISH REPORT r330_rep                                        #FUN-7A0025
 
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)                   #FUN-7A0025
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105   MARK
 
END FUNCTION
 
#No.FUN-7A0025-MARK-BEGIN--
#REPORT r330_rep(sr)
#  DEFINE l_amt			LIKE type_file.num20_6 #No.FUN-690028 DECIMAL(20,6)
#  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#         sr           RECORD order1 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(20),
#                             order2 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(20),
#                             apf04 LIKE apf_file.apf04, #付款單單頭檔
#                             apf02 LIKE apf_file.apf02,
#                             apf01 LIKE apf_file.apf01,
#                             apf03 LIKE apf_file.apf03,
#                             apf12 LIKE apf_file.apf12,
#                             apf06 LIKE apf_file.apf06,
#                             apf08 LIKE apf_file.apf08,
#                             apf09 LIKE apf_file.apf09,
#                             azi03 LIKE azi_file.azi03,
#                             azi04 LIKE azi_file.azi04,
#                             azi05 LIKE azi_file.azi05,
#                             aph01 LIKE aph_file.aph01,
#                             aph02 LIKE aph_file.aph02,
#                             aph03 LIKE aph_file.aph03,
#                             aph05 LIKE aph_file.aph05,
#                         #     aph06 LIKE aph_file.aph06, #No.MOD-4A0267
#                             aph07 LIKE aph_file.aph07,
#                             aph08 LIKE aph_file.aph08,
#                             aph09 LIKE aph_file.aph09,
#                             gen02 LIKE gen_file.gen02,
#                             aph03a LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
#                             nmd02 LIKE nmd_file.nmd02,
#                             nma02 LIKE nma_file.nma02
#                  END RECORD,
# #TQC-6A0088---begin---                                                                                                      
#                  sr1           RECORD                                                                                             
#                          curr      LIKE apf_file.apf06,                                                                                      
#                          amt1      LIKE apf_file.apf08,                                                                           
#                          amt2      LIKE apf_file.apf09,                                                                           
#                          amt3      LIKE apf_file.apf10                                                                            
#                       END RECORD,                                                                                                 
#       #TQC-6A0088---end---
#     l_chr        LIKE type_file.chr1     #No.FUN-690028 VARCHAR(1)
#  DEFINE g_head1    STRING
#
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2,sr.apf01
#
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        #LET g_head1 = g_x[11] CLIPPED,g_orderA[1] CLIPPED,   #MOD-670037
#        LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,   #MOD-670037
#                      '-',g_orderA[2] CLIPPED
#        PRINT g_head1
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#              g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#
#     BEFORE GROUP OF sr.order1
#        IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#           SKIP TO TOP OF PAGE
#        END IF
#        LET apf08_t1 = 0
#        LET apf09_t1 = 0
#
#     BEFORE GROUP OF sr.order2
#        IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#           SKIP TO TOP OF PAGE
#        END IF
#        LET apf08_t2 = 0
#        LET apf09_t2 = 0
#
#     BEFORE GROUP OF sr.apf01
#        PRINT COLUMN g_c[31],sr.apf04,
#              COLUMN g_c[32],sr.gen02,
#              COLUMN g_c[33],sr.apf02,
#              COLUMN g_c[34],sr.apf01,
#              COLUMN g_c[35],sr.apf03,
#              COLUMN g_c[36],sr.apf12,
#              COLUMN g_c[37],sr.apf06,
#              COLUMN g_c[38],cl_numfor(sr.apf08,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(sr.apf09,39,g_azi05);
#        INSERT INTO curr_tmp VALUES(sr.apf06,sr.apf08,sr.apf09,0)   #MOD-730134
#
#        LET apf08_t1 = apf08_t1 + sr.apf08
#        LET apf08_t2 = apf08_t2 + sr.apf08
#        LET apf08_t3 = apf08_t3 + sr.apf08
#        LET apf09_t1 = apf09_t1 + sr.apf09
#        LET apf09_t2 = apf09_t2 + sr.apf09
#        LET apf09_t3 = apf09_t3 + sr.apf09
#
#     ON EVERY ROW
#         #--No.MOD-4A0267--#
#        PRINT COLUMN g_c[40],sr.aph03a,
#              COLUMN g_c[41],cl_numfor(sr.aph05,41,g_azi04),   #付款金額
#              COLUMN g_c[42],sr.aph07,
#              COLUMN g_c[43],sr.aph08,     #開票銀行
#              COLUMN g_c[44],sr.nma02,     #開票銀行
#              COLUMN g_c[45],sr.nmd02
#        #-------END-------#
#
#
#TQC-6A0088    --begin--                                                                                                   
#         #INSERT INTO curr_tmp VALUES(sr.apf06,sr.apf08,sr.apf09,sr.aph05)   #MOD-730134                                                          
#         INSERT INTO curr_tmp VALUES(sr.apf06,0,0,sr.aph05)   #MOD-730134                                                          
#        #TQC-6A0088    ---end---
#
#     AFTER GROUP OF sr.order1
#        IF tm.u[1,1] = 'Y' THEN
#           PRINT ''
#           LET l_amt = GROUP SUM(sr.aph05)
#           PRINT COLUMN g_c[36],g_orderA[1] CLIPPED,
#                 COLUMN g_c[37],g_x[16] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(apf08_t1,38,g_azi05),
#                 COLUMN g_c[39],cl_numfor(apf09_t1,39,g_azi05),
#                 COLUMN g_c[41],cl_numfor(l_amt   ,41,g_azi05)
#           PRINT ''
#        END IF
#
#     AFTER GROUP OF sr.order2
#        IF tm.u[2,2] = 'Y' THEN
#           LET l_amt = GROUP SUM(sr.aph05)
#           PRINT COLUMN g_c[36],g_orderA[2] CLIPPED,
#                 COLUMN g_c[37],g_x[16] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(apf08_t2,38,g_azi05),
#                 COLUMN g_c[39],cl_numfor(apf09_t2,39,g_azi05),
#                 COLUMN g_c[41],cl_numfor(l_amt   ,41,g_azi05)
#           PRINT ''
#        END IF
#
#     ON LAST ROW
#        LET l_amt = SUM(sr.aph05)
#        PRINT
#TQC-6A0088  -begin---- 
#       FOREACH tmp4_cs INTO sr1.*                                                                                                    
#         SELECT azi05 INTO g_azi05 FROM azi_file                                                                                   
#          WHERE azi01 = sr1.curr                                                                                                   
#         PRINT COLUMN g_c[36],g_x[17] CLIPPED,                                                                                     
#               COLUMN g_c[37],sr1.curr CLIPPED,                                                                                    
#              COLUMN g_c[38],cl_numfor(sr1.amt1,38,g_azi05),                                                                       
#              COLUMN g_c[39],cl_numfor(sr1.amt2,39,g_azi05),                                                                       
#              COLUMN g_c[41],cl_numfor(sr1.amt3,41,g_azi05)                                                                        
#    END FOREACH                                                                                                                    
##        PRINT
#        PRINT COLUMN g_c[37],g_x[17] CLIPPED,
#              COLUMN g_c[38],cl_numfor(apf08_t3,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(apf09_t3,39,g_azi05),
#              COLUMN g_c[41],cl_numfor(l_amt   ,41,g_azi05)
#        PRINT
#TQC-6A0088  -end----
 
#        FOR i = 1 TO 40
#           IF g_tot[i] != 0 THEN
#              PRINT COLUMN g_c[38],g_x[25] CLIPPED,
#                    COLUMN g_c[39],g_due[i],
#                    COLUMN g_c[40],g_x[26] CLIPPED,
#                    COLUMN g_c[41],cl_numfor(g_tot[i],41,g_azi05)
#           END IF
#        END FOR
#
#        IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#           CALL cl_wcchp(tm.wc,'apf01,apf02,apf12,apf04,apf05') RETURNING tm.wc
#           PRINT g_dash[1,g_len]
#           #TQC-630166
#           #IF tm.wc[001,070] > ' ' THEN            # for 80
#           #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#           #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
#           #END IF
#           #IF tm.wc[071,140] > ' ' THEN
#           #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#           #END IF
#           #IF tm.wc[141,210] > ' ' THEN
#           #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#           #END IF
#           #IF tm.wc[211,280] > ' ' THEN
#           #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#           #END IF
#           CALL cl_prt_pos_wc(tm.wc)
#           #END TQC-630166
#        END IF
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
# #      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[45],g_x[7] CLIPPED       #TQC-6A0088
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED       #TQC-6A0088
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
# #         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[45],g_x[6] CLIPPED    #TQC-6A0099
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #TQC-6A0099
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-7A0025-MARK-END--
