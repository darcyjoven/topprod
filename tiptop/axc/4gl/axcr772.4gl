# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr772.4gl
# Descriptions...: 工單入庫月報
# Input parameter: 
# Return code....: 
# Date & Author..: 98/12/03 By ANN CHEN
# Modify ........: 01/06/29 By Ostrich 010629 #No.+319 加列在製差異轉出
# Modify ........: No:9452 04/04/14 By Melody 修改tlf10 為tlf10*tlf60
# Modify ........: No:8741 03/11/25 By Melody 列印格式修改
# Modify ........: No:9586(MOD-470046) 04/07/16 By Carol SQL 須新增考慮RUNCARD完工入庫
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0099 05/01/04 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-580167 05/08/16 By Claire 補上ima021 對應
# Modify.........: No.MOD-5A0408 05/11/01 By Sarah 將375,391行的MARK拿掉
# Modify.........: No.FUN-5A0210 05/11/15 By Sarah 將r772_ccg_cur,r772_ccg_cur1改成PREPARE sql寫法串tm.wc
# Modify.........: No.FUN-5B0082 05/11/17 By Sarah 報表少印"其他"欄位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670058 06/07/18 By Sarah 抓取拆件式工單入庫資料(將sfb02!='11'mark掉)
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將之前FUN-670058多抓cct_file的部份remove
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/28 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-740434 07/04/24 By Sarah 條件選項的日期區間若輸入超出一期,資料抓取有誤
# Modify.........: No.FUN-7C0034 007/12/26 By ChenMoyan 轉CR報表
# Mofify.........: No.FUN-7C0101 08/01/25 By lala 成本改善增加成本計算類型(type)  
# Modify.........: No.FUN-830002 08/03/05 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段
# Modify.........: No.MOD-820053 08/03/23 By Pengu 抓取ccg的資料應該考慮到截止日期(tm.edate)
# Modify.........: No.MOD-7C0192 08/03/25 By Pengu 此支報表沒有針對拆件式的狀況做處理
# Modify.........: No.MOD-840342 08/04/20 By Sarah 報表欄位的值與正確的值對不起來(應該是寫入Temptable時塞錯欄位)
# Modify.........: No.MOD-870186 08/07/16 By Pengu 成本分群小計的成本分群說明無法完全顯示
# Modify.........: No.MOD-920161 09/02/16 By Pengu 取得在製起迄期別ccg_file中起始期及截止期有問題
# Modify.........: No.MOD-960193 09/06/30 By mike 金額相關欄位應該要用azi03取位     
# Modify.........: No.MOD-960283 09/06/25 By mike rpt tlf10小數取位(ccz27)應參照axcr700  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0050 09/10/15 By xiaofeizhu 增加會計科目，成本中心等信息
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.TQC-A40139 10/04/29 By Carrier 1.MOD-990257 追单
# Modify.........: No:MOD-A50022 10/05/05 By Sarah 1.l_bmm與l_emm應改以年度*12+期別計算 2.ccg03應過濾期別
# Modify.........: No:FUN-B90029 11/10/25 By jason 單價要加製費
# Modify.........: No:MOD-C50106 12/05/15 By Elise 將LET l_azf03=l_azf03[1,8]都mark
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:TQC-C80058 12/08/08 By lujh 倉庫tlf031改抓tlf902，tlf032改抓tlf903
# Modify.........: No:MOD-C80226 12/10/10 By yinhy tlf930該抓sfb98
# Modify.........: No:FUN-C80092 12/12/07 By fengrui 修改只列印當站下線資料包含製差問題
# Modify.........: No:TQC-D10073 13/01/18 By wujie 將tlfctype的條件搬到left outer join的條件裡
# Modify.........: No:TQC-D20051 13/02/26 By wujie sql有写错，调整
# Modify.........: No:FUN-D20078 13/02/27 By xujing 倉退單過帳寫tlf時,區分一般倉退和委外倉退,同時修正成本計算及相關查詢報表邏輯

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
              bdate   LIKE type_file.dat,           #No.FUN-680122DATE
              edate   LIKE type_file.dat,           #No.FUN-680122DATE
              type    LIKE type_file.chr1,          #No.FUN-7C0101 VARCHAR(1)
              stock   LIKE type_file.chr1,          #No.FUN-B90029
              a       LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_sql           STRING                     #No.FUN-7C0034
