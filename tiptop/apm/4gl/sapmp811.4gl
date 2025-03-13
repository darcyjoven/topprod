# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp811.4gl
# Descriptions...: 三角貿易採購單拋轉還原作業
# Date & Author..: 01/11/08 By Tommy
# Modify.........: No.8083 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.若逆拋最終供應商的採購單性質為'REG'
# Modify.........: No.FUN-570252 05/12/27 By Sarah 拋轉還原需將特別說明與備註刪除
# Modify.........: No.FUN-620028 06/02/11 By Carrier 將apmp811拆開成apmp811及sapmp811
# Modify.........: No.FUN-620025 06/02/20 By cl 增加使用分銷功能后依流程代碼抓取訂單與采購單
# Modify.........: No.FUN-620054 06/03/08 By ice 增加對指定工廠的三角貿易采購單拋轉還原
# Modify.........: No.FUN-630040 06/03/22 By Nicola 多接收及回傳一個參數
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/08/28 by Yiting 因應多角改善專案，目前站別多一站，真正拋轉的站別在第二站，所以要從第二站還原
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-710030 07/02/05 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-740054 07/04/11 By claire aza50錯當成一單到底參數使用
# Modify.........: No.MOD-770154 07/08/01 By Claire apm-922錯寫應為apm-992
# Modify.........: NO.MOD-780030 07/08/08 By claire 備註的單號值不可取來源站應取各站的單號
# Modify.........: No.MOD-770112 07/08/10 By claire (1) 刪除訂單備註(oao_file)要與刪除訂單置於同段處理
#                                                   (2) 刪除採購備註(pmo_file)需確認非最終站且最終站有最後供應商
# Modify.........: No.MOD-770087 07/08/24 By claire 逆拋還原時確認是否已有已確認的出貨(通知)單單身含有該訂單號碼(與單一工廠的檢查一致)
# Modify.........: No.TQC-7C0036 07/12/06 By agatha 增加采購單號開窗
# Modify.........: No.MOD-810063 08/01/25 By claire 確認最後一站的so ,有無再轉PO
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-940364 09/04/28 By Dido 若為起單收貨需包含未確認問題,因此僅需排除已作廢單據
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.MOD-960061 09/06/04 By lilingyu 增加控管:若訂單已轉工單或采購單,給出提示信息,不允許還原
# Modify.........: No.FUN-870007 09/08/14 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-9C0155 09/12/17 By lilingyu 集團調撥atmt254過賬還原時,程序當出
# Modify.........: No.TQC-9C0177 09/12/29 By Dido 最終站供應商檢核採購單是否存在收貨單應以最終站採購單
# Modify.........: No:MOD-A30133 10/03/19 By Smapmin 判斷是否存在請/採購單時,要排除作廢的單據
# Modify.........: No:MOD-A30136 10/03/19 By Smapmin 判斷是否存在工單時,要排除作廢的單據
# Modify.........: No:MOD-A30225 10/03/30 By Smapmin 增加控管"已存在採購變更單不允許多角採購單拋轉還原"
# Modify.........: No:TQC-A50061 10/05/18 By lilingyu 訂單分配多角拋轉還原時的相關邏輯處理
# Modify.........: No.FUN-A50102 10/07/15 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-BB0086 11/11/08 By lilingyu 重新過單
# Modify.........: No:TQC-BB0196 11/11/22 By suncx atmt254還原過賬BUG處理
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/axmp503.global"                 #TQC-A50061
 
DEFINE g_pmm   RECORD LIKE pmm_file.*                  #TQC-BB0086
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE tm RECORD
          pmm01  LIKE pmm_file.pmm01
       END RECORD
DEFINE g_poz           RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8083
DEFINE g_poy           RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083
DEFINE l_dbs_new       LIKE type_file.chr21      #No.FUN-680136 VARCHAR(21)    #New DataBase Name
DEFINE l_azp           RECORD LIKE azp_file.*
DEFINE g_sw            LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
#DEFINE g_argv1         LIKE pmm_file.pmm01
DEFINE g_argv1         STRING   #No.FUN-630040
DEFINE g_argv2         LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)   #No.FUN-630040
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE g_flag          LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE g_msg           LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE g_oea01         LIKE oea_file.oea01       # No.FUN-620025
DEFINE g_pmm01         LIKE pmm_file.pmm01       # No.FUN-620025
DEFINE l_aza50         LIKE aza_file.aza50       # No.FUN-620025
DEFINE g_wc            STRING    #No.FUN-630040
DEFINE l_plant_new     LIKE azp_file.azp01     #FUN-980092 add
DEFINE l_dbs_tra       LIKE azw_file.azw05     #FUN-980092 add
 
