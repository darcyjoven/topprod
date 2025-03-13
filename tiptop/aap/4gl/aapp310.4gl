# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: aapp310.4gl
# Descriptions...: 廠商付款單整批產生作業
# Date & Author..: 92/12/20 By Roger
# Modify.........: 97/05/14 By Danny  郵資改由廠商資料取得
#                                     每張付款單只扣一次郵資
# Modify.........: 97/05/19 By Danny  轉帳須扣手續費
# Modify.........: 98/11/02 By Connie 增加多工廠請款處理
# Modify.........: No.MOD-4A0029 04/10/04 By Yuna PLANT-ID沒開窗
# Modify.........: No.MOD-4A0008 04/10/11 By ching add 轉電匯款
# Modify.........: No.MOD-4A0194 04/10/12 By ching 輸入人員後帶出部門
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.FUN-530044 05/03/30 By Nicola 1.付款類別為轉帳時，應可由銀行編號取得會計科目
# Modify.........: No.FUN-550030 05/05/12 By jackie 單據編號加大
# Modify.........: No.FUN-560002 05/06/03 By Will 單據編號修改
# Modify ........: No.MOD-560031 05/06/16 By ching fix select STATUS
# Modify.........: NO.FUN-560096 05/06/18 By Smapmin 自動編號
# Modify.........: No.MOD-570166 05/07/27 By Smapmin 在工廠編號欄位按enter 無法離開
# Modify.........: No.MOD-580246 05/08/29 By Smapmin 原因沒有判斷傳票產生否,造成程式無法處理
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5B0229 05/11/22 By Smapmin 不可抓取原來自己的那張待抵.
# Modify.........: No.MOD-5B0210 05/11/23 By Smapmin 拋轉後簽核欄位為NULL
# Modify.........: No.MOD-5C0068 05/12/13 By Carrier apz27='N'-->apa34-apa35,   
#                                                    apz27='Y'-->apa73
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-640098 06/04/10 By Smapmin 付款方式與付款廠商開窗功能
# Modify.........: No.TQC-640193 06/04/28 By Smapmin 單別抓取有誤
# Modify.........: No.MOD-660018 06/06/07 By Smapmin 折讓待抵的資料不應被排除
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660192 06/07/04 By Smapmin 選擇電匯時,科目應改為aps58
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670063 06/07/13 By Nicola 加入aph03=2的判斷
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能 
# Modify.........: No.FUN-680027 06/08/29 By cl     多帳期處理
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-710014 07/01/11 By Hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-710086 07/01/15 By Smapmin 起始/截止付款單號於一開始時要清空
# Modify.........: No.FUN-730064 07/04/02 By bnlent 會計科目加帳套
# Modify ........: No.TQC-740042 07/04/09 By johnray s_get_bookno和s_get_bookno1參數應先取出年份
# Modify ........: No.TQC-740066 07/04/12 By Ray 修正TQC-740042的錯誤
# Modify.........: No.FUN-740090 07/04/23 By Smapmin 付款類別為轉帳時,科目不可開放修改
# Modify.........: No.FUN-740145 07/04/25 By wujie   票據到期日改從子帳期apc中抓取
#                                                    將從apa抓應付帳款日改從apc抓取
# Modify.........: No.TQC-750019 07/05/08 By Sarah 產生付款單身資料時,應排除類別(apa00)為26的單據
# Modify.........: No.TQC-750140 07/05/24 By rainy 不可抓員工借支，報銷還款資料
# Modify.........: No.TQC-760028 07/06/06 By Smapmin 增加票到期日欄位,增加開窗功能
# Modify.........: No.MOD-770130 07/07/26 By Smapmin 開票/付款銀行不應由貸方科目決定
#                                                    選擇轉帳方式時，開票/付款銀行一定要輸入
# Modify.........: No.MOD-7B0149 07/11/15 By chenl   原幣金額根據幣種取位。
# Modify.........: No.MOD-7B0157 07/11/26 By Smapmin 幣別不同時,因以本幣差異金額回推原幣差異金額
# Modify.........: No.MOD-7C0153 07/12/21 By Smapmin 未開發票者也應該抓進來
# Modify.........: No.MOD-830237 08/03/31 By Smapmin 若為支票類別時將"開票/付款銀行設定為必要欄位
# Modify.........: No.MOD-840062 08/04/09 By smapmin 修正MOD-7B0157
# Modify.........: No.MOD-880155 08/08/25 By Sarah apa01欄位開窗改CALL q_apa08,過濾掉已付的資料
# Modify.........: No.CHI-690027 08/10/16 By xiaofeizhu 加二條件選項：「是否指定付款幣別」/「幣別」
# Modify.........: No.MOD-8C0169 08/12/18 By Sarah g_sql裡應為FROM apa_file,apc_file,第二個table誤寫為apa_file
# Modify.........: No.MOD-8C0230 08/12/29 By Sarah 產生付款單時,付款幣別應可以與apf06不同
# Modify.........: No.MOD-910101 09/01/13 By Sarah p310_ins_aph()裡g_sql的WHERE條件裡過濾g_apa的值,應改過濾g_apf的值
# Modify.........: No.MOD-930078 09/03/08 By lilingyu 付款銀行應依付款類別的不同做合理性檢查 
# Modify.........: No.MOD-930165 09/03/16 By lilingyu 到期日需針對類別為2或C時,才做假日問題檢查
# Modify.........: No.MOD-930189 09/03/19 By Sarah 當不指定付款幣別時,"開票/付款銀行"開窗選不到資料
# Modify.........: No.MOD-940124 09/04/09 By lilingyu AFTER FIELD bankno時,做DISPLAY BY NAME np_actno的動作
# Modify.........: No.MOD-960157 09/06/12 By baofei  如果沒有產生任何一筆付款單資料，LET g_success = 'N' 顯示'aap-129'信息
# Modify.........: No.MOD-960161 09/06/12 By mike 新增apf_file前給予apf42預設值為'0'    
# Modify.........: No.MOD-970180 09/07/20 By mike AFTER FIELD bankno段,                                                             
#                                                 請改成跟AFTER FIELD pay_type段一樣,                                               
#                                                 根據不同的pay_type的值來決定bank_actno與bank_actno1科目要抓什麼                   
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980122 09/08/17 By sabrina 若付款方式為"2.轉帳"時，現金變動碼要為必要輸入欄位
# Modify.........: No.MOD-980124 09/08/17 By Sarah 當重新帶出np_actno與np_actno1時,也應重新抓取、顯示aag02與aag02_1
# Modify.........: No.FUN-960140 09/09/08 By lutingtingGP 5.2處理,畫面新增門店編號
# Modify.........: No:MOD-990168 09/10/21 By mike 调整抓取 apyapr 方式      
# Modify.........: NO.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9B0130 09/11/26 By lutingting 畫面門店編號拿掉
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.TQC-A20062 10/03/02 By lutingting 拿掉營運中心編號以及apz26的處理
# Modify.........: No:FUN-970077 10/03/10 By chenmoyan add r_type
# Modify.........: No.FUN-A20010 10/03/10 By chenmoyan mark r_type
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AAP
# Modify.........: No:CHI-A60007 10/06/08 By Summer 增加錯誤彙總提示    
# Modify.........: No:MOD-A60100 10/06/15 By Dido 排序方式調整;語法變數調整    
# Modify.........: No.MOD-A60109 10/06/17 By Dido apa_file增加apa02 <= pay_date條件
# Modify.........: No.MOD-A60200 10/06/30 By sabrina 抓取原帳款資料
# Modify.........: No.FUN-A50102 10/07/21 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A50185 10/07/27 By sabrina 匯率抓取方式應與aapt330單身新增時方式一致，不應取apz33
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.CHI-A90044 10/10/08 By Summer 付款單身(aph_file)產生調整
# Modify.........: No.TQC-AC0404 10/12/31 By zhangweib ins_aph()中將matches '2*'修改成LIKE '2%'
# Modify.........: No:CHI-B10014 11/01/10 By Summer 手續費是外加時(假設為30元)1.應該要自動產生手續費-30 2.付款單身的TT或支票為1030
# Modify.........: No:MOD-B10132 11/01/18 By Dido 調整依單別產生分錄,apz40 參考 saapt310 調整 
# Modify.........: No:MOD-B20016 11/02/10 By Dido apf07 預設值調整
# Modify.........: No:FUN-B20059 11/02/24 By wujie  科目自动开窗hard code修改
# Modify.........: No:MOD-B30007 11/03/01 By Dido aph19 預設值調整 
# Modify.........: No:MOD-B30008 11/03/01 By Dido 若無設定 apz58 則提示警訊 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:TQC-B40046 11/04/08 By yinhy 若付款類型為1支票時，若apz58為null則不應該報錯
# Modify.........: No:MOD-B40058 11/04/13 By Dido 產生付款單號前重新抓取 g_apy 變數 
# Modify.........: No:MOD-B70047 11/07/07 By Dido 未付金額應包含 apc14/apc15
# Modify.........: No:MOD-B80059 11/08/05 By Polly 針對CHI-A70049僅需display段mark，其他CHI-A70049的mark都需還原
# Modify.........: No:MOD-B80109 11/08/10 By Polly 修正aapp310整批產生後，在aapt330單身付款部分之到期日若相同時，會出現兩筆產生付款資料
# Modify.........: No:MOD-B80130 11/08/12 By Polly 在FUNCTION p310_ins_aph增加判斷apa01存在別張aapt330中，且金額相同時則 CONTINUE FOREACH
# Modify.........: No.MOD-B90034 11/09/05 By Polly 增加判斷aph05若有* -1，則post_fee也需要一併 * -1
# Modify.........: No.MOD-B90086 11/09/14 By Polly WHEN INFIELD(bankno) 改為case when 方式處理
# Modify.........: No.TQC-B90106 11/09/19 By Carrier 邮资汇率取单头;付款单身多币种时,apf10f=0(与aapt330处理方式一致)
# Modify.........: No.TQC-B90101 11/09/14 By yinhy apf10f,apf10尾差處理
# Modify.........: No.MOD-BB0168 11/11/15 By yinhy apc13已經在saapt110.4gl中減掉了apc15，此處不應該再減
# Modify.........: No.MOD-C30684 12/03/14 by minpp 程式開啟時,游標停在 QBE 條件中,此時若選擇'放棄'action,仍會往下執行輸入條件選項,增加關閉代碼
# Modify.........: No:FUN-C80018 12/08/15 By minpp nma28添加控管
# Modify.........: No:MOD-C80144 12/10/31 By Polly 1.當apf06與aph13幣別不同時，不可將LET l_drcostf = l_drtotf
#                                                  2.沖帳期別aph17改用apc02給予

IMPORT os   #No.FUN-9C0009  add by dxfwo
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_apa           RECORD LIKE apa_file.*, 
       g_apf           RECORD LIKE apf_file.*,
       g_apg           RECORD LIKE apg_file.*,
       g_aph           RECORD LIKE aph_file.*,
       g_apc           RECORD LIKE apc_file.*, #No.FUN-680027 add
       g_aps42         LIKE aps_file.aps42,
       g_aps43         LIKE aps_file.aps43,
       g_aps46         LIKE aps_file.aps46,
       g_aps47         LIKE aps_file.aps47,
       g_aps58         LIKE aps_file.aps58,   #FUN-660192
       g_aps24         LIKE aps_file.aps24,   #FUN-660192
       g_aps421        LIKE aps_file.aps421,
       g_aps431        LIKE aps_file.aps431,
       g_aps461        LIKE aps_file.aps461,
       g_aps471        LIKE aps_file.aps471,
       g_aps581        LIKE aps_file.aps581,
       g_aps241        LIKE aps_file.aps241,
       g_tot           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       g_discount      LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       i,j,k           LIKE type_file.num5,        # No:FUN-690028 INTEGER,    #CHI-A90044 add k
       l_ac,l_sl       LIKE type_file.num5,        # No.FUN-690028 INTEGER,
       g_wc,g_sql      string,  #No.FUN-580092 HCN
       g_buf           LIKE nph_file.nph02,    #FUN-660117
       g_sw            LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
       g_seq           LIKE type_file.num5,    # No.FUN-690028 SMALLINT,
      #plant           ARRAY[5] OF LIKE apa_file.apa05, #FUN-660117    #FUN-A20062
       emp_no 	      LIKE gen_file.gen01,             #FUN-660117
       dept   	      LIKE gem_file.gem01,             #FUN-660117
       tr_type	      LIKE apy_file.apyslip,           # No.FUN-690028 VARCHAR(5),    #NO.FUN-550030
       pay_date	      LIKE type_file.dat,              #No.FUN-690028 DATE
       pay_type	      LIKE type_file.chr1,             # No.FUN-690028 VARCHAR(1),
       apf14           LIKE apf_file.apf14,             #FUN-660117
       np_actno	      LIKE nma_file.nma05,             #FUN-660117
       np_actno1	      LIKE nma_file.nma051,            #No.FUN-680029
       bank_actno      LIKE nma_file.nma05,             #FUN-660117
       bank_actno1     LIKE nma_file.nma051,            #No.FUN-680029
       bankno          LIKE nma_file.nma01,             #FUN-660117
