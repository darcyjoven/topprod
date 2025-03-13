# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axcp306.4gl
# Descriptions...: 每月人工製費整批產生作業
# Date & Author..: 08/01/24 BY Sarah
# Modify.........: No.FUN-7C0028 08/01/24 By Sarah 新增"每月人工製費整批產生作業"
# Modify.........: No.FUN-840169 08/04/24 By Sarah 增加一選項"是否依axci041所設定科目抓取科目餘額,產生至axct211?"
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-920010 09/02/04 By jan 拿掉選項"是否依axci041所設定科目抓取科目餘額,產生至axct211?"
# Modify.........: No.CHI-920067 09/03/03 By Pengu INSERT cdb時若KEY重覆應累加cdb05
# Modify.........: No.CHI-970043 09/07/20 By jan 改sql語句
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990045 09/09/29 By Pengu update cdb_file位考慮跨資料庫
# Modify.........: No.FUN-980092 09/09/29 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.TQC-9A0003 09/10/09 By wujie 背景執行時走不到AFTER FIELD plant 中的p306_get_dbs()
# Modify.........: No:MOD-980109 09/11/11 By sabrina 滾算時金額時，應該用cmi_file去滾算，而不能用cda_file
# Modify.........: No:MOD-9A0120 09/11/11 By sabrina 成本中心+成本項目的金額沒有跟axct211一樣
# Modify.........: No:FUN-9B0118 09/12/01 By Carrier add type & 根据cmi/cay/cdb的key的变化加入相关值
# Modify.........: No:TQC-9C0073 09/12/10 By Carrier 不过plant字段时,g_dbs_new的赋值
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A50075 10/05/25 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.CHI-BC0036 11/12/28 By ck2yuan 增加控管年度期別不可小於現行年度期別
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:TQC-C20478 12/02/27 By xujing  調整AFTER FIELD e中 SQL語法有誤
# Modify.........: No:MOD-CB0002 12/11/06 By Elise 避免舊值殘留，抓取前先清空變數
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能
# Modify.........: No:MOD-D90024 13/09/05 By suncx 背景執行時也需要調用函數p306_get_dbs()，否則legal为null

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
            yy         LIKE type_file.num5,
            mm         LIKE type_file.num5,
            p_plant    LIKE azp_file.azp01,
            e          LIKE aaa_file.aaa01,
            type       LIKE type_file.chr1   #No.FUN-9B0118
           #a          LIKE type_file.chr1   #FUN-840169 add  #FUN-920010
          END RECORD
DEFINE n               LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_flag          LIKE type_file.chr1
DEFINE l_flag          LIKE type_file.chr1 
DEFINE g_change_lang   LIKE type_file.chr1      #是否有做語言切換
DEFINE g_bdate,g_edate LIKE ccj_file.ccj01 
DEFINE l_plant_new            LIKE azp_file.azp01     #FUN-980009 add 
DEFINE l_legal                LIKE azw_file.azw02     #FUN-980009 add 
DEFINE l_dbs_tra     LIKE type_file.chr21   #FUN-980092
DEFINE g_cka00         LIKE cka_file.cka00   #FUN-C80092 add
DEFINE g_cka09         LIKE cka_file.cka09   #FUN-C80092 add

