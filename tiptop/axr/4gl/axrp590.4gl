# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axrp590.4gl
# Descriptions...: 應收傳票拋轉總帳作業
# Date & Author..: 97/05/29 By Sophia
# Modify.........: 97-07-22帳別以 user輸入為主                     
# Modify.........: copy aapp400
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-510051 05/01/10 By kitty gl_no_b/gl_no_e的欄位變數未清除, 導致連續執行時, 傳票列印錯誤
# Modify ........: No.MOD-530029 05/03/10 By kitty 程式沒有處裡傳票日期(gl_date)必須與單據日期同月份(npp02)之檢核  
# Modify ........: No.MOD-530509 05/05/17 By Smapmin 修正錯誤訊息顯示方式
# Modify.........: NO.FUN-560095 05/06/18 By ching  2.0功能修改
# Modify ........: No.FUN-560190 05/06/23 By wujie 單據編號修改,p_gz修改
# Modify ........: No.FUN-570090 05/08/01 By will 增加取得傳票缺號號碼的功能 
# Modify.........: No.MOD-5C0079 05/12/14 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-5C0015 06/01/02 BY GILL 多 INSERT 異動碼5~10, 關係人
# Modify.........: NO.MOD-5B0343 06/01/05 BY yiting  回寫"票據系統" anmt302的傳票編號(TT暫收流程) 不對
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.FUN-620021 06/03/27 By Sarah 取消ins_ar_ap_p590()
# Modify.........: No.FUN-660032 06/06/12 By rainy 拋轉摘要預設為"Y"
# Modify.........: No.FUN-660116 06/06/20 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改 
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670060 06/08/07 By Rayven 修正只能拋DEMO-1的BUG
# Modify.........: No.FUN-670047 06/08/15 By day 多帳套修改
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-680059 06/11/28 By Smapmin 總帳傳票日期空白者,依原分錄日期產生
# Modify.........: No.MOD-6A0097 06/11/28 By Smapmin modify FUN-680059
# Modify.........: No.FUN-710050 07/01/22 By bnlent  錯誤訊息匯整
# Modify.........: No.FUN-710049 07/01/31 By jamie QBE條件開窗點選單號 
# Modify.........: No.MOD-730107 07/03/23 By Smapmin 拋轉傳票入帶入申請人
# Modify.........: No.FUN-740009 07/04/02 By chenl   會計科目加帳套
# Modify.........: No.MOD-740097 07/04/22 By Smapmin 調整交易開始位置 
# Modify.........: No.MOD-740430 07/04/24 By Ray  不使用兩套帳時，傳票起訖單號不會出現
# Modify.........: No.MOD-740480 07/04/26 By Smapmin 分錄底稿日期若跨月,當傳票日期的條件為空白時,產生的傳票所屬的會計期別會有問題
# Modify.........: No.FUN-740220 07/04/27 By Elva 查詢開窗錯誤
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-770061 07/07/13 By Smampin 修改錯誤訊息
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 需簽核單別不可自動確認
# Modify.........: No.TQC-7B0090 07/11/15 By xufeng  憑証自動審核時,審核人欄位沒有值
# Modify.........: No.TQC-7B0103 07/11/16 By xufeng  會出現一個帳套拋轉成功，另一個帳套不成功的狀況
# Modify.........: No.FUN-810069 08/02/28 By yaofs 項目預算取消abb15的管控 
# Modify.........: No.MOD-820003 08/03/18 By Smapmin 開窗應過濾已拋轉傳票者
# Modify.........: No.MOD-840101 08/04/14 By Smapmin 檢核傳票編號是否有重複時,參數帶錯
# Modify.........: No.MOD-840608 08/04/23 By hellen  g_wc轉換,axrt300直接拋磚總帳，確認的問題
# Modify.........: No.MOD-850183 08/05/22 By Sarah 將IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF這行mark掉
# Modify.........: No.FUN-850140 08/06/09 By Sarah 當多角序號oma99<>null時,增加s_chknpq()功能
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.MOD-860265 08/07/16 By Sarah 當l_npp.nppsys='AR' AND l_npp.npp00=41 AND l_npq.npq011=0時,要將傳票號碼,傳票日期也寫到ole14,ole13
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.MOD-880081 08/08/13 By Sarah 還原FUN-620021處理
# Modify.........: No.MOD-920357 09/03/02 By chenl 若是背景執行,則應在執行前先判斷賬款日期是否小于關賬日期,若是則退出.
# Modify.........: No.MOD-930290 09/03/30 By Sarah 出貨(l_npp00='1')要拋傳票時,應檢查借方SUM(npq07f)=出貨單頭oga50,若不相等要show error
# Modify.........: No.MOD-940110 09/04/09 By lilingyu l_remark之前應增加判斷,避免造成科目空白而無法合并
# Modify.........: No.MOD-860216 09/05/26 By wujie  拋轉時備注欄位會有多余的空格
# Modify.........: No.TQC-970029 09/07/02 By wujie 宣告p590_1_p0時，多一個npq01
# Modify.........: No.TQC-970317 09/07/28 By Carrier 若g_success='N'時的報錯,需彈出
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980087 09/08/24 By mike 1.axr-058訊息增加顯示帳款編號,2.建立TempTable p590_tmp時,remark1應為CHAR(1000),   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-970247 09/07/27 By sabrina 支票轉暫收時應先判斷該單據別是否需拋轉傳票，不需要時才回寫傳票編號、日期
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數  
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.MOD-990216 09/10/09 By liuxqa 運行成功之后，繼續運行時，無法取到缺號，須將g_j重新置空。
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.MOD-9B0043 09/11/06 By lutingting 建臨時表p590_tmp報錯,因為建臨時表語法錯誤 
# Modify.........: No:FUN-9B0076 09/11/10 By wujie 5.2SQL转标准语法
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9C0138 09/12/17 By wujie 排除aapt330的分录底稿 
# Modify.........: No:MOD-9C0351 09/12/23 By Sarah user範圍預設成0~z
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-A10006 10/01/14 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No:FUN-A10089 10/01/19 By wujie  增加显示选取的缺号结果
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: NO.MOD-A70139 10/07/19 BY sabrina 將l_msg型態改為STRING
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: NO.TQC-A80087 10/08/17 BY xiaofeizhu 第二套張插入aba_file時多了值g_user，應去除
# Modify.........: NO.FUN-A60007 10/09/01 BY chenmoyan check oct_file更新傳票編號
# Modify.........: NO.MOD-A90032 10/09/06 BY Dido 作廢時已刪除 npp_file/npq_file 因此無須判斷作廢
# Modify.........: NO.TQC-AB0371 10/12/02 By chenying 輸入時選擇"語言"切換之後，就會自動離開QBE欄位，進入到INPUT欄# Modify.........: NO.TQC-AB0371 10/12/02 By chenying 輸入時選擇"語言"切換之後，就會自動離開QBE欄位，進入到INPUT欄位
# Modify.........: NO.MOD-AC0020 10/12/02 BY Dido 抓取 ar_date 規則,若結關日(oga021)為空時,改抓出貨日期(oga02) 
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:MOD-AC0267 10/12/23 By Dido axr-164 改為錯誤訊息彙總 
# Modify.........: NO.FUN-AB0110 10/12/03 BY yiting update oct08時,只取oma00 = '12'
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B70021 11/07/12 By wujie 抛转时自动产生tic资料
# Modify.........: No:MOD-B80046 11/08/03 By yinhy 拋轉時附件張數錯誤
# Modify.........: No:TQC-BC0069 11/12/12 By Sarah 修改FUNCTION ins_ar_ap_p590()傳入的變數型態
# Modify.........: No:MOD-C10020 12/12/15 By Polly 出貨單已確認，但未過帳，不可拋轉傳票
# Modify.........: No:TQC-C70073 12/07/11 By lujh aglt110作業中的【aba21】欄位類型應該是整型，而本作業axrp590拋轉過去的資料中aba21欄位卻顯示成0.0
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:CHI-D10022 13/02/05 By apo 若要拋轉傳票的單據來源是axrt400且其單頭nmg29='Y'(單據確認時會ins oma_file),應將產生的傳票號碼回寫至oma33
# Modify.........: No:FUN-C50011 13/03/11 By apo 增加"依會計科目彙總"的功能
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:MOD-D60016 13/06/04 By yinhy 背景作業下傳參時判斷如果gl_date為null就讓g_flag為Y
# Modify.........: No:MOD-DB0101 13/11/14 By yinhy 科目無法合併
# Modify.........: No:yinhy131115 13/11/15 By yinhy 用戶預設10個z

IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_npp        	RECORD LIKE npp_file.*
DEFINE g_aba        	RECORD LIKE aba_file.*
DEFINE g_aac        	RECORD LIKE aac_file.*
DEFINE l_ooz        	RECORD LIKE ooz_file.*     #No.FUN-670047
DEFINE g_wc,g_sql   	string                     #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21       #No.FUN-680123 VARCHAR(21)
DEFINE g_plant_gl 	LIKE type_file.chr21       #No.FUN-980059 VARCHAR(21)
DEFINE no_sep		LIKE type_file.chr3        #No.FUN-680123 VARCHAR(3) # 傳票單號彙總選擇
DEFINE gl_no	    	LIKE aba_file.aba01        #No.FUN-680123 VARCHAR(16)    # 傳票單號     #No.FUN-560190
DEFINE gl_no1	    	LIKE aba_file.aba01        #No.FUN-680123 VARCHAR(16)    # 傳票單號     #No.FUN-670047
DEFINE gl_no_b,gl_no_e	LIKE aba_file.aba01        #No.FUN-680123 VARCHAR(16)    # Generated 傳票單號 (Begin no and End no)   #No.FUN-560190
DEFINE gl_no_b_b,gl_no_e_e	LIKE aba_file.aba01      #No.FUN-680123 VARCHAR(16)    #No.FUN-670047
DEFINE gl_no_b1,gl_no_e1	LIKE aba_file.aba01      #No.FUN-680123 VARCHAR(16)    #No.FUN-670047
DEFINE gl_date		LIKE type_file.dat         #No.FUN-680123 DATE
DEFINE g_yy,g_mm	LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE p_plant          LIKE azp_file.azp01        #No.FUN-680123 VARCHAR(12)	
DEFINE l_plant_old      LIKE azp_file.azp01        #No.FUN-680123 VARCHAR(12)    #No.FUN-570090  --add 
DEFINE p_bookno         LIKE aaa_file.aaa01        #No.FUN-670039
DEFINE p_bookno1        LIKE aaa_file.aaa01	   #No.FUN-670047
DEFINE gl_tran		LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
DEFINE g_AR_AP		LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
DEFINE gl_seq    	LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)         # 傳票區分項目
DEFINE b_user,e_user	LIKE aba_file.abauser      #No.FUN-680123 VARCHAR(10)
DEFINE g_statu      	LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
DEFINE g_aba01t     	LIKE aba_file.aba01        #No.FUN-560190
DEFINE l_flag           LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
DEFINE g_t1         	LIKE ooy_file.ooyslip      #No.FUN-680123 VARCHAR(5)                   #No.FUN-560190
DEFINE g_aaz85          LIKE aaz_file.aaz85       #傳票是否自動確認 no.3432
DEFINE   g_cnt          LIKE type_file.num10       #No.FUN-680123 INTEGER   
DEFINE   g_i            LIKE type_file.num5        #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   g_j            LIKE type_file.num5        #No.FUN-680123 SMALLINT   #No.FUN-570090  --add     
DEFINE   g_change_lang  LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)   #是否有做語言切換 No.FUN-570156
DEFINE   g_flag         LIKE type_file.chr1   #MOD-6A0097 
DEFINE gl_summary       LIKE type_file.chr1        #FUN-C50011 add
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add
DEFINE g_aag44          LIKE aag_file.aag44   #FUN-D40118 add
DEFINE p_bookno2        LIKE aaa_file.aaa01   #FUN-D40118 add 
 
