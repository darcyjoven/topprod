# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg112.4gl
# Descriptions...: 兩期財務報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/10 By Nora
# Modify.........: No.MOD-4A0248 04/10/18 By Yuna QBE開窗開不出來
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.MOD-510052 05/01/20 By Kitty 若為資產負債表起始月份不可輸入
# Modify.........: No.FUN-510007 05/02/18 By Nicola 報表架構修改
# Modify.........: No.MOD-560188 05/06/27 By Nicola 報表結構 列印碼設定 "3" OR "4" 資料印出異常
# Modify.........: No.TQC-620081 06/02/20 By Smapmin 當月結方法選擇為帳結法時，
#                                                    相關財務報表無法產出累計/前期損益表  
# Modify.........: No.TQC-630260 06/03/28 By Smapmin 第二期的數值有誤
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.MOD-680002 06/08/02 By Smapmin 修正TQC-620081
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0093 06/11/08 By Carrier 報表格式調整
# Modify.........: No.TQC-6B0171 06/11/27 By Smapmin 金額不可為NULL
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.MOD-720040 07/02/08 By TSD.Jin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-730135 07/03/28 By Smapmin 修正TQC-620081
# Modify.........: No.FUN-740020 07/04/06 By sherry  會計科目加帳套
# Modify.........: No.MOD-870217 08/07/17 By Smapmin 金額為0不印出,應納入maj03=5的條件
# Modify.........: No.MOD-910208 09/01/17 By Sarah 列印碼設定為H會印出金額與百分比,應復原TQC-6B0171附予sr.bal1,sr.bal2,sr.bal3值段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0405 09/12/25 By Dido 無法切換語言別 
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No.MOD-A60135 10/06/21 By Dido 合計階增加 maj09 處理 
# Modify.........: No:CHI-A70061 10/08/25 By Summer 先列印空白再列印資料
# Modify.........: No:MOD-B70285 11/07/29 By Carrier CE凭证时考虑部门设置
# Modify.........: No.FUN-B80158 11/08/26 By yangtt  明細類CR轉換成GRW
# Modify.........: No.FUN-B80158 12/01/05 By qirl FUN-B90140追單
# Modify.........: No.FUN-B80158 12/01/16 By xuxz MOD-BB0296追單
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1,             #報表結構編號 #No.FUN-680098  VARCHAR(1)
                 a      LIKE mai_file.mai01,             #報表結構編號 #No.FUN-680098  VARCHAR(6)
                 b      LIKE aaa_file.aaa01,             #帳別編號    #No.FUN-670039  
                 title1  LIKE type_file.chr8,            #輸入期別名稱#No.FUN-680098   VARCHAR(8) 
                 yy1     LIKE type_file.num5,            #輸入年度#No.FUN-680098       smallint
                 bm1     LIKE type_file.num5,            #Begin 期別#No.FUN-680098     smallint
                 em1     LIKE type_file.num5,            # End  期別#No.FUN-680098     smallint
                 title2  LIKE type_file.chr8,            #輸入期別名稱#No.FUN-680098   VARCHAR(8)
                 yy2     LIKE type_file.num5,            #輸入年度#No.FUN-680098       smallint
                 bm2     LIKE type_file.num5,            #Begin 期別#No.FUN-680098     smallint 
                 em2     LIKE type_file.num5,            # End  期別#No.FUN-680098     smallint
                 c       LIKE type_file.chr1,            #異動額及餘額為0者是否列印#No.FUN-680098   VARCHAR(1)
                 d       LIKE type_file.chr1,            #金額單位#No.FUN-680098   VARCHAR(1)
                 e       LIKE type_file.num5,            #小數位數#No.FUN-680098  smallint
                 f       LIKE type_file.num5,            #列印最小階數#No.FUN-680098  smallint
                 h       LIKE type_file.chr4,              #額外說明類別#No.FUN-680098   VARCHAR(4)
                 o       LIKE type_file.chr1,            #轉換幣別否#No.FUN-680098   VARCHAR(1)
                 p      LIKE azi_file.azi01,  #幣別
                 q      LIKE azj_file.azj03,  #匯率
                 r      LIKE azi_file.azi01,  #幣別
                 more    LIKE type_file.chr1,            #Input more condition(Y/N)#No.FUN-680098    VARCHAR(1)
                 acc_code  LIKE type_file.chr1    #FUN-B80158   Add
              END RECORD,
          bdate,edate     LIKE type_file.dat,           #No.FUN-680098   date
          i,j,k            LIKE type_file.num5,         #No.FUN-680098  smallint
          g_unit     LIKE type_file.num10,              #金額單位基數   #No.FUN-680098  integer 
 #        g_dash2    VARCHAR(132),           #No.MOD-560188 Mark 
          g_bookno   LIKE aah_file.aah00, #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot2     ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot3     ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_basetot1 LIKE aah_file.aah04,
          g_basetot2 LIKE aah_file.aah04,
          g_basetot3 LIKE aah_file.aah04
   DEFINE g_aaa03    LIKE aaa_file.aaa03   
   DEFINE g_i        LIKE type_file.num5    #count/index for any purpose  #No.FUN-680098  smallint
   DEFINE g_msg      LIKE type_file.chr1000 #No.FUN-680098    VARCHAR(72)
   DEFINE l_table    STRING                 #MOD-720040 By TSD.Jin
   DEFINE g_str      STRING                 #MOD-720040 By TSD.Jin
   DEFINE g_sql      STRING                 #MOD-720040 By TSD.Jin
   DEFINE g_aaa09    LIKE aaa_file.aaa09   #MOD-730135
 
