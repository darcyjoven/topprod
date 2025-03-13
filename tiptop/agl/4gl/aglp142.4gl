# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp142.4gl
# Descriptions...: 內部管理傳票拋轉作業
# Date & Author..: 06/08/03 By Sarah
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改
# Modify.........: No.FUN-680098 06/09/05 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6C0099 06/12/21 By Sarah QBE增加npp02(異動日)
# Modify.........: No.FUN-710023 07/01/18 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10006 10/01/13 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No.FUN-A50102 10/06/04 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24 預設值 
# Modify.........: No:TQC-AB0328 10/12/04 By chenying 拋轉不成功時也顯示拋轉成功
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
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
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0073
 
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
#FUN-680098--BEGIN     
   CREATE TEMP TABLE agl_tmp_file( 
    tc_tmp00     LIKE type_file.chr1 NOT NULL,            
    tc_tmp01     LIKE type_file.num5,        
    tc_tmp02     LIKE type_file.chr20, 
    tc_tmp03     LIKE oay_file.oayslip)
#FUN-680098--END
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
         CALL p142_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            LET g_aaz.aaz64 = p_bookno  # 得帳別
            CALL p142_t()
            CALL s_showmsg()            #NO.FUN-710023   
            IF g_success = 'Y' THEN
               COMMIT WORK
#               CALL s_m_prtgl(g_dbs_gl,g_aaz.aaz64,gl_no_b,gl_no_e)  #FUN-990069
               CALL s_m_prtgl(g_plant_gl,g_aaz.aaz64,gl_no_b,gl_no_e)  #FUN-990069
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE
            ELSE 
               CLOSE WINDOW p142_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p142_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         LET g_aaz.aaz64 = p_bookno  # 得帳別
         CALL p142_t()
          CALL s_showmsg()           #NO.FUN-710023  
         IF g_success = "Y" THEN
            COMMIT WORK
#            CALL s_m_prtgl(g_dbs_gl,g_aaz.aaz64,gl_no_b,gl_no_e)   #FUN-990069
            CALL s_m_prtgl(g_plant_gl,g_aaz.aaz64,gl_no_b,gl_no_e)   #FUN-990069
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
 
FUNCTION p142()
   WHILE TRUE 
     LET g_success=""
     CLEAR FORM
     CALL p142_ask()
     IF INT_FLAG THEN RETURN END IF
     IF NOT cl_sure(20,20) THEN LET INT_FLAG = 1 RETURN END IF
     CALL cl_wait()
 
     LET g_aaz.aaz64 = p_bookno  # 得帳別
 
     LET p_row = 19 LET p_col = 20
     CALL p142_t()
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
 
FUNCTION p142_ask()
   DEFINE l_aaa07        LIKE aaa_file.aaa07
   DEFINE l_flag         LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE li_result      LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE l_cnt          LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE lc_cmd         LIKE type_file.chr1000 #No.FUN-680098     VARCHAR(500)
   DEFINE li_chk_bookno  LIKE type_file.num5,   #No.FUN-680098  SMALLINT,
          l_sql          STRING        
   DEFINE   l_no           LIKE type_file.chr3    #No.FUN-840125                
   DEFINE   l_aac03        LIKE aac_file.aac03    #No.FUN-840125  
 
   LET p_row = 1 LET p_col = 1
 
   OPEN WINDOW p142_w AT p_row,p_col WITH FORM "agl/42f/aglp142" 
        ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   CONSTRUCT BY NAME g_wc ON npp00,npp01,npp02   #TQC-6C0099 add npp02
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
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
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
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
      CLOSE WINDOW p142_w
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
         #FUN-990031--mod--str--    營運中心要控制在當前法人下
         #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         #IF STATUS <> 0 THEN
         #   CALL cl_err3("sel","azp_file",p_plant,"","mfg9142","","",1)
         #   NEXT FIELD p_plant
         #END IF
         SELECT * FROM azw_file WHERE azw01 = p_plant AND azw02 = g_legal                                                   
         IF STATUS THEN                                                                                                         
            CALL cl_err3("sel","azw_file",p_plant,"","agl-171","","",1)                                                     
            NEXT FIELD p_plant                                                                                                    
         END IF                                                                                                                 
         #FUN-990031--mod--end 
 
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
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
         PREPARE p142_pre2 FROM l_sql
         DECLARE p142_cur2 CURSOR FOR p142_pre2
         OPEN p142_cur2
         FETCH p142_cur2 INTO g_cnt
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno
         END IF
 
      AFTER FIELD gl_no
        #CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",g_dbs_gl) #FUN-980094 mark
         CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",p_plant) #FUN-980094
              RETURNING li_result,gl_no
         IF (NOT li_result) THEN                                             
            NEXT FIELD gl_no                                                 
         END IF  
        #No.FUN-840125---Begin                                                  
        LET l_no = gl_no                                                        
        SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no               
        IF l_aac03 != '0' THEN                                                  
           CALL cl_err(gl_no,'agl-991',0)                                       
           NEXT FIELD gl_no                                                     
        END IF                                                                  
        #No.FUN-840125---End 
 
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
         #g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
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
               LET g_plant_gl = p_plant   #No.FUN-980059
               #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1',' ',' ','AGL') #No.FUN-840125