MAIN
  OPTIONS
      INPUT NO WRAP
  DEFER INTERRUPT				# Supress DEL key function
 
  INITIALIZE g_bgjob_msgfile TO NULL
  LET tm.yy     = ARG_VAL(1)
  LET tm.mm     = ARG_VAL(2)
  LET tm.p_plant= ARG_VAL(3)
  LET tm.e      = ARG_VAL(4)     
  LET tm.type   = ARG_VAL(5)       #FUN-920010
  LET g_bgjob   = ARG_VAL(6)       #FUN-920010

  IF cl_null(g_bgjob) THEN
     LET g_bgjob = "N"
  END IF
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (NOT cl_setup("AXC")) THEN
     EXIT PROGRAM
  END IF
 
  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

  LET g_success = 'Y'
  WHILE TRUE
     LET g_flag = 'Y' 

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

     IF g_bgjob = "N" THEN
        CLEAR FORM
        CALL p306_tm(0,0)
        IF g_flag = 'N' THEN
           CONTINUE WHILE
        END IF
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
        LET g_plant_new= tm.p_plant  #工厂编号                                  
        CALL s_getdbs()                                                         
        IF cl_sure(18,20) THEN 
           #FUN-C80092--add--str--
           LET g_cka09 = " tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; tm.p_plant='",tm.p_plant,
                         "'; tm.e='",tm.e,"'; tm.type='",tm.type,"'; g_bgjob='",g_bgjob,"'"
           CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
           #FUN-C80092--add--end--
           BEGIN WORK
           LET g_success = 'Y'
           CALL p306_get_dbs(tm.p_plant)     #No.TQC-9A0003
           CALL axcp306()
           CALL s_showmsg()
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
              CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF l_flag THEN 
              CONTINUE WHILE 
           ELSE 
              CLOSE WINDOW p306_w
              EXIT WHILE 
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p306_w
     ELSE
        #FUN-C80092--add--str--
        LET g_cka09 = " tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; tm.p_plant='",tm.p_plant,
                      "'; tm.e='",tm.e,"'; tm.type='",tm.type,"'; g_bgjob='",g_bgjob,"'"
        CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
        #FUN-C80092--add--end--
        BEGIN WORK
        LET g_success = 'Y'
        LET g_plant_new= tm.p_plant  #工厂编号                                  
        CALL s_getdbs()                                                         
        CALL p306_get_dbs(tm.p_plant)  #MOD-D90024 add
        CALL axcp306()
        CALL s_showmsg()
        IF g_success = "Y" THEN
           COMMIT WORK
           CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
        ELSE
           ROLLBACK WORK
           CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE

  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p306_tm(p_row,p_col)
  DEFINE p_row,p_col    LIKE type_file.num5
  DEFINE l_sql          STRING
  DEFINE lc_cmd         LIKE type_file.chr1000
  DEFINE li_chk_bookno  LIKE type_file.num5
  DEFINE l_aaa          RECORD LIKE aaa_file.*   #TQC-C20478 
 
  OPEN WINDOW p306_w WITH FORM "axc/42f/axcp306"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()
 
  WHILE TRUE
     MESSAGE ""
     IF s_shut(0) THEN RETURN END IF
     CLEAR FORM
     INITIALIZE tm.* TO NULL          #Default condition
     LET tm.yy = g_ccz.ccz01
     LET tm.mm = g_ccz.ccz02
     LET tm.p_plant=g_plant
     LET tm.e  = g_aaz.aaz64          #預設帳別
     LET tm.type = g_ccz.ccz28        #No.FUN-9B0118
     LET g_bgjob = 'N'
 
     DISPLAY BY NAME tm.yy,tm.mm,tm.p_plant,tm.e #,tm.a   #FUN-840169 add tm.a #FUN-920010
     INPUT BY NAME tm.yy,tm.mm,tm.p_plant,tm.e,tm.type,g_bgjob WITHOUT DEFAULTS   #FUN-840169 add tm.a#FUN-920010 del tm.a  #No.FUN-9B0118
        AFTER FIELD yy
           IF tm.yy IS NULL THEN
              NEXT FIELD yy
           END IF
 
        AFTER FIELD mm
           IF NOT cl_null(tm.mm) THEN
              SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.yy
              IF g_azm.azm02 = 1 THEN
                 IF tm.mm > 12 OR tm.mm < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD mm
                 END IF
              ELSE
                 IF tm.mm > 13 OR tm.mm < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD mm
                 END IF
              END IF
           END IF
           IF tm.mm IS NULL THEN
              NEXT FIELD mm
           END IF
 
        AFTER FIELD p_plant
           IF tm.p_plant IS NULL THEN
              NEXT FIELD p_plant
           END IF
           SELECT COUNT(*) INTO g_cnt FROM azp_file WHERE azp01=tm.p_plant
           IF g_cnt=0 THEN
              CALL cl_err(tm.p_plant,'apm-277',1) NEXT FIELD p_plant
           END IF
           CALL p306_get_dbs(tm.p_plant)
 
        AFTER FIELD e  #帳別
           IF tm.e IS NULL THEN
              NEXT FIELD e
           END IF
           IF NOT cl_null(tm.e) THEN
              CALL s_check_bookno(tm.e,g_user,tm.p_plant)
                  RETURNING li_chk_bookno
              IF (NOT li_chk_bookno) THEN
                  NEXT FIELD e
              END IF 
              LET g_plant_new= tm.p_plant  #工廠編號
              #CALL s_getdbs()#FUN-A50102
              LET l_sql = "SELECT *",
                          #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                          "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),#FUN-A50102
                          " WHERE aaa01 = '",tm.e,"' ",
                          "   AND aaaacti IN ('Y','y') "
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
              PREPARE p306_pre2 FROM l_sql
              DECLARE p306_cur2 CURSOR FOR p306_pre2
              OPEN p306_cur2
