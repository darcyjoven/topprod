# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axcp072.4gl
# Descriptions...: 聯產品入庫資料產生作業
# Date & Author..: 06/02/09 By Sarah
# Modify.........: No.FUN-610080 06/02/09 By Sarah 新增"聯產品入庫資料產生作業"
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-740120 07/05/07 By Sarah PROMPT訊息沒照規範寫
# Modify.........: No.MOD-860081 08/06/10 By jamie ON IDLE問題
# Modify.........: No.FUN-8A0086 08/10/17 By lutingting完善錯誤匯總的修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業程式日誌
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
           yy  LIKE type_file.num5,           #No.FUN-680122SMALLINT,
           mm  LIKE type_file.num5            #No.FUN-680122SMALLINT,
          END RECORD
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   l_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_cka00         LIKE cka_file.cka00    #FUN-C80092
DEFINE   g_cka09         LIKE cka_file.cka09    #FUN-C80092
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   CALL p072_tm(0,0)			
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	

END MAIN
 
FUNCTION p072_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   LET p_row = 4 LET p_col = 38
 
   OPEN WINDOW p072_w AT p_row,p_col WITH FORM "axc/42f/axcp072"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN 
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy = g_ccz.ccz01
      LET tm.mm = g_ccz.ccz02
 
      INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS 
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy < 0 THEN
               NEXT FIELD yy
            END IF
         AFTER FIELD mm
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF
            IF tm.mm < 1 OR tm.mm > 12 THEN
               NEXT FIELD mm
            END IF
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.yy*12+tm.mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
               CALL cl_err('','axc-095',1) NEXT FIELD yy
            END IF
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
         ON ACTION locale #genero
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         
          LET INT_FLAG = 0
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
      END IF
      CALL axcp072()
      CALL s_showmsg()        #No.FUN-710027  
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      #CALL cl_end(0,0)
   END WHILE
 
   ERROR ""
   CLOSE WINDOW p072_w
END FUNCTION
 
FUNCTION axcp072()
 #DEFINE    l_time        LIKE type_file.chr8	    #No.FUN-6A0146
  DEFINE    l_cnt         LIKE type_file.num10,     #No.FUN-680122INTEGER,
            l_cjp         RECORD LIKE cjp_file.*,
            l_msg         STRING                    #TQC-740120 add
  DEFINE    l_bdate       LIKE type_file.dat        #CHI-9A0021 add
  DEFINE    l_edate       LIKE type_file.dat        #CHI-9A0021 add
  DEFINE    l_correct     LIKE type_file.chr1       #CHI-9A0021 add
 
  CALL cl_getmsg('axc-532',g_lang) RETURNING l_msg   #TQC-740120 add
  SELECT COUNT(*) INTO l_cnt FROM cjp_file WHERE cjp02=tm.yy AND cjp03=tm.mm 
  LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm                            #FUN-C80092 add
  CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
  IF l_cnt > 0 THEN
    CASE g_lang
      WHEN '0'
        LET INT_FLAG = 0  ######add for prompt bug
       #str TQC-740120 modify
       #PROMPT '資料已存在是否重新處理?(Y/N)' for g_chr
        PROMPT l_msg CLIPPED FOR g_chr
       #end TQC-740120 modify
       #MOD-860081------add-----str---
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
           
           ON ACTION about         
              CALL cl_about()      
           
           ON ACTION controlg      
              CALL cl_cmdask()     
           
           ON ACTION help          
              CALL cl_show_help()  
        END PROMPT
       #MOD-860081------add-----end---
 
      WHEN '2'
        LET INT_FLAG = 0  ######add for prompt bug
       #str TQC-740120 modify
       #PROMPT '資料已存在是否重新處理?(Y/N)' for g_chr
        PROMPT l_msg CLIPPED FOR g_chr
       #end TQC-740120 modify
       #MOD-860081------add-----str---
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
           
           ON ACTION about         
              CALL cl_about()      
           
           ON ACTION controlg      
              CALL cl_cmdask()     
           
           ON ACTION help          
              CALL cl_show_help()  
        END PROMPT
       #MOD-860081------add-----end---
 
      OTHERWISE
        LET INT_FLAG = 0  ######add for prompt bug
       #str TQC-740120 modify
       #PROMPT 'Data Existing,Re-Process?(Y/N)' for g_chr
        PROMPT l_msg CLIPPED FOR g_chr
       #end TQC-740120 modify
       #MOD-860081------add-----str---
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
           
           ON ACTION about         
              CALL cl_about()      
           
           ON ACTION controlg      
              CALL cl_cmdask()     
           
           ON ACTION help          
              CALL cl_show_help()  
        END PROMPT
       #MOD-860081------add-----end---
    END CASE
    IF g_chr NOT MATCHES '[Yy]' THEN RETURN END IF
  END IF
 
  BEGIN WORK
  LET g_success = 'Y'         #No.FUN-8A0086
  IF l_cnt > 0 THEN
    DELETE FROM cjp_file WHERE cjp02=tm.yy AND cjp03=tm.mm
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
#     CALL cl_err('del cjp_file:',STATUS,1)   #No.FUN-660127
      CALL cl_err3("del","cjp_file",tm.yy,tm.mm,STATUS,"","del cjp_file:",1)   #No.FUN-660127
      ROLLBACK WORK
      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
    END IF 
  END IF
  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
 #當月起始日與截止日
  CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
  INITIALIZE l_cjp.* TO NULL
  DECLARE p072_cur CURSOR FOR
   SELECT sfv11,0,0,sfv04,bmm04,bmm06
     FROM sfu_file, sfv_file, bmm_file
    WHERE sfu01=sfv01 AND sfupost='Y'
      AND sfv11=bmm01 AND sfv04=bmm03
     #AND YEAR(sfu02)=tm.yy AND MONTH(sfu02)=tm.mm  #CHI-9A0021
      AND sfu02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
  CALL s_showmsg_init()   #No.FUN-710027 
  FOREACH p072_cur INTO l_cjp.*
    IF sqlca.sqlcode THEN 
#       CALL cl_err('',STATUS,0)
        CALL s_errmsg('','','',STATUS,0)   #No.FUN-710027
        CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
        EXIT PROGRAM 
    END IF 
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
 
    LET l_cjp.cjp02 =tm.yy
    LET l_cjp.cjp03 =tm.mm
    MESSAGE l_cjp.cjp01
    CALL ui.Interface.refresh()
    INSERT INTO cjp_file VALUES(l_cjp.*)
    IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
#     CALL cl_err('ins cjp_file:',STATUS,1)   #No.FUN-660127
#      CALL cl_err3("ins","cjp_file",l_cjp.cjp01,l_cjp.cjp02,STATUS,"","ins cjp_file:",1)   #No.FUN-660127  #No.FUN-710027
      LET g_showmsg=l_cjp.cjp01,"/",l_cjp.cjp02                                                                     #No.FUN-710027
      CALL s_errmsg('cjp01,cjp02',g_showmsg,'ins cjp_file',STATUS,1)                                        #No.FUN-710027
      ROLLBACK WORK
      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
      CALL cl_end2(2) RETURNING l_flag  #批次作業失敗 
#      EXIT PROGRAM             #No.FUN-710027
      CONTINUE FOREACH          #No.FUN-710027
    END IF 
  END FOREACH
 
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
  COMMIT WORK
  CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
  CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
END FUNCTION
#FUN-B80056
