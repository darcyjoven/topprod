# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gxrp610.4gl
# Descriptions...: 月底重評價傳票拋轉總帳作業
# Date & Author..: 02/03/18 By Danny
# Modify ........: No.FUN-4C0014 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify ........: No.FUN-560190 05/06/23 By wujie 單據編號修改,p_gz修改
# Modify ........: No.FUN-570090 05/08/01 By will 增加取得傳票缺號號碼的功能 
# Modify.........: No.MOD-5C0083 05/12/15 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-5C0015 060102 BY GILL 多 INSERT 異動碼5~10, 關係人
# Modify.........: No.FUN-570123 06/03/02 By saki 批次背景執行
# Modify.........: No.TQC-630102 06/03/10 By 執行時會出現insert錯誤訊息
# Modify.........: No.FUN-660032 06/06/12 By rainy 拋轉摘要預設為Y
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670047 06/08/16 By day 多帳套修改
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改
# Modify.........: No.FUN-680145 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0064 07/01/25 By rainy 無資料時要秀訊息
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.TQC-750011 07/06/22 By rainy npp_file,npq_file 加 npp00 = npq00
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.FUN-810069 08/02/28 By yaofs 項目預算取消abb15的管控 
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理 gja_file->pja_file
# Modify.........: No.FUN-830139 08/04/14 By bnlent 1、預算項目BUG修改 2、s_getbug ->s_getbug1 
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.TQC-860043 08/06/30 By lumx 修改FUN-840139導致的創建臨時表錯誤
# Modify.........: No.MOD-870128 08/07/17 By Sarah aba05應寫入g_today,而不是gl_date
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.MOD-910078 09/01/08 By chenl  修正臨時表建表錯誤。
# Modify.........: No.TQC-940071 09/05/08 By mike 排序字段重復 
# Modify.........: No.FUN-980011 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改QRY相關傳入參數
# Modify.........: No.FUN-980020 09/09/25 By douzh  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-A10006 10/01/18 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No.FUN-9C0072 10/01/19 By vealxu 精簡程式碼
# Modify.........: No:TQC-A40003 10/04/01 By wujie  p610_tmp缺少npp08栏位  
# Modify.........: No.MOD-A40110 10/04/20 By sabrina 在取得分錄底稿資料時,用g_yy及g_mm當條件會無資料,需用日期判斷
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24 預設值 
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:TQC-BA0149 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:MOD-C80073 12/10/09 By yinhy 不可在TRANSACTION中寫到BDL語法(如DROP TABLE)
# Modify.........: No:MOD-CB0120 12/11/13 By jt_chen 調整累加值變數預設，已正確的補到缺號。
# Modify.........: No:MOD-CB0152 12/11/20 By Polly 修正重覆計算已耗用金額問題
# Modify.........: No.FUN-D40112 13/05/06 By lujh 拋總賬的時候需要管控日期不可小于最后一張憑證的日期，選擇缺號時，
#                                                 憑證日期和缺號前一張憑證的日期一致，下面的憑證日期不再作為憑證日期
# Modify.........: No:FUN-D40107 13/05/23 By lujh 背景作業時，系統範圍的傳參沒法無效 

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_npp        	RECORD LIKE npp_file.*
DEFINE g_aba        	RECORD LIKE aba_file.*
DEFINE g_aac        	RECORD LIKE aac_file.*
 DEFINE g_wc,g_sql   	string  #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21    #NO.FUN-680145 VARCHAR(21)
DEFINE g_plant_gl 	LIKE type_file.chr21    #NO.FUN-980059 VARCHAR(21)
DEFINE no_sep		LIKE type_file.chr3     #NO.FUN-680145 VARCHAR(3)     # 傳票單號彙總選擇
DEFINE gl_no	    	LIKE aba_file.aba01     #NO.FUN-680145 VARCHAR(16)    # 傳票單號
DEFINE gl_no1	    	LIKE aba_file.aba01     #NO.FUN-680145 VARCHAR(16)    #No.FUN-670047
DEFINE gl_no_b,gl_no_e	LIKE aba_file.aba01     #NO.FUN-680145 VARCHAR(16)    # Generated 傳票單號 (Begin no and End no)
DEFINE gl_no_b1,gl_no_e1	LIKE aba_file.aba01 #NO.FUN-680145 VARCHAR(16)    #No.FUN-670047
DEFINE gl_date		LIKE type_file.dat      #NO.FUN-680145 DATE
DEFINE g_yy,g_mm	LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE p_type           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)	
DEFINE p_plant          LIKE tmn_file.tmn01     #NO.FUN-680145 VARCHAR(12)	
DEFINE l_plant_old      LIKE tmn_file.tmn01     #NO.FUN-680145 VARCHAR(12)    #No.FUN-570090  --add
DEFINE p_bookno         LIKE aaa_file.aaa01	#NO.FUN-670003
DEFINE p_bookno1        LIKE aaa_file.aaa01	#No.FUN-670047
DEFINE gl_tran		LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
DEFINE g_AR_AP		LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
DEFINE gl_seq    	LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)     # 傳票區分項目
DEFINE g_statu      	LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
DEFINE g_aba01t     	LIKE aac_file.aac01     #NO.FUN-680145 VARCHAR(5)     #No.FUN-560190
DEFINE g_t1         	LIKE aac_file.aac01     #NO.FUN-680145 VARCHAR(5)     #No.FUN-560190 
 
DEFINE   g_cnt          LIKE type_file.num10    #NO.FUN-680145 INTEGER   
DEFINE   g_i            LIKE type_file.num5     #NO.FUN-680145 SMALLINT   #count/index for any purpose
DEFINE   g_j            LIKE type_file.num5,    #NO.FUN-680145 SMALLINT   #No.FUN-570090  --add  
         g_flag         LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)    #No.FUN-570123
         g_change_lang  LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)    #No.FUN-570123
         b_date         LIKE npp_file.npp02,    #MOD-A40110 add  
         e_date         LIKE npp_file.npp02     #MOD-A40110 add 
 
