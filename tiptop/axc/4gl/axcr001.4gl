# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcr001.4gl
# Descriptions...: 入庫金額明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/10 By Nick
# Modify ........: No:8628 03/11/03 By Melody 後續sr.amt1 會依 u_sign 會再處理,應先不處理正負問題
# Modify ........: No:8741 03/11/25 By Melody 加上工單已無入庫數量但有轉出金額(c
# Modify ........: No:9625 04/06/03 By Melody 新增差異轉出的金額
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.MOD-530505 05/03/26 By pengu  在AFTER INPUT 在CALL一次 s_azm()，避免造成無資料產生
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570067 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-580014 05/08/22 By jackie 報表轉XML格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610051 06/02/10 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-620070 06/03/01 by Claire tlf036由INPUT段改為QBE
# Modify.........: No.FUN-610092 06/05/25 by Joe 增加庫存單位欄位
# Modify.........: No.FUN-670009 06/07/11 By Sarah 增加aimt306,aimt309借還料
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/05 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-780017 07/07/27 By dxfwo CR報表的制作
# Modify.........: No.FUN-7C0101 08/01/24 By ChenMoyan 改善報表
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.FUN-830135 08/03/27 By ChenMoyan 成本改善報表部分的BUG修改
# Modify.........: No.FUN-820035 08/07/15 By lutingting  雜項入庫增加抓atmt260 atmt261的資料列印
# Modify.........: No.MOD-870134 08/09/18 By Pengu 倉退的單價應該是正數，金額才是負數
# Modify.........: No.MOD-860073 08/06/23 By chenl 排除拆件式工單計算。
# Modify.........: No.CHI-910019 09/05/20 By Pengu 部份的退貨折讓成本會無法抓取到AP的金額因程式段只抓apa58=2
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0187 09/11/02 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40130 10/04/27 By Carrier 追单 FUN-9A0067,MOD-990149
# Modify.........: No:MOD-B30018 11/03/03 By sabrina PREPARE axcr001_prepare2的SQL少給兩個值
# Modify.........: No:FUN-BB0063 12/02/13 By bart 成本考慮委外倉退金額
# Modify.........: No:MOD-C40054 12/04/09 By yinhy 增加未完全開立發票，仍有一部份為暫估金額的處理
# Modify.........: No:TQC-C60021 12/06/04 By Sarah ICD行業別時,要抓入非成本倉的資料出來,只是數量顯示0
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-C80033 12/08/06 By Elise MOD-C40054增加的變數若為null則給0
# Modify.........: No:CHI-D30019 13/04/18 By bart 排除委外倉退資料不列印 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,        #No.FUN-680122  VARCHAR(600),    # Where condition
           tlf036  LIKE tlf_file.tlf036,          #FUN-550025
           yy,mm   LIKE type_file.num5,           #No.FUN-680122 SMALLINT,
           b       LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),     
           more    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),       # Input more condition(Y/N)
           type    LIKE type_file.chr1            #No.FUN-7C0101
           END RECORD 
DEFINE g_tot_bal   LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)  # User defined variable
DEFINE bdate       LIKE type_file.dat             #No.FUN-680122 DATE
DEFINE edate       LIKE type_file.dat             #No.FUN-680122 DATE
DEFINE last_yy     LIKE type_file.num5            #FUN-820035
DEFINE last_mm     LIKE type_file.num5            #FUN-820035
DEFINE g_argv1     LIKE type_file.chr20           #No.FUN-680122 VARCHAR(20)
DEFINE g_argv2     LIKE type_file.num5            #No.FUN-680122 SMALLINT 
DEFINE g_argv3     LIKE type_file.num5            #No.FUN-680122 SMALLINT 
DEFINE g_chr       LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1)
DEFINE g_i         LIKE type_file.num5            #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table     STRING                         #No.FUN-780017                                                                    
DEFINE g_sql       STRING                         #No.FUN-780017                                                                    
DEFINE g_str       STRING                         #No.FUN-780017 

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
   LET g_sql = " ima01.ima_file.ima01,",                                                                                            
               " ima02.ima_file.ima02,",
               " tlfccost.tlfc_file.tlfccost,",               #No.FUN-7C0101
               " tlf06.tlf_file.tlf06,",
               " tlf036.tlf_file.tlf036,",
               " tlf037.tlf_file.tlf037,",
               " ima25.ima_file.ima25,",
               " qty.type_file.num15_3,",                       #No.FUN-A20044
               " amt1.type_file.num20_6,",
               " amt2.type_file.num20_6 "                                                                                                                                                                                            
   LET l_table = cl_prt_temptable('axcr001',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
               " VALUES(?,?,?,?,?,?,?,?,?,?)"          #No.FUN-7C0101                                       
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
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
   LET tm.b       = ARG_VAL(10)        
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET tm.type    = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(7)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL axcr001_tm(0,0)          # Input print condition
      ELSE 
      CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      CALL axcr001()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000   #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE
      LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr001_w AT p_row,p_col WITH FORM "axc/42f/axcr001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b = '1' 
   LET tm.more = 'N'
   LET tm.yy = g_ccz.ccz01 #No.TQC-A40130 YEAR(g_today)-->g_ccz.ccz01            
   LET tm.mm = g_ccz.ccz02 #No.TQC-A40130 MONTH(g_today)-->g_ccz.ccz02
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,ima39,ima08, ima06,tlf036, #FUN-620070 add tlf036
                                  ima09, ima10, ima11, ima12 
 
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
         LET INT_FLAG = 0 CLOSE WINDOW axcr001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF

      LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"

      INPUT BY NAME tm.yy,tm.mm,tm.type,tm.b,tm.more WITHOUT DEFAULTS #No.FUN-7C0101 
         BEFORE INPUT
            LET tm.type = g_ccz.ccz28       #No.FUN-830135
            DISPLAY BY NAME tm.type            #No.FUN-830135
            CALL cl_qbe_display_condition(lc_qbe_sn)
         AFTER FIELD yy
            IF tm.yy IS NULL THEN NEXT FIELD yy END IF
         AFTER FIELD mm
            IF tm.mm IS NULL THEN NEXT FIELD mm END IF
            CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
         AFTER FIELD b
            IF tm.b IS NULL OR tm.b NOT MATCHES "[12]" THEN 
               NEXT FIELD b  
            END IF 
         AFTER FIELD type                                                                                                                  
            IF tm.type IS NULL OR tm.type NOT MATCHES "[12345]" THEN                                                                            
               NEXT FIELD type                                                                                                            
            END IF     
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
         AFTER INPUT 
           CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
         LET INT_FLAG = 0 CLOSE WINDOW axcr001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcr001'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr001','9031',1)   
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
                            " '",tm.b       CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                            " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr001',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr001_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axcr001()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr001_w
END FUNCTION
 
FUNCTION axcr001()
   DEFINE l_name       LIKE type_file.chr20,         #No.FUN-680122CHAR(20),        # External(Disk) file name
         #l_sql        LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-680122 VARCHAR(1200),  #TQC-C60021 mark
          l_sql        STRING,                       # RDSQL STATEMENT                                 #TQC-C60021
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          xxx          LIKE aab_file.aab02,          #No.FUN-680122 VARCHAR(5),       #FUN-550025
          amt_1,amt_2  LIKE apb_file.apb10,          #No.FUN-680122 DECIMAL(20,6)
          amt_3        LIKE apb_file.apb10,          #No.FUN-680122 DECIMAL(20,6)
          u_sign       LIKE type_file.num5,          #No.FUN-680122 SMALLINT,
          l_za05       LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_order      ARRAY[5] OF LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40), #No.FUN-550025#FUN-5B0105 16->40
          l_ima53      LIKE ima_file.ima53,
          l_ima91      LIKE ima_file.ima91,
          l_ima531     LIKE ima_file.ima531,
          l_dmy1       LIKE smy_file.smydmy1,
          qty_1,qty_2  LIKE type_file.num15_3,       #MOD-C40054
          qty_3,qty_4  LIKE type_file.num15_3,       #MOD-C40054
          amt_4,amt_5  LIKE apb_file.apb10,          #MOD-C40054
          sr           RECORD order1  LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40), #FUN-5B0105 20->40 
                              order2  LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40), #FUN-5B0105 20->40
                              ima01   LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),
                              ima02   LIKE ima_file.ima02,  
                              ima25   LIKE ima_file.ima25, 
                              tlf06   LIKE tlf_file.tlf06,  #No:8174  
                              tlf02   LIKE type_file.num5,          #No.FUN-680122 SMALLINT,
                              tlf03   LIKE type_file.num5,          #No.FUN-680122 SMALLINT,
                              tlf026  LIKE tlf_file.tlf026,         #No.FUN-680122 VARCHAR(16),      #FUN-550025  
                              tlf027  LIKE type_file.num5,          #No.FUN-680122 SMALLINT,
                              tlf036  LIKE tlf_file.tlf036,       #FUN-550025
                              tlf037  LIKE type_file.num5,        #No.FUN-680122 SMALLINT,
                              tlf13   LIKE tlf_file.tlf13,        #No.FUN-680122 VARCHAR(10),
                              tlfc21  LIKE tlfc_file.tlfc21,         #No.FUN-7C0101
                              tlf21   LIKE tlf_file.tlf21,
                              qty     LIKE type_file.num15_3,         #FUN-A20044
                              amt1    LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6)      # A/P Amt
                              amt2    LIKE type_file.num20_6         #No.FUN-680122DEC(20,6)       # Adj Amt
                             ,tlfccost LIKE tlfc_file.tlfccost        #No.FUN-7C0101 
                       END RECORD

     CALL r001_get_date() IF g_success = 'N' THEN RETURN END IF #FUN-820035
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

     LET l_sql = "SELECT '','',ima01,ima02,ima25,tlf06,tlf02,tlf03,",
                 "       tlf026,tlf027,tlf036,tlf037,tlf13,tlfc21,tlf21,tlf10*tlf60,0,0,tlfccost",    #No.FUN-7C0101
     #No.TQC-A40130  --Begin  tlf_file转为内联
                 "  FROM ima_file, tlf_file",
                 "  LEFT OUTER JOIN tlfc_file",
                 "    ON tlfc01 = tlf01 ",
                 "   AND tlfc02 = tlf02  AND tlfc03 = tlf03 ",
                 "   AND tlfc06 = tlf06  AND tlfc13 = tlf13 ",
                 "   AND tlfc902= tlf902 AND tlfc903= tlf903 ",
                 "   AND tlfc904= tlf904 AND tlfc905= tlf905 ",
                 "   AND tlfc906= tlf906 AND tlfc907= tlf907 ",
                 "   AND tlfctype = '",tm.type,"'",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND  ima01=tlf01 ",
                 "   AND ((tlf02=50 OR tlf02=57) OR (tlf03=50 OR tlf03=57)) ",
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)", 
                 "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                 "   AND NOT EXISTS(SELECT 1 FROM rvu_file WHERE rvu01 = tlf905 AND rvu00 = '3' AND RVU08 = 'SUB' ) "  #CHI-D30019
     #No.TQC-A40130  --End  
    #str TQC-C60021 add
    #ICD行業別時,要抓入非成本倉的資料出來,只是數量顯示0
     IF s_industry('icd') THEN
        LET l_sql = l_sql CLIPPED," UNION ",
                    "SELECT '','',ima01,ima02,ima25,tlf06,tlf02,tlf03,",
                    "       tlf026,tlf027,tlf036,tlf037,tlf13,tlfc21,tlf21,0,0,0,tlfccost",
                    "  FROM ima_file, tlf_file",
                    "  LEFT OUTER JOIN tlfc_file",
                    "    ON tlfc01 = tlf01 ",
                    "   AND tlfc02 = tlf02  AND tlfc03 = tlf03 ",
                    "   AND tlfc06 = tlf06  AND tlfc13 = tlf13 ",
                    "   AND tlfc902= tlf902 AND tlfc903= tlf903 ",
                    "   AND tlfc904= tlf904 AND tlfc905= tlf905 ",
                    "   AND tlfc906= tlf906 AND tlfc907= tlf907 ",
                    "   AND tlfctype = '",tm.type,"'",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND  ima01=tlf01 ",
                    "   AND ((tlf02=50 OR tlf02=57) OR (tlf03=50 OR tlf03=57)) ",
                    "   AND tlf902 IN (SELECT jce02 FROM jce_file)",   #入非成本倉
                    "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                    "   AND NOT EXISTS(SELECT 1 FROM rvu_file WHERE rvu01 = tlf905 AND rvu00 = '3' AND RVU08 = 'SUB' ) "  #CHI-D30019
     END IF
    #end TQC-C60021 add
     PREPARE axcr001_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr001_curs1 CURSOR FOR axcr001_prepare1
     IF tm.b = '1' THEN
        IF tm.type MATCHES '[12]' THEN             # No.FUN-7C0101
           LET l_name='axcr001'
        END IF                                     # No.FUN-7C0101
        IF tm.type MATCHES '[345]' THEN            # No.FUN-7C0101                                                                                 
           LET l_name='axcr001_2'                  # No.FUN-7C0101                                                                                  
        END IF                                     # No.FUN-7C0101     
     ELSE 
        IF tm.type MATCHES '[12]' THEN             # No.FUN-7C0101
           LET l_name='axcr001_1'
        END IF                                     # No.FUN-7C0101
        IF tm.type MATCHES '[345]' THEN            # No.FUN-7C0101                                                                                
           LET l_name='axcr001_3'                  # No.FUN-7C0101                                                                                
        END IF                                     # No.FUN-7C0101
     END IF 
     CALL cl_del_data(l_table)   
           
     LET g_pageno = 0
     FOREACH axcr001_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.tlf06 IS NULL THEN CONTINUE FOREACH END IF
       # Elvis Add
       IF cl_null(sr.tlf036) THEN CONTINUE FOREACH END IF
       # End Add 
       LET u_sign=0  
       IF sr.tlf02 = 65 OR sr.tlf03 = 65 THEN CONTINUE FOREACH END IF #No.MOD-860073
       IF sr.tlf02 = 50 OR sr.tlf02 = 57
          THEN LET u_sign=-1 
          IF sr.tlf03 <> 50 AND sr.tlf03 <> 57 THEN 
             IF sr.tlf13 <> 'aimt309' THEN   #FUN-680007 add
                LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
             END IF                          #FUN-680007 add
          END IF 
       END IF
       IF sr.tlf03 = 50 OR sr.tlf03 = 57
          THEN LET u_sign=1  
       END IF
       IF sr.tlf02 = 50 AND sr.tlf03 = 57 
          THEN LET u_sign=-1 LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
       END IF 
       IF u_sign=0 THEN CONTINUE FOREACH END IF
       CALL s_get_doc_no(sr.tlf036) RETURNING xxx
       LET g_chr = ''
       SELECT smydmy2,smydmy1 INTO g_chr,l_dmy1
         FROM smy_file WHERE smyslip=xxx
       IF g_chr != '1' OR g_chr IS NULL THEN CONTINUE FOREACH END IF
       IF l_dmy1 = 'N' THEN CONTINUE FOREACH END IF
       CASE
          WHEN sr.tlf13 MATCHES 'aimt30*' OR sr.tlf13 MATCHES 'atmt26*'	  
               #借還料
               IF sr.tlf13 = 'aimt306' OR sr.tlf13 = 'aimt309' THEN
                  SELECT imp09*sr.qty INTO sr.amt1
                    FROM imp_file
                   WHERE imp01=sr.tlf036 AND imp02=sr.tlf037
                  IF sr.tlf13 = 'aimt309' THEN
                     LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
                  END IF
               ELSE
                  SELECT inb14 INTO sr.amt1
                    FROM inb_file
                   WHERE inb01=sr.tlf036 AND inb03=sr.tlf037
               END IF   #FUN-670009 add
               IF sr.tlf13 MATCHES 'atmt26*' THEN
                  CALL r001_get_atmt26(sr.ima01,u_sign,sr.tlf13,sr.tlf026,sr.qty)                                                        
                  RETURNING sr.amt1
               END IF 
          WHEN sr.tlf13 = 'aimt324' OR sr.tlf13 = 'aimt720'  #調撥入zzz
               SELECT imn092 INTO sr.amt1
                 FROM imn_file
                WHERE imn01=sr.tlf036 AND imn02=sr.tlf037
          WHEN sr.tlf13 = 'asft6201'                         #完工入庫
               LET sr.amt1 = sr.tlf21  
          OTHERWISE
               IF sr.tlf13 MATCHES 'apm*' THEN
                  LET amt_1 = 0 LET amt_2 = 0
                  LET amt_3 = 0
                  LET qty_1=0 LET qty_2=0 LET qty_3=0 LET qty_4=0  LET amt_4=0 LET amt_5=0  #MOD-C40054
                  SELECT SUM(apb101),SUM(apb09) INTO amt_1   #MOD-C40054 add apb09
                    FROM apb_file,apa_file           
                   WHERE apb21=sr.tlf036 AND apb22=sr.tlf037 
                     AND apb29 ='1'
                     AND apb01=apa01 AND apa00 = '11'
                     AND apa02 BETWEEN bdate AND edate
                     AND apa42 = 'N' 
                  IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
                  IF cl_null(qty_1) THEN LET qty_1=0 END IF            #MOD-C80033
                  SELECT SUM(apb101),SUM(apb09) INTO amt_3   #MOD-C40054 add apb09
                    FROM apb_file,apa_file           
                   WHERE apb21=sr.tlf036 AND apb22=sr.tlf037 
                     AND apb29 <> '1'
                     AND apb01=apa01 AND apa00 = '11'
                     AND apa02 BETWEEN bdate AND edate
                     AND apa42 = 'N' 
                  IF amt_3 IS NULL THEN LET amt_3 = 0 END IF
                  IF cl_null(qty_2) THEN LET qty_2=0 END IF            #MOD-C80033
                  SELECT SUM(apb101) INTO amt_2
                    FROM apb_file,apa_file          
                   WHERE apb21=sr.tlf026 AND apb22=sr.tlf027 AND apb01=apa01
                     AND apa00 = '21' AND (apa58 = '2' OR apa58 = '3')      #No.CHI-910019 add
                     AND apa02 BETWEEN bdate AND edate
                     AND apa42 = 'N' 
                  IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
                  LET sr.amt1 = amt_1-amt_2+amt_3
                  #No.MOD-C40054  --Begin
                  SELECT apb08,apb09 INTO amt_4,qty_3 FROM apb_file,apa_file
                   WHERE apa01 = apb01 AND apa42 = 'N'
                     AND apb29='1' AND  apb21=sr.tlf036
                     AND apb22=sr.tlf037
                     AND apa00='16'
                     AND apa42 = 'N'
                     AND apa02 BETWEEN bdate AND edate
                  IF cl_null(qty_3) THEN LET qty_3=0 END IF   #MOD-C80033
                  IF cl_null(amt_4) THEN LET amt_4=0 END IF   #MOD-C80033
                  SELECT apb08,apb09 INTO amt_5,qty_4 FROM apb_file,apa_file
                   WHERE apa01 = apb01 AND apa42 = 'N'
                     AND apb29='3'
                     AND apb21=sr.tlf026 AND apb22=sr.tlf027
                     AND apa00 = '26'
                     AND apa42 = 'N'
                     AND apa02 BETWEEN bdate AND edate
                  IF cl_null(qty_4) THEN LET qty_4=0 END IF   #MOD-C80033
                  IF cl_null(amt_5) THEN LET amt_5=0 END IF   #MOD-C80033
                  LET sr.amt1 = sr.amt1 + amt_4*(qty_3-qty_1) + amt_5*(qty_4-qty_2)
                  #No.MOD-C40054  --End
                  IF sr.amt1 IS NULL OR sr.amt1 = 0 THEN
                     SELECT SUM(ale09) INTO sr.amt1
                       FROM ale_file #,alk_file   #外購到貨立帳
                      WHERE ale16=sr.tlf036 AND ale17=sr.tlf037  # AND ale01=alk01
                  END IF
                 #No:8628 --- 後續sr.amt1 會依 u_sign 會再處理  ----------
                 #抓取暫估金額
                  LET amt_1 = 0 LET amt_2 = 0
                  IF sr.amt1 IS NULL OR sr.amt1 = 0 THEN
                     SELECT SUM(apb101)  INTO amt_1 FROM apb_file,apa_file 
                      WHERE apa01 = apb01 AND apa42 = 'N' 
                        AND apb29='1' AND  apb21=sr.tlf036
                        AND apb22=sr.tlf037 
                        AND apa00='16'
                        AND apa42 = 'N'
                        AND apa02 BETWEEN bdate AND edate   
                     SELECT SUM(apb101) INTO amt_2 FROM apb_file,apa_file  
                      WHERE apa01 = apb01 AND apa42 = 'N' 
                        AND apb29='3' 
                        AND apb21=sr.tlf026 AND apb22=sr.tlf027
                        AND apa00 = '26'     
                        AND apa42 = 'N'
                        AND apa02 BETWEEN bdate AND edate   
                     IF cl_null(amt_1) THEN LET amt_1 = 0 END IF
                     IF cl_null(amt_2) THEN LET amt_2 = 0 END IF
                     LET sr.amt1 = amt_1 - amt_2 
                  END IF
                  IF sr.amt1 < 0 THEN LET sr.amt1 =  sr.amt1 * -1 END IF
               END IF
       END CASE
       IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
       ### 完工入庫單利用tlf_file 
       IF sr.amt1 = 0 THEN
          #CHI-D30019---begin
          ##FUN-BB0063(S)
          ##處理委外倉退
          #IF sr.tlf13='apmt1072' THEN
          #   LET sr.amt1 = sr.tlf21
          #ELSE
          ##FUN-BB0063(E)
          #CHI-D30019---end
             LET sr.amt1 = 0                 #no.4836
             LET sr.amt2 = sr.tlf21
          #END IF  #CHI-D30019
       END IF 
       LET sr.qty  = sr.qty  * u_sign
       LET sr.amt1 = sr.amt1 * u_sign
       IF sr.qty = 0 THEN LET sr.qty=NULL END IF                      #No.FUN-780017
       EXECUTE insert_prep USING
          sr.ima01,sr.ima02,sr.tlfccost,sr.tlf06,sr.tlf036,           #No.FUN-7C0101 
          sr.tlf037,sr.ima25,sr.qty,sr.amt1,sr.amt2                   #No.FUN-780017        
     END FOREACH

     #該工單已無入庫數量但有轉出金額(ccg31=0 and ccg32<>0)
     LET l_sql = "SELECT '','',ima01,ima02,ima25,'',0,0,",
                #"       '','',ccg01,0,0,0,0,0,ccg32*-1 ",            #MOD-B30018 mark 
                 "       '','',ccg01,0,0,0,0,0,0,ccg32*-1,ccg07 ",    #MOD-B30018 add 
                 "  FROM ima_file, ccg_file, sfb_file  ",   #No:9625
                 " WHERE ",tm.wc CLIPPED ,
                 "   AND ccg31=0 AND ccg32<>0 ",
                 "   AND ima01=ccg04",
                 "   AND sfb01=ccg01",                      #No:9625
                 "   AND ccg02=",tm.yy,
                 "   AND ccg03=",tm.mm
     PREPARE axcr001_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr001_curs2 CURSOR FOR axcr001_prepare2
 
     FOREACH axcr001_curs2 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) EXIT FOREACH END IF
       IF tm.b = '1' THEN 
          LET sr.order1 = sr.ima01 
          LET sr.order2 = sr.tlf06 
       ELSE 
          LET sr.order1 = sr.tlf036 
          LET sr.order2 = sr.ima01 
       END IF 
       LET sr.tlf026='調整'
       IF sr.qty = 0 THEN LET sr.qty=NULL END IF              #No.FUN-780017
       EXECUTE insert_prep USING
          sr.ima01,sr.ima02,sr.tlfccost,sr.tlf06,sr.tlf036,   #No.FUN-7C0101
          sr.tlf037,sr.ima25,sr.qty,sr.amt1,sr.amt2           #No.FUN-780017                             
     END FOREACH
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                          #No.FUN-780017
     IF g_zz05 = 'Y' THEN                                                              #No.FUN-780017  
        CALL cl_wcchp(tm.wc,'ima01,ima39,ima08,ima06,tlf036,ima09,ima10,ima11,ima12')  #No.FUN-780017         
             RETURNING tm.wc                                                           #No.FUN-780017
     END IF                                                                            #No.FUN-780017  
     #LET g_str = tm.yy,";",tm.mm,";",g_ccz.ccz27,";",g_azi03,";",tm.b,";",tm.wc        #No.FUN-780017 #CHI-C30012 mark
     LET g_str = tm.yy,";",tm.mm,";",g_ccz.ccz27,";",g_ccz.ccz26,";",tm.b,";",tm.wc    #CHI-C30012
                 ,";",tm.type                                                          #No.FUN-7C0101
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                #No.FUN-780017
     CALL cl_prt_cs3('axcr001',l_name,l_sql,g_str)                                     #No.FUN-780017 
END FUNCTION
 
FUNCTION r001_get_atmt26(l_ima01,u_sign,l_tlf13,l_tlf026,l_qty)
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
   DECLARE r001_tsdf_tlf_c1 CURSOR FROM l_sql
 
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
 
      FOREACH r001_tsdf_tlf_c1 USING l_tlf026,l_tlf13,l_flag INTO l_tlf.*
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
   RETURN amta
 
END FUNCTION
 
FUNCTION r001_get_date()                                                                                                  
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
#No.FUN-9C0073 ------------------By chenls  10/01/12 
