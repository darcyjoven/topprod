# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gapp600.4gl
# Descriptions...: 應付帳款月底重評價作業
# Date & Author..: 02/03/14 By Danny
# Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-530672 05/03/30 By Danny
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No:BUG-580313 05/08/26 By Carrier 取消MOD-530672的修改
# Modify.........: No.FUN-570157 06/03/06 By saki 批次背景執行
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680027 06/08/29 By cl      多帳期處理
# Modify.........: No.FUN-680145 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6C0151 06/12/25 By jamie 執行時出現axr-408 的訊息之後,按OK,程式關不掉
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740307 07/04/25 By Rayven l_sql定義的長度太短,導致溢出,無法作業
# Modify.........: No.TQC-750042 07/05/10 By chenl 重估匯差應該按子帳期apc_file來做，而不是按apa_file來做。 
# Modify.........: No.FUN-7B0055 07/11/13 By Carrier 加入oox041 多帳期項次
# Modify.........: No.TQC-7B0096 07/11/15 By xufeng  默認的年度和期別不應該是自然年期,應該按照會計明細檔轉換
# Modify.........: No.FUN-920210 09/05/05 By sabrina 如果apz62='Y'，則預付(apa23)/暫付(apa=24)不做月底重評價
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980152 09/09/03 By sabrina 若g_apz.apz27='N'時，錯誤訊息會無法關掉 
# Modify.........: No:MOD-A30093 10/03/17 By sabrina 應先取位再減，否則易造成尾差
# Modify.........: No:MOD-A80080 10/08/10 By wujie   p600_pre1的sql中apa34-apa35>0的条件改为apa73<>0 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-C60127 12/06/14 By yinhy SQL中apc08-apc10改為apc08-apc10-apc14
# Modify.........: No:FUN-C80034 12/08/10 By yinhy 不應該僅僅是提示有衝賬資料，應該將這些單據列示出來
# Modify.........: No:MOD-C80215 12/08/28 By Polly 回寫oox08需加上匯差金額
# Modify.........: No:MOD-CB0151 12/11/16 By yinhy 默認期間取apz21、apz22，重估匯率為0不做重評價
# Modify.........: No:FUN-D40107 13/05/23 By zhangweib 新增狀態頁簽,INSERT時賦值
# Modify.........: No:MOD-C80215 13/07/01 By SunLM  调整MOD-C80125 INSERT INTO oox_file 写法,l_amt--> sr.apa73 
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
# Modify.........: No:FUN-D90016 13/09/04 By yangtt 原幣為0，本幣有值時，本幣未沖金額結轉至oox10
# Modify.........: No:MOD-150304 20/04/09 By lifang 修正FUN-D90016的改法，原币为0时，本币未冲金额应该取重新计算后的sr.apa73

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   	string  #No.FUN-580092 HCN
DEFINE g_yy,g_mm	LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE b_date,e_date    LIKE type_file.dat      #NO.FUN-690009 DATE 
DEFINE g_change_lang    LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(01)     #No.FUN-570157
       g_flag           LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)     #No.FUN-570157
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0097
      DEFINE   p_row,p_col   LIKE type_file.num5     #NO.FUN-690009 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570157 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)     #年度
   LET g_mm    = ARG_VAL(2)     #月份
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #No.FUN-570157 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF
 
   #-->No.FUN-570157 --start
   #OPEN WINDOW p600 AT p_row,p_col
   #    WITH FORM "gap/42f/gapp600" 
   #   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   #
   #CALL cl_ui_init()
 
   #CALL cl_opmsg('z')
   #IF g_apz.apz27 = 'N' THEN
   #   CALL cl_err('','axr-408',1) 
   #ELSE
   #   CALL p600()
   #END IF
   #CLOSE WINDOW p600
   #No.FUN-C80034  --Begin
   DROP TABLE apa_tmp_file      
   CREATE TEMP TABLE apa_tmp_file(
      apa13    LIKE apa_file.apa13);
      
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF 
   #No.FUN-C80034  --End	
#  CALL cl_used('gapp600',g_time,1) RETURNING g_time      #No.FUN-6A0097
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   WHILE TRUE
     IF g_bgjob = "N" THEN
        IF g_apz.apz27 = 'N' THEN
           CALL cl_err('','axr-408',1) 
           EXIT WHILE            #MOD-980152 add
        ELSE
           CALL p600()
           LET g_success='Y'          
           CALL cl_wait()
           BEGIN WORK
           IF cl_sure(15,20) THEN 
           	  CALL s_showmsg_init()  #FUN-C80034
              CALL p600_t()
              CALL s_showmsg()       #FUN-C80034
              IF g_success = 'Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING g_flag#批次作業正確結束
              ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING g_flag#批次作業失敗
              END IF
              IF g_flag THEN
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
        IF g_apz.apz27 = 'N' THEN
           CALL cl_err('','axr-408',1) 
           EXIT WHILE            #MOD-980152 add
        ELSE
           LET g_success='Y'          
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
     EXIT WHILE  #TQC-6C0151 add
   END WHILE
 # CALL cl_used('gapp600',g_time,2) RETURNING g_time        #No.FUN-6A0097
   #No.FUN-570157 --end--
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
END MAIN
 
