# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr110.4gl (copy from aglr110)
# Descriptions...: 當期預算財務報表列印
# Date & Author..: 03/03/14 By Kammy
# Modify.........: No.FUN-510025 05/01/13 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-540147 05/05/06 By ching fix正負號問題
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/08 By baogui  表名名稱未置中
# Modify.........: No.FUN-6C0068 07/01/08 By rainy 報表結構檢查使用者設限及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730033 07/03/20 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740001 07/04/02 By Smapmin 增加語言別轉換功能
# Modify.........: No.FUN-740048 07/04/12 By johnray 會計科目加帳套
# Modify.........: No.TQC-770061 07/07/11 By Carrier 去掉maj00的條件
# Modify.........: NO.FUN-750025 07/07/20 BY TSD.pinky 改為crystal report
# Modify.........: NO.FUN-810069 08/02/28 By destiny 取消預算編號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40063 10/05/04 By Summer 正負號相反問題
# Modify.........: NO:CHI-A20007 10/02/06 By sabrina afc04='@'要mark，不然金額會有問題, afc041才是部門編號
# Modify.........: No:FUN-AB0020 10/11/04 By huangtao 添加預算項目欄位
# Modify.........: No:FUN-B10020 11/01/13 By huangtao 預算項目可以為空 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-C60129 12/06/14 By Polly 金額加總增加挪用與追加部分
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,     #No.FUN-680061  VARCHAR(1)
              a       LIKE maj_file.maj01,     #報表結構編號 #No.FUN-680061  VARCHAR(6)                                                                  
              b       LIKE aaa_file.aaa01,     #帳別編號  #No.FUN-670039                                               
              yy      LIKE abk_file.abk03,     #輸入年度  #No.FUN-680061   SMALLINT                                                             
              bm      LIKE aah_file.aah03,     #Begin 期別   #No.FUN-680061 SMALLINT                                                           
              em      LIKE aah_file.aah03,     # End  期別   #No.FUN-680061 SMALLINT 
             #budget  LIKE afa_file.afa01,     #預算編號     #No.FUN-680061 VARCHAR(4)    #FUN-810069--mark 
              afc01   LIKE afc_file.afc01,         #FUN-AB0020   add by huangtao             
              c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印   #No.FUN-680061  VARCHAR(1)                                                          
              d       LIKE type_file.chr1,     #金額單位     #No.FUN-680061   VARCHAR(1)                                                                       
              f       LIKE maj_file.maj08,     #列印最小階數    #No.FUN-680061   SMALLINT                                                                    
              more    LIKE type_file.chr1,     #No.FUN-680061   VARCHAR(01)
              e   LIKE azi_file.azi05,    #小數位數   #No.FUN-680061    SMALLINT
              h   LIKE fan_file.fan02,    #額外說明類別   #No.FUN-680061   VARCHAR(04)
              o   LIKE type_file.chr1,    #轉換幣別否   #No.FUN-680061   VARCHAR(01)
              p   LIKE azi_file.azi01,    #幣別
              q   LIKE azj_file.azj03,    #匯率
              r   LIKE azi_file.azi01     #幣別
              END RECORD,
          bdate,edate     LIKE type_file.dat,      #No.FUN-680061  DATE
          i,j,k,g_mm      LIKE type_file.num5,     #No.FUN-680061  SMALLINT
          g_unit    LIKE type_file.num10,          #No.FUN-680061   INTEGER
          g_bookno  LIKE aah_file.aah00,           #帳別
          g_mai02   LIKE mai_file.mai02,
          g_mai03   LIKE mai_file.mai03,
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680061  ARRAY[100] OF DEC(20,6)
          g_basetot1 LIKE type_file.num20_6               #No.FUN-680061  DEC(20,6)
