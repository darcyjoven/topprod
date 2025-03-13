# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp103.4gl
# Descriptions...: 已過帳傳票重新過帳作業 (整批資料處理作業)
# Input parameter:
# Return code....:
# Date & Author..: 92/03/06 BY MAY
# 改為傳'過帳否'參數至 s_post 以判斷為'已過帳重新過帳' OR '未過帳整批過帳'
#                  By Melody    aee00 改為 no-use
#                  By Melody  1.新增 '輸入人員' 範圍(QBE)
#                             2.起迄日期改為 Noentry
# Modify.........: No.MOD-520112 05/02/23 By Kitty  Line 203的 END IF應放在 Line 190後面才是
# Modify.........: No.MOD-520088 05/02/24 By Kitty 問Y/N的一律改為用cl_confirm
# Modify ........: No.FUN-570145 06/02/27 By TSD.Hazel 批次背景執行
# Modify.........: No.MOD-620034 06/03/31 By Smapmin 新增帳別欄位
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/17 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-730008 07/03/08 By Smapmin 恢復MOD-620034所修改的程式段
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-8C0103 08/12/11 By Sarah 離開INPUT前再檢核一次axm-164訊息
# Modify.........: No.FUN-920155 09/02/20 By shiwuying 程序名稱由s_post改為aglp102_post
# Modify.........: No.MOD-930250 09/03/24 By Sarah 輸入帳別後，應重新依帳別抓取aaa_file帳別參數檔
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9A0052 09/11/17 By Carrier 增加'科目核算項'統計檔功能
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-AB0068 11/01/06 By Carrier s_eoy多加一个叁数'N'
# Modify.........: No:TQC-C50055 12/05/23 By Dido 過帳前先刪除 CE 傳票 
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
      tm        RECORD
               bookno LIKE aaa_file.aaa01,   #No.FUN-740020
               aaa04  LIKE aaa_file.aaa04,
               aaa05  LIKE aaa_file.aaa05,
               y1     LIKE aaa_file.aaa04,
               m2     LIKE aaa_file.aaa05
               END RECORD,
     g_aaa04   LIKE type_file.num5,     #現行會計年度     #No.FUN-680098   SMALLINT
     g_aaa05   LIKE type_file.num5,     #現行期別         #No.FUN-680098   SMALLINT
     g_aaa07   LIKE type_file.dat,      #關帳日期         #No.FUN-680098   DATE
     b_date    LIKE type_file.dat,      #還原起始日期     #No.FUN-680098   DATE
     e_date    LIKE type_file.dat,      #還原截止日期     #No.FUN-680098   DATE
     b_post_date   LIKE type_file.dat,        #過帳起始日期  #No.FUN-680098  DATE
     e_post_date   LIKE type_file.dat,        #過帳截止日期  #No.FUN-680098  DATE
     g_bookno      LIKE aea_file.aea00,       #帳別
     bno      LIKE type_file.chr18,           #起始傳票編號     #No.FUN-680098 VARCHAR(6)
     eno      LIKE type_file.chr18            #截止傳票編號     #No.FUN-680098 VARCHAR(6)
DEFINE  g_row,g_col   LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE ls_date        STRING,  #No.FUN-570145
      ls_date2        STRING,  #No.FUN-680098
      l_flag          LIKE type_file.chr1,    #No.FUN-680098 VARCHAR(1)
      l_y1            LIKE aaa_file.aaa04,
      g_change_lang   LIKE type_file.chr1     #No.FUN-680098   VARCHAR(1)


DEFINE   g_chr             LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    LET tm.bookno = ARG_VAL(1)  #No.FUN-740020
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.y1       = ARG_VAL(2)
   LET tm.m2       = ARG_VAL(3)
   LET ls_date     = ARG_VAL(4)                         #起始傳票日期
   LET b_post_date = cl_batch_bg_date_convert(ls_date)
   LET ls_date2    = ARG_VAL(5)                         #截止傳票日期
   LET e_post_date = cl_batch_bg_date_convert(ls_date2)
   LET g_bgjob     = ARG_VAL(6)
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
       #SELECT aaz64 INTO tm.bookno FROM aaz_file
       LET tm.bookno = g_aza.aza81
    END IF
    #No.FUN-740020  --End
