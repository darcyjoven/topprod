# Prog. Version..: '5.30.08-13.07.05(00010)'     #
#
# Pattern name...: gxrp620.4gl
# Descriptions...: 月底重評價傳票拋轉還原作業
# Date & Author..: 02/03/18 By Danny
# Modify.........: No.MOD-510037 05/01/19 By kitty 傳票拋轉還原作錯支程式,但傳票還是會被作廢或刪除
# Modify.........: No.MOD-590096 05/09/07 By wujie 傳票號碼加大到16碼
# Modify.........: MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: No.FUN-570126 06/03/03 By saki 批次背景執行
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-670047 06/08/16 By Ray 多帳套修改
# Modify.........: No.FUN-680145 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.MOD-7A0113 07/10/22 By Smapmin 若總帳參數設為傳票拋轉還原時傳票為作廢狀態,應該要保留成作廢狀態.
# Modify.........: No.MOD-920020 09/02/02 By chenyu 關帳日期要根據不同來源碼選不同的參數的關帳日期
# Modify.........: No.FUN-980011 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/08/31 By douzh GP5.2架構重整，修改sub相關傳參
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A20014 10/02/22 By sabrina 送簽中或已核准不可還原
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70049 10/07/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.MOD-CB0129 12/11/14 By wujie 画面增加开窗功能
# Modify.........: No:FUN-D40107 13/05/30 By zhangweib 有傳參時,憑證編號不給默認值
# Modify.........: No.FUN-D60110 13/08/25 by yangtt 憑證編號開窗可多選
# modify.........:               15/02/06 by donghy 抛转还原的sql有个bug-已修正
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號
#                                                  2.拋轉還原時多控卡不允許刪除不同來源碼的傳票
# Modify.........: No:MOD-E50017 14/05/06 By yihsuan 相關 cl_replace_str 調整為實際對應 table 

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global" 
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21    #NO.FUN-680145 VARCHAR(21)
DEFINE p_plant          LIKE ooz_file.ooz02p    #NO.FUN-680145 VARCHAR(12)
DEFINE p_acc            LIKE aaa_file.aaa01     #NO.FUN-670003
DEFINE p_acc1           LIKE aaa_file.aaa01     #NO.FUN-670047
DEFINE gl_date		LIKE type_file.dat      #NO.FUN-680145 DATE
DEFINE gl_yy,gl_mm	LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE g_existno	LIKE npp_file.nppglno   #NO.FUN-680145 VARCHAR(16)	        #No.MOD-590096
DEFINE g_existno1	LIKE npp_file.nppglno   #NO.FUN-680145 VARCHAR(16)	        #No.FUN-670047
DEFINE g_str 		LIKE type_file.chr3     #NO.FUN-680145 VARCHAR(3)
DEFINE g_mxno		LIKE type_file.chr8     #NO.FUN-680145 VARCHAR(8)
 
DEFINE   g_cnt          LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(72)
         g_flag         LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)           #No.FUN-570126
         g_change_lang  LIKE type_file.chr1     # Prog. Version..: '5.30.08-13.07.05(01)          #No.FUN-570126
DEFINE g_aaz84          LIKE aaz_file.aaz84 #還原方式 1.刪除 2.作廢    #MOD-7A0113   
#No.FUN-D60110 ---Add--- Start
DEFINE g_existno_str     STRING
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING
DEFINE tm   RECORD
            wc1         STRING,
            wc2         STRING
            END RECORD
#No.FUN-D60110 ---Add--- End
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0099
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570126 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant     = ARG_VAL(1)
   LET p_acc   = ARG_VAL(2)
   LET g_existno    = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570126 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CGXR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   #->No.FUN-570126 --start--
   #OPEN WINDOW p620 AT p_row,p_col
   #     WITH FORM "gxr/42f/gxrp620"
   #      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   #CALL cl_ui_init()
 
   #CALL cl_opmsg('z')
   #CALL p620()
   #IF INT_FLAG
   #   THEN LET INT_FLAG = 0
   #   ELSE CALL cl_end(18,20)
   #END IF
   #CLOSE WINDOW p620
 
   LET g_success = 'Y'
   WHILE TRUE
      CALL s_showmsg_init()   #No.FUN-D60110   Add
      IF g_bgjob = "N" THEN
         CALL p620_ask()
         #FUN-D60110 ---Add--- Start
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         #FUN-D60110 ---Add--- End
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            #FUN-D60110 ---Add--- Start
            CALL p620_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D60110 ---Add--- End
            CALL p620()
            IF g_success = 'Y' THEN
               COMMIT WORK
               LET g_existno = NULL    #No.FUN-D40107   Add
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               LET g_existno = NULL    #No.FUN-D40107   Add
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p620_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #No.FUN-D60110 Add
         CALL p620_existno_chk()                        #No.FUN-D60110 Add
         BEGIN WORK
         LET g_success = 'Y'
         CALL p620()
          IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570126 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
END MAIN
 
FUNCTION p620()
# 得出總帳 database name
# g_ooz.ooz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
   #No.FUN-570126 --start--
