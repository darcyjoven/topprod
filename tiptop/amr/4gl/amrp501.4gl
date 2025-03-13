# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrp501.4gl
# Descriptions...: MRP 計劃模擬
# Date & Author..: 96/05/25 By Roger
# Modify.........: #NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: NO.MOD-4C0101 04/12/17  by pengu 修改報表檔案產生模式
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-660123 06/06/26 By Clinton 日期調整
# Modify.........: No.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號改為char(16)
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690047 06/09/27 By Sarah 抓取請購單、採購單資料時,需將pml38='Y',pmn38='Y'條件加入
# Modify.........: No.FUN-6A0012 06/10/16 By Sarah 算受訂量時，合約數量不納入(串oea_file的條件加上oea00<>'0')
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940083 09/05/14 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:MOD-9C0233 09/12/19 By jan mstlegel-->mstlegal
# Modify.........: No.TQC-970269 09/12/29 By baofei 取消MARK CALL p501_c_part_tmp3()
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:FUN-A40023 10/04/07 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A70034 10/07/23 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:TQC-C20222 12/02/20 By xujing  增加p500_declare() 中 insert mst09 
# Modify.........: No:CHI-C80041 13/02/06 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE msr		RECORD LIKE msr_file.*
DEFINE msl		RECORD LIKE msl_file.*
DEFINE mss		RECORD LIKE mss_file.*
DEFINE mst		RECORD LIKE mst_file.*
DEFINE msa		RECORD LIKE msa_file.*
DEFINE msb		RECORD LIKE msb_file.*
DEFINE bma		RECORD LIKE bma_file.*
DEFINE bmb		RECORD LIKE bmb_file.*
DEFINE bmb1		RECORD LIKE bmb_file.*
DEFINE bmb2		RECORD LIKE bmb_file.*
DEFINE bmb3		RECORD LIKE bmb_file.*
DEFINE bmb4		RECORD LIKE bmb_file.*
DEFINE bmd		RECORD LIKE bmd_file.*
DEFINE rpc		RECORD LIKE rpc_file.*
DEFINE ver_no  		LIKE msl_file.msl_v      #NO.FUN-680082 VARCHAR(2)
DEFINE lot_type		LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
DEFINE lot_bm		LIKE type_file.num5      #NO.FUN-680082 SMALLINT
DEFINE lot_no1		LIKE type_file.chr20     #NO.FUN-680082 VARCHAR(20)
DEFINE lot_no2		LIKE type_file.chr20     #NO.FUN-680082 VARCHAR(20)
DEFINE past_date  	LIKE type_file.dat       #NO.FUN-680082 DATE 
DEFINE bdate,edate	LIKE type_file.dat       #NO.FUN-680082 DATE
DEFINE buk_type		LIKE type_file.chr1  	 # Bucket Type   #NO.FUN-680082 VARCHAR(1)
DEFINE buk_code		LIKE rpg_file.rpg01      # Bucket code   #NO.FUN-680082 VARCHAR(4)
DEFINE po_days		LIKE ima_file.ima72      # Reschedule days    #NO.FUN-680082 INTEGER		
DEFINE wo_days		LIKE ima_file.ima72      # Reschedule days    #NO.FUN-680082 INTEGER	
DEFINE incl_id 		LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
DEFINE incl_so 		LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
DEFINE msb_expl		LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)  # msb_file explosing flag
DEFINE mss_expl		LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)  # mss_file explosing flag
DEFINE sub_flag		LIKE type_file.chr1  	 #NO.FUN-680082 VARCHAR(1)
DEFINE qvl_flag		LIKE type_file.chr1  	 #NO.FUN-680082 VARCHAR(1)
DEFINE qvl_bml03	LIKE bml_file.bml03      #NO.FUN-680082 SMALLINT
DEFINE g_msp01          LIKE msp_file.msp01
DEFINE g_sql            STRING  # 限定倉別       #No.FUN-580092 HCN  
DEFINE g_sql1           STRING  # 限定單據別     #No.FUN-580092 HCN 
DEFINE g_sql2           STRING  # 限定指送地址   #No.FUN-580092 HCN 
DEFINE g_sql3           STRING  # 限定指送地址   #No.FUN-580092 HCN 
DEFINE g_sql4           STRING  # 限定指送地址   #No.FUN-580092 HCN 
DEFINE g_sql5           STRING  #No.FUN-580092 HCN   
DEFINE g_before_input_done   STRING
DEFINE needdate  	LIKE type_file.dat        # MRP Need Date #NO.FUN-680082 DATE		
DEFINE i,j,k		LIKE type_file.num10      #NO.FUN-680082 INTEGER
DEFINE g_qty,g_nopen	LIKE sfb_file.sfb08       #NO.FUN-680082 DEC(15,3)
DEFINE g_mss00		LIKE mss_file.mss00       #NO.FUN-680082 INTEGER
DEFINE g_mss01		LIKE mss_file.mss01       #NO.MOD-490217
DEFINE g_mss03		LIKE mss_file.mss03       #NO.FUN-680082 DATE
DEFINE g_mst03		LIKE mst_file.mst03       #NO.FUN-680082 DATE
DEFINE g_mst04		LIKE mst_file.mst04       #NO.FUN-680082 DATE
DEFINE g_mst06		LIKE mst_file.mst06       #NO.FUN-680082 VARCHAR(20)
DEFINE g_mst061		LIKE mst_file.mst061      #NO.FUN-680082 SMALLINT
DEFINE g_mst07		LIKE mst_file.mst07       #NO.MOD-490217
DEFINE g_mst08		LIKE mst_file.mst08       #NO.FUN-680082 DEC(15,3)
DEFINE g_argv1		LIKE msl_file.msl_v       #NO.FUN-680082 VARCHAR(2)
DEFINE g_err_cnt	LIKE type_file.num10      #NO.FUN-680082 INTEGER
DEFINE g_n		LIKE type_file.num10      #NO.FUN-680082 INTEGER
DEFINE g_x_1		LIKE aab_file.aab02       #NO.FUN-680082 INTEGER
DEFINE g_ima16		LIKE type_file.num10      #NO.FUN-680082 INTEGER
DEFINE g_sub_qty	LIKE mst_file.mst08       #NO.FUN-680082 DEC(15,3)
DEFINE fz_flag		LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(1)
DEFINE g_sfa01		LIKE sfa_file.sfa01       #NO.FUN-680082 VARCHAR(10)
DEFINE g_sfb05		LIKE sfb_file.sfb05       #NO.MOD-490217
DEFINE g_sfb13		LIKE sfb_file.sfb13       #NO.FUN-680082 DATE
DEFINE g_eff_date	LIKE type_file.dat        #NO.FUN-680082 DATE
 
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose  #NO.FUN-680082 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000     #NO.FUN-680082 VARCHAR(72)
MAIN
   DEFINE   p_row,p_col  LIKE type_file.num5        #NO.FUN-680082 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   LET p_row = 3 LET p_col = 3
   OPEN WINDOW p501_w AT p_row,p_col
        WITH FORM "amr/42f/amrp501"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   LET ver_no  =''
   LET bdate   =NULL
   LET edate   =NULL
   WHILE TRUE
      CALL p501_ask()
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
      CALL cl_wait()
      CALL p501_mrp()
      ERROR ''
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      CALL cl_end(0,0)
      EXIT WHILE
   END WHILE
   CLOSE WINDOW p501_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION p501_wc_default()
   SELECT * INTO msr.* FROM msr_file WHERE msr_v=ver_no
   IF STATUS=0
      THEN LET lot_type=msr.lot_type
           LET lot_bm  =msr.lot_bm
           LET lot_no1 =msr.lot_no1
           LET lot_no2 =msr.lot_no2
           LET bdate   =msr.bdate
           LET edate   =msr.edate
           LET buk_type=msr.buk_type
           LET buk_code=msr.buk_code
           LET po_days =msr.po_days
           LET wo_days =msr.wo_days
           LET incl_id =msr.incl_id
           LET incl_so =msr.incl_so
           LET msb_expl=msr.msb_expl
           LET mss_expl=msr.mss_expl
           LET sub_flag=msr.sub_flag
           LET qvl_flag='N'
      ELSE LET lot_type='1'
           LET lot_bm  =99
           LET lot_no1 ='*'
           LET lot_no2 =NULL
           LET bdate   =TODAY
           LET edate   =TODAY+30
           LET buk_type=g_sma.sma22
           LET po_days =0
           LET wo_days =0
           LET incl_id='Y'
           LET incl_so='Y'
           LET msb_expl='Y'
           LET mss_expl='Y'
           LET sub_flag='Y'
           LET qvl_flag='N'
   END IF
END FUNCTION
 
FUNCTION p501_declare()		# DECLARE Insert Cursor
   DEFINE l_sql		STRING  #LIKE type_file.chr1000    #NO.FUN-680082 VARCHAR(3000)
 
   LET l_sql="INSERT INTO mst_file(mst_v, mst01, mst02, mst03, mst04, mst05, mst06, ", 
                                 " mst061,mst06_fz,mst07,mst08,mst09,mstplant,mstlegal) ", #MOD-9C0233  #TQC-C20222 mst09
                         " VALUES (?,?,?,?,?,?,?,?,?,?,?,?, ?,?)"                 #FUN-980004      #TQC-C20222

   PREPARE p501_p_ins_mst FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_mst',STATUS,1) END IF
   DECLARE p501_c_ins_mst CURSOR WITH HOLD FOR p501_p_ins_mst
   IF STATUS THEN CALL cl_err('dec ins_mst',STATUS,1) END IF
 
##--  declare cursor for update mss_file --##
   LET l_sql="UPDATE mss_file SET mss041=mss041+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss041 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss041',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss043=mss043+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss043 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss043',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss044=mss044+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss044 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss044',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss051=mss051+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss051 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss051',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss052=mss052+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss052 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss052',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss053=mss053+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss053 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss053',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss061=mss061+?,mss06_fz=mss06_fz+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss061 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss061',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss062=mss062+?,mss063=mss063+?,",
                                 "mss06_fz=mss06_fz+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss062 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss062',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss064=mss064+?,mss06_fz=mss06_fz+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss064 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss064',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss065=mss065+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p501_p_upd_mss065 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss065',STATUS,1) END IF
 
LET l_sql="UPDATE mss_file SET mss_v = ?,mss00 = ?,mss01 = ?,mss02 = ?,mss03 = ?,",
"                              mss041 = ?,mss043 = ?,mss044 = ?,mss051 = ?,mss052 = ?,",
"                              mss053 = ?,mss061 = ?,mss062 = ?,mss063 = ?,mss064 = ?,",
"                              mss065 = ?,mss06_fz = ?,mss071 = ?,mss072 = ?,mss08 = ?,",
"                              mss09 = ?,mss10 = ?,mss11 = ?,mss12 = ? ",
"           WHERE mss_v=? AND mss01 = ? AND mss02 = ? AND mss03 = ? "
   PREPARE p501_p_upd_mss FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss',STATUS,1) END IF
 
END FUNCTION
 
FUNCTION p501_mrp()
   CALL p501_get_sql()          # 組織字串 (限定倉別,單別,指送地址)
   CALL p501_ins_msr1()		# 版本記錄 begin
   CALL p501_del()		# 將原資料(mss,mst,msl,msk)清除
   CALL p501_c_buk_tmp()	# 產生時距檔
   CALL p501_c_part_tmp()	# 找出需 MRP 的料號
   CALL p501_declare()		# DECLARE Insert Cursor
   OPEN p501_c_ins_mst
   IF STATUS THEN CALL cl_err('open ins_mst',STATUS,1) END IF
   CALL p501_mss041()		# 彙總 獨立需求
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss042()		# 彙總 受訂量
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss043()		# 彙總 計劃備(MPS計劃 下階料)
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss044()		# 彙總 工單備(實際工單下階料)
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_c_part_tmp2()	# 找出需 MRP 的料號+廠商
   CALL p501_c_part_tmp3()	# 找出有替代的料號+替代料號+替代量  #TQC-970269
   CALL p501_mss051()		# ---> 庫存量
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss052()		# ---> 在驗量
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss061()		# ---> 請購量
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss062_63()	# ---> 採購量
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss064()		# ---> 在製量
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_mss065()		# ---> 計劃產
   FLUSH p501_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p501_plan()		# 提出規劃建議
   CLOSE p501_c_ins_mst
   CALL p501_ins_msr2()		# 版本記錄結束
END FUNCTION
 
FUNCTION p501_ask()
   DEFINE   l_n   LIKE type_file.num5          #NO.FUN-680082 SMALLINT
 
 
   INPUT BY NAME
      ver_no,lot_type,lot_bm,lot_no1,lot_no2,bdate,edate,
      buk_type,buk_code,po_days,wo_days,
      incl_id,incl_so,msb_expl,mss_expl,
      sub_flag,qvl_flag,g_msp01
      WITHOUT DEFAULTS
 
      BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL p501_set_entry()
           CALL p501_set_no_entry()
           LET g_before_input_done = TRUE
 
      AFTER FIELD ver_no
         IF ver_no IS NULL THEN
            NEXT FIELD ver_no
         END IF
         IF lot_type IS NULL THEN
            CALL p501_wc_default()
            DISPLAY BY NAME lot_type, lot_bm,   lot_no1 ,lot_no2  ,
                            bdate,    edate,
                            buk_type, buk_code,
                            po_days, wo_days,
                            incl_id,incl_so,msb_expl,mss_expl,
                            sub_flag
         END IF
 
      AFTER FIELD lot_type
         IF lot_type IS NULL THEN
            NEXT FIELD lot_type
         END IF
 
             CALL cl_qbe_init()
 
      BEFORE FIELD lot_no1
         CASE
            WHEN lot_type='1'
               CALL cl_err('','amr-104','1')
#              ERROR "請輸入MPS計劃 編號!"
            WHEN lot_type='2'
               CALL cl_err('','amr-105','1')
#              ERROR "請輸入實際工單編號!"
            WHEN lot_type='3'
               CALL cl_err('','amr-106','1')
#              ERROR "請輸入訂單編號!"
            WHEN lot_type='4'
               CALL cl_err('','amr-107','1')
