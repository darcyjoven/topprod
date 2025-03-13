# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: aapr111.4gl
# Descriptions...: 應付憑單列印作業
# Input parameter:
# Return code....:
# Date & Author..: 93/01/06 By yen
# Modify.........: 97/04/16 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: No.8139 03/09/25 Wiky add gem02/gen02
# Modify.........: No.9385 04/03/31 By Kitty 應付憑單單身合計無金額
# Modify.........: No.FUN-540057 05/05/09 By vivien 發票號碼調整
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-550107 05/06/02 By ching fix品名列印問題
# Modify.........: No.MOD-570277 05/07/27 By Nicola 幣別取位修改
# Modify.........: No.FUN-570264 05/07/28 By saki 背景選擇樣板
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.MOD-590466 05/09/30 By Dido 報表調整
# Modify.........: No.FUN-5A0180 05/10/26 By Claire 報表調整
# Modify.........: No.MOD-5A0398 05/10/26 By Smapmin 修改USING格式
# Modify.........: No.TQC-5B0137 05/11/17 By Rosayu 單頭的匯率資料跟傳票連在一起
# Modify.........: NO.TQC-5B0088 05/11/16 BY yiting 多發票未稅,稅,含稅...最後請加入小計
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-610076 06/01/20 By Smapmin 多加幣別說明
# Modify.........: No.TQC-610130 06/01/25 By Smapmin 多發票時,單頭的發票日期要列印MISC
# Modify.........: No.MOD-630001 06/03/03 By vivien  報表調整                       
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改 
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.MOD-660099 06/06/26 By Smapmin 多發票資料新增扣抵區分與格式欄位
# Modify.........: No.FUN-660122 06/06/27 By Hellen  cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/24 By douzh l_time轉g_time
# Modify.........: No.FUN-690080 06/10/25 By ice 查詢帳款,增加13,17,25類型的判斷與關聯
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0128 06/11/22 By Rayven 欄位字段寬度不規範,"幣種"欄位數據應為左對齊
# Modify.........: No.FUN-6C0048 07/01/09 By ching-yuan TOP MARGIN g_top_margin及BOTTOM MARGIN g_bottom_margin由g_top_margin及g_bottom_margin設定
# Modify.........: No.FUN-710086 07/02/13 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/21 By Nicole 增加 CR 參數設定 
# Modify.........: No.FUN-730064 07/04/03 By atsea 會計科目加帳套 
# Modify ........: No.TQC-740042 07/04/09 By johnray s_get_bookno和s_get_bookno1參數應先取出年份
# Modify.........: No.TQC-750206 07/05/29 By Smapmin 增加未付欄位
# Modify.........: No.FUN-760045 07/07/05 By CoCo 子報表修改 
# Modify.........: No.MOD-7A0117 07/10/19 By Sarah 修正多發票列印異常
# Modify.........: No.MOD-7A0142 07/10/25 By Smapmin 增加折稅欄位
# Modify.........: No.CHI-7A0043 07/10/30 By Smapmin 修改列印分錄條件
# Modify.........: No.MOD-7B0023 07/11/05 By Smapmin 增加一暫估入庫選項
# Modify.........: No.MOD-7B0078 07/11/09 By Smapmin 金額合計有誤
# Modify.........: No.MOD-7B0175 07/11/21 By Smapmin 發票金額為負數時加總有誤
# Modify.........: No.TQC-7C0081 07/12/12 By Rayven 資料選項的4和5控管反了
# Modify.........: No.MOD-810213 08/01/31 By Smapmin 幣別取位不正確
# Modify.........: No.MOD-830072 08/03/10 By Smapmin 避免舊資料無法update apaprno
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-870026 08/07/08 By Sarah 資料選項tm.f增加7.折讓申請 8.D.M申請
# Modify.........: No.FUN-890002 08/09/09 By Sarah CR Temptable增加apa00
# Modify.........: No.MOD-8A0174 08/10/20 By Sarah 當apk04為NULL或' '值時,廠商簡稱改抓單頭apa07
# Modify.........: No.FUN-940041 09/04/27 By TSD.liquor 在CR報表列印簽核欄
# Modify.........: No.FUN-940102 09/04/28 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.MOD-950207 09/05/20 By lilingyu 當報表"資料選項"選擇5時,單身應呈現零用金作業的單身內容 
# Modify.........: No.MOD-960322 09/06/26 By Sarah CR Temptable增加apa37f,apa37
# Modify.........: No.MOD-970099 09/07/13 By mike CR Temptable應增加l_gem02欄位,以sr.apb.apb26為部門代號抓取
#                                                 aapr111.rpt單身資料里的部門名稱改顯示l_gem02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei 增加apa77申報統編列印
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/19 By chenls 拿掉plant,跨DB以apb37來跨
# Modify.........: No.CHI-A40017 10/04/22 By liuxqa modify sql 
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A90037 10/10/13 By Summer 資料選項tm.f增加9.暫估退貨,抓26的資料
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:TQC-BA0027 10/10/13 By yinhy 條件選項中選擇[f]=9.暫估退貨類型，[b]=Y,仍然能列印出報表數據
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao CR報表列印簽核欄
# Modify.........: No:TQC-BC0013 12/02/08 By Elise 增加送貨廠商說明欄位l_pmc03
# Modify.........: No.FUN-C10024 12/05/16 By minpp 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.MOD-C70146 12/07/13 By Polly 增加判斷含稅否，而帶含稅金額或是未稅金額
# Modify.........: No.MOD-CC0199 12/12/22 By Polly 調整報表pmc03無法顯示廠商簡稱
# Modify.........: No.TQC-DA0026 13/10/21 By yangxf “賬款編號”，“賬款人員”，“賬款部門”，“賬款類型”，“付款廠商”欄位添加开窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
#             wc      LIKE type_file.chr1000,     # Where condition  #No.FUN-690028 VARCHAR(700)               #TQC-DA0026 MARK 
              wc      STRING,                                                                                  #TQC-DA0026 add
              b       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # 已列印者是否再列印(Y/N)
              g       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # 是否列印多發票(Y/N)
              c       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # 是否列印傳票分錄(Y/N)
              d       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # 是否列印額外備註(Y/N)
              e       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # 是否列印料號品名(Y/N)
              f       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # (1)進貨發票 (2)雜項發票 (3)Ｃ．Ｍ．
              h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)       # (1)已確認 (2)未確認 (3)全部
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_dash1_1   LIKE type_file.chr1000,     # No.FUN-690028  VARCHAR(110)
           g_sql      string         # RDSQL STATEMENT  #No.FUN-580092 HCN
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#No.FUN-A10098-------------mark start
#DEFINE source    LIKE azp_file.azp01               #FUN-660117
#DEFINE g_azp02   LIKE azp_file.azp02  #FUN-630043
#No.FUN-A10098-------------mark end
DEFINE l_table   STRING                        #No.FUN-710086
DEFINE l_table1  STRING                        #No.FUN-710086
DEFINE l_table2  STRING                        #No.FUN-710086
DEFINE l_table3  STRING                        #No.FUN-710086
DEFINE l_table4  STRING                        #No.FUN-710086
DEFINE g_str     STRING                        #No.FUN-710086
DEFINE g_bookno1       LIKE aza_file.aza81     #No.FUN-730064
DEFINE g_bookno2       LIKE aza_file.aza82     #No.FUN-730064
DEFINE g_flag          LIKE type_file.chr1     #No.FUN-730064
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   LET tm.g  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)
   LET tm.h  = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047
 
   LET g_sql = "apa01.apa_file.apa01,apa02.apa_file.apa02,apa05.apa_file.apa05,",
               "apa06.apa_file.apa06,apa07.apa_file.apa07,apa08.apa_file.apa08,",
               "apa09.apa_file.apa09,apa12.apa_file.apa12,apa13.apa_file.apa13,",
               "apa14.apa_file.apa14,apa15.apa_file.apa15,apa16.apa_file.apa16,",
               "apa17.apa_file.apa17,apa171.apa_file.apa171,apa19.apa_file.apa19,",
               "apa20.apa_file.apa20,apa21.apa_file.apa21,apa22.apa_file.apa22,",
               "apa23.apa_file.apa23,apa24.apa_file.apa24,apa25.apa_file.apa25,",
               "apa31f.apa_file.apa31f,apa32f.apa_file.apa32f,apa34f.apa_file.apa34f,",
               "apa35f.apa_file.apa35f,apa31.apa_file.apa31,apa32.apa_file.apa32,",
               "apa34.apa_file.apa34,apa35.apa_file.apa35,apa36.apa_file.apa36,",
               "apa44.apa_file.apa44,apa60f.apa_file.apa60f,apa60.apa_file.apa60,",
               "apa61f.apa_file.apa61f,apa61.apa_file.apa61,",   #MOD-7A0142
               "apa64.apa_file.apa64,apa65f.apa_file.apa65f,apa65.apa_file.apa65,",
               "apb02.apb_file.apb02,apb03.apb_file.apb03,apb06_07.type_file.chr1000,",
               "apb08.apb_file.apb08,apb09.apb_file.apb09,",
               "apb10.apb_file.apb10,apb12.apb_file.apb12,apb21_22.type_file.chr1000,",
               "apb23.apb_file.apb23,apb24.apb_file.apb24,",
               "apb25.apb_file.apb25,apb26.apb_file.apb26,l_gem02.gem_file.gem02,apb27.apb_file.apb27,", #MOD-970099add gem02
               "apb28.apb_file.apb28,apo02.apo_file.apo02,apr02.apr_file.apr02,",
               "gen02.gen_file.gen02,gem02.gem_file.gem02,pma02.pma_file.pma02,",
               "apz27.apz_file.apz27,oox10_sum.oox_file.oox10,pmm22.pmm_file.pmm22,",
               "cnt.type_file.num5,azi03.azi_file.azi03,",   #MOD-7B0078
               "azi04.azi_file.azi04,azi05.azi_file.azi05,azi07.azi_file.azi07,azi03_1.azi_file.azi03,",   #MOD-810213
               "azi04_1.azi_file.azi04,apa00.apa_file.apa00,",   #FUN-890002 add apa00
               "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-940041
               "sign_show.type_file.chr1,",                             #是否顯示簽核資料(Y/N)  #FUN-940041
               "sign_str.type_file.chr1000,",                         #TQC-C10034 add
               "apb33.apb_file.apb33,apb31.apb_file.apb31,apb30.apb_file.apb30,",  #MOD-950207 add
               "apb32.apb_file.apb32,apa37f.apa_file.apa37f,apa37.apa_file.apa37,",  #MOD-950207 add  #MOD-960322 add apa37f,apa37
               "apa77.apa_file.apa77,",   #FUN-970108 add apa77
              #"l_pmc03.pmc_file.pmc03"                                              #TQC-BC0013 add l_pmc03 #MOD-CC0199 mark
               "pmc03.pmc_file.pmc03"                                                #MOD-CC0199 mod pmc03
   LET l_table = cl_prt_temptable('aapr111',g_sql) CLIPPED
   IF l_table = -1 THEN
      EXIT PROGRAM
   END IF
