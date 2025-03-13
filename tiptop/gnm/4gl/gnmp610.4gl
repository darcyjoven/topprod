# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gnmp610.4gl
# Descriptions...: 應收票據月底重評價作業
# Date & Author..: 03/04/21 By Danny
 # Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-550057 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570160 06/03/06 By saki 批次作業背景執行 
# Modify.........: NO.TQC-630264 06/03/31 BY yiting where條件錯誤
# Modify.........: NO.TQC-640034 06/05/25 BY yiting 32區ds1 執行後會出現不明視窗且錯誤訊息無法去除
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
# Modify.........: No:MOD-D60018 13/06/04 By Lori nmh24增加「託收」票據(nmh24='2')
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql   	string  #No.FUN-580092 HCN
DEFINE g_yy,g_mm	LIKE type_file.num5      #NO FUN-680145 SMALLINT
DEFINE b_date,e_date    LIKE type_file.dat       #NO FUN-680145 DATE  
#No.FUN-570160 --start--
DEFINE g_change_lang    LIKE type_file.chr1      #NO FUN-680145 VARCHAR(01)           
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
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0098
   DEFINE l_flag        LIKE type_file.chr1     #No.FUN-570160 VARCHAR(01)   #NO FUN-680145
   DEFINE p_row,p_col   LIKE type_file.num5     #NO FUN-680145 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570160 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy   = ARG_VAL(1)
   LET g_mm   = ARG_VAL(2)
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   # No.FUN-570160 --start--
   #OPEN WINDOW p610 AT p_row,p_col
   #    WITH FORM "gnm/42f/gnmp610" 
   #   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   #
   #CALL cl_ui_init()
 
   #CALL cl_opmsg('z')
   #IF g_nmz.nmz59 = 'N' THEN
   #   CALL cl_err('','axr-408',1)
   #ELSE
   #   CALL p610()
   #END IF
   #CLOSE WINDOW p610
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         IF g_nmz.nmz59 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE     #NO.TQC-640034
         ELSE
            CALL p610()                               # UI
            IF cl_sure(18,20) THEN 
               LET g_success = 'Y'
               BEGIN WORK
               CALL cl_wait()
               CALL p610_t()
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
                  CLOSE WINDOW p610
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         END IF
      ELSE
         IF g_nmz.nmz59 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE      #NO.TQC-640034
         ELSE
            LET g_success = 'Y'
            BEGIN WORK
            CALL p610_t()
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
   #No.FUN-570160 --end--
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END MAIN
 
FUNCTION p610()
   DEFINE   lc_cmd        LIKE type_file.chr1000   # No.FUN-570160   #NO FUN-680145 VARCHAR(500)
   DEFINE   p_row,p_col   LIKE type_file.num5      # No.FUN-570160   #NO FUN-680145 SMALLINT
 
   #No.FUN-570160 --start--
   LET p_row=5
   LET p_col=25
   OPEN WINDOW p610 AT p_row,p_col
        WITH FORM "gnm/42f/gnmp610" 
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   #No.FUN-570160 --end--
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
   LET g_bgjob = "N"                               #No.FUN-570160
 
   WHILE TRUE
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS   #No.FUN-570160
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#           CALL cl_dynamic_locale()               #No.FUN-570160
#           CALL cl_show_fld_cont()                #No.FUN-550037 hmf   No.FUN-570160
            LET g_change_lang = TRUE               #No.FUN-570160
            EXIT INPUT                             #No.FUN-570160
 
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
            IF (g_yy*12+g_mm) < (g_nmz.nmz60*12+g_nmz.nmz61) THEN 
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
         CLOSE WINDOW p610         #No.FUN-570160
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM              #No.FUN-570160
         #EXIT WHILE               #No.FUN-570160
      END IF
 
      #No.FUN-570160 --start--
#     IF NOT cl_sure(15,20) THEN
#        RETURN
#     END IF
#     CALL cl_wait()
#     BEGIN WORK
#     LET g_success = 'Y'
#     CALL p610_t()
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
          WHERE zz01 = "gnmp610"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gnmp610','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gnmp610',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p610
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
      #No.FUN-570160 ---end---
   END WHILE
 
END FUNCTION
 
