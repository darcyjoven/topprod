# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp109.4gl
# Descriptions...: 已過帳傳票還原作業
# Input parameter:
# Return code....:
# Date & Author..: 92/03/06 BY MAY
# Modify.........: 95/06/09 By Danny  (判斷是否小於關帳日期)
# Modify.........: By Melody   '還原後傳票是否立即刪除'選項拿掉
# Modify.........: By Melody   aee00 改為 no-use
# Modify.........: 97/04/16 By Melody aaa07 改為關帳日期
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570024 04/07/29 By Elva 新增審計調整內容
# Modify ........: No.FUN-570145 06/02/27 By yiting 批次背景執行
# Modify.........: No.MOD-620034 06/03/31 By Smapmin 新增帳別欄位
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.MOD-680104 06/09/06 By Smapmin 過帳傳票還原作業不應該刪除科目異動碼值基本資料
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/17 By yjkhero 錯誤訊息匯整
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.MOD-730008 07/03/08 By Smapmin 恢復MOD-620034所修改的程式段
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.FUN-740200 07/04/26 By cheunl aaz431,aaz441為nouse參數，對程序有影響，所以mark
# Modify.........: No.TQC-7C0029 07/12/06 By Smapmin 抓取科目相關資料時,WHERE條件要加入帳別
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控
# Modify.........: No.MOD-910187 09/01/15 By chenl  1.修正FUN-810069及增加FUN-840074修改功能。針對項目預算管理進行調整。
#                                                   2.應計憑証增加條件abapost='Y'
# Modify.........: No.MOD-920260 09/02/19 By chenyu 過賬還原沒有清空過賬人員欄位
# Modify.........: No.MOD-920374 09/02/27 By chenl  調整函數re_aao()。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0052 09/11/17 By Carrier 增加'科目核算項'統計檔功能
# Modify.........: No:MOD-A10073 10/01/12 By Sarah 批次執行過程中若有錯,最後TRANSACTION應ROLLBACK
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:TQC-AB0117 10/11/28 By lixia 已拋轉憑證的憑證再次過帳，同樣顯示拋轉成功
# Modify.........: No:MOD-B30571 11/03/16 By Sarah 回寫afc_file前,需先判斷若abb35/abb05/abb08為NULL值給預設值' '
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.MOD-C10222 12/02/02 By Polly 過帳還原時若沒有刪除到tic_file則不提示錯誤
# Modify.........: No.MOD-C30827 12/03/27 By Polly 傳繫還原時，需將沖帳記錄一併刪除調整

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     #No.FUN-740020  --Begin
     tm        RECORD
               bookno LIKE aaa_file.aaa01
               END RECORD,
     #No.FUN-740020  --End
     g_wc      STRING,  #No.FUN-580092 HCN
     g_sql     STRING,  # RDSQL STATEMENT
     g_aaa04   LIKE aaa_file.aaa04,
     g_aaa05   LIKE aaa_file.aaa05,
     g_aaa07   LIKE aaa_file.aaa07,
     g_aba      RECORD LIKE aba_file.*,
     g_abb      RECORD LIKE abb_file.*,
     l_aag      RECORD LIKE aag_file.*,
     l_aba      RECORD LIKE aba_file.*,
     l_abb      RECORD LIKE abb_file.*,
     g_eom,g_eoy LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1)
     #FUN-570024  --begin
     g_bdate    LIKE type_file.dat,       #No.FUN-680098   DATE
     g_bno      LIKE aba_file.aba01,
     #FUN-570024  --end
     g_bookno   LIKE aaa_file.aaa01       #帳別

DEFINE   g_cnt           LIKE type_file.num10          #No.FUN-680098 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(72)
DEFINE ls_date           STRING  ,    #No.FUN-570145
       l_flag            LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       g_change_lang     LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
DEFINE  p_row,p_col      LIKE type_file.num5           #No.FUN-680098 SMALLINT

MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
    #FUN-570024  --begin
    DEFINE  p_row,p_col    LIKE type_file.num5,        #No.FUN-680098 SMALLINT
            l_str          LIKE ze_file.ze03,          #No.FUN-680098 VARCHAR(15)
            l_flag         LIKE type_file.chr1         #No.FUN-680098 VARCHAR(1)
    #FUN-570024  --end

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

   LET tm.bookno = ARG_VAL(1)  #No.FUN-740020
    #FUN-570024 --begin
    LET g_bdate = ARG_VAL(2)
    LET g_bno = ARG_VAL(3)
    #FUN-570024 --end
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(4)                         #QBE條件
   LET g_bgjob  = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
  #--- No.FUN-570145 --end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114


    #No.FUN-740020  --Begin
    IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
       SELECT aaz64 INTO tm.bookno FROM aaz_file
    END IF
    SELECT aaa04,aaa05,aaa07
      INTO g_aaa04,g_aaa05,g_aaa07
      FROM aaa_file WHERE aaa01 = tm.bookno
    #No.FUN-740020  --End
  #--- No.FUN-570145 --start---
  #CALL aglp109_tm(0,0)
  WHILE TRUE
    LET g_success = 'Y'
    LET g_totsuccess = 'Y'    #MOD-A10073 add
    LET g_change_lang = FALSE
    IF g_bgjob = 'N' THEN
       IF cl_null(g_bdate) THEN
          CALL aglp109_tm(0,0)
      #ELSE                   #MOD-A10073 mark
      #   CALL aglp109_p1()   #MOD-A10073 mark 
       END IF
       IF cl_sure(21,21) THEN
          LET g_success = 'Y'
          CALL cl_wait()
          BEGIN WORK
          CALL p109_process()
          #CALL aglp109_tm(0,0)
          CALL s_showmsg()                #NO.FUN-710023
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW aglp109_w
            EXIT WHILE
         END IF
       ELSE
         CONTINUE WHILE
       END IF
       CLOSE WINDOW aglp109_w
    ELSE
       BEGIN WORK
      #str MOD-A10073 mark 
      #IF cl_null(g_bdate) THEN
      #   CALL aglp109_tm(0,0)
      #ELSE
      #   CALL aglp109_p1()
      #END IF
      #end MOD-A10073 mark 
       CALL p109_process()
       CALL s_showmsg()                #NO.FUN-710023
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
  END WHILE

#NO.FUN-570145 START---
    #FUN-570024 --begin
    #IF cl_null(g_bdate) THEN
    #   CALL aglp109_tm(0,0)
    #ELSE
    #   CALL aglp109_p1()
    #   IF g_success = 'Y' THEN
    #     COMMIT WORK
    #   ELSE
    #      ROLLBACK WORK
    #   END IF
    #END IF
    #FUN-570024 --end
#NO.FUN-570145 END---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION aglp109_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5     #FUN-570145  #No.FUN-680098 SMALLINT
           #l_str         VARCHAR(15)                #FUN-570145
           #l_flag        LIKE type_file.chr1     #FUN-570145
   DEFINE  lc_cmd         LIKE type_file.chr1000  #FUN-570145  #No.FUN-680098  VARCHAR(500)

   CALL s_dsmark(tm.bookno)  #No.FUN-740020

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp109_w AT p_row,p_col WITH FORM "agl/42f/aglp109"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()


   CALL s_shwact(0,0,tm.bookno)  #No.FUN-740020
   CALL cl_opmsg('q')

   WHILE TRUE
      IF s_aglshut(0) THEN RETURN END IF
      CLEAR FORM
      CONSTRUCT BY NAME g_wc ON aba01,aba02,aba03,aba04,abauser

         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

       ON ACTION locale
         #CALL cl_dynamic_locale()               #No.FUN-570145
#         CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
         LET g_change_lang = TRUE                #No.FUN-570145
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

         ON ACTION exit                        #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup') #FUN-980030
  #-->No.FUN-570145 --start--
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
        CONTINUE WHILE
     END IF

