# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr003.4gl
# Descriptions...: 出庫成本明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/10 By Nick
# Modify.........: No.8741 03/11/27 By Melody 成本階改抓ccc04,修改列印部份
# Modify.........: No.9700 04/07/13 By Carol 料號 20 碼,列印應show 20碼
# Modify.........: No.MOD-470487 04/09/09 By Smapmin 將料號放大到20碼並調整資料位置
# Modify.........: No.MOD-4A0202 04/10/13 By Carol sr.sfb05在本程式中跟本沒有出現過來源,造成部份資料執行不出單位成本資料!
# Modify.........: No.MOD-4B0014 04/11/24 By Carol 重工成本計算段落調整及修改
# Modify.........: No.FUN-4C0099 04/12/22 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-590022 05/09/07 By jackie 修正報表不齊問題 
# Modify.........: No.MOD-5A0452 05/11/15 By Sarah 將cost_code2移到FOREACH後SELECT
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致 
# Modify.........: No.FUN-670058 06/07/14 By Sarah 工單(tlf62)列印位數太短
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-780017 07/08/02 By dxfwo CR報表的制作
# Modify.........: No.FUN-7C0028 08/03/19 By Sarah 畫面增加tm.type(成本計算類型),報表增加列印tlfcost
# Modify.........: No.TQC-870024 08/07/21 By lutingting 將單號為TQC-810037過單到31區：出庫明細打印，應按照選擇序號分別列出明細資料
# Modify.........: No.FUN-820035 08/07/21 By lutingting 雜項出庫增加抓atmt260 atmt261的資料
# Modify.........: No.MOD-860120 08/09/18 By Pengu 當input條件選4.銷售出庫時sql會出現-1719錯誤訊息
# Modify.........: No.MOD-860073 08/06/23 By chenl 工單退料包含拆件式工單計算。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40130 10/04/26 By Carrier 追单FUN-9A0067/MOD-990108
# Modify.........: No:CHI-9B0031 10/11/25 By Summer 重複性生產無法產生工單領用資料
# Modify.........: No:MOD-B60065 11/06/08 By zhangll 抓取ccc_file資料時，where條件缺少關鍵字
# Modify.........: No:MOD-B70024 11/07/17 By Summer 當重工領用時並未沒重新抓取重工領用單價
# Modify.........: No:MOD-BB0072 11/11/12 By johung 調整出庫類別為「銷售出庫」時的條件
# Modify.........: No:MOD-C10110 12/01/12 By ck2yuan 雜項領用時,不抓取aimt302,aimt312的資料
# Modify.........: No:MOD-C20108 12/02/14 By ck2yuan 計算銷售成本時 (出貨)，如果oga65='Y'就不計算
# Modify.........: No:MOD-C20143 12/02/15 By ck2yuan 若未AFTER FIELD mm 不會是畫面上年度期別,改在AFTER INPUT才CALL s_azm
# Modify.........: No:MOD-C50083 12/05/14 By ck2yuan 當是雜項領用時，應依ccz08判斷是否應在axct500重取單價
# Modify.........: No:MOD-C50240 12/06/01 By ck2yuan 修正sql條件
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
          #wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(600),     # Where condition
           wc      STRING,          #MOD-B60065 mod
           yy,mm   LIKE type_file.num5,          #No.FUN-680122 SMALLINT, 
           type    LIKE type_file.chr1,          #FUN-7C0028 add        
           o       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)        
                   # (1)工單領用 (2)雜項領用 (3)其他調整 (4)銷售出庫
           more    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)        # Input more condition(Y/N)
           END RECORD
