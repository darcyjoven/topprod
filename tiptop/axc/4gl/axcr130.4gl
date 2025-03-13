# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr130.4gl
# Descriptions...: 銷貨毛利分析表(BY 料件)
# Date & Author..: 98/05/30 By Star
# Modify ........: No:8628 03/11/03 By Melody occ37 判斷式應拿掉,與axcr161 match
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0071 04/12/13 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                   #如果二個幣別相同時，匯率強制為 1
# Modify.........: No:BUG-4C0078 04/12/14 By pengu sql 中判斷 oga09 = '2' 之兩處，皆應該改為 oga09 !='1' AND oga09 !='5'   #MOD-4C0078
# Modify.........: No.FUN-4C0099 04/12/28 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.MOD-540083 05/05/03 By kim 拿掉BOM材料欄位
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-660073 06/09/14 By Nicola 訂單樣品修改
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-6A0146/FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-6B0063 06/12/08 By claire MOD-540083 未調整
# Modify.........: No.CHI-6A0063 06/12/14 By rainy  銷退資料屬「5、折讓」的部份，銷退金額改抓ohb1
# Modify.........: No.MOD-710129 07/01/23 By jamie MISC的判斷需取前四碼 
# Modify.........: No.MOD-720076 07/02/13 By pengu 銷售金額SUM(ogb12*ogb13*oga24)調整為SUM(ogb14*oga24)
# Modify.........: No.FUN-7B0044 07/12/20 By Sarah 移除Input中的"應加減折讓/雜項發票/內部自用"
# Modify.........: No.FUN-7C0101 08/01/25 By Zhangyajun 成本改善增加成本計算類型字段(type)
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-880182 08/08/26 By Pengu 銷退部分應排除非成本倉
# Modify.........: No.MOD-880124 08/09/03 By Pengu 材料/加工會是累加,不是平均值
# Modify.........: No.MOD-890146 08/09/23 By Pengu 在計算銷貨成本時先做取位後在做加總
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.TQC-980163 09/09/01 By liuxqa將產生的臨時表的表名寫死。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.TQC-A40130 10/04/28 By Carrier GP5.2报表追单
# Modify.........: No:CHI-9C0059 11/01/17 By kim GP5.1成本改善問題修改
# Modify.........: No:MOD-C70200 12/07/18 By ck2yuan AFTER GROUP時取位均使用t_azi05
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-A70023 13/01/30 By Alberti 調整成品替代的銷貨收入
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD            
            wc       STRING,
            yy1_b,mm1_b,mm1_e LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
            type     LIKE type_file.chr1,     #No.FUN-7C0101 VARCHAR(1)
            azh01    LIKE azh_file.azh01,
            azh02    LIKE azh_file.azh02,
            azk01    LIKE azk_file.azk01,
            azk04    LIKE azk_file.azk04,
            dec      LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),       #金額單位(1)元(2)千(3)萬
            z        LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
            more     LIKE type_file.chr1      #No.FUN-680122 VARCHAR(01)
           END RECORD 
DEFINE g_bdate,g_edate  LIKE type_file.dat                 #No.FUN-680122 DATE
DEFINE g_orderA   ARRAY[2] OF LIKE type_file.chr20      #No.FUN-680122 VARCHAR(10)
DEFINE g_bookno   LIKE aaa_file.aaa01      #No.FUN-670039
DEFINE g_base     LIKE type_file.num10     #No.FUN-680122 INTEGER
DEFINE g_y,g_m    LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
       g_tname    LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),               #tmpfile name
       g_tname1   LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),               #tmpfile name
       g_delsql   LIKE type_file.chr1000,  #execute sys_cmd  #No.FUN-680122 VARCHAR(50)
       g_delsql1  LIKE type_file.chr1000,  #execute sys_cmd  #No.FUN-680122 VARCHAR(50)
       g_sum      RECORD
          qty     LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3),  #數量(內銷) #TQC-840066
          amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #金額(內銷)
          cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #成本(內銷)
          qty1    LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3),  #數量(內退) #TQC-840066
          amt1    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #金額(內退)
          cost1   LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #成本(內退)
          dae_amt LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),  #折讓
          dac_amt LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)   #雜項發票
                  END RECORD
DEFINE g_i        LIKE type_file.num5      #count/index for any purpose  #No.FUN-680122 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.yy1_b = ARG_VAL(8)
   LET tm.mm1_b = ARG_VAL(9)
   LET tm.mm1_e = ARG_VAL(10)
   LET tm.azh01 = ARG_VAL(11)
   LET tm.azk01 = ARG_VAL(12)
   LET tm.azk04 = ARG_VAL(13)
   LET tm.z     = ARG_VAL(14)
   LET tm.dec   = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_bookno   = ARG_VAL(19)
   LET tm.type    = ARG_VAL(20)   #No.FUN-7C0101 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r130_tm(0,0)        
      ELSE CALL r130()             
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r130_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,   #No.FUN-580031
       p_row,p_col    LIKE type_file.num5,   #No.FUN-680122 SMALLINT
       l_date         LIKE type_file.dat,    #No.FUN-680122 DATE,
       l_cmd          LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(400)
 
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW r130_w AT p_row,p_col WITH FORM "axc/42f/axcr130"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.dec = '1'
   LET tm.z = 'N'
   LET tm.more = 'N'
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.type  = g_ccz.ccz28   #No.FUN-7C0101 add
   LET tm.azk01 =  g_aza.aza17  #No:8488
   LET tm.azk04 = 1
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET g_base   = 1
 