#      r_type          LIKE type_file.chr50,            #FUN-970077 #FUN-A20010
       post_fee_sw     LIKE type_file.chr1,             #No.FUN-690028 VARCHAR(1)
       post_fee	       LIKE type_file.num20_6,          # No.FUN-690028 DEC(20,6), #FUN-4B0079
       plant_seperate  LIKE type_file.chr1,             # No.FUN-690028 VARCHAR(1),
       discount_sw     LIKE type_file.chr1,             #No.FUN-690028 VARCHAR(1)
       sw_21,sw_22,sw_23  LIKE type_file.chr1,          # No.FUN-690028 VARCHAR(1),
       g_arr  	       DYNAMIC ARRAY OF RECORD
                        duedate	  LIKE type_file.dat,         #No.FUN-690028 DATE
                        amountf   LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
                        amount	  LIKE type_file.num20_6      # No.FUN-690028 DEC(20,6)  #FUN-4B0079
                       END RECORD,
       apa64_t         DATE,
       apc05_t         DATE,                  #No.FUN-740145
       g_start_no      LIKE apf_file.apf01,   #FUN-660117
       g_end_no        LIKE apf_file.apf01,   #FUN-660117
       g_dbs_cnt       LIKE type_file.num5    # No.FUN-690028 SMALLINT
DEFINE g_change_lang   LIKE type_file.chr1,   #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
       p_row,p_col     LIKE type_file.num5    # No.FUN-570112  #No.FUN-690028 SMALLINT
DEFINE l_depno         LIKE gem_file.gem01    #FUN-660117
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_flag          LIKE type_file.chr1    #No.FUN-730064
DEFINE g_bookno1       LIKE aza_file.aza81    #No.FUN-730064
DEFINE g_bookno2       LIKE aza_file.aza82    #No.FUN-730064
DEFINE assign          LIKE type_file.chr10   #No.CHI-690027
DEFINE curr            LIKE azi_file.azi01    #No.CHI-690027
DEFINE g_t2            LIKE apy_file.apyslip  #MOD-B10132      
DEFINE g_apydmy3       LIKE apy_file.apydmy3  #MOD-B10132      
 
MAIN
   DEFINE ls_date       STRING,   #->No.FUN-570112
          l_flag        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc         = ARG_VAL(1)      #QBE條件
  #TQC-A20062--mod--str--
  #LET plant[1]     = ARG_VAL(2)      #營運中心編號
  #LET plant[2]     = ARG_VAL(3)      #營運中心編號
  #LET plant[3]     = ARG_VAL(4)      #營運中心編號
  #LET plant[4]     = ARG_VAL(5)      #營運中心編號
  #LET plant[5]     = ARG_VAL(6)      #營運中心編號
  #LET emp_no       = ARG_VAL(7)      #付款人員
  #LET dept         = ARG_VAL(8)      #部門
  #LET tr_type      = ARG_VAL(9)      #付款單別
  #LET ls_date        = ARG_VAL(10)
  #LET pay_date    = cl_batch_bg_date_convert(ls_date)   #付款日期
  #LET bankno       = ARG_VAL(11)     #開票/付款銀行
  #LET pay_type     = ARG_VAL(12)     #付款類別
  #LET np_actno     = ARG_VAL(13)     #貸方科目
  #LET apf14        = ARG_VAL(14)     #現金變動碼
  #LET post_fee_sw  = ARG_VAL(15)     #扣郵資(手續費)
  #LET sw_21        = ARG_VAL(16)     #退貨折讓沖帳
  #LET sw_22        = ARG_VAL(17)     #dm沖帳
  #LET sw_23        = ARG_VAL(18)     #預付沖帳
  #LET bank_actno   = ARG_VAL(19)
  #LET g_bgjob      = ARG_VAL(20)     #背景作業
  #LET np_actno1    = ARG_VAL(21)     #貸方科目二  #No.FUN-680029
  #LET assign       = ARG_VAL(22)     #CHI-690027
  #LET curr         = ARG_VAL(23)     #CHI-690027   
   LET emp_no       = ARG_VAL(2)      #付款人員
   LET dept         = ARG_VAL(3)      #部門
   LET tr_type      = ARG_VAL(4)      #付款單別
   LET ls_date        = ARG_VAL(5)
   LET pay_date    = cl_batch_bg_date_convert(ls_date)   #付款日期
   LET bankno       = ARG_VAL(6)     #開票/付款銀行
   LET pay_type     = ARG_VAL(7)     #付款類別
   LET np_actno     = ARG_VAL(8)     #貸方科目
   LET apf14        = ARG_VAL(9)     #現金變動碼
   LET post_fee_sw  = ARG_VAL(10)     #扣郵資(手續費)
   LET sw_21        = ARG_VAL(11)     #退貨折讓沖帳
   LET sw_22        = ARG_VAL(12)     #dm沖帳
   LET sw_23        = ARG_VAL(13)     #預付沖帳
   LET bank_actno   = ARG_VAL(14)
   LET g_bgjob      = ARG_VAL(15)     #背景作業
   LET np_actno1    = ARG_VAL(16)     #貸方科目二  #No.FUN-680029
   LET assign       = ARG_VAL(17)     #CHI-690027
   LET curr         = ARG_VAL(18)     #CHI-690027
#  LET r_type       = ARG_VAL(24)     #FUN-970077 add
  #TQC-A20062--mod--end
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   WHILE TRUE
     #LET g_dbs_cnt = 5     #TQC-A20062
      IF g_bgjob = "N" THEN
         CALL p310()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p310_process()
            IF g_success = 'Y' THEN
               COMMIT WORK
               OPEN WINDOW p310_w2 WITH FORM "aap/42f/aapp310_2"
                  ATTRIBUTE (STYLE = g_win_style CLIPPED)
               CALL cl_ui_locale("aapp310_2")

               DISPLAY BY NAME g_cnt,g_tot,g_start_no,g_end_no
               CALL cl_end2(1) RETURNING l_flag
               CLOSE WINDOW p310_w2
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p310_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         IF g_apz.apz13 = 'Y' THEN LET l_depno = dept ELSE LET l_depno = ' ' END IF
         SELECT aps24,aps42,aps43,aps46,aps47,aps58
           INTO g_aps24,g_aps42,g_aps43,g_aps46,g_aps47,g_aps58
           FROM aps_file WHERE aps01 = l_depno
         IF g_aza.aza63 = 'Y' THEN 
           SELECT aps241,aps421,aps431,aps461,aps471,aps581
             INTO g_aps241,g_aps421,g_aps431,g_aps461,g_aps471,g_aps581
             FROM aps_file WHERE aps01 = l_depno
         END IF
 
         LET g_success = 'Y'
         BEGIN WORK
         CALL p310_process()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p310()
   DEFINE   l_depno     LIKE gem_file.gem01   #FUN-660117
   DEFINE l_apg05      LIKE apg_file.apg05  
   DEFINE l_apg05f     LIKE apg_file.apg05f
   DEFINE l_pma11      LIKE pma_file.pma11
   DEFINE l_aag02      LIKE aag_file.aag02     #No:8748 
   DEFINE l_name       LIKE type_file.chr20   #No.FUN-690028 VARCHAR(20)
   DEFINE l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(30)
   DEFINE l_aba19      LIKE aba_file.aba19
   DEFINE li_result    LIKE type_file.num5        #No.FUN-560002   #No.FUN-690028 SMALLINT
   DEFINE lc_cmd       LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(500)               #No.FUN-570112
#  DEFINE l_n          LIKE type_file.num5     #FUN-970077 add     #FUN-A20010
 
   OPEN WINDOW p310_w AT p_row,p_col WITH FORM "aap/42f/aapp310"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
   #CALL cl_set_comp_visible("g01",FALSE)   #FUN-990031    #TQC-A20062
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("np_actno1,aag02_1",FALSE)
    END IF
 