#   IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       RETURN
#   END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp109_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     LET g_bgjob = 'N'
     LET tm.bookno = g_aza.aza81  #No.FUN-740020
     DISPLAY BY NAME tm.bookno    #No.FUN-740020
     DISPLAY BY NAME g_bgjob
     INPUT BY NAME tm.bookno,g_bgjob WITHOUT DEFAULTS  #No.FUN-740020

         #No.FUN-740020  --Begin
         AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL p109_bookno(tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
              #str MOD-A10073 add
               ELSE
                  SELECT aaa04,aaa05,aaa07 
                    INTO g_aaa04,g_aaa05,g_aaa07
                    FROM aaa_file WHERE aaa01 = tm.bookno
              #end MOD-A10073 add
               END IF
            END IF
         #No.FUN-740020  --End

         #No.FUN-740020  --Begin
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.bookno
                  CALL cl_create_qry() RETURNING tm.bookno
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
            END CASE
         #No.FUN-740020  --End

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

        ON ACTION locale
           CALL cl_show_fld_cont()
           LET g_change_lang = TRUE
           EXIT INPUT

        ON ACTION exit                            #加離開功能
           LET INT_FLAG = 1
           EXIT INPUT
     END INPUT

     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
        CONTINUE WHILE
     END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp109_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF

#   IF cl_sure(21,21) THEN
#      CALL cl_wait()
#      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#         LET p_row = 14 LET p_col = 42
#      ELSE LET p_row = 18 LET p_col = 26
#      END IF
#      OPEN WINDOW aglp109_g_w AT p_row,p_col
#        WITH 5 rows, 30 COLUMNS
#      CALL cl_getmsg('agl-024',g_lang) RETURNING l_str
#     #DISPLAY l_str AT 4,8  CHI-A70049 mark
#      LET g_sql = "SELECT * FROM aba_file WHERE aba00 = '",tm.bookno,"'",
#                  "   AND abapost = 'Y' AND abaacti = 'Y' AND ",g_wc CLIPPED
#      PREPARE p109_p FROM g_sql
#      DECLARE p109_cur CURSOR WITH HOLD FOR p109_p
#      FOREACH p109_cur INTO g_aba.*
#        #DISPLAY 'recover:',g_aba.aba01 AT 1,1  CHI-A70049 mark
#         IF g_aba.aba03 < g_aaa04 THEN #若非今年的傳票資料,則判斷系統參數
#            IF g_aaz.aaz431 NOT MATCHES  '[Yy]' THEN
#               CALL cl_err(g_aba.aba03,'agl-047',0) CONTINUE FOREACH
#            END IF
#         END IF
#         #若為今年前期的傳票資料,則判斷系統參數(aaz441)
###         IF g_aba.aba03 = g_aaa04 AND g_aba.aba04 < g_aaa05 THEN
##            IF g_aaz.aaz441 NOT MATCHES  '[Yy]' THEN
##               CALL cl_err(g_aba.aba04,'agl-048',0) CONTINUE FOREACH
#            END IF
##         END IF
##         IF g_aba.aba02 <= g_aaa07 THEN   #判斷傳票日期是否小於關帳日期
#            CALL cl_err(g_aba.aba02,'agl-200',0) CONTINUE FOREACH
#         END IF
#         LET g_success = 'Y'
#         BEGIN WORK
#         CALL aglp109()    #處理1.科目餘額檔2.分類帳檔3.異動別分類檔
#                           #    4.更新科目餘額5.預算巳消耗金額
#      END FOREACH
#      CLOSE WINDOW aglp109_g_w
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#      END IF
#      IF l_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END IF
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aglp109"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('aglp109','9031',1)
        ELSE
           LET g_wc = cl_replace_str(g_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " '",g_bdate CLIPPED,"'",
                        " '",g_bno CLIPPED,"'",
                        " '",g_wc CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aglp109',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp109_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
      END IF
      EXIT WHILE
#-- No.FUN-570145 --end---
   ERROR ""
  END WHILE
#  CLOSE WINDOW aglp109_w
END FUNCTION

#No.FUN-740020  --Begin
FUNCTION p109_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti

    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-740020  --End

#FUN-570024  --begin
FUNCTION aglp109_p1()
DEFINE  p_row,p_col    LIKE type_file.num5,             #No.FUN-680098 SMALLINT
        l_str          LIKE type_file.chr1000,          #No.FUN-680098 VARCHAR(15)
        l_flag         LIKE type_file.chr1              #No.FUN-680098 VARCHAR(01)

   LET p_row = 18 LET p_col = 26
   OPEN WINDOW aglp109_g_w AT p_row,p_col
     WITH 5 rows, 30 COLUMNS
   CALL cl_getmsg('agl-024',g_lang) RETURNING l_str
  #DISPLAY l_str AT 4,8   CHI-A70049   mark
   IF NOT cl_null(g_bdate) AND NOT cl_null(g_bno) THEN
      LET g_sql = "SELECT * FROM aba_file WHERE aba00 = '",tm.bookno,"'",          #No.FUN-740020
                  "   AND abapost = 'Y' AND abaacti = 'Y' ",
                  "   AND aba02 ='",g_bdate,"'",
                  "   AND aba01 ='",g_bno,"'"
   ELSE
      LET g_sql = "SELECT * FROM aba_file WHERE aba00 = '",tm.bookno,"'",  #No.FUN-740020
                  "   AND abapost = 'Y' AND abaacti = 'Y' AND ",g_wc CLIPPED
   END IF
   PREPARE p109_pb FROM g_sql
   DECLARE p109_curb CURSOR WITH HOLD FOR p109_pb
   FOREACH p109_curb INTO g_aba.*
     #DISPLAY 'recover:',g_aba.aba01 AT 1,1   #CHI-A70049 mark
#No.FUN-740200---------start---------------
#     IF g_aba.aba03 < g_aaa04 THEN #若非今年的傳票資料,則判斷系統參數
#        IF g_aaz.aaz431 NOT MATCHES  '[Yy]' THEN
#           CALL cl_err(g_aba.aba03,'agl-047',0) CONTINUE FOREACH
#        END IF
#     END IF
#     #若為今年前期的傳票資料,則判斷系統參數(aaz441)
#     IF g_aba.aba03 = g_aaa04 AND g_aba.aba04 < g_aaa05 THEN
#        IF g_aaz.aaz441 NOT MATCHES  '[Yy]' THEN
#           CALL cl_err(g_aba.aba04,'agl-048',0) CONTINUE FOREACH
#        END IF
#     END IF
#No.FUN-740200---------send----------------
      IF g_aba.aba02 <= g_aaa07 THEN   #判斷傳票日期是否小於關帳日期
         CALL cl_err(g_aba.aba02,'agl-200',0) CONTINUE FOREACH
      END IF
      LET g_success = 'Y'
      BEGIN WORK
      CALL aglp109()    #處理1.科目餘額檔2.分類帳檔3.異動別分類檔
                        #    4.更新科目餘額5.預算巳消耗金額
   END FOREACH
   CLOSE WINDOW aglp109_g_w
END FUNCTION
#FUN-570024  --end

FUNCTION aglp109()
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
      DEFINE
          l_buf     LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(80)
          l_aag05   LIKE aag_file.aag05,
          l_aag06   LIKE aag_file.aag06,
          l_aag07   LIKE aag_file.aag07,
          l_aag08   LIKE aag_file.aag08,
          l_aag23   LIKE aag_file.aag23,
          l_aag151,l_aag161,l_aag171,l_aag181      LIKE aag_file.aag151,  #No.FUN-680098  VARCHAR(1)
          l_amt_d,l_amt_c    LIKE type_file.num20_6,  #No.FUN-4C0009      #No.FUN-680098  DECIMAL(20,6)
          l_amtf_d,l_amtf_c  LIKE type_file.num20_6,  #No.FUN-4C0009      #No.FUN-680098  DECIMAL(20,6)
          l_no_d,l_no_c      LIKE type_file.num5,     #No.FUN-680098      SMALLINT
          l_cnt1,l_cnt2      LIKE type_file.num5     # Already-cnt, N-cnt   #No.FUN-680098 SMALLINT
   DEFINE m_aag08   LIKE aag_file.aag08,
          t_aag08   LIKE aag_file.aag08,     #add 030926 NO.A092
          l_aag24   LIKE aag_file.aag24,
          l_i       LIKE type_file.num5      #No.FUN-680098  SMALLINT

   #FUN-5C0015 BY GILL --START
   DEFINE l_aag311   LIKE aag_file.aag311,
          l_aag321   LIKE aag_file.aag321,
          l_aag331   LIKE aag_file.aag331,
          l_aag341   LIKE aag_file.aag341,
          l_aag351   LIKE aag_file.aag351,
          l_aag361   LIKE aag_file.aag361,
          l_aag371   LIKE aag_file.aag371
   #FUN-5C0015 BY GILL --END
   DEFINE l_cnt      LIKE type_file.num5          #MOD-C30827 add
   DEFINE l_abh      RECORD LIKE abh_file.*       #MOD-C30827 add
   DEFINE l_abh09,l_abh09_2 LIKE abh_file.abh09   #MOD-C30827 add


     #將當期會計科目餘額反調
     DECLARE p109_cs2 CURSOR FOR
            SELECT abb_file.*,
                   aag05,aag06,aag07,aag08,aag151,aag161,aag171,aag181,aag23,
                   aag311,aag321,aag331,aag341,  #FUN-5C0015 BY GILL
                   aag351,aag361,aag371          #FUN-5C0015 BY GILL
              FROM abb_file LEFT OUTER JOIN aag_file ON abb03 = aag01 AND abb00 = aag00
             WHERE abb00 = tm.bookno AND abb01 = g_aba.aba01   #No.FUN-740020
     FOREACH p109_cs2 INTO g_abb.*,l_aag05,l_aag06,l_aag07,l_aag08,
                                   l_aag151,l_aag161,l_aag171,l_aag181,l_aag23,
             l_aag311,l_aag321,l_aag331,l_aag341, #FUN-5C0015 BY GILL
             l_aag351,l_aag361,l_aag371           #FUN-5C0015 BY GILL


#-----------------------------MODIFY '92/08/12' afc_file 巳消耗金額亦需反調
       IF STATUS THEN
#         CALL cl_err('p109.1:foreach',STATUS,1)    #NO.FUN-710023
          LET g_showmsg=tm.bookno,"/",g_aba.aba01    #NO.FUN-710023   #No.FUN-740020
          CALL s_errmsg('abb00,abb01',g_showmsg,'p109.1:foreach',STATUS,1)     #NO.FUN-710023
          LET g_success = 'N'
          RETURN
      END IF
      IF g_bgjob = 'N' THEN           #FUN-57014
         display 'update afc' at 2,1
      END IF
#No.MOD-910187--begin-- unmark and modify
      IF cl_null(g_abb.abb35) THEN LET g_abb.abb35=' ' END IF     #MOD-B30571 add
      IF cl_null(g_abb.abb05) THEN LET g_abb.abb05=' ' END IF     #MOD-B30571 add
      IF cl_null(g_abb.abb08) THEN LET g_abb.abb08=' ' END IF     #MOD-B30571 add
#FUN-810069 --- STA
#     IF g_abb.abb15 IS NOT NULL AND g_abb.abb15 != ' ' THEN
      IF g_abb.abb36 IS NOT NULL AND g_abb.abb36 != ' ' THEN   #No.MOD-910187
         IF g_abb.abb06 = '1' THEN #單身科目為借方
            IF l_aag06 = '1' THEN #借餘 原來借餘是用加的故此時借餘要減回來
               UPDATE afc_file SET afc07 = afc07 - g_abb.abb07
               #WHERE afc00 = tm.bookno AND afc01 = g_abb.abb15  #No.FUN-740020  #No.MOD-910187
                WHERE afc00 = tm.bookno AND afc01 = g_abb.abb36  #No.MOD-910187
                  AND afc02 = g_abb.abb03
                  AND afc03 = g_aba.aba03
                 #No.MOD-910187--begin-- modify
                 #AND (afc04 = '@' OR afc04=g_abb.abb05 OR
                 #     afc04 = g_abb.abb08 OR
                 #     afc04 = g_abb.abb11 OR
                 #     afc04 = g_abb.abb12 OR
                 #     afc04 = g_abb.abb13 OR
                 #     afc04 = g_abb.abb14 OR
                 #     #FUN-5C0015 BY GILL --START
                 #     afc04 = g_abb.abb31 OR
                 #     afc04 = g_abb.abb32 OR
                 #     afc04 = g_abb.abb33 OR
                 #     afc04 = g_abb.abb34 OR
                 #     afc04 = g_abb.abb35 OR
                 #     afc04 = g_abb.abb36 OR
                 #     afc04 = g_abb.abb37
                 #     #FUN-5C0015 BY GILL --END
                 #     )
                  AND afc04 = g_abb.abb35
                  AND afc041= g_abb.abb05
                  AND afc042= g_abb.abb08
                 #No.MOD-910187---end---
                  AND afc05 = g_aba.aba04
               IF STATUS THEN
 #                CALL cl_err('p109.2:upd afc',STATUS,1)   #No.FUN-660123
 #                CALL cl_err3("upd","afc_file",tm.bookno,g_abb.abb15,STATUS,"","p109.2:upd afc",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
                  LET g_showmsg=tm.bookno,"/",g_abb.abb15                               #NO.FUN-710023                     #No.FUN-740020
                  CALL s_errmsg('afc00,afc01',g_showmsg,'p109.1:foreach',STATUS,1)     #NO.FUN-710023
                  LET g_success = 'N'
                  RETURN
               END IF
            ELSE   #貸餘
               UPDATE afc_file SET afc07 = afc07 + g_abb.abb07
               #WHERE afc00 = tm.bookno AND afc01 = g_abb.abb15  #No.FUN-740020  #No.MOD-910187 mark
                WHERE afc00 = tm.bookno AND afc01 = g_abb.abb36  #No.MOD-910187
                  AND afc02 = g_abb.abb03
                  AND afc03 = g_aba.aba03
                 #No.MOD-910187--begin-- modify
                 #AND (afc04 = '@' OR afc04=g_abb.abb05 OR
                 #     afc04 = g_abb.abb08 OR
                 #     afc04 = g_abb.abb11 OR
                 #     afc04 = g_abb.abb12 OR
                 #     afc04 = g_abb.abb13 OR
                 #     afc04 = g_abb.abb14 OR
                 #     #FUN-5C0015 BY GILL --START
                 #     afc04 = g_abb.abb31 OR
                 #     afc04 = g_abb.abb32 OR
                 #     afc04 = g_abb.abb33 OR
                 #     afc04 = g_abb.abb34 OR
                 #     afc04 = g_abb.abb35 OR
                 #     afc04 = g_abb.abb36 OR
                 #     afc04 = g_abb.abb37
                 #     #FUN-5C0015 BY GILL --END
                 #    )
                  AND afc04 = g_abb.abb35
                  AND afc041= g_abb.abb05
                  AND afc042= g_abb.abb08
                 #No.MOD-910187---end---
                  AND afc05 = g_aba.aba04
               IF STATUS THEN
 #                CALL cl_err('p109.3:upd afc',STATUS,1)   #No.FUN-660123
 #                CALL cl_err3("upd","afc_file",tm.bookno,g_abb.abb15,STATUS,"","p109.3:upd afc",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
                  LET g_showmsg=tm.bookno,"/",g_abb.abb15                               #NO.FUN-710023                     #No.FUN-740020
                  CALL s_errmsg('afc00,afc01',g_showmsg,'p109.3:upd afc',STATUS,1)     #NO.FUN-710023
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
         IF g_abb.abb06 = '2' THEN #單身科目為貸方
            IF l_aag06 = '1' THEN #借餘 原來貸餘是用減的故此時貸餘要加回來
               UPDATE afc_file SET afc07 = afc07 + g_abb.abb07
               #WHERE afc00 = tm.bookno AND afc01 = g_abb.abb15  #No.FUN-740020  #No.MOD-910187 mark
                WHERE afc00 = tm.bookno AND afc01 = g_abb.abb36  #No.MOD-910187
                  AND afc02 = g_abb.abb03
                  AND afc03 = g_aba.aba03
                 #No.MOD-910187--begin-- modify
                 #AND (afc04 = '@' OR afc04=g_abb.abb05 OR
                 #     afc04 = g_abb.abb08 OR
                 #     afc04 = g_abb.abb11 OR
                 #     afc04 = g_abb.abb12 OR
                 #     afc04 = g_abb.abb13 OR
                 #     afc04 = g_abb.abb14 OR
                 #     #FUN-5C0015 BY GILL --START
                 #     afc04 = g_abb.abb31 OR
                 #     afc04 = g_abb.abb32 OR
                 #     afc04 = g_abb.abb33 OR
                 #     afc04 = g_abb.abb34 OR
                 #     afc04 = g_abb.abb35 OR
                 #     afc04 = g_abb.abb36 OR
                 #     afc04 = g_abb.abb37
                 #     #FUN-5C0015 BY GILL --END
                 #    )
                  AND afc04 = g_abb.abb35
                  AND afc041= g_abb.abb05
                  AND afc042= g_abb.abb08
                 #No.MOD-910187---end---
                  AND afc05 = g_aba.aba04
               IF STATUS THEN
 #                CALL cl_err('p109.4:upd afc',STATUS,1)   #No.FUN-660123
 #                CALL cl_err3("upd","afc_file",tm.bookno,g_abb.abb15,STATUS,"","p109.4:upd afc",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
                  LET g_showmsg=tm.bookno,"/",g_abb.abb15                               #NO.FUN-710023                     #No.FUN-740020
                  CALL s_errmsg('afc00,afc01',g_showmsg,'p109.4:upd afc',STATUS,1)     #NO.FUN-710023
                  LET g_success = 'N'
                  RETURN
               END IF
            ELSE   #貸餘
               UPDATE afc_file SET afc07 = afc07 + g_abb.abb07 * (-1)
               #WHERE afc00 = tm.bookno AND afc01 = g_abb.abb15  #No.FUN-740020  #No.MOD-910187 mark
                WHERE afc00 = tm.bookno AND afc01 = g_abb.abb36  #No.MOD-910187
                  AND afc02 = g_abb.abb03
                  AND afc03 = g_aba.aba03
                 #No.MOD-910187--begin-- modify
                 #AND (afc04 = '@' OR afc04=g_abb.abb05 OR
                 #     afc04 = g_abb.abb08 OR
                 #     afc04 = g_abb.abb11 OR
                 #     afc04 = g_abb.abb12 OR
                 #     afc04 = g_abb.abb13 OR
                 #     afc04 = g_abb.abb14 OR
                 #     #FUN-5C0015 BY GILL --START
                 #     afc04 = g_abb.abb31 OR
                 #     afc04 = g_abb.abb32 OR
                 #     afc04 = g_abb.abb33 OR
                 #     afc04 = g_abb.abb34 OR
                 #     afc04 = g_abb.abb35 OR
                 #     afc04 = g_abb.abb36 OR
                 #     afc04 = g_abb.abb37
                 #     #FUN-5C0015 BY GILL --END
                 #    )
                  AND afc04 = g_abb.abb35
                  AND afc041= g_abb.abb05
                  AND afc042= g_abb.abb08
                 #No.MOD-910187---end---
                  AND afc05 = g_aba.aba04
               IF STATUS THEN
 #                CALL cl_err('p109.5:upd afc',STATUS,1)   #No.FUN-660123
 #                CALL cl_err3("upd","afc_file",tm.bookno,g_abb.abb15,STATUS,"","p109.5:upd afc",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
                  LET g_showmsg=tm.bookno,"/",g_abb.abb15                               #NO.FUN-710023                     #No.FUN-740020
                  CALL s_errmsg('afc00,afc01',g_showmsg,'p109.5:upd afc',STATUS,1)     #NO.FUN-710023
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
      END IF
#FUN-810069 --- END
#No.MOD-910187---end--- unmark and modify
     ###afc_file的更新完成
#----------------------------- #若為明細科目則需再扣除統制科目的金額
     IF g_bgjob = 'N' THEN         #FUN-570145
         display 'update aah' at 2,1
     END IF
     IF g_abb.abb06 = '1'
        THEN LET l_amt_d = g_abb.abb07  LET l_no_d = 1
             LET l_amt_c = 0            LET l_no_c = 0
             LET l_amtf_d= g_abb.abb07f LET l_amtf_c= 0
        ELSE LET l_amt_d = 0            LET l_no_d = 0
             LET l_amt_c = g_abb.abb07  LET l_no_c = 1
             LET l_amtf_c= g_abb.abb07f LET l_amtf_d= 0
     END IF
     #科目餘額檔傳票中的單身科目
     UPDATE aah_file SET aah04 = aah04 - l_amt_d, aah05 = aah05 - l_amt_c,
                         aah06 = aah06 - l_no_d,  aah07 = aah07 - l_no_c
         WHERE aah00 = tm.bookno AND aah01 = g_abb.abb03   #No.FUN-740020
               AND aah02 = g_aba.aba03 AND aah03 = g_aba.aba04
       IF STATUS THEN
#          CALL cl_err('p109.6:upd aah',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("upd","aah_file",tm.bookno,g_abb.abb03,STATUS,"","p109.6:upd aah",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
           LET g_showmsg=tm.bookno,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04             #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'p109.5:upd afc',STATUS,1)     #NO.FUN-710023
           LET g_success = 'N' RETURN END IF
     #add by danny 020226 外幣管理(A002)
     IF g_aaz.aaz83 = 'Y' THEN
        UPDATE tah_file SET tah04 = tah04 - l_amt_d, tah05 = tah05 - l_amt_c,
                            tah06 = tah06 - l_no_d,  tah07 = tah07 - l_no_c,
                            tah09 = tah09 - l_amtf_d,tah10 = tah10 - l_amtf_c
         WHERE tah00 = tm.bookno    AND tah01 = g_abb.abb03   #No.FUN-740020
           AND tah02 = g_aba.aba03 AND tah03 = g_aba.aba04
           AND tah08 = g_abb.abb24
          IF STATUS THEN
#          CALL cl_err('p109.6:upd tah',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("upd","tah_file",tm.bookno,g_abb.abb03,STATUS,"","p109.6:upd tah",1)  #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24 #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'p109.6:upd tah',STATUS,1)      #NO.FUN-710023
            LET g_success = 'N'
             RETURN
           END IF
     END IF
     IF g_aaz.aaz51 = 'Y' THEN
        UPDATE aas_file SET aas04 = aas04 - l_amt_d, aas05 = aas05 - l_amt_c,
                            aas06 = aas06 - l_no_d,  aas07 = aas07 - l_no_c
            WHERE aas00 = tm.bookno AND aas01 = g_abb.abb03   #No.FUN-740020
                  AND aas02 = g_aba.aba02
          IF STATUS THEN
#          CALL cl_err('p109.7:upd aas',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("upd","aas_file",tm.bookno,g_abb.abb03,STATUS,"","p109.7:upd aas",1)   #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",g_abb.abb03,"/",g_aba.aba02                             #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'p109.7:upd ass',STATUS,1)             #NO.FUN-710023
                         LET g_success = 'N' RETURN END IF
        #add by danny 020226 外幣管理(A002)
        IF g_aaz.aaz83 = 'Y' THEN
           UPDATE tas_file SET tas04 = tas04 - l_amt_d, tas05 = tas05 - l_amt_c,
                               tas06 = tas06 - l_no_d,  tas07 = tas07 - l_no_c,
                               tas09 = tas09 - l_amtf_d,tas10 = tas10 - l_amtf_c
            WHERE tas00 = tm.bookno    AND tas01 = g_abb.abb03   #No.FUN-740020
              AND tas02 = g_aba.aba02 AND tas08 = g_abb.abb24
        IF STATUS THEN
#          CALL cl_err('p109.7:upd tas',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("upd","tas_file",tm.bookno,g_abb.abb03,STATUS,"","p109.7:upd tas",1)   #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_abb.abb24                             #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'p109.7:upd tas',STATUS,1)             #NO.FUN-710023
                          LET g_success = 'N' RETURN END IF
        END IF
     END IF
     IF l_aag05='Y' AND g_abb.abb05 IS NOT NULL THEN
        # UPDATE aao_file SET aao05 = aao05 - l_amt_d, aao06 = aao06 - l_amt_c
        # No.+462 010725 mod by linda
        UPDATE aao_file SET aao05 = aao05 - l_amt_d, aao06 = aao06 - l_amt_c,
                            aao07 = aao07 - l_no_d,  aao08 = aao08 - l_no_c
        #No.+462 end---
            WHERE aao00 = tm.bookno AND aao01 = g_abb.abb03   #No.FUN-740020
                  AND aao02 = g_abb.abb05
                  AND aao03 = g_aba.aba03
                  AND aao04 = g_aba.aba04
          IF STATUS THEN
#             CALL cl_err('p109.7:upd aao',STATUS,1)   #No.FUN-660123
#             CALL cl_err3("upd","aao_file",tm.bookno,g_abb.abb03,STATUS,"","p109.7:upd aao",1)    #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",g_abb.abb03,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04 #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('aao00,aao01,aao02,aao03,aao04',g_showmsg,'p109.7:upd aoo',STATUS,1)     #NO.FUN-710023
                         LET g_success = 'N' RETURN END IF
        #add by danny 020226 外幣管理(A002)
        IF g_aaz.aaz83 = 'Y' THEN
           UPDATE tao_file SET tao05 = tao05 - l_amt_d, tao06 = tao06 - l_amt_c,
                               tao07 = tao07 - l_no_d,  tao08 = tao08 - l_no_c,
                               tao10 = tao10 - l_amtf_d,tao11 = tao11 - l_amtf_c
            WHERE tao00 = tm.bookno    AND tao01 = g_abb.abb03   #No.FUN-740020
              AND tao02 = g_abb.abb05 AND tao03 = g_aba.aba03
              AND tao04 = g_aba.aba04 AND tao09 = g_abb.abb24
             IF STATUS THEN
#                CALL cl_err('p109.7:upd tao',STATUS,1)   #No.FUN-660123
#                CALL cl_err3("upd","tao_file",tm.bookno,g_abb.abb03,STATUS,"","p109.7:upd tao",1)   #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",g_abb.abb03,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24 #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('tao00,tao01,tao02,tao03,tao04,tao09',g_showmsg,'p109.7:upd too',STATUS,1)     #NO.FUN-710023
                          LET g_success = 'N' RETURN END IF
        END IF
     END IF

     #No.FUN-9A0052  --Begin
     CALL aglp109_aeh(g_aba.*,g_abb.*)
     #No.FUN-9A0052  --End

      #若有統制帳戶則需再反調統制帳戶的金額
     #modify 020814  NO.A030
      IF l_aag07 = '2' THEN #為明細科目則以其統制帳戶再更新一次
        CALL aglp109_upd(l_aag08,l_amt_d,l_amt_c,l_no_d,l_no_c,
                         l_amtf_d,l_amtf_c,l_aag05)
        #modify 030926  NO.A092
      # IF g_aza.aza26 = '2' THEN       #bug no:7275 #CHI-710005
           SELECT aag08,aag24 INTO t_aag08,l_aag24 FROM aag_file
            WHERE aag01 = l_aag08
              AND aag00 = tm.bookno   #TQC-7C0029
           IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
           LET m_aag08 = t_aag08
           FOR l_i = l_aag24 - 1  TO 1 STEP -1
               CALL aglp109_upd(m_aag08,l_amt_d,l_amt_c,l_no_d,l_no_c, l_amtf_d,l_amtf_c,l_aag05)
               LET t_aag08 = m_aag08
               SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = t_aag08
                                                         AND aag00 = tm.bookno   #TQC-7C0029
           END FOR
      # END IF
{---bug no:7275
        #add by danny 020226 外幣管理(A002)
        IF g_aaz.aaz83 = 'Y' THEN
           UPDATE tah_file SET tah04 = tah04 - l_amt_d, tah05 = tah05 - l_amt_c,
                               tah06 = tah06 - l_no_d,  tah07 = tah07 - l_no_c,
                               tah09 = tah09 - l_amtf_d,tah10 = tah10 - l_amtf_c
             WHERE tah00 = tm.bookno AND tah01 = l_aag08  #No.FUN-740020
               AND tah02 = g_aba.aba03 AND tah03 = g_aba.aba04
               AND tah08 = g_abb.abb24
             IF STATUS THEN
#              CALL cl_err('p109.8:upd tah',STATUS,1)   #No.FUN-660123
               CALL cl_err3("upd","tah_file",tm.bookno,l_aag08,STATUS,"","p109.8:upd tah",1)   #No.FUN-660123  #No.FUN-740020
                   LET g_success = 'N' RETURN END IF
        END IF
        IF g_aaz.aaz51 = 'Y' THEN
           UPDATE aas_file SET aas04 = aas04 - l_amt_d, aas05 = aas05 - l_amt_c,
                               aas06 = aas06 - l_no_d,  aas07 = aas07 - l_no_c
                WHERE aas00 = tm.bookno AND aas01 = l_aag08  #No.FUN-740020
                      AND aas02 = g_aba.aba02
             IF STATUS THEN
#               CALL cl_err('p109.9:upd aas',STATUS,1)   #No.FUN-660123
                CALL cl_err3("upd","aas_file",tm.bookno,l_aag08,STATUS,"","p109.9:upd aas",1)   #No.FUN-660123  #No.FUN-740020
                            LET g_success = 'N' RETURN END IF
           #add by danny 020226 外幣管理(A002)
           IF g_aaz.aaz83 = 'Y' THEN
              UPDATE tas_file SET tas04 = tas04 - l_amt_d,
                                  tas05 = tas05 - l_amt_c,
                                  tas06 = tas06 - l_no_d,
                                  tas07 = tas07 - l_no_c,
                                  tas09 = tas09 - l_amtf_d,
                                  tas10 = tas10 - l_amtf_c
               WHERE tas00 = tm.bookno    AND tas01 = l_aag08  #No.FUN-740020
                 AND tas02 = g_aba.aba02 AND tas08 = g_abb.abb24
                IF STATUS THEN
#                  CALL cl_err('p109.9:upd tas',STATUS,1)   #No.FUN-660123
                   CALL cl_err3("upd","tas_file",tm.bookno,l_aag08,STATUS,"","p109.9:upd tas",1)   #No.FUN-660123  #No.FUN-740020
                             LET g_success = 'N' RETURN END IF
           END IF
        END IF
        IF l_aag05='Y' AND g_abb.abb05 IS NOT NULL THEN
         # UPDATE aao_file SET aao05 = aao05 - l_amt_d, aao06 = aao06 - l_amt_c
         # No.+462 010725 mod by linda
           UPDATE aao_file SET aao05 = aao05 - l_amt_d, aao06 = aao06 - l_amt_c,
                               aao07 = aao07 - l_no_d,  aao08 = aao08 - l_no_c
         #No.+462 end---
               WHERE aao00 = tm.bookno AND aao01 = l_aag08  #No.FUN-740020
                     AND aao02 = g_abb.abb05
                     AND aao03 = g_aba.aba03
                     AND aao04 = g_aba.aba04
             IF STATUS THEN
#                 CALL cl_err('p109.9:upd aao',STATUS,1)   #No.FUN-660123
                  CALL cl_err3("upd","aao_file",tm.bookno,l_aag08,STATUS,"","p109.9:upd aao",1)   #No.FUN-660123  #No.FUN-740020
                          LET g_success = 'N' RETURN END IF
           #add by danny 020226 外幣管理(A002)
           IF g_aaz.aaz83 = 'Y' THEN
              UPDATE tao_file SET tao05 = tao05 - l_amt_d,
                                  tao06 = tao06 - l_amt_c,
                                  tao07 = tao07 - l_no_d,
                                  tao08 = tao08 - l_no_c,
                                  tao10 = tao10 - l_amtf_d,
                                  tao11 = tao11 - l_amtf_c
               WHERE tao00 = tm.bookno AND tao01 = l_aag08  #No.FUN-740020
                 AND tao02 = g_abb.abb05 AND tao03 = g_aba.aba03
                 AND tao04 = g_aba.aba04 AND tao09 = g_abb.abb24
                IF STATUS THEN
#                     CALL cl_err('p109.9:upd tao',STATUS,1)   #No.FUN-660123
                      CALL cl_err3("upd","tao_file",tm.bookno,l_aag08,STATUS,"","p109.9:upd tao",1)   #No.FUN-660123  #No.FUN-740020
                             LET g_success = 'N' RETURN END IF
           END IF
        END IF
--------------------}
     END IF
     #科目異動碼沖帳餘額檔
     IF g_abb.abb11 IS NOT NULL AND g_abb.abb11 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb11,'1',l_aag151)
        CALL aglp109_ted(g_abb.abb11,'1',l_aag151)
     END IF
     IF g_abb.abb12 IS NOT NULL AND g_abb.abb12 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb12,'2',l_aag161)
        CALL aglp109_ted(g_abb.abb12,'2',l_aag161)
     END IF
     IF g_abb.abb13 IS NOT NULL AND g_abb.abb13 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb13,'3',l_aag171)
        CALL aglp109_ted(g_abb.abb13,'3',l_aag171)
     END IF
     IF g_abb.abb14 IS NOT NULL AND g_abb.abb14 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb14,'4',l_aag181)
        CALL aglp109_ted(g_abb.abb14,'4',l_aag181)
     END IF

     #FUN-5C0015 BY GILL --START
     IF g_abb.abb31 IS NOT NULL AND g_abb.abb31 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb31,'5',l_aag311)
        CALL aglp109_ted(g_abb.abb31,'5',l_aag311)
     END IF
     IF g_abb.abb32 IS NOT NULL AND g_abb.abb32 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb32,'6',l_aag321)
        CALL aglp109_ted(g_abb.abb32,'6',l_aag321)
     END IF
     IF g_abb.abb33 IS NOT NULL AND g_abb.abb33 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb33,'7',l_aag331)
        CALL aglp109_ted(g_abb.abb33,'7',l_aag331)
     END IF
     IF g_abb.abb34 IS NOT NULL AND g_abb.abb34 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb34,'8',l_aag341)
        CALL aglp109_ted(g_abb.abb34,'8',l_aag341)
     END IF
     IF g_abb.abb35 IS NOT NULL AND g_abb.abb35 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb35,'9',l_aag351)
        CALL aglp109_ted(g_abb.abb35,'9',l_aag351)
     END IF
     IF g_abb.abb36 IS NOT NULL AND g_abb.abb36 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb36,'10',l_aag361)
        CALL aglp109_ted(g_abb.abb36,'10',l_aag361)
     END IF
     IF g_abb.abb37 IS NOT NULL AND g_abb.abb37 != ' ' THEN #異動碼不為空
        CALL aglp109_aed(g_abb.abb37,'99',l_aag371)
        CALL aglp109_ted(g_abb.abb37,'99',l_aag371)
     END IF

     #FUN-5C0015 BY GILL --END

     #專案管理異動資料還原 #no.5601
     IF NOT cl_null(g_abb.abb08) AND l_aag23 = 'Y' THEN
        CALL aglp109_aef(g_abb.abb08)   #專案餘額檔
      END IF

     END FOREACH
     IF g_bgjob = 'N' THEN         #FUN-570145
         display "update aba's abapost" at 2,1
     END IF
     UPDATE aba_file SET abapost = 'N'
                        ,aba38= ' '   #No.MOD-920260 add
         WHERE aba00 = tm.bookno AND aba01 = g_aba.aba01  #No.FUN-740020
        IF STATUS THEN
