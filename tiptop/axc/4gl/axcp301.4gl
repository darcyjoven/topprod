# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp301.4gl
# Descriptions...: CA系統傳票拋轉總帳
# Date & Author..: 05/01/25 By Carol
# Modify.........: No.FUN-510041 05/01/25 By Carol 新增成本拋轉傳票功能
# Modify.........: No.FUN-560190 05/06/28 By wujie 單據編號修改
# Modify ........: No.FUN-580111 05/08/24 By will 增加取得傳票缺號號碼的功能  
# Modify.........: No.MOD-5C0083 05/12/15 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-5C0015 BY GILL 新增abb31~37
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660032 06/06/12 By rainy 拋轉摘要預設為"Y"
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳別權限修改
# Modify.........: No.FUN-680086 06/08/25 By Elva 兩套帳內容修改
# Modify.........: No.FUN-680122 06/09/15 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-6A0022 06/11/17 By Smapmin 補上nppsys=npqsys的條件
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-750013 07/05/03 By Carol SQL加上npp00=npq00的條件
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-810186 08/01/25 By Smapmin 增加傳票是否自動確認的檢核
# Modify.........: No.FUN-810069 08/02/28 By yaofs 項目預算取消abb15的管控 
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改 
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法  
# Modify.........: No.FUN-9B0068 09/11/10 By lilingyu 臨時表字段改成like 的形式
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0073 09/12/10 By Carrier 不过plant字段时,g_dbs_new的赋值
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-A10006 10/01/13 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A60136 10/06/21 By Sarah aba20應預設為'0'
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24 預設值 
# Modify.........: No:FUN-AA0025 10/10/25 By wujie 新增成本分录结转相关修改
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:TQC-BA0149 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:TQC-BB0071 11/11/09 By wujie axcp301不关闭反复执行时，QBE条件会不断累加
# Modify.........: No:FUN-BB0038 11/11/09 By elva 成本改善,add npp00='9'
# Modify.........: No:MOD-C30039 12/03/06 By ck2yuan 增加s_chknpq檢查,修正使用l_totsuccess判斷
# Modify.........: No:FUN-C50131 12/06/01 By xuxz DROP TABLE 造成的提前COMMIT WORK 
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.MOD-D70057 13/07/09 by wujie 将chknpq拿出来，提高效率

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
 DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_dbs_gl         LIKE type_file.chr21     #No.FUN-680122 VARCHAR(21)
DEFINE g_plant_gl       LIKE type_file.chr21     #No.FUN-980059 VARCHAR(21)
DEFINE gl_no	        LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(16)	# 傳票單號 #No.FUN-560190
DEFINE gl_no1           LIKE type_file.chr20     #No.FUN-680122 VARCHAR(16)	# 傳票單號 #No.FUN-680086
DEFINE gl_no_b,gl_no_e  LIKE type_file.chr20     #No.FUN-680122CHAR(16)	# Generated 傳票單號  #No.FUN-560190 
DEFINE gl_no1_b,gl_no1_e  LIKE type_file.chr20   #No.FUN-680122CHAR(16)	# Generated 傳票單號  #No.FUN-680086 
DEFINE p_plant          LIKE tmn_file.tmn01      #No.FUN-680122CHAR(12)	
DEFINE l_plant_old      LIKE tmn_file.tmn01      #No.FUN-680122CHAR(12)       #No.FUN-580111  --add    
DEFINE p_bookno         LIKE aaa_file.aaa01  #No.FUN-670006
DEFINE p_bookno1        LIKE aaa_file.aaa01  #No.FUN-680086
DEFINE gl_date		LIKE type_file.dat       #No.FUN-680122 DATE
DEFINE gl_tran	        LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)
DEFINE g_t1	        LIKE type_file.chr5      # Prog. Version..: '5.30.06-13.03.12(05)        # No.FUN-560190     
DEFINE g_yy,g_mm	LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_statu          LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)
DEFINE g_aba01t         LIKE aba_file.aba01   # No.FUN-560190 
DEFINE p_row,p_col      LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_npp00          LIKE npp_file.npp00  
DEFINE g_flag           LIKE type_file.num5      #No.FUN-680122 SMALLINT  
DEFINE g_cnt            LIKE type_file.num10     #No.FUN-680122 INTEGER   
DEFINE g_i              LIKE type_file.num5      #No.FUN-680122 SMALLINT   #count/index for any purpose
DEFINE g_j              LIKE type_file.num5      #No.FUN-680122 SMALLINT   #No.FUN-580111  --add   
DEFINE l_flag          LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(1),                #No.FUN-570153
       g_change_lang   LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01),               #是否有做語言切換 No.FUN-570153
       ls_date         STRING                  #->No.FUN-570153
DEFINE g_aaz85          LIKE aaz_file.aaz85 #傳票是否自動確認   #MOD-810186
DEFINE g_wc1           STRING                    #No.TQC-BB0071 
DEFINE g_cka00          LIKE cka_file.cka00      #FUN-C80092 add
DEFINE g_cka09          LIKE cka_file.cka09      #FUN-C80092 add
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add
 
MAIN
#     DEFINE     l_time LIKE type_file.chr8              #No.FUN-6A0146
     DEFINE l_tmn02         LIKE tmn_file.tmn02     #No.FUN-670068 
     DEFINE l_tmn06         LIKE tmn_file.tmn06     #No.FUN-670068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc1    = ARG_VAL(1)   #No.TQC-BB0071                      
   LET p_plant  = ARG_VAL(2)                      
   LET p_bookno = ARG_VAL(3)                      
   LET gl_no    = ARG_VAL(4)                      
   LET ls_date  = ARG_VAL(5)                      
   LET gl_date  = cl_batch_bg_date_convert(ls_date)
   LET gl_tran  = ARG_VAL(6)                      
   LET g_bgjob  = ARG_VAL(7)                
   LET p_bookno1= ARG_VAL(8)         #FUN-680086              
   LET gl_no1   = ARG_VAL(9)         #FUN-680086  
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
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

   #No.FUN-580111  --begin      
   DROP TABLE agl_tmp_file       
#FUN-9B0068 --BEGIN--
#   CREATE TEMP TABLE agl_tmp_file 
#   (tc_tmp00     VARCHAR(1) NOT NULL,            
#    tc_tmp01     SMALLINT,                   
#    tc_tmp02     VARCHAR(20),
# Prog. Version..: '5.30.06-13.03.12(05))  #FUN-680086       帳套二          

   CREATE TEMP TABLE agl_tmp_file(            
   tc_tmp00     LIKE type_file.chr1 NOT NULL,            
    tc_tmp01    LIKE type_file.num10, 
    tc_tmp02    LIKE type_file.chr20, 
    tc_tmp03    LIKE type_file.chr5) 
#FUN-9B0068 --END--
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
       CALL cl_batch_bg_javamail("N")      #FUN-570153
       EXIT PROGRAM 
   END IF    
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03) #FUN-680086     
   IF STATUS THEN CALL cl_err('create index',STATUS,0)  
       CALL cl_batch_bg_javamail("N")      #FUN-570153
       EXIT PROGRAM 
   END IF 
   #No.FUN-580111  --end
 
#No.FUN-670068--begin
    DECLARE tmn_del CURSOR FOR
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'        
#No.FUN-670068--end  
         
#NO.FUN-570153 mark--
#   LET p_row = 1 LET p_col = 1
 
#    OPEN WINDOW p301 AT p_row,p_col WITH FORM "axc/42f/axcp301" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    
#    CALL cl_ui_init()
#
#    CALL cl_opmsg('z')
#    CALL p301()
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       #ELSE CALL cl_end(18,20)
#    END IF
 