MAIN
   DEFINE ls_date       STRING    #No.FUN-570156 
   DEFINE l_flag        LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)   #No.FUN-570156 
   DEFINE l_tmn02       LIKE tmn_file.tmn02        #No.FUN-670068 
   DEFINE l_tmn06       LIKE tmn_file.tmn06        #No.FUN-670068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET g_wc     = cl_replace_str(g_wc, "\\\"", "'")   #MOD-840608 add
   LET b_user   = ARG_VAL(2)             #輸入user範圍
   LET e_user   = ARG_VAL(3)             #輸入user範圍
   LET p_plant  = ARG_VAL(4)             #總帳營運中心編號
   LET p_bookno = ARG_VAL(5)             #總帳帳別編號
   LET gl_no    = ARG_VAL(6)             #總帳傳票單別
   LET ls_date  = ARG_VAL(7)             #總帳傳票日期
   LET gl_date  = cl_batch_bg_date_convert(ls_date)
   #No.MOD-D60016  --Begin
   IF  cl_null(gl_date) THEN
       LET g_flag = 'Y' 
   END IF
   #No.MOD-D60016  --End
   LET gl_tran  = ARG_VAL(8)             #應拋轉摘要
   LET gl_seq   = ARG_VAL(9)             #傳票彙總方式
   LET g_bgjob = ARG_VAL(10)    #背景作業
   LET p_bookno1= ARG_VAL(11)             #No.FUN-680028
   LET gl_no1   = ARG_VAL(12)             #No.FUN-680028

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
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
 
   DROP TABLE agl_tmp_file  
   CREATE TEMP TABLE agl_tmp_file     
   (tc_tmp00 LIKE type_file.chr1 NOT NULL,  
    tc_tmp01 LIKE type_file.num5,           
    tc_tmp02 LIKE type_file.chr20, 
    tc_tmp03 LIKE aba_file.aba00)  
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      EXIT PROGRAM
   END IF   
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-670047               
   IF STATUS THEN CALL cl_err('create index',STATUS,0)
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      EXIT PROGRAM
   END IF  

    DECLARE tmn_del CURSOR FOR
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y' 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #No.FUN-6A0095

   WHILE TRUE
      IF g_bgjob = "N" THEN
         LET g_success = 'Y'   #MOD-740097
         CALL p590_create_tmp()  #No.TQC-7B0103
         BEGIN WORK   #MOD-740097
         LET g_j = 0         #No.MOD-990216 add
         CALL p590_ask()

         IF cl_sure(18,20) THEN 
            CALL cl_wait()

            LET g_ooz.ooz02b = p_bookno    # 得帳別
            LET g_ooz.ooz02c = p_bookno1   # 得帳別  #No.FUN-670047

            OPEN WINDOW axrp590_t_w9 WITH 3 ROWS, 70 COLUMNS 
            CALL cl_set_win_title("axrp590_t_w9")

            CALL p590_t('0')    #拋第一套帳
            IF g_aza.aza63='Y' AND g_success='Y' THEN
               call p590_t('1') #拋第二套帳
            END IF
            CLOSE WINDOW axrp590_t_w9
            CALL s_showmsg()       #No.FUN-710050
            IF g_success = 'Y' THEN
               COMMIT WORK
               IF  NOT cl_null(gl_no_b_b) THEN   #genero
                   CALL s_m_prtgl(g_plant_gl,g_ooz.ooz02b,gl_no_b_b,gl_no_e_e)  #FUN-990069
               END IF
               If g_aza.aza63='Y' THEN
                  IF NOT cl_null(gl_no_b1) THEN  
                     CALL s_m_prtgl(g_plant_gl,g_ooz.ooz02c,gl_no_b1,gl_no_e1)   #FUN-990069
                  END IF
               END IF
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p590
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p590_create_tmp()  #No.TQC-7B0103
         BEGIN WORK
         LET g_ooz.ooz02b = p_bookno    # 得帳別
         LET g_ooz.ooz02c = p_bookno1   # 得帳別  #No.FUN-670047
         CALL p590_t('0')    #拋第一套帳
         IF g_aza.aza63='Y' AND g_success='Y' THEN
            call p590_t('1') #拋第二套帳
         END IF
         CALL s_showmsg()    #No.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
            IF NOT cl_null(gl_no_b_b) THEN   #genero
               CALL s_m_prtgl(g_plant_gl,g_ooz.ooz02b,gl_no_b_b,gl_no_e_e)  #FUN-990069
            END IF
            IF g_aza.aza63='Y' THEN        #若使用多帳套,則打印第二帳
               IF NOT cl_null(gl_no_b1) THEN  
                  CALL s_m_prtgl(g_plant_gl,g_ooz.ooz02c,gl_no_b1,gl_no_e1)#FUN-990069
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
 #No.FUN-CB0096 ---start--- add
  LET l_time = TIME
  LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
  CALL s_log_data('U','100',g_id,'1',l_time,'','')
 #No.FUN-CB0096 ---end  --- add

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION p590()
   CALL p590_ask()	# Ask for first_flag, data range or exist_no
   IF INT_FLAG THEN RETURN END IF
   IF cl_sure(21,21) THEN   #genero
   CALL cl_wait()
      LET g_ooz.ooz02b = p_bookno    # 得帳別
      
      OPEN WINDOW axrp590_t_w9 WITH 3 ROWS, 70 COLUMNS 
      CALL cl_set_win_title("axrp590_t_w9")
      
      CALL p590_t('0')    #only for compiler No.FUN-670047
   END IF
   CLOSE WINDOW axrp590_t_w9
END FUNCTION
 
FUNCTION p590_ask()
   DEFINE   li_result        LIKE type_file.num5        #No.FUN-680123  SMALLINT   #No.FUN-560190
   DEFINE   l_aaa07          LIKE aaa_file.aaa07
   DEFINE   l_abapost,l_flag LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1) 
   DEFINE   l_cnt            LIKE type_file.num5        #No.FUN-680123 SMALLINT  #No.FUN-570090  -add 
   DEFINE   lc_cmd           LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(500)     #No.FUN-570156
   DEFINE   li_chk_bookno    LIKE type_file.num5,       #No.FUN-680123 SMALLINT,   #No.FUN-670006
            li_chk_bookno1   LIKE type_file.num5,       #No.FUN-680123 SMALLINT,   #No.FUN-670067
            l_sql            STRING                     #No.FUN-670006  -add
   DEFINE   l_tmn02          LIKE tmn_file.tmn02        #No.FUN-670068 
   DEFINE   l_tmn06          LIKE tmn_file.tmn06        #No.FUN-670068 
  #DEFINE   l_npp00          VARCHAR(2)                 #FUN-710049 add  #TQC-BC0069 mark
   DEFINE   l_npp00          LIKE type_file.chr2        #FUN-710049 add  #TQC-BC0069
   DEFINE   l_no             LIKE type_file.chr3        #No.FUN-840125                
   DEFINE   l_no1            LIKE type_file.chr3        #No.FUN-840125                
   DEFINE   l_aac03          LIKE aac_file.aac03        #No.FUN-840125 
   DEFINE   l_aac03_1        LIKE aac_file.aac03        #No.FUN-840125 
#No.FUN-A10089 --begin
   DEFINE   l_chr1           LIKE type_file.chr20
   DEFINE   l_chr2           STRING
#No.FUN-A10089 --end

   OPEN WINDOW p590 WITH FORM "axr/42f/axrp590" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
    
   IF g_aza.aza63 != 'Y' THEN 
      CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)  
   END IF
   WHILE TRUE
#No.FUN-A10089 --begin
   LET l_chr2 =' '  
   DISPLAY ' ' TO chr2   
#No.FUN-A10089 --end
   CONSTRUCT BY NAME g_wc ON npp00,npp01,npp011,npp02 
 
      AFTER FIELD npp00
           CALL FGL_DIALOG_GETBUFFER() 
           RETURNING l_npp00
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npp01) #查詢單號
                  IF l_npp00 IS NULL THEN 
                     NEXT FIELD npp00 
                  END IF
 
                  IF l_npp00 = '1' THEN   #出貨
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_oga04"   #MOD-820003
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO npp01
                     NEXT FIELD npp01
                  END IF
                 IF l_npp00 = '2' THEN    #立帳
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oma7"              #FUN-740220   #MOD-820003
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
                 IF l_npp00 = '3' THEN    #沖帳
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ooa1"   #MOD-820003
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
                 IF l_npp00 = '41' THEN   #L/C收狀
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ola2"   #MOD-820003
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
                 IF l_npp00 = '42' THEN   #L/C修改
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ole1"   #MOD-820003
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
                 IF l_npp00 = '43' THEN   #L/C押匯
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_olc1"   #MOD-820003
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
#TQC-AB0371--------mod--------------str-----------
#     ON ACTION locale                    #genero
#        LET g_change_lang = TRUE                   #No.FUN-570156FUN-570156
#        EXIT CONSTRUCT
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT 
#TQC-AB0371--------mod--------------end-------------
       ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#TQC-AB0371--------mod--------------str-----------