###GENGRE###START
TYPE sr1_t RECORD
    maj31 LIKE maj_file.maj31,   #NO.FUN-B80158 ADD
    maj01 LIKE maj_file.maj01,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    maj04 LIKE maj_file.maj04,
    maj05 LIKE maj_file.maj05,
    maj06 LIKE maj_file.maj06,
    maj07 LIKE maj_file.maj07,
    maj08 LIKE maj_file.maj08,
    maj09 LIKE maj_file.maj09,
    maj10 LIKE maj_file.maj10,
    maj11 LIKE maj_file.maj11,
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj21 LIKE maj_file.maj21,
    maj22 LIKE maj_file.maj22,
    maj23 LIKE maj_file.maj23,
    maj24 LIKE maj_file.maj24,
    maj25 LIKE maj_file.maj25,
    maj26 LIKE maj_file.maj26,
    maj27 LIKE maj_file.maj27,
    maj28 LIKE maj_file.maj28,
    maj29 LIKE maj_file.maj29,
    maj30 LIKE maj_file.maj30,
    line LIKE type_file.num5,
    bal1 LIKE aah_file.aah04,
    bal2 LIKE aah_file.aah04,
    bal3 LIKE aah_file.aah04,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114#FUN-B80158 mark
 
   #MOD-720040 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " maj31.maj_file.maj31, ", #FUN-B80158 add maj31
               " maj01.maj_file.maj01, ",
               " maj02.maj_file.maj02, ",
               " maj03.maj_file.maj03, ",
               " maj04.maj_file.maj04, ",
               " maj05.maj_file.maj05, ",
               " maj06.maj_file.maj06, ",
               " maj07.maj_file.maj07, ",
               " maj08.maj_file.maj08, ",
               " maj09.maj_file.maj09, ",
               " maj10.maj_file.maj10, ",
               " maj11.maj_file.maj11, ",
               " maj20.maj_file.maj20, ",
               " maj20e.maj_file.maj20e, ",
               " maj21.maj_file.maj21, ",
               " maj22.maj_file.maj22, ",
               " maj23.maj_file.maj23, ",
               " maj24.maj_file.maj24, ",
               " maj25.maj_file.maj25, ",
               " maj26.maj_file.maj26, ",
               " maj27.maj_file.maj27, ",
               " maj28.maj_file.maj28, ",
               " maj29.maj_file.maj29, ",
               " maj30.maj_file.maj30, ",
               " line.type_file.num5, ", #CHI-A70061 add
               " bal1.aah_file.aah04,  ",
               " bal2.aah_file.aah04,  ",
               " bal3.aah_file.aah04,  ",
               " azi03.azi_file.azi03, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05  " 
  
   LET l_table = cl_prt_temptable('aglg112',g_sql) CLIPPED  # 產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      #CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add#FUN-B80158 mark
      EXIT PROGRAM 
   END IF                 # Temp Table產生有錯
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,  #TQC-A40133 mark
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,?) " #CHI-A70061 add ?      #FUN-B80158 add ?
  
   PREPARE insert_prep FROM g_sql
   IF sqlca.sqlcode THEN
      CALL cl_err('insert_prep:',status,1)
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add#FUN-B80158 mark
      #CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add#FUN-B80158 mark
      EXIT PROGRAM
   END IF
   #MOD-720040 By TSD.Jin--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80158 add
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)   #TQC-610056
   LET tm.title1 = ARG_VAL(11)   #TQC-610056
   LET tm.yy1 = ARG_VAL(12)
   LET tm.bm1 = ARG_VAL(13)
   LET tm.em1 = ARG_VAL(14)
   LET tm.title2 = ARG_VAL(15)   #TQC-610056
   LET tm.yy2 = ARG_VAL(16)   #TQC-610056
   LET tm.bm2 = ARG_VAL(17)   #TQC-610056
   LET tm.em2 = ARG_VAL(18)   #TQC-610056
   LET tm.c  = ARG_VAL(19)
   LET tm.d  = ARG_VAL(20)
   LET tm.e  = ARG_VAL(21)
   LET tm.f  = ARG_VAL(22)
   LET tm.h  = ARG_VAL(23)
   LET tm.o  = ARG_VAL(24)
   LET tm.p  = ARG_VAL(25)
   LET tm.q  = ARG_VAL(26)
   LET tm.r  = ARG_VAL(27)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(28)
   LET g_rep_clas = ARG_VAL(29)
   LET g_template = ARG_VAL(30)
   LET g_rpt_name = ARG_VAL(31)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
  #No.FUN-740020---begin---
   IF cl_null(tm.b) THEN
      LET tm.b = g_aza.aza81
   END IF 
  #No.FUN-740020---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g112_tm()                # Input print condition
      ELSE CALL g112()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION g112_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680098  smallint
          l_sw          LIKE type_file.chr1,     #重要欄位是否空白  #No.FUN-680098   VARCHAR(1)
          l_cmd         LIKE type_file.chr1000   #No.FUN-680098    VARCHAR(400)
   DEFINE li_chk_bookno   LIKE type_file.num5    #No.FUN-670005  #No.FUN-680098  smallint
   DEFINE li_result     LIKE type_file.num5      #No.FUN-6C0068
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 11
 
   END IF
   OPEN WINDOW g112_w AT p_row,p_col
        WITH FORM "agl/42f/aglg112" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0) #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
   LET tm.title1 = 'M.T.D.'
   LET tm.title2 = 'Y.T.D.'
