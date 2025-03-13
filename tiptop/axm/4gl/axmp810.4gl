# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp810.4gl
# Descriptions...: 三角貿易訂單拋轉還原作業
# Date & Author..: 98/12/10 By Linda
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.MOD-570279 05/07/20 By Mandy axmt810-->做多角拋轉還原時,畫面p810_w應秀出要還原的單號
# Modify.........: No.FUN-5A0153 05/10/31 By Sarah 訂單編號應增加放大鏡可開窗查詢訂單編號,訂單日期,客戶編號等資料
# Modify.........: No.FUN-620024 06/02/11 By Rayven 增加使用分銷功能后依流程代碼抓取訂單與采購單
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/08/31 BY yiting 訂單站別從0站開始
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.TQC-680107 06/09/22 By Rayven 修正拋轉還原流通配銷時取采購單單號錯誤
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/24 By cheunl 錯誤訊息匯整
# Modify.........: No.MOD-780030 07/08/08 By claire 訂單拋備註時其它站的單號要取該站為主而非來源站
# Modify.........: NO.TQC-790056 07/09/21 BY yiting 拋轉還原時不考慮參數設定
# Modify.........: No.TQC-7B0159 07/12/04 By Judy 多角拋轉還原不成功未提示錯誤信息
# Modify.........: No.CHI-7B0040 08/03/05 By claire 還原時若已有工單產生則不允許還原
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830136 08/03/18 By Carol 還原時oea49不應=0
# Modify.........: No.TQC-830006 08/03/18 By claire 還原時若已有出通(貨)則不允許還原
# Modify.........: No.MOD-940054 09/04/07 By Dido 訊息調整 axm-305-->tri-012 
# Modify.........: No.MOD-940364 09/04/28 By Dido 若為起單出貨需包含未確認問題,因此僅需排除已作廢單據
# Modify.........: No.MOD-950108 09/05/18 By Dido 在 transation 架構中錯誤時不可直接 return 
# Modify.........: No.MOD-970254 09/07/30 By Dido 排除已作廢之出貨或出通單 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/21 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-9A0167 09/10/27 By Dido 若已有訂單變更發出者需檢核不可還原 
# Modify.........: No.MOD-A10011 10/01/05 By Dido 若已有訂單單身部分結案者需檢核不可還原 
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No.FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-BA0035 11/12/19 By Summer 若已有請購單/採購單則不允許還原 
# Modify.........: No:MOD-C50124 12/05/17 By Elise 多角訂單無法拋轉還原,MOD-BA0035最終站才檢查
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*   #NO.FUN-620024
DEFINE g_oea01 LIKE oea_file.oea01      #NO.FUN-620024
DEFINE g_pmm01 LIKE pmm_file.pmm01      #NO.FUN-620024
DEFINE g_msg   LIKE type_file.chr1000   #No.FUN-680137 VARCHAR(60)
DEFINE tm RECORD
          oea01  LIKE oea_file.oea01
       END RECORD