#  IF g_change_lang THEN
#     LET g_change_lang = FALSE
#     CALL cl_dynamic_locale()
#     CALL cl_show_fld_cont()
#  END IF
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
#TQC-AB0371--------mod--------------end-------------
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p590 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET p_plant = g_ooz.ooz02p 
   LET l_plant_old = p_plant      #No.FUN-570090  --add 
   LET p_bookno   = g_ooz.ooz02b 
   LET p_bookno1  = g_ooz.ooz02c  #No.FUN-670047
   LET b_user  = '0'   #MOD-9C0351 mod #g_user
   #LET e_user  = 'z'   #MOD-9C0351 mod #g_user
   LET e_user  = 'zzzzzzzzzz'    #yinhy131115  
   LET gl_date = g_today
   LET gl_tran = 'Y' #No.FUN-660032 add
   LET gl_seq  = '0'
   LET g_bgjob = "N"              #No.FUN-570156
   LET gl_summary = 'Y'           #FUN-C50011 add 
 
  #INPUT BY NAME b_user,e_user,p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,gl_tran,gl_seq,g_bgjob  #FUN-C50011 mark  #No.FUN-570156  #No.FUN-670047
   INPUT BY NAME b_user,e_user,p_plant,p_bookno,gl_no,                 #FUN-C50011 add
                 p_bookno1,gl_no1,gl_date,gl_tran,gl_summary,          #FUN-C50011 add
                 gl_seq,g_bgjob                                        #FUN-C50011 add 
       WITHOUT DEFAULTS   ATTRIBUTE(UNBUFFERED)  #No.FUN-570090  --add UNBUFFERED
 
      AFTER FIELD p_plant
         SELECT *  FROM azw_file WHERE azw01 = p_plant 
            AND azw02 = g_legal
         IF STATUS <> 0 THEN
            CALL cl_err('sel_azw','agl-171',0) #FUN-990031
            NEXT FIELD p_plant
         END IF
         # 得出總帳 database name 
         LET g_plant_new= p_plant    # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
         IF l_plant_old != p_plant THEN          
            FOREACH tmn_del INTO l_tmn02,l_tmn06 
               DELETE FROM tmn_file  
               WHERE tmn01 = p_plant_old 
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
             LET g_plant_new= p_plant 
                 #CALL s_getdbs()          #FUN-A50102
                 LET l_sql = "SELECT COUNT(*)",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                             " WHERE aaa01 = '",p_bookno,"' ",
                             "   AND aaaacti IN ('Y','y') "
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE p590_pre2 FROM l_sql
                 DECLARE p590_cur2 CURSOR FOR p590_pre2
                 OPEN p590_cur2
                 FETCH p590_cur2 INTO g_cnt 
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno
         END IF
      AFTER FIELD p_bookno1
         IF p_bookno1 IS NULL THEN
            NEXT FIELD p_bookno1
         END IF
         IF p_bookno1 = p_bookno  THEN
            NEXT FIELD p_bookno1
         END IF
         CALL s_check_bookno(p_bookno1,g_user,p_plant) 
              RETURNING li_chk_bookno1
         IF (NOT li_chk_bookno1) THEN
              NEXT FIELD p_bookno1
         END IF 
         LET g_plant_new= p_plant 
             #CALL s_getdbs()              #FUN-A50102
             LET l_sql = "SELECT COUNT(*)",
                         #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                         "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                         " WHERE aaa01 = '",p_bookno1,"' ",
                         "   AND aaaacti IN ('Y','y') "
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
             PREPARE p590_pre3 FROM l_sql
             DECLARE p590_cur3 CURSOR FOR p590_pre3
             OPEN p590_cur3
             FETCH p590_cur3 INTO g_cnt 
         IF g_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD p_bookno1
         END IF
 
      AFTER FIELD gl_no1
         CALL s_check_no("agl",gl_no1,"","1","aba_file","aba01",p_plant)    #MOD-840101 #No.FUN-980094
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
         CALL s_check_no("agl",gl_no,"","1","aba_file","aba01",p_plant)    #MOD-840101 #No.FUN-980094
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
         IF NOT cl_null(gl_date) THEN
            SELECT aaa07 INTO l_aaa07 FROM aaa_file 
             WHERE aaa01 = p_bookno
            IF gl_date <= l_aaa07 THEN    
               CALL cl_err('','axr-164',0)    #MOD-770061
               NEXT FIELD gl_date
            END IF
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
             WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)   #No.FUN-660116
               NEXT FIELD gl_date
            END IF
        #-MOD-AC0267-mark-
        #ELSE
        #   CALL chk_date()
        #   IF g_success = 'N' THEN
        #      NEXT FIELD gl_date
        #   ELSE   #MOD-6A0097
        #      LET g_flag = 'Y'   #MOD-6A0097
        #   END IF
        #-MOD-AC0267-end-
         END IF
 
      AFTER FIELD gl_seq  
         IF cl_null(gl_seq) OR gl_seq NOT MATCHES '[0123]' THEN
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
         IF gl_no IS NULL or gl_no = ' ' THEN
            LET l_flag='Y'
         END IF
         IF cl_null(gl_date) THEN
            LET g_flag = 'Y'
         END IF
         IF cl_null(gl_tran)    THEN
            LET l_flag='Y'
         END IF
        #----------------FUN-C50011------------------(S)
         IF cl_null(gl_summary) THEN  
            LET l_flag='Y'            
         END IF                       
        #----------------FUN-C50011------------------(E)
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
         IF NOT cl_null(gl_date) THEN   #FUN-680059
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
             WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)   #No.FUN-660116
               NEXT FIELD gl_date
            END IF
         END IF   #FUN-680059
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION CONTROLP
         IF INFIELD(gl_no) THEN
                 CALL s_getdbs()                                                                                                    
                 LET g_dbs_gl=g_dbs_new                                                                                             
                 LET g_plant_gl= p_plant   #No.FUN-980059                                                                                             
            CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')   #No.FUN-840125  #No.FUN-980059
            RETURNING gl_no
            DISPLAY BY NAME gl_no
            NEXT FIELD gl_no
         END IF
         IF INFIELD(gl_no1) THEN
            CALL s_getdbs()                                                                                                    
            LET g_dbs_gl=g_dbs_new                                                                                             
            CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL')    #No.FUN-840125  #No.FUN-980059
            RETURNING gl_no1
            DISPLAY BY NAME gl_no1
            NEXT FIELD gl_no1
         END IF
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p590 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axrp590"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('axrp590','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",b_user CLIPPED,"'",
                      " '",e_user CLIPPED,"'",
                      " '",p_plant CLIPPED,"'",
                      " '",p_bookno CLIPPED,"'",
                      " '",gl_no CLIPPED,"'",
                      " '",gl_date CLIPPED,"'",
                      " '",gl_tran CLIPPED,"'",
                      " '",gl_seq CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",p_bookno1 CLIPPED,"'",   #No.FUN-670047
                      " '",gl_no1 CLIPPED,"'"       #No.FUN-670047
                     ," '",gl_summary CLIPPED,"'"          #FUN-C50011 add 
         CALL cl_cmdat('axrp590',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p590
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
#============================== 逐張拋轉 ======================================
FUNCTION p590_t(l_npptype)  #No.FUN-670047
   DEFINE l_npptype       LIKE npp_file.npptype  #No.FUN-670047
   DEFINE g_cnt1          LIKE type_file.num10   #No.FUN-680123 INTEGER                #No.FUN-670047
   DEFINE l_sql           STRING                 #No.FUN-670047
   DEFINE l_npp		  RECORD LIKE npp_file.*
   DEFINE l_npq		  RECORD LIKE npq_file.*
   DEFINE l_cus           LIKE oma_file.oma03    #No:9469
   DEFINE l_order	  LIKE npp_file.npp01    #No.FUN-680123 VARCHAR(30)
   DEFINE l_order2        LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(100)
   DEFINE l_name	  LIKE type_file.chr20   #No.FUN-680123 VARCHAR(20)
   DEFINE l_post          LIKE type_file.chr1    #No.FUN-680123 VARCHAR(01)
   DEFINE l_remark   	  LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(150)  #No.7319
   DEFINE l_cmd      	  LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(30)
  #DEFINE l_msg           LIKE type_file.chr8    #No.FUN-680123 VARCHAR(80)   #MOD-A70139 mark
   DEFINE l_msg           STRING                 #MOD-A70139 add 
   DEFINE ar_date	  LIKE type_file.dat     #No.FUN-680123 DATE
   DEFINE ar_glno	  LIKE oga_file.oga907   #No.FUN-680123 VARCHAR(16)
   DEFINE ar_conf	  LIKE oga_file.ogaconf  #No.FUN-680123 VARCHAR(1)
   DEFINE ar_user  	  LIKE oga_file.ogauser  #No.FUN-680123 VARCHAR(10)
   DEFINE l_yy,l_mm       LIKE type_file.num5    #No.FUN-680123 SMALLINT
   DEFINE l_flag          LIKE type_file.chr1    #No.FUN-680123 VARCHAR(01)
   DEFINE l_oma99         LIKE oma_file.oma99    #FUN-850140 add
   DEFINE l_aba11         LIKE aba_file.aba11    #FUN-840211
   DEFINE l_aaa07         LIKE aaa_file.aaa07    #No.MOD-920357
   DEFINE sum_npq07f      LIKE npq_file.npq07f   #MOD-930290 add
   DEFINE l_oga50         LIKE oga_file.oga50    #MOD-930290 add
   DEFINE l_oga02         LIKE oga_file.oga02    #MOD-AC0020
   DEFINE l_npp01         LIKE npp_file.npp01    #MOD-B80046
   DEFINE l_yy1           LIKE type_file.num5    #CHI-CB0004
   DEFINE l_mm1           LIKE type_file.num5    #CHI-CB0004  
   CALL s_showmsg_init()  #MOD-AC0267 mark 
   #因為若user在input未經傳票日期欄位即按ESC時,會未讀取azn_file
   IF NOT cl_null(gl_date) THEN   #FUN-680059   
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
           CALL cl_err('','axr-164',1)      #No.TQC-970317
        END IF
         LET g_success = 'N'
         RETURN
      END IF
      IF g_aza.aza63 = 'Y' THEN
         IF l_npptype = '0' THEN
            #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",
            LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(p_plant,'aznn_file'), #FUN-A50102           
                        "  WHERE aznn01 = '",gl_date,"' ",                               
                        "    AND aznn00 = '",p_bookno,"' "                            
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
            PREPARE aznn_pre1 FROM l_sql                                                 
            DECLARE aznn_cs1 CURSOR FOR aznn_pre1                                        
            OPEN aznn_cs1                                                               
            FETCH aznn_cs1 INTO g_yy,g_mm
         ELSE
            #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",
            LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(p_plant,'aznn_file'), #FUN-A50102            
                        "  WHERE aznn01 = '",gl_date,"' ",                               
                        "    AND aznn00 = '",p_bookno1,"' "                            
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
            PREPARE aznn_pre2 FROM l_sql                                                 
            DECLARE aznn_cs2 CURSOR FOR aznn_pre2                                        
            OPEN aznn_cs2                                                               
            FETCH aznn_cs2 INTO g_yy,g_mm
         END IF
      ELSE
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
             WHERE azn01 = gl_date
      END IF
      IF STATUS THEN
          CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",1)   #No.FUN-660116  #No.TQC-970317
          LET g_success = 'N'  #No.TQC-7B0103
          RETURN
      END IF
   ELSE
     #CALL chk_date()     #MOD-AC0267 mark
      CALL p590_chkdate() #MOD-AC0267
      IF g_success = 'N' THEN
         CALL cl_err('read azn:',SQLCA.sqlcode,1)  #No.TQC-970317
         RETURN
      END IF
   END IF
 
  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   IF NOT cl_null(gl_date) THEN   #FUN-680059
      LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) FROM npp_file ",
                " WHERE nppsys= 'AR' ",
                "   AND (nppglno IS NULL OR nppglno=' ') ",
                "   AND ( YEAR(npp02)  !=YEAR('",gl_date,"') OR ",
                "        (YEAR(npp02)   =YEAR('",gl_date,"') AND ",
                "         MONTH(npp02) !=MONTH('",gl_date,"'))) ",
                "   AND npptype = '",l_npptype,"' AND ",g_wc CLIPPED #No.FUN-670047
      PREPARE p590_0_p0 FROM g_sql
      IF STATUS THEN
         CALL cl_err('p590_0_p0',STATUS,1)
         CALL cl_batch_bg_javamail("N")       #No.FUN-570156
         LET g_success = 'N'  #No.TQC-7B0103
        #No.FUN-CB0096 ---start--- add
         LET l_time = TIME
         LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
         CALL s_log_data('U','100',g_id,'1',l_time,'','')
        #No.FUN-CB0096 ---end  --- add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE p590_0_c0 CURSOR WITH HOLD FOR p590_0_p0
      LET l_flag='N' 
      FOREACH p590_0_c0 INTO l_yy,l_mm
         LET l_flag='Y'  EXIT FOREACH
      END FOREACH
      IF l_flag ='Y' THEN
         CALL cl_err('err:','axr-061',1)
         LET g_success = 'N' #No.FUN-570156 
         RETURN
      END IF
  END IF   #FUN-680059
 
  IF g_aaz.aaz81 = 'Y' THEN
     LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
     IF g_aza.aza63 = 'Y' THEN 
        IF l_npptype = '0' THEN
           #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102 
                       " WHERE aba00 =  '",p_bookno,"'"
                      ,"   AND aba19 <> 'X' "  #CHI-C80041 
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
        ELSE
     	     #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",
             LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102 
                       " WHERE aba00 =  '",p_bookno1,"'"
                      ,"   AND aba19 <> 'X' "  #CHI-C80041 
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
        END IF
         
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
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
 
 
  #no.3432 (是否自動傳票確認)
  #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",
  LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(p_plant,'aaz_file'), #FUN-A50102 
              " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
  PREPARE aaz85_pre FROM g_sql
  DECLARE aaz85_cs CURSOR FOR aaz85_pre
  OPEN aaz85_cs 
  FETCH aaz85_cs INTO g_aaz85
  IF STATUS THEN 
     CALL cl_err('sel aaz85',STATUS,1)
     LET g_success = 'N' #No.FUN-570156 
     RETURN
  END IF
 
   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             "  FROM npp_file,npq_file",
             " WHERE nppsys= 'AR' ",
             "   AND (nppglno IS NULL OR nppglno=' ') ",
             "   AND nppsys = npqsys",      
             "   AND npp00 = npq00 ",
             "   AND npp01 = npq01 AND npp011=npq011",
             "   AND npptype = npqtype AND npptype='",l_npptype,"' ",  #No.FUN-670047
             "   AND ",g_wc CLIPPED
   CASE WHEN gl_seq = '0' 
        LET g_sql = g_sql CLIPPED," ORDER BY npq06,npq03,npq05,npq24,npq25"
        WHEN gl_seq = '1' 
       LET g_sql = g_sql CLIPPED," ORDER BY npq01,npq06,npq03,npq05,npq24,npq25"
        WHEN gl_seq = '2'
       LET g_sql = g_sql CLIPPED," ORDER BY npq02,npq06,npq03,npq05,npq24,npq25"
        WHEN gl_seq = '3'
       LET g_sql = g_sql CLIPPED," ORDER BY npq21,npq06,npq03,npq05,npq24,npq25"
        OTHERWISE 
        LET g_sql = g_sql CLIPPED," ORDER BY npq06,npq03,npq05,npq24,npq25"
   END CASE
   IF gl_tran = 'N' THEN 
        LET g_sql = g_sql CLIPPED,",npq11,npq12,npq13,npq14,npq15,npq08"    #No.TQC-970029
   ELSE
        LET g_sql = g_sql CLIPPED,",npq04,npq11,npq12,npq13,npq14,npq15,npq08"    #No.TQC-970029
   END IF
   PREPARE p590_1_p0 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p590_1_p0',STATUS,1)
      CALL cl_batch_bg_javamail("N")    #No.FUN-570156
      LET g_success = 'N'  #No.TQC-7B0103
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p590_1_c0 CURSOR WITH HOLD FOR p590_1_p0
 
   CALL cl_outnam('axrp590') RETURNING l_name
   IF l_npptype = '0' THEN
      START REPORT axrp590_rep TO l_name
   ELSE
      START REPORT axrp590_1_rep TO l_name
   END IF
   LET g_success = 'Y'
   LET g_cnt1 = 0 #No.FUN-670047
   WHILE TRUE
     #CALL s_showmsg_init()    #No.FUN-710050    #MOD-AC0267 mark 
      FOREACH p590_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
            CALL s_errmsg('','','foreach:',STATUS,1) 
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
         IF g_success='N' THEN                                                                                                        
            LET g_totsuccess='N'                                                                                                      
            LET g_success="Y"                                                                                                         
         END IF                                                                                                                       
 
        #當多角序號oma99<>null時,增加s_chknpq()功能
         SELECT oma99 INTO l_oma99 FROM oma_file WHERE oma01=l_npp.npp01
         IF NOT cl_null(l_oma99) THEN
            CALL s_chknpq(l_npp.npp01,l_npp.nppsys,1,'0',p_bookno)
            IF g_aza.aza63 ='Y' THEN
               CALL s_chknpq(l_npp.npp01,l_npp.nppsys,1,'1',p_bookno1)
            END IF
         END IF
 
         #檢查若單據性質設為不拋轉傳票則不能拋轉
         CALL s_get_doc_no(l_npp.npp01) RETURNING g_t1        #No.FUN-560190
         SELECT ooydmy1 INTO l_post FROM ooy_file
          WHERE ooyslip = g_t1
         IF l_post = 'N' THEN CONTINUE FOREACH END IF
 
         CASE WHEN l_npp.nppsys='AR' AND l_npp.npp00=1
                   LET l_oga50 = 0   #MOD-930290 add
                  #FUN-A60056--mod--str--
                  #SELECT oga02,oga907,ogaconf,ogauser,oga03,oga50       #No:9469  #MOD-930290 add oga50
                  #  INTO ar_date,ar_glno,ar_conf,ar_user,l_cus,l_oga50  #No:9469  #MOD-930290 add l_oga50
                  #  FROM oga_file WHERE oga01=l_npp.npp01
                   LET g_sql = "SELECT oga02,oga021,oga907,ogaconf,ogauser,oga03,oga50",        #MOD-AC0020 add oga021
                               "  FROM ",cl_get_target_table(l_npq.npq30,'oga_file'),
                               " WHERE oga01='",l_npp.npp01,"'",
                               "   AND ogapost = 'Y' "                                          #MOD-C10020 add
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,l_npq.npq30) RETURNING g_sql
                   PREPARE sel_oga02 FROM g_sql
                  #EXECUTE sel_oga02 INTO ar_date,ar_glno,ar_conf,ar_user,l_cus,l_oga50         #MOD-AC0020 mark
                   EXECUTE sel_oga02 INTO l_oga02,ar_date,ar_glno,ar_conf,ar_user,l_cus,l_oga50 #MOD-AC0020
                  #FUN-A60056--mod--end
                   IF STATUS THEN
                      #CALL cl_err('','axr-001',1)                           #MOD-AC0267 mark  
                       CALL s_errmsg('','','','axr-001',1)                   #MOD-AC0267
                       LET g_success='N'   #MOD-530509
                   END IF
                  #-MOD-AC0020-add-
                   IF cl_null(ar_date) THEN
                      LET ar_date = l_oga02
                   END IF 
                  #-MOD-AC0020-end-
                  #出貨要拋傳票時,應檢查借方SUM(npq07f)=出貨單頭oga50,不相等要show error
                   IF cl_null(l_oga50) THEN LET l_oga50=0 END IF
                   LET sum_npq07f = 0
                   SELECT SUM(npq07f) INTO sum_npq07f FROM npq_file
                    WHERE npqsys=l_npp.nppsys AND npqtype=l_npp.npptype
                      AND npq00 =l_npp.npp00  AND npq01  =l_npp.npp01
                      AND npq011=l_npp.npp011 AND npq06  ='1'   #借方
                   IF cl_null(sum_npq07f) THEN LET sum_npq07f=0 END IF
                   IF sum_npq07f != l_oga50 THEN
                      LET g_showmsg=l_npp.npp01,":",sum_npq07f,"<>",l_oga50
                      CALL s_errmsg("oga01,npq07f,oga50",g_showmsg,"","axr-509",1)
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='AR' AND l_npp.npp00=2
                   SELECT oma02,oma33,omaconf,omauser,oma03      #No:9469
                     INTO ar_date,ar_glno,ar_conf,ar_user,l_cus  #No:9469
                     FROM oma_file WHERE oma01=l_npp.npp01
                   IF STATUS THEN
                      #CALL cl_err('','axr-002',1)                           #MOD-AC0267 mark
                       CALL s_errmsg('','','','axr-002',1)                   #MOD-AC0267
                       LET g_success='N'   #MOD-530509
                   END IF
              WHEN l_npp.nppsys='AR' AND l_npp.npp00=3
                   SELECT ooa02,ooa33,ooaconf,ooauser,ooa03      #No:9469
                     INTO ar_date,ar_glno,ar_conf,ar_user,l_cus  #No:9469
                     FROM ooa_file WHERE ooa01=l_npp.npp01
                   IF STATUS THEN
                      #CALL cl_err('','axr-003',1)                           #MOD-AC0267 mark
                       CALL s_errmsg('','','','axr-003',1)                   #MOD-AC0267
                       LET g_success='N'   #MOD-530509
                   END IF
              WHEN l_npp.nppsys='AR' AND l_npp.npp00=41
                   SELECT ola02,ola28,olaconf,olauser,ola05      #No:9469
                     INTO ar_date,ar_glno,ar_conf,ar_user,l_cus  #No:9469
                     FROM ola_file WHERE ola01=l_npp.npp01
                   IF STATUS THEN
                      #CALL cl_err('','axr-004',1) LET g_success='N'   #MOD-530509 #MOD-AC0267 mark
                       CALL s_errmsg('','','','axr-004',1)                         #MOD-AC0267
                       LET g_success='N'                                           #MOD-AC0267
                   END IF
                   IF l_npq.npq011=0 THEN
                      UPDATE ole_file SET ole14=gl_no,ole13=gl_date
                       WHERE ole01 = l_npq.npq01 AND ole02 = l_npq.npq011
                      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                        #CALL cl_err3("upd","ole_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd ole",1)   #No.FUN-660116  #No.TQC-970317  #MOD-AC0267 mark
                         CALL s_errmsg('','','upd ole',SQLCA.sqlcode,1)                                                               #MOD-AC0267
                         LET g_success = 'N'
                      END IF
                   END IF
              WHEN l_npp.nppsys='AR' AND l_npp.npp00=42 
                   SELECT ole09,ole14,oleconf,oleuser
                     INTO ar_date,ar_glno,ar_conf,ar_user
                     FROM ole_file WHERE ole01=l_npp.npp01
                                     AND ole02=l_npp.npp011
                   IF STATUS THEN
                      #CALL cl_err('','axr-005',1) LET g_success='N'   #MOD-530509 #MOD-AC0267 mark
                       CALL s_errmsg('','','','axr-005',1)                         #MOD-AC0267
                       LET g_success = 'N'                                         #MOD-AC0267
                   END IF
              WHEN l_npp.nppsys='AR' AND l_npp.npp00=43 
                   SELECT olc12,olc23,olcconf,olcuser,olc05       #No:9469
                     INTO ar_date,ar_glno,ar_conf,ar_user,l_cus   #No:9469
                     FROM olc_file 
                    WHERE olc29=l_npp.npp01 AND olc28 = l_npp.npp011
                   IF STATUS THEN
                       CALL s_errmsg('','','','axr-006',1)
                       LET g_success ='N'
                   END IF
              OTHERWISE CONTINUE FOREACH
         END CASE
         IF ar_conf='N' THEN CONTINUE FOREACH END IF
        #IF ar_conf='X' THEN CONTINUE FOREACH END IF                   #MOD-A90032 mark
         IF cl_null(ar_conf) THEN CONTINUE FOREACH END IF                    #MOD-C10020 add
         IF ar_user<b_user OR ar_user>e_user THEN CONTINUE FOREACH END IF
         IF l_npp.npp011=1 AND ar_date<>l_npp.npp02 THEN
            LET l_msg= "Date differ:",ar_date,'-',l_npp.npp02,
                       "  * Press any key to continue ..."
            CALL cl_msgany(19,4,l_msg)
            LET INT_FLAG = 0  ######add for prompt bug
         END IF
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         IF l_npq.npq05 = ' ' THEN LET l_npq.npq05 = NULL END IF   #MOD-940110         
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
          IF cl_null(l_cus) THEN LET l_cus=l_npq.npq21  END IF   #No:9469
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_npp.npp01 # 依單號
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 # 依日期
              WHEN gl_seq = '3' LET l_order = l_cus       # 依客戶 No:9469
              OTHERWISE         LET l_order = ' '
         END CASE
        #-------------FUN-C50011--------------(S)
         IF gl_summary='Y' THEN
            LET l_order2 = 0
         ELSE
            LET l_order2 = l_npq.npq02
         END IF
        #-------------FUN-C50011--------------(E)
        #INSERT INTO p590_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)             #FUN-C50011 mark
         INSERT INTO p590_tmp VALUES(l_order,l_order2,l_npp.*,l_npq.*,l_remark)    #FUN-C50011 add
           IF SQLCA.SQLCODE THEN
               #CALL cl_err3("ins","p590_tmp",l_order,"",STATUS,"","l_order:",1)   #No.FUN-660116 #MOD-AC0267 mark
                CALL s_errmsg('','','l_order:',STATUS,1)                                          #MOD-AC0267
                LET g_success ='N'                                                                #MOD-AC0267
           END IF
           LET g_cnt1 = g_cnt1 + 1   #No.FUN-670047
      END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
                
         #------------------------------FUN-C50011------------------------(S)
         #-FUN-C50011-----mark
         #DECLARE p590_tmpcs CURSOR FOR 
         #     SELECT * FROM p590_tmp
         #     ORDER BY order1,npp01,npq06,npq03,npq05,   #MOD-B80046 add npp01
         #              npq24,npq25,remark1,npq01
         #-FUN-C50011-----mark
          IF gl_summary='Y' THEN
             #依據會科合併時,如有多張帳款需要合併時,應先以科目為優先排序,帳款單號於最後再排序
            #No.MOD-DB0101  --Mark Begin
            #IF g_aza.aza26=2 THEN                                                            
            #   LET g_sql = "SELECT * FROM p590_tmp",
            #               #"  ORDER BY order1,order2,npp01,npq06,npq03,npq05, ",  
            #               "  ORDER BY order1,order2,npq06,npq03,npq05, ",               #MOD-DB0101
            #               "           npq24,npq25,remark,npq01                "         
            #ELSE 
            #No.MOD-DB0101  --Mark End                                                                         
                LET g_sql = "SELECT * FROM p590_tmp",                                     
                            "  ORDER BY order1,order2,npq06,npq03,npq05, ",        
                            "           npq24,npq25,remark,npq01                "         
            #END IF     #No.MOD-DB0101  --Mark                                                                   
          ELSE   
             #No.MOD-DB0101  --Mark Begin
             #IF g_aza.aza26=2 THEN                                                        
             #   LET g_sql = "SELECT * FROM p590_tmp",
             #               "  ORDER BY order1,npp01,npq06,order2,npq03, ",        
             #               "           npq05,npq24,npq25,remark                "
             #ELSE
             #No.MOD-DB0101  --Mark End                                                                         
                LET g_sql = "SELECT * FROM p590_tmp",                                     
                            "  ORDER BY order1,npq06,order2,npq03, ",              
                            "           npq05,npq24,npq25,remark                "         
             #END IF  #No.MOD-DB0101  --Mark                                                                     
          END IF
          PREPARE p590_tmpp FROM g_sql
          DECLARE p590_tmpcs CURSOR WITH HOLD FOR p590_tmpp
         #------------------------------FUN-C50011------------------------(E)
          LET l_npp01 = NULL   #MOD-B80046
         #FOREACH p590_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark                 #FUN-C50011 mark
          FOREACH p590_tmpcs INTO l_order,l_order2,l_npp.*,l_npq.*,l_remark        #FUN-C50011 add
              IF STATUS THEN
                  CALL s_errmsg('','','order:',STATUS,1) 
                  LET g_success ='N'                       #MOD-AC0267
                  EXIT FOREACH
              END IF
               IF g_success='N' THEN                                                                                                        
                 LET g_totsuccess='N'                                                                                                      
                 LET g_success="Y"                                                                                                         
               END IF                                                                                                                       
               
              LET l_order =l_order CLIPPED    #No.MOD-860216 
      
              #MOD-B80046  --Begin
              IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
                 LET l_npp.npp08 = 0
              END IF
              LET l_npp01 = l_npp.npp01
              #MOD-B80046  --End

              IF l_npptype = '0' AND l_npp.npptype = '0' THEN
                #OUTPUT TO REPORT axrp590_rep(l_order,l_npp.*,l_npq.*,l_remark)             #FUN-C50011 mark
                 OUTPUT TO REPORT axrp590_rep(l_order,l_order2,l_npp.*,l_npq.*,l_remark)    #FUN-C50011 add
                 CALL p590_chk_oct(l_npp.*,g_aba.aba01)  #FUN-A60007 add
              END IF
              IF l_npptype = '1' AND l_npp.npptype = '1' THEN
                #OUTPUT TO REPORT axrp590_1_rep(l_order,l_npp.*,l_npq.*,l_remark)           #FUN-C50011 mark
                 OUTPUT TO REPORT axrp590_1_rep(l_order,l_order2,l_npp.*,l_npq.*,l_remark)  #FUN-C50011 add 
                 CALL p590_chk_oct(l_npp.*,g_aba.aba01)  #FUN-A60007 add
              END IF
          END FOREACH  
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
      
      EXIT WHILE
   END WHILE
   IF l_npptype = '0' THEN
      FINISH REPORT axrp590_rep 
   ELSE
      FINISH REPORT axrp590_1_rep 
   END IF
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009 
   IF g_cnt1 = 0  THEN                                                          
      CALL s_errmsg('','','','aap-129',1)                                               
      LET g_success = 'N'      
   END IF             