#          CALL cl_err('p109.c:upd aba',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("upd","aba_file",tm.bookno,g_aba.aba01,STATUS,"","p109.c:upd aba",1)   #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",g_aba.aba01                               #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('aba00,aba01',g_showmsg,'p109.c:upd aba',STATUS,1)     #NO.FUN-710023
        LET g_success = 'N' RETURN
     END IF
     IF g_bgjob = 'N' THEN         #FUN-570145
         display 'delete aea' at 2,1
     END IF
     #刪除分類帳
     DELETE FROM aea_file WHERE aea00 = tm.bookno AND aea03 = g_aba.aba01  #No.FUN-740020
       IF STATUS THEN
#         CALL cl_err('p109.d:del aea',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("del","aea_file",tm.bookno,g_aba.aba01,STATUS,"","p109.d:del aea",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
           LET g_showmsg=tm.bookno,"/",g_aba.aba01                     #NO.FUN-710023                     #No.FUN-740020
           CALL s_errmsg('aea00,aea03',g_showmsg,'p109.d:del aea',STATUS,1)     #NO.FUN-710023
                       LET g_success = 'N' RETURN END IF
     IF g_bgjob = 'N' THEN         #FUN-570145
         display 'delete aec' at 2,1
     END IF
     #刪除異動明細檔
     DELETE FROM aec_file WHERE aec00 = tm.bookno AND aec03 = g_aba.aba01  #No.FUN-740020
       IF STATUS THEN