WHILE TRUE
   LET tm.wc=NULL 
   CONSTRUCT BY NAME tm.wc ON ima01,ima12
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp                                                                                              
         CASE
            WHEN INFIELD(ima01)   #料件編號                                                                                                 
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO ima01                                                                                 
               NEXT FIELD ima01                                                                                                     
            WHEN INFIELD(ima12)   #成本分群
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
         END CASE  
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r130_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
      
   INPUT BY NAME tm.type,tm.yy1_b,tm.mm1_b,tm.mm1_e,tm.azh01,   #No.FUN-7C0101 add tm.type
                 tm.azk01,tm.azk04,tm.z,tm.dec,tm.more
         WITHOUT DEFAULTS 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      AFTER FIELD azh01
         IF NOT cl_null(tm.azh01) THEN
            SELECT azh02 INTO tm.azh02 FROM azh_file
             WHERE azh01 = tm.azh01
            IF SQLCA.SQLCODE = 100 THEN
               CALL cl_err3("sel","azh_file",tm.azh01,"","mfg6217","","",1)   #No.FUN-660127
               NEXT FIELD azh01
            END IF
         END IF
 
      AFTER FIELD azk01
         IF NOT cl_null(tm.azk01) THEN 
            SELECT * FROM azi_file 
            WHERE azi01 = tm.azk01  
            IF STATUS != 0 THEN
               CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)   #No.FUN-660127
               NEXT FIELD azk01   
            END IF
 
            # azk04 賣出匯率
            SELECT MAX(azk02) INTO l_date FROM azk_file
            SELECT azk04 INTO tm.azk04 FROM azk_file
            WHERE azk01 = tm.azk01 AND azk02 =l_date
            DISPLAY BY NAME  tm.azk04
         ELSE
            LET tm.azk04 = 0
            DISPLAY BY NAME tm.azk04
         END IF
##
      AFTER FIELD azk04                    #FUN-4C0071
         IF tm.azk01 =g_aza.aza17 THEN
            LET tm.azk04 =1
            DISPLAY tm.azk04  TO azk04 
         END IF  
 
      AFTER FIELD dec
         IF tm.dec NOT MATCHES '[123]' THEN NEXT FIELD dec END IF
         CASE tm.dec WHEN 1 LET g_base = 1
                     WHEN 2 LET g_base = 1000
                     WHEN 3 LET g_base = 10000
                     OTHERWISE NEXT FIELD dec
         END CASE
       
      AFTER FIELD z
         IF cl_null(tm.z) OR tm.z NOT MATCHES '[yYNn]' THEN
            NEXT FIELD z
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLP 
         CASE
            WHEN INFIELD(azk01) #幣別檔
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = tm.azk01
                 CALL cl_create_qry() RETURNING tm.azk01
                 DISPLAY BY NAME tm.azk01
                 NEXT FIELD azk01
            WHEN INFIELD(azk04)
                 CALL s_rate(tm.azk01,tm.azk04) RETURNING tm.azk04
                 DISPLAY BY NAME tm.azk04
                 NEXT FIELD azk04
##
            WHEN INFIELD(azh01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azh'
                 LET g_qryparam.default1 = tm.azh01
                 LET g_qryparam.default2 = tm.azh02
                 CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
                 DISPLAY tm.azh01, tm.azh02 TO azh01, azh02 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()  
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(tm.azk01) THEN 
            LET tm.azk04 = 0
            DISPLAY BY NAME tm.azk04
        #CHI-C30012---begin
        ##--------------No:MOD-840687 add
        #    LET t_azi03 = g_azi03
        #    LET t_azi04 = g_azi04
        #    LET t_azi05 = g_azi05
        # ELSE 
        #    SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 
        #           FROM azi_file WHERE azi01 = tm.azk01
        ##--------------No:MOD-840687 end
        ##CHI-C30012---end
         END IF 
         #CHI-C30012---begin
         LET t_azi03 = g_ccz.ccz26
         LET t_azi04 = g_ccz.ccz26
         LET t_azi05 = g_ccz.ccz26
         #CHI-C30012---end 
##
         ##get 前期
         IF tm.mm1_e=1 THEN
            LET g_y=tm.yy1_b-1
            LET g_m=12 
         ELSE
            LET g_y=tm.yy1_b
            LET g_m=tm.mm1_e-1
         END IF
 
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
      LET INT_FLAG = 0 
      CLOSE WINDOW r130_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_b,tm.mm1_e)
        RETURNING g_bdate,g_edate
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr130'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr130','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_lang CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.yy1_b   CLIPPED,"'",
                     " '",tm.mm1_b   CLIPPED,"'",
                     " '",tm.mm1_e   CLIPPED,"'",
                     " '",tm.type   CLIPPED,"'",     #No.FUN-7C0101 
                     " '",tm.azh01   CLIPPED,"'",
                     " '",tm.azk01    CLIPPED,"'",
                     " '",tm.azk04    CLIPPED,"'",
                     " '",tm.z        CLIPPED,"'",
                     " '",tm.dec      CLIPPED,"'",
                     " '",g_rep_user  CLIPPED,"'",
                     " '",g_rep_clas CLIPPED,"'",   
                     " '",g_template  CLIPPED,"'",
                     " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr130',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r130()
   ERROR ""
END WHILE
   CLOSE WINDOW r130_w
END FUNCTION
 
