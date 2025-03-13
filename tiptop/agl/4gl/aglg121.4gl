# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg121.4gl
# Descriptions...: (部門)兩期實際預算比較報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/25 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/18 By Nicola 報表架構修改
# Modify.........: No.MOD-560188 05/06/27 By Nicola 報表結構 列印碼設定 "3" OR "4" 資料印出異常
# Modify.........: No.MOD-5A0262 05/10/27 By Nicola 報表條件修改
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/10 By Carrier 報表格式調整
# Modify.........: No.MOD-6B0126 06/12/05 By Smapmin 預算需為正值
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加判斷使用者及部門權限
# Modify.........: No.FUN-6B0021 07/03/15 By jamie 族群欄位開窗查詢
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/09 By sherry  會計科目加帳套
# Modify.........: No.FUN-780060 07/08/24 By destiny 報表改為CR輸出
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消管控 預算編碼>預算項目
# Modify.........: No.FUN-830139 08/04/02 By bnlent 去掉預算項目字段
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額 
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No:CHI-A30009 10/04/09 By Summer 預算金額錯誤 
# Modify.........: No:MOD-A80236 10/08/30 By Dido 重複執行時變數 g_buf 須清空 
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-AB0020 10/11/08 By lixh1   添加預算項目(afc01)欄位
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No:MOD-B60232 11/06/27 By Sarah g_buf與l_sql宣告改用STRING
# Modify.........: No.FUN-B80158 11/08/26 By yangtt  明細類CR轉換成GRW
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1,   #報表結構編號   #No.FUN-680098   VARCHAR(1)
                 a      LIKE mai_file.mai01,   #報表結構編號   #No.FUN-680098   VARCHAR(6)
                 b      LIKE aaa_file.aaa01,   #帳別編號       #No.FUN-670039
                 abe01  LIKE abe_file.abe01,   #列印族群       #No.FUN-680098   VARCHAR(6)
                 title1 LIKE type_file.chr8,   #輸入期別名稱   #No.FUN-680098   VARCHAR(8)
                 yy1    LIKE type_file.num5,   #輸入年度       #No.FUN-680098   smallint
                 bm1    LIKE type_file.num5,   #Begin 期別     #No.FUN-680098   smallint
                 em1    LIKE type_file.num5,   # End  期別     #No.FUN-680098   smallint
                 title2 LIKE type_file.chr8,   #輸入期別名稱   #No.FUN-680098   VARCHAR(8)
                 yy2    LIKE type_file.num5,   #輸入年度       #No.FUN-680098   smallint
                 bm2    LIKE type_file.num5,   #Begin 期別     #No.FUN-680098   smallint
                 em2    LIKE type_file.num5,   # End  期別     #No.FUN-680098   smallint
                 afc01  LIKE afc_file.afc01,   #預算項目        #FUN-AB0020
                 #budget LIKE afa_file.afa01,   #預算編號       #No.FUN-680098   VARCHAR(4) #No.FUN-830139 mark
                 e      LIKE type_file.num5,   #小數位數       #No.FUN-680098   smallint
                 f      LIKE type_file.num5,   #列印最小階數   #No.FUN-680098   smallint
                 d      LIKE type_file.chr1,   #金額單位       #No.FUN-680098   VARCHAR(1)
                 c      LIKE type_file.chr1,   #異動額及餘額為0者是否列印       #No.FUN-680098  VARCHAR(1)
                 h      LIKE type_file.chr4,   #額外說明類別   #No.FUN-680098   VARCHAR(4)
                 o      LIKE type_file.chr1,   #轉換幣別否     #No.FUN-680098 VARCHAR(2)
                 r      LIKE azi_file.azi01,   #幣別
                 p      LIKE azi_file.azi01,   #幣別
                 q      LIKE azj_file.azj03,   #匯率
                 more   LIKE type_file.chr1    #Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)
              END RECORD,
          bdate,edate LIKE type_file.dat,     #No.FUN-680098 date
          i,j,k       LIKE type_file.num5,    #No.FUN-680098 SMALLINT
          g_unit      LIKE type_file.num10,   #金額單位基數 #No.FUN-680098   INTEGER
          g_buf       STRING,                 #MOD-B60232 mod #LIKE type_file.chr1000, #No.FUN-680098  char(6000)
          g_bookno    LIKE aah_file.aah00,    #帳別
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_abe01     LIKE abe_file.abe01,
          g_tot1      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot2      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot1_1    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot2_1    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          m_gem02     LIKE gem_file.gem02,
          rep_cnt     LIKE type_file.num5     #No.FUN-680098  smallint
   DEFINE g_aaa03     LIKE aaa_file.aaa03   
   DEFINE g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
   DEFINE g_msg       LIKE ze_file.ze03       #No.FUN-680098  VARCHAR(72)
#No.FUN-780060--start--add 
   DEFINE g_sql       STRING    
   DEFINE l_table     STRING   
   DEFINE g_str       STRING   