FUNCTION p610_t()
   DEFINE l_sql         LIKE type_file.chr1000   #NO FUN-680145 VARCHAR(600) 
   DEFINE l_name        LIKE type_file.chr20     #NO FUN-680145 VARCHAR(20)
   DEFINE yymm          LIKE azj_file.azj02      #NO FUN-680145 VARCHAR(06)
   DEFINE amt1,amt2     LIKE nmh_file.nmh32
   DEFINE l_cnt         LIKE type_file.num5      #NO FUN-680145 SMALLINT
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_net,l_amt   LIKE nmh_file.nmh32       
   DEFINE l_trno        LIKE npp_file.npp01      #No.FUN-550057 #NO FUN-680145 VARCHAR(16)
   DEFINE l_flag        LIKE type_file.chr1      #NO FUN-680145 VARCHAR(01)
   DEFINE sr            RECORD 
                        nmh01   LIKE nmh_file.nmh01,
                        nmh04   LIKE nmh_file.nmh04,
                        nmh03   LIKE nmh_file.nmh03,
                        nmh28   LIKE nmh_file.nmh28,
                        nmh32   LIKE nmh_file.nmh32,
                        nmh39   LIKE nmh_file.nmh39,
                        nmh40   LIKE nmh_file.nmh40,
                        amt1    LIKE nmh_file.nmh32, 
                        azj07   LIKE azj_file.azj07,
                        nmh24   LIKE nmh_file.nmh24
                        END RECORD
 
#  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17    #No.CHI-6A0004
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
    WHERE nppsys = 'NM' AND npp00 = 14 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有大於本月的異動記錄
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'NR' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-403',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有沖帳資料
   SELECT COUNT(*) INTO l_cnt FROM nmh_file 
    WHERE nmh03 != g_aza.aza17
      AND nmh24 IN ('1','2','3') AND nmh38='Y'    #MOD-D60018 add nmh24 = 2
      AND nmh04 <= e_date
      AND nmh01 IN (SELECT oob06 FROM ooa_file,oob_file 
                     WHERE ooa01=oob01 AND ooaconf !='X'
                       AND ooa02 > e_date ) 
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN 
   END IF
   #刪除分錄底稿
   DELETE FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 14 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
