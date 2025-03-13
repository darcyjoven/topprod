# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axcr370.4gl
# Descriptions...: 成本計算後勾稽作業
# Input parameter: 
# Return code....: 
# Date & Author..:
# Maintain.......:
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0099 05/01/21 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.MOD-530395 05/03/29 By pengu   adj-22若為第一次計算成本,期初期末金額核對應抓是否存在開帳資料
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570240 05/07/28 By elva 月份改為由期別抓資料
# Modify.........: No.FUN-570190 05/08/08 By Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-610080 06/01/23 By Sarah 對在製(工單,產品)檢查段(855行開始),
#                                                  IF ima911='Y'，不處理sfb_curs
#                                                                 不處理ccg11,ccg21,ccg31,ccg91 數量檢查
#                                                                 不處理cch11,cch21,cch31,cch41,cch91 數量檢查
# Modify.........: No.MOD-620035 06/02/15 by Claire ccc22a-ccc44(雜入金額)再與cce22e比較
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-660073 06/12/08 By Nicola 訂單樣品修改
# Modify.........: No.MOD-6C0180 06/12/29 by rainy 若為第一個月上線,在製成本金額核對應抓取是否存在開帳資料.
# Modify.........: No.MOD-710013 07/01/10 by claire 聯產品金額核對應加入本月重工入庫金額
# Modify.........: No.MOD-720078 07/03/09 By pengu 修改SQL語法
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750093 07/06/21 By jan 報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/20 By jan 打印條件修改
# Modify.........: No.MOD-7A0169 07/10/30 By Pengu 拆件式工單成本資料已改寫至cch_file與ccg_file故不應再撈ccu_file
# Modify.........: No.MOD-7A0168 07/10/29 By Pengu 1.錯誤訊息太短應調整str_err放大
#                                                  2.#chk98錯誤訊息應調整sr.ccc.ccc22b+sr.ccc.ccc28b
# Mofify.........: No.FUN-7C0101 08/01/25 By lala    成本改善
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.MOD-820018 08/03/23 By Pengu 一顆料有兩個以上的img且img21不一樣時，在核對imk09與ccc91時會異常
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.CHI-870016 08/07/22 By Sarah 拆件式工單不做chk25檢查
# Modify.........: No.MOD-880122 08/09/03 By Pengu sfq_curs CURSOR應排除作廢單據
# Modify.........: No.MOD-910220 09/02/02 By chenl 根據成本計算類別，調整計算方式。
# Modify.........: No.MOD-8B0258 09/02/03 By Pengu 調整聯產品的判斷公式
# Modify.........: No.MOD-930237 09/03/25 By chenyu 先進先出的情況沒有考慮
# Modify.........: No.MOD-940117 09/04/09 By chenl 調整SQL錯誤，增加變量。
# Modify.........: No.MOD-930305 09/03/30 By Pengu SQL條件錯誤
# Modify.........: No.MOD-980077 09/08/12 By mike 將多的sr.ccc.ccc08拿掉.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-930021 10/02/24 By huangrh 增加檢核料件無成本分群之錯誤
# Modify.........: No:TQC-A40139 10/05/04 By Carrier MOD-990009 追单
# Modify.........: No:CHI-A50003 10/05/11 By Summer 因"(Adj45)差異大於"欄位沒有作用,故將adj45欄位拿掉
# Modify.........: No:CHI-A70034 10/07/20 By Summer 將itemx畫面欄位改為下拉式選項,desc_x拿掉
# Modify.........: No:MOD-B10161 11/01/20 By sabrina 修改分倉成本的sql
# Modify.........: No:MOD-B60226 11/06/24 By Pengu 調整MOD-910220的錯誤
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正 
# Modify.........: No:FUN-C50130 12/06/14 By suncx 檢查因成本階異常導致的CCG和CCH不平
# Modify.........: No:MOD-C70189 12/07/17 By ck2yuan 金額欄位需依ccz26進行取位
# Modify.........: No:CHI-C50058 12/08/17 By bart 期初.期末數量=0及各項數量=0時，不要印出"無單位成本資料請輸入調整資料(axct002)"的訊息
# Modify.........: No:CHI-C80002 12/10/05 By bart 改善效能 NOT IN 改為 NOT EXISTS
# Modify.........: No:MOD-D40149 13/04/19 By bart 如果sr.str_err = ''就不EXECUTE

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc        LIKE type_file.chr1000,         #No.FUN-680122CHAR(300)                # Where condition
              ccc02     LIKE ccc_file.ccc02,    # 年別
              ccc03     LIKE ccc_file.ccc03,    # 期別
              itemx     LIKE type_file.num5,            #No.FUN-680122SMALLINT
             #desc_x    LIKE type_file.chr1000,         #No.FUN-680122CHAR(30) #CHI-A70034 mark
              #adj45     LIKE cch_file.cch12,           #CHI-A50003 mark
              more      LIKE type_file.chr1,            #No.FUN-680122CHAR(01)                 # Input more condition(Y/N)
              type      LIKE type_file.chr1       #FUN-7C0101
              END RECORD,
          l_za05  LIKE za_file.za05,
          l_order array[3] of LIKE type_file.chr20,           #No.FUN-680122CHAR(20)
          l_bdate LIKE type_file.dat,             #No.FUN-680122date
          l_edate LIKE type_file.dat,             #No.FUN-680122date
          l_key   LIKE type_file.chr1,            #No.FUN-680122char(1)
          l_sts   LIKE oea_file.oea01,          #No.FUN-680122char(14)
          l_year,l_month  LIKE type_file.num5,            #No.FUN-680122SMALLINT
          g_show      LIKE type_file.num5,            #No.FUN-680122SMALLINT
          g_yy        LIKE type_file.num5,            #No.FUN-680122SMALLINT
          g_mm        LIKE type_file.num5             #No.FUN-680122SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_bdate         LIKE type_file.dat              #No.FUN-680122DATE  #FUN-570240
DEFINE   g_edate         LIKE type_file.dat              #No.FUN-680122 DATE   #FUN-570240
DEFINE   g_str     STRING        #No.FUN-750093
DEFINE   g_sql     STRING        #No.FUN-750093
DEFINE   l_table   STRING        #No.FUN-750093
 
MAIN
   OPTIONS
 
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key functvon
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   LET g_pdate       = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom      = ARG_VAL(2)
   LET g_rlang       = ARG_VAL(3)
   LET g_bgjob       = ARG_VAL(4)
   LET g_prtway      = ARG_VAL(5)
   LET g_copies      = ARG_VAL(6)
   LET tm.wc         = ARG_VAL(7)
   LET tm.ccc02      = ARG_VAL(8)
   LET tm.ccc03      = ARG_VAL(9)
   LET tm.itemx      = ARG_VAL(10)
   #LET tm.desc_x      = ARG_VAL(11) #CHI-A70034 mark
   #LET tm.adj45      = ARG_VAL(12) #CHI-A50003 mark
   #CHI-A70034 mod -1 --start--
   LET g_rep_user = ARG_VAL(11)     #CHI-A50003 mod 13->12
   LET g_rep_clas = ARG_VAL(12)     #CHI-A50003 mod 14->13
   LET g_template = ARG_VAL(13)     #CHI-A50003 mod 15->14
   LET tm.type = ARG_VAL(14)        #FUN-7C0101  #CHI-A50003 mod 16->15
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #CHI-A70034 mod -1 --end--
 
   CALL s_lsperiod(tm.ccc02,tm.ccc03) RETURNING g_yy,g_mm
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL axcr370_tm(0,0)                 # Input print condition
   ELSE
      CALL axcr370()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr370_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 13 END IF
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW axcr370_w AT p_row,p_col
        WITH FORM "axc/42f/axcr370" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
   LET tm.more          = 'N'
   LET g_pdate          = g_today
   LET g_rlang          = g_lang
   LET g_bgjob          = 'N'
   LET g_copies         = '1'
   LET tm.ccc02         = g_ccz.ccz01
   LET tm.ccc03         = g_ccz.ccz02
   LET tm.itemx         = 0
   LET tm.more          ='N'
 
 
 
WHILE TRUE
 
   CONSTRUCT BY NAME tm.wc ON ima01,ima12,ima57