#FUN-A20010 --Begin
#   #FUN-970077---Begin
#   IF g_aza.aza73  = 'Y' AND g_aza.aza26  = '0' THEN
#      CALL cl_set_comp_visible("r_type",TRUE)
#   ELSE
#        CALL cl_set_comp_visible("r_type",FALSE)
#   END IF
#   #FUN-970077---End
#FUN-A20010 --End
WHILE TRUE
   LET g_action_choice = ""
 
   CLEAR FORM
   CALL g_arr.clear()
   LET g_start_no=''   #MOD-710086
   LET g_end_no=''   #MOD-710086
   CALL s_get_bookno(YEAR(g_apa.apa02)) RETURNING g_flag,g_bookno1,g_bookno2  #No.TQC-740042
   IF g_flag = '1' THEN
      CALL cl_err(g_apa.apa02,'aoo-081',1)
   END IF
   CONSTRUCT BY NAME g_wc ON apa12,apa11,apa01,apa02,apa21,apa00,
                             apa05,apa06,apa07,apa13,apa36,apa64           #FUN-9B0130

 
     ON ACTION locale
        LET g_change_lang = TRUE       #->No.FUN-570112
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
 

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(apa06) #PAY TO VENDOR
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa06
               WHEN INFIELD(apa11) # PAY TERM
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pma"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa11
               WHEN INFIELD(apa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apa08"   #MOD-880155 mod q_apa07->q_apa08
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
               WHEN INFIELD(apa21) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa21
               WHEN INFIELD(apa05) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa05
               WHEN INFIELD(apa13) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa13
               WHEN INFIELD(apa36) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apr"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa36

            END CASE
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup') #FUN-980030
   #MOD-C30684--ADD--STR
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p310_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
      EXIT PROGRAM
   END IF
   #MOD-C30684--ADD--END 
 

  #TQC-A20062--mark--str--
  #IF g_apz.apz26 = 'Y' THEN		# 允許多工廠付款   #TQC-630135
  #  LET plant[1] = g_plant
  #  INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.* 
  #       ATTRIBUTE(COUNT=5,MAXCOUNT=g_max_rec,UNBUFFERED,   #MOD-570166
  #                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
  #     AFTER FIELD plant
  #        LET l_ac = ARR_CURR()
  #        IF plant[l_ac] IS NOT NULL AND plant[l_ac] != g_plant THEN
  #           IF NOT s_chknplt(plant[l_ac],'AAP','AAP') THEN 
  #              CALL cl_err(plant[l_ac],'aap-025',0)
  #              NEXT FIELD plant
  #           END IF
  #        END IF
  #     ON ACTION CONTROLP
  #      CASE WHEN INFIELD(plant)
  #              LET l_ac = ARR_CURR()
  #              CALL cl_init_qry_var()
  #              LET g_qryparam.form = "q_azp"
  #              LET g_qryparam.default1 = plant[l_ac]
  #              CALL cl_create_qry() RETURNING plant[l_ac]
  #              DISPLAY plant[l_ac] TO FORMONLY.plant
  #              NEXT FIELD plant
  #      END CASE
  #     ON ACTION locale
  #        LET g_change_lang = TRUE       #->No.FUN-570112
  #        EXIT INPUT
  #     ON ACTION exit
  #        LET INT_FLAG = 1
  #        EXIT INPUT
  #     ON IDLE g_idle_seconds
  #        CALL cl_on_idle()
  #        CONTINUE INPUT
 
  #  ON ACTION about         #MOD-4C0121
  #     CALL cl_about()      #MOD-4C0121
 
  #  ON ACTION help          #MOD-4C0121
  #     CALL cl_show_help()  #MOD-4C0121
 
  #  ON ACTION controlg      #MOD-4C0121
  #     CALL cl_cmdask()     #MOD-4C0121
 
  #  
  #  END INPUT

  #  IF g_change_lang THEN
  #     LET g_change_lang = FALSE
  #     CALL cl_dynamic_locale()
  #     CALL cl_show_fld_cont()   #FUN-550037(smin)
  #     EXIT WHILE
  #  END IF
  #  IF INT_FLAG THEN
  #     LET INT_FLAG = 0
  #     CLOSE WINDOW p310_w
  #     EXIT PROGRAM
  #  END IF
  #END IF
  #TQC-A20062--mark--end
 
   LET pay_date = g_today
   LET pay_type = '1'
   LET post_fee_sw    = 'N'
   LET discount_sw    = '1'
   LET sw_21 = 'Y'
   LET sw_22 = 'Y' 
   LET sw_23 = 'N'
   LET plant_seperate = 'Y'
   LET post_fee       = 0
   LET g_bgjob = "N"
   LET assign    = 'N'                     #CHI-690027
   LET curr = NULL                         #CHI-690027                                                                              
   DISPLAY BY NAME curr                    #CHI-690027
   CALL p310_set_entry_1()                 #CHI-690027
   CALL p310_set_no_entry_1()              #CHI-690027
 
    INPUT BY NAME emp_no,dept,tr_type,pay_date,assign,curr,pay_type,bankno,np_actno,np_actno1,apf14, #MOD-930078
                 post_fee_sw, sw_21,sw_22,sw_23,g_bgjob WITHOUT DEFAULTS  #No.B46 #NO.FUN-570112  
 
      AFTER FIELD emp_no
         IF NOT cl_null(emp_no) THEN 
            SELECT * FROM gen_file WHERE gen01=emp_no
             IF STATUS THEN #MOD-560031
               CALL cl_err3("sel","gen_file",emp_no,"","mfg3096","","",1)   #No.FUN-660122
               NEXT FIELD emp_no
            END IF
            SELECT gen03 INTO dept FROM gen_file
             WHERE gen01=emp_no
            DISPLAY BY NAME dept
         END IF
 
      AFTER FIELD dept
         IF NOT cl_null(dept) THEN
            IF g_apz.apz13 = 'Y' THEN
               LET l_depno = dept
            ELSE 
               LET l_depno = ' '
            END IF
            SELECT * FROM gem_file WHERE gem01=dept
             IF STATUS THEN #MOD-560031
               CALL cl_err3("sel","gem_file",dept,"","mfg3097","","",1)   #No.FUN-660122
               NEXT FIELD dept
            END IF

            SELECT aps24,aps42,aps43,aps46,aps47,aps58
              INTO g_aps24,g_aps42,g_aps43,g_aps46,g_aps47,g_aps58
              FROM aps_file WHERE aps01 = l_depno
            DISPLAY BY NAME np_actno
            IF g_aza.aza63 = 'Y' THEN
               SELECT aps241,aps421,aps431,aps461,aps471,aps581
                 INTO g_aps241,g_aps421,g_aps431,g_aps461,g_aps471,g_aps581
                 FROM aps_file WHERE aps01 = l_depno
            END IF
         END IF
 
      AFTER FIELD tr_type
         IF NOT cl_null(tr_type) THEN 
#           CALL s_check_no(g_sys,tr_type,"","33","","","")                      
            CALL s_check_no("aap",tr_type,"","33","","","")                      #No.FUN-A40041
              RETURNING li_result,tr_type                                     
            IF (NOT li_result) THEN                                          
                NEXT FIELD tr_type                                             
            END IF 
                                
         END IF
 
      AFTER FIELD np_actno
         IF NOT cl_null(np_actno) THEN
           CALL s_aapact('2',g_bookno1,np_actno) RETURNING l_aag02    #No.FUN-730064
           IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) 
#No.FUN-B20059 --begin
               CALL q_aapact(FALSE,FALSE,'2',np_actno,g_bookno1) RETURNING np_actno
#No.FUN-B20059 --end
               NEXT FIELD np_actno
           END IF
           DISPLAY l_aag02 TO aag02

         END IF
 
      AFTER FIELD np_actno1
         IF NOT cl_null(np_actno1) THEN
           CALL s_aapact('2',g_bookno2,np_actno1) RETURNING l_aag02       #No.FUN-730064
           IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) 
#No.FUN-B20059 --begin
               CALL q_aapact(FALSE,FALSE,'2',np_actno1,g_bookno2) RETURNING np_actno1