DEFINE g_tot_bal   LIKE type_file.num20_6        #No.FUN-680122 DECIMAL(20,6) # User defined variable
DEFINE bdate       LIKE type_file.dat            #No.FUN-680122 DATE
DEFINE edate       LIKE type_file.dat            #No.FUN-680122 DATE
DEFINE g_argv1     LIKE type_file.chr20          #No.FUN-680122 VARCHAR(20)
DEFINE g_argv2     LIKE type_file.num5           #No.FUN-680122 SMALLINT
DEFINE g_argv3     LIKE type_file.num5           #No.FUN-680122 SMALLINT
DEFINE g_chr       LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE g_i         LIKE type_file.num5           #count/index for any purpose #No.FUN-680122 SMALLINT
DEFINE l_table     STRING                        #No.FUN-780017                                                                    
DEFINE g_sql       STRING                        #No.FUN-780017                                                                    
DEFINE g_str       STRING                        #No.FUN-780017
 
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
              "ima25.ima_file.ima25,  tlf14.tlf_file.tlf14,",
              "tlf11.tlf_file.tlf11,  tlf62.tlf_file.tlf62,",
              "tlf036.tlf_file.tlf036,tlf037.tlf_file.tlf037,",
            #  "qty.ima_file.ima26,    up.oeb_file.oeb13,",     #No.FUN-A20044
              "qty.type_file.num15_3,    up.oeb_file.oeb13,",     #No.FUN-A20044
              "amt.oeb_file.oeb13,    tlfcost.tlf_file.tlfcost"   #FUN-7C0028 add tlfcost
  LET l_table = cl_prt_temptable('axcr003',g_sql) CLIPPED                                                                  
  IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
  LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"   #FUN-7C0028 add ?
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
  LET tm.type    = ARG_VAL(10)       #FUN-7C0028 add
  LET tm.o       = ARG_VAL(11)
  LET g_rep_user = ARG_VAL(12)
  LET g_rep_clas = ARG_VAL(13)
  LET g_template = ARG_VAL(14)
 
   LET g_rpt_name = ARG_VAL(8)  #No.FUN-7C0078
  IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
     THEN CALL axcr003_tm(0,0)          # Input print condition
  ELSE
     CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
     LET tm.wc=tm.wc CLIPPED," AND ima1.ima01 NOT LIKE 'MISC%'" #TQC-870024
     CALL axcr003()                     # Read data and create out-file
  END IF
 
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr003_tm(p_row,p_col)
  DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
  DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
  DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
 
  IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
  LET p_row = 3 LET p_col = 20
  OPEN WINDOW axcr003_w AT p_row,p_col WITH FORM "axc/42f/axcr003" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
  CALL cl_ui_init()
 
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL      # Default condition
  LET tm.type = g_ccz.ccz28    #FUN-7C0028 add
  LET tm.o    = '1'
  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies= '1'
 
  WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ima1.ima01,ima1.ima39,ima1.ima08,ima1.ima06, 
                                ima1.ima09,ima1.ima10,ima1.ima11,ima1.ima12,
                                tlf026, tlf036
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
        LET INT_FLAG = 0 
        CLOSE WINDOW axcr003_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
 
    #LET tm.wc=tm.wc CLIPPED," AND ima1.ima01 NOT MATCHES 'MISC*'" #CHI-9B0031 mark
     LET tm.wc=tm.wc CLIPPED," AND ima1.ima01 NOT like 'MISC%'" #CHI-9B0031
 
     LET tm.yy=g_ccz.ccz01 #No.TQC-A40130
     LET tm.mm=g_ccz.ccz02 #No.TQC-A40130
     INPUT BY NAME tm.yy,tm.mm,tm.type,tm.o,tm.more WITHOUT DEFAULTS    #FUN-7C0028 add tm.type
        BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
 
        AFTER FIELD yy
           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
        AFTER FIELD mm
           IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
           IF tm.mm < 1 OR tm.mm > 12 THEN 
              CALL cl_err('','-1103',1)
              NEXT FIELD mm
           END IF
          #CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate     #MOD-C20143 mark
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
 
        AFTER INPUT                                               #MOD-C20143 add
           CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate    #MOD-C20143 add

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
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='axcr003'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcr003','9031',1)   
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
                           " '",tm.type CLIPPED,"'",   #FUN-7C0028 add
                           " '",tm.o  CLIPPED,"'",
                           " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('axcr003',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW axcr003_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL axcr003()
     ERROR ""
  END WHILE
  CLOSE WINDOW axcr003_w
 
END FUNCTION
 
