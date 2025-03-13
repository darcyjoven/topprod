# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aglp006.4gl
# Descriptions...: 合併報表長期投資認列分錄產生作業
# Date & Author..: 07/08/24 by Sarah
# Modify.........: No.FUN-780068 07/08/24 By Sarah 新增"合併報表長期投資認列分錄產生作業"
# Modify.........: No.CHI-890015 08/11/04 By Sarah 科目於aag371(關係人異動碼輸入控制)若未設定則無須寫入npq37
# Modify.........: No.MOD-8C0270 08/12/29 By Sarah 關係人代號npq37之值,應填入axz08才對
# Modify.........: No.FUN-890072 08/12/29 By jamie 在p006_process2() 程式段，如果axv05 = '1'(順流)時， 分錄科目抓取改為
#                                                                                                      借：未實現銷貨利益 (aaz108)
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
#                                                                                                          貸：遞延貸項   (aaz109)
# Modify.........: NO.FUN-980003 09/08/28 By TSD.jarlin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/01/07 By hongmei from 5.0X串axe_file時,增加串axe13(族群代號)=tm.axa01
# Modify.........: NO.FUN-930103 09/05/19 BY hongmei from 5.0X ON CHANGE mm寫法，取tm.v_no值，當此欄位無異動時，會造成預設值空白
# Modify.........: No.MOD-9A0005 09/10/07 By Smapmin 異動碼預設為NULL而非一個空白
# Modify.........: NO.FUN-920150 09/10/29 BY yiting 新增至npp_file,npq_file要以上層公司的DB寫入
# Modify.........: NO:FUN-950060 09/10/30 by yiting 修改分錄
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-A50102 10/06/04 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-AB0008 10/11/01 By Dido aag371 增加檢核 4 
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:MOD-B50055 11/05/09 By Sarah 修正MOD-AB0008,當aag371='4'時還需判斷pmc903/occ37為Y時npq37才給值
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-C50059 12/12/20 By Belle 將axb07,axb08,axb13修改為axbb07,axbb06,axbb10
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D40105 13/08/22 By yangtt 組sql錯誤，導致執行失敗

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm      RECORD
                yy       LIKE type_file.num5,    #會計年度
                mm       LIKE type_file.num5,    #期別
                axa01    LIKE axa_file.axa01,    #族群代號
                axa02    LIKE axa_file.axa02,    #上層公司
                axa03    LIKE axa_file.axa03,    #帳別
                v_no     LIKE npp_file.npp01     #單據編號
               END RECORD
DEFINE g_npp             RECORD LIKE npp_file.*
DEFINE g_npq             RECORD LIKE npq_file.*
DEFINE p_row,p_col       LIKE type_file.num5     #No.FUN-680070 SMALLINT
DEFINE l_flag            LIKE type_file.chr1     #No.FUN-680070 VARCHAR(01)
DEFINE g_change_lang     LIKE type_file.chr1     #No.FUN-570144 是否有做語言切換       #No.FUN-680070 VARCHAR(01)
DEFINE g_bookno          LIKE aea_file.aea00     #帳別
DEFINE g_dbs_gl          LIKE type_file.chr21
DEFINE g_plant_gl        LIKE azp_file.azp01     #FUN-A50102
DEFINE g_bdate           LIKE type_file.dat,
       g_edate           LIKE type_file.dat,
       g_rate            LIKE type_file.num20_6, #持股比率
       g_aaa04           LIKE aaa_file.aaa04,    #現行會計年度
       g_aaa05           LIKE aaa_file.aaa05,    #現行期別
       g_axz06           LIKE axz_file.axz06     #上層公司記帳幣別   #FUN-780068 add 10/19
DEFINE g_sql           STRING                    #FUN-920150
DEFINE g_dbs_axz03    LIKE type_file.chr21       #FUN-920150
DEFINE g_axz03         LIKE axz_file.axz03       #FUN-920150
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(2)
   LET tm.mm    = ARG_VAL(3)
   LET tm.axa01 = ARG_VAL(4)
   LET tm.axa02 = ARG_VAL(5)
   LET tm.axa03 = ARG_VAL(6)
   LET tm.v_no  = ARG_VAL(7)
   LET g_bgjob  = ARG_VAL(8)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = "N" THEN
        CALL p006_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p006()
           CALL s_showmsg()                           #NO.FUN-710023
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp006_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        #現行會計年度(aaa04)、現行期別(aaa05)
        SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
          FROM aaa_file WHERE aaa01 = g_bookno      #MOD-660034
        LET g_success = 'Y'
        BEGIN WORK
        CALL p006()
        CALL s_showmsg()                            #NO.FUN-710023
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690114
END MAIN
 
