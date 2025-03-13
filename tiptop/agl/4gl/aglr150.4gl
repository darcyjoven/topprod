# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr150.4gl
# Descriptions...: 五期財務報表列印
# Date & Author..: 96/01/29 By Melody
# Modify.........: No.MOD-4A0248 04/10/18 By Yuna QBE開窗開不出來
# Modify.........: No.MOD-510052 05/01/20 By Kitty 若為資產負債表起始月份不可輸入
# Modify.........: No.FUN-510007 05/02/01 By Nicola 報表架構修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 07/01/04 By Judy 調整報表
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加判斷使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No.FUN-780060 07/08/28 By destiny 報表格式改為CR輸出
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.MOD-8A0211 08/10/29 By Sarah 判斷餘額為零不列印時,maj.maj03 MATCHES "[012]"應改為maj.maj03 MATCHES "[0125]"
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-950007 09/05/12 By sabrina 跨主機資料拋轉，shell手工調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By chenls plant 都拿掉，程式中跨DB語法改為不跨DB
# Modify.........: No:CHI-A70046 10/08/04 By Summer 百分比需依金額單位顯示
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No.FUN-B90140 11/10/11 By minpp 增加checkbox"列印會計科目"
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.TQC-C50091 12/05/11 By xuxz 報表計算不正確
# Modify.........: No.TQC-C60121 12/06/14 By lujh 還原TQC-C50091修改的內容
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1,       #報表結構編號 #No.FUN-680098   VARCHAR(1)
                 a      LIKE mai_file.mai01,       #報表結構編號 #No.FUN-680098   VARCHAR(6) 
                 
                 title1 LIKE type_file.chr8,       #輸入期別名稱 #No.FUN-680098    VARCHAR(8)
                 yy1    LIKE type_file.num5,       #輸入年度 #No.FUN-680098    smallint 
                 bm1    LIKE type_file.num5,       #Begin 期別 #No.FUN-680098   smallint
                 em1    LIKE type_file.num5,       # End  期別 #No.FUN-680098   smallint
#                 plant1 LIKE azp_file.azp01,       #工廠編號 #No.FUN-680098      VARCHAR(10)    #No.FUN-A10098 ---mark
                 dbs1  LIKE type_file.chr21,       #資料庫編號 #No.FUN-680098    VARCHAR(21)
                 book1  LIKE aaa_file.aaa01,       #帳別編號    #No.FUN-670039  
                 
                 title2 LIKE type_file.chr8,      #輸入期別名稱 #No.FUN-680098  VARCHAR(8)   
                 yy2    LIKE type_file.num5,      #輸入年度 #No.FUN-680098   smallint
                 bm2   LIKE type_file.num5,       #Begin 期別 #No.FUN-680098   smallint
                 em2   LIKE type_file.num5,       # End  期別 #No.FUN-680098   smallint
#                 plant2 LIKE azp_file.azp01,      #工廠編號 #No.FUN-680098     VARCHAR(10)       #No.FUN-A10098 ---mark
                 dbs2  LIKE type_file.chr21,      #資料庫編號 #No.FUN-680098    VARCHAR(21)
                 book2  LIKE aaa_file.aaa01,      #帳別編號    #No.FUN-670039 
                 
                 title3 LIKE type_file.chr8,     #輸入期別名稱 #No.FUN-680098  VARCHAR(8)   
                 yy3   LIKE type_file.num5,      #輸入年度 #No.FUN-680098   smallint
                 bm3  LIKE type_file.num5,       #Begin 期別 #No.FUN-680098   smallint
                 em3   LIKE type_file.num5,      # End  期別 #No.FUN-680098   smallint
#                 plant3 LIKE azp_file.azp01,     #工廠編號     #No.FUN-680098     VARCHAR(10)    #No.FUN-A10098 ---mark
                 dbs3   LIKE type_file.chr21,     #資料庫編號 #No.FUN-680098    VARCHAR(21)
                 book3  LIKE aaa_file.aaa01,     #帳別編號    #No.FUN-670039
                 
                 title4 LIKE type_file.chr8,     #輸入期別名稱 #No.FUN-680098    VARCHAR(8)
                 yy4   LIKE type_file.num5,      #輸入年度 #No.FUN-680098   smallint
                 bm4   LIKE type_file.num5,      #Begin 期別 #No.FUN-680098 smallint  
                 em4   LIKE type_file.num5,      # End  期別 #No.FUN-680098 smallint  
#                 plant4 LIKE azp_file.azp01,     #工廠編號 #No.FUN-680098   VARCHAR(10)         #No.FUN-A10098 ---mark
                 dbs4  LIKE type_file.chr21,     #資料庫編號 #No.FUN-680098    VARCHAR(21)
                 book4  LIKE aaa_file.aaa01,     #帳別編號    #No.FUN-670039
                 
                 title5 LIKE type_file.chr8,      #輸入期別名稱 #No.FUN-680098   VARCHAR(8) 
                 yy5   LIKE type_file.num5,      #輸入年度 #No.FUN-680098  smallint 
                 bm5   LIKE type_file.num5,      #Begin 期別 #No.FUN-680098   smallint
                 em5   LIKE type_file.num5,      # End  期別 #No.FUN-680098   smallint
#                 plant5 LIKE azp_file.azp01,     #工廠編號 #No.FUN-680098    VARCHAR(10)       #No.FUN-A10098 ---mark
                 dbs5   LIKE type_file.chr21,     #資料庫編號#No.FUN-680098   VARCHAR(21) 
                 book5  LIKE aaa_file.aaa01,     #帳別編號    #No.FUN-670039 
                 
                 c    LIKE type_file.chr1,       #異動額及餘額為0者是否列印 #No.FUN-680098    VARCHAR(1)
                 d    LIKE type_file.chr1,        #金額單位 #No.FUN-680098    VARCHAR(1)
                 e    LIKE type_file.num5,       #小數位數 #No.FUN-680098   smallint
                 f    LIKE type_file.num5,        #列印最小階數 #No.FUN-680098   smallint
                 h    LIKE type_file.chr4,          #額外說明類別 #No.FUN-680098   VARCHAR(4) 
                 o    LIKE type_file.chr1,         #轉換幣別否   #No.FUN-680098   VARCHAR(1)
                 r    LIKE azi_file.azi01,      #幣別    
                 p    LIKE azi_file.azi01,      #幣別
                 q    LIKE type_file.chr1,        #匯率 #No.FUN-680098    VARCHAR(1)
                 more   LIKE type_file.chr1,               #Input more condition(Y/N) #No.FUN-680098  VARCHAR(1)
                 acc_code LIKE type_file.chr1    #FUN-B90140   Add
              END RECORD,
          bdate,edate LIKE type_file.dat,           #No.FUN-680098   DATE
          i,j,k       LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          g_unit      LIKE type_file.num10,         #金額單位基數 #No.FUN-680098    INTEGER
          g_bookno    LIKE aah_file.aah00,          #帳別
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_tot1      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098   DEC(20,6)
          g_tot2      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098   DEC(20,6)
          g_tot3      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098   DEC(20,6)
          g_tot4      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098   DEC(20,6)
          g_tot5      ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098   DEC(20,6)
          g_basetot1  LIKE aah_file.aah04,
          g_basetot2  LIKE aah_file.aah04,
          g_basetot3  LIKE aah_file.aah04,
          g_basetot4  LIKE aah_file.aah04,
          g_basetot5  LIKE aah_file.aah04
   DEFINE g_aaa03     LIKE aaa_file.aaa03   
   DEFINE g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  SMALLINT
   DEFINE g_msg       LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
#No.FUN-780060--start--add
   DEFINE g_sql         STRING 
   DEFINE l_table       STRING 
   DEFINE g_str         STRING 
