# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: afap302.4gl
# Descriptions...: FA系統傳票拋轉總帳
# Date & Author..: 97/05/16 By Danny
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-490264 04/09/16 By Nicola npp00一定要輸入(再次改回來)
# Modify.........: No.FUN-4B0073 04/11/26 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-510051 05/01/10 By Kitty gl_no_b/gl_no_e的欄位變數未清除, 導致連續執行時, 傳票列印錯誤
# Modify.........: No.FUN-560146 05/06/21 By Nicola 使用相同之總帳工廠編號時，組sql會有錯誤
# Modify.........: No.FUN-560190 05/06/28 By wujie  單據編號修改
# Modify ........: No.FUN-570090 05/07/29 By will 增加取得傳票缺號號碼的功能
# Modify.........: No.FUN-5C0015 060102 BY GILL 多 INSERT 異動碼5~10, 關係人
# Modify.........: No.FUN-570144 06/03/03 By yiting 批次作業背景執行
# Modify.........: No.FUN-650088 06/05/17 By Smapmin 增加是否拋轉傳票的CHECK
# Modify.........: No.FUN-660032 06/06/12 By rainy   拋轉摘要預設為"Y"
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.MOD-660139 06/06/30 By Sarah 檢查fahdmy3='Y'的條件句排除掉npp00='10'(折舊)
# Modify.........: No.FUN-670003 06/07/10 By Czl 帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670060 06/08/04 By Rayven 修正只能拋DEMO-1的BUG
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改 
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位型態定義,改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6B0103 06/11/23 By Smapmin 修正MOD-680063
# Modify.........: No.MOD-690088 06/12/01 By Smapmin 拋轉完後並未顯示傳票編號資訊
# Modify.........: No.MOD-6C0182 06/12/29 By Smapmin 拋轉至總帳時,狀態碼為0開立.
# Modify.........: No.FUN-710028 07/01/18 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-740019 07/04/10 By Smapmin 動態抓取單號長度
# Modify.........: No.TQC-750011 07/06/22 By rainy npp_file,npq_file 加 npp00 = npq00
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-770150 07/08/06 By Smapmin 拋轉總帳沒有申請人
# Modify.........: No.MOD-770139 07/08/08 By Smapmin 增加傳票自動確認功能
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控
# Modify.........: No.MOD-850183 08/05/22 By Sarah 將IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF這行mark掉
#                                                  將IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN改成IF g_aba.abamksg='N' THEN
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.MOD-890061 08/09/12 By Sarah 當npp00='10'時,增加CALL s_chknpq()檢查分錄底稿
# Modify.........: No.MOD-890293 08/10/02 By Smapmin 檢核分錄的錯誤訊息重複顯示
#                                                    transaction過程中因有DDL語法,導致rollback失敗
# Modify.........: No.MOD-8C0037 08/12/09 By Sarah 當npp00=10時,抓取當年度/期別(fan03/fan04)fan資料筆數不可為0
# Modify.........: No.MOD-930194 09/04/07 By liuxqa 若是背景執行，則應在執行前先判斷賬款日期是否小于關帳日期，若是則退出。
# Modify.........: No.TQC-960092 09/06/12 By baofei MSV p302_tmp插值的時候不能為NULL
# Modify.........: No.TQC-960449 09/07/02 By destiny 宣告p302_1_p0時order by了多個npq01  
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/10 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No:MOD-990236 09/10/21 By mike sql修改    
# Modify.........: No.TQC-9B0029 09/11/06 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0070 09/11/10 By wujie 5.2SQL转标准语法
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9B0145 09/11/19 By wujie   npq01截位
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0034 09/12/04 by wujie  执行利息资本化时，fcx01取npq01前10码
# Modify.........: No:TQC-9C0027 09/12/08 By liuxqa 总账传票日期空白者，依原分录日期产生。
# Modify.........: No:TQC-9C0125 09/12/23 By liuxqa 修正TQC-9C0027 .
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.TQC-A10060 10/01/12 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10006 10/01/13 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No:FUN-A10089 10/01/19 By wujie  增加显示选取的缺号结果
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba37 預設值 
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:MOD-AC0277 10/12/23 By Dido 財編不足時,須再用 CLIPPED 動作 
# Modify.........: No:MOD-AC0406 10/12/31 By chenying afap302拋轉時，有出現錯誤訊息-->
# Modify.........: No:MOD-B30368 11/03/16 By lixia 拋傳票程式沒進FOREACH p302_cus而跑FINISH REPORT,會當掉
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B40042 11/04/11 By Dido 未過帳不可拋轉
# Modify.........: No:MOD-B50121 11/05/13 By Dido gl_no 變數非單別導致取號有誤 
# Modify.........: No:MOD-B60111 11/06/14 By Dido report 變數調整 
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No.MOD-B80302 11/08/30 By Dido 當npp00='12'時,增加CALL s_chknpq()檢查分錄底稿
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善" 追單
# Modify.........: No:TQC-BA0149 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:MOD-BC0074 11/12/10 By johung 拋轉匯總全部時仍會匯成多張
# Modify.........: No:FUN-BC0035 12/01/16 By Sakura 增加npp00=14判斷
# Modify.........: No:MOD-C20099 12/02/09 By Dido 折舊分錄若有誤,則此筆分錄皆不可產生 
# Modify.........: No:TQC-C50073 12/05/09 By xuxz b_user,e_user賦值修改
# Modify.........: No:FUN-C50113 12/05/58 By minpp afai104抛转总账调用,修改开窗显示设置
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No.MOD-CC0100 12/12/13 By Polly 財簽二動態抓取單號長度
# Modify.........: No.MOD-CC0140 12/12/17 By yinhy 默認g_j初始值為0
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:MOD-CB0120 13/02/04 By jt_chen 調整累加值變數預設，已正確的補到缺號。

IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_wc,g_sql       STRING                      #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21        #No.FUN-680070 VARCHAR(21)
DEFINE g_plant_gl 	LIKE type_file.chr21        #No.FUN-980059 VARCHAR(21)
DEFINE gl_no	        LIKE aba_file.aba01         # 傳票單別 No.FUN-560190  #No.FUN-680070 VARCHAR(16)
DEFINE gl_no_b,gl_no_e	LIKE aba_file.aba01         # No.FUN-560190           #No.FUN-680070 VARCHAR(16)
DEFINE p_plant          LIKE npp_file.npp06         #No.FUN-680070 VARCHAR()
DEFINE p_plant_old      LIKE npp_file.npp06         #No.FUN-570090  --add     #No.FUN-680070 VARCHAR(12)
DEFINE p_bookno         LIKE aaa_file.aaa01         #NO.FUN-6700039
DEFINE p_bookno1        LIKE aaa_file.aaa01         #No.FUN-680028
DEFINE gl_no_b1,gl_no_e1	LIKE aba_file.aba01 #No.FUN-680028            #No.FUN-680070 VARCHAR(16)
DEFINE gl_no1		LIKE aba_file.aba01         #No.FUN-680028            #No.FUN-680070 VARCHAR(16)
DEFINE gl_date		LIKE type_file.dat          #No.FUN-680070 DATE
DEFINE gl_tran		LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_t1             LIKE type_file.chr5         #NO.FUN-680070 VARCHAR(05)
DEFINE gl_seq           LIKE type_file.chr1         # 傳票區分項目            #No.FUN-680070 VARCHAR(1)
DEFINE b_user,e_user	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
DEFINE g_yy,g_mm	LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_statu          LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_aba01t         LIKE aba_file.aba01         #No.FUN-560190
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_npp00          LIKE npp_file.npp00         #No.MOD-490264
DEFINE   g_flag          LIKE type_file.num5        #No.FUN-680070 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose    #No.FUN-680070 SMALLINT
DEFINE   g_j             LIKE type_file.num5,       #No.FUN-570090  --add           #No.FUN-680070 SMALLINT
         g_change_lang   LIKE type_file.chr1        #是否有做語言切換 No.FUN-570144 #No.FUN-680070 VARCHAR(01)
DEFINE g_zero           LIKE type_file.chr1   #MOD-6C0182
DEFINE   g_aaz85         LIKE aaz_file.aaz85 #傳票是否自動確認   #MOD-770139
DEFINE g_npp01          DYNAMIC ARRAY OF LIKE npp_file.npp01   #MOD-890293
DEFINE g_cnt2           LIKE type_file.num10        #MOD-890293
DEFINE g_flag1           LIKE type_file.chr1         #TQC-9C0027  add  
DEFINE g_npp            RECORD LIKE npp_file.*      #FUN-C50113
DEFINE g_fromprog       STRING #FUN-C50113 add      #FUN-C50113
DEFINE gl_bookno        LIKE npp_file.npp01                     #FUN-C50113
DEFINE gl_bookno2       LIKE npp_file.npp011         #FUN-C50113
DEFINE gl_date1         LIKE npp_file.npp02          #FUN-C50113
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add

