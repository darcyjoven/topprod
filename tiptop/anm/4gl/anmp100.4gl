# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: anmp100.4gl
# Descriptions...: 外匯/定存傳票拋轉總帳
# Date & Author..: 98/06/24 By Danny
# Modify.........: 99/06/29 By Kammy (add 定存部份)           
# Modify.........: 00/04/20 By Polly Hsu
# Modify.........: No.MOD-470276 04/09/03 By Yuna anmi820的質押傳票編號及日期應該成ref方式
# Modify.........: No.FUN-4B0052 04/11/23 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-510051 05/01/10 By Kitty gl_no_b/gl_no_e的欄位變數未清除, 導致連續執行時, 傳票列印錯誤
# Modify ........: No.FUN-560190 05/06/23 By wujie 單據編號修改,p_gz修改
# Modify ........: No.FUN-570090 05/07/29 By will 增加取得傳票缺號號碼的功能
# Modify.........: No.MOD-5C0083 05/12/15 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-5C0015 060102 BY GILL 多 INSERT 異動碼5~10, 關係人
# Modify.........: No.FUN-570127 2006/03/08 By yiting 批次作業功能修改
# Modify.........: No.MOD-640499 06/04/18 By Smapmin 增加類別24的處理
# Modify.........: No.FUN-650088 06/05/17 By Smapmin 增加是否拋轉傳票的CHECK
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳別權限修改
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670060 06/08/04 By Rayven 只能拋轉DEMO-1的BUG
# Modify.........: No.FUN-680088 06/08/28 By Rayven 新增多帳套功能
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/16 By Jackho 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-740018 07/04/09 By Smapmin 拋轉傳票未帶申請人
# Modify.........: No.FUN-740049 07/04/12 By hongmei 會計科目加帳套
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 需簽核單別不可自動確認
# Modify.........: No.MOD-790147 07/09/28 By Smapmin SELECT 'xxx' 改為30位 
# Modify.........: No.MOD-7B0104 07/11/12 By Smapmin 連續拋轉時,拋轉後自動確認的功能異常
# Modify.........: No.FUN-810069 08/02/27 By yaofs 項目預算取消abb15的管控 
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.MOD-930241 09/03/26 By Sarah 背景執行段應該也要CALL s_m_prtgl()
# Modify.........: No.MOD-960019 09/06/02 By baofei MARK p100_t()段IF gl_seq = '1' AND l_npq.npq00 = 24 THEN條件處理
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.TQC-960295 09/10/10 By baofei aba20新增時，給值的類型不符
# Modify.........: No.FUN-990031 09/10/13 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9B0142 09/11/18 By liuxqa 重新过单TQC-9B0039
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10006 10/01/13 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No:FUN-A10089 10/01/19 By wujie  增加显示选取的缺号结果
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70009 10/07/27 By Summer 調整傳票日期允許空白功能
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24/aba37 預設值 
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:TQC-BA0149 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:MOD-C70104 12/07/09 By Polly 控卡分錄底稿異動日與會計年度期別與總帳期別不一致不能拋傳票
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:MOD-CB0120 13/02/04 By jt_chen 調整累加值變數預設，已正確的補到缺號。
# Modify.........: No:MOD-CC0035 13/02/19 By Polly npp00為8、10、11、12類需回寫nme10、nme16欄位
# Modify.........: No:FUN-D60110 13/08/26 By yangtt CALL s_log_data多笔同时抛转TIME相同会报错

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aba             RECORD LIKE aba_file.*
DEFINE g_aac             RECORD LIKE aac_file.*
DEFINE g_wc,g_sql        string  #No.FUN-580092 HCN
#DEFINE g_dbs_gl 	 VARCHAR(21)
DEFINE g_dbs_gl 	 STRING                 #No.FUN-560190
DEFINE g_plant_gl 	 STRING                 #No.FUN-980059
#DEFINE gl_no		 VARCHAR(16)         	# 傳票單號  #No.FUN-680088 mark
#DEFINE gl_no_b,gl_no_e	 VARCHAR(16)        	# Generated 傳票單號 #No.FUN-680088 mark
DEFINE gl_no             LIKE aba_file.aba01    #No.FUN-680088
DEFINE gl_no_b,gl_no_e   LIKE aba_file.aba01    #No.FUN-680088
DEFINE gl_no1            LIKE aba_file.aba01    #No.FUN-680088
DEFINE gl_no1_b,gl_no1_e LIKE aba_file.aba01    #No.FUN-680088
DEFINE p_plant           LIKE npp_file.npp06    #No.FUN-680107 VARCHAR(12)
DEFINE p_plant_old       LIKE npp_file.npp06    #No.FUN-680107 VARCHAR(12) #No.FUN-570090  --add
DEFINE p_bookno          LIKE aaa_file.aaa01    #No.FUN-670039	
DEFINE p_bookno1         LIKE aaa_file.aaa01    #No.FUN-680088
DEFINE g_t1              LIKE aac_file.aac01    #No.FUN-560190	  #No.FUN-680107 VARCHAR(05)
DEFINE gl_date	         LIKE type_file.dat     #No.FUN-680107 DATE
DEFINE gl_tran	         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE gl_seq    	 LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) # 傳票區分項目
DEFINE g_yy,g_mm	 LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_aba01t          LIKE aba_file.aba01    #No.FUN-680107 VARCHAR(5) #No.FUN-560190
DEFINE p_row,p_col       LIKE type_file.num5    #No.FUN-680107 SMALLINT
#------for ora修改-------------------
#DEFINE g_system         VARCHAR(2)                #No.FUN-670060 mark
DEFINE g_system          LIKE aba_file.aba06    #FUN-670060
DEFINE g_zero            LIKE aba_file.aba08    #No.FUN-680107 decimal(15,3)
DEFINE g_zero1           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_N               LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_y               LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
DEFINE g_aaz85           LIKE aaz_file.aaz85    #傳票是否自動確認 no.3432
DEFINE g_cnt             LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_cnt1            LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i               LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_j               LIKE type_file.num5    #No.FUN-680107 SMALLINT #No.FUN-570090  --add 
DEFINE g_flag            LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_change_lang     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1) #NO.FUN-570127
       ls_date           STRING,
       l_flag            LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0082
    DEFINE l_tmn02       LIKE tmn_file.tmn02    #No.FUN-670068                                                                       
    DEFINE l_tmn06       LIKE tmn_file.tmn06    #No.FUN-670068  
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET p_plant = ARG_VAL(2)
   LET p_bookno= ARG_VAL(3)
   LET gl_no   = ARG_VAL(4)
   LET ls_date = ARG_VAL(5)
   LET gl_date = cl_batch_bg_date_convert(ls_date)
   LET gl_tran = ARG_VAL(6)
   LET gl_seq  = ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)
   LET p_bookno1 = ARG_VAL(9)   #No.FUN-680088
   LET gl_no1    = ARG_VAL(10)  #No.FUN-680088
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
#FUN-570127 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
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
 
#NO.FUN-570127 mark----------
#   #No.FUN-570090  --begin   
#   DROP TABLE agl_tmp_file   
#   CREATE TEMP TABLE agl_tmp_file      
#   (tc_tmp00     VARCHAR(1) NOT NULL,   
#    tc_tmp01     SMALLINT,          
#    tc_tmp02     VARCHAR(20))         
#   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF  
#   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02)   
#   IF STATUS THEN CALL cl_err('create index',STATUS,0) EXIT PROGRAM END IF    
#   #No.FUN-570090  --end  
 
#   OPEN WINDOW p100 AT p_row,p_col WITH FORM "anm/42f/anmp100" 
#    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    CALL cl_opmsg('z')
 
    #02/02/20 bug no:4422 add
#    CALL p100_create_tmp()
    #02/02/20 bug no:4422 add
#    CALL p100()
#    CLOSE WINDOW p100
#NO.FUN-570127 mark---
 
#NO.FUN-570127 start---
#No.FUN-670068--begin                                                                                                               
   DROP TABLE agl_tmp_file   
#No.FUN-680107 --START
#  CREATE TEMP TABLE agl_tmp_file      
#  (tc_tmp00     VARCHAR(1) NOT NULL,   
#   tc_tmp01     SMALLINT,          
#   tc_tmp02     VARCHAR(20),
#   tc_tmp03     VARCHAR(5))   #No.FUN-680088 add tc_tmp03
 
   CREATE TEMP TABLE agl_tmp_file(
       tc_tmp00 LIKE type_file.chr1 NOT NULL,
       tc_tmp01 LIKE type_file.num5,  
       tc_tmp02 LIKE type_file.chr20, 
       tc_tmp03 LIKE oay_file.oayslip)
#No.FUN-680107 --END 
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
       CALL cl_batch_bg_javamail("N")   #NO.FUN-570127
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
       EXIT PROGRAM 
   END IF  
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-680088 add tc_tmp03
   IF STATUS THEN CALL cl_err('create index',STATUS,0) 
       CALL cl_batch_bg_javamail("N")   #NO.FUN-570127
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
       EXIT PROGRAM 
   END IF    
   #No.FUN-570090  --end  
    DECLARE tmn_del CURSOR FOR                                                                                                      
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'                                                               
#No.FUN-670068--end  
    LET g_j = 0   #MOD-CB0120 add
    WHILE TRUE
       LET g_success = 'Y'
       LET g_change_lang = FALSE
       IF g_bgjob = 'N' THEN
          CALL p100_ask()
          IF cl_sure(18,20) THEN
             CALL p100_create_tmp()
             LET g_nmz.nmz02b = p_bookno  # 得帳別
             LET g_nmz.nmz02c = p_bookno1 #No.FUN-680088
             BEGIN WORK
             CALL s_showmsg_init()   #No.FUN-710024
             CALL p100_t('0')  #No.FUN-680088 add '0'
             #No.FUN-680088 --start--
             IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                CALL p100_t('1') 
             END IF
             #No.FUN-680088 --end--
             CALL s_showmsg()          #No.FUN-710024
             IF g_success = 'Y' THEN
                COMMIT WORK