#No.FUN-620028  --Begin
FUNCTION p811(p_argv1,p_argv2)   #No.FUN-630040
   DEFINE l_time        LIKE type_file.chr8                   #計算被使用時間  #No.FUN-680136 VARCHAR(8)
  #DEFINE p_argv1       LIKE pmm_file.pmm01
   DEFINE p_argv1       STRING    #No.FUN-630040
   DEFINE p_argv2       LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)   #No.FUN-630040
 
   WHENEVER ERROR CONTINUE
  
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2   #No.FUN-630040
 
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      CALL p811_p1()
   ELSE
      #-----No.FUN-630040-----
      IF g_argv2 = "A" THEN
         LET g_wc = g_argv1
         OPEN WINDOW win2 AT 10,5 WITH 6 ROWS,70 COLUMNS 
         CALL p811_p2('','')                     #No.FUN-620054
         CALL s_showmsg()       #No.FUN-710030
         IF g_success = 'Y' THEN 
          # CALL cl_cmmsg(1) 
            COMMIT WORK
         ELSE 
          # CALL cl_rbmsg(1)
            ROLLBACK WORK
         END IF
         CLOSE WINDOW win2
      ELSE
         LET tm.pmm01 = g_argv1
         OPEN WINDOW win AT 10,5 WITH 6 ROWS,70 COLUMNS 
         CALL p811_p2('','')                     #No.FUN-620054
         CALL s_showmsg()       #No.FUN-710030
         IF g_success = 'Y' THEN 
            CALL cl_cmmsg(1) 
            COMMIT WORK
         ELSE 
            CALL cl_rbmsg(1)
            ROLLBACK WORK
         END IF
         CLOSE WINDOW win
      END IF
      #-----No.FUN-630040 END-----
   END IF
 
   RETURN g_success   #No.FUN-630040
 
END FUNCTION
#No.FUN-620028  --Begin
 
FUNCTION p811_p1()
 DEFINE l_ac LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_i LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   LET p_row = 4 LET p_col = 35
  
   OPEN WINDOW p811_w AT p_row,p_col WITH FORM "apm/42f/apmp811" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
  
   CALL cl_opmsg('z')
  
   DISPLAY BY NAME tm.pmm01
 
   WHILE TRUE
      ERROR ''
      INPUT BY NAME tm.pmm01  WITHOUT DEFAULTS  
           AFTER FIELD pmm01
              IF NOT cl_null(tm.pmm01) THEN
                 SELECT * INTO g_pmm.* FROM pmm_file
                  WHERE pmm01=tm.pmm01
                 IF SQLCA.SQLCODE THEN
#                   CALL cl_err('sel pmm',SQLCA.SQLCODE,0)   #No.FUN-660129
                    CALL cl_err3("sel","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","sel pmm",1)  #No.FUN-660129
                    NEXT FIELD pmm01 
                 END IF
                 IF g_pmm.pmm901='N' OR g_pmm.pmm901 IS NULL THEN
                    CALL cl_err(g_pmm.pmm901,'apm-021',0)  # 非三角貿易採購單no.7603
                    NEXT FIELD pmm01 
                 END IF
                 IF g_pmm.pmm905='N' THEN
                   #CALL cl_err(g_pmm.pmm905,'apm-922',0)  # 此採購單尚未拋轉no.7603  #MOD-770154 mark
                    CALL cl_err(g_pmm.pmm905,'apm-992',1)  #MOD-770154 add
                    NEXT FIELD pmm01 
                 END IF
                 IF g_pmm.pmm906 <>'Y' THEN
                    CALL cl_err(g_pmm.pmm906,'apm-021',0)  # 非來源採購單    no.7603
                    NEXT FIELD pmm01 
                 END IF
              END IF
       #TQC-7C0036   ----begin-------
        ON ACTION CONTROLP
         CASE
           WHEN INFIELD (pmm01)
             CALL cl_init_qry_var()                                                                                             
           #  LET g_qryparam.state = "c"                                                                                         
             LET g_qryparam.form ="q_pmm01b"                                                                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret 
             LET tm.pmm01=g_qryparam.multiret 
             DISPLAY BY NAME  tm.pmm01
             NEXT FIELD pmm01
        END CASE 
       #TQC-7C0036   ----end---------
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG call cl_cmdask()
 
        ON ACTION locale                    #genero
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
  
     IF g_action_choice = "locale" THEN  #genero
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE 
     END IF
  
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE 
     END IF
  
     IF NOT cl_sure(0,0) THEN CONTINUE WHILE END IF
     CALL p811_p2('','')                        #No.FUN-620054
     IF g_success = 'Y' THEN 
        COMMIT WORK
        CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
     ELSE
        ROLLBACK WORK
        CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
     END IF
 
     IF g_flag THEN
        CONTINUE WHILE
     ELSE
        EXIT WHILE
     END IF
   END WHILE
   CLOSE WINDOW p811_w
END FUNCTION
 