DEFINE   g_i         LIKE type_file.num5                  #count/index for any purpose   #No.FUN-680061 SAMLLINT
DEFINE   g_aaa03     LIKE  aaa_file.aaa03 
DEFINE   g_before_input_done  LIKE type_file.num5         #No.FUN-680061 SAMLLINT
DEFINE   g_msg       LIKE type_file.chr1000               #No.FUN-680061  VARCHAR(100)
DEFINE   p_cmd       LIKE type_file.chr1                  #No.FUN-680061  VARCHAR(1)
DEFINE   g_str         STRING          # FUN-750025 TSD.pinky
DEFINE   l_table       STRING          # FUN-750025 TSD.pinky
DEFINE   g_sql         STRING          # FUN-750025
 
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
   #str FUN-750025 add
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "maj20.maj_file.maj20,",
              "maj20e.maj_file.maj20e,",
              "maj02.maj_file.maj02,",   #項次(排序要用的)
              "maj03.maj_file.maj03,",   #列印碼
              "bal1.type_file.num20_6,",
              "line.type_file.num5,",      #1:表示此筆為空行 2:表示此筆不為空行
              "per1.ima_file.ima18,",
              "azi04.azi_file.azi04"
 
  LET l_table = cl_prt_temptable('abgr110',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
  #end FUN-750025 add
 
      LET g_trace = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)   #TQC-610054
   LET tm.yy = ARG_VAL(11)
   LET tm.bm = ARG_VAL(12)
   LET tm.em = ARG_VAL(13)
   LET tm.afc01 = ARG_VAL(14)           #FUN-AB0020 
#  LET tm.budget  = ARG_VAL(14)   #TQC-610054        #FUN-810069
   LET tm.c  = ARG_VAL(15)
   LET tm.d  = ARG_VAL(16)
   LET tm.e  = ARG_VAL(17)
   LET tm.f  = ARG_VAL(18)
   LET tm.h  = ARG_VAL(19)
   LET tm.o  = ARG_VAL(20)
   LET tm.r  = ARG_VAL(21)   #TQC-610054
   LET tm.p  = ARG_VAL(22)
   LET tm.q  = ARG_VAL(23)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF    #No.FUN-740048
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r110_tm()                # Input print condition
      ELSE CALL r110()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r110_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
          l_sw           LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(100)
          li_chk_bookno  LIKE type_file.num5     #No.FUN-680061 SMALLINT
   DEFINE li_result      LIKE type_file.num5     #NO.FUN-6C0068
 
#   CALL s_dsmark(g_bookno)    #No.FUN-740048
   CALL s_dsmark(tm.b)    #No.FUN-740048
   LET p_row = 4 LET p_col = 11
   OPEN WINDOW r110_w AT p_row,p_col
        WITH FORM "abg/42f/abgr110"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)    #No.FUN-740048
   CALL  s_shwact(0,0,tm.b)    #No.FUN-740048
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b = g_aza.aza81      #No.FUN-740048
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno    #No.FUN-740048
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b    #No.FUN-740048
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #FUN-660105
#   CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) #FUN-660105     #No.FUN-740048
   CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)      #No.FUN-740048
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#  CALL cl_err('sel azi:',SQLCA.sqlcode,0) #FUN-660105
   CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) #FUN-660105 
   END IF
#   LET tm.b = g_bookno    #No.FUN-740048
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'Y'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
#   INPUT BY NAME tm.b,tm.rtype,tm.a,tm.yy,tm.bm,tm.em,tm.budget,     #FUN-810069
#   INPUT BY NAME tm.b,tm.rtype,tm.a,tm.yy,tm.bm,tm.em,               #FUN-810069     #FUN-AB0020  mark
    INPUT BY NAME tm.b,tm.rtype,tm.a,tm.yy,tm.bm,tm.em,tm.afc01,      #FUN-AB0020
                  tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS HELP 1
        BEFORE INPUT
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
            LET g_before_input_done = FALSE
            CALL r110_set_entry(p_cmd)
            CALL r110_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD rtype
            CALL r110_set_entry(p_cmd)
            CALL r110_set_no_entry(p_cmd)
 
        AFTER FIELD a
            IF cl_null(tm.b) THEN NEXT FIELD tm.b END IF  #No.FUN-730033
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                  AND mai00 = tm.b   #No.FUN-730033
         IF STATUS THEN 