#    CLOSE WINDOW p301
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p301_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         #No.TQC-9C0073  --Begin                                                
         LET g_plant_new= p_plant  # 工厂编号                                   
         CALL s_getdbs()                                                        
         LET g_dbs_gl=g_dbs_new    # 得资料库名称                               
         #No.TQC-9C0073  --End
         IF cl_sure(18,20) THEN 
            #FUN-C80092--add--str--
            LET g_cka09 = " p_plant='",p_plant,"'; p_bookno='",p_bookno,"'; gl_no='",gl_no,"'; gl_date='",gl_date,
                           "'; gl_tran='",gl_tran,"'; g_bgjob='",g_bgjob,"'; p_bookno1='",p_bookno1,
                           "'; gl_no1='",gl_no1,"' "
            CALL s_log_ins(g_prog,'','',g_wc1,g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end--
            BEGIN WORK
            LET g_success = 'Y'
            LET g_ccz.ccz12 = p_bookno  # 得帳別
            #FUN-680086  --begin
            IF g_aza.aza63 = 'Y' THEN
               LET g_ccz.ccz121 = p_bookno1  # 得帳別
            END IF
            #FUN-680086  --end
            CALL p301_t('0') #FUN-680086
            CALL s_showmsg()        #No.FUN-710027 
            #FUN-680086  --begin
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p301_t('1') #FUN-680086
               CALL s_showmsg()        #No.FUN-710027 
            END IF
            #FUN-680086  --end
            IF g_success = 'Y' THEN
               COMMIT WORK
#               CALL s_m_prtgl(g_dbs_gl,g_ccz.ccz12,gl_no_b,gl_no_e)   #FUN-990069
               CALL s_m_prtgl(g_plant_gl,g_ccz.ccz12,gl_no_b,gl_no_e)   #FUN-990069
               #FUN-680086  --begin
               IF g_aza.aza63 = 'Y' THEN
#                  CALL s_m_prtgl(g_dbs_gl,g_ccz.ccz121,gl_no1_b,gl_no1_e)#FUN-990069
                  CALL s_m_prtgl(g_plant_gl,g_ccz.ccz121,gl_no1_b,gl_no1_e)#FUN-990069
               END IF
               #FUN-680086  --end
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
               CLOSE WINDOW p301
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p301
      ELSE
         #FUN-C80092--add--str--
         LET g_cka09 = " p_plant='",p_plant,"'; p_bookno='",p_bookno,"'; gl_no='",gl_no,"'; gl_date='",gl_date,
                       "'; gl_tran='",gl_tran,"'; g_bgjob='",g_bgjob,"'; p_bookno1='",p_bookno1,
                       "'; gl_no1='",gl_no1,"' "
         CALL s_log_ins(g_prog,'','',g_wc1,g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--
         BEGIN WORK
         LET g_success = 'Y'
         LET g_ccz.ccz12 = p_bookno  # 得帳別
         #FUN-680086  --begin
         IF g_aza.aza63 = 'Y' THEN
            LET g_ccz.ccz121 = p_bookno1  # 得帳別
         END IF
         #FUN-680086  --end
         #No.TQC-9C0073  --Begin                                                
         LET g_plant_new= p_plant  # 工厂编号                                   
         CALL s_getdbs()                                                        
         LET g_dbs_gl=g_dbs_new    # 得资料库名称                               
         #No.TQC-9C0073  --End  
         CALL p301_t('0') #FUN-680086
         CALL s_showmsg()        #No.FUN-710027 
         #FUN-680086  --begin
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL p301_t('1') #FUN-680086
            CALL s_showmsg()        #No.FUN-710027 
         END IF
         #FUN-680086  --end
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
#            CALL s_m_prtgl(g_dbs_gl,g_ccz.ccz12,gl_no_b,gl_no_e)  #FUN-990069
            CALL s_m_prtgl(g_plant_gl,g_ccz.ccz12,gl_no_b,gl_no_e)  #FUN-990069
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#  CALL cl_used('axcp301',l_time,2) RETURNING l_time
#->No.FUN-570153 ---end---
 
#No.FUN-670068--begin 
         FOREACH tmn_del INTO l_tmn02,l_tmn06 
            DELETE FROM tmn_file
            WHERE tmn01 = p_plant
              AND tmn02 = l_tmn02  
              AND tmn06 = l_tmn06  
         END FOREACH
    #No.FUN-580111  --start          
#   DELETE FROM tmn_file    
#    WHERE tmn01 = p_plant 
#      AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y') 
#No.FUN-670068--end
    #No.FUN-580111  --end  
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
END MAIN
 
FUNCTION p301()
   WHILE TRUE 
     LET g_success=""
     CLEAR FORM
     CALL p301_ask()
     IF INT_FLAG THEN RETURN END IF
     IF NOT cl_sure(20,20) THEN LET INT_FLAG = 1 RETURN END IF
     CALL cl_wait()
 
     LET g_ccz.ccz12 = p_bookno  # 得帳別
     #FUN-680086  --begin
     IF g_aza.aza63 = 'Y' THEN
        LET g_ccz.ccz121 = p_bookno1  # 得帳別
     END IF
     #FUN-680086  --end
 
     LET p_row = 19 LET p_col = 20
     CALL p301_t('0') #FUN-680086
     #FUN-680086  --begin
     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        CALL p301_t('1') #FUN-680086
     END IF
     #FUN-680086  --end
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
 
FUNCTION p301_ask()
   DEFINE   l_aaa07   LIKE aaa_file.aaa07
   DEFINE   l_flag    LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
   DEFINE   li_result LIKE type_file.num5      #No.FUN-680122 SMALLINT   #No.FUN-560190
   DEFINE   l_cnt     LIKE type_file.num5      #No.FUN-680122 SMALLINT   #No.FUN-580111  -add      
   DEFINE   lc_cmd    LIKE type_file.chr1000   #No.FUN-680122     VARCHAR(500)            #No.FUN-570153
   DEFINE   li_chk_bookno  LIKE type_file.num5,      #No.FUN-680122 SMALLINT,   #No.FUN-670006
            l_sql            STRING    #No.FUN-670006  -add
   DEFINE l_tmn02         LIKE tmn_file.tmn02     #No.FUN-670068 
   DEFINE l_tmn06         LIKE tmn_file.tmn06     #No.FUN-670068 
   DEFINE   l_no           LIKE type_file.chr3    #No.FUN-840125                
   DEFINE   l_no1          LIKE type_file.chr3    #No.FUN-840125                
   DEFINE   l_aac03        LIKE aac_file.aac03    #No.FUN-840125  
   DEFINE   l_aac03_1      LIKE aac_file.aac03    #No.FUN-840125  
#->No.FUN-570153 ---start---
   LET p_row = 1 LET p_col = 1
 
    OPEN WINDOW p301 AT p_row,p_col WITH FORM "axc/42f/axcp301" 
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    #FUN-680086  --begin
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)
    END IF
    #FUN-680086  --end
    CALL cl_opmsg('z')
 
#->No.FUN-570153 ---end---
#No.TQC-BB0071 --begin   
#No.FUN-AA0025 --begin
#   IF NOT cl_null(g_wc) THEN 
#      DISPLAY g_wc TO npp01
#      LET g_wc = "npp01 ='",g_wc CLIPPED,"'"
#   ELSE  
   LET g_wc = NULL 
   IF NOT cl_null(g_wc1) THEN 
      DISPLAY g_wc1 TO npp01
      LET g_wc = "npp01 ='",g_wc1 CLIPPED,"'"
   ELSE
#No.FUN-AA0025 --end 
#No.TQC-BB0071 --end  
   CONSTRUCT BY NAME g_wc ON npp01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
#NO.FUN-570153 mark
#         LET g_action_choice = "locale" 
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570153 mark
         LET g_change_lang = TRUE         #NO.FUN-570153 
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
   END IF        #No.FUN-AA0025
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#NO.FUN-570153 start--
#   IF INT_FLAG THEN 
#      RETURN 
#   END IF
 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      RETURN             
#   END IF
   #->No.FUN-570153 --start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p301
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#NO.FUN-570153 end---
 
   LET p_plant = g_ccz.ccz11 
   LET l_plant_old = p_plant      #No.FUN-580111  --add   
   LET p_bookno= g_ccz.ccz12 
   LET p_bookno1= g_ccz.ccz121 #FUN-680086
   LET gl_date = g_today
   #LET gl_tran = 'N'   # FUN-660032
   LET gl_tran = 'Y'    # FUN-660032
   LET g_bgjob = 'N'    # FUN-570153
 
   INPUT BY NAME p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,gl_tran,g_bgjob #FUN-680086
   #INPUT BY NAME p_plant,p_bookno,gl_no,gl_date,gl_tran 
      WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)   #No.FUN-580111  --add UNBUFFERED
 
      AFTER FIELD p_plant
         SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         IF STATUS <> 0 THEN
#           CALL cl_err(p_plant,'mfg9142',1)   #No.FUN-660127
            CALL cl_err3("sel","azp_file",p_plant,"","mfg9142","","",1)   #No.FUN-660127
            NEXT FIELD p_plant
         END IF
 
        #得出總帳 database name 
        #g_ccz.ccz11 -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
         #No.FUN-580111  --begin           
         IF l_plant_old != p_plant THEN   