#              CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125    #No.FUN-980059
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                    RETURNING gl_no 
               DISPLAY BY NAME gl_no
               NEXT FIELD gl_no
            #No.FUN-740020  --Begin
            WHEN INFIELD(p_bookno)
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_m_aaa' 
#              LET g_qryparam.arg1 = t_dbss    #No.FUN-980025 mark
               LET g_qryparam.plant = p_plant  #No.FUN-980025 add
               LET g_qryparam.default1 =p_bookno 
               CALL cl_create_qry() RETURNING p_bookno
               DISPLAY BY NAME p_bookno
               NEXT FIELD p_bookno
            #No.FUN-740020  --End  
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
                                                                              
#        CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,gl_date,0)  #No.FUN-670068 mark
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
   
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
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
      CLOSE WINDOW p142_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "aglp142"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aglp142','9031',1)   
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
         CALL cl_cmdat('aglp142',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p142_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION p142_t()
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_cmd         LIKE type_file.chr50   #No.FUN-680098  VARCHAR(30)
   DEFINE l_order       LIKE npp_file.npp01
   DEFINE l_remark      LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(150)  
   DEFINE l_name        LIKE type_file.chr20   #No.FUN-680098  VARCHAR(20)
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
   DEFINE l_yy,l_mm     LIKE azn_file.azn02    #No.FUN-680098  SMALLINT
   DEFINE l_msg         LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(80)
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   DEFINE l_flag1       LIKE type_file.chr1   #TQC-AB0328
   DEFINE l_npp01       LIKE npp_file.npp01   #TQC-BA0149
   DEFINE l_yy1         LIKE type_file.num5    #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5    #CHI-CB0004
   
   LET g_success='Y'
   LET l_flag1 = 'N'    #TQC-AB0328 
   CALL p142_create_tmp()
 
  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
             "  FROM npp_file ",
#            " WHERE nppsys= 'CC' AND (nppglno IS NULL OR nppglno='')",    #TQC-AB0328 mark
             " WHERE nppsys= 'CC' AND (nppglno IS NULL OR nppglno=' ')",   #TQC-AB0328 add
             "   AND ",g_wc CLIPPED,
             "   AND ( YEAR(npp02)  !=YEAR('",gl_date,"') OR ",
             "        (YEAR(npp02)   =YEAR('",gl_date,"') AND ",
             "         MONTH(npp02) !=MONTH('",gl_date,"'))) "
   PREPARE p142_0_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p142_0_p0',STATUS,1) RETURN END IF
   DECLARE p142_0_c0 CURSOR WITH HOLD FOR p142_0_p0
   LET l_flag='N'
   FOREACH p142_0_c0 INTO l_yy,l_mm
      LET l_flag='Y'  EXIT FOREACH
   END FOREACH
   IF l_flag ='Y' THEN
      LET g_success='N'
      CALL cl_err('err:','axr-061',1)
      RETURN
   END IF
 
  #No.FUN-840211---Begin
  IF g_aaz.aaz81 = 'Y' THEN
     LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
     SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file
      WHERE aba00 = p_bookno
        AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
        AND aba19 <> 'X'  #CHI-C80041
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
  #No.FUN-840211---End
  
   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             "  FROM npp_file,npq_file ",
             " WHERE nppsys= 'CC'",
#            "   AND (nppglno IS NULL OR nppglno='')",    #TQC-AB0328 mark
             "   AND (nppglno IS NULL OR nppglno=' ')",   #TQC-AB0328 add
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
 
   PREPARE p142_1_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p142_1_p0',STATUS,1) 
      CALL cl_batch_bg_javamail("N")
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE p142_1_c0 CURSOR WITH HOLD FOR p142_1_p0
 
   CALL cl_outnam('aglp142') RETURNING l_name
 
      CALL s_showmsg_init()                     #NO.FUN-710023
   START REPORT aglp142_rep TO l_name
   WHILE TRUE
      FOREACH p142_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)  
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END         
         LET l_flag1 = 'Y'     #TQC-AB0328
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         IF gl_tran = 'N' THEN 
            LET l_npq.npq04 = NULL 
            LET l_remark = l_npq.npq11 clipped,l_npq.npq12 clipped,
                           l_npq.npq13 clipped,l_npq.npq14 clipped,
                           #-----MOD-760129---------
                           l_npq.npq31 clipped,l_npq.npq32 clipped,
                           l_npq.npq33 clipped,l_npq.npq34 clipped,
                           l_npq.npq35 clipped,l_npq.npq36 clipped,
                           l_npq.npq37 clipped,
                           #-----END MOD-760129-----
                           l_npq.npq15 clipped,l_npq.npq08 clipped
         ELSE 
            LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                           l_npq.npq12 clipped,l_npq.npq13 clipped,
                           l_npq.npq14 clipped,
                           #-----MOD-760129---------
                           l_npq.npq31 clipped,l_npq.npq32 clipped,
                           l_npq.npq33 clipped,l_npq.npq34 clipped,
                           l_npq.npq35 clipped,l_npq.npq36 clipped,
                           l_npq.npq37 clipped,
                           #-----END MOD-760129-----
                           l_npq.npq15 clipped,
                           l_npq.npq08 clipped
         END IF
 
         LET l_order = l_npp.npp01 # 依單號
 
         INSERT INTO p142_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err3("ins","p142_tmp","","",STATUS,"","l_order",1) #NO.FUN-710023 
            CALL s_errmsg(' ',' ','order:',STATUS,1)     
         END IF
      END FOREACH
