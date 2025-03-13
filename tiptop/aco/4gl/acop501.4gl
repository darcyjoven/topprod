# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acop501.4gl
# Descriptions...: 合同進口明細擷取作業
# Date & Author..: 00/06/16 By Kammy
# Modify.........: 00/08/11 By Carol 改多工廠方式輸入
# Modify         : No.8963 04/07/07 By ching 判斷#是否為材料料號 的SQL 有問題
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.MOD-490398 04/11/23 By Danny  ima75 -> coa03
# Modify.........: No.MOD-490398 05/01/24 By Carrier cop10->1/2/3/4/5/6/7
# Modify.........: No.MOD-530224 05/04/01 By Carrier add cop21,cop22
# Modify.........: No.FUN-550036 05/05/23 By Trisy 單據編號加大
# Modify.........: No.FUN-570116 06/02/27 By yiting 批次背景執行
# MOdify.........: No.TQC-660045 06/06/13 By hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.MOD-880014 08/08/05 By Pengu 收貨單中有輸報單編號及報單日期並沒有擷取過來
# Modify.........: No.MOD-8B0076 08/11/14 By Pengu l_flag變數重複定義
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()      
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/10 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980014 09/10/13 By rainy con01 default 空白，全部plant設定相同的擷取條件
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.TQC-AB0103 10/11/28 By vealxu UPDATE時,g_dbs_tra指向的DB錯誤，建議把g_dbs_tra或是g_plant_new帶進FUNCTION
# Modify.........: No:FUN-BB0083 11/12/22 By xujing 增加數量欄位小數取位 cop_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cop    RECORD LIKE cop_file.*
DEFINE tm       RECORD
       conf     LIKE type_file.chr1              #No.FUN-680069 VARCHAR(01)
                END RECORD
DEFINE g_t1     LIKE oay_file.oayslip            #No.FUN-550036         #No.FUN-680069 VARCHAR(5)
DEFINE s_date   LIKE type_file.dat               #No.FUN-680069 DATE 
DEFINE g_wc,g_wc2,g_sql STRING                   #No:8500    #No.FUN-580092 HCN        #No.FUN-680069
DEFINE yclose,mclose    LIKE type_file.num5      #No.FUN-680069 SMALLINT  
DEFINE g_cnt            LIKE type_file.num5      #No.FUN-680069 SMALLINT 
DEFINE g_msg            LIKE type_file.chr1000   #No.FUN-680069 VARCHAR(255)  #No.MOD-490398
DEFINE g_i              LIKE type_file.num5      #No.MOD-490398        #No.FUN-680069 SMALLINT
DEFINE g_change_lang    LIKE type_file.chr1      #No.FUN-680069 VARCHAR(1)      #No.FUN-570116
 
MAIN
   DEFINE g_flag        LIKE type_file.chr1      
 
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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 WHILE TRUE
   IF g_bgjob="N" THEN
       CALL p501_p1()
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          LET g_success='Y'
          BEGIN WORK
          CALL p501_s1()
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING g_flag     #No.MOD-8B0076 modify
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING g_flag     #No.MOD-8B0076 modify
          END IF
          IF g_flag THEN                          #No.MOD-8B0076 modify
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p500_w
             EXIT WHILE
          END IF
      ELSE
         CONTINUE WHILE
      END IF
    ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p501_s1()
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
 
FUNCTION p501_p1()
 DEFINE l_tlf06     LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(80)
 DEFINE d_tlf06     LIKE aab_file.aab01         #No.FUN-680069 VARCHAR(24)
 DEFINE bdate,edate LIKE type_file.chr20        #No.FUN-680069 VARCHAR(10)
 DEFINE l_date      LIKE type_file.dat          #No.FUN-680069 DATE 
 DEFINE l_ac,i      LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE lc_cmd      LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(500) #No.FUN-570116
 
      OPEN WINDOW p501_w WITH FORM "aco/42f/acop501"
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
     #INPUT BY NAME tm.conf WITHOUT DEFAULTS 
     INPUT BY NAME tm.conf,g_bgjob WITHOUT DEFAULTS 
 
 
        AFTER FIELD conf 
           IF cl_null(tm.conf) OR tm.conf NOT MATCHES '[YN]' THEN
              NEXT FIELD conf
           END IF
 
        ON ACTION locale
#          CALL cl_dynamic_locale()                 #no.FUN-570116 MARK
          LET g_change_lang = TRUE                  #No.FUN-570116