#FUNCTION p811_p2(p_pmm01,p_dbs)               #No.FUN-620054 #FUN-980092 mark 
FUNCTION p811_p2(p_pmm01,p_plant)               #No.FUN-620054  #FUN-980092 add
  DEFINE p_pmm01  LIKE pmm_file.pmm01         #No.FUN-620054
  DEFINE p_dbs    LIKE type_file.chr21      #No.FUN-680136 VARCHAR(21)  #No.FUN-620054
  DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE p_last   LIKE type_file.num5       #No.FUN-680136 SMALLINT     #流程之最後家數
  DEFINE p_last_plant LIKE type_file.chr10  #No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
  DEFINE l_sql1   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_j    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_msg  LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(60)
  DEFINE l_count    LIKE type_file.num5         #MOD-960061
  DEFINE l_sql811   STRING                      #MOD-960061 
  DEFINE p_plant    LIKE azp_file.azp01   #FUN-980092 add
  DEFINE l_azp03    LIKE azp_file.azp03   #FUN-980092 add
  DEFINE l_dbs      LIKE azw_file.azw05   #FUN-980092 add
  
   CALL cl_wait() 
   
   #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
      LET p_dbs = s_dbstring(l_azp03) 
 
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
   #--End   FUN-980092 add-------------------------------------
 
   #No.FUN-620054 --start--
   IF cl_null(p_pmm01) AND cl_null(p_dbs) THEN
      BEGIN WORK 
   END IF
   #No.FUN-620054 --end--
   LET g_success='Y'
 
   #No.FUN-620054 --start--
   IF cl_null(p_pmm01) AND cl_null(p_dbs) THEN
      #-----No.FUN-630040-----
      IF g_argv2 = "A" THEN
         LET l_sql = " SELECT * FROM pmm_file ",
                     "  WHERE ",g_wc CLIPPED
         PREPARE pmm1_pre FROM l_sql
         EXECUTE pmm1_pre INTO g_pmm.*
      ELSE
         SELECT * INTO g_pmm.* FROM pmm_file
          WHERE pmm01=tm.pmm01
      END IF
      #-----No.FUN-630040 END-----
   ELSE
      #LET l_sql = " SELECT * FROM ",p_dbs CLIPPED,"pmm_file ", #FUN-980092 mark
      #LET l_sql = " SELECT * FROM ",l_dbs CLIPPED,"pmm_file ",  #FUN-980092 add   #FUN-A50102 mark
      #LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'pmn_file'),  #FUN-A50102   #TQC-BB0196 mark
       LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'pmm_file'),  #TQC-BB0196
                  "  WHERE pmm01 = '",p_pmm01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       # CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092    #FUN-A50102 mark
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql                    #FUN-A50102 
      PREPARE pmm_pre FROM l_sql
      EXECUTE pmm_pre INTO g_pmm.*
   END IF
   #No.FUN-620054  --end--
   IF SQLCA.SQLCODE THEN
      CALL cl_err('sel pmm',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_pmm.pmm901='N' OR g_pmm.pmm901 IS NULL THEN
      CALL cl_err(g_pmm.pmm901,'axm-023',1) 
      LET g_success = 'N'
      RETURN                                         # 非三角貿易採購單
   END IF
   IF g_pmm.pmm905='N' THEN
      CALL cl_err(g_pmm.pmm905,'apm-992',1) 
      LET g_success = 'N'
      RETURN                                         # 此採購單尚未拋轉
   END IF
   IF g_pmm.pmm906 <>'Y' THEN
      CALL cl_err(g_pmm.pmm906,'apm-991',1) 
      LET g_success = 'N'
      RETURN                                         # 非來源採購單
   END IF
 
   LET l_cnt=0
   #No.FUN-620054  --start--
   IF cl_null(p_pmm01) AND cl_null(p_dbs) THEN
      SELECT COUNT(*) INTO l_cnt FROM rvb_file,rva_file
       WHERE rvb04 =g_pmm.pmm01
         AND rva01=rvb01
        #AND rvaconf='Y'   #MOD-940364 mark
         AND rvaconf<>'X'  #MOD-940364 add
   ELSE
      LET l_sql = " SELECT COUNT(*) ",
                  #"   FROM ",p_dbs CLIPPED,"rvb_file,",p_dbs CLIPPED,"rva_file ", #FUN-980092 mark
                 #"   FROM ",l_dbs CLIPPED,"rvb_file,",l_dbs CLIPPED,"rva_file ",  #FUN-980092 add     #FUN-A50102 mark
                  "   FROM ",cl_get_target_table(p_plant,'rva_file'),          #FUN-A50102
                  "  WHERE rvb04 = '",g_pmm.pmm01,"' ",
                  "    AND rva01 = rvb01 ",
                 #"    AND rvaconf='Y' "  #MOD-940364 mark
                  "    AND rvaconf<>'X' " #MOD-940364 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       # CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092      #FUN-A50102 mark
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql                      #FUN-A50102         
      PREPARE rva_pre FROM l_sql
      EXECUTE rva_pre INTO l_cnt
   END IF
   #No.FUN-620054  --end--
   IF l_cnt >0 AND NOT cl_null(l_cnt) THEN
      CALL cl_err(g_pmm.pmm906,'apm-407',1) 
      LET g_success = 'N'
      RETURN
   END IF

   #-----MOD-A30225---------
   LET l_cnt=0
   SELECT count(*) INTO l_cnt 
      FROM pna_file
      WHERE pna01 = g_pmm.pmm01 
        AND pnaconf = 'Y'
   IF l_cnt >0 THEN
      CALL cl_err(g_pmm.pmm01,'apm-595',1) 
      LET g_success = 'N'
      RETURN
   END IF
   #-----END MOD-A30225-----
 
{
  #保留此段, 若條件改成construct多筆時只要把mark拿掉
  #讀取符合條件之三角貿易採購單資料
  LET l_sql="SELECT * FROM pmm_file ",
            " WHERE pmm01 ='",tm.pmm01,"' ",
             " AND pmm901='Y' ",
             " AND pmm905='Y' ",
             " AND pmm906='Y' ",
             " AND pmmconf='Y' "      #已確認之採購單才可轉
  PREPARE p811_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('pre1',SQLCA.SQLCODE,1) END IF
  LET g_success='Y' 
  DECLARE p811_curs1 CURSOR FOR p811_p1
  FOREACH p811_curs1 INTO g_pmm.*
     IF SQLCA.SQLCODE THEN
        CALL cl_err(foreach p811_curs1',status,1) 
        LET g_success = 'N'
        EXIT FOREACH
     END IF
}
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
            RETURNING p_last,p_last_plant  #記錄最後一筆之家數
     #依流程代碼最多6層
     FOR i = 1 TO p_last   #FUN-670007
           #得到廠商/客戶代碼及database
         # CALL p811_azp(i,p_dbs)          #No.FUN-620054       #FUN-A50102 mark
           CALL p811_azp(i)                #FUN-A50102
           #刪除訂單單頭檔(pmm_file)
           #FUN-620025--begin--
           #IF l_aza50 = 'Y' THEN   #TQC-740054 mark
              #LET l_sql = " SELECT oea01 FROM ",l_dbs_new CLIPPED,"oea_file ", #FUN-980092 mark
             #LET l_sql = " SELECT oea01 FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 mark  #FUN-A50102 mark
              LET l_sql = " SELECT oea01 FROM ",cl_get_target_table(l_plant_new,'oea_file'),      #FUN-A50102
                          "  WHERE oea99 ='",g_pmm.pmm99,"'"
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              PREPARE oea01_pre FROM l_sql
              DECLARE oea01_cs CURSOR FOR oea01_pre
              OPEN oea01_cs 
              FETCH oea01_cs INTO g_oea01   
              IF SQLCA.SQLCODE THEN
                 #LET g_msg = l_dbs_new CLIPPED,'fetch oea01_cs'  #FUN-980092 mark
                 LET g_msg = l_dbs_tra CLIPPED,'fetch oea01_cs'   #FUN-980092 add
#No.FUN-710030 -- begin --
#                 CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                 ELSE
                   #CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)  #MOD-9C0155
                    CALL cl_err3("sel","oea_file",g_pmm.pmm99,"",SQLCA.sqlcode,"",g_msg,1)  #MOD-9C0155
                 END IF
#No.FUN-710030 -- end --
                 LET g_success = 'N'
              END IF
           #TQC-740054-begin-mark
           #ELSE
           #   LET g_oea01=g_pmm.pmm01
           #END IF 
           #TQC-740054-end-mark
           #FUN-620025--end--
 
#MOD-960061 --begin--   
         #LET l_sql811 = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"sfb_file", #FUN-980092 mark
         #LET l_sql811 = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"sfb_file",  #FUN-980092 add    #FUN-A50102 mark
          LET l_sql811 = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'sfb_file'),      #FUN-A50102
                        " WHERE sfb22 = ? ",
                        "   AND sfb87 <> 'X'"   #MOD-A30136
         CALL cl_replace_sqldb(l_sql811) RETURNING l_sql811             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql811,l_plant_new) RETURNING l_sql811 #FUN-980092
         PREPARE p811_sfb FROM l_sql811
         EXECUTE p811_sfb INTO l_count USING g_oea01
         IF l_count > 0 THEN 
             #LET g_msg = l_dbs_new CLIPPED,'sel sfb:' #FUN-980092 mark
             LET g_msg = l_dbs_tra CLIPPED,'sel sfb:'  #FUN-980092 add
             IF g_bgerr THEN
                CALL s_errmsg("","",g_msg,'apm-119',1)
             ELSE
                CALL cl_err3("","","","",'apm-119',"",g_msg,1)
             END IF
             LET g_success='N' 
         END IF   
 
         #LET l_sql811 = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"pmn_file", #FUN-980092 mark
         #LET l_sql811 = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 add   #MOD-A30133
         #LET l_sql811 = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"pmn_file,",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add   #MOD-A30133  #FUN-A50102 mark
          LET l_sql811 = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",", #FUN-A50102
                                                 cl_get_target_table(l_plant_new,'pmn_file'),     #FUN-A50102
                        " WHERE pmn24 = ? ",
                        "   AND pmm01 = pmn01",   #MOD-A30133
                        "   AND pmm18 <> 'X'"   #MOD-A30133
         CALL cl_replace_sqldb(l_sql811) RETURNING l_sql811             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql811,l_plant_new) RETURNING l_sql811 #FUN-980092
         PREPARE p811_pmn FROM l_sql811
         EXECUTE p811_pmn INTO l_count USING g_oea01
         IF l_count > 0 THEN 
             #LET g_msg = l_dbs_new CLIPPED,'sel pmn:'  #FUN-980092 mark
             LET g_msg = l_dbs_tra CLIPPED,'sel pmn:'   #FUN-980092 add
             IF g_bgerr THEN
                CALL s_errmsg("","",g_msg,'apm-231',1)
             ELSE
                CALL cl_err3("","","","",'apm-231',"",g_msg,1)
             END IF
             LET g_success='N' 
         END IF                                  
