# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr140.4gl
# Descriptions...: 四期財務報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/29 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
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
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By sherry  會計科目加帳套
# Modify.........: No.FUN-780060 07/08/28 By destiny 報表格式改為CR輸出
# Modify.........: No.MOD-8A0211 08/10/29 By Sarah 判斷餘額為零不列印時,maj.maj03 MATCHES "[012]"應改為maj.maj03 MATCHES "[0125]"
# Modify.........: No.MOD-970205 09/07/22 By mike 二期比較應為(第二期-第一期)/第一期，或者是(第一期-第二期)/第二期，而非目前之(第一>
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No.FUN-B90140 11/10/11 By minpp 增加checkbox"列印會計科目"
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.TQC-C50091 12/05/11 By xuxz 報表計算不正確
# Modify.........: No.TQC-C60121 12/06/20 By lujh 還原TQC-C50091修改的內容
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1   , #報表結構編號      #No.FUN-680098  VARCHAR(1)
                 a      LIKE mai_file.mai01,    #報表結構編號      #No.FUN-680098    VARCHAR(4)
                 b      LIKE aaa_file.aaa01,    #帳別編號          #No.FUN-670039
                 title1 LIKE type_file.chr8,    #輸入期別名稱   #No.FUN-680098   VARCHAR(8)
                 yy1    LIKE type_file.num5,    #輸入年度       #No.FUN-680098   smallint 
                 bm1    LIKE type_file.num5,    #Begin 期別     #No.FUN-680098   smallint
                 em1    LIKE type_file.num5,    # End  期別     #No.FUN-680098   smallint
                 title2 LIKE type_file.chr8,    #輸入期別名稱   #No.FUN-680098   VARCHAR(8)
                 yy2    LIKE type_file.num5,    #輸入年度       #No.FUN-680098   smallint
                 bm2    LIKE type_file.num5,    #Begin 期別     #No.FUN-680098   smallilnt
                 em2    LIKE type_file.num5,    # End  期別     #No.FUN-680098   smallint
                 title3 LIKE type_file.chr8,    #輸入期別名稱   #No.FUN-680098   VARCHAR(8)
                 yy3    LIKE type_file.num5,    #輸入年度       #No.FUN-680098   smallint
                 bm3    LIKE type_file.num5,    #Begin 期別     #No.FUN-680098   smallint
                 em3    LIKE type_file.num5,    # End  期別     #No.FUN-680098   smallint
                 title4 LIKE type_file.chr8,    #輸入期別名稱   #No.FUN-680098   VARCHAR(8)
                 yy4    LIKE type_file.num5,    #輸入年度       #No.FUN-680098   smallint
                 bm4    LIKE type_file.num5,    #Begin 期別     #No.FUN-680098   smallint
                 em4    LIKE type_file.num5,    # End  期別     #No.FUN-680098   smallint
                 c      LIKE type_file.chr1,    #異動額及餘額為0者是否列印#No.FUN-680098   VARCHAR(1)
                 d      LIKE type_file.chr1,    #金額單位#No.FUN-680098   VARCHAR(1)
                 e      LIKE type_file.num5,    #小數位數#No.FUN-680098   smallint
                 f      LIKE type_file.num5,               #列印最小階數#No.FUN-680098   smallint
                 h      LIKE type_file.chr4,               #額外說明類別#No.FUN-680098   VARCHAR(4)
                 o      LIKE type_file.chr1,               #轉換幣別否 #No.FUN-680098    VARCHAR(1)
                 r      LIKE azi_file.azi01,  #幣別
                 p      LIKE azi_file.azi01,  #幣別
                 q      LIKE azj_file.azj03,  #匯率
                 more   LIKE type_file.chr1,              #Input more condition(Y/N) #No.FUN-680098   VARCHAR(1)
                 acc_code LIKE type_file.chr1    #FUN-B90140   Add 
             END RECORD,
          bdate,edate   LIKE type_file.dat,          #No.FUN-680098   date
          i,j,k        LIKE type_file.num5,          #No.FUN-680098 smallint
          g_unit       LIKE type_file.num10,         #金額單位基數 #No.FUN-680098   integer
          g_bookno     LIKE aah_file.aah00,          #帳別
          g_mai02      LIKE mai_file.mai02,
          g_mai03      LIKE mai_file.mai03,
          g_tot1       ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot2       ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot3       ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_tot4       ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098  dec(20,6)
          g_basetot1   LIKE aah_file.aah04,
          g_basetot2   LIKE aah_file.aah04,
          g_basetot3   LIKE aah_file.aah04,
          g_basetot4   LIKE aah_file.aah04
   DEFINE g_aaa03      LIKE aaa_file.aaa03   
   DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
   DEFINE g_msg        LIKE type_file.chr1000  #No.FUN-680098   VARCHAR(72)
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
   LET g_sql="maj31.maj_file.maj31,",     #FUN-B90140   Add
             "maj20.maj_file.maj20,", 
             "maj20e.maj_file.maj20e,", 
             "maj02.maj_file.maj02,", 
             "maj03.maj_file.maj03,",  
             "bal1.aah_file.aah04,",  
             "bal2.aah_file.aah04,", 
             "bal3.aah_file.aah04,",
             "bal4.aah_file.aah04,", 
             "per1.fid_file.fid03,",  
             "per2.fid_file.fid03,", 
             "line.type_file.num5"    
   LET l_table = cl_prt_temptable('aglr140',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?, ?)"   #FUN-B90140   Add ? 
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
  LET tm.b  = ARG_VAL(10)
  LET tm.title1  = ARG_VAL(11)
  LET tm.yy1 = ARG_VAL(12)
  LET tm.bm1 = ARG_VAL(13)
  LET tm.em1 = ARG_VAL(14)
  LET tm.title2  = ARG_VAL(15)
  LET tm.yy2 = ARG_VAL(16)
  LET tm.bm2 = ARG_VAL(17)
  LET tm.em2 = ARG_VAL(18)
  LET tm.title3  = ARG_VAL(19)
  LET tm.yy3 = ARG_VAL(20)
  LET tm.bm3 = ARG_VAL(21)
  LET tm.em3 = ARG_VAL(22)
  LET tm.title4  = ARG_VAL(23)
  LET tm.yy4 = ARG_VAL(24)
  LET tm.bm4 = ARG_VAL(25)
  LET tm.em4 = ARG_VAL(26)
  #-----END TQC-610056-----
   LET tm.c  = ARG_VAL(27)
   LET tm.d  = ARG_VAL(28)
   LET tm.e  = ARG_VAL(29)
   LET tm.f  = ARG_VAL(30)
   LET tm.h  = ARG_VAL(31)
   LET tm.o  = ARG_VAL(32)
   LET tm.r  = ARG_VAL(33)
   LET tm.p  = ARG_VAL(34)
   LET tm.q  = ARG_VAL(35)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(36)
   LET g_rep_clas = ARG_VAL(37)
   LET g_template = ARG_VAL(38)
   LET g_rpt_name = ARG_VAL(39)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64 
   END IF
 #No.FUN-740020---begin  
   IF cl_null(tm.b) THEN
      LET tm.b = g_aza.aza81 
   END IF
 #No.FUN-740020---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r140_tm()
   ELSE
      CALL r140() 
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r140_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680098 smallint
          l_sw         LIKE type_file.chr1,         #重要欄位是否空白 #No.FUN-680098   VARCHAR(1)
          l_cmd        LIKE type_file.chr1000       #No.FUN-680098    VARCHAR(400)
   DEFINE li_chk_bookno LIKE type_file.num5         #No.FUN-670005 #No.FUN-680098  smallint
   DEFINE li_result     LIKE type_file.num5         #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 1 LET p_col = 16
 
   OPEN WINDOW r140_w AT p_row,p_col
     WITH FORM "agl/42f/aglr140"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
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
#  LET tm.b = g_bookno      #No.FUN-740020
   LET tm.b = g_aza.aza81      #No.FUN-740020
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
     #NO.FUN-590002-start----
     LET tm.rtype = '1'
     #NO.FUN-590002-end----
 
   WHILE TRUE
 
      LET l_sw = 1
 
