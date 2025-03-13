# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp870.4gl
# Descriptions...: 代採買三角貿易應收/應付帳款拋轉還原作業 no.6215
# Date & Author..: 02/10/24 By Kammy
# Modify.........: 03/06/02 By Kammy 增加倉退單拋轉應收應付部份 no.7176
# Modify.........: No.8166 03/09/10 Kammy 1.流程代碼改抓poy_file,poz_file
#                                         2.多角序號
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值 
# Modify.........: No.FUN-570138 06/03/08 By yiting 批次背景執行
# Modify.........: NO.MOD-630079 06/03/22 By Mandy 代採逆拋時,若在最終工廠有指定最終供應商時,apmp860並不會自動產生最終供應商的相對AP,
#                                                  所以並不需要判斷最終站是否有打此供應商的相對應收貨/入庫單
# Modify.........: No.FUN-660129 06/06/20 By day   cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: NO.FUN-710019 07/01/12 by Yiting 
# Modify.........: NO.FUN-710030 07/01/23 by bnlent  錯誤訊息匯整 
# Modify.........: NO.TQC-7C0019 07/12/05 BY zhangmin刪除應收/應付單時同時刪除多帳期資料
# Modify.........: NO.MOD-8C0250 09/01/06 BY claire axm-994判斷應再加上計價數量(rvv87)<>0,才能讓數量為0的帳款誤拋後做還原
# Modify.........: NO.CHI-920010 09/04/29 BY ve007 1.產生ap分錄底稿應要判斷單別是否有要拋總帳
                                                  #2.ap分錄底稿產生后，應要判斷底稿的正確性
                                                  #3.多角還原時，應判斷單據是否產生底稿在決定刪除
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.TQC-980185 09/09/01 By lilingyu "異動單號"欄位更改為可開窗選擇
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70104 10/07/27 By Smapmin oha54要還原為0
# Modify.........: No:MOD-B20047 11/02/14 By Summer 拋轉還原時未更新ogb60 
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-B40063 11/07/04 By Summer 金額為0不產生分錄,整張帳款金額為0時不做分錄的檢核
# Modify.........: No:MOD-B90076 11/09/08 By Summer 判斷異動類別為入庫單時才需CALL p870_u_ogb60() 
# Modify.........: No:MOD-BA0108 12/02/03 By Summer 還原時沒刪到分錄單身 
# Modify.........: No:MOD-BC0078 12/02/03 By Summer 錯誤訊息改為彙總訊息 
# Modify.........: No:MOD-C60027 12/06/20 By Vampire 增加判斷已開立發票不可還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rvu   RECORD LIKE rvu_file.*
DEFINE g_rvv   RECORD LIKE rvv_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_rva   RECORD LIKE rva_file.*
DEFINE tm RECORD
          rvu00  LIKE rvu_file.rvu00,        #no.7176
          rvu01  LIKE rvu_file.rvu01
       END RECORD
DEFINE g_poz  RECORD LIKE poz_file.*         #流程代碼資料(單頭) No.8166
DEFINE g_poy  RECORD LIKE poy_file.*         #流程代碼資料(單身) No.8166
DEFINE l_dbs_new     LIKE type_file.chr21    #No.FUN-680136 #New DataBase Name
DEFINE l_azp    RECORD LIKE azp_file.*
DEFINE g_sw     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
DEFINE g_argv1  LIKE rvu_file.rvu01
DEFINE g_oga01  LIKE oga_file.oga01
DEFINE g_rvu01  LIKE rvu_file.rvu01
DEFINE g_apa01  LIKE apa_file.apa01
DEFINE g_oma01  LIKE oma_file.oma01
DEFINE p_last        LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE p_last_plant  LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE g_t1          LIKE type_file.chr3     #No.FUN-680136 VARCHAR(3)
DEFINE g_flag        LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE l_flag        LIKE type_file.chr1,    #No.FUN-570138 #No.FUN-680136 VARCHAR(1)
       g_change_lang LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       ls_date       STRING                  #No.FUN-570138
DEFINE l_c           LIKE type_file.num5     #No.FUN-680136 
DEFINE g_msg         LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE p_ooy RECORD LIKE ooy_file.*          #No.CHI-920010
DEFINE p_apy RECORD LIKE apy_file.*          #No.CHI-920010
DEFINE AR_t1,AP_t1  LIKE aba_file.aba00      #No.CHI-920010
DEFINE l_plant_new  LIKE azw_file.azw01      #FUN-980092 add
DEFINE l_dbs_tra    LIKE azw_file.azw05      #FUN-980092 add
 