#No.FUN-670068--begin
            FOREACH tmn_del INTO l_tmn02,l_tmn06 
               DELETE FROM tmn_file  
               WHERE tmn01 = p_plant_old 
                 AND tmn02 = l_tmn02
                 AND tmn06 = l_tmn06 
            END FOREACH   
#           DELETE FROM tmn_file         
#            WHERE tmn01 = l_plant_old  
#              AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
#No.FUN-670068--end
            DELETE FROM agl_tmp_file          
            LET l_plant_old = g_plant_new      
         END IF                               
         #No.FUN-580111  --end  
 
      AFTER FIELD p_bookno
         IF p_bookno IS NULL THEN
            NEXT FIELD p_bookno
         END IF
         #No.FUN-670006--begin
             CALL s_check_bookno(p_bookno,g_user,p_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD p_bookno
             END IF 
             LET g_plant_new = p_plant  #工廠編號
                 #CALL s_getdbs() #FUN-A50102
                 LET l_sql = "SELECT COUNT(*) ",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                             " WHERE aaa01 = '",p_bookno,"' ",
                             "   AND aaaacti IN ('Y','y') "
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE p301_pre2 FROM l_sql
                 DECLARE p301_cur2 CURSOR FOR p301_pre2
                 OPEN p301_cur2
                 FETCH p301_cur2 INTO g_cnt
#        SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=p_bookno
          #No.FUN-670006--end
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno
         END IF
 
      AFTER FIELD gl_no
         #No.FUN-560190  --start--
#         CALL s_check_no("agl",gl_no,"","1","abb_file","abb01",g_dbs_gl)   #MOD-5C0083
        #CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",g_dbs_gl)    #MOD-5C0083 #FUN-980094
         CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",p_plant)    #MOD-5C0083 #FUN-980094
              RETURNING li_result,gl_no
#         CALL s_get_doc_no(gl_no) RETURNING gl_no    #MOD-5C0083
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
#        CALL s_aglslip(g_t1,'*','AGL')   # 單別,單據性質(全部)
#        IF NOT cl_null(g_errno) THEN
#           CALL cl_err(g_t1,g_errno,0)
#           NEXT FIELD gl_no
#        END IF                          
#       
#        LET g_errno=' '
#        CALL s_chkno(gl_no) RETURNING g_errno
#        IF NOT cl_null(g_errno) THEN
#           CALL cl_err(gl_no,g_errno,0)
#           NEXT FIELD gl_no
#        END IF
#      
#        CALL s_m_aglsl(g_dbs_gl,gl_no,'1')
#        IF NOT cl_null(g_errno) THEN 
#           CALL cl_err(gl_no,g_errno,0)
#           NEXT FIELD gl_no
#        END IF  
         #No.FUN-560190  --end--
 
      #FUN-680086  --begin
      AFTER FIELD p_bookno1
         IF NOT cl_null(p_bookno1) THEN
         #No.FUN-670006--begin
             IF p_bookno = p_bookno1 THEN
                CALL cl_err('sel aaa','afa-888',0)
                NEXT FIELD p_bookno1
             END IF
             CALL s_check_bookno(p_bookno1,g_user,p_plant)
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD p_bookno1
             END IF 
             LET g_plant_new = p_plant  #工廠編號
             #CALL s_getdbs()   #FUN-A50102
             LET l_sql = "SELECT COUNT(*) ",
                         #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                         "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),#FUN-A50102
                         " WHERE aaa01 = '",p_bookno1,"' ",
                         "   AND aaaacti IN ('Y','y') "
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
             PREPARE p301_pre3 FROM l_sql
             DECLARE p301_cur3 CURSOR FOR p301_pre3
             OPEN p301_cur3
             FETCH p301_cur3 INTO g_cnt
          #No.FUN-670006--end
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno1
            END IF
         END IF
 
      AFTER FIELD gl_no1
         #No.FUN-560190  --start--
#         CALL s_check_no("agl",gl_no,"","1","abb_file","abb01",g_dbs_gl)   #MOD-5C0083
        #CALL s_check_no("agl",gl_no1,"","1","aac_file","aac01",g_dbs_gl)    #MOD-5C0083 #FUN-980094
         CALL s_check_no("agl",gl_no1,"","1","aac_file","aac01",p_plant)    #MOD-5C0083 #FUN-980094
              RETURNING li_result,gl_no1
#         CALL s_get_doc_no(gl_no) RETURNING gl_no    #MOD-5C0083
         IF (NOT li_result) THEN                                             
            NEXT FIELD gl_no1                                                 
         END IF  
        #No.FUN-840125---Begin                                                  
        LET l_no1 = gl_no1                                                        
        SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1               
        IF l_aac03_1 != '0' THEN                                                  
           CALL cl_err(gl_no1,'agl-991',0)                                       
           NEXT FIELD gl_no1                                                     
        END IF                                                                  
        #No.FUN-840125---End 
      #FUN-680086  --end
 
      AFTER FIELD gl_date
         IF gl_date IS NULL THEN
            NEXT FIELD gl_date
         END IF
         #No.FUN-670006--begin
             CALL s_check_bookno(p_bookno,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD gl_date
             END IF 
             #No.FUN-670006--end
         SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
         IF gl_date <= l_aaa07 THEN    
            CALL cl_err('','axm-164',0) NEXT FIELD gl_date
         END IF
         
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
#           CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)   #No.FUN-660127
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
         IF cl_null(p_plant)    THEN
            LET l_flag='Y'
         END IF
         IF cl_null(p_bookno)   THEN 
            LET l_flag='Y'
         END IF
         #No.FUN-560190  --start--
     #   IF gl_no[1,3] IS NULL or gl_no[1,3] = ' ' THEN
         IF gl_no[1,g_doc_len] IS NULL or gl_no[1,g_doc_len] = ' ' THEN
         #No.FUN-560190  --end--
            LET l_flag='Y'
         END IF
         IF cl_null(gl_date)    THEN
            LET l_flag='Y'
         END IF
         IF cl_null(gl_tran)    THEN 
            LET l_flag='Y'
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
 
         # 得出總帳 database name
         # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
 
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
#           CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)   #No.FUN-660127
            NEXT FIELD gl_date
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gl_no)
#No.FUN-560190--begin
               CALL s_getdbs()                                                                                                            
               LET g_dbs_gl=g_dbs_new
               LET g_plant_gl= p_plant   #No.FUN-980059
#No.FUN-560190--end   
 
               #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1',' ',' ','AGL') #No.FUN-840125
            #  CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125    #No.FUN-980059
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                    RETURNING gl_no 
               DISPLAY BY NAME gl_no
               NEXT FIELD gl_no
 
            #FUN-680086 --begin
            WHEN INFIELD(gl_no1)
               CALL s_getdbs()                                                                                                            
               LET g_dbs_gl=g_dbs_new
 
               #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1',' ',' ','AGL') #No.FUN-840125 
            #  CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1','0',' ','AGL')  #No.FUN-840125    #No.FUN-980059
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                    RETURNING gl_no1 
               DISPLAY BY NAME gl_no1
               NEXT FIELD gl_no1
            #FUN-680086 --end  
            OTHERWISE 
               EXIT CASE
        END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     
     #No.FUN-580111  --begin              
      ON ACTION get_missing_voucher_no     
         IF cl_null(gl_no) AND cl_null(gl_no1) THEN  #No.FUN-680086 add AND cl_null(gl_no1)
            NEXT FIELD gl_no      
         END IF                    
                                    
#No.FUN-670068--begin 
         FOREACH tmn_del INTO l_tmn02,l_tmn06 
            DELETE FROM tmn_file
            WHERE tmn01 = p_plant
              AND tmn02 = l_tmn02  
              AND tmn06 = l_tmn06  
         END FOREACH 
#        DELETE FROM tmn_file        
#         WHERE tmn01 = p_plant       
#           AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
#No.FUN-670068--end
         DELETE FROM agl_tmp_file         
                                                                              
         CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0)       #No.FUN-680086
                                                              
         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file        
          WHERE tc_tmp00='Y'                       
         IF l_cnt > 0 THEN                          
            CALL cl_err(l_cnt,'aap-501',0)           
         ELSE                                         
            CALL cl_err('','aap-502',0)                
         END IF             
      #No.FUN-580111  --end  
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
 