#MOD-960061 --end--           

           
           #LET l_sql2= " DELETE FROM ",l_dbs_new CLIPPED,"oea_file",  #FUN-980092 mark
           #LET l_sql2= " DELETE FROM ",l_dbs_tra CLIPPED,"oea_file", #FUN-980092 add        #FUN-A50102 mark
            LET l_sql2= " DELETE FROM ",cl_get_target_table(l_plant_new,'oea_file'),         #FUN-A50102
                       "  WHERE oea01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_oea FROM l_sql2
           EXECUTE del_oea USING g_oea01         #FUN-620025 
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              #LET g_msg = l_dbs_new CLIPPED,'del oea:'  #FUN-980092 mark
              LET g_msg = l_dbs_tra CLIPPED,'del oea:'   #FUN-980092 add
#No.FUN-710030 -- begin --
#              CALL cl_err(g_msg,SQLCA.SQLCODE,1)
              IF g_bgerr THEN
                 CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              END IF
#No.FUN-710030 -- end --
              LET g_success='N' 
           END IF
 

           #刪除訂單身檔
           #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"oeb_file", #FUN-980092 mark
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add   #FUN-A50102 mark
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oeb_file'),     #FUN-A50102
                    " WHERE oeb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_oeb FROM l_sql2
           EXECUTE del_oeb USING g_oea01         #FUN-620025
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]= 0 THEN
              LET g_msg = l_dbs_new CLIPPED,'del oeb:'