MAIN
   OPTIONS                                   #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.rvu01     = ARG_VAL(1)
   LET tm.rvu00     = ARG_VAL(2)
   LET g_bgjob= ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   #若有傳參數則不用輸入畫面
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob= "N" THEN
         IF cl_null(g_argv1) THEN
            CALL p870_p1()
         END IF
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL p870_p2()
            #若無傳入值時
            CALL s_showmsg()   #No.FUN-710030
            IF g_success = 'Y' AND cl_null(g_argv1) THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            #若有傳入值時
            IF g_success = 'Y' AND NOT cl_null(g_argv1) THEN
               CALL cl_cmmsg(1)
               COMMIT WORK
            ELSE
               CALL cl_rbmsg(1)
               ROLLBACK WORK
            END IF
            CLOSE WINDOW win
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p870_w
               EXIT WHILE
            END IF
         ELSE
            CLOSE WINDOW win
            CONTINUE WHILE
         END IF
         IF NOT cl_null(g_argv1) THEN
            CLOSE WINDOW win
         END IF
         CLOSE WINDOW p870_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p870_p2()
         CALL s_showmsg()   #No.FUN-710030
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p870_p1()
 DEFINE l_ac    LIKE type_file.num5        #No.FUN-680136 SMALLINT
 DEFINE l_i     LIKE type_file.num5        #No.FUN-680136 SMALLINT
 DEFINE l_cnt   LIKE type_file.num5        #No.FUN-680136 SMALLINT
 DEFINE l_rvv23 LIKE rvv_file.rvv23
 DEFINE lc_cmd  LIKE type_file.chr1000     #No.FUN-680136 VARCHAR(500)
 DEFINE l_rvv87 LIKE rvv_file.rvv87        #MOD-8C0250 add
 
 OPEN WINDOW p870_w WITH FORM "apm/42f/apmp870" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
 CALL cl_ui_init()
 
 CALL cl_opmsg('z')
 
 WHILE TRUE
    #NO.FUN-590002-start----
    LET tm.rvu00 = '1'
    #NO.FUN-590002-end----
    LET g_bgjob = "N"          #->No.FUN-570138
    ERROR ''
    #INPUT BY NAME tm.rvu00,tm.rvu01  WITHOUT DEFAULTS  
    INPUT BY NAME tm.rvu00,tm.rvu01,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570138
        #no.7176
        AFTER FIELD rvu00
           IF NOT cl_null(tm.rvu00) THEN
              IF tm.rvu00 NOT MATCHES '[13]' THEN
                 NEXT FIELD rvu00
              END IF
           END IF
         #no.7176
         AFTER FIELD rvu01
            IF NOT cl_null(tm.rvu01) THEN
               SELECT * INTO g_rvu.* FROM rvu_file
                WHERE rvu01=tm.rvu01 
                  AND rvu00=tm.rvu00  #no.7176
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('sel rvu',SQLCA.SQLCODE,0)   #No.FUN-660129
                  CALL cl_err3("sel","rvu_file",tm.rvu01,"",SQLCA.sqlcode,"","sel rvu",0)  #No.FUN-660129
                  NEXT FIELD rvu01 
               END IF
               IF g_rvu.rvu08 != 'TAP' THEN  #非三角貿易
                  CALL cl_err(g_rvu.rvu08,'axm-406',0)
                  NEXT FIELD rvu01 
               END IF
               IF g_rvu.rvu20 != 'Y' THEN   #未拋轉
                  CALL cl_err(g_rvu.rvu20,'axm-991',0)
                  NEXT FIELD rvu01 
               END IF
               #已請款匹配量
               #SELECT SUM(rvv23) INTO l_rvv23 FROM rvv_file                    #MOD-8C0250 mark
               SELECT SUM(rvv23),SUM(rvv87) INTO l_rvv23,l_rvv87 FROM rvv_file  #MOD-8C0250
                WHERE rvv01 = g_rvu.rvu01 
               IF cl_null(l_rvv23) THEN LET l_rvv23 = 0 END IF
              #IF l_rvv23 = 0 THEN                 #MOD-8C0250 mark
               IF l_rvv23 = 0 AND l_rvv87<>0 THEN  #MOD-8C0250 
                  CALL cl_err('','axm-994',0)
                  NEXT FIELD rvu01
               END IF
            END IF
 
#TQC-980185 --begin--
       ON ACTION controlp
         CASE
           WHEN INFIELD(rvu01) 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_rvu001"
              LET g_qryparam.default1 = tm.rvu01
              LET g_qryparam.arg1     = tm.rvu00
              CALL cl_create_qry() RETURNING tm.rvu01
              DISPLAY tm.rvu01 TO FORMONLY.rvu01
              NEXT FIELD rvu01
        END CASE     
#TQC-980185 --end--
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG call cl_cmdask()
 
      ON ACTION locale                    #genero
#NO.FUN-570138 MARK
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570138 MARK
         LET g_change_lang = TRUE   #NO.FUN-570138
         EXIT INPUT
 
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
 
#NO.FUN-570138 start---
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p832_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apmp870"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apmp870','9031',1)  
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.rvu01 CLIPPED,"'",
                      " '",tm.rvu00 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apmp870',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p870_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
 END WHILE
#->No.FUN-570138 ---end---
 
#NO.FUN-570138 mark---
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE 
#   END IF
 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      EXIT WHILE 
#   END IF
 
#   IF cl_sure(0,0) THEN 
#      CALL cl_wait() 
#      BEGIN WORK 
#      LET g_success='Y'
#      CALL p870_p2()
#      IF g_success = 'Y' THEN 
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
#   END IF 
#
# END WHILE
# CLOSE WINDOW p870_w
#NO.FUN-570138 mark---
END FUNCTION
 
FUNCTION p870_p2()
  DEFINE l_sql  LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1 LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2 LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE l_oma  RECORD LIKE oma_file.*
  DEFINE l_apa  RECORD LIKE apa_file.*
  DEFINE l_npp  RECORD LIKE npp_file.*
  DEFINE l_j    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_msg  LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(60)
 
    #讀取出貨單資料
    SELECT rvu_file.*,rva_file.* INTO g_rvu.*,g_rva.*
      FROM rvu_file,rva_file
     WHERE rvu01  = tm.rvu01  
       AND rvu00  = tm.rvu00 #no.7176
       AND rvu02  = rva01
       AND rvu08  = 'TAP' 
       AND rvu20  = 'Y'
       AND rvuconf= 'Y'
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('sel rvu',SQLCA.SQLCODE,1)    #No.FUN-660129
       CALL cl_err3("sel","rvu_file,rva_file","","",SQLCA.sqlcode,"","sel rvu",1)  #No.FUN-660129
       LET g_success = 'N'
       RETURN
    END IF
{
  #保留此段, 若條件改成construct多筆時只要把mark拿掉
  #讀取符合條件之代採買採購單資料
  LET l_sql="SELECT * FROM rvu_file ",
            " WHERE rvu01 ='",tm.rvu01,"' ",
             " AND rvu08  ='TAP' ",
             " AND rvu20  ='Y' ",
             " AND rvuconf='Y' "      #已確認之入庫單
  PREPARE p870_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN
     CALL cl_err('prepare p870_p1',SQLCA.SQLCODE,1) 
     LET g_success = 'N'
     RETURN
  END IF
 
  DECLARE p870_curs1 CURSOR FOR p870_p1
  IF SQLCA.SQLCODE THEN
     CALL cl_err('declare p870_p1',SQLCA.SQLCODE,1) 
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p870_curs1 INTO g_rvu.*
     IF SQLCA.SQLCODE THEN
        CALL cl_err('foreach p870_curs1',SQLCA.SQLCODE,1) 
        LET g_success = 'N'
        EXIT FOREACH
     END IF
}
     IF cl_null(g_rva.rva02) THEN   
        #只讀取第一筆訂單之資料
        LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvb_file ",
                    "  WHERE pmm01 = rvb04 ",