#                CALL s_m_prtgl(g_dbs_gl,g_nmz.nmz02b,gl_no_b,gl_no_e)   #FUN-990069
                CALL s_m_prtgl(g_plant_gl,g_nmz.nmz02b,gl_no_b,gl_no_e)   #FUN-990069
                #No.FUN-680088 --start--
                IF g_aza.aza63 = 'Y' THEN
#                   CALL s_m_prtgl(g_dbs_gl,g_nmz.nmz02c,gl_no1_b,gl_no1_e)#FUN-990069
                   CALL s_m_prtgl(g_plant_gl,g_nmz.nmz02c,gl_no1_b,gl_no1_e)#FUN-990069
                END IF
                #No.FUN-680088 --end--
                CALL cl_end2(1) RETURNING l_flag
             ELSE
                ROLLBACK WORK
                CALL cl_end2(2) RETURNING l_flag
             END IF
             IF l_flag THEN
                CONTINUE WHILE
             ELSE
                CLOSE WINDOW p100
                EXIT WHILE
             END IF
          ELSE
             CONTINUE WHILE
          END IF
       ELSE
          CALL p100_create_tmp()
          LET g_nmz.nmz02b = p_bookno  # 得帳別
          LET g_nmz.nmz02c = p_bookno1    #No.FUN-6800288
          BEGIN WORK
          CALL s_showmsg_init()   #No.FUN-710024
          CALL p100_t('0')  #No.FUN-680088 add '0'
          #No.FUN-680088 --start--
          IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
             CALL p100_t('1')
          END IF
          #No.FUN-680088 --end--
          CALL s_showmsg()          #No.FUN-710024
          IF g_success = 'Y' THEN
             COMMIT WORK
            #str MOD-930241 add
#             CALL s_m_prtgl(g_dbs_gl,g_nmz.nmz02b,gl_no_b,gl_no_e)  #FUN-990069
             CALL s_m_prtgl(g_plant_gl,g_nmz.nmz02b,gl_no_b,gl_no_e)  #FUN-990069
             CALL s_showmsg()
             IF g_aza.aza63 = 'Y' THEN
#                CALL s_m_prtgl(g_dbs_gl,g_nmz.nmz02c,gl_no1_b,gl_no1_e) #FUN-990069
                CALL s_m_prtgl(g_plant_gl,g_nmz.nmz02c,gl_no1_b,gl_no1_e) #FUN-990069
                CALL s_showmsg()
             END IF
            #end MOD-930241 add
          ELSE
             ROLLBACK WORK
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
       END IF
    END WHILE
#FUN-570127 ---end---
    #No.FUN-570090  --start  
#   DELETE FROM tmn_file    
#    WHERE tmn01 = p_plant 
#      AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y') 
#No.FUN-670068--begin                                                                                                               
    FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                            
       DELETE FROM tmn_file                                                                                                         
       WHERE tmn01 = p_plant                                                                                                        
         AND tmn02 = l_tmn02                                                                                                        
         AND tmn06 = l_tmn06                                                                                                        
    END FOREACH  
#FUN-570127 ---end---
#No.FUN-670068--end
    #No.FUN-570090  --end 
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION p100()
 
   WHILE TRUE
     ERROR ''
     LET g_flag = 'Y' 
     CALL p100_ask()	# Ask for first_flag, data range or exist_no
     IF g_flag = 'N' THEN 
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN 
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF cl_sure(10,10) THEN 
        CALL cl_wait()
        LET g_nmz.nmz02b = p_bookno  # 得帳別
#       LET p_row = 19 LET p_col = 20
#       OPEN WINDOW p100_t_w9 AT p_row,p_col WITH 3 ROWS, 70 COLUMNS 
        CALL p100_t('0')  #No.FUN-680088 add '0'
        #No.FUN-680088 --start--
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL p100_t('1')
        END IF
        #No.FUN-680088 --end--
#genero
        IF g_success = 'Y' THEN 
           COMMIT WORK
#           CALL s_m_prtgl(g_dbs_gl,g_nmz.nmz02b,gl_no_b,gl_no_e)  #FUN-990069
           CALL s_m_prtgl(g_plant_gl,g_nmz.nmz02b,gl_no_b,gl_no_e)  #FUN-990069
           #No.FUN-680088 --start--
           IF g_aza.aza63 = 'Y' THEN
#              CALL s_m_prtgl(g_dbs_gl,g_nmz.nmz02c,gl_no1_b,gl_no1_e) #FUN-990069
              CALL s_m_prtgl(g_plant_gl,g_nmz.nmz02c,gl_no1_b,gl_no1_e) #FUN-990069
           END IF
           #No.FUN-680088 --end--
           CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
        END IF 
        CLOSE WINDOW p100_t_w9
        IF g_flag THEN
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
     END IF 
   END WHILE 
#genero
 
END FUNCTION
 
FUNCTION p100_ask()
   DEFINE   l_aaa07        LIKE aaa_file.aaa07
   DEFINE   li_result      LIKE type_file.num5    #No.FUN-560190 #No.FUN-680107 SMALLINT
   DEFINE   l_cnt          LIKE type_file.num5    #No.FUN-570090 -add #No.FUN-680107 SMALLINT
   DEFINE   lc_cmd         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500)       #FUN-570127
   DEFINE   li_chk_bookno  LIKE type_file.num5    #No.FUN-680107 SMALLINT #No.FUN-670006
   DEFINE   li_chk_bookno1 LIKE type_file.num5    #No.FUN-680107 SMALLINT #No.FUN-680088
   DEFINE   l_sql          STRING                 #No.FUN-670006 -add
   DEFINE   l_tmn02        LIKE tmn_file.tmn02    #No.FUN-670068                                                                       
   DEFINE   l_tmn06        LIKE tmn_file.tmn06    #No.FUN-670068  
   DEFINE   l_no           LIKE type_file.chr3    #No.FUN-840125
   DEFINE   l_no1          LIKE type_file.chr3    #No.FUN-840125
   DEFINE   l_aac03        LIKE aac_file.aac03    #No.FUN-840125
   DEFINE   l_aac03_1      LIKE aac_file.aac03    #No.FUN-840125
#No.FUN-A10089 --begin
   DEFINE   l_chr1         LIKE type_file.chr20
   DEFINE   l_chr2         STRING
#No.FUN-A10089 --end

#FUN-570127 --start--
   #No.FUN-570090  --begin   
#No.FUN-670068--begin                                                                                                               
#  DROP TABLE agl_tmp_file   
#  CREATE TEMP TABLE agl_tmp_file      
#  (tc_tmp00     VARCHAR(1) NOT NULL,   
#   tc_tmp01     SMALLINT,          
#   tc_tmp02     VARCHAR(20),
#   tc_tmp03     VARCHAR(5))   #No.FUN-680088 add tc_tmp03
#  IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
#      CALL cl_batch_bg_javamail("N")   #NO.FUN-570127
#      EXIT PROGRAM 
#  END IF  
#  CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-680088 add tc_tmp03
#  IF STATUS THEN CALL cl_err('create index',STATUS,0) 
#      CALL cl_batch_bg_javamail("N")   #NO.FUN-570127
#      EXIT PROGRAM 
#  END IF    
#  #No.FUN-570090  --end  
#   DECLARE tmn_del CURSOR FOR                                                                                                      
#      SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'                                                               
#No.FUN-670068--end  
 
   OPEN WINDOW p100 AT p_row,p_col WITH FORM "anm/42f/anmp100"
        ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL cl_opmsg('z')
 
    #No.FUN-680088 --start--
    IF g_aza.aza63 = 'N' THEN 
       CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)
    END IF
    #No.FUN-680088 --end--
 
    WHILE TRUE
#FUN-570127 ---end---
#No.FUN-A10089 --begin
   LET l_chr2 =' '  
   DISPLAY ' ' TO chr2   
#No.FUN-A10089 --end 
     CONSTRUCT BY NAME g_wc ON npp00,npp01,npp011,npp02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION locale                    #genero
#         LET g_action_choice = "locale"
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE         #FUN-570127
         EXIT CONSTRUCT
   
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   
#NO.FUN-570127 start---
 
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        LET g_flag = 'N'
#        RETURN
#     END IF
 
#     IF INT_FLAG THEN
#        RETURN
#    END IF
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p100
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
       END IF
#FUN-570127 ---end---
 
     LET p_plant = g_nmz.nmz02p 
     LET p_plant_old = p_plant      #No.FUN-570090  --add  
     LET p_bookno   = g_nmz.nmz02b 
     #No.FUN-680088 --start--                                                                                                         
     LET p_bookno1  = g_nmz.nmz02c
     LET gl_no1_b = ''
     LET gl_no1_e = ''
     #No.FUN-680088 --end--
     LET gl_date = g_today
     LET gl_tran = 'Y'
     LET gl_seq  = '0'
     LET g_bgjob = 'N'   #NO.FUN-570127
     #INPUT BY NAME p_plant,p_bookno,gl_no,gl_date,gl_tran,gl_seq 
     INPUT BY NAME p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,gl_tran,gl_seq,g_bgjob #NO.FUN-570127 #No.FUN-680088 add p_bookno1,gl_no1
         WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)  #No.FUN-570090  --add UNBUFFERED
   
         AFTER FIELD p_plant
            #FUN-990031--mod--str--    營運中心要控制在當前法人下
            #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
            #IF STATUS <> 0 THEN
            #   NEXT FIELD p_plant
            #END IF
            SELECT * FROM azw_file WHERE azw01 = p_plant AND azw02 = g_legal                                                           
            IF STATUS THEN                                                                                                             
               CALL cl_err3("sel","azw_file",p_plant,"","agl-171","","",1)                                                             
               NEXT FIELD p_plant                                                                                                      
            END IF                                                                                                                     
            #FUN-990031--mod--end 
 
           # 得出總帳 database name 
           # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
            #No.FUN-570090  --begin       
            IF p_plant_old != p_plant THEN 
#No.FUN-670068--begin                                                                                                               
               FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                            
                  DELETE FROM tmn_file                                                                                                         
                  WHERE tmn01 = p_plant_old                                                                                                        
                    AND tmn02 = l_tmn02                                                                                                        
                    AND tmn06 = l_tmn06                                                                                                        
               END FOREACH  