#  LET tm.b = g_bookno     #No.FUN-740020
   LET tm.b = g_aza.aza81  #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.acc_code = 'N'   #FUN-B80158   Add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
#   INPUT BY NAME tm.rtype,tm.a,tm.b,
    INPUT BY NAME tm.rtype,tm.b,tm.a,    #No.FUN-740020
                  tm.title1,tm.yy1,tm.bm1,tm.em1,
                  tm.title2,tm.yy2,tm.bm2,tm.em2,
                  tm.e,tm.f,tm.d,tm.acc_code,tm.c,tm.h,tm.o,tm.r,    #FUN-B80158 add tm.acc_code
                 tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
          CALL cl_dynamic_locale()                  #MOD-9C0405 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
       #No.MOD-510052
      BEFORE FIELD rtype 
         CALL g112_set_entry()  
 
      AFTER FIELD rtype 
       IF tm.rtype='1' THEN
         LET tm.bm1=0
         LET tm.bm2=0
         CALL g112_set_no_entry()
       END IF
       #No.MOD-510052 end
 
      AFTER FIELD a
         IF tm.a IS NULL THEN NEXT FIELD a END IF
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a 
                  AND mai00 = tm.b    #No.FUN-740020
                  AND maiacti IN ('Y','y')
         IF STATUS THEN 
#           CALL cl_err('sel mai:',STATUS,0)  #No.FUN-660123
            CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660123
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
         IF tm.b IS NULL THEN
            NEXT FIELD b END IF 
         #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN 
#           CALL cl_err('sel aaa:',STATUS,0)  #No.FUN-660123
            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
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
         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
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
#         IF tm.bm1 <1 OR tm.bm1 > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD bm1
#         END IF
#No.TQC-720032 -- end --
  
      AFTER FIELD em1
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
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
#         IF tm.em1 <1 OR tm.em1 > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em1
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF
         IF tm.yy2 IS NULL THEN
            LET tm.yy2 = tm.yy1
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
            DISPLAY BY NAME tm.yy2,tm.bm2,tm.em2
         END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
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
#           CALL cl_err(tm.p,'agl-109',0) #No.FUN-660123
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)   #No.FUN-660123
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
         IF tm.bm1 IS NULL THEN 
            LET l_sw = 0 
            DISPLAY BY NAME tm.bm1 
        END IF
         IF tm.em1 IS NULL THEN 
            LET l_sw = 0 
            DISPLAY BY NAME tm.em1 
        END IF
        IF l_sw = 0 THEN 
            LET l_sw = 1 
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
         IF INFIELD(a) THEN
#           CALL q_mai(0,0,tm.a,tm.a) RETURNING tm.a
            #No.BUG_480213
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
           #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020  #No.TQC-C50042   Mark
            LET g_qryparam.where = " mai00 = '",tm.b,"'  AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
            CALL cl_create_qry() RETURNING tm.a
            #No.BUG_480213 (end)
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
          #No.MOD-4C0156 add
         IF INFIELD(b) THEN
#           CALL q_aaa(0,0,tm.b) RETURNING tm.b
#           CALL FGL_DIALOG_SETBUFFER( tm.b )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.b
            CALL cl_create_qry() RETURNING tm.b 
#            CALL FGL_DIALOG_SETBUFFER( tm.b )
            DISPLAY BY NAME tm.b
            NEXT FIELD b
         END IF
          #No.MOD-4C0156 end
         IF INFIELD(p) THEN
             #--No.MOD-4A0248----
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azi'
            LET g_qryparam.default1 = tm.p
            CALL cl_create_qry() RETURNING tm.p
            #--END--------------