#No.FUN-710030 -- begin --
#              CALL cl_err(g_msg,SQLCA.SQLCODE,1)
              IF g_bgerr THEN
                 CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              END IF
#No.FUN-710030 -- end --
              LET g_success='N' 
           #No.FUN-7B0018 080305 add --begin
           ELSE
              IF NOT s_industry('std') THEN
                 #IF NOT s_del_oebi(g_oea01,'',l_dbs_new) THEN  #FUN-980092 mark
                 IF NOT s_del_oebi(g_oea01,'',l_plant_new) THEN #FUN-980092 add
                    LET g_success = 'N'
                 END IF
              END IF
           #No.FUN-7B0018 080305 add --end
           END IF


         #MOD-770112-begin-add
           #刪除備註
          #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"oao_file",                 #FUN-A50102 mark
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oao_file'),  #FUN-A50102 
                      " WHERE oao01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2                  #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2      #FUN-A50102
           PREPARE del_oao FROM l_sql2
          #EXECUTE del_oao USING g_pmm.pmm01   #MOD-780030 mark
           EXECUTE del_oao USING g_oea01       #MOD-780030 
           IF SQLCA.SQLCODE <> 0 THEN
              LET g_success='N'
              IF g_bgerr THEN
                 CALL s_errmsg("","","del oao",SQLCA.sqlcode,1)
                 CONTINUE FOR
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","del oao",1)
                 EXIT FOR
              END IF
           END IF
         #MOD-770112-end-add
 
          #MOD-810063-begin-add
           #若為最後一站且已將訂單拋一段採購單,請購單不可還原
           IF i = p_last  THEN
              LET l_cnt=0
              LET l_sql = " SELECT COUNT(*) ",
                          #"   FROM ",l_dbs_new CLIPPED,"pmm_file,",l_dbs_new CLIPPED,"pmn_file ", #FUN-980092 mark
                          #"   FROM ",l_dbs_tra CLIPPED,"pmm_file,",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980092 add    #FUN-A50102 mark
                           "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'),",",              #FUN-A50102
                                      cl_get_target_table(l_plant_new,'pmn_file'),                  #FUN-A50102        
                          "  WHERE pmn24 = '",g_oea01,"' ",
                          "    AND pmn01 = pmm01 ",
                          "    AND pmm909 = '3' ",
                          "    AND pmm18 <> 'X' "   #MOD-A30133
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
              PREPARE pmn_pre FROM l_sql
              EXECUTE pmn_pre INTO l_cnt
              IF l_cnt >0  THEN
                 #LET g_msg=l_dbs_new CLIPPED,' ',g_oea01  #FUN-980092 mark
                 LET g_msg=l_dbs_tra CLIPPED,' ',g_oea01   #FUN-980092 add
                 CALL cl_err(g_msg,'mfg9118',1)   #最終站已拋採購單
                 LET g_success = 'N'
              END IF
              LET l_cnt=0
              LET l_sql = " SELECT COUNT(*) ",
                          #"   FROM ",l_dbs_new CLIPPED,"pml_file ", #FUN-980092 mark
                          #"   FROM ",l_dbs_tra CLIPPED,"pml_file ",  #FUN-980092 add   #MOD-A30133
                          #"   FROM ",l_dbs_tra CLIPPED,"pml_file,",l_dbs_tra CLIPPED,"pmk_file ", #FUN-980092 add   #MOD-A30133 #FUN-A50102
                          "    FROM ",cl_get_target_table(l_plant_new,'pml_file'),",",  #FUN-A50102 
                                      cl_get_target_table(l_plant_new,'pmk_file'),      #FUN-A50102
                          "  WHERE pml24 = '",g_oea01,"' ",
                          "    AND pml01 = pmk01 ",   #MOD-A30133
                          "    AND pmk18 <> 'X' "     #MOD-A30133
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
              PREPARE pml_pre FROM l_sql
              EXECUTE pml_pre INTO l_cnt
              IF l_cnt >0  THEN
                 #LET g_msg=l_dbs_new CLIPPED,' ',g_oea01  #FUN-980092 mark
                 LET g_msg=l_dbs_tra CLIPPED,' ',g_oea01   #FUN-980092 add
                 CALL cl_err(g_msg,'axm-001',1)   #最終站已拋請購單
                 LET g_success = 'N'
              END IF
           END IF
          #MOD-810063-end-add
 
          #MOD-770087-begin-add
           LET l_cnt=0
           #若為逆拋且已有出貨(通知)單已確認,則不可刪除
           IF i = p_last AND  g_poz.poz011='2' THEN
              LET l_sql = " SELECT COUNT(*) ",
                          #"   FROM ",l_dbs_new CLIPPED,"ogb_file,",l_dbs_new CLIPPED,"oga_file ", #FUN-980092 mark
                          #"   FROM ",l_dbs_tra CLIPPED,"ogb_file,",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092 add   #FUN-A50102 mark
                           "   FROM ",cl_get_target_table(l_plant_new,'ogb_file'),",", #FUN-A50102 
                                      cl_get_target_table(l_plant_new,'oga_file'),     #FUN-A50102  
                          "  WHERE ogb31 = '",g_oea01,"' ",
                          "    AND oga01 = ogb01 ",
                          "    AND ogaconf <> 'X' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
              PREPARE ogb_pre FROM l_sql
              EXECUTE ogb_pre INTO l_cnt
              IF l_cnt >0 AND NOT cl_null(l_cnt) THEN
                 #CALL cl_err(l_dbs_new,'axm-407',1)   #已有出貨(通知)單確認
                 CALL cl_err(l_dbs_tra,'axm-407',1)   #已有出貨(通知)單確認
                 LET g_success = 'N'
              END IF
           END IF
          #MOD-770087-end-add
 
         IF i != p_last OR (i = p_last AND NOT cl_null(g_pmm.pmm50)) THEN
           #No.8083
           #若為逆拋且最終供應商採購單已有收貨資料了，則不可刪除
           IF i = p_last AND NOT cl_null(g_pmm.pmm50) AND g_poz.poz011='2' THEN
              LET g_cnt = 0 
              LET l_sql2 = " SELECT COUNT(*) ",
                          #"   FROM ",l_dbs_new CLIPPED,"rvb_file ",     #FUN-980092 mark
                          #"   FROM ",l_dbs_tra CLIPPED,"rvb_file,",     #FUN-980092 add    #FUN-A50102 mark 
                          #"        ",l_dbs_tra CLIPPED,"pmm_file ",     #TQC-9C0177        #FUN-A50102 mark
                           "   FROM ",cl_get_target_table(l_plant_new,'rvb_file'),",",      #FUN-A50102
                                      cl_get_target_table(l_plant_new,'pmm_file'),          #FUN-A50102     
                          #"  WHERE rvb04 = '",g_pmm.pmm01,"'"           #TQC-9C0177 mark
                           "  WHERE rvb04 = pmm01 ",                     #TQC-9C0177
                           "    AND pmm99 = '",g_pmm.pmm99,"'"           #TQC-9C0177
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE count_rvb_pre FROM l_sql2
              DECLARE count_rvb CURSOR FOR count_rvb_pre
              OPEN count_rvb 
              FETCH count_rvb INTO g_cnt
              IF g_cnt > 0 THEN
                 #LET g_msg = l_dbs_new CLIPPED,g_pmm.pmm50  #FUN-980092 mark
                 LET g_msg = l_dbs_tra CLIPPED,g_pmm.pmm50   #FUN-980092 add