#        CALL cl_err('p109.e:del aec',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("del","aec_file",tm.bookno,g_aba.aba01,STATUS,"","p109.e:upd aec",1)   #No.FUN-660123
         LET g_showmsg=tm.bookno,"/",g_aba.aba01                               #NO.FUN-710023                     #No.FUN-740020
         CALL s_errmsg('aec00,aec03',g_showmsg,'p109.e:del aec',STATUS,1)     #NO.FUN-710023
                       LET g_success = 'N' RETURN END IF
     #刪除專案明細檔   #no.5601
     DELETE FROM aeg_file WHERE aeg00 = tm.bookno AND aeg03 = g_aba.aba01  #No.FUN-740020
       IF STATUS THEN
#        CALL cl_err('p109.f:del aeg',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("del","aeg_file",tm.bookno,g_aba.aba01,STATUS,"","p109.f:upd aba",1)   #No.FUN-660123
         LET g_showmsg=tm.bookno,"/",g_aba.aba01                               #NO.FUN-710023                     #No.FUN-740020
         CALL s_errmsg('aeg00,aeg03',g_showmsg,'p109.f:del aeg',STATUS,1)     #NO.FUN-710023
                       LET g_success = 'N' RETURN END IF

     IF g_aba.aba06 = 'AC' THEN #若為應計傳票則利用其參考號碼為本傳票號碼做刪除
       #-------------------------MOD-C30827-------------(s)
        LET l_cnt=0
        SELECT COUNT(*) INTO l_cnt FROM aba_file
         WHERE aba00 = tm.bookno
           AND aba07 = g_aba.aba01
           AND aba06 = 'RA'
           AND abapost = 'Y'
        IF l_cnt >0 THEN
           CALL cl_err('','agl-921',1)
           LET g_success='N'
           RETURN
        END IF
       #-------------------------MOD-C30827-------------(e)
        IF g_bgjob = 'N' THEN         #FUN-570145
           display 'delete AC aba,abb' at 2,1
        END IF
##No.3036 modify 1999/03/10
        SELECT COUNT(*) INTO g_cnt FROM aea_file
         WHERE aea00=tm.bookno  #No.FUN-740020
           AND aea03= (SELECT aba01 FROM aba_file
                        WHERE aba00 = tm.bookno  #No.FUN-740020
                          AND aba06 = 'RA'
                          AND aba07 = g_aba.aba01)
        IF g_cnt > 0 THEN
           DELETE FROM aea_file WHERE aea00=tm.bookno  #No.FUN-740020
                                  AND aea03= (SELECT aba01 FROM aba_file
                                               WHERE aba00 = tm.bookno  #No.FUN-740020
                                               AND aba06 = 'RA'
                                               AND aba07 = g_aba.aba01)
            IF STATUS THEN
#             CALL cl_err('p109.f:del AC aea',STATUS,1)   #No.FUN-660123
#             CALL cl_err3("del","aea_file",tm.bookno,g_aba.aba01,STATUS,"","p109.f:del AC aea",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
              CALL s_errmsg('aea00',tm.bookno,'p109.f:del AC aea',STATUS,1)     #NO.FUN-710023       #NO.FUN-710023  #No.FUN-740020
              LET g_success = 'N' RETURN
            END IF
        END IF
##No.3080 modify 1999/04/08
        INITIALIZE l_aba.* TO NULL
        INITIALIZE l_abb.* TO NULL
        INITIALIZE l_aag.* TO NULL
        DECLARE p109_return CURSOR FOR
         SELECT * FROM aba_file,abb_file LEFT OUTER JOIN aag_file ON abb03 = aag01 AND abb00 = aag00
          WHERE aba00 = tm.bookno  #No.FUN-740020
            AND aba01 = (SELECT aba01 FROM aba_file
                          WHERE aba00 = tm.bookno  #No.FUN-740020
                            AND aba06 = 'RA'
                            AND aba07 = g_aba.aba01)
            AND aba00 = abb00
            AND aba01 = abb01
            AND abapost = 'Y'   #No.MOD-910187
        FOREACH p109_return INTO l_aba.*,l_abb.*,l_aag.*
           IF STATUS THEN
#           CALL cl_err('foreach return',STATUS,0) EXIT FOREACH     #NO.FUN-710023
#          CALL s_errmsg('aba00',tm.bookno,'foreach return',STATUS,0)    #NO.FUN-710023   #No.FUN-740020
           CALL s_errmsg('aba00',tm.bookno,'foreach return',STATUS,1)    #NO.FUN-710023   #No.FUN-740020 #FUN-740200
           END IF
           CALL re_aah(l_aag.aag07,l_aag.aag08)
           IF g_success = 'N' THEN EXIT FOREACH END IF
           IF g_aaz.aaz51 = 'Y' THEN  #No.MOD-920374
              CALL re_aas(l_aag.aag07,l_aag.aag08)
              IF g_success = 'N' THEN EXIT FOREACH END IF
           END IF #No.MOD-920374
           IF l_aag.aag05 = 'Y' AND NOT cl_null(l_abb.abb05) THEN  #No.MOD-920374
              CALL re_aao(l_aag.aag07,l_aag.aag08)
              IF g_success = 'N' THEN EXIT FOREACH END IF
           END IF   #No.MOD-920374
           CALL re_afc()
           IF g_success = 'N' THEN EXIT FOREACH END IF
           CALL re_aed()
           IF g_success = 'N' THEN EXIT FOREACH END IF
           #no.A002
           IF g_aaz.aaz83 = 'Y' THEN   #No.MOD-920374
              CALL re_tah(l_aag.aag07,l_aag.aag08)
              IF g_success = 'N' THEN EXIT FOREACH END IF
           END IF    #No.MOD-920374
           IF g_aaz.aaz51 = 'Y' AND g_aaz.aaz83 = 'Y' THEN   #No.MOD-920374
              CALL re_tas(l_aag.aag07,l_aag.aag08)
              IF g_success = 'N' THEN EXIT FOREACH END IF
           END IF   #No.MOD-920374
           IF l_aag.aag05 = 'Y' AND NOT cl_null(l_abb.abb05) AND g_aaz.aaz83 = 'Y' THEN  #No.MOD-920374
           CALL re_tao(l_aag.aag07,l_aag.aag08)
           IF g_success = 'N' THEN EXIT FOREACH END IF
           END IF   #No.MOD-920374
           #no.A002(end)
           #No.FUN-9A0052  --Begin
           CALL aglp109_aeh(l_aba.*,l_abb.*)
           #No.FUN-9A0052  --End
        END FOREACH
##----------------------------
       #-------------------------MOD-C30827-------------(s)
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM aba_file
         WHERE aba00 = tm.bookno
           AND aba07 = g_aba.aba01
           AND aba06 = 'RA'
           AND abapost = 'N'
           AND aba19 = 'N'              #未確認
        IF l_cnt > 0 THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM abb_file,aag_file
            WHERE abb03 = aag01
              AND abb00 = aag00
              AND aag20 = 'Y'
              AND abb00 = tm.bookno
              AND abb01 IN (SELECT aba01 FROM aba_file
                             WHERE aba00 = tm.bookno
                               AND aba07 = g_aba.aba01
                               AND aba06 = 'RA'
                               AND abapost = 'N')
           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
           IF l_cnt > 0 THEN
              MESSAGE "delete abh's (RA)  "
              LET g_sql = "SELECT * FROM abh_file ",
                          " WHERE abh00 = '",tm.bookno,"'",
                          "   AND abh01 IN (SELECT aba01 FROM aba_file ",
                          "                  WHERE aba00 = '",tm.bookno,"'",
                          "                    AND aba06 = 'RA' ",
                          "                    AND aba07 = '",g_aba.aba01,"')"
              PREPARE abh_pre  FROM g_sql
              DECLARE abh_curs  CURSOR FOR abh_pre
              FOREACH abh_curs  INTO l_abh.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('',SQLCA.sqlcode,0)
                   EXIT FOREACH
                END IF
                DELETE FROM abh_file WHERE abh00=l_abh.abh00
                                       AND abh01=l_abh.abh01
                                       AND abh02=l_abh.abh02

                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                   CALL cl_err3("del","abh_file",tm.bookno,"",SQLCA.sqlcode,"","(s_eom:ckp#2b)",1)
                   LET g_success='N'
                   RETURN
                END IF

                SELECT SUM(abh09) INTO l_abh09 FROM abh_file
                 WHERE abhconf = 'Y'
                   AND abh07 = l_abh.abh07
                   AND abh08 = l_abh.abh08
                   AND abh00 = l_abh.abh00
                IF cl_null(l_abh09) THEN LET l_abh09=0 END IF
                SELECT SUM(abh09) INTO l_abh09_2 FROM abh_file
                 WHERE abhconf = 'N'
                   AND abh07 = l_abh.abh07
                   AND abh08 = l_abh.abh08
                   AND abh00 = l_abh.abh00
                IF cl_null(l_abh09_2) THEN LET l_abh09_2=0 END IF
                UPDATE abg_file SET abg072 = l_abh09,
                                    abg073 = l_abh09_2
                              WHERE abg00 = tm.bookno
                                AND abg01 = l_abh.abh07
                                AND abg02=l_abh.abh08
              END FOREACH
           END IF
        END IF
       #-------------------------MOD-C30827-------------(e)
        #FUN-B40056 --begin
        DELETE FROM tic_file WHERE tic00 = tm.bookno AND   #No.FUN-740020
                                      tic04 = (SELECT aba01 FROM aba_file
                                                    WHERE aba00 = tm.bookno AND 
                                                          aba06 = 'RA' AND
                                                          aba07 = g_aba.aba01)
       #---------------------------------MOD-C10222------------------------------------mark
       #IF STATUS THEN
       #   CALL cl_err3("del","tic_file",tm.bookno,"",STATUS,"","p109.f:del AC abb",1)
       #   LET g_success = 'N' 
       #   RETURN 
       #END IF
       #---------------------------------MOD-C10222------------------------------------mark
        #FUN-B40056 --end
        
        DELETE FROM abb_file WHERE abb00 = tm.bookno AND   #No.FUN-740020
                                      abb01 = (SELECT aba01 FROM aba_file
                                                    WHERE aba00 = tm.bookno AND  #No.FUN-740020
                                                          aba06 = 'RA' AND
                                                          aba07 = g_aba.aba01)
          IF STATUS THEN