#NO.FUN-570153 start--
      ON ACTION locale
         LET g_change_lang = TRUE         #NO.FUN-570153 
         EXIT INPUT 
#NO.FUN-570153 end--
 
   END INPUT
 
#NO.FUN-570153 start--
#->No.FUN-570153 ---start---
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p301
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#   IF INT_FLAG THEN
#      RETURN
#   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp301"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp301','9031',1)   
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
         CALL cl_cmdat('axcp301',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p301
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#->No.FUN-570153 ---end---   
END FUNCTION
 
FUNCTION p301_t(p_npptype) #FUN-680086
   DEFINE p_npptype     LIKE npp_file.npptype #FUN-680086
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_cmd         LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(30)
   DEFINE l_order       LIKE npp_file.npp01
   DEFINE l_remark      LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(150)  
   DEFINE l_name        LIKE type_file.chr20     #No.FUN-680122 VARCHAR(20)
   DEFINE l_flag        LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)
   DEFINE l_yy,l_mm     LIKE type_file.num5      #No.FUN-680122 SMALLINT
   DEFINE l_msg         LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(80)
   DEFINE l_aba11       LIKE aba_file.aba11      #FUN-840211
   DEFINE l_npp02b      LIKE npp_file.npp02      #CHI-9A0021 add
   DEFINE l_npp02e      LIKE npp_file.npp02      #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1      #CHI-9A0021 add  
#No.FUN-AA0025 --begin
   DEFINE l_cdl11       LIKE cdl_file.cdl11
   DEFINE l_nppglno     LIKE npp_file.nppglno  
   DEFINE l_chr         LIKE type_file.chr1
   DEFINE l_conf        LIKE cde_file.cdeconf
#No.FUN-AA0025 --end
   DEFINE l_npp01       LIKE npp_file.npp01    #TQC-BA0149
   DEFINE l_totsuccess  LIKE type_file.chr1      #MOD-C30039 add
   DEFINE l_yy1         LIKE type_file.num5      #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5      #CHI-CB0004
 
   LET g_success='Y'
   CALL p301_create_tmp(p_npptype) #FUN-680086
 
   #FUN-680086  --begin
   IF g_aza.aza63 = 'Y' THEN
      LET g_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,
                  " aznn_file WHERE aznn01 = '",gl_date,"'" 
      IF p_npptype = '0' THEN
         LET g_sql = g_sql CLIPPED," AND aznn00 = '",p_bookno,"'"
      ELSE
         LET g_sql = g_sql CLIPPED," AND aznn00 = '",p_bookno1,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      PREPARE azn_p1 FROM g_sql
      DECLARE azn_c1 CURSOR FOR azn_p1
      OPEN azn_c1
      FETCH azn_c1 INTO g_yy,g_mm
   ELSE
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
   END IF
   #FUN-680086  --end
 
  #當月起始日與截止日
   CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_npp02b,l_npp02e   #CHI-9A0021 add
 
  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
             "  FROM npp_file ",
             " WHERE nppsys= 'CA' AND (nppglno IS NULL OR nppglno='')",
           # "   AND npp00 = 1 ",  #FUN-AA0025
             "   AND npptype ='",p_npptype,"'", #FUN-680086
             "   AND ",g_wc CLIPPED,
            #CHI-9A0021 -- begin
            #"   AND ( YEAR(npp02)  !=YEAR('",gl_date,"') OR ",
            #"        (YEAR(npp02)   =YEAR('",gl_date,"') AND ",
            #"         MONTH(npp02) !=MONTH('",gl_date,"'))) "
             "   AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'"
            #CHI-9A0021 -- end
   PREPARE p301_0_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p301_0_p0',STATUS,1) RETURN END IF
   DECLARE p301_0_c0 CURSOR WITH HOLD FOR p301_0_p0
   LET l_flag='N'
   FOREACH p301_0_c0 INTO l_yy,l_mm
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
     IF g_aza.aza63 = 'Y' THEN 
        IF p_npptype = '0' THEN
           #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                       " WHERE aba00 =  '",p_bookno,"'"
                      ,"   AND aba19 <> 'X' "   #CHI-C80041 
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
        ELSE
           #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                       " WHERE aba00 =  '",p_bookno1,"'"
                      ,"   AND aba19 <> 'X' "   #CHI-C80041 
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
        END IF
     
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        PREPARE aba11_pre FROM g_sql
        EXECUTE aba11_pre INTO l_aba11
     ELSE 
       SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file 
         WHERE aba00 = p_bookno
           AND aba19 <> 'X'  #CHI-C80041 
           AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
     END IF
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
  
   #-----MOD-810186---------
   #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
   OPEN aaz85_cs
   FETCH aaz85_cs INTO g_aaz85
   IF STATUS THEN
      CALL cl_err('sel aaz85',STATUS,1)
      RETURN
   END IF
   #-----END MOD-810186-----
   
#No.MOD-D70057 --begin
    LET g_sql="SELECT *  ", 
               "  FROM npp_file",
             " WHERE nppsys= 'CA' AND (nppglno IS NULL OR nppglno='')",
             "   AND npptype ='",p_npptype,"'",
             "   AND ",g_wc CLIPPED
     PREPARE p301_1_p0_1 FROM g_sql
     DECLARE p301_1_c0_1 CURSOR WITH HOLD FOR p301_1_p0_1
     FOREACH p301_1_c0_1 INTO l_npp.*
        IF p_npptype = '0' THEN
           CALL s_chknpq(l_npp.npp01,'CA',l_npp.npp011,p_npptype,p_bookno)
        ELSE
           CALL s_chknpq(l_npp.npp01,'CA',l_npp.npp011,p_npptype,p_bookno1)
        END IF

        IF g_success='N' THEN
           LET l_totsuccess='N'
           LET g_success="Y"
        END IF
      END FOREACH
#No.MOD-D70057 --end 

   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             "  FROM npp_file,npq_file ",
             " WHERE nppsys= 'CA' AND (nppglno IS NULL OR nppglno='')",
             "   AND npp01 = npq01 AND npp011=npq011",
             "   AND npptype ='",p_npptype,"'", #FUN-680086
             "   AND npptype = npqtype ", #FUN-680086
             "   AND nppsys = npqsys",   #CHI-6A0022
             "   AND ",g_wc CLIPPED,
           # "   AND npp00 = 1 ",  #FUN-AA0025
             "   AND npp00 = npq00 ",    #MOD-750013 add
             " ORDER BY npq06,npq03,npq05,npq24,npq25 "
   IF gl_tran = 'N' THEN 
      LET g_sql=g_sql CLIPPED,",npq11,npq12,npq13,npq14,npq15,npq08,npq01"
   ELSE 
      LET g_sql=g_sql CLIPPED,",npq04,npq11,npq12,npq13,npq14,npq15,npq08,npq01"
   END IF
 
   PREPARE p301_1_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p301_1_p0',STATUS,1) 
       CALL cl_batch_bg_javamail("N")      #FUN-570153
       CALL s_log_upd(g_cka00,'N')         #FUN-C80092 add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
   DECLARE p301_1_c0 CURSOR WITH HOLD FOR p301_1_p0
   CALL cl_outnam('axcp301') RETURNING l_name
   #FUN-680086  --begin
   IF p_npptype = '0' THEN
      START REPORT axcp301_rep TO l_name
   ELSE
      START REPORT axcp301_rep2 TO l_name
   END IF
   #FUN-680086  --end  
#   BEGIN WORK  #NO.FUN-570153 
   WHILE TRUE
      CALL s_showmsg_init()   #No.FUN-710027   
      FOREACH p301_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