FUNCTION r130()
   DEFINE l_name    LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-680122 VARCHAR(20)
          l_ima08   LIKE ima_file.ima08,
          l_sql     LIKE type_file.chr1000,  # RDSQL STATEMENT  #No.FUN-680122 VARCHAR(2000)
          l_za05    LIKE za_file.za05,       #No.FUN-680122 VARCHAR(40)
          l_qty     LIKE ccc_file.ccc21,     #No.MOD-880124 add
          l_flag    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1)
          sr     RECORD
              ima131  LIKE ima_file.ima131,
              ima01  LIKE ima_file.ima01,
              ima02  LIKE ima_file.ima02,
              ccc08   LIKE ccc_file.ccc08,     #No.FUN-7C0101 VARCHAR(40)
              qty     LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
              amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              um      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              ub      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              ul      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_qty  LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
              rq_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_cost LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              amt_us  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              cost_us LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              um_l    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              ul_l    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus   LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus_r LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)             
              END RECORD
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
  CALL get_tmpfile() #銷售
  LET l_sql=" SELECT ima131,ima01,ima02,ccc08,sum(qty),sum(amt),sum(cost),",     #No.FUN-7C0101 add ccc08
            " sum(um),sum(ub),sum(ul),sum(rq_qty),sum(rq_amt),sum(rq_cost)",
            " FROM ", g_tname CLIPPED,
      " GROUP BY ima131,ima01,ima02,ccc08 ",
      "  ORDER BY ima131,ima01,ima02,ccc08 "
  PREPARE r130_prepare1 FROM l_sql
  IF SQLCA.sqlcode != 0 THEN 
     CALL cl_err('prepare1:',SQLCA.sqlcode,1)    
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
     EXIT PROGRAM 
  END IF
  DECLARE r130_curs1 CURSOR FOR r130_prepare1
 
  CALL cl_outnam('axcr130') RETURNING l_name
  
  IF tm.type MATCHES '[12]' THEN
     LET g_zaa[34].zaa06='Y'
  END IF
  IF tm.type MATCHES '[345]' THEN
     LET g_zaa[34].zaa06='N'
  END IF
  
  CALL cl_prt_pos_len()   # No:MOD-960320 add
  START REPORT r130_rep TO l_name
 
  LET g_pageno = 0
  FOREACH r130_curs1 INTO sr.*
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('foreach:',SQLCA.sqlcode,1) 
     END IF
 
    ##get 前期材料,加工 
     SELECT ccc23a, (ccc23b+ccc23c+ccc23d+ccc23e+ccc23f+ccc23g+ccc23h)          #No.FUN-7C0101 mod
       INTO sr.um_l,sr.ul_l FROM ccc_file
      WHERE ccc01=sr.ima01 AND ccc02=g_y AND ccc03=g_m 
            AND ccc07 = tm.type AND ccc08 = sr.ccc08                            #No.FUN-7C0101 add
     IF STATUS=NOTFOUND THEN LET sr.um_l=0 LET sr.ul_l=0 END IF
 
     #重新SUM採料金額與加工金額及數量
     SELECT SUM(ccc12a+ccc22a+ccc26a+ccc28a),
            SUM(ccc12b+ccc22b+ccc26b+ccc28b+ 
                ccc12c+ccc22c+ccc26c+ccc28c+ 
                ccc12d+ccc22d+ccc26d+ccc28d+ 
                ccc12e+ccc22e+ccc26e+ccc28e),
            SUM(ccc11+ccc21+ccc25+ccc27)
       INTO sr.um,sr.ul,l_qty FROM ccc_file
      WHERE ccc01=sr.ima01 AND ccc02=tm.yy1_b
            AND ccc03  BETWEEN tm.mm1_b and tm.mm1_e 
            AND ccc07 = tm.type AND ccc08 = sr.ccc08   #No:MOD-960338 add  
 
     IF sr.um IS NULL THEN LET sr.um=0 END IF
     IF sr.ul IS NULL THEN LET sr.ul=0 END IF
     IF sr.ub IS NULL THEN LET sr.ub=0 END IF
     IF sr.um_l IS NULL THEN LET sr.um_l=0 END IF
     IF sr.ul_l IS NULL THEN LET sr.ul_l=0 END IF
     IF l_qty IS NULL THEN LET l_qty=0 END IF     #No.MOD-880124 add
     LET sr.amt=sr.amt/g_base
     LET sr.cost=sr.cost/g_base
     LET sr.rq_amt=sr.rq_amt/g_base
     LET sr.rq_cost=sr.rq_cost/g_base
     LET sr.um=sr.um/g_base
     LET sr.ub=sr.ub/g_base 
     LET sr.ul=sr.ul/g_base
     LET sr.um_l=sr.um_l/g_base
     LET sr.ul_l=sr.ul_l/g_base
     #計算才料金額與加工金額平均值
     IF l_qty > 0 THEN
        LET sr.um = sr.um / l_qty
        LET sr.ul = sr.ul / l_qty
     END IF
     IF sr.qty >0 THEN 
        LET sr.amt_us=sr.amt/sr.qty
        LET sr.cost_us=sr.cost/sr.qty
     ELSE
        LET sr.amt_us=sr.amt
        LET sr.cost_us=sr.cost
     END IF
                  
     IF tm.azk04 >0 THEN
        LET sr.amt_us=sr.amt_us/tm.azk04
        LET sr.cost_us=sr.cost_us/tm.azk04
        LET sr.um=sr.um/tm.azk04
        LET sr.ub=sr.ub/tm.azk04
        LET sr.ul=sr.ul/tm.azk04
        LET sr.um_l=sr.um_l/tm.azk04
        LET sr.ul_l=sr.ul_l/tm.azk04
     END IF
 
    ### 毛利
     IF tm.z matches '[Nn]' THEN LET sr.ima131=' ' END IF
     LET sr.bonus=(sr.amt-sr.rq_amt)-(sr.cost-sr.rq_cost) 
     IF (sr.amt-sr.rq_amt)<>0 THEN
        LET sr.bonus_r=sr.bonus/(sr.amt-sr.rq_amt)*100
     ELSE
        LET sr.bonus_r=-100
     END IF
     IF sr.qty<>0 OR sr.amt <>0 OR sr.rq_qty OR sr.rq_amt <>0 THEN
        OUTPUT TO REPORT r130_rep(sr.*)
     END IF
  END FOREACH
  FINISH REPORT r130_rep
 
  PREPARE del_cmd FROM g_delsql
  EXECUTE del_cmd
 
  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION get_tmpfile()
DEFINE l_dot   LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
DEFINE l_title LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(100)
DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(200)
DEFINE l_col   LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(200)
DEFINE l_tlf905   LIKE tlf_file.tlf905 #No:CHI-A70023 add
DEFINE l_tlf906   LIKE tlf_file.tlf906 #No:CHI-A70023 add
#-----------No:MOD-960339 modify
#DEFINE tmp_sql LIKE type_file.chr1000 #No.FUN-680122 CHAR(1000)
DEFINE tmp_sql STRING
#-----------No:MOD-960339 end
DEFINE de_qty  LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
       de_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
       de_cost LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)
