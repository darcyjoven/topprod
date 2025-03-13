# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmp550.4gl
# Descriptions...: 融資平均月利率計算作業
# Date & Author..: 98/06/20 By David Hsu
# Modify.........: No.7354 03/10/28 By Kitty g_sum配合改為小數4位
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-750128 07/05/28 By Smapmin 修改g_success
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70004 10/07/12 By Summer 增加aza63判斷使用s_azmm
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    b_date,e_date   LIKE type_file.dat,          #No.FUN-680107 DATE
    yy              LIKE nmm_file.nmm01,
    mm              LIKE nmm_file.nmm02,
    g_sum           LIKE nmm_file.nmm03          #No:7354  #FUN-680107 DEC(15,4)
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_chr        LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE g_flag       LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE g_change_lang  LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #是否有做語言切換 No.FUN-570127
DEFINE g_bookno1    LIKE aza_file.aza81       #CHI-A70004 add
DEFINE g_bookno2    LIKE aza_file.aza82       #CHI-A70004 add

MAIN
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0082
   DEFINE l_flag    LIKE type_file.chr1          #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET yy   = ARG_VAL(1)
   LET mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570127 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570127 mark---
#   OPEN WINDOW p550_w AT p_row,p_col WITH FORM "anm/42f/anmp550"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('z')
#NO.FUN-570127 mark--
 
#NO.FUN-570127  start--
    #LET g_success = 'Y'   #MOD-750128
    WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p550_tm()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p550()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p550
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'   #MOD-750128
         BEGIN WORK
         CALL p550()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
 END WHILE
#->No.FUN-570127 ---end---
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
#   CALL p550()               #NO.FUN-570127 MARK
#   CLOSE WINDOW p550_w       #NO.FUN-570127 MARK
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION p550_tm()
  DEFINE   lc_cmd   LIKE type_file.chr1000 #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
  #->No.FUN-570127 --start--
  OPEN WINDOW p550 AT p_row,p_col WITH FORM "anm/42f/anmp550"
  ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
  #->No.FUN-570127 ---end---
 
    WHILE TRUE 
      CLEAR FORM
      LET g_bgjob = 'N'                             #NO.FUN-570127
      #INPUT yy,mm FROM nmm01,nmm02
      INPUT yy,mm,g_bgjob WITHOUT DEFAULTS FROM nmm01,nmm02,g_bgjob  #NO.FUN-570127
      
  
          AFTER FIELD nmm02
             IF NOT cl_null(mm) THEN 
                #CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date #CHI-A70004 mark
                #CHI-A70004 add --start--
                IF g_aza.aza63 = 'Y' THEN
                   CALL s_azmm(yy,mm,g_nmz.nmz02p,g_nmz.nmz02b) RETURNING g_chr,b_date,e_date
                ELSE
                   CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date
                END IF
                #CHI-A70004 add --end--
             END IF 
  
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
  
          ON ACTION CONTROLG
             CALL cl_cmdask()
  
          ON ACTION locale                    #genero
          #   LET g_action_choice = "locale"
          #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_change_lang = TRUE                   #no.FUN-570127 
             EXIT INPUT
    
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
          ON ACTION exit  #加離開功能genero
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
 
#NO.FUN-570127 start-- 
#       IF g_action_choice = "locale" THEN  #genero
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
    
#       IF INT_FLAG THEN
#          EXIT WHILE 
#       END IF
 
#       IF cl_sure(10,10) THEN
#
#          BEGIN WORK
#          LET g_success = 'Y'
#
#           SELECT nmm04/SUM(nmn07*nmn08)*100 INTO g_sum
#            FROM nmm_file,nmn_file
#           WHERE nmm01=nmn01
#             AND nmm02=nmn02
#             AND nmm01=yy
#              AND nmm02=mm
#           GROUP BY nmm04
#          LET g_sum=g_sum*DAY(e_date)
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('p550(ckp#1):',SQLCA.sqlcode,1) 
#              LET g_success = 'N' 
#             EXIT WHILE 
#          END IF
#
#           UPDATE nmm_file SET nmm03 =g_sum
#           WHERE nmm01 =yy
#             AND nmm02 =mm
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('p550(ckp#3):',SQLCA.sqlcode,1)
#              LET g_success = 'N'
#          END IF
#       END IF
#
#     END WHILE 
# 
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        EXIT WHILE 
#     END IF
#      IF g_success = 'Y' THEN 
#        COMMIT WORK
#        CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#     ELSE 
#        ROLLBACK WORK
#         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#     END IF
#
#     IF g_flag THEN
#        CONTINUE WHILE
#      ELSE
#        EXIT WHILE
#     END IF
#NO.FUN-570127 mark---
 
#NO.FUN-570127 start---------
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p550
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "anmp550"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('anmp550','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                    " '",yy CLIPPED,"'",
                    " '",mm CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('anmp550',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p550
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
    END IF
   EXIT WHILE
#NO.FUN-570127 end----------------
  END WHILE 
END FUNCTION
 
FUNCTION p550()
 
   #CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date #CHI-A70004 mark
   #CHI-A70004 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,mm,g_nmz.nmz02p,g_nmz.nmz02b) RETURNING g_chr,b_date,e_date
    ELSE
       CALL s_azm(yy,mm) RETURNING g_chr,b_date,e_date
    END IF
    #CHI-A70004 add --end--
    SELECT nmm04/SUM(nmn07*nmn08)*100 INTO g_sum
     FROM nmm_file,nmn_file
    WHERE nmm01=nmn01
      AND nmm02=nmn02
      AND nmm01=yy
       AND nmm02=mm
    GROUP BY nmm04
   LET g_sum=g_sum*DAY(e_date)
   IF SQLCA.sqlcode THEN
#     CALL cl_err('p550(ckp#1):',SQLCA.sqlcode,1)    #No.FUN-660148
      CALL cl_err3("sel","nmm_file,nmn_file","","",SQLCA.sqlcode,"","p550(ckp#1):",1) #No.FUN-660148
       LET g_success = 'N'    #MOD-750128 取消mark
#      EXIT WHILE 
      RETURN
   END IF
 
    UPDATE nmm_file SET nmm03 =g_sum
    WHERE nmm01 =yy
      AND nmm02 =mm
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p550(ckp#3):',SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("upd","nmm_file","","",SQLCA.sqlcode,"","p550(ckp#3):",1) #No.FUN-660148
       LET g_success = 'N'
   END IF
END FUNCTION
 
 
