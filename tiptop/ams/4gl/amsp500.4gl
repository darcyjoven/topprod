# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: amsp500.4gl
# Descriptions...: MRP 計劃模擬
# Date & Author..: 96/05/25 By Roger
# Note...........: MPS(amri500) 的供給與下階需求皆不考慮
# Modify ........: No:9359 04/03/19 By Melody 需加判斷元件有效碼='Y'
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: NO.MOD-4C0101 04/12/17 by pengu 修改報表檔案產生模式
# Modify.........: NO.MOD-530745 05/03/30 by ching 連續執行有錯
# Modify.........: No.FUN-550056 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/06 By pengu 3REATE TEMP TABLE 欄位放大
# Modify ........: No.FUN-560060 05/06/15 By vivien 單據編號加大返工				
# Modify ........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.MOD-540195 05/07/22 By pengu  1.於p500_mps039()取預測資料時起始時間應該採用fordate不是採用 bdate
# Modify.........: NO.MOD-580222 05/08/23 By Rosayu cl_used只可以在main中進入點跟退出點呼叫兩次
# Modify.........: NO.FUN-5A0017 05/10/06 By Sarah 日期計算應判斷其合理性,排除掉非工作日(s_aday)
# Modify.........: NO.FUN-5A0145 05/10/31 By Sarah 判斷截止日期(edate)不可小於起始日期(forbdate)
# Modify.........: No.FUN-5A0200 05/12/20 By Pengu  資料篩選，MPS基準日，改由"資料起始日"為基準，而不是原本的"計畫基準日"
# Modify.........: NO.FUN-5C0041 05/12/26 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-570126 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-640272 06/04/28 By Sarah 當有FQC時，FQC量沒有計算入供給量中去
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-660110 06/06/23 By Sarah 檔掉工單性質屬於試產性工單(sfb02='15')
# Modify.........: No.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號改成char(16)
# Modify.........: No.TQC-680016 06/08/07 By 1.執行amsp500模擬MPS時無法成功
                          #                  2.畫面輸入順序不對 
# Modify.........: No.MOD-680009 06/08/07 By Pengu S委外加工"件,應該要考慮交期提前天數
# Modify.........: No.MOD-670085 06/08/07 By 若主料有訂單量時，且其下階料也要列入MPS計算時，將下階料的需求
                              #              算在訂單量上，而不是算再下階備料
# Modify.........: No.FUN-680101 06/09/07 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-670074 06/09/07 By kim plp/plm 量應該要考慮單位小數取位 同asfi301 處理  (amsp500 也是要考慮)
# Modify.........: No.FUN-690047 06/09/28 By Sarah 抓取請購單、採購單資料時,需將pml38='Y',pmn38='Y'條件加入
# Modify.........: No.FUN-6A0012 06/10/16 By Sarah 算受訂量時，合約數量不納入(串oea_file的條件加上oea00<>'0')
# Modify.........: No.FUN-6A0049 06/10/23 By rainy CALL err() -> cl_err3()
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.MOD-710107 07/01/22 By pengu p500_mpg_c CURSOR的SQL語法
# Modify.........: No.TQC-720042 07/02/27 By jamie DEFINE 錯誤
# Modify.........: No.TQC-790001 07/09/02 By Mandy PK問題
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.MOD-790070 07/09/17 By Pengu CREATE TEMP TABLE時應先建INDEX在INSERT資料
# Modify.........: No.MOD-7A0036 07/10/17 By Pengu 修改TEMP TABLE的欄位資料型態
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.MOD-820085 08/02/26 By Pengu CREATE TEMP TABLE 之前都做drop table的動作
# Modify.........: No.MOD-810233 08/02/26 By Pengu MRP最終計算PLM/PLP量時如果是P件應該根據採購單位和庫存單位做一個換算
#                                                  再考慮最小採購量和採購批量
# Modify.........: No.MOD-810107 08/03/23 By Pengu 調整i,j,k變數的資料型態
# Modify.........: No.MOD-840090 08/04/19 By Pengu p500_mps045未考慮特性代碼
# Modify.........: No.MOD-850310 08/05/30 by claire 工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領,若 A  < 0 ,則 LET A = 0
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.MOD-860338 08/07/16 By Pengu 取訂單只要未作廢皆抓取。建議應跟amrp500一致，只抓取已確認之訂單
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-8C0021 08/12/02 By chenyu 取l_gfe03的sql有誤
# Modify.........: No.MOD-890257 08/12/22 By Pengu 跟amrp500一致，只抓取已確認之訂單
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950015 09/05/05 By Smapmin QOH_used table已沒有Create,故相關程式段也要拿掉
# Modify.........: No.FUN-940083 09/05/14 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.MOD-970143 09/07/16 By lilingyu run MPS時,應直接抓oea_file,oeb_file,不需要從mpg_file抓 
# Modify.........: No.FUN-980005 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:FUN-9A0096 09/10/29 By lilingyu 更改sql的標準寫法
# Modify.........: No:MOD-9B0106 09/11/17 By Smapmin 修改變數定義
# Modify.........: No:TQC-9C0100 09/12/14 By lilingyu 查詢時,發生語法錯誤 
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.TQC-A30097 10/03/18 By lilingyu _rep函數里的l_im50變量重新定義
# Modify.........: No.FUN-A40002 10/04/01 By lilingyu 增加規格替代的計算
# Modify.........: No.FUN-A20037 10/04/13 By lilingyu  過單
# Modify.........: No.TQC-A40069 10/04/14 By destiny 于MRP對應將BOM料號改為發料料號
# Modify.........: No.MOD-A40081 10/05/18 By liuxqa modify sql
# Modify.........: No:FUN-A70034 10/07/08 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-AB0229 10/11/25 By sabrina 將sales欄位放大成char(10)
# Modify.........: No.TQC-AB0112 10/11/28 By vealxu INSERT mpt_file時mptplant欄位未有賦值
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:MOD-B50134 11/07/17 By Summer 若key值重覆時，則將金額做加總後update opc_tmp 
# Modify.........: No:CHI-C80048 12/10/25 By bart 取消時距限制30
# Modify.........: No:MOD-CC0173 12/12/26 By Elise 增加考慮rpc_file的已確認與未結案
# Modify.........: No:CHI-D20018 13/03/11 By bart 改善log的執行呈現訊息

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE mpr		RECORD LIKE mpr_file.*
DEFINE mpl		RECORD LIKE mpl_file.*
DEFINE mps		RECORD LIKE mps_file.*
DEFINE mpt		RECORD LIKE mpt_file.*
DEFINE msa		RECORD LIKE msa_file.*
DEFINE msb		RECORD LIKE msb_file.*
DEFINE bma		RECORD LIKE bma_file.*
DEFINE bmb		RECORD LIKE bmb_file.*
DEFINE bon              RECORD LIKE bon_file.*     #FUN-A40002
DEFINE g_ima01       LIKE ima_file.ima01           #FUN-A40002
DEFINE bmb1		RECORD LIKE bmb_file.*
DEFINE bmb2		RECORD LIKE bmb_file.*
DEFINE bmb3		RECORD LIKE bmb_file.*
DEFINE bmb4		RECORD LIKE bmb_file.*
DEFINE bmd		RECORD LIKE bmd_file.*
DEFINE rpc		RECORD LIKE rpc_file.*
DEFINE g_msa            RECORD LIKE msa_file.*
DEFINE g_msb            RECORD LIKE msb_file.*
DEFINE ver_no  		LIKE mpt_file.mpt_v     #NO.FUN-680101  VARCHAR(2)
DEFINE lot_type		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
DEFINE lot_bm		LIKE type_file.num5     #NO.FUN-680101  SMALLINT
DEFINE lot_no1		LIKE ima_file.ima01     #MOD-9B0106 chr20-->ima01 
DEFINE lot_no2		LIKE ima_file.ima01     #MOD-9B0106 chr20-->ima01
DEFINE past_date  	LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE bdate,edate	LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE forbdate         LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE buk_type		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)   # Bucket Type
DEFINE buk_code		LIKE mpz_file.mpz03     #NO.FUN-680101  VARCHAR(4)	  # Bucket code
DEFINE po_days		LIKE type_file.num10    #NO.FUN-680101  INTEGER	  # Reschedule days
DEFINE wo_days		LIKE type_file.num10    #NO.FUN-680101  INTEGER   # Reschedule days
DEFINE incl_id 		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
DEFINE incl_so 		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
DEFINE msb_expl		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)   # msb_file explosing flag
DEFINE mss_expl		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)	  # mps_file explosing flag
DEFINE mps_save		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)   # 保留現有MPS 計劃否
DEFINE mps_msa01    	LIKE msa_file.msa01     #NO.FUN-680101  VARCHAR(16)  # 欲保留的MPS 計劃編號   #No.FUN-560060
DEFINE mbdate   	LIKE type_file.dat      #NO.FUN-680101  date      # 日期區間起
DEFINE medate   	LIKE type_file.dat      #NO.FUN-680101  date      # 日期區間止
DEFINE sub_flag		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)	
DEFINE qvl_flag		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)	
DEFINE qvl_bml03	LIKE type_file.num5     #NO.FUN-680101  SMALLINT
DEFINE qty_type         LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
DEFINE sw               LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(01)   #NO.FUN-5C0041 ADD
DEFINE needdate  	LIKE type_file.dat      #NO.FUN-680101  DATE	   # MRP Need Date
DEFINE i,j,k		LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE g_qty,g_nopen	LIKE sfb_file.sfb08     #NO.FUN-680101  DEC(15,3)
DEFINE g_mps00		LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE g_mps01		LIKE mps_file.mps01     #NO.MOD-490217
DEFINE g_mps03		LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE g_mpt03		LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE g_mpt04		LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE g_mpt06		LIKE type_file.chr20    #NO.FUN-680101  VARCHAR(20)
DEFINE g_mpt061		LIKE type_file.num5     #NO.FUN-680101  SMALLINT
DEFINE g_mpt07		LIKE mpt_file.mpt07     #NO.MOD-490217
DEFINE g_mpt08		LIKE mpt_file.mpt08     #NO.FUN-680101  DEC(15,3)
DEFINE g_argv1		LIKE mpt_file.mpt_v     #NO.FUN-680101  VARCHAR(2)
DEFINE g_err_cnt	LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE g_n		LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE g_x1		LIKE type_file.chr20    #NO.FUN-680101  VARCHAR(6)
DEFINE g_ima16		LIKE type_file.num10    #NO.FUN-680101  INTEGER
DEFINE g_sub_qty	LIKE mpt_file.mpt08     #NO.FUN-680101  DEC(15,3)
DEFINE fz_flag		LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
DEFINE g_sfa01          LIKE sfa_file.sfa01     #NO.FUN-680101  VARCHAR(16)    #No.FUN-550056
DEFINE g_sfb05		LIKE sfb_file.sfb05     #NO.MOD-490217
DEFINE g_sfb13		LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE g_eff_date	LIKE type_file.dat      #NO.FUN-680101  DATE
DEFINE g_oeb01          LIKE oeb_file.oeb01     #NO.FUN-680101  VARCHAR(16)    #No.FUN-550056
DEFINE g_oeb03	        LIKE type_file.num5     #NO.FUN-680101  SMALLINT
DEFINE g_oeb15	        LIKE oeb_file.oeb15     #NO.FUN-680101  DATE
DEFINE g_sw             LIKE type_file.num5     #NO.FUN-680101  SMALLINT    #NO.FUN-5C0041
DEFINE   g_i            LIKE type_file.num5     #NO.FUN-680101  SMALLINT    #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(72)
DEFINE   g_locale       LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(01)
DEFINE   g_flag         LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(01)    #NO.FUN-570126
DEFINE   g_change_lang  LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
 
MAIN
   DEFINE   ls_date     STRING        #No.FUN-570126
   DEFINE   ls_cmd      STRING        #No.FUN-570126
   DEFINE   li_result   LIKE type_file.num5     #NO.FUN-680101  SMALLINT     #No.FUN-570126
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ver_no = ARG_VAL(1)
   LET g_argv1=ARG_VAL(1)
   LET lot_no1 = ARG_VAL(2)
   LET lot_no2 = ARG_VAL(3)
   LET buk_type = ARG_VAL(4)
   LET buk_code = ARG_VAL(5)
   LET ls_date = ARG_VAL(6)
   LET bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(7)
   LET forbdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(8)
   LET edate = cl_batch_bg_date_convert(ls_date)
   LET po_days = ARG_VAL(9)
   LET wo_days = ARG_VAL(10)
   LET incl_id = ARG_VAL(11)
   LET incl_so = ARG_VAL(12)
   LET qty_type = ARG_VAL(13)
   LET mss_expl = ARG_VAL(14)
   LET mps_save = ARG_VAL(15)
   LET mps_msa01 = ARG_VAL(16)
   LET ls_date = ARG_VAL(17)
   LET mbdate    = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(18)
   LET medate =  cl_batch_bg_date_convert(ls_date)
   LET g_bgjob = ARG_VAL(19)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
  
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p500_ask()
         IF cl_sure(18,20) THEN
            CALL p500_mrp()
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
            ELSE
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p500_w
               EXIT WHILE
            END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       LET g_success = 'Y'
       CALL p500_mrp()
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
  END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION p500_wc_default()
   SELECT * INTO mpr.* FROM mpr_file WHERE mpr_v=ver_no
   IF STATUS=0
      THEN LET lot_type=mpr.lot_type
           LET lot_bm  =mpr.lot_bm
           LET lot_no1 =mpr.lot_no1
           LET lot_no2 =mpr.lot_no2
           LET forbdate=mpr.forbdate
           LET bdate   =mpr.bdate
           LET edate   =mpr.edate
           LET po_days =mpr.po_days
           LET wo_days =mpr.wo_days
           LET incl_id =mpr.incl_id
           LET incl_so =mpr.incl_so
           LET qty_type=mpr.qty_type
           LET mss_expl=mpr.mss_expl
           LET sub_flag=mpr.sub_flag
           LET qvl_flag='N'
           LET mps_save=mpr.mps_save
           LET mps_msa01=mpr.mps_msa01
           LET mbdate  =mpr.mbdate
           LET medate  =mpr.medate
      ELSE LET lot_type='1'
           LET lot_bm  =99
           LET lot_no1 ='*'
           LET lot_no2 =NULL
           LET forbdate   =TODAY    #No.FUN-5A0200 add
           LET edate   =TODAY+30
           LET po_days =0
           LET wo_days =0
           LET incl_id='Y'
           LET incl_so='1'
           LET qty_type='N'
           LET mss_expl='Y'
           LET sub_flag='Y'
           LET qvl_flag='N'
           LET mps_save='N'
           LET mps_msa01=''
           LET mbdate  =''
           LET medate  =''
   END IF
END FUNCTION
 
FUNCTION p500_declare()		# DECLARE Insert Cursor
   DEFINE l_sql		STRING  #LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(600)
 
   LET l_sql="INSERT INTO mpt_file(mpt_v, mpt01, mpt02, mpt03, mpt04, mpt05, mpt06, ",
                                "  mpt061,mpt06_fz,mpt07,mpt08,mptplant,mptlegal) ",  #TQC-9C0100
                         " VALUES (?,?,?,?,?,?,?,?,?,?,?, ?,?)"                      #FUN-980005 

   PREPARE p500_p_ins_mpt FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_mpt',STATUS,1) END IF
   DECLARE p500_c_ins_mpt CURSOR WITH HOLD FOR p500_p_ins_mpt
   IF STATUS THEN CALL cl_err('dec ins_mpt',STATUS,1) END IF
 
##--  declare cursor for update mps_file --##
   LET l_sql="UPDATE mps_file SET mps039=mps039+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps039 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps039',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps041=mps041+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps041 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps041',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps043=mps043+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps043 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps043',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps044=mps044+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps044 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps044',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps046=mps046+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps046 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps044',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps051=mps051+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps051 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps051',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps052=mps052+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps052 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps052',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps053=mps053+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps053 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps053',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps061=mps061+?,mps06_fz=mps06_fz+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps061 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps061',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps062=mps062+?,mps063=mps063+?,",
                                 "mps06_fz=mps06_fz+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps062 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps062',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps064=mps064+?,mps06_fz=mps06_fz+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps064 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps064',STATUS,1) END IF
 
   LET l_sql="UPDATE mps_file SET mps065=mps065+?",
             " WHERE mps_v=?",
             "   AND mps01=? AND mps02=? AND mps03=?"
   PREPARE p500_p_upd_mps065 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps065',STATUS,1) END IF
 
   LET l_sql ="UPDATE mps_file SET ",
     "mps_v=? , mps00=?,  mps01=? , mps02=? , mps03=? , mps039=?, mps041=? ,",
     "mps043=?, mps044=?, mps046=? ,mps051=?, mps052=?, mps053=?, mps061=?, ",
     "mps062=?, mps063=?, mps064=?, mps065=?, mps06_fz=?, mps071=?, mps072=?,",
     "mps08=?,  mps09=?,  mps10=?,  mps11=?, mps12=?, mpsplant=?, mpslegal=? ", #FUN-980005 add mpsplant,mpslegal
     " WHERE mps_v=? AND mps01=? AND mps03=?"
   PREPARE p500_p_upd_mps FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mps',STATUS,1) END IF
 
END FUNCTION
 
FUNCTION p500_mrp()
      IF qvl_flag='Y' THEN
         LET qvl_bml03=1
      ELSE
         LET qvl_bml03=NULL
      END IF
 
   CALL p500_ins_mpr1()		# 版本記錄 begin
   CALL p500_del()		# 將原資料(mps,mpt,mpl,mpk)清除
   CALL p500_c_buk_tmp()	# 產生時距檔
   CALL p500_c_part_tmp()	# 找出需 MPS 的料號
   CALL p500_declare()		# DECLARE Insert Cursor
   OPEN p500_c_ins_mpt
   IF STATUS THEN CALL cl_err('open ins_mpt',STATUS,1) END IF
   CALL p500_forcast()          # 取最近的預測資料
   CALL p500_mps039()		# 彙總 預測需求
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps040()		# 彙總 安全庫存量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps041()		# 彙總 獨立需求
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps042()		# 彙總 受訂量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
 
#納入保留的 MPS 計劃
   CALL p500_mps043()		# 彙總 計劃備(MPS計劃 下階料)
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps044()		# 彙總 工單備(實際工單下階料)
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
 
   CALL p500_c_part_tmp2()	# 找出需 MRP 的料號+廠商    #bugno:6768 #開放
 
   CALL p500_mps051()		# ---> 庫存量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps052()		# ---> 在驗量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps061()		# ---> 請購量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps062_63()	# ---> 採購量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
   CALL p500_mps064()		# ---> 在製量
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
 
#納入保留的 MPS 計劃
   CALL p500_mps065()		# ---> 計劃產
   FLUSH p500_c_ins_mpt         # 將insert mpt_file 的 cursor 寫入 database
 
   CALL p500_plan()		# 提出規劃建議
   CLOSE p500_c_ins_mpt
   CALL p500_ins_mpr2()		# 版本記錄結束
END FUNCTION
 
FUNCTION p500_ask()
   DEFINE l_mpz       RECORD LIKE mpz_file.*
   DEFINE lc_cmd      LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(500)      #No.FUN-570126
   DEFINE ls_add      STRING         #No.FUN-570126
 
   OPEN WINDOW p500_w WITH FORM "ams/42f/amsp500"
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
 
   LET ver_no  = ""
   LET bdate   = NULL
   LET forbdate=NULL
   LET edate   = NULL
   LET g_bgjob   = "N"
 
