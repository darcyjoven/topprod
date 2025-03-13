# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acop520.4gl
# Descriptions...: 材料/成品明細資料擷取作業(內部)
# Date & Author..: No.MOD-490398 05/01/18 By Danny
# Modify.........: No.MOD-490398 05/02/25 By Carrier 材料時新增cor14='3'報廢的狀態
# Modify.........: No.MOD-490398 05/03/01 By Carrier
#                  1.報廢的來源修改為 tlf_file和cop_file 因為有可能先被cop_file擷取了
#                  2.TRANSACTION不能被包含在FOREACH中.
# Modify.........: No.FUN-550036 05/05/23 By Trisy 單據編號加大
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-570116 06/02/27 By yiting 批次背景執行
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()      
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/11 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980014 09/10/13 By rainy con01 default 空白，全部plant設定相同的擷取條件
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-BB0083 11/12/26 By xujing 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cor            RECORD LIKE cor_file.*
DEFINE tm               RECORD
       conf             LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
                        END RECORD
DEFINE g_wc,g_wc2,g_sql STRING                     #No.FUN-680069 #No.FUN-580092 HCN 
DEFINE yclose,mclose    LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE g_cnt            LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE g_msg            LIKE zaa_file.zaa08         #No.FUN-680069 VARCHAR(255)
DEFINE g_i              LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE g_change_lang    LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)  #No.FUN-570116
 
MAIN
   DEFINE l_flag        LIKE type_file.chr1                   #No.FUN-570116        #No.FUN-680069 VARCHAR(1)
 
   OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.conf = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
WHILE TRUE
   IF g_bgjob="N" THEN
       CALL p520_p1()
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          LET g_success='Y'
          BEGIN WORK
          CALL p520_s1()
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
         ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p520_w
             EXIT WHILE
          END IF
      ELSE
         CONTINUE WHILE
      END IF
   ELSE
     LET g_success='Y'
     BEGIN WORK
     CALL p520_s1()
     IF g_success="Y" THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     EXIT WHILE
   END IF
 END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p520_p1()
 DEFINE l_tlf06     LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(80) 
 DEFINE d_tlf06     LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(24)
 DEFINE bdate,edate LIKE type_file.chr20        #No.FUN-680069 VARCHAR(10)
 DEFINE l_date      LIKE type_file.dat          #No.FUN-680069 DATE
 DEFINE l_ac,i      LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE lc_cmd      LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(500) #No.FUN-570116
 
   OPEN WINDOW p520_w WITH FORM "aco/42f/acop520"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()

   CLEAR FORM
 
  CALL cl_opmsg('z')
  LET l_date= MDY(MONTH(g_today),1,YEAR(g_today))-1
  LET edate = g_today
  LET bdate = MDY(MONTH(g_today),1,YEAR(g_today))
  LET d_tlf06=bdate CLIPPED,':',edate CLIPPED
  LET yclose= YEAR(l_date)
  LET mclose= MONTH(l_date)
  LET tm.conf = 'Y'
  LET g_bgjob = "N"         #No.FUN-570116
 
 
  WHILE TRUE
     #INPUT BY NAME tm.conf WITHOUT DEFAULTS 
     INPUT BY NAME tm.conf,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570116
 
        AFTER FIELD conf 
           IF cl_null(tm.conf) OR tm.conf NOT MATCHES '[YN]' THEN
              NEXT FIELD conf
           END IF
 
        ON ACTION locale
           LET g_change_lang= TRUE                   #No.FUN-570116
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT INPUT
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_set_comp_entry("g_bgjob",TRUE)  #NO.FUN-570116
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
#No.FUN-570611--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
      END IF
 
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "acop520"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('acop520','9031',1)
        ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",tm.conf CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop520',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
   EXIT WHILE
   #No.FUN-570116--end--
 END WHILE
END FUNCTION
 