#                   "    AND rvb01 = '",g_rvu.rvu02,"'" 
                    "    AND rvb01 = ? "
        PREPARE pmm_pre FROM l_sql1
        IF SQLCA.SQLCODE THEN
           CALL cl_err('prepare pmm_pre',SQLCA.SQLCODE,1) 
           LET g_success = 'N'
           RETURN
        END IF
        DECLARE pmm_f CURSOR FOR pmm_pre
        IF SQLCA.SQLCODE THEN
           CALL cl_err('declare pmm_f',SQLCA.SQLCODE,1) 
           LET g_success = 'N'
           RETURN
        END IF
        OPEN pmm_f USING g_rvu.rvu02
        IF SQLCA.SQLCODE THEN
           CALL cl_err('open pmm_pre',SQLCA.SQLCODE,1) 
           LET g_success = 'N'
           RETURN
        END IF
        FETCH pmm_f INTO g_pmm.*
        IF SQLCA.SQLCODE THEN
           CALL cl_err('fetch pmm_pre',SQLCA.SQLCODE,1) 
           LET g_success = 'N'
           RETURN
        END IF
     ELSE
        #讀取該入庫單之採購單
        SELECT * INTO g_pmm.* FROM pmm_file
         WHERE pmm01 = g_rva.rva02
     END IF
     #必須檢查為來源採購單(目前應收/應付拋轉只採正拋)
     IF g_pmm.pmm906 != 'Y' THEN
        CALL cl_err(g_pmm.pmm01,'apm-021',1) 
        LET g_success='N' RETURN
     END IF
 
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.* FROM poz_file
      WHERE poz01=g_pmm.pmm904 AND poz00='2'
     IF SQLCA.sqlcode THEN