#No.FUN-780060--end--add 
###GENGRE###START
TYPE sr1_t RECORD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal1 LIKE aao_file.aao05,
    bal1_1 LIKE aao_file.aao05,
    bal2 LIKE aao_file.aao05,
    bal2_1 LIKE aao_file.aao05,
    dept LIKE gem_file.gem01,
    l_gem02 LIKE gem_file.gem02,
    l_amt1 LIKE aao_file.aao05,
    l_amt2 LIKE aao_file.aao05,
    l_per1 LIKE fid_file.fid03,
    l_per2 LIKE fid_file.fid03,
    line LIKE type_file.num5
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#No.FUN-780060--start--add  
   LET g_sql="maj20.maj_file.maj20,", 
             "maj20e.maj_file.maj20e,", 
             "maj02.maj_file.maj02,", 
             "maj03.maj_file.maj03,",   
             "bal1.aao_file.aao05,", 
             "bal1_1.aao_file.aao05,",  
             "bal2.aao_file.aao05,",     
             "bal2_1.aao_file.aao05,",
             "dept.gem_file.gem01,",  
             "l_gem02.gem_file.gem02,",  
             "l_amt1.aao_file.aao05,", 
             "l_amt2.aao_file.aao05,",  
             "l_per1.fid_file.fid03,",
             "l_per2.fid_file.fid03,", 
             "line.type_file.num5"      
   LET l_table = cl_prt_temptable('aglg121',g_sql) CLIPPED 
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"  
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM
   END IF 
#No.FUN-780060--end--add
 
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
   LET tm.abe01= ARG_VAL(11)
   LET tm.title1 = ARG_VAL(12)   #TQC-610056
   LET tm.yy1 = ARG_VAL(13)
   LET tm.bm1 = ARG_VAL(14)
   LET tm.em1 = ARG_VAL(15)
   LET tm.title2 = ARG_VAL(16)   #TQC-610056
   LET tm.yy2 = ARG_VAL(17)   #TQC-610056
   LET tm.bm2 = ARG_VAL(18)   #TQC-610056
   LET tm.em2 = ARG_VAL(19)   #TQC-610056
   LET tm.afc01 = ARG_VAL(20) #FUN-AB0020
   #LET tm.budget = ARG_VAL(20) #No.FUN-830139
   LET tm.e  = ARG_VAL(21)
   LET tm.f  = ARG_VAL(22)
   LET tm.d  = ARG_VAL(23)
   LET tm.c  = ARG_VAL(24)
   LET tm.h  = ARG_VAL(25)
   LET tm.o  = ARG_VAL(26)
   LET tm.r  = ARG_VAL(27)   #TQC-610056
   LET tm.p  = ARG_VAL(28)
   LET tm.q  = ARG_VAL(29)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(30)
   LET g_rep_clas = ARG_VAL(31)
   LET g_template = ARG_VAL(32)
   LET g_rpt_name = ARG_VAL(33)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF    #No.FUN-740020
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g121_tm()                # Input print condition
      ELSE CALL g121()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION g121_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,        #重要欄位是否空白 #No.FUN-680098    VARCHAR(1)
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670005    #No.FUN-680098 smallint 
   DEFINE li_result      LIKE type_file.num5     #No.FUN-6C0068    
   DEFINE l_azfacti      LIKE azf_file.azfacti   #FUN-AB0020
   CALL s_dsmark(g_bookno)
 
   LET p_row = 1 LET p_col = 16
 
   OPEN WINDOW g121_w AT p_row,p_col WITH FORM "agl/42f/aglg121" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0)  #No.FUN-660123
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
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET g_buf=''                                  #MOD-A80236
    LET l_sw = 1
#   INPUT BY NAME tm.rtype,tm.a,tm.b,tm.abe01,    #No.FUN-740020
    INPUT BY NAME tm.rtype,tm.b,tm.a,tm.abe01,
                  tm.title1,tm.yy1,tm.bm1,tm.em1,
                  tm.title2,tm.yy2,tm.bm2,tm.em2,tm.afc01, #tm.budget, #No.FUN-830139   #FUN-AB0020  add afc01
                 tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                 tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
 
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
                  AND mai00 = tm.b      #No.FUN-740020
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
 
      AFTER FIELD abe01
         IF tm.abe01 IS NULL THEN NEXT FIELD abe01 END IF
         SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
         IF STATUS=100 THEN
            LET g_abe01 =' '
            SELECT * FROM gem_file WHERE gem01=tm.abe01 AND gem05='Y'
            IF STATUS=100 THEN NEXT FIELD abe01 END IF
         END IF
         IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
 
