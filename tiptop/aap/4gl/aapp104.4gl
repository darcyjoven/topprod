# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapp104.4gl
# Descriptions...: 帳款統計年結
# Date & Author..: 92/12/20 By Roger
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-710014 07/01/11 By cheunl錯誤訊息匯整
# Modify.........: No.MOD-740358 07/04/24 By Carrier 加入"科目變更"內容
# Modify.........: No.TQC-790090 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    yy              LIKE type_file.num10,       # No.FUN-690028 INTEGER
    g_a             LIKE type_file.chr1,        #No.MOD-740358 
    g_change_lang   LIKE type_file.chr1,        #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    g_apn           RECORD
                    apn08		LIKE apn_file.apn08,
                    apn09		LIKE apn_file.apn09,
                    apn00		LIKE apn_file.apn00,
                    apn01		LIKE apn_file.apn01,
                    apn02		LIKE apn_file.apn02,
                    apn04		LIKE apn_file.apn04,
## mod by mark 020326 
#                   apn03		LIKE apn_file.apn03,
                    apn10		LIKE apn_file.apn10,
## mod by mark 020326 
                    x1		        LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
                    x2		        LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
## end 
                    apn11		LIKE apn_file.apn11,
                    apn12		LIKE apn_file.apn12,
                    apn13		LIKE apn_file.apn13,
                    apn14		LIKE apn_file.apn14,
                    apn15		LIKE apn_file.apn15,
                    apn16		LIKE apn_file.apn16,
                    apn03		LIKE apn_file.apn03
                    END RECORD,
     g_wc,g_sql     string  #No.FUN-580092 HCN
 
MAIN
   DEFINE l_flag        LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET yy = ARG_VAL(1)                  #年度
   #No.MOD-740358  --Begin
   LET g_a      = ARG_VAL(2)
   LET g_bgjob  = ARG_VAL(3)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF cl_null(g_a) THEN
      LET g_a = "N"
   END IF
   #No.MOD-740358  --End  
#->No.FUN-570112 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
#NO.FUN-570112 START------\
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p104()
         IF cl_sure(0,0) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p104_process()
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
               CLOSE WINDOW p104_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p104_process()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p104()
   DEFINE lc_cmd        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(500)   #No.FUN-570112
 
WHILE TRUE
   LET g_action_choice = ""

   OPEN WINDOW p104_w WITH FORM "aap/42f/aapp104"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
   CLEAR FORM

   LET yy = YEAR(TODAY) - 1
   LET g_bgjob = "N"
 
  #INPUT BY NAME yy WITHOUT DEFAULTS     #No.FUN-570112
   INPUT BY NAME yy,g_a,g_bgjob WITHOUT DEFAULTS  #No.MOD-740358
 
      AFTER FIELD yy
         IF cl_null(yy) THEN 
            NEXT FIELD yy
         END IF
 
      #No.MOD-740358  --Begin
      AFTER FIELD g_a
         IF cl_null(g_a) OR g_a NOT MATCHES '[YN]' THEN
            NEXT FIELD g_a
         END IF
      #No.MOD-740358  --End  
 
      ON ACTION locale
        #->No.FUN-570112 --start--
        #LET g_action_choice='locale'
        #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE
        #->No.FUN-570112 ---end---
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
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
  #->No.FUN-570112 --start--
  #IF g_action_choice = 'locale' THEN
   IF g_change_lang THEN
      LET g_change_lang = FALSE
  #->No.FUN-570112 ---end---
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
#NO.FUN-570112 START---
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p104_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM


   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp104"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp104','9031',1)  
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",yy CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp104',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p104_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
  #->No.FUN-570112 ---end---
#NO.FUN-570112 MARK---
#   IF INT_FLAG THEN
#      RETURN 
#   END IF
#   IF cl_sure(0,0) THEN
#      LET g_success = 'Y'
#      BEGIN WORK
#      CALL p104_process()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#     END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
#NO.FUN-570112 MARK----------
END WHILE
END FUNCTION
 
FUNCTION p104_process()
   DEFINE  l_apn   RECORD LIKE apn_file.*       #No.MOD-740358
 
   LET g_sql =
       "SELECT apn08,apn09,apn00,apn01,apn02,apn04,apn10,",
       "       SUM(apn06),SUM(apn07)",
       "  FROM apn_file WHERE apn04 = ",yy,
       " GROUP BY apn08,apn09,apn00,apn01,apn02,apn04,apn10 "
   PREPARE p104_prepare FROM g_sql
   DECLARE p104_cs CURSOR WITH HOLD FOR p104_prepare
   SELECT DISTINCT 'N' FROM apn_file WITH(holdlock)
   IF STATUS THEN 
      CALL cl_err('Lock apn_file fail:',SQLCA.sqlcode,1)
      CLOSE WINDOW p104_w
      CALL cl_batch_bg_javamail("N")  #NO.FUN-570112
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM 
   END IF
   LET yy = yy + 1
   DELETE FROM apn_file WHERE apn04 = yy
   
   CALL s_showmsg_init()                   #No.FUN-710014
   FOREACH p104_cs INTO g_apn.*
      IF STATUS THEN
#No.FUN-710014 -------------- --Begin------------------
#        CALL cl_err('p104(ckp#1):',SQLCA.sqlcode,1)    
#        LET g_success = 'N'
         CALL s_errmsg('','','p104(ckp#1):',SQLCA.sqlcode,1)                                                                        
         LET g_success = 'N'               #No.FUN-8A0086
         LET g_totsuccess='N'                                                                                                       
         EXIT FOREACH
#No.FUN-710014 -------------- --End------------------
      END IF
      IF g_apn.x1 IS NULL THEN  
         LET g_apn.x1 = 0
      END IF
      IF g_apn.x2 IS NULL THEN 
         LET g_apn.x2 = 0
      END IF