DEFINE   g_str           STRING                     #No.FUN-7C0034
DEFINE   l_azf03         LIKE azf_file.azf03        #No.FUN-7C0034
DEFINE   l_table         STRING                     #No.FUN-7C0034
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
   
   LET g_sql = "tlf031.tlf_file.tlf031,tlf06.tlf_file.tlf06,",
               "tlf036.tlf_file.tlf036,tlf62.tlf_file.tlf62,",
               "tlf01.tlf_file.tlf01,  ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,tlfccost.tlfc_file.tlfccost,", #No.FUN-7C0101 add tlfccost
               "tlf10.tlf_file.tlf10,  amt01.tlf_file.tlf221,",
               "amt02.tlf_file.tlf222, amt03.tlf_file.tlf2231,",
               "amt04.tlf_file.tlf2232,amt05.tlf_file.tlf224,",
               "amt07.ccc_file.ccc23,  amt08.tlf_file.tlf2241,",     #No.FUN-7C0101
               "amt09.tlf_file.tlf2242,amt06.tlf_file.tlf2243,",     #No.FUN-7C0101
               "code.type_file.chr1,   ima12.ima_file.ima12,",
               "bdate.type_file.dat,   edate.type_file.dat,",
               "azf03.azf_file.azf03,",
               "ima39.ima_file.ima39,",                                           #FUN-9A0050
               "ima391.ima_file.ima391,",                                         #FUN-9A0050
               "tlf930.tlf_file.tlf930"                                           #FUN-9A0050               
   LET l_table = cl_prt_temptable('axcr772',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?,?)"            #No.FUN-7C0101 add               #FUN-9A0050 Add ?,?,? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a    = 'Y'
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
   LET tm.type = ARG_VAL(14)               #No.FUN-7C0101
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   LET tm.stock = ARG_VAL(14)   #FUN-B90029
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr772_tm(0,0)
      ELSE CALL axcr772()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr772_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01,          #No.FUN-580031
       p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
       l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
       l_bdate,l_edate   LIKE type_file.dat,           #No.FUN-680122 DATE  
       l_cmd             LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW axcr772_w AT p_row,p_col WITH FORM "axc/42f/axcr772"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,l_bdate,l_edate
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.more= 'N'
   LET tm.a   = 'Y'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.type = g_ccz.ccz28   #No.FUN-7C0101 add
   LET tm.stock = '1'   #FUN-B90029
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima08,sfb01,ima57,ima01   #FUN-5A0210
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr772_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.stock,tm.a,tm.more   #No.FUN-7C0101 add tm.type #FUN-B90029 add tm.stock 
      WITHOUT DEFAULTS 
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
      AFTER FIELD type
        IF cl_null(tm.type) OR tm.type NOT MATCHES '[12345]' THEN
           NEXT FIELD type
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr772_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr772'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr772','9031',1)   
      ELSE
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
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101 add
                         " '",tm.a CLIPPED,"'",                 #TQC-610051 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.stock CLIPPED,"'"              #No:FUN-B90029
 
         CALL cl_cmdat('axcr772',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr772_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr772()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr772_w
END FUNCTION
 
FUNCTION axcr772()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
          l_sql     STRING,                       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_ccg02b  LIKE ccg_file.ccg02,   #FUN-5A0210    #MOD-740434 modify
          l_ccg03b  LIKE ccg_file.ccg03,   #FUN-5A0210    #MOD-740434 modify
          l_ccg02e  LIKE ccg_file.ccg02,                  #MOD-740434 add
          l_ccg03e  LIKE ccg_file.ccg03,                  #MOD-740434 add
          l_bmm     LIKE type_file.num5,                  #No.MOD-920161 add
          l_emm     LIKE type_file.num5,                  #No.MOD-920161 add
          sr        RECORD                                #MOD-840342 mod
                     code     LIKE type_file.chr1,        #No.FUN-680122CHAR(01)
                     ima12    LIKE ima_file.ima12,
                     ima01    LIKE ima_file.ima01,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,       #FUN-4C0099
                     tlfccost LIKE tlfc_file.tlfccost,    #No.FUN-7C0101
                     tlf021   LIKE tlf_file.tlf021,
                     tlf031   LIKE tlf_file.tlf031,
                     tlf06    LIKE tlf_file.tlf06,
                     tlf036   LIKE tlf_file.tlf036,
                     tlf037   LIKE tlf_file.tlf037,
                     tlf01    LIKE tlf_file.tlf01,
                     tlf10    LIKE tlf_file.tlf10,
                     tlfc21   LIKE tlfc_file.tlfc21,      #No.FUN-7C0101
                     tlf13    LIKE tlf_file.tlf13,
                     tlf62    LIKE tlf_file.tlf62,
                     tlf907   LIKE tlf_file.tlf907,
                     amt01    LIKE tlf_file.tlf221,   #材料金額
                     amt02    LIKE tlf_file.tlf222,   #人工金額     
                     amt03    LIKE tlf_file.tlf2231,  #製造費用
                     amt04    LIKE tlf_file.tlf2232,  #加工費用
                     amt05    LIKE tlf_file.tlf224,   #其他金額
                     amt07    LIKE tlf_file.tlf2241,  #No.FUN-7C0101
                     amt08    LIKE tlf_file.tlf2242,  #No.FUN-7C0101
                     amt09    LIKE tlf_file.tlf2243,  #No.FUN-7C0101
                     amt06    LIKE ccc_file.ccc23,    #總金額
                     tlf902   LIKE tlf_file.tlf902,   #TQC-C80058 add
                     tlf903   LIKE tlf_file.tlf903    #TQC-C80058 add   
                    END RECORD
DEFINE     l_tlf032   LIKE tlf_file.tlf032     #No.FUN-9A0050
DEFINE     l_tlf930   LIKE tlf_file.tlf930     #No.FUN-9A0050 
DEFINE     l_ima39    LIKE ima_file.ima39      #No.FUN-9A0050
DEFINE     l_ima391   LIKE ima_file.ima391     #No.FUN-9A0050
DEFINE     l_ccz07    LIKE ccz_file.ccz07      #No.FUN-9A0050                    
DEFINE     l_where    STRING                   #FUN-B90029     
DEFINE     l_sfb98    LIKE sfb_file.sfb98      #MOD-C80226
   
     CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '',ima12,ima01,ima02,ima021,tlfccost,",      #No.FUN-7C0101 add tlfccost   #MOD-840342 mod
                #" tlf021,tlf031,tlf06,tlf036,tlf037,",      #FUN-D20078 mark 
                 " tlf021,tlf031,tlf06,tlf905,tlf906,",      #FUN-D20078 add
                #" tlf01,tlf10*tlf60,tlfc21,tlf13,tlf62,tlf907,", #No:9452   #No.FUN-7C0101 tlf21->tlfc21    #FUN-D20078 mark
                 " tlf01,tlf10*tlf60*tlf907,tlfc21*tlf907,tlf13,tlf62,tlf907,", #FUN-D20078 add
                #"  tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,tlf902,tlf903,tlf032,tlf930",   #FUN-5B0082   #No.FUN-7C0101 #FUN-9A0050 Add tlf032,tlf930   #TQC-C80058  add tlf902,tlf903 #FUN-D20078 mark
                 "  tlfc221*tlf907,tlfc222*tlf907,tlfc2231*tlf907,tlfc2232*tlf907,tlfc224*tlf907,tlfc2241*tlf907,", #FUN-D20078 add
                 "  tlfc2242*tlf907,tlfc2243*tlf907,0,tlf902,tlf903,tlf032,tlf930",   #FUN-D20078 add
                 "  FROM tlf_file LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf02=tlfc02 AND tlf03 = tlfc03 AND tlf13=tlfc13 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906  ",          #No.FUN-7C0101  TQC-D20051 remove ima_file,sfb_file
                 "                        AND tlfc_file.tlfctype = '",tm.type,"' ",  #No.TQC-D10073 add
                 " ,ima_file,sfb_file ",                                             #No.TQC-D20051 add
                 " WHERE ima01 = tlf01 and tlf62=sfb01",
                 "   AND sfb02!=11",   #FUN-670058 mark    #No.MOD-7C0192 del mark
                 #"   AND (tlf13 = 'asft6201' OR tlf13='asft6101' ",   #No:9586  #FUN-B90029 mark
                 #"    OR  tlf13 = 'asft6231' OR tlf13='asft660' )",    #No:9586 #FUN-B90029 mark
                 "   AND ",tm.wc CLIPPED,
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')" #No.TQC-D10073 del ,
#                 " AND tlfc_file.tlfctype = '",tm.type,"'"                 #No.TQC-D10073 mark"
     #FUN-B90029(S)
     CASE tm.stock
        WHEN "2"
           LET l_where = "   AND (tlf13 = 'asft6201' OR tlf13='asft6101' ",
                         "    OR  tlf13 = 'asft6231' OR tlf13='asft660' OR tlf13='asft700')"
        WHEN "3"
           LET l_where = "   AND (tlf13='asft700')"
        OTHERWISE
           LET l_where = "   AND (tlf13 = 'asft6201' OR tlf13='asft6101' ",
                         "    OR  tlf13 = 'asft6231' OR tlf13='asft660' )"
     END CASE
     LET l_sql = l_sql CLIPPED, l_where CLIPPED
     #FUN-B90029(E)                  
     PREPARE axcr772_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr772_curs1 CURSOR FOR axcr772_prepare1
 
     CALL cl_outnam('axcr772') RETURNING l_name
     LET g_pageno = 0
     FOREACH axcr772_curs1 INTO sr.*,l_tlf032,l_tlf930 #FUN-9A0050 Add l_tlf032,l_tlf930
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET sr.code=' '
       SELECT sfb99,sfb98 INTO sr.code,l_sfb98 FROM sfb_file WHERE sfb01 = sr.tlf62  #MOD-C80226 add sfb98
       IF SQLCA.sqlcode THEN LET sr.code = ' ' END IF
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
       IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF
       IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF                  #No.FUN-7C0101
       IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF                  #No.FUN-7C0101
       IF  cl_null(sr.amt09)  THEN LET sr.amt09=0 END IF                  #No.FUN-7C0101
       LET sr.amt06 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt04 + sr.amt05+ sr.amt07 + sr.amt08 + sr.amt09   #No.FUN-7C0101
       IF  cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF
       IF NOT cl_null(sr.ima12) and sr.ima12 !='ZZZ' THEN                                                                           
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
                         #" WHERE imd01='",sr.tlf031,"'"  #TQC-C80058  mark                                                                          
                         " WHERE imd01='",sr.tlf902,"'"   #TQC-C80058  add
                WHEN l_ccz07='4'                                                                                                    
                     LET l_sql="SELECT ime09,ime091 FROM ime_file",           
                         #" WHERE ime01='",sr.tlf031,"' ",#TQC-C80058  mark                                                                         
                         #  " AND ime02='",l_tlf032,"'"   #TQC-C80058  mark   
                         " WHERE ime01='",sr.tlf902,"' ", #TQC-C80058  add
                         "   AND ime02='",sr.tlf903,"'"   #TQC-C80058  add                                                                     
          END CASE
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                               
          PREPARE stock_p1 FROM l_sql                                                                                               
          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
          DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
          OPEN stock_c1                                                                                                             
          FETCH stock_c1 INTO l_ima39,l_ima391                                                                                           
          CLOSE stock_c1       
       EXECUTE insert_prep USING
          sr.tlf031,sr.tlf06, sr.tlf036,  sr.tlf62,sr.tlf01,
          sr.ima02, sr.ima021,sr.tlfccost,sr.tlf10,sr.amt01,   #No.FUN-7C0101 add tlfccost
          sr.amt02, sr.amt03, sr.amt04,   sr.amt05,sr.amt07,   #No.FUN-7C0101 add amt7
          sr.amt08, sr.amt09, sr.amt06,   sr.code, sr.ima12,   #No.FUN-7C0101 add amt8,amt9
          tm.bdate, tm.edate, l_azf03
         #,l_ima39,l_ima391,l_tlf930                           #FUN-9A0050 Add  #MOD-C80226 mark
          ,l_ima39,l_ima391,l_sfb98                             #MOD-C80226 mod sfb98
     END FOREACH
    
     IF cl_null(tm.stock) OR tm.stock<>'3' THEN  #FUN-C80092 add
     #No.+319 add by Ostrich 在製差異轉出應列示 ---
     #ccz09 = 'Y' 時,在製差異轉出歸本月入庫
        LET l_ccg02b= YEAR(tm.bdate)    #MOD-740434 modify
        LET l_ccg03b= MONTH(tm.bdate)   #MOD-740434 modify
        LET l_ccg02e= YEAR(tm.edate)    #MOD-740434 add
        LET l_ccg03e= MONTH(tm.edate)   #MOD-740434 add
       #str MOD-A50022 mod
       #改以年度*12+期別來計算
       #LET l_bmm = YEAR(tm.bdate) * 12 + MONTH(tm.bdate)   #No:MOD-920161 add
       #LET l_emm = YEAR(tm.edate) * 12 + MONTH(tm.edate)   #No:MOD-920161 add
        CALL s_yp(tm.bdate) RETURNING l_ccg02b,l_ccg03b
        CALL s_yp(tm.edate) RETURNING l_ccg02e,l_ccg03e
        LET l_bmm = l_ccg02b * 12 + l_ccg03b
        LET l_emm = l_ccg02e * 12 + l_ccg03e
       #end MOD-A50022 mod
        LET l_sql = "SELECT 'Z',ima12,ccg04,ima02,ima021, ",
                    #No.TQC-A40139  --Begin
                   #"       ' ',' ',' ',ima12,' ', ",
                   #"       ima01,ccg31,ccg32,' ',ccg01,ccg07, ",              #No.FUN-7C0101 add ccg07
                    "       ccg07,' ',' ',' ',ima12,' ', ",
                    "       ima01,ccg31,ccg32,' ',ccg01, ",              #No.FUN-7C0101 add ccg07
                    #No.TQC-A40139  --End  
                    "       ' ',-ccg32a,-ccg32b,-ccg32c,-ccg32d,-ccg32e,-ccg32f,-ccg32g,-ccg32h,0 ",   #FUN-5B0082  #No.FUN-7C0101 add ccg32f,g,h
                    "  FROM ccg_file,ima_file,sfb_file ",
                    " WHERE (ccg02 * 12 + ccg03) BETWEEN ",l_bmm CLIPPED,
                    "   AND ",l_emm CLIPPED,
                    "   AND sfb02<>'11' ",
                    "   AND ccg32 <>0 ",
                    "   AND ccg06 = '",tm.type,"'",   #No.FUN-7C0101 add
                    "   AND ima01 = ccg04 ",
                    "   AND ccg31 = 0 ",
                    "   AND sfb01 = ccg01 ",
                    "   AND ",tm.wc CLIPPED
  
        PREPARE r772_prepare1 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
           EXIT PROGRAM 
        END IF
        DECLARE r772_ccg_cur CURSOR FOR r772_prepare1
        FOREACH r772_ccg_cur INTO sr.*
          IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
          IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
          IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
          IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
          IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF
          IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF                  #No.FUN-7C0101
          IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF                  #No.FUN-7C0101
          IF  cl_null(sr.amt09)  THEN LET sr.amt09=0 END IF                  #No.FUN-7C0101
          LET sr.amt06 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt04 + sr.amt05+ sr.amt07 + sr.amt08 + sr.amt09   #No.FUN-7C0101
          IF  cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF
          IF NOT cl_null(sr.ima12) and sr.ima12 !='ZZZ' THEN                                                                           
             SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818                                          
             IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF                                                                            
            #LET l_azf03=l_azf03[1,8]  #MOD-C50106 mark                                                                                                  
          END IF                                                                                                          
          EXECUTE insert_prep USING                                                                                                    
             sr.tlf031,sr.tlf06, sr.tlf036,  sr.tlf62,sr.tlf01,
             sr.ima02, sr.ima021,sr.tlfccost,sr.tlf10,sr.amt01,   #No.FUN-7C0101 add tlfccost
             sr.amt02, sr.amt03, sr.amt04,   sr.amt05,sr.amt07,   #No.FUN-7C0101 add amt7
             sr.amt08, sr.amt09, sr.amt06,   sr.code, sr.ima12,   #No.FUN-7C0101 add amt8,amt9
             tm.bdate, tm.edate, l_azf03
             ,'','',''                                            #FUN-9A0050 Add
        END FOREACH
    
     #ccz09 = 'N' 時,在製差異轉出歸差異ccg42 (成本分群預設為'ZZZ')
       #str MOD-A50022 mod
       #改抓年度,期別
       #LET l_ccg02b= YEAR(tm.bdate)    #MOD-740434 modify
       #LET l_ccg03b= MONTH(tm.bdate)   #MOD-740434 modify
       #LET l_ccg02e= YEAR(tm.edate)    #MOD-740434 add
       #LET l_ccg03e= MONTH(tm.edate)   #MOD-740434 add
        CALL s_yp(tm.bdate) RETURNING l_ccg02b,l_ccg03b
        CALL s_yp(tm.edate) RETURNING l_ccg02e,l_ccg03e
       #end MOD-A50022 mod
        LET l_sql = "SELECT '','ZZZ',ccg04,ima02,ima021, ",
                    #No.TQC-A40139  --Begin
                   #"       ' ',' ',' ',ima12,' ', ",
                   #"       ima01,ccg41,ccg42,' ',ccg01,ccg07, ",              #No.FUN-7C0101 add ccg07
                    "       ccg07,' ',' ',' ',ima12,' ', ",
                    "       ima01,ccg41,ccg42,' ',ccg01, ",              #No.FUN-7C0101 add ccg07
                    #No.TQC-A40139  --End  
                    "       ' ',-ccg42a,-ccg42b,-ccg42c,-ccg42d,-ccg42e,-ccg42f,-ccg42g,-ccg42h,0 ",   #FUN-5B0082   #No.FUN-7C0101 add ccg42f,g,h
                    "  FROM ccg_file,ima_file,sfb_file ",
                    " WHERE ccg02 >= ",l_ccg02b," AND ccg03 >= ",l_ccg03b,   
                    "   AND ccg02 <= ",l_ccg02e," AND ccg03 <= ",l_ccg03e,   
                    "   AND sfb02<>'11' ",
                    "   AND ccg42 <>0 ",
                    "   AND ccg06 = '",tm.type,"'",                          #No.FUN-7C0101 add
                    "   AND ima01 = ccg04 ",
                    "   AND sfb01 = ccg01 ",
                    "   AND ",tm.wc CLIPPED
    
        PREPARE r772_prepare2 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
           EXIT PROGRAM 
        END IF
        DECLARE r772_ccg_cur1 CURSOR FOR r772_prepare2
        FOREACH r772_ccg_cur1 INTO sr.*
          IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
          IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
          IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
          IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
          IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF
          IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF                  #No.FUN-7C0101
          IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF                  #No.FUN-7C0101
          IF  cl_null(sr.amt09)  THEN LET sr.amt09=0 END IF                  #No.FUN-7C0101
          LET sr.amt06 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt04 + sr.amt05 + sr.amt07 + sr.amt08 + sr.amt09      #No.FUN-7C0101
          IF  cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF
          IF NOT cl_null(sr.ima12) and sr.ima12 !='ZZZ' THEN                                                                           
             SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818                                          
             IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF                                                                            
            #LET l_azf03=l_azf03[1,8]  #MOD-C50106 mark                                                                                                  
          END IF                                                                                                             
          EXECUTE insert_prep USING                                                                                                    
             sr.tlf031,sr.tlf06, sr.tlf036,  sr.tlf62,sr.tlf01,
             sr.ima02, sr.ima021,sr.tlfccost,sr.tlf10,sr.amt01,   #No.FUN-7C0101 add tlfccost
             sr.amt02, sr.amt03, sr.amt04,   sr.amt05,sr.amt07,   #No.FUN-7C0101 add amt7
             sr.amt08, sr.amt09, sr.amt06,   sr.code, sr.ima12,   #No.FUN-7C0101 add amt8,amt9
             tm.bdate, tm.edate, l_azf03
             ,'','',''                                            #FUN-9A0050 Add
        END FOREACH
    END IF  #FUN-C80092 add
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,ima08,sfb01,ima57,ima01')
            RETURNING tm.wc
    END IF
    #LET g_str = tm.wc,";",tm.a,";",tm.type,";",g_azi03,";",g_ccz.ccz27 #MOD-960193 add azi03 #MOD-960283 add czz27 #CHI-C30012
    LET g_str = tm.wc,";",tm.a,";",tm.type,";",g_ccz.ccz26,";",g_ccz.ccz27 #CHI-C30012
    IF tm.type MATCHES '[12]' THEN
       IF g_aza.aza63 = 'Y' THEN
          LET l_name = 'axcr772_3'
       ELSE
     	    LET l_name = 'axcr772_1'
       END IF	     
       CALL cl_prt_cs3('axcr772',l_name,g_sql,g_str)               #FUN-9A0050 Add    
    END IF
    IF tm.type MATCHES '[345]' THEN
       IF g_aza.aza63 = 'Y' THEN
          LET l_name = 'axcr772_2'
       ELSE
     	    LET l_name = 'axcr772'
       END IF	     
    CALL cl_prt_cs3('axcr772',l_name,g_sql,g_str)             #FUN-9A0050 Add    
    END IF
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