#     INPUT BY NAME tm.rtype,tm.a,tm.b,tm.title1,tm.yy1,tm.bm1,tm.em1,tm.title2,
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.title1,tm.yy1,tm.bm1,tm.em1,tm.title2,   #No.FUN-740020
                    tm.yy2,tm.bm2,tm.em2,tm.title3,tm.yy3,tm.bm3,tm.em3,
                    tm.title4,tm.yy4,tm.bm4,tm.em4,tm.e,tm.f,tm.d,tm.acc_code,tm.c,tm.h,  #FUN-B90140   Add tm.acc_code
                    tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
          #No.MOD-510052
         BEFORE FIELD rtype 
            CALL r140_set_entry()  
      
         AFTER FIELD rtype 
            IF tm.rtype='1' THEN
               LET tm.bm1=0
               LET tm.bm2=0
               LET tm.bm3=0
               LET tm.bm4=0
               CALL r140_set_no_entry()
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
               AND mai00 = tm.b     #No.FUN-740020      
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
      
         AFTER FIELD b
            IF tm.b IS NULL THEN 
            NEXT FIELD b 
            END IF
            #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end
               
            
            SELECT aaa02 FROM aaa_file
             WHERE aaa01 = tm.b 
               AND aaaacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b
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
            IF tm.yy3 IS NULL THEN
               LET tm.yy3 = tm.yy1
               LET tm.bm3 = tm.bm1
               LET tm.em3 = 12
               DISPLAY BY NAME tm.yy3,tm.bm3,tm.em3
            END IF
            IF tm.yy4 IS NULL THEN
               LET tm.yy4 = tm.yy1
               LET tm.bm4 = tm.bm1
               LET tm.em4 = 12
               DISPLAY BY NAME tm.yy4,tm.bm4,tm.em4
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
            IF tm.f IS NULL OR tm.f < 0  THEN
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
            SELECT azi01 FROM azi_file 
             WHERE azi01 = tm.p
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
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a 
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
 
             #No.MOD-4C0156 add
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
             #No.MOD-4C0156 end
 
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'aglr140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr140','9031',1)   
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
                       " '",tm.b CLIPPED,"'",
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
                       #-----END TQC-610056-----
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",   #TQC-610056
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr140',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r140()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r140_w
 
