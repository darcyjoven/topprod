# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp703.4gl
# Descriptions...: 生產報工工時轉成會每日工時作業
# Date & Author..: 06/07/14 By Sarah
# Modify.........: No.FUN-660153 06/07/14 By Sarah 新增"生產報工工時轉成會每日工時作業"
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-840464 08/04/21 By Sarah ccj_file增加了ccj071,應給予DEFAULT值0
# Modify.........: No.FUN-840181 08/06/12 By Sherry 增加實際機時
# Modify.........: No.CHI-860018 08/08/04 By sherry 考慮axcp700,axcp703同時執行
# Modify.........: No.FUN-910076 09/02/02 By jan 擷取機時資料
# Modify.........: No.MOD-940108 09/04/08 By Dido 增加檢核成本結算年月
# Modify.........: No.MOD-940368 09/05/21 By Pengu 再刪除cci_file時資料未正確的刪除，造成INSERT 時會出現-239異常
# Modify.........: No.FUN-980069 09/08/21 By mike 將年度欄位default ccz01月份欄位default ccz02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-950008 10/02/23 By vealxu 新增自動確認checkbox欄位
# Modify.........: No:MOD-A20084 10/02/23 By Sarah 修正CHI-9A0021
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:MOD-AC0056 10/12/08 By sabrina 將g_cnt與l_cnt變數改為LIKE type_file.num10 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60050 11/07/17 By Pengu 參數設定人工製費只依年月區分，則cci02應為一個空白
# Modify.........: No:FUN-C50019 12/06/15 By bart 背景執行
# Modify.........: No.FUN-C80092 12/12/05 By lixh1 增加寫入日誌功能
# Modify.........: No:CHI-C80041 13/01/03 By bart 作廢判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          yy LIKE type_file.num5,          #No.FUN-680122 SMALLINT,
          mm LIKE type_file.num5           #No.FUN-680122 SMALLINT
         ,check LIKE type_file.chr1        #No.FUN-950008 VARCHAR(1) 
          END RECORD
DEFINE g_row,g_col   LIKE type_file.num5   #No.FUN-680122 SMALLINT
DEFINE g_cnt         LIKE type_file.num10   #CHI-860018    #MOD-AC0056 num5 modify num10
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
DEFINE g_ccifirm     LIKE type_file.chr1    #No.FUN-950008 VARCHAR(1) 
DEFINE g_cka00       LIKE cka_file.cka00    #FUN-C80092
DEFINE l_msg1        STRING                 #FUN-C80092
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
   #FUN-C50019---begin
   INITIALIZE g_bgjob_msgfile TO NULL  
   LET tm.yy   = ARG_VAL(1)  
   LET tm.mm   = ARG_VAL(2)  
   LET g_bgjob = ARG_VAL(3)  
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF  
   #FUN-C50019---end
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   
   IF g_bgjob = 'N' THEN   #FUN-C50019
      LET g_row = 4 LET g_col = 38
 
      OPEN WINDOW p703_w AT g_row,g_col WITH FORM "axc/42f/axcp703"  
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
      CALL cl_ui_init()
      CALL p703_tm(0,0)
   #FUN-C50019---begin
   ELSE
      CALL axcp703()
   END IF 
   #FUN-C50019---end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p703_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000       #FUN-C50019

   CALL cl_opmsg('z')
 
   WHILE TRUE
      MESSAGE ""
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy = g_ccz.ccz01 #FUN-980069 YEAR (TODAY)-->g_ccz.ccz01
      LET tm.mm = g_ccz.ccz02 #FUN-980069 MONTH(TODAY)-->g_ccz.ccz02
      LET tm.check = 'N'      #FUN-950008 add       
      LET g_ccifirm = 'N'     #FUN-950008 add
      LET g_bgjob = 'N'       #FUN-C50019
 
      INPUT BY NAME tm.yy,tm.mm,tm.check,g_bgjob WITHOUT DEFAULTS   #FUN-950008 add check #FUN-C50019 ,g_bgjob

 
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

         #No.FUN-950008  ---start---
         AFTER FIELD check
            IF tm.check = 'Y' THEN
               LET g_ccifirm = 'Y'
            END IF 
         #No.FUN-950008  ---end--- 

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
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()          #No.FUN-550037 hmf
            EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF  
 
           IF tm.yy*12+tm.mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
              CALL cl_err('','axc-095',1)
              NEXT FIELD yy
           END IF
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      #FUN-C50019---begin
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 ='axcp703'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axcp703','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp703',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p703_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      #FUN-C50019---end
      IF cl_sure(21,21) THEN   #genero
   #FUN-C80092 -------------Begin---------------
         LET l_msg1 = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";",
                     "tm.check = '",tm.check,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg1)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         LET g_success='Y'
         CALL axcp703()
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
         IF g_flag THEN
             CALL p703_tm(0,0)
         ELSE
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
            EXIT PROGRAM
         END IF
 
      END IF
   END WHILE
 
   ERROR ""
   CLOSE WINDOW p703_w