FUNCTION p520_s1()
  DEFINE l_tlf    RECORD LIKE tlf_file.*
  DEFINE no       LIKE tlf_file.tlf026        #No.FUN-680069 VARCHAR(16)  #No.FUN-550036 
  DEFINE seq      LIKE tlf_file.tlf027        #No.FUN-680069 SMALLINT
  DEFINE l_tlf_rowid     LIKE type_file.row_id  #chr18 FUN-A70120
  DEFINE l_type   LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
  DEFINE l_flag   LIKE type_file.num5         #No.FUN-680069 SMALLINT
  DEFINE l_dbs    LIKE type_file.chr21        #No.FUN-680069 LIKE azp_file.azp03
  DEFINE l_cnz01  LIKE cnz_file.cnz01
  DEFINE l_cnz04  LIKE cnz_file.cnz04
  DEFINE l_za05   LIKE za_file.za05        
  DEFINE l_name   LIKE type_file.chr20        #No.FUN-680069 VARCHAR(20)
  DEFINE l_cop    RECORD LIKE cop_file.*
  DEFINE l_cor    RECORD LIKE cor_file.*
  DEFINE l_chr    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  CALL cl_wait()                   # Wait.....     
 
  CALL cl_outnam('acop520') RETURNING l_name
  START REPORT p520_rep TO l_name
 
  DECLARE cnz_curs CURSOR FOR
    SELECT UNIQUE azp01 FROM azp_file 
     WHERE azp01 IN( SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user ) 
     ORDER BY azp01
  IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF

  #工廠別
  FOREACH cnz_curs INTO l_cnz01 
    IF STATUS THEN 
       CALL cl_err('foreach cnz',STATUS,1) LET g_success='N' EXIT FOREACH 
    END IF
    IF cl_null(l_cnz01)  THEN CONTINUE FOREACH END IF 
    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_cnz01
   
    LET g_plant_new = l_cnz01   
    CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
 
    LET g_sql= "SELECT rowid,tlf_file.*",
              #"  FROM ",s_dbstring(g_dbs_tra CLIPPED),"tlf_file", #FUN-980092 ADD   #FUN-A50102
               "  FROM ",cl_get_target_table(g_plant_new,'tlf_file'),   #FUN-A50102
               " WHERE (tlf910 IS NULL OR tlf910='')",       #合同是否已擷取   
               "   AND ((tlf02 = 50 AND tlf03 = 60) ",       #發料
               "    OR  (tlf02 = 60 AND tlf03 = 50) ",       #退料
               "    OR  ((tlf02=50 OR tlf02=60) AND tlf03=40) ", #報廢
               "    OR  ((tlf02 = 60 OR tlf02 = 65) AND tlf03 = 50) ", #完工入庫
               "    OR  (tlf02 = 25 AND tlf03 = 50)) "       #委外收貨入庫
 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    DECLARE cnz_b_curs CURSOR FOR
       SELECT cnz04 FROM cnz_file WHERE cnz02 = '3' ##AND cnz01 = l_cnz01   #FUN-980014 remark cnz01條件
        ORDER BY cnz04
    IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
    FOREACH cnz_b_curs INTO l_cnz04
       IF STATUS THEN 
          CALL cl_err('foreach cnz',STATUS,1) LET g_success='N' EXIT FOREACH 
       END IF
       LET g_sql = g_sql CLIPPED," AND ",l_cnz04 CLIPPED
    END FOREACH
    LET g_sql = g_sql CLIPPED,"  ORDER BY tlf036,tlf037 "
    CALL cl_parse_qry_sql(g_sql,l_cnz01) RETURNING g_sql   #FUN-980014
    PREPARE p520_p1 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('p520_p1',STATUS,1) LET g_success = 'N' EXIT FOREACH
    END IF
    DECLARE p520_s1_c CURSOR FOR p520_p1
 
    FOREACH p520_s1_c INTO l_tlf_rowid,l_tlf.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF
    
       #No.MOD-490398  --begin
      IF l_tlf.tlf02 = 50 OR l_tlf.tlf03 = 40 THEN 
         LET no=l_tlf.tlf026 LET seq=l_tlf.tlf027
      ELSE
         LET no=l_tlf.tlf036 LET seq=l_tlf.tlf037
      END IF
      SELECT * FROM cor_file WHERE cor01=no AND cor02=seq
      IF SQLCA.sqlcode = 0 THEN
         CONTINUE FOREACH  #已經擷取過該資料了
      END IF
      #檢查是否為保稅料件
      CALL p520_chk(l_tlf.tlf01) RETURNING l_flag,l_type  
      IF l_flag THEN CONTINUE FOREACH END IF
      LET l_chr='a'
      OUTPUT TO REPORT p520_rep(l_chr,no,seq,l_tlf_rowid,l_tlf.*,l_type)
    END FOREACH
 
    #新增從cop_file來擷取報廢的資料
    LET g_sql= "SELECT *",
              #"  FROM ",s_dbstring(g_dbs_tra CLIPPED),"cop_file", #FUN-980092 ADD   #FUN-A50102
               "  FROM ",cl_get_target_table(l_cnz01,'cop_file'),   #FUN-A50102
               " WHERE cop10='7'"       #報廢
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,l_cnz01) RETURNING g_sql     #FUN-980014

    PREPARE p520_p2 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('p520_p2',STATUS,1) LET g_success = 'N' EXIT FOREACH
    END IF
    DECLARE p520_s2_c CURSOR FOR p520_p2
 
    FOREACH p520_s2_c INTO l_cop.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF
      SELECT * FROM cor_file WHERE cor01=l_cop.cop01 AND cor02=l_cop.cop02
      IF SQLCA.sqlcode = 0 THEN
         CONTINUE FOREACH  #已經擷取過該資料了
      END IF
      LET l_cor.cor00='2'
      LET l_cor.cor01=l_cop.cop01
      LET l_cor.cor02=l_cop.cop02
      LET l_cor.cor03=l_cop.cop03
      LET l_cor.cor04=l_cop.cop04
      LET l_cor.cor05=l_cop.cop11
      LET l_cor.cor06=l_cop.cop19
      LET l_cor.cor07=l_cop.cop05
      LET l_cor.cor08=l_cop.cop06
      LET l_cor.cor09=l_cop.cop14
      LET l_cor.cor10=l_cop.cop15
      LET l_cor.cor11=l_cop.cop16/l_cop.cop14
      LET l_cor.cor12=l_cop.cop16
      LET l_cor.cor13=l_cop.cop17
      LET l_cor.cor14='3'
      LET l_cor.cor15=NULL 
      LET l_cor.corconf='N'
      LET l_cor.coracti='Y'
      LET l_cor.coruser=g_user
      LET l_cor.corgrup=g_grup
      LET l_cor.cordate=g_today
      LET l_cor.corplant = g_plant  #FUN-980002
      LET l_cor.corlegal = g_legal  #FUN-980002
 
      LET l_cor.cororiu = g_user      #No.FUN-980030 10/01/04
      LET l_cor.cororig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO cor_file VALUES(l_cor.*)
      
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","cor_file",l_cor.cor01,l_cor.cor02,STATUS,"","ins cor",0) #NO.TQC-660045
         LET g_success='N'
      END IF
      LET l_chr='b'
      INITIALIZE l_tlf.* TO NULL
      LET no          =l_cor.cor01
      LET seq         =l_cor.cor02
      LET l_tlf.tlf026=l_cor.cor01
      LET l_tlf.tlf027=l_cor.cor02
      LET l_tlf.tlf06 =l_cor.cor03
      LET l_tlf.tlf01 =l_cor.cor04
      OUTPUT TO REPORT p520_rep(l_chr,no,seq,l_tlf_rowid,l_tlf.*,NULL)
 
    END FOREACH
 
     #No.MOD-490398 - -end   
 END FOREACH 
 
   #No.MOD-490398  --begin
  IF g_success = 'Y' THEN
     COMMIT WORK
  ELSE
     ROLLBACK WORK
  END IF
   #No.MOD-490398  --end  
 
  FINISH REPORT p520_rep
  CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
