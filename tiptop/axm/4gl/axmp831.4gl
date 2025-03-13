# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp831.4gl
# Descriptions...: 三角貿易出貨通知單拋轉還原作業(正拋使用)
# Arthur.........: NO.FUN-670007 06/08/10 by yiting 
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/23 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-880065 08/08/08 By claire 拋轉還原前先確認出貨單已拋轉還原才可執行本作業
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/21 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-9C0140 09/12/21 By Dido 當多訂單合併一出貨通知單時, 出貨單扣帳還原原拋轉至各站之出通單, invoice還是會存在 
# Modify.........: No:MOD-A10139 10/01/22 By Dido 不應將刪除invoice的判斷包在packing之中 
# Modify.........: No:FUN-A50102 10/06/11 by lixh1  跨庫統一用cl_get_target_table()實現
# Modify.........: No.FUN-B90012 11/09/13 By xianghui 增加ICD行業功能
# Modify.........: No.FUN-C50136 12/08/27 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: No.FUN-C80001 12/09/03 By bart 還原時需刪除ogc_file,ogg_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE l_oga   RECORD LIKE oga_file.*    #NO.FUN-620024
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE g_oha   RECORD LIKE oha_file.*    #NO.FUN-620024
DEFINE g_ohb   RECORD LIKE ohb_file.*    #NO.FUN-620024
DEFINE tm RECORD
          oga01  LIKE oga_file.oga01
       END RECORD
DEFINE g_poz   RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.7993
DEFINE g_poy   RECORD LIKE poy_file.*    #流程代碼資料(單身) No.7993
DEFINE s_poy   RECORD LIKE poy_file.*    #來源流程資料(單身) No.7993
DEFINE g_rva01     LIKE rva_file.rva01
DEFINE g_rvu01     LIKE rvu_file.rvu01
DEFINE g_oga01     LIKE oga_file.oga01
DEFINE t_oga01     LIKE oga_file.oga01
DEFINE g_ofa01     LIKE ofa_file.ofa01
DEFINE s_dbs_new   LIKE type_file.chr21  #New DataBase Name #No.FUN-680137 VARCHAR(21)
DEFINE s_azp       RECORD LIKE azp_file.*
DEFINE l_azp       RECORD LIKE azp_file.*
DEFINE g_sw        LIKE type_file.chr1      #No.FUN-680137 VARCHAR(1)
DEFINE g_t1        LIKE oay_file.oayslip #No.FUN-550070 #No.FUN-680137 VARCHAR(5)
DEFINE g_argv1     LIKE oga_file.oga01
DEFINE oga_t1      LIKE oay_file.oayslip    #No.FUN-550070 #No.FUN-680137 VARCHAR(05)
DEFINE rva_t1      LIKE oay_file.oayslip    #No.FUN-680137 VARCHAR(05)
DEFINE rvu_t1      LIKE oay_file.oayslip    #No.FUN-680137 VARCHAR(05)
DEFINE l_aza50     LIKE aza_file.aza50   #No.FUN-620024
DEFINE g_pmm01     LIKE pmm_file.pmm01   #No.FUN-620024
DEFINE g_cnt       LIKE type_file.num10  #No.FUN-680137 INTEGER
DEFINE g_msg       LIKE type_file.chr1000#No.FUN-680137 VARCHAR(72)
DEFINE g_ima906    LIKE ima_file.ima906  #FUN-560043
DEFINE s_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
DEFINE s_plant_new  LIKE azp_file.azp01    #FUN-980092 add
 