#  CALL p620_ask()
#  IF INT_FLAG THEN RETURN END IF
#  IF NOT cl_sure(20,20) THEN LET INT_FLAG = 1 RETURN END IF
#  CALL cl_wait()
   IF g_bgjob = "N" THEN
      OPEN WINDOW p620_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS
   END IF
   #No.FUN-570126 ---end---
   LET g_success = 'Y'
   LET g_plant_new=p_plant
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
#  BEGIN WORK                     #No.FUN-570126
   #-----MOD-7A0113---------
   #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE aaz84_pre FROM g_sql
   DECLARE aaz84_cs CURSOR FOR aaz84_pre
   OPEN aaz84_cs 
   FETCH aaz84_cs INTO g_aaz84
   IF STATUS THEN 
     #No.FUN-D60110 ---Mod--- Start
     #CALL cl_err('sel aaz84',STATUS,1)   
     #CLOSE WINDOW p620_t_w9
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     #EXIT PROGRAM
      LET g_success = 'N'
      CALL s_errmsg('sel aaz84','','',STATUS,1)
      RETURN
     #No.FUN-D60110 ---Mod--- End
   END IF
   #-----END MOD-7A0113-----
   CALL p620_t()
   #No.FUN-670047 --begin
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL p620_t_1()
   END IF
   LET p_acc1 = g_ooz.ooz02c
   #No.FUN-670047 --end
 
#  IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF   #No.FUN-570126
   IF g_bgjob = "N" THEN          #No.FUN-570126
      ERROR ""
      CLOSE WINDOW p620_t_w9
   END IF                         #No.FUN-570126
END FUNCTION
 
FUNCTION p620_ask()
   DEFINE   li_chk_bookno      LIKE type_file.num5     #NO.FUN-680145 SMALLINT   #No.FUN-670003
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
   DEFINE   l_aaa07            LIKE aaa_file.aaa07
   DEFINE   l_aba00            LIKE aba_file.aba00
   DEFINE   l_aba06            LIKE aba_file.aba06     #No.MOD-920020 add
   DEFINE   l_date             LIKE nmz_file.nmz10     #No.MOD-920020 add
   DEFINE   l_npp07            LIKE npp_file.npp07     #No.FUN-670047
   DEFINE   l_nppglno          LIKE npp_file.nppglno   #No.FUN-670047
   DEFINE   l_conf   	       LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
   DEFINE   lc_cmd             LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(500)            #No.FUN-570126
   DEFINE   p_row,p_col        LIKE type_file.num5,    #NO.FUN-680145 SMALLINT             #No.FUN-570126
            l_sql              STRING                  #No.FUN-670003  -add
   DEFINE   l_aba20            LIKE aba_file.aba20     #CHI-A20014 add
 
 
   #No.FUN-570126 --start--
   LET p_row = 5 LET p_col = 28
   OPEN WINDOW p620_w AT p_row,p_col WITH FORM "gxr/42f/gxrp620"
       ATTRIBUTE (STYLE = g_win_style)
    CALL cl_ui_init()
    CALL cl_opmsg('z')
   #No.FUN-570126 ---end---
    #No.FUN-670047 --begin
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("p_acc1,g_existno1",TRUE)
    ELSE
       CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)
    END IF
    #No.FUN-670047 --end
 
   LET p_plant = g_ooz.ooz02p
   LET p_acc   = g_ooz.ooz02b
  #LET g_existno = NULL         #No.FUN-D40107   Mark
   LET g_bgjob = "N"            #No.FUN-570126
 
   WHILE TRUE                   #No.FUN-570126
      DIALOG ATTRIBUTES(UNBUFFERED)  #No.FUN-D60110 Add
     #INPUT BY NAME p_plant,p_acc,g_existno,g_bgjob WITHOUT DEFAULTS    #No.FUN-570126   #No.FUN-D60110   Mark
      INPUT BY NAME p_plant,p_acc ATTRIBUTE(WITHOUT DEFAULTS=TRUE)      #No.FUN-D60110   Add
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        #No.FUN-D60110 ---Mark--- Start
        #ON ACTION locale
        #   #No.FUN-570126 --start--
#       #   CALL cl_dynamic_locale()
#       #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        #   LET g_change_lang = TRUE
        #   EXIT INPUT
        #   #No.FUN-570126 ---end---
        #No.FUN-D60110 ---Mark--- End
 
         AFTER FIELD p_plant
            SELECT azp01 FROM azp_file WHERE azp01 = p_plant
            IF STATUS THEN
               NEXT FIELD p_plant
            END IF
            LET g_plant_new=p_plant
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new
 
         AFTER FIELD p_acc
            IF p_acc IS NULL THEN
               NEXT FIELD p_acc
            END IF
            LET g_ooz.ooz02b = p_acc
            #No.FUN-670003--begin                                               
             CALL s_check_bookno(p_acc,g_user,p_plant)                          
                  RETURNING li_chk_bookno                                       
             IF (NOT li_chk_bookno) THEN                                        
                NEXT FIELD p_acc                                                
             END IF 
             LET g_plant_new= p_plant  # 工廠編號                                                                              
             CALL s_getdbs()                                                                                                    
             LET l_sql = "SELECT COUNT(*) ",                                                                                    
                         #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                         "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102                         
                         " WHERE aaa01 = '",p_acc,"' "                                                                          
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
             PREPARE p620_pre5 FROM l_sql                                                                                       
             DECLARE p620_cur5 CURSOR FOR p620_pre5                                                                             
             OPEN p620_cur5                                                                                                     
             FETCH p620_cur5 INTO g_cnt                                                            
