# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp102.4gl
# Descriptions...: 帳款統計年結
# Date & Author..: 92/12/20 By Roger
# Modify ........: No.A091 03/08/13 By Kammy 補充 No.A074 未修改到的部份
# Modify ........: No.9108 04/07/06 By Kammy Insert apm_file未依幣別 insert
# Modify ........: No.MOD-510141 05/03/04 By Kitty Insert apm_file加apm10
# Modify ........: No.MOD-530052 05/03/08 By Kitty g_sql錯誤更正
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行時間
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-6A0117 06/11/15 By Claire 加入期別
# Modify.........: No.FUN-710014 07/01/11 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-740358 07/04/24 By Carrier 加入"科目變更"內容
# Modify.........: No.TQC-790090 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0188 09/11/23 By jan 修改sql語句寫法
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    yy              LIKE type_file.num10,       # No.FUN-690028 INTEGER
    g_a             LIKE type_file.chr1,        #No.MOD-740358 
    g_change_lang   LIKE type_file.chr1,        #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    g_apm           RECORD
                    apm08		LIKE apm_file.apm08,
                    apm09		LIKE apm_file.apm09,
                    apm00		LIKE apm_file.apm00,
                    apm01		LIKE apm_file.apm01,
                    apm02		LIKE apm_file.apm02,
                    apm03		LIKE apm_file.apm03,
                    apm11               LIKE apm_file.apm11,  #No.A091 add
                    apm04		LIKE apm_file.apm04,
                    apm06               LIKE apm_file.apm06,
                    apm07               LIKE apm_file.apm07,
                    apm06f              LIKE apm_file.apm06f, #No.A091 add
                    apm07f              LIKE apm_file.apm07f  #No.A091 add
                    END RECORD,
     g_wc,g_sql      string,  #No.FUN-580092 HCN
     l_flag          LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT
 
MAIN
   DEFINE l_time  	LIKE type_file.chr8    #No.FUN-690028 VARCHAR(8)
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
#NO.FUN-570112 MARK-----
#   OPEN WINDOW p102_w AT p_row,p_col WITH FORM "aap/42f/aapp102"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
#   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
#   LET yy = YEAR(TODAY) - 1
#   CALL p102()
#   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#NO.FUN-570112 MARK-----
#NO.FUN-570112 START---------------
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p102()
         IF cl_sure(0,0) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p102_process()
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
               CLOSE WINDOW p102_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p102_process()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570112 END--------------
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   #IF INT_FLAG THEN LET INT_FLAG = 0 END IF  NO.FUN-570112 MARK
END MAIN
 
FUNCTION p102()
  #DEFINE   l_flag    LIKE type_file.num5        #No.FUN-570112  #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(500)   #No.FUN-570112
   DEFINE   p_row,p_col   LIKE type_file.num5      #No.FUN-570112  #No.FUN-690028 SMALLINT
 
 
   LET g_action_choice = ""
#->No.FUN-570112 --start--
   OPEN WINDOW p102_w AT p_row,p_col WITH FORM "aap/42f/aapp102"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
#->No.FUN-570112 ---end---
 
   CLEAR FORM
#->No.FUN-570112 --start--
   LET yy = YEAR(TODAY) - 1
   LET g_bgjob = "N"
#->No.FUN-570112 ---end---
 
WHILE TRUE  
 
   #INPUT BY NAME yy WITHOUT DEFAULTS    NO.FUN-570112 MARK
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
 
#NO.FUN-570122 START---------
#   IF INT_FLAG THEN 
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p102_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp102"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp102','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " ",yy CLIPPED,
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp102',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p102_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
#   IF cl_sure(0,0) THEN 
#      LET g_success = 'Y'
#      BEGIN WORK
#      CALL p102_process()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#     IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
#NO.FUN-570112 END--------------------
END WHILE
END FUNCTION
 
