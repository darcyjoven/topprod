# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axcp130.4gl
# Descriptions...: LCM 料件數量入庫異動計算作業
# Date & Author..: 99/03/29 By Linda
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7B0117 07/12/18 By Sarah 移除QBE的 類別 選擇功能
# Modify.........: No.MOD-850089 08/07/13 By Pengu 若異動起始日有異動且異動量與庫存量時,其將差量累加在異動起始日
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting 完善報錯方式修改
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.MOD-920144 09/02/16 By Pengu 工單入庫處理部份未包含Runcard 工單
# Modify.........: No.FUN-940049 09/04/15 By jan 1.抓取料件之入庫異動資料(tlf_file)時，改成依選項限定tlf13
# ...............................................2.往前推算到了 異動起始日 時，若 異動量 < 庫存量時，
# .................................................改成去cao_file抓取資料，若cao_file無資料時，才將其差量放在異動起始日
# Modify.........: No.CHI-980016 09/08/07 By mike 請調整axcp130將tm.b2與tm.b3預設為'N'  
# Modify.........: No.FUN-970102 09/07/29 By jan移除g_cmz.cmz70
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0158 09/10/27 By sabrina 計算已結筆數 no_ok 錯誤
# Modify.........: No:CHI-980035 09/11/16 By jan 有差異量時，去cao_file撈開帳資料來新增到cmc_file,未判斷到開帳資料若大於差異量的處理
# Modify.........: No:CHI-9C0025 09/12/22 By kim add 成本計算類別(cma07)及類別編號(cma08)
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:MOD-A60101 10/06/15 By Sarah tm.b1='Y'時,需增加抓tlf13='asft6231'的資料
# Modify.........: No:MOD-9C0430 10/11/25 By sabrina 輸入料號後直接按確定，計畫日期會沒有值
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:CHI-B80057 13/01/22 By Alberti 在抓取成本開帳資料時，應以最近日期優先抓取
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            wc      LIKE type_file.chr1000,             #No.FUN-680122 VARCHAR(600),
            yy      LIKE type_file.num5,          #FUN-8B0047
            mm      LIKE type_file.num5,          #FUN-8B0047
            bdate   LIKE cmz_file.cmz01,   #基準日      #No.FUN-680122 DATE,
            cmz70   LIKE cmz_file.cmz01,   #異動起始日  #No.FUN-680122 DATE,
            ctype   LIKE ccc_file.ccc07,   #CHI-9C0025
            b1      LIKE type_file.chr1,   #FUN-940049
            b2      LIKE type_file.chr1,   #FUN-940049
            b3      LIKE type_file.chr1,   #FUN-940049
            no_tot  LIKE type_file.num5,   #應結筆數    #No.FUN-680122 SMALLINT,
            no_ok   LIKE type_file.num5,   #已結筆數    #No.FUN-680122 SMALLINT,
            p1      LIKE ima_file.ima57,   #階數
            p2      LIKE ima_file.ima01    #料件編號
           END RECORD,
       g_cmz   RECORD LIKE cmz_file.*,
       a_bdate,a_edate  LIKE type_file.dat,            #No.FUN-680122 DATE,      #區段1
       b_bdate,b_edate  LIKE type_file.dat,            #No.FUN-680122 DATE,      #區段2
       c_bdate,c_edate  LIKE type_file.dat,            #No.FUN-680122 DATE,      #區段3
       yy,mm            LIKE type_file.num5,           #No.FUN-680122 SMALLINT,  #現行會計年月
       g_yy             LIKE type_file.num5,           #No.FUN-680122 SMALLINT,  #基準日之年度
       g_mm             LIKE type_file.num5            #No.FUN-680122 SMALLINT   #基準日之月份
 