FUNCTION p006_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5
   DEFINE lc_cmd       LIKE type_file.chr1000
   DEFINE l_str        LIKE type_file.chr20
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_max        LIKE type_file.chr20
DEFINE g_sql           STRING                    #FUN-920150
 
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(g_bookno)
 
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW p006_w AT p_row,p_col WITH FORM "agl/42f/aglp006"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE
      CLEAR FORM
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      #現行會計年度(aaa04)、現行期別(aaa05)
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
        FROM aaa_file WHERE aaa01 = g_bookno    #MOD-660034
 
      LET tm.yy = g_aaa04
      LET tm.mm = g_aaa05
      LET g_bgjob = 'N'
      INPUT BY NAME tm.yy,tm.mm,tm.axa01,tm.axa02,tm.axa03,tm.v_no,g_bgjob
            WITHOUT DEFAULTS
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN
               IF tm.mm < 0 OR tm.mm > 12  THEN
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm
               END IF
               LET tm.v_no=tm.yy USING '&&&&',tm.mm USING '&&','0001'  #FUN-930103 add
            END IF
 
         AFTER FIELD axa01   #族群代號
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-117","","",0)  #No.FUN-660123
                  NEXT FIELD axa01
               END IF
            END IF
 
         AFTER FIELD axa02   #上層公司編號
            IF NOT cl_null(tm.axa02) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-118","","",0)  #No.FUN-660123
                  NEXT FIELD axa02
               END IF
               SELECT DISTINCT axa03 INTO tm.axa03 FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               DISPLAY BY NAME tm.axa03
               SELECT axz03 INTO g_axz03 FROM axz_file                          
                 WHERE axz01 = tm.axa02                                         
               LET g_plant_new = g_axz03      #g^G^_i^A^Kd8-e?^C                
               CALL s_getdbs()                                                  
               LET g_dbs_axz03 = g_dbs_new #上層公司DB                          
              #LET g_sql = "SELECT * FROM ",g_dbs_axz03,"aaz_file",            #FUN-A50102
               LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102 
                           " WHERE aaz00 = '0'"                                 
	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE p006_pre_02 FROM g_sql                                   
               DECLARE p006_cur_02 CURSOR FOR p006_pre_02                       
               OPEN p006_cur_02                                                 
               FETCH p006_cur_02 INTO g_aaz.*                                 
 
              #LET g_sql = "SELECT count(*) FROM ",g_dbs_axz03,"npp_file ",  #FUN-A50102
               LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'npp_file'),  #FUN-A50102
                           "WHERE npp01  ='",tm.v_no,"'", 
                           "  AND nppsys = 'CD'", 
                           "  AND npp00  = 1",
                           "  AND npp011 = 1",
                           "  AND npptype= '0'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE p006_pre_07 FROM g_sql                                   
               DECLARE p006_cur_07 CURSOR FOR p006_pre_07                      
               OPEN p006_cur_07                                                 
               FETCH p006_cur_07 INTO l_cnt
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN   #若已存在則抓最大號碼+1
                  LET l_str = tm.v_no[1,6]
                 #LET g_sql = "SELECT MAX(npp01) FROM ",g_dbs_axz03,"npp_file", #FUN-A50102
                  LET g_sql = "SELECT MAX(npp01) FROM ",cl_get_target_table(g_plant_new,'npp_file'), #FUN-A50102  
                              "  WHERE npp01[1,6] = '",l_str,"'", 
                              "    AND nppsys = 'CD'", 
                              "    AND npp00  = 1",
                              "    AND npp011 = 1",
                              "    AND npptype= '0'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE p006_pre_08 FROM g_sql                                   
               DECLARE p006_cur_08 CURSOR FOR p006_pre_08                       
               OPEN p006_cur_08                                                 
               FETCH p006_cur_08 INTO l_max
               LET l_max = l_max+1
               LET tm.v_no = l_max USING '&&&&&&&&&&'
            END IF
            DISPLAY BY NAME tm.v_no 
            END IF
 
         AFTER FIELD axa03   #帳別
            IF NOT cl_null(tm.axa03) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
               IF l_cnt = 0  THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-118","","",0)  #No.FUN-660123
                  NEXT FIELD axa03
               END IF
            END IF
 
         AFTER FIELD v_no   # default value for v_no by yymmxxxx
            IF cl_null(tm.v_no) THEN
               NEXT FIELD FORMONLY.v_no 
            END IF
           #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_axz03,"npp_file",  #FUN-A50102
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'npp_file'),  #FUN-A50102 
                        " WHERE npp01 = '",tm.v_no,"'",
                        "   AND nppsys = 'CD'",
                        "   AND npp00 = '1'",
                        "   AND npp011 = '1'",
                        "  AND npptype = '0'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
            PREPARE p006_pre_09 FROM g_sql                                   
            DECLARE p006_cur_09 CURSOR FOR p006_pre_09                       
            OPEN p006_cur_09                                                 
            FETCH p006_cur_09 INTO l_cnt
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN 
               CALL cl_err(tm.v_no,'afa-368',0)
            END IF 
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
    
         ON ACTION CONTROLG
            call cl_cmdask()
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION locale
            LET g_change_lang = TRUE               #No.FUN-570144
            EXIT INPUT
   
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
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
         LET INT_FLAG = 0
         CLOSE WINDOW p006_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "aglp006"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp006','9031',1)  
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.axa01 CLIPPED,"'",
                         " '",tm.axa02 CLIPPED,"'",
                         " '",tm.axa03 CLIPPED,"'",
                         " '",tm.v_no  CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'"
            CALL cl_cmdat('aglp006',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p006_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
  
FUNCTION p006()
DEFINE #l_sql        LIKE type_file.chr1000,
       l_sql        STRING,     #NO.FUN-910082
       i,g_no       LIKE type_file.num5,
       l_date       LIKE type_file.dat,
       l_cnt        LIKE type_file.num5,
       g_dept       DYNAMIC ARRAY OF RECORD
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05,  #帳別
                    #axb13      LIKE axb_file.axb13,   #FUN-C50059 mark #長期投資科目  #FUN-780068 add 10/19
                     axbb10     LIKE axbb_file.axbb10, #FUN-C50059      #長期投資科目
                     axz03      LIKE axz_file.axz03    #下層公司營運中心  #FUN-920150
                    END RECORD
 
   CALL s_showmsg_init()                             #NO.FUN-710023
 
   #-->step 1 刪除資料
   CALL p006_del()
   IF g_success = 'N' THEN RETURN END IF
 
   #-->step 2 資料寫入
   #---->insert npp單頭
   LET g_npp.nppsys  = 'CD'
   LET g_npp.npp00   = 1  
   LET g_npp.npp011  = 1
   LET g_npp.npptype = '0'
   LET g_npp.npp01   = tm.v_no
   #LET npp02=畫面所設定期別的最後一天
   LET l_date = MDY(tm.mm,1,tm.yy)
   CALL s_last(l_date) RETURNING l_date
   LET g_npp.npp02   = l_date
   LET g_npp.npp03   = NULL
   SELECT axz03,axz05 INTO g_npp.npp06,g_npp.npp07 
    FROM axz_file                                                              
   WHERE axz01 = tm.axa02                         
   LET g_npp.nppglno = NULL
   LET g_npp.npplegal = g_legal #FUN-980003 jarlin add

  #LET g_sql =" INSERT INTO ",g_dbs_axz03,"npp_file",  #FUN-A50102
   LET g_sql =" INSERT INTO ",cl_get_target_table(g_plant_new,'npp_file'),   #FUN-A50102
              "(nppsys,npp00,npp01,npp011,npp02,npp03,npp04,npp05,npp06,npp07,",
              "nppglno,npptype,npplegal)",
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   CALL s_getlegal(g_axz03) RETURNING g_npp.npplegal
   PREPARE p006_ins_npp_p FROM g_sql
   IF STATUS THEN
      CALL cl_err('prepare:ins_npp',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXECUTE p006_ins_npp_p USING g_npp.nppsys,g_npp.npp00,g_npp.npp01,
                                g_npp.npp011,
                                g_npp.npp02,g_npp.npp03,g_npp.npp04,
                                g_npp.npp05,g_npp.npp06,g_npp.npp07,
                                g_npp.nppglno,g_npp.npptype,g_npp.npplegal

  #INSERT INTO npp_file VALUES(g_npp.*)  #FUN-D40105 mark
  #CHI-A70049---mark---satrt---
  #IF STATUS THEN
  #   DISPLAY "npp_file INSERT:",status
  #   LET g_success = 'N'
  #   RETURN
  #END IF
  #CHI-A70049---mark---end---
   IF g_bgjob = 'N' THEN  #NO.FUN-570144 
      MESSAGE g_npp.npp01
      CALL ui.Interface.refresh() 
   END IF
 
   CALL g_dept.clear()   #將g_dept清空
   CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING g_bdate,g_edate   #FUN-C50059
 
  #LET l_sql=" SELECT axa01,axa02,axa03,axb04,axb05,axb13",    #FUN-C50059 mark #FUN-780068 add axb13 10/19
  #          "   FROM axb_file,axa_file ",                     #FUN-C50059 mark
   LET l_sql=" SELECT axa01,axa02,axa03,axb04,axb05,axbb10",   #FUN-C50059
             "   FROM axb_file,axa_file,axbb_file ",           #FUN-C50059
             "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
             "    AND axb01=axbb01 AND axb02=axbb02 AND axb03=axbb03 ",   #FUN-C50059
             "    AND axb04=axbb04 AND axb05=axbb05 ",                    #FUN-C50059
             "    AND axa01='",tm.axa01,"' ",
             "    AND axa02='",tm.axa02,"' ",
             "    AND axa03='",tm.axa03,"' ",
             "    AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file ",      #FUN-C50059
             "                   WHERE axb01=axbb01 AND axb02=axbb02 AND axb03=axbb03 ",  #FUN-C50059
             "                     AND axb04=axbb04 AND axb05=axbb05 AND axbb06<'",g_edate,"')",#FUN-C50059
             "  ORDER BY axa01,axa02,axa03,axb04"
   PREPARE p006_axa_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:axa',STATUS,1)
      CALL cl_batch_bg_javamail('N')                 #FUN-57014
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE p006_axa_c CURSOR FOR p006_axa_p
 
   LET g_no = 1
   FOREACH p006_axa_c INTO g_dept[g_no].*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg(' ',' ','for_axa_c:',STATUS,1) #NO.FUN-710023
         LET g_success = 'N'
         RETURN
      END IF
      SELECT axz03 INTO g_dept[g_no].axz03
        FROM axz_file where axz01 = g_dept[g_no].axb04
      LET g_no=g_no+1
   END FOREACH
   CALL g_dept.deleteElement(g_no)
   LET g_no=g_no-1
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   FOR i =1 TO g_no
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
 
      #抓取上層公司記帳幣別
      SELECT axz06 INTO g_axz06 FROM axz_file where axz01 = tm.axa02
 
      #抓取子公司持股比率
      CALL get_rate(g_dept[i].axb04,g_dept[i].axb05)  
 
      ##長期投資認列包含子公司的淨利認列及關係人交易認列
 
      ##1.淨利認列
        ##借:長期投資
        ##       貸:投資收益
      CALL p006_process1(g_dept[i].*)
 
      ##2.關係人交易認列
        ##借:投資收益
        ##       貸:長期投資
      CALL p006_process2(g_dept[i].*)
   END FOR
 
   ###檢查是否有寫入單身，若沒有的話連單頭也要刪除
   LET l_cnt = 0

  #LET g_sql = "SELECT COUNT (*) FROM ",g_dbs_axz03,"npq_file ", #FUN-A50102
   LET g_sql = "SELECT COUNT (*) FROM ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
              #FUN-D40105--mark--str--
              #"WHERE npqsys = 'CD'",  
              #"AND npq00  = 1",
              #"AND npq011 = 1",
              #"AND npqtype= '0'",
              #"AND npq01  = '",tm.v_no,"'"
              #FUN-D40105--mark--str--
              #FUN-D40105--add--str--
               " WHERE npqsys = 'CD'",
               "   AND npq00  = 1",
               "   AND npq011 = 1",
               "   AND npqtype= '0'",
               "   AND npq01  = '",tm.v_no,"'"
              #FUN-D40105--add--end--
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE p006_pre_10 FROM g_sql                                   
   DECLARE p006_cur_10 CURSOR FOR p006_pre_10                      
   OPEN p006_cur_10                                                 
   FETCH p006_cur_10 INTO l_cnt
   IF l_cnt = 0 THEN
     #LET g_sql ="DELETE FROM ",g_dbs_axz03,"npp_file",   #FUN-A50102
      LET g_sql ="DELETE FROM ",cl_get_target_table(g_plant_new,'npp_file'),   #FUN-A50102
                #FUN-D40105--mark--str--
                #"WHERE nppsys = 'CD'",
                #"AND npp00  = 1",
                #"AND npp011 = 1",
                #"AND npptype= ? ",
                #"AND npp01  ='",tm.v_no,"'",
                #"AND (nppglno=' ' OR nppglno IS NULL)"
                #FUN-D40105--mark--str--
                #FUN-D40105--add--str--
                 " WHERE nppsys = 'CD' ",
                 "   AND npp00  = 1 ",
                 "   AND npp011 = 1 ",
                 "   AND npptype= ? ",
                 "   AND npp01  ='",tm.v_no,"'",
                 "   AND (nppglno=' ' OR nppglno IS NULL)"
                #FUN-D40105--add--end--
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE p006_del_p1 FROM g_sql
      IF STATUS THEN
         LET g_success='N'
         RETURN
      END IF
      EXECUTE p006_del_p1 USING '0'
   END IF
 
   ###寫入次帳別的分錄
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL p006_ins_bookno2()
   END IF
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   IF g_success="N" THEN
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p006_process1(g_dept)    #淨利認列
DEFINE g_dept        RECORD
                      axa01      LIKE axa_file.axa01,  #族群代號
                      axa02      LIKE axa_file.axa02,  #上層公司
                      axa03      LIKE axa_file.axa03,  #帳別
                      axb04      LIKE axb_file.axb04,  #下層公司
                      axb05      LIKE axb_file.axb05,  #帳別
                     #axb13  LIKE axb_file.axb13,   #FUN-C50059 mark #長期投資科目  #FUN-780068 add 10/19
                      axbb10 LIKE axbb_file.axbb10, #FUN-C50059      #長期投資科目
                      axz03      LIKE axz_file.axz03   #子公司營運中心 #FUN-920150
                     END RECORD,
       l_sql         STRING,
       l_axe04_102   LIKE axe_file.axe04,    #子公司本期損益科目
       l_axe11       LIKE axe_file.axe11,    #再衡量匯率類別
       l_axe12       LIKE axe_file.axe12,    #換算匯率類別
       l_cnt         LIKE type_file.num5,
       l_axz04       LIKE axz_file.axz04,    #使用tiptop否   
       l_axz06       LIKE axz_file.axz06,    #記帳幣別
       l_axz07       LIKE axz_file.axz07,    #功能幣別
       l_rate        LIKE axp_file.axp05,            
       l_rate1       LIKE axp_file.axp05,                
       l_amt         LIKE npq_file.npq07f,   #科目餘額
       l_amt_07f     LIKE npq_file.npq07f,   #科目餘額   #FUN-780068 add 10/19
       l_amt_07      LIKE npq_file.npq07,    #科目餘額   #FUN-780068 add 10/19
       l_aag371      LIKE aag_file.aag371,   #關係人異動碼輸入控制   #CHI-890015 add
       l_axz08       LIKE axz_file.axz08,    #關係人代號   #MOD-8C0270 add
       l_pmc903      LIKE pmc_file.pmc903    #MOD-B50055 add
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   ###以下層公司(axb04)的營運中心代碼(axz03)去抓所在的資料庫代碼(azp03)
   SELECT azp03 INTO g_dbs_new FROM azp_file
    WHERE azp01=(SELECT axz03 FROM axz_file WHERE axz01=g_dept.axb04)
   IF STATUS THEN LET g_dbs_new = NULL END IF
   IF NOT cl_null(g_dbs_new) THEN
      LET g_dbs_new=g_dbs_new CLIPPED,'.'
   END IF
   LET g_dbs_gl = g_dbs_new CLIPPED
   SELECT axz03 INTO g_plant_gl FROM axz_file WHERE axz01=g_dept.axb04  #FUN-A50102 
   LET l_amt_07f= 0   #FUN-780068 add 10/19
   LET l_amt_07 = 0   #FUN-780068 add 10/19
 
   #抓取子公司原始本期損益科目
   IF cl_null(g_aaz.aaz102) THEN RETURN END IF
   #因為對應的子公司原始科目有可能是多筆，因此要改成用FOREACH將資料一筆筆抓出來
   DECLARE p006_axe_cs CURSOR FOR
      SELECT axe04,axe11,axe12
        FROM axe_file
       WHERE axe01 = g_dept.axb04
         AND axe00 = g_dept.axb05
         AND axe13 = tm.axa01       #FUN-910001 add
         AND axe06 = g_aaz.aaz102
   FOREACH p006_axe_cs INTO l_axe04_102,l_axe11,l_axe12
      IF cl_null(l_axe04_102) THEN RETURN END IF
 
      #axz04(使用tiptop否),axz06(記帳幣別),axz07(功能幣別),axz08(關係人)
      SELECT axz04,axz06,axz07,axz08          #MOD-8C0270 add axz08
        INTO l_axz04,l_axz06,l_axz07,l_axz08  #MOD-8C0270 add l_axz08
        FROM axz_file
       WHERE axz01=g_dept.axb04
 
      SELECT axz03 INTO g_plant_new FROM axz_file     
       WHERE axz01 = g_dept.axb04 

      CALL s_getdbs()
      LET g_dbs_gl = g_dbs_new 
      LET g_plant_gl = g_plant_new   #FUN-A50102
      LET l_rate = 1
      LET l_rate1= 1
      #再衡量匯率
      CALL p006_getrate(l_axe11,tm.yy,tm.mm,l_axz06,l_axz07) RETURNING l_rate
      #換算匯率
      CALL p006_getrate(l_axe12,tm.yy,tm.mm,l_axz07,g_axz06) RETURNING l_rate1
 
      #-->check 是否有下層資料
      #   沒下層若為使用TIPTOP(axz04=Y)則抓aah_file(aah05-aah04)
      #           不使用TIPTOP(axz04=N)則抓axq_file(axq09-axq08)
      #   有下層                       則抓axh_file(axh09-axh08)
      SELECT COUNT(*) INTO l_cnt FROM axa_file
       WHERE axa01=g_dept.axa01
         AND axa02=g_dept.axb04
         AND axa03=g_dept.axb05
      IF l_cnt=0 OR
         (g_dept.axa02=g_dept.axb04 AND g_dept.axa03=g_dept.axb05)
      THEN     #無下層資料
         IF l_axz04='Y' THEN   #使用TIPTOP=>aah_file
            LET l_sql="SELECT SUM(aah05-aah04) ",
                     #FUN-A50102--mod--str--
                     #"  FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",
                      "  FROM ",cl_get_target_table(g_plant_gl,'aah_file'),",",
                      "       ",cl_get_target_table(g_plant_gl,'aag_file'),
                     #FUN-A50102--mod--end
                      " WHERE aah02 =",tm.yy,               #年度
                      "   AND aah03 =",tm.mm,               #期別
                      "   AND aah00 ='",g_dept.axb05,"' ",  #帳別
                      "   AND aah01 ='",l_axe04_102,"' ",   #科目
                      "   AND aah01 = aag01 ",
                      "   AND aah00 = aag00 ",
                      "   AND aag07 IN ('2','3')"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
            PREPARE p006_aah_p FROM l_sql
            IF STATUS THEN
               LET g_showmsg=tm.yy,"/",g_dept.axb05
               CALL s_errmsg('aah02,aah00',g_showmsg,'prepare:aah',STATUS,1)
               LET g_success='N'
            END IF
            DECLARE p006_aah_cs CURSOR FOR p006_aah_p
            OPEN p006_aah_cs
            FETCH p006_aah_cs INTO l_amt
            CLOSE p006_aah_cs
         ELSE                  #非使用TIPTOP=>axq_file
            LET l_sql="SELECT SUM(axq09-axq08) ",
                     #FUN-A50102--mod--str--
                     #"  FROM ",g_dbs_gl,"axq_file,",g_dbs_gl,"aag_file ",
                      "  FROM ",cl_get_target_table(g_plant_gl,'axq_file'),",",
                      "       ",cl_get_target_table(g_plant_gl,'aag_file'),
                     #FUN-A50102--mod--end
                      " WHERE axq06 =",tm.yy,               #年度
                      "   AND axq07 =",tm.mm,               #期別
                      "   AND axq05 ='",l_axe04_102,"' ",   #科目
                      "   AND axq05 = aag01 ",
                      "   AND axq00 = aag00 ",
                      "   AND aag07 IN ('2','3')"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
            PREPARE p006_axq_p FROM l_sql
            IF STATUS THEN
               LET g_showmsg=tm.yy,"/",g_dept.axb05
               CALL s_errmsg('axq06,axq00',g_showmsg,'prepare:axq',STATUS,1)
               LET g_success='N'
            END IF
            DECLARE p006_axq_cs CURSOR FOR p006_axq_p
            OPEN p006_axq_cs
            FETCH p006_axq_cs INTO l_amt
            CLOSE p006_axq_cs
         END IF
      ELSE     #有下層資料
         LET l_sql="SELECT SUM(axh09-axh08) ",
                  #FUN-A50102--mod--str--
                  #"  FROM ",g_dbs_axz03,"axh_file,",g_dbs_axz03,"aag_file ", #FUN-920150 mod
                   "  FROM ",cl_get_target_table(g_plant_new,'axh_file'),",",
                   "       ",cl_get_target_table(g_plant_new,'aag_file'),
                  #FUN-A50102--mod--end
                   " WHERE axh06 =",tm.yy,               #年度
                   "   AND axh07 =",tm.mm,               #期別
                   "   AND axh00 ='",g_dept.axb05,"' ",  #帳別
                   "   AND axh05 ='",l_axe04_102,"' ",   #科目
                   "   AND axh05 = aag01 ",
                   "   AND axh00 = aag00 ",
                   "   AND aag07 IN ('2','3')"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
         PREPARE p006_axh_p FROM l_sql
         IF STATUS THEN
            LET g_showmsg=tm.yy,"/",g_dept.axb05
            CALL s_errmsg('axh06,axh00',g_showmsg,'prepare:axh',STATUS,1)
            LET g_success='N'
         END IF
         DECLARE p006_axh_cs CURSOR FOR p006_axh_p
         OPEN p006_axh_cs
         FETCH p006_axh_cs INTO l_amt
         CLOSE p006_axh_cs
      END IF
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      #原幣金額 = 科目餘額 * 持股比率
      LET l_amt_07f= l_amt_07f+ l_amt * g_rate
      #本幣金額 = 原幣金額 * 再衡量匯率 * 換算匯率
      LET l_amt_07 = l_amt_07 + l_amt * g_rate * l_rate * l_rate1
      IF l_amt_07 < 0 THEN LET l_amt_07 = l_amt_07  * -1 END IF    #FUN-920150 add
      IF l_amt_07f < 0 THEN LET l_amt_07f = l_amt_07f * -1 END IF  #FUN-920150 add
   END FOREACH
   IF cl_null(l_amt_07f) AND cl_null(l_amt_07) THEN RETURN END IF
 
   INITIALIZE g_npq.* TO NULL   #CHI-890015 add
 
   #---->insert npq單身
   ##借方:長期投資
   LET g_npq.npqsys = 'CD'                        #系統別(CD)
   LET g_npq.npq00  = 1                           #類別(1)
   LET g_npq.npq011 = 1                           #異動序號
   LET g_npq.npqtype= '0'                         #分錄底稿類別
   LET g_npq.npq01  = tm.v_no                     #單號
   #LET g_sql = "SELECT MAX(npq02)+1 FROM ",g_dbs_axz03,"npq_file",  #FUN-A50102
   LET g_sql = "SELECT MAX(npq02)+1 FROM ",cl_get_target_table(g_plant_new,'npq_file'), #FUN-A50102
               " WHERE npqsys = 'CD'",
               "   AND npq00 = '1'",
               "   AND npq011 = '1'",
               "   AND npqtype = '0'",
               "   AND npq01 = '",tm.v_no,"'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE p006_count_p5 FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:count_p5',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE p006_count_c5 CURSOR FOR p006_count_p5
      OPEN p006_count_c5
      FETCH p006_count_c5 INTO g_npq.npq02
   IF cl_null(g_npq.npq02) THEN
      LET g_npq.npq02 = 1                         #項次
   END IF    #FUN-920150
   #長期投資科目的來源,改由抓取AGLI002的axb13(長期投資科目)
   #長期投資科目的來源,改由抓取AGLI0021的axbb10(長期投資科目)           #FUN-C50059
   IF l_amt < 0 THEN            
       LET g_npq.npq03 = g_aaz.aaz103      
   ELSE                                   
      #LET g_npq.npq03 = g_dept.axb13    #FUN-C50059 mark 
       LET g_npq.npq03 = g_dept.axbb10   #FUN-C50059 
   END IF    
   LET g_npq.npq04 = NULL                         #摘要
   LET g_npq.npq05 = NULL                         #部門
   LET g_npq.npq06 = '1'                          #借貸別
   #原幣金額 = 科目餘額 * 持股比率
   LET g_npq.npq07f= l_amt_07f                    #原幣金額  #FUN-780068      10/19
   CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
   IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
   #本幣金額 = 原幣金額 * 再衡量匯率 * 換算匯率
   LET g_npq.npq07 = l_amt_07                     #本幣金額  #FUN-780068      10/19
   CALL cl_digcut(g_npq.npq07 ,g_azi04) RETURNING g_npq.npq07
   IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07  = 0 END IF
   LET g_npq.npq08 = ' '   
   LET g_npq.npq11 = ''   #MOD-9A0005
   LET g_npq.npq12 = ''   #MOD-9A0005
   LET g_npq.npq13 = ''   #MOD-9A0005
   LET g_npq.npq14 = ''   #MOD-9A0005
   LET g_npq.npq15 = ' '
   LET g_npq.npq21 = ' ' 
   LET g_npq.npq22 = ' '
   LET g_npq.npq23 = NULL
   LET g_npq.npq24 = l_axz06                      #原幣幣別
   LET g_npq.npq25 = l_rate*l_rate1               #匯率
  #關係人異動碼輸入控制
   LET l_aag371 = ''
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01 = g_npq.npq03 AND aag00 = g_bookno
  #str MOD-B50055 add
   IF l_aag371 = '4' THEN
      LET l_pmc903=''
      SELECT pmc903 INTO l_pmc903 FROM pmc_file WHERE pmc01=l_axz08
      IF cl_null(l_pmc903) THEN
         SELECT occ37 INTO l_pmc903 FROM occ_file WHERE occ01==l_axz08
         IF cl_null(l_pmc903) THEN LET l_pmc903='N' END IF
      END IF
   END IF
  #end MOD-B50055 add
  #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
  #IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008                       #MOD-B50055 mark
   IF l_aag371 MATCHES '[23]' OR (l_aag371='4' AND l_pmc903='Y') THEN   #MOD-B50055
      LET g_npq.npq37 = l_axz08                   #異動碼-關係人   #MOD-8C0270
   END IF   #CHI-890015 add
 
   LET g_npq.npqlegal = g_legal #NO.FUN-980003 jarlin add
   IF g_npq.npq07<>0 THEN
     #LET g_sql = "INSERT INTO ",g_dbs_axz03,"npq_file", #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102 
                  "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,",
                  "npq06,npq07f,npq07,npq08,npq11,npq12,npq13,npq14,",
                  "npq15,npq21,npq22,npq23,npq24,npq25,npq26,npq27,",
                  "npq28,npq29,npq30,npq31,npq32,npq33,npq34,npq35,",
                  "npq36,npq37,npq930,npqtype,npqlegal)",
                  " VALUES(?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?)"
      IF g_bgjob = 'N' THEN
         MESSAGE g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
         CALL ui.Interface.refresh()
      END IF
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      CALL s_getlegal(g_axz03) RETURNING g_npq.npqlegal
      PREPARE p006_ins_npq_p1 FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:ins_npq_p1',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      EXECUTE p006_ins_npq_p1 USING g_npq.npqsys,g_npq.npq00,g_npq.npq01,
                                    g_npq.npq011,g_npq.npq02,g_npq.npq03,
                                    g_npq.npq04,g_npq.npq05,g_npq.npq06,
                                    g_npq.npq07f,g_npq.npq07,g_npq.npq08,
                                    g_npq.npq11,g_npq.npq12,g_npq.npq13,
                                    g_npq.npq14,g_npq.npq15,g_npq.npq21,
                                    g_npq.npq22,g_npq.npq23,g_npq.npq24,
                                    g_npq.npq25,g_npq.npq26,g_npq.npq27,
                                    g_npq.npq28,g_npq.npq29,g_npq.npq30,
                                    g_npq.npq31,g_npq.npq32,g_npq.npq33,
                                    g_npq.npq34,g_npq.npq35,g_npq.npq36,
                                    g_npq.npq37,g_npq.npq930,g_npq.npqtype,g_npq.npqlegal
      IF STATUS THEN
         LET g_showmsg=tm.v_no,"/",g_npq.npq03,"/",g_npq.npq07
         CALL s_errmsg('npq01,npq03,npq07',g_showmsg,'ins npq',STATUS,1)
         LET g_success='N'
      END IF
   END IF
 
   INITIALIZE g_npq.* TO NULL
 
   ##貸方:投資收益
   LET g_npq.npqsys = 'CD'                        #系統別(CD)
   LET g_npq.npq00  = 1                           #類別(1)
   LET g_npq.npq011 = 1                           #異動序號
   LET g_npq.npqtype= '0'                         #分錄底稿類別
   LET g_npq.npq01  = tm.v_no                     #單號
  #LET g_sql = "SELECT MAX(npq02)+1 FROM ",g_dbs_axz03,"npq_file",
   LET g_sql = "SELECT MAX(npq02)+1 FROM ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
               " WHERE npqsys = 'CD'",
               "   AND npq00 = '1'",
               "   AND npq011 = '1'",
               "   AND npqtype = '0'",
               "   AND npq01 = '",tm.v_no,"'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE p006_count_p3 FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:count_p3',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE p006_count_c3 CURSOR FOR p006_count_p3
      OPEN p006_count_c3
      FETCH p006_count_c3 INTO g_npq.npq02
   IF cl_null(g_npq.npq02) THEN
      LET g_npq.npq02 = 1                         #項次
   END IF

   IF l_amt < 0 THEN                    
      #LET g_npq.npq03 = g_dept.axb13    #FUN-C50059 mark 
       LET g_npq.npq03 = g_dept.axbb10   #FUN-C50059
   ELSE                                                                         
       LET g_npq.npq03 = g_aaz.aaz103                 #科目(貸:投資收益)        
   END IF                        
   LET g_npq.npq04 = NULL                         #摘要
   LET g_npq.npq05 = NULL                         #部門
   LET g_npq.npq06 = '2'                          #借貸別
   #原幣金額 = 科目餘額 * 持股比率
   LET g_npq.npq07f= l_amt_07f                    #原幣金額  #FUN-780068      10/19
   CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
   IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
   #本幣金額 = 原幣金額 * 再衡量匯率 * 換算匯率
   LET g_npq.npq07 = l_amt_07                     #本幣金額  #FUN-780068      10/19
   CALL cl_digcut(g_npq.npq07 ,g_azi04) RETURNING g_npq.npq07
   IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07  = 0 END IF
   LET g_npq.npq08 = ' '   
   LET g_npq.npq11 = ''   #MOD-9A0005
   LET g_npq.npq12 = ''   #MOD-9A0005
   LET g_npq.npq13 = ''   #MOD-9A0005
   LET g_npq.npq14 = ''   #MOD-9A0005
   LET g_npq.npq15 = ' '
   LET g_npq.npq21 = ' ' 
   LET g_npq.npq22 = ' '
   LET g_npq.npq23 = NULL
   LET g_npq.npq24 = l_axz06                      #原幣幣別
   LET g_npq.npq25 = l_rate*l_rate1               #匯率
  #關係人異動碼輸入控制
   LET l_aag371 = ''
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01 = g_npq.npq03 AND aag00 = g_bookno
  #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
   IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
      LET g_npq.npq37 = l_axz08                   #異動碼-關係人   #MOD-8C0270
   END IF   #CHI-890015 add
   LET g_npq.npqlegal = g_legal #FUN-980003 jarlin add
   IF g_npq.npq07<>0 THEN
     #LET g_sql = "INSERT INTO ",g_dbs_axz03,"npq_file", #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'), #FUN-A50102 
                  "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,",
                  "npq06,npq07f,npq07,npq08,npq11,npq12,npq13,npq14,",
                  "npq15,npq21,npq22,npq23,npq24,npq25,npq26,npq27,",
                  "npq28,npq29,npq30,npq31,npq32,npq33,npq34,npq35,",
                  "npq36,npq37,npq930,npqtype,npqlegal)",
                  " VALUES(?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?)"
      IF g_bgjob = 'N' THEN
         MESSAGE g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
         CALL ui.Interface.refresh()
      END IF
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      CALL s_getlegal(g_axz03) RETURNING g_npq.npqlegal
      PREPARE p006_ins_npq_p2 FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:ins_npq_p2',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      EXECUTE p006_ins_npq_p2 USING g_npq.npqsys,g_npq.npq00,g_npq.npq01,
                                    g_npq.npq011,g_npq.npq02,g_npq.npq03,
                                    g_npq.npq04,g_npq.npq05,g_npq.npq06,
                                    g_npq.npq07f,g_npq.npq07,g_npq.npq08,
                                    g_npq.npq11,g_npq.npq12,g_npq.npq13,
                                    g_npq.npq14,g_npq.npq15,g_npq.npq21,
                                    g_npq.npq22,g_npq.npq23,g_npq.npq24,
                                    g_npq.npq25,g_npq.npq26,g_npq.npq27,
                                    g_npq.npq28,g_npq.npq29,g_npq.npq30,
                                    g_npq.npq31,g_npq.npq32,g_npq.npq33,
                                    g_npq.npq34,g_npq.npq35,g_npq.npq36,
                                    g_npq.npq37,g_npq.npq930,g_npq.npqtype,g_npq.npqlegal
      IF STATUS THEN
         LET g_showmsg=tm.v_no,"/",g_npq.npq03,"/",g_npq.npq07
         CALL s_errmsg('npq01,npq03,npq07',g_showmsg,'ins npq',STATUS,1)
         LET g_success='N'
      END IF
   END IF
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021    
END FUNCTION
 
FUNCTION p006_process2(g_dept)    #關係人交易認列
DEFINE g_dept        RECORD
                      axa01      LIKE axa_file.axa01,  #族群代號
                      axa02      LIKE axa_file.axa02,  #上層公司
                      axa03      LIKE axa_file.axa03,  #帳別
                      axb04      LIKE axb_file.axb04,  #下層公司
                      axb05      LIKE axb_file.axb05,  #帳別
                     #axb13      LIKE axb_file.axb13,    #FUN-C50059 mark #長期投資科目  #FUN-780068 add 10/19
                      axbb10     LIKE axbb_file.axbb10,  #FUN-C50059      #長期投資科目
                      axz03      LIKE axz_file.axz03  #子公司營運中心 #FUN-920150
                     END RECORD,
       l_sql         STRING,
       l_axv05       LIKE axv_file.axv05,    #交易性質(1.順流 2.逆流 3.側流)
       l_axv07       LIKE axv_file.axv07,    #來源公司   #FUN-780068 add 10/19
       l_axv09       LIKE axv_file.axv09,    #帳列科目   #FUN-780068 add 10/19
       l_axv11       LIKE axv_file.axv11,    #來源幣別   #FUN-780068 add 10/19
       l_axv14       LIKE axv_file.axv14,    #未實現利益
       l_axv16       LIKE axv_file.axv16,    #分配未實現利益
       l_axe11       LIKE axe_file.axe11,    #再衡量匯率類別
       l_axe12       LIKE axe_file.axe12,    #換算匯率類別
       l_axz05       LIKE axz_file.axz05,    #帳別
       l_axz06       LIKE axz_file.axz06,    #記帳幣別
       l_axz07       LIKE axz_file.axz07,    #功能幣別
       l_rate        LIKE axp_file.axp05,
       l_rate1       LIKE axp_file.axp05,
       l_aag371      LIKE aag_file.aag371,   #關係人異動碼輸入控制   #CHI-890015 add
       l_axz08       LIKE axz_file.axz08     #關係人     #MOD-8C0270 add
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   LET l_sql = "SELECT axv05,axv07,axv09,axv11,SUM(axv14),SUM(axv16) ",   #FUN-780068 mod 10/19
               "  FROM axv_file",
               " WHERE axv01 = ",tm.yy,
               "   AND axv02 = ",tm.mm,
               "   AND axv03 ='",tm.axa01,"'",
               "   AND axv031='",tm.axa02,"'",
               "   AND (axv07='",g_dept.axb04,"' OR ",       
               "        axv08='",g_dept.axb04,"')",          
               " GROUP BY axv05,axv07,axv09,axv11",
               " ORDER BY axv05,axv07,axv09,axv11"   
   PREPARE p006_axv_p FROM l_sql
   IF STATUS THEN 
      CALL s_errmsg(' ',' ','prepare:axv',STATUS,1) 
      LET g_success='N'
      RETURN    
   END IF
   DECLARE p006_axv_cs CURSOR FOR p006_axv_p
 
   FOREACH p006_axv_cs INTO l_axv05,l_axv07,l_axv09,  #FUN-780068 mod 10/19
                            l_axv11,l_axv14,l_axv16   #FUN-780068 mod 10/19
      IF SQLCA.sqlcode THEN 
         EXIT FOREACH 
      END IF
      IF cl_null(l_axv14) THEN LET l_axv14 = 0 END IF
      IF cl_null(l_axv16) THEN LET l_axv16 = 0 END IF
 
      #不是"順流"的資料，表示幣別是子公司的幣別，需做匯率轉換
      IF l_axv05 != '1' THEN    
         #axz05(帳別),axz06(記帳幣別),axz07(功能幣別),axz08(關係人)
         SELECT axz05,axz06,axz07,axz08          #MOD-8C0270 add axz08
           INTO l_axz05,l_axz06,l_axz07,l_axz08  #MOD-8C0270 add l_axz08
           FROM axz_file
          WHERE axz01=l_axv07
 
         SELECT axe11,axe12 INTO l_axe11,l_axe12
           FROM axe_file
          WHERE axe01 = l_axv07
            AND axe00 = l_axz05
            AND axe06 = l_axv09
            AND axe13 = tm.axa01       #FUN-910001 add
 
         LET l_rate = 1
         LET l_rate1= 1
         #再衡量匯率
         CALL p006_getrate(l_axe11,tm.yy,tm.mm,l_axv11,l_axz07) RETURNING l_rate
         #換算匯率
         CALL p006_getrate(l_axe12,tm.yy,tm.mm,l_axv11,g_axz06) RETURNING l_rate1  #FUN-920150 mod
      ELSE
         LET l_axv11 = g_axz06   #FUN-780068 add 10/19
         LET l_rate = 1
         LET l_rate1= 1
      END IF
 
      INITIALIZE g_npq.* TO NULL   #CHI-890015 add
 
      #---->insert npq單身
      ##借方:投資收益
      LET g_npq.npqsys = 'CD'                        #系統別(CD)
      LET g_npq.npq00  = 1                           #類別(1)
      LET g_npq.npq011 = 1                           #異動序號
      LET g_npq.npqtype= '0'                         #分錄底稿類別
      LET g_npq.npq01  = tm.v_no                     #單號
     #LET g_sql = "SELECT MAX(npq02)+1  FROM ",g_dbs_axz03,"npq_file",   #FUN-A50102
      LET g_sql = "SELECT MAX(npq02)+1  FROM ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
                  " WHERE npqsys = 'CD'",
                  "   AND npq00 = '1'",
                  "   AND npq011 = '1'",
                  "   AND npqtype = '0'",
                  "   AND npq01 = '",tm.v_no,"'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE p006_count_p4 FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:count_p4',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE p006_count_c4 CURSOR FOR p006_count_p4
      OPEN p006_count_c4
      FETCH p006_count_c4 INTO g_npq.npq02
      IF cl_null(g_npq.npq02) THEN
         LET g_npq.npq02 = 1                         #項次
      END IF
      LET g_npq.npq04 = NULL                         #摘要
      LET g_npq.npq05 = NULL                         #部門
      LET g_npq.npq06 = '1'                          #借貸別
        IF l_axv05 = '1' THEN                          #順流
         IF l_axv16 > 0 THEN
            LET g_npq.npq07f = l_axv16       #原幣金額(分配未實現利益)
            LET g_npq.npq03 = g_aaz.aaz109   #科目(借:未實現銷貨利益)
         ELSE
            LET g_npq.npq07f = l_axv16
            LET g_npq.npq03 = g_aaz.aaz112
         END IF 
      ELSE
         LET g_npq.npq07f = l_axv16
         LET g_npq.npq03 = g_aaz.aaz103
       END IF
      CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
      #本幣金額 = 原幣金額 * 再衡量匯率 * 換算匯率
      LET g_npq.npq07 = g_npq.npq07f*l_rate*l_rate1  #本幣金額
      CALL cl_digcut(g_npq.npq07 ,g_azi04) RETURNING g_npq.npq07
      IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07  = 0 END IF
      LET g_npq.npq08 = ' '   
      LET g_npq.npq11 = ''   #MOD-9A0005
      LET g_npq.npq12 = ''   #MOD-9A0005
      LET g_npq.npq13 = ''   #MOD-9A0005
      LET g_npq.npq14 = ''   #MOD-9A0005
      LET g_npq.npq15 = ' '
      LET g_npq.npq21 = ' ' 
      LET g_npq.npq22 = ' '
      LET g_npq.npq23 = NULL
      LET g_npq.npq24 = l_axv11                      #原幣幣別
      LET g_npq.npq25 = l_rate*l_rate1               #匯率
     #關係人異動碼輸入控制
      LET l_aag371 = ''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01 = g_npq.npq03 AND aag00 = g_bookno
     #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
      IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
         LET g_npq.npq37 = l_axz08                   #異動碼-關係人   #MOD-8C0270
      END IF   #CHI-890015 add
      LET g_npq.npqlegal = g_legal #NO.FUN-980003 jarlin add
      IF g_npq.npq07<>0 THEN
     #LET g_sql = "INSERT INTO ",g_dbs_axz03,"npq_file",  #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
                  "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,",
                  "npq06,npq07f,npq07,npq08,npq11,npq12,npq13,npq14,",
                  "npq15,npq21,npq22,npq23,npq24,npq25,npq26,npq27,",
                  "npq28,npq29,npq30,npq31,npq32,npq33,npq34,npq35,",
                  "npq36,npq37,npq930,npqtype,npqlegal)",
                  " VALUES(?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?)"
         IF g_bgjob = 'N' THEN
            MESSAGE g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
            CALL ui.Interface.refresh()
         END IF
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
        CALL s_getlegal(g_axz03) RETURNING g_npq.npqlegal
         PREPARE p006_ins_npq_p3 FROM g_sql
         IF STATUS THEN
            CALL cl_err('prepare:ins_npq_p3',STATUS,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         EXECUTE p006_ins_npq_p3 USING g_npq.npqsys,g_npq.npq00,g_npq.npq01,
                                    g_npq.npq011,g_npq.npq02,g_npq.npq03,
                                    g_npq.npq04,g_npq.npq05,g_npq.npq06,
                                    g_npq.npq07f,g_npq.npq07,g_npq.npq08,
                                    g_npq.npq11,g_npq.npq12,g_npq.npq13,
                                    g_npq.npq14,g_npq.npq15,g_npq.npq21,
                                    g_npq.npq22,g_npq.npq23,g_npq.npq24,
                                    g_npq.npq25,g_npq.npq26,g_npq.npq27,
                                    g_npq.npq28,g_npq.npq29,g_npq.npq30,
                                    g_npq.npq31,g_npq.npq32,g_npq.npq33,
                                    g_npq.npq34,g_npq.npq35,g_npq.npq36,
                                    g_npq.npq37,g_npq.npq930,g_npq.npqtype
         IF STATUS THEN
            LET g_showmsg=tm.v_no,"/",g_npq.npq03,"/",g_npq.npq07
            CALL s_errmsg('npq01,npq03,npq07',g_showmsg,'ins npq',STATUS,1)
            LET g_success='N'
         END IF
      END IF
    
      INITIALIZE g_npq.* TO NULL
    
      ##貸方:長期投資
      LET g_npq.npqsys = 'CD'                        #系統別(CD)
      LET g_npq.npq00  = 1                           #類別(1)
      LET g_npq.npq011 = 1                           #異動序號
      LET g_npq.npqtype= '0'                         #分錄底稿類別
      LET g_npq.npq01  = tm.v_no                     #單號
     #LET g_sql = "SELECT MAX(npq02)+1 FROM ",g_dbs_axz03,"npq_file",  #FUN-A50102
      LET g_sql = "SELECT MAX(npq02)+1 FROM ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
                  " WHERE npqsys = 'CD'",
                  "   AND npq00 = '1'",
                  "   AND npq011 = '1'",
                  "   AND npqtype = '0'",
                  "   AND npq01 = '",tm.v_no,"'"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE p006_count_p FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:count_p',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE p006_count_c CURSOR FOR p006_count_p
      OPEN p006_count_c
      FETCH p006_count_c INTO g_npq.npq02
      IF cl_null(g_npq.npq02) THEN
         LET g_npq.npq02 = 1                         #項次
      END IF
     #長期投資科目的來源,改由抓取AGLI002的axb13(長期投資科目)
     #長期投資科目的來源,改由抓取AGLI0021的axbb10(長期投資科目)   #FUN-C50059
      LET g_npq.npq04 = NULL                         #摘要
      LET g_npq.npq05 = NULL                         #部門
      LET g_npq.npq06 = '2'                          #借貸別
      IF l_axv05 = '1' THEN                          #順流
          IF l_axv16 > 0 THEN     
             LET g_npq.npq07f = l_axv16      #原幣金額(分配未實現利益)
             LET g_npq.npq03 = g_aaz.aaz110  #科目(貨:遞延貨項)
          ELSE
             LET g_npq.npq07f = l_axv16
             LET g_npq.npq03 = g_aaz.aaz111
          END IF
      ELSE
          LET g_npq.npq07f = l_axv16
         #LET g_npq.npq03 = g_dept.axb13          #FUN-C50059 mark    #科目(貸:長期投資)  
          LET g_npq.npq03 = g_dept.axbb10         #FUN-C50059         #科目(貸:長期投資)  
      END IF
      CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
      #本幣金額 = 原幣金額 * 再衡量匯率 * 換算匯率
      LET g_npq.npq07 = g_npq.npq07f*l_rate*l_rate1  #本幣金額
      CALL cl_digcut(g_npq.npq07 ,g_azi04) RETURNING g_npq.npq07
      IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07  = 0 END IF
      LET g_npq.npq08 = ' '   
      LET g_npq.npq11 = ''   #MOD-9A0005
      LET g_npq.npq12 = ''   #MOD-9A0005
      LET g_npq.npq13 = ''   #MOD-9A0005
      LET g_npq.npq14 = ''   #MOD-9A0005
      LET g_npq.npq15 = ' '
      LET g_npq.npq21 = ' ' 
      LET g_npq.npq22 = ' '
      LET g_npq.npq23 = NULL
      LET g_npq.npq24 = l_axv11                      #原幣幣別
      LET g_npq.npq25 = l_rate*l_rate1               #匯率
     #關係人異動碼輸入控制
      LET l_aag371 = ''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01 = g_npq.npq03 AND aag00 = g_bookno
     #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
      IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
         LET g_npq.npq37 = l_axz08                   #異動碼-關係人   #MOD-8C0270
      END IF   #CHI-890015 add
      LET g_npq.npqlegal = g_legal #NO.FUN-980003 jarlin add
      IF g_npq.npq07<>0 THEN
     #LET g_sql = "INSERT INTO ",g_dbs_axz03,"npq_file",  #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102 
                  "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,",
                  "npq06,npq07f,npq07,npq08,npq11,npq12,npq13,npq14,",
                  "npq15,npq21,npq22,npq23,npq24,npq25,npq26,npq27,",
                  "npq28,npq29,npq30,npq31,npq32,npq33,npq34,npq35,",
                  "npq36,npq37,npq930,npqtype,npqlegal)",
                  " VALUES(?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?,?,?,?,",
                  "?,?,?,?,?,?,?)"
         IF g_bgjob = 'N' THEN
            MESSAGE g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
            CALL ui.Interface.refresh()
         END IF
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
        CALL s_getlegal(g_axz03) RETURNING g_npq.npqlegal
         PREPARE p006_ins_npq_p4 FROM g_sql
         IF STATUS THEN
            CALL cl_err('prepare:ins_npq_p4',STATUS,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         EXECUTE p006_ins_npq_p4 USING g_npq.npqsys,g_npq.npq00,g_npq.npq01,
                                       g_npq.npq011,g_npq.npq02,g_npq.npq03,
                                       g_npq.npq04,g_npq.npq05,g_npq.npq06,
                                       g_npq.npq07f,g_npq.npq07,g_npq.npq08,
                                       g_npq.npq11,g_npq.npq12,g_npq.npq13,
                                       g_npq.npq14,g_npq.npq15,g_npq.npq21,
                                       g_npq.npq22,g_npq.npq23,g_npq.npq24,
                                       g_npq.npq25,g_npq.npq26,g_npq.npq27,
                                       g_npq.npq28,g_npq.npq29,g_npq.npq30,
                                       g_npq.npq31,g_npq.npq32,g_npq.npq33,
                                       g_npq.npq34,g_npq.npq35,g_npq.npq36,
                                       g_npq.npq37,g_npq.npq930,g_npq.npqtype,g_npq.npqlegal
         IF STATUS THEN
            LET g_showmsg=tm.v_no,"/",g_npq.npq03,"/",g_npq.npq07
            CALL s_errmsg('npq01,npq03,npq07',g_showmsg,'ins npq',STATUS,1)
            LET g_success='N'
         END IF
      END IF
 
   END FOREACH
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
 
FUNCTION p006_del()
DEFINE l_sql   STRING
 
  #LET l_sql = "DELETE FROM ",g_dbs_axz03,"npp_file ",  #FUN-920150 mod #FUN-A50102
   LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'npp_file'),  #FUN-A50102 
               " WHERE npp01  = '",tm.v_no,"'",
               "   AND nppsys = 'CD'",
               "   AND npp00  = 1",
               "   AND npp011 = 1",
               "   AND npptype= ?",
               "   AND (nppglno=' ' OR nppglno IS NULL)"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
   PREPARE del_npp_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('del_npp_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
  #LET l_sql = "DELETE FROM ",g_dbs_axz03,"npq_file ",  #FUN-920150 mod   #FUN-A50102
   LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
               " WHERE npq01  = '",tm.v_no,"'",
               "   AND npqsys = 'CD'",
               "   AND npq00  = 1",
               "   AND npq011 = 1",
               "   AND npqtype= ?"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
   PREPARE del_npq_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('del_npq_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   #先將舊資料刪除再重新產生
   ##-->delete npp_file(分錄底稿單頭檔)
   EXECUTE del_npp_prep USING '0'
   IF STATUS THEN
      LET g_showmsg=tm.v_no,"/CD/0"
      CALL s_errmsg('npp01,nppsys,npptype',g_showmsg,'del npp',STATUS,1)
      LET g_success='N'
   END IF
 
   ##-->delete npq_file(分錄底稿單身檔)
   EXECUTE del_npq_prep USING '0'
   IF STATUS THEN
      LET g_showmsg=tm.v_no,"/CD/0"
      CALL s_errmsg('npq01,npqsys,npqtype',g_showmsg,'del npq',STATUS,1)
      LET g_success='N'
   END IF
 
   #若參數設定"使用多帳別功能"(aza63=Y),則需連次帳別資料一併刪除
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      ##-->delete npp_file(分錄底稿單頭檔)
      EXECUTE del_npp_prep USING '1'
      IF STATUS THEN
         LET g_showmsg=tm.v_no,"/CD/1"
         CALL s_errmsg('npp01,nppsys,npptype',g_showmsg,'del npp',STATUS,1)
         LET g_success='N'
      END IF
 
      ##-->delete npq_file(分錄底稿單身檔)
      EXECUTE del_npq_prep USING '1'
      IF STATUS THEN
         LET g_showmsg=tm.v_no,"/CD/1"
         CALL s_errmsg('npq01,npqsys,npqtype',g_showmsg,'del npq',STATUS,1)
         LET g_success='N'
      END IF
   END IF
 
   #FUN-B40056--add--str--
   LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
               " WHERE tic04  = '",tm.v_no,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  
   PREPARE del_tic_prep FROM l_sql
   EXECUTE del_tic_prep
   IF STATUS THEN
      LET g_showmsg=tm.v_no,"/CD/0"
      CALL s_errmsg('npq01,npqsys,npqtype',g_showmsg,'del tic',STATUS,1)
      LET g_success='N'
   END IF
   #FUN-B40056--add--end--
 
END FUNCTION
 
FUNCTION p006_ins_bookno2()   #寫入次帳別的分錄
DEFINE l_npp RECORD LIKE npp_file.*   #FUN-920150 
DEFINE l_npq RECORD LIKE npq_file.*   #FUN-920150 
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
  #LET g_sql = "SELECT * FROM ",g_dbs_axz03, "npp_file",  #FUN-A50102
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'npp_file'),  #FUN-A50102 
              " WHERE npp01 = '",tm.v_no,"'", 
              "   AND nppsys = 'CD'", 
              "   AND npp00  = 1",
              "   AND npp011 = 1",
              "   AND npptype= '0'"          #0.主帳別

	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE p006_ins_book2_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('prepare:ins_book2',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p006_ins_book2_c1 CURSOR FOR p006_ins_book2_p1
   FOREACH p006_ins_book2_c1  INTO l_npp.*
      IF SQLCA.sqlcode THEN
         LET g_showmsg=tm.v_no,"/CD/1"
         CALL s_errmsg('npq01,npqsys,npqtype',g_showmsg,'sel npq',STATUS,1)
         LET g_success='N'
      END IF
      LET l_npp.npptype = '1'
     #LET g_sql = "INSERT INTO ",g_dbs_axz03,"npq_file", #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102 
                   "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,",
                   "npq06,npq07f,npq07,npq08,npq11,npq12,npq13,npq14,",
                   "npq15,npq21,npq22,npq23,npq24,npq25,npq26,npq27,",
                   "npq28,npq29,npq30,npq31,npq32,npq33,npq34,npq35,",
                   "npq36,npq37,npq930,npqtype,npqlegal)",
                   " VALUES(?,?,?,?,?,?,?,?,?,?,",
                   "?,?,?,?,?,?,?,?,?,?,",
                   "?,?,?,?,?,?,?,?,?,?,",
                   "?,?,?,?,?,?,?)"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       CALL s_getlegal(g_axz03) RETURNING l_npq.npqlegal
       PREPARE p006_ins_book2_npp1 FROM g_sql
       IF STATUS THEN
          CALL cl_err('prepare:ins_book2_npp1',STATUS,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
      #FUN-D40118 ---Add--- Start
       SELECT aag44 INTO l_aag44 FROM aag_file
        WHERE aag00 = g_bookno
          AND aag01 = g_npq.npq03
       IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
          CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET g_npq.npq03 = ''
          END IF
       END IF
      #FUN-D40118 ---Add--- End
       EXECUTE p006_ins_book2_npp1 USING l_npq.npqsys,l_npq.npq00,l_npq.npq01,
                                    l_npq.npq011,l_npq.npq02,l_npq.npq03,
                                    l_npq.npq04,l_npq.npq05,l_npq.npq06,
                                    l_npq.npq07f,l_npq.npq07,l_npq.npq08,
                                    l_npq.npq11,l_npq.npq12,l_npq.npq13,
                                    l_npq.npq14,l_npq.npq15,l_npq.npq21,
                                    l_npq.npq22,l_npq.npq23,l_npq.npq24,
                                    l_npq.npq25,l_npq.npq26,l_npq.npq27,
                                    l_npq.npq28,l_npq.npq29,l_npq.npq30,
                                    l_npq.npq31,l_npq.npq32,l_npq.npq33,
                                    l_npq.npq34,l_npq.npq35,l_npq.npq36,
                                    l_npq.npq37,l_npq.npq930,l_npq.npqtype,l_npq.npqlegal
     IF SQLCA.sqlcode THEN
        LET g_showmsg=tm.v_no,"/CD/1"
        CALL s_errmsg('npq01,npqsys,npqtype',g_showmsg,'ins npq_file',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
   END FOREACH     #FUN-920150 
 
END FUNCTION
 
FUNCTION get_rate(p_axb04,p_axb05)    #持股比率
DEFINE p_axb04    LIKE axb_file.axb04,
       p_axb05    LIKE axb_file.axb05,
      #l_axb07    LIKE axb_file.axb07,    #FUN-C50059 mark
      #l_axb08    LIKE axb_file.axb08,    #FUN-C50059 mark
       l_axbb07   LIKE axbb_file.axbb07,  #FUN-C50059
       l_axbb06   LIKE axbb_file.axbb06,  #FUN-C50059
       l_axd07b   LIKE axd_file.axd07b,
       l_axd08b   LIKE axd_file.axd08b,
       l_count    LIKE type_file.num5,
       l_sql      LIKE type_file.chr1000
 
    CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING g_bdate,g_edate
   #FUN-C50059--mark--
   #SELECT axb07,axb08 INTO l_axb07,l_axb08 
   #  FROM axb_file 
   # WHERE axb01=tm.axa01 
   #   AND axb02=tm.axa02 
   #   AND axb03=tm.axa03
   #   AND axb04=p_axb04      #下層公司
   #   AND axb05=p_axb05      #下層帳號
   #FUN-C50059--mark--
   #FUN-C50059--
    SELECT axbb07,axbb06 INTO l_axbb07,l_axbb06 
      FROM axbb_file 
     WHERE axbb01=tm.axa01 
       AND axbb02=tm.axa02 
       AND axbb03=tm.axa03
       AND axbb04=p_axb04      #下層公司
       AND axbb05=p_axb05      #下層帳號
       AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                      WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=tm.axa03
                        AND axbb04 =p_axb04 AND axbb05 =p_axb05 AND axbb06<g_edate) 
   #FUN-C50059--
    IF STATUS THEN LET g_rate=0 RETURN END IF
   #FUN-C50059--mark--
   #IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN 
   #   LET g_rate=l_axb07/100 
   #FUN-C50059--mark--
   #FUN-C50059--
    IF g_edate >= l_axbb06 OR cl_null(l_axbb06) THEN 
       LET g_rate=l_axbb07/100 
   #FUN-C50059--
       RETURN 
    END IF
    
    LET l_count=0
    LET g_rate =0
    LET l_sql = "SELECT axd07b,axd08b ",
                "  FROM axd_file",
                " WHERE axd01 ='",tm.axa01,"'",
                "   AND axd02 ='",tm.axa02,"'",
                "   AND axd03 ='",tm.axa03,"'",
                "   AND axd04a='",p_axb04,"'",
                "   AND axd05a='",p_axb05,"'"
    PREPARE p006_axd_p FROM l_sql
    IF STATUS THEN 
       CALL s_errmsg(' ',' ','prepare:axd',STATUS,1) 
       LET g_success = 'N'  
       RETURN    
    END IF
    DECLARE p006_axd_c CURSOR FOR p006_axd_p
 
    FOREACH p006_axd_c INTO l_axd07b,l_axd08b
       IF SQLCA.sqlcode THEN 
          LET g_rate=0 
          EXIT FOREACH 
       END IF
       LET l_count=l_count+1
       IF g_edate>=l_axd08b THEN 
          LET g_rate=l_axd07b/100
          EXIT FOREACH 
       END IF
    END FOREACH       
    IF l_count=0 THEN LET g_rate=0 RETURN END IF
END FUNCTION
 
FUNCTION p006_getrate(l_value,l_axp01,l_axp02,l_axp03,l_axp04)
DEFINE l_value LIKE axe_file.axe11,
       l_axp01 LIKE axp_file.axp01,
       l_axp02 LIKE axp_file.axp02,
       l_axp03 LIKE axp_file.axp03,
       l_axp04 LIKE axp_file.axp04,
       l_axp05 LIKE axp_file.axp05,
       l_axp06 LIKE axp_file.axp06,
       l_axp07 LIKE axp_file.axp07,
       l_rate  LIKE axp_file.axp05
 
   SELECT axp05,axp06,axp07
     INTO l_axp05,l_axp06,l_axp07
     FROM axp_file
    WHERE axp01=l_axp01
      AND axp02=(SELECT max(axp02) FROM axp_file
                  WHERE axp01 = l_axp01
                    AND axp02 <=l_axp02
                    AND axp03 = l_axp03
                    AND axp04 = l_axp04)
      AND axp03=l_axp03
      AND axp04=l_axp04
 
   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_axp05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_axp06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_axp07
      OTHERWISE
         LET l_rate=1
   END CASE
 
   IF l_rate = 0 OR cl_null(l_rate) THEN LET l_rate = 1 END IF
 
   RETURN l_rate
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

