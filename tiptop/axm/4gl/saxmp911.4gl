# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axmp911.4gl
# Descriptions...: 三角貿易出貨通知單拋轉還原作業(逆拋時使用)
# Date & Author..: FUN-670007 06/08/10 BY yiting 
# Modify.........: No.FUN-680137 06/09/11 By bnlent  欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-710019 07/01/15 BY yiting
# Modify.........: No.FUN-710046 07/01/24 By yjkhero 錯誤訊息匯整 
# Modify.........: No.TQC-7C0093 07/12/08 By Davidzv 增加出貨單開窗查詢
# Modify.........: No.CHI-7B0041 07/12/09 By claire 訊息調整 axm-305-->tri-012
# Modify.........: No.MOD-810043 08/01/04 By claire (1)來源站不需產生invoice及packing
#                                                   (2)不應將刪除invoice的判斷包在packing之中
# Modify.........: No.MOD-810077 08/01/11 By claire 拋轉還原前先確認出貨單已拋轉還原才可執行本作業
# Modify.........: No.MOD-810094 08/01/11 By claire 合併出貨時對Packing還原拋轉的條件未考慮
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/21 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/06/18 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B90012 11/09/13 By xianghui 增加ICD行業功能
# Modify.........: No.FUN-C50136 12/08/14 BY xianghui 做信用管控時，需要刪掉oib_file，更新oic_file
# Modify.........: No.FUN-C80001 12/09/03 By bart 還原時需刪除ogc_file,ogg_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   RECORD LIKE oga_file.*    #NO.FUN-670007
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE l_oga   RECORD LIKE oga_file.*    #NO.FUN-620024 
DEFINE l_ogb   RECORD LIKE ogb_file.*    #NO.FUN-620024 
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE g_oha   RECORD LIKE oha_file.*    #NO.FUN-620024                         
DEFINE g_ohb   RECORD LIKE ohb_file.*    #NO.FUN-620024 
DEFINE tm RECORD
          oga09  LIKE oga_file.oga09,
          oga01  LIKE oga_file.oga01
       END RECORD
DEFINE g_poz       RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8047
DEFINE g_poy       RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8047
DEFINE s_poy       RECORD LIKE poy_file.*    #NO.FUN-620024
DEFINE s_dbs_new   LIKE type_file.chr21      #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_new   LIKE type_file.chr21      #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE g_rva01     LIKE rva_file.rva01 
DEFINE g_rvu01     LIKE rvu_file.rvu01 
DEFINE g_oga01     LIKE oga_file.oga01
DEFINE t_oga01     LIKE oga_file.oga01
DEFINE g_ofa01     LIKE ofa_file.ofa01
DEFINE s_azp       RECORD LIKE azp_file.*
DEFINE l_azp       RECORD LIKE azp_file.*
DEFINE g_sw        LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
DEFINE g_t1        LIKE oay_file.oayslip                     #No.FUN-550070  #No.FUN-680137 VARCHAR(5)
DEFINE g_argv1     LIKE oga_file.oga01
DEFINE g_argv2     LIKE oga_file.oga09
DEFINE oga_t1      LIKE oay_file.oayslip  #No.FUN-680137  VARCHAR(5)
DEFINE rva_t1      LIKE oay_file.oayslip  #No.FUN-680137  VARCHAR(5)
DEFINE rvu_t1      LIKE oay_file.oayslip  #No.FUN-680137  VARCHAR(5)
DEFINE l_aza50     LIKE aza_file.aza50      #No.FUN-620024
DEFINE g_pmm01     LIKE pmm_file.pmm01      #No.FUN-620024 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(72)
DEFINE g_ima906 LIKE ima_file.ima906   #FUN-560043
DEFINE l_poy02  LIKE poy_file.poy02     #FUN-710019 
DEFINE l_c      LIKE type_file.num5     #FUN-710019
DEFINE l_plant_new     LIKE azp_file.azp01     #FUN-980092 add
DEFINE l_dbs_tra       LIKE azw_file.azw05     #FUN-980092 add
 
FUNCTION p911(p_argv1,p_argv2)
    DEFINE p_argv1       LIKE oga_file.oga01
    DEFINE p_argv2       LIKE oga_file.oga09

    WHENEVER ERROR CONTINUE
    
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
 
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN 
       CALL p911_p1()
    ELSE
       LET tm.oga09 = g_argv2
       LET tm.oga01 = g_argv1
       OPEN WINDOW win WITH 6 ROWS,70 COLUMNS 
       CALL p911_p2('','','')    #NO.FUN-620054
       CLOSE WINDOW win
    END IF
END FUNCTION
 