WHILE TRUE   #NO.FUN-570126
      SELECT * INTO l_mpz.* FROM mpz_file WHERE mpz00='0'
      IF STATUS THEN
         CALL cl_err3("sel","mpz_file",g_mpz.mpz00,"",STATUS,"","sel mpz",1)   #No.FUN-660108
      END IF
      LET sw = 'Y'   #NO.FUN-5C0041 ADD
      LET buk_type = l_mpz.mpz02
      LET buk_code = l_mpz.mpz03
      ERROR ''
      INPUT BY NAME ver_no,lot_no1,lot_no2,buk_type,buk_code,
                    forbdate,bdate,edate,po_days,wo_days,       #No.TQC-680016 modify
                    incl_id,incl_so,qty_type,mss_expl,
                    sw,g_bgjob,mps_save,mps_msa01,mbdate,medate  #NO.FUN-570126
            WITHOUT DEFAULTS
 
         AFTER FIELD ver_no
            IF NOT cl_null(ver_no) THEN
               IF l_mpz.mpz_v = ver_no THEN
                  LET g_msg=ver_no CLIPPED,'為目前所 Release MPS計劃的 MPS 模擬版本,建議您選用其他模擬版本'
                  CALL cl_err(g_msg,'!',0)
               END IF
               IF lot_type IS NULL THEN
                  CALL p500_wc_default()
                  DISPLAY BY NAME lot_no1,lot_no2,forbdate,edate, bdate,
                                  buk_type,buk_code,po_days,wo_days,
                                  incl_id,incl_so,qty_type,mss_expl,
                                  mps_save,mps_msa01,mbdate,medate,sw,g_bgjob,
                                  mps_save,mps_msa01,mbdate,medate #NO.FUN-5C0041
               END IF
            END IF
 
 
         BEFORE FIELD buk_code
            IF buk_type!='1' THEN
               LET buk_code = NULL DISPLAY BY NAME buk_code
            END IF
 
         AFTER FIELD buk_code
            IF buk_code IS NULL THEN
               NEXT FIELD buk_code
            END IF
            SELECT * FROM rpg_file WHERE rpg01 = buk_code
            IF STATUS THEN
               CALL cl_err3("sel","rpg_file",buk_code,"",STATUS,"","sel rpg",1)   #No.FUN-660108
               NEXT FIELD buk_code
            END IF
 
         AFTER FIELD forbdate
            IF NOT cl_null(forbdate) AND NOT cl_null(edate) THEN
               IF forbdate > edate THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD forbdate
               END IF
            END IF
 
         AFTER FIELD edate
            IF NOT cl_null(forbdate) AND NOT cl_null(edate) THEN
               IF forbdate > edate THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD edate
               END IF
            END IF
 
         AFTER FIELD incl_so
            IF NOT cl_null(incl_so) THEN
               IF incl_so NOT MATCHES '[123]' THEN
                  NEXT FIELD incl_so
               END IF
            END IF
 
         ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET sw = "N"
               DISPLAY BY NAME sw
               CALL cl_set_comp_entry("sw",FALSE)
            ELSE
               CALL cl_set_comp_entry("sw",TRUE)
            END IF
 
         AFTER FIELD mps_save   # 保留現有MPS 計劃否
            IF NOT cl_null(mps_save) THEN
               IF mps_save not matches '[YN]' THEN
                  NEXT FIELD mps_save
               END IF
               IF mps_save = 'N' THEN
                  LET mps_msa01 = ''
                  LET mbdate = ''
                  LET medate = ''
                  DISPLAY BY NAME mps_msa01,mbdate,medate
                  EXIT INPUT
               END IF
            END IF
 
         BEFORE FIELD mps_msa01  #
            IF mps_save='Y' AND cl_null(mps_msa01) THEN
               SELECT MAX(msa01) INTO mps_msa01
                 FROM msa_file
                WHERE msa03 = 'N' # 未結案
               DISPLAY BY NAME mps_msa01
            END IF
 
         AFTER FIELD mps_msa01  #
            IF NOT cl_null(mps_msa01) THEN
               SELECT * INTO g_msa.* FROM msa_file WHERE msa01=mps_msa01
               IF STATUS THEN
                  CALL cl_err3("sel","msa_file",mps_msa01,"",STATUS,"","sel msafile",1)   #No.FUN-660108
                  NEXT FIELD mps_msa01
               END IF
               IF g_msa.msa03 = 'Y' THEN # 已結案
                  CALL cl_err(mps_msa01,'aec-078',0)
                  NEXT FIELD mps_msa01
               END IF
               IF cl_null(mbdate) THEN
                  SELECT MIN(msb04) INTO mbdate
                    FROM msb_file
                   WHERE msb01 = mps_msa01
                  DISPLAY BY NAME mbdate
               END IF
               IF cl_null(medate) THEN
                  SELECT MAX(msb04) INTO medate
                    FROM msb_file
                   WHERE msb01 = mps_msa01
                  DISPLAY BY NAME medate
               END IF
            END IF
 
 
            IF NOT cl_null(mps_msa01) THEN
               SELECT * INTO g_msa.* FROM msa_file WHERE msa01=mps_msa01
               IF STATUS THEN
                  CALL cl_err3("sel","msa_file",mps_msa01,"",STATUS,"","sel msa_file",1)   #No.FUN-660108
                  NEXT FIELD mps_msa01
               END IF
               IF g_msa.msa03 = 'Y' THEN # 已結案
                  CALL cl_err(mps_msa01,'aec-078',0)
                  NEXT FIELD mps_msa01
               END IF
            END IF
 
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE   #NO.FUN-570126 
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      LET g_locale='N'
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "amsp500"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err("amsp500","9031",1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",ver_no CLIPPED,"'",
                        " '",lot_no1 CLIPPED,"'",
                        " '",lot_no2 CLIPPED,"'",
                        " '",buk_type CLIPPED,"'",
                        " '",buk_code CLIPPED,"'",
                        " '",bdate CLIPPED,"'",
                        " '",forbdate CLIPPED,"'",
                        " '",edate CLIPPED,"'",
                        " '",po_days,"'",
                        " '",wo_days,"'",
                        " '",incl_id CLIPPED,"'",
                        " '",incl_so CLIPPED,"'",
                        " '",qty_type CLIPPED,"'",
                        " '",mss_expl CLIPPED,"'",
                        " '",mps_save CLIPPED,"'",
                        " '",mps_msa01 CLIPPED,"'",
                        " '",mbdate CLIPPED,"'",
                        " '",medate CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat("amsp500",g_time,lc_cmd CLIPPED)
           CLOSE WINDOW p500_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
     END IF
     EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p500_ins_mpr1()
  DEFINE l_mpr02   LIKE mpr_file.mpr02   #NO.FUN-680101  VARCHAR(8)
   CALL msg(" Start .....")
   INITIALIZE mpr.* TO NULL
   LET mpr.mpr_v=ver_no
   LET mpr.mpr01=TODAY
   LET l_mpr02 = TIME
   LET mpr.mpr02=l_mpr02
   LET mpr.mpr05=g_user
   LET mpr.lot_type=lot_type
   LET mpr.lot_bm  =lot_bm
   LET mpr.lot_no1 =lot_no1
   LET mpr.lot_no2 =lot_no2
   LET mpr.forbdate   =forbdate    #No.FUN-5A0200 add
   LET mpr.edate   =edate
   LET mpr.buk_type   =buk_type
   LET mpr.buk_code   =buk_code
   LET mpr.po_days    =po_days
   LET mpr.wo_days    =wo_days
   LET mpr.incl_id    =incl_id
   LET mpr.incl_so    =incl_so
   LET mpr.qty_type   =qty_type
   LET mpr.mss_expl   =mss_expl
   LET mpr.sub_flag   =sub_flag
   LET mpr.mps_save   =mps_save
   LET mpr.mps_msa01  =mps_msa01
   LET mpr.mbdate     =mbdate
   LET mpr.medate     =medate
   DELETE FROM mpr_file WHERE mpr_v=ver_no
   IF STATUS THEN 
     CALL cl_err3("del","mpr_file",ver_no,"",STATUS,"","ins mpr",1)   
   END IF
   INSERT INTO mpr_file VALUES(mpr.*)
   IF STATUS THEN  
     CALL cl_err3("ins","mpr_file",mpr.mpr01,"",STATUS,"","del mpr",1)   
       CALL cl_batch_bg_javamail("N")   #NO.FUN-570126 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
END FUNCTION
 
FUNCTION p500_ins_mpr2()
  DEFINE l_mpr03   LIKE mpr_file.mpr03   #NO.FUN-680101  VARCHAR(8)
  DEFINE l_cnt     LIKE type_file.num5    # CHI-D20018

  #CHI-D20018-start-add    
   SELECT COUNT(*) INTO l_cnt 
   FROM mps_file
   WHERE mps_v = ver_no

   IF l_cnt = 0 THEN                              
      CALL msg(" End .....(未產生資料)")
   ELSE 
  #CHI-D20018-end-add 
      CALL msg(" End .....")
   END IF              #CHI-D20018
   LET l_mpr03 = TIME
   LET mpr.mpr03=l_mpr03
   LET mpr.mpr04=g_mps00
   UPDATE mpr_file SET mpr03=mpr.mpr03,
                       mpr04=mpr.mpr04
    WHERE mpr_v=ver_no
   IF STATUS THEN
      CALL cl_err3("upd","mpr_file",ver_no,"",STATUS,"","upd mpr",1)   
   END IF
   UPDATE sma_file SET sma21=TODAY WHERE sma00='0'
END FUNCTION
 
FUNCTION p500_del()
   CALL p500_del_mps()		# 將原資料(mps_file)清除
   CALL p500_del_mpt() 		# 將原資料(mpt_file)清除
   CALL p500_del_mpl() 		# 將 Log  (mpl_file)清除
   CALL p500_del_mpk() 		# 將時距日(mpk_file)清除
   CALL p500_del_mpm() 		# 將時距日/實際對照檔(mpm_file)清除
END FUNCTION
 
FUNCTION p500_del_mps()
   DELETE FROM mps_file WHERE mps_v=ver_no
   IF STATUS THEN  
     CALL cl_err3("del","mps_file",ver_no,"",STATUS,"","del mps",1)   
       CALL cl_batch_bg_javamail("N")  #NO.FUN-570126 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
END FUNCTION
 
FUNCTION p500_del_mpt()
   DEFINE l_mpt          RECORD LIKE mpt_file.* 

#FUN-A40002 --begin-  
  # DECLARE del_mpt_c CURSOR FOR
  #    SELECT * FROM mpt_file WHERE mpt_v=ver_no
  # FOREACH del_mpt_c INTO l_mpt.*
  #   DELETE FROM mpt_file WHERE mpt_v=l_mpt.mpt_v AND mpt01=l_mpt.mpt01 AND mpt02=l_mpt.mpt02
  #                        AND mpt03=l_mpt.mpt03 AND mpt04=l_mpt.mpt04
  #                        AND mpt05=l_mpt.mpt05 AND mpt06=l_mpt.mpt06
  #                        AND mpt061=l_mpt.mpt061 AND mpt06_fz=l_mpt.mpt06_fz
  #                        AND mpt07=l_mpt.mpt07 AND mpt08=l_mpt.mpt08
#FUN-A40002 --end--  
  DELETE FROM mpt_file WHERE mpt_v = ver_no   #FUN-A40002 
     IF STATUS THEN  
        CALL cl_err3("del","mpt_file",ver_no,"",STATUS,"","del mpt",1)   
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
#   END FOREACH   #FUN-A40002
END FUNCTION
 
FUNCTION p500_del_mpl()
   DELETE FROM mpl_file WHERE mpl_v=ver_no
   IF STATUS THEN 
      CALL cl_err3("del","mpl_file",ver_no,"",STATUS,"","del mpl",1)   
   END IF
END FUNCTION
 
FUNCTION p500_del_mpk()
   DELETE FROM mpk_file WHERE mpk_v=ver_no
   IF STATUS THEN 
      CALL cl_err3("del","mpk_file",ver_no,"",STATUS,"","del mpk",1)   
   END IF
END FUNCTION
 
FUNCTION p500_del_mpm()
   DELETE FROM mpm_file WHERE mpm_v=ver_no
   IF STATUS THEN 
      CALL cl_err3("del","mpm_file",ver_no,"",STATUS,"","del mpm",1)   
   END IF
END FUNCTION
 
FUNCTION p500_c_buk_tmp()	# 產生時距檔
  DEFINE d,d2	LIKE type_file.dat      #NO.FUN-680101  DATE
  CASE g_lang
    WHEN '0'
      LET g_msg ="產生時距檔(buk_tmp)!"
    WHEN '2'
      LET g_msg ="產生時距檔(buk_tmp)!"
    OTHERWISE
      LET g_msg ="Gen. File (buk_tmp)!"
  END CASE
  CALL msg(g_msg)
  DROP TABLE buk_tmp
  CREATE TEMP TABLE buk_tmp(
         real_date LIKE type_file.dat,   
         plan_date LIKE type_file.dat)
  IF STATUS THEN CALL cl_err('create buk_tmp:',STATUS,1) 
      CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
  CASE WHEN buk_type = '1' CALL rpg_buk() RETURN
       WHEN buk_type = '2' LET past_date = bdate-1
       WHEN buk_type = '3' LET past_date = bdate-7
       WHEN buk_type = '4' LET past_date = bdate-10
       WHEN buk_type = '5' LET past_date = bdate-30
       OTHERWISE           LET past_date = bdate-1
  END CASE
  CALL p500_buk_date(past_date) RETURNING past_date
 
# 未來在 QR 查詢時,可以快速歸納新增的訂單資料所屬的時距,
# 因此 default 產生 30 個時距資料
 
  CALL p500_buk_date(bdate) RETURNING d
 
  LET g_i = 1    #  期數
  WHILE TRUE
     CALL p500_buk_date(d) RETURNING d2
     IF d <= edate
        THEN
        INSERT INTO buk_tmp VALUES(d,d2)
     END IF
     IF STATUS THEN CALL err('ins buk_tmp:',STATUS,1) 
      CALL cl_err3("ins","buk_file",d,"",STATUS,"","ins buk",1)   
         CALL cl_batch_bg_javamail("N")  #NO.FUN-570126 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
     SELECT COUNT(distinct mpm_d) INTO g_i FROM mpm_file
      WHERE mpm_v = ver_no
     #IF g_i = 30 THEN EXIT WHILE END IF #CHI-C80048
     LET d = d + 1
     IF d > edate THEN EXIT WHILE END IF #CHI-C80048
  END WHILE
END FUNCTION
 
FUNCTION p500_buk_date(d)
  DEFINE d,d2	LIKE type_file.dat      #NO.FUN-680101  DATE
  DEFINE x	LIKE type_file.chr8     #NO.FUN-680101  VARCHAR(8)
  CASE WHEN buk_type = '3' LET i=weekday(d) IF i=0 THEN LET i=7 END IF
                           LET d2=d-i+1
       WHEN buk_type = '4' LET x = d USING 'yyyymmdd'
                           CASE WHEN x[7,8]<='10' LET x[7,8]='01'
                                WHEN x[7,8]<='20' LET x[7,8]='11'
                                OTHERWISE         LET x[7,8]='21'
                           END CASE
                           LET d2= MDY(x[5,6],x[7,8],x[1,4])
       WHEN buk_type = '5' LET x = d USING 'yyyymmdd'
                           LET x[7,8]='01'
                           LET d2= MDY(x[5,6],x[7,8],x[1,4])
       OTHERWISE           LET d2=d
  END CASE
  IF d <= edate
     THEN
     INSERT INTO mpk_file(mpk_v,mpk_d) VALUES(ver_no, d2)
  END IF
  INSERT INTO mpm_file(mpm_v,mpm_d,mpm_act) VALUES(ver_no, d2, d)
  RETURN d2
END FUNCTION
 
FUNCTION rpg_buk()
  DEFINE l_bucket ARRAY[36] OF LIKE type_file.num5     #NO.FUN-680101  SMALLINT
  DEFINE l_rpg    RECORD LIKE rpg_file.*
  DEFINE dd1,dd2  LIKE type_file.dat      #NO.FUN-680101  DATE
 
  SELECT * INTO l_rpg.* FROM rpg_file WHERE rpg01 = buk_code
  IF STATUS THEN 
  CALL cl_err3("sel","rpg_file",buk_code,"",STATUS,"","sel rpg:",1)   #No.FUN-660108 
   RETURN END IF
 
  LET l_bucket[01]=l_rpg.rpg101 LET l_bucket[02]=l_rpg.rpg102
  LET l_bucket[03]=l_rpg.rpg103 LET l_bucket[04]=l_rpg.rpg104
  LET l_bucket[05]=l_rpg.rpg105 LET l_bucket[06]=l_rpg.rpg106
  LET l_bucket[07]=l_rpg.rpg107 LET l_bucket[08]=l_rpg.rpg108
  LET l_bucket[09]=l_rpg.rpg109 LET l_bucket[10]=l_rpg.rpg110
  LET l_bucket[11]=l_rpg.rpg111 LET l_bucket[12]=l_rpg.rpg112
  LET l_bucket[13]=l_rpg.rpg113 LET l_bucket[14]=l_rpg.rpg114
  LET l_bucket[15]=l_rpg.rpg115 LET l_bucket[16]=l_rpg.rpg116
  LET l_bucket[17]=l_rpg.rpg117 LET l_bucket[18]=l_rpg.rpg118
  LET l_bucket[19]=l_rpg.rpg119 LET l_bucket[20]=l_rpg.rpg120
  LET l_bucket[21]=l_rpg.rpg121 LET l_bucket[22]=l_rpg.rpg122
  LET l_bucket[23]=l_rpg.rpg123 LET l_bucket[24]=l_rpg.rpg124
  LET l_bucket[25]=l_rpg.rpg125 LET l_bucket[26]=l_rpg.rpg126
  LET l_bucket[27]=l_rpg.rpg127 LET l_bucket[28]=l_rpg.rpg128
  LET l_bucket[29]=l_rpg.rpg129 LET l_bucket[30]=l_rpg.rpg130
  LET l_bucket[31]=l_rpg.rpg131 LET l_bucket[32]=l_rpg.rpg132
  LET l_bucket[33]=l_rpg.rpg133 LET l_bucket[34]=l_rpg.rpg134
  LET l_bucket[35]=l_rpg.rpg135 LET l_bucket[36]=l_rpg.rpg136
  LET past_date=bdate-l_rpg.rpg101
  INSERT INTO mpk_file(mpk_v,mpk_d) VALUES(ver_no, past_date)
 
  LET dd1=bdate LET dd2=bdate
  FOR i = 1 TO 36
   FOR j=1 TO l_bucket[i]
     INSERT INTO buk_tmp VALUES (dd1,dd2)
     INSERT INTO mpm_file(mpm_v,mpm_d,mpm_act) VALUES(ver_no, dd2, dd1)
     LET dd1=dd1+1
   END FOR
   INSERT INTO mpk_file(mpk_v,mpk_d) VALUES(ver_no, dd2)
   LET dd2=dd2+l_bucket[i]
  END FOR
END FUNCTION
 
FUNCTION p500_c_part_tmp()			# 找出需 MRP 的料號
  DEFINE l_sql		LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(500)
  DEFINE l_bmb03        LIKE bmb_file.bmb03     #NO.MOD-490217
  DEFINE l_sfa05	LIKE sfa_file.sfa05     #NO.FUN-680101  VARCHAR(20)
  #-------------------------------------------------------- sub_tmp
  DROP TABLE sub_tmp     #No.MOD-820085 add
  CREATE TEMP TABLE sub_tmp(
       sub_partno LIKE ima_file.ima01,    #No.MOD-7A0036 modify
       sub_wo_no  LIKE oea_file.oea01,
       sub_prodno LIKE type_file.chr20, 
       sub_qty    LIKE mps_file.mps062)
  CASE g_lang
    WHEN '0'
      LET g_msg ="找出需 MPS 的料號檔(part_tmp)!"
    WHEN '2'
      LET g_msg ="找出需 MPS 的料號檔(part_tmp)!"
    OTHERWISE
      LET g_msg ="Find   MPS Itm#file(part_tmp)!"
  END CASE
  CALL msg(g_msg)
  #-------------------------------------------------------- part_tmp
  DROP TABLE part_tmp
  CREATE TEMP TABLE part_tmp(
                    partno LIKE ima_file.ima01)    #No.MOD-7A0036 modify
  IF STATUS THEN CALL cl_err('create part_tmp:',STATUS,1) 
      CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
  CREATE UNIQUE INDEX part_tmp_i1 ON part_tmp(partno)
 
  IF STATUS THEN CALL cl_err('index part_tmp:',STATUS,1) #FUN-6A0049
      CALL cl_batch_bg_javamail("N")   #NO.FUN-570126 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
 
  LET l_sql="SELECT DISTINCT ima01",	# 主件
            "  FROM ima_file",
            " WHERE ima139 = 'Y' ",
            "   AND imaacti='Y'",
            "   AND (ima01 MATCHES '",lot_no1,"' OR ",
            "        ima01 MATCHES '",lot_no2,"')"
 #DISPLAY l_sql   #CHI-A70049 mark
  CALL p500_ins_part_tmp(l_sql)
END FUNCTION
 
FUNCTION p500_ins_part_tmp(p_sql)
   DEFINE p_sql   	LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(600)
   DEFINE l_sql   	LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(600)
   DEFINE l_ima08	LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
   DEFINE l_partno	LIKE ima_file.ima01     #NO.MOD-490217
   DEFINE l_ima910      LIKE ima_file.ima910    #FUN-550110
   DEFINE l_cnt1        LIKE type_file.num5     #NO.FUN-680101  SMALLINT  #NO.FUN-5C0041
   DEFINE l_sw_tot      LIKE type_file.num5     #NO.FUN-680101  SMALLINT  #NO.FUN-5C0041
   DEFINE l_count       LIKE type_file.num5     #NO.FUN-680101  SMALLINT  #NO.FUN-5C0041
 
   IF sw = 'N' THEN
       LET l_count = 1
       LET l_sql="SELECT COUNT(*)",
                "  FROM ima_file",
                " WHERE ima139 = 'Y' ",
                "   AND imaacti='Y'",
                "   AND (ima01 MATCHES '",lot_no1,"' OR ",
                "        ima01 MATCHES '",lot_no2,"')"
 
       PREPARE p500_sw_p1 FROM l_sql
       DECLARE p500_sw_c1 CURSOR WITH HOLD FOR p500_sw_p1
       OPEN p500_sw_c1
       FETCH p500_sw_c1 INTO l_sw_tot
 
       IF l_sw_tot > 0 THEN
          IF l_sw_tot > 10 THEN
             LET g_sw = l_sw_tot /10
             CALL cl_progress_bar(10)
          ELSE
             CALL cl_progress_bar(l_sw_tot)
          END IF
       END IF
   END IF
 
   PREPARE p500_ins_tmp_p FROM p_sql
   DECLARE p500_ins_tmp_c CURSOR FOR p500_ins_tmp_p
   LET g_n=0
   FOREACH p500_ins_tmp_c INTO l_partno
     IF STATUS THEN CALL cl_err('ins_tmp_c:',STATUS,1) EXIT FOREACH END IF  #FUN-6A0049
     LET l_cnt1 = l_cnt1+ 1  #NO.FUN-5C0041 ADD
     INSERT INTO part_tmp VALUES(l_partno)
     LET g_n=g_n+1 LET g_x1=g_n USING '&&&&&&'
     IF g_x1[5,6]='00' THEN MESSAGE g_n END IF
     IF lot_bm>0 THEN
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_partno
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        CALL p500_bom1(0,l_partno,l_ima910)  #FUN-550110
     IF sw = 'N' THEN
         IF l_sw_tot > 10 THEN  #筆數合計
             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                 CALL cl_progressing(" ")
             END IF
             IF (l_cnt1 mod g_sw) = 0 AND l_count < 10 THEN
                 CALL cl_progressing(" ")
                 LET l_count = l_count + 1
             END IF
         ELSE
             CALL cl_progressing(" ")
         END IF
     END IF
     END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('ins_tmp_c:',STATUS,1) END IF  #FUN-6A0049
   IF sub_flag='N' THEN RETURN END IF
   DECLARE p500_ins_tmp_c2 CURSOR FOR
     SELECT bmd04 FROM part_tmp, bmd_file, ima_file
           WHERE partno=bmd01 AND bmd04=ima01
             AND imaacti='Y' AND ima139 = 'Y'
             AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
             AND bmdacti = 'Y'                                           #CHI-910021
   FOREACH p500_ins_tmp_c2 INTO l_partno
     IF STATUS THEN CALL cl_err('fore ins_tmp_c2',STATUS,1) EXIT FOREACH END IF
     INSERT INTO part_tmp VALUES(l_partno)
     LET g_n=g_n+1 LET g_x1=g_n USING '&&&&&&'
     IF g_x1[5,6]='00' THEN MESSAGE g_n END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('fore ins_tmp_c2',STATUS,1) END IF

#FUN-A40002 --begin--
 DECLARE p500_ins_tmp_c3 CURSOR FOR 
 SELECT DISTINCT ima01 from ima_file,bon_file,bmb_file,part_tmp
  WHERE imaacti = 'Y' and ima37 = '1' AND ima139 = 'Y'
    AND partno = bon01 
    AND bmb03 = bon01 AND bmb16 = '7'
	  AND (bmb01 = bon02 or bon02 = '*') 
    AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
    AND bonacti = 'Y'
    AND ima251 = bon06
    AND ima022 BETWEEN bon04 AND bon05
    AND ima109 = bon07 
    AND ima54 = bon08 
    AND ima01 != bon01   	
                              
   FOREACH p500_ins_tmp_c3 INTO l_partno
     IF STATUS THEN 
        CALL cl_err('fore ins_tmp_c3',STATUS,1) 
        EXIT FOREACH 
     END IF
     DELETE FROM part_tmp WHERE partno = l_partno
     INSERT INTO part_tmp VALUES(l_partno)
     
     LET g_n=g_n+1 LET g_x1=g_n USING '&&&&&&'
     IF g_x1[5,6]='00' THEN
        CALL ui.Interface.refresh()
     END IF
   END FOREACH
   IF STATUS THEN 
      CALL cl_err('fore ins_tmp_c3',STATUS,1) 
   END IF
#FUN-A40002 --end--   
END FUNCTION
 
FUNCTION p500_bom1(p_level,p_key,p_key2)  #FUN-550110
   DEFINE p_level     LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          p_key       LIKE bma_file.bma01,    #主件料件編號
          p_key2      LIKE ima_file.ima910,   #FUN-550110
          l_ac,i      LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          arrno       LIKE type_file.num5,    #NO.FUN-680101  SMALLINT    #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD          #每階存放資料
              bmb03  LIKE bmb_file.bmb03,     #元件料號
               bma01 LIKE bma_file.bma01      #NO.MOD-490217
          END RECORD,
          l_sql       LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(400)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
        CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    IF p_level > lot_bm THEN RETURN END IF
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01",
               " FROM bmb_file, OUTER bma_file,ima_file",
               " WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01",
               "   AND bmb29 ='",p_key2,"' ",  #FUN-550110
               "   AND bmb03 = ima_file.ima01 AND ima_file.ima139 = 'Y' AND imaacti='Y' " #No:9359
    PREPARE p500_ppp FROM l_sql
    DECLARE p500_cur CURSOR FOR p500_ppp
    LET l_ac = 1
    FOREACH p500_cur INTO sr[l_ac].*  # 先將BOM單身存入BUFFER
       IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) EXIT FOREACH END IF
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
        IF sw = 'Y' THEN
            message p_level,' ',sr[i].bmb03 clipped
            CALL ui.Interface.refresh()
        END IF
        INSERT INTO part_tmp VALUES(sr[i].bmb03)
        IF STATUS THEN CONTINUE FOR END IF
        LET g_n=g_n+1 LET g_x1=g_n USING '&&&&&&'
        IF g_x1[5,6]='00' THEN MESSAGE g_n END IF
        IF sr[i].bma01 IS NOT NULL THEN
           CALL p500_bom1(p_level,sr[i].bmb03,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
FUNCTION p500_mps_0()	# mps_file 歸 0
   LET mps.mps_v =ver_no
   LET mps.mps039=0
   LET mps.mps041=0
   LET mps.mps043=0
   LET mps.mps044=0
   LET mps.mps051=0
   LET mps.mps052=0
   LET mps.mps053=0
   LET mps.mps061=0
   LET mps.mps062=0
   LET mps.mps063=0
   LET mps.mps064=0
   LET mps.mps065=0
   LET mps.mps06_fz=0
   LET mps.mps071=0
   LET mps.mps072=0
   LET mps.mps08 =0
   LET mps.mps09 =0
   LET mps.mps10 ='N'
   LET mps.mps11 =NULL
   LET mps.mps12 = 0
END FUNCTION
 
FUNCTION p500_forcast()
  DEFINE l_opc01  LIKE opc_file.opc01,
         l_opc02  LIKE opc_file.opc02,
         l_opc03  LIKE opc_file.opc03,
         l_opc04  LIKE opc_file.opc04,
         l_opd06  LIKE opd_file.opd06,
         l_opd07  LIKE opd_file.opd07,
         l_opd08  LIKE opd_file.opd08,
         l_opd09  LIKE opd_file.opd09,
         l_opc    RECORD LIKE opc_file.*
 
  IF incl_so = '1' THEN RETURN END IF #需求納入(1.訂單 2.預測 3.取最大)
  DROP TABLE opc_tmp     #No.MOD-820085 add
  CREATE TEMP TABLE opc_tmp(
                            partno   LIKE ima_file.ima01,   #No.MOD-7A0036 modify
                            cus      LIKE opc_file.opc02,
                            plandate LIKE type_file.dat,   
                            sales    LIKE opc_file.opc04,    #MOD-AB0229 type_file.chr8 modify opc_file.opc04  
                            bdate1   LIKE type_file.dat,  #MOD-B50134 bdate modify bdate1 
                            edate1   LIKE type_file.dat,  #MOD-B50134 edate modify edate1 
                            qty1     LIKE mps_file.mps062,
                            qty2     LIKE mps_file.mps062)
 IF STATUS THEN CALL cl_err('create opc_tmp:',STATUS,1) #FUN-6A0049
      CALL cl_batch_bg_javamail("N")    #NO.FUN-570126
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
 #CREATE UNIQUE INDEX opc_tmp_i1 ON opc_tmp(partno,cus,sales,bdate)     #MOD-B50134 mark
  CREATE UNIQUE INDEX opc_tmp_i1 ON opc_tmp(partno,cus,sales,bdate1)    #MOD-B50134 add    
  IF STATUS THEN CALL cl_err('index opc_tmp:',STATUS,1) #FUN-6A0049
      CALL cl_batch_bg_javamail("N")    #NO.FUN-570126
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
 
# 只抓日期小於計劃基準日且最靠近者
   DECLARE p500_opc_c1 CURSOR FOR
      SELECT opc01,opc02,MAX(opc03),opc04
        FROM opc_file,part_tmp
       WHERE opc01=partno
         AND opc03<=forbdate    #計劃日期<=基準日期  #No.FUN-5A0200 add
         AND (opc10 IS NULL OR (opc10 IS NOT NULL AND opc10=buk_code)) #時距代號
        GROUP BY  opc01,opc02,opc04
 
   FOREACH p500_opc_c1 INTO l_opc.opc01,l_opc.opc02,l_opc.opc03,l_opc.opc04
 
      DECLARE p500_opc_c CURSOR FOR
         SELECT opc01,opc02,opc03,opc04,opd06,opd07,opd08,opd09
          FROM opc_file,opd_file
          WHERE opc01=l_opc.opc01
            AND opc02=l_opc.opc02
            AND opc03=l_opc.opc03
            AND opc04=l_opc.opc04
            AND opc01=opd01 AND opc02 = opd02
            AND opc03=opd03 AND opc04 = opd04
            ORDER BY opd06 DESC
 
      FOREACH  p500_opc_c INTO l_opc01,l_opc02,l_opc03,l_opc04,
                               l_opd06,l_opd07,l_opd08,l_opd09
        IF STATUS THEN CALL cl_err('p500_opc_c',STATUS,1) RETURN END IF  #FUN-6A0049
        INSERT INTO opc_tmp VALUES(l_opc01,l_opc02,l_opc03,l_opc04,
                                l_opd06,l_opd07,l_opd08,l_opd09)
       #MOD-B50134---add---start---
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
           UPDATE opc_tmp SET qty1=qty1+l_opd08, qty2=qty2+l_opd09
            WHERE partno=l_opc01 AND cus=l_opc02 AND sales=l_opc04
              AND bdate1=l_opd06
        END IF
       #MOD-B50134---add---end---
      END FOREACH
 
   END FOREACH
END FUNCTION
 
FUNCTION p500_mps039()	#  ---> 預測需求
 DEFINE l_opc02   LIKE opc_file.opc02,
        l_opc03   LIKE opc_file.opc03,
        l_opc04   LIKE opc_file.opc04,
        l_opd06   LIKE opd_file.opd06,
        l_opd07   LIKE opd_file.opd07,
        l_opd08   LIKE opd_file.opd08,
        l_opd09   LIKE opd_file.opd09
 
  IF incl_so = '1' THEN RETURN END IF #需求納入(1.訂單 2.預測 3.取最大)
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps039(彙總預測需求)!"
    WHEN '2'
      LET g_msg ="_mps039(彙總預測需求)!"
    OTHERWISE
      LET g_msg ="_mps039(Sum Forcast)!"
  END CASE
  CALL msg(g_msg)
 
   DECLARE p500_opd_c CURSOR FOR
      SELECT * FROM opc_tmp
 
   CALL p500_mps_0()
   FOREACH p500_opd_c  INTO mps.mps01,l_opc02,l_opc03,l_opc04,
                            l_opd06,l_opd07,l_opd08,l_opd09
     IF STATUS THEN CALL cl_err('p500_opd_c',STATUS,1) RETURN END IF   #FUN-6A0049
     LET mps.mps039 = l_opd08
     IF qty_type = 'Y' THEN LET mps.mps039 = l_opd09 END IF
     LET mps.mps02='-'
     LET mps.mps03=past_date
     IF l_opd06 >= bdate THEN     #No.MOD-540195 mark    #No.FUN-5A0200 add
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=l_opd06
        IF STATUS THEN CONTINUE FOREACH END IF
     ELSE
         CONTINUE FOREACH        #No.MOD-540195 add
 
     END IF
     IF mps.mps039 IS NULL THEN LET mps.mps039=0 END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps039 using mps.mps039,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02    # 廠商
     LET mpt.mpt03=mps.mps03	# 時距日期
     LET mpt.mpt04=l_opd06  	# 實際日期
     LET mpt.mpt05='39'		# 供需類別
     LET mpt.mpt06=l_opc03      # 單號
     LET mpt.mpt061=NULL	# 項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps039	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN 
       CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   
         CALL cl_batch_bg_javamail("N")    #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('p500_opd_c',STATUS,1) RETURN END IF   #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps040()	#  ---> 安全庫存需求
 DEFINE  l_ima01  LIKE ima_file.ima01
 DEFINE  l_ima133 LIKE ima_file.ima133
 
  IF incl_so = '2' THEN RETURN END IF #需求納入(1.訂單 2.預測 3.取最大)
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps040(彙總安全庫存需求)!"
    WHEN '2'
      LET g_msg ="_mps040(彙總安全庫存需求)!"
    OTHERWISE
      LET g_msg ="_mps040(Sum SafeStockReq)!"
  END CASE
  CALL msg(g_msg)
   DECLARE p500_ima27_c CURSOR FOR
      SELECT ima133, ima01, ima27 FROM ima_file,part_tmp
       WHERE ima01=partno AND ima27 > 0
   CALL p500_mps_0()
   FOREACH p500_ima27_c INTO mps.mps01, l_ima01,mps.mps041
     IF STATUS THEN CALL cl_err('p500_ima27_c',STATUS,1) RETURN END IF  #FUN-6A0049
     LET mps.mps02='-'
     LET mps.mps03=past_date
     IF mps.mps041 IS NULL THEN LET mps.mps041=0 END IF
     IF cl_null(mps.mps01) THEN LET mps.mps01 = l_ima01 END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps041 using mps.mps041,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 時距日期
     LET mpt.mpt04=NULL     	# 實際日期
     LET mpt.mpt05='40'		# 供需類別
     LET mpt.mpt06=NULL		# 單號
     LET mpt.mpt061=NULL	# 項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps041	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   #No.FUN-660108
         CALL cl_batch_bg_javamail("N")     #NO.FUN-570126 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
   END FOREACH
   IF STATUS THEN CALL err('p500_ima27_c',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mps041()	# 彙總 獨立需求量
  DEFINE l_rpc02        LIKE rpc_file.rpc02    #NO.FUN-680101  VARCHAR(16)      #No.FUN-550056
  DEFINE l_rpc12	LIKE rpc_file.rpc12    #NO.FUN-680101  DATE
  DEFINE l_ima01        LIKE ima_file.ima01
  DEFINE l_ima133       LIKE ima_file.ima133
 
  IF incl_so = '2' THEN RETURN END IF #需求納入(1.訂單 2.預測 3.取最大)
  IF incl_id = 'N' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps041(受訂量)!"
    WHEN '2'
      LET g_msg ="_mps041(受訂量)!"
    OTHERWISE
      LET g_msg ="_mps041(SumOrdQty.)!"
  END CASE
  CALL msg(g_msg)
  DECLARE p500_rpc_c CURSOR FOR
     SELECT rpc02, rpc01, rpc12, rpc13-rpc131 FROM rpc_file,part_tmp
      WHERE rpc01=partno AND rpc13>rpc131 AND rpc12 <= edate
        AND rpc12 >= bdate               #No.FUN-5A0200 add
        AND rpc18='Y' AND rpc19 !='Y'    #MOD-CC0173 add
 
  CALL p500_mps_0()
  FOREACH p500_rpc_c INTO l_rpc02, l_ima01, l_rpc12, mps.mps041
     IF STATUS THEN CALL err('p500_rpc_c:',STATUS,1) RETURN END IF
     IF mps.mps041 <= 0 OR mps.mps041 IS NULL THEN CONTINUE FOREACH END IF
     SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
     IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
     IF cl_null(l_ima133)
     THEN LET mps.mps01 = l_ima01
     ELSE LET mps.mps01 = l_ima133
     END IF
     LET mps.mps02='-'
     LET mps.mps03=past_date
     IF l_rpc12 >= bdate THEN
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=l_rpc12
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
      END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps041 using mps.mps041,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 日期
     LET mpt.mpt04=l_rpc12	# 日期
     LET mpt.mpt05='41'		# 供需類別
     LET mpt.mpt06=l_rpc02	# 單號
     LET mpt.mpt061=NULL	# 項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps041	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
        CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   
         CALL cl_batch_bg_javamail("N")    # NO.FUN-570126
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
        EXIT PROGRAM 
     END IF
  END FOREACH
  IF STATUS THEN CALL cl_err('p500_rpc_c:',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps042()	# 彙總 受訂量
  DEFINE l_ima01        LIKE ima_file.ima01
  DEFINE l_ima133       LIKE ima_file.ima133
  DEFINE l_ima910       LIKE ima_file.ima910   #FUN-550110
 
  IF incl_so = '2' THEN RETURN END IF #需求納入(1.訂單 2.預測 3.取最大)
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps042(彙總受訂量)!"
    WHEN '2'
      LET g_msg ="_mps042(彙總受訂量)!"
    OTHERWISE
      LET g_msg ="_mps042(SumOrdQty.)!"
  END CASE
  CALL msg(g_msg)
 
 
 DECLARE p500_mpg_c CURSOR FOR
     SELECT oeb01,oeb03,oeb04,oeb15,(oeb12-oeb24)*oeb05_fac
       FROM oeb_file,part_tmp,oea_file
      WHERE oea01 = oeb01
        AND oeaconf = 'Y'
        AND oea00<>'0'           
        AND oeb04 = partno    
        AND oeb15 <= edate AND oeb15 >= bdate
        AND oeb70 != 'Y'                   
 
  CALL p500_mps_0()
  FOREACH p500_mpg_c INTO g_oeb01, g_oeb03, l_ima01, g_oeb15, mps.mps041
     IF STATUS THEN CALL cl_err('p500_mpg_c:',STATUS,1) RETURN END IF  #FUN-6A0049
     IF mps.mps041 <= 0 OR mps.mps041 IS NULL THEN CONTINUE FOREACH END IF
     SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
     IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
     IF cl_null(l_ima133)
     THEN LET mps.mps01 = l_ima01
     ELSE LET mps.mps01 = l_ima133
     END IF
     LET mps.mps02='-'
     LET mps.mps03=past_date
     IF g_oeb15 >= bdate THEN
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=g_oeb15
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps041 using mps.mps041,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 時距日期
     LET mpt.mpt04=g_oeb15	# 實際日期
     LET mpt.mpt05='42'		# 供需類別
     LET mpt.mpt06=g_oeb01	# 單號
     LET mpt.mpt061=g_oeb03     #項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps041	# 數量
     LET mpt.mptplant = mps.mpsplant    #TQC-AB0112
     LET mpt.mptlegal = mps.mpslegal    #TQC-AB0112
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
        CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
 
     LET l_ima910=''
     SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=msb.msb03
     IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
     LET g_eff_date=forbdate
     #--
     #-->展開至尾階取MPS 料件產生需求
 
  END FOREACH
  IF STATUS THEN CALL cl_err('p500_mpg_c:',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps042_bom(p_level,p_key,p_key2,p_qty)  #FUN-550110
   DEFINE p_level     LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          p_key       LIKE bma_file.bma01,    #主件料件編號
          p_key2      LIKE ima_file.ima910,   #FUN-550110
          p_qty       LIKE bmb_file.bmb06,    #NO.FUN-680101  DEC(18,6)
          l_bmb01     LIKE bmb_file.bmb01,
          l_ac,i      LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          arrno       LIKE type_file.num5,    #NO.FUN-680101  SMALLINT    #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD          #每階存放資料
              bmb03     LIKE bmb_file.bmb03,       #元件料號
              bmb06     LIKE bmb_file.bmb06,       #FUN-560230
              bmb18     LIKE bmb_file.bmb18,       #投料時距
              bmb10_fac LIKE bmb_file.bmb10_fac,
              bma01     LIKE bma_file.bma01
          END RECORD,
          l_ima133    LIKE ima_file.ima133,
          l_ima139    LIKE ima_file.ima139,
          l_ima08     LIKE ima_file.ima08,
          l_ima59     LIKE ima_file.ima59,
          l_ima60     LIKE ima_file.ima60,
          l_ima601    LIKE ima_file.ima601,    #No.FUN-840194 
          l_ima61     LIKE ima_file.ima61,
          l_ima50     LIKE ima_file.ima50,
          l_ima48     LIKE ima_file.ima48,
          l_ima49     LIKE ima_file.ima49,
          l_ima491    LIKE ima_file.ima491,
          l_leadtime  LIKE ima_file.ima50,
          l_needate   LIKE type_file.dat,     #NO.FUN-680101  DATE
          l_sql       LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(400)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
        CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1 IF p_level > lot_bm THEN RETURN END IF
    LET arrno = 600
 
    DECLARE p500_42_c1 CURSOR FOR
          SELECT bmb03,(bmb06/bmb07),bmb18,bmb10_fac,bma01
            FROM bmb_file, OUTER bma_file
           WHERE bmb01=p_key AND bmb_file.bmb03=bma_file.bma01
             AND bmb29=p_key2  #FUN-550110
             AND bmb04<=g_eff_date AND (bmb05 IS NULL OR bmb05>g_eff_date)
    LET l_ac = 1
    FOREACH p500_42_c1 INTO sr[l_ac].*
       IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) EXIT FOREACH END IF
       LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
        IF sw = 'Y' THEN
            message p_level,' ',sr[i].bmb03 clipped
            CALL ui.Interface.refresh()
        END IF
        SELECT ima133,ima139 INTO l_ima133,l_ima139 FROM ima_file
                            WHERE ima01 = sr[i].bmb03
        IF l_ima139 ='Y' THEN
           LET mps.mps03=past_date
           SELECT ima08,ima59,ima60,ima601,ima61,ima50,ima48,ima49,ima491 #No.FUN-840194 add ima601 #CHI-810015 拿掉,ima56   #FUN-710073 add ima56   
             INTO l_ima08,l_ima59,l_ima60,l_ima601,l_ima61,  #No.FUN-840194 add ima601                      
                  l_ima50,l_ima48,l_ima49,l_ima491                    #CHI-810015 拿掉,l_ima56 #FUN-710073 add l_ima56
             FROM ima_file WHERE ima01 = sr[i].bmb03
           IF cl_null(l_ima59)  THEN LET l_ima59 = 0 END IF
           IF cl_null(l_ima60)  THEN LET l_ima60 = 0 END IF
           IF cl_null(l_ima61)  THEN LET l_ima61 = 0 END IF
           IF cl_null(l_ima50)  THEN LET l_ima50 = 0 END IF
           IF cl_null(l_ima48)  THEN LET l_ima48 = 0 END IF
           IF cl_null(l_ima49)  THEN LET l_ima49 = 0 END IF
           IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
 
           IF l_ima08='M' THEN
              LET l_leadtime=l_ima59+l_ima60/l_ima601*sr[i].bmb06+l_ima61  #CHI-810015 mark還原  #No.FUN-840194 
           ELSE 
              LET l_leadtime=l_ima50+l_ima48+l_ima49+l_ima491
           END IF
           LET l_needate =g_oeb15 -l_ima50	# 減採購/製造前置日數
           IF l_needate >= bdate THEN
              SELECT plan_date INTO mps.mps03 FROM buk_tmp
                               WHERE real_date=l_needate
              IF STATUS THEN RETURN END IF
           END IF
 
           IF cl_null(mps.mps03) THEN 
               LET mps.mps03 = g_today
           END IF
           LET mps.mpsplant = g_plant  #FUN-980005 add
           LET mps.mpslegal = g_legal  #FUN-980005 add
           INSERT INTO mps_file VALUES(mps.*)
           IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
              CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
           END IF
           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
              EXECUTE p500_p_upd_mps046 using sr[i].bmb06,mps.mps_v,mps.mps01,
                                              mps.mps02,mps.mps03
              IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
           END IF
 
           LET mpt.mpt_v=mps.mps_v	# 版本
           LET mpt.mpt01=sr[i].bmb03    #料號
           LET mpt.mpt02=mps.mps02	# 廠商
           LET mpt.mpt03=mps.mps03	# 時距日期
           LET mpt.mpt04=l_needate      # 需求日期
           LET mpt.mpt05='46'		# 供需類別
           LET mpt.mpt06=g_oeb01	# 單號
           LET mpt.mpt061=g_oeb03	# 項次
           LET mpt.mpt06_fz=NULL	# 凍結否
           LET mpt.mpt07=mps.mps01      # 索料號(上階半/成品)
           LET mpt.mpt08=sr[i].bmb06    # 數量
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
           IF STATUS THEN  
              CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   
               CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM 
           END IF
        END IF
        IF sr[i].bma01 IS NOT NULL THEN #若為主件
           CALL p500_mps042_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06) #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
FUNCTION p500_mps043()	# 彙總 計劃量 (MPS計劃 下階料)
  DEFINE l_ima59,l_ima60,l_ima61 LIKE ima_file.ima60     #NO.FUN-680101  DEC(9,3)
  DEFINE l_ima08	         LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
  DEFINE l_ima910                LIKE ima_file.ima910    #FUN-550110
  DEFINE l_ima601                LIKE ima_file.ima601    #FUN-840194
  DEFINE li_result               LIKE type_file.num5     #CHI-690066 add
 
  IF msb_expl='N' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps043(彙總MPS計劃 下階料需求量)!"
    WHEN '2'
      LET g_msg ="_mps043(彙總MPS計劃 下階料需求量)!"
    OTHERWISE
      LET g_msg ="_mps043(Sum MPSPrj  LowCdRequQty)!"
  END CASE
  CALL msg(g_msg)
  DECLARE p500_msb_c CURSOR FOR
     SELECT msb_file.*,ima59,ima60,ima601,ima61  #No.FUN-840194 add ima601        #CHI-810015 拿掉,ima56   #FUN-710073 add ima56
       FROM msb_file,msa_file,OUTER ima_file
      WHERE msa01=mps_msa01
        AND msa03='N'
        AND msb01=msa01
        AND msb04 <= medate AND msb04 >= mbdate
         AND msb_file.msb03=ima_file.ima01
  CALL p500_mps_0()
  FOREACH p500_msb_c INTO msb.*, l_ima59,l_ima60,l_ima601,l_ima61 #No.FUN-840194 add l_ima601  #CHI-810015拿掉,l_ima56   #FUN-710073 add l_ima56 
     IF STATUS THEN CALL cl_err('p500_msb_c:',STATUS,1) RETURN END IF  #FUN-6A0049
 
     IF l_ima60 IS NULL THEN LET l_ima60=0 END IF
     IF l_ima61 IS NULL THEN LET l_ima61=0 END IF
 
     IF cl_null(g_argv1) THEN
        MESSAGE msb.msb01 CLIPPED,' ',msb.msb02
     END IF
     SELECT SUM(sfb08) INTO g_qty FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02 AND sfb87!='X'
        AND sfb02!='15'   #FUN-660110 add
     IF g_qty IS NULL THEN LET g_qty=0 END IF
     LET g_nopen = msb.msb05 - g_qty
     IF g_nopen <= 0 THEN CONTINUE FOREACH END IF
     LET msb.msb04=msb.msb04-(l_ima59+l_ima60/l_ima601*msb.msb05+l_ima61) #No.FUN-840194 #CHI-810015 mark還原 # 推出開工日
     FOR g_i=1 TO 365
         LET li_result = 0
         CALL s_daywk(msb.msb04) RETURNING li_result
         IF li_result = 1 THEN   #0:非工作日 1:工作日 2:無資料 
            EXIT FOR
         ELSE
            LET msb.msb04=msb.msb04-1  #向前一天
         END IF
     END FOR
     LET g_eff_date=msb.msb07
 
     LET l_ima910=''
     SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=msb.msb03
     IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
     CALL p500_mps044_bom('43',0,msb.msb03,l_ima910,g_nopen)  #FUN-550110
  END FOREACH
END FUNCTION
 
FUNCTION p500_mps043_ins()
       IF cl_null(mps.mps02) THEN LET mps.mps02='-' END IF
       LET mps.mps03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
       LET needdate=msb.msb04 + bmb.bmb18
       IF needdate >= bdate THEN
          SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       IF cl_null(mps.mps03) THEN 
           LET mps.mps03 = g_today
       END IF
       LET mps.mpsplant = g_plant  #FUN-980005 add
       LET mps.mpslegal = g_legal  #FUN-980005 add
       INSERT INTO mps_file VALUES(mps.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
        CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
         END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps043 using mps.mps043,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
       END IF
       LET mpt.mpt_v=mps.mps_v	# 版本
       LET mpt.mpt01=mps.mps01	# 料號
       LET mpt.mpt02=mps.mps02	# 廠商
       LET mpt.mpt03=mps.mps03	# 日期
       LET mpt.mpt04=needdate	# 日期
       LET mpt.mpt05='43'	# 供需類別
       LET mpt.mpt06=msb.msb01	# 單號
       LET mpt.mpt061=msb.msb02	# 項次
       LET mpt.mpt06_fz=NULL	# 凍結否
       LET mpt.mpt07=msb.msb03	# 追索料號(上階半/成品)
       LET mpt.mpt08=mps.mps043	# 數量
       LET mpt.mptplant=g_plant   #FUN-980005 add
       LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
       IF STATUS THEN  
          CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   
           CALL cl_batch_bg_javamail("N")   #NO.FUN-570126 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM 
       END IF
END FUNCTION
 
FUNCTION p500_mps044()	# 彙總 備料量
   DEFINE l_qty	     LIKE mps_file.mps062   #NO.FUN-680101  DEC(15,3)
   DEFINE l_sfa29    LIKE sfa_file.sfa29
   DEFINE l_ima01    LIKE ima_file.ima01
   DEFINE l_ima133   LIKE ima_file.ima133
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
 
     #注意: sfa_file 應增加限定廠商欄位 (sfa31)(儲位), 於備料產生時賦予
     CASE g_lang
       WHEN '0'
         LET g_msg ="_mps044(彙總備料量)!"
       WHEN '2'
         LET g_msg ="_mps044(彙總備料量)!"
       OTHERWISE
         LET g_msg ="_mps044(Sum BakQty)!"
     END CASE
     CALL msg(g_msg)
     #工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領
     #若 A  < 0 ,則 LET A = 0,同amrp500 之計算邏輯
     #----------------------------------------------------------------------
     DECLARE p500_sfa_c1 CURSOR FOR		#以sfa27計劃 (非sfa03)
       #SELECT sfb01,sfa27,sfa31,sfb13,((sfa05-sfa06-sfa065+sfa063-sfa062)*sfa13),sfb05,sfa29   #MOD-850310     #No.TQC-A40069
        SELECT sfb01,sfa03,sfa31,sfb13,((sfa05-sfa06-sfa065+sfa063-sfa062)*sfa13),sfb05,sfa29   #MOD-850310     #No.TQC-A40069
          FROM sfb_file,sfa_file,part_tmp
        #WHERE sfb01=sfa01 AND sfa27=partno                         #No.TQC-A40069
         WHERE sfb01=sfa01 AND sfa03=partno                         #No.TQC-A40069
           AND sfb04!='8' AND sfb13<=edate AND sfb13 >=bdate        #No.FUN-5A0200 add
           AND sfa05>sfa06+sfa065 AND sfb23='Y'  AND sfb87!='X'#已備料工單 (取備料檔)
           AND sfb02!='15'   #FUN-660110 add
     CALL p500_mps_0()
     FOREACH p500_sfa_c1 INTO g_sfa01,l_ima01,mps.mps02,g_sfb13,mps.mps044,
                              g_sfb05,l_sfa29
       IF STATUS THEN CALL cl_err('p500_sfa_c1',STATUS,1) RETURN END IF  #FUN-6A0049
       IF mps.mps044 < 0  THEN LET mps.mps044=0 END IF                   #MOD-850310 add
       IF cl_null(g_argv1) THEN
          MESSAGE g_sfa01 CLIPPED
       END IF
       IF l_sfa29 != g_sfb05 THEN LET g_sfb05 = l_sfa29 END IF
       SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
       IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
       IF cl_null(l_ima133)
       THEN LET mps.mps01 = l_ima01
       ELSE LET mps.mps01 = l_ima133
       END IF
       CALL p500_mps044_ins()
     END FOREACH
     IF STATUS THEN CALL cl_err('p500_sfa_c1',STATUS,1) RETURN END IF   #FUN-6A0049
     DECLARE p500_sfa_c2 CURSOR FOR
        SELECT sfb01,sfb13,sfb08,sfb05,sfb071
          FROM sfb_file
         WHERE sfb04!='8' AND sfb13<=edate AND sfb13 >=bdate      #No.FUN-5A0200 add
           AND sfb23='N'   AND sfb87!='X'               #未備料工單(取BOM檔)
           AND sfb02!='15'   #FUN-660110 add
     CALL p500_mps_0()
     FOREACH p500_sfa_c2 INTO g_sfa01,g_sfb13,l_qty,g_sfb05,g_eff_date
       IF STATUS THEN CALL cl_err('p500_sfa_c2',STATUS,1) RETURN END IF  #FUN-6A0049
       IF cl_null(g_argv1) THEN MESSAGE g_sfa01 CLIPPED END IF
       LET l_ima910=''
       SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=g_sfb05
       IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
       CALL p500_mps044_bom('44',0,g_sfb05,l_ima910,l_qty)  #FUN-550110
     END FOREACH
     IF STATUS THEN CALL cl_err('p500_sfa_c2',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
#No.FUN-A70034  --Begin
FUNCTION p500_mps044_bom(p_sw,p_level,p_key,p_key2,p_qty)  #FUN-550110
   DEFINE l_total     LIKE sfa_file.sfa05
   DEFINE l_QPA       LIKE bmb_file.bmb06
   DEFINE l_ActualQPA LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
   DEFINE p_sw	      LIKE mps_file.mps_v,    #NO.FUN-680101  VARCHAR(2)   # 43:mps043 44:mps044
          p_level     LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          p_key       LIKE bma_file.bma01,    #主件料件編號
          p_key2      LIKE ima_file.ima910,   #FUN-550110
          p_qty       LIKE bmb_file.bmb06,    #NO.FUN-680101  DEC(18,6)
          l_bmb01     LIKE bmb_file.bmb01,
          l_ac,i      LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          arrno       LIKE type_file.num5,    #NO.FUN-680101  SMALLINT  #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD          #每階存放資料
              bmb03 LIKE bmb_file.bmb03,      #元件料號
              bml04 LIKE bml_file.bml04,      #指定廠牌
              bmb06 LIKE bmb_file.bmb06,      #FUN-560230
              bmb18 LIKE bmb_file.bmb18,      #投料時距
              ima08 LIKE type_file.chr1,      #NO.FUN-680101  VARCHAR(01)
              bmb10_fac LIKE bmb_file.bmb10_fac,
              ima55     LIKE ima_file.ima55,
              ima133    LIKE ima_file.ima133,
              bmb10     LIKE bmb_file.bmb10,
              #No.FUN-A70034  --Begin
              bmb08     LIKE bmb_file.bmb08,
              bmb081    LIKE bmb_file.bmb081,
              bmb082    LIKE bmb_file.bmb082
              #No.FUN-A70034  --End  
          END RECORD,
          l_sql       LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(400)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
        CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1 IF p_level > lot_bm THEN RETURN END IF
    LET arrno = 600
 DECLARE p500_44_c1 CURSOR FOR
   #No.FUN-A70034  --Begin
   #SELECT bmb03,bml04,bmb06/bmb07*(1+bmb08/100),bmb18,ima08,bmb10_fac,
   #      ima55,ima133,bmb10
   SELECT bmb03,bml04,bmb06/bmb07,bmb18,ima08,bmb10_fac,
          ima55,ima133,bmb10,bmb08,bmb081,bmb082
   #No.FUN-A70034  --End  
     FROM ima_file, bmb_file LEFT OUTER JOIN bml_file ON bmb03 = bml01 AND bmb01 = bml02 AND bml03= qvl_bml03
    WHERE bmb01=p_key AND bmb03=ima01 AND ima139 = 'Y'
      AND bmb04<=g_eff_date AND (bmb05 IS NULL OR bmb05>g_eff_date)
    UNION
   #No.FUN-A70034  --Begin
   #SELECT bmb03,bml04,bmb06/bmb07*(1+bmb08/100),bmb18,ima08,bmb10_fac,
   #      ima55,ima133,bmb10
   SELECT bmb03,bml04,bmb06/bmb07,bmb18,ima08,bmb10_fac,
          ima55,ima133,bmb10,bmb08,bmb081,bmb082
   #No.FUN-A70034  --End  
     FROM bmb_file, ima_file, bml_file
    WHERE bmb01=p_key AND bmb03=ima01 AND ima139 = 'Y'
      AND bmb04<=g_eff_date AND (bmb05 IS NULL OR bmb05>g_eff_date)
      AND (bmb03=bml01 AND bml02='ALL' AND bml03=qvl_bml03)
 LET l_ac = 1  
    FOREACH p500_44_c1 INTO sr[l_ac].*
             # 先將BOM單身存入BUFFER
       IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) EXIT FOREACH END IF
       IF not cl_null(sr[l_ac].ima133) THEN
          LET sr[l_ac].bmb03 = sr[l_ac].ima133
       END IF
       #No.FUN-A70034  --Begin
       #LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       #No.FUN-A70034  --End  
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
       IF sw = 'Y' THEN
           message p_level,' ',sr[i].bmb03 clipped
           CALL ui.Interface.refresh()
       END IF
       #No.FUN-A70034  --Begin
       CALL cralc_rate(p_key,sr[i].bmb03,p_qty,sr[i].bmb081,sr[i].bmb08,sr[i].bmb082,
                       sr[i].bmb06,0)
            RETURNING l_total,l_QPA,l_ActualQPA
       LET sr[i].bmb06=l_total
       #No.FUN-A70034  --End  
       IF sr[i].ima08='X' THEN
           CALL p500_mps044_bom(p_sw,p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06)  #FUN-8B0035
       ELSE
               SELECT partno FROM part_tmp WHERE partno=sr[i].bmb03
               IF STATUS THEN CONTINUE FOR END IF
               LET mps.mps01=sr[i].bmb03
               LET mps.mps02='-'
 
               LET bmb.bmb18=sr[i].bmb18
               IF cl_null(sr[i].bmb10_fac) THEN  LET sr[i].bmb10_fac=1 END IF
               IF p_sw='43' THEN
# -(統一單位為庫存單位)-------
                       LET mps.mps043=sr[i].bmb06 * sr[i].bmb10_fac
                       CALL p500_mps043_ins()
               ELSE
# -(統一單位為庫存單位)-------
                       LET mps.mps044=sr[i].bmb06 * sr[i].bmb10_fac
                       CALL p500_mps044_ins()
               END IF
       END IF
    END FOR
END FUNCTION
 
FUNCTION p500_mps044_ins()
       IF cl_null(mps.mps02) THEN LET mps.mps02='-' END IF
       LET mps.mps03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
       LET needdate=g_sfb13 + bmb.bmb18
       IF needdate >= bdate THEN
          SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       IF cl_null(mps.mps03) THEN 
           LET mps.mps03 = g_today
       END IF
       LET mps.mpsplant = g_plant  #FUN-980005 add
       LET mps.mpslegal = g_legal  #FUN-980005 add
       INSERT INTO mps_file VALUES(mps.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
       CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
       END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
          EXECUTE p500_p_upd_mps044 using mps.mps044,mps.mps_v,mps.mps01,
                                          mps.mps02,mps.mps03
          IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
       END IF
       LET mpt.mpt_v=mps.mps_v	# 版本
       LET mpt.mpt01=mps.mps01	# 料號
       LET mpt.mpt02=mps.mps02	# 廠商
       LET mpt.mpt03=mps.mps03	# 日期
       LET mpt.mpt04=needdate	# 日期
       LET mpt.mpt05='44'	# 供需類別
       LET mpt.mpt06=g_sfa01	# 單號
       LET mpt.mpt061=NULL	# 項次
       LET mpt.mpt06_fz=NULL	# 凍結否
       LET mpt.mpt07=g_sfb05	# 追索料號(上階半/成品)
       LET mpt.mpt08=mps.mps044	# 數量
       LET mpt.mptplant=g_plant   #FUN-980005 add
       LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
       IF STATUS THEN  
          CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt:",1)   
           CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM 
       END IF
END FUNCTION
 
FUNCTION p500_c_part_tmp2()		# 找出需 MRP 的料號+廠商
  CASE g_lang
    WHEN '0'
      LET g_msg ="找出需 MRP 的料號+廠商!"
    WHEN '2'
      LET g_msg ="找出需 MRP 的料號+廠商!"
    OTHERWISE
      LET g_msg ="Find   MRP Itm#+FactNo!"
  END CASE
  CALL msg(g_msg)
  DROP TABLE part_tmp2
  CREATE TEMP TABLE part_tmp2(
         partno LIKE ima_file.ima01,      #No.MOD-7A0036 modify
         ven_no LIKE mps_file.mps02)
  IF STATUS THEN CALL cl_err('create part_tmp2:',STATUS,1)  #FUN-6A0049
      CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
  CREATE UNIQUE INDEX part_tmp2_i1 ON part_tmp2(partno,ven_no)
  IF STATUS THEN CALL cl_err('index part_tmp2:',STATUS,1)   #FUN-6A0049
      CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
  END IF
  INSERT INTO part_tmp2
         SELECT DISTINCT mps01,mps02 FROM mps_file
          WHERE mps_v=ver_no
            AND mps01 IS NOT NULL AND mps02 IS NOT NULL AND mps02 <> '-'
END FUNCTION

#FUN-A40002 --begin-- 
#FUNCTION p500_c_part_tmp3()		# 找出有替代的正料號+替代料號+替代量
#   DEFINE l_mpt01       LIKE mpt_file.mpt01  #NO.MOD-490217
#   DEFINE l_mpt07	LIKE mpt_file.mpt07  #NO.MOD-490217
#  CASE g_lang
#    WHEN '0'
#      LET g_msg ="找出有替代的正料號+替代料號+替代量!"
#    WHEN '2'
#      LET g_msg ="找出有替代的正料號+替代料號+替代量!"
#    OTHERWISE
#      LET g_msg ="Find has ChgNo By Itm#+ChgNo+ChgQty!"
#  END CASE
#  CALL msg(g_msg)
# DROP TABLE QOH_used
#  CREATE TEMP TABLE QOH_used (
#                 partno LIKE ima_file.ima01,     #No.MOD-7A0036 modify
#                 loc_no LIKE type_file.chr20)
#  IF STATUS THEN CALL cl_err('create QOH_used:',STATUS,1)   #FUN-6A0049
#      CALL cl_batch_bg_javamail("N")  #NO.FUN-570126
#      EXIT PROGRAM 
#  END IF
#  CREATE UNIQUE INDEX QOH_used_i1 ON QOH_used(partno)
#  IF STATUS THEN CALL cl_err('index QOH_used:',STATUS,1)  #FUN-6A0049
#      CALL cl_batch_bg_javamail("N")  #NO.FUN-570126
#      EXIT PROGRAM 
#  END IF
#  DROP TABLE part_tmp3
#  CREATE TEMP TABLE part_tmp3(
#         partno LIKE ima_file.ima01,     #No.MOD-7A0036 modify
#         sub_no LIKE ima_file.ima01,     #No.MOD-7A0036 modify
#         sub_qty LIKE mps_file.mps062)   #No.MOD-7A0036 modify
# IF STATUS THEN CALL cl_err('create part_tmp3:',STATUS,1)   #FUN-6A0049
#      CALL cl_batch_bg_javamail("N")  #NO.FUN-570126
#      EXIT PROGRAM 
#  END IF
#  CREATE UNIQUE INDEX part_tmp3_i1 ON part_tmp3(partno,sub_no)
#  IF STATUS THEN CALL cl_err('index part_tmp3:',STATUS,1) EXIT PROGRAM END IF  #FUN-6A0049
#  DECLARE p500_tmp3_c CURSOR FOR
#          SELECT DISTINCT mpt01,mpt07 FROM mpt_file
#                 WHERE mpt_v=ver_no
#                   AND mpt05 IN ('43','44') AND mpt02='-'
#  FOREACH p500_tmp3_c INTO l_mpt01,l_mpt07
#    IF STATUS THEN CALL cl_err('p500_tmp3_c:',STATUS,1) RETURN END IF  #FUN-6A0049
#       INSERT INTO part_tmp3
#            SELECT DISTINCT bmd01,bmd04,bmd07 FROM bmd_file,bmb_file
#              WHERE bmd01=l_mpt01 {AND bmd08='ALL'}
#                AND bmb03=l_mpt01 AND bmb01=l_mpt07  AND bmb16 IN ('1','2')
#                AND bmdacti = 'Y'                                           #CHI-910021
#       IF STATUS THEN 
#          CALL cl_err3("ins","part_tmp3",l_mpt01,l_mpt07,STATUS,"","ins part_tmp3",1)   
#       END IF
#  END FOREACH
#  IF STATUS THEN CALL cl_err('p500_tmp3_c:',STATUS,1) RETURN END IF  #FUN-6A0049
#  DROP TABLE x
#  SELECT DISTINCT partno,sub_no,sub_qty FROM part_tmp3 INTO TEMP x
#  DELETE FROM part_tmp3
#  INSERT INTO part_tmp3 SELECT * FROM x	#隱藏問題:同料但不同替量時,會有多筆tmp
#  IF STATUS THEN CALL cl_err('ins3part_tmp3',STATUS,1)  #FUN-6A0049
#      CALL cl_batch_bg_javamail("N")  #NO.FUN-570126
#      EXIT PROGRAM 
#  END IF
#END FUNCTION
#FUN-A40002 --end--
 
FUNCTION p500_mps051()	#  ---> 庫存量
   DEFINE l_img02	 LIKE ima_file.ima02    #NO.FUN-680101  VARCHAR(10)
   DEFINE l_img03	 LIKE ima_file.ima03    #NO.FUN-680101  VARCHAR(10)
   DEFINE l_ima01        LIKE ima_file.ima01
   DEFINE l_ima133       LIKE ima_file.ima133
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps051(彙總庫存量)!"
    WHEN '2'
      LET g_msg ="_mps051(彙總庫存量)!"
    OTHERWISE
      LET g_msg ="_mps051(Sum StkQty)!"
  END CASE
  CALL msg(g_msg)
   DECLARE p500_img_c1 CURSOR FOR
      SELECT img01, img02, img03, SUM(img10*img21) FROM img_file,part_tmp   #MOD-940312
       WHERE img01=partno {AND img10 > 0} AND img24='Y'
         GROUP BY  img01, img02, img03
   CALL p500_mps_0()
   FOREACH p500_img_c1 INTO mps.mps01, l_img02, l_img03, mps.mps051
     IF STATUS THEN CALL cl_err('p500_img_c1',STATUS,1) RETURN END IF  #FUN-6A0049
 
     LET l_ima01 = mps.mps01
 
     SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
     IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
     IF cl_null(l_ima133)
     THEN LET mps.mps01 = l_ima01
     ELSE LET mps.mps01 = l_ima133
     END IF
 
     LET mps.mps02='-'
 
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mps.mps01 AND ven_no=mps.mps02
     IF i = 0 THEN LET mps.mps02='-' END IF
     IF cl_null(mps.mps02) THEN LET mps.mps02='-' END IF
     LET mps.mps03=past_date
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps051 using mps.mps051,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 時距日期
     LET mpt.mpt04=NULL     	# 實際日期
     LET mpt.mpt05='51'		# 供需類別
     LET mpt.mpt06=l_img02 CLIPPED,' ',l_img03	# 單號
     LET mpt.mpt061=NULL	# 項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps051	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)   #No.FUN-660108
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
   END FOREACH
   IF STATUS THEN CALL err('p500_img_c1',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mps052()	#  ---> 在驗量
   DEFINE l_rvb01       LIKE rvb_file.rvb01      #NO.FUN-680101  VARCHAR(16)   #No.FUN-550056
   DEFINE l_rvb02	LIKE type_file.num5      #NO.FUN-680101  SMALLINT
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_ima133      LIKE ima_file.ima133
   DEFINE l_pmn09       LIKE pmn_file.pmn09     #採購單位/料件庫存單位的轉換率
   DEFINE l_pmn38       LIKE pmn_file.pmn38     #MPS/MRP可用   #FUN-690047 add
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps051(彙總在驗量)!"
    WHEN '2'
      LET g_msg ="_mps051(彙總在驗量)!"
    OTHERWISE
      LET g_msg ="_mps051(Sum QC Qty)!"
  END CASE
  CALL msg(g_msg)
   DECLARE p500_rvb_c1 CURSOR FOR
      SELECT rvb01,rvb02,rvb05, rva05, rvb31,pmn09,pmn38   #FUN-690047 add pmn38
        FROM rvb_file,rva_file,part_tmp,OUTER pmn_file
       WHERE rvb05=partno AND rvb31>0 AND rvb01=rva01 AND rvaconf <> 'X'
         AND rvb_file.rvb04=pmn_file.pmn01
         AND rvb_file.rvb03=pmn_file.pmn02
   CALL p500_mps_0()
   FOREACH p500_rvb_c1 INTO l_rvb01,l_rvb02,
                            l_ima01,mps.mps02,mps.mps052,l_pmn09,l_pmn38   #FUN-690047 add l_pmn38
     IF STATUS THEN CALL err('p500_rvb_c1',STATUS,1) RETURN END IF
     IF l_pmn38!='Y' THEN CONTINUE FOREACH END IF   #FUN-690047 add
     LET mps.mps02='-'
 
     SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
     IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
     IF cl_null(l_ima133)
     THEN LET mps.mps01 = l_ima01
     ELSE LET mps.mps01 = l_ima133
     END IF
 
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mps.mps01 AND ven_no=mps.mps02
     IF i = 0 THEN LET mps.mps02='-' END IF
     IF cl_null(mps.mps02) THEN LET mps.mps02='-' END IF
 
     IF cl_null(l_pmn09) THEN LET l_pmn09=1 END IF
     LET mps.mps052=mps.mps052*l_pmn09
 
     LET mps.mps03=past_date
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
      END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps052 using mps.mps052,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 日期
     LET mpt.mpt04=NULL     	# 日期
     LET mpt.mpt05='52'		# 供需類別
     LET mpt.mpt06=l_rvb01	# 單號
     LET mpt.mpt061=l_rvb02	# 項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps052	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)  
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('p500_rvb_c1',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps061()	# 彙總 請購量
  DEFINE l_pml01        LIKE pml_file.pml01   #NO.FUN-680101  VARCHAR(16)      #No.FUN-550056
  DEFINE l_pml02	LIKE pml_file.pml02   #NO.FUN-680101  SMALLINT
  DEFINE l_pml33	LIKE pml_file.pml33   #NO.FUN-680101  DATE
  DEFINE l_pmk05	LIKE pmk_file.pmk05   #NO.FUN-680101  VARCHAR(10)
  DEFINE l_pmk25	LIKE pmk_file.pmk25   #NO.FUN-680101  VARCHAR(1)
  DEFINE l_pml09	LIKE pml_file.pml09
  DEFINE l_ima01	LIKE ima_file.ima01
  DEFINE l_ima133	LIKE ima_file.ima133
 
  IF g_sma.sma56='3' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps061(彙總請購量)!"
    WHEN '2'
      LET g_msg ="_mps061(彙總請購量)!"
    OTHERWISE
      LET g_msg ="_mps061(Sum RequQty  )!"
  END CASE
  CALL msg(g_msg)
  DECLARE p500_pml_c CURSOR FOR
    SELECT pml01, pml02, pml04, pml11, pml33, pml20-pml21, pmk05, pmk25,pml09
      FROM pml_file,pmk_file,part_tmp
     WHERE pml04=partno AND pml20>pml21
        AND ( pml16<='2'  OR pml16='S' OR pml16='R' OR pml16='W') #MOD-530745
       #AND pml33<=edate AND pml33 >=bdate          #No.FUN-5A0200 add  #MOD-A40081 mark
       AND pml33<=edate           #No.FUN-5A0200 add   #MOD-A40081 mod
       AND pml01=pmk01 AND pmk02<>'SUB' AND pmk18 !='X'
       AND pml38='Y'   #FUN-690047 add  #可用/不可用
  CALL p500_mps_0()
 
  FOREACH p500_pml_c INTO l_pml01, l_pml02, l_ima01  , fz_flag, l_pml33,
                          mps.mps061, l_pmk05, l_pmk25,l_pml09
     IF STATUS THEN CALL cl_err('p500_pml_c',STATUS,1) RETURN END IF  #FUN-6A0049
 
     SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
     IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
     IF cl_null(l_ima133)
     THEN LET mps.mps01 = l_ima01
     ELSE LET mps.mps01 = l_ima133
     END IF
 
     IF g_sma.sma56='2' AND l_pmk25 MATCHES '[X0]' THEN CONTINUE FOREACH END IF
     IF mps.mps061 <= 0 OR mps.mps061 IS NULL THEN CONTINUE FOREACH END IF
 
     LET mps.mps02='-'
 
     IF cl_null(l_pml09) THEN LET l_pml09=1 END IF
     LET mps.mps061=mps.mps061*l_pml09
 
     SELECT pmh07 INTO mps.mps02 FROM pmh_file
            WHERE pmh01=mps.mps01 AND pmh02=mps.mps02
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mps.mps01 AND ven_no=mps.mps02
     IF i = 0 THEN LET mps.mps02='-' END IF
     IF cl_null(mps.mps02) THEN LET mps.mps02='-' END IF
     LET mps.mps03=past_date
     IF l_pml33 >= bdate THEN
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=l_pml33
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF fz_flag='Y'
        THEN LET mps.mps06_fz=mps.mps061
        ELSE LET mps.mps06_fz=0
     END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps061 using mps.mps061,mps.mps06_fz,
                                        mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 日期
     LET mpt.mpt04=l_pml33	# 日期
     LET mpt.mpt05='61'		# 供需類別
     LET mpt.mpt06=l_pml01	# 單號
     LET mpt.mpt061=l_pml02	# 項次
     LET mpt.mpt06_fz=fz_flag	# 凍結否
     LET mpt.mpt07=l_pmk05	# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps061	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)   
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
  END FOREACH
  IF STATUS THEN CALL cl_err('p500_pml_c',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps062_63()	# 彙總 採購量
  DEFINE l_pmn01        LIKE pmn_file.pmn01   #NO.FUN-680101  VARCHAR(16)   #No.FUN-550056
  DEFINE l_pmn02	LIKE pmn_file.pmn02   #NO.FUN-680101  SMALLINT
  DEFINE l_pmn33	LIKE pmn_file.pmn33   #NO.FUN-680101  DATE
  DEFINE l_pmn16	LIKE pmn_file.pmn16   #NO.FUN-680101  VARCHAR(1)
  DEFINE l_pmm09	LIKE pmm_file.pmm09   #NO.FUN-680101  VARCHAR(10)
  DEFINE l_pmm25	LIKE pmm_file.pmm25   #NO.FUN-680101  VARCHAR(1)
  DEFINE l_ima01        LIKE ima_file.ima01
  DEFINE l_ima133       LIKE ima_file.ima133
  DEFINE l_qty		LIKE mps_file.mps062  #NO.FUN-680101  DEC(15,3)
  DEFINE l_pmn09        LIKE pmn_file.pmn09     #採購單位/料件庫存單位的轉換率
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps062(彙總採購量)!"
    WHEN '2'
      LET g_msg ="_mps062(彙總採購量)!"
    OTHERWISE
      LET g_msg ="_mps062(Sum PurchQty )!"
  END CASE
  CALL msg(g_msg)
  DECLARE p500_pmn_c CURSOR FOR
    SELECT pmn01, pmn02, pmn04, pmn11, pmn33, pmn20-pmn50+pmn55+pmn58 #FUN-940083 
          ,pmn16, pmm09, pmm25,
           pmn09
      FROM pmn_file,pmm_file,part_tmp
    WHERE pmn04=partno AND pmn20>(pmn50-pmn55-pmn58)  #No.FUN-9A0068 
       AND ( pmn16<='2'  OR pmn16='S' OR pmn16='R' OR pmn16='W') #MOD-530745
      #AND pmn33<=edate AND pmn33>=bdate       #No.FUN-5A0200 add  #MOD-A40081 mark
      AND pmn33<=edate       #No.FUN-5A0200 add   #MOD-A40081 mod
      AND pmn01=pmm01 AND pmm02<>'SUB' AND pmm18 !='X'
      AND pmn38 ='Y'   #FUN-690047 add  #可用/不可用
  CALL p500_mps_0()
  FOREACH p500_pmn_c INTO l_pmn01, l_pmn02, l_ima01  , fz_flag, l_pmn33,
                          l_qty, l_pmn16, l_pmm09, l_pmm25,l_pmn09
     IF STATUS THEN CALL cl_err('p500_pmn_c',STATUS,1) RETURN END IF  #FUN-6A0049
     IF g_sma.sma57='2' AND l_pmm25 MATCHES '[X0]' THEN CONTINUE FOREACH END IF
     IF l_qty <= 0 OR l_qty IS NULL THEN CONTINUE FOREACH END IF
 
     SELECT ima133 INTO l_ima133 FROM ima_file WHERE ima01 = l_ima01
     IF SQLCA.sqlcode THEN LET l_ima133 = ' ' END IF
     IF cl_null(l_ima133)
     THEN LET mps.mps01 = l_ima01
     ELSE LET mps.mps01 = l_ima133
     END IF
 
     LET mps.mps02='-'
 
     SELECT pmh07 INTO mps.mps02 FROM pmh_file
            WHERE pmh01=mps.mps01 AND pmh02=mps.mps02
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mps.mps01 AND ven_no=mps.mps02
     IF i = 0 THEN LET mps.mps02='-' END IF
     IF cl_null(mps.mps02) THEN LET mps.mps02='-' END IF
     LET mps.mps03=past_date
     IF l_pmn33 >= bdate THEN
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=l_pmn33
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF cl_null(l_pmn09) THEN LET l_pmn09=1 END IF
     LET l_qty=l_qty * l_pmn09
     IF l_pmn16<'2'
        THEN LET mps.mps062=l_qty LET mps.mps063=0
        ELSE LET mps.mps062=0     LET mps.mps063=l_qty
     END IF
     IF fz_flag='Y'
        THEN LET mps.mps06_fz=l_qty
        ELSE LET mps.mps06_fz=0
     END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps062 using mps.mps062,mps.mps063,mps.mps06_fz,
                                        mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 日期
     LET mpt.mpt04=l_pmn33	# 日期
     IF l_pmn16<'2'
        THEN LET mpt.mpt05='62'	# 供需類別 (在採)
        ELSE LET mpt.mpt05='63'	# 供需類別 (在外)
     END IF
     LET mpt.mpt06=l_pmn01	# 單號
     LET mpt.mpt061=l_pmn02	# 項次
     LET mpt.mpt06_fz=fz_flag	# 凍結否
     LET mpt.mpt07=l_pmm09	# 追索料號(上階半/成品)
     LET mpt.mpt08=l_qty	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN 
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)   
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
  END FOREACH
  IF STATUS THEN CALL cl_err('p500_pmn_c',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps064()	# 彙總 在製量
  DEFINE l_sfb01        LIKE sfb_file.sfb01     #NO.FUN-680101  VARCHAR(16)      #No.FUN-550056
  DEFINE l_sfb15	LIKE sfb_file.sfb15     #NO.FUN-680101  DATE
  DEFINE l_ima01        LIKE ima_file.ima01
  DEFINE l_ima133       LIKE ima_file.ima133
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps064(彙總在製量)!"
    WHEN '2'
      LET g_msg ="_mps064(彙總在製量)!"
    OTHERWISE
      LET g_msg ="_mps064(Sum WkingQty )!"
  END CASE
  CALL msg(g_msg)
  DECLARE p500_sfb_c CURSOR FOR
    SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb09,ima55_fac,ima133         #FUN-640272
      FROM sfb_file,part_tmp,OUTER ima_file
     WHERE sfb05=partno AND sfb08>sfb09 AND sfb04<'8'
       #AND sfb15<=edate AND sfb15 >=bdate AND sfb87!='X'      #No.FUN-5A0200 add  #MOD-A40081 mark
       AND sfb15<=edate  AND sfb87!='X'      #No.FUN-5A0200 add   #MOD-A40081 mod
       AND ima_file.ima01=sfb_file.sfb05
       AND sfb02!='15'   #FUN-660110 add
  CALL p500_mps_0()
  FOREACH p500_sfb_c INTO l_sfb01, mps.mps01, fz_flag, l_sfb15, mps.mps064,
                          l_ima55_fac,l_ima133
     IF STATUS THEN CALL cl_err('p500_sfb_c',STATUS,1) RETURN END IF  #FUN-6A0049
     IF mps.mps064 <= 0 OR mps.mps064 IS NULL THEN CONTINUE FOREACH END IF
 
     IF not cl_null(l_ima133) THEN  LET mps.mps01 = l_ima133 END IF
     LET mps.mps02='-'
     LET mps.mps03=past_date
     IF l_sfb15 >= bdate THEN
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=l_sfb15
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
## -(統一單位為庫存單位)-------
     LET mps.mps064=mps.mps064*l_ima55_fac
     IF fz_flag='Y'
        THEN
            LET mps.mps06_fz=mps.mps064
        ELSE
            LET mps.mps06_fz=0
     END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps064 using mps.mps064,mps.mps06_fz,
                                        mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 日期
     LET mpt.mpt04=l_sfb15	# 日期
     LET mpt.mpt05='64'		# 供需類別
     LET mpt.mpt06=l_sfb01	# 單號
     LET mpt.mpt061=NULL	# 項次
     LET mpt.mpt06_fz=fz_flag	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps064	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)   
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
  END FOREACH
  IF STATUS THEN CALL cl_err('p500_sfb_c',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps065()	# 彙總 計劃產出量
DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mps065(彙總計劃產出量)!"
    WHEN '2'
      LET g_msg ="_mps065(彙總計劃產出量)!"
    OTHERWISE
      LET g_msg ="_mps065(Sum PrjProdQty)!"
  END CASE
  CALL msg(g_msg)
  IF msb_expl='N' THEN RETURN END IF
  DECLARE p500_msb_c4 CURSOR FOR
     SELECT msb_file.*,ima55_fac FROM msb_file,msa_file,part_tmp,OUTER ima_file
      WHERE msb03=partno
        AND msa01=mps_msa01
        AND msa03='N'
        AND msb01=msa01
        AND msb04 <= medate AND msb04 >= mbdate
         AND msb_file.msb03=ima_file.ima01
 
  CALL p500_mps_0()
  FOREACH p500_msb_c4 INTO msb.*,l_ima55_fac
     IF STATUS THEN CALL cl_err('msb_c4:',STATUS,1) RETURN END IF
     SELECT SUM(sfb08) INTO g_qty FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02 AND sfb87!='X'
        AND sfb02!='15'   #FUN-660110 add
     IF g_qty IS NULL THEN LET g_qty=0 END IF
     LET mps.mps065=msb.msb05-g_qty
     IF mps.mps065 <= 0 OR mps.mps065 IS NULL THEN CONTINUE FOREACH END IF
 
     IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
     LET mps.mps065=mps.mps065*l_ima55_fac
 
     LET mps.mps01=msb.msb03
     LET mps.mps02='-'
     LET mps.mps03=past_date
     IF msb.msb04 >= bdate THEN
        SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=msb.msb04
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF cl_null(mps.mps03) THEN 
         LET mps.mps03 = g_today
     END IF
     LET mps.mpsplant = g_plant  #FUN-980005 add
     LET mps.mpslegal = g_legal  #FUN-980005 add
     INSERT INTO mps_file VALUES(mps.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
     CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
      END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
        EXECUTE p500_p_upd_mps065 using mps.mps065,mps.mps_v,mps.mps01,
                                        mps.mps02,mps.mps03
        IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
     END IF
     LET mpt.mpt_v=mps.mps_v	# 版本
     LET mpt.mpt01=mps.mps01	# 料號
     LET mpt.mpt02=mps.mps02	# 廠商
     LET mpt.mpt03=mps.mps03	# 日期
     LET mpt.mpt04=msb.msb04	# 日期
     LET mpt.mpt05='65'		# 供需類別
     LET mpt.mpt06=msb.msb01	# 單號
     LET mpt.mpt061=msb.msb02	# 項次
     LET mpt.mpt06_fz=NULL	# 凍結否
     LET mpt.mpt07=NULL		# 追索料號(上階半/成品)
     LET mpt.mpt08=mps.mps065	# 數量
     LET mpt.mptplant=g_plant   #FUN-980005 add
     LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
     IF STATUS THEN  
     CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)   
         CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
  END FOREACH
  IF STATUS THEN CALL cl_err('msb_c4:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_plan()	# M.R.P. (M.R.P. By Lot)
  DEFINE l_mps01      LIKE mps_file.mps01
 DEFINE l_mps03        LIKE mps_file.mps03
 DEFINE l_mps_v        LIKE mps_file.mps_v 
   DEFINE l_name         LIKE type_file.chr20    #NO.FUN-680101  VARCHAR(20)   #MOD-4C0101
  DECLARE low_level_code CURSOR FOR
     SELECT ima16 FROM part_tmp,ima_file
         WHERE partno=ima01 AND imaacti='Y' AND ima08<>'X'
          GROUP BY ima16 ORDER BY ima16
  LET g_n=0
  LET g_mps00=0
  FOREACH low_level_code INTO g_ima16
     IF STATUS THEN CALL cl_err('low level:',STATUS,1) EXIT FOREACH END IF
     IF cl_null(g_argv1) THEN 
         IF g_bgjob = 'N' THEN   #NO.FUN-570126 
             MESSAGE "Low Level:",g_ima16,"       "  
         END IF
     END IF
     IF sub_flag='Y' THEN
       LET g_msg='_plan_sub:',g_ima16 USING '<<<' CALL msg(g_msg)
       CALL p500_plan_sub()
       CALL p500_plan_sub_1()       #FUN-A40002
     END IF
     LET g_msg='_plan:',g_ima16 USING '<<<' CALL msg(g_msg)
     DECLARE p500_plan_c CURSOR FOR
       SELECT mps_v,mps01,mps03 FROM mps_file,ima_file
        WHERE mps_v=ver_no AND mps01=ima01 AND ima16=g_ima16
 
     CALL cl_outnam('amsp500 ') RETURNING l_name
     START REPORT p500_rep TO l_name
 
     FOREACH p500_plan_c INTO l_mps_v,l_mps01,l_mps03
        IF STATUS THEN CALL cl_err('p500_plan_c',STATUS,1) EXIT FOREACH END IF  #FUN-6A0049
        SELECT * INTO mps.* FROM mps_file
        WHERE mps_v=l_mps_v AND mps01=l_mps01 AND mps03=l_mps03
        OUTPUT TO REPORT p500_rep(l_mps_v,l_mps01,l_mps03,mps.*)
     END FOREACH
     IF STATUS THEN CALL cl_err('p500_plan_c',STATUS,1) END IF  #FUN-6A0049
     FINISH REPORT p500_rep
  END FOREACH
  IF STATUS THEN CALL cl_err('low level:',STATUS,1) END IF
END FUNCTION
 
REPORT p500_rep(p_mps,mps)
  DEFINE p_mps      RECORD
                        mps_v       LIKE mps_file.mps_v,
                        mps01       LIKE mps_file.mps01,
                        mps03       LIKE mps_file.mps03
                       END RECORD 
  DEFINE i,j,k	        LIKE type_file.num10    
  DEFINE bal		LIKE mps_file.mps062    #NO.FUN-680101  DEC(15,3)
  DEFINE qty2		LIKE mps_file.mps062    #NO.FUN-680101  DEC(15,3)
  DEFINE l_ima08	LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
  DEFINE l_ima45,l_ima46,l_ima47	LIKE ima_file.ima45   #NO.FUN-680101  DEC(12,3)
  DEFINE l_ima56,l_ima561,l_ima562	LIKE ima_file.ima56   #NO.FUN-680101  DEC(12,3)
 #DEFINE l_ima50	LIKE type_file.num5     #NO.FUN-680101  SMALLINT  #TQC-A30097
  DEFINE l_ima50	LIKE ima_file.ima50     #TQC-A30097
  DEFINE l_ima59	LIKE ima_file.ima59     #NO.FUN-680101  DEC(9,3)
  DEFINE l_ima60	LIKE ima_file.ima60     #NO.FUN-680101  DEC(9,3)
  DEFINE l_ima601	LIKE ima_file.ima601    #NO.FUN-840194
  DEFINE l_ima61	LIKE ima_file.ima61     #NO.FUN-680101  DEC(9,3)
  DEFINE l_ima72	LIKE type_file.num5     #NO.FUN-680101  SMALLINT
  DEFINE l_soqty        LIKE mps_file.mps041
  DEFINE l_mpsqty       LIKE mps_file.mps041
  DEFINE mps		RECORD LIKE mps_file.*
  DEFINE rrr		DYNAMIC ARRAY OF RECORD
  			mps_v       LIKE mps_file.mps_v,
                                    mps01     LIKE mps_file.mps01,
                                    mps03     LIKE mps_file.mps03    #No.TQC-940183 #No.FUN-940083
  			END RECORD
  DEFINE sss		DYNAMIC ARRAY OF RECORD LIKE mps_file.*
  DEFINE l_gfe03        LIKE gfe_file.gfe03 #FUN-670074
  DEFINE l_ima910       LIKE ima_file.ima910      #No.MOD-840090 add
  DEFINE l_ima25        LIKE ima_file.ima25
  DEFINE l_ima44        LIKE ima_file.ima44
  DEFINE l_ima55        LIKE ima_file.ima55
  DEFINE l_mps09        LIKE mps_file.mps09
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY mps.mps01,mps.mps02,mps.mps03
  FORMAT
    BEFORE GROUP OF mps.mps01
      SELECT ima08,ima45,ima46,ima47,ima50+ima48+ima49+ima491,
                   ima56,ima561,ima562,
                   ima59,ima60,ima601,ima61,ima72,     #No.FUN-840194 add ima601 #No.MOD-810233 add ,
                   ima25,ima44,ima55                   #No.MOD-810233 add
        INTO l_ima08,l_ima45,l_ima46,l_ima47,l_ima50,
                     l_ima56,l_ima561,l_ima562,
                     l_ima59,l_ima60,l_ima601,l_ima61,l_ima72, #No.FUN-840194 add l_ima601 #No.MOD-810233 add ,
                     l_ima25,l_ima44,l_ima55           #No.MOD-810233 add
       FROM ima_file
      WHERE ima01=mps.mps01
      IF l_ima45 IS NULL THEN LET l_ima45=0 END IF
      IF l_ima46 IS NULL THEN LET l_ima46=0 END IF
      IF l_ima47 IS NULL THEN LET l_ima47=0 END IF
      IF l_ima50 IS NULL THEN LET l_ima50=0 END IF
      IF l_ima56 IS NULL THEN LET l_ima56=0 END IF
      IF l_ima561 IS NULL THEN LET l_ima561=0 END IF
      IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
      IF l_ima59 IS NULL THEN LET l_ima59=0 END IF
      IF l_ima60 IS NULL THEN LET l_ima60=0 END IF
      IF l_ima61 IS NULL THEN LET l_ima61=0 END IF
      IF l_ima72 IS NULL THEN LET l_ima72=0 END IF
      IF STATUS THEN
         LET l_ima45=0 LET l_ima46=0 LET l_ima47=0 LET l_ima50=0
         LET l_ima56=0 LET l_ima561=0 LET l_ima562=0
         LET l_ima59=0 LET l_ima60=0 LET l_ima61=0
      END IF
      IF l_ima08='M' THEN
         LET l_ima50=l_ima59+l_ima60/l_ima601*mps.mps09+l_ima61   #No.FUN-840194  #CHI-810015 mark還原 
         LET l_ima47=l_ima562
         LET l_ima45=l_ima56
         LET l_ima46=l_ima561
         LET l_ima44=l_ima55         #No.MOD-810233 add
      END IF
      IF l_ima08='P' THEN
         CASE WHEN po_days>0 LET l_ima72=po_days
              WHEN po_days=0 LET l_ima72=po_days
              WHEN po_days<0 LET l_ima72=l_ima72
         END CASE
      END IF
      IF l_ima08='M' OR l_ima08 = 'S' THEN       #No.MOD-680009 modify
         CASE WHEN wo_days>0 LET l_ima72=wo_days
              WHEN wo_days=0 LET l_ima72=wo_days
              WHEN wo_days<0 LET l_ima72=l_ima72
         END CASE
      END IF
    BEFORE GROUP OF mps.mps02
      FOR i = 1 TO 100 INITIALIZE sss[i].* TO NULL END FOR                                         #09/10/20 xiaofeizhu Add
      LET i = 0
      LET g_n=g_n+1 MESSAGE g_n
    ON EVERY ROW
      LET g_mps00=g_mps00+1
      LET i = i+1
      LET rrr[i].mps_v=p_mps.mps_v
 LET rrr[i].mps01=p_mps.mps01
 LET rrr[i].mps03=p_mps.mps03   #FUN-940083
      LET sss[i].*    =mps.*
      LET sss[i].mps00=g_mps00
    AFTER GROUP OF mps.mps02
      LET bal=0
      FOR i = 1 TO 100
        IF sss[i].mps01 IS NULL THEN EXIT FOR END IF
        LET bal=bal
               +sss[i].mps051+sss[i].mps052+sss[i].mps053
               +sss[i].mps061+sss[i].mps062+sss[i].mps063
               +sss[i].mps064+sss[i].mps065
               -sss[i].mps043-sss[i].mps044
               -sss[i].mps071+sss[i].mps072
#需求納入(1.訂單 2.預測 3.取最大)
     CASE
         WHEN incl_so = '1'
              LET bal = bal - sss[i].mps041
         WHEN incl_so = '2'
              LET bal = bal - sss[i].mps039
         WHEN incl_so = '3'
              IF sss[i].mps041 > sss[i].mps039
                 THEN
                 LET bal = bal - sss[i].mps041
              ELSE
                 LET bal = bal - sss[i].mps039
              END IF
     END CASE
 
        IF bal < 0 THEN
          FOR j = i+1 TO 100		# 請/採購交期, 工單完工日調整
            IF sss[j].mps01 IS NULL THEN EXIT FOR END IF
            IF sss[j].mps03 > sss[i].mps03+l_ima72 THEN EXIT FOR END IF
            LET qty2=sss[j].mps061+sss[j].mps062+sss[j].mps063+sss[j].mps064
                    -sss[j].mps06_fz			# 扣除Frozen凍結量
                    -sss[j].mps071+sss[j].mps072
            IF qty2 <= 0 THEN CONTINUE FOR END IF
            IF qty2 >= bal*-1
               THEN LET sss[j].mps071=sss[j].mps071+bal*-1
                    LET sss[i].mps072=sss[i].mps072+bal*-1
                    LET bal=0
                    EXIT FOR
               ELSE LET sss[j].mps071=sss[j].mps071+qty2
                    LET sss[i].mps072=sss[i].mps072+qty2
                    LET bal=bal+qty2
            END IF
          END FOR
        END IF
        LET sss[i].mps08=bal
        IF sss[i].mps08 < 0 THEN 			#-> plan order
           LET sss[i].mps09=sss[i].mps08*-1
 
           LET l_mps09 = sss[i].mps09
           #若庫存單位與採購/生產單位不一樣時才推算數量
           IF l_ima25 != l_ima44 THEN      
              CALL p500_che_qty(mps.mps01,l_ima25,l_ima44,l_mps09)
                                RETURNING l_mps09
           END IF
           IF l_ima47 != 0 THEN                         # 採購/製造損耗率
              LET l_mps09 = l_mps09 * (100+l_ima47)/100
           END IF
           IF l_ima45 != 0 THEN                         # 採購/製造倍量
              LET k = (l_mps09 / l_ima45) + 0.999
              LET l_mps09 = l_ima45 * k
           END IF
           IF l_mps09 < l_ima46 THEN               # 最小採購/製造量
              LET l_mps09 = l_ima46
           END IF
           IF l_ima25 != l_ima44 THEN
              CALL p500_che_qty(mps.mps01,l_ima44,l_ima25,l_mps09) 
                                RETURNING l_mps09
           END IF
          LET l_gfe03=NULL
          SELECT gfe03 INTO l_gfe03 FROM ima_file,gfe_file,mps_file #No.MOD-8C0021 mark
                                   WHERE ima01=mps01
                                     AND mps01=sss[i].mps01
                                     AND ima55=gfe01
 
          LET sss[i].mps09 = l_mps09
          IF NOT cl_null(l_gfe03) THEN
             LET sss[i].mps09=cl_digcut(l_mps09,l_gfe03)
          END IF
           LET needdate=NULL
           IF needdate IS NULL THEN LET needdate=sss[i].mps03 END IF
 
           IF l_ima08='M' THEN
               LET l_ima50=l_ima59+l_ima60/l_ima601*sss[i].mps09+l_ima61 #No.FUN-840194 #CHI-810015 mark還原 
           END IF
           LET sss[i].mps11=s_aday(needdate,-1,l_ima50)  # 減採購/製造前置日數   #FUN-5A0017
            IF sss[i].mps11 > sss[i].mps03 THEN
               LET sss[i].mps11=sss[i].mps03
            END IF
        END IF
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sss[i].mps01
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        IF sss[i].mps09>0 AND (l_ima08='M' OR l_ima08='S' OR l_ima08='T') THEN
           CALL p500_mps045(sss[i].mps00,sss[i].mps01,
                            sss[i].mps11,needdate,sss[i].mps09,l_ima910)    #No.MOD-840090 add ima910
        END IF
        LET bal=sss[i].mps08+sss[i].mps09
        EXECUTE p500_p_upd_mps using sss[i].*,rrr[i].*              #FUN-940083
        IF SQLCA.SQLCODE THEN
            IF g_bgjob = 'N' THEN #NO.FUN-570126 
                MESSAGE sss[i].mps01,' ',sss[i].mps03
                 CALL cl_err3("upd","mps_file",sss[i].mps00,sss[i].mps01,STATUS,"","upd mps",1)   #FUN-6A0049
            END IF
        END IF
      END FOR
END REPORT
 
FUNCTION p500_che_qty(p_part,p_unit1,p_unit2,p_qty)
   DEFINE p_part         LIKE ima_file.ima01
   DEFINE p_unit1        LIKE ima_file.ima25
   DEFINE p_unit2        LIKE ima_file.ima25
   DEFINE p_qty          LIKE mps_file.mps09
   DEFINE l_factor       LIKE ima_file.ima55_fac
   DEFINE l_cnt          LIKE type_file.num5
 
   CALL s_umfchk(p_part,p_unit1,p_unit2) RETURNING l_cnt, l_factor
   IF l_cnt = 1 THEN
     LET l_factor = 1
   END IF
   LET p_qty = p_qty * l_factor 
   RETURN p_qty
END FUNCTION
#------------------------------------------------- 建議 PLM 下階料備料量
#No.FUN-A70034  --Begin
FUNCTION p500_mps045(p_mps00,p_ima01,p_opendate,p_needdate,p_qty,p_key2)    #No.MOD-840090 add p_key2
  DEFINE l_total        LIKE sfa_file.sfa05
  DEFINE l_QPA          LIKE bmb_file.bmb06
  DEFINE l_ActualQPA    LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
  DEFINE p_mps00	LIKE type_file.num10    #NO.FUN-680101  INTEGER
  DEFINE p_ima01        LIKE ima_file.ima01  #NO.MOD-490217	
  DEFINE p_opendate	LIKE type_file.dat      #NO.FUN-680101  DATE
  DEFINE p_needdate 	LIKE type_file.dat      #NO.FUN-680101  DATE
  DEFINE p_qty 		LIKE mps_file.mps062    #NO.FUN-680101  DEC(15,3)
  DEFINE qty1,qty2,qty3,qty4 LIKE mps_file.mps062    #NO.FUN-680101  DEC(15,3)
  DEFINE l_ima08	LIKE type_file.chr1     #NO.FUN-680101  VARCHAR(1)
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
  DEFINE p_key2         LIKE ima_file.ima910      #No.MOD-840090 add
 
  IF mss_expl='N' THEN RETURN END IF		# 僅在多階 MRP 狀況下
  DECLARE p500_mps045_c1 CURSOR FOR
     SELECT bmb_file.*, ima08 FROM bmb_file, ima_file
      WHERE bmb01=p_ima01
        AND bmb04<=p_needdate AND (bmb05 IS NULL OR bmb05>p_needdate)
        AND bmb29=p_key2            #No.MOD-840090 add
        AND bmb03=ima01
        AND ima139 = 'Y'
  CALL p500_mps_0()
  FOREACH p500_mps045_c1 INTO bmb1.*, l_ima08
    IF STATUS THEN CALL cl_err('45_c1:',STATUS,1) EXIT FOREACH END IF
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb1.bmb01   # 主件
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
    #No.FUN-A70034  --Begin
    #LET qty1=p_qty*bmb1.bmb06/bmb1.bmb07*(1+bmb1.bmb08/100)/
    #         l_ima55_fac*bmb1.bmb10_fac
    CALL cralc_rate(bmb1.bmb01,bmb1.bmb03,p_qty,bmb1.bmb081,bmb1.bmb08,bmb1.bmb082,bmb1.bmb06/bmb1.bmb07,0)
         RETURNING l_total,l_QPA,l_ActualQPA
    LET qty1 = l_total / l_ima55_fac*bmb1.bmb10_fac
    #No.FUN-A70034  --End  
    IF l_ima08!='X' THEN
       SELECT partno FROM part_tmp WHERE partno=bmb1.bmb03
       IF STATUS THEN CONTINUE FOREACH END IF
       LET bmb.*=bmb1.*
       CALL p500_mps045_ins(p_mps00,p_opendate,p_needdate,qty1,p_ima01)
       CONTINUE FOREACH
    END IF
    #(1)---------------------------------------------------------
    DECLARE p500_mps045_c2 CURSOR FOR	# Phantom 再展一階
       SELECT bmb_file.*,ima08 FROM bmb_file,ima_file
          WHERE bmb01=bmb1.bmb03
            AND bmb04<=p_needdate AND (bmb05 IS NULL OR bmb05>p_needdate)
            AND bmb03=ima01
    CALL p500_mps_0()
    FOREACH p500_mps045_c2 INTO bmb2.*,l_ima08
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb2.bmb01
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
      #No.FUN-A70034  --Begin
      #LET qty2=qty1*bmb2.bmb06/bmb2.bmb07*(1+bmb2.bmb08/100)*l_ima55_fac
      CALL cralc_rate(bmb2.bmb01,bmb2.bmb03,qty1,bmb2.bmb081,bmb2.bmb08,bmb2.bmb082,bmb2.bmb06/bmb2.bmb07,0)
           RETURNING l_total,l_QPA,l_ActualQPA
      LET qty2 = l_total * l_ima55_fac
      #No.FUN-A70034  --End  
      IF l_ima08!='X' THEN
         SELECT partno FROM part_tmp WHERE partno=bmb2.bmb03
         IF STATUS THEN CONTINUE FOREACH END IF
         LET bmb.*=bmb2.*
         CALL p500_mps045_ins(p_mps00,p_opendate,p_needdate,qty2,p_ima01)
         CONTINUE FOREACH
      END IF
      #(2)---------------------------------------------------------
      DECLARE p500_mps045_c3 CURSOR FOR	# Phantom 再展一階
          SELECT bmb_file.*,ima08 FROM bmb_file,ima_file
           WHERE bmb01=bmb2.bmb03
             AND bmb04<=p_needdate AND (bmb05 IS NULL OR bmb05>p_needdate)
             AND bmb03=ima01
      CALL p500_mps_0()
      FOREACH p500_mps045_c3 INTO bmb3.*,l_ima08
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb3.bmb01
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
        #No.FUN-A70034  --Begin
        #LET qty3=qty1*bmb3.bmb06/bmb3.bmb07*(1+bmb3.bmb08/100)*l_ima55_fac
        CALL cralc_rate(bmb3.bmb01,bmb3.bmb03,qty1,bmb3.bmb081,bmb3.bmb08,bmb3.bmb082,bmb3.bmb06/bmb3.bmb07,0)
             RETURNING l_total,l_QPA,l_ActualQPA
        LET qty3 = l_total * l_ima55_fac
        #No.FUN-A70034  --End  
        IF l_ima08!='X' THEN
           SELECT partno FROM part_tmp WHERE partno=bmb3.bmb03
           IF STATUS THEN CONTINUE FOREACH END IF
           LET bmb.*=bmb3.*
           CALL p500_mps045_ins(p_mps00,p_opendate,p_needdate,qty3,p_ima01)
           CONTINUE FOREACH
        END IF
        #(3)---------------------------------------------------------
        DECLARE p500_mps045_c4 CURSOR FOR
            SELECT bmb_file.*,ima08 FROM bmb_file,ima_file
             WHERE bmb01=bmb3.bmb03
               AND bmb04<=p_needdate
               AND (bmb05 IS NULL OR bmb05>p_needdate)
               AND bmb03=ima01
           CALL p500_mps_0()
        FOREACH p500_mps045_c4 INTO bmb4.*,l_ima08
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb4.bmb01
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
          #No.FUN-A70034  --Begin
          #LET qty4=qty1*bmb4.bmb06/bmb4.bmb07*(1+bmb4.bmb08/100)*l_ima55_fac
          CALL cralc_rate(bmb4.bmb01,bmb4.bmb03,qty1,bmb4.bmb081,bmb4.bmb08,bmb4.bmb082,bmb4.bmb06/bmb4.bmb07,0)
               RETURNING l_total,l_QPA,l_ActualQPA
          LET qty4 = l_total * l_ima55_fac
          #No.FUN-A70034  --End  
          SELECT partno FROM part_tmp WHERE partno=bmb4.bmb03
          IF STATUS THEN CONTINUE FOREACH END IF
          LET bmb.*=bmb4.*
          CALL p500_mps045_ins(p_mps00,p_opendate,p_needdate,qty4,p_ima01)
        END FOREACH
      END FOREACH
    END FOREACH
  END FOREACH
  IF STATUS THEN CALL cl_err('p500_mps045_c2:',STATUS,1) RETURN END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION p500_mps045_ins(p_mps00,p_opendate,p_needdate,p_qty,p_id)
  DEFINE p_mps00        LIKE type_file.num10    #NO.FUN-680101  INTEGER
  DEFINE p_qty 		LIKE mps_file.mps062    #NO.FUN-680101  DEC(15,3)
  DEFINE p_opendate 	LIKE type_file.dat      #NO.FUN-680101  DATE
  DEFINE p_needdate 	LIKE type_file.dat      #NO.FUN-680101  DATE
  DEFINE p_id           LIKE ima_file.ima01 ## 98/06/23 Eric Add
                                             ## 解決虛擬料件回溯追蹤
 
       SELECT partno FROM part_tmp WHERE partno=bmb.bmb03
       IF STATUS THEN INSERT INTO part_tmp VALUES(bmb.bmb03) END IF
       LET mps.mps01=bmb.bmb03
       LET mps.mps02='-'
       LET mps.mps03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
       LET needdate=p_opendate + bmb.bmb18
       IF needdate >= bdate THEN
          SELECT plan_date INTO mps.mps03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       LET mps.mps043=p_qty
       IF cl_null(mps.mps03) THEN 
           LET mps.mps03 = g_today
       END IF
       LET mps.mpsplant = g_plant  #FUN-980005 add
       LET mps.mpslegal = g_legal  #FUN-980005 add
       INSERT INTO mps_file VALUES(mps.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
        CALL cl_err3("ins","mps_file",g_mps01,g_mps03,SQLCA.SQLCODE,"","ins mps:",1)   #No.FUN-660108 #TQC-790091 mod
         END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
          EXECUTE p500_p_upd_mps043 using mps.mps043,mps.mps_v,mps.mps01,
                                          mps.mps02,mps.mps03
          IF STATUS THEN CALL cl_err('upd mps:',STATUS,1) END IF
       END IF
       LET mpt.mpt_v=mps.mps_v	# 版本
       LET mpt.mpt01=mps.mps01	# 料號
       LET mpt.mpt02=mps.mps02	# 廠商
       LET mpt.mpt03=mps.mps03	# 日期
       LET mpt.mpt04=p_opendate	# 日期
       LET mpt.mpt05='45'	# 供需類別
       LET mpt.mpt06=p_mps00  	# 單號
       LET mpt.mpt061=NULL     	# 項次
       LET mpt.mpt06_fz=NULL	# 凍結否
       LET mpt.mpt07=p_id       # 追索料號(上階半/成品) 98/06/23 Modif
       LET mpt.mpt08=mps.mps043	# 數量
       LET mpt.mptplant=g_plant   #FUN-980005 add
       LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
       IF STATUS THEN  
          CALL cl_err3("ins","mpt_file",mpt.mpt_v,mpt.mpt01,STATUS,"","ins mpt",1)   #FUN-6A0049
           CALL cl_batch_bg_javamail("N")   #NO.FUN-570126 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM 
       END IF
END FUNCTION
 
FUNCTION p500_plan_sub()
  DEFINE l_short	LIKE mps_file.mps041    #NO.FUN-680101  DEC(15,3)
  DEFINE l_short2       LIKE mps_file.mps041    #NO.FUN-680101  DEC(15,3)
  DEFINE xx		LIKE mps_file.mps041    #NO.FUN-680101  DEC(15,3)
  DEFINE b1,b2,b3,b22	LIKE mps_file.mps041    #NO.FUN-680101  DEC(15,3)
  DEFINE l_bal		LIKE mps_file.mps041    #NO.FUN-680101  DEC(15,3)
  DECLARE p500_plan_sub_c CURSOR FOR
    SELECT UNIQUE mps01,mps03		# 找出有取替代的元件
      FROM mps_file, bmd_file, ima_file
     WHERE mps_v=ver_no AND mps01=bmd01 AND mps01=ima01 AND ima16=g_ima16
       AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
       AND bmdacti = 'Y'                                           #CHI-910021
     ORDER BY 1,2
  FOREACH p500_plan_sub_c INTO g_mps01,g_mps03
     IF STATUS THEN CALL cl_err('fore1',STATUS,1) RETURN END IF  #FUN-6A0049
#需求納入(1.訂單 2.預測 3.取最大)
     CASE
         WHEN incl_so = '1'
              SELECT SUM((mps041+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065))
                INTO l_short
                FROM mps_file
               WHERE mps_v=ver_no AND mps01=g_mps01 AND mps02='-'
                 AND mps03<=g_mps03
         WHEN incl_so = '2'
              SELECT SUM((mps039+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065))
                INTO l_short
                FROM mps_file
               WHERE mps_v=ver_no AND mps01=g_mps01 AND mps02='-'
                 AND mps03<=g_mps03
         WHEN incl_so = '3'
              SELECT SUM((mps041+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065)),
                     SUM((mps039+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065))
                INTO l_short,l_short2
                FROM mps_file
               WHERE mps_v=ver_no AND mps01=g_mps01 AND mps02='-'
                 AND mps03<=g_mps03
              IF l_short2>l_short THEN LET l_short=l_short2 END IF
     END CASE
 
     IF l_short IS NULL THEN LET l_short=0 END IF
     IF l_short<=0 THEN CONTINUE FOREACH END IF	#若不足才找替代
     DECLARE p500_plan_sub_c2 CURSOR FOR
       SELECT mpt03,mpt04,mpt06,mpt061,mpt07,mpt08 FROM mpt_file
        WHERE mpt_v=ver_no AND mpt01=g_mps01 AND mpt02='-' AND mpt03<=g_mps03
          AND mpt05 IN ('43','44','45')   #備料
        ORDER BY 1 DESC, 2, 5, 3
     FOREACH p500_plan_sub_c2 INTO g_mpt03,g_mpt04,g_mpt06,g_mpt061,
                                   g_mpt07,g_mpt08
       IF STATUS THEN CALL cl_err('fore2',STATUS,1) EXIT FOREACH END IF  #FUN-6A0049
       SELECT SUM(sub_qty) INTO xx FROM sub_tmp
         WHERE sub_partno=g_mps01 AND sub_wo_no=g_mpt06 AND sub_prodno=g_mpt07
       IF xx IS NULL THEN LET xx=0 END IF
       LET g_mpt08=g_mpt08 - xx
       IF g_mpt08 <= 0 THEN CONTINUE FOREACH END IF
       #------------------------------------------ 取該料+工單已被計算部份
       IF l_short<g_mpt08 THEN LET g_mpt08=l_short END IF
       DECLARE p500_plan_sub_c3 CURSOR FOR
         SELECT bmd_file.* FROM bmd_file, ima_file
          WHERE bmd01=g_mps01 AND (bmd08=g_mpt07 OR bmd08='ALL')
            AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
            AND bmd04=ima01 AND imaacti='Y'
            AND bmdacti = 'Y'                                           #CHI-910021
          ORDER BY bmd03
       FOREACH p500_plan_sub_c3 INTO bmd.*
         IF STATUS THEN CALL cl_err('fore3',STATUS,1) EXIT FOREACH END IF  #FUN-6A0049
         SELECT SUM(mps051+mps052+mps061+mps062+mps063+mps064+mps065)
           INTO b1					# QOH/PR/PO 供給合計
           FROM mps_file
          WHERE mps_v=ver_no AND mps01=bmd.bmd04 AND mps02='-'
            AND mps03<=g_mpt03
 
#需求納入(1.訂單 2.預測 3.取最大)
         CASE
            WHEN incl_so = '1'
                 SELECT SUM(mps041+mps043+mps044-mps053)
                   INTO b2			# 需求(+替代需求)合計
                   FROM mps_file
                  WHERE mps_v=ver_no AND mps01=bmd.bmd04 AND mps02='-'
                    AND mps03<=g_mps03
            WHEN incl_so = '2'
                 SELECT SUM(mps039+mps043+mps044-mps053)
                   INTO b2			# 需求(+替代需求)合計
                   FROM mps_file
                  WHERE mps_v=ver_no AND mps01=bmd.bmd04 AND mps02='-'
                    AND mps03<=g_mps03
            WHEN incl_so = '3'
                 SELECT SUM(mps041+mps043+mps044-mps053),
                        SUM(mps039+mps043+mps044-mps053)
                   INTO b2,b22			# 需求(+替代需求)合計
                   FROM mps_file
                  WHERE mps_v=ver_no AND mps01=bmd.bmd04 AND mps02='-'
                    AND mps03<=g_mps03
                 IF b22>b2 THEN LET b2=b22 END IF
         END CASE
 
         IF b1 IS NULL THEN LET b1=0 END IF
         IF b2 IS NULL THEN LET b2=0 END IF
         LET l_bal=b1-b2
         IF l_bal<=0 THEN CONTINUE FOREACH END IF
         IF g_mpt08*bmd.bmd07 > l_bal
            THEN LET g_sub_qty=l_bal
            ELSE LET g_sub_qty=g_mpt08*bmd.bmd07
         END IF
         #-------------------------------- 統計該料+工單已被計算部份,存入sub_tmp
         UPDATE sub_tmp SET sub_qty=sub_qty+g_sub_qty
          WHERE sub_partno=g_mps01 AND sub_wo_no=g_mpt06 AND sub_prodno=g_mpt07
         IF SQLCA.SQLERRD[3]=0 THEN
            INSERT INTO sub_tmp (sub_partno, sub_wo_no, sub_prodno, sub_qty)
                                VALUES(g_mps01, g_mpt06, g_mpt07, g_sub_qty)
         END IF
         #---------------------------------------------------------------------
         CALL u_sub_1()	# 更新替代件
         CALL u_sub_2()	# 更新被替代件
         LET g_mpt08=g_mpt08-g_sub_qty/bmd.bmd07
         LET l_short=l_short-g_sub_qty/bmd.bmd07
         IF g_mpt08 <= 0 THEN EXIT FOREACH END IF
       END FOREACH
       IF STATUS THEN CALL cl_err('fore3',STATUS,1) EXIT FOREACH END IF  #FUN-6A0049
       IF l_short <= 0 THEN EXIT FOREACH END IF
     END FOREACH
     IF STATUS THEN CALL cl_err('fore2',STATUS,1) EXIT FOREACH END IF  #FUN-6A0049
  END FOREACH
  IF STATUS THEN CALL cl_err('fore1',STATUS,1) END IF  #FUN-6A0049
END FUNCTION
 
FUNCTION u_sub_1()
   UPDATE mps_file SET mps053=mps053-g_sub_qty
    WHERE mps_v=ver_no AND mps01=bmd.bmd04
      AND mps02='-'    AND mps03=g_mpt03
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL p500_mps_0()
      LET mps.mps01=bmd.bmd04
      LET mps.mps02='-'
      LET mps.mps03=g_mpt03
      LET mps.mps053=-g_sub_qty
      IF cl_null(mps.mps03) THEN 
          LET mps.mps03 = g_today
      END IF
      LET mps.mpsplant = g_plant  #FUN-980005 add
      LET mps.mpslegal = g_legal  #FUN-980005 add
      INSERT INTO mps_file VALUES (mps.*)
   END IF
   LET mpt.mpt01=bmd.bmd04
   LET mpt.mpt02='-'
   LET mpt.mpt03=g_mpt03
   LET mpt.mpt04=g_mpt04
   LET mpt.mpt05='53'
   LET mpt.mpt06=g_mpt06
   LET mpt.mpt061=g_mpt061
   LET mpt.mpt06_fz=NULL
   LET mpt.mpt07=g_mps01
   LET mpt.mpt08=-g_sub_qty
   LET mpt.mptplant=g_plant   #FUN-980005 add
   LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
END FUNCTION
 
FUNCTION u_sub_2()
   UPDATE mps_file SET mps053=mps053+g_sub_qty/bmd.bmd07
    WHERE mps_v=ver_no AND mps01=g_mps01
      AND mps02='-'    AND mps03=g_mpt03
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL p500_mps_0()
      LET mps.mps01=g_mps01
      LET mps.mps02='-'
      LET mps.mps03=g_mpt03
      LET mps.mps053=g_sub_qty/bmd.bmd07
      IF cl_null(mps.mps03) THEN 
          LET mps.mps03 = g_today
      END IF
      LET mps.mpsplant = g_plant  #FUN-980005 add
      LET mps.mpslegal = g_legal  #FUN-980005 add
      INSERT INTO mps_file VALUES (mps.*)
   END IF
   LET mpt.mpt01=g_mps01
   LET mpt.mpt02='-'
   LET mpt.mpt03=g_mpt03
   LET mpt.mpt04=g_mpt04
   LET mpt.mpt05='53'
   LET mpt.mpt06=g_mpt06
   LET mpt.mpt061=g_mpt061
   LET mpt.mpt06_fz=NULL
   LET mpt.mpt07=bmd.bmd04
   LET mpt.mpt08=g_sub_qty/bmd.bmd07
   LET mpt.mptplant=g_plant   #FUN-980005 add
   LET mpt.mptlegal=g_legal   #FUN-980005 add
PUT p500_c_ins_mpt FROM mpt.mpt_v,mpt.mpt01,mpt.mpt02,mpt.mpt03,mpt.mpt04,
mpt.mpt05,mpt.mpt06,mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,mpt.mpt08,mpt.mptplant,mpt.mptlegal   #FUN-9A0096  add plant,legal
END FUNCTION

#FUN-A40002 --begin--
FUNCTION p500_plan_sub_1()
  DEFINE l_short	      LIKE mps_file.mps041    
  DEFINE l_short2       LIKE mps_file.mps041    
  DEFINE xx		          LIKE mps_file.mps041    
  DEFINE b1,b2,b3,b22	  LIKE mps_file.mps041    
  DEFINE l_bal		      LIKE mps_file.mps041    
   
   DECLARE p500_plan_sub_c_1 CURSOR FOR   # 找出有取替代的元件
   SELECT unique mps01,mps03 FROM mps_file,ima_file,bon_file,bmb_file
    WHERE mps_v = ver_no                     
      AND mps01 = bon01 
      AND mps01 in(select ima01 from ima_file) 
      AND ima16 = g_ima16 
      AND bmb16 = '7' AND bmb03 = bon01          
      AND (bmb01 = bon02 OR bon02 = '*')
      AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
      AND bonacti = 'Y'
      ORDER BY 1,2                 
           
  FOREACH p500_plan_sub_c_1 INTO g_mps01,g_mps03
     IF STATUS THEN CALL cl_err('',STATUS,1) RETURN END IF  
#需求納入(1.訂單 2.預測 3.取最大)
     CASE
         WHEN incl_so = '1'
              SELECT SUM((mps041+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065))
                INTO l_short
                FROM mps_file
               WHERE mps_v=ver_no AND mps01=g_mps01 AND mps02='-'
                 AND mps03<=g_mps03
         WHEN incl_so = '2'
              SELECT SUM((mps039+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065))
                INTO l_short
                FROM mps_file
               WHERE mps_v=ver_no AND mps01=g_mps01 AND mps02='-'
                 AND mps03<=g_mps03
         WHEN incl_so = '3'
              SELECT SUM((mps041+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065)),
                     SUM((mps039+mps043+mps044)   #需求 - 供給
                -(mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065))
                INTO l_short,l_short2
                FROM mps_file
               WHERE mps_v=ver_no AND mps01=g_mps01 AND mps02='-'
                 AND mps03<=g_mps03
              IF l_short2>l_short THEN LET l_short=l_short2 END IF
     END CASE
 
     IF l_short IS NULL THEN LET l_short=0 END IF
     IF l_short<=0 THEN CONTINUE FOREACH END IF	#若不足才找替代
     DECLARE p500_plan_sub_c5 CURSOR FOR
       SELECT mpt03,mpt04,mpt06,mpt061,mpt07,mpt08 FROM mpt_file
        WHERE mpt_v=ver_no AND mpt01=g_mps01 AND mpt02='-' AND mpt03<=g_mps03
          AND mpt05 IN ('43','44','45')   #備料
        ORDER BY 1 DESC, 2, 5, 3
     FOREACH p500_plan_sub_c5 INTO g_mpt03,g_mpt04,g_mpt06,g_mpt061,
                                   g_mpt07,g_mpt08
       IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF  
       SELECT SUM(sub_qty) INTO xx FROM sub_tmp
         WHERE sub_partno=g_mps01 AND sub_wo_no=g_mpt06 AND sub_prodno=g_mpt07
       IF xx IS NULL THEN LET xx=0 END IF
       LET g_mpt08=g_mpt08 - xx
       IF g_mpt08 <= 0 THEN CONTINUE FOREACH END IF
       #------------------------------------------ 取該料+工單已被計算部份
       IF l_short<g_mpt08 THEN LET g_mpt08=l_short END IF
       DECLARE p500_plan_sub_c4 CURSOR FOR
        SELECT distinct bon_file.* FROM bon_file,ima_file,bmb_file,part_tmp
         WHERE bmb03 = bon01 AND bmb16 = '7'
		       AND (bmb01 = bon02 or bon02 = '*')   		  
           AND bon01 = g_mps01 AND (bon02 = g_mpt07 OR bon02 = '*')
           AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
           AND partno = ima01
           AND imaacti='Y' AND bonacti = 'Y'              
           ORDER BY bon03      
       FOREACH p500_plan_sub_c4 INTO bon.*
         IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF          
  
         DECLARE p500_plan_sub_ima01 CURSOR FOR 
          SELECT DISTINCT ima01 FROM ima_file,bon_file,bmb_file,part_tmp
           WHERE imaacti = 'Y' and ima37 = '1' AND ima139 = 'Y'
             AND partno = bon01 
             AND bmb03 = bon01 AND bmb16 = '7'
	           AND (bmb01 = bon02 or bon02 = '*') 
             AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
             AND bonacti = 'Y'
             AND ima251 = bon06
             AND ima022 BETWEEN bon04 AND bon05
             AND ima109 = bon07 
             AND ima54 = bon08 
             AND ima01 != bon01
                                             
         FOREACH p500_plan_sub_ima01 INTO g_ima01
            SELECT SUM(mps051+mps052+mps061+mps062+mps063+mps064+mps065)
              INTO b1					# QOH/PR/PO 供給合計
              FROM mps_file
             WHERE mps_v=ver_no AND mps02='-'
               AND mps03<=g_mpt03
               AND mps01 = g_ima01       
 
#需求納入(1.訂單 2.預測 3.取最大)
         CASE
            WHEN incl_so = '1'
                 SELECT SUM(mps041+mps043+mps044-mps053)
                   INTO b2			# 需求(+替代需求)合計
                   FROM mps_file
                  WHERE mps_v=ver_no AND mps02='-'
                    AND mps03<=g_mps03
                    AND mps01 = g_ima01                              
            WHEN incl_so = '2'
                 SELECT SUM(mps039+mps043+mps044-mps053)
                   INTO b2			# 需求(+替代需求)合計
                  FROM mps_file
                  WHERE mps_v=ver_no AND mps02='-'
                   AND mps03<=g_mps03
                   AND mps01 = g_ima01                              
           WHEN incl_so = '3'
                 SELECT SUM(mps041+mps043+mps044-mps053),
                        SUM(mps039+mps043+mps044-mps053)
                   INTO b2,b22			# 需求(+替代需求)合計
                   FROM mps_file
                  WHERE mps_v=ver_no AND mps02='-'
                    AND mps03<=g_mps03
                    AND mps01 = g_ima01                              
                 IF b22>b2 THEN LET b2=b22 END IF
         END CASE
 
         IF b1 IS NULL THEN LET b1=0 END IF
         IF b2 IS NULL THEN LET b2=0 END IF
         LET l_bal=b1-b2
         IF l_bal<=0 THEN CONTINUE FOREACH END IF
         IF g_mpt08*bon.bon11 > l_bal
            THEN LET g_sub_qty=l_bal
            ELSE LET g_sub_qty=g_mpt08*bon.bon11
         END IF
         #-------------------------------- 統計該料+工單已被計算部份,存入sub_tmp
         UPDATE sub_tmp SET sub_qty=sub_qty+g_sub_qty
          WHERE sub_partno=g_mps01 AND sub_wo_no=g_mpt06 AND sub_prodno=g_mpt07
         IF SQLCA.SQLERRD[3]=0 THEN
            INSERT INTO sub_tmp (sub_partno, sub_wo_no, sub_prodno, sub_qty)
                                VALUES(g_mps01, g_mpt06, g_mpt07, g_sub_qty)
         END IF
         #---------------------------------------------------------------------
         LET bmd.bmd04 = g_ima01
         LET bmd.bmd07 = bon.bon11
         CALL u_sub_1()	# 更新替代件
         CALL u_sub_2()	# 更新被替代件
         LET g_mpt08=g_mpt08-g_sub_qty/bon.bon11
         LET l_short=l_short-g_sub_qty/bon.bon11
         IF g_mpt08 <= 0 THEN 
            EXIT FOREACH 
         END IF 
         IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF              
        END FOREACH  
         IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF          
       END FOREACH
       IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF  
       IF l_short <= 0 THEN EXIT FOREACH END IF
     END FOREACH
     IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF  
  END FOREACH
  IF STATUS THEN CALL cl_err('',STATUS,1) END IF  
END FUNCTION
#FUN-A40002 --end--
 
FUNCTION msg(p_msg)		# 非 Background 狀態, 才可顯示 message            #FUN-A20037
   DEFINE p_msg		LIKE type_file.chr1000  #NO.FUN-680101  VARCHAR(60)
   LET mpl.mpl_v=ver_no
   LET mpl.mpl01=TODAY
   LET g_time = TIME        #No.FUN-6A0081
   LET mpl.mpl02=g_time     #No.FUN-6A0081
   LET mpl.mpl03=p_msg
   LET mpl.mplplant=g_plant #FUN-980005
   LET mpl.mpllegal=g_legal #FUN-980005
   INSERT INTO mpl_file VALUES(mpl.*)
   IF cl_null(g_argv1) THEN
       IF g_bgjob = 'N' THEN  #NO.FUN-570126
           MESSAGE p_msg CLIPPED
       END IF
   END IF
END FUNCTION
 
FUNCTION err(p_msg,err_code,p_n)
   DEFINE p_msg    	LIKE type_file.chr1000, #NO.FUN-680101  VARCHAR(80)
          err_code	LIKE ze_file.ze01,      #NO.FUN-680101  VARCHAR(7)
          err_coden	LIKE type_file.num10,   #NO.FUN-680101  INTEGER
          p_n   	LIKE type_file.num5,    #NO.FUN-680101  SMALLINT
          l_errmsg      LIKE type_file.chr1000, #NO.FUN-680101  VARCHAR(70)
          l_sqlerrd ARRAY[6] OF LIKE type_file.num10,   #NO.FUN-680101  INTEGER
          l_chr    	LIKE type_file.chr1    #NO.FUN-680101  VARCHAR(1)
 
 
   LET g_err_cnt=g_err_cnt+1
   IF NOT cl_null(g_argv1) THEN
      LET mpl.mpl_v=ver_no
      LET mpl.mpl01=TODAY
      LET g_time = TIME      #No.FUN-6A0081
      LET mpl.mpl02=g_time   #No.FUN-6A0081
      LET mpl.mpl03=p_msg CLIPPED,' ',err_code
      LET mpl.mplplant=g_plant #FUN-980005
      LET mpl.mpllegal=g_legal #FUN-980005
      INSERT INTO mpl_file VALUES(mpl.*)
      RETURN
   END IF
   LET l_sqlerrd[1] = SQLCA.sqlerrd[1]
   LET l_sqlerrd[2] = SQLCA.sqlerrd[2]
   LET l_sqlerrd[3] = SQLCA.sqlerrd[3]
   LET l_sqlerrd[4] = SQLCA.sqlerrd[4]
   LET l_sqlerrd[5] = SQLCA.sqlerrd[5]
   LET l_sqlerrd[6] = SQLCA.sqlerrd[6]
   LET l_errmsg = NULL
   SELECT ze03 INTO l_errmsg FROM ze_file
    WHERE ze01 = err_code AND ze02 = g_lang
   IF SQLCA.sqlcode and err_numchk(err_code)
      THEN LET err_coden = err_code
           LET l_errmsg = err_get(err_coden)
   END IF
   IF l_errmsg IS NULL THEN LET l_errmsg = 'Unknown error code!' END IF
   IF err_code IS NULL THEN
       IF (g_bgjob = "Y") THEN
           LET l_errmsg = ' ',p_msg CLIPPED,' ',l_errmsg
           CALL cl_batch_bg_msg_log(l_errmsg)
       ELSE
           ERROR ' ',p_msg CLIPPED,' ',l_errmsg
       END IF
   ELSE
       IF (g_bgjob = "Y") THEN
           LET l_errmsg = '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg
           CALL cl_batch_bg_msg_log(l_errmsg)
       ELSE
           ERROR '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg
       END IF
   END IF
 
    IF (p_n = 1) AND (g_bgjob = "N") THEN        #No.FUN-570126
        PROMPT 'press any key to continue:' FOR CHAR l_chr
           IF l_chr = '1' THEN
              PROMPT err_code CLIPPED,
                 ' 1:',l_sqlerrd[1],' 2:',l_sqlerrd[2],' 3:',l_sqlerrd[3],
                 ' 4:',l_sqlerrd[4],' 5:',l_sqlerrd[5],' 6:',l_sqlerrd[6],
                 ' <cr>:'FOR CHAR l_chr
           END IF
   END IF
   IF p_n > 1 THEN
      SLEEP p_n
   END IF
END FUNCTION
 
FUNCTION err_numchk(err_code)
   DEFINE err_code LIKE ze_file.ze01       #NO.FUN-680101  VARCHAR(7)
   DEFINE i        LIKE type_file.num5     #NO.FUN-680101  SMALLINT
   FOR i = 1 TO 7
      IF cl_null(err_code[i,i]) OR
         err_code[i,i] MATCHES "[-0123456789]"
         THEN CONTINUE FOR
         ELSE RETURN FALSE
      END IF
   END FOR
   RETURN TRUE
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14



