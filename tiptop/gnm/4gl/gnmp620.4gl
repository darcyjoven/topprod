# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gnmp620.4gl
# Descriptions...: 應付票據月底重評價作業
# Date & Author..: 03/04/22 By Danny
# Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-550057 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570160 06/03/06 By saki 批次作業背景執行 
# Modify.........: NO.TQC-660040 06/06/12 BY Smapmin 執行後會出現不明視窗且錯誤訊息無法去除
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680145 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-CB0155 12/11/16 By yinhy 默認期間取nmz21、nmz22，重估匯率為0不做重評價
# Modify.........: No:FUN-D40107 13/05/23 By lujh INSERT INTO oox_file前给状态栏位赋值
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   	string  #No.FUN-580092 HCN
DEFINE g_yy,g_mm	LIKE type_file.num5     #NO FUN-680145 SMALLINT
DEFINE b_date,e_date    LIKE type_file.dat      #NO FUN-680145 DATE
#No.FUN-570160 --start--
DEFINE g_change_lang    LIKE type_file.chr1     #NO FUN-680145 VARCHAR(01)             
DEFINE ls_date          STRING                 
#No.FUN-570160 ---end---

#FUN-D40107--add--str--
DEFINE g_ooxacti    LIKE oox_file.ooxacti
DEFINE g_ooxuser    LIKE oox_file.ooxuser             
DEFINE g_ooxoriu    LIKE oox_file.ooxorig
DEFINE g_ooxorig    LIKE oox_file.ooxorig
DEFINE g_ooxgrup    LIKE oox_file.ooxgrup
DEFINE g_ooxmodu    LIKE oox_file.ooxmodu
DEFINE g_ooxdate    LIKE oox_file.ooxdate       
DEFINE g_ooxcrat    LIKE oox_file.ooxcrat
#FUN-D40107--add--end--
 
MAIN
   DEFINE l_flag        LIKE type_file.chr1     #No.FUN-570160 #NO FUN-680145 VARCHAR(01)
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #No.FUN-570160 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570160 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    

   WHILE TRUE
      IF g_bgjob = "N" THEN
         IF g_nmz.nmz63 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE   #TQC-660040
         ELSE
            CALL p620()                               # UI
            IF cl_sure(18,20) THEN 
               LET g_success = 'Y'
               CALL cl_wait()
               BEGIN WORK
               CALL p620_t()
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
                  CLOSE WINDOW p620
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         END IF
      ELSE
         IF g_nmz.nmz63 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE   #TQC-660040
         ELSE
            LET g_success = 'Y'
            BEGIN WORK
            CALL p620_t()
            IF g_success = "Y" THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   # No.FUN-570160 --end--

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p620()
   DEFINE   lc_cmd        LIKE type_file.chr1000  #No.FUN-570160  #NO FUN-680145 VARCHAR(500) 
 
   OPEN WINDOW p620 WITH FORM "gnm/42f/gnmp620" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   #No.MOD-CB0155  --Begin
   #LET g_yy = YEAR(g_today)
   #LET g_mm = MONTH(g_today)
   IF cl_null(g_yy) OR g_yy=0 THEN   #FUN-D40107  add
      LET g_yy = g_nmz.nmz21
   END IF                  #FUN-D40107  add
   IF cl_null(g_mm) OR g_mm=0 THEN   #FUN-D40107  add
      LET g_mm = g_nmz.nmz22
   END IF                  #FUN-D40107  add
   #No.MOD-CB0155  --End
   LET g_bgjob = "N"                      #No.FUN-570160

   WHILE TRUE
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS   #No.FUN-570160
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            CALL cl_dynamic_locale()      #No.FUN-570160
            CALL cl_show_fld_cont()       #No.FUN-550037 hmf   No.FUN-570160
            LET g_change_lang = TRUE      #No.FUN-570160
            EXIT INPUT                    #No.FUN-570160
 
         AFTER FIELD g_yy
            IF cl_null(g_yy) THEN 
               NEXT FIELD g_yy
            END IF
 
         AFTER FIELD g_mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_yy
            IF g_azm.azm02 = 1 THEN
               IF g_mm > 12 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            ELSE
               IF g_mm > 13 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            END IF
         END IF
