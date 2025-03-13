# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acop500.4gl
# Descriptions...: 出口/報廢/銷退明細擷取作業
# Date & Author..: 00/06/13 By Kammy
# Modify.........: NO.MOD-490217 by yiting 04/09/10 料號欄位放大
# Modify.........: No.MOD-4A0338 by Smapmin 04/10/28  以za_file方式取代PRINT中文字的部份
# Modify.........: No.MOD-490398 by Danny 04/11/29 ima75 -> coa03
# Modify.........: No.MOD-490398 By Carrier #coo10的方式修改為0/1/2/3/4/5/6/7
# Modify.........: No.MOD-530224 By Carrier add coo21/coo22
# Modify.........: No.FUN-550036 05/05/23 By Trisy 單據編號加大
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-570116 06/02/27 By yiting 批次背景執行
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()      
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/10 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980014 09/10/13 By rainy con01 default 空白，全部plant設定相同的擷取條件
# Modify.........: No.MOD-9C0275 09/12/19 By liuxqa 调整SQL语句。
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.TQC-AB0103 10/11/28 By vealxu UPDATE時,g_dbs_tra指向的DB錯誤，建議把g_dbs_tra或是g_plant_new帶進FUNCTION
# Modify.........: No:FUN-BB0083 11/12/23 By xujing 增加數量欄位小數取位 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_coo    RECORD LIKE coo_file.*
DEFINE tm       RECORD 
       conf     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
       END RECORD
DEFINE g_char   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_rec_b  LIKE type_file.num10         #No.FUN-680069 INTEGER 
DEFINE i        LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE g_t1     LIKE apo_file.apo02
DEFINE s_date   LIKE type_file.dat           #No.FUN-680069 DATE
DEFINE g_wc,g_wc2,g_sql  STRING  #No.FUN-580092 HCN        #No.FUN-680069
DEFINE yclose,mclose     LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE g_change_lang     LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)   #No.FUN-570116
DEFINE g_msg             LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(255)    #No.MOD-490398
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT


MAIN
   DEFINE l_flag         LIKE type_file.chr1                   #No.FUN-570116        #No.FUN-680069 VARCHAR(1)
 
   OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
     INITIALIZE g_bgjob_msgfile TO NULL
     LET tm.conf = ARG_VAL(1)
     LET g_bgjob= ARG_VAL(2)
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
    
    DROP TABLE p500_temp
    CREATE TEMP TABLE p500_temp (
              level1 LIKE bmb_file.bmb02,
              bmb02  LIKE bmb_file.bmb02,
              bmb03  LIKE bmb_file.bmb03,
              bmb06  LIKE bmb_file.bmb06,
              bmb08  LIKE bmb_file.bmb08,
              bmb10  LIKE bmb_file.bmb10,
              qty    LIKE bmb_file.bmb06,
              bma01  LIKE bma_file.bma01);
    IF STATUS THEN CALL cl_err('create tmp',STATUS,1) 
       EXIT PROGRAM 
    END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109

WHILE TRUE
   IF g_bgjob="N" THEN
      CALL p500_p1()
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p500_s1()
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
            CLOSE WINDOW p500_w
            EXIT WHILE
         END IF
      ELSE
         CONTINUE WHILE
      END IF
   ELSE
      LET g_success = 'Y'
      BEGIN WORK
      CALL p500_s1()
      IF g_success="Y" THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p500_p1()
 DEFINE l_tlf06     LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(80)
 DEFINE d_tlf06     LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(24)
 DEFINE bdate,edate LIKE type_file.chr20        #No.FUN-680069 VARCHAR(10)
 DEFINE l_date      LIKE type_file.dat          #No.FUN-680069 DATE
 DEFINE l_ac        LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE lc_cmd      LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(500) #No.FUN-570116
 
      OPEN WINDOW p500w WITH FORM "aco/42f/acop500"
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
  LET g_bgjob = "N" #No.FUN-570116
 
 WHILE TRUE
      INPUT BY NAME tm.conf,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570116

         ON ACTION locale
          LET g_change_lang = TRUE        #->No.FUN-570116
          EXIT INPUT                                #No.FUN-570116
 
         AFTER FIELD conf
            IF cl_null(tm.conf) OR tm.conf NOT MATCHES '[YN]' THEN
               NEXT FIELD conf
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
     
         BEFORE INPUT
             CALL cl_set_comp_entry("g_bgjob",FALSE)  #NO.FUN-570116
             CALL cl_set_comp_entry("g_bgjob",TRUE)   #NO.FUN-570116
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p500_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
            EXIT PROGRAM
      END IF

     IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "abmp603"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('acop500','9031',1)
        ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",tm.conf CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop500',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
    #No.FUN-570116--end---
 