#No.FUN-B20059 --end
               NEXT FIELD np_actno1
           END IF
           DISPLAY l_aag02 TO aag02_1
         END IF
      
      AFTER FIELD assign
          IF NOT cl_null(assign)  THEN
             IF assign NOT MATCHES "[YN]" THEN
                NEXT FIELD assign       
             END IF
          END IF
                    
       ON CHANGE  assign
          LET curr = NULL
          DISPLAY BY NAME curr  
          CALL p310_set_entry_1()       
          CALL p310_set_no_entry_1()            
      
 
      AFTER FIELD bankno
         IF NOT cl_null(bankno) THEN
            CALL bankno_check(bankno)      
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD bankno
            END IF    
            IF pay_type = '2' THEN #MOD-970180    
               SELECT nma05 INTO bank_actno FROM nma_file
                WHERE nma01 = bankno
               LET np_actno = bank_actno
               DISPLAY BY NAME np_actno
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","nma_file",bankno,"","aap-007","","",0)   #No.FUN-660122
                  NEXT FIELD bankno
               END IF
               IF g_aza.aza63 = 'Y' THEN
                  SELECT nma051 INTO bank_actno1 FROM nma_file
                   WHERE nma01 = bankno
                  LET np_actno1= bank_actno1
                  DISPLAY BY NAME np_actno1
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","nma_file",bankno,"","aap-007","","",0)
                     NEXT FIELD bankno
                  END IF
               END IF
            ELSE                                                                                                                    
               IF pay_type = '1' THEN                                                                                                 
                  LET np_actno = g_aps24                                                                                              
                  IF g_aza.aza63 = 'Y' THEN                                                                                           
                     LET np_actno1 = g_aps241                                                                                         
                  END IF                                                                                                              
               ELSE                                                                                                                   
                  LET np_actno = g_aps58                                                                                              
                  IF g_aza.aza63 = 'Y' THEN                                                                                           
                     LET np_actno1 = g_aps581                                                                                         
                  END IF                                                                                                              
               END IF                                                                                                                 
            END IF                                                                                                                  
            DISPLAY BY NAME np_actno,np_actno1
            LET l_aag02 = ''
            DISPLAY l_aag02 TO aag02
            DISPLAY l_aag02 TO aag02_1
            IF NOT cl_null(np_actno) THEN
               LET l_aag02 = ''
               CALL s_aapact('2',g_bookno1,np_actno) RETURNING l_aag02
               DISPLAY l_aag02 TO aag02
            END IF
            IF NOT cl_null(np_actno1) THEN
               LET l_aag02 = ''
               CALL s_aapact('2',g_bookno1,np_actno1) RETURNING l_aag02
               DISPLAY l_aag02 TO aag02_1
            END IF
         END IF
 
      AFTER FIELD apf14  
         IF NOT cl_null(apf14) THEN
            SELECT COUNT(*) INTO g_cnt FROM nml_file WHERE nml01=apf14
            IF g_cnt=0 THEN
               CALL cl_err('','anm-024',1)
               NEXT FIELD apf14
            END IF
         END IF
 
       AFTER FIELD post_fee_sw
          IF NOT cl_null(post_fee_sw)  THEN
             IF post_fee_sw NOT MATCHES "[YN]" THEN
                NEXT FIELD post_fee_sw
             END IF
          END IF
            
       AFTER FIELD pay_type
          CALL p310_set_no_required()    #MOD-770130
          CALL p310_set_required()   #MOD-770130
          IF pay_type = '2' THEN  
             SELECT nma05 INTO np_actno FROM nma_file
              WHERE nma01=bankno
             LET bank_actno = np_actno
             IF g_aza.aza63 = 'Y' THEN
                SELECT nma051 INTO np_actno1 FROM nma_file
                 WHERE nma01 = bankno
             END IF
             LET bank_actno1 = np_actno1
          ELSE
             IF pay_type = '1' THEN
                LET np_actno = g_aps24
                IF g_aza.aza63 = 'Y' THEN
                   LET np_actno1 = g_aps241
                END IF
             ELSE
                LET np_actno = g_aps58
                IF g_aza.aza63 = 'Y' THEN
                   LET np_actno1 = g_aps581
                END IF
             END IF
          END IF 
          DISPLAY BY NAME np_actno
          DISPLAY BY NAME np_actno1  #No.FUN-680029
          LET l_aag02 = ''
          DISPLAY l_aag02 TO aag02
          DISPLAY l_aag02 TO aag02_1
          IF NOT cl_null(np_actno) THEN
             LET l_aag02 = ''
             CALL s_aapact('2',g_bookno1,np_actno) RETURNING l_aag02
             DISPLAY l_aag02 TO aag02
          END IF
          IF NOT cl_null(np_actno1) THEN
             LET l_aag02 = ''
             CALL s_aapact('2',g_bookno1,np_actno1) RETURNING l_aag02
             DISPLAY l_aag02 TO aag02_1
          END IF
          CALL p310_set_entry()   #FUN-740090
          CALL p310_set_no_entry()   #FUN-740090
 
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(tr_type) #查詢單据
             CALL q_apy(FALSE,FALSE,tr_type,'33','AAP') RETURNING tr_type  #TQC-670008
             DISPLAY BY NAME tr_type 
             NEXT FIELD tr_type
          WHEN INFIELD(np_actno) #查詢 Account No.
             CALL q_aapact(FALSE,TRUE,'2',np_actno,g_bookno1) RETURNING np_actno   #No:8727  #No.FUN-730064
             DISPLAY BY NAME np_actno 
             NEXT FIELD np_actno
          WHEN INFIELD(np_actno1)
             CALL q_aapact(FALSE,TRUE,'2',np_actno1,g_bookno2) RETURNING np_actno1    #No.FUN-730064
             DISPLAY BY NAME np_actno1 
             NEXT FIELD np_actno1
          WHEN INFIELD(apf14) # 現金變動碼  
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_nml"
             LET g_qryparam.default1 = apf14
             CALL cl_create_qry() RETURNING apf14
             DISPLAY BY NAME apf14
             NEXT FIELD apf14   
          WHEN INFIELD(dept)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gem"
             LET g_qryparam.default1 = dept
             CALL cl_create_qry() RETURNING dept 
             DISPLAY BY NAME dept
             NEXT FIELD dept
          WHEN INFIELD(emp_no) #
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gen"
             LET g_qryparam.default1 = emp_no
             CALL cl_create_qry() RETURNING emp_no
             DISPLAY BY NAME emp_no
             NEXT FIELD emp_no
 
          WHEN INFIELD(bankno)
             CALL cl_init_qry_var()
             IF cl_null(curr) THEN                               #CHI-690027
                 LET g_qryparam.form = "q_nma91"    
                #--------------------No.MOD-B90086---------------------start
                 CASE
                   WHEN pay_type = '1' LET g_qryparam.arg1 = pay_type
                   WHEN pay_type = '2' LET g_qryparam.arg1 = '123'
                   WHEN pay_type = 'C' LET g_qryparam.arg1 = '23'
                 END CASE
                #IF pay_type = '1' THEN
                #   LET g_qryparam.arg1 = pay_type
                #ELSE
                #   LET g_qryparam.arg1 = '123'
                #END IF
                #--------------------No.MOD-B90086---------------------end           
             ELSE                          
                LET g_qryparam.form = "q_nma9"                   #CHI-690027
                LET g_qryparam.arg1 = curr                       
               #--------------------No.MOD-B90086---------------------start
                CASE
                  WHEN pay_type = '1' LET g_qryparam.arg2 = pay_type
                  WHEN pay_type = '2' LET g_qryparam.arg2 = '123'
                  WHEN pay_type = 'C' LET g_qryparam.arg2 = '23'
                END CASE
               #IF pay_type = '1' THEN
               #   LET g_qryparam.arg2 = pay_type
               #ELSE
               #   LET g_qryparam.arg2 = '123'
               #END IF
               #--------------------No.MOD-B90086---------------------end
             END IF                                              #CHI-690027    
             LET g_qryparam.default1 = bankno
             CALL cl_create_qry() RETURNING bankno
             DISPLAY BY NAME bankno
             NEXT FIELD bankno
             
          WHEN INFIELD(curr)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azi"
             LET g_qryparam.default1 = curr
             CALL cl_create_qry() RETURNING curr
             DISPLAY BY NAME curr
             NEXT FIELD curr
 
       END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG 
          CALL cl_cmdask()
       ON ACTION locale
          LET g_change_lang = TRUE       #->No.FUN-570112
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
 
   
   END INPUT

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      EXIT WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp310"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aapp310','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                     #TQC-A20062--mark--str--
                     #" '",plant[1] CLIPPED,"'",
                     #" '",plant[2] CLIPPED,"'",
                     #" '",plant[3] CLIPPED,"'",
                     #" '",plant[4] CLIPPED,"'",
                     #" '",plant[5] CLIPPED,"'",
                     #TQC-A20062--mark--end
                      " '",emp_no CLIPPED,"'",
                      " '",dept CLIPPED,"'",
                      " '",tr_type CLIPPED,"'",
                      " '",pay_date CLIPPED,"'",
                      " '",pay_type CLIPPED,"'",       #MOD-930078 bankno->pay_type
                      " '",bankno CLIPPED,"'",         #MOD-930078 pay_type->bankno
                      " '",np_actno CLIPPED,"'",
                      " '",apf14 CLIPPED,"'",
                      " '",post_fee_sw CLIPPED,"'",
                      " '",sw_21 CLIPPED,"'",
                      " '",sw_22 CLIPPED,"'",
                      " '",sw_23 CLIPPED,"'",
                      " '",bank_actno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",np_actno1 CLIPPED,"'",  #No.FUN-680029
                      " '",assign CLIPPED,"'",     #No.CHI-690027
                      " '",curr CLIPPED,"'"        #No.CHI-690027                      
         CALL cl_cmdat('aapp310',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p310_process()
   DEFINE   l_apg05    LIKE apg_file.apg05
   DEFINE   l_apg05f   LIKE apg_file.apg05f
   DEFINE   l_pma11    LIKE pma_file.pma11 
   DEFINE   l_name     LIKE type_file.chr20              #No.FUN-690028 VARCHAR(20)
   DEFINE   l_cmd      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(30)
   DEFINE   l_aba19    LIKE aba_file.aba19
    DEFINE   g_t1       LIKE oay_file.oayslip   #MOD-580246  #No.FUN-690028 VARCHAR(5)
   DEFINE   l_fag      LIKE type_file.num5    #MOD-960157   

   LET g_tot = 0
   LET g_cnt = 0
   CALL cl_outnam('aapp310')
   RETURNING l_name
   START REPORT aapp310_rep TO l_name        
   LET g_success = 'Y'
 
  #TQC-A20062--mark--str--
  #FOR i = 1 TO g_dbs_cnt
  #  #IF g_apz.apz23 = 'N' THEN		# 不允許多工廠付款   #TQC-630135
  #  IF g_apz.apz26 = 'N' THEN		# 不允許多工廠付款   #TQC-630135
  #     IF i = 1 THEN
  #        LET g_plant_new = g_plant
  #        LET g_dbs_new = NULL
  #     ELSE 
  #        EXIT FOR
  #     END IF
  #  END IF
  #  IF g_apz.apz26 = 'Y' THEN		# 允許多工廠付款   #TQC-630135
  #     IF plant[i] IS NULL THEN
  #        CONTINUE FOR 
  #     END IF
  #     LET g_plant_new = plant[i]
  #     FOR j = 1 TO i			# 若 Plant 選擇重複, 則 Skip
  #        IF plant[j] = g_plant_new THEN
  #           EXIT FOR 
  #        END IF
  #     END FOR
  #     IF j < i THEN 
  #        CONTINUE FOR 
  #     END IF
  #     CALL s_getdbs()
  #  END IF
  #TQC-A20062--mark--end
  
      LET g_wc=cl_replace_str(g_wc, "apa12", "apc04")
     #TQC-A20062--mod--str--
     #LET g_sql = "SELECT ",g_dbs_new CLIPPED,"apa_file.*,apc_file.*,pma11 ",
     #            "  FROM ",g_dbs_new CLIPPED,"apa_file LEFT OUTER JOIN ",g_dbs_new CLIPPED,"pma_file ON apa_file.apa11 = pma_file.pma01,",
     #                     g_dbs_new CLIPPED,"apc_file ",
      LET g_sql = "SELECT apa_file.*,apc_file.*,pma11 ",
                  "  FROM apa_file LEFT OUTER JOIN pma_file ON apa_file.apa11 = pma_file.pma01,",
                  "       apc_file ",
     #TQC-A20062--mod--end
                  " WHERE ", g_wc CLIPPED,
                  "   AND apc08  > (apc10+apc16+apc14)",   #85-09-24 #MOD-B70047 add apc14
                  #"   AND apa00 IN ('11','12','13','14','15')", #TQC-750140
                  "   AND apa00 IN ('11','12','14','15')",       #TQC-750140
                  "   AND apa41 = 'Y' AND apa42 = 'N'",
                  "   AND apa02 <= '",pay_date CLIPPED,"'",                 #MOD-A60109
                 #No.+118 010515 by plum add 立暫估者不產生至付款單
                  #"   AND apa08 !='UNAP' ",   #MOD-7C0153
                  "   AND (apa08 !='UNAP' OR apa08 IS NULL) ",   #MOD-7C0153
                 #No.+118..end
                  "   AND apc01 = apa01 ",                       #MOD-A60100 
                  "  ORDER BY apa06,apa07,apa13,apc05,apa01"     #MOD-A60100
      CALL s_showmsg_init()                            #No.FUN-710074 by hellen
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      LET l_fag = 0  #MOD-960157 
      PREPARE p310_prepare FROM g_sql
      DECLARE p310_cs CURSOR FOR p310_prepare
      FOREACH p310_cs INTO g_apa.*,g_apc.*,l_pma11     #No.FUN-680027 add apc
         IF STATUS THEN
           #TQC-A20062--mod--str--
           #LET g_msg = "p310(Foreach) Plant:",g_plant_new CLIPPED," i:",i
           #CALL s_errmsg('','',g_msg,SQLCA.sqlcode,0) #No.FUN-710014
            CALL s_errmsg('','',g_msg,SQLCA.sqlcode,0)
           #TQC-A20062--mod--end
            LET g_success = 'N'
            RETURN
         END IF
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
       #CHI-A70049---mark---start---
         IF l_pma11 != pay_type THEN                  #No.MOD-B80059 remark
            #IF g_bgjob = 'N' THEN                    #FUN-570112             
                #display "pma11!=pay_type"
            #END IF                                   #FUN-570112
            CALL s_errmsg('apa01',g_apa.apa01,'','aap-740',1)  #CHI-A60007 add #No.MOD-B80059 remark
            CONTINUE FOREACH                                   #No.MOD-B80059 remark
         END IF                                                #No.MOD-B80059 remark 
       #CHI-A70049---mark---end---
         #------85-11-07 by kitty 增加判斷是否已有付款單,且未確認
         SELECT SUM(apg05f),SUM(apg05) INTO l_apg05f,l_apg05 FROM apg_file,apf_file
          WHERE apg04=g_apa.apa01 AND apf41='N' AND apf01 = apg01            #86-04-17 by danny 
            AND apg06=g_apc.apc02            #No.FUN-680027 add
         IF l_apg05f IS NULL THEN 
            LET l_apg05f = 0 
         END IF
         IF l_apg05  IS NULL THEN
            LET l_apg05  = 0
         END IF

         IF g_apz.apz27 = 'N' THEN                                                                                                  
            IF (g_apc.apc08 -g_apc.apc10 -g_apc.apc16 -g_apc.apc14)-l_apg05f<=0 OR   #MOD-B70047 add apc14 
               (g_apc.apc09-g_apc.apc11-g_apc.apc16*g_apa.apa14-g_apc.apc15)-l_apg05<=0  THEN#No.MOD-5C0068 #MOD-B70047 add apc15
               CALL s_errmsg('apa01',g_apa.apa01,'','aap-076',1)  #CHI-A60007 add
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
         ELSE                                                                                                                       
           #IF (g_apc.apc09 -g_apc.apc10 -g_apc.apc16)-l_apg05f<=0 OR                #MOD-B70047 mark 
            IF (g_apc.apc08 -g_apc.apc10 -g_apc.apc16 -g_apc.apc14)-l_apg05f<=0 OR   #MOD-B70047 add apc14 
               #(g_apc.apc13-g_apc.apc16*g_apc.apc07-g_apc.apc15)-l_apg05<=0 THEN   #A067 #MOD-B70047 add apc15 
               (g_apc.apc13-g_apc.apc16*g_apc.apc07)-l_apg05<=0 THEN   #A067 #MOD-B70047 add apc15  #MOD-BB0168
               CALL s_errmsg('apa01',g_apa.apa01,'','aap-076',1)  #CHI-A60007 add
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
         END IF                                                                                                                     
         IF g_apa.apa24 IS NULL THEN
            LET g_apa.apa24 = 0
         END IF
         IF plant_seperate = 'Y' THEN	# 因無法加傳遞參數, 故使用 apa05
            LET g_apa.apa05 = g_plant_new
         ELSE
            LET g_apa.apa05 = '#'
         END IF

        IF g_apz.apz06 = 'N' THEN
           LET g_t1=g_apa.apa01[1,g_doc_len]
           SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
           IF g_apy.apydmy3 = 'Y' AND cl_null(g_apa.apa44) THEN
              CALL s_errmsg('apa01',g_apa.apa01,'','aap-109',1)  #CHI-A60007 add
              CONTINUE FOREACH
           END IF
        END IF
         IF NOT cl_null(g_apa.apa44) AND g_apz.apz05 = 'N' THEN
            LET g_plant_new = g_apz.apz02p
            CALL s_getdbs()
            LET g_sql =
            "SELECT aba19 ",
          # "  FROM ",g_dbs_new CLIPPED,"aba_file",                  #FUN-A50102 mark
            "  FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'),  #FUN-A50012	
            "  WHERE aba01 = ? AND aba00 = ? "
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_apz.apz02p) RETURNING g_sql#FUN-A50102 
            PREPARE t310_p3x FROM g_sql DECLARE t310_c3x CURSOR FOR t310_p3x
            OPEN t310_c3x USING g_apa.apa44,g_apz.apz02b
            FETCH t310_c3x INTO l_aba19
            IF cl_null(l_aba19) THEN 
               LET l_aba19 = 'N'
            END IF
            IF l_aba19 = 'N' THEN
                IF g_bgjob = 'N' THEN                    #FUN-570112
                   display "aba19" 
                END IF
                CALL s_errmsg('apa01',g_apa.apa01,'','aap-110',1)  #CHI-A60007 add
                CONTINUE FOREACH
            END IF
         END IF
         LET l_fag = 1 #MOD-960157
        #OUTPUT TO REPORT aapp310_rep(g_plant_new,g_dbs_new,g_apa.*,g_apc.*)  #No.FUN-680027 add apc  #TQC-A20062
         OUTPUT TO REPORT aapp310_rep(g_apa.*,g_apc.*)    #TQC-A20062
      END FOREACH
  #END FOR   #TQC-A20062
   FINISH REPORT aapp310_rep
IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo 
   IF l_fag = 0 THEN                                                                                                                
      LET g_success = 'N'                                                                                                           
      CALL s_errmsg('','','','aap-129',1)
   END IF                                                                                                                           
   IF g_totsuccess="N" THEN  
      LET g_success="N"
   END IF
   CALL s_showmsg()
 
END FUNCTION
 
