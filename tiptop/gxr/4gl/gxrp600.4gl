# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gxrp600.4gl
# Descriptions...: 應收帳款月底重評價作業
# Date & Author..: 02/03/04 By Danny
# Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-550071 05/05/28 By vivien 單據編號格式放大 
# Modify.........: No.MOD-580076 05/08/11 By Smapmin 不可用客戶檔occ40來決定AR的幣種
# Modify.........: No.MOD-580180 05/08/19 By Smapmin 對occ40重新定義,勾選時表示要月底重評價
# Modify.........: No.FUN-570123 06/03/02 By saki 批次背景執行
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680022 06/08/23 By cl   多帳期處理
# Modify.........: No.FUN-680145 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A099 06/10/25 By king l_time轉g_time
# Modify.........: No.MOD-720106 07/03/01 By Smapmin 預設年度期別應依照參數設定
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740413 07/04/29 By chenl   擴大l_sql，保証字符串完整。
# Modify.........: No.TQC-750042 07/05/10 By chenl   應該按子帳期omc_file來做調整匯差的處理
# Modify.........: No.TQC-7B0058 07/11/12 By wujie   本幣重估匯率沒有正確截位，回寫本幣未衝金額位數也有問題
#                                                    檢查調匯月份以后的收款記錄ooa_file，但應該不考慮以后月份的直接收款產生的ooa_file
# Modify.........: No.FUN-7B0055 07/11/13 By Carrier 加入oox041 多帳期項次
# Modify.........: No.FUN-7B0090 07/11/16 By Carrier sr.oma00沒有值,無法做判斷 & 還原時沒有更新oma_file資料
# Modify.........: No.FUN-920210 09/05/04 By sabrina 當g_ooz.ooz66 = 'Y'時，預收(oma00=23)/暫收(oma00=24)不做月底重評價
# Modify.........: No.FUN-980011 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980152 09/09/03 By sabrina 判斷是否可以執行gxrp600
# Modify.........: No:MOD-A30093 10/03/17 By sabrina 應先取位再減，否則易造成尾差
# Modify.........: No:MOD-A20112 10/02/26 By wujie   应收冲至单身项次时增加原币冲完但是本币还没冲完的情况
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-B60086 11/06/10 By wujie 考虑本币未冲金额不为0的情况也要抓
# Modify.........: No:FUN-C80034 12/08/10 By yinhy 不應該僅僅是提示有衝賬資料，應該將這些單據列示出來
# Modify.........: No:MOD-CB0150 12/11/16 By yinhy 重評價匯率為0時不需要做重評價
# Modify.........: No:MOD-CB0263 12/11/28 By yinhy SQL中omc08-omc10应再減掉omc14
# Modify.........: No:FUN-D40107 13/05/23 By zhangweib 新增狀態頁簽,INSERT時賦值
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
# Modify.........: No:FUN-D90016 13/09/04 By yangtt 原幣為0，本幣有值時，本幣未沖金額結轉至oox10
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   	string  #No.FUN-580092 HCN 
DEFINE g_yy,g_mm	LIKE oox_file.oox01     #NO.FUN-680145 SMALLINT
DEFINE g_tabname        STRING  #No.FUN-660146
DEFINE g_key2           STRING  #No.FUN-660146
DEFINE b_date,e_date    LIKE type_file.dat,     #NO.FUN-680145 DATE 
       g_flag           LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)    #No.FUN-570123
       g_change_lang    LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)    #No.FUN-570123
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy     = ARG_VAL(1)
   LET g_mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570123 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
   #No.FUN-C80034  --Begin
   DROP TABLE oma_tmp_file      
   CREATE TEMP TABLE oma_tmp_file(
      oma23    LIKE oma_file.oma23);
      
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF 
   #No.FUN-C80034  --End	
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    

   WHILE TRUE
      IF g_bgjob = "N" THEN
        #MOD-980152---add---start---
         IF g_ooz.ooz07 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE
         ELSE
        #MOD-980152---add---end---
            CALL p600_tm()
            IF cl_sure(18,20) THEN
               LET g_success = 'Y'
               BEGIN WORK
               CALL s_showmsg_init()  #FUN-C80034
               CALL p600_t()
               CALL s_showmsg()       #FUN-C80034
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
                  CLOSE WINDOW p600_w
                  EXIT WHILE 
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         END IF        #MOD-980152 add
      ELSE
        #MOD-980152---add---start---
         IF g_ooz.ooz07 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE
         ELSE
        #MOD-980152---add---end---
            LET g_success = 'Y'
            BEGIN WORK
            CALL p600_t()
            IF g_success = "Y" THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
         END IF           #MOD-980152 add
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#  CALL cl_opmsg('z')
#  IF g_ooz.ooz07 = 'N' THEN
#     CALL cl_err('','axr-408',1)
#  ELSE
#     CALL p600()
#  END IF
#  CLOSE WINDOW p600
#->No.FUN-570123 ---end---

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p600_tm()                             #No.FUN-570123  更名
   DEFINE   lc_cmd        LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(500)  #No.FUN-570123
   DEFINE   p_row,p_col   LIKE type_file.num5     #NO.FUN-680145 SMALLINT   #No.FUN-570123
 
   #-----MOD-720106---------
   #LET   g_yy = YEAR(g_today)   
   #LET   g_mm = MONTH(g_today)
   IF cl_null(g_yy) OR cl_null(g_mm) OR g_yy = 0 THEN   #No.FUN-D40107   ADd
   LET g_yy = g_ooz.ooz05
   LET g_mm = g_ooz.ooz06
   #-----END MOD-720106-----
   END IF   #No.FN-D40107  Add
 
   #No.FUN-570123 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p600_w AT p_row,p_col WITH FORM "gxr/42f/gxrp600"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   #No.FUN-570123 ---end---
 
   WHILE TRUE
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS   #No.FUN-570123
      
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#           CALL cl_dynamic_locale()                  #No.FUN-570123
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf  No.FUN-570123
            LET g_change_lang = TRUE                  #No.FUN-570123
            EXIT INPUT
 
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
## genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
#            IF cl_null(g_mm) OR g_mm < 1 OR g_mm > 13 THEN
#               NEXT FIELD g_mm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF 
            IF (g_yy*12+g_mm) < (g_ooz.ooz05*12+g_ooz.ooz06) THEN 
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
      #No.FUN-570123 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CLOSE WINDOW p600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