END FUNCTION
 
FUNCTION r140()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMEN                #No.FUN-680098 VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1           #No.FUN-680098                  VARCHAR(1)   
   DEFINE amt1,amt2,amt3,amt4 LIKE aah_file.aah04
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1,bal2,bal3,bal4      LIKE aah_file.aah04
                    END RECORD
#No.FUN-780060--start--add
   DEFINE l_tit1       LIKE type_file.chr1000                                                     
   DEFINE l_tit2       LIKE type_file.chr1000                                                              
   DEFINE l_tit3       LIKE type_file.chr1000                                          
   DEFINE l_tit4       LIKE type_file.chr1000 
   DEFINE per1,per2    LIKE fid_file.fid03
#No.FUN-780060--end--
   CALL cl_del_data(l_table)                      #No.FUN-780060
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE
      WHEN tm.rtype = '1'
         LET g_msg = " maj23[1,1]='1'"
      WHEN tm.rtype = '2'
         LET g_msg = " maj23[1,1]='2'"
      OTHERWISE
         LET g_msg = " 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r140_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r140_c CURSOR FOR r140_p
 
   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0 
      LET g_tot2[g_i] = 0
      LET g_tot3[g_i] = 0 
      LET g_tot4[g_i] = 0
   END FOR
 
#   CALL cl_outnam('aglr140') RETURNING l_name       #No.FUN-780060    
#   START REPORT r140_rep TO l_name                  #No.FUN-780060 
 