#            CALL cl_err('foreach:',STATUS,1)             #No.FUN-710027
             CALL s_errmsg('','','foreach:',STATUS,1)     #No.FUN-710027   
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
#No.FUN-AA0025 --begin  
         #杂项进出分录未抛转时杂项进出差异分录不能抛转
         LET l_cdl11 = NULL
         SELECT DISTINCT cdl11 INTO l_cdl11 FROM cdl_file
          WHERE cdl12 = l_npp.npp01
         IF NOT cl_null(l_cdl11) THEN  
            LET l_nppglno = NULL
            SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = l_cdl11 AND nppsys ='CA' AND npp00 =6 AND npp011 =1 AND npptype=p_npptype
            IF cl_null(l_nppglno) THEN 
               CALL cl_err('','axc-527',0)
               LET g_success ='N'
               EXIT FOREACH  
            END IF
         END IF 
      #   LET l_chr = l_npq.npq01[1,1] 
      #   IF l_chr MATCHES '[ABCDEF]' THEN 
      #      CASE WHEN l_chr ='A' SELECT DISTINCT cdeconf INTO l_conf FROM cde_file WHERE cde05 = l_npq.npq01        
      #           WHEN l_chr ='B' SELECT DISTINCT cdgconf INTO l_conf FROM cdg_file WHERE cdg05 = l_npq.npq01 
      #           WHEN l_chr ='C' SELECT DISTINCT cdjconf INTO l_conf FROM cdj_file WHERE cdj13 = l_npq.npq01 
      #           WHEN l_chr ='D' SELECT DISTINCT cdkconf INTO l_conf FROM cdk_file WHERE cdk10 = l_npq.npq01 
      #           WHEN l_chr ='E' SELECT DISTINCT cdlconf INTO l_conf FROM cdl_file WHERE cdl11 = l_npq.npq01 
      #           WHEN l_chr ='F' SELECT DISTINCT cdlconf1 INTO l_conf FROM cdl_file WHERE cdl12 = l_npq.npq01 
      #      END CASE 
      #      IF l_conf ='N' THEN LET g_success ='N' CONTINUE FOREACH END IF 
      #   END IF 
      #  IF l_npp.npp00 >= 2 AND l_npp.npp00 <= 7 THEN  #FUN-BB0038
         IF l_npp.npp00 MATCHES '[2345679]' THEN  #FUN-BB0038
            CASE WHEN l_npp.npp00 = 2 SELECT DISTINCT cdeconf INTO l_conf FROM cde_file WHERE cde05 = l_npq.npq01        
                 WHEN l_npp.npp00 = 3 SELECT DISTINCT cdgconf INTO l_conf FROM cdg_file WHERE cdg05 = l_npq.npq01 
                 WHEN l_npp.npp00 = 4 SELECT DISTINCT cdjconf INTO l_conf FROM cdj_file WHERE cdj13 = l_npq.npq01 
                 WHEN l_npp.npp00 = 5 SELECT DISTINCT cdkconf INTO l_conf FROM cdk_file WHERE cdk10 = l_npq.npq01 
                 WHEN l_npp.npp00 = 6 SELECT DISTINCT cdlconf INTO l_conf FROM cdl_file WHERE cdl11 = l_npq.npq01 
                 WHEN l_npp.npp00 = 7 SELECT DISTINCT cdlconf1 INTO l_conf FROM cdl_file WHERE cdl12 = l_npq.npq01 
                 WHEN l_npp.npp00 = 9 SELECT DISTINCT cdmconf INTO l_conf FROM cdm_file WHERE cdm10 = l_npq.npq01  #FUN-BB0038
            END CASE 
            IF l_conf ='N' THEN LET g_success ='N' CONTINUE FOREACH END IF 
         END IF
#No.FUN-AA0025 --end
#No.FUN-710027--begin 
         IF g_success='N' THEN  
           #LET g_totsuccess='N'      #MOD-C30039 mark
            LET l_totsuccess='N'      #MOD-C30039 add
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
#No.MOD-D70057 --begin
#MOD-C30039 str add-----
#        IF p_npptype = '0' THEN
#           CALL s_chknpq(l_npq.npq01,'CA',l_npq.npq011,p_npptype,p_bookno)
#        ELSE
#           CALL s_chknpq(l_npq.npq01,'CA',l_npq.npq011,p_npptype,p_bookno1)
#        END IF
#
#        IF g_success='N' THEN
#           LET l_totsuccess='N'
#           LET g_success="Y"
#        END IF
#MOD-C30039 end add-----
#No.MOD-D70057 --end 
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
 
         INSERT INTO p301_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
             IF SQLCA.SQLCODE THEN
#                 CALL cl_err('l_order:',STATUS,1)   #No.FUN-660127
#                 CALL cl_err3("ins","p301_tmp","","",STATUS,"","l_order",1)   #No.FUN-660127 #No.FUN-710027
                 CALL s_errmsg('','','l_order',STATUS,1)                                      #No.FUN-710027
             END IF
 
      END FOREACH
#No.FUN-710027--begin 
     #IF g_totsuccess="N" THEN     #MOD-C30039 mark
      IF l_totsuccess="N" THEN     #MOD-C30039 add
           LET g_success="N"
      END IF 
#No.FUN-710027--end
      LET l_npp01 = NULL   #No.TQC-BA0149 
      DECLARE p301_tmpcs CURSOR FOR
          SELECT * FROM p301_tmp
           ORDER BY order1,npp01,npq06,npq03,npq05,  #No.TQC-BA0149 add npp01
                    npq24,npq25,remark1,npq01
          FOREACH p301_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
              IF STATUS THEN
#                 CALL cl_err('order:',STATUS,1)           #No.FUN-710027
                  CALL s_errmsg('','','order:',STATUS,1)   #No.FUN-710027
                  EXIT FOREACH
              END IF
#No.FUN-710027--begin 
              IF g_success='N' THEN  
                #LET g_totsuccess='N'      #MOD-C30039 mark
                 LET l_totsuccess='N'      #MOD-C30039 add  
                 LET g_success="Y"   
              END IF 
#No.FUN-710027--end
              #No.TQC-BA0149  --Begin
              IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
                 LET l_npp.npp08 = 0
              END IF
              LET l_npp01 = l_npp.npp01
              #No.TQC-BA0149  --End
              #FUN-680086  --begin
              IF p_npptype = '0' THEN
                 OUTPUT TO REPORT axcp301_rep(l_order,l_npp.*,l_npq.*,l_remark)
              ELSE
                 OUTPUT TO REPORT axcp301_rep2(l_order,l_npp.*,l_npq.*,l_remark)
              END IF
              #FUN-680086  --end
          END FOREACH
#No.FUN-710027--begin 
     #IF g_totsuccess="N" THEN     #MOD-C30039 mark
      IF l_totsuccess="N" THEN     #MOD-C30039 add
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
      EXIT WHILE
   END WHILE
   #FUN-680086  --begin
   IF p_npptype = '0' THEN
      FINISH REPORT axcp301_rep
   ELSE
      FINISH REPORT axcp301_rep2
   END IF
   #FUN-680086  --end
 
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009 
#NO.FUN-570153 mark--
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL s_m_prtgl(g_dbs_gl,g_ccz.ccz12,gl_no_b,gl_no_e)
#   ELSE 
#      ROLLBACK WORK
#   END IF
#   DROP TABLE p301_tmp
#NO.FUN-570153 mark--
END FUNCTION
 
REPORT axcp301_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order        LIKE npp_file.npp01
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5      #No.FUN-680122 SMALLINT          #傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf    LIKE npq_file.npq07
  DEFINE l_no           LIKE fcx_file.fcx01  
  DEFINE l_remark       LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(150)  
  DEFINE l_p1       LIKE type_file.chr2      #No.FUN-680122 VARCHAR(02)
  DEFINE l_p2       LIKE type_file.num5      #No.FUN-680122 SMALLINT
  DEFINE l_p3       LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
  DEFINE l_p4       LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
  DEFINE li_result  LIKE type_file.num5      #No.FUN-680122 SMALLINT       #No.FUN-560190
  DEFINE l_missingno    LIKE aba_file.aba01  #No.FUN-580111  --add  
  DEFINE l_flag1        LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)              #No.FUN-580111  --add  
  DEFINE l_plant    LIKE azp_file.azp01   #FUN-980009 add
  DEFINE l_legal    LIKE azw_file.azw02   #FUN-980009 add
  DEFINE l_npp08    LIKE npp_file.npp08   #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021
 #FUN-C70093--ADD--STR
  DEFINE l_npp01     LIKE npp_file.npp01
  DEFINE l_cdm02     LIKE cdm_file.cdm02
  DEFINE l_cdm03     LIKE cdm_file.cdm03
  DEFINE l_cdm04     LIKE cdm_file.cdm04
  DEFINE l_cdm05     LIKE cdm_file.cdm05
  DEFINE l_cdm06     LIKE cdm_file.cdm06
  DEFINE l_cdm11     LIKE cdm_file.cdm11   
 #FUN-C70093--ADD--END
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                    l_npq.npq01,l_remark
 
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
   #缺號使用                         
   #No.FUN-580111  --begin            
   LET l_flag1='N'                     
   LET l_missingno = NULL               
   LET g_j=g_j+1                         
   SELECT tc_tmp02 INTO l_missingno       
     FROM agl_tmp_file      
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'   
      AND tc_tmp03=p_bookno #FUN-680086
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                          
      LET gl_no=l_missingno                   
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no        
                                AND tc_tmp03 = p_bookno #FUN-680086
   END IF                                      
                                                
   #缺號使用完，再在流水號最大的編號上增加       
   IF l_flag1='N' THEN  
     #No.FUN-CB0096 ---start--- Add
      LET t_no = Null
      CALL s_log_check(l_order) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET gl_no = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---end  --- Add
   #No.FUN-580111  --end 