#No.FUN-780060--end--  
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
#No.FUN-780060--start--
   LET g_sql="maj31.maj_file.maj31,",  #FUN-B90140   Add
             "maj20.maj_file.maj20,", 
             "maj20e.maj_file.maj20e,", 
             "maj02.maj_file.maj02,", 
             "maj03.maj_file.maj03,",  
             "bal1.aah_file.aah04,",  
             "bal2.aah_file.aah04,", 
             "bal3.aah_file.aah04,",
             "bal4.aah_file.aah04,",
             "bal5.aah_file.aah04,",
             "per1.fid_file.fid03,",  
             "per2.fid_file.fid03,", 
             "per3.fid_file.fid03,",
             "per4.fid_file.fid03,",
             "per5.fid_file.fid03,",
             "line.type_file.num5,",
             "acc_code.type_file.chr1"     #FUN-B90140   Add
   LET l_table = cl_prt_temptable('aglr140',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?,",   
               "        ?,?,?,?,?,?)"         #FUN-B90140   Add ?
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM  
   END IF       
#No.FUN-780060--end--
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
  #-----TQC-610056---------
  LET tm.title1 = ARG_VAL(10)
  LET tm.yy1 = ARG_VAL(11)
  LET tm.bm1 = ARG_VAL(12)
  LET tm.em1 = ARG_VAL(13)
  LET tm.title2 = ARG_VAL(14)
  LET tm.yy2 = ARG_VAL(15)
  LET tm.bm2 = ARG_VAL(16)
  LET tm.em2 = ARG_VAL(17)
  LET tm.title3 = ARG_VAL(18)
  LET tm.yy3 = ARG_VAL(19)
  LET tm.bm3 = ARG_VAL(20)
  LET tm.em3 = ARG_VAL(21)
  LET tm.title4 = ARG_VAL(22)
  LET tm.yy4 = ARG_VAL(23)
  LET tm.bm4 = ARG_VAL(24)
  LET tm.em4 = ARG_VAL(25)
  LET tm.title5 = ARG_VAL(26)
  LET tm.yy5 = ARG_VAL(27)
  LET tm.bm5 = ARG_VAL(28)
  LET tm.em5 = ARG_VAL(29)
  #-----END TQC-610056-----
   LET tm.c  = ARG_VAL(30)
   LET tm.d  = ARG_VAL(31)
   LET tm.e  = ARG_VAL(32)
   LET tm.f  = ARG_VAL(33)
   LET tm.h  = ARG_VAL(34)
   LET tm.o  = ARG_VAL(35)
   LET tm.r  = ARG_VAL(36)   #TQC-610056
   LET tm.p  = ARG_VAL(37)
   LET tm.q  = ARG_VAL(38)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(39)
   LET g_rep_clas = ARG_VAL(40)
   LET g_template = ARG_VAL(41)
   LET g_rpt_name = ARG_VAL(42)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r150_tm()
   ELSE
      CALL r150() 
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r150_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098   VARCHAR(1) 
          l_cmd          LIKE type_file.chr1000        #No.FUN-680098   VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5,          #No.FUN-670005   #No.FUN-680098  smallint 
          l_sql          STRING      #No.FUN-670005  
   DEFINE li_result      LIKE type_file.num5          #No.FUN-6C0068
   CALL s_dsmark(g_bookno)
 
   LET p_row = 1 LET p_col = 16
 
   OPEN WINDOW r150_w AT p_row,p_col
     WITH FORM "agl/42f/aglr150"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
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
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
 
   LET tm.title1 = 'M.T.D.'
   LET tm.title2 = 'Y.T.D.'
   LET tm.book1 = g_bookno
   LET tm.book2 = g_bookno
   LET tm.book3 = g_bookno
   LET tm.book4 = g_bookno
   LET tm.book5 = g_bookno
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.acc_code = 'N'   #FUN-B90140   Add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      LET l_sw = 1
 
      INPUT BY NAME tm.rtype,tm.a,
#No.FUN-A10098 ---mark start
#                    tm.title1,tm.yy1,tm.bm1,tm.em1,tm.plant1,tm.book1,
#                    tm.title2,tm.yy2,tm.bm2,tm.em2,tm.plant2,tm.book2,
#                    tm.title3,tm.yy3,tm.bm3,tm.em3,tm.plant3,tm.book3,
#                    tm.title4,tm.yy4,tm.bm4,tm.em4,tm.plant4,tm.book4,
#                    tm.title5,tm.yy5,tm.bm5,tm.em5,tm.plant5,tm.book5,
#No.FUN-A10098 ---mark end
#No.FUN-A10098 ---add begin
                    tm.title1,tm.yy1,tm.bm1,tm.em1,tm.book1,
                    tm.title2,tm.yy2,tm.bm2,tm.em2,tm.book2,
                    tm.title3,tm.yy3,tm.bm3,tm.em3,tm.book3,
                    tm.title4,tm.yy4,tm.bm4,tm.em4,tm.book4,
                    tm.title5,tm.yy5,tm.bm5,tm.em5,tm.book5,
#No.FUN-A10098 ---add end
                    tm.e,tm.f,tm.d,tm.acc_code,tm.c,tm.h,tm.o,tm.r,   #FUN-B90140   Add tm.acc_code
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
          #No.MOD-510052
         BEFORE FIELD rtype 
            CALL r150_set_entry()  
      
         AFTER FIELD rtype 
            IF tm.rtype = '1' THEN
               LET tm.bm1 = 0
               LET tm.bm2 = 0
               LET tm.bm3 = 0
               LET tm.bm4 = 0
               LET tm.bm5 = 0
               CALL r150_set_no_entry()
            END IF
          #No.MOD-510052 end
      
         AFTER FIELD a
            IF tm.a IS NULL THEN
               NEXT FIELD a
            END IF
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = g_aza.aza81      #No.FUN-740020
               AND maiacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0)   #No.FUN-660123
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
      
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c 
            END IF
      
         AFTER FIELD yy1
            IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
               NEXT FIELD yy1
            END IF
      
         BEFORE FIELD bm1
            IF tm.rtype='1' THEN
               LET tm.bm1 = 0
               DISPLAY '' TO bm1
            END IF
      
         BEFORE FIELD bm2
            IF tm.rtype='1' THEN
               LET tm.bm2 = 0
               DISPLAY '' TO bm2
            END IF
      
         BEFORE FIELD bm3
            IF tm.rtype='1' THEN
               LET tm.bm3 = 0
               DISPLAY '' TO bm3
            END IF
      
         BEFORE FIELD bm4
            IF tm.rtype='1' THEN
               LET tm.bm4 = 0 
               DISPLAY '' TO bm4
            END IF
      
         BEFORE FIELD bm5
            IF tm.rtype='1' THEN
               LET tm.bm5 = 0
               DISPLAY '' TO bm5
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
            IF tm.bm1 IS NULL THEN
               NEXT FIELD bm1
            END IF
#No.TQC-720032 -- begin --
#            IF tm.bm1 <1 OR tm.bm1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm1
#            END IF
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
            IF tm.em1 IS NULL THEN
               NEXT FIELD em1
            END IF
#No.TQC-720032 -- begin --
#            IF tm.em1 <1 OR tm.em1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD em1
#            END IF
#No.TQC-720032 -- end --
            IF tm.bm1 > tm.em1 THEN
               CALL cl_err('','9011',0) 
               NEXT FIELD bm1
            END IF
            IF tm.yy2 IS NULL THEN
               LET tm.yy2 = tm.yy1
               LET tm.bm2 = tm.bm1
               LET tm.em2 = 12
               DISPLAY BY NAME tm.yy2,tm.bm2,tm.em2
            END IF