#      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#      IF tm.conf = 'Y' THEN CALL p500_s1() END IF
   EXIT WHILE
    #No.FUN-570116--end---
 END WHILE
END FUNCTION
 
FUNCTION p500_s1()
  DEFINE l_name   LIKE type_file.chr20       #No.FUN-680069 VARCHAR(20)
  DEFINE l_tlf    RECORD LIKE tlf_file.*
  DEFINE l_dbs    LIKE type_file.chr21       #No.FUN-680069 LIKE azp_file.azp03 
  DEFINE no       LIKE tlf_file.tlf026       #No.FUN-680069 VARCHAR(16) #No.FUN-550036 
  DEFINE seq      LIKE tlf_file.tlf027       #No.FUN-680069 SMALLINT
  DEFINE l_tlf_rowid   LIKE type_file.row_id #chr18 FUN-A70120
  
  DEFINE l_ima08  LIKE ima_file.ima08        #No.FUN-680069 VARCHAR(1)
  DEFINE l_y,l_m  LIKE type_file.num5        #No.FUN-680069 SMALLINT
  
  DEFINE l_oga08  LIKE oga_file.oga08
  DEFINE l_oha08  LIKE oha_file.oha08
  DEFINE l_flag   LIKE type_file.num5        #No.FUN-680069 SMALLINT
  DEFINE l_type   LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)    #半成品保稅料
 
  DEFINE l_cnz01  LIKE cnz_file.cnz01
  DEFINE l_cnz04  LIKE cnz_file.cnz04
  DEFINE l_za05   LIKE za_file.za05          #No.MOD-490398
  #CALL cl_wait()                 #No.FUN-570116
 
  LET l_y=yclose
  LET l_m=mclose
  LET l_m=l_m+1
  IF l_m > 12 THEN
     LET l_m=1
     LET l_y=l_y+1
  END IF
  LET s_date=MDY(l_m,1,l_y)-1
 
  #No.MOD-490398
 CALL cl_outnam('acop500') RETURNING l_name
 START REPORT p500_rep TO l_name
 
  #No.MOD-490398
 
