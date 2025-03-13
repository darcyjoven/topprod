# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp700.4gl
# Descriptions...: 生產日報工時轉成會每日工時作業
# Date & Author..: 99/04/30 By ChiaYi FOR TIPTOP 4.00 
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570153 06/03/14 By yiting 背景作業
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-750146 07/06/07 By pengu 調整成本中心的抓法
# Modify.........: No.MOD-840464 08/04/21 By Sarah ccj_file增加了ccj071,應給予DEFAULT值0
# Modify.........: No.FUN-840181 08/06/12 By Sherry 增加實際機時
# Modify.........: No.CHI-860018 08/08/04 By sherry 考慮axcp700,axcp703同時執行
# Modify.........: No.FUN-910076 09/02/02 By jan 擷取機時資料
# Modify.........: No.MOD-930304 09/05/21 By Pengu 判斷若shb.shb033為NULL則default 0
# Modify.........: No.MOD-940371 09/05/21 By Pengu 再刪除cci_file時資料未正確的刪除，造成INSERT 時會出現-239異常
# Modify.........: No.FUN-980069 09/08/21 By mike 將年度欄位default ccz01月份欄位default ccz02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-950008 10/02/23 By vealxu 新增自動確認checkbox欄位 
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.CHI-BC0036 11/12/28 By ck2yuan 增加控管年度期別不可小於現行年度期別
# Modify.........: No.MOD-C50202 12/05/30 By Elise l_cnt為type_file.num5,但筆數超過了type_file.num5取值範圍
# Modify.........: No.FUN-C80092 12/12/04 By lixh1 增加寫入日誌功能
# Modify.........: No:CHI-C80041 13/01/03 By bart 作廢判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          yy LIKE type_file.num5,           #No.FUN-680122 smallint, 
          mm LIKE type_file.num5            #No.FUN-680122 smallint 
         ,check LIKE type_file.chr1         #No.FUN-950008 VARCHAR(1)
          END RECORD
