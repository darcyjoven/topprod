# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: aglp102.4gl
# Descriptions...: 未過帳傳票過帳作業 (整批資料處理作業)
# Date & Author..: 92/03/11 BY MAY
#                  新增'輸入人員範圍'(QBE)、s_post()新增'過帳否'及'tm.wc'
#                  兩參數傳遞
# Memo...........: 本程式用於平時過帳故無需每次過帳都要做月結的動作 故月結不
#                  在本程式處理  而由使用者另行執行期末結轉作業(aglp201)
# Modify.........: 99/03/02 By Carol--bug:3028 
# Modify ........: No.FUN-570145 06/02/27 By YITING 批次背景執行
# Modify.........: No.MOD-620034 06/03/31 By Smapmin 新增帳別欄位
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-730008 07/03/08 By Smapmin 恢復MOD-620034所修改的程式段 
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-740160 07/04/22 By Smapmin 傳票日期不可小於等於關帳日期
# Modify.........: No.MOD-7B0215 07/12/04 By Smapmin 修改transaction流程
# Modify.........: No.MOD-7C0040 07/12/05 By Smapmin 背景處理時,不應出現詢問是否月結的畫面
# Modify.........: No.FUN-8A0086 08/10/17 By zhaijie錯誤匯總加s_showmsg_init()
# Modify.........: No.FUN-920155 09/02/20 By shiwuying 程序名稱由s_post改為aglp102_post
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0403 09/12/25 By Dido 帳別異動後重新計算起迄日 
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:MOD-A40181 10/08/03 By sabrina 判斷月份時應該加上年份 
# Modify.........: No:TQC-AB0114 10/11/30 By lixia 處理人員改為開窗
# Modify.........: No:TQC-B30141 11/03/28 By elva CE凭证过账时增加判断
# Modify.........: No:MOD-B60002 11/06/01 By Dido 若屬於傳遞參數方式時,則不執行結轉 
# Modify.........: No:MOD-B80056 11/08/05 By Polly 將tm.wc型態改為STRING
# Modify.........: No:MOD-CB0180 12/11/20 By Polly 按放棄時，離開畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm        RECORD
              #wc     LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(300) #No.MOD-B80056 mark
               wc     STRING,                                              #No.MOD-B80056 add
               bookno LIKE aaa_file.aaa01,   #No.FUN-740032
               bdate  LIKE type_file.dat,   #No.FUN-680098   DATE
               edate  LIKE type_file.dat,   #No.FUN-680098   DATE
               aba01_1  LIKE aba_file.aba01,   
               aba01_2  LIKE aba_file.aba01 
               END RECORD,
     g_aaa     RECORD LIKE aaa_file.*,
     b_date    LIKE type_file.dat,                        #期間起始日期        #No.FUN-680098  DATE
     e_date    LIKE type_file.dat,                        #期間起始日期        #No.FUN-680098  DATE
     g_bookno  LIKE aea_file.aea00,         #帳別
     g_eom     LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)
     g_eoy     LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)
     g_aba06   LIKE aba_file.aba06,         #TQC-B30141
     bno       LIKE type_file.chr6,         #起始傳票編號     #No.FUN-680098 VARCHAR(6)
     eno       LIKE type_file.chr6,         #截止傳票編號     #No.FUN-680098 VARCHAR(6)
     l_y1      LIKE type_file.num5,         #No.FUN-680098 SMALLINT
     l_y2      LIKE type_file.num5,         #No.FUN-680098 SMALLINT
     l_m1      LIKE type_file.num5,         #No.FUN-680098 SMALLINT      
     l_m2      LIKE type_file.num5,         #No.FUN-680098 SMALLINT      
     l_flag    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE ls_date         STRING,              #No.FUN-570145
       ls_date2        STRING,
       g_change_lang   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE   g_chr         LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A70007 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A70007 add