#No.FUN-710030 -- begin --
#                 CALL cl_err(g_msg,'tri-017',1)
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,"tri-017",1)
                 ELSE
                    CALL cl_err3("","","","","tri-017","",g_msg,1)
                 END IF
#No.FUN-710030 -- end --
                 LET g_success = 'N'
              END IF
           END IF
           #No.8083(end)
           #刪除採購單單頭檔
           #FUN-620025--begin--
           #IF l_aza50 = 'Y' THEN   #TQC-740054 mark
              IF i != p_last OR (i = p_last AND NOT cl_null(g_pmm.pmm50)) THEN
                 #No.FUN-870007-start-
                 IF g_azw.azw04='2' THEN
                    #LET l_sql = " SELECT pmm01 FROM ",l_dbs_new CLIPPED,"pmm_file ", #FUN-980092 mark
                    #LET l_sql = " SELECT pmm01 FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add    #FUN-A50102 mark
                    LET l_sql = "  SELECT pmm01 FROM ",cl_get_target_table(l_plant_new,'pmm_file'),       #FUN-A50102
                                "  WHERE pmm99 ='",g_pmm.pmm99,"'",
                                "    AND pmmplant='",g_poy.poy04,"'"
                 ELSE
                 #No.FUN-870007--end--
                 #LET l_sql = " SELECT pmm01 FROM ",l_dbs_new CLIPPED,"pmm_file ",  #FUN-980092 mark
                 #LET l_sql = " SELECT pmm01 FROM ",l_dbs_tra CLIPPED,"pmm_file ",   #FUN-980092 add      #FUN-A50102 mark
                  LET l_sql = " SELECT pmm01 FROM ",cl_get_target_table(l_plant_new,'pmm_file'),          #FUN-A50102
                             "  WHERE pmm99 ='",g_pmm.pmm99,"'"
                 END IF   #No.FUN-870007
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE pmm01_pre FROM l_sql
                 DECLARE pmm01_cs CURSOR FOR pmm01_pre
                 OPEN pmm01_cs 
                 FETCH pmm01_cs INTO g_pmm01  
                 IF SQLCA.SQLCODE THEN
                    #LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs' #FUN-980092 mark
                    LET g_msg = l_dbs_tra CLIPPED,'fetch rvu01_cs' #FUN-980092 add