#REPORT aapp310_rep(l_plant_new,l_dbs_new,l_apa,l_apc)     #No.FUN-680027 add apc    #TQC-A20062
REPORT aapp310_rep(l_apa,l_apc)    #TQC-A20062
   #DEFINE l_plant_new  LIKE apb_file.apb03        # No.FUN-690028 VARCHAR(10)  #TQC-A20062
   #DEFINE l_dbs_new    LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)  #TQC-A20062
    DEFINE l_apa		RECORD LIKE apa_file.*
    DEFINE l_apc		RECORD LIKE apc_file.*    #No.FUN-680027 add
 
    #order by 廠商/簡稱/幣別/ 票據到期日/帳款
  #ORDER BY l_apa.apa06,l_apa.apa07,l_apa.apa13,              #MOD-A60100 mark
   ORDER EXTERNAL BY l_apa.apa06,l_apa.apa07,l_apa.apa13,     #MOD-A60100
            l_apc.apc05,l_apa.apa01   #No.FUN-740145
 FORMAT
    BEFORE GROUP OF l_apa.apa13   #幣別      
       LET i = 0
       LET k = 0 #CHI-A90044 add
       LET apc05_t = '010101'       #No.FUN-740145
       LET g_apa.* = l_apa.*
       CALL p310_ins_apf()		         	# Add 付款單頭
    ON EVERY ROW
       IF g_success = 'Y' THEN
          LET g_apa.* = l_apa.*
          LET g_apc.* = l_apc.*     #No.FUN-680027
         #CALL p310_ins_apg(l_plant_new,l_dbs_new)	# Add 付款單借方單身   #TQC-A20062
          CALL p310_ins_apg()    #TQC-A20062
       END IF
    AFTER GROUP OF l_apa.apa13
       IF g_success = 'Y' THEN
         #CALL p310_ins_aph(l_plant_new,l_dbs_new)	# Add 付款單貸方單身   #TQC-A20062
         CALL p310_ins_aph()     #TQC-A20062
       END IF
       IF g_success = 'Y' THEN
         #CALL p310_upd_aph(l_plant_new,l_dbs_new)	# Add 付款單貸方單身   #TQC-A20062
         CALL p310_upd_aph()     #TQC-A20062
       END IF
       IF g_success = 'Y' THEN
          CALL p310_upd_apf()                           # 單頭合計金額
       END IF
       IF g_start_no IS NULL THEN LET g_start_no = g_apf.apf01 END IF
       LET g_end_no = g_apf.apf01
       LET g_tot    = g_tot + g_apf.apf10
       LET g_cnt    = g_cnt + 1
END REPORT
 
FUNCTION p310_ins_apf()
    DEFINE li_result   LIKE type_file.num5     #FUN-560096  #No.FUN-690028 SMALLINT
   #DEFINE g_t2        LIKE apy_file.apyslip       #MOD-990168 #MOD-B10132 mark 
    DEFINE ls_doc      STRING                         #MOD-B40058 
    DEFINE lc_doc      LIKE aba_file.aba00     # 單別 #MOD-B40058
    DEFINE l_inx_s     LIKE type_file.num10           #MOD-B40058

    INITIALIZE g_apf.* TO NULL

   #-MOD-B40058-add-
    LET ls_doc = tr_type 
    LET l_inx_s = ls_doc.getIndexOf("-",1)
    IF l_inx_s > 0 THEN
       LET ls_doc = ls_doc.subString(1,l_inx_s - 1)
    END IF
    LET lc_doc = ls_doc 
    SELECT * INTO g_apy.* 
      FROM apy_file 
     WHERE apyslip = lc_doc 
   #-MOD-B40058-end- 

    CALL s_auto_assign_no("aap",tr_type,pay_date,"33","","","","","")   #FUN-560096
         RETURNING li_result,g_apf.apf01   #FUN-560096
    IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
    END IF
 
    IF g_i THEN LET g_success = 'N' RETURN END IF
    LET g_apf.apf00 = '33'
    LET g_apf.apf02 = pay_date
    LET g_apf.apf03 = g_apa.apa06
    LET g_apf.apf12 = g_apa.apa07
    LET g_apf.apf13 = g_apa.apa18
    LET g_apf.apf04 = emp_no
    LET g_apf.apf05 = dept
    LET g_apf.apf06 = g_apa.apa13
    CALL s_curr3(g_apf.apf06,g_apf.apf02,g_apz.apz33) RETURNING g_apf.apf07 #FUN-640022
   #IF g_apf.apf07 = 0 THEN LET g_apf.apf07 = 1 END IF                          #MOD-B20016 mark
    IF g_apf.apf07 = 0 OR cl_null(g_apf.apf07) THEN LET g_apf.apf07 = 1 END IF  #MOD-B20016
    LET g_apf.apf08f= 0 LET g_apf.apf08 = 0
    LET g_apf.apf09f= 0 LET g_apf.apf09 = 0
    LET g_apf.apf10f= 0 LET g_apf.apf10 = 0
    LET g_apf.apf14 = apf14
    LET g_apf.apf41 = 'N'   
    LET g_apf.apfmksg=g_apy.apyapr
    LET g_apf.apfuser=g_user
    LET g_apf.apfgrup=g_grup
    LET g_apf.apfinpd=g_today
    LET g_apf.apfacti='Y'
    LET g_apg.apg02 = 0
    LET g_discount=0
    LET g_t2 = tr_type[1,g_doc_len]                                                                                                 
    SELECT apyapr,apydmy3 INTO g_apf.apfmksg,g_apydmy3 FROM apy_file #MOD-B10132 add apydmy3                                                                                   
     WHERE apyslip = g_t2  

    LET g_apf.apf42 = '0' #MOD-960161   
    LET g_apf.apflegal = g_legal #FUN-980001 add
    LET g_apf.apforiu = g_user      #No.FUN-980030 10/01/04
    LET g_apf.apforig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO apf_file VALUES(g_apf.*)
   IF g_bgjob = 'N' THEN                    #FUN-570112
       DISPLAY "add apf(",SQLCA.sqlcode,"):",g_apf.apf01,' ',g_apf.apf02,' ',
                          g_apf.apf03,' ',g_apf.apf04 AT 1,1
   END IF   
   #IF SQLCA.sqlcode THEN                             #MOD-A60100 mark
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     #MOD-A60100 
       CALL cl_err3("ins","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","p310_ins_apf",1)   #No.FUN-660122
       LET g_success = 'N'
    END IF
END FUNCTION
 
#FUNCTION p310_ins_apg(p_plant_new,p_dbs_new)    #TQC-A20062
FUNCTION p310_ins_apg()     #TQC-A20062
   #DEFINE p_plant_new		LIKE apg_file.apg03  #FUN-660117   #TQC-A20043
   #DEFINE p_dbs_new            LIKE type_file.chr21     # No.FUN-690028 VARCHAR(21)  #TQC-A20043
    DEFINE l_pma04              LIKE pma_file.pma04  #No.FUN-690028 DECIMAL(5,2)
 

    LET g_apg.apg05f=g_apc.apc08 -g_apc.apc10 -g_apc.apc16 -g_apc.apc14 #MOD-B70047 add apc14 
    IF g_apz.apz27 = 'N' THEN    
       LET g_apg.apg05 =g_apc.apc09 -g_apc.apc11 -g_apc.apc16*g_apa.apa14 -g_apc.apc15 #MOD-B70047 add apc15 
    ELSE
       #LET g_apg.apg05 =g_apc.apc13 -g_apc.apc16*g_apa.apa72 -g_apc.apc15 #MOD-B70047 add apc15 
       LET g_apg.apg05 =g_apc.apc13 -g_apc.apc16*g_apa.apa72  #MOD-B70047 add apc15  #MOD-BB0166
    END IF 
    IF cl_null(g_apg.apg05) THEN LET g_apg.apg05=0 END IF 
    IF cl_null(g_apg.apg05) THEN LET g_apg.apg05=0 END IF   #No:8165

    IF g_apg.apg05f <= 0 AND g_apg.apg05 <= 0 THEN RETURN END IF
    LET g_apg.apg01 = g_apf.apf01
    LET g_apg.apg02 = g_apg.apg02 + 1
   #LET g_apg.apg03 = p_plant_new   #TQC-A20062
    LET g_apg.apg04 = g_apa.apa01
    LET g_apg.apg06 =  g_apc.apc02   #No.FUN-680027 add
    LET g_apg.apglegal = g_legal #FUN-980001 add
    INSERT INTO apg_file VALUES(g_apg.*)
   IF g_bgjob = 'N' THEN                    #FUN-570112
       DISPLAY "add apg(",SQLCA.sqlcode,"):",g_apg.apg01,' ',g_apg.apg02,' ',
                          g_apg.apg03,' ',g_apg.apg04,' ',g_apg.apg05 AT 2,1
   END IF  
   #IF SQLCA.sqlcode THEN                             #MOD-A60100 mark
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     #MOD-A60100 
       CALL cl_err3("ins","apg_file",g_apg.apg01,g_apg.apg02,SQLCA.sqlcode,"","p310_ins_apg(ckp#1)",1)   #No.FUN-660122
       LET g_success = 'N'
       RETURN
    END IF
    LET g_apf.apf08f= g_apf.apf08f+ g_apg.apg05f
    LET g_apf.apf08 = g_apf.apf08 + g_apg.apg05
    IF g_apc.apc05 < g_apf.apf02 THEN LET g_apc.apc05 = g_apf.apf02 END IF    #No.MOD-B80109 add
    #CHI-A90044 mod g_arr[i]->g_arr[k] --start--
    IF (g_apc.apc05 = apc05_t) OR (g_apc.apc05 IS NULL AND apc05_t IS NULL)     #No.FUN-740145
       THEN LET g_arr[k].amountf= g_arr[k].amountf+ g_apg.apg05f
            LET g_arr[k].amount = g_arr[k].amount + g_apg.apg05
       ELSE LET k = k + 1
            LET g_arr[k].duedate = g_apc.apc05       #No.FUN-740145
            LET g_arr[k].amountf= g_apg.apg05f
            LET g_arr[k].amount = g_apg.apg05
            LET apc05_t = g_apc.apc05                #No.FUN-740145
    END IF
    #CHI-A90044 mod g_arr[i]->g_arr[k] --end--
END FUNCTION
 
#FUNCTION p310_ins_aph(p_plant_new,p_dbs_new)    #TQC-A20062
FUNCTION p310_ins_aph()           #TQC-A20062
   #DEFINE p_plant_new		LIKE apg_file.apg03  #FUN-660117    #TQC-A20062
   #DEFINE p_dbs_new		LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)   #TQC-A20062
    DEFINE mm,dd,dd2  LIKE type_file.num10       # No.FUN-690028 INTEGER
    DEFINE c_date     LIKE type_file.chr8        # No.FUN-690028 VARCHAR(6)
    DEFINE l_seq      LIKE type_file.num10       # No.FUN-690028 INTEGER
    DEFINE l_x        LIKE type_file.num5        # No.FUN-690028 SMALLINT
    DEFINE l_i,l_j    LIKE type_file.num5    #No.FUN-690028 SMALLINT
    DEFINE l_sw       LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aph  RECORD LIKE aph_file.*
    DEFINE l_apa00      LIKE apa_file.apa00
    DEFINE l_apa01      LIKE apa_file.apa01
    DEFINE l_apa34      LIKE apa_file.apa34     #No.MOD-B80130 add
    DEFINE l_apa35      LIKE apa_file.apa35     #No.MOD-B80130 add
    DEFINE l_cnt        LIKE type_file.num10    #No.MOD-B80130 add
    DEFINE l_drcostf    LIKE apa_file.apa34f
    DEFINE l_drcost     LIKE apa_file.apa34
    DEFINE l_drtotf     LIKE apa_file.apa34f
    DEFINE l_drtot      LIKE apa_file.apa34
    DEFINE l_check_costf LIKE apa_file.apa34f
    DEFINE l_check_cost LIKE apa_file.apa34
    DEFINE l_azi04      LIKE azi_file.azi04        #取對應幣種的小數位數。   #No.MOD-7B0149
 
 
    LET g_seq = 0
    LET g_sw  = 'N'
    LET l_drtotf= g_apf.apf08f
    LET l_drtot = g_apf.apf08
   #TQC-A20062--mark--str--
   #FOR l_i = 1 TO g_dbs_cnt
   #   IF g_apz.apz26 = 'N' THEN		# 不允許多工廠付款   #TQC-630135
   #      IF l_i = 1 THEN
   #         LET g_plant_new = g_plant LET g_dbs_new = NULL
   #      ELSE 
   #         EXIT FOR
   #      END IF
   #   END IF
   #   IF g_apz.apz26 = 'Y' THEN		# 允許多工廠付款   #TQC-630135
   #      IF plant[l_i] IS NULL THEN CONTINUE FOR END IF
   #      LET g_plant_new = plant[l_i]
   #      FOR l_j = 1 TO l_i			# 若 Plant 選擇重複, 則 Skip
   #      FOR l_j = 1 TO l_i			# 若 Plant 選擇重複, 則 Skip
   #         IF plant[l_j] = g_plant_new THEN EXIT FOR END IF
   #      END FOR
   #      IF l_j < l_i THEN CONTINUE FOR END IF
   #      CALL s_getdbs()
   #   END IF
       #--->帳款扣項
   #TQC-A20062--mark--end
                                                                            
       IF g_apz.apz27 = 'N' THEN                                                                                                    

          LET g_sql = "SELECT apa00,apa01,(apc08 -apc10 -apc16 -apc14),",      #MOD-B70047 add apc14 
                      "       (apc09-apc11-apc16*apa14-apc15),apa13,apa14,",   #MOD-B70047 add apc15
                      "       apa34,apa35,apc02                           ",   #MOD-B80130 add #MOD-C80144 add apc02
                     #TQC-A20062--mod--str--
                     #" FROM ",g_dbs_new CLIPPED,"apa_file  ,",                                                                       
                     #         g_dbs_new CLIPPED,"apc_file   ",                                                                       
                      " FROM apa_file  ,apc_file ",
                     #TQC-A20062--mod--end
                      " WHERE apa06 = '",g_apf.apf03,"'",  #廠商編號  #MOD-910101 mod g_apa.apa06->g_apf.apf03
                      "   AND apa07 = '",g_apf.apf12,"'",  #廠商NAME  #MOD-910101 mod g_apa.apa07->g_apf.apf12
                      "   AND apa01 = apc01  ",
