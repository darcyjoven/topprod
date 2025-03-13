# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr116.4gl
# Descriptions...: 會計核算報表
# Date & Author..: 06/03/30 By ice
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0073 06/11/06 By xufeng  修改報表
# Modify.........: No.TQC-6A0094 06/11/27 By johnray 報表修改
# Modify.........: No.FUN-6c0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-710056 07/01/29 By Carrier 匯出規則改變
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730070 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務-修改
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: No.FUN-780057 07/08/28 By mike 報表輸出格式改為Crystal Reports
# Modify.........: No.MOD-860252 09/02/03 By chenl  增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能.
# Modify.........: No.MOD-920221 09/02/20 By liuxqa 報表打印時報錯，當tm.e的取值為空時，預設值為2位。
# Modify.........: No.MOD-930159 09/03/19 By Sarah 執行gglr113,gglr114,gglr115時無法列印報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          rtype   LIKE type_file.num5,    #NO FUN-690009   VARCHAR(1)
          a       LIKE maj_file.maj01,    #NO FUN-690009   VARCHAR(6)    #報表結構編號
          b       LIKE aah_file.aah00,    #帳別編號
          yy1     LIKE aah_file.aah02,    #NO FUN-690009   SMALLINT   #輸入年度
          bm1     LIKE aah_file.aah03,    #NO FUN-690009   SMALLINT   #Begin 期別
          em1     LIKE aah_file.aah03,    #NO FUN-690009   SMALLINT   # End  期別
          c       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #異動額及餘額為0者是否列印
          d       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #金額單位
          e       LIKE azi_file.azi05,    #NO FUN-690009   SMALLINT   #小數位數
          f       LIKE maj_file.maj08,    #NO FUN-690009   SMALLINT   #列印最小階數
          h       LIKE ze_file.ze03,      # Prog. Version..: '5.30.06-13.03.12(04)   #額外說明類別
          i       LIKE type_file.chr1,    #No.MOD-860252   #僅貨幣性科目
          o       LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #轉換幣別否
          p       LIKE azi_file.azi01,    #幣別
          q       LIKE azj_file.azj03,    #匯率
          r       LIKE azi_file.azi01,    #幣別
          more    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)    #Input more condition(Y/N)
      END RECORD,
          bdate,edate   LIKE type_file.dat,     #NO FUN-690009   DATE
          i,j,k         LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          g_unit        LIKE type_file.num10,   #NO FUN-690009   INTEGER     #金額單位基數
          g_bookno      LIKE aah_file.aah00,    #帳別
          g_mai02       LIKE mai_file.mai02,
          g_mai03       LIKE mai_file.mai03,
          g_tot1        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6) #當期
          g_tot2        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6) #年初
          g_tot3        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6) #期間
          g_tot4        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot5        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot6        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot7        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_tot8        ARRAY[100] OF LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
          g_basetot1    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot2    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot3    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot4    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot5    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot6    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot7    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_basetot8    LIKE type_file.num20_6,  #NO FUN-690009   DEC(20,6)
          g_argv1       LIKE type_file.chr1,     #NO FUN-690009   VARCHAR(01)  
                                                 #報表類型 1:資產負債
                                                 #2:利潤表 3:現金流量表 4:應交增值稅明細表
                                                 #5:資產減值明細表 6:股東權益增減變動表 7:利潤分配表
          g_name        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(60)   #FILENAME
          g_flag        LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #Y:產生接口數據 N:會計報表打印
          g_ym          LIKE type_file.chr8     # Prog. Version..: '5.30.06-13.03.12(08)   #報告期(日)
 
#No.FUN-570087  --start
DEFINE   g_formula   DYNAMIC ARRAY OF RECORD
                        maj02        LIKE maj_file.maj02,
                        maj27        LIKE maj_file.maj27,
                        lbal1,lbal2  LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
                        bal1,bal2    LIKE type_file.num20_6,    #NO FUN-690009   DEC(20,6)
                        tbal0,tbal1  LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)
                     END RECORD,
         g_sql       STRING,                   # 查詢語句
         g_for_str   STRING,                   # 當前公式內容
         g_ser_str   STRING,                   # 歷史序號
         g_str_len   LIKE type_file.num5,    #NO FUN-690009   SMALLINT    # 循環計算公式長度中所有出現序號
         g_str_cnt   LIKE type_file.num5,    #NO FUN-690009   SMALLINT    # 循環計數
         g_for_cnt   LIKE type_file.num5,    #NO FUN-690009   SMALLINT    # 從第一筆序號計算出結果開始查詢
         g_beg_pos   LIKE type_file.num5,    #NO FUN-690009   SMALLINT    # 開始位置
         g_end_pos   LIKE type_file.num5,    #NO FUN-690009   SMALLINT    # 結束位置
         g_lbasetot1 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)   # 基准百分比
#        g_lbasetot2 LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)  # 基准百分比
         g_ltot1     ARRAY[100] OF LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)   # 計算上月合計金額
#        g_ltot2     ARRAY[100] OF LIKE type_file.num20_6     #NO FUN-690009   DEC(20,6)   # 計算本年合計金額
#No.FUN-570087  --end
DEFINE   g_aaa03     LIKE aaa_file.aaa03
DEFINE   g_i         LIKE type_file.num5     #NO FUN-690009   SMALLINT     #count/index for any purpose
DEFINE   g_msg       LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(72)
 
#No.FUN-780057  --str
DEFINE   g_str       STRING        
DEFINE   l_table     STRING
#No.FUN-780057  --end
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                             # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-780057  --str
   LET g_sql="maj02.maj_file.maj02,",   #項次(排序要用的)
             "maj03.maj_file.maj03,",   #列印碼
             "maj04.maj_file.maj04,",
             "maj06.maj_file.maj06,",
             "maj07.maj_file.maj07,",
             "maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,",
             "maj26.maj_file.maj26,",
             "bal1.type_file.num20_6,",
             "tbal0.type_file.num20_6,",
             "tbal1.type_file.num20_6,",
             "l_amt0.type_file.num20_6,",
             "l_amt1.type_file.num20_6,",
             "l_amt2.type_file.num20_6,",
             "l_amt3.type_file.num20_6,",
             "l_amt4.type_file.num20_6,",
             "l_tot.type_file.num20_6,",
             "l_tot0.type_file.num20_6,",
             "l_tot2.type_file.num20_6,",
             "l_tot3.type_file.num20_6,",
             "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空行
 
   LET l_table = cl_prt_temptable('gglr116',g_sql) CLIPPED   # 產生Temp Table 
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                   
   #No.FUN-780057  --end
 
   LET g_flag  = 'N'
   LET g_argv1 = NULL
   INITIALIZE tm.* TO NULL          # Default condition
   LET tm.rtype  = '2'              # default trace off
   LET g_argv1   = ARG_VAL(1)
   LET tm.a      = ARG_VAL(2)
   LET tm.yy1    = ARG_VAL(3)
   LET tm.bm1    = ARG_VAL(4)
   LET tm.em1    = ARG_VAL(5)
   LET g_name    = ARG_VAL(6)
   LET tm.b      = ARG_VAL(7)  #No.FUN-730070
   IF g_argv1 MATCHES '[1]' THEN
      LET tm.rtype  = '1'           # default trace off 資產負債表
   ELSE
      LET tm.rtype  = '2'           # default trace off 損益表
   END IF
   CASE g_argv1
      WHEN "4"  LET g_prog = 'gglr114' #應交增值稅明細表
      WHEN "7"  LET g_prog = 'gglr115' #利潤分配表
      WHEN "6"  LET g_prog = 'gglr113' #股東權益增減變動表
      WHEN "5"  LET g_prog = 'gglr116' #資產減值准備明細表
      OTHERWISE IF cl_null(g_argv1) THEN LET g_argv1= '5' END IF
                LET g_prog = 'gglr116'
   END CASE
#  LET g_bookno  = ARG_VAL(1)
#  LET g_pdate   = ARG_VAL(2)       # Get arguments from command line
#  LET g_towhom  = ARG_VAL(3)
#  LET g_rlang   = ARG_VAL(4)
#  LET g_bgjob   = ARG_VAL(5)
#  LET g_prtway  = ARG_VAL(6)
#  LET g_copies  = ARG_VAL(7)
#  LET tm.a      = ARG_VAL(8)
#  LET tm.yy1    = ARG_VAL(9)
#  LET tm.bm1    = ARG_VAL(10)
#  LET tm.em1    = ARG_VAL(11)
#  LET tm.c      = ARG_VAL(12)
#  LET tm.d      = ARG_VAL(13)
#  LET tm.e      = ARG_VAL(14)
#  LET tm.f      = ARG_VAL(15)
#  LET tm.h      = ARG_VAL(16)
#  LET tm.o      = ARG_VAL(17)
#  LET tm.p      = ARG_VAL(18)
#  LET tm.q      = ARG_VAL(19)
#  LET g_rep_user= ARG_VAL(20)
#  LET g_rep_clas= ARG_VAL(21)
#  LET g_template= ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
   #No.FUN-740033  --Begin
   IF cl_null(tm.b) THEN
      LET tm.b = g_aaz.aaz64
   END IF
   #No.FUN-740033  --End  
   IF NOT (cl_null(g_argv1) OR cl_null(tm.a) OR cl_null(tm.yy1)) THEN
      LET g_flag = 'Y'
      IF g_argv1 = '1' THEN
         CALL s_azn01(tm.yy1,tm.bm1) RETURNING bdate,edate
         LET g_ym = edate USING 'YYYYMMDD'
      ELSE
         LET g_ym = tm.yy1 USING '&&&&',tm.bm1 USING '&&'
      END IF
#     LET tm.b = g_bookno  #No.FUN-730070
      IF cl_null(tm.c) THEN LET tm.c = 'Y' END IF       #打印余額為零者
      IF cl_null(tm.d) THEN LET tm.d = '1' END IF       #金額單位
      SELECT mai02 INTO g_mai02 FROM mai_file WHERE mai01 = tm.a
                                                AND mai00 = tm.b   #No.FUN-730070
      #使用預設帳別之幣別
#     SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno  #No.FUN-730070
      SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b      #No.FUN-730070
      IF SQLCA.sqlcode THEN 
#          CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660124
           CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)     #No.FUN-660124  #No.FUN-730070
      END IF
      IF cl_null(tm.e) THEN
         #使用預設帳別之幣別之小數位數
#        SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('sel azi:',SQLCA.sqlcode,0)
            LET tm.e = 2
#        END IF
      END IF
      IF cl_null(tm.f) THEN LET tm.f = 0 END IF         #打印最小階
      IF cl_null(tm.h) THEN LET tm.h = 'N' END IF       #依科目額外說明打印
      IF cl_null(tm.o) THEN LET tm.o = 'N' END IF       #轉換幣別
      IF cl_null(tm.r) THEN LET tm.r = g_aaa03 END IF   #總帳幣種
      IF cl_null(tm.p) THEN LET tm.p = g_aaa03 END IF   #轉換幣種
      IF cl_null(tm.q) THEN LET tm.q = 1 END IF         #乘匯率
      IF cl_null(tm.i) THEN LET tm.i = 'Y' END IF       #No.MOD-860252
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF g_flag = 'N' THEN
      IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN # If background job sw is off
         CALL r116_tm()                           # Input print condition
      ELSE
         CALL r116()                              # Read data and create out-file
      END IF
   ELSE
      CALL r116()                                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r116_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_sw           LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5     #FUN-6C0068
 
   CALL s_dsmark(tm.b)  #No.FUN-730070
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r116_w AT p_row,p_col WITH FORM "ggl/42f/gglr116"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   IF g_argv1 = '5' OR   #資產減值准備明細表
      g_argv1 = '6' THEN #股東權益增減變動表
      CALL cl_set_comp_visible("bm1",FALSE)
   END IF
   CALL cl_set_comp_visible("em1",FALSE)
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,tm.b)  #No.FUN-730070
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b  #No.FUN-730070
   IF SQLCA.sqlcode THEN 
#      CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660124
       CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)     #No.FUN-660124  #No.FUN-730070
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#       CALL cl_err('sel azi:',SQLCA.sqlcode,0)   #No.FUN-660124
        CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)     #No.FUN-660124
        LET tm.e = 2     #No.MOD-920221 add by liuxqa 預設小數位為二位。       
   END IF
#  LET tm.b = g_bookno  #No.FUN-730070
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.i = 'Y'     #No.MOD-860252
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      LET l_sw = 1
      INPUT BY NAME tm.b,tm.a,  #No.FUN-740033
                    tm.yy1,tm.bm1,tm.em1,
                    tm.c,tm.d,tm.e,tm.f,tm.h,tm.i,tm.o,tm.r, #No.MOD-860252 add tm.i
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF tm.b IS NULL THEN NEXT FIELD b END IF  #No.FUN-740033
            IF tm.a IS NULL THEN NEXT FIELD a END IF
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
            IF g_argv1 = '1' THEN
               SELECT mai02,mai03 INTO g_mai02,g_mai03
                 FROM mai_file
                WHERE mai01 = tm.a AND maiacti = 'Y'
                  AND mai03 = '2'
                  AND mai00 = tm.b  #No.FUN-730070
            ELSE
               SELECT mai02,mai03 INTO g_mai02,g_mai03
                 FROM mai_file
                WHERE mai01 = tm.a AND maiacti = 'Y'
                  AND mai03 <> '2'
                  AND mai00 = tm.b  #No.FUN-730070
            END IF
            IF SQLCA.sqlcode THEN
#              CALL cl_err('sel mai:',SQLCA.sqlcode,0)    No.FUN-660124
               CALL cl_err3("sel","mai_file",tm.a,"",SQLCA.sqlcode,"","sel mai:",0)   #No.FUN-660124
               NEXT FIELD a
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
 
         AFTER FIELD b
            IF tm.b IS NULL THEN NEXT FIELD b END IF
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti = 'Y'
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660124
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660124
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD yy1
            IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
               NEXT FIELD yy1
            END IF
 
         BEFORE FIELD bm1
            IF tm.rtype='1' THEN
               LET tm.bm1 = 0 DISPLAY '' TO bm1
            END IF
 
         AFTER FIELD bm1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
#No.TQC-720032 -- begin --
#            IF tm.bm1 <1 OR tm.bm1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm1
#            END IF
#No.TQC-720032 -- end --
            LET tm.em1 = tm.bm1
         AFTER FIELD em1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
#No.TQC-720032 -- begin --
#            IF tm.em1 <1 OR tm.em1 > 13 THEN
#               CALL cl_err('','agl-013',0) NEXT FIELD em1
#            END IF
#No.TQC-720032 -- end --
            IF tm.bm1 > tm.em1 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD bm1
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[1234]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 10000 END IF
            IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
 
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
 
         BEFORE FIELD p
            IF tm.o = 'N' THEN NEXT FIELD more END IF
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN 
#                CALL cl_err(tm.p,'agl-109',0)    #No.FUN-660124 
                 CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)    #No.FUN-660124
            NEXT FIELD p 
            END IF
 
         BEFORE FIELD q
            IF tm.o = 'N' THEN NEXT FIELD o END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.yy1 IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy1
               CALL cl_err('',9033,0)
            END IF
            IF NOT (g_argv1 = '5' OR   #資產減值准備明細表
                    g_argv1 = '6') THEN #股東權益增減變動表
               IF tm.bm1 IS NULL THEN
                  LET l_sw = 0
                  DISPLAY BY NAME tm.bm1
               END IF
            END IF
#           IF tm.em1 IS NULL THEN
#              LET l_sw = 0
#              DISPLAY BY NAME tm.em1
#           END IF
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 10000 END IF
            IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT INPUT
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  IF g_argv1 = '1' THEN
                     LET g_qryparam.where = " mai03 = '2' "
                  ELSE
                    #LET g_qryparam.where = " mai03 != '2' "   #No.TQC-C50042   Mark
                     LET g_qryparam.where = " mai03 NOT IN ('2','5','6') "   #No.TQC-C50042   Add
                  END IF
                  LET g_qryparam.default1 = tm.a
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
 
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
 
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY BY NAME tm.p
                  NEXT FIELD p
            END CASE
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r116_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='gglr116'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr116','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.b CLIPPED,"'" ,  #No.FUN-730070
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.yy1 CLIPPED,"'",
                        " '",tm.bm1 CLIPPED,"'",
                        " '",tm.em1 CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gglr116',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r116_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r116()
      ERROR ""
   END WHILE
   CLOSE WINDOW r116_w