#No.FUN-830139 ...begin
#      AFTER FIELD budget
### No:2577 modify 1998/10/21 ----------------
##        SELECT * FROM afa_file WHERE afa00=tm.b AND afa01=tm.budget
##        SELECT * FROM afa_file WHERE afa01=tm.budget
##         SELECT * FROM afa_file WHERE afa00=tm.b AND afa01=tm.budget    #No.FUN-740020         #FUN-810069
##                                  AND afaacti IN ('Y','y')                                   #FUN-810069
#        SELECT * FROM azf_file WHERE azfacti = 'Y' AND azf02 = '2' AND azf01 = tm.budget        #FUN-810069
### -
#        IF STATUS THEN
##          CALL cl_err('sel afa:',STATUS,0) 
##           CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0)   #No.FUN-660123      #FUN-810069
#            CALL cl_err3("sel","azf_file",tm.budget,"",STATUS,"","sel azf:",0)   #No.FUN-660123      #FUN-810069
#           NEXT FIELD budget
#        END IF
#No.FUN-830139 ...end
         
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
#         IF tm.bm1 <1 OR tm.bm1 > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD bm1
#         END IF
#No.TQC-720032 -- end --  
 
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

#FUN-AB0020 --------------------Begin----------------------------
      AFTER FIELD afc01
        IF NOT cl_null(tm.afc01) THEN
           SELECT azf01 FROM azf_file
            WHERE azf01 = tm.afc01  AND azf02 = '2'
          IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
             NEXT FIELD afc01
          ELSE
             SELECT azfacti INTO l_azfacti FROM azf_file
              WHERE azf01 = tm.afc01 AND azf02 = '2'
             IF l_azfacti = 'N' THEN
                CALL cl_err(tm.afc01,'agl1002',0)
             END IF
          END IF
       END IF       
#FUN-AB0020 --------------------End------------------------------          
 
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
#           CALL cl_err(tm.p,'agl-109',0)  #No.FUN-660123
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
         CASE tm.d
            WHEN '1'  LET g_unit = 1 
            WHEN '2'  LET g_unit = 1000
            WHEN '3'  LET g_unit = 1000000
         END CASE 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(a) 
#           CALL q_mai(4,8,tm.a,'13') RETURNING tm.a
#           CALL FGL_DIALOG_SETBUFFER( tm.a )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
           #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042   Mark
            LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
            CALL cl_create_qry() RETURNING tm.a 
#            CALL FGL_DIALOG_SETBUFFER( tm.a )
            DISPLAY BY NAME tm.a
            NEXT FIELD a
 
          #No.MOD-4C0156 add
         WHEN INFIELD(b) 
#           CALL q_aaa(0,0,tm.b) RETURNING tm.b
#           CALL FGL_DIALOG_SETBUFFER( tm.b )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.b
            CALL cl_create_qry() RETURNING tm.b 
#            CALL FGL_DIALOG_SETBUFFER( tm.b )
            DISPLAY BY NAME tm.b
            NEXT FIELD b
          #No.MOD-4C0156 end
         WHEN INFIELD(p)
#           CALL q_azi(7,10,tm.p) RETURNING tm.p
#           CALL FGL_DIALOG_SETBUFFER( tm.p )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azi'
            LET g_qryparam.default1 = tm.p
            CALL cl_create_qry() RETURNING tm.p 
#            CALL FGL_DIALOG_SETBUFFER( tm.p )
            DISPLAY BY NAME tm.p
            NEXT FIELD p
 
         #No.FUN-830139 ...begin
         #WHEN INFIELD(budget) 
#        #   CALL q_afa(4,6,tm.budget,g_bookno) RETURNING tm.budget
#        #   CALL FGL_DIALOG_SETBUFFER( tm.budget )
         #   CALL cl_init_qry_var()
#        #    LET g_qryparam.form = 'q_afa'     #FUN-810069
         #   LET g_qryparam.form = 'q_azf'      #FUN-810069
         #   LET g_qryparam.default1 = tm.budget
         #   LET g_qryparam.arg1 = '2'              #FUN-810069
         #   CALL cl_create_qry() RETURNING tm.budget