#              ERROR "請輸入料號!"
            WHEN lot_type='5'
#              ERROR "請輸入料號!"
               CALL cl_err('','amr-107','1')
         END CASE
 
 
      AFTER FIELD lot_no1
         IF lot_no1 IS NULL THEN
            NEXT FIELD lot_no1
         END IF
 
      AFTER FIELD bdate
         IF bdate IS NULL THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF edate IS NULL THEN
            NEXT FIELD edate
         END IF
 
      BEFORE FIELD buk_type
         CALL p501_set_entry()
      AFTER FIELD buk_type
         CALL p501_set_no_entry()
 
      AFTER FIELD buk_code
        IF NOT cl_null(buk_code) THEN
           SELECT * FROM rpg_file WHERE rpg01 = buk_code
           IF STATUS THEN
               CALL cl_err3("sel","rpg_file",buk_code,"",STATUS,"","sel rpg:",0)        #NO.FUN-660107 
               NEXT FIELD buk_code
           END IF
        END IF
      AFTER FIELD msb_expl
         IF msb_expl IS NULL THEN
            NEXT FIELD msb_expl
         END IF
 
      AFTER FIELD mss_expl
         IF mss_expl IS NULL THEN
            NEXT FIELD mss_expl
         END IF
 
      AFTER FIELD g_msp01
         IF cl_null(g_msp01) THEN
            NEXT FIELD g_msp01
         END IF
         SELECT COUNT(*) INTO l_n FROM msp_file WHERE msp01 = g_msp01
         IF l_n=0 THEN
            CALL cl_err(g_msp01,100,0)
            NEXT FIELD g_msp01
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            RETURN
         END IF
         IF cl_null(g_msp01) THEN
            NEXT FIELD g_msp01
         END IF
         SELECT COUNT(*) INTO l_n FROM msp_file WHERE msp01 = g_msp01
         IF l_n=0 THEN
            CALL cl_err(g_msp01,100,0)
            NEXT FIELD g_msp01
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      RETURN
   END IF
   IF qvl_flag='Y' THEN
      LET qvl_bml03=1
   ELSE
      LET qvl_bml03=NULL
   END IF
 
END FUNCTION
FUNCTION p501_set_entry()
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("buk_code",TRUE)
   END IF
 