END FUNCTION
 
FUNCTION r116()
   DEFINE l_name    LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)  # External(Disk) file name
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0097
   DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)# RDSQL STATEMENT
   DEFINE l_chr     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(40)
   DEFINE amt1      LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #當期數
   DEFINE tamt0     LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #年初數
   DEFINE tamt1     LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #期間發生數(年初-當期)
   DEFINE l_amt0    LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #年初余額
   DEFINE l_aag06   LIKE aag_file.aag06
   DEFINE l_amt1    LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #本年增加數
   DEFINE l_amt2    LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #本年轉回數
   DEFINE l_amt3    LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
   DEFINE l_amt4    LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
   DEFINE ll_amt0   LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #年初余額
   DEFINE ll_amt1   LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #本年增加數
   DEFINE ll_amt2   LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6) #本年轉回數
   DEFINE ll_amt3   LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
   DEFINE ll_amt4   LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
   # No.FUN-570087  --begin
   DEFINE lamt1     LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)  #上月統計金額
   DEFINE l_lendy1  LIKE abb_file.abb07
   DEFINE l_lendy2  LIKE abb_file.abb07
   # No.FUN-570087  --end
   DEFINE l_tmp     LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_year    LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE sr  RECORD
              bal1  LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)   #當期數
              tbal0 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)   #年初數
              tbal1 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)   #期間發生數
              lbal1 LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)   #No.FUN-570087 --add
              END RECORD,
          l_endy1   LIKE abb_file.abb07,
          l_endy2   LIKE abb_file.abb07
   DEFINE r116_tmp RECORD
             maj02  LIKE maj_file.maj02,    #NO FUN-690009   DEC(9,4)
             maj03  LIKE maj_file.maj03,    #NO FUN-690009   VARCHAR(01)
             maj04  LIKE maj_file.maj04,    #NO FUN-690009   SMALLINT
             maj06  LIKE maj_file.maj06,    #NO FUN-690009   VARCHAR(01)
             maj07  LIKE maj_file.maj07,    #NO FUN-690009   VARCHAR(01)
             maj20  LIKE maj_file.maj20,    #NO FUN-690009   VARCHAR(100)
             maj20e LIKE maj_file.maj20e,   #NO FUN-690009   VARCHAR(50)
             maj26  LIKE maj_file.maj26,    #NO FUN-690009   SMALLINT
             bal1   LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)     #當期異動數
             tbal0  LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)     #年初數
             tbal1  LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)     #期間發生數
             l_amt0 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)
             l_amt1 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)
             l_amt2 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)
             l_amt3 LIKE type_file.num20_6,   #NO FUN-690009   DEC(20,6)
             l_amt4 LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
                END RECORD
   #No.FUN-780057  --STR
   DEFINE  l_tot LIKE type_file.num20_6
   DEFINE  l_tot0 LIKE type_file.num20_6
   DEFINE  l_tot1 LIKE type_file.num20_6
   DEFINE  l_tot2 LIKE  type_file.num20_6
   DEFINE  l_tot3 LIKE type_file.num20_6
   DEFINE  l_unit LIKE zaa_file.zaa08
   DEFINE  per1 LIKE fid_file.fid03
   #No.FUN-780057  --end 
   DEFINE  l_gaz06 LIKE gaz_file.gaz06   #MOD-930159 add
   DEFINE  l_prog  LIKE zz_file.zz01     #MOD-930159 add
 
#NO.FUN_690009--------------------begin--------------------------------                                                                        
   DROP TABLE tmp_file
   CREATE TEMP TABLE tmp_file(
        maj02  LIKE maj_file.maj02,
        maj03  LIKE maj_file.maj03,
        maj04  LIKE maj_file.maj04,
        maj06  LIKE maj_file.maj06,
        maj07  LIKE maj_file.maj07,
        maj20  LIKE maj_file.maj20,
        maj20e LIKE maj_file.maj20e,
        maj26  LIKE maj_file.maj26,
        bal1   LIKE type_file.num20_6,
        tbal0  LIKE type_file.num20_6,
        tbal1  LIKE type_file.num20_6,
        l_amt0 LIKE type_file.num20_6,
        l_amt1 LIKE type_file.num20_6,
        l_amt2 LIKE type_file.num20_6,
        l_amt3 LIKE type_file.num20_6,
        l_amt4 LIKE type_file.num20_6)
#NO.FUN_690009--------------------END----------------------------------------- 
   #No.FUN-B80096--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   #No.FUN-780057  --str
   CALL cl_del_data(l_table)
   LET l_unit=''
   #No.FUN-780057  --end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang  #MOD-730146 modify