FUNCTION p600()
   DEFINE p_row,p_col     LIKE type_file.num5     #NO.FUN-690009 SMALLINT     #No.FUN-570157
   DEFINE lc_cmd          LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(500)    #No.FUN-570157
 
   #No.FUN-570157 --start
   OPEN WINDOW p600 AT p_row,p_col WITH FORM "gap/42f/gapp600" 
      ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   #No.FUN-570157 --end--
 
  IF cl_null(g_yy) OR cl_null(g_mm) OR g_yy = 0 THEN   #No.FUN-D40107   Add
  #No.TQC-7B0096  --begin--mark----
  #LET g_yy = YEAR(g_today)
  #LET g_mm = MONTH(g_today)
  #No.TQC-7B0096  --end----mark----
  LET g_yy = g_apz.apz21   #MOD-CB0151
  LET g_mm = g_apz.apz22   #MOD-CB0151
     #No.TQC-7B0096  --begin--
      SELECT aznn02,aznn04 INTO g_yy,g_mm
        FROM aznn_file
       WHERE aznn00=g_apz.apz02b
         AND aznn01=g_today
     #No.TQC-7B0096  --end----
  END IF                                   #No.FUN-D40107   Add
   LET g_bgjob = 'N'                   #No.FUN-570157
 
   WHILE TRUE
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS  #No.FUN-570157
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#           CALL cl_dynamic_locale()   #No.FUN-570157
#           CALL cl_show_fld_cont()    #No.FUN-550037 hmf    No.FUN-570157
            LET g_change_lang = TRUE   #No.FUN-570157
            EXIT INPUT                 #No.FUN-570157
 
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
#No.TQC-720032 -- end --
#            IF cl_null(g_mm) OR g_mm < 1 OR g_mm > 13 THEN
#               NEXT FIELD g_mm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_yy*12+g_mm) < (g_apz.apz21*12+g_apz.apz22) THEN 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      #No.FUN-570157 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570157 ---end---
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p600     #No.FUN-570157
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM          #No.FUN-570157
         #EXIT WHILE           #No.FUN-570157
      END IF
 
      #No.FUN-570157 --start-- 