#        CALL cl_err('sel mai:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","mai_file",tm.a,tm.b,STATUS,"","sel mai:",0) #FUN-660105   #No.TQC-770061
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
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN 
#        CALL cl_err('sel aaa:',STATUS,0) #FUN-660105
         CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0) #FUN-660105  
         NEXT FIELD b END IF
 
 
        AFTER FIELD yy
           IF tm.yy IS NULL OR tm.yy = 0 THEN
              NEXT FIELD yy
           END IF
 
        AFTER FIELD bm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#           IF tm.bm <1 OR tm.bm > 13 THEN
#               CALL cl_err('','agl-013',0)
#              NEXT FIELD bm
#           END IF
#No.TQC-720032 -- end --
 
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
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
#FUN-810069--begin--
#      AFTER FIELD budget
#         SELECT * FROM afa_file WHERE afa01=tm.budget
#                                  AND afaacti IN ('Y','y')
#                                  AND afa00 = tm.b
#        IF STATUS THEN 
#       CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#        CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0) #FUN-660105 
#        NEXT FIELD budget END IF
#FUN-810069--end--
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
            CALL r110_set_entry(p_cmd)
         CALL r110_set_no_entry(p_cmd)
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p AND aziacti = 'Y'
         IF SQLCA.sqlcode THEN 
#        CALL cl_err(tm.p,'agl-109',0) #FUN-660105
         CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0) #FUN-660105 
         NEXT FIELD p END IF
 
 
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
         IF tm.yy IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy ATTRIBUTE(REVERSE)
            CALL cl_err('',9033,0)
        END IF
         IF tm.bm IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm ATTRIBUTE(REVERSE)
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
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_mai"
                 LET g_qryparam.default1 = tm.a
                #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-730033   #No.TQC-C50042   Mark
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
#FUN-810069--begin--
#         WHEN INFIELD(budget)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_afa"
#                 LET g_qryparam.default1 = tm.budget
#                 LET g_qryparam.arg1 = tm.b      #No.FUN-740048
#                 CALL cl_create_qry() RETURNING tm.budget
#                 DISPLAY tm.budget TO budget
#            NEXT FIELD budget
#FUN-810069--end--
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
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr110','9031',1)
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
                      " '",tm.bm CLIPPED,"'",
                      " '",tm.em CLIPPED,"'",
                      " '",tm.afc01 CLIPPED,"'",         #FUN-AB0020
