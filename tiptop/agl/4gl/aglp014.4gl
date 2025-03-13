# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp014.4gl (FUN-770086 copy from aglp142)
# Descriptions...: 合併報表長期投資認列傳票拋轉作業
# Date & Author..: 07/07/27 By kim
# Modify.........: No.MOD-780104 04/12/08 By kim 補過單
# Modify.........: No.FUN-810069 08/02/27 By yaofs 項目預算取消abb15的管控 
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: NO.FUN-920189 09/10/29 BY ve007 營運中心應控卡npp06
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10006 10/01/11 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No.FUN-9C0072 10/01/19 By vealxu   精簡程式碼
# Modify.........: No.FUN-A50102 10/06/04 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No.FUN-920196 10/08/16 By vealxu 營運中心開窗,抓取npp_file,npq_file要跨庫
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24 預設值 
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:TQC-BA0149 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_wc,g_sql       STRING          #No.FUN-580092 HCN       
DEFINE g_dbs_gl         LIKE type_file.chr21  #No.FUN-680098   VARCHAR(21) 
DEFINE g_plant_gl       LIKE type_file.chr21  #No.FUN-980059   VARCHAR(21) 
DEFINE gl_no	        LIKE aba_file.aba01   #No.FUN-680098   VARCHAR(16)	# 傳票單號              
DEFINE gl_no_b,gl_no_e  LIKE aba_file.aba01   #No.FUN-680098   VARCHAR(16)	# Generated 傳票單號
DEFINE p_plant          LIKE azp_file.azp01   #No.FUN-680098   VARCHAR(12)	
DEFINE l_plant_old      LIKE azp_file.azp01   #No.FUN-680098   VARCHAR(12)
DEFINE p_bookno         LIKE aaa_file.aaa01
DEFINE gl_date		LIKE type_file.dat     #No.FUN-680098  DATE
DEFINE gl_tran	        LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
DEFINE g_t1	        LIKE oay_file.oayslip  #No.FUN-680098  VARCHAR(5)
DEFINE g_yy,g_mm	LIKE azn_file.azn02    #No.FUN-680098  SMALLINT
DEFINE g_statu          LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
DEFINE g_aba01t         LIKE aba_file.aba01
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-680098 SMALLINT
DEFINE g_npp00          LIKE npp_file.npp00  
DEFINE g_flag           LIKE type_file.num5    #No.FUN-680098 SMALLINT  
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-680098 INTEGER
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_j              LIKE type_file.num5      #No.FUN-680098  SMALLINT
DEFINE l_flag           LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1)
       g_change_lang    LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1),        #是否有做語言切換
       ls_date          STRING
DEFINE t_dbss           LIKE azp_file.azp03      #No.FUN-740020
 