#No.FUN-A10098 ---mark start
#
#        AFTER FIELD plant1
#           IF tm.plant1 IS NOT NULL THEN
#              SELECT azp02 FROM azp_file WHERE azp01=tm.plant1
#              IF STATUS THEN
##                 CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660123
#                 CALL cl_err3("sel","azp_file",tm.plant1,"",STATUS,"","sel azp:",0)   #No.FUN-660123
#                 NEXT FIELD plant1
#              END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant1) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant1
#           END IF 
#    #No.FUN-940102 --end--
#           END IF
#
#        AFTER FIELD plant2
#           IF tm.plant2 IS NOT NULL THEN
#              SELECT azp02 FROM azp_file WHERE azp01=tm.plant2
#              IF STATUS THEN
##                 CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660123
#                 CALL cl_err3("sel","azp_file",tm.plant2,"",STATUS,"","sel azp:",0)   #No.FUN-660123
#                 NEXT FIELD plant2
#              END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant2) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant2
#           END IF 
#    #No.FUN-940102 --end--
#           END IF
#     
#        AFTER FIELD plant3
#           IF tm.plant3 IS NOT NULL THEN
#              SELECT azp02 FROM azp_file WHERE azp01=tm.plant3
#              IF STATUS THEN 
##                 CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660123
#                 CALL cl_err3("sel","azp_file",tm.plant3,"",STATUS,"","sel azp:",0)   #No.FUN-660123
#                 NEXT FIELD plant3
#              END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant3) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant3
#           END IF 
#    #No.FUN-940102 --end--
#           END IF
#     
#        AFTER FIELD plant4
#           IF tm.plant4 IS NOT NULL THEN
#              SELECT azp02 FROM azp_file WHERE azp01=tm.plant4
#              IF STATUS THEN
##                 CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660123
#                 CALL cl_err3("sel","azp_file",tm.plant4,"",STATUS,"","sel azp:",0)   #No.FUN-660123
#                 NEXT FIELD plant4
#              END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant4) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant4
#           END IF 
#    #No.FUN-940102 --end--
#           END IF
#     
#        AFTER FIELD plant5
#           IF tm.plant5 IS NOT NULL THEN
#              SELECT azp02 FROM azp_file WHERE azp01=tm.plant5
#              IF STATUS THEN
##                 CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660123
#                 CALL cl_err3("sel","azp_file",tm.plant5,"",STATUS,"","sel azp:",0)   #No.FUN-660123
#                 NEXT FIELD plant5
#              END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.plant5) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD plant5
#           END IF 
#    #No.FUN-940102 --end--
#           END IF
#
#No.FUN-A10098 ---mark end      
         AFTER FIELD book1
            IF tm.book1 IS NULL THEN
            NEXT FIELD book1 
            END IF
            #No.FUN-670005--begin
#No.FUN-A10098 ---start
#             CALL s_check_bookno(tm.book1,g_user,tm.plant1) 
#                  RETURNING li_chk_bookno
             CALL s_check_bookno(tm.book1,g_user,g_plant)
                   RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD book1
             END IF
#             LET g_plant_new=tm.plant1   # 工廠編號
#             CALL s_getdbs()
#             LET l_sql = "SELECT * ",
#                         "  FROM ",g_dbs_new CLIPPED,"aaa_file ",
#No.FUN-A10098 ---end
             LET l_sql = "SELECT * FROM aaa_file ",          #No.FUN-A10098 ---add
                         "  WHERE aaa01 = '",tm.book1,"' ",
                         "    AND aaaacti = 'Y' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032     #No.FUN-A10098 ---mark
             PREPARE p150_pre1 FROM l_sql
             DECLARE p150_cur1 CURSOR FOR p150_pre1
             OPEN p150_cur1
             FETCH p150_cur1 
 
            #No.FUN-670005--end
               
            
#            SELECT aaa02 FROM aaa_file #No.FUN-670005
#             WHERE aaa01 = tm.book1    #No.FUN-670005
#               AND aaaacti = 'Y'       #No.FUN-670005       
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.book1,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD book1
            END IF
 
         AFTER FIELD book2
            IF tm.book2 IS NULL THEN
            NEXT FIELD book2 
            END IF