#NO.FUN-710023--BEGIN                                                           
# IF g_totsuccess="N" THEN                  #TQC-AB0328 mark                                           
  IF g_totsuccess="N" OR l_flag1 = 'N' THEN #TQC-AB0328 add                                                       
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
      LET l_npp01 = NULL   #No.TQC-BA0149
      DECLARE p142_tmpcs CURSOR FOR
         SELECT * FROM p142_tmp
          ORDER BY order1,npp01,npq06,npq03,npq05,npq24,npq25,remark1,npq01  #No.TQC-BA0149 add npp01
      FOREACH p142_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
#NO.FUN-710023--BEGIN
#        IF STATUS THEN CALL cl_err('order:',STATUS,1) EXIT FOREACH END IF 
         IF STATUS THEN
            CALL s_errmsg(' ',' ','order:',STATUS,1)     
            CONTINUE FOREACH           
         END IF    
#NO.FUN-710023--END
         #No.TQC-BA0149  --Begin
         IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
            LET l_npp.npp08 = 0
         END IF
         LET l_npp01 = l_npp.npp01
         #No.TQC-BA0149  --End
         LET l_flag1 = 'Y'     #TQC-AB0328 
         OUTPUT TO REPORT aglp142_rep(l_order,l_npp.*,l_npq.*,l_remark)
      END FOREACH
#NO.FUN-710023--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
      EXIT WHILE
   END WHILE
   FINISH REPORT aglp142_rep
 
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009 
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
END FUNCTION
 
REPORT aglp142_rep(l_order,l_npp,l_npq,l_remark)
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
         #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",g_dbs_gl,"",g_aaz.aaz64)  #FUN-980094 mark
          CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",g_aaz.aaz64)  #FUN-980094
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
       LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                 "(aba00,aba01,aba02,aba03,aba04,aba05,aba06,",
                 " aba07,aba08,aba09,aba12,aba19,abamksg,abapost,",
                 " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,",   #TQC-A10060  add abaoriu,abaorig
                 " abasign,abadays,abaprit,abasmax,abasseq,abamodu,aba11,",
                 " abalegal,aba21,aba24)",     #FUN-840211 add aba11 #FUN-980003 add abalegal FUN-A10006 add aba21 #MOD-A80136 add aba24
                 " VALUES(?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?)" #TQC-A10060  add ?,?  #FUN-840211 add ? #FUN-980003 add ? FUN-A10006 add ? #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql  #FUN-A50102
       PREPARE p142_1_p4 FROM g_sql
 
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
       LET l_p1='CC'
       LET l_p2='0'
       LET l_p3='N'
       LET l_p4='Y'
 
       EXECUTE p142_1_p4 USING g_aaz.aaz64,gl_no,gl_date,g_yy,g_mm,g_today,l_p1,
                               l_order,l_p2,l_p2,l_p3,l_p3,g_aba.abamksg,l_p3,
                               l_p2,l_p4,g_user,g_grup,g_today,g_aba.abaoriu,g_aba.abaorig,
                               g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,g_user,g_aba.aba11,  #TQC-A10060  add g_aba.abaoriu,g_aba.abaorig
                               g_legal,l_npp.npp08,g_user   #FUN-840211 add aba11 #FUN-980003 add g_legal FUN-A10006 add npp08 #MOD-A80136 add g_user
       IF STATUS THEN
