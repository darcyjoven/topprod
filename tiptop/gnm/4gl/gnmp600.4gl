# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gnmp600.4gl
# Descriptions...: 外幣存款月底重評價作業
# Date & Author..: 02/03/11 By Danny
# Modify.........: No:9365 04/03/23 By Kitty nme12為char故nme02要先轉換成文字
# Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-550057 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570160 06/03/06 By saki 批次作業背景執行 
# Modify.........: NO.TQC-660040 06/06/12 BY Smapmin 執行後會出現不明視窗且錯誤訊息無法去除
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680145 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730032 07/03/22 By Elva  新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.MOD-810100 08/01/16 By Smapmin 執行銀行月底重評價時，產生之銀行異動
#                                                    未因匯損知銀行異動碼為提出，匯損金額應該*-1
#                                                    目前直接以負數INSERT造成錯誤
# Modify.........: No.TQC-830043 08/03/21 By lumxa  運行作業報oox_file無法插入null值 
# Modify.........: No.MOD-870221 08/07/24 By Sarah 調整WHERE條件nmg20 MATCHES '2*',改為nmg20 != '1'
# Modify.........: No.MOD-880127 08/08/18 By Sarah 還原MOD-810100修改段
# Modify.........: No.FUN-840015 08/08/27 By xiaofeizhu 相關nmz35的地方都要判斷，分為匯差利得(nmz23)/匯差損失(nmz53)
# Modify.........: No.MOD-890079 08/09/12 By Sarah 將p600_curs1的SQL中,"AND npk05!='",g_aza.aza17,"'"條件還原
# Modify.........: No.MOD-920218 09/02/18 By liuxqa 排除原幣和本幣余額為零的銀行。
# Modify.........: No.MOD-930024 09/03/03 By chenl 還原MOD-880127
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0119 09/11/19 By Sarah 取得l_nme.nme03值後重抓nmc04與nmc05
# Modify.........: No.FUN-9C0012 09/12/02 By destiny nem_file补PK，在insert表时给PK字段预设值
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:MOD-A30093 10/03/17 By sabrina 應先取位再減，否則易造成尾差
# Modify.........: No:CHI-A30015 10/05/17 By Summer 外幣存款做調匯只對銀行存款餘額(nmp_file)做調匯,
#                                                   不需要到anmt302明細去調匯,故不需產生npk_file 
# Modify.........: No:MOD-A70118 10/07/27 By sabrina 幣別上月匯率應抓取azj07
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B40073 11/04/11 By Sarah 執行重評價作業前先檢核nmz35與nmz53是否正確,不正確則不可計算
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No:MOD-CB0155 12/11/16 By yinhy 默認期間取nmz21、nmz22，重估匯率為0不做重評價
# Modify.........: No:FUN-D40107 13/05/23 By lujh INSERT INTO oox_file前给状态栏位赋值
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       STRING                   #No.FUN-580092 HCN
DEFINE g_yy,g_mm	LIKE type_file.num5      #NO FUN-680145 SMALLINT 
DEFINE b_date,e_date    LIKE type_file.dat       #NO FUN-680145 DATE 
DEFINE g_nmc03          LIKE nmc_file.nmc03      #MOD-B40073 add
DEFINE g_nmc04          LIKE nmc_file.nmc04
DEFINE g_nmc05          LIKE nmc_file.nmc05
DEFINE g_change_lang    LIKE type_file.chr1      #NO FUN-680145 VARCHAR(01)           
DEFINE ls_date          STRING   
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
   DEFINE l_flag        LIKE type_file.chr1       #NO FUN-680145 VARCHAR(01) 
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy   = ARG_VAL(1)
   LET g_mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         IF g_nmz.nmz20 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE   #TQC-660040
         ELSE
            CALL p600()                               # UI
            IF cl_sure(18,20) THEN 
               LET g_success = 'Y'
               BEGIN WORK
               CALL p600_t()
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
                  CLOSE WINDOW p600
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         END IF
      ELSE
         IF g_nmz.nmz20 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE   #TQC-660040
         ELSE
            LET g_success = 'Y'
            BEGIN WORK
            CALL p600_t()
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

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END MAIN
 