#           CALL q_azi(6,10,tm.p) RETURNING tm.p
#           CALL FGL_DIALOG_SETBUFFER( tm.p )
            DISPLAY BY NAME tm.p
            NEXT FIELD p
         END IF
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g112_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg112'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg112','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.rtype CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-610056
                         " '",tm.title1 CLIPPED,"'",   #TQC-610056
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.bm1 CLIPPED,"'",
                         " '",tm.em1 CLIPPED,"'",
                         " '",tm.title2 CLIPPED,"'",   #TQC-610056
                         " '",tm.yy2 CLIPPED,"'",   #TQC-610056
                         " '",tm.bm2 CLIPPED,"'",   #TQC-610056
                         " '",tm.em2 CLIPPED,"'",   #TQC-610056
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.p CLIPPED,"'",
                         " '",tm.q CLIPPED,"'",
                         " '",tm.r CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglg112',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g112()
   ERROR ""
END WHILE
   CLOSE WINDOW g112_w
END FUNCTION
 
FUNCTION g112()
   DEFINE l_name     LIKE type_file.chr20     # External(Disk) file name#No.FUN-680098   VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0073
   DEFINE l_sql      LIKE type_file.chr1000   # RDSQL STATEMENT   #No.FUN-680098   VARCHAR(1000)
   DEFINE l_chr      LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
   DEFINE amt1,amt2  LIKE aah_file.aah04
   DEFINE amt3       LIKE aah_file.aah04
   DEFINE maj        RECORD LIKE maj_file.*
   DEFINE sr         RECORD
                       bal1      LIKE aah_file.aah04,
                       bal2      LIKE aah_file.aah04,
                       bal3      LIKE aah_file.aah04
                     END RECORD
   #-----TQC-620081---------
   DEFINE l_endy1   LIKE abb_file.abb07
   DEFINE l_endy2   LIKE abb_file.abb07
   #-----END TQC-620081-----
   DEFINE l_abb05   LIKE abb_file.abb05   #No.MOD-B70285
 
   #MOD-720040 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
   #MOD-720040 By TSD.Jin--end
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #MOD-720040 By TSD.Jin
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g112_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g112_c CURSOR FOR g112_p
 
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR #no.6227
 
