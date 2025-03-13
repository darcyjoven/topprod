# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp112.4gl
# Descriptions...: 請款折讓產生
# Date & Author..: 93/09/03 By Roger
# 1.未篩選確認碼(apa41)為'Y',結案碼為'N'資料 2.產生至折讓單確認碼應為'Y'
# Modify.........: 97/03/12 By Danny
# 1.憑證號碼原為折讓單號, 更改為請款單號
# 2.若請款單之發票號碼為MISC時, 單身之發票號碼取自apk_file之第一筆
# 3.不再產生分錄底稿
# Modify.........: No.8681 稅別加 controlp
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-530118 05/03/17 By kitty 將GROUP SUM拿掉
# Modify ........: No.MOD-530439 05/04/06 By Nicola 匯率要帶aapt110的匯率資料
# Modify.........: No.FUN-540057 05/05/10 By wujie 發票號碼調整
# Modify.........: No.FUN-550030 05/05/12 By jackie 單據編號加大
# Modify.........: No.FUN-560002 05/06/03 By Will 單據編號修改
# Modify.........: No.FUN-560106 05/06/19 By wujie單據編號修改
# Modify.........: No.FUN-570042 05/07/05 By ching default 折讓付款日=帳款日
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5B0210 05/11/23 By Smapmin 拋轉後簽核欄位為NULL
# Modify.........: No.FUN-5B0089 05/12/30 By Rosayu 產生apa資料後要加判斷單別設定產生分錄底稿
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.TQC-630190 06/03/24 By Smapmin 欄位大小定義錯誤
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680027 06/08/14 By Rayven 多帳期修改
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By Jackho 本（原）幣取位修改
# Modify.........: No.TQC-6B0066 06/12/13 By Rayven 對原幣和本幣合計按幣種進行截位
# Modify.........: No.FUN-710014 07/01/08 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.TQC-730065 07/03/20 By jamie p112_tmp加上apa992,apa37,apa37f,apa101,apa102 
# Modify.........: No.MOD-790046 07/09/17 By Smapmin 進貨發票確認時自動產生請款折讓,不需執行此程式
#                                                    進貨發票帳款需確認後方可執行此作業
#                                                    單頭金額為單身合計金額
# Modify.........: No.TQC-790128 07/09/26 By Judy 付款日，票據到期日賦初始值
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier apb34給default值'N'
# Modify.........: No.FUN-810045 08/03/24 By rainy 項目管理，專案相關欄位代入pab_file
# Modify.........: No.FUN-840006 08/04/02 By hellen項目管理，去掉預算編號相關欄位
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-960141 09/08/12 By lutingting GP5.2修改,去除apaplant,apbplant等欄位
# Modify.........: No.MOD-970103 09/07/10 By Sarah 寫入p112_tmp失敗,造成無法拋轉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei 抓apz63欄位寫入apa77
# Modify.........: No.FUN-990014 09/09/08 By hongmei 先抓apyvcode申報統編，若無則將apz63的值寫入apa77/
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
#                                            QBE条件新增来源机构,控制在同一法人下，条件选项资料来源中心隐藏
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting拋轉apb時給欄位apb37賦值
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-9C0001 09/12/25 By lutingting t110_g_gl新增參數
# Modify.........: No.FUN-A20044 10/03/17 By vealxu ima26x 調整
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AAP
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No.FUN-A60056 10/06/24 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056內容
# Modify.........: No:CHI-A90002 10/10/06 By Summer 應過濾pmcacti='Y'才能立帳
# Modify.........: No:MOD-AB0226 10/11/25 By Dido apk171 需依據正項格式給予負項格式 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:FUN-B50016 11/05/04 By Guoch 付款廠商、發票號碼進行開創查詢
# Modify.........: No:TQC-B80026 11/08/02 By wujie 1:after group of order1后，将apa31等的赋值从sum改回原来做法
#                                                  2:aapt110如果是多发票的话，无法从apk里找到对应的发票号码，暂改为只取单头apa08
# Modify.........: No.FUN-B80058 11/08/05 By lixia 兩套帳內容修改，新增azf141
# Modify.........: No.TQC-C10017 12/02/10 By yinhy 調整apb25，apb26，apb27，apb36，apb31，apb930欄位的值
# Modify.........: No.MOD-C30301 12/03/10 By lujh 修改輸入資料后點確定程式down出的問題
# Modify.........: No:TQC-CB0002 12/11/02 By zhangweib 延續 TQC-B80026,為多發票時,調整 FETCH p112_apk_no 改為 FETCH FIRST p112_apk_no 方式抓取第一筆為代表即可
# Modify.........: No:TQC-D90022 13/09/23 By yangtt "賬款編號""賬款人員""賬款部門"新增開窗
IMPORT os     #No.FUN-9C0009  add by dxfwo
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    seperate_sw 	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
    to_trtype 		LIKE apy_file.apyslip,  # No.FUN-690028 VARCHAR(5),     #No.FUN-550030
    to_apa02		LIKE type_file.dat,     # No.FUN-690028 DATE,
    #to_apa15	 VARCHAR(4),                #FUN-660117 remark
    #to_apa16		SMALLINT,               #FUN-660117 remark
    #to_apa21	 VARCHAR(8),                #FUN-660117 remark
    #to_apa22	 VARCHAR(6),                #FUN-660117 remark
    #to_apa36	 VARCHAR(4),                #FUN-660117 remark
    to_apa15		LIKE gec_file.gec01,    #FUN-660117
    to_apa16		LIKE gec_file.gec04,    #FUN-660117
    to_apa21		LIKE gen_file.gen01,    #FUN-660117
    to_apa22		LIKE gem_file.gem01,    #FUN-660117
    to_apa36		LIKE apr_file.apr01,    #FUN-660117
    #begin_no,end_no     VARCHAR(16),              #FUN-660117 remark
    begin_no            LIKE apa_file.apa01,    #FUN-660117
    end_no              LIKE apa_file.apa01,    #FUN-660117
    g_argv1             LIKE type_file.chr20,   # No.FUN-690028 VARCHAR(10),
    body_no             LIKE type_file.num5,    # No.FUN-690028 SMALLINT,
    g_apa               RECORD LIKE apa_file.*,
    g_apc               RECORD LIKE apc_file.*, #No.FUN-680027
    g_wc,g_sql  	string,                 #No.FUN-580092 HCN
    #g_d_actno    VARCHAR(24),               #FUN-660117 remark
    #g_c_actno    VARCHAR(24),               #FUN-660117 remark
    g_d_actno   	LIKE apt_file.apt03,    #FUN-660117
    g_c_actno   	LIKE apt_file.apt04,    #FUN-660117
    g_e_actno   	LIKE apa_file.apa511,   #No.FUN-680029
    g_f_actno   	LIKE apa_file.apa541,   #No.FUN-680029
    g_gec031            LIKE gec_file.gec031,   #No.FUN-680029
    g_change_lang       LIKE type_file.chr1,    #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
    l_azi04             LIKE azi_file.azi04
DEFINE g_net            LIKE apv_file.apv04     #MOD-590440
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-690028 SMALLINT
#DEFINE source           VARCHAR(10)               #FUN-630043 #FUN-660117 remark
DEFINE source           LIKE azp_file.azp01     #FUN-660117
 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_apa05         LIKE apa_file.apa05    #CHI-A90002 add
MAIN
   DEFINE l_time  	LIKE type_file.chr8     #No.FUN-690028 VARCHAR(8)
   DEFINE l_flag        LIKE type_file.num5     #No.FUN-570112  #No.FUN-690028 SMALLINT
   DEFINE ls_date       STRING                  #->No.FUN-570112
   DEFINE   l_cmd       LIKE type_file.chr1000  #->No.FUN-570112  #No.FUN-690028 VARCHAR(30)
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc        = ARG_VAL(1)       #QBE條件
   LET seperate_sw = ARG_VAL(2)       #選項
   LET body_no     = ARG_VAL(3)       #折讓單身儲存筆數
   LET to_trtype   = ARG_VAL(4)       #折讓帳款單別
   LET ls_date     = ARG_VAL(5)
   LET to_apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
   LET to_apa15    = ARG_VAL(6)       #稅別
   LET to_apa16    = ARG_VAL(7)       #稅率
   LET to_apa21    = ARG_VAL(8)       #帳款人員
   LET to_apa22    = ARG_VAL(9)       #帳款部門
   LET to_apa36    = ARG_VAL(10)      #帳款類別
   LET g_bgjob     = ARG_VAL(11)      #背景作業
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
 
#NO.FUN-570112 MARK---------
#   OPEN WINDOW p112_w AT p_row,p_col WITH FORM "aap/42f/aapp112"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#NO.FUN-570112 MARK-----
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   CALL p112_create_tmp()
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p112()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p112_process()
            CALL s_showmsg()                  # No.FUN-710014  add  
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag    
#              LET l_cmd="chmod 777 aapp112.out"   #No.FUN-9C0009  mark by dxfwo
#              RUN l_cmd                           #No.FUN-9C0009  mark by dxfwo
               IF os.Path.chrwx("aapp112.out",511) THEN END IF  #No.FUN-9C0009  add by dxfwo     
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p112_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p112_w
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p112_process()  
         CALL s_showmsg()                      # No.FUN-710014  add    
         IF g_success = "Y" THEN
            COMMIT WORK