#        CALL cl_err(g_pmm.pmm904,'axm-318',1)   #No.FUN-660129
         CALL cl_err3("sel","poz_file",g_pmm.pmm904,"","axm-318","","",1)  #No.FUN-660129
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN 
         CALL cl_err(g_pmm.pmm904,'tri-009',1)
         LET g_success = 'N'
         RETURN
     END IF
     CALL s_mtrade_last_plant(g_pmm.pmm904) 
          RETURNING p_last,p_last_plant       #記錄最後一家
 
     #依流程代碼最多6層
     CALL s_showmsg_init()    #No.FUN-710030
     FOR i = 0 TO p_last
         #No.FUN-710030--Begin--                                                                                                      
          IF g_success='N' THEN                                                                                                        
             LET g_totsuccess='N'                                                                                                      
             LET g_success="Y"                                                                                                         
          END IF                                                                                                                       
         #No.FUN-710030--End-
 
         #得到廠商/客戶代碼及database
         CALL p870_azp(i)      
 
         #No.8166
         IF tm.rvu00 = '1' THEN
            CALL p870_getno1(i)
         ELSE
            CALL p870_getno2(i)
         END IF
         #No.8166(end)
         
          #No.CHI-920010 --begin--
         #讀取AR,AP單別檔資料
         LET l_sql = "SELECT * ",
                     #" FROM ",l_dbs_new CLIPPED,"ooy_file ",
                     " FROM ",cl_get_target_table(l_plant_new,'ooy_file'), #FUN-A50102
                     " WHERE ooyslip = '",AR_t1,"' "     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE ooy_p1 FROM l_sql 
         IF STATUS THEN CALL s_errmsg('ooyslip',AR_t1,'ooy_p1',STATUS,1) END IF 
         DECLARE ooy_c1 CURSOR FOR ooy_p1
         OPEN ooy_c1
         FETCH ooy_c1 INTO p_ooy.* 
         CLOSE ooy_c1
         IF i != p_last THEN   ##最後一家工廠不必拋AP
            LET l_sql = "SELECT * ",
                        #" FROM ",l_dbs_new CLIPPED,"apy_file ",
                        " FROM ",cl_get_target_table(l_plant_new,'apy_file'), #FUN-A50102
                        " WHERE apyslip = '",AP_t1,"' "      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE apy_p1 FROM l_sql 
            IF STATUS THEN CALL s_errmsg('apyslip',AP_t1,'apy_p1',STATUS,1) END IF  
            DECLARE apy_c1 CURSOR FOR apy_p1
            OPEN apy_c1
            FETCH apy_c1 INTO p_apy.* 
            CLOSE apy_c1
        END IF
        #No.CHI-920010 --end--
        
     IF i != 0 THEN #來源廠沒有拋應收單據  #No.9422
         #***************判斷已沖帳或已拋傳票否*************#
         #判斷應收帳款是否已拋轉至總帳
         #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," oma_file",
         LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'oma_file'), #FUN-A50102
                     " WHERE oma01 =  ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE oma_pre FROM l_sql
         DECLARE oma_cs CURSOR FOR oma_pre
         OPEN oma_cs USING g_oma01
         IF SQLCA.sqlcode THEN 
         #No.FUN-710030-Begin--
         #  CALL cl_err('open oma_cs:',SQLCA.sqlcode,1)
            CALL s_errmsg('','','open oma_cs:',SQLCA.sqlcode,1)
            LET g_success='N' 
         #  EXIT FOR
            CONTINUE FOR
         #No.FUN-710030--End--
         END IF 
         FETCH oma_cs INTO l_oma.*
         IF SQLCA.sqlcode THEN 
         #No.FUN-710030--Begin--
         #  CALL cl_err('fetch oma_cs:',SQLCA.sqlcode,1)
            CALL s_errmsg('','','fetch oma_cs:',SQLCA.sqlcode,1)
         #No.FUN-710030--End--
            LET g_success='N' 
         #  EXIT FOR     #No.FUN-710030
            CONTINUE FOR #No.FUN-710030
         END IF 
 
         IF l_oma.oma33 IS NOT NULL THEN
         #No.FUN-710030--Begin--
         #  CALL cl_err('oma33:','axm-898',1)
         #  LET g_success='N' EXIT FOR
            CALL s_errmsg('','','oma33:','axm-898',1)
            LET g_success='N' CONTINUE FOR
         #No.FUN-710030--End--
         END IF
         IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN #已沖帳
         #No.FUN-710030--Begin--
         #  CALL cl_err('oma55:','agl-905',1)
         #  LET g_success='N' EXIT FOR
            CALL s_errmsg('','','oma55:','agl-905',1)
            LET g_success='N' CONTINUE FOR
         #No.FUN-710030--End--
         END IF
         #MOD-C60027 add start -----
         IF NOT cl_null(l_oma.oma10) THEN
            CALL s_errmsg('','','oma10:','arm-015',1)
            LET g_success='N'
            CONTINUE FOR
         END IF
         #MOD-C60027 add start -----
     END IF
        
         IF i != p_last OR     ##最後一家工廠不必拋AP
            g_poz.poz011 != '2' AND NOT cl_null(g_pmm.pmm50) THEN
            #判斷應付帳款是否已拋轉至總帳
            #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," apa_file",
            LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'apa_file'), #FUN-A50102
                        " WHERE apa01 = '",g_apa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE apa_pre FROM l_sql
            DECLARE apa_cs CURSOR FOR apa_pre
            OPEN apa_cs 
            IF SQLCA.sqlcode THEN 
            #No.FUN-710030--Begin--
            #  CALL cl_err('open apa_cs:',SQLCA.sqlcode,1)
               CALL s_errmsg('','','open apa_cs:',SQLCA.sqlcode,1)
               LET g_success='N' 
            #  EXIT FOR
               CONTINUE FOR
            #No.FUN-710030--End--
            END IF 
            FETCH apa_cs INTO l_apa.*
            IF SQLCA.sqlcode THEN 
            #No.FUN-710030--Begin--
            #  CALL cl_err('fetch apa_cs:',SQLCA.sqlcode,1)
               CALL s_errmsg('','','fetch apa_cs:',SQLCA.sqlcode,1)
               LET g_success='N' 
            #  EXIT FOR
               CONTINUE FOR
            #No.FUN-710030--End--
            END IF 
            IF l_apa.apa44 IS NOT NULL THEN
            #No.FUN-710030--Begin--
            #  CALL cl_err('apa44:','axm-898',0)
            #  LET g_success='N' EXIT FOR
               CALL s_errmsg('','','apa44:','axm-898',1)
               LET g_success='N' CONTINUE FOR
            #No.FUN-710030--End--
            END IF
            IF l_apa.apa35>0 OR l_apa.apa35f>0    #已沖帳
               OR l_apa.apa65>0 OR l_apa.apa65f>0 THEN
            #No.FUN-710030--Begin--
            #  CALL cl_err('oma35:','aap-255',0)
            #  LET g_success='N' EXIT FOR
               CALL s_errmsg('','','oma35:','aap-255',1)
               LET g_success='N' CONTINUE FOR
            #No.FUN-710030--End--
            END IF
         END IF
         IF p_ooy.ooydmy1 = 'Y' THEN              #No.CHI-920010
         #判斷分錄底稿是否已拋轉至總帳
         #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," npp_file ",
         LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'npp_file'), #FUN-A50102
                     " WHERE nppsys='AR' AND npp00='2' ",
                     "   AND npp01 = ? ",
                     "   AND npp011=1 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE npp_p1 FROM l_sql
         DECLARE npp_c1 CURSOR FOR npp_p1
         OPEN npp_c1 USING g_oma01
         FETCH npp_c1 INTO l_npp.*
         IF l_npp.nppglno IS NOT NULL THEN
            #No.FUN-710030--Begin--
            #CALL cl_err('nppglno(AR):','axm-898',0)
            #LET g_success='N' EXIT FOR
             CALL s_errmsg('','','nppglno(AR):','axm-898',1)
             LET g_success='N' CONTINUE FOR
            #No.FUN-710030--End--
         END IF
         END IF                            #No.CHI-920010
         IF i != p_last OR     ##最後一家工廠不必拋AP
            g_poz.poz011 != '2' AND NOT cl_null(g_pmm.pmm50) THEN
            IF p_apy.apydmy3 = 'Y' THEN              #NO.CHI-920010
            #判斷分錄底稿是否已拋轉至總帳
            #LET l_sql = "SELECT * FROM ",l_dbs_new CLIPPED," npp_file ",
            LET l_sql = "SELECT * FROM ",cl_get_target_table(l_plant_new,'npp_file'), #FUN-A50102
                        " WHERE nppsys='AP' AND npp00='1' ",
                        "   AND npp01 = '",g_apa01,"'",
                        "   AND npp011=1 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE npp_p2 FROM l_sql
            DECLARE npp_c2 CURSOR FOR npp_p2
            OPEN npp_c2 
            FETCH npp_c2 INTO l_npp.*
            IF l_npp.nppglno IS NOT NULL THEN
            #No.FUN-710030--Begin--
            #  CALL cl_err('nppglno(AP):','axm-898',0)
            #  LET g_success='N' EXIT FOR
               CALL s_errmsg('','','nppglno(AP):','axm-898',1)
               LET g_success='N' CONTINUE FOR
            #No.FUN-710030--End--
            END IF
          END IF                      #NO.CHI-920010  
         END IF
         #****************************************************#
 
         IF tm.rvu00 = '1' THEN #MOD-B90076 add 
            #還原ogb60
            CALL p870_u_ogb60() #MOD-B20047 add
         END IF                 #MOD-B90076 add
         #還原各廠之應收/應付資料
         #CALL p870_pro(l_dbs_new,i)
         CALL p870_pro(l_plant_new,l_dbs_new,i) #FUN-A50102
     END FOR 
     #No.FUN-710030--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
     #No.FUN-710030--End--
 