#No.FUN-560190--start
     #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",g_dbs_gl,"",g_ccz.ccz12) #FUN-980094 mark
      CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",g_ccz.ccz12) #FUN-980094
           RETURNING li_result,gl_no
      END IF   #No.FUN-CB0096   Add
      IF (NOT li_result) THEN
         LET g_success = 'N'
      END IF
#     CALL s_m_aglau(g_dbs_gl,g_ccz.ccz12,gl_no,gl_date,g_yy,g_mm,0)
#          RETURNING g_i,gl_no
#     PRINT "Get max TR-no:",gl_no," Return code(g_i):",g_i
#     IF g_i != 0 THEN LET g_success = 'N' END IF
#No.FUN-560190--end  
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
          MESSAGE "Insert G/L voucher no:",gl_no 
          CALL ui.Interface.refresh()
      END IF
      PRINT "Insert aba:",g_ccz.ccz12,' ',gl_no,' From:',l_order
   END IF  #No.FUN-580111  -add 
  #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",
   LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
              "(aba00,aba01,aba02,aba03,aba04,",
              " aba05,aba06,aba07,aba08,aba09,",
              " aba12,aba19,aba20,abamksg,abapost,",  #MOD-A60136 add aba20
              " abaprno,abaacti,abauser,abagrup,abadate,",
              " abasign,abadays,abaprit,abasmax,abasseq,",
              " abamodu,aba11,abalegal,abaoriu,abaorig,",  #FUN-840211 add aba11  #FUN-980009 add abalegal
              " aba21,aba24)",  #FUN-A10006 add aba21 #MOD-A80136 add aba24
              " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "         ?,?,?,?,?, ?,?,?,?,?, ?,?)" #FUN-840211 add ?  #MOD-A60136 add ?  #FUN-840211 add ? #FUN-980009 add ?  #FUN-A10006 add ? #MOD-A80136 add ?
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   LET l_plant = g_plant_new  #FUN-980009 add
   CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980009 add
   PREPARE p301_1_p4 FROM g_sql
 
   #自動賦予簽核等級
   LET g_aba.aba01=gl_no
   #No.FUN-560190  --start--
   LET g_aba01t = gl_no[1,g_doc_len]
   #No.FUN-560190  --end--
   SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
     INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
          g_aba.abaprit,g_aba.abasign
     FROM aac_file WHERE aac01 = g_aba01t
   IF g_aba.abamksg MATCHES  '[Yy]' THEN
      IF g_aac.aacatsg matches'[Yy]' THEN   #自動付予
         CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
              RETURNING g_aba.abasign
      END IF
      SELECT COUNT(*) INTO g_aba.abasmax
        FROM azc_file
       WHERE azc01=g_aba.abasign
   END IF
 
   #將常數轉變數
   LET l_p1='CA'
   LET l_p2='0'
   LET l_p3='N'
   LET l_p4='Y'
   LET g_aba.aba20='0'   #MOD-A60136 add
 
   EXECUTE p301_1_p4 USING
      g_ccz.ccz12,  gl_no,        gl_date,       g_yy,         g_mm,
      g_today,      l_p1,         l_order,       l_p2,         l_p2,
      l_p3,         l_p3,         g_aba.aba20,   g_aba.abamksg,l_p3,     #MOD-A60136 add g_aba.aba20
      l_p2,         l_p4,         g_user,        g_grup,       g_today,
      g_aba.abasign,g_aba.abadays,g_aba.abaprit, g_aba.abasmax,l_p2,
      g_user,       g_aba.aba11,  l_legal,       g_user,       g_grup,   #FUN-A10036  #FUN-840211 add aba11 #FUN-980009 add l_legal
      l_npp.npp08,  g_user                                               #FUN-A10006 add npp08 #MOD-A80136 add g_useR
   IF STATUS THEN
      CALL cl_err('ins aba:',STATUS,1)
      LET g_success = 'N'
   END IF
   DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-580111
                          AND tmn06 = p_bookno #FUN-680086
   IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
   LET gl_no_e = gl_no
   LET l_credit = 0
   LET l_debit  = 0
   LET l_seq = 0
 
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     #FUN-C70093--ADD--STR
     CASE  WHEN l_npp.npp00=9  
        DECLARE cdm_cs CURSOR FOR
         SELECT cdm02,cdm03,cdm04,cdm05,cdm06,cdm11 FROM cdm_file
          WHERE cdm10=l_npp.npp01
        FOREACH cdm_cs INTO l_cdm02,l_cdm03,l_cdm04,l_cdm05,l_cdm06,l_cdm11
         UPDATE ccb_file SET ccbglno=gl_no
           WHERE ccb01=l_cdm06
             AND ccb02=l_cdm02
             AND ccb03=l_cdm03
             AND ccb04=l_cdm11
             AND ccb06=l_cdm04
             AND ccb07=l_cdm05
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ccb_file",l_npp.npp00,gl_no,SQLCA.sqlcode,"","upd npp03/glno:",0)   #No.FUN-660127    #wujie 130627
            LET g_success = 'N'
         END IF
        END FOREACH
     END CASE
      #FUN-C70093--ADD--END 
     UPDATE npp_file SET npp03  = gl_date, 
                         nppglno= gl_no,
                         npp06  = p_plant, 
                         npp07  = p_bookno 
      WHERE npp01 = l_npp.npp01
        AND npp011= l_npp.npp011
        AND npp00 = l_npp.npp00
        AND nppsys= l_npp.nppsys
        AND npptype= '0' #FUN-680086
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('upd npp03/glno:',SQLCA.sqlcode,1)    #No.FUN-660127
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",0)   #No.FUN-660127   #wujie 130627
        LET g_success = 'N'
     END IF
 
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN  #NO.FUN-570153 
         MESSAGE "Seq:",l_seq 
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                 "(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,",
                 " abb08,abb11,abb12,abb13,abb14,",
 
                 #FUN-5C0015 BY GILL --START
                 " abb31,abb32,abb33,abb34,abb35,abb36,abb37,",
                 #FUN-5C0015 BY GILL --END
 
           #      " abb15,abb24,abb25)",               #No.FUN-810069
                 " abb24,abb25,abblegal)",                      #No.FUN-810069 #FUN-980009 add abblegal
                 " VALUES(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,",
                 
                 #FUN-5C0015 BY GILL--START
                 "?,?,?,?,?,?,?,",
                 #FUN-5C0015 BY GILL--EN
 
          #       " ?,?,?)"                             #No.FUN-810069
                 " ?,?, ?)"                                #No.FUN-810069   #FUN-980009 add ?
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     LET l_plant = g_plant_new  #FUN-980009 add
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980009 add
     PREPARE p301_1_p5 FROM g_sql
     EXECUTE p301_1_p5 USING 
             g_ccz.ccz12,
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
 
             #FUN-5C0015 BY GILL --START
             l_npq.npq31,
             l_npq.npq32,
             l_npq.npq33,
             l_npq.npq34,
             l_npq.npq35,
             l_npq.npq36,
             l_npq.npq37,
             #FUN-5C0015 BY GILL --END
 
       #      l_npq.npq15,                #No.FUN-810069
             l_npq.npq24,
             l_npq.npq25
             ,l_legal         #FUN-980009 add l_legal
 
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',STATUS,1) 
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1' THEN 
        LET l_debit  = l_debit  + l_amt
     ELSE 
        LET l_credit = l_credit + l_amt
     END IF
 
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
 
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED," aba_file ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  " SET aba08 = ?, ",
                  "     aba09 = ?  ",
                  "    ,aba21 = ? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? ",
                  "   AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p301_1_p6 FROM g_sql
      EXECUTE p301_1_p6 USING l_debit,l_credit,l_npp08,gl_no,g_ccz.ccz12  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',g_ccz.ccz12,gl_no,gl_date,l_p3,'',TRUE)   #No.TQC-B70021   

      #-----MOD-810186---------
      IF g_aaz85 = 'Y' THEN 
            #若有立沖帳管理就不做自動確認
            #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'abb_file'),",","aag_file",#FUN-A50102
                        " WHERE abb01 = '",gl_no,"'",
                        "   AND abb00 = '",g_ccz.ccz12,"'",  
                        "   AND abb03 = aag01  ",
                        "   AND abb00 = aag00  ",        
                        "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE count_pre FROM g_sql
            DECLARE count_cs CURSOR FOR count_pre
            OPEN count_cs 
            FETCH count_cs INTO g_cnt
            CLOSE count_cs
            IF g_cnt = 0 THEN
               IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
               IF g_aba.abamksg='N' THEN   
                  LET g_aba.aba20='1' 
                  LET g_aba.aba19 = 'Y'
                  #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (g_ccz.ccz12,gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end 
                  LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                              "    SET abamksg = ? ,",
                                     " abasign = ? ,", 
                                     " aba18   = ? ,",
                                     " aba19   = ? ,",
                                     " aba20   = ? ,",
                                     " aba37   = ?  ",   
                               " WHERE aba01 = ? AND aba00 = ? "
 	              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                  PREPARE upd_aba19 FROM g_sql
                  EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                          g_aba.aba18  ,g_aba.aba19,
                                          g_aba.aba20  ,
                                          g_user,    
                                          gl_no     ,g_ccz.ccz12  
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
                  END IF
               END IF   
            END IF
      END IF     
      #-----END MOD-810186-----
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      #No.FUN-560190  --start--
      #LET gl_no[4,12]=''
      LET gl_no[g_no_sp,g_no_ep]=''
      #No.FUN-560190  --end--