#NO.FUN-570145 START--
    #CALL aglp103_tm(0,0)
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp103_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL aglp103()
           CALL s_showmsg()      #NO.FUN-710023
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp103_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF                   #No:BUG-520112
      ELSE
        LET g_success = 'Y'
        CALL p103_pre(tm.bookno)   #MOD-930250 mod
        BEGIN WORK
        CALL aglp103()
        CALL s_showmsg()                   #NO.FUN-710023
        IF g_success='Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
      END IF
  END WHILE
 #FUN-570145 end---
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION aglp103_tm(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5,           #No.FUN-680098 SMALLINT
            l_str          LIKE ze_file.ze03,           #No.FUN-680098 VARCHAR(30)
            l_str1         LIKE type_file.chr1000,        #No.FUN-680098  VARCHAR(12)
            l_y1           LIKE aaa_file.aaa04,
            l_msg          LIKE bxi_file.bxi01,     #No.FUN-680098  VARCHAR(16)
            l_ans          LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1)
            l_flag         LIKE type_file.chr1      #No.FUN-680098  VARCHAR(1)
   DEFINE  lc_cmd         LIKE type_file.chr1000 #FUN-570145   #No.FUN-680098   VARCHAR(500)

   CALL s_dsmark(tm.bookno)  #No.FUN-740020

   LET p_row = 9 LET p_col = 20

   OPEN WINDOW aglp103_w AT p_row,p_col WITH FORM "agl/42f/aglp103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

   CALL s_shwact(0,0,tm.bookno)  #No.FUN-740020
   INITIALIZE tm.* TO NULL            # Defaealt condition
   LET tm.bookno = g_aza.aza81 #No.FUN-740020
      SELECT aaa04,aaa05,aaa07 INTO tm.aaa04,tm.aaa05,g_aaa07
        FROM aaa_file WHERE aaa01 = tm.bookno  #No.FUN-740020
      IF tm.y1 IS NULL OR tm.y1 = ' ' THEN
         LET tm.y1 = tm.aaa04
         LET tm.m2 = tm.aaa05
      END IF
      #No.7704
      #CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
      ELSE
         CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date
      END IF
      #CHI-A70007 add --end--
      LET b_post_date = b_date
      LET e_post_date = e_date
      #No.7704(end)
   WHILE TRUE
      CLEAR FORM
      LET g_bgjob = 'N'      #FUN-570145
      #DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.y1,tm.m2
      DISPLAY BY NAME tm.bookno  #No.FUN-740020
      DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.y1,tm.m2,g_bgjob
      #INPUT BY NAME tm.y1,tm.m2,b_post_date,e_post_date
      INPUT BY NAME tm.bookno,tm.y1,tm.m2,b_post_date,e_post_date,g_bgjob     #No.FUN-740020
                    WITHOUT DEFAULTS

         #-->No.FUN-570145 --start--
           #ON ACTION locale
           #   CALL cl_dynamic_locale()
           #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           ON ACTION locale
#              CALL cl_show_fld_cont()
              LET g_change_lang = TRUE
              EXIT INPUT
         #---No.FUN-570145 --end--

      #No.FUN-740020  --Begin
      AFTER FIELD bookno
         IF NOT cl_null(tm.bookno) THEN
            CALL p103_bookno(tm.bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.bookno,g_errno,0)
               LET tm.bookno = g_aza.aza81
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
            END IF
         END IF
      #No.FUN-740020  --End


      AFTER FIELD y1
         IF tm.y1  IS NULL OR tm.y1 = ' ' THEN
            NEXT FIELD y1
         END IF
         IF tm.y1 > tm.aaa04 THEN
            CALL cl_err(tm.y1,'agl-030',0)
            NEXT FIELD y1
         END IF

      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.m2 IS NULL OR tm.m2 = ' ' THEN
             NEXT FIELD m2
         ELSE    #前面年度已判斷此處只需判斷輸入之過帳期別要小於現行期別
             IF  g_aaz.aaz442  MATCHES '[Nn]' AND #是否今年前期
                 tm.y1 = tm.aaa04 AND           #可重新過帳
                 tm.m2 < tm.aaa05 THEN
                 CALL cl_err(tm.m2,'agl-045',0)
                 NEXT FIELD m2
             END IF
             IF tm.y1 = tm.aaa04 AND tm.m2 > tm.aaa05 THEN
                CALL cl_err(tm.m2,'agl-023',0)
                NEXT FIELD m2
             END IF
         END IF
         #CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
         #CHI-A70007 add --start--
         IF g_aza.aza63 = 'Y' THEN
            CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
         ELSE
            CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date
         END IF
         #CHI-A70007 add --end--
         LET b_post_date = b_date
         LET e_post_date = e_date
         #no.4717日期不可小於關帳日期
         IF b_post_date <= g_aaa07 THEN
            CALL cl_err('date<aaa07','axm-164',0)
            NEXT FIELD y1
         END IF
         #no.4717(end)
         DISPLAY BY NAME b_post_date,e_post_date

     #str MOD-8C0103 add
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         ELSE
            #CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
            #CHI-A70007 add --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
            ELSE
               CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date
            END IF
            #CHI-A70007 add --end--
            LET b_post_date = b_date
            LET e_post_date = e_date
            #no.4717日期不可小於關帳日期
            IF b_post_date <= g_aaa07 THEN
               CALL cl_err('date<aaa07','axm-164',0)
               NEXT FIELD y1
            END IF
            #no.4717(end)
            DISPLAY BY NAME b_post_date,e_post_date
         END IF
     #end MOD-8C0103 add

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

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
        CALL cl_cmdask()
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
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

   END INPUT
     #-->No.FUN-570145 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp103_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF

#   IF cl_sure(21,21) THEN
#      CALL cl_wait()
#      LET g_success = 'Y'
#      BEGIN WORK
#      CALL aglp103() #歸零,取消,還原 1.科目餘額檔2.分類帳檔3.異動別分類檔
##********因過帳作業可一期間過好幾次帳與重新過帳不同(重新過帳一定以期為單位),
#所以在此需將重新過帳的期間轉為起始、截止日期,如此才可共用同一SUBROUTINE。
#      #過帳,故需傳遞期間的起始、截止日期
#      CALL s_post(g_bookno,b_post_date,e_post_date,'','','Y',' 1=1')
#      IF tm.y1 != tm.aaa04 OR tm.m2 != tm.aaa05 THEN
#          #CALL cl_conf2(18,10,'agl-180','YN') RETURNING g_chr        #No.MOD-520088
#         CALL cl_confirm('agl-180') RETURNING g_chr
#          IF g_chr THEN                  #No.MOD-520088
#            CALL s_eom(g_bookno,b_date,e_date,tm.y1,tm.m2,'Y')
#         END IF
#      END IF
#      LET l_y1 = tm.y1
#      #若所重新處理資料的會計年度不是
#      #現行年度而是前幾年的資料時就需
#      #再作年結資料得處理(與期末結轉不同在於
#      #期末結轉會對帳別中現行期別的更新)
#      #將次年度期別零者刪除
#      IF tm.aaa04 > l_y1 THEN
#         #CALL cl_conf2(18,10,'agl-181','YN') RETURNING g_chr
#          CALL cl_confirm('agl-181') RETURNING g_chr           #No.MOD-520088
#          IF g_chr THEN                  #No.MOD-520088
#            WHILE tm.aaa04 > l_y1
#                CALL s_eoy(g_bookno,l_y1)
#                LET l_y1  = l_y1  + 1
#            END WHILE
#         END IF
#       END IF                   #No.MOD-520112
#      IF g_success='Y' THEN
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
   ERROR ""
#   END IF
 #END WHILE
   #CLOSE WINDOW aglp103_w
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aglp103"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('aglp103','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " '",tm.y1 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                        " '",b_post_date CLIPPED,"'",
                        " '",e_post_date CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aglp103',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp103_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
      END IF
      EXIT WHILE
END WHILE
      #-- No.FUN-570145 --end---

END FUNCTION

#No.FUN-740020  --Begin
FUNCTION p103_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti

   LET g_errno = ' '
   SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
   LET tm.y1=''              #MOD-930250 add
   CALL p103_pre(p_bookno)   #MOD-930250 add
   CASE
      WHEN l_aaaacti = 'N' LET g_errno = '9028'
      WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
      OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
END FUNCTION
#No.FUN-740020  --End

FUNCTION aglp103()
DEFINE
          l_str     LIKE ze_file.ze03,
          l_aea00   LIKE aea_file.aea00,
          l_aea01   LIKE aea_file.aea01,
          l_aea03   LIKE aea_file.aea03,
          l_aea04   LIKE aea_file.aea04,
          l_aec00   LIKE aec_file.aec00,
          l_aec01   LIKE aec_file.aec01,
          l_aec02   LIKE aec_file.aec02,
          l_aec03   LIKE aec_file.aec03,
          l_aec04   LIKE aec_file.aec04,
          l_aec05   LIKE aec_file.aec05,
          l_aec051  LIKE aec_file.aec051,
          l_aec052  LIKE aec_file.aec052,
          l_aeg00   LIKE aeg_file.aeg00,
          l_aeg01   LIKE aeg_file.aeg01,
          l_aeg02   LIKE aeg_file.aeg02,
          l_aeg03   LIKE aeg_file.aeg03,
          l_aeg04   LIKE aeg_file.aeg04,
          l_aeg05   LIKE aeg_file.aeg05,
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT         #No.FUN-680098   VARCHAR(600)
          l_buf     LIKE type_file.chr1000,       #         #No.FUN-680098   VARCHAR(80)
          #l_y1     LIKE type_file.num5,    #NO.FUN-570145   #No.FUN-680098   SMALLINT
          l_y11     LIKE type_file.num5,                     #No.FUN-680098   SMALLINT
          l_m2      LIKE type_file.num5,              #No.FUN-680098   SMALLINT
          l_aee02    	LIKE type_file.chr1,          #No.FUN-680098    VARCHAR(1)
          l_aag151,l_aag161,l_aag171,l_aag181 LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)                  #No.FUN-680098  VARCHAR(1)
          l_cnt1,l_cnt2    LIKE type_file.num5            # Already-cnt, N-cnt         #No.FUN-680098 smallint
     IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET g_row = 18 LET g_col = 36
     ELSE LET g_row = 18 LET g_col = 26
     END IF
     IF g_bgjob = 'N' THEN      #FUN-570145
        OPEN WINDOW aglp103_g_w AT g_row,g_col
                 WITH 9 rows, 30 COLUMNS
         CALL cl_getmsg('agl-024',g_lang) RETURNING l_str
        #DISPLAY l_str AT 3,10    #CHI-A70049 mark
     END IF

     SET LOCK  MODE TO WAIT