#            CALL cl_err('p109.f:del AC abb',STATUS,1)   #No.FUN-660123
             CALL cl_err3("del","abb_file",tm.bookno,"",STATUS,"","p109.f:del AC abb",1)   #No.FUN-660123  #No.FUN-740020
                          LET g_success = 'N' RETURN END IF
        DELETE FROM aba_file WHERE aba00 = tm.bookno AND   #No.FUN-740020
                                   aba06 = 'RA' AND
                                   aba07 = g_aba.aba01
          IF STATUS THEN
#           CALL cl_err('p109.g:del AC aba',STATUS,1)   #No.FUN-660123
            CALL cl_err3("del","aba_file",tm.bookno,g_aba.aba01,STATUS,"","p109.g:del AC aba",1)   #No.FUN-660123  #No.FUN-740020
                          LET g_success = 'N' RETURN END IF
     END IF

END FUNCTION

#add 020814 NO.A030
FUNCTION aglp109_upd(p_aag08,amt_d,amt_c,no_d,no_c,amtf_d,amtf_c,p_aag05)
    DEFINE p_aag05       LIKE aag_file.aag05
    DEFINE p_aag08       LIKE aag_file.aag08
    DEFINE amt_d,amt_c   LIKE aah_file.aah04
    DEFINE no_d,no_c     LIKE aah_file.aah06
    DEFINE amtf_d,amtf_c LIKE tah_file.tah09

    UPDATE aah_file SET aah04 = aah04 - amt_d, aah05 = aah05 - amt_c,
                        aah06 = aah06 - no_d,  aah07 = aah07 - no_c
     WHERE aah00 = tm.bookno    AND aah01 = p_aag08  #No.FUN-740020
       AND aah02 = g_aba.aba03 AND aah03 = g_aba.aba04
    IF STATUS THEN
#      CALL cl_err('p109.8:upd aah',STATUS,1)  #No.FUN-660123
#      CALL cl_err3("upd","aah_file",tm.bookno,p_aag08,STATUS,"","p109.8:upd aah",1)   #No.FUN-660123 #NO.FUN-710023
       LET g_showmsg=tm.bookno,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04             #NO.FUN-710023                     #No.FUN-740020
       CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'p109.7:upd too',STATUS,1)   #NO.FUN-710023
       LET g_success = 'N' RETURN
    END IF
    #add by danny 020226 外幣管理(A002)
    IF g_aaz.aaz83 = 'Y' THEN
       UPDATE tah_file SET tah04 = tah04 - amt_d, tah05 = tah05 - amt_c,
                           tah06 = tah06 - no_d,  tah07 = tah07 - no_c,
                           tah09 = tah09 - amtf_d,tah10 = tah10 - amtf_c
        WHERE tah00 = tm.bookno    AND tah01 = p_aag08  #No.FUN-740020
          AND tah02 = g_aba.aba03 AND tah03 = g_aba.aba04
          AND tah08 = g_abb.abb24
       IF STATUS THEN
#         CALL cl_err('p109.8:upd tah',STATUS,1)    #No.FUN-660123
#         CALL cl_err3("upd","tah_file",tm.bookno,p_aag08,STATUS,"","p109.8:upd tah",1)    #No.FUN-660123 #NO.FUN-710023
         LET g_showmsg=tm.bookno,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24 #NO.FUN-710023                     #No.FUN-740020
         CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'p109.8:upd tah',STATUS,1) #NO.FUN-710023
         LET g_success = 'N' RETURN
       END IF
    END IF
    IF g_aaz.aaz51 = 'Y' THEN
       UPDATE aas_file SET aas04 = aas04 - amt_d, aas05 = aas05 - amt_c,
                           aas06 = aas06 - no_d,  aas07 = aas07 - no_c
        WHERE aas00 = tm.bookno AND aas01 = p_aag08  #No.FUN-740020
          AND aas02 = g_aba.aba02
       IF STATUS THEN
#        CALL cl_err('p109.9:upd aas',STATUS,1)  #No.FUN-660123
#        CALL cl_err3("upd","aas_file",tm.bookno,p_aag08,STATUS,"","p109.9:upd aas",1)   #No.FUN-660123 #NO.FUN-710023
         LET g_showmsg=tm.bookno,"/",p_aag08,"/",g_aba.aba02                             #NO.FUN-710023     #No.FUN-740020
         CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'p109.9:upd aas',STATUS,1) #NO.FUN-710023
          LET g_success = 'N' RETURN
       END IF
       #add by danny 020226 外幣管理(A002)
       IF g_aaz.aaz83 = 'Y' THEN
          UPDATE tas_file SET tas04 = tas04 - amt_d, tas05 = tas05 - amt_c,
                              tas06 = tas06 - no_d,  tas07 = tas07 - no_c,
                              tas09 = tas09 - amtf_d,tas10 = tas10 - amtf_c
           WHERE tas00 = tm.bookno    AND tas01 = p_aag08  #No.FUN-740020
             AND tas02 = g_aba.aba02 AND tas08 = g_abb.abb24
          IF STATUS THEN
#            CALL cl_err('p109.9:upd tas',STATUS,1)    #No.FUN-660123
#            CALL cl_err3("upd","tas_file",tm.bookno,p_aag08,STATUS,"","p109.9:upd tas",1)   #No.FUN-660123 #NO.FUN-710023
             LET g_showmsg=tm.bookno,"/",p_aag08,"/",g_aba.aba02,"/",g_abb.abb24             #NO.FUN-710023     #No.FUN-740020
             CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'p109.9:upd tas',STATUS,1)   #NO.FUN-710023
             LET g_success = 'N' RETURN
          END IF
       END IF
    END IF
    IF p_aag05='Y' AND g_abb.abb05 IS NOT NULL THEN
       UPDATE aao_file SET aao05 = aao05 - amt_d, aao06 = aao06 - amt_c,
                           aao07 = aao07 - no_d,  aao08 = aao08 - no_c
        WHERE aao00 = tm.bookno    AND aao01 = p_aag08  #No.FUN-740020
          AND aao02 = g_abb.abb05 AND aao03 = g_aba.aba03
          AND aao04 = g_aba.aba04
       IF STATUS THEN
#         CALL cl_err('p109.9:upd aao',STATUS,1) #No.FUN-660123
#          CALL cl_err3("upd","aao_file",tm.bookno,p_aag08,STATUS,"","p109.9:upd aao",1)   #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",p_aag08,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04            #NO.FUN-710023     #No.FUN-740020
           CALL s_errmsg('aao00,aao01,aao02,aao03,aao04',g_showmsg,'p109.9:upd aoo',STATUS,1)   #NO.FUN-710023
          LET g_success = 'N' RETURN
       END IF
       #add by danny 020226 外幣管理(A002)
       IF g_aaz.aaz83 = 'Y' THEN
          UPDATE tao_file SET tao05 = tao05 - amt_d, tao06 = tao06 - amt_c,
                              tao07 = tao07 - no_d,  tao08 = tao08 - no_c,
                              tao10 = tao10 - amtf_d,tao11 = tao11 - amtf_c
           WHERE tao00 = tm.bookno    AND tao01 = p_aag08  #No.FUN-740020
             AND tao02 = g_abb.abb05 AND tao03 = g_aba.aba03
             AND tao04 = g_aba.aba04 AND tao09 = g_abb.abb24
         IF STATUS THEN
#          CALL cl_err('p109.9:upd tao',STATUS,1)  #No.FUN-660123
#          CALL cl_err3("upd","tao_file",tm.bookno,p_aag08,STATUS,"","p109.9:upd tao",1)                        #No.FUN-660123 #NO.FUN-710023
           LET g_showmsg=tm.bookno,"/",p_aag08,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24  #NO.FUN-710023     #No.FUN-740020
           CALL s_errmsg('tao00,tao01,tao02,tao03,tao04,tao09',g_showmsg,'p109.9:upd aoo',STATUS,1)            #NO.FUN-710023
           LET g_success = 'N' RETURN
         END IF
       END IF
    END IF
END FUNCTION

#MODIFY BY MAY '92/07/10'  因多加aed_file處理類aah_file要反調
FUNCTION aglp109_aed(p_key,p_key2,p_flag)
DEFINE  p_key   LIKE aed_file.aed02,        #異動碼               #No.FUN-680098  VARCHAR(20)
        p_key2  LIKE aed_file.aed011,       #FUN-5C0015 BY GILL   #No.FUN-680098  VARCHAR(1)
        p_flag  LIKE type_file.chr1                               #No.FUN-680098  VARCHAR(1)
     IF g_bgjob = 'N' THEN         #FUN-570145
         display 'update aed' at 2,1
     END IF
     IF g_abb.abb06 = '1' THEN
        UPDATE aed_file SET aed05 = aed05 - g_abb.abb07,
                            aed07 = aed07 - 1
               WHERE aed01 = g_abb.abb03 AND
                     aed02 = p_key AND aed03 = g_aba.aba03 AND
                     aed011= p_key2 AND aed04 = g_aba.aba04
## No:2806 modify 1998/11/19 ----------------------------
                 AND aed00 = tm.bookno  #No.FUN-740020
## ------------------------------------------------------
     END IF
     IF g_abb.abb06 = '2' THEN
        UPDATE aed_file SET aed06 = aed06 - g_abb.abb07,
                            aed08 = aed08 - 1
               WHERE aed01 = g_abb.abb03 AND
                     aed02 = p_key AND aed03 = g_aba.aba03 AND
                     aed011= p_key2 AND aed04 = g_aba.aba04
## No:2806 modify 1998/11/19 ----------------------------
                 AND aed00 = tm.bookno  #No.FUN-740020
## ------------------------------------------------------
     END IF
## No:2516 modify 1998/10/13 --------------
{
     IF p_flag IS NULL OR p_flag MATCHES "[12]" THEN
        DELETE FROM aee_file
            WHERE aee01 = g_abb.abb03
              AND aee02 = p_key2   AND aee03 = p_key
              AND aee05 = g_aba.aba01 AND aee06 = g_aba.aba02
     END IF
}
END FUNCTION

FUNCTION aglp109_ted(p_key,p_key2,p_flag)
DEFINE  p_key  LIKE aed_file.aed02,              #異動碼         #No.FUN-680098  VARCHAR(20)
        p_key2 LIKE aed_file.aed011,     #FUN-5C0015 BY GILL     #No.FUN-680098  VARCHAR(1)
        p_flag LIKE type_file.chr1                               #No.FUN-680098  VARCHAR(1)

     #add by danny 020228 外幣管理(A002)
     IF g_aaz.aaz83 = 'N' THEN RETURN END IF
     IF g_bgjob = 'N' THEN         #FUN-570145
         display 'update ted' at 2,1
     END IF
     IF g_abb.abb06 = '1' THEN
        UPDATE ted_file SET ted05 = ted05 - g_abb.abb07,
                            ted07 = ted07 - 1,
                            ted10 = ted10 - g_abb.abb07f
               WHERE ted01 = g_abb.abb03 AND ted02 = p_key
                 AND ted03 = g_aba.aba03 AND ted011= p_key2
                 AND ted04 = g_aba.aba04 AND ted00 = tm.bookno  #No.FUN-740020
                 AND ted09 = g_abb.abb24
     END IF
     IF g_abb.abb06 = '2' THEN
        UPDATE ted_file SET ted06 = ted06 - g_abb.abb07,
                            ted08 = ted08 - 1,
                            ted11 = ted11 - g_abb.abb07f
               WHERE ted01 = g_abb.abb03 AND ted02 = p_key
                 AND ted03 = g_aba.aba03 AND ted011= p_key2
                 AND ted04 = g_aba.aba04 AND ted00 = tm.bookno  #No.FUN-740020
                 AND ted09 = g_abb.abb24
     END IF
END FUNCTION

