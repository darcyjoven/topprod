# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: anmp600.4gl
# Descriptions...: 關帳作業 
# Date & Author..: 02/09/27 By Kammy
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-930164 09/04/15 By jamie update nmz10成功時，寫入azo_file
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:MOD-D40132 13/04/18 By SunLM  關帳日期不可小於等於主帳別總賬關帳日期

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm        RECORD
               aaa04  LIKE aaa_file.aaa04,
               aaa05  LIKE aaa_file.aaa05,
               nmz10  LIKE nmz_file.nmz10 
               END RECORD,
        g_aaa04        LIKE aaa_file.aaa04,    #No.FUN-680107 SMALLINT #現行會計年度
        g_aaa05        LIKE aaa_file.aaa05,    #No.FUN-680107 SMALLINT #現行期別
        g_nmz10        LIKE nmz_file.nmz10,    #No.FUN-680107 DATE     #現行關帳年度
        g_change_lang  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)  #是否有做語言切換 No.FUN-570127
DEFINE  p_row,p_col  LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE  g_flag       LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE  g_msg           LIKE type_file.chr1000 #FUN-930164 add
DEFINE  g_flag_10       LIKE type_file.chr1    #FUN-930164 add
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8       #No.FUN-6A0082
    DEFINE l_flag   LIKE type_file.chr1     #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
    DEFINE ls_date  STRING                  #No.FUN-570126
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
 
   #->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date = ARG_VAL(1)
   LET tm.nmz10 = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob = ARG_VAL(2)    #背景作業
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
#   LET p_row = 5
#   LET p_col = 28
 
#   OPEN WINDOW anmp600_w AT p_row,p_col WITH FORM "anm/42f/anmp600" 
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('z')
#NO.FUN-570127 mark--
 
#NO.FUN-570127 start-----------
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET g_success = 'Y'
   WHILE TRUE
     IF g_bgjob = "N" THEN
        CALL anmp600_tm()
        IF cl_sure(18,20) THEN
           BEGIN WORK
           UPDATE nmz_file SET nmz10 = tm.nmz10
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('upd_nmz_file',SQLCA.sqlcode,0)   #No.FUN-660148
              CALL cl_err3("upd","nmz_file",tm.nmz10,"",SQLCA.sqlcode,"","upd_nmz_file",0) #No.FUN-660148
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
           ELSE
              COMMIT WORK
             #FUN-930164---add---str---
              IF g_flag_10='Y' THEN 
                 LET g_errno = TIME
                 LET g_msg = 'old:',g_nmz.nmz10,' new:',tm.nmz10
                 INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)          #FUN-980005 add plant & legal 
                    VALUES ('anmp600',g_user,g_today,g_errno,'nmz10',g_msg,g_plant,g_legal)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","azo_file","anmp600","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    RETURN
                 END IF
              END IF 
              LET g_nmz.nmz10 = tm.nmz10
             #FUN-930164---add---end---
              CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
           END IF
           IF g_flag
           THEN CONTINUE WHILE
           ELSE
                CLOSE WINDOW p600
                EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        BEGIN WORK
          UPDATE nmz_file SET nmz10 = tm.nmz10
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             ROLLBACK WORK
          ELSE
             COMMIT WORK
             #FUN-930164---add---str---
              IF g_flag_10='Y' THEN 
                 LET g_errno = TIME
                 LET g_msg = 'old:',g_nmz.nmz10,' new:',tm.nmz10
                 INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)          #FUN-980005 add plant & legal 
                    VALUES ('anmp600',g_user,g_today,g_errno,'nmz10',g_msg,g_plant,g_legal)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","azo_file","anmp600","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    RETURN
                 END IF
              END IF 
             #FUN-930164---add---end---
          END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
#->No.FUN-570127 ---end---
#   CALL anmp600_tm()                     #NO.FUN-570127 MARK
#   CLOSE WINDOW anmp600_w                #NO.FUN-570127 MARK 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION anmp600_tm()
   DEFINE   p_row,p_col   LIKE type_file.num5,   #No.FUN-680107 SMALLINT
   	    l_str         LIKE cob_file.cob08,   #No.FUN-680107 VARCHAR(30)
            l_flag        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE   lc_cmd        LIKE type_file.chr1000 #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
   DEFINE l_aaa07   LIKE aaa_file.aaa07                 #MOD-D40132 add
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
#NO.FUN-570127 start--
   LET p_row = 5
   LET p_col = 28
 
   OPEN WINDOW anmp600_w AT p_row,p_col WITH FORM "anm/42f/anmp600" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
#NO.FUN-570127 end--
 
   WHILE TRUE
       INITIALIZE tm.* TO NULL			# Defaealt condition
       SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file WHERE aaa01 = g_nmz.nmz02b
       LET tm.aaa04 = g_aaa04
       LET tm.aaa05 = g_aaa05
       LET tm.nmz10 = g_nmz.nmz10
       LET g_bgjob = 'N' #NO.FUN-570127
 
       CLEAR FORM 
       ERROR ""
       DISPLAY BY NAME tm.aaa04,tm.aaa05 
       #INPUT BY NAME tm.nmz10 WITHOUT DEFAULTS 
       INPUT BY NAME tm.nmz10,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570127
    
          AFTER FIELD nmz10
             IF cl_null(tm.nmz10) THEN 
                NEXT FIELD nmz10 
             END IF
            #FUN-930164---add---str---
             IF tm.nmz10 <> g_nmz.nmz10  THEN 
                LET g_flag_10='Y'
             END IF
            #FUN-930164---add---end---
            #MOD-D40132 add beg-----
            SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01= g_aza.aza81
            IF tm.nmz10 <=l_aaa07 THEN 
               CALL cl_err(l_aaa07,'asm-994',1)
               NEXT FIELD nmz10
            END IF     
            #MOD-D40132 add end-----      
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG
             CALL cl_cmdask()
    
          ON ACTION locale                    #genero
             #LET g_action_choice = "locale"
             #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_change_lang = TRUE                   #NO.FUN-570127
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
             LET g_flag_10='N'       #FUN-930164 add
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
 
        IF g_change_lang THEN
            LET g_change_lang = FALSE
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CONTINUE WHILE
        END IF
#NO.FUN-570127 mark---------
    
       IF INT_FLAG THEN
          LET INT_FLAG = 0 
          CLOSE WINDOW p600         #NO.FUN-570127
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM              #NO.FUN-570127
#          EXIT WHILE 
       END IF
       
#NO.FUN-570127 mark-------
#       IF cl_sure(10,10) THEN
#          CALL cl_wait()
#
#          BEGIN WORK
#
#          UPDATE nmz_file SET nmz10 = tm.nmz10
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#             CALL cl_err('upd_nmz_file',SQLCA.sqlcode,0)
#             ROLLBACK WORK
#             CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#          ELSE
#             COMMIT WORK
#             CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#          END IF 
#
#          IF g_flag THEN
#             CONTINUE WHILE
#          ELSE
#             EXIT WHILE
#          END IF
#       END IF
#NO.FUN-570127 mark-----------
 
#NO.FUN-570127 start------------
       IF g_bgjob = "Y" THEN
          SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "anmp600"
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('anmp600','9031',1)   
          ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm.nmz10 CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('anmp600',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p600
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
     END IF
     EXIT WHILE
#->No.FUN-570127 ---end-----------
   END WHILE
 
END FUNCTION