DEFINE gettmp RECORD 
             ima131 LIKE ima_file.ima131,     #No.FUN-680122 VARCHAR(10),
             ima01  LIKE ima_file.ima01,
             ima02  LIKE ima_file.ima02,
             ccc08   LIKE ccc_file.ccc08,     #No.FUN-7C0101 VARCHAR(40)
             qty     LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
             amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
             cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
             um      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
             ub      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
             ul      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
             rq_qty  LIKE ogb_file.ogb16,     #No.FUN-680122 DEC(15,3), #TQC-840066
             rq_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
             rq_cost LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)
       END RECORD 
DEFINE l_ctype_str STRING  #CHI-9C0059
 
    LET g_tname='r130_tmp'                        #No.TQC-980163 mod
    LET g_delsql= " DROP TABLE ",g_tname CLIPPED
    PREPARE r130_del1 FROM g_delsql
    EXECUTE r130_del1 #delete tmpfile
 
    LET tmp_sql=
#FUN-9C0073 -----mark start
#        "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
#             "(ima131 VARCHAR(10),",
#             " ima01  VARCHAR(20),",
#             " ima02  VARCHAR(30),",
#             " ccc08  VARCHAR(40),",    #No.FUN-7C0101 add
#             " qty    DEC(15,3),",
#             " amt    DEC(20,6),",
#             " cost   DEC(20,6),",
#             " um     DEC(20,6),",
#             " ub     DEC(20,6),",
#             " ul     DEC(20,6),",
#             " rq_qty DEC(20,6),",
#             " rq_amt DEC(20,6),",
#             " rq_cost DEC(20,6))"
         "CREATE TEMP TABLE ",g_tname CLIPPED," (",
             " ima131 LIKE type_file.chr10,",
             " ima01  LIKE type_file.chr20,",
             " ima02  LIKE type_file.chr30,",
             " ccc08  LIKE type_file.chr50,",    #No.FUN-7C0101 add
             " qty    LIKE type_file.num20_6,",
             " amt    LIKE type_file.num20_6,",
             " cost   LIKE type_file.num20_6,",
             " um     LIKE type_file.num20_6,",
             " ub     LIKE type_file.num20_6,",
             " ul     LIKE type_file.num20_6,",
             " rq_qty LIKE type_file.num20_6,",
             " rq_amt LIKE type_file.num20_6,",
             " rq_cost LIKE type_file.num20_6)"
