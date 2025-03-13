# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg225.4gl
# Descriptions...: 兩期比較異動碼財務報表列印
# Date & Author..: 95/10/10 By Nora
# Modify.........: By Melody    3.0 版報表結構檔案修改, 程式改寫
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/03 By Nicola 報表架構修改
# Modify.........: No.FUN-5C0015 06/01/05 變數tm.x放大至c(30)
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加判斷使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: No.FUN-780061 07/08/29 By zhoufeng 報表輸出改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70046 10/08/11 By Summer 百分比需依金額單位顯示
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No.FUN-B80158 11/09/01 By yangtt 明細類CR轉換成GRW
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1,  #報表結構編號  #No.FUN-680098   VARCHAR(1)
                 a      LIKE mai_file.mai01,  #報表結構編號  #No.FUN-680098   VARCHAR(6)
                 b      LIKE aaa_file.aaa01,  #帳別編號      #No.FUN-670039
                # FUN-5C0015 mod (s)
                #x      VARCHAR(20),             #帳別編號
                 x      LIKE aed_file.aed02,  #帳別編號     #No.FUN-680098   VARCHAR(20)  
                # FUN-5C0015 mod (e)
                 title1  LIKE type_file.chr8,               #輸入期別名稱 #No.FUN-680098   VARCHAR(8)  
                 yy1     LIKE aed_file.aed03,               #輸入年度     #No.FUN-680098   smallint
                 bm1     LIKE aed_file.aed04,               #Begin 期別   #No.FUN-680098   smallint
                 em1     LIKE aed_file.aed04,               # End  期別   #No.FUN-680098   smallint
                 title2  LIKE type_file.chr8,               #輸入期別名稱 #No.FUN-680098   VARCHAR(1)  
                 yy2     LIKE aed_file.aed03,               #輸入年度     #No.FUN-680098   smallint
                 bm2     LIKE aed_file.aed04,               #Begin 期別   #No.FUN-680098   smallint  
                 em2     LIKE aed_file.aed04,               # End  期別   #No.FUN-680098   smallint   
                 c       LIKE type_file.chr1,               #異動額及餘額為0者是否列印 #No.FUN-680098   VARCHAR(1)  
                 d       LIKE type_file.chr1,               #金額單位     #No.FUN-680098   VARCHAR(1)  
                 e       LIKE type_file.num5,               #小數位數     #No.FUN-680098   smallint
                 f       LIKE type_file.num5,               #列印最小階數 #No.FUN-680098   smallint
                 h       LIKE type_file.chr4,               #額外說明類別 #No.FUN-680098   VARCHAR(4)  
                 o       LIKE type_file.chr1,               #轉換幣別否   #No.FUN-680098   VARCHAR(1)  
                 p       LIKE azi_file.azi01,  #幣別
                 q       LIKE azj_file.azj03,  #匯率
                 r       LIKE azi_file.azi01,  #幣別
                 more    LIKE type_file.chr1                #Input more condition(Y/N) #No.FUN-680098   VARCHAR(1)  
              END RECORD,
          bdate,edate      LIKE type_file.dat,           #No.FUN-680098  date
          i,j,k            LIKE type_file.num5,          #No.FUN-680098  smallint
          g_unit           LIKE type_file.num5,          #金額單位基數 #No.FUN-680098   smallint
          g_bookno         LIKE aed_file.aed00,          #帳別
          g_mai02          LIKE mai_file.mai02,
          g_mai03          LIKE mai_file.mai03,
          g_tot1           ARRAY[100] OF  LIKE type_file.num20_6,   #No.FUN-680098   dec(20,6)
          g_tot2           ARRAY[100] OF  LIKE type_file.num20_6,   #No.FUN-680098   dec(20,6)
          g_basetot1       LIKE aed_file.aed05,
          g_basetot2       LIKE aed_file.aed05
   DEFINE g_aaa03          LIKE aaa_file.aaa03   
   DEFINE g_i              LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098 smallint
   DEFINE g_msg            LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(72)  
   DEFINE g_sql            STRING                  #No.FUN-780061
   DEFINE g_str            STRING                  #No.FUN-780061
   DEFINE l_table          STRING                  #No.FUN-780061
 