DEFINE g_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE l_flag          LIKE type_file.chr1,         #No.FUN-570153 #No.FUN-680122 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(01),     #是否有做語言切換 No.FUN-570153
       ls_date         STRING                       #No.FUN-570153
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc    = ARG_VAL(1)                      
   LET ls_date  = ARG_VAL(2)                      
   LET tm.bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(3)                      
   LET tm.cmz70 = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob  = ARG_VAL(4)                
   LET tm.yy    = ARG_VAL(5) #FUN-8B0047                      
   LET tm.mm    = ARG_VAL(6) #FUN-8B0047                      
   LET tm.ctype = ARG_VAL(7) #CHI-9C0025
   IF cl_null(g_bgjob) THEN 
      LET g_bgjob = 'N'
   END IF 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME    #No.FUN-6A0146
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   
   #讀取LCM系統參數檔
   SELECT * INTO g_cmz.*
     FROM cmz_file
    WHERE cmz00 = '0'
   IF SQLCA.SQLCODE <>0 THEN
      CALL cl_err3("sel","cmz_file","","",sqlca.sqlcode,"","sel cmz error:",1)   #No.FUN-660127
      EXIT PROGRAM
   END IF
 
 
   WHILE TRUE
      LET g_success = 'Y'

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

      IF g_bgjob = "N" THEN
         CALL p130_tm()
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            CALL p130()
            CALL s_showmsg()        #No.FUN-710027  
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
               CLOSE WINDOW p130_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p130_w
      ELSE
         BEGIN WORK
         CALL p130()
         CALL s_showmsg()        #No.FUN-710027  
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p130_tm()
   DEFINE   l_msg   LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(30) 
   DEFINE   c       LIKE cre_file.cre08           #No.FUN-680122 VARCHAR(10)
   DEFINE lc_cmd    LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(500)            #No.FUN-570153
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B0047
 
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW p130_w AT p_row,p_col WITH FORM "axc/42f/axcp130" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   
   LET yy=g_ccz.ccz01 LET mm=g_ccz.ccz02 
   LET tm.yy    = g_ccz.ccz01 #FUN-8B0047
   LET tm.mm    = g_ccz.ccz02 #FUN-8B0047
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate  #No:MOD-9C0430 add
   LET tm.b1    = 'Y'         #FUN-940049
   LET tm.b2    = 'N'         #FUN-940049 #CHI-980016 Y-->N  
   LET tm.b3    = 'N'         #FUN-940049 #CHI-980016 Y-->N  
   LET tm.ctype = g_ccz.ccz28 #CHI-9C0025
 