MAIN
   DEFINE p_Row,p_col   LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE ls_date       STRING         #No.FUN-570123
   DEFINE l_tmn02       LIKE tmn_file.tmn02     #No.FUN-670068 
   DEFINE l_tmn06       LIKE tmn_file.tmn06     #No.FUN-670068 
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_type     = ARG_VAL(1)
   LET p_plant    = ARG_VAL(2)
   LET p_bookno   = ARG_VAL(3)
   LET gl_no      = ARG_VAL(4)
   LET ls_date    = ARG_VAL(5)
   LET gl_date    = cl_batch_bg_date_convert(ls_date)
   LET gl_tran   = ARG_VAL(6)
   LET g_bgjob = ARG_VAL(7)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.MOD-C80073  --Begin
   #DROP TABLE agl_tmp_file      
   #CREATE TEMP TABLE agl_tmp_file(
   # tc_tmp00     LIKE type_file.chr1,  
   # tc_tmp01     LIKE type_file.num5,  
   # tc_tmp02     LIKE aba_file.aba01,
   # tc_tmp03     LIKE aaa_file.aaa01)
   #IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF 
   #CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)   #No.FUN-670047             
   #IF STATUS THEN CALL cl_err('create index',STATUS,0) EXIT PROGRAM END IF         
   #No.MOD-C80073  --End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #TQC-940071     
   CALL p610_create_temp_table()  #MOD-C80073
    DECLARE tmn_del CURSOR FOR
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y' 
   LET g_j = 0   #MOD-CB0120 add 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p610_ask()
         IF cl_sure(18,20) THEN
            CALL cl_wait()
            LET g_ooz.ooz02b = p_bookno    # 得帳別
            LET g_ooz.ooz02c = p_bookno1   #No.FUN-670047
            OPEN WINDOW p610_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS
            BEGIN WORK
            CALL p610_t('0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p610_t('1')
            END IF
            CLOSE WINDOW p610_t_w9
            IF g_success = 'Y' THEN
               COMMIT WORK
               IF NOT cl_null(gl_no_b) THEN   #打印第一帳
                  CALL s_m_prtgl(p_plant,g_ooz.ooz02b,gl_no_b,gl_no_e)    #FUN-980020 
               END IF
               IF g_aza.aza63='Y' THEN        #若使用多帳套,則打印第二帳
                  IF NOT cl_null(gl_no_b1) THEN  
                     CALL s_m_prtgl(p_plant,g_ooz.ooz02c,gl_no_b1,gl_no_e1)   #FUN-980020 
                  END IF
               END IF
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p610_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_ooz.ooz02b = p_bookno    # 得帳別
         BEGIN WORK
         CALL p610_t('0')
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL p610_t('1')
         END IF
         IF g_success = "Y" THEN
            COMMIT WORK
            IF NOT cl_null(gl_no_b) THEN   #打印第一帳
               CALL s_m_prtgl(p_plant,g_ooz.ooz02b,gl_no_b,gl_no_e)   #FUN-980020
            END IF
            IF g_aza.aza63='Y' THEN        #若使用多帳套,則打印第二帳
               IF NOT cl_null(gl_no_b1) THEN  
                  CALL s_m_prtgl(p_plant,g_ooz.ooz02c,gl_no_b1,gl_no_e1)    #FUN-980020
               END IF
            END IF
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
   FOREACH tmn_del INTO l_tmn02,l_tmn06 
      DELETE FROM tmn_file
      WHERE tmn01 = p_plant
        AND tmn02 = l_tmn02  
        AND tmn06 = l_tmn06  
   END FOREACH  
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
END MAIN
 
FUNCTION p610_ask()
   DEFINE   li_chk_bookno      LIKE type_file.num5     #NO.FUN-680145 SMALLINT   #No.FUN-670003
   DEFINE   l_aaa07            LIKE aaa_file.aaa07
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1) 
   DEFINE   li_result          LIKE type_file.num5     #NO.FUN-680145 SMALLINT          #No.FUN-560190
   DEFINE   l_cnt              LIKE type_file.num5     #NO.FUN-680145 SMALLINT          #No.FUN-570090  -add       
   DEFINE   lc_cmd             LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(500)         #No.FUN-570123
   DEFINE   p_row,p_col        LIKE type_file.num5,    #NO.FUN-680145 SMALLINT          #No.FUN-570123
            l_sql              STRING            #No.FUN-670003  -add
   DEFINE l_tmn02              LIKE tmn_file.tmn02     #No.FUN-670068 
   DEFINE l_tmn06              LIKE tmn_file.tmn06     #No.FUN-670068 
   DEFINE   l_no               LIKE type_file.chr3     #No.FUN-840125                
   DEFINE   l_no1              LIKE type_file.chr3     #No.FUN-840125                
   DEFINE   l_aac03            LIKE aac_file.aac03     #No.FUN-840125 
   DEFINE   l_aac03_1          LIKE aac_file.aac03     #No.FUN-840125 
   #FUN-D40112--add--str--
   DEFINE   m_date    LIKE aba_file.aba02
   DEFINE   l_aba01   LIKE aba_file.aba01
   DEFINE   l_chr1    LIKE type_file.chr20
   DEFINE   l_chr2    STRING
   #FUN-D40112--add--end--  
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p610_w AT p_row,p_col WITH FORM "gxr/42f/gxrp610"
   ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
 
   IF g_aza.aza63 != 'Y' THEN 
      CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)  
   END IF
   IF cl_null(p_type) THEN #FUN-D40107 add 
      LET p_type  = '1'
   END IF                  #FUN-D40107 add
   LET p_plant = g_ooz.ooz02p 
   LET l_plant_old = p_plant      #No.FUN-570090  --add 
   LET p_bookno= g_ooz.ooz02b 
   LET p_bookno1= g_ooz.ooz02c    #No.FUN-670047
   LET gl_date = g_today
   LET gl_tran = 'Y'  #FUN-660032 add
   LET gl_seq  = '0'
   LET l_chr2 =' '    #FUN-D40112 add
 
   WHILE TRUE                     #No.FUN-570123
      INPUT BY NAME p_type,p_plant,p_bookno,p_bookno1,gl_no,gl_no1,gl_date,gl_tran,g_bgjob   #No.FUN-570123   #No.FUN-670047
        WITHOUT DEFAULTS  ATTRIBUTE(UNBUFFERED)  #No.FUN-570090  --add UNBUFFERED
         BEFORE INPUT
             CALL cl_qbe_init()
   
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
   
            IF cl_null(p_type) OR p_type NOT MATCHES '[12345]' THEN
               NEXT FIELD p_type
            END IF
   
         AFTER FIELD p_plant
            SELECT azp01 FROM azp_file WHERE azp01 = p_plant
            IF STATUS <> 0 THEN 
               NEXT FIELD p_plant
            END IF
            # 得出總帳 database name 
            LET g_plant_new= p_plant    # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
            IF l_plant_old != p_plant THEN  
            FOREACH tmn_del INTO l_tmn02,l_tmn06 
               DELETE FROM tmn_file  
               WHERE tmn01 = l_plant_old 
                 AND tmn02 = l_tmn02
                 AND tmn06 = l_tmn06 
            END FOREACH  
               DELETE FROM agl_tmp_file      
               LET l_plant_old = g_plant_new   
            END IF                         
   
         AFTER FIELD p_bookno
            IF p_bookno IS NULL THEN
               NEXT FIELD p_bookno 
            END IF
             CALL s_check_bookno(p_bookno,g_user,p_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD p_bookno
             END IF 
             LET g_plant_new= p_plant  # 工廠編號                                                                              
             CALL s_getdbs()                                                                                                   
             LET l_sql = "SELECT COUNT(*) ",                                                                                    
                         #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                         "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102                          
                         " WHERE aaa01 = '",p_bookno,"' "                                                                          
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
             PREPARE p610_pre4 FROM l_sql                                                                                       
             DECLARE p610_cur4 CURSOR FOR p610_pre4                                                                             
             OPEN p610_cur4                                                                                                     
             FETCH p610_cur4 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno
            END IF
       
         AFTER FIELD p_bookno1
            IF p_bookno1 IS NULL THEN
               NEXT FIELD p_bookno1 
            END IF
            IF p_bookno1 = p_bookno THEN
               NEXT FIELD p_bookno1 
            END IF
            CALL s_check_bookno(p_bookno1,g_user,p_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD p_bookno1
            END IF 
            LET g_plant_new= p_plant  # 工廠編號                                                                              
            CALL s_getdbs()                                                                                                     
            LET l_sql = "SELECT COUNT(*) ",                                                                                    
                        #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                        "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102                       
                        " WHERE aaa01 = '",p_bookno1,"' "                                                                          
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE p610_pre4_1 FROM l_sql                                                                                       
            DECLARE p610_cur4_1 CURSOR FOR p610_pre4_1                                                                             
            OPEN p610_cur4_1                                                                                                     
            FETCH p610_cur4_1 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno1
            END IF
 
         AFTER FIELD gl_no1
            CALL s_check_no("agl",gl_no1,"","1","aac_file","aac01",p_plant)   #FUN-980094
                 RETURNING li_result,gl_no1
                 IF (NOT li_result) THEN
                     NEXT FIELD gl_no1
                 END IF
                 LET l_no1 = gl_no1                                                        
                 SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1               
                 IF l_aac03_1 != '0' THEN                                                  
                    CALL cl_err(gl_no1,'agl-991',0)                                       
                    NEXT FIELD gl_no1                                                     
                 END IF                                                                  
   
         AFTER FIELD gl_no
            CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",p_plant)   #MOD-5C0083 #FUN-980094
                 RETURNING li_result,gl_no
                 IF (NOT li_result) THEN
                     NEXT FIELD gl_no
                 END IF
           LET l_no = gl_no                                                        
           SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no               
           IF l_aac03 != '0' THEN                                                  
              CALL cl_err(gl_no,'agl-991',0)                                       
              NEXT FIELD gl_no                                                     
           END IF                                                                  
 
         AFTER FIELD gl_date
            IF gl_date IS NULL THEN 
               NEXT FIELD gl_date
            END IF
            SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
            IF gl_date < l_aaa07 THEN    
               CALL cl_err('','axm-164',0) 
               NEXT FIELD gl_date
            END IF
            #------------------------------------------------
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660146
               NEXT FIELD gl_date
            END IF
            #FUN-D40112--add--str--
            IF NOT cl_null(l_chr2) THEN 
               LET l_sql = "SELECT MAX(aba01) FROM aba_file WHERE aba01 < '",l_chr2,"' AND aba01 LIKE '",gl_no,"%' "
               PREPARE aba_pre1 FROM l_sql
               DECLARE aba_cur1 CURSOR FOR aba_pre1
               EXECUTE aba_cur1 INTO l_aba01
                 
               LET m_date = ' '            
               SELECT aba02 INTO m_date FROM aba_file WHERE aba01 = l_aba01
               IF gl_date <> m_date THEN 
                  CALL cl_err(l_aba01,'cgl-017',0)
                  NEXT FIELD gl_date
               END IF                
            END IF 
            #FUN-D40112--add--end--
 
         AFTER INPUT
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF
            LET l_flag='N'
            IF INT_FLAG THEN 
               EXIT INPUT 
            END IF
            IF cl_null(p_plant) THEN 
               LET l_flag='Y'
            END IF
            IF cl_null(p_bookno) THEN
               LET l_flag='Y'
            END IF
            IF gl_no[1,g_doc_len] IS NULL or gl_no[1,g_doc_len] = ' ' THEN
               LET l_flag='Y'
            END IF
            IF cl_null(gl_date) THEN 
               LET l_flag='Y'
            END IF
            IF cl_null(gl_tran) THEN 
               LET l_flag='Y' 
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) 
               NEXT FIELD p_plant
            END IF
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new 
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
             WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660146
               NEXT FIELD gl_date
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            IF INFIELD(gl_no) THEN
            CALL s_getdbs()                                                                                                    
            LET g_dbs_gl=g_dbs_new                                                                                             
            LET g_plant_gl= p_plant   #No.FUN-980059                                                                                             
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')   #No.FUN-840125  #NO.FUN-980059
               RETURNING gl_no  #NO:6842
               DISPLAY BY NAME gl_no
               NEXT FIELD gl_no
            END IF
            IF INFIELD(gl_no1) THEN
               CALL s_getdbs()                                                                                                    
               LET g_dbs_gl=g_dbs_new                                                                                             
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL')   #No.FUN-840125  #No.FUN-980059
               RETURNING gl_no1
               DISPLAY BY NAME gl_no1
               NEXT FIELD gl_no1
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION get_missing_voucher_no           
            IF cl_null(gl_no) AND cl_null(gl_no1) THEN  #No.FUN-670068 add AND cl_null(gl_no1) 
               NEXT FIELD gl_no                   
            END IF                               
            FOREACH tmn_del INTO l_tmn02,l_tmn06 
               DELETE FROM tmn_file
               WHERE tmn01 = p_plant
                 AND tmn02 = l_tmn02  
                 AND tmn06 = l_tmn06  
            END FOREACH  
            DELETE FROM agl_tmp_file     
            CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0) #No.FUN-670068
            SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file     
             WHERE tc_tmp00='Y'              
            IF l_cnt > 0 THEN               
               CALL cl_err(l_cnt,'aap-501',0)   
               #FUN-D40112--add--str--
               LET l_sql = " SELECT tc_tmp02 FROM agl_tmp_file ",
                           "  WHERE tc_tmp00 ='Y'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
               PREPARE sel_tmp_pre   FROM l_sql
               DECLARE sel_tmp  CURSOR FOR sel_tmp_pre
               LET l_chr2 =' '  
               FOREACH sel_tmp INTO l_chr1
                  IF cl_null(l_chr2) THEN
                     LET l_chr2 =l_chr1
                  ELSE
                     LET l_chr2 =l_chr2 CLIPPED,'|',l_chr1
                  END IF
               END FOREACH
               
               LET l_sql = "SELECT MAX(aba01) FROM aba_file WHERE aba01 < '",l_chr2,"' AND aba01 LIKE '",gl_no,"%' "
               PREPARE aba_pre12 FROM l_sql
               DECLARE aba_cur12 CURSOR FOR aba_pre12
               EXECUTE aba_cur12 INTO l_aba01
                 
               LET m_date = ' '            
               SELECT aba02 INTO m_date FROM aba_file WHERE aba01 = l_aba01
               LET gl_date = m_date
               #FUN-D40112--add--end--
            ELSE      
               CALL cl_err('','aap-502',0)     
            END IF                            
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CLOSE WINDOW p610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #TQC-940071  
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gxrp610"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gxrp610','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",p_type CLIPPED ,"'",
                         " '",p_plant CLIPPED ,"'",
                         " '",p_bookno CLIPPED ,"'",
                         " '",gl_no CLIPPED ,"'",
                         " '",gl_date CLIPPED,"'",
                         " '",gl_tran CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gxrp610',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #TQC-940071  
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p610_t(l_npptype)  #No.FUN-670047
   DEFINE l_npptype       LIKE npp_file.npptype  #No.FUN-670047	
   DEFINE l_sql           STRING                 #No.FUN-670047
   DEFINE l_npp		  RECORD LIKE npp_file.*
   DEFINE l_npq		  RECORD LIKE npq_file.*
   DEFINE l_order	  LIKE npp_file.npp01     #NO.FUN-680145 VARCHAR(30)
   DEFINE l_order2        LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(100)
   DEFINE l_name	  LIKE type_file.chr20    #NO.FUN-680145 VARCHAR(20)
   DEFINE l_post          LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
   DEFINE l_remark   	  LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(150)  #No.7319
   DEFINE l_cmd      	  LIKE type_file.chr50    #NO.FUN-680145 VARCHAR(30)
   DEFINE ar_date	  LIKE type_file.dat      #NO.FUN-680145 DATE
   DEFINE ar_glno	  LIKE type_file.chr20    #NO.FUN-680145 VARCHAR(12)
   DEFINE ar_conf	  LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
   DEFINE ar_user  	  LIKE type_file.chr20    #NO.FUN-680145 VARCHAR(10)
   DEFINE l_yy,l_mm       LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_flag          LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
   DEFINE l_cnt0          LIKE type_file.num5     #NO.FUN-6B0064
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   #DEFINE l_npp01       LIKE npp_file.npp01    #TQC-BA0149
   
   #因為若user在input未經傳票日期欄位即按ESC時,會未讀取azn_file
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",
         LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102          
                     "  WHERE aznn01 = '",gl_date,"' ",                               
                     "    AND aznn00 = '",p_bookno,"' "                            
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE aznn_pre1 FROM l_sql                                                 
         DECLARE aznn_cs1 CURSOR FOR aznn_pre1                                        
         OPEN aznn_cs1                                                               
         FETCH aznn_cs1 INTO g_yy,g_mm
      ELSE
         #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",
         LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102          
                     "  WHERE aznn01 = '",gl_date,"' ",                               
                     "    AND aznn00 = '",p_bookno1,"' "                            
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE aznn_pre2 FROM l_sql                                                 
         DECLARE aznn_cs2 CURSOR FOR aznn_pre2                                        
         OPEN aznn_cs2                                                               
         FETCH aznn_cs2 INTO g_yy,g_mm
      END IF
   ELSE
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
   END IF
   IF STATUS THEN
      CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660146
      RETURN  
   END IF
   #No.MOD-C80073  --Begin
   #DROP TABLE p610_tmp
   ##修改npp01,nppglno,npq01,npq11,npq12,npq13,npq14,npq22,npq30
   #CREATE TEMP TABLE p610_tmp(
   #   order1    LIKE npp_file.npp01,
   #   nppsys    LIKE npp_file.nppsys,
   #   npp00     LIKE npp_file.npp00,
   #   npp01     LIKE npp_file.npp01,
   #   npp011    LIKE npp_file.npp011,
   #   npp02     LIKE npp_file.npp02,
   #   npp03     LIKE npp_file.npp03,
   #   npp04     LIKE npp_file.npp04,
   #   npp05     LIKE npp_file.npp05,
   #   npp06     LIKE npp_file.npp06,
   #   npp07     LIKE npp_file.npp07,
   #   nppglno   LIKE npp_file.nppglno,
   #   npptype   LIKE npp_file.npptype, 
   #   npplegal  LIKE npp_file.npplegal, #FUN-980011 add
   #   npp08     LIKE npp_file.npp08,     #No.TQC-A40003
   #   npqsys    LIKE npq_file.npqsys,
   #   npq00     LIKE npq_file.npq00,
   #   npq01     LIKE npq_file.npq01,
   #   npq011    LIKE npq_file.npq011,
   #   npq02     LIKE npq_file.npq02,
   #   npq03     LIKE npq_file.npq03,
   #   npq04     LIKE npq_file.npq04,
   #   npq05     LIKE npq_file.npq05,
   #   npq06     LIKE npq_file.npq06,    
   #   npq07f    LIKE npq_file.npq07f,
   #   npq07     LIKE npq_file.npq07,
   #   npq08     LIKE npq_file.npq08,
   #   npq11     LIKE npq_file.npq11,
   #   npq12     LIKE npq_file.npq12,     
   #   npq13     LIKE npq_file.npq13,
   #   npq14     LIKE npq_file.npq14,
   #   npq15     LIKE npq_file.npq15,    #MOD-910078
   #   npq21     LIKE npq_file.npq21,
   #   npq22     LIKE npq_file.npq22,
   #   npq23     LIKE npq_file.npq23,
   #   npq24     LIKE npq_file.npq24,
   #   npq25     LIKE npq_file.npq25,
   #   npq26     LIKE npq_file.npq26,
   #   npq27     LIKE npq_file.npq27,
   #   npq28     LIKE npq_file.npq28,    
   #   npq29     LIKE npq_file.npq29,
   #   npq30     LIKE npq_file.npq30,
   #   npq31     LIKE npq_file.npq31,
   #   npq32     LIKE npq_file.npq32,
   #   npq33     LIKE npq_file.npq33,
   #   npq34     LIKE npq_file.npq34,
   #   npq35     LIKE npq_file.npq35,
   #   npq36     LIKE npq_file.npq36,
   #   npq37     LIKE npq_file.npq37,
   #   npq930    LIKE npq_file.npq930,
   #   npqtype   LIKE npq_file.npqtype,
   #   npqlegal  LIKE npq_file.npqlegal, #FUN-980011 add
   #   remark1   LIKE type_file.chr1000);
 
   #IF STATUS THEN
   #   CALL cl_err('create tmp',STATUS,1)
   #   CALL cl_batch_bg_javamail("N")         #No.FUN-570123
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #TQC-940071 
   #   EXIT PROGRAM
   #END IF
   #No.MOD-C80073  --End
   #所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   CASE p_type
     WHEN '1'
       LET g_wc = " nppsys= 'AR' AND npp00 = 4 "
     WHEN '2'
       LET g_wc = g_wc CLIPPED," nppsys= 'AP' AND npp00 = 5 "
     WHEN '3'
       LET g_wc = g_wc CLIPPED," nppsys= 'NM' AND npp00 = 13"
     WHEN '4'
       LET g_wc = g_wc CLIPPED," nppsys= 'NM' AND npp00 = 14"
     WHEN '5'
       LET g_wc = g_wc CLIPPED," nppsys= 'NM' AND npp00 = 15"
     OTHERWISE 
       LET g_wc = g_wc CLIPPED," ((nppsys= 'AR' AND npp00 = 4) OR ",
                               "  (nppsys= 'AP' AND npp00 = 5) OR ",
                               "  (nppsys= 'NM' AND npp00 = 13) OR ",
                               "  (nppsys= 'NM' AND npp00 = 14) OR ",
                               "  (nppsys ='NM' AND npp00 = 15))"
   END CASE
 
  IF g_aaz.aaz81 = 'Y' THEN
     IF g_aza.aza63 = 'Y' THEN 
        IF l_npptype = '0' THEN
           #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                       " WHERE aba00 =  '",p_bookno,"'"
        ELSE
     	     #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
             LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                         " WHERE aba00 =  '",p_bookno1,"'"
        END IF
     
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        PREPARE aba11_pre FROM g_sql
        EXECUTE aba11_pre INTO l_aba11
     ELSE 
       SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file 
         WHERE aba00 = p_bookno
     END IF
     
     IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF
     LET g_aba.aba11 = l_aba11
  ELSE 
     LET g_aba.aba11 = ' '        
     
  END IF      
 
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date          #MOD-A40110 add
   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             "  FROM npp_file,npq_file",
             " WHERE (nppglno IS NULL OR nppglno=' ') ",
             "   AND nppsys = npqsys",      
             "   AND npp00 = npq00 ",
             "   AND npp01 = npq01 AND npp011=npq011",
            #"   AND (YEAR(npp02) = ",g_yy," AND MONTH(npp02) = ",g_mm,")",     #MOD-A40110 mark
             "   AND npp02 BETWEEN '",b_date,"' AND '",e_date,"'",              #MOD-A40110 add
             "   AND npptype = npqtype AND npptype = '",l_npptype,"' AND ",g_wc CLIPPED,  #No.FUN-670047
             " ORDER BY npq01,npq06,npq03,npq05,npq24,npq25"
   IF gl_tran = 'N' THEN 
      LET g_sql = g_sql CLIPPED,",npq11,npq12,npq13,npq14,npq36,npq08" #TQC-940071  
   ELSE
      LET g_sql = g_sql CLIPPED,
                  ",npq04,npq11,npq12,npq13,npq14,npq36,npq08" #TQC-940071  
   END IF
   PREPARE p610_1_p0 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p610_1_p0',STATUS,1)
      CALL cl_batch_bg_javamail("N")         #No.FUN-570123
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #TQC-940071   
      EXIT PROGRAM
   END IF
   DECLARE p610_1_c0 CURSOR WITH HOLD FOR p610_1_p0
 
   CALL cl_outnam('gxrp610') RETURNING l_name
   IF l_npptype = '0' THEN
      START REPORT gxrp610_rep TO l_name
   ELSE
      START REPORT gxrp610_1_rep TO l_name
   END IF
   LET g_success = 'Y'
   LET l_cnt0 = 0   #FUN-6B0064
   WHILE TRUE
      FOREACH p610_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         IF gl_tran = 'N' THEN 
              LET l_npq.npq04 = NULL
              LET l_remark = l_npq.npq11 clipped,l_npq.npq12 clipped,
                             l_npq.npq13 clipped,l_npq.npq14 clipped,
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             l_npq.npq36 clipped,l_npq.npq08 clipped  #No.FUN-830139 npq15->npq36
         ELSE LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                             l_npq.npq12 clipped,l_npq.npq13 clipped,
                             l_npq.npq14 clipped,
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             l_npq.npq36 clipped, #No.FUN-830139 npq15->npq36
                             l_npq.npq08 clipped
         END IF
         LET l_order = l_npp.npp01    # 依單號
         INSERT INTO p610_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         IF SQLCA.SQLCODE THEN 
            CALL cl_err3("ins","p610_tmp","","",STATUS,"","l_order",1)   #No.FUN-660146
         END IF
         LET l_cnt0 = l_cnt0 + 1  #FUN-6B0064
      END FOREACH
      #LET l_npp01 = NULL   #No.TQC-BA0149
      DECLARE p610_tmpcs CURSOR FOR 
           SELECT * FROM p610_tmp
           ORDER BY order1,npq06,npq03,npq05, 
                    npq24,npq25,remark1,npq01
      FOREACH p610_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
          IF STATUS THEN
             CALL cl_err('order:',STATUS,1) EXIT FOREACH
          END IF
          IF l_npptype = '0' THEN
             OUTPUT TO REPORT gxrp610_rep(l_order,l_npp.*,l_npq.*,l_remark)
          ELSE
             OUTPUT TO REPORT gxrp610_1_rep(l_order,l_npp.*,l_npq.*,l_remark)
          END IF
      END FOREACH  
      EXIT WHILE
   END WHILE
   IF l_npptype = '0' THEN
      FINISH REPORT gxrp610_rep
   ELSE
      FINISH REPORT gxrp610_1_rep
   END IF
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
   IF l_cnt0 = 0 THEN
     CALL cl_err('','mfg3160',1)
     LET g_success = 'N'
   END IF
   #DROP TABLE p610_tmp  #MOD-C80073 mark