#TQC-C10034--add--begin
   LET g_sql = "apv01.apv_file.apv01, apv02.apv_file.apv02, apv03.apv_file.apv03,",
               "apv04f.apv_file.apv04f, apv04.apv_file.apv04, azi04.azi_file.azi04,",
               "azi04_1.azi_file.azi04"
#TQC-C10034--add--end
   LET l_table1 = cl_prt_temptable('aapr1111',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "apk01.apk_file.apk01,apk02.apk_file.apk02,apk03.apk_file.apk03,",
               "apk04.apk_file.apk04,apl02.apl_file.apl02,apk05.apk_file.apk05,",
               "apk17.apk_file.apk17,apk171.apk_file.apk171,apk08.apk_file.apk08,",
               "apk07.apk_file.apk07,apk06.apk_file.apk06,azi04.azi_file.azi04,aza26.aza_file.aza26"   #MOD-7B0175
   LET l_table2 = cl_prt_temptable('aapr1112',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "npq01.npq_file.npq01,npq02.npq_file.npq02,npq03.npq_file.npq03,",
               "npq04.npq_file.npq04,npq06.npq_file.npq06,npq07.npq_file.npq07,",
               "azi04.azi_file.azi04"     #No.FUN-760045
   LET l_table3 = cl_prt_temptable('aapr1113',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "apd01.apd_file.apd01,apd02.apd_file.apd02,apd03.apd_file.apd03"
   LET l_table4 = cl_prt_temptable('aapr1114',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-BB0047 ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r111_tm(0,0)                # Input print condition
      ELSE CALL r111()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r111_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000   #No.FUN-690028 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5      #No.FUN-940102
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r111_w AT p_row,p_col WITH FORM "aap/42f/aapr111"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = 'N'
   LET tm.g    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = 'N'
   LET tm.e    = 'N'
   LET tm.f    = '1'
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#No.FUN-A10098-------------mark start
#      LET source=g_plant 
#      LET g_azp02=''
#      DISPLAY BY NAME source
#      SELECT azp02 INTO g_azp02 FROM azp_file WHERE azp01=source
#      DISPLAY g_azp02 TO FORMONLY.azp02
#      LET g_plant_new=source
#      CALL s_getdbs()
#      IF g_aza.aza53='Y' THEN
#         INPUT BY NAME source WITHOUT DEFAULTS
#            AFTER FIELD source 
#               LET g_azp02=''
#               SELECT azp02 INTO g_azp02 FROM azp_file
#                  WHERE azp01=source
#               IF STATUS THEN
#                  CALL cl_err3("sel","azp_file",source,"","100","","",0) #FUN-660122
#                  NEXT FIELD source
#               END IF
#               DISPLAY g_azp02 TO FORMONLY.azp02
#               CALL s_chk_demo(g_user,source)RETURNING li_result                                                                    
#                 IF not li_result THEN                                                                                              
#                    NEXT FIELD source                                                                                               
#                 END IF                                                                                                             
#               LET g_plant_new=source
#               CALL s_getdbs()
# 
#            AFTER INPUT
#               IF INT_FLAG THEN EXIT INPUT END IF  
# 
#            ON ACTION CONTROLP
#               CASE
#                  WHEN INFIELD(source)
#               END IF
#               DISPLAY g_azp02 TO FORMONLY.azp02
#               CALL s_chk_demo(g_user,source)RETURNING li_result                                                                    
#                 IF not li_result THEN                                                                                              
#                    NEXT FIELD source                                                                                               
#                 END IF                                                                                                             
#               LET g_plant_new=source
#               CALL s_getdbs()
# 
#            AFTER INPUT
#               IF INT_FLAG THEN EXIT INPUT END IF  
# 
#            ON ACTION CONTROLP
#               CASE
#                  WHEN INFIELD(source)
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_zxy"     #No.FUN-940102                                                             
#                       LET g_qryparam.arg1 = g_user      #No.FUN-940102 
#                       LET g_qryparam.default1 = source
#                       CALL cl_create_qry() RETURNING source 
#                       DISPLAY BY NAME source
#                       NEXT FIELD source
#               END CASE
# 
#            ON ACTION exit              #加離開功能genero
#               LET INT_FLAG = 1
#               EXIT INPUT
# 
#            ON ACTION controlg       #TQC-860021
#               CALL cl_cmdask()      #TQC-860021
# 
#            ON IDLE g_idle_seconds   #TQC-860021
#               CALL cl_on_idle()     #TQC-860021
#               CONTINUE INPUT        #TQC-860021
# 
#            ON ACTION about          #TQC-860021
#               CALL cl_about()       #TQC-860021
# 
#            ON ACTION help           #TQC-860021
#               CALL cl_show_help()   #TQC-860021
#         END INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0 
#            CLOSE WINDOW r111_w 
#            EXIT PROGRAM
#         END IF
#      END IF
#No.FUN-A10098-------------mark end
   CONSTRUCT BY NAME tm.wc ON apa01,apa02,apa06,apa21,apa22,apa36
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
#TQC-DA0026 add start ----
     ON ACTION controlp
        CASE 
           WHEN INFIELD(apa01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_apa01_1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO apa01
                NEXT FIELD apa01      
           WHEN INFIELD(apa06)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_apa06_2"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO apa06
                NEXT FIELD apa06
           WHEN INFIELD(apa21)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_apa21"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO apa21
                NEXT FIELD apa21
           WHEN INFIELD(apa22)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_apa22"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO apa22
                NEXT FIELD apa22
           WHEN INFIELD(apa36)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_apa36"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO apa36
                NEXT FIELD apa36
        END CASE 
#TQC-DA0026 add end ------ 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.f,tm.h,tm.b,tm.d,tm.g,tm.e,tm.c,tm.more
                   WITHOUT DEFAULTS HELP 1
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
      AFTER FIELD g
         IF tm.g NOT MATCHES "[YN]" OR cl_null(tm.g)
            THEN NEXT FIELD g
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)
            THEN NEXT FIELD c
         END IF
      AFTER FIELD d
         IF tm.d NOT MATCHES "[YN]" OR cl_null(tm.d)
            THEN NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e NOT MATCHES "[YN]" OR cl_null(tm.e)
            THEN NEXT FIELD e
         END IF
      AFTER FIELD f
        #IF tm.f NOT MATCHES "[12345678]" OR cl_null(tm.f)  #No.FUN-690080   #MOD-7B0023   #FUN-870026 #CHI-A90037 mark
         IF tm.f NOT MATCHES "[123456789]" OR cl_null(tm.f)  #CHI-A90037
            THEN NEXT FIELD f
         END IF
      AFTER FIELD h
         IF tm.h NOT MATCHES "[123]" OR cl_null(tm.h)
            THEN NEXT FIELD h
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   # get exec cmd (fglgo xxxx)
             WHERE zz01='aapr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr111','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,         # (at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapr111',g_time,l_cmd) # Execute cmd at later time
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1500)          #TQC-DA0026 mark 
          l_sql     STRING,                                                                              #TQC-DA0026 add
          l_chr        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_cnt     LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_order    ARRAY[5] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(16),  #No.FUN-550030
          sr               RECORD
                                  apa  RECORD LIKE apa_file.*, #應付帳款單頭
                                  apb  RECORD LIKE apb_file.*, #應付帳款單身
                                  type LIKE rvv_file.rvv03,  # No.FUN-690028 VARCHAR(01)    #出/入狀況
                                  apo02 LIKE apo_file.apo02,   #留置原因
                                  apr02 LIKE apr_file.apr02,   #類別名稱
                                  pmm22 LIKE pmm_file.pmm22,   #幣別
                                  pmn31 LIKE pmn_file.pmn31,   #採購單價
                                  pmn04 LIKE pmn_file.pmn04,   #料件編號
                                  pmn041 LIKE pmn_file.pmn041, #品名規格
                                  azi03 LIKE azi_file.azi03,   #單位小數位數
                                  azi04 LIKE azi_file.azi04,   #金額小數位數
                                  azi05 LIKE azi_file.azi05,   #小計小數位數
                                  azi07 LIKE azi_file.azi07,   #MOD-810213
                                  gen02 LIKE gen_file.gen02,   #員工姓名No:8139
                                  gem02 LIKE gem_file.gem02    #部門名稱No:8139
                        END RECORD
   DEFINE sr1              RECORD
                                  npq02 LIKE npq_file.npq02, # 項次
                                  npq03 LIKE npq_file.npq03, # 科目編號
                                  npq04 LIKE npq_file.npq04, # 摘要
                                  npp02 LIKE npp_file.npp02, # 移動日期 
                                  npq06 LIKE npq_file.npq06, # 借貸別(1.借/2.貸)
                                  npq07 LIKE npq_file.npq07  # 異動金額
                        END RECORD
   DEFINE l_apd02       LIKE apd_file.apd02
   DEFINE l_apd03       LIKE apd_file.apd03
   DEFINE l_pma02       LIKE pma_file.pma02
   DEFINE l_apv         RECORD LIKE apv_file.*
   DEFINE l_apk         RECORD LIKE apk_file.*
   DEFINE l_apl02       LIKE apl_file.apl02
   DEFINE l_net         LIKE oox_file.oox10
   DEFINE l_apb06_07    LIKE type_file.chr1000
   DEFINE l_apb21_22    LIKE type_file.chr1000
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_sign_type    LIKE type_file.chr1   #CHI-A40017
   DEFINE l_sign_show    LIKE type_file.chr1   #CHI-A40017
#TQC-C10034--mark--begin
  #DEFINE l_ii           INTEGER
  #DEFINE l_key          RECORD                  #主鍵
  #          v1          LIKE apa_file.apa01
  #          END RECORD
#TQC-C10034--mark--end
   DEFINE l_gem02        LIKE gem_file.gem02 #MOD-970099 
   DEFINE l_pmc03 LIKE pmc_file.pmc03        #TQC-BC0013 add
   DEFINE l_gec05       LIKE gec_file.gec05    #MOD-C70146 add
   DEFINE l_gec07       LIKE gec_file.gec07    #MOD-C70146 add

   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
 
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,",  #MOD-810213  #FUN-890002 add ?
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "   #FUN-940041 加3個?   #MOD-950207  #MOD-960322 add 2? #MOD-970099 add ?  #FUN-970108 add?   #TQC-C10034 add 1?  
                                                         #TQC-BC0013 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #MOD-7B0175
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"      #No.FUN-760045
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep4:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM   
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr111'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 110 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '-' END FOR  #MOD-630001

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
 
   LET l_sql = "SELECT ",
               "  apa_file.*,apb_file.*,'','','',",
               "  '','','','','','',''",
               #"  FROM apa_file ,OUTER apb_file ",   #CHI-A40017 mark
               "  FROM apa_file LEFT OUTER JOIN apb_file ", #CHI-A40017 mod
               " ON apa01 = apb01",    #CHI-A40017 mod
               #" WHERE apa_file.apa01 = apb_file.apb01",   #CHI-A40017 mark
               "  WHERE  apa42 = 'N' "                      #CHI-A40017 mod
 
   IF tm.b = 'N' THEN
      LET l_sql = l_sql CLIPPED," AND (apaprno = 0 OR apaprno IS NULL)"
   END IF
   IF tm.f = '1' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '11'"
   END IF
   IF tm.f = '2' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '12'"
   END IF
   IF tm.f = '3' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '15'"
   END IF
   IF tm.f = '4' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '17'"  #No.TQC-7C0081
   END IF
   IF tm.f = '5' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '13'"  #No.TQC-7C0081
   END IF
   IF tm.f = '6' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '16'"
   END IF
  #資料選項tm.f增加7.折讓申請 8.D.M申請,抓21與22的資料
   IF tm.f = '7' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '21'"
   END IF
   IF tm.f = '8' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '22'"
   END IF
  #TQC-BA0027 add --start--
  #資料選項tm.f增加9.暫估退貨,抓26的資料
   IF tm.f = '9' THEN
      LET l_sql = l_sql CLIPPED," AND apa00 = '26'"
   END IF
  #TQC-BA0027 add --end--
   IF tm.h = '1' THEN
      LET l_sql = l_sql CLIPPED," AND apa41 = 'Y'"
   END IF
   IF tm.h = '2' THEN
      LET l_sql = l_sql CLIPPED," AND apa41 = 'N'"
   END IF
   LET l_sql = l_sql CLIPPED," AND ",tm.wc
   PREPARE r111_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r111_curs1 CURSOR FOR r111_prepare1
#TQC-C10034--mark--begin 
#  LET l_sql = "SELECT DISTINCT apa01",
#              "  FROM apa_file LEFT OUTER JOIN apb_file ",  #NO.CHI-A40017 mod
#              "  ON apa01 = apb01",            #No.CHI-A40017 mod
#              "   WHERE apa42 = 'N' "         #NO.CHI-A40017 mod
#
#  IF tm.b = 'N' THEN
#     LET l_sql = l_sql CLIPPED," AND (apaprno = 0 OR apaprno IS NULL)"
#  END IF
#  IF tm.f = '1' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '11'"
#  END IF
#  IF tm.f = '2' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '12'"
#  END IF
#  IF tm.f = '3' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '15'"
#  END IF
#  IF tm.f = '4' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '17'"  #No.TQC-7C0081
#  END IF
#  IF tm.f = '5' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '13'"  #No.TQC-7C0081
#  END IF
#  IF tm.f = '6' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '16'"
#  END IF
#  #資料選項tm.f增加7.折讓申請 8.D.M申請,抓21與22的資料
#  IF tm.f = '7' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '21'"
#  END IF
#  IF tm.f = '8' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '22'"
#  END IF
# #CHI-A90037 add --start--
# #資料選項tm.f增加9.暫估退貨,抓26的資料
#  IF tm.f = '9' THEN
#     LET l_sql = l_sql CLIPPED," AND apa00 = '26'"
#  END IF
# #CHI-A90037 add --end--
#  IF tm.h = '1' THEN
#     LET l_sql = l_sql CLIPPED," AND apa41 = 'Y'"
#  END IF
#  IF tm.h = '2' THEN
#     LET l_sql = l_sql CLIPPED," AND apa41 = 'N'"
#  END IF
#  LET l_sql = l_sql CLIPPED," AND ",tm.wc
#  PREPARE r111_prepare1_2 FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     RETURN
#  END IF
#  DECLARE r111_curs1_2 CURSOR FOR r111_prepare1_2
#TQC-C10034---mark---end 
   #-->傳票分錄資料(npq_file)

   LET l_sql = " SELECT npq02, npq03, '',npp02,npq06, npq07 ",    #MOD-7A0117 
               "   FROM npp_file, npq_file ",    #MOD-7A0117
               "  WHERE npp01 = ? ",
               "    AND npptype = 0 ",   #CHI-7A0043
               "    AND nppsys = 'AP' AND npp00 = 1 ",
               "    AND npqsys= nppsys",
               "    AND npq01 = npp01 ",
               "    AND npq00 = npp00 ",
               "    AND npq011= npp011",
               "    AND npptype = npqtype ",   #CHI-7A0043
               " ORDER BY npq02"   #MOD-7A0117
   PREPARE r111_pnpq FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('r111_pnpq:',SQLCA.sqlcode,1)
   END IF
   DECLARE r111_cnpq CURSOR FOR r111_pnpq
 
   #-->多發票資料(apk_file)
   LET l_sql = " SELECT apk_file.*,apl02 ",
               "   FROM apk_file LEFT OUTER JOIN apl_file ON apk04=apl01 ",  #No.CHI-A40017 mod
               "  WHERE apk01 = ? "                                     #No.CHI-A40017 mod
               #"    AND apk_file.apk04 = apl_file.apl01 "            #No.CHI-A40017 mark
   PREPARE r111_papk FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('r111_papk:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r111_capk CURSOR FOR r111_papk
   #-->備註檔(apd_file)
   LET l_sql = " SELECT apd02,apd03 FROM apd_file ",
               "  WHERE apd01 = ? "
   PREPARE r111_papd FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('r111_papd:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE r111_capd CURSOR FOR r111_papd
 
   LET g_pageno = 0
   FOREACH r111_curs1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #no.5282  參考資料改在 foreach抓..
      SELECT azi03,azi04,azi05,azi07 INTO sr.azi03,sr.azi04,sr.azi05,sr.azi07   #MOD-810213
        FROM azi_file WHERE azi01 = sr.apa.apa13
 
     #FUN-A60056--mod--str--
     #SELECT pmm22,pmn31,pmn04,pmn041
     #  INTO sr.pmm22,sr.pmn31,sr.pmn04,sr.pmn041
     #  FROM pmm_file,pmn_file
     # WHERE pmm01 = pmn01
     #   AND pmn01 = sr.apb.apb06 AND pmn02 = sr.apb.apb07
 
     #SELECT rvv03 INTO sr.type FROM rvv_file
     # WHERE rvv01 = sr.apb.apb21 AND rvv02 = sr.apb.apb22
     LET l_sql = "SELECT pmm22,pmn31,pmn04,pmn041 ",
                 "  FROM ",cl_get_target_table(sr.apb.apb37,'pmm_file'),
                 "      ,",cl_get_target_table(sr.apb.apb37,'pmn_file'),
                 " WHERE pmm01 = pmn01",
                 "   AND pmn01 = '",sr.apb.apb06,"'",
                 "   AND pmn02 = '",sr.apb.apb07,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,sr.apb.apb37) RETURNING l_sql
     PREPARE sel_pmm22_cs FROM l_sql
     EXECUTE sel_pmm22_cs INTO sr.pmm22,sr.pmn31,sr.pmn04,sr.pmn041

     LET l_sql = "SELECT rvv03 FROM ",cl_get_target_table(sr.apb.apb37,'rvv_file'),
                 " WHERE rvv01 = '",sr.apb.apb21,"'",
                 "   AND rvv02 = '",sr.apb.apb22,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,sr.apb.apb37) RETURNING l_sql
     PREPARE sel_rvv03_cs FROM l_sql
     EXECUTE sel_rvv03_cs INTO sr.type 
     #FUN-A60056--mod--end
      IF sr.type IS NULL THEN LET sr.type = '1' END IF      #No:9385 add
 
      SELECT apo02 INTO sr.apo02 FROM apo_file
       WHERE apo01 = sr.apa.apa19
 
      SELECT apr02 INTO sr.apr02 FROM apr_file
       WHERE apr01 = sr.apa.apa36
 
      SELECT gen02 INTO sr.gen02 FROM gen_file   #No:8139
       WHERE gen01=sr.apa.apa21
      IF SQLCA.SQLCODE THEN
         LET sr.gen02=NULL
      END IF
 
      SELECT gem02 INTO sr.gem02 FROM gem_file   #No:8139
       WHERE gem01=sr.apa.apa22
      IF SQLCA.SQLCODE THEN
         LET sr.gem02=NULL
      END IF
 

         LET l_sql = "SELECT pmm22,pmn31,pmn04,pmn041 FROM ",
#No.FUN-A10098 ----BEGIN
#                             g_dbs_new CLIPPED,"pmm_file, ",g_dbs_new CLIPPED,"pmn_file",  #FUN-630043
                     cl_get_target_table(sr.apb.apb37,'pmm_file'),",",
                     cl_get_target_table(sr.apb.apb37,'pmn_file'),
#No.FUN-A10098 ----END
                     " WHERE pmm01 = pmn01 AND pmm18='Y'",
                     "   AND pmm01 = '",sr.apb.apb06,"'",
                     "   AND pmn01 = '",sr.apb.apb06,"'",
                     "   AND pmn02 = '",sr.apb.apb07,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                            #No.FUN-A10098 -----add
         CALL cl_parse_qry_sql(l_sql,sr.apb.apb37) RETURNING  l_sql              #No.FUN-A10098 -----add
         PREPARE r400_p2 FROM l_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('r400_p2 error',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         DECLARE r400_c2 CURSOR FOR r400_p2     #No.FUN-710086
         OPEN r400_c2                           #No.FUN-710086 r400_p2 -> r400_c2
         FETCH r400_c2 INTO sr.pmm22,sr.pmn31,sr.pmn04,sr.pmn041   #No.FUN-710086 r400_p2 -> r400_c2
 
         LET l_sql = "SELECT rvv03  FROM ",
#No.FUN-A10098 ----BEGIN
#                             g_dbs_new CLIPPED,"rvu_file, ",g_dbs_new CLIPPED,"rvv_file",  #FUN-630043
                     cl_get_target_table(sr.apb.apb37,'rvu_file'),",",
                     cl_get_target_table(sr.apb.apb37,'rvv_file'),
#No.FUN-A10098 ----END
                     " WHERE rvu01=rvv01 AND rvuconf='Y' AND ",
                     "   rvv01 = '",sr.apb.apb21,"'",
                     "   AND rvv02 = '",sr.apb.apb22,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                            #No.FUN-A10098 -----add
         CALL cl_parse_qry_sql(l_sql,sr.apb.apb37) RETURNING  l_sql              #No.FUN-A10098 -----add
         PREPARE r400_rvv FROM l_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('r400_rvv error',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         DECLARE r400_rvv1 CURSOR FOR r400_rvv  #No.FUN-710086
         OPEN r400_rvv1                         #No.FUN-710086 r400_rvv -> r400_4vv1
         FETCH r400_rvv1 INTO sr.type           #No.FUN-710086 r400_rvv -> r400_4vv1
      IF sr.type != '1' AND sr.apa.apa00 ='11'   #No.6366
      THEN LET sr.apb.apb09 = sr.apb.apb09 * -1
      END IF
 
 
      SELECT pma02 INTO l_pma02 FROM pma_file
       WHERE pma01=sr.apa.apa11
 
      IF g_apz.apz27 = 'Y' THEN
         SELECT SUM(oox10) INTO l_net FROM oox_file
          WHERE oox00 = 'AP' AND oox03 = sr.apa.apa01
         IF cl_null(l_net) THEN LET l_net = 0 END IF
      END IF
 

 
      SELECT COUNT(*) INTO g_cnt FROM apb_file WHERE apb01=sr.apa.apa01
 

 
      LET l_apb21_22 = sr.apb.apb21,'-',sr.apb.apb22 USING "&&&&"
      LET l_apb06_07 = sr.apb.apb06,'-',sr.apb.apb07 USING "&&&&"
 
      IF cl_null(sr.apa.apa37f) THEN LET sr.apa.apa37f=0 END IF   #MOD-960322 addd
      IF cl_null(sr.apa.apa37)  THEN LET sr.apa.apa37 =0 END IF   #MOD-960322 addd
      SELECT gem02 INTO l_gem02 FROM gem_file #MOD-970099
       WHERE gem01=sr.apb.apb26               #MOD-970099
      LET l_sign_type =''           #CHI-A40017 add
      LET l_sign_show ='N'          #CHI-A40017 add      
      #TQC-BC0013 ---add---str---
      LET l_pmc03=''
      SELECT pmc03 INTO l_pmc03 FROM pmc_file
       WHERE pmc01=sr.apa.apa05
      #TQC-BC0013 ---add---end---
     #---------MOD-C70146----------(S)
      SELECT gec05,gec07 INTO l_gec05,l_gec07
        FROM gec_file
       WHERE gec01 = sr.apa.apa15

      IF (l_gec05 = '2' OR  l_gec05 = '5') AND l_gec07 = 'Y' THEN
         LET sr.apb.apb24 = sr.apb.apb23 * sr.apb.apb09
         LET sr.apb.apb10 = sr.apb.apb08 * sr.apb.apb09
         LET sr.apb.apb24 = cl_digcut(sr.apb.apb24,sr.azi04)
         LET sr.apb.apb10 = cl_digcut(sr.apb.apb10,g_azi04)
      END IF
     #---------MOD-C70146----------(E)

      EXECUTE insert_prep USING
         sr.apa.apa01,sr.apa.apa02,sr.apa.apa05,
         sr.apa.apa06,sr.apa.apa07,sr.apa.apa08,
         sr.apa.apa09,sr.apa.apa12,sr.apa.apa13,
         sr.apa.apa14,sr.apa.apa15,sr.apa.apa16,
         sr.apa.apa17,sr.apa.apa171,sr.apa.apa19,
         sr.apa.apa20,sr.apa.apa21,sr.apa.apa22,
         sr.apa.apa23,sr.apa.apa24,sr.apa.apa25,
         sr.apa.apa31f,sr.apa.apa32f,sr.apa.apa34f,
         sr.apa.apa35f,sr.apa.apa31,sr.apa.apa32,
         sr.apa.apa34,sr.apa.apa35,sr.apa.apa36,
         sr.apa.apa44,sr.apa.apa60f,sr.apa.apa60,
         sr.apa.apa61f,sr.apa.apa61,   #MOD-7A0142        
         sr.apa.apa64,sr.apa.apa65f,sr.apa.apa65,
         sr.apb.apb02,sr.apb.apb03,l_apb06_07,
         sr.apb.apb08,sr.apb.apb09,sr.apb.apb10,
         sr.apb.apb12,l_apb21_22,sr.apb.apb23,
         sr.apb.apb24,sr.apb.apb25,sr.apb.apb26,
         l_gem02, #MOD-970099  
         sr.apb.apb27,sr.apb.apb28,sr.apo02,sr.apr02,
         sr.gen02,sr.gem02,l_pma02,g_apz.apz27,l_net,
         sr.pmm22,g_cnt,sr.azi03,sr.azi04,   #MOD-7B0078
         sr.azi05,sr.azi07,g_azi03,g_azi04,   #MOD-810213
         sr.apa.apa00,  #FUN-890002 add
         #"",l_img_blob,"N"    #FUN-940041    #CHI-A40017 mark
         l_sign_type,l_img_blob,l_sign_show,"",    #FUN-940041 #CHI-A40017 mod #TQC-C10034 add ""
         sr.apb.apb33,sr.apb.apb31,sr.apb.apb30,sr.apb.apb32,  #MOD-950207                                        
         sr.apa.apa37f,sr.apa.apa37,sr.apa.apa77,l_pmc03   #MOD-960322 add #FUN-970108 add apa77   #TQC-BC0013 add l_pmc03
 
   END FOREACH
 
   LET l_sql = "SELECT DISTINCT apa01 FROM ",
                g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE r111_p2 FROM l_sql
   DECLARE r111_curs2 CURSOR FOR r111_p2
   FOREACH r111_curs2 INTO sr.apa.apa01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CALL appr111_upd(sr.apa.apa01)   #MOD-7A0117
 
      DECLARE r111_c2 CURSOR FOR
         SELECT * FROM apv_file WHERE apv01 = sr.apa.apa01
      FOREACH r111_c2 INTO l_apv.*
         IF STATUS THEN EXIT FOREACH END IF
         EXECUTE insert_prep1 USING sr.apa.apa01,l_apv.apv02,l_apv.apv03,
                                    l_apv.apv04f,l_apv.apv04,
                                    sr.azi04,g_azi04 
#TQC-C10034--add--begin
      END FOREACH

      FOREACH r111_capk USING sr.apa.apa01 INTO l_apk.*,l_apl02
         IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
         END IF
        #當apk04為NULL或' '值時,廠商簡稱改抓單頭apa07
         IF cl_null(l_apk.apk04) OR l_apk.apk04=' ' THEN
            SELECT apa07 INTO sr.apa.apa07 FROM apa_file
             WHERE apa01=sr.apa.apa01
            LET l_apl02=sr.apa.apa07
         END IF
         LET l_apl02 = l_apl02[1,10]
         EXECUTE insert_prep2 USING sr.apa.apa01,l_apk.apk02,l_apk.apk03,
                                    l_apk.apk04,l_apl02,l_apk.apk05,l_apk.apk17,
                                    l_apk.apk171,l_apk.apk08,l_apk.apk07,l_apk.apk06,
                                    #sr.azi04       #No.FUN-760045   #MOD-7B0175
                                    sr.azi04,g_aza.aza26  #MOD-7B0175
      END FOREACH

      FOREACH r111_cnpq USING sr.apa.apa01 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
        # CALL s_get_bookno(sr1.npp02)     #FUN-C10024  mark
          CALL s_get_bookno(YEAR(sr1.npp02)) 
             RETURNING g_flag, g_bookno1,g_bookno2
         IF g_flag='1' THEN   #抓不到帳別
            CALL cl_err('foreach:','aoo-081',1)
            EXIT FOREACH
         END IF
         SELECT aag02 INTO sr1.npq04 FROM aag_file
          WHERE aag00=g_bookno1
            AND aag01=sr1.npq03     
#TQC-C10034--add--end
         EXECUTE insert_prep3 USING sr.apa.apa01,sr1.npq02,sr1.npq03,sr1.npq04,
                                    sr1.npq06,sr1.npq07,sr.azi04       
      END FOREACH
 
      FOREACH r111_capd USING sr.apa.apa01 INTO l_apd02,l_apd03
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         EXECUTE insert_prep4 USING sr.apa.apa01,l_apd02,l_apd03
      END FOREACH
 
   END FOREACH
 
 
   CALL cl_wcchp(tm.wc,'apa01,apa02,apa06,apa21,apa22,apa36')
        RETURNING tm.wc
   LET g_str = tm.wc,";",g_zz05,";",tm.f,";",tm.e,";",tm.g,";",tm.c,";",tm.d CLIPPED  
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table  CLIPPED,"|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table3 CLIPPED, "|",               
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table4 CLIPPED

   LET g_cr_table = l_table                 #主報表的temp table名稱
  #LET g_cr_gcx01 = "aapi103"               #單別維護程式   #TQC-C10034 mark
   LET g_cr_apr_key_f = "apa01"             #報表主鍵欄位名稱，用"|"隔開 
#TQC-C10034--mark--begin
  #LET l_ii = 1
  ##報表主鍵值
  #CALL g_cr_apr_key.clear()                #清空
  #FOREACH r111_curs1_2 INTO l_key.*            
  #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
  #   LET l_ii = l_ii + 1
  #END FOREACH
#TQC-C10034--mark--end 
     
     CALL cl_prt_cs3('aapr111','aapr111',l_sql,g_str)
 
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105
END FUNCTION
 
FUNCTION appr111_upd(l_apa01)
     DEFINE l_apa01 LIKE apa_file.apa01
     DEFINE l_apaprno LIKE apa_file.apaprno   #MOD-830072
 
     SELECT apaprno INTO l_apaprno FROM apa_file
       WHERE apa01=l_apa01
     IF cl_null(l_apaprno) THEN
        UPDATE apa_file SET apaprno = 0 WHERE apa01 = l_apa01
     END IF 
 
     UPDATE apa_file SET apaprno = apaprno + 1 WHERE apa01 = l_apa01
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err3("upd","apa_file",l_apa01,"",SQLCA.sqlcode,"","foreach:",1)  #No.FUN-660122
     END IF
END FUNCTION
 
#No.FUN-9C0077 程式精簡