#FUN-9C0073 -----mark end
    PREPARE cre_p1 FROM tmp_sql
    EXECUTE cre_p1
    IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('Create axcr130_tmp:' ,SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
    # 準備Insert Into Temp File
    LET tmp_sql= " INSERT INTO ",g_tname CLIPPED,
                 " (ima131,ima01,ima02,ccc08,qty,amt,cost,um,ub,ul,rq_qty, ",    #No.FUN-7C0101 add ccc08
                 " rq_amt,rq_cost)  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "          #No.FUN-7C0101
    PREPARE r130_ins FROM tmp_sql
    IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('r130_ins:',SQLCA.sqlcode,1) 
       EXECUTE del_cmd #delete tmpfile
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM 
    END IF
 
    LET tmp_sql =    #出貨單刪除 
          "SELECT SUM(tlf10),SUM(ogb14*oga24)*-1,",
          "SUM(CAST(tlf21 AS DECIMAL(20,",t_azi04,")))  ",
          #No.TQC-A40130  --Begin No:MOD-980240
          " FROM tlf_file LEFT OUTER JOIN tlfc_file ",
          "               ON  tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
          "               AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",          #No.FUN-830002
          "               AND tlfc_file.tlfc13 = tlf13",                                       #No.FUN-830002 
          "               AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",      #No.FUN-830002                                               
          "               AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",      #No.FUN-830002                                               
          "               AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",      #No.FUN-7C0101
          ",smy_file ,ccc_file,oga_file,ima_file,ogb_file",
          #No.TQC-A40130  --End  
          " WHERE ",tm.wc CLIPPED,
         #---------------------No:MOD-980240 modif
         #" AND ogb1001=azf01 AND azf08 <>'Y' ",  #No:FUN-660073
          " AND (ogb1001 IS NULL OR ogb1001 ",
          "      IN (SELECT azf01 FROM azf_file WHERE  azf08 <>'Y')) ", 
         #---------------------No:MOD-980240 end
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 723 OR tlf03 = 725) AND tlf02 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf01=ccc01 ",
          " AND ccc02=YEAR(tlf06) AND ccc03=MONTH(tlf06) ",
          " AND ccc07= '",tm.type,"'",  #No.FUN-7C0101 add
          " AND ccc08=tlfcost ", #CHI-9C0059
          " AND tlfccost=tlfcost ", #CHI-9C0059
          " AND tlf01=ima01 ",
          " AND (oga65 != 'Y' OR oga09 = '8') ",    #No:MOD-990139 add
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 AND oga09 NOT IN ('1','5','7','9') ",   #MOD-4C0078  #No.FUN-610020
          " AND oga00 NOT IN ('A','2','3','7') ",   #No:MOD-980157 modify
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " AND tlfc_file.tlfctype = '",tm.type,"'",
          " AND ima01 = ? ",
          " AND tlfccost = ?"    #No.FUN-7C0101 add
 
          PREPARE r130_prepare3_r FROM tmp_sql
          DECLARE r130_curs3_r CURSOR FOR r130_prepare3_r
 
          #CHI-9C0059(S)
          CASE tm.type 
             WHEN '3'  LET l_ctype_str = " AND ccc_file.ccc08 = ohb_file.ohb092 "
             WHEN '5'  LET l_ctype_str = " AND ccc_file.ccc08 = imd_file.imd09  "
             OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
          END CASE
          #CHI-9C0059(E)

          ### insert 銷退資料 
          LET tmp_sql= "INSERT INTO ",g_tname,
              " SELECT ima131,ima01,'',ccc08, ",        #No.FUN-7C0101 add ccc08
              " 0,0,0,0,0,0, SUM(ohb16), ",
              " SUM(ohb13*ohb16*oha24),",
              " SUM(CAST((ohb16*ccc23) AS DECIMAL(20,",t_azi04,")))",
              " FROM oha_file,ohb_file,occ_file,ima_file, OUTER ccc_file,OUTER imd_file ",  #No.TQC-A40130  #CHI-9C0059
              " WHERE (oha02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
              " AND ccc02=YEAR(oha02) ",
              " AND ccc03=MONTH(oha02) ",
              " AND ccc07 = '",tm.type,"'",            #No.FUN-7C0101 add
              " AND ohaconf = 'Y' AND ohapost = 'Y' ",
              " AND ccc_file.ccc01 = ohb04 AND ohb04=ima01 AND oha01=ohb01 ",
              " AND ohb09 NOT IN (SELECT jce02 FROM jce_file)",  #No.MOD-880182 add
              " AND oha03 = occ01 ", # AND occ37 <> 'Y'", #No:8628
              " AND oha09 NOT IN ('2','5','6') ",  #No:MOD-980157 modify   #No:MOD-980190 modify
              " AND ohb_file.ohb09 = imd_file.imd01 ",  #CHI-9C0059
              l_ctype_str,  #CHI-9C0059
              " AND ",tm.wc CLIPPED,
              " GROUP BY ima131,ima01,ccc08 "                  #No.FUN-7C0101 add 4
     PREPARE ins_ohacmd FROM tmp_sql
     EXECUTE ins_ohacmd
          LET tmp_sql= "INSERT INTO ",g_tname,
              " SELECT ima131,ima01,'',ccc08, ",        #No.FUN-7C0101 add ccc08
              " 0,0,0,0,0,0, SUM(ohb16), ",
              " SUM(ohb14*oha24),",
              " SUM(CAST((ohb16*ccc23) AS DECIMAL(20,",t_azi04,")))",
              " FROM oha_file,ohb_file,occ_file,ima_file,OUTER ccc_file,OUTER imd_file ",  #No.TQC-A40130 #CHI-9C0059
              " WHERE (oha02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
              " AND ccc02=YEAR(oha02) ",
              " AND ccc03=MONTH(oha02) ",
              " AND ccc07 = '",tm.type,"'",            #No.FUN-7C0101 add
              " AND ohaconf = 'Y' AND ohapost = 'Y' ",
              " AND ccc01 = ohb04 AND ohb04=ima01 AND oha01=ohb01 ",
              " AND oha03 = occ01 ", # AND occ37 <> 'Y'", #No:8628
              " AND oha09 ='5'",    #5折讓的資料
              " AND ohb_file.ohb09 = imd_file.imd01 ",  #CHI-9C0059
              l_ctype_str,  #CHI-9C0059
              " AND ",tm.wc CLIPPED,
              " GROUP BY ima131,ima01,ccc08 "                   #No.FUN-7C0101 add 4
      PREPARE ins_ohacmd2 FROM tmp_sql
      EXECUTE ins_ohacmd2
    #CHI-9C0059(S)
    CASE tm.type 
       WHEN '3'  LET l_ctype_str = " AND ccc_file.ccc08 = ogb_file.ogb092 "
       WHEN '5'  LET l_ctype_str = " AND ccc_file.ccc08 = imd_file.imd09  "
       OTHERWISE LET l_ctype_str = " AND ccc08=' ' "
    END CASE
    #CHI-9C0059(E)
 
    LET tmp_sql= #" INSERT INTO ",g_tname,
	  " SELECT ima131,ima01,'',ccc08,",             #No.FUN-7C0101 add ccc08
     #     總銷售量    總銷售金額              總銷售成本 
         #---------------------No:MOD-890146 modify
         #" sum(ogb16),sum(ogb13*ogb16*oga24),sum(ogb16*ccc23),",
         #------------No:CHI-A70023 modify
         #" sum(ogb16),sum(ogb14*oga24),",
         #" sum(CAST((ogb16*ccc23) AS DECIMAL(20,",t_azi04,"))),",
          " sum(tlf10),sum(tlf10*ogb14/ogb12*oga24),",
          " sum(CAST((tlf10*ccc23) AS DECIMAL(20,",t_azi04,"))),",
         #------------No:CHI-A70023 end
         #---------------------No:MOD-890146 end
     #                  bom unit price
          " (ccc23a),         0,",     #MOD-6B0063 modify (ccc05)->0
          " (ccc23b+ccc23c+ccc23d+ccc23e+ccc23f+ccc23g+ccc23h), ",  #No.FUN-7C0101 mod
     #      銷退量     銷退金額   銷退成本 
          " 0         ,0         ,0           ",
          ",tlf905,tlf906 ",                   #No:CHI-A70023 add
         #---------------------No:MOD-980240 modify
         #" FROM oga_file,occ_file, ima_file, ccc_file,ogb_file, azf_file ",  #No.FUN-660073
          " FROM oga_file,occ_file, ima_file,OUTER ccc_file,ogb_file,OUTER imd_file,tlf_file ",	  #CHI-9C0059
         #---------------------No:MOD-980240 end
          " WHERE ",tm.wc CLIPPED,
         #---------------No:MOD-980240 modify
         #" AND ogb1001=azf01 AND azf08 <>'Y' ",  #No:FUN-660073
          " AND (ogb1001 IS NULL OR ogb1001 IN ",
          "      (SELECT azf01 FROM azf_file WHERE azf08 <>'Y')) ",  
         #---------------No:MOD-980240 end
          " AND ogb_file.ogb09 = imd_file.imd01 ",  #CHI-9C0059
          l_ctype_str,  #CHI-9C0059
         #---------------No:CHI-A70023 add
         #" AND ima01=ogb04 AND oga01 = ogb01 ",
          " AND oga01 = ogb01 ",
          " AND tlf905 = oga01 AND tlf906 = ogb03 AND tlf01 = ccc01",
         #---------------No:CHI-A70023 end
          " AND (oga02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
          " AND ccc02=YEAR(oga02) ",
          " AND ccc03=MONTH(oga02) ",
          " AND ccc07 = '",tm.type,"'",            #No.FUN-7C0101 add
          " AND ccc_file.ccc01=ima01 ",
          " AND (oga65 != 'Y' OR oga09 = '8') ",    #No:MOD-990139 add
          " AND oga09 NOT IN ('1','5','7','9') AND ogaconf = 'Y' AND ogapost = 'Y' ",  #MOD-4C0078  #No.FUN-610020