#No.FUN-A10098 ---start
#            #No.FUN-670005--begin
#             CALL s_check_bookno(tm.book2,g_user,tm.plant2) 
#                  RETURNING li_chk_bookno
             CALL s_check_bookno(tm.book2,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD book2
             END IF
#             LET g_plant_new=tm.plant2   # 工廠編號
#             CALL s_getdbs()
#             LET l_sql = "SELECT * ",
#                         "  FROM ",g_dbs_new CLIPPED,"aaa_file ",
#No.FUN-A10098 ---end
             LET l_sql = "SELECT * FROM aaa_file ",  #No.FUN-A10098 ---add
                         "  WHERE aaa01 = '",tm.book2,"' ",
                         "    AND aaaacti = 'Y' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032    #No.FUN-A10098 ---mark
             PREPARE p150_pre2 FROM l_sql
             DECLARE p150_cur2 CURSOR FOR p150_pre2
             OPEN p150_cur2
             FETCH p150_cur2
#            SELECT aaa02 FROM aaa_file
#               WHERE aaa01 = tm.book2
#                 AND aaaacti = 'Y'
            #No.FUN-670005--end
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.book2,tm.book1,STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD book2
            END IF
      
         AFTER FIELD book3
            IF tm.book3 IS NULL THEN
            NEXT FIELD book3 
            END IF
#No.FUN-A10098 ---start
#            #No.FUN-670005--begin
#             CALL s_check_bookno(tm.book3,g_user,tm.plant3) 
#                  RETURNING li_chk_bookno
             CALL s_check_bookno(tm.book3,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
               NEXT FIELD book3
             END IF 
#             LET g_plant_new=tm.plant3   # 工廠編號
#             CALL s_getdbs()
#             LET l_sql = "SELECT * ",
#                         "  FROM ",g_dbs_new CLIPPED,"aaa_file ",
#No.FUN-A10098 ---end
              LET l_sql = "SELECT * FROM aaa_file ",             #No.FUN-A10098 ---add
                         "  WHERE aaa01 = '",tm.book3,"' ",
                         "    AND aaaacti = 'Y' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032    #No.FUN-A10098 ---mark
             PREPARE p150_pre3 FROM l_sql
             DECLARE p150_cur3 CURSOR FOR p150_pre3
             OPEN p150_cur3
             FETCH p150_cur3
#            SELECT aaa02 FROM aaa_file
#              WHERE aaa01 = tm.book3
#                AND aaaacti = 'Y'
            #No.FUN-670005--end
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.book3,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD book3
            END IF
      
         AFTER FIELD book4
            IF tm.book4 IS NULL THEN
            NEXT FIELD book4 
            END IF
#No.FUN-A10098 ---start
#            #No.FUN-670005--begin
#             CALL s_check_bookno(tm.book4,g_user,tm.plant4) 
#                  RETURNING li_chk_bookno
             CALL s_check_bookno(tm.book4,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD book4
             END IF 
#             LET g_plant_new=tm.plant4   # 工廠編號
#             CALL s_getdbs()
#             LET l_sql = "SELECT * ",
#                         "  FROM ",g_dbs_new CLIPPED,"aaa_file ",
#No.FUN-A10098 ---end
              LET l_sql = "SELECT * FROM aaa_file ",    #No.FUN-A10098 ---add
                         "  WHERE aaa01 = '",tm.book4,"' ",
                         "    AND aaaacti = 'Y' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032    #No.FUN-A10098 ---mark
             PREPARE p150_pre4 FROM l_sql
             DECLARE p150_cur4 CURSOR FOR p150_pre4
             OPEN p150_cur4
             FETCH p150_cur4
#            SELECT aaa02 FROM aaa_file
#              WHERE aaa01 = tm.book4
#                AND aaaacti = 'Y'
           #No.FUN-670005--end
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.book4,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD book4
            END IF
      
         AFTER FIELD book5
            IF tm.book5 IS NULL THEN
            NEXT FIELD book5 
            END IF
#No.FUN-A10098 ---start
#            #No.FUN-670005--begin
#             CALL s_check_bookno(tm.book5,g_user,tm.plant5) 
#                  RETURNING li_chk_bookno
             CALL s_check_bookno(tm.book5,g_user,g_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD book5
             END IF
#             LET g_plant_new=tm.plant5   # 工廠編號
#             CALL s_getdbs()
#             LET l_sql = "SELECT * ",
#                         "  FROM ",g_dbs_new CLIPPED,"aaa_file ",
#No.FUN-A10098 ---end
              LET l_sql = "SELECT * FROM aaa_file ",
                         "  WHERE aaa01 = '",tm.book5,"' ",
                         "    AND aaaacti = 'Y' "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032     #No.FUN-A10098 ---mark
             PREPARE p150_pre5 FROM l_sql
             DECLARE p150_cur5 CURSOR FOR p150_pre5
             OPEN p150_cur5
             FETCH p150_cur5
#            SELECT aaa02 FROM aaa_file
#              WHERE aaa01 = tm.book5
#                AND aaaacti = 'Y'
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.book5,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD book5
            END IF
      
         AFTER FIELD title5
            IF tm.title5 = 'TOTAL' THEN
               LET tm.yy5 = NULL
               LET tm.bm5 = NULL
               LET tm.em5 = NULL
#               LET tm.plant5 = NULL               #No.FUN-A10098 ---mark
               LET tm.book5 = NULL
#               DISPLAY BY NAME tm.yy5,tm.bm5,tm.em5,tm.plant5,tm.book5    #No.FUN-A10098 ---mark
               DISPLAY BY NAME tm.yy5,tm.bm5,tm.em5,tm.book5               #No.FUN-A10098 ---add
            END IF
      
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN 
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
      
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0 THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN 
               NEXT FIELD h
            END IF
      
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o 
            END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
      
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more 
            END IF
      
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.p,'agl-109',0)   #No.FUN-660123
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
               NEXT FIELD p 
            END IF
      
         BEFORE FIELD q
            IF tm.o = 'N' THEN
               NEXT FIELD o 
            END IF

             
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
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
#No.FUN-A10098 ---mark start
#
#           LET tm.dbs1 = NULL
#           LET tm.dbs2 = NULL
#           LET tm.dbs3 = NULL
#           LET tm.dbs4 = NULL
#           LET tm.dbs5 = NULL
#           IF tm.plant1 IS NOT NULL THEN
#              SELECT azp03 INTO tm.dbs1 FROM azp_file WHERE azp01=tm.plant1
#              #No.FUN-7B0012  --Begin
#              LET tm.dbs1 = s_dbstring(tm.dbs1 CLIPPED)    #FUN-820017
#              #No.FUN-7B0012  --End  
#           END IF
#           IF tm.plant2 IS NOT NULL THEN
#              SELECT azp03 INTO tm.dbs2 FROM azp_file WHERE azp01=tm.plant2
#              #No.FUN-7B0012  --Begin
#              LET tm.dbs2 = s_dbstring(tm.dbs2 CLIPPED)    #FUN-820017
#              #No.FUN-7B0012  --End  
#           END IF
#           IF tm.plant3 IS NOT NULL THEN
#              SELECT azp03 INTO tm.dbs3 FROM azp_file WHERE azp01=tm.plant3
#              #No.FUN-7B0012  --Begin
#              LET tm.dbs3 = s_dbstring(tm.dbs3 CLIPPED)    #FUN-820017
#              #No.FUN-7B0012  --End  
#           END IF
#           IF tm.plant4 IS NOT NULL THEN
#              SELECT azp03 INTO tm.dbs4 FROM azp_file WHERE azp01=tm.plant4
#              #No.FUN-7B0012  --Begin
#              LET tm.dbs4 = s_dbstring(tm.dbs4 CLIPPED)    #FUN-820017
#              #No.FUN-7B0012  --End  
#           END IF
#           IF tm.plant5 IS NOT NULL THEN
#              SELECT azp03 INTO tm.dbs5 FROM azp_file WHERE azp01=tm.plant5
#              #No.FUN-7B0012  --Begin
#              LET tm.dbs5 = s_dbstring(tm.dbs5 CLIPPED)    #FUN-820017
#              #No.FUN-7B0012  --End  
#           END IF
#
#No.FUN-A10098 ---mark end
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN 
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN 
               LET g_unit = 1000000
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask() 
 
         ON ACTION CONTROLP
            IF INFIELD(a) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",g_aza.aza81,"'"     #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",g_aza.aza81,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a 
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p 
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF
#No.FUN-A10098 ---mark
#
#           IF INFIELD(plant1) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azp'
#              LET g_qryparam.default1 = tm.plant1
#              CALL cl_create_qry() RETURNING tm.plant1
#              DISPLAY BY NAME tm.plant1 NEXT FIELD plant1
#           END IF
#           IF INFIELD(plant2) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azp'
#              LET g_qryparam.default1 = tm.plant2
#              CALL cl_create_qry() RETURNING tm.plant2
#              DISPLAY BY NAME tm.plant2 NEXT FIELD plant2
#           END IF
#           IF INFIELD(plant3) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azp'
#              LET g_qryparam.default1 = tm.plant3
#              CALL cl_create_qry() RETURNING tm.plant3
#              DISPLAY BY NAME tm.plant3 NEXT FIELD plant3
#           END IF
#           IF INFIELD(plant4) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azp'
#              LET g_qryparam.default1 = tm.plant4
#              CALL cl_create_qry() RETURNING tm.plant4
#              DISPLAY BY NAME tm.plant4 NEXT FIELD plant4
#           END IF
#            #-----No.MOD-4A0248------
#           IF INFIELD(plant5) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = 'q_azp'
#              LET g_qryparam.default1 = tm.plant5
#              CALL cl_create_qry() RETURNING tm.plant5
#              DISPLAY BY NAME tm.plant5 NEXT FIELD plant5
#           END IF
#
#No.FUN-A10098 ---mark end
            IF INFIELD(book1) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.book1
               CALL cl_create_qry() RETURNING tm.book1
               DISPLAY BY NAME tm.book1 NEXT FIELD book1
            END IF
            IF INFIELD(book2) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.book2
               CALL cl_create_qry() RETURNING tm.book2
               DISPLAY BY NAME tm.book2 NEXT FIELD book2
            END IF
            IF INFIELD(book3) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.book3
               CALL cl_create_qry() RETURNING tm.book3
               DISPLAY BY NAME tm.book3 NEXT FIELD book3
            END IF
            IF INFIELD(book4) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.book4
               CALL cl_create_qry() RETURNING tm.book4
               DISPLAY BY NAME tm.book4 NEXT FIELD book4
            END IF
            IF INFIELD(book5) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.book5
               CALL cl_create_qry() RETURNING tm.book5
               DISPLAY BY NAME tm.book5 NEXT FIELD book5
            END IF
            #------END-------
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r150_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr150'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr150','9031',1)   
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
                       #-----TQC-610056---------
                       " '",tm.title1 CLIPPED,"'",
                       " '",tm.yy1 CLIPPED,"'",
                       " '",tm.bm1 CLIPPED,"'",
                       " '",tm.em1 CLIPPED,"'",
                       " '",tm.title2 CLIPPED,"'",
                       " '",tm.yy2 CLIPPED,"'",
                       " '",tm.bm2 CLIPPED,"'",
                       " '",tm.em2 CLIPPED,"'",
                       " '",tm.title3 CLIPPED,"'",
                       " '",tm.yy3 CLIPPED,"'",
                       " '",tm.bm3 CLIPPED,"'",
                       " '",tm.em3 CLIPPED,"'",
                       " '",tm.title4 CLIPPED,"'",
                       " '",tm.yy4 CLIPPED,"'",
                       " '",tm.bm4 CLIPPED,"'",
                       " '",tm.em4 CLIPPED,"'",
                       " '",tm.title5 CLIPPED,"'",
                       " '",tm.yy5 CLIPPED,"'",
                       " '",tm.bm5 CLIPPED,"'",
                       " '",tm.em5 CLIPPED,"'",
                       #-----END TQC-610056-----
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr150',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r150_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r150()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r150_w
 
END FUNCTION
 
FUNCTION r150()
   DEFINE l_name    LIKE type_file.chr20      # External(Disk) file name    #No.FUN-680098  VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000) 
   DEFINE l_sql1    LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000)
   DEFINE l_sql2    LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000)
   DEFINE l_sql3    LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1       #No.FUN-680098    VARCHAR(1)
   DEFINE amt1,amt2,amt3,amt4,amt5 LIKE aah_file.aah04
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_azk041_1  LIKE azk_file.azk041
   DEFINE l_azk041_2  LIKE azk_file.azk041
   DEFINE l_azk041_3  LIKE azk_file.azk041
   DEFINE l_azk041_4  LIKE azk_file.azk041
   DEFINE l_azk041_5  LIKE azk_file.azk041
   DEFINE l_azk02_1   LIKE azk_file.azk02
   DEFINE l_azk02_2   LIKE azk_file.azk02
   DEFINE l_azk02_3   LIKE azk_file.azk02
   DEFINE l_azk02_4   LIKE azk_file.azk02
   DEFINE l_azk02_5   LIKE azk_file.azk02
   DEFINE i           LIKE type_file.num5        #No.FUN-680098  smallint
   DEFINE l_dbs       LIKE type_file.chr21       #No.FUN-680098  VARCHAR(21)   
   DEFINE sr          RECORD
                         bal1,bal2,bal3,bal4,bal5      LIKE aah_file.aah04
                      END RECORD