#                     "   AND apa00 matches '2*'",           #No.TQC-AC0404
                      "   AND apa00 LIKE '2%'",              #No.TQC-AC0404                                                                       
                      "   AND (apa00 = '21' OR  ",
                      "       (apa00 <> '21' AND apa08 != apa01))",
                      "   AND apa00 != '26'",   #TQC-750019 add
                      "   AND apc09 > (apc11+apc16*apa14) ",
                      "   AND apa02 <= '",pay_date CLIPPED,"'",                 #MOD-A60109
                      "   AND (apa58 = '2' OR apa58 ='3' OR apa58 IS NULL) ",                                                       
                      "   AND apa41 = 'Y' AND apa42 = 'N'"                                                                          
       ELSE               

          LET g_sql = "SELECT apa00,apa01,(apc08 -apc10 -apc16 -apc14),",   #MOD-B70047 add apc14
                     #"       (apc13-apc16*apa72-apc15),apa13,apa72,",      #MOD-B70047 add apc15
                      "       (apc13-apc16*apa72),apa13,apa72,",            #MOD-B70047 add apc15   #MOD-BB0168
                      "       apa34,apa35,apc02                     ",      #MOD-B80130 add #MOD-C80144 add apc02
                     #TQC-A20062--mod--str--
                     #" FROM ",g_dbs_new CLIPPED,"apa_file ,",
                     #         g_dbs_new CLIPPED,"apc_file  ",   #MOD-8C0169 mod
                      " FROM apa_file ,apc_file ",
                     #TQC-A20062--mod--end
                      " WHERE apa06 = '",g_apf.apf03,"'",  #廠商編號  #MOD-910101 mod g_apa.apa06->g_apf.apf03
                      "   AND apa07 = '",g_apf.apf12,"'",  #廠商NAME  #MOD-910101 mod g_apa.apa07->g_apf.apf12
                      "   AND apa01 = apc01 ",
#                     "   AND apa00 matches '2*'",                 #No.TQC-AC0404
                      "   AND apa00 LIKE '2%'",                    #No.TQC-AC0404                                                                  
                      "   AND (apa00 = '21' OR  ",
                      "       (apa00 <> '21' AND apa08 != apa01))",
                      "   AND apa00 != '26'",   #TQC-750019 add
                      "   AND apc13-(apc16*apa72)>0 ",                                                                              
                      "   AND apa02 <= '",pay_date CLIPPED,"'",                 #MOD-A60109
                      "   AND (apa58 = '2' OR apa58 ='3' OR apa58 IS NULL) ",                                                       
                      "   AND apa41 = 'Y' AND apa42 = 'N'"                                                                          
       END IF                                                                                                                       
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       PREPARE p310_predr FROM g_sql
       DECLARE p310_csdr CURSOR WITH HOLD FOR p310_predr   
       #-->帳款扣項(折讓/D.M./預付)
       FOREACH p310_csdr INTO l_apa00,l_apa01,l_drcostf,l_drcost,
                              l_aph.aph13,l_aph.aph14,
                              l_apa34,l_apa35,l_aph.aph17     #No.MOD-B80130 add #MOD-C80144 add aph17
          IF SQLCA.sqlcode THEN 
             CALL cl_err('p310_csdr',SQLCA.sqlcode,0)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          IF sw_21='N' AND l_apa00='21' THEN CONTINUE FOREACH END IF
          IF sw_22='N' AND l_apa00='22' THEN CONTINUE FOREACH END IF
          IF sw_23='N' AND l_apa00='23' THEN CONTINUE FOREACH END IF
          IF assign = 'Y' AND l_aph.aph13 <> curr THEN CONTINUE FOREACH END IF #MOD-C80144 add
          LET g_seq = g_seq + 1
          LET l_aph.aph01 = g_apf.apf01   #付款單號
          LET l_aph.aph02 = g_seq         #項次
          CASE 
            WHEN l_apa00 = '21'  LET l_aph.aph03 = '6'
            WHEN l_apa00 = '22'  LET l_aph.aph03 = '7'
            WHEN l_apa00 = '23'  LET l_aph.aph03 = '8'
            WHEN l_apa00 = '24'  LET l_aph.aph03 = '9'
            OTHERWISE  LET l_aph.aph03 = '3'
          END CASE
         #----------------------------------MOD-C80144-----------------------mark
         #IF l_aph.aph03 MATCHES "[6,7,8,9]" THEN
         ##-----------------------No.MOD-B80130-----------------------------start
         #   SELECT COUNT(*) INTO l_cnt FROM aph_file
         #    WHERE aph04=l_apa01 and aph05 = l_apa34-l_apa35

         #    IF l_cnt > 0 THEN
         #       CONTINUE FOREACH
         #    END IF
         ##-----------------------No.MOD-B80130-------------------------------end
         #   SELECT MAX(aph17)+1 INTO l_aph.aph17 FROM aph_file
         #   #WHERE aph01=l_aph.aph17                               #MOD-A60100 mark
         #   #WHERE aph01=l_aph.aph01                               #MOD-A60100 #MOD-A60200 mark
         #    WHERE aph04=l_apa01                                   #MOD-A60200 add
         #   IF cl_null(l_aph.aph17) OR STATUS THEN
         #      LET l_aph.aph17=1
         #   END IF 
         #ELSE
         #   LET l_aph.aph17 = NULL 
         #END IF
         #----------------------------------MOD-C80144-----------------------mark
          IF l_aph.aph03 NOT MATCHES "[6,7,8,9]" THEN         #MOD-C80144 add
             LET l_aph.aph17 = NULL                           #MOD-C80144 add
          END IF                                              #MOD-C80144 add
         #IF l_drtot < l_drcost THEN                          #MOD-C80144 mark
          IF l_drtot <= l_drcost THEN                         #MOD-C80144 add
             IF g_apf.apf06 = l_aph.aph13 THEN                #MOD-C80144 add
               LET l_drcostf= l_drtotf
             END IF                                           #MOD-C80144 add
             LET l_drcost = l_drtot
             LET g_sw = 'Y' 
          ELSE LET l_drtotf= l_drtotf- l_drcostf
               LET l_drtot = l_drtot - l_drcost
          END IF
          LET l_aph.aph04 = l_apa01         #帳款編號
          LET l_aph.aph05f= l_drcostf       #貸方金額(原幣)   

           #原幣金額將根據幣種進行取位調整。
           SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_aph.aph13
           CALL cl_digcut(l_aph.aph05f,l_azi04) RETURNING l_aph.aph05f
          LET l_aph.aph05 = l_drcost        #貸方金額(本幣)
          LET l_aph.aph06 = null         LET l_aph.aph07 = null
          LET l_aph.aph08 = null         LET l_aph.aph09 = 'N'  #3385
          LET l_aph.aphlegal = g_legal #FUN-980001 add
#FUN-A20010 --Begin
#         LET l_aph.aph18 = r_type    #FUN-970077 add
#         LET l_aph.aph19 = '3'       #FUN-970077 add
          LET l_aph.aph18 = ''
          LET l_aph.aph19 = ''
          LET l_aph.aph20 = ''
                                                                                                                                    
          IF pay_type = "2" THEN
             SELECT pmf14,pmf15,pmf11 INTO l_aph.aph18,l_aph.aph19,l_aph.aph20
               FROM pmf_file
              WHERE pmf01 = g_apf.apf03
                AND pmf08 = g_apf.apf06
                AND pmf05 = 'Y'
                AND pmfacti = 'Y'
            #-MOD-B30007-add-
             IF cl_null(l_aph.aph19) THEN
                LET l_aph.aph19 = '1'
             END IF
            #-MOD-B30007-end-
          ELSE
             LET l_aph.aph19 = '3'
          END IF
#FUN-A20010 --End
          INSERT INTO aph_file VALUES(l_aph.*)
          IF g_bgjob = 'N' THEN                    #FUN-570112
              DISPLAY "add aph_dr(",SQLCA.sqlcode,"):",g_aph.aph01,' ',g_aph.aph02
                        AT 3,1
          END IF 
         #IF SQLCA.sqlcode THEN                             #MOD-A60100 mark
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     #MOD-A60100 
             CALL cl_err3("ins","aph_file",l_aph.aph01,l_aph.aph02,SQLCA.sqlcode,"","p310_ins_aph(ckp#2_CR)",1)   #NO.FUN-660122
             LET g_success = 'N'
             RETURN
          END IF
          LET g_apf.apf10f= g_apf.apf10f+ l_aph.aph05f
          LET g_apf.apf10 = g_apf.apf10 + l_aph.aph05
          IF g_sw = 'Y' THEN EXIT FOREACH END IF
       END FOREACH 
      #-MOD-C80144-add-
       LET l_cnt = 0
       SELECT COUNT(aph13) INTO l_cnt
         FROM aph_file
        WHERE aph01 = g_apf.apf01
          AND aph13 <> g_apf.apf06
          AND aph05f <> 0
       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       IF l_cnt > 0 THEN
          LET g_apf.apf10f = 0
       END IF
      #-MOD-C80144-end-
   #END FOR    #TQC-A20062
END FUNCTION
 