#----------------------------------------------------------------------
     #### 92/07/30 BY MAY 當月巳消耗預算金額必需歸零
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        UPDATE afc"
         CALL ui.Interface.refresh()
     END IF
{ckp1.1}UPDATE afc_file SET afc07 = 0 WHERE afc00 = tm.bookno AND  #No.FUN-740020
                                            afc03 = tm.y1 AND
                                            afc05 = tm.m2
     IF SQLCA.sqlcode THEN
#       CALL cl_err('zero afc',SQLCA.sqlcode,1) #No.FUN-660123
        CALL cl_err3("upd","afc_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","zero afc",1)   #No.FUN-660123  #No.FUN-740020
        LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
     END IF
#----------------------------------------------------------------------
     #將當期會計科目餘額歸零
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        UPDATE aah"
         CALL ui.Interface.refresh()
     END IF
{ckp#1} UPDATE aah_file SET(aah04,aah05,aah06,aah07)=(0,0,0,0)
            WHERE aah00 = tm.bookno AND aah02 = tm.y1 AND aah03 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('upd aah04=0',SQLCA.sqlcode,1) #No.FUN-660123
            CALL cl_err3("upd","aah_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd aah04=0",1)   #No.FUN-660123    #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     #add by danny 020226 外幣管理(A002)
     IF g_aaz.aaz83 = 'Y' THEN
        UPDATE tah_file SET tah04=0,tah05=0,tah06=0,
                            tah07=0,tah09=0,tah10=0
            WHERE tah00 = tm.bookno AND tah02 = tm.y1 AND tah03 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('upd tah04=0',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("upd","tah_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd tah04=0",1)   #No.FUN-660123  #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     END IF
#----------------------------------------------------------------------
     #將每日會計科目餘額歸零
     IF g_aaz.aaz51 = 'Y' THEN
       IF g_bgjob = 'N' THEN         #FUN-570145
           MESSAGE "        UPDATE aas"
           CALL ui.Interface.refresh()
       END IF
{ckp#1.1} UPDATE aas_file SET(aas04,aas05,aas06,aas07)=(0,0,0,0)
            WHERE aas00 = tm.bookno AND aas02 BETWEEN b_date AND e_date #No.FUN-740020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('upd aas04=0',SQLCA.sqlcode,1) #No.FUN-660123
            CALL cl_err3("upd","aas_file",tm.bookno,"",SQLCA.sqlcode,"","upd aas04=0",1)  #No.FUN-660123   #N.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
        #add by danny 020226 外幣管理(A002)
        IF g_aaz.aaz83 = 'Y' THEN
           UPDATE tas_file SET tas04=0,tas05=0,tas06=0,
                               tas07=0,tas09=0,tas10=0
            WHERE tas00 = tm.bookno AND tas02 BETWEEN b_date AND e_date #N.FUN-740020
           IF SQLCA.sqlcode THEN
#             CALL cl_err('upd tas04=0',SQLCA.sqlcode,1)   #No.FUN-660123
              CALL cl_err3("upd","tas_file",tm.bookno,"",SQLCA.sqlcode,"","upd tas04=0",1)   #No.FUN-660123  #No.FUN-740020
              LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
           END IF
        END IF
     END IF
#----------------------------------------------------------------------
     #將部門會計科目餘額歸零
     IF g_bgjob = 'N' THEN         #FUN-57014 5
        MESSAGE "        UPDATE aao"
        CALL ui.Interface.refresh()
     END IF
#{ckp#1.1} UPDATE aao_file SET(aao05,aao06)=(0,0)
#No.+462 010725 mod by linda
{ckp#1.1} UPDATE aao_file SET(aao05,aao06,aao07,aao08)=(0,0,0,0)
            WHERE aao00 = tm.bookno AND aao03 = tm.y1 AND aao04 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#          CALL cl_err('upd aao05=0',SQLCA.sqlcode,1) #No.FUN-660123
           CALL cl_err3("upd","aao_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd aao05=0",1)   #No.FUN-660123           #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     #add by danny 020226 外幣管理(A002)
     IF g_aaz.aaz83 = 'Y' THEN
        UPDATE tao_file SET tao05=0,tao06=0,tao07=0,
                            tao08=0,tao10=0,tao11=0
            WHERE tao00 = tm.bookno AND tao03 = tm.y1 AND tao04 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('upd tao05=0',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("upd","tao_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd tao05=0",1)   #No.FUN-660123   #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     END IF

#No.FUN-9A0052  --Begin
#----------------------------------------------------------------------
     #將當期的aeh_file科目異碼沖帳餘額檔歸零
     IF g_bgjob = 'N' THEN
         MESSAGE "        UPDATE aeh"
         CALL ui.Interface.refresh()
     END IF
     UPDATE aeh_file SET (aeh11,aeh12,aeh13,aeh14,aeh15,aeh16) = (0,0,0,0,0,0)
      WHERE aeh00=tm.bookno AND aeh09 = tm.y1 AND aeh10 = tm.m2
     IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","aeh_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd aed05=0",1)
          LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
     END IF
#No.FUN-9A0052  --End
#----------------------------------------------------------------------
     #將當期的aed_file科目異碼沖帳餘額檔歸零
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        UPDATE aed"
         CALL ui.Interface.refresh()
     END IF
{ckp#2} UPDATE aed_file SET (aed05,aed06,aed07,aed08) = (0,0,0,0)
            WHERE aed00=tm.bookno AND aed03 = tm.y1 AND aed04 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#            CALL cl_err('upd aed05=0',SQLCA.sqlcode,1) #No.FUN-660123
             CALL cl_err3("upd","aed_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd aed05=0",1)  #No.FUN-660123      #No.FUN-740020
             LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     #add by danny 020226 外幣管理(A002)
     IF g_aaz.aaz83 = 'Y' THEN
        UPDATE ted_file SET ted05=0,ted06=0,ted07=0,
                            ted08=0,ted10=0,ted11=0
            WHERE ted00=tm.bookno AND ted03 = tm.y1 AND ted04 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('upd ted05=0',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("upd","ted_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd ted05=0",1)   #No.FUN-660123   #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     END IF
#----------------------------------------------------------------------
     #no.6533
     #將當期的aef_file科目專案餘額檔歸零
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        UPDATE aef"
         CALL ui.Interface.refresh()
     END IF
{ckp#2} UPDATE aef_file SET (aef05,aef06,aef07,aef08) = (0,0,0,0)
            WHERE aef00=tm.bookno AND aef03 = tm.y1 AND aef04 = tm.m2  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#            CALL cl_err('upd aef05=0',SQLCA.sqlcode,1) #No.FUN-660123
             CALL cl_err3("upd","aef_file",tm.bookno,tm.y1,SQLCA.sqlcode,"","upd aed05=0",1)  #No.FUN-660123          #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
     #no.6533(end)
{    # 96-07-01 By Melody
     # 改為傳'過帳否'參數至 s_post 以判斷為'已過帳重新過帳' OR '未過帳整批過帳'
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        UPDATE aba"
     END IF
        UPDATE aba_file SET abapost = 'N'
            WHERE aba00 = tm.bookno AND (aba02 BETWEEN b_date AND e_date)  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#           CALL cl_err('upd abapost=N',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("upd","aba_file",tm.bookno,"",SQLCA.sqlcode,"","upd abapost=N",1)   #No.FUN-660123   #No.FUN-740020
            LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
}
#----------------------------------------------------------------------
     #將最近過帳日期更新(帳別檔中)
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        UPDATE aaa"
         CALL ui.Interface.refresh()
     END IF
{ckp#4} UPDATE aaa_file SET  aaa06 = g_today WHERE aaa01 = tm.bookno  #No.FUN-740020
        IF SQLCA.sqlcode THEN
#            CALL cl_err('upd aaa06=today',SQLCA.sqlcode,1)  #No.FUN-660123
             CALL cl_err3("upd","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","upd aaa06=today",1)   #No.FUN-660123  #No.FUN-740020
             LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
        END IF
#----------------------------------------------------------------------
     #刪除分類帳
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        Delete aea"
         CALL ui.Interface.refresh()
     END IF
     DELETE FROM aea_file WHERE aea00 = tm.bookno AND   #No.FUN-740020
                                (aea02 BETWEEN b_date AND e_date)
     IF STATUS THEN
        DECLARE del_aea_c CURSOR FOR
        SELECT aea00,aea01,aea03,aea04 FROM aea_file WHERE aea00 = tm.bookno AND   #No.FUN-740020
                                   (aea02 BETWEEN b_date AND e_date)
        CALL s_showmsg_init()           #NO.FUN-710023
        FOREACH del_aea_c INTO l_aea00,l_aea01,l_aea03,l_aea04
#NO.FUN-710023--BEGIN
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF
#NO.FUN-710023--END
           IF g_bgjob = 'N' THEN         #FUN-570145
               CALL ui.Interface.refresh()
           END IF
           DELETE FROM aea_file WHERE aea00 = l_aea00 AND aea01 = l_aea01 AND aea03 = l_aea03 AND aea04 = l_aea04
           IF SQLCA.sqlcode THEN
#              CALL cl_err('del aea:',SQLCA.sqlcode,1)   #No.FUN-660123
#              CALL cl_err3("del","aea_file","","",SQLCA.sqlcode,"","del aea:",1)   #No.FUN-660123 #NO.FUN-710023
               CALL s_errmsg('aea01',l_aea01,'del aea',SQLCA.sqlcode,1)          #NO.FUN-710023
#              LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN                    #NO.FUN-710023
               LET g_success='N' CONTINUE FOREACH                                   #NO.FUN-710023
           END IF
        END FOREACH
#NO.FUN-710023--BEGIN
           IF g_totsuccess="N" THEN
             LET g_success="N"
           END IF
#NO.FUN-710023--END
     END IF
#----------------------------------------------------------------------
     #刪除當期異動明細檔
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        Delete aec"
         CALL ui.Interface.refresh()
     END IF
     DELETE FROM aec_file WHERE aec00 = tm.bookno AND   #No.FUN-740020
                                (aec02 BETWEEN b_date AND e_date )
     IF STATUS THEN
        DECLARE del_aec_c CURSOR FOR
           SELECT unique aec00,aec01,aec02,aec03,aec04,aec05,aec051,aec052 FROM aec_file WHERE aec00 = tm.bookno AND   #No.FUN-740020
                                   (aec02 BETWEEN b_date AND e_date )
        FOREACH del_aec_c INTO l_aec00,l_aec01,l_aec02,l_aec03,l_aec04,l_aec05,l_aec051,l_aec052
#NO.FUN-710023--BEGIN
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF
#NO.FUN-710023--END
        IF g_bgjob = 'N' THEN         #FUN-570145
           CALL ui.Interface.refresh()
        END IF
           DELETE FROM aec_file WHERE aec00 = l_aec00 AND aec01 = l_aec01 AND aec02 = l_aec02
          AND aec03 = l_aec03 AND aec04 = l_aec04 AND aec05 = l_aec05 AND aec051 = l_aec051 AND aec052 = l_aec052
           IF SQLCA.sqlcode THEN
#              CALL cl_err('del aec',SQLCA.sqlcode,1)   #No.FUN-660123
#              CALL cl_err3("del","aec_file",tm.bookno,"",SQLCA.sqlcode,"","del aec",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
               CALL s_errmsg('aec01',l_aec01,'del aec',SQLCA.sqlcode,1)                #NO.FUN-710023
#              LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN                         #NO.FUN-710023
               LET g_success='N' CONTINUE FOREACH                                        #NO.FUN-710023
           END IF
        END FOREACH
#NO.FUN-710023--BEGIN
           IF g_totsuccess="N" THEN
             LET g_success="N"
           END IF
#NO.FUN-710023--END
     END IF
     #no.6533
     #刪除當期專案明細檔
     IF g_bgjob = 'N' THEN         #FUN-570145
         MESSAGE "        Delete aeg"
         CALL ui.Interface.refresh()
     END IF
     DELETE FROM aeg_file WHERE aeg00 = tm.bookno AND   #No.FUN-740020
                                (aeg02 BETWEEN b_date AND e_date )
     IF STATUS THEN
        DECLARE del_aeg_c CURSOR FOR
           SELECT unique aeg00,aeg01,aeg02,aeg03,aeg04,aeg05 FROM aeg_file WHERE aeg00 = tm.bookno AND   #No.FUN-740020
                                   (aeg02 BETWEEN b_date AND e_date )
        FOREACH del_aec_c INTO l_aec00,l_aec01,l_aec02,l_aec03,l_aec04,l_aec05,l_aec051,l_aec052
#NO.FUN-710023--BEGIN
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF
#NO.FUN-710023--END
        IF g_bgjob = 'N' THEN         #FUN-570145
           CALL ui.Interface.refresh()
        END IF
           DELETE FROM aeg_file WHERE aeg00 = l_aeg00 AND aeg01 = l_aeg01 AND aeg02 = l_aeg02 AND aeg03 = l_aeg03 AND aeg04 = l_aeg04 AND aeg05 = l_aeg05
           IF SQLCA.sqlcode THEN
#              CALL cl_err('del aec',SQLCA.sqlcode,1)   #No.FUN-660123
#              CALL cl_err3("del","aeg_file",tm.bookno,"",SQLCA.sqlcode,"","del aec",1)   #No.FUN-660123 #NO.FUN-710023  #No.FUN-740020
               CALL s_errmsg('aec01',l_aec01,'del aec',SQLCA.sqlcode,1)                #NO.FUN-710023
#              LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN                         #NO.FUN-710023
               LET g_success='N' CONTINUE FOREACH                                        #NO.FUN-710023
           END IF
        END FOREACH
#NO.FUN-710023--BEGIN
        IF g_totsuccess="N" THEN
           LET g_success="N"
        END IF
#NO.FUN-710023--END
     END IF
     #no.6533(end)
#----------------------------------------------------------------------
## No:2515  modify 1998/10/13 -----------
#No.TQC-9B0015  --Begin
#{
#     #刪除當期異動明細檔
#     IF g_bgjob = 'N' THEN         #FUN-570145
#         MESSAGE "        Delete aee"
#     END IF
#        DECLARE del_aee_c CURSOR FOR
#           SELECT aee_file.rowid,aee02,aag151,aag161,aag171,aag181
#                  FROM aee_file,aag_file
#                  WHERE aee01 = aag01 AND (aee06 BETWEEN b_date AND e_date )
#        FOREACH del_aee_c INTO l_aee_rowid,l_aee02,
#                                 l_aag151,l_aag161,l_aag171,l_aag181
#           IF SQLCA.sqlcode THEN
#              CALL cl_err('del aee:',SQLCA.sqlcode,1)
#              LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
#           END IF
#           CASE WHEN l_aee02 = '1' AND l_aag151 = '3' CONTINUE FOREACH
#                WHEN l_aee02 = '2' AND l_aag161 = '3' CONTINUE FOREACH
#                WHEN l_aee02 = '3' AND l_aag171 = '3' CONTINUE FOREACH
#                WHEN l_aee02 = '4' AND l_aag181 = '3' CONTINUE FOREACH
#           END CASE
##ckp#6.1#  DELETE FROM aee_file WHERE rowid=l_aee_rowid
#           IF SQLCA.sqlcode THEN
##              CALL cl_err('(aglp103:ckp#6.1)',SQLCA.sqlcode,1)  #No.FUN-660123
#               CALL cl_err3("del","aee_file",l_aee02,"",SQLCA.sqlcode,"","(aglp103:ckp#6.1)",1)   #No.FUN-660123
#               LET g_success='N' CLOSE WINDOW aglp103_g_w RETURN
#           END IF
#        END FOREACH
#     #display SQLCA.SQLERRD[3] at 4,20
#}
#No.TQC-9B0015  --End
#----------------------------------------------------------------------
     #RA傳票的刪除
        IF (tm.m2 = 12  AND g_aza.aza02 = '1') OR #若為'12'期則INSERT為次年度
           (tm.m2 = 13  AND g_aza.aza02  = '2') THEN
           LET l_y1 = tm.y1 + 1
           LET l_m2 = 1
        ELSE
           LET l_y1 = tm.y1
           LET l_m2 = tm.m2 + 1
       END IF
     #刪除當期來源碼為'CE'者 ---> 改為 s_eom() 刪除, 920909 by Roger
     #刪除當期來源碼為'RA'者 ---> 改為 s_eom() 刪除, 920909 by Roger
     CLOSE WINDOW aglp103_g_w
     CALL p103_p()        #FUN-570145
END FUNCTION

#FUN-570145 ---start---
FUNCTION p103_pre(p_bookno)                  #MOD-930250 mod
   DEFINE p_bookno   LIKE aaa_file.aaa01     #MOD-930250 add
   DEFINE l_flag     LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)

   SELECT aaa04,aaa05,aaa07 INTO tm.aaa04,tm.aaa05,g_aaa07
     FROM aaa_file WHERE aaa01 = p_bookno  #No.FUN-740020   #MOD-930250 mod
   IF tm.y1 IS NULL OR tm.y1 = ' ' THEN
      LET tm.y1 = tm.aaa04
      LET tm.m2 = tm.aaa05
   END IF
   #CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,b_date,e_date
   ELSE
      CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,b_date,e_date
   END IF
   #CHI-A70007 add --end--
   LET b_post_date = b_date
   LET e_post_date = e_date
   DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.y1,tm.m2,b_post_date,e_post_date   #MOD-930250 add
END FUNCTION

FUNCTION p103_p()
# CALL s_post(tm.bookno,b_post_date,e_post_date,'','','Y',' 1=1')  #No.FUN-740020 #No.FUN-920155
  CALL p103_del_CE(tm.bookno,e_date)   #TQC-C50055
  CALL aglp102_post(tm.bookno,b_post_date,e_post_date,'','','Y',' 1=1')           #No.FUN-920155
  IF tm.y1 != tm.aaa04 OR tm.m2 != tm.aaa05 THEN
     IF g_bgjob = 'N' THEN
        CALL cl_confirm('agl-180') RETURNING g_chr
     ELSE
        LET g_chr = 'Y'
     END IF

     IF g_chr THEN                  #No:BUG-520088
        CALL s_eom(tm.bookno,b_date,e_date,tm.y1,tm.m2,'Y')  #No.FUN-740020
     END IF
  END IF
  LET l_y1 = tm.y1
  #若所重新處理資料的會計年度不是現行年度而是前幾年的資料時就需
  #再作年結資料得處理(與期末結轉不同在於期末結轉會對帳別中現行期別的更新)
  #將次年度期別零者刪除
  IF tm.aaa04 > l_y1 THEN
     IF g_bgjob = 'N' THEN
        CALL cl_confirm('agl-181') RETURNING g_chr           #No:BUG-520088
     ELSE
        LET g_chr = 'Y'
     END IF
     IF g_chr THEN                  #No:BUG-520088
        WHILE tm.aaa04 > l_y1
              #No.FUN-AB0068  --Begin                                           
              #CALL s_eoy(tm.bookno,l_y1)  #No.FUN-740020                       
              CALL s_eoy(tm.bookno,l_y1,'N')                                    
              #No.FUN-AB0068  --End
              LET l_y1  = l_y1  + 1
        END WHILE
     END IF
  END IF                   #No:BUG-520112
END FUNCTION

#FUN-570145 ---end---
#MOD-730008
#-TQC-C50055-add-
FUNCTION p103_del_CE(p_bookno,p_edate) #刪除當期來源碼為'CE'者傳票, 以便重新產生
 DEFINE p_bookno          LIKE aba_file.aba00     
 DEFINE p_edate           LIKE type_file.dat     
 DEFINE l_abh             RECORD LIKE abh_file.*     
 DEFINE l_abh09,l_abh09_2 LIKE abh_file.abh09       
 DEFINE l_sql             STRING                
 DEFINE l_cnt             LIKE type_file.num5 

  #需一併刪除abh_file
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM abb_file,aag_file
    WHERE abb03=aag01 AND abb00=aag00
      AND aag20='Y'
      AND abb00 = p_bookno
      AND abb01 IN (SELECT aba01 FROM aba_file
                     WHERE aba00 = p_bookno
                       AND aba02 = p_edate
                       AND aba19 <> 'X'  #CHI-C80041
                       AND aba06 = 'CE')
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      LET l_sql =  "SELECT * FROM abh_file ",
                   " WHERE abh00 = ",p_bookno,
                   "   AND abh01 IN (SELECT aba01 FROM aba_file ",
                   "                  WHERE aba00 = ",p_bookno,
                   "                    AND aba02 = '",p_edate,"'",
                   "                    AND aba19 <> 'X' ",  #CHI-C80041
                   "                    AND aba06 = 'CE') "
      PREPARE abh_pre FROM l_sql
      DECLARE abh_curs1 CURSOR FOR abh_pre
      FOREACH abh_curs1 INTO l_abh.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
 {ckp#2a}  
         DELETE FROM abh_file
          WHERE abh00=l_abh.abh00
            AND abh01=l_abh.abh01
            AND abh02=l_abh.abh02
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg('abh00',p_bookno,'(s_del_CE:ckp#2a)',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("del","abh_file",p_bookno,"",SQLCA.sqlcode,"","(s_del_CE:ckp#2a)",1)
            END IF
            LET g_success='N' 
            RETURN
         END IF
         LET l_abh09 = 0
         SELECT SUM(abh09) INTO l_abh09 FROM abh_file
          WHERE abhconf='Y' AND abh07=l_abh.abh07
            AND abh08=l_abh.abh08
            AND abh00=l_abh.abh00       
         IF cl_null(l_abh09) THEN LET l_abh09=0 END IF
         LET l_abh09_2 = 0
         SELECT SUM(abh09) INTO l_abh09_2 FROM abh_file
          WHERE abhconf='N' AND abh07=l_abh.abh07
            AND abh08=l_abh.abh08
            AND abh00=l_abh.abh00 
         IF cl_null(l_abh09_2) THEN LET l_abh09_2=0 END IF
         UPDATE abg_file SET abg072=l_abh09,
                             abg073=l_abh09_2
          WHERE abg00=p_bookno
            AND abg01=l_abh.abh07 
            AND abg02=l_abh.abh08
      END FOREACH
   END IF
         
{ckp#21} 
   DELETE FROM tic_file
    WHERE tic00 = p_bookno
      AND tic04 IN (SELECT aba01 FROM aba_file
                     WHERE aba00 = p_bookno
                       AND aba02 = p_edate
                       AND aba19 <> 'X'  #CHI-C80041
                       AND aba06 = 'CE')
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
        CALL s_errmsg('abb00',p_bookno,'(s_del_CE:ckp#21)',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err3("del","tic_file",p_bookno,"",SQLCA.sqlcode,"","(s_del_CE:ckp#21)",1)
      END IF
      LET g_success='N' 
      RETURN
   END IF
    
{ckp#21} 
   DELETE FROM abb_file
    WHERE abb00 = p_bookno
      AND abb01 IN (SELECT aba01 FROM aba_file
                     WHERE aba00 = p_bookno
                       AND aba02 = p_edate
                       AND aba19 <> 'X'  #CHI-C80041
                       AND aba06 = 'CE')
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
        CALL s_errmsg('abb00',p_bookno,'(s_del_CE:ckp#21)',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err3("del","abb_file",p_bookno,"",SQLCA.sqlcode,"","(s_del_CE:ckp#21)",1)
      END IF
      LET g_success='N' 
      RETURN
   END IF
{ckp#22} 
   DELETE FROM aba_file
    WHERE aba00 = p_bookno
      AND aba02 = p_edate
      AND aba19 <> 'X'  #CHI-C80041
      AND aba06 = 'CE'
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
        LET g_showmsg=p_bookno,"/",p_edate,"/",'CE'
        CALL s_errmsg('abb00,aba02,aba06',g_showmsg,'(s_del_CE:ckp#22)',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err3("del","aba_file",p_bookno,p_edate,SQLCA.sqlcode,"","(s_del_CE:ckp#22)",1)
      END IF
      LET g_success='N' 
      RETURN
   END IF

END FUNCTION
#-TQC-C50055-end-
