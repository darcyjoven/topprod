# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afap620.4gl
# Descriptions...: 盤點過帳還原作業        
# Date & Author..: 03/09/23 By Sophia
# Modify.........: No.MOD-590305 05/09/16 By Dido 增加刪除 fap_file
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.MOD-660116 06/06/28 By Smapmin  不update faj17
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/05 By Rayven 確定運行’沒什麼作用，不管選
# Modify.........: No.FUN-710028 07/01/22 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720008 07/02/02 By Smapmin 增加開窗查詢條件
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A70015 10/07/02 By Dido 若此財編存在於別張盤點單且未過帳時則不可還原 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善" 追單
# Modify.........: No:MOD-D10025 13/01/04 By suncx 當人為原因導致已出售資產被盤點到時，過賬時不會生成fap_file資料，此時過賬還原則無fap_file資料刪除，所以應該拿掉SQLCA.sqlerrd[3] = 0的管控
 
DATABASE ds
 
GLOBALS "../../config/top.global" #CKP
DEFINE g_i LIKE type_file.num5    #CKP       #No.FUN-680070 SMALLINT
DEFINE g_cnt LIKE type_file.num5    #CKP       #No.FUN-680070 SMALLINT
 
DEFINE   g_fca		RECORD LIKE fca_file.*,
         g_faj		RECORD LIKE faj_file.*,
         tm             RECORD
          fca01         LIKE fca_file.fca01
#         a             LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1) #No.TQC-6C0009 mark
          END RECORD,
         g_fap          RECORD LIKE fap_file.*,
         g_tmp          LIKE type_file.num10,        #No.FUN-680070 INTEGER
         g_flag         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          g_wc,g_wc2,g_sql string  #No.FUN-580092 HCN
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0069
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.fca01  = ARG_VAL(1)
#  LET tm.a  = ARG_VAL(2)      #No.TQC-6C0009 mark
#  LET g_bgjob = ARG_VAL(3)    #背景作業 #No.TQC-6C0009 mark
   LET g_bgjob = ARG_VAL(2)    #背景作業 #No.TQC-6C0009
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
 
   #CKP
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
#NO.FUN-570144 mark---
#    LET p_row = 7 LET p_col = 29
# OPEN WINDOW p620_w AT p_row,p_col
#      #CKP
#      WITH FORM "afa/42f/afap620"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#   CALL cl_ui_init()
 
#    CALL p620_p1()
#    CLOSE WINDOW p620_w
#NO.FUN-570144 mark---
 
#NO.FUN-570144 START------
 LET g_success = 'Y'
 WHILE TRUE
   IF g_bgjob = "N" THEN
      CALL p620_p1()
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p620_p2()
         CALL s_showmsg()   #No.FUN-710028
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag
         END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p620_w
            EXIT WHILE
         END IF
     ELSE
         CONTINUE WHILE
     END IF
   ELSE
     BEGIN WORK
     LET g_success = 'Y'
     CALL p620_p2()
     CALL s_showmsg()   #No.FUN-710028
     IF g_success = "Y" THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     CALL cl_batch_bg_javamail(g_success)
     EXIT WHILE
   END IF
 END WHILE
#->No.FUN-570144 ---end---
 CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p620_p1()
  DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p620_w AT p_row,p_col WITH FORM "afa/42f/afap620"
    ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  #->No.FUN-570144 ---end---
 
#LET tm.a = 'N'    #No.TQC-6C0009 mark
 LET g_bgjob = 'N' #NO.FUN-570144 
 WHILE TRUE
       #INPUT BY NAME tm.fca01,tm.a WITHOUT DEFAULTS HELP 1