#FUNCTION p310_upd_aph(p_plant_new,p_dbs_new)   #TQC-A20062
FUNCTION p310_upd_aph()              #TQC-A20062
   #DEFINE p_plant_new		LIKE apg_file.apg03  #FUN-660117   #TQC-A20062
   #DEFINE p_dbs_new		LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)   #TQC-A20062
    DEFINE mm,dd,dd2  LIKE type_file.num10       # No.FUN-690028 INTEGER
    DEFINE c_date     LIKE type_file.chr8        # No.FUN-690028 VARCHAR(6)
    DEFINE l_seq      LIKE type_file.num10       # No.FUN-690028 INTEGER
    DEFINE l_x        LIKE type_file.num5        # No.FUN-690028 SMALLINT
    DEFINE l_i,l_j    LIKE type_file.num5    #No.FUN-690028 SMALLINT
    DEFINE l_sw       LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aph07      LIKE aph_file.aph07
    DEFINE l_aph        RECORD LIKE aph_file.*
    DEFINE l_apa00      LIKE apa_file.apa00
    DEFINE l_apa01      LIKE apa_file.apa01
    DEFINE l_drcostf    LIKE apa_file.apa34f
    DEFINE l_drcost     LIKE apa_file.apa34
    DEFINE l_drtotf     LIKE apa_file.apa34f
    DEFINE l_drtot      LIKE apa_file.apa34
    DEFINE l_nma10      LIKE nma_file.nma10 
    DEFINE l_check_costf LIKE apa_file.apa34f
    DEFINE l_check_cost LIKE apa_file.apa34
    DEFINE l_n       	LIKE type_file.num5       #No.FUN-690028 SMALLINT
    DEFINE DMf,DM       LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
    DEFINE t_azi07     LIKE azi_file.azi07   #No.MOD-670063
    DEFINE l_azi04      LIKE azi_file.azi04  #No.MOD-7B0149
    DEFINE l_pmc281     LIKE pmc_file.pmc281  #0:手續費外加 1:手續費內扣 #CHI-A90044 add
    DEFINE l_cnt        LIKE type_file.num10      #No.TQC-B90106
 
 
       IF g_sw = 'Y' THEN RETURN END IF		# 用待抵帳款沖即可, 不必付現
       LET DMf =g_apf.apf10f
       LET DM  =g_apf.apf10
       IF post_fee_sw = 'Y' THEN  #扣郵資/手續費
         #SELECT pmc28 INTO post_fee FROM pmc_file WHERE pmc01 = g_apf.apf03 #CHI-A90044 mark
          SELECT pmc28,pmc281 INTO post_fee,l_pmc281 FROM pmc_file WHERE pmc01 = g_apf.apf03 #CHI-A90044
          IF STATUS THEN
             CALL cl_err3("sel","pmc_file",g_apf.apf03,"",STATUS,"","set pmc28",1)   #No.FUN-660122
             LET post_fee = 0 
          END IF
       ELSE 
          LET post_fee = 0
       END IF
       IF cl_null(post_fee) THEN LET post_fee = 0 END IF
    LET l_x = 0
    LET i = 1     #TQC-A20062
    FOR j = 1 TO k  #CHI-A90044 mod i->k
       IF DMf > g_arr[j].amountf THEN
          LET DMf = DMf - g_arr[j].amountf
          LET DM  = DM  - g_arr[j].amount
          CONTINUE FOR
       END IF
       #同一廠商, 只扣一次郵資
       LET l_x = l_x + 1
       IF l_x = 1 THEN
          #CHI-A90044 mod --start--
          #LET l_check_costf= g_arr[j].amountf- DMf - post_fee /g_apf.apf07
          #LET l_check_cost = g_arr[j].amount - DM  - post_fee 
          IF l_pmc281 = '0' THEN #0:手續費外加 
            #CHI-B10014 mod --start--
            #LET l_check_costf= g_arr[j].amountf- DMf  
            #LET l_check_cost = g_arr[j].amount - DM 
             LET l_check_costf= g_arr[j].amountf- DMf + post_fee /g_apf.apf07 
             LET l_check_cost = g_arr[j].amount - DM  + post_fee 
            #CHI-B10014 mod --end--
          ELSE #1:手續費內扣
             LET l_check_costf= g_arr[j].amountf- DMf - post_fee /g_apf.apf07
             LET l_check_cost = g_arr[j].amount - DM  - post_fee 
          END IF
          #CHI-A90044 mod --end--
       ELSE 
          LET l_check_costf= g_arr[j].amountf- DMf /g_apf.apf07
          LET l_check_cost = g_arr[j].amount - DM  
       END IF
       LET DMf = 0
       LET DM  = 0
       IF l_check_cost > 0 THEN 
         #-MOD-B30008-add-
          #IF cl_null(g_apz.apz58) THEN                       #No.TQC-B40046
          IF cl_null(g_apz.apz58) AND pay_type = '2' THEN     #No.TQC-B40046
             CALL s_errmsg('apa01',g_apa.apa01,'aaps100','aap-307',1)  
             LET g_success = 'N'
             RETURN
          END IF
         #-MOD-B30008-end-
          LET g_seq = g_seq + 1
          LET g_aph.aph01 = g_apf.apf01
          LET g_aph.aph02 = g_seq
          LET g_aph.aph03 = pay_type
          #no.5323 若為轉帳則自動default 銀存異動碼
          IF g_aph.aph03 = '2' THEN  
             LET g_aph.aph16 = g_apz.apz58
          END IF 
          IF g_aph.aph03 MATCHES "[6,7,8,9]" THEN
             SELECT MAX(aph17)+1 INTO g_aph.aph17 FROM aph_file 
             WHERE aph01=g_aph.aph01
             IF cl_null(g_aph.aph17) OR STATUS THEN
                LET g_aph.aph17 = 1
             END IF
          ELSE
             LET g_aph.aph17 = NULL
          END IF
          LET g_aph.aph05f= l_check_costf   #MOD-7B0157   #MOD-840062取消mark
          LET g_aph.aph05= l_check_cost   #MOD-7B0157
          LET g_aph.aph07 = g_arr[j].duedate
           IF g_aph.aph07 < g_apf.apf02 THEN      #No.MOD-490105
             LET g_aph.aph07 = g_apf.apf02
          END IF
    
    #當g_aph.aph03='2'或'c'時,才做假日問題處理            #MOD-930165
    IF g_aph.aph03 = '2' OR g_aph.aph03 = 'C' THEN       #MOD-930165
          LET l_n = WEEKDAY(g_aph.aph07)	# 若為週日
          IF l_n = 0 THEN LET g_aph.aph07 = g_aph.aph07 + 1 END IF
          IF l_n = 6 THEN LET g_aph.aph07 = g_aph.aph07 + 2 END IF
          SELECT nph02 INTO g_buf FROM nph_file WHERE nph01=g_aph.aph07 #假日
          #no.4313 找尋下一個工作日
          IF STATUS = 0 THEN
             SELECT MIN(sme01) INTO l_aph07 FROM sme_file
              WHERE sme01 > g_aph.aph07 AND sme02 = 'Y'
             IF STATUS = 100 THEN 
                CALL cl_err3("sel","sme_file",g_aph.aph07,"","amr-533","","",1)   #No.FUN-660122
             ELSE
                LET g_aph.aph07 = l_aph07
             END IF
          END IF
      END IF         #MOD-930165
          LET g_aph.aph08 = bankno
          IF pay_type = "2" THEN
             LET g_aph.aph04 = np_actno
             IF g_aza.aza63 = 'Y' THEN
                LET g_aph.aph041 = np_actno1
             END IF
          ELSE
              IF g_apf.apf02 = g_aph.aph07 AND g_apz.apz52 = '2' THEN    #No.MOD-490105
                LET g_aph.aph04 = bank_actno
                IF g_aza.aza63 = 'Y' THEN
                   LET g_aph.aph041 = bank_actno1
                END IF
             ELSE 
                LET g_aph.aph04 = np_actno
                IF g_aza.aza63 = 'Y' THEN
                   LET g_aph.aph041 = np_actno1
                END IF
             END IF
          END IF
          LET g_aph.aph09 = 'N'  #3385

         IF assign = 'Y' THEN
            LET g_aph.aph13 = curr
         ELSE   
            SELECT nma10 INTO l_nma10 FROM nma_file WHERE nma01=g_aph.aph08
            LET g_aph.aph13 = l_nma10
         END IF

         SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
           WHERE azi01 = g_aph.aph13 
        #LET g_aph.aph14 =  s_curr3(g_aph.aph13,g_apf.apf02,g_apz.apz33)            #MOD-A50185 mark
         CALL s_bankex(g_aph.aph08,g_apf.apf02) RETURNING g_aph.aph14   #MOD-A50185 add
         LET g_aph.aph14 = cl_digcut(g_aph.aph14,t_azi07)
         IF g_aph.aph14 = 0 OR cl_null(g_aph.aph14) THEN
            LET g_aph.aph14 = 1
         END IF
         IF g_aph.aph13 <> g_apf.apf06 THEN  #MOD-840062
            LET g_aph.aph05f = g_aph.aph05 / g_aph.aph14
         ELSE
            LET g_aph.aph05 = g_aph.aph05f * g_aph.aph14
         END IF
         LET g_aph.aph05 = cl_digcut(g_aph.aph05,g_azi04)
         LET g_aph.aph05f = cl_digcut(g_aph.aph05f,t_azi04)
          LET g_aph.aphlegal = g_legal #FUN-980001 add
#FUN-A20010 --Begin
#         LET l_aph.aph18 = r_type    #FUN-970077 add
#         LET l_aph.aph19 = '3'       #FUN-970077 add
          LET l_aph.aph18 = ''
          LET l_aph.aph19 = ''
          LET l_aph.aph20 = ''
                                                                                                                                    
          IF pay_type = "2" THEN
             SELECT pmf14,pmf15,pmf11 INTO l_aph.aph18,l_aph.aph19,l_aph.aph20
               FROM pmf_file
              WHERE pmf01 = g_apf.apf03
                AND pmf08 = g_apf.apf06
                AND pmf05 = 'Y'
                AND pmfacti = 'Y'
            #-MOD-B30007-add-
             IF cl_null(l_aph.aph19) THEN
                LET l_aph.aph19 = '1'
             END IF
            #-MOD-B30007-end-
          ELSE
             LET l_aph.aph19 = '3'
          END IF
#FUN-A20010 --End
          INSERT INTO aph_file VALUES(g_aph.*)
          IF g_bgjob = 'N' THEN                    #FUN-570112
              DISPLAY "add aph(",SQLCA.sqlcode,"):",g_aph.aph01,' ',g_aph.aph02,' ',
                                 g_aph.aph04,' ',g_aph.aph05 AT 3,1
          END IF 
         #IF SQLCA.sqlcode THEN                             #MOD-A60100 mark
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     #MOD-A60100 
             CALL cl_err3("ins","aph_file",g_aph.aph01,g_aph.aph02,SQLCA.sqlcode,"","p310_ins_aph(ckp#1)",1)   #No.FUN-660122
             LET g_success = 'N'
             RETURN
          END IF
          LET g_apf.apf10f= g_apf.apf10f+ g_aph.aph05f
          LET g_apf.apf10 = g_apf.apf10 + g_aph.aph05
          LET g_apf.apf10 = cl_digcut(g_apf.apf10,g_azi04)    #TQC-B90101 add
          LET g_apf.apf10f = cl_digcut(g_apf.apf10f,t_azi04)  #TQC-B90101 add
       END IF
       
    END FOR

    #-->郵資
     IF post_fee > 0 AND pay_type MATCHES '[12C]' AND  #MOD-4A0008
       l_check_cost > 0 THEN 
       LET g_seq = g_seq + 1
       LET l_aph.aph01 = g_apf.apf01
       LET l_aph.aph02 = g_seq 
       LET l_aph.aph03 = '3'
       LET l_aph.aph17 = NULL
       IF pay_type = '1' THEN 
          LET l_aph.aph04 = g_aps47
          IF g_aza.aza63 = 'Y' THEN
             LET l_aph.aph041 = g_aps471
          END IF
       ELSE
          LET l_aph.aph04 = g_aps46
          IF g_aza.aza63 = 'Y' THEN
             LET l_aph.aph041 = g_aps461
          END IF
       END IF  
       LET l_aph.aph05f= post_fee/g_apf.apf07
       CALL cl_digcut(post_fee,g_azi04) RETURNING post_fee
       LET l_aph.aph05 = post_fee
       #CHI-B10014 add --start--
       IF l_pmc281 = '0' THEN #0:手續費外加 
          LET l_aph.aph05 = l_aph.aph05 * -1
          LET l_aph.aph05f = l_aph.aph05f * -1
       END IF
       #CHI-B10014 add --end--
       LET l_aph.aph06 = null LET l_aph.aph07 = null
       LET l_aph.aph08 = null LET l_aph.aph09 ='N' #3385 
       LET l_aph.aph13 = g_apf.apf06
       #No.TQC-B90106  --Begin
       #LET l_aph.aph14 = 1
       LET l_aph.aph14 = g_apf.apf07
       #No.TQC-B90106  --End  
#FUN-A20010 --Begin
#         LET l_aph.aph18 = r_type    #FUN-970077 add
#         LET l_aph.aph19 = '3'       #FUN-970077 add
          LET l_aph.aph18 = ''
          LET l_aph.aph19 = ''
          LET l_aph.aph20 = ''
                                                                                                                                    
          IF pay_type = "2" THEN
             SELECT pmf14,pmf15,pmf11 INTO l_aph.aph18,l_aph.aph19,l_aph.aph20
               FROM pmf_file
              WHERE pmf01 = g_apf.apf03
                AND pmf08 = g_apf.apf06
                AND pmf05 = 'Y'
                AND pmfacti = 'Y'
            #-MOD-B30007-add-
             IF cl_null(l_aph.aph19) THEN
                LET l_aph.aph19 = '1'
             END IF
            #-MOD-B30007-end-
          ELSE
             LET l_aph.aph19 = '3'
          END IF