END FUNCTION
 
REPORT gxrp610_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01     #NO.FUN-680145 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5     #NO.FUN-680145 SMALLINT	# 傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE oeb_file.oeb13   #NO.FUN-680145 DEC(20,6)  #FUN-4C0014
  DEFINE l_remark       LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(150)  #No.7319
  DEFINE l_p1           LIKE type_file.chr2     #NO.FUN-680145 VARCHAR(02)
  DEFINE l_p2           LIKE type_file.num5     #NO.FUN-680145 SMALLINT
  DEFINE l_p3           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
  DEFINE l_p4           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
  DEFINE n1,n2          LIKE type_file.num5     #NO.FUN-680145 SMALLINT 
  DEFINE amtd,amtc      LIKE npq_file.npq07
  DEFINE li_result      LIKE type_file.num5     #NO.FUN-680145 SMALLINT #No.FUN-560190
  DEFINE l_missingno    LIKE aba_file.aba01  #No.FUN-570090  --add 
  DEFINE l_flag1        LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)              #No.FUN-570090  --add
  DEFINE l_npp08        LIKE npp_file.npp08     #MOD-A80017 Add
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                    l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   BEFORE GROUP OF l_order
   #缺號使用           
   LET l_flag1='N'               
   LET l_missingno = NULL       
   LET g_j=g_j+1               
   SELECT tc_tmp02 INTO l_missingno      
     FROM agl_tmp_file                   
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'    
      AND tc_tmp03=p_bookno  #No.FUN-670047
   IF NOT cl_null(l_missingno) THEN         
      LET l_flag1='Y'                      
      LET gl_no=l_missingno               
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no         
                                AND tc_tmp03 = p_bookno  #No.FUN-670047
   END IF            
                   
   #缺號使用完，再在流水號最大的編號上增加     
   IF l_flag1='N' THEN                        
     CALL s_auto_assign_no("agl",gl_no,gl_date,"","","",p_plant,"",g_ooz.ooz02b) #FUN-980094
       RETURNING li_result,gl_no   
     IF (NOT li_result) THEN                                                   
         LET g_success = 'N'
     END IF                                                                    
     PRINT "Get max TR-no:",gl_no," Return code(g_i):",g_i
    #DISPLAY "Insert G/L voucher no:",gl_no AT 1,1   #CHI-A70049 mark
     PRINT "Insert aba:",g_ooz.ooz02b,' ',gl_no,' From:',l_order
   END IF  #No.FUN-570090  -add      
     #LET g_sql="INSERT INTO ",g_dbs_gl CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
                        " abamksg,abapost,",
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        " abasign,abadays,abaprit,abasmax,abasseq,aba11,",     #FUN-840211 add aba11
                        " abalegal,abaoriu,abaorig,aba21,aba24 ) ", #FUN-980011 add #FUN-A10036  FUN-A10006 #MOD-A80136 add aba24
                 " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?, ?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?)"  #FUN-Z10036 #FUN-840211 add ?  #FUN-980011 add FUN-A10006 add ? #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p610_1_p4 FROM g_sql
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     LET g_aba01t = gl_no[1,g_doc_len]   #No.FUN-560190 
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t    
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN 
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF
     CASE p_type
       WHEN '1' LET l_p1='AR'
       WHEN '2' LET l_p1='AP'
       WHEN '3' LET l_p1='NM'
       WHEN '4' LET l_p1='NM'
       WHEN '5' LET l_p1='NM'
     END CASE
     LET l_p2='0'
     LET l_p3='N'
     LET l_p4='Y'
     EXECUTE p610_1_p4 USING
        g_ooz.ooz02b,gl_no,gl_date,g_yy,g_mm,g_today,   #MOD-870128
        l_p1,l_order,l_p2,l_p2,l_p3,l_p3,l_p2,
        g_aba.abamksg,l_p3,
        l_p2,l_p4,g_user,g_grup,g_today,
        g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2
        ,g_aba.aba11   #FUN-840211 add aba11
        ,g_legal,g_user,g_grup,l_npp.npp08,g_user  #FUN-A10036       #FUN-980011 add  FUN-A10006 #MOD-A80136 add g_user 
     IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aba_file",g_ooz.ooz02b,gl_no,SQLCA.sqlcode,"","ins aba",1)   #No.FUN-660146
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570090  --add   
                            AND tmn06 = p_bookno  #No.FUN-670047
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   AFTER GROUP OF l_npq.npq01
     SELECT SUM(npq07) INTO amtd FROM npq_file 
      WHERE npq01 = l_npp.npp01 AND npq06 = '1' #--->借方合計
        AND npqsys= l_npp.nppsys
        AND npq011= l_npp.npp011
        AND npqtype=l_npp.npptype    #No.FUN-670047 
     SELECT SUM(npq07) INTO amtc FROM npq_file 
      WHERE npq01 = l_npp.npp01 AND npq06 = '2' #--->貸方合計
        AND npqsys= l_npp.nppsys
        AND npq011= l_npp.npp011
        AND npqtype=l_npp.npptype    #No.FUN-670047 
     IF cl_null(amtd) THEN LET amtd = 0 END IF
     IF cl_null(amtc) THEN LET amtc = 0 END IF
     #-->借貸要平
     IF amtd != amtc THEN
        CALL cl_err(l_npp.npp01,'aap-058',1) LET g_success='N'
     END IF
     #-->科目要對
     SELECT COUNT(*) INTO n1 FROM npq_file
      WHERE npq01 = l_npp.npp01 AND npqsys = l_npp.nppsys 
        AND npq011= l_npp.npp011
        AND npqtype=l_npp.npptype    #No.FUN-670047 
     SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
      WHERE npq01 = l_npp.npp01 AND npqsys = l_npp.nppsys
        AND npq011= l_npp.npp011
        AND npq03 = aag01 AND aag03 = '2' AND aag07 IN ('2','3')
        AND npqtype=l_npp.npptype    #No.FUN-670047 
        AND aag00 = g_ooz.ooz02b   #FUN-740009
     IF n1<>n2 THEN
        CALL cl_err(l_npp.npp01,'aap-262',1) LET g_success='N'
     END IF
     CALL p610_chknpq(l_npp.npp01,l_npp.nppsys,l_npp.npp011,l_npp.npp00,l_npp.npptype) 
 
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no,
                         npp06 = p_plant,npp07=p_bookno
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype='0'   #No.FUN-670047 
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno",1)   #No.FUN-660146
        LET g_success = 'N'  
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
    #DISPLAY "Seq:",l_seq AT 2,1   #CHI-A70049 mark
     #LET g_sql = "INSERT INTO ",g_dbs_gl CLIPPED,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,abb24,abb25,",              #No.FUN-810069
 
                        " abb31,abb32,abb33,abb34,abb35,abb36,abb37",
 
                        ", abblegal ", #FUN-980011 add
 
                        " )",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?",                       #No.FUN-810069
                 "       ,?,?,?,?,?,?,? ", #FUN-5C0015 BY GILL
                 "       ,? ) "            #FUN-980011 add
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p610_1_p5 FROM g_sql
     EXECUTE p610_1_p5 USING 
                g_ooz.ooz02b,gl_no,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                                #No.FUN-810069
 
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,
 
                g_legal #FUN-980011 add
 
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",g_ooz.ooz02b,gl_no,SQLCA.sqlcode,"","ins abb",1)   #No.FUN-660146
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
     CALL s_flows('2',g_ooz.ooz02b,gl_no,gl_date,l_p3,'',TRUE)   #No.TQC-B70021   

      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED,"aba_file SET aba08=?,aba09=?  ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                    " SET aba08=?,aba09=?  ",
                    "    ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p610_1_p6 FROM g_sql
      EXECUTE p610_1_p6 USING l_debit,l_credit,l_npp08,gl_no,g_ooz.ooz02b  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aba_file",g_ooz.ooz02b,gl_no,SQLCA.sqlcode,"","upd aba08/09",1)   #No.FUN-660146
         LET g_success = 'N'
      END IF
      PRINT
      LET gl_no[4,12]=''
      LET gl_no[g_no_sp-1,g_no_ep]=''  