#     IF NOT cl_sure(15,20) THEN
#        RETURN 
#     END IF
#     CALL cl_wait()
#     BEGIN WORK
#     LET g_success = 'Y'
#     CALL p600_t()
#     IF g_success = 'Y' THEN
#        COMMIT WORK ELSE ROLLBACK WORK 
#     END IF
#     ERROR ''
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0 EXIT WHILE
#     END IF
 
      IF g_bgjob = "Y" THEN
        LET lc_cmd = NULL
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "gapp600"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('gapp600','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_yy CLIPPED,"'",
                        " '",g_mm CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('gapp600',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p600
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
     #No.FUN-570157 ---end---
   END WHILE
 
END FUNCTION
 
FUNCTION p600_t()
   #modify 030306 NO.A048
#  DEFINE l_sql         LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(1600)  #No.TQC-740307 mark
   DEFINE l_sql         STRING                  #No.TQC-740307
   DEFINE l_name        LIKE type_file.chr20    #NO.FUN-690009 VARCHAR(20)
   DEFINE yymm          LIKE azj_file.azj02     #NO.FUN-690009 VARCHAR(06)
   DEFINE amt1,amt2     LIKE oma_file.oma56t
   DEFINE l_cnt         LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_net,l_amt   LIKE oma_file.oma56       
   DEFINE l_net_apc     LIKE oma_file.oma56     #No.TQC-750042 各子帳期匯差  
   DEFINE l_net_tot     LIKE oma_file.oma56     #No.TQC-750042 各子帳期匯差之合  
   DEFINE l_net1        LIKE oma_file.oma56     #No.MOD-A30093 add
#  DEFINE l_trno        VARCHAR(10)
   DEFINE l_trno        LIKE npp_file.npp01     #NO.FUN-690009 VARCHAR(16)   #No.FUN-550030
   #add 030306 NO.A048
   DEFINE l_flag        LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
   DEFINE l_apa01       LIKE apa_file.apa01     #FUN-C80034
   DEFINE l_apa13       LIKE apa_file.apa13     #FUN-C80034
   DEFINE l_msg         STRING                  #FUN-C80034
   DEFINE sr            RECORD 
                        #add 030306 NO.A048
                        apa00   LIKE apa_file.apa00,
                        apa01   LIKE apa_file.apa01,
                        apa02   LIKE apa_file.apa02,
                        apa13   LIKE apa_file.apa13,
                        apa14   LIKE apa_file.apa14,
                        apa34   LIKE apa_file.apa34,
                        apa35   LIKE apa_file.apa35,
                        apa72   LIKE apa_file.apa72,
                        apa73   LIKE apa_file.apa73,
                        amt1    LIKE apa_file.apa34,
                        amt2    LIKE apa_file.apa35,
                        azj07   LIKE azj_file.azj07,
                        apc02   LIKE apc_file.apc02      #No.FUN-7B0055
                        END RECORD
   DEFINE l_apc         RECORD LIKE apc_file.*     #No.FUN-680027 
   DEFINE l_apc13_tot   LIKE apc_file.apc13        #No.FUN-680027
   DEFINE l_amt1        LIKE oma_file.oma56        #add by liumin 170415
   DEFINE l_amt2        LIKE oma_file.oma56   #add by dengsy170415
   DEFINE l_apa73       LIKE apa_file.apa73 #add by lixwz
   DEFINE l_oox10       LIKE oox_file.oox10   

   DELETE FROM apa_tmp_file     #FUN-C80034
 # SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17      #No.CHI-6A0004
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'AP',g_yy USING '&&&&',g_mm USING '&&'
   
 
   #檢查是否已拋轉總帳
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'AP' AND npp00 = 5 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有大於本月的異動記錄
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'AP' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-403',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有沖帳資料
   #modify 030306 NO.A048
   SELECT COUNT(*) INTO l_cnt FROM apa_file
    WHERE apa13 != g_aza.aza17
      AND apa41 = 'Y' AND apa42 = 'N'
      AND apa02 <= e_date
      AND (apa01 IN (SELECT apg04 FROM apf_file,apg_file 
                      WHERE apf01=apg01 AND apf00 = '33'
                        AND apf41 = 'Y'
                        AND apf02 > e_date) OR 
           apa01 IN (SELECT apv03 FROM apv_file,apa_file
                      WHERE apv01=apa01
                        AND apa41 = 'Y' 
                        AND apa02 > e_date) OR
           apa01 IN (SELECT aph04 FROM apf_file,aph_file 
                      WHERE aph01=apf01  
                        AND apf41 = 'Y'
                        AND apf02 > e_date) OR
           apa01 IN (SELECT oob06 FROM oob_file,ooa_file
                      WHERE oob01=ooa01 
                        AND ooaconf = 'Y' 
                        AND oob03 = '2' AND oob04 = '9'
                        AND ooa02 > e_date)) 
 
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      #No.FUN-C80034  --Begin
      #CALL cl_err('','anm-203',1) LET g_success = 'N' RETURN 
         LET g_sql = "SELECT apa01 FROM apa_file",
                     " WHERE apa13 != '",g_aza.aza17,"'",
                     "  AND apa41 = 'Y' AND apa42 = 'N'",
                     "  AND apa02 <= '",e_date,"'",
                     "  AND (apa01 IN (SELECT apg04 FROM apf_file,apg_file",
                     "                  WHERE apf01=apg01 AND apf00 = '33'",
                     "                    AND apf41 = 'Y'",
                     "                    AND apf02 > '", e_date,"'",") OR ",
                     "       apa01 IN (SELECT apv03 FROM apv_file,apa_file",
                     "                  WHERE apv01=apa01",
                     "                    AND apa41 = 'Y' ",
                     "                    AND apa02 > '",e_date,"'",") OR",
                     "       apa01 IN (SELECT aph04 FROM apf_file,aph_file ",
                     "                  WHERE aph01=apf01",
                     "                    AND apf41 = 'Y'",
                     "                    AND apf02 > '",e_date,"'",") OR",
                     "       apa01 IN (SELECT oob06 FROM oob_file,ooa_file",
                     "                  WHERE oob01=ooa01 ",
                     "                    AND ooaconf = 'Y' ",
                     "                    AND oob03 = '2' AND oob04 = '9'",
                     "                    AND ooa02 > '",e_date,"'","))"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE p600_pre2 FROM g_sql
       DECLARE p600_cus2 CURSOR WITH HOLD FOR p600_pre2
       FOREACH p600_cus2 INTO l_apa01
       	  IF STATUS THEN
            CALL s_errmsg('','','foreach:',STATUS,1)
            LET g_success = 'N' 
            EXIT FOREACH
          END IF  
          IF NOT cl_null(l_apa01) THEN
             LET l_msg = l_msg,'|',l_apa01
          END IF
       END FOREACH      
       IF NOT cl_null(l_msg) THEN 
         # CALL s_errmsg('apa01',l_msg,'','anm-203',1)
         # LET g_success = 'N'
       END IF
       #No.FUN-C80034  --End
   END IF
   #刪除分錄底稿
   DELETE FROM npp_file 
    WHERE nppsys = 'AP' AND npp00 = 5 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
      #No.FUN-660071  --Begin
      #CALL cl_err('del npp',STATUS,1)
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1) #No.FUN-660071
      LET g_success='N' RETURN
      #No.FUN-660071  --End  
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'AP' AND npq00 = 5 AND npq011 = 1
      AND npq01 = l_trno 
   IF STATUS THEN
      #No.FUN-660071  --Begin
      #CALL cl_err('del npq',STATUS,1) 
      CALL cl_err3("del","npq_file",l_trno,"",STATUS,"","del npq",1) #No.FUN-660071
      LET g_success='N' RETURN
      #No.FUN-660071  --End  
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
      WHERE oox00 = 'AP' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p600_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p600_del_curs1',STATUS,1) LET g_success='N' RETURN
      END IF
      #No.FUN-7B0055  --Begin
      #UPDATE apa_file SET apa72 = l_oox.oox06, apa73 = l_oox.oox08
      # WHERE apa01 = l_oox.oox03
      UPDATE apc_file SET apc07 = l_oox.oox06, apc13 = l_oox.oox08
       WHERE apc01 = l_oox.oox03
         AND apc02 = l_oox.oox041
      #No.FUN-7B0055  --End
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         #No.FUN-660071  --Begin
         #CALL cl_err('upd apa',STATUS,1)
         #No.FUN-7B0055  --Begin
         #CALL cl_err3("upd","apa_file",l_oox.oox03,"",STATUS,"","upd apa",1) #No.FUN-660071
         CALL cl_err3("upd","apc_file",l_oox.oox03,l_oox.oox041,STATUS,"","upd apc",1)
         #No.FUN-7B0055  --End
         LET g_success='N' RETURN
         #No.FUN-660071  --End  
      END IF
      DELETE FROM oox_file WHERE oox03=l_oox.oox03 AND oox04=l_oox.oox04 AND oox02=l_oox.oox02 
        AND oox01=l_oox.oox01 AND oox00=l_oox.oox00 AND oox041 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         #No.FUN-660071  --Begin
         CALL cl_err('del oox',STATUS,1)
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox04,STATUS,"","del oox",1) #No.FUN-660071
         LET g_success='N' RETURN
         #No.FUN-660071  --End  
      END IF
   END FOREACH
 
   #add 030306 NO.A048
   LET l_sql ="SELECT SUM(apv04f),SUM(apv04) ",
              " FROM apv_file,apa_file",
              " WHERE apv03= ?  AND apv01=apa01 AND apa41='Y' ",
              "   AND apv05= ? ",     #No.FUN-7B0055
              "   AND apa02 > '",e_date,"' "
 
   PREPARE p600_papv FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare apv:',SQLCA.sqlcode,1)
      CALL cl_batch_bg_javamail("N")     #No.FUN-570157
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p600_capv CURSOR FOR p600_papv
 
   LET l_sql = "SELECT SUM(aph05f),SUM(aph05) ",
               "  FROM aph_file,apf_file",
               " WHERE aph04 = ? AND aph01 = apf01 AND  apf41 = 'Y' ",
               "   AND aph17 = ? ",    #No.FUN-7B0055
               "   AND apf02 > '",e_date,"' "
   PREPARE p600_paph FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aph:',SQLCA.sqlcode,1)
      CALL cl_batch_bg_javamail("N")     #No.FUN-570157
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p600_caph CURSOR FOR p600_paph
 
   LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",
               "  FROM oob_file,ooa_file",
               " WHERE oob06 = ? AND oob01 = ooa01 AND  ooaconf = 'Y' ",
               "   AND oob03 = '2' AND oob04 = '9' ",
               "   AND oob19 = ? ",    #No.FUN-7B0055
               "   AND ooa02 > '",e_date,"' "
   PREPARE p600_poob FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare oob:',SQLCA.sqlcode,1)
      CALL cl_batch_bg_javamail("N")     #No.FUN-570157
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p600_coob CURSOR FOR p600_poob
 
   LET l_sql ="SELECT SUM(apg05f),SUM(apg05) ",
               " FROM apf_file,apg_file",
               " WHERE apf01=apg01 ",
               "   AND apf41='Y' ", 
               "   AND apf02 > '",e_date,"' ",
               "   AND apg04 = ? ",
               "   AND apg06 = ? "   #No.FUN-7B0055
   PREPARE p600_papg FROM l_sql
   IF STATUS THEN 
      CALL cl_err('p600_papg',STATUS,1) LET g_success='N' RETURN
   END IF
   DECLARE p600_capg CURSOR FOR p600_papg
   #zhouxm170810 add start
   LET l_sql ="SELECT SUM(api05f),SUM(api05) ",
               " FROM apa_file,api_file",
               " WHERE apa01=api01 ",
               "   AND apa63='1' ", 
               "   AND apa02 > '",e_date,"' ",
               "   AND api26 = ? ",
               "   AND api40 = ? "   
	       #" AND (api40=? OR (api02 ='2' and api40<>?)) "  #add by lixwz201208 api40 不是1的情况
   PREPARE p600_papi FROM l_sql
   IF STATUS THEN 
      CALL cl_err('p600_papg',STATUS,1) LET g_success='N' RETURN
   END IF
   DECLARE p600_capi CURSOR FOR p600_papi
   #zhouxm170810 add end 
 
   #modify 030306 NO.A048
  #LET l_sql="SELECT apa00,apa01,apa02,apa13,apa14,apa34,apa35,apa72,apa73,",  #No.FUN-7B0055
  #          "       apa34f-apa35f,apa34-apa35,azj07 ",                        #No.FUN-7B0055
  #          "  FROM apa_file LEFT OUTER JOIN azj_file ON apa_file.apa13=azj_file.azj01 ",                                #No.FUN-7B0055
   LET l_sql="SELECT apa00,apa01,apa02,apa13,apc06,apc09,apc11,apc07,apc13,",  #No.FUN-7B0055
             #"       apc08-apc10,apc09-apc11,azj07,apc02 ",                    #No.FUN-7B0055   #No.MOD-C60127 mark
             "       apc08-apc10-apc14,apc09-apc11-apc15,azj07,apc02 ",        #No.MOD-C60127
             "  FROM apa_file,OUTER azj_file,apc_file ",                       #No.FUN-7B0055
             " WHERE apa13 != '",g_aza.aza17,"'",
             "  AND azj_file.azj01=apa_file.apa13 AND azj_file.azj02='",yymm,"'",
             "   AND apa41='Y' AND apa42='N' ",
             "   AND apa02 <= '",e_date,"'",
             "   AND apa01 = apc01 ",                                          #No.FUN-7B0055
              #No.MOD-580313  --begin 
              #"   AND apa08 != 'UNAP' ",         #No.MOD-530672
              #No.MOD-580313  --end 