#            SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=p_acc
           #No.FUN-670003--end
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_acc
            END IF

        #No.FUN-D60110 ---Mark--- Start
        #AFTER FIELD g_existno
        #   IF cl_null(g_existno) THEN
        #      NEXT FIELD g_existno
        #   END IF
        #  #LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost FROM ",        #No.MOD-920020 mark
        #   LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,aba06,aba20 FROM ",  #No.MOD-920020 add   #CHI-A20014 add aba20
        #              #g_dbs_gl CLIPPED,"aba_file",
        #              cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
        #             " WHERE aba01 = ? AND aba00 = ? "
        #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102          
        #   PREPARE p620_t_p1 FROM g_sql
        #   DECLARE p620_t_c1 CURSOR FOR p620_t_p1
        #   IF STATUS THEN
        #      CALL cl_err('decl aba_cursor:',STATUS,0)
        #      NEXT FIELD g_existno
        #   END IF
        #   OPEN p620_t_c1 USING g_existno,g_ooz.ooz02b
        #  #FETCH p620_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost          #No.MOD-920020 mark
        #   FETCH p620_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,l_aba06,l_aba20  #No.MOD-920020 add   #CHI-A20014 l_aba20
        #   IF STATUS THEN
        #      CALL cl_err('sel aba:',STATUS,0)
        #      NEXT FIELD g_existno
        #   END IF
        #  #CHI-A20014---add---start---
        #   IF l_aba20 MATCHES '[Ss1]' THEN
        #      CALL cl_err(g_existno,'mfg3557',0)
        #      NEXT FIELD g_existno
        #   END IF
        #  #CHI-A20014---add---end---
        #   #---增加判斷會計帳別之關帳日期
        #   #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl CLIPPED,"aaa_file", " WHERE aaa01='",l_aba00,"'"
        #   LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
        #             " WHERE aaa01='",l_aba00,"'"
        #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #   PREPARE p620_x_gl_p1 FROM g_sql
        #   DECLARE p620_c_gl_p1 CURSOR FOR p620_x_gl_p1
        #   OPEN p620_c_gl_p1
        #   FETCH p620_c_gl_p1 INTO l_aaa07
        #   IF gl_date < l_aaa07 THEN
        #      CALL cl_err(gl_date,'agl-200',0)
        #      NEXT FIELD g_existno
        #   END IF
        #   #------ end -------------------
        #   IF l_abapost = 'Y' THEN
        #      CALL cl_err(g_existno,'aap-130',0)
        #      NEXT FIELD g_existno
        #   END IF
        #   IF l_conf ='Y' THEN
        #      CALL cl_err(g_existno,'aap-026',0)
        #      NEXT FIELD g_existno
        #   END IF
        #  #No.MOD-920020 modify --begin
        #  #IF gl_date < g_sma.sma53 THEN
        #  #   CALL cl_err(gl_date,'aap-027',0)
        #  #   NEXT FIELD g_existno
        #  #END IF
        #   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
        #   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
        #   CASE l_aba06
        #      WHEN 'AR'  LET l_date = g_ooz.ooz09
        #      WHEN 'AP'  LET l_date = g_apz.apz57
        #      WHEN 'NM'  LET l_date = g_nmz.nmz10
        #      OTHERWISE  LET l_date = g_sma.sma53
        #   END CASE
        #   IF gl_date < l_date THEN
        #      CALL cl_err(gl_date,'aap-027',0)
        #      NEXT FIELD g_existno
        #   END IF
        #  #No.MOD-920020 modify --end
        #   #No.FUN-670047 --begin
        #   IF g_aza.aza63 = 'Y' THEN
        #      SELECT unique npp07,nppglno INTO l_npp07,l_nppglno FROM npp_file
        #       WHERE npp01 IN (SELECT npp01 FROM npp_file
        #                        WHERE npp07 = p_acc
        #                          AND nppglno = g_existno
        #                          AND npptype = '0')
        #         AND npptype = '1'
        #      IF STATUS THEN
        #         CALL cl_err3("sel","npp_file","","","axr-800","","",1)
        #         RETURN
        #      END IF
        #      DISPLAY l_npp07 TO FORMONLY.p_acc1
        #      DISPLAY l_nppglno TO FORMONLY.g_existno1
        #      LET g_ooz.ooz02c = l_npp07
        #      LET p_acc1= l_npp07
        #      LET g_existno1 = l_nppglno
        #
        #     #LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost FROM ",        #No.MOD-920020 mark
        #      LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,aba06,aba20 FROM ",  #No.MOD-920020 add  #CHI-A20014 add aba20
        #                 #g_dbs_gl CLIPPED,"aba_file",
        #                 cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
        #                " WHERE aba01 = ? AND aba00 = ? "
        #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		    #  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102           
        #      PREPARE p620_t_p2 FROM g_sql
        #      DECLARE p620_t_c2 CURSOR FOR p620_t_p2
        #      IF STATUS THEN
        #         CALL cl_err('decl aba_cursor:',STATUS,0)
        #         NEXT FIELD g_existno
        #      END IF
        #      OPEN p620_t_c2 USING g_existno1,g_ooz.ooz02c
        #     #FETCH p620_t_c2 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost          #No.MOD-920020 mark
        #      FETCH p620_t_c2 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,l_aba06,l_aba20  #No.MOD-920020 add   #CHI-A20014 add l_aba20
        #      IF STATUS THEN
        #         CALL cl_err('sel aba:',STATUS,0)
        #         NEXT FIELD g_existno
        #      END IF
        #     #CHI-A20014---add---start---
        #      IF l_aba20 MATCHES '[Ss1]' THEN
        #         CALL cl_err(g_existno,'mfg3557',0)
        #         NEXT FIELD g_existno
        #      END IF
        #     #CHI-A20014---add---end---
        #      #---增加判斷會計帳別之關帳日期
        #      #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl CLIPPED,"aaa_file", " WHERE aaa01='",l_aba00,"'"
        #      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
        #                " WHERE aaa01='",l_aba00,"'"
 	      #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #      PREPARE p620_x_gl_p2 FROM g_sql
        #      DECLARE p620_c_gl_p2 CURSOR FOR p620_x_gl_p2
        #      OPEN p620_c_gl_p2
        #      FETCH p620_c_gl_p2 INTO l_aaa07
        #      IF gl_date < l_aaa07 THEN
        #         CALL cl_err(gl_date,'agl-200',0)
        #         NEXT FIELD g_existno
        #      END IF
        #      #------ end -------------------
        #      IF l_abapost = 'Y' THEN
        #         CALL cl_err(g_existno1,'aap-130',0)
        #         NEXT FIELD g_existno
        #      END IF
        #      IF l_conf ='Y' THEN
        #         CALL cl_err(g_existno1,'aap-026',0)
        #         NEXT FIELD g_existno
        #      END IF
        #     #No.MOD-920020 modify --begin
        #     #IF gl_date < g_sma.sma53 THEN
        #     #   CALL cl_err(gl_date,'aap-027',0)
        #     #   NEXT FIELD g_existno
        #     #END IF
        #      CASE l_aba06
        #         WHEN 'AR'  LET l_date = g_ooz.ooz09
        #         WHEN 'AP'  LET l_date = g_apz.apz57
        #         WHEN 'NM'  LET l_date = g_nmz.nmz10
        #         OTHERWISE  LET l_date = g_sma.sma53
        #      END CASE
        #      IF gl_date < l_date THEN
        #         CALL cl_err(gl_date,'aap-027',0)
        #         NEXT FIELD g_existno
        #      END IF
        #     #No.MOD-920020 modify --end
        #   END IF
        #   #No.FUN-670047 --end
        #No.FUN-D60110 ---Mark--- End
 
         AFTER INPUT
            IF INT_FLAG THEN
               #EXIT INPUT     #No.FUN-D60110   Mark
               EXIT DIALOG     #No.FUN-D60110 Add
            END IF
            LET l_flag='N'
            IF cl_null(p_plant) THEN
               LET l_flag='Y'
            END IF
            IF cl_null(p_acc) THEN
               LET l_flag='Y'
            END IF
           #No.FUN-D60110 ---Mark--- Start
           #IF cl_null(g_existno) THEN
           #   LET l_flag='Y'
           #END IF
           #No.FUN-D60110 ---Mark--- End
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD p_plant
            END IF
            # 得出總帳 database name
            # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new
        #No.FUN-D60110 ---Mark--- Start
        #ON ACTION CONTROLR
        #   CALL cl_show_req_fields()
        #ON ACTION CONTROLG
        #   CALL cl_cmdask()
        #ON IDLE g_idle_seconds
        #   CALL cl_on_idle()
        #   CONTINUE INPUT
        #
        #ON ACTION about         #MOD-4C0121
        #   CALL cl_about()      #MOD-4C0121
        #
        #ON ACTION help          #MOD-4C0121
        #   CALL cl_show_help()  #MOD-4C0121
        #
        ##No.MOD-480423
        #ON ACTION exit              #加離開功能genero
        #   LET INT_FLAG = 1
        #   EXIT INPUT
        ##No.MOD-480423 (end)
        #
        ##No.FUN-580031 --start--
        #ON ACTION qbe_select
        #   CALL cl_qbe_select()
        ##No.FUN-580031 ---end---
        #
        ##No.FUN-580031 --start--
        #ON ACTION qbe_save
        #   CALL cl_qbe_save()
        ##No.FUN-580031 ---end---
        #No.FUN-D60110 ---Mark--- Start