FUNCTION p102_process()
   DEFINE  l_apm   RECORD LIKE apm_file.*       #No.MOD-740358
   LET g_sql =
        "SELECT apm08,apm09,apm00,apm01,apm02,apm03,apm11,apm04,",         #No.MOD-530052
        "       SUM(apm06),SUM(apm07),",   #No.MOD-530052
       "       SUM(apm06f),SUM(apm07f)",  #No.A091 add
       "  FROM apm_file WHERE apm04 = ",yy,
       " GROUP BY apm08,apm09,apm00,apm01,apm02,apm03,apm11,apm04"
   PREPARE p102_prepare FROM g_sql
   DECLARE p102_cs CURSOR WITH HOLD FOR p102_prepare
  #SELECT DISTINCT 'N' FROM apm_file WITH(holdlock) #TQC-9B0188
   SET LOCK MODE TO NOT WAIT                        #TQC-9B0188
   LOCK TABLE apm_file IN SHARE MODE                #TQC-9B0188
   IF STATUS THEN 
      CALL cl_err('Lock apm_file fail:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CLOSE WINDOW p102_w
      CALL cl_batch_bg_javamail("N")  #NO.FUN-570112
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
      EXIT PROGRAM 
   END IF
   LET yy = yy + 1
   DELETE FROM apm_file WHERE apm04 = yy
      AND apm05=0  #MOD-6A0117 add
 
   CALL s_showmsg_init()   #No.FUN-710014
   FOREACH p102_cs INTO g_apm.*
      IF STATUS THEN
#No.FUN-710014  --Begin
#        CALL cl_err('p102(ckp#1):',SQLCA.sqlcode,1)   
#        LET g_success = 'N'
         CALL s_errmsg('','','p102(ckp#1):',SQLCA.sqlcode,1)
         LET g_success = 'N'                #No.FUN-8A0086
         LET g_totsuccess='N'
#No.FUN-710014  --End
         EXIT FOREACH
      END IF
#->No.FUN-570112 --start--
      IF g_bgjob = 'N' THEN
         MESSAGE "Insert apm:",g_apm.apm00,' ',g_apm.apm01,' ',g_apm.apm02,' ',yy
         CALL ui.Interface.refresh()
      END IF
#->No.FUN-570112 ---end---
 
      #No.MOD-740358  --Begin
      IF g_a = 'Y' THEN
         CALL s_tag(yy,g_apm.apm09,g_apm.apm00)
              RETURNING g_apm.apm09,g_apm.apm00
      END IF
      #No.MOD-740358  --End  
 
      INSERT INTO apm_file(apm00,apm01,apm02,apm03,apm04,apm05,
                         apm06,apm07,
                         apm06f,apm07f,        #No.A091 add
                         # apm08,apm09,apm10,apm11)    #No.9108   #No.MOD-510141 #FUN-980001 mark 
                          apm08,apm09,apm10,apm11,apmlegal)    #No.9108   #No.MOD-510141  #FUN-980001 add apmlegal
      VALUES(g_apm.apm00 ,g_apm.apm01,g_apm.apm02,g_apm.apm03,yy,0,
                    g_apm.apm06 ,g_apm.apm07,
                    g_apm.apm06f,g_apm.apm07f,       #No.A091 add
                     #g_apm.apm08 ,g_apm.apm09,'1',g_apm.apm11)  #No.9108   #No:BUG-510141 MOD-530052 #FUN-980001 mark
                     g_apm.apm08 ,g_apm.apm09,'1',g_apm.apm11,g_legal)  #No.9108   #No:BUG-510141 MOD-530052  ##FUN-980001 add g_legal
      #No.MOD-740358  --Begin
      #多個科目對應同一科目時,INSERT會有重復問題
 
      #TQC-790090
#     IF STATUS THEN
#     IF SQLCA.sqlcode = '-239'  THEN
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
         SELECT * INTO l_apm.* FROM apm_file
          WHERE apm08 = g_apm.apm08
            AND apm09 = g_apm.apm09
            AND apm00 = g_apm.apm00
            AND apm10 = '1'
            AND apm01 = g_apm.apm01
            AND apm02 = g_apm.apm02
            AND apm03 = g_apm.apm03
            AND apm11 = g_apm.apm11
            AND apm04 = g_apm.apm04
            AND apm05 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_apm.apm08,"/",g_apm.apm09,"/",g_apm.apm00,"/1/",
                            g_apm.apm01,"/",g_apm.apm02,"/",g_apm.apm03,"/",
                            g_apm.apm11,"/",g_apm.apm04,"/0"
            CALL s_errmsg("apm08,apm09,apm00,apm10,apm01,apm02,apm03,apm11,apm04,apm05",g_showmsg,"select apm",SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         IF cl_null(l_apm.apm06f) THEN LET l_apm.apm06f = 0 END IF
         IF cl_null(l_apm.apm07f) THEN LET l_apm.apm07f = 0 END IF
         IF cl_null(l_apm.apm06)  THEN LET l_apm.apm06  = 0 END IF
         IF cl_null(l_apm.apm07)  THEN LET l_apm.apm07  = 0 END IF
         IF cl_null(g_apm.apm06f) THEN LET g_apm.apm06f = 0 END IF
         IF cl_null(g_apm.apm07f) THEN LET g_apm.apm07f = 0 END IF
         IF cl_null(g_apm.apm06)  THEN LET g_apm.apm06  = 0 END IF
         IF cl_null(g_apm.apm07)  THEN LET g_apm.apm07  = 0 END IF
         LET l_apm.apm06f  = l_apm.apm06f + g_apm.apm06f
         LET l_apm.apm07f  = l_apm.apm07f + g_apm.apm07f
         LET l_apm.apm06   = l_apm.apm06  + g_apm.apm06
         LET l_apm.apm07   = l_apm.apm07  + g_apm.apm07
#        IF l_apm.apm06f - l_apm.apm07f > 0 THEN 
#           LET l_apm.apm06f = l_apm.apm06f -l_apm.apm07f LET g_apm.apm07f=0
#        ELSE 
#           LET l_apm.apm07f = l_apm.apm07f -l_apm.apm06f LET g_apm.apm06f=0
#        END IF
#        IF l_apm.apm06 - l_apm.apm07 > 0 THEN 
#           LET l_apm.apm06 = l_apm.apm06 -l_apm.apm07 LET g_apm.apm07=0
#        ELSE 
#           LET l_apm.apm07 = l_apm.apm07 -l_apm.apm06 LET g_apm.apm06=0
#        END IF
         UPDATE apm_file SET apm06f = l_apm.apm06f,
                             apm07f = l_apm.apm07f,
                             apm06  = l_apm.apm06,
                             apm07  = l_apm.apm07
          WHERE apm08 = g_apm.apm08
            AND apm09 = g_apm.apm09
            AND apm00 = g_apm.apm00
            #AND apm10 = g_apm.apm10 #FUN-980001 mark
            AND apm10 = '1'          #FUN-980001 add
            AND apm01 = g_apm.apm01
            AND apm02 = g_apm.apm02
            AND apm03 = g_apm.apm03
            AND apm11 = g_apm.apm11
            AND apm04 = g_apm.apm04
            #AND apm05 = g_apm.apm05 #FUN-980001 mark
            AND apm05 = 0            #FUN-980001 add
         IF SQLCA.sqlcode <> 0 THEN
            LET g_showmsg = g_apm.apm08,"/",g_apm.apm09,"/",g_apm.apm00,"/1/",
                            g_apm.apm01,"/",g_apm.apm02,"/",g_apm.apm03,"/",
                            g_apm.apm11,"/",g_apm.apm04,"/0"
            CALL s_errmsg("apm08,apm09,apm00,apm10,apm01,apm02,apm03,apm11,apm04,apm05",g_showmsg,"update apm",SQLCA.sqlcode,1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      ELSE
         IF SQLCA.sqlcode <> 0 THEN
            #CALL cl_err('p102(ckp#4):',SQLCA.sqlcode,1)    #No.FUN-660122
            #No.FUN-710014  --Begin
            #CALL cl_err3("ins","apm_file","","",SQLCA.sqlcode,"","",1) #No.FUN-660122
            #LET g_success = 'N'
            #EXIT FOREACH
            LET g_showmsg=g_apm.apm00,"/",g_apm.apm01,"/",                                                                          
                          g_apm.apm03,"/",                                                                         
                          yy,"/",0,"/",g_apm.apm06,"/",                                                                            
                          g_apm.apm07,"/","1","/",g_apm.apm08,"/",g_apm.apm09,"/","1","/",g_apm.apm11                                                                        
            CALL s_errmsg("apm00,apm01,apm02,apm03,apm04,apm05,apm06,apm07,apm08,apm09,apm10,apm11",                                            
                          g_showmsg,"p102(ckp#4):",SQLCA.sqlcode,1)                                                                 
            LET g_totsuccess = 'N'                                                                                                  
            CONTINUE FOREACH                                                                                                        
            #No.FUN-710014  --End    
         END IF
      END IF
      #No.MOD-740358  --End  
   END FOREACH
#No.FUN-710014  --Begin                                                                                                          
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
   CALL s_showmsg()                                                                                                                 
#No.FUN-710014  --End
 
END FUNCTION