#                      " '",tm.budget CLIPPED,"'",   #TQC-610054   #FUN-810069
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
         CALL cl_cmdat('abgr110',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r110()
   ERROR ""
END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION r110()
   DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061  VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT   #No.FUN-680061  VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680061   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061   VARCHAR(40)
   DEFINE amt1      LIKE type_file.num20_6  #No.FUN-680061   DEC(20,6)
   DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680061   DEC(20,6)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE per1         LIKE ima_file.ima18   #No.FUN-680061  DEC(8,3)
   DEFINE sr  RECORD
              bal1	LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
              END RECORD
   #str FUN-750025 add
  ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
  CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
            AND aaf02 = g_rlang
 
     CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
          WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
          WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
          OTHERWISE LET g_msg = " 1=1"
     END CASE
     LET l_sql = "SELECT * FROM maj_file",
                 " WHERE maj01 = '",tm.a,"'",
#                "   AND maj00 = '",tm.b,"'",   #No.FUN-730033  #No.TQC-770061
                 "   AND ",g_msg CLIPPED,
                 " ORDER BY maj02"
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r110_p FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r110_c CURSOR FOR r110_p
     FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
 
     FOREACH r110_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0
       IF NOT cl_null(maj.maj21) THEN
          IF cl_null(maj.maj22) THEN LET maj.maj22 = maj.maj21 END IF
#FUN-AB0020 --------------start--------------------------
          IF NOT cl_null(tm.afc01) THEN
            #IF maj.maj24 IS NULL                                                 #MOD-C60129 mark
            #   THEN SELECT SUM(afc06) INTO amt1 FROM afc_file,aag_file #整體預算 #MOD-C60129 mark
             IF maj.maj24 IS NULL THEN                                  #MOD-C60129 add
                SELECT SUM(afc06+afc08+afc09) INTO amt1                 #MOD-C60129 add
                  FROM afc_file,aag_file                                #MOD-C60129 add  #整體預算                      
                   WHERE afc00 = tm.b
                     AND afc01 = tm.afc01                          
                     AND afc02 BETWEEN maj.maj21 AND maj.maj22
                     AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND tm.em
                     AND afc02 = aag01 AND aag07 IN ('2','3')
                     AND afc00 = aag00  
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("sel","afc_file,aag_file",tm.b,"",STATUS,"","sel afc:",1)       
                      EXIT FOREACH
                   END IF
            #ELSE SELECT SUM(afc06) INTO amt1 FROM afc_file,afb_file,aag_file    #MOD-C60129 mark
             ELSE                                                                #MOD-C60129 add
                SELECT SUM(afc06+afc08+afc09) INTO amt1                          #MOD-C60129 add
                  FROM afc_file,afb_file,aag_file                                #MOD-C60129 add
                   WHERE afb00 = afc00  AND afb01 = afc01
                     AND afb02 = afc02  AND afb03 = afc03
                     AND afb15 = '2'
                     AND afc00 = tm.b
                     AND afc01 = tm.afc01                            
                     AND afc02 BETWEEN maj.maj21 AND maj.maj22
                     AND afc041 BETWEEN maj.maj24 AND maj.maj25       
                     AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND tm.em
                     AND afc02 = aag01 AND aag07 IN ('2','3')
                     AND afc00 = aag00  
                     AND afbacti = 'Y'                                            #FUN-D70090 add
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("sel","afc_file,afb_file,aag_file",tm.b,"",STATUS,"","sel aoo:",1)        
                      EXIT FOREACH
                   END IF
             END IF
         ELSE   
#FUN-AB0020  -----------------------end------------------------------
           #IF maj.maj24 IS NULL                                                #MOD-C60129 mark
           # THEN SELECT SUM(afc06) INTO amt1 FROM afc_file,aag_file #整體預算  #MOD-C60129 mark
            IF maj.maj24 IS NULL THEN                                           #MOD-C60129 add
               SELECT SUM(afc06+afc08+afc09) INTO amt1                          #MOD-C60129 add
                 FROM afc_file,aag_file                                         #MOD-C60129 add #整體預算 
                   WHERE afc00 = tm.b
#                     AND afc01 = tm.budget                          #FUN-810069
                     #AND afc01=''                                    #FUN-810069 #CHI-A40063 mark
                     AND afc02 BETWEEN maj.maj21 AND maj.maj22
                     AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND tm.em
                    #AND afc04 = '@'                 #CHI-A20007 mark
                     AND afc02 = aag01 AND aag07 IN ('2','3')
                     AND afc00 = aag00  #No.FUN-730033
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err('sel afc:',STATUS,1) #FUN-660105
#		              CALL cl_err3("sel","afc_file,aag_file",tm.b,tm.budget,STATUS,"","sel afc:",1) #FUN-660105   #FUN-810069--mark 
                      CALL cl_err3("sel","afc_file,aag_file",tm.b,"",STATUS,"","sel afc:",1)        #FUN-810069 
                      EXIT FOREACH
                   END IF
            #ELSE SELECT SUM(afc06) INTO amt1 FROM afc_file,afb_file,aag_file   #MOD-C60129 mark
             ELSE                                                               #MOD-C60129 add
               SELECT SUM(afc06+afc08+afc09) INTO amt1                          #MOD-C60129 add
                 FROM afc_file,afb_file,aag_file                                #MOD-C60129 add
                   WHERE afb00 = afc00  AND afb01 = afc01
                     AND afb02 = afc02  AND afb03 = afc03
                     AND afb15 = '2'
                     AND afc00 = tm.b
#                    AND afc01 = tm.budget                            #FUN-810069
                     #AND afc01 =''                                    #FUN-810069 #CHI-A40063 mark
                     AND afc02 BETWEEN maj.maj21 AND maj.maj22
                    #AND afc04 BETWEEN maj.maj24 AND maj.maj25        #CHI-A20007 mark
                     AND afc041 BETWEEN maj.maj24 AND maj.maj25       #CHI-A20007 add
                     AND afc03 = tm.yy AND afc05 BETWEEN tm.bm AND tm.em
                     AND afc02 = aag01 AND aag07 IN ('2','3')
                     AND afc00 = aag00  #No.FUN-730033
                     AND afbacti = 'Y'                                #FUN-D70090 add
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err('sel aao:',STATUS,1) #FUN-660105
#                     CALL cl_err3("sel","afc_file,afb_file,aag_file",tm.b,tm.budget,STATUS,"","sel aoo:",1) #FUN-660105 #FUN-810069--mark 
                      CALL cl_err3("sel","afc_file,afb_file,aag_file",tm.b,"",STATUS,"","sel aoo:",1)        #FUN-810069 
                      EXIT FOREACH
                   END IF
             END IF
          END IF                                          #FUN-AB0020      
          IF amt1 IS NULL THEN LET amt1 = 0 END IF
          #CHI-A40063 add --start--
          IF maj.maj09='-' THEN
             LET amt1 = amt1 * -1
          END IF
          #CHI-A40063 add --end--
          IF g_trace='Y' THEN
             DISPLAY 'F2:',maj.maj02,' ',maj.maj21,' TT:',amt1
          END IF
       END IF
       #-->匯率的轉換
       IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF
       #-->合計階數處理
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0	
          THEN FOR i = 1 TO 100 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
               LET k=maj.maj08  LET sr.bal1=g_tot1[k]
               FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
          ELSE
             IF maj.maj03='5' THEN
                LET sr.bal1=amt1
             ELSE
                LET sr.bal1=NULL
             END IF
       END IF
       #-->百分比基準科目
       IF maj.maj11 = 'Y' THEN			
          LET g_basetot1=sr.bal1
          IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
           IF maj.maj09='-' THEN LET g_basetot1=g_basetot1*-1 END IF  #MOD-540147
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       #-->餘額為 0 者不列印
       IF (tm.c='N' OR maj.maj03='2') AND
          maj.maj03 MATCHES "[0125]" AND sr.bal1=0 THEN
          CONTINUE FOREACH				
       END IF
       #-->最小階數起列印
       IF tm.f>0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH				
       END IF
       #by TSD.pinky
       #IF maj.maj09='-' THEN LET sr.bal1=sr.bal1*-1 END IF  #MOD-540147 #CHI-A40063 mark
       LET per1 = (sr.bal1 / g_basetot1) * 100     #百分比
       IF cl_null(per1) THEN LET per1 = 0 END IF 
      #-->列印額外名稱
      IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       IF maj.maj04 = 0 THEN
         EXECUTE insert_prep USING
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
              sr.bal1, '2',per1,g_azi04
       ELSE
        EXECUTE insert_prep USING
           maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
           sr.bal1, '2',per1,g_azi04
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO maj.maj04
           EXECUTE insert_prep USING
              maj.maj20,maj.maj20e,maj.maj02,'',
              '0', '1','',''
        END FOR
      END IF
     END FOREACH
 
   #str FUN-750025 add
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
  #報表名稱是否以報表結構名稱列印
  IF g_aaz.aaz77 = 'N' THEN LET g_mai02 = '' END IF
  LET g_str = g_mai02,";",tm.a,";",tm.d,";",tm.yy,";",tm.bm,";",
              tm.em,";",";",tm.e
  CALL cl_prt_cs3('abgr110','abgr110',g_sql,g_str)
  #------------------------------ CR (4) ------------------------------#
  #end FUN-750025 add
 
END FUNCTION
 
FUNCTION r110_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1       #No.FUN-680061 VARCHAR(1)
 
#   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bm,p,q",TRUE)
#   END IF
 
END FUNCTION
 
FUNCTION r110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1       #No.FUN-680061  VARCHAR(1)
 
   #IF (NOT g_before_input_done) THEN
       IF tm.rtype='1' THEN
           LET tm.bm = 0 DISPLAY ' ' TO bm
           CALL cl_set_comp_entry("bm",FALSE)
       END IF
       IF tm.o = 'N' THEN
           CALL cl_set_comp_entry("p,q",FALSE)
       END IF
  # END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