#No.MOD-CB0129 --begin
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(p_plant)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp01_2"
               LET g_qryparam.default1 = p_plant
               CALL cl_create_qry() RETURNING p_plant
               DISPLAY BY NAME p_plant
               NEXT FIELD p_plant 
            WHEN INFIELD(p_acc)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = p_acc
               CALL cl_create_qry() RETURNING p_acc
               DISPLAY BY NAME p_acc
               NEXT FIELD p_acc
           #No.FUN-D60110 ---Mark--- Start
           #WHEN INFIELD(g_existno)
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form ="q_aba"
           #   LET g_qryparam.arg1 = p_acc
           #   LET g_qryparam.where = "aba19 = 'N' AND abapost ='N' AND abaacti ='Y' AND aba20 NOT IN ('S','s','1')"
           #   LET g_qryparam.default1 = g_existno
           #   CALL cl_create_qry() RETURNING g_existno
           #   DISPLAY BY NAME g_existno
           #   NEXT FIELD g_existno
           #No.FUN-D60110 ---Mark--- End
         END case
#No.MOD-CB0129 --end 

      END INPUT

   #FUN-D60110 ---Add--- Start
   CONSTRUCT BY NAME  tm.wc1 ON g_existno
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

   AFTER FIELD g_existno
      IF tm.wc1 = " 1=1" THEN 
         CALL cl_err('','9033',0)
         NEXT FIELD g_existno 
      END IF  
     #MOD-G30031---add---str--
      IF GET_FLDBUF(g_existno) = "*" THEN
         CALL cl_err('','9089',1)
         NEXT FIELD g_existno
      END IF
     #MOD-G30031---add---end-- 
      CALL  p620_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(g_existno)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aba"
               LET g_qryparam.arg1 = p_acc
               LET g_qryparam.where = "aba19 = 'N' AND abapost ='N' AND abaacti ='Y' AND aba20 NOT IN ('S','s','1')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_existno
               NEXT FIELD g_existno
         END CASE

   END CONSTRUCT

   INPUT BY NAME g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

   END INPUT 
   
   ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION exit 
         LET INT_FLAG = 1
         EXIT DIALOG    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
  
      ON ACTION ACCEPT
        #MOD-G30031---add---str--
         IF GET_FLDBUF(g_existno) = "*" THEN
            CALL cl_err('','9089',1)
            NEXT FIELD g_existno
         END IF
        #MOD-G30031---add---end--
         EXIT DIALOG        
       
      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END DIALOG 
   #FUN-D60110 ---Add--- End
 
      #No.FUN-570126 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gxrp620"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gxrp620','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",p_plant CLIPPED ,"'",
                         " '",p_acc CLIPPED ,"'",
                         " '",g_existno CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gxrp620',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
   #No.FUN-570126 ---end---
