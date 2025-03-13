# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gisp200.4gl
# Descriptions...: 進項發票底稿產生作業
# Date & Author..: 02/03/28 By Danny
# Modify.........: No.FUN-580006 05/08/18 By ice 修改ora錯誤
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-790001 07/09/02 By Mandy PK 問題
# Modify.........: No.TQC-790089 07/09/18 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint Modify.........: No.TQC-790089 07/09/18 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-9B0011 09/11/03 By liuxqa s_dbstring整批修改。
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-910088 11/12/29 By chenjing 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm          RECORD 
                    wc       LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(400)
                   a         LIKE type_file.chr1          #NO FUN-690009 VARCHAR(1)
                   END RECORD,
       g_atot      LIKE type_file.num5,      #NO FUN-690009 SMALLINT
       plant       ARRAY[12] OF LIKE azp_file.azp01       #NO FUN-690009 VARCHAR(12)    #工廠編號
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL p200_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p200_tm()
   DEFINE   l_cmd         LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(400)
            l_ac,i        LIKE type_file.num5      #NO FUN-690009 SMALLINT
 
   OPEN WINDOW p200_w WITH FORM "gis/42f/gisp200" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa00,apa01,apa02,apa05,apb12
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      END CONSTRUCT

      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup') #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE 
      END IF 
      #----- 工廠編號 ----#
      LET plant[1] = g_plant
      CALL SET_COUNT(1)    # initial array argument
 
      INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.* 
 
         AFTER FIELD plant
            LET l_ac = ARR_CURR()
            IF NOT cl_null(plant[l_ac]) THEN
               SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
               IF STATUS THEN 
                  CALL cl_err3("sel","azp_file",plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660146
                  NEXT FIELD plant  
               END IF
               FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
                  IF plant[i] = plant[l_ac] THEN
                     CALL cl_err('','aom-492',1) NEXT FIELD plant
                  END IF
               END FOR
               IF NOT s_chkdbs(g_user,plant[l_ac],g_rlang) THEN
                  NEXT FIELD plant
               END IF
            END IF
 
         AFTER INPUT                    # 檢查至少輸入一個工廠
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET g_atot = ARR_COUNT()
            FOR i = 1 TO g_atot
               IF NOT cl_null(plant[i]) THEN
                  EXIT INPUT
               END IF
            END FOR
            IF i = g_atot+1 THEN
               CALL cl_err('','aom-423',1) NEXT FIELD plant
            END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG CALL cl_cmdask()  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      LET tm.a = 'N' 
 
      INPUT BY NAME tm.a WITHOUT DEFAULTS  
 
         AFTER FIELD a 
           IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
              NEXT FIELD a
           END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END INPUT
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF cl_sure(18,0) THEN
         CALL cl_wait()
         CALL p200_g()
         CALL cl_end(0,0)
      END IF
   END WHILE
 
   CLOSE WINDOW p200_w
END FUNCTION
 
FUNCTION p200_g() 
 DEFINE  l_sql      LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(1600)
         l_buf      LIKE type_file.chr1000,      #NO FUN-690009 VARCHAR(400)
         l_dbs      LIKE azp_file.azp03,         #NO FUN-690009 VARCHAR(20)
         l_apa      RECORD LIKE apa_file.*,
         l_apb      RECORD LIKE apb_file.*,
         l_apk      RECORD LIKE apk_file.*,
         l_ise      RECORD LIKE ise_file.*,
         l_pmc081   LIKE pmc_file.pmc081,
         l_pmc082   LIKE pmc_file.pmc082,
         l_apl02    LIKE apl_file.apl02,
         l_i        LIKE type_file.num5          #NO FUN-690009 SMALLINT
 
    BEGIN WORK 
    LET g_success = 'Y'
    
    LET l_i = 1
    FOR l_i = 1 TO g_atot
        IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF    
        #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i] #FUN-A50102
        #LET l_dbs = s_dbstring(l_dbs CLIPPED)        #TQC-9B0011 mod   #FUN-A50102
        LET l_sql = "SELECT apk_file.*,apa_file.*,apb_file.*,",
                    "       pmc081,pmc082,apl02 ",
                    #"  FROM ",l_dbs CLIPPED,"apk_file,",
                    #          l_dbs CLIPPED,"apa_file,",
                    #          l_dbs CLIPPED,"apb_file, OUTER ",
                    #          l_dbs CLIPPED,"apl_file, OUTER ",
                    #          l_dbs CLIPPED,"pmc_file ",
                    "  FROM ",cl_get_target_table(plant[l_i],'apk_file'),",",        #FUN-A50102
                              cl_get_target_table(plant[l_i],'apa_file'),",",        #FUN-A50102
                              cl_get_target_table(plant[l_i],'apb_file'),", OUTER ", #FUN-A50102                              
                              cl_get_target_table(plant[l_i],'apl_file'),", OUTER ", #FUN-A50102                              
                              cl_get_target_table(plant[l_i],'pmc_file'),            #FUN-A50102
                    " WHERE apa01 = apb01 ",
                    "   AND apk01 = apb01 AND apk02 = apb02 ",
                    "   AND apl_file.apl01 = apk_file.apk04 ",
                    "   AND pmc_file.pmc24 = apk_file.apk04 ", 
                    "   AND apa41 = 'Y' AND apa42 = 'N' ",
                    "   AND apk172 IN ('S','N','T','W','A','G') ",
                    "   AND apa01 NOT IN (SELECT UNIQUE ise04 FROM ise_file",
                    "                      WHERE ise07 = '1' ) ",
                    "   AND ",tm.wc CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE p200_pre FROM l_sql
        IF STATUS THEN 
           CALL cl_err('p200_pre',STATUS,0) LET g_success = 'N' EXIT FOR 
        END IF
        DECLARE p200_curs CURSOR FOR p200_pre
        FOREACH p200_curs INTO l_apk.*,l_apa.*,l_apb.*,
                               l_pmc081,l_pmc082,l_apl02
          IF STATUS THEN 
             CALL cl_err('p200_curs',STATUS,0) LET g_success = 'N' EXIT FOR
          END IF
          INITIALIZE l_ise.* TO NULL
          LET l_ise.ise00 = '0'
          LET l_ise.ise01 = l_apk.apk03             #發票號碼
          LET l_ise.ise02 = l_apk.apk28             #發票類別
          LET l_ise.ise03 = l_apk.apk05             #發票日期
          LET l_ise.ise04 = l_apk.apk01             #帳款編號
          LET l_ise.ise05 = l_apk.apk02             #帳款項次
          LET l_ise.ise051= l_apk.apk04             #廠商統一編號
          IF cl_null(l_apl02) THEN 
               LET l_ise.ise052= l_pmc081,l_pmc082  #廠商全名
          ELSE LET l_ise.ise052= l_apl02            #廠商全名
          END IF
          LET l_ise.ise06 = l_apa.apa15    #稅別 
          LET l_ise.ise061= l_apk.apk29    #營業稅率
          LET l_ise.ise062= l_apk.apk172   #發票種類
          LET l_ise.ise07 = '0'            #狀態碼
          LET l_ise.ise08 = l_apk.apk08    #發票未稅金額
          LET l_ise.ise08x= l_apk.apk07    #發票稅額
          LET l_ise.ise08t= l_apk.apk06    #發票含稅金額
          LET l_ise.ise14 = l_apb.apb27    #入庫日期
          IF l_ise.ise062 = 'G' THEN
             LET l_ise.ise15 = l_apk.apk30 #數量
             LET l_ise.ise16 = l_apb.apb28 #單位
             LET l_ise.ise15 = s_digqty(l_ise.ise15,l_ise.ise16)   #FUN-910088--add--
          END IF
          LET l_ise.ise18 = l_apa.apa01    #異動單號
          LET l_ise.ise19 = l_apb.apb02    #項次 
          LET l_ise.iseuser = g_user
          LET l_ise.isegrup = g_grup
          LET l_ise.isedate = g_today
          LET l_ise.iselegal= g_legal #FUN-980011 add
 
          IF l_apk.apk171 = '23' THEN     
             LET l_ise.ise08 = l_ise.ise08 * -1
             LET l_ise.ise08x= l_ise.ise08x* -1
             LET l_ise.ise08t= l_ise.ise08t* -1
             LET l_ise.ise15 = l_ise.ise15 * -1
          END IF
         #TQC-790001--mod--add--
          IF cl_null(l_ise.ise05) THEN LET l_ise.ise05 = 0 END IF
         #TQC-790001--mod--end--
          LET l_ise.iseoriu = g_user      #No.FUN-980030 10/01/04
          LET l_ise.iseorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO ise_file VALUES(l_ise.*)
         #IF STATUS != 0 AND STATUS != -239 THEN                         #TQC-790089 mark
          IF STATUS != 0 AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN  #TQC-790089 mod
#            CALL cl_err('ins ise',STATUS,1)   #No.FUN-660146
            #CALL cl_err3("ins","ise_file",l_ise.ise01,l_ise.ise04,STATUS,"","ins ise",1)        #TQC-790089 mark #No.FUN-660146
             CALL cl_err3("ins","ise_file",l_ise.ise01,l_ise.ise04,SQLCA.SQLCODE,"","ins ise",1) #TQC-790089 mod  #No.FUN-660146
             LET g_success='N' EXIT FOR 
          END IF
         #IF STATUS = -239 AND tm.a = 'Y' THEN                    #TQC-790089 mark
          IF cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a = 'Y' THEN  #TQC-790089 mod
             UPDATE ise_file SET * = l_ise.* 
              WHERE ise01 = l_ise.ise01 AND ise04 = l_ise.ise04
                AND ise05 = l_ise.ise05
             IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('upd ise',STATUS,1)  #No.FUN-660146
                CALL cl_err3("upd","ise_file",l_ise.ise01,l_ise.ise04,STATUS,"","upd ise",1)   #No.FUN-660146
                LET g_success='N' EXIT FOR  
             END IF
          END IF
        END FOREACH
    END FOR
    IF g_success = 'Y' THEN COMMIT WORK ELSE  ROLLBACK WORK END IF
END FUNCTION