#  SELECT aaf03 INTO g_company
#    FROM aaf_file
#   WHERE aaf01 = tm.b
#     AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r116_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE r116_c CURSOR FOR r116_p
 
   FOR g_i = 1 TO 100
       LET g_tot1[g_i] = 0
       LET g_tot2[g_i] = 0
       LET g_tot3[g_i] = 0
       LET g_tot4[g_i] = 0
       LET g_tot5[g_i] = 0
       LET g_tot6[g_i] = 0
       LET g_tot7[g_i] = 0
       LET g_tot8[g_i] = 0
       LET g_ltot1[g_i] = 0  #No.FUN-570087 按照公式計算上月相關金額
   END FOR
   CALL g_formula.clear()
   LET g_i = 0
   FOREACH r116_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      LET tamt0 = 0
      LET tamt1 = 0
      LET l_amt0 = 0
      LET l_amt1 = 0
      LET l_amt2 = 0
      LET l_amt3 = 0
      LET l_amt4 = 0
      #No.FUN-570087   --begin 按照公式計算上月相關金額
      LET lamt1 = 0
      IF maj.maj06 NOT MATCHES '[123456789]' THEN
         CONTINUE FOREACH
      END IF
 
      CASE g_argv1
         WHEN "4"        #應交增值稅明細表
            IF NOT cl_null(maj.maj21) THEN
               #No.MOD-860252--begin--
               IF tm.i = 'Y' THEN 
                  SELECT SUM(aah04),SUM(aah05) INTO tamt0,l_amt0
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 = 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                     AND aag09 ='Y' 
                  SELECT SUM(aah04),SUM(aah05) INTO tamt1,l_amt1
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                     AND aag09 ='Y'
                  SELECT SUM(aah04),SUM(aah05) INTO amt1,l_amt2
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                     AND aag09 ='Y'
                  SELECT SUM(aah04),SUM(aah05) INTO l_amt3,l_amt4
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 > 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070 
                     AND aag09 ='Y'             
               END IF 
               #No.MOD-860252---end---
               IF tm.i = 'N' THEN    #No.MOD-860252
                  SELECT SUM(aah04),SUM(aah05) INTO tamt0,l_amt0
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 = 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                  SELECT SUM(aah04),SUM(aah05) INTO tamt1,l_amt1
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                  SELECT SUM(aah04),SUM(aah05) INTO amt1,l_amt2
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                  SELECT SUM(aah04),SUM(aah05) INTO l_amt3,l_amt4
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 > 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
               END IF     #No.MOD-860252
            END IF
            IF amt1 IS NULL THEN LET amt1 = 0 END IF
            IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
            IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
            IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
            IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
            IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
            IF l_amt3 IS NULL THEN LET l_amt3 = 0 END IF
            IF l_amt4 IS NULL THEN LET l_amt4 = 0 END IF
            LET ll_amt0 = l_amt0
            LET ll_amt1 = l_amt1
            LET ll_amt2 = l_amt2
            LET ll_amt3 = l_amt3
            LET ll_amt4 = l_amt4
            #匯率的轉換
            IF tm.o = 'Y' THEN
               LET amt1 = amt1 * tm.q
               LET tamt0 = tamt0 * tm.q
               LET tamt1 = tamt1 * tm.q
               LET ll_amt0 = ll_amt0 * tm.q
               LET ll_amt1 = ll_amt1 * tm.q
               LET ll_amt2 = ll_amt2 * tm.q
               LET ll_amt3 = ll_amt3 * tm.q
               LET ll_amt4 = ll_amt4 * tm.q
            END IF
            IF maj.maj03 MATCHES "[012H]" AND maj.maj08 > 0	THEN #合計階數處理
               FOR i = 1 TO 100
                  #合計加/減項的處理
                  IF maj.maj09 = '-' THEN
                     LET g_tot1[i]=g_tot1[i]-amt1
                     LET g_tot2[i]=g_tot2[i]-tamt0
                     LET g_tot3[i]=g_tot3[i]-tamt1
                     LET g_tot4[i]=g_tot4[i]-ll_amt0
                     LET g_tot5[i]=g_tot5[i]-ll_amt1
                     LET g_tot6[i]=g_tot6[i]-ll_amt2
                     LET g_tot7[i]=g_tot7[i]-ll_amt3
                     LET g_tot8[i]=g_tot8[i]-ll_amt4
                  ELSE
                     LET g_tot1[i]=g_tot1[i]+amt1
                     LET g_tot2[i]=g_tot2[i]+tamt0
                     LET g_tot3[i]=g_tot3[i]+tamt1
                     LET g_tot4[i]=g_tot4[i]+ll_amt0
                     LET g_tot5[i]=g_tot5[i]+ll_amt1
                     LET g_tot6[i]=g_tot6[i]+ll_amt2
                     LET g_tot7[i]=g_tot7[i]+ll_amt3
                     LET g_tot8[i]=g_tot8[i]+ll_amt4
                  END IF
                  #No.FUN-570087  --begin  按照公式計算上月相關金額
                   # 注意 ︰ 本年合計不變
                   LET g_ltot1[i]=g_ltot1[i]+lamt1
                   #No.FUN-570087  --end
               END FOR
               LET k=maj.maj08
               LET sr.bal1=g_tot1[k]
               LET sr.tbal0=g_tot2[k]
               LET sr.tbal1=g_tot3[k]
               LET l_amt0 = g_tot4[k]
               LET l_amt1 = g_tot5[k]
               LET l_amt2 = g_tot6[k]
               LET l_amt3 = g_tot7[k]
               LET l_amt4 = g_tot8[k]
               LET sr.lbal1=g_ltot1[k]
               FOR i = 1 TO maj.maj08
                   LET g_tot1[i]=0
                   LET g_tot2[i]=0
                   LET g_tot3[i]=0
                   LET g_tot4[i]=0
                   LET g_tot5[i]=0
                   LET g_tot6[i]=0
                   LET g_tot7[i]=0
                   LET g_tot8[i]=0
                   LET g_ltot1[i]=0
               END FOR
            ELSE
               IF maj.maj03='5' THEN
                  LET sr.bal1=amt1
                  LET sr.tbal0=tamt0
                  LET sr.tbal1=tamt1
                  LET l_amt0 = ll_amt0
                  LET l_amt1 = ll_amt1
                  LET l_amt2 = ll_amt2
                  LET l_amt3 = ll_amt3
                  LET l_amt4 = ll_amt4
                  LET sr.lbal1=lamt1
               ELSE
                  LET sr.bal1=0
                  LET sr.tbal0=0
                  LET sr.tbal1=0
                  LET l_amt0 = 0
                  LET l_amt1 = 0
                  LET l_amt2 = 0
                  LET l_amt3 = 0
                  LET l_amt4 = 0
                  LET sr.lbal1=0
               END IF
            END IF
            IF maj.maj11 = 'Y' THEN			# 百分比基準科目
               LET g_basetot1=sr.bal1
               LET g_basetot2=sr.tbal0
               LET g_basetot3=sr.tbal1
               LET g_basetot4=l_amt0
               LET g_basetot5=l_amt1
               LET g_basetot6=l_amt2
               LET g_basetot7=l_amt3
               LET g_basetot8=l_amt4
               #No.FUN-570087  --begin 按照公式計算上月相關金額
               LET g_lbasetot1=sr.lbal1
               IF maj.maj07='2' THEN
                  LET g_basetot1=g_basetot1*-1
                  LET g_basetot2=g_basetot2*-1
                  LET g_basetot3=g_basetot3*-1
                  LET g_basetot4=g_basetot4*-1
                  LET g_basetot5=g_basetot5*-1
                  LET g_basetot6=g_basetot6*-1
                  LET g_basetot7=g_basetot7*-1
                  LET g_basetot8=g_basetot8*-1
                  LET g_lbasetot1=g_lbasetot1*-1
               END IF
               #No.FUN-570087  --end
            END IF
            IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
            IF cl_null(sr.tbal0) THEN LET sr.tbal0 = 0 END IF
            IF cl_null(sr.tbal1) THEN LET sr.tbal1 = 0 END IF
            IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF
            IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
            IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
            IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
            IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
            #No.FUN-780057  --STR                                                                                                
               IF tm.h = 'Y' THEN                                                                                                   
                  LET maj.maj20 = maj.maj20e                                                                                        
               END IF                                                                                                               
            #No.FUN-780057  --END 
 
            IF (NOT cl_null(maj.maj05)) AND maj.maj05 > 0 THEN
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
            END IF
            INSERT INTO tmp_file
               VALUES(maj.maj02,maj.maj03,maj.maj04,maj.maj06,
                      maj.maj07,maj.maj20,maj.maj20e,maj.maj26,
                      sr.bal1,sr.tbal0,sr.tbal1,
                      l_amt0,l_amt1,l_amt2,l_amt3,l_amt4)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('insert tmp',SQLCA.sqlcode,0)   #No.FUN-660124
               CALL cl_err3("ins","tmp_file","","",SQLCA.sqlcode,"","insert tmp",0)   #No.FUN-660124
               CONTINUE FOREACH
            END IF
         WHEN "5"        #資產減值准備明細表
            IF NOT cl_null(maj.maj21) THEN
               #No.MOD-860252--begin-- add
               IF tm.i = 'Y' THEN 
                  SELECT SUM(aah04-aah05) INTO l_amt0
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 = 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                     AND aag09 = 'Y' 
                  SELECT SUM(aah04),SUM(aah05) INTO l_amt1,l_amt2
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 > 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070 
                     AND aag09 = 'Y'              
               END IF 
               #No.MOD-860252---end---
               IF tm.i = 'N' THEN  #No.MOD-860252
                  SELECT SUM(aah04-aah05) INTO l_amt0
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 = 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
                  SELECT SUM(aah04),SUM(aah05) INTO l_amt1,l_amt2
                    FROM aah_file,aag_file
                   WHERE aah00 = tm.b
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22
                     AND aah02 = tm.yy1 AND aah03 > 0
                     AND aah01 = aag01
                     AND aag07 IN ('2','3')  #No.FUN-710056
                     AND aah00 = aag00       #No.FUN-730070
               END IF    #No.MOD-860252
               IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
               IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
               IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
               LET ll_amt0 = l_amt0
               LET ll_amt1 = l_amt1
               LET ll_amt2 = l_amt2
               #匯率的轉換
               IF tm.o = 'Y' THEN
                  LET ll_amt0 = ll_amt0 * tm.q
                  LET ll_amt1 = ll_amt1 * tm.q
                  LET ll_amt2 = ll_amt2 * tm.q
               END IF
               IF maj.maj03 MATCHES "[012H]" AND maj.maj08 > 0	THEN #合計階數處理
                  FOR i = 1 TO 100
                      LET g_tot4[i]=g_tot4[i]+ll_amt0
                      LET g_tot5[i]=g_tot5[i]+ll_amt1
                      LET g_tot6[i]=g_tot6[i]+ll_amt2
                      #No.FUN-570087  --begin  按照公式計算上月相關金額
                      # 注意 ︰ 本年合計不變
                      LET g_ltot1[i]=g_ltot1[i]+lamt1
                      #No.FUN-570087  --end
                  END FOR
                  LET k=maj.maj08
                  LET l_amt0 = g_tot4[k]
                  LET l_amt1 = g_tot5[k]
                  LET l_amt2 = g_tot6[k]
                  LET sr.lbal1=g_ltot1[k]
                  FOR i = 1 TO maj.maj08
                      LET g_tot4[i]=0
                      LET g_tot5[i]=0
                      LET g_tot6[i]=0
                      LET g_ltot1[i]=0
                  END FOR
               ELSE
                  IF maj.maj03='5' THEN
                     LET l_amt0 = ll_amt0
                     LET l_amt1 = ll_amt1
                     LET l_amt2 = ll_amt2
                     LET sr.lbal1=lamt1
                  ELSE
                     LET l_amt0 = 0
                     LET l_amt1 = 0
                     LET l_amt2 = 0
                     LET sr.lbal1=0
                  END IF
               END IF
               IF maj.maj11 = 'Y' THEN			# 百分比基準科目
                  LET g_basetot4=l_amt0
                  LET g_basetot5=l_amt1
                  LET g_basetot6=l_amt2
                  #No.FUN-570087  --begin 按照公式計算上月相關金額
                  LET g_lbasetot1=sr.lbal1
                  IF maj.maj07='2' THEN
                     LET g_basetot4=g_basetot4*-1
                     LET g_basetot5=g_basetot5*-1
                     LET g_basetot6=g_basetot6*-1
                     LET g_lbasetot1=g_lbasetot1*-1
                  END IF
                  #No.FUN-570087  --end
               END IF
            END IF
            IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
            IF cl_null(sr.tbal0) THEN LET sr.tbal0 = 0 END IF
            IF cl_null(sr.tbal1) THEN LET sr.tbal1 = 0 END IF
            IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF
            IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
            IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
            IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
            IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
            #No.FUN-780057  --STR                                                                                                
               IF tm.h = 'Y' THEN                                                                                                   
                  LET maj.maj20 = maj.maj20e                                                                                        
               END IF                                                                                                               
            #No.FUN-780057  --END 
 
            IF (NOT cl_null(maj.maj05)) AND maj.maj05 > 0 THEN
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
            END IF
            INSERT INTO tmp_file
               VALUES(maj.maj02,maj.maj03,maj.maj04,maj.maj06,
                      maj.maj07,maj.maj20,maj.maj20e,maj.maj26,
                      sr.bal1,sr.tbal0,sr.tbal1,
                      l_amt0,l_amt1,l_amt2,l_amt3,l_amt4)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('insert tmp',SQLCA.sqlcode,0)   #No.FUN-660124
               CALL cl_err3("ins","tmp_file","","",SQLCA.sqlcode,"","insert tmp",0)   #No.FUN-660124
               CONTINUE FOREACH
            END IF
         WHEN "6"        #股東權益增減變動表
            IF NOT cl_null(maj.maj21) THEN
               #CARRIER
               IF maj.maj02 >230 THEN
                  ERROR "CARRIER"
               END IF
               LET l_year = tm.yy1 - 1
               CASE maj.maj06
                  WHEN "4"    #借方
                     #No.MOD-860252--begin-- add
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04) INTO tamt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah04) INTO l_amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                     END IF 
                     #No.MOD-860252---end--- 
                     IF tm.i = 'N' THEN    #No.MOD-860252
                        SELECT SUM(aah04) INTO tamt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah04) INTO l_amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                     END IF    #No.MOD-860252
                  WHEN "5"    #貸方
                     #No.MOD-860252--begin-- add
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah05) INTO tamt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah05) INTO l_amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070   
                           AND aag09 = 'Y'                   
                     END IF 
                     #No.MOD-860252---end--- add
                     IF tm.i ='N' THEN   #No.MOD-860252
                        SELECT SUM(aah05) INTO tamt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah05) INTO l_amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                     END IF     #No.MOD-860252
                  OTHERWISE
                     #No.MOD-860252--begin--
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04-aah05) INTO amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 = 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah04-aah05) INTO tamt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah04-aah05) INTO tamt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah04-aah05) INTO l_amt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 = 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah04-aah05) INTO l_amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                        SELECT SUM(aah04-aah05) INTO l_amt2
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                           AND aag09 = 'Y'
                     END IF 
                     #No.MOD-860252---end---
                     IF tm.i = 'N' THEN   #No.MOD-860252
                        SELECT SUM(aah04-aah05) INTO amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 = 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah04-aah05) INTO tamt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah04-aah05) INTO tamt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah04-aah05) INTO l_amt0
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 = 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah04-aah05) INTO l_amt1
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year AND aah03 > 0
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                        SELECT SUM(aah04-aah05) INTO l_amt2
                          FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = l_year
                           AND aah01 = aag01 AND aag07 IN ('2','3')  #No.FUN-710056
                           AND aah00 = aag00       #No.FUN-730070
                     END IF   #No.MOD-860252
               END CASE
            END IF
            IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
            IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
            IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
            LET ll_amt0 = l_amt0
            LET ll_amt1 = l_amt1
            LET ll_amt2 = l_amt2
            IF amt1 IS NULL THEN LET amt1 = 0 END IF
            IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
            IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
            #匯率的轉換
            IF tm.o = 'Y' THEN
               LET sr.bal1 = sr.bal1 * tm.q
               LET sr.tbal0 = sr.tbal0 * tm.q
               LET sr.tbal1 = sr.tbal1 * tm.q
               LET ll_amt0 = ll_amt0 * tm.q
               LET ll_amt1 = ll_amt1 * tm.q
               LET ll_amt2 = ll_amt2 * tm.q
            END IF
            IF maj.maj03 MATCHES "[012H]" AND maj.maj08 > 0	THEN #合計階數處理
               FOR i = 1 TO 100
                   LET g_tot1[i]=g_tot1[i]+amt1
                   LET g_tot2[i]=g_tot2[i]+tamt0
                   LET g_tot3[i]=g_tot3[i]+tamt1
                   LET g_tot4[i]=g_tot4[i]+ll_amt0
                   LET g_tot5[i]=g_tot5[i]+ll_amt1
                   LET g_tot6[i]=g_tot6[i]+ll_amt2
                   #No.FUN-570087  --begin  按照公式計算上月相關金額
                   # 注意 ︰ 本年合計不變
                   LET g_ltot1[i]=g_ltot1[i]+lamt1
                   #No.FUN-570087  --end
               END FOR
               LET k=maj.maj08
               LET sr.bal1=g_tot1[k]
               LET sr.tbal0=g_tot2[k]
               LET sr.tbal1=g_tot3[k]
               LET l_amt0 = g_tot4[k]
               LET l_amt1 = g_tot5[k]
               LET l_amt2 = g_tot6[k]
               LET sr.lbal1=g_ltot1[k]
               FOR i = 1 TO maj.maj08
                   LET g_tot1[i]=0
                   LET g_tot2[i]=0
                   LET g_tot3[i]=0
                   LET g_tot4[i]=0
                   LET g_tot5[i]=0
                   LET g_tot6[i]=0
                   LET g_ltot1[i]=0
               END FOR
            ELSE
               IF maj.maj03='5' THEN
                  LET sr.bal1=amt1
                  LET sr.tbal0=tamt0
                  LET sr.tbal1=tamt1
                  LET l_amt0 = ll_amt0
                  LET l_amt1 = ll_amt1
                  LET l_amt2 = ll_amt2
                  LET sr.lbal1=lamt1
               ELSE
                  LET sr.bal1=0
                  LET sr.tbal0=0
                  LET sr.tbal1=0
                  LET l_amt0 = 0
                  LET l_amt1 = 0
                  LET l_amt2 = 0
                  LET sr.lbal1=0
               END IF
            END IF
            IF maj.maj11 = 'Y' THEN			# 百分比基準科目
               LET g_basetot1=sr.bal1
               LET g_basetot2=sr.tbal0
               LET g_basetot3=sr.tbal1
               LET g_basetot4=l_amt0
               LET g_basetot5=l_amt1
               LET g_basetot6=l_amt2
               #No.FUN-570087  --begin 按照公式計算上月相關金額
               LET g_lbasetot1=sr.lbal1
               IF maj.maj07='2' THEN
                  LET g_basetot1=g_basetot1*-1
                  LET g_basetot2=g_basetot2*-1
                  LET g_basetot3=g_basetot3*-1
                  LET g_basetot4=g_basetot4*-1
                  LET g_basetot5=g_basetot5*-1
                  LET g_basetot6=g_basetot6*-1
                  LET g_lbasetot1=g_lbasetot1*-1
               END IF
               #No.FUN-570087  --end
            END IF
            IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
            IF cl_null(sr.tbal0) THEN LET sr.tbal0 = 0 END IF
            IF cl_null(sr.tbal1) THEN LET sr.tbal1 = 0 END IF
            IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF
            IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
            IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
            IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
            IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
   
            #No.FUN-780057  --STR                                                                                                
               IF tm.h = 'Y' THEN                                                                                                   
                  LET maj.maj20 = maj.maj20e                                                                                        
               END IF                                                                                                               
            #No.FUN-780057  --END 
 
            IF (NOT cl_null(maj.maj05)) AND maj.maj05 > 0 THEN
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
            END IF
            INSERT INTO tmp_file
               VALUES(maj.maj02,maj.maj03,maj.maj04,maj.maj06,
                      maj.maj07,maj.maj20,maj.maj20e,maj.maj26,
                      sr.bal1,sr.tbal0,sr.tbal1,
                      l_amt0,l_amt1,l_amt2,l_amt3,l_amt4)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('insert tmp',SQLCA.sqlcode,0)   #No.FUN-660124
               CALL cl_err3("ins","tmp_file","","",SQLCA.sqlcode,"","insert tmp",0)   #No.FUN-660124
               CONTINUE FOREACH
            END IF
         OTHERWISE
            #新增按公式打印,累計已計算完成科目金額
            #若該科目沒維護公式字段，則正常計算金額
            IF cl_null(maj.maj27) THEN
               #新增僅借方/貸方 選擇金額合計
               CASE
                  WHEN maj.maj06='4'      ## 借方金額 科目借方之當期異動
                     IF NOT cl_null(maj.maj21) THEN
                        IF maj.maj24 IS NULL THEN
                           #No.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aah04) INTO amt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah04) INTO tamt0
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 = 0
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah04) INTO tamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y' 
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN #No.MOD-860252
                              SELECT SUM(aah04) INTO amt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                              SELECT SUM(aah04) INTO tamt0
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 = 0
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                              SELECT SUM(aah04) INTO tamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                           END IF    #No.MOD-860252
                           #按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                             #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aah04) INTO lamt1
                               FROM aah_file,aag_file
                              WHERE aah00 = tm.b
                                AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                AND aah02 = tm.yy1
                                AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                AND aah01 = aag01
                                AND aag07 IN ('2','3')  #No.FUN-710056
                                AND aah00 = aag00       #No.FUN-730070
                                AND aag09 = 'Y' 
                              END IF 
                              #NO.MOD-860252---end---
                              IF tm.i = 'N' THEN #No.MOD-860252
                                 SELECT SUM(aah04) INTO lamt1
                                   FROM aah_file,aag_file
                                  WHERE aah00 = tm.b
                                    AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aah02 = tm.yy1
                                    AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aah01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aah00 = aag00       #No.FUN-730070
                              END IF #No.MOD-860252
                           END IF
                        ELSE
                          #No.MOD-860252--begin--
                          IF tm.i = 'Y' THEN 
                             SELECT SUM(aao05) INTO amt1
                               FROM aao_file,aag_file
                              WHERE aao00 = tm.b
                               AND aao01 BETWEEN maj.maj21 AND maj.maj22
                               AND aao02 BETWEEN maj.maj24 AND maj.maj25
                               AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                               AND aao01 = aag01
                               AND aag07 IN ('2','3')  #No.FUN-710056
                               AND aao00 = aag00       #No.FUN-730070
                               AND aag09 = 'Y'
                            SELECT SUM(aao05) INTO tamt0
                              FROM aao_file,aag_file
                             WHERE aao00 = tm.b
                               AND aao01 BETWEEN maj.maj21 AND maj.maj22
                               AND aao02 BETWEEN maj.maj24 AND maj.maj25
                               AND aao03 = tm.yy1 AND aao04 = 0
                               AND aao01 = aag01
                               AND aag07 IN ('2','3')  #No.FUN-710056
                               AND aao00 = aag00       #No.FUN-730070
                               AND aag09 = 'Y'
                            SELECT SUM(aao05) INTO tamt1
                              FROM aao_file,aag_file
                             WHERE aao00 = tm.b
                               AND aao01 BETWEEN maj.maj21 AND maj.maj22
                               AND aao02 BETWEEN maj.maj24 AND maj.maj25
                               AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                               AND aao01 = aag01
                               AND aag07 IN ('2','3')  #No.FUN-710056
                               AND aao00 = aag00       #No.FUN-730070
                               AND aag09 = 'Y' 
                          END IF 
                          #No.MOD-860252
                          IF tm.i = 'N' THEN #No.MOD-860252
                           SELECT SUM(aao05) INTO amt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05) INTO tamt0
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 = 0
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05) INTO tamt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           END IF #No.MOD-860252
                           #按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                           	  #No.MOD-860252--begin--
                           	  IF tm.i = 'Y' THEN 
                           	     SELECT SUM(aao05) INTO lamt1
                                   FROM aao_file,aag_file
                                  WHERE aao00 = tm.b
                                    AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                    AND aao03 = tm.yy1
                                    AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aao01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aao00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y'
                           	  END IF 
                           	  #No.MOD-860252---end---
                           	  IF tm.i = 'N' THEN    #No.MOD-860252
                              SELECT SUM(aao05) INTO lamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1
                                 AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                              END IF #No.MOD-860252
                           END IF
                        END IF
                        IF STATUS THEN
                           CALL cl_err('sel aah4:',STATUS,1)
                           EXIT FOREACH
                        END IF
                        IF amt1 IS NULL THEN LET amt1 = 0 END IF
                        IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
                        IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
                     END IF
                  WHEN maj.maj06='5'    ## 貸方金額 科目貸方之當期異動
                     IF NOT cl_null(maj.maj21) THEN
                        IF maj.maj24 IS NULL THEN
                          #No.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aah05) INTO amt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah05) INTO tamt0
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 = 0
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah05) INTO tamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end--
                           IF tm.i = 'N' THEN  #No.MOD-860252
                           SELECT SUM(aah05) INTO amt1
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           SELECT SUM(aah05) INTO tamt0
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 = 0
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           SELECT SUM(aah05) INTO tamt1
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           END IF #No.MOD-860252
                           #按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                              #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aah05) INTO lamt1
                                   FROM aah_file,aag_file
                                  WHERE aah00 = tm.b
                                    AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aah02 = tm.yy1
                                    AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aah01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aah00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y' 
                              END IF 
                              #No.MOD-860252---end---
                              IF tm.i = 'N' THEN     #No.MOD-860252
                              SELECT SUM(aah05) INTO lamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1
                                 AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                              END IF #No.MOD-860252
                           END IF
                        ELSE
                           #NO.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aao06) INTO amt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao06) INTO tamt0
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 = 0
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao06) INTO tamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN   #No.MOD-860252
                           SELECT SUM(aao06) INTO amt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao06) INTO tamt0
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 = 0
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao06) INTO tamt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           END IF   #No.MOD-860252
                           #按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                              #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aao06) INTO lamt1
                                   FROM aao_file,aag_file
                                  WHERE aao00 = tm.b
                                    AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                    AND aao03 = tm.yy1
                                    AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aao01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aao00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y'
                              END IF 
                              #No.MOD-860252---end---
                              IF tm.i = 'N' THEN #No.MOD-860252
                              SELECT SUM(aao06) INTO lamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1
                                 AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                              END IF    #No.MOD-860252
                           END IF
                        END IF
                        IF STATUS THEN CALL cl_err('sel aah5:',STATUS,1) EXIT FOREACH END IF
                        IF amt1 IS NULL THEN LET amt1 = 0 END IF
                        IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
                        IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
                     END IF
                     #No.FUN-570087   --end
                  WHEN maj.maj06='6' OR maj.maj06='8' OR      ## 期初借 & 期末借
                       maj.maj06='7' OR maj.maj06='9'
                     IF NOT cl_null(maj.maj21) THEN
                        IF maj.maj24 IS NULL THEN
                           #No.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aah04-aah05) INTO amt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y' 
                              SELECT SUM(aah04-aah05) INTO tamt0
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 = 0
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah04-aah05) INTO tamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN    #No.MOD-860252
                           SELECT SUM(aah04-aah05) INTO amt1
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           SELECT SUM(aah04-aah05) INTO tamt0
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 = 0
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           SELECT SUM(aah04-aah05) INTO tamt1
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           END IF  #No.MOD-860252
                           #按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                              #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aah04-aah05) INTO lamt1
                                   FROM aah_file,aag_file
                                  WHERE aah00 = tm.b
                                    AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aah02 = tm.yy1
                                    AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aah01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aah00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y'
                              END IF 
                              #No.MOD-860252---end---
                              IF tm.i = 'N' THEN   #No.MOD-860252
                              SELECT SUM(aah04-aah05) INTO lamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1
                                 AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                              END IF #No.MOD-860252
                           END IF
                        ELSE
                           #No.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aao05-aao06) INTO amt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao05-aao06) INTO tamt0
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 = 0
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao05-aao06) INTO tamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN    #No.MOD-860252
                           SELECT SUM(aao05-aao06) INTO amt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05-aao06) INTO tamt0
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 = 0
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05-aao06) INTO tamt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           END IF    #No.MOD-860252
                           #按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                              #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aao05-aao06) INTO lamt1
                                   FROM aao_file,aag_file
                                  WHERE aao00 = tm.b
                                    AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                    AND aao03 = tm.yy1
                                    AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aao01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aao00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y'
                              END IF 
                              #No.MOD-860252---end---
                              IF tm.i = 'N' THEN    #No.MOD-860252
                              SELECT SUM(aao05-aao06) INTO lamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1
                                 AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                              END IF   #No.MOD-860252
                           END IF
                        END IF
                        IF STATUS THEN
                           CALL cl_err('sel aah4:',STATUS,1)
                           EXIT FOREACH
                        END IF
                        IF amt1 IS NULL THEN LET amt1 = 0 END IF
                        IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
                        IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
                        #No.MOD-860252--begin--
                        IF tm.i = 'Y' THEN 
                           SELECT aag06 INTO l_aag06 FROM aag_file
                            WHERE aag01 = maj.maj21
                              AND aag00 = tm.b        #No.FUN-730070
                              AND aag09 = 'Y'
                        ELSE 
                        #No.MOD-860252---end---
                        SELECT aag06 INTO l_aag06 FROM aag_file
                         WHERE aag01 = maj.maj21
                           AND aag00 = tm.b        #No.FUN-730070
                        END IF   #No.MOD-860252
                        IF l_aag06 = '1' THEN
                           IF maj.maj06='6' OR maj.maj06='8' THEN
                              IF maj.maj06='6' THEN
                                 LET amt1 = 0
                              END IF
                           ELSE
                              LET amt1 = 0
                              LET tamt0 = 0
                              LET tamt1 = 0
                           END IF
                        ELSE
                           IF maj.maj06='7' OR maj.maj06='9' THEN
                              IF maj.maj06='7' THEN
                                 LET amt1 = 0
                              END IF
                           ELSE
                              LET amt1 = 0
                              LET tamt0 = 0
                              LET tamt1 = 0
                           END IF
                        END IF
                     END IF
                  OTHERWISE
                     IF NOT cl_null(maj.maj21) THEN
                        LET l_year = tm.yy1 - 1
                        IF maj.maj24 IS NULL THEN
                           #No.MOD-860252--begin-- 
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aah04-aah05) INTO amt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah04-aah05) INTO tamt0
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 = 0
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aah04-aah05) INTO tamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN   #No.MOD-860252
                           SELECT SUM(aah04-aah05) INTO amt1
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           SELECT SUM(aah04-aah05) INTO tamt0
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 = 0
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           SELECT SUM(aah04-aah05) INTO tamt1
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy1 AND aah03 > 0 AND aah03 < tm.bm1
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           END IF   #No.MOD-860252
                           #No.FUN-570087  --add  按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                              #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aah04-aah05) INTO lamt1
                                   FROM aah_file,aag_file
                                  WHERE aah00 = tm.b
                                    AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aah02 = tm.yy1
                                    AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aah01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aah00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y' 
                              END IF 
                              #No.MOD-860252---end---
                              IF tm.i = 'N' THEN   #No.MOD-860252
                              SELECT SUM(aah04-aah05) INTO lamt1
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = tm.yy1
                                 AND aah03 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                              END IF   #No.MOD-860252
                           END IF
                           #No.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aah04-aah05) INTO l_amt0
                                FROM aah_file,aag_file
                               WHERE aah00 = tm.b
                                 AND aah01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aah02 = l_year AND aah03 = 0
                                 AND aah01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aah00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN #No.MOD-860252
                           SELECT SUM(aah04-aah05) INTO l_amt0
                             FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = l_year AND aah03 = 0
                              AND aah01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aah00 = aag00       #No.FUN-730070
                           END IF #No.MOD-860252
                           #No.FUN-570087   --end
                        ELSE
                           #No.MOD-860252--begin--
                           IF tm.i = 'Y' THEN 
                              SELECT SUM(aao05-aao06) INTO amt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao05-aao06) INTO tamt0
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 = 0
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao05-aao06) INTO tamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                              SELECT SUM(aao05-aao06) INTO l_amt0
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = l_year AND aao04 = 0
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                                 AND aag09 = 'Y'
                           END IF 
                           #No.MOD-860252---end---
                           IF tm.i = 'N' THEN   #No.MOD-860252
                           SELECT SUM(aao05-aao06) INTO amt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05-aao06) INTO tamt0
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 = 0
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05-aao06) INTO tamt1
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy1 AND aao04 > 0 AND aao04 < tm.bm1
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           SELECT SUM(aao05-aao06) INTO l_amt0
                             FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = l_year AND aao04 = 0
                              AND aao01 = aag01
                              AND aag07 IN ('2','3')  #No.FUN-710056
                              AND aao00 = aag00       #No.FUN-730070
                           END IF    #No.MOD-860252
                           #No.FUN-570087  --begin按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET lamt1 = 0
                           ELSE
                              #No.MOD-860252--begin--
                              IF tm.i = 'Y' THEN 
                                 SELECT SUM(aao05-aao06) INTO lamt1
                                   FROM aao_file,aag_file
                                  WHERE aao00 = tm.b
                                    AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                    AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                    AND aao03 = tm.yy1
                                    AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                    AND aao01 = aag01
                                    AND aag07 IN ('2','3')  #No.FUN-710056
                                    AND aao00 = aag00       #No.FUN-730070
                                    AND aag09 = 'Y'
                              END IF 
                              #No.MOD-860252---end---
                              IF tm.i = 'N' THEN   #No.MOD-860252
                              SELECT SUM(aao05-aao06) INTO lamt1
                                FROM aao_file,aag_file
                               WHERE aao00 = tm.b
                                 AND aao01 BETWEEN maj.maj21 AND maj.maj22
                                 AND aao02 BETWEEN maj.maj24 AND maj.maj25
                                 AND aao03 = tm.yy1
                                 AND aao04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                                 AND aao01 = aag01
                                 AND aag07 IN ('2','3')  #No.FUN-710056
                                 AND aao00 = aag00       #No.FUN-730070
                              END IF   #No.MOD-860252
                           END IF
                           #No.FUN-570087  --end
                        END IF
                        IF STATUS THEN CALL cl_err('sel aah1:',STATUS,1) EXIT FOREACH END IF
                        IF amt1 IS NULL THEN LET amt1 = 0 END IF
                        IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
                        IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
                        #No.A121
                        IF g_argv1 MATCHES '[27]' THEN
                           SELECT SUM(abb07) INTO l_endy1
                             FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy1
                              AND aba19 <> 'X'  #CHI-C80041
                              AND aba04 BETWEEN tm.bm1 AND tm.em1
                           SELECT SUM(abb07) INTO l_endy2
                             FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy1
                              AND aba19 <> 'X'  #CHI-C80041
                              AND aba04 BETWEEN tm.bm1 AND tm.em1
                           #No.FUN-570087  --begin   按照公式計算上月相關金額
                           IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                              LET l_lendy1 = 0 LET l_lendy2 = 0
                           ELSE
                              SELECT SUM(abb07) INTO l_lendy1
                                FROM abb_file,aba_file
                               WHERE abb00 = tm.b
                                 AND aba00 = abb00 AND aba01 = abb01
                                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                                 AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy1
                                 AND aba19 <> 'X'  #CHI-C80041
                                 AND aba04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                              SELECT SUM(abb07) INTO l_lendy2
                                FROM abb_file,aba_file
                               WHERE abb00 = tm.b
                                 AND aba00 = abb00 AND aba01 = abb01
                                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                                 AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy1
                                 AND aba19 <> 'X'  #CHI-C80041
                                 AND aba04 BETWEEN (tm.bm1-1) AND (tm.em1-1)
                           END IF
                        END IF
                        IF l_lendy1 IS NULL THEN LET l_lendy1 = 0 END IF
                        IF l_lendy2 IS NULL THEN LET l_lendy2 = 0 END IF
                        LET lamt1 = lamt1 + l_lendy2 - l_lendy1
                        #No.FUN-570087  --end
                        IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
                        IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
                        LET amt1 = amt1 + l_endy2 - l_endy1
                        #end
                     END IF
               END CASE
               IF amt1 IS NULL THEN LET amt1 = 0 END IF
               IF tamt0 IS NULL THEN LET tamt0 = 0 END IF
               IF tamt1 IS NULL THEN LET tamt1 = 0 END IF
               IF l_amt0 IS NULL THEN LET l_amt0 = 0 END IF
               IF g_argv1 = '7' AND maj.maj06 = '1' THEN
                  LET amt1 = 0
                  LET tamt1 = tamt0 - l_amt0
                  LET tamt0 = l_amt0
               END IF
               #匯率的轉換
               IF tm.o = 'Y' THEN
                  LET amt1 = amt1 * tm.q
                  LET tamt0 = tamt0 * tm.q
                  LET tamt1 = tamt1 * tm.q
                  LET l_amt0 = l_amt0 * tm.q
               END IF
               IF maj.maj03 MATCHES "[012H]" AND maj.maj08 > 0	THEN #合計階數處理
                  FOR i = 1 TO 100
                      LET g_tot1[i]=g_tot1[i]+amt1
                      LET g_tot2[i]=g_tot2[i]+tamt0
                      LET g_tot3[i]=g_tot3[i]+tamt1
                      #No.FUN-570087  --begin  按照公式計算上月相關金額
                      # 注意 ︰ 本年合計不變
                      LET g_ltot1[i]=g_ltot1[i]+lamt1
                      #No.FUN-570087  --end
                  END FOR
                  LET k=maj.maj08
                  LET sr.bal1=g_tot1[k]
                  LET sr.tbal0=g_tot2[k]
                  LET sr.tbal1=g_tot3[k]
                  LET sr.lbal1=g_ltot1[k]
                  FOR i = 1 TO maj.maj08
                      LET g_tot1[i]=0
                      LET g_tot2[i]=0
                      LET g_tot3[i]=0
                      LET g_ltot1[i]=0
                  END FOR
               ELSE
                  IF maj.maj03='5' THEN
                     LET sr.bal1=amt1
                     LET sr.tbal0=tamt0
                     LET sr.tbal1=tamt1
                     LET sr.lbal1=lamt1
                  ELSE
                     LET sr.bal1=0
                     LET sr.tbal0=0
                     LET sr.tbal1=0
                     LET sr.lbal1=0
                  END IF
               END IF
               IF maj.maj11 = 'Y' THEN			# 百分比基準科目
                  LET g_basetot1=sr.bal1
                  LET g_basetot2=sr.tbal0
                  LET g_basetot3=sr.tbal1
                  #No.FUN-570087  --begin 按照公式計算上月相關金額
                  LET g_lbasetot1=sr.lbal1
                  IF maj.maj07='2' THEN
                     LET g_basetot1=g_basetot1*-1
                     LET g_basetot2=g_basetot2*-1
                     LET g_basetot3=g_basetot3*-1
                     LET g_lbasetot1=g_lbasetot1*-1
                  END IF
                  #No.FUN-570087  --end
               END IF
               IF maj.maj03='0' THEN CONTINUE FOREACH END IF  #本行不印出
               IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"
                  AND sr.bal1=0 THEN
                  CONTINUE FOREACH				#餘額為 0 者不列印
               END IF
               IF tm.f > 0 AND maj.maj08 < tm.f THEN
                  CONTINUE FOREACH				#最小階數起列印
               END IF
               #No.FUN-570087  --begin  按公式計算金額
               #新增按公式打印,累計已計算完成科目金額
               LET g_i = g_i + 1
               LET g_formula[g_i].maj02 = cl_numfor(maj.maj02,9,2)
               LET g_formula[g_i].maj27 = maj.maj27
               LET g_formula[g_i].bal1  = cl_numfor(sr.bal1,20,6)
               LET g_formula[g_i].tbal0 = cl_numfor(sr.tbal0,20,6)
               LET g_formula[g_i].tbal1 = cl_numfor(sr.tbal1,20,6)
               LET g_formula[g_i].lbal1 = cl_numfor(sr.lbal1,20,6)
               CALL g_formula.appendElement()
               IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
               IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
               IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
    
               #No.FUN-780057  --STR
               IF tm.h = 'Y' THEN                                                                                                      
                  LET maj.maj20 = maj.maj20e                                                                                 
               END IF   
               #No.FUN-780057  --END
 
               IF (NOT cl_null(maj.maj05)) AND maj.maj05 > 0 THEN
                  LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               END IF
               INSERT INTO tmp_file
                  VALUES(maj.maj02,maj.maj03,maj.maj04,maj.maj06,
                         maj.maj07,maj.maj20,maj.maj20e,maj.maj26,
                         sr.bal1,sr.tbal0,sr.tbal1,
                         l_amt0,l_amt1,l_amt2,l_amt3,l_amt4)
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('insert tmp',SQLCA.sqlcode,0)   #No.FUN-660124
                  CALL cl_err3("ins","tmp_file","","",SQLCA.sqlcode,"","insert tmp",0)   #No.FUN-660124
                  CONTINUE FOREACH
               END IF
            ELSE
               LET g_i = g_i + 1
               LET g_formula[g_i].maj02 = cl_numfor(maj.maj02,9,2)
               LET g_formula[g_i].maj27 = maj.maj27
               LET g_for_str = maj.maj27 CLIPPED
               IF NOT cl_null(g_for_str) THEN
                  CALL formula_gen(g_for_str,"1")
                  LET g_sql = "SELECT ",g_for_str," FROM sma_file "
                  PREPARE r116_bal1 FROM g_sql
                  EXECUTE r116_bal1 INTO g_formula[g_i].bal1
               ELSE
                  LET g_formula[g_i].bal1 = cl_numfor(sr.bal1,20,6)
                  LET g_formula[g_i].tbal0 = cl_numfor(sr.tbal0,20,6)
                  LET g_formula[g_i].tbal1 = cl_numfor(sr.tbal1,20,6)
               END IF
 