#      INPUT BY NAME tm.fca01,tm.a,g_bgjob  WITHOUT DEFAULTS HELP 1  #NO.FUN-570144 #No.TQC-6C0009 mark
       INPUT BY NAME tm.fca01,g_bgjob  WITHOUT DEFAULTS HELP 1  #No.TQC-6C0009
      
       AFTER FIELD fca01
         IF cl_null(tm.fca01) THEN 
            NEXT FIELD fca01
         ELSE
            SELECT COUNT(*) INTO g_cnt
              FROM fca_file
             WHERE fca01 = tm.fca01
               AND fca15 = 'Y'   #MOD-720008
            IF g_cnt = 0 THEN
               CALL cl_err(tm.fca01,'afa-032',0)
               NEXT FIELD fca01
            END IF
         END IF
 
#No.TQC-6C0009 --start-- mark
#      AFTER FIELD a
#        IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
#           NEXT FIELD a
#        END IF
#No.TQC-6C0009 --end--
 
         ON ACTION locale
            #CALL cl_dynamic_locale()
            #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE                   #NO.FUN-570144 
            EXIT INPUT
 
    ON ACTION  CONTROLP
       CASE
           WHEN INFIELD(fca01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_fca"
                LET g_qryparam.where = "fca15 = 'Y'"   #MOD-720008
                CALL cl_create_qry() RETURNING tm.fca01
#                CALL FGL_DIALOG_SETBUFFER( tm.fca01 )
                DISPLAY BY NAME tm.fca01
                NEXT FIELD fca01
       OTHERWISE EXIT CASE
       END CASE
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
#NO.FUN-570144 mark------
#   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
#   IF tm.a = 'Y' THEN
#      IF cl_sure(15,17) THEN
#         CALL p620_p2()
#      END IF
#   ELSE
#      EXIT PROGRAM
#   END IF
#NO.FUN-570144 mark--------
 
#NO.FUN-570144 start-------
   IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p620_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
 
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap620'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap620','9031',1) 
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.fca01 CLIPPED,"'",
#                    " '",tm.a CLIPPED,"'",   #No.TQC-6C0009 mark
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap620',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p620_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
 
  EXIT WHILE
END WHILE
#FUN-570144 ---end---
END FUNCTION
 
FUNCTION p620_p2()
   DEFINE  l_fcaqty     LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE  l_cnt        LIKE type_file.num5         #MOD-A70015
 
   BEGIN WORK
      LET g_success='Y'
      LET g_sql = "SELECT * FROM fca_file ",
                  " WHERE fca01 = '",tm.fca01,"' AND fca15='Y'"
      PREPARE p620_s1_pre1 FROM g_sql
      DECLARE p620_s1_c CURSOR FOR p620_s1_pre1
      CALL s_showmsg_init()    #No.FUN-710028
      #FUN-B50090 add begin-------------------------
      #重新抓取關帳日期
      SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
      #FUN-B50090 add -end--------------------------
      FOREACH p620_s1_c INTO g_fca.*
#        IF SQLCA.sqlcode  THEN CALL cl_err('',STATUS,1) END IF          #No.FUN-710028
#        IF SQLCA.sqlcode  THEN CALL s_errmsg('','','',STATUS,0) END IF  #No.FUN-710028 #No.FUN-8A0086
         IF SQLCA.sqlcode  THEN                                          #No.FUN-8A0086
            CALL s_errmsg('','','',STATUS,0)                             #No.FUN-8A0086
            LET g_success = 'N'                                          #No.FUN-8A0086
         END IF                                                          #No.FUN-8A0086
#No.FUN-710028 --begin                                                                                                              
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        
#No.FUN-710028 -end
 
         #-->盤點日期小於關帳日期
         IF g_fca.fca13 < g_faa.faa09 THEN 
#           CALL cl_err(g_fca.fca01,'aap-176',1)         #No.FUN-710028
            CALL s_errmsg('','',g_fca.fca01,'aap-176',1) #No.FUN-710028
            LET g_success = 'N'