#->No.FUN-570112 --start--
      IF g_bgjob = 'N' THEN
          MESSAGE "Insert apn:",g_apn.apn00,' ',g_apn.apn01,' ',g_apn.apn02,' ',yy
          CALL ui.Interface.refresh()
      END IF
#->No.FUN-570112 ---end---
 
      #No.MOD-740358  --Begin
      IF g_a = 'Y' THEN
         CALL s_tag(yy,g_apn.apn09,g_apn.apn00)
              RETURNING g_apn.apn09,g_apn.apn00
      END IF
      #No.MOD-740358  --End  
 
      INSERT INTO apn_file(apn00,apn01,apn02,apn03,apn04,apn05,
                           apn06,apn07,apn08,apn09,apn10,apn11,apn12,
                           #apn13,apn14,apn15,apn16) #FUN-980001 mark
                           apn13,apn14,apn15,apn16,apnlegal) #FUN-980001 add apnlegal
      VALUES(g_apn.apn00,g_apn.apn01,g_apn.apn02,g_apn.apn03,yy,
             0,g_apn.x1,g_apn.x2,g_apn.apn08,g_apn.apn09,g_apn.apn10,
             g_apn.apn11, g_apn.apn12, g_apn.apn13, g_apn.apn14, 
             #g_apn.apn15, g_apn.apn16) #FUN-980001 mark
             g_apn.apn15, g_apn.apn16,g_legal) #FUN-980001 add g_legal
      #No.MOD-740358  --Begin
      #多個科目對應同一科目時,INSERT會有重復問題
 
      #TQC-790090
#     IF STATUS THEN
#     IF SQLCA.sqlcode = '-239'  THEN
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
         SELECT * INTO l_apn.* FROM apn_file
          WHERE apn08 = g_apn.apn08
            AND apn09 = g_apn.apn09
            AND apn00 = g_apn.apn00
            AND apn01 = g_apn.apn01
            AND apn02 = g_apn.apn02
            AND apn04 = yy
            AND apn05 = 0
            AND apn10 = g_apn.apn10
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_apn.apn08,"/",g_apn.apn09,"/",g_apn.apn00,"/",
                            g_apn.apn01,"/",g_apn.apn02,"/",yy,"/0/",
                            g_apn.apn10
            CALL s_errmsg("apn08,apn09,apn00,apn01,apn02,apn04,apn05,apn10",g_showmsg,"select apn",SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         IF cl_null(l_apn.apn06)  THEN LET l_apn.apn06  = 0 END IF
         IF cl_null(l_apn.apn07)  THEN LET l_apn.apn07  = 0 END IF
         IF cl_null(g_apn.x1) THEN LET g_apn.x1 = 0 END IF
         IF cl_null(g_apn.x2) THEN LET g_apn.x2 = 0 END IF
         LET l_apn.apn06   = l_apn.apn06  + g_apn.x1
         LET l_apn.apn07   = l_apn.apn07  + g_apn.x2
         UPDATE apn_file SET apn06  = l_apn.apn06,
                             apn07  = l_apn.apn07
          WHERE apn08 = g_apn.apn08
            AND apn09 = g_apn.apn09
            AND apn00 = g_apn.apn00
            AND apn01 = g_apn.apn01
            AND apn02 = g_apn.apn02
            AND apn04 = yy
            AND apn05 = 0
            AND apn10 = g_apn.apn10
         IF SQLCA.sqlcode <> 0 THEN
            LET g_showmsg = g_apn.apn08,"/",g_apn.apn09,"/",g_apn.apn00,"/",
                            g_apn.apn01,"/",g_apn.apn02,"/",yy,"/0/",
                            g_apn.apn10
            CALL s_errmsg("apn08,apn09,apn00,apn01,apn02,apn04,apn05,apn10",g_showmsg,"update apn",SQLCA.sqlcode,1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      ELSE
         IF SQLCA.sqlcode <> 0 THEN
            #CALL cl_err('p104(ckp#4):',SQLCA.sqlcode,1)   #No.FUN-660122
            #No.FUN-710014 ----------------Begin------------------
            #CALL cl_err3("ins","apn_file",g_apn.apn00,g_apn.apn01,SQLCA.sqlcode,"","p104(ckp#4):",1) #No.FUN-660122
            #LET g_success = 'N'
            #EXIT FOREACH
            LET g_showmsg=g_apn.apn00,"/",g_apn.apn01,"/",g_apn.apn02,"/",g_apn.apn03,"/",yy,"/",                                                                    
                          0,"/",g_apn.x1,"/",g_apn.x2,"/",g_apn.apn08,"/",g_apn.apn09,"/",g_apn.apn10,"/",                                                               
                          g_apn.apn11,"/",g_apn.apn12,"/",g_apn.apn13,"/",g_apn.apn14,"/",                                                                    
                          g_apn.apn15,"/",g_apn.apn16
            CALL s_errmsg("apn00,apn01,apn02,apn03,apn04,apn05,apn06,apn07,apn08,apn09,apn10,apn11,apn12,apn13,apn14,apn15,apn16",
                           g_showmsg,"p104(ckp#4):",SQLCA.sqlcode,1)
            LET g_totsuccess = 'N'                                                                                                  
            CONTINUE FOREACH
         END IF
 #No.FUN-710014 -------------- --End------------------
      END IF
      #No.MOD-740358  --End  
   END FOREACH
   
 #No.FUN-710014  ------------Begin-----------                                                                                                          
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   CALL s_showmsg()                                                                                                                 
 #No.FUN-710014  -------------End--------------
 
END FUNCTION