#No.FUN-780060--start--add 
   DEFINE per1,per2,per3,per4,per5    LIKE fid_file.fid03  
   DEFINE l_tit1            LIKE type_file.chr1000 
   DEFINE l_tit2            LIKE type_file.chr1000  
   DEFINE l_tit3            LIKE type_file.chr1000
   DEFINE l_tit4            LIKE type_file.chr1000
   DEFINE l_tit5            LIKE type_file.chr1000 
   DEFINE l_tit6            LIKE type_file.chr1000 
   DEFINE l_tit7            LIKE type_file.chr1000 
   DEFINE l_tit8            LIKE type_file.chr1000 
   DEFINE l_tit9            LIKE type_file.chr1000 
   DEFINE l_tit10           LIKE type_file.chr1000 
#No.FUN-780060--end--  
   CALL cl_del_data(l_table)                 #No.FUN-780060
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #------------no.3989  依工廠別組 sql-------------------------
   FOR i = 1 TO 5
#No.FUN-A10098 ---mark start
#      CASE i WHEN 1 LET l_dbs = tm.dbs1
#             WHEN 2 LET l_dbs = tm.dbs2
#             WHEN 3 LET l_dbs = tm.dbs3
#             WHEN 4 LET l_dbs = tm.dbs4
#             WHEN 5 LET l_dbs = tm.dbs5
#      END CASE
#No.FUN-A10098 ---mark start
 
#      LET l_sql1="SELECT SUM(aah04-aah05) FROM ",l_dbs,"aah_file,aag_file",    #No.FUN-A10098 ---mark
       LET l_sql1="SELECT SUM(aah04-aah05) FROM aah_file,aag_file",             #No.FUN-A10098 ---add
                 " WHERE aah00 = ?",
                 "   AND aah01 BETWEEN ? AND ?",
                 "   AND aah02 = ?",
                 "   AND aah03 BETWEEN ? AND ?",
                 "   AND aah01 = aag01 AND aah00 = aag00 AND aag07 IN ('2','3')"     #No.FUN-740020
 
#      LET l_sql2="SELECT SUM(aao05-aao06) FROM ",l_dbs,"aao_file,aag_file",     #No.FUN-A10098 ---mark
       LET l_sql2="SELECT SUM(aao05-aao06) FROM aao_file,aag_file",              #No.FUN-A10098 ---add
                 " WHERE aao00 = ?",
                 "   AND aao01 BETWEEN ? AND ?",
                 "   AND aao02 BETWEEN ? AND ?",
                 "   AND aao03 = ?",
                 "   AND aao04 BETWEEN ? AND ?",
                 "   AND aao01 = aag01  AND aao00 = aag00 AND aag07 IN ('2','3')"   #No.FUN-740020
 
#      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032   #FUN-950007 add     #No.FUN-A10098 ---mark
#      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032   #FUN-950007 add     #No.FUN-A10098 ---mark
      CASE i WHEN 1 
 	#CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032  #FUN-950007 add
               PREPARE aah_p1 FROM l_sql1 DECLARE aah_c1 CURSOR FOR aah_p1
               PREPARE aao_p1 FROM l_sql2 DECLARE aao_c1 CURSOR FOR aao_p1
             WHEN 2 
               PREPARE aah_p2 FROM l_sql1 DECLARE aah_c2 CURSOR FOR aah_p2
               PREPARE aao_p2 FROM l_sql2 DECLARE aao_c2 CURSOR FOR aao_p2
             WHEN 3 
               PREPARE aah_p3 FROM l_sql1 DECLARE aah_c3 CURSOR FOR aah_p3
               PREPARE aao_p3 FROM l_sql2 DECLARE aao_c3 CURSOR FOR aao_p3
             WHEN 4 
               PREPARE aah_p4 FROM l_sql1 DECLARE aah_c4 CURSOR FOR aah_p4
               PREPARE aao_p4 FROM l_sql2 DECLARE aao_c4 CURSOR FOR aao_p4
             WHEN 5 
               PREPARE aah_p5 FROM l_sql1 DECLARE aah_c5 CURSOR FOR aah_p5
               PREPARE aao_p5 FROM l_sql2 DECLARE aao_c5 CURSOR FOR aao_p5
      END CASE
   END FOR
   #------------------------------------------------------------
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r150_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)    
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r150_c CURSOR FOR r150_p
 
   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0
      LET g_tot2[g_i] = 0
      LET g_tot3[g_i] = 0
      LET g_tot4[g_i] = 0
      LET g_tot5[g_i] = 0
   END FOR
 
#  CALL cl_outnam('aglr150') RETURNING l_name        #No.FUN-780060
#  START REPORT r150_rep TO l_name                   #No.FUN-780060
 
#  LET g_pageno = 0
 
   FOREACH r150_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET amt1 = 0
      LET amt2 = 0 
      LET amt3 = 0
      LET amt4 = 0
      LET amt5 = 0
 
      IF NOT cl_null(maj.maj21) THEN
         IF maj.maj24 IS NULL THEN
            OPEN aah_c1 USING tm.book1,maj.maj21,maj.maj22,tm.yy1,tm.bm1,tm.em1
            IF STATUS THEN 
               CALL cl_err('open aah_c1',STATUS,1)
            END IF
            FETCH aah_c1 INTO amt1
         ELSE 
            OPEN aao_c1 USING tm.book1,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                              tm.yy1,tm.bm1,tm.em1
            IF STATUS THEN 
               CALL cl_err('open aao_c1',STATUS,1) 
            END IF
            FETCH aao_c1 INTO amt1
         END IF
         IF STATUS THEN 
            CALL cl_err('sel aah1:',STATUS,1)
            EXIT FOREACH
         END IF
         IF amt1 IS NULL THEN
            LET amt1 = 0
         END IF
      END IF
 
      IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
         IF maj.maj24 IS NULL THEN
            OPEN aah_c2 USING tm.book2,maj.maj21,maj.maj22,tm.yy2,tm.bm2,tm.em2
            IF STATUS THEN
               CALL cl_err('open aah_c2',STATUS,1)
            END IF
            FETCH aah_c2 INTO amt2
         ELSE 
            OPEN aao_c2 USING tm.book2,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                              tm.yy2,tm.bm2,tm.em2
            IF STATUS THEN 
               CALL cl_err('open aao_c2',STATUS,1)
            END IF
            FETCH aao_c2 INTO amt2
         END IF
         IF STATUS THEN 
            CALL cl_err('sel aah2:',STATUS,1) 
            EXIT FOREACH
         END IF
         IF amt2 IS NULL THEN
            LET amt2 = 0
         END IF
      END IF
 
      IF NOT cl_null(maj.maj21) AND tm.yy3 IS NOT NULL THEN
         IF maj.maj24 IS NULL THEN
            OPEN aah_c3 USING tm.book3,maj.maj21,maj.maj22,tm.yy3,tm.bm3,tm.em3
            IF STATUS THEN
               CALL cl_err('open aah_c3',STATUS,1)
            END IF
            FETCH aah_c3 INTO amt3
         ELSE 
            OPEN aao_c3 USING tm.book3,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                              tm.yy3,tm.bm3,tm.em3
            IF STATUS THEN
               CALL cl_err('open aao_c3',STATUS,1) 
            END IF
            FETCH aao_c3 INTO amt3
         END IF
         IF STATUS THEN
            CALL cl_err('sel aah3:',STATUS,1)
            EXIT FOREACH 
         END IF
         IF amt3 IS NULL THEN
            LET amt3 = 0
         END IF
      END IF
 
      IF NOT cl_null(maj.maj21) AND tm.yy4 IS NOT NULL THEN
         IF maj.maj24 IS NULL THEN 
            OPEN aah_c4 USING tm.book4,maj.maj21,maj.maj22,tm.yy4,tm.bm4,tm.em4
            IF STATUS THEN
               CALL cl_err('open aah_c4',STATUS,1)
            END IF
            FETCH aah_c4 INTO amt4
         ELSE 
            OPEN aao_c4 USING tm.book4,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                              tm.yy4,tm.bm4,tm.em4
            IF STATUS THEN
               CALL cl_err('open aao_c4',STATUS,1)
            END IF
            FETCH aao_c4 INTO amt4
         END IF
         IF STATUS THEN
            CALL cl_err('sel aah4:',STATUS,1)
            EXIT FOREACH 
         END IF
         IF amt4 IS NULL THEN
            LET amt4 = 0
         END IF
      END IF
 
      IF NOT cl_null(maj.maj21) AND tm.yy5 IS NOT NULL THEN
         IF maj.maj24 IS NULL THEN
            OPEN aah_c5 USING tm.book5,maj.maj21,maj.maj22,tm.yy5,tm.bm5,tm.em5
            IF STATUS THEN
               CALL cl_err('open aah_c5',STATUS,1)
            END IF
            FETCH aah_c5 INTO amt5
         ELSE 
            OPEN aao_c5 USING tm.book5,maj.maj21,maj.maj22,maj.maj24,maj.maj25,
                              tm.yy5,tm.bm5,tm.em5
            IF STATUS THEN 
               CALL cl_err('open aao_c5',STATUS,1) 
            END IF
            FETCH aao_c5 INTO amt5
         END IF
         IF STATUS THEN 
            CALL cl_err('sel aah5:',STATUS,1) 
            EXIT FOREACH
         END IF
         IF amt5 IS NULL THEN
            LET amt5 = 0
         END IF
      END IF
 
      #------------------------------------------------------------
      IF tm.title5 = 'TOTAL' THEN      # 當第五期名稱為'TOTAL'時,表合計
         LET amt5 = amt1 + amt2 + amt3 + amt4
      END IF
      #------------------------------------------------------------
 
      #------------no.3989  依工廠別組 sql-------------------------
      #抓取幣別小數取位........
      FOR i = 1 TO 5