#         " AND oga03 = occ01 AND occ37 <> 'Y'",
          " AND oga03 = occ01 ", #AND occ37 <> 'Y'", #No:8628
          " AND oga00 NOT IN ('A','2','3','7') ",   #No:MOD-950210 modify    #No:MOD-980157 modify
        # " GROUP BY ima131,ima01,ccc08,ccc23a,ccc05,(ccc23b+ccc23c+ccc23d+ccc23e+ccc23f+ccc23g+ccc23h)" #No.MOD-960336
          " GROUP BY ima131,ima01,ccc08,ccc23a,(ccc23b+ccc23c+ccc23d+ccc23e+ccc23f+ccc23g+ccc23h),tlf905,tlf906" #No.MOD-960336	 #CHI-9C0059
 
          PREPARE r130_prepare3 FROM tmp_sql
          DECLARE r130_curs3 CURSOR FOR r130_prepare3
         #FOREACH r130_curs3 INTO gettmp.*                     #No:CHI-A70023 mark
          FOREACH r130_curs3 INTO gettmp.*,l_tlf905,l_tlf906   #No:CHI-A70023 add
             IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
                PREPARE del_cmd2 FROM g_delsql
                EXECUTE del_cmd2 #delete tmpfile
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
                EXIT PROGRAM 
             END IF
             LET de_qty = 0 LET de_amt = 0 LET de_cost = 0 
             OPEN r130_curs3_r USING gettmp.ima01,gettmp.ccc08   #No.FUN-7C0101 add ccc08
             FETCH r130_curs3_r INTO de_qty,de_amt,de_cost
             CLOSE r130_curs3_r 
             # 讀取 銷退資料
             IF cl_null(de_qty) THEN LET de_qty = 0 END IF 
             IF cl_null(de_amt) THEN LET de_amt = 0 END IF 
             IF cl_null(de_cost) THEN LET de_cost = 0 END IF 
             IF cl_null(gettmp.qty) THEN LET gettmp.qty = 0 END IF 
             IF cl_null(gettmp.amt) THEN LET gettmp.amt = 0 END IF 
             IF cl_null(gettmp.cost) THEN LET gettmp.cost = 0 END IF 
             LET gettmp.qty = gettmp.qty + de_qty
             LET gettmp.amt = gettmp.amt + de_amt
             LET gettmp.cost = gettmp.cost + de_cost
             EXECUTE r130_ins USING gettmp.*
          END FOREACH 
END FUNCTION
 