DEFINE g_row,g_col   LIKE type_file.num5           #No.FUN-680122 smallint, 
DEFINE g_cnt         LIKE type_file.num10    #CHI-860018   #MOD-C50202 mod num5->num10
DEFINE g_flag  LIKE type_file.chr1                 #No.FUN-680122 VARCHAR(1)
DEFINE g_change_lang LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)               #FUN-570153
DEFINE g_ccifirm     LIKE type_file.chr1           #No.FUN-950008 VARCHAR(1)     
DEFINE g_cka00       LIKE cka_file.cka00           #FUN-C80092
DEFINE l_msg         STRING                        #FUN-C80092

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF s_shut(0) THEN RETURN END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy   = ARG_VAL(1)
   LET tm.mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
 
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
    
 
#  CALL cl_used('axcp700',g_time,1) RETURNING g_time   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p700_tm(0,0)
         IF cl_sure(21,21) THEN  
   #FUN-C80092 -------------Begin---------------
            LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";",
                        "tm.check = '",tm.check,"'",";","g_bgjob = '",g_bgjob,"'"
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
                 RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
            BEGIN WORK
            CALL axcp700()
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
                CONTINUE WHILE
            ELSE
                CLOSE WINDOW p700_w
                EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p700_w
      ELSE
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";",
                     "tm.check = '",tm.check,"'",";","g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         CALL axcp700()
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')     #更新日誌  #FUN-C80092
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#  CALL cl_used('axcp700',g_time,2) RETURNING g_time   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p700_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE   lc_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)      #FUN-570153
 
   LET g_row = 4 LET g_col = 38
 
   OPEN WINDOW p700_w AT g_row,g_col WITH FORM "axc/42f/axcp700"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
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
      LET tm.check = 'N'      #FUN-950008  add 
      LET g_ccifirm = 'N'     #FUN-950008  add  
      LET g_bgjob = 'N'                         #FUN-570153
 
       INPUT BY NAME tm.yy,tm.mm,tm.check,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570153 #No.FUN-950008 add check 
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF tm.mm IS NULL THEN
               NEXT FIELD mm 
            END IF
            IF tm.mm < 1 OR tm.mm > 12 THEN
               NEXT FIELD mm
            END IF

         #No.FUN-950008 ---start---
         AFTER FIELD check
            IF tm.check = 'Y' THEN
              LET g_ccifirm = 'Y' 
            END IF 
         #No.FUN-950008 ---end---

         #-----CHI-BC0036 str add-----
         AFTER INPUT
             IF tm.yy*12+tm.mm > g_ccz.ccz01*12+g_ccz.ccz02 THEN
               CALL cl_err('','axc-196','1')
               #ERROR "計算年度期別不可小於現行年期!"
               NEXT FIELD yy
             END IF
         #-----CHI-BC0036 end add-----

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
            LET g_change_lang = TRUE                  #FUN-570153
            EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p700_w     #FUN-570153
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
 
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 ='axcp700'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axcp700','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp700',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p700_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION axcp700()
DEFINE    l_gen03       LIKE gen_file.gen03,
          l_eca03       LIKE eca_file.eca03,    #No.MOD-750146 add
          l_sql		LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(500),
          l_cci01       LIKE cci_file.cci01,        #No.MOD-940371 add
          l_cci02       LIKE cci_file.cci02,        #No.MOD-940371 add
          l_ccj06       LIKE ccj_file.ccj06,
          shb           RECORD LIKE shb_file.*,
          cci           RECORD LIKE cci_file.*,
          ccj           RECORD LIKE ccj_file.* 
   DEFINE l_cnt         LIKE type_file.num10    #FUN-910076     #MOD-C50202 mod num5->num10
   DEFINE l_bdate       LIKE type_file.dat      #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat      #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1     #CHI-9A0021 add 
 
 
 
    LET l_cnt = 0                            

   #當月起始日與截止日
    CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
                                                                                
    SELECT COUNT(*) INTO l_cnt  FROM ccj_file                                                                                
     WHERE ccj01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
       AND ccj04 IN (SELECT sfb01 FROM sfb_file
                      WHERE sfb93='Y')
                   
   IF l_cnt > 0 THEN
     IF  cl_confirm('axc-525') THEN
     DELETE FROM ccj_file 
     WHERE ccj01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
       AND ccj04 IN (SELECT sfb01 FROM sfb_file
                      WHERE sfb93='Y'
                    )
     IF SQLCA.sqlcode THEN 
        ERROR "DELETE FROM ccj_file ERROR:",SQLCA.sqlcode 
        LET g_success='N'
     END IF
 
     LET l_sql = " SELECT cci01,cci02 FROM cci_file ",
                 "    WHERE cci01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                 "      AND ccifirm <> 'X' "   #CHI-C80041
 
     PREPARE p700_cci_p1 FROM l_sql
     DECLARE p700_cci_c1 CURSOR FOR p700_cci_p1
     FOREACH p700_cci_c1 INTO l_cci01,l_cci02
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
              ERROR "DELETE FROM cci_file ERROR:",SQLCA.sqlcode
              LET g_success='N'
           END IF
        END IF
     END FOREACH
     ELSE
       UPDATE ccj_file SET ccj05=0,ccj051=0 
        WHERE ccj01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
          AND ccj04 IN (SELECT sfb01 FROM sfb_file
                         WHERE sfb93='Y'
                        )
     END IF
   END IF
 
     INITIALIZE shb.* TO NULL
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
     LET l_sql = "SELECT * FROM shb_file ",
                 " WHERE shb03 BETWEEN '",l_bdate,"' AND '",l_edate,"'"  
                ,"   AND shbconf = 'Y' "         #FUN-A70095
     PREPARE p700_prepare FROM l_sql
     DECLARE p700_cur CURSOR FOR p700_prepare
     FOREACH p700_cur INTO shb.*
         IF sqlca.sqlcode THEN 
            CALL cl_err('',STATUS,0) 
            LET g_success='N'
         END IF 
         IF cl_null(shb.shb032) THEN LET shb.shb032 = 0 END IF
         IF cl_null(shb.shb033) THEN LET shb.shb033 = 0 END IF   #No.MOD-930304 add
         IF g_bgjob = 'N' THEN         #FUN-570153
             MESSAGE 'Transfer Note:',shb.shb01
         END IF
         CALL ui.Interface.refresh()
         initialize cci.* to null
         initialize ccj.* to null
         LET l_gen03 = ''
         LET cci.cci01 = shb.shb03  #報工日期
         select gen03 into l_gen03 from gen_file where gen01 = shb.shb04
         LET l_eca03 = ' '
         SELECT eca03 INTO l_eca03 FROM eca_file WHERE eca01=shb.shb07
         CASE WHEN g_ccz.ccz06 = '3'
                LET cci.cci02 = shb.shb081
              WHEN g_ccz.ccz06 = '4'
                LET cci.cci02 = shb.shb07
              WHEN g_ccz.ccz06 = '1'
                LET cci.cci02 = ' '
              WHEN g_ccz.ccz06 = '2'
                LET cci.cci02 = l_eca03
              OTHERWISE
                LET cci.cci02 = l_gen03    #部門
         END CASE
         LET cci.cci03 = ""         #備註
         LET cci.cci04 = ""         #NO USE
         LET cci.cci05 = 0          #工時合計