DEFINE g_flag        LIKE type_file.chr1       #CHI-A70007 add
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET tm.bookno = ARG_VAL(1)  #No.FUN-740032
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc      = ARG_VAL(2)                         #QBE條件
   LET ls_date    = ARG_VAL(3)                         #起始傳票日期
   LET tm.bdate   = cl_batch_bg_date_convert(ls_date)
   LET ls_date2   = ARG_VAL(4)                         #截止傳票日期
   LET tm.edate   = cl_batch_bg_date_convert(ls_date2)
   LET tm.aba01_1 = ARG_VAL(5)
   LET tm.aba01_2 = ARG_VAL(6)
   LET g_bgjob    = ARG_VAL(7)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
  #--- No.FUN-570145 --end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
    #No.FUN-740032  -Begin
    IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
       #SELECT aaz64 INTO tm.bookno FROM aaz_file
       LET tm.bookno = g_aza.aza81
    END IF
    SELECT * INTO g_aaa.* from aaa_file WHERE aaa01 = tm.bookno
    #No.FUN-740032  -End  
#NO.FUN-570145 START--
#    CALL aglp102_tm(0,0)
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp102_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = "Y"
           BEGIN WORK
           CALL s_showmsg_init()                  #NO.FUN-710023  
       #   CALL s_post(tm.bookno,tm.bdate,tm.edate,tm.aba01_1,  #No.FUN-740032 #No.FUN-920155
           CALL aglp102_post(tm.bookno,tm.bdate,tm.edate,tm.aba01_1,           #No.FUN-920155
                       tm.aba01_2,'N',tm.wc)
           #TQC-B30141 --begin
           #CE类凭证过账时不做月结
          #IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結   #MOD-7B0215
           SELECT aba06 INTO g_aba06 FROM aba_file WHERE aba01=tm.aba01_1 AND aba01=tm.aba01_2 AND aba00=tm.bookno
           IF g_aba06='CE' THEN ELSE
              IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結   #MOD-7B0215 
           END IF
           #TQC-B30141 --end
           CALL s_showmsg()                       #NO.FUN-710023
           IF g_success='Y' THEN
              COMMIT WORK   
              #IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結   #MOD-7B0215
              CALL cl_end2(1) RETURNING l_flag        #批次作業失敗
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           CLOSE WINDOW post_g_w
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp102_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL s_showmsg_init()                  #NO.FUN-8A0086  
   #    CALL s_post(tm.bookno,tm.bdate,tm.edate,tm.aba01_1,  #No.FUN-740032 #No.FUN-920155
        CALL aglp102_post(tm.bookno,tm.bdate,tm.edate,tm.aba01_1,           #No.FUN-920155
                    tm.aba01_2,'N',tm.wc)
        CALL p102_process()
        #TQC-B30141 --begin
        #IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結   #MOD-7B0215
        SELECT aba06 INTO g_aba06 FROM aba_file WHERE aba01=tm.aba01_1 AND aba01=tm.aba01_2 AND aba00=tm.bookno
        IF g_aba06='CE' THEN ELSE
          #IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結   #MOD-7B0215 #MOD-B60002 mark
          #-MOD-B60002-add-
           IF g_eom = 'Y' AND (cl_null(ARG_VAL(5)) OR ARG_VAL(5) <> ARG_VAL(6)) THEN 
              CALL p102_eom()      #月結
           END IF                  
          #-MOD-B60002-end-
        END IF
        #TQC-B30141 --end
        CALL s_showmsg()                       #NO.FUN-710023
        IF g_success = 'Y' THEN
           COMMIT WORK   
           #IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結   #MOD-7B0215
        ELSE
           ROLLBACK WORK
        END IF
        EXIT WHILE
     END IF
   END WHILE