END FUNCTION
 
FUNCTION p620_t()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n10 LIKE type_file.num10    #NO.FUN-680145 INTEGER
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npp00       LIKE npp_file.npp00
   DEFINE l_npp01       LIKE npp_file.npp01
 
   #-----MOD-7A0113---------
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")   #No.FUN-D60110   Add
      #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "   SET abaacti = 'N' ",
                #" WHERE aba01 = ? AND aba00 = ? "     #No.FUN-D60110   Mark
                " WHERE  aba00 = ? ",                  #No.FUN-D60110 Add
                "   AND ",tm.wc2                       #No.FUN-D60110 Add
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_updaba_p FROM g_sql
     #EXECUTE p620_updaba_p USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
      EXECUTE p620_updaba_p USING g_ooz.ooz02b             #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)           #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN   #No.FUN-D60110   Mark
      END IF
   ELSE
   #-----END MOD-7A0113-----
     #DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------   #CHI-A70049 mark
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","abb01")   #No.FUN-D60110   Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                #" WHERE abb01=? AND abb00=?"    #No.FUN-D60110   Mark
                " WHERE  abb00 = ? ",            #No.FUN-D60110   Add
                "   AND ",tm.wc2                 #No.FUN-D60110   Add
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p3 FROM g_sql
     #EXECUTE p620_2_p3 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
      #EXECUTE p620_2_p3 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Add
      EXECUTE p620_2_p3 USING g_ooz.ooz02b   #change by donghy 一个?两个参数~~150206
      IF SQLCA.sqlcode THEN
#        CALL cl_err('(del abb)',SQLCA.sqlcode,1)  #No.FUN-660146
        #CALL cl_err3("del","abb_file",g_ooz.ooz02b,g_existno,SQLCA.sqlcode,"","(del abb)",1)   #No.FUN-660146   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN   #No.FUN-D60110   Mark
      END IF
     #DISPLAY "Delete GL's Voucher head!" AT 1,1 #-------------------------   #CHI-A70049 mark
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")   #No.FUN-D60110   Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                #" WHERE aba01 = ? AND aba00 = ? "     #No.FUN-D60110   Mark
                " WHERE  aba00 = ? ",                  #No.FUN-D60110 Add
                "   AND ",tm.wc2                       #No.FUN-D60110 Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p4 FROM g_sql
     #EXECUTE p620_2_p4 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
      EXECUTE p620_2_p4 USING g_ooz.ooz02b             #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
#        CALL cl_err('(del aba)',SQLCA.sqlcode,1)  #No.FUN-660146
         CALL cl_err3("del","aba_file",g_ooz.ooz02b,g_existno,SQLCA.sqlcode,"","(del aba)",1)   #No.FUN-660146 #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N' 
        #RETURN   #No.FUN-D60110   Mark
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','axr-161',1) LET g_success = 'N' RETURN
#        CALL cl_err('(del aba):0',SQLCA.SQLCODE,1)  #No.FUN-660146
        #CALL cl_err3("del","aba_file",g_ooz.ooz02b,g_existno,SQLCA.sqlcode,"","(del aba):0",1)   #No.FUN-660146 #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del aba)','aap-161',1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN   #No.FUN-D60110   Mark
      END IF
     #DISPLAY "Delete GL's Voucher desp!" AT 1,1 #-------------------------  #CHI-A70049 mark
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","abc01")   #No.FUN-D60110   Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'), #FUN-A50102
                #" WHERE abc01=? AND abc00=?"    #FUN-A50102  #No.FUN-D60110   Mark
                " WHERE  abc00=?",               #No.FUN-D60110 Add
                "   AND ",tm.wc2                 #No.FUN-D60110 Add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p5 FROM g_sql
      #EXECUTE p620_2_p5 USING g_existno,g_ooz.ooz02b 
      EXECUTE p620_2_p5 USING g_ooz.ooz02b #change by donghy 一个?两个参数~~150206
      IF SQLCA.sqlcode THEN
