# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: aapp800.4gl
# Descriptions...: 外購系統傳票拋轉總帳
# Date & Author..: 98/06/05 By Danny
# Modify.........: NO:7803 03/08/29 By Nicola :傳票單別開窗查詢
# Modify.........: No.8657 03/11/05 By Kitty 當aaz85='N'時,aba19為會null
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-540153 05/05/06 By ching 變數清空
# Modify ........: No.MOD-540153 05/05/06 By ching 變數清空
# Modify ........: No.FUN-550030 05/05/23 By wujie 單據編號加大 
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify ........: No.FUN-570090 05/07/29 By Will 增加取得傳票缺號號碼的功能 
# Modify.........: No.MOD-5C0083 05/12/15 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-5C0015 060102 BY GILL 多 INSERT 異動碼5~10, 關係人
# Modify.........: No.FUN-570112 06/02/24 By yiting 批次背景執行
# Modify.........: No.MOD-640018 06/04/13 By Smapmin 加入alc02<>0的條件
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-660141 06/07/07 By wujie 帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670060 06/08/01 By wujie 修改背景執行時錯誤的地方
# Modify.........: No.FUN-680029 06/08/22 By Rayven 新增多帳套功能
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-710014 07/01/11 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-730064 07/03/28 By atsea 會計科目加帳套
# Modify.........: No.TQC-750011 07/06/22 By rainy npp_file,npq_file 加 npp00 = npq00
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 需簽核單別不可自動確認
# Modify.........: No.FUN-810069 08/02/25 By douzh 項目預算取消abb15的管控
# Modify.........: No.MOD-840107 08/04/14 By Smapmin 檢核傳票編號是否有重複時,參數帶錯
# Modify.........: No.MOD-850183 08/05/22 By Sarah 將IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF這行mark掉
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990069 09/09/07 By mike 拋轉傳票時,未檢查總帳是否已關帳.    
# Modify.........: No.FUN-980094 09/09/10 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No.FUN-9B0070 09/11/10 By wujie 5.2SQL转标准语法
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9C0299 09/12/21 By baofei abaoriu,abaorig給值
# Modify.........: No:TQC-A10060 10/01/07 By wuxj   INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10006 10/01/11 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No:FUN-A10089 10/01/19 By wujie  增加显示选取的缺号结果
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70005 10/07/12 By Summer 增加aza63判斷使用s_azmm
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80071 10/08/10 By Dido 單別區間調整用變數方式抓取 
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24/aba37 預設值 
# Modify.........: No:CHI-AA0015 10/11/05 By Summer alc02原為vachar(1)改為Number(5) 
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file  
# Modify.........: No:TQC-BA0148 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:MOD-BC0106 11/12/15 By Polly 修改當aapt711時，ap_date改抓 ala86
# Modify.........: No:CHI-CB0004 12/11/09 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:MOD-CB0120 13/02/04 By jt_chen 調整累加值變數預設，已正確的補到缺號。
# Modify.........: No:MOD-CC0079 13/02/20 By Vampire 還原 axr-061 並 LET g_success = 'N'
# Modify.........: No.FUN-D40105 13/08/22 by yangtt 產生記錄檔報錯修改

IMPORT os   #No.FUN-9C0009  add by dxfwo 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_dbs_gl 	STRING          #No.FUN-550030
DEFINE g_plant_gl 	STRING          #No.FUN-980059
#DEFINE gl_no	 VARCHAR(12)	# 傳票單號
#DEFINE gl_no	 VARCHAR(16)	#No.FUN-550030 #FUN-660117 remark
DEFINE gl_no		LIKE abb_file.abb01            #FUN-660117
DEFINE gl_no1           LIKE aba_file.aba01                #No.FUN-680029
#DEFINE gl_no_b,gl_no_e VARCHAR(12)	# Generated 傳票單號
DEFINE gl_no_b,gl_no_e  LIKE abb_file.abb01  #No.FUN-690028 VARCHAR(16)	#No.FUN-550030  
DEFINE gl_no_b1,gl_no_e1 LIKE aba_file.aba01    #No.FUN-680029
#DEFINE p_plant          VARCHAR(12)	    #FUN-660117 remark
DEFINE p_plant          LIKE azp_file.azp01 #FUN-660117	
#DEFINE p_plant_old      VARCHAR(12)        #No.FUN-570090  --add  #FUN-660117 remark 
DEFINE p_plant_old      LIKE azp_file.azp01                     #FUN-660117  
#DEFINE splant           VARCHAR(12)	     #FUN-660117 remark
DEFINE splant           LIKE azp_file.azp01  #FUN-660117	
#DEFINE p_bookno         VARCHAR(02)	     #FUN-660117 remark
DEFINE p_bookno         LIKE apz_file.apz02b #FUN-660117	
DEFINE p_bookno1        LIKE apz_file.apz02c    #No.FUN-680029
DEFINE g_npptype        LIKE npp_file.npptype   #No.FUN-680029
DEFINE g_source         LIKE type_file.chr1    #No.FUN-690028 VARCHAR(01)	
DEFINE gl_date		LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE gl_tran          LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE gl_seq    	LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)         # 傳票區分項目
DEFINE g_yy,g_mm	LIKE type_file.num5    #No.FUN-690028 SMALLINT
#DEFINE g_aba01t         VARCHAR(5)         #No.FUN-550030 #FUN-660117 remark
DEFINE g_aba01t         LIKE aac_file.aac01             #FUN-660117
DEFINE l_flag           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE x1               LIKE type_file.chr20   #No.FUN-690028 VARCHAR(16)
#------for ora0改-------------------
#DEFINE g_system         VARCHAR(2)              #FUN-660117 remark
#DEFINE g_system         LIKE aba_file.aba02   #FUN-660117
DEFINE g_system         LIKE aba_file.aba06   #FUN-670060
DEFINE g_zero           LIKE type_file.num20_6#No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_zero1          LIKE type_file.chr1   #No.FUN-690028 VARCHAR(1)         #No:8657
DEFINE g_N              LIKE type_file.chr1   #No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1   #No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_aaz85          LIKE aaz_file.aaz85, #傳票是否自動確認 no.3432
       g_change_lang    LIKE type_file.chr1          #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_j             LIKE type_file.num5     #No.FUN-690028 SMALLINT   #No.FUN-570090
#DEFINE   l_dbs           VARCHAR(21)   #FUN-570112  #FUN-660117 remark
DEFINE   l_dbs           LIKE azp_file.azp03      #FUN-660117
 
#No.FUN-570090  --begin                                                                                                             
DEFINE g_tc_tmp        DYNAMIC ARRAY OF RECORD                                                                                      
           tc_tmp00      LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1),                                                                                                   
           tc_tmp01      LIKE type_file.num5,    #No.FUN-690028 SMALLINT,                                                                                                  
           tc_tmp02      LIKE type_file.chr20    #No.FUN-690028 VARCHAR(20)                                                                                                   
                       END RECORD                                                                                                   
#No.FUN-570090  --end 
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add
DEFINE l_time_t LIKE type_file.chr8    #FUN-D40105 add
 
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0055
DEFINE ls_date         STRING    #->No.FUN-570112
DEFINE l_tmn02         LIKE tmn_file.tmn02     #No.FUN-670068                                                                       
DEFINE l_tmn06         LIKE tmn_file.tmn06     #No.FUN-670068 
 
     OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET splant   = ARG_VAL(2)             #資料來源營運中心
   LET x1       = ARG_VAL(3)             #資料來源
   LET p_plant  = ARG_VAL(4)             #總帳營運中心編號
   LET p_bookno = ARG_VAL(5)             #總帳帳別編號
   LET gl_no    = ARG_VAL(6)             #總帳傳票單別
   LET ls_date  = ARG_VAL(7)
   LET gl_date  = cl_batch_bg_date_convert(ls_date)   #總帳傳票日期
   LET gl_tran  = ARG_VAL(8)             #拋轉摘要
   LET gl_seq   = ARG_VAL(9)             #傳票匯總方式
   LET g_bgjob = ARG_VAL(10)    #背景作業
   LET p_bookno1 = ARG_VAL(11)  #No.FUN-680029
   LET gl_no1    = ARG_VAL(12)  #No.FUN-680029
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570112 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
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
 
   #No.FUN-570090  --begin       
   DROP TABLE agl_tmp_file       
# No.FUN-690028 --start--
   CREATE TEMP TABLE agl_tmp_file(          
    tc_tmp00    LIKE type_file.chr1 NOT NULL,  
    tc_tmp01    LIKE type_file.num5,     
    tc_tmp02    LIKE type_file.chr20, 
    tc_tmp03    LIKE apz_file.apz02b)
# No.FUN-690028 ---end---
   IF STATUS THEN
      CALL cl_err('create tmp',STATUS,0)
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      EXIT PROGRAM
   END IF 
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-680029  add tc_tmp03
   IF STATUS THEN
      CALL cl_err('create index',STATUS,0)
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      EXIT PROGRAM
   END IF 
   #No.FUN-570090  --end  
 