MAIN
   OPTIONS                               #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                      #擷取中斷鍵, 由程式處理
 
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
       CALL p831_p1()
       CLOSE WINDOW p831_w
    ELSE
       LET tm.oga01 = g_argv1
       IF cl_sure(0,0) THEN
          CALL p831_p2()
       END IF
    END IF
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p831_p1()
 DEFINE l_ac       LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_i,l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_cnt      LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p831_w WITH FORM "axm/42f/axmp831" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oga01
 WHILE TRUE
    LET g_action_choice = ''
    INPUT BY NAME tm.oga01  WITHOUT DEFAULTS  
         AFTER FIELD oga01
            IF cl_null(tm.oga01) THEN
               NEXT FIELD oga01
            END IF
            SELECT * INTO g_oga.*
               FROM oga_file
              WHERE oga01=tm.oga01
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","oga_file",tm.oga01,"",STATUS,"","sel oga",0)   #No.FUN-660167
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga10 IS NOT NULL THEN
               CALL cl_err(g_oga.oga10,'axm-502',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
               CALL cl_err(g_oga.oga901,'axm-406',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga09<>'5' THEN
               CALL cl_err(g_oga.oga905,'axm-406',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga905='N' THEN
               CALL cl_err(g_oga.oga905,'tri-012',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga906 <>'Y' THEN
               CALL cl_err(g_oga.oga906,'apm-012',0)
               NEXT FIELD oga01 
            END IF
            IF g_oga.ogaconf != 'Y' THEN #01/08/20 mandy
                CALL cl_err(g_oga.oga01,'axm-184',0)
                NEXT FIELD oga01 
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()
      ON ACTION locale
         LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
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
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN
      CALL p831_p2()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
  CLOSE WINDOW p831_w
END FUNCTION
 
FUNCTION p831_p2()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3 LIKE type_file.chr1000 #FUN-560043  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql4 LIKE type_file.chr1000 #NO.FUN-620024  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql5 LIKE type_file.chr1000 #NO.FUN-620024  #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oeb  RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_x     LIKE type_file.chr3     #No.FUN-620024  #No.FUN-680137 VARCHAR(3)
  DEFINE l_j     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
  DEFINE l_ogd01 LIKE ogd_file.ogd01
  DEFINE p_last  LIKE type_file.num5     #流程之最後家數 #No.FUN-680137 SMALLINT
  DEFINE p_last_plant LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)
  DEFINE l_oha   RECORD LIKE oha_file.*   #NO.FUN-620024
  DEFINE l_ohb   RECORD LIKE ohb_file.*   #NO.FUN-620024
  DEFINE l_oha01 LIKE oha_file.oha01     #NO.FUN-620024
  DEFINE l_oga99 LIKE oga_file.oga99       #MOD-880065 add
  DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980092 add
# DEFINE l_oga03 LIKE oga_file.oga03     #FUN-C50136 add
# DEFINE l_oia07 LIKE oia_file.oia07     #FUN-C50136 add
 
   CALL cl_wait() 
   LET s_oea62=0
{
  #保留此段, 若條件改成construct多筆時只要把mark拿掉
  #讀取符合條件之三角貿易訂單資料
  LET l_sql="SELECT * FROM oga_file ",
            " WHERE oga01 ='",tm.oga01,"' ",
             " AND oga09='5' ",
             " AND oga909='Y' ",
             " AND oga905='Y' ",
             " AND oga906='Y' ",
             " AND (oga10 IS NULL OR oga10 =' ' ) ",   #帳單編號必須為null
             " AND ogaconf='Y' "      #已確認之訂單才可轉
  PREPARE p831_p1 FROM l_sql 
  IF STATUS THEN CALL cl_err('pre1',STATUS,1) END IF
  LET g_success='Y' 
  DECLARE p831_curs1 CURSOR FOR p831_p1
  FOREACH p831_curs1 INTO g_oga.*
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err('sel oga',STATUS,0)
        EXIT FOREACH
     END IF
}
     SELECT * INTO g_oga.*
       FROM oga_file
      WHERE oga01=tm.oga01
     IF SQLCA.SQLCODE THEN
        CALL cl_err3("sel","oga_file",tm.oga01,"",STATUS,"","sel oga",1)   #No.FUN-660167
        RETURN
     END IF
     IF g_oga.oga10 IS NOT NULL THEN
        CALL cl_err(g_oga.oga10,'axm-502',1)
        RETURN           
     END IF
     IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
        CALL cl_err(g_oga.oga901,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga09<>'5' THEN
        CALL cl_err(g_oga.oga905,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga905='N' THEN
        CALL cl_err(g_oga.oga905,'tri-012',1)
        RETURN
     END IF
     IF g_oga.oga906 <>'Y' THEN
        CALL cl_err(g_oga.oga906,'apm-012',1)
        RETURN
     END IF
     #MOD-880065-begin-add
     #判斷出通單拋轉完成才可以繼續作業
      SELECT oga99 INTO l_oga99 FROM oga_file
       WHERE oga01 = g_oga.oga011 
         AND (oga09 = '4' OR oga09= '6')
      IF NOT cl_null(l_oga99) THEN
         CALL cl_err(g_oga.oga01,'axm-228',1)
	 LET g_success = 'N'
         RETURN
      END IF
     #MOD-880065-end-add
 
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                    "  WHERE oea01 = ogb31 ",
                    "    AND ogb01 = '",g_oga.oga01,"'",
                    "    AND oeaconf = 'Y' "  #01/08/16 mandy
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f 
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該出貨單之訂單
        SELECT * INTO g_oea.*
          FROM oea_file
         WHERE oea01 = g_oga.oga16
           AND oeaconf = 'Y'   #01/08/16 mandy
     END IF
     IF SQLCA.sqlcode THEN
         CALL cl_err('sel oea',STATUS,1)
         LET g_success = 'N'
         RETURN
     END IF
 
     #no.6158檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        LET g_success='N' RETURN
     END IF
     #no.6158
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 AND poz00='1'
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)   #No.FUN-660167
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.pozacti = 'N' THEN 
         CALL cl_err(g_oea.oea904,'tri-009',1)
         LET g_success = 'N'
         RETURN
     END IF
     IF g_poz.poz011 = '2' THEN
        CALL cl_err('','axm-411',1) LET g_success = 'N' RETURN
     END IF
 
     CALL s_mtrade_last_plant(g_oea.oea904) 
                 RETURNING p_last,p_last_plant    #記錄最後一筆之家數
 
     BEGIN WORK 
     LET g_success='Y'
 
     #依流程代碼最多6層
     FOR i = 1 TO p_last
           #得到廠商/客戶代碼及database
           CALL p831_azp(i)
           CALL p831_getno()                      #No.7993 取得還原單號
           #NO.FUN-620024  --start--
           LET l_sql5 = "SELECT oga00,oga01 ",                                  
                        #" FROM ",s_dbs_new CLIPPED,"oga_file ",  #FUN-980092 mark         
                        #" FROM ",s_dbs_tra CLIPPED,"oga_file ",   #FUN-980092 add   #FUN-A50102
                        " FROM ",cl_get_target_table( s_plant_new, 'oga_file' ),     #FUN-A50102
                        " WHERE oga99='",g_oga.oga99,"'" 
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
         CALL cl_parse_qry_sql(l_sql5,s_plant_new) RETURNING l_sql5 #FUN-980092
           PREPARE oga_p2 FROM l_sql5                                     
           IF SQLCA.SQLCODE THEN
              CALL cl_err('oga_p2',SQLCA.SQLCODE,1)
           END IF
           DECLARE oga_c2 CURSOR FOR oga_p2                               
           OPEN oga_c2                                                    
           FETCH oga_c2 INTO l_oga.oga00,l_oga.oga01                      
           IF SQLCA.SQLCODE <> 0 THEN                                     
              LET g_success='N'                                           
              RETURN                                                      
           END IF                                                         
           CLOSE oga_c2
           #NO.FUN-620024  --end--
           LET l_oea62=0
           #-------------------刪除各單據資料-------------------
           #-----No.FUN-850100-----
           #刪除批/序號資料檔(rvbs_file)
           #LET l_sql2="DELETE FROM ",s_dbs_new CLIPPED,"rvbs_file", #FUN-980092 mark
        #   LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"rvbs_file",  #FUN-980092 add   #FUN-A50102
           LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'rvbs_file' ),   #FUN-A50102
                      " WHERE rvbs00 = ? ",
                      "   AND rvbs01 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_rvbss FROM l_sql2
           #-----No.FUN-850100 END-----
 
#          #FUN-C50136--add-str--
#          IF g_oaz.oaz96 ='Y' THEN
#             LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(s_plant_new,'oga_file'),
#                          " WHERE oga01 = ? ",
#                          "   AND oga09 ='5'"
#             PREPARE sel_oga FROM l_sql2
#             EXECUTE sel_oga USING g_oga01 INTO l_oga03
#             CALL s_ccc_oia07('C',l_oga03) RETURNING l_oia07
#             IF l_oia07 = '0' THEN
#                CALL s_ccc_rback(l_oga03,'C',g_oga01,0,s_plant_new)
#             END IF
#          END IF
#          #FUN-C50136--add-end--
           #刪除出貨通知單單頭檔(oga_file)
           #LET l_sql2="DELETE FROM ",s_dbs_new CLIPPED,"oga_file",
        #   LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"oga_file",    #FUN-A50102
           LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'oga_file' ),  #FUN-A50102
                      " WHERE oga01= ? ",
                      "   AND oga09='5'   "    #出通單   
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_oga FROM l_sql2
           EXECUTE del_oga USING g_oga01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              #LET g_msg = s_dbs_new CLIPPED,'del oga:' #FUN-980092 mark
              LET g_msg = s_dbs_tra CLIPPED,'del oga:'  #FUN-980092 add
              CALL cl_err(g_msg,STATUS,1)
              LET g_success='N'
           END IF
           #出貨單單身 -->s_dbs_new
           #LET l_sql2="DELETE FROM ",s_dbs_new CLIPPED,"ogb_file", #FUN-980092 mark
       #    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add   #FUN-A50102
           LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'ogb_file' ),   #FUN-A50102
                     " WHERE ogb01= ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_ogb FROM l_sql2
           EXECUTE del_ogb USING g_oga01
           IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
              #LET g_msg = s_dbs_new CLIPPED,'del ogb:' #FUN-980092 mark
              LET g_msg = s_dbs_tra CLIPPED,'del ogb:'  #FUN-980092 add
              CALL cl_err(g_msg,STATUS,1)
              LET g_success='N'
           #No.FUN-7B0018 080305 add --begin
           ELSE
              IF NOT s_industry('std') THEN
                 #IF NOT s_del_ogbi(g_oga01,'',s_dbs_new) THEN #FUN-980092 mark
                 IF NOT s_del_ogbi(g_oga01,'',s_plant_new) THEN #FUN-980092 add
                    LET g_success = 'N'
                 END IF
              END IF
           #No.FUN-7B0018 080305 add --end
           END IF
           #FUN-C80001---begin
           LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'ogc_file' ),  
                     " WHERE ogc01= ? "
      	   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
           CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
           PREPARE del_ogc FROM l_sql2
           EXECUTE del_ogc USING g_oga01
           IF SQLCA.SQLCODE THEN
              LET g_msg = s_dbs_tra CLIPPED,'del ogc:' 
              CALL cl_err(g_msg,STATUS,1)
              LET g_success='N'
           END IF 
           LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'ogg_file' ),  
                     " WHERE ogg01= ? "
      	   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
           CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
           PREPARE del_ogg FROM l_sql2
           EXECUTE del_ogg USING g_oga01
           IF SQLCA.SQLCODE THEN
              LET g_msg = s_dbs_tra CLIPPED,'del ogg:' 
              CALL cl_err(g_msg,STATUS,1)
              LET g_success='N'
           END IF 
           #FUN-C80001---end
           #-----No.FUN-850100-----
           #刪除批/序號資料
           EXECUTE del_rvbss USING 'axmt850',g_oga01
           IF SQLCA.SQLCODE THEN
              #LET g_msg = s_dbs_new CLIPPED,'del rvbs:'    #FUN-980092 mark
              LET g_msg = s_dbs_tra CLIPPED,'del rvbs:'     #FUN-980092 add
              CALL s_errmsg('','',g_msg,STATUS,1)
              LET g_success='N'
           END IF
           #-----No.FUN-850100 END-----
           #FUN-B90012-add-str--
           IF s_industry('icd') THEN
              CALL icd_idb_del(g_oga01,'',s_plant_new)
           END IF
           #FUN-B90012-add-str--
 
           IF (g_oaz.oaz67 = '1' AND g_oax.oax05='Y') THEN  
               SELECT COUNT(*) INTO g_cnt FROM ogd_file,oga_file
               #WHERE ogd01=oga01 AND oga16=g_oga.oga16 AND oga30='Y'     #MOD-9C0140 mark
                WHERE ogd01=oga01 AND oga99=g_oga.oga99 AND oga30='Y'     #MOD-9C0140
               IF g_cnt> 0 THEN               #有輸入Packing List才拋轉
                   LET l_ogd01 = g_oga01
                   #no.4495(end)
                   IF NOT cl_null(g_oga01) THEN   #本區有抓到出貨單號時再DELETE
                       #刪除包裝單身檔-->s_dbs_new
                       #LET l_sql2="DELETE FROM ",s_dbs_new CLIPPED,"ogd_file", #FUN-980092 mark
                       #LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"ogd_file",  #FUN-980092 add   #FUN-A50102
                       LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'ogd_file' ),   #FUN-A50102
                                  " WHERE ogd01= ? "
 	               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
                       PREPARE del_ogd FROM l_sql2
                       EXECUTE del_ogd USING l_ogd01
                       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                           #LET g_msg = s_dbs_new CLIPPED,'del ogd:' #FUN-980092 mark
                           LET g_msg = s_dbs_tra CLIPPED,'del ogd:'  #FUN-980092 add
                           CALL cl_err(g_msg,STATUS,1)
                           LET g_success='N'
                       END IF
                       #NO.FUN-7B0018 08/01/31 add --begin                             
                       IF NOT s_industry('std') THEN                                   
                          #IF NOT s_del_ogdi(l_ogd01,'','',s_dbs_new) THEN  #FUN-980092 mark             
                          IF NOT s_del_ogdi(l_ogd01,'','',s_plant_new) THEN  #FUN-980092 add            
                             LET g_success = 'N'
                          END IF                                                       
                       END IF                                                          
                       #NO.FUN-7B0018 08/01/31 add --end
                   END IF    #FUN-670007
               END IF        #MOD-A10139
           END IF            #MOD-A10139
          #IF g_oaz.oaz203='Y' THEN
           IF g_oax.oax04='Y' AND NOT cl_null(g_ofa01) THEN    #NO.FUN-670007
               SELECT * INTO g_ofa.* FROM ofa_file
                WHERE ofa01=g_oga.oga27
               #刪除Invoice單頭檔-->s_dbs_new
              #LET l_sql2="DELETE FROM ",s_dbs_new CLIPPED,"ofa_file", #FUN-980092 mark
           #    LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"ofa_file",  #FUN-980092 add    #FUN-A50102
               LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'ofa_file' ),    #FUN-A50102
                          " WHERE ofa01= ? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE del_ofa FROM l_sql2
               EXECUTE del_ofa USING g_ofa01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                   #LET g_msg = s_dbs_new CLIPPED,'del ofa:' #FUN-980092 mark
                   LET g_msg = s_dbs_tra CLIPPED,'del ofa:'  #FUN-980092 add
                   CALL cl_err(g_msg,STATUS,1) 
                   LET g_success='N'
               END IF
               #刪除Invoice單身檔-->s_dbs_new
              #LET l_sql2="DELETE FROM ",s_dbs_new CLIPPED,"ofb_file", #FUN-980092 mark
            #   LET l_sql2="DELETE FROM ",s_dbs_tra CLIPPED,"ofb_file",  #FUN-980092 add    #FUN-A50102
               LET l_sql2="DELETE FROM ",cl_get_target_table( s_plant_new, 'ofb_file' ),    #FUN-A50102
                          " WHERE ofb01= ? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE del_ofb FROM l_sql2
               EXECUTE del_ofb USING g_ofa01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                   #LET g_msg = s_dbs_new CLIPPED,'del ofb:' #FUN-980092 mark
                   LET g_msg = s_dbs_tra CLIPPED,'del ofb:'  #FUN-980092 add
                   CALL cl_err(g_msg,STATUS,1)
                   LET g_success='N'
               END IF
           END IF 
              #END IF          #MOD-A10139 mark
          #END IF              #MOD-A10139 mark
       END FOR
       MESSAGE ''
 