#     IF INT_FLAG THEN  
#        LET INT_FLAG = 0
#        EXIT WHILE
#     END IF
#     IF NOT cl_sure(15,20) THEN 
#        RETURN 
#     END IF
#     CALL cl_wait()
#     BEGIN WORK
#     LET g_success = 'Y'
#     CALL p600_t()
#     IF g_success = 'Y' THEN 
#        COMMIT WORK 
#     ELSE
#        ROLLBACK WORK 
#     END IF
#     ERROR ''
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gxrp600"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gxrp600','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED ,"'",
                         " '",g_mm CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gxrp600',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
      #No.FUN-570123 ---end---
   END WHILE
END FUNCTION
 
FUNCTION p600_t()
   #modify 030213 NO.A048
  #DEFINE l_sql         LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(1600)  #No.MOD-740413 mark
   DEFINE l_sql         STRING                  #No.MOD-740413
   DEFINE l_name        LIKE type_file.chr20    #NO.FUN-680145 VARCHAR(20)
   DEFINE yymm          LIKE azj_file.azj02     #NO.FUN-680145 VARCHAR(06)
   DEFINE l_oma56       LIKE oma_file.oma56
   DEFINE l_oma56t      LIKE oma_file.oma56t
   DEFINE amt1,amt2     LIKE oma_file.oma56t
   DEFINE l_omb         RECORD LIKE omb_file.*       
   DEFINE l_omb15       LIKE omb_file.omb15
   DEFINE l_omb16       LIKE omb_file.omb16
   DEFINE l_omb16t      LIKE omb_file.omb16t
   DEFINE l_cnt         LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_net,l_amt   LIKE oma_file.oma56       
   DEFINE l_net_omc     LIKE oma_file.oma56     #No.TQC-750042  
   DEFINE l_net1        LIKE oma_file.oma56     #No.MOD-A30093 add
   DEFINE l_trno        LIKE npp_file.npp01     #NO.FUN-680145 VARCHAR(16)     #No.FUN-550071
   DEFINE l_omc         RECORD LIKE omc_file.*  #No.FUN-680022 add 
   DEFINE l_omc13_tot   LIKE omc_file.omc13     #No.FUN-680022 add 
   DEFINE l_oma00       LIKE oma_file.oma00     #No.FUN-7B0090
   #modify 030213 NO.A048
   DEFINE l_flag        LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
   DEFINE l_oma01       LIKE oma_file.oma01     #FUN-C80034
   DEFINE l_oma23       LIKE oma_file.oma23     #FUN-C80034
   DEFINE l_msg         STRING                  #FUN-C80034
   DEFINE l_amt1        LIKE oma_file.oma56        #add by liumin 170415
   DEFINE sr            RECORD 
                        oma00   LIKE oma_file.oma00,
                        oma01   LIKE oma_file.oma01,
                        oma02   LIKE oma_file.oma02,
                        oma23   LIKE oma_file.oma23,
                        oma24   LIKE oma_file.oma24,
                        oma56t  LIKE oma_file.oma56t,
                        oma57   LIKE oma_file.oma57,
                        oma60   LIKE oma_file.oma60,
                        oma61   LIKE oma_file.oma61,
                        omb03   LIKE omb_file.omb03,
                        amt1    LIKE oma_file.oma54,
                        amt2    LIKE oma_file.oma56,
                        azj07   LIKE azj_file.azj07,
                        omc02   LIKE omc_file.omc02  #No.FUN-7B0055
                        END RECORD
                        
   DELETE FROM oma_tmp_file     #FUN-C80034
 
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'AR',g_yy USING '&&&&',g_mm USING '&&'
 
   #檢查是否已拋轉總帳
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'AR' AND npp00 = 4 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
   #檢查是否有大於本月的異動記錄
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'AR' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-403',1) LET g_success = 'N' RETURN 
   END IF
   #modify 030213 NO.A048
   #檢查是否有沖帳資料
   SELECT COUNT(*) INTO l_cnt FROM oma_file
    WHERE oma23 != g_aza.aza17
      AND (oma00 MATCHES '1*' OR oma00 MATCHES '2*')
      AND omaconf='Y' AND omavoid='N'
      AND oma02 <= e_date
      AND oma01 IN (SELECT oob06 FROM ooa_file,oob_file
                      WHERE ooa01=oob01 AND ooaconf !='X' AND ooa00 ='1'     #No.TQC-7B0058
                        AND ooa02 > e_date)
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      #No.FUN-C80034  --Begin
      #CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN
       LET l_msg = ''
       LET g_sql = "SELECT oma01  FROM oma_file",
                   " WHERE oma23 !=  '",g_aza.aza17,"'",
                   "  AND (oma00 MATCHES '1*' OR oma00 MATCHES '2*')",
                   "  AND omaconf='Y' AND omavoid='N'",
                   "  AND oma02 <= '",e_date,"'",
                   " AND oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                   "       WHERE ooa01=oob01 AND ooaconf !='X' AND ooa00 ='1' ",
                   "        AND ooa02 > '",e_date,"')"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE p600_pre2 FROM g_sql
       DECLARE p600_cus2 CURSOR WITH HOLD FOR p600_pre2
       FOREACH p600_cus2 INTO l_oma01
       	  IF STATUS THEN
            CALL s_errmsg('','','foreach:',STATUS,1)
            LET g_success = 'N' 
            EXIT FOREACH
          END IF  
          IF NOT cl_null(l_oma01) THEN
             LET l_msg = l_msg,'|',l_oma01
          END IF
       END FOREACH      
       #IF NOT cl_null(l_msg) THEN 
       #   CALL s_errmsg('oma01',l_msg,'','axr-402',1)
       #   LET g_success = 'N'
       #END IF
       #No.FUN-C80034  --End 
   END IF
   #刪除分錄底稿
   DELETE FROM npp_file 
    WHERE nppsys = 'AR' AND npp00 = 4 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