#No.FUN-670068--begin                                                                                                               
    DECLARE tmn_del CURSOR FOR                                                                                                      
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'                                                               
#No.FUN-670068--end  
#NO.FUN-570112 MARK----------
#    OPEN WINDOW p800 AT p_row,p_col WITH FORM "aap/42f/aapp800" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    CALL cl_opmsg('z')
#    CALL p800()
#    IF INT_FLAG
#       THEN LET INT_FLAG = 0
#       ELSE CALL cl_end(18,20)
#    END IF
#    CLOSE WINDOW p800
#NO.FUN-570112 MARK---

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0055

   LET g_j = 0  #MOD-CB0120 add
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p800_ask()               # Ask for first_flag, data range or exist
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL p800_create_tmp()
            LET g_apz.apz02b = p_bookno  # 得帳別
            LET g_apz.apz02c = p_bookno1 #No.FUN-680029
            BEGIN WORK
            CALL p800_t('0')  #No.FUN-680029 add '0'
            #No.FUN-680029 --start--
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p800_t('1')
            END IF
            #No.FUN-680029 --end--
            CALL s_showmsg()                       #NO.FUN-710014
            IF g_success = 'Y' THEN
               COMMIT WORK
#               CALL s_m_prtgl(g_dbs_gl,g_apz.apz02b,gl_no_b,gl_no_e)  #FUN-990069
               CALL s_m_prtgl(g_plant_gl,g_apz.apz02b,gl_no_b,gl_no_e)  #FUN-990069
               #No.FUN-680029 --start--
               IF g_aza.aza63 = 'Y' THEN
#                  CALL s_m_prtgl(g_dbs_gl,g_apz.apz02c,gl_no_b1,gl_no_e1)#FUN-990069
                  CALL s_m_prtgl(g_plant_gl,g_apz.apz02c,gl_no_b1,gl_no_e1)#FUN-990069
               END IF
               #No.FUN-680029 --end--
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p800
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = splant
         DATABASE l_dbs
    #     CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
         CALL cl_ins_del_sid(1,splant) #FUN-980030   #FUN-990069
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         LET g_source = x1[1,1]
 
         LET g_success = 'Y'
         CALL p800_create_tmp()
         LET g_apz.apz02b = p_bookno  # 得帳別
         LET g_apz.apz02c = p_bookno1    #No.FUN-680029
         BEGIN WORK
         CALL p800_t('0')  #No.FUN-680029 add '0'
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL p800_t('1')
         END IF
         #No.FUN-680029 --end--
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570112 ---end---
    #No.FUN-570090  --start        
#No.FUN-670068--begin                                                                                                               
    FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                            
       DELETE FROM tmn_file                                                                                                         
       WHERE tmn01 = p_plant                                                                                                        
         AND tmn02 = l_tmn02                                                                                                        
         AND tmn06 = l_tmn06                                                                                                        
    END FOREACH                                                                                                                     
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#NO.FUN-570112 MARK------
#FUNCTION p800()
 
#WHILE TRUE
#   LET g_action_choice = ""
 
#   CALL p800_ask()	# Ask for first_flag, data range or exist_no
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CALL cl_show_fld_cont()   #FUN-550037(smin)
#      CONTINUE WHILE
#   END IF
#   IF INT_FLAG THEN RETURN END IF
#   IF cl_sure(20,20) THEN 
#      CALL cl_wait()
#      CALL p800_create_tmp()
#      LET g_apz.apz02b = p_bookno  # 得帳別
#      CALL p800_t()
#   END IF
#END WHILE
#END FUNCTION
#NO.FUN-570112 MARK-------
 
FUNCTION p800_ask()
   DEFINE   l_dbs     LIKE type_file.chr21   #No.FUN-690028 VARCHAR(21)
   DEFINE   l_aaa07   LIKE aaa_file.aaa07
   DEFINE   l_flag    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE   li_result LIKE type_file.num5           #No.FUN-550030  #No.FUN-690028 SMALLINT
   DEFINE   l_cnt     LIKE type_file.num5    #No.FUN-570090  -add      #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd    LIKE type_file.chr1000 # No.FUN-690028 VARCHAR(500)        #No.FUN-570112
   DEFINE   l_chk_bookno  LIKE type_file.num5        # No.FUN-690028 SMALLINT      #No.FUN-660141 
   DEFINE   l_chk_bookno1 LIKE type_file.num5        # No.FUN-690028 SMALLINT   #No.FUN-680029 
   DEFINE   l_sql     STRING  #FUN-660141
   DEFINE   l_tmn02   LIKE tmn_file.tmn02     #No.FUN-670068                                                                       
   DEFINE   l_tmn06   LIKE tmn_file.tmn06     #No.FUN-670068 
   DEFINE   l_no      LIKE type_file.chr3     #No.FUN-840125
   DEFINE   l_no1     LIKE type_file.chr3     #No.FUN-840125
   DEFINE   l_aac03   LIKE aac_file.aac03     #No.FUN-840125
   DEFINE   l_aac03_1 LIKE aac_file.aac03     #No.FUN-840125
#No.FUN-A10089 --begin
   DEFINE   l_chr1         LIKE type_file.chr20
   DEFINE   l_chr2         STRING
#No.FUN-A10089 --end
#->No.FUN-570112 --start--
    OPEN WINDOW p800 AT p_row,p_col WITH FORM "aap/42f/aapp800"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL cl_opmsg('z')
 
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)
    END IF
    #No.FUN-680029 --end--
 
WHILE TRUE
#->No.FUN-570112 ---end---
#No.FUN-A10089 --begin
   LET l_chr2 =' '  
   DISPLAY ' ' TO chr2   
#No.FUN-A10089 --end
 
   CONSTRUCT BY NAME g_wc ON npp00,npp01,npp011,npp02 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
       #->No.FUN-570112 --start--
       #LET g_action_choice='locale'
        LET g_change_lang = TRUE
       #->No.FUN-570112 ---end---
        EXIT CONSTRUCT
     ON ACTION exit
        LET INT_FLAG = 1
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
 
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#NO.FUN-570112 START---
#   IF g_action_choice = 'locale' THEN
#      RETURN
#   END IF
 
#   IF INT_FLAG THEN 
#      RETURN 
#   END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p800
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
      EXIT PROGRAM
   END IF
#No.FUN-570112 ---end---
 
    LET gl_no_b=''  #MOD-540153
    LET gl_no_e=''  #MOD-540153
    LET gl_no  =''  #MOD-540153
   LET p_plant = g_apz.apz02p 
   LET p_plant_old = p_plant      #No.FUN-570090  --add  
   LET splant  = g_plant      
   LET p_bookno   = g_apz.apz02b 
   #No.FUN-680029 --start--
   LET p_bookno1  = g_apz.apz02c 
   LET gl_no_b1 = ''
   LET gl_no_e1 = ''
   LET gl_no1   = ''
   #No.FUN-680029 --end--
   LET gl_date = g_today
   LET gl_tran = 'Y'
   LET gl_seq  = '0'
#->No.FUN-570112 --start--
   LET g_bgjob = "N"
 
   #INPUT BY NAME splant,x1,p_plant,p_bookno,gl_no,gl_date, gl_tran,gl_seq
   INPUT BY NAME splant,x1,p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date, gl_tran,gl_seq,g_bgjob #NO.FUN-570112 #No.FUN-680029 add p_bookno1,gl_no1
      WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)   #No.FUN-570090  --add UNBUFFERED
   
      AFTER FIELD splant
         LET splant = splant CLIPPED
         #FUN-990031--add--str--營運中心要控制在同意法人下
         #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = splant 
         SELECT azw06 INTO l_dbs FROM azw_file WHERE azw01 = splant
            AND azw02 = g_legal
         #FUN-990031--end
         IF STATUS THEN 
            CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
            #ERROR 'WRONG database!'     #FUN-990031
            NEXT FIELD splant
         END IF
         #No.FUN-570090  --begin    
         LET g_plant = splant      
         DECLARE tc_tmp_cs CURSOR FOR SELECT * FROM agl_tmp_file 
         CALL g_tc_tmp.clear()              
         LET g_i = 1                       
         FOREACH tc_tmp_cs INTO g_tc_tmp[g_i].*         
             LET g_i = g_i + 1                         
         END FOREACH                                  
         CALL g_tc_tmp.deleteElement(g_i)            
         #No.FUN-570090  --end 
         DATABASE l_dbs
 #        CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
         CALL cl_ins_del_sid(1,splant) #FUN-980030  #FUN-990069
         IF STATUS THEN
            ERROR 'open database error!'
            NEXT FIELD splant
         END IF
         #No.FUN-570090  --begin    
         DROP TABLE agl_tmp_file    
# No.FUN-690028 --start--
         CREATE TEMP TABLE agl_tmp_file(       
           tc_tmp00     LIKE type_file.chr1 NOT NULL,
           tc_tmp01     LIKE type_file.num5,  
           tc_tmp02     LIKE type_file.chr20, 
           tc_tmp03     LIKE apz_file.apz02b)
# No.FUN-690028 ---end--- 
         IF STATUS THEN 
            CALL cl_err('create tmp',STATUS,0) 
           #No.FUN-CB0096 ---start--- add
           #LET l_time = TIME          #FUN-D40105 mark
            LET l_time = l_time + 1    #FUN-D40105 add
            LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
            CALL s_log_data('U','100',g_id,'1',l_time,'','')
           #No.FUN-CB0096 ---end  --- add
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
            EXIT PROGRAM 
         END IF      
         CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-680029 add tc_tmp03                  
         IF STATUS THEN 
            CALL cl_err('create index',STATUS,0) 
           #No.FUN-CB0096 ---start--- add
           #LET l_time = TIME          #FUN-D40105 mark
            LET l_time = l_time + 1    #FUN-D40105 add
            LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
            CALL s_log_data('U','100',g_id,'1',l_time,'','')
           #No.FUN-CB0096 ---end  --- add
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
            EXIT PROGRAM 
         END IF  
         FOR g_i = 1 TO g_tc_tmp.getLength()     
             INSERT INTO agl_tmp_file VALUES (g_tc_tmp[g_i].*)
         END FOR                     
         #No.FUN-570090  --end
   
      AFTER FIELD x1
         LET g_source = x1[1,1]