#          CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
          EXIT INPUT                                #No.FUN-570116
 
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
             CALL cl_qbe_init()
             CALL cl_set_comp_entry("g_bgjob",TRUE)  #NO.FUN-570116 
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
        CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
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
          CALL cl_err('acop501','9031',1)
        ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",tm.conf CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop501',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p501_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
 
  EXIT WHILE
 END WHILE
END FUNCTION
 
FUNCTION p501_s1()
  DEFINE l_name   LIKE type_file.chr20        #No.FUN-680069 VARCHAR(20)
  DEFINE l_tlf    RECORD LIKE tlf_file.*
  DEFINE no       LIKE tlf_file.tlf026        #No.FUN-680069 VARCHAR(16)    #單據號碼 
  DEFINE seq      LIKE tlf_file.tlf027        #No.FUN-680069 SMALLINT
  DEFINE l_tlf_rowid       LIKE type_file.row_id  #chr18 FUN-A70120
  DEFINE l_flag   LIKE type_file.num5         #No.FUN-680069 SMALLINT    #No.MOD-490398
  DEFINE l_dbs    LIKE type_file.chr21        #No.FUN-680069 LIKE azp_file.azp03 
  DEFINE l_ima08  LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
  DEFINE l_y,l_m  LIKE type_file.num5         #No.FUN-680069 SMALLINT
  DEFINE l_cnz01  LIKE cnz_file.cnz01
  DEFINE l_cnz04  LIKE cnz_file.cnz04
  DEFINE l_za05   LIKE za_file.za05            #No.MOD-490398
 
  LET l_y=yclose
  LET l_m=mclose
  LET l_m=l_m+1
  IF l_m > 12 THEN
     LET l_m=1
     LET l_y=l_y+1
  END IF
  LET s_date=MDY(l_m,1,l_y)-1
 
     CALL cl_outnam('acop501') RETURNING l_name
     START REPORT p501_rep TO l_name
 
 DECLARE cnz_curs CURSOR FOR
    SELECT UNIQUE azp01 FROM azp_file 
     WHERE azp01 IN( SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user ) 
     ORDER BY azp01
 IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF

 FOREACH cnz_curs INTO l_cnz01 
    IF STATUS THEN 
       CALL cl_err('foreach cnz',STATUS,1) LET g_success='N' EXIT FOREACH 
    END IF
    IF cl_null(l_cnz01)  THEN CONTINUE FOREACH END IF 
    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_cnz01
 
     LET g_plant_new = l_cnz01
     CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
 
    LET g_sql= "SELECT rowid,tlf_file.*",
              #"  FROM ",s_dbstring(g_dbs_tra CLIPPED),"tlf_file",  #FUN-980092 ADD
               "  FROM ",cl_get_target_table(g_plant_new,'tlf_file'),  #FUN-A50102
               " WHERE (tlf910 IS NULL OR tlf910='')",        #合同是否已擷取   
               "   AND (((tlf02=10 OR tlf02=11 OR tlf02=14 OR tlf02=16)",
               "   AND tlf03=20) ",                           #是否為收貨單
               "    OR  ((tlf02=50 OR tlf02=60) AND tlf03=40) ", #報廢 
               "    OR  (tlf02 = 50 AND tlf03 = 31) ",        #倉退
               "    OR  (tlf02 = 20 AND tlf03 = 31))"         #驗退
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    DECLARE cnz_b_curs CURSOR FOR
       SELECT cnz04 FROM cnz_file WHERE cnz02 = '2'  ##AND cnz01 = l_cnz01  #FUN-980014 remark cnz01條件
        ORDER BY cnz04
    IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
    FOREACH cnz_b_curs INTO l_cnz04
       IF STATUS THEN 
          CALL cl_err('foreach cnz',STATUS,1) LET g_success='N' EXIT FOREACH 
       END IF
       LET g_sql = g_sql CLIPPED," AND ",l_cnz04 CLIPPED
    END FOREACH
    LET g_sql = g_sql CLIPPED,"  ORDER BY tlf036,tlf037 "
    CALL cl_parse_qry_sql(g_sql,l_cnz01) RETURNING g_sql     #FUN-980014
    PREPARE p501_p1 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('p501_p1',STATUS,1) LET g_success = 'N' EXIT FOREACH
    END IF
    DECLARE p501_s1_c CURSOR FOR p501_p1
 
    FOREACH p501_s1_c INTO l_tlf_rowid,l_tlf.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF
    
      CALL p501_chk(l_tlf.tlf01) RETURNING l_flag
      IF l_flag THEN CONTINUE FOREACH END IF
 
      IF l_tlf.tlf02 = 50 THEN 
         LET no=l_tlf.tlf026 LET seq=l_tlf.tlf027
      ELSE
         LET no=l_tlf.tlf036 LET seq=l_tlf.tlf037
      END IF
      OUTPUT TO REPORT p501_rep(no,seq,l_tlf_rowid,l_tlf.*,g_plant_new)     #TQC-AB0103 add g_plant_new
    END FOREACH
 END FOREACH 
 
  FINISH REPORT p501_rep
  CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