MAIN
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)                      
   LET p_plant  = ARG_VAL(2)                      
   LET p_bookno = ARG_VAL(3)                      
   LET gl_no    = ARG_VAL(4)                      
   LET ls_date  = ARG_VAL(5)                      
   LET gl_date  = cl_batch_bg_date_convert(ls_date)
   LET gl_tran  = ARG_VAL(6)                      
   LET g_bgjob  = ARG_VAL(7)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   DROP TABLE agl_tmp_file    
   CREATE TEMP TABLE agl_tmp_file( 
    tc_tmp00     LIKE type_file.chr1 NOT NULL,            
    tc_tmp01     LIKE type_file.num5,        
    tc_tmp02     LIKE type_file.chr20, 
    tc_tmp03     LIKE oay_file.oayslip)
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
      CALL cl_batch_bg_javamail("N")
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF    
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03) #No.FUN-670068 add tc_tmp03
   IF STATUS THEN CALL cl_err('create index',STATUS,0)  
      CALL cl_batch_bg_javamail("N")
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF 
 
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p014_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            LET g_aaz.aaz64 = p_bookno  # 得帳別
            CALL p014_t()
            CALL s_showmsg()            #NO.FUN-710023   
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_m_prtgl(g_plant_gl,g_aaz.aaz64,gl_no_b,gl_no_e)  #FUN-990069
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE
            ELSE 
               CLOSE WINDOW p014_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p014_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         LET g_aaz.aaz64 = p_bookno  # 得帳別
         CALL p014_t()
          CALL s_showmsg()           #NO.FUN-710023  
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_m_prtgl(g_plant_gl,g_aaz.aaz64,gl_no_b,gl_no_e) #FUN-990069
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
   DELETE FROM tmn_file    
    WHERE tmn01 = p_plant 
      AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')    
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p014()
   WHILE TRUE 
     LET g_success=""
     CLEAR FORM
     CALL p014_ask()
     IF INT_FLAG THEN RETURN END IF
     IF NOT cl_sure(20,20) THEN LET INT_FLAG = 1 RETURN END IF
     CALL cl_wait()
 
     LET g_aaz.aaz64 = p_bookno  # 得帳別
 
     LET p_row = 19 LET p_col = 20
     CALL p014_t()
     IF g_success='Y' THEN
        CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
     ELSE
        CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
     END IF
     IF g_flag THEN
        CONTINUE WHILE
     ELSE
        EXIT WHILE
     END IF
   END WHILE
END FUNCTION
 
