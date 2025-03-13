# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr771.4gl
# Descriptions...: 工單發料月報
# Input parameter: 
# Return code....: 
# Date & Author..: 98/12/03 By ANN CHEN
# Modify ........: No:9454 04/04/14 By Melody 修改tlf10 為tlf10*tlf60
# Modify ........: No:8741 moidfy 報表格式
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0099 05/01/04 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-5A0423 05/11/01 By Sarah 將362,376行的MARK拿掉
# Modify.........: No.FUN-5B0082 05/11/17 By Sarah 報表少印"其他"欄位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670058 06/07/18 By Sarah 抓取拆件式工單發料資料(將sfb02!='11'mark掉)
# Modify.........: No.MOD-680061 06/08/24 By Claire 倉退印倉庫tlf031
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710128 07/04/09 By pengu 重工否, 應以元件的重工否為依據, 而非工單的重工否
# Modify.........: No.TQC-760141 07/06/15 By Sarah 報表的製表日期與FROM/頁次等..應該在雙線的上一行(標準)
# Modify.........: No.TQC-790087 07/09/14 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-810073 07/12/25 By ChenMoyan 轉CR報表
# Modify.........: No.FUN-7C0101 08/01/31 By Cockroach  增加type(成本計算類型)和打印字段
# Modify.........: No.FUN-830002 08/03/05 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段
# Modify.........: No.MOD-7C0191 08/03/25 By Pengu 此支報表沒有針對拆件式的狀況做處理
# Modify.........: No.MOD-940230 09/04/16 By chenl 去掉對azf03的顯示限制語句.
# Modify.........: No.MOD-960193 09/06/30 By mike 金額相關欄位應該要用azi03取位         
# Modify.........: No.MOD-960284 09/06/25 By mike rpt tlf10小數取位(ccz27)應參照axcr700  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990086 09/09/09 By Carrier 報表資料剔除 不計算成本 的資料
# Modify.........: No:FUN-9A0050 09/10/15 By xiaofeizhu 增加會計科目，成本中心等信息 
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.TQC-A40139 10/04/29 By Carrier 1.MOD-9A0009 追单
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90029 11/11/01 By jason 單價要加製費
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-C80003 12/08/06 By Elise 將tlfctype的條件搬到left outer join的條件裡 
# Modify.........: No:MOD-D20105 13/02/20 By wujie 当站下线为正值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(300),      # Where condition
              bdate   LIKE type_file.dat,      #No.FUN-680122 DATE,
              edate   LIKE type_file.dat,      #No.FUN-680122 DATE,
              type    LIKE type_file.chr1,     #No.FUN-7C0101 ADD 成本計算類型
              stock   LIKE type_file.chr1,     #FUN-B90029
              a       LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),
              more    LIKE type_file.chr1      #No.FUN-680122 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_sql,g_str     STRING                #No.FUN-810073