#     CALL cl_err('del npp',STATUS,1) #No.FUN-660146
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)   #No.FUN-660146
      LET g_success='N' RETURN  
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'AR' AND npq00 = 4 AND npq011 = 1
      AND npq01 = l_trno 
   IF STATUS THEN
#     CALL cl_err('del npq',STATUS,1)   #No.FUN-660146
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
      WHERE oox00 = 'AR' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p600_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p600_del_curs1',STATUS,1) LET g_success='N' RETURN 
      END IF
      #No.FUN-7B0090  --Begin
      SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01=l_oox.oox03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oma_file",l_oox.oox03,"",STATUS,"","sel oma",1)
         LET g_success ='N' EXIT FOREACH
      END IF
      #No.FUN-7B0090  --End  
      #modify 030213 NO.A048
      IF l_oma00 MATCHES '1*' THEN  #No.FUN-7B0090
         IF g_ooz.ooz62 = 'N' THEN
            #No.FUN-7B0055  --Begin
            #UPDATE oma_file SET oma60 = l_oox.oox06, oma61 = l_oox.oox08
            # WHERE oma01 = l_oox.oox03
            UPDATE omc_file SET omc07 = l_oox.oox06, omc13 = l_oox.oox08
             WHERE omc01 = l_oox.oox03 AND omc02 = l_oox.oox041
            LET g_tabname = "omc_file"  #No.FUN-660146
            #No.FUN-7B0055  --End  
         ELSE
            UPDATE omb_file SET omb36 = l_oox.oox06, omb37 = l_oox.oox08
             WHERE omb01 = l_oox.oox03 AND omb03 = l_oox.oox04
            LET g_tabname = "omb_file"  #No.FUN-660146
            LET g_key2=l_oox.oox04  #No.FUN-660146
         END IF
      ELSE
         #No.FUN-7B0055  --Begin
         #UPDATE oma_file SET oma60 = l_oox.oox06, oma61 = l_oox.oox08
         # WHERE oma01 = l_oox.oox03
         UPDATE omc_file SET omc07 = l_oox.oox06, omc13 = l_oox.oox08
          WHERE omc01 = l_oox.oox03 AND omc02 = l_oox.oox041
         LET g_tabname = "omc_file"  #No.FUN-660146
         #No.FUN-7B0055  --End  
      END IF
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd oma/omb',STATUS,1)  #No.FUN-660146
         CALL cl_err3("upd",g_tabname,l_oox.oox03,g_key2,STATUS,"","upd oma/omb",1)   #No.FUN-660146 
         LET g_success='N' RETURN
      END IF
      #modi by kitty bug NO:A053  因為報表有的是直接印單頭的欄位資料..
      IF l_oma00 MATCHES '1*' AND g_ooz.ooz62 = 'Y' THEN  #No.FUN-7B0090
         SELECT SUM(omb37) INTO l_amt FROM omb_file
          WHERE omb01=l_oox.oox03    #No.FUN-7B0090
         UPDATE oma_file SET oma60 = l_oox.oox06, oma61 = l_amt  #No.FUN-7B0090
          WHERE oma01 = l_oox.oox03  #No.FUN-7B0090
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd oma2',STATUS,1)   #No.FUN-660146
            CALL cl_err3("upd","oma_file",l_oox.oox03,"",SQLCA.sqlcode,"","upd oma2",1)   #No.FUN-660146  #No.FUN-7B0090
            LET g_success='N' EXIT FOREACH 
         END IF
      END IF
      #No.FUN-7B0090  --Begin
      IF g_ooz.ooz62 = 'N' THEN
         LET l_amt = 0 
         SELECT SUM(omc13) INTO l_amt FROM omc_file
          WHERE omc01 = l_oox.oox03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","omc_file",l_oox.oox03,"",STATUS,"","sel omc13",1)
            LET g_success = 'N' EXIT FOREACH
         END IF
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         UPDATE oma_file SET oma60 = l_oox.oox06, oma61 = l_amt
          WHERE oma01 = l_oox.oox03
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","oma_file",l_oox.oox03,"",STATUS,"","upd oma61",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH 
         END IF
      END IF
      #No.FUN-7B0090  --End  
      #--- end
      DELETE FROM oox_file WHERE oox00 = l_oox.oox00 AND oox01 = l_oox.oox01 AND oox02 = l_oox.oox02
      AND oox03 = l_oox.oox03 AND oox04 = l_oox.oox04 AND oox041 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del oox',STATUS,1)  #No.FUN-660146
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)   #No.FUN-660146
         LET g_success='N' RETURN 
      END IF
   END FOREACH
 
   IF g_ooz.ooz62 = 'N' THEN   #收款沖帳需沖到應收帳款項次
      #modify 030213 NO.A048
      #No.FUN-7B0055  --Begin
      #LET l_sql="SELECT oma00,oma01,oma02,oma23,oma24,oma56t,oma57,oma60,",
      #          "       oma61,0,oma54t-oma55,oma56t-oma57,azj07 ",
      #          "  FROM oma_file,OUTER azj_file,occ_file",
      LET l_sql="SELECT oma00,oma01,oma02,oma23,omc06,omc09, omc11,omc07,",
                #"       omc13,0,omc08 -omc10,omc09 -omc11,azj07,omc02 ",              #MOD-CB0263 mark
                "       omc13,0,omc08 -omc10-omc14,omc09 -omc11-omc15,azj07,omc02 ",   #MOD-CB0263
                "  FROM oma_file,OUTER azj_file,occ_file,omc_file",
      #No.FUN-7B0055  --End
                " WHERE oma23 != '",g_aza.aza17,"'",
                "   AND azj_file.azj01 = oma_file.oma23 AND azj_file.azj02='",yymm,"'",
                "   AND oma01 = omc01 ",   #No.FUN-7B0055
 #                "   AND occ01 = oma03 AND occ40 = 'N' ",  #本幣AR   #MOD-580076
 #                "   AND occ01 = oma03 ",  #本幣AR   #BUG-580076   #MOD-580180
                 "   AND occ01 = oma03 AND occ40 = 'Y' ",  #本幣AR   #MOD-580180
                "   AND oma00 like '1%' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",e_date,"'",