##
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
     ON ACTION controlp                                                      
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
        END IF                                                              
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr370_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc=" 1=1" THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
 
   #DISPLAY BY NAME tm.ccc02,tm.ccc03,tm.adj45,tm.more  #CHI-A50003 mark
   DISPLAY BY NAME tm.ccc02,tm.ccc03,tm.more            #CHI-A50003 
           

   #INPUT   BY NAME tm.ccc02,tm.ccc03,tm.type,tm.itemx,tm.desc_x,tm.adj45,tm.more   #FUN-7C0101 #CHI-A50003 mark
   #INPUT   BY NAME tm.ccc02,tm.ccc03,tm.type,tm.itemx,tm.desc_x,tm.more   #CHI-A50003 #CHI-A70034 mark
   INPUT   BY NAME tm.ccc02,tm.ccc03,tm.type,tm.itemx,tm.more   #CHI-A70034
           WITHOUT DEFAULTS 
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD ccc02
         IF tm.ccc02 IS NULL THEN
            CALL s_yp(g_pdate) RETURNING tm.ccc02,tm.ccc03
            DISPLAY tm.ccc02,tm.ccc03 TO ccc02,ccc03
         END IF
 
      AFTER FIELD ccc03
         IF NOT cl_null(tm.ccc03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.ccc02
            IF g_azm.azm02 = 1 THEN
               IF tm.ccc03 > 12 OR tm.ccc03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ccc03
               END IF
            ELSE
               IF tm.ccc03 > 13 OR tm.ccc03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ccc03
               END IF
            END IF
         END IF
         IF tm.ccc03 IS NULL THEN
            CALL s_yp(g_pdate) RETURNING tm.ccc02,tm.ccc03
            DISPLAY tm.ccc02,tm.ccc03 TO ccc02,ccc03
         END IF
         CALL s_lsperiod(tm.ccc02,tm.ccc03) RETURNING g_yy,g_mm
 
      AFTER FIELD itemx      
         IF cl_null(tm.itemx) THEN NEXT FIELD itemx END IF
         #CHI-A70034 mark --start--
         #CALL r370_kind('d')
         #IF NOT cl_null(g_errno) THEN	#有誤
         #   CALL cl_err(tm.itemx,g_errno,0) NEXT FIELD itemx
         #END IF
         #CHI-A70034 mark --end--
 
      AFTER FIELD type                                              #FUN-7C0101                                                 
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF   #FUN-7C0101
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
      
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       
       ON ACTION about         
          CALL cl_about()      
       
       ON ACTION help          
          CALL cl_show_help()  
 
   END INPUT
 
   CALL s_lsperiod(tm.ccc02,tm.ccc03) RETURNING g_yy,g_mm
   CALL s_azn01(tm.ccc02,tm.ccc03) RETURNING l_bdate,l_edate
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr370_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr370'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr370','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate      CLIPPED,"'",
                         " '",g_towhom     CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob      CLIPPED,"'",
                         " '",g_prtway     CLIPPED,"'",
                         " '",g_copies     CLIPPED,"'",
                         " '",tm.wc        CLIPPED,"'",
                         " '",tm.ccc02     CLIPPED,"'",
                         " '",tm.ccc03     CLIPPED,"'",
                         " '",tm.itemx     CLIPPED,"'",
                        #" '",tm.desc_x    CLIPPED,"'", #CHI-A70034 mark
                        #" '",tm.adj45     CLIPPED,"'", #CHI-A50003 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr370',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr370_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr370()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr370_w
END FUNCTION
   
FUNCTION axcr370()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
          l_sql     LIKE type_file.chr1000,       #No.FUN-680122CHAR(2000)
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680122CHAR(2000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_tot     LIKE ccc_file.ccc32,         #No.FUN-680122 DECIMAL(20,6)
          l_tot1    LIKE ccc_file.ccc32,         #No.FUN-680122 DECIMAL(20,6)
          l_tot2    LIKE ccc_file.ccc32,         #No.FUN-680122 DECIMAL(20,6)
          l_totccu  LIKE ccc_file.ccc32,         #No.FUN-680122 DECIMAL(20,6)
          l_ccg92   like ccg_file.ccg92,
          t_ccc23   like ccc_file.ccc23,
          t_ccc23a   like ccc_file.ccc23a,
          t_ccc23b   like ccc_file.ccc23b,
          t_ccc23c   like ccc_file.ccc23c,
          t_ccc23d   like ccc_file.ccc23d,
          t_ccc23e   like ccc_file.ccc23e,
          l_ccc92    like ccc_file.ccc92,     #上月期末
          l_sfb38    like sfb_file.sfb38,     #工單結案
          l_ccj05    like ccj_file.ccj05,     #投入工時
          l_ccj051   LIKE ccj_file.ccj051,    #投入機時
          l_ccj07    LIKE ccj_file.ccj07,     #投入標准人工工時
          l_ccj071   LIKE ccj_file.ccj071,    #投入標准機器工時
          l_imk09    like imk_file.imk09,
          l_img21    like img_file.img21,
          l_tlf62    like tlf_file.tlf62,
          l_tlf21    like tlf_file.tlf21,
          l_tlfc21   like tlfc_file.tlfc21,          #FUN-7C0101
          l_tlfccost  like tlfc_file.tlfccost,         #FUN-7C0101
          l_cch12    like cch_file.cch12,
          l_cch22    like cch_file.cch22,
          l_cch32    like cch_file.cch32,
          l_cch42    like cch_file.cch42,
          l_cch60    like cch_file.cch60,
          l_ccg22    like ccg_file.ccg22,
          l_cch91    like cch_file.cch91,
          l_cch92    like cch_file.cch92,
          l_ima131   like ima_file.ima131,
          l_ccb      RECORD LIKE ccb_file.*,
          l_ccg      RECORD LIKE ccg_file.*,
          l_cch      RECORD LIKE cch_file.*,
          l_diff     LIKE ccg_file.ccg12,
          l_dif      LIKE ccg_file.ccg12,
          l_cce22a   LIKE cce_file.cce22a,
          l_cce22b   LIKE cce_file.cce22b,
          l_cce22c   LIKE cce_file.cce22c,
          l_cce22d   LIKE cce_file.cce22d,
          l_cce22e   LIKE cce_file.cce22e,
          l_cce22f   LIKE cce_file.cce22f,             #FUN-7C0101
          l_cce22g   LIKE cce_file.cce22g,             #FUN-7C0101
          l_cce22h   LIKE cce_file.cce22h,             #FUN-7C0101
          l_sfb02    LIKE sfb_file.sfb02,              #CHI-870016 add
          sr      RECORD
                  type  LIKE type_file.num5,           #No.FUN-680122smallint
                  ima01 like ima_file.ima01,
                  ima02 like ima_file.ima02,
                  ima12 LIKE ima_file.ima12,           #FUN-930021
                  ima021 like ima_file.ima021,
                  ima911 like ima_file.ima911,         #FUN-610080
                  str_err LIKE type_file.chr1000,      #No.FUN-680122char(100)
                  ccc    RECORD LIKE ccc_file.*
                  END RECORD,
        #FUN-C50130 add begin------------
          l_ccg_cch RECORD
                ccg01  LIKE ccg_file.ccg01,
                ccg04  LIKE ccg_file.ccg04,
                ima57a LIKE ima_file.ima57,
                cch03  LIKE cch_file.cch03,
                cch04  LIKE cch_file.cch04,
                ima57b LIKE ima_file.ima57,
                sfb99  LIKE sfb_file.sfb99
                END RECORD
        #FUN-C50130 add end----------------
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET g_sql = " ima01.ima_file.ima01,",
                " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,",
                " ccc08.ccc_file.ccc08,",     #No.MOD-910220
                " str_err.type_file.chr1000,",
                " type.type_file.num5"
 
    LET l_table = cl_prt_temptable('axcr370',g_sql) CLIPPED
    IF l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
       EXIT PROGRAM
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?)"        #No.MOD-910220 add ?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
       EXIT PROGRAM
    END IF
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
    LET l_sql = 
    "SELECT tlf62,tlfccost,SUM(tlfc21*tlf907)*-1 ",                         #FUN-7C0101
    "  FROM tlf_file, sfb_file,ima_file A,ima_file B,tlfc_file ",          #FUN-7C0101
    " WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate ,"' ",
    "   AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR ",
    "       (tlf03=50 AND tlf02 BETWEEN 60 AND 69)) ",
    "   AND tlf01=B.ima01 AND sfb01 = tlf62 AND tlf01 = ? ",
    "   AND tlf13 NOT MATCHES 'asft6*' ", # 去除工單完工入退庫者
    "   AND sfb05 = A.ima01 AND A.ima57 <  B.ima57 ",
    #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add #CHI-C80002
    "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)",  #CHI-C80002
    "   AND tlfc_file.tlfc01 = tlf01  AND tlfc_file.tlfc02 = tlf02", 
    "   AND tlfc_file.tlfc03 = tlf03  AND tlfc_file.tlfc06 = tlf06",
    "   AND tlfc_file.tlfc13 = tlf13", #No.FUN-830002 add 
    "   AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903= tlf903",
    "   AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc905= tlf905",
    "   AND tlfc_file.tlfc906= tlf906 AND tlfc_file.tlfc907= tlf907",
    "   AND tlfc_file.tlfctype = '",tm.type,"'",
    " GROUP BY tlf62,tlfccost "                                                       #FUN-7C0101
 
     PREPARE axcr370_preparewip FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('preparewip:',SQLCA.sqlcode,1)    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr370_curswip CURSOR WITH HOLD FOR axcr370_preparewip
 
     LET l_sql=" SELECT ' ',ima01,ima02,ima12,ima021,ima911,' ',ccc_file.* ",   #FUN-610080#FUN-930021 add ima12
               "   FROM ima_file,ccc_file  ",
               " WHERE ",tm.wc clipped,
               "   AND ima01 = ccc01 ",
               "   AND ccc02 = ",tm.ccc02,
               "   AND ccc03 = ",tm.ccc03,
               "   AND ccc07 ='",tm.type,"'"                             #FUN-7C0101
 
     PREPARE axcr370_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr370_curs1 CURSOR WITH HOLD FOR axcr370_prepare1
 
     LET l_sql = " SELECT * FROM ccg_file  ",
                 " WHERE ccg04 = ? ", 
                 "  AND ccg02 = ",tm.ccc02 ," AND ccg03 = ",tm.ccc03,
                 "  AND ccg06 ='",tm.type,"'"                             #FUN-7C0101
     PREPARE r370_preccg FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('preccg:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE ccg_curs CURSOR WITH HOLD FOR r370_preccg
 
     LET l_sql = "SELECT * FROM cch_file ",
                 " WHERE cch01 = ? ",
                 "   AND cch02 = ",tm.ccc02," AND cch03 = ",tm.ccc03,
                 "   AND cch06 ='",tm.type,"'",                      #FUN-7C0101
                 "   AND (cch91 < 0   OR cch92a < 0 OR cch92b < 0 ",
                 "     OR cch92c < 0 OR  cch92d < 0 OR cch92e < 0 ",
                 "     OR cch92 < 0  OR ((cch11+cch21)=0 AND (cch12+cch22)!=0))"
     PREPARE r370_precch FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('precch:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE cch_curs CURSOR WITH HOLD FOR r370_precch
   
     LET l_sql = "SELECT SUM(cch22) FROM cch_file ",
                 " WHERE cch04 = ? ",
                 "   AND cch02 = ",tm.ccc02," AND cch03 = ",tm.ccc03,
                 "   AND cch06 ='",tm.type,"'",                      #FUN-7C0101
                 "   AND cch07 = ? "       #No.MOD-910220
     PREPARE r370_precch1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('precch1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE cch_curs1 CURSOR WITH HOLD FOR r370_precch1
     #-->拆件式
 
     LET l_sql = "SELECT SUM(ccg22) FROM ccg_file ",
                 " WHERE ccg04 = ? ",
                 "   AND ccg02 = ",tm.ccc02," AND ccg03 = ",tm.ccc03,
                 "   AND ccg06 ='",tm.type,"'"                       #FUN-7C0101
     PREPARE r370_precch6 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('precch6:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE cch_curs6 CURSOR WITH HOLD FOR r370_precch6
   
     LET l_sql = "SELECT UNIQUE tlf62,tlfccost,(tlfc21*tlf907) FROM tlf_file,sfb_file,tlfc_file ",
                 " WHERE tlf01 = ? ",
                 "   AND tlf21 IS NOT NULL",
                 "   AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                 "   AND tlf62 = sfb01",
                 #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add #CHI-C80002
                 "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)",  #CHI-C80002
                 "   AND tlfc_file.tlfc01 = tlf01   AND tlfc_file.tlfc02 = tlf02",                                                                
                 "   AND tlfc_file.tlfc03 = tlf03   AND tlfc_file.tlfc06 = tlf06",
                 "   AND tlfc_file.tlfc13 = tlf13", #No.FUN-830002 add                                                                
                 "   AND tlfc_file.tlfc902= tlf902  AND tlfc_file.tlfc903= tlf903",                                                               
                 "   AND tlfc_file.tlfc904= tlf904  AND tlfc_file.tlfc905= tlf905",                                                               
                 "   AND tlfc_file.tlfc906= tlf906  AND tlfc_file.tlfc907= tlf907",                                                               
                 "   AND tlfc_file.tlfctype =  '",tm.type,"'",
                 "   AND sfb81 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
     PREPARE r370_precch2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('precch2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE cch_curs2 CURSOR WITH HOLD FOR r370_precch2
 
     LET l_sql = "SELECT ccc92 FROM ccc_file ",
                 " WHERE ccc01 = ? ",
                 "   AND ccc02 = ",g_yy," AND ccc03 = ",g_mm,
                 "   AND ccc07 ='",tm.type,"'",                         #FUN-7C0101
                 "   AND ccc08 = ? "      #No.MOD-910220
     PREPARE r370_preccc3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('preccc3:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE ccc_curs3 CURSOR WITH HOLD FOR r370_preccc3
     CALL s_azn01(tm.ccc02,tm.ccc03) RETURNING g_bdate,g_edate
     LET l_sql = "SELECT UNIQUE ccj05,ccj051,ccj07,ccj071 FROM ccj_file ",  #No.MOD-910220
                 " WHERE ccj01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                 "   AND ccj04 = ?"
     PREPARE r370_preccj  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('preccj:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE ccj_curs CURSOR WITH HOLD FOR r370_preccj 
 
     #--------有無工單資料----------------
     LET l_sql = "SELECT COUNT(*) FROM cch_file",
                 " WHERE cch02 = ",tm.ccc02,
                 "   AND cch03 = ",tm.ccc03,
                 "   AND cch04 = ' DL+OH+SUB'",
                 "   AND cch06 ='",tm.type,"'",                      #FUN-7C0101
                 "   AND cch01 = ? "
     PREPARE r370_precch4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('precch4:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE cch_curs4 CURSOR WITH HOLD FOR r370_precch4
 
     #--------工單結案否----------------
     LET l_sql = "SELECT sfb38 FROM sfb_file",
                 " WHERE sfb01 = ?"
     PREPARE r370_presfb FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('presfb:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE sfb_curs CURSOR WITH HOLD FOR r370_presfb
 
   CASE 
      WHEN tm.type = '1' OR tm.type='2'  #'月加權平均成本'或'先進先出成本'
        LET l_sql = "SELECT SUM(imk09*img21) FROM imk_file,img_file",
                    " WHERE imk01 = ? ",
                    "   AND imk01=img01 ", 
                    "   AND imk02=img02 ", 
                    "   AND imk03=img03 ", 
                    "   AND imk04=img04 ", 
                    "   AND imk05 = ",tm.ccc02, 
                    "   AND imk06 = ",tm.ccc03, 
                    #"   AND imk02 NOT IN(SELECT jce02 FROM jce_file)"  #CHI-C80002
                    "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02)"  #CHI-C80002
                                        
      WHEN tm.type = '3'  #'個別認定-批次成本'
        LET l_sql = "SELECT SUM(imk09*img21) FROM imk_file,img_file",
                    " WHERE imk01 = ? ", 
                    "   AND imk01=img01 ", 
                    "   AND imk02=img02 ",
                    "   AND imk03=img03 ", 
                    "   AND imk04=img04 ",
                    "   AND imk04= ? ", 
                    "   AND imk05 = ",tm.ccc02, 
                    "   AND imk06 = ",tm.ccc03,  
                    #"   AND imk02 NOT IN(SELECT jce02 FROM jce_file)"  #CHI-C80002
                    "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02)"  #CHI-C80002     
      WHEN tm.type = '4'  #'個別認定-項目成本'
        LET l_sql = "SELECT SUM(imk09*img21) FROM imk_file,img_file",
                    " WHERE imk01 = ? ",
                    "   AND imk01=img01 ", 
                    "   AND imk02=img02 ", 
                    "   AND imk03=img03 ", 
                    "   AND imk04=img04 ", 
                    "   AND imk05 = ",tm.ccc02,  
                    "   AND imk06 = ",tm.ccc03,  
                    #"   AND imk02 NOT IN(SELECT jce02 FROM jce_file)"  #CHI-C80002
                    "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02)"  #CHI-C80002   
      WHEN tm.type = '5'  #'個別認定-分倉成本'
       #LET l_sql = "SELECT SUM(imk09*img21) FROM imk_file,img_file,imd_file",       #MOD-B10161 mark
        LET l_sql = "SELECT SUM(imk09*img21) FROM imk_file,img_file",                #MOD-B10161 add
                    " WHERE imk01 = ? ", 
                    "   AND imk01 = img01 ",
                    "   AND imk02 = img02 ",
                    "   AND imk03 = img03 ",
                    "   AND imk04 = img04 ",
                   #"   AND imk02 = ? ",           #MOD-B10161 mark
                    #"   AND imk02 IN (SELECT imd01 FROM imd_file WHERE imd09 = ?) ",  #MOD-B10161 add  #CHI-C80002
                    "   AND EXISTS(SELECT 1 FROM imd_file WHERE imd01 = mk02 AND imd09 = ?) ",  #CHI-C80002
                    "   AND imk05 = ",tm.ccc02,  
                    "   AND imk06 = ",tm.ccc03,  
                    #"   AND imk02 NOT IN(SELECT jce02 FROM jce_file)"  #CHI-C80002  
                    "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = imk02)"  #CHI-C80002
    END CASE 
     PREPARE r370_preimk FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('preimk:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE imk_curs CURSOR WITH HOLD FOR r370_preimk
   
     LET g_pageno = 0
 
     DECLARE sfq_curs CURSOR FOR
      SELECT UNIQUE sfq02 FROM sfq_file,sfp_file    #No.MOD-880122 modify
       WHERE NOT EXISTS ( SELECT * FROM sfb_file WHERE sfb01=sfq02)
         AND sfp01 = sfq01        #No.MOD-880122 add
         AND sfpconf != 'X'       #No.MOD-880122 add
     FOREACH sfq_curs INTO sr.str_err
         LET sr.type = -1000
         LET sr.str_err=sr.str_err CLIPPED,'(1)' CLIPPED         
         EXECUTE insert_prep USING
                 sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''
     END FOREACH 

     #FUN-C50130 add str-----------------------------------------------
     LET l_sql = "SELECT UNIQUE ccg01,ccg04,aa.ima57,cch03,cch04,bb.ima57,sfb99 ",
                 "  FROM (SELECT UNIQUE ccg01,ccg03,ccg04,ima57 ", 
                 "          FROM ccg_file,ima_file ",
                 "         WHERE ccg04=ima01 AND ccg02 = ",tm.ccc02," AND ccg03 = ",tm.ccc03,
                 "           AND ccg06='",tm.type,"' AND ccg04 = ?) aa, ",
                 "       (SELECT UNIQUE cch01,cch03,cch04,ima57 ",
                 "          FROM cch_file,ima_file ",
                 "         WHERE cch04=ima01 AND cch02 = ",tm.ccc02," AND cch03 = ",tm.ccc03,
                 "           AND cch06='",tm.type,"') bb,sfb_file  ",
                 " WHERE aa.ccg01=bb.cch01 AND aa.ima57>bb.ima57 AND sfb01 = aa.ccg01",
                 "   AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99 = 'N')",
                 " ORDER BY ccg04,cch04"
     PREPARE r370_ccg01 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('r370_ccg01:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF
     DECLARE ccg_curs01 CURSOR WITH HOLD FOR r370_ccg01 
     #FUN-C50130 add end----------------------------------------------

     FOREACH axcr370_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)    
          EXIT FOREACH 
       END IF
        IF sr.ccc.ccc23 = 0 THEN 
           LET sr.type = 59  
           LET sr.str_err=sr.ima01
           IF sr.ccc.ccc21!=0 AND sr.ccc.ccc22=0 THEN
              LET sr.str_err = sr.str_err CLIPPED,'(2)' CLIPPED
           ELSE
              #CHI-C50058---begin
              IF sr.ccc.ccc11 = 0 AND sr.ccc.ccc21 = 0 AND sr.ccc.ccc25 = 0 AND  
              sr.ccc.ccc27 = 0 AND sr.ccc.ccc31 = 0 AND sr.ccc.ccc41 = 0 AND 
              sr.ccc.ccc43 = 0 AND sr.ccc.ccc51 = 0 AND sr.ccc.ccc61 = 0 AND   
              sr.ccc.ccc64 = 0 AND sr.ccc.ccc71 = 0 AND sr.ccc.ccc91 = 0 AND  
              sr.ccc.ccc81 = 0 THEN 
                 LET sr.str_err = ''
              ELSE   
              #CHI-C50058---end   
                 LET sr.str_err = sr.str_err CLIPPED,'(3)' CLIPPED
              END IF #CHI-C50058
           END IF
           IF NOT cl_null(sr.str_err) THEN  #MOD-D40149
              EXECUTE insert_prep USING                                              
                      sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''
           END IF   #MOD-D40149     
        END IF
       message sr.ima01
       IF (tm.itemx = 51 or tm.itemx = 0) AND
          (sr.ccc.ccc21 !=0 OR sr.ccc.ccc27!=0
          OR sr.ccc.ccc61 != 0 OR sr.ccc.ccc81 !=0 ) THEN   #No.FUN-660073
          LET l_ima131  = null
          SELECT ima131  INTO l_ima131  FROM ima_file #no.5684
           WHERE ima01 = sr.ima01
          IF cl_null(l_ima131)  THEN
             LET sr.type = 60 
             LET sr.str_err=sr.ima01 CLIPPED,'(4)' CLIPPED
             EXECUTE insert_prep USING                                               
                     sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type   #No.MOD-910220 add ''
          END IF
       END IF
       LET l_tot = 0 LET l_tot1 = 0  LET l_tot2 = 0  LET l_totccu = 0
       OPEN cch_curs1 USING sr.ima01,sr.ccc.ccc08   #No.MOD-940117 add ccc08 
       FETCH cch_curs1 INTO l_tot 
       CLOSE cch_curs1
       IF l_tot IS NULL THEN LET l_tot = 0 END IF 
 
 
       LET l_tot1 = (sr.ccc.ccc32+sr.ccc.ccc26) * -1
       IF l_tot != l_tot1 AND (l_tot-l_tot1 > 1 OR l_tot1-l_tot > 1) THEN
          IF tm.itemx = -09 OR tm.itemx = 0 THEN 
             IF l_tot > l_tot1 THEN 
                LET sr.type = -09
                FOREACH cch_curs2 USING sr.ima01 INTO l_tlf62,l_tlfccost,l_tlf21
                  LET sr.str_err=l_tlf62 CLIPPED,' ',cl_numfor(l_tlf21,17,g_ccz.ccz26),   #MOD-C70189 取位 0->g_ccz.ccz26
                  '(5)' CLIPPED,l_tot - cl_numfor(l_tot1,17,g_ccz.ccz26),                 #MOD-C70189 取位 3->g_ccz.ccz26
                  '(Adj-30)'
                  EXECUTE insert_prep USING                                          
                          sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type    #No.MOD-910220 add ''
                END FOREACH 
             ELSE #tlf > cch 
                LET l_tlf21 = 0  LET l_tlf62 = ' '
                FOREACH axcr370_curswip USING sr.ima01 INTO l_tlf62,l_tlfccost,l_tlf21    #FUN-7C0101
                    LET l_cch22 = 0
                    SELECT SUM(cch22) INTO l_cch22 FROM cch_file
                     WHERE cch04 = sr.ima01 AND cch01 = l_tlf62
                       AND cch02 = tm.ccc02 AND cch03 = tm.ccc03
                       AND cch06 = tm.type   #FUN-830002
                       AND cch07 = l_tlfccost #No.MOD-910220
                    IF l_cch22 IS NULL THEN LET l_cch22 = 0 END IF 
                    IF l_cch22 != l_tlf21 THEN 
                       LET l_dif = l_cch22 - l_tlf21
                       IF l_dif  < 0 THEN LET l_dif = l_dif * -1 END IF
                       IF l_dif >= 1 THEN 
                          LET sr.str_err=                                       
                             l_tlf62 CLIPPED,' ',cl_numfor(l_tlf21,17,g_ccz.ccz26),   #MOD-C70189 取位 0->g_ccz.ccz26
                                               '(6)' CLIPPED,                 
                              cl_numfor(l_dif,17,g_ccz.ccz26),'(Adj-31)'              #MOD-C70189 取位 0->g_ccz.ccz26
                          EXECUTE insert_prep USING                                     
                                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type    #No.MOD-910220 add ''
                       END IF
                    END IF
                END FOREACH
             END IF 
          END IF 
       END IF 
 
       IF sr.ccc.ccc61 != 0 AND sr.ccc.ccc62 = 0 AND sr.ccc.ccc23 != 0 THEN
          LET sr.type = -07
          LET sr.str_err='(7)' CLIPPED
          EXECUTE insert_prep USING                             
                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''
       END IF 
 
       IF sr.ccc.ccc61 = 0 AND sr.ccc.ccc62 != 0 THEN
          LET sr.type = -07
          LET sr.str_err='(8)' CLIPPED
          EXECUTE insert_prep USING                                             
                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''
       END IF 
 
       IF sr.ccc.ccc81 != 0 AND sr.ccc.ccc82 = 0 AND sr.ccc.ccc23 != 0 THEN
          LET sr.type = -07
          LET sr.str_err='(7)' CLIPPED
          EXECUTE insert_prep USING                                             
                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add '' 
       END IF 
 
       IF sr.ccc.ccc81 = 0 AND sr.ccc.ccc82 != 0 THEN
          LET sr.type = -07
          LET sr.str_err='(8)' CLIPPED
          EXECUTE insert_prep USING                                             
                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''
       END IF 
 
       IF sr.ccc.ccc31 != 0 AND sr.ccc.ccc32 = 0 AND sr.ccc.ccc23 != 0 THEN
          LET sr.type = -08
          LET sr.str_err='(9)' CLIPPED
          EXECUTE insert_prep USING                                             
                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type   #No.MOD-910220 add ''
       END IF 
 
       IF sr.ccc.ccc31 = 0 AND sr.ccc.ccc32 != 0 THEN
          LET sr.type = -08
          LET sr.str_err='(10)' CLIPPED
          EXECUTE insert_prep USING                                             
                  sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
       END IF 
 
 IF tm.itemx <= 0 AND NOT (tm.itemx = -77 OR tm.itemx=-66) THEN # ccc_file Group
       #---------------Adj-10-------------------------
       IF tm.itemx = -10 OR tm.itemx = 0 THEN 
          IF (sr.ccc.ccc25 >0 OR sr.ccc.ccc25 < 0 )
             AND (sr.ccc.ccc26a = 0 OR sr.ccc.ccc26 = 0 ) 
          THEN LET sr.type = -10
               LET sr.str_err='(11)' CLIPPED
               EXECUTE insert_prep USING                                             
                       sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
          END IF
       END IF
       #---------------Adj-11-------------------------
       IF tm.itemx = -11 OR tm.itemx = 0 THEN 
          IF (sr.ccc.ccc41 !=0 AND sr.ccc.ccc42 = 0 AND sr.ccc.ccc23 != 0) 
          THEN LET sr.type = -11
               LET sr.str_err='(12)' CLIPPED
               EXECUTE insert_prep USING                                        
                       sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''  
          END IF
       END IF
       #---------------Adj-12-------------------------
       IF tm.itemx = -12 OR tm.itemx = 0 THEN 
          IF (sr.ccc.ccc41 =0 AND sr.ccc.ccc42 != 0 )
          THEN LET sr.type = -12
               LET sr.str_err='(13)' CLIPPED
               EXECUTE insert_prep USING                                        
                       sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
          END IF
       END IF
       #---------------chk5(nochk-13)----------------
       IF tm.itemx = -13 OR tm.itemx = 0 THEN 
          IF (sr.ccc.ccc91=0) and (sr.ccc.ccc92!=0) then
             IF sr.ccc.ccc92 <  1  THEN 
               LET sr.type = -13
               LET sr.str_err='(14)' CLIPPED,                                  
                           sr.ccc.ccc92 using'----&.&&&&&',"(#Nochk-13)"
               EXECUTE insert_prep USING                                        
                       sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             ELSE 
               LET sr.type = -13
               LET sr.str_err='(15)' CLIPPED,"(#chk-131)"
               EXECUTE insert_prep USING                                        
                       sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
          END IF
       END IF
 
       #---------------chk10--------------------------
       IF tm.itemx = -14 OR tm.itemx = 0 THEN 
          IF (sr.ccc.ccc91<0)  THEN
             LET sr.type = -14
             LET sr.str_err='(16)' CLIPPED,"(#chk-14)"
             EXECUTE insert_prep USING                                        
                     sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
          END IF
       END IF
       #---------------chk3---------------------------
       IF sr.ccc.ccc92  < 0 OR sr.ccc.ccc92a < 0 OR sr.ccc.ccc92b < 0 OR 
          sr.ccc.ccc92c < 0 OR sr.ccc.ccc92d < 0 OR sr.ccc.ccc92e < 0 OR
          sr.ccc.ccc92f < 0 OR sr.ccc.ccc92g < 0 OR sr.ccc.ccc92h < 0   #No.MOD-910220
       THEN 
            #-----------月底結存成本-------------------------
            IF tm.itemx = -15 OR tm.itemx = 0 THEN 
               IF sr.ccc.ccc92 <  0  THEN 
                  LET sr.type = -15
                  LET sr.str_err='(17)' CLIPPED,"(#Adj-15)",                   
                                  cl_numfor(sr.ccc.ccc92,17,g_ccz.ccz26)   #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                          
                          sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
               END IF
            END IF
            #-----------月底結存材料成本--------------------
            IF tm.itemx = -16 OR tm.itemx = 0 THEN 
               IF sr.ccc.ccc92a <  0  THEN 
                  LET sr.type = -16
                  LET sr.str_err='(18)' CLIPPED,                               
                                cl_numfor(sr.ccc.ccc92a,17,g_ccz.ccz26),"(#Adj-16)"    #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
               END IF
            END IF
            #-----------月底結存人工成本--------------------
            IF tm.itemx = -17 OR tm.itemx = 0 THEN 
               IF sr.ccc.ccc92b <  0  THEN 
                  LET sr.type = -17
                  LET sr.str_err='(19)' CLIPPED,                               
                                  cl_numfor(sr.ccc.ccc92b,17,g_ccz.ccz26),"(#Adj-17)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type  #No.MOD-910220 add ccc08
               END IF
            END IF
            #-----------月底結存製費成本--------------------
            IF tm.itemx = -18 OR tm.itemx = 0 THEN 
               IF sr.ccc.ccc92c <  0  THEN 
                  LET sr.type = -18
                  LET sr.str_err='(20)' CLIPPED,                               
                                  cl_numfor(sr.ccc.ccc92c,17,g_ccz.ccz26),"(#Adj-18)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
               END IF
            END IF
            #-----------月底結存加工成本--------------------
            IF tm.itemx = -19 OR tm.itemx = 0 THEN 
               IF sr.ccc.ccc92d <  0  THEN 
                  LET sr.type = -19
                  LET sr.str_err='(21)' CLIPPED,                               
                               cl_numfor(sr.ccc.ccc92d,17,g_ccz.ccz26),"(#Adj-19)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
               END IF
            END IF
            #-----------月底結存其他成本--------------------
            IF tm.itemx = -20 OR tm.itemx = 0 THEN 
               IF sr.ccc.ccc92e <  0  THEN 
                  LET sr.type = -20
                  LET sr.str_err='(22)' CLIPPED,                               
                               cl_numfor(sr.ccc.ccc92e,17,g_ccz.ccz26),"(#Adj-20)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
               END IF
               IF sr.ccc.ccc92f <  0  THEN 
                  LET sr.type = -20
                  LET sr.str_err='(22)' CLIPPED,                               
                               cl_numfor(sr.ccc.ccc92f,17,g_ccz.ccz26),"(#Adj-20)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type   
               END IF 
               IF sr.ccc.ccc92g <  0  THEN 
                  LET sr.type = -20
                  LET sr.str_err='(22)' CLIPPED,                               
                               cl_numfor(sr.ccc.ccc92g,17,g_ccz.ccz26),"(#Adj-20)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type   
               END IF 
               IF sr.ccc.ccc92h <  0  THEN 
                  LET sr.type = -20
                  LET sr.str_err='(22)' CLIPPED,                               
                               cl_numfor(sr.ccc.ccc92h,17,g_ccz.ccz26),"(#Adj-20)"  #MOD-C70189 取位 5->g_ccz.ccz26
                  EXECUTE insert_prep USING                                     
                          sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type   
               END IF 
            END IF
       END IF
       #---------------chk4---------------------------
       IF sr.ccc.ccc93 != 0 THEN
          IF tm.itemx = -21 OR tm.itemx = 0 THEN
             IF sr.ccc.ccc93 > 5 OR sr.ccc.ccc93 < -5 THEN
                LET sr.type = -21
                LET sr.str_err='(23)' CLIPPED,                                 
                               cl_numfor(sr.ccc.ccc93,17,g_ccz.ccz26),"(#Adj-21)"  #MOD-C70189 取位 0->g_ccz.ccz26
                EXECUTE insert_prep USING                                     
                       #sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08 #MOD-980077
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #MOD-980077
             END IF
          END IF
       END IF 
        LET l_ccc92 =NULL      #--No.MOD-530395
       OPEN ccc_curs3 USING sr.ima01,sr.ccc.ccc08     #No.MOD-910220 add ccc08
       FETCH ccc_curs3 INTO l_ccc92
       IF cl_null(l_ccc92) THEN 
          IF g_sma.sma43="1" THEN 
             SELECT SUM(cxd09) INTO l_ccc92 FROM cxd_file
              WHERE cxd01=sr.ima01 AND cxd02=g_yy AND cxd03=g_mm
                AND cxd010=tm.type AND cxd011=sr.ccc.ccc08
          ELSE
             SELECT cca12 INTO l_ccc92 FROM cca_file
              WHERE cca01 = sr.ima01 
                AND cca02 = g_yy AND cca03 = g_mm
                AND cca06 = tm.type               #FUN-7C0101
                AND cca07 = sr.ccc.ccc08
          END IF    #No.MOD-930237 add
          IF cl_null(l_ccc92) THEN LET l_ccc92 = 0 END IF
       END IF
       IF tm.itemx = -22 OR tm.itemx = 0 THEN
          IF sr.ccc.ccc12 <> l_ccc92 THEN
             LET sr.type = -22
             LET sr.str_err='(24)' CLIPPED,"(#Adj-22)"
             EXECUTE insert_prep USING                                       
                     sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
          END IF
       END IF
       LET l_imk09 = 0
       CASE 
         WHEN tm.type = '1' OR tm.type= '2' OR tm.type='4'
           OPEN imk_curs USING sr.ima01
           FETCH imk_curs INTO l_imk09
         WHEN tm.type = '3' OR tm.type = '5'
           OPEN imk_curs USING sr.ima01,sr.ccc.ccc08
           FETCH imk_curs INTO l_imk09
       END CASE 
       IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF
       IF tm.itemx = -23 OR tm.itemx = 0 THEN
          IF sr.ccc.ccc91 <> l_imk09 THEN
             LET sr.type = -23
             LET sr.str_err='(25)' CLIPPED,cl_numfor(sr.ccc.ccc91,17,g_ccz.ccz27),          #MOD-C70189 取位 3->g_ccz.ccz27
                           '(26)' CLIPPED,cl_numfor(l_imk09,17,g_ccz.ccz27),                #MOD-C70189 取位 3->g_ccz.ccz27
                           '(27)' CLIPPED,cl_numfor(sr.ccc.ccc91 -l_imk09,17,g_ccz.ccz27),  #MOD-C70189 取位 3->g_ccz.ccz27
                           "(#Adj-23)"
             EXECUTE insert_prep USING                                          
                     sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
          END IF
       END IF
       #---------------chk15--------------------------
       IF sr.ccc.ccc91 != 0 THEN 
          IF sr.ccc.ccc23 = 0 AND
             (sr.ccc.ccc21 !=0 OR sr.ccc.ccc27!=0) THEN
             LET sr.type = -24
             LET sr.str_err='(28)' CLIPPED,"(#chk-24)"
             EXECUTE insert_prep USING                                          
                     sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
          END IF
          IF tm.itemx = -24 OR tm.itemx = 0 THEN 
             IF sr.ccc.ccc23a < 0 THEN
                LET sr.type = -24
                LET sr.str_err='(29)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING                                          
                     sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
             END IF
             IF sr.ccc.ccc23b < 0 THEN
                LET sr.type = -24
                LET sr.str_err='(30)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
             END IF
             IF sr.ccc.ccc23c < 0 THEN
                LET sr.type = -24
                LET sr.str_err='(31)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
             END IF
             IF sr.ccc.ccc23d < 0 THEN
                LET sr.type = -24
                LET sr.str_err='(32)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
             END IF
             IF sr.ccc.ccc23e < 0 THEN
                LET sr.type = -24
                LET sr.str_err='(33)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.MOD-910220 add ccc08
             END IF
             IF sr.ccc.ccc23f < 0 THEN 
                LET sr.type = -24
                LET sr.str_err='(33)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING  
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.090119 by chenl
             END IF 
             IF sr.ccc.ccc23g < 0 THEN 
                LET sr.type = -24
                LET sr.str_err='(33)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING  
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.090119 by chenl
             END IF
             IF sr.ccc.ccc23h < 0 THEN 
                LET sr.type = -24
                LET sr.str_err='(33)' CLIPPED,"(#chk-24)"
                EXECUTE insert_prep USING  
                        sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type #No.090119 by chenl
             END IF
          END IF 
       END IF 
   END IF 
   
       #------------對在製工單做檢查 -----------------
       FOREACH ccg_curs USING sr.ima01 INTO l_ccg.*
          IF SQLCA.sqlcode THEN 
             CALL cl_err('foreach ccg_curs',SQLCA.sqlcode,0)
             EXIT FOREACH 
          END IF
  IF tm.itemx = 0 OR tm.itemx = 50 OR tm.itemx = 40 OR tm.itemx=30
     OR tm.itemx=20 OR tm.itemx =-77 OR tm.itemx = 41 THEN
          #----------------本月有工時,但無工單資料或工單已結案------
          LET l_ccj05=NULL
         #----------No:MOD-B60226 add
          LET l_ccj051 = NULL
          LET l_ccj07  = NULL
          LET l_ccj071 = NULL
         #----------No:MOD-B60226 end
          OPEN ccj_curs USING l_ccg.ccg01
          FETCH ccj_curs INTO l_ccj05,l_ccj051,l_ccj07,l_ccj071      #No:MOD-B60226 modify
          IF (l_ccj05 IS NOT NULL AND l_ccj05 <> 0)       
             OR (l_ccj051 IS NOT NULL AND l_ccj051 <>0)
             OR (l_ccj07 IS NOT NULL AND l_ccj07 <>0)
             OR (l_ccj071 IS NOT NULL AND l_ccj071 <>0) THEN 
             IF (l_ccg.ccg12+l_ccg.ccg22+l_ccg.ccg23) = 0 THEN
                LET sr.type = 50 
                LET sr.str_err=l_ccg.ccg01 clipped,                             
                               '(34)' CLIPPED,"(#Adj50)"
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''                 
             ELSE   
                LET g_cnt = 0
                OPEN cch_curs4 USING l_ccg.ccg01
                FETCH cch_curs4 INTO g_cnt
                IF g_cnt = 0 THEN     #無工單資料
                   LET sr.type = 50 
                   LET sr.str_err=l_ccg.ccg01 clipped,                          
                                  '(34)' CLIPPED,"(#Adj50)"
                   EXECUTE insert_prep USING                                       
                           sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
                ELSE
                   IF sr.ima911 != 'Y' THEN   #FUN-610080
                      LET l_sfb38 = NULL
                      OPEN sfb_curs USING l_ccg.ccg01
                      FETCH sfb_curs INTO l_sfb38
                      IF l_sfb38 IS NOT NULL AND l_sfb38<l_bdate THEN  #已結案
                         LET sr.type = 50 
                          LET sr.str_err=l_ccg.ccg01 clipped,                    
                                      '(34)' CLIPPED,"(#Adj50)"
                         EXECUTE insert_prep USING                                    
                                 sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
                      END IF
                   END IF                     #FUN-610080
                END IF
             END IF
          END IF
          #----------------主件檢查chk20-------------------
          IF tm.itemx = 20 OR tm.itemx = 0 THEN 
             IF sr.ima911 != 'Y' THEN   #FUN-610080
                IF l_ccg.ccg31 > (l_ccg.ccg11 + l_ccg.ccg21)
                THEN LET sr.type = 20
                   LET sr.str_err=l_ccg.ccg01,                                  
                                  '(35)' CLIPPED,'(#chk20)'
                   EXECUTE insert_prep USING                              
                                 sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add '' 
                END IF
             END IF                     #FUN-610080
          END IF
          #----------------主件數量檢查-------------------
          IF tm.itemx = 50 OR tm.itemx = 0 THEN 
             IF sr.ima911 != 'Y' THEN   #FUN-610080
                IF (l_ccg.ccg91 = 0 AND  (l_ccg.ccg92>1 OR l_ccg.ccg92<-1 ) ) THEN    # l_ccg.ccg92 != 0 ) THEN  #tianry add 170214 
                   LET sr.type = 30
                   LET sr.str_err=l_ccg.ccg01,                                  
                                  '(36)' CLIPPED,'(#chk30)'
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''       
                END IF
                IF (l_ccg.ccg91< -1 AND l_ccg.ccg92  = 0) THEN   #0 AND l_ccg.ccg92  = 0) THEN  #tianry 
                   LET sr.type = 30
                   LET sr.str_err=l_ccg.ccg01,                                  
                                  '(37)' CLIPPED,'(#chk30)'
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
                END IF
             END IF                     #FUN-610080
             IF l_ccg.ccg92 < -1   THEN
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(38)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING                                    
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_ccg.ccg92a < -1 THEN   #tianry add 
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(39)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_ccg.ccg92b < -1  THEN
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(40)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_ccg.ccg92c < -1  THEN
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(41)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_ccg.ccg92d < -1 THEN
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(42)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_ccg.ccg92e < -1 THEN
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(43)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''                 
             END IF
             IF l_ccg.ccg92f < -1 THEN 
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(43)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING    
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type
             END IF 
             IF l_ccg.ccg92g < -1 THEN 
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(43)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING    
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type
             END IF 
             IF l_ccg.ccg92h < -1 THEN 
                LET sr.type = 30
                LET sr.str_err=l_ccg.ccg01,                                     
                               '(43)' CLIPPED,'(#chk30)'
                EXECUTE insert_prep USING    
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type
             END IF 
             IF sr.ima911 != 'Y' THEN   #FUN-610080
                IF l_ccg.ccg91 < -1 THEN
                   LET sr.type = 30
                   LET sr.str_err=l_ccg.ccg01,                                  
                                  '(44)' CLIPPED,'(#chk30)'
                   EXECUTE insert_prep USING                                       
                           sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''                 
                END IF
             END IF                     #FUN-610080
          END IF
          IF tm.itemx = 35 OR tm.itemx = 0 THEN
             IF sr.ima911 != 'Y' THEN   #FUN-610080
                IF (l_ccg.ccg11+l_ccg.ccg21) = 0 AND 
                   (l_ccg.ccg12+l_ccg.ccg22+l_ccg.ccg23) <> 0 THEN
                   LET sr.type = 40 
                   LET sr.str_err=l_ccg.ccg01 clipped,                          
                                  '(45)' CLIPPED,"(#Adj40)" 
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
                END IF
             END IF                     #FUN-610080
          END IF
          IF tm.itemx = 41 OR tm.itemx = 0 THEN
             IF l_ccg.ccg32 >0 THEN 
                LET sr.type = 41
                LET sr.str_err=l_ccg.ccg01 clipped,                             
                       '(46)' CLIPPED,cl_numfor(l_ccg.ccg32,17,g_ccz.ccz26),"(#Adj41)"    #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                EXECUTE insert_prep USING                                    
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''              
             END IF
          END IF
          LET l_ccg92 = NULL  #MOD-6C0180 
          SELECT ccg92 INTO l_ccg92 FROM ccg_file
           WHERE ccg02 = g_yy AND ccg03 = g_mm AND ccg01 = l_ccg.ccg01
             AND ccg04 = l_ccg.ccg04 AND ccg06 = tm.type   #FUN-830002
          IF cl_null(l_ccg92) THEN
            SELECT SUM(ccf12) INTO l_ccg92 FROM ccf_file
             WHERE ccf02 = g_yy AND ccf03 = g_mm AND ccf01 = l_ccg.ccg01
             AND ccf06 = l_ccg.ccg06                   #FUN-7C0101
          END IF
          IF l_ccg92 IS NULL OR STATUS THEN LET l_ccg92 = 0 END IF 
          IF l_ccg92 != l_ccg.ccg12 THEN 
             LET sr.type = 42
             LET l_diff = l_ccg.ccg12 - l_ccg92
             LET sr.str_err=l_ccg.ccg01 clipped,                                
              '(47)' CLIPPED,cl_numfor(l_ccg92,17,g_ccz.ccz26),             #MOD-C70189 取位 3->g_ccz.ccz26
              " != ",'(48)' CLIPPED,cl_numfor(l_ccg.ccg12,17,g_ccz.ccz26),  #MOD-C70189 取位 3->g_ccz.ccz26
              "(",cl_numfor(l_diff,17,g_ccz.ccz26),")(#Adj42)"              #MOD-C70189 取位 3->g_ccz.ccz26
             EXECUTE insert_prep USING                                       
                     sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
          END IF 
          IF tm.itemx = -77 OR tm.itemx = 0 THEN
             LET l_cch22 = 0
             SELECT SUM(cch22) INTO l_cch22 FROM cch_file
              WHERE cch01 = l_ccg.ccg01
                AND cch02 = l_ccg.ccg02
                AND cch03 = l_ccg.ccg03
                AND cch06 = tm.type   #FUN-830002
             IF cl_null(l_cch22) THEN LET l_cch22 = 0 END IF
             IF (l_ccg.ccg22+l_ccg.ccg23) <> l_cch22 THEN
                LET sr.type = 51 
                LET sr.str_err=l_ccg.ccg01 clipped,                             
                 '(49)' CLIPPED,l_ccg.ccg22+cl_numfor(l_ccg.ccg23,17,g_ccz.ccz26),  #MOD-C70189 取位 g_azi03->g_ccz.ccz26
              " #",'(50)' CLIPPED,cl_numfor(l_cch22,17,g_ccz.ccz26),"(#Adj51)"       #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                EXECUTE insert_prep USING                                          
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             LET l_cch32=0
             SELECT SUM(cch32) INTO l_cch32 FROM cch_file
              WHERE cch01 = l_ccg.ccg01
                AND cch02 = l_ccg.ccg02
                AND cch03 = l_ccg.ccg03
                AND cch06 = tm.type   #FUN-830002
             IF cl_null(l_cch32) THEN LET l_cch32 = 0 END IF
             IF l_ccg.ccg32 <> l_cch32 THEN
                LET sr.type = 51 
                 LET sr.str_err=l_ccg.ccg01 clipped,                             
                   '(51)' CLIPPED,cl_numfor(l_ccg.ccg32*-1,17,g_ccz.ccz26),          #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                   '(52)' CLIPPED,cl_numfor(l_cch32*-1,17,g_ccz.ccz26),"(#Adj51)"    #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type   #No.MOD-910220 add ''                   
             END IF
             LET l_cch12=0
             SELECT SUM(cch12) INTO l_cch12 FROM cch_file
              WHERE cch01 = l_ccg.ccg01
                AND cch02 = l_ccg.ccg02
                AND cch03 = l_ccg.ccg03
                AND cch06 = tm.type   #FUN-830002
             IF cl_null(l_cch12) THEN LET l_cch12 = 0 END IF
             IF l_ccg.ccg12 <> l_cch12 THEN
                LET sr.type = 51 
                LET sr.str_err=l_ccg.ccg01 clipped,                             
                      '(53)' CLIPPED,cl_numfor(l_ccg.ccg12,17,g_ccz.ccz26),          #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                      '(54)' CLIPPED,cl_numfor(l_cch12,17,g_ccz.ccz26),"(#Adj51)"    #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''                
             END IF
             LET l_cch92=0
             SELECT SUM(cch92) INTO l_cch92 FROM cch_file
              WHERE cch01 = l_ccg.ccg01
                AND cch02 = l_ccg.ccg02
                AND cch03 = l_ccg.ccg03
                AND cch06 = tm.type   #FUN-830002
             IF cl_null(l_cch92) THEN LET l_cch92 = 0 END IF
             IF l_ccg.ccg92 <> l_cch92 THEN
                LET sr.type = 51 
                LET sr.str_err=l_ccg.ccg01 clipped,                             
                      '(55)' CLIPPED,cl_numfor(l_ccg.ccg92,17,g_ccz.ccz26),          #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                      '(56)' CLIPPED,cl_numfor(l_cch92,17,g_ccz.ccz26),"(#Adj51)"    #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''                 
             END IF
             LET l_cch42=0
             SELECT SUM(cch42) INTO l_cch42 FROM cch_file
              WHERE cch01 = l_ccg.ccg01
                AND cch02 = l_ccg.ccg02
                AND cch03 = l_ccg.ccg03
                AND cch06 = tm.type   #FUN-830002
             IF cl_null(l_cch42) THEN LET l_cch42 = 0 END IF
             IF l_ccg.ccg42 <> l_cch42 THEN
                LET sr.type = 51
                LET sr.str_err=l_ccg.ccg01 clipped,                             
                      '(57)' CLIPPED,cl_numfor(l_ccg.ccg42,17,g_ccz.ccz26),          #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                      '(58)' CLIPPED,cl_numfor(l_cch42,17,g_ccz.ccz26),"(#Adj51)"    #MOD-C70189 取位 g_azi03->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''                
             END IF
             LET l_cch60=0
             SELECT SUM(cch60) INTO l_cch60 FROM cch_file
              WHERE cch01 = l_ccg.ccg01
                AND cch02 = l_ccg.ccg02
                AND cch03 = l_ccg.ccg03
                AND cch06 = tm.type   #FUN-830002
             IF cl_null(l_cch60) THEN LET l_cch60 = 0 END IF
          END IF
  END IF 
      #拆件式工單不做chk25檢查
       LET l_sfb02 = ''
       SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01=l_ccg.ccg01
       #----------------元件檢查chk25-----------------------
      IF (tm.itemx =-66 OR tm.itemx = 25 OR tm.itemx = 0   #CHI-870016
       OR tm.itemx = 50 OR tm.itemx = 35)   #THEN          #CHI-870016
       AND l_sfb02 != 11 THEN                              #CHI-870016
             FOREACH cch_curs USING l_ccg.ccg01 INTO l_cch.*
                IF SQLCA.sqlcode THEN 
                   CALL cl_err('foreach cch_curs',SQLCA.sqlcode,0)
                   EXIT FOREACH
                END IF
                IF l_cch.cch92 < -1 THEN   #tianry add 170214   0->-1
                  LET sr.type = 25
                  LET sr.str_err = l_cch.cch01 CLIPPED ,' ',                    
                    l_cch.cch04 CLIPPED,'(61)' CLIPPED,                        
                    cl_numfor(l_cch.cch92,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                  EXECUTE insert_prep USING                                       
                          sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07                 
                END IF
                IF l_cch.cch92a < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',                   
                   l_cch.cch04 CLIPPED,'(62)' CLIPPED,                        
                   cl_numfor(l_cch.cch92a,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING                                     
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                END IF
                IF l_cch.cch92b < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',                   
                   l_cch.cch04 CLIPPED,'(63)' CLIPPED,                        
                   cl_numfor(l_cch.cch92b,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                END IF
                IF l_cch.cch92c < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',                   
                   l_cch.cch04 CLIPPED,'(64)' CLIPPED,                        
                   cl_numfor(l_cch.cch92c,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                END IF
                IF l_cch.cch92d < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',                   
                   l_cch.cch04 CLIPPED,'(65)' CLIPPED,                        
                   cl_numfor(l_cch.cch92d,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                END IF
                IF l_cch.cch92e < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',                   
                   l_cch.cch04 CLIPPED,'(66)' CLIPPED,                        
                   cl_numfor(l_cch.cch92e,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING                                    
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                END IF
                IF l_cch.cch92f < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',l_cch.cch04 CLIPPED,'(66)' CLIPPED,   
                                    cl_numfor(l_cch.cch92f,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type
                END IF 
                IF l_cch.cch92g < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',l_cch.cch04 CLIPPED,'(66)' CLIPPED,   
                                    cl_numfor(l_cch.cch92g,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type
                END IF
                IF l_cch.cch92h < -1 THEN   #tianry add 170214   0->-1
                   LET sr.type = 25
                   LET sr.str_err = l_cch.cch01 CLIPPED ,' ',l_cch.cch04 CLIPPED,'(66)' CLIPPED,   
                                    cl_numfor(l_cch.cch92h,17,g_ccz.ccz26),' (#chk25)'      #MOD-C70189 取位 3->g_ccz.ccz26
                   EXECUTE insert_prep USING
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type
                END IF  
                IF sr.ima911 != 'Y' THEN   #FUN-610080
                   IF l_cch.cch91 < 0 THEN
                      LET sr.type = 35
                      LET sr.str_err=l_cch.cch01 CLIPPED,' ',l_cch.cch04 CLIPPED,
                       '(67)' CLIPPED,cl_numfor(l_cch.cch91,17,g_ccz.ccz27) #,              #MOD-C70189 取位 3->g_ccz.ccz27
                         # ' (#chk35)'
                      EXECUTE insert_prep USING                                    
                              sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                   END IF
                   IF (l_cch.cch11+l_cch.cch21) = 0 AND
                  # (l_cch.cch12+l_cch.cch22) >tm.adj45   #CHI-A50003 mark
                  #       AND l_cch.cch04 != ' DL+OH+SUB' #CHI-A50003 mark
                              l_cch.cch04 != ' DL+OH+SUB' #CHI-A50003
                   THEN LET sr.type = 45 
                        LET sr.str_err=l_cch.cch01 clipped,' ',l_cch.cch04 clipped,
                            '(68)' CLIPPED,"(#Adj45)"
                        EXECUTE insert_prep USING                                 
                                sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                   END IF
                END IF                     #FUN-610080
                IF l_cch.cch32 > 0 THEN
                     LET sr.type = 45 
                     LET sr.str_err=l_cch.cch01 clipped,' ',l_cch.cch04 clipped,
                                    '(69)' CLIPPED,"(#Adj45)"
                     EXECUTE insert_prep USING                               
                                sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #NO.MOD-910220 add cch07
                END IF 
                LET l_cch91 = 0 LET l_cch92 = 0
                SELECT cch91,cch92 INTO l_cch91 ,l_cch92 FROM cch_file
                 WHERE cch01 = l_cch.cch01 AND cch02 = g_yy AND cch03 = g_mm
                   AND cch04 = l_cch.cch04 AND cch06 = tm.type   #FUN-830002
                   AND cch07 = l_cch.cch07   #No.MOD-910220
                IF l_cch91 IS NULL THEN LET l_cch91 = 0 END IF 
                IF l_cch92 IS NULL THEN LET l_cch92 = 0 END IF 
                IF sr.ima911 != 'Y' THEN   #FUN-610080
                   IF l_cch91 != l_cch.cch11 THEN
                      LET sr.type = 45 
                      LET sr.str_err=l_cch.cch01 clipped,' ',l_cch.cch04 clipped,
                                     '(70)' CLIPPED,"(#Adj45)"
                      EXECUTE insert_prep USING                                  
                              sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07 
                   END IF 
                END IF                     #FUN-610080
                IF l_cch92 != l_cch.cch12 THEN
                   LET sr.type = 45 
                   LET sr.str_err=l_cch.cch01 clipped,' ',l_cch.cch04 clipped,  
                                  '(71)' CLIPPED,"(#Adj45)"
                   EXECUTE insert_prep USING                                 
                           sr.ima01,sr.ima02,sr.ima021,l_cch.cch07,sr.str_err,sr.type #No.MOD-910220 add cch07
                END IF 
             END FOREACH 
          END IF 
          #no.7394 聯產品檢查 Type = 99 (FOR ccg_file)
          IF tm.itemx=0 OR tm.itemx=99 THEN
             SELECT SUM(cce22a),SUM(cce22b),SUM(cce22c),SUM(cce22d),
                    SUM(cce22e),SUM(cce22f),SUM(cce22g),SUM(cce22h)             #FUN-7C0101
               INTO l_cce22a,l_cce22b,l_cce22c,l_cce22d,l_cce22e,l_cce22f,l_cce22g,l_cce22h           #FUN-7C0101
               FROM cce_file
              WHERE cce01 = l_ccg.ccg01 AND cce02 = tm.ccc02 
                AND cce03 = tm.ccc03
                AND cce06 = tm.type                #FUN-7C0101
             LET l_cce22a = l_cce22a * -1
             LET l_cce22b = l_cce22b * -1
             LET l_cce22c = l_cce22c * -1
             LET l_cce22d = l_cce22d * -1
             LET l_cce22e = l_cce22e * -1
            #-----------------No:TQC-A40139 modify
             LET l_cce22f = l_cce22f * -1
             LET l_cce22g = l_cce22g * -1
             LET l_cce22h = l_cce22h * -1
            #-----------------No:TQC-A40139 end
             IF l_cce22a != l_ccg.ccg32a THEN
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ', 
                '(73)' CLIPPED,' ',cl_numfor(l_cce22a,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(74)' CLIPPED,' ',cl_numfor(l_ccg.ccg32a,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                    
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''             
             END IF
             IF l_cce22b != l_ccg.ccg32b THEN
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ', 
                '(75)' CLIPPED,' ',cl_numfor(l_cce22b,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26              
                '(76)' CLIPPED,' ',cl_numfor(l_ccg.ccg32b,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''             
             END IF
             IF l_cce22c != l_ccg.ccg32c THEN
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ', 
                '(77)' CLIPPED,' ',cl_numfor(l_cce22c,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(78)' CLIPPED,' ',cl_numfor(l_ccg.ccg32c,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''                
             END IF
             IF l_cce22d != l_ccg.ccg32d THEN
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ', 
                '(79)' CLIPPED,' ',cl_numfor(l_cce22d,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(80)' CLIPPED,' ',cl_numfor(l_ccg.ccg32d,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''                
             END IF
             IF l_cce22e != l_ccg.ccg32e THEN
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ', 
                '(81)' CLIPPED,' ',cl_numfor(l_cce22e,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(82)' CLIPPED,' ',cl_numfor(l_ccg.ccg32e,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type   #No.MOD-910220 add ''               
             END IF
             IF l_cce22f != l_ccg.ccg32f THEN 
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ',
                '(81)' CLIPPED,' ',cl_numfor(l_cce22f,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(82)' CLIPPED,' ',cl_numfor(l_ccg.ccg32f,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING 
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type
             END IF 
             IF l_cce22g != l_ccg.ccg32g THEN 
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ',
                '(81)' CLIPPED,' ',cl_numfor(l_cce22g,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(82)' CLIPPED,' ',cl_numfor(l_ccg.ccg32g,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING 
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type
             END IF 
             IF l_cce22h != l_ccg.ccg32h THEN 
                LET sr.type = 99
                LET sr.str_err = '(72)' CLIPPED,' ',l_ccg.ccg01 CLIPPED ,' ',
                '(81)' CLIPPED,' ',cl_numfor(l_cce22h,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(82)' CLIPPED,' ',cl_numfor(l_ccg.ccg32h,17,g_ccz.ccz26),' (#chk99)'   #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING 
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type
             END IF 
          END IF
       END FOREACH  #(foreach for ccg end)
 
          #no.7394 聯產品檢查 Type = 98(FOR ccc_file)
          IF tm.itemx=0 OR tm.itemx=98 THEN
             SELECT SUM(cce22a),SUM(cce22b),SUM(cce22c),SUM(cce22d),
                    SUM(cce22e),SUM(cce22f),SUM(cce22g),SUM(cce22h)             #FUN-7C0101
               INTO l_cce22a,l_cce22b,l_cce22c,l_cce22d,l_cce22e,l_cce22f,l_cce22g,l_cce22h       #FUN-7C0101
               FROM cce_file
              WHERE cce04 = sr.ccc.ccc01 AND cce02 = tm.ccc02 
                AND cce03 = tm.ccc03 AND cce06 = tm.type                        #FUN-7C0101
             IF l_cce22a != (sr.ccc.ccc22a3+sr.ccc.ccc22a2+sr.ccc.ccc28a) THEN    #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err =                                                
                '(83)' CLIPPED,' ',cl_numfor(l_cce22a,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26                  
             
                '(84)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22a3+sr.ccc.ccc28a,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_cce22b != sr.ccc.ccc22b3 + sr.ccc.ccc22b2+sr.ccc.ccc28b THEN  #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err =                                                
                '(85)' CLIPPED,' ',cl_numfor(l_cce22b,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(86)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22b3+sr.ccc.ccc28b,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''                
             END IF
             IF l_cce22c != sr.ccc.ccc22c3+sr.ccc.ccc22c2+sr.ccc.ccc28c THEN  #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err =                                                
                '(87)' CLIPPED,' ',cl_numfor(l_cce22c,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(88)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22c3+sr.ccc.ccc28c,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_cce22d != sr.ccc.ccc22d3+sr.ccc.ccc22d2+sr.ccc.ccc28d THEN    #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err =                                                
                '(89)' CLIPPED,' ',cl_numfor(l_cce22d,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(90)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22d3+sr.ccc.ccc28d,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type #No.MOD-910220 add ''
             END IF
             IF l_cce22e != sr.ccc.ccc22e3+sr.ccc.ccc22e2+sr.ccc.ccc28e THEN   #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err =                                                
                '(91)' CLIPPED,' ',cl_numfor(l_cce22e,17,g_ccz.ccz26),' ',              #MOD-C70189 取位 3->g_ccz.ccz26
                '(92)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22e3+sr.ccc.ccc28e,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING                                       
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type  #No.MOD-910220 add ''
             END IF
#            IF l_cce22f != sr.ccc.ccc22f + sr.ccc.ccc28f THEN  #No.TQC-A40139
             IF l_cce22f != sr.ccc.ccc22f3+sr.ccc.ccc22f2+sr.ccc.ccc28f THEN   #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err = '(91)' CLIPPED,' ',cl_numfor(l_cce22f,17,g_ccz.ccz26),' ',             #MOD-C70189 取位 3->g_ccz.ccz26
                '(92)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22f+sr.ccc.ccc28f,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING 
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type                 
             END IF 
             IF l_cce22g != sr.ccc.ccc22g3+sr.ccc.ccc22g2+sr.ccc.ccc28g THEN   #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err = '(91)' CLIPPED,' ',cl_numfor(l_cce22g,17,g_ccz.ccz26),' ',             #MOD-C70189 取位 3->g_ccz.ccz26
                '(92)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22g+sr.ccc.ccc28g,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING 
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type                 
             END IF 
             IF l_cce22h != sr.ccc.ccc22h3+sr.ccc.ccc22h2+sr.ccc.ccc28h THEN     #No:TQC-A40139 modify
                LET sr.type = 98
                LET sr.str_err = '(91)' CLIPPED,' ',cl_numfor(l_cce22h,17,g_ccz.ccz26),' ',             #MOD-C70189 取位 3->g_ccz.ccz26
                '(92)' CLIPPED,' ',cl_numfor(sr.ccc.ccc22h+sr.ccc.ccc28h,17,g_ccz.ccz26),' (#chk98)'    #MOD-C70189 取位 3->g_ccz.ccz26
                EXECUTE insert_prep USING 
                        sr.ima01,sr.ima02,sr.ima021,'',sr.str_err,sr.type                 
             END IF 
          END IF
#FUN-930021----------BEGIN
#mark  by ly 170929
{
         IF cl_null(sr.ima12) THEN
            LET sr.type = 93
            LET sr.str_err = sr.ccc.ccc01,'(93)' CLIPPED
            EXECUTE insert_prep USING
                    sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type
         END IF
}
#FUN-930021-----------END
         #FUN-C50130 add str---------------------
         #-----成本階檢查-----
         FOREACH ccg_curs01 USING sr.ima01 INTO l_ccg_cch.*
            IF SQLCA.sqlcode THEN 
               CALL cl_err('foreach ccg_curs',SQLCA.sqlcode,0)
               EXIT FOREACH 
            END IF
            LET sr.type = 94
            LET sr.str_err = l_ccg_cch.ccg01,l_ccg_cch.ima57a,'(94)' CLIPPED,l_ccg_cch.cch04,l_ccg_cch.ima57b
            IF l_ccg_cch.sfb99 IS NULL OR l_ccg_cch.sfb99=' ' OR l_ccg_cch.sfb99 ='N' THEN 
               EXECUTE insert_prep USING
                       sr.ima01,sr.ima02,sr.ima021,sr.ccc.ccc08,sr.str_err,sr.type
            END IF 
         END FOREACH 
         #FUN-C50130 add end---------------------
     END FOREACH    #(foreach for ccc end)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''                                                               
     IF g_zz05 = 'Y' THEN                                                         
          CALL cl_wcchp(tm.wc,'ima01,ima12,ima57')                        
                RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.ccc02,";",tm.ccc03,";",tm.type
     #darcy:2024/07/03 add s---
     #darcy:2023/06/14 add s---
   #   let l_sql = "select   ima01,ima02,ima021,ccc08,axcr370(str_err) str_err ,type ty from ",g_cr_db_str CLIPPED,l_table CLIPPED
   #   call cl_fast_query_zat(
   #       "pqraxc0001",
   #       l_sql,
   #       true
   #    )
   #    return
     #darcy:2023/06/14 add e---
     #darcy:2024/07/03 add e---
     CALL cl_prt_cs3('axcr370','axcr370',l_sql,g_str)
 
END FUNCTION
 
 
#CHI-A70034 mark --start--
#FUNCTION r370_kind(p_cmd)
#DEFINE
#	p_cmd LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
#	l_indo DYNAMIC ARRAY OF RECORD
#		sss LIKE type_file.num5,           #No.FUN-680122SMALLINT	
#		eee LIKE type_file.num5            #No.FUN-680122SMALLINT
#		END RECORD,
#	l_c30 LIKE type_file.chr1000,        #No.FUN-680122CHAR(30) #TQC-840066
#	l_n,l_inx,l_inx1 LIKE type_file.num5           #No.FUN-680122 SMALLINT
# 
#    LET g_errno = ' '
#    FOR l_n=24 TO 48
#        IF tm.itemx =g_x[l_n].substring(1,4) THEN  #by kim
#           LET l_inx1=l_n               #check 所輸入是否已定義好
#           LET l_c30=g_x[l_n].substring(5,40)          #之單据(za)
#           EXIT FOR
#        END IF
#    END FOR
# 
#    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#       DISPLAY l_c30 TO FORMONLY.desc_x 
#    END IF
#END FUNCTION
#CHI-A70034 mark --end--
#No.FUN-9C0073 -----------------By chenls 10/01/12