# END FOREACH     
END FUNCTION
 
FUNCTION p870_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,         #No.FUN-680136 SMALLINT
         l_sql1  LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
     ##-------------取得當站資料庫----------------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
#    LET l_dbs_new = l_azp.azp03 CLIPPED,"."   #TQC-950010 MARK                                                                     
     LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950010 ADD     
     IF l_i = 0 THEN LET l_dbs_new = ' ' END IF  
    #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()      
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
END FUNCTION
 
#FUNCTION p870_pro(p_dbs,i)
FUNCTION p870_pro(l_plant,p_dbs,i)  #FUN-A50102
 DEFINE p_dbs    LIKE type_file.chr21    #No.FUN-680136 VARCHAR(21)
 DEFINE l_plant  LIKE type_file.chr21
 DEFINE i        LIKE type_file.num5     #i=0 來源廠 #No.FUN-680136 SMALLINT
 DEFINE l_sql    LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(600)
 DEFINE l_apb02  LIKE apb_file.apb02
 DEFINE l_apb04  LIKE apb_file.apb04
 DEFINE l_apb05  LIKE apb_file.apb05
 DEFINE l_qty    LIKE rvb_file.rvb06
 DEFINE l_cnt    LIKE type_file.num5     #CHI-B40063 add
 
     IF i != 0 THEN #來源廠沒有拋應收單據
        #刪除應收帳款單頭(oma_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"oma_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'oma_file'), #FUN-A50102
                  " WHERE oma01= ? ",
                  "   AND oma33 IS NULL "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE del_oma FROM l_sql
        EXECUTE del_oma USING g_oma01     
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('del oma:',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
           CALL s_errmsg('','','del oma:',SQLCA.SQLCODE,1) #MOD-BC0078
           LET g_success='N' 
        END IF
        #刪除應收帳款單頭(omb_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"omb_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'omb_file'), #FUN-A50102
                  " WHERE omb01= ? " 
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE del_omb FROM l_sql
        EXECUTE del_omb USING g_oma01     
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('del omb:',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
           CALL s_errmsg('','','del omb:',SQLCA.SQLCODE,1) #MOD-BC0078
           LET g_success='N' 
        END IF
 
        #No.TQC-7C0019 --begin--
        #刪除應收多帳期資料(omc_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"omc_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'omc_file'), #FUN-A50102
                  " WHERE omc01= ? " 
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE del_omc FROM l_sql
        EXECUTE del_omc USING g_oma01     
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('del omc:',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
           CALL s_errmsg('','','del omc:',SQLCA.SQLCODE,1) #MOD-BC0078
           LET g_success='N' 
        END IF
        #No.TQC-7C0019 --end--
 
        IF tm.rvu00 = '1' THEN 
           #更新出貨單單頭檔之帳單編號
           #LET l_sql="UPDATE ",p_dbs CLIPPED,"oga_file",    #FUN-980092 mark
           #LET l_sql="UPDATE ",l_dbs_tra CLIPPED,"oga_file", #FUN-980092 add
           LET l_sql="UPDATE ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
                     " SET oga10 = NULL ",
                     " WHERE oga01 = ?  "
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
           PREPARE upd_rvu2 FROM l_sql
           EXECUTE upd_rvu2 USING g_oga01 #no.7605
           IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
              LET g_msg = p_dbs CLIPPED,'upd oga10'
             #CALL cl_err(g_msg,SQLCA.sqlcode,1)         #MOD-BC0078 mark
              CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1) #MOD-BC0078
              LET g_success = 'N'
           END IF
        ELSE
           #更新銷退單單頭檔之帳單編號
           #LET l_sql="UPDATE ",p_dbs CLIPPED,"oha_file",#FUN-980092 mark
           #LET l_sql="UPDATE ",l_dbs_tra CLIPPED,"oha_file",#FUN-980092 add
           LET l_sql="UPDATE ",cl_get_target_table(l_plant,'oha_file'), #FUN-A50102
                     " SET oha10 = NULL,",
                     "     oha54 = 0 ",   #MOD-A70104
                     " WHERE oha01 = ?  "
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
           PREPARE upd_oha FROM l_sql
           EXECUTE upd_oha USING g_oga01
           IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
              LET g_msg = p_dbs CLIPPED,'upd oha10'
             #CALL cl_err(g_msg,SQLCA.sqlcode,1)         #MOD-BC0078 mark
              CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1) #MOD-BC0078
              LET g_success = 'N'
           END IF
        END IF
        IF p_ooy.ooydmy1 = 'Y' THEN             #No.CHI-920010    
           #刪除分錄底稿單頭檔(npp_file)--AR
           #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npp_file",
           LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npp_file'), #FUN-A50102
                     " WHERE nppsys='AR' AND npp00='2' ",
                     "   AND npp01=? ",
                     "   AND npp011=1 ",
                     "   AND nppglno IS NULL "
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
           PREPARE del_npp_ar FROM l_sql
           EXECUTE del_npp_ar USING g_oma01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
             #CALL cl_err('del npp(AR):',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
              CALL s_errmsg('','','del npp(AR):',SQLCA.SQLCODE,1) #MOD-BC0078
              LET g_success='N' 
           END IF
           #CHI-B40063 add --start--
          #LET l_sql="SELECT COUNT(*) FROM",cl_get_target_table(l_plant,'npq_file'),  #MOD-BA0108 mark 
           LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'npq_file'), #MOD-BA0108
                    " WHERE npqsys='AR' AND npq00='2' ",
                    "   AND npq01=? ",
                    "   AND npq011=1 " 
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
           PREPARE sel_npq_ar FROM l_sql
           LET l_cnt = 0 
           EXECUTE sel_npq_ar USING g_oma01 INTO l_cnt
           IF l_cnt > 0 THEN 
           #CHI-B40063 add --end--
              #刪除分錄底稿單身檔(npq_file)--AR
              #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",
              LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npq_file'), #FUN-A50102
                        " WHERE npqsys='AR' AND npq00='2' ",
                        "   AND npq01=? ",
                        "   AND npq011=1 " 
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
              PREPARE del_npq_ar FROM l_sql
              EXECUTE del_npq_ar USING g_oma01
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                #CALL cl_err('del npq(AR):',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
                 CALL s_errmsg('','','del npq(AR):',SQLCA.SQLCODE,1) #MOD-BC0078
                 LET g_success='N' 
              END IF
           END IF   #CHI-B40063 add

           #FUN-B40056--add--str--
           #刪除現金流量表
           LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'tic_file'), 
                     " WHERE tic04 = '",g_oma01,"'"
    	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
           PREPARE del_tic_ar FROM l_sql
           EXECUTE del_tic_ar 
           IF SQLCA.SQLCODE THEN
             #CALL cl_err('del tic(AR):',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
              CALL s_errmsg('','','del tic(AR):',SQLCA.SQLCODE,1) #MOD-BC0078
              LET g_success='N' 
           END IF 
           #FUN-B40056--add--end--
        END IF                                   #No.CHI-920010    
     END IF
     IF i != p_last OR     ##最後一家工廠不必拋AP
        g_poz.poz011 != '2' AND NOT cl_null(g_pmm.pmm50) THEN
        #刪除應付帳款單頭(apa_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apa_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'apa_file'), #FUN-A50102
                  " WHERE apa01= ? ",
                  "   AND apa44 IS NULL "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE del_apa FROM l_sql
        EXECUTE del_apa USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('del apa:',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
           CALL s_errmsg('','','del apa:',SQLCA.SQLCODE,1) #MOD-BC0078
           LET g_success='N' 
        END IF
 
        #no.7489
        #LET l_sql="SELECT apb02,apb04,apb05 FROM ",p_dbs CLIPPED,"apb_file",
        LET l_sql="SELECT apb02,apb04,apb05 FROM ",cl_get_target_table(l_plant,'apb_file'), #FUN-A50102
                  " WHERE apb01 = ? "
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE sel_apb FROM l_sql
        DECLARE apb_cs CURSOR FOR sel_apb
        FOREACH apb_cs USING g_apa01 INTO l_apb02,l_apb04,l_apb05
            #刪除應付帳款單身(apb_file)
            #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apb_file",
            LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'apb_file'), #FUN-A50102
                      " WHERE apb01= ? " ,
                      "   AND apb02= ? "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
            PREPARE del_apb FROM l_sql
            EXECUTE del_apb USING g_apa01,l_apb02
            IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              #CALL cl_err('del apb:',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
               CALL s_errmsg('','','del apb:',SQLCA.SQLCODE,1) #MOD-BC0078
               LET g_success='N' 
            END IF
            #LET l_sql = " SELECT SUM(apb09) FROM ",p_dbs," apb_file ",
            LET l_sql = " SELECT SUM(apb09) FROM ",cl_get_target_table(l_plant,'apb_file'), #FUN-A50102
                        "  WHERE apb04 = '",l_apb04,"'",
                        "    AND apb05 = ",l_apb05
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
            PREPARE rvb06_pre FROM l_sql
            DECLARE sum_rvb06 CURSOR FOR rvb06_pre
            OPEN sum_rvb06 
            FETCH sum_rvb06 INTO l_qty
            CLOSE sum_rvb06
            IF cl_null(l_qty) THEN LET l_qty = 0 END IF
            IF tm.rvu00 = '1' THEN  #no.7176入庫單才回寫
               #更新rvb06(驗收單之已請款量)
               #LET l_sql = " UPDATE ",p_dbs," rvb_file SET rvb06 = ? ",  #FUN-980092 mark
               #LET l_sql = " UPDATE ",l_dbs_tra," rvb_file SET rvb06 = ? ",   #FUN-980092 add
               LET l_sql = " UPDATE ",cl_get_target_table(l_plant,'rvb_file'), #FUN-A50102
                           "    SET rvb06 = ? ", 
                           "  WHERE rvb01 = ? ",
                           "    AND rvb02 = ? "
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
               PREPARE upd_rvb06 FROM l_sql
               EXECUTE upd_rvb06 USING l_qty,l_apb04,l_apb05
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 #CALL cl_err('upd rvb06:',SQLCA.SQLCODE,1) LET g_success='N' #MOD-BC0078 mark
                  CALL s_errmsg('','','upd rvb06:',SQLCA.SQLCODE,1)           #MOD-BC0078
                  LET g_success='N'                                           #MOD-BC0078
               END IF
            END IF
        END FOREACH
        #no.7489(end)
 
        #No.TQC-7C0019 --begin--
        #刪除應付多帳期資料(apc_file)
        #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"apc_file",
        LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'apc_file'), #FUN-A50102
                  " WHERE apc01= ? "
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE del_apc FROM l_sql
        EXECUTE del_apc USING g_apa01
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('del apc:',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
           CALL s_errmsg('','','del apc:',SQLCA.SQLCODE,1) #MOD-BC0078
           LET g_success='N' 
        END IF
        #No.TQC-7C0019 --end--
 
        #---------------- no:3497 01/09/07 ---------------------
        #更新rvv23(入庫單之已請款匹配量)
        #LET l_sql = " UPDATE ",p_dbs," rvv_file SET rvv23 = 0 ",  #FUN-980092 mark
        #LET l_sql = " UPDATE ",l_dbs_tra," rvv_file SET rvv23 = 0 ",   #FUN-980092 add
        LET l_sql = " UPDATE ",cl_get_target_table(l_plant,'rvv_file'), #FUN-A50102
                    "    SET rvv23 = 0 ", 
                    "  WHERE rvv01 = ? "
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980092
        PREPARE upd_rvv23 FROM l_sql
        EXECUTE upd_rvv23 USING g_rvu01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('upd rvv23:',SQLCA.SQLCODE,1) LET g_success='N' #MOD-BC0078 mark
           CALL s_errmsg('','','upd rvv23:',SQLCA.SQLCODE,1)           #MOD-BC0078
           LET g_success='N'                                           #MOD-BC0078
        END IF
        #---------------------------------------------------------
        IF p_apy.apydmy3 = 'Y' THEN              #NO.CHI-920010
           #刪除分錄底稿單頭檔(npp_file)--AP
           #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npp_file",
           LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npp_file'), #FUN-A50102
                  " WHERE nppsys='AP' AND npp00='1' ",
                  "   AND npp01=? ",
                  "   AND npp011=1 ",
                  "   AND nppglno IS NULL "
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
           PREPARE del_npp_ap FROM l_sql
           EXECUTE del_npp_ap USING g_apa01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
             #CALL cl_err('del npp(AR):',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
              CALL s_errmsg('','','del npp(AR):',SQLCA.SQLCODE,1) #MOD-BC0078
              LET g_success='N' 
           END IF
           #CHI-B40063 add --start--
          #LET l_sql="SELECT COUNT(*) FROM",cl_get_target_table(l_plant,'npq_file'),  #MOD-BA0108 mark
           LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'npq_file'), #MOD-BA0108
                     " WHERE npqsys='AP' AND npq00='1' ",
                     "   AND npq01=? ",
                     "   AND npq011=1 " 
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
           PREPARE sel_npq_ap FROM l_sql
           LET l_cnt = 0
           EXECUTE sel_npq_ap USING g_apa01 INTO l_cnt
           IF l_cnt > 0 THEN 
           #CHI-B40063 add --end--
              #刪除分錄底稿單身檔(npq_file)--AP
              #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",
              #LET l_sql="DELETE FROM ",p_dbs CLIPPED,"npq_file",
              LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'npq_file'), #FUN-A50102
                        " WHERE npqsys='AP' AND npq00='1' ",
                        "   AND npq01=? ",
                        "   AND npq011=1 " 
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
              PREPARE del_npq_ap FROM l_sql
              EXECUTE del_npq_ap USING g_apa01
              IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                #CALL cl_err('del npq(AR):',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
                 CALL s_errmsg('','','del npq(AR):',SQLCA.SQLCODE,1) #MOD-BC0078
                 LET g_success='N' 
              END IF
           END IF   #CHI-B40063 add
           
           #FUN-B40056--add--str--
           #刪除現金流量表
           LET l_sql="DELETE FROM ",cl_get_target_table(l_plant,'tic_file'),
                     " WHERE tic04 = '",g_apa01,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
           CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
           PREPARE del_tic_ap FROM l_sql
           EXECUTE del_tic_ap
           IF SQLCA.SQLCODE THEN
             #CALL cl_err('del tic(AR):',SQLCA.SQLCODE,1)         #MOD-BC0078 mark
              CALL s_errmsg('','','del tic(AR):',SQLCA.SQLCODE,1) #MOD-BC0078
              LET g_success='N'
           END IF
           #FUN-B40056--add--end--
        END IF                        #No,CHI-920010  
     END IF