#                "   AND (oma54t>oma55 OR",
                "   AND (oma54t>oma55 OR omc13 <>0 OR",    #No.MOD-B60086 add omc13
                "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                "                   WHERE ooa01=oob01 AND ooaconf !='X' ",
                "                     AND ooa02 > '",e_date,"' ))" 
   ELSE 
      #modify 030213 NO.A048
      LET l_sql="SELECT oma00,oma01,oma02,oma23,oma24,omb16t,omb35,omb36,",
                "       omb37,omb03,omb14t-omb34,omb16t-omb35,azj07,0 ",  #No.FUN-7B0055
                "  FROM oma_file,omb_file,OUTER azj_file,occ_file",
                " WHERE oma01 = omb01 ",
                "   AND oma23 != '",g_aza.aza17,"'",
                "   AND azj_file.azj01 = oma_file.oma23 AND azj_file.azj02='",yymm,"'",
 #                "   AND occ01 = oma03 AND occ40 = 'N' ",  #本幣AR   #MOD-580076
 #                "   AND occ01 = oma03 ",  #本幣AR   #BUG-580076   #MOD-580180
                 "   AND occ01 = oma03 AND occ40 = 'Y' ",  #本幣AR   #MOD-580180
                "   AND oma00 like '1%' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",e_date,"'",
                "   AND (omb14t>omb34 OR",
                "   omb37 <>0 OR ",                  #No.MOD-B60086 add omb37 