#        IF cl_null(g_source) OR g_source NOT MATCHES '[1234567]' THEN
#           NEXT FIELD g_source 
#        END IF
   
      AFTER FIELD p_plant
         #FUN-990031--add--str--營運中心要控制在同意法人下
         #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         SELECT * FROM azw_file WHERE azw01 = p_plant
            AND azw02 = g_legal
         #FUN-990031--end
         IF STATUS <> 0 THEN
            CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
            NEXT FIELD p_plant
         END IF
        # 得出總帳 database name 
        # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new CLIPPED
         #No.FUN-570090  --begin      
         IF p_plant_old != p_plant THEN    
#No.FUN-670068--begin                                                                                                               
            FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                       
               DELETE FROM tmn_file                                                                                                    
               WHERE tmn01 = p_plant_old                                                                                               
                 AND tmn02 = l_tmn02                                                                                                   
                 AND tmn06 = l_tmn06                                                                                                   
            END FOREACH  
#           DELETE FROM tmn_file          
#            WHERE tmn01 = p_plant_old   
#              AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')  
#No.FUN-670068--end
            DELETE FROM agl_tmp_file  
            LET p_plant_old = g_plant_new          
         END IF                                   
         #No.FUN-570090  --end 
   
      AFTER FIELD p_bookno
         IF p_bookno IS NULL THEN
            NEXT FIELD p_bookno
         END IF
        #No.B003 010413 by plum
#No.FUN-660141--begin
         CALL s_check_bookno(p_bookno,g_user,p_plant)
               RETURNING l_chk_bookno
         IF (NOT l_chk_bookno) THEN
            LET p_bookno =NULL
            NEXT FIELD p_bookno
         END IF
         #No.FUN-680029 --start--
         IF p_bookno1 = p_bookno THEN
            CALL cl_err('','aap-987',1)
            NEXT FIELD p_bookno
         END IF
         #No.FUN-680029 --end--
             LET g_plant_new= p_plant  # 工廠編號
             CALL s_getdbs()
             LET l_sql = "SELECT COUNT(*) ",
                        #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                         "  FROM ",cl_get_target_table(p_plant,'aaa_file'),
                         " WHERE aaa01 = '",p_bookno,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
             PREPARE a800_pre2 FROM l_sql
             DECLARE a800_cur2 CURSOR FOR a800_pre2
             OPEN a800_cur2
             FETCH a800_cur2 INTO g_cnt 
#No.FUN-660141--end   
#       SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=p_bookno
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno
         END IF
        #No.B003..end
   
      AFTER FIELD gl_no
        #No.B112 010505 by plum
         LET g_errno=' '
#No.FUN-550030--begin
#         CALL s_check_no("agl",gl_no,"","1","","",g_dbs_gl)   #MOD-5C0083
         #CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",g_dbs_gl)   #MOD-5C0083   #MOD-840107
        #FUN-980094------------------(S)
        #CALL s_check_no("agl",gl_no,"","1","aba_file","aba01",g_dbs_gl)   #MOD-5C0083   #MOD-840107
         CALL s_check_no("agl",gl_no,"","1","aba_file","aba01",p_plant)
        #FUN-980094------------------(E)
         RETURNING li_result,gl_no
#         LET gl_no = s_get_doc_no(gl_no)   #MOD-5C0083
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
#        CALL s_chkno(gl_no) 
#        RETURNING g_errno
#        IF NOT cl_null(g_errno) THEN
#           CALL cl_err(gl_no,g_errno,0)
#           NEXT FIELD gl_no
#        END IF
        #No.B112 ..end
#        CALL s_m_aglsl(g_dbs_gl,gl_no,'1')
#        IF NOT cl_null(g_errno) THEN 
#           CALL cl_err(gl_no,g_errno,0)
#           NEXT FIELD gl_no
#        END IF
#No.FUN-550030--end 
 
      #No.FUN-680029 --start--
      AFTER FIELD p_bookno1
         IF p_bookno1 IS NULL THEN
            NEXT FIELD p_bookno1
         END IF
         CALL s_check_bookno(p_bookno1,g_user,p_plant)
               RETURNING l_chk_bookno1
         IF (NOT l_chk_bookno1) THEN
            LET p_bookno1 = NULL
            NEXT FIELD p_bookno1
         END IF
         IF p_bookno1 = p_bookno THEN
            CALL cl_err('','aap-987',1)
            NEXT FIELD p_bookno1
         END IF
        #LET g_plant_new= p_plant  # 工廠編號    #FUN-A50102
        #CALL s_getdbs()    #FUN-A50102
         LET l_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                     "  FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102 
                     " WHERE aaa01 = '",p_bookno1,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
         PREPARE a800_pre3 FROM l_sql
         DECLARE a800_cur3 CURSOR FOR a800_pre3
         OPEN a800_cur3
         FETCH a800_cur3 INTO g_cnt 
 
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno1
         END IF
   
      AFTER FIELD gl_no1
         LET g_errno=' '
 
         #CALL s_check_no("agl",gl_no1,"","1","aac_file","aac01",g_dbs_gl)   #MOD-840107
        #FUN-980094------------------(S)
        #CALL s_check_no("agl",gl_no1,"","1","aba_file","aba01",g_dbs_gl)   #MOD-840107
         CALL s_check_no("agl",gl_no1,"","1","aba_file","aba01",p_plant)
        #FUN-980094------------------(E)
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
      #No.FUN-680029 --end--
   
      AFTER FIELD gl_date
         IF gl_date IS NULL THEN
            NEXT FIELD gl_date
          END IF
          SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
         IF gl_date <= l_aaa07 THEN    
            CALL cl_err('','axm-164',0)
            NEXT FIELD gl_date
         END IF
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
#           CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)  #No.FUN-660122
            NEXT FIELD gl_date
         END IF
   
      AFTER FIELD gl_seq  
         IF cl_null(gl_seq) OR gl_seq NOT MATCHES '[012]' THEN
            NEXT FIELD gl_seq 
         END IF
   
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #No.B003 010413 by plum
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT 
         END IF
         IF cl_null(splant)     THEN
            LET l_flag='Y'
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
            LET l_flag='Y' 
         END IF
         IF cl_null(gl_tran)    THEN
            LET l_flag='Y'
         END IF
         IF cl_null(gl_seq)     THEN
            LET l_flag='Y' 
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD splant
         END IF
        # 得出總帳 database name
        # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new CLIPPED
       #No.B003...end
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         IF STATUS THEN
#           CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)  #No.FUN-660122
            NEXT FIELD gl_date
         END IF
 
      ON ACTION CONTROLP            #No:7803
         IF INFIELD(gl_no) THEN
            #No.FUN-550030 防止USER游標亂跳以致沒走到先前的 s_getdbs()
            # 得出總帳 database name
            # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
             LET g_plant_new= p_plant  # 工廠編號
             CALL s_getdbs()
             LET g_dbs_gl=g_dbs_new CLIPPED
             LET g_plant_gl = p_plant      #No.FUN-980059
            #end No.FUN-550030
              #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1',' ',' ','AGL') #No.FUN-840125
#             CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125    #No.FUN-980059
              CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                         RETURNING gl_no  #NO:6842
#              CALL FGL_DIALOG_SETBUFFER( gl_no )
              DISPLAY BY NAME gl_no
              NEXT FIELD gl_no
           END IF
         #No.FUN-680029 --start--
         IF INFIELD(gl_no1) THEN
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new CLIPPED
            #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1',' ',' ','AGL') #No.FUN-840125
#           CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1',' ',' ','AGL')  #No.FUN-840125    #No.FUN-980059
            CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1',' ',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                        RETURNING gl_no1
            DISPLAY BY NAME gl_no1
            NEXT FIELD gl_no1
         END IF
         #No.FUN-680029 --end--
 
      #No.FUN-570090  --begin             
      ON ACTION get_missing_voucher_no   
         IF cl_null(gl_no) AND cl_null(gl_no1) THEN  #No.FUN-670068 add cl_null(gl_no1)
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
                                 