FUNCTION p911_p1()
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p911_w WITH FORM "axm/42f/axmp911" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 DISPLAY BY NAME tm.oga09,tm.oga01
 WHILE TRUE
    LET g_action_choice = ''
    INPUT BY NAME tm.oga09,tm.oga01  WITHOUT DEFAULTS  
         AFTER FIELD oga09
            IF cl_null(tm.oga09) THEN 
               NEXT FIELD oga09
            END IF
            IF tm.oga09 NOT MATCHES '[46]' THEN
               NEXT FIELD oga09
            END IF
         AFTER FIELD oga01
            IF cl_null(tm.oga01) THEN
               NEXT FIELD oga01
            END IF
            SELECT * INTO g_oga.*
               FROM oga_file
              WHERE oga01=tm.oga01 
                AND oga09= '5'  #No.8047
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","oga_file",tm.oga01,'5',SQLCA.SQLCODE,"","sel oga",1)    #No.FUN-660167
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga10 IS NOT NULL THEN
               CALL cl_err(g_oga.oga10,'axm-502',1)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
               CALL cl_err(g_oga.oga901,'axm-406',1)
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga905='N' THEN
               CALL cl_err(g_oga.oga905,'tri-012',1)      #CHI-7B0041
               NEXT FIELD oga01 
            END IF
            IF g_oga.oga906 <>'Y' THEN
               CALL cl_err(g_oga.oga906,'axm-402',1)      #No.MOD-660081 modify
               NEXT FIELD oga01 
            END IF
            IF g_oga.ogaconf <>'Y' THEN
               CALL cl_err(g_oga.oga01,'axm-184',1)
               NEXT FIELD oga01 
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         call cl_cmdask()
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
 
         #No.TQC-7C0093---BEGIN---
         ON ACTION controlp
            CASE WHEN INFIELD(oga01)
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_oga12"                                                                                      
               LET g_qryparam.default1 = tm.oga01
               CALL cl_create_qry() RETURNING tm.oga01
               DISPLAY BY NAME tm.oga01
               NEXT FIELD oga01
            END CASE
         #No.TQC-7C0093---END---
   END INPUT
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN 
      CALL p911_p2('','','')    #NO.FUN-620054
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
 CLOSE WINDOW p911_w
END FUNCTION
 
#FUNCTION p911_p2(p_oga01,p_oga09,p_dbs)    #No.FUN-620054 #FUN-980092 mark 
FUNCTION p911_p2(p_oga01,p_oga09,p_plant)    #No.FUN-620054 #FUN-980092 add
  DEFINE p_oga01   LIKE oga_file.oga01     #No.FUN-620054 出貨單號
  DEFINE p_oga09   LIKE oga_file.oga09     #NO.FUN-620054 單據別
  DEFINE p_dbs   LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)           #No.FUN-620054 Database
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3  LIKE type_file.chr1000  #FUN-560043  #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql4  LIKE type_file.chr1000  #NO.FUN-620024                                      #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql5  LIKE type_file.chr1000  #NO.FUN-620024  #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i   LIKE type_file.num5     #No.FUN-680137 SMALLINT
  DEFINE l_oeb   RECORD LIKE oeb_file.*
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_ogd01 LIKE ogd_file.ogd01
  DEFINE l_x     LIKE type_file.chr3     #No.FUN-680137 VARCHAR(3)
  DEFINE l_j     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_msg   LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(60)
  DEFINE p_last  LIKE type_file.num5     #No.FUN-680137  SMALLINT     #流程之最後家數
  DEFINE p_last_plant LIKE cre_file.cre08  #No.FUN-680137 VARCHAR(10)
  DEFINE l_oha   RECORD LIKE oha_file.*   #NO.FUN-620024                         
  DEFINE l_ohb   RECORD LIKE ohb_file.*   #NO.FUN-620024                         
  DEFINE l_oha01 LIKE oha_file.oha01      #NO.FUN-620024 
  DEFINE l_oga99 LIKE oga_file.oga99      #NO.MOD-810077 
  DEFINE p_plant LIKE azp_file.azp01     #FUN-980092 add
  DEFINE l_dbs   LIKE azp_file.azp03     #FUN-980092 add
  DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980092 add