END FUNCTION
 
#REPORT axrp590_rep(l_order,l_npp,l_npq,l_remark)                           #FUN-C50011 mark
REPORT axrp590_rep(l_order,l_order2,l_npp,l_npq,l_remark)                   #FUN-C50011 add
  DEFINE l_order    LIKE npp_file.npp01        #No.FUN-680123 VARCHAR(30)
  DEFINE l_order2   LIKE npp_file.npp01        #FUN-C50011 add
  DEFINE l_npp	    RECORD LIKE npp_file.*
  DEFINE l_npq	    RECORD LIKE npq_file.*
  DEFINE l_seq	    LIKE type_file.num5        #No.FUN-680123   SMALLINT #傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6   #No.FUN-680123  DEC(20,6)  #FUN-4C0013
  DEFINE l_remark   LIKE type_file.chr1000     #No.FUN-680123    VARCHAR(150)   #No.7319
  DEFINE l_p1       LIKE aba_file.aba06        #No.FUN-680123    VARCHAR(02)
  DEFINE l_p2       LIKE type_file.num5        #No.FUN-680123    SMALLINT
  DEFINE l_p3       LIKE type_file.chr1        #No.FUN-680123    VARCHAR(01)
  DEFINE l_p4       LIKE type_file.chr1        #No.FUN-680123    VARCHAR(01)
  DEFINE li_result      LIKE type_file.num5    #No.FUN-680123    SMALLINT   #No.FUN-560190
  DEFINE l_missingno    LIKE aba_file.aba01    #No.FUN-570090    --add  
  DEFINE l_flag1        LIKE type_file.chr1    #No.FUN-680123    VARCHAR(1)              #No.FUN-570090  --add
  DEFINE ls_msg      LIKE type_file.chr50    #MOD-980087
  DEFINE l_npp08    LIKE npp_file.npp08      #MOD-A80017 Add         
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021 
     
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                    l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   BEFORE GROUP OF l_order
   IF g_flag = 'Y' THEN 
      LET gl_date = l_npp.npp02 
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=gl_date   #MOD-740480
   END IF   #MOD-6A0097
 
    LET g_plant_new= p_plant  # 工廠編號 
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new CLIPPED
 
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
     #No.FUN-CB0096 ---start---   Add
      LET t_no = Null
      CALL s_log_check(l_npq.npq01) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET gl_no = t_nO
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---start---   Add
     CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",g_ooz.ooz02b) #No.FUN-980094
        RETURNING li_result,gl_no
      END IF   #No.FUN-CB0096   Add
 
     PRINT "Get max TR-no:",gl_no," Return code(li_result):",li_result
     IF li_result = 0 THEN LET g_success = 'N' END IF
     IF g_bgjob = "N" THEN             #No.FUN-570156
        MESSAGE    "Insert G/L voucher no:",gl_no
        CALL ui.Interface.refresh() 
     END IF                            #No.FUN-570156
     PRINT "Insert aba:",g_ooz.ooz02b,' ',gl_no,' From:',l_order
   END IF  #No.FUN-570090  -add     
     #LET g_sql="INSERT INTO ",g_dbs_gl CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
                        " abamksg,abapost,",
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal,abaoriu,abaorig,aba21)", #FUN-A10036    #FUN-840211 add aba11   #MOD-730107 #FUN-980011 add   FUN-A10006 add aba21
                 " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?)" #FUN-A10036  #FUN-840211 add aba11  #MOD-730107 #FUN-980011 add  FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p590_1_p4 FROM g_sql
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
     LET l_p1='AR'
     LET l_p2='0'
     LET l_p3='N'
     LET l_p4='Y'
     #TQC-C70073--add--str--
     IF cl_null(l_npp.npp08) THEN
        LET l_npp.npp08 = '0'
     END IF
     #TQC-C70073--add--end--
     EXECUTE p590_1_p4 USING g_ooz.ooz02b,gl_no,gl_date,g_yy,g_mm,g_today,
                             l_p1,l_order,l_p2,l_p2,l_p3,l_p3,l_p2,
                             g_aba.abamksg,l_p3,
                             l_p2,l_p4,g_user,g_grup,g_today,
                 g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,g_user,g_aba.aba11,g_legal,g_user,g_grup,l_npp.npp08 #FUN-A10036   #FUN-840211 add aba11   #MOD-730107 #FUN-980011 add   FUN-A10006 add npp08
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570090  --add      
                            AND tmn06 = p_bookno #No.FUN-670047
     IF gl_no_b_b IS NULL THEN LET gl_no_b_b = gl_no END IF      #No.MOD-740430
     LET gl_no_e_e = gl_no      #No.MOD-740430
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF  #FUN-680059
     LET g_AR_AP = '0'
     #----------------------------------------- update傳票號回源頭檔案
     CASE WHEN l_npp.nppsys='AR' AND l_npp.npp00=1
              #FUN-A60056--mod--str--
              #UPDATE oga_file SET oga907=gl_no WHERE oga01=l_npp.npp01
               LET g_sql = "UPDATE ",cl_get_target_table(l_npq.npq30,'oga_file'),
                           " SET oga907='",gl_no,"'",
                           " WHERE oga01='",l_npp.npp01,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_npq.npq30) RETURNING g_sql
               PREPARE upd_oga FROM g_sql
               EXECUTE upd_oga
              #FUN-A60056--mod--end
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","oga_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd oga",1)   #No.FUN-660116  #No.TQC-970317
                  LET g_success = 'N'
               END IF
          WHEN l_npp.nppsys='AR' AND l_npp.npp00=2
               UPDATE oma_file SET oma33=gl_no WHERE oma01 = l_npq.npq01
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","oma_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd oma",1)   #No.FUN-660116  #No.TQC-970317
                  LET g_success = 'N'
               END IF
          WHEN l_npp.nppsys='AR' AND l_npp.npp00=3
               UPDATE ooa_file SET ooa33=gl_no WHERE ooa01 = l_npq.npq01
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","ooa_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd oma",1)   #No.FUN-660116  #No.TQC-970317
                  LET g_success = 'N'
               END IF
               #-No.3024 99/03/02 modify加入AP/AR之間帳務處理
               LET g_npp.* = l_npp.*
               CALL p590_upglno(l_npq.npq01,3,gl_no,l_npp.npp02,l_npp.npp011)
          WHEN l_npp.nppsys='AR' AND l_npp.npp00=41
               UPDATE ola_file SET ola28=gl_no,ola33=gl_date
                WHERE ola01 = l_npq.npq01 AND ola011= l_npq.npq011
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","ola_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd ola",1)   #No.FUN-660116  #No.TQC-970317
                  LET g_success = 'N'
               END IF
          WHEN l_npp.nppsys='AR' AND l_npp.npp00=42
               UPDATE ole_file SET ole14=gl_no ,ole13=gl_date
                WHERE ole01 = l_npq.npq01 AND ole02 = l_npq.npq011
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","ole_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd ole",1)   #No.FUN-660116  #No.TQC-970317
                  LET g_success = 'N'
               END IF
          WHEN l_npp.nppsys='AR' AND l_npp.npp00=43
               UPDATE olc_file SET olc23=gl_no ,olc24=gl_date
                WHERE olc29=l_npp.npp01 AND olc28 = l_npp.npp011
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","olc_file",l_npp.npp01,"",SQLCA.sqlcode,"","upd olc",1)   #No.FUN-660116  #No.TQC-970317
                  LET g_success = 'N'
               END IF
     END CASE
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no,
                         npp06 = p_plant,npp07=p_bookno
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype = '0'  #No.FUN-670047
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   #No.FUN-660116
        LET g_success = 'N'
     END IF
     IF g_AR_AP = '1' THEN
        UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no,
                            npp06 = p_plant,npp07=p_bookno
         WHERE npp01 = l_npp.npp01
           AND npp011= l_npp.npp011
           AND npp00 = 3          
           AND nppsys= 'AP'
           AND npptype = '0' #No.FUN-670047
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   #No.FUN-660116
           LET g_success = 'N'
        END IF
     END IF
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
      IF g_bgjob = "N" THEN        #No.FUN-570156
         MESSAGE   "Seq:",l_seq 
         CALL ui.Interface.refresh() 
      END IF                       #No.FUN-570156
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,abb24,abb25,",                   #No.FUN-810069
                        
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
 
                        ",abblegal )", #FUN-980011 add
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?",                           #No.FUN-810069
                 "       ,?,?,?,?,?,?,?, ?)" #FUN-5C0015 BY GILL
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p590_1_p5 FROM g_sql
     EXECUTE p590_1_p5 USING 
                g_ooz.ooz02b,gl_no,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                          #No.FUN-810069
 
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,
                g_legal #FUN-980011 add
 
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",gl_no,l_seq,SQLCA.sqlcode,"","ins abb:",1)   #No.FUN-660116
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      IF l_debit<>l_credit THEN    #BUGNO:021219
         LET ls_msg = l_npq.npq01,' :l_debit<>l_credit' #MOD-980087     
         CALL cl_err(ls_msg CLIPPED,'axr-058',1) LET g_success = 'N' #MOD-980087   
      END IF
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED,"aba_file SET aba08=?,aba09 =? ",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
                    " SET aba08=?,aba09 =? ",
                    "    ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE p590_1_p6 FROM g_sql
      EXECUTE p590_1_p6 USING l_debit,l_credit,l_npp08,gl_no,g_ooz.ooz02b    #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aba_file",gl_no,g_ooz.ooz02b,SQLCA.sqlcode,"","upd aba08/09:",1)   #No.FUN-660116
         LET g_success = 'N'
      END IF
      PRINT