#更新出貨單之拋轉否='N'
       UPDATE oga_file
          SET oga905='N',
              ogapost = 'N'
        WHERE oga909='Y'          #三角貿易訂單
          AND oga01 = g_oga.oga01
        #MOD-4A0340
       IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
          CALL cl_err3("upd","oga_file",g_oga.oga01,"",STATUS,"","upd oga",1)   #No.FUN-660167
          LET g_success='N' 
       END IF
       #--
       CALL p831_flow99()         #No.7993
       CALL s_showmsg()        #No.FUN-710046 
      IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
END FUNCTION
 
#取得工廠資料並且 抓取要還原的單號
FUNCTION p831_azp(l_n)
  DEFINE l_source LIKE type_file.num5,   #來源站別 #No.FUN-680137 SMALLINT
         l_n      LIKE type_file.num5,   #當站站別 #No.FUN-680137 SMALLINT
         l_sql1   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(800)
 
     ##-------------取得來源資料庫-----------------
     SELECT * INTO s_poy.* FROM poy_file 
      WHERE poy01 = g_poz.poz01 AND poy02 = l_n
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_dbs_new = s_azp.azp03 CLIPPED,"."
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = s_azp.azp01
     LET s_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET s_dbs_tra = g_dbs_tra
     #--End   FUN-980092 add-------------------------------------
 
      LET l_sql1 = "SELECT aza50 ",                                             
                #   "  FROM ",s_dbs_new CLIPPED,"aza_file ",    #FUN-A50102
                   "  FROM ",cl_get_target_table( s_plant_new, 'aza_file' ),   #FUN-A50102
                   "  WHERE aza01 = '0' "                                       
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, s_plant_new ) RETURNING l_sql1    #FUN-A50102
      PREPARE aza_p1 FROM l_sql1                                                
      IF SQLCA.SQLCODE THEN 