DEFINE g_poz  RECORD LIKE poz_file.*    #流程代碼資料
DEFINE g_poy  RECORD LIKE poy_file.*    #流程代碼資料
DEFINE s_poy  RECORD LIKE poy_file.*    #流程代碼資料
DEFINE s_dbs_new     LIKE type_file.chr21  #New DataBase Name #No.FUN-680137  VARCHAR(21)
DEFINE l_dbs_new     LIKE type_file.chr21  #New DataBase Name #No.FUN-680137  VARCHAR(21)
DEFINE s_azp  RECORD LIKE azp_file.*
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE g_sw          LIKE type_file.chr1   #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1       LIKE oea_file.oea01
DEFINE tot           LIKE oeb_file.oeb12
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE l_aza50       LIKE aza_file.aza50   #No.FUN-620024
DEFINE l_dbs_tra     LIKE azw_file.azw05   #FUN-980092 add
DEFINE s_dbs_tra     LIKE azw_file.azw05   #FUN-980092 add
DEFINE s_plant_new   LIKE azp_file.azp01   #FUN-980092 add
DEFINE l_plant_new   LIKE azp_file.azp01   #FUN-980092 add
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_argv1 = ARG_VAL(1)
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN 
       CALL p810_p1()
    ELSE
       OPEN WINDOW p810_w WITH FORM "axm/42f/axmp810" 
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       
       CALL cl_ui_init()
       LET tm.oea01 = g_argv1
        DISPLAY BY NAME tm.oea01  #MOD-570279
       SELECT * INTO g_oea.*
          FROM oea_file
          WHERE oea01=tm.oea01
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("sel","oea_file",tm.oea01,"",SQLCA.SQLCODE,"","sel oea",1)   #No.FUN-660167
          RETURN
       END IF
       IF g_oea.oea901='N' OR g_oea.oea901 IS NULL THEN
          CALL cl_err(g_oea.oea901,'axm-304',1)  RETURN
       END IF
       IF g_oea.oea905='N' THEN
          CALL cl_err(g_oea.oea905,'tri-012',1) RETURN  #MOD-940054 add
       END IF
       IF g_oea.oea906 <>'Y' THEN
          CALL cl_err(g_oea.oea906,'axm-306',1) RETURN
       END IF
       IF g_oea.oea62 >0 THEN
          CALL cl_err(g_oea.oea62,'axm-407',1) RETURN
       END IF
       IF cl_sure(0,0) THEN
          CALL p810_p2()
       END IF
    END IF
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p810_p1()
 DEFINE l_ac       LIKE type_file.num5   #No.FUN-680137 SMALLINT
 DEFINE l_i,l_flag LIKE type_file.num5   #No.FUN-680137 SMALLINT
 DEFINE l_cnt      LIKE type_file.num5   #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p810_w WITH FORM "axm/42f/axmp810" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oea01
 WHILE TRUE
    LET g_action_choice = ''
 
    INPUT BY NAME tm.oea01  WITHOUT DEFAULTS   #NO.FUN-620024
 
 
         AFTER FIELD oea01
            IF cl_null(tm.oea01) THEN
               NEXT FIELD oea01
            END IF
            SELECT * INTO g_oea.*
               FROM oea_file
              WHERE oea01=tm.oea01
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","oea_file",tm.oea01,"",SQLCA.SQLCODE,"","sel oea",0)   #No.FUN-660167
               NEXT FIELD oea01 
            END IF
            IF g_oea.oea901='N' OR g_oea.oea901 IS NULL THEN
               CALL cl_err(g_oea.oea901,'apm-021',0)   #no.7603
               NEXT FIELD oea01 
            END IF
            IF g_oea.oea905='N' THEN
               CALL cl_err(g_oea.oea905,'axm-307',0)   #no.7603
               NEXT FIELD oea01 
            END IF
            IF g_oea.oea906 <>'Y' THEN
               CALL cl_err(g_oea.oea906,'axm-306',0)
               NEXT FIELD oea01 
            END IF
            IF g_oea.oea62 >0  THEN
               CALL cl_err(g_oea.oea62,'axm-407',0)
               NEXT FIELD oea01 
            END IF
            IF g_oea.oeaconf != 'Y' THEN #未確認 01/08/16 mandy
                CALL cl_err(g_oea.oea01,'axm-184',0 ) 
                NEXT FIELD oea01
            END IF
            #====>此訂單在"工單維護作業asfi301"已有資料,不可取消確認!
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM sfb_file
              WHERE sfb22 = g_oea.oea01
                AND sfb87 != 'X'
             IF l_cnt > 0 THEN
                 CALL cl_err(g_oea.oea01,'axm-016',0)
                 NEXT FIELD oea01
             END IF
            #====>此訂單在出通(貨)單已有資料,不可取消確認!
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM ogb_file
              WHERE ogb31 = g_oea.oea01
             IF l_cnt > 0 THEN
                 CALL cl_err(g_oea.oea01,'axm-407',0)
                 NEXT FIELD oea01
             END IF
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oea01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oea12"
               LET g_qryparam.default1 = tm.oea01
               CALL cl_create_qry() RETURNING tm.oea01
               DISPLAY BY NAME tm.oea01
               NEXT FIELD oea01
         END CASE
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()
      ON ACTION locale
         LET g_action_choice='locale'
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT INPUT                         #NO.FUN-620024
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT                         #NO.FUN-620024
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT                     #NO.FUN-620024
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT                                #NO.FUN-620024
 
 
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN
      CALL p810_p2()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
    END IF
 END WHILE
  CLOSE WINDOW p810_w