DEFINE   l_table         STRING                #No.FUN-810073
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
   
   LET g_sql = "tlf021.tlf_file.tlf021,",
               "tlf06.tlf_file.tlf06,",
               "tlf026.tlf_file.tlf026,",
               "tlf62.tlf_file.tlf62,",
               "tlf01.tlf_file.tlf01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "tlfccost.tlfc_file.tlfccost,",       #FUN-7C0101 ADD
               "tlf10.tlf_file.tlf10,",
               "amt01.tlfc_file.tlfc221,",     #FUN-7C0101 tlf-->tlfc
               "amt02.tlfc_file.tlfc222,",     #FUN-7C0101 tlf-->tlfc    
               "amt03.tlfc_file.tlfc2231,",    #FUN-7C0101 tlf-->tlfc    
               "amt04.tlfc_file.tlfc2232,",    #FUN-7C0101 tlf-->tlfc    
               "amt05.tlfc_file.tlfc224,",     #FUN-7C0101 tlf-->tlfc    
               "amt07.tlfc_file.tlfc2241,",         #FUN-7C0101 ADD
               "amt08.tlfc_file.tlfc2242,",         #FUN-7C0101 ADD   
               "amt09.tlfc_file.tlfc2243,",         #FUN-7C0101 ADD   
               "amt06.ccc_file.ccc23,",
               "sfb99.cch_file.cch05,",
               "ima12.ima_file.ima12,",
               "bdate.type_file.dat,",
               "edate.type_file.dat,",
               "azf03.azf_file.azf03,",
               "ima39.ima_file.ima39,",                                           #FUN-9A0050
               "ima391.ima_file.ima391,",                                         #FUN-9A0050
               "tlf930.tlf_file.tlf930"                                           #FUN-9A0050               
   LET l_table = cl_prt_temptable('axcr771',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a = ARG_VAL(10)    
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET tm.type  = ARG_VAL(14)   #FUN-7C0101  ADD 
   #LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078 #FUN-B90029 mark
   LET g_rpt_name = ARG_VAL(15)   #FUN-B90029 ARG_VAL(13)重覆 
   LET tm.stock = ARG_VAL(16)     #No:FUN-B90029
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr771_tm(0,0)
      ELSE CALL axcr771()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr771_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_bdate,l_edate   LIKE type_file.dat,           #No.FUN-680122 DATE,    
          l_cmd             LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW axcr771_w AT p_row,p_col
        WITH FORM "axc/42f/axcr771" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,l_bdate,l_edate
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28
   LET tm.stock = '1'   #FUN-B90029
   LET tm.a   = 'Y'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima08,tlf62,ima57,ima01
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr771_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.stock,tm.a,tm.more #FUN-7C0101 ADD tm.type   #FUN-B90029 add tm.stock
      WITHOUT DEFAULTS 
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
      AFTER FIELD type 
        IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr771_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr771'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr771','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         #" '",tm.type  CLIPPED,"'",             #FUN-7C0101 ADD #FUN-B90029 mark
                         " '",tm.a CLIPPED,"'",                 #TQC-610051 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",tm.type  CLIPPED,"'",             #FUN-B90029 順序有誤
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.stock CLIPPED,"'"              #No:FUN-B90029
 
         CALL cl_cmdat('axcr771',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr771_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr771()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr771_w
END FUNCTION
 
FUNCTION axcr771()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),        # External(Disk) file name
           l_sql     STRING,
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),
          l_azf03   LIKE azf_file.azf03,          #No.FUN-810073
          sr               RECORD code   LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(01),
                                  ima12  LIKE ima_file.ima12,
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,   #FUN-4C0099
                                  tlfccost LIKE tlfc_file.tlfccost,  #FUN-7C0101 ADD
                                  tlf02  LIKE tlf_file.tlf02,
                                  tlf021 LIKE tlf_file.tlf021,
                                  tlf03  LIKE tlf_file.tlf03,
                                  tlf031 LIKE tlf_file.tlf031,
                                  tlf06  LIKE tlf_file.tlf06,
                                  tlf026 LIKE tlf_file.tlf026,
                                  tlf027 LIKE tlf_file.tlf027,
                                  tlf036 LIKE tlf_file.tlf036,
                                  tlf037 LIKE tlf_file.tlf037,
                                  tlf01  LIKE tlf_file.tlf01,
                                  tlf10  LIKE tlf_file.tlf10,
                                  tlfc21  LIKE tlfc_file.tlfc21,   #FUN-7C0101 tlf-->tlfc
                                  tlf13  LIKE tlf_file.tlf13,
                                  tlf62  LIKE tlf_file.tlf62,
                                  tlf907 LIKE tlf_file.tlf907,
                                  amt01  LIKE tlfc_file.tlfc221,   #材料金額 #FUN-7C0101 tlf-->tlfc
                                  amt02  LIKE tlfc_file.tlfc222,   #人工金額 #FUN-7C0101 tlf-->tlfc       
                                  amt03  LIKE tlfc_file.tlfc2231,  #製造費用#FUN-7C0101 tlf-->tlfc   
                                  amt04  LIKE tlfc_file.tlfc2232,  #加工費用 #FUN-7C0101 tlf-->tlfc   
                                 #start FUN-5B0082
                                  amt05  LIKE tlfc_file.tlfc224,   #其他金額#FUN-7C0101 tlf-->tlfc
                                  amt07  LIKE tlfc_file.tlfc2241, #FUN-7C0101 ADD 制費三  
                                  amt08  LIKE tlfc_file.tlfc2241, #FUN-7C0101 ADD 制費四  
                                  amt09  LIKE tlfc_file.tlfc2241, #FUN-7C0101 ADD 制費五 
                                 #amt05  LIKE ccc_file.ccc23     #總金額
                                  amt06  LIKE ccc_file.ccc23     #總金額
                                 #end FUN-5B0082
                        END RECORD