#MOD-720040 By TSD.Jin--start mark
#  CALL cl_outnam('aglg112') RETURNING l_name
#  START REPORT g112_rep TO l_name
#MOD-720040 By TSD.Jin--end mark
   FOREACH g112_c INTO maj.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET amt1 = 0 LET amt2 = 0 LET amt3 = 0 
     #No.MOD-B70285  --Begin
     IF maj.maj24 IS NULL THEN
        LET l_abb05 = ' '
     ELSE
        LET l_abb05 = maj.maj24
     END IF
     #No.MOD-B70285  --End
     IF NOT cl_null(maj.maj21) THEN
        IF maj.maj24 IS NULL
           THEN SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
                 WHERE aah00 = tm.b
                   AND aag00 = tm.b      #No.FUN-740020
                   AND aah01 BETWEEN maj.maj21 AND maj.maj22
                   AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                   AND aah01 = aag01 AND aag07 IN ('2','3')
           ELSE SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
                 WHERE aao00 = tm.b
                   AND aag00 = tm.b      #No.FUN-740020
                   AND aao01 BETWEEN maj.maj21 AND maj.maj22
                   AND aao02 BETWEEN maj.maj24 AND maj.maj25
                   AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                   AND aao01 = aag01  AND aag07 IN ('2','3')
        END IF
        IF STATUS THEN CALL cl_err('sel aah1:',STATUS,1) EXIT FOREACH END IF
        IF amt1 IS NULL THEN LET amt1 = 0 END IF
        #-----TQC-620081---------
        #-----MOD-730135---------
        LET g_aaa09 = ''
        SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
        IF g_aaa09 = '2' THEN
        #IF g_aza.aza26 = '2' THEN
        #-----END MOD-730135-----
           #SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file   #MOD-680002
           SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file,aag_file   #MOD-680002
            WHERE abb00 = tm.b
              AND aag00 = tm.b      #No.FUN-740020
              AND aba00 = abb00 AND aba01 = abb01
              AND abb03 BETWEEN maj.maj21 AND maj.maj22
              AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy1
              AND abb05 = l_abb05      #No.MOD-B70285
              AND aba04 BETWEEN tm.bm1 AND tm.em1
              AND abapost = 'Y'
              AND abb03 = aag01   #MOD-680002
              AND aag03 <> '4'   #MOD-680002
           #SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file   #MOD-680002
           SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file,aag_file   #MOD-680002
            WHERE abb00 = tm.b
              AND aag00 = tm.b      #No.FUN-740020
              AND aba00 = abb00 AND aba01 = abb01
              AND abb03 BETWEEN maj.maj21 AND maj.maj22
              AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy1
              AND abb05 = l_abb05      #No.MOD-B70285
              AND aba04 BETWEEN tm.bm1 AND tm.em1
              AND abapost = 'Y'
              AND abb03 = aag01   #MOD-680002
              AND aag03 <> '4'   #MOD-680002
           IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
           IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
           LET amt1 = amt1 - (l_endy1 - l_endy2)
         END IF
        #-----END TQC-620081-----
     END IF
     IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
        IF maj.maj24 IS NULL
           THEN SELECT SUM(aah04-aah05) INTO amt2 FROM aah_file,aag_file
                 WHERE aah00 = tm.b
                   AND aag00 = tm.b      #No.FUN-740020
                   AND aah01 BETWEEN maj.maj21 AND maj.maj22
                   AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                   AND aah01 = aag01 AND aag07 IN ('2','3')
           ELSE SELECT SUM(aao05-aao06) INTO amt2 FROM aao_file,aag_file
                 WHERE aao00 = tm.b
                   AND aag00 = tm.b      #No.FUN-740020
                   AND aao01 BETWEEN maj.maj21 AND maj.maj22
                   AND aao02 BETWEEN maj.maj24 AND maj.maj25
                   AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                   AND aao01 = aag01  AND aag07 IN ('2','3')
        END IF
        IF STATUS THEN CALL cl_err('sel aah2:',STATUS,1) EXIT FOREACH END IF
        IF amt2 IS NULL THEN LET amt2 = 0 END IF
        #-----TQC-620081---------
        #-----MOD-730135---------
        LET g_aaa09 = ''
        SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
        IF g_aaa09 = '2' THEN
        #IF g_aza.aza26 = '2' THEN
        #-----END MOD-730135-----
           #SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file   #MOD-680002
           SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file,aag_file   #MOD-680002
            WHERE abb00 = tm.b
              AND aag00 = tm.b      #No.FUN-740020
              AND aba00 = abb00 AND aba01 = abb01
              AND abb03 BETWEEN maj.maj21 AND maj.maj22
              AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy2
              AND abb05 = l_abb05      #No.MOD-B70285
              AND aba04 BETWEEN tm.bm2 AND tm.em2
              AND abapost = 'Y'
              AND abb03 = aag01   #MOD-680002
              AND aag03 <> '4'   #MOD-680002
           #SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file   #MOD-680002
           SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file,aag_file   #MOD-680002
            WHERE abb00 = tm.b
              AND aag00 = tm.b      #No.FUN-740020
              AND aba00 = abb00 AND aba01 = abb01
              AND abb03 BETWEEN maj.maj21 AND maj.maj22
              AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy2
              AND abb05 = l_abb05      #No.MOD-B70285
              AND aba04 BETWEEN tm.bm2 AND tm.em2
              AND abapost = 'Y'
              AND abb03 = aag01   #MOD-680002
              AND aag03 <> '4'   #MOD-680002
           IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
           IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
           #LET amt1 = amt1 - (l_endy1 - l_endy2)   #TQC-630260
           LET amt2 = amt2 - (l_endy1 - l_endy2)   #TQC-630260
         END IF
        #-----END TQC-620081-----
     END IF
     IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF #匯率的轉換
     IF tm.o = 'Y' THEN LET amt2 = amt2 * tm.q END IF #匯率的轉換
     LET amt3 = amt1 - amt2    #no.6227
     IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN     #合計階數處理     #MOD-A60135
       #THEN FOR i = 1 TO 100 LET g_tot1[i]=g_tot1[i]+amt1 END FOR              #MOD-A60135 mark
       #     FOR i = 1 TO 100 LET g_tot2[i]=g_tot2[i]+amt2 END FOR              #MOD-A60135 mark
       #     FOR i = 1 TO 100 LET g_tot3[i]=g_tot3[i]+amt3 END FOR #no.6227     #MOD-A60135 mark
            #-MOD-A60135-add-
             FOR i = 1 TO 100 
                 IF maj.maj09 = '-' THEN
                    LET g_tot1[i] = g_tot1[i] - amt1
                    LET g_tot2[i] = g_tot2[i] - amt2   #FUN-B80158(MOD-BB0296)
                    LET g_tot3[i] = g_tot3[i] - amt3   #FUN-B80158(MOD-BB0296)
                 ELSE
                    LET g_tot1[i] = g_tot1[i] + amt1
                    LET g_tot2[i] = g_tot2[i] + amt2   #FUN-B80158(MOD-BB0296)
                    LET g_tot3[i] = g_tot3[i] + amt3   #FUN-B80158(MOD-BB0296)
                 END IF
             END FOR
            ##FUN-B80158(MOD-BB0296)--mark--str
            #FOR i = 1 TO 100 
            #    IF maj.maj09 = '-' THEN
            #       LET g_tot2[i] = g_tot2[i] - amt2
            #    ELSE
            #       LET g_tot2[i] = g_tot2[i] + amt2
            #    END IF
            #END FOR
            #FOR i = 1 TO 100 
            #    IF maj.maj09 = '-' THEN
            #       LET g_tot3[i] = g_tot3[i] - amt3
            #    ELSE
            #       LET g_tot3[i] = g_tot3[i] + amt3
            #    END IF
            #END FOR
            #FUN-B80158(MOD-BB0296)--mark--end
            #-MOD-A60135-end-
             LET k=maj.maj08  LET sr.bal1=g_tot1[k] LET sr.bal2=g_tot2[k]
                              LET sr.bal3=g_tot3[k]                #no.6227
             #-FUN-B80158(MOD-BB0296)-add-str
             IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
                LET sr.bal1 = sr.bal1 *-1
                LET sr.bal2 = sr.bal2 *-1
                LET sr.bal3 = sr.bal3 *-1
             END IF
            #-FUN-B80158(MOD-BB0296)-end-
             FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
             FOR i = 1 TO maj.maj08 LET g_tot2[i]=0 END FOR
             FOR i = 1 TO maj.maj08 LET g_tot3[i]=0 END FOR        #no.6227
        ELSE 
        IF maj.maj03='5' THEN
            LET sr.bal1=amt1
            LET sr.bal2=amt2
            LET sr.bal3=amt3 #no.6227
        ELSE
            #-----TQC-6B0171---------
            LET sr.bal1=NULL            #MOD-910208 mark回復
            LET sr.bal2=NULL            #MOD-910208 mark回復
            LET sr.bal3=NULL #no.6227   #MOD-910208 mark回復
           #LET sr.bal1=0               #MOD-910208 mark
           #LET sr.bal2=0               #MOD-910208 mark
           #LET sr.bal3=0               #MOD-910208 mark
            #-----END TQC-6B0171-----
        END IF
     END IF
     IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
        LET g_basetot1=sr.bal1
        LET g_basetot2=sr.bal2
        LET g_basetot3=sr.bal3
        IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
        IF maj.maj07='2' THEN LET g_basetot2=g_basetot2*-1 END IF
        IF maj.maj07='2' THEN LET g_basetot3=g_basetot3*-1 END IF #no.6227
     END IF
     IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
     IF (tm.c='N' OR maj.maj03='2') AND
        #maj.maj03 MATCHES "[012]" AND sr.bal1=0 AND sr.bal2=0 THEN   #MOD-870217
        maj.maj03 MATCHES "[0125]" AND sr.bal1=0 AND sr.bal2=0 THEN   #MOD-870217
        CONTINUE FOREACH                        #餘額為 0 者不列印
     END IF
     IF tm.f>0 AND maj.maj08 < tm.f THEN
        CONTINUE FOREACH                        #最小階數起列印
     END IF
 