#No.FUN-710030 -- begin --
                    CALL cl_err(g_msg,SQLCA.SQLCODE,1)
#                    LET g_success = 'N'
                    IF g_bgerr THEN
                       CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                    END IF
#No.FUN-710030 -- end --
                 END IF
              END IF
           #TQC-740054-begin-mark
           #ELSE
           #   LET g_pmm01=g_pmm.pmm01
           #END IF 
           #TQC-740054-end-mark
           #FUN-620025--end--



           #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"pmm_file", #FUN-980092 mark
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add      #FUN-A50102 mark
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'pmm_file'),        #FUN-A50102
                    " WHERE pmm01= ? ",
                    "   AND pmm901='Y' AND pmm905='Y' "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_pmm1 FROM l_sql2
           EXECUTE del_pmm1 USING g_pmm01        #FUN-620025
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              #LET g_msg = l_dbs_new CLIPPED,'del pmm:' #FUN-980092 mark
              LET g_msg = l_dbs_tra CLIPPED,'del pmm:'  #FUN-980092 add
#No.FUN-710030 -- begin --
#              CALL cl_err(g_msg,SQLCA.SQLCODE,1)
              IF g_bgerr THEN
                 CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              END IF
#No.FUN-710030 -- end --
              LET g_success='N' 
           END IF
       

           #刪除採購單單身檔
           #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"pmn_file", #FUN-980092 mark
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 add   #FUN-A50102 mark
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'pmn_file'),     #FUN-A50102 
                    " WHERE pmn01= ? " 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_pmn2 FROM l_sql2
           EXECUTE del_pmn2 USING g_pmm01        #FUN-620025
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              #LET g_msg = l_dbs_new CLIPPED,'del pmn:' #FUN-980092 mark
              LET g_msg = l_dbs_tra CLIPPED,'del pmn:'  #FUN-980092 add
#No.FUN-710030 -- begin --
#              CALL cl_err(g_msg,SQLCA.SQLCODE,1)
              IF g_bgerr THEN
                 CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
              END IF
#No.FUN-710030 -- end --
              LET g_success='N' 
           #No.FUN-7B0018 080306 add --begin
           ELSE
              IF NOT s_industry('std') THEN
                 #IF NOT s_del_pmni(g_pmm01,'',l_dbs_new) THEN  #FUN-980092 mark
                 IF NOT s_del_pmni(g_pmm01,'',l_plant_new) THEN #FUN-980092 add
                    LET g_success = 'N'
                 END IF
              END IF
           #No.FUN-7B0018 080306 add --end
           END IF
 
          #start FUN-570252
           #刪除特別說明
           #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"pmo_file",  #FUN-980092 mark
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"pmo_file",   #FUN-980092 add   #FUN-A50102 mark
            LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'pmo_file'),      #FUN-A50102
                      " WHERE pmo01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_pmo FROM l_sql2
          #EXECUTE del_pmo USING g_pmm.pmm01   #MOD-780030 mark
           EXECUTE del_pmo USING g_pmm01       #MOD-780030 
           IF SQLCA.SQLCODE <> 0 THEN
#No.FUN-710030 -- begin --
#              CALL cl_err('del pmo',STATUS,1) LET g_success='N' EXIT FOR
              LET g_success='N'
              IF g_bgerr THEN
                 CALL s_errmsg("","","del pmo",SQLCA.sqlcode,1)
                 CONTINUE FOR
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","del pmo",1)
                 EXIT FOR
              END IF
#No.FUN-710030 -- end --
           END IF

         #MOD-770112-begin-mark
         #  #刪除備註
         #  LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"oao_file",
         #             " WHERE oao01= ? "
         #  PREPARE del_oao FROM l_sql2
         #  EXECUTE del_oao USING g_pmm.pmm01
         #  IF SQLCA.SQLCODE <> 0 THEN
         #     CALL cl_err('del oao',STATUS,1) LET g_success='N' EXIT FOR
         #  END IF
##No.FUN-710030 -- begin --
##              CALL cl_err('del oao',STATUS,1) LET g_success='N' EXIT FOR
#              LET g_success='N'
#              IF g_bgerr THEN
#                 CALL s_errmsg("","","del oao",SQLCA.sqlcode,1)
#                 CONTINUE FOR
#              ELSE
#                 CALL cl_err3("","","","",SQLCA.sqlcode,"","del oao",1)
#                 EXIT FOR
#              END IF
##No.FUN-710030 -- end --
         # END IF
         #MOD-770112-end-mark
          #end FUN-570252
         END IF
       END FOR