#              LET g_for_str = maj.maj28 CLIPPED
#              IF NOT cl_null(g_for_str) THEN
#                 CALL formula_gen(g_for_str,"2")
#                 LET g_sql = "SELECT ",g_for_str," FROM sma_file "
#                 PREPARE r116_bal2 FROM g_sql
#                 EXECUTE r116_bal2 INTO g_formula[g_i].bal2
#              ELSE
#                 LET g_formula[g_i].bal2 = cl_numfor(sr.bal2,20,6)
#              END IF
               CALL g_formula.appendElement()
               LET sr.bal1  = cl_numfor(g_formula[g_i].bal1,20,6)
               LET sr.tbal0 = cl_numfor(g_formula[g_i].tbal0,20,6)
               LET sr.tbal1 = cl_numfor(g_formula[g_i].tbal1,20,6)
               LET sr.lbal1 = cl_numfor(g_formula[g_i].lbal1,20,6)
               IF cl_null(sr.bal1) THEN LET sr.bal1 = 0.999999 END IF
               IF cl_null(sr.tbal0) THEN LET sr.tbal0 = 0.999999 END IF
               IF cl_null(sr.tbal1) THEN LET sr.tbal1 = 0.999999 END IF
               IF cl_null(sr.lbal1) THEN LET sr.lbal1 = 0.999999 END IF
               IF cl_null(l_amt0) THEN LET l_amt0 = 0 END IF
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
               IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
               IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
               #No.FUN-780057  --STR
               IF tm.h = 'Y' THEN                                                                                                      
                  LET maj.maj20 = maj.maj20e                                                                                 
               END IF    
               #No.FUN-780057  --END
 
               IF (NOT cl_null(maj.maj05)) AND maj.maj05 > 0 THEN
                  LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               END IF
               INSERT INTO tmp_file
                  VALUES(maj.maj02,maj.maj03,maj.maj04,maj.maj06,
                         maj.maj07,maj.maj20,maj.maj20e,maj.maj26,
                         sr.bal1,sr.tbal0,sr.tbal1,
                         l_amt0,l_amt1,l_amt2,l_amt3,l_amt4)
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('insert tmp',SQLCA.sqlcode,0)   #No.FUN-660124
                  CALL cl_err3("ins","tmp_file","","",SQLCA.sqlcode,"","insert tmp",0)   #No.FUN-660124
                  CONTINUE FOREACH
               END IF
            END IF
            #No.FUN-570087  --end
      END CASE
   END FOREACH
   IF g_flag = 'Y' THEN
      #LET l_name = g_name                        #No.FUN-780057
      #START REPORT r116_rep1 TO l_name           #No.FUN-780057
      LET l_name='gglr116_1'                      #No.FUN-780057
   ELSE
      #CALL cl_outnam(g_prog) RETURNING l_name    #No.FUN-780057
      
      IF g_argv1 = '5' THEN
         #START REPORT r116_rep2 TO l_name        #No.FUN-780057
         LET l_name = 'gglr116_2'                 #No.FUN-780057
      ELSE
         #START REPORT r116_rep TO l_name         #No.FUN-780057
         LET l_name = 'gglr116'                   #No.FUN-780057
      END IF
   END IF
   DECLARE r116_c1 CURSOR FOR SELECT * FROM tmp_file ORDER BY maj02
   FOREACH r116_c1 INTO r116_tmp.*
      IF g_flag = 'Y' THEN
         #No.FUN-780057 --STR
         #金額單位之列印                                                                                                            
         CASE tm.d                                                                                                                  
            WHEN '1'  LET l_unit = cl_getmsg('sub-137',g_lang)                                                                      
                      LET g_unit = 1                                                                                                
            WHEN '3'  LET l_unit = cl_getmsg('sub-131',g_lang)                                                                      
                      LET g_unit = 10000                                                                                            
            OTHERWISE LET l_unit = ' '                                                                                              
                      LET g_unit = 1                                                                                                
         END CASE                                                                                                                   
       
         
         LET l_tot  = r116_tmp.bal1      #當期                                                                                          
         LET l_tot0 = r116_tmp.tbal0     #年初                                                                                          
         LET l_tot1 = r116_tmp.tbal1     #期間                                                                                          
         LET l_tot2 = l_tot+l_tot1   #本年實際                                                                                      
         LET l_tot3 = l_tot2+l_tot0  #本年累計                                                                                      
         IF r116_tmp.maj07='2' AND g_argv1 != '4' THEN                                                                                  
            LET l_tot  = l_tot * -1                                                                                                 
            LET l_tot0 = l_tot0 * -1 
            LET l_tot1 = l_tot1 * -1                                                                                                
            LET l_tot2 = l_tot2 * -1                                                                                                
            LET l_tot3 = l_tot3 * -1                                                                                                
            LET r116_tmp.bal1 = r116_tmp.bal1 * -1                                                                                          
            LET r116_tmp.tbal0 = r116_tmp.tbal0 * -1                                                                                        
            LET r116_tmp.tbal1 = r116_tmp.tbal1 * -1                                                                                        
            LET r116_tmp.l_amt0 = r116_tmp.l_amt0 * -1                                                                                      
            LET r116_tmp.l_amt1 = r116_tmp.l_amt1 * -1                                                                                      
            LET r116_tmp.l_amt2 = r116_tmp.l_amt2 * -1                                                                                      
            LET r116_tmp.l_amt3 = r116_tmp.l_amt3 * -1                                                                                      
            LET r116_tmp.l_amt4 = r116_tmp.l_amt4 * -1                                                                                      
         END IF               
         LET per1 = (r116_tmp.bal1/g_basetot1)*100
         CASE 
            WHEN r116_tmp.maj03 !='9' AND r116_tmp.maj03 !='3' AND r116_tmp.maj03 !='0' AND r116_tmp.maj03 !='4' 
               IF (NOT cl_null(r116_tmp.maj26)) OR g_argv1 = '5' THEN                                                                   
                  CASE g_argv1                                                                                                      
                     WHEN "1"   #資產負債表                                                                                         
                        LET l_tot0 = l_tot0/g_unit                                                                                
                        LET l_tot3 = l_tot3/g_unit                                                                                
                       
                     
                     WHEN "2"   #利潤表                                                                                             
                        LET l_tot = l_tot/g_unit                                                                                  
                        LET l_tot3 = l_tot3/g_unit                                                                                
                     
                   
                     WHEN "4"   #應交增值稅明細表                                                                                   
                        CASE r116_tmp.maj06                                                                                             
                           WHEN "1"                                                                                                 
                              LET l_tot = r116_tmp.tbal0 - r116_tmp.l_amt0                                                                  
                              LET l_tot3 = l_tot                                                                                    
                           WHEN "2"                                                                                                 
                              LET l_tot = r116_tmp.bal1 - r116_tmp.l_amt2                                                                   
                              LET l_tot3 = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.l_amt3 - r116_tmp.l_amt4                                     
                           WHEN "3"                                                                                                 
                              LET l_tot = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.tbal1 - r116_tmp.l_amt1 + r116_tmp.bal1 - r116_tmp.l_amt2             
                              LET l_tot3 = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.l_amt3 - r116_tmp.l_amt4                                     
                           WHEN "4"                                                                                                 
                              LET l_tot = r116_tmp.bal1                                                                                 
                            
                              LET l_tot3 = r116_tmp.l_amt3                                                                              
                           WHEN "5"                                                                                                 
                              LET l_tot = r116_tmp.l_amt2                                                                               
              
                              LET l_tot3 = r116_tmp.l_amt4                                                                              
                           WHEN "6"                                                                                                 
                              LET l_tot = r116_tmp.tbal0  
                              LET l_tot3 = l_tot                                                                                    
                           WHEN "7"                                                                                                 
                              LET l_tot = r116_tmp.l_amt0                                                                               
                              LET l_tot3 = l_tot                                                                                    
                           WHEN "8"                                                                                                 
                              LET l_tot = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.tbal1 - r116_tmp.l_amt1 + r116_tmp.bal1 - r116_tmp.l_amt2             
                              LET l_tot3 = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.l_amt3 - r116_tmp.l_amt4                                     
                           OTHERWISE                                                                                                
                              LET l_tot = r116_tmp.tbal0 + r116_tmp.tbal1 + r116_tmp.bal1                                                       
                              LET l_tot3 = r116_tmp.l_amt0 - r116_tmp.l_amt4                                                                
                        END CASE                                                                                                    
                        IF r116_tmp.maj07='2' THEN                                                                                      
                           LET l_tot  = l_tot * -1                                                                                  
                           LET l_tot3  = l_tot3 * -1                                                                                
                        END IF                                                                                                      
                        LET l_tot = l_tot/g_unit 
                        LET l_tot3 = l_tot3/g_unit
                     WHEN "5"   #資產減值准備明細表                                                                                 
                        LET r116_tmp.l_amt0 = r116_tmp.l_amt0/g_unit                                                                        
                        LET r116_tmp.l_amt1 = r116_tmp.l_amt1/g_unit                                                                        
                        LET r116_tmp.l_amt2 = r116_tmp.l_amt2/g_unit                                                                        
                        LET l_amt3 = r116_tmp.l_amt0 + r116_tmp.l_amt1 - r116_tmp.l_amt2  
                     WHEN "6"   #股東權益增減變動表                                                                                 
                        CASE r116_tmp.maj06                                                                                             
                           WHEN "1"                                                                                                 
                              LET l_tot2 = r116_tmp.bal1                                                                              
                              LET l_tot0 = r116_tmp.l_amt0                                                                            
                           WHEN "3"                                                                                                 
                              LET l_tot2 = r116_tmp.tbal1                                                                             
                              LET l_tot0 = r116_tmp.l_amt2                                                                            
                           OTHERWISE                                                                                                
                              LET l_tot2 = r116_tmp.tbal0                                                                             
                              LET l_tot0 = r116_tmp.l_amt1                                                                            
                        END CASE                                                                                                    
                        LET l_tot2 = l_tot2/g_unit                                                                              
                        LET l_tot0 = l_tot0/g_unit 
                     WHEN "7"   #利潤分配表                                                                                         
                        LET l_tot2 = l_tot2                                                                                       
                        LET l_tot0 = l_tot0                                                                                       
                        LET l_tot2 = l_tot2/g_unit                                                                              
                        LET l_tot0 = l_tot0/g_unit                                                                              
                        IF l_tot0 < 0 THEN                                                                                        
                           LET l_tot0 = l_tot0 * -1                                                                             
                        END IF                                                                                                      
                        IF l_tot2 < 0 THEN                                                                                        
                           LET l_tot2 = l_tot2 * -1                                                                             
                        END IF               
                  END CASE
               END IF
         END CASE
         IF r116_tmp.maj04 = 0 THEN
            EXECUTE insert_prep USING
               r116_tmp.maj02,r116_tmp.maj03,r116_tmp.maj04,r116_tmp.maj06,r116_tmp.maj07,
               r116_tmp.maj20,r116_tmp.maj20e,
               r116_tmp.maj26,r116_tmp.bal1,r116_tmp.tbal0,r116_tmp.tbal1,r116_tmp.l_amt0,
               r116_tmp.l_amt1,r116_tmp.l_amt2,
               r116_tmp.l_amt3,r116_tmp.l_amt4,l_tot,l_tot0,l_tot2,l_tot3,'2'
         ELSE 
            EXECUTE insert_prep USING
               r116_tmp.maj02,r116_tmp.maj03,r116_tmp.maj04,r116_tmp.maj06,r116_tmp.maj07,
               r116_tmp.maj20,r116_tmp.maj20e,                                              
               r116_tmp.maj26,r116_tmp.bal1,r116_tmp.tbal0,r116_tmp.tbal1,r116_tmp.l_amt0,
               r116_tmp.l_amt1,r116_tmp.l_amt2,                                             
               r116_tmp.l_amt3,r116_tmp.l_amt4,l_tot,l_tot0,l_tot2,l_tot3,'2'
            #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
            #讓空行的這筆資料排在正常的資料前面印出           
            FOR i=1 TO r116_tmp.maj04
               EXECUTE insert_prep USING
                  r116_tmp.maj02,'','','','',r116_tmp.maj20,r116_tmp.maj20e,
                  '','','','','','','',
                  '','','','','','','1'
            END FOR 
         END IF
         #No.FUN-780057 --END                              
         #OUTPUT TO REPORT r116_rep1(r116_tmp.*)    #No.FUN-780057
      ELSE
         IF g_argv1 = '5' THEN
            IF tm.d = '1' THEN LET g_unit = 1 END IF                                                                                   
            IF tm.d = '2' THEN LET g_unit = 1000 END IF                                                                                
            IF tm.d = '3' THEN LET g_unit = 10000 END IF                                                                               
            IF tm.d = '4' THEN LET g_unit = 1000000 END IF                                                                             
            IF r116_tmp.maj07='2' AND g_argv1 != '4' THEN                                                                                   
               LET l_tot  = l_tot * -1                                                                                                 
               LET l_tot0 = l_tot0 * -1                                                                                                
               LET l_tot1 = l_tot1 * -1                                                                                                
               LET l_tot2 = l_tot2 * -1                                                                                                
               LET l_tot3 = l_tot3 * -1                                                                                                
               LET r116_tmp.bal1 = r116_tmp.bal1 * -1                                                                                            
               LET r116_tmp.tbal0 = r116_tmp.tbal0 * -1                                                                                          
               LET r116_tmp.tbal1 = r116_tmp.tbal1 * -1                                                                                          
               LET r116_tmp.l_amt0 = r116_tmp.l_amt0 * -1                                                                                        
               LET r116_tmp.l_amt1 = r116_tmp.l_amt1 * -1                                                                                        
               LET r116_tmp.l_amt2 = r116_tmp.l_amt2 * -1                                                                                        
               LET r116_tmp.l_amt3 = r116_tmp.l_amt3 * -1                                                                                        
               LET r116_tmp.l_amt4 = r116_tmp.l_amt4 * -1                                                                                        
            END IF                                                                                                                     
            LET per1 = (r116_tmp.bal1 / g_basetot1) * 100  
   
 
 
           
            IF r116_tmp.maj04 = 0 THEN
               EXECUTE insert_prep USING 
                   r116_tmp.maj02,r116_tmp.maj03,r116_tmp.maj04,r116_tmp.maj06,r116_tmp.maj07,
                   r116_tmp.maj20,r116_tmp.maj20e,
                   r116_tmp.maj26,r116_tmp.bal1,r116_tmp.tbal0,r116_tmp.tbal1,r116_tmp.l_amt0,
                   r116_tmp.l_amt1,r116_tmp.l_amt2,
                   r116_tmp.l_amt3,r116_tmp.l_amt4,l_tot,l_tot0,l_tot2,l_tot3,'2'
            ELSE
               EXECUTE insert_prep USING
                   r116_tmp.maj02,r116_tmp.maj03,r116_tmp.maj04,r116_tmp.maj06,r116_tmp.maj07,
                   r116_tmp.maj20,r116_tmp.maj20e,                                          
                   r116_tmp.maj26,r116_tmp.bal1,r116_tmp.tbal0,r116_tmp.tbal1,r116_tmp.l_amt0,
                   r116_tmp.l_amt1,r116_tmp.l_amt2,                                         
                   r116_tmp.l_amt3,r116_tmp.l_amt4,l_tot,l_tot0,l_tot2,l_tot3,'2'    
               #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
               #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
               #讓空行的這筆資料排在正常的資料前面印出 
               FOR i=1 TO r116_tmp.maj04
                  EXECUTE insert_prep USING
                     r116_tmp.maj02,'','','','',r116_tmp.maj20,r116_tmp.maj20e,
                     '','','','','','','',
                     '','','','','','','1'
               END FOR
            END IF
            #No.FUN-780057 --END          
            #OUTPUT TO REPORT r116_rep2(r116_tmp.*)    #No.FUN-780057
         ELSE
            #No.FUN-780057  --STR
 
            LET l_tot  = r116_tmp.bal1      #當期                                                                                           
            LET l_tot0 = r116_tmp.tbal0     #年初                                                                                           
            LET l_tot1 = r116_tmp.tbal1     #期間                                                                                           
            LET l_tot2 = l_tot+l_tot1  #本年實際                                                                                       
            LET l_tot3 = l_tot2+l_tot0 #本年累計                                                                                       
            IF r116_tmp.maj07='2' AND g_argv1 != '4' THEN                                                                                   
               LET l_tot  = l_tot * -1                                                                                                 
               LET l_tot0 = l_tot0 * -1                                                                                                
               LET l_tot1 = l_tot1 * -1                                                                                                
               LET l_tot2 = l_tot2 * -1                                                                                                
               LET l_tot3 = l_tot3 * -1                                                                                                
               LET r116_tmp.bal1 = r116_tmp.bal1 * -1                                                                                            
               LET r116_tmp.tbal0 = r116_tmp.tbal0 * -1                                                                                          
               LET r116_tmp.tbal1 = r116_tmp.tbal1 * -1                                                                                          
               LET r116_tmp.l_amt0 = r116_tmp.l_amt0 * -1                                                                                        
               LET r116_tmp.l_amt1 = r116_tmp.l_amt1 * -1                                                                                        
               LET r116_tmp.l_amt2 = r116_tmp.l_amt2 * -1                                                                                        
               LET r116_tmp.l_amt3 = r116_tmp.l_amt3 * -1                                                                                        
               LET r116_tmp.l_amt4 = r116_tmp.l_amt4 * -1 
            END IF                                                                                                                     
            LET per1 = (r116_tmp.bal1 / g_basetot1) * 100                                                                                   
            IF tm.d = '1' THEN LET g_unit = 1 END IF                                                                                   
            IF tm.d = '2' THEN LET g_unit = 1000 END IF                                                                                
            IF tm.d = '3' THEN LET g_unit = 10000 END IF                                                                               
            IF tm.d = '4' THEN LET g_unit = 1000000 END IF
            CASE
               WHEN r116_tmp.maj03 != '9' AND r116_tmp.maj03 != '3' AND r116_tmp.maj03 != '0' AND r116_tmp.maj03 !='4' 
                 
                  IF cl_null(r116_tmp.maj26) AND g_argv1 != '5' THEN                                                                        
                     LET l_tot  = NULL                                                                                                 
                     LET l_tot0 = NULL                                                                                                 
                     LET l_tot1 = NULL                                                                                                 
                     LET l_tot2 = NULL                                                                                                 
                     LET l_tot3 = NULL                                                                                                 
                     LET r116_tmp.bal1 = NULL                                                                                               
                     LET r116_tmp.tbal0 = NULL                                                                                              
                     LET r116_tmp.tbal1 = NULL                                                                                              
                     LET r116_tmp.l_amt0 = NULL                                                                                             
                     LET r116_tmp.l_amt1 = NULL                                                                                             
                     LET r116_tmp.l_amt2 = NULL                                                                                             
                     LET r116_tmp.l_amt3 = NULL                                                                                             
                     LET r116_tmp.l_amt4 = NULL                                                                                             
                  END IF    
                  CASE g_argv1
                     WHEN "4"  #應交增值稅明細表
                        CASE r116_tmp.maj06                                                                                                 
                           WHEN "1"                                                                                                    
                              LET l_tot = r116_tmp.tbal0 - r116_tmp.l_amt0                                                                       
                              LET l_tot3 = l_tot                                                                                       
                           WHEN "2"                                                                                                    
                              LET l_tot = r116_tmp.bal1 - r116_tmp.l_amt2                                                                        
                              LET l_tot3 = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.l_amt3 - r116_tmp.l_amt4                                            
                           WHEN "3"                                                                                                    
                              LET l_tot = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.tbal1 - r116_tmp.l_amt1 + r116_tmp.bal1 - r116_tmp.l_amt2                      
                              LET l_tot3 = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.l_amt3 - r116_tmp.l_amt4                                            
                           WHEN "4"                                                                                                    
                              LET l_tot = r116_tmp.bal1                                                                                     
                              #LET l_tot3 = r116_tmp.tbal0 + r116_tmp.l_amt3                                                                     
                              LET l_tot3 = r116_tmp.l_amt3                                                                                  
                           WHEN "5"                                                                                                    
                              LET l_tot = r116_tmp.l_amt2                                                                                   
                              #LET l_tot3 = r116_tmp.l_amt0 + r116_tmp.l_amt4                                                                    
                              LET l_tot3 = r116_tmp.l_amt4                                                                                  
                           WHEN "6"                   
                              LET l_tot = r116_tmp.tbal0                                                                                    
                              LET l_tot3 = l_tot                                                                                       
                           WHEN "7"                                                                                                    
                              LET l_tot = r116_tmp.l_amt0                                                                                   
                              LET l_tot3 = l_tot                                                                                       
                           WHEN "8"                                                                                                    
                              LET l_tot = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.tbal1 - r116_tmp.l_amt1 + r116_tmp.bal1 - r116_tmp.l_amt2                      
                              LET l_tot3 = r116_tmp.tbal0 - r116_tmp.l_amt0 + r116_tmp.l_amt3 - r116_tmp.l_amt4                                            
                           OTHERWISE                                                                                                   
                              LET l_tot = r116_tmp.tbal0 + r116_tmp.tbal1 + r116_tmp.bal1                                                             
                              LET l_tot3 = r116_tmp.l_amt0 - r116_tmp.l_amt4                                                                     
                        END CASE                                                                                                       
                        IF r116_tmp.maj07='2' THEN                                                                                          
                           LET l_tot  = l_tot * -1                                                                                     
                           LET l_tot3  = l_tot3 * -1                                                                                   
                        END IF
                     WHEN "6" #股東權益增減變動表                                                                                      
                        CASE r116_tmp.maj06                                                                                                 
                           WHEN "1"                                                                                                    
                              LET l_tot2 = r116_tmp.bal1                                                                                    
                              LET l_tot0 = r116_tmp.l_amt0                                                                                  
                           WHEN "3"                                                                                                    
                              LET l_tot2 = r116_tmp.tbal1                                                                                   
                              LET l_tot0 = r116_tmp.l_amt2                                                                                  
                           OTHERWISE                                                                                                   
                              LET l_tot2 = r116_tmp.tbal0                                                                                   
                              LET l_tot0 = r116_tmp.l_amt1                                                                                  
                        END CASE  
                     WHEN "7"                                                                                                          
                        IF l_tot0 < 0 THEN                                                                                             
                           LET l_tot0 = l_tot0 * -1                                                                                    
                        END IF                                                                                                         
                        IF l_tot2 < 0 THEN                                                                                             
                           LET l_tot2 = l_tot2 * -1                                                                                    
                        END IF
                  END CASE  
            END CASE                                                
            LET l_tot = l_tot/g_unit
            LET l_tot0 = l_tot0/g_unit
            LET l_tot2 = l_tot2/g_unit
            LET l_tot3 = l_tot3/g_unit
            
            IF r116_tmp.maj04 = 0 THEN
               EXECUTE insert_prep USING 
                 r116_tmp.maj02,r116_tmp.maj03,r116_tmp.maj04,r116_tmp.maj06,r116_tmp.maj07,
                 r116_tmp.maj20,r116_tmp.maj20e,
                 r116_tmp.maj26,r116_tmp.bal1,r116_tmp.tbal0,r116_tmp.tbal1,r116_tmp.l_amt0,
                 r116_tmp.l_amt1,r116_tmp.l_amt2,
                 r116_tmp.l_amt3,r116_tmp.l_amt4,
                 l_tot,l_tot0,l_tot2,l_tot3,'2'
            ELSE 
               EXECUTE insert_prep USING
                 r116_tmp.maj02,r116_tmp.maj03,r116_tmp.maj04,r116_tmp.maj06,r116_tmp.maj07,
                 r116_tmp.maj20,r116_tmp.maj20e,
                 r116_tmp.maj26,r116_tmp.bal1,r116_tmp.tbal0,r116_tmp.tbal1,r116_tmp.l_amt0,
                 r116_tmp.l_amt1,r116_tmp.l_amt2,
                 r116_tmp.l_amt3,r116_tmp.l_amt4,
                 l_tot,l_tot0,l_tot2,l_tot3,'2'
                 #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
                 #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
                 #讓空行的這筆資料排在正常的資料前面印出          
                 FOR i=1 TO r116_tmp.maj04 
                    EXECUTE insert_prep USING
                       r116_tmp.maj02,'','','','',r116_tmp.maj20,r116_tmp.maj20e,
                       '','','','','','','',
                       '','','','','','','1'
                 END FOR
              END IF
              #No.FUN-780057 --end
           
           #OUTPUT TO REPORT r116_rep(r116_tmp.*)     #No.FUN-780057
         END IF
      END IF
   END FOREACH
   #No.FUN-780057  --STR
   #IF g_flag = 'Y' THEN
      #FINISH REPORT r116_rep1           #No.FUN-780057
   #ELSE
      #IF g_argv1 = '5' THEN
         #FINISH REPORT r116_rep2        #No.FUN-780057
      #ELSE
         #FINISH REPORT r116_rep         #No.FUN-780057
      #END IF
      #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-780057
   #END IF
   #No.FUN-780057  --END
 
   IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
   IF g_basetot2 = 0 THEN LET g_basetot2 = NULL END IF
   IF g_basetot3 = 0 THEN LET g_basetot3 = NULL END IF
   IF g_basetot4 = 0 THEN LET g_basetot4 = NULL END IF
   IF g_basetot5 = 0 THEN LET g_basetot5 = NULL END IF
   IF g_basetot6 = 0 THEN LET g_basetot6 = NULL END IF
   IF g_basetot7 = 0 THEN LET g_basetot7 = NULL END IF
   IF g_basetot8 = 0 THEN LET g_basetot8 = NULL END IF
   IF g_lbasetot1= 0 THEN LET g_lbasetot1= NULL END IF
   
   #No.FUN-780057 --str
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #str MOD-930159 add
   SELECT gaz06 INTO l_gaz06 FROM gaz_file
    WHERE gaz01=g_prog AND gaz02=g_lang
  #end MOD-930159 add
   LET g_str=g_mai02,';',tm.b,';',tm.a,';',tm.yy1,';',tm.bm1,';',
             tm.em1,';',tm.c,';',tm.d,';',tm.e,';',tm.f,';',
             tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q,';',
             g_ym,';',l_unit,';',g_argv1,';',l_gaz06,';',g_prog   #MOD-930159 mod
   LET l_prog = g_prog   #記錄原始prog                         #MOD-930159 add
   IF g_prog != 'gglr116' THEN LET g_prog = 'gglr116' END IF   #MOD-930159 add
   CALL cl_prt_cs3('gglr116',l_name,g_sql,g_str)
   LET g_prog = l_prog   #MOD-930159 add
   #No.FUN-780057 --END
   #No.FUN-B80096--mark--Begin---    
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-780057  --STR
#REPORT r116_rep(tmp)
 