#            "   AND ( (apa34-apa35) >0 OR ",
             "   AND ( apa73<>0 OR ",    #No.MOD-A80080
             "        apa01 IN (SELECT apg04 FROM apf_file,apg_file ",
             "                   WHERE apf01=apg01 AND apf00='33' ",
             "                     AND apf41 = 'Y' ", 
             "                     AND apf02 >'",e_date,"' )  OR ",
             "        apa01 IN (SELECT apv03 FROM apv_file,apa_file ",
             "                   WHERE apv01=apa01  ",
             "                     AND apa41 = 'Y' ", 
             #"                     AND apa02 >'",e_date,"' )  OR ", #zhouxm170810 mark
             "                     AND apa02 >'",b_date,"' )  OR ", #zhouxm170810 add 
             "        apa01 IN (SELECT aph04 FROM apf_file,aph_file ",
             "                   WHERE aph01=apf01  ",
             "                     AND apf41 = 'Y' ", 
             "                     AND apf02 >'",e_date,"' ) OR ",
             "  apa01 in (select apg04 from apg_file,apf_file where apg01=apf01 and apf41='Y' ", #add by dengsy170415
             #"and   apf02 >'",e_date,"' ) or ",  #add by dengsy170415
             "and   apf02 >='",b_date,"' ) or ",  #zhouxm170802 add 
             "        apa01 IN (SELECT oob06 FROM oob_file,ooa_file ",
             "                   WHERE oob01=ooa01  ",
             "                     AND ooaconf = 'Y' ", 
             "                     AND oob03 = '2' AND oob04 = '9' ",
             "                     AND ooa02 >'",e_date,"' ) ) "
            #" ORDER BY apa01,apc02 "     #No.FUN-7B0055   #FUN-920210 mark
   
  #FUN-920210---add---start---
   IF g_apz.apz62 = 'Y' THEN    #預付/暫付不做月底重評價
      LET l_sql = l_sql CLIPPED,
                  " AND apa00 != '23' AND apa00 != '24' ",
                  " ORDER BY apa01,apc02 "
   ELSE                         #預付/暫付做月底重評價
      LET l_sql = l_sql CLIPPED,
                  " ORDER BY apa01,apc02 "
   END IF
  #FUN-920210---add---end---
 
   PREPARE p600_pre1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('p600_pre1',STATUS,1)
      CALL cl_batch_bg_javamail("N")      #No.FUN-570157
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p600_curs1 CURSOR FOR p600_pre1
   FOREACH p600_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p600_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      IF cl_null(sr.azj07) OR sr.azj07 = 0 THEN   #MOD-CB0151 add azj07=0 
         #No.FUN-C80034  --Begin
         #CALL cl_err(sr.apa13,'aoo-108',1) LET g_success='N' EXIT FOREACH
         LET g_success = 'N'
         IF NOT cl_null(sr.apa13) THEN
            INSERT INTO apa_tmp_file VALUES(sr.apa13)
            IF SQLCA.SQLCODE THEN 
               CALL cl_err3("ins","apa_tmp_file","","",STATUS,"","l_order",1) 
               EXIT FOREACH
            END IF         
         END IF
         #No.FUN-C80034  --End
      END IF
      LET l_amt2=0  #add by dengsy170415 
      #modify 030306 NO.A048
      #未付金額需將大於此月已付金額加回
      IF sr.apa00 MATCHES '1*' THEN
         LET l_flag='1'                    #bug no:A061
         OPEN p600_capg USING sr.apa01,sr.apc02   #No.FUN-7B0055
         IF STATUS THEN
            CALL cl_err('p600_capg',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF
        # FETCH p600_capg INTO amt1,amt2#mark muping171221
         IF cl_null(amt1) THEN LET amt1 = 0 END IF
         IF cl_null(amt2) THEN LET amt2 = 0 END IF
         LET sr.amt1 = sr.amt1 + amt1
      ELSE
         LET l_flag='2'                    #bug no:A061
         OPEN p600_capv USING sr.apa01,sr.apc02   #No.FUN-7B0055
         IF STATUS THEN
            CALL cl_err('p600_capv',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF
         FETCH p600_capv INTO amt1,amt2
         IF cl_null(amt1) THEN LET amt1 = 0 END IF
         IF cl_null(amt2) THEN LET amt2 = 0 END IF
         LET sr.amt1 = sr.amt1 + amt1
         LET l_amt2=amt2  #add by dengsy170415
 
         OPEN p600_caph USING sr.apa01,sr.apc02   #No.FUN-7B0055
         IF STATUS THEN
            CALL cl_err('p600_caph',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF
         FETCH p600_caph INTO amt1,amt2
         IF cl_null(amt1) THEN LET amt1 = 0 END IF
         IF cl_null(amt2) THEN LET amt2 = 0 END IF
         LET sr.amt1 = sr.amt1 + amt1
         LET l_amt2=l_amt2+ amt2  #zhouxm170802 add 
         
         OPEN p600_coob USING sr.apa01,sr.apc02   #No.FUN-7B0055
         IF STATUS THEN
            CALL cl_err('p600_coob',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF
         FETCH p600_coob INTO amt1,amt2
         IF cl_null(amt1) THEN LET amt1 = 0 END IF
         IF cl_null(amt2) THEN LET amt2 = 0 END IF
         LET sr.amt1 = sr.amt1 + amt1

         #zhouxm170810 add start
         OPEN p600_capi USING sr.apa01,sr.apc02   #No.FUN-7B0055
         IF STATUS THEN
            CALL cl_err('p600_caph',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF
         FETCH p600_capi INTO amt1,amt2
         IF cl_null(amt1) THEN LET amt1 = 0 END IF
         IF cl_null(amt2) THEN LET amt2 = 0 END IF
         LET sr.amt1 = sr.amt1 + amt1
         #LET l_amt2=l_amt2+ amt2  
         #zhouxm170810 add end 
      END IF
 
      #當月立帳資料,賦予重估匯率
      IF sr.apa02 >= b_date AND sr.apa02 <= e_date THEN
         LET sr.apa72 = sr.apa14
      END IF
      #取得未付金額
      CALL s_g_np1('2',l_flag,sr.apa01,'',sr.apc02) RETURNING sr.apa73  #No.FUN-7B0055
      #add by lixwz201208 s---
      IF sr.apa00 ='16' THEN
         SELECT sum(api05) INTO l_apa73 from api_file,apa_file WHERE
          apa01 = api01 and apa02 <= e_date and  api26 = sr.apa01
	 SELECT sum(oox10) into l_oox10 from oox_file where oox03 =sr.apa01

         if sr.apa34-l_apa73-l_oox10 < sr.apa73 THEN LET sr.apa73=sr.apa34-l_apa73-l_oox10 END IF
      END IF
      #add by lixwz201208 e---
      IF cl_null(sr.apa73) THEN LET sr.apa73 = 0 END IF
      #LET sr.apa73 = sr.apa73 + amt2 #add by liumin 170415 加上后面月份已冲金额#mark muping171221
      LET sr.apa73 = sr.apa73 + l_amt2  #add by dengsy170415 #直接冲账
 
     #No.FUN-7B0055  --Begin
     ##No.TQC-750042--begin--
     ##更改子帳期未付金額
     
     ##原先做法: 匯差= 本幣未付金額 - (原幣未付金額*重估匯率)
    #MOD-A30093---modify---start---
    #LET l_net = sr.apa73 - (sr.amt1 * sr.azj07) 
     #FUN-D90016---add--str--
     #IF g_aza.aza26 = '2' AND sr.apa73 !=0 AND sr.amt1 = 0 THEN#mark by dengsy170415
        #LET l_net = sr.amt2          #MOD-150304 mark
     #   LET l_net = sr.apa73          #MOD-150304 add #mark by dengsy170415
     #ELSE  #mark by dengsy170415

     #--add by lifang 200409 begin#
     IF g_aza.aza26 = '2' AND sr.apa73 !=0 AND sr.amt1 = 0 THEN
        #LET l_net = sr.amt2          #MOD-150304 mark
        LET l_net = sr.apa73          #MOD-150304 add
     ELSE
     #--add by lifang 200409 end#
     #FUN-D90016---add--end--
        LET l_net1 = sr.amt1 * sr.azj07            
        CALL cl_digcut(l_net1,g_azi04) RETURNING l_net1
        LET l_net = sr.apa73 - l_net1
    #MOD-A30093---modify---end---
     END IF   #FUN-D90016 add  #mark by dengsy170415   #remark by lifang 200409
     IF cl_null(l_net) THEN LET l_net = 0 END IF
     CALL cl_digcut(l_net,g_azi04) RETURNING l_net             
     ##現在做法: 匯差= 各子帳期本幣未付金額 - (各子帳期原幣未付金額*重估匯率)
     # SELECT SUM(apc13) INTO l_apc13_tot FROM apc_file WHERE apc01=sr.apa01
     # IF l_apc13_tot != 0 THEN  
     #    LET l_net_apc = 0
     #    LET l_net = 0
     #    DECLARE p600_apc_cs CURSOR FOR 
     #        SELECT * FROM apc_file WHERE apc01=sr.apa01
     #    FOREACH p600_apc_cs INTO l_apc.*
     #        LET l_net_apc = l_apc.apc13-((l_apc.apc08-l_apc.apc10)* sr.azj07)   #該子帳期匯差
     #        LET l_net = l_net + l_net_apc                                       #統計整筆資料的子帳期匯差之和
     #        LET l_apc.apc13 = l_apc.apc13 - l_net_apc
     #        LET l_apc.apc07 = sr.azj07
     #        UPDATE apc_file SET apc13 = l_apc.apc13,
     #                            apc07 = l_apc.apc07
     #         WHERE apc01=l_apc.apc01 AND apc02=l_apc.apc02
     #        IF SQLCA.sqlcode THEN
     #           CALL cl_err3("upd","apc_file",l_apc.apc01,l_apc.apc02,SQLCA.sqlcode,"","upd apc_file",1)
     #           LET g_success='N' EXIT FOREACH
     #        END IF
     #    END FOREACH
     #    CALL cl_digcut(l_net,g_azi04) RETURNING l_net
     #    #求得此筆帳款的本幣未付金額,即做過匯差后,子帳期本幣未付金額的合計.
     #    SELECT SUM(apc13) INTO l_amt FROM apc_file WHERE apc01=sr.apa01
     #    IF SQLCA.sqlcode THEN
     #       LET l_net = 0
     #       LET l_amt = sr.apa73 - l_net 
     #       CALL cl_err('sum apc13:','gap-002',1)
     #    END IF
     # ELSE 
     #   LET l_net = 0
     #   LET l_amt = sr.apa73 - l_net 
     # END IF   
     ##No.TQC-750042--end--
 
     ## 本幣未付金額=上月未付金額-匯差
     
     LET l_amt = sr.apa73 - l_net         #No.TQC-750042 mark
     #LET l_amt1 = sr.apa73 - l_net - amt2  #add by liumin 170415 减去后面月份已冲的金额#mark muping171221
     #No.FUN-7B0055  --End
 
      #add 030306 NO.A048
      IF sr.apa00 MATCHES '2*' THEN
         LET l_net = l_net * -1
      END IF
      
      #No.yinhy130729  --Beign
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.apa13
      LET sr.apa72 = cl_digcut(sr.apa72,t_azi07)
      LET sr.azj07 = cl_digcut(sr.azj07,t_azi07)
      LET sr.apa73 = cl_digcut(sr.apa73,g_azi04)
      LET l_amt = cl_digcut(l_amt,g_azi04)
      LET l_net = cl_digcut(l_net,g_azi04)
      LET l_amt = cl_digcut(l_amt,g_azi04) #add by liumin 170415
      #No.yinhy130729  --End
 
      #產生異動記錄檔
      #IF l_net != 0 THEN #mark by dengsy170415
      IF l_net != 0 OR sr.amt1=0 THEN    #add by dengsy170415 
         #modify 030306 NO.A048
         #-------------------------------MOD-C80215-------------------------(S)
         #--MOD-C80215--mark
         #INSERT INTO oox_file(oox00,oox01,oox02,oox03v,oox03,oox04, #No.MOD-470041
         #                    oox05,oox06,oox07,oox08,oox09,oox10,oox041,   #No.FUN-7B0055
         #                    ooxlegal)  #FUN-980011 add
         #             VALUES('AP',g_yy,g_mm,sr.apa00,sr.apa01,0,
         #                    sr.apa13,sr.apa72,sr.azj07,sr.apa73,
         #                    l_amt,l_net,sr.apc02,                         #No.FUN-7B0055
         #                    g_legal)    #FUN-980011 add
         #--MOD-C80215--mark
         #zhouxm170802 add start 
         IF sr.apa73=0 AND sr.amt1=0 THEN 
            CONTINUE FOREACH 
         END IF  
         #zhouxm170802 add end 
          INSERT INTO oox_file(oox00,oox01,oox02,oox03v,oox03,
                               oox04,oox05,oox06,oox07,oox08,
                               oox09,oox10,oox041,ooxlegal,
                               oox11,                             #No.FUN-D70002   Add
                               ooxacti,ooxuser,ooxgrup,ooxmodu,   #No.FUN-D40107   Add
                               ooxdate,ooxcrat,ooxoriu,ooxorig    #No.FUN-D40107   Add
                               )
                       VALUES('AP',g_yy,g_mm,sr.apa00,sr.apa01,
                              0,sr.apa13,sr.apa72,sr.azj07,sr.apa73,           #MOD-C80215 sr.apa73 mod l_amt #MOD-C80215 sunlm sr.apa73
                              l_amt,l_net,sr.apc02,g_legal,
                              sr.amt1,                            #No.FUN-D70002   Add
                              'Y',g_user ,g_grup,"",              #No.FUN-D40107   Add
                              "" ,g_today,g_user,g_grup           #No.FUN-D40107   Add
                              )
         #-------------------------------MOD-C80215-------------------------(E)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #No.FUN-660071  --Begin
            #CALL cl_err('ins oox',STATUS,1)  #No.FUN-660071
            CALL cl_err3("ins","oox_file",sr.apa01,0,STATUS,"","ins oox",1) #No.FUN-660071
            LET g_success = 'N' EXIT FOREACH
            #No.FUN-660071  --End  
         END IF
      END IF
      #更新未付金額
      #No.FUN-7B0055  --Begin
      UPDATE apc_file SET apc13 = l_amt,  #mark by liumin 170415#还原 muping171221
      #UPDATE apc_file SET apc13 = l_amt1,  #add by liumin 170415#mark muping171221
                          apc07 = sr.azj07
       WHERE apc01= sr.apa01 AND apc02 = sr.apc02
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","apc_file",sr.apa01,sr.apc02,STATUS,"","upd apc",1)
         LET g_success='N' EXIT FOREACH
      END IF
      LET l_amt = 0 
      SELECT SUM(apc13) INTO l_amt FROM apc_file
       WHERE apc01=sr.apa01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","apc_file",sr.apa01,"",STATUS,"","sel apc",1)
         LET g_success ='N' EXIT FOREACH
      END IF
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      #No.FUN-7B0055  --End  
    #No.TQC-750042--begin-- 
    #原先由apa更新后再對apc更新，現改為apc更新完成后再更新apa
      UPDATE apa_file SET apa72 = sr.azj07, apa73 = l_amt
       WHERE apa01 = sr.apa01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         #No.FUN-660071  --Begin
         #CALL cl_err('upd apa',STATUS,1)
         CALL cl_err3("upd","apa_file",sr.apa01,"",STATUS,"","upd apa",1) #No.FUN-660071
         LET g_success='N' EXIT FOREACH
         #No.FUN-660071  --End  
    #此處對apc,即子帳期的處理已在此段上方做處理. 
    ##No.FUN-680027--begin-- add
    # ELSE
    #    SELECT SUM(apc13) INTO l_apc13_tot FROM apc_file WHERE apc01=sr.apa01
    #    IF NOT cl_null(l_apc13_tot) THEN  
    #       DECLARE p600_apc_cs CURSOR FOR 
    #           SELECT * FROM apc_file WHERE apc01=sr.apa01
    #       FOREACH p600_apc_cs INTO l_apc.*
    #           LET l_apc.apc13 = l_apc.apc13-(l_apc.apc13/l_apc13_tot)*l_net 
    #           LET l_apc.apc07 = sr.azj07
    #           UPDATE apc_file SET apc13 = l_apc.apc13,
    #                               apc07 = l_apc.apc07
    #            WHERE apc01=l_apc.apc01 AND apc02=l_apc.apc02
    #           IF SQLCA.sqlcode THEN
    #              CALL cl_err3("upd","apc_file",l_apc.apc01,l_apc.apc02,SQLCA.sqlcode,"","upd apc_file",1)
    #              LET g_success='N' EXIT FOREACH
    #           END IF
    #       END FOREACH
    #    END IF   
    ##No.FUN-680027--end-- add
      END IF
    #No.TQC-750042--end--
   END FOREACH
   #No.FUN-C80034  --Begin
   LET l_msg = ''
   DECLARE apa_tmpcs CURSOR FOR 
        SELECT DISTINCT apa13 FROM apa_tmp_file
        ORDER BY apa13
   FOREACH apa_tmpcs INTO l_apa13
       IF STATUS THEN
          CALL cl_err('order:',STATUS,1) EXIT FOREACH
       END IF
       IF NOT cl_null(l_apa13) THEN      
          LET l_msg = l_msg,'|',l_apa13
       END IF       
   END FOREACH   
   IF NOT cl_null(l_msg) THEN
      CALL s_errmsg('apa13',l_msg,'','aoo-108',1)
   END IF     
   #No.FUN-C80034  --End
   #更新月底重評價年度月份
   UPDATE apz_file SET apz21 = g_yy, apz22 = g_mm
    WHERE apz00 = '0'
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      #No.FUN-660071  --Begin
      CALL cl_err('upd apz21/22',STATUS,1)
      CALL cl_err3("upd","aza_file",g_yy,g_mm,STATUS,"","upd apz21/22",1) #No.FUN-660071
      LET g_success='N' 
      #No.FUN-660071  --End  
   END IF
END FUNCTION