#   LET g_pageno = 0                                 #No.FUN-780060 
 
   FOREACH r140_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
 
      LET amt1 = 0 
      LET amt2 = 0
      LET amt3 = 0
      LET amt4 = 0
 
      IF NOT cl_null(maj.maj21) THEN
         IF maj.maj24 IS NULL THEN
            SELECT SUM(aah04-aah05) INTO amt1
              FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b      #No.FUN-740020
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy1
               AND aah03 BETWEEN tm.bm1 AND tm.em1
               AND aah01 = aag01
               AND aag07 IN ('2','3')
         ELSE 
            SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020      
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy1
               AND aao04 BETWEEN tm.bm1 AND tm.em1
               AND aao01 = aag01
               AND aag07 IN ('2','3')
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
            SELECT SUM(aah04-aah05) INTO amt2
              FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy2 
               AND aah03 BETWEEN tm.bm2 AND tm.em2
               AND aah01 = aag01
               AND aag07 IN ('2','3')
         ELSE
            SELECT SUM(aao05-aao06) INTO amt2
              FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy2
               AND aao04 BETWEEN tm.bm2 AND tm.em2
               AND aao01 = aag01
               AND aag07 IN ('2','3')
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
            SELECT SUM(aah04-aah05) INTO amt3
              FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy3
               AND aah03 BETWEEN tm.bm3 AND tm.em3
               AND aah01 = aag01
               AND aag07 IN ('2','3')
         ELSE
            SELECT SUM(aao05-aao06) INTO amt3
              FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy3
               AND aao04 BETWEEN tm.bm3 AND tm.em3
               AND aao01 = aag01
               AND aag07 IN ('2','3')
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
            SELECT SUM(aah04-aah05) INTO amt4
              FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy4
               AND aah03 BETWEEN tm.bm4 AND tm.em4
               AND aah01 = aag01
               AND aag07 IN ('2','3')
         ELSE
            SELECT SUM(aao05-aao06) INTO amt4
              FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b     #No.FUN-740020
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy4
               AND aao04 BETWEEN tm.bm4 AND tm.em4
               AND aao01 = aag01
               AND aag07 IN ('2','3')
         END IF
         IF STATUS THEN 
            CALL cl_err('sel aah4:',STATUS,1) 
            EXIT FOREACH
         END IF
         IF amt4 IS NULL THEN
            LET amt4 = 0 
         END IF
      END IF
 
      IF tm.o = 'Y' THEN 
         LET amt1 = amt1 * tm.q 
         LET amt2 = amt2 * tm.q
         LET amt3 = amt3 * tm.q
         LET amt4 = amt4 * tm.q 
      END IF #匯率的轉換

      #TQC-C60121--mark--str-- 
      #TQC-C50091--add--str
      #IF maj.maj07 = '2' THEN
      #   LET amt1 = amt1 * -1
      #   LET amt2 = amt2 * -1
      #   LET amt3 = amt3 * -1
      #   LET amt4 = amt4 * -1
      #END IF
      #TQC-C50091--add--end
      #TQC-C60121--mark--end--
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN      #合計階數處理
         FOR i = 1 TO 100 
            #CHI-A70050---modify---start---
            #LET g_tot1[i] = g_tot1[i] + amt1
            #LET g_tot2[i] = g_tot2[i] + amt2 
            #LET g_tot3[i] = g_tot3[i] + amt3
            #LET g_tot4[i] = g_tot4[i] + amt4 
             IF maj.maj09 = '-' THEN
                LET g_tot1[i] = g_tot1[i] - amt1
                LET g_tot2[i] = g_tot2[i] - amt2 
                LET g_tot3[i] = g_tot3[i] - amt3
                LET g_tot4[i] = g_tot4[i] - amt4 
             ELSE
                LET g_tot1[i] = g_tot1[i] + amt1
                LET g_tot2[i] = g_tot2[i] + amt2 
                LET g_tot3[i] = g_tot3[i] + amt3
                LET g_tot4[i] = g_tot4[i] + amt4 
             END IF
            #CHI-A70050---modify---end---
         END FOR
 
         LET k = maj.maj08  
         LET sr.bal1 = g_tot1[k]
         LET sr.bal2 = g_tot2[k]
         LET sr.bal3 = g_tot3[k]
         LET sr.bal4 = g_tot4[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal2 = sr.bal2 *-1
            LET sr.bal3 = sr.bal3 *-1
            LET sr.bal4 = sr.bal4 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08
            LET g_tot1[i] = 0
            LET g_tot2[i] = 0
            LET g_tot3[i] = 0
            LET g_tot4[i] = 0 
         END FOR
      ELSE 
         IF maj.maj03 = '5' THEN
            LET sr.bal1 = amt1
            LET sr.bal2 = amt2
            LET sr.bal3 = amt3
            LET sr.bal4 = amt4
         ELSE
            LET sr.bal1 = NULL 
            LET sr.bal2 = NULL 
            LET sr.bal3 = NULL 
            LET sr.bal4 = NULL 
         END IF
      END IF
 
      IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
         LET g_basetot1 = sr.bal1
         LET g_basetot2 = sr.bal2
         LET g_basetot3 = sr.bal3
         LET g_basetot4 = sr.bal4
         IF maj.maj07 = '2' THEN 
            LET g_basetot1 = g_basetot1 * -1
            LET g_basetot2 = g_basetot2 * -1
            LET g_basetot3 = g_basetot3 * -1
            LET g_basetot4 = g_basetot4 * -1 
         END IF
      END IF
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH 
      END IF #本行不印出
 
     #IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"   #MOD-8A0211 mark
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"  #MOD-8A0211
         AND sr.bal1 = 0 AND sr.bal2 = 0 AND sr.bal3 = 0 AND sr.bal4 = 0 THEN
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
        END IF 
        #TQC-C50091-mark--end
        #TQC-C60121--unmark--end--
         IF tm.h = 'Y' THEN 
            LET maj.maj20 = maj.maj20e 
         END IF 
         IF sr.bal2 = 0 THEN  #MOD-970205       bal1-->bal2
            LET per1 = 0    
         ELSE  
           #LET per1 = (sr.bal1 - sr.bal2) / sr.bal1 * 100  #MOD-970205                                                             
            LET per1 = (sr.bal1 - sr.bal2) / sr.bal2 * 100  #MOD-970205  
         END IF
         IF sr.bal4 = 0 THEN  #MOD-970205       bal3-->bal4
            LET per2 = 0 
         ELSE    
           #LET per2 = (sr.bal3-sr.bal4) / sr.bal3 * 100 #MOD-970205                                                               
            LET per2 = (sr.bal3-sr.bal4) / sr.bal4 * 100 #MOD-970205  
         END IF 
         IF tm.d MATCHES '[23]' THEN 
            LET sr.bal1 = sr.bal1 / g_unit
            LET sr.bal2 = sr.bal2 / g_unit
            LET sr.bal3 = sr.bal3 / g_unit 
            LET sr.bal4 = sr.bal4 / g_unit
         END IF
         LET maj.maj20 = maj.maj05 SPACES,maj.maj20
         IF maj.maj04=0 THEN 
             EXECUTE insert_prep USING                                                                                                  
                     maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,    #FUN-B90140   Add maj.maj31
                     sr.bal1,sr.bal2,sr.bal3,sr.bal4,per1,per2,
                     '2'
         ELSE 
             EXECUTE insert_prep USING                                                                                                  
                     maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,     #FUN-B90140   Add maj.maj31                                                                      
                     sr.bal1,sr.bal2,sr.bal3,sr.bal4,per1,per2,                                                                           
                     '2' 
             FOR i=1 TO maj.maj04
             EXECUTE insert_prep USING
                     maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,    #FUN-B90140   Add maj.maj31
                     '0','0','0','0','0','0',
                     '1'
             END FOR
         END IF
#No.FUN-780060--end--
#     OUTPUT TO REPORT r140_rep(maj.*, sr.*)             #No.FUN-780060
 
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
 
#  FINISH REPORT r140_rep                                   #No.FUN-780060
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)              #No.FUN-780060
#No.FUN-780060--start--add
   LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',                                                                 
                  '-',tm.em1 USING'&&',")"                                                                                      
   LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',                                                                 
                  '-',tm.em2 USING'&&',")"                                                                                      
   LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',                                                                 
                  '-',tm.em3 USING'&&',")"                                                                                      
   LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',                                                                 
                  '-',tm.em4 USING'&&',")"
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   LET g_str= g_mai02,";",tm.d,";",tm.a,";",tm.p,";",tm.title1,";", 
              tm.title2,";",tm.title3,";",tm.title4,";",l_tit1,";", 
              l_tit2,";",l_tit3,";",l_tit4,";",tm.e   
              ,";",tm.acc_code   #FUN-B90140   Add
   CALL cl_prt_cs3('aglr140','aglr140',g_sql,g_str)