#           LET l_cmd="chmod 777 aapp112.out"                 #No.FUN-9C0009  mark by dxfwo
#           RUN l_cmd                                         #No.FUN-9C0009  mark by dxfwo 
            IF os.Path.chrwx("aapp112.out",511) THEN END IF   #No.FUN-9C0009  add by dxfwo
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #FUN-630043
   IF g_aza.aza53='Y' AND source!=g_plant THEN
      DATABASE g_dbs      
  #    CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
      CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
   END IF
   #FUN-630043
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
#NO.FUN-570112 END------
#NO.FUN[-570112 MARK---
#   CALL p112()
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
#   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#NO.FUN-570112 MARK---
END MAIN
 
FUNCTION p112()
   DEFINE   l_cmd 	     LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(30)
#            l_flag           LIKE type_file.num5,    NO.FUN-570112 MARK  #No.FUN-690028 SMALLINT
            li_result        LIKE type_file.num5              #No.FUN-560002  #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd           LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(500)           #No.FUN-570112
   DEFINE l_azp02   LIKE azp_file.azp02  #FUN-630043
   DEFINE l_azp03   LIKE azp_file.azp03  #FUN-630043
 
 
WHILE TRUE
   LET g_action_choice = ""
#->No.FUN-570112 --start--
   OPEN WINDOW p112_w AT p_row,p_col WITH FORM "aap/42f/aapp112"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