END FUNCTION
 
FUNCTION p810_p2()
  DEFINE p_last  LIKE type_file.num5    #流程之最後家數 #No.FUN-680137 SMALLINT
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_j     LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE l_oao01 LIKE oao_file.oao01    #MOD-780030 add
 
   CALL cl_wait() 
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM ogb_file,oga_file
    WHERE ogb31 =g_oea.oea01
      AND oga01=ogb01
      AND oga09='4' 
      AND ogaconf<>'X'   #MOD-940364 add
   IF l_cnt >0 AND l_cnt IS NOT NULL THEN
      CALL cl_err(g_oea.oea906,'axm-407',1) RETURN
   END IF
 
   LET l_cnt=0
   SELECT count(*) INTO l_cnt 
      FROM oep_file
      WHERE oep01 = g_oea.oea01 
        AND oep09 = '2'
   IF l_cnt >0 THEN
      CALL cl_err(tm.oea01,'axm-800',1) RETURN
   END IF

   LET l_cnt=0
   SELECT count(*) INTO l_cnt 
      FROM oeb_file
      WHERE oeb01 = g_oea.oea01 
        AND oeb70 = 'Y'
   IF l_cnt >0 THEN
      CALL cl_err(tm.oea01,'axd-048',1) RETURN
   END IF

   #讀取三角貿易流程代碼資料
   SELECT * INTO g_poz.* FROM poz_file
     WHERE poz01=g_oea.oea904
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","poz_file",g_oea.oea904,"",SQLCA.SQLCODE,"","sel poz",1)   #No.FUN-660167
      RETURN
   END IF
 
 
   BEGIN WORK 
   LET g_success='Y'
     CALL p810_last() RETURNING p_last  #取得最後一筆之家數
     #依流程代碼最多6層
     CALL s_showmsg_init()                #No.FUN-710046
     FOR i = 0 TO p_last    #FUN-670007
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
           IF i = 0 THEN CONTINUE FOR END IF  #FUN-670007 
           #得到廠商/客戶代碼及database
           CALL p810_azp(i)    
 
           #刪除採購單單頭檔(pmm_file)
 
           #取采購單單號
                 #LET l_sql = " SELECT pmm01 FROM ",s_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add
                 LET l_sql = " SELECT pmm01 FROM ",cl_get_target_table(s_plant_new,'pmm_file'),  #FUN-A50102
                             "  WHERE pmm99 ='",g_oea.oea99,"'"
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE pmm01_pre FROM l_sql
                 DECLARE pmm01_cs CURSOR FOR pmm01_pre
                 OPEN pmm01_cs
                 FETCH pmm01_cs INTO g_pmm01                 #P/O
                 IF SQLCA.SQLCODE THEN
                    LET g_msg = s_dbs_tra CLIPPED,'fetch pmm01_cs'   #FUN-980092 add
                    CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)  #No.FUN-710046
                    LET g_success = 'N'              
                    CONTINUE FOR             #MOD-950108
                 END IF
           #LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(s_plant_new,'pmm_file'),  #FUN-A50102
                      " WHERE pmm01= ? ",
                      "   AND pmm02='TRI' "     
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_pmm FROM l_sql2
           EXECUTE del_pmm USING g_pmm01            #NO.FUN-620024
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] =0 THEN   #FUN-670007
              CALL s_errmsg('','',"DEL pmm",SQLCA.sqlcode,1)   #No.FUN-710046 
              LET g_success='N'
              CONTINUE FOR                                     #No.FUN-710046
           END IF
           #刪除採購單身檔
           #LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(s_plant_new,'pmn_file'),  #FUN-A50102
                      " WHERE pmn01= ? ",             #NO.FUN-620024
                      "   AND pmn011='TRI' "     
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_pmn FROM l_sql2
           EXECUTE del_pmn USING g_pmm01            #NO.FUN-620024
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] =0 THEN   #FUN-670007
              CALL s_errmsg('','',"DEL pmn",SQLCA.sqlcode,1)   #No.FUN-710046
              LET g_success='N'
              CONTINUE FOR                #No.FUN-710046
           ELSE
              IF NOT s_industry('std') THEN
                 IF NOT s_del_pmni(g_pmm01,'',s_plant_new) THEN #FUN-980092 add
                    LET g_success = 'N'
                    CONTINUE FOR             #MOD-950108
                 END IF
              END IF
           END IF
           #刪除訂單單頭檔
 
           #取訂單單號
              #LET l_sql = "SELECT oea01 FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add
              LET l_sql = "SELECT oea01 FROM ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102
                          " WHERE oea99 = '",g_oea.oea99,"'"
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
              PREPARE oea01_pre FROM l_sql
              DECLARE oea01_cs CURSOR FOR oea01_pre
              OPEN oea01_cs
              FETCH oea01_cs INTO g_oea01                   #S/O
              LET l_oao01 = g_oea01                         #MOD-780030 add
              IF SQLCA.SQLCODE THEN
                 LET g_msg = l_dbs_tra CLIPPED,'fetch oea01_cs'  #FUN-980092 add
                 CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)     #No.FUN-710046
                 LET g_success = 'N'
                 CONTINUE FOR             #MOD-950108
              END IF
            #====>此訂單在"工單維護作業asfi301"已有資料,不可取消確認!
             LET l_cnt = 0
             #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED," sfb_file",  #FUN-980092 add
             LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'sfb_file'),  #FUN-A50102
                         "  WHERE sfb22 = '",g_oea01,"' ", 
                         "    AND sfb87 != 'X' "
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
             PREPARE sfb_pre FROM l_sql
             DECLARE sfb_cnt CURSOR FOR sfb_pre
             OPEN sfb_cnt
             FETCH sfb_cnt INTO l_cnt                  #S/O
             IF l_cnt > 0 THEN
                 LET g_msg = l_dbs_tra CLIPPED,g_oea01  #FUN-980092 add
                 CALL cl_err(g_msg,'axm-016',1)
                 LET g_success = 'N'
                 CONTINUE FOR             #MOD-950108
             END IF
             IF i = p_last THEN  #MOD-C50124 add
               #MOD-BA0035 add --start--
               #====>此訂單已轉請購單不可異動!
                LET l_cnt = 0
                LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pml_file'),",", 
                                                     cl_get_target_table(l_plant_new,'pmk_file'), 
                            "  WHERE pml01 = pmk01 ", 
                            "    AND pml24 = '",g_oea01,"' ", 
                            "    AND pmk18 != 'X' "
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
                PREPARE pml_pre FROM l_sql
                DECLARE pml_cnt CURSOR FOR pml_pre
                OPEN pml_cnt
                FETCH pml_cnt INTO l_cnt 
                IF l_cnt > 0 THEN
                    LET g_msg = l_dbs_tra CLIPPED,g_oea01
                    CALL cl_err(g_msg,'axm-001',1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
               #====>此訂單已轉採購單不可異動!
                LET l_cnt = 0
                LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",", 
                                                     cl_get_target_table(l_plant_new,'pmm_file'), 
                            "  WHERE pmn01 = pmm01 ", 
                            "    AND pmn24 = '",g_oea01,"' ", 
                            "    AND pmm18 != 'X' "
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
                PREPARE pmm_pre FROM l_sql
                DECLARE pmm_cnt CURSOR FOR pmm_pre
                OPEN pmm_cnt
                FETCH pmm_cnt INTO l_cnt 
                IF l_cnt > 0 THEN
                    LET g_msg = l_dbs_tra CLIPPED,g_oea01
                    CALL cl_err(g_msg,'apm-231',1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
               #MOD-BA0035 add --end--
             END IF  #MOD-C50124 add
            #====>此訂單在出通(貨)單已有資料,不可取消確認!
             LET l_cnt = 0
             #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED," oga_file, ",	#FUN-980092 add	
             #                             "     ",l_dbs_tra CLIPPED," ogb_file",	#FUN-980092 add	
             LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'),",",  #FUN-A50102
                                                  cl_get_target_table(l_plant_new,'ogb_file'),  #FUN-A50102	
                         "  WHERE ogb31 = '",g_oea01,"' AND oga01 = ogb01 AND ogaconf <> 'X' "	
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
             PREPARE ogb_pre FROM l_sql
             DECLARE ogb_cnt CURSOR FOR ogb_pre
             OPEN ogb_cnt
             FETCH ogb_cnt INTO l_cnt                  
             IF l_cnt > 0 THEN
                 LET g_msg = l_dbs_tra CLIPPED,g_oea01  #FUN-980092 add
                 CALL cl_err(g_msg,'axm-407',1)
                 LET g_success = 'N'
                 CONTINUE FOR             #MOD-950108
             END IF
 
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102	
                    " WHERE oea01= ? ",
                    "   AND oea901='Y' AND oea905='Y' "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_oea FROM l_sql2
           EXECUTE del_oea USING g_oea01            #NO.FUN-620024
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] =0 THEN   #FUN-670007
              CALL s_errmsg('','',"DEL oea",SQLCA.sqlcode,1) #No.FUN-710046
              LET g_success='N'  
              CONTINUE FOR             #No.FUN-710046              
           END IF
           #刪除訂單單身檔
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oeb_file'),  #FUN-A50102	
                      " WHERE oeb01= ? " 
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_oeb FROM l_sql2
           EXECUTE del_oeb USING g_oea01            #NO.FUN-620024
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] =0 THEN   #FUN-670007
              CALL s_errmsg('','',"DEL oeb",SQLCA.sqlcode,1) #No.FUN-710046
              LET g_success='N'
              CONTINUE FOR           #No.FUN-710046
           ELSE
              IF NOT s_industry('std') THEN
                 IF NOT s_del_oebi(g_oea01,'',l_plant_new) THEN #FUN-980092 add
                    LET g_success = 'N'
                    CONTINUE FOR
                 END IF
              END IF
           END IF
           #刪除訂單選配/備品檔 no.7168
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oeo_file",  #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oeo_file'),  #FUN-A50102	
                    " WHERE oeo01= ? "  #no.7667
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_oeo FROM l_sql2
           EXECUTE del_oeo USING g_oea.oea01
           IF SQLCA.SQLCODE <> 0 THEN
              CALL s_errmsg('','',"DEL oeo",SQLCA.sqlcode,1) #No.FUN-710046
              LET g_success='N' 
              CONTINUE FOR             #No.FUN-710046
           END IF
           #刪除Memo檔 No.7963
           #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"oao_file",
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oao_file'),  #FUN-A50102	
                      " WHERE oao01= ? "  
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE del_oao FROM l_sql2
           EXECUTE del_oao USING l_oao01       #MOD-780030 modify
           IF SQLCA.SQLCODE <> 0 THEN
              CALL s_errmsg('','',"DEL oao",SQLCA.sqlcode,1)  #No.FUN-710046
              LET g_success='N'
              CONTINUE FOR          #No.FUN-710046
           END IF
        END FOR
   CALL s_showmsg()    #TQC-7B0159
   IF g_totsuccess = 'N' THEN                                                                                                       
      LET g_success = 'N'                                                                                                           
   END IF                                                                                                                           
        #8409
        IF g_success = 'N' THEN CALL cl_rbmsg(1) ROLLBACK WORK RETURN END IF 
       #更新訂單之拋轉否='N',其簽核亦還原
       LET g_i=g_i
           UPDATE oea_file
              SET oea905='N',
                  oea99 = '',        #No.7963  #No.TQC-680107
                  oeasseq = 0        #MOD-830136-modify
            WHERE oea901='Y'          #三角貿易訂單
              AND oea01 =g_oea.oea01
       IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
          CALL s_errmsg("oea01",g_oea.oea01,"UPD oea_file",SQLCA.sqlcode,1)     #No.FUN-710046
          LET g_success='N'
       END IF
       #刪除簽核過程檔
       DELETE FROM azd_file WHERE azd01 = g_oea.oea01 AND azd02 = 5
       IF SQLCA.SQLCODE <> 0 THEN
          CALL s_errmsg("azd01",g_oea.oea01,"DEL azd_file",SQLCA.sqlcode,1) #No.FUN-710046
          LET g_success='N'  
       END IF
       #no.6497更新合約已訂量 
       IF g_oea.oea11 = '3' THEN
          DECLARE oeb_cs CURSOR FOR
           SELECT * FROM oeb_file WHERE oeb01 = g_oea.oea01
          FOREACH oeb_cs INTO g_oeb.*
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
            SELECT SUM(oeb12) INTO tot FROM oea_file,oeb_file
               WHERE oea12 = g_oea.oea12 AND oea00 != '0' AND oeaconf = 'Y'
                 AND oea01 = oeb01 AND oeb71 = g_oeb.oeb71
            IF cl_null(tot) THEN LET tot = 0 END IF
            UPDATE oeb_file SET oeb24 = tot
                WHERE oeb01 = g_oea.oea12 AND oeb03 = g_oeb.oeb71
            IF SQLCA.SQLCODE OR SQLCA.SQLCODE THEN
               LET g_showmsg=g_oea.oea12,"/",g_oeb.oeb71                              #No.FUN-710046
               CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)  #No.FUN-710046                     
               LET g_success = 'N'
            END IF
          END FOREACH
   IF g_totsuccess = 'N' THEN                                                                                                       
      LET g_success = 'N'                                                                                                           
   END IF                                                                                                                           
       END IF