#   DEFINE l_last_sw        LIKE type_file.chr1      #NO FUN-690009   VARCHAR(01)
#   DEFINE l_unit           LIKE zaa_file.zaa08        #NO FUN-690009   VARCHAR(04)
#   DEFINE l_time           LIKE type_file.chr20     #NO FUN-690009   VARCHAR(20)
#   DEFINE per1,per2,per3   LIKE fid_file.fid03    #NO FUN-690009   DEC(8,3)
#   DEFINE l_tot0,l_tot1       LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE l_tot2,l_tot3       LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE l_tot,l_tot0_n      LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE l_tot_n,l_tot2_n    LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE l_tot3_n            LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE l_amt3              LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE tmp RECORD
#             maj02  LIKE maj_file.maj02,    #NO FUN-690009   DEC(9,4)
#             maj03  LIKE maj_file.maj03,    #NO FUN-690009   VARCHAR(01)
#             maj04  LIKE maj_file.maj04,    #NO FUN-690009   SMALLINT
#             maj06  LIKE maj_file.maj06,    #NO FUN-690009   VARCHAR(01)
#             maj07  LIKE maj_file.maj07,    #NO FUN-690009   VARCHAR(01)
#             maj20  LIKE maj_file.maj20,    #NO FUN-690009   VARCHAR(100)
#             maj20e LIKE maj_file.maj20e,   #NO FUN-690009   VARCHAR(50)
#             maj26  LIKE maj_file.maj26,    #NO FUN-690009   SMALLINT
#             bal1   LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             tbal0  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             tbal1  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt0 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt1 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt2 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt3 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt4 LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
#               END RECORD
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#   ORDER BY tmp.maj02
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6A0094
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0094
#         #金額單位之列印
#         CASE tm.d
#            WHEN '1'  LET l_unit = g_x[16] CLIPPED
#            WHEN '2'  LET l_unit = g_x[17] CLIPPED
#            WHEN '3'  LET l_unit = g_x[21] CLIPPED
#            WHEN '4'  LET l_unit = g_x[18] CLIPPED
#            OTHERWISE LET l_unit = ' '
#         END CASE
#No.TQC-6B0073  --begin
#        LET l_time = tm.yy1 CLIPPED,g_x[25] CLIPPED,tm.bm1 USING '&&',g_x[26] CLIPPED  
#         IF g_argv1 = '6' THEN
#            LET l_time = tm.yy1 CLIPPED,g_x[25] CLIPPED
#         ELSE
#            LET l_time = tm.yy1 CLIPPED,g_x[25] CLIPPED,tm.bm1 USING '&&',g_x[26] CLIPPED 
#         END IF 
#No.TQC-6B0073  --end            
#         PRINT COLUMN ((g_len-FGL_WIDTH(l_time CLIPPED))/2),l_time CLIPPED
#               COLUMN (g_len-FGL_WIDTH(g_x[24])-6),g_x[3] CLIPPED,g_pageno CLIPPED  #No.TQC-6A0094
#         PRINT g_x[23] CLIPPED,g_company CLIPPED,
#               COLUMN (g_len-FGL_WIDTH(g_x[24] CLIPPED)-6),g_x[24] CLIPPED,l_unit CLIPPED
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#         PRINT g_dash1 CLIPPED
#         LET l_last_sw = 'n'
#
#      ON EVERY ROW
#         IF tm.h='Y' THEN LET tmp.maj20=tmp.maj20e END IF
#         LET l_tot  = tmp.bal1      #當期
#         LET l_tot0 = tmp.tbal0     #年初
#         LET l_tot1 = tmp.tbal1     #期間
#         LET l_tot2 = l_tot+l_tot1  #本年實際
#         LET l_tot3 = l_tot2+l_tot0 #本年累計
#         IF tmp.maj07='2' AND g_argv1 != '4' THEN
#            LET l_tot  = l_tot * -1
#            LET l_tot0 = l_tot0 * -1
#            LET l_tot1 = l_tot1 * -1
#            LET l_tot2 = l_tot2 * -1
#            LET l_tot3 = l_tot3 * -1
#            LET tmp.bal1 = tmp.bal1 * -1
#
#            LET tmp.tbal0 = tmp.tbal0 * -1
#            LET tmp.tbal1 = tmp.tbal1 * -1
#            LET tmp.l_amt0 = tmp.l_amt0 * -1
#            LET tmp.l_amt1 = tmp.l_amt1 * -1
#            LET tmp.l_amt2 = tmp.l_amt2 * -1
#            LET tmp.l_amt3 = tmp.l_amt3 * -1
#            LET tmp.l_amt4 = tmp.l_amt4 * -1
#         END IF
#         LET per1 = (tmp.bal1 / g_basetot1) * 100
#         IF tm.d = '1' THEN LET g_unit = 1 END IF
#         IF tm.d = '2' THEN LET g_unit = 1000 END IF
#         IF tm.d = '3' THEN LET g_unit = 10000 END IF
#         IF tm.d = '4' THEN LET g_unit = 1000000 END IF
#         CASE 
#            WHEN tmp.maj03 = '9' 
#               SKIP TO TOP OF PAGE
#            WHEN tmp.maj03 = '3'
#               PRINT COLUMN g_c[33], g_dash2[1,g_w[33]],
#                     COLUMN g_c[34], g_dash2[1,g_w[34]]
#            WHEN tmp.maj03 = '0' #本行不印出,金額要加總(已在合計階處理)
#               IF (NOT cl_null(tmp.maj04)) AND tmp.maj04 > 0 THEN
#                  FOR i = 1 TO tmp.maj04
#                     PRINT
#                  END FOR
#               END IF
#            WHEN tmp.maj03 = '4'
#               PRINT g_dash2 CLIPPED
#            OTHERWISE 
#               FOR i = 1 TO tmp.maj04 PRINT END FOR
#               LET per1 = (tmp.bal1 / g_basetot1) * 100
#               #LET per2 = (tmp.bal2 / g_basetot2) * 100
#               IF cl_null(tmp.maj26) AND g_argv1 != '5' THEN
#                  LET l_tot  = NULL
#                  LET l_tot0 = NULL
#                  LET l_tot1 = NULL
#                  LET l_tot2 = NULL
#                  LET l_tot3 = NULL
#                  LET tmp.bal1 = NULL
#                  LET tmp.tbal0 = NULL
#                  LET tmp.tbal1 = NULL
#                  LET tmp.l_amt0 = NULL
#                  LET tmp.l_amt1 = NULL
#                  LET tmp.l_amt2 = NULL
#                  LET tmp.l_amt3 = NULL
#                  LET tmp.l_amt4 = NULL
#               END IF
#               CASE g_argv1
#                  WHEN "1" #資產負債表
#                     PRINT COLUMN g_c[31],tmp.maj20 CLIPPED,
#                           COLUMN g_c[32],tmp.maj26 USING '#####',
#                           COLUMN g_c[33],cl_numfor(l_tot0/g_unit,20,tm.e),
#                           COLUMN g_c[34],cl_numfor(l_tot3/g_unit,20,tm.e)
#                  WHEN "2" #利潤表
#                     PRINT COLUMN g_c[31],tmp.maj20 CLIPPED,
#                           COLUMN g_c[32],tmp.maj26 USING '#####',
#                           COLUMN g_c[33],cl_numfor(l_tot/g_unit,20,tm.e),
#                           COLUMN g_c[34],cl_numfor(l_tot3/g_unit,20,tm.e)
#                  WHEN "4" #應交增值稅明細表
#                     CASE tmp.maj06
#                        WHEN "1"
#                           LET l_tot = tmp.tbal0 - tmp.l_amt0
#                           LET l_tot3 = l_tot
#                        WHEN "2"
#                           LET l_tot = tmp.bal1 - tmp.l_amt2
#                           LET l_tot3 = tmp.tbal0 - tmp.l_amt0 + tmp.l_amt3 - tmp.l_amt4
#                        WHEN "3"
#                           LET l_tot = tmp.tbal0 - tmp.l_amt0 + tmp.tbal1 - tmp.l_amt1 + tmp.bal1 - tmp.l_amt2
#                           LET l_tot3 = tmp.tbal0 - tmp.l_amt0 + tmp.l_amt3 - tmp.l_amt4
#                        WHEN "4"
#                           LET l_tot = tmp.bal1
#                           #LET l_tot3 = tmp.tbal0 + tmp.l_amt3
#                           LET l_tot3 = tmp.l_amt3
#                        WHEN "5"
#                           LET l_tot = tmp.l_amt2
#                           #LET l_tot3 = tmp.l_amt0 + tmp.l_amt4
#                           LET l_tot3 = tmp.l_amt4
#                        WHEN "6"
#                           LET l_tot = tmp.tbal0
#                           LET l_tot3 = l_tot
#                        WHEN "7"
#                           LET l_tot = tmp.l_amt0
#                           LET l_tot3 = l_tot
#                        WHEN "8"
#                           LET l_tot = tmp.tbal0 - tmp.l_amt0 + tmp.tbal1 - tmp.l_amt1 + tmp.bal1 - tmp.l_amt2
#                           LET l_tot3 = tmp.tbal0 - tmp.l_amt0 + tmp.l_amt3 - tmp.l_amt4
#                        OTHERWISE
#                           LET l_tot = tmp.tbal0 + tmp.tbal1 + tmp.bal1
#                           LET l_tot3 = tmp.l_amt0 - tmp.l_amt4
#                     END CASE
#                     IF tmp.maj07='2' THEN
#                        LET l_tot  = l_tot * -1
#                        LET l_tot3  = l_tot3 * -1
#                     END IF
#                     PRINT COLUMN g_c[31],tmp.maj20 CLIPPED,
#                           COLUMN g_c[32],tmp.maj26 USING '#####',
#                           COLUMN g_c[33],cl_numfor(l_tot/g_unit,20,tm.e),
#                           COLUMN g_c[34],cl_numfor(l_tot3/g_unit,20,tm.e)
#                  WHEN "6" #股東權益增減變動表
#                     CASE tmp.maj06
#                        WHEN "1"
#                           LET l_tot2 = tmp.bal1
#                           LET l_tot0 = tmp.l_amt0
#                        WHEN "3"
#                           LET l_tot2 = tmp.tbal1
#                           LET l_tot0 = tmp.l_amt2
#                        OTHERWISE
#                           LET l_tot2 = tmp.tbal0
#                           LET l_tot0 = tmp.l_amt1
#                     END CASE
#                     PRINT COLUMN g_c[31],tmp.maj20[1,40] CLIPPED,
#                           COLUMN g_c[32],tmp.maj26 USING '#####',
#                           COLUMN g_c[33],cl_numfor(l_tot2/g_unit,20,tm.e),
#                           COLUMN g_c[34],cl_numfor(l_tot0/g_unit,20,tm.e)
#                  WHEN "7"
#                     IF l_tot0 < 0 THEN
#                        LET l_tot0 = l_tot0 * -1
#                     END IF
#                     IF l_tot2 < 0 THEN
#                        LET l_tot2 = l_tot2 * -1
#                     END IF
#                     PRINT COLUMN g_c[31],tmp.maj20 CLIPPED,
#                           COLUMN g_c[32],tmp.maj26 USING '#####',
#                           COLUMN g_c[33],cl_numfor(l_tot2/g_unit,20,tm.e),
#                           COLUMN g_c[34],cl_numfor(l_tot0/g_unit,20,tm.e)
#               END CASE
#          END CASE
#
#      ON LAST ROW
#         LET l_last_sw = 'y'
#
#      PAGE TRAILER
#         PRINT g_dash[1,g_len]
#         IF l_last_sw = 'n' THEN
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         END IF
#
#END REPORT
#No.FUN-780057  --END
 