# BEGIN WORK             #NO.FUN-570116
# LET g_success='Y'      #NO.FUN-570116
 #030901 modify
 DECLARE cnz_curs CURSOR FOR
   #FUN-980014 --begin
    #SELECT UNIQUE cnz01 FROM cnz_file WHERE cnz02 = '1'
    # ORDER BY cnz01
    SELECT UNIQUE azp01 FROM azp_file 
     WHERE azp01 IN( SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user ) 
     ORDER BY azp01
   #FUN-980014 --end
 IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
 FOREACH cnz_curs INTO l_cnz01 
    IF STATUS THEN 
       CALL cl_err('foreach cnz',STATUS,1) LET g_success='N' EXIT FOREACH 
    END IF
    IF cl_null(l_cnz01) THEN CONTINUE FOREACH END IF 
    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_cnz01
 
    #Begin FUN-980092 add------------
    LET g_plant_new = l_cnz01   
    CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
 
    LET g_sql= "SELECT tlf_file.rowid,tlf_file.*,oga08,oha08 ",
              #FUN-A50102--mod--str--
              #"  FROM ",s_dbstring(g_dbs_tra CLIPPED),"tlf_file LEFT OUTER JOIN ",                 #MOD-9C0275 mod                                                         
              #          s_dbstring(g_dbs_tra CLIPPED),"oga_file ON oga01=tlf026 LEFT OUTER JOIN ", #MOD-9C0275 mod                                                                          
              #          s_dbstring(g_dbs_tra CLIPPED),"oha_file ON oha01=tlf026",                  #MOD-9C0275 mod 
               "  FROM ",cl_get_target_table(g_plant_new,'tlf_file'),
               "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'oga_file'),
               "       ON oga01=tlf026 ",
               "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'oha_file'),
               "       ON oha01=tlf026 ",
              #FUN-A50102--mod--end
               " WHERE (tlf910 IS NULL OR tlf910='')",       #合同是否已擷取
               "   AND ((tlf02=50 AND (tlf03=724 OR tlf03 = 40))", #出貨/報廢單
               "    OR (tlf02=731 AND tlf03=50 ))"                #銷退
 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    DECLARE cnz_b_curs CURSOR FOR
       SELECT cnz04 FROM cnz_file WHERE cnz02 = '1'  #AND cnz01 = l_cnz01  #FUN-980014 remark cnz01條件
        ORDER BY cnz04  
    IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF

    FOREACH cnz_b_curs INTO l_cnz04
       IF STATUS THEN 
          CALL cl_err('foreach cnz',STATUS,1) LET g_success='N' EXIT FOREACH 
       END IF
       LET g_sql = g_sql CLIPPED," AND ",l_cnz04 CLIPPED
    END FOREACH

    LET g_sql = g_sql CLIPPED,"  ORDER BY tlf026,tlf027 "
    CALL cl_parse_qry_sql(g_sql,l_cnz01) RETURNING g_sql     #FUN-980014
    PREPARE p500_p1 FROM g_sql
    IF STATUS THEN
       CALL cl_err('p500_p1',STATUS,0) LET g_success='N' EXIT FOREACH 
    END IF
    DECLARE p500_s1_c CURSOR FOR p500_p1
  
    FOREACH p500_s1_c INTO l_tlf_rowid,l_tlf.*,l_oga08,l_oha08
      IF STATUS THEN 
         Call cl_err('foreach',STATUS,0)
         LET g_success='N' EXIT FOREACH
      END IF
 
       #No.MOD-490398
      #先檢查料號有無建立對應之海關料號
      LET l_type = 'N'
      CALL p500_chk(l_tlf.tlf01) RETURNING l_flag
      IF l_flag THEN
         IF l_tlf.tlf03 = 724 THEN CONTINUE FOREACH END IF
         SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01 = l_tlf.tlf01
         IF l_ima08 NOT MATCHES '[MS]' THEN CONTINUE FOREACH END IF
         #半成品報廢無對應海關料號, 需另外判斷是否有用到保稅料件
         CALL p500_check(l_tlf.tlf01) RETURNING l_flag
         IF l_flag THEN CONTINUE FOREACH END IF
         LET l_type = 'Y'
      END IF
  
      LET no=l_tlf.tlf026 LET seq=l_tlf.tlf027
       #No.MOD-490398 end
 
    # OUTPUT TO REPORT p500_rep(no,seq,l_tlf_rowid,l_tlf.*,l_oga08,l_oha08,l_type)                #TQC-AB0103
      OUTPUT TO REPORT p500_rep(no,seq,l_tlf_rowid,l_tlf.*,l_oga08,l_oha08,l_type,g_plant_new)    #TQC-AB0103
    END FOREACH
 END FOREACH
 
  FINISH REPORT p500_rep
  IF g_bgjob = 'N' THEN
     CALL cl_prt(l_name,' ','1',g_len)
  END IF
 
END FUNCTION


 
FUNCTION p500_chk(p_part)
    DEFINE p_part      LIKE ima_file.ima01
    DEFINE l_coa       RECORD LIKE coa_file.*
    DEFINE l_cob       RECORD LIKE cob_file.*
    DEFINE l_cnt,l_no  LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
    DECLARE chk_curs CURSOR FOR
       SELECT * FROM coa_file,cob_file
        WHERE cob01 = coa03 AND coa01 = p_part
      
    LET l_no = 0
    FOREACH chk_curs INTO l_coa.*,l_cob.*
       IF STATUS THEN 
          CALL cl_err('chk_curs',STATUS,0) EXIT FOREACH
       END IF
        #No.MOD-490398  --begin
       #IF l_cob.cob03 != '1' THEN RETURN 1 END IF       #非成品料號
       IF l_cob.cob03 != '1' THEN CONTINUE FOREACH END IF       #非成品料號
       SELECT COUNT(*) INTO l_cnt FROM com_file 
        WHERE com01  = l_coa.coa03 AND com03 = l_coa.coa05
          AND comacti !='N'  
       #IF l_cnt = 0 THEN RETURN 1 END IF
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF
       LET l_no = l_no + 1
        #No.MOD-490398  --end
    END FOREACH
    #無對應之商品編號
    IF l_no = 0 THEN RETURN 1 END IF
    RETURN 0