#no.3432 自動確認
#No.TQC-B70021 --begin 
      CALL s_flows('2',g_ooz.ooz02b,gl_no,gl_date,'N','',TRUE)   
#No.TQC-B70021 --end
IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'abb_file')," ,aag_file", #FUN-A50102
                  " WHERE abb01 = '",gl_no,"'",
                  "   AND abb00 = '",g_ooz.ooz02b,"'",
                  "   AND abb03 = aag01  ",
                  "   AND aag00 = abb00 ",             #No.FUN-740009
                  "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE count_pre FROM g_sql
      DECLARE count_cs CURSOR FOR count_pre
      OPEN count_cs 
      FETCH count_cs INTO g_cnt
      CLOSE count_cs
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
         IF g_aba.abamksg='N' THEN   #No.TQC-7B0090
            LET g_aba.aba20='1' 
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (g_ooz.ooz02b,gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end 
            LET g_sql = " UPDATE ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,", 
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",
                               " aba37   = ?  ",   #No.TQC-7B0090
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba19 FROM g_sql
            EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user,     #No.TQC-7B0090
                                    gl_no        ,g_ooz.ooz02b
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","aba_file",gl_no,g_ooz.ooz02b,STATUS,"","upd aba19",1)   #No.FUN-660116
               LET g_success = 'N'   
            END IF
         END IF   #MOD-770101
      END IF
END IF     
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,g_aba.aba01,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,g_aba.aba01,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      LET gl_no[g_no_sp,g_no_ep]=''     #No.FUN-560190
END REPORT
 
FUNCTION p590_upglno(p_no,p_type,p_glno,p_date,p_no1)
 DEFINE p_no    LIKE npq_file.npq01
 DEFINE p_no1   LIKE npp_file.npp011
 DEFINE p_glno  LIKE nme_file.nme12
 DEFINE p_date  LIKE nmi_file.nmi02
 DEFINE p_type  LIKE type_file.num5        #No.FUN-680123 SMALLINT
 DEFINE l_t     LIKE nmy_file.nmyslip      #No.FUN-680123 VARCHAR(5)     #NO.MOD-5B0343 ADD
 DEFINE l_nmydmy3  LIKE nmy_file.nmydmy3   #NO.MOD-5B0343 ADD
 DEFINE l_oob   RECORD LIKE oob_file.*
 
    CASE WHEN p_type = 1    #收貨
         WHEN p_type = 3    #沖帳
           DECLARE oob_curs CURSOR FOR
            SELECT * FROM oob_file WHERE oob01 = p_no
           FOREACH oob_curs INTO l_oob.*
              IF STATUS THEN 
                 CALL cl_err('foreach',STATUS,1) LET g_success = 'N'  #No.TQC-970317
                 EXIT FOREACH
              END IF
               #-----------支票轉暫收--------------------------
               LET l_t = s_get_doc_no(l_oob.oob06)
               SELECT nmydmy3 INTO l_nmydmy3
                 FROM nmy_file WHERE nmyslip = l_t
               IF l_oob.oob03 = '1' AND l_oob.oob04 ='1' AND l_nmydmy3 = 'N'
               THEN 
                   UPDATE nmh_file SET nmh33 = gl_no,
                                       nmh34 = gl_date
                                 WHERE nmh01 = l_oob.oob06 
                   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
                      CALL cl_err3("upd","nmh_file",l_oob.oob06,"",SQLCA.sqlcode,"","upd nmh_file",1)   #No.FUN-660116  #No.TQC-970317
                      LET g_success = 'N' EXIT FOREACH 
                   END IF 
               END IF
               #-----------T/T 轉暫收--------------------------
               LET l_t = s_get_doc_no(l_oob.oob06)
               SELECT nmydmy3 INTO l_nmydmy3
                 FROM nmy_file WHERE nmyslip = l_t
               IF l_oob.oob03 = '1' AND l_oob.oob04 ='2' AND l_nmydmy3 = 'N'
               THEN 
                   UPDATE nmg_file SET nmg13 = gl_no,
                                       nmg14 = gl_date
                                 WHERE nmg00 = l_oob.oob06 
                   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","nmg_file",l_oob.oob06,"",SQLCA.sqlcode,"","upd nmg_file",1)   #No.FUN-660116  #No.TQC-970317
                        LET g_success = 'N' EXIT FOREACH 
                   END IF 
                   UPDATE nme_file SET nme16 = gl_date,
                                       nme10 = gl_no  #NO:4230
                                 WHERE nme12 = l_oob.oob06 
                   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","nme_file",l_oob.oob06,"",SQLCA.sqlcode,"","upd nme_file",1)   #No.FUN-660116  #No.TQC-970317
                      LET g_success = 'N' EXIT FOREACH 
                   END IF 
               END IF
               IF l_oob.oob04 ='9'    #NO.B263 mod
               THEN 
                   LET g_AR_AP = '1'            #0,未使用 AR-AP 1.有使用
		   UPDATE apf_file SET apf44 = gl_no,
				       apf43 = gl_date
                                 WHERE apf01 = p_no
                   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","apf_file",p_no,"",SQLCA.sqlcode,"","upd apf_file",1)   #No.FUN-660116
                      LET g_success = 'N' EXIT FOREACH 
                   END IF 
   		   #CALL ins_ar_ap_p590('AR',3,p_no,p_no1)   #FUN-620021 mark   #MOD-880081 mark回復   #yinhy130626
               END IF
              #str CHI-D10022 add
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM oma_file
                WHERE oma01=l_oob.oob06 AND oma00='24' 
               IF g_cnt > 0 THEN
                  UPDATE oma_file SET oma33=gl_no
                   WHERE oma01=l_oob.oob06 AND oma00='24' 
                  IF STATUS THEN
                     CALL s_errmsg('oma00',l_oob.oob06,'up oma_file',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  END IF
               END IF
              #end CHI-D10022 add
 
           END FOREACH 
       OTHERWISE EXIT CASE 
       END CASE 
END FUNCTION
 
FUNCTION ins_ar_ap_p590(l_sys,l_type,l_no,l_no1)
   #DEFINE l_sys    CHAR(02)                  #TQC-BC0069 mark
   #DEFINE l_type   CHAR(02)                  #TQC-BC0069 mark
   #DEFINE l_no     CHAR(16)  #No.FUN-560190  #TQC-BC0069 mark
   #DEFINE l_no1    SMALLINT                  #TQC-BC0069 mark
    DEFINE l_sys    LIKE npq_file.npqsys      #TQC-BC0069
    DEFINE l_type   LIKE npq_file.npqtype     #TQC-BC0069
    DEFINE l_no     LIKE npq_file.npq01       #TQC-BC0069
    DEFINE l_no1    LIKE npp_file.npp011      #TQC-BC0069
    DEFINE l_npq    RECORD LIKE npq_file.*
    DEFINE l_npp    RECORD LIKE npp_file.*
    DEFINE l_cnt    INTEGER
    DEFINE l_apa06  LIKE apa_file.apa06
    DEFINE l_apa07  LIKE apa_file.apa07
    DEFINE l_flag   LIKE type_file.chr1    #FUN-D40118 add
 
    LET l_npp.*      = g_npp.*
    LET l_npp.nppsys = 'AP'
    SELECT COUNT(*) INTO g_cnt FROM npp_file WHERE npp01 =g_npp.npp01 AND nppsys ='AR'
    IF g_cnt >1 THEN
       RETURN
    END IF
    #No.B262 010328 add 若己存在則不insert 
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
     FROM npp_file
     WHERE npp01 = l_npp.npp01
       AND npp011=l_npp.npp011
       AND nppsys=l_npp.nppsys
       AND npp00=l_npp.npp00
    IF l_cnt IS NOT NULL AND l_cnt > 0 THEN
       RETURN 
    END IF
 
    LET l_npp.npplegal = g_legal #FUN-980011 add
    INSERT INTO npp_file VALUES(l_npp.*)
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('ins ap:npp',SQLCA.SQLCODE,1)  #No.TQC-970317
         LET g_success = 'N'
         RETURN
    END IF
    DECLARE aap_curs CURSOR FOR
     SELECT *  FROM npq_file WHERE npq01  = l_no 
                               AND npqsys = 'AR'
                               AND npq00  = 3
                               AND npq011 = 1
    FOREACH aap_curs INTO l_npq.* 
            LET l_npq.npqsys = 'AP'
            SELECT apa06,apa07 INTO l_apa06,l_apa07 FROM apa_file
             WHERE apa01=l_npq.npq23
            IF SQLCA.SQLERRD[3] !=0 THEN
               IF NOT cl_null(l_apa06) THEN LET l_npq.npq21=l_apa06 END IF
               IF NOT cl_null(l_apa07) THEN LET l_npq.npq22=l_apa07 END IF
            END IF
            LET l_npq.npqlegal = g_legal #FUN-980011 add
            #FUN-D40118--add--str--
            IF l_npq.npqtype='0' THEN
               LET p_bookno2 = p_bookno
            ELSE
               LET p_bookno2 = p_bookno1
            END IF
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = p_bookno2
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,p_bookno2) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES(l_npq.*)
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err('ins ap:npq',SQLCA.SQLCODE,1)  #No.TQC-970317
               LET g_success = 'N'
               EXIT FOREACH
            END IF
    END FOREACH
END FUNCTION
 
FUNCTION p590_create_tmp()
 DROP TABLE p590_tmp;
#SELECT chr30 order1, npp_file.*,npq_file.*,chr1000 remark1     #FUN-C50011 mark     #MOD-9B0043
 SELECT chr30 order1, npq02 order2,npp_file.*,npq_file.*,       #FUN-C50011 add
        chr1000 remark                                          #FUN-C50011 add 
   FROM npp_file,npq_file,type_file  
 #WHERE 1 = 2   #FUN-C50011 mark
  WHERE npp01 = npq01 AND npp01 = '@@@@' AND npp00 = npq00      #FUN-C50011 add
    AND 1=0                                                     #FUN-C50011 add
   INTO TEMP p590_tmp
 IF SQLCA.SQLCODE THEN
    LET g_success='N'
    CALL cl_err3("ins","p590_tmp","","",SQLCA.sqlcode,"","create p590_tmp",1)   #No.FUN-660116  #No.TQC-970317
 END IF
 DELETE FROM p590_tmp WHERE 1=1
 LET gl_no_b_b=gl_no_b   #No.FUN-670047
 LET gl_no_e_e=gl_no_e   #No.FUN-670047
 LET gl_no_b=''
 LET gl_no_e=''
 LET gl_no_b1='' #No.FUN-670047
 LET gl_no_e1='' #No.FUN-670047
END FUNCTION
 
#REPORT axrp590_1_rep(l_order,l_npp,l_npq,l_remark)                                #FUN-C50011 mark
REPORT axrp590_1_rep(l_order,l_order2,l_npp,l_npq,l_remark)                        #FUN-C50011 add
  DEFINE l_order	LIKE  npp_file.npp01       #No.FUN-680123 VARCHAR(30)
  DEFINE l_order2	LIKE  npp_file.npp01       #FUN-C50011 add
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5        # 傳票項次 #No.FUN-680123 SMALLINT
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)  #FUN-4C0013
  DEFINE l_remark       LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(150)   #No.7319
  DEFINE l_p1           LIKE aba_file.aba18        #No.FUN-680123 VARCHAR(02)
  DEFINE l_p2           LIKE type_file.num5        #No.FUN-680123 SMALLINT
  DEFINE l_p3           LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
  DEFINE l_p4           LIKE type_file.chr1        #No.FUN-680123 VARCHAR(01)
  DEFINE   li_result    LIKE type_file.num5        #No.FUN-680123 SMALLINT   #No.FUN-560190
  DEFINE l_missingno    LIKE aba_file.aba01  #No.FUN-570090  --add  
  DEFINE l_flag1        LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)              #No.FUN-570090  --add
  DEFINE ls_msg         LIKE type_file.chr50    #MOD-980087
  DEFINE l_npp08        LIKE npp_file.npp08     #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021
        
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 #ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,              #FUN-C50011 mark
  ORDER BY          l_order,l_order2,l_npq.npq06,l_npq.npq03,l_npq.npq05,     #FUN-C50011 add
                    l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   BEFORE GROUP OF l_order
   IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF  #FUN-680059
 
    LET g_plant_new= p_plant  # 工廠編號 
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new CLIPPED
 
   LET l_flag1='N'              
   LET l_missingno = NULL      
   LET g_j=g_j+1              
   SELECT tc_tmp02 INTO l_missingno            
     FROM agl_tmp_file                         
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'    
      AND tc_tmp03=p_bookno1  
   IF NOT cl_null(l_missingno) THEN         
      LET l_flag1='Y'                      
      LET gl_no1=l_missingno               
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1         
                                AND tc_tmp03 = p_bookno1 
   END IF                     
                             
   IF l_flag1='N' THEN              
 
     #No.FUN-CB0096 ---start---   Add
      LET t_no = Null
      CALL s_log_check(l_npq.npq01) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET gl_no1 = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---start---   Add
     CALL s_auto_assign_no("agl",gl_no1,gl_date,"1","","",p_plant,"",g_ooz.ooz02c) #No.FUN-980094
        RETURNING li_result,gl_no1
      END IF   #No.FUN-CB0096   Add
 
     PRINT "Get max TR-no:",gl_no1," Return code(li_result):",li_result
     IF li_result = 0 THEN LET g_success = 'N' END IF
     IF g_bgjob = "N" THEN             #No.FUN-570156
        MESSAGE    "Insert G/L voucher no:",gl_no1
        CALL ui.Interface.refresh() 
     END IF                            #No.FUN-570156
     PRINT "Insert aba:",g_ooz.ooz02c,' ',gl_no1,' From:',l_order
   END IF  #No.FUN-570090  -add     
     #LET g_sql="INSERT INTO ",g_dbs_gl CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,",
                        " abamksg,abapost,",
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal,abaoriu,abaorig,aba21)", #FUN-Z10036    #FUN-840211 add aba11   #MOD-730107 #FUN-980011 add FUN-A10006 add aba21
                 " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?)" #FUN-A10036 #FUN-840211 add aba11 #MOD-730107 #FUN-980011 add  FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql#FUN-A50102
     PREPARE p590_1_p4_1 FROM g_sql
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
     LET l_p1='AR'
     LET l_p2='0'
     LET l_p3='N'
     LET l_p4='Y'
     #TQC-C70073--add--str--
     IF cl_null(l_npp.npp08) THEN
        LET l_npp.npp08 = '0'
     END IF
     #TQC-C70073--add--end--     
     EXECUTE p590_1_p4_1 USING g_ooz.ooz02c,gl_no1,gl_date,g_yy,g_mm,g_today,
                             l_p1,l_order,l_p2,l_p2,l_p3,l_p3,l_p2,
                             g_aba.abamksg,l_p3,
                             l_p2,l_p4,g_user,g_grup,g_today,
                 g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,g_user   #MOD-730107