FUNCTION axcr003()
  DEFINE l_name      LIKE type_file.chr20,                 #No.FUN-680122CHAR(20),  # External(Disk) file name
        #l_sql       LIKE type_file.chr1000,               # RDSQL STATEMENT        #No.FUN-680122CHAR(1200), 
         l_sql       STRING,           #MOD-B60065 mod
         l_chr       LIKE type_file.chr1,                  #No.FUN-680122 VARCHAR(1)
         xxx         LIKE aab_file.aab02,                  #No.FUN-680122  VARCHAR(5), #FUN-550025
         u_sign      LIKE type_file.num5,                  #No.FUN-680122SMALLINT,
         l_za05      LIKE type_file.chr1000,               #No.FUN-680122 VARCHAR(40)
         l_order     ARRAY[5] OF LIKE cre_file.cre08,      #No.FUN-680122CHAR(10), 
         l_ima53     LIKE ima_file.ima53,
         l_ima91     LIKE ima_file.ima91,
         l_ima531    LIKE ima_file.ima531,
         l_dmy1      LIKE smy_file.smydmy1,
       #  qty1        LIKE ima_file.ima26,                  #No.FUN-680122DEC(15,3),
         qty1        LIKE type_file.num15_3,                  #No.FUN-A20044,
         amt1        LIKE oeb_file.oeb13,                  #No.FUN-680122 DECIMAL(20,6)
         cost_code1,cost_code2 LIKE ima_file.ima57,        #MOD-5A0452
         l_sfb05     LIKE sfb_file.sfb05,                  #MOD-5A0452
         l_sfb99     LIKE sfb_file.sfb99,                  #--20041026 by Eden
         l_sfb02     LIKE sfb_file.sfb02,                  #No:CHI-9B0031 add
         sr          RECORD ima01   LIKE ima_file.ima01,   #MOD-470487
                            ima02   LIKE ima_file.ima02,   # 
                            ima25   LIKE ima_file.ima25,   # 
                            tlf13   LIKE tlf_file.tlf13,
                            tlf62   LIKE tlf_file.tlf62,   #FUN-670058 VARCHAR(10)
                            tlf02   LIKE tlf_file.tlf02,   #No.FUN-680122 SMALLINT,
                            tlf03   LIKE tlf_file.tlf03,   #No.FUN-680122 SMALLINT,
                            tlf026  LIKE tlf_file.tlf026,  #No.FUN-680122 VARCHAR(10),   #FUN-550025
                            tlf027  LIKE tlf_file.tlf027,  #No.FUN-680122 SMALLINT,
                            tlf036  LIKE tlf_file.tlf036,  #No.FUN-680122 VARCHAR(10),   #FUN-550025  
                            tlf037  LIKE type_file.num5,   #No.FUN-680122 SMALLINT,
                            tlf11   LIKE tlf_file.tlf11,   #No.FUN-680122 VARCHAR(4),
                            tlf14   LIKE tlf_file.tlf14,   #No.FUN-680122 VARCHAR(4),
                            tlfcost LIKE tlf_file.tlfcost, #FUN-7C0028 add
                           # qty     LIKE ima_file.ima26,   #No.FUN-680122 DEC(15,3), 
                            qty     LIKE type_file.num15_3,   #No.FUN-A20044 
                            up      LIKE oeb_file.oeb13,   #No.FUN-680122 DEC(20,6)   # A/P Amt
                            amt     LIKE oeb_file.oeb13    #No.FUN-680122 DEC(20,6)   # Adj Amt
                     END RECORD
DEFINE  l_tlf907     LIKE tlf_file.tlf907    #No.MOD-860073
DEFINE  l_cnt        LIKE type_file.num5     #No:TQC-A40130 add
DEFINE l_oga65       LIKE oga_file.oga65     #MOD-C20108 add
 
  CALL cl_del_data(l_table)                         #No.FUN-780017 
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
  
     IF tm.o = '1' THEN
        LET l_sql = "SELECT ima1.ima01,ima1.ima02,ima1.ima25,",
                    "       tlf13,tlf62,tlf02,tlf03,",             
                    "       tlf026,tlf027,tlf036,tlf037,tlf11,tlf14,tlfcost,",  #FUN-7C0028 add tlfcost
                    "       tlf10*tlf60,0,0,",
                    "       ima1.ima57 ", #Carollin add                     