FUNCTION p501_chk(p_part)
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
        #No.MOD-490398  --begin
       IF l_cob.cob03 != '2' THEN CONTINUE FOREACH END IF       #非材料料號
       SELECT COUNT(*) INTO l_cnt FROM con_file 
        WHERE con03 = l_coa.coa03 AND con08 = l_coa.coa05
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF
       LET l_no = l_no + 1
        #No.MOD-490398  --end
    END FOREACH
    #無對應之商品編號
    IF l_no = 0 THEN RETURN 1 END IF
    RETURN 0
END FUNCTION
 

REPORT p501_rep(no,seq,l_tlf_rowid,l_tlf,l_plant)          #TQC-AB0103 add l_plant
  DEFINE no     LIKE cop_file.cop01         #No.FUN-680069 VARCHAR(16)  #單據號碼 
  DEFINE seq    LIKE type_file.num5         #No.FUN-680069 SMALLINT    #單據項次
  DEFINE l_plant         LIKE azp_file.azp01     #TQC-AB0103 
  DEFINE l_tlf_rowid     LIKE type_file.row_id   #chr18  FUN-A70120
  DEFINE l_tlf  RECORD LIKE tlf_file.*
  DEFINE l_cop  RECORD LIKE cop_file.*
  
  DEFINE l_coc01    LIKE coc_file.coc01,
         l_sum      LIKE coe_file.coe05,
         l_qty      LIKE coe_file.coe09,
         l_tot      LIKE cop_file.cop16,
         l_w_qty    LIKE cod_file.cod09,
         l_ima25    LIKE ima_file.ima25,
         l_ima02    LIKE ima_file.ima02,
         l_ima021   LIKE ima_file.ima021,
         l_fac      LIKE coa_file.coa04,
         l_unit_fac LIKE coa_file.coa04,
         l_cnt      LIKE type_file.num5                  #No.MOD-490398        #No.FUN-680069 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  
  ORDER EXTERNAL BY l_plant,no,seq        #TQC-AB0103 
  FORMAT
    #No.MOD-490398
   PAGE HEADER
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[36],g_x[37],g_x[35]
      PRINT g_dash1
 
   BEFORE GROUP OF no
