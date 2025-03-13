# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axcp631.4gl
# Descriptions...: 一般BOM複製成標準BOM作業
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/30 By Roger
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE newv			        LIKE cco_file.cco01            #No.FUN-680122 VARCHAR(4)
DEFINE eff_date   			LIKE type_file.dat             #No.FUN-680122 DATE
DEFINE bno,eno				LIKE type_file.chr20           #No.FUN-680122 VARCHAR(20)
DEFINE notot,no_ok			LIKE type_file.num10           #No.FUN-680122 INTEGER 
DEFINE bma	RECORD LIKE bma_file.*
DEFINE bmb	RECORD LIKE bmb_file.*
DEFINE ccm	RECORD LIKE ccm_file.*
DEFINE ccn	RECORD LIKE ccn_file.*
DEFINE g_flag   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0146
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   OPEN WINDOW p631_w AT 4,14 WITH FORM "axc/42f/axcp631" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   WHILE TRUE 
      LET g_flag = 'Y'
      CALL p631_ask()
      IF g_flag = 'N' THEN
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      SELECT COUNT(*) INTO notot FROM bma_file WHERE bma01 BETWEEN bno AND eno
      DISPLAY BY NAME notot
      IF cl_sure(20,20) THEN
         CALL cl_wait()
         BEGIN WORK
         LET g_success='Y'
         CALL p631()
         CALL s_showmsg()        #No.FUN-710027  
      END IF
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING g_flag#批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
 
      ERROR ''
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
   END WHILE
#  CALL cl_end(0,0) 
   CLOSE WINDOW p631_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p631_ask()
   DEFINE   c         LIKE cre_file.cre08           #No.FUN-680122 VARCHAR(10) 
   DEFINE   l_cco02   LIKE type_file.chr20          #No.FUN-680122 VARCHAR(20)
 
 
   LET eff_date=TODAY
 
   INPUT BY NAME bno,eno,eff_date, newv WITHOUT DEFAULTS 
 
      AFTER FIELD bno
         IF cl_null(bno) THEN 
            NEXT FIELD bno
         END IF
 
      AFTER FIELD eno
         IF cl_null(eno) THEN 
            NEXT FIELD eno
         END IF
 
      AFTER FIELD eff_date
         IF cl_null(eff_date) THEN
            NEXT FIELD eff_date
         END IF
 
      AFTER FIELD newv
         IF cl_null(newv) THEN
            NEXT FIELD newv
         END IF
         SELECT cco02 INTO l_cco02 FROM cco_file WHERE cco01=newv
         IF STATUS THEN
#           CALL cl_err('sel cco',STATUS,0)     #No.FUN-660127
            CALL cl_err3("sel","cco_file",newv,"",STATUS,"","sel cco",0)   #No.FUN-660127
            NEXT FIELD newv
         END IF
         DISPLAY l_cco02 TO cco02_2
 
      AFTER INPUT 
         IF INT_FLAG THEN
            RETURN
         END IF
         IF cl_null(newv) THEN 
            NEXT FIELD newv
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION locale#genero
         LET g_action_choice = "locale"
         EXIT INPUT
 
   END INPUT
   IF g_action_choice = "locale" THEN  #genero
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      LET g_flag = 'N'
      RETURN
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
END FUNCTION
 
FUNCTION p631()
   DECLARE p631_c1 CURSOR WITH HOLD FOR
       SELECT * FROM bma_file WHERE bma01 BETWEEN bno AND eno
   LET no_ok=0
   CALL s_showmsg_init()   #No.FUN-710027 
   FOREACH p631_c1 INTO bma.*
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
      LET no_ok=no_ok+1
      DISPLAY BY NAME no_ok DISPLAY bma.bma01 TO p2
      #BEGIN WORK 
      #LET g_success='Y'
      CALL p631_2()
      #IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   END FOREACH
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
END FUNCTION
 
FUNCTION p631_2()
   LET ccm.ccm01=bma.bma01
   LET ccm.ccm02=newv
   LET ccm.ccm03=0
   LET ccm.ccmuser=g_user
   LET ccm.ccmgrup=g_grup
   LET ccm.ccmoriu = g_user      #No.FUN-980030 10/01/04
   LET ccm.ccmorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccm_file VALUES(ccm.*)
   IF STATUS THEN LET g_success='N'
#   CALL cl_err('ins ccm',STATUS,1)    #No.FUN-660127
#    CALL cl_err3("ins","ccm_file",ccm.ccm01,ccm.ccm02,STATUS,"","ins ccm",1)   #No.FUN-660127  #No.FUN-710027
     LET g_showmsg = ccm.ccm01,"/",ccm.ccm02                                                        #No.FUN-710027
     CALL s_errmsg('ccm01,ccm02',g_showmsg,'ims ccm',STATUS,1)                                  #No.FUN-710027
   RETURN END IF
   DECLARE p631_c2 CURSOR FOR
    SELECT bmb03,SUM(bmb06/bmb07) FROM bmb_file
      WHERE bmb01=bma.bma01
        AND (bmb04 <=eff_date OR bmb04 IS NULL)
        AND (bmb05 > eff_date OR bmb05 IS NULL)
      GROUP BY bmb03
      ORDER BY 1
   LET ccn.ccn03=0
   FOREACH p631_c2 INTO bmb.bmb03, bmb.bmb06
      LET ccn.ccn01=ccm.ccm01
      LET ccn.ccn02=ccm.ccm02
      LET ccn.ccn03=ccn.ccn03+1
      LET ccn.ccn04=bmb.bmb03
      LET ccn.ccn05=bmb.bmb06
      LET ccn.ccn06=0
      INSERT INTO ccn_file VALUES(ccn.*)
      IF STATUS THEN
         MESSAGE ccn.ccn03
         CALL ui.Interface.refresh()
          LET g_success='N' 
#           CALL cl_err('ins ccn',STATUS,1)   #No.FUN-660127
#            CALL cl_err3("ins","ccn_file",ccn.ccn01,ccn.ccn02,STATUS,"","ins ccn",1)   #No.FUN-660127  #No.FUN-710027
            LET  g_showmsg=ccn.ccn01,"/",ccn.ccn02                                                      #No.FUN-710027
            CALL s_errmsg('ccn01,ccn02',g_showmsg,'ins ccn',STATUS,1)                                   #No.FUN-710027
            RETURN 
      END IF
   END FOREACH
END FUNCTION