#CHI-9B0031 mod --start--
#"  FROM tlf_file LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype='",tm.type,"' ",
#"                LEFT OUTER JOIN sfb_file ON tlf62=sfb01 AND (sfb_file.sfb02<>'5' OR sfb_file.sfb02<>'8'), ", 
"  FROM tlf_file LEFT JOIN tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype='",tm.type,"' ,",
#CHI-9B0031 mod --end--
"       ima_file ima1",  
                    " WHERE ",tm.wc clipped,
                    "   AND (tlf06 BETWEEN '",bdate,"' AND '",edate,"')",
                    "   AND tlf10<>0 ",
                    "   AND tlf01=ima1.ima01",
                    "   AND tlf902 NOT IN(SELECT jce02 FROM jce_file)",
                   #--------------No:CHI-9B0031 modify
                   #"   AND ((tlf13 MATCHES 'asfi5*') OR (tlf13 MATCHES 'asft6*' AND tlf02 = 65))"  #No.MOD-860073
                    "   AND ((tlf13 like 'asfi5%') OR ",
                    "        (tlf13 like 'asri2%') OR ",
                    "        (tlf13 like 'asft6%' AND tlf02 = 65)) "
                   #--------------No:CHI-9B0031 end
     END IF
     IF tm.o ='2' THEN
            LET l_sql = "SELECT ima1.ima01,ima1.ima02,ima1.ima25,",
                                 "       tlf13,tlf62,tlf02,tlf03,",              #Carollin mdoify
                                 "       tlf026,tlf027,tlf036,tlf037,tlf11,tlf14,tlfcost,",  #FUN-7C0028 add tlfcost
                                 "       tlf10*tlf60,0,0,",
                                 "       ima1.ima57 ", #Carollin add                     #MOD-5A0452
                                #CHI-9B0031 mod --start--
                                #"  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype='",tm.type,"' ,ima_file ima1",   #FUN-7C0028 add tlfc_file
                                 "  FROM tlf_file LEFT JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype='",tm.type,"' ,ima_file ima1",   #FUN-7C0028 add tlfc_file
                                #CHI-9B0031 mod --end--
                                 " WHERE ",tm.wc clipped,
                                "   AND (tlf13='aimt301' or tlf13='aimt311' ",                  
                               #"    OR  tlf13='aimt302' or tlf13='aimt312'",       #MOD-C10110 mark            
                                "    OR  tlf13='atmt260' or tlf13='atmt261'",  #FUN-820035
                                "    OR  tlf13='aimt303' or tlf13='aimt313')",
                                "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                                "   AND tlf10<>0 ",
                                "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                                "   AND tlf01=ima1.ima01" ,
                                "  "                       #FUN-7C0028 add 
     END IF
     IF tm.o = '3' THEN
             LET l_sql = "SELECT ima1.ima01,ima1.ima02,ima1.ima25,",
                                  "       tlf13,tlf62,tlf02,tlf03,",                             
                                  "       tlf026,tlf027,tlf036,tlf037,tlf11,tlf14,tlfcost,",  #FUN-7C0028 add tlfcost
                                  "       tlf10*tlf60,0,0,",
                                  "       ima1.ima57 ",                     
                                 #CHI-9B0031 mod --start--
                                 #"  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype='",tm.type,"' ,ima_file ima1",   #FUN-7C0028 add tlfc_file
                                  "  FROM tlf_file LEFT JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 AND tlfctype='",tm.type,"' ,ima_file ima1",   #FUN-7C0028 add tlfc_file
                                 #CHI-9B0031 mod --end--
                                 " WHERE ",tm.wc clipped,
                                 "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                                 "   AND tlf10<>0 ",
                                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",              
                                 "   AND tlf01=ima1.ima01",
                                 "   AND tlf61  IN (SELECT smyslip FROM smy_file WHERE smydmy2 = '5') ",
                                 "  "                       #FUN-7C0028 add 
     END IF
     IF tm.o = '4' THEN
              LET l_sql = "SELECT ima1.ima01,ima1.ima02,ima1.ima25,",
                                   "       tlf13,tlf62,tlf02,tlf03,",              #Carollin mdoify
                                   "       tlf026,tlf027,tlf036,tlf037,tlf11,tlf14,tlfcost,",  #FUN-7C0028 add tlfcost
                                   "       tlf10*tlf60,0,0,",
                                   "       ima1.ima57 ", #Carollin add                     #MOD-5A0452
              #No.TQC-A40130  --Begin 去掉azf_file
                                  #CHI-9B0031 mod --start--
                                  #"  FROM ima_file ima1,tlf_file LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 ",
                                   "  FROM ima_file ima1,tlf_file LEFT JOIN tlfc_file ON tlf01=tlfc01 ",
                                  #CHI-9B0031 mod --en--
                                   "                     AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 ",
                                   "                     AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 ",
                                   "                     AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                                   "                     AND tlf907=tlfc907 AND tlfctype='",tm.type,"'",
                                   " WHERE ",tm.wc clipped,
                                  #"   AND (tlf13 matches 'axmt*' OR tlf13 MATCHES 'aomt*')", #CHI-9B0031 mark
                                  #"   AND (tlf13 like 'axm%*' OR tlf13 like 'aomt%')", #CHI-9B0031   #MOD-BB0072 mark
                                   "   AND (tlf13 like 'axm%' OR tlf13 like 'aomt%')",  #MOD-BB0072
                                   "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                                   "   AND tlf10<>0 ",
                                   "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                                   "   AND tlf01=ima1.ima01",
                                   "  "                       #FUN-7C0028 add 
              #No.TQC-A40130  --End  
     END IF
     IF tm.o = '5' THEN
             LET l_sql = "SELECT ima1.ima01,ima1.ima02,ima1.ima25,",
                                  "       tlf13,tlf62,tlf02,tlf03,",              #Carollin mdoify
                                  "       tlf026,tlf027,tlf036,tlf037,tlf11,tlf14,tlfcost,",  #FUN-7C0028 add tlfcost
                                  "       tlf10*tlf60,0,0,",
                                  "       ima1.ima57 ", #Carollin add                     #MOD-5A0452
                                 #CHI-9B0031 mod --start--
                                 #"  FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 LEFT OUTER JOIN sfb_file ON tlf62=sfb01 AND (sfb_file.sfb02 = '5' OR sfb_file.sfb02 = '8'), ima_file ima1",   #FUN-7C0028 add tlfc_file",
                                  "  FROM tlf_file LEFT JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 LEFT JOIN sfb_file ON tlf62=sfb01 AND (sfb_file.sfb02 = '5' OR sfb_file.sfb02 = '8'), ima_file ima1",   #FUN-7C0028 add tlfc_file",
                                 #CHI-9B0031 mod --end--
                                 " WHERE ",tm.wc clipped,
                                 "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                                 "   AND tlf10<>0 ",
                                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                                 "   AND tlf01=ima1.ima01",
                                 "   AND tlf62=sfb_file.sfb01 ",
                                #"   AND (tlf13 matches 'asfi5*') ", #CHI-9B0031 mark
                                 "   AND (tlf13 like 'asfi5%') ",    #CHI-9B0031
                                 "  "                       #FUN-7C0028 add 
     END IF
 
 
  PREPARE axcr003_prepare1 FROM l_sql
  IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
     EXIT PROGRAM 
  END IF
  DECLARE axcr003_curs1 CURSOR FOR axcr003_prepare1
 
  FOREACH axcr003_curs1 INTO sr.*,cost_code1 #Carollin add                        #MOD-5A0452
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET u_sign=0  
 
   #------------------No:MOD-990108 modify                                      
    IF tm.o = '4' THEN                                                          
       IF NOT cl_null(sr.tlf14) THEN                                            
          LET l_cnt = 0                                                         
          SELECT COUNT(*) INTO l_cnt FROM azf_file                              
                  WHERE azf01 = sr.tlf14 and azf08 = 'Y'                        
         IF l_cnt > 0 THEN CONTINUE FOREACH END IF                              
       END IF                                                                   
    END IF                                                                      
   #------------------No:MOD-990108 end 

   #--------------No:CHI-9B0031 add
    IF tm.o = '1' THEN
       LET l_sfb02 = NULL
       SELECT sfb02 INTO l_sfb02 FROM sfb_file 
               WHERE sfb01 = sr.tlf62 
       IF l_sfb02='5' OR l_sfb02='8' THEN CONTINUE FOREACH END IF
    END IF 
   #--------------No:CHI-9B0031 end

     SELECT sfb05,sfb99 INTO l_sfb05,l_sfb99
       FROM sfb_file WHERE sfb01 = sr.tlf62
     IF SQLCA.sqlcode OR cl_null(cost_code2) THEN
        LET l_sfb05 = ' '
        LET l_sfb99 = ' '
     END IF
     SELECT ima57 INTO cost_code2 FROM ima_file WHERE ima01 = l_sfb05
     IF SQLCA.sqlcode OR cl_null(cost_code2) THEN
        LET cost_code2 = ' '
     END IF
 
     IF sr.tlf02 = 50 OR sr.tlf02 = 57 THEN
        LET u_sign=1 
        IF sr.tlf03 <> 50 AND sr.tlf03 <> 57 AND sr.tlf13 !='aimp880' THEN
           LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
        END IF 
        IF sr.tlf13='aimp880' AND sr.tlf02 = 50 THEN 
           LET  u_sign = -1 
        END IF
        SELECT oga65 INTO l_oga65 FROM oga_file WHERE oga01=sr.tlf026   #MOD-C20108 add
     END IF
 
     IF sr.tlf03 = 50 OR sr.tlf03 = 57 THEN 
        IF sr.tlf02 = 65 THEN
           LET l_tlf907 = 0
           SELECT tlf907 INTO l_tlf907 FROM tlf_file 
            WHERE tlf01 = sr.ima01
           #MOD-C50240 str add-----
              AND tlf026 = sr.tlf026
              AND tlf027 = sr.tlf027
              AND tlf036 = sr.tlf036
              AND tlf037 = sr.tlf037
           #MOD-C50240 end add-----
           IF l_tlf907 <> 0 THEN
              LET u_sign = l_tlf907 * -1
           END IF 
        ELSE
           LET u_sign = -1
        END IF
        SELECT oga65 INTO l_oga65 FROM oga_file WHERE oga01=sr.tlf036   #MOD-C20108 add
     END IF
 
     IF sr.tlf02 = 50 AND sr.tlf03 = 57
        THEN LET u_sign=1 LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
        SELECT oga65 INTO l_oga65 FROM oga_file WHERE oga01=sr.tlf026   #MOD-C20108 add
     END IF
 
     IF u_sign=0 THEN CONTINUE FOREACH END IF
     LET sr.qty = sr.qty * u_sign
     CALL s_get_doc_no(sr.tlf036) RETURNING xxx
     IF xxx = 'Phy' THEN
        CALL s_get_doc_no(sr.tlf026) RETURNING xxx
     END IF
     SELECT smydmy2,smydmy1 INTO g_chr,l_dmy1
       FROM smy_file WHERE smyslip=xxx
      IF sr.tlf02 = 65 THEN
         LET g_chr = 3
      END IF
     IF g_chr = '1' OR g_chr IS NULL THEN CONTINUE FOREACH END IF
 