END FUNCTION
 #No.MOD-490398 end 
 
REPORT p500_rep(no,seq,l_tlf_rowid,l_tlf,l_oga08,l_oha08,l_type,l_plant)       #TQC-AB0103 add l_plant 
  DEFINE no         LIKE tlf_file.tlf026         #No.FUN-680069 VARCHAR(16)    #No.FUN-550036
  DEFINE seq        LIKE tlf_file.tlf027         #No.FUN-680069 SMALLINT    #單據項次
  DEFINE l_tlf_rowid  LIKE type_file.row_id      #chr18   FUN-A70120
  DEFINE l_plant    LIKE azp_file.azp01          #TQC-AB0103 
  DEFINE l_tlf RECORD LIKE tlf_file.*
  DEFINE l_oga08    LIKE oga_file.oga08
  DEFINE l_oha08    LIKE oha_file.oha08
  DEFINE l_ima910   LIKE ima_file.ima910        #FUN-550100
  DEFINE l_type     LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
  DEFINE l_cnt      LIKE type_file.num5         #No.FUN-680069 SMALLINT
  DEFINE l_coc01    LIKE coc_file.coc01,
         l_sum      LIKE cod_file.cod05,
         l_qty      LIKE cod_file.cod09,
         l_tot      LIKE coo_file.coo16,
         l_w_qty    LIKE cod_file.cod09,
         l_ima25    LIKE ima_file.ima25,
         l_ima02    LIKE ima_file.ima02,
         l_ima021   LIKE ima_file.ima021,
         l_fac      LIKE coa_file.coa04,
         l_unit_fac LIKE coa_file.coa04,
         g_sw       LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  ORDER EXTERNAL BY l_plant,l_tlf.tlf026,l_tlf.tlf027   #TQC-AB0103 add l_plant
  FORMAT
    #No.MOD-490398
   PAGE HEADER
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[36],g_x[37],g_x[35]
      PRINT g_dash1
 
 # No.MOD-490398  --BEGIN