# END FOREACH     
  CALL s_showmsg()             #No.FUN-710046
  IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
  END IF
END FUNCTION
 
FUNCTION p810_azp(l_n)
  DEFINE l_source LIKE type_file.num5,   #來源站別 #No.FUN-680137 SMALLINT
         l_n      LIKE type_file.num5,   #當站站別 #No.FUN-680137 SMALLINT
         l_sql1   LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(800)
         l_next   LIKE type_file.num5    #SMALLINT               #FUN-670007
 
     ##-------------取得來源資料庫(P/O)-----------------
     IF l_n = 1 THEN LET l_source = 0 ELSE LET l_source = l_n - 1 END IF   #FUN-670007 
     LET l_next = l_source + 1      #FUN-670007 
     SELECT * INTO s_poy.* FROM poy_file 
      WHERE poy01 = g_poz.poz01 AND poy02 = l_source
 
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_dbs_new = s_dbstring(s_azp.azp03 CLIPPED)
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = s_azp.azp01
     LET s_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET s_dbs_tra = g_dbs_tra
     ##-------------取得當站資料庫(S/O)-----------------
      SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_next   #FUN-670007
 
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)
 
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
      #判斷是否使用分銷功能
      LET l_sql1 = "SELECT aza50 ",                                             
                   #"  FROM ",l_dbs_new CLIPPED,"aza_file ", 
                   "  FROM ",cl_get_target_table(g_poy.poy04,'aza_file'),  #FUN-A50102                    
                   "  WHERE aza01 = '0' "                                       
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,g_poy.poy04) RETURNING l_sql1 #FUN-A50102
      PREPARE aza_p1 FROM l_sql1                                                
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','',"aza_p1",SQLCA.sqlcode,0) #No.FUN-710046
      END IF        
      DECLARE aza_c1  CURSOR FOR aza_p1                                         
      OPEN aza_c1                                                               
      FETCH aza_c1 INTO l_aza50                                                 
      CLOSE aza_c1
END FUNCTION
 
FUNCTION p810_last()
DEFINE l_last  LIKE type_file.num5   #No.FUN-680137 SMALLINT
   SELECT MAX(poy02) INTO l_last FROM poy_file
    WHERE poy01 = g_poz.poz01 
   IF SQLCA.SQLCODE THEN 
      LET l_last = 1
      CALL cl_err3("sel","poy_file",g_poz.poz01,"","axm-318","","",1)   #No.FUN-660167
      LET g_success= 'N' 
   END IF
   RETURN l_last
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