#No.MOD-A20112 --begin                                                          
                "       (omb14t = omb34 AND omb16t>omb35) OR ",                 
#No.MOD-A20112 --end
                "        omb01 IN (SELECT oob06 FROM ooa_file,oob_file",
                "                   WHERE ooa01=oob01 AND ooaconf !='X' ",
                "                     AND ooa02 > '",e_date,"' ))"
   END IF
   #add 030213 NO.A048
   LET l_sql= l_sql CLIPPED,
                " UNION ALL ",
                "SELECT oma00,oma01,oma02,oma23,omc06,omc09, omc11,omc07,",     
                #"       omc13,0,omc08 -omc10,omc09 -omc11,azj07,omc02 ",              #MOD-CB0263 mark
                "       omc13,0,omc08 -omc10-omc14,omc09 -omc11-omc15,azj07,omc02 ",   #MOD-CB0263      
                "  FROM oma_file,azj_file,occ_file,omc_file",
                " WHERE oma23 != '",g_aza.aza17,"'",
                "   AND azj_file.azj01 = oma_file.oma23 AND azj_file.azj02='",yymm,"'",
                "   AND oma01 = omc01 ",
                "   AND occ01 = oma03 AND occ40 = 'Y' ",  #AR
                "   AND oma00 LIKE '2%' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",e_date,"'",
                "   AND (oma54t>oma55 OR",
                "       omc13 <>0 OR ",     #No.MOD-B60086 add omc13
                "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                "                   WHERE ooa01=oob01 AND ooaconf !='X' ",
                "                     AND ooa02 > '",e_date,"' ))" 
    
               #" ORDER BY 1,9,14 "  #No.FUN-7B0055     #FUN-920210 mark
 
 #FUN-920210---add---start---
  IF g_ooz.ooz66 = 'Y' THEN     #預收/暫收不做月底重評價
     LET l_sql = l_sql CLIPPED,
                " AND oma00 != '23' AND oma00 != '24' ",
                "ORDER BY 1,9,14 "
  ELSE                          #預收/暫收做月底重評價
     LET l_sql = l_sql CLIPPED,
                " ORDER BY 1,9,14 "
  END IF
 #FUN-920210---add---end---
 
   PREPARE p600_pre1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('p600_pre1',STATUS,1)
      CALL cl_batch_bg_javamail("N")        #No.FUN-570123
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p600_curs1 CURSOR FOR p600_pre1
   FOREACH p600_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p600_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      IF cl_null(sr.azj07) OR sr.azj07 = 0  THEN    #MOD-CB0150 add azj07=0
         #No.FUN-C80034  --Begin
         #CALL cl_err(sr.oma23,'aoo-108',1) LET g_success='N' EXIT FOREACH
         LET g_success = 'N'
         IF NOT cl_null(sr.oma23) THEN
            INSERT INTO oma_tmp_file VALUES(sr.oma23)
            IF SQLCA.SQLCODE THEN 
               CALL cl_err3("ins","oma_tmp_file","","",STATUS,"","l_order",1) 
               EXIT FOREACH
            END IF  
         END IF       
         #No.FUN-C80034  --End
      END IF
      #未沖金額需將大於此月已沖金額加回
      #modify 030213 NO.A048
      IF sr.oma00 MATCHES '1*' THEN
         LET l_flag = '1'
         IF g_ooz.ooz62 = 'N' THEN
            SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2 FROM oob_file,ooa_file
             WHERE ooa01=oob01 AND oob03='2' AND oob04='1' AND ooaconf='Y'
               AND ooa02 > e_date AND oob06 = sr.oma01
               AND oob19 = sr.omc02  #No.FUN-7B0055
         ELSE
            SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2 FROM oob_file,ooa_file
             WHERE ooa01=oob01 AND oob03='2' AND oob04='1' AND ooaconf='Y'
               AND ooa02 > e_date AND oob06 = sr.oma01 AND oob15 = sr.omb03
         END IF
      ELSE
         LET l_flag = '2'
         SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2 FROM oob_file,ooa_file
          WHERE ooa01=oob01 AND oob03='1' AND oob04='3' AND ooaconf='Y'
            AND ooa02 > e_date AND oob06 = sr.oma01
            AND oob19 = sr.omc02  #No.FUN-7B0055
      END IF
 
      IF cl_null(amt1) THEN LET amt1 = 0 END IF
      IF cl_null(amt2) THEN LET amt2 = 0 END IF
      LET sr.amt1 = sr.amt1 + amt1
      LET sr.amt2 = sr.amt2 + amt2
 
      #當月立帳資料,賦予本幣未沖金額
      IF sr.oma02 >= b_date AND sr.oma02 <= e_date THEN
         LET sr.oma60 = sr.oma24
      END IF
      #modify 030213 NO.A048
      CALL s_g_np1('1',l_flag,sr.oma01,sr.omb03,sr.omc02) RETURNING sr.oma61  #No.FUN-7B0055
      IF cl_null(sr.oma61) THEN LET sr.oma61 = 0 END IF
      LET sr.oma61 = sr.oma61 + amt2 #add by liumin 170415 加上后面月份已冲金额
 
      #No.FUN-7B0055  --Begin
      ###No.TQC-750042--begin--
      ###更改子帳期本幣未付金額
      ### 匯差=(原幣未沖金額*重估匯率)-本幣未沖金額 
     #MOD-A30093---modify---start---
     #LET l_net = (sr.amt1 * sr.azj07) - sr.oma61
     #FUN-D90016---add--str--
      #IF g_aza.aza26 = '2' AND sr.oma61 !=0 AND sr.amt1 = 0 THEN  #mark by dengsy170415
      #   LET l_net = sr.amt2 #mark by dengsy170415
      #ELSE #mark by dengsy170415
     #FUN-D90016---add--end--
         LET l_net1 = sr.amt1 * sr.azj07
         CALL cl_digcut(l_net1,g_azi04) RETURNING l_net1
         LET l_net = l_net1 - sr.oma61
     #MOD-A30093---modify---end---
      #END IF    #FUN-D90016 add  #mark by dengsy170415
      IF cl_null(l_net) THEN LET l_net = 0 END IF
      #CALL cl_digcut(l_net,t_azi04) RETURNING l_net
      CALL cl_digcut(l_net,g_azi04) RETURNING l_net    