END FUNCTION
 
FUNCTION axcp703()
    DEFINE l_eca03       LIKE eca_file.eca03,    # 工作站所屬部門別
           l_sql		LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(500),
           l_msg         STRING,                 #FUN-640165 add
           l_cci01       LIKE cci_file.cci01,        #No.MOD-940368 add
           l_cci02       LIKE cci_file.cci02,        #No.MOD-940368 add
           srf           RECORD LIKE srf_file.*,
           srg           RECORD LIKE srg_file.*,
           cci           RECORD LIKE cci_file.*,
           ccj           RECORD LIKE ccj_file.* 
    DEFINE l_cnt         LIKE type_file.num10    #FUN-910076   #MOD-AC0056 num5 modify num10
    DEFINE l_bdate       LIKE type_file.dat      #CHI-9A0021 add
    DEFINE l_edate       LIKE type_file.dat      #CHI-9A0021 add
    DEFINE l_correct     LIKE type_file.chr1     #CHI-9A0021 add
 
 
 
   #當月起始日與截止日
    CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt  FROM ccj_file
     WHERE ccj01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
       AND ccj04 IN (SELECT sfb01 FROM sfb_file
                      WHERE sfb93='N'
                    )
   IF l_cnt > 0 THEN 
     IF  cl_confirm('axc-525') THEN 
     DELETE FROM ccj_file 
     WHERE ccj01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
       AND ccj04 IN (SELECT sfb01 FROM sfb_file
                      WHERE sfb93='N'
                    )
     IF SQLCA.sqlcode THEN 
        IF g_bgjob = 'N' THEN  #FUN-C50019
           ERROR "DELETE FROM ccj_file ERROR:",SQLCA.sqlcode 
        END IF #FUN-C50019
        LET g_success='N'
     END IF
 
     LET l_sql = " SELECT cci01,cci02 FROM cci_file ",
                 "    WHERE cci01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                 "      AND ccifirm <> 'X' "   #CHI-C80041
     PREPARE p703_cci_p1 FROM l_sql
     DECLARE p703_cci_c1 CURSOR FOR p703_cci_p1
     FOREACH p703_cci_c1 INTO l_cci01,l_cci02
        IF sqlca.sqlcode THEN
           CALL cl_err('del cci',STATUS,0)
           LET g_success='N'
        END IF
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM ccj_file
                 WHERE ccj01 = l_cci01 AND ccj02 = l_cci02
 
        IF g_cnt=0 THEN
           DELETE FROM cci_file
           WHERE cci01 = l_cci01 AND cci02 = l_cci02
           IF SQLCA.sqlcode THEN
              IF g_bgjob = 'N' THEN  #FUN-C50019
                 ERROR "DELETE FROM cci_file ERROR:",SQLCA.sqlcode
              END IF #FUN-C50019
              LET g_success='N'
           END IF
        END IF
     END FOREACH
     ELSE  
       UPDATE ccj_file SET ccj05=0,ccj051=0
        WHERE ccj01 BETWEEN l_bdate AND l_edate            #CHI-9A0021
          AND ccj04 IN (SELECT sfb01 FROM sfb_file
                        WHERE sfb93='N'
                        )
     END IF 
   END IF
     
 
     INITIALIZE srf.* TO NULL
     INITIALIZE srg.* TO NULL
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
     LET l_sql = "SELECT * FROM srf_file,srg_file ",
                 " WHERE srf01=srg01 ",
                 "   AND srfconf='Y' ",
                #"   AND YEAR(srf02)  = ",tm.yy,   #MOD-A20084 mark
                #"   AND MONTH(srf02) = ",tm.mm,   #MOD-A20084 mark
                 "   AND srf02 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                 "   AND srf07='2'"   #工單生產報工
     PREPARE p703_prepare FROM l_sql
     DECLARE p703_cur CURSOR FOR p703_prepare
     FOREACH p703_cur INTO srf.*,srg.*
        IF SQLCA.sqlcode THEN 
           CALL cl_err('',STATUS,0) 
           LET g_success='N'
        END IF 
 
        IF cl_null(srg.srg10) THEN LET srg.srg10 = 0 END IF    #工時(分)
        IF g_bgjob = 'N' THEN  #FUN-C50019
           MESSAGE 'Transfer Note:',srg.srg01                     #報工單號
        END IF   #FUN-C50019
        
        CALL ui.Interface.refresh()
        INITIALIZE cci.* TO NULL
        INITIALIZE ccj.* TO NULL
 
        LET cci.cci01 = srf.srf02                       #報工日期
        SELECT eca03 INTO l_eca03 FROM eca_file,eci_file
         WHERE eca01 = eci03 AND eci01 = srf.srf03
        IF g_ccz.ccz06 = '1' THEN LET l_eca03 = ' ' END IF     #No:MOD-B60050 #當參數設定為止區分年月時，則成本中心應為一個空白
        LET cci.cci02 = l_eca03                         #成本中心
        LET cci.cci03 = ''                              #備註
        LET cci.cci04 = ''                              #NO USE
        LET cci.cci05 = 0                               #工時合計