DEFINE     l_slip     LIKE smy_file.smyslip    #No.MOD-990086
DEFINE     l_smydmy1  LIKE smy_file.smydmy1    #No.MOD-990086
DEFINE     l_tlf032   LIKE tlf_file.tlf032     #No.FUN-9A0050
DEFINE     l_tlf930   LIKE tlf_file.tlf930     #No.FUN-9A0050 
DEFINE     l_ima39    LIKE ima_file.ima39      #No.FUN-9A0050
DEFINE     l_ima391   LIKE ima_file.ima391     #No.FUN-9A0050
DEFINE     l_ccz07    LIKE ccz_file.ccz07      #No.FUN-9A0050
DEFINE     l_where    STRING                   #FUN-B90029

     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-7C0101 ADD 4 ? #FUN-9A0050 Add ?,?,?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
        EXIT PROGRAM
     END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #No.TQC-A40139  --Begin
    #LET l_sql = "SELECT cch05,ima12,ima01,ima02,ima021,tlfccost, ",#FUN-7C0101 ADD tlfccost 
     LET l_sql = "SELECT '',   ima12,ima01,ima02,ima021,tlfccost, ",#FUN-7C0101 ADD tlfccost 
                 "       tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,",
                 "       tlf036,tlf037,tlf01,tlf10*tlf60,tlf21,tlf13,tlf62,tlf907,",
                 "       tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,tlf032,tlf930",#FUN-7C0101 tlf221-tlf224-->tlfc221-tlfc224  ADD tlf2241-tlf2243 #FUN-9A0050 Add tlf032,tlf930   
               # "  FROM tlf_file,ima_file,sfb_file,cch_file,tlfc_file", #FUN-7C0101 ADD tlfc_file    
                 "  FROM ima_file,sfb_file,tlf_file LEFT OUTER JOIN tlfc_file ",         #FUN-7C0101 ADD tlfc_file    
                 "                        ON  tlfc_file.tlfc01 = tlf01  AND tlfc_file.tlfc06 = tlf06",      #FUN-7C0101 ADD
                 "                        AND tlfc_file.tlfc02 = tlf02  AND tlfc_file.tlfc03 = tlf03 ",                        #FUN-830002 ADD                                      
                 "                        AND tlfc_file.tlfc13 = tlf13 ",                                         #FUN-830002 ADD                                      
                 "                        AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903= tlf903 ",                    #FUN-830002 ADD                                      
                 "                        AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc907= tlf907 ",                    #FUN-830002 ADD  
                 "                        AND tlfc_file.tlfc905= tlf905 AND tlfc_file.tlfc906= tlf906",     #FUN-7C0101 ADD  
                 "                        AND tlfc_file.tlfctype = '",tm.type,"' ",  #MOD-C80003 add
                 " WHERE ima_file.ima01 = tlf01 AND tlf62 = sfb_file.sfb01 ",
               # "   AND cch_file.cch01 = tlf62 ",
               # "   AND cch_file.cch02 = YEAR(tlf06) ",
               # "   AND cch_file.cch03 = MONTH(tlf06) ",
               # "   AND cch_file.cch04 = tlf01 ",
               # "   AND ((tlf13 matches 'asfi5*') OR (tlf13 matches 'asft6*' AND sfb02='11'))",   #FUN-B90029 mark
                 "   AND ",tm.wc CLIPPED,
                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                 "   AND tlf902 NOT IN(SELECT jce02 FROM jce_file) "              #MOD-C80003 del , 
               # "   AND cch06 = tlfctype ",                     #FUN-7C0101 ADD 
               # "   AND cch07 = tlfccost ",                     #FUN-7C0101 ADD 
               # " AND tlfc_file.tlfctype = '",tm.type,"'"       #FUN-7C0101 ADD  #MOD-C80003 mark 
     #No.TQC-A40139  --End  
 
     #FUN-B90029(S)
     CASE tm.stock
        WHEN "2"
           LET l_where = "   AND ((tlf13 matches 'asfi5*') OR (tlf13 matches 'asft6*' AND sfb02='11') OR (tlf13='asft700'))"
        WHEN "3"
           LET l_where = "   AND (tlf13='asft700')"
        OTHERWISE
           LET l_where = "   AND ((tlf13 matches 'asfi5*') OR (tlf13 matches 'asft6*' AND sfb02='11'))"
     END CASE
     LET l_sql = l_sql CLIPPED, l_where CLIPPED
     #FUN-B90029(E)
     
     PREPARE axcr771_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr771_curs1 CURSOR FOR axcr771_prepare1
 
     CALL cl_outnam('axcr771') RETURNING l_name
     LET g_pageno = 0
     FOREACH axcr771_curs1 INTO sr.*,l_tlf032,l_tlf930  #FUN-9A0050 Add l_tlf032,l_tlf930
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.tlf907>0 THEN
          LET l_slip = s_get_doc_no(sr.tlf036)
       ELSE
          LET l_slip = s_get_doc_no(sr.tlf026)
       END IF
       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
        WHERE smyslip = l_slip
       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
          CONTINUE FOREACH
       END IF
      #-----------------No:MOD-9A0009 add                                       
       LET sr.code=' '                                                          
       SELECT cch05 INTO sr.code FROM cch_file WHERE cch04 = sr.tlf01           
                     AND cch01 = sr.tlf62                                       
                     AND cch02 = YEAR(sr.tlf06)                                 
                     AND cch03 = MONTH(sr.tlf06)                                
                     AND cch06 = tm.type                                        
                     AND cch07 = sr.tlfccost                                    
      #-----------------No:MOD-9A0009 end 
       IF cl_null(sr.code) THEN LET sr.code = ' ' END IF
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
       IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF   #FUN-5B0082
       IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF   #FUN-7C0101  ADD
       IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF   #FUN-7C0101  ADD
       IF  cl_null(sr.amt09)  THEN LET sr.amt09=0 END IF   #FUN-7C0101  ADD
       #-->退料時為正值
       #IF sr.tlf907 = 1 THEN   #FUN-B90029
       IF sr.tlf907 = 1 AND (sr.tlf13<>'asft700') THEN  #FUN-B90029 
          LET sr.tlf02  = sr.tlf03
          LET sr.tlf021 = sr.tlf031     #MOD-680061 add
          LET sr.tlf026 = sr.tlf036
       ELSE 
          LET sr.tlf10= sr.tlf10 * -1
          LET sr.amt01= sr.amt01 * -1
          LET sr.amt02= sr.amt02 * -1
          LET sr.amt03= sr.amt03 * -1
          LET sr.amt04= sr.amt04 * -1
          LET sr.amt05= sr.amt05 * -1   #FUN-5B0082
          LET sr.amt07= sr.amt07 * -1   #FUN-7C0101  ADD                                                                                            
          LET sr.amt08= sr.amt08 * -1   #FUN-7C0101  ADD                                                                                            
          LET sr.amt09= sr.amt09 * -1   #FUN-7C0101  ADD         
       END IF