#MOD-720040 By TSD.Jin--start
     IF maj.maj07 = '2' THEN
        LET sr.bal1 = sr.bal1 * -1
        LET sr.bal2 = sr.bal2 * -1
     END IF
  
     LET sr.bal3 = sr.bal1 - sr.bal2
  
     LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
  
     IF tm.h = 'Y' THEN
        LET maj.maj20 = maj.maj20e
     END IF
  
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
     EXECUTE insert_prep USING
        maj.maj31,      #FUN-B80158 add maj31
        maj.maj01,maj.maj02,maj.maj03,maj.maj04,maj.maj05,
        maj.maj06,maj.maj07,maj.maj08,maj.maj09,maj.maj10,
        maj.maj11,maj.maj20,maj.maj20e,maj.maj21,maj.maj22,
        maj.maj23,maj.maj24,maj.maj25,maj.maj26,maj.maj27,
        maj.maj28,maj.maj29,maj.maj30,'2',sr.bal1,sr.bal2,sr.bal3, #CHI-A70061 add '2'
        g_azi03,g_azi04,g_azi05
     #CHI-A70061 add --start--
     IF maj.maj04 > 0 THEN
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO maj.maj04
           EXECUTE insert_prep USING
              maj.maj31,      #FUN-B80158 add maj31
              maj.maj01,maj.maj02,maj.maj03,maj.maj04,maj.maj05,
              maj.maj06,maj.maj07,maj.maj08,maj.maj09,maj.maj10,
              maj.maj11,maj.maj20,maj.maj20e,maj.maj21,maj.maj22,
              maj.maj23,maj.maj24,maj.maj25,maj.maj26,maj.maj27,
              maj.maj28,maj.maj29,maj.maj30,'1',sr.bal1,sr.bal2,sr.bal3,
              g_azi03,g_azi04,g_azi05
           IF STATUS THEN
              CALL cl_err("execute insert_prep:",STATUS,1)
              EXIT FOR
           END IF
        END FOR
     END IF
     #CHI-A70061 add --end--
 
#    OUTPUT TO REPORT g112_rep(maj.*, sr.*)
#MOD-720040 By TSD.Jin--end
   END FOREACH
   #-----TQC-6B0171--------- 
   #IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
   #IF g_basetot2 = 0 THEN LET g_basetot2 = NULL END IF
   #IF g_basetot3 = 0 THEN LET g_basetot3 = NULL END IF  #no.6227
   IF cl_null(g_basetot1) THEN LET g_basetot1 = 0 END IF
   IF cl_null(g_basetot2) THEN LET g_basetot2 = 0 END IF
   IF cl_null(g_basetot3) THEN LET g_basetot3 = 0 END IF 
   #-----END TQC-6B0171-----
 
   #MOD-720040 By TSD.Jin--start
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   LET g_str = NULL
   IF g_zz05 = 'Y' THEN
      #因為沒有QBE
   END IF
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
###GENGRE###   LET g_str = g_str,";",
###GENGRE###               tm.title1,";",tm.yy1,";",tm.bm1 USING '&&',";",tm.em1 USING '&&',";",
###GENGRE###               tm.title2,";",tm.yy2,";",tm.bm2 USING '&&',";",tm.em2 USING '&&',";",
###GENGRE###               tm.a,";",tm.d,";",tm.e,";",tm.h,";",tm.p,";",
###GENGRE###               g_mai02,";",g_basetot1,";",g_basetot2,";",g_basetot3 ,";",tm.acc_code   #No.FUN-B80158  add    ,";",tm.acc_code 
  