#                ,g_aba.aba11,g_legal,g_user,g_user,g_grup,l_npp.npp08 #FUN-A10036   #FUN-840211 add aba11 #FUN-980011 add  FUN-A10006 add npp08 #TQC-A80087 Mark
                 ,g_aba.aba11,g_legal,g_user,g_grup,l_npp.npp08        #TQC-A80087 Add
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
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF  #FUN-680059
     LET g_AR_AP = '0'
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no1,
                         npp06 = p_plant,npp07=p_bookno1
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype = '1'
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   #No.FUN-660116
        LET g_success = 'N'
     END IF
     IF g_AR_AP = '1' THEN
        UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no1,
                            npp06 = p_plant,npp07=p_bookno1
         WHERE npp01 = l_npp.npp01
           AND npp011= l_npp.npp011
           AND npp00 = 3          
           AND nppsys= 'AP'
           AND l_npptype = '1'
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   #No.FUN-660116
           LET g_success = 'N'
        END IF
     END IF
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
      IF g_bgjob = "N" THEN        #No.FUN-570156
         MESSAGE   "Seq:",l_seq 
         CALL ui.Interface.refresh() 
      END IF                       #No.FUN-570156
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,abb24,abb25,",                   #No.FUN-810069
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37,",
                        " abblegal)", #FUN-980011 add
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?",                             #No.FUN-810069
                 "       ,?,?,?,?,?,?,?, ?)" #FUN-5C0015 BY GILL #FUN-980011 add
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p590_1_p5_1 FROM g_sql
     EXECUTE p590_1_p5_1 USING 
                g_ooz.ooz02c,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                           #No.FUN-810069
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,g_legal      #FUN-980011 add
 
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",gl_no1,l_seq,SQLCA.sqlcode,"","ins abb:",1)   #No.FUN-660116
        LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      IF l_debit<>l_credit THEN    #BUGNO:021219
         LET ls_msg = l_npq.npq01,' :l_debit<>l_credit' #MOD-980087   
         CALL cl_err(ls_msg CLIPPED,'axr-058',1) LET g_success = 'N' #MOD-980087  
      END IF
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
      #LET g_sql = "UPDATE ",g_dbs_gl CLIPPED,"aba_file SET aba08=?,aba09 =? ",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
                    " SET aba08=?,aba09 =? ",
                    "    ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE p590_1_p6_1 FROM g_sql
      EXECUTE p590_1_p6_1 USING l_debit,l_credit,l_npp08,gl_no1,g_ooz.ooz02c  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aba_file",gl_no1,g_ooz.ooz02c,SQLCA.sqlcode,"","upd aba08/09:",1)   #No.FUN-660116
         LET g_success = 'N'
      END IF
      PRINT