FUNCTION p014_ask()
   DEFINE l_aaa07        LIKE aaa_file.aaa07
   DEFINE l_flag         LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE li_result      LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE l_cnt          LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE lc_cmd         LIKE type_file.chr1000 #No.FUN-680098     VARCHAR(500)
   DEFINE li_chk_bookno  LIKE type_file.num5,   #No.FUN-680098  SMALLINT,
          l_sql          STRING        
   DEFINE   l_no           LIKE type_file.chr3    #No.FUN-840125                
   DEFINE   l_aac03        LIKE aac_file.aac03    #No.FUN-840125 
   DEFINE   l_npp01        STRING                 #FUN-920189
   DEFINE   l_npp06        LIKE npp_file.npp06    #FUN-920189
   DEFINE   p_npp01        LIKE npp_file.npp01    #FUN-920189
 
   LET p_row = 1 LET p_col = 1
 
   OPEN WINDOW p014_w AT p_row,p_col WITH FORM "agl/42f/aglp014" 
        ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   CONSTRUCT BY NAME g_wc ON npp00,npp01,npp02   #TQC-6C0099 add npp02
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()     
     
      ON ACTION help         
         CALL cl_show_help() 
     
      ON ACTION controlg     
         CALL cl_cmdask()    
   
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p014_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
   LET p_plant = g_plant
   LET l_plant_old = p_plant
   LET p_bookno= g_aaz.aaz64   #預設帳別 
   LET gl_date = g_today
   LET gl_tran = 'Y'
   LET g_bgjob = 'N'
 
   INPUT BY NAME p_plant,p_bookno,gl_no,gl_date,gl_tran,g_bgjob
         WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        AFTER FIELD p_plant

         SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         IF STATUS <> 0 THEN
            CALL cl_err3("sel","azp_file",p_plant,"","mfg9014","","",1)
            NEXT FIELD p_plant
         END IF
 
         SELECT azp03 INTO t_dbss FROM azp_file WHERE azp01 = p_plant  #No.FUN-740020
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
         IF l_plant_old != p_plant THEN   
            DELETE FROM tmn_file         
             WHERE tmn01 = l_plant_old  
               AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y') 
            DELETE FROM agl_tmp_file             
            LET l_plant_old = g_plant_new      
         END IF                               
 
      AFTER FIELD p_bookno
         IF p_bookno IS NULL THEN
            NEXT FIELD p_bookno
         END IF
         CALL s_check_bookno(p_bookno,g_user,p_plant) RETURNING li_chk_bookno
         IF (NOT li_chk_bookno) THEN
            NEXT FIELD p_bookno
         END IF 
         LET g_plant_new = p_plant  #工廠編號
         CALL s_getdbs()
         LET l_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",  #FUN-A50102
                     "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),   #FUN-A50102
                     " WHERE aaa01 = '",p_bookno,"' ",
                     "   AND aaaacti IN ('Y','y') "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql#FUN-920196 
         PREPARE p014_pre2 FROM l_sql
         DECLARE p014_cur2 CURSOR FOR p014_pre2
         OPEN p014_cur2
         FETCH p014_cur2 INTO g_cnt
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno
         END IF
 
      AFTER FIELD gl_no
         CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",p_plant) #FUN-980094
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
         CALL s_check_bookno(p_bookno,g_user,g_plant) RETURNING li_chk_bookno
         IF (NOT li_chk_bookno) THEN
            NEXT FIELD gl_date
         END IF 
         SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
         IF gl_date <= l_aaa07 THEN    
            CALL cl_err('','axm-164',0) NEXT FIELD gl_date
         END IF
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)
            NEXT FIELD gl_date
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
        
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(p_plant)  THEN LET l_flag='Y' END IF
         IF cl_null(p_bookno) THEN LET l_flag='Y' END IF
         IF gl_no[1,g_doc_len] IS NULL or gl_no[1,g_doc_len] = ' ' THEN
            LET l_flag='Y'
         END IF
         IF cl_null(gl_date)  THEN LET l_flag='Y' END IF
         IF cl_null(gl_tran)  THEN LET l_flag='Y' END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
 
         #得出總帳 database name
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
 
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)
            NEXT FIELD gl_date
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gl_no)
               CALL s_getdbs()                                                                                                            
               LET g_dbs_gl=g_dbs_new
               LET g_plant_gl = p_plant  #No.FUN-980059
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')   #No.FUN-840125 #No.FUN-980059
                    RETURNING gl_no 
               DISPLAY BY NAME gl_no
               NEXT FIELD gl_no
            WHEN INFIELD(p_bookno)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_m_aaa' 
               LET g_qryparam.plant = p_plant  #No.FUN-980025 add
               LET g_qryparam.default1 =p_bookno 
               CALL cl_create_qry() RETURNING p_bookno
               DISPLAY BY NAME p_bookno
               NEXT FIELD p_bookno
            
            #FUN-920196 ------------add start-------------
             WHEN INFIELD(p_plant)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = p_plant 
                CALL cl_create_qry() RETURNING p_plant
                DISPLAY BY NAME p_plant
                NEXT FIELD p_plant
            #FUN-920196 ------------add end-----------------   
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
     
      ON ACTION get_missing_voucher_no     
         IF cl_null(gl_no) THEN  
            NEXT FIELD gl_no      
         END IF                    
                                    
         DELETE FROM tmn_file        
          WHERE tmn01 = p_plant       
            AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')  
         DELETE FROM agl_tmp_file                                             
                                                                              
         CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,'','',gl_date,0)  #No.FUN-670068
                                                              
         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file           
          WHERE tc_tmp00='Y'                       
         IF l_cnt > 0 THEN                          
            CALL cl_err(l_cnt,'aap-501',0)           
         ELSE                                         
            CALL cl_err('','aap-502',0)                
         END IF             
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT INPUT 
 
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
      CLOSE WINDOW p014_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "aglp014"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aglp014','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",p_plant CLIPPED ,"'",
                      " '",p_bookno CLIPPED ,"'",
                      " '",gl_no CLIPPED ,"'",
                      " '",gl_date CLIPPED ,"'",
                      " '",gl_tran CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aglp014',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p014_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION p014_t()
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_cmd         LIKE type_file.chr50   #No.FUN-680098  VARCHAR(30)
   DEFINE l_order       LIKE npp_file.npp01
   DEFINE l_remark      LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(150)  
   DEFINE l_name        LIKE type_file.chr20   #No.FUN-680098  VARCHAR(20)
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
   DEFINE l_yy,l_mm     LIKE azn_file.azn02    #No.FUN-680098  SMALLINT
   DEFINE l_msg         LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(80)
   DEFINE l_aba11       LIKE aba_file.aba11    #FUN-840211
   DEFINE l_bdate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1    #CHI-9A0021 add
   DEFINE l_npp01       LIKE npp_file.npp01    #TQC-BA0149
   DEFINE l_yy1         LIKE type_file.num5    #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5    #CHI-CB0004
 
   LET g_success='Y'
   CALL p014_create_tmp()
 
  #當月起始日與截止日
   #CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A70007 mark
  #CHI-A70007 add --start--
  IF g_aza.aza63 = 'Y' THEN
     CALL s_azmm(YEAR(gl_date),MONTH(gl_date),p_plant,p_bookno) RETURNING l_correct,l_bdate,l_edate
  ELSE
     CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_bdate,l_edate
  END IF
  #CHI-A70007 add --end--
 
  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
            #"  FROM npp_file ",                                    #FUN-920196 mark
             "  FROM ",cl_get_target_table(p_plant,'npp_file'),     #FUN-920196                      
             " WHERE nppsys= 'CD' AND (nppglno IS NULL OR nppglno='')",
             "   AND ",g_wc CLIPPED,
             "   AND npp02 NOT BETWEEN '",l_bdate,"' AND '",l_edate,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-920196
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-920196
   PREPARE p014_0_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p014_0_p0',STATUS,1) RETURN END IF
   DECLARE p014_0_c0 CURSOR WITH HOLD FOR p014_0_p0
   LET l_flag='N'
   FOREACH p014_0_c0 INTO l_yy,l_mm
      LET l_flag='Y'  EXIT FOREACH
   END FOREACH
   IF l_flag ='Y' THEN
      LET g_success='N'
      CALL cl_err('err:','axr-061',1)
      RETURN
   END IF
 
 
  IF g_aaz.aaz81 = 'Y' THEN
     LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
     SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file
      WHERE aba00 = p_bookno
        AND aba19 <> 'X'  #CHI-C80041
        AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
     #CHI-CB0004--(B)
      IF cl_null(l_aba11) OR l_aba11 = 1 THEN
         LET l_aba11 = YEAR(gl_date)*1000000+MONTH(gl_date)*10000+1
      END IF
     #CHI-CB0004--(E)
     #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
      LET g_aba.aba11 = l_aba11
   ELSE 
      LET g_aba.aba11 = ' '        
     
  END IF      
  
   LET g_sql="SELECT npp_file.*,npq_file.* ", 
            #"  FROM npp_file,npq_file ",                                  #FUN-920196 mark
             "  FROM ",cl_get_target_table(p_plant,'npp_file'),",",        #FUN-920196
                       cl_get_target_table(p_plant,'npq_file'),            #FUN-920196
             " WHERE nppsys= 'CD'",
             "   AND (nppglno IS NULL OR nppglno='')",
             "   AND nppsys = npqsys",
             "   AND npp00  = npq00",
             "   AND npp01  = npq01",
             "   AND npp011 = npq011",
             "   AND npptype= npqtype",
             "   AND ",g_wc CLIPPED,
             " ORDER BY npq06,npq03,npq05,npq24,npq25 "
   IF gl_tran = 'N' THEN 
      LET g_sql=g_sql CLIPPED,",npq11,npq12,npq13,npq14,npq15,npq08,npq01"
   ELSE 
      LET g_sql=g_sql CLIPPED,",npq04,npq11,npq12,npq13,npq14,npq15,npq08,npq01"
   END IF
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-920196
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-920196
   PREPARE p014_1_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p014_1_p0',STATUS,1) 
      CALL cl_batch_bg_javamail("N")
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE p014_1_c0 CURSOR WITH HOLD FOR p014_1_p0
 
   CALL cl_outnam('aglp014') RETURNING l_name
 
      CALL s_showmsg_init()                     #NO.FUN-710023
   START REPORT aglp014_rep TO l_name
   WHILE TRUE
      FOREACH p014_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)  
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
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
                           l_npq.npq15 clipped,l_npq.npq08 clipped
         ELSE 
            LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                           l_npq.npq12 clipped,l_npq.npq13 clipped,
                           l_npq.npq14 clipped,
                           l_npq.npq31 clipped,l_npq.npq32 clipped,
                           l_npq.npq33 clipped,l_npq.npq34 clipped,
                           l_npq.npq35 clipped,l_npq.npq36 clipped,
                           l_npq.npq37 clipped,
                           l_npq.npq15 clipped,
                           l_npq.npq08 clipped
         END IF
 
         LET l_order = l_npp.npp01 # 依單號
 
         INSERT INTO p014_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg(' ',' ','order:',STATUS,1)     
         END IF
      END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
      LET l_npp01 = NULL   #No.TQC-BA0149
      DECLARE p014_tmpcs CURSOR FOR
         SELECT * FROM p014_tmp
          ORDER BY order1,npp01,npq06,npq03,npq05,npq24,npq25,remark1,npq01   #No.TQC-BA0149 add npp01
      FOREACH p014_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
         IF STATUS THEN
            CALL s_errmsg(' ',' ','order:',STATUS,1)     
            CONTINUE FOREACH           
         END IF    
         #No.TQC-BA0149  --Begin
         IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
            LET l_npp.npp08 = 0
         END IF
         LET l_npp01 = l_npp.npp01
         #No.TQC-BA0149  --End
         OUTPUT TO REPORT aglp014_rep(l_order,l_npp.*,l_npq.*,l_remark)
      END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
      EXIT WHILE
   END WHILE
   FINISH REPORT aglp014_rep
 
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
END FUNCTION
 
