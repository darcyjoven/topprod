# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp300.4gl
# Descriptions...: 每月投入工時統計作業
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/30 By Roger
# Modify.........: No:8950 03/12/19 Ching 若參數設為人工/製費取自系統, 時, 人工/製費無法自動產生
#                                         因CALL p300_DLOH() 段應放在 call p300() 之後
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570246 05/07/27 By Elva 用月份抓每日工時改成用期別抓
# Modify.........: No.TQC-5B0215 05/12/09 By kim START REPORT的檔名寫固定的，會製成權限不足，請改用變動檔名
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740120 07/05/07 By Sarah PROMPT訊息沒照規範寫
# Modify.........: No.MOD-7B0235 07/11/29 By Pengu 當畫面出現"資料已存在是否重新計算"若選擇否但程式還是會計算
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.MOD-840594 08/07/08 By Pengu 不應擷取未確認的工時
# Modify.........: No.MOD-980042 09/08/06 By mike 請在CALL p300()前先LET g_chr='Y'   
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy              LIKE type_file.num5,           #No.FUN-680122 SMALLINT,
        mm             LIKE type_file.num5            #No.FUN-680122 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_flag   LIKE type_file.chr1                 #No.FUN-680122 VARCHAR(1)
DEFINE   g_bdate  LIKE type_file.dat                  #No.FUN-680122 DATE   #FUN-570246
DEFINE   g_edate  LIKE type_file.dat                  #No.FUN-680122 DATE   #FUN-570246
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570153        #No.FUN-680122 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),              #是否有做語言切換 No.FUN-570153
       ls_date         STRING                  #->No.FUN-570153
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_cka00     LIKE cka_file.cka00          #FUN-C80092 add
DEFINE g_cka09     LIKE cka_file.cka09          #FUN-C80092 add

MAIN
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6A0146
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET yy = ARG_VAL(1)                      
   LET mm = ARG_VAL(2)                      
   LET g_bgjob = ARG_VAL(3)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