#      BEGIN WORK
#      LET g_success = 'Y'
 
   BEFORE GROUP OF seq
      LET g_msg = ''  
    #No.MOD-490398 end
 
   AFTER GROUP OF seq
      INITIALIZE l_cop.* TO NULL
      LET l_cop.cop01 = no                   #單據編號
      LET l_cop.cop02 = seq                  #項次
      LET l_cop.cop03 =l_tlf.tlf06           #單據日期
      LET l_cop.cop04 =l_tlf.tlf01           #料件編號
      LET l_cop.cop05 =l_tlf.tlf19           #廠商編號
      SELECT pmc03 INTO l_cop.cop06          #廠商簡稱
       FROM pmc_file WHERE pmc01=l_cop.cop05
      LET l_cop.cop10 = '1'                  #1.直接進口 2.轉廠進口
      IF l_tlf.tlf02 = 50 THEN 
          LET l_cop.cop10 = '4'               #4.國外退貨 #No.MOD-490398
      END IF
      
       #No.MOD-490398
      LET l_cop.cop13 = l_tlf.tlf13          #異動命令 
      LET l_cop.cop14 = l_tlf.tlf10          #異動數量
      LET l_cop.cop15 = l_tlf.tlf11          #異動單位 
 
      #Packing/Invoice No,手冊編號
     #----------------No.MOD-880014 modify
     #SELECT rva09,rvb25 INTO l_cop.cop12,l_cop.cop18 FROM rva_file,rvb_file
      SELECT rva08,rva21,rva09,rvb25 INTO l_cop.cop07,l_cop.cop08,
             l_cop.cop12,l_cop.cop18 FROM rva_file,rvb_file
     #----------------No.MOD-880014 end
       WHERE rva01 = rvb01 AND rvb01 = l_tlf.tlf036 AND rvb02 = l_tlf.tlf037
       #No.MOD-490398  --begin
      IF cl_null(l_cop.cop18) THEN LET l_cop.cop18=l_tlf.tlf64 END IF
       #No.MOD-490398  --end   
 
      #海關代號
      SELECT MAX(coc10) INTO l_cop.cop19 FROM coc_file
       WHERE coc03 = l_cop.cop18
 
      #商品編號
      SELECT COUNT(*) INTO l_cnt FROM coa_file 
       WHERE coa01 = l_cop.cop04 AND coa05 = l_cop.cop19
      IF l_cnt > 1 THEN                      #對應多個商品編號 
         LET l_cop.cop11 = 'MISC'
         LET l_unit_fac = 1
      ELSE
         SELECT coa03,coa04 INTO l_cop.cop11,l_unit_fac FROM coa_file 
          WHERE coa01=l_cop.cop04 AND coa05 = l_cop.cop19
      END IF
 
      #合同編號 
      SELECT coc01,coc04 INTO l_coc01,l_cop.cop09 FROM coc_file
       WHERE coc03 = l_cop.cop18
 
      SELECT coe06 INTO l_cop.cop17
        FROM coe_file,coc_file
       WHERE coc01 = coe01 AND coc01 = l_coc01 
         AND coe03 = l_cop.cop11
 
      #異動數量對庫存單位的換算
      IF cl_null(l_tlf.tlf60) THEN LET l_tlf.tlf60 = 1 END IF
      LET l_w_qty = l_cop.cop14 * l_tlf.tlf60
 
      #庫存數量對合同單位的換算
      IF cl_null(l_unit_fac) OR l_unit_fac = 0 THEN
         LET g_msg = cl_getmsg('abm-731',g_lang) LET g_success = 'N'
      END IF
       #No.MOD-490398 end
      LET l_cop.cop16 = l_w_qty * l_unit_fac 
      LET l_cop.cop16 = s_digqty(l_cop.cop16,l_cop.cop17) #FUN-BB0083 add
 
      LET l_cop.cop20  ='N'
      LET l_cop.copconf='N'
      LET l_cop.copacti='Y'
      LET l_cop.copuser=g_user
      LET l_cop.copgrup=g_grup
      LET l_cop.copdate=g_today
       LET l_cop.cop21 = l_tlf.tlf60*l_unit_fac    #No.MOD-530224
       LET l_cop.cop22 = 'N'  #No.MOD-530224
      LET l_cop.copplant = g_plant  #FUN-980002
      LET l_cop.coplegal = g_legal  #FUN-980002
      
      LET l_cop.coporiu = g_user      #No.FUN-980030 10/01/04
      LET l_cop.coporig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO cop_file VALUES(l_cop.*)
      
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","cop_file",l_cop.cop01,l_cop.cop02,STATUS,"","ins cop",0) #TQC-660045        
         LET g_success='N'
      END IF
 
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file       
       WHERE ima01=l_cop.cop04
      IF SQLCA.sqlcode THEN 
         LET l_ima02 = ' ' 
         LET l_ima021 = ' ' 
      END IF
      PRINT COLUMN g_c[31],l_cop.cop01,
            COLUMN g_c[32],l_cop.cop02 USING '###&',
            COLUMN g_c[33],l_cop.cop03,
            COLUMN g_c[34],l_cop.cop04,
            COLUMN g_c[36],l_ima02,
            COLUMN g_c[37],l_ima021,
            COLUMN g_c[35],g_msg
       #No.MOD-490398 end
 
       IF g_success = 'Y' THEN              #No.MOD-490398
        #LET g_sql="UPDATE ",s_dbstring(g_dbs_tra CLIPPED),  #FUN-980092 ADD       #TQC-AB0103                                                                             
        #          "tlf_file SET tlf910='Y' WHERE rowid=?"   #TQC-940178 ADD       #TQC-AB0103 
         LET g_sql="UPDATE ",cl_get_target_table(l_plant,'tlf_file'),              #TQC-AB0103
                   "   SET tlf910='Y' WHERE rowid=?"                               #TQC-AB0103 
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql                      #TQC-AB0103
         PREPARE p501_up_tlf FROM g_sql
         EXECUTE p501_up_tlf USING l_tlf_rowid
         
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd tlf910',STATUS,0) 
            LET g_success='N'
         END IF
      END IF
 
   AFTER GROUP OF no

END REPORT
