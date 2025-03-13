# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: abgr115.4gl (copy from aglr115)
# Descriptions...: 全年度預算財務報表列印
# Date & Author..: 03/03/17 By Kammy
# Modify.........: No.FUN-510025 05/01/13 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/08 By baogui 報表修改
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.TQC-760001 07/06/01 By Smapmin 修復shell造成的錯誤
# Modify.........: NO.FUN-750025 07/07/24 BY TSD.c123k 改為crystal report
# Modify.........: NO.FUN-810069 08/02/28 By ChenMoyan 去掉budget 增加afc041,afb042
# Modify.........: No.MOD-8C0081 08/12/15 By Sarah 當報表結構設定為貸餘時,在算合計階應以負數計算,但呈現仍為正數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40036 10/04/22 By Summer 相關有使用afb04,afb041,afb042若給予''者,將改為' '
# Modify.........: No:MOD-A40169 10/04/28 By sabrina SQL少串afb_file 
# Modify.........: No:MOD-B70196 11/07/21 By Polly 合計階已做maj09的控制，MOD-8C0081報表結構處理貸餘的部分拿掉
# Modify.........: No:CHI-A20007 10/10/28 By sabrina 欄位抓錯，afb041、afc041才是部門編號
# Modify.........: No:FUN-AB0020 10/11/04 By huangtao 添加預算項目欄位
# Modify.........: No:MOD-AB0241 10/11/26 By Dido 若無部門時不需串 afb_file SUM(afc06)  
# Modify.........: No:FUN-B10020 11/01/13 By huangtao 預算項目可以為空 
# Modify.........: No:MOD-B40223 11/04/25 By Dido 計算合計階段需增加maj09的控制 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-CA0238 12/11/13 By Polly 考量與aglr121共用問題，在寫入temp file前再判斷預算變數若 < 0 時再 * -1
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No.MOD-C70241 13/04/08 By apo 傳入tm.e參數做取位動作
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            rtype  LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(1)
            a      LIKE abh_file.abh05,      #No.FUN-680061 VARCHAR(6)
            b      LIKE aaa_file.aaa01,      #帳別編號   #No.FUN-670039 
            yy     LIKE abk_file.abk03,      #No.FUN-680061 SMALLINT
            bm     LIKE aah_file.aah03,      #No.FUN-680061 SMALLINT   
            em     LIKE aah_file.aah03,      #No.FUN-680061 SMALLINT
            afc01   LIKE afc_file.afc01,         #FUN-AB0020   add by huangtao
