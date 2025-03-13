# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp209.4gl
# Descriptions...: 獨立轉明細科目
# Input parameter:
# Return code....:
# Date & Author..: 93/07/02 By Roger
# Modify.........: By Melody    新增 check 輸入科目必須存在會計主檔
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-590351 05/10/21 By Carrier 加入外幣檔案
# Modify.........: No.FUN-570145 06/02/27 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-740065 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-920041 09/02/05 By Sarah 所有SQL皆須過濾帳別
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0052 09/11/17 By Carrier 增加'科目核算項'統計檔功能
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50149 11/05/24 By yinhy 原獨立科目应自动update成統制科目，且自動新建明細科目
# Modify.........: No.TQC-B60002 11/05/24 By yinhy 獨立科目已存在未審核、未拋轉的分錄底稿或未審核、未過賬的憑證,也可以轉為明細科目
# Modify.........: No.TQC-C30287 12/03/22 By zhangweib 加上區域別功能,即大陸版時才可開啟此作業.
# Modify.........: No.MOD-C70212 12/08/01 By Elise FUNCTION p209_chk_aag01錯誤代碼agl-241應RETURN 1

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE bookno LIKE aaa_file.aaa01         #No.FUN-740065
DEFINE old_no LIKE aag_file.aag01         #No.FUN-680098      VARCHAR(24)
DEFINE new_no LIKE aag_file.aag01         #No.FUN-680098      VARCHAR(24)
DEFINE g_aag  RECORD LIKE aag_file.*
DEFINE g_aag1 RECORD LIKE aag_file.*
DEFINE g_bookno   LIKE aea_file.aea00      #帳別
DEFINE ls_date      STRING,                 #No.FUN-570145
      l_flag          LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
      g_change_lang   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10  #No.FUN-B50149
DEFINE g_flag2        LIKE type_file.chr1   #No.FUN-B50149
MAIN
#     DEFINE     l_time LIKE type_file.chr8              #No.FUN-6A0073

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    LET bookno = ARG_VAL(1)  #No.FUN-740065
#->No.FUN-570145 --start--
  INITIALIZE g_bgjob_msgfile TO NULL
  LET bookno = ARG_VAL(1)    #No.FUN-740065
  LET old_no = ARG_VAL(2)
  LET new_no = ARG_VAL(3)
  LET g_bgjob  = ARG_VAL(4)
  IF cl_null(g_bgjob) THEN
     LET g_bgjob= "N"
  END IF
#->No.FUN-570145 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

  #No.TQC-C30287   --start---   Add
   IF g_aza.aza26 <> '2' THEN
      CALL cl_err('','tis-004',1)
      EXIT PROGRAM          
   END IF
  #No.TQC-C30287   --end---     Add

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

    #No.FUN-740065  --Begin
    #LET g_bookno = ARG_VAL(1)
    IF bookno IS NULL OR bookno = ' ' THEN
#      SELECT aaz64 INTO g_bookno FROM aaz_file
       LET bookno = g_aza.aza81
    END IF
    #No.FUN-740065  --End
 #->No.FUN-570145 --start--
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp209_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL aglp209()
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
              CLOSE WINDOW aglp209_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL aglp209()
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
  END WHILE
#->No.FUN-570145 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION aglp209_tm(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5          #No.FUN-680098 SMALLINT
    DEFINE  l_flag         LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
    DEFINE  lc_cmd         LIKE type_file.chr1000       #FUN-570145    #No.FUN-680098  VARCHAR(500)
    DEFINE  l_n            LIKE type_file.num5          #FUN-B50149
   CALL s_dsmark(bookno)  #No.FUN-740065

   LET p_row = 3 LET p_col = 26

   OPEN WINDOW aglp209_w AT p_row,p_col WITH FORM "agl/42f/aglp209"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   CALL s_shwact(0,0,bookno)  #No.FUN-740065
   CALL cl_opmsg('q')
   WHILE TRUE