#        CALL cl_err('(del abc)',SQLCA.sqlcode,1)  #No.FUN-660146
        #CALL cl_err3("del","abc_file",g_ooz.ooz02b,g_existno,SQLCA.sqlcode,"","(del abc)",1)   #No.FUN-660146 #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
         LET g_success = 'N'
        #RETURN   #No.FUN-D60110   Mark
      END IF

#FUN-B40056 --begin
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","tic04")     #No.FUN-D60110 Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'), #FUN-A50102
                #" WHERE tic04 =? AND tic00 =?"  #No.FUN-D60110   Mark
                " WHERE  tic00 =?",              #No.FUN-D60110 Add
                "   AND ",tm.wc2                 #No.FUN-D60110 Add
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE p620_2_p9 FROM g_sql
     #EXECUTE p620_2_p9 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
      EXECUTE p620_2_p9 USING g_ooz.ooz02b             #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err3("del","tic_file",g_ooz.ooz02b,g_existno,SQLCA.sqlcode,"","(del tic)",1) #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN    #No.FUN-D60110   Mark
      END IF
#FUN-B40056 --end
     #DISPLAY "Delete GL's Voucher detail!" AT 1,1 #-------------------------  #CHI-A70049 mark
   END IF   #MOD-7A0113 
#  CALL s_abhmod(g_dbs_gl,g_ooz.ooz02b,g_existno)   #MOD-590081   #CHI-780008 #FUN-980020
   CALL s_abhmod(p_plant,g_ooz.ooz02b,g_existno)    #FUN-980020 
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)             #FUN-980011 add
                  VALUES('gxrp620',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980011 add
   #----------------------------------------------------------------------
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE npp_file SET npp03=NULL,nppglno=NULL,npp06=NULL,npp07=NULL
  # WHERE nppglno=g_existno
  #   AND ((nppsys= 'AR' AND npp00 = 4) OR  (nppsys= 'AP' AND npp00 = 5)
  #        OR (nppsys= 'NM' AND npp00 = 13)                  #No.MOD-510037 add
  #       OR (nppsys= 'NM' AND npp00 = 14)
  #       OR (nppsys ='NM' AND npp00 = 15))
  #   #No.FUN-670047 --begin
  #   AND npptype = '0'
  #   AND npp07 = g_ooz.ooz02b
  #   #No.FUN-670047 --end
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE ",tm.wc2 CLIPPED,
               "   AND ((nppsys= 'AR' AND npp00 = 4) OR  (nppsys= 'AP' AND npp00 = 5)",
               "        OR (nppsys= 'NM' AND npp00 = 13)",
               "        OR (nppsys= 'NM' AND npp00 = 14)",
               "        OR (nppsys ='NM' AND npp00 = 15))",
               "   AND npptype = '0'",    
               "   AND npp07 = '",g_ooz.ooz02b,"'"
   PREPARE p620_npp_prep FROM g_sql
   EXECUTE p620_npp_prep
  #No.FUN-D60110 ---Mod--- End
   IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#     CALL cl_err('(upd npp03)',STATUS,1)  #No.FUN-660146 
     #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","(upd npp03)",1)   #No.FUN-660146   #No.FUN-D60110   Mark
      CALL s_errmsg('','','(upd npp03)',STATUS,1)
      LET g_success='N'
     #RETURN     #No.FUN-D60110   Mark
   END IF
END FUNCTION
 
#No.FUN-670047 --begin
FUNCTION p620_t_1()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n10 LIKE type_file.num10    #NO.FUN-680145 INTEGER
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npp00       LIKE npp_file.npp00
   DEFINE l_npp01       LIKE npp_file.npp01
 
   #-----MOD-7A0113---------
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
      #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
      LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")        #No.FUN-D60110  Add
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "   SET abaacti = 'N' ",
              #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
               " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_updaba_p1 FROM g_sql
     #EXECUTE p620_updaba_p1 USING g_existno1,g_ooz.ooz02c  #No.FUN-D60110   Mark
      EXECUTE p620_updaba_p1 USING g_ooz.ooz02c             #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)           #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN                     #No.FUN-D60110   Add
      END IF
   ELSE
   #-----END MOD-7A0113-----
     #DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------  #CHI-A70049 mark
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
      LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","abb01")
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
              #" WHERE abb01=? AND abb00=?"   #No.FUN-D60110   Mark
               " WHERE abb00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p6 FROM g_sql
     #EXECUTE p620_2_p6 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
      EXECUTE p620_2_p6 USING g_ooz.ooz02c              #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err3("del","abb_file",g_ooz.ooz02c,g_existno1,SQLCA.sqlcode,"","(del abb)",1)   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N' 
        #RETURN         #No.FUN-D60110   Mark
      END IF
     #DISPLAY "Delete GL's Voucher head!" AT 1,1 #-------------------------  #CHI-A70049 mark
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
      LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")        #No.FUN-D60110  Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
              #" WHERE aba01=? AND aba00=?"   #No.FUN-D60110   Mark
               " WHERE aba00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p7 FROM g_sql
     #EXECUTE p620_2_p7 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
      EXECUTE p620_2_p7 USING g_ooz.ooz02c              #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err3("del","aba_file",g_ooz.ooz02c,g_existno1,SQLCA.sqlcode,"","(del aba)",1)   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N' 
        #RETURN   #No.FUN-D60110   Mark
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
        #CALL cl_err3("del","aba_file",g_ooz.ooz02c,g_existno1,SQLCA.sqlcode,"","(del aba):0",1)    #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del aba)','aap-161',1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN   #No.FUN-D60110   Mark
      END IF
     #DISPLAY "Delete GL's Voucher desp!" AT 1,1 #-------------------------  #CHI-A70049 mark
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
      LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","abc01")        #No.FUN-D60110  Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'), #FUN-A50102
               #" WHERE abc01=? AND abc00=?"   #No.FUN-D60110   Mark
                " WHERE abc00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p8 FROM g_sql
     #EXECUTE p620_2_p8 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
      EXECUTE p620_2_p8 USING g_ooz.ooz02c              #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err3("del","abc_file",g_ooz.ooz02c,g_existno1,SQLCA.sqlcode,"","(del abc)",1)   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N' 
        #RETURN   #No.FUN-D60110   Mark
      END IF
      
   #FUN-B40056 --begin
      LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","tic04")        #No.FUN-D60110  Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'), #FUN-A50102
               #" WHERE tic04=? AND tic00=?"   #No.FUN-D60110   Mark
                " WHERE tic00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p620_2_p10 FROM g_sql
     #EXECUTE p620_2_p10 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
      EXECUTE p620_2_p10 USING g_ooz.ooz02c   #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #CALL cl_err3("del","tic_file",g_ooz.ooz02c,g_existno1,SQLCA.sqlcode,"","(del tic)",1)   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)   #No.FUN-D60110   Add
         LET g_success = 'N'
        #RETURN   #No.FUN-D60110   Mark
      END IF
   #FUN-B40056 --end
     #DISPLAY "Delete GL's Voucher detail!" AT 1,1 #-------------------------  #CHI-A70049 mark
   END IF   #MOD-7A0113 
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)              #FUN-980011 add
                  VALUES('gxrp620',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal) #FUN-980011 add
   #----------------------------------------------------------------------
  #UPDATE npp_file SET npp03=NULL,nppglno=NULL,npp06=NULL,npp07=NULL
  # WHERE nppglno=g_existno1
  #   AND ((nppsys= 'AR' AND npp00 = 4) OR  (nppsys= 'AP' AND npp00 = 5)
  #        OR (nppsys= 'NM' AND npp00 = 13)                  #No.MOD-510037 add
  #       OR (nppsys= 'NM' AND npp00 = 14)
  #       OR (nppsys ='NM' AND npp00 = 15))
  #   #No.FUN-670047 --begin
  #   AND npptype = '1'
  #   AND npp07 = g_ooz.ooz02c
  #   #No.FUN-670047 --end
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE ",tm.wc2 CLIPPED,
               "   AND ((nppsys= 'AR' AND npp00 = 4) OR  (nppsys= 'AP' AND npp00 = 5)",
               "        OR (nppsys= 'NM' AND npp00 = 13)",
               "        OR (nppsys= 'NM' AND npp00 = 14)",
               "        OR (nppsys ='NM' AND npp00 = 15))",
               "   AND npptype = '1'",    
               "   AND npp07 = '",g_ooz.ooz02c,"'"
   PREPARE p620_npp_prep1 FROM g_sql
   EXECUTE p620_npp_prep1
  #No.FUN-D60110 ---Mod--- End
   IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
     #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1)   #No.FUN-D60110   Mark
      CALL s_errmsg('','','(upd npp03)',STATUS,1)   #No.FUN-D60110   Add
      LET g_success='N' 
     #RETURN     #No.FUN-D60110   Mark
   END IF