WHILE TRUE
 
   CONSTRUCT BY NAME tm.wc ON cma01         ##FUN-7B0117
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cmauser', 'cmagrup') #FUN-980030
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW p130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_bgjob = 'N'    # FUN-570153
 
   CALL cl_set_comp_entry('bdate',FALSE) #FUN-8B0047
 
   DISPLAY BY NAME tm.yy,tm.mm,tm.bdate,tm.cmz70   #,tm.a1,tm.a2,tm.a3,tm.a4,tm.a5 #FUN-8B0047 #FN-940049 mark a
 
   INPUT BY NAME tm.yy,tm.mm,tm.bdate,tm.cmz70,tm.ctype,  #tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,  #FUN-940049 mark a  #CHI-9C0025
                 tm.b1,tm.b2,tm.b3,        #FUN-940049
                 g_bgjob WITHOUT DEFAULTS   #NO.FUN-570153  #FUN-8B0047
 
         AFTER FIELD yy
            IF NOT cl_null(tm.yy) THEN
               IF tm.yy < 0 THEN
                  CALL cl_err('','mfg5034',0)
                  NEXT FIELD yy
               END IF
              #--------------No:MOD-9C0430 add
               IF NOT cl_null(tm.mm) THEN
                  CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate
                  DISPLAY BY NAME tm.bdate
               END IF
              #--------------No:MOD-9C0430 end
            END IF
 
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN
               IF tm.mm < 1 OR tm.mm > 12 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD mm
               END IF
               CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate
               DISPLAY BY NAME tm.bdate
            END IF
 
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN
            NEXT FIELD bdate
         END IF
         LET g_yy = YEAR(tm.bdate)
         LET g_mm = MONTH(tm.bdate)
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM ccc_file
          WHERE ccc02 = g_yy
            AND ccc03 = g_mm
         IF g_cnt =0 OR g_cnt IS NULL THEN
            CALL cl_getmsg('axc-004',g_lang) RETURNING l_msg
            ERROR l_msg
            NEXT FIELD bdate
         END IF
      AFTER FIELD cmz70
         IF tm.cmz70 IS NULL THEN
            NEXT FIELD cmz70
         END IF
         IF tm.cmz70 > tm.bdate THEN
            NEXT FIELD cmz70
         END IF
 
 
      AFTER INPUT
         IF INT_FLAG THEN
            RETURN
         END IF
         IF tm.b1 MATCHES '[Nn]' AND tm.b3 MATCHES '[Nn]' AND tm.b2 MATCHES '[Nn]' THEN
            NEXT FIELD b1
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
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
     ON ACTION locale
        LET g_change_lang = TRUE
        EXIT INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp130"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp130','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.wc CLIPPED ,"'",
                      " '",tm.bdate CLIPPED ,"'",
                      " '",tm.cmz70 CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",tm.yy   CLIPPED,"'", #FUN-8B0047
                      " '",tm.mm   CLIPPED,"'", #FUN-8B0047
                      " '",tm.ctype CLIPPED,"'" #CHI-9C0025
         CALL cl_cmdat('axcp130',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p130()
   DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680122CHAR(800)
 
   #先刪除此次要計算之LCM料件數量入庫異動
   IF tm.wc = " 1=1 " THEN
      DELETE FROM cmc_file WHERE 1=1
          AND cmc021=tm.yy #FUN-8B0047
          AND cmc022=tm.mm #FUN-8B0047
          AND cmc07 =tm.ctype #CHI-9C0025
   ELSE
      LET l_sql = " DELETE FROM cmc_file",
                  "  WHERE cmc01 IN (SELECT cma01 FROM cma_file ",
                  "  WHERE ",tm.wc CLIPPED," )",
                  "    AND cmc021=",tm.yy, #FUN-8B0047
                  "    AND cmc022=",tm.mm, #FUN-8B0047
                  "    AND cmc07 ='",tm.ctype,"' " #CHI-9C0025
      PREPARE del_cmc FROM l_sql
      EXECUTE del_cmc 
   END IF
   IF SQLCA.SQLCODE <> 0 THEN   
      LET g_success='N'
      RETURN
   END IF
   #將料件新增至LCM入庫檔中
   CALL p130_ins_cmc()
END FUNCTION
 
FUNCTION p130_ins_cmc()
  DEFINE l_sql LIKE type_file.chr1000,       #No.FUN-680122CHAR(1200),
         l_sql1 LIKE type_file.chr1000,       #No.FUN-680122CHAR(600),
         l_cnt1 LIKE type_file.num5,         #No:MOD-9A0158 add
         l_cnt  LIKE type_file.num5          #No.FUN-680122 SMALLINT
  DEFINE l_tlf06 LIKE tlf_file.tlf06,
         l_tlf10 LIKE tlf_file.tlf10,
         l_qty   LIKE tlf_file.tlf10,
         l_diff  LIKE tlf_file.tlf10,
         l_tot_cao03 LIKE cao_file.cao03, #FUN-940049
         l_cma   RECORD LIKE cma_file.*,
         l_cmc   RECORD LIKE cmc_file.*,
         l_cao   RECORD LIKE cao_file.*   #FUN-940049
  DEFINE l_b1    STRING
  DEFINE l_b2    STRING
  DEFINE l_b3    STRING
  DEFINE l_sql2  STRING
   
   LET l_sql = " SELECT COUNT(DISTINCT cma01) ",   #CHI-9C0025
               " FROM cma_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND cma15 <> 0 ",
               "   AND cma021=",tm.yy, #FUN-8B0047
               "   AND cma022=",tm.mm, #FUN-8B0047
               "   AND cma07 ='",tm.ctype,"' "  #CHI-9C0025
   PREPARE p130_cn1 FROM l_sql
   DECLARE p130_cp1 CURSOR FOR p130_cn1
   OPEN p130_cp1
   FETCH p130_cp1 INTO tm.no_tot
   IF g_bgjob = 'N' THEN  #NO.FUN-570153 
       DISPLAY BY NAME tm.no_tot
   END IF
   LET l_sql = " SELECT * ", 
               " FROM cma_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND cma15 <> 0 ",
               "   AND cma021=",tm.yy, #FUN-8B0047
               "   AND cma022=",tm.mm, #FUN-8B0047
               "   AND cma07 ='",tm.ctype,"' "  #CHI-9C0025
   PREPARE p130_p1 FROM l_sql
   DECLARE p130_c1 CURSOR FOR p130_p1
 
   LET tm.no_tot=0
   LET l_cnt=0
   #得到該料件之入庫異動資料   
   LET l_sql1 = "SELECT tlf06,SUM(tlf10*tlf60) ", #no.6966
                " FROM tlf_file ",
                " WHERE tlf01 = ? ",
                "   AND tlfcost = ? ", #CHI-9C0025
                "   AND tlf06 BETWEEN '",tm.cmz70,"' AND '",tm.bdate,"' ",
                "   AND tlf03='50' " ,
                "   AND tlf10 <> 0 ",
                "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ",
                "   AND tlf021 NOT IN (select cmw01 FROM cmw_file) "   #FUN-940049
   LET l_b1 = NULL
   LET l_b2 = NULL
   LET l_b3 = NULL
   LET l_sql2 = ''
   IF tm.b1 = 'Y' THEN
      LET l_b1 = " ((tlf02 = '50' AND  tlf13 IN ('asft6201','asrt320','asft6231')) OR ",
                 "  (tlf13 IN ('apmt150','asft6201','asft6231','apmt230','apmt102','apmt1072')))"   #MOD-A60101 add asft6231
   END IF     
   IF tm.b2 = 'Y' THEN
      LET l_b2 = " (tlf13 IN ('aimt302','aimt312') OR (tlf03='50' AND tlf13='aimp880'))"
   END IF
   IF tm.b3 = 'Y' THEN
      LET l_b3 = " (tlf13 IN ('asfi526','asfi527','asfi528','asfi529','asri220') OR ",
                                  " (tlf02='65' AND tlf13='asft6201') OR tlf13='aomt800')"
   END IF
   IF l_b1 IS NOT NULL THEN
      LET l_sql2 = " OR ",l_b1
   END IF
   IF l_b2 IS NOT NULL THEN
      LET l_sql2 = l_sql2 ," OR ",l_b2
   END IF
   IF l_b3 IS NOT NULL THEN
      LET l_sql2 = l_sql2 ," OR ",l_b3
   END IF
   IF l_sql2.getlength() > 4 THEN
      #將第一個"OR"刪掉
      LET l_sql2 = l_sql2.substring(5,l_sql2.getlength())
      LET l_sql2 = " AND (",l_sql2 ,") "
   END IF
   LET l_sql1 = l_sql1 ,l_sql2
   LET l_sql1 = l_sql1 CLIPPED," GROUP BY tlf06 ORDER BY tlf06 DESC " 
   PREPARE p130_tlf FROM l_sql1
   DECLARE p130_ctlf CURSOR FOR p130_tlf
 
   CALL s_showmsg_init()   #No.FUN-710027    
   FOREACH p130_c1 INTO l_cma.*  
     IF SQLCA.SQLCODE <>0 THEN
        EXIT FOREACH
        LET g_success = 'N'         #No.FUN-8A0086
     END IF
     IF g_success='N' THEN  
        LET g_totsuccess='N'  
        LET g_success="Y"   
     END IF 
     IF cl_null(l_cma.cma15) THEN LET l_cma.cma15=0 END IF
     LET l_cnt=l_cnt+1
     LET tm.no_ok=l_cnt
     LET tm.p1=l_cma.cma03
     LET tm.p2=l_cma.cma01
     IF g_bgjob = 'N' THEN  #NO.FUN-570153 
         DISPLAY BY NAME tm.no_ok,tm.p1,tm.p2
     END IF
     LET l_diff=0
     LET l_qty = l_cma.cma15
     FOREACH p130_ctlf USING l_cma.cma01,l_cma.cma08   #CHI-9C0025
                        INTO l_tlf06,l_tlf10
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        IF cl_null(l_tlf10) THEN LET l_tlf10=0 END IF
        LET l_qty = l_qty - l_tlf10
        #若庫存量加總已大於異動量時必須考慮
        IF l_qty <0 THEN
           LET l_tlf10 = l_tlf10 + l_qty
        END IF
        INITIALIZE l_cmc.* TO NULL #CHI-9C0025
        LET l_cmc.cmc01  = l_cma.cma01
        LET l_cmc.cmc02  = tm.bdate
        LET l_cmc.cmc03  = l_tlf06
        LET l_cmc.cmc04  = l_tlf10
        LET l_cmc.cmc021 = tm.yy   #FUN-8B0047
        LET l_cmc.cmc022 = tm.mm   #FUN-8B0047
        LET l_cmc.cmc07  = l_cma.cma07  #CHI-9C0025
        LET l_cmc.cmc08  = l_cma.cma08  #CHI-9C0025
        LET l_cmc.cmclegal = g_legal    #FUN-A50075

        INSERT INTO cmc_file VALUES(l_cmc.*)
        IF SQLCA.SQLCODE <> 0 THEN
           LET g_success='N'
            LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03                                                            #No.FUN-710027
           CALL s_errmsg('cmc01,cmc03',g_showmsg,'ins cmc:',SQLCA.sqlcode,1)                                       #No.FUN-710027
        END IF
        IF l_qty <0 THEN
           EXIT FOREACH 
        END IF 
     END FOREACH
     #若異動量 < 庫存量時, 其差量放在異動起始日  
     IF l_qty > 0 THEN  
       LET l_cnt1 = 0                             #MOD-9A0158 l_cnt modify l_cnt1
       SELECT count(*) INTO l_cnt1 FROM cao_file  #MOD-9A0158 l_cnt modify l_cnt1
        WHERE cao01 = l_cma.cma01 AND caoacti = 'Y'
          AND cao07 = l_cma.cma07  #CHI-9C0025
          AND cao08 = l_cma.cma08  #CHI-9C0025
       LET l_tot_cao03 = 0
       IF l_cnt1 = 0 THEN                         #MOD-9A0158 l_cnt modify l_cnt1
          INITIALIZE l_cmc.* TO NULL #CHI-9C0025
          LET l_cmc.cmc01 = l_cma.cma01
          LET l_cmc.cmc02=tm.bdate
          LET l_cmc.cmc03=tm.cmz70
          LET l_cmc.cmc04=l_qty
          LET l_cmc.cmc021=tm.yy   #FUN-8B0047
          LET l_cmc.cmc022=tm.mm   #FUN-8B0047
          LET l_cmc.cmc07  = l_cma.cma07  #CHI-9C0025
          LET l_cmc.cmc08  = l_cma.cma08  #CHI-9C0025
          LET l_cmc.cmclegal = g_legal    #FUN-A50075
          INSERT INTO cmc_file VALUES(l_cmc.*)
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
             UPDATE cmc_file SET cmc04 = cmc04 + l_qty
                       WHERE cmc01  = l_cma.cma01
                         AND cmc03  = tm.cmz70
                         AND cmc021 = tm.yy  #FUN-8B0047
                         AND cmc022 = tm.mm  #FUN-8B0047
                         AND cmc07  = l_cma.cma07  #CHI-9C0025
                         AND cmc08  = l_cma.cma08  #CHI-9C0025
              IF SQLCA.SQLCODE <> 0 THEN
                 LET g_success='N'
                 LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03 
                 CALL s_errmsg('cmc01,cmc03',g_showmsg,'upd cmc:',SQLCA.sqlcode,1)
              END IF
          ELSE 
             IF SQLCA.SQLCODE <> 0 THEN
                LET g_success='N'
                LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03
                CALL s_errmsg('cmc01,cmc03',g_showmsg,'ins cmc:',SQLCA.sqlcode,1)
             END IF
          END IF       #No.MOD-850089 add
       ELSE
          DECLARE cao_cs CURSOR FOR
           SELECT * FROM cao_file
            WHERE cao01=l_cma.cma01
              AND caoacti='Y'
              AND cao07 = l_cma.cma07  #CHI-9C0025
              AND cao08 = l_cma.cma08  #CHI-9C0025
            ORDER BY cao02 DESC      #CHI-B80057 add
          FOREACH cao_cs INTO l_cao.*
            IF l_cao.cao03>=(l_qty-l_tot_cao03) THEN #CHI-980035
               LET l_cao.cao03=l_qty- l_tot_cao03    #CHI-980035
            END IF                                   #CHI-980035
            INITIALIZE l_cmc.* TO NULL
            LET l_cmc.cmc01  = l_cao.cao01
            LET l_cmc.cmc02  = tm.bdate
            LET l_cmc.cmc03  = l_cao.cao02
            LET l_cmc.cmc04  = l_cao.cao03
            LET l_cmc.cmc021 = tm.yy
            LET l_cmc.cmc022 = tm.mm
            LET l_cmc.cmc07  = l_cao.cao07
            LET l_cmc.cmc08  = l_cao.cao08
            LET l_cmc.cmclegal = g_legal    #FUN-A50075
            INSERT INTO cmc_file VALUES(l_cmc.*)
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                UPDATE cmc_file SET cmc04 = cmc04 + l_cao.cao03   #CHI-980035
                          WHERE cmc01 = l_cma.cma01
                            AND cmc03 = tm.cmz70
                            AND cmc021=tm.yy
                            AND cmc022=tm.mm
                            AND cmc07  = l_cao.cao07  #CHI-9C0025
                            AND cmc08  = l_cao.cao08  #CHI-9C0025
                 IF SQLCA.SQLCODE <> 0 THEN
                    LET g_success='N'
                    LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03
                    CALL s_errmsg('cmc01,cmc03',g_showmsg,'upd cmc:',SQLCA.sqlcode,1)
                 END IF
             ELSE 
                IF SQLCA.SQLCODE <> 0 THEN
                   LET g_success='N'
                   LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03
                   CALL s_errmsg('cmc01,cmc03',g_showmsg,'ins cmc:',SQLCA.sqlcode,1)
                END IF
             END IF
            LET l_tot_cao03=l_tot_cao03+l_cao.cao03
            IF l_tot_cao03 >= l_qty THEN  #CHI-980035
               EXIT FOREACH               #CHI-980035
            END IF                        #CHI-980035
          END FOREACH
          IF l_tot_cao03 < l_qty THEN
             LET l_cmc.cmc01  = l_cma.cma01
             LET l_cmc.cmc02  = tm.bdate
             LET l_cmc.cmc03  = tm.cmz70
             LET l_cmc.cmc04  = l_qty - l_tot_cao03
             LET l_cmc.cmc021 = tm.yy
             LET l_cmc.cmc022 = tm.mm
             LET l_cmc.cmc07  = l_cma.cma07  #CHI-9C0025
             LET l_cmc.cmc08  = l_cma.cma08  #CHI-9C0025
             LET l_cmc.cmclegal = g_legal    #FUN-A50075
             INSERT INTO cmc_file VALUES(l_cmc.*) #CHI-9C0025            
             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                UPDATE cmc_file SET cmc04=cmc04+(l_qty - l_tot_cao03)
                 WHERE cmc01  = l_cma.cma01
                   AND cmc03  = tm.cmz70
                   AND cmc021 = tm.yy
                   AND cmc022 = tm.mm
                   AND cmc07  = l_cma.cma07  #CHI-9C0025
                   AND cmc08  = l_cma.cma08  #CHI-9C0025
                IF SQLCA.SQLCODE <> 0 THEN
                   LET g_success = 'N'
                   LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03
                   CALL s_errmsg('cmc01,cmc03',g_showmsg,'upd cmc:',SQLCA.sqlcode,1)
                END IF
             ELSE
                IF SQLCA.SQLCODE <> 0 THEN
                   LET g_success = 'N'
                   LET g_showmsg = l_cmc.cmc01,"/",l_cmc.cmc03
                   CALL s_errmsg('cmc01,cmc03',g_showmsg,'ins cmc:',SQLCA.sqlcode,1)
                END IF
             END IF 
          END IF
       END IF
     END IF   
   END FOREACH 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls  10/01/11 