#No.FUN-780057  --STR
#REPORT r116_rep1(tmp1)
#   DEFINE l_last_sw           LIKE type_file.chr1     #NO.FUN-690009   VARCHAR(01)
#   DEFINE l_unit              LIKE zaa_file.zaa08       #NO.FUN-690009   VARCHAR(04)
#   DEFINE per1,per2,per3      LIKE fid_file.fid03     #NO.FUN-690009   DEC(8,3)
#   DEFINE l_tot0,l_tot1       LIKE type_file.num20_6  #NO.FUN-690009   DEC(20,6)
#   DEFINE l_tot2,l_tot3       LIKE type_file.num20_6  #NO.FUN-690009   DEC(20,6)
#   DEFINE l_tot,l_tot0_n      LIKE type_file.num20_6  #NO.FUN-690009   DEC(20,6)
#   DEFINE l_tot_n,l_tot2_n    LIKE type_file.num20_6  #NO.FUN-690009   DEC(20,6)
#   DEFINE l_tot3_n            LIKE type_file.num20_6  #NO.FUN-690009   DEC(20,6)
#   DEFINE i                   LIKE type_file.num5     #NO.FUN-690009   SMALLINT
#   DEFINE l_i,l_i0,l_i2,l_i3  LIKE type_file.num10    #NO.FUN-690009   INTEGER
#   DEFINE l_amt3              LIKE type_file.num20_6  #NO.FUN-690009   DEC(20,6)
#   DEFINE tmp1 RECORD
#             maj02  LIKE maj_file.maj02,    #NO FUN-690009   DEC(9,4)
#             maj03  LIKE maj_file.maj03,    #NO FUN-690009   VARCHAR(01)
#             maj04  LIKE maj_file.maj04,    #NO FUN-690009   SMALLINT
#             maj06  LIKE maj_file.maj06,    #NO FUN-690009   VARCHAR(01)
#             maj07  LIKE maj_file.maj07,    #NO FUN-690009   VARCHAR(01)
#             maj20  LIKE maj_file.maj20,    #NO FUN-690009   VARCHAR(100)
#             maj20e LIKE maj_file.maj20e,   #NO FUN-690009   VARCHAR(50)
#             maj26  LIKE maj_file.maj26,    #NO FUN-690009   SMALLINT
#             bal1   LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             tbal0  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             tbal1  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt0 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt1 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt2 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt3 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt4 LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
#                END RECORD
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#   ORDER BY tmp1.maj02
#   FORMAT
#      ON EVERY ROW
#         #金額單位之列印
#         CASE tm.d
#            WHEN '1'  LET l_unit = cl_getmsg('sub-137',g_lang)
#                      LET g_unit = 1
#            WHEN '3'  LET l_unit = cl_getmsg('sub-131',g_lang)
#                      LET g_unit = 10000
#            OTHERWISE LET l_unit = ' '
#                      LET g_unit = 1
#         END CASE
#         IF tm.h='Y' THEN LET tmp1.maj20=tmp1.maj20e END IF
#         LET l_tot  = tmp1.bal1      #當期
#         LET l_tot0 = tmp1.tbal0     #年初
#         LET l_tot1 = tmp1.tbal1     #期間
#         LET l_tot2 = l_tot+l_tot1   #本年實際
#         LET l_tot3 = l_tot2+l_tot0  #本年累計
#         IF tmp1.maj07='2' AND g_argv1 != '4' THEN
#            LET l_tot  = l_tot * -1
#            LET l_tot0 = l_tot0 * -1
#            LET l_tot1 = l_tot1 * -1
#            LET l_tot2 = l_tot2 * -1
#            LET l_tot3 = l_tot3 * -1
#            LET tmp1.bal1 = tmp1.bal1 * -1
#            LET tmp1.tbal0 = tmp1.tbal0 * -1
#            LET tmp1.tbal1 = tmp1.tbal1 * -1
#            LET tmp1.l_amt0 = tmp1.l_amt0 * -1
#            LET tmp1.l_amt1 = tmp1.l_amt1 * -1
#            LET tmp1.l_amt2 = tmp1.l_amt2 * -1
#            LET tmp1.l_amt3 = tmp1.l_amt3 * -1
#            LET tmp1.l_amt4 = tmp1.l_amt4 * -1
#         END IF
#         CASE tmp1.maj03
#            WHEN '9' SKIP TO TOP OF PAGE
#            WHEN '3'
#            WHEN '0' #本行不印出,金額要加總(已在合計階處理)
#               IF (NOT cl_null(tmp1.maj04)) AND tmp1.maj04 > 0 THEN
#                  FOR i = 1 TO tmp1.maj04
#                     PRINT
#                  END FOR
#               END IF
#            WHEN '4'
#            OTHERWISE
#               IF (NOT cl_null(tmp1.maj04)) AND tmp1.maj04 > 0 THEN
#                  FOR i = 1 TO tmp1.maj04
#                     PRINT
#                  END FOR
#               END IF
#               LET per1 = (tmp1.bal1 / g_basetot1) * 100
#               PRINT '\"',g_mai02 CLIPPED,'\"',
#                     '\t',
#                     '\"',g_company CLIPPED,'\"',
#                     '\t',
#                     '\"',g_ym CLIPPED,'\"',
#                     '\t',
#                     '\"',l_unit CLIPPED,'\"',
#                     '\t',
#                     '\"',tmp1.maj20 CLIPPED,'\"',
#                     '\t';
#               IF NOT cl_null(tmp1.maj26) THEN    #行次
#                  LET i = FGL_WIDTH(tmp1.maj26)                                                                                     
#                  CASE i 
#                     WHEN "1"
#                        PRINT '\"',tmp1.maj26 USING '#','\"',
#                              '\t';
#                     WHEN "2"
#                        PRINT '\"',tmp1.maj26 USING '##','\"',
#                              '\t';
#                     WHEN "3"
#                        PRINT '\"',tmp1.maj26 USING '###','\"', 
#                              '\t';
#                     WHEN "4"
#                        PRINT '\"',tmp1.maj26 USING '####','\"', 
#                              '\t';
#                     WHEN "5"
#                        PRINT '\"',tmp1.maj26 USING '#####','\"', 
#                              '\t';
#                     OTHERWISE 
#                        PRINT ;
#                  END CASE
#               END IF
#               IF (NOT cl_null(tmp1.maj26)) OR g_argv1 = '5' THEN
#                  CASE g_argv1
#                     WHEN "1"   #資產負債表
#                        LET l_tot0_n = l_tot0/g_unit
#                        LET l_tot3_n = l_tot3/g_unit
#                        LET l_i0 = FGL_WIDTH(l_tot0_n)+tm.e+1
#                        LET l_i3 = FGL_WIDTH(l_tot3_n)+tm.e+1
#                        PRINT r116_numfor(l_tot0_n,l_i0,tm.e),
#                              '\t',
#                              r116_numfor(l_tot3_n,l_i3,tm.e)
#                     WHEN "2"   #利潤表
#                        LET l_tot_n = l_tot/g_unit
#                        LET l_tot3_n = l_tot3/g_unit
#                        LET l_i = FGL_WIDTH(l_tot_n)+tm.e+1
#                        LET l_i3 = FGL_WIDTH(l_tot3_n)+tm.e+1
#                        PRINT r116_numfor(l_tot_n,l_i,tm.e),
#                              '\t',
#                              r116_numfor(l_tot3_n,l_i3,tm.e)
#                     WHEN "4"   #應交增值稅明細表
#                        CASE tmp1.maj06
#                           WHEN "1"
#                              LET l_tot = tmp1.tbal0 - tmp1.l_amt0
#                              LET l_tot3 = l_tot
#                           WHEN "2"
#                              LET l_tot = tmp1.bal1 - tmp1.l_amt2
#                              LET l_tot3 = tmp1.tbal0 - tmp1.l_amt0 + tmp1.l_amt3 - tmp1.l_amt4
#                           WHEN "3"
#                              LET l_tot = tmp1.tbal0 - tmp1.l_amt0 + tmp1.tbal1 - tmp1.l_amt1 + tmp1.bal1 - tmp1.l_amt2
#                              LET l_tot3 = tmp1.tbal0 - tmp1.l_amt0 + tmp1.l_amt3 - tmp1.l_amt4
#                           WHEN "4"
#                              LET l_tot = tmp1.bal1
#                              #LET l_tot3 = tmp1.tbal0 + tmp1.l_amt3
#                              LET l_tot3 = tmp1.l_amt3
#                           WHEN "5"
#                              LET l_tot = tmp1.l_amt2
#                              #LET l_tot3 = tmp1.l_amt0 + tmp1.l_amt4
#                              LET l_tot3 = tmp1.l_amt4
#                           WHEN "6"
#                              LET l_tot = tmp1.tbal0
#                              LET l_tot3 = l_tot
#                           WHEN "7"
#                              LET l_tot = tmp1.l_amt0
#                              LET l_tot3 = l_tot
#                           WHEN "8"
#                              LET l_tot = tmp1.tbal0 - tmp1.l_amt0 + tmp1.tbal1 - tmp1.l_amt1 + tmp1.bal1 - tmp1.l_amt2
#                              LET l_tot3 = tmp1.tbal0 - tmp1.l_amt0 + tmp1.l_amt3 - tmp1.l_amt4
#                           OTHERWISE
#                              LET l_tot = tmp1.tbal0 + tmp1.tbal1 + tmp1.bal1
#                              LET l_tot3 = tmp1.l_amt0 - tmp1.l_amt4
#                        END CASE
#                        IF tmp1.maj07='2' THEN
#                           LET l_tot  = l_tot * -1
#                           LET l_tot3  = l_tot3 * -1
#                        END IF
#                        LET l_tot_n = l_tot/g_unit
#                        LET l_tot3_n = l_tot3/g_unit
#                        LET l_i = FGL_WIDTH(l_tot_n)+tm.e+1
#                        LET l_i3 = FGL_WIDTH(l_tot3_n)+tm.e+1
#                        PRINT r116_numfor(l_tot_n,l_i,tm.e),
#                              '\t',
#                              r116_numfor(l_tot3_n,l_i3,tm.e)
#                     WHEN "5"   #資產減值准備明細表
#                        LET tmp1.l_amt0 = tmp1.l_amt0/g_unit
#                        LET tmp1.l_amt1 = tmp1.l_amt1/g_unit
#
#                        LET tmp1.l_amt2 = tmp1.l_amt2/g_unit
#                        LET l_amt3 = tmp1.l_amt0 + tmp1.l_amt1 - tmp1.l_amt2
#                        LET l_i0 = FGL_WIDTH(tmp1.l_amt0)+tm.e+1
#                        LET l_i  = FGL_WIDTH(tmp1.l_amt1)+tm.e+1
#                        LET l_i2 = FGL_WIDTH(tmp1.l_amt2)+tm.e+1
#                        LET l_i3 = FGL_WIDTH(l_amt3)+tm.e+1
#                        PRINT r116_numfor(tmp1.l_amt0,l_i0,tm.e),
#                              '\t';
#                        IF tmp1.maj07 = '2' THEN
#                           PRINT r116_numfor(-tmp1.l_amt2,l_i2,tm.e),
#                                 '\t',
#                                 r116_numfor(-tmp1.l_amt1,l_i,tm.e),
#                                 '\t';
#                        ELSE
#                           PRINT r116_numfor(tmp1.l_amt1,l_i,tm.e),
#                                 '\t',
#                                 r116_numfor(tmp1.l_amt2,l_i2,tm.e),
#                                 '\t';
#                        END IF
#                        PRINT r116_numfor(l_amt3,l_i3,tm.e)
#                     WHEN "6"   #股東權益增減變動表
#                        CASE tmp1.maj06
#                           WHEN "1"
#                              LET l_tot2_n = tmp1.bal1
#                              LET l_tot0_n = tmp1.l_amt0
#                           WHEN "3"
#                              LET l_tot2_n = tmp1.tbal1
#                              LET l_tot0_n = tmp1.l_amt2
#                           OTHERWISE
#                              LET l_tot2_n = tmp1.tbal0
#                              LET l_tot0_n = tmp1.l_amt1
#                        END CASE
#                        LET l_tot2_n = l_tot2_n/g_unit
#                        LET l_tot0_n = l_tot0_n/g_unit
#                        LET l_i2 = FGL_WIDTH(l_tot2_n)+tm.e+1
#                        LET l_i0 = FGL_WIDTH(l_tot0_n)+tm.e+1
#                        PRINT r116_numfor(l_tot2_n,l_i2,tm.e),   #本年數
#                              '\t',
#                              r116_numfor(l_tot0_n,l_i0,tm.e)    #上年數
#                     WHEN "7"   #利潤分配表
#                        LET l_tot2_n = l_tot2
#                        LET l_tot0_n = l_tot0
#                        LET l_tot2_n = l_tot2_n/g_unit
#                        LET l_tot0_n = l_tot0_n/g_unit
#                        IF l_tot0_n < 0 THEN
#                           LET l_tot0_n = l_tot0_n * -1
#                        END IF
#                        IF l_tot2_n < 0 THEN
#                           LET l_tot2_n = l_tot2_n * -1
#                        END IF
#                        LET l_i2 = FGL_WIDTH(l_tot2_n)+tm.e+1
#                        LET l_i0 = FGL_WIDTH(l_tot0_n)+tm.e+1
#                        PRINT r116_numfor(l_tot2_n,l_i2,tm.e),
#                              '\t',
#                              r116_numfor(l_tot0_n,l_i0,tm.e)
#                     OTHERWISE PRINT
#                  END CASE
#               ELSE
#                  PRINT '\t','\t'
#               END IF
#         END CASE
#END REPORT
#No.FUN-780057  --END
 