#No.FUN-A10098 ---mark start
#         CASE i WHEN 1 LET l_dbs = tm.dbs1
#                WHEN 2 LET l_dbs = tm.dbs2
#                WHEN 3 LET l_dbs = tm.dbs3
#                WHEN 4 LET l_dbs = tm.dbs4
#                WHEN 5 LET l_dbs = tm.dbs5
#         END CASE
#No.FUN-A10098 ---mark end
 
         #---NO:3531 wiky
#         LET l_sql3="SELECT MAX(azk02),azk041 FROM ",l_dbs,"azk_file",         #No.FUN-A10098 ---mark
         LET l_sql3="SELECT MAX(azk02),azk041 FROM azk_file",                   #No.FUN-A10098 ---add
                    " WHERE azk01=?",
                    "   AND YEAR(azk02)=?",
                    "   AND MONTH(azk02)=?",
                    " GROUP BY azk041 "
 
# 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032  #FUN-950007 add    #No.FUN-A10098 ---mark
         IF tm.o = 'Y' THEN #轉換幣別='Y'
            CASE i 
              WHEN 1   #---抓第一個azk041 
 	#CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032  #FUN-950007 mark
                 PREPARE azk_01 FROM l_sql3 DECLARE azk_1 CURSOR FOR azk_01
                 OPEN azk_1 USING tm.p,tm.yy1,tm.q
                 IF STATUS THEN CALL cl_err('open azk_1',STATUS,1) END IF
                 FETCH azk_1 INTO l_azk02_1,l_azk041_1
              WHEN 2   #---抓第二個azk041 
                 PREPARE azk_02 FROM l_sql3 DECLARE azk_2 CURSOR FOR azk_02
                 OPEN azk_2 USING tm.p,tm.yy2,tm.q
                 IF STATUS THEN CALL cl_err('open azk_2',STATUS,1) END IF
                 FETCH azk_2 INTO l_azk02_2,l_azk041_2
              WHEN 3   #---抓第三個azk041 
                 PREPARE azk_03 FROM l_sql3 DECLARE azk_3 CURSOR FOR azk_03
                 OPEN azk_3 USING tm.p,tm.yy3,tm.q
                 IF STATUS THEN CALL cl_err('open azk_3',STATUS,1) END IF
                 FETCH azk_3 INTO l_azk02_3,l_azk041_3
              WHEN 4   #---抓第四個azk041 
                 PREPARE azk_04 FROM l_sql3 DECLARE azk_4 CURSOR FOR azk_04
                 OPEN azk_4 USING tm.p,tm.yy4,tm.q
                 IF STATUS THEN CALL cl_err('open azk_4',STATUS,1) END IF
                 FETCH azk_4 INTO l_azk02_4,l_azk041_4
              WHEN 5   #---抓第五個azk041 
                 LET l_sql3[31,51]=tm.dbs5
                 PREPARE azk_05 FROM l_sql3 DECLARE azk_5 CURSOR FOR azk_05
                 OPEN azk_5 USING tm.p,tm.yy5,tm.q
                 IF STATUS THEN CALL cl_err('open azk_5',STATUS,1) END IF
                 FETCH azk_5 INTO l_azk02_5,l_azk041_5
            END CASE
         ELSE                                   
            CASE i 
              WHEN 1   #---抓第一個azk041 
                 PREPARE azk_x01 FROM l_sql3 DECLARE azk_x1 CURSOR FOR azk_x01
                 OPEN azk_x1 USING tm.r,tm.yy1,tm.q
                 IF STATUS THEN CALL cl_err('open azk_x1',STATUS,1) END IF
                 FETCH azk_x1 INTO l_azk02_1,l_azk041_1
              WHEN 2   #---抓第二個azk041 
                 PREPARE azk_x02 FROM l_sql3 DECLARE azk_x2 CURSOR FOR azk_x02
                 OPEN azk_x2 USING tm.r,tm.yy2,tm.q
                 IF STATUS THEN CALL cl_err('open azk_x2',STATUS,1) END IF
                 FETCH azk_x2 INTO l_azk02_2,l_azk041_2
              WHEN 3   #---抓第三個azk041 
                 PREPARE azk_x03 FROM l_sql3 DECLARE azk_x3 CURSOR FOR azk_x03
                 OPEN azk_x3 USING tm.r,tm.yy3,tm.q
                 IF STATUS THEN CALL cl_err('open azk_x3',STATUS,1) END IF
                 FETCH azk_x3 INTO l_azk02_3,l_azk041_3
              WHEN 4   #---抓第四個azk041 
                 PREPARE azk_x04 FROM l_sql3 DECLARE azk_x4 CURSOR FOR azk_x04
                 OPEN azk_x4 USING tm.r,tm.yy4,tm.q
                 IF STATUS THEN CALL cl_err('open azk_x4',STATUS,1) END IF
                 FETCH azk_x4 INTO l_azk02_4,l_azk041_4
              WHEN 5   #---抓第五個azk041 
                 PREPARE azk_x05 FROM l_sql3 DECLARE azk_x5 CURSOR FOR azk_x05
                 OPEN azk_x5 USING tm.r,tm.yy5,tm.q
                 IF STATUS THEN CALL cl_err('open azk_x5',STATUS,1) END IF
                 FETCH azk_x5 INTO l_azk02_5,l_azk041_5
            END CASE
         END IF
      END FOR
      IF tm.q IS NULL THEN
         LET l_azk041_1 = 1 
         LET l_azk041_2 = 1 
         LET l_azk041_3 = 1 
         LET l_azk041_4 = 1 
         LET l_azk041_5 = 1 
      END IF
 
      IF l_azk041_1 IS NULL THEN
         LET l_azk041_1 = 1 
      END IF
 
      IF l_azk041_2 IS NULL THEN
         LET l_azk041_2 = 1 
      END IF
 
      IF l_azk041_3 IS NULL THEN
         LET l_azk041_3 = 1 
      END IF
 
      IF l_azk041_4 IS NULL THEN
         LET l_azk041_4 = 1 
      END IF
 
      IF l_azk041_5 IS NULL THEN
         LET l_azk041_5 = 1 
      END IF
      
      #各期科目餘額 * azk041
      LET amt1 = amt1 * l_azk041_1 
      LET amt2 = amt2 * l_azk041_2
      LET amt3 = amt3 * l_azk041_3
      LET amt4 = amt4 * l_azk041_4 
      LET amt5 = amt5 * l_azk041_5
      #---NO:3531 wiky
    
      #TQC-C60121--mark--str-- 
      #TQC-C50091--add--str
      #IF maj.maj07 = '2' THEN
      #   LET amt1 = amt1 * -1
      #   LET amt2 = amt2 * -1
      #   LET amt3 = amt3 * -1
      #   LET amt4 = amt4 * -1
      #   LET amt5 = amt5 * -1
      #END IF
      #TQC-C50091--add--end
      #TQC-C60121--mark--end--
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN      #合計階數處理
         FOR i = 1 TO 100 
           #CHI-A70050---modify---start---
           #LET g_tot1[i] = g_tot1[i] + amt1 
           #LET g_tot2[i] = g_tot2[i] + amt2
           #LET g_tot3[i] = g_tot3[i] + amt3 
           #LET g_tot4[i] = g_tot4[i] + amt4
           #LET g_tot5[i] = g_tot5[i] + amt5
            IF maj.maj09 = '-' THEN
               LET g_tot1[i] = g_tot1[i] - amt1 
               LET g_tot2[i] = g_tot2[i] - amt2
               LET g_tot3[i] = g_tot3[i] - amt3 
               LET g_tot4[i] = g_tot4[i] - amt4
               LET g_tot5[i] = g_tot5[i] - amt5
            ELSE
               LET g_tot1[i] = g_tot1[i] + amt1 
               LET g_tot2[i] = g_tot2[i] + amt2
               LET g_tot3[i] = g_tot3[i] + amt3 
               LET g_tot4[i] = g_tot4[i] + amt4
               LET g_tot5[i] = g_tot5[i] + amt5
            END IF
           #CHI-A70050---modify---end---
         END FOR
 
         LET k = maj.maj08  
         LET sr.bal1 = g_tot1[k]
         LET sr.bal2 = g_tot2[k]
         LET sr.bal3 = g_tot3[k]
         LET sr.bal4 = g_tot4[k]
         LET sr.bal5 = g_tot5[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal2 = sr.bal2 *-1
            LET sr.bal3 = sr.bal3 *-1
            LET sr.bal4 = sr.bal4 *-1
            LET sr.bal5 = sr.bal5 *-1
         END IF
        #CHI-A70050---add---end---
 
         FOR i = 1 TO maj.maj08
            LET g_tot1[i] = 0
            LET g_tot2[i] = 0
            LET g_tot3[i] = 0 
            LET g_tot4[i] = 0 
            LET g_tot5[i] = 0 
         END FOR
      ELSE
         IF maj.maj03 = '5' THEN
            LET sr.bal1 = amt1
            LET sr.bal2 = amt2
            LET sr.bal3 = amt3
            LET sr.bal4 = amt4
            LET sr.bal5 = amt5
         ELSE
            LET sr.bal1 = NULL 
            LET sr.bal2 = NULL 
            LET sr.bal3 = NULL 
            LET sr.bal4 = NULL 
            LET sr.bal5 = NULL 
         END IF
      END IF
      IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
         LET g_basetot1 = sr.bal1
         LET g_basetot2 = sr.bal2
         LET g_basetot3 = sr.bal3
         LET g_basetot4 = sr.bal4
         LET g_basetot5 = sr.bal5
         IF maj.maj07 = '2' THEN
            LET g_basetot1 = g_basetot1 * -1 
            LET g_basetot2 = g_basetot2 * -1 
            LET g_basetot3 = g_basetot3 * -1
            LET g_basetot4 = g_basetot4 * -1 
            LET g_basetot5 = g_basetot5 * -1
         END IF
         #CHI-A70046 add --start--
         LET g_basetot1=g_basetot1/g_unit
         LET g_basetot2=g_basetot2/g_unit
         LET g_basetot3=g_basetot3/g_unit
         LET g_basetot4=g_basetot4/g_unit
         LET g_basetot5=g_basetot5/g_unit
         #CHI-A70046 add --end--
      END IF
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH
      END IF #本行不印出
 
     #IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"   #MOD-8A0211 mark
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"  #MOD-8A0211
         AND sr.bal1 = 0 AND sr.bal2 = 0 AND sr.bal3 = 0 AND sr.bal4 = 0
         AND sr.bal5 = 0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
 
      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
#No.FUN-780060--start--add
        #TQC-C60121--unmark--str--
        #TQC-C50091--mark--str
        IF maj.maj07 = '2' THEN 
           LET sr.bal1 = sr.bal1 * -1 
           LET sr.bal2 = sr.bal2 * -1
           LET sr.bal3 = sr.bal3 * -1
           LET sr.bal4 = sr.bal4 * -1
           LET sr.bal5 = sr.bal5 * -1 
        END IF
        #TQC-C50091--mark--end
        #TQC-C60121--unmark--end--
         IF tm.h = 'Y' THEN    
            LET maj.maj20 = maj.maj20e
         END IF
         LET per1 = (sr.bal1 / g_basetot1) * 100 
         LET per2 = (sr.bal2 / g_basetot2) * 100 
         LET per3 = (sr.bal3 / g_basetot3) * 100
         LET per4 = (sr.bal4 / g_basetot4) * 100  
         LET per5 = (sr.bal5 / g_basetot5) * 100 
         IF tm.d MATCHES '[23]' THEN 
            LET sr.bal1 = sr.bal1 / g_unit 
            LET sr.bal2 = sr.bal2 / g_unit
            LET sr.bal3 = sr.bal3 / g_unit 
            LET sr.bal4 = sr.bal4 / g_unit 
            LET sr.bal5 = sr.bal5 / g_unit 
         END IF                                                                     
         LET maj.maj20 = maj.maj05 SPACES,maj.maj20
         IF maj.maj04=0 THEN 
            EXECUTE insert_prep USING
                    maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,  #FUN-B90140   Add maj.maj31
                    sr.bal1,sr.bal2,sr.bal3,sr.bal4,sr.bal5,
                    per1,per2,per3,per4,per5,
                    '2',tm.acc_code       	#FUN-B90140 ADD tm.acc_code
         ELSE 
            EXECUTE insert_prep USING                                                                                                     
                   maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03, #FUN-B90140   Add maj.maj31                                                                      
                    sr.bal1,sr.bal2,sr.bal3,sr.bal4,sr.bal5,                                                                         
                    per1,per2,per3,per4,per5,                                                                                       
                    '2',tm.acc_code              #FUN-B90140 ADD tm.acc_code
            FOR i=1 TO maj.maj04
            EXECUTE insert_prep USING
                    maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,    #FUN-B90140   Add maj.maj31
                    '0','0','0','0','0',
                    '0','0','0','0','0',
                    '1',tm.acc_code               #FUN-B90140 ADD tm.acc_code
            END FOR
         END IF
#No.FUN-780060--end--
#     OUTPUT TO REPORT r150_rep(maj.*, sr.*)
 
   END FOREACH
 
   IF g_basetot1 = 0 THEN
      LET g_basetot1 = NULL
   END IF
 
   IF g_basetot2 = 0 THEN
      LET g_basetot2 = NULL
   END IF
 
   IF g_basetot3 = 0 THEN
      LET g_basetot3 = NULL
   END IF
 
   IF g_basetot4 = 0 THEN
      LET g_basetot4 = NULL
   END IF
 
   IF g_basetot5 = 0 THEN
      LET g_basetot5 = NULL
   END IF
#No.FUN-780060--start--add
   LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&', 
                  '-',tm.em1 USING'&&',")" 
   LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&', 
                  '-',tm.em2 USING'&&',")"
   LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',
                  '-',tm.em3 USING'&&',")"
   LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',
                  '-',tm.em4 USING'&&',")" 
   LET l_tit5 = "(",tm.yy5 USING '<<<<','/',tm.bm5 USING'&&', 
                  '-',tm.em5 USING'&&',")"
#No.FUN-A10098 ---mark start
#   LET l_tit6 =tm.plant1,'           ',tm.book1
#   LET l_tit7 =tm.plant2,'           ',tm.book2
#   LET l_tit8 =tm.plant3,'           ',tm.book3
#   LET l_tit9 =tm.plant4,'           ',tm.book4
#   LET l_tit10 =tm.plant5,'          ',tm.book5
#No.FUN-A10098 ---mark end
#No.FUN-A10098 ---add start
   LET l_tit6 ='           ',tm.book1
   LET l_tit7 ='           ',tm.book2
   LET l_tit8 ='           ',tm.book3
   LET l_tit9 ='           ',tm.book4
   LET l_tit10 ='          ',tm.book5
#No.FUN-A10098 ---add end
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   LET g_str= g_mai02,";",tm.d,";",tm.a,";",tm.p,";",l_tit6,";",
              l_tit7,";",l_tit8,";",l_tit9,";",l_tit10,";",l_tit1,";", 
              l_tit2,";",l_tit3,";",l_tit4   
              ,";",l_tit5,";",tm.e,";", #CHI-A70046 add ,";",   
              g_basetot1,";",g_basetot2,";",g_basetot3,";",g_basetot4 ,";",g_basetot5  #CHI-A70046 add   
    CALL cl_prt_cs3('aglr150','aglr150',g_sql,g_str)
#No.FUN-780060--end--
#  FINISH REPORT r150_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
#No.FUN-780060--start--mark
{REPORT r150_rep(maj, sr)
   DEFINE l_last_sw   LIKE type_file.chr1       #No.FUN-680098    VARCHAR(1)
   DEFINE l_unit      LIKE zaa_file.zaa08       #No.FUN-680098    VARCHAR(4)
   DEFINE per1,per2,per3,per4,per5   LIKE fid_file.fid03   #No.FUN-680098   dec(8,3)
   DEFINE maj          RECORD LIKE maj_file.*  
   DEFINE sr           RECORD
                          bal1,bal2,bal3,bal4,bal5      LIKE aah_file.aah04
                       END RECORD
   DEFINE g_head1      STRING
   DEFINE l_tit1       LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(12)
   DEFINE l_tit2       LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(12)
   DEFINE l_tit3       LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(12)
   DEFINE l_tit4       LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(12)
   DEFINE l_tit5       LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(12)
 
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
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
     
         #金額單位之列印
         CASE tm.d
            WHEN '1'  LET l_unit = g_x[11]
            WHEN '2'  LET l_unit = g_x[12]
            WHEN '3'  LET l_unit = g_x[13]
            OTHERWISE LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[9] CLIPPED,tm.a,'               ',
                       g_x[14] CLIPPED,tm.p,'     ',
                       g_x[10] CLIPPED,l_unit
         PRINT g_head1
         PRINT g_dash[1,g_len]
#No.FUN-A10098 ---mark start
#         PRINT COLUMN g_c[32],tm.plant1,
#               COLUMN g_c[33],tm.book1,
#               COLUMN g_c[34],tm.plant2,
#               COLUMN g_c[35],tm.book2,
#               COLUMN g_c[36],tm.plant3,
#               COLUMN g_c[37],tm.book3,
#               COLUMN g_c[38],tm.plant4,
#               COLUMN g_c[39],tm.book4,
#               COLUMN g_c[40],tm.plant5,
#               COLUMN g_c[41],tm.book5
#No.FUN-A10098 ---mark end
#No.FUN-A10098 ---add start
         PRINT 
               COLUMN g_c[33],tm.book1,
               COLUMN g_c[35],tm.book2,
               COLUMN g_c[37],tm.book3,
               COLUMN g_c[39],tm.book4,
               COLUMN g_c[41],tm.book5
#No.FUN-A10098 ---add end
 
         LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',
                      '-',tm.em1 USING'&&',")"
         LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',
                      '-',tm.em2 USING'&&',")"
         LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',
                      '-',tm.em3 USING'&&',")"
         LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',
                      '-',tm.em4 USING'&&',")"
         LET l_tit5 = "(",tm.yy5 USING '<<<<','/',tm.bm5 USING'&&',
                      '-',tm.em5 USING'&&',")"
         PRINT COLUMN g_c[32],l_tit1 CLIPPED,  #FUN-6C0012
               COLUMN g_c[34],l_tit2 CLIPPED,  #FUN-6C0012
               COLUMN g_c[36],l_tit3 CLIPPED,  #FUN-6C0012
               COLUMN g_c[38],l_tit4 CLIPPED,  #FUN-6C0012
               COLUMN g_c[40],l_tit5 CLIPPED   #FUN-6C0012 
 
         PRINT COLUMN g_c[32],g_dash2[1,(g_w[32]+g_w[33]+1)],
               COLUMN g_c[34],g_dash2[1,(g_w[34]+g_w[35]+1)],
               COLUMN g_c[36],g_dash2[1,(g_w[36]+g_w[37]+1)],
               COLUMN g_c[38],g_dash2[1,(g_w[38]+g_w[39]+1)],
               COLUMN g_c[40],g_dash2[1,(g_w[40]+g_w[41]+1)]
 
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41]
         PRINT g_dash1
         LET l_last_sw = 'n'
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN 
            LET sr.bal1 = sr.bal1 * -1 
            LET sr.bal2 = sr.bal2 * -1 
            LET sr.bal3 = sr.bal3 * -1
            LET sr.bal4 = sr.bal4 * -1
            LET sr.bal5 = sr.bal5 * -1 
         END IF
 
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e
         END IF
 
         CASE 
            WHEN maj.maj03 = '9'
               SKIP TO TOP OF PAGE
            WHEN maj.maj03 = '3'
               PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
                     COLUMN g_c[33],g_dash2[1,g_w[33]],
                     COLUMN g_c[34],g_dash2[1,g_w[34]],
                     COLUMN g_c[35],g_dash2[1,g_w[35]],
                     COLUMN g_c[36],g_dash2[1,g_w[36]],
                     COLUMN g_c[37],g_dash2[1,g_w[37]],
                     COLUMN g_c[38],g_dash2[1,g_w[38]],
                     COLUMN g_c[39],g_dash2[1,g_w[39]],
                     COLUMN g_c[40],g_dash2[1,g_w[40]],
                     COLUMN g_c[41],g_dash2[1,g_w[41]]
            WHEN maj.maj03 = '4'
               PRINT g_dash2
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
 
               LET per1 = (sr.bal1 / g_basetot1) * 100
               LET per2 = (sr.bal2 / g_basetot2) * 100
               LET per3 = (sr.bal3 / g_basetot3) * 100
               LET per4 = (sr.bal4 / g_basetot4) * 100
               LET per5 = (sr.bal5 / g_basetot5) * 100
 
               IF tm.d MATCHES '[23]' THEN
                  LET sr.bal1 = sr.bal1 / g_unit
                  LET sr.bal2 = sr.bal2 / g_unit
                  LET sr.bal3 = sr.bal3 / g_unit
                  LET sr.bal4 = sr.bal4 / g_unit
                  LET sr.bal5 = sr.bal5 / g_unit
               END IF
 
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               PRINT COLUMN g_x[31],maj.maj20,
                     COLUMN g_x[32],cl_numfor(sr.bal1,32,tm.e),
                     COLUMN g_x[33],per1 USING '---&.&&',
                     COLUMN g_x[34],cl_numfor(sr.bal2,34,tm.e),
                     COLUMN g_x[35],per2 USING '---&.&&',
                     COLUMN g_x[36],cl_numfor(sr.bal3,36,tm.e),
                     COLUMN g_x[37],per3 USING '---&.&&', 
                     COLUMN g_x[38],cl_numfor(sr.bal4,38,tm.e),
                     COLUMN g_x[39],per4 USING '---&.&&', 
                     COLUMN g_x[40],cl_numfor(sr.bal5,40,tm.e),
                     COLUMN g_x[41],per5 USING '---&.&&' 
         END CASE
     
      ON LAST ROW
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
     
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
     
END REPORT}
#No.FUN-780060--end--
 
 #No.MOD-510052 add
FUNCTION r150_set_entry() 
 
   IF INFIELD(rtype) THEN
      CALL cl_set_comp_entry("bm1,bm2,bm3,bm4,bm5",TRUE)
   END IF 
 
END FUNCTION
 
FUNCTION r150_set_no_entry()
 
   IF INFIELD(rtype) AND tm.rtype='1' THEN
      CALL cl_set_comp_entry("bm1,bm2,bm3,bm4,bm5",FALSE)
   END IF 
 
END FUNCTION
 #No.MOD-510052 end