#              DELETE FROM tmn_file       
#               WHERE tmn01 = p_plant_old 
#                 AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00='Y')  
#No.FUN-670068--begin                                                                                                               
               DELETE FROM agl_tmp_file       
               LET p_plant_old = g_plant_new     
            END IF     
            #No.FUN-570090  --end
   
         AFTER FIELD p_bookno
            IF p_bookno IS NULL THEN 
               NEXT FIELD p_bookno 
            END IF
            #No.FUN-670006--begin 
            IF NOT cl_null(p_bookno) THEN
              CALL s_check_bookno(p_bookno,g_user,p_plant)
                 RETURNING li_chk_bookno
              IF (NOT li_chk_bookno) THEN
                 NEXT FIELD p_bookno
              END IF
              #No.FUN-680088 --start--
              IF p_bookno1 = p_bookno THEN
                 CALL cl_err('','aap-987',1)
                 NEXT FIELD p_bookno
              END IF
              #No.FUN-680088 --end--
              LET g_plant_new= p_plant  #工廠編號
                 #CALL s_getdbs()       #FUN-A50102
                 LET l_sql = "SELECT *",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                             " WHERE aaa01 = '",p_bookno,"' ",
                             "   AND aaaacti IN ('Y','y') "
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE p100_pre2 FROM l_sql
                 DECLARE p100_cur2 CURSOR FOR p100_pre2
                 OPEN p100_cur2
                 FETCH p100_cur2
#             SELECT * FROM aaa_file WHERE aaa01 = p_bookno AND aaaacti='Y'
              IF STATUS THEN
                 CALL cl_err(p_bookno,'aap-229',0) NEXT FIELD p_bookno
              END IF
            END IF
            #No.FUN-670006--end 
   
         AFTER FIELD gl_no
      #No.FUN-560190 --start--        
#            LET g_t1 = gl_no[1,g_doc_len]     #MOD-5C0083
#No.FUN-560190 --start--
#            CALL s_check_no("agl",gl_no,"","1","","",g_dbs_gl)    #MOD-5C0083                                                            
           #CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",g_dbs_gl)   #MOD-5C0083 #FUN-980094
            CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",p_plant)   #MOD-5C0083 #FUN-980094
            RETURNING li_result,gl_no                                                                                         
#            LET gl_no = s_get_doc_no(gl_no)     #MOD-5C0083                                                                         
#            DISPLAY BY NAME gl_no          #MOD-5C0083                                                                                    
            IF (NOT li_result) THEN                                                                                                 
#               LET gl_no=gl_no    #MOD-5C0083
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
#           LET g_t1=gl_no[1,3]               #--NO:6842
#           CALL s_aglslip(g_t1,'*','AGL')    # 單別,單據性質(全部)NO:6842
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD gl_no
#           END IF                            #--NO:6842
#          #No.B112 010505 by plum
#           LET g_errno=' '
#           CALL s_chkno(gl_no) 
#           RETURNING g_errno
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(gl_no,g_errno,0)
#              NEXT FIELD gl_no
#           END IF
#          #No.B112 ..end
#           CALL s_m_aglsl(g_dbs_gl,gl_no,'1')
#           IF NOT cl_null(g_errno) THEN 
#              CALL cl_err(gl_no,g_errno,0)
#              NEXT FIELD gl_no
#           END IF
    #No.FUN-560190 ---end--- 
  
         #No.FUN-680088 --start--
         AFTER FIELD p_bookno1
            IF p_bookno1 IS NULL THEN 
               NEXT FIELD p_bookno1
            END IF
            IF NOT cl_null(p_bookno1) THEN
               CALL s_check_bookno(p_bookno1,g_user,p_plant)
                  RETURNING li_chk_bookno1
               IF (NOT li_chk_bookno1) THEN
                  NEXT FIELD p_bookno1
               END IF
               IF p_bookno1 = p_bookno THEN
                  CALL cl_err('','aap-987',1)
                  NEXT FIELD p_bookno1
               END IF
               LET g_plant_new= p_plant  #工廠編號
               #CALL s_getdbs()         #FUN-A50102
               LET l_sql = "SELECT *",
                           #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                           "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                           " WHERE aaa01 = '",p_bookno1,"' ",
                           "   AND aaaacti IN ('Y','y') "
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE p100_pre1 FROM l_sql
               DECLARE p100_cur1 CURSOR FOR p100_pre1
               OPEN p100_cur1
               FETCH p100_cur1
               IF STATUS THEN
                  CALL cl_err(p_bookno1,'aap-229',0) NEXT FIELD p_bookno1
               END IF
            END IF
 
         AFTER FIELD gl_no1
           #CALL s_check_no("agl",gl_no1,"","1","aac_file","aac01",g_dbs_gl) #FUN-980094
            CALL s_check_no("agl",gl_no1,"","1","aac_file","aac01",p_plant)  #FUN-980094
                  RETURNING li_result,gl_no1
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
         #No.FUN-680088 --end--
 
         AFTER FIELD gl_date
            #CHI-A70009 mark --start--
            #IF gl_date IS NULL THEN
            #   NEXT FIELD gl_date
            #END IF
            #CHI-A70009 mark --end--
            IF NOT cl_null(gl_date) THEN #CHI-A70009 add
             #-------- NO:0723 modi in 99/10/18 --------------
               SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
               IF gl_date <= l_aaa07 THEN    
                  CALL cl_err('','axm-164',0) 
                  NEXT FIELD gl_date
               END IF
            #------------------------------------------------
               SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
               IF STATUS THEN
#                 CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
                  NEXT FIELD gl_date
               END IF
            #CHI-A70009 add --start--
            ELSE
               CALL chk_date()
               IF g_success = 'N' THEN
                  LET g_flag = 'N'
                  NEXT FIELD gl_date
               ELSE
                  LET g_flag = 'Y'
               END IF
            END IF
            #CHI-A70009 add --end--
   
         AFTER FIELD gl_seq  
            IF cl_null(gl_seq) OR gl_seq NOT MATCHES '[012]' THEN
               NEXT FIELD gl_seq 
            END IF
   
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
#            IF gl_no[1,3] IS NULL or gl_no[1,3] = ' ' THEN
            IF gl_no[1,g_doc_len] IS NULL or gl_no[1,g_doc_len] = ' ' THEN
               NEXT FIELD gl_no
            END IF
            #modi by canny(980811)
         IF NOT cl_null(gl_date) THEN #CHI-A70009 add
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
#              CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0) #No.FUN-660148
               NEXT FIELD gl_date
            END IF
         END IF #CHI-A70009 add
#No.FUN-560190--begin
           #CHI-A70009 add --start--
            IF cl_null(gl_date) THEN
               LET g_flag='Y'
            END IF
           #CHI-A70009 add --end--
           # 得出總帳 database name                                                                                                 
           # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl                                                    
            LET g_plant_new= p_plant  # 工廠編號                                                                                    
            CALL s_getdbs()                                                                                                         
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱  
#No.FUN-560190--end   
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
   
         ON ACTION CONTROLG 
            CALL cl_cmdask()
   
         ON ACTION CONTROLP
               IF INFIELD(gl_no) THEN
#No.FUN-560190--begin
                 CALL s_getdbs()                                                                                                         
                 LET g_dbs_gl=g_dbs_new 
                 LET g_plant_gl = p_plant   #No.FUN-980059
#No.FUN-560190--end   
                  #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1',' ',' ','AGL') #No.FUN-840125
              #   CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125    #No.FUN-980059
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                  RETURNING gl_no
#                  CALL FGL_DIALOG_SETBUFFER( gl_no )
                  IF g_bgjob = 'N' THEN  #NO.FUN-570127
                      DISPLAY BY NAME gl_no
                  END IF
                  NEXT FIELD gl_no
            END IF
               #No.FUN-680088 --start--
               IF INFIELD(gl_no1) THEN
                  CALL s_getdbs()                                                                                                         
                  LET g_dbs_gl=g_dbs_new 
                  #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1',' ',' ','AGL') #No.FUN-840125
              #   CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1','0',' ','AGL')  #No.FUN-840125    #No.FUN-980059
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                  RETURNING gl_no1
                  IF g_bgjob = 'N' THEN 
                      DISPLAY BY NAME gl_no1
                  END IF
                  NEXT FIELD gl_no1
               END IF
               #No.FUN-680088 --end--
   
         #No.FUN-570090  --begin        
         ON ACTION get_missing_voucher_no  
         IF cl_null(gl_no) AND cl_null(gl_no1) THEN  #No.FUN-670068 add AND cl_null(gl_no1)
            NEXT FIELD gl_no
         END IF                         
        #CHI-A70009 add --start--
         IF cl_null(gl_date) THEN
            NEXT FIELD gl_date
         END IF
        #CHI-A70009 add --end--
                                       
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
                                                                 
#        CALL s_agl_missingno(p_plant,g_dbs_gl,g_nmz.nmz02b,gl_no,gl_date,0)  #No.FUN-670068 mark 
         CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0)  #No.FUN-670068
                                     
         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file       
          WHERE tc_tmp00='Y'                              
         IF l_cnt > 0 THEN                               
            CALL cl_err(l_cnt,'aap-501',0)         
#No.FUN-A10089 --begin
            LET l_sql = " SELECT tc_tmp02 FROM agl_tmp_file ",
                        "  WHERE tc_tmp00 ='Y'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
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
            DISPLAY l_chr2 TO chr2
#No.FUN-A10089 --end     
         ELSE                                          
            CALL cl_err('','aap-502',0)               
         END IF                                      
         #No.FUN-570090  --end 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#FUN-570127 --start--
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT INPUT
#FUN-570127 ---end---
 
      END INPUT