# Prog. Version..: '5.30.06-13.03.12(0) THEN RETURN END IF     #FUN-570145
      CLEAR FORM
      LET g_bgjob = 'N'        #No.FUN-570145
      LET bookno = g_aza.aza81  #No.FUN-740065
      DISPLAY BY NAME bookno    #No.FUN-740065
      INPUT BY NAME bookno,old_no,new_no,g_bgjob WITHOUT DEFAULTS  #No.FUN-740065
         ON ACTION locale
#           CALL cl_dynamic_locale()                #FUN-570145
#           CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
            LET g_change_lang = TRUE                 #No.FUN-570145
            EXIT INPUT

         #No.FUN-740065  --Begin
         AFTER FIELD bookno
            IF NOT cl_null(bookno) THEN
               CALL p209_bookno(bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(bookno,g_errno,0)
                  LET bookno = g_aza.aza81
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
               END IF
            END IF
         #No.FUN-740065  --End

         AFTER FIELD old_no
            IF old_no IS NULL THEN NEXT FIELD old_no END IF
            # 96-06-18
            SELECT * FROM aag_file WHERE aag01=old_no AND aag07='3'
                                     AND aag00=bookno  #No.FUN-740065
            IF STATUS=100 THEN
#              CALL cl_err('','agl-925',0)   #No.FUN-660123
               CALL cl_err3("sel","aag_file",old_no,bookno,"agl-925","","",0)   #No.FUN-660123  #No.FUN-740065
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = old_no
               LET g_qryparam.arg1 = bookno
               LET g_qryparam.where = " aag07 ='3' AND aag01 LIKE '",old_no CLIPPED,"%'"
               CALL cl_create_qry() RETURNING old_no
               DISPLAY BY NAME old_no 
               NEXT FIELD old_no
               #End Add No.FUN-B10048
            END IF
            DISPLAY old_no TO old_no2
            IF new_no IS NULL THEN
               LET new_no = old_no DISPLAY BY NAME new_no
            END IF

         AFTER FIELD new_no
            #IF new_no IS NULL THEN NEXT FIELD new_no END IF
#No.FUN-B50149  --Begin
#            # 96-06-18
#            SELECT * FROM aag_file WHERE aag01=new_no AND aag07='2'
#                                     AND aag00=bookno   #No.FUN-740065
#            IF STATUS=100 THEN
##              CALL cl_err('','agl-001',0)   #No.FUN-660123
#               CALL cl_err3("sel","aag_file",new_no,bookno,"agl-001","","",0)   #No.FUN-660123  #No.FUN-740065
#               #Add No.FUN-B10048
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_aag"
#               LET g_qryparam.construct = 'N'
#               LET g_qryparam.default1 = new_no
#               LET g_qryparam.arg1 = bookno
#               LET g_qryparam.where = " aag07 ='2' AND aag01 LIKE '",new_no CLIPPED,"%'"
#               CALL cl_create_qry() RETURNING new_no
#               DISPLAY BY NAME new_no
#               #End Add No.FUN-B10048
#               NEXT FIELD new_no
#            END IF
         IF NOT cl_null(new_no) AND NOT cl_null(bookno) THEN
            SELECT count(*) INTO l_n FROM aag_file
                WHERE aag01 = new_no
                  AND aag00 = bookno
               IF l_n > 0 THEN  # Duplicated
                  CALL cl_err(new_no,-239,0)                 
                  DISPLAY BY NAME new_no
                  DISPLAY BY NAME bookno
                  NEXT FIELD new_no
               END IF
            CALL s_field_chk(new_no,'6',g_plant,'aag01') RETURNING g_flag2
             IF g_flag2 = '0' THEN                                            
                CALL cl_err(new_no,'aoo-043',1)                                                   
                DISPLAY BY NAME new_no                                
                NEXT FIELD new_no                                             
             END IF 
         END IF                                                                 
         IF p209_chk_aag01(new_no) THEN 
           NEXT FIELD new_no
         END IF 
#No.FUN-B50149  --End

          
         ON ACTION CONTROLP
            CASE
               #No.FUN-740065  --Begin
               WHEN INFIELD(bookno)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aaa"
                   LET g_qryparam.default1 = bookno
                   CALL cl_create_qry() RETURNING bookno
                   DISPLAY BY NAME bookno
                   NEXT FIELD bookno
               #No.FUN-740065  --End
               WHEN INFIELD(old_no)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = old_no
                   LET g_qryparam.arg1 = bookno   #No.FUN-740065
                   LET g_qryparam.where = " aag07 ='3' "
                   CALL cl_create_qry() RETURNING old_no
#                  CALL FGL_DIALOG_SETBUFFER( old_no )
                   DISPLAY BY NAME old_no               #No.MOD-490344
                   NEXT FIELD old_no
               WHEN INFIELD(new_no)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = new_no
                   LET g_qryparam.arg1 = bookno   #No.FUN-740065
                   LET g_qryparam.where = " aag07 ='2' "
                   CALL cl_create_qry() RETURNING new_no
#                  CALL FGL_DIALOG_SETBUFFER( new_no )
                   DISPLAY BY NAME new_no               #No.MOD-490344
                   NEXT FIELD new_no
            END CASE

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
#NO.FUN-570145 START--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp209_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
     #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
#     IF cl_sure(21,21) THEN
#        LET g_success = 'Y'
#        BEGIN WORK
#        CALL aglp209()
#        IF g_success='Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01= 'aglp209'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp209','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",old_no  CLIPPED,"'",
                         " '",new_no  CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp209',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp209_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#->No.FUN-570145 --end--
#  CLOSE WINDOW aglp209_w
END FUNCTION

#No.FUN-740065  --Begin
FUNCTION p209_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti

    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
       WHEN l_aaaacti = 'N' LET g_errno = '9028'
       WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION
#No.FUN-740065  --End

FUNCTION aglp209()
   DEFINE g_bookno1    LIKE aza_file.aza81    #No.TQC-B60002
   DEFINE g_bookno2    LIKE aza_file.aza82    #No.TQC-B60002
   DEFINE g_flag       LIKE type_file.chr1    #No.TQC-B60002
   DEFINE l_npqtype    LIKE npq_file.npqtype  #No.TQC-B60002
   CALL cl_wait()
   WHILE TRUE
      #No.FUN-B50149  --Begin
      UPDATE aag_file SET aag07 = '1'  WHERE aag00 = bookno AND aag01 = old_no
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF        
      INSERT INTO aag_file VALUES (g_aag.*) 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF   
      #No.FUN-B50149  --End
#----------------------- generate aah 明細 ---------------------------
      DROP TABLE x
      SELECT * FROM aah_file WHERE aah01 = old_no AND aah00=bookno INTO TEMP x  #MOD-920041 mod
      IF STATUS THEN CALL x('p209.ckp#1') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from aah into temp'
      END IF
      UPDATE x SET x.aah01 = new_no
      IF STATUS THEN CALL x('p209.ckp#2') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows in temp updated'
      END IF
      INSERT INTO aah_file SELECT * FROM x
      IF STATUS THEN CALL x('p209.ckp#3') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from temp into aah'
      END IF
#----------------------- generate aao 明細 ---------------------------
      DROP TABLE x
      SELECT * FROM aao_file WHERE aao01 = old_no AND aao00=bookno INTO TEMP x  #MOD-920041 mod
      IF STATUS THEN CALL x('p209.ckp#1') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from aao into temp'
      END IF
      UPDATE x SET x.aao01 = new_no
      IF STATUS THEN CALL x('p209.ckp#2') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows in temp updated'
      END IF
      IF INT_FLAG THEN LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      INSERT INTO aao_file SELECT * FROM x
      IF STATUS THEN CALL x('p209.ckp#3') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from temp into aao'
      END IF
#----------------------- generate aas 明細 ---------------------------
      DROP TABLE x
      SELECT * FROM aas_file WHERE aas01 = old_no AND aas00=bookno INTO TEMP x  #MOD-920041 mod
      IF STATUS THEN CALL x('p209.ckp#1') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from aas into temp'
      END IF
      UPDATE x SET x.aas01 = new_no
      IF STATUS THEN CALL x('p209.ckp#2') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows in temp updated'
      END IF
      INSERT INTO aas_file SELECT * FROM x
      IF STATUS THEN CALL x('p209.ckp#3') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from temp into aas'
      END IF
#----------------------- update abb03 from old_no to new_no ----------
      UPDATE abb_file SET abb03 = new_no WHERE abb03 = old_no
                                           AND abb00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#4') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of abb updated'
      END IF
#----------------------- update aed01 from old_no to new_no ----------
      UPDATE aed_file SET aed01 = new_no WHERE aed01 = old_no
                                           AND aed00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#5') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of aed updated'
      END IF
#----------------------- update aea05 from old_no to new_no ----------
      UPDATE aea_file SET aea05 = new_no WHERE aea05 = old_no
                                           AND aea00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#7') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of aea updated'
      END IF
#----------------------- update aec01 from old_no to new_no ----------
      UPDATE aec_file SET aec01 = new_no WHERE aec01 = old_no
                                           AND aec00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#8') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of aec updated'
      END IF
#----------------------- update afb02 from old_no to new_no ----------
      UPDATE afb_file SET afb02 = new_no WHERE afb02 = old_no
                                           AND afb00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#9') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of afb updated'
      END IF
#----------------------- update afc02 from old_no to new_no ----------
      UPDATE afc_file SET afc02 = new_no WHERE afc02 = old_no
                                           AND afc00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#10') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of afc updated'
      END IF
#----------------------- update ahb03 from old_no to new_no ----------
      UPDATE ahb_file SET ahb03 = new_no WHERE ahb03 = old_no
                                           AND ahb00 = bookno #no.7277  #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#11') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of ahb updated'
      END IF
#---------------------------------------------------------------------
#No.TQC-B60002  --Begin
#----------------------- update npr00 from old_no to new_no ---------- 
      UPDATE npr_file SET npr00 = new_no WHERE npr00 = old_no
                                           AND npr09 = bookno #no.7277  #No.FUN-740065
         IF STATUS THEN CALL x('p209.ckp#11') EXIT WHILE END IF
         IF g_bgjob= 'N' THEN          #FUN-570145
             DISPLAY SQLCA.SQLERRD[3],' rows of npr updated'
         END IF

#----------------------- update npq00 from old_no to new_no ---------- 
     CALL s_get_bookno1(NULL,g_plant) RETURNING g_flag,g_bookno1,g_bookno2
     IF g_flag = '0' THEN
        IF g_bookno1 = bookno THEN LET l_npqtype = '0' END IF
        IF g_bookno2 = bookno THEN LET l_npqtype = '1' END IF
     END IF
      UPDATE npq_file SET npq03 = new_no WHERE npq03 = old_no
                                           AND npqtype = l_npqtype #no.7277  #No.FUN-740065
         IF STATUS THEN CALL x('p209.ckp#11') EXIT WHILE END IF
         IF g_bgjob= 'N' THEN          #FUN-570145
             DISPLAY SQLCA.SQLERRD[3],' rows of npq updated'
         END IF
#----------------------- update apm from old_no to new_no ---------- 
      UPDATE apm_file SET apm00 = new_no WHERE apm00 = old_no
                                          AND apm09 = bookno #no.7277  #No.FUN-740065
         IF STATUS THEN CALL x('p209.ckp#11') EXIT WHILE END IF
         IF g_bgjob= 'N' THEN          #FUN-570145
             DISPLAY SQLCA.SQLERRD[3],' rows of apm updated'
         END IF
#----------------------- update apn from old_no to new_no ---------- 
      UPDATE apn_file SET apn00 = new_no WHERE apn00 = old_no
                                          AND apn09 = bookno #no.7277  #No.FUN-740065
         IF STATUS THEN CALL x('p209.ckp#11') EXIT WHILE END IF
         IF g_bgjob= 'N' THEN          #FUN-570145
             DISPLAY SQLCA.SQLERRD[3],' rows of apn updated'
         END IF
#----------------------- update ooo from old_no to new_no ---------- 
      UPDATE ooo_file SET ooo03 = new_no WHERE ooo03 = old_no
                                          AND ooo11 = bookno #no.7277  #No.FUN-740065
         IF STATUS THEN CALL x('p209.ckp#11') EXIT WHILE END IF
         IF g_bgjob= 'N' THEN          #FUN-570145
             DISPLAY SQLCA.SQLERRD[3],' rows of ooo updated'
         END IF
#No.TQC-B60002  --End
#No.MOD-590351  --begin
#----------------------- generate tah 明細 ---------------------------
      DROP TABLE x
      SELECT * FROM tah_file WHERE tah01 = old_no AND tah00=bookno INTO TEMP x  #MOD-920041 mod
      IF STATUS THEN CALL x('p209.ckp#1') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from tah into temp'
      END IF
      UPDATE x SET x.tah01 = new_no
      IF STATUS THEN CALL x('p209.ckp#2') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows in temp updated'
      END IF
      INSERT INTO tah_file SELECT * FROM x
      IF STATUS THEN CALL x('p209.ckp#3') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from temp into tah'
      END IF
#----------------------- generate tao 明細 ---------------------------
      DROP TABLE x
      SELECT * FROM tao_file WHERE tao01 = old_no AND tao00=bookno INTO TEMP x  #MOD-920041 mod
      IF STATUS THEN CALL x('p209.ckp#1') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from tao into temp'
      END IF
      UPDATE x SET x.tao01 = new_no
      IF STATUS THEN CALL x('p209.ckp#2') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows in temp updated'
      END IF
      INSERT INTO tao_file SELECT * FROM x
      IF STATUS THEN CALL x('p209.ckp#3') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from temp into tao'
      END IF
#----------------------- generate tas 明細 ---------------------------
      DROP TABLE x
      SELECT * FROM tas_file WHERE tas01 = old_no AND tas00=bookno INTO TEMP x  #MOD-920041 mod
      IF STATUS THEN CALL x('p209.ckp#1') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from tas into temp'
      END IF
      UPDATE x SET x.tas01 = new_no
      IF STATUS THEN CALL x('p209.ckp#2') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows in temp updated'
      END IF
      INSERT INTO tas_file SELECT * FROM x
      IF STATUS THEN CALL x('p209.ckp#3') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows from temp into tas'
      END IF
#-----No.FUN-9A0052 Beg- update aeh01 from old_no to new_no ----------
      UPDATE aeh_file SET aeh01 = new_no WHERE aeh01 = old_no
                                           AND aeh00 = bookno #no.7277          #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#5') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of aeh updated'
      END IF
#-----No.FUN-9A0052 End-----------------------------------------------
#----------------------- update ted01 from old_no to new_no ----------
      UPDATE ted_file SET ted01 = new_no WHERE ted01 = old_no
                                           AND ted00 = bookno #no.7277          #No.FUN-740065
      IF STATUS THEN CALL x('p209.ckp#5') EXIT WHILE END IF
      IF g_bgjob= 'N' THEN          #FUN-570145
         DISPLAY SQLCA.SQLERRD[3],' rows of ted updated'
      END IF
#---------------------------------------------------------------------
#No.MOD-590351  --end
      
      ERROR 'O.K.!'
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION x(l_msg)
   DEFINE l_msg    LIKE type_file.chr1000      #No.FUN-680098    VARCHAR(40)
   CALL cl_err(l_msg,SQLCA.SQLCODE,1)
   LET g_success = 'N'
END FUNCTION

#No.FUN-B50149  --Begin
#No.TQC-B60002  --Mark Begin
#FUNCTION aglp209_chk()
#   DEFINE g_bookno1    LIKE aza_file.aza81
#   DEFINE g_bookno2    LIKE aza_file.aza82
#   DEFINE g_flag       LIKE type_file.chr1  
#
#    CALL s_get_bookno1(NULL,g_plant) RETURNING g_flag,g_bookno1,g_bookno2
#    IF g_flag = '0' THEN  
#       IF bookno = g_bookno1 THEN
#          LET g_cnt = 0
#          SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
#            WHERE npp00 = npq00
#              AND npp01 = npq01
#              AND npp011 = npq011
#              AND nppsys = npqsys
#              AND npptype = npqtype
#              AND npq03 = g_aag.aag01
#              AND nppglno IS NULL
#              AND npqtype = '0'   
#          IF g_cnt > 0 THEN
#             LET g_success = 'N'
#             CALL cl_err(g_aag.aag01,'agl-973',1)
#             RETURN
#          END IF
#          SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
#            WHERE aba01 = abb01
#              AND aba00 = g_aag.aag00
#              AND abb03 = g_aag.aag01
#              AND aba20 = '0'
#              AND aba00=bookno
#              AND (aba19 ='N' OR (aba19 = 'Y' AND abapost = 'N'))   
#          IF g_cnt > 0 THEN
#             LET g_success = 'N'
#             CALL cl_err(g_aag.aag01,'agl-973',1) 
#             RETURN
#          END IF      
#      ELSE IF bookno = g_bookno2 THEN
#      	  LET g_cnt = 0
#          SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
#            WHERE npp00 = npq00
#              AND npp01 = npq01
#              AND npp011 = npq011
#              AND nppsys = npqsys
#              AND npptype = npqtype
#              AND npq03 = g_aag.aag01
#              AND nppglno IS NULL
#              AND npqtype = '1'
#          IF g_cnt > 0 THEN
#             LET g_success = 'N'
#             CALL cl_err(g_aag.aag01,'agl-973',1) 
#             RETURN
#          END IF
#          SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
#            WHERE aba01 = abb01
#              AND aba00 = g_aag.aag00
#              AND abb03 = g_aag.aag01
#              AND aba20 = '0'
#              AND aba00=g_bookno2         #No.TQC-B50067
#              AND (aba19 ='N' OR (aba19 = 'Y' AND abapost = 'N'))   
#          IF g_cnt > 0 THEN
#             LET g_success = 'N'
#             CALL cl_err(g_aag.aag01,'agl-973',1)
#             RETURN
#          END IF
#         END IF  
#        END IF               
#    ELSE  
#      CALL cl_err(g_plant,'aoo-081',1) #抓不到帳別
#    END IF	
#      
#END FUNCTION
#No.TQC-B60002  --Mark End

#函數說明:
#若采用科目編碼規範，則判斷用戶輸入的科目編碼是否符合科目規範
#判斷函數，有返回值，0-正確，1-錯誤
FUNCTION p209_chk_aag01(p_aag01)
DEFINE   p_aag01           LIKE aag_file.aag01
DEFINE   l_aaz107          LIKE aaz_file.aaz107
DEFINE   l_aaz108          LIKE aaz_file.aaz108 
DEFINE   l_aag01_length    LIKE type_file.num5   #編碼長度
DEFINE   l_length          LIKE type_file.num5   #其他段編碼長度
DEFINE   l_ret             LIKE type_file.chr1   #接收預設函數返回值
 
    #初始化各變量
     LET l_aaz107 = NULL
     LET l_aaz108 = NULL 
     LET l_aag01_length = 0
     LET l_length = 0    
     LET l_ret    = NULL 
       
     IF cl_null(p_aag01) THEN RETURN 0 END IF   #科目編號為空則返回0
 
    #找出科目編碼規範
     SELECT aaz107,aaz108 INTO l_aaz107,l_aaz108 FROM aaz_file WHERE aaz00 = '0'
     IF cl_null(l_aaz107) OR cl_null(l_aaz108) THEN  #沒有值，表示不采用編碼規範
        CALL cl_err('system message:','agl-241',0)
       #RETURN 0  #MOD-C70212 mark     
        RETURN 1  #MOD-C70212
     END IF 
     
     CALL LENGTH(p_aag01) RETURNING l_aag01_length
 
    #編碼長度小于首段長度
     IF l_aag01_length < l_aaz107 OR l_aag01_length = l_aaz107 THEN 
        CALL cl_err(p_aag01,'agl-240',1) 
        RETURN 1
     END IF 
    
    #編碼長度大于首段長度
     IF l_aag01_length > l_aaz107 THEN 
        LET l_length = l_aag01_length - l_aaz107
        IF (l_length mod l_aaz108) <> 0 THEN 
           CALL cl_err(p_aag01,'agl-240',1)
           RETURN 1
        END IF 
     END IF 
   
     
    #若編碼符合規範，則調用預設函數i102_def()
     CALL p209_def(p_aag01,l_aaz107,l_aaz108,l_aag01_length) RETURNING l_ret
     IF l_ret <> 'Y' THEN 
       RETURN 1 
     END IF 
     
     RETURN 0
 
END FUNCTION 

#函數說明：
#根據科目編碼，預設統制明細別aag07，所屬統制科目aag08 和科目層級aag24
#功能函數，無返回值
FUNCTION p209_def(p_aag01,p_aaz107,p_aaz108,p_length)
DEFINE   p_aag01          LIKE aag_file.aag01
DEFINE   p_aaz107         LIKE aaz_file.aaz107      #首段編碼長度定義值
DEFINE   p_aaz108         LIKE aaz_file.aaz108      #其他段編碼長度定義值
DEFINE   p_length         LIKE type_file.num5       #當前科目編碼總長度
DEFINE   l_length         LIKE type_file.num5       
DEFINE   l_success        LIKE type_file.chr1    
DEFINE   l_i              LIKE type_file.num5    
DEFINE   l_buff           STRING 
DEFINE   l_aag01          LIKE aag_file.aag01
DEFINE   l_count          LIKE type_file.num5
 
    #初始化各變量
     LET l_success = 'Y'
     LET l_aag01 = NULL 
     LET l_count = 0
      
   #若科目編碼字段長度大于首段編碼定義長度
    IF p_length > p_aaz107 THEN 
       LET l_length = p_length - p_aaz107    
       LET l_i = l_length / p_aaz108  
       LET l_buff  = p_aag01 
       LET l_aag01 = l_buff.substring(1,p_length-p_aaz108)
 
      #先確定帳套是否已經存在
      IF cl_null(bookno) THEN 
         CALL cl_err('','anm-062',0)
         LET l_success = 'N' 
         RETURN l_success 
      END IF 
      
      IF l_aag01 != old_no THEN
         CALL cl_err('','agl-245',0)
         LET l_success = 'N' 
         RETURN l_success 
      END IF
       
      SELECT * INTO g_aag.* FROM aag_file WHERE aag00 = bookno AND aag01 = old_no
      LET g_aag.aag01 = new_no
      LET g_aag.aag07 = '2'
      LET g_aag.aag08 = l_aag01
      LET g_aag.aag24 = 99
      LET g_aag.aagacti ='Y'                   #有效的資料
      LET g_aag.aaguser = g_user
      LET g_aag.aagoriu = g_user
      LET g_aag.aagorig = g_grup
      LET g_aag.aaggrup = g_grup               #使用者所屬群
      LET g_aag.aagdate = g_today
      LET g_aag.aagmodu = ''
   END IF 
     
   RETURN l_success 
 
END FUNCTION 
#No.FUN-B50149  --END