END FUNCTION
#No.FUN-670047 --end
#Patch....NO.TQC-610035 <001> #

#No.FUN-D60110 ---Add--- Start
FUNCTION p620_existno_chk()
   DEFINE   l_chk_bookno       LIKE type_file.num5    
   DEFINE   l_chk_bookno1      LIKE type_file.num5    
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01 
   DEFINE   l_aba06            LIKE aba_file.aba06
   DEFINE   l_aba00            LIKE aba_file.aba00 
   DEFINE   l_conf             LIKE aba_file.aba19
   DEFINE   l_aaa07            LIKE aaa_file.aaa07 
   DEFINE   l_npp00            LIKE npp_file.npp00 
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07     
   DEFINE   l_nppglno          LIKE npp_file.nppglno   
   DEFINE   l_cnt              LIKE type_file.num5    
   DEFINE   lc_cmd             LIKE type_file.chr1000 
   DEFINE   l_sql              STRING        
   DEFINE   l_cnt1             LIKE type_file.num5     
   DEFINE   l_aba20            LIKE aba_file.aba20    
   DEFINE   l_date             LIKE aba_file.aba02
   
   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
   
  #LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")   #MOD-E50017 mark
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")     #MOD-E50017 add
   LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,aba06,aba20,aba01 FROM ", 
             #g_dbs_gl CLIPPED,"aba_file",   #MOD-E50017 mark
              cl_get_target_table(g_plant_new,'aba_file'), 
             " WHERE aba00 = ? AND ",tm.wc2 CLIPPED
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        
   PREPARE p620_t_p1 FROM g_sql
   DECLARE p620_t_c1 CURSOR FOR p620_t_p1
   IF STATUS THEN
        CALL s_errmsg('decl aba_cursor:','','',STATUS,1)
        LET g_success = 'N'
   END IF
   OPEN p620_t_c1 USING g_ooz.ooz02b
   FOREACH p620_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,l_aba06,l_aba20,l_aba01 
      IF STATUS THEN
         CALL s_errmsg('sel aba:','','',STATUS,1)  
         LET g_success = 'N'
      END IF
      IF l_aba20 MATCHES '[Ss1]' THEN
         CALL s_errmsg('sel aba:','','','mfg3557',1) 
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---str--
      IF l_aba06 <> 'AR' AND l_aba06 <> 'AP' AND l_aba06 <> 'NM' THEN
         CALL s_errmsg('sel aba:',l_aba01,'','agl040',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---end--
      #---增加判斷會計帳別之關帳日期
      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), 
                " WHERE aaa01='",l_aba00,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE p620_x_gl_p1 FROM g_sql
      DECLARE p620_c_gl_p1 CURSOR FOR p620_x_gl_p1
      OPEN p620_c_gl_p1
      FETCH p620_c_gl_p1 INTO l_aaa07
      IF gl_date < l_aaa07 THEN
         CALL s_errmsg('sel aba:','','','agl-200',1)  
         LET g_success = 'N'
      END IF
      IF l_abapost = 'Y' THEN
         CALL s_errmsg('sel aba:','','','aap-130',1) 
         LET g_success = 'N'
      END IF
      IF l_conf ='Y' THEN
         CALL s_errmsg('sel aba:','','','aap-026',1)
         LET g_success = 'N'
      END IF
      CASE l_aba06
         WHEN 'AR'  LET l_date = g_ooz.ooz09
         WHEN 'AP'  LET l_date = g_apz.apz57
         WHEN 'NM'  LET l_date = g_nmz.nmz10
         OTHERWISE  LET l_date = g_sma.sma53
      END CASE
      IF gl_date < l_date THEN
         CALL s_errmsg('sel aba:','','','aap-027',1)  
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_aza.aza63 = 'Y' THEN
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")
      LET g_sql = "SELECT unique npp07,nppglno ",
                  "  FROM npp_file",
                  " WHERE npp01 IN (SELECT npp01 FROM npp_file",
                  "                  WHERE npp07 = '",p_acc,"'",
                  "                    AND ",tm.wc2 CLIPPED,
                  "                    AND npptype = '0')",
                  "   AND npptype = '1' "
      PREPARE p620_sel_npp1 FROM g_sql
      DECLARE p620_sel_npp CURSOR FOR p620_sel_npp1
      FOREACH p620_sel_npp INTO l_npp07,l_nppglno
         IF STATUS THEN
            CALL s_errmsg('sel nnp_file:','','',STATUS,1)
            LET g_success = 'N'
         END IF
         DISPLAY l_npp07 TO FORMONLY.p_acc1
         DISPLAY l_nppglno TO FORMONLY.g_existno1
         LET g_ooz.ooz02c = l_npp07
         LET p_acc1= l_npp07
         IF cl_null(g_existno1) THEN 
            LET g_existno1 = "'",l_nppglno,"'"
            LET g_existno1_str = g_existno1
         ELSE
            LET g_existno1_str = g_existno1_str,",","'",l_nppglno,"'"
         END IF
         LET g_existno1 = l_nppglno

         LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,aba06,aba20 FROM ", 
                    g_dbs_gl CLIPPED,"aba_file",
                    cl_get_target_table(g_plant_new,'aba_file'), 
                   " WHERE aba01 = ? AND aba00 = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
         PREPARE p620_t_p2 FROM g_sql
         DECLARE p620_t_c2 CURSOR FOR p620_t_p2
         IF STATUS THEN
            CALL s_errmsg('decl aba_cursor:','','',STATUS,1)
            LET g_success = 'N'
         END IF
         OPEN p620_t_c2 USING g_existno1,g_ooz.ooz02c
         FETCH p620_t_c2 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,l_aba06,l_aba20
         IF STATUS THEN
            CALL s_errmsg('sel aba:','','',STATUS,1) 
            LET g_success = 'N'
         END IF
         IF l_aba20 MATCHES '[Ss1]' THEN
            CALL s_errmsg('sel aba:','','','mfg3557',1) 
            LET g_success = 'N'
         END IF
         #---增加判斷會計帳別之關帳日期
         LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                   " WHERE aaa01='",l_aba00,"'"
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE p620_x_gl_p2 FROM g_sql
         DECLARE p620_c_gl_p2 CURSOR FOR p620_x_gl_p2
         OPEN p620_c_gl_p2
         FETCH p620_c_gl_p2 INTO l_aaa07
         IF gl_date < l_aaa07 THEN
            CALL s_errmsg('sel aba:','','','agl-200',1)
            LET g_success = 'N'
         END IF
         IF l_abapost = 'Y' THEN
            CALL s_errmsg('sel aba:','','','aap-130',1) 
            LET g_success = 'N'
         END IF
         IF l_conf ='Y' THEN
            CALL s_errmsg('sel aba:','','','aap-026',1)  
            LET g_success = 'N'
         END IF
         CASE l_aba06
            WHEN 'AR'  LET l_date = g_ooz.ooz09
            WHEN 'AP'  LET l_date = g_apz.apz57
            WHEN 'NM'  LET l_date = g_nmz.nmz10
            OTHERWISE  LET l_date = g_sma.sma53
         END CASE
         IF gl_date < l_date THEN
            CALL s_errmsg('sel aba:','','','aap-027',1)   
            LET g_success = 'N'
         END IF
      END FOREACH
      LET g_existno1_str = "g_existno IN (",g_existno1_str,")"
   END IF
END FUNCTION
#No.FUN-D60110 ---Add--- End