END FUNCTION
 
FUNCTION p870_getno1(i) 
  DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(600)
  DEFINE i     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
         #IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm.pmm50)) THEN                          #MOD-630079
         IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm.pmm50) AND g_poz.poz011 = '1' ) THEN  #MOD-630079 #正拋時才需進入
            #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ", #FUN-980092 mark
            #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092 add
            LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                        "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                        "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE rvu01_pre FROM l_sql
            DECLARE rvu01_cs CURSOR FOR rvu01_pre
            OPEN rvu01_cs 
            FETCH rvu01_cs INTO g_rvu01                              #入庫單
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs'
            #No.FUN-710030--Begin--
            #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
            #No.FUN-710030--End--
               LET g_success = 'N'
            END IF
 
            #LET l_sql = " SELECT apa01 FROM ",l_dbs_new CLIPPED,"apa_file ",
            LET l_sql = " SELECT apa01 FROM ",cl_get_target_table(l_plant_new,'apa_file'), #FUN-A50102
                        "  WHERE apa99 ='",g_rvu.rvu99,"'",
                        "    AND apa00 = '11' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE apa01_pre FROM l_sql
            DECLARE apa01_cs CURSOR FOR apa01_pre
            OPEN apa01_cs 
            FETCH apa01_cs INTO g_apa01                              #付款單
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_new CLIPPED,'fetch apa01_cs'
            #No.FUN-710030--Begin--
            #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
            #No.FUN-710030--End--
               LET g_success = 'N'
            END IF
            LET AP_t1=s_get_doc_no(g_apa01)               #No.CHI-920010
         END IF
 
     IF i != 0 THEN   #FUN-710019
        #LET l_sql = " SELECT oga01 FROM ",l_dbs_new CLIPPED,"oga_file ",  #FUN-980092 mark
        #LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",   #FUN-980092 add
        LET l_sql = " SELECT oga01 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                    "  WHERE oga99 ='",g_rvu.rvu99,"'",
                    "    AND oga09 = '6' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE oga01_pre FROM l_sql
        DECLARE oga01_cs CURSOR FOR oga01_pre
        OPEN oga01_cs 
        FETCH oga01_cs INTO g_oga01                              #出貨單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch oga01_cs'
        #No.FUN-710030--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710030--End--
           LET g_success = 'N'
        END IF
      
        #LET l_sql = " SELECT oma01 FROM ",l_dbs_new CLIPPED,"oma_file ",
        LET l_sql = " SELECT oma01 FROM ",cl_get_target_table(l_plant_new,'oma_file'), #FUN-A50102 
                    "  WHERE oma99 ='",g_rvu.rvu99,"'",
                    "    AND oma00 = '12' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oma01_pre FROM l_sql
        DECLARE oma01_cs CURSOR FOR oma01_pre
        OPEN oma01_cs 
        FETCH oma01_cs INTO g_oma01                              #出貨單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch oma01_cs'
        #No.FUN-710030--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710030--End--
           LET g_success = 'N'
        END IF
        LET AR_t1=s_get_doc_no(g_oma01)           #No.CHI-920010
     END IF