#          CALL cl_err('ins aba:',STATUS,1) #NO.FUN-710023 
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
#         CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1) #NO.FUN-710023
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
#                  " abb15,abb24,abb25)",                      #FUN-810069
                   " abb24,abb25,abblegal)",                            #FUN-810069 #FUN-980003 add abblegal
                   " VALUES ",
#                  "(?,?,?,?,?,?,?,?,?,",                      #FUN-810069
                   "(?,?,?,?,?,?,?,?,",                        #FUN-810069
                   " ?,?,?,?,?,",
                   " ?,?,?,?,?,?,?,",
                   " ?,?,?, ?)"     #FUN-980003 add ?
       LET l_amtf= GROUP SUM(l_npq.npq07f)
       LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql  #FUN-A50102
       PREPARE p142_1_p5 FROM g_sql
       EXECUTE p142_1_p5 USING 
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
               l_npq.npq36,
               l_npq.npq37,
#              l_npq.npq15,                           #FUN-810069
               l_npq.npq24,
               l_npq.npq25
               ,g_legal       #FUN-980003 add g_legal
       IF SQLCA.sqlcode THEN
#         CALL cl_err('ins abb:',STATUS,1)  #NO.FUN-710023
          LET g_showmsg=g_aaz.aaz64,"/",gl_no,"/",l_seq
          CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ins abb:',STATUS,1)   #NO.FUN-710023
          LET g_success = 'N'
       END IF
       IF l_npq.npq06 = '1' THEN 
          LET l_debit  = l_debit  + l_amt
       ELSE 
          LET l_credit = l_credit + l_amt
       END IF


     AFTER GROUP OF l_order                                           #MOD-A80017 Add
       LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add 
     #---------- Update aba_file's debit & credit amount ------------------------------
       PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
       CALL s_flows('2',g_aaz.aaz64,gl_no,gl_date,l_p3,'',TRUE)   #No.TQC-B70021 
 
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED," aba_file ",  #FUN-A50102
       LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                   "   SET aba08 = ?, ",
                   "       aba09 = ?  ",
                   "      ,aba21 = ? ",                                 #MOD-A80017 Add
                   " WHERE aba01 = ? ",
                   "   AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql  #FUN-A50102
       PREPARE p142_1_p6 FROM g_sql
       EXECUTE p142_1_p6 USING l_debit,l_credit,l_npp08,gl_no,g_aaz.aaz64 #MOD-A80017 Add l_npp08
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N' #NO.FUN-710023
           LET g_showmsg= gl_no,"/",g_aaz.aaz64                             #NO.FUN-710023
           CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba08/09:',SQLCA.sqlcode,1)    #NO.FUN-710023
       END IF
       PRINT
       LET gl_no[g_no_sp,g_no_ep]=''
END REPORT
 
FUNCTION p142_create_tmp()
   DROP TABLE p142_tmp;
 
   #寫入暫存檔
   #No.TQC-9B0039  --Begin
   #SELECT 'xxxxxxxxxxxx' order1, npp_file.*,npq_file.*,
   #       SPACE(40) remark1
   #  FROM npp_file,npq_file
   # WHERE npp01 = npq01 AND npp01 = '@@@@'
   #  INTO TEMP p142_tmp
   SELECT chr30 order1, npp_file.*,npq_file.*,
          chr1000 remark1
     FROM npp_file,npq_file,type_file
    WHERE npp01 = npq01 AND npp01 = '@@@@'
      AND 1=0
     INTO TEMP p142_tmp
   #No.TQC-9B0039  --End  
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err3("sel","npp_file,npq_file","","",SQLCA.SQLCODE,"","create p142_tmp",0)
   END IF
 
   DELETE FROM p142_tmp WHERE 1=1
 
   LET gl_no_b=''
   LET gl_no_e=''
 
END FUNCTION
#CHI-AC0010