END REPORT
 
FUNCTION p301_create_tmp(p_npptype) #FUN-680086
DEFINE  p_npptype  LIKE npp_file.npptype  #FUN-680086
    DELETE FROM p301_tmp #FUN-C50131 add
#   DROP TABLE p301_tmp;
 
#寫入暫存檔
 #No.TQC-9B0039  --Begin
 #SELECT 'xxxxxxxxxxxx' order1, npp_file.*,npq_file.*,
 #       SPACE(100) remark1
 #  FROM npp_file,npq_file
 # WHERE npp01 = npq01 AND npp01 = '@@@@'
 #  INTO TEMP p301_tmp
 IF p_npptype = '0' THEN #FUN-C50131 add
 SELECT chr30 order1, npp_file.*,npq_file.*,
        chr1000 remark1
   FROM npp_file,npq_file,type_file
  WHERE npp01 = npq01 AND npp01 = '@@@@'
    AND 1=0
   INTO TEMP p301_tmp
 END IF #FUN-C50131--add
 #No.TQC-9B0039  --End  
##
 
 IF SQLCA.SQLCODE THEN
    LET g_success='N'
#   CALL cl_err('create p301_tmp',SQLCA.SQLCODE,0)   #No.FUN-660127
#    CALL cl_err3("sel","npp_file,npq_file","","",SQLCA.SQLCODE,"","create p301_tmp",0)   #No.FUN-660127   #No.FUN-710027 
    CALL s_errmsg('sel npp_file,npq_file','','create p301_tmp',SQLCA.sqlcode,1)                            #No.FUN-710027 
 END IF
 DELETE FROM p301_tmp WHERE 1=1
 
 IF p_npptype = '0' THEN  #FUN-680086
    LET gl_no_b=''
    LET gl_no_e=''
 ELSE
    LET gl_no1_b='' #FUN-680086
    LET gl_no1_e='' #FUN-680086
 END IF
 
END FUNCTION
 
#FUN-680086  --begin
REPORT axcp301_rep2(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order        LIKE npp_file.npp01
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5      #No.FUN-680122 SMALLINT          #傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf    LIKE npq_file.npq07
  DEFINE l_no           LIKE fcx_file.fcx01  
  DEFINE l_remark       LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(150)  
  DEFINE l_p1       LIKE type_file.chr2      #No.FUN-680122 VARCHAR(02)
  DEFINE l_p2       LIKE type_file.num5      #No.FUN-680122 SMALLINT
  DEFINE l_p3       LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
  DEFINE l_p4       LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
  DEFINE li_result  LIKE type_file.num5      #No.FUN-680122 SMALLINT       #No.FUN-560190
  DEFINE l_missingno    LIKE aba_file.aba01  #No.FUN-580111  --add  
  DEFINE l_flag1        LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)              #No.FUN-580111  --add  
  DEFINE l_plant    LIKE azp_file.azp01   #FUN-980009 add
  DEFINE l_legal    LIKE azw_file.azw02   #FUN-980009 add
  DEFINE l_npp08    LIKE npp_file.npp08      #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021
  #FUN-C70093--ADD--STR
  DEFINE l_npp01     LIKE npp_file.npp01
  DEFINE l_cdm02     LIKE cdm_file.cdm02
  DEFINE l_cdm03     LIKE cdm_file.cdm03
  DEFINE l_cdm04     LIKE cdm_file.cdm04
  DEFINE l_cdm05     LIKE cdm_file.cdm05
  DEFINE l_cdm06     LIKE cdm_file.cdm06
  DEFINE l_cdm11     LIKE cdm_file.cdm11
  #FUN-C70093--ADD--end
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                    l_npq.npq01,l_remark
 
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
   #缺號使用                         
   #No.FUN-580111  --begin            
   LET l_flag1='N'                     
   LET l_missingno = NULL               
   LET g_j=g_j+1                         
   SELECT tc_tmp02 INTO l_missingno       
     FROM agl_tmp_file          
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'   
      AND tc_tmp03=p_bookno1 #FUN-680086
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                          
      LET gl_no1=l_missingno                   
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1        
                                AND tc_tmp03 = p_bookno1 #FUN-680086
   END IF                                      
                                                
   #缺號使用完，再在流水號最大的編號上增加       
   IF l_flag1='N' THEN  
    #No.FUN-CB0096 ---start--- Add
     LET t_no = Null
     CALL s_log_check(l_order) RETURNING t_no
     IF NOT cl_null(t_no) THEN
        LET gl_no1 = t_no
        LET li_result = '1'
     ELSE
    #No.FUN-CB0096 ---end  --- Add
   #No.FUN-580111  --end 
#No.FUN-560190--start
    #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",g_dbs_gl,"",g_ccz.ccz121) #FUN-980094 mark
     CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",p_plant,"",g_ccz.ccz121) #FUN-980094
      RETURNING li_result,gl_no1
     END IF   #No.FUN-CB0096   Add
     IF (NOT li_result) THEN
        LET g_success = 'N'
     END IF