#     CALL cl_err('del npp',STATUS,1)   #No.FUN-660146
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)   #No.FUN-660146
      LET g_success='N' RETURN 
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'NM' AND npq00 = 14 AND npq011 = 1
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
   DECLARE p610_del_curs1 CURSOR FOR 
     SELECT oox_file.* FROM oox_file 
      WHERE oox00 = 'NR' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p610_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p610_del_curs1',STATUS,1) LET g_success='N' RETURN 
      END IF
      UPDATE nmh_file SET nmh39 = l_oox.oox06, nmh40 = l_oox.oox08
       WHERE nmh01 = l_oox.oox03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd nmh',STATUS,1)  #No.FUN-660146
         CALL cl_err3("upd","nmh_file",l_oox.oox03,"",STATUS,"","upd nmh",1)   #No.FUN-660146
         LET g_success='N' RETURN 
      END IF
      DELETE FROM oox_file WHERE oox03=l_oox.oox03 AND oox04=l_oox.oox04 AND oox02=l_oox.oox02 AND oox01=l_oox.oox01 AND oox00=l_oox.oox00 
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del oox',STATUS,1)  #No.FUN-660146
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)   #No.FUN-660146
         LET g_success='N' RETURN 
      END IF
   END FOREACH
 
   LET l_sql = "SELECT nmh01,nmh04,nmh03,nmh28,nmh32,nmh39,nmh40,",
               "       nmh02-nmh17,azj07,nmh24 ", 
               " FROM nmh_file LEFT OUTER JOIN azj_file ON nmh_file.nmh03=azj_file.azj01 ",
               " WHERE nmh24 IN ('1','2','3') AND nmh38 = 'Y' ",                               #MOD-D60018 add nmh24 = 2
               "   AND nmh03 != '",g_aza.aza17,"'",
               "   AND azj_file.azj02='",yymm,"'",
               #"   AND nmh04 <= '",e_date,"' AND nmh01='NRA-360001'",  #NO.TQC-630264 MARK
               "   AND nmh04 <= '",e_date,"'",
               "   AND (nmh02 > nmh17  OR ",
               "        nmh01 IN (SELECT oob06 FROM ooa_file,oob_file ",
               "                   WHERE ooa01=oob01 AND ooaconf != 'X' ", 
               "                     AND ooa02 >'",e_date,"' ))",
               " ORDER BY nmh01 "
   PREPARE p610_pre1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('p610_pre1',STATUS,1)
      CALL cl_batch_bg_javamail("N")            #No.FUN-570160
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p610_curs1 CURSOR FOR p610_pre1
   FOREACH p610_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p610_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      #IF cl_null(sr.azj07) THEN                    #MOD-CB0155 mark
      IF cl_null(sr.azj07) OR sr.azj07 = 0  THEN    #MOD-CB0155
         CALL cl_err(sr.nmh03,'aoo-056',1) LET g_success='N' EXIT FOREACH
      END IF
      #未沖金額需將大於此月已沖金額加回
      SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2 FROM oob_file,ooa_file
       WHERE ooa01=oob01 AND oob03='1' AND oob04='1' AND ooaconf='Y'
         AND ooa02 > e_date AND oob06 = sr.nmh01
      IF cl_null(amt1) THEN LET amt1 = 0 END IF
      IF cl_null(amt2) THEN LET amt2 = 0 END IF
      LET sr.amt1 = sr.amt1 + amt1
 
      #當月立帳資料,賦予重估匯率
      IF sr.nmh04 >= b_date AND sr.nmh04 <= e_date THEN
         LET sr.nmh39 = sr.nmh28
      END IF
 
      IF sr.nmh24 = '1' THEN LET l_flag = '1' ELSE LET l_flag = '2' END IF
  
      #取得未沖金額
      CALL s_g_np('4','1',sr.nmh01,'') RETURNING sr.nmh40
      IF cl_null(sr.nmh40) THEN LET sr.nmh40 = 0 END IF
 
      #匯差= (原幣未沖金額*重估匯率)-本幣未沖金額 
      LET l_net = (sr.amt1 * sr.azj07) - sr.nmh40 
      IF cl_null(l_net) THEN LET l_net = 0 END IF
      CALL cl_digcut(l_net,g_azi04) RETURNING l_net
 
      #本幣未沖金額=上月未沖金額+匯差
      LET l_amt = sr.nmh40 + l_net 

      #產生異動記錄檔
      IF l_net != 0 THEN 
         INSERT INTO oox_file(oox00,oox01,oox02,oox03v,oox03,oox04,
                               oox05,oox06,oox07,oox08,oox09,oox10, #No.MOD-470041
                               oox11,                       #No.FUN-D70002   Add
                               ooxlegal,                            #FUN-980011 add 
                               ooxacti,ooxuser,ooxoriu,ooxorig,     #FUN-D40107 add
                               ooxgrup,ooxmodu,ooxdate,ooxcrat)     #FUN-D40107 add
                       VALUES('NR',g_yy,g_mm,l_flag,sr.nmh01,0,
                              sr.nmh03,sr.nmh39,sr.azj07,sr.nmh40,
                              l_amt,l_net,
                              sr.amt1,                      #No.FUN-D70002   Add
                              g_legal,          #FUN-980011 add 
                              g_ooxacti,g_ooxuser,g_ooxoriu,g_ooxorig,  #FUN-D40107 add
                              g_ooxgrup,g_ooxmodu,g_ooxdate,g_ooxcrat)  #FUN-D40107 add   
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins oox',STATUS,1)   #No.FUN-660146
            CALL cl_err3("ins","oox_file",sr.nmh01,"NR",STATUS,"","ins oox",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH 
         END IF
      END IF
      #更新未沖金額
      UPDATE nmh_file SET nmh39 = sr.azj07, nmh40 = l_amt
       WHERE nmh01 = sr.nmh01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd nmh',STATUS,1)  #No.FUN-660146
         CALL cl_err3("upd","nmh_file",sr.nmh01,"",STATUS,"","upd nmh",1)   #No.FUN-660146
         LET g_success='N' EXIT FOREACH  
      END IF
   END FOREACH
 
   #更新月底重評價年度月份
   UPDATE nmz_file SET nmz60 = g_yy, nmz61 = g_mm
    WHERE nmz00 = '0'
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd nmz60/61',STATUS,1)   #No.FUN-660146
      CALL cl_err3("upd","nmz_file","","",STATUS,"","upd nmz60/61",1)   #No.FUN-660146
      LET g_success='N'  
   END IF
END FUNCTION