#           budget LIKE afa_file.afa01,      #No.FUN-680061 VARCHAR(4)  #No.FUN-810069   
            c      LIKE type_file.chr1,      #異動額及餘額為0者是否列印 #No.FUN-680061 VARCHAR(1)
            d      LIKE type_file.chr1,      #金額單位   #No.FUN-680061 VARCHAR(1)
            e      LIKE azi_file.azi05,      #小數位數   #No.FUN-680061 SMALLINT 
            f      LIKE maj_file.maj08,      #列印最小階數  #No.FUN-680061 SMALLINT
            h      LIKE fan_file.fan02,      #額外說明類別  #No.FUN-680061 VARCHAR(4)
            o      LIKE type_file.chr1,      #轉換幣別否     #No.FUN-680061 VARCHAR(1)
            p      LIKE azi_file.azi01,      #幣別
            q      LIKE azj_file.azj03,      #匯率
            r      LIKE azi_file.azi01,      #幣別
            more   LIKE type_file.chr1       #No.FUN-680061 VARCHAR(1)
           END RECORD,
       bdate,edate LIKE type_file.dat,       #No.FUN-680061 DATE
       i,j,k       LIKE type_file.num5,      #No.FUN-680061 SMALLINT
       g_unit      LIKE type_file.num10,     #No.FUN-680061 INTEGER
       g_bookno    LIKE afc_file.afc00,      #帳別
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_tot       ARRAY[100,12] OF LIKE type_file.num20_6,#No.FUN-680061 DEC(20,6)
       bal         ARRAY[12] OF LIKE type_file.num20_6,    #No.FUN-680061 DEC(20,6)
       g_basetot   ARRAY[12] OF LIKE type_file.num20_6,    #No.FUN-680061 DEC(20,6)
       amt         LIKE type_file.num20_6                  #No.FUN-680061 DEC(20,6)
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose    #No.FUN-680061 SMALLINT
DEFINE g_aaa03     LIKE aaa_file.aaa03
DEFINE g_before_input_done LIKE type_file.num5             #No.FUN-680061  SMALLINT
DEFINE p_cmd       LIKE type_file.chr1       #No.FUN-680061  VARCHAR(1)
DEFINE g_msg       LIKE type_file.chr1000    #No.FUN-680061 VARCHAR(100)
DEFINE g_str       STRING                    # FUN-750025 TSD.c123k
DEFINE l_table     STRING                    # FUN-750025 TSD.c123k
DEFINE g_sql       STRING                    # FUN-750025 TSD.c123k  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
 
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "maj20.maj_file.maj20,maj02.maj_file.maj02,",
               "maj03.maj_file.maj03,g_mai02.mai_file.mai02,",
               "bal01.type_file.num20_6,bal02.type_file.num20_6,",
               "bal03.type_file.num20_6,bal04.type_file.num20_6,",
               "bal05.type_file.num20_6,bal06.type_file.num20_6,",
               "bal07.type_file.num20_6,bal08.type_file.num20_6,",
               "bal09.type_file.num20_6,bal10.type_file.num20_6,",
               "bal11.type_file.num20_6,bal12.type_file.num20_6,",
               "bal13.type_file.num20_6,g_unit.type_file.num10,",
               "g_aaa03.aaa_file.aaa03,line.type_file.num5"
   LET l_table = cl_prt_temptable('abgr115',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750025
 
   LET g_trace  = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
LET tm.a     = ARG_VAL(9)
LET tm.b     = ARG_VAL(10)   #TQC-610054
LET tm.yy    = ARG_VAL(11)
LET tm.em    = ARG_VAL(12)
LET tm.afc01 = ARG_VAL(13)           #FUN-AB0020
#LET tm.budget = ARG_VAL(13)   #TQC-610054 #No.FUN-810069 
LET tm.c     = ARG_VAL(14)
LET tm.d     = ARG_VAL(15)
LET tm.e     = ARG_VAL(16)
LET tm.f     = ARG_VAL(17)
LET tm.h     = ARG_VAL(18)
LET tm.o     = ARG_VAL(19)
LET tm.r     = ARG_VAL(20)   #TQC-610054
LET tm.p     = ARG_VAL(21)
LET tm.q     = ARG_VAL(22)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #No.FUN-740048
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r115_tm()                # Input print condition
      ELSE CALL r115()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r115_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680061 SMALLINT
          l_sw           LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(400)
          li_chk_bookno  LIKE type_file.num5,      #No.FUN-680061 SMALLINT
          li_result      LIKE type_file.num5       #No.FUN-6C0068
 
#  CALL s_dsmark(g_bookno)   #No.FUN-740048
   CALL s_dsmark(tm.b)       #No.FUN-740048
   LET p_row = 4 LET p_col = 11
   OPEN WINDOW r115_w AT p_row,p_col WITH FORM "abg/42f/abgr115"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#  CALL s_shwact(0,0,g_bookno)   #No.FUN-740048
   CALL s_shwact(0,0,tm.b)       #No.FUN-740048
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b = g_aza.aza81    #No.FUN-740048
   #使用預設帳別之幣別
#  SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740048
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b   #No.FUN-740048
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
#     CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105    #No.FUN-740048
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)      #No.FUN-740048
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0) #FUN-660105
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
#  LET tm.b = g_bookno   #No.FUN-740048
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'Y'
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
      INPUT BY NAME tm.b,tm.rtype,tm.a,tm.yy,tm.em,
#                   tm.budget,tm.e,tm.f,           #No.FUN-810069
#                    tm.e,tm.f,                     #No.FUN-810069       #FUN-AB0020  mark
                    tm.afc01,tm.e,tm.f,            #FUN-AB0020
                    tm.d,tm.c,tm.h,tm.o,tm.r,
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS HELP 1
         BEFORE INPUT
         #No.FUN-580031 --start--
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
            LET g_before_input_done = FALSE
            CALL r115_set_entry(p_cmd)
            CALL r115_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         AFTER FIELD a
            #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            #FUN-6C0068--end
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a AND (maiacti = 'Y' OR maiacti = 'y')
               AND mai00 = tm.b    #No.FUN-740048
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0) #FUN-660105 
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
         #No.FUN-660141--begin
            CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF 
            #No.FUN-660141--end
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND (aaaacti = 'Y' OR aaaacti = 'y')
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0) #FUN-660105 
               NEXT FIELD b
            END IF
 
         AFTER FIELD yy
            IF tm.yy = 0 THEN NEXT FIELD yy END IF
 
         AFTER FIELD em
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.em) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.em > 12 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               ELSE
                  IF tm.em > 13 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               END IF
            END IF
#           IF tm.em <1 OR tm.em > 13 THEN
#              CALL cl_err('','agl-013',0) NEXT FIELD em
#           END IF
#No.TQC-720032 -- end --
 
#        AFTER FIELD budget                         #No.FUN-810069
#           SELECT * FROM afa_file WHERE afa01=tm.budget   #No.FUN-810069
#	       AND (afaacti = 'Y' OR afaacti = 'y')   #No.FUN-810069
#              AND afa00 = tm.b     #No.FUN-740048 #No.FUN-810069
#           IF STATUS THEN                          #No.FUN-810069
#              CALL cl_err('sel afa:',STATUS,0) #FUN-660105 
#              CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105 #No.FUN-810069
#              NEXT FIELD budget
#           END IF                #No.FUN-810069

#FUN-AB0020 -------------start------------------------
         AFTER FIELD afc01
            IF NOT cl_null(tm.afc01) THEN            #FUN-B10020
               SELECT * FROM azf_file WHERE azf01 = tm.afc01
                                     AND azfacti = 'Y'
                                     AND azf02 = '2'
               IF STATUS THEN
                  CALL cl_err3("sel","azf_file",tm.afc01,"",STATUS,"","sel afc:",0)
                  NEXT FIELD afc01
               END IF
            END IF                                   #FUN-B10020
#FUN-AB0020 --------------end-------------------------
 
         AFTER FIELD d
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
 
         AFTER FIELD f
            IF tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD o
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
            CALL r115_set_entry(p_cmd)
            CALL r115_set_no_entry(p_cmd)
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN 
#              CALL cl_err(tm.p,'agl-109',0) #FUN-660105
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0) #FUN-660105 
               NEXT FIELD p
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.yy IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy ATTRIBUTE(REVERSE)
               CALL cl_err('',9033,0)
            END IF
            IF tm.em IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.em ATTRIBUTE(REVERSE)
            END IF
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION CONTROLT
            LET g_trace = 'Y'    # Trace on
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_mai"
                  LET g_qryparam.default1 = tm.a
                 #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740048   #No.TQC-C50042   Mark
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY tm.a TO a
                  NEXT FIELD a
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY tm.p TO p
                  NEXT FIELD p