#    CALL s_m_aglau(g_dbs_gl,g_ccz.ccz12,gl_no,gl_date,g_yy,g_mm,0)
#         RETURNING g_i,gl_no
#    PRINT "Get max TR-no:",gl_no," Return code(g_i):",g_i
#    IF g_i != 0 THEN LET g_success = 'N' END IF
#No.FUN-560190--end  
     IF g_bgjob = 'N' THEN  #NO.FUN-570153 
         MESSAGE "Insert G/L voucher no:",gl_no1 
         CALL ui.Interface.refresh()
     END IF
     PRINT "Insert aba:",g_ccz.ccz121,' ',gl_no1,' From:',l_order
   END IF  #No.FUN-580111  -add 
  #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",
   LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
             "(aba00,aba01,aba02,aba03,aba04,",
             " aba05,aba06,aba07,aba08,aba09,",
             " aba12,aba19,aba20,abamksg,abapost,",  #MOD-A60136 add aba20
             " abaprno,abaacti,abauser,abagrup,abadate,",
             " abasign,abadays,abaprit,abasmax,abasseq,",
             " abamodu,aba11,abalegal,abaoriu,abaorig,",  #FUN-840211 add aba11  #FUN-980009 add abalegal
             " aba21,aba24)",  #FUN-A10006 add aba21 #MOD-A80136 add aba24
             " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "         ?,?,?,?,?, ?,?,?,?,?, ?,?)" #FUN-840211 add ?  #MOD-A60136 add ?  #FUN-840211 add ? #FUN-980009 add ?  #FUN-A10006 add ? #MOD-A80136 add ?
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   LET l_plant = g_plant_new  #FUN-980009 add
   CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980009 add
   PREPARE p301_1_p41 FROM g_sql
 
   #自動賦予簽核等級
   LET g_aba.aba01=gl_no1
   #No.FUN-560190  --start--
   LET g_aba01t = gl_no1[1,g_doc_len]
   #No.FUN-560190  --end--
   SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
     INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
          g_aba.abaprit,g_aba.abasign
     FROM aac_file WHERE aac01 = g_aba01t
   IF g_aba.abamksg MATCHES  '[Yy]' THEN
      IF g_aac.aacatsg matches'[Yy]' THEN  #自動付予
         CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
              RETURNING g_aba.abasign
      END IF
      SELECT COUNT(*) INTO g_aba.abasmax
        FROM azc_file
       WHERE azc01=g_aba.abasign
   END IF
 
   #將常數轉變數
   LET l_p1='CA'
   LET l_p2='0'
   LET l_p3='N'
   LET l_p4='Y'
   LET g_aba.aba20='0'   #MOD-A60136 add
 
   EXECUTE p301_1_p41 USING
      g_ccz.ccz121, gl_no1,       gl_date,       g_yy,         g_mm,
      g_today,      l_p1,         l_order,       l_p2,         l_p2,
      l_p3,         l_p3,         g_aba.aba20,   g_aba.abamksg,l_p3,     #MOD-A60136 add g_aba.aba20
      l_p2,         l_p4,         g_user,        g_grup,       g_today,
      g_aba.abasign,g_aba.abadays,g_aba.abaprit, g_aba.abasmax,l_p2,
      g_user,       g_aba.aba11,  l_legal,       g_user,       g_grup,   #FUN-840211 add aba11 #FUN-980009 add l_legal
      l_npp.npp08,  g_user                                               #FUN-A10006 add npp08 #MOD-A80136 add g_user
   IF STATUS THEN
      CALL cl_err('ins aba:',STATUS,1)
      LET g_success = 'N'
   END IF
   DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1  #No.FUN-580111
                          AND tmn06 = p_bookno1 #FUN-680086
   IF gl_no1_b IS NULL THEN LET gl_no1_b = gl_no1 END IF
   LET gl_no1_e = gl_no1
   LET l_credit = 0
   LET l_debit  = 0
   LET l_seq = 0
 
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
    ##FUN-C70093--ADD--STR
     #axct326拋轉傳票回寫ccbglno
     CASE WHEN l_npp.npp00=9  
         DECLARE cdm_cs1 CURSOR FOR 
         SELECT cdm02,cdm03,cdm04,cdm05,cdm06,cdm11 FROM cdm_file 
          WHERE cdm10=l_npp.npp01
        FOREACH cdm_cs INTO l_cdm02,l_cdm03,l_cdm04,l_cdm05,l_cdm06,l_cdm11
         UPDATE ccb_file SET ccbglno=gl_no
           WHERE ccb01=l_cdm06
             AND ccb02=l_cdm02
             AND ccb03=l_cdm03
             AND ccb04=l_cdm11
             AND ccb06=l_cdm04
             AND ccb07=l_cdm05
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ccb_file",l_npp.npp00,gl_no,SQLCA.sqlcode,"","upd npp03/glno:",0)   #No.FUN-660127    #wujie 130627
            LET g_success = 'N'
         END IF
        END FOREACH
      END CASE
      #FUN-C70093--ADD--END
 
     UPDATE npp_file SET npp03  = gl_date, 
                         nppglno= gl_no1,
                         npp06  = p_plant, 
                         npp07  = p_bookno1
      WHERE npp01 = l_npp.npp01
        AND npp011= l_npp.npp011
        AND npp00 = l_npp.npp00
        AND nppsys= l_npp.nppsys
        AND npptype= '1' #FUN-680086
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('upd npp03/glno:',SQLCA.sqlcode,1)    #No.FUN-660127
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",0)   #No.FUN-660127   #wujie 130627
        LET g_success = 'N'
     END IF
 
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN  #NO.FUN-570153 
         MESSAGE "Seq:",l_seq 
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                 "(abb00,abb01,abb02,abb03,abb04,abb05,abb06,abb07f,abb07,",
                 " abb08,abb11,abb12,abb13,abb14,",
 
                 #FUN-5C0015 BY GILL --START
                 " abb31,abb32,abb33,abb34,abb35,abb36,abb37,",
                 #FUN-5C0015 BY GILL --END
 
           #      " abb15,abb24,abb25)",                 #No.FUN-810069
                 " abb24,abb25,abblegal)",                        #No.FUN-810069 #FUN-980009 add abblegal
                 " VALUES(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,",
                 
                 #FUN-5C0015 BY GILL--START
                 "?,?,?,?,?,?,?,",
                 #FUN-5C0015 BY GILL--EN
 
           #      " ?,?,?)"                               #No.FUN-810069
                 " ?,?, ?)"                                  #No.FUN-810069 #FUN-980009 add ?
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     LET l_plant = g_plant_new  #FUN-980009 add
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980009 add
     PREPARE p301_1_p51 FROM g_sql
     EXECUTE p301_1_p51 USING 
             g_ccz.ccz121,
             gl_no1,
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
 
             #FUN-5C0015 BY GILL --START
             l_npq.npq31,
             l_npq.npq32,
             l_npq.npq33,
             l_npq.npq34,
             l_npq.npq35,
             l_npq.npq36,
             l_npq.npq37,
             #FUN-5C0015 BY GILL --END
 
      #       l_npq.npq15,                   #No.FUN-810069
             l_npq.npq24,
             l_npq.npq25
             ,l_legal             #FUN-980009 add l_legal
 
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',STATUS,1) 
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1' THEN 
        LET l_debit  = l_debit  + l_amt
     ELSE 
        LET l_credit = l_credit + l_amt
     END IF
 
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
 
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED," aba_file ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  " SET aba08 = ?, ",
                  "     aba09 = ?  ",
                  "    ,aba21 = ? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? ",
                  "   AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p301_1_p61 FROM g_sql
      EXECUTE p301_1_p61 USING l_debit,l_credit,l_npp08,gl_no1,g_ccz.ccz121   #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',g_ccz.ccz121,gl_no1,gl_date,l_p3,'',TRUE)   #No.TQC-B70021

      #-----MOD-810186---------
      IF g_aaz85 = 'Y' THEN 
            #若有立沖帳管理就不做自動確認
            #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'abb_file'),","," aag_file", #FUN-A50102
                        " WHERE abb01 = '",gl_no1,"'",
                        "   AND abb00 = '",g_ccz.ccz121,"'",  
                        "   AND abb03 = aag01  ",
                        "   AND abb00 = aag00  ",        
                        "   AND aag20 = 'Y' "
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE count_pre2 FROM g_sql
            DECLARE count_cs2 CURSOR FOR count_pre2
            OPEN count_cs2 
            FETCH count_cs2 INTO g_cnt
            CLOSE count_cs2
            IF g_cnt = 0 THEN
               IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
               IF g_aba.abamksg='N' THEN   
                  LET g_aba.aba20='1' 
                  LET g_aba.aba19 = 'Y'
                  #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (g_ccz.ccz121,gl_no1) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end 

                  LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                              "    SET abamksg = ? ,",
                                     " abasign = ? ,", 
                                     " aba18   = ? ,",
                                     " aba19   = ? ,",
                                     " aba20   = ? ,",
                                     " aba37   = ?  ",   
                               " WHERE aba01 = ? AND aba00 = ? "
 	              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                  PREPARE upd_aba19_2 FROM g_sql
                  EXECUTE upd_aba19_2 USING g_aba.abamksg,g_aba.abasign,
                                          g_aba.aba18  ,g_aba.aba19,
                                          g_aba.aba20  ,
                                          g_user,    
                                          gl_no1     ,g_ccz.ccz121  
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
                  END IF
               END IF   
            END IF
      END IF     
      #-----END MOD-810186-----
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no1,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no1,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      #No.FUN-560190  --start--
      #LET gl_no[4,12]=''
      LET gl_no1[g_no_sp,g_no_ep]=''
      #No.FUN-560190  --end--
END REPORT
#FUN-680086  --end
#CHI-AC0010