MAIN
     DEFINE ls_date       STRING                  #->No.FUN-570144
     DEFINE l_flag        LIKE type_file.chr1     #->No.FUN-570144       #No.FUN-680070 VARCHAR(1)
     DEFINE l_tmn02       LIKE tmn_file.tmn02     #No.FUN-670068                                                                       
     DEFINE l_tmn06       LIKE tmn_file.tmn06     #No.FUN-670068 
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
 
   LET g_wc     = ARG_VAL(1)             #QBE條件       
   LET g_fromprog  = ARG_VAL(1)          #用於afai104傳入#FUN-C50113
   LET b_user   = ARG_VAL(2)             #輸入user範圍
   LET e_user   = ARG_VAL(3)             #輸入user範圍
   LET p_plant  = ARG_VAL(4)             #總帳營運中心編號
   LET p_bookno = ARG_VAL(5)             #總帳帳別編號
   LET gl_no    = ARG_VAL(6)             #總帳傳票單別
   LET ls_date  = ARG_VAL(7)             #總帳傳票日期
   LET gl_date  = cl_batch_bg_date_convert(ls_date)
   LET gl_tran  = ARG_VAL(8)             #應拋轉摘要
   LET gl_seq   = ARG_VAL(9)             #傳票彙總方式
   LET g_bgjob  = ARG_VAL(10)            #背景作業
   LET p_bookno1= ARG_VAL(11)             #總帳帳別編號2     #No.FUN-680028
   LET gl_no1   = ARG_VAL(12)             #總帳傳票單別2     #No.FUN-680028
   LET gl_bookno= ARG_VAL(13)             #單號              #FUN-C50113
   LET gl_bookno2=ARG_VAL(14)             #序號              #FUN-C50113
   LET gl_date1  =ARG_VAL(15)              #日期              #FUN-C50113
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
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
 
   CALL p302_create_tmp()  #MOD-890293 
   DROP TABLE agl_tmp_file                                                                                                           

   CREATE TEMP TABLE agl_tmp_file
   (tc_tmp00     LIKE type_file.chr1 NOT NULL,
    tc_tmp01     LIKE type_file.num5,  
    tc_tmp02     LIKE type_file.chr20, 
    tc_tmp03     LIKE type_file.chr8)
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM 
   END IF   
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03) #No.FUN-680028                
   IF STATUS THEN CALL cl_err('create index',STATUS,0) 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM 
   END IF 
    DECLARE tmn_del CURSOR FOR                                                                                                      
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'                                                               
   LET g_j = 0   #MOD-CB0120 add
   WHILE TRUE
      IF g_bgjob = "N" THEN
         LET g_success = 'Y'
         CALL p302_ask()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            CALL cl_wait()
            LET p_row = 19 LET p_col = 20
            LET g_faa.faa02b = p_bookno    # 得帳別
            LET g_faa.faa02c = p_bookno1   # 得帳別
            LET g_j = 0     #MOD-CC0140
            OPEN WINDOW afap302_t_w9 AT p_row,p_col WITH 3 ROWS, 70 COLUMNS
            CALL cl_set_win_title("afap302_t_w9")
            CALL p302_t('0')
        #   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           ##-----No:FUN-B60140 Mark-----
           #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088 
           #   CALL p302_t('1')
           #END IF
           ##-----No:FUN-B60140 Mark END-----
            CALL s_showmsg()         #No.FUN-710028
            CLOSE WINDOW afap302_t_w9
            IF g_success = 'Y' THEN
               IF NOT cl_null(gl_no_b) THEN
                  CALL s_m_prtgl(g_plant_gl,g_faa.faa02b,gl_no_b,gl_no_e) #FUN-990069
              #   IF g_aza.aza63 = 'Y' THEN     #第二套帳是否打印
                 ##-----No:FUN-B60140 Mark-----
                 #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
                 #   CALL s_m_prtgl(g_plant_gl,g_faa.faa02c,gl_no_b1,gl_no_e1) #FUN-990069
                 #END IF
                 ##-----No:FUN-B60140 Mark END-----
               END IF
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p302
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y' 
         BEGIN WORK
         LET g_faa.faa02b = p_bookno    # 得帳別
         LET g_faa.faa02c = p_bookno1   # 得帳別
         CALL p302_t('0')
      #  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        ##-----No:FUN-B60140 Mark-----
        #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088
        #   CALL p302_t('1')
        #END IF
        ##-----No:FUN-B60140 Mark END-----
         CALL s_showmsg()   #No.FUN-710028
         IF g_success = "Y" THEN
            IF NOT cl_null(gl_no_b) THEN
               CALL s_m_prtgl(g_plant_gl,g_faa.faa02b,gl_no_b,gl_no_e)    #FUN-990069
            #  IF g_aza.aza63 = 'Y' THEN     #第二套帳是否打印
              ##-----No:FUN-B60140 Mark-----
              #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
              #   CALL s_m_prtgl(g_plant_gl,g_faa.faa02c,gl_no_b1,gl_no_e1) #FUN-990069
              #END IF
              ##-----No:FUN-B60140 Mark END-----
            END IF
            COMMIT WORK
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
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION p302()
 

     CALL p302_ask()	# Ask for first_flag, data range or exist_no
     IF INT_FLAG THEN RETURN END IF
     IF NOT cl_sure(20,20) THEN   #LET INT_FLAG = 1 RETURN END IF  #NO.FUN-570144 
         CALL cl_wait()
         LET g_faa.faa02b = p_bookno  # 得帳別
         LET p_row = 19 LET p_col = 20
         OPEN WINDOW p302_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
         CALL cl_set_win_title("afap302_t_w9")  #NO.FUN-570144 
         CALL p302_t('0')
      #  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        ##-----No:FUN-B60140 Mark-----
        #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088
        #   CALL p302_t('1')
        #END IF
        ##-----No:FUN-B60140 Mark END-----
     END IF 
     CLOSE WINDOW p302_t_w9

END FUNCTION
 
FUNCTION p302_ask()
   DEFINE li_chk_bookno  LIKE type_file.num5    #No.FUN-670003       #No.FUN-680070 SMALLINT
   DEFINE   l_aaa07   LIKE aaa_file.aaa07
   DEFINE   l_tmn02   LIKE tmn_file.tmn02 	#No.FUN-670068
   DEFINE   l_tmn06   LIKE tmn_file.tmn06 	#No.FUN-670068
   DEFINE   l_flag    LIKE type_file.chr1       #No.FUN-680070 VARCHAR(01)
   DEFINE   li_result LIKE type_file.num5       #No.FUN-560190       #No.FUN-680070 SMALLINT
   DEFINE   l_cnt     LIKE type_file.num5       #No.FUN-570090  -add             #No.FUN-680070 SMALLINT
   DEFINE   lc_cmd    LIKE type_file.chr1000,   #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
            l_sql     STRING                    #No.FUN-670003  -add
   DEFINE   l_no      LIKE type_file.chr3       #No.FUN-840125
   DEFINE   l_no1     LIKE type_file.chr3       #No.FUN-840125
   DEFINE   l_aac03   LIKE aac_file.aac03       #No.FUN-840125
   DEFINE   l_aac03_1 LIKE aac_file.aac03       #No.FUN-840125
#No.FUN-A10089 --begin
   DEFINE   l_chr1         LIKE type_file.chr20
   DEFINE   l_chr2         STRING
#No.FUN-A10089 --end
   DEFINE  l_npp00   LIKE npp_file.npp00 #FUN-C50113-add
   DEFINE  l_npp01   LIKE npp_file.npp01 #FUN-C50113-add
   DEFINE  l_npp011  LIKE npp_file.npp011 #FUN-C50113-add
   DEFINE  l_npp02   LIKE npp_file.npp02  #FUN-C50113-add
    OPEN WINDOW p302 AT p_row,p_col WITH FORM "afa/42f/afap302"
    ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
 #  IF g_aza.aza63 != 'Y' THEN 
    #IF g_faa.faa31 != 'Y' THEN   #No:FUN-AB0088 #No:FUN-B60140 Mark
       CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)  
    #END IF  #No:FUN-B60140 Mark
WHILE TRUE
#No.FUN-A10089 --begin
   LET l_chr2 =' '  
   DISPLAY ' ' TO chr2   