# DEFINE l_oga03 LIKE oga_file.oga03     #FUN-C50136 add 
# DEFINE l_oia07 LIKE oia_file.oia07     #FUN-C50136 add 
 
   #No.FUN-620054 --start--
   #IF cl_null(p_oga01) AND cl_null(p_dbs) THEN #FUN-980092 mark 
   IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
      CALL cl_wait()
      BEGIN WORK 
   END IF
   #No.FUN-620054 --end--
   LET g_success='Y'
   LET s_oea62=0
{
  #保留此段, 若條件改成construct多筆時只要把mark拿掉
  #讀取符合條件之三角貿易訂單資料
  LET l_sql="SELECT * FROM oga_file ",
            " WHERE oga01 ='",tm.oga01,"' ",
             " AND oga09='4' ",
             " AND oga909='Y' ",
             " AND oga905='Y' ",
             " AND oga906='Y' ",
             " AND (oga10 IS NULL OR oga10 =' ' ) ",   #帳單編號必須為null
             " AND ogaconf='Y' "      #已確認之訂單才可轉
  PREPARE p911_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('pre1',SQLCA.SQLCODE,1) END IF
  LET g_success='Y' 
  DECLARE p911_curs1 CURSOR FOR p911_p1
  FOREACH p911_curs1 INTO g_oga.*
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err('sel oga',SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
}
    #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
    IF NOT cl_null(p_plant) THEN
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
       LET p_dbs = s_dbstring(l_azp03)
 
       LET g_plant_new = p_plant
       CALL s_gettrandbs()
       LET l_dbs = g_dbs_tra
    END IF

     IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
        SELECT * INTO g_oga.* FROM oga_file
         WHERE oga01=tm.oga01
           AND oga09= '5' #No.8047
     ELSE
        LET l_sql = " SELECT * ",
                    #"   FROM ",p_dbs CLIPPED,"oga_file ", #FUN-980092 mark
                    #"   FROM ",l_dbs CLIPPED,"oga_file ",  #FUN-980092 add
                    "   FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                    "  WHERE oga01 = '",p_oga01,"' ",
                    "    AND oga09 = '",p_oga09,"' " 
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
        PREPARE oga_pre FROM l_sql
        EXECUTE oga_pre INTO g_oga.*
     END IF
     #No.FUN-620054 --end--
     IF SQLCA.SQLCODE THEN RETURN END IF
     IF g_oga.oga10 IS NOT NULL THEN
        CALL cl_err(g_oga.oga10,'axm-502',1)
        RETURN           
     END IF
     IF g_oga.oga909='N' OR g_oga.oga909 IS NULL THEN
        CALL cl_err(g_oga.oga901,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga09 NOT MATCHES '[5]' THEN
        CALL cl_err(g_oga.oga905,'axm-406',1)
        RETURN           
     END IF
     IF g_oga.oga905='N' THEN
        CALL cl_err(g_oga.oga905,'tri-012',1)      #CHI-7B0041
        RETURN
     END IF
     IF g_oga.oga906 <>'Y' THEN
        CALL cl_err(g_oga.oga906,'axm-402',1)        #No.MOD-660081 modify
        RETURN
     END IF
     #MOD-810077-begin-add
     #判斷出通單拋轉完成才可以繼續作業
      SELECT oga99 INTO l_oga99 FROM oga_file
       WHERE oga01 = g_oga.oga011 
         AND (oga09 = '4' OR oga09= '6')
      IF NOT cl_null(l_oga99) THEN
         CALL cl_err(g_oga.oga01,'axm-228',1)
	 LET g_success = 'N'
         RETURN
      END IF
     #MOD-810077-end-add
 
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        #No.FUN-620054 --start--
        #IF cl_null(p_oga01) AND cl_null(p_dbs) THEN  #FUN-980092 mark
        IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
           LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                       "  WHERE oea01 = ogb31 ",
                       "    AND ogb01 = '",g_oga.oga01,"'",
                       "    AND oeaconf = 'Y' " #01/08/16 mandy
        ELSE
           #LET l_sql1= " SELECT * FROM ",p_dbs CLIPPED,"oea_file, ",  #FUN-980092 mark
           #            "               ",p_dbs CLIPPED,"ogb_file ",   #FUN-980092 mark
           #LET l_sql1= " SELECT * FROM ",l_dbs CLIPPED,"oea_file, ",   #FUN-980092 add
           #            "               ",l_dbs CLIPPED,"ogb_file ",    #FUN-980092 add
            LET l_sql1= " SELECT * FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                       "             , ", cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102
                       "  WHERE oea01 = ogb31 ",
                       "    AND ogb01 = '",g_oga.oga01,"'",
                       "    AND oeaconf = 'Y' " #01/08/16 mandy
        END IF
        #No.FUN-620054 --end--
 	    CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
        CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f 
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該出貨單之訂單
        #No.FUN-620054 --start--
        #IF cl_null(p_oga01) AND cl_null(p_dbs) THEN  #FUN-980092 mark
        IF cl_null(p_oga01) AND cl_null(p_plant) THEN #FUN-980092 add
           SELECT * INTO g_oea.*
             FROM oea_file
            WHERE oea01 = g_oga.oga16
              AND oeaconf = 'Y' #01/08/16 mandy
        ELSE
           LET l_sql = " SELECT * ",
                       #"   FROM ",p_dbs CLIPPED,"oea_file ", #FUN-980092 mark
                       #"   FROM ",l_dbs CLIPPED,"oea_file ",  #FUN-980092 add
                       "   FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                       "  WHERE oea01 = '",g_oga.oga16,"' ",
                       "    AND oeaconf = 'Y'  "  #01/08/16 mandy
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
           PREPARE oea2_pre FROM l_sql
           EXECUTE oea2_pre INTO g_oea.*
        END IF
        #No.FUN-620054 --end--
     END IF
     IF g_oea.oea902 = 'N' THEN
	CALL cl_err('','axm-026',1)  #訂單不為最終流程訂單!
	LET g_success = 'N'
     END IF
     #no.6158檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        LET g_success='N' RETURN
     END IF
     #no.6158
 
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 
     #No.FUN-620054 --end--
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",1)      #No.FUN-660167
         LET g_success = 'N'
         RETURN
     END IF
     IF tm.oga09 = '4' AND g_poz.poz00='2' THEN
        CALL cl_err(g_oea.oea904,'tri-008',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF tm.oga09 = '6' AND g_poz.poz00='1' THEN
        CALL cl_err(g_oea.oea904,'tri-008',1)
        LET g_success = 'N'
        RETURN
     END IF
 
     IF g_poz.pozacti = 'N' THEN 
        CALL cl_err(g_oea.oea904,'tri-009',1)
        LET g_success = 'N'
        RETURN
     END IF
 
     IF g_poz.poz011 = '1' THEN
        CALL cl_err('','axm-412',1) 
        LET g_success = 'N'
        RETURN
     END IF
     CALL s_mtrade_last_plant(g_oea.oea904) 
         RETURNING p_last,p_last_plant       #記錄最後一筆之家數
 
     #依流程代碼最多6層
     FOR i = p_last TO 0 STEP -1
#NO.FUN-710046--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710046--END
           IF i = p_last THEN CONTINUE FOR END IF
           #得到廠商/客戶代碼及database
           CALL p911_azp(i)
#NO.FUN-710019 start-------
           SELECT poy02 INTO l_poy02
             FROM poy_file
            WHERE poy01 = g_poz.poz01
              AND poy04 = g_poz.poz18
           LET l_c = 0
           SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file    
           WHERE poy01 = g_poz.poz01
             AND poy04 = g_poz.poz18
           IF (g_poz.poz19 = 'Y' AND l_c > 0) THEN    #己設立中斷點
               IF g_poy.poy02 <= l_poy02 THEN         #目前站別>中斷點站別時繼續拋轉 
#               EXIT FOR                      #NO.FUN-710046
                CONTINUE FOR                  #NO.FUN-710046
               END IF
           END IF
#NO.FUN-710019 end-----------
           #CALL p911_getno(i,p_dbs)                 #No.8047 取得還原單號 NO.FUN-620054  #FUN-980092 mark
           CALL p911_getno(i,p_plant)                 #No.8047 取得還原單號 NO.FUN-620054 #FUN-980092 add
           #-------------------刪除各單據資料-------------------
           #-----No.FUN-850100-----
           #刪除批/序號資料檔(rvbs_file)
           #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"rvbs_file", #FUN-980092 mark
           #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"rvbs_file",  #FUN-980092 add
           LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102
                      " WHERE rvbs00 = ? ",
                      "   AND rvbs01 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
           PREPARE del_rvbsl FROM l_sql2
           #-----No.FUN-850100 END-----
 
           IF tm.oga09 = '4' OR (tm.oga09='6' AND i <> 0) THEN #No.8047
#              #FUN-C50136--add-str--
#              IF g_oaz.oaz96 ='Y' THEN
#                 LET l_sql2 = "SELECT oga03 FROM ",cl_get_target_table(l_plant_new,'oga_file'),
#                              " WHERE oga01 = ? ",
#                              "   AND oga09 ='5'"
#                 PREPARE sel_oga FROM l_sql2
#                 EXECUTE sel_oga USING g_oga01 INTO l_oga03
#                 CALL s_ccc_oia07('D',l_oga03) RETURNING l_oia07
#                 IF l_oia07 = '0' THEN
#                    CALL s_ccc_rback(l_oga03,'D',g_oga01,0,l_plant_new)
#                 END IF
#              END IF
#              #FUN-C50136--add-end--
               #刪除出貨單單頭檔(oga_file)
               #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"oga_file", #FUN-980092 mark
               #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add
               LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                          " WHERE oga01= ? ",
                          "  AND oga09= '5'"
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE del_oga FROM l_sql2
               EXECUTE del_oga USING g_oga01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  #LET g_msg = l_dbs_new CLIPPED,'del oga' #FUN-980092 mark
                  LET g_msg = l_dbs_tra CLIPPED,'del oga'  #FUN-980092 add
#                 CALL cl_err(g_msg,SQLCA.SQLCODE,1) #NO.FUN-710046
              #NO.FUN-710046--BEGIN
                  IF g_bgerr THEN
                    LET g_showmsg=g_oga01,"/",5
                    CALL s_errmsg('oga01,oga09',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                  ELSE 
                    CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  END IF
              #NO.FUN-710046      
                  LET g_success='N'
               END IF
 
               #刪除出貨單身檔
               #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"ogb_file", #FUN-980092 mark
               #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add
               LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                         " WHERE ogb01= ? "
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE del_ogb FROM l_sql2
               EXECUTE del_ogb USING g_oga01
               IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
                  #LET g_msg = l_dbs_new CLIPPED,'del ogb' #FUN-980092 mark
                  LET g_msg = l_dbs_tra CLIPPED,'del ogb'  #FUN-980092 add
#                 CALL cl_err(g_msg,SQLCA.SQLCODE,1)    #NO.FUN-710046
               #NO.FUN-710046--BEGIN
                  IF g_bgerr THEN 
                    CALL s_errmsg('ogb01',g_oga01,g_msg,SQLCA.SQLCODE,1)
                  ELSE 
                    CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                  END IF
               #NO.FUN-710046--END   
                  LET g_success='N'
               #No.FUN-7B0018 080305 add --begin
               ELSE
                  IF NOT s_industry('std') THEN
                     #IF NOT s_del_ogbi(g_oga01,'',l_dbs_new) THEN #FUN-980092 mark
                     IF NOT s_del_ogbi(g_oga01,'',l_plant_new) THEN #FUN-980092 add
                        LET g_success = 'N'
                     END IF
                  END IF
               #No.FUN-7B0018 080305 add --end
               END IF
               #FUN-C80001---begin
               LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogc_file'), 
                         " WHERE ogc01= ? "
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE del_ogc FROM l_sql2
               EXECUTE del_ogc USING g_oga01
               IF SQLCA.SQLCODE THEN
                  LET g_msg = l_dbs_tra CLIPPED,'del ogc:'
                  CALL s_errmsg('','',g_msg,STATUS,1)
                  LET g_success='N'
               END IF
               LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogg_file'), 
                         " WHERE ogg01= ? "
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
               PREPARE del_ogg FROM l_sql2
               EXECUTE del_ogg USING g_oga01
               IF SQLCA.SQLCODE THEN
                  LET g_msg = l_dbs_tra CLIPPED,'del ogg:'
                  CALL s_errmsg('','',g_msg,STATUS,1)
                  LET g_success='N'
               END IF
               #FUN-C80001---end
               #-----No.FUN-850100-----
               #刪除批/序號資料
               EXECUTE del_rvbsl USING 'axmt850',g_oga01
               IF SQLCA.SQLCODE THEN
                  #LET g_msg = l_dbs_new CLIPPED,'del rvbs:'    #FUN-980092 mark
                  LET g_msg = l_dbs_tra CLIPPED,'del rvbs:'     #FUN-980092 add
                  CALL s_errmsg('','',g_msg,STATUS,1)
                  LET g_success='N'
               END IF
               #-----No.FUN-850100 END-----

               ##FUN-B90012-add-str--
               IF s_industry('icd') THEN
                  CALL icd_idb_del(g_oga01,'',l_plant_new)
               END IF
               #FUN-B90012-add-str--
 
           #END IF          #MOD-810043-mark
           IF (g_oaz.oaz67 = '1' AND g_oax.oax05='Y') THEN  
              #MOD-810094-begin-modify
               #SELECT COUNT(*) INTO g_cnt FROM ogd_file,oga_file
               # WHERE ogd01=oga01 AND oga16=g_oga.oga16 AND oga30='Y'
               IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                  SELECT COUNT(*) INTO g_cnt FROM ogd_file,oga_file
                   WHERE ogd01 = oga01
                     AND (oga16 = g_oga.oga16 OR oga16 IS NULL)
                     AND oga30='Y'  
                     AND oga01=g_oga.oga01
               ELSE
                   LET l_sql = "SELECT COUNT(*) ",
                               #"  FROM ",p_dbs CLIPPED,"ogd_file,",p_dbs CLIPPED,"oga_file ", #FUN-980092 mark
                               #"  FROM ",l_dbs CLIPPED,"ogd_file,",l_dbs CLIPPED,"oga_file ",  #FUN-980092 add
                               "  FROM ",cl_get_target_table(p_plant,'ogd_file'),  #FUN-A50102
                                    ",", cl_get_target_table(p_plant,'oga_file'),  #FUN-A50102
                               " WHERE ogd01 = oga01 ",
                               "   AND (oga16 = '",g_oga.oga16,"' OR oga16 IS NULL) "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
                   PREPARE ogd_pre FROM l_sql
                   EXECUTE ogd_pre INTO g_cnt
               END IF
              #MOD-810094-end-modify
               IF g_cnt> 0 THEN               #有輸入Packing List才拋轉
                   LET l_ogd01 = g_oga01
                   #no.4495(end)
                   IF NOT cl_null(g_oga01) THEN   #本區有抓到出貨單號時再DELETE
                       #刪除包裝單身檔-->l_dbs_new
                       #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"ogd_file", #FUN-980092 mark
                       #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ogd_file",  #FUN-980092 add
                       LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ogd_file'), #FUN-A50102
                                  " WHERE ogd01= ? "
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                       PREPARE del_ogd FROM l_sql2
                       EXECUTE del_ogd USING l_ogd01
                       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                           #LET g_msg = l_dbs_new CLIPPED,'del ogd:' #FUN-980092 mark
                           LET g_msg = l_dbs_tra CLIPPED,'del ogd:'  #FUN-980092 add
             #             CALL cl_err(g_msg,STATUS,1) #NO.FUN-710046
                  #NO.FUN-710046--BEGIN
                           IF g_bgerr THEN 
                             CALL s_errmsg('ogd01',l_ogd01,g_msg,STATUS,1)
                           ELSE 
                             CALL cl_err(g_msg,STATUS,1)
                           END IF
                  #NO.FUN-710046--END   
                           LET g_success='N'
                       END IF
                       #NO.FUN-7B0018 08/01/31 add --begin                             
                       IF NOT s_industry('std') THEN                                   
                          #IF NOT s_del_ogdi(l_ogd01,'','',l_dbs_new) THEN      #FUN-980092 mark         
                          IF NOT s_del_ogdi(l_ogd01,'','',l_plant_new) THEN      #FUN-980092 add        
                             LET g_success='N'
                          END IF                                                       
                       END IF                                                          
                       #NO.FUN-7B0018 08/01/31 add --end
                   END IF    #FUN-670007
               END IF     #MOD-810043
           END IF         #MOD-810043
           #-----------------刪除Invoice資料-------------------------
                   IF g_oax.oax04='Y' AND NOT cl_null(g_ofa01) THEN    #NO.FUN-670007
                     #MOD-810094-begin-modify
                     # SELECT * INTO g_ofa.* FROM ofa_file
                     #  WHERE ofa01=g_oga.oga27
                      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                          SELECT COUNT(*) INTO g_cnt FROM ofa_file,ofb_file
                           WHERE ofa01=g_oga.oga27      AND ofaconf='Y'
                             AND ofa01=ofb01
                      ELSE
                          LET l_sql = "SELECT COUNT(*) ",
                                      #"  FROM ",p_dbs CLIPPED,"ofa_file,",p_dbs CLIPPED,"ofb_file ",  #FUN-980092 mark
                                      #"  FROM ",l_dbs CLIPPED,"ofa_file,",l_dbs CLIPPED,"ofb_file ",   #FUN-980092 add
                                      "  FROM ",cl_get_target_table(p_plant,'ofa_file'),",", #FUN-A50102
                                                cl_get_target_table(p_plant,'ofb_file'),     #FUN-A50102 
                                      " WHERE ofa01='",g_oga.oga27,"'  ",
                                      "   AND ofa01=ofb01 ",
                                      "   AND ofaconf='Y' "
 	                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
                          PREPARE ofa_pre3 FROM l_sql
                          EXECUTE ofa_pre3 INTO g_cnt
                      END IF
                     IF g_cnt = 0 THEN
                      IF g_bgerr THEN 
                       LET g_msg=g_oga.oga27,"/",'Y'                
                       CALL s_errmsg('ofa01,ofaconf',g_msg,'sel ofa:',SQLCA.SQLCODE,1)  
                      ELSE 
                       CALL cl_err('sel ofa:',SQLCA.SQLCODE,1)
                      END IF 
                       LET g_success='N'
                     ELSE
             #MOD-810094-end-modify
                       #刪除Invoice單頭檔-->l_dbs_new
                       #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"ofa_file",#FUN-980092 mark
                       #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ofa_file",#FUN-980092 add
                       LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ofa_file'),     #FUN-A50102 
                                  " WHERE ofa01= ? "
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                       PREPARE del_ofa FROM l_sql2
                       EXECUTE del_ofa USING g_ofa01
                       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                           #LET g_msg = l_dbs_new CLIPPED,'del ofa:'  #FUN-980092 mark
                           LET g_msg = l_dbs_tra CLIPPED,'del ofa:'  #FUN-980092 add
           #               CALL cl_err(g_msg,STATUS,1)  #NO.FUN-710046
                         #NO.FUN-710046--BEGIN
                           IF g_bgerr THEN 
                             CALL s_errmsg('ofa01',g_ofa01,g_msg,STATUS,1)
                           ELSE 
                             CALL cl_err(g_msg,STATUS,1)
                           END IF
                        #NO.FUN-710046--END   
                           LET g_success='N'
                       END IF
                       #刪除Invoice單身檔-->l_dbs_new
                       #LET l_sql2="DELETE FROM ",l_dbs_new CLIPPED,"ofb_file", #FUN-980092 mark
                       #LET l_sql2="DELETE FROM ",l_dbs_tra CLIPPED,"ofb_file",  #FUN-980092 add
                       LET l_sql2="DELETE FROM ",cl_get_target_table(l_plant_new,'ofb_file'),     #FUN-A50102 
                                  " WHERE ofb01= ? "
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                       PREPARE del_ofb FROM l_sql2
                       EXECUTE del_ofb USING g_ofa01
                       IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3] = 0 THEN
                           #LET g_msg = l_dbs_new CLIPPED,'del ofb:' #FUN-980092 mark
                           LET g_msg = l_dbs_tra CLIPPED,'del ofb:'  #FUN-980092 add
           #               CALL cl_err(g_msg,STATUS,1)    #NO.FUN-710046
                           #NO.FUN-710046--BEGIN
                           IF g_bgerr THEN 
                              CALL s_errmsg('ofb01',g_ofa01,g_msg,STATUS,1)
                           ELSE 
                              CALL cl_err(g_msg,STATUS,1)
                           END IF
                          #NO.FUN-710046--END   
                           LET g_success='N'
                       END IF
                     END IF   #MOD-810079 add 
                   END IF 
               #END IF     #MOD-810043-mark
           #END IF         #MOD-810043-mark
           END IF          #MOD-810043-add  
           #-------------------刪除各單據資料-------------------
        END FOR
#NO.FUN-710046--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710046--END
       MESSAGE ''
 
       #更新出貨單之拋轉否='N'
       #IF cl_null(p_dbs) THEN  #FUN-980092 mark
       IF cl_null(p_plant) THEN #FUN-980092 add
         UPDATE oga_file
            SET oga905='N',
                oga99 = ' '         #No.8047
          WHERE oga909='Y'          #三角貿易出貨單
            AND oga01 = g_oga.oga01
       ELSE
          #LET l_sql = " UPDATE ",p_dbs CLIPPED,"oga_file ",#FUN-980092 mark
          #LET l_sql = " UPDATE ",l_dbs CLIPPED,"oga_file ",#FUN-980092 add
          LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                      "    SET oga905 = 'N', ",
                      "        oga99 = ' '  ",       #No.8047
                      "  WHERE oga909='Y' ",          #三角貿易出貨單
                      "    AND oga01 = '",g_oga.oga01,"' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
          PREPARE oga_upd_pre FROM l_sql
          EXECUTE oga_upd_pre
       END IF
       IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
#         CALL cl_err('upd oga',STATUS,1)   #NO.FUN-710046
        #NO.FUN-710046--BEGIN
          IF g_bgerr THEN 
           CALL s_errmsg('oga01',g_oga.oga01,'upd oga',STATUS,1) 
          ELSE 
           CALL cl_err('upd oga',STATUS,1)
          END IF
        #NO.FUN-710046--END   
          LET g_success='N'
       END IF
       #--
       #CALL p911_flow99(p_dbs)         #No.8047 #No.FUN-620054  #FUN-980092 mark
       CALL p911_flow99(p_plant)         #No.8047 #No.FUN-620054  #FUN-980092 add
 
   #IF cl_null(p_oga01) AND cl_null(p_dbs) THEN #FUN-980092 mark
   IF cl_null(p_oga01) AND cl_null(p_plant) THEN  #FUN-980092 add
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   
END FUNCTION
 
#取得工廠資料
FUNCTION p911_azp(l_n)
   DEFINE l_source LIKE type_file.num5,    #No.FUN-680137  SMALLINT,    #來源站別
          l_n      LIKE type_file.num5     #當站站別  #No.FUN-680137 SMALLINT
   DEFINE l_sql1   LIKE type_file.chr1000   #NO.FUN-620024  #No.FUN-680137 VARCHAR(800)
 
   ##-------------取得當站資料庫----------------------
   SELECT * INTO g_poy.* FROM poy_file                  #取得當站流程設定
    WHERE poy01 = g_poz.poz01
      AND poy02 = l_n
   #No.FUN-620054 --end-- 
   SELECT * INTO l_azp.* FROM azp_file
    WHERE azp01 = g_poy.poy04
  #LET l_dbs_new = l_azp.azp03 CLIPPED,"." #TQC-950020   
   LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED) #TQC-950020   
 
   #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
   LET g_plant_new = l_azp.azp01
   LET l_plant_new = g_plant_new
   CALL s_gettrandbs()
   LET l_dbs_tra = g_dbs_tra
   #--End   FUN-980092 add-------------------------------------
 
   #NO.FUN-620024  --start--                                                 
   LET l_sql1 = "SELECT aza50 ",                                             
                #"  FROM ",l_dbs_new CLIPPED,"aza_file ",
                "  FROM ",cl_get_target_table(g_poy.poy04,'aza_file'), #FUN-A50102
                "  WHERE aza01 = '0' "                                       
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,g_poy.poy04) RETURNING l_sql1 #FUN-A50102
   PREPARE aza_p1 FROM l_sql1                                                
#  IF SQLCA.SQLCODE THEN CALL cl_err('aza_p1',SQLCA.SQLCODE,1) END IF         #NO.FUN-710046
#NO.FUN-710046--BEGIN
   IF SQLCA.SQLCODE THEN
    IF g_bgerr THEN
     CALL s_errmsg('aza01',0,'aza_p1',SQLCA.SQLCODE,1)
    ELSE
     CALL cl_err('aza_p1',SQLCA.SQLCODE,1)    
    END IF
   END IF
#NO.FUN-710046--END  
   DECLARE aza_c1  CURSOR FOR aza_p1                                         
   OPEN aza_c1                                                               
   FETCH aza_c1 INTO l_aza50                                                 
   CLOSE aza_c1                                                              
   #NO.FUN-620024  --end--
 
END FUNCTION
 
#No.7742
FUNCTION p911_chkoeo(p_oeo01,p_oeo03,p_oeo04)
   DEFINE p_oeo01 LIKE oeo_file.oeo01
   DEFINE p_oeo03 LIKE oeo_file.oeo03
   DEFINE p_oeo04 LIKE oeo_file.oeo04
   DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
   #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_new,"oeo_file ", #FUN-980092 mark
   #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_tra,"oeo_file ", #FUN-980092 add
   LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeo_file'), #FUN-A50102
             "  WHERE oeo01 = '",p_oeo01,"'",
             "    AND oeo03 = '",p_oeo03,"'",
             "    AND oeo04 = '",p_oeo04,"'",
             "    AND oeo08 = '2' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
   PREPARE chkoeo_pre FROM l_sql
 
   DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
 
   OPEN chkoeo_cs 
   FETCH chkoeo_cs INTO g_cnt
 
   IF g_cnt > 0 THEN
      RETURN 1
   ELSE
      RETURN 0 
   END IF
 
END FUNCTION 
#No.7742(end)
 
#No.8047
#取得要還原的單號
#FUNCTION p911_getno(l_n,p_dbs)        #No.FUN-620054   #FUN-980092 mark
FUNCTION p911_getno(l_n,p_plant)        #No.FUN-620054  #FUN-980092 add
   DEFINE p_dbs LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)              #No.FUN-620054
   DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
   DEFINE l_slip LIKE oga_file.oga01
   DEFINE l_n   LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE p_plant LIKE azp_file.azp01     #FUN-980092 add
   DEFINE l_dbs   LIKE azp_file.azp03     #FUN-980092 add
   DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980092 add
   
    #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
    IF NOT cl_null(p_plant) THEN
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
       LET p_dbs = s_dbstring(l_azp03)
 
       LET g_plant_new = p_plant
       CALL s_gettrandbs()
       LET l_dbs = g_dbs_tra
    END IF
    #--End   FUN-980092 add-------------------------------------
   
   IF tm.oga09 = '4' OR (tm.oga09='6' AND l_n <> 0) THEN #No.8047
      #LET l_sql = " SELECT oga01 FROM ",l_dbs_new CLIPPED,"oga_file ",  #FUN-980092 mark
      #LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",   #FUN-980092 add
      LET l_sql = " SELECT oga01 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                  "  WHERE oga99 ='",g_oga.oga99,"'",
                  "    AND oga09 = '5' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE oga01_pre FROM l_sql
      DECLARE oga01_cs CURSOR FOR oga01_pre
      OPEN oga01_cs 
      FETCH oga01_cs INTO g_oga01                              #出貨單
      IF SQLCA.SQLCODE THEN
         #LET g_msg = l_dbs_new CLIPPED,'fetch oga01_cs' #FUN-980092 mark
         LET g_msg = l_dbs_tra CLIPPED,'fetch oga01_cs'  #FUN-980092 add