#No.FUN-9A0052  --Begin
FUNCTION aglp109_aeh(p_aba,p_abb)
   DEFINE p_aba        RECORD LIKE aba_file.*
   DEFINE p_abb        RECORD LIKE abb_file.*
   DEFINE l_sql        STRING
   DEFINE l_amt_d      LIKE type_file.num20_6
   DEFINE l_amt_c      LIKE type_file.num20_6
   DEFINE l_amtf_d     LIKE type_file.num20_6
   DEFINE l_amtf_c     LIKE type_file.num20_6
   DEFINE l_no_d       LIKE type_file.num5
   DEFINE l_no_c       LIKE type_file.num5

     IF g_bgjob = 'N' THEN
         display 'update aeh_file' at 2,1
     END IF
     LET l_amt_d  = 0    LET l_amt_c  = 0
     LET l_amtf_d = 0    LET l_amtf_c = 0
     LET l_no_d   = 0    LET l_no_c   = 0
     IF p_abb.abb06 = '1' THEN
        LET l_amt_d  = p_abb.abb07
        LET l_amtf_d = p_abb.abb07f
        LET l_no_d   = 1
     ELSE
        LET l_amt_c  = p_abb.abb07
        LET l_amtf_c = p_abb.abb07f
        LET l_no_c   = 1
     END IF
     LET l_sql = " UPDATE aeh_file SET aeh11 = aeh11 - ",l_amt_d ,",",
                                    "  aeh12 = aeh12 - ",l_amt_c ,",",
                                    "  aeh13 = aeh13 - ",l_no_d  ,",",
                                    "  aeh14 = aeh14 - ",l_no_c  ,",",
                                    "  aeh15 = aeh15 - ",l_amtf_d,",",
                                    "  aeh16 = aeh16 - ",l_amtf_c,
                 "  WHERE aeh00 = '",p_abb.abb00,"'",
                 "    AND aeh01 = '",p_abb.abb03,"'",
                 "    AND aeh09 =  ",p_aba.aba03,
                 "    AND aeh10 =  ",p_aba.aba04,
                 "    AND aeh17 = '",p_abb.abb24,"'"

     IF cl_null(p_abb.abb05) THEN
        LET l_sql = l_sql CLIPPED," AND aeh02=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh02='",p_abb.abb05,"'"
     END IF
     IF cl_null(p_abb.abb08) THEN
        LET l_sql = l_sql CLIPPED," AND aeh03=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh03='",p_abb.abb08,"'"
     END IF
     IF cl_null(p_abb.abb11) THEN
        LET l_sql = l_sql CLIPPED," AND aeh04=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh04='",p_abb.abb11,"'"
     END IF
     IF cl_null(p_abb.abb12) THEN
        LET l_sql = l_sql CLIPPED," AND aeh05=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh05='",p_abb.abb12,"'"
     END IF
     IF cl_null(p_abb.abb13) THEN
        LET l_sql = l_sql CLIPPED," AND aeh06=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh06='",p_abb.abb13,"'"
     END IF
     IF cl_null(p_abb.abb14) THEN
        LET l_sql = l_sql CLIPPED," AND aeh07=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh07='",p_abb.abb14,"'"
     END IF
     IF cl_null(p_abb.abb15) THEN
        LET l_sql = l_sql CLIPPED," AND aeh08=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh08='",p_abb.abb15,"'"
     END IF
     IF cl_null(p_abb.abb31) THEN
        LET l_sql = l_sql CLIPPED," AND aeh31=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh31='",p_abb.abb31,"'"
     END IF
     IF cl_null(p_abb.abb32) THEN
        LET l_sql = l_sql CLIPPED," AND aeh32=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh32='",p_abb.abb32,"'"
     END IF
     IF cl_null(p_abb.abb33) THEN
        LET l_sql = l_sql CLIPPED," AND aeh33=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh33='",p_abb.abb33,"'"
     END IF
     IF cl_null(p_abb.abb34) THEN
        LET l_sql = l_sql CLIPPED," AND aeh34=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh34='",p_abb.abb34,"'"
     END IF
     IF cl_null(p_abb.abb35) THEN
        LET l_sql = l_sql CLIPPED," AND aeh35=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh35='",p_abb.abb35,"'"
     END IF
     IF cl_null(p_abb.abb36) THEN
        LET l_sql = l_sql CLIPPED," AND aeh36=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh36='",p_abb.abb36,"'"
     END IF
     IF cl_null(p_abb.abb37) THEN
        LET l_sql = l_sql CLIPPED," AND aeh37=' '"
     ELSE
        LET l_sql = l_sql CLIPPED," AND aeh37='",p_abb.abb37,"'"
     END IF
     PREPARE aeh_p1 FROM l_sql
     EXECUTE aeh_p1
     IF STATUS THEN
        LET g_showmsg=p_aba.aba00,"/",p_abb.abb03,"/",p_aba.aba03,"/",p_aba.aba04,"/",p_abb.abb24
        CALL s_errmsg('aeh00,aeh01,aeh09,aeh10,aeh17',g_showmsg,'p109.9:upd aeh',STATUS,1)
        LET g_success = 'N' RETURN
     END IF
END FUNCTION
#No.FUN-9A0052  --End