#   BEFORE GROUP OF l_tlf.tlf026
#      BEGIN WORK
#      LET g_success = 'Y'
 # No.MOD-490398  --end  
 
   BEFORE GROUP OF l_tlf.tlf027
      LET g_msg = ''  
    #No.MOD-490398 end
 
   AFTER GROUP OF l_tlf.tlf027
      INITIALIZE g_coo.* TO NULL
      LET g_coo.coo01 = no                   #單據編號
      LET g_coo.coo02 = seq                  #項次
      LET g_coo.coo03 =l_tlf.tlf06           #單據日期
      LET g_coo.coo04 =l_tlf.tlf01           #料件編號
      LET g_coo.coo05 =l_tlf.tlf19           #客戶編號
      SELECT occ02 INTO g_coo.coo06          #客戶簡稱
       FROM occ_file WHERE occ01=g_coo.coo05
      
      CASE l_oga08
        WHEN '1' LET g_coo.coo10 = '0'                  #內銷出貨
        WHEN '2' LET g_coo.coo10 = '1'                  #直接出口
        WHEN '3' LET g_coo.coo10 = '2'                  #轉廠出口
        OTHERWISE 
           IF cl_null(l_oha08) THEN
              SELECT COUNT(*) INTO l_cnt FROM com_file 
               WHERE com01 = g_coo.coo11 
              IF l_cnt > 0 THEN 
                 LET g_coo.coo10 = '3'                   #成品報廢
              ELSE
                  #No.MOD-490398  --begin
                 IF l_type = 'Y' 
                    THEN LET g_coo.coo10 = '4'           #半成品報廢
                         LET g_coo.coo11 = ''
                 #  ELSE LET g_coo.coo10 = '5'           #原料報廢
                 END IF 
                  #No.MOD-490398  --end
              END IF 
           ELSE
               #No.MOD-490398
              CASE l_oha08
                WHEN '1' LET g_coo.coo10 = '5'                  #內銷退貨
                WHEN '2' LET g_coo.coo10 = '6'                  #國外退貨
                WHEN '3' LET g_coo.coo10 = '7'                  #轉廠退貨
              END CASE
               #No.MOD-490398 end
           END IF
      END CASE
 
      LET g_coo.coo13 = l_tlf.tlf13          #異動命令 
      LET g_coo.coo14 = l_tlf.tlf10          #異動數量
      LET g_coo.coo15 = l_tlf.tlf11          #異動單位 
      LET g_coo.coo18 = l_tlf.tlf64          #手冊編號
 
       #No.MOD-490398
      #海關代號
      SELECT MAX(coc10) INTO g_coo.coo12 FROM coc_file
       WHERE coc03 = g_coo.coo18
 
      #商品編號
      SELECT COUNT(*) INTO l_cnt FROM coa_file 
       WHERE coa01 = g_coo.coo04 AND coa05 = g_coo.coo12
      IF l_cnt > 1 THEN                      #對應多個商品編號 
         LET g_coo.coo11 = 'MISC'
         LET l_unit_fac = 1
      ELSE
         SELECT coa03,coa04 INTO g_coo.coo11,l_unit_fac FROM coa_file 
          WHERE coa01=g_coo.coo04 AND coa05 = g_coo.coo12
      END IF
       #No.MOD-490398 end
      
      #合同編號 
      SELECT coc01,coc04 INTO l_coc01,g_coo.coo09 FROM coc_file
       WHERE coc03 = g_coo.coo18
      
       #No.MOD-490398  --begin
      IF g_coo.coo10 MATCHES '[0123567]' THEN           
         #下面的SQL有可能找不到值..因為可能SELECT出多筆
         SELECT cod06,cod041 INTO g_coo.coo17,g_coo.coo19
           FROM cod_file,coc_file
          WHERE coc01 = cod01 AND coc01 = l_coc01
            AND cod03 = g_coo.coo11 
       #No.MOD-490398  --end
         #異動數量對庫存單位的換算
         IF cl_null(l_tlf.tlf60) THEN LET l_tlf.tlf60 = 1 END IF
         LET l_w_qty = g_coo.coo14 * l_tlf.tlf60
 
         #庫存數量對合同單位的換算
          #No.MOD-490398
         IF cl_null(l_unit_fac) OR l_unit_fac = 0 THEN