#NO.FUN-570125 start---
#      IF INT_FLAG THEN 
#         RETURN
#      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p100
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = 'anmp100'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('anmp100','9031',1)   
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",p_plant CLIPPED,"'",
                         " '",p_bookno CLIPPED,"'",
                         " '",gl_no CLIPPED,"'",
                         " '",gl_date CLIPPED,"'",
                         " '",gl_tran CLIPPED,"'",
                         " '",gl_seq CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",  
                         " '",p_bookno1 CLIPPED,"'", #No.FUN-680088 
                         " '",gl_no1 CLIPPED,"'"     #No.FUN-680088 
             CALL cl_cmdat('anmp100',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p100
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p100_t(l_npptype)  #No.FUN-680088 add l_npptype
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_cmd  	LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
   DEFINE l_order	LIKE npp_file.npp01    #No.FUN-680088
#  DEFINE l_order	LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30) #No.FUN-680088 mark
   DEFINE l_remark	LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(150) #No.7319
   DEFINE l_name	LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
   DEFINE ap_date	LIKE type_file.dat     #No.FUN-680107 DATE
   DEFINE ap_glno	LIKE gxg_file.gxg07    #No.FUN-680107 VARCHAR(12)
   DEFINE ap_conf	LIKE gxg_file.gxgconf  #No.FUN-680107 VARCHAR(1)
   DEFINE max_gxg02     LIKE gxg_file.gxg02
   DEFINE l_msg         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(80)
   DEFINE l_str         STRING,                #MOD-640499
          l_len         LIKE type_file.num5,   #No.FUN-680107 SMALLINT #MOD-640499
          l_gxh011      LIKE gxh_file.gxh011,  #MOD-640499
          l_gxh02       LIKE gxh_file.gxh02,   #MOD-640499
          l_gxh03       LIKE gxh_file.gxh03    #MOD-640499
   DEFINE l_npptype     LIKE npp_file.npptype  #No.FUN-680088
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   DEFINE l_npp01       LIKE npp_file.npp01    #TQC-BA0149
   DEFINE l_yy,l_mm     LIKE type_file.num5    #MOD-C70104 add
   DEFINE l_aaa07       LIKE aaa_file.aaa07    #MOD-C70104 add
   DEFINE l_npp02b      LIKE npp_file.npp02    #MOD-C70104 add
   DEFINE l_npp02e      LIKE npp_file.npp02    #MOD-C70104 add
   DEFINE l_correct     LIKE type_file.chr1    #MOD-C70104 add
 
   DEFINE l_yy1         LIKE type_file.num5    #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5    #CHI-CB0004
   DELETE FROM p100_tmp;
    #No.MOD-510051
  
   IF l_npptype = '0' THEN  #No.FUN-680088
      LET gl_no_b=''
      LET gl_no_e=''
   #No.FUN-680088 --start--
   ELSE
      LET gl_no1_b=''
      LET gl_no1_e=''
   END IF
 
  #IF NOT cl_null(gl_date) THEN   #CHI-A70009 add #MOD-C70104 mark
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",
         LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"'",
                     "    AND aznn00 = '",p_bookno,"'"
      ELSE
         #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",
         LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"'",
                     "    AND aznn00 = '",p_bookno1,"'"
      END IF
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p100_p1 FROM g_sql
      DECLARE p100_c1 CURSOR FOR p100_p1
      OPEN p100_c1
      FETCH p100_c1 INTO g_yy,g_mm
   ELSE 
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = gl_date
   END IF
   #No.FUN-680088 --end--
  #END IF   #CHI-A70009 add                                          #MOD-C70104 mark
  #----------------------------------MOD-C70104------------------------------------(S)
  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   IF NOT cl_null(gl_date) THEN
     #判斷是否小于關帳日期
      IF l_npptype = '0' THEN
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno
      ELSE
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno1
      END IF
      IF gl_date <= l_aaa07 THEN
         IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','','axr-164',1)
         ELSE
            CALL cl_err('','axr-164',0)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
     #當月起始日與截止日
      CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_npp02b,l_npp02e

      LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                "  FROM npp_file,nmy_file",
                " WHERE nppsys= 'NM' AND nppglno IS NULL",
                "   AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                "   AND npptype = '",l_npptype,"'",
                "   AND ",g_wc CLIPPED,
                "   AND npp01 like ltrim(rtrim(nmyslip)) || '-%' AND nmydmy3='Y'"
      PREPARE p100_0_p0 FROM g_sql
      IF STATUS THEN
         CALL cl_err('p400_0_p0',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE p100_0_c0 CURSOR WITH HOLD FOR p100_0_p0
      LET l_flag='N'
      FOREACH p100_0_c0 INTO l_yy,l_mm
         LET l_flag='Y'
         EXIT FOREACH
      END FOREACH
      IF l_flag ='Y' THEN
         CALL cl_err('err:','axr-061',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
  #----------------------------------MOD-C70104------------------------------------(E)
   
   #No.FUN-840211---Begin
   IF g_aaz.aaz81 = 'Y' THEN
      LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
      LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
      IF g_aza.aza63 = 'Y' THEN 
         IF l_npptype = '0' THEN
            #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
            LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                        " WHERE aba00 =  '",p_bookno,"'"
                       ,"   AND aba19 <> 'X' "  #CHI-C80041
                       ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
         ELSE
        	  #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
              LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                        " WHERE aba00 =  '",p_bookno1,"'"
                       ,"   AND aba19 <> 'X' "  #CHI-C80041
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
 
   #no.3432 (是否自動傳票確認)
   #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
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
   #no.3432(end)
 
   LET g_success = 'Y'
   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             " FROM npp_file,npq_file,nmy_file ",   #FUN-650088
             #" FROM npp_file,npq_file ",   #FUN-650088
             " WHERE nppsys= 'NM' AND nppglno IS NULL",
             " AND npp01 = npq01 AND npp011=npq011",
             " AND npp00 = npq00 AND nppsys = npqsys ",
            " AND (npp00 = 4 OR npp00 = 5 OR npp00= 8 OR npp00=9",
            #" OR npp00 =10 OR npp00 =11 OR npp00=12)",    #MOD-640499
            " OR npp00 =10 OR npp00 =11 OR npp00=12 OR npp00=24)",    #MOD-640499
             "   AND npptype = '",l_npptype,"'",  #No.FUN-680088
             "   AND npptype = npqtype ",         #No.FUN-680088
             " AND ",g_wc CLIPPED,
             "   AND npp01 like ltrim(rtrim(nmyslip)) || '-%' AND nmydmy3='Y'"  #FUN-650088
   PREPARE p100_1_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('prepare 100g_1_p0',STATUS,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p100_1_c0 CURSOR WITH HOLD FOR p100_1_p0
   IF STATUS THEN CALL cl_err('declare 100g_1_c0',STATUS,1) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   CALL cl_outnam('anmp100') RETURNING l_name
   IF l_npptype = '0' THEN  #No.FUN-68002
      START REPORT anmp100_rep TO l_name
   #No.FUN-680088 --start--
   ELSE
      START REPORT anmp100_1_rep TO l_name
   END IF
   #No.FUN-680088 --end--
 
#   BEGIN WORK               #No.FUN-710024 mark
 
   LET g_cnt1 = 0
   WHILE TRUE
      FOREACH p100_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err('foreach:',STATUS,1) 
            CALL s_errmsg('','','foreach:',STATUS,1) 
#No.FUN-710024--end
            LET g_success = 'N'
            EXIT FOREACH
         END IF
#No.FUN-710024--begin
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF          
#No.FUN-710024--end
         IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
         CASE 
           WHEN l_npp.npp00 = 4                         #定存質押
                SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
                 WHERE gxg011=l_npp.npp01  AND gxg09 IS NULL
                SELECT gxg08,gxg07,gxgconf INTO ap_date,ap_glno,ap_conf
                  FROM gxg_file
                 WHERE gxg011=l_npp.npp01 AND gxg02=l_npp.npp011
                   AND gxg09 IS NULL
                IF STATUS THEN
#                  CALL cl_err('sel gxg:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxg_file",l_npp.npp01,l_npp.npp011,STATUS,"","sel gxg:",0) #No.FUN-660148
                   LET g_showmsg=l_npp.npp01,"/",l_npp.npp011
                   CALL s_errmsg('gxg011.gxg02',g_showmsg,'sel gxg:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           WHEN l_npp.npp00 = 5                         #解除質押
                SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
                 WHERE gxg011=l_npp.npp01  AND gxg09 IS NOT NULL
                SELECT gxg11,gxg10,gxgconf INTO ap_date,ap_glno,ap_conf
                  FROM gxg_file
                 WHERE gxg011=l_npp.npp01 AND gxg02=l_npp.npp011
                   AND gxg09 IS NOT NULL
                IF STATUS THEN
#                  CALL cl_err('sel gxg:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxg_file",l_npp.npp01,l_npp.npp011,STATUS,"","sel gxg:",0) #No.FUN-660148
                   LET g_showmsg=l_npp.npp01,"/",l_npp.npp011
                   CALL s_errmsg('gxg011.gxg02',g_showmsg,'sel gxg:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           WHEN l_npp.npp00 = 8                         #外匯交割
                SELECT gxe04,gxe14,gxe13 INTO ap_date,ap_glno,ap_conf
                  FROM gxe_file WHERE gxe01=l_npp.npp01
                                  AND gxe011=l_npp.npp011
                IF STATUS THEN
#                  CALL cl_err('sel gxe:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxe_file",l_npp.npp01,l_npp.npp011,STATUS,"","sel gxe:",0) #No.FUN-660148
                   LET g_showmsg=l_npp.npp01,"/",l_npp.npp011
                   CALL s_errmsg('gxe01.gxe011',g_showmsg,'sel gxe:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           WHEN l_npp.npp00 = 9                         #外匯交易
                SELECT gxc03,gxc14,gxc13 INTO ap_date,ap_glno,ap_conf
                  FROM gxc_file WHERE gxc01=l_npp.npp01
                IF STATUS THEN
#                  CALL cl_err('sel gxc:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxc_file",l_npp.npp01,"",STATUS,"","sel gxc:",0) #No.FUN-660148
                   CALL s_errmsg('gxc01',l_npp.npp01,'sel gxc:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           #### polly.s
           WHEN l_npp.npp00 = 10  #收息
                SELECT gxi02,gxiglno,gxiconf INTO ap_date,ap_glno,ap_conf
                  FROM gxi_file WHERE gxi01=l_npp.npp01
                IF STATUS THEN
#                  CALL cl_err('sel gxi:',STATUS,0)   #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxi_file",l_npp.npp01,"",STATUS,"","sel gxi:",0) #No.FUN-660148
                   CALL s_errmsg('gxi01',l_npp.npp01,'sel gxi:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N' 
                END IF
           WHEN l_npp.npp00 = 11  #定存到期
                SELECT gxk02,gxkglno,gxkconf INTO ap_date,ap_glno,ap_conf
                  FROM gxk_file WHERE gxk01=l_npp.npp01
                IF STATUS THEN
#                  CALL cl_err('sel gxk:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxk_file",l_npp.npp01,"",STATUS,"","sel gxk:",0) #No.FUN-660148
                   CALL s_errmsg('gxk01',l_npp.npp01,'sel gxk:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           WHEN l_npp.npp00 = 12  #存入定存單
                SELECT gxf03,gxf13,gxfconf INTO ap_date,ap_glno,ap_conf
                  FROM gxf_file WHERE gxf011=l_npp.npp01
                IF STATUS THEN
#                  CALL cl_err('sel gxf:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxf_file",l_npp.npp01,"",STATUS,"","sel gxf:",0) #No.FUN-660148
                   CALL s_errmsg('gxf011',l_npp.npp01,'sel gxf:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           #### polly.end
           #-----MOD-640499---------
           WHEN l_npp.npp00 = 24
                LET l_str = l_npq.npq01
                LET l_len = l_str.getLength()
                LET l_gxh011 = l_str.subString(1,l_len-6)
                LET l_gxh02  = l_str.subString(l_len-5,l_len-2)
                LET l_gxh03  = l_str.subString(l_len-1,l_len)
                LET ap_date = l_npp.npp02
                SELECT gxhglno,gxh15 INTO ap_glno,ap_conf
                  FROM gxh_file WHERE gxh011 = l_gxh011 AND
                                      gxh02  = l_gxh02  AND
                                      gxh03  = l_gxh03
                IF STATUS THEN
#                  CALL cl_err('sel gxh:',STATUS,0)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("sel","gxh_file",l_gxh02,l_gxh011,STATUS,"","sel gxh:",0) #No.FUN-660148
                   LET g_showmsg=l_gxh011,"/",l_gxh02,"/",l_gxh03
                   CALL s_errmsg('gxh011,gxh02,gxh03',g_showmsg,'sel gxh:',STATUS,1)   
#No.FUN-710024--end
                   LET g_success='N'
                END IF
           #-----END MOD-640499-----
 
           OTHERWISE CONTINUE FOREACH
         END CASE
         IF l_npp.npp00=4 OR l_npp.npp00=5 THEN
            IF max_gxg02 != l_npp.npp011 THEN CONTINUE FOREACH END IF
         END IF
         IF ap_conf='N' THEN CONTINUE FOREACH END IF
         IF ap_conf='X' THEN CONTINUE FOREACH END IF   #010815增
         IF l_npptype = '0' THEN  #No.FUN-680088
            IF ap_glno IS NOT NULL THEN CONTINUE FOREACH END IF
         END IF   #No.FUN-680088
         IF l_npp.npp011=1 AND ap_date<>l_npp.npp02 THEN
            #no.7247
            LET l_msg= "Date differ:",ap_date,'-',l_npp.npp02,
                       "  * Press any key to continue ..."
            CALL cl_msgany(19,4,l_msg)
            LET INT_FLAG = 0  ######add for prompt bug
           #PROMPT "date differ:",ap_date,'-',l_npp.npp02 FOR CHAR g_chr
            #no.7247(end)
         END IF
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
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_npp.npp01 # 依單號
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 # 依日期
              OTHERWISE         LET l_order = ' '
         END CASE
         #02/02/20 bug no.4422 add
         #資料丟入temp file 排序
#MOD-960019---begin 
#         #-----MOD-640499---------
#         IF gl_seq = '1' AND l_npq.npq00 = 24 THEN
#            LET l_order = l_npp.npp01[1,g_no_ep]
#         END IF
#         #-----END MOD-640499-----
#MOD-960019---end
         INSERT INTO p100_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         LET g_cnt1 = g_cnt1 + 1
         IF STATUS THEN
#           CALL cl_err('ins tmp:',STATUS,1)    #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","p100_tmp","","",STATUS,"","ins tmp:",1) #No.FUN-660148
            LET g_success='N' 
#            EXIT FOREACH
            CALL s_errmsg('','','ins tmp:',STATUS,1)
            CONTINUE FOREACH
#No.FUN-710024--end
         END IF
         #02/02/20 bug no.4422 add
      END FOREACH
#No.FUN-710024--begin
      IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
      END IF 
#No.FUN-710024--end  
      LET l_npp01 = NULL   #No.TQC-BA0149 
      #-02/02/20 bug no.4422 add--
      DECLARE p100_tmpcs CURSOR FOR
         SELECT * FROM p100_tmp
          ORDER BY npq00,order1,npp01,npq06,npq03,npq05,  #No.TQC-BA0149 add npp01
                   npq24,npq25,remark,npq01
      FOREACH p100_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
         IF STATUS THEN
#            CALL cl_err('foreach tmp:',STATUS,1)           #No.FUN-710024
            CALL s_errmsg('','','foreach tmp:',STATUS,1)    #No.FUN-710024
            LET g_success='N'
            EXIT FOREACH
         END IF
         #No.TQC-BA0149  --Begin
         IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
            LET l_npp.npp08 = 0
         END IF
         LET l_npp01 = l_npp.npp01
         #No.TQC-BA0149  --End
         IF l_npp.npptype = '0' THEN  #No.FUN-680088
            OUTPUT TO REPORT anmp100_rep(l_order,l_npp.*,l_npq.*,l_remark)
         #No.FUN-680088 --start--
         ELSE
            OUTPUT TO REPORT anmp100_1_rep(l_order,l_npp.*,l_npq.*,l_remark)
         END IF
         #No.FUN-680088 --end--
      END FOREACH
      #--02/02/20 bug no.4422 add--
 
      EXIT WHILE
   END WHILE
 
   IF l_npptype = '0' THEN  #No.FUN-680088
      FINISH REPORT anmp100_rep
   #No.FUN-680088 --start--
   ELSE
      FINISH REPORT anmp100_1_rep
   END IF
   #No.FUN-680088 --end--
  #No.+366 010705 plum
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009 
#  RUN l_cmd                                          #No.FUN-9C0009 	
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
  #No.+366..end
   IF g_cnt1 = 0  THEN 
#      CALL cl_err('','aap-129',1)           #No.FUN-710024
      CALL s_errmsg('','','','aap-129',1)    #No.FUN-710024
      LET g_success = 'N'
   END IF 
 
END FUNCTION
 
REPORT anmp100_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01  #No.FUN-680107 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5    #No.FUN-680107 SMALLINT # 傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6 #No.FUN-680107 DECIMAL(20,6) #No.FUN-4C0010
  DEFINE l_remark       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(150) #No.7319
  DEFINE l_gxl03        LIKE gxl_file.gxl03    #no:7356
  DEFINE li_result      LIKE type_file.num5    #No.FUN-560190  #No.FUN-680107 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01    #No.FUN-570090  --add    
  DEFINE l_flag1        LIKE type_file.chr1    #No.FUN-570090  --add   #No.FUN-680107 VARCHAR(1)
  DEFINE l_str          STRING,                #MOD-640499
         l_len          LIKE type_file.num5,   #No.FUN-680107 SMALLINT #MOD-640499
         l_gxh011       LIKE gxh_file.gxh011,  #MOD-640499
         l_gxh02        LIKE gxh_file.gxh02,   #MOD-640499
         l_gxh03        LIKE gxh_file.gxh03    #MOD-640499
  DEFINE l_legal        LIKE npq_file.npqlegal #FUN-980005 
  DEFINE l_npp08        LIKE npp_file.npp08    #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021 
  
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_npq.npq00,l_order,l_npq.npq06,   #NO:7498
           l_npq.npq03,l_npq.npq05,l_npq.npq24,l_npq.npq25,
           l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
 
#No.FUN-670060--begin                                                                                                               
   # 得出總帳 database name                                                                                                         
   # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl                                                            
    LET g_plant_new= p_plant  # 工廠編號                                                                                            
    CALL s_getdbs()                                                                                                                 
    LET g_dbs_gl=g_dbs_new CLIPPED                                                                                                  
#No.FUN-670060--end  

   #CHI-A70009 add --start--
   IF g_flag = 'Y' THEN
      LET gl_date = l_npp.npp02
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=gl_date
   END IF
   #CHI-A70009 add --end--
 
   #缺號使用            
   #No.FUN-570090  --begin 
   LET l_flag1='N'        
   LET l_missingno = NULL 
   LET g_j=g_j+1         
   SELECT tc_tmp02 INTO l_missingno        
     FROM agl_tmp_file                     
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'
      AND tc_tmp03 = p_bookno  #No.FUN-680088
   IF NOT cl_null(l_missingno) THEN     
      LET l_flag1='Y'                  
      LET gl_no=l_missingno           
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no      
                                AND tc_tmp03 = p_bookno  #No.FUN-680088
   END IF                                                
                                        
   #缺號使用完，再在流水號最大的編號上增加      
   IF l_flag1='N' THEN                         
   #No.FUN-570090  --end
#No.FUN-560190 --start--
    #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",g_dbs_gl,"",p_bookno) #No.FUN-680088 g_nmz.nmz02b -> p_bookno #FUN-980094
    #No.FUN-CB0096 ---start--- Add
     LET t_no = Null
     CALL s_log_check(l_order) RETURNING t_no
     IF NOT cl_null(t_no) THEN
        LET gl_no = t_no
        LET li_result = '1'
     ELSE
    #No.FUN-CB0096 ---start--- Add
     CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",p_bookno) #No.FUN-680088 g_nmz.nmz02b -> p_bookno #FUN-980094
          RETURNING li_result,gl_no
     END IF   #No.FUN-CB0096   Add
     PRINT "Get max TR-no:",gl_no," Return code(li_result):",li_result
     IF li_result = 0 THEN LET g_success = 'N' END IF
#     CALL s_m_aglau(g_dbs_gl,g_nmz.nmz02b,gl_no,gl_date,g_yy,g_mm,0)
#          RETURNING g_i,gl_no
#     PRINT "Get max TR-no:",gl_no," Return code(g_i):",g_i
#     IF g_i != 0 THEN LET g_success = 'N' END IF
#No.FUN-560190 ---end--
     IF g_bgjob = 'N' THEN  #NO.FUN-570127 
        DISPLAY "Insert G/L voucher no:",gl_no AT 1,1  
     END IF
     PRINT "Insert aba:",p_bookno,' ',gl_no,' From:',l_order  #No.FUN-680088 g_nmz.nmz02b -> p_bookno
   END IF  #No.FUN-570090  -add   
     
     #LET g_sql="INSERT INTO ",g_dbs_gl CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
               "(aba00,aba01,aba02,aba03,aba04,aba05,",
               " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",
               " abaprno,abaacti,abauser,abagrup,abadate,",
               #" abasign,abadays,abaprit,abasmax,abasseq)",   #MOD-740018
               " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,",     #FUN-840211 add aba11    #MOD-740018
               " abalegal,abaoriu,abaorig,aba21) " ,  #FUN-980005 #TQC-A10060 add abaoriu,abaorig FUN-A10006 add aba21
            #" VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #MOD-740018
            " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?,",     #FUN-840211 add ?    #MOD-740018 FUN-A10006 add ?
            "        ?,?,?) "  #FUN-980005  #TQC-A10060  add ?,?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p100_1_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     LET g_aba01t = gl_no[1,g_doc_len]    #No.FUN-560190
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
## ----
    #----------------------  for ora修改 ------------------------------------
     LET g_system = 'NM'
     LET g_zero   = 0
     LET g_zero1  = 0
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     #FUN-980005 add legal 
     CALL s_getlegal(p_plant) RETURNING l_legal  
     LET g_aba.abalegal = l_legal 
     #FUN-980005 end legal
     LET g_aba.abaoriu = g_user    #TQC-A10060  add
     LET g_aba.abaorig = g_grup    #TQC-A10060  add
     EXECUTE p100_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,g_today,  #No.FUN-680088 g_nmz.nmz02b -> p_bookno
                        #     g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero,    #TQC-960295 
                             g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero1,   #TQC-960295  
                             g_N,g_N,
                             g_zero,g_Y,g_user,g_grup,g_today,
            #g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_zero1   #MOD-740018
            g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_zero1,g_user,g_aba.aba11 #No.FUN-840211 add aba11    #MOD-740018
           ,g_aba.abalegal,g_aba.abaoriu,g_aba.abaorig,l_npp.npp08   #FUN-980005  #TQC-A10060  add g_aba.abaoriu,g_aba.abaorig FUN-A10006 add npp08
    #EXECUTE p100_1_p4 USING g_nmz.nmz02b,gl_no,gl_date,g_yy,g_mm,gl_date,
    #                           'NM',l_order,'0','0','N','N','0','N','N',
    #                           '0','Y',g_user,g_grup,g_today
    #----------------------  for ora修改 ------------------------------------
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#        CALL cl_err('ins aba:',SQLCA.sqlcode,1)
        LET g_showmsg=p_bookno,"/",gl_no
        CALL s_errmsg('aba00,aba01',g_showmsg,'ins aba:',SQLCA.sqlcode,1)
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570090  --add 
                            AND tmn06 = p_bookno  #No.FUN-680088
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF #CHI-A70009 add 
     CASE 
       WHEN l_npq.npq00 = 4                                #定存質押
            UPDATE gxg_file SET gxg07 = gl_no ,gxg08=gl_date
             WHERE gxg011 = l_npq.npq01 AND gxg02 = l_npq.npq011
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxg:',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxg_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","upd gxg:",1) #No.FUN-660148
                LET g_showmsg=l_npq.npq01,"/",l_npq.npq011
                CALL s_errmsg('gxg011,gxg02',g_showmsg,'upd gxg:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N' 
             END IF
          #--- No.MOD-470276---
         {
            UPDATE gxf_file SET gxf17 = gl_no ,gxf18 =gl_date
             WHERE gxf011 = l_npq.npq01
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxf:',SQLCA.sqlcode,1)    #No.FUN-660148
                CALL cl_err3("upd","gxf_file",,"",SQLCA.sqlcode,"","",1) #No.FUN-660148
                LET g_success = 'N'
             END IF
         }
         #--------END---------
        WHEN l_npq.npq00 = 5
             UPDATE gxg_file SET gxg10 = gl_no,gxg11 = gl_date
              WHERE gxg011 = l_npq.npq01 AND gxg02 = l_npq.npq011
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxg:',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxg_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","upd gxg:",1) #No.FUN-660148
                LET g_showmsg=l_npq.npq01,"/",l_npq.npq011
                CALL s_errmsg('gxg011,gxg02',g_showmsg,'upd gxg:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N' 
             END IF
          #--- No.MOD-470276---
         {
             UPDATE gxf_file SET gxf19 = gl_no ,gxf20=gl_date
              WHERE gxf011 = l_npq.npq01
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxf:',SQLCA.sqlcode,1)    #No.FUN-660148
                CALL cl_err3("upd","gxf_file",,"",SQLCA.sqlcode,"","",1) #No.FUN-660148
                LET g_success = 'N'
             END IF
         }
         #--------END---------
        WHEN l_npq.npq00 = 8 
             UPDATE gxe_file SET gxe14 = gl_no ,gxe141 = gl_date
              WHERE gxe01 = l_npq.npq01 AND gxe011=l_npp.npp011
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxe:',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxe_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","upd gxe:",1) #No.FUN-660148
                LET g_showmsg=l_npq.npq01,"/",l_npq.npq011
                CALL s_errmsg('gxe01,gxe011',g_showmsg,'upd gxg:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N'
            #--------------------------MOD-CC0035-------------------(S)
             ELSE
                UPDATE nme_file SET nme10 = gl_no ,nme16 = gl_date
                 WHERE nme12 = l_npq.npq01
                IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
                   CALL s_errmsg('nme12',l_npq.npq01,'upd nme:',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
            #--------------------------MOD-CC0035-------------------(E)
             END IF
        WHEN l_npq.npq00 = 9
             UPDATE gxc_file SET gxc14 = gl_no ,gxc141 =gl_date
              WHERE gxc01 = l_npq.npq01
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxc:',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxc_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd gxc:",1) #No.FUN-660148
                CALL s_errmsg('gxc01',l_npq.npq01,'upd gxc:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N' 
             END IF
        # polly.s
        WHEN l_npq.npq00 = 10
             UPDATE gxi_file SET gxiglno = gl_no ,gxi25 = gl_date
              WHERE gxi01 = l_npq.npq01
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxi:',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxi_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd gxi:",1) #No.FUN-660148
                CALL s_errmsg('gxi01',l_npq.npq01,'upd gxi:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N' 
            #--------------------------MOD-CC0035-------------------(S)
             ELSE
                UPDATE nme_file SET nme10 = gl_no ,nme16 = gl_date
                 WHERE nme12 = l_npq.npq01
                IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
                   CALL s_errmsg('nme12',l_npq.npq01,'upd nme:',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
            #--------------------------MOD-CC0035-------------------(E)
             END IF
        WHEN l_npq.npq00 = 11
             UPDATE gxk_file SET gxkglno = gl_no ,gxk30 = gl_date
              WHERE gxk01 = l_npq.npq01
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxk:',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxk_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd gxk:",1) #No.FUN-660148
                CALL s_errmsg('gxk01',l_npq.npq01,'upd gxk:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N'
            #--------------------------MOD-CC0035-------------------(S)
             ELSE
                UPDATE nme_file SET nme10 = gl_no ,nme16 = gl_date
                 WHERE nme12 = l_npq.npq01
                IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
                   CALL s_errmsg('nme12',l_npq.npq01,'upd nme:',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
            #--------------------------MOD-CC0035-------------------(E)
             END IF
             #更新 定期存單檔 到期傳票及日期
             DECLARE gxl_cur CURSOR FOR SELECT gxl03 FROM gxl_file  #bug no:7356
               WHERE gxl01=l_npq.npq01
             FOREACH gxl_cur INTO l_gxl03
                UPDATE gxf_file SET gxf29 = gl_no ,gxf30 = gl_date
                 WHERE gxf011 = l_gxl03
                IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#                  CALL cl_err('upd gxf:',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#                   CALL cl_err3("upd","gxf_file",l_gxl03,"",SQLCA.sqlcode,"","upd gxf:",1) #No.FUN-660148
                   CALL s_errmsg('gxf011',l_gxl03,'upd gxf:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                   LET g_success = 'N'
                END IF
             END FOREACH
        WHEN l_npq.npq00 = 12
             UPDATE gxf_file SET gxf13 = gl_no ,gxf14= gl_date
              WHERE gxf011 = l_npq.npq01
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxf:',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxf_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd gxf:",1) #No.FUN-660148
                CALL s_errmsg('gxf011',l_npq.npq01,'upd gxf:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N' 
            #--------------------------MOD-CC0035-------------------(S)
             ELSE
                UPDATE nme_file SET nme10 = gl_no ,nme16 = gl_date
                 WHERE nme12 = l_npq.npq01
                IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
                   CALL s_errmsg('nme12',l_npq.npq01,'upd nme:',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
            #--------------------------MOD-CC0035-------------------(E)
             END IF
        # polly.end
        #-----MOD-640499---------
        WHEN l_npq.npq00 = 24
             LET l_str = l_npq.npq01
             LET l_len = l_str.getLength()
             LET l_gxh011 = l_str.subString(1,l_len-6)
             LET l_gxh02  = l_str.subString(l_len-5,l_len-2)
             LET l_gxh03  = l_str.subString(l_len-1,l_len)
 
             UPDATE gxh_file SET gxhglno = gl_no
               WHERE gxh011 = l_gxh011 AND gxh02 = l_gxh02 AND gxh03 = l_gxh03
             IF SQLCA.SQLERRD[3] = 0 OR SQLCA.sqlcode THEN
#               CALL cl_err('upd gxh:',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#                CALL cl_err3("upd","gxh_file",l_gxh011,l_gxh02,SQLCA.sqlcode,"","upd gxh:",1) #No.FUN-660148
                LET g_showmsg=l_gxh011,"/",l_gxh02,"/",l_gxh03
                CALL s_errmsg('gxh011,gxh02,gxh03',g_showmsg,'upd gxh:',SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N'
             END IF
        #-----END MOD-640499-----
 
     END CASE
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no,
                         npp06= p_plant,npp07=p_bookno
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype = '0'  #No.FUN-680088
     IF SQLCA.sqlcode THEN
#       CALL cl_err('upd npp03/glno:',SQLCA.sqlcode,1)    #No.FUN-660148
#No.FUN-710024--begin
#        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp02,SQLCA.sqlcode,"","upd npp03/glno:",1) #No.FUN-660148
        LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.npp00,"/",l_npp.nppsys
        CALL s_errmsg('npp01,npp011,npp00,nppsys',g_showmsg,'upd npp03/glno:',SQLCA.sqlcode,1)
#No.FUN-710024--end
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN  #NO.FUN-570127
        DISPLAY "Seq:",l_seq AT 2,1  
     END IF
     #LET g_sql = "INSERT INTO ",g_dbs_gl CLIPPED,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                   #    " abb08,abb11,abb12,abb13,abb14,abb15,",      #No.FUN-810069 
                        " abb08,abb11,abb12,abb13,abb14,",            #No.FUN-810069
                        " abb24,abb25,",
 
                        #FUN-5C0015 BY GILL --START
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        #FUN-5C0015 BY GILL --END
                        ",abblegal ", 
                        " )",
            #    " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",      #No.FUN-810069 
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?",        #No.FUN-810069
                 "       ,?,?,?,?,?, ?,?,?)" #FUN-5C0015 BY GILL
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p100_1_p5 FROM g_sql
 
     #FUN-980005 add legal 
     CALL s_getlegal(p_plant) RETURNING l_legal  
     #FUN-980005 end legal 
     EXECUTE p100_1_p5 USING 
                p_bookno,gl_no,l_seq,l_npq.npq03,l_npq.npq04,  #No.FUN-680088 g_nmz.nmz02b -> p_bookno
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
              # l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25,      #No.FUN-810069
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                  #No.FUN-810069
 
                #FUN-5C0015 BY GILL --START
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37
                #FUN-5C0015 BY GILL --END
               ,l_legal  #FUN-980005 
 
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#        CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
        LET g_showmsg=p_bookno,"/",gl_no,"/",l_seq
        CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ins abb:',SQLCA.sqlcode,1)
        LET g_success='N'
#No.FUN-710024--end
     END IF
 
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED,"aba_file SET aba08 = ?,aba09 = ? ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  " SET aba08 = ?,aba09 = ? ",
                  "    ,aba21=? ",                                 #MOD-A80017 Add 
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p100_1_p6 FROM g_sql
      EXECUTE p100_1_p6 USING l_debit,l_credit,l_npp08,gl_no,p_bookno  #No.FUN-680088 g_nmz.nmz02b -> p_bookno #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
         LET g_showmsg=gl_no,"/",p_bookno
         CALL s_errmsg('aba00,aba01',g_showmsg,'upd aba08/09:',SQLCA.sqlcode,1)
         LET g_success='N'
#No.FUN-710024--end
      END IF
      PRINT
     CALL s_flows('2',p_bookno,gl_no,gl_date,g_N,'',TRUE)   #No.TQC-B70021 
#no.3432 自動確認
IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
     #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'abb_file'), " ,aag_file", #FUN-A50102    
                 " WHERE abb01 = '",gl_no,"'",
                 "   AND abb00 = '",p_bookno,"'",  #No.FUN-680088 g_nmz.nmz02b -> p_bookno
                 "   AND abb03 = aag01  ",
                 "   AND aag20 = 'Y' ",
                 "   AND abb00 = aag00  "        #No.FUN-740049     
                 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE count_pre FROM g_sql
      DECLARE count_cs CURSOR FOR count_pre
      OPEN count_cs 
      FETCH count_cs INTO g_cnt
      CLOSE count_cs
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
         #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-7B0104
         #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-7B0104
         IF g_aba.abamksg='N' THEN   #MOD-7B0104
            LET g_aba.aba20='1' 
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (p_bookno,gl_no) RETURNING l_success  
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
                               " aba20   = ? ,",             #MOD-A80136
                               " aba37   = ?  ",             #MOD-A80136
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba19 FROM g_sql
            EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user  ,                #MOD-A80136
                                    gl_no        ,p_bookno  #No.FUN-680088 g_nmz.nmz02b -> p_bookno
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#              CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
               LET g_showmsg=gl_no,"/",p_bookno
               CALL s_errmsg('aba00,aba01',g_showmsg,'upd aba19',STATUS,1)
               LET g_success='N'
#No.FUN-710024--end
            END IF
         END IF   #MOD-770101
      END IF
END IF     
#no.3432(end)
       #No.FUN-CB0096 ---start--- Add
       #LET l_time = TIME   #No.FUN-D60110   Mark
        LET l_time = l_time + 1    #No.FUN-D60110   Add
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no,l_order)
        IF g_aba.abamksg = 'N' THEN
          #LET l_time = TIME   #No.FUN-D60110   Mark
           LET l_time = l_time + 1    #No.FUN-D60110   Add
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
#      LET gl_no[4,12]=''
       LET gl_no[g_no_sp-1,g_no_ep]=''   #No.FUN-560190
END REPORT
 
#No.FUN-680088 --start--
REPORT anmp100_1_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01   #No.FUN-680107 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6  #No.FUN-680107 DECIMAL(20,6)
  DEFINE l_remark       LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(150)             
  DEFINE l_gxl03        LIKE gxl_file.gxl03   
  DEFINE li_result      LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01     
  DEFINE l_flag1        LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
  DEFINE l_str          STRING,   
         l_len          LIKE type_file.num5,    #No.FUN-680107 SMALLINT
         l_gxh011       LIKE gxh_file.gxh011, 
         l_gxh02        LIKE gxh_file.gxh02,  
         l_gxh03        LIKE gxh_file.gxh03   
  DEFINE l_legal        LIKE npp_file.npplegal     #FUN-980005 
  DEFINE l_npp08        LIKE npp_file.npp08     #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021 
   
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_npq.npq00,l_order,l_npq.npq06,   #NO:7498
           l_npq.npq03,l_npq.npq05,l_npq.npq24,l_npq.npq25,
           l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
      IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF   #CHI-A70009 add
 
#No.FUN-670060--begin                                                                                                               
   # 得出總帳 database name                                                                                                         
   # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl                                                            
    LET g_plant_new= p_plant  # 工廠編號                                                                                            
    CALL s_getdbs()                                                                                                                 
    LET g_dbs_gl=g_dbs_new CLIPPED                                                                                                  
#No.FUN-670060--end  
 
   #缺號使用            
   #No.FUN-570090  --begin 
   LET l_flag1='N'        
   LET l_missingno = NULL 
   LET g_j=g_j+1         
   SELECT tc_tmp02 INTO l_missingno        
     FROM agl_tmp_file                     
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'
      AND tc_tmp03 = p_bookno1
   IF NOT cl_null(l_missingno) THEN     
      LET l_flag1='Y'                  
      LET gl_no1=l_missingno           
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1      
                                AND tc_tmp03 = p_bookno1
   END IF                                                
                                        
   #缺號使用完，再在流水號最大的編號上增加      
   IF l_flag1='N' THEN                         
   #No.FUN-570090  --end
#No.FUN-560190 --start--
    #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",g_dbs_gl,"",p_bookno1) #FUN-980094
    #No.FUN-CB0096 ---start--- Add
     LET t_no = Null
     CALL s_log_check(l_order) RETURNING t_no
     IF NOT cl_null(t_no) THEN
        LET gl_no1 = t_no
        LET li_result = '1'
     ELSE
    #No.FUN-CB0096 ---start--- Add
     CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",p_plant,"",p_bookno1) #FUN-980094
          RETURNING li_result,gl_no1
     END IF   #No.FUN-CB0096   Add
     PRINT "Get max TR-no:",gl_no1," Return code(li_result):",li_result
     IF li_result = 0 THEN LET g_success = 'N' END IF
     IF g_bgjob = 'N' THEN 
        DISPLAY "Insert G/L voucher no:",gl_no1 AT 1,1  
     END IF
     PRINT "Insert aba:",p_bookno1,' ',gl_no1,' From:',l_order
   END IF  #No.FUN-570090  -add   
     #LET g_sql="INSERT INTO ",g_dbs_gl CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
               "(aba00,aba01,aba02,aba03,aba04,aba05,",
               " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",
               " abaprno,abaacti,abauser,abagrup,abadate,",
               " abasign,abadays,abaprit,abasmax,abasseq,aba11,",     #FUN-840211 add aba11
               " abalegal,abaoriu,abaorig,aba21,aba24)" , #FUN-980005   #TQC-A10060 add abaoriu,abaorig FUN-A10006 add aba21 #MOD-A80136 add aba24
            " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,",#FUN-840211 add ? FUN-A10006 add ?
            "        ?,?,?,?) "    #FUN-980005  #TQC-A10060  add ?,? #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p100_1_p7 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no1
     LET g_aba01t = gl_no1[1,g_doc_len]    #No.FUN-560190
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
## ----
    #----------------------  for ora修改 ------------------------------------
     LET g_system = 'NM'
     LET g_zero   = 0
     LET g_zero1  = 0
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     #FUN-980005 add legal 
     CALL s_getlegal(p_plant) RETURNING l_legal  
     LET g_aba.abalegal = l_legal 
     #FUN-980005 end legal 
     LET g_aba.abaoriu = g_user  #TQC-A10060 add
     LET g_aba.abaorig = g_grup  #TQC-A10060 add
     EXECUTE p100_1_p7 USING p_bookno1,gl_no1,gl_date,g_yy,g_mm,g_today,
                            # g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero,    #TQC-960295 
                             g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero1,  #TQC-960295  
                             g_N,g_N,
                             g_zero,g_Y,g_user,g_grup,g_today,
            g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_zero1,g_aba.aba11 #No.FUN-840211 add aba11
           ,g_aba.abalegal,g_aba.abaoriu,g_aba.abaorig,l_npp.npp08,g_user    #FUN-980005  #TQC-A10060 FUN-A10006 add npp08 #MOD-A80136 add g_user
    #----------------------  for ora修改 ------------------------------------
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
         LET g_showmsg=p_bookno1,"/",gl_no1
         CALL s_errmsg('aba00,aba01',g_showmsg,'ins aba:',SQLCA.sqlcode,1)
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1
                            AND tmn06 = p_bookno1
     IF gl_no1_b IS NULL THEN LET gl_no1_b = gl_no1 END IF
     LET gl_no1_e = gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF   #CHI-A70009 add
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no1,
                         npp06= p_plant,npp07=p_bookno1
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype = '1' 
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp02,SQLCA.sqlcode,"","upd npp03/glno1:",1)
        LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.npp00,"/",l_npp.nppsys
        CALL s_errmsg('npp01,npp011,npp00,nppsys',g_showmsg,'upd npp03/glno1:',SQLCA.sqlcode,1)
#No.FUN-710024--end
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN  #NO.FUN-570127
        DISPLAY "Seq:",l_seq AT 2,1 
     END IF
     #LET g_sql = "INSERT INTO ",g_dbs_gl CLIPPED,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                    #    " abb08,abb11,abb12,abb13,abb14,abb15,",        #No.FUN-810069   
                        " abb08,abb11,abb12,abb13,abb14,",               #No.FUN-810069   
                        " abb24,abb25,",
 
                        #FUN-5C0015 BY GILL --START
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        #FUN-5C0015 BY GILL --END
                        ",abblegal",  #FUN-980005 
                        " )",
              #   " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",        #No.FUN-810069   
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?",           #No.FUN-810069   
                 "       ,?,?,?,?,?, ?,?,?)" #FUN-5C0015 BY GILL
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p100_1_p8 FROM g_sql
     #FUN-980005 add legal 
     CALL s_getlegal(p_plant) RETURNING l_legal  
     #FUN-980005 end legal 
     EXECUTE p100_1_p8 USING 
                p_bookno1,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
         #       l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25,        #No.FUN-810069   
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                     #No.FUN-810069   
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37
               ,l_legal    #FUN-980005 
 
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#        CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
        LET g_showmsg=p_bookno1,"/",gl_no1,"/",l_seq
        CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ins abb:',SQLCA.sqlcode,1)
        LET g_success = 'N'
#No.FUN-710024--end
     END IF
   
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED,"aba_file SET (aba08,aba09) = (?,?)",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
#                 " SET (aba08,aba09) = (?,?)",                    #MOD-A80017 Mark
                  " SET aba08 = ?,aba09 = ? ",                     #MOD-A80017 Add
                  "    ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p100_1_p9 FROM g_sql
      EXECUTE p100_1_p9 USING l_debit,l_credit,l_npp08,gl_no1,p_bookno1   #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
         LET g_showmsg=gl_no1,"/",p_bookno1
         CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba08/09:',SQLCA.sqlcode,1)
         LET g_success = 'N'
#No.FUN-710024--end
      END IF
      PRINT
     CALL s_flows('2',p_bookno1,gl_no1,gl_date,g_N,'',TRUE)   #No.TQC-B70021
#no.3432 自動確認
IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
     #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'abb_file')," ,aag_file", #FUN-A50102     
                 " WHERE abb01 = '",gl_no1,"'",
                 "   AND abb00 = '",p_bookno1,"'",
                 "   AND abb03 = aag01  ",
                 "   AND aag20 = 'Y' ",
                 "   AND abb00 = aag00  "        #No.FUN-740049
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE count_pre1 FROM g_sql
      DECLARE count_cs1 CURSOR FOR count_pre1
      OPEN count_cs1 
      FETCH count_cs1 INTO g_cnt
      CLOSE count_cs1
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
         #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-7B0104
         #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-7B0104
         IF g_aba.abamksg='N' THEN   #MOD-7B0104
            LET g_aba.aba20='1' 
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (p_bookno1,gl_no1) RETURNING l_success  
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
                               " aba20   = ? ,",             #MOD-A80136
                               " aba37   = ?  ",             #MOD-A80136
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba19_1 FROM g_sql
            EXECUTE upd_aba19_1 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user  ,                #MOD-A80136
                                    gl_no1       ,p_bookno1
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#              CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
               LET g_showmsg=gl_no1,"/",p_bookno1
               CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba19',STATUS,1)
               LET g_success = 'N'
#No.FUN-710024--end
            END IF
         END IF   #MOD-770101
      END IF
END IF     
       #No.FUN-CB0096 ---start--- Add
       #LET l_time = TIME   #No.FUN-D60110   Mark
        LET l_time = l_time + 1    #No.FUN-D60110   Add
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no1,l_order)
        IF g_aba.abamksg = 'N' THEN
          #LET l_time = TIME   #No.FUN-D60110   Mark
           LET l_time = l_time + 1    #No.FUN-D60110   Add
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no1,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
       LET gl_no1[g_no_sp-1,g_no_ep]=''
END REPORT
#No.FUN-680088 --end--
 
FUNCTION p100_create_tmp()
 DROP TABLE p100_tmp;
#SELECT 'xxxxxxxxxxxxxxxx' order1, npp_file.*,npq_file.*,               # MOD-790147
 #No.TQC-9B0039  --Begin
 #SELECT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order1, npp_file.*,npq_file.*, # MOD-790147 
 #       SPACE(100) remark
 #  FROM npp_file,npq_file
 # WHERE npp01 = npq01 AND npp01 = '@@@@'
 #  INTO TEMP p100_tmp
 SELECT chr30 order1, npp_file.*,npq_file.*, # MOD-790147 
        chr1000 remark
   FROM npp_file,npq_file,type_file
  WHERE npp01 = npq01 AND npp01 = '@@@@'
    AND 1=0
   INTO TEMP p100_tmp
 #No.TQC-9B0039  --End  
 IF SQLCA.SQLCODE THEN
    LET g_success='N'
#   CALL cl_err('create p100_tmp:',SQLCA.SQLCODE,0)   #No.FUN-660148
    CALL cl_err3("ins","p100_tmp","","",SQLCA.sqlcode,"","create p100_tmp:",0) #No.FUN-660148
 END IF
 DELETE FROM p100_tmp WHERE 1=1
#
# CREATE TEMP TABLE p100_tmp
# (order1    VARCHAR(30), 
#  nppsys    VARCHAR(02),  
#  npp00     smallint,      
#  npp01     VARCHAR(20), 
#  npp011    smallint, 
#  npp02     date,     
#  npp03     date,     
#  npp04     smallint, 
#  npp05     VARCHAR(02), 
#  npp06     VARCHAR(10),
#  npp07     VARCHAR(05),  #No.FUN-670039
#  nppglno   VARCHAR(12),
#  npqsys    VARCHAR(02),         
#  npq00     smallint,        
#  npq01     VARCHAR(20),       
#  npq011    smallint,      
#  npq02     smallint,     
#  npq03     VARCHAR(20),    
#  npq04     VARCHAR(30),   
#  npq05     VARCHAR(06),     
#  npq06     VARCHAR(01),       
#  npq07f    dec(15,3) not null,
#  npq07     dec(15,3) not null,
#  npq08     VARCHAR(15),       
#  npq11     VARCHAR(15),      
#  npq12     VARCHAR(15),     
#  npq13     VARCHAR(15),    
#  npq14     VARCHAR(15),   
#  npq15     VARCHAR(04),  
#  npq21     VARCHAR(10), 
#  npq22     VARCHAR(10),
#  npq23     VARCHAR(10),   
#  npq24     VARCHAR(04),   
#  npq25     dec(20,10) not null,   #No.FUN-4B0052
#  npq26     VARCHAR(01),         
#  npq27     VARCHAR(01),        
#  npq28     VARCHAR(01),       
#  npq29     VARCHAR(01),  
#  npq30     VARCHAR(10),
#  remark    VARCHAR(100)
#  )
#}
END FUNCTION
#TQC-9B0142 mod

#CHI-A70009 add --start--
FUNCTION chk_date()  #傳票日期抓npp02時要判斷的日期
  DEFINE l_npp     RECORD LIKE npp_file.*
  DEFINE l_npq     RECORD LIKE npq_file.*
  DEFINE l_aaa07   LIKE aaa_file.aaa07

  LET g_sql="SELECT npp_file.*,npq_file.* ",
            "  FROM npp_file,npq_file,nmy_file",
            " WHERE nppsys= 'NM'  AND nppglno IS NULL",
            "   AND npp01 = npq01 AND npp011=npq011",
            "   AND npp00 = npq00 ",
            "   AND ",g_wc CLIPPED,
            "   AND npp01 like trim(nmyslip)||'-%' AND nmydmy3='Y'",  
            "   AND nppsys=npqsys "
   PREPARE p100_1_p10 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p100_1_p10',STATUS,1)
      CALL p100_tmn_del()
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110   Mark
      LET l_time = l_time + 1    #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p100_1_c10 CURSOR WITH HOLD FOR p100_1_p10
   FOREACH p100_1_c10 INTO l_npp.*,l_npq.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01=p_bookno
      IF l_npp.npp02 <= l_aaa07 THEN
         CALL cl_err(l_npp.npp01,'axm-164',0)
         LET g_success = 'N'
      END IF
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=l_npp.npp02
      IF STATUS THEN
         CALL cl_err3("sel","azn_file",l_npp.npp02,"",SQLCA.sqlcode,"","read azn",0)
         LET g_success = 'N'
      END IF
   END FOREACH
END FUNCTION

FUNCTION p100_tmn_del()
   DEFINE l_tmn02 LIKE tmn_file.tmn02
   DEFINE l_tmn06 LIKE tmn_file.tmn06

   FOREACH tmn_del INTO l_tmn02,l_tmn06
      DELETE FROM tmn_file
      WHERE tmn01 = p_plant
        AND tmn02 = l_tmn02
        AND tmn06 = l_tmn06
   END FOREACH
END FUNCTION
#CHI-A70009 add --end--
#CHI-AC0010