#        CALL s_agl_missingno(p_plant,g_dbs_gl,g_apz.apz02b,gl_no,gl_date,0) #No.FUN-680029 mark
         CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0) #No.FUN-680029
                                
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
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()
      ON ACTION locale
        #LET g_action_choice='locale'    #->No.FUN-570112
         LET g_change_lang = TRUE        #->No.FUN-570112
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570112 MARK-------
#   IF g_action_choice = 'locale' THEN
#      RETURN
#  END IF
#   IF INT_FLAG THEN RETURN END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p800
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp800"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp800','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",splant CLIPPED,"'",
                      " '",x1 CLIPPED,"'",
                      " '",p_plant CLIPPED,"'",
                      " '",p_bookno CLIPPED,"'",
                      " '",gl_no CLIPPED,"'",
                      " '",gl_date CLIPPED,"'",
                      " '",gl_tran CLIPPED,"'",
                      " '",gl_seq CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",p_bookno1 CLIPPED,"'",  #No.FUN-680029
                      " '",gl_no1 CLIPPED,"'"      #No.FUN-680029 
         CALL cl_cmdat('aapp800',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p800
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211  
    EXIT PROGRAM
   END IF
   EXIT WHILE
#->No.FUN-570112 ---end---
END WHILE
END FUNCTION
 
FUNCTION p800_t(l_npptype)  #No.FUN-680029 add l_npptype
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_order       LIKE npp_file.npp01    #No.FUN-690028 VARCHAR(30)               
   DEFINE l_remark 	LIKE zaa_file.zaa08    #No.FUN-690028 VARCHAR(150)
   DEFINE l_name	LIKE type_file.chr20   #No.FUN-690028 VARCHAR(20)
   DEFINE l_cmd 	LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(30)
   DEFINE ap_date	LIKE type_file.dat     #No.FUN-690028 DATE
   #DEFINE ap_glno VARCHAR(16)         #No.FUN-550030  #FUN-660117 remark
   DEFINE ap_glno	LIKE ala_file.ala75              #FUN-660117
   #DEFINE ap_conf VARCHAR(1)                          #FUN-660117 remark
   DEFINE ap_conf	LIKE ala_file.alaclos            #FUN-660117
   DEFINE l_mm,l_yy     LIKE type_file.num5     #No.FUN-690028 SMALLINT
   DEFINE l_msg         LIKE ze_file.ze03       #No.FUN-690028 VARCHAR(80)
   DEFINE l_npptype     LIKE npp_file.npptype         #No.FUN-680029
   DEFINE g_cnt1        LIKE type_file.num10       #No.FUN-680029  #No.FUN-690028 INTEGER
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   DEFINE l_npp01       LIKE npp_file.npp01   #TQC-BA0148
   DEFINE l_yy1         LIKE type_file.num5          #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5          #CHI-CB0004   
   DELETE FROM p800_tmp;
   
   LET gl_no_b1=''  #No.FUN-680029
   LET gl_no_e1=''  #No.FUN-680029
   LET g_npptype = l_npptype  #No.FUN-680029
   
   #No.+070 010424 by plum add 若立帳日期不為空白時check單據日期及立帳日要同年月
    IF NOT cl_null(gl_date) THEN
       LET l_flag='N'
       CALL p800_chkdate()
       IF l_flag='X' THEN
          RETURN
       END IF
       IF l_flag='Y' THEN #MOD-CC0079 remove {
          CALL cl_err('err:','axr-061',1)
          LET g_success = 'N'  #MOD-CC0079 add
          RETURN
       END IF
       #MOD-CC0079 remove }
    END IF
   #No.+070..end
   
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
        #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",   #FUN-A50102
         LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(p_plant,'aznn_file'),   #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"'",
                     "    AND aznn00 = '",p_bookno,"'"
      ELSE
        #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",   #FUN-A50102
         LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(p_plant,'aznn_file'),   #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"'",
                     "    AND aznn00 = '",p_bookno1,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p800_p1 FROM g_sql
      DECLARE p800_c1 CURSOR FOR p800_p1
      OPEN p800_c1
      FETCH p800_c1 INTO g_yy,g_mm
   ELSE
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = gl_date
   END IF
   #No.FUN-680029 --end--
 
   #No.FUN-840211---Begin
  IF g_aaz.aaz81 = 'Y' THEN
     LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
     IF g_aza.aza63 = 'Y' THEN 
        IF l_npptype = '0' THEN
          #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",     #FUN-A50102
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                       " WHERE aba00 =  '",p_bookno,"'"
                      ,"   AND aba19 <> 'X' " #CHI-C80041
                      ,"   AND YEAR(aba02) =" ,l_yy1," AND MONTH(aba02) =", l_mm1  #CHI-CB0004
        ELSE
     	  # LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",    #FUN-A50102
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                       " WHERE aba00 =  '",p_bookno1,"'"
                      ,"   AND aba19 <> 'X' " #CHI-C80041
                      ,"   AND YEAR(aba02) =" ,l_yy1," AND MONTH(aba02) =", l_mm1  #CHI-CB0004
        END IF
     
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
        PREPARE aba11_pre FROM g_sql
        EXECUTE aba11_pre INTO l_aba11
     ELSE 
       SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file 
         WHERE aba00 = p_bookno
           AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
           AND aba19 <> 'X'  #CHI-C80041
     END IF
    #CHI-CB0004--(B)
     IF cl_null(l_aba11) OR l_aba11 = 1 THEN
        LET l_aba11 = l_yy1*1000000+l_mm1*10000+1
     END IF
    #CHI-CB0004--(E)
    #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
     LET g_aba.aba11 = l_aba11
  ELSE 
     LET g_aba.aba11 = ' '        
  END IF      
  #No.FUN-840211---End
    
   #no.3432 (是否自動傳票確認)
  #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",    #FUN-A50102
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(p_plant,'aaz_file'),   #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
   OPEN aaz85_cs 
   FETCH aaz85_cs INTO g_aaz85
   IF STATUS THEN 
      CALL cl_err('sel aaz85',STATUS,1)
      RETURN
   END IF
   #no.3432(end)
 
   CASE g_source
     WHEN '1'  #預購會計(aapt720)
       IF l_npptype = '0' THEN  #No.FUN-680029
          LET g_sql =" SELECT ala08,ala72,alafirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,npp_file,npq_file ",
                     "  WHERE ala01 = npq01 AND ala72 IS NULL ",
                     "    AND npq00 = 4 AND npq011 = 0 "
       #No.FUN-680088 --start--
       ELSE
          LET g_sql =" SELECT ala08,ala72,alafirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,npp_file,npq_file ",
                     "  WHERE ala01 = npq01 ",
                     "    AND npq00 = 4 AND npq011 = 0 "
       END IF
       #No.FUN-680088 --end--
     WHEN '2'  #到單(aapt820)
       IF l_npptype = '0' THEN  #No.FUN-680029
          LET g_sql =" SELECT alh021,alh72,alhfirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM alh_file,npp_file,npq_file ",
                     "  WHERE alh01 = npp01 AND alh72 IS NULL ",
                     "    AND npq00 = 4 AND npq011 = 2 "
       #No.FUN-680088 --start--
       ELSE
          LET g_sql =" SELECT alh021,alh72,alhfirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM alh_file,npp_file,npq_file ",
                     "  WHERE alh01 = npp01 ",
                     "    AND npq00 = 4 AND npq011 = 2 "
       END IF
       #No.FUN-680088 --end--
     WHEN '3'  #到貨(aapt810)
       IF l_npptype = '0' THEN  #No.FUN-680029
          LET g_sql =" SELECT alk02,alk72,alkfirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM alk_file,npp_file,npq_file ",
                     "  WHERE alk01 = npp01 AND alk72 IS NULL ",
                     "    AND npq00 = 4 AND npq011 = 1 ",
                     "    AND alkfirm <> 'X' "  #CHI-C80041
       #No.FUN-680088 --start--
       ELSE
          LET g_sql =" SELECT alk02,alk72,alkfirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM alk_file,npp_file,npq_file ",
                     "  WHERE alk01 = npp01 ",
                     "    AND npq00 = 4 AND npq011 = 1 ",
                     "    AND alkfirm <> 'X' "  #CHI-C80041
       END IF
       #No.FUN-680088 --end--
     WHEN '4'  #預購付款(aapt711)
       IF l_npptype = '0' THEN  #No.FUN-680029
         #LET g_sql =" SELECT ala08,ala74,ala78,",                  #MOD-BC0106 mark
          LET g_sql =" SELECT ala86,ala74,ala78,",                  #MOD-BC0106 add
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,npp_file,npq_file ",
                     "  WHERE ala01 = npp01 AND ala74 IS NULL ",
                     "    AND npq00 = 5 AND npq011 = 0 "
       #No.FUN-680088 --start--
       ELSE
         #LET g_sql =" SELECT ala08,ala74,ala78,",                  #MOD-BC0106 mark
          LET g_sql =" SELECT ala86,ala74,ala78,",                  #MOD-BC0106 add
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,npp_file,npq_file ",
                     "  WHERE ala01 = npp01  ",
                     "    AND npq00 = 5 AND npq011 = 0 "
       END IF
       #No.FUN-680088 --end--
     WHEN '5'  #預購修改(aapt740)
       IF l_npptype = '0' THEN  #No.FUN-680029
          LET g_sql =" SELECT alc08,alc72,alcfirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,alc_file,npp_file,npq_file ",
                     "  WHERE alc01 = npp01 AND alc72 IS NULL ",
                     "    AND ala01 = alc01 ",
                     "    AND npp011= alc02 ",
                     "    AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                     "    AND npq00 = 6 ",
                     "    AND alcfirm <> 'X' "  #CHI-C80041
       #No.FUN-680088 --start--
       ELSE
          LET g_sql =" SELECT alc08,alc72,alcfirm,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,alc_file,npp_file,npq_file ",
                     "  WHERE alc01 = npp01 ",
                     "    AND ala01 = alc01 ",
                     "    AND npp011= alc02 ",
                     "    AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                     "    AND npq00 = 6 ", 
                     "    AND alcfirm <> 'X' "  #CHI-C80041
       END IF
       #No.FUN-680088 --end--
     WHEN '6'  #修改付款(aapt741)
       IF l_npptype = '0' THEN  #No.FUN-680029
          LET g_sql =" SELECT alc08,alc74,alc78,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,alc_file,npp_file,npq_file ",
                     "  WHERE alc01 = npp01 AND alc74 IS NULL ",
                     "    AND ala01 = alc01 ",
                     "    AND npp011= alc02 ",
                     "    AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                     "    AND npq00 = 7 ",
                     "    AND alcfirm <> 'X' "  #CHI-C80041
       #No.FUN-680088 --start--
       ELSE
          LET g_sql =" SELECT alc08,alc74,alc78,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,alc_file,npp_file,npq_file ",
                     "  WHERE alc01 = npp01 ",
                     "    AND ala01 = alc01 ",
                     "    AND npp011= alc02 ",
                     "    AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                     "    AND npq00 = 7 ",
                     "    AND alcfirm <> 'X' "  #CHI-C80041
       END IF
       #No.FUN-680088 --end--
     WHEN '7'  #結案(aapt750)
       IF l_npptype = '0' THEN  #No.FUN-680029
          LET g_sql =" SELECT ala08,ala75,alaclos,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,npp_file,npq_file ",
                     "  WHERE ala01 = npp01 AND (ala75 IS NULL or ala75 = ' ') ",
                     "    AND npq00 = 9 AND npq011 = 0 "
       #No.FUN-680088 --start--
       ELSE
          LET g_sql =" SELECT ala08,ala75,alaclos,",
                     "        npp_file.*,npq_file.*",
                     "   FROM ala_file,npp_file,npq_file ",
                     "  WHERE ala01 = npp01 ",
                     "    AND npq00 = 9 AND npq011 = 0 "
       END IF
       #No.FUN-680088 --end--
   END CASE
   LET g_sql = g_sql CLIPPED," AND nppsys = npqsys AND npp00 = npq00 ",
                             " AND npp01 = npq01   AND npp011 = npq011 ",
                             " AND npptype ='",l_npptype,"'", #No.FUN-680029 
                             " AND npqtype=npptype ",         #No.FUN-680029
                             " AND npqsys = 'LC'   AND ",g_wc CLIPPED,
                             " ORDER BY nppsys,npp00,npp01,npp011,npq02 "  
   CALL s_showmsg_init()                  #NO.FUN-710014
   PREPARE p800_1_p0 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p800_1_p0',STATUS,1) 
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME          #FUN-D40105 mark
      LET l_time = l_time + 1    #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p800_1_c0 CURSOR WITH HOLD FOR p800_1_p0
   CALL cl_outnam('aapp800') RETURNING l_name
   IF l_npptype = '0' THEN  #No.FUN-680029
      START REPORT aapp800_rep TO l_name
   #No.FUN-680029 --start--
   ELSE
      START REPORT aapp800_1_rep TO l_name
   END IF
   #No.FUN-680029 --end--
   LET l_yy = YEAR(gl_date) 
   LET l_mm = MONTH(gl_date) 
   #BEGIN WORK   #FUN-D40121 add
   LET g_cnt1 = 0     #No.FUN-680029
   LET g_success = 'Y'
   WHILE TRUE
#NO.FUN-710014--BEGIN
  IF g_success='N' THEN
  LET g_totsuccess='N'
  LET g_success='Y'
END IF
#NO.FUN-710014--END
      FOREACH p800_1_c0 INTO ap_date,ap_glno,ap_conf,
                              l_npp.*,l_npq.*
         IF STATUS THEN
#          CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH              #NO.FUN-710014
           CALL s_errmsg('','','foreach:',STATUS,1)  LET g_success = 'N' CONTINUE FOREACH #NO.FUN-710014
         END IF
         #add by danny 99/01/28
         IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
         IF ap_conf='N' THEN CONTINUE FOREACH END IF
         IF ap_conf='X' THEN CONTINUE FOREACH END IF #01/08/14
         IF l_npptype = '0' THEN  #No.FUN-680029
            IF NOT cl_null(ap_glno) THEN CONTINUE FOREACH END IF
         END IF  #No.FUN-680029
 
         IF ap_date<>l_npp.npp02 THEN
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
         ELSE LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
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
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 USING 'yyyymmdd'
                                                          # 依日期
              OTHERWISE         LET l_order = ' '
         END CASE
         #02/02/19 bug no.4422 add
         #資料丟入temp file 排序
         INSERT INTO p800_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         IF STATUS THEN
#           CALL cl_err('ins tmp:',STATUS,1)   #No.FUN-660122
#NO.FUN-710014--BEGIN
 #          CALL cl_err3("ins","p800_tmp","","",STATUS,"","ins tmp:",1)  #No.FUN-660122
            CALL s_errmsg('npp01',l_order,'ins tmp:',STATUS,1 )
 #          LET g_success='N' EXIT FOREACH 
            LET g_success='N' CONTINUE FOREACH 
#NO.FUN-710014--END
         END IF
         LET g_cnt1 = g_cnt1 + 1        #No.FUN-680029
         #02/02/19 bug no.4422 add
      END FOREACH
#NO.FUN-710014--BEGIN
   IF g_totsuccess="N" THEN   
      LET g_success="N"
   END IF
#NO.FUN-710014--END
   LET l_npp01 = NULL   #No.TQC-BA0148
      #-02/02/19 bug no.4422 add--
      DECLARE p800_tmpcs CURSOR FOR
         SELECT * FROM p800_tmp 
          ORDER BY order1,npp01,npq06,npq03,npq05,     #No.TQC-BA0148 add npp01
                   npq24,npq25,remark,npq01
      FOREACH p800_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
#NO.FUN-710014--BEGIN
   IF g_success="N" THEN
    LET g_totsuccess="N"
    LET g_success='Y'
   END IF
#NO.FUN-710014--END
         IF STATUS THEN
#           CALL cl_err('for tmp:',STATUS,1) LET g_success='N' EXIT FOREACH              #NO.FUN-710014
            CALL s_errmsg('','','for tmp:',STATUS,1) LET g_success='N' CONTINUE FOREACH  #NO.FUN-710014
         END IF
         #No.TQC-BA0148  --Begin
         IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
            LET l_npp.npp08 = 0
         END IF
         LET l_npp01 = l_npp.npp01
         #No.TQC-BA0148  --End
         
         IF l_npptype = '0' THEN  #No.FUN-680029
            OUTPUT TO REPORT aapp800_rep(l_order,l_npp.*,l_npq.*,l_remark)
         #No.FUN-680029 --start--
         ELSE
            OUTPUT TO REPORT aapp800_1_rep(l_order,l_npp.*,l_npq.*,l_remark)
         END IF
         #No.FUN-680029 --end--
      END FOREACH
#NO.FUN-710014--BEGIN
   IF g_totsuccess="N" THEN   
      LET g_success="N"
   END IF
#NO.FUN-710014--END
      #--02/02/19 bug no.4422 add--
      EXIT WHILE
   END WHILE
   IF l_npptype = '0' THEN  #No.FUN-680029
      FINISH REPORT aapp800_rep
   #No.FUN-680029 --start--
   ELSE
      FINISH REPORT aapp800_1_rep
   END IF
   #No.FUN-680029 --end--
  #No.+366 010705 plum
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009  mark by dxfwo 
#  RUN l_cmd                                          #No.FUN-9C0009  mark by dxfwo
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo
  #No.+366..end
#NO.FUN-570112 MARK--
#   IF g_success = 'Y'
#      THEN COMMIT WORK
#           CALL s_m_prtgl(g_dbs_gl,g_apz.apz02b,gl_no_b,gl_no_e)
#      ELSE ROLLBACK WORK
#   END IF
#NO.FUN-570112 MARK---
 
   #No.FUN-680029 --begin--
   IF g_cnt1 = 0  THEN
      CALL cl_err('','aap-129',1)
      LET g_success = 'N'
   END IF
   #No.FUN-680029 --end--
END FUNCTION
 
REPORT aapp800_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01      # No.FUN-690028 VARCHAR(30)  
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf DEC(20,6)  #FUN-4B0079
  DEFINE l_remark       LIKE zaa_file.zaa08       # No.FUN-690028 VARCHAR(150)
  DEFINE li_result      LIKE type_file.num5                    #No.FUN-550030  #No.FUN-690028 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01  #No.FUN-570090  --add
  DEFINE l_flag1        LIKE type_file.chr1                #No.FUN-570090  --add    #No.FUN-690028 VARCHAR(1)
  DEFINE l_legal        LIKE azw_file.azw02  #FUN-980001 add
  DEFINE l_npp08        LIKE npp_file.npp08  #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021  
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
 
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
#No.FUN-670060--begin
   # 得出總帳 database name 
   # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
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
      AND tc_tmp03 = p_bookno  #No.FUN-680029
   IF NOT cl_null(l_missingno) THEN      
      LET l_flag1='Y'                   
      LET gl_no=l_missingno            
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no  
                                AND tc_tmp03 = p_bookno  #No.FUN-680029   
   END IF       
               
   #缺號使用完，再在流水號最大的編號上增加         
   IF l_flag1='N' THEN         
   #No.FUN-570090  --end
#No.FUN-550030--begin
    #FUN-980094------------------(S)
    #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","aba_file","aba01",g_dbs_gl,"",p_bookno) #No.FUN-680029 g_apz.apz02b -> p_bookno
    #No.FUN-CB0096 ---start--- Add
     LET t_no = Null
     CALL s_log_check(l_order) RETURNING t_no
     IF NOT cl_null(t_no) THEN
        LET gl_no = t_no
        LET li_result = '1'
     ELSE
    #No.FUN-CB0096 ---start--- Add
    #FUN-980094------------------(S)
    #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","aba_file","aba01",g_dbs_gl,"",p_bookno) #No.FUN-680029 g_apz.apz02b -> p_bookno
     CALL s_auto_assign_no("agl",gl_no,gl_date,"1","aba_file","aba01",p_plant,"",p_bookno)
    #FUN-980094------------------(E)
     RETURNING li_result,gl_no
     END IF   #No.FUN-CB0096   Add
     IF (NOT li_result) THEN
        LET g_success = 'N'
     END IF
#    CALL s_m_aglau(g_dbs_gl,g_apz.apz02b,gl_no,gl_date,g_yy,g_mm,0)
#         RETURNING g_i,gl_no
#    PRINT "Get max TR-no:",gl_no," Return code(g_i):",g_i
#    IF g_i != 0 THEN LET g_success = 'N' END IF
#No.FUN-550030--end   
     IF g_bgjob = 'N'    THEN    #FUN-570112
         DISPLAY "Insert G/L voucher no:",gl_no AT 1,1
     END IF
    #NO.FUN-570112 
    IF g_bgjob = 'N'    THEN    #FUN-570112
        PRINT "Insert aba:",p_bookno,' ',gl_no,' From:',l_order  #No.FUN-680029 g_apz.apz02b -> p_bookno    
    END IF
    END IF  #No.FUN-570090  -add          
    #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",    #FUN-A50102
     LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",    #No:8657
                        " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,", #MOD-9C0299 add abaoriu,abaorig
                        #" abasign,abadays,abaprit,abasmax,abasseq,aba11)",     #FUN-840211 add aba11 #FUN-980001 mark
#                       " abasign,abadays,abaprit,abasmax,abasseq,aba11,abalegal,abaoriu,abaorig,aba21)",    #TQC-A10060 add abaoriu,abaorig  #FUN-840211 add aba11 #FUN-980001 add  #FUN-A10006 add aba21
                       #" abasign,abadays,abaprit,abasmax,abasseq,aba11,abalegal,aba21)",    #TQC-A10060 add abaoriu,abaorig  #FUN-840211 add aba11 #FUN-980001 add  #FUN-A10006 add aba21          #MOD-A80136 mark
                        " abasign,abadays,abaprit,abasmax,abasseq,aba11,abalegal,aba21,aba24)",    #TQC-A10060 add abaoriu,abaorig  #FUN-840211 add aba11 #FUN-980001 add  #FUN-A10006 add aba21    #MOD-A80136 add aba24
                #" VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)" #FUN-840211 add ?    #No:8657 #FUN-980001 mark
#               " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,? ,?,?,?,?,?,?)" #TQC-A10060 add ?,? #MOD-9C0299 add ?,? #FUN-840211 add ?    #No:8657 #FUN-980001 add #FUN-A10006 add ?
                " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,? ,?,?,?,?,?)" #TQC-A10060 add ?,? #MOD-9C0299 add ?,? #FUN-840211 add ?    #No:8657 #FUN-980001 add #FUN-A10006 add ?  #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
     PREPARE p800_1_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     LET g_aba01t = gl_no[1,g_doc_len]               #No.FUn-550030
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
     LET g_system = 'LC'
     LET g_zero   = 0
     LET g_zero1  = '0'    #No:8657
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
     LET g_aba.abalegal = l_legal #FUN-980001 add
     EXECUTE p800_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,g_today,  #No.FUN-680029 g_apz.apz02b -> p_bookno
                            g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero1,g_N,g_N,   #No:8657
                            g_zero,g_Y,g_user,g_grup,g_today,
                            g_user,g_grup,       #MOD-9C0299  
                            g_aba.abasign,g_aba.abadays,
                            #g_aba.abaprit,g_aba.abasmax,g_zero,g_aba.aba11 #No.FUN-840211 add aba11 #FUN-980001 mark
                            g_aba.abaprit,g_aba.abasmax,g_zero,g_aba.aba11,g_aba.abalegal, #No.FUN-840211 add aba11 #FUN-980001 add
#                           g_aba.abaoriu,g_aba.abaorig,l_npp.npp08   #TQC-A10060 add  abaoriu,g_aba.abaurig  #FUN-A10006 add npp08
                            l_npp.npp08,g_user   #TQC-A10060 add  abaoriu,g_aba.abaurig  #FUN-A10006 add npp08 #MOD-A80136 add g_user
    #EXECUTE p800_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,gl_date,  #No.FUN-680029 g_apz.apz02b -> p_bookno
    #                        'LC',l_order,'0','0','N','N','N',
    #                        '0','Y',g_user,g_grup,g_today
    #----------------------  for ora修改 ------------------------------------
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570090  --add
                            AND tmn06 = p_bookno  #No.FUN-680029-680029 
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
          #預購申請(aapt720)
     CASE WHEN l_npq.npqsys='LC' AND l_npq.npq00=4 AND l_npq.npq011=0
               UPDATE ala_file SET ala72 = gl_no WHERE ala01 = l_npq.npq01
          #外購到貨(aapt810)
          WHEN l_npq.npqsys='LC' AND l_npq.npq00=4 AND l_npq.npq011=1
               UPDATE alk_file SET alk72 = gl_no WHERE alk01 = l_npq.npq01
               # Thomas 99/01/08 順便更新內購傳票編號
               UPDATE apa_file SET apa43=gl_date,apa44 = gl_no 
                WHERE apa01 = l_npq.npq01
          #外購到單(aapt820)
          WHEN l_npq.npqsys='LC' AND l_npq.npq00=4 AND l_npq.npq011=2
               UPDATE alh_file SET alh72 = gl_no WHERE alh01 = l_npq.npq01
          #外購付款(aapt711)
          WHEN l_npq.npqsys='LC' AND l_npq.npq00=5 AND l_npq.npq011=0
               UPDATE ala_file SET ala74 = gl_no WHERE ala01 = l_npq.npq01
          #修改付款(aapt741)
          WHEN l_npq.npqsys='LC' AND l_npq.npq00=7                 
               UPDATE alc_file SET alc74 = gl_no 
               WHERE alc01 = l_npq.npq01 AND alc02 = l_npq.npq011 AND
                     alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
          #外購修改(aapt740)
          WHEN l_npq.npqsys='LC' AND l_npq.npq00=6                   
               UPDATE alc_file SET alc72 = gl_no 
                WHERE alc01 = l_npq.npq01 AND alc02 = l_npq.npq011 AND
                      alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
          #結案(aapt750)
          WHEN l_npq.npqsys='LC' AND l_npq.npq00=9 AND l_npq.npq011=0
               UPDATE ala_file SET ala75 = gl_no WHERE ala01 = l_npq.npq01
     END CASE
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('upd ala/alc:',SQLCA.sqlcode,1) LET g_success = 'N'   
     END IF
     UPDATE npp_file SET npp03 = gl_date,nppglno = gl_no,
                         npp06 = p_plant,npp07 = p_bookno
      WHERE npp01 = l_npq.npq01
        AND npp011= l_npq.npq011
        AND npp00 = l_npq.npq00
        AND nppsys= l_npq.npqsys
        AND npptype = '0'  #No.FUN-680029
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#       CALL cl_err('upd npp03/glno:',SQLCA.sqlcode,1)    #No.FUN-660122
        CALL cl_err3("upd","npp_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","upd npp03/glno:",1)  #No.FUN-660122
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N'    THEN    #FUN-570112
         DISPLAY "Seq:",l_seq AT 2,1
     END IF
    #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",   #FUN-A50102
     LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'),    #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
#                       " abb08,abb11,abb12,abb13,abb14,abb15,",                #FUN-810069
                        " abb08,abb11,abb12,abb13,abb14,",                      #FUN-810069
                        " abb24,abb25,",
            
                        #FUN-5C0015 BY GILL --START
                        #"abb31,abb32,abb33,abb34,abb35,abb36,abb37", #FUN-980001 mark
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal", #FUN-980001 add abblegal
                        #FUN-5C0015 BY GILL --END
 
                        " )",
#                " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",                #FUN-810069
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?",                  #FUN-810069
                 #"       ,?,?,?,?,?,?,?)" #FUN-5C0015 BY GILL #FUN-980001 mark
                 "       ,?,?,?,?,?,?,?,?)" #FUN-5C0015 BY GILL #FUN-980001 add ?
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
     CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
     PREPARE p800_1_p5 FROM g_sql
     EXECUTE p800_1_p5 USING 
                p_bookno,gl_no,l_seq,l_npq.npq03,l_npq.npq04,   #No.FUN-680029 g_apz.apz02b -> p_bookno
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
#               l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25,                #FUN-810069
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                            #FUN-810069
 
                #FUN-5C0015 BY GILL --START
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                #l_npq.npq35,l_npq.npq36,l_npq.npq37 #FUN-980001 mark
                l_npq.npq35,l_npq.npq36,l_npq.npq37,l_legal #FUN-980001 add l_legal
                #FUN-5C0015 BY GILL --END
 
 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      IF g_bgjob = 'N'    THEN    #FUN-570112
          PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
      END IF
     #FUN-A50102--mod--str--
     #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 = ? ,aba09 = ? ",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'),
                  "   SET aba08 = ? ,aba09 = ? ",
     #FUN-A50102--mod--end
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p800_1_p6 FROM g_sql
      EXECUTE p800_1_p6 USING l_debit,l_credit,l_npp08,gl_no,p_bookno #No.FUN-680029 g_apz.apz02b -> p_bookno #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      #NO.FUN-570112 
      IF g_bgjob = 'N'    THEN    #FUN-570112
          PRINT
      END IF
     CALL s_flows('2',p_bookno,gl_no,gl_date,g_N,'',TRUE)   #No.TQC-B70021
#no.3432 自動確認
IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
     #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",   #FUN-A50102
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'abb_file'),",aag_file",   #FUN-A50102
                  " WHERE abb01 = '",gl_no,"'",
                  "   AND abb00 = '",p_bookno,"'",  #No.FUN-680029 g_apz.apz02b -> p_bookno
                  "   AND abb03 = aag01  ",
                  "   AND aag20 = 'Y' ",
                  "   AND abb00 = aag00  "        #No.FUN-730064
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE count_pre FROM g_sql
      DECLARE count_cs CURSOR FOR count_pre
      OPEN count_cs 
      FETCH count_cs INTO g_cnt
      CLOSE count_cs
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
        #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-850183 mark
        #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-850183 mark
         IF g_aba.abamksg='N' THEN                       #MOD-850183
            LET g_aba.aba20='1' 
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
#No.TQC-B70021 --begin 
            CALL s_chktic (p_bookno,gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end 
           #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",   #FUN-A50102
            LET g_sql = " UPDATE ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,", 
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",             #MOD-A80136
                               " aba37   = ?  ",             #MOD-A80136
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
            PREPARE upd_aba19 FROM g_sql
            EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user,                  #MOD-A80136
                                    gl_no        ,p_bookno  #No.FUN-680029 g_apz.apz02b -> p_bookno
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF     
#no.3432(end)
       #No.FUN-CB0096 ---start--- Add
       #LET l_time = TIME          #FUN-D40105 mark
        LET l_time = l_time + 1    #FUN-D40105 add
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no,l_order)
        IF g_aba.abamksg = 'N' THEN
          #LET l_time = TIME          #FUN-D40105 mark
           LET l_time = l_time + 1    #FUN-D40105 add
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
     #LET gl_no[4,12]=''                      #MOD-A80071 mark
      LET gl_no[g_no_sp-1,g_no_ep]=''         #MOD-A80071