#No.FUN-A10089 --end
 
   #FUN-C50113-add-str
   IF g_fromprog = "afai104" THEN
      LET l_npp00 = "10"
      LET l_npp01 = gl_bookno
      LET l_npp011= gl_bookno2
      LET l_npp02 = gl_date1
      DISPLAY l_npp00 TO npp00
      CONSTRUCT BY NAME g_wc ON npp01,npp011,npp02

   BEFORE CONSTRUCT
      DISPLAY l_npp01 TO npp01
      DISPLAY l_npp011 TO npp011
      DISPLAY l_npp02    TO npp02  
      ON ACTION locale
             LET g_change_lang = TRUE        
             IF g_aza.aza26 = '2' THEN
                CALL p302_set_comb()
             END IF
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
   LET g_wc=g_wc,"and npp00='10' and npp01='",l_npp01,"'"
   ELSE
  #FUN-C50113--add---end
 
   CONSTRUCT BY NAME g_wc ON npp00,npp01,npp011,npp02

   BEFORE CONSTRUCT
     CALL cl_qbe_init() 
 
         ON ACTION locale
             LET g_change_lang = TRUE        #->No.FUN-570144
             IF g_aza.aza26 = '2' THEN 
                CALL p302_set_comb()
             END IF
             EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
   END CONSTRUCT
 END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p302
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211   #FUN-B40028 mark
      EXIT PROGRAM
   END IF

   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE                            #NO.FUN-570144 
   END IF
 
   LET p_plant = g_faa.faa02p 
   LET p_plant_old = p_plant      #No.FUN-570090  --add  
   LET p_bookno= g_faa.faa02b 
   LET p_bookno1= g_faa.faa02c    #No.FUN-680028 
  #TQC-C50073--mod--str
  #LET b_user  = g_user
  #LET e_user  = g_user
   LET b_user  = '0'
   LET e_user  = 'z'
  #TQC-C50073--mod--end
   IF NOT cl_null(gl_date1) THEN     #FUN-C50113
      LET gl_date = gl_date1         #FUN-C50113
   ELSE                              #FUN-C50113
      LET gl_date = g_today      
   END IF                            #FUN-C50113
   LET gl_tran = 'Y'   #FUN-660032
   LET gl_seq  = '0'
   LET g_bgjob = 'N' #NO.FUN-570144 
 
  INPUT BY NAME b_user,e_user,p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,gl_tran,gl_seq,g_bgjob #No.FUN-680028
      WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)  #No.FUN-570090  --add UNBUFFERED
 
      AFTER FIELD p_plant
         SELECT * FROM azw_file WHERE azw01 = p_plant AND azw02 = g_legal 
         IF STATUS <> 0 THEN
            CALL cl_err3("sel","azw_file",p_plant,"","agl-171","","",1)   #FUN-990031 add 
            NEXT FIELD p_plant
         END IF
        # 得出總帳 database name 
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
         IF p_plant_old != p_plant THEN 
            FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                       
               DELETE FROM tmn_file                                                                                                    
               WHERE tmn01 = p_plant_old                                                                                               
                 AND tmn02 = l_tmn02                                                                                                   
                 AND tmn06 = l_tmn06                                                                                                   
            END FOREACH            

            DELETE FROM agl_tmp_file 
            LET p_plant_old = g_plant_new      
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
                         #"  FROM ",g_dbs_new CLIPPED,"aaa_file ", #FUN-A50102
                          "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),   #FUN-A50102                                                              
                          " WHERE aaa01 = '",p_bookno,"' "                                                                          
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
              PREPARE p302_pre3 FROM l_sql                                                                                       
              DECLARE p302_cur3 CURSOR FOR p302_pre3                                                                             
              OPEN p302_cur3                                                                                                     
              FETCH p302_cur3 INTO g_cnt
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
                     #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",  #FUN-A50102                                                             
                      "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),   #FUN-A50102
                      " WHERE aaa01 = '",p_bookno1,"' "                                                                          
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
          PREPARE p302_pre3_1 FROM l_sql                                                                                       
          DECLARE p302_cur3_1 CURSOR FOR p302_pre3_1                                                                             
          OPEN p302_cur3_1                                                                                                     
          FETCH p302_cur3_1 INTO g_cnt
          IF g_cnt=0 THEN
             CALL cl_err('sel aaa',100,0)
             NEXT FIELD p_bookno1
          END IF
 
      AFTER FIELD gl_no1
         CALL s_check_no("agl",gl_no1,"","1","","",p_plant) #FUN-980094
              RETURNING li_result,g_t1 
         IF (NOT li_result) THEN
             NEXT FIELD gl_no1
         END IF
        LET l_no1 = gl_no1                                                        
        SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1               
        IF l_aac03_1 != '0' THEN                                                  
           CALL cl_err(gl_no1,'agl-991',0)                                       
           NEXT FIELD gl_no1                                                     
        END IF                                                                  
 
      AFTER FIELD b_user
         IF b_user IS NULL THEN
            NEXT FIELD b_user 
         END IF
 
      AFTER FIELD e_user
         IF e_user IS NULL THEN
            NEXT FIELD e_user 
         END IF
         IF e_user = 'Z' THEN 
            LET e_user='z'
            DISPLAY BY NAME e_user 
         END IF
 
      AFTER FIELD gl_no
         CALL s_check_no("agl",gl_no,"","1","","",p_plant) #FUN-980094
              RETURNING li_result,g_t1 
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

         IF NOT cl_null(gl_date) THEN  #TQC-9C0027 ADD  #TQC-9C0125 mod
            SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
            IF gl_date <= l_aaa07 THEN    
               CALL cl_err('','axm-164',0) NEXT FIELD gl_date
            END IF
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
              CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","anm-946",0)   #No.FUN-680028
              NEXT FIELD gl_date
             END IF
          ELSE
             CALL chk_date()
             IF g_success = 'N' THEN
                NEXT FIELD gl_date
             ELSE
                LET g_flag1='Y'  
             END IF
           END IF
 
      AFTER FIELD gl_seq  
         IF cl_null(gl_seq) OR gl_seq NOT MATCHES '[012]' THEN
            NEXT FIELD gl_seq 
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
         IF gl_no[1,g_doc_len] IS NULL or gl_no[1,g_doc_len] = ' ' THEN    
            LET l_flag='Y'
         END IF
         IF cl_null(gl_date)    THEN
            LET g_flag1='Y'   #TQC-9C0027 mod
         END IF
         IF cl_null(gl_tran)    THEN 
            LET l_flag='Y'
         END IF
         IF cl_null(gl_seq)     THEN
            LET l_flag='Y'
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
         # 得出總帳 database name
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
         LET g_plant_gl = p_plant  #No.FUN-980059
        IF NOT cl_null(gl_date) THEN   #TQC-9C0027 add
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","anm-946",0)   #No.FUN-680028
            NEXT FIELD gl_date
         END IF
        END IF                         #TQC-9C0027 add
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gl_no)
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL') RETURNING gl_no  #No.FUN-840125 #No.FUN-980059
               DISPLAY BY NAME gl_no
               NEXT FIELD gl_no
            WHEN INFIELD(gl_no1)
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL') RETURNING gl_no1 #No.FUN-840125 #No.FUN-980059
               DISPLAY BY NAME gl_no1
               NEXT FIELD gl_no1
            OTHERWISE 
               EXIT CASE
        END CASE
 
      ON ACTION get_missing_voucher_no     
         IF cl_null(gl_no) AND cl_null(gl_no1) THEN  #No.FUN-670068 add AND cl_null(gl_no1)
            NEXT FIELD gl_no             
         END IF                         
         IF cl_null(gl_date) THEN
            NEXT FIELD gl_date
         END IF
         FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                       
            DELETE FROM tmn_file                                                                                                    
            WHERE tmn01 = p_plant
              AND tmn02 = l_tmn02                                                                                                   
              AND tmn06 = l_tmn06                                                                                                   
         END FOREACH            

         DELETE FROM agl_tmp_file      
                                     
         CALL s_agl_missingno(p_plant,g_plant_new,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0)  #No.FUN-670068#FUN-B60140 g_dbs->g_plant_new
                                                    
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
         LET g_change_lang = TRUE
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
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p302
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap302"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap302','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",b_user   CLIPPED,"'",
                      " '",e_user   CLIPPED,"'",
                      " '",p_plant  CLIPPED,"'",
                      " '",p_bookno CLIPPED,"'",
                      " '",gl_no    CLIPPED,"'",
                      " '",gl_date  CLIPPED,"'",
                      " '",gl_tran  CLIPPED,"'",
                      " '",gl_seq   CLIPPED,"'",
                      " '",g_bgjob    CLIPPED,"'",
                      " '",p_bookno1  CLIPPED,"'",       #No.FUN-680028
                      " '",gl_no1   CLIPPED,"'"          #No.FUN-680028
         CALL cl_cmdat('afap302',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p302
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p302_t(l_npptype)
   DEFINE l_npptype     LIKE npp_file.npptype #No.FUN-680028
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_cmd  	LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
   DEFINE l_order	LIKE npp_file.npp01         #No.FUN-680070 VARCHAR(30)
   DEFINE l_remark	LIKE type_file.chr1000      #No.7319       #No.FUN-680070 VARCHAR(150)
   DEFINE l_name	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
   DEFINE fa_date	LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE fa_glno	LIKE faq_file.faq06         #No.FUN-680070 VARCHAR(12)
   DEFINE fa_conf	LIKE fba_file.fbaconf       #No.FUN-680070 VARCHAR(1)
   DEFINE fa_post	LIKE fba_file.fbapost       #MOD-B40042
   DEFINE fa_user	LIKE fba_file.fbauser       #No.FUN-680070 VARCHAR(10)
   DEFINE l_flag        LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_yy,l_mm     LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_msg         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
   DEFINE l_sql         STRING  #No.FUN-680028
   DEFINE g_cnt1        LIKE type_file.num10  #No.FUN-680028       #No.FUN-680070 INTEGER
   DEFINE l_npp00       LIKE npp_file.npp00   #MOD-6B0103
   DEFINE l_npp01       LIKE npp_file.npp01   #MOD-6B0103
   DEFINE l_npp011      LIKE npp_file.npp011  #MOD-AC0406 
   DEFINE l_chknpp01    LIKE npp_file.npp01   #MOD-C20099
   DEFINE l_nppsys      LIKE npp_file.nppsys  #MOD-AC0406 
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3   #MOD-6B0103
   DEFINE l_t1          LIKE type_file.chr5   #MOD-6B0103
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   DEFINE i             LIKE type_file.num10  #MOD-890293
   DEFINE l_flag2       LIKE type_file.chr1   #MOD-890293
   DEFINE l_aaa07       LIKE aaa_file.aaa07   #No.MOD-930194 add
   DEFINE l_yn          LIKE type_file.chr1   #MOD-B30368
   DEFINE l_npq01       LIKE npq_file.npq01   #TQC-BA0149
   DEFINE l_yy1         LIKE type_file.num5   #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5   #CHI-CB0004
 
 
   IF NOT cl_null(gl_date) THEN
      IF l_npptype ='0' THEN
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
#  IF g_aza.aza63 = 'Y' THEN
  ##-----No:FUN-B60140 -----
  #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
  #   IF l_npptype = '0' THEN
  #     #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",   #FUN-A50102
  #      LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102                           
  #                  "  WHERE aznn01 = '",gl_date,"' ",                               
  #                  "    AND aznn00 = '",p_bookno,"' "                            
  #      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  #      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
  #      PREPARE aznn_pre1 FROM l_sql                                                 
  #      DECLARE aznn_cs1 CURSOR FOR aznn_pre1                                        
  #      OPEN aznn_cs1                                                               
  #      FETCH aznn_cs1 INTO g_yy,g_mm
  #   ELSE
  #     #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",  #FUN-A50102                          
  #      LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102
  #                  "  WHERE aznn01 = '",gl_date,"' ",                               
  #                  "    AND aznn00 = '",p_bookno1,"' "                            
  #      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  #      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
  #      PREPARE aznn_pre2 FROM l_sql                                                 
  #      DECLARE aznn_cs2 CURSOR FOR aznn_pre2                                        
  #      OPEN aznn_cs2                                                               
  #      FETCH aznn_cs2 INTO g_yy,g_mm
  #   END IF
  #ELSE
  #   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
  #       WHERE azn01 = gl_date
  #END IF
   #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file", #FUN-B60140 mark
   LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file')  ,#No:FUN-B60140 add
               "  WHERE aznn01 = '",gl_date,"' ",
               "    AND aznn00 = '",p_bookno,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
   PREPARE aznn_pre1 FROM l_sql
   DECLARE aznn_cs1 CURSOR FOR aznn_pre1
   OPEN aznn_cs1
   FETCH aznn_cs1 INTO g_yy,g_mm
  ##-----No:FUN-B60140 END-----
   IF STATUS THEN  
       CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","anm-946",0)   #No.FUN-660116
       LET g_success = 'N'
       RETURN
   END IF
  ELSE 
       CALL chk_date()
       IF g_success = 'N' THEN
          CALL cl_err('read azn"',SQLCA.sqlcode,1)  
          RETURN
       END IF
  END IF
 
   
   LET g_success='Y'
 
  IF g_aaz.aaz81 = 'Y' THEN
  #  IF g_aza.aza63 = 'Y' THEN 
    ##-----No:FUN-B60140-----
    #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
    #   IF l_npptype = '0' THEN
    #     #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",  #FUN-A50102
    #      LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
    #                  " WHERE aba00 =  '",p_bookno,"'"
    #   ELSE
    #	    #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",  #FUN-A50102
    #        LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A5012
    #                  " WHERE aba00 =  '",p_bookno1,"'"
    #   END IF
    #
    #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    #   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    #   PREPARE aba11_pre FROM g_sql
    #   EXECUTE aba11_pre INTO l_aba11
    #ELSE 
    #  SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file 
    #    WHERE aba00 = p_bookno
    #END IF
     LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(gl_date)   #CHI-CB0004 
     #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",#FUN-B60140 mark
     LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file')  ,#No:FUN-B60140 add
                 " WHERE aba00 =  '",p_bookno,"'"
                ,"   ANd aba19 <> 'X' "  #CHI-C80041
                ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB00040
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
     PREPARE aba11_pre FROM g_sql
     EXECUTE aba11_pre INTO l_aba11
    ##-----No:FUN-B60140 END-----
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
  
  #是否自動傳票確認
 #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",  #FUN-A50102
  LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102 
              " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
  PREPARE aaz85_pre FROM g_sql
  DECLARE aaz85_cs CURSOR FOR aaz85_pre
  OPEN aaz85_cs
  FETCH aaz85_cs INTO g_aaz85
  IF STATUS THEN
     LET g_success = 'N'
     CALL cl_err('sel aaz85',STATUS,1)
     RETURN
  END IF
 
  #No+070 010424 by plum add  check 不同年月
  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   #LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",   #MOD-6B0103
IF NOT cl_null(gl_date) THEN                               #TQC-9C0125
   LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02),npp00,npp01 ",   #MOD-6B0103
             "  FROM npp_file ",   #FUN-650088      #MOD-6B0103
             " WHERE nppsys= 'FA' AND (nppglno IS NULL OR nppglno='')",
             "   AND (npp00 <> 0 OR npp00 <> 2) ",
             "   AND npptype = '",l_npptype,"' AND ",g_wc CLIPPED, #No.FUN-680028
             "   AND ( YEAR(npp02)  !=YEAR('",gl_date,"') OR ",
             "        (YEAR(npp02)   =YEAR('",gl_date,"') AND ",
             "         MONTH(npp02) !=MONTH('",gl_date,"'))) "
 
   PREPARE p302_0_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p302_0_p0',STATUS,1) RETURN END IF
   DECLARE p302_0_c0 CURSOR WITH HOLD FOR p302_0_p0
   LET l_flag='N'
   FOREACH p302_0_c0 INTO l_yy,l_mm,l_npp00,l_npp01
      IF l_npp00 != 10 AND l_npp00 != 11 AND l_npp00 != 12 THEN
         LET l_fahdmy3 = ''
         LET l_t1 = l_npp01[1,g_doc_len]
         SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file
           WHERE fahslip = l_t1
         IF l_fahdmy3 <> 'Y' THEN
            CONTINUE FOREACH
         END IF
      END IF
      LET l_flag='Y'  EXIT FOREACH
   END FOREACH
   IF l_flag ='Y' THEN
      LET g_success='N'
      CALL cl_err('err:','axr-061',1)
      RETURN
   END IF
 END IF                       #TQC-9C0125 add

   #MOD-AC0406------add--------str----------------
   LET g_sql ="SELECT DISTINCT npp01,npp011,nppsys,npp00 ",
              " FROM npp_file,npq_file ", 
              " WHERE nppsys= 'FA' AND (nppglno IS NULL OR nppglno='')",
              " AND npp01 = npq01 AND npp011=npq011",
              "   AND npp00 = npq00 ",
              "   AND npptype = '",l_npptype,"' AND npptype = npqtype AND nppsys = npqsys AND npp00=npq00 AND ",g_wc CLIPPED,  
              "   AND (npp00 <> 0 OR npp00 <> 2) "

   PREPARE p302_pre FROM g_sql
   DECLARE p302_cus CURSOR WITH HOLD FOR p302_pre
   CALL s_showmsg_init()   #MOD-AC0406 add
   LET l_yn='N'            #MOD-B30368
   FOREACH p302_cus INTO l_npp01,l_npp011,l_nppsys,l_npp00
   LET l_yn='Y'            #MOD-B30368
   IF STATUS THEN
      CALL s_errmsg('','','foreach:',STATUS,1) LET g_success = 'N' CONTINUE FOREACH  
   END IF
   #MOD-AC0406------add--------end---------------- 
   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             "  FROM npp_file,npq_file ",    #MOD-6B0103
             " WHERE nppsys= 'FA' AND (nppglno IS NULL OR nppglno='')",
             "   AND npp01 = npq01 AND npp011=npq011",
             "   AND npp00 = npq00 ",   #TQC-750011 add
             "   AND npptype = '",l_npptype,"' AND npptype = npqtype AND nppsys = npqsys AND npp00=npq00 AND ",g_wc CLIPPED, #No.FUN-680028
             "   AND (npp00 <> 0 OR npp00 <> 2) ",
             "   AND npp01 ='",l_npp01,"' AND npp011 ='",l_npp011,"' AND nppsys ='",l_nppsys,"' AND npp00 ='",l_npp00,"' " 
 
   CASE WHEN gl_seq = '0' 
        LET g_sql = g_sql CLIPPED," ORDER BY npq06,npq03,npq05,npq24,npq25"
        WHEN gl_seq = '1'
       LET g_sql = g_sql CLIPPED," ORDER BY npq01,npq06,npq03,npq05,npq24,npq25"
        WHEN gl_seq = '2'
       LET g_sql = g_sql CLIPPED," ORDER BY npq02,npq06,npq03,npq05,npq24,npq25"
        OTHERWISE      
        LET g_sql = g_sql CLIPPED," ORDER BY npq06,npq03,npq05,npq24,npq25"
   END CASE
   IF gl_tran = 'N' THEN 
      LET g_sql = g_sql CLIPPED,",npq11,npq12,npq13,npq14,npq15,npq08,npq01"
   ELSE 
     LET g_sql = g_sql CLIPPED,",npq04,npq11,npq12,npq13,npq14,npq15,npq08"           #No.TQC-960449 
   END IF
   PREPARE p302_1_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p302_1_p0',STATUS,1) 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM 
      LET g_success = 'N' END IF
   DECLARE p302_1_c0 CURSOR WITH HOLD FOR p302_1_p0
   CALL cl_outnam('afap302') RETURNING l_name
   IF l_npptype = '0' THEN
      START REPORT afap302_rep TO l_name
   ELSE
      START REPORT afap302_1_rep TO l_name
   END IF
   LET g_cnt1 = 0 #No.FUN-680028
   WHILE TRUE  
     #CALL s_showmsg_init()    #No.FUN-710028  #MOD-AC0406 mark
      CALL g_npp01.clear()   #MOD-890293
      LET g_cnt2 = 1   #MOD-890293
      FOREACH p302_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
            CALL s_errmsg('','','foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH  #No.FUN-710028
         END IF
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        
 
         IF l_npp.npp00 != 10 AND l_npp.npp00 != 11 AND l_npp.npp00 != 12 THEN
            LET l_fahdmy3 = ''
            LET l_t1 = l_npp.npp01[1,g_doc_len]
            SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file
              WHERE fahslip = l_t1
            IF l_fahdmy3 <> 'Y' THEN
               CONTINUE FOREACH
            END IF
         END IF
 
         CASE WHEN l_npp.nppsys='FA' AND l_npp.npp00=1 
                   SELECT faq02,faq06,faqconf,faquser,faqpost     #MOD-B40042 add faq_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post     
                     FROM faq_file WHERE faq01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('faq01',l_npp.npp01,'sel faq:',STATUS,1)    #No.FUN-710028
                      LET g_success='N' 
                   END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=2 
                   SELECT fas02,fas07,fasconf,fasuser,faspost     #MOD-B40042 add fas_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post
                     FROM fas_file WHERE fas01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fas01',l_npp.npp01,'sel fas:',STATUS,1)    #No.FUN-710028
                      LET g_success='N' 
                   END IF
              #FUN-BC0035---begin add
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=14
                   SELECT fbx02,fbx07,fbxconf,fbxuser,fbxpost     
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post 
                     FROM fbx_file WHERE fbx01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fbx01',l_npp.npp01,'sel fbx:',STATUS,1)    
                      LET g_success='N' 
                   END IF
              #FUN-BC0035---end add                   
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=4
                   SELECT fbe02,fbe14,fbeconf,fbeuser,fbepost     #MOD-B40042 add fbe_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post
                     FROM fbe_file WHERE fbe01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fbe01',l_npp.npp01,'sel fbe:',STATUS,1)    #No.FUN-710028
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='FA' AND (l_npp.npp00=5 OR l_npp.npp00=6)
                   SELECT fbg02,fbg08,fbgconf,fbguser,fbgpost     #MOD-B40042 add fbg_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post
                     FROM fbg_file WHERE fbg01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fbg01',l_npp.npp01,'sel fbg:',STATUS,1)    #No.FUN-710028
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=7
                   SELECT fay02,fay06,fayconf,fayuser,faypost     #MOD-B40042 add fay_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post
                     FROM fay_file WHERE fay01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fay01',l_npp.npp01,'sel fay:',STATUS,1)    #No.FUN-710028
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=8
                   SELECT fba02,fba06,fbaconf,fbauser,fbapost     #MOD-B40042 add fba_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post
                     FROM fba_file WHERE fba01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fba01',l_npp.npp01,'sel fba:',STATUS,1)    #No.FUN-710028
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=9
                   SELECT fbc02,fbc06,fbcconf,fbcuser,fbcpost     #MOD-B40042 add fbc_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post
                     FROM fbc_file WHERE fbc01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fbc01',l_npp.npp01,'sel fbc:',STATUS,1)    #No.FUN-710028
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=10
                   LET fa_date = l_npp.npp02
                  #當npp00=10時,抓取當年度/期別(fan03/fan04)fan資料筆數不可為0
                   LET g_cnt = 0
                   SELECT COUNT(*) INTO g_cnt FROM fan_file
                   #WHERE fan03=YEAR(fa_date) AND fan04=MONTH(fa_date) #MOD-990236                                                  
                    WHERE fan03=g_yy AND fan04=g_mm  #MOD-990236                    
                   IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                   IF g_cnt = 0 THEN
                      LET l_msg = YEAR(fa_date)+"/"+MONTH(fa_date)
                      CALL s_errmsg('fan04',l_msg,'','afa-927',1)    #No.FUN-710028
                      LET g_success='N'
                   END IF
                  ##-----No:FUN-B60140 Mark-----
                  ##-----No:FUN-AB0088-----
                  #IF g_faa.faa31 = 'Y' THEN 
                  #   LET g_cnt = 0
                  #   SELECT COUNT(*) INTO g_cnt FROM fbn_file
                  #    WHERE fbn03=g_yy AND fbn04=g_mm  
                  #   IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                  #   IF g_cnt = 0 THEN 
                  #      LET l_msg = YEAR(fa_date)+"/"+MONTH(fa_date)
                  #      CALL s_errmsg('fbn04',l_msg,'','afa-927',1) 
                  #      LET g_success='N'
                  #   END IF
                  #END IF
                  ##-----No:FUN-AB0088 END-----
                  ##-----No:FUN-B60140 Mark END-----

                   LET l_flag2 = 'N' 
                   FOR i = 1 TO g_npp01.getlength()
                       IF g_npp01[i] = l_npp.npp01 THEN
                          LET l_flag2 = 'Y'
                          EXIT FOR
                       END IF
                   END FOR
                   IF l_flag2 = 'N' THEN 
                      LET g_npp01[g_cnt2]=l_npp.npp01
                      LET g_cnt2 = g_cnt2 + 1
                      CALL s_chknpq(l_npp.npp01,'FA',1,'0',p_bookno)
                      IF g_success = 'N' THEN           #MOD-C20099
                         LET l_chknpp01 = l_npp.npp01   #MOD-C20099
                      END IF                            #MOD-C20099
                   #  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                     ##-----No:FUN-B60140 Mark-----
                     #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088 
                     #   CALL s_chknpq(l_npp.npp01,'FA',1,'1',p_bookno1)
                     #END IF
                     ##-----No:FUN-B60140 Mark END-----
                   END IF   #MOD-890293
                   IF l_chknpp01 = l_npp.npp01 THEN CONTINUE FOREACH END IF #MOD-C20099
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=11  #利息－資本化
                   LET fa_date = l_npp.npp02 
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=12  #保險
                   LET fa_date = l_npp.npp02
                  #-MOD-B80302-add-
                   LET l_flag2 = 'N' 
                   FOR i = 1 TO g_npp01.getlength()
                       IF g_npp01[i] = l_npp.npp01 THEN
                          LET l_flag2 = 'Y'
                          EXIT FOR
                       END IF
                   END FOR
                   IF l_flag2 = 'N' THEN 
                      LET g_npp01[g_cnt2]=l_npp.npp01
                      LET g_cnt2 = g_cnt2 + 1
                      CALL s_chknpq(l_npp.npp01,'FA',1,'0',p_bookno)
                   END IF 
                  #-MOD-B80302-end-
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=13  #減值準備              
                   SELECT fbs02,fbs04,fbsconf,fbsuser,fbspost     #MOD-B40042 add fbs_post
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post #MOD-B40042 add fa_post                       
                     FROM fbs_file WHERE fbs01=l_npp.npp01                      
                   IF STATUS THEN                                               
                      CALL s_errmsg('fbs01',l_npp.npp01,'sel fbs:',STATUS,1)    #No.FUN-710028
                      LET g_success='N'
                   END IF                                                       
              OTHERWISE CONTINUE FOREACH
         END CASE
        #IF g_success='N' THEN CONTINUE FOREACH END IF   #MOD-890061 add
         IF g_success='N' THEN EXIT FOREACH     END IF   #MOD-AC0406
         IF fa_conf='N' THEN CONTINUE FOREACH END IF
         IF fa_conf='X' THEN CONTINUE FOREACH END IF #010731 增
         IF fa_post='N' THEN CONTINUE FOREACH END IF     #MOD-B40042
         IF fa_post='X' THEN CONTINUE FOREACH END IF    #No:FUN-B60140
         IF fa_user<b_user OR fa_user>e_user THEN CONTINUE FOREACH END IF
         IF l_npptype ='0' THEN
            IF fa_glno IS NOT NULL THEN CONTINUE FOREACH END IF
         END IF
         IF l_npp.npp011=1 AND fa_date<>l_npp.npp02 THEN
            LET l_msg= "Date differ:",fa_date,'-',l_npp.npp02,
                       "  * Press any key to continue ..."
            CALL cl_msgany(19,4,l_msg)
            LET INT_FLAG = 0  ######add for prompt bug
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
         ELSE LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                             l_npq.npq12 clipped,l_npq.npq13 clipped,
                             l_npq.npq14 clipped,
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             l_npq.npq15 clipped,
                             l_npq.npq08 clipped
         END IF
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_npp.npp01 # 依單號
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 # 依日期
              OTHERWISE         LET l_order = ' '
         END CASE
         IF cl_null(l_remark) THEN LET l_remark = ' '  END IF #TQC-960092       
         INSERT INTO p302_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
             IF SQLCA.SQLCODE THEN
                 CALL cl_err3("ins","p302_tmp",l_order,l_npp.npp01,STATUS,"","l_order:",1)   #No.FUN-660136
                 LET g_success = 'N'     #FUN-570144
             END IF
         LET g_cnt1 = g_cnt1 + 1  #No.FUN-680028
      END FOREACH
      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          
  #MOD-BC0074 -- 程式搬移 begin --
      EXIT WHILE
   END WHILE
   END FOREACH
  #MOD-BC0074 -- 程式搬移  end -- 
           LET l_npq01 = NULL   #No.TQC-BA0149
         #MOD-BC0074 -- mark begin --
         #DECLARE p302_tmpcs CURSOR FOR
         #    SELECT * FROM p302_tmp
         #    ORDER BY order1,npp01,npq06,npq03,npq05,   #No.TQC-BA0149 add npp01
         #             npq24,npq25,remark1,npq01
         #MOD-BC0074 -- mark end --
         #MOD-BC0074 -- begin --
          IF g_aza.aza26 = '2' THEN
             LET g_sql = "SELECT * FROM p302_tmp",
                         " ORDER BY order1,npp01,npq06,npq03,npq05,",
                         " npq24,npq25,remark1,npq01"
          ELSE
             LET g_sql = "SELECT * FROM p302_tmp",
                         " ORDER BY order1,npq06,npq03,npq05,",
                         " npq24,npq25,remark1,npq01"
          END IF
          PREPARE p302_tmpp FROM g_sql
          DECLARE p302_tmpcs CURSOR WITH HOLD FOR p302_tmpp
         #MOD-BC0074 -- end --
          FOREACH p302_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
              IF STATUS THEN
                  CALL s_errmsg('','','order:',STATUS,1)  #No.FUN-710028
                  LET g_success='N'   #No.FUN-680028
                  EXIT FOREACH
              END IF
              IF g_success='N' THEN                                                                                                         
                 LET g_totsuccess='N'                                                                                                       
                 LET g_success="Y"                                                                                                          
              END IF                                                                                                                        
              #No.TQC-BA0149  --Begin
              IF NOT cl_null(l_npq01) AND l_npq01 = l_npp.npp01 THEN
                 LET l_npp.npp08 = 0
              END IF
              LET l_npq01 = l_npp.npp01
              #No.TQC-BA0149  --End
 
              IF l_npptype = '0' AND l_npp.npptype = '0' THEN
                 OUTPUT TO REPORT afap302_rep(l_order,l_npp.*,l_npq.*,l_remark)
              END IF
              IF l_npptype = '1' AND l_npp.npptype = '1' THEN
                 OUTPUT TO REPORT afap302_1_rep(l_order,l_npp.*,l_npq.*,l_remark)
              END IF
          END FOREACH
          IF g_totsuccess="N" THEN                                                                                                        
             LET g_success="N"                                                                                                            
          END IF 
  #MOD-BC0074 -- 程式搬移 mark begin --
  #   EXIT WHILE
  #END WHILE
  #END FOREACH  #MOD-AC0406
  #MOD-BC0074 -- 程式搬移 mark end -
   IF l_yn='Y' THEN      #MOD-B30368
      IF l_npptype = '0' THEN
         FINISH REPORT afap302_rep
      ELSE
         FINISH REPORT afap302_1_rep
      END IF            
   END IF                #MOD-B30368

   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009

   IF g_cnt1 = 0  THEN                                                          
      CALL s_errmsg('','','','aap-129',1)   #No.FUN-710028                                           
      LET g_success = 'N'                                                       
   END IF            
   DELETE FROM p302_tmp     #MOD-890293
END FUNCTION
 
REPORT afap302_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01         #No.FUN-680070 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5  	    # 傳票項次     #No.FUN-680070 SMALLINT
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6      #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
  DEFINE l_no           LIKE fcx_file.fcx01         #No:9057
  DEFINE l_no1          STRING                      #No.TQC-9B0145
  DEFINE l_remark       LIKE type_file.chr1000      #No.7319       #No.FUN-680070 VARCHAR(150)
  DEFINE l_aba06        LIKE aba_file.aba06         #No.FUN-680070 CHAR(02) #MOD-B60111 mod l_p1 -> aba06
  DEFINE l_number       LIKE type_file.num5         #No.FUN-680070 SMALLINT #MOD-B60111 mod l_p2 -> number
  DEFINE l_no2          LIKE type_file.chr1         #No.FUN-680070 CHAR(01) #MOD-B60111 mod l_p3 -> no
  DEFINE l_yes          LIKE type_file.chr1         #No.FUN-680070 CHAR(01) #MOD-B60111 mod l_p4 -> yes
  DEFINE li_result      LIKE type_file.num5         #No.FUN-560190 #No.FUN-680070 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01         #No.FUN-570090  --add    
  DEFINE l_flag1        LIKE type_file.chr1         #No.FUN-570090  --add          #No.FUN-680070 VARCHAR(1)
  DEFINE l_npp08        LIKE npp_file.npp08         #MOD-A80017 Add 
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021  
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   BEFORE GROUP OF l_order
    IF g_flag1 = 'Y' THEN
       LET gl_date = l_npp.npp02 
       SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=gl_date
    END IF
 
   # 得出總帳 database name
    LET g_plant_new= p_plant  # 工廠編號                                                                                            
    CALL s_getdbs()                                                                                                                 
    LET g_dbs_gl=g_dbs_new CLIPPED                                                                                                  
 
   LET l_flag1='N'          
   LET l_missingno = NULL  
   LET g_j=g_j+1          
   SELECT tc_tmp02 INTO l_missingno    
     FROM agl_tmp_file                 
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'     
      AND tc_tmp03=p_bookno #No.FUN-680028
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                       
      LET gl_no=l_missingno                
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no      
                                AND tc_tmp03 = p_bookno #No.FUN-680028
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
  #No.FUN-CB0096 ---start--- Add
  #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",g_faa.faa02b)              #MOD-B50121 mark
   CALL s_auto_assign_no("agl",gl_no[1,g_doc_len],gl_date,"1","","",p_plant,"",g_faa.faa02b) #MOD-B50121
        RETURNING li_result,gl_no
   END IF   #No.FUN-CB0096
     IF g_bgjob = 'N' THEN    #FUN-570144 BY 050919
         MESSAGE "Insert G/L voucher no:",gl_no 
         CALL ui.Interface.refresh()
     END IF
     PRINT "Insert aba:",g_faa.faa02b,' ',gl_no,' From:',l_order
     END IF  #No.FUN-570090  -add     
    #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",   #FUN-A50102
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102 
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",   #MOD-6C0182
                        " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,",  #TQC-A10060  add abaoriu,abaorig
                        " abasign,abadays,abaprit,abasmax,abasseq,abamodu,aba24,aba11,abalegal,aba21)",     #FUN-840211 add aba11   #MOD-770150 #FUN-980003 add  #FUN-A10006 add aba21
                    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #TQC-A10060  add ?,?   #FUN-840211 add ?  #MOD-6C0182   #MOD-770150 #FUN-980003 add  #FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
     PREPARE p302_1_p4 FROM g_sql
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     CALL s_get_doc_no(gl_no) RETURNING g_aba01t     #No.FUN-560190
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

     LET l_aba06  = 'FA'    #MOD-B60111 mod l_p1 -> aba06
     LET l_number = 0       #MOD-B60111 mod l_p2 -> number
     LET l_no2    = 'N'     #MOD-B60111 mod l_p3 -> no
     LET l_yes    = 'Y'     #MOD-B60111 mod l_p4 -> yes
     LET g_zero='0'   #MOD-6C0182
     EXECUTE p302_1_p4 USING g_faa.faa02b,gl_no,gl_date,g_yy,g_mm,g_today,
                            #l_p1,l_order,l_p2,l_p2,l_p3,l_p3,g_zero,g_aba.abamksg,   #MOD-6C0182              #MOD-B60111 mark
                             l_aba06,l_order,l_number,l_number,l_no2,l_no2,g_zero,g_aba.abamksg,   #MOD-6C0182 #MOD-B60111
                            #l_p3,l_p2,l_p4,g_user,g_grup,g_today,g_user,g_grup,g_aba.abasign,  #TQC-A10060  add g_user,g_grup       #MOD-B60111 mark
                             l_no2,l_number,l_yes,g_user,g_grup,g_today,g_user,g_grup,g_aba.abasign,  #TQC-A10060  add g_user,g_grup #MOD-B60111
                            #g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,     #MOD-B60111 mark
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_number, #MOD-B60111
                             g_user,g_user,g_aba.aba11,#No.FUN-840211 add aba11   #MOD-770150
                             g_legal,l_npp.npp08   #FUN-980003 add  FUN-A10006 add npp08
     IF STATUS THEN
         CALL cl_err('ins aba:',STATUS,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570090  --add  
                            AND tmn06 = p_bookno  #No.FUN-680028
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF   #TQC-9C0027 add 
     CASE WHEN l_npp.nppsys='FA' AND l_npp.npp00=1
               UPDATE faq_file SET faq06=gl_no,faq07=gl_date
                WHERE faq01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","faq_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd faq:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=2
               UPDATE fas_file SET fas07=gl_no,fas08=gl_date
                WHERE fas01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fas_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fas:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          #FUN-BC0035---begin add
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=14
               UPDATE fbx_file SET fbx07=gl_no,fbx08=gl_date
                WHERE fbx01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbx_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbx:",1) 
                  LET g_success = 'N'   
               END IF
          #FUN-BC0035---end add                
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=4
               UPDATE fbe_file SET fbe14=gl_no,fbe15=gl_date
                WHERE fbe01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbe_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbe:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND (l_npp.npp00=5 OR l_npp.npp00=6)
               UPDATE fbg_file SET fbg08=gl_no,fbg09=gl_date
                WHERE fbg01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbg_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbg:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=7
               UPDATE fay_file SET fay06=gl_no,fay07=gl_date
                WHERE fay01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fay_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fay:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=8
               UPDATE fba_file SET fba06=gl_no,fba07=gl_date
                WHERE fba01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fba_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fba:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=9
               UPDATE fbc_file SET fbc06=gl_no,fbc07=gl_date
                WHERE fbc01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbc_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbc:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=11   #利息-資本化
               LET l_no1= l_npq.npq01[1,10]       #No.TQC-9B0145  #No.TQC-9C0034
               LET l_no = l_no1.trim()       #No.TQC-9B0145
               LET l_no = l_no CLIPPED       #MOD-AC0277
               UPDATE fcx_file SET fcx11=gl_no,fcx12=gl_date
                WHERE fcx01 = l_no           #No:9057
                  AND fcx02 = YEAR(l_npp.npp02)
                  AND fcx03 = MONTH(l_npp.npp02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fcx_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fcx:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=12  #保險
               UPDATE fdd_file SET fdd06=gl_no,fdd07=gl_date
                WHERE fdd01 = l_npq.npq23
                  AND fdd03 = YEAR(l_npp.npp02)
                  AND fdd033 = MONTH(l_npp.npp02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fdd_file",l_npq.npq23,"",SQLCA.sqlcode,"","upd fdd:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=13  #減值準備                  
               UPDATE fbs_file SET fbs04 = gl_no,
                                   fbs05 = gl_date
                WHERE fbs01 = l_npq.npq01                                       
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                    
                  CALL cl_err3("upd","fbs_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbs:",1)   #No.FUN-660136
                  LET g_success = 'N' 
               END IF                                                           
          OTHERWISE EXIT CASE 
     END CASE
     UPDATE npp_file SET npp03 = gl_date, nppglno= gl_no ,
                         npp06 = p_plant, npp07  = p_bookno     #no.7277
      WHERE npp01 = l_npp.npp01
        AND npp011= l_npp.npp011
        AND npp00 = l_npp.npp00
        AND nppsys= l_npp.nppsys
        AND npptype='0' #No.FUN-680028
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   #No.FUN-660136
        LET g_success = 'N'
     END IF
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN    #FUN-570144 BY 050919
         MESSAGE "Seq:",l_seq 
         CALL ui.Interface.refresh()
     END IF
    #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",   #FUN-A50102
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'),   #FUN-A50102 
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,",                             #FUN-810069
                        " abb24,abb25,", 
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37,",
                        "abblegal ", #FUN-980003 add
                        " )",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?",                         #FUN-810069
                 "       ,?,?,?,?,?,?,? ",  #FUN-5C0015 BY GILL 
                 "       ,?) "              #FUN-980003 add 
 
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
     PREPARE p302_1_p5 FROM g_sql
     EXECUTE p302_1_p5 USING 
                g_faa.faa02b,gl_no,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,                                                           #FUN-810069
                l_npq.npq24,l_npq.npq25,
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,
                g_legal    #FUN-980003 add
 
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',STATUS,1) LET g_success = 'N'
     END IF
 
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
     #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08=?,aba09=?",  #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "   SET aba08=?,aba09=?",   #FUN-A50102
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p302_1_p6 FROM g_sql
      EXECUTE p302_1_p6 USING l_debit,l_credit,l_npp08,gl_no,g_faa.faa02b       #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',g_faa.faa02b,gl_no,gl_date,l_no2,'',TRUE)   #No.TQC-B70021 
      IF g_aaz85 = 'Y' THEN 
            #若有立沖帳管理就不做自動確認
           #FUN-A50102--mod--str--
           #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
            LET g_sql = "SELECT COUNT(*) ",
                        "  FROM ",cl_get_target_table(g_plant_new,'abb_file'),
                        "      ,",cl_get_target_table(g_plant_new,'aag_file'),
           #FUN-A50102--mod--end
                        " WHERE abb01 = '",gl_no,"'",
                        "   AND abb00 = '",g_faa.faa02b,"'",
                        "   AND abb03 = aag01  ",
                        "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
            PREPARE count_pre FROM g_sql
            DECLARE count_cs CURSOR FOR count_pre
            OPEN count_cs 
            FETCH count_cs INTO g_cnt
            CLOSE count_cs
            IF g_cnt = 0 THEN
               IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
               IF g_aba.abamksg='N' THEN                       #MOD-850183
                  LET g_aba.aba20='1' 
                  LET g_aba.aba19 = 'Y'
#No.TQC-B70021 --begin 
            CALL s_chktic (g_faa.faa02b,gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end  
                 #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",  #FUN-A50102
                  LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                              "    SET abamksg = ? ,",
                                     " abasign = ? ,", 
                                     " aba18   = ? ,",
                                     " aba19   = ? ,",
                                     " aba20   = ? ,",              #MOD-A80136 
                                     " aba37   = ?  ",              #MOD-A80136
                               " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
                  PREPARE upd_aba19 FROM g_sql
                  EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                          g_aba.aba18  ,g_aba.aba19,
                                          g_aba.aba20  ,
                                          g_user,                    #MOD-A80136
                                          gl_no        ,g_faa.faa02b
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
                  END IF
               END IF    
            END IF
      END IF     
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
     #LET gl_no[g_no_sp,g_no_ep]=''   #MOD-740019  #MOD-CC0100 mark
      LET gl_no[g_no_sp-1,g_no_ep]=''              #MOD-CC0100 add
END REPORT
 
FUNCTION p302_create_tmp()   #MOD-690088   #MOD-890293取消mark
 
 DROP TABLE p302_tmp;
 
 SELECT chr30 order1, npp_file.*,npq_file.*,
        chr1000 remark1
   FROM npp_file,npq_file,type_file
  WHERE npp01 = npq01 AND npp01 = '@@@@'
    AND 1=0
   INTO TEMP p302_tmp
 IF SQLCA.SQLCODE THEN
    LET g_success='N'
    CALL cl_err3("ins","p302_tmp","","",SQLCA.sqlcode,"","create p302_tmp",0)   #No.FUN-660136
 END IF
 DELETE FROM p302_tmp WHERE 1=1
    LET gl_no_b=''
    LET gl_no_e=''
#IF g_aza.aza63 = 'Y' THEN   #MOD-890293
##-----No:FUN-B60140 Mark-----
#IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
#   LET gl_no_b1='' #No.FUN-680028
#   LET gl_no_e1='' #No.FUN-680028
#END IF  #MOD-890293
##-----No:FUN-B60140 Mark END-----
 
END FUNCTION
 
FUNCTION p302_set_comb()                                                        
  DEFINE comb_value STRING                                                      
  DEFINE comb_item  STRING                                                      
                                                                                
    LET comb_value = '1,2,4,5,6,7,8,9,10,11,12,13,14' #FUN-BC0035 add 14
    CALL cl_getmsg('afa-377',g_lang) RETURNING comb_item
 
    CALL cl_set_combo_items('npp00',comb_value,comb_item)     
END FUNCTION
 
REPORT afap302_1_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01       #No.FUN-680070 VARCHAR(30)
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5  	# 傳票項次       #No.FUN-680070 SMALLINT
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
  DEFINE l_no           LIKE fcx_file.fcx01     #No:9057
  DEFINE l_remark       LIKE type_file.chr1000  #No.7319       #No.FUN-680070 VARCHAR(150)
  DEFINE l_aba06_1      LIKE aba_file.aba06         #No.FUN-680070 CHAR(02) #MOD-B60111 mod l_p1 -> aba06
  DEFINE l_number_1     LIKE type_file.num5         #No.FUN-680070 SMALLINT #MOD-B60111 mod l_p2 -> number
  DEFINE l_no_1         LIKE type_file.chr1         #No.FUN-680070 CHAR(01) #MOD-B60111 mod l_p3 -> no
  DEFINE l_yes_1        LIKE type_file.chr1         #No.FUN-680070 CHAR(01) #MOD-B60111 mod l_p4 -> yes
  DEFINE li_result      LIKE type_file.num5     #No.FUN-560190       #No.FUN-680070 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01     #No.FUN-570090  --add    
  DEFINE l_flag1        LIKE type_file.chr1     #No.FUN-570090  --add          #No.FUN-680070 VARCHAR(1)
  DEFINE l_npp08        LIKE npp_file.npp08     #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021 
   
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   BEFORE GROUP OF l_order
   IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF   #TQC-9C0027 add
 
   # 得出總帳 database name
    LET g_plant_new= p_plant  # 工廠編號                                                                                            
    CALL s_getdbs()                                                                                                                 
    LET g_dbs_gl=g_dbs_new CLIPPED                                                                                                  
 
   LET l_flag1='N'          
   LET l_missingno = NULL  
   LET g_j=g_j+1          
   SELECT tc_tmp02 INTO l_missingno    
     FROM agl_tmp_file                 
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'     
      AND tc_tmp03=p_bookno1 #No.FUN-680028
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                       
      LET gl_no1=l_missingno                
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1      
                                AND tc_tmp03 = p_bookno1 #No.FUN-680028
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
  #No.FUN-CB0096 ---start--- Add
  #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",p_plant,"",g_faa.faa02c)              #MOD-B50121 mark
   CALL s_auto_assign_no("agl",gl_no1[1,g_doc_len],gl_date,"1","","",p_plant,"",g_faa.faa02c) #MOD-B50121
        RETURNING li_result,gl_no1
   END IF   #No.FUN-CB0096   Add 
     IF g_bgjob = 'N' THEN    #FUN-570144 BY 050919
         MESSAGE "Insert G/L voucher no:",gl_no1 
         CALL ui.Interface.refresh()
     END IF
     PRINT "Insert aba:",g_faa.faa02c,' ',gl_no1,' From:',l_order
     END IF  #No.FUN-570090  -add     
    #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",    #UFN-A50102
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102 
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",   #MOD-6C0182
                        " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,",     #TQC-A10060  add abaoriu,abaorig
                        " abasign,abadays,abaprit,abasmax,abasseq,abamodu,aba24,aba11,abalegal,aba21)",     #FUN-840211 add aba11   #MOD-770150 #FUN-980003 add  #FUN-A10006 add aba21
                    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" #TQC-A10060 add ?,? #FUN-840211 add ?   #MOD-6C0182   #MOD-770150 #FUN-980003 add  #FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
     PREPARE p302_1_p4_1 FROM g_sql
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no1
     CALL s_get_doc_no(gl_no1) RETURNING g_aba01t     #No.FUN-560190
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

     LET l_aba06_1  = 'FA'    #MOD-B60111 mod l_p1 -> aba06
     LET l_number_1 = 0       #MOD-B60111 mod l_p2 -> number
     LET l_no_1     = 'N'     #MOD-B60111 mod l_p3 -> no
     LET l_yes_1    = 'Y'     #MOD-B60111 mod l_p4 -> yes
     LET g_zero='0'   #MOD-6C0182
     EXECUTE p302_1_p4_1 USING g_faa.faa02c,gl_no1,gl_date,g_yy,g_mm,g_today,
                            #l_p1,l_order,l_p2,l_p2,l_p3,l_p3,g_zero,g_aba.abamksg,   #MOD-6C0182                      #MOD-B60111 mark
                             l_aba06_1,l_order,l_number_1,l_number_1,l_no_1,l_no_1,g_zero,g_aba.abamksg,   #MOD-6C0182 #MOD-B60111
                            #l_p3,l_p2,l_p4,g_user,g_grup,g_today,g_user,g_grup,g_aba.abasign,   #TQC-A10060  add g_user,g_grup            #MOD-B60111 mark
                             l_no_1,l_number_1,l_yes_1,g_user,g_grup,g_today,g_user,g_grup,g_aba.abasign,   #TQC-A10060  add g_user,g_grup #MOD-B60111
                            #g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,       #MOD-B60111 mark
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_number_1, #MOD-B60111
                             g_user,g_user,g_aba.aba11,   #No.FUN-840211 add aba11   #MOD-770150
                             g_legal,l_npp.npp08   #FUN-980003 add  FUN-A10006 add npp08
     IF STATUS THEN
         CALL cl_err('ins aba:',STATUS,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1  #No.FUN-570090  --add  
                            AND tmn06 = p_bookno1  #No.FUN-680028
     IF gl_no_b1 IS NULL THEN LET gl_no_b1 = gl_no1 END IF
     LET gl_no_e1 = gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF   #TQC-9C0027 add 
     UPDATE npp_file SET npp03 = gl_date, nppglno= gl_no1,
                         npp06 = p_plant, npp07  = p_bookno1    #no.7277
      WHERE npp01 = l_npp.npp01
        AND npp011= l_npp.npp011
        AND npp00 = l_npp.npp00
        AND nppsys= l_npp.nppsys
        AND npptype='1' #No.FUN-680028
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   #No.FUN-660136
        LET g_success = 'N'
     END IF
   AFTER GROUP OF l_remark 
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN    #FUN-570144 BY 050919
         MESSAGE "Seq:",l_seq 
         CALL ui.Interface.refresh()
     END IF
    #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",  #FUN-A50102
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'),   #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,",                       #FUN-810069
                        " abb24,abb25,",
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37,",
                        "abblegal ",  #FUN-980003 add
                        " )",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?",                   #FUN-810069
                 "       ,?,?,?,?,?,?,? ", #FUN-5C0015 BY GILL
                 "       ,?) "             #FUN-980003 add
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
     PREPARE p302_1_p5_1 FROM g_sql
     EXECUTE p302_1_p5_1 USING 
                g_faa.faa02c,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,                                                     #FUN-810069
                l_npq.npq24,l_npq.npq25,
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,
                g_legal #FUN-980003 add
 
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',STATUS,1) LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
     #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08=?,aba09=?",  #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "   SET aba08=?,aba09=?",   #FUN-A50102
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p302_1_p6_1 FROM g_sql
      EXECUTE p302_1_p6_1 USING l_debit,l_credit,l_npp08,gl_no1,g_faa.faa02c  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',g_faa.faa02c,gl_no1,gl_date,l_no_1,'',TRUE)   #No.TQC-B70021

      IF g_aaz85 = 'Y' THEN 
            #若有立沖帳管理就不做自動確認
           #FUN-A50102--mod--str--
           #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
            LET g_sql = "SELECT COUNT(*) ",
                        "  FROM ",cl_get_target_table(g_plant_new,'abb_file'),
                        "      ,",cl_get_target_table(g_plant_new,'aag_file'),
           #FUN-A50102--mod--end
                        " WHERE abb01 = '",gl_no1,"'",
                        "   AND abb00 = '",g_faa.faa02c,"'",
                        "   AND abb03 = aag01  ",
                        "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
            PREPARE count_pre2 FROM g_sql
            DECLARE count_cs2 CURSOR FOR count_pre2
            OPEN count_cs2 
            FETCH count_cs2 INTO g_cnt
            CLOSE count_cs2
            IF g_cnt = 0 THEN
               IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
               IF g_aba.abamksg='N' THEN                       #MOD-850183
                  LET g_aba.aba20='1' 
                  LET g_aba.aba19 = 'Y'
#No.TQC-B70021 --begin 
            CALL s_chktic (g_faa.faa02c,gl_no1) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end
                 #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",  #FUN-A50102
                  LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                              "    SET abamksg = ? ,",
                                     " abasign = ? ,", 
                                     " aba18   = ? ,",
                                     " aba19   = ? ,",
                                     " aba20   = ? ,",              #MOD-A80136 
                                     " aba37   = ?  ",              #MOD-A80136
                               " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
                  PREPARE upd_aba19_2 FROM g_sql
                  EXECUTE upd_aba19_2 USING g_aba.abamksg,g_aba.abasign,
                                          g_aba.aba18  ,g_aba.aba19,
                                          g_aba.aba20  ,
                                          g_user,                    #MOD-A80136
                                          gl_no1        ,g_faa.faa02c
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
                  END IF
               END IF    
            END IF
      END IF     
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
     #LET gl_no1[4,12]=''                       #MOD-CC0100 mark
      LET gl_no1[g_no_sp-1,g_no_ep]=''          #MOD-CC0100 add
END REPORT

FUNCTION chk_date()  #傳票日期抓npp02時要判斷的日期
  DEFINE l_npp            RECORD LIKE npp_file.*
  DEFINE l_npq            RECORD LIKE npq_file.*
  DEFINE l_aaa07  LIKE aaa_file.aaa07

  LET g_sql="SELECT npp_file.*,npq_file.* ",
            "  FROM npp_file,npq_file",
            " WHERE nppsys= 'FA' AND nppglno IS NULL",
            "   AND npp01 = npq01 AND npp011=npq011",
            "   AND npp00 = npq00 ",     
            "   AND ",g_wc CLIPPED,
            "   AND nppsys=npqsys "
   PREPARE p400_1_p10 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p400_1_p10',STATUS,1)
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
      EXIT PROGRAM
   END IF
   DECLARE p400_1_c10 CURSOR WITH HOLD FOR p400_1_p10
   FOREACH p400_1_c10 INTO l_npp.*,l_npq.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      SELECT aaa07 INTO l_aaa07 FROM aaa_file
         WHERE aaa01 = p_bookno
      IF l_npp.npp02 <= l_aaa07 THEN
         CALL cl_err(l_npp.npp01,'axm-164',0)
         LET g_success = 'N'
      END IF
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
         WHERE azn01 = l_npp.npp02
      IF STATUS THEN
         CALL cl_err3("sel","azn_file",l_npp.npp02,"",SQLCA.sqlcode,"","read azn",0)
         LET g_success = 'N'
      END IF
   END FOREACH
END FUNCTION
#No.FUN-9C0077 程式精簡
#CHI-AC0010