#     CALL cl_err('aza_p1',SQLCA.SQLCODE,1)               #No.FUN-710046
      CALL s_errmsg('aza01','0','aza_p1',SQLCA.SQLCODE,1) #No.FUN-710046
      END IF        
      DECLARE aza_c1  CURSOR FOR aza_p1                                         
      OPEN aza_c1                                                               
      FETCH aza_c1 INTO l_aza50                                                 
      CLOSE aza_c1                                                              
 
END FUNCTION
 
#取得要還原的單號
FUNCTION p831_getno() 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
     #LET l_sql = " SELECT oga01 FROM ",s_dbs_new CLIPPED,"oga_file ", #FUN-980092 mark
 #    LET l_sql = " SELECT oga01 FROM ",s_dbs_tra CLIPPED,"oga_file ",  #FUN-980092 add    #FUN-A50102
     LET l_sql = " SELECT oga01 FROM ",cl_get_target_table( s_plant_new, 'oga_file' ),     #FUN-A50102
                 "  WHERE oga99 ='",g_oga.oga99,"'",
                 "    AND oga09 = '5' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
     PREPARE oga01_pre FROM l_sql
     DECLARE oga01_cs CURSOR FOR oga01_pre
     OPEN oga01_cs 
     FETCH oga01_cs INTO g_oga01                              #出貨單
     IF SQLCA.SQLCODE THEN
       #LET g_msg = s_dbs_new CLIPPED,'fetch oga01_cs'      #No.FUN-710046    #FUN-980092 mark
       LET g_msg = s_dbs_tra CLIPPED,'fetch oga01_cs'      #No.FUN-710046     #FUN-980092 add