END REPORT
 
#No.FUN-680029 --start--
REPORT aapp800_1_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01      # No.FUN-690028 VARCHAR(30)  
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6) 
  DEFINE l_remark       LIKE zaa_file.zaa08        # No.FUN-690028 VARCHAR(150)
  DEFINE li_result      LIKE type_file.num5                 #No.FUN-690028 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01  
  DEFINE l_flag1        LIKE type_file.chr1                 #No.FUN-690028 VARCHAR(1)
  DEFINE l_legal        LIKE azw_file.azw02  #FUN-980001 add
  DEFINE l_npp08        LIKE npp_file.npp08  #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021 
   
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
 
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
   # 得出總帳 database name 
   # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
    LET g_plant_new= p_plant  # 工廠編號
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new CLIPPED
   
   #缺號使用                
   LET l_flag1='N'             
   LET l_missingno = NULL     
   LET g_j=g_j+1             
   SELECT tc_tmp02 INTO l_missingno       
     FROM agl_tmp_file                    
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y' 
      AND tc_tmp03 = p_bookno1
   IF NOT cl_null(l_missingno) THEN      
      LET l_flag1='Y'                   
      LET gl_no1 =l_missingno            
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1  
                                AND tc_tmp03 = p_bookno1
   END IF       
               
   #缺號使用完，再在流水號最大的編號上增加         
   IF l_flag1='N' THEN         
     #FUN-980094------------------(S)
     #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","aba_file","aba01",g_dbs_gl,"",p_bookno1)
     #No.FUN-CB0096 ---start--- Add
      LET t_no = Null
      CALL s_log_check(l_order) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET gl_no1 = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---start--- Add
     #FUN-980094------------------(S)
     #CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","aba_file","aba01",g_dbs_gl,"",p_bookno1)
      CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","aba_file","aba01",p_plant,"",p_bookno1)
     #FUN-980094------------------(E)
                  RETURNING li_result,gl_no1
      END IF   #No.FUN-CB0096   Add
      IF (NOT li_result) THEN
         LET g_success = 'N'
      END IF
 
      IF g_bgjob = 'N' THEN 
          DISPLAY "Insert G/L voucher no:",gl_no1 AT 1,1
      END IF
 
      IF g_bgjob = 'N' THEN 
         PRINT "Insert aba:",p_bookno1,' ',gl_no1,' From:',l_order
      END IF
   END IF
   #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",   #FUN-A50102
    LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
              "(aba00,aba01,aba02,aba03,aba04,aba05,",
              " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",
              " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,", # MOD-9C0299 add abaoriu,abaorig
              #" abasign,abadays,abaprit,abasmax,abasseq,aba11)",     #FUN-840211 add aba11 #FUN-980001 mark