#NO.FUN-570153 mark--
#   OPEN WINDOW p300_w AT p_row,p_col WITH FORM "axc/42f/axcp300" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('q')
#   LET yy=g_ccz.ccz01 LET mm=g_ccz.ccz02 DISPLAY BY NAME yy,mm
#   WHILE TRUE 
#      ERROR ''
#      LET g_flag = 'Y'
#      CALL p300_ask()
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#     END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF cl_sure(0,0) THEN 
#         BEGIN WORK
#         LET g_success='Y'
#         CALL cl_wait()
#       #No:8950
#         CALL p300()
#         IF g_ccz.ccz10 = '2' THEN
#            CALL p300_DLOH()
#         END IF
#       ##
#         CALL p300_chk()
#      END IF
#      ERROR ''
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF g_success='Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#      END IF
#      IF g_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END WHILE
#   CLOSE WINDOW p300_w
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start---
  LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N" THEN
         CALL p300_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            #FUN-C80092--add--str--
            LET g_cka09 = " yy='",yy,"'; mm='",mm,"'; g_bgjob='",g_bgjob,"'"
            CALL s_log_ins(g_prog,yy,mm,'',g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end--
            BEGIN WORK
            LET g_success = 'Y'
            CALL cl_wait()
          #No:8950
            LET g_chr = 'Y' #MOD-980042   
            CALL p300()
            IF g_chr = 'Y' THEN      #No.MOD-7B0235 add
               IF g_ccz.ccz10 = '2' THEN
                  CALL p300_DLOH()
               END IF
               CALL p300_chk()
            END IF                   #No.MOD-7B0235 add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE  
               CLOSE WINDOW p300_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p300_w
      ELSE
         #FUN-C80092--add--str--
         LET g_cka09 = " yy='",yy,"'; mm='",mm,"'; g_bgjob='",g_bgjob,"'"
         CALL s_log_ins(g_prog,yy,mm,'',g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--
         BEGIN WORK
         LET g_success = 'Y'
         LET g_chr = 'Y' #MOD-980042   
         CALL p300()
         IF g_chr = 'Y' THEN      #No.MOD-7B0235 add
            IF g_ccz.ccz10 = '2' THEN
               CALL p300_DLOH()
            END IF
            CALL p300_chk()
         END IF                    #No.MOD-7B0235 add
 
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#  CALL cl_used('axcp300',g_time,2) RETURNING g_time   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#->No.FUN-570153 ---end---
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p300_ask()
   DEFINE   c   LIKE cre_file.cre08            #No.FUN-680122 VARCHAR(10)
   DEFINE lc_cmd        LIKE type_file.chr1000        #No.FUN-680122  VARCHAR(500)           #No.FUN-570153
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
#->No.FUN-570153 ---start---
   LET p_row = 0 LET p_col = 0 
   OPEN WINDOW p300_w AT p_row,p_col WITH FORM "axc/42f/axcp300" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('q')
   LET yy=g_ccz.ccz01 LET mm=g_ccz.ccz02 DISPLAY BY NAME yy,mm
   LET g_bgjob='N' 
#->No.FUN-570153 ---end---
 
   #INPUT BY NAME yy,mm WITHOUT DEFAULTS 
   INPUT BY NAME yy,mm,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570153
      AFTER FIELD yy
         IF cl_null(yy) OR yy = 0 THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF mm > 12 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF mm > 13 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#         IF cl_null(mm) OR mm = 0 OR mm < 1 OR mm > 13 THEN #FUN-570246
#            NEXT FIELD mm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(mm)  THEN
            NEXT FIELD yy
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
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
      ON ACTION locale                    #genero
#NO.FUN-570153 mark
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570153 mark
         LET g_change_lang = TRUE        #NO.FUN-570153
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
#NO.FUN-570153 start--
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp300"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp300','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",yy CLIPPED ,"'",
                      " '",mm CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp300',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#->No.FUN-570153 ---end---   
END FUNCTION
 
FUNCTION p300()
   DEFINE l_dept LIKE cck_file.cck_w           #No.FUN-680122 VARCHAR(10) 
   DEFINE l_tot	 LIKE cck_file.cck05           #No.FUN-680122 DEC(15,3)
   DEFINE cck	 RECORD LIKE cck_file.*
   DEFINE l_flag LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE l_sql  LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
   DEFINE l_n    LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
 
  ##1999/09/13 modify
   LET l_flag = 'N'
   SELECT COUNT(*) INTO g_cnt FROM cck_file
    WHERE cck01 = yy AND cck02 = mm
   IF g_cnt>0 THEN
      LET INT_FLAG = 0  ######add for prompt bug
      CALL cl_conf(6,6,'axc-192') RETURNING l_n
      CASE WHEN l_n=1
               LET g_chr='Y'
           WHEN l_n=0 
               LET g_chr='N'
      END CASE
      IF g_chr='Y' OR g_chr='y' THEN
         DELETE FROM cck_file WHERE cck01=yy AND cck02=mm
      ELSE
        #----------No.MOD-7B0235 modify
        #LET l_flag='Y'
         LET g_success = 'N'
         RETURN
        #----------No.MOD-7B0235 end
      END IF
   END IF
  ##-------------------
   #FUN-570246 --begin
   CALL s_azn01(yy,mm) RETURNING g_bdate,g_edate
   IF g_ccz.ccz06 = '1' THEN 
      LET l_sql = " SELECT '',SUM(ccj05) ",           #不區分成本中心
                  "  FROM cci_file,ccj_file ",
                # " WHERE YEAR(cci01) = '",yy,"'", 
                # "   AND MONTH(cci01)= '",mm,"'",
                  " WHERE cci01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  "   AND ccifirm = 'Y' ",                 #No.MOD-840594 add
                  "   AND cci01=ccj01 AND cci02 = ccj02 "
 
   ELSE 
      LET l_sql = " SELECT ccj02,SUM(ccj05) ",     #區分成本中心
                  "  FROM cci_file,ccj_file ",
               #  " WHERE YEAR(cci01) = '",yy,"'", 
               #  "   AND MONTH(cci01)= '",mm,"'",
                  " WHERE cci01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  "   AND ccifirm = 'Y' ",                 #No.MOD-840594 add
                  "   AND cci01=ccj01 AND cci02 = ccj02 ",
                  "  GROUP BY ccj02 "
   #FUN-570246 --end
 
   END IF 
 
   PREPARE p300_pre_c2 FROM l_sql
   IF SQLCA.sqlcode  THEN
      CALL cl_err('pre p300_pre_c2',STATUS,1)
   END IF
   DECLARE p300_c2  CURSOR FOR p300_pre_c2
   IF SQLCA.sqlcode  THEN
      CALL cl_err('declare p300_c2',STATUS,1)
   END IF
   CALL s_showmsg_init()   #No.FUN-710027   
   FOREACH p300_c2 INTO l_dept,l_tot
      IF STATUS THEN 
         LET g_success='N'
#         CALL cl_err('foreach',STATUS,1)            #No.FUN-710027
         CALL s_errmsg('','','foreach',STATUS,1)     #No.FUN-710027
         EXIT FOREACH 
      END IF
 
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
      IF l_tot IS NULL THEN LET l_tot=0 END IF
      SELECT * INTO cck.* FROM cck_file
         #   WHERE cck01=yy AND cck02=mm AND cck_w=x1 AND cck_l=x2
             WHERE cck01=yy AND cck02=mm AND cck_w=l_dept   #no.5929
      IF STATUS AND l_flag = 'N' THEN
         IF cl_null(l_dept) THEN LET l_dept = ' ' END IF
         LET cck.cck01=yy
         LET cck.cck02=mm
         LET cck.cck_w=l_dept
         LET cck.cck_l=''
         LET cck.cck03=0    LET cck.cck04=0  LET cck.cck05=l_tot  
         LET cck.cck06=0    LET cck.cck07=0
         LET cck.cckdate=g_today
         LET cck.cckuser=g_user
         LET cck.cckgrup=g_grup
         LET cck.cckoriu = g_user      #No.FUN-980030 10/01/04
         LET cck.cckorig = g_grup      #No.FUN-980030 10/01/04
         LET cck.ccklegal = g_legal    #No.FUN-A50075 
         INSERT INTO cck_file VALUES(cck.*)
         IF STATUS THEN 
#           CALL cl_err('ins cck05:',STATUS,1)    #No.FUN-660127
#No.FUN-710027--begin 
#            CALL cl_err3("ins","cck_file",cck.cck01,cck.cck02,STATUS,"","ins cck05:",1)   #No.FUN-660127
           LET g_showmsg = cck.cck01,"/",cck.cck02
            CALL s_errmsg('cck01,cck02',g_showmsg,'ins cck05:',STATUS,1)
            LET g_success='N'
#            RETURN 
           CONTINUE FOREACH
#No.FUN-710027--end
         END IF
      END IF
      LET cck.cck05=l_tot
      IF l_tot>0 
         THEN LET cck.cck06=cck.cck03/l_tot
              LET cck.cck07=cck.cck04/l_tot
         ELSE LET cck.cck06=0
              LET cck.cck07=0
      END IF
      UPDATE cck_file SET cck05 = cck.cck05,
                          cck06 = cck.cck06,
                          cck07 = cck.cck07
       WHERE cck01=yy AND cck02=mm AND cck_w=l_dept 
      IF STATUS THEN 
#        CALL cl_err('upd cck05:',STATUS,1)    #No.FUN-660127
#No.FUN-710027--begin 
#         CALL cl_err3("upd","cck_file",yy,mm,STATUS,"","upd cck05:",1)   #No.FUN-660127
          LET g_showmsg = yy,"/",mm
          CALL s_errmsg('cck01,cck02',g_showmsg,'upd cck05:',STATUS,1)
            LET g_success='N'
#            RETURN 
           CONTINUE FOREACH
#No.FUN-710027--end
      END IF
   END FOREACH
#No.FUN-710027--begin 
   IF g_totsuccess="N" THEN
        LET g_success="N"
    END IF 
#No.FUN-710027--end
 
END FUNCTION
   
FUNCTION p300_chk()
   DEFINE l_ccj		RECORD LIKE ccj_file.*
   DEFINE l_sfb01	LIKE sfb_file.sfb01         #No.FUN-550025
   DEFINE l_sfb38	LIKE type_file.dat,         #No.FUN-680122 DATE
          l_msg         STRING                      #TQC-740120 add
 
   DECLARE chk_c CURSOR FOR
         SELECT ccj_file.*, sfb01,sfb38
           FROM cci_file,ccj_file LEFT OUTER JOIN sfb_file ON ccj04=sfb_file.sfb01
       #  WHERE YEAR(cci01)=yy AND MONTH(cci01)=mm   #FUN-570246
          WHERE cci01 BETWEEN g_bdate AND g_edate   #FUN-570246
            AND cci01=ccj01 AND cci02=ccj02
            AND ccifirm = 'Y'           #No.MOD-840594 add
 
   FOREACH chk_c INTO l_ccj.*,l_sfb01,l_sfb38
      IF SQLCA.sqlcode THEN 
#        CALL cl_err('chk_c',SQLCA.sqlcode,0)          #No.FUN-710027
         CALL s_errmsg('','','chk_c',SQLCA.sqlcode,0)  #No.FUN-710027
         LET g_success='N'
         EXIT FOREACH
      END IF
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
 
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
          MESSAGE "WO:",l_ccj.ccj04
          CALL ui.Interface.refresh()
      END IF
      LET INT_FLAG = 0  ######add for prompt bug
      IF l_sfb01 IS NULL THEN 
          IF g_bgjob = 'N' THEN  #NO.FUN-570153 
             #str TQC-740120 modify
             #PROMPT " 工單錯誤:" FOR CHAR g_chr 
              CALL cl_getmsg('axc-533',g_lang) RETURNING l_msg   
              PROMPT l_msg CLIPPED FOR CHAR g_chr
             #end TQC-740120 modify
             #MOD-860081---add---str---
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
              ON ACTION about                    
                 CALL cl_about()                 
   
              ON ACTION help                     
                 CALL cl_show_help()             
 
              ON ACTION controlg                 
                 CALL cl_cmdask()                
              END PROMPT
             #MOD-860081---add---end---
 
              IF YEAR(l_sfb38)*12+MONTH(l_sfb38) < yy*12+mm THEN
                  LET INT_FLAG = 0  ######add for prompt bug
                 #str TQC-740120 modify
                 #PROMPT " 此工單上期已結案 : " FOR CHAR g_chr
                  CALL cl_getmsg('axc-534',g_lang) RETURNING l_msg   
                  PROMPT l_msg CLIPPED FOR CHAR g_chr
                 #end TQC-740120 modify
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                    #CONTINUE PROMPT
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
   
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
 
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
          
                  END PROMPT
              END IF
         END IF
         UPDATE ccj_file SET ccj08='工單已結案'
           WHERE ccj01=l_ccj.ccj01
             AND ccj02=l_ccj.ccj02
             AND ccj03=l_ccj.ccj03
         IF STATUS THEN 
#           CALL cl_err('upd ccj08:',STATUS,1)    #No.FUN-660127
#No.FUN-710027--begin 
#            CALL cl_err3("upd","ccj_file",l_ccj.ccj01,l_ccj.ccj02,STATUS,"","upd ccj08:",1)   #No.FUN-660127
            LET g_showmsg = l_ccj.ccj01,"/",l_ccj.ccj02
            CALL s_errmsg('ccj02,ccj02',g_showmsg,'upd ccj08',STATUS,1)
            LET g_success='N'
#            RETURN 
            CONTINUE FOREACH
#No.FUN-710027--end
         END IF
      END IF
   END FOREACH
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
END FUNCTION
 
FUNCTION p300_DLOH()
DEFINE l_cck03 LIKE cck_file.cck03
DEFINE l_cck04 LIKE cck_file.cck04
DEFINE l_cmi   RECORD LIKE cmi_file.*
DEFINE cck RECORD LIKE cck_file.*
DEFINE l_name  LIKE type_file.chr20          #No.FUN-680122 VARCHAR(20) #TQC-5B0215
 
LET l_cck03 = 0 LET l_cck04 = 0
   IF g_ccz.ccz06 = '1' THEN #不分成本中心
      SELECT SUM(cmi08) INTO l_cck03  FROM cmi_file
       WHERE cmi01 = yy and cmi02 = mm AND cmi04 = '1'
      IF l_cck03 IS NULL THEN LET l_cck03 = 0 END IF
      SELECT SUM(cmi08) INTO l_cck04  FROM cmi_file
       WHERE cmi01 = yy and cmi02 = mm AND cmi04 = '2'
      IF l_cck04 IS NULL THEN LET l_cck04 = 0 END IF
      SELECT * INTO cck.* FROM cck_file
       WHERE cck01 = yy AND cck02 = mm AND cck_w = ' '
      LET cck.cck03 = l_cck03 LET cck.cck04 = l_cck04
      IF cck.cck05 >0
         THEN LET cck.cck06=cck.cck03/cck.cck05
              LET cck.cck07=cck.cck04/cck.cck05
         ELSE LET cck.cck06=0
              LET cck.cck07=0
      END IF
        UPDATE cck_file SET cck03=cck.cck03,
                            cck04=cck.cck04,
                            cck06=cck.cck06,
                            cck07=cck.cck07
       WHERE cck01=yy AND cck02=mm AND cck_w=' '
      IF STATUS THEN 
#        CALL cl_err('upd cck:',STATUS,1)    #No.FUN-660127
#         CALL cl_err3("upd","cck_file",yy,mm,STATUS,"","upd cck:",1)   #No.FUN-660127   #No.FUN-710027
         LET g_showmsg = yy,"/",mm                                                       #No.FUN-710027
         CALL s_errmsg('cck01,cck02',g_showmsg,'upd cck:',STATUS,1)                      #No.FUN-710027
         LET g_success='N'
         RETURN 
      END IF
   ELSE
      DECLARE cmi_curs CURSOR FOR
       SELECT cmi04,cmi03,SUM(cmi08) FROM cmi_file
        WHERE cmi01 = yy and cmi02 = mm
        GROUP BY cmi04,cmi03
      #TQC-5B0215...............begin
      CALL cl_outnam('axcp300') RETURNING l_name
     #START REPORT p300_rep TO 'xx'
      START REPORT p300_rep TO l_name
      #TQC-5B0215...............end
      FOREACH cmi_curs INTO l_cmi.cmi04,l_cmi.cmi03,l_cmi.cmi08
         OUTPUT TO REPORT p300_rep(l_cmi.*)
      END FOREACH
      FINISH REPORT p300_rep
   END IF
END FUNCTION
 
REPORT p300_rep(l_cmi)
 DEFINE l_cmi RECORD LIKE cmi_file.*
 DEFINE l_cck03 LIKE cck_file.cck03
    DEFINE l_cck04 LIKE cck_file.cck04
    DEFINE cck RECORD LIKE cck_file.*
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
    ORDER BY l_cmi.cmi03,l_cmi.cmi04
 
    FORMAT
      BEFORE GROUP OF l_cmi.cmi03
          LET l_cck03 = 0
          LET l_cck04 = 0
      ON EVERY ROW
          IF l_cmi.cmi04 = '1' THEN
             LET l_cck03 = l_cck03 +l_cmi.cmi08
          ELSE
             LET l_cck04 = l_cck04 +l_cmi.cmi08
          END IF
 
      AFTER GROUP OF l_cmi.cmi03
         SELECT * INTO cck.* FROM cck_file
          WHERE cck01 = yy AND cck02 = mm AND cck_w = l_cmi.cmi03
         LET cck.cck03 = l_cck03 LET cck.cck04 = l_cck04
         IF cck.cck05 >0
            THEN LET cck.cck06=cck.cck03/cck.cck05
                 LET cck.cck07=cck.cck04/cck.cck05
            ELSE LET cck.cck06=0
                 LET cck.cck07=0
         END IF
        UPDATE cck_file SET cck03=cck.cck03,
                            cck04=cck.cck04,
                            cck06=cck.cck06,
                            cck07=cck.cck07
          WHERE cck01=yy AND cck02=mm AND cck_w=l_cmi.cmi03
         IF STATUS THEN 
#           CALL cl_err('upd cck:',STATUS,1)    #No.FUN-660127
            CALL cl_err3("upd","cck_file",yy,mm,STATUS,"","upd cck:",1)   #No.FUN-660127
            LET g_success='N'
            RETURN 
         END IF
END REPORT
 