#        #    CALL FGL_DIALOG_SETBUFFER( tm.budget )
         #   DISPLAY BY NAME tm.budget
         #   NEXT FIELD budget
         #No.FUN-830139 ...end
        #FUN-6B0021---add---str---
         WHEN INFIELD(abe01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_abe'
            LET g_qryparam.default1 = tm.abe01
            CALL cl_create_qry() RETURNING tm.abe01
            DISPLAY BY NAME tm.abe01
            NEXT FIELD abe01
        #FUN-6B0021---add---end---

#FUN-AB0020 --------------Begin--------------------
         WHEN INFIELD(afc01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azf'    
            LET g_qryparam.default1 = tm.afc01
            LET g_qryparam.arg1 = '2'        
            CALL cl_create_qry() RETURNING tm.afc01
            DISPLAY BY NAME tm.afc01
            NEXT FIELD afc01
#FUN-AB0020 ---------------End---------------------         
 
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g121_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg121'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg121','9031',1)  
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
                         " '",tm.abe01 CLIPPED,"'",
                         " '",tm.title1 CLIPPED,"'",   #TQC-610056
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.bm1 CLIPPED,"'",
                         " '",tm.em1 CLIPPED,"'",
                         " '",tm.title2 CLIPPED,"'",   #TQC-610056
                         " '",tm.yy2 CLIPPED,"'",   #TQC-610056
                         " '",tm.bm2 CLIPPED,"'",   #TQC-610056
                         " '",tm.em2 CLIPPED,"'",   #TQC-610056
                         " '",tm.afc01 CLIPPED,"'",   #FUN-AB0020
                         #" '",tm.budget CLIPPED,"'", #No.FUN-830139
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.r CLIPPED,"'",   #TQC-610056
                         " '",tm.p CLIPPED,"'",
                         " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglg121',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g121()
   ERROR ""
END WHILE
   CLOSE WINDOW g121_w
END FUNCTION
 
FUNCTION g121()
   DEFINE l_name  LIKE type_file.chr20     # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#  DEFINE l_time  LIKE type_file.chr8      #No.FUN-6A0073
   DEFINE l_sql   STRING                   #MOD-B60232 mod  #LIKE type_file.chr1000  # RDSQL STATEMENT #No.FUN-680098  char(1000) 
   DEFINE l_chr   LIKE type_file.chr1      #No.FUN-680098    VARCHAR(1)
   DEFINE maj     RECORD LIKE maj_file.*
   DEFINE l_leng  LIKE type_file.num5      #No.FUN-680098   smallint
   DEFINE l_abe03 LIKE abe_file.abe03
   DEFINE m_abd02 LIKE abd_file.abd02
#No.FUN-780060--start--add  
   DEFINE l_tit1       LIKE type_file.chr1000 
   DEFINE l_tit2       LIKE type_file.chr1000  
#No.FUN-780060--end--
   CALL cl_del_data(l_table)                   #No.FUN-780060
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
          AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g121_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g121_c CURSOR FOR g121_p
   FOR g_i = 1 TO 100
       LET g_tot1[g_i] = 0 LET g_tot2[g_i] = 0
       LET g_tot1_1[g_i] = 0 LET g_tot2_1[g_i] = 0
   END FOR
#   CALL cl_outnam('aglg121') RETURNING l_name  #No.FUN-780060
#   START REPORT g121_rep TO l_name             #No.FUN-780060
#   LET g_pageno = 0                            #No.FUN-780060
 
        IF g_abe01=' ' THEN                     #--- 部門
           DECLARE g121_curs10 CURSOR FOR 
            SELECT abd02,gem05 FROM abd_file,gem_file WHERE abd01=tm.abe01
                                                        AND gem01=abd02
             ORDER BY 1
           FOREACH g121_curs10 INTO m_abd02,l_chr
               IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
               CALL g121_bom(m_abd02,l_chr)
           END FOREACH
         # IF g_buf IS NULL THEN LET g_buf="'",tm.abe01 CLIPPED,"'," END IF
           LET g_buf=g_buf CLIPPED,"'",tm.abe01 CLIPPED,"',"   #No.MOD-5A0262
          #LET l_leng=LENGTH(g_buf)                        #MOD-B60232 mark
          #LET g_buf=g_buf[1,l_leng-1] CLIPPED             #MOD-B60232 mark
           LET l_leng= g_buf.getlength()                   #MOD-B60232
           LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED #MOD-B60232
           CALL g121_process(tm.abe01)
        ELSE                                    #--- 族群
           DECLARE g121_bom CURSOR FOR
            SELECT abe03,gem05 FROM abe_file,gem_file WHERE abe01=tm.abe01
                                                        AND gem01=abe03
             ORDER BY 1
           FOREACH g121_bom INTO l_abe03,l_chr
            IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
            CALL g121_bom(l_abe03,l_chr)
            IF g_buf IS NULL THEN LET g_buf="'",l_abe03 CLIPPED,"'," END IF
           #LET l_leng=LENGTH(g_buf)                        #MOD-B60232 mark
           #LET g_buf=g_buf[1,l_leng-1] CLIPPED             #MOD-B60232 mark
            LET l_leng= g_buf.getlength()                   #MOD-B60232
            LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED #MOD-B60232
            CALL g121_process(l_abe03)
            LET g_buf=''
           END FOREACH
        END IF
 
#   FINISH REPORT g121_rep
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-780060--start--add
   LET l_tit1 = tm.yy1 USING '<<<<','/',tm.bm1 USING'&&','-',tm.em1 USING'&&'   
   LET l_tit2 = tm.yy2 USING '<<<<','/',tm.bm2 USING'&&','-',tm.em2 USING'&&' 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
###GENGRE###   LET g_str=g_mai02,";",tm.a,";",tm.d,";",tm.p,";",tm.e,";",tm.title1,";",tm.title2,";", 
###GENGRE###               l_tit1,";",l_tit2  #No.FUN-830139
###GENGRE###   CALL cl_prt_cs3('aglg121','aglg121',g_sql,g_str)
    CALL aglg121_grdata()    ###GENGRE###
#No.FUN-780060--end-- 
END FUNCTION
 
FUNCTION g121_process(l_dept)
   DEFINE l_dept       LIKE type_file.chr6    #No.FUN-680098  
   DEFINE l_sql         STRING                
   DEFINE amt1,amt2     LIKE aao_file.aao05
   DEFINE amt1_1,amt2_1 LIKE aao_file.aao05
   DEFINE maj           RECORD LIKE maj_file.*
   DEFINE sr            RECORD
                           bal1,bal2       LIKE aao_file.aao05,
                           bal1_1,bal2_1   LIKE aao_file.aao05,
                           dept            LIKE gem_file.gem01           
                        END RECORD
#No.FUN-780060--start--add 
   DEFINE l_gem02      LIKE gem_file.gem02 
   DEFINE l_amt1       LIKE aao_file.aao05 
   DEFINE l_amt2       LIKE aao_file.aao05 
   DEFINE l_per1       LIKE fid_file.fid03 
   DEFINE l_per2       LIKE fid_file.fid03  
#No.FUN-780060--end-- 
    IF cl_null(l_dept) THEN RETURN END IF
    LET rep_cnt=rep_cnt+1
 
    #----------- sql for sum(aao05-aao06)-----------------------------------
    LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                " WHERE aao01 BETWEEN ? AND ? ",
                "   AND aao02 IN (",g_buf CLIPPED,")",     #---- g_buf 部門族群
                "   AND aao03 = ? ",
                "   AND aao04 BETWEEN ? AND ? ",
                "   AND aao00= '",tm.b,"'",
                "   AND aag00= '",tm.b,"'",       #No.FUN-740020
                "   AND aao01 = aag01 AND aag07 IN ('2','3')"
    PREPARE g121_sum FROM l_sql
    DECLARE g121_sumc CURSOR FOR g121_sum
 
   #LET l_sql = " SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
    LET l_sql = " SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                " FROM afc_file,afb_file",
                " WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02 ",
                " AND afc03=afb03 AND afc04=afb04 ",
                " AND afc00= '",tm.b,"'",
                " AND afb00= '",tm.b,"'",          #No.FUN-740020
                #" AND afc01= '",tm.budget,"'",    #No.FUN-830139
                " AND afc041=afb041 ",        #FUN-810069
                " AND afc042=afb042 ",        #FUN-810069
                " AND afc02 BETWEEN ? AND ? ",
                " AND afc03= ?  ",
                " AND afc041 IN (",g_buf CLIPPED,")",  #MOD-9C0100 afc04 modify afc041
                " AND afc05 BETWEEN ? AND ? ",       
                " AND afbacti = 'Y' "    #TQC-630238
               #" AND afb15='2' "     #---- 部門預算   #MOD-9C0100 mark
#FUN-AB0020 ---------------------Begin---------------------------
    IF NOT cl_null(tm.afc01) THEN
       LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
    END IF
#FUN-AB0020 ---------------------End----------------------------- 
    PREPARE g121_sumbug FROM l_sql
    DECLARE g121_sumcbug CURSOR FOR g121_sumbug
    #-----------------------------------------------------------------------
 
    FOREACH g121_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0 LET amt2=0
       LET amt1_1=0 LET amt2_1=0
       #期別 yy1/bm1 - yy1/em1
       IF NOT cl_null(maj.maj21) THEN
          OPEN g121_sumc USING maj.maj21,maj.maj22,tm.yy1,tm.bm1,tm.em1
          FETCH g121_sumc INTO amt1   
          IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
          IF amt1 IS NULL THEN LET amt1 = 0 END IF
 
          OPEN g121_sumcbug USING maj.maj21,maj.maj22,tm.yy1,tm.bm1,tm.em1
          FETCH g121_sumcbug INTO amt1_1   
          IF STATUS THEN CALL cl_err('sel afc:',STATUS,1) EXIT FOREACH END IF
          IF cl_null(amt1_1) THEN LET amt1_1 = 0 END IF
       END IF
       #期別 yy2/bm2 - yy2/em2
       IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
          OPEN g121_sumc USING maj.maj21,maj.maj22,tm.yy2,tm.bm2,tm.em2
          FETCH g121_sumc INTO amt2
          IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
          IF amt2 IS NULL THEN LET amt2 = 0 END IF
 
          OPEN g121_sumcbug USING maj.maj21,maj.maj22,tm.yy2,tm.bm2,tm.em2
          FETCH g121_sumcbug INTO amt2_1
          IF STATUS THEN CALL cl_err('sel afc:',STATUS,1) EXIT FOREACH END IF
          IF cl_null(amt2_1) THEN LET amt2_1 = 0 END IF
       END IF
      #CHI-A70050---mark---start--- 
      ##CHI-A30009 add start---
      #IF maj.maj09='-' THEN
      #   LET amt1_1 = amt1_1 * -1
      #  # LET amt1 = amt1 * -1
      #END IF
      ##CHI-A30009 add end-----
      #CHI-A70050---mark---end---
       IF tm.o = 'Y' THEN
          LET amt1 = amt1 * tm.q   #匯率的轉換
          LET amt2 = amt2 * tm.q 
          LET amt1_1 = amt1_1 * tm.q 
          LET amt2_1 = amt2_1 * tm.q
       END IF
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN      #合計階數處理
          FOR i = 1 TO 100
             #CHI-A70050---modify---start---
             #LET g_tot1[i]=g_tot1[i]+amt1
             #LET g_tot2[i]=g_tot2[i]+amt2        
             #LET g_tot1_1[i]=g_tot1_1[i]+amt1_1 
             #LET g_tot2_1[i]=g_tot2_1[i]+amt2_1
              IF maj.maj09 = '-' THEN
                 LET g_tot1[i]=g_tot1[i]-amt1
                 LET g_tot2[i]=g_tot2[i]-amt2        
                 LET g_tot1_1[i]=g_tot1_1[i]-amt1_1 
                 LET g_tot2_1[i]=g_tot2_1[i]-amt2_1
              ELSE
                 LET g_tot1[i]=g_tot1[i]+amt1
                 LET g_tot2[i]=g_tot2[i]+amt2        
                 LET g_tot1_1[i]=g_tot1_1[i]+amt1_1 
                 LET g_tot2_1[i]=g_tot2_1[i]+amt2_1
              END IF
             #CHI-A70050---modify---end---
          END FOR
          LET k=maj.maj08 
          LET sr.bal1=g_tot1[k] 
          LET sr.bal2=g_tot2[k]
          LET sr.bal1_1=g_tot1_1[k]
          LET sr.bal2_1=g_tot2_1[k]
         #CHI-A70050---add---start---
          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
             LET sr.bal1 = sr.bal1 *-1
             LET sr.bal1_1 = sr.bal1_1 *-1
             LET sr.bal2 = sr.bal2 *-1
             LET sr.bal2_1 = sr.bal2_1 *-1
          END IF
         #CHI-A70050---add---end---
          FOR i = 1 TO maj.maj08 
             LET g_tot1[i]=0 LET g_tot2[i]=0 LET g_tot1_1[i]=0 LET g_tot2_1[i]=0
          END FOR
       ELSE 
          IF maj.maj03='5' THEN
              LET sr.bal1=amt1
              LET sr.bal1_1=amt1_1
              LET sr.bal2=amt2
              LET sr.bal2_1=amt2_1
          ELSE
              LET sr.bal1=NULL 
              LET sr.bal1_1=NULL 
              LET sr.bal2=NULL
              LET sr.bal2_1=NULL
          END IF
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"                #CHI-CC0023 add maj03 match 5
          AND sr.bal1=0 AND sr.bal2=0 AND sr.bal1_1=0 AND sr.bal2_1=0 THEN
          CONTINUE FOREACH                        #餘額為 0 者不列印
       END IF
       IF tm.f>0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                        #最小階數起列印
       END IF
       LET sr.dept = l_dept
#No.FUN-780060--start--add  
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.dept 
         IF maj.maj07 = '2' THEN   
            LET sr.bal1 = sr.bal1 * -1 
            LET sr.bal2 = sr.bal2 * -1    
         END IF
         IF tm.h = 'Y' THEN 
            LET maj.maj20 = maj.maj20e  
         END IF         
            LET l_amt1 = sr.bal1 - sr.bal1_1 
            LET l_amt2 = sr.bal2 - sr.bal2_1 
         IF sr.bal1_1 = 0 THEN  
            LET l_per1 = 0  
         ELSE    
            LET l_per1 = l_amt1 / sr.bal1_1 * 100 
         END IF
         IF sr.bal2_1 = 0 THEN 
            LET l_per2 = 0 
         ELSE   
            LET l_per2 = l_amt2 / sr.bal2_1 * 100   
         END IF 
         IF tm.d MATCHES '[23]' THEN 
            LET sr.bal1 = sr.bal1 / g_unit   
            LET sr.bal1_1 = sr.bal1_1 / g_unit   
            LET l_amt1 = l_amt1 / g_unit 
            LET sr.bal2_1 = sr.bal2_1 / g_unit  
            LET l_amt2 = l_amt2 / g_unit    
         END IF          
         LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED

        IF sr.bal1_1<0 THEN LET sr.bal1_1=sr.bal1_1*-1 END IF #CHI-A30009 add

        IF maj.maj04=0 THEN  
           EXECUTE insert_prep USING 
                   maj.maj20,maj.maj20e,maj.maj02,maj.maj03,sr.bal1,sr.bal1_1, 
                   sr.bal2,sr.bal2_1,sr.dept,l_gem02,l_amt1,l_amt2,
                   l_per1,l_per2,'2' 
        ELSE  
           EXECUTE insert_prep USING
                   maj.maj20,maj.maj20e,maj.maj02,maj.maj03,sr.bal1,sr.bal1_1,
                   sr.bal2,sr.bal2_1,sr.dept,l_gem02,l_amt1,l_amt2,
                   l_per1,l_per2,'2'                                                      
           FOR i=1 TO maj.maj04 
           EXECUTE insert_prep USING  
                   maj.maj20,maj.maj20e,maj.maj02,maj.maj03,'0','0', 
                   '0','0',sr.dept,l_gem02,'0','0',  
                   '0','0','1'  
           END FOR          
        END IF 
#No.FUN-780060--end--
#       OUTPUT TO REPORT g121_rep(maj.*, sr.*)              #No.FUN-780060  
    END FOREACH
END FUNCTION
#No.FUN-780060--start--add
{REPORT g121_rep(maj, sr)
   DEFINE l_last_sw   LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
   DEFINE l_unit      LIKE zaa_file.zaa08      #No.FUN-680098   VARCHAR(4)
   DEFINE maj          RECORD LIKE maj_file.*
   DEFINE sr           RECORD
                          bal1,bal2       LIKE aao_file.aao05,
                          bal1_1,bal2_1   LIKE aao_file.aao05,
                          dept            LIKE gem_file.gem01           
                       END RECORD
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE l_amt1       LIKE aao_file.aao05
   DEFINE l_amt2       LIKE aao_file.aao05
   DEFINE l_per1       LIKE fid_file.fid03      #No.FUN-680098 dec(8,3)  
   DEFINE l_per2       LIKE fid_file.fid03      #No.FUN-680098 dec(8,3) 
   DEFINE g_head1      STRING
   DEFINE l_tit1       LIKE type_file.chr1000 #No.FUN-680098    VARCHAR(12)
   DEFINE l_tit2       LIKE type_file.chr1000 #No.FUN-680098    VARCHAR(12)
 
   OUTPUT 
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.dept,maj.maj02
 
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
              WHEN '1'  LET l_unit = g_x[13]
              WHEN '2'  LET l_unit = g_x[14]
              WHEN '3'  LET l_unit = g_x[15]
              OTHERWISE LET l_unit = ' '
         END CASE
 
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.dept
         LET g_head1 = g_x[9] CLIPPED,sr.dept CLIPPED,' ',l_gem02 CLIPPED  #No.TQC-6A0093
         PRINT g_head1 CLIPPED  #No.TQC-6A0093
 
         LET g_head1 = g_x[11] CLIPPED,tm.a CLIPPED,'     ',  #No.TQC-6A0093
                       g_x[16] CLIPPED,tm.p CLIPPED,'     ',  #No.TQC-6A0093
                       g_x[12] CLIPPED,l_unit CLIPPED  #No.TQC-6A0093
         PRINT g_head1 CLIPPED  #No.TQC-6A0093
         LET g_head1 = g_x[17] CLIPPED,tm.budget CLIPPED
         PRINT g_head1 CLIPPED  #No.TQC-6A0093
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[33],tm.title1 CLIPPED,  #No.TQC-6A0093
               COLUMN g_c[37],tm.title2 CLIPPED   #No.TQC-6A0093
         LET l_tit1 = tm.yy1 USING '<<<<','/',
                      tm.bm1 USING'&&','-',tm.em1 USING'&&'
         LET l_tit2 = tm.yy2 USING '<<<<','/',
                      tm.bm2 USING'&&','-',tm.em2 USING'&&'
         PRINT COLUMN g_c[33],l_tit1 CLIPPED,  #No.TQC-6A0093
               COLUMN g_c[37],l_tit2 CLIPPED   #No.TQC-6A0093
         PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+g_w[33]+g_w[34]+g_w[35]+3],
               COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+3]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39]
         PRINT g_dash1 CLIPPED  #No.TQC-6A0093
         LET l_last_sw = 'n'
     
      BEFORE GROUP OF sr.dept
         SKIP TO TOP OF PAGE
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN
            LET sr.bal1 = sr.bal1 * -1
            LET sr.bal2 = sr.bal2 * -1
            #LET sr.bal1_1 = sr.bal1_1 * -1   #MOD-6B0126
            #LET sr.bal2_1 = sr.bal2_1 * -1   #MOD-6B0126
         END IF
 
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
                     COLUMN g_c[37],g_dash2[1,g_w[37]],
                     COLUMN g_c[38],g_dash2[1,g_w[38]],
                     COLUMN g_c[39],g_dash2[1,g_w[39]]
                #-----No.MOD-560188 END-----
            WHEN maj.maj03 = '4'
               PRINT g_dash2 CLIPPED  #No.TQC-6A0093
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
 
               LET l_amt1 = sr.bal1 - sr.bal1_1
               LET l_amt2 = sr.bal2 - sr.bal2_1
 
               IF sr.bal1_1 = 0 THEN
                  LET l_per1 = 0                       
               ELSE
                  LET l_per1 = l_amt1 / sr.bal1_1 * 100
               END IF
 
               IF sr.bal2_1 = 0 THEN
                  LET l_per2 = 0                       
               ELSE
                  LET l_per2 = l_amt2 / sr.bal2_1 * 100
               END IF
 
               IF tm.d MATCHES '[23]' THEN
                  LET sr.bal1 = sr.bal1 / g_unit
                  LET sr.bal1_1 = sr.bal1_1 / g_unit
                  LET l_amt1 = l_amt1 / g_unit
                  LET sr.bal2 = sr.bal2 / g_unit
                  LET sr.bal2_1 = sr.bal2_1 / g_unit
                  LET l_amt2 = l_amt2 / g_unit
               END IF
 
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
               PRINT COLUMN g_c[31],maj.maj20 CLIPPED,  #No.TQC-6A0093
                     COLUMN g_c[32],cl_numfor(sr.bal1,32,tm.e),
                     COLUMN g_c[33],cl_numfor(sr.bal1_1,33,tm.e),
                     COLUMN g_c[34],cl_numfor(l_amt1,34,tm.e),
                     COLUMN g_c[35],l_per1 USING "----&.&&",      
                     COLUMN g_c[36],cl_numfor(sr.bal2,36,tm.e),
                     COLUMN g_c[37],cl_numfor(sr.bal2_1,37,tm.e),
                     COLUMN g_c[38],cl_numfor(l_amt2,38,tm.e),
                     COLUMN g_c[39],l_per2 USING "----&.&&"        
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
     