END FUNCTION
 
FUNCTION p870_getno2(i) 
  DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(600)
  DEFINE i     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
         #IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm.pmm50)) THEN                          #MOD-630079
         IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm.pmm50) AND g_poz.poz011 = '1' ) THEN  #MOD-630079 #正拋時才需進入
            #LET l_sql = " SELECT rvu01 FROM ",l_dbs_new CLIPPED,"rvu_file ", #FUN-980092 mark
            #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092 add
            LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102 
                        "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                        "    AND rvu00 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE rvu01t_pre FROM l_sql
            DECLARE rvu01t_cs CURSOR FOR rvu01t_pre
            OPEN rvu01t_cs 
            FETCH rvu01t_cs INTO g_rvu01                              #倉退單
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs'
            #No.FUN-710030--Begin--
            #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
            #No.FUN-710030--End--
               LET g_success = 'N'
            END IF
 
            #LET l_sql = " SELECT apa01 FROM ",l_dbs_new CLIPPED,"apa_file ",
            LET l_sql = " SELECT apa01 FROM ",cl_get_target_table(l_plant_new,'apa_file'), #FUN-A50102
                        "  WHERE apa99 ='",g_rvu.rvu99,"'",
                        "    AND apa00 = '21' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE apa01t_pre FROM l_sql
            DECLARE apa01t_cs CURSOR FOR apa01t_pre
            OPEN apa01t_cs 
            FETCH apa01t_cs INTO g_apa01                             #付款單
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_new CLIPPED,'fetch apa01t_cs'
            #No.FUN-710030--Begin--
              #CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
            #No.FUN-710030--End--
               LET g_success = 'N'
            END IF
            LET AP_t1=s_get_doc_no(g_apa01)               #No.CHI-920010
         END IF
 
     IF i != 0 THEN
        #LET l_sql = " SELECT oha01 FROM ",l_dbs_new CLIPPED,"oha_file ", #FUN-980092 mark
        #LET l_sql = " SELECT oha01 FROM ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092 add
        LET l_sql = " SELECT oha01 FROM ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                    "  WHERE oha99 ='",g_rvu.rvu99,"'",
                    "    AND oha05 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE oha01_pre FROM l_sql
        DECLARE oha01_cs CURSOR FOR oha01_pre
        OPEN oha01_cs 
        FETCH oha01_cs INTO g_oga01                              #銷退單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch oha01_cs'
        #No.FUN-710030--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710030--End--
           LET g_success = 'N'
        END IF
      
        #LET l_sql = " SELECT oma01 FROM ",l_dbs_new CLIPPED,"oma_file ",
        LET l_sql = " SELECT oma01 FROM ",cl_get_target_table(l_plant_new,'oma_file'), #FUN-A50102
                    "  WHERE oma99 ='",g_rvu.rvu99,"'",
                    "    AND oma00 = '21' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oma01t_pre FROM l_sql
        DECLARE oma01t_cs CURSOR FOR oma01t_pre
        OPEN oma01t_cs 
        FETCH oma01t_cs INTO g_oma01                             #出貨單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch oma01t_cs'
        #No.FUN-710030--Begin--
        #  CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)
        #No.FUN-710030--End--
           LET g_success = 'N'
        END IF
        LET AR_t1=s_get_doc_no(g_oma01)           #No.CHI-920010
     END IF