END FUNCTION
FUNCTION p501_set_no_entry()
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      IF buk_type!='1' THEN
         LET buk_code = NULL
         DISPLAY BY NAME buk_code
         CALL cl_set_comp_entry("buk_code",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p501_ins_msr1()
  DEFINE l_msr02   LIKE msr_file.msr02        #NO.FUN-680082 VARCHAR(8)
 
   CALL msg(" Start .....")
   INITIALIZE msr.* TO NULL
   LET msr.msr_v    =ver_no
   LET msr.msr01    =TODAY
   LET l_msr02 = TIME
   LET msr.msr02    =l_msr02
   LET msr.msr05    =g_user
   LET msr.lot_type =lot_type
   LET msr.lot_bm   =lot_bm
   LET msr.lot_no1  =lot_no1
   LET msr.lot_no2  =lot_no2
   LET msr.bdate    =bdate
   LET msr.edate    =edate
   LET msr.buk_type =buk_type
   LET msr.buk_code =buk_code
   LET msr.po_days  =po_days
   LET msr.wo_days  =wo_days
   LET msr.incl_id  =incl_id
   LET msr.incl_so  =incl_so
   LET msr.msb_expl =msb_expl
   LET msr.mss_expl =mss_expl
   LET msr.sub_flag =sub_flag
   DELETE FROM msr_file WHERE msr_v=ver_no
   IF STATUS THEN CALL err('del msr',STATUS,1) END IF
   INSERT INTO msr_file VALUES(msr.*)
   IF STATUS THEN CALL err('ins msr',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_ins_msr2()
  DEFINE l_msr03    LIKE msr_file.msr03    #NO.FUN-680082 VARCHAR(8)
 
   CALL msg(" End .....")
   LET l_msr03 = TIME
   LET msr.msr03=l_msr03
   LET msr.msr04=g_mss00
   UPDATE msr_file SET
          msr03=msr.msr03,
          msr04=msr.msr04
          WHERE msr_v=ver_no
   IF STATUS THEN CALL err('upd msr',STATUS,1) END IF
   UPDATE sma_file SET sma21=TODAY WHERE sma00='0'
END FUNCTION
 
FUNCTION p501_del()
   CALL p501_del_mss()		# 將原資料(mss_file)清除
   CALL p501_del_mst() 		# 將原資料(mst_file)清除
   CALL p501_del_msl() 		# 將 Log  (msl_file)清除
   CALL p501_del_msk() 		# 將時距日(msk_file)清除
END FUNCTION
 
FUNCTION p501_del_mss()
   DELETE FROM mss_file WHERE mss_v=ver_no
   IF STATUS THEN CALL err('del mss',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_del_mst()
   DEFINE l_rowid       LIKE type_file.row_id   #chr18    #No.FUN-9A0068 FUN-A70120
   DECLARE del_mst_c CURSOR FOR
      SELECT rowid FROM mst_file WHERE mst_v=ver_no
   FOREACH del_mst_c INTO l_rowid
     DELETE FROM mst_file WHERE rowid=l_rowid
     IF STATUS THEN CALL err('del mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
   END FOREACH
END FUNCTION
 
FUNCTION p501_del_msl()
   DELETE FROM msl_file WHERE msl_v=ver_no
   IF STATUS THEN CALL err('del msl',STATUS,1) END IF
END FUNCTION
 
FUNCTION p501_del_msk()
   DELETE FROM msk_file WHERE msk_v=ver_no
   IF STATUS THEN CALL err('del msk',STATUS,1) END IF
END FUNCTION
 
FUNCTION p501_c_buk_tmp()	# 產生時距檔
  DEFINE d,d2	LIKE type_file.dat           #NO.FUN-680082 DATE
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
  IF STATUS THEN CALL err('create buk_tmp:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CASE WHEN buk_type = '1' CALL rpg_buk() RETURN
       WHEN buk_type = '2' LET past_date = bdate-1
       WHEN buk_type = '3' LET past_date = bdate-6
       WHEN buk_type = '4' LET past_date = bdate-10
       WHEN buk_type = '5' LET past_date = bdate-30
       OTHERWISE           LET past_date = bdate-1
  END CASE
  CALL p501_buk_date(past_date) RETURNING past_date
  FOR j = bdate TO edate
     LET d=j
     CALL p501_buk_date(d) RETURNING d2
     INSERT INTO buk_tmp VALUES(d,d2)
     IF STATUS THEN CALL err('ins buk_tmp:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
        EXIT PROGRAM END IF
  END FOR
END FUNCTION
 
FUNCTION p501_buk_date(d)
  DEFINE d,d2	LIKE type_file.dat       #NO.FUN-680082 DATE
  DEFINE x	LIKE type_file.chr8      #NO.FUN-680082 VARCHAR(8)
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
  INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, d2)
  RETURN d2
END FUNCTION
 
FUNCTION rpg_buk()
  DEFINE l_bucket ARRAY[36] OF LIKE type_file.num5     #NO.FUN-680082 SMALLINT
  DEFINE l_rpg    RECORD LIKE rpg_file.*
  DEFINE dd1,dd2  LIKE type_file.dat           #NO.FUN-680082 DATE
 
  SELECT * INTO l_rpg.* FROM rpg_file WHERE rpg01 = buk_code
  IF STATUS THEN 
   CALL cl_err3("sel","rpg_file",buk_code,"",STATUS,"","sel rpg:",1)        #NO.FUN-660107 
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
  INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, past_date)
 
  LET dd1=bdate LET dd2=bdate
  FOR i = 1 TO 12
   FOR j=1 TO l_bucket[i]
     INSERT INTO buk_tmp VALUES (dd1,dd2)
     LET dd1=dd1+1
   END FOR
   INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, dd2)
   LET dd2=dd2+l_bucket[i]
  END FOR
END FUNCTION
 
FUNCTION p501_c_part_tmp()			 # 找出需 MRP 的料號
  DEFINE l_sql		  LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(3000)
   DEFINE l_bmb03         LIKE bmb_file.bmb03    #NO.MOD-490217
  DEFINE l_sfa05	  LIKE sfa_file.sfa05    #NO.FUN-680082 VARCHAR(20)
  #-------------------------------------------------------- sub_tmp
  CREATE TEMP TABLE sub_tmp(
       sub_partno LIKE type_file.chr1000,
       sub_wo_no LIKE oea_file.oea01,
       sub_prodno LIKE type_file.chr20, 
       sub_qty LIKE ade_file.ade05)
  CASE g_lang
    WHEN '0'
      LET g_msg ="找出需 MRP 的料號檔(part_tmp)!"
    WHEN '2'
      LET g_msg ="找出需 MRP 的料號檔(part_tmp)!"
    OTHERWISE
      LET g_msg ="Find   MRP Itm#file(part_tmp)!"
  END CASE
  CALL msg(g_msg)
  #-------------------------------------------------------- part_tmp
  DROP TABLE part_tmp
  CREATE TEMP TABLE part_tmp(
                             partno LIKE type_file.chr1000)      
  IF STATUS THEN CALL err('create part_tmp:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CREATE UNIQUE INDEX part_tmp_i1 ON part_tmp(partno)
  IF STATUS THEN CALL err('index part_tmp:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CASE WHEN lot_type='1'
            LET l_sql="SELECT DISTINCT msb03",	# 主件
                      "  FROM msa_file,msb_file",
                      " WHERE (msa01 MATCHES '",lot_no1,"' OR ",
                      "        msa01 MATCHES '",lot_no2,"')",
                      "   AND msa03='N'",
                      "   AND msa05<>'X'", #CHI-C80041
                      "   AND msa01=msb01"
            LET l_sql = l_sql CLIPPED,g_sql3 CLIPPED
            LET l_sql = l_sql CLIPPED
            CALL p501_ins_part_tmp(l_sql)
            IF lot_bm=0 THEN EXIT CASE END IF
            LET l_sql="SELECT DISTINCT bmb03",	# 下階料
                      "  FROM msa_file,msb_file,bmb_file",
                      " WHERE (msa01 MATCHES '",lot_no1,"' OR ",
                      "        msa01 MATCHES '",lot_no2,"')",
                      "   AND msa03='N'",
                      "   AND msa05<>'X'", #CHI-C80041
                      "   AND msa01=msb01",
                      "   AND msb03=bmb01",
                      "   AND bmb04<=msb07",
                      "   AND (bmb05 IS NULL OR bmb05>msb07)",
                      "   AND bmb03 IS NOT NULL"
            LET l_sql = l_sql CLIPPED,g_sql3 CLIPPED
            LET l_sql = l_sql CLIPPED
            CALL p501_ins_part_tmp(l_sql)
       WHEN lot_type='2'
            LET l_sql="SELECT DISTINCT sfb05",	# 主件
                      "  FROM sfb_file",
                      " WHERE (sfb01 MATCHES '",lot_no1,"' OR ",
                      "        sfb01 MATCHES '",lot_no2,"')",
                      "   AND sfb04 <> '8' AND sfb87!='X'"
            CALL p501_ins_part_tmp(l_sql)
            IF lot_bm=0 THEN EXIT CASE END IF
            LET l_sql="SELECT DISTINCT sfa03 FROM sfa_file,sfb_file",	# 下階料
                      " WHERE (sfb01 MATCHES '",lot_no1,"' OR ",
                      "        sfb01 MATCHES '",lot_no2,"')",
                      "   AND sfa05 IS NOT NULL AND sfb87!='X'",
                      "   AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04 <> '8'"
            CALL p501_ins_part_tmp(l_sql)
       WHEN lot_type='3'
            LET l_sql="SELECT DISTINCT oeb04",	# 主件
                      "  FROM oeb_file, oea_file",
                      " WHERE (oeb01 MATCHES '",lot_no1,"' OR ",
                      "        oeb01 MATCHES '",lot_no2,"')",
                      "   AND oeb12>oeb24",
                      "   AND oeb70='N'",
                      "   AND oeb01=oea01 AND oeaconf='Y'",
                      "   AND oea00<>'0'"   #FUN-6A0012 add
            CALL p501_ins_part_tmp(l_sql)
       WHEN lot_type='4'
            LET l_sql="SELECT DISTINCT ima01",	# 主件
                      "  FROM ima_file",
                      " WHERE ima37 IN ('1','2','3','4')",
                      "   AND imaacti='Y'",
                      "   AND (ima01 MATCHES '",lot_no1,"' OR ",
                      "        ima01 MATCHES '",lot_no2,"')"
            CALL p501_ins_part_tmp(l_sql)
       WHEN lot_type='5'
            LET l_sql="SELECT DISTINCT ima01",	# 主件
                      "  FROM ima_file",
                      " WHERE ima37 IN ('1','2','3','4')",
                      "   AND imaacti='Y'",
                      "   AND ima92 ='Y'",
                      "   AND (ima01 MATCHES '",lot_no1,"' OR ",
                      "        ima01 MATCHES '",lot_no2,"')"
            CALL p501_ins_part_tmp(l_sql)
  END CASE
END FUNCTION
 
FUNCTION p501_ins_part_tmp(p_sql)
   DEFINE p_sql   	 LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(2000)
   DEFINE l_ima08	 LIKE ima_file.ima08     #NO.FUN-680082 VARCHAR(1)
    DEFINE l_partno      LIKE msb_file.msb03     #NO.MOD-490217	
 
   LET p_sql = p_sql CLIPPED
   PREPARE p501_ins_tmp_p FROM p_sql
   DECLARE p501_ins_tmp_c CURSOR FOR p501_ins_tmp_p
   LET g_n=0
   FOREACH p501_ins_tmp_c INTO l_partno
     IF STATUS THEN CALL err('ins_tmp_c:',STATUS,1) EXIT FOREACH END IF
     INSERT INTO part_tmp VALUES(l_partno)
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        MESSAGE g_n
        CALL ui.Interface.refresh()
     END IF
     IF lot_bm>0 THEN
        CALL p501_bom1(0,l_partno)
     END IF
   END FOREACH
   #No.FUN-A70034  --Begin
   #IF STATUS THEN CALL err('ins_tmp_c:',STATUS,1) END IF
   #No.FUN-A70034  --End  
   IF sub_flag='N' THEN RETURN END IF
   DECLARE p501_ins_tmp_c2 CURSOR FOR
     SELECT bmd04 FROM part_tmp, bmd_file, ima_file
           WHERE partno=bmd01 AND bmd04=ima01
             AND imaacti='Y'
             AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
             AND bmdacti = 'Y'                                           #CHI-910021
   FOREACH p501_ins_tmp_c2 INTO l_partno
     IF STATUS THEN CALL cl_err('fore ins_tmp_c2',STATUS,1) EXIT FOREACH END IF
     INSERT INTO part_tmp VALUES(l_partno)
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        MESSAGE g_n
        CALL ui.Interface.refresh()
     END IF
   END FOREACH
   #No.FUN-A70034  --Begin
   #IF STATUS THEN CALL cl_err('fore ins_tmp_c2',STATUS,1) END IF
   #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_bom1(p_level,p_key)
   DEFINE p_level     LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          p_key       LIKE bma_file.bma01,   #主件料件編號
          l_ac,i      LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          arrno       LIKE type_file.num5,   #BUFFER SIZE (可存筆數)   #NO.FUN-680082 SMALLINT
          sr DYNAMIC ARRAY OF RECORD         #每階存放資料
               bmb03 LIKE bmb_file.bmb03,    #元件料號
               bma01 LIKE bma_file.bma01     #NO.MOD-490217
          END RECORD,
          l_sql       LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
    LET p_level = p_level + 1
    IF p_level > lot_bm THEN RETURN END IF
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01",
               " FROM bmb_file, OUTER bma_file",
               " WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01"
    PREPARE p501_ppp FROM l_sql
    DECLARE p501_cur CURSOR FOR p501_ppp
    LET l_ac = 1
    FOREACH p501_cur INTO sr[l_ac].*  # 先將BOM單身存入BUFFER
       IF STATUS THEN CALL cl_err('fore p501_cur:',STATUS,1) EXIT FOREACH END IF
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    #No.FUN-A70034  --Begin
    #IF STATUS THEN CALL cl_err('fore p501_cur:',STATUS,1) END IF
    #No.FUN-A70034  --End  
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb03 clipped
        CALL ui.Interface.refresh()
        INSERT INTO part_tmp VALUES(sr[i].bmb03)
        IF STATUS THEN CONTINUE FOR END IF
        LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
        IF g_x_1[5,6]='00' THEN
           MESSAGE g_n
           CALL ui.Interface.refresh()
        END IF
 
        IF sr[i].bma01 IS NOT NULL THEN
           CALL p501_bom1(p_level,sr[i].bmb03)
        END IF
    END FOR
END FUNCTION
 
FUNCTION p501_mss_0()	# mss_file 歸 0
   LET mss.mss_v =ver_no
   LET mss.mss041=0
   LET mss.mss043=0
   LET mss.mss044=0
   LET mss.mss051=0
   LET mss.mss052=0
   LET mss.mss053=0
   LET mss.mss061=0
   LET mss.mss062=0
   LET mss.mss063=0
   LET mss.mss064=0
   LET mss.mss065=0
   LET mss.mss06_fz=0
   LET mss.mss071=0
   LET mss.mss072=0
   LET mss.mss08 =0
   LET mss.mss09 =0
   LET mss.mss10 ='N'
   LET mss.mss11 =NULL
END FUNCTION
 
FUNCTION p501_mss040()	#  ---> 安全庫存需求
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss040(彙總安全庫存需求)!"
    WHEN '2'
      LET g_msg ="_mss040(彙總安全庫存需求)!"
    OTHERWISE
      LET g_msg ="_mss040(Sum SafeStockReq)!"
  END CASE
  CALL msg(g_msg)
   DECLARE p501_ima27_c CURSOR FOR
      SELECT ima01, ima27 FROM ima_file,part_tmp
       WHERE ima01=partno AND ima27 > 0
   CALL p501_mss_0()
   FOREACH p501_ima27_c INTO mss.mss01, mss.mss041
     IF STATUS THEN CALL err('p501_ima27_c',STATUS,1) RETURN END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF mss.mss041 IS NULL THEN LET mss.mss041=0 END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=NULL     	# 日期
     LET mst.mst05='40'		# 供需類別
     LET mst.mst06=NULL		# 單號
     LET mst.mst061=NULL	# 項次
     LET mst.mst06_fz=NULL	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
   END FOREACH
   #No.FUN-A70034  --Begin
   #IF STATUS THEN CALL err('p501_ima27_c',STATUS,1) RETURN END IF
   #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss041()	# 彙總 獨立需求量
  DEFINE l_rpc02	LIKE rpc_file.rpc02    #NO.FUN-680082 VARCHAR(10)
  DEFINE l_rpc12	LIKE rpc_file.rpc12    #NO.FUN-680082 DATE
  IF incl_id = 'N' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss041(彙總受訂量)!"
    WHEN '2'
      LET g_msg ="_mss041(彙總受訂量)!"
    OTHERWISE
      LET g_msg ="_mss041(SumOrdQty.)!"
  END CASE
  CALL msg(g_msg)
  DECLARE p501_rpc_c CURSOR FOR
     SELECT rpc02, rpc01, rpc12, rpc13-rpc131 FROM rpc_file,part_tmp
      WHERE rpc01=partno AND rpc13>rpc131 AND rpc12 <= edate
 
  CALL p501_mss_0()
  FOREACH p501_rpc_c INTO l_rpc02, mss.mss01, l_rpc12, mss.mss041
     IF STATUS THEN CALL err('p501_rpc_c:',STATUS,1) RETURN END IF
     IF mss.mss041 <= 0 OR mss.mss041 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF l_rpc12 >= bdate THEN
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_rpc12
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=l_rpc12	# 日期
     LET mst.mst05='41'		# 供需類別
     LET mst.mst06=l_rpc02	# 單號
     LET mst.mst061=NULL	# 項次
     LET mst.mst06_fz=NULL	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034 #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_rpc_c:',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss042()	# 彙總 受訂量
  DEFINE l_oeb01	LIKE oeb_file.oeb01    #NO.FUN-680082 VARCHAR(10)
  DEFINE l_oeb15	LIKE oeb_file.oeb15    #NO.FUN-680082 DATE
  DEFINE l_sql          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
 
  IF incl_so = 'N' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss041(彙總受訂量)!"
    WHEN '2'
      LET g_msg ="_mss041(彙總受訂量)!"
    OTHERWISE
      LET g_msg ="_mss041(SumOrdQty.)!"
  END CASE
  CALL msg(g_msg)
## -(統一單位為庫存單位)-------
## 限定倉別 010710
## 限定出至境外倉訂單不納入
  LET l_sql = " SELECT oeb01, oeb04, oeb15, (oeb12-oeb24)*oeb05_fac ",
              "   FROM oeb_file,oea_file,part_tmp,OUTER imd_file,oay_file ",
              "  WHERE oeb04=partno AND oeb12>oeb24 AND oeb70='N' ",
              "    AND oeb15 <= '",edate,"' AND oeb01=oea01 AND oeaconf='Y'",
              "    AND oea00<>'0'",  #FUN-6A0012 add
              "    AND oeb_file.oeb09=imd_file.imd01 ",
              "    AND oeb01 like oayslip || '-%' AND (oaytype!='33' AND oaytype!='34')"    #No.FUN-550055
 
## 加上限定倉別
   LET l_sql = l_sql CLIPPED,g_sql CLIPPED,g_sql5 CLIPPED
 
   PREPARE p501_oeb_p FROM l_sql
   DECLARE p501_oeb_c CURSOR FOR p501_oeb_p
 
  CALL p501_mss_0()
  FOREACH p501_oeb_c INTO l_oeb01, mss.mss01, l_oeb15, mss.mss041
     IF STATUS THEN CALL err('p501_oeb_c:',STATUS,1) RETURN END IF
     IF mss.mss041 <= 0 OR mss.mss041 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF l_oeb15 >= bdate THEN
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_oeb15
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=l_oeb15	# 日期
     LET mst.mst05='42'		# 供需類別
     LET mst.mst06=l_oeb01	# 單號
     LET mst.mst061=NULL	# 項次
     LET mst.mst06_fz=NULL	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_oeb_c:',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss043()	# 彙總 計劃量 (MPS計劃 下階料)
  DEFINE l_ima59,l_ima60,l_ima61 LIKE ima_file.ima60 #NO.FUN-680082 DEC(9,3)
  DEFINE l_ima08	LIKE ima_file.ima08          #NO.FUN-680082 VARCHAR(1)
  DEFINE l_ima601	LIKE ima_file.ima601         #NO.FUN-840194
  DEFINE l_sql          LIKE type_file.chr1000       #NO.FUN-680082 VARCHAR(3000)
  DEFINE li_result      LIKE type_file.num5          #NO.CHI-690066 add
 
  IF msb_expl='N' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss043(彙總MPS計劃 下階料需求量)!"
    WHEN '2'
      LET g_msg ="_mss043(彙總MPS計劃 下階料需求量)!"
    OTHERWISE
      LET g_msg ="_mss043(Sum MPSPrj  LowCdRequQty)!"
  END CASE
  CALL msg(g_msg)
 
  LET l_sql = "SELECT msb_file.*,ima59,ima60,ima601,ima61 ", #No.FUN-840194 add ima601 #CHI-810015 mod #FUN-710073 add ima56
              "  FROM msb_file,msa_file, OUTER ima_file ",
              " WHERE msb01=msa01 AND msb04 <= '",edate,"' AND msa03='N' ",
              "   AND msa05<>'X'", #CHI-C80041
              "   AND msb_file.msb03=ima_file.ima01 ",
              "   AND msa02 MATCHES '*",g_msp01 CLIPPED,"*'"
 
  PREPARE p501_msb_p FROM l_sql
  DECLARE p501_msb_c CURSOR FOR p501_msb_p
 
  CALL p501_mss_0()
  FOREACH p501_msb_c INTO msb.*, l_ima59,l_ima60,l_ima601,l_ima61 #No.FUN-840194 add ima601  #CHI-810015 拿掉,l_ima56  #FUN-710073 add l_ima56
     IF STATUS THEN CALL err('p501_msb_c:',STATUS,1) RETURN END IF
 
     IF l_ima60 IS NULL THEN LET l_ima60=0 END IF
     IF l_ima61 IS NULL THEN LET l_ima61=0 END IF
     IF cl_null(g_argv1) THEN
        MESSAGE msb.msb01 CLIPPED
        CALL ui.Interface.refresh()
     END IF
     SELECT SUM(sfb08) INTO g_qty FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02 AND sfb87!='X'
     IF g_qty IS NULL THEN LET g_qty=0 END IF
     LET g_nopen = msb.msb05 - g_qty
     IF g_nopen <= 0 THEN CONTINUE FOREACH END IF
     LET msb.msb04=msb.msb04-(l_ima59+l_ima60/l_ima601*msb.msb05+l_ima61)  #No.FUN-840194 #CHI-810015 mark還原 # 推出開工日
     FOR g_i=1 TO 365
         LET li_result = 0
         CALL s_daywk(msb.msb04) RETURNING li_result
         IF li_result = 1 THEN  #0:非工作日 1:工作日 2:無資料
            EXIT FOR
         ELSE
            LET msb.msb04=msb.msb04-1  #向前一天
         END IF
     END FOR
     LET g_eff_date=msb.msb07
 
     CALL p501_mss044_bom('43',0,msb.msb03,g_nopen)
  END FOREACH
END FUNCTION
 
FUNCTION p501_mss043_ins()
       IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
       LET mss.mss03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
       LET needdate=msb.msb04 + bmb.bmb18
       IF needdate >= bdate THEN
          SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       LET mss.mssplant=g_plant #FUN-980004 add
       LET mss.msslegal=g_legal #FUN-980004 add
       INSERT INTO mss_file VALUES(mss.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
           CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
       END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss043 using mss.mss043,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
       END IF
       LET mst.mst_v=mss.mss_v	# 版本
       LET mst.mst01=mss.mss01	# 料號
       LET mst.mst02=mss.mss02	# 廠商
       LET mst.mst03=mss.mss03	# 日期
       LET mst.mst04=needdate	# 日期
       LET mst.mst05='43'	# 供需類別
       LET mst.mst06=msb.msb01	# 單號
       LET mst.mst061=msb.msb02	# 項次
       LET mst.mst06_fz=NULL	# 凍結否
       LET mst.mst07=msb.msb03	# 追索料號(上階半/成品)
       LET mst.mst08=mss.mss043	# 數量
       LET mst.mstplant=g_plant   #FUN-980004 add
       LET mst.mstlegal=g_legal   #FUN-980004 add
       IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
       PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                               mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034 #TQC-20222

       IF STATUS THEN CALL err('ins mst',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_mss044()	# 彙總 備料量
     DEFINE l_qty	LIKE mss_file.mss062    #NO.FUN-680082 DEC(15,3)
     DEFINE l_sfa29     LIKE sfa_file.sfa29
     DEFINE l_sql       LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(3000)
 
     #注意: sfa_file 應增加限定廠商欄位 (sfa31)(儲位), 於備料產生時賦予
     CASE g_lang
       WHEN '0'
         LET g_msg ="_mss044(彙總備料量)!"
       WHEN '2'
         LET g_msg ="_mss044(彙總備料量)!"
       OTHERWISE
         LET g_msg ="_mss044(Sum BakQty)!"
     END CASE
     CALL msg(g_msg)
     #----------------------------------------------------------------------
     #add by chien 01/07/02
     LET l_sql = " SELECT sfb01,sfa03,sfa31,sfb13,((sfa05-sfa06-sfa065)/sfa28)*sfa13,",
                 " sfb05,sfa29 ",
                 " FROM sfb_file,sfa_file,part_tmp,smy_file ",
                 " WHERE sfb01=sfa01 AND sfa03=partno ",
                 " AND sfb04!='8' AND sfb13<='",edate,"' AND sfa05>sfa06+sfa065 ",
                 " AND sfb23='Y' AND sfb87!='X'",#已備料工單 (取備料檔)
                 " AND sfb01 like smyslip || '-%'"     #No.FUN-550055
     LET l_sql = l_sql CLIPPED,g_sql1 CLIPPED#,g_sql1 CLIPPED
     LET l_sql = l_sql CLIPPED
     PREPARE p501_sfa_p1 FROM l_sql
     DECLARE p501_sfa_c1 CURSOR FOR p501_sfa_p1
     CALL p501_mss_0()
     FOREACH p501_sfa_c1 INTO g_sfa01,mss.mss01,mss.mss02,g_sfb13,mss.mss044,
                              g_sfb05,l_sfa29
       IF STATUS THEN CALL err('p501_sfa_c1',STATUS,1) RETURN END IF
       IF cl_null(g_argv1) THEN
          MESSAGE g_sfa01 CLIPPED
          CALL ui.Interface.refresh()
       END IF
       IF l_sfa29 != g_sfb05 THEN LET g_sfb05 = l_sfa29 END IF
       CALL p501_mss044_ins()
     END FOREACH
     #No.FUN-A70034  --Begin
     #IF STATUS THEN CALL err('p501_sfa_c1',STATUS,1) RETURN END IF
     #No.FUN-A70034  --End  
     #----------------------------------------------------------------------
     LET l_sql = " SELECT sfb01,sfb13,sfb08,sfb05,sfb071 ",#未備料工單(取BOM檔)
                 " FROM sfb_file,smy_file ",
                 " WHERE sfb04!='8' AND sfb13<'",edate,"' AND sfb23='N'",
                 " AND sfb01 like smyslip || '-%' AND sfb87!='X'"   #No.FUN-550055
     LET l_sql = l_sql CLIPPED,g_sql1 CLIPPED
     LET l_sql = l_sql CLIPPED
     PREPARE p501_sfa_p2 FROM l_sql
     DECLARE p501_sfa_c2 CURSOR FOR p501_sfa_p2
     CALL p501_mss_0()
     FOREACH p501_sfa_c2 INTO g_sfa01,g_sfb13,l_qty,g_sfb05,g_eff_date
       IF STATUS THEN CALL err('p501_sfa_c2',STATUS,1) RETURN END IF
       IF cl_null(g_argv1) THEN
          MESSAGE g_sfa01 CLIPPED
          CALL ui.Interface.refresh()
       END IF
       CALL p501_mss044_bom('44',0,g_sfb05,l_qty)
     END FOREACH
     #No.FUN-A70034  --Begin
     #IF STATUS THEN CALL err('p501_sfa_c2',STATUS,1) RETURN END IF
     #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss044_bom(p_sw,p_level,p_key,p_qty) 
#No.FUN-A70034  --Begin
   DEFINE l_total     LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA       LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA LIKE bmb_file.bmb06     #实际QPA
#No.FUN-A70034  --End  
   DEFINE p_sw	      LIKE msl_file.msl_v,   # 43:mss043 44:mss044  #NO.FUN-680082 VARCHAR(2)
          p_level     LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          p_key       LIKE bma_file.bma01,   #主件料件編號
          p_qty       LIKE bmb_file.bmb06,   #NO.FUN-680082 DEC(18,6)
          l_bmb01     LIKE bmb_file.bmb01,
          l_ac,i      LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          arrno       LIKE type_file.num5,   #BUFFER SIZE (可存筆數)#NO.FUN-680082 SMALLINT
          sr DYNAMIC ARRAY OF RECORD         #每階存放資料
              bmb03 LIKE bmb_file.bmb03,     #元件料號
              bml04 LIKE bml_file.bml04,     #指定廠牌
              bmb06 LIKE bmb_file.bmb06,     #FUN-560230
              bmb18 LIKE bmb_file.bmb18,     #投料時距
              ima08 LIKE ima_file.ima08,     #NO.FUN-680082 VARCHAR(01)
              bmb10_fac LIKE bmb_file.bmb10_fac,
              ima55     LIKE ima_file.ima55,
              bmb10     LIKE bmb_file.bmb10,
              #No.FUN-A70034  --Begin
              bmb08     LIKE bmb_file.bmb08,
              bmb081    LIKE bmb_file.bmb081,
              bmb082    LIKE bmb_file.bmb082
              #No.FUN-A70034  --End  
          END RECORD,
          l_sql       LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
      EXIT PROGRAM END IF
    LET p_level = p_level + 1 IF p_level > lot_bm THEN RETURN END IF
    LET arrno = 600
    DECLARE p501_44_c1 CURSOR FOR
          #No.FUN-A70034  --Begin
          #SELECT bmb03,bml04,bmb06/bmb07*(1+bmb08/100),bmb18,ima08,bmb10_fac,
          #       ima55,bmb10
          SELECT bmb03,bml04,bmb06/bmb07,bmb18,ima08,bmb10_fac,
                 ima55,bmb10,
                 bmb08,bmb081,bmb082
          #No.FUN-A70034  --End  
                 FROM bmb_file, ima_file, OUTER bml_file
                 WHERE bmb01=p_key AND bmb03=ima01
                   AND bmb04<=g_eff_date AND (bmb05 IS NULL OR bmb05>g_eff_date)
                   AND (bmb_file.bmb03=bml_file.bml01 AND bmb_file.bmb01=bml_file.bml02 AND bml_file.bml03=qvl_bml03
                    OR bmb_file.bmb03=bml_file.bml01 AND bml_file.bml02='ALL' AND bml_file.bml03=qvl_bml03)
    LET l_ac = 1
    FOREACH p501_44_c1 INTO sr[l_ac].*
             # 先將BOM單身存入BUFFER
       IF STATUS THEN CALL cl_err('fore p501_cur:',STATUS,1) EXIT FOREACH END IF
 
       #No.FUN-A70034  --Begin
       #LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       #No.FUN-A70034  --Begin
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    #No.FUN-A70034  --Begin
    #IF STATUS THEN CALL cl_err('fore p501_cur:',STATUS,1) END IF
    #No.FUN-A70034  --End  
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
       message p_level,' ',sr[i].bmb03 clipped
       CALL ui.Interface.refresh()
       #No.FUN-A70034  --Begin
       CALL cralc_rate(p_key,sr[i].bmb03,p_qty,sr[i].bmb081,sr[i].bmb08,sr[i].bmb082, 
                       sr[i].bmb06,0)
            RETURNING l_total,l_QPA,l_ActualQPA
       LET sr[i].bmb06 = l_total 
       #No.FUN-A70034  --End  
 
       IF sr[i].ima08='X'
          THEN
           CALL p501_mss044_bom(p_sw,p_level,sr[i].bmb03,sr[i].bmb06)
          ELSE
               SELECT partno FROM part_tmp WHERE partno=sr[i].bmb03
               IF STATUS THEN CONTINUE FOR END IF
               LET mss.mss01=sr[i].bmb03
               LET mss.mss02=sr[i].bml04
               LET bmb.bmb18=sr[i].bmb18
               IF cl_null(sr[i].bmb10_fac) THEN  LET sr[i].bmb10_fac=1 END IF
               IF p_sw='43'
                  THEN
##  -(統一單位為庫存單位)-------
                       LET mss.mss043=sr[i].bmb06 * sr[i].bmb10_fac
                       CALL p501_mss043_ins()
                  ELSE
##  -(統一單位為庫存單位)-------
                       LET mss.mss044=sr[i].bmb06 * sr[i].bmb10_fac
                       CALL p501_mss044_ins()
               END IF
       END IF
    END FOR
END FUNCTION
 
FUNCTION p501_mss044_ins()
       IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
       LET mss.mss03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
       LET needdate=g_sfb13 + bmb.bmb18
       IF needdate >= bdate THEN
          SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       LET mss.mssplant=g_plant #FUN-980004 add
       LET mss.msslegal=g_legal #FUN-980004 add
       INSERT INTO mss_file VALUES(mss.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
           CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
       END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss044 using mss.mss044,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
       END IF
       LET mst.mst_v=mss.mss_v	# 版本
       LET mst.mst01=mss.mss01	# 料號
       LET mst.mst02=mss.mss02	# 廠商
       LET mst.mst03=mss.mss03	# 日期
       LET mst.mst04=needdate	# 日期
       LET mst.mst05='44'	# 供需類別
       LET mst.mst06=g_sfa01	# 單號
       LET mst.mst061=NULL	# 項次
       LET mst.mst06_fz=NULL	# 凍結否
       LET mst.mst07=g_sfb05	# 追索料號(上階半/成品)
       LET mst.mst08=mss.mss044	# 數量
       LET mst.mstplant=g_plant   #FUN-980004 add
       LET mst.mstlegal=g_legal   #FUN-980004 add
       IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
       PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                               mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222
       IF STATUS THEN CALL err('ins mst',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_c_part_tmp2()		# 找出需 MRP 的料號+廠商
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
         partno LIKE type_file.chr1000,
         ven_no LIKE mss_file.mss02)    
  IF STATUS THEN CALL err('create part_tmp2:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  INSERT INTO part_tmp2
         SELECT DISTINCT mss01,mss02 FROM mss_file
          WHERE mss_v=ver_no
            AND mss01 IS NOT NULL AND mss02 IS NOT NULL AND mss02 <> '-'
  CREATE UNIQUE INDEX part_tmp2_i1 ON part_tmp2(partno,ven_no)
  IF STATUS THEN CALL err('index part_tmp2:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_c_part_tmp3()		# 找出有替代的正料號+替代料號+替代量
   DEFINE l_mst01        LIKE mst_file.mst01  #NO.MOD-490217
   DEFINE l_mst07	LIKE mst_file.mst07  #NO.MOD-490217
  CASE g_lang
    WHEN '0'
      LET g_msg ="找出有替代的正料號+替代料號+替代量!"
    WHEN '2'
      LET g_msg ="找出有替代的正料號+替代料號+替代量!"
    OTHERWISE
      LET g_msg ="Find has ChgNo By Itm#+ChgNo+ChgQty!"
  END CASE
  CALL msg(g_msg)
  DROP TABLE QOH_used
  CREATE TEMP TABLE QOH_used(
                             partno LIKE type_file.chr1000,
                             loc_no LIKE type_file.chr20)    
  IF STATUS THEN CALL err('create QOH_used:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CREATE UNIQUE INDEX QOH_used_i1 ON QOH_used(partno)
  IF STATUS THEN CALL err('index QOH_used:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  DROP TABLE part_tmp3
  CREATE TEMP TABLE part_tmp3(
         partno  LIKE mss_file.mss01,
         sub_no  LIKE mss_file.mss01,
         sub_qty LIKE type_file.num5)
  IF STATUS THEN CALL err('create part_tmp3:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  DECLARE p501_tmp3_c CURSOR FOR
          SELECT DISTINCT mst01,mst07 FROM mst_file
                 WHERE mst_v=ver_no
                   AND mst05 IN ('43','44') AND mst02='-'
  FOREACH p501_tmp3_c INTO l_mst01,l_mst07
    IF STATUS THEN CALL err('p501_tmp3_c:',STATUS,1) RETURN END IF
       INSERT INTO part_tmp3
            SELECT DISTINCT bmd01,bmd04,bmd07 FROM bmd_file,bmb_file
              WHERE bmd01=l_mst01 {AND bmd08='ALL'}
                AND bmb03=l_mst01 AND bmb01=l_mst07 AND bmb16 IN ('1','2')
                AND bmdacti = 'Y'                                           #CHI-910021
       IF STATUS THEN CALL err('ins2part_tmp3',STATUS,1) END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_tmp3_c:',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
  DROP TABLE x
  SELECT DISTINCT partno,sub_no,sub_qty FROM part_tmp3 INTO TEMP x
  DELETE FROM part_tmp3
  INSERT INTO part_tmp3 SELECT * FROM x	#隱藏問題:同料但不同替量時,會有多筆tmp
  IF STATUS THEN CALL err('ins3part_tmp3',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CREATE UNIQUE INDEX part_tmp3_i1 ON part_tmp3(partno,sub_no)
  IF STATUS THEN CALL err('index part_tmp3:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_mss051()	#  ---> 庫存量
   DEFINE l_img02	LIKE img_file.img02    #NO.FUN-680082 VARCHAR(10)
   DEFINE l_img03	LIKE img_file.img03    #NO.FUN-680082 VARCHAR(10)
   DEFINE l_sql         LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(3000)
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss051(彙總庫存量)!"
    WHEN '2'
      LET g_msg ="_mss051(彙總庫存量)!"
    OTHERWISE
      LET g_msg ="_mss051(Sum StkQty)!"
  END CASE
  CALL msg(g_msg)
   LET l_sql = "SELECT img01, img02, img03, SUM(img10*img21) ",   #MOD-940312
               "  FROM img_file,part_tmp,imd_file",
               " WHERE img01=partno AND img24='Y' ",
               "   AND imd01=img02 "
## 加上限定倉別
   LET l_sql = l_sql CLIPPED,g_sql CLIPPED
   LET l_sql = l_sql CLIPPED," GROUP BY img01,img02,img03"
 
   PREPARE p501_img_p1 FROM l_sql
   DECLARE p501_img_c1 CURSOR FOR p501_img_p1
 
   CALL p501_mss_0()
   FOREACH p501_img_c1 INTO mss.mss01, l_img02, l_img03, mss.mss051
     IF STATUS THEN CALL err('p501_img_c1',STATUS,1) RETURN END IF
     SELECT partno FROM QOH_used WHERE partno=mss.mss01 AND loc_no=l_img03
     IF STATUS	# 如果庫存先前已被MRP使用, 則不可再重複使用
        THEN INSERT INTO QOH_used VALUES(mss.mss01,l_img03)
        ELSE CONTINUE FOREACH
     END IF
     LET mss.mss02=l_img03
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
     LET mss.mss03=past_date
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss051 using mss.mss051,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=NULL     	# 日期
     LET mst.mst05='51'		# 供需類別
     LET mst.mst06=l_img02 CLIPPED,' ',l_img03	# 單號
     LET mst.mst061=NULL	# 項次
     LET mst.mst06_fz=NULL	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss051	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
   END FOREACH
   #No.FUN-A70034  --Begin
   #IF STATUS THEN CALL err('p501_img_c1',STATUS,1) RETURN END IF
   #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss052()	#  ---> 在驗量
   DEFINE l_rvb01	LIKE rvb_file.rvb01   #NO.FUN-680082 VARCHAR(10)
   DEFINE l_rvb02	LIKE rvb_file.rvb02   #NO.FUN-680082 SMALLINT
   DEFINE l_pmn09       LIKE pmn_file.pmn09   #採購單位/料件庫存單位的轉換率
   DEFINE l_pmn38       LIKE pmn_file.pmn38   #MPS/MRP可用   #FUN-690047 add
   DEFINE l_sql         LIKE type_file.chr1000#NO.FUN-680082 VARCHAR(1000)
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss051(彙總在驗量)!"
    WHEN '2'
      LET g_msg ="_mss051(彙總在驗量)!"
    OTHERWISE
      LET g_msg ="_mss051(Sum QC Qty)!"
  END CASE
  CALL msg(g_msg)
 
   LET l_sql = "SELECT rvb01,rvb02,rvb05, rva05, rvb31,pmn09 ",
               "      ,pmn38 ",   #FUN-690047 add
               "FROM rvb_file,rva_file,part_tmp,OUTER pmn_file,OUTER imd_file",
               " WHERE rvb05=partno AND rvb31>0 AND rvb01=rva01 ",
               "   AND rvb_file.rvb04=pmn_file.pmn01 ",
               "   AND rvb_file.rvb03=pmn_file.pmn02 ",
               "   AND rvaconf ='Y'",
               "   AND rvb_file.rvb36=imd_file.imd01 "
   LET l_sql = l_sql CLIPPED,g_sql CLIPPED
   PREPARE p501_rvb_p1 FROM l_sql
   DECLARE p501_rvb_c1 CURSOR FOR p501_rvb_p1
 
   CALL p501_mss_0()
   FOREACH p501_rvb_c1 INTO l_rvb01,l_rvb02,
                            mss.mss01,mss.mss02,mss.mss052,l_pmn09,l_pmn38   #FUN-690047 add l_pmn38
     IF STATUS THEN CALL err('p501_rvb_c1',STATUS,1) RETURN END IF
     IF l_pmn38!='Y' THEN CONTINUE FOREACH END IF   #FUN-690047 add
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
 
     IF cl_null(l_pmn09) THEN LET l_pmn09=1 END IF
     LET mss.mss052=mss.mss052*l_pmn09
 
     LET mss.mss03=past_date
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss052 using mss.mss052,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=NULL     	# 日期
     LET mst.mst05='52'		# 供需類別
     LET mst.mst06=l_rvb01	# 單號
     LET mst.mst061=l_rvb02	# 項次
     LET mst.mst06_fz=NULL	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss052	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
   END FOREACH
   #No.FUN-A70034  --Begin
   #IF STATUS THEN CALL err('p501_rvb_c1',STATUS,1) RETURN END IF
   #No.FUN-A70034  --End  
END FUNCTION
 
  ##NO.FUN-A40023   --begin
#FUNCTION p501_mss053()	#  ---> 替代料庫存量
#   DEFINE l_img01	LIKE img_file.img01   #NO.MOD-490217
#  DEFINE l_img03	LIKE img_file.img03   #NO.FUN-680082 VARCHAR(20)
#  DEFINE l_sql         LIKE type_file.chr1000#NO.FUN-680082 VARCHAR(1000) 
#
# CASE g_lang
#   WHEN '0'
#     LET g_msg ="_mss053(彙總替代料量)!"
#   WHEN '2'
#     LET g_msg ="_mss053(彙總替代料量)!"
#   OTHERWISE
#     LET g_msg ="_mss053(Sum ChgItmQty)!"
# END CASE
# CALL msg(g_msg)
#
#  LET l_sql = " SELECT partno, img01, img03, SUM(img10*img21) ",   #MOD-940312
#              "   FROM img_file,part_tmp3,imd_file ",
#              "  WHERE img01=sub_no AND img24='Y' ",
#              "    AND img02=imd01 "
#  LET l_sql = l_sql CLIPPED,g_sql CLIPPED
#  LET l_sql = l_sql CLIPPED," GROUP BY partno,img01,img03 "
#  PREPARE p501_img_p2 FROM l_sql
#  DECLARE p501_img_c2 CURSOR FOR p501_img_p2
#
#  CALL p501_mss_0()
#  FOREACH p501_img_c2 INTO mss.mss01,l_img01,l_img03,mss.mss053
#    IF STATUS THEN CALL err('p501_img_c2',STATUS,1) RETURN END IF
#    SELECT partno FROM QOH_used WHERE partno=l_img01 AND loc_no=l_img03
#    IF STATUS	# 如果庫存先前已被MRP使用, 則不可再重複使用
#       THEN INSERT INTO QOH_used VALUES(l_img01,l_img03)
#       ELSE CONTINUE FOREACH
#    END IF
#    LET mss.mss02='-'
#    LET mss.mss03=past_date
#    LET mss.mssplant=g_plant #FUN-980004 add
#    LET mss.msslegal=g_legal #FUN-980004 add
#    INSERT INTO mss_file VALUES(mss.*)
#    IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
#        CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
#    END IF
#    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
#       EXECUTE p501_p_upd_mss053 using mss.mss053,mss.mss_v,mss.mss01,
#                                       mss.mss02,mss.mss03
#       IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
#    END IF
#    LET mst.mst_v=mss.mss_v	# 版本
#    LET mst.mst01=mss.mss01	# 料號
#    LET mst.mst02=mss.mss02	# 廠商
#    LET mst.mst03=mss.mss03	# 日期
#    LET mst.mst04=NULL     	# 日期
#    LET mst.mst05='53'		# 供需類別
#    LET mst.mst06=NULL		# 單號
#    LET mst.mst061=NULL	# 項次
#    LET mst.mst06_fz=NULL	# 凍結否
#    LET mst.mst07=l_img01	# 追索料號(替代料號)
#    LET mst.mst08=mss.mss053	# 數量
#    LET mst.mstplant=g_plant   #FUN-980004 add
#    LET mst.mstlegal=g_legal   #FUN-980004 add
#    PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08
#    IF STATUS THEN CALL err('ins mst',STATUS,1) EXIT PROGRAM END IF
#  END FOREACH
#  IF STATUS THEN CALL err('p501_img_c2',STATUS,1) RETURN END IF
# END FUNCTION
  ##NO.FUN-A40023   --end 

FUNCTION p501_mss061()	# 彙總 請購量
  DEFINE l_pml01	LIKE pml_file.pml01    #NO.FUN-680082 VARCHAR(10)
  DEFINE l_pml02	LIKE pml_file.pml02    #NO.FUN-680082 SMALLINT 
  DEFINE l_pml33	LIKE pml_file.pml33    #NO.FUN-680082 DATE
  DEFINE l_pml35	LIKE pml_file.pml35    #NO.FUN-680082 DATE
  DEFINE l_pmk05	LIKE pmk_file.pmk05    #NO.FUN-680082 VARCHAR(10)
  DEFINE l_pml09	like pml_file.pml09    
  DEFINE l_pmk25	LIKE pmk_file.pmk25    #NO.FUN-680082 VARCHAR(1)
  DEFINE l_sql          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
 
  IF g_sma.sma56='3' THEN RETURN END IF
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss061(彙總請購量)!"
    WHEN '2'
      LET g_msg ="_mss061(彙總請購量)!"
    OTHERWISE
      LET g_msg ="_mss061(Sum RequQty  )!"
  END CASE
  CALL msg(g_msg)
  LET l_sql = "SELECT pml01,pml02,pml04,pml11,pml35,pml20-pml21,pmk05, ",
              "       pmk25,pml09 ",
              "  FROM pml_file,pmk_file,part_tmp,smy_file ",
              " WHERE pml04=partno AND pml20>pml21 AND pml16<='2' ",
              "   AND pml35<='",edate,"'",   #TQC-660123
              "   AND pml01=pmk01 AND pmk02<>'SUB' ",
              "   AND pml01 like smyslip || '-%'",
              "   AND pml38='Y'"   #FUN-690047 add  #可用/不可用
## 限定指送地點
  LET l_sql = l_sql CLIPPED ,g_sql1 CLIPPED,g_sql4 CLIPPED
  LET l_sql = l_sql CLIPPED
  PREPARE p501_pml_p FROM l_sql
  DECLARE p501_pml_c CURSOR FOR p501_pml_p
 
  CALL p501_mss_0()
  FOREACH p501_pml_c INTO l_pml01, l_pml02, mss.mss01, fz_flag, l_pml35,
                          mss.mss061, l_pmk05, l_pmk25,l_pml09
     IF STATUS THEN CALL err('p501_pml_c',STATUS,1) CONTINUE FOREACH END IF
     IF g_sma.sma56='2' AND l_pmk25 MATCHES '[X0]' THEN CONTINUE FOREACH END IF
     IF mss.mss061 <= 0 OR mss.mss061 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02=l_pmk05
 
     IF cl_null(l_pml09) THEN LET l_pml09=1 END IF
     LET mss.mss061=mss.mss061*l_pml09
 
     SELECT pmh07 INTO mss.mss02 FROM pmh_file
            WHERE pmh01=mss.mss01 AND pmh02=mss.mss02
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
     LET mss.mss03=past_date
     IF l_pml35 >= bdate THEN
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_pml35
        IF STATUS THEN RETURN END IF
     END IF
     IF fz_flag='Y'
        THEN LET mss.mss06_fz=mss.mss061
        ELSE LET mss.mss06_fz=0
     END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss061 using mss.mss061,mss.mss06_fz,
                                        mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=l_pml35	# 日期
     LET mst.mst05='61'		# 供需類別
     LET mst.mst06=l_pml01	# 單號
     LET mst.mst061=l_pml02	# 項次
     LET mst.mst06_fz=fz_flag	# 凍結否
     LET mst.mst07=l_pmk05	# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss061	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034   #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_pml_c',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss062_63()	# 彙總 採購量
  DEFINE l_pmn01	LIKE pmn_file.pmn01    #NO.FUN-680082 VARCHAR(10) 
  DEFINE l_pmn02	LIKE pmn_file.pmn02    #NO.FUN-680082 SMALLINT
  DEFINE l_pmn33	LIKE pmn_file.pmn33    #NO.FUN-680082 DATE
  DEFINE l_pmn35	LIKE pmn_file.pmn35    #TQC-660123    #NO.FUN-680082 DATE
  DEFINE l_pmn16	LIKE pmn_file.pmn16    #NO.FUN-680082 VARCHAR(1)
  DEFINE l_pmm09	LIKE pmm_file.pmm09    #NO.FUN-680082 VARCHAR(10)
  DEFINE l_pmm25	LIKE pmm_file.pmm25    #NO.FUN-680082 VARCHAR(1)
  DEFINE l_qty		LIKE mss_file.mss062   #NO.FUN-680082 DEC(15,3)
  DEFINE l_sql          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
  DEFINE l_pmn09        LIKE pmn_file.pmn09     #採購單位/料件庫存單位的轉換率
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss062(彙總採購量)!"
    WHEN '2'
      LET g_msg ="_mss062(彙總採購量)!"
    OTHERWISE
      LET g_msg ="_mss062(Sum PurchQty )!"
  END CASE
  CALL msg(g_msg)
  LET l_sql = "SELECT pmn01, pmn02, pmn04, pmn11, pmn35, pmn20-pmn50+pmn55+pmn58, ", #FUN-940083 
              "       pmn16, pmm09, pmm25, pmn09 ",
              "  FROM pmn_file,pmm_file,part_tmp ",
              " WHERE pmn04=partno AND pmn20>(pmn50-pmn55-pmn58) ",  #No.FUN-9A0068 
              "   AND pmn16<='2' AND pmn35<='",edate,"'", #TQC-660123
              "   AND pmn01=pmm01 AND pmm02<>'SUB' ",
              "   AND pmn38 ='Y'"   #FUN-690047 add  #可用/不可用
  LET l_sql = l_sql CLIPPED,g_sql2 CLIPPED
  LET l_sql = l_sql CLIPPED
  PREPARE p501_pmn_p FROM l_sql
  DECLARE p501_pmn_c CURSOR FOR p501_pmn_p
 
  CALL p501_mss_0()
  FOREACH p501_pmn_c INTO l_pmn01, l_pmn02, mss.mss01, fz_flag, l_pmn35,
                          l_qty, l_pmn16, l_pmm09, l_pmm25,l_pmn09
     IF STATUS THEN CALL err('p501_pmn_c',STATUS,1) CONTINUE FOREACH END IF
     IF g_sma.sma57='2' AND l_pmm25 MATCHES '[X0]' THEN CONTINUE FOREACH END IF
     IF l_qty <= 0 OR l_qty IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02=l_pmm09
     SELECT pmh07 INTO mss.mss02 FROM pmh_file
            WHERE pmh01=mss.mss01 AND pmh02=mss.mss02
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
     LET mss.mss03=past_date
     IF l_pmn35 >= bdate THEN
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_pmn35
        IF STATUS THEN RETURN END IF
     END IF
     IF cl_null(l_pmn09) THEN LET l_pmn09=1 END IF
     LET l_qty=l_qty * l_pmn09
     IF l_pmn16<'2'
        THEN LET mss.mss062=l_qty LET mss.mss063=0
        ELSE LET mss.mss062=0     LET mss.mss063=l_qty
     END IF
     IF fz_flag='Y'
        THEN LET mss.mss06_fz=l_qty
        ELSE LET mss.mss06_fz=0
     END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss062 using mss.mss062,mss.mss063,mss.mss06_fz,
                                        mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=l_pmn35	# 日期
     IF l_pmn16<'2'
        THEN LET mst.mst05='62'	# 供需類別 (在採)
        ELSE LET mst.mst05='63'	# 供需類別 (在外)
     END IF
     LET mst.mst06=l_pmn01	# 單號
     LET mst.mst061=l_pmn02	# 項次
     LET mst.mst06_fz=fz_flag	# 凍結否
     LET mst.mst07=l_pmm09	# 追索料號(上階半/成品)
     LET mst.mst08=l_qty	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_pmn_c',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss064()	# 彙總 在製量
  DEFINE l_sfb01	LIKE sfb_file.sfb01    #NO.FUN-680082 VARCHAR(10)
  DEFINE l_sfb15	LIKE sfb_file.sfb15    #NO.FUN-680082 DATE
  DEFINE l_sql          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss064(彙總在製量)!"
    WHEN '2'
      LET g_msg ="_mss064(彙總在製量)!"
    OTHERWISE
      LET g_msg ="_mss064(Sum WkingQty )!"
  END CASE
  CALL msg(g_msg)
 
  DECLARE p501_sfb_c CURSOR FOR
    SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb11-sfb09,ima55_fac
      FROM sfb_file,part_tmp,OUTER ima_file
     WHERE sfb05=partno AND sfb08>sfb09 AND sfb04<'8' AND sfb15<=edate
       AND ima_file.ima01=sfb_file.sfb05 AND sfb87 !='X'
 
  CALL p501_mss_0()
  FOREACH p501_sfb_c INTO l_sfb01, mss.mss01, fz_flag, l_sfb15, mss.mss064,
                          l_ima55_fac
     IF STATUS THEN CALL err('p501_sfb_c',STATUS,1) CONTINUE FOREACH END IF
     IF mss.mss064 <= 0 OR mss.mss064 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF l_sfb15 >= bdate THEN
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_sfb15
        IF STATUS THEN RETURN END IF
     END IF
     IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
##  -(統一單位為庫存單位)-------
     LET mss.mss064=mss.mss064*l_ima55_fac
     IF fz_flag='Y'
        THEN
            LET mss.mss06_fz=mss.mss064
        ELSE
            LET mss.mss06_fz=0
     END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss064 using mss.mss064,mss.mss06_fz,
                                        mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=l_sfb15	# 日期
     LET mst.mst05='64'		# 供需類別
     LET mst.mst06=l_sfb01	# 單號
     LET mst.mst061=NULL	# 項次
     LET mst.mst06_fz=fz_flag	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss064	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034   #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
        EXIT PROGRAM END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_sfb_c',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss065()	# 彙總 計劃產出量
DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
 
  CASE g_lang
    WHEN '0'
      LET g_msg ="_mss065(彙總計劃產出量)!"
    WHEN '2'
      LET g_msg ="_mss065(彙總計劃產出量)!"
    OTHERWISE
      LET g_msg ="_mss065(Sum PrjProdQty)!"
  END CASE
  CALL msg(g_msg)
  IF msb_expl='N' THEN RETURN END IF
  DECLARE p501_msb_c4 CURSOR FOR
     SELECT msb_file.*,ima55_fac FROM msb_file,msa_file,part_tmp,OUTER ima_file
      WHERE msb03=partno
        AND msb01=msa01 AND msb04 <= edate AND msa03='N'
        AND msa05<>'X'  #CHI-C80041
        AND msb_file.msb03=ima_file.ima01
  CALL p501_mss_0()
  FOREACH p501_msb_c4 INTO msb.*,l_ima55_fac
     IF STATUS THEN CALL cl_err('msb_c4:',STATUS,1) CONTINUE FOREACH END IF
     SELECT SUM(sfb08) INTO g_qty FROM sfb_file
           WHERE sfb22=msb.msb01 AND sfb221=msb.msb02 AND sfb87 !='X'
     IF g_qty IS NULL THEN LET g_qty=0 END IF
     LET mss.mss065=msb.msb05-g_qty
     IF mss.mss065 <= 0 OR mss.mss065 IS NULL THEN CONTINUE FOREACH END IF
 
     IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
## -(統一單位為庫存單位)-------
     LET mss.mss065=mss.mss065*l_ima55_fac
 
     LET mss.mss01=msb.msb03
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF msb.msb04 >= bdate THEN
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=msb.msb04
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     LET mss.mssplant=g_plant #FUN-980004 add
     LET mss.msslegal=g_legal #FUN-980004 add
     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss065 using mss.mss065,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v	# 版本
     LET mst.mst01=mss.mss01	# 料號
     LET mst.mst02=mss.mss02	# 廠商
     LET mst.mst03=mss.mss03	# 日期
     LET mst.mst04=msb.msb04	# 日期
     LET mst.mst05='65'		# 供需類別
     LET mst.mst06=msb.msb01	# 單號
     LET mst.mst061=msb.msb02	# 項次
     LET mst.mst06_fz=NULL	# 凍結否
     LET mst.mst07=NULL		# 追索料號(上階半/成品)
     LET mst.mst08=mss.mss065	# 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
     PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                             mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034   #TQC-20222

     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL cl_err('msb_c4:',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_plan()	# M.R.P. (M.R.P. By Lot)
DEFINE l_mss_v   LIKE mss_file.mss_v
DEFINE l_mss01   LIKE mss_file.mss01
DEFINE l_mss02   LIKE mss_file.mss02
DEFINE l_mss03   LIKE mss_file.mss03
   DEFINE l_name        LIKE type_file.chr20    #MOD-4C0101   #NO.FUN-680082 VARCHAR(20)      
 
  DECLARE low_level_code CURSOR FOR
     SELECT ima16 FROM part_tmp,ima_file
         WHERE partno=ima01 AND imaacti='Y' AND ima08<>'X'
         GROUP BY ima16 ORDER BY ima16
  LET g_n=0
  LET g_mss00=0
  FOREACH low_level_code INTO g_ima16
     IF STATUS THEN CALL cl_err('low level:',STATUS,1) EXIT FOREACH END IF
     IF cl_null(g_argv1) THEN
        MESSAGE "Low Level:",g_ima16,"       "
        CALL ui.Interface.refresh()
     END IF
     IF sub_flag='Y' THEN
       LET g_msg='_plan_sub:',g_ima16 USING '<<<' CALL msg(g_msg)
       CALL p501_plan_sub()
     END IF
     LET g_msg='_plan:',g_ima16 USING '<<<' CALL msg(g_msg)
     DECLARE p501_plan_c CURSOR FOR
       SELECT mss_v,mss01,mss02,mss03 FROM mss_file,ima_file
        WHERE mss_v=ver_no AND mss01=ima01 AND ima16=g_ima16
 
     CALL cl_outnam('amrp501 ') RETURNING l_name
     START REPORT p501_rep TO l_name
 
     FOREACH p501_plan_c INTO l_mss_v,l_mss01,l_mss02,l_mss03
        IF STATUS THEN CALL err('p501_plan_c',STATUS,1) EXIT FOREACH END IF
        SELECT * INTO mss.* FROM mss_file
        WHERE mss_v=l_mss_v AND mss01=l_mss01 AND mss02=l_mss02 AND mss03=l_mss03
        OUTPUT TO REPORT p501_rep(l_mss_v,l_mss01,l_mss02,l_mss03, mss.*)
     END FOREACH
     #No.FUN-A70034  --Begin
     #IF STATUS THEN CALL err('p501_plan_c',STATUS,1) END IF
     #No.FUN-A70034  --End  
     FINISH REPORT p501_rep
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL cl_err('low level:',STATUS,1) END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
REPORT p501_rep(p_mss_v,p_mss01,p_mss02,p_mss03, mss)
  DEFINE p_mss_v  LIKE mss_file.mss_v
  DEFINE p_mss01  LIKE mss_file.mss01
  DEFINE p_mss02  LIKE mss_file.mss02
  DEFINE p_mss03  LIKE mss_file.mss03
  DEFINE i,j,k	  LIKE type_file.num10      #NO.FUN-680082 INTEGER
  DEFINE bal	  LIKE mss_file.mss08       #NO.FUN-680082 DEC(15,3)
  DEFINE qty2	  LIKE mss_file.mss08       #NO.FUN-680082 DEC(15,3)
  DEFINE l_ima08  LIKE ima_file.ima08     #NO.FUN-680082 VARCHAR(1)
  DEFINE l_ima45,l_ima46,l_ima47	LIKE ima_file.ima45     #NO.FUN-680082 DEC(12,3)
  DEFINE l_ima56,l_ima561,l_ima562	LIKE ima_file.ima56     #NO.FUN-680082 DEC(12,3)
  DEFINE l_ima50	LIKE ima_file.ima50     #NO.FUN-680082 SMALLINT
  DEFINE l_ima59	LIKE ima_file.ima59     #NO.FUN-680082 DEC(9,3)
  DEFINE l_ima60	LIKE ima_file.ima60     #NO.FUN-680082 DEC(9,3)
  DEFINE l_ima601	LIKE ima_file.ima601    #NO.FUN-840194
  DEFINE l_ima61	LIKE ima_file.ima61     #NO.FUN-680082 DEC(9,3)
  DEFINE l_ima72	LIKE ima_file.ima72     #NO.FUN-680082 SMALLINT
  DEFINE mss		RECORD LIKE mss_file.*
  DEFINE rrr		DYNAMIC ARRAY OF RECORD
         mss_v    LIKE mss_file.mss_v,
         mss01    LIKE mss_file.mss01,
         mss02    LIKE mss_file.mss02,
         mss03    LIKE mss_file.mss03
  			END RECORD
  DEFINE sss		DYNAMIC ARRAY OF RECORD LIKE mss_file.*

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY mss.mss01,mss.mss02,mss.mss03
  FORMAT
    BEFORE GROUP OF mss.mss01
      SELECT ima08,ima45,ima46,ima47,ima50+ima48+ima49+ima491,
                   ima56,ima561,ima562,
                   ima59,ima60,ima601,ima61,ima72  #No.FUN-840194 add ima601
        INTO l_ima08,l_ima45,l_ima46,l_ima47,l_ima50,
                     l_ima56,l_ima561,l_ima562,
                     l_ima59,l_ima60,l_ima601,l_ima61,l_ima72 #No.FUN-840194 add ima601
       FROM ima_file
      WHERE ima01=mss.mss01
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
         LET l_ima50=l_ima59+l_ima60/l_ima601*mss.mss09+l_ima61     #No.FUN-840194  #CHI-810015 mark還原 
         LET l_ima47=l_ima562
         LET l_ima45=l_ima56
         LET l_ima46=l_ima561
      END IF
      IF l_ima08='P' THEN
         CASE WHEN po_days>0 LET l_ima72=po_days
              WHEN po_days=0 LET l_ima72=po_days
              WHEN po_days<0 LET l_ima72=l_ima72
         END CASE
      END IF
      IF l_ima08='M' THEN
         CASE WHEN wo_days>0 LET l_ima72=wo_days
              WHEN wo_days=0 LET l_ima72=wo_days
              WHEN wo_days<0 LET l_ima72=l_ima72
         END CASE
      END IF
    BEFORE GROUP OF mss.mss02
      FOR i = 1 TO 100 LET rrr[i].mss_v=NULL LET rrr[i].mss01=NULL LET rrr[i].mss02=NULL LET rrr[i].mss03=NULL INITIALIZE sss[i].* TO NULL END FOR  #FUN-940083
      LET i = 0
      LET g_n=g_n+1
      MESSAGE g_n
      CALL ui.Interface.refresh()
    ON EVERY ROW
      LET g_mss00=g_mss00+1
      LET i = i+1
      LET rrr[i].mss_v=p_mss_v
      LET rrr[i].mss01=p_mss01
      LET rrr[i].mss02=p_mss02
      LET rrr[i].mss03=p_mss03
      LET sss[i].*    =mss.*
      LET sss[i].mss00=g_mss00
    AFTER GROUP OF mss.mss02
      LET bal=0
      FOR i = 1 TO 100
        IF sss[i].mss01 IS NULL THEN EXIT FOR END IF
        LET bal=bal
               +sss[i].mss051+sss[i].mss052+sss[i].mss053
               +sss[i].mss061+sss[i].mss062+sss[i].mss063
               +sss[i].mss064+sss[i].mss065
               -sss[i].mss041-sss[i].mss043-sss[i].mss044
               -sss[i].mss071+sss[i].mss072
        IF bal < 0 THEN
          FOR j = i+1 TO 100		# 請/採購交期, 工單完工日調整
            IF sss[j].mss01 IS NULL THEN EXIT FOR END IF
            IF sss[j].mss03 > sss[i].mss03+l_ima72 THEN EXIT FOR END IF
            LET qty2=sss[j].mss061+sss[j].mss062+sss[j].mss063+sss[j].mss064
                    -sss[j].mss06_fz			# 扣除Frozen凍結量
                    -sss[j].mss071+sss[j].mss072
            IF qty2 <= 0 THEN CONTINUE FOR END IF
            IF qty2 >= bal*-1
               THEN LET sss[j].mss071=sss[j].mss071+bal*-1
                    LET sss[i].mss072=sss[i].mss072+bal*-1
                    LET bal=0
                    EXIT FOR
               ELSE LET sss[j].mss071=sss[j].mss071+qty2
                    LET sss[i].mss072=sss[i].mss072+qty2
                    LET bal=bal+qty2
            END IF
          END FOR
        END IF
        LET sss[i].mss08=bal
        IF sss[i].mss08 < 0 THEN 			#-> plan order
           LET sss[i].mss09=sss[i].mss08*-1
           IF l_ima47 != 0 THEN				# 採購/製造損耗率
              LET sss[i].mss09 = sss[i].mss09 * (100+l_ima47)/100
           END IF
           IF l_ima45 != 0 THEN				# 採購/製造倍量
              LET k = (sss[i].mss09 / l_ima45) + 0.999
              LET sss[i].mss09 = l_ima45 * k
           END IF
           IF sss[i].mss09 < l_ima46 THEN		# 最小採購/製造量
              LET sss[i].mss09 = l_ima46
           END IF
           LET needdate=NULL
           IF needdate IS NULL THEN LET needdate=sss[i].mss03 END IF
 
           IF l_ima08='M' THEN
               LET l_ima50=l_ima59+l_ima60/l_ima601*sss[i].mss09+l_ima61  #No.FUN-840194 #CHI-810015 mark還原 
            END IF
           LET sss[i].mss11=needdate-l_ima50	# 減採購/製造前置日數
            IF sss[i].mss11 > sss[i].mss03 THEN
               LET sss[i].mss11=sss[i].mss03
            END IF
 
        END IF
        IF sss[i].mss09>0 AND (l_ima08='M' OR l_ima08='S' OR l_ima08='T') THEN
           CALL p501_mss045(sss[i].mss00,sss[i].mss01,
                            sss[i].mss11,needdate,sss[i].mss09)
        END IF
        LET bal=sss[i].mss08+sss[i].mss09
        EXECUTE p501_p_upd_mss using sss[i].*,rrr[i].*   #FUN-940083
        IF SQLCA.SQLCODE THEN
           MESSAGE sss[i].mss01,' ',sss[i].mss03
           CALL ui.Interface.refresh()
           CALL err('plan:upd mss:',SQLCA.SQLCODE,1)
        END IF
      END FOR
END REPORT
 
#------------------------------------------------- 建議 PLM 下階料備料量
FUNCTION p501_mss045(p_mss00,p_ima01,p_opendate,p_needdate,p_qty)
#No.FUN-A70034  --Begin
  DEFINE l_total        LIKE sfa_file.sfa05
  DEFINE l_QPA          LIKE bmb_file.bmb06
  DEFINE l_ActualQPA    LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
  DEFINE p_mss00	LIKE mss_file.mss00    #NO.FUN-680082 INTEGER
  DEFINE p_ima01	LIKE ima_file.ima01    #NO.MOD-490217
  DEFINE p_opendate	LIKE type_file.dat     #NO.FUN-680082 DATE
  DEFINE p_needdate 	LIKE type_file.dat     #NO.FUN-680082 DATE
  DEFINE p_qty 		LIKE mss_file.mss043   #NO.FUN-680082 DEC(15,3)
  DEFINE qty1,qty2,qty3,qty4 LIKE mss_file.mss043    #NO.FUN-680082 DEC(15,3)
  DEFINE l_ima08	LIKE ima_file.ima08          #NO.FUN-680082 VARCHAR(1)
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
## -----------------------------------
  IF mss_expl='N' THEN RETURN END IF		# 僅在多階 MRP 狀況下
  #(0)------------------------------------------------------------
  DECLARE p501_mss045_c1 CURSOR FOR
     SELECT bmb_file.*, ima08 FROM bmb_file, ima_file
      WHERE bmb01=p_ima01
        AND bmb04<=p_needdate AND (bmb05 IS NULL OR bmb05>p_needdate)
        AND bmb03=ima01
  CALL p501_mss_0()
  FOREACH p501_mss045_c1 INTO bmb1.*, l_ima08
    IF STATUS THEN CALL cl_err('45_c1:',STATUS,1) EXIT FOREACH END IF
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb1.bmb01   # 主件
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
    #No.FUN-A70034  --Begin
    #LET qty1=p_qty*bmb1.bmb06/bmb1.bmb07*(1+bmb1.bmb08/100)/
    #         l_ima55_fac*bmb1.bmb10_fac

    CALL cralc_rate(bmb1.bmb01,bmb1.bmb03,p_qty,bmb1.bmb081,bmb1.bmb08,
                    bmb1.bmb082,bmb1.bmb06/bmb1.bmb07,0)
         RETURNING l_total,l_QPA,l_ActualQPA
    LET qty1=l_total/ l_ima55_fac*bmb1.bmb10_fac
    #No.FUN-A70034  --End  
    IF l_ima08!='X' THEN
       SELECT partno FROM part_tmp WHERE partno=bmb1.bmb03
       IF STATUS THEN CONTINUE FOREACH END IF
       LET bmb.*=bmb1.*
       CALL p501_mss045_ins(p_mss00,p_opendate,p_needdate,qty1,p_ima01)
       CONTINUE FOREACH
    END IF
    #(1)---------------------------------------------------------
    DECLARE p501_mss045_c2 CURSOR FOR	# Phantom 再展一階
       SELECT bmb_file.*,ima08 FROM bmb_file,ima_file
          WHERE bmb01=bmb1.bmb03
            AND bmb04<=p_needdate AND (bmb05 IS NULL OR bmb05>p_needdate)
            AND bmb03=ima01
    CALL p501_mss_0()
    FOREACH p501_mss045_c2 INTO bmb2.*,l_ima08
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb2.bmb01
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
      #No.FUN-A70034  --Begin
      #LET qty2=qty1*bmb2.bmb06/bmb2.bmb07*(1+bmb2.bmb08/100)*l_ima55_fac
      CALL cralc_rate(bmb2.bmb01,bmb2.bmb03,qty1,bmb2.bmb081,bmb2.bmb08,
                      bmb2.bmb082,bmb2.bmb06/bmb2.bmb07,0)
           RETURNING l_total,l_QPA,l_ActualQPA
      LET qty2=l_total*l_ima55_fac
      #No.FUN-A70034  --End  
      IF l_ima08!='X' THEN
         SELECT partno FROM part_tmp WHERE partno=bmb2.bmb03
         IF STATUS THEN CONTINUE FOREACH END IF
         LET bmb.*=bmb2.*
         CALL p501_mss045_ins(p_mss00,p_opendate,p_needdate,qty2,p_ima01)
         CONTINUE FOREACH
      END IF
      #(2)---------------------------------------------------------
      DECLARE p501_mss045_c3 CURSOR FOR	# Phantom 再展一階
          SELECT bmb_file.*,ima08 FROM bmb_file,ima_file
           WHERE bmb01=bmb2.bmb03
             AND bmb04<=p_needdate AND (bmb05 IS NULL OR bmb05>p_needdate)
             AND bmb03=ima01
      CALL p501_mss_0()
      FOREACH p501_mss045_c3 INTO bmb3.*,l_ima08
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb3.bmb01
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
        #No.FUN-A70034  --Begin
        #LET qty3=qty1*bmb3.bmb06/bmb3.bmb07*(1+bmb3.bmb08/100)*l_ima55_fac
        CALL cralc_rate(bmb3.bmb01,bmb3.bmb03,qty1,bmb3.bmb081,bmb3.bmb08,
                        bmb3.bmb082,bmb3.bmb06/bmb3.bmb07,0)
             RETURNING l_total,l_QPA,l_ActualQPA
        LET qty3=l_total*l_ima55_fac
        #No.FUN-A70034  --End  


        IF l_ima08!='X' THEN
           SELECT partno FROM part_tmp WHERE partno=bmb3.bmb03
           IF STATUS THEN CONTINUE FOREACH END IF
           LET bmb.*=bmb3.*
           CALL p501_mss045_ins(p_mss00,p_opendate,p_needdate,qty3,p_ima01)
           CONTINUE FOREACH
        END IF
        #(3)---------------------------------------------------------
        DECLARE p501_mss045_c4 CURSOR FOR
            SELECT bmb_file.*,ima08 FROM bmb_file,ima_file
             WHERE bmb01=bmb3.bmb03
               AND bmb04<=p_needdate
               AND (bmb05 IS NULL OR bmb05>p_needdate)
               AND bmb03=ima01
           CALL p501_mss_0()
        FOREACH p501_mss045_c4 INTO bmb4.*,l_ima08
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb4.bmb01
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## -(統一單位為庫存單位)-------
          #No.FUN-A70034  --Begin
          #LET qty4=qty1*bmb4.bmb06/bmb4.bmb07*(1+bmb4.bmb08/100)*l_ima55_fac
          CALL cralc_rate(bmb4.bmb01,bmb4.bmb03,qty1,bmb4.bmb081,bmb4.bmb08,
                          bmb4.bmb082,bmb4.bmb06/bmb4.bmb07,0)
               RETURNING l_total,l_QPA,l_ActualQPA
          LET qty4=l_total*l_ima55_fac
          #No.FUN-A70034  --End  

          SELECT partno FROM part_tmp WHERE partno=bmb4.bmb03
          IF STATUS THEN CONTINUE FOREACH END IF
          LET bmb.*=bmb4.*
          CALL p501_mss045_ins(p_mss00,p_opendate,p_needdate,qty4,p_ima01)
        END FOREACH
      END FOREACH
    END FOREACH
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('p501_mss045_c2:',STATUS,1) RETURN END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION p501_mss045_ins(p_mss00,p_opendate,p_needdate,p_qty,p_id)
  DEFINE p_mss00	LIKE mss_file.mss00     #NO.FUN-680082 INTEGER
  DEFINE p_qty 		LIKE mss_file.mss043    #NO.FUN-680082 DEC(15,3)
  DEFINE p_opendate 	LIKE type_file.dat      #NO.FUN-680082 DATE
  DEFINE p_needdate 	LIKE type_file.dat      #NO.FUN-680082 DATE
  DEFINE p_id           LIKE ima_file.ima01 ## 98/06/23 Eric Add
                                             ## 解決虛擬料件回溯追蹤
 
       SELECT partno FROM part_tmp WHERE partno=bmb.bmb03
       IF STATUS THEN INSERT INTO part_tmp VALUES(bmb.bmb03) END IF
       LET mss.mss01=bmb.bmb03
       LET mss.mss02=NULL
       SELECT bml04 INTO mss.mss02 FROM bml_file	# 限定廠商
        WHERE (bml01=bmb.bmb03 AND bml02=bmb.bmb01 AND bml03=qvl_bml03
           OR bml01=bmb.bmb03 AND bml02='ALL' AND bml03=qvl_bml03)
       IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
       LET mss.mss03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
       LET needdate=p_opendate + bmb.bmb18
       IF needdate >= bdate THEN
          SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       LET mss.mss043=p_qty
       LET mss.mssplant=g_plant #FUN-980004 add
       LET mss.msslegal=g_legal #FUN-980004 add
       INSERT INTO mss_file VALUES(mss.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
           CALL cl_err3("ins","mss_file",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","ins mss:",1)        
       END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        EXECUTE p501_p_upd_mss043 using mss.mss043,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
       END IF
       LET mst.mst_v=mss.mss_v	# 版本
       LET mst.mst01=mss.mss01	# 料號
       LET mst.mst02=mss.mss02	# 廠商
       LET mst.mst03=mss.mss03	# 日期
       LET mst.mst04=p_opendate	# 日期
       LET mst.mst05='45'	# 供需類別
       LET mst.mst06=p_mss00  	# 單號
       LET mst.mst061=NULL     	# 項次
       LET mst.mst06_fz=NULL	# 凍結否
       LET mst.mst07=p_id       # 追索料號(上階半/成品) 98/06/23 Modif
       LET mst.mst08=mss.mss043	# 數量
       LET mst.mstplant=g_plant   #FUN-980004 add
       LET mst.mstlegal=g_legal   #FUN-980004 add
       IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
       PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                               mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

       IF STATUS THEN CALL err('ins mst',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p501_plan_sub()
  DEFINE l_short	LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
  DEFINE xx		LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
  DEFINE b1,b2,b3	LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
  DEFINE l_bal		LIKE mss_file.mss041    #NO.FUN-680082 DEC(15,3)
  DECLARE p501_plan_sub_c CURSOR FOR
    SELECT UNIQUE mss01,mss03		# 找出有取替代的元件
      FROM mss_file, bmd_file, ima_file
     WHERE mss_v=ver_no AND mss01=bmd01 AND mss01=ima01 AND ima16=g_ima16
       AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
       AND bmdacti = 'Y'                                           #CHI-910021
     ORDER BY 1,2
  FOREACH p501_plan_sub_c INTO g_mss01,g_mss03
     IF STATUS THEN CALL err('fore1',STATUS,1) RETURN END IF
     SELECT SUM((mss041+mss043+mss044)   #需求 - 供給
               -(mss051+mss052+mss053+mss061+mss062+mss063+mss064+mss065))
       INTO l_short
       FROM mss_file
      WHERE mss_v=ver_no AND mss01=g_mss01 AND mss02='-' AND mss03<=g_mss03
     IF l_short IS NULL THEN LET l_short=0 END IF
     IF l_short<=0 THEN CONTINUE FOREACH END IF	#若不足才找替代
     DECLARE p501_plan_sub_c2 CURSOR FOR
       SELECT mst03,mst04,mst06,mst061,mst07,mst08 FROM mst_file
        WHERE mst_v=ver_no AND mst01=g_mss01 AND mst02='-' AND mst03<=g_mss03
          AND mst05 IN ('43','44','45')   #備料
        ORDER BY 1 DESC, 2, 5, 3
     FOREACH p501_plan_sub_c2 INTO g_mst03,g_mst04,g_mst06,g_mst061,
                                   g_mst07,g_mst08
       IF STATUS THEN CALL err('fore2',STATUS,1) EXIT FOREACH END IF
       #------------------------------------------ 取該料+工單已被計算部份
       SELECT SUM(sub_qty) INTO xx FROM sub_tmp
         WHERE sub_partno=g_mss01 AND sub_wo_no=g_mst06 AND sub_prodno=g_mst07
       IF xx IS NULL THEN LET xx=0 END IF
       LET g_mst08=g_mst08 - xx
       IF g_mst08 <= 0 THEN CONTINUE FOREACH END IF
       #------------------------------------------ 取該料+工單已被計算部份
       IF l_short<g_mst08 THEN LET g_mst08=l_short END IF
       DECLARE p501_plan_sub_c3 CURSOR FOR
         SELECT bmd_file.* FROM bmd_file, ima_file
          WHERE bmd01=g_mss01 AND (bmd08=g_mst07 OR bmd08='ALL')
            AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
            AND bmd04=ima01 AND imaacti='Y'
            AND bmdacti = 'Y'                                           #CHI-910021
          ORDER BY bmd03
       FOREACH p501_plan_sub_c3 INTO bmd.*
         IF STATUS THEN CALL err('fore3',STATUS,1) EXIT FOREACH END IF
         SELECT SUM(mss051+mss052+mss061+mss062+mss063+mss064+mss065)
           INTO b1					# QOH/PR/PO 供給合計
           FROM mss_file
          WHERE mss_v=ver_no AND mss01=bmd.bmd04 AND mss02='-'
            AND mss03<=g_mst03
         SELECT SUM(mss041+mss043+mss044-mss053)
           INTO b2					# 需求(+替代需求)合計
           FROM mss_file
          WHERE mss_v=ver_no AND mss01=bmd.bmd04 AND mss02='-'
            AND mss03<=g_mss03
         IF b1 IS NULL THEN LET b1=0 END IF
         IF b2 IS NULL THEN LET b2=0 END IF
         LET l_bal=b1-b2
         IF l_bal<=0 THEN CONTINUE FOREACH END IF
         IF g_mst08*bmd.bmd07 > l_bal
            THEN LET g_sub_qty=l_bal
            ELSE LET g_sub_qty=g_mst08*bmd.bmd07
         END IF
         #-------------------------------- 統計該料+工單已被計算部份,存入sub_tmp
         UPDATE sub_tmp SET sub_qty=sub_qty+g_sub_qty
          WHERE sub_partno=g_mss01 AND sub_wo_no=g_mst06 AND sub_prodno=g_mst07
         IF SQLCA.SQLERRD[3]=0 THEN
            INSERT INTO sub_tmp (sub_partno, sub_wo_no, sub_prodno, sub_qty)
                                VALUES(g_mss01, g_mst06, g_mst07, g_sub_qty)
         END IF
         #---------------------------------------------------------------------
         CALL u_sub_1()	# 更新替代件
         CALL u_sub_2()	#
         FLUSH p501_c_ins_mst
         LET g_mst08=g_mst08-g_sub_qty/bmd.bmd07
         LET l_short=l_short-g_sub_qty/bmd.bmd07
         IF g_mst08 <= 0 THEN EXIT FOREACH END IF
       END FOREACH
       #No.FUN-A70034  --Begin
       #IF STATUS THEN CALL err('fore3',STATUS,1) EXIT FOREACH END IF
       #No.FUN-A70034  --End  
       IF l_short <= 0 THEN EXIT FOREACH END IF
     END FOREACH
     #No.FUN-A70034  --Begin
     #IF STATUS THEN CALL err('fore2',STATUS,1) EXIT FOREACH END IF
     #No.FUN-A70034  --End  
  END FOREACH
  #No.FUN-A70034  --Begin
  #IF STATUS THEN CALL err('fore1',STATUS,1) END IF
  #No.FUN-A70034  --End  
END FUNCTION
 
FUNCTION u_sub_1()
   UPDATE mss_file SET mss053=mss053-g_sub_qty
    WHERE mss_v=ver_no AND mss01=bmd.bmd04
      AND mss02='-'    AND mss03=g_mst03
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL p501_mss_0()
      LET mss.mss01=bmd.bmd04
      LET mss.mss02='-'
      LET mss.mss03=g_mst03
      LET mss.mss053=-g_sub_qty
      LET mss.mssplant=g_plant #FUN-980004 add
      LET mss.msslegal=g_legal #FUN-980004 add
      INSERT INTO mss_file VALUES (mss.*)
   END IF
   LET mst.mst01=bmd.bmd04
   LET mst.mst02='-'
   LET mst.mst03=g_mst03
   LET mst.mst04=g_mst04
   LET mst.mst05='53'
   LET mst.mst06=g_mst06
   LET mst.mst061=g_mst061
   LET mst.mst06_fz=NULL
   LET mst.mst07=g_mss01
   LET mst.mst08=-g_sub_qty
   LET mst.mstplant=g_plant   #FUN-980004 add
   LET mst.mstlegal=g_legal   #FUN-980004 add
   IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
   PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                           mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

END FUNCTION
 
FUNCTION u_sub_2()
   UPDATE mss_file SET mss053=mss053+g_sub_qty/bmd.bmd07
    WHERE mss_v=ver_no AND mss01=g_mss01
      AND mss02='-'    AND mss03=g_mst03
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL p501_mss_0()
      LET mss.mss01=g_mss01
      LET mss.mss02='-'
      LET mss.mss03=g_mst03
      LET mss.mss053=g_sub_qty/bmd.bmd07
      LET mss.mssplant=g_plant #FUN-980004 add
      LET mss.msslegal=g_legal #FUN-980004 add
      INSERT INTO mss_file VALUES (mss.*)
   END IF
   LET mst.mst01=g_mss01
   LET mst.mst02='-'
   LET mst.mst03=g_mst03
   LET mst.mst04=g_mst04
   LET mst.mst05='53'
   LET mst.mst06=g_mst06
   LET mst.mst061=g_mst061
   LET mst.mst06_fz=NULL
   LET mst.mst07=bmd.bmd04
   LET mst.mst08=g_sub_qty/bmd.bmd07
   LET mst.mstplant=g_plant   #FUN-980004 add
   LET mst.mstlegal=g_legal   #FUN-980004 add
   IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF       #TQC-C20222
   PUT p501_c_ins_mst FROM mst.mst_v,mst.mst01,mst.mst02,mst.mst03,mst.mst04,mst.mst05,mst.mst06,mst.mst061,mst.mst06_fz,mst.mst07,mst.mst08,
                           mst.mst09,mst.mstplant,mst.mstlegal    #No.FUN-A70034  #TQC-20222

END FUNCTION
 
FUNCTION msg(p_msg)		# 非 Background 狀態, 才可顯示 message
   DEFINE p_msg		LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(60)
   DEFINE l_time        LIKE type_file.chr8	    #No.FUN-6A0076
   LET msl.msl_v=ver_no
   LET msl.msl01=TODAY
   LET l_time = TIME
   LET msl.msl02=l_time
   LET msl.msl03=p_msg
   LET msl.msllegal=g_legal #FUN-980004 add
   LET msl.mslplant=g_plant #FUN-980004 add
   INSERT INTO msl_file VALUES(msl.*)
   IF cl_null(g_argv1) THEN
      MESSAGE p_msg CLIPPED
      CALL ui.Interface.refresh()
   END IF
END FUNCTION
 
FUNCTION err(p_msg,err_code,p_n)
   DEFINE p_msg    	LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(80)
          err_code	LIKE ze_file.ze01,       #NO.FUN-680082 VARCHAR(7)
          err_coden	LIKE type_file.num10,    #NO.FUN-680082 INTEGER
          p_n   	LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_errmsg      LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(70)
          l_sqlerrd ARRAY[6] OF LIKE type_file.num10, #NO.FUN-680082 INTEGER
          l_chr    	LIKE type_file.chr1,     #NO.FUN-680082 VARCHAR(1)
          l_time        LIKE type_file.chr8 	    #No.FUN-6A0076
 
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
 
 
   LET g_err_cnt=g_err_cnt+1
   IF g_err_cnt > 100 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
   IF NOT  cl_null(g_argv1) THEN
      LET msl.msl_v=ver_no
      LET msl.msl01=TODAY
      LET l_time = TIME
      LET msl.msl02=l_time
      LET msl.msl03=p_msg CLIPPED,' ',err_code
      LET msl.msllegal=g_legal #FUN-980004 add
      LET msl.mslplant=g_plant #FUN-980004 add
      INSERT INTO msl_file VALUES(msl.*)
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
       ERROR ' ',p_msg CLIPPED,' ',l_errmsg
   ELSE
       ERROR '(',err_code clipped,')',p_msg CLIPPED,' ',l_errmsg
   END IF
   IF p_n = 1
      THEN
           LET INT_FLAG = 0  ######add for prompt bug
           PROMPT 'press any key to continue:' FOR CHAR l_chr
           IF l_chr = '1' THEN
              PROMPT err_code CLIPPED,
                 ' 1:',l_sqlerrd[1],' 2:',l_sqlerrd[2],' 3:',l_sqlerrd[3],
                 ' 4:',l_sqlerrd[4],' 5:',l_sqlerrd[5],' 6:',l_sqlerrd[6],
                 ' <cr>:'FOR CHAR l_chr
           END IF
   END IF
   IF p_n > 1
      THEN SLEEP p_n
   END IF
END FUNCTION
 
FUNCTION err_numchk(err_code)
   DEFINE err_code LIKE ze_file.ze01       #NO.FUN-680082 VARCHAR(7)
   DEFINE i        LIKE type_file.num5     #NO.FUN-680082 SMALLINT
   FOR i = 1 TO 7
      IF cl_null(err_code[i,i]) OR
         err_code[i,i] MATCHES "[-0123456789]"
         THEN CONTINUE FOR
         ELSE RETURN FALSE
      END IF
   END FOR
   RETURN TRUE
END FUNCTION
 
# 因分倉 MRP 在抓取來源資料時,其SQL必須參考MRP限定倉別版別(msp_file),
# 的參數設定,而本 function 旨在組出對應的 sql
FUNCTION p501_get_sql()
DEFINE l_msp RECORD LIKE msp_file.*
DEFINE l_n   LIKE type_file.num5      #NO.FUN-680082 SMALLINT
DEFINE l_i   LIKE type_file.num5      #NO.FUN-680082 SMALLINT
DEFINE g_sw  LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
DEFINE l_star LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
 
   LET l_n = 1
   DECLARE sel_msp_cur CURSOR FOR
    SELECT * FROM msp_file
     WHERE msp01 = g_msp01
   FOREACH sel_msp_cur INTO l_msp.*
    IF STATUS THEN CALL cl_err('for msp:',STATUS,0) EXIT FOREACH END IF
    LET l_star='N'
    IF NOT cl_null(l_msp.msp03) THEN
## 先判斷有沒有星號
      FOR l_i=1 TO LENGTH(l_msp.msp03)
         IF l_msp.msp03[l_i,l_i]='*' THEN
           IF l_n=1 THEN
             LET g_sql = g_sql CLIPPED,
                         " AND (imd01 MATCHES '",l_msp.msp03 CLIPPED,"'"
           ELSE
             LET g_sql = g_sql CLIPPED,
                         "  OR imd01 MATCHES '",l_msp.msp03 CLIPPED,"'"
           END IF
           LET l_star='Y'
           EXIT FOR
         END IF
      END FOR
 
## 若沒有星號
       IF l_star='N' THEN
         IF l_n=1 THEN
           LET g_sql = g_sql CLIPPED," AND (imd01 = '",l_msp.msp03 ,"'"
         ELSE
           LET g_sql = g_sql CLIPPED,"      OR imd01 = '",l_msp.msp03 ,"'"
         END IF
       END IF
    END IF
 
    LET l_star='N'
    IF NOT cl_null(l_msp.msp04) THEN
      FOR l_i=1 TO LENGTH(l_msp.msp04)
         IF l_msp.msp04[l_i,l_i]='*' THEN
           IF l_n=1 THEN
             LET g_sql1 = g_sql1 CLIPPED,
                 " AND (smyslip MATCHES '",l_msp.msp04 CLIPPED,"'"
             LET g_sql3 = g_sql3 CLIPPED,
                 " AND (msa01 MATCHES '",l_msp.msp04 CLIPPED,"'"
             LET g_sql5 = g_sql5 CLIPPED,
                 " AND (oayslip MATCHES '",l_msp.msp04 CLIPPED,"'"
           ELSE
             LET g_sql1 = g_sql1 CLIPPED,
                 "     OR smyslip MATCHES '",l_msp.msp04 CLIPPED,"'"
             LET g_sql3 = g_sql3 CLIPPED,
                 "     OR msa01  MATCHES '",l_msp.msp04 CLIPPED,"'"
             LET g_sql5 = g_sql5 CLIPPED,
                 "     OR oayslip MATCHES '",l_msp.msp04 CLIPPED,"'"
           END IF
           LET l_star='Y'
           EXIT FOR
         END IF
      END FOR
 
      IF l_star='N' THEN
        IF l_n=1 THEN
          LET g_sql1 = g_sql1 CLIPPED," AND (smyslip = '",l_msp.msp04 ,"'"
          LET g_sql3 = g_sql3 CLIPPED," AND (msa01 like '",l_msp.msp04 ,"-%'"    #No.FUN-550055
          LET g_sql5 = g_sql5 CLIPPED," AND (oayslip = '",l_msp.msp04 ,"'"
        ELSE
          LET g_sql1 = g_sql1 CLIPPED,"     OR smyslip = '",l_msp.msp04 ,"'"
          LET g_sql3 = g_sql3 CLIPPED,"     OR msa01 like '",l_msp.msp04 ,"-%'"    #No.FUN-550055
          LET g_sql5 = g_sql5 CLIPPED,"     OR oayslip = '",l_msp.msp04 ,"'"
        END IF
      END IF
    END IF
 
  #仿前面
    LET l_star='N'
    IF NOT cl_null(l_msp.msp05) THEN
      FOR l_i=1 TO LENGTH(l_msp.msp05)
         IF l_msp.msp05[l_i,l_i]='*' THEN
           IF l_n=1 THEN
             LET g_sql2 = g_sql2 CLIPPED,
                          " AND (pmm10 MATCHES '",l_msp.msp05 CLIPPED,"'"
             LET g_sql4 = g_sql4 CLIPPED,
                          " AND (pmk10 MATCHES '",l_msp.msp05 CLIPPED,"'"
           ELSE
             LET g_sql2 = g_sql2 CLIPPED,
                          "     OR pmm10 MATCHES '",l_msp.msp05 CLIPPED,"'"
             LET g_sql4 = g_sql4 CLIPPED,
                          "     OR pmk10 MATCHES '",l_msp.msp05 CLIPPED,"'"
           END IF
           LET l_star='Y'
           EXIT FOR
         END IF
      END FOR
 
      IF l_star='N' THEN
        IF l_n=1 THEN
          LET g_sql2 = g_sql2 CLIPPED," AND (pmm10 = '",l_msp.msp05 ,"'"
          LET g_sql4 = g_sql4 CLIPPED," AND (pmk10 = '",l_msp.msp05 ,"'"
        ELSE
          LET g_sql2 = g_sql2 CLIPPED,"     OR pmm10 = '",l_msp.msp05 ,"'"
          LET g_sql4 = g_sql4 CLIPPED,"     OR pmk10 = '",l_msp.msp05 ,"'"
        END IF
      END IF
    END IF
    LET l_n=l_n+1
 
   END FOREACH
 
   IF NOT cl_null(g_sql) THEN LET g_sql = g_sql CLIPPED," )" END IF
   IF NOT cl_null(g_sql1) THEN LET g_sql1 = g_sql1 CLIPPED," )" END IF
   IF NOT cl_null(g_sql2) THEN LET g_sql2 = g_sql2 CLIPPED," )" END IF
   IF NOT cl_null(g_sql3) THEN LET g_sql3 = g_sql3 CLIPPED," )" END IF
   IF NOT cl_null(g_sql4) THEN LET g_sql4 = g_sql4 CLIPPED," )" END IF
   IF NOT cl_null(g_sql5) THEN LET g_sql5 = g_sql5 CLIPPED," )" END IF
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