#No.TQC-B70021 --begin 
      CALL s_flows('2',g_ooz.ooz02c,gl_no1,gl_date,'N','',TRUE) 
#No.TQC-B70021 --end

IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'abb_file')," ,aag_file", #FUN-A50102
                  " WHERE abb01 = '",gl_no1,"'",
                  "   AND abb00 = '",g_ooz.ooz02c,"'",
                  "   AND abb03 = aag01  ",
                  "   AND abb00 = aag00 ",                    #No.FUN-740009
                  "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE count_pre_1 FROM g_sql
      DECLARE count_cs_1 CURSOR FOR count_pre_1
      OPEN count_cs_1 
      FETCH count_cs_1 INTO g_cnt
      CLOSE count_cs_1
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
         IF g_aba.abamksg='N' THEN   #No.TQC-7B0090
            LET g_aba.aba20='1' 
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (g_ooz.ooz02c,gl_no1) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end
            LET g_sql = " UPDATE ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,", 
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",   #No.TQC-7B0090
                               " aba37   = ?  ",   #No.TQC-7B0090
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba19_1 FROM g_sql
            EXECUTE upd_aba19_1 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user,     #No.TQC-7B0090
                                    gl_no1       ,g_ooz.ooz02c
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","aba_file",gl_no1,g_ooz.ooz02c,STATUS,"","upd aba19",1)   #No.FUN-660116
               LET g_success = 'N'   
            END IF
         END IF   #MOD-770101
      END IF