#Carollin modify 取單位成本及重工數量金額備用
      SELECT ccc25,ccc26,ccc23 INTO qty1,amt1,sr.up FROM ccc_file
       WHERE ccc01=sr.ima01 AND ccc02=tm.yy AND ccc03=tm.mm
         AND ccc07=tm.type AND ccc08=sr.tlfcost  #MOD-B60065 add
      IF qty1  IS NULL THEN LET qty1=0 END IF
      IF amt1  IS NULL THEN LET amt1=0 END IF
      IF sr.up IS NULL THEN LET sr.up=0 END IF
#------------------------------------------------
 
      IF l_dmy1 != 'Y' THEN CONTINUE FOREACH END IF
      IF tm.o='1' THEN                 #(1)工單領用
         IF g_chr != '3' THEN CONTINUE FOREACH END IF
         IF (sr.tlf02 >= 60 AND sr.tlf02 <= 69) OR
            (sr.tlf03 >= 60 AND sr.tlf03 <= 69) THEN 
            LET g_chr=''
         ELSE 
            CONTINUE FOREACH
         END IF
 
        #Carollin add--------------------
         IF sr.tlf13[1,5]='asfi5' THEN    #工單發料
            IF cost_code2 <> '99' AND cost_code1 <= cost_code2 THEN
               IF qty1 <> 0 THEN        #重工領出單位成本須重求
                  LET sr.up=amt1/qty1 
               ELSE 
                  LET sr.up=0
               END IF
            END IF
         END IF
        #--------------------------------
      END IF
 
      IF tm.o='2' THEN                 #(2)雜項領用
         IF g_chr != '3' THEN CONTINUE FOREACH END IF
         IF (sr.tlf02 >= 60 AND sr.tlf02 <= 69) OR
            (sr.tlf03 >= 60 AND sr.tlf03 <= 69) THEN 
            CONTINUE FOREACH
         ELSE 
            LET g_chr=''
         END IF
        #MOD-C50083 str add-----
         IF g_ccz.ccz08 = '2' THEN
            LET sr.up = 0
            SELECT inb13+inb132+inb133+inb134+inb135+inb136+inb137+inb138
              INTO sr.up FROM inb_file WHERE inb01= sr.tlf036 AND inb04=sr.ima01
         END IF
        #MOD-C50083 end add-----
      END IF
 
      IF tm.o='3' THEN                 #(3)其他調整
         IF g_chr != '5' THEN CONTINUE FOREACH END IF
      END IF
 
      IF tm.o='4' THEN                 #(4)銷售出庫
         IF g_chr != '2' THEN CONTINUE FOREACH END IF
         IF l_oga65 ='Y' THEN CONTINUE FOREACH END IF               #MOD-C20108 add
      END IF

     #MOD-B70024---add---start---
      IF tm.o='5' THEN
         IF g_chr != '3' THEN CONTINUE FOREACH END IF
         IF sr.tlf13[1,5]='asfi5' THEN    #工單發料
            IF cost_code2 <> '99' AND cost_code1 <= cost_code2 THEN
               IF qty1 <> 0 THEN        #重工領出單位成本須重求
                  LET sr.up=amt1/qty1 
               ELSE 
                  LET sr.up=0
               END IF
            END IF
         END IF
      END IF
     #MOD-B70024---add---end---


      LET sr.amt = sr.qty * sr.up
      EXECUTE insert_prep USING 
         sr.ima01,sr.ima02, sr.ima25, sr.tlf14,sr.tlf11,
         sr.tlf62,sr.tlf036,sr.tlf037,sr.qty,  sr.up,
         sr.amt  ,sr.tlfcost   #FUN-7C0028 add tlfcost
  END FOREACH
 
 
  IF g_zz05 = 'Y' THEN                                                        
     CALL cl_wcchp(tm.wc,'ima1.ima01, ima1.ima39, ima1.ima08, ima1.ima06,                                                       
                          ima1.ima09, ima1.ima10, ima1.ima11, ima1.ima12,                                                       
                          tlf026, tlf036 ')         
          RETURNING tm.wc                                                     
  END IF
  #             p1        p2        p3       p4           p5
  LET g_str = tm.yy,";",tm.mm,";",tm.wc,";",tm.o,";",g_ccz.ccz27,";",
  #             p6          p7
              #g_azi03,";",tm.type   #FUN-7C0028 add tm.type  #CHI-C30012 mark
              g_ccz.ccz26,";",tm.type    #CHI-C30012
  LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
  CALL cl_prt_cs3('axcr003','axcr003',l_sql,g_str)  
END FUNCTION
#No.FUN-9C0073 -----------------------By chenls 10/01/12 