#           EXIT FOREACH      #No.FUN-710028
            CONTINUE FOREACH  #No.FUN-710028
         END IF
         #-----No:FUN-B60140-----
         IF g_faa.faa31 = "Y" THEN
            #-->盤點日期小於關帳日期
            IF g_fca.fca13 < g_faa.faa092 THEN
               CALL s_errmsg('','',g_fca.fca01,'aap-176',1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF
         #-----No:FUN-B60140 END-----
        #-MOD-A70015-add-
         #-->此財編存在於別張盤點編號中且未過帳
         LET l_cnt = 0
         SELECT count(*) INTO l_cnt
           FROM fca_file
          WHERE fca03 = g_fca.fca03 AND fca01 <> g_fca.fca01 AND fca15 = 'N'  
         IF l_cnt > 0 THEN 
            CALL s_errmsg('','',g_fca.fca03,'afa-108',1) 
            LET g_success = 'N'
            CONTINUE FOREACH  
         END IF
        #-MOD-A70015-end-
         #-----MOD-660116---------
     UPDATE faj_file SET 
              faj19=g_fca.fca06,
              faj20=g_fca.fca05,faj21=g_fca.fca07
          WHERE faj02  = g_fca.fca03
            AND faj022 = g_fca.fca031
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("upd","faj_file",g_fca.fca03,g_fca.fca031,SQLCA.sqlcode,"","update faj_file:",1)   #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = g_fca.fca03,"/",g_fca.fca031  #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'update faj_file:',SQLCA.sqlcode,1)  #No.FUN-710028
            LET g_success = 'N'
#           EXIT FOREACH      #No.FUN-710028
            CONTINUE FOREACH  #No.FUN-710028
         END IF
         #-----END MOD-660116-----
         UPDATE fca_file SET fca15 = 'N' 
          WHERE fca01 = tm.fca01
            AND fca02 = g_fca.fca02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err('update fca_file:',SQLCA.sqlcode,1)   #No.FUN-660136
#           CALL cl_err3("upd","fca_file",tm.fca01,g_fca.fca02,SQLCA.sqlcode,"","update fca_file:",1)   #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = tm.fca01,"/",g_fca.fca02  #No.FUN-710028
            CALL s_errmsg('fca01,fca02',g_showmsg,'update fca_file:',SQLCA.sqlcode,1)  #No.FUN-710028
            LET g_success = 'N'
#           EXIT FOREACH      #No.FUN-710028
            CONTINUE FOREACH  #No.FUN-710028
          END IF
#MOD-590305
        SELECT faj17-faj58 INTO l_fcaqty
          FROM faj_file
         WHERE faj02  = g_fca.fca03
           AND faj022 = g_fca.fca031
        IF l_fcaqty != g_fca.fca09 OR g_fca.fca05 != g_fca.fca10 OR
           g_fca.fca06 != g_fca.fca11 OR g_fca.fca07 != g_fca.fca12 THEN
 
           DELETE FROM fap_file
            WHERE fap02 = g_fca.fca03 AND fap021 = g_fca.fca031
              AND fap03 = '2'
          #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN  #MOD-D10025 mark
           IF SQLCA.sqlcode THEN                          #MOD-D10025 add
#            CALL cl_err('delete fap_file:',SQLCA.sqlcode,1)   #No.FUN-660136
#            CALL cl_err3("del","fap_file",g_fca.fca03,g_fca.fca031,SQLCA.sqlcode,"","delete fap_file:",1)   #No.FUN-660136
             LET g_showmsg = g_fca.fca03,"/",g_fca.fca031,"/",'2'   #No.FUN-710028
             CALL s_errmsg('fap02,fap021,fap03',g_showmsg,'delete fap_file:',SQLCA.sqlcode,1)  #No.FUN-710028
             LET g_success = 'N'
#            EXIT FOREACH      #No.FUN-710028
             CONTINUE FOREACH  #No.FUN-710028
           END IF
        END IF
#MOD-590305 End
 
      END FOREACH
#No.FUN-710028 --begin                                                                                                              
      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          
#No.FUN-710028 --end
 
 
   IF g_success = 'Y'
   THEN CALL cl_cmmsg(1) COMMIT WORK
   ELSE CALL cl_rbmsg(1) ROLLBACK WORK
   END IF
END FUNCTION