FUNCTION p520_chk(p_part)
    DEFINE p_part      LIKE ima_file.ima01
    DEFINE l_cob       RECORD LIKE cob_file.*
    DEFINE l_coa       RECORD LIKE coa_file.*
    DEFINE l_cnt,l_no  LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
    DECLARE chk_curs CURSOR FOR
       SELECT * FROM coa_file,cob_file
        WHERE cob01 = coa03 AND coa01 = p_part
      
    LET l_no = 0
    FOREACH chk_curs INTO l_coa.*,l_cob.*
       IF STATUS THEN 
          CALL cl_err('chk_curs',STATUS,0) EXIT FOREACH
       END IF
       LET l_no = l_no + 1
    END FOREACH
    #無對應之商品編號
    IF l_no = 0 THEN RETURN 1,'' END IF
    RETURN 0,l_cob.cob03
END FUNCTION
 
 REPORT p520_rep(l_chr,no,seq,l_tlf_rowid,l_tlf,l_type) #No.MOD-490398
  DEFINE l_chr  LIKE type_file.chr1         #No.bug-490398        #No.FUN-680069 VARCHAR(1)
  DEFINE no     LIKE tlf_file.tlf026         #No.FUN-680069 VARCHAR(16)    #No.FUN-550036 
  DEFINE seq    LIKE tlf_file.tlf027         #No.FUN-680069 SMALLINT     #單據項次
  DEFINE l_tlf_rowid     LIKE type_file.row_id   #chr18  FUN-A70120
  DEFINE l_type LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)    #資料類型 1.成品 2.材料
  DEFINE l_tlf  RECORD LIKE tlf_file.*
  DEFINE l_cor  RECORD LIKE cor_file.*
  DEFINE l_coc01    LIKE coc_file.coc01,
         l_w_qty    LIKE cod_file.cod09,
         l_ima25    LIKE ima_file.ima25,
         l_ima02    LIKE ima_file.ima02,
         l_ima021   LIKE ima_file.ima021,
         l_cnt      LIKE type_file.num5                          #No.FUN-680069 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  
  ORDER EXTERNAL BY no,seq
  FORMAT
   PAGE HEADER
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[36],g_x[37],g_x[35]
      PRINT g_dash1
 
    #No.MOD-490398  --begin
   #BEFORE GROUP OF no
   #   BEGIN WORK
   #   LET g_success = 'Y'
    #No.MOD-490398  --end   
 
   BEFORE GROUP OF seq
      LET g_msg = ''  
 
   AFTER GROUP OF seq
       #NO.MOD-490398  --begin
      IF l_chr='a' THEN
         INITIALIZE l_cor.* TO NULL
         LET l_cor.cor00 = l_type               #類別 1.成品 2.材料
         LET l_cor.cor01 = no                   #單據編號
         LET l_cor.cor02 = seq                  #項次
         LET l_cor.cor03 = l_tlf.tlf06          #單據日期
         LET l_cor.cor04 = l_tlf.tlf01          #料件編號
         LET l_cor.cor07 = l_tlf.tlf19          #廠商/客戶編號
         IF l_cor.cor00 =  '1' THEN             #客戶簡稱
            SELECT occ02 INTO l_cor.cor08       
              FROM occ_file WHERE occ01 = l_cor.cor07
         ELSE                                   #廠商簡稱
            SELECT pmc03 INTO l_cor.cor08       
              FROM pmc_file WHERE pmc01 = l_cor.cor07
         END IF
         LET l_cor.cor09 = l_tlf.tlf10          #異動數量
         LET l_cor.cor10 = l_tlf.tlf11          #異動單位 
         LET l_cor.cor15 = l_tlf.tlf62          #工單編號 
 
         #海關代號
         SELECT MAX(coc01),MAX(coc10) INTO l_coc01,l_cor.cor06 FROM coc_file
          WHERE coc03 = l_tlf.tlf64 
 
         #商品編號
         SELECT COUNT(*) INTO l_cnt FROM coa_file 
          WHERE coa01 = l_cor.cor04 AND coa05 = l_cor.cor06
         IF l_cnt > 1 THEN                      #對應多個商品編號 
            LET l_cor.cor05 = 'MISC'            #商品編號
            LET l_cor.cor11 = 1                 #轉換率
         ELSE
            SELECT coa03,coa04 INTO l_cor.cor05,l_cor.cor11 FROM coa_file 
             WHERE coa01 = l_cor.cor04 AND coa05 = l_cor.cor06
         END IF
 
         #合同單位
         IF l_cor.cor00 =  '1' THEN             
            SELECT cod06 INTO l_cor.cor13
              FROM cod_file,coc_file
             WHERE coc01 = cod01 AND coc01 = l_coc01 AND cod03 = l_cor.cor05
         ELSE
            SELECT coe06 INTO l_cor.cor13
              FROM coe_file,coc_file
             WHERE coc01 = coe01 AND coc01 = l_coc01 AND coe03 = l_cor.cor05
         END IF
 
         #異動數量對庫存單位的換算
         IF cl_null(l_tlf.tlf60) THEN LET l_tlf.tlf60 = 1 END IF
         LET l_w_qty = l_cor.cor09 * l_tlf.tlf60
 
         #庫存數量對合同單位的換算
         IF cl_null(l_cor.cor11) OR l_cor.cor11 = 0 THEN
            LET g_msg = cl_getmsg('abm-731',g_lang) LET g_success = 'N'
         END IF
     
         #合同數量
         LET l_cor.cor12 = l_w_qty * l_cor.cor11   
         LET l_cor.cor12 = s_digqty(l_cor.cor12,l_cor.cor13) #FUN-BB0083 add         
 
         #異動方式
         LET l_cor.cor14 = '3'                                #其它
         IF l_cor.cor00 =  '1' THEN      #成品        
            IF (l_tlf.tlf02 = 60 OR l_tlf.tlf02 = 65) AND l_tlf.tlf03 = 50 THEN
               LET l_cor.cor14 = '1'                          #完工入庫
            END IF
            IF l_tlf.tlf02 = 25 AND l_tlf.tlf03 = 50 THEN       
               LET l_cor.cor14 = '2'                          #委外收貨入庫
            END IF
         ELSE
            IF l_tlf.tlf02 = 50 AND l_tlf.tlf03 = 60 THEN       
               LET l_cor.cor14 = '1'                          #發料
            END IF
            IF l_tlf.tlf02 = 60 AND l_tlf.tlf03 = 50 THEN       
               LET l_cor.cor14 = '2'                          #退料
            END IF
             #No.MOD-490398  --begin
            IF (l_tlf.tlf02=50 OR l_tlf.tlf02=60) AND l_tlf.tlf03=40 THEN
               LET l_cor.cor14='3'                            #報廢
            END IF
             #No.MOD-490398  --end
         END IF
 
         LET l_cor.corconf='N'
         LET l_cor.coracti='Y'
         LET l_cor.coruser=g_user
         LET l_cor.corgrup=g_grup
         LET l_cor.cordate=g_today
         LET l_cor.corplant = g_plant  #FUN-980002
         LET l_cor.corlegal = g_legal  #FUN-980002
         
         LET l_cor.cororiu = g_user      #No.FUN-980030 10/01/04
         LET l_cor.cororig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO cor_file VALUES(l_cor.*)
         
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err3("ins","cor_file",l_cor.cor01,l_cor.cor02,STATUS,"","ins cor",0) #NO.TQC-660045
             LET g_success='N'
         END IF
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file       
       WHERE ima01=l_cor.cor04
      IF SQLCA.sqlcode THEN 
         LET l_ima02 = ' ' 
         LET l_ima021 = ' ' 
      END IF
         PRINT COLUMN g_c[31],l_cor.cor01,
               COLUMN g_c[32],l_cor.cor02 USING '###&', #FUN-590118
               COLUMN g_c[33],l_cor.cor03,
               COLUMN g_c[34],l_cor.cor04,
               COLUMN g_c[36],l_ima02,
               COLUMN g_c[37],l_ima021,
               COLUMN g_c[35],g_msg
      END IF
      #不更新tlf910,因為acop501會擷取"報廢"的資料.
      #如果此時被更新為"Y",acop501會擷取有誤碼,影響報關資料.
      #故本作業不更新任何tlf910內容
      #IF g_success = 'Y' THEN              
      #   LET g_sql="UPDATE ",g_dbs CLIPPED,
      #             ".dbo.tlf_file SET tlf910='Y' WHERE rowid=?"
      #   PREPARE p520_up_tlf FROM g_sql
      #   EXECUTE p520_up_tlf USING l_tlf_rowid
      #   
      #   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      #      CALL cl_err('upd tlf910',STATUS,0) LET g_success='N'
      #   END IF
      #END IF
 
   ON EVERY ROW
      IF l_chr='b' THEN
         PRINT COLUMN g_c[31],l_tlf.tlf026,
               COLUMN g_c[32],l_tlf.tlf027 USING '####&',
               COLUMN g_c[33],l_tlf.tlf06, 
               COLUMN g_c[34],l_tlf.tlf01,
               COLUMN g_c[35],g_msg
      END IF
 
   #AFTER GROUP OF no
   #   IF g_success = 'Y' THEN
   #      COMMIT WORK
   #   ELSE
   #      ROLLBACK WORK
   #   END IF
    #No.MOD-490398  --end   
END REPORT