#No.FUN-710030 -- begin --
       IF g_totsuccess="N" THEN
          LET g_success="N"
       END IF
#No.FUN-710030 -- end --
       LET i = i
       #更新採購單之拋轉否='N'
       #No.FUN-620054 --start--
       IF cl_null(p_pmm01) AND cl_null(p_dbs) THEN
#TQC-A50061 --begin--
         IF g_code = 'axmp503' THEN 
            IF g_total_1 = g_total_sum THEN          
               UPDATE pmm_file
                  SET pmm905='N',
                      pmm99 = ' ',       
                      pmmsseq=0,
                      pmm16 = 0  
                WHERE pmm901='Y'          
                  AND pmm01 =g_pmm.pmm01                         
            END IF     
         ELSE
#TQC-A50061 --end--        
          UPDATE pmm_file
             SET pmm905='N',
                 pmm99 = ' ',        #No.8083
                 pmmsseq=0,
                 pmm16 = 0  
           WHERE pmm901='Y'          #三角貿易採購單
             AND pmm01 =g_pmm.pmm01
         END IF          #TQC-A50061                
       ELSE
          #LET l_sql = " UPDATE ",p_dbs CLIPPED,"pmm_file ", #FUN-980092 mark
          #LET l_sql = " UPDATE ",l_dbs CLIPPED,"pmm_file ",  #FUN-980092 add  #FUN-A50102 mark
           LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'pmm_file'), #FUN-A50102 
                      "    SET pmm905='N', ",
                      "        pmm99 = ' ', ",      #No.8083
                      "        pmmsseq=0, ",
                      "        pmm16 = 0  ",
                      "  WHERE pmm901='Y' ",         #三角貿易採購單
                      "    AND pmm01 ='",g_pmm.pmm01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092     #FUN-A50102 mark
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql                     #FUN-A50102
          PREPARE upd_pmm_pre FROM l_sql
          EXECUTE upd_pmm_pre 
       END IF
       #No.FUN-620054 --end--
       #MOD-4A0340
#TQC-A50061 --begin--
      IF g_code = 'axmp503' THEN 
         IF STATUS THEN 
            CALL cl_err('',STATUS,0)
            LET g_success = 'N'
         END IF 
      ELSE
#TQC-A50061 --end--        
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
#No.FUN-710030 -- begin --
#          CALL cl_err('upd pmm',STATUS,1)
          IF g_bgerr THEN
             CALL s_errmsg("","","upd pmm",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","upd pmm",1)
          END IF
#No.FUN-710030 -- end --
          LET g_success='N' 
       END IF
      END IF     #TQC-A50061           
       #--
       #刪除簽核過程檔
       #No.FUN-620054 --start--
       IF cl_null(p_pmm01) AND cl_null(p_dbs) THEN
          DELETE FROM azd_file WHERE azd01 = g_pmm.pmm01 AND azd02 = 5
       ELSE 
         #LET l_sql = " DELETE FROM ",p_dbs CLIPPED,"azd_file  ",                  #FUN-A50102 mark
          LET l_sql = " DELETE FROM ",cl_get_target_table(p_plant,'azd_file'), #FUN-A50102  
                      "  WHERE azd01 = '",g_pmm.pmm01,"' ",
                      "    AND azd02 = 5 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql     #FUN-A50102
          PREPARE del_azd FROM l_sql
          EXECUTE del_azd 
       END IF
       #No.FUN-620054 --end--
       IF SQLCA.SQLCODE <> 0 THEN
          LET g_success='N' 
       END IF
# END FOREACH     
END FUNCTION
 
#FUNCTION p811_azp(l_i,p_dbs)   #No.FUN-620054  #FUN-A50102 mark
FUNCTION p811_azp(l_i)          #FUN-A50102 ` 
  DEFINE p_dbs       LIKE type_file.chr21   #No.FUN-680136 VARCHAR(21)  #No.FUN-620054
  DEFINE l_i         LIKE type_file.num5    #當站  #No.FUN-680136 SMALLINT
  DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
 
     ##-------------取得當站資料庫----------------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
#    LET l_dbs_new = l_azp.azp03 CLIPPED,"."   #TQC-950010 MARK                                                                     
     LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950010 ADD   
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
     #No.FUN-620025--begin 
     LET l_sql1 = "SELECT aza50 ",  
                # "  FROM ",l_dbs_new CLIPPED,"aza_file ",               #FUN-A50102 mark
                  "  FROM ",cl_get_target_table(g_poy.poy04,'aza_file'), #FUN-A50102
                  "  WHERE aza01 = '0' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1             #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,g_poy.poy04) RETURNING l_sql1 #FUN-A50102
     PREPARE aza_p1 FROM l_sql1 
     IF SQLCA.SQLCODE THEN CALL cl_err('aza_p1',SQLCA.SQLCODE,1) END IF 
     DECLARE aza_c1  CURSOR FOR aza_p1 
     OPEN aza_c1 
     FETCH aza_c1 INTO l_aza50 
     CLOSE aza_c1  
     #No.FUN-620025--end
END FUNCTION