#            IF cl_null(g_mm) OR g_mm < 1 OR g_mm > 13 THEN 
#               NEXT FIELD g_mm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER INPUT
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF
            IF (g_yy*12+g_mm) < (g_nmz.nmz64*12+g_nmz.nmz65) THEN 
               CALL cl_err(g_mm,'axr-404',1) NEXT FIELD g_mm
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
 
          #No.MOD-480423
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
          #No.MOD-480423 (end)
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      #No.FUN-570160 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570160 ---end---
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CLOSE WINDOW p620        #No.FUN-570160
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM             #No.FUN-570160
#        EXIT WHILE               #No.FUN-570160
      END IF
 
      #No.FUN-570160 --start--
#     IF NOT cl_sure(15,20) THEN 
#        RETURN 
#     END IF
#     CALL cl_wait()
#     BEGIN WORK
#     LET g_success = 'Y'
#     CALL p620_t()
#     IF g_success = 'Y' THEN
#        COMMIT WORK
#     ELSE
#        ROLLBACK WORK
#     END IF
#     ERROR ''
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0
#        EXIT WHILE
#     END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gnmp620"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gnmp620','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gnmp620',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p620
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
      #No.FUN-570160 ---end---
   END WHILE
 
END FUNCTION
 
FUNCTION p620_t()
   DEFINE l_sql         LIKE type_file.chr1000  #NO FUN-680145 VARCHAR(600) 
   DEFINE l_name        LIKE type_file.chr20    #NO FUN-680145 VARCHAR(20)
   DEFINE yymm          LIKE azj_file.azj02     #NO FUN-680145 VARCHAR(06)
   DEFINE amt1,amt2     LIKE nmd_file.nmd04 
   DEFINE l_cnt         LIKE type_file.num5     #NO FUN-680145 SMALLINT
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_net,l_amt   LIKE nmd_file.nmd04       
   DEFINE l_trno        LIKE npp_file.npp01     #No.FUN-550057   #NO FUN-680145 VARCHAR(16)
   DEFINE l_amt_np      LIKE nmd_file.nmd04
   DEFINE sr            RECORD 
                        nmd01   LIKE nmd_file.nmd01,
                        nmd07   LIKE nmd_file.nmd07,
                        nmd21   LIKE nmd_file.nmd21,
                        nmd19   LIKE nmd_file.nmd19,
                        nmd26   LIKE nmd_file.nmd26,
                        nmd33   LIKE nmd_file.nmd33,
                        amt1    LIKE nmd_file.nmd04, 
                        azj07   LIKE azj_file.azj07 
                        END RECORD
 
#  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17  #No.CHI-6A0004
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'NM',g_yy USING '&&&&',g_mm USING '&&'

   #FUN-D40107--add--str--
   LET g_ooxacti = 'Y' 
   LET g_ooxuser = g_user                
   LET g_ooxoriu = g_user 
   LET g_ooxorig = g_grup 
   LET g_ooxgrup = g_grup
   LET g_ooxmodu = ''  
   LET g_ooxdate = g_today             
   LET g_ooxcrat = g_today  
   #FUN-D40107--add--end-- 
 
   #檢查是否已拋轉總帳
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 15 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有大於本月的異動記錄
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'NP' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-403',1) LET g_success = 'N' RETURN 
   END IF
   #刪除分錄底稿
   DELETE FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 15 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
#     CALL cl_err('del npp',STATUS,1)  #No.FUN-660146
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)   #No.FUN-660146
      LET g_success='N' RETURN  
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'NM' AND npq00 = 15 AND npq011 = 1
      AND npq01 = l_trno 
   IF STATUS THEN