#FUN-A20010 --End
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_aph.aph13
       CALL cl_digcut(l_aph.aph05f,l_azi04) RETURNING l_aph.aph05f
       LET l_aph.aphlegal = g_legal #FUN-980001 add
       INSERT INTO aph_file VALUES(l_aph.*)
       IF g_bgjob = 'N' THEN                    #FUN-570112
           DISPLAY "add aph_fee(",SQLCA.sqlcode,"):",g_aph.aph01,' ',g_aph.aph02
                     AT 3,1
       END IF
      #IF SQLCA.sqlcode THEN                             #MOD-A60100 mark
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     #MOD-A60100 
          CALL cl_err3("ins","aph_file",l_aph.aph01,l_aph.aph02,SQLCA.sqlcode,"","p310_ins_aph(ckp#2)",1)   #No.FUN-660122
          LET g_success = 'N'
          RETURN
       END IF
       IF l_pmc281 = '0' THEN                                            #No.MOD-B90034 add
          LET g_apf.apf10f= g_apf.apf10f+ (post_fee/g_apf.apf07) * -1    #No.MOD-B90034 add
          LET g_apf.apf10 = g_apf.apf10 + (post_fee * -1)                #No.MOD-B90034 add
       ELSE                                                              #No.MOD-B90034 add
          LET g_apf.apf10f= g_apf.apf10f+ post_fee/g_apf.apf07
          LET g_apf.apf10 = g_apf.apf10 + post_fee
       END IF                                                            #No.MOD-B90034 add
    END IF
  
    #No.TQC-B90106  --Begin
    #当付款单身多币种时,apf10f没有意义
    LET l_cnt = 0
    SELECT COUNT(UNIQUE aph13) INTO l_cnt FROM aph_file
     WHERE aph01=g_apf.apf01
    IF l_cnt > 1 THEN
       LET g_apf.apf10f = 0
    END IF
    #No.TQC-B90106  --End  

    IF g_apf.apf08f=g_apf.apf10f AND g_apf.apf08!=g_apf.apf10 THEN
       LET g_seq = g_seq + 1
       LET l_aph.aph01 = g_apf.apf01
       LET l_aph.aph02 = g_seq 
       LET l_aph.aph05f= 0
       LET l_aph.aph05 = g_apf.apf08-g_apf.apf10
       CALL cl_digcut(l_aph.aph05,g_azi04) RETURNING l_aph.aph05
       LET l_aph.aph06 = null LET l_aph.aph07 = null
       LET l_aph.aph08 = null LET l_aph.aph09 = 'N' #3385
       LET l_aph.aph13 = g_aza.aza17
       LET l_aph.aph14 = 1
#FUN-A20010 --Begin
#         LET l_aph.aph18 = r_type    #FUN-970077 add
#         LET l_aph.aph19 = '3'       #FUN-970077 add
          LET l_aph.aph18 = ''
          LET l_aph.aph19 = ''
          LET l_aph.aph20 = ''
                                                                                                                                    
          IF pay_type = "2" THEN
             SELECT pmf14,pmf15,pmf11 INTO l_aph.aph18,l_aph.aph19,l_aph.aph20
               FROM pmf_file
              WHERE pmf01 = g_apf.apf03
                AND pmf08 = g_apf.apf06
                AND pmf05 = 'Y'
                AND pmfacti = 'Y'
            #-MOD-B30007-add-
             IF cl_null(l_aph.aph19) THEN
                LET l_aph.aph19 = '1'
             END IF
            #-MOD-B30007-end-
          ELSE
             LET l_aph.aph19 = '3'
          END IF
#FUN-A20010 --End
       IF g_apf.apf08>g_apf.apf10
          THEN LET l_aph.aph03 = '4' LET l_aph.aph04 = g_aps43
               IF g_aza.aza63 = 'Y' THEN
                  LET l_aph.aph041 = g_aps431
               END IF
          ELSE LET l_aph.aph03 = '5' LET l_aph.aph04 = g_aps42
               IF g_aza.aza63 = 'Y' THEN
                  LET l_aph.aph041 = g_aps421
               END IF
       END IF
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_aph.aph13
       CALL cl_digcut(l_aph.aph05f,l_azi04) RETURNING l_aph.aph05f
       LET l_aph.aphlegal = g_legal #FUN-980001 add
       INSERT INTO aph_file VALUES(l_aph.*)	# 匯兌損益
      #-MOD-A60100-add-
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
          CALL cl_err3("ins","aph_file",l_aph.aph01,l_aph.aph02,SQLCA.sqlcode,"","p310_upd_aph(ckp#3)",1)  
          LET g_success = 'N'
          RETURN
       END IF
      #-MOD-A60100-end-
       LET g_apf.apf10=g_apf.apf10+l_aph.aph05
    END IF
END FUNCTION
 
FUNCTION p310_upd_apf()
    UPDATE apf_file SET  apf08f = g_apf.apf08f,
                         apf10f = g_apf.apf10f,
                         apf08  = g_apf.apf08,
                         apf10  = g_apf.apf10
           WHERE apf01 = g_apf.apf01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
       CALL cl_err3("upd","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","up_apf",0)   #No.FUN-660122
       LET g_success = 'N'
       RETURN 
    END IF
    IF g_apz.apz40 = 'N' THEN RETURN END IF  #MOD-B10132 
   #IF g_apz.apz40 = 'Y' THEN                #MOD-B10132 mark 
    IF g_apydmy3 = 'Y' THEN                  #MOD-B10132
       CALL t310_g_gl(g_apf.apf00,g_apf.apf01,'0')  #No.FUN-680029 新增參數'0'
       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
          CALL t310_g_gl(g_apf.apf00,g_apf.apf01,'1')
       END IF
    END IF
END FUNCTION
 
#FUN-A50102 ---------------------mark start-------------------------------------
#FUNCTION p310_bu(p_dbs_new)		# 960210 不再 Online update (By Roger)
#   DEFINE p_dbs_new           LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)
#   DEFINE l_year,l_mon        LIKE type_file.num10       # No.FUN-690028 INTEGER
#   DEFINE l_apa               RECORD LIKE apa_file.*
# 
##更新已付帳款------------------------------------------------------------------
#      LET g_sql =
#        "UPDATE ",p_dbs_new,"apa_file SET apa35 = apa35 + ? WHERE apa01 = ?"
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#      PREPARE p310_p5 FROM g_sql
#      EXECUTE p310_p5 USING g_apg.apg05,g_apg.apg04
#         IF SQLCA.sqlcode 
#         THEN LET g_success = 'N'
#             CALL cl_err('p310_bu(ckp#1):',SQLCA.sqlcode,1)
#             RETURN
#         END IF
##產生付款 Log------------------------------------------------------------------
#      LET g_sql = "DELETE FROM ",p_dbs_new,"ape_file WHERE apa01=?",
#                  " AND ape02=? AND ape03=? AND ape04=? "
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#      PREPARE p310_p51 FROM g_sql
#      EXECUTE p310_p51 USING g_apg.apg04,
#                             g_apg.apg03,g_apg.apg01,g_apg.apg02
#      LET g_sql = "INSERT INTO ",p_dbs_new,"ape_file VALUES(?,?,?,?,?)"
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#      PREPARE p310_p52 FROM g_sql
#      EXECUTE p310_p52 USING g_apg.apg04,g_plant,
#                             g_apg.apg01,g_apg.apg02,g_apg.apg05
#      IF STATUS THEN
#         LET g_success = 'N'
#         CALL cl_err('p310_bu(ckp#1.1):',SQLCA.sqlcode,1)
#         RETURN
#      END IF
#END FUNCTION
#FUN-A50102 ---------------------------mark end----------------------------------
 
FUNCTION p310_set_entry()
    CALL cl_set_comp_entry("np_actno,np_actno1",TRUE)
END FUNCTION
FUNCTION p310_set_no_entry()
    IF pay_type = '2' THEN
       CALL cl_set_comp_entry("np_actno,np_actno1",FALSE)
    END IF
END FUNCTION
FUNCTION p310_set_no_required()  
    CALL cl_set_comp_required("bankno,apf14",FALSE)     #MOD-980122 add apf14
END FUNCTION
 
FUNCTION p310_set_required()  
    IF pay_type = '1' OR pay_type = '2' THEN    #MOD-830237
       CALL cl_set_comp_required("bankno",TRUE)
    END IF
    IF pay_type = '2' THEN
       CALL cl_set_comp_required("apf14",TRUE)
    END IF
END FUNCTION
FUNCTION p310_set_entry_1()
    CALL cl_set_comp_entry("curr",TRUE)
END FUNCTION
FUNCTION p310_set_no_entry_1()
    IF assign = 'N' THEN
       CALL cl_set_comp_entry("curr",FALSE)
    END IF
END FUNCTION
 
FUNCTION bankno_check(p_cmd)
DEFINE p_cmd      LIKE  nma_file.nma01
DEFINE l_nmaacti  LIKE  nma_file.nmaacti
DEFINE l_nma28    LIKE  nma_file.nma28 
DEFINE l_nma10    LIKE  nma_file.nma10 
 
  LET g_errno = ''
  IF cl_null(curr) THEN        	                      
     IF pay_type = '1'  THEN 
        SELECT nmaacti,nma28 INTO l_nmaacti,l_nma28
          FROM nma_file 
         WHERE nma01 = p_cmd
        CASE 
          WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap990'
                                    LET l_nmaacti = NULL
                                    LET l_nma28   = NULL
          WHEN l_nmaacti = 'N'      LET g_errno = 'aap991'
          WHEN l_nma28 != pay_type AND g_aza.aza26 ! = '2'  LET g_errno = 'aap992'   #FUN-C80018 add AND g_aza.aza26 ! = '2'
         OTHERWISE 
               LET g_errno = SQLCA.sqlcode USING '-----'  
         END CASE       
     ELSE
     	  SELECT nmaacti,nma28 INTO l_nmaacti,l_nma28
          FROM nma_file  
         WHERE nma01 = p_cmd
        CASE 
          WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap990'
                                    LET l_nmaacti = NULL
                                    LET l_nma28   = NULL
          WHEN l_nmaacti = 'N'      LET g_errno = 'aap991'
          WHEN l_nma28 !='1' AND l_nma28 != '2'
                             AND l_nma28 != '3' 
                             AND g_aza.aza26 ! = '2'        #FUN-C80018    
                                    LET g_errno = 'aap992'      
        OTHERWISE 
               LET g_errno = SQLCA.sqlcode USING '-----'  
         END CASE 
      END IF      	        
    ELSE  
    	 IF pay_type = '1' THEN  
    	   SELECT nmaacti,nma10,nma28 INTO l_nmaacti,l_nma10,l_nma28
    	     FROM nma_file
    	    WHERE nma01 = p_cmd
    	   CASE 
          WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap990'
                                    LET l_nmaacti = NULL
                                    LET l_nma28   = NULL
          WHEN l_nmaacti = 'N'      LET g_errno = 'aap991'
          WHEN l_nma28 != pay_type  AND g_aza.aza26 ! = '2'  LET g_errno = 'aap992'   #FUN-C80018 add AND g_aza.aza26 ! = '2'
          WHEN l_nma10 != curr OR l_nma10 IS NULL   LET g_errno = 'aap993'
        OTHERWISE 
               LET g_errno = SQLCA.sqlcode USING '-----'  
         END CASE      
       ELSE
          SELECT nmaacti,nma10,nma28 INTO l_nmaacti,l_nma10,l_nma28
    	     FROM nma_file
    	    WHERE nma01 = p_cmd
    	   CASE 
          WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap990'
                                    LET l_nmaacti = NULL
                                    LET l_nma28   = NULL
           WHEN l_nma28 !='1' AND l_nma28 != '2'
                              AND l_nma28 != '3' 
                              AND g_aza.aza26!='2'             #FUN-C80018
                                    LET g_errno = 'aap992'        
          WHEN l_nma10 != curr OR l_nma10 IS NULL   LET g_errno = 'aap993'
        OTHERWISE 
               LET g_errno = SQLCA.sqlcode USING '-----'  
         END CASE     
        END IF         
    END IF    
END FUNCTION 
#No.FUN-9C0077 程式精簡