#             " abasign,abadays,abaprit,abasmax,abasseq,aba11,abalegal,abaoriu,abaorig,aba21)", #TQC-A10060 add abaurig,abaorig    #FUN-840211 add aba11 #FUN-980001 add  #FUN-A10006 add abb21
              " abasign,abadays,abaprit,abasmax,abasseq,aba11,abalegal,aba21,aba24)", #TQC-A10060 add abaurig,abaorig    #FUN-840211 add aba11 #FUN-980001 add  #FUN-A10006 add abb21     #MOD-A80136 add aba24
              #" VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)" #FUN-840211 add ? #FUN-980001 mark
#             " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,? ,?,?,?,?,?,?)" #TQC-A10060 add ?,? #MOD-9C0299 add ?? #FUN-840211 add ? #FUN-980001 add     #FUN-A10006 add ?
              " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,? ,?,?,?,?,?)" #TQC-A10060 add ?,? #MOD-9C0299 add ?? #FUN-840211 add ? #FUN-980001 add     #FUN-A10006 add ? #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
     PREPARE p800_1_p7 FROM g_sql
 
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no1
     LET g_aba01t = gl_no1[1,g_doc_len]
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
 
    #----------------------  for ora修改 ------------------------------------
     LET g_system = 'LC'
     LET g_zero   = 0
     LET g_zero1  = '0'    #No:8657
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     CALL s_getlegal(g_plant_new) RETURNING l_legal
     LET g_aba.abalegal = l_legal #FUN-980001 add
     EXECUTE p800_1_p7 USING p_bookno1,gl_no1,gl_date,g_yy,g_mm,g_today,
                            g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero1,g_N,g_N, 
                            g_zero,g_Y,g_user,g_grup,g_today,
                            g_user,g_grup,         #MOD-9C0299 
                            g_aba.abasign,g_aba.abadays,
                            #g_aba.abaprit,g_aba.abasmax,g_zero,g_aba.aba11 #No.FUN-840211 add aba11 #FUN-980001 mark
                            g_aba.abaprit,g_aba.abasmax,g_zero,g_aba.aba11,g_aba.abalegal, #No.FUN-840211 add aba11 #FUN-980001 add