END FUNCTION
#No.FUN-780060--start--mark
{REPORT r140_rep(maj, sr)
   DEFINE l_last_sw   LIKE type_file.chr1       #No.FUN-680098   VARCHAR(1)
   DEFINE l_unit      LIKE zaa_file.zaa08       #No.FUN-680098   VARCHAR(4)
   DEFINE per1,per2   LIKE fid_file.fid03       #No.FUN-680098     dec(8,3)
   DEFINE maj          RECORD LIKE maj_file.* 
   DEFINE sr           RECORD
                          bal1,bal2,bal3,bal4      LIKE aah_file.aah04
                       END RECORD
   DEFINE g_head1      STRING
   DEFINE l_tit1       LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(12)
   DEFINE l_tit2       LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(12)
   DEFINE l_tit3       LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(12)
   DEFINE l_tit4       LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(12)
 
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
              WHEN '1'  LET l_unit = g_x[12]
              WHEN '2'  LET l_unit = g_x[13]
              WHEN '3'  LET l_unit = g_x[14]
              OTHERWISE LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[10] CLIPPED,tm.a,'               ',
                       g_x[15] CLIPPED,tm.p,'     ',
                       g_x[11] CLIPPED,l_unit
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[32],tm.title1 CLIPPED,  #FUN-6C0012
               COLUMN g_c[33],tm.title2 CLIPPED,  #FUN-6C0012
               COLUMN g_c[36],tm.title3 CLIPPED,  #FUN-6C0012
               COLUMN g_c[37],tm.title4 CLIPPED   #FUN-6C0012
         LET l_tit1 = "(",tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',
                      '-',tm.em1 USING'&&',")"
         LET l_tit2 = "(",tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',
                      '-',tm.em2 USING'&&',")"
         LET l_tit3 = "(",tm.yy3 USING '<<<<','/',tm.bm3 USING'&&',
                      '-',tm.em3 USING'&&',")"
         LET l_tit4 = "(",tm.yy4 USING '<<<<','/',tm.bm4 USING'&&',
                      '-',tm.em4 USING'&&',")"
         PRINT COLUMN g_c[32],l_tit1 CLIPPED,  #FUN-6C0012
               COLUMN g_c[33],l_tit2 CLIPPED,  #FUN-6C0012
               COLUMN g_c[36],l_tit3 CLIPPED,  #FUN-6C0012
               COLUMN g_c[37],l_tit4 CLIPPED   #FUN-6C0012
 
         PRINT COLUMN g_c[31],g_dash2[1,g_w[31]],
               COLUMN g_c[32],g_dash2[1,(g_w[32]+g_w[33]+g_w[34]+g_w[35]+3)],
               COLUMN g_c[36],g_dash2[1,(g_w[36]+g_w[37]+g_w[38]+g_w[39]+3)]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39]
         PRINT g_dash1 
         LET l_last_sw = 'n'
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN 
            LET sr.bal1 = sr.bal1 * -1
            LET sr.bal2 = sr.bal2 * -1
            LET sr.bal3 = sr.bal3 * -1
            LET sr.bal4 = sr.bal4 * -1
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
                     COLUMN g_c[39],g_dash2[1,g_w[39]]
            WHEN maj.maj03 = '4'
               PRINT g_dash2
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
               IF sr.bal2 = 0 THEN #MOD-970205       bal1-->bal2
                  LET per1 = 0                       
               ELSE
                 #LET per1 = (sr.bal1 - sr.bal2) / sr.bal1 * 100 #MOD-970205                                                        
                  LET per1 = (sr.bal1 - sr.bal2) / sr.bal2 * 100 #MOD-970205  
               END IF
 
               IF sr.bal4 = 0 THEN #MOD-970205       bal3-->bal4
                  LET per2 = 0                       
               ELSE
                 #LET per2 = (sr.bal3-sr.bal4) / sr.bal3 * 100 #MOD-970205                                                          
                  LET per2 = (sr.bal3-sr.bal4) / sr.bal4 * 100 #MOD-970205   
               END IF
 
               IF tm.d MATCHES '[23]' THEN
                  LET sr.bal1 = sr.bal1 / g_unit
                  LET sr.bal2 = sr.bal2 / g_unit
                  LET sr.bal3 = sr.bal3 / g_unit
                  LET sr.bal4 = sr.bal4 / g_unit
               END IF
 
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               PRINT COLUMN g_c[31],maj.maj20,
                     COLUMN g_c[32],cl_numfor(sr.bal1,32,tm.e),
                     COLUMN g_c[33],cl_numfor(sr.bal2,33,tm.e),
                     COLUMN g_c[34],cl_numfor(sr.bal1-sr.bal2,34,tm.e),
                     COLUMN g_c[35],per1 USING "----&.&&",      
                     COLUMN g_c[36],cl_numfor(sr.bal3,36,tm.e),
                     COLUMN g_c[37],cl_numfor(sr.bal4,37,tm.e),
                     COLUMN g_c[38],cl_numfor(sr.bal3-sr.bal4,38,tm.e),
                     COLUMN g_c[39],per2 USING "----&.&&"       
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
FUNCTION r140_set_entry() 
 
   IF INFIELD(rtype) THEN
      CALL cl_set_comp_entry("bm1,bm2,bm3,bm4",TRUE)
   END IF 
 
END FUNCTION
 
FUNCTION r140_set_no_entry()
 
   IF INFIELD(rtype) AND tm.rtype='1' THEN
      CALL cl_set_comp_entry("bm1,bm2,bm3,bm4",FALSE)
   END IF 
 
END FUNCTION
 #No.MOD-510052 end
