# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp202.4gl
# Descriptions...: 年底結轉作業 (整批資料處理作業)
# Modify.........: No.MOD-520008 05/02/14 By Kitty 現行年月不應該default aaa04-1
# Modify ........: No.FUN-570145 06/02/27 By yiting 批次背景
# Input parameter:
# Return code....:
# Modify.........: No.MOD-640539 06/04/21 By Carrier 大陸版年結時自動更新現行年月aaa04/aaa05的值
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
#
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-720046 07/02/27 By Smapmin 做完年結後,現行年度應+1
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-740287 07/04/23 By Smapmin 年結後更新現行年度與現行期別,不分地區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-AB0068 11/01/06 By Carrier 增加"次年科目变更"
# Modify.........: No:MOD-C30071 12/03/30 By Polly 增加年結控卡，目前為最後年月才能做年結
# Modify.........: No:MOD-D20020 13/02/04 By apo 在變更帳別後重取現行會計年度,改取azmm_file之會計期間

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     bookno            LIKE aaa_file.aaa01,      #No.FUN-740020
     close_y,close_m   LIKE type_file.num5,      #closing year & month  #No.FUN-680098     SMALLINT
     g_a               LIKE type_file.chr1,      #No.FUN-AB0068 
     g_aaa04           LIKE aaa_file.aaa04,      #現行會計年度          #No.FUN-680098     SMALLINT
     g_aaa05           LIKE aaa_file.aaa05,      #現行期別              #No.FUN-680098     SMALLLINT
     b_date            LIKE type_file.dat,       #期間起始日期          #No.FUN-680098     DATE
     e_date            LIKE type_file.dat,       #期間起始日期          #No.FUN-680098     DATE
     g_bookno          LIKE aea_file.aea00,      #帳別
     bno               LIKE type_file.chr6,      #起始傳票編號                      #No.FUN-680098  VARCHAR(6)
     eno               LIKE type_file.chr6       #截止傳票編號                      #No.FUN-680098  VARCHAR(6)
DEFINE ls_date         STRING,    #No.FUN-570145
      l_flag           LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
      g_change_lang    LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1)

MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    LET bookno = ARG_VAL(1)  #No.FUN-740020
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET close_y  = ARG_VAL(2)
   LET g_a      = ARG_VAL(3)    #No.FUN-AB0068                                  
   LET g_bgjob  = ARG_VAL(4)    #No.FUN-AB0068
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


    #No.FUN-740020  --Begin
    IF bookno IS NULL OR bookno = ' ' THEN
#      SELECT aaz64 INTO g_bookno FROM aaz_file
       LET bookno = g_aza.aza81
    END IF
    #No.FUN-740020  --End
  #-->No.FUN-570145 --start
   #CALL aglp202_tm(0,0)
   WHILE TRUE
    LET g_change_lang = FALSE
    IF g_bgjob = 'N' THEN
       CALL aglp202_tm(0,0)
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          LET g_success = 'Y'
          BEGIN WORK
          CALL p202_process()
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
          ELSE
             CALL cl_rbmsg(1)
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW aglp202_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       LET g_success = 'Y'
       BEGIN WORK
       CALL p202_process()
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
  END WHILE
