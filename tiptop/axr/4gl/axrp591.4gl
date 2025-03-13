# Prog. Version..: '5.30.08-13.07.05(00010)'     #
#
# Pattern name...: axrp591.4gl
# Descriptions...: AR系統傳票拋轉還原
# Date & Author..: 97/05/29 By Sophia
# Modify.........: 97-07-22 帳別以user輸入為主
# Modify.........: copy aapp409
# Modify.........: No.9590 04/05/24 By Kitty nme16應更新原收支日,否則會影響anm報表等問題
# Modify.........: No.FUN-560060 05/06/15 By day   單據編號修改
# Modify.........: No.MOD-570223 05/07/19 By Yiting 傳票還原時,應判斷AP系統關帳
# Modify.........: No.MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.FUN-620021 06/03/27 By Sarah 取消B284處理段
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670047 06/08/15 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.MOD-6B0075 06/11/14 By xufeng 將還原時關帳日期多余的判斷去掉 
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-990182 09/10/19 By sabrina (1)帳款若已沖帳則不可做傳票還原 (2)將rowid拿掉 
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.TQC-9A0161 09/10/29 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9C0099 09/12/14 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No:MOD-A10124 10/01/21 By wujie   接MOD-990182判断中需排除直接收款的状况
# Modify.........: No:CHI-A20014 10/02/25 By sabrina 送簽中或已核准不可還原
# Modify.........: No:MOD-A30132 10/03/19 By Dido 增加作廢碼判斷 
# Modify.........: No:MOD-A60075 10/06/10 By Dido 取消 MOD-990182 控管
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 调整FUN-A60056修改内容
# Modify.........: No:MOD-A80246 10/09/01 By Dido 若已有產生至 amdi100 則不可還原 
# Modify.........: NO.FUN-A60007 10/09/02 BY chenmoyan 傳票拋轉還原時要考慮到oct_file
# Modify.........: NO.MOD-A80015 10/09/06 BY Dido 使用 oct_file 條件應為 oct00
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.MOD-BC0152 11/12/15 By Polly 還原FUN-620021程式段，產生分錄底稿
# Modify.........: No.TQC-C10008 11/01/03 By Dido 由於 n10 變數未放置於 FOREACH sel_azw01_cur 處理 
# Modify.........: No:CHI-C20017 12/05/29 By jinjj 若g_bgjob='Y'時使用彙總訊息方式呈現
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.FUN-D60110 13/06/24 by zhangweib 憑證編號開窗可多選
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string                     #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21       #No.FUN-680123 VARCHAR(21)
DEFINE p_plant          LIKE ooz_file.ooz02p       #No.FUN-680123 VARCHAR(12)
DEFINE p_acc            LIKE aaa_file.aaa01        #No.FUN-670039
DEFINE p_acc1           LIKE aaa_file.aaa01        #No.FUN-670047
DEFINE gl_date	 	LIKE type_file.dat         #No.FUN-680123 DATE
DEFINE gl_yy,gl_mm	LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE g_existno	LIKE aba_file.aba01        #No.FUN-560060
DEFINE g_existno1	LIKE aba_file.aba01        #No.FUN-670047
DEFINE g_str 		LIKE type_file.chr3        #No.FUN-680123 VARCHAR(3)
DEFINE g_mxno		LIKE type_file.chr8        #No.FUN-680123 VARCHAR(8)
DEFINE g_aaz84          LIKE aaz_file.aaz84 #還原方式 1.刪除 2.作廢 no.4868
DEFINE l_flag           LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
DEFINE   g_cnt          LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(72)
DEFINE   g_change_lang  LIKE type_file.chr1        # Prog. Version..: '5.30.08-13.07.05(01)   #是否有做語言切換 No.FUN-570156
DEFINE   l_abapost      LIKE aba_file.abapost      #No.FUN-680123 VARCHAR(1)
DEFINE   l_aaa07            LIKE aaa_file.aaa07
DEFINE   l_aba00            LIKE aba_file.aba00
DEFINE   l_npp07            LIKE npp_file.npp07     #No.FUN-670047
DEFINE   l_nppglno          LIKE npp_file.nppglno   #No.FUN-670047
DEFINE   l_abaacti          LIKE aba_file.abaacti
DEFINE   l_conf   	    LIKE type_file.chr1     #No.FUN-680123 VARCHAR(1)
DEFINE   l_npp01            LIKE npp_file.npp01     #MOD-990182 add
DEFINE   l_cnt              LIKE type_file.num5     #MOD-990182 add
DEFINE   l_aba20            LIKE aba_file.aba20     #CHI-A20014 add 
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE l_oma01  LIKE oma_file.oma01
#No.FUN-CB0096 ---end  --- Add
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
    OPTIONS
        MESSAGE   LINE  LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)             #輸入總帳營運中心編號
   LET p_acc     = ARG_VAL(2)             #輸入總帳帳別編號
   LET g_existno = ARG_VAL(3)             #輸入原總帳傳票編號
   LET g_bgjob = ARG_VAL(4)      #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #No.FUN-6A0095
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add

   WHILE TRUE
      CALL s_showmsg_init()   #CHI-C20017 add
      IF g_bgjob = "N" THEN
         CALL p591_ask()
         #FUN-D60110 ---Add--- Start
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         #FUN-D60110 ---Add--- End
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL cl_wait()
            BEGIN WORK
            #FUN-D60110 ---Add--- Start
            CALL p591_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D60110 ---Add--- End
            CALL p591()
            CALL s_showmsg()   #CHI-C20017 add
            CLOSE WINDOW p591_t_w9
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
               CLOSE WINDOW p591   
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'   #CHI-C20017 add
         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #No.FUN-D60110 Add
         CALL p591_existno_chk()                        #No.FUN-D60110 Add
         #No.FUN-670047 --begin
         LET g_plant_new=p_plant
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new
         LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti,aba20 ",    #CHI-A20014 add aba20
                   #" FROM ",g_dbs_gl,"aba_file",
                   " FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                   " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE p591_t_p3 FROM g_sql
         DECLARE p591_t_c3 CURSOR FOR p591_t_p3
         IF STATUS THEN
            #CALL cl_err('decl aba_cursor:',STATUS,0)          #CHI-C20017 mark
            CALL s_errmsg('','','decl aba_cursor:',STATUS,1)   #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                                            #CHI-C20017 mark
         END IF
         OPEN p591_t_c3 USING g_existno,g_ooz.ooz02b
         FETCH p591_t_c3 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
                              l_abaacti,l_aba20 #no.7378    #CHI-A20014 add l_aba20
         IF STATUS THEN
            #CALL cl_err('sel aba:',STATUS,0)         #CHI-C20017 mark
            CALL s_errmsg('','','sel aba:',STATUS,1)  #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                                   #CHI-C20017 mark
         END IF
         #no.7378
         IF l_abaacti = 'N' THEN
            #CALL cl_err('','mfg8001',1)          #CHI-C20017 mark
            CALL s_errmsg('','','','mfg8001',1)   #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                               #CHI-C20017 mark
         END IF
        #CHI-A20014---add---start---
         IF l_aba20 MATCHES '[Ss1]' THEN
            #CALL cl_err('','mfg3557',0)          #CHI-C20017 mark
            CALL s_errmsg('','','','mfg3557',1)   #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                                #CHI-C20017 mark
         END IF
        #CHI-A20014---add---end---
         #---增加判斷會計帳別之關帳日期
         #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
         LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                   " WHERE aaa01='",l_aba00,"'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE p591_x_gl_p3 FROM g_sql
         DECLARE p591_c_gl_p3 CURSOR FOR p591_x_gl_p3
         OPEN p591_c_gl_p3
         FETCH p591_c_gl_p3 INTO l_aaa07
         IF gl_date <= l_aaa07 THEN
            #CALL cl_err(gl_date,'agl-200',0)          #CHI-C20017 mark
            CALL s_errmsg('','',gl_date,'agl-200',1)   #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                                    #CHI-C20017 mark
         END IF
         IF l_abapost = 'Y' THEN
            #CALL cl_err(g_existno,'aap-130',0)          #CHI-C20017 mark
            CALL s_errmsg('','',g_existno,'aap-130',1)   #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                                      #CHI-C20017 mark
         END IF
         IF l_conf ='Y' THEN
            #CALL cl_err(g_existno,'aap-026',0)          #CHI-C20017 mark
            CALL s_errmsg('','',g_existno,'aap-026',1)   #CHI-C20017 add
            LET g_success = 'N'
            #RETURN                                      #CHI-C20017 mark
         END IF
        #-MOD-A80246-add-  
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt 
           FROM amd_file
          WHERE amd28 = g_existno
         IF l_cnt > 0 THEN
            #CALL cl_err(g_existno,'amd-030',0)          #CHI-C20017 mark
            CALL s_errmsg('','',g_existno,'amd-030',1)   #CHI-C20017 add 
            LET g_success ='N'
            #RETURN                                      #CHI-C20017 mark
         END IF 
        #-MOD-A80246-end-  