#FUN-570145 end----
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglp102_tm(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          # g_aay          RECORD LIKE aay_file.*,
            g_aaz31        LIKE aaz_file.aaz31,
            g_aaz32        LIKE aaz_file.aaz32,
            l_bdate        LIKE type_file.dat,     #期別的起始日期  #No.FUN-680098 DATE
            l_edate        LIKE type_file.dat,     #期別的截止日期  #No.FUN-680098 DATE
            l_azn02        LIKE azn_file.azn02,
            l_azn04        LIKE azn_file.azn04,
            l_cdate        LIKE type_file.chr8,      #No.FUN-680098 VARCHAR(1)
            l_yy           LIKE type_file.num10,     #No.FUN-680098 INTEGER
            l_mm,l_dd     LIKE type_file.num5        #No.FUN-680098 SMALLINT
   DEFINE  lc_cmd         LIKE type_file.chr1000   #FUN-570145   #No.FUN-680098 VARCHAR(500)
 
   CALL s_dsmark(tm.bookno)  #No.FUN-740032
 
   OPEN WINDOW aglp102_w WITH FORM "agl/42f/aglp102" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL s_shwact(3,2,tm.bookno)  #No.FUN-740032
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_aglshut(0) THEN RETURN  END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL            # Defaealt condition
      #本期的起始截止日期
      #CALL s_azm(g_aaa.aaa04,g_aaa.aaa05) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF cl_null(tm.bookno) THEN
         CALL s_get_bookno(g_aaa.aaa04)
            RETURNING g_flag,g_bookno1,g_bookno2
      END IF
      IF g_aza.aza63 = 'Y' THEN
         IF NOT cl_null(tm.bookno)THEN
            CALL s_azmm(g_aaa.aaa04,g_aaa.aaa05,g_plant,tm.bookno) RETURNING l_flag,l_bdate,l_edate
         ELSE
            CALL s_azmm(g_aaa.aaa04,g_aaa.aaa05,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
         END IF
      ELSE
         CALL s_azm(g_aaa.aaa04,g_aaa.aaa05) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      #預設過帳起始日期=MAX(上次過帳日期+1,本期第一日)
         IF g_aaa.aaa06+1 > l_bdate THEN
             LET tm.bdate = g_aaa.aaa06+1
          ELSE 
             LET tm.bdate =  l_bdate
          END IF
 
      #預設過帳截止日期=MIN(today,本期最後一日)
         IF g_today > l_edate THEN
            LET tm.edate = tm.bdate   
            LET l_dd=cl_days(YEAR(tm.bdate),MONTH(tm.bdate)) 
            LET tm.edate=MDY(MONTH(tm.bdate),l_dd,YEAR(tm.bdate)) 
         ELSE LET tm.edate = l_edate
         END IF
 
      CONSTRUCT BY NAME tm.wc ON abauser  
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#TQC-AB0114--add--str---
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(abauser) #人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abauser
                  NEXT FIELD abauser
               OTHERWISE EXIT CASE
            END CASE
#TQC-AB0114--add--end---

         ON ACTION locale
           #CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()          #No.FUN-550037 hmf
           LET g_change_lang = TRUE         #No.FUN-570145
           #LET g_action_choice = "locale"  #No.FUN-570145
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
 
 
         
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    #-- No.FUN-570145 start--
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
 
 
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
     LET tm.bookno = g_aza.aza81
     LET g_bgjob = 'N'
    #-- No.FUN-570145 --end---
    #DISPLAY BY NAME tm.bdate,tm.edate,tm.aba01_1,tm.aba01_2  #FUN-5701
    DISPLAY BY NAME tm.bdate,tm.edate,tm.aba01_1,tm.aba01_2,g_bgjob 
    DISPLAY BY NAME tm.bookno  #No.FUN-740032
    #INPUT BY NAME tm.bdate,tm.edate,tm.aba01_1,tm.aba01_2        #FUN-570145
    INPUT BY NAME tm.bookno,tm.bdate,tm.edate,tm.aba01_1,tm.aba01_2,g_bgjob    #No.FUN-740032
              WITHOUT DEFAULTS
 
      #No.FUN-740032  --Begin
      AFTER FIELD bookno
         IF NOT cl_null(tm.bookno) THEN
            CALL p102_bookno(tm.bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.bookno,g_errno,0)
               LET tm.bookno = g_aza.aza81
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
            END IF
           #-MOD-9C0403-add-
            SELECT * INTO g_aaa.* from aaa_file WHERE aaa01 = tm.bookno
            #CALL s_azm(g_aaa.aaa04,g_aaa.aaa05) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
            #CHI-A70007 add --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(g_aaa.aaa04,g_aaa.aaa05,g_plant,tm.bookno) RETURNING l_flag,l_bdate,l_edate
            ELSE
               CALL s_azm(g_aaa.aaa04,g_aaa.aaa05) RETURNING l_flag,l_bdate,l_edate
            END IF
            #CHI-A70007 add --end--
            #預設過帳起始日期=MAX(上次過帳日期+1,本期第一日)
            IF g_aaa.aaa06+1 > l_bdate THEN
               LET tm.bdate = g_aaa.aaa06+1
            ELSE
               LET tm.bdate = l_bdate
            END IF
            #預設過帳截止日期=MIN(today,本期最後一日)
            IF g_today > l_edate THEN
               LET tm.edate = tm.bdate
               LET l_dd=cl_days(YEAR(tm.bdate),MONTH(tm.bdate))
               LET tm.edate=MDY(MONTH(tm.bdate),l_dd,YEAR(tm.bdate))
            ELSE
               LET tm.edate = l_edate
            END IF
            DISPLAY BY NAME tm.bdate,tm.edate
           #-MOD-9C0403-end-
         END IF
      #No.FUN-740032  --End  
 
      AFTER FIELD bdate
         IF tm.bdate IS NULL OR tm.bdate = ' ' THEN
            NEXT FIELD bdate
         #-----MOD-740160---------
         ELSE
            IF tm.bdate <= g_aaa.aaa07 THEN 
               CALL cl_err('','agl-085',0)
               NEXT FIELD bdate
            END IF
         #-----END MOD-740160-----
         END IF
 
      AFTER FIELD edate
         IF tm.edate IS NULL OR tm.edate = ' ' THEN
            NEXT FIELD edate 
         ELSE
            #-----MOD-740160---------
            IF tm.edate <= g_aaa.aaa07 THEN 
               CALL cl_err('','agl-085',0)
               NEXT FIELD edate
            END IF
            #-----END MOD-740160-----
            IF tm.edate < tm.bdate THEN
                CALL cl_err(tm.bdate,'agl-031',0)
                NEXT FIELD bdate
            END IF
            SELECT azn02,azn04 INTO l_y1,l_m1 FROM azn_file 
                   WHERE azn01 = tm.bdate
            IF SQLCA.sqlcode THEN 
#              CALL cl_err(tm.bdate,'aoo-064',0)   #No.FUN-660123
               CALL cl_err3("sel","azn_file",tm.bdate,"","aoo-064","","",0)   #No.FUN-660123
               NEXT FIELD bdate
            END IF
            SELECT azn02,azn04 INTO l_y2,l_m2 FROM azn_file
                   WHERE azn01 = tm.edate
            IF SQLCA.sqlcode THEN 
#              CALL cl_err(tm.edate,'aoo-064',0)   #No.FUN-660123
               CALL cl_err3("sel","azn_file",tm.edate,"","aoo-064","","",0)   #No.FUN-660123
               NEXT FIELD edate
            END IF
            IF l_y1 != l_y2  OR l_m1 != l_m2 THEN   #輸入資料必需為同一年度,期間
                CALL cl_err('','agl-032',0) NEXT FIELD bdate
            END IF
         END IF
    
      #No.FUN-740032  --Begin
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
      #No.FUN-740032  --End  
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
        CALL cl_cmdask()
      AFTER INPUT
        IF INT_FLAG THEN 
           LET INT_FLAG = 0 
          #EXIT WHILE                                        #MOD-CB0180 mark
           CLOSE WINDOW aglp102_w                            #MOD-CB0180 add
           CALL cl_used(g_prog,g_time,2) RETURNING g_time    #MOD-CB0180 add
           EXIT PROGRAM                                      #MOD-CB0180 add
        END IF
        IF l_y1 != l_y2  OR l_m1 != l_m2 THEN   #輸入資料必需為同一年度,期間
            CALL cl_err('','agl-032',0) NEXT FIELD bdate
        END IF
       #IF l_m2 < g_aaa.aaa05                        #MOD-A40181 mark
        IF l_y2||l_m2 < g_aaa.aaa04||g_aaa.aaa05     #MOD-A40181 add
           THEN LET g_eom = 'Y' #為前期的傳票，需作月結
           ELSE LET g_eom = 'N' 
        END IF
        IF l_y1 < g_aaa.aaa04
           THEN LET g_eom = 'Y' #為去年的傳票，需作月結及年結
                LET g_eoy = 'Y'
           ELSE LET g_eoy = 'N'
        END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     #-->No.FUN-570145 --start--
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_change_lang = TRUE
            EXIT INPUT
     #---No.FUN-570145 --end--
 
 
      END INPUT
     #-->No.FUN-570145 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()          #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
     #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
#      IF cl_sure(21,21) THEN
#         CALL cl_wait()
#         # 96-07-02 過帳
#         LET g_success = "Y"
#         BEGIN WORK
#         CALL s_post(g_bookno,tm.bdate,tm.edate,tm.aba01_1,tm.aba01_2,'N',tm.wc)
#         IF g_success='Y' THEN
#            COMMIT WORK
#            IF g_eom = 'Y' THEN CALL p102_eom() END IF                  #月結
#            CALL cl_end2(1) RETURNING l_flag        #批次作業失敗
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aglp102"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('aglp102','9031',1)   
        ELSE
           LET tm.wc = cl_replace_str(tm.wc, "\"", "'")
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.bdate CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.aba01_1 CLIPPED,"'",
                        " '",tm.aba01_2 CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aglp102',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp102_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
      END IF
      EXIT WHILE
      #-- No.FUN-570145 --end---
      ERROR ""
   END WHILE
   #CLOSE WINDOW post_g_w
   #CLOSE WINDOW aglp102_w
END FUNCTION
 
#No.FUN-740032  --Begin
FUNCTION p102_bookno(p_bookno)
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
#No.FUN-740032  --End  
 
FUNCTION p102_eom()
   DEFINE l_flag        LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE b_date,e_date LIKE type_file.dat           #No.FUN-680098 DATE
 
   #CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(l_y1,l_m1,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
   ELSE
      CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date
   END IF
   #CHI-A70007 add --end--
   IF g_bgjob = 'N' THEN   #MOD-7C0040
      CALL cl_confirm('agl-180') RETURNING g_chr
   ELSE
      LET g_chr = 'Y'   #MOD-7C0040
   END IF   #MOD-7C0040
 
   IF (NOT g_chr) THEN
      RETURN
   END IF
   CALL s_eom(tm.bookno,b_date,e_date,l_y1,l_m1,'Y')  #No.FUN-740032
END FUNCTION
 
#NO.FUN-570145
FUNCTION p102_process()
   LET l_y1=' '
   LET l_m1=' '
   LET l_y2=' '
   LET l_m2=' '
   SELECT azn02,azn04 INTO l_y1,l_m1 FROM azn_file
          WHERE azn01 = tm.bdate
   SELECT azn02,azn04 INTO l_y2,l_m2 FROM azn_file
          WHERE azn01 = tm.edate
   IF l_y1 != l_y2  OR l_m1 != l_m2 THEN   #輸入資料必需為同一年度,期間
      RETURN
   END IF
  #IF l_m2 < g_aaa.aaa05 THEN                            #MOD-A40181 mark
   IF l_y2||l_m2 < g_aaa.aaa04||g_aaa.aaa05 THEN         #MOD-A40181 add
      LET g_eom = 'Y' #為前期的傳票，需作月結
   ELSE
      LET g_eom = 'N'
   END IF
   IF l_y1 < g_aaa.aaa04 THEN
      LET g_eom = 'Y' #為去年的傳票，需作月結及年結
      LET g_eoy = 'Y'
   ELSE
      LET g_eoy = 'N'
   END IF
END FUNCTION
#NO.FUN-570145
#MOD-730008