#       LET cci.ccifirm = 'N'                           #確認碼    #FUN-950008 mark
        LET cci.ccifirm = g_ccifirm                                #FUN-950008 add  
        LET cci.cciinpd = g_today                       #輸入日期                                
        LET cci.cciacti = 'Y'                           #資料有效碼
        LET cci.cciuser = g_user                        #資料所有者
        LET cci.ccigrup = g_grup                        #資料所有群
        LET cci.ccimodu = ''                            #資料更改者                              
        LET cci.ccidate = g_today                       #最近修改日
 
        LET ccj.ccj01 = srf.srf02                       #報工日期
        LET ccj.ccj02 = l_eca03                         #成本中心
        SELECT max(ccj03) INTO ccj.ccj03 FROM ccj_file  #序號
         WHERE ccj01 = ccj.ccj01 AND ccj02 = ccj.ccj02 
        IF cl_null(ccj.ccj03) OR (ccj.ccj03 = 0) THEN
           LET ccj.ccj03 = 1
        ELSE
           LET ccj.ccj03 = ccj.ccj03 + 1
        END IF 
        LET ccj.ccj04 = srg.srg16                       #工單編號
        LET ccj.ccj05 = srg.srg10/60                    #投入工時
        LET ccj.ccj051= srg.srg19/60  #FUN-910076           
        LET ccj.ccj06 = srg.srg05+srg.srg06+srg.srg07   #生產數量
        LET ccj.ccj07 = 0                               #投入標準人工工時
        LET ccj.ccj071= 0                               #投入標準機器工時   #MOD-840464 add
        CALL cl_get_feldname('srf01',g_lang) RETURNING l_msg 
        LET ccj.ccj08 = l_msg,":",srf.srf01,' ',srg.srg02 using '###'        #備註
        IF cl_null(ccj.ccj05) THEN LET ccj.ccj05 = 0 END IF
        IF ccj.ccj03 = 1 THEN
           LET cci.ccioriu = g_user      #No.FUN-980030 10/01/04
           LET cci.cciorig = g_grup      #No.FUN-980030 10/01/04
           LET cci.ccilegal = g_legal    #FUN-A50075
           INSERT INTO cci_file VALUES(cci.*)
           IF SQLCA.sqlcode THEN
              IF g_bgjob = 'N' THEN  #FUN-C50019
                 ERROR "INSERT INTO cci_file ERROR:",SQLCA.sqlcode 
              END IF #FUN-C50019
              LET g_success='N'
              EXIT FOREACH
           END IF 
        END IF 
        LET ccj.ccjlegal = g_legal   #FUN-A50075
        INSERT INTO ccj_file VALUES(ccj.*)
        IF SQLCA.sqlcode THEN
           IF g_bgjob = 'N' THEN  #FUN-C50019
              ERROR "INSERT INTO ccj_file ERROR:",SQLCA.sqlcode 
           END IF #FUN-C50019
           LET g_success='N'
           EXIT FOREACH
        END IF 
 
        #更新單頭工時合計(cci05)欄位
        SELECT SUM(ccj05) INTO cci.cci05 FROM ccj_file 
         WHERE ccj01 = ccj.ccj01 AND ccj02 = ccj.ccj02
        IF cl_null(cci.cci05) THEN LET cci.cci05 = 0 END IF 
        UPDATE cci_file SET cci05 = cci.cci05 
         WHERE cci01 = cci.cci01 AND cci02 = cci.cci02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           IF g_bgjob = 'N' THEN  #FUN-C50019
              ERROR "UPDATE cci_file.cci05 ERROR:",SQLCA.sqlcode 
           END IF #FUN-C50019
           LET g_success='N'
           EXIT FOREACH
        END IF 
     END FOREACH
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END FUNCTION
#No.FUN-9C0073 -----------By chenls 10/01/12