###GENGRE###   CALL cl_prt_cs3('aglg112','aglg112',l_sql,g_str)   #FUN-710080 modify
    CALL aglg112_grdata()    ###GENGRE###
 
#  FINISH REPORT g112_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #MOD-720040 By TSD.Jin--end
 
END FUNCTION
 
REPORT g112_rep(maj, sr)
   DEFINE l_last_sw  LIKE type_file.chr1   #No.FUN-680098    VARCHAR(1)
   DEFINE l_unit     LIKE zaa_file.zaa08   #No.FUN-680098    VARCHAR(4)
   DEFINE per1,per2  LIKE fid_file.fid03   #No.FUN-680098    dec(8,3)
   DEFINE per3       LIKE fid_file.fid03   #No.FUN-680098    dec(8,3)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1      LIKE aah_file.aah04,
                       bal2      LIKE aah_file.aah04,
                       bal3      LIKE aah_file.aah04
                    END RECORD
   DEFINE g_head1   STRING
   DEFINE l_tit1     LIKE type_file.chr1000   #No.FUN-680098   VARCHAR(12)
   DEFINE l_tit2     LIKE type_file.chr1000   #No.FUN-680098   VARCHAR(12)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin 
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY maj.maj02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         LET g_x[1] = g_mai02
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED  #No.TQC-6A0093
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
     
         #金額單位之列印
         CASE tm.d
              WHEN '1'  LET l_unit = g_x[12]
              WHEN '2'  LET l_unit = g_x[13]
              WHEN '3'  LET l_unit = g_x[14]
              OTHERWISE LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[10] CLIPPED,tm.a,'     ',
                       g_x[15] CLIPPED,tm.p,'     ',
                       g_x[11] CLIPPED,l_unit
         PRINT g_head1 CLIPPED
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[32],tm.title1 CLIPPED,  #No.TQC-6A0093
               COLUMN g_c[34],tm.title2 CLIPPED,  #No.TQC-6A0093
               COLUMN g_c[36],g_x[16] CLIPPED
         LET l_tit1 = tm.yy1 USING '<<<<','/',
                      tm.bm1 USING'&&','-',tm.em1 USING'&&'
         LET l_tit2 = tm.yy2 USING '<<<<','/',
                      tm.bm2 USING'&&','-',tm.em2 USING'&&'
         PRINT COLUMN g_c[32],l_tit1 CLIPPED,  #No.TQC-6A0093
               COLUMN g_c[34],l_tit2 CLIPPED,  #No.TQC-6A0093
               COLUMN g_c[36],g_x[17] CLIPPED
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1 CLIPPED  #No.TQC-6A0093
         LET l_last_sw = 'n'
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN
            LET sr.bal1 = sr.bal1 * -1
            LET sr.bal2 = sr.bal2 * -1
         END IF
 
         LET sr.bal3 = sr.bal1 - sr.bal2
 
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e 
         END IF
 
         CASE
            WHEN maj.maj03 = '9'
               SKIP TO TOP OF PAGE
            WHEN maj.maj03 = '3'
                #-----No.MOD-560188-----
               PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
                     COLUMN g_c[33],g_dash2[1,g_w[33]],
                     COLUMN g_c[34],g_dash2[1,g_w[34]],
                     COLUMN g_c[35],g_dash2[1,g_w[35]],
                     COLUMN g_c[36],g_dash2[1,g_w[36]],
                     COLUMN g_c[37],g_dash2[1,g_w[37]]
                #-----No.MOD-560188 END-----
            WHEN maj.maj03 = '4'
               PRINT g_dash2[1,g_len]
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
               LET per1 = (sr.bal1 / g_basetot1) * 100
               LET per2 = (sr.bal2 / g_basetot2) * 100
               LET per3 = (sr.bal3 / sr.bal1   ) * 100
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
               PRINT COLUMN g_c[31],maj.maj20 CLIPPED,
                     COLUMN g_c[32],cl_numfor(sr.bal1/g_unit,32,tm.e),
                     COLUMN g_c[33],per1 USING '----&.&&',
                     COLUMN g_c[34],cl_numfor(sr.bal2/g_unit,34,tm.e),
                     COLUMN g_c[35],per2 USING '----&.&&',
                     COLUMN g_c[36],cl_numfor(sr.bal3/g_unit,36,tm.e),
                     COLUMN g_c[37],per3 USING '----&.&&'
         END CASE
     
      ON LAST ROW
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-6A0093
     
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-6A0093
         ELSE
            SKIP 2 LINE
         END IF
     