FUNCTION p600()
   DEFINE   lc_cmd        LIKE type_file.chr1000 #No.FUN-570160   #NO FUN-680145 VARCHAR(500)
 
   OPEN WINDOW p600 WITH FORM "gnm/42f/gnmp600" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   #No.MOD-CB0155  --Begin
   #LET g_yy = YEAR(g_today)
   #LET g_mm = MONTH(g_today)
   LET g_yy = g_nmz.nmz21
   LET g_mm = g_nmz.nmz22
   #No.MOD-CB0155  --End
   LET g_bgjob = "N"                          #No.FUN-570160
 
   WHILE TRUE
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS    #No.FUN-570160
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_change_lang = TRUE        #No.FUN-570160
            EXIT INPUT                      #No.FUN-570160
 
         AFTER FIELD g_yy
            IF cl_null(g_yy) THEN
               NEXT FIELD g_yy
            END IF
 
         AFTER FIELD g_mm
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
 
         AFTER INPUT
            #add 030312 NO.A048
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_yy*12+g_mm) < (g_nmz.nmz21*12+g_nmz.nmz22) THEN 
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
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CLOSE WINDOW p600
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gnmp600"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gnmp600','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gnmp600',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p600
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p600_t()
   DEFINE l_sql         LIKE type_file.chr1000   #NO FUN-680145 VARCHAR(600)
   DEFINE l_name        LIKE type_file.chr20     #NO FUN-680145 VARCHAR(20)
   DEFINE yymm          LIKE azj_file.azj02      #NO FUN-680145 VARCHAR(06)
   DEFINE yymm2         LIKE azj_file.azj02      #MOD-A70118 add
   DEFINE l_azj07       LIKE azj_file.azj07      #MOD-A70118 add
   DEFINE amt1,amt2     LIKE oma_file.oma56
   DEFINE l_cnt         LIKE type_file.num5      #NO FUN-680145 SMALLINT
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE p_oox         RECORD LIKE oox_file.*
  #DEFINE l_net,l_amt   LIKE oma_file.oma56      #CHI-A30015 mark 
  #DEFINE l_net1        LIKE oma_file.oma56      #MOD-A30093 add #CHI-A30015 mark
   DEFINE l_trno        LIKE npp_file.npp01      #No.FUN-550057 #NO FUN-680145 VARCHAR(16)
   DEFINE l_edate       LIKE nme_file.nme12      #No.9365       #NO FUN-680145 VARCHAR(08)
  #CHI-A30015 mark --start--
  # DEFINE sr            RECORD 
  #                      nmg00   LIKE nmg_file.nmg00,
  #                      nmg01   LIKE nmg_file.nmg01,
  #                      npk05   LIKE npk_file.npk05,
  #                      npk06   LIKE npk_file.npk06,
  #                      nmg25   LIKE nmg_file.nmg25,
  #                      nmg09   LIKE nmg_file.nmg09,
  #                      nmg10   LIKE nmg_file.nmg10,
  #                      amt1    LIKE nmg_file.nmg23, 
  #                      azj07   LIKE azj_file.azj07 
  #                      END RECORD
  #CHI-A30015 mark --end--
   DEFINE sr2           RECORD 
                        nma01   LIKE nma_file.nma01, 
                        nma10   LIKE nma_file.nma10, 
                        nmp16   LIKE nmp_file.nmp16, 
                        nmp19   LIKE nmp_file.nmp19, 
                        azj07   LIKE azj_file.azj07, 
                        old_ex  LIKE azj_file.azj07,
                        new_amt LIKE nmp_file.nmp19,
                        net     LIKE nmp_file.nmp19  
                        END RECORD
   DEFINE l_nme24       LIKE nme_file.nme24   #FUN-730032
   DEFINE l_yy,l_mm	LIKE type_file.num5      #MOD-A70118 add
   DEFINE l_gae04       LIKE gae_file.gae04      #MOD-B40073 add
 
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
    WHERE nppsys = 'NM' AND npp00 = 13 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有大於本月的異動記錄
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'NM' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-403',1) LET g_success = 'N' RETURN 
   END IF

  #str MOD-B40073 add
  #執行重評價作業前先檢核nmz35與nmz53是否正確,不正確則不可計算
  #nmz35 匯盈  須存在nmc_file且nmc03='1'
  #nmz53 匯損  須存在nmc_file且nmc03='2'
   LET g_sql = "SELECT nmc03 FROM nmc_file WHERE nmc01=?"
   PREPARE p600_nmc_p FROM g_sql
   DECLARE p600_nmc_c CURSOR FOR p600_nmc_p

   LET g_sql = "SELECT gae04 FROM gae_file",
               " WHERE gae01 = 'anms101' AND gae02 = ?",
               "   AND gae03 = '",g_lang,"'",
               "   AND gae11 = 'N'",
               "   AND gae12 = '",g_ui_setting,"'"
   PREPARE p600_gae_p FROM g_sql
   DECLARE p600_gae_c CURSOR FOR p600_gae_p

   LET g_nmc03=''
   OPEN p600_nmc_c USING g_nmz.nmz35
   FETCH p600_nmc_c INTO g_nmc03
   IF g_nmc03 <> '1' THEN 
      LET l_gae04=''
      OPEN p600_gae_c USING 'nmz35'
      FETCH p600_gae_c INTO l_gae04
      LET l_gae04=l_gae04 CLIPPED,"(nmz35)"
      CALL cl_err(l_gae04,'anm-334',1) LET g_success = 'N' RETURN
   END IF 
   LET g_nmc03=''
   OPEN p600_nmc_c USING g_nmz.nmz53
   FETCH p600_nmc_c INTO g_nmc03
   IF g_nmc03 <> '2' THEN 
      LET l_gae04=''
      OPEN p600_gae_c USING 'nmz53'
      FETCH p600_gae_c INTO l_gae04
      LET l_gae04=l_gae04 CLIPPED,"(nmz53)"
      CALL cl_err(l_gae04,'anm-333',1) LET g_success = 'N' RETURN
   END IF 
  #end MOD-B40073 add

 #CHI-A30015 mark --start--
 #  #檢查是否有沖帳資料
 #  SELECT COUNT(*) INTO l_cnt FROM nmg_file,npk_file
 #   WHERE nmg00 = npk00
 #     AND npk05 != g_aza.aza17
 #     AND nmg20 != '1'         #MOD-870221
 #     AND nmgconf='Y' 
 #     AND nmg01 <= e_date
 #     AND nmg00 IN (SELECT oob06 FROM ooa_file,oob_file 
 #                    WHERE ooa01=oob01 AND ooaconf !='X'
 #                      AND ooa02 > e_date ) 
 #  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
 #  IF l_cnt > 0 THEN 
 #     CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN 
 #  END IF
 #CHI-A30015 mark --end--

   #刪除分錄底稿
   DELETE FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 13 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)   #No.FUN-660146
      LET g_success='N' RETURN  
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'NM' AND npq00 = 13 AND npq011 = 1
      AND npq01 = l_trno 
   IF STATUS THEN
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
   DECLARE p600_del_curs1 CURSOR FOR 
     SELECT oox_file.* FROM oox_file 
      WHERE oox00 = 'NM' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p600_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p600_del_curs1',STATUS,1) LET g_success='N' RETURN 
      END IF
      IF l_oox.oox03v = '2' THEN    #銀行收支單
         UPDATE nmg_file SET nmg09 = l_oox.oox06, nmg10 = l_oox.oox08
          WHERE nmg00 = l_oox.oox03
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","nmg_file",l_oox.oox03,"",STATUS,"","upd nmg",1)   #No.FUN-660146
            LET g_success='N' RETURN 
         END IF
      END IF
      LET l_edate = e_date USING 'YYYYMMDD' #No.9365
      IF l_oox.oox03v = '1' THEN    #銀行存款
         IF g_aza.aza73 = 'Y' THEN #No.MOD-740346
            IF l_oox.oox10 > 0 THEN                          #FUN-840015
               LET g_sql="SELECT nme24 FROM nme_file",
                         " WHERE nme01='", l_oox.oox03,"'",
                         "   AND nme02='", e_date,"'",
                         "   AND nme03='", g_nmz.nmz35,"'",
                         "   AND nme12='", l_edate,"'"
            ELSE                                             #FUN-840015
               LET g_sql="SELECT nme24 FROM nme_file",       #FUN-840015 
                         " WHERE nme01='", l_oox.oox03,"'",  #FUN-840015
                         "   AND nme02='", e_date,"'",       #FUN-840015
                         "   AND nme03='", g_nmz.nmz53,"'",  #FUN-840015
                         "   AND nme12='", l_edate,"'"       #FUN-840015
            END IF                         	                 #FUN-840015
            PREPARE del_nme24_p FROM g_sql
            DECLARE del_nme24_cs CURSOR FOR del_nme24_p
            FOREACH del_nme24_cs INTO l_nme24
               IF l_nme24 != '9' THEN  #No.TQC-750098
                  CALL cl_err(l_edate,'anm-043',1)
                  LET g_success='N'        #No.MOD-740346
                  RETURN
               END IF
            END FOREACH
         END IF #No.MOD-740346
         
         #FUN-B40056 --begin
         IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
            IF l_oox.oox10 > 0 THEN
               DELETE FROM tic_file
                WHERE tic04 IN (
               SELECT nme12 FROM nme_file
                WHERE nme01 = l_oox.oox03 AND nme02 = e_date
                  AND nme03 = g_nmz.nmz35 AND nme12 = l_edate)
            ELSE
               DELETE FROM tic_file
                WHERE tic04 IN (
               SELECT nme12 FROM nme_file
                WHERE nme01 = l_oox.oox03 AND nme02 = e_date
                  AND nme03 = g_nmz.nmz53 AND nme12 = l_edate)
            END IF
            
            IF STATUS THEN 
               CALL cl_err3("del","tic_file",l_oox.oox03,e_date,STATUS,"","del tic",1)
               LET g_success ='N'   
            END IF
         END IF
         #FUN-B40056 --end
         
         IF l_oox.oox10 > 0 THEN                              #FUN-840015
            DELETE FROM nme_file
             WHERE nme01 = l_oox.oox03 AND nme02 = e_date
               AND nme03 = g_nmz.nmz35 AND nme12 = l_edate    #No.9365
         ELSE                                                 #FUN-840015
            DELETE FROM nme_file                              #FUN-840015
             WHERE nme01 = l_oox.oox03 AND nme02 = e_date     #FUN-840015
               AND nme03 = g_nmz.nmz53 AND nme12 = l_edate    #FUN-840015
         END IF               	                              #FUN-840015
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("del","nme_file",l_oox.oox03,e_date,STATUS,"","del nme",1)   #No.FUN-660146
            LET g_success ='N'   
         END IF
         UPDATE nmp_file SET nmp17 = nmp17 - l_oox.oox10, #總帳存入
                             nmp19 = nmp19 - l_oox.oox10, #總帳結存
                             nmp07 = nmp07 - l_oox.oox10, #出納存入
                             nmp09 = nmp09 - l_oox.oox10  #出納結存
          WHERE nmp01 = l_oox.oox03 AND nmp02 = l_oox.oox01
            AND nmp03 = l_oox.oox02
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("upd","nmp_file",l_oox.oox03,l_oox.oox01,STATUS,"","upd nmp #1",1)   #No.FUN-660146
            LET g_success ='N'   
         END IF
      END IF
      DELETE FROM oox_file WHERE oox03 = l_oox.oox03 AND oox04=l_oox.oox04 AND oox02=l_oox.oox02 AND oox01=l_oox.oox01 AND oox00=l_oox.oox00 
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)   #No.FUN-660146
         LET g_success='N' RETURN  
      END IF
   END FOREACH
 
 #CHI-A30015 mark --start--
 #  #客戶匯款入帳/押匯入帳
 #  LET l_sql = "SELECT nmg00,nmg01,npk05,npk06,nmg25,nmg09,nmg10,",
 #              "       nmg23-nmg24,azj07 ", 
 #              " FROM nmg_file,npk_file,OUTER azj_file ",
 #              " WHERE nmg00 = npk00 ",
 #              "   AND nmg20 != '1'",       #MOD-870221
 #              "   AND nmgconf = 'Y' ",
 #              "   AND npk05 != '",g_aza.aza17,"'",   #MOD-890079 mark回復
 #              "   AND azj_file.azj01 = npk_file.npk05 AND azj_file.azj02='",yymm,"'",
 #              "   AND nmg01 <= '",e_date,"'",
 #              "   AND nmg29 != 'Y' ",       #不為暫收
 #              "   AND (nmg23 > nmg24  OR ",
 #              "        nmg00 IN (SELECT oob06 FROM ooa_file,oob_file ",
 #              "                   WHERE ooa01=oob01 AND ooaconf != 'X' ", 
 #              "                     AND ooa02 >'",e_date,"' ))",
 #              " ORDER BY nmg00 "
 #  PREPARE p600_pre1 FROM l_sql
 #  IF STATUS THEN
 #     CALL cl_err('p600_pre1',STATUS,1)
 #     CALL cl_batch_bg_javamail("N")     #No.FUN-570160
 #     EXIT PROGRAM
 #  END IF
 #  DECLARE p600_curs1 CURSOR FOR p600_pre1
 #  FOREACH p600_curs1 INTO sr.*
 #     IF STATUS THEN
 #        CALL cl_err('p600_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
 #     END IF
 #     IF cl_null(sr.azj07) THEN 
 #        CALL cl_err(sr.npk05,'aoo-108',1) LET g_success='N' EXIT FOREACH
 #     END IF
 #     #未沖金額需將大於此月已沖金額加回
 #     SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2 FROM oob_file,ooa_file
 #      WHERE ooa01=oob01 AND oob03='1' AND oob04='2' AND ooaconf='Y'
 #        AND ooa02 > e_date AND oob06 = sr.nmg00
 #     IF cl_null(amt1) THEN LET amt1 = 0 END IF
 #     IF cl_null(amt2) THEN LET amt2 = 0 END IF
 #     LET sr.amt1 = sr.amt1 + amt1
 # 
 #     #當月收支資料,賦予重估匯率
 #     IF sr.nmg01 >= b_date AND sr.nmg01 <= e_date THEN
 #        LET sr.nmg09 = sr.npk06
 #     END IF
 #     #取得未沖金額
 #     #modify 030312 NO.A048
 #     CALL s_g_np('3','2',sr.nmg00,'') RETURNING sr.nmg10
 #     IF cl_null(sr.nmg10) THEN LET sr.nmg10 = 0 END IF
 # 
 #     # 匯差= (原幣未沖金額*重估匯率)-本幣未沖金額 
 #    #MOD-A30093---modify---start---
 #    #LET l_net = (sr.amt1 * sr.azj07) - sr.nmg10 
 #     LET l_net1 = sr.amt1 * sr.azj07
 #     CALL cl_digcut(l_net1,g_azi04) RETURNING l_net1
 #     LET l_net = l_net1 - sr.nmg10
 #    #MOD-A30093---modify---end--- 
 #     IF cl_null(l_net) THEN LET l_net = 0 END IF
 #     CALL cl_digcut(l_net,g_azi04) RETURNING l_net    
 # 
 #     # 本幣未沖金額=上月未沖金額+匯差
 #     LET l_amt = sr.nmg10 + l_net 
 # 
 #     #產生異動記錄檔
 #     IF l_net != 0 THEN 
 #        LET p_oox.oox00 = 'NM'
 #        LET p_oox.oox01 = g_yy
 #        LET p_oox.oox02 = g_mm
 #        LET p_oox.oox03v= '2'
 #        LET p_oox.oox03 = sr.nmg00
 #        LET p_oox.oox04 = 0
 #        LET p_oox.oox05 = sr.npk05
 #        LET p_oox.oox06 = sr.nmg09
 #        LET p_oox.oox07 = sr.azj07
 #        LET p_oox.oox08 = sr.nmg10
 #        LET p_oox.oox09 = l_amt
 #        LET p_oox.oox10 = l_net
 #        LET p_oox.oox041 = 0  #TQC-830043
 #        LET p_oox.ooxlegal = g_legal #FUN-980011 add
 # 
 #        INSERT INTO oox_file VALUES(p_oox.*)
 #        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
 #           CALL cl_err3("ins","oox_file",p_oox.oox03,p_oox.oox01,STATUS,"","ins oox",1)   #No.FUN-660146
 #           LET g_success = 'N' EXIT FOREACH 
 #        END IF
 #     END IF
 #     #更新未沖金額
 #     UPDATE nmg_file SET nmg09 = sr.azj07, nmg10 = l_amt
 #      WHERE nmg00 = sr.nmg00
 #     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
 #        CALL cl_err3("upd","nmg_file",sr.nmg00,"",STATUS,"","upd nmg",1)   #No.FUN-660146
 #        LET g_success='N' EXIT FOREACH 
 #     END IF
 #  END FOREACH
 #CHI-A30015 mark --end--

   #外幣存款月底餘額
   LET l_sql = "SELECT nma01,nma10,nmp16,nmp19,azj07,0,0,0 ",
               "  FROM nma_file,nmp_file,OUTER azj_file ",
               " WHERE nma10 != '",g_aza.aza17,"'",
               "   AND azj_file.azj01 = nma_file.nma10 AND azj_file.azj02='",yymm,"'",
               "   AND nmp01 = nma01 AND nmp02 = ",g_yy," AND nmp03 = ",g_mm,
               "   AND (nmp16 <>0 OR nmp19 <> 0) ",        #No.MOD-920218 add by liuxqa 
               " ORDER BY 1 "
   PREPARE p600_pre2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('p600_pre2',STATUS,1)
      CALL cl_batch_bg_javamail("N")      #No.FUN-570160
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p600_curs2 CURSOR FOR p600_pre2
 
   IF l_oox.oox10 > 0 THEN                              #FUN-840015 
      SELECT nmc04,nmc05 INTO g_nmc04,g_nmc05                      
        FROM nmc_file WHERE nmc01 = g_nmz.nmz35
   ELSE                                                 #FUN-840015
      SELECT nmc04,nmc05 INTO g_nmc04,g_nmc05           #FUN-840015            
        FROM nmc_file WHERE nmc01 = g_nmz.nmz53         #FUN-840015
   END IF        	                                      #FUN-840015
   FOREACH p600_curs2 INTO sr2.*
      IF STATUS THEN
         CALL cl_err('p600_curs2',STATUS,1) LET g_success = 'N' EXIT FOREACH 
      END IF
      #IF cl_null(sr2.azj07) THEN                     #MOD-CB0155 mark
      IF cl_null(sr2.azj07) OR sr2.azj07 = 0  THEN    #MOD-CB0155
         CALL cl_err(sr2.nma10,'aoo-056',1) LET g_success='N' EXIT FOREACH
      END IF
     #MOD-A70118--modify---
     #LET sr2.old_ex = sr2.nmp19 / sr2.nmp16
      IF g_mm = 1 THEN
         LET l_mm = 12
         LET l_yy = g_yy - 1
      ELSE
         LET l_mm = g_mm - 1
         LET l_yy = g_yy
      END IF
      LET yymm2 = l_yy USING '&&&&',l_mm USING '&&'
      SELECT azj07 INTO l_azj07 FROM azj_file 
       WHERE azj01 = sr2.nma10 AND azj02=yymm2
      IF NOT cl_null(l_azj07) THEN
         LET sr2.old_ex = l_azj07
      ELSE
         LET sr2.old_ex = sr2.nmp19 / sr2.nmp16
      END IF
     #MOD-A70118---modify--- 
      LET sr2.new_amt = sr2.nmp16  * sr2.azj07
      CALL cl_digcut(sr2.new_amt,g_azi04) RETURNING sr2.new_amt
      LET sr2.net = sr2.new_amt - sr2.nmp19 
      CALL cl_digcut(sr2.net,g_azi04) RETURNING sr2.net
      IF sr2.net = 0 THEN CONTINUE FOREACH END IF
      #產生異動記錄檔
      IF sr2.net != 0 THEN 
         INSERT INTO oox_file(oox00,oox01,oox02,oox03v,oox03,oox04,
                               oox05,oox06,oox07,oox08,oox09,oox10,oox041,  #TQC-830043
                               oox11,                                       #No.FUN-D70002   Add
                               ooxlegal,                                    #FUN-980011 add
                               ooxacti,ooxuser,ooxoriu,ooxorig,     #FUN-D40107 add
                               ooxgrup,ooxmodu,ooxdate,ooxcrat)     #FUN-D40107 add)   
                       VALUES('NM',g_yy,g_mm,'1',sr2.nma01,'0',sr2.nma10,    #TQC-830043
                              sr2.old_ex,sr2.azj07,sr2.nmp19,
                              sr2.new_amt,sr2.net,'0',   #TQC-830043
                              sr2.nmp16,                                #No.FUN-D70002   Add
                              g_legal,                   #FUN-980011 add
                              g_ooxacti,g_ooxuser,g_ooxoriu,g_ooxorig,  #FUN-D40107 add
                              g_ooxgrup,g_ooxmodu,g_ooxdate,g_ooxcrat)  #FUN-D40107 add  )      
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("ins","oox_file",sr2.nma01,"NM",STATUS,"","ins oox #2",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH  
         END IF
         CALL p600_ins_nme(sr2.nma01,g_yy,g_mm,sr2.net,sr2.azj07)
      END IF
   END FOREACH
   #更新月底重評價年度月份
   UPDATE nmz_file SET nmz21 = g_yy, nmz22 = g_mm
    WHERE nmz00 = '0'
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","nmz_file","","",STATUS,"","upd nmz21/22",1)   #No.FUN-660146
      LET g_success='N' 
   END IF
END FUNCTION
 
FUNCTION p600_ins_nme(p_nmp01,p_nmp02,p_nmp03,p_nme08,p_azj07)
  DEFINE  p_nmp01  LIKE nmp_file.nmp01,  #銀行編號
          p_nme08  LIKE nme_file.nme08,  #金額(本幣)
          p_azj07  LIKE azj_file.azj07,
          l_refno  LIKE nme_file.nme12,
          p_nmp02  LIKE nmp_file.nmp02,
         p_nmp03  LIKE nmp_file.nmp03, 
          l_nme    RECORD LIKE nme_file.*
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
            
    LET l_nme.nme01 = p_nmp01              #銀行編號
    LET l_nme.nme02 = e_date               #異動日期
    IF p_nme08 > 0 THEN                    #FUN-840015
       LET l_nme.nme03 = g_nmz.nmz35       #異動碼
    ELSE                                   #FUN-840015
       LET l_nme.nme03 = g_nmz.nmz53       #FUN-840015
    END IF	                           #FUN-840015
   #重抓nmc04與nmc05
    SELECT nmc04,nmc05 INTO g_nmc04,g_nmc05 FROM nmc_file
     WHERE nmc01 = l_nme.nme03
    LET l_nme.nme04 = 0                    #金額(原幣)
    IF g_lang = '0' OR g_lang = '2' THEN 
         LET l_nme.nme05 = '期末匯差調整'             #摘要
    ELSE LET l_nme.nme05 = 'Exchange Rate Revalued'   #摘要(期末匯差調整)
    END IF
    LET l_nme.nme06 = g_nmc04              #對方科目
    LET l_nme.nme07 = p_azj07              #匯率    
    IF p_nme08 > 0 THEN
       LET l_nme.nme08 = p_nme08
    ELSE
       LET l_nme.nme08 = p_nme08 * -1
    END IF
    LET l_nme.nme12 = e_date USING 'YYYYMMDD'   #參考單號   No.9365
    LET l_nme.nme16 = e_date
    LET l_nme.nme14 = g_nmc05                   #現金變動碼
    LET l_nme.nme17 = 'Revalued'                #摘要(期末匯差調整)
    LET l_nme.nmeacti = 'Y'
    LET l_nme.nmegrup = g_grup
    LET l_nme.nmeuser = g_user
    LET l_nme.nmedate = g_today
    LET l_nme.nme21 = 1
    LET l_nme.nme22 = '24'
    LET l_nme.nme24 = '9'  #No.TQC-750098
    LET l_nme.nmelegal = g_legal #FUN-980011 add
    LET l_nme.nme00=0    #No.FUN-9C0012 
    LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
    LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

    INSERT INTO nme_file VALUES(l_nme.*)
    IF STATUS THEN
        CALL cl_err3("ins","nme_file","","",STATUS,"","ins nme",1)   #No.FUN-660146
        LET g_success = 'N' RETURN 
    END IF                          
    CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062 
    UPDATE nmp_file SET nmp17 = nmp17 + p_nme08,   #總帳存入
                        nmp19 = nmp19 + p_nme08,   #總帳結存
                        nmp07 = nmp07 + p_nme08,   #出納存入
                        nmp09 = nmp09 + p_nme08    #出納結存
                    WHERE nmp01=p_nmp01 AND nmp02=p_nmp02 AND nmp03=p_nmp03      #No.9459
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
       CALL cl_err3("upd","nmp_file",p_nmp01,"",STATUS,"","upd nmp",1)   #No.FUN-660146
       LET g_success ='N' 
    END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼
