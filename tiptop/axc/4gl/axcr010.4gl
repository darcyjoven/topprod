# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcr010.4gl
# Descriptions...: 入庫金額統計表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/02/10 By Roger
# Modify ........: No:8628 03/11/03 By Melody 後續sr.amt1 會依 u_sign 會再處理,應先不處理正負問題
# Modify ........: No:8741 03/11/25 By Melody 增加'15'結案轉出,修改PRINT段
# Modify ........: No:9580 93/05/19 By Melody 此行應 remark，因倉退時 sr.amta 自然會成為負值，乘以 u_sign 反而會造成金額錯誤
# Modify ........: No:9626 04/07/21 By Carol 新增取雜收金額為31.雜收入庫
#                                            總金額與axcr004本月入庫核對較為簡便
# Modify.........: No.FUN-4C0099 04/12/24 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.MOD-530392 05/03/26 By Carol 不印明細時,格式未對齊,應抓apb101而非apb10
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.MOD-570089 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.MOD-570149 05/07/07 By Carol modify l_sql:add select ccg31,ccg32
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-590407 05/10/03 By Sarah 金額計算有誤,倉退部份也加進去了
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.MOD-620051 06/02/20 By Claire 1.31雜項入庫說明 2.雜項入庫資料未抓入計算
# Modify.........: No.TQC-620134 06/02/24 By Claire 31 的材料金額為null -->0
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630038 06/03/20 By Claire 少計其他
# Modify.........: No.FUN-610092 06/05/25 By Joe 增加庫存單位欄位
# Modify.........: No.FUN-670009 06/07/11 By Sarah 增加aimt306,aimt309借還料->31:雜項入庫
# Modify.........: No.FUN-670058 06/07/14 By Sarah 拆件式工單的入庫料號,金額沒有印出來 
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680007 06/08/02 By Sarah 將之前FUN-670058抓ccu_file的部份改成抓cch_file
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-720042 07/02/06 By TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-740176 07/04/27 By Sarah 不需抓取cch_file
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.MOD-820017 08/02/13 By Pengu 調整l_sql語法
# Modify.........: No.FUN-7C0028 08/03/17 By Sarah 畫面增加tm.type(成本計算類型),報表增加列印製費三、四、五
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860142 08/07/14 By Pengu 立帳金額時未考慮apa00='16'(暫估)的部份
# Modify.........: No.FUN-820035 08/07/15 By lutingting 雜項入庫增加抓atmt260 atmt261的資料列印
# Modify.........: No.MOD-880121 08/09/03 By Pengu 類別 11 與 axc700 的一般採購入庫對不平 
# Modify.........: No.MOD-860073 08/06/23 By chenl 排除拆件式工單計算。
# Modify.........: No.MOD-8A0203 08/11/15 By Pengu 再算本月請款未入庫淨額時加上apb34=N條件
# Modify.........: No.CHI-910019 09/05/20 By Pengu 部份的退貨折讓成本會無法抓取到AP的金額因程式段只抓apa58=2
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40130 10/04/26 By Carrier CHI-950048/MOD-970078追单
# Modify.........: No:MOD-A60047 10/06/07 By Sarah 數值變數使用前應先歸零
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:FUN-BB0063 11/11/14 By kim 成本考慮委外倉退金額
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-D30019 13/04/18 By bart 排除委外倉退資料不列印 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            #Print condition RECORD
            wc      LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(600),  # Where condition
            yy,mm   LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
            type    LIKE type_file.chr1,     #No.FUN-7C0028 add
            n       LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1)
            more    LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)      # Input more condition(Y/N)
           END RECORD 
DEFINE g_tot_bal    LIKE type_file.num20_6   #No.FUN-680122 DECIMAL(20,6)     # User defined variable
DEFINE bdate        LIKE type_file.dat       #No.FUN-680122 DATE
DEFINE edate        LIKE type_file.dat       #No.FUN-680122 DATE
DEFINE last_yy   LIKE type_file.num5         #FUN-820035
DEFINE last_mm   LIKE type_file.num5         #FUN-820035
DEFINE g_sql        STRING                   #No.FUN-580092 HCN
DEFINE g_argv1      LIKE ima_file.ima01      #No.FUN-680122 VARCHAR(20) #CHI-690007
DEFINE g_argv2      LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_argv3      LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_chr        LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table      STRING                   #MOD-720042 BY TSD.Sora
DEFINE g_str        STRING                   #MOD-720042 BY TSD.Sora
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
  
   LET g_sql = "ima01.ima_file.ima01,  ima02.ima_file.ima02,",   
               "ima021.ima_file.ima021,ima25.ima_file.ima25,",
               "type.aba_file.aba18,   trno.oea_file.oea01,",         
             #  "qty.ima_file.ima26,", #TQC-840066  #FUN-A20044
               "qty.type_file.num15_3,", #FUN-A20044
               "amta.type_file.num20_6,amtb.type_file.num20_6,",
               "amtc.type_file.num20_6,amtd.type_file.num20_6,",
               "amte.type_file.num20_6,amtf.type_file.num20_6,",   #FUN-7C0028 add amtf
               "amtg.type_file.num20_6,amth.type_file.num20_6,",   #FUN-7C0028 add amtg,amth
               "azi03.azi_file.azi03,  azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,  ccz27.ccz_file.ccz27,",     #No.TQC-A40130
               "tlfccost.tlfc_file.tlfccost"     #TQC-A40130
   LET l_table = cl_prt_temptable('axcr010',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #No.TQC-780054
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,? )"     #FUN-7C0028 add 3?  #No.TQC-A40130
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate    = ARG_VAL(1)        
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.yy      = ARG_VAL(8)
   LET tm.mm      = ARG_VAL(9)  
   LET tm.type    = ARG_VAL(10)   #FUN-7C0028 add  
   LET tm.n       = ARG_VAL(11)   
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL axcr010_tm(0,0)                    # Input print condition
   ELSE
      CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      CALL axcr010()                          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr010_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE 
      LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axcr010_w AT p_row,p_col WITH FORM "axc/42f/axcr010"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL      #Default condition
   LET tm.type = g_ccz.ccz28    #FUN-7C0028 add
   LET tm.n    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ima01,ima39,ima08,ima06, 
                                ima09,ima10,ima11,ima12
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
   
        ON ACTION controlp                                                                                              
           IF INFIELD(ima01) THEN                                                                                                  
              CALL cl_init_qry_var()                                                                                               
              LET g_qryparam.form = "q_ima"                                                                                       
              LET g_qryparam.state = "c"                                                                                           
              CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
              DISPLAY g_qryparam.multiret TO ima01                                                                                 
              NEXT FIELD ima01                                                                                                     
           END IF  
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
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW axcr010_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
   
     LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
   
     INPUT BY NAME tm.yy,tm.mm,tm.type,tm.n,tm.more WITHOUT DEFAULTS    #FUN-7C0028 add tm.type
        BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        AFTER FIELD yy
           IF tm.yy IS NULL THEN NEXT FIELD yy END IF
        AFTER FIELD mm
           IF tm.mm IS NULL THEN NEXT FIELD mm END IF
           CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
        AFTER FIELD type
           IF tm.type IS NULL OR tm.type NOT MATCHES "[12345]" THEN
              NEXT FIELD type
           END IF
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
        LET INT_FLAG = 0 CLOSE WINDOW axcr010_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='axcr010'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('axcr010','9031',1)   
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.yy CLIPPED,"'",
                           " '",tm.mm CLIPPED,"'",
                           " '",tm.type CLIPPED,"'",              #FUN-7C0028 add
                           " '",tm.n CLIPPED,"'",
                           " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('axcr010',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW axcr010_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL axcr010()
     ERROR ""
   END WHILE
   CLOSE WINDOW axcr010_w
END FUNCTION
 
FUNCTION axcr010()
   DEFINE l_name    LIKE type_file.chr20,       #No.FUN-680122 VARCHAR(20),       # External(Disk) file name
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680122CHAR(1200),
          l_chr     LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
          xxx       LIKE aab_file.aab02,        #No.FUN-680122 VARCHAR(5),        #No.FUN-550025
          u_sign    LIKE type_file.num5,        #No.FUN-680122SMALLINT,
          l_sfb99   LIKE sfb_file.sfb99,        #No.FUN-680122CHAR(1),
          l_ccg31   LIKE ccg_file.ccg31,
          l_ccg32   LIKE ccg_file.ccg32,
          l_cch31   LIKE cch_file.cch31,        #FUN-680007 modify
          l_cch32   LIKE cch_file.cch32,        #FUN-680007 modify
          l_za05    LIKE type_file.chr1000,     #No.FUN-680122 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10),
          l_ima53   LIKE ima_file.ima53, 
          l_ima91   LIKE ima_file.ima91, 
          l_ima531  LIKE ima_file.ima531, 
         #-----------No:TQC-A40130 add
          l_ima01   LIKE ima_file.ima01,
          l_sfb01   LIKE sfb_file.sfb01,
          l_cnt     LIKE type_file.num5,
         #-----------No:TQC-A40130 end
          l_rvv04  LIKE rvv_file.rvv04, 
          l_rvv05  LIKE rvv_file.rvv05, 
          l_rvv39  LIKE rvv_file.rvv39, 
          l_pmm22  LIKE pmm_file.pmm22, 
          l_pmm42  LIKE pmm_file.pmm42, 
          amt       LIKE type_file.num20_6,     #070227 BY TSD.Sora
          l_flag    LIKE type_file.chr1,        #070227 BY TSD.Sora
          l_amt1    LIKE type_file.num20_6,     #No.FUN-680122 DECIMAL(20,6)
          l_amt2    LIKE type_file.num20_6,     #No.FUN-680122 DECIMAL(20,6)
          l_amt3    LIKE type_file.num20_6,     #No.FUN-680122 DECIMAL(20,6)
          l_dmy1    LIKE smy_file.smydmy1,
          l_dmy4    LIKE smy_file.smydmy2,
          l_tlfccost LIKE tlfc_file.tlfccost,   #TQC-A40130
          sr        RECORD ima01  LIKE ima_file.ima01,    #CHI-690007
                           ima02  LIKE ima_file.ima02,    # 
                           ima021 LIKE ima_file.ima021,   #FUN-5A0059 
                           ima25  LIKE ima_file.ima25,    # 
                           type   LIKE aba_file.aba18,    #No.FUN-680122 VARCHAR(2), 
                                  # 11.本月採購入庫, 發票請款
                                  # 12.本月採購入庫, L/C 請款
                                  # 13.本月入庫未請款
                                  # 14.本月入庫調整金額
                                  # 21.本月自製入庫
                                  # 22.本月重工入庫
                           trno   LIKE oea_file.oea01,          #No.FUN-680122CHAR(12),
                         #  qty    LIKE ima_file.ima26,          #No.FUN-680122DEC(15,3),#TQC-840066 #FUN-A20044 
                           qty    LIKE type_file.num15_3,       #FUN-A20044
                           amta   LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
                           amtb   LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
                           amtc   LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
                           amtd   LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
                           amte   LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
                           amtf   LIKE type_file.num20_6,       #FUN-7C0028 add
                           amtg   LIKE type_file.num20_6,       #FUN-7C0028 add
                           amth   LIKE type_file.num20_6        #FUN-7C0028 add
                    END RECORD,
          sr2       RECORD tlf02  LIKE tlf_file.tlf02,          #No.FUN-680122 SMALLINT,
                           tlf03  LIKE tlf_file.tlf03,          #No.FUN-680122 SMALLINT,
                           tlf026 LIKE tlf_file.tlf026,         #No.FUN-550025 VARCHAR(10)
                           tlf027 LIKE tlf_file.tlf027,         #No.FUN-680122 SMALLINT,
                           tlf036 LIKE tlf_file.tlf036,         #No.FUN-550025 VARCHAR(10)
                           tlf037 LIKE tlf_file.tlf037,         #No.FUN-680122 SMALLINT, 
                           tlf13  LIKE tlf_file.tlf13,          #No.FUN-680122 VARCHAR(10),
                           tlf62  LIKE tlf_file.tlf62           #No.FUN-550025
                    END RECORD
    DEFINE l_rvu00   LIKE rvu_file.rvu00   #FUN-BB0063  
    DEFINE l_rvu08   LIKE rvu_file.rvu08   #FUN-BB0063  
   
    CALL cl_del_data(l_table)   #MOD-720042 BY TSD.Sora
    CALL r010_get_date() IF g_success = 'N' THEN RETURN END IF #FUN-820035
 
    DROP TABLE r010_tmp
    CREATE TEMP TABLE r010_tmp(
       type LIKE aba_file.aba18,
       qty1 LIKE type_file.num15_3,     #TQC-840066#FUN-A20044
       amt1 LIKE type_file.num20_6,
       amt2 LIKE type_file.num20_6,
       amt3 LIKE type_file.num20_6,
       amt4 LIKE type_file.num20_6,
       amt5 LIKE type_file.num20_6,
       amt6 LIKE type_file.num20_6,   #FUN-7C0028 add
       amt7 LIKE type_file.num20_6,   #FUN-7C0028 add
       amt8 LIKE type_file.num20_6)   #FUN-7C0028 add
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axcr010'
    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
      FROM azi_file WHERE azi01 = g_aza.aza17
    
    LET g_pageno = 0
#--------------------------------------------------------------- 取 tlf_file
    LET l_sql = "SELECT ima01,ima02,ima021,ima25,'',' ',tlf10*tlf60,0,0,0,0,0,0,0,0,",  #MOD-570089   #FUN-7C0028 add 0,0,0,
                "       tlf02,tlf03,tlf026,tlf027,tlf036,tlf037,tlf13,tlf62,tlfccost",   #TQC-A40130 add tlfccost
                "  FROM ima_file, tlf_file ",  #No.TQC-A40130
                "  LEFT OUTER JOIN tlfc_file ON (tlfc01=tlf01 AND tlfc02=tlf02 AND tlfc03=tlf03 AND ",      #TQC-A40130
                "  tlfc06=tlf06 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 AND tlfc904=tlf904 ",#TQC-A40130
                "  AND tlfc905=tlf905 AND tlfc906=tlf906 AND tlfc907=tlf907 AND tlfctype='",tm.type,"') ",                             #TQC-A40130
                " WHERE ",tm.wc CLIPPED,     #No.MOD-820017 add clipped
                "   AND ((tlf02=50 OR tlf02=57) OR (tlf03=50 OR tlf03=57)) ",
                "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                "   AND ima01=tlf01 AND ima01 NOT MATCHES 'MISC*'",
                "   AND NOT EXISTS(SELECT 1 FROM rvu_file WHERE rvu01 = tlf905 AND rvu00 = '3' AND RVU08 = 'SUB' ) "  #CHI-D30019
    PREPARE axcr010_prepare1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM 
    END IF
    DECLARE axcr010_curs1 CURSOR FOR axcr010_prepare1
    FOREACH axcr010_curs1 INTO sr.*, sr2.*,l_tlfccost    #TQC-A40130 add l_tlfccost
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF l_tlfccost IS NULL THEN LET l_tlfccost = ' ' END IF #TQC-A40130
       IF sr2.tlf02 = 65 OR sr2.tlf03 = 65 THEN CONTINUE FOREACH END IF #No.MOD-860073
       LET u_sign=0  
       IF sr2.tlf02 = 50 OR sr2.tlf02 = 57 THEN
          LET u_sign=-1 
          IF sr2.tlf13 != 'aimt309' THEN   #FUN-670009 add
             LET sr2.tlf036=sr2.tlf026 
             LET sr2.tlf037=sr2.tlf027
          END IF                           #FUN-670009 add
       END IF
       IF sr2.tlf03 = 50 OR sr2.tlf03 = 57 THEN
          LET u_sign=1  
       END IF
       IF u_sign=0 THEN CONTINUE FOREACH END IF
       CALL s_get_doc_no(sr2.tlf036) RETURNING xxx
       LET g_chr = ''
       SELECT smydmy2,smydmy1 INTO l_dmy4,l_dmy1
         FROM smy_file WHERE smyslip=xxx
       IF l_dmy4 != '1' OR l_dmy4 IS NULL THEN CONTINUE FOREACH END IF
 
       IF sr2.tlf13 MATCHES 'apm*' THEN
          LET l_amt1 = 0     LET l_amt2 = 0
          LET l_amt3 = 0
          SELECT SUM(apb101) INTO l_amt1   #MOD-530392
            FROM apb_file,apa_file         #發票請款立帳
           WHERE apb21=sr2.tlf036 AND apb22=sr2.tlf037 AND apb01=apa01
             AND apb29 = '1'
             AND apa02 BETWEEN bdate AND edate
             AND apa00 = '11'
             AND apa42 = 'N'
             AND apb34 = 'N'    #No.MOD-860142 add
          SELECT SUM(apb101) INTO l_amt2   #MOD-530392
            FROM apb_file,apa_file         #發票請款立帳
           WHERE apb21=sr2.tlf036 AND apb22=sr2.tlf037 AND apb01=apa01
             AND apb29 <> '1'
             AND apa02 BETWEEN bdate AND edate
             AND apa00 = '11'
             AND apa42 = 'N'
             AND apb34 = 'N'    #No.MOD-860142 add
          SELECT SUM(apb101) INTO l_amt3   #MOD-530392 	
            FROM apb_file,apa_file         #發票請款立帳
           WHERE apb21=sr2.tlf036 AND apb22=sr2.tlf037 AND apb01=apa01
             AND apa02 BETWEEN bdate AND edate
             AND apa00 = '21'   AND (apa58 ='2' OR apa58 = '3')   #No.CHI-910019 add
             AND apa42 = 'N'
             AND apb34 = 'N'    #No.MOD-860142 add
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
          LET sr.amta = l_amt1 + l_amt2 - l_amt3
 
          #----- 後續sr.amta 會依 u_sign 會再處理  ---------- No:8628
          IF sr.amta != 0 THEN LET sr.type='11' END IF
          IF sr.amta IS NULL OR sr.amta = 0 THEN
             LET sr.amta = 0   #MOD-A60047 add
             SELECT SUM(ale09) INTO sr.amta
               FROM ale_file #,alk_file   #L/C 到貨立帳
              WHERE ale16=sr2.tlf036 AND ale17=sr2.tlf037  #AND ale01=alk01
             IF sr.amta != 0 THEN LET sr.type='12' END IF
             IF sr.amta IS NULL THEN LET sr.amta=0 END IF
          END IF
          #抓取暫估金額，且此金額歸為位請款
          IF sr.amta IS NULL OR sr.amta = 0 THEN
             LET l_amt1 = 0     LET l_amt2 = 0   #MOD-A60047 add
             SELECT SUM(apb101)  INTO l_amt1 FROM apb_file,apa_file 
                    WHERE apa01 = apb01 AND apa42 = 'N' 
                     AND apb29='1' AND  apb21=sr2.tlf036
                     AND apb22=sr2.tlf037 
                      AND apa00='16'
                      AND apa42 = 'N'
                      AND apa02 BETWEEN bdate AND edate   
             
             SELECT SUM(apb101) INTO l_amt2 FROM apb_file,apa_file  
                     WHERE apa01 = apb01 AND apa42 = 'N' 
                      AND apb29='3' 
                      AND apb21=sr2.tlf036 AND apb22=sr2.tlf037
                      AND apa00 = '26'     
                      AND apa42 = 'N'
                      AND apa02 BETWEEN bdate AND edate   
             
             IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
             LET sr.amta = l_amt1 - l_amt2 
             IF sr.amta != 0 THEN LET sr.type='13' END IF
             IF sr.amta IS NULL THEN LET sr.amta=0 END IF
          END IF
          #抓取入庫單貨倉驗退單上的數量乘以單價金額，此部分也歸類為位請款
          IF sr.amta IS NULL OR sr.amta = 0 THEN
             SELECT rvv04,rvv05,rvv39 INTO l_rvv04,l_rvv05,l_rvv39
               FROM rvv_file
              WHERE rvv01=sr2.tlf036 AND rvv02=sr2.tlf037 AND rvv25<>'Y'   #No.MOD-880121 modify
                AND rvv03 = '1'
             IF (l_rvv04 IS NOT NULL OR l_rvv05 IS NOT NULL 
                OR l_rvv39 IS NOT NULL) THEN
                SELECT pmm22,pmm42 INTO l_pmm22,l_pmm42
                  FROM rvb_file,pmm_file,rva_file
                 WHERE rvb01=l_rvv04 AND rvb02=l_rvv05
                   AND pmm01=rvb04 AND rva01 = rvb01
                   AND rvaconf <> 'X'  AND pmm18 <> 'X'
                IF STATUS <> 0 THEN
                   LET l_pmm22=' '
                   LET l_pmm42= 1
                END IF
                IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                LET l_amt1=l_rvv39*l_pmm42
             END IF
 
             SELECT rvu00,rvu08,rvv04,rvv05,rvv39 INTO l_rvu00,l_rvu08,l_rvv04,l_rvv05,l_rvv39  #FUN-BB0063
              FROM rvu_file,rvv_file   #FUN-BB0063
             WHERE rvu01=rvv01 AND rvv01=sr2.tlf036 AND rvv02=sr2.tlf037 AND rvv25<>'Y'   #No.MOD-880121 modify  #FUN-BB0063
               AND rvv03 <> '1'
             IF (l_rvv04 IS NOT NULL OR l_rvv05 IS NOT NULL 
                OR l_rvv39 IS NOT NULL) THEN
                SELECT pmm22,pmm42 INTO l_pmm22,l_pmm42
                  FROM rvb_file,pmm_file,rva_file
                 WHERE rvb01=l_rvv04 AND rvb02=l_rvv05
                   AND pmm01=rvb04 AND rva01 = rvb01
                   AND rvaconf <> 'X'  AND pmm18 <> 'X'
                IF STATUS <> 0 THEN
                    LET l_pmm22=' '
                    LET l_pmm42= 1
                END IF
                IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                LET l_amt2=l_rvv39*l_pmm42
             END IF
             IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
             #CHI-D30019---begin
             ##FUN-BB0063(S)
             #IF l_rvu00 ='3' AND l_rvu08='SUB' THEN
             #   LET sr.amtb = l_amt1 - l_amt2
             #ELSE
             ##FUN-BB0063(E)
             #CHI-D30019---end
                LET sr.amta = l_amt1 - l_amt2 
             #END IF  #CHI-D30019
             #IF sr.amta != 0 OR sr.amtb != 0 THEN LET sr.type='13' END IF  #FUN-BB0063  CHI-D30019
          END IF
       END IF
       IF sr2.tlf13 MATCHES 'asf*' THEN
          IF (sr2.tlf02 = 25 OR sr2.tlf03 = 25 OR sr2.tlf03 = 50) THEN
             LET l_sfb99 = NULL
             SELECT sfb99 INTO l_sfb99 FROM sfb_file WHERE sfb01=sr2.tlf62
             IF l_sfb99 IS NULL OR l_sfb99='N' THEN LET sr.type='21' END IF
             IF l_sfb99 = 'Y'                  THEN LET sr.type='22' END IF
          END IF
       END IF
       IF sr2.tlf13 MATCHES 'aim*' AND (sr2.tlf02 = 90 OR sr2.tlf03 = 50) THEN
          LET sr.amta = 0   #MOD-A60047 add
         #SELECT inb14 INTO sr.amta FROM inb_file      #FUN-AB0089
    #FUN-AB0089--add--begin
          SELECT inb13 *inb09,inb132*inb09,inb133*inb09,inb134*inb09,
                 inb135*inb09,inb136*inb09,inb137*inb09,inb138*inb09
           INTO sr.amta,sr.amtb,sr.amtc,sr.amtd,sr.amte,sr.amtf,sr.amtg,sr.amth 
           FROM inb_file
           WHERE inb01=sr2.tlf036 AND inb03=sr2.tlf037
           LET sr.amta = cl_digcut(sr.amta,g_ccz.ccz26)
           LET sr.amtb = cl_digcut(sr.amtb,g_ccz.ccz26)
           LET sr.amtc = cl_digcut(sr.amtc,g_ccz.ccz26)
           LET sr.amtd = cl_digcut(sr.amtd,g_ccz.ccz26)
           LET sr.amte = cl_digcut(sr.amte,g_ccz.ccz26)
           LET sr.amtf = cl_digcut(sr.amtf,g_ccz.ccz26)
           LET sr.amtg = cl_digcut(sr.amtg,g_ccz.ccz26)
           LET sr.amth = cl_digcut(sr.amth,g_ccz.ccz26)
    #FUN-AB0089--add--end
          IF SQLCA.sqlcode  THEN  #MOD-620051 OR SQLCA.sqlerrd[3]=0 THEN
             LET sr.amta=0
    #FUN-AB0089--add--begin
             LET sr.amtb=0
             LET sr.amtc=0
             LET sr.amtd=0
             LET sr.amte=0
             LET sr.amtf=0
             LET sr.amtg=0
             LET sr.amth=0
     #FUN-AB0089--add--end
          ELSE
             LET sr.type='31'
          END IF
       END IF
##
       IF (sr2.tlf13 MATCHES 'aimt306' AND (sr2.tlf02 = 80 OR sr2.tlf03 = 50)) OR
          (sr2.tlf13 MATCHES 'aimt309' AND (sr2.tlf02 = 50 OR sr2.tlf03 = 80)) THEN
          LET sr.amta=0
          SELECT imp09*sr.qty INTO sr.amta FROM imp_file
           WHERE imp01=sr2.tlf036 AND imp02=sr2.tlf037
          IF SQLCA.sqlcode  THEN  #MOD-620051 OR SQLCA.sqlerrd[3]=0 THEN
             LET sr.amta=0
          ELSE
             LET sr.type='31'
          END IF
          LET sr.amta = sr.amta * u_sign
       END IF
      
       IF  sr2.tlf13 MATCHES 'atmt26*'  THEN
           LET sr.amta=0
           CALL r010_get_atmt26(sr.ima01,u_sign,sr2.tlf13,sr2.tlf026,sr.qty)
           RETURNING sr.amta,sr.amtb,sr.amtc,sr.amtd,sr.amte
           LET sr.type='14'
           LET sr.amta = sr.amta * u_sign
       END IF
   
       IF sr.amta IS NULL THEN LET sr.amta=0 END IF  #TQC-620134
       LET sr.qty  = sr.qty  * u_sign
       IF sr.type IS NULL OR sr.type=' ' THEN LET sr.type='13' END IF
       IF sr.type='13' AND sr2.tlf13='apmt150' THEN
          LET sr.amta = 0   #MOD-A60047 add
          SELECT tlf21 INTO sr.amta FROM tlf_file
           WHERE tlf01 =sr.ima01 AND tlf02=sr2.tlf02 AND tlf03=sr2.tlf03
             AND tlf026=sr2.tlf026 AND tlf027=sr2.tlf027
             AND tlf036=sr2.tlf036 AND tlf037=sr2.tlf037
             AND tlf13 =sr2.tlf13  AND tlf62 =sr2.tlf62
          IF sr.amta IS NULL THEN LET sr.amta=0 END IF
          LET sr.amta = sr.amta * u_sign
       END IF
 
       EXECUTE insert_prep USING
          sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.type,
          sr.trno, sr.qty,  sr.amta,  sr.amtb, sr.amtc,
          sr.amtd, sr.amte, sr.amtf,  sr.amtg, sr.amth,   #FUN-7C0028 sr.amtf,sr.amtg,sr.amgh
          #g_azi03, g_azi04, g_azi05,  g_ccz.ccz27,l_tlfccost   #TQC-A40130 add tlfccost #CHI-C30012 mark 
          g_ccz.ccz26, g_ccz.ccz26, g_ccz.ccz26,  g_ccz.ccz27,l_tlfccost #CHI-C30012
    END FOREACH
 
    LET sr.amta = 0   LET sr.amtb = 0  LET sr.amtc = 0   #MOD-A60047 add
    LET sr.amtd = 0   LET sr.amte = 0  LET sr.amtf = 0   #MOD-A60047 add
    LET sr.amtg = 0   LET sr.amth = 0                    #MOD-A60047 add
#--------------------------------------------------------------- 取 ccb_file
    LET l_sql = "SELECT ima01,ima02,ima021,ima25,'14',' ',0,",   #FUN-5A0059
                "       ccb22a,ccb22b,ccb22c,ccb22d,ccb22e",
                "      ,ccb22f,ccb22g,ccb22h,ccb07",   #FUN-7C0028 add #TQC-A40130 add ccb07
                "  FROM ima_file, ccb_file",
                " WHERE ",tm.wc CLIPPED,     #No.MOD-820017 add clipped
                "   AND ima01=ccb01",
                "   AND ccb02= ",tm.yy,
                "   AND ccb03= ",tm.mm,
                "   AND ccb06='",tm.type,"'"     #FUN-7C0028 add
    PREPARE axcr010_prepare2 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM 
    END IF
    DECLARE axcr010_curs2 CURSOR FOR axcr010_prepare2
    FOREACH axcr010_curs2 INTO sr.*,l_tlfccost   #No.TQC-A40130
       IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) EXIT FOREACH END IF
       IF l_tlfccost IS NULL THEN LET l_tlfccost = ' ' END IF #TQC-A40130
       EXECUTE insert_prep USING
          sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.type,
          sr.trno, sr.qty,  sr.amta,  sr.amtb, sr.amtc,
          sr.amtd, sr.amte, sr.amtf,  sr.amtg, sr.amth,   #FUN-7C0028 sr.amtf,sr.amtg,sr.amgh
          #g_azi03, g_azi04, g_azi05,  g_ccz.ccz27,l_tlfccost   #CHI-950048 add l_tlfccost #CHI-C30012 mark 
          g_ccz.ccz26, g_ccz.ccz26, g_ccz.ccz26,  g_ccz.ccz27,l_tlfccost #CHI-C30012
    END FOREACH
#--------------------------------------------------------------- 取 ccg_file
   #------------------------------No:TQC-A40130 modify------------------------
     DROP TABLE ccg_tmp
     DROP INDEX ccg_tmp_index
    
      CREATE TEMP TABLE ccg_tmp(
        ima01  LIKE ima_file.ima01,   
        sfb01  LIKE sfb_file.sfb01,
        flag   LIKE type_file.chr1)

      IF STATUS THEN 
        CALL cl_err('create ccg_tmp:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
      END IF
      CREATE UNIQUE INDEX ccg_tmp_index ON ccg_tmp(ima01,sfb01)

      IF STATUS THEN 
        CALL cl_err('create ccg_tmp_index:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
      END IF

     LET l_sql = " SELECT ima01,sfb01 ",
                 "  FROM ima_file, ccg_file, sfb_file",
                 " WHERE ",tm.wc CLIPPED, 
                 "   AND ima01=ccg04 AND ccg01=sfb01",
                 "   AND ccg02=",tm.yy,
                 "   AND ccg03=",tm.mm,
                 "   AND ccg06='",tm.type,"'", 
                 " UNION ",
                 " SELECT ima01,sfb01 ",
                 "  FROM ima_file, cce_file,sfb_file",
                 " WHERE ",tm.wc CLIPPED, 
                 "   AND ima01=cce04 AND cce01=sfb01",
                 "   AND cce02=",tm.yy,
                 "   AND cce03=",tm.mm,
                 "   AND cce06='",tm.type,"'"   
     PREPARE r010_instmp FROM l_sql
     IF STATUS THEN CALL cl_err('r010_instmp:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE r010_instmp_cusr1 CURSOR FOR r010_instmp
     FOREACH r010_instmp_cusr1 INTO l_ima01,l_sfb01 
        IF STATUS THEN CALL cl_err('instmp_cusr1:',STATUS,1) EXIT FOREACH END IF
        LET l_flag = '1'        #1.ccg_file  2.cce_file
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM cce_file 
            WHERE cce01 = l_sfb01                 #No:MOD-990011 modify
              AND cce02 = tm.yy AND cce03 = tm.mm
              AND cce06 = tm.type
        IF l_cnt > 0 THEN LET l_flag = '2' END IF
        INSERT INTO ccg_tmp VALUES(l_ima01,l_sfb01,l_flag)
        IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
            CALL cl_err('ins ccg_tmp:',SQLCA.SQLCODE,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
     END FOREACH

     DECLARE r010_instmp_cusr2 CURSOR FOR 
                   SELECT ima01,sfb01,flag FROM ccg_tmp

     FOREACH r010_instmp_cusr2 INTO l_ima01,l_sfb01,l_flag 
        IF STATUS THEN CALL cl_err('instmp_cusr2:',STATUS,1) EXIT FOREACH END IF
        LET sr.amta = 0   LET sr.amtb = 0  LET sr.amtc = 0   #MOD-A60047 add
        LET sr.amtd = 0   LET sr.amte = 0  LET sr.amtf = 0   #MOD-A60047 add
        LET sr.amtg = 0   LET sr.amth = 0                    #MOD-A60047 add
        IF l_flag = '1' THEN
           SELECT ima01,ima02,ima021,ima25,'',' ',0,
                  ccg32a*-1,ccg32b*-1,ccg32c*-1,ccg32d*-1,ccg32e*-1,
                  ccg32f*-1,ccg32g*-1,ccg32h*-1,
                  sfb99,ccg31,ccg32,ccg07
             INTO sr.*,l_sfb99,l_ccg31,l_ccg32,l_tlfccost
             FROM ima_file, ccg_file, OUTER sfb_file
             WHERE ima01=ccg04 AND ccg01=sfb01
               AND ccg04 = l_ima01 AND ccg01 = l_sfb01
               AND ccg02=tm.yy
               AND ccg03=tm.mm
               AND ccg06 = tm.type
        ELSE
           SELECT ima01,ima02,ima021,ima25,'',' ',0,
                  cce22a,cce22b,cce22c,cce22d,cce22e,
                  cce22f,cce22g,cce22h,sfb99,cce21,cce22,cce07
             INTO sr.*,l_sfb99,l_ccg31,l_ccg32,l_tlfccost
             FROM ima_file, cce_file, OUTER sfb_file
             WHERE ima01=cce04 AND cce01=sfb01
               AND cce04 = l_ima01 AND cce01 = l_sfb01
               AND cce02=tm.yy
               AND cce03=tm.mm
        END IF
        IF l_sfb99 IS NULL OR l_sfb99='N' THEN LET sr.type='21' END IF
        IF l_sfb99 = 'Y'                  THEN LET sr.type='22' END IF
        IF l_ccg31=0 AND l_ccg32<>0       THEN LET sr.type='15' END IF
      EXECUTE insert_prep USING
         sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.type,
         sr.trno, sr.qty,  sr.amta,  sr.amtb, sr.amtc,
         sr.amtd, sr.amte, sr.amtf,  sr.amtg, sr.amth,   
         #g_azi03, g_azi04, g_azi05,  g_ccz.ccz27,l_tlfccost  #CHI-C30012 mark
         g_ccz.ccz26, g_ccz.ccz26, g_ccz.ccz26,  g_ccz.ccz27,l_tlfccost #CHI-C30012
     END FOREACH

     #LET l_sql = "SELECT ima01,ima02,ima021,ima25,'',' ',0,",   #FUN-5A0059
     #            "       ccg32a*-1,ccg32b*-1,ccg32c*-1,ccg32d*-1,ccg32e*-1,",
     #            "       ccg32f*-1,ccg32g*-1,ccg32h*-1,",   #FUN-7C0028 add
     #            "       sfb99,ccg31,ccg32",  #MOD-570149 add ccg31,ccg32
     #            "  FROM ima_file, ccg_file LEFT OUTER JOIN sfb_file ON ccg01=sfb01",
     #            " WHERE ",tm.wc CLIPPED,  #MOD-570149 add CLIPPED
     #             "   AND ima01=ccg04 ",
     #            "   AND ccg02= ",tm.yy,
     #            "   AND ccg03= ",tm.mm,
     #            "   AND ccg06='",tm.type,"'"   #FUN-7C0028 add
     #PREPARE axcr010_prepare3 FROM l_sql
     #IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
     #   EXIT PROGRAM 
     #END IF
     #DECLARE axcr010_curs3 CURSOR FOR axcr010_prepare3
     #FOREACH axcr010_curs3 INTO sr.*, l_sfb99,l_ccg31,l_ccg32    #MOD-570149 add ccg31,ccg32
     #  IF STATUS THEN CALL cl_err('foreach3:',STATUS,1) EXIT FOREACH END IF
     #  IF l_sfb99 IS NULL OR l_sfb99='N' THEN LET sr.type='21' END IF
     #  IF l_sfb99 = 'Y'                  THEN LET sr.type='22' END IF
 
     #  #---No:8741 ccg無轉出數量,有金額(結案轉出)(ccg31=0 and ccg32<>0)
     #  IF l_ccg31=0 AND l_ccg32<>0 THEN LET sr.type='15' END IF
 
     #  IF sr.type IS NULL OR sr.type=' ' THEN LET sr.type='2x' END IF
     # EXECUTE insert_prep USING
     #    sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.type,
     #    sr.trno, sr.qty,  sr.amta,  sr.amtb, sr.amtc,
     #    sr.amtd, sr.amte, sr.amtf,  sr.amtg, sr.amth,   #FUN-7C0028 sr.amtf,sr.amtg,sr.amgh
     #    g_azi03, g_azi04, g_azi05,  g_ccz.ccz27
 
     #END FOREACH
   #------------------------------No:TQC-A40130 end------------------------ 
 
 
     LET g_sql="SELECT SUM(apb101) FROM ima_file,apb_file,apa_file,rvv_file",
               " WHERE ",tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'",
               "   AND ima01=apb12 AND apb01=apa01",
               "   AND apa42 = 'N' ",
               "   AND apa00 IN ('11','21')",
               "   AND apa02 BETWEEN '",bdate,"' AND '",edate,"'",
               "   AND apb21=rvv01 AND apb22=rvv02",
               "   AND apb34 = 'N' ",                 #No.MOD-8A0203 add
               "   AND rvv09 NOT BETWEEN '",bdate,"' AND '",edate,"'"
     PREPARE r010_rvv_p FROM g_sql
     DECLARE r010_rvv_c CURSOR FOR r010_rvv_p
     OPEN r010_rvv_c
     FETCH r010_rvv_c INTO amt
 
     IF cl_null(amt) or amt=0 THEN 
        LET l_flag='N' 
     ELSE
        LET l_flag='Y'
     END IF
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima01,ima39,ima08,ima06,ima09,ima10,ima11,ima12')   #FUN-710080 modify
          RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.n,";",amt,";",
                 l_flag,";",tm.type   #FUN-7C0028 add tm.type
     CALL cl_prt_cs3('axcr010','axcr010',l_sql,g_str)   #FUN-710080 modify
END FUNCTION
 
FUNCTION r010_get_atmt26(l_ima01,u_sign,l_tlf13,l_tlf026,l_qty)
  DEFINE u_sign     LIKE type_file.num5
  DEFINE l_tlf13    LIKE tlf_file.tlf13 
  DEFINE l_tlf026   LIKE tlf_file.tlf026 
  DEFINE l_qty      LIKE tlf_file.tlf10 
  DEFINE l_ima01    LIKE ima_file.ima01 
  DEFINE l_sql      STRING,
         l_flag     LIKE tlf_file.tlf907,
         l_tlf      RECORD LIKE tlf_file.*,
         l_ccc23    LIKE ccc_file.ccc23,
         l_ccc23a   LIKE ccc_file.ccc23a,
         l_ccc23b   LIKE ccc_file.ccc23b,
         l_ccc23c   LIKE ccc_file.ccc23c,
         l_ccc23d   LIKE ccc_file.ccc23d,
         l_ccc23e   LIKE ccc_file.ccc23e 
  DEFINE  amta       LIKE ccc_file.ccc22a      
  DEFINE  amtb       LIKE ccc_file.ccc22a
  DEFINE  amtc       LIKE ccc_file.ccc22a      
  DEFINE  amtd       LIKE ccc_file.ccc22a      
  DEFINE  amte       LIKE ccc_file.ccc22a      
  DEFINE  amt        LIKE ccc_file.ccc22  
 
   #--->子件單價
   #-->先取本月月平均單價，抓不到再取上月月平均單價
   LET l_ccc23 =0
   LET l_ccc23a=0
   LET l_ccc23b=0
   LET l_ccc23c=0
   LET l_ccc23d=0
   LET l_ccc23e=0
   LET amt     =0
   LET amta    =0
   LET amtb    =0
   LET amtc    =0
   LET amtd    =0
   LET amte    =0
   #-->取本月月平均單價
   SELECT ccc23,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e
     INTO l_ccc23,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
     FROM ccc_file
    WHERE ccc01=l_ima01 AND ccc02=tm.yy AND ccc03=tm.mm
   IF STATUS OR cl_null(l_ccc23) OR l_ccc23 =0 THEN
      #-->抓不就到取上月月平均單價
      SELECT ccc23,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e
        INTO l_ccc23,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
        FROM ccc_file
       WHERE ccc01=l_ima01 AND ccc02=last_yy AND ccc03=last_mm
   END IF
 
  #例：組合單 將A <= B + C  (組合的子件)
  #    拆解單 將A => B , C  (拆解出的子件)
  #    B 10個 單價4 (月加權)
  #    C 10個 單價6 (月加權)
  #    組合成A 10個 異動成本 = 10*4 + 10*6 = 100
  #    ==>A 的異動成本必須來自 B + C
 
   #抓子件的tlf資料,加總起來後當成A的異動成本
   IF l_tlf13='atmt260' THEN
      LET l_sql = "SELECT tlf_file.* ",
                  "  FROM tsd_file,tlf_file",
                  " WHERE tsd01 = tlf905 AND tsd02 = tlf906 AND tsd03 = tlf01",
                  "   AND tlf905= ?",
                  "   AND tlf13 = ?",
                  "   AND tlf907= ?"
   END IF
   IF l_tlf13='atmt261' THEN
      LET l_sql = "SELECT tlf_file.* ",
                  "  FROM tsf_file,tlf_file",
                  " WHERE tsf01 = tlf905 AND tsf02 = tlf906 AND tsf03 = tlf01",
                  "   AND tlf905= ?",
                  "   AND tlf13 = ?",
                  "   AND tlf907= ?"
   END IF
   DECLARE r010_tsdf_tlf_c1 CURSOR FROM l_sql
 
   IF (l_tlf13='atmt260' AND u_sign = -1) OR     #組合的子件
      (l_tlf13='atmt261' AND u_sign =  1) THEN   #拆解出的子件
      LET amta=amta + (l_qty*l_ccc23a)
      LET amtb=amtb + (l_qty*l_ccc23b)
      LET amtc=amtc + (l_qty*l_ccc23c)
      LET amtd=amtd + (l_qty*l_ccc23d)
      LET amte=amte + (l_qty*l_ccc23e)
   ELSE
      IF l_tlf13='atmt260' THEN LET l_flag = -1 END IF
      IF l_tlf13='atmt261' THEN LET l_flag =  1 END IF
 
      FOREACH r010_tsdf_tlf_c1 USING l_tlf026,l_tlf13,l_flag INTO l_tlf.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('r010_tsdf_tlf_c1',SQLCA.sqlcode,0)   
            EXIT FOREACH
         END IF
 
         LET l_ccc23a=0  LET l_ccc23b=0  LET l_ccc23c=0
         LET l_ccc23d=0  LET l_ccc23e=0
         SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e
           INTO l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
           FROM ccc_file
          WHERE ccc01=l_tlf.tlf01 AND ccc02=tm.yy AND ccc03=tm.mm

         LET amta=amta + (l_tlf.tlf10*l_ccc23a)
         LET amtb=amtb + (l_tlf.tlf10*l_ccc23b)
         LET amtc=amtc + (l_tlf.tlf10*l_ccc23c)
         LET amtd=amtd + (l_tlf.tlf10*l_ccc23d)
         LET amte=amte + (l_tlf.tlf10*l_ccc23e)
      END FOREACH
   END IF
   LET amt =amta + amtb + amtc + amtd + amte
   RETURN amta,amtb,amtc,amtd,amte

END FUNCTION

FUNCTION r010_get_date()
   DEFINE l_correct     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, bdate, edate #得出起始日與截止日
   IF l_correct != '0' THEN LET g_success = 'N' RETURN END IF                                                                       
   IF tm.mm = 1                                                                                                                        
      THEN IF g_aza.aza02 = '1'                                                                                                     
              THEN LET last_mm = 12 LET last_yy = tm.yy - 1                                                                            
              ELSE LET last_mm = 13 LET last_yy = tm.yy - 1                                                                            
           END IF                                                                                                                   
      ELSE LET last_mm = tm.mm - 1 LET last_yy = tm.yy                                                                                    
   END IF                                                                                                                           
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12