#             FETCH p306_cur2 INTO g_cnt      #TQC-C20478
              FETCH p306_cur2 INTO l_aaa.*    #TQC-C20478
              IF STATUS THEN
                 CALL cl_err(tm.e,'aap-229',0) NEXT FIELD e
              END IF
           END IF
           #LET l_sql= " SELECT COUNT(*) FROM ",g_dbs_new CLIPPED,"aaa_file ",
           LET l_sql= " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aaa_file'),#FUN-A50102
                      " WHERE aaa01='",tm.e,"'"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE p306_e_pre FROM l_sql
           DECLARE p306_e_cur CURSOR FOR p306_e_pre
           OPEN p306_e_cur
           FETCH p306_e_cur INTO g_cnt
           IF g_cnt=0 THEN
              CALL cl_err(tm.e,'anm-062',1) NEXT FIELD e
           END IF
           CLOSE p306_e_cur
 
        AFTER INPUT
           IF tm.yy IS NULL THEN NEXT FIELD yy END IF
           IF tm.mm IS NULL THEN NEXT FIELD mm END IF
           IF tm.p_plant IS NULL THEN NEXT FIELD p_plant END IF
           IF tm.e IS NULL THEN NEXT FIELD e END IF

         #-----CHI-BC0036 str add-----
             IF tm.yy*12+tm.mm > g_ccz.ccz01*12+g_ccz.ccz02 THEN
               CALL cl_err('','axc-196','1')
               #ERROR "計算年度期別不可小於現行年期!"
               NEXT FIELD yy
             END IF
         #-----CHI-BC0036 end add-----
 
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
 
        ON ACTION exit          #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
 
        ON ACTION locale        #genero
           LET g_change_lang = TRUE
           EXIT INPUT
 
        BEFORE INPUT
           CALL cl_qbe_init()
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
     END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        LET g_flag = 'N'
        RETURN
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p306_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "axcp306"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axcp306','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.yy CLIPPED ,"'",
                        " '",tm.mm CLIPPED ,"'",
                        " '",tm.p_plant CLIPPED ,"'",
                        " '",tm.e CLIPPED ,"'",
                        " '",tm.type CLIPPED ,"'",   #No.FUN-9B0118
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('axcp306',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p306_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION axcp306()
  DEFINE l_sql                  STRING,                   # RDSQL STATEMENT
         l_cmi                  RECORD
                                   cmi01 LIKE cmi_file.cmi01,  #carrier add cmi00?
                                   cmi02 LIKE cmi_file.cmi02,
                                   cmi03 LIKE cmi_file.cmi03,
                                   cmi04 LIKE cmi_file.cmi04,
                                   cmi05 LIKE cmi_file.cmi05
                                END RECORD,
         l_cda06                LIKE cda_file.cda06,
         l_cda08                LIKE cda_file.cda08,
         l_cda09                LIKE cda_file.cda09,
         cdb                    RECORD LIKE cdb_file.*,
         l_cmi08                LIKE cmi_file.cmi08,       #金額
         aao                    RECORD LIKE aao_file.*,
         cax                    RECORD LIKE cax_file.*,   #TQC-6A0072 add
         cay                    RECORD LIKE cay_file.*,   #FUN-660103 add
         l_aag221               LIKE aag_file.aag221, 
         l_cax07_sum            LIKE cax_file.cax07,      #FUN-660103 add
         l_aaosum               LIKE aao_file.aao05,      #FUN-660201 add
         l_cax10                LIKE cax_file.cax10,      #FUN-660103 add
         l_cam07                LIKE cam_file.cam07,      #FUN-660103 add
         l_caz09_sum            LIKE caz_file.caz09,      #FUN-660103 add
         l_caz10                LIKE caz_file.caz10       #FUN-660103 add
 DEFINE l_cnt                   LIKE type_file.num5       #No.FUN-9B0118
 DEFINE l_str                   STRING                    #No.FUN-9B0118
 DEFINE l_cmi12                 LIKE cmi_file.cmi12       #No.FUN-9B0118
 DEFINE l_count                 INT   
 
 #當勾選要先產生axct211資料
 
  LET g_bdate = MDY(tm.mm,1,tm.yy)
  LET g_edate = MDY(tm.mm+1,1,tm.yy)-1
  
  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'cdb_file,'),cl_get_target_table(l_plant_new,'npp_file'), 
              " WHERE cdb13=npp01 and nppglno is not null AND cdb13 IS NOT NULL AND cdb01='",tm.yy,"' AND cdb02= ",tm.mm,
              "   AND cdb11='",tm.type,"'"      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
  PREPARE del_pre FROM l_sql
  DECLARE del_pre_c CURSOR FOR del_pre
  OPEN del_pre_c
  FETCH del_pre_c INTO l_count
  
    IF l_count>0 THEN
     CALL cl_err('check nppglno&cdb13:','cgl_005',1)
     LET g_success='N'
     RETURN
  END IF
 
  ##同一年/月/成本计算类型,只能有一个帐套

  #LET l_sql = "INSERT INTO ",l_dbs_tra CLIPPED," cdb_file ",  #FUN-980092
  LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant_new,'cdb_file'), #FUN-A50102
              "(cdb00,cdb11,cdb01,cdb02,cdb03,cdb04,cdb05,cdb06,cdb07,cdb08,cdb09,cdb10,", #FUN-8B0047  #No.FUN-9B0118
             #" cdbdate,cdbgrup,cdbmodu,cdbuser,cdbplant,cdblegal,cdboriu,cdborig) ",#FUN-A10036 #FUN-980009 add cdbplant,cdblegal   #FUN-A50075
              " cdbdate,cdbgrup,cdbmodu,cdbuser,cdblegal,cdboriu,cdborig) ",#FUN-A10036 #FUN-980009 add cdbplant,cdblegal  #FUN-A50075 拿掉PLANT
              "VALUES(?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ? ,?,?,?,?)"  #FUN-A10036 #FUN-8B0047 #FUN-980009 add ?,?  #No.FUN-9B0118   #FUN-A50075 拿掉一個?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE insert_prep FROM l_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) 
     CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
 
  #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"cdb_file",  #FUN-980092
  LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'cdb_file'), #FUN-A50102
              "            SET cdb05 = cdb05 + ? ",
              "            WHERE cdb01 = ? ",
              "              AND cdb02 = ? ",
              "              AND cdb03 = ? ",
              "              AND cdb04 = ? ",
              "              AND cdb08 = ? ",
              "              AND cdb11 = ? ",         #No.FUN-9B0118
             #"              AND cdbplant = ? ",      #FUN-A50075
              "              AND cdblegal = ? "
 
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
  PREPARE update_prep FROM l_sql
  IF STATUS THEN
     CALL cl_err('update_prep:',status,1)
     CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
  #->1.先刪除舊資料
  
  #LET l_sql = "DELETE FROM ",l_dbs_tra CLIPPED," cdb_file",  #FUN-980092
  LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant_new,'cdb_file'), #FUN-A50102
              " WHERE cdb01='",tm.yy,"' AND cdb02= ",tm.mm,
              "   AND cdb11='",tm.type,"'"        #No.FUN-9B0118
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
  PREPARE del_pre1 FROM l_sql
  EXECUTE del_pre1
  IF SQLCA.sqlcode THEN
     CALL cl_err('DELETE cdb_file:',SQLCA.sqlcode,0)
     LET g_success='N'
     RETURN
  END IF
 
  #->2.開始產生cdb_file
  #    資料來源axci041,axct211
 
  #-->2-1.抓取cda_file設定(axci041成本中心成本項目分攤方式設置作業)
  #LET l_sql = "SELECT DISTINCT cmi01,cmi02,cmi03,cmi04,cmi05 FROM ",g_dbs_new CLIPPED," cmi_file",  #No:MOD-9A0120 add distinct
  LET l_sql = "SELECT DISTINCT cmi01,cmi02,cmi03,cmi04,cmi05 FROM ",cl_get_target_table(g_plant_new,'cmi_file'), #FUN-A50102
              " WHERE cmi01=",tm.yy,
              "   AND cmi02=",tm.mm,
              "   AND cmi00='",tm.e,"'",          #No.FUN-9B0118
              " ORDER BY cmi01,cmi02,cmi03,cmi04,cmi05"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE axcp306_p1 FROM l_sql
  IF STATUS THEN
     CALL cl_err('axcp306_p1:',STATUS,1)
     CALL cl_batch_bg_javamail("N")
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
  DECLARE axcp306_c1 CURSOR FOR axcp306_p1
 
  CALL s_showmsg_init()
  FOREACH axcp306_c1 INTO l_cmi.*           #MOD-980109 add
     IF STATUS THEN
        CALL s_errmsg('','','Foreach_306_c1:',STATUS,1)
        LET g_success='N'
        EXIT FOREACH
     END IF
     IF g_success='N' THEN  
        LET g_totsuccess='N'  
        LET g_success="Y"   
     END IF 
 
     #-->2-2.抓取金額cmi08.dbo.axct211 (cmi_file) 
     #LET l_sql = "SELECT SUM(cmi08) FROM ",g_dbs_new CLIPPED," cmi_file",
     LET l_sql = "SELECT SUM(cmi08) FROM ",cl_get_target_table(g_plant_new,'cmi_file'), #FUN-A50102
                 " WHERE cmi01= ",l_cmi.cmi01,      #年
                 "   AND cmi02= ",l_cmi.cmi02,      #月 
                 "   AND cmi00='",tm.e,"'",         #No.FUN-9B0118
                 "   AND cmi03='",l_cmi.cmi03,"'",  #工作站
                 "   AND cmi04='",l_cmi.cmi04,"'",  #類別(人工/製費一/二/三/四/五)
                 "   AND cmi05='",l_cmi.cmi05,"'"   #科目
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE axcp306_p_cmi08 FROM l_sql
     DECLARE axcp306_c_cmi08 CURSOR FOR axcp306_p_cmi08
     OPEN axcp306_c_cmi08
     FETCH axcp306_c_cmi08 INTO l_cmi08
     IF cl_null(l_cmi08) THEN LET l_cmi08 = 0 END IF

     LET l_cda06 = ''  LET l_cda08 = ''  LET l_cda09 = 0   #MOD-CB0002 add
     LET l_sql ="SELECT DISTINCT cda06,cda08,cda09 FROM cda_file ",
                " WHERE cda01= '",l_cmi.cmi03,"'",
                "   AND cda02= '",l_cmi.cmi04,"'"
     PREPARE axcp306_p_cda06 FROM l_sql
     DECLARE axcp306_c_cda06 CURSOR FOR axcp306_p_cda06
     FOREACH axcp306_c_cda06 INTO l_cda06,l_cda08,l_cda09
        IF (NOT cl_null(l_cda06)) AND (NOT cl_null(l_cda08)) THEN
            EXIT FOREACH
        END IF
     END FOREACH

     SELECT UNIQUE cmi12 INTO l_cmi12 FROM cmi_file
      WHERE cmi01=l_cmi.cmi01  #年
        AND cmi02=l_cmi.cmi02  #月 
        AND cmi00=tm.e         #No.FUN-9B0118
        AND cmi03=l_cmi.cmi03  #工作站
        AND cmi04=l_cmi.cmi04  #類別(人工/製費一/二/三/四/五)
        AND cmi05=l_cmi.cmi05  #科目
     IF SQLCA.sqlcode THEN LET l_cmi12 = '1' END IF
 
     LET cdb.cdb01=tm.yy               #年
     LET cdb.cdb02=tm.mm               #月
     LET cdb.cdb03=l_cmi.cmi03         #成本中心   #MOD-980109 modify
     LET cdb.cdb04=l_cmi.cmi04         #成本項目   #MOD-980109 modify
     LET cdb.cdb05=l_cmi08             #成本
     LET cdb.cdb06=0                   #分攤基礎指標總數
     LET cdb.cdb07=0                   #單位成本
     LET cdb.cdb08=l_cmi12             #分攤方式   MOD-980109 modify    #No.FUN-9B0118
     LET cdb.cdbdate=g_today           #最近修改日
     LET cdb.cdbgrup=g_grup            #資料所有部門
     LET cdb.cdbmodu=g_user            #資料修改者
     LET cdb.cdbuser=g_user            #資料所有者
     LET cdb.cdb00  =tm.e              #No.FUN-9B0118
     LET cdb.cdb11  =tm.type           #No.FUN-9B0118
     
     LET cdb.cdb09=l_cda08 #FUN-8B0047    #MOD-980109 modify
     LET cdb.cdb10=l_cda09 #FUN-8B0047    #MOD-980109 modify
  
     EXECUTE insert_prep USING
        cdb.cdb00,cdb.cdb11,           #No.FUN-9B0118
        cdb.cdb01,cdb.cdb02,cdb.cdb03,cdb.cdb04,cdb.cdb05,
        cdb.cdb06,cdb.cdb07,cdb.cdb08,cdb.cdb09,cdb.cdb10, #FUN-8B0047
        cdb.cdbdate,cdb.cdbgrup,
       #cdb.cdbmodu,cdb.cdbuser,l_plant_new,l_legal,g_user,g_grup #FUN-A10036  #FUN-980009 add 
        cdb.cdbmodu,cdb.cdbuser,l_legal,g_user,g_grup    #FUN-A50075
     IF SQLCA.SQLCODE THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
           EXECUTE update_prep USING
              l_cmi08,tm.yy,tm.mm,l_cmi.cmi03,
              l_cmi.cmi04,l_cmi12,tm.type,         #No.FUN-9B0118
              #l_plant_new,l_legal                 #No.FUN-9B0118   #FUN-A50075
              l_legal                              #FUN-A50075
           IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err('UPDATE cdb_file',SQLCA.SQLCODE,1)
              LET g_success='N'
           END IF
        ELSE      
           CALL cl_err('INSERT cdb_file',SQLCA.SQLCODE,1)
           LET g_success='N'
        END IF             #No.CHI-920067 add
     END IF
  END FOREACH
  IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION p306_get_dbs(p_plant)
   DEFINE p_plant  LIKE type_file.chr20
 
   SELECT azp03 INTO g_dbs_new FROM azp_file
    WHERE azp01 = p_plant
   IF STATUS THEN LET g_dbs_new=NULL RETURN END IF
   LET g_dbs_new=s_dbstring(g_dbs_new CLIPPED)
 
 
   LET l_plant_new = p_plant                       #FUN-980009 add 
   CALL s_getlegal(l_plant_new) RETURNING l_legal  #FUN-980009 add 
 
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET l_dbs_tra = g_dbs_tra
 
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