FUNCTION re_aah(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07      #No.FUN-680098    VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08      #No.FUN-680098    VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE type_file.num20_6   #No.FUN-4C0009    #No.FUN-680098  DECIMAL(20,6)
    DEFINE rec_d,rec_c  LIKE type_file.num5      #No.FUN-680098    SMALLINT
    DEFINE l_i        	LIKE type_file.num5      #No.FUN-680098    SMALLINT
    DEFINE l_aag08      LIKE aag_file.aag08
    DEFINE m_aag08      LIKE aag_file.aag08    #add 030926 NO.A092
    DEFINE l_aag24      LIKE aag_file.aag24

    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = l_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aah_file SET aah04 = aah04 - amt_d,
                        aah05 = aah05 - amt_c,
                        aah06 = aah06 - rec_d,
                        aah07 = aah07 - rec_c
          WHERE aah00=l_aba.aba00 AND aah01=l_abb.abb03
            AND aah02=l_aba.aba03 AND aah03=l_aba.aba04
          IF STATUS THEN
#            CALL cl_err('upd aah:',STATUS,1)  #No.FUN-660123
#            CALL cl_err3("upd","aah_file",l_aba.aba00,l_abb.abb03,STATUS,"","upd aah:",1)   #No.FUN-660123 #NO.FUN-710023
             LET g_showmsg=l_aba.aba00,"/",l_abb.abb03,"/",l_aba.aba03,"/",l_aba.aba04       #NO.FUN-710023
             CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd aah:',STATUS,1)           #NO.FUN-710023
             LET g_success='N' RETURN
          END IF
   #modify 020814  NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL re_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
      #modify 030926 NO.A092
     #IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08
            AND aag00 = tm.bookno   #TQC-7C0029
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
           # CALL re_aah_2(l_aag08,amt_d,amt_c,rec_d,rec_c)
             CALL re_aah_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08
                                                       AND aag00 = tm.bookno   #TQC-7C0029
         END FOR
     #END IF
   END IF
END FUNCTION

#add 020814  NO.A030
FUNCTION re_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE p_aag08      LIKE aag_file.aag08
   DEFINE amt_d,amt_c  LIKE aah_file.aah04
   DEFINE rec_d,rec_c  LIKE aah_file.aah06

   UPDATE aah_file SET aah04 = aah04 - amt_d, aah05 = aah05 - amt_c,
                       aah06 = aah06 - rec_d, aah07 = aah07 - rec_c
    WHERE aah00=l_aba.aba00 AND aah01=p_aag08
      AND aah02=l_aba.aba03 AND aah03=l_aba.aba04
   IF STATUS THEN
#     CALL cl_err('upd aah(2):',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","aah_file",l_aba.aba00,p_aag08,STATUS,"","upd aah(2):",1)   #No.FUN-660123
      LET g_showmsg=l_aba.aba00,"/",p_aag08,"/",l_aba.aba03,"/",l_aba.aba04          #NO.FUN-710023
      CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd aah(2):',STATUS,1)      #NO.FUN-710023
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION re_tah(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07      #No.FUN-680098   VARCHAR(1)
    DEFINE p_aag08	 LIKE aag_file.aag08      #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE type_file.num20_6   #No.FUN-4C0009    #No.FUN-680098  DECIMAL(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No.FUN-4C0009     #No.FUN-680098  DECIMAL(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5                        #No.FUN-680098  SMALLINT
    DEFINE l_i        	 LIKE type_file.num5                        #No.FUN-680098  SMALLINT
    DEFINE l_aag08       LIKE aag_file.aag08
    DEFINE m_aag08       LIKE aag_file.aag08       #add 030926 NO.A092
    DEFINE l_aag24       LIKE aag_file.aag24

    #add by danny 020228 外幣管理(A002)
    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= l_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = l_abb.abb07  LET rec_c = 1
            LET amtf_c= l_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tah_file SET tah04 = tah04 - amt_d,
                        tah05 = tah05 - amt_c,
                        tah06 = tah06 - rec_d,
                        tah07 = tah07 - rec_c,
                        tah09 = tah09 - amtf_d,
                        tah10 = tah10 - amtf_c
          WHERE tah00=l_aba.aba00 AND tah01=l_abb.abb03
            AND tah02=l_aba.aba03 AND tah03=l_aba.aba04
            AND tah08=l_abb.abb24
          IF STATUS THEN
#            CALL cl_err('upd tah:',STATUS,1)  #No.FUN-660123
             CALL cl_err3("upd","tah_file",l_aba.aba00,l_abb.abb03,STATUS,"","upd tah:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
   #modify 020814  NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL re_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
      #modify 030926  NO.A092
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08
            AND aag00 = tm.bookno   #TQC-7C0029
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
           # CALL re_tah_2(l_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             CALL re_tah_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08
                                                       AND aag00 = tm.bookno   #TQC-7C0029
         END FOR
    # END IF
   END IF
END FUNCTION

#add 020814  NO.A030
FUNCTION re_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE p_aag08        LIKE aag_file.aag08
   DEFINE amt_d,amt_c    LIKE tah_file.tah04
   DEFINE rec_d,rec_c    LIKE aah_file.aah06
   DEFINE amtf_d,amtf_c  LIKE tah_file.tah09

   UPDATE tah_file SET tah04 = tah04 - amt_d, tah05 = tah05 - amt_c,
                       tah06 = tah06 - rec_d, tah07 = tah07 - rec_c,
                       tah09 = tah09 - amtf_d,tah10 = tah10 - amtf_c
    WHERE tah00=l_aba.aba00 AND tah01=p_aag08
      AND tah02=l_aba.aba03 AND tah03=l_aba.aba04
      AND tah08=l_abb.abb24
   IF STATUS THEN
#     CALL cl_err('upd tah(2):',STATUS,1)   #No.FUN-660123
      CALL cl_err3("upd","tah_file",l_aba.aba00,p_aag08,STATUS,"","upd tah(2):",1)   #No.FUN-660123
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION re_aas(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07     #No.FUN-680098   VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08     #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c  LIKE tah_file.tah04     #No.FUN-4C0009   #No.FUN-680098  DECIMAL(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5     #No.FUN-680098   SMALLINT
    DEFINE l_i          LIKE type_file.num5     #No.FUN-680098   SMALLINT
    DEFINE l_aag08      LIKE aag_file.aag08
    DEFINE m_aag08      LIKE aag_file.aag08     #add 030926 NO.A092
    DEFINE l_aag24      LIKE aag_file.aag24

    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = l_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aas_file SET  aas04 = aas04-amt_d,
                         aas05 = aas05-amt_c,
                         aas06 = aas06-rec_d,
                         aas07 = aas07-rec_c
          WHERE aas00=l_aba.aba00 AND aas01=l_abb.abb03 AND aas02=l_aba.aba02
          IF STATUS THEN
#            CALL cl_err('upd aas:',STATUS,1)    #No.FUN-660123
             CALL cl_err3("upd","aas_file",l_aba.aba00,l_abb.abb03,STATUS,"","upd aas:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
   #modify 020814  NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL re_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
       #modify 030926  NO.A092
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08
            AND aag00 = tm.bookno   #TQC-7C0029
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
           # CALL re_aas_2(l_aag08,amt_d,amt_c,rec_d,rec_c)
             CALL re_aas_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08
                                                       AND aag00 = tm.bookno   #TQC-7C0029
         END FOR
    # END IF
   END IF
END FUNCTION

#add 020814  NO.A030
FUNCTION re_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE p_aag08      LIKE aag_file.aag08
   DEFINE amt_d,amt_c  LIKE aah_file.aah04
   DEFINE rec_d,rec_c  LIKE aah_file.aah06

      UPDATE aas_file SET  aas04 = aas04-amt_d,
                           aas05 = aas05-amt_c,
                           aas06 = aas06-rec_d,
                           aas07 = aas07-rec_c
              WHERE aas00=l_aba.aba00 AND aas01=p_aag08 AND aas02=l_aba.aba02
   IF STATUS THEN
#     CALL cl_err('upd aas(2):',STATUS,1)    #No.FUN-660123
      CALL cl_err3("upd","aas_file",l_aba.aba00,p_aag08,STATUS,"","upd aas(2):",1)   #No.FUN-660123
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION re_tas(p_aag07,p_aag08)
    DEFINE p_aag07 	 LIKE aag_file.aag07   #No.FUN-680098   VARCHAR(1)
    DEFINE p_aag08	 LIKE aag_file.aag08   #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE tah_file.tah04   #No.FUN-4C0009   #No.FUN-680098   DECIMAL(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6#No.FUN-4C0009   #No.FUN-680098   DECIMAL(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5   #No.FUN-680098   SMALLINT
    DEFINE l_i           LIKE type_file.num5   #No.FUN-680098   SMALLINT
    DEFINE l_aag08       LIKE aag_file.aag08
    DEFINE m_aag08       LIKE aag_file.aag08     #add 030926 NO.A092
    DEFINE l_aag24       LIKE aag_file.aag24

    #add by danny 020226 外幣管理(A002)
    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= l_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = l_abb.abb07  LET rec_c = 1
            LET amtf_c= l_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tas_file SET tas04=tas04-amt_d,
                        tas05=tas05-amt_c,
                        tas06=tas06-rec_d,
                        tas07=tas07-rec_c,
                        tas09=tas09-amtf_d,
                        tas10=tas10-amtf_c
          WHERE tas00=l_aba.aba00 AND tas01=l_abb.abb03 AND tas02=l_aba.aba02
            AND tas08=l_abb.abb24
          IF STATUS THEN
#            CALL cl_err('upd tas:',STATUS,1)    #No.FUN-660123
             CALL cl_err3("upd","tas_file",l_aba.aba00,l_abb.abb03,STATUS,"","upd tas:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
   #modify 020814  NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL re_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
      #modify 030926  NO.A092
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08
            AND aag00 = tm.bookno   #TQC-7C0029
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
           # CALL re_tas_2(l_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             CALL re_tas_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08
                                                       AND aag00 = tm.bookno   #TQC-7C0029
         END FOR
    # END IF
   END IF
END FUNCTION

#add 020814  NO.A030
FUNCTION re_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE p_aag08        LIKE aag_file.aag08
   DEFINE amt_d,amt_c	 LIKE tah_file.tah04     #No.FUN-4C0009   #No.FUN-680098 DECIMAL(20,6)
   DEFINE amtf_d,amtf_c  LIKE type_file.num20_6  #No.FUN-4C0009   #No.FUN-680098 DECIMAL(20,6)
   DEFINE rec_d,rec_c    LIKE type_file.num5                      #No.FUN-680098 SMALLINT

   UPDATE tas_file SET tas04=tas04-amt_d, tas05=tas05-amt_c,
                       tas06=tas06-rec_d, tas07=tas07-rec_c,
                       tas09=tas09-amtf_d,tas10=tas10-amtf_c
    WHERE tas00=l_aba.aba00 AND tas01=p_aag08
      AND tas02=l_aba.aba02 AND tas08=l_abb.abb24
   IF STATUS THEN
#     CALL cl_err('upd tas(2):',STATUS,1)    #No.FUN-660123
      CALL cl_err3("upd","tas_file",l_aba.aba00,p_aag08,STATUS,"","upd tas(2):",1)   #No.FUN-660123
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION re_aao(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07      #No.FUN-680098    VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08      #No.FUN-680098    VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE type_file.num20_6   #No.FUN-4C0009     #No.FUN-680098  DECIMAL(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5      #No.FUN-680098     SMALLINT
    DEFINE l_i          LIKE type_file.num5      #No.FUN-680098     SMALLINT
    DEFINE l_aag08      LIKE aag_file.aag08
    DEFINE m_aag08      LIKE aag_file.aag08      #add 030926 NO.A092
    DEFINE l_aag24      LIKE aag_file.aag24

    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = l_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aao_file SET aao05 = aao05 - amt_d,
                        aao06 = aao06 - amt_c,
                        aao07 = aao07 - rec_d,
                        aao08 = aao08 - rec_c
          WHERE aao00=l_aba.aba00 AND aao01=l_abb.abb03 AND aao02=l_abb.abb05
            AND aao03=l_aba.aba03 AND aao04=l_aba.aba04
          IF STATUS THEN
#            CALL cl_err('upd aao:',STATUS,1)   #No.FUN-660123
             CALL cl_err3("upd","aao_file",l_aba.aba00,l_abb.abb03,STATUS,"","upd aao:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
   #modify 020814  NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
     #CALL re_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)                 #No.A056  #No.MOD-920374 mark
      CALL re_aao_2(p_aag08,amt_d,amt_c,rec_d,rec_c)                 #No.A056  #No.MOD-920374
     #modify 030926  NO.A092
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08
            AND aag00 = tm.bookno   #TQC-7C0029
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
           # CALL re_aas_2(l_aag08,amt_d,amt_c,rec_d,rec_c)          #No.A056
            #CALL re_aas_2(m_aag08,amt_d,amt_c,rec_d,rec_c)          #No.A056  #No.MOD-920374 mark
             CALL re_aao_2(m_aag08,amt_d,amt_c,rec_d,rec_c)          #No.A056  #no.MOD-920374
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08
                                                       AND aag00 = tm.bookno   #TQC-7C0029
         END FOR
    # END IF
   END IF
END FUNCTION

#add 020814  NO.A030
FUNCTION re_aao_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE p_aag08        LIKE aag_file.aag08
   DEFINE amt_d,amt_c	 LIKE type_file.num20_6  #No.FUN-4C0009    #No.FUN-680098 DECIMAL(20,6)
   DEFINE rec_d,rec_c	 LIKE type_file.num5     #No.FUN-680098    SMALLINT

   UPDATE aao_file SET aao05 = aao05 - amt_d, aao06 = aao06 - amt_c,
                       aao07 = aao07 - rec_d, aao08 = aao08 - rec_c
    WHERE aao00=l_aba.aba00 AND aao01=p_aag08 AND aao02=l_abb.abb05
      AND aao03=l_aba.aba03 AND aao04=l_aba.aba04
   IF STATUS THEN
#     CALL cl_err('upd aao(2):',STATUS,1)   #No.FUN-660123
      CALL cl_err3("upd","aao_file",l_aba.aba00,p_aag08,STATUS,"","upd aao(2):",1)   #No.FUN-660123
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION re_tao(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07     #No.FUN-680098   VARCHAR(1)
    DEFINE p_aag08	 LIKE aag_file.aag08     #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE tah_file.tah04     #No.FUN-4C0009    #No.FUN-680098  DECIMAL(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No.FUN-4C0009    #No.FUN-680098  DECIMAL(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5     #No.FUN-680098   SMALLINT
    DEFINE l_i           LIKE type_file.num5     #No.FUN-680098   SMALLINT
    DEFINE l_aag08       LIKE aag_file.aag08
    DEFINE m_aag08       LIKE aag_file.aag08     #add 030926  NO.A092
    DEFINE l_aag24       LIKE aag_file.aag24

    #add by danny 020226 外幣管理(A002)
    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= l_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = l_abb.abb07  LET rec_c = 1
            LET amtf_c= l_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tao_file SET tao05 = tao05 - amt_d,
                        tao06 = tao06 - amt_c,
                        tao07 = tao07 - rec_d,
                        tao08 = tao08 - rec_c,
                        tao10 = tao10 - amtf_d,
                        tao11 = tao11 - amtf_c
          WHERE tao00=l_aba.aba00 AND tao01=l_abb.abb03 AND tao02=l_abb.abb05
            AND tao03=l_aba.aba03 AND tao04=l_aba.aba04 AND tao09=l_abb.abb24
          IF STATUS THEN
#            CALL cl_err('upd tao:',STATUS,1)    #No.FUN-660123
             CALL cl_err3("upd","tao_file",l_aba.aba00,l_abb.abb03,STATUS,"","upd tao:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
   #modify 020814  NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL re_tao_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
      #modify 030926 NO.A092
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08
            AND aag00 = tm.bookno   #TQC-7C0029
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
           # CALL re_tao_2(l_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             CALL re_tao_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08
                                                       AND aag00 = tm.bookno   #TQC-7C0029
         END FOR
    # END IF
   END IF
END FUNCTION

#add 020814  NO.A030
FUNCTION re_tao_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE p_aag08        LIKE aag_file.aag08
   DEFINE amt_d,amt_c	 LIKE tah_file.tah04      #No.FUN-4C0009     #No.FUN-680098  DECIMAL(20,6)
   DEFINE rec_d,rec_c	 LIKE type_file.num5      #No.FUN-680098     SMALLINT
   DEFINE amtf_d,amtf_c	 LIKE type_file.num20_6   #No.FUN-4C0009     #No.FUN-680098  DECIMAL(20,6)

   UPDATE tao_file SET tao05 = tao05 - amt_d, tao06 = tao06 - amt_c,
                       tao07 = tao07 - rec_d, tao08 = tao08 - rec_c,
                       tao10 = tao10 - amtf_d,tao11 = tao11 - amtf_c
    WHERE tao00=l_aba.aba00 AND tao01=p_aag08     AND tao02=l_abb.abb05
      AND tao03=l_aba.aba03 AND tao04=l_aba.aba04 AND tao09=l_abb.abb24
   IF STATUS THEN
#     CALL cl_err('upd tao(2):',STATUS,1)   #No.FUN-660123
      CALL cl_err3("upd","tao_file",l_aba.aba00,p_aag08,STATUS,"","upd tao(2):",1)   #No.FUN-660123
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION re_afc()
    DEFINE amt_d,amt_c LIKE  type_file.num20_6 #No.FUN-4C0009   #No.FUN-680098 DECIMAL(20,6)
    DEFINE rec_d,rec_c  LIKE type_file.num5    #No.FUN-680098   SMALLINT

    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = l_abb.abb07 LET rec_c = 1
    END IF
    IF cl_null(l_abb.abb35) THEN LET l_abb.abb35=' ' END IF     #MOD-B30571 add
    IF cl_null(l_abb.abb05) THEN LET l_abb.abb05=' ' END IF     #MOD-B30571 add
    IF cl_null(l_abb.abb08) THEN LET l_abb.abb08=' ' END IF     #MOD-B30571 add
## No:2427 Modify 1998/09/18 -------------------
    IF l_aag.aag06='1' THEN   # 正常餘額型態 (1.借餘/2.貸餘)
       UPDATE afc_file SET afc07 = afc07 - (amt_d - amt_c)
#       WHERE afc01=l_abb.abb15 AND afc02=l_abb.abb03 AND afc00=l_aba.aba00             #FUN-810069
        WHERE afc01=l_abb.abb36 AND afc02=l_abb.abb03 AND afc00=l_aba.aba00              #FUN-810069
         #AND afc041 = l_abb.abb35 AND afc042 = l_abb.abb08                              #FUN-810069   #No.MOD-910187mark
          AND afc041 = l_abb.abb05 AND afc042 = l_abb.abb08                              #FUN-810069   #No.MOD-910187
          AND afc03=l_aba.aba03 AND afc05=l_aba.aba04
          AND afc04 = l_abb.abb35  #No.MOD-910187
         #No.MOD-910187--begin-- mark
         #AND (afc04 = '@' OR afc04=l_abb.abb05 OR
         #     afc04 = l_abb.abb08 OR
         #     afc04 = l_abb.abb11 OR
         #     afc04 = l_abb.abb12 OR
         #     afc04 = l_abb.abb13 OR
         #     afc04 = l_abb.abb14 OR
         #     #FUN-5C0015 BY GILL --START
         #     afc04 = g_abb.abb31 OR
         #     afc04 = g_abb.abb32 OR
         #     afc04 = g_abb.abb33 OR
         #     afc04 = g_abb.abb34 OR
         #     afc04 = g_abb.abb35 OR
         #     afc04 = g_abb.abb36 OR
         #     afc04 = g_abb.abb37
         #     #FUN-5C0015 BY GILL --END
         #     )
         #No.MOD-910187---end--- mark
       IF STATUS THEN
#         CALL cl_err('upd afc:',STATUS,1)    #No.FUN-660123
#         CALL cl_err3("upd","afc_file",l_abb.abb15,l_abb.abb03,STATUS,"","upd afc:",1)   #No.FUN-660123   #FUN-810069
          CALL cl_err3("upd","afc_file",l_abb.abb36,l_abb.abb03,STATUS,"","upd afc:",1)   #No.FUN-660123    #FUN-810069
          LET g_success='N' RETURN
       END IF
    ELSE
       UPDATE afc_file SET afc07 = afc07 - (amt_c - amt_d)
#       WHERE afc01=l_abb.abb15 AND afc02=l_abb.abb03 AND afc00=l_aba.aba00       #FUN-810069
        WHERE afc01=l_abb.abb36 AND afc02=l_abb.abb03 AND afc00=l_aba.aba00        #FUN-810069
         #AND afc041 = abb35 AND afc042 = abb08                                    #FUN-810069  #No.MOD-910187 mark
          AND afc041 = l_abb.abb05 AND afc042 = l_abb.abb08                                    #FUN-810069  #No.MOD-910187
          AND afc04  = l_abb.abb35  #no.MOD-910187
          AND afc03=l_aba.aba03 AND afc05=l_aba.aba04
         #No.MOD-910187--begin--  mark
         #AND (afc04 = '@' OR afc04=l_abb.abb05 OR
         #     afc04 = l_abb.abb08 OR
         #     afc04 = l_abb.abb11 OR
         #     afc04 = l_abb.abb12 OR
         #     afc04 = l_abb.abb13 OR
         #     afc04 = l_abb.abb14 OR
         #     #FUN-5C0015 BY GILL --START
         #     afc04 = g_abb.abb31 OR
         #     afc04 = g_abb.abb32 OR
         #     afc04 = g_abb.abb33 OR
         #     afc04 = g_abb.abb34 OR
         #     afc04 = g_abb.abb35 OR
         #     afc04 = g_abb.abb36 OR
         #     afc04 = g_abb.abb37
         #     #FUN-5C0015 BY GILL --END
         #    )
         #No.MOD-910187---end---
       IF STATUS THEN
#         CALL cl_err('upd afc:',STATUS,1)  #No.FUN-660123
#         CALL cl_err3("upd","afc_file",l_abb.abb15,l_abb.abb03,STATUS,"","upd afc:",1)   #No.FUN-660123        #FUN-810069
          CALL cl_err3("upd","afc_file",l_abb.abb36,l_abb.abb03,STATUS,"","upd afc:",1)   #No.FUN-660123         #FUN-810069
          LET g_success='N' RETURN
       END IF
    END IF
END FUNCTION

FUNCTION re_aed()
   IF NOT cl_null(l_abb.abb11) THEN
      #CALL aec_del(l_abb.abb11,l_aag.aag151,'1')            #FUN-5C0015 BY GILL
      CALL aec_del(l_abb.abb11,l_aag.aag151,'1',l_aag.aag15) #FUN-5C0015 BY GILL
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb11,'1')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb11,'1')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb12) THEN
      #CALL aec_del(l_abb.abb12,l_aag.aag161,'2')            #FUN-5C0015 BY GILL
      CALL aec_del(l_abb.abb12,l_aag.aag161,'2',l_aag.aag16) #FUN-5C0015 BY GILL
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb12,'2')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb12,'2')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb13) THEN
      #CALL aec_del(l_abb.abb13,l_aag.aag171,'3')            #FUN-5C0015 BY GILL
      CALL aec_del(l_abb.abb13,l_aag.aag171,'3',l_aag.aag17) #FUN-5C0015 BY GILL
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb13,'3')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb13,'3')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb14) THEN
      #CALL aec_del(l_abb.abb14,l_aag.aag181,'4')            #FUN-5C0015 BY GILL
      CALL aec_del(l_abb.abb14,l_aag.aag181,'4',l_aag.aag18) #FUN-5C0015 BY GILL
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb14,'4')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb14,'4')
      IF g_success = 'N' THEN RETURN END IF
   END IF

   #FUN-5C0015 BY GILL --START
   IF NOT cl_null(l_abb.abb31) THEN
      CALL aec_del(l_abb.abb31,l_aag.aag311,'5',l_aag.aag31)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb31,'5')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb31,'5')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb32) THEN
      CALL aec_del(l_abb.abb32,l_aag.aag321,'6',l_aag.aag32)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb32,'6')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb32,'6')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb33) THEN
      CALL aec_del(l_abb.abb33,l_aag.aag331,'7',l_aag.aag33)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb33,'7')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb33,'7')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb34) THEN
      CALL aec_del(l_abb.abb34,l_aag.aag341,'8',l_aag.aag34)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb34,'8')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb34,'8')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb35) THEN
      CALL aec_del(l_abb.abb35,l_aag.aag351,'9',l_aag.aag35)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb35,'9')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb35,'9')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb36) THEN
      CALL aec_del(l_abb.abb36,l_aag.aag361,'10',l_aag.aag36)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb36,'10')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb36,'10')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(l_abb.abb37) THEN
      CALL aec_del(l_abb.abb37,l_aag.aag371,'99',l_aag.aag37)
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_del(l_abb.abb37,'99')
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_del(l_abb.abb37,'99')
      IF g_success = 'N' THEN RETURN END IF
   END IF
   #FUN-5C0015 BY GILL --END