#            LET g_msg = cl_getmsg('abm-731',g_lang) LET g_success = 'N'
         END IF
          #No.MOD-490398 end
         LET g_coo.coo16 = l_w_qty * l_unit_fac 
         LET g_coo.coo16 = s_digqty(g_coo.coo16,g_coo.coo17)   #FUN-BB0083 add
      END IF
      
      IF g_coo.coo19 IS NULL THEN LET g_coo.coo19 = ' ' END IF
 
      LET g_coo.coo20  ='N'
      LET g_coo.cooconf='N'
      LET g_coo.cooacti='Y'
      LET g_coo.coouser=g_user
      LET g_coo.coogrup=g_grup
      LET g_coo.coodate=g_today
       LET g_coo.coo21 = l_tlf.tlf60*l_unit_fac   #MOD-530224
       LET g_coo.coo22 = 'N' #MOD-530224
      LET g_coo.cooplant = g_plant   #FUN-980002
      LET g_coo.coolegal = g_legal   #FUN-980002
      
      LET g_coo.coooriu = g_user      #No.FUN-980030 10/01/04
      LET g_coo.cooorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO coo_file VALUES(g_coo.*)
      
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","coo_file",g_coo.coo01,g_coo.coo02,STATUS,"","ins coo",1) #TQC-660045
         LET g_success='N'
      END IF
       IF g_coo.coo10 MATCHES '[0123567]' THEN                  #No.MOD-490398
          CALL p500_gen(g_coo.coo11,g_coo.coo19,g_coo.coo12)    #No.MOD-490398
      END IF
      IF g_coo.coo10 = '4' THEN 
        #FUN-550100
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr.ima01
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        #--
         CALL p500_gen2(g_coo.coo04,l_ima910)
      END IF
 
       #No.MOD-490398
      IF g_coo.coo11 = 'MISC' THEN LET g_msg = g_msg CLIPPED,' ',g_x[9] END IF
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file       
       WHERE ima01=g_coo.coo04
      IF SQLCA.sqlcode THEN 
         LET l_ima02 = ' ' 
         LET l_ima021 = ' ' 
      END IF
      PRINT COLUMN g_c[31],g_coo.coo01,
            COLUMN g_c[32],g_coo.coo02 USING '###&', #FUN-590118
            COLUMN g_c[33],g_coo.coo03,
            COLUMN g_c[34],g_coo.coo04,
            COLUMN g_c[34],g_coo.coo04,
            COLUMN g_c[36],l_ima02,
            COLUMN g_c[37],l_ima021,
            COLUMN g_c[35],g_msg 
       #No.MOD-490398 end
 
       IF g_success = 'Y' THEN            #No.MOD-490398
       # LET g_sql="UPDATE ",s_dbstring(g_dbs_tra CLIPPED),  #FUN-980092 add          #TQC-AB0103                                                                  
       #           "tlf_file SET tlf910='Y' WHERE rowid=?"                            #TQC-AB0103
         LET g_sql="UPDATE ",cl_get_target_table(l_plant,'tlf_file'),                 #TQC-AB0103
                   "   SET tlf910='Y' WHERE rowid=?"                                  #TQC-AB0103 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql                         #TQC-AB0103 
         PREPARE p500_up_tlf FROM g_sql
         EXECUTE p500_up_tlf USING l_tlf_rowid
         
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd tlf910',STATUS,1) 
            LET g_success='N'
         END IF
      END IF