END REPORT
 
FUNCTION p610_chknpq(p_no,p_sys,p_npq011,p_npq00,p_npqtype)  #No.FUN-670047  
   DEFINE p_npqtype LIKE npq_file.npqtype  #No.FUN-670047
   DEFINE p_no     LIKE npp_file.npp01
   DEFINE p_sys    LIKE npp_file.nppsys
   DEFINE p_npq011 LIKE npq_file.npq011
   DEFINE p_npq00  LIKE npq_file.npq00     #add 030428 NO.A058
   DEFINE l_npp    RECORD LIKE npp_file.*
   DEFINE l_npq    RECORD LIKE npq_file.*
   DEFINE l_aag    RECORD LIKE aag_file.*
   DEFINE l_cnt    LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_apz02p LIKE apz_file.apz02p
   DEFINE l_bookno LIKE apz_file.apz02b
   DEFINE l_dbs_gl LIKE type_file.chr21    #NO.FUN-680145 VARCHAR(21)
   DEFINE l_aaz72  LIKE aaz_file.aaz72
   DEFINE l_dept   LIKE gem_file.gem01
   DEFINE l_azn02  LIKE azn_file.azn02
   DEFINE l_azn04  LIKE azn_file.azn04
   DEFINE l_afb04  LIKE afb_file.afb04
   DEFINE l_afb07  LIKE afb_file.afb07
   DEFINE l_afb15  LIKE afb_file.afb15
   DEFINE l_afb041 LIKE afb_file.afb041    #FUN-810069
   DEFINE l_afb042 LIKE afb_file.afb042    #FUN-810069
   DEFINE l_flag   LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_amt,total_t  LIKE npq_file.npq07
   DEFINE l_tol,l_tol1   LIKE npq_file.npq07
   DEFINE l_buf,l_buf1   LIKE type_file.chr50    #NO.FUN-680145 VARCHAR(40)
   DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(600)
 
 
   CASE 
     WHEN p_sys='AP'
       IF p_npqtype = '0' THEN
          SELECT apz02p,apz02b INTO l_apz02p,l_bookno FROM apz_file WHERE apz00='0'
       ELSE
          SELECT apz02p,apz02c INTO l_apz02p,l_bookno FROM apz_file WHERE apz00='0'
       END IF
     WHEN p_sys='AR'
       IF p_npqtype = '0' THEN
          SELECT ooz02p,ooz02b INTO l_apz02p,l_bookno FROM ooz_file WHERE ooz00='0'
       ELSE
          SELECT ooz02p,ooz02c INTO l_apz02p,l_bookno FROM ooz_file WHERE ooz00='0'
       END IF
     WHEN p_sys='NM'
       IF p_npqtype = '0' THEN
          SELECT nmz02p,nmz02b INTO l_apz02p,l_bookno FROM nmz_file WHERE nmz00='0'
       ELSE
          SELECT nmz02p,nmz02c INTO l_apz02p,l_bookno FROM nmz_file WHERE nmz00='0'
       END IF
   END CASE
   LET g_plant_new = l_apz02p
   CALL s_getdbs()
   LET l_dbs_gl=g_dbs_new 
 
   #-->取總帳系統參數
   #LET l_sql = "SELECT aaz72  FROM ",l_dbs_gl,"aaz_file WHERE aaz00 = '0' "
   LET l_sql = "SELECT aaz72  FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE chk_pregl FROM l_sql
   DECLARE chk_curgl CURSOR FOR chk_pregl
   OPEN chk_curgl 
   FETCH chk_curgl INTO l_aaz72 
   IF SQLCA.sqlcode THEN LET l_aaz72 = '1' END IF
 
   DECLARE npq_cur CURSOR FOR
    SELECT npq_file.*,aag_file.*
      FROM npq_file LEFT OUTER JOIN aag_file ON npq_file.npq03=aag_file.aag01 
     WHERE npq01 = p_no     AND npqsys = p_sys 
       AND npq011= p_npq011 
       AND npq00 = p_npq00      #add 030428 NO.A058
       AND npqtype=p_npqtype    #No.FUN-670047 
       AND aag00 = l_bookno       #FUN-740009  
   IF STATUS THEN 
      CALL cl_err('dec cursor',STATUS,1) LET g_success='N' RETURN 
   END IF
   
   FOREACH npq_cur INTO l_npq.*,l_aag.*
      ##(若科目有部門管理者,應check部門欄位)
      IF l_aag.aag05='Y' THEN  #部門明細管理
         IF cl_null(l_npq.npq05) THEN 
            CALL cl_err(l_npq.npq03,'aap-287',1) LET g_success='N' RETURN 
         END IF
         SELECT gem01 FROM gem_file WHERE gem01=l_npq.npq05 AND gemacti='Y' 
         IF STATUS THEN
            CALL cl_err3("sel","gem_file",l_npq.npq05,"","aap-039","","",1)   #No.FUN-660146
            LET g_success='N' RETURN  
         END IF
         #若有部門管理應Check其部門是否為拒絕部門
         IF l_aaz72 = '2' THEN 
            SELECT COUNT(*) INTO l_cnt FROM aab_file 
             WHERE aab01 = l_npq.npq03   #科目
               AND aab02 = l_npq.npq05   #部門
               AND aab00 = l_bookno      #FUN-740009
            IF l_cnt = 0 THEN
               CALL cl_err(l_npq.npq03,'agl-209',1) LET g_success='N' RETURN
            END IF
         ELSE 
            SELECT COUNT(*) INTO l_cnt FROM aab_file 
             WHERE aab01 = l_npq.npq03   #科目
               AND aab02 = l_npq.npq05   #部門
               AND aab00 = l_bookno      #FUN-740009
            IF l_cnt > 0 THEN
               CALL cl_err(l_npq.npq03,'agl-207',1) LET g_success='N' RETURN
            END IF
         END IF 
      ELSE     #針對不做部門管理,其部門應為空白
         IF NOT cl_null(l_npq.npq05) THEN
            CALL cl_err(l_npq.npq03,'agl-216',1) LET g_success='N' RETURN
         END IF 
      END IF
 
      #若科目須做預算控制，預算編號不可空白
      IF l_aag.aag21 = 'Y' THEN
            #考慮是否預算超限
            SELECT * INTO l_npp.* FROM npp_file WHERE npp01 = p_no AND npptype = p_npptype #No.FUN-670047
            IF g_aza.aza63 = 'Y' THEN
               IF l_npp.npptype = '0' THEN
                  SELECT aznn02,aznn04 INTO l_azn02,l_azn04 FROM aznn_file     #取得第一帳套的會計期間
                   WHERE aznn01 = l_npp.npp02 and aznn00=p_bookno
               ELSE
                  SELECT aznn02,aznn04 INTO l_azn02,l_azn04 FROM aznn_file     #取得第二帳套的會計期間
                   WHERE aznn01 = l_npp.npp02 and aznn00=p_bookno1
               END IF
            ELSE
               SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
                WHERE azn01 = l_npp.npp02
            END IF
            IF cl_null(l_npq.npq05) THEN 
               LET l_dept='@'
            ELSE
               LET l_dept = l_npq.npq05
            END IF
            IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF #MOD-CB0152
            IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF #MOD-CB0152
            SELECT afb04,afb15,afb041,afb042 INTO l_afb04,l_afb15,l_afb041,l_afb042 FROM afb_file   #FUN-810069
             WHERE afb00 = l_bookno AND afb01 = l_npq.npq36     #No.FUN-830139
              #AND afb02 = l_npq.npq03 AND afb03 = l_azn02 AND afb04 = l_dept    #MOD-CB0152 mark
               AND afb02 = l_npq.npq03 AND afb03 = l_azn02 AND afb041 = l_dept   #MOD-CB0152
              #AND afb041 = l_npq.npq05 AND afb042 = l_npq.npq08        #FUN-810069  #MOD-CB0152 mark
               AND afb04 = l_npq.npq35 AND afb042 = l_npq.npq08                      #MOD-CB0152
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","afb_file",l_bookno,l_npq.npq36,"agl-139","","",1) #No.FUN-660146 #No.FUN-830139
            END IF
            IF l_aag.aag23 = 'N' THEN
               LET l_afb04 = ' '
               LET l_afb042 = ' '
            END IF
            CALL s_getbug1(l_bookno,l_npq.npq36,l_npq.npq03,
                           l_azn02,l_afb04,l_afb041,l_afb042,l_azn04,l_npp.npptype)    #FUN-810069
                 RETURNING l_flag,l_afb07,l_amt
            IF l_flag THEN CALL cl_err('','agl-139',1) END IF #若不成功
 
            IF l_afb07  != '1' THEN #要做超限控制
               SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                WHERE npq01 = npp01         AND npq03 = l_npq.npq03 
                  AND npq00 = npp00    #TQC-750011
                  AND npq36 = l_npq.npq36   AND npq06 = '1' #借方  #No.FUN-830139 
                  AND YEAR(npp02) = l_azn02 AND MONTH(npp02)= l_azn04
                  AND npqtype = p_npqtype   #No.FUN-670047
               IF SQLCA.sqlcode OR l_tol IS NULL THEN LET l_tol = 0 END IF
 
               SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                WHERE npq01 = npp01         AND npq03 = l_npq.npq03 
                  AND npq00 = npp00    #TQC-750011
                  AND npq36 = l_npq.npq36   AND npq06 = '2' #貸方  #No.FUN-830139
                  AND YEAR(npp02) = l_azn02 AND MONTH(npp02)= l_azn04
                  AND npqtype = p_npqtype   #No.FUN-670047
               IF SQLCA.sqlcode OR l_tol1 IS NULL THEN LET l_tol1 = 0 END IF
 
               IF l_aag.aag06 = '1' THEN #借餘 
                  LET total_t = l_tol - l_tol1   #借減貸
               ELSE #貸餘
                  LET total_t = l_tol1 - l_tol   #貸減借
               END IF
               LET l_amt = l_amt + l_npq.npq07            #MOD-CB0152 add
              #IF total_t > l_amt THEN #借餘大於預算金額  #MOD-CB0152 mark
               IF l_npq.npq07 > l_amt THEN                #MOD-CB0152 add
                  CASE l_afb07
                    WHEN '2'
                         CALL cl_getmsg('agl-140',0) RETURNING l_buf
                         CALL cl_getmsg('agl-141',0) RETURNING l_buf1
                         IF g_bgjob = "N" THEN        #No.FUN-570123
                            ERROR l_npq.npq03 CLIPPED,' ',
                                  l_buf CLIPPED,' ',total_t,
                                  l_buf1 CLIPPED,' ',l_amt
                         END IF                       #No.FUN-570123
                    WHEN '3'
                         CALL cl_getmsg('agl-142',0) RETURNING l_buf
                         CALL cl_getmsg('agl-143',0) RETURNING l_buf1
                         IF g_bgjob = "N" THEN        #No.FUN-570123
                            ERROR l_npq.npq03 CLIPPED,' ',
                                  l_buf CLIPPED,' ',total_t,
                                  l_buf1 CLIPPED,' ',l_amt
                         END IF                       #No.FUN-570123
                         LET g_success='N'
                  END CASE
               END IF
            END IF
      END IF
 
      #若科目須做專案管理，專案編號不可空白
      IF l_aag.aag23 = 'Y' THEN
         IF cl_null(l_npq.npq08) THEN
            CALL cl_err(l_npq.npq03,'agl-922',1) LET g_success='N' RETURN
         ELSE
            SELECT * FROM pja_file WHERE pja01 = l_npq.npq08 AND pjaacti = 'Y'    #FUN-810045
                                     AND pjaclose = 'N'                           #No.FUN-960038
            IF STATUS = 100 THEN
               CALL cl_err3("sel","pja_file",l_npq.npq08,"","apj-005","","",1)   #No.FUN-660146  #FUN-810045
               LET g_success='N' RETURN 
            END IF
         END IF
      END IF
   
      #(若科目有異動碼管理者,應check異動碼欄位)
      #異動碼控制方式 
      #(1:可輸入,可空白/2.必須輸入,不需檢查/ 3.必須輸入, 必須檢查)
      IF l_aag.aag151 MATCHES '[23]' AND cl_null(l_npq.npq11) THEN 
         CALL cl_err(l_npq.npq03,'aap-288',1) LET g_success='N' RETURN
      END IF
      IF l_aag.aag171 MATCHES '[23]' AND cl_null(l_npq.npq13) THEN
         CALL cl_err(l_npq.npq03,'aap-288',1) LET g_success='N' RETURN
      END IF
      IF l_aag.aag181 MATCHES '[23]' AND cl_null(l_npq.npq14) THEN
         CALL cl_err(l_npq.npq03,'aap-288',1) LET g_success='N' RETURN
      END IF
   END FOREACH