#                           g_aba.abaoriu,g_aba.abaorig      #TQC-A10060 add abaoriu,abaorig
                            l_npp.npp08,g_user     #FUN-A10006 add aba21 #MOD-A80136 add g_user
    #----------------------  for ora修改 ------------------------------------
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1
                            AND tmn06 = p_bookno1
     IF gl_no_b1 IS NULL THEN LET gl_no_b1 = gl_no1 END IF
     LET gl_no_e1 = gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     UPDATE npp_file SET npp03 = gl_date,nppglno = gl_no1,
                         npp06 = p_plant,npp07 = p_bookno1
      WHERE npp01 = l_npq.npq01
        AND npp011= l_npq.npq011
        AND npp00 = l_npq.npq00
        AND nppsys= l_npq.npqsys
        AND npptype = '1'
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","npp_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","upd npp03/glno1:",1)
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN
         DISPLAY "Seq:",l_seq AT 2,1
     END IF
    #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",    #FUN-A50102
     LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'),   #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
#                       " abb08,abb11,abb12,abb13,abb14,abb15,",                #FUN-810069
                        " abb08,abb11,abb12,abb13,abb14,",                      #FUN-810069
                        " abb24,abb25,",
                        #"abb31,abb32,abb33,abb34,abb35,abb36,abb37", #FUN-980001 mark
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal", #FUN-980001 add
                        " )",
#                " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",                #FUN-810069
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?",                  #FUN-810069
                 #"       ,?,?,?,?,?,?,?)" #FUN-980001 mark
                 "       ,?,?,?,?,?,?,?,?)" #FUN-980001 add
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
     CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
     PREPARE p800_1_p8 FROM g_sql
     EXECUTE p800_1_p8 USING 
                p_bookno1,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
#               l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25,                #FUN-810069
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                            #FUN-810069
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                #l_npq.npq35,l_npq.npq36,l_npq.npq37 #FUN-980001 mark
                l_npq.npq35,l_npq.npq36,l_npq.npq37,l_legal #FUN-980001 add
 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      IF g_bgjob = 'N'    THEN    #FUN-570112
          PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
      END IF
     #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 = ? ,aba09 = ? ",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'),     #FUN-A50102
                  "   SET aba08 = ? ,aba09 = ? ",    #FUN-A50102
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE p800_1_p9 FROM g_sql
      EXECUTE p800_1_p9 USING l_debit,l_credit,l_npp08,gl_no1,p_bookno1  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      #NO.FUN-570112 
      IF g_bgjob = 'N' THEN
          PRINT
      END IF
     CALL s_flows('2',p_bookno1,gl_no1,gl_date,g_N,'',TRUE)   #No.TQC-B70021
 
IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
     #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",   #FUN-A50102
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'abb_file'),
                  ",aag_file",    #FUN-A50102
                  " WHERE abb01 = '",gl_no1,"'",
                  "   AND abb00 = '",p_bookno1,"'",
                  "   AND abb03 = aag01  ",
                  "   AND aag20 = 'Y' ",
                  "   AND abb00 = aag00  "        #No.FUN-730064
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE count_pre1 FROM g_sql
      DECLARE count_cs1 CURSOR FOR count_pre1
      OPEN count_cs1 
      FETCH count_cs1 INTO g_cnt
      CLOSE count_cs1
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
        #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-850183 mark
        #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-850183 mark
         IF g_aba.abamksg='N' THEN                       #MOD-850183
            LET g_aba.aba20='1' 
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
#No.TQC-B70021 --begin 
            CALL s_chktic (p_bookno1,gl_no1) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end  
           #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",    #FUN-A50102
            LET g_sql = " UPDATE ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,", 
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",             #MOD-A80136
                               " aba37   = ?  ",             #MOD-A80136
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
            PREPARE upd_aba19_1 FROM g_sql
            EXECUTE upd_aba19_1 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user  ,                #MOD-A80136
                                    gl_no1       ,p_bookno1
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF     
       #No.FUN-CB0096 ---start--- Add
       #LET l_time = TIME          #FUN-D40105 mark
        LET l_time = l_time + 1    #FUN-D40105 add
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no1,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no1,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
 
     #LET gl_no1[4,12]=''                      #MOD-A80071 mark
      LET gl_no1[g_no_sp-1,g_no_ep]=''         #MOD-A80071
END REPORT
#No.FUN-680029 --end--
 
FUNCTION p800_chkdate()
    DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(600)
    DEFINE l_yy,l_mm  LIKE type_file.num5    #No.FUN-690028 SMALLINT
    DEFINE l_aaa07    LIKE aaa_file.aaa07    #MOD-990069                                                                            
    DEFINE l_npp02b   LIKE npp_file.npp02    #CHI-9A0021 add
    DEFINE l_npp02e   LIKE npp_file.npp02    #CHI-9A0021 add
    DEFINE l_correct  LIKE type_file.chr1    #CHI-9A0021 add
                                                                                                                                    
  #MOD-990069   ---start                                                                                                            
   IF g_npptype = '0' THEN                                                                                                          
      SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno                                                                
   ELSE                                                                                                                             
      SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno1                                                               
   END IF                                                                                                                           
   IF gl_date <= l_aaa07 THEN                                                                                                       
      IF g_bgjob = 'Y' THEN                                                                                                         
         CALL s_errmsg('','','','axr-164',1)                                                                                        
      ELSE                                                                                                                          
         CALL cl_err('','axr-164',0)                                                                                                
      END IF                                                                                                                        
      LET l_flag='X' RETURN                                                                                                         
   END IF                                                                                                                           
  #MOD-990069   ---end       
 
  #當月起始日與截止日
   #CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_npp02b,l_npp02e   #CHI-9A0021 add #CHI-A70005 mark
   #CHI-A70005 add --start--
   IF g_aza.aza63 = 'Y' THEN
      IF g_npptype = '0' THEN
         CALL s_azmm(YEAR(gl_date),MONTH(gl_date),g_apz.apz02p,g_apz.apz02b) RETURNING l_correct,l_npp02b,l_npp02e
      ELSE
         CALL s_azmm(YEAR(gl_date),MONTH(gl_date),g_apz.apz02p,g_apz.apz02c) RETURNING l_correct,l_npp02b,l_npp02e
      END IF
   ELSE   
      CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_npp02b,l_npp02e
   END IF
   #CHI-A70005 add --end--
 
   CASE g_source
     WHEN '1'  #預購會計(aapt720)
      #LET g_sql =" SELECT ala08,ala72,alafirm,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM ala_file,npp_file ",
                  "  WHERE ala01 = npp01 " ,
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (ala72 IS NULL OR ala72 =' ')  ",
                  "    AND  alafirm='Y' ",
                  "    AND npptype = '",g_npptype,"'",  #No.FUN-680029
                  "    AND npp00 = 4 AND npp011 = 0 "
     WHEN '2'  #到單(aapt820)
      #LET g_sql =" SELECT alh021,alh72,alhfirm,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM alh_file,npp_file ",
                  "  WHERE alh01 = npp01 ",
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (alh72 IS NULL OR alh72 =' ')  ",
                  "    AND  alhfirm='Y' ",
                  "    AND npptype = '",g_npptype,"'",  #No.FUN-680029
                  "    AND npp00 = 4 AND npp011 = 2 "
     WHEN '3'  #到貨(aapt810)
      #LET g_sql =" SELECT alk02,alk72,alkfirm,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM alk_file,npp_file ",
                  "  WHERE alk01 = npp01 ",
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (alk72 IS NULL OR alk72 =' ')  ",
                  "    AND  alkfirm='Y' ",
                  "    AND npptype = '",g_npptype,"'",  #No.FUN-680029
                  "    AND npp00 = 4 AND npp011 = 1 "
     WHEN '4'  #預購付款(aapt711)
      #LET g_sql =" SELECT ala08,ala74,ala78,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM ala_file,npp_file ",
                  "  WHERE ala01 = npp01 ",
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (ala74 IS NULL OR ala74 =' ')  ",
                  "    AND  ala78='Y' ",
                  "    AND npptype = '",g_npptype,"'",  #No.FUN-680029
                  "    AND npp00 = 5 AND npp011 = 0 "
     WHEN '5'  #預購修改(aapt740)
      #LET g_sql =" SELECT alc08,alc72,alcfirm,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM ala_file,alc_file,npp_file ",
                  "  WHERE alc01 = npp01 AND ala01 = alc01 ",
                  "    AND npp011= alc02 AND npp00 = 6 ",
                  "    AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (alc72 IS NULL OR alc72 =' ')  ",
                  "    AND  alcfirm='Y' ",
                  "    AND npptype = '",g_npptype,"'"   #No.FUN-680029
     WHEN '6'  #修改付款(aapt741)
      #LET g_sql =" SELECT alc08,alc74,alc78,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM ala_file,alc_file,npp_file ",
                  "  WHERE alc01 = npp01 AND ala01 = alc01 ",
                  "    AND npp011= alc02 AND npp00 = 7 ",
                  "    AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (alc74 IS NULL OR alc74 =' ')  ",
                  "    AND  alc78='Y' ",
                  "    AND alcfirm <> 'X' ",  #CHI-C80041
                  "    AND npptype = '",g_npptype,"'"   #No.FUN-680029
     WHEN '7'  #結案(aapt750)
      #LET g_sql =" SELECT ala08,ala75,alaclos,",
       LET g_sql =" SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                  "   FROM ala_file,npp_file ",
                  "  WHERE ala01 = npp01 AND npp00 = 9 AND npp011 = 0 ",
                 #CHI-9A0021 -- begin
                 #"    AND ( YEAR(npp02) != YEAR('",gl_date,"') ",
                 #"     OR  (YEAR(npp02)  = YEAR('",gl_date,"') ",
                 #"    AND   MONTH(npp02)!= MONTH('",gl_date,"'))) ",
                  "    AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                 #CHI-9A0021 -- end
                  "    AND (ala75 IS NULL or ala75 = ' ') ",
                  "    AND  alaclos='Y' ",
                  "    AND npptype = '",g_npptype,"'"   #No.FUN-680029
   END CASE
   LET g_sql = g_sql CLIPPED," AND nppsys = 'LC'  AND ",g_wc CLIPPED
 
   display g_sql
 
   PREPARE p800_prechk FROM g_sql
   IF STATUS THEN CALL cl_err('p800_prechk',STATUS,1) 
      LET l_flag='X' RETURN
   END IF
   DECLARE p800_chkdate CURSOR WITH HOLD FOR p800_prechk
   FOREACH p800_chkdate INTO l_yy,l_mm
      LET l_flag='Y' EXIT FOREACH
   END FOREACH
 
END FUNCTION
 
FUNCTION p800_create_tmp()
 DROP TABLE p800_tmp;
 #FUN-560011
 #No.TQC-9B0039  --Begin
 #SELECT space(16) order1, npp_file.*,npq_file.*,
 #       space(100) remark
 #  FROM npp_file,npq_file
 # WHERE npp01 = npq01 AND npp01 = '@@@@'
 #  INTO TEMP p800_tmp
 SELECT chr30 order1, npp_file.*,npq_file.*,
        chr1000 remark
   FROM npp_file,npq_file,type_file
  WHERE npp01 = npq01 AND npp01 = '@@@@'
    AND 1=0
   INTO TEMP p800_tmp
 #No.TQC-9B0039  --End  
 IF SQLCA.SQLCODE THEN
    LET g_success='N'
#   CALL cl_err('create p800_tmp:',SQLCA.SQLCODE,1)   #No.FUN-660122
    CALL cl_err3("ins","p800_tmp","","",SQLCA.sqlcode,"","create p800_tmp:",1)  #No.FUN-660122
 END IF
 DELETE FROM p800_tmp WHERE 1=1
#No.FUN-9B0070 --begin
{
# CREATE TEMP TABLE p800_tmp
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
#  npq05     VARCHAR(255),  #FUN-560011    
#  npq06     VARCHAR(255),  #FUN-560011      
#  npq07f    DEC(20,6)  not null,  #FUN-4B0079
#  npq07     DEC(20,6)  not null,  #FUN-4B0079
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
#  npq25     DEC(20,10)   not null, #FUN-4B0079
#  npq26     VARCHAR(01),   
#  npq27     VARCHAR(01),        
#  npq28     VARCHAR(01),       
#  npq29     VARCHAR(01),  
#  npq30     VARCHAR(10),
#  remark    VARCHAR(100)
#  )
}
#No.FUN-9B0070 --end
END FUNCTION
#CHI-AC0010