END IF     
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,g_aba.aba01,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,g_aba.aba01,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      LET gl_no1[g_no_sp,g_no_ep]=''     
END REPORT
 
#FUNCTION chk_date()  #傳票日期抓npp02時要判斷的日期      #MOD-AC0267 mark
FUNCTION p590_chkdate()  #傳票日期抓npp02時要判斷的日期   #MOD-AC0267
   DEFINE l_npp            RECORD LIKE npp_file.*
  #DEFINE l_npq            RECORD LIKE npq_file.*         #MOD-AC0267
   DEFINE l_aaa07  LIKE aaa_file.aaa07
  #LET g_sql="SELECT npp_file.*,npq_file.* ",             #MOD-AC0267 mark
  #          "  FROM npp_file,npq_file",                  #MOD-AC0267 mark
   LET g_sql="SELECT npp_file.* ",                        #MOD-AC0267
             "  FROM npp_file",                           #MOD-AC0267
             " WHERE nppsys= 'AR' ",
             "   AND (nppglno IS NULL OR nppglno=' ') ",
            #"   AND nppsys = npqsys",                    #MOD-AC0267 mark
            #"   AND npp00 = npq00 ",                     #MOD-AC0267 mark
            #"   AND npp01 = npq01 AND npp011=npq011",    #MOD-AC0267 mark
             "   AND ",g_wc CLIPPED
 
    PREPARE p590_1_p7 FROM g_sql
    IF STATUS THEN CALL cl_err('p590_1_p7',STATUS,1) 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    DECLARE p590_1_c7 CURSOR WITH HOLD FOR p590_1_p7
   #FOREACH p590_1_c7 INTO l_npp.*,l_npq.*                #MOD-AC0267 mark
    FOREACH p590_1_c7 INTO l_npp.*                        #MOD-AC0267
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
       END IF
       SELECT aaa07 INTO l_aaa07 FROM aaa_file
          WHERE aaa01 = p_bookno
       IF l_npp.npp02 <= l_aaa07 THEN
         #CALL cl_err(l_npp.npp01,'axr-164',1)   #MOD-770061  #No.TQC-970317 #MOD-AC0267 mark
          CALL s_errmsg('npp01',l_npp.npp01,'','axr-164',1)                  #MOD-AC0267
          LET g_success = 'N'
       END IF
       SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
          WHERE azn01 = l_npp.npp02
       IF STATUS THEN
         #CALL cl_err3("sel","azn_file",l_npp.npp02,"",SQLCA.sqlcode,"","read azn_file",1)  #No.TQC-970317 #MOD-AC0267 mark
          CALL s_errmsg('sel','azn_file',l_npp.npp02,SQLCA.sqlcode,1)                                      #MOD-AC0267 
          LET g_success = 'N'
       END IF
    END FOREACH
END FUNCTION
#No.FUN-9C0072 精簡程式碼
 
#--FUN-A60007 start----------
FUNCTION p590_chk_oct(l_npp,l_aba01)
DEFINE l_npp RECORD LIKE npp_file.*
DEFINE l_cnt LIKE type_file.num5
DEFINE l_omb RECORD LIKE omb_file.*
DEFINE l_aba01 LIKE aba_file.aba01

    #先找出單號符合的應收單身資料
    LET g_sql = "SELECT * FROM ",cl_get_target_table(p_plant," omb_file"),
                " WHERE omb01 = '",l_npp.npp01,"'"
    CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   
    PREPARE p590_omb_p1 FROM g_sql
    DECLARE p590_omb_c1 CURSOR FOR p590_omb_p1
    FOREACH p590_omb_c1 INTO l_omb.*
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt
          FROM oct_file
         WHERE oct01 = l_omb.omb01  
           AND oct02 = l_omb.omb03
           AND oct00 = l_npp.npptype
        IF l_cnt > 0 THEN    #代表已有寫入遞延收入檔
            IF l_omb.omb00 = '12' THEN  #出貨
                IF l_npp.npptype = '0' THEN
                    UPDATE oct_file 
                       SET oct08 = l_aba01
                     WHERE oct01 = l_omb.omb01
                       AND oct02 = l_omb.omb03 
                       AND oct16 = '1'         
                       AND oct00 = l_npp.npptype         
                ELSE 
                    UPDATE oct_file 
                       SET oct08 = l_aba01
                     WHERE oct01 = l_omb.omb01
                       AND oct02 = l_omb.omb03 
                       AND oct16 = '1'
                       AND oct00 = l_npp.npptype         
                END IF
            END IF
#FUN-AB0110 --Begin mark
#           IF l_omb.omb00 = '21' THEN  #出貨
#               IF l_npp.npptype = '0' THEN
#                   UPDATE oct_file 
#                      SET oct08 = l_aba01
#                    WHERE oct01 = l_omb.omb01
#                      AND oct02 = l_omb.omb03 
#                      AND oct16 = '3'                  
#                      AND oct00 = l_npp.npptype         
#               ELSE 
#                   UPDATE oct_file 
#                      SET oct08 = l_aba01
#                    WHERE oct01 = l_omb.omb01
#                      AND oct02 = l_omb.omb03 
#                      AND oct16 = '3'
#                      AND oct00 = l_npp.npptype         
#               END IF
#           END IF
#FUN-AB0110 --End mark
        END IF
    END FOREACH
END FUNCTION
#--FUN-A60007 end------------
#CHI-AC0010