END FUNCTION
 
REPORT gxrp610_1_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01     #NO.FUN-680145 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5    #NO.FUN-680145 SMALLINT	# 傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE oeb_file.oeb13  #NO.FUN-680145 DEC(20,6)  #FUN-4C0014
  DEFINE l_remark      LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(150)  #No.7319
  DEFINE l_p1          LIKE type_file.chr2     #NO.FUN-680145 VARCHAR(02)
  DEFINE l_p2          LIKE type_file.num5     #NO.FUN-680145 SMALLINT
  DEFINE l_p3          LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
  DEFINE l_p4          LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
  DEFINE n1,n2         LIKE type_file.num5     #NO.FUN-680145 SMALLINT 
  DEFINE amtd,amtc     LIKE npq_file.npq07
  DEFINE li_result     LIKE type_file.num5     #NO.FUN-680145 SMALLINT #No.FUN-560190
  DEFINE l_missingno   LIKE aba_file.aba01  #No.FUN-570090  --add 
  DEFINE l_flag1       LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)              #No.FUN-570090  --add
  DEFINE l_npp08       LIKE npp_file.npp08     #MOD-A80017 Add
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                    l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
   #缺號使用           
   LET l_flag1='N'               
   LET l_missingno = NULL       
   LET g_j=g_j+1               
   SELECT tc_tmp02 INTO l_missingno      
     FROM agl_tmp_file                   
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'    
      AND tc_tmp03=p_bookno1  #No.FUN-670047
   IF NOT cl_null(l_missingno) THEN         
      LET l_flag1='Y'                      
      LET gl_no1=l_missingno               
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1         
                                AND tc_tmp03 = p_bookno1  #No.FUN-670047
   END IF            
                   
   #缺號使用完，再在流水號最大的編號上增加     
   IF l_flag1='N' THEN                        
     CALL s_auto_assign_no("agl",gl_no1,gl_date,"","","",p_plant,"",g_ooz.ooz02c) #FUN-980094
       RETURNING li_result,gl_no1   
     IF (NOT li_result) THEN                                                   
         LET g_success = 'N'
     END IF                                                                    
     PRINT "Get max TR-no:",gl_no1," Return code(g_i):",g_i
    #DISPLAY "Insert G/L voucher no:",gl_no1 AT 1,1   #CHI-A70049 mark
     PRINT "Insert aba:",g_ooz.ooz02c,' ',gl_no1,' From:',l_order
   END IF  #No.FUN-570090  -add      
     #LET g_sql="INSERT INTO ",g_dbs_gl CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
                        " abamksg,abapost,",
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        " abasign,abadays,abaprit,abasmax,abasseq,aba11,",     #FUN-840211 add aba11
                        " abalegal,abaoriu,abaorig,aba21,aba24 ) ", #FUN-A10036 #FUN-980011 add   FUN-A10006 add aba21 #MOD-A80136 add aba24
                 " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?, ?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?)"  #FUN-A10036 #FUN-840211 add ?  #FUN-980011 add  FUN-A10006 add ? #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p610_1_p4_1 FROM g_sql 
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no1
     LET g_aba01t = gl_no1[1,g_doc_len]   #No.FUN-560190 
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t    
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN 
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF
     CASE p_type
       WHEN '1' LET l_p1='AR'
       WHEN '2' LET l_p1='AP'
       WHEN '3' LET l_p1='NM'
       WHEN '4' LET l_p1='NM'
       WHEN '5' LET l_p1='NM'
       #####
     END CASE
     LET l_p2='0'
     LET l_p3='N'
     LET l_p4='Y'
     EXECUTE p610_1_p4_1 USING
        g_ooz.ooz02c,gl_no1,gl_date,g_yy,g_mm,g_today,   #MOD-870128
        l_p1,l_order,l_p2,l_p2,l_p3,l_p3,l_p2,
        g_aba.abamksg,l_p3,
        l_p2,l_p4,g_user,g_grup,g_today,
        g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2
        ,g_aba.aba11   #FUN-840211 add aba11
        ,g_legal,g_user,g_grup,l_npp.npp08,g_user #FUN-A10036       #FUN-980011 add  FUN-A10006 add npp08 #MOD-A80136 add g_user
 
     IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aba_file",g_ooz.ooz02c,gl_no1,SQLCA.sqlcode,"","ins aba",1)   #No.FUN-660146
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1  #No.FUN-570090  --add   
                            AND tmn06 = p_bookno1  #No.FUN-670047
     IF gl_no_b1 IS NULL THEN LET gl_no_b1 = gl_no1 END IF
     LET gl_no_e1 = gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     SELECT SUM(npq07) INTO amtd FROM npq_file 
      WHERE npq01 = l_npp.npp01 AND npq06 = '1' #--->借方合計
        AND npqsys= l_npp.nppsys
        AND npq011= l_npp.npp011
        AND npqtype=l_npp.npptype    #No.FUN-670047 
     SELECT SUM(npq07) INTO amtc FROM npq_file 
      WHERE npq01 = l_npp.npp01 AND npq06 = '2' #--->貸方合計
        AND npqsys= l_npp.nppsys
        AND npq011= l_npp.npp011
        AND npqtype=l_npp.npptype    #No.FUN-670047 
     IF cl_null(amtd) THEN LET amtd = 0 END IF
     IF cl_null(amtc) THEN LET amtc = 0 END IF
     #-->借貸要平
     IF amtd != amtc THEN
        CALL cl_err(l_npp.npp01,'aap-058',1) LET g_success='N'
     END IF
     #-->科目要對
     SELECT COUNT(*) INTO n1 FROM npq_file
      WHERE npq01 = l_npp.npp01 AND npqsys = l_npp.nppsys 
        AND npq011= l_npp.npp011
        AND npqtype=l_npp.npptype    #No.FUN-670047 
     SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
      WHERE npq01 = l_npp.npp01 AND npqsys = l_npp.nppsys
        AND npq011= l_npp.npp011
        AND npq03 = aag01 AND aag03 = '2' AND aag07 IN ('2','3')
        AND npqtype=l_npp.npptype    #No.FUN-670047 
        AND aag00 = g_ooz.ooz02c   #FUN-740009
     IF n1<>n2 THEN
        CALL cl_err(l_npp.npp01,'aap-262',1) LET g_success='N'
     END IF
     CALL p610_chknpq(l_npp.npp01,l_npp.nppsys,l_npp.npp011,l_npp.npp00,l_npp.npptype)
 
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no1,
                         npp06 = p_plant,npp07=p_bookno1
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype='1'   #No.FUN-670047 
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno",1)   #No.FUN-660146
        LET g_success = 'N'  
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
    #DISPLAY "Seq:",l_seq AT 2,1   #CHI-A70049 mark
     #LET g_sql = "INSERT INTO ",g_dbs_gl CLIPPED,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,abb24,abb25,",                      #No.FUN-810069
 
                        " abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        " ,abblegal ",   #FUN-980011 add
                        " )",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?",                               #No.FUN-810069
                 "       ,?,?,?,?,?,?,?,",  #FUN-5C0015 BY GILL
                 "       ? ) "              #FUN-980011 add
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p610_1_p5_1 FROM g_sql
     EXECUTE p610_1_p5_1 USING 
                g_ooz.ooz02c,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                                        #No.FUN-810069
 
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,
 
                g_legal  #FUN-980011 add
 
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",g_ooz.ooz02c,gl_no1,SQLCA.sqlcode,"","ins abb",1)   #No.FUN-660146
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
     CALL s_flows('2',g_ooz.ooz02c,gl_no1,gl_date,l_p3,'',TRUE)   #No.TQC-B70021

      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED,"aba_file SET aba08=?,aba09=?  ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                    " SET aba08=?,aba09=?  ",
                    "    ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p610_1_p6_1 FROM g_sql
      EXECUTE p610_1_p6_1 USING l_debit,l_credit,l_npp08,gl_no1,g_ooz.ooz02c  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aba_file",g_ooz.ooz02c,gl_no1,SQLCA.sqlcode,"","upd aba08/09",1)   #No.FUN-660146
         LET g_success = 'N'
      END IF
      PRINT
      LET gl_no1[4,12]=''
      LET gl_no1[g_no_sp-1,g_no_ep]=''  