#        CALL cl_err(g_msg,SQLCA.SQLCODE,1) #NO.FU-710046
#NO.FUN-710046--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_oga.oga99,"/",5
           CALL s_errmsg('oga99,oga09',g_showmsg,g_msg,SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err(g_msg,SQLCA.SQLCODE,1)
         END IF
#NO.FUN-710046--END
         LET g_success = 'N'
      END IF
      #MOD-520099
      LET l_slip=''
      IF g_oaz.oaz67 = '1' THEN    #PACKING來源為出通單時
          #IF cl_null(p_dbs) THEN  #FUN-980092 mark
          IF cl_null(p_plant) THEN #FUN-980092 add
             SELECT ofa01 INTO l_slip FROM ofa_file
              #WHERE ofa011=g_oga.oga011
              WHERE ofa011=g_oga.oga01
                AND ofa99=g_oga.oga99   #No.TQC-5C0131
          ELSE
             LET l_sql = " SELECT ofa01 ",
                         #"   FROM ",p_dbs CLIPPED,"ofa_file ", #FUN-980092 mark
                         #"   FROM ",l_dbs CLIPPED,"ofa_file ",  #FUN-980092 add
                         "   FROM ",cl_get_target_table(p_plant,'ofa_file'), #FUN-A50102
                         "  WHERE ofa011 = '",g_oga.oga011,"' ",
                         "    AND ofa99 = '",g_oga.oga99,"' "   #No.TQC-5C0131
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
             PREPARE ofa_pre FROM l_sql
             EXECUTE ofa_pre INTO l_slip
          END IF
          #No.FUN-620054 --end--
          #-----No.MOD-5C0147 END-----
      ELSE 
         LET l_slip=g_oga.oga27
      END IF
      #--
   
      IF g_oaz.oaz67 = '1' THEN    #PACKING來源為出通單時
          IF NOT cl_null(l_slip) AND g_oax.oax04 = 'Y' THEN  
             #LET l_sql = " SELECT ofa01 FROM ",l_dbs_new CLIPPED,"ofa_file ", #FUN-980092 mark
             #LET l_sql = " SELECT ofa01 FROM ",l_dbs_tra CLIPPED,"ofa_file ",  #FUN-980092 add
             LET l_sql = " SELECT ofa01 FROM ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102
                         "  WHERE ofa99 ='",g_oga.oga99,"'"
   
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
             PREPARE ofa01_pre FROM l_sql
             DECLARE ofa01_cs CURSOR FOR ofa01_pre
             OPEN ofa01_cs 
             FETCH ofa01_cs INTO g_ofa01                              #INVOICE#
             IF SQLCA.SQLCODE THEN
                #LET g_msg = l_dbs_new CLIPPED,'fetch ofa01_cs' #FUN-980092 mark
                LET g_msg = l_dbs_tra CLIPPED,'fetch ofa01_cs'  #FUN-980092 add
#               CALL cl_err(g_msg,SQLCA.SQLCODE,1)             #NO.FUN-710046
           #NO.FUN-710046--BEGIN
                IF g_bgerr THEN
                  CALL s_errmsg('ofa99',g_oga.oga99,g_msg,SQLCA.SQLCODE,1)            
                ELSE
                  CALL cl_err(g_msg,SQLCA.SQLCODE,1)  
                 END IF
           #NO.FUN-710046--END   
                LET g_success = 'N'
             END IF
          END IF
      END IF
   END IF
 
END FUNCTION
#No.8047(end)
 
#No.8047 清空多角序號
#FUNCTION p911_flow99(p_dbs)     #No.FUN-620054  #FUN-980092 mark
FUNCTION p911_flow99(p_plant)     #No.FUN-620054 #FUN-980092 add
   DEFINE p_dbs   LIKE type_file.chr21,     #No.FUN-680137 VARCHAR(21),     #No.FUN-620054
          l_sql   LIKE type_file.chr1000    #No.FUN-620054  #No.FUN-680137 VARCHAR(200)
   DEFINE p_plant LIKE azp_file.azp01     #FUN-980092 add
   DEFINE l_dbs   LIKE azp_file.azp03     #FUN-980092 add
   DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980092 add
   
   
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
   IF cl_null(p_dbs) THEN
        UPDATE oga_file SET oga99 = ' ' WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga99",1)    #No.FUN-660167 #NO.FUN-710046
        #NO.FUN-710046--BEGIN
           IF g_bgerr THEN
              CALL s_errmsg('oga01',g_oga.oga01,"upd oga99",SQLCA.SQLCODE,1)
           ELSE
              CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga99",1) 
           END IF
        #NO.FUN-710046--END    
           LET g_success = 'N' RETURN
        END IF
        #更新INVOICE ofa99
        IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' THEN  #NO.FUN-670007
           UPDATE ofa_file SET ofa99= ' ' WHERE ofa01 = g_oga.oga27
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err3("upd","ofa_file",g_oga.oga27,"",SQLCA.SQLCODE,"","upd  ofa99",1)    #NO.FUN-710046
        #NO.FUN-710046--BEGIN
              IF g_bgerr THEN
               CALL s_errmsg('ofa01',g_oga.oga27,"upd  ofa99",SQLCA.SQLCODE,1)
              ELSE
               CALL cl_err3("upd","oga_file",g_oga.oga27,"",SQLCA.SQLCODE,"","upd ofa99",1) 
              END IF
        #NO.FUN-710046--END    
              LET g_success = 'N' RETURN
           END IF
        END IF
   ELSE
      #LET l_sql = " UPDATE ",p_dbs CLIPPED,"oga_file SET oga99 = ' ' ",
      #LET l_sql = " UPDATE ",l_dbs CLIPPED,"oga_file SET oga99 = ' ' ",
      LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                     " SET oga99 = ' ' ",
                  "  WHERE oga01 = '",g_oga.oga01,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
      PREPARE oga_upd2_pre FROM l_sql
      EXECUTE oga_upd2_pre
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd oga99',SQLCA.SQLCODE,1)  #NO.FUN-710046
        #NO.FUN-710046--BEGIN
          IF g_bgerr THEN
             CALL s_errmsg('oga01',g_oga.oga01,"upd  oga99",SQLCA.SQLCODE,1)
          ELSE
             CALL cl_err('upd oga99',SQLCA.SQLCODE,1)
          END IF
        #NO.FUN-710046--END    
         LET g_success = 'N' RETURN
      END IF
      #更新INVOICE ofa99
      IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' THEN   #NO.FUN-670007
         #LET l_sql = " UPDATE ",p_dbs CLIPPED,"ofa_file SET ofa99= ' ' ", #FUN-980092 mark
         #LET l_sql = " UPDATE ",l_dbs CLIPPED,"ofa_file SET ofa99= ' ' ",  #FUN-980092 add
         LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'ofa_file'), #FUN-A50102
                        " SET ofa99= ' ' ", 
                     "  WHERE ofa01 = '",g_oga.oga27,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
         PREPARE ofa_upd_pre FROM l_sql
         EXECUTE ofa_upd_pre
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        #   CALL cl_err('upd ofa99',SQLCA.SQLCODE,1) #NO.FUN-710046
        #NO.FUN-710046--BEGIN
            IF g_bgerr THEN
               CALL s_errmsg('ofa01',g_oga.oga27,"upd  oga99",SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err('upd ofa99',SQLCA.SQLCODE,1)
            END IF
        #NO.FUN-710046--END    
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF 
 
END FUNCTION 
#No.8047(end)