END REPORT}
#No.FUN-780060--end-- 
  
FUNCTION g121_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01               #No.FUN-680098  VARCHAR(6) #TQC-840066
    DEFINE l_sw     LIKE type_file.chr1               #No.FUN-680098  VARCHAR(1) 
    DEFINE l_abd02  LIKE abd_file.abd01               #No.FUN-680098  VARCHAR(1)
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5          #No.FUN-680098 smallint
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
  
### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR 
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH 
  
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN 
           CALL g121_bom(l_arr[l_cnt2].*)
        END IF
    END FOR 
    IF l_sw = 'Y' THEN 
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION

###GENGRE###START
FUNCTION aglg121_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg121")
        IF handler IS NOT NULL THEN
            START REPORT aglg121_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY dept,maj02,line"   #FUN-B80158 add
          
            DECLARE aglg121_datacur1 CURSOR FROM l_sql
            FOREACH aglg121_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg121_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg121_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg121_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-----add------str------
    DEFINE l_unit        STRING
    DEFINE l_bal1_fmt    STRING
    DEFINE l_bal1_1_fmt  STRING
    DEFINE l_amt1_fmt    STRING
    DEFINE l_bal2_fmt    STRING
    DEFINE l_bal2_1_fmt  STRING
    DEFINE l_amt2_fmt    STRING
    DEFINE l_tit1        LIKE type_file.chr1000 
    DEFINE l_tit2        LIKE type_file.chr1000  
    DEFINE l_per         STRING
    DEFINE l_per1        STRING
    #FUN-B80158-----end------str------

    
    ORDER EXTERNAL BY sr1.dept,sr1.maj02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158-----add------str------
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit
            LET l_tit1 = tm.yy1 USING '<<<<','/',tm.bm1 USING'&&','-',tm.em1 USING'&&'   
            LET l_tit2 = tm.yy2 USING '<<<<','/',tm.bm2 USING'&&','-',tm.em2 USING'&&' 
            PRINTX l_tit1
            PRINTX l_tit2
            #FUN-B80158-----end------str------
              
        BEFORE GROUP OF sr1.dept
        BEFORE GROUP OF sr1.maj02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158-----add------str------
            LET l_bal1_fmt = cl_gr_numfmt("aao_file","aao05",tm.e)
            PRINTX l_bal1_fmt
            LET l_bal1_1_fmt = cl_gr_numfmt("aao_file","aao05",tm.e)
            PRINTX l_bal1_1_fmt
            LET l_amt1_fmt = cl_gr_numfmt("aao_file","aao05",tm.e)
            PRINTX l_amt1_fmt
            LET l_bal2_fmt = cl_gr_numfmt("aao_file","aao05",tm.e)
            PRINTX l_bal2_fmt
            LET l_bal2_1_fmt = cl_gr_numfmt("aao_file","aao05",tm.e)
            PRINTX l_bal2_1_fmt
            LET l_amt2_fmt = cl_gr_numfmt("aao_file","aao05",tm.e)
            PRINTX l_amt2_fmt

            IF NOT cl_null(sr1.l_per1) THEN
               LET l_per1 = sr1.l_per1 USING '--,---,--&.&&','%'
               LET l_per1 = l_per1.trim()
            ELSE
               LET l_per1 = sr1.l_per1 USING '--,---,--&.&&'
               LET l_per1 = l_per1.trim()
            END IF
            PRINTX l_per1 
            IF NOT cl_null(sr1.l_per2) THEN
               LET l_per = sr1.l_per2 USING '--,---,--&.&&','%'
               LET l_per = l_per.trim()
            ELSE
               LET l_per = sr1.l_per2 USING '--,---,--&.&&'
               LET l_per = l_per.trim()
            END IF
            PRINTX l_per  
            #FUN-B80158-----end------str------

            PRINTX sr1.*

        AFTER GROUP OF sr1.dept
        AFTER GROUP OF sr1.maj02

        
        ON LAST ROW

END REPORT
###GENGRE###END