#FUN-570145 end--------
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION aglp202_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5          #No.FUN-680098  SMALLINT
   #       l_flag         VARCHAR(1)                      #FUN-570145
   DEFINE  lc_cmd         LIKE type_file.chr1000       #FUN-570145    #No.FUN-680098      VARCHAR(500)


   CALL s_dsmark(bookno)  #No.FUN-740020

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW aglp202_w AT p_row,p_col WITH FORM "agl/42f/aglp202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

   CALL s_shwact(0,0,bookno)  #No.FUN-740020
   CALL cl_opmsg('q')
   WHILE TRUE
	  IF s_shut(0) THEN RETURN END IF
      CLEAR FORM
      LET bookno = g_aza.aza81  #No.FUN-740020
      DISPLAY BY NAME bookno    #No.FUN-740020
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file
             WHERE aaa01 = bookno  #No.FUN-740020
       LET close_y = g_aaa04  #-1         #No.MOD-520008
      LET close_m = g_aaa05
    #-- No.FUN-570145 --start---
     LET g_bgjob = 'N'
    #--FUN-570145--end---------

     #No.FUN-AB0068  --Begin                                                    
     LET g_a = 'N'                                                              
     DISPLAY g_a TO FORMONLY.g_a                                                
     #No.FUN-AB0068  --End 

     #INPUT close_y WITHOUT DEFAULTS FROM aaa04         #FUN-570145
     INPUT bookno,close_y,g_a,g_bgjob WITHOUT DEFAULTS FROM bookno,aaa04,g_a,g_bgjob  #No.FUN-740020  #No.FUN-AB0068
      #-->No.FUN-570145 --start--
       #ON ACTION locale
       #   CALL cl_dynamic_locale()
       #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #-->No.FUN-570145 --end----

      #No.FUN-740020  --Begin
      AFTER FIELD bookno
         IF NOT cl_null(bookno) THEN
           #MOD-D20020--
            SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file
             WHERE aaa01 = bookno        
            LET close_y = g_aaa04  
            LET close_m = g_aaa05
           #MOD-D20020--
            CALL p202_bookno(bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(bookno,g_errno,0)
               LET bookno = g_aza.aza81
               DISPLAY BY NAME bookno
               NEXT FIELD bookno
            END IF
         END IF
      #No.FUN-740020  --End


      AFTER FIELD aaa04
         IF close_y  IS NULL OR close_y = ' ' THEN
            NEXT FIELD aaa04
         END IF

      #No.FUN-740020  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bookno)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = bookno
               CALL cl_create_qry() RETURNING bookno
               DISPLAY BY NAME bookno
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

   #-->No.FUN-570145 --start--
      ON ACTION locale
#         CALL cl_show_fld_cont()
         LET g_change_lang = TRUE
         EXIT INPUT
   #-->No.FUN-570145 --end----


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
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF

  #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aglp202_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

#   IF cl_sure(21,21) THEN
#      CALL cl_wait()
#      #期末結轉(END OF MONTH)
#      LET g_success = 'Y'
#      BEGIN WORK
#      #no.4352避免有error -274訊息出現
#      #no.4352(end)
#-----------------------------年結
#      CALL s_eoy(g_bookno,close_y)       #年結
#      #no.4352
#      #no.4352(end)
#      IF g_success = 'N' THEN CALL cl_rbmsg(1) ROLLBACK WORK EXIT WHILE END IF
##----------------------------- commit work
#         IF g_success='Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#   END  IF
    IF g_bgjob = "Y" THEN
        LET lc_cmd = NULL
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aglp202"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('aglp202','9031',1)
        ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",close_y CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp202',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW aglp202_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
   END IF
   EXIT WHILE
   #-- No.FUN-570145 --end---
   ERROR ""
   END WHILE
#   CLOSE WINDOW aglp202_w
END FUNCTION

#No.FUN-740020  --Begin
FUNCTION p202_bookno(p_bookno)
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

#FUN-570145 -----start-----
FUNCTION p202_process()
  DEFINE l_azm02        LIKE azm_file.azm02  #MOD-C30071 add

#no.4352避免有error -274訊息出現
#no.4352(end)


  #-----------------------------年結
  #No.FUN-AB0068  --Begin                                                       
  #CALL s_eoy(bookno,close_y)       #年结  #No.FUN-740020                       
  IF cl_null(g_a) THEN LET g_a = 'N' END IF                
 #------------------------MOD-C30071--------------------------start
 #MOD-D20020--mark
 #SELECT azm02 INTO l_azm02 FROM azm_file
 # WHERE azm01=close_y
 #MOD-D20020--mark
 #MOD-D20020
  SELECT azmm02 INTO l_azm02 FROM azmm_file 
   WHERE azmm01=close_y AND azmm00=bookno
 #MOD-D20020

  IF ((l_azm02 = '1' AND close_m = 12) OR
      (l_azm02 = '2' AND close_m = 13)) THEN
      CALL s_eoy(bookno,close_y,g_a)                   #年结
  ELSE
    CALL cl_err('','agl-239',1)
    LET g_success = 'N'
    RETURN
  END IF
 #CALL s_eoy(bookno,close_y,g_a)   #年结  #No.FUN-740020
 #-----------------------MOD-C30071----------------------------end                     
  #No.FUN-AB0068  --End  
  #No.MOD-640539  --Begin
  #IF g_aza.aza26 = '2' THEN   #MOD-740287
     #UPDATE aaa_file SET aaa04 = close_y,aaa05 = 1 WHERE aaa01 = g_bookno   #TQC-720046
     UPDATE aaa_file SET aaa04 = close_y+1,aaa05 = 1 WHERE aaa01 = bookno   #TQC-720046  #No.FUN-740020
     IF SQLCA.sqlcode THEN
#       CALL cl_err('upd aaa04',SQLCA.sqlcode,1)   #No.FUN-660123
        CALL cl_err3("upd","aaa_file",bookno,"",SQLCA.sqlcode,"","upd aaa04",1)   #No.FUN-660123  #No.FUN-740020
        LET g_success = 'N'
     END IF
  #END IF   #MOD-740287
  #No.MOD-640539  --End
#no.4352
#no.4352(end)
  #----------------------------- commit work

END FUNCTION
#FUN-570145 ------end------