###GENGRE###START
TYPE sr1_t RECORD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal1 LIKE aed_file.aed05,
    bal2 LIKE aed_file.aed05,
    per1 LIKE fid_file.fid03,
    per2 LIKE fid_file.fid03,
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
 
   #No.FUN-780061 --start--
   LET g_sql="maj20.maj_file.maj20,maj20e.maj_file.maj20e,",
             "maj02.maj_file.maj02,maj03.maj_file.maj03,bal1.aed_file.aed05,",
             "bal2.aed_file.aed05,per1.fid_file.fid03,per2.fid_file.fid03,",
             "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglg225',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   #No.FUN-780061 --end--
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.x  = ARG_VAL(10)
   LET tm.yy1 = ARG_VAL(11)
   LET tm.title1 = ARG_VAL(12)   #TQC-610056
   LET tm.yy1 = ARG_VAL(13)   #TQC-610056
   LET tm.bm1 = ARG_VAL(14)
   LET tm.em1 = ARG_VAL(15)
   LET tm.title2 = ARG_VAL(16)   #TQC-610056
   LET tm.yy2 = ARG_VAL(17)   #TQC-610056
   LET tm.bm2 = ARG_VAL(18)   #TQC-610056
   LET tm.em2 = ARG_VAL(19)   #TQC-610056
   LET tm.c  = ARG_VAL(20)
   LET tm.d  = ARG_VAL(21)
   LET tm.e  = ARG_VAL(22)
   LET tm.f  = ARG_VAL(23)
   LET tm.h  = ARG_VAL(24)
   LET tm.o  = ARG_VAL(25)
   LET tm.p  = ARG_VAL(26)
   LET tm.q  = ARG_VAL(27)
   LET tm.r  = ARG_VAL(28)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(29)
   LET g_rep_clas = ARG_VAL(30)
   LET g_template = ARG_VAL(31)
   LET g_rpt_name = ARG_VAL(32)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bookno) THEN 
      LET g_bookno = g_aza.aza81    #No.FUN-740020
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g225_tm() 
   ELSE
      CALL g225()    
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION g225_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,     #No.FUN-680098    smallint
          l_sw         LIKE type_file.chr1,     #重要欄位是否空白 #No.FUN-680098   VARCHAR(1)  
          l_cmd        LIKE type_file.chr1000   #No.FUN-680098    VARCHAR(400)  
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670005   #No.FUN-680098    smallint
   DEFINE li_result    LIKE type_file.num5      #No.FUN-6C0068  
   CALL s_dsmark(g_bookno)
   LET p_row = 1 LET p_col = 14
   OPEN WINDOW g225_w AT p_row,p_col
     WITH FORM "agl/42f/aglg225"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
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
   LET tm.b = g_bookno
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
 
      LET l_sw = 1
   
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.x,tm.title1,tm.yy1,tm.bm1,tm.em1,     #No.FUN-740020
                    tm.title2,tm.yy2,tm.bm2,tm.em2,tm.e,tm.f,tm.d,tm.c,tm.h,
                    tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
   
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
               AND mai00 = tm.b          #No.FUN-740020
               AND maiacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0)    #No.FUN-660123
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
#              CALL cl_err('sel aaa:',STATUS,0)    #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b
            END IF
   
         AFTER FIELD x
            IF tm.x IS NULL THEN
               NEXT FIELD x
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
            IF tm.rtype = '1' THEN
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
#            IF tm.bm1 < 1 OR tm.bm1 > 13 THEN
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
#            IF tm.em1 < 1 OR tm.em1 > 13 THEN
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
   
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
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
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"     #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
             #No.MOD-4C0156 add
            IF  INFIELD(b) THEN
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
   
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g225_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg225'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg225','9031',1)   
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
                        " '",tm.x CLIPPED,"'",   #TQC-610056
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
            CALL cl_cmdat('aglg225',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g225_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g225()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g225_w
 
END FUNCTION
 
FUNCTION g225()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098 VARCHAR(20)  
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT                 #No.FUN-680098char(1000)  
   DEFINE l_chr     LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)  
   DEFINE amt1,amt2 LIKE aed_file.aed05
   DEFINE l_tmp     LIKE aed_file.aed05
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1,bal2      LIKE aed_file.aed05
                    END RECORD
   DEFINE per1,per2 LIKE fid_file.fid03           #No.FUN-780061
   DEFINE l_tit1    LIKE type_file.chr1000        #No.FUN-780061
   DEFINE l_tit2    LIKE type_file.chr1000        #No.FUN-780061
 
   CALL cl_del_data(l_table)                      #No.FUN-780061
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g225_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE g225_c CURSOR FOR g225_p
 
   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0
      LET g_tot2[g_i] = 0 
   END FOR
 