#No.FUN-780057  --STR
#REPORT r116_rep2(tmp)
#   DEFINE l_last_sw        LIKE type_file.chr1     #NO FUN-690009   VARCHAR(01)
#   DEFINE l_unit           LIKE zaa_file.zaa08       #NO FUN-690009   VARCHAR(04)
#   DEFINE l_time           LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)
#   DEFINE per1,per2,per3   LIKE fid_file.fid03   #NO FUN-690009   DEC(8,3)
#   DEFINE l_tot0,l_tot1,l_tot2,l_tot3,l_tot LIKE type_file.num20_6    #NO FUN-690009   DEC(20,6)
#   DEFINE tmp RECORD
#             maj02  LIKE maj_file.maj02,    #NO FUN-690009   DEC(9,4)
#             maj03  LIKE maj_file.maj03,    #NO FUN-690009   VARCHAR(01)
#             maj04  LIKE maj_file.maj04,    #NO FUN-690009   SMALLINT
#             maj06  LIKE maj_file.maj06,    #NO FUN-690009   VARCHAR(01)
#             maj07  LIKE maj_file.maj07,    #NO FUN-690009   VARCHAR(01)
#             maj20  LIKE maj_file.maj20,    #NO FUN-690009   VARCHAR(100)
#             maj20e LIKE maj_file.maj20e,   #NO FUN-690009   VARCHAR(50)
#             maj26  LIKE maj_file.maj26,    #NO FUN-690009   SMALLINT
#             bal1   LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             tbal0  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             tbal1  LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt0 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt1 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt2 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt3 LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#             l_amt4 LIKE type_file.num20_6  #NO FUN-690009   DEC(20,6)
#               END RECORD
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#   ORDER BY tmp.maj02
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED #No.TQC-6A0094
#         #金額單位之列印
#         CASE tm.d
#            WHEN '1'  LET l_unit = g_x[16] CLIPPED
#            WHEN '2'  LET l_unit = g_x[17] CLIPPED
#            WHEN '3'  LET l_unit = g_x[21] CLIPPED
#            WHEN '4'  LET l_unit = g_x[18] CLIPPED
#            OTHERWISE LET l_unit = ' '
#         END CASE
#        LET l_time = tm.yy1 CLIPPED,g_x[25] CLIPPED,tm.bm1 USING '&&',g_x[26] CLIPPED   #No.TQC-6B0073
#         LET l_time = tm.yy1 CLIPPED,g_x[25] CLIPPED   #No.TQC-6B0073
#         PRINT COLUMN ((g_len-FGL_WIDTH(l_time))/2),l_time
#               COLUMN (g_len-FGL_WIDTH(g_x[24])-6),g_x[3] CLIPPED,g_pageno CLIPPED  #No.TQC-6A0094
#         PRINT g_x[23] CLIPPED,g_company,
#               COLUMN (g_len-FGL_WIDTH(g_x[24] CLIPPED)-6),g_x[24] CLIPPED,l_unit CLIPPED
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#         PRINT g_dash1 CLIPPED
#         LET l_last_sw = 'n'
#
#      ON EVERY ROW
#         IF tm.d = '1' THEN LET g_unit = 1 END IF
#         IF tm.d = '2' THEN LET g_unit = 1000 END IF
#         IF tm.d = '3' THEN LET g_unit = 10000 END IF
#         IF tm.d = '4' THEN LET g_unit = 1000000 END IF
#         IF tmp.maj07='2' AND g_argv1 != '4' THEN
#            LET l_tot  = l_tot * -1
#            LET l_tot0 = l_tot0 * -1
#            LET l_tot1 = l_tot1 * -1
#            LET l_tot2 = l_tot2 * -1
#            LET l_tot3 = l_tot3 * -1
#            LET tmp.bal1 = tmp.bal1 * -1
#            LET tmp.tbal0 = tmp.tbal0 * -1
#            LET tmp.tbal1 = tmp.tbal1 * -1
#            LET tmp.l_amt0 = tmp.l_amt0 * -1
#            LET tmp.l_amt1 = tmp.l_amt1 * -1
#            LET tmp.l_amt2 = tmp.l_amt2 * -1
#            LET tmp.l_amt3 = tmp.l_amt3 * -1
#            LET tmp.l_amt4 = tmp.l_amt4 * -1
#         END IF
#         LET per1 = (tmp.bal1 / g_basetot1) * 100
#         CASE 
#            WHEN tmp.maj03 = '9' 
#               SKIP TO TOP OF PAGE
#            WHEN tmp.maj03 = '3'
#               PRINT COLUMN g_c[32], g_dash2[1,g_w[32]],
#                     COLUMN g_c[33], g_dash2[1,g_w[33]],
#                     COLUMN g_c[34], g_dash2[1,g_w[34]],
#                     COLUMN g_c[35], g_dash2[1,g_w[35]]
#            WHEN tmp.maj03 = '0' #本行不印出,金額要加總(已在合計階處理)
#               IF (NOT cl_null(tmp.maj04)) AND tmp.maj04 > 0 THEN
#                  FOR i = 1 TO tmp.maj04
#                     PRINT
#                  END FOR
#               END IF
#            WHEN tmp.maj03 = '4'
#               PRINT g_dash2 CLIPPED
#            OTHERWISE
#               PRINT COLUMN g_c[31],tmp.maj20 CLIPPED,
#                     COLUMN g_c[32],cl_numfor(tmp.l_amt0/g_unit,20,tm.e);
#               IF tmp.maj07 = '2' THEN
#                  PRINT COLUMN g_c[33],cl_numfor(-tmp.l_amt2/g_unit,20,tm.e),
#                        COLUMN g_c[34],cl_numfor(-tmp.l_amt1/g_unit,20,tm.e);
#               ELSE
#                  PRINT COLUMN g_c[33],cl_numfor(tmp.l_amt1/g_unit,20,tm.e),
#                        COLUMN g_c[34],cl_numfor(tmp.l_amt2/g_unit,20,tm.e);
#               END IF
#               PRINT COLUMN g_c[35],cl_numfor((tmp.l_amt0+tmp.l_amt1-tmp.l_amt2)/g_unit,20,tm.e)
#         END CASE
#      ON LAST ROW
#         LET l_last_sw = 'y'
#
#      PAGE TRAILER
#         PRINT g_dash[1,g_len]
#         IF l_last_sw = 'n' THEN
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         END IF
#
#END REPORT
#No.FUN-780057  --END 
 