#     #IF l_net = 0 THEN CONTINUE FOREACH END IF
      ##對子帳期進行匯差處理
      # INITIALIZE l_omc.* TO NULL
      # LET l_net_omc = 0
      # LET l_net     = 0
      # SELECT SUM(omc13) INTO l_omc13_tot FROM omc_file WHERE omc01=sr.oma01
      # IF l_omc13_tot !=0 AND NOT cl_null(l_omc13_tot) THEN 
      #    DECLARE p600_omc_cs  CURSOR FOR 
      #      SELECT * FROM omc_file WHERE omc01=sr.oma01
      #    FOREACH p600_omc_cs INTO l_omc.*
      #      LET l_net_omc =(l_omc.omc08-l_omc.omc10)*sr.azj07 - l_omc.omc13
      #      LET l_net = l_net + l_net_omc
      #      LET l_omc.omc13=l_omc.omc13+l_net_omc
      #      CALL cl_digcut(l_omc.omc13,g_azi04) RETURNING l_omc.omc13  #No.TQC-7B0058
      #      UPDATE omc_file SET omc13=l_omc.omc13
      #       WHERE omc01=l_omc.omc01 AND omc02=l_omc.omc02
      #      IF SQLCA.sqlcode THEN
      #         CALL cl_err3("upd","omc_file",l_omc.omc01,l_omc.omc02,SQLCA.sqlcode,"","update omc_file",1)
      #         LET g_success='N'
      #         EXIT FOREACH
      #      END IF
      #    END FOREACH
      #    CALL cl_digcut(l_net,t_azi04) RETURNING l_net
      #    SELECT SUM(omc13) INTO l_amt FROM omc_file WHERE omc01 = sr.oma01
      #    IF SQLCA.sqlcode THEN
      #       LET l_net = 0
      #       LET l_amt = sr.oma61 + l_net
      #       CALL cl_err('sum omc13:','gap-002',1)
      #    END IF
      # ELSE
      #    LET l_net = 0
      #    LET l_amt = sr.oma61 + l_net
      # END IF
 
      # 本幣未沖金額=上月未沖金額+匯差
      
      LET l_amt = sr.oma61 + l_net
     
      LET l_amt1 = sr.oma61 + l_net  + amt2  #add by liumin 170415 减去后面月份已冲的金额
      #No.TQC-750042--end--
    
      #add 030213 NO.A048
      IF sr.oma00 MATCHES '2*' THEN
         LET l_net = l_net * -1
      END IF
 
      CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt  #No.TQC-7B0058

      #No.FUN-7B0055  --End
      #產生異動記錄檔
      #IF l_net != 0  THEN  #mark by dengsy170415
     IF l_net != 0 OR sr.amt1=0 THEN #add by dengsy170415  
         #modify 030213 NO.A048
         INSERT INTO oox_file(oox00,oox01,oox02,oox03v,oox03,
                              oox04,oox05,oox06,oox07,oox08,
                              oox11,                        #No.FUN-D70002   Add
                              oox09,oox10,oox041,ooxlegal,  #No.MOD-470041  #No.FUN-7B0055 #FUN-980011 add
                              ooxacti,ooxuser,ooxgrup,ooxmodu,   #No.FUN-D40107   Add
                              ooxdate,ooxcrat,ooxoriu,ooxorig    #No.FUN-D40107   Add
                              )
                      VALUES('AR',g_yy,g_mm,sr.oma00,sr.oma01,sr.omb03,
                              sr.oma23,sr.oma60,sr.azj07,sr.oma61,
                              sr.amt1,                      #No.FUN-D70002   Add
                              l_amt,
                              l_net,sr.omc02,g_legal,       #No.FUN-7B0055 #FUN-980011 add
                              'Y',g_user ,g_grup,"",              #No.FUN-D40107   Add
                              "" ,g_today,g_user,g_grup           #No.FUN-D40107   Add
                              )
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins oox #2',STATUS,1)  #No.FUN-660146
            CALL cl_err3("ins","oox_file",sr.oma01,"AR",STATUS,"","ins oox #2",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH  
         END IF
      END IF
      #更新未沖金額
      #原先處理方式為，先對oma處理后，再對omc進行處理，現改為omc(子帳期)處理完理完后，再對oma進行匯差處理。  #No.TQC-750042批注
      #modify 030213 NO.A048
      IF sr.oma00 MATCHES '1*' THEN
         IF g_ooz.ooz62 = 'N' THEN
            #No.FUN-7B0055  --Begin
            #UPDATE oma_file SET oma60 = sr.azj07, oma61 = l_amt
            # WHERE oma01 = sr.oma01
            UPDATE omc_file SET omc13=l_amt1,omc07 = sr.azj07  #No.FUN-7B0090 azi07     #add by liumin 170415
             WHERE omc01 = sr.oma01 AND omc02 = sr.omc02
            LET g_tabname = "omc_file"
            #No.FUN-7B0055  --End  
         ELSE
            UPDATE omb_file SET omb36 = sr.azj07, omb37 = l_amt1  #add by liumin 170415
             WHERE omb01 = sr.oma01 AND omb03 = sr.omb03
            LET g_tabname = "omb_file"
            LET g_key2 = sr.omb03
         END IF
      ELSE
         #No.FUN-7B0055  --Begin
         #UPDATE oma_file SET oma60 = sr.azj07, oma61 = l_amt
         # WHERE oma01 = sr.oma01
         UPDATE omc_file SET omc13=l_amt1,omc07 = sr.azj07  #No.FUN-7B0090 azj07  #add by liumin 170415
          WHERE omc01 = sr.oma01 AND omc02 = sr.omc02
         LET g_tabname = "omc_file"
         #No.FUN-7B0055  --End  
      END IF
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         #CALL cl_err('upd oma/omb',STATUS,1)  #No.FUN-660146
         CALL cl_err3("ins",g_tabname,sr.oma01,g_key2,STATUS,"","upd oma/omb",1)   #No.FUN-660146
         LET g_success='N' EXIT FOREACH
      END IF
      #modi by kitty bug NO:A053  因為報表有的是直接印單頭的欄位資料..
      IF sr.oma00 MATCHES '1*' AND g_ooz.ooz62 = 'Y' THEN
         SELECT SUM(omb37) INTO l_amt FROM omb_file
          WHERE omb01=sr.oma01
         UPDATE oma_file SET oma60 = sr.azj07, oma61 = l_amt
          WHERE oma01 = sr.oma01
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd oma2',STATUS,1)   #No.FUN-660146
            CALL cl_err3("upd","oma_file",sr.oma01,"",STATUS,"","upd oma2",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH 
         END IF
      END IF
      #No.FUN-7B0055  --Begin
      IF g_ooz.ooz62 = 'N' THEN
         LET l_amt = 0 
         SELECT SUM(omc13) INTO l_amt FROM omc_file
          WHERE omc01 = sr.oma01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","omc_file",sr.oma01,"",STATUS,"","sel omc13",1)
            LET g_success = 'N' EXIT FOREACH
         END IF
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         UPDATE oma_file SET oma60 = sr.azj07, oma61 = l_amt
          WHERE oma01 = sr.oma01
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","oma_file",sr.oma01,"",STATUS,"","upd oma61",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH 
         END IF
      END IF
      #No.FUN-7B0055  --End  
      #--end
     #No.TQC-750042--begin-- mark
     #對子帳期的匯差處理已在更新未付金額(oma)之前處理
     ##No.FUN-680022--begin-- add
     ##將匯差金額分攤到omc_file中去
     #INITIALIZE l_omc.* TO NULL
     #SELECT SUM(omc13) INTO l_omc13_tot FROM omc_file WHERE omc01=sr.oma01
     #IF l_omc13_tot !=0 AND NOT cl_null(l_omc13_tot) THEN 
     #   DECLARE p600_omc_cs  CURSOR FOR 
     #     SELECT * FROM omc_file WHERE omc01=sr.oma01
     #   FOREACH p600_omc_cs INTO l_omc.*
     #     LET l_omc.omc13=l_omc.omc13+(l_omc.omc13/l_omc13_tot)*l_net
     #     UPDATE omc_file SET omc13=l_omc.omc13
     #      WHERE omc01=l_omc.omc01 AND omc02=l_omc.omc02
     #     IF SQLCA.sqlcode THEN
     #        CALL cl_err3("upd","omc_file",l_omc.omc01,l_omc.omc02,SQLCA.sqlcode,"","update omc_file",1)
     #        LET g_success='N'
     #        EXIT FOREACH
     #     END IF
     #   END FOREACH
     #END IF
 
     ##No.FUN-680022--end-- add
     #No.TQC-750042--end-- mark
   END FOREACH
   #No.FUN-C80034  --Begin
   LET l_msg = ''
   DECLARE oma_tmpcs CURSOR FOR 
        SELECT DISTINCT oma23 FROM oma_tmp_file
        ORDER BY oma23
   FOREACH oma_tmpcs INTO l_oma23
       IF STATUS THEN
          CALL cl_err('order:',STATUS,1) EXIT FOREACH
       END IF
       IF NOT cl_null(l_oma23) THEN      
          LET l_msg = l_msg,'|',l_oma23
       END IF       
   END FOREACH   
   IF NOT cl_null(l_msg) THEN
      CALL s_errmsg('oma23',l_msg,'','aoo-108',1)
   END IF     
   #No.FUN-C80034  --End
   #更新月底重評價年度月份
   UPDATE ooz_file SET ooz05 = g_yy, ooz06 = g_mm
    WHERE ooz00 = '0'
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd ooz05/06',STATUS,1)   #No.FUN-660146
      CALL cl_err3("upd","ooz_file","","",STATUS,"","upd ooz05/ooz06",1)   #No.FUN-660146
      LET g_success='N'  
   END IF
END FUNCTION
 