#   CALL cl_outnam('aglg225') RETURNING l_name       #No.FUN-780061
#   START REPORT g225_rep TO l_name                  #No.FUN-780061
   FOREACH g225_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
 
      LET amt1 = 0 
      LET amt2 = 0
 
      IF NOT cl_null(maj.maj21) THEN
         SELECT SUM(aed05-aed06) INTO amt1
           FROM aed_file,aag_file
          WHERE aed00 = tm.b
            AND aed01 BETWEEN maj.maj21 AND maj.maj22
            AND aed03 = tm.yy1
            AND aed04 BETWEEN tm.bm1 AND tm.em1
            AND aed01 = aag01
            AND aed00 = aag00                               #No.FUN-740020
            AND aag07 IN ('2','3')
            AND aed02 = tm.x
         IF STATUS THEN
#           CALL cl_err('sel aed1:',STATUS,1)    #No.FUN-660123
            CALL cl_err3("sel","aed_file,aag_file",tm.b,tm.yy1,STATUS,"","sel aed1:",1)   #No.FUN-660123
            EXIT FOREACH 
         END IF
         IF amt1 IS NULL THEN
            LET amt1 = 0 
         END IF
      END IF
 
      IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
         SELECT SUM(aed05-aed06) INTO amt2
           FROM aed_file,aag_file
          WHERE aed00 = tm.b
            AND aed01 BETWEEN maj.maj21 AND maj.maj22
            AND aed03 = tm.yy2
            AND aed04 BETWEEN tm.bm2 AND tm.em2
            AND aed01 = aag01
            AND aed00 = aag00       #No.FUN-740020
            AND aag07 IN ('2','3')
            AND aed02 = tm.x
         IF STATUS THEN 