REPORT r130_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
DEFINE dec_name LIKE type_file.chr20        #No.FUN-680122 VARCHAR(10)
DEFINE l_ima02 LIKE ima_file.ima02
DEFINE l_ima021 LIKE ima_file.ima021
DEFINE 
       sr  RECORD
              ima131  LIKE ima_file.ima131,
              ima01  LIKE ima_file.ima01,
              ima02  LIKE ima_file.ima02,
              ccc08   LIKE ccc_file.ccc08,     #No.FUN-7C0101 VARCHAR(40) 
              qty     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              amt     LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              cost    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              um      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              ub      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              ul      LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_qty  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_amt  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              rq_cost LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              amt_us  LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              cost_us LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              um_l    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              ul_l    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus   LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6),
              bonus_r LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)
              END RECORD,
     p_amt_us,p_cost_us LIKE type_file.num20_6,  #No.FUN-680122 dec(20,6),
     p_um,p_um_l,p_ul,p_ul_l   LIKE type_file.num20_6,  #No.FUN-680122 dec(20,6),
     p_qty              LIKE type_file.num20_6,  #No.FUN-680122 dec(20,6),
     p_bonus_r,p_bonus  LIKE type_file.num20_6   #No.FUN-680122 dec(20,6)
 
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY  sr.ima131,sr.ima01
  FORMAT
   PAGE HEADER
      IF NOT cl_null(tm.azh02) THEN
         LET g_x[1] = tm.azh02
      ELSE 
         LET g_x[1] = g_x[1] 
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      IF tm.dec ='2' THEN 
         LET dec_name=g_x[11]      #千
      ELSE 
         IF tm.dec='3' THEN	
            LET dec_name=g_x[12]   #萬
         ELSE 
            LET dec_name=g_x[10]   #元
         END IF
      END IF
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01    #No.FUN-870151
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,g_x[9] CLIPPED,
                  #tm.azk01 clipped,'/',tm.azk04 using '<<&.&&',' ',    #No.FUN-870151
                   tm.azk01 clipped,'/',cl_numfor(tm.azk04,8,t_azi07),  #No.FUN-870151      
            COLUMN (g_len-FGL_WIDTH(dec_name))/2,dec_name clipped ##TQC-6A0078
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[22] CLIPPED,
            tm.yy1_b USING '####','/',tm.mm1_b USING '##','-',
                                      tm.mm1_e USING '##'
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[39],g_x[40],g_x[42], #MOD-540083
            g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]   #No.FUN-7C0101 add g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW 
    IF tm.z matches '[nN]' THEN 
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
          WHERE ima01=sr.ima01
      IF SQLCA.sqlcode THEN 
          LET l_ima02 = NULL 
          LET l_ima021 = NULL 
      END IF
 
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],l_ima02 CLIPPED, #MOD-4A0238
            COLUMN g_c[33],l_ima021 CLIPPED,
            COLUMN g_c[34],sr.ccc08 CLIPPED,                 #No.FUN-7C0101 add
            COLUMN g_c[35],cl_numfor(sr.qty,35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27  #No:MOD-960320 modify
            COLUMN g_c[36],cl_numfor(sr.amt,36,t_azi04),    #FUN-570190    #No:MOD-960320 modify    #MOD-840687 modify
            COLUMN g_c[37],cl_numfor(sr.amt_us,37,t_azi03),    #FUN-570190 #No:MOD-960320 modify    #MOD-840687 modify
            COLUMN g_c[38],cl_numfor(sr.cost,38,t_azi04),    #FUN-570190   #No:MOD-960320 modify    #MOD-840687 modify  
            COLUMN g_c[39],cl_numfor(sr.cost_us,39,t_azi03),  #FUN-570190  #No:MOD-960320 modify    #MOD-840687 modify
            COLUMN g_c[40],cl_numfor(sr.um,40,2),                          #No:MOD-960320 modify
            COLUMN g_c[42],cl_numfor(sr.um_l,42,2),                        #No:MOD-960320 modify
            COLUMN g_c[43],cl_numfor(sr.ul,43,2),                          #No:MOD-960320 modify
            COLUMN g_c[44],cl_numfor(sr.ul_l,44,2),                        #No:MOD-960320 modify
            COLUMN g_c[45],cl_numfor(sr.rq_qty,45,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27  #No:MOD-960320 modify
            COLUMN g_c[46],cl_numfor(sr.rq_amt,46,t_azi04),    #FUN-570190                  #No:MOD-960320 modify
            COLUMN g_c[47],cl_numfor(sr.rq_cost,47,t_azi03),    #FUN-570190     #No:MOD-960320 modify   #MOD-840687 modify
            COLUMN g_c[48],cl_numfor(sr.bonus,48,t_azi04),' ',    #FUN-570190   #No:MOD-960320 modify   #MOD-840687 modify 
            COLUMN g_c[49],cl_numfor(sr.bonus_r,49,2)                           #No:MOD-960320 modify   #MOD-840687 modify
    END IF
 
   AFTER GROUP OF sr.ima131
    IF tm.z MATCHES '[yY]' THEN
      SELECT oba02 INTO sr.ima02 FROM oba_file
      WHERE oba01=sr.ima131
      IF STATUS=NOTFOUND THEN LET sr.ima02=null END IF
      LET p_qty=GROUP SUM(sr.qty) 
      IF p_qty !=0 THEN
              LET p_amt_us=GROUP SUM(cl_numfor(sr.amt,35,t_azi05))/p_qty        #MOD-C70200  g_azi05->t_azi05  
              LET p_amt_us=cl_digcut(p_amt_us,t_azi05)/tm.azk04                 #MOD-C70200  g_azi05->t_azi05 
              LET p_cost_us=GROUP SUM(cl_digcut(sr.cost,t_azi05))/p_qty         #MOD-C70200  g_azi05->t_azi05 
              LET p_cost_us=cl_digcut(p_cost_us,t_azi05)/tm.azk04               #MOD-C70200  g_azi05->t_azi05
              LET p_um=GROUP SUM(cl_digcut(sr.um,t_azi05)*sr.qty)/p_qty         #MOD-C70200  g_azi05->t_azi05
              LET p_um_l=GROUP SUM(cl_digcut(sr.um_l,t_azi05)*sr.qty)/p_qty     #MOD-C70200  g_azi05->t_azi05
              LET p_ul=GROUP SUM(cl_digcut(sr.ul,t_azi05)*sr.qty)/p_qty         #MOD-C70200  g_azi05->t_azi05
              LET p_ul_l=GROUP SUM(cl_digcut(sr.ul_l,t_azi05)*sr.qty)/p_qty     #MOD-C70200  g_azi05->t_azi05
         ELSE LET p_amt_us=0
              LET p_cost_us=0
              LET p_um=0
              LET p_um_l=0
              LET p_ul=0
              LET p_ul_l=0
      END IF
      LET p_bonus=group sum(sr.amt-sr.rq_amt)
                 -group sum(sr.cost-sr.rq_cost) 
      IF group sum(sr.amt-sr.rq_amt)<>0 THEN
          LET p_bonus_r=p_bonus/group sum(sr.amt-sr.rq_amt)*100
      ELSE
          LET p_bonus_r=-100
      END IF
      
      SELECT ima021 INTO l_ima021 FROM ima_file 
       WHERE ima01=sr.ima131
      IF SQLCA.sqlcode THEN 
         LET l_ima021 = NULL 
      END IF
 
      PRINT COLUMN g_c[31],sr.ima131,' ',
            COLUMN g_c[32],sr.ima02 CLIPPED,  #MOD-4A0238
            COLUMN g_c[33],l_ima021 CLIPPED,
            COLUMN g_c[34],sr.ccc08 CLIPPED,                 #No.FUN-7C0101 add
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.qty),35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27   #No:MOD-960320 modify
            COLUMN g_c[36],cl_numfor(GROUP SUM(cl_digcut(sr.amt,t_azi05)),36,t_azi05),    #FUN-570190  #No.TQC-6A0078 #No:MOD-960320 modify  #MOD-840687 modify
            COLUMN g_c[37],cl_numfor(p_amt_us,37,2),           #No:MOD-960320 modify
            COLUMN g_c[38],cl_numfor(GROUP SUM(cl_digcut(sr.cost,t_azi05)),38,t_azi05),    #FUN-570190 #No.TQC-6A0078 #No:MOD-960320 modify  #MOD-840687 modify
            COLUMN g_c[39],cl_numfor(p_cost_us,39,2),      #No:MOD-960320 modify
            COLUMN g_c[40],cl_numfor(p_um,40,2),           #No:MOD-960320 modify
            COLUMN g_c[42],cl_numfor(p_um_l,42,2),         #No:MOD-960320 modify
          # Prog. Version..: '5.30.06-13.03.12(0,41,2), #MOD-540083  #No:MOD-960320 modify
            COLUMN g_c[43],cl_numfor(p_ul,43,2),           #No:MOD-960320 modify
            COLUMN g_c[44],cl_numfor(p_ul_l,44,2),         #No:MOD-960320 modify
            COLUMN g_c[45],cl_numfor(GROUP SUM(sr.rq_qty),45,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27  #No:MOD-960320 modify
            COLUMN g_c[46],cl_numfor(GROUP SUM(cl_digcut(sr.rq_amt,t_azi05)),46,g_azi05) ,    #FUN-570190 #No.TQC-6A0078 #No:MOD-960320 modify  #MOD-840687 modify
            COLUMN g_c[47],cl_numfor(GROUP SUM(cl_digcut(sr.rq_cost,t_azi05)),47,g_azi05),    #FUN-570190 #No:MOD-960320 modify                 #MOD-840687 modify
            COLUMN g_c[48],cl_numfor(p_bonus,48,t_azi05),    #FUN-570190 #No:MOD-960320 modify  #MOD-840687 modify
            COLUMN g_c[49],cl_numfor(p_bonus_r,49,2)   #No:MOD-960320 modify
 
      PRINT g_dash2
      END IF
   ON LAST ROW
      PRINT g_dash2
      PRINT COLUMN g_c[33],g_x[13] CLIPPED,
            COLUMN g_c[35],cl_numfor(SUM(sr.qty),35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz2       #No:MOD-960320 modify7
            COLUMN g_c[36],cl_numfor(SUM(cl_digcut(sr.amt,t_azi05)),36,t_azi05),    #FUN-570190   #No.TQC-6A0078  #No:MOD-960320 modify  ##MOD-840687 modify 
            COLUMN g_c[38],cl_numfor(SUM(cl_digcut(sr.cost,t_azi05)),38,t_azi05),    #FUN-570190  #No:MOD-960320 modify                  ##MOD-840687 modify
            COLUMN g_c[45],cl_numfor(SUM(sr.rq_qty),45,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27   #No:MOD-960320 modify
            COLUMN g_c[46],cl_numfor(SUM(cl_digcut(sr.rq_amt,t_azi05)),46,t_azi05),    #FUN-570190  #No.TQC-6A0078   #No:MOD-960320 modify   #MOD-840687 modify 
            COLUMN g_c[47],cl_numfor(SUM(cl_digcut(sr.rq_cost,t_azi05)),47,t_azi05),    #FUN-570190   #No.TQC-6A0078 #No:MOD-960320 modify   #MOD-840687 modify 
            COLUMN g_c[48],cl_numfor(SUM(cl_digcut(sr.bonus,t_azi05)),48,t_azi05);    #FUN-570190   #No.TQC-6A0078   #No:MOD-960320 modify   #MOD-840687 modify
      IF sum(sr.amt-sr.rq_amt)<>0 THEN
         PRINT COLUMN g_c[48],
               cl_numfor(SUM(cl_digcut(sr.bonus,t_azi05))/sum(cl_digcut(sr.amt,t_azi05)-cl_digcut(sr.rq_amt,t_azi05))*100,48,2)   #No.TQC-6A0078 #MOD-840687 modify
      ELSE
         PRINT COLUMN g_c[48],cl_numfor(0,48,2)
      END IF
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_dash2
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
      LET l_last_sw='y'
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash2  
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT 
 
 
FUNCTION change_string(old_string, old_sub, new_sub)
DEFINE query_text   LIKE type_file.chr1000  #No.FUN-680122 VARCHAR(300)
DEFINE AA           LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
DEFINE old_string   LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(300) ,
       xxx_string   LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(300) ,
       old_sub      LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(128) ,
       new_sub      LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(128) ,
       first_byte   LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
       nowx_byte    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
       next_byte    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
       this_byte    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
       length1, length2, length3   LIKE type_file.num5,     #No.FUN-680122 smallint,
                     pu1, pu2      LIKE type_file.num5,     #No.FUN-680122 smallint,
       ii, jj, kk, ff, tt          LIKE type_file.num5      #No.FUN-680122 smallint
 
LET length1 = length(old_string)
LET length2 = length(old_sub)
LET length3 = length(new_sub)
LET first_byte = old_sub[1,1]
LET xxx_string = " "
let pu1 = 0
 
FOR ii = 1 TO length1
    LET this_byte = old_string[ii, ii]
    LET nowx_byte = this_byte
    IF this_byte = first_byte THEN
        FOR jj = 2 TO length2
            let this_byte = old_string[ ii + jj - 1, ii + jj - 1]
            let next_byte = old_sub[ jj, jj]
            IF this_byte <> next_byte THEN
                let jj = 29999
                exit for
            END IF
        END FOR
        IF jj < 29999 THEN
           let pu1 = pu1 + 1
           let pu2 = pu1 + length3 - 1
           LET xxx_string[pu1, pu2] = new_sub CLIPPED
           LET ii = ii + length2 - 1
           LET pu1 = pu2
        ELSE
            let pu1 = pu1 + 1
            LET xxx_string[pu1,pu1] = nowx_byte
        END IF
    ELSE
        LET pu1 = pu1 + 1
        LET xxx_string[pu1,pu1] = nowx_byte
    END IF
end for
let query_text = xxx_string
            LET INT_FLAG = 0  ######add for prompt bug
RETURN query_text
end function
#No.FUN-9C0073 -----------------By chenls 10/01/18