END FUNCTION

#FUNCTION aec_del(p_key,p_sw,p_key2)     #FUN-5C0015 BY GILL --MARK
FUNCTION aec_del(p_key,p_sw,p_key2,p_tc) #FUN-5C0015 BY GILL
   DEFINE  p_key   LIKE aec_file.aec05,	 # 異動碼
	   p_sw    LIKE type_file.chr1,  # 異動碼處理方式        #No.FUN-680098 VARCHAR(1)
           p_key2  LIKE ooy_file.ooytype,#FUN-5C0015 BY GILL     #No.FUN-680098 VARCHAR(1)
           p_tc    LIKE aec_file.aec052  #FUN-5C0015 BY GILL


   DELETE FROM aec_file WHERE aec00 = l_abb.abb00
                          AND aec01 = l_abb.abb03
                          AND aec02 = l_aba.aba02
                          AND aec03 = l_aba.aba01
                          AND aec04 = l_abb.abb02
                          AND aec05 = p_key
                          AND aec051 = p_key2
                          AND aec052 = p_tc  #FUN-5C0015 BY GILL
        IF STATUS THEN
#          CALL cl_err('ins aec:',STATUS,1)   #No.FUN-660123
           CALL cl_err3("del","aec_file",l_abb.abb00,l_abb.abb03,STATUS,"","ins aec:",1)   #No.FUN-660123
           LET g_success='N' RETURN
        END IF
#-----MOD-680104---------
#   DELETE FROM aee_file WHERE aee01 = l_abb.abb03
#                          AND aee02 = p_key2
#                          AND aee03 = p_key
#        IF STATUS THEN
##          CALL cl_err('ins aec:',STATUS,1)    #No.FUN-660123
#           CALL cl_err3("del","aee_file",l_abb.abb03,p_key2,STATUS,"","ins aec:",1)   #No.FUN-660123
#           LET g_success='N' RETURN
#        END IF
#-----END MOD-680104-----
END FUNCTION

FUNCTION aed_del(p_key,p_key2)
    DEFINE p_key	LIKE aed_file.aed02        #No.FUN-680098 VARCHAR(15)
    DEFINE p_key2	LIKE aed_file.aed011       #FUN-5C0015 BY GILL --MARK #No.FUN-680098 VARCHAR(1)
    DEFINE amt_d,amt_c	LIKE type_file.num20_6     #No.FUN-4C0009 #No.FUN-680098     DECIMAL(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5        #No.FUN-680098 SMALLINT

    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = l_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aed_file SET aed05 = aed05 - amt_d,
                        aed06 = aed06 - amt_c,
                        aed07 = aed07 - rec_d,
                        aed08 = aed08 - rec_c
                  WHERE aed01 = l_abb.abb03 AND aed02 = p_key AND aed011=p_key2
                    AND aed03 = l_aba.aba03 AND aed04 = l_aba.aba04
                    AND aed00 = l_aba.aba00
          IF STATUS THEN
#            CALL cl_err('upd aed:',STATUS,1)   #No.FUN-660123
             CALL cl_err3("upd","aed_file",l_abb.abb03,p_key,STATUS,"","upd aed:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
END FUNCTION

FUNCTION ted_del(p_key,p_key2)
    DEFINE p_key         LIKE ted_file.ted02     #No.FUN-680098  VARCHAR(15)
    DEFINE p_key2	 LIKE ted_file.ted011    #FUN-5C0015 BY GILL --MARK #No.FUN-680098 VARCHAR(1)
    DEFINE amt_d,amt_c	 LIKE type_file.num20_6  #No.FUN-4C0009    #No.FUN-680098 DECIMAL(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No.FUN-4C0009    #No.FUN-680098 DECIMAL(20,6)
    DEFINE rec_d,rec_c   LIKE type_file.num5     #No.FUN-680098 SMALLINT

   #add by danny 020226 外幣管理(A002)
    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF l_abb.abb06 = 1
       THEN LET amt_d = l_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= l_abb.abb07f LET amtf_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = l_abb.abb07 LET rec_c = 1
            LET amtf_c= l_abb.abb07f LET amtf_d = 0
    END IF
    UPDATE ted_file SET ted05 = ted05 - amt_d,
                        ted06 = ted06 - amt_c,
                        ted07 = ted07 - rec_d,
                        ted08 = ted08 - rec_c,
                        ted10 = ted10 - amtf_d,
                        ted11 = ted11 - amtf_c
                  WHERE ted01 = l_abb.abb03 AND ted02 = p_key
                    AND ted011= p_key2      AND ted03 = l_aba.aba03
                    AND ted04 = l_aba.aba04 AND ted00 = l_aba.aba00
                    AND ted09 = l_abb.abb24
          IF STATUS THEN
#            CALL cl_err('upd ted:',STATUS,1)   #No.FUN-660123
             CALL cl_err3("upd","ted_file",l_abb.abb03,p_key,STATUS,"","upd ted:",1)   #No.FUN-660123
             LET g_success='N' RETURN
          END IF
END FUNCTION
FUNCTION aglp109_aef(p_key)
DEFINE    p_key     LIKE ted_file.ted02   #No.FUN-680098 VARCHAR(20)
     IF g_abb.abb06 = '1' THEN
        UPDATE aef_file SET aef05 = aef05 - g_abb.abb07,
                            aef07 = aef07 - 1
               WHERE aef01 = g_abb.abb03
                 AND aef02 = p_key
                 AND aef03 = g_aba.aba03
                 AND aef04 = g_aba.aba04
                 AND aef00 = tm.bookno  #No.FUN-740020
     END IF
     IF g_abb.abb06 = '2' THEN
        UPDATE aef_file SET aef06 = aef06 - g_abb.abb07,
                            aef08 = aef08 - 1
               WHERE aef01 = g_abb.abb03
                 AND aef02 = p_key
                 AND aef03 = g_aba.aba03
                 AND aef04 = g_aba.aba04
                 AND aef00 = tm.bookno  #No.FUN-740020
     END IF
     IF STATUS THEN
#       CALL cl_err('upd aef:',STATUS,1)    #No.FUN-660123
#       CALL cl_err3("upd","aef_file",g_abb.abb03,p_key,STATUS,"","upd aef:",1)     #No.FUN-660123 #NO.FUN-710023
        LET g_showmsg=g_abb.abb03,"/", p_key,"/",g_aba.aba03,"/",g_aba.aba04,"/",tm.bookno          #No.FUN-740020
        CALL s_errmsg('aef01,aef02,aef03,aef04,aef00',g_showmsg,'upd aef:',STATUS,1)
        LET g_success='N' RETURN
     END IF
END FUNCTION

#FUN-570145 -----start-------
FUNCTION p109_process()
DEFINE l_str  LIKE type_file.chr1000       #FUN-570145    #No.FUN-680098  VARCHAR(15)
DEFINE l_flag LIKE type_file.chr1    #TQC-AB0113

   IF g_bgjob = 'N' THEN
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 14 LET p_col = 42
      ELSE
         LET p_row = 18 LET p_col = 26
      END IF
      OPEN WINDOW aglp109_g_w AT p_row,p_col WITH 5 rows, 30 COLUMNS
      CALL cl_getmsg('agl-024',g_lang) RETURNING l_str
      DISPLAY l_str AT 4,8
   END IF

  #str MOD-A10073 mod
   IF NOT cl_null(g_bdate) AND NOT cl_null(g_bno) THEN 
      LET g_sql = "SELECT * FROM aba_file WHERE aba00 = '",tm.bookno,"'",  #No.FUN-740020
                  "   AND abapost = 'Y' AND abaacti = 'Y' ",                    
                  "   AND aba02 ='",g_bdate,"'",                                
                  "   AND aba01 ='",g_bno,"'"                                   
   ELSE         
  #end MOD-A10073 mod
      LET g_sql = "SELECT * FROM aba_file WHERE aba00 = '",tm.bookno,"'",  #No.FUN-740020
                  "   AND abapost = 'Y' AND abaacti = 'Y' AND ",g_wc CLIPPED
   END IF   #MOD-A10073 add
   PREPARE p109_p FROM g_sql
   DECLARE p109_cur CURSOR WITH HOLD FOR p109_p
   CALL s_showmsg_init()                        #NO.FUN-710023
   LET l_flag = '0'  #TQC-AB0113
   FOREACH p109_cur INTO g_aba.*
      LET l_flag = '1'  #TQC-AB0113
#NO.FUN-710023--BEGIN
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
#NO.FUN-710023--END
      IF g_bgjob = 'N' THEN
         DISPLAY 'recover:',g_aba.aba01 AT 1,1
      END IF
#No.FUN-740200---------start---------------
#     IF g_aba.aba03 < g_aaa04 THEN #若非今年的傳票資料,則判斷系統參數
#        IF g_aaz.aaz431 NOT MATCHES  '[Yy]' THEN
#           CALL cl_err(g_aba.aba03,'agl-047',0) CONTINUE FOREACH #NO.FUN-710023
#           LET  g_showmsg=tm.bookno,"/",'Y',"/",'Y'  #No.FUN-740020
#           CALL s_errmsg('aba00,abapost,abaacti',g_showmsg,g_aba.aba03,'agl-047',0) CONTINUE FOREACH #NO.FUN-710023
#           CALL s_errmsg('aba00,abapost,abaacti',g_showmsg,g_aba.aba03,'agl-047',1) CONTINUE FOREACH #NO.FUN-710023 #No.FUN-740200
#        END IF
#     END IF
#    #若為今年前期的傳票資料,則判斷系統參數(aaz441)
#     IF g_aba.aba03 = g_aaa04 AND g_aba.aba04 < g_aaa05 THEN
#        IF g_aaz.aaz441 NOT MATCHES  '[Yy]' THEN
#           CALL cl_err(g_aba.aba04,'agl-048',0) CONTINUE FOREACH #NO.FUN-710023
#           LET  g_showmsg=tm.bookno,"/",'Y',"/",'Y'  #No.FUN-740020
#           CALL s_errmsg('aba00,abapost,abaacti',g_showmsg,g_aba.aba04,'agl-048',1) CONTINUE FOREACH #NO.FUN-710023
#        END IF
#     END IF
#No.FUN-740200---------end-----------------
      IF g_aba.aba02 <= g_aaa07 THEN   #判斷傳票日期是否小於關帳日期
#        CALL cl_err(g_aba.aba02,'agl-200',0) CONTINUE FOREACH #NO.FUN-710023
         LET  g_showmsg=tm.bookno,"/",'Y',"/",'Y'  #No.FUN-740020
#        CALL s_errmsg('aba00,abapost,abaacti',g_showmsg,g_aba.aba01,'agl-200',0)
         CALL s_errmsg('aba00,abapost,abaacti',g_showmsg,g_aba.aba01,'agl-200',1)   #No.FUN-740200
         LET g_success = 'N'   #MOD-A10073 add
         CONTINUE FOREACH #NO.FUN-710023
      END IF
      CALL aglp109()    #處理1.科目餘額檔2.分類帳檔3.異動別分類檔
                        #    4.更新科目餘額5.預算巳消耗金額
   END FOREACH
#NO.FUN-710023--BEGIN
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#NO.FUN-710023--END
#TQC-AB0117--ADD--STR--
   IF l_flag = '0' THEN
      LET g_success='N'
      CALL s_errmsg('aba00,abapost,abaacti',g_showmsg,g_aba.aba01,'agl-118',1)   
   END IF
#TQC-AB0117--ADD--END--
   CLOSE WINDOW aglp109_g_w
END FUNCTION

#FUN-570145 ---end---
#MOD-730008