#              WHEN INFIELD(budget)                  #No.FUN-810069
#                 CALL cl_init_qry_var()        #No.FUN-810069
#                 LET g_qryparam.form ="q_afa"  #No.FUN-810069
#                 LET g_qryparam.default1 = tm.budget          #No.FUN-810069
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-810069
#                 CALL cl_create_qry() RETURNING tm.budget     #No.FUN-810069
#                 DISPLAY tm.budget TO budget   #No.FUN-810069
#                 NEXT FIELD budget                  #No.FUN-810069
#FUN-AB0020 --------------start--------------------
               WHEN INFIELD(afc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azf'    
                  LET g_qryparam.default1 = tm.afc01
                  LET g_qryparam.arg1 = '2'        
                  CALL cl_create_qry() RETURNING tm.afc01
                  DISPLAY BY NAME tm.afc01
                  NEXT FIELD afc01
#FUN-AB0020 ---------------end--------------------
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
 
         #-----TQC-740001--------- 
         ON ACTION locale
            CALL cl_dynamic_locale()
         #-----END TQC-740001-----
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r115_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='abgr115'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abgr115','9031',1)
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
                        " '",tm.b CLIPPED,"'",   #TQC-610054
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.em CLIPPED,"'",
                     " '",tm.afc01 CLIPPED,"'",         #FUN-AB0020 
#                    " '",tm.budget CLIPPED,"'",   #TQC-610054     #No.FUN-810069
                     " '",tm.c CLIPPED,"'",
                     " '",tm.d CLIPPED,"'",
                     " '",tm.e CLIPPED,"'",
                     " '",tm.f CLIPPED,"'",
                     " '",tm.h CLIPPED,"'",
                     " '",tm.o CLIPPED,"'",
                     " '",tm.r CLIPPED,"'",   #TQC-610054
                     " '",tm.p CLIPPED,"'",
                     " '",tm.q CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            IF g_trace = 'Y' THEN ERROR l_cmd END IF
            CALL cl_cmdat('abgr115',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r115_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r115()
      ERROR ""
   END WHILE
   CLOSE WINDOW r115_w
END FUNCTION
 
FUNCTION r115()
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061  VARCHAR(20)
#  DEFINE l_time    LIKE type_file.chr8     #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT    #No.FUN-680061 VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061  VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(40)
   DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr  RECORD
               bal01,bal02,bal03,bal04,bal05,bal06,
               bal07,bal08,bal09,bal10,bal11,bal12,
               bal13       LIKE type_file.num20_6 #No.FUN-680061 DEC(20,6)
              END RECORD
 
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ----------------------------------#
   # end FUN-750025
 
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
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   PREPARE r115_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM 
   END IF
   DECLARE r115_c CURSOR FOR r115_p
 
   FOR i=1 TO 100 FOR j=1 TO 12 LET g_tot[i,j] = 0 END FOR END FOR
 
  #CALL cl_outnam('abgr115') RETURNING l_name  #FUN-750025 TSD.c123k mark
  #START REPORT r115_rep TO l_name   #FUN-750025 TSD.c123k mark
   FOREACH r115_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      FOR i = 1 TO 12 LET bal[i]=0 END FOR
      FOR i = 1 TO tm.em
         LET amt = 0
         IF NOT cl_null(maj.maj21) THEN
            IF tm.rtype='1' THEN LET tm.bm=0 ELSE LET tm.bm=i END IF
#FUN-AB0020 --------------start---------------------------
            IF NOT cl_null(tm.afc01) THEN
              IF maj.maj24 IS NULL THEN
                #SELECT SUM(afc06) INTO amt FROM afc_file,afb_file   #MOD-A40169 add afb_file #MOD-AB0241 mark
                 SELECT SUM(afc06) INTO amt FROM afc_file            #MOD-A40169 add afb_file #MOD-AB0241
                  WHERE afc00 = tm.b
                    AND afc01 = tm.afc01
                    AND afc02 BETWEEN maj.maj21 AND maj.maj22
                    AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND i
                   #AND afc041 = afb041 AND afc042 = afb042           #MOD-AB0241 mark 
              ELSE
	         SELECT SUM(afc06) INTO amt FROM afc_file,afb_file
                  WHERE afb00 = afc00  AND afb01 = afc01
                    AND afb02 = afc02  AND afb03 = afc03
                    AND afb04 = afc04
                    AND afc00 = tm.b
                    AND afc01 = tm.afc01
                    AND afc02 BETWEEN maj.maj21 AND maj.maj22
                    AND afc041 BETWEEN maj.maj24 AND maj.maj25      
                    AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND i
                    AND afc041 = afb041 AND afc042 = afb042  
                    AND afb04 = ' ' AND afb042 = ' '          
                    AND afbacti = 'Y'                         #FUN-D70090 add
              END IF
           ELSE  
#FUN-AB0020 --------------------end------------------------------
              IF maj.maj24 IS NULL THEN
                #SELECT SUM(afc06) INTO amt FROM afc_file,afb_file   #MOD-A40169 add afb_file #MOD-AB0241 mark
                 SELECT SUM(afc06) INTO amt FROM afc_file            #MOD-A40169 add afb_file #MOD-AB0241
                  WHERE afc00 = tm.b
#                   AND afc01 = tm.budget     #No.FUN-810069
                    AND afc02 BETWEEN maj.maj21 AND maj.maj22
                    AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND i
                   #AND afc041 = afb041 AND afc042 = afb042 #No.FUN-810069    #MOD-AB0241 mark 
                   #AND afc04 = '@'  #整體預算            #CHI-A20007 mark
              ELSE
	         SELECT SUM(afc06) INTO amt FROM afc_file,afb_file
                  WHERE afb00 = afc00  AND afb01 = afc01
                    AND afb02 = afc02  AND afb03 = afc03
                    AND afb04 = afc04
                   #AND afb15 = '2'           #部門預算          #CHI-A20007 mark
                    AND afc00 = tm.b
#                   AND afc01 = tm.budget     #No.FUN-810069 
                    AND afc02 BETWEEN maj.maj21 AND maj.maj22
                   #AND afc04 BETWEEN maj.maj24 AND maj.maj25        #CHI-A20007 mark
                    AND afc041 BETWEEN maj.maj24 AND maj.maj25       #CHI-A20007 add
                    AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND i
                    AND afc041 = afb041 AND afc042 = afb042   #No.FUN-810069
                   #AND afb041 = ' ' AND afb042 = ' '         #No.FUN-810069 #CHI-A40036 mod ' ' #CHI-A20007 mark
                    AND afb04 = ' ' AND afb042 = ' '          #CHI-A20007 add   
                    AND afbacti = 'Y'                         #FUN-D70090 add
              END IF
           END IF                                  #FUN-AB0020
            IF STATUS THEN 
#           CALL cl_err('sel afc1:',STATUS,1) #FUN-660105
#           CALL cl_err3("sel","afc1_file",tm.b,tm.budget,STATUS,"","sel afc1:",1) #FUN-660105 #No.FUN-810069 
            CALL cl_err3("sel","afc1_file",tm.b,'',STATUS,"","sel afc1:",1)        #No.FUN-810069
            EXIT FOREACH END IF
            IF amt IS NULL THEN LET amt = 0 END IF
         END IF
         IF tm.o = 'Y' THEN LET amt = amt * tm.q END IF #匯率的轉換
         IF maj.maj07='2' THEN LET amt = amt * -1 END IF        #MOD-8C0081 add     #No.MOD-B70196 mark #MOD-CA0238 remark
         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN	#合計階數處理
           #FOR j=1 TO 100 LET g_tot[j,i]=g_tot[j,i]+amt END FOR #MOD-B40223 mark
           #-MOD-B40223-add-
            FOR j=1 TO 100 
               IF maj.maj09 = '-' THEN
                  LET g_tot[j,i]=g_tot[j,i]-amt 
               ELSE
                  LET g_tot[j,i]=g_tot[j,i]+amt 
               END IF
            END FOR
           #-MOD-B40223-end-
            LET k=maj.maj08  LET bal[i]=g_tot[k,i]
           #-MOD-B40223-add-
            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
               LET bal[i] = bal[i] *-1
            END IF
           #-MOD-B40223-end-
            FOR j = 1 TO maj.maj08 LET g_tot[j,i]=0 END FOR
         ELSE
            IF maj.maj03='5' THEN
               LET bal[i]=amt
            ELSE
               LET bal[i]=0
            END IF
         END IF
         IF maj.maj11 = 'Y' THEN			# 百分比基準科目
            LET g_basetot[i]=bal[i]
            IF maj.maj07='2' THEN LET g_basetot[i]=g_basetot[i]*-1 END IF
            IF g_basetot[i] = 0 THEN LET g_basetot[i] = NULL END IF
         END IF
         IF maj.maj08 = 0 THEN LET bal[i]=NULL END IF
      END FOR
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" AND          #CHI-CC0023 add maj03 match 5
         bal[1]=0 AND bal[2]=0  AND bal[3]=0  AND bal[4]=0  AND
         bal[5]=0 AND bal[6]=0  AND bal[7]=0  AND bal[8]=0  AND
         bal[9]=0 AND bal[10]=0 AND bal[11]=0 AND bal[12]=0 THEN
         CONTINUE FOREACH				#餘額為 0 者不列印
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH				#最小階數起列印
      END IF
      LET sr.bal13=bal[1]+bal[2]+bal[3]+bal[4]+bal[5]+bal[6]+
                   bal[7]+bal[8]+bal[9]+bal[10]+bal[11]+bal[12]
      IF tm.rtype='1' THEN LET sr.bal13=NULL END IF
      FOR i = tm.em+1 TO 12 LET bal[i]= NULL END FOR
      LET sr.bal01=bal[1]
      LET sr.bal02=bal[2]
      LET sr.bal03=bal[3]
      LET sr.bal04=bal[4]
      LET sr.bal05=bal[5]
      LET sr.bal06=bal[6]
      LET sr.bal07=bal[7]
      LET sr.bal08=bal[8]
      LET sr.bal09=bal[9]
      LET sr.bal10=bal[10]
      LET sr.bal11=bal[11]
      LET sr.bal12=bal[12]
 
     #FUN-750025 TSD.c123k add
     #------------------MOD-CA0238---------------------(S)
     #--MOD-CA0238--mark
     #IF maj.maj07='2' THEN
     #   LET sr.bal01=sr.bal01*-1 LET sr.bal02=sr.bal02*-1
     #   LET sr.bal03=sr.bal03*-1 LET sr.bal04=sr.bal04*-1
     #   LET sr.bal05=sr.bal05*-1 LET sr.bal06=sr.bal06*-1
     #   LET sr.bal07=sr.bal07*-1 LET sr.bal08=sr.bal08*-1
     #   LET sr.bal09=sr.bal09*-1 LET sr.bal10=sr.bal10*-1
     #   LET sr.bal11=sr.bal11*-1 LET sr.bal12=sr.bal12*-1
     #   LET sr.bal13=sr.bal13*-1
     #END IF
     #--MOD-CA0238--mark
      IF sr.bal01 < 0 THEN
         LET sr.bal01 = sr.bal01 * -1
      END IF
      IF sr.bal02 < 0 THEN
         LET sr.bal02 = sr.bal02 * -1
      END IF
      IF sr.bal03 < 0 THEN
         LET sr.bal03 = sr.bal03 * -1
      END IF
      IF sr.bal04 < 0 THEN
         LET sr.bal04 = sr.bal04 * -1
      END IF
      IF sr.bal05 < 0 THEN
         LET sr.bal05 = sr.bal05 * -1
      END IF
      IF sr.bal06 < 0 THEN
         LET sr.bal06 = sr.bal06 * -1
      END IF
      IF sr.bal07 < 0 THEN
         LET sr.bal07 = sr.bal07 * -1
      END IF
      IF sr.bal08 < 0 THEN
         LET sr.bal08 = sr.bal08 * -1
      END IF
      IF sr.bal09 < 0 THEN
         LET sr.bal09 = sr.bal09 * -1
      END IF
      IF sr.bal10 < 0 THEN
         LET sr.bal10 = sr.bal10 * -1
      END IF
      IF sr.bal11 < 0 THEN
         LET sr.bal11 = sr.bal11 * -1
      END IF
      IF sr.bal12 < 0 THEN
         LET sr.bal12 = sr.bal12 * -1
      END IF
      IF sr.bal13 < 0 THEN
         LET sr.bal13 = sr.bal13 * -1
      END IF
     #------------------MOD-CA0238---------------------(E)
 
      IF tm.h='Y' THEN LET maj.maj20 = maj.maj20e END IF
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
 
      IF maj.maj03 <> '9' AND maj.maj03 <> '3' AND maj.maj03 <> '4' THEN
         LET sr.bal01 = sr.bal01 / g_unit
         LET sr.bal02 = sr.bal02 / g_unit
         LET sr.bal03 = sr.bal03 / g_unit
         LET sr.bal04 = sr.bal04 / g_unit
         LET sr.bal05 = sr.bal05 / g_unit
         LET sr.bal06 = sr.bal06 / g_unit
         LET sr.bal07 = sr.bal07 / g_unit
         LET sr.bal08 = sr.bal08 / g_unit
         LET sr.bal09 = sr.bal09 / g_unit
         LET sr.bal10 = sr.bal10 / g_unit
         LET sr.bal11 = sr.bal11 / g_unit
         LET sr.bal12 = sr.bal12 / g_unit
         LET sr.bal13 = sr.bal13 / g_unit
      END IF
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      IF maj.maj04 = 0 THEN
         EXECUTE insert_prep USING
            maj.maj20, maj.maj02, maj.maj03,  g_mai02,    sr.bal01,
            sr.bal02,  sr.bal03,  sr.bal04,   sr.bal05,   sr.bal06,
            sr.bal07,  sr.bal08,  sr.bal09,   sr.bal10,   sr.bal11,
            sr.bal12,  sr.bal13,  g_unit,     g_aaa03,    '2'
      ELSE
         EXECUTE insert_prep USING
            maj.maj20, maj.maj02, maj.maj03,  g_mai02,    sr.bal01,
            sr.bal02,  sr.bal03,  sr.bal04,   sr.bal05,   sr.bal06,
            sr.bal07,  sr.bal08,  sr.bal09,   sr.bal10,   sr.bal11,
            sr.bal12,  sr.bal13,  g_unit,     g_aaa03,    '2'
 
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
             EXECUTE insert_prep USING
               maj.maj20,maj.maj02,'',g_mai02,'0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0','','1'
         END FOR
      END IF
      #------------------------------ CR (3) ------------------------------#
      #FUN-750025 TSD.c123k end
   END FOREACH
 
  #FINISH REPORT r115_rep  #FUN-750025 TSD.c123k mark
 
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-750025 TSD.c123k mark
 
   # FUN-750025 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      #CALL cl_wcchp(tm.wc,'occ01,occ20,occ03,occ21')
      #     RETURNING tm.wc
      #LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.d,";",tm.a,";",tm.p,";",tm.yy,";",
               tm.rtype,";",tm.h,";",tm.e                             #MOD-C70241 add tm.e
   CALL cl_prt_cs3('abgr115','abgr115',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   # FUN-750025 end
END FUNCTION
 
FUNCTION r115_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680061  VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("p,q",TRUE)
#   END IF
 
END FUNCTION
 
FUNCTION r115_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
 
    IF tm.o = 'N' THEN
       CALL cl_set_comp_entry("p,q",FALSE)
    END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#TQC-760001