END REPORT
 
 #No.MOD-510052 add
FUNCTION g112_set_entry() 
 
    IF INFIELD(rtype) THEN
      CALL cl_set_comp_entry("bm1,bm2",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION g112_set_no_entry()
 
    IF INFIELD(rtype) AND tm.rtype='1' THEN
      CALL cl_set_comp_entry("bm1,bm2",FALSE)
    END IF 
 
END FUNCTION
 #No.MOD-510052 end

###GENGRE###START
FUNCTION aglg112_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg112")
        IF handler IS NOT NULL THEN
            START REPORT aglg112_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY maj02,line"
          
            DECLARE aglg112_datacur1 CURSOR FROM l_sql
            FOREACH aglg112_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg112_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg112_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg112_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50158------add----str-----
    DEFINE l_bal1   LIKE type_file.num20_6
    DEFINE l_bal2   LIKE type_file.num20_6
    DEFINE l_bal3   LIKE type_file.num20_6
    DEFINE l_date1  STRING
    DEFINE l_date2  STRING
    DEFINE l_per1   LIKE type_file.num20_6
    DEFINE l_per2   LIKE type_file.num20_6        
    DEFINE l_per3   LIKE type_file.num20_6        
    DEFINE l_unit   STRING
    DEFINE l_aa     LIKE aah_file.aah04
    DEFINE l_bb     LIKE aah_file.aah04
    DEFINE l_bal1_fmt  STRING
    DEFINE l_bal2_fmt  STRING
    DEFINE l_bal3_fmt  STRING
    #FUN-B50158------end----str-----

    
    ORDER EXTERNAL BY sr1.maj02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B50158------add----str-----
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit
          
            LET l_date1 = tm.yy1 CLIPPED,'/',tm.bm1 USING '&&','-',tm.em1 USING '&&'
            PRINTX l_date1

            LET l_date2 = tm.yy2,'/',tm.bm2 USING '&&','-',tm.em2 USING '&&'
            PRINTX l_date2

            PRINTX g_mai02
            #FUN-B50158------end----str-----
              
        BEFORE GROUP OF sr1.maj02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B50158------add----str-----
            CASE tm.d 
               WHEN '1'
                  LET l_bal1 = sr1.bal1 / 1
                  LET l_bal2 = sr1.bal2 / 1
                  LET l_bal3 = sr1.bal3 / 1
               WHEN '2'
                  LET l_bal1 = sr1.bal1 / 1000
                  LET l_bal2 = sr1.bal2 / 1000
                  LET l_bal3 = sr1.bal3 / 1000
               WHEN '3'
                  LET l_bal1 = sr1.bal1 / 1000000
                  LET l_bal2 = sr1.bal2 / 1000000
                  LET l_bal3 = sr1.bal3 / 1000000
            END CASE
            PRINTX l_bal1
            PRINTX l_bal2
            PRINTX l_bal3

            LET l_aa = g_basetot1
            IF NOT cl_null(sr1.bal1) AND  NOT cl_null(g_basetot1) THEN
               IF sr1.bal1 != 0 AND l_aa!= 0 AND NOT cl_null(sr1.bal1) AND NOT cl_null(g_basetot1) THEN
                  LET l_per1 = (sr1.bal1 / l_aa) * 100
               ELSE 
                 LET l_per1 = 0
               END IF
            ELSE 
               LET l_per1 = NULL
            END IF
            PRINTX l_per1
           
            LET l_bb = g_basetot2
            IF NOT cl_null(sr1.bal2) AND NOT cl_null(g_basetot2) THEN
               IF sr1.bal2 != 0 AND l_bb!= 0 AND NOT cl_null(sr1.bal2) AND NOT cl_null(g_basetot2) THEN
                  LET l_per2 = (sr1.bal2 / l_bb) * 100
               ELSE 
                  LET l_per2 = 0
               END IF
            ELSE
               LET l_per2 = NULL
            END IF
            PRINTX l_per2

            IF NOT cl_null(sr1.bal2) AND NOT cl_null(sr1.bal3) THEN
               IF sr1.bal2 != 0 THEN
                  LET l_per3 = (sr1.bal3 / sr1.bal2) * 100             
               ELSE
                  LET l_per3 = 0
               END IF
            ELSE
               LET l_per3 = NULL
            END IF
            PRINTX l_per3

            LET l_bal1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e) 
            LET l_bal2_fmt = cl_gr_numfmt("aah_file","aah04",tm.e) 
            LET l_bal3_fmt = cl_gr_numfmt("aah_file","aah04",tm.e) 
            PRINTX l_bal1_fmt
            PRINTX l_bal2_fmt
            PRINTX l_bal3_fmt
            #FUN-B50158------end----str-----

            PRINTX sr1.*

        AFTER GROUP OF sr1.maj02

        
        ON LAST ROW

END REPORT
###GENGRE###END