#MOD-6B0075    --Begin
#        IF gl_date < g_ooz.ooz09 THEN       
#           CALL cl_err(gl_date,'aap-027',0)  
#           LET g_success = 'N'               
#           RETURN                            
#        END IF       
#MOD-6B0075    --End                        
           
        #-MOD-A60075-mark-
        #MOD-990182---add---start---
        #SELECT npp01 INTO l_npp01 FROM npp_file
        # WHERE nppsys = 'AR' AND nppglno = g_existno
        #   AND npp011 IN (SELECT npp011 FROM npp_file
        #                        WHERE npp07 = p_acc
        #                          AND nppglno = g_existno
        #                          AND npptype = '0')
        #LET l_cnt = 0
        #SELECT COUNT(*) INTO l_cnt FROM ooa_file,oob_file
        # WHERE ooa01 = oob01 AND oob03 = '2' AND oob04 = '1'
        #   AND oob06 = l_npp01
        #   AND ooa00 <> '2'   #No.MOD-A10124
        #   AND ooaconf <> 'X' #MOD-A30132
        #IF l_cnt > 0 THEN
        #   CALL cl_err('','axr-801',1)
        #   LET g_success = 'N'
        #   RETURN
        #END IF
        #MOD-990182---add---end--- 
        #-MOD-A60075-end-
         IF g_aza.aza63 = 'Y' THEN
            SELECT npp07,nppglno INTO l_npp07,l_nppglno
              FROM npp_file
             WHERE npp01 IN (SELECT npp01 FROM npp_file
                                    WHERE npp07 = p_acc
                                      AND nppglno = g_existno
                                      AND npptype = '0')
               AND npp011 IN (SELECT npp011 FROM npp_file
                                    WHERE npp07 = p_acc
                                      AND nppglno = g_existno
                                      AND npptype = '0')
               AND npp00  IN (SELECT npp00  FROM npp_file
                                    WHERE npp07 = p_acc
                                      AND nppglno = g_existno
                                      AND npptype = '0')
               AND npptype = '1' AND nppsys  ='AR'
            IF STATUS THEN
               #CALL cl_err3("sel","npp_file","","","axr-800","","",1)     #CHI-C20017 mark
               CALL s_errmsg('','','',"axr-800",1)                         #CHI-C20017 add 
               LET g_success = 'N'
               #RETURN                                                     #CHI-C20017 mark
            END IF
            LET g_ooz.ooz02c = l_npp07
            LET g_existno1 = l_nppglno
 
            LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti,aba20 ",    #CHI-A20014 add aba20
                      #" FROM ",g_dbs_gl,"aba_file",
                      " FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                      " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE p591_t_p4 FROM g_sql
            DECLARE p591_t_c4 CURSOR FOR p591_t_p4
            IF STATUS THEN
               #CALL cl_err('decl aba_cursor:',STATUS,0)          #CHI-C20017 mark
               CALL s_errmsg('','','decl aba_cursor:',STATUS,1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                                            #CHI-C20017 mark
            END IF
            OPEN p591_t_c4 USING g_existno1,g_ooz.ooz02c
            FETCH p591_t_c4 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
                                 l_abaacti,l_aba20     #CHI-A20014 add l_aba20
            IF STATUS THEN
               #CALL cl_err('sel aba:',STATUS,0)          #CHI-C20017 mark
               CALL s_errmsg('','','sel aba:',STATUS,1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                                    #CHI-C20017 mark
            END IF
            IF l_abaacti = 'N' THEN
               #CALL cl_err('','mfg8001',1)          #CHI-C20017 mark
               CALL s_errmsg('','','','mfg8001',1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                               #CHI-C20017 mark
            END IF
           #CHI-A20014---add---start---
            IF l_aba20 MATCHES '[Ss1]' THEN
               #CALL cl_err('','mfg3557',0)          #CHI-C20017 mark
               CALL s_errmsg('','','','mfg3557',1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                               #CHI-C20017 mark
            END IF
           #CHI-A20014---add---end---
            #---增加判斷會計帳別之關帳日期
            #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
            LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                      " WHERE aaa01='",l_aba00,"'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE p591_x_gl_p4 FROM g_sql
            DECLARE p591_c_gl_p4 CURSOR FOR p591_x_gl_p4
            OPEN p591_c_gl_p4
            FETCH p591_c_gl_p4 INTO l_aaa07
            IF gl_date <= l_aaa07 THEN
               #CALL cl_err(gl_date,'agl-200',0)          #CHI-C20017 mark
               CALL s_errmsg('','',gl_date,'agl-200',1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                                    #CHI-C20017 mark
            END IF
            IF l_abapost = 'Y' THEN
               #CALL cl_err(g_existno1,'aap-130',0)          #CHI-C20017 mark
               CALL s_errmsg('','',g_existno1,'aap-130',1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                                       #CHI-C20017 mark
            END IF
            IF l_conf ='Y' THEN
               #CALL cl_err(g_existno1,'aap-026',0)          #CHI-C20017 mark
               CALL s_errmsg('','',g_existno1,'aap-026',1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                                       #CHI-C20017 mark
            END IF
         #FUN-B50090 add begin-------------------------
         #重新抓取關帳日期
            LET g_sql ="SELECT ooz09 FROM ooz_file ",
                       " WHERE ooz00 = '0'"
            PREPARE t600_ooz09_p FROM g_sql
            EXECUTE t600_ooz09_p INTO g_ooz.ooz09
         #FUN-B50090 add -end--------------------------
            IF gl_date < g_ooz.ooz09 THEN
               #CALL cl_err(gl_date,'aap-027',0)          #CHI-C20017 mark
               CALL s_errmsg('','',gl_date,'aap-027',1)   #CHI-C20017 add
               LET g_success = 'N'
               #RETURN                                     #CHI-C20017 mark
            END IF
         END IF
         #No.FUN-670047 --end
         #LET g_success = 'Y'   #CHI-C20017 mark
         BEGIN WORK
         CALL p591()
         CALL s_showmsg()   #CHI-C20017 add
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
  #No.FUN-CB0096 ---start--- add
  #LET l_time = TIME   #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('U','100',g_id,'1',l_time,'','')
  #No.FUN-CB0096 ---end  --- add
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN

 
FUNCTION p591()
# 得出總帳 database name
# g_ooz.ooz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
   #No.FUN-570156 --start--
#  CALL p591_ask()			
#  IF INT_FLAG THEN RETURN END IF
#  IF cl_sure(21,21) THEN
#     CALL cl_wait()
#     OPEN WINDOW p591_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS
      IF g_bgjob = "N" THEN
         OPEN WINDOW p591_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
      END IF
   #No.FUN-570156 ---end---
      #LET g_success = 'Y'  #CHI-C20017 mark
      LET g_plant_new=p_plant
      CALL s_getdbs()
      LET g_dbs_gl=g_dbs_new
 
      #no.4868 (還原方式為刪除/作廢)
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
        #str CHI-C20017 mod
         #CALL cl_err('sel aaz84',STATUS,1)
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','sel aaz84',STATUS,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('sel aaz84',STATUS,1)
        #END IF
        #No.FUN-D60110 ---Mark--- End
        #No.FUN-570156 --start--
         CALL cl_batch_bg_javamail("N")
         IF g_bgjob = "N" THEN
            CLOSE WINDOW p591_t_w9
            CLOSE WINDOW p591 
         END IF
         #No.FUN-570156
         CALL s_showmsg()   #CHI-C20017 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      #no.4868(end)
 
#     BEGIN WORK       #No.FUN-570156
      CALL p591_t()
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL p591_t_1()
      END IF
#  END IF              #No.FUN-570156
   #----genero
   #No.FUN-570156 --start--
#  ERROR ""0
#  CLOSE WINDOW p591_t_w9
   #No.FUN-570156 ---end---
END FUNCTION
 
FUNCTION p591_ask()
   DEFINE   l_abapost,l_flag   LIKE aba_file.abapost   #No.FUN-680123 VARCHAR(1)
   DEFINE   l_aaa07            LIKE aaa_file.aaa07
   DEFINE   l_aba00            LIKE aba_file.aba00
   DEFINE   l_npp07            LIKE npp_file.npp07     #No.FUN-670047
   DEFINE   l_nppglno          LIKE npp_file.nppglno   #No.FUN-670047
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_conf   	       LIKE type_file.chr1     #No.FUN-680123 VARCHAR(1)
   DEFINE   lc_cmd             LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(500)     #No.FUN-570156
   DEFINE li_chk_bookno  LIKE type_file.num5           #No.FUN-680123 SMALLINT   #No.FUN-670006
   DEFINE l_i            LIKE type_file.num10,         #No.FUN-680123 SMALLINT,
          l_dbname       LIKE type_file.chr21,         #No.FUN-680123 VARCHAR(21),
          l_ds           LIKE azp_file.azp01,
          l_sql          STRING                        #No.FUN-670006  -add
   DEFINE   l_npp01            LIKE npp_file.npp01     #MOD-990182 add
   DEFINE   l_cnt              LIKE type_file.num5     #MOD-990182 add
   DEFINE   l_aba20            LIKE aba_file.aba20     #CHI-A20014 add
 
   OPEN WINDOW p591 WITH FORM "axr/42f/axrp591" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)
   ELSE
      CALL cl_set_comp_visible("p_acc1,g_existno1",TRUE)
   END IF
 
   WHILE TRUE
   LET g_bgjob = "N" 
   #No.FUN-570156 ---end---   
 
   LET p_plant = g_ooz.ooz02p
   LET p_acc   = g_ooz.ooz02b
   LET g_existno = NULL
   DIALOG ATTRIBUTES(UNBUFFERED)  #No.FUN-D60110 Add
     #INPUT BY NAME p_plant,p_acc,g_existno,g_bgjob WITHOUT DEFAULTS    #No.FUN-570156   #No.FUN-D60110  Mark
      INPUT BY NAME p_plant,p_acc ATTRIBUTE(WITHOUT DEFAULTS=TRUE)     #No.FUN-D60110 Add
    
            #No.FUN-580031 --start--
            BEFORE INPUT
                CALL cl_qbe_init()
            #No.FUN-580031 ---end---
    
         AFTER FIELD p_plant
            #FUN-990031--mod--str--營運中心要控制在當前法人下
            #SELECT azp01 FROM azp_file
            # WHERE azp01 = p_plant
            SELECT *  FROM azw_file WHERE azw01 = p_plant 
               AND azw02 = g_legal
            #FUN-990031--mod--end
            IF STATUS <> 0 THEN
               CALL cl_err('sel_azw','agl-171',0) #FUN-990031
               NEXT FIELD p_plant
            END IF
            ##-00/05/18 modify
            LET g_plant_new=p_plant
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new
    
         AFTER FIELD p_acc
            LET g_ooz.ooz02b = p_acc
            #No.FUN-670006--begin
                CALL s_check_bookno(p_acc,g_user,p_plant) 
                     RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                     NEXT FIELD p_acc
                END IF 
                LET g_plant_new= p_plant  #工廠編號
                    CALL s_getdbs()
                    LET l_sql = "SELECT COUNT(*)",
                                #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                                "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                                " WHERE aaa01 = '",p_acc,"' ",
                                "   AND aaaacti IN ('Y','y') "
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                    PREPARE p591_pre2 FROM l_sql
                    DECLARE p591_cur2 CURSOR FOR p591_pre2
                    OPEN p591_cur2
                    FETCH p591_cur2 INTO g_cnt
   ## No:2553 modify 1998/10/19 ---------------------
   #         SELECT COUNT(*) INTO g_cnt FROM aaa_file
   #          WHERE aaa01=p_acc
             #No.FUN-670006--end
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_acc
            END IF
   ## -----------------------------------------------

        #No.FUN-D60110 ---Mark--- Start
        #AFTER FIELD g_existno
        #   IF cl_null(g_existno) THEN
        #      NEXT FIELD g_existno
        #   END IF
        #   LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti,aba20 ",     #CHI-A20014 add aba20
        #             #" FROM ",g_dbs_gl,"aba_file",
        #             " FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
        #             " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"
        #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #   PREPARE p591_t_p1 FROM g_sql
        #   DECLARE p591_t_c1 CURSOR FOR p591_t_p1
        #   IF STATUS THEN
        #      CALL cl_err('decl aba_cursor:',STATUS,0)
        #      NEXT FIELD g_existno
        #   END IF
        #   OPEN p591_t_c1 USING g_existno,g_ooz.ooz02b
        #   FETCH p591_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
        #                        l_abaacti,l_aba20 #no.7378     #CHI-A20014 add l_aba20
        #   IF STATUS THEN
        #      CALL cl_err('sel aba:',STATUS,0)
        #      NEXT FIELD g_existno
        #   END IF
        #   #no.7378
        #   IF l_abaacti = 'N' THEN
        #      CALL cl_err('','mfg8001',1)
        #      NEXT FIELD g_existno
        #   END IF
        #  #CHI-A20014---add---start---
        #   IF l_aba20 MATCHES '[Ss1]' THEN
        #      CALL cl_err('','mfg3557',0)
        #      NEXT FIELD g_existno
        #   END IF
        #  #CHI-A20014---add---end---
        #   #---增加判斷會計帳別之關帳日期
        #   #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
        #   LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
        #             " WHERE aaa01='",l_aba00,"'"
        #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #   PREPARE p591_x_gl_p1 FROM g_sql
        #   DECLARE p591_c_gl_p1 CURSOR FOR p591_x_gl_p1
        #   OPEN p591_c_gl_p1
        #   FETCH p591_c_gl_p1 INTO l_aaa07
        #   IF gl_date <= l_aaa07 THEN
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
   #    #    IF gl_date < g_sma.sma53 THEN
        # #FUN-B50090 add begin-------------------------
        # #重新抓取關帳日期
        #    LET g_sql ="SELECT ooz09 FROM ooz_file ",
        #               " WHERE ooz00 = '0'"
        #    PREPARE t600_ooz09_p1 FROM g_sql
        #    EXECUTE t600_ooz09_p1 INTO g_ooz.ooz09
        # #FUN-B50090 add -end--------------------------
        #    IF gl_date < g_ooz.ooz09 THEN   #MOD-570223
        #      CALL cl_err(gl_date,'aap-027',0)
        #      NEXT FIELD g_existno
        #   END IF
        #  #-MOD-A80246-add-  
        #   LET l_cnt = 0
        #   SELECT COUNT(*) INTO l_cnt 
        #     FROM amd_file
        #    WHERE amd28 = g_existno
        #   IF l_cnt > 0 THEN
        #      CALL cl_err(g_existno,'amd-030',0) 
        #      NEXT FIELD g_existno
        #   END IF 
        #  #-MOD-A80246-end-  
        #     
        #  #-MOD-A60075-mark-
        #  #MOD-990182---add---start---
        #  #SELECT npp01 INTO l_npp01 FROM npp_file
        #  # WHERE nppsys = 'AR' AND nppglno = g_existno
        #  #   AND npp011 IN (SELECT npp011 FROM npp_file
        #  #                        WHERE npp07 = p_acc
        #  #                          AND nppglno = g_existno
        #  #                          AND npptype = '0')
        #  #LET l_cnt = 0
        #  #SELECT COUNT(*) INTO l_cnt FROM ooa_file,oob_file
        #  # WHERE ooa01 = oob01 AND oob03 = '2' AND oob04 = '1'
        #  #   AND oob06 = l_npp01
        #  #   AND ooa00 <> '2'   #No.MOD-A10124
        #  #IF l_cnt > 0 THEN
        #  #   CALL cl_err('','axr-801',1)
        #  #   NEXT FIELD g_existno
        #  #END IF
        #  #MOD-990182---add---end--- 
        #  #-MOD-A60075-end-
        #   #No.FUN-670047 --begin
        #   IF g_aza.aza63 = 'Y' THEN
        #      SELECT npp07,nppglno INTO l_npp07,l_nppglno
        #        FROM npp_file
        #       WHERE npp01 IN (SELECT npp01 FROM npp_file
        #                              WHERE npp07 = p_acc
        #                                AND nppglno = g_existno
        #                                AND npptype = '0')
        #         AND npp011 IN (SELECT npp011 FROM npp_file
        #                              WHERE npp07 = p_acc
        #                                AND nppglno = g_existno
        #                                AND npptype = '0')
        #         AND npp00  IN (SELECT npp00  FROM npp_file
        #                              WHERE npp07 = p_acc
        #                                AND nppglno = g_existno
        #                                AND npptype = '0')
        #         AND npptype = '1' AND nppsys = 'AR'
        #      IF STATUS THEN
        #         CALL cl_err3("sel","npp_file","","","axr-800","","",1) 
        #         RETURN
        #      END IF
        #      LET g_ooz.ooz02c = l_npp07
        #      LET g_existno1 = l_nppglno
        #      DISPLAY l_npp07 TO FORMONLY.p_acc1
        #      DISPLAY l_nppglno TO FORMONLY.g_existno1
        #
        #      LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti,aba20 ",    #CHI-A20014 add aba20
        #                #" FROM ",g_dbs_gl,"aba_file",
        #                " FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
        #                " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"
        #     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #      PREPARE p591_t_p2 FROM g_sql
        #      DECLARE p591_t_c2 CURSOR FOR p591_t_p2
        #      IF STATUS THEN
        #         CALL cl_err('decl aba_cursor:',STATUS,0)
        #         NEXT FIELD g_existno
        #      END IF
        #      OPEN p591_t_c2 USING g_existno1,g_ooz.ooz02c
        #      FETCH p591_t_c2 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
        #                           l_abaacti,l_aba20    #CHI-A20014 add l_aba20
        #      IF STATUS THEN
        #         CALL cl_err('sel aba:',STATUS,0)
        #         NEXT FIELD g_existno
        #      END IF
        #      IF l_abaacti = 'N' THEN
        #         CALL cl_err('','mfg8001',1)
        #         NEXT FIELD g_existno
        #      END IF
        #     #CHI-A20014---add---start---
        #      IF l_aba20 MATCHES '[Ss1]' THEN
        #         CALL cl_err('','mfg3557',0)
        #         NEXT FIELD g_existno
        #      END IF
        #     #CHI-A20014---add---end---
        #      #---增加判斷會計帳別之關帳日期
        #      #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file",
        #      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
        #                " WHERE aaa01='",l_aba00,"'"
        #     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #      PREPARE p591_x_gl_p2 FROM g_sql
        #      DECLARE p591_c_gl_p2 CURSOR FOR p591_x_gl_p2
        #      OPEN p591_c_gl_p2
        #      FETCH p591_c_gl_p2 INTO l_aaa07
        #      IF gl_date <= l_aaa07 THEN
        #         CALL cl_err(gl_date,'agl-200',0)
        #         NEXT FIELD g_existno
        #      END IF
        #      IF l_abapost = 'Y' THEN
        #         CALL cl_err(g_existno1,'aap-130',0)
        #         NEXT FIELD g_existno
        #      END IF
        #      IF l_conf ='Y' THEN
        #         CALL cl_err(g_existno1,'aap-026',0)
        #         NEXT FIELD g_existno
        #      END IF
        #      IF gl_date < g_ooz.ooz09 THEN
        #         CALL cl_err(gl_date,'aap-027',0)
        #         NEXT FIELD g_existno
        #      END IF
        #   END IF
        #   #No.FUN-670047 --end
        #No.FUN-D60110 ---Mark--- End
    
        ON ACTION CONTROLP
 
          #No.B003 010413 by plum
         AFTER INPUT
            IF INT_FLAG THEN
               #EXIT INPUT     #No.FUN-D60110   Mark
               EXIT DIALOG     #No.FUN-D60110 Add
            END IF
            LET l_flag='N'
            IF cl_null(p_plant)   THEN
               LET l_flag='Y'
            END IF
            IF cl_null(p_acc)     THEN
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
          #No.B003...end

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
        #ON ACTION exit                            #加離開功能
        #   LET INT_FLAG = 1
        #   EXIT INPUT
        #
        #ON ACTION locale
        #   #No.FUN-570156 --start--
        #   LET g_change_lang = TRUE
   #    #   CALL cl_dynamic_locale()
   #    #    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        #   EXIT INPUT
        #   #No.FUN-570156 ---end---
        #
        #
        #   #No.FUN-580031 --start--
        #   ON ACTION qbe_select
        #      CALL cl_qbe_select()
        #   #No.FUN-580031 ---end---
        #
        #   #No.FUN-580031 --start--
        #   ON ACTION qbe_save
        #      CALL cl_qbe_save()
        #   #No.FUN-580031 ---end---
        #No.FUN-D60110 ---Mark--- Start
    
      END INPUT
   #No.FUN-570156 --start--

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
      CALL  p591_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(g_existno)
              LET g_existno_str = ''
              CALL q_aba01_1( TRUE, TRUE, p_plant,p_acc,' ','AR')
              RETURNING g_existno_str   
              DISPLAY g_existno_str TO g_existno
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
   
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      EXIT WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p591 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
      
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axrp591"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('axrp591','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant CLIPPED,"'",
                      " '",p_acc CLIPPED,"'",
                      " '",g_existno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axrp591',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p591
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
#No.FUN-570156 ---end---   
END FUNCTION
 
FUNCTION p591_t()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n10       LIKE type_file.num10   #No.FUN-680123 INTEGER
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npp00       LIKE npp_file.npp00
   DEFINE l_npp01       LIKE npp_file.npp01
   DEFINE l_cn          LIKE type_file.num5    #No.FUN-680123 SMALLINT             #TSC:plum 20040521 No:9590
   DEFINE l_sql         LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(600) #TSC:plum 20040521 No:9590
   DEFINE l_nmg01       LIKE nmg_file.nmg01    #TSC:plum 20040521 No:9590
   DEFINE l_nmg00       LIKE nmg_file.nmg00    #MOD-990182 add
   #No.TQC-9A0161   --Begin
   DEFINE l_nme00       LIKE nme_file.nme00
   DEFINE l_nme01       LIKE nme_file.nme01
   DEFINE l_nme02       LIKE nme_file.nme02
   DEFINE l_nme03       LIKE nme_file.nme03
   DEFINE l_nme12       LIKE nme_file.nme12
   DEFINE l_nme21       LIKE nme_file.nme21
   #No.TQC-9A0161   --Begin
  #DEFINE l_omb44       LIKE omb_file.omb44   #FUN-A60056    #FUN-A70139 
   DEFINE l_azw01       LIKE azw_file.azw01   #FUN-A70139
   DEFINE n11           LIKE type_file.num10   #FUN-A60007 
 
IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
   #LET g_sql="UPDATE ",g_dbs_gl CLIPPED," aba_file  SET abaacti = 'N' ",
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")   #No.FUN-D60110   Add
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
             "   SET abaacti = 'N' ",
               #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
                " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_updaba_p FROM g_sql
  #EXECUTE p591_updaba_p USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
   EXECUTE p591_updaba_p USING g_ooz.ooz02b             #No.FUN-D60110   Mark
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success = 'N'
      #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
      #No.FUN-D60110 ---Mark--- Start
      #ELSE
      #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      ##end CHI-C20017 mod
      #No.FUN-D60110 ---Mark--- End
   END IF
ELSE
   IF g_bgjob = "N" THEN       #No.FUN-570156
      MESSAGE   "Delete GL's Voucher body!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF                      #No.FUN-570156
   #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","abb01")   #No.FUN-D60110   Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
              #" WHERE abb01=? AND abb00=?"   #No.FUN-D60110   Mark
               " WHERE abb00=? AND ",tm.wc2   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_2_p3 FROM g_sql
  #EXECUTE p591_2_p3 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
   EXECUTE p591_2_p3 USING g_ooz.ooz02b   #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del abb)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success = 'N'
      #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
      #No.FUN-D60110 ---Mark--- Start
      #ELSE
      #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #end CHI-C20017 mod
      #No.FUN-D60110 ---Mark--- End
   END IF
   IF g_bgjob = "N" THEN       #No.FUN-570156
      MESSAGE   "Delete GL's Voucher head!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF                      #No.FUN-570156
  # LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")        #No.FUN-D60110  Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
            #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
             " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_2_p4 FROM g_sql
  #EXECUTE p591_2_p4 USING g_existno,g_ooz.ooz02b  #No.FUN-D60110   Mark 
   EXECUTE p591_2_p4 USING g_ooz.ooz02b   #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del aba)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
   END IF
   IF SQLCA.sqlerrd[3] = 0 THEN
    #str CHI-C20017 mod
      #CALL cl_err('(del aba)','axr-161',1) LET g_success = 'N' RETURN
      #CALL cl_err('(del aba):0',SQLCA.SQLCODE,1) LET g_success = 'N' RETURN
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del aba)',SQLCA.SQLCODE,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)',SQLCA.SQLCODE,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
   END IF
   IF g_bgjob = "N" THEN      #No.FUN-570156
      MESSAGE   "Delete GL's Voucher desp!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF                     #No.FUN-570156
   #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","abc01")        #No.FUN-D60110  Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'), #FUN-A50102
              #" WHERE abc01 = ? AND abc00 = ? "   #No.FUN-D60110   Mark
               " WHERE abc00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_2_p5 FROM g_sql
  #EXECUTE p591_2_p5 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
   EXECUTE p591_2_p5 USING g_ooz.ooz02b   #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
    #str CHI-C20017 mod
      #CALL cl_err('(del abc)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
   END IF
#FUN-B40056 --begin
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","tic04")        #No.FUN-D60110  Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
            #" WHERE tic04=? AND tic00=?"   #No.FUN-D60110   Mark
             " WHERE tic00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p591_2_p9 FROM g_sql
  #EXECUTE p591_2_p9 USING g_existno,g_ooz.ooz02b   #No.FUN-D60110   Mark
   EXECUTE p591_2_p9 USING g_ooz.ooz02b   #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del tic)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success = 'N'
      #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
      #No.FUN-D60110 ---Mark--- Start
      #ELSE
      #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #end CHI-C20017 mod
      #No.FUN-D60110 ---Mark--- End
   END IF
#FUN-B40056 --end
END IF
   IF g_bgjob = "N" THEN             #No.FUN-570156
      MESSAGE   "Delete GL's Voucher detail!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF                            #No.FUN-570156
  #CALL s_abhmod(g_dbs_gl,g_ooz.ooz02b,g_existno)    #MOD-590081   #CHI-780008#TQC-9C0099 mark
   CALL s_abhmod(p_plant,g_ooz.ooz02b,g_existno)    #MOD-590081   #CHI-780008 #TQC-9C0099
   IF g_success = 'N' THEN RETURN END IF
        LET g_msg = TIME
        INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980011 add
               VALUES('axrp591',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980011 add
   #----------------------------------------------------------------------
  #UPDATE npp_file SET (npp03,nppglno,npp06,npp07)=(NULL,NULL,NULL,NULL)
  # WHERE nppglno=g_existno
  #   IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#   #      CALL cl_err('(upd npp03)',STATUS,1) LET g_success='N' RETURN  
  #   END IF
   #----------------------------------------------------------------------
#FUN-A70139--取消mark--str
#FUN-A60056--mark--str--拿到更新oga_file之后更新.因為upd oga_file要用到oma33
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE oma_file SET oma33=NULL WHERE oma33=g_existno
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","oma33")
   LET g_sql = "UPDATE oma_file SET oma33=NULL WHERE ",tm.wc2 CLIPPED
   PREPARE p591_upd_oma FROM g_sql
   EXECUTE p591_upd_oma
  #No.FUN-D60110 ---Mod--- End
      IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
         #CALL cl_err('(upd oma33)',STATUS,1)  #No.FUN-660116
         #CALL cl_err3("upd","oma_file",g_existno,"",STATUS,"","(upd oma33)",1)   #No.FUN-660116
         #LET g_success='N' RETURN 
         LET g_success='N'
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(upd oma33)',STATUS,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err3("upd","oma_file",g_existno,"",STATUS,"","(upd oma33)",1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
      END IF
   LET n1 = SQLCA.SQLERRD[3]
#FUN-A60056--mark--end
#FUN-A70139--end
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE ooa_file SET ooa33=NULL WHERE ooa33=g_existno
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","ooa33")
   LET g_sql = "UPDATE ooa_file SET ooa33=NULL WHERE ",tm.wc2 CLIPPED
   PREPARE p591_upd_ooa FROM g_sql
   EXECUTE p591_upd_ooa
  #No.FUN-D60110 ---Mod--- End
      IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
#        CALL cl_err('(upd ooa33)',STATUS,1) #No.FUN-660116
         #CALL cl_err3("upd","ooa_file",g_existno,"",STATUS,"","(upd ooa33)",1)   #No.FUN-660116
         #LET g_success='N' RETURN  
         LET g_success='N'
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(upd ooa33)',STATUS,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err3("upd","ooa_file",g_existno,"",STATUS,"","(upd ooa33)",1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
      END IF
   LET n2 = SQLCA.SQLERRD[3]
##No.3025 1999/03/02 modify
   #-----------支票 轉暫收------------------------------------------------
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE nmh_file SET nmh33 = NULL, nmh34 = NULL WHERE nmh33 = g_existno
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nmh33")
   LET g_sql = "UPDATE nmh_file SET nmh33 = NULL, nmh34 = NULL WHERE ",tm.wc2 CLIPPED
   PREPARE p591_upd_nmh FROM g_sql
   EXECUTE p591_upd_nmh
  #No.FUN-D60110 ---Mod--- End
   LET n3 = SQLCA.SQLERRD[3]
   #-----------T/T 轉暫收-------------------------------------------------
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE nmg_file SET nmg13 = NULL, nmg14 = NULL WHERE nmg13 = g_existno
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nmg13")
   LET g_sql = "UPDATE nmg_file SET nmg13 = NULL, nmg14 = NULL WHERE ",tm.wc2 CLIPPED
   PREPARE p591_upd_nmg FROM g_sql
   EXECUTE p591_upd_nmg
  #No.FUN-D60110 ---Mod--- End
   LET n4 = SQLCA.SQLERRD[3]
   #-----------T/T 轉暫收-------------------------------------------------
    #No:9590 modify
   {#TSC:plum 20040521
   UPDATE nme_file SET nme16 = NULL WHERE nme10 = g_existno
   LET n5 = SQLCA.SQLERRD[3]
   }
   LET l_cn=0
   #No.TQC-9A0161  --Begin
   #LET l_sql ="SELECT nmg00,nmg01 FROM nme_file,nmg_file ",
   #           " WHERE nme10=? ",
   #           "   AND nme12=nmg00 "
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nme10")
   LET l_sql ="SELECT nmg00,nmg01,nme00,nme01,nme02,nme03,nme12,nme21 FROM nme_file,nmg_file ",
             #" WHERE nme10=? ",   #No.FUN-D60110   Mark
              " WHERE ",tm.wc2 CLIPPED,   #No.FUN-D60110   Add
              "   AND nme12=nmg00 "
   PREPARE p591_p_nme FROM l_sql
   DECLARE p591_c_nme CURSOR FOR p591_p_nme
   FOREACH p591_c_nme USING g_existno INTO l_nmg00,l_nmg01,l_nme00,l_nme01,l_nme02,l_nme03,l_nme12,l_nme21
     IF STATUS OR SQLCA.SQLCODE THEN
       #str CHI-C20017 mod
        #CALL cl_err('sel nme error: ',SQLCA.SQLCODE,1)
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','sel nme error: ',SQLCA.SQLCODE,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('sel nme error: ',SQLCA.SQLCODE,1)
        #END IF
        #end CHI-C20017 mod
        #No.FUN-D60110 ---Mark--- End
        LET g_success='N' 
        EXIT FOREACH
     END IF
     #UPDATE nme_file SET nme16=l_nmg01 WHERE rowid=l_nmg00
     UPDATE nme_file SET nme16 = l_nmg01 
      WHERE nme00 = l_nme00
        AND nme01 = l_nme01
        AND nme03 = l_nme03
        AND nme12 = l_nme12
        AND nme21 = l_nme21
     LET l_cn=l_cn+1
   END FOREACH
   #No.TQC-9A0161  --End  
   LET n5=l_cn
  #No:9590..END
   #-----------AR/AP 帳務處理---------------------------------------------
#--------------------------MOD-BC0152------------------------------------remark
 #start FUN-620021 mark
 ##No.B284 010402 by plum  處理AR/AP刪除npp,npq
  #No.FUN-D60110 ---Mod--- Start
  #SELECT npp00 INTO l_npp00 FROM npp_file
  #  WHERE nppglno=g_existno AND nppsys='AR' AND npp00=3 AND npp011=1
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")
   LET g_sql = "SELECT npp00,nppglno FROM npp_file ",
               " WHERE ",tm.wc2 CLIPPED,
               "   AND nppsys='AR' AND npp00=3 AND npp011=1"
   PREPARE p591_npp001 FROM g_sql
   DECLARE p591_npp00 CURSOR FOR p591_npp001
   FOREACH p591_npp00 INTO l_npp00,g_existno
  #No.FUN-D60110 ---Mod--- End
      IF l_npp00=3 THEN
         DECLARE cur_del CURSOR FOR
          SELECT npp01 FROM npp_file
           WHERE nppglno=g_existno AND nppsys='AP' AND npp00=3 AND npp011=1
         FOREACH cur_del INTO l_npp01
           DELETE FROM npq_file
            WHERE npq01=l_npp01 AND npqsys='AP' AND npq00=3 AND npq011=1
         END FOREACH
         DELETE FROM npp_file
          WHERE nppglno=g_existno AND nppsys='AP' AND npp00=3 AND npp011=1
      END IF
   END FOREACH   #No.FUN-D60110   Add
 ##No.B284..end
 #end FUN-620021 mark
#--------------------------MOD-BC0152------------------------------------remark
  #UPDATE apf_file SET apf43 = NULL, apf44 = NULL WHERE apf44 = g_existno  #No.FUN-D60110  Mark
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")   #No.FUN-D60110  Add
   LET g_sql = " UPDATE apf_file SET apf43 = NULL, apf44 = NULL WHERE ",tm.wc2 CLIPPED   #No.FUN-D60110  Add
   PREPARE p591_upd_apf FROM g_sql
   EXECUTE p591_upd_apf
   LET n6 = SQLCA.SQLERRD[3]
   #----------------------------------------------------------------------
   #************** NO:0147 modify in 99/05/14 *******************#
  #UPDATE ola_file SET ola28=NULL,ola33=NULL WHERE ola28=g_existno   #No.FUN-D60110  Mark
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","ola28")   #No.FUN-D60110  Add
   LET g_sql = " UPDATE ola_file SET ola28=NULL,ola33=NULL WHERE ",tm.wc2 CLIPPED   #No.FUN-D60110  Add
   PREPARE p591_upd_ola FROM g_sql
   EXECUTE p591_upd_ola
   LET n7 = SQLCA.SQLERRD[3]
  #UPDATE ole_file SET ole14=NULL,ole13=NULL WHERE ole14=g_existno   #No.FUN-D60110  Mark
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","ole14")   #No.FUN-D60110  Add
   LET g_sql = " UPDATE ole_file SET ole14=NULL,ole13=NULL WHERE ",tm.wc2 CLIPPED   #No.FUN-D60110  Add
   PREPARE p591_upd_ole FROM g_sql
   EXECUTE p591_upd_ole
   LET n8 = SQLCA.SQLERRD[3]
  #UPDATE olc_file SET olc23=NULL,olc24=NULL WHERE olc23=g_existno
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","olc23")   #No.FUN-D60110  Add
   LET g_sql = "UPDATE olc_file SET olc23=NULL,olc24=NULL WHERE ",tm.wc2 CLIPPED   #No.FUN-D60110  Add
   PREPARE p591_upd_olc FROM g_sql
   EXECUTE p591_upd_olc
   LET n9 = SQLCA.SQLERRD[3]
   #*************************************************************#
   #***********************
#FUN-A70139--mod--str--
# #FUN-A60056--mod--str--
# #UPDATE oga_file SET oga907=NULL WHERE oga907= g_existno
#   LET g_sql=" SELECT DISTINCT omb44 ",
#             "  FROM omb_file,oma_file",
#             " WHERE oma01 = omb01",
#             "   AND oma33 = '",g_existno,"'"  
#   PREPARE sel_omb44 FROM g_sql
#   DECLARE sel_omb44_cs CURSOR FOR sel_omb44
#  FOREACH sel_omb44_cs INTO l_omb44
   LET n10 = 0    #TQC-C10008
   LET g_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y' ",
               "   AND azw02 = '",g_legal,"'"
   PREPARE sel_azw01_pre FROM g_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
   FOREACH sel_azw01_cur INTO l_azw01
#FUN-A70139--mod--end
      IF STATUS OR SQLCA.SQLCODE THEN
       #str CHI-C20017 mod
         #CALL cl_err('sel omb error: ',SQLCA.SQLCODE,1)   #FUN-A70139
         #CALL cl_err('sel azw error: ',SQLCA.SQLCODE,1)
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','sel azw error: ',SQLCA.SQLCODE,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('sel azw error: ',SQLCA.SQLCODE,1)
        #END IF
        #end CHI-C20017 mod
        #No.FUN-D60110 ---Mark--- Start
         LET g_success='N' EXIT FOREACH
      END IF
     #LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oga_file'),   #FUN-A70139
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","oga907")   #No.FUN-D60110  Add
      LET g_sql = "UPDATE ",cl_get_target_table(l_azw01,'oga_file'),
                  "   SET oga907=NULL ",
                 #" WHERE oga907= '",g_existno,"'"   #No.FUN-D60110   Mark
                  " WHERE ",tm.wc2 CLIPPED           #No.FUN-D60110   Add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     #CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql  #FUN-A70139
      CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql  #FUN-A70139
      PREPARE upd_oga FROM g_sql
      EXECUTE upd_oga
      LET n10 = n10 + SQLCA.SQLERRD[3]  #TQC-C10008
   END FOREACH
  #FUN-A70139--mark--str--不需要oma33的值來實現跨庫,因此這部分還是還原至上方
  ######從上面拉下來,先更新oga_file再更新oma33
  #UPDATE oma_file SET oma33=NULL WHERE oma33=g_existno
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err3("upd","oma_file",g_existno,"",STATUS,"","(upd oma33)",1)  
  #      LET g_success='N' RETURN
  #   END IF
  #LET n1 = SQLCA.SQLERRD[3]
  #FUN-A70139--mark--end
  #FUN-A60056--mod--end
  #LET n10= SQLCA.SQLERRD[3]    #TQC-C10008 mark
   #***********************
   #--FUN-A60007 start---
  #UPDATE oct_file SET oct08=NULL WHERE oct08=g_existno AND oct08 = '0'     #MOD-A80015 mark
  #UPDATE oct_file SET oct08=NULL WHERE oct08=g_existno AND oct00 = '0'     #MOD-A80015   #No.FUN-D60110   Mark
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","oct08")   #No.FUN-D60110  Add
   LET g_sql = "UPDATE oct_file SET oct08=NULL WHERE oct00 = '0' AND ",tm.wc2 CLIPPED   #No.FUN-D60110  Add
   PREPARE p591_upd_oct FROM g_sql
   EXECUTE p591_upd_oct
   LET n11= SQLCA.SQLERRD[3]
   #--FUN-A60007 end---
  #IF n1+n2+n3+n4+n5+n6+n7+n8+n9+n10 <=0 THEN LET g_success = 'N' RETURN END IF #FUN-A60007
   IF n1+n2+n3+n4+n5+n6+n7+n8+n9+n10+n11 <=0 THEN LET g_success = 'N' RETURN END IF #FUN-A60007
   #----------------------------------------------------------------------
     #No.FUN-D60110 ---Mod--- Start
     #UPDATE npp_file
     #   SET npp03=NULL,nppglno=NULL,npp06=NULL,npp07=NULL
     # WHERE nppglno=g_existno
     #   #No.FUN-670047 --begin
     #   AND npptype = '0'
     #   AND npp07 = g_ooz.ooz02b
     #   #No.FUN-670047 --end
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")   #No.FUN-D60110  Add
      LET g_sql = "UPDATE npp_file SET npp03=NULL,nppglno=NULL,npp06=NULL,npp07=NULL",
                  " WHERE ",tm.wc2 CLIPPED,
                  "   AND npptype = '0'",
                  "   AND npp07 = '",g_ooz.ooz02b,"'"
      PREPARE p591_npp_upd FROM g_sql
      EXECUTE p591_npp_upd
     #No.FUN-D60110 ---Mod--- Start
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
        #str CHI-C20017 mod
#        CALL cl_err('(upd npp03)',STATUS,1)  #No.FUN-660116
         #CALL cl_err3("upd","npp_file",g_existno,"",SQLCA.sqlcode,"","(upd npp03)",1)   #No.FUN-660116
         #LET g_success='N' RETURN 
         LET g_success='N'
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(upd npp03)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err3("upd","npp_file",g_existno,"",SQLCA.sqlcode,"","(upd npp03)",1)
        #   RETURN
        #END IF
        #end CHI-C20017 mod
        #No.FUN-D60110 ---Mark--- End
      END IF
  #UPDATE oct_file SET oct08=NULL WHERE oct081=g_existno1 AND oct08 = '1' #FUN-A60007  #MOD-A80015 mark
  #UPDATE oct_file SET oct08=NULL WHERE oct08=g_existno1 AND oct00 = '1'               #MOD-A80015   #No.FUN-D60110   Add
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","oct08")   #No.FUN-D60110  Add
   LET g_sql = "UPDATE oct_file SET oct08=NULL WHERE oct00 = '0' AND ",tm.wc2 CLIPPED   #No.FUN-D60110  Add
   PREPARE p591_upd_oct1 FROM g_sql
   EXECUTE p591_upd_oct1
  #No.FUN-CB0096 ---start--- Add
  #LET l_time = TIME   #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,l_oma01)
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
 
#No.FUN-670047 --begin
FUNCTION p591_t_1()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n10          LIKE type_file.num10      #No.FUN-680123INTEGER
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npp00       LIKE npp_file.npp00
   DEFINE l_npp01       LIKE npp_file.npp01
   DEFINE l_cn          LIKE type_file.num5       #No.FUN-680123 SMALLINT             #TSC:plum 20040521 No:9590
   DEFINE l_sql         LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(600)            #TSC:plum 20040521 No:9590
   DEFINE l_nmg01       LIKE nmg_file.nmg01       #TSC:plum 20040521 No:9590
 
 
IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
   #LET g_sql="UPDATE ",g_dbs_gl CLIPPED," aba_file  SET abaacti = 'N' ",
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")   #No.FUN-D60110   Add
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
             "   SET abaacti = 'N' ",
               #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
                " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_updaba_p1 FROM g_sql
  #EXECUTE p591_updaba_p1 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
   EXECUTE p591_updaba_p1 USING g_ooz.ooz02c   #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success='N'
      #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
      #No.FUN-D60110 ---Mark--- Start
      #ELSE
      #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      ##end CHI-C20017 mod
      #No.FUN-D60110 ---Mark--- End
   END IF
ELSE
   IF g_bgjob = "N" THEN
      MESSAGE   "Delete GL's Voucher body!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF                      #No.FUN-570156
   #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","abb01")   #No.FUN-D60110   Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
              #" WHERE abb01=? AND abb00=?"   #No.FUN-D60110   Mark
               " WHERE abb00=? AND ",tm.wc2   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_2_p6 FROM g_sql
  #EXECUTE p591_2_p6 USING g_existno1,g_ooz.ooz02c  #No.FUN-D60110   Mark
   EXECUTE p591_2_p6 USING g_ooz.ooz02c             #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del abb)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success='N'
      #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
      #No.FUN-D60110 ---Mark--- Start
      #ELSE
      #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #end CHI-C20017 mod
      #No.FUN-D60110 ---Mark--- End
   END IF
   IF g_bgjob = "N" THEN
      MESSAGE   "Delete GL's Voucher head!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF
   #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")   #No.FUN-D60110   Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
            #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
             " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_2_p7 FROM g_sql
  #EXECUTE p591_2_p7 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
   EXECUTE p591_2_p7 USING g_ooz.ooz02c              #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del aba)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success='N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
   END IF
   IF SQLCA.sqlerrd[3] = 0 THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del aba)','axr-161',1) LET g_success = 'N' RETURN
      #CALL cl_err('(del aba):0',SQLCA.SQLCODE,1) LET g_success = 'N' RETURN
      LET g_success='N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del aba)',SQLCA.SQLCODE,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)',SQLCA.SQLCODE,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
   END IF
   IF g_bgjob = "N" THEN
      MESSAGE   "Delete GL's Voucher desp!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF                     #No.FUN-570156
   #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","abc01")   #No.FUN-D60110   Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'), #FUN-A50102
              #" WHERE abc01 = ? AND abc00 = ? "   #No.FUN-D60110   Mark
               " WHERE abc00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p591_2_p8 FROM g_sql
  #EXECUTE p591_2_p8 USING g_existno1,g_ooz.ooz02b   #No.FUN-D60110   Mark
   EXECUTE p591_2_p8 USING g_ooz.ooz02b   #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del abc)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success='N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
   END IF
#FUN-B40056 --begin
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","tic04")   #No.FUN-D60110   Add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
            #" WHERE tic04=? AND tic00=?"   #No.FUN-D60110   Mark
             " WHERE tic00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p591_2_p10 FROM g_sql
  #EXECUTE p591_2_p10 USING g_existno1,g_ooz.ooz02c   #No.FUN-D60110   Mark
   EXECUTE p591_2_p10 USING g_ooz.ooz02c              #No.FUN-D60110   Add
   IF SQLCA.sqlcode THEN
     #str CHI-C20017 mod
      #CALL cl_err('(del tic)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
      LET g_success='N'
      #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
      #No.FUN-D60110 ---Mark--- Start
      #ELSE
      #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #end CHI-C20017 mod
      #No.FUN-D60110 ---Mark--- End
   END IF
#FUN-B40056 --end
END IF
   IF g_bgjob = "N" THEN
      MESSAGE   "Delete GL's Voucher detail!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980011 add
          VALUES('axrp591',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal) #FUN-980011 add
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE npp_file
  #   SET npp03=NULL,nppglno=NULL,npp06=NULL,npp07=NULL
  # WHERE nppglno=g_existno1
  #   AND npptype = '1'
  #   AND npp07 = g_ooz.ooz02c
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE ",tm.wc2 CLIPPED,
               "   AND npptype = '1'",    
               "   AND npp07 = '",g_ooz.ooz02c,"'"
   PREPARE p591_npp_prep FROM g_sql
   EXECUTE p591_npp_prep
  #No.FUN-D60110 ---Mod--- End
   IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
     #str CHI-C20017 mod
      #CALL cl_err3("upd","npp_file",g_existno1,"",SQLCA.sqlcode,"","(upd npp03)",1)   #No.FUN-660116
      #LET g_success='N' RETURN 
      LET g_success='N'
     #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd npp03)',SQLCA.sqlcode,1)
     #No.FUN-D60110 ---Mark--- Start
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno1,"",SQLCA.sqlcode,"","(upd npp03)",1)
     #   RETURN
     #END IF
     #end CHI-C20017 mod
     #No.FUN-D60110 ---Mark--- End
   END IF
  #No.FUN-CB0096 ---start--- Add
  #LET l_time = TIME   #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','11.',g_id,'2',l_time,g_existno,l_oma01)
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
#No.FUN-670047 --end
#Patch....NO.TQC-610037 <001> #

#No.FUN-D60110 ---Add--- Start
FUNCTION p591_existno_chk()
   DEFINE   l_chk_bookno       LIKE type_file.num5    
   DEFINE   l_chk_bookno1      LIKE type_file.num5    
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01 
   DEFINE   l_aba00            LIKE aba_file.aba00 
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

   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")
   LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti,aba20,aba01 ",   
             "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),
             " WHERE aba00 = ? AND aba06='AR' AND ",tm.wc2 CLIPPED
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE p591_t_p1 FROM g_sql
   DECLARE p591_t_c1 CURSOR FOR p591_t_p1
   IF STATUS THEN
      CALL s_errmsg('decl aba_cursor:','','',STATUS,1)
      LET g_success = 'N'
   END IF
   OPEN p591_t_c1 USING g_ooz.ooz02b
   FOREACH p591_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
                        l_abaacti,l_aba20,g_existno
      IF STATUS THEN
         CALL s_errmsg('sel aba:','','',STATUS,1) 
         LET g_success = 'N'
      END IF
      IF l_abaacti = 'N' THEN
         CALL s_errmsg('sel aba:','','','mfg8001',1)   
         LET g_success = 'N'
      END IF
      IF l_aba20 MATCHES '[Ss1]' THEN
         CALL s_errmsg('sel aba:','','','mfg3557',1)  
         LET g_success = 'N'
      END IF
      #---增加判斷會計帳別之關帳日期
      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'),
                " WHERE aaa01='",l_aba00,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE p591_x_gl_p1 FROM g_sql
      DECLARE p591_c_gl_p1 CURSOR FOR p591_x_gl_p1
      OPEN p591_c_gl_p1
      FETCH p591_c_gl_p1 INTO l_aaa07
      IF gl_date <= l_aaa07 THEN
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
      #重新抓取關帳日期
       LET g_sql ="SELECT ooz09 FROM ooz_file ",
                  " WHERE ooz00 = '0'"
       PREPARE t600_ooz09_p1 FROM g_sql
       EXECUTE t600_ooz09_p1 INTO g_ooz.ooz09
       IF gl_date < g_ooz.ooz09 THEN   
         CALL s_errmsg('sel aba:','','','aap-027',1)  
         LET g_success = 'N'
      END IF 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM amd_file
       WHERE amd28 = g_existno
      IF l_cnt > 0 THEN
         CALL s_errmsg('sel aba:','','','amd-030',1) 
         LET g_success = 'N'
      END IF 
   END FOREACH
   IF g_aza.aza63 = 'Y' THEN
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")
      LET g_sql = "SELECT npp07,nppglno FROM npp_file ",
                  " WHERE npp01 IN (SELECT npp01 FROM npp_file",
                  "                  WHERE npp07 = '",p_acc,"'",
                  "                    AND ",tm.wc2 CLIPPED,
                  "                    AND npptype = '0')",
                  "   AND npp011 IN (SELECT npp011 FROM npp_file",
                  "                   WHERE npp07 = '",p_acc,"'",
                  "                     AND ",tm.wc2 CLIPPED,
                  "                     AND npptype = '0')",
                  "   AND npp00  IN (SELECT npp00  FROM npp_file",
                  "                   WHERE npp07 = '",p_acc,"'",
                  "                     AND ",tm.wc2 CLIPPED,
                  "                     AND npptype = '0')",
                  "   AND npptype = '1' AND nppsys = 'AR'"
      PREPARE p591_npp07_prep FROM g_sql
      DECLARE p591_npp07_p CURSOR FOR p591_npp07_prep
      FOREACH p591_npp07_p INTO l_npp07,l_nppglno
         IF STATUS THEN
            CALL s_errmsg('sel npp_file','','',STATUS,1)
            RETURN
         END IF
         LET g_ooz.ooz02c = l_npp07
         LET g_existno1 = l_nppglno
         IF cl_null(g_existno1_str) THEN 
               LET g_existno1_str = "'",l_nppglno,"'"
         ELSE
               LET g_existno1_str = g_existno1_str,",'",l_nppglno,"'"
         END IF
         DISPLAY l_npp07 TO FORMONLY.p_acc1
         DISPLAY l_nppglno TO FORMONLY.g_existno1
         
         LET g_sql="SELECT aba00,aba02,aba03,aba04,aba19,abapost,abaacti,aba20 ",  
                   " FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                   " WHERE aba01 = ? AND aba00 = ? AND aba06='AR'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE p591_t_p2 FROM g_sql
         DECLARE p591_t_c2 CURSOR FOR p591_t_p2
         IF STATUS THEN
            CALL s_errmsg('decl aba_cursor:','','',STATUS,1) 
            LET g_success = 'N'
         END IF
         OPEN p591_t_c2 USING g_existno1,g_ooz.ooz02c
         FOREACH p591_t_c2 INTO l_aba00,gl_date,gl_yy,gl_mm,l_conf,l_abapost,
                                l_abaacti,l_aba20  
            IF STATUS THEN
               CALL s_errmsg('sel aba:','','',STATUS,1)  
               LET g_success = 'N'
            END IF
            IF l_abaacti = 'N' THEN
               CALL s_errmsg('sel aba:','','','mfg8001',1) 
               LET g_success = 'N'
            END IF
            IF l_aba20 MATCHES '[Ss1]' THEN
               CALL s_errmsg('sel aba:','','','mfg3557',1)
               LET g_success = 'N'
            END IF
            #---增加判斷會計帳別之關帳日期
            LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(g_plant_new,'aaa_file'), 
                      " WHERE aaa01='",l_aba00,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
            PREPARE p591_x_gl_p2 FROM g_sql
            DECLARE p591_c_gl_p2 CURSOR FOR p591_x_gl_p2
            OPEN p591_c_gl_p2
            FETCH p591_c_gl_p2 INTO l_aaa07
            IF gl_date <= l_aaa07 THEN
               CALL s_errmsg('',gl_date,'','agl-200',1) 
               LET g_success = 'N'
            END IF
            IF l_abapost = 'Y' THEN
               CALL s_errmsg('',g_existno1,'','aap-130',1)
               LET g_success = 'N'
            END IF
            IF l_conf ='Y' THEN
               CALL s_errmsg('',g_existno1,'','aap-026',1)
               LET g_success = 'N'
            END IF
            IF gl_date < g_ooz.ooz09 THEN
               CALL s_errmsg('',gl_date,'','aap-027',1)  
               LET g_success = 'N'
            END IF
         END FOREACH
      END FOREACH
      LET g_existno1_str = "g_existno IN (",g_existno1_str,")"
   END IF
END FUNCTION
#No.FUN-D60110 ---Add--- End