#       CALL cl_err(g_msg,SQLCA.SQLCODE,1)                  #No.FUN-710046 
        CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)        #No.FUN-710046
        LET g_success = 'N'
     END IF
     IF NOT cl_null(g_oga.oga27) AND g_oax.oax04 = 'Y' THEN    #NO.FUN-670007              
        #LET l_sql = " SELECT ofa01 FROM ",s_dbs_new CLIPPED,"ofa_file ", #FUN-980092 mark
     #   LET l_sql = " SELECT ofa01 FROM ",s_dbs_tra CLIPPED,"ofa_file ",  #FUN-980092 add   #FUN-A50102
        LET l_sql = " SELECT ofa01 FROM ",cl_get_target_table( s_plant_new, 'ofa_file' ),    #FUN-A50102
                    "  WHERE ofa99 ='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
        PREPARE ofa01_pre FROM l_sql
        DECLARE ofa01_cs CURSOR FOR ofa01_pre
        OPEN ofa01_cs 
        FETCH ofa01_cs INTO g_ofa01                              #INVOICE#
        IF SQLCA.SQLCODE THEN
          #LET g_msg = s_dbs_new CLIPPED,'fetch ofa01_cs' #FUN-980092 mark
          LET g_msg = s_dbs_tra CLIPPED,'fetch ofa01_cs'  #FUN-980092 add
#          CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           CALL s_errmsg('','',g_msg,SQLCA.SQLCODE,1)        #No.FUN-710046 
           LET g_success = 'N'
        END IF
     END IF
END FUNCTION
 
#No.7993 清空多角序號
FUNCTION p831_flow99()
     
        UPDATE oga_file SET oga99 = ' ' WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga99",1)   #No.FUN-660167
           CALL s_errmsg('oga01',g_oga.oga01,'',SQLCA.SQLCODE,1)  #No.FUN-710046        
           LET g_success = 'N' RETURN
        END IF
        #更新INVOICE ofa99
        IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' THEN 
           UPDATE ofa_file SET ofa99= ' ' WHERE ofa01 = g_oga.oga27
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err3("upd","ofa_file",g_oga.oga27,"",SQLCA.SQLCODE,"","upd ofa99",1)   #No.FUN-660167
              CALL s_errmsg('ofa01',g_oga.oga27,'',SQLCA.SQLCODE,1)  #No.FUN-710046  
              LET g_success = 'N' RETURN
           END IF
        END IF
END FUNCTION 