#           CALL cl_err('sel aed2:',STATUS,1)    #No.FUN-660123
            CALL cl_err3("sel","amt2",tm.b,tm.yy2,STATUS,"","sel aed2:",1)   #No.FUN-660123
            EXIT FOREACH 
         END IF
         IF amt2 IS NULL THEN
            LET amt2 = 0 
         END IF
      END IF
 
      IF tm.o = 'Y' THEN
         LET amt1 = amt1 * tm.q
         LET amt2 = amt2 * tm.q 
      END IF #匯率的轉換
 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN     #合計階數處理
         FOR i = 1 TO 100
            #CHI-A70050---modify---start---
            #LET g_tot1[i] = g_tot1[i] + amt1
            #LET g_tot2[i] = g_tot2[i] + amt2
             IF maj.maj09 = '-' THEN
                LET g_tot1[i] = g_tot1[i] - amt1
                LET g_tot2[i] = g_tot2[i] - amt2
             ELSE
                LET g_tot1[i] = g_tot1[i] + amt1
                LET g_tot2[i] = g_tot2[i] + amt2
             END IF
            #CHI-A70050---modify---end---
         END FOR
 
         LET k = maj.maj08
         LET sr.bal1 = g_tot1[k]
         LET sr.bal2 = g_tot2[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal2 = sr.bal2 *-1
         END IF
        #CHI-A70050---add---end---
 
         FOR i = 1 TO maj.maj08
             LET g_tot1[i] = 0
             LET g_tot2[i] = 0
         END FOR
      ELSE 
         IF maj.maj03='5' THEN
            LET sr.bal1=amt1
            LET sr.bal2=amt2
         ELSE
            LET sr.bal1=NULL 
            LET sr.bal2=NULL 
         END IF
      END IF
 
      IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
         LET g_basetot1 = sr.bal1
         LET g_basetot2 = sr.bal2
         IF maj.maj07='2' THEN
            LET g_basetot1 = g_basetot1 * -1
            LET g_basetot2 = g_basetot2 * -1
         END IF
         LET g_basetot1=g_basetot1/g_unit #CHI-A70046 add
         LET g_basetot2=g_basetot2/g_unit #CHI-A70046 add
      END IF
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH 
      END IF #本行不印出
 
      IF (tm.c = 'N' OR maj.maj03 = '2') AND maj.maj03 MATCHES "[0125]"                #CHI-CC0023 add maj03 match 5
         AND sr.bal1 = 0 AND sr.bal2 = 0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
 
      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
 
#      OUTPUT TO REPORT g225_rep(maj.*, sr.*)    #No.FUN-780061
      #No.FUN-780061 --start--
      IF maj.maj07 = '2' THEN 
         LET sr.bal1 = sr.bal1 * -1
         LET sr.bal2 = sr.bal2 * -1
      END IF
 
      IF tm.h = 'Y' THEN 
         LET maj.maj20 = maj.maj20e
      END IF
      
      LET per1 = (sr.bal1 / g_basetot1) * 100
      LET per2 = (sr.bal2 / g_basetot2) * 100

      LET sr.bal1 = sr.bal1 / g_unit #CHI-A70046 add
      LET sr.bal2 = sr.bal2 / g_unit #CHI-A70046 add
 
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
      IF maj.maj04 = 0 THEN
         EXECUTE insert_prep USING maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                                   sr.bal1,sr.bal2,per1,per2,'2'
      ELSE
         EXECUTE insert_prep USING maj.maj20,maj.maj20e,maj.maj02,maj.maj03,    
                                   sr.bal1,sr.bal2,per1,per2,'2'
         FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING maj.maj20,maj.maj20e,maj.maj02,'',
                                      '0','0','0','0','1'
         END FOR
      END IF
      #No.FUN-780061 --end--
 
   END FOREACH
 
   IF g_basetot1 = 0 THEN
      LET g_basetot1 = NULL
   END IF
 
   IF g_basetot2 = 0 THEN 
      LET g_basetot2 = NULL
   END IF
 
#   FINISH REPORT g225_rep                       #No.FUN-780061
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-780061
   #No.FUN-780061 --start--
   LET l_tit1 = tm.yy1 USING '<<<<','/',tm.bm1 USING'&&','-',tm.em1 USING'&&'
   LET l_tit2 = tm.yy2 USING '<<<<','/',tm.bm2 USING'&&','-',tm.em2 USING'&&'
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.x,";",
###GENGRE###               tm.title1,";",tm.title2,";",l_tit1,";",l_tit2,";",tm.e,";",g_basetot1,";",g_basetot2  #CHI-A70046 add g_basetot1,g_basetot2
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   CALL cl_prt_cs3('aglg225','aglg225',l_sql,g_str)
    CALL aglg225_grdata()    ###GENGRE###
   #No.FUN-780061 --end--
 
END FUNCTION
#No.FUN-780061 --start-- mark
{REPORT g225_rep(maj, sr)
   DEFINE l_last_sw    LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)  
   DEFINE l_unit       LIKE zaa_file.zaa08      #No.FUN-680098   chr(4)
   DEFINE per1,per2    LIKE fid_file.fid03      #No.FUN-680098   dec(8,3)
   DEFINE maj          RECORD LIKE maj_file.*
   DEFINE sr           RECORD
                          bal1,bal2      LIKE aed_file.aed05
                       END RECORD
   DEFINE g_head1      STRING
   DEFINE l_tit1       LIKE type_file.chr20      #No.FUN-680098   VARCHAR(12)  
   DEFINE l_tit2       LIKE type_file.chr20      #No.FUN-680098   VARCHAR(12)   
 
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
         LET g_head1 = g_x[15] CLIPPED,tm.x
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[32],tm.title1,
               COLUMN g_c[34],tm.title2
         LET l_tit1 = tm.yy1 USING '<<<<','/',tm.bm1 USING'&&',
                      '-',tm.em1 USING'&&'
         LET l_tit2 = tm.yy2 USING '<<<<','/',tm.bm2 USING'&&',
                      '-',tm.em2 USING'&&'
         PRINT COLUMN g_c[32],l_tit1,
               COLUMN g_c[34],l_tit2
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
         PRINT g_dash1 
         LET l_last_sw = 'n'
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN 
            LET sr.bal1 = sr.bal1 * -1
            LET sr.bal2 = sr.bal2 * -1
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
                     COLUMN g_c[35],g_dash2[1,g_w[35]]
            WHEN maj.maj03 = '4'
               PRINT g_dash2
            OTHERWISE
               FOR i = 1 TO maj.maj04
                  PRINT
               END FOR
               LET per1 = (sr.bal1 / g_basetot1) * 100
               LET per2 = (sr.bal2 / g_basetot2) * 100
 
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20
               PRINT COLUMN g_c[31],maj.maj20,
                     COLUMN g_c[32],cl_numfor(sr.bal1/g_unit,32,tm.e),
                     COLUMN g_c[33],per1 USING '----&.&&',
                     COLUMN g_c[34],cl_numfor(sr.bal2/g_unit,34,tm.e),
                     COLUMN g_c[35],per2 USING '----&.&&'
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
#No.FUN-780061 --end--

###GENGRE###START
FUNCTION aglg225_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg225")
        IF handler IS NOT NULL THEN
            START REPORT aglg225_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg225_datacur1 CURSOR FROM l_sql
            FOREACH aglg225_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg225_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg225_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg225_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158--------add----str------
    DEFINE l_per1       LIKE fid_file.fid03
    DEFINE l_per2       LIKE fid_file.fid03
    DEFINE l_unit       STRING
    DEFINE l_bal1_fmt   STRING
    DEFINE l_bal2_fmt   STRING
    DEFINE l_tit1       LIKE type_file.chr1000  
    DEFINE l_tit2       LIKE type_file.chr1000 
    DEFINE l_title2      STRING
    #FUN-B80158--------add----end------
    
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158--------add----str------
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit
            LET l_tit1 = tm.yy1 USING '<<<<','/',tm.bm1 USING'&&','-',tm.em1 USING'&&'
            LET l_tit2 = tm.yy2 USING '<<<<','/',tm.bm2 USING'&&','-',tm.em2 USING'&&'
            PRINTX l_tit1
            PRINTX l_tit2
            IF g_aaz.aaz77 = 'Y' THEN
               LET l_title2 = g_mai02
            ELSE
               LET l_title2 = g_grPageHeader.title2
            END IF
            PRINTX l_title2
            #FUN-B80158--------add----end------
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158--------add----str------
            IF g_basetot1 != "" THEN
               LET l_per1 = sr1.bal1 / g_basetot1
            ELSE
               LET l_per1 = ""
            END IF
            PRINTX l_per1

            IF g_basetot2 != "" THEN
               LET l_per2 = sr1.bal2 / g_basetot2
            ELSE
               LET l_per2 = ""
            END IF
            PRINTX l_per2
            
            LET l_bal1_fmt = cl_gr_numfmt("aed_file","aed05",tm.e)
            PRINTX l_bal1_fmt
            LET l_bal2_fmt = cl_gr_numfmt("aed_file","aed05",tm.e)
            PRINTX l_bal2_fmt
            #FUN-B80158--------add----end------

            PRINTX sr1.*

        
        ON LAST ROW

END REPORT
###GENGRE###END