#->No.FUN-570112 ---end---
 
    CALL cl_set_comp_visible("group05", FALSE)   #FUN-990031
 
   #-----MOD-790046---------
   IF g_apz.apz60 = 'Y' THEN
      CALL cl_err('','aap-200',1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   #-----END MOD-790046-----
 
   CLEAR FORM
 
      #FUN-630043
      LET source=g_plant 
      LET l_azp02=''
      DISPLAY BY NAME source
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=source
      DISPLAY l_azp02 TO FORMONLY.azp02
      IF g_aza.aza53='Y' THEN
         INPUT BY NAME source WITHOUT DEFAULTS
            AFTER FIELD source 
               LET l_azp02=''
               SELECT azp02 INTO l_azp02 FROM azp_file
                  WHERE azp01=source
               IF STATUS THEN
#                 CALL cl_err(source,'100',0)   #No.FUN-660122
                  CALL cl_err3("sel","azp_file",source,"","100","","",0)   #No.FUN-660122
                  NEXT FIELD source
               END IF
               DISPLAY l_azp02 TO FORMONLY.azp02
 
            AFTER INPUT
               IF INT_FLAG THEN EXIT INPUT END IF  
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(source)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azp"
                       LET g_qryparam.default1 = source
                       CALL cl_create_qry() RETURNING source 
                       DISPLAY BY NAME source
                       NEXT FIELD source
               END CASE
 
            ON ACTION exit              #加離開功能genero
               LET INT_FLAG = 1
               EXIT INPUT
 
            ON ACTION controlg       #TQC-860021
               CALL cl_cmdask()      #TQC-860021
       
            ON IDLE g_idle_seconds   #TQC-860021
               CALL cl_on_idle()     #TQC-860021
               CONTINUE INPUT        #TQC-860021
       
            ON ACTION about          #TQC-860021
               CALL cl_about()       #TQC-860021
       
            ON ACTION help           #TQC-860021
               CALL cl_show_help()   #TQC-860021
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            CLOSE WINDOW p112_w 
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
            EXIT PROGRAM
         END IF
         IF source!=g_plant THEN
            SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=source
            IF STATUS THEN LET l_azp03=g_dbs END IF
            DATABASE l_azp03    
  #          CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
            CALL cl_ins_del_sid(1,source) #FUN-980030  #FUN-990069
         END IF
      END IF
      #FUN-630043
 
   WHILE TRUE
      IF NOT cl_null(g_argv1) THEN
         LET g_wc = " apa01 = '",g_argv1 CLIPPED,"'"
      ELSE
         CONSTRUCT BY NAME g_wc ON apa01,apa02,apa06,apa08,apa21,apa22,apa100   #FUN-990031 add apa100
            #No.FUN-580031 --start--
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
            #No.FUN-580031 ---end---
 
            ON ACTION locale
              #LET g_action_choice='locale'   #->No.FUN-570112
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
 
            #No.FUN-580031 --start--
            ON ACTION qbe_select
               CALL cl_qbe_select()
            #No.FUN-580031 ---end---
 
            #FUN-990031--add--str--
            ON ACTION CONTROLP
               CASE
#FUN-B50016 --begin
                 WHEN INFIELD(apa06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc03"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa06 
                   NEXT FIELD apa06
                 WHEN INFIELD(apa08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_apa02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa08 
                   NEXT FIELD apa08
#FUN-B50016 --end
                 WHEN INFIELD(apa100)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa100 
                   NEXT FIELD apa100 
                 #TQC-D90022--add---str---
                 WHEN INFIELD(apa01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oma01_1"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa01
                   NEXT FIELD apa01
                 WHEN INFIELD(apa21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa21
                   NEXT FIELD apa21
                 WHEN INFIELD(apa22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa22
                   NEXT FIELD apa22
                 #TQC-D90022--add---end---
               END CASE
            #FUN-990031--add--end
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup') #FUN-980030
  #->No.FUN-570112 --start--
#         IF g_action_choice = 'locale' THEN
#            EXIT WHILE
#         END IF
         IF g_change_lang THEN
            LET g_change_lang = FALSE
            CALL cl_dynamic_locale()
            EXIT WHILE
         END IF
  #->No.FUN-570112 ---end---
         IF INT_FLAG THEN
            CLOSE WINDOW p112_w
            LET INT_FLAG = 0
         #FUN-630043
         IF g_aza.aza53='Y' AND source!=g_plant THEN
            DATABASE g_dbs 
       #     CALL cl_ins_del_sid(1) #FUN-980030    #FUN-990069
            CALL cl_ins_del_sid(1,g_plant) #FUN-980030    #FUN-990069
         END IF
         #FUN-630043
             CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
             EXIT PROGRAM
         END IF
      END IF
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
  #->No.FUN-570112 --start--
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CALL cl_show_fld_cont()   #FUN-550037(smin)
#      CONTINUE WHILE
#   END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
  #->No.FUN-570112 ---end---
 
 
      #no.4422 02/02/19 add
#      CALL p112_create_tmp()  #NO.FUN-570112 MARK
      #no.4422 02/02/19 add
      LET seperate_sw = '1'
      LET to_apa02    = g_today
#TQC-790128.....begin
      LET g_apa.apa12 = to_apa02
      LET g_apa.apa64 = to_apa02
      LET g_apa.apa24 = 0
#TQC-790128.....end
      LET body_no     = 4
      LET g_bgjob = "N"            #FUN-570112
 
      INPUT BY NAME seperate_sw,body_no,to_trtype,to_apa02,to_apa15,to_apa16,
                    #to_apa21,to_apa22,to_apa36
                    to_apa21,to_apa22,to_apa36,g_bgjob #NO.FUN-570112 
                    WITHOUT DEFAULTS
 
         AFTER FIELD body_no
            IF body_no=0 THEN
               NEXT FIELD body_no
            END IF
 
         AFTER FIELD to_trtype
            IF NOT cl_null(to_trtype) THEN
            #No.FUN-560002  --start
#              CALL s_check_no(g_sys,to_trtype,"","21","","","")
               CALL s_check_no("aap",to_trtype,"","21","","","")    #No.FUN-A40041
                 RETURNING li_result,to_trtype
               IF (NOT li_result) THEN
    	          NEXT FIELD to_trtype
               END IF
#               CALL s_apyslip(to_trtype,'21',g_sys)	#檢查單別
#               IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#                  CALL cl_err(to_trtype,g_errno,0)
#                  NEXT FIELD to_trtype
#               END IF
               LET g_apa.apamksg = g_apy.apyapr
            #No.FUN-560002  --end
            END IF
 
         AFTER FIELD to_apa15
            IF NOT cl_null(to_apa15) THEN
               SELECT gec04 INTO to_apa16 FROM gec_file
                WHERE gec01 = to_apa15 AND gecacti = 'Y'
                  AND gec011='1'  #進項
               IF STATUS THEN
#                 CALL cl_err(to_apa15,SQLCA.sqlcode,0)   #No.FUN-660122
                  CALL cl_err3("sel","gec_file",to_apa15,"",SQLCA.sqlcode,"","",0)   #No.FUN-660122
                  NEXT FIELD to_apa15
               END IF
               DISPLAY BY NAME to_apa16
            END IF
 
         AFTER FIELD to_apa21
            IF NOT cl_null(to_apa21) THEN
               CALL p112_apa21('')
               IF NOT cl_null(g_errno) THEN	#抱歉, 有問題
                  CALL cl_err(to_apa21,g_errno,0)
                  NEXT FIELD to_apa21
               END IF
            END IF
 
         AFTER FIELD to_apa22
            IF NOT cl_null(to_apa22) THEN
               CALL p112_apa22('')
               IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
                  CALL cl_err(to_apa22,g_errno,0)
                  NEXT FIELD to_apa22
               END IF
            END IF
 
         AFTER FIELD to_apa36
            IF NOT cl_null(to_apa36) THEN
               CALL p112_apa36('')
               IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
                  CALL cl_err(to_apa36,g_errno,0)
                  NEXT FIELD to_apa36
               END IF
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(to_trtype) # 單別
                #CALL q_apy(FALSE,FALSE,to_trtype,'21',g_sys)  #TQC-670008
                CALL q_apy(FALSE,FALSE,to_trtype,'21','AAP')   #TQC-670008
                     RETURNING to_trtype
#                CALL FGL_DIALOG_SETBUFFER( to_trtype )
                DISPLAY BY NAME to_trtype
             WHEN INFIELD(to_apa21) # Class
#               CALL q_gen(7,9,to_apa21) RETURNING to_apa21
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.default1 = to_apa21
                CALL cl_create_qry() RETURNING to_apa21
#                CALL FGL_DIALOG_SETBUFFER( to_apa21 )
                DISPLAY BY NAME to_apa21
             WHEN INFIELD(to_apa22) # Class
#               CALL q_gem(7,9,to_apa22) RETURNING to_apa22
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.default1 = to_apa22
                CALL cl_create_qry() RETURNING to_apa22
#                CALL FGL_DIALOG_SETBUFFER( to_apa22 )
                DISPLAY BY NAME to_apa22
             WHEN INFIELD(to_apa36) # Class
#               CALL q_apr(7,9,to_apa36) RETURNING to_apa36
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_apr"
                LET g_qryparam.default1 = to_apa36
                CALL cl_create_qry() RETURNING to_apa36
#                CALL FGL_DIALOG_SETBUFFER( to_apa36 )
                DISPLAY BY NAME to_apa36
             WHEN INFIELD(to_apa15) # 稅別  No:8680
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gec"
                LET g_qryparam.default1 = to_apa15
                LET g_qryparam.arg1 = '1'
                CALL cl_create_qry() RETURNING to_apa15
#                CALL FGL_DIALOG_SETBUFFER( to_apa15 )
                DISPLAY BY NAME to_apa15
          END CASE
 
         ON ACTION locale
           #LET g_action_choice='locale'  #->No.FUN-570112
            LET g_change_lang = TRUE      #->No.FUN-570112
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
 
#NO.FUN-570122 MARK-------
#      IF INT_FLAG THEN
#         RETURN
#      END IF
#      IF g_action_choice = 'locale' THEN
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()   #FUN-550037(smin)
#        CONTINUE WHILE
#      END IF
#      IF cl_sure(20,20) THEN
#         LET g_success = 'Y'
#         BEGIN WORK
#         CALL p112_process()
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag
#         END IF
#         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#      END IF
      #No.+366 010709 by plum
#      LET l_cmd="chmod 777 aapp112.out"
#      RUN l_cmd
      #No.+366...end
#NO.FUN-570112 MARK-------
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p112_w
         #FUN-630043
         IF g_aza.aza53='Y' AND source!=g_plant THEN
            DATABASE g_dbs 
    #        CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
            CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
         END IF
         #FUN-630043
          CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
          EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aapp112"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('aapp112','9031',1)   
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",seperate_sw CLIPPED,"'",
                         " '",body_no CLIPPED,"'",
                         " '",to_trtype CLIPPED,"'",
                         " '",to_apa02 CLIPPED,"'",
                         " '",to_apa15 CLIPPED,"'",
                         " '",to_apa16 CLIPPED,"'",
                         " '",to_apa21 CLIPPED,"'",
                         " '",to_apa22 CLIPPED,"'",
                         " '",to_apa36 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aapp112',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p112_w
         #FUN-630043
         IF g_aza.aza53='Y' AND source!=g_plant THEN
            DATABASE g_dbs 
        #    CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
            CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
         END IF
         #FUN-630043
          CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
          EXIT PROGRAM
      END IF
      EXIT WHILE
  #->No.FUN-570112 ---end---
END WHILE
 
END FUNCTION
 
FUNCTION p112_process()
   DEFINE   order1	     LIKE zaa_file.zaa08,    # No.FUN-690028 VARCHAR(30),
            i,j   	     LIKE type_file.num5,    #No.FUN-690028 SMALLINT
            from 	     RECORD LIKE apa_file.*,
            l_plant	     LIKE apb_file.apb03,    #No.FUN-690028 VARCHAR(10),
             l_desc	     LIKE apb_file.apb12,    #NO.MOD-490217
            l_upf,l_up       LIKE type_file.num20_6, #No.FUN-690028 DEC(20,6),  #FUN-4B0079
            l_qty            LIKE apb_file.apb15,    #No.FUN-690028 DEC(15,3),  #FUN-4B0079
            l_amtf,l_amt     LIKE type_file.num20_6, #No.FUN-690028 DEC(20,6),  #FUN-4B0079
            l_apa06_t        LIKE apa_file.apa06,
            l_apb01          LIKE apb_file.apb01,
            l_apb02          LIKE apb_file.apb02,
            l_apb21          LIKE apb_file.apb21,   #TQC-630190
            l_apb22          LIKE apb_file.apb22,   #TQC-630190
            l_apb06          LIKE apb_file.apb06,   #TQC-630190
           #TQC-730065---add---str---
            l_apb07          LIKE apb_file.apb07,               
            l_apa992         LIKE apa_file.apa992,             
            l_apa37          LIKE apa_file.apa37,              
            l_apa37f         LIKE apa_file.apa37f,             
            l_apa101         LIKE apa_file.apa101,             
            l_apa102         LIKE apa_file.apa102              
           #TQC-730065---add---end---
            ,l_apb37          LIKE apb_file.apb37     #FUN-A70139
  DEFINE l_name   LIKE type_file.chr20         #MOD-C30301 add
      LET g_sql= "SELECT apa_file.*,apb03,apb12,apb13f,apb13,apb15,apb14f,",
                  "                 apb14,apb21,apb22,apb06,apb07,azi04",
               	  "                ,apb01,apb02 ",
                  "                ,apb37 ",              #FUN-A70139
                 #"                ,apa992,apa37,apa37f,apa101,apa102 ", #TQC-730065 add  #FUN-A70139 
                  "  FROM apb_file, apa_file LEFT OUTER JOIN azi_file ON apa_file.apa13 = azi_file.azi01",
                  " WHERE ",g_wc CLIPPED,
                 #"  AND apa00 matches '1*'", #CHI-A90002 mark
                  "  AND apa00 LIKE '1%'", #CHI-A90002
          	  "  AND apa31 > apa57",              #單頭與單身不同時
                  "  AND apa56 = '3'",                #價格折讓
                  "  AND apa60 >0 ",                  #No.160 010531 by plum add
                  "  AND apa01 = apb01",
 
                  "  AND apa41 = 'Y'",   #MOD-790046
                  "  AND apa42 = 'N' AND apa75='N'",  #未作廢&非外購
                  "  AND apb14 > 0 ",                 #折讓金額
                  "  AND (apb16 IS NULL OR apb16= ' ' OR apb16 = 'N')"   #折讓
      PREPARE p112_prepare FROM g_sql
      DECLARE p112_cs CURSOR WITH HOLD FOR p112_prepare
#      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aza.aza17     #No.CHI-6A0004 mark
 
      #START REPORT p112_rep TO 'aapp112.out'    #MOD-C30301   mark
      CALL cl_outnam(g_prog) RETURNING l_name    #MOD-C30301   add
      START REPORT p112_rep TO l_name            #MOD-C30301   add
      LET l_apa06_t = ' '
      CALL s_showmsg_init()       #NO. FUN-710014
      FOREACH p112_cs INTO from.*,l_plant,l_desc,l_upf,l_up,l_qty,l_amtf,l_amt,
                                  l_apb21,l_apb22,l_apb06,l_apb07,
                                  l_azi04,l_apb01,l_apb02,l_apb37    #FUN-A70139 add apb37
#NO. FUN-710014--BEGIN          
                 IF g_success='N' THEN
                      LET g_totsuccess='N'
                      LET g_success="Y"
                 END IF
#NO. FUN-710014--END
         IF SQLCA.sqlcode THEN
#           CALL cl_err('p112(ckp#1):',SQLCA.sqlcode,1)
            LET g_showmsg='1','/','3'  
            CALL s_errmsg('apa00,apa56',g_showmsg,'',SQLCA.sqlcode,1)  # No.FUN-710014 
            LET g_success = 'N'
            EXIT FOREACH       
         END IF
         #CHI-A90002 add --start--
         LET g_apa05= from.apa05
         CALL p112_apa05('')
         IF NOT cl_null(g_errno) THEN
            LET g_success = 'N'
            CALL s_errmsg("apa05",g_apa05,'',g_errno,1)
            CONTINUE FOREACH
         END IF
         #CHI-A90002 add --end--
         IF g_bgjob = 'N' THEN                         #FUN-570112
            DISPLAY "foreach:",from.apa01 AT 1,1
         END IF
         #-->產生方式
         IF seperate_sw = '1' THEN
            IF from.apa06 != l_apa06_t THEN
               LET i = 0
               LET j= 0
            END IF
            LET j = j + 1
            IF j > body_no THEN
               LET i = i + 1
               LET j = 1
            END IF
            LET order1 = from.apa56,from.apa06,from.apa07,i USING '&'
            LET l_apa06_t = from.apa06
         ELSE
            LET order1 = from.apa56,from.apa01
         END IF
        #str MOD-970103 mod
        #INSERT INTO p112_tmp VALUES(order1,from.*,l_plant,l_desc,
        #                            l_upf,l_up,l_qty,l_amtf,l_amt,
        #                            l_apb21,l_apb22,l_apb06,l_apb07,
        #                            l_azi04,l_apb01,l_apb02)
         INSERT INTO p112_tmp VALUES(
            order1,
            from.apa00,from.apa01,from.apa02,from.apa05,from.apa06,
            from.apa07,from.apa08,from.apa09,from.apa11,from.apa12,
            from.apa13,from.apa14,from.apa15,from.apa16,from.apa17,
            from.apa171,from.apa172,from.apa173, from.apa174, from.apa175,
            from.apa18,from.apa19,from.apa20,from.apa21,from.apa22,
            from.apa23,from.apa24,from.apa25,from.apa31f,from.apa32f,
            from.apa33f,from.apa34f,from.apa35f,from.apa31,from.apa32,
            from.apa33,from.apa34,from.apa35,from.apa36,from.apa41,
            from.apa42,from.apa43,from.apa44,from.apa45,from.apa46,
            from.apa51,from.apa52,from.apa53,from.apa54,from.apa55,
            from.apa56,from.apa57f, from.apa57,from.apa58,from.apa59,
            from.apa60f,from.apa61f,from.apa60,from.apa61,from.apa62,
            from.apa63,from.apa64,from.apa65f,from.apa65,from.apa66,
            from.apa67,from.apa68,from.apa69,from.apa70,from.apa71,
            from.apa72,from.apa73,from.apa74,from.apa75,from.apa99,
            from.apainpd,from.apamksg,from.apasign,from.apadays,from.apaprit,
            from.apasmax,from.apasseq,from.apaprno,from.apaacti,from.apauser,
            from.apagrup,from.apamodu,from.apadate,from.apa100,from.apa930,
            from.apa511,from.apa521,from.apa531,from.apa541,from.apa992,
            from.apa37,from.apa37f,from.apa101,from.apa102,
            l_plant,l_desc,l_upf,l_up,l_qty,
            l_amtf,l_amt,l_apb21,l_apb22,l_apb06,
            l_apb07,l_azi04,l_apb01,l_apb02,l_apb37)   #FUN-A70139 add apb37
        #end MOD-970103 mod
         IF STATUS THEN
#           CALL cl_err('ins p112_tmp:',STATUS,1)   #No.FUN-660122
            CALL cl_err3("ins","p112_tmp","","",STATUS,"","ins p112_tmp",1)   #No.FUN-660122
            LET g_success='N'
            EXIT FOREACH
         END IF
      END FOREACH
 IF g_totsuccess="N" THEN                           # No.FUN-710014  add
        LET g_success="N"                           # No.FUN-710014  add
     END IF                                         # No.FUN-710014  add
      DECLARE p112_tmpcs CURSOR FOR
       SELECT * FROM p112_tmp
        ORDER BY order1,apa01
      FOREACH p112_tmpcs INTO
            order1,
           #str MOD-970103 mod
           #from.*
            from.apa00,from.apa01,from.apa02,from.apa05,from.apa06,
            from.apa07,from.apa08,from.apa09,from.apa11,from.apa12,
            from.apa13,from.apa14,from.apa15,from.apa16,from.apa17,
            from.apa171,from.apa172,from.apa173, from.apa174, from.apa175,
            from.apa18,from.apa19,from.apa20,from.apa21,from.apa22,
            from.apa23,from.apa24,from.apa25,from.apa31f,from.apa32f,
            from.apa33f,from.apa34f,from.apa35f,from.apa31,from.apa32,
            from.apa33,from.apa34,from.apa35,from.apa36,from.apa41,
            from.apa42,from.apa43,from.apa44,from.apa45,from.apa46,
            from.apa51,from.apa52,from.apa53,from.apa54,from.apa55,
            from.apa56,from.apa57f, from.apa57,from.apa58,from.apa59,
            from.apa60f,from.apa61f,from.apa60,from.apa61,from.apa62,
            from.apa63,from.apa64,from.apa65f,from.apa65,from.apa66,
            from.apa67,from.apa68,from.apa69,from.apa70,from.apa71,
            from.apa72,from.apa73,from.apa74,from.apa75,from.apa99,
            from.apainpd,from.apamksg,from.apasign,from.apadays,from.apaprit,
            from.apasmax,from.apasseq,from.apaprno,from.apaacti,from.apauser,
            from.apagrup,from.apamodu,from.apadate,from.apa100,from.apa930,
            from.apa511,from.apa521,from.apa531,from.apa541,from.apa992,
            from.apa37,from.apa37f,from.apa101,from.apa102,
           #end MOD-970103 mod
            l_plant,l_desc,l_upf,l_up,l_qty,
            l_amtf,l_amt,l_apb21,l_apb22,l_apb06,l_apb07,
            l_azi04,l_apb01,l_apb02,l_apb37   #FUN-A70139 add l_apb37
#NO. FUN-710014--BEGIN          
                  IF g_success='N' THEN
                      LET g_totsuccess='N'
                      LET g_success="Y"
                  END IF
#NO. FUN-710014--END
 
         IF SQLCA.sqlcode THEN
#           CALL cl_err('sel tmp:',SQLCA.sqlcode,1)                     # No.FUN-710014 
            CALL s_errmsg('','','sel tmp:',SQLCA.sqlcode,1)             # No.FUN-710014  add    
            LET g_success = 'N'
            EXIT FOREACH                      
         END IF
          OUTPUT TO REPORT p112_rep(order1,from.*,
                          l_plant,l_desc,l_upf,l_up,l_qty,l_amtf,l_amt,
                          l_apb21,l_apb22,l_apb06,l_apb07,l_apb01,l_apb02,l_apb37)   #FUN-A70139 add l_apb37
 
      END FOREACH
#NO. FUN-710014--BEGIN
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
    #NO. FUN-710014--END 
 
      FINISH REPORT p112_rep
      IF begin_no IS NOT NULL THEN
         IF g_bgjob = 'N' THEN                         #FUN-570112
             DISPLAY begin_no TO start_no
             DISPLAY end_no   TO end_no
         END IF   #NO.FUN-570112 
      ELSE
        #CALL cl_err('','aap-129',1) #CHI-A90002 mark
         LET g_success = 'N'   #CHI-A90002 add
         CALL s_errmsg('apa01',begin_no,'','aap-129',1) #CHI-A90002 
      END IF
 
END FUNCTION
 
REPORT p112_rep(order1,froma,p_plant,p_desc,p_upf,p_up,p_qty,p_amtf,p_amt,
                       p_apb21,p_apb22,p_apb06,p_apb07,p_apb01,p_apb02,p_apb37)   #FUN-A70139 add apb37
  DEFINE order1	        LIKE zaa_file.zaa08,    #No.FUN-690028  VARCHAR(30),
         #tr_no 	        VARCHAR(16),       #TQC-630190 #FUN-660117 remark
         tr_no 	        LIKE apa_file.apa01,    #FUN-660117
         froma	        RECORD LIKE apa_file.*,
         toa	        RECORD LIKE apa_file.*,
         tob	        RECORD LIKE apb_file.*,
         #p_plant        VARCHAR(10),              #FUN-660117 remark
         p_plant        LIKE apb_file.apb03,    #FUN-660117
         p_desc	LIKE apb_file.apb12,            #NO.MOD-490217
         p_upf,p_up     LIKE type_file.num20_6, #No.FUN-690028 DEC(20,6),  #FUN-4B0079
#        p_qty          LIKE ima_file.ima26,    #No.FUN-690028 DEC(15,3),  #FUN-A20044
         p_qty          LIKE type_file.num15_3, #FUN-A20044
         p_amtf,p_amt   LIKE type_file.num20_6, #No.FUN-690028 DEC(20,6),  #FUN-4B0079
         #p_apb21  VARCHAR(10),               #FUN-660117 remark
         p_apb21        LIKE apb_file.apb21,    #FUN-660117
         p_apb22 	LIKE type_file.num5,    #No.FUN-690028 SMALLINT,
         #p_apb06  VARCHAR(10),               #FUN-660117
         p_apb06 	LIKE apb_file.apb06,    #FUN-660117
         p_apb07 	LIKE type_file.num5,    #No.FUN-690028 SMALLINT,
         g_apk          RECORD LIKE apk_file.*,
         p_apb01        LIKE apb_file.apb01,
         p_apb02        LIKE apb_file.apb02,
         l_apk03        LIKE apk_file.apk03,
         l_apk06        LIKE apk_file.apk06,
         l_sumf,l_sum   LIKE apa_file.apa34,
         l_amt_totf     LIKE apa_file.apa34,
         l_amt_tot      LIKE apa_file.apa34,
         l_taxf,l_tax   LIKE apb_file.apb10,
         l_apa73        LIKE apa_file.apa73,    #No.FUN-680027
         l_apa31        LIKE apa_file.apa31,
         l_apa31f       LIKE apa_file.apa31f,
         l_apa32        LIKE apa_file.apa32,
         l_apa32f       LIKE apa_file.apa32f
DEFINE   li_result      LIKE type_file.num5     #No.FUN-560106  #No.FUN-690028 SMALLINT
DEFINE   l_apydmy3      LIKE apy_file.apydmy3   #FUN-5B0089 add
DEFINE   l_apc08        LIKE apc_file.apc08     #No.TQC-6B0066
DEFINE   l_apc09        LIKE apc_file.apc09     #No.TQC-6B0066
DEFINE   p_apb37        LIKE apb_file.apb37     #FUN-A70139 
DEFINE   l_azf141       LIKE azf_file.azf141  #FUN-B80058

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY order1,froma.apa01
 
  FORMAT
    BEFORE GROUP OF order1
         LET toa.*     = froma.*
        ##No.2816 modify 1998/11/13
         LET g_gec031 = ''  #No.FUN-680029
         SELECT gec03,gec031,gec04,gec06 INTO toa.apa52,g_gec031,toa.apa16,toa.apa172  #No.FUN-680029 新增gec031
           FROM gec_file
          WHERE gec01 = to_apa15 AND gecacti = 'Y' AND gec011= '1' #進項
         IF STATUS THEN LET g_success= 'N' END IF
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' THEN
            LET toa.apa521 = g_gec031
         END IF
         #No.FUN-680029 --end--
        ##-------------------------
 
        #LET toa.*     = froma.*
         LET toa.apa00 = '21'
#No.FUN-560106--begin
         CALL s_auto_assign_no("aap",to_trtype,to_apa02,toa.apa00,"apa_file","apa01","","","")
         RETURNING li_result,tr_no
#        CALL s_apyauno(to_trtype,to_apa02,toa.apa00) RETURNING g_i,tr_no
#No.FUN-560106-end
         LET toa.apa01 = tr_no
         LET toa.apa02 = to_apa02
         LET toa.apa08 = froma.apa01
         #LET toa.apa11 = NULL   #MOD-790046
         LET toa.apa11 = froma.apa11   #MOD-790046
        #LET toa.apa12 = NULL
         LET toa.apa12 = to_apa02   #FUN-570042
         #LET toa.apa14 = 1         #No.MOD-530439 Mark
         LET toa.apa72 = 1          #A059
         LET toa.apa15 = to_apa15
         LET toa.apa16 = to_apa16
        #LET toa.apa171= '23'          #MOD-AB0226 mark
        #-MOD-AB0226-add-
         CASE 
            WHEN (toa.apa171 = '21' OR toa.apa171 = '25' OR toa.apa171 = '26')
              LET toa.apa171  = '23' 
            WHEN (toa.apa171 = '22' OR toa.apa171 = '27')
              LET toa.apa171  = '24'
            WHEN (toa.apa171 = '28')
              LET toa.apa171  = '29'
            WHEN (toa.apa171 = 'XX')
              LET toa.apa171  = 'XX'
         END CASE 
        #-MOD-AB0226-end- 
         LET toa.apa175= NULL
         LET toa.apa19 = NULL
         LET toa.apa20 = 0
         LET toa.apa21 = to_apa21
         LET toa.apa22 = to_apa22
         LET toa.apa24 = NULL
         LET toa.apa33f= 0 LET toa.apa33 = 0
         LET toa.apa65f= 0 LET toa.apa65 = 0
         LET toa.apa36 = to_apa36
        #No.+160 010531 by plum
       {
         LET toa.apa41 = 'N'
         LET toa.apa31f= 0 LET toa.apa31 = 0
         LET toa.apa32f= 0 LET toa.apa32 = 0
         LET toa.apa34f= 0 LET toa.apa34 = 0
         LET toa.apa35f= 0 LET toa.apa35 = 0
         LET toa.apa57f= 0 LET toa.apa57 = 0
        }
         LET toa.apa41 = 'Y'
         LET toa.apa31f= froma.apa60f LET toa.apa31 = froma.apa60
         LET toa.apa32f= froma.apa61f LET toa.apa32 = froma.apa61
         LET toa.apa35f= toa.apa31f+toa.apa32f
         LET toa.apa35 = toa.apa31 +toa.apa32
         LET toa.apa34f= toa.apa35f
         LET toa.apa34 = toa.apa35
         LET toa.apa57f= toa.apa31f
         LET toa.apa57 = toa.apa31
        #No.+160..end
         LET toa.apa42 = 'N'
         LET toa.apa44 = NULL
         LET toa.apa51 = g_c_actno
         LET toa.apa54 = g_d_actno
         #No.FUN-680029 --start--
         IF g_aza.aza63 = 'Y' THEN
            LET toa.apa511 = g_e_actno
            LET toa.apa541 = g_f_actno
         END IF
         #No.FUN-680029 --end--
         LET toa.apa53 = NULL
         LET toa.apa56 = '0'
         LET toa.apa58 = '1'
         LET toa.apa60f= 0 LET toa.apa60 = 0
         LET toa.apa61f= 0 LET toa.apa61 = 0
         #No.MOD-590440  --begin
         CALL p112_comp_oox(toa.apa01) RETURNING g_net
         LET toa.apa73 = toa.apa34-toa.apa35 + g_net     #A059
         #No.MOD-590440  --end
         LET toa.apa74 ='N'
         LET toa.apa75 ='N'
         LET toa.apaacti = 'Y'
         LET toa.apauser = g_user
         LET toa.apagrup = g_grup
         LET toa.apadate = g_today
         LET toa.apa930=s_costcenter(toa.apa22)  #FUN-670064
 
        ##FUN-980001 add -(S)
         #LET toa.apaplant = g_plant    #FUN-960141 090824 mark
         LET toa.apa100 = g_plant       #FUN-960141 090824 add
         LET toa.apalegal = g_legal
        ##FUN-980001 add -(E)
 
#MOD-5B0210
        LET to_trtype = s_get_doc_no(to_trtype)   #TQC-630190
        SELECT apyapr INTO toa.apamksg FROM apy_file
           WHERE apyslip = to_trtype
#END MOD-5B0210
         #FUN-990014--Begin
         SELECT apyvcode INTO toa.apa77 FROM apy_file WHERE apyslip = to_trtype
          IF cl_null(toa.apa77) THEN
             LET toa.apa77 = g_apz.apz63   #FUN-970108 add
          END IF 
         #FUN-990014---End   
         IF g_bgjob = 'N' THEN                         #FUN-570112
             DISPLAY "insert apa:",toa.apa01,' ',toa.apa02,' ',toa.apa06
                 AT 2,1
         END IF                                        #FUN-570112 
         LET toa.apaoriu = g_user      #No.FUN-980030 10/01/04
         LET toa.apaorig = g_grup      #No.FUN-980030 10/01/04
         LET toa.apa79 = '0'           #No.FUN-A40003     #No.FUN-A60024
         INSERT INTO apa_file VALUES(toa.*)
         IF STATUS THEN
#           CALL cl_err('p112_ins_apa(ckp#1):',SQLCA.sqlcode,1)   #No.FUN-660122
            CALL cl_err3("ins","apa_file",toa.apa01,"",SQLCA.sqlcode,"","p112_ins_apa(ckp#1)",1)   #No.FUN-660122
            LET g_success = 'N'
         END IF
         IF begin_no IS NULL THEN LET begin_no=toa.apa01 END IF
         LET end_no=toa.apa01
         IF froma.apa08 = 'MISC' THEN
            #No.B266 010510 by plum
            {
            SELECT apk03 INTO l_apk03 FROM apk_file
             WHERE apk01 = froma.apa01 AND apk02 = 1
            IF STATUS THEN LET l_apk03 = '' END IF
            }
           #DECLARE p112_apk_no CURSOR FOR                           #No.TQC-CB0002   Mark
            DECLARE p112_apk_no SCROLL CURSOR FOR                    #No.TQC-CB0002   Add
            #SELECT apk06,apk03 FROM apk_file                        #MOD-AB0226 mark
             SELECT apk06,apk03,apk171,apk17 FROM apk_file           #MOD-AB0226
             #WHERE apk01 = froma.apa01 AND apk171 IN ('21','22','25')                      #MOD-AB0226 mark
              WHERE apk01 = froma.apa01 AND apk171 IN ('21','22','25','26','27','28','XX')  #MOD-AB0226
              ORDER by apk06 DESC,apk03
            OPEN p112_apk_no
           #FETCH p112_apk_no INTO l_apk06,l_apk03                       #MOD-AB0226 mark
           #FETCH p112_apk_no INTO l_apk06,l_apk03,toa.apa171,toa.apa17  #MOD-AB0226   #No.TQC-CB0002   Mark
            FETCH FIRST p112_apk_no INTO l_apk06,l_apk03,toa.apa171,toa.apa17  #No.TQC-CB0002   Add
            CLOSE p112_apk_no
            #No.B266..end
         END IF
         INITIALIZE tob.* TO NULL
         LET tob.apb01 = tr_no
         LET tob.apb02 = 0
         LET l_amt_totf= 0 LET l_amt_tot = 0
         LET tob.apb13f= 0 LET tob.apb13 = 0
         LET tob.apb14f= 0 LET tob.apb14 = 0
         LET tob.apb15 = 0
         LET tob.apb930=toa.apa930  #FUN-670064
        
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=toa.apa13  #No.TQC-6B0066
           
         #No.FUN-680027 --start--
         IF cl_null(toa.apa01) THEN
            LET g_success = 'N'
         ELSE
            LET g_apc.apc01 = toa.apa01
            LET g_apc.apc02 = 1
            LET g_apc.apc03 = toa.apa11
            LET g_apc.apc04 = toa.apa12
            LET g_apc.apc05 = toa.apa64
            LET g_apc.apc06 = toa.apa14
            LET g_apc.apc07 = toa.apa72
            LET g_apc.apc08 = toa.apa34f
            LET g_apc.apc09 = toa.apa34
            LET g_apc.apc10 = toa.apa35f
            LET g_apc.apc11 = toa.apa35
            LET g_apc.apc12 = toa.apa08
            LET g_apc.apc13 = toa.apa73
            LET g_apc.apc14 = toa.apa65f
            LET g_apc.apc15 = toa.apa65
            LET g_apc.apc16 = toa.apa20
            #No.TQC-6B0066 --start--
            LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
            LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
            LET g_apc.apc10 = cl_digcut(g_apc.apc10,t_azi04)
            LET g_apc.apc11 = cl_digcut(g_apc.apc11,g_azi04)
            LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)
            LET g_apc.apc14 = cl_digcut(g_apc.apc14,t_azi04)
            LET g_apc.apc15 = cl_digcut(g_apc.apc15,g_azi04)
            LET g_apc.apc16 = cl_digcut(g_apc.apc16,t_azi04)
            #No.TQC-6B0066 --end--
 
            ##FUN-980001 add --(S)
            #LET g_apc.apcplant = g_plant   #FUN-960141 mark 090824
            LET g_apc.apclegal = g_legal
            ##FUN-980001 add --(E)
            
            INSERT INTO apc_file VALUES(g_apc.*)
            IF STATUS THEN
               CALL cl_err3("ins","apc_file",g_apc.apc01,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
         END IF
         #No.FUN-680027 --end--
 
    ON EVERY ROW
      #LET tob.apb01 = froma.apa01 #CHI-A90002 add     #MOD-AB0226 mark
       LET tob.apb02 = tob.apb02 + 1
       IF p_upf  IS NULL THEN LET p_upf  = 0 END IF
       IF p_amtf IS NULL THEN LET p_amtf = 0 END IF
       IF p_qty  IS NULL THEN LET p_qty  = 0 END IF
       IF p_amtf = 0 THEN LET p_amtf = p_amt END IF
       LET l_amt_totf= l_amt_totf+ p_amtf LET l_amt_tot = l_amt_tot + p_amt
       LET tob.apb03 = p_plant
       LET tob.apb12 = p_desc
       LET tob.apb23 = p_upf LET tob.apb08 = p_up
       LET tob.apb09 = p_qty
       LET tob.apb24 = p_amtf LET tob.apb10 = p_amt
      #No.+005 010514 by plum for 成本分攤
       LET tob.apb081=tob.apb08
       LET tob.apb101=tob.apb10
      #No.+005
#No.TQC-B80026 --begin
#      IF froma.apa08 = 'MISC' THEN
#         LET tob.apb11 = l_apk03
#      ELSE
#         LET tob.apb11 = froma.apa08
#      END IF
      #LET tob.apb11 = froma.apa08   #No.TQC-CB0002   Mark
#No.TQC-B80026 --end
       LET tob.apb11 = l_apk03   #No.TQC-CB0002   Add
       LET tob.apb21 = p_apb21
       LET tob.apb22 = p_apb22
       LET tob.apb29 = '3'
       LET tob.apb06 = p_apb06
       LET tob.apb07 = p_apb07
       LET tob.apb34 = 'N'     #No.TQC-7B0083
     #FUN-810045 begin
      #FUN-A60056--mod--str--
      #SELECT pmn40,pmn401,pmn67,pmn122,pmn96,pmn98                         #No.FUN-840006 去掉pmn66
      #  INTO tob.apb25,tob.apb251,tob.apb26,tob.apb35,tob.apb36,tob.apb31  #No.FUN-840006 去掉tob.apb30
      #  FROM pmn_file 
      # WHERE pmn01=tob.apb06 and pmn02=tob.apb07 
       LET g_sql = "SELECT pmn40,pmn401,pmn67,pmn122,pmn96,pmn98 ",
                  #"  FROM ",cl_get_target_table(toa.apa100,'pmn_file'),  #FUN-A70139
                   "  FROM ",cl_get_target_table(p_apb37,'pmn_file'),  #FUN-A70139
                   " WHERE pmn01='",tob.apb06,"'",
                   "   AND pmn02='",tob.apb07,"'" 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      #CALL cl_parse_qry_sql(g_sql,toa.apa100) RETURNING g_sql   #FUN-A70139
       CALL cl_parse_qry_sql(g_sql,p_apb37) RETURNING g_sql   #FUN-A70139
       PREPARE sel_pmn40 FROM g_sql 
       EXECUTE sel_pmn40 INTO tob.apb25,tob.apb251,tob.apb26,tob.apb35,tob.apb36,tob.apb31
      #FUN-A60056--mod--end 
       IF cl_null(tob.apb25) AND NOT cl_null(tob.apb31) THEN
         SELECT azf14,azf141 INTO tob.apb25,l_azf141    ##FUN-B80058 add azf141
           FROM azf_file
#         WHERE azf01=tob.apb31 AND azf02='2' AND azfacti='Y'                #No.FUN-930104
         WHERE azf01=tob.apb31 AND azf02='2' AND azfacti='Y' AND azf09 = '7' #No.FUN-930104
         IF g_aza.aza63='Y' AND cl_null(tob.apb251) THEN
           #LET tob.apb251 = tob.apb25
           LET tob.apb251 = l_azf141      #FUN-B80058
         END IF
       END IF
     #FUN-810045 end
 
     ##FUN-980001 add --(S)
       #LET tob.apbplant = g_plant     #FUN-960141 mark 090812
       LET tob.apblegal = g_legal
     ##FUN-980001 add --(E)
      #LET tob.apb37 = toa.apa100    #FUN-9A0093   #FUN-A70139
       LET tob.apb37 = p_apb37       #FUN-A70139 
       #TQC-C10017  --Begin
       IF cl_null(tob.apb25) THEN LET tob.apb25= ' ' END IF
       IF cl_null(tob.apb26) THEN LET tob.apb26= ' ' END IF
       IF cl_null(tob.apb27) THEN LET tob.apb27= ' ' END IF
       IF cl_null(tob.apb31) THEN LET tob.apb31= ' ' END IF
       IF cl_null(tob.apb35) THEN LET tob.apb35= ' ' END IF
       IF cl_null(tob.apb36) THEN LET tob.apb36= ' ' END IF
       IF cl_null(tob.apb930) THEN LET tob.apb930= ' ' END IF
       #TQC-C10017  --End
       INSERT INTO apb_file VALUES(tob.*)
       IF STATUS THEN
#         CALL cl_err('p112_ins_apb(ckp#2):',SQLCA.sqlcode,1)   #No.FUN-660122
          CALL cl_err3("ins","apb_file",tob.apb01,tob.apb02,SQLCA.sqlcode,"","p112_ins_apb(ckp#2)",1)   #No.FUN-660122
          LET g_success = 'N'
       END IF
       UPDATE apa_file SET apa59 = 'Y' WHERE apa01 = froma.apa01
##No.2814 modify 1998/11/13
       #modi by canny(980812).dbo.update apb16 and insert apk_file
       UPDATE apb_file SET apb16 = 'Y'
	WHERE apb01 = p_apb01 and apb02 = p_apb02
 
       #insert into apk_file
        INITIALIZE g_apk.* TO NULL
	      LET g_apk.apk01   = tob.apb01                    #折讓單
      	LET g_apk.apk02   = tob.apb02                    #項次
        LET g_apk.apk03   = tob.apb11                    #發票號碼
        LET g_apk.apk04   = toa.apa18                    #統一編號
        LET g_apk.apk05   = toa.apa09                    #發票日期
        LET l_tax  = tob.apb10 * toa.apa16 /100
        CALL cl_digcut(l_tax ,l_azi04) RETURNING l_tax
        LET g_apk.apk07   = l_tax                        #稅額
	      LET g_apk.apk08   = tob.apb10                    #未稅金額
	      LET g_apk.apk06   = g_apk.apk07 + g_apk.apk08    #含稅金額
        #no.A010依幣別取位
        LET g_apk.apk06   = cl_digcut(g_apk.apk06,g_azi04)
        LET g_apk.apk07   = cl_digcut(g_apk.apk07,g_azi04)
        LET g_apk.apk08   = cl_digcut(g_apk.apk08,g_azi04)
        #(end)
        #no.5954 增加幣別等欄位
        LET g_apk.apk11   = toa.apa15
        LET g_apk.apk29   = toa.apa16
        LET g_apk.apk12   = toa.apa13
        LET g_apk.apk13   = toa.apa14
        LET g_apk.apk07f  = tob.apb24 * g_apk.apk29 / 100
        LET g_apk.apk08f  = tob.apb24
        LET g_apk.apk06f  = g_apk.apk07f + g_apk.apk08f
        LET g_apk.apk06f  = cl_digcut(g_apk.apk06f,l_azi04)
        LET g_apk.apk07f  = cl_digcut(g_apk.apk07f,l_azi04)
        LET g_apk.apk08f  = cl_digcut(g_apk.apk08f,l_azi04)
        #no.5954(end)
        LET g_apk.apk09   = ' '
        LET g_apk.apk10   = ' '
        LET g_apk.apk17   = toa.apa17
        LET g_apk.apk171  = toa.apa171     
       #-MOD-AB0226-add-
        CASE 
           WHEN (toa.apa171 = '21' OR toa.apa171 = '25' OR toa.apa171 = '26')
             LET g_apk.apk171  = '23' 
           WHEN (toa.apa171 = '22' OR toa.apa171 = '27')
             LET g_apk.apk171  = '24'
           WHEN (toa.apa171 = '28')
             LET g_apk.apk171  = '29'
           WHEN (toa.apa171 = 'XX')
             LET g_apk.apk171  = 'XX'
        END CASE 
       #-MOD-AB0226-end- 
        
        LET g_apk.apk172  = toa.apa172
        LET g_apk.apk173  = 0
        LET g_apk.apk174  = 0
        LET g_apk.apk175  = 0
        LET g_apk.apk22   = ' '
        LET g_apk.apk25   = tob.apb12
        LET g_apk.apk26   = p_apb01
       	LET g_apk.apk27   = p_apb02
        LET g_apk.apkacti = 'Y'
        LET g_apk.apkuser = g_user
		    LET g_apk.apkgrup = g_grup
  	    LET g_apk.apkdate = today
	
	        ##FUN-980001 add -(S)
		   #LET g_apk.apkplant= g_plant    #FUN-960141 mark 090812
		    LET g_apk.apklegal= g_legal
	        ##FUN-980001 add -(E)
	        
	      #FUN-990014--Begin
        SELECT apyvcode INTO g_apk.apk32 FROM apy_file WHERE apyslip = to_trtype
          IF cl_null(g_apk.apk32) THEN
             LET g_apk.apk32 = g_apz.apz63   #FUN-970108 add
          END IF 
        #FUN-990014---End
        
		    LET g_apk.apkoriu = g_user      #No.FUN-980030 10/01/04
		    LET g_apk.apkorig = g_grup      #No.FUN-980030 10/01/04
		    INSERT INTO apk_file VALUES (g_apk.*)
	        IF STATUS THEN
#          CALL cl_err('p112_ins_apk(ckp#3):',SQLCA.sqlcode,1)   #No.FUN-660122
           CALL cl_err3("ins","apk_file",g_apk.apk01,g_apk.apk02,SQLCA.sqlcode,"","p112_ins_apk(ckp#3)",1)   #No.FUN-660122
           LET g_success = 'N'
        END IF
##-------------------------
 
    AFTER GROUP OF order1
      {
       #canny(980807)
       IF l_amt_totf IS NULL THEN LET l_amt_totf = 0 END IF
       LET l_taxf = l_amt_totf * to_apa16 / 100
       CALL cl_digcut(l_taxf,l_azi04) RETURNING l_taxf
       LET l_tax  = l_amt_tot  * to_apa16 / 100
      #No.+079 010424 by plum
      #CALL cl_digcut(l_tax ,l_azi04) RETURNING l_tax
       CALL cl_digcut(l_tax ,g_azi04) RETURNING l_tax        #No.CHI-6A0004 t_azi-->g_azi
      #No.+079..end
       LET l_sumf=l_amt_totf+l_taxf
       LET l_sum =l_amt_tot +l_tax
       #canny(980807)
       IF l_amt_totf IS NULL THEN LET l_amt_totf = 0 END IF
       UPDATE apa_file SET apa31f=l_amt_totf,
                           apa32f=l_taxf,
                           apa33f=0,
                           apa34f=l_sumf,
                           apa35f=0,
                           apa57f=l_amt_totf,
                           apa31=l_amt_tot ,
                           apa32=l_tax ,
                           apa33=0 ,
                           apa34=l_sum ,
                           apa35=0 ,
                           apa57 = l_amt_tot
              WHERE apa01 = tr_no
     }
      #no.4478
      #CALL t110_chkapk(tr_no,froma.apa01)
       CALL t110_chkapk(tr_no,froma.apa01,'2')
        #No.MOD-530118
#No.TQC-B80026 --begin
       #-----MOD-790046--------- 
       LET l_apa31 = (froma.apa60)
       LET l_apa31f= (froma.apa60f)
       LET l_apa32 = (froma.apa61)
       LET l_apa32f= (froma.apa61f)
#      LET l_apa31 = SUM(froma.apa60)
#      LET l_apa31f= SUM(froma.apa60f)
#      LET l_apa32 = SUM(froma.apa61)
#      LET l_apa32f= SUM(froma.apa61f)
       #-----END MOD-790046-----
#No.TQC-B80026 --end
       UPDATE apa_file SET apa31 =l_apa31,apa31f=l_apa31f,
                           apa32 =l_apa32,apa32f=l_apa32f,
                           apa34 =l_apa31+l_apa32,
                           apa34f=l_apa31f+l_apa32f,
                           apa35 =l_apa31+l_apa32,
                           apa35f=l_apa31f+l_apa32f,
                           apa73 = 0,              #A059
                           apa57 =l_apa31,
                           apa57f=l_apa31f
        WHERE apa01=tr_no
       #no.4478(end)
       IF STATUS THEN
#         CALL cl_err('p112_upd_apa(ckp#3):',SQLCA.sqlcode,1)   #No.FUN-660122
          CALL cl_err3("upd","apa_file",tr_no,"",SQLCA.sqlcode,"","p112_upd_apa(ckp#3)",1)   #No.FUN-660122
          LET g_success = 'N'
       END IF
 
       #No.TQC-6B0066 --start--
       LET l_apc08 = l_apa31f+l_apa32f
       LET l_apc09 = l_apa31+l_apa32
       LET l_apc08 = cl_digcut(l_apc08,t_azi04)
       LET l_apc09 = cl_digcut(l_apc09,g_azi04)
       #No.TQC-6B0066 --end--
 
       #No.FUN-680027 --start--
       #No.TQC-6B0066 --start--
#      UPDATE apc_file SET apc09 =l_apa31+l_apa32,
#                          apc08 =l_apa31f+l_apa32f,
#                          apc11 =l_apa31+l_apa32,
#                          apc10 =l_apa31f+l_apa32f,
#                          apc13 = 0
#       WHERE apc01=tr_no
       UPDATE apc_file SET apc09 = l_apc09,
                           apc08 = l_apc08,
                           apc11 = l_apc09,
                           apc10 = l_apc08,
                           apc13 = 0
        WHERE apc01=tr_no
       #No.TQC-6B0066 --end--
       IF STATUS THEN
          CALL cl_err3("upd","apc_file",tr_no,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
       #No.FUN-680027 --end--
 
       #FUN-5B0089 add
       LET to_trtype = s_get_doc_no(to_trtype)   #TQC-630190
       SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = to_trtype
       IF SQLCA.sqlcode THEN
#         CALL cl_err('sel apy:',STATUS,0)   #No.FUN-660122
          CALL cl_err3("sel","l_apydmy3",to_trtype,"",STATUS,"","sel apy",0)   #No.FUN-660122
          LET g_success = 'N'
       END IF
       IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
          CALL t110_g_gl(toa.apa00,toa.apa01,'0','')  #No.FUN-680029 新增參數'0'  #FUN-9C0001 add ''
          #No.FUN-680029 --start--
          IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
             CALL t110_g_gl(toa.apa00,toa.apa01,'1','')  #FUN-9C0001 add ''
          END IF
          #No.FUN-680029 --end--
       END IF
       #FUN-5B0089 end
       #No.MOD-590440  --begin
       CALL p112_comp_oox(tr_no) RETURNING g_net
       UPDATE apa_file SET apa73 =apa34 - apa35 + g_net
        WHERE apa01=tr_no
       IF STATUS THEN
#         CALL cl_err('p112_upd_apa(ckp#4):',SQLCA.sqlcode,1)   #No.FUN-660122
          CALL cl_err3("upd","apa_file",tr_no,"",SQLCA.sqlcode,"","p112_upd_apa(ckp#4)",1)   #No.FUN-660122
          LET g_success = 'N'
       END IF
       #No.MOD-590440  --end
 
       #No.FUN-680027 --start--
       SELECT apa73 INTO l_apa73 FROM apa_file
        WHERE apa01 = tr_no
       LET l_apa73 = cl_digcut(l_apa73,g_azi04)  #No.TQC-6B0066
       UPDATE apc_file SET apc13 = l_apa73
        WHERE apc01 = tr_no
       IF STATUS THEN
          CALL cl_err3("upd","apa_file",tr_no,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
       END IF
       #No.FUN-680027 --end--
END REPORT
 
#CHI-A90002 add --start--
FUNCTION p112_apa05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_pmc05   LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti

   SELECT pmc05,pmcacti
     INTO l_pmc05,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_apa05

   LET g_errno = ' '

   CASE
      WHEN l_pmcacti = 'N'            LET g_errno = '9028'
      WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'
     
      WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'        
      WHEN l_pmc05   = '3'            LET g_errno = 'aap-033' 
 
      WHEN STATUS=100 LET g_errno = '100'
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF

   IF p_cmd='d' THEN
      RETURN
   END IF

END FUNCTION
#CHI-A90002 add --end--

FUNCTION p112_apa36(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aps   RECORD LIKE aps_file.*
    DEFINE l_apr02 LIKE apr_file.apr02
    #DEFINE l_depno     VARCHAR(6)           #FUN-660117 remark
    DEFINE l_depno  LIKE gem_file.gem01   #FUN-660117 
 
    LET g_errno = ' '
    SELECT apr02 INTO l_apr02 FROM apr_file WHERE apr01 = to_apa36
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN LET l_apr02 = '' END IF
    IF g_bgjob = 'N' THEN                         #FUN-570112
        DISPLAY l_apr02 TO apr02
    END IF                                        #FUN-570112
    IF p_cmd = 'd' THEN RETURN END IF
    IF g_apz.apz13 = 'Y'
       THEN LET l_depno = to_apa22
       ELSE LET l_depno = ' '
    END IF
    SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_depno
    IF SQLCA.sqlcode THEN 
#      CALL cl_err(g_apa.apa22,'aap-053',1)  #No.FUN-660122
       CALL cl_err3("sel","aps_file",l_depno,"","aap-053","","",1)   #No.FUN-660122
       RETURN 
    END IF
    SELECT apt03,apt04 INTO g_d_actno,g_c_actno FROM apt_file
           WHERE apt01 = to_apa36 AND apt02 = l_depno
    IF SQLCA.sqlcode THEN
       LET g_d_actno = l_aps.aps21
       LET g_c_actno = l_aps.aps22
    END IF
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'Y' THEN  
       SELECT apt031,apt041 INTO g_e_actno,g_f_actno FROM apt_file
        WHERE apt01 = to_apa36
          AND apt02 = l_depno
       IF SQLCA.sqlcode THEN
          LET g_e_actno = l_aps.aps211
          LET g_f_actno = l_aps.aps221
       END IF
    END IF
    #No.FUN-680029 --end--
END FUNCTION
 
FUNCTION p112_apa21(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_gen03   LIKE gen_file.gen03
    DEFINE l_genacti LIKE gen_file.genacti
 
    SELECT gen03,genacti INTO l_gen03,l_genacti
           FROM gen_file WHERE gen01 = to_apa21
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
         WHEN l_genacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET to_apa22 = l_gen03
    IF g_bgjob = 'N' THEN                         #FUN-570112
        DISPLAY BY NAME to_apa22
    END IF                                        #FUN-570112 
END FUNCTION
 
FUNCTION p112_apa22(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_gemacti LIKE gem_file.gemacti
 
    SELECT gemacti INTO l_gemacti
           FROM gem_file WHERE gem01 = to_apa22
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
END FUNCTION
 
#no.4422 02/02/19 add
FUNCTION p112_create_tmp()
# No.FUN-690028 --start--
 CREATE TEMP TABLE p112_tmp(
   order1    LIKE zaa_file.zaa08,
   apa00     LIKE apa_file.apa00,
   apa01     LIKE apa_file.apa01,
   apa02     LIKE apa_file.apa02,
   apa05     LIKE apa_file.apa05,
   apa06     LIKE apa_file.apa06,
   apa07     LIKE apa_file.apa07,
   apa08     LIKE apa_file.apa08,
   apa09     LIKE apa_file.apa09,
   apa11     LIKE apa_file.apa11,
   apa12     LIKE apa_file.apa12,
   apa13     LIKE apa_file.apa13,
   apa14     LIKE apa_file.apa14,
   apa15     LIKE apa_file.apa15,
   apa16     LIKE apa_file.apa16,
   apa17     LIKE apa_file.apa17,
   apa171    LIKE apa_file.apa171,
   apa172    LIKE apa_file.apa172,
   apa173    LIKE type_file.num5,  
   apa174    LIKE type_file.num5,  
   apa175    LIKE type_file.num10, 
   apa18     LIKE apa_file.apa18,
   apa19     LIKE apa_file.apa19,
   apa20     LIKE apa_file.apa20,
   apa21     LIKE apa_file.apa21,
   apa22     LIKE apa_file.apa22,
   apa23     LIKE apa_file.apa23,
   apa24     LIKE type_file.num5,  
   apa25     LIKE apa_file.apa25,
   apa31f    LIKE apa_file.apa31f,
   apa32f    LIKE apa_file.apa32f,
   apa33f    LIKE apa_file.apa33f,
   apa34f    LIKE apa_file.apa34f,
   apa35f    LIKE apa_file.apa35f,
   apa31     LIKE apa_file.apa31,
   apa32     LIKE apa_file.apa32,
   apa33     LIKE apa_file.apa33,
   apa34     LIKE apa_file.apa34,
   apa35     LIKE apa_file.apa35,
   apa36     LIKE apa_file.apa36,
   apa41     LIKE apa_file.apa41,
   apa42     LIKE apa_file.apa42,
   apa43     LIKE apa_file.apa43,
   apa44     LIKE apa_file.apa44,
   apa45     LIKE apa_file.apa45,
   apa46     LIKE apa_file.apa46,
   apa51     LIKE apa_file.apa51,
   apa52     LIKE apa_file.apa52,
   apa53     LIKE apa_file.apa53,
   apa54     LIKE apa_file.apa54,
   apa55     LIKE apa_file.apa55,
   apa56     LIKE apa_file.apa56,
    apa57f   LIKE apa_file.apa57f,
    apa57    LIKE apa_file.apa57,
   apa58     LIKE apa_file.apa58,
   apa59     LIKE apa_file.apa59,
   apa60f    LIKE apa_file.apa60f,
   apa61f    LIKE apa_file.apa61f,
   apa60     LIKE apa_file.apa60,
   apa61     LIKE apa_file.apa61,
   apa62     LIKE apa_file.apa62, 
   apa63     LIKE apa_file.apa63,
   apa64     LIKE apa_file.apa64,
   apa65f    LIKE apa_file.apa65f,
   apa65     LIKE apa_file.apa65,
   apa66     LIKE apa_file.apa66, 
   apa67     LIKE apa_file.apa67, 
   apa68     LIKE apa_file.apa68,
   apa69     LIKE apa_file.apa69,
   apa70     LIKE apa_file.apa70,
   apa71     LIKE apa_file.apa71,   #No.FUN-840006 mark   #MOD-970103 mark回復
   apa72     LIKE apa_file.apa72,
   apa73     LIKE apa_file.apa73,
   apa74     LIKE apa_file.apa74,
   apa75     LIKE apa_file.apa75,
   apa99     LIKE apa_file.apa99,
   apainpd   LIKE apa_file.apainpd,
   apamksg   LIKE apa_file.apamksg,
   apasign   LIKE apa_file.apasign,
   apadays   LIKE apa_file.apadays,
   apaprit   LIKE apa_file.apaprit,
   apasmax   LIKE apa_file.apasmax,
   apasseq   LIKE apa_file.apasseq,
   apaprno   LIKE apa_file.apaprno,
   apaacti   LIKE apa_file.apaacti,
   apauser   LIKE apa_file.apauser,
   apagrup   LIKE apa_file.apagrup,
   apamodu   LIKE apa_file.apamodu,
   apadate   LIKE type_file.dat,   
   apa100    LIKE apa_file.apa100,
   apa930    LIKE apa_file.apa930,
   apa511    LIKE apa_file.apa511,
   apa521    LIKE apa_file.apa521,
   apa531    LIKE apa_file.apa531,
   apa541    LIKE apa_file.apa541,
   apa992    LIKE apa_file.apa992,  #TQC-730065 add
   apa37     LIKE apa_file.apa37,   #TQC-730065 add  
   apa37f    LIKE apa_file.apa37f,  #TQC-730065 add 
   apa101    LIKE apa_file.apa101,  #TQC-730065 add
   apa102    LIKE apa_file.apa102,  #TQC-730065 add
   plant     LIKE apb_file.apb03,
   l_desc    LIKE apb_file.apb12,
   upf       LIKE type_file.num20_6,
   up        LIKE type_file.num20_6,
   qty       LIKE apb_file.apb15,
   amtf      LIKE type_file.num20_6,
   amt       LIKE type_file.num20_6,
   apb21     LIKE apb_file.apb21,
   apb22     LIKE apb_file.apb22,
   apb06     LIKE apb_file.apb06,
   apb07     LIKE apb_file.apb07,
   azi04     LIKE azi_file.azi04,
   apb01     LIKE apb_file.apb01,
   apb02     LIKE apb_file.apb02,
   apb37     LIKE apb_file.apb37)    #FUN-A70139 add
 
# No.FUN-690028 ---end---
END FUNCTION
#no.4422 02/02/19 add
 
#No.MOD-590440  --begin
FUNCTION p112_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
#No.MOD-590440  --end
#Patch....NO.TQC-610035 <001> #