#        LET cci.ccifirm = 'Y'      #確認碼   #FUN-950008 mark
         LET cci.ccifirm = g_ccifirm          #FUN-950008 add 
         LET cci.cciinpd   = TODAY  #輸入日期                                
         LET cci.cciacti   = 'Y'    #資料有效碼
         LET cci.cciuser   = g_user #資料所有者
         LET cci.ccigrup   = g_grup #資料所有群
         LET cci.ccimodu   = ''     #資料更改者                              
         LET cci.ccidate   = NULL   #最近修改日
     
         LET ccj.ccj01 = shb.shb03  #報工日期
         CASE WHEN g_ccz.ccz06 = '3'
                LET ccj.ccj02 = shb.shb081
              WHEN g_ccz.ccz06 = '4'
                LET ccj.ccj02 = shb.shb07
              WHEN g_ccz.ccz06 = '1'
                LET ccj.ccj02 = ' '
              WHEN g_ccz.ccz06 = '2'
                LET ccj.ccj02 = l_eca03
              OTHERWISE
                LET ccj.ccj02 = l_gen03    #部門
         END CASE
 
         SELECT max(ccj03) INTO ccj.ccj03 FROM ccj_file  #序號
         WHERE ccj01 = ccj.ccj01 AND ccj02 = ccj.ccj02 
         IF cl_null(ccj.ccj03) OR (ccj.ccj03 = 0) THEN
            LET ccj.ccj03 = 1
         ELSE
            LET ccj.ccj03 = ccj.ccj03 + 1
         END IF 
         LET ccj.ccj04 = shb.shb05     #工單單號
         LET ccj.ccj05 = 0
         LET ccj.ccj06 = 0
         LET ccj.ccj05 = shb.shb032/60 #投入工時-->成會以小時為單位
         LET ccj.ccj051= shb.shb033/60 #FUN-910076
         LET ccj.ccj06 = shb.shb111    #生產數量(良品轉出)
         LET l_ccj06 = shb.shb111
         LET ccj.ccj06 =l_ccj06
         LET ccj.ccj07 = 0             #投入標準人工工時   #MOD-840464 add
         LET ccj.ccj071= 0             #投入標準機器工時   #MOD-840464 add  
         LET ccj.ccj08 = shb.shb081    #備註(作業編號)
         IF cl_null(ccj.ccj05) THEN LET ccj.ccj05 = 0 END IF
         IF ccj.ccj03 = 1 THEN
            LET cci.ccioriu = g_user      #No.FUN-980030 10/01/04
            LET cci.cciorig = g_grup      #No.FUN-980030 10/01/04
            LET cci.ccilegal = g_legal    #FUN-A50075
            INSERT INTO cci_file VALUES(cci.*)
            IF sqlca.sqlcode THEN
               IF g_bgjob = 'N' THEN         #FUN-570153
                   ERROR "INSERT INTO cci_file ERROR:",sqlca.sqlcode 
               END IF 
               LET g_success='N'
               EXIT FOREACH
            END IF 
         END IF 
         LET ccj.ccjlegal = g_legal    #FUN-A50075
         INSERT INTO ccj_file VALUES(ccj.*)
         IF SQLCA.sqlcode THEN
             IF g_bgjob = 'N' THEN         #FUN-570153
                 ERROR "INSERT INTO ccj_file ERROR:",sqlca.sqlcode 
             END IF
             LET g_success='N'
             EXIT FOREACH
         END IF 
         SELECT SUM(ccj05) INTO cci.cci05 FROM ccj_file 
          WHERE ccj01 = ccj.ccj01 AND ccj02 = ccj.ccj02
         
         IF cl_null(cci.cci05) THEN LET cci.cci05 = 0 END IF 
 
         UPDATE cci_file SET cci05 = cci.cci05 WHERE 
         cci01 = cci.cci01 AND cci02 = cci.cci02
         IF sqlca.sqlcode OR sqlca.sqlerrd[3] = 0 
         THEN 
             IF g_bgjob = 'N' THEN         #FUN-570153
                 ERROR "UPDATE cci_file.cci05 ERROR:",sqlca.sqlcode 
             END IF
             LET g_success='N'
             EXIT FOREACH
         END IF 
     END FOREACH
END FUNCTION
#No.FUN-9C0073 ----------------By chenls 10/01/12