#     CALL cl_err('del npq',STATUS,1)  #No.FUN-660146
      CALL cl_err3("del","npq_file",l_trno,"",STATUS,"","del npq",1)   #No.FUN-660146
      LET g_success='N' RETURN  
   END IF

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = l_trno
   IF STATUS THEN
      CALL cl_err3("del","tic_file",l_trno,"",STATUS,"","del tic",1)
      LET g_success='N' 
      RETURN
   END IF
   #FUN-B40056--add--end--

   #還原
   DECLARE p620_del_curs1 CURSOR FOR 
     SELECT oox_file.* FROM oox_file 
      WHERE oox00 = 'NP' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p620_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p620_del_curs1',STATUS,1) LET g_success='N' RETURN  
      END IF
      UPDATE nmd_file SET nmd33 = l_oox.oox06 WHERE nmd01 = l_oox.oox03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd nmd',STATUS,1)  #No.FUN-660146
         CALL cl_err3("upd","nmd_file",l_oox.oox03,"",STATUS,"","upd nmd",1)   #No.FUN-660146
         LET g_success='N' RETURN  
      END IF
      DELETE FROM oox_file WHERE oox03=l_oox.oox03 AND oox04=l_oox.oox04 AND oox02=l_oox.oox02 AND oox01=l_oox.oox01 AND oox00=l_oox.oox00
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del oox',STATUS,1)  #No.FUN-660146
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)   #No.FUN-660146
         LET g_success='N' RETURN  
      END IF
   END FOREACH
 
   LET l_sql = "SELECT nmd01,nmd07,nmd21,nmd19,nmd26,nmd33,",
               "       nmd04,azj07 ", 
               " FROM nmd_file LEFT OUTER JOIN azj_file ON nmd_file.nmd21=azj_file.azj01 ",
               " WHERE nmd12 IN ('1','X') AND nmd30 = 'Y' ",
               "   AND nmd21 != '",g_aza.aza17,"'",
               " AND azj_file.azj02='",yymm,"'",
               "   AND nmd07 <= '",e_date,"'",
               " ORDER BY nmd01 "
   PREPARE p620_pre1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('p620_pre1',STATUS,1)
      CALL cl_batch_bg_javamail("N")        #No.FUN-570160
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p620_curs1 CURSOR FOR p620_pre1
   FOREACH p620_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p620_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      #IF cl_null(sr.azj07) THEN                      #MOD-CB0155 mark
      IF cl_null(sr.azj07) OR sr.azj07 = 0  THEN    #MOD-CB0155
         CALL cl_err(sr.nmd21,'aoo-056',1) LET g_success='N' EXIT FOREACH
      END IF
 
      #當月立帳資料,賦予重估匯率
      IF sr.nmd07 >= b_date AND sr.nmd07 <= e_date THEN
         LET sr.nmd33 = sr.nmd19
      END IF
      #取得未沖金額
      CALL s_g_np('5','1',sr.nmd01,'') RETURNING l_amt_np 
      IF cl_null(l_amt_np) THEN LET l_amt_np = 0 END IF
 
      #匯差= 本幣未沖金額-(原幣未沖金額*重估匯率)
      LET l_net = l_amt_np - (sr.amt1 * sr.azj07) 
      IF cl_null(l_net) THEN LET l_net = 0 END IF
      CALL cl_digcut(l_net,g_azi04) RETURNING l_net
 
      #本幣未沖金額=上月未沖金額-匯差
      LET l_amt = l_amt_np - l_net 
 
      #產生異動記錄檔
      IF l_net != 0 THEN 
         INSERT INTO oox_file(oox00,oox01,oox02,oox03v,oox03,oox04,
                              oox05,oox06,oox07,oox08,oox09,oox10, #No.MOD-470041
                              oox11,                        #No.FUN-D70002   Add
                              ooxlegal,                            #FUN-980011 add
                              ooxacti,ooxuser,ooxoriu,ooxorig,     #FUN-D40107 add
                              ooxgrup,ooxmodu,ooxdate,ooxcrat)     #FUN-D40107 add
                       VALUES('NP',g_yy,g_mm,'1',sr.nmd01,0,sr.nmd21,
                              sr.nmd33,sr.azj07,l_amt_np,l_amt,l_net,
                              sr.amt1,                      #No.FUN-D70002   Add
                              g_legal,           #FUN-980011 add
                              g_ooxacti,g_ooxuser,g_ooxoriu,g_ooxorig,  #FUN-D40107 add
                              g_ooxgrup,g_ooxmodu,g_ooxdate,g_ooxcrat)  #FUN-D40107 add   
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins oox',STATUS,1)  #No.FUN-660146
            CALL cl_err3("ins","oox_file",sr.nmd01,"NP",STATUS,"","ins oox",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH  
         END IF
      END IF
      #更新重估匯率
      UPDATE nmd_file SET nmd33 = sr.azj07 WHERE nmd01 = sr.nmd01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd nmd',STATUS,1)   #No.FUN-660146
         CALL cl_err3("upd","nmd_file",sr.nmd01,"",STATUS,"","upd nmd",1)   #No.FUN-660146
         LET g_success='N' EXIT FOREACH 
      END IF
   END FOREACH
 
   #更新月底重評價年度月份
   UPDATE nmz_file SET nmz64 = g_yy, nmz65 = g_mm
    WHERE nmz00 = '0'
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd nmz64/65',STATUS,1)   #No.FUN-660146
      CALL cl_err3("upd","nmz_file","","",STATUS,"","upd nmz64/65",1)   #No.FUN-660146
      LET g_success='N'  
   END IF
END FUNCTION