END REPORT


 
 FUNCTION p500_gen(p_key,p_key3,p_key4)           #No.MOD-490398
 DEFINE l_col      RECORD LIKE col_file.*,
        l_con      RECORD LIKE con_file.*,
        p_key      LIKE coo_file.coo11,
        p_key3     LIKE coo_file.coo19,
        p_key4     LIKE coo_file.coo12           #No.MOD-490398
 
   IF cl_null(p_key) THEN RETURN END IF
   
   IF p_key3 IS NULL THEN LET p_key3 = ' ' END IF
 
   DECLARE con_curs CURSOR FOR
    SELECT * FROM con_file
      WHERE con01 = p_key AND con013 = p_key3 AND con08 = p_key4   #No.MOD-490398
     ORDER BY con02
   
   INITIALIZE l_col.* TO NULL
   LET l_col.col01 = g_coo.coo01
   LET l_col.col02 = g_coo.coo02
   LET l_col.col03 = 0
   FOREACH con_curs INTO l_con.*
      IF STATUS THEN 
         CALL cl_err('foreach con',STATUS,1) LET g_success='N' EXIT FOREACH 
      END IF
      LET l_col.col03 = l_col.col03 + 1
      LET l_col.col04 = l_con.con03
      LET l_col.col06 = l_con.con04
      LET l_col.col07 = l_con.con05
      LET l_col.col08 = l_con.con06
      LET l_col.col09 = g_coo.coo16*(l_con.con05/(1-(l_con.con06/100)))  #No.MOD-490398
      LET l_col.col09 = s_digqty(l_col.col09,l_col.col06) #FUN-BB0083 add
      LET l_col.col10 = l_col.col09
      LET l_col.col10 = s_digqty(l_col.col10,l_col.col06) #FUN-BB0083 add
      LET l_col.col11 = l_col.col07
      LET l_col.col12 = l_col.col08
      LET l_col.colplant = g_plant   #FUN-980002
      LET l_col.collegal = g_legal   #FUN-980002
 
      INSERT INTO col_file VALUES(l_col.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","col_file",l_col.col01,l_col.col02,STATUS,"","ins col",1) #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
   END FOREACH 
END FUNCTION
 
FUNCTION p500_gen2(p_key,p_key2)
   DEFINE p_key    LIKE coo_file.coo04
   DEFINE p_key2   LIKE ima_file.ima910           #FUN-550100
   DEFINE sr       RECORD                         #每階存放資料
                   level1 LIKE type_file.num5,    #No.FUN-680069 SMALLINT
                   bmb02  LIKE bmb_file.bmb02,    #項次
                   bmb03  LIKE bmb_file.bmb03,    #元件料號
                   bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
                   bmb08  LIKE bmb_file.bmb08,    #損耗率
                   bmb10  LIKE bmb_file.bmb10,    #發料單位
                   qty    LIKE coa_file.coa04,    #No.FUN-680069 DEC(13,5)
                   bma01  LIKE bma_file.bma01,    #NO.MOD-490217
                   ima25  LIKE ima_file.ima25,
                   coa03  LIKE coa_file.coa03,    #No.MOD-490398
                   coa04  LIKE coa_file.coa04,    #No.MOD-490398
                   cob04  LIKE cob_file.cob04
                   END RECORD
   DEFINE l_col    RECORD LIKE col_file.*
   DEFINE l_fac    LIKE bmb_file.bmb06
   DEFINE l_msg    LIKE type_file.chr1000         #No.FUN-680069 VARCHAR(255)   #No.MOD-490398
 
   DELETE FROM p500_temp
   CALL p500_bom(0,p_key,p_key2,g_coo.coo14) 
 
    #No.MOD-490398
   DECLARE bom_curs CURSOR FOR 
    SELECT p500_temp.*,ima25,'',0,''
      FROM p500_temp,ima_file
     WHERE ima01 = bmb03
    #No.MOD-490398  end 
 
   INITIALIZE l_col.* TO NULL
   LET l_col.col01 = g_coo.coo01
   LET l_col.col02 = g_coo.coo02
   LET l_col.col03 = 0
   FOREACH bom_curs INTO sr.*
      IF STATUS THEN 
         CALL cl_err('bom_curs',STATUS,1) LET g_success='N' EXIT FOREACH 
      END IF
       #No.MOD-490398
      INITIALIZE sr.coa03 TO NULL
      INITIALIZE sr.coa04 TO NULL
      SELECT coa03,coa04 INTO sr.coa03,sr.coa04 FROM coa_file
       WHERE coa01 = sr.bmb03
         AND coa05 = g_coo.coo12
      IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN    #出現一個ima01對應多個coa03
         CALL q_coa(FALSE,FALSE,sr.coa03,sr.coa04,sr.bmb03,g_coo.coo12)
              RETURNING sr.coa03,sr.coa04
         IF INT_FLAG THEN LET INT_FLAG=0 CONTINUE FOREACH END IF
      END IF
      SELECT cob04 INTO sr.cob04 FROM cob_file WHERE cob01 = sr.coa03 
 
      #生產單位對庫存單位的換算
      CALL s_umfchk(sr.bmb03,sr.bmb10,sr.ima25) RETURNING g_i,l_fac
       IF g_i THEN            #No.MOD-490398
         CALL cl_getmsg('asf-816',g_lang) RETURNING l_msg 
         LET g_msg = g_msg CLIPPED,' ',l_msg
         LET g_success='N' EXIT FOREACH 
       END IF                 #No.MOD-490398 end
      LET sr.qty = sr.qty * l_fac * sr.coa04
       #No.MOD-490398  end
 
      LET l_col.col03 = l_col.col03 + 1
      LET l_col.col04 = sr.coa03  
      LET l_col.col06 = sr.cob04
      LET l_col.col07 = sr.bmb06
      LET l_col.col08 = 0
      LET l_col.col09 = sr.qty * l_col.col07
      LET l_col.col09 = s_digqty(l_col.col09,l_col.col06) #FUN-BB0083 add
      LET l_col.col10 = l_col.col09
      LET l_col.col10 = s_digqty(l_col.col10,l_col.col06) #FUN-BB0083 add
      LET l_col.col11 = l_col.col07
      LET l_col.col12 = l_col.col08
      LET l_col.colplant = g_plant   #FUN-980002
      LET l_col.collegal = g_legal   #FUN-980002
 
      INSERT INTO col_file VALUES(l_col.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","col_file",l_col.col01,l_col.col02,STATUS,"","ins col #2",1) #TQC-660045        
         LET g_success='N' EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION p500_check(p_part)
   DEFINE p_part   LIKE bma_file.bma01
   DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680069 SMALLINT
   DEFINE l_ima910 LIKE ima_file.ima910         #FUN-550100
 
   #FUN-550100
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part     
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   DELETE FROM p500_temp
   CALL p500_bom(0,p_part,l_ima910,1)   #FUN-550100
   SELECT COUNT(*) INTO l_cnt FROM p500_temp
   IF l_cnt > 0 THEN RETURN 0 ELSE RETURN 1 END IF
END FUNCTION
 
 
FUNCTION p500_bom(p_level,p_key,p_key2,p_total)
   DEFINE p_level	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          p_key		LIKE bma_file.bma01,         #主件料件編號
          p_key2	LIKE ima_file.ima910,        #FUN-550100
          p_total       LIKE bmb_file.bmb06,         #FUN-560227
          l_ac,i	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          arrno		LIKE type_file.num5,         #No.FUN-680069 SMALLINT	#BUFFER SIZE (可存筆數)
          l_chr		LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          sr DYNAMIC ARRAY OF RECORD                 #每階存放資料
              level1    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
              bmb02     LIKE bmb_file.bmb02,         #項次
              bmb03     LIKE bmb_file.bmb03,         #元件料號
              bmb06     LIKE bmb_file.bmb06,         #QPA/BASE
              bmb08     LIKE bmb_file.bmb08,         #損耗率
              bmb10     LIKE bmb_file.bmb10,         #發料單位
              qty       LIKE bmb_file.bmb06,         #No.FUN-680069 DEC(13,5),
              bma01     LIKE bma_file.bma01          #NO.MOD-490217
          END RECORD,
          l_cmd		LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(1000)
      DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN 
       CALL cl_err('','mfg2733',1) LET g_success='N' RETURN 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600	
    LET l_cmd= "SELECT 0,bmb02,bmb03,(bmb06/bmb07),bmb08,bmb10,0,bma01",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb03 = bma01",
               " WHERE bmb01='", p_key,"' ",
               "   AND bmb29 ='",p_key2,"' ", #FUN-550100
               "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               "   AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
               " ORDER BY bmb02"
    PREPARE p500_precur FROM l_cmd
    IF SQLCA.sqlcode THEN 
       CALL cl_err('P1:',STATUS,1) LET g_success='N' RETURN 
    END IF
    DECLARE p500_cur CURSOR FOR p500_precur 
    LET l_ac = 1
    FOREACH p500_cur INTO sr[l_ac].*        	 #先將BOM單身存入BUFFER
        #FUN-8B0035--BEGIN--
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0035--END--  
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	 #讀BUFFER傳給REPORT
        LET sr[i].level1 = p_level
        LET sr[i].qty =p_total*sr[i].bmb06*(1+sr[i].bmb08/100)
        IF sr[i].bma01 IS NOT NULL THEN          #若為主件
          #CALL p500_bom(p_level,sr[i].bmb03,' ',sr[i].qty)        #FUN-8B0035
           CALL p500_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].qty)#FUN-8B0035
        ELSE 
            #No.MOD-490398
           SELECT UNIQUE ima01 FROM ima_file,cob_file,coa_file
            WHERE ima01 = sr[i].bmb03                                           
              AND coa01 = ima01                               
              AND coa05 = g_coo.coo12                         
               AND cob01 = coa03         #No.MOD-490398 end                         
           IF STATUS = 0 THEN 
              INSERT INTO p500_temp VALUES (sr[i].*)
              IF STATUS THEN 
                 CALL cl_err3("ins","p500_temp","","",STATUS,"","ins tmp",1) #TQC-660045
                 LET g_success='N' EXIT FOR 
              END IF
           END IF
        END IF
    END FOR
END FUNCTION