#No.MOD-D20105 --begin
       IF sr.tlf13 = 'asft700' THEN   #当站下线为正值
          LET sr.tlf10= sr.tlf10 * -1
          LET sr.amt01= sr.amt01 * -1
          LET sr.amt02= sr.amt02 * -1
          LET sr.amt03= sr.amt03 * -1
          LET sr.amt04= sr.amt04 * -1
          LET sr.amt05= sr.amt05 * -1   #FUN-5B0082
          LET sr.amt07= sr.amt07 * -1   #FUN-7C0101  ADD                                                                                            
          LET sr.amt08= sr.amt08 * -1   #FUN-7C0101  ADD                                                                                            
          LET sr.amt09= sr.amt09 * -1   #FUN-7C0101  ADD         
       END IF
#No.MOD-D20105 --end
       LET sr.amt06 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt04 + sr.amt05 + sr.amt07 + sr.amt08 + sr.amt09 #FUN-7C0101 ADD amt07-amt09
       IF cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF
      
      IF NOT cl_null(sr.ima12) THEN                                                                                                
         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818                                          
         IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF                                                                            
      END IF
           LET l_sql = "SELECT ccz07 ",                                                                                             
                       " FROM ccz_file ",                                                                          
                       " WHERE ccz00 = '0' "                                                                                        
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                                     
           PREPARE ccz_p1 FROM l_sql                                                                                                
           IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF                                                       
           DECLARE ccz_c1 CURSOR FOR ccz_p1                                                                                         
           OPEN ccz_c1                                                                                                              
           FETCH ccz_c1 INTO l_ccz07                                                                                                
           CLOSE ccz_c1
           CASE WHEN l_ccz07='1'                                                                                                    
                     LET l_sql="SELECT ima39,ima391 FROM ima_file ",                  
                               " WHERE ima01='",sr.tlf01,"'"                                                                     
                WHEN l_ccz07='2'                                                                                                    
                    LET l_sql="SELECT imz39,imz391 ",                                                  
                         " FROM ima_file,imz_file",                                                                      
                         " WHERE ima01='",sr.tlf01,"' AND ima06=imz01 "                                                          
                WHEN l_ccz07='3'                                                                                                    
                     LET l_sql="SELECT imd08,imd081 FROM imd_file",                          
                         " WHERE imd01='",sr.tlf031,"'"                                                                           
                WHEN l_ccz07='4'                                                                                                    
                     LET l_sql="SELECT ime09,ime091 FROM ime_file",           
                         " WHERE ime01='",sr.tlf031,"' ",                                                                         
                           " AND ime02='",l_tlf032,"'"                                                                           
          END CASE
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                               
          PREPARE stock_p1 FROM l_sql                                                                                               
          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
          DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
          OPEN stock_c1                                                                                                             
          FETCH stock_c1 INTO l_ima39,l_ima391                                                                                           
          CLOSE stock_c1       
      EXECUTE insert_prep USING
          sr.tlf021,sr.tlf06,sr.tlf026,sr.tlf62,sr.tlf01,sr.ima02,sr.ima021,sr.tlfccost,   #FUN-7C0101 ADD tlfccost
          sr.tlf10,sr.amt01,sr.amt02,sr.amt03,sr.amt04,sr.amt05,sr.amt07,sr.amt08,sr.amt09,# #FUN-7C0101 ADD sr.amt07-amt09
          sr.amt06,sr.code,sr.ima12,tm.bdate,tm.edate,l_azf03
          ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add
      
     END FOREACH
 
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'ima12,ima08,tlf62,ima57,ima01')
             RETURNING tm.wc
     ELSE
         LET tm.wc = ""
     END IF
     #LET g_str = tm.wc,";",tm.a,";",g_azi03,";",g_ccz.ccz27  #MOD-960193   add azi03 #MOD-960284 add ccz27  #CHI-C30012
     LET g_str = tm.wc,";",tm.a,";",g_ccz.ccz26,";",g_ccz.ccz27  #CHI-C30012
#根據成本計算類型判定類別編號是否打印
     IF tm.type MATCHES '[12]' THEN
        IF g_aza.aza63 = 'Y' THEN
           LET l_name = 'axcr771_2'
        ELSE
     	     LET l_name = 'axcr771'
        END IF	     
        CALL cl_prt_cs3('axcr771',l_name,g_sql,g_str)             #FUN-9A0050 Add        
     ELSE
        IF g_aza.aza63 = 'Y' THEN
           LET l_name = 'axcr771_3'
        ELSE
     	     LET l_name = 'axcr771_1'
        END IF	     
        CALL cl_prt_cs3('axcr771',l_name,g_sql,g_str)             #FUN-9A0050 Add         
     END IF 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