END FUNCTION

#MOD-B20047 add --start-- 
#更新ogb60(已開發票數量)
FUNCTION p870_u_ogb60()
 DEFINE l_omb12 LIKE omb_file.omb12 
 DEFINE l_omb31 LIKE omb_file.omb31 
 DEFINE l_omb32 LIKE omb_file.omb32 
 DEFINE l_sql   LIKE type_file.chr1000   

  LET l_sql="SELECT omb31,omb32 FROM ",cl_get_target_table(l_plant_new,'omb_file'),
            " WHERE omb01 ='",g_oma01,"' "
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
  PREPARE omb_p1 FROM l_sql 
  IF STATUS THEN 
     CALL s_errmsg('','','omb_p1',STATUS,1)
  END IF
  DECLARE omb_curs1 CURSOR FOR omb_p1
  FOREACH omb_curs1 INTO l_omb31,l_omb32
     IF SQLCA.SQLCODE <> 0 THEN
        CALL s_errmsg('','','sel oga',STATUS,1) 
        EXIT FOREACH
     END IF
     #計算除本張帳款外的omb12
     LET l_sql = " SELECT SUM(omb12)  FROM ",cl_get_target_table(l_plant_new,'omb_file'),",",
                                             cl_get_target_table(l_plant_new,'oma_file'),
                 "  WHERE omb31='",l_omb31,"'", 
                 "    AND omb32='",l_omb32,"'",
                 "    AND omb01=oma01 AND omavoid='N' ",
                 "    AND omb01 !='",g_oma01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
     PREPARE omb12_pre FROM l_sql
     DECLARE sum_omb12 CURSOR FOR omb12_pre
     OPEN sum_omb12 
     FETCH sum_omb12 INTO l_omb12
     CLOSE sum_omb12
     IF cl_null(l_omb12) THEN LET l_omb12=0 END IF

     #更新ogb60
     LET l_sql = " UPDATE ",cl_get_target_table(l_plant_new,'ogb_file'), 
                 "    SET ogb60 = ? ",
                 "  WHERE ogb01 = '",l_omb31,"' ",
                 "    AND ogb03 = '",l_omb32,"' "
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
     PREPARE upd_ogb60 FROM l_sql
     EXECUTE upd_ogb60 USING l_omb12
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        IF SQLCA.SQLCODE <> 0 THEN
           CALL s_errmsg('','','upd ogb60:',SQLCA.SQLCODE,1)
        ELSE
           CALL s_errmsg('','','upd ogb60:','axm-981',1)
        END IF
        LET g_success='N' 
     END IF

  END FOREACH
END FUNCTION
#MOD-B20047 add --end-- 