END REPORT
#No.FUN-9C0072 精簡程式碼  
#CHI-AC0010

#No.MOD-C80073  --Begin
FUNCTION p610_create_temp_table()
   DROP TABLE agl_tmp_file     
   CREATE TEMP TABLE agl_tmp_file(
    tc_tmp00     LIKE type_file.chr1,  
    tc_tmp01     LIKE type_file.num5,  
    tc_tmp02     LIKE aba_file.aba01,
    tc_tmp03     LIKE aaa_file.aaa01)
   IF STATUS THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM 
   END IF 
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)   #No.FUN-670047     
   IF STATUS THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_err('create index',STATUS,0) EXIT PROGRAM 
   END IF   
     
   DROP TABLE p610_tmp
   #修改npp01,nppglno,npq01,npq11,npq12,npq13,npq14,npq22,npq30
   CREATE TEMP TABLE p610_tmp(
      order1    LIKE npp_file.npp01,
      nppsys    LIKE npp_file.nppsys,
      npp00     LIKE npp_file.npp00,
      npp01     LIKE npp_file.npp01,
      npp011    LIKE npp_file.npp011,
      npp02     LIKE npp_file.npp02,
      npp03     LIKE npp_file.npp03,
      npp04     LIKE npp_file.npp04,
      npp05     LIKE npp_file.npp05,
      npp06     LIKE npp_file.npp06,
      npp07     LIKE npp_file.npp07,
      nppglno   LIKE npp_file.nppglno,
      npptype   LIKE npp_file.npptype,
      npplegal  LIKE npp_file.npplegal, #FUN-980011 add
      npp08     LIKE npp_file.npp08,     #No.TQC-A40003
      npqsys    LIKE npq_file.npqsys,
      npq00     LIKE npq_file.npq00,
      npq01     LIKE npq_file.npq01,
      npq011    LIKE npq_file.npq011,
      npq02     LIKE npq_file.npq02,
      npq03     LIKE npq_file.npq03,
      npq04     LIKE npq_file.npq04,
      npq05     LIKE npq_file.npq05,
      npq06     LIKE npq_file.npq06,
      npq07f    LIKE npq_file.npq07f,
      npq07     LIKE npq_file.npq07,
      npq08     LIKE npq_file.npq08,
      npq11     LIKE npq_file.npq11,
      npq12     LIKE npq_file.npq12,
      npq13     LIKE npq_file.npq13,
      npq14     LIKE npq_file.npq14,
      npq15     LIKE npq_file.npq15,    #MOD-910078
      npq21     LIKE npq_file.npq21,
      npq22     LIKE npq_file.npq22,
      npq23     LIKE npq_file.npq23,
      npq24     LIKE npq_file.npq24,
      npq25     LIKE npq_file.npq25,
      npq26     LIKE npq_file.npq26,
      npq27     LIKE npq_file.npq27,
      npq28     LIKE npq_file.npq28,
      npq29     LIKE npq_file.npq29,
      npq30     LIKE npq_file.npq30,
      npq31     LIKE npq_file.npq31,
      npq32     LIKE npq_file.npq32,
      npq33     LIKE npq_file.npq33,
      npq34     LIKE npq_file.npq34,
      npq35     LIKE npq_file.npq35,
      npq36     LIKE npq_file.npq36,
      npq37     LIKE npq_file.npq37,
      npq930    LIKE npq_file.npq930,
      npqtype   LIKE npq_file.npqtype,
      npqlegal  LIKE npq_file.npqlegal, #FUN-980011 add
      remark1   LIKE type_file.chr1000);

   IF STATUS THEN
      CALL cl_err('create tmp',STATUS,1)
      CALL cl_batch_bg_javamail("N")         #No.FUN-570123
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #TQC-940071
      EXIT PROGRAM
   END IF
END FUNCTION
#No.MOD-C80073  --End
                                              