REPORT aglp014_rep(l_order,l_npp,l_npq,l_remark)
   DEFINE l_order      LIKE npp_file.npp01
   DEFINE l_npp	       RECORD LIKE npp_file.*
   DEFINE l_npq	       RECORD LIKE npq_file.*
   DEFINE l_remark     LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(150)
   DEFINE l_seq	       LIKE type_file.num5    #No.FUN-680098  SMALLINT          #傳票項次
   DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE npq_file.npq07 
   DEFINE l_p1         LIKE type_file.chr2     #No.FUN-680098  VARCHAR(02)
   DEFINE l_p2         LIKE type_file.num5     #No.FUN-680098 SMALLINT
   DEFINE l_p3         LIKE type_file.chr1     #No.FUN-680098 VARCHAR(01)
   DEFINE l_p4         LIKE type_file.chr1     #No.FUN-680098 VARCHAR(01)
   DEFINE li_result    LIKE type_file.num5     #No.FUN-680098 SMALLINT
   DEFINE l_missingno  LIKE aba_file.aba01
   DEFINE l_flag1      LIKE type_file.chr1     #No.FUN-680098 VARCHAR(1)
   DEFINE l_npp08      LIKE npp_file.npp08     #MOD-A80017 Add
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                     l_npq.npq01,l_remark
 
   FORMAT
     #---------- Insert aba_file ------------------------------
     BEFORE GROUP OF l_order
       #缺號使用                         
       LET l_flag1='N'                     
       LET l_missingno = NULL               
       LET g_j=g_j+1                         
       SELECT tc_tmp02 INTO l_missingno       
         FROM agl_tmp_file                      
        WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'   
       IF NOT cl_null(l_missingno) THEN          
          LET l_flag1='Y'                          
          LET gl_no=l_missingno                   
          DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no   
       END IF                                      
                                                  
       #缺號使用完，再在流水號最大的編號上增加       
       IF l_flag1='N' THEN  
          CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",g_aaz.aaz64) #FUN-980094
               RETURNING li_result,gl_no
          IF (NOT li_result) THEN
             LET g_success = 'N'
          END IF
          IF g_bgjob = 'N' THEN
             MESSAGE "Insert G/L voucher no:",gl_no 
             CALL ui.Interface.refresh()
          END IF
          PRINT "Insert aba:",g_aaz.aaz64,' ',gl_no,' From:',l_order
       END IF
 
      #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",   #FUN-A50102
       LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'),  #FUN-A50102
                 "(aba00,aba01,aba02,aba03,aba04,aba05,aba06,",
                 " aba07,aba08,aba09,aba12,aba19,abamksg,abapost,",
                 " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,",   #TQC-A10060   add abaoriu,abaorig
                 " abasign,abadays,abaprit,abasmax,abasseq,abamodu,aba11,",
                 " abalegal,aba21,aba24)",     #FUN-840211 add aba11 #FUN-980003 add abalegal  #FUN-A10006 add aba21 #MOD-A80136 add aba24
                 " VALUES(?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?)"  #FUN-840211 add ? #FUN-980003 add ? #TQC-A10060   add ?,?  #FUN-A10006 add ? #MOD-A80136 add ?
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-920032
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql  #FUN-A50102
       PREPARE p014_1_p4 FROM g_sql
 
       #自動賦予簽核等級
       LET g_aba.aba01=gl_no
       LET g_aba01t = gl_no[1,g_doc_len]
       SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
         INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
              g_aba.abaprit,g_aba.abasign
         FROM aac_file WHERE aac01 = g_aba01t
       IF g_aba.abamksg MATCHES  '[Yy]' THEN
          IF g_aac.aacatsg matches'[Yy]' THEN  #自動付予
             CALL s_sign(g_aba.aba01,4,'aba01','aba_file') RETURNING g_aba.abasign
          END IF
          SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
           WHERE azc01=g_aba.abasign
       END IF
 
       #將常數轉變數
       LET l_p1='CD'
       LET l_p2='0'
       LET l_p3='N'
       LET l_p4='Y'
 
       EXECUTE p014_1_p4 USING g_aaz.aaz64,gl_no,gl_date,g_yy,g_mm,g_today,l_p1,
                               l_order,l_p2,l_p2,l_p3,l_p3,g_aba.abamksg,l_p3,
                               l_p2,l_p4,g_user,g_grup,g_today,g_aba.abaoriu,g_aba.abaorig,g_aba.abasign,    #TQC-A10060  add g_aba.abaoriu,g_aba.abaorig
                               g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,g_user
                               ,g_aba.aba11,g_legal   #FUN-840211 add aba11 #FUN-980003 add g_legal
                               ,l_npp.npp08,g_user           #FUN-A10006 add #MOD-A80136 add g_user         
       IF STATUS THEN
           CALL s_errmsg('aba00',g_aaz.aaz64,'ins aba:',STATUS,1) #NO.FUN-710023
           LET g_success = 'N'
       END IF
 
       DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no
       IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
       LET gl_no_e = gl_no
       LET l_credit = 0
       LET l_debit  = 0
       LET l_seq = 0
 
     #---------- Update gl-no To original file ------------------------------
     AFTER GROUP OF l_npq.npq01
       UPDATE npp_file SET npp03  = gl_date, 
                           nppglno= gl_no,
                           npp06  = p_plant, 
                           npp07  = p_bookno 
                     WHERE npp01  = l_npp.npp01
                       AND npp011 = l_npp.npp011
                       AND npp00  = l_npp.npp00
                       AND nppsys = l_npp.nppsys
                       AND npptype= l_npp.npptype
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.npp00                          #NO.FUN-710023 
          CALL s_errmsg('npp01,npp011,npp00',g_showmsg,SQLCA.sqlcode,"upd npp03/glno:",1)     #NO.FUN-710023
          LET g_success = 'N'
       END IF
 
     #---------- Insert into abb_file ------------------------------
     AFTER GROUP OF l_remark   
       LET l_seq = l_seq + 1
       IF g_bgjob = 'N' THEN
          MESSAGE "Seq:",l_seq 
          CALL ui.Interface.refresh()
       END IF
 
      #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",   #FUN-A50102
       LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'),  #FUN-A50102
                   "(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,",
                   " abb08,abb11,abb12,abb13,abb14,",
                   " abb31,abb32,abb33,abb34,abb35,abb36,abb37,",
                   " abb24,abb25,abblegal)",                 #No.FUN-810069  #FUN-980003 add abblegal
                   " VALUES ",
                   "(?,?,?,?,?,?,?,?,?,",
                   " ?,?,?,?,?,",
                   " ?,?,?,?,?,?,",                 #No.FUN-810069
                   " ?,?,?,?)"                      #FUN-980003 add ?
       LET l_amtf= GROUP SUM(l_npq.npq07f)
       LET l_amt = GROUP SUM(l_npq.npq07)
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql  #FUN-A50102
       PREPARE p014_1_p5 FROM g_sql
       EXECUTE p014_1_p5 USING 
               g_aaz.aaz64,
               gl_no,
               l_seq,
               l_npq.npq03,
               l_npq.npq04,
               l_npq.npq05,
               l_npq.npq06,
               l_amtf,
               l_amt,
               l_npq.npq08,
               l_npq.npq11,
               l_npq.npq12,
               l_npq.npq13,
               l_npq.npq14,
               l_npq.npq31,
               l_npq.npq32,
               l_npq.npq33,
               l_npq.npq34,
               l_npq.npq35,
               l_npq.npq37,
               l_npq.npq15,
               l_npq.npq24,
               l_npq.npq25
               ,g_legal                    #FUN-980003 add g_legal
       IF SQLCA.sqlcode THEN
          LET g_showmsg=g_aaz.aaz64,"/",gl_no,"/",l_seq
          CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ins abb:',STATUS,1)   #NO.FUN-710023
          LET g_success = 'N'
       END IF
 
       IF l_npq.npq06 = '1' THEN 
          LET l_debit  = l_debit  + l_amt
       ELSE 
          LET l_credit = l_credit + l_amt
       END IF
 
     #---------- Update aba_file's debit & credit amount ------------------------------
     AFTER GROUP OF l_order
       LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
       PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
       CALL s_flows('2',g_aaz.aaz64,gl_no,gl_date,l_p3,'',TRUE)   #No.TQC-B70021  
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED," aba_file ",   #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'),  #FUN-A50102    
                   "   SET aba08 = ?, ",
                   "       aba09 = ?  ",
                   "      ,aba21=? ",                                 #MOD-A80017 Add
                   " WHERE aba01 = ? ",
                   "   AND aba00 = ?"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql  #FUN-A50102
       PREPARE p014_1_p6 FROM g_sql
       EXECUTE p014_1_p6 USING l_debit,l_credit,l_npp08,gl_no,g_aaz.aaz64  #MOD-A80017 Add l_npp08
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg= gl_no,"/",g_aaz.aaz64                             #NO.FUN-710023
           CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba08/09:',SQLCA.sqlcode,1)    #NO.FUN-710023
       END IF
       PRINT
       LET gl_no[g_no_sp,g_no_ep]=''
END REPORT
 
FUNCTION p014_create_tmp()
   DROP TABLE p014_tmp;
 
   SELECT chr30 order1, npp_file.*,npq_file.*,
          chr1000 remark1
     FROM npp_file,npq_file,type_file
    WHERE npp01 = npq01 AND npp01 = '@@@@'
      AND 1=0
     INTO TEMP p014_tmp

   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err3("sel","npp_file,npq_file","","",SQLCA.SQLCODE,"","create p014_tmp",0)
   END IF
 
   DELETE FROM p014_tmp WHERE 1=1
 
   LET gl_no_b=''
   LET gl_no_e=''
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#CHI-AC0010