#No.FUN-570087  -add
FUNCTION formula_gen(p_str,p_chr)
   DEFINE p_str  STRING,
          l_tmp  STRING,
          p_chr  LIKE type_file.chr1     #NO FUN-690009   VARCHAR(01)
 
   IF cl_null(p_str) OR p_chr NOT MATCHES '[12]' THEN
      ERROR "ERROR STRING"
      RETURN
   END IF
 
   # 先計算如出現TMONTH,則需替換為 tm.em2
   # 僅在年合計金額邊判斷，不判斷月合計
   FOR g_for_cnt = 1 TO g_i
      LET g_ser_str = 'TMONTH'
      FOR g_str_len = 1 TO g_for_str.getLength()
         LET g_str_cnt =g_for_str.getIndexOf(g_ser_str,g_str_len)
         IF g_str_cnt > 0 THEN
            LET g_beg_pos = g_str_cnt - 1
            LET g_end_pos = g_beg_pos + g_ser_str.getLength() + 1
            IF p_chr = '1' THEN
               EXIT FOR
            ELSE
#              LET g_for_str = g_for_str.subString(1,g_beg_pos),tm.em2,
#                              g_for_str.subString(g_end_pos,g_for_str.getLength())
            END IF
            LET g_str_len = g_end_pos
         ELSE
            EXIT FOR
         END IF
      END FOR
   END FOR
 
   # 先計算如出現上月公式，則需替換為上月金額 sr.lbal
   # 僅在月合計金額邊判斷，不判斷年合計
   FOR g_for_cnt = 1 TO g_i
      LET l_tmp = g_formula[g_for_cnt].maj02
      LET l_tmp = l_tmp.trimLeft()
      LET g_ser_str = 'L',l_tmp
      FOR g_str_len = 1 TO g_for_str.getLength()
         LET g_str_cnt =g_for_str.getIndexOf(g_ser_str,g_str_len)
         IF g_str_cnt > 0 THEN
            LET g_beg_pos = g_str_cnt - 1
            LET g_end_pos = g_beg_pos + g_ser_str.getLength() + 1
            IF p_chr = '1' THEN
               LET g_for_str = g_for_str.subString(1,g_beg_pos),
                               g_formula[g_for_cnt].lbal1 CLIPPED,
                               g_for_str.subString(g_end_pos,g_for_str.getLength())
            ELSE
               EXIT FOR
            END IF
            LET g_str_len = g_end_pos
         ELSE
            EXIT FOR
         END IF
      END FOR
   END FOR
 
   # 替換公式中出現的序號金額 sr.bal1
   FOR g_for_cnt = 1 TO g_i
      LET g_ser_str = g_formula[g_for_cnt].maj02 CLIPPED
      FOR g_str_len = 1 TO g_for_str.getLength()
         LET g_str_cnt =g_for_str.getIndexOf(g_ser_str,g_str_len)
         IF g_str_cnt > 0 THEN
            LET g_beg_pos = g_str_cnt - 1
            LET g_end_pos = g_beg_pos + g_ser_str.getLength() + 1
            IF p_chr = '1' THEN
               LET g_for_str = g_for_str.subString(1,g_beg_pos),
                               g_formula[g_for_cnt].bal1 CLIPPED,
                               g_for_str.subString(g_end_pos,g_for_str.getLength())
#           ELSE
#              LET g_for_str = g_for_str.subString(1,g_beg_pos),
#                              g_formula[g_for_cnt].bal2 CLIPPED,
#                              g_for_str.subString(g_end_pos,g_for_str.getLength())
            END IF
            LET g_str_len = g_end_pos
         ELSE
            EXIT FOR
         END IF
      END FOR
   END FOR
 
END FUNCTION
 
FUNCTION r116_numfor(p_value,p_len,p_n)
   DEFINE p_value	LIKE type_file.num26_10,#  NO FUN-690009   DECIMAL(26,10),
          p_len,p_n	LIKE type_file.num5,    #  NO FUN-690009   SMALLINT
          l_len 	LIKE type_file.num5,    #  NO FUN-690009   SMALLINT
          l_str		LIKE type_file.chr1000, #  NO FUN-690009   VARCHAR(37)
          l_str1        LIKE type_file.chr1,    #  NO FUN-690009   VARCHAR(01)
          l_length      LIKE type_file.num5,    #  NO FUN-690009   SMALLINT
          i,j,k         LIKE type_file.num5     #  NO FUN-690009   SMALLINT
                                                   
   IF NOT cl_null(g_xml_rep) THEN
      LET l_len = g_w[p_len]
   END IF
   IF l_len > 0 THEN LET p_len = l_len END IF
   LET p_value = cl_digcut(p_value,p_n)
   CASE WHEN p_n = 0  LET l_str = p_value USING '------------------------------------&'
        WHEN p_n = 10 LET l_str = p_value USING '-------------------------&.&&&&&&&&&&'
        WHEN p_n = 9  LET l_str = p_value USING '--------------------------&.&&&&&&&&&'
        WHEN p_n = 8  LET l_str = p_value USING '---------------------------&.&&&&&&&&'
        WHEN p_n = 7  LET l_str = p_value USING '----------------------------&.&&&&&&&'
        WHEN p_n = 6  LET l_str = p_value USING '-----------------------------&.&&&&&&'
        WHEN p_n = 5  LET l_str = p_value USING '------------------------------&.&&&&&'
        WHEN p_n = 4  LET l_str = p_value USING '-------------------------------&.&&&&'
        WHEN p_n = 3  LET l_str = p_value USING '--------------------------------&.&&&'
        WHEN p_n = 2  LET l_str = p_value USING '---------------------------------&.&&'
        WHEN p_n = 1  LET l_str = p_value USING '----------------------------------&.&'
   END CASE
   LET j=37                    #TQC-640038
   LET i = j - p_len + 8
   IF i < 0 THEN               #FUN-560048
        IF not cl_null(g_xml_rep) THEN
          LET i = 0
        ELSE
          LET i = 1
        END IF
   END IF
 
   LET l_length = 0
   #當傳進的金額位數實際上大於所要求回傳的位數時，該欄位應show"*****" NO:0508
   FOR k = 37 TO 1 STEP -1                        #MOD-590093 #TQC-640038
       LET l_str1 = l_str[k,k]
       IF cl_null(l_str1) THEN EXIT FOR END IF
       LET l_length = l_length + 1
   END FOR
   IF l_length > p_len THEN
      LET i = j - l_length
      IF i < 0 THEN
            RETURN l_str
      END IF
   END IF
   IF not cl_null(g_xml_rep) THEN
      RETURN l_str[i+1,j]
   ELSE
      RETURN l_str[i,j]
   END IF
END FUNCTION
